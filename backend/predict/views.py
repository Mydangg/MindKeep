from rest_framework import viewsets, status
from rest_framework.decorators import action
from permission.authentication import FirebaseAuthentication
from .serializers import PredictSerializers
from rest_framework.response import Response
from firebase_admin import firestore
import numpy as np
import cv2
import traceback
import mediapipe as mp
import tensorflow as tf
from datetime import datetime
from collections import defaultdict
from backend.utils.firestore_utils import serialize_doc
from user_auth.views import UserViewSet
from rest_framework.permissions import IsAuthenticated

db = firestore.client()

# Load model


import keras

emotion_model = keras.models.load_model(
    'predict/ml/fer2013_cnn_improved.h5',
    compile=False
)
emotion_labels = ['Tức giận', 'Lo lắng','Vui vẻ','Bình thường', 'Buồn', 'Ngạc nhiên']

mp_face_detection = mp.solutions.face_detection

class PredictAIViewSet(viewsets.GenericViewSet,viewsets.ViewSet):
    authentication_classes = [FirebaseAuthentication]
    permission_classes = [IsAuthenticated]

    def get_final_emotion(self, prediction_id):
        try:
            doc_snapshot = db.collection('predictions').document(prediction_id).get()
            if doc_snapshot.exists:
                return doc_snapshot.get('final_emotion')
            return None
        except Exception as e:
            traceback.print_exc()
            return Response({"error": str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

    def save_face_emotions(self, email, user_id, emotions_data):
        try:
            print('')
            emotion_weight = defaultdict(float)
            for e in emotions_data:
                emotion_weight[e['emotion']] += e['confidence_score']

            #Get the label with the highest total confidence
            final_emotion = max(emotion_weight, key=emotion_weight.get) if emotion_weight else "unknown"
            
            predict_info = {
                "user_id": user_id,
                "email": email,
                "emotions": emotions_data,  
                "final_emotion": final_emotion,
                "created_at": datetime.utcnow(),
                "updated_at": datetime.utcnow(),
            }

            doc_ref = db.collection("predictions").document()  
            doc_ref.set(predict_info)
        
            return {
            "id": doc_ref.id,
            "user_id": user_id,
            "email": email,
            "emotions": emotions_data,
            "final_emotion": final_emotion,
            "created_at": datetime.utcnow(),
        }

        except Exception as e:
            # ném lỗi lên action xử lý
            raise e

    @action(detail=False, methods=['post'])
    def upload_faces(self, request):
        user = request.user
                #Save Firestore
        try:
            serializer = PredictSerializers(data=request.data)
            if not serializer.is_valid():
                return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

            data = serializer.validated_data
            email = data['email']
            user_id = data['user_id']
            images = data['images']

            exists  = UserViewSet().check_user_exists(email)
            if not exists:
                return Response({"error": "Người dùng không tồn tại"}, status=status.HTTP_400_BAD_REQUEST)

            emotions_data = []
            face_inputs = []
            mp_face_detection_instance = mp.solutions.face_detection.FaceDetection(
                model_selection=0, min_detection_confidence=0.5
            )

            for idx, img in enumerate(images):
                image_bytes = np.frombuffer(img.read(), np.uint8)
                frame = cv2.imdecode(image_bytes, cv2.IMREAD_COLOR)
                if frame is None:
                    return Response({'error': f'Hình ảnh không hợp lệ tại ảnh {idx}'}, status=400)

                rgb_frame = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
                face_results = mp_face_detection_instance.process(rgb_frame)

                if not face_results.detections:
                    emotions_data.append({
                        "image_order": idx + 1,
                        "emotion": "no_face",
                        "confidence_score": 0.0
                    })
                    continue

                detection = face_results.detections[0]
                bboxC = detection.location_data.relative_bounding_box
                ih, iw, _ = frame.shape
                x1 = int(bboxC.xmin * iw)
                y1 = int(bboxC.ymin * ih)
                w = int(bboxC.width * iw)
                h = int(bboxC.height * ih)
                x1, y1, x2, y2 = max(0, x1), max(0, y1), min(iw, x1 + w), min(ih, y1 + h)
                face_crop = frame[y1:y2, x1:x2]

                if face_crop.shape[0] < 10 or face_crop.shape[1] < 10:
                    emotions_data.append({
                        "image_order": idx + 1,
                        "emotion": "face_too_small",
                        "confidence_score": 0.0
                    })
                    continue

                # Prepare face_input for model
                face_gray = cv2.cvtColor(face_crop, cv2.COLOR_BGR2GRAY)
                face_resized = cv2.resize(face_gray, (48, 48))
                face_input = face_resized.astype("float32") / 255.0
                face_input = np.expand_dims(face_input, axis=(0, -1))
                face_inputs.append(face_input)

            if not face_inputs:
                return Response({'error': 'Không phát hiện thấy khuôn mặt nào hợp lệ'}, status=status.HTTP_400_BAD_REQUEST)

            face_inputs = np.vstack(face_inputs)  # (N,48,48,1)
            emotion_preds = emotion_model.predict(face_inputs, verbose=0)

            # Build emotions_data
            for i, e in enumerate(emotion_preds):
                emotion_index = np.argmax(e)
                emotion_label = emotion_labels[emotion_index]
                confidence_score = float(e[emotion_index])

                emotions_data.append({
                    "image_order": i + 1,
                    "emotion": emotion_label,
                    "confidence_score": confidence_score
                })

            result = self.save_face_emotions(email, user_id, emotions_data)
            return Response({"results": result}, status=status.HTTP_200_OK)
        except Exception as e:
            return Response({"error": str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
    
    def retrieve(self, request, pk=None):
        try:
            doc_ref = db.collection('predictions').document(pk).get()
            if not doc_ref.exists:
                return Response({"error": "Dữ liệu không có"}, status=status.HTTP_400_BAD_REQUEST)
            
            return  Response({"result" : serialize_doc(doc_ref)}, status=status.HTTP_200_OK) 
        except Exception as e:
            traceback.print_exc()
            return Response({"error": str(e)},status=status.HTTP_500_INTERNAL_SERVER_ERROR)

    
    def list(self, request):
        user = request.user
        try:
            col_ref = db.collection('predictions')
            docs = col_ref.where('user_id', '==', user.uid)\
            .order_by('created_at', direction=firestore.Query.ASCENDING)\
            .stream()

            results = [serialize_doc(doc) for doc in docs]

            return Response({"count": len(results), "result": results}, status=status.HTTP_200_OK)

        except Exception as e:
            traceback.print_exc()
            return Response({"error": str(e)},status=status.HTTP_500_INTERNAL_SERVER_ERROR)

    def destroy_prediction(self, pk):
        if not pk:
            return False

        try:
            # soft delete prediction
            doc_pred = db.collection('predictions').document(pk)
            if not doc_pred.get().exists:
                return Response({"error": "Kết quả dự đoán ban đầu không tồn tại"}, status=status.HTTP_404_NOT_FOUND)

            doc_pred.update({
                "is_deleted": True,
                "updated_at": firestore.SERVER_TIMESTAMP
            })
            return True
        except Exception as e:
            traceback.print_exc()
            return False


