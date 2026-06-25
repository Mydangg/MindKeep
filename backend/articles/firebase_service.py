import firebase_admin
from firebase_admin import credentials, firestore
from articles.data.articles_data import articles 

db = firestore.client()

def upload_articles_to_firebase():
    batch = db.batch()  

    for article in articles:
        doc_ref = db.collection('articles').document(str(article['id']))
        batch.set(doc_ref, article)

    # Commit batch
    batch.commit()
    print(f"Đã upload {len(articles)} bài viết lên Firebase!")
