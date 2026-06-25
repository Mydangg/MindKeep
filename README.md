# Application For Predicting Mental Illness.
- figman: [link](https://www.figma.com/design/rnajTb7CHIpTEPTuG3sO4w/DACN2?node-id=0-1&t=Z1anz722cIDgUIFn-1)

## Function
- Sign In, Sign Up, Logout
- Change profile, feedbacke app for creator
- Upload photos to predict initial mental health issues based on emotions, then take the DASS21 test to combine the results and provide final advice
- View articles, like and save articles (Like and save are data used in the user recommendation system)
- Chatbot with Geminai API 

## UI

<img src="https://github.com/user-attachments/assets/dbc1e804-a9a0-4c48-bbc9-22195b983da8" width="200"/> <img src="https://github.com/user-attachments/assets/e464375c-ffa2-4a77-9cfe-777065f4dfd9" width="200"/> <img src="https://github.com/user-attachments/assets/8ec929a3-e297-4ec9-ba48-547d7ac82507" width="200"/> 

## Technologies Used
- Visual studio code
- Dart (v3.7.0)
- Flutter (v3.29.0)
- DevTools (v2.42.2)
- Python (v2.10.8)
- Django (v5.2.7)

## Installation
- Database : firebase
- Create file config.json into assert of frontend and create file firebase_key.json inti backend

- Set up a virtual environment:
 ```bash
python -m venv venv
```
```bash
venv\Scripts\activate
```
```bash
pip install -r requirements.txt
```
-   Escape from the virtual environment
   ```bash
  deactivate
```
- Running for backend:
```bash
cd backend
```
```bash
python manage.py runserver
```
- Running for frontend
  - First: new Terminal
```bash
cd fronted
```
```bash
flutter run
```


