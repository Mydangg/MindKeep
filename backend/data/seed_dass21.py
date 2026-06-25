from firebase_admin import credentials, firestore
import firebase_admin

cred = credentials.Certificate("../firebase_key.json")

firebase_admin.initialize_app(cred)

db = firestore.client()

# question 
questions = [
    {"content": "Tôi thấy khó mà thoải mái được", "type": "stress", "order": 1},
    {"content": "Tôi bị khô miệng", "type": "anxiety", "order": 2},
    {"content": "Tôi dường như chẳng có chút cảm xúc tích cực nào", "type": "depression", "order": 3},
    {"content": "Tôi bị rối loạn nhịp thở (thở gấp, khó thở dù chẳng làm việc gì nặng)", "type": "anxiety", "order": 4},
    {"content": "Tôi thấy khó bắt tay vào công việc", "type": "depression", "order": 5},
    {"content": "Tôi có xu hướng phản ứng thái quá với mọi tình huống", "type": "stress", "order": 6},
    {"content": "Tôi bị ra mồ hôi (chẳng hạn như mồ hôi tay...)", "type": "anxiety", "order": 7},
    {"content": "Tôi thấy mình đang suy nghĩ quá nhiều", "type": "stress", "order": 8},
    {"content": "Tôi lo lắng về những tình huống có thể làm tôi hoảng sợ hoặc biến tôi thành trò cười", "type": "anxiety", "order": 9},
    {"content": "Tôi thấy mình chẳng có gì để mong đợi cả", "type": "depression", "order": 10},
    {"content": "Tôi thấy bản thân dễ bị kích động", "type": "stress", "order": 11},
    {"content": "Tôi thấy khó thư giãn được", "type": "stress", "order": 12},
    {"content": "Tôi cảm thấy chán nản, thất vọng", "type": "depression", "order": 13},
    {"content": "Tôi không chấp nhận được việc có cái gì đó xen vào cản trở việc tôi đang làm", "type": "stress", "order": 14},
    {"content": "Tôi thấy mình gần như hoảng loạn", "type": "anxiety", "order": 15},
    {"content": "Tôi không thấy hăng hái với bất kỳ việc gì nữa", "type": "depression", "order": 16},
    {"content": "Tôi cảm thấy mình chẳng đáng làm người", "type": "depression", "order": 17},
    {"content": "Tôi thấy mình khá dễ phật ý, tự ái", "type": "stress", "order": 18},
    {"content": "Tôi nghe thấy rõ tiếng nhịp tim dù chẳng làm việc gì cả (ví dụ, tiếng nhịp tim tăng, tiếng tim loạn nhịp)", "type": "anxiety", "order": 19},
    {"content": "Tôi hay sợ vô cớ", "type": "anxiety", "order": 20},
    {"content": "Tôi thấy cuộc sống vô nghĩa", "type": "depression", "order": 21},
]

batch = db.batch()
for i in questions:
    doc_ref = db.collection('psych_questions').document()
    batch.set(doc_ref, i)

batch.commit()
print("Question created successfully!")

#answers
answers = [
    {"text": "Không đúng với tôi chút nào cả", "score": 0, "order": 1},
    {"text": "Đúng với tôi một phần, hoặc thỉnh thoảng mới đúng", "score": 1, "order": 2},
    {"text": "Đúng với tôi phần nhiều, hoặc phần lớn thời gian là đúng", "score": 2, "order": 3},
    {"text": "Hoàn toàn đúng với tôi, hoặc hầu hết thời gian là đúng", "score": 3, "order": 4},
]

batch = db.batch()
for o in answers:
    doc_ref = db.collection("psych_answers").document()
    batch.set(doc_ref, o)

batch.commit()
print("Answer created successfully!")