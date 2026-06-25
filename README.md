# MindKeep - Mental Health Support Application

MindKeep is a mobile application designed to support users in monitoring and improving their mental well-being through Artificial Intelligence, DASS-21 assessment, personalized recommendations, community interaction, and emergency support features.

## Figma Design

https://www.figma.com/design/rnajTb7CHIpTEPTuG3sO4w/DACN2?node-id=0-1&p=f&t=TduXwf84LUtYQyVR-0

---

# System Workflow

1. User signs up or logs into the application.
2. User uploads a facial image.
3. The facial emotion recognition model analyzes the image and predicts emotional states.
4. User completes the DASS-21 psychological assessment.
5. The system combines:
   * Emotion recognition results.
   * DASS-21 assessment results.
6. The system generates an initial mental health evaluation and provides recommendations.
7. Users can browse mental health articles and community posts.
8. Users can create and share posts with the community.
9. User interactions such as likes and saves are collected and used by the recommendation system.
10. Personalized articles and posts are recommended based on user interests.
11. Users can communicate with the Gemini-powered chatbot for mental health support.
12. In emergency situations, users can quickly contact trusted family members or emergency medical services (115).

---

# Features

## Authentication

* Sign In
* Sign Up
* Logout

## User Profile

* Update personal information
* Manage profile settings
* Submit feedback to application administrators
* Manage emergency contacts

## Mental Health Assessment

* Upload facial images
* Facial emotion recognition using AI
* Complete DASS-21 questionnaire
* * Combined evaluation based on facial emotion recognition and DASS-21 assessment
* Personalized recommendations and advice

## Community

* Create posts
* Share experiences and thoughts
* View community posts
* Like posts
* Comment on posts

## Articles

* Browse mental health articles
* Like articles
* Save articles for later reading

## Recommendation System

* Personalized article recommendations
* Personalized post recommendations
* Based on:

  * Likes
  * Saved content
  * User interaction history

## AI Chatbot

* Gemini API integration
* Mental health support conversations
* Answer user questions
* Provide guidance and suggestions

## Emergency Support

* Quick call to trusted family members
* Quick call to emergency medical service (115)
* Easily accessible from the support screen

---

# User Interface

<p align="center">
  <img src="frontend/assets/image/home.jpg" width="200"/>
  <img src="frontend/assets/image/face.png" width="200"/>
  <img src="frontend/assets/image/DASS-21.png" width="200"/>
</p>

<p align="center">
  <img src="frontend/assets/image/result.png" width="200"/>
  <img src="frontend/assets/image/article.png" width="200"/>
  <img src="frontend/assets/image/post.png" width="200"/>
</p>

<p align="center">
  <img src="frontend/assets/image/support.png" width="200"/>
</p>

---

# Technologies Used

## Frontend

* Flutter 3.29.0
* Dart 3.7.0
* Visual Studio Code
* Flutter DevTools 2.42.2

## Backend

* Python 3.10.8
* Django 5.2.7

## Database

* Firebase Authentication
* Firebase Firestore
* Firebase Storage

## Artificial Intelligence

* CNN-based Facial Emotion Recognition
* DASS-21 Psychological Assessment
* Gemini API Chatbot
* Content-Based Recommendation System

---

# Installation

## Database Configuration

Create the following configuration files:

### Frontend

```text
frontend/assets/config.json
```

### Backend

```text
backend/firebase_key.json
```

---

## Backend Setup

Create a virtual environment:

```bash
python -m venv venv
```

Activate the virtual environment:

```bash
venv\Scripts\activate
```

Install dependencies:

```bash
pip install -r requirements.txt
```

Deactivate the virtual environment:

```bash
deactivate
```

Run the backend server:

```bash
cd backend
python manage.py runserver
```

---

## Frontend Setup

Open a new terminal:

```bash
cd frontend
```

```bash
flutter pub get
```

Run the Flutter application:

```bash
flutter run
```
---

# Authors

MindKeep was developed as a Mental Health Support and Recommendation System that combines Artificial Intelligence, DASS-21 assessment, personalized recommendations, community interaction, chatbot assistance, and emergency support to help users monitor and improve their mental well-being.
