from django.shortcuts import render
from rest_framework import viewsets, status
from rest_framework.response import Response
from firebase_admin import firestore
from permission.authentication import FirebaseAuthentication
from backend.utils.firestore_utils import serialize_doc
from datetime import datetime
from predict.views import PredictAIViewSet
from user_auth.views import UserViewSet
from rest_framework.permissions import IsAuthenticated

db = firestore.client()

# Create your views here.
class PsychTestViewSet(viewsets.GenericViewSet,viewsets.ViewSet):
    authentication_classes = [FirebaseAuthentication]
    permission_classes = [IsAuthenticated] 

    def interpret_overall(self, prediction_id, dass_result):
        predict_ai = PredictAIViewSet()
        emotion = predict_ai.get_final_emotion(prediction_id)

        if not emotion:
            raise ValueError("Không tìm thấy thông tin cảm xúc")

        depression_level = dass_result["depression"]["level"]
        stress_level = dass_result["stress"]["level"]
        anxiety_level = dass_result["anxiety"]["level"]

        default_action_plan = [
            "Dành 10-15 phút mỗi ngày để hít thở sâu hoặc đi bộ nhẹ.",
            "Ngủ đủ giấc và hạn chế sử dụng điện thoại trước khi ngủ.",
            "Ghi lại cảm xúc trong ngày để nhận biết điều gì đang làm bạn áp lực.",
            "Chia sẻ với người thân hoặc bạn bè khi cảm thấy quá tải.",
            "Thực hiện lại bài đánh giá sau 7 ngày để theo dõi sự thay đổi.",
        ]

        expert_rules = [
            {
                "name": "Nguy cơ trầm cảm",
                "conditions": {
                    "emotion": ["Buồn"],
                    "depression": ["Vừa", "Nặng", "Rất nặng"]
                },
                "priority": 3,
                "conclusion": "Bạn có thể đang trải qua một giai đoạn cảm xúc khá nặng nề.",
                "reason": "Cảm xúc buồn kết hợp với mức Depression trên DASS-21 từ vừa trở lên cho thấy bạn nên quan tâm nhiều hơn đến trạng thái tinh thần hiện tại.",
                "positive_feedback": "Việc bạn hoàn thành bài đánh giá đã là một bước rất tích cực để hiểu bản thân và tìm kiếm sự hỗ trợ phù hợp.",
                "recommendation": "Hãy cho bản thân thời gian nghỉ ngơi, tránh tự trách mình và chia sẻ với người thân hoặc chuyên gia nếu cảm giác buồn kéo dài.",
                "action_plan": [
                    "Tâm sự với một người bạn tin tưởng hoặc người thân trong hôm nay.",
                    "Dành thời gian nghỉ ngơi, ăn uống đầy đủ và ngủ đúng giờ.",
                    "Viết ra 3 điều nhỏ khiến bạn cảm thấy dễ chịu hơn trong ngày.",
                    "Nếu cảm giác buồn kéo dài hoặc có ý nghĩ làm hại bản thân, hãy liên hệ người thân hoặc chuyên gia ngay.",
                ],
            },
            {
                "name": "Nguy cơ căng thẳng cao",
                "conditions": {
                    "emotion": ["Tức giận"],
                    "stress": ["Nặng", "Rất nặng"]
                },
                "priority": 2,
                "conclusion": "Bạn có thể đang chịu áp lực khá lớn trong thời gian gần đây.",
                "reason": "Cảm xúc tức giận xuất hiện cùng với điểm Stress cao cho thấy cơ thể và tinh thần đang phản ứng mạnh với áp lực.",
                "positive_feedback": "Điểm tích cực là bạn đã nhận diện được trạng thái của mình, đây là bước đầu quan trọng để điều chỉnh lại nhịp sống.",
                "recommendation": "Bạn nên tạm nghỉ, giảm bớt tác nhân gây áp lực và thực hiện các hoạt động giúp cơ thể thư giãn.",
                "action_plan": [
                    "Tạm dừng công việc 5-10 phút và hít thở chậm.",
                    "Giảm bớt một việc chưa thật sự cần thiết trong hôm nay.",
                    "Đi bộ nhẹ, nghe nhạc thư giãn hoặc uống một ly nước.",
                    "Nếu căng thẳng lặp lại nhiều ngày, hãy chia sẻ với người thân hoặc chuyên gia.",
                ],
            },
            {
                "name": "Nguy cơ lo âu",
                "conditions": {
                    "emotion": ["Lo lắng", "Ngạc nhiên"],
                    "anxiety": ["Nặng", "Rất nặng"]
                },
                "priority": 2,
                "conclusion": "Bạn có thể đang có nhiều lo lắng cần được quan tâm.",
                "reason": "Cảm xúc lo lắng hoặc ngạc nhiên kết hợp với mức Anxiety cao cho thấy bạn có thể đang cảm thấy bất an hoặc khó kiểm soát suy nghĩ.",
                "positive_feedback": "Bạn đã chủ động kiểm tra trạng thái của mình, điều này cho thấy bạn đang quan tâm và chăm sóc bản thân tốt hơn.",
                "recommendation": "Hãy ưu tiên các hoạt động giúp ổn định nhịp thở, giảm suy nghĩ quá mức và tìm kiếm sự đồng hành từ người tin cậy.",
                "action_plan": [
                    "Thử bài tập hít vào 4 giây, giữ 4 giây, thở ra 6 giây.",
                    "Viết ra điều khiến bạn lo lắng và điều bạn có thể làm ngay lúc này.",
                    "Hạn chế caffeine hoặc thức khuya nếu bạn đang dễ lo âu.",
                    "Trao đổi với người thân hoặc chuyên gia nếu cảm giác lo âu kéo dài.",
                ],
            },
            {
                "name": "Tâm lý ổn định",
                "conditions": {
                    "emotion": ["Vui vẻ"],
                    "stress": ["Bình thường"],
                    "anxiety": ["Bình thường"],
                    "depression": ["Bình thường"]
                },
                "priority": 1,
                "conclusion": "Trạng thái tâm lý hiện tại của bạn khá tích cực và ổn định.",
                "reason": "Cảm xúc tích cực kết hợp với các chỉ số DASS-21 ở mức bình thường cho thấy bạn đang duy trì trạng thái tinh thần tốt.",
                "positive_feedback": "Bạn đang có nền tảng cảm xúc tốt. Hãy tiếp tục duy trì những thói quen đang giúp bạn cảm thấy cân bằng.",
                "recommendation": "Tiếp tục ngủ đủ giấc, vận động nhẹ và duy trì kết nối với những người mang lại năng lượng tích cực cho bạn.",
                "action_plan": [
                    "Duy trì thói quen ngủ và thức dậy đúng giờ.",
                    "Vận động nhẹ ít nhất 15 phút mỗi ngày.",
                    "Ghi lại một điều tích cực bạn cảm nhận được trong ngày.",
                    "Tiếp tục kiểm tra định kỳ để theo dõi sức khỏe tinh thần.",
                ],
            },
        ]

        matched_rules = []

        for rule in expert_rules:
            conditions = rule["conditions"]
            match = True

            if "emotion" in conditions and emotion not in conditions["emotion"]:
                match = False

            if "stress" in conditions and stress_level not in conditions["stress"]:
                match = False

            if "anxiety" in conditions and anxiety_level not in conditions["anxiety"]:
                match = False

            if "depression" in conditions and depression_level not in conditions["depression"]:
                match = False

            if match:
                matched_rules.append(rule)

        if matched_rules:
            selected_rule = sorted(
                matched_rules,
                key=lambda x: x["priority"],
                reverse=True
            )[0]

            return {
                "type": "expert_system",
                "rule_name": selected_rule["name"],
                "conclusion": selected_rule["conclusion"],
                "reason": selected_rule["reason"],
                "positive_feedback": selected_rule["positive_feedback"],
                "recommendation": selected_rule["recommendation"],
                "action_plan": selected_rule["action_plan"],
                "input_data": {
                    "emotion": emotion,
                    "stress": stress_level,
                    "anxiety": anxiety_level,
                    "depression": depression_level
                },
                "note": "Kết quả chỉ mang tính tham khảo, không thay thế chẩn đoán của chuyên gia."
            }

        return {
            "type": "expert_system",
            "rule_name": "Gợi ý chăm sóc bản thân",
            "conclusion": "Bạn đang duy trì cảm xúc tương đối tích cực, tuy nhiên một vài chỉ số vẫn cho thấy cơ thể và tinh thần có thể đang chịu áp lực.",
            "reason": "Dữ liệu cảm xúc và kết quả DASS-21 chưa khớp với các nhóm cảnh báo cao, nhưng vẫn có những dấu hiệu nên được theo dõi nhẹ nhàng.",
            "positive_feedback": "Điểm tích cực là bạn đã chủ động nhìn lại trạng thái của mình. Đây là bước quan trọng để chăm sóc sức khỏe tinh thần tốt hơn.",
            "recommendation": "Hãy tiếp tục quan sát cảm xúc, nghỉ ngơi hợp lý và tạo cho bản thân những khoảng thời gian thư giãn trong ngày.",
            "action_plan": default_action_plan,
            "input_data": {
                "emotion": emotion,
                "stress": stress_level,
                "anxiety": anxiety_level,
                "depression": depression_level
            },
            "note": "Kết quả chỉ mang tính tham khảo, không thay thế chẩn đoán của chuyên gia."
        }

    #return the results after taking the test
    def classify_dass21(self,score, prediction_id):
        levels = {
            "stress" : [(0,14, "Bình thường"), (15,18, "Nhẹ"), (19,25, "Vừa"), (26,33, "Nặng"), (34,999, "Rất nặng")],
            "anxiety" : [(0,7, "Bình thường"), (8,9, "Nhẹ"), (10,14, "Vừa"), (15,19, "Nặng"), (20,999, "Rất nặng")],
            "depression" : [(0,9, "Bình thường"), (10,13, "Nhẹ"), (14,20, "Vừa"), (21,27, "Nặng"), (28,999, "Rất nặng")]
        }

        result = {}
        for scale, value in score.items():
            for(low, high, label) in levels[scale]:
                if low <= value * 2 <= high:
                    result[scale] = {"score": value * 2, "level" : label}
                    break
        return self.interpret_overall(prediction_id, result)
    
    def retrieve(self, request, pk=None):
        try:
            # Get all test cases with prediction_id
            test_docs = list(db.collection('dass21_tests')
                            .where("prediction_id", "==", pk)
                            .stream())
            
            if not test_docs:
                return Response({"error": "Không tìm thấy bài test nào"}, status=status.HTTP_404_NOT_FOUND)
            
            # Get the first test (if there is only 1 prediction_id)
            test_doc = test_docs[0]
            test_data = serialize_doc(test_doc)
            
            # Get related answers
            ans_docs = list(db.collection('dass21_answers')
                                .where("test_id", "==", test_doc.id)
                                .stream())
            answers = [serialize_doc(a) for a in ans_docs]

            return Response({
                "test": test_data,
                "answers": answers
            }, status=status.HTTP_200_OK)

        except Exception as e:
            return Response({"error": str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
  

    def list(self, request):
        try:
            doc_ques = db.collection('psych_questions').stream()
            doc_ans = db.collection('psych_answers').stream()

            result_ques = []
            for question in doc_ques:
                result_ques.append(serialize_doc(question))

            result_ans = []
            for answer in doc_ans:
                result_ans.append(serialize_doc(answer))

            return Response({"questions": result_ques, "answers": result_ans}, status=status.HTTP_200_OK)
        except Exception as e:
            return Response({"error": str(e)},status=status.HTTP_500_INTERNAL_SERVER_ERROR)

    def create(self, request):
        user = request.user
        is_auth = UserViewSet()
        data = request.data
        user_id = user.uid
        prediction_id = data.get("prediction_id")
        answers = data.get("answers", [])

        user = is_auth.get_user_by_firebase(user_id)
        if isinstance(user, Response):
            return user 
        
        if not answers :
            return Response({"error": "Bạn chưa trả lời câu hỏi"}, status=status.HTTP_400_BAD_REQUEST)
    
        #Score for each group
        score = {"stress": 0, "anxiety": 0, "depression": 0}

        # Mapping questions for 3 groups
        stress_questions = [1, 6, 8, 11, 12, 14, 18]
        anxiety_questions = [2, 4, 7, 9, 15, 19, 20]
        depression_questions = [3, 5, 10, 13, 16, 17, 21]

        for ans in answers:
            qid = ans['question_id']
            val = ans['answer_value']
            if qid in stress_questions:
                score['stress'] += val
            elif qid in anxiety_questions:
                score['anxiety'] += val
            elif qid in depression_questions:
                score['depression'] += val

        # --- Save the total record to dass21_tests ---
        result_test = self.classify_dass21(score, prediction_id)

        test_data = {
            "user_id": user_id,
            "prediction_id": prediction_id,
            "stress_score": score['stress'],
            "anxiety_score": score['anxiety'],
            "depression_score": score['depression'],
            "result_test": result_test,
            "created_at": datetime.utcnow(),
            "updated_at": datetime.utcnow()
        }

        try:
            test_ref = db.collection("dass21_tests").add(test_data)
            test_id = test_ref[1].id

            #Save each answer to dass21_answers
            batch = db.batch()
            answers_ref = db.collection("dass21_answers")

            for ans in answers:
                doc_ref = answers_ref.document()
                batch.set(doc_ref, {
                    "test_id": test_id,
                    "question_id": ans["question_id"],
                    "answer_value": ans["answer_value"],
                    "created_at": datetime.utcnow()
                })
            #Commit batch only once
            batch.commit()

            # result_test = self.classify_dass21(score,prediction_id)

            return Response({
                "test_id": test_id,
                "score": score,
                "result_test": result_test,
            }, status=status.HTTP_201_CREATED)

        except Exception as e:
            return Response({"error": str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
        
    def destroy(self, request, pk=None):
        try:
            predict_ai = PredictAIViewSet()

            prediction_deleted = predict_ai.destroy_prediction(pk)

            if not prediction_deleted:
                    return Response({"error": "Không thể xoá hoặc không tìm thấy prediction."},
                            status=status.HTTP_404_NOT_FOUND)
            
            test_docs = list(db.collection('dass21_tests')
                            .where("prediction_id", "==", pk)
                            .stream())

            if len(test_docs) == 0:
                return Response({"message": "Bài kiểm tra không tồn tại"}, status=status.HTTP_404_NOT_FOUND)

            total_answers = 0

            for test in test_docs:
                test.reference.update({
                    "is_deleted": True,
                    "updated_at": firestore.SERVER_TIMESTAMP
                })

                #get related questions
                ans_docs = list(db.collection('dass21_answers')
                                    .where("test_id", "==", test.id)
                                    .stream())

                total_answers += len(ans_docs)

                for ans in ans_docs:
                    ans.reference.update({
                        "is_deleted": True,
                        "updated_at": firestore.SERVER_TIMESTAMP
                    })
            return Response({"message": "Xoá thành công"}, status=status.HTTP_200_OK)

        except Exception as e:
            return Response({"error": str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)


        


