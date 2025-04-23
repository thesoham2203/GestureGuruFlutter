# GestureGuru

GestureGuru is an innovative mobile application designed to bridge the communication gap between the deaf and hearing communities by providing a platform for learning and translating Indian Sign Language (ISL) and American Sign Language (ASL). The app allows users to learn sign language through interactive lessons, quizzes, and real-time gesture recognition.

## Features

- **Indian Sign Language Learning:** Learn ISL using official government videos and gamified quizzes.
- **ASL Recognition:** Real-time ASL sign translation using a FastAPI server and machine learning models.
- **Speech-to-Sign Language Conversion:** Convert spoken language to sign language using an avatar for visual translation.
- **Real-time Gesture Translation:** Live translation of ASL gestures into text for seamless communication with the deaf community.
- **Offline Functionality:** Fully offline app for users in areas with limited or no internet connectivity.
- **User Feedback & Testing:** Mechanisms for feedback and testing the accuracy of gestures and translations.

## Technologies

- **Frontend:** Flutter
- **Backend:** FastAPI
- **Machine Learning Libraries:** TensorFlow, Keras, OpenCV (for gesture recognition)
- **Translation:** Google Translate API (for text translation)
- **Databases:** SQLite (offline storage)
- **Languages Supported:** Indian Sign Language (ISL), American Sign Language (ASL), English

## Installation

### Prerequisites

Before setting up the project, make sure you have the following installed:

- Flutter SDK
- Python 3.x
- FastAPI
- Tesseract OCR (for text recognition)
- TensorFlow and other machine learning libraries

### Clone the Repository

```bash
git clone https://github.com/thesoham2203/GestureGuruFlutter.git
cd GestureGuruFlutter
