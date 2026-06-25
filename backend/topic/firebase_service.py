import firebase_admin
from firebase_admin import credentials, firestore
from topic.data.topic_data import topics

db = firestore.client()

def upload_topics_to_firebase():
    batch = db.batch()  

    for topic in topics:
        doc_ref = db.collection('topics').document(str(topic['id']))
        batch.set(doc_ref, topic)

    # Commit batch
    batch.commit()
    print(f"Đã upload {len(topic)} các topic lên Firebase!")