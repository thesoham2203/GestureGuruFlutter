
# 📱 GestureGuru Flutter App

**GestureGuru** is an inclusive mobile application that enables users to **learn and translate American Sign Language (ASL)** in real-time. This Flutter-based frontend interacts with a FastAPI-powered backend to provide accurate gesture recognition using machine learning.

> 🔗 [Backend GitHub Repository](https://github.com/yourusername/gestureguru-python)  
> 🧠 Powered by ONNX/TF models + FastAPI + Flutter

---

## 🚀 Features

- 🎓 **Learn Mode** – Watch ISLRTC-approved videos to learn ASL.
- 🤳 **Translate Mode** – Live gesture recognition using device camera.
- 🧠 **Auto-suggest** – Suggests nearest-matched words for better accuracy.
- 🧪 **Quiz/Test Mode** *(Coming Soon)* – Practice through quizzes and accuracy testing.

---

## 🛠️ Tech Stack

| Layer        | Technology            |
|--------------|------------------------|
| Frontend     | Flutter (Dart)         |
| Camera       | `camera`, `image_picker` |
| HTTP Requests| `http` package         |
| Video Launch | `url_launcher`         |

---

## 📁 Folder Structure

```

gestureguru-flutter/
├── lib/
│   ├── main.dart                # App entry point
│   ├── screens/                 # UI screens (Learn, Translate, etc.)
│   ├── services/                # FastAPI communication
│   ├── models/                  # Prediction model
│   ├── widgets/                 # Reusable UI components
│   └── utils/                   # Constants, helpers
├── assets/                      # Icons, images
├── pubspec.yaml                 # Dependencies
└── README.md

````

---

## 📦 Dependencies

Your `pubspec.yaml` should include:

```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^0.14.0
  camera: ^0.10.5+3
  path_provider: ^2.1.2
  image_picker: ^1.0.4
  flutter_spinkit: ^5.1.0
  url_launcher: ^6.2.5
````

Install them with:

```bash
flutter pub get
```

---

## ⚙️ Setup Instructions

### 1. Clone the Repo

```bash
git clone https://github.com/yourusername/gestureguru-flutter.git
cd gestureguru-flutter
```

### 2. Run the App

```bash
flutter pub get
flutter run
```

> ✅ Works with both Android and iOS. Use a real device for better camera testing.

---


## 📹 Translate Mode Flow

1. Launch Camera.
2. Frame captured every few seconds.
3. Frame is sent via POST request to backend `/predict`.
4. Prediction + confidence score displayed on screen.

---

## 🎓 Learn Mode

* Loads ASL videos from official ISLRTC YouTube playlist.
* Categories: Alphabets, Common Words, Greetings, etc.
* User can browse and mark videos as learned.

---

## 🧪 Quiz Mode *(Upcoming)*

* Choose category or random mode.
* Multiple choice or camera-based quiz.
* Score and feedback shown.

---

## 🚧 To-Do / Roadmap

* [ ] Gamification – XP, badges, ranks.
* [ ] Offline mode with on-device ML model.
* [ ] Voice & Text output for predicted signs.
* [ ] Feedback and accessibility settings.

---

## 🤝 Contributing

Pull requests are welcome! Please fork the repo and create a branch for your feature/fix.

---

## 👨‍💻 Author

**Soham**, Final Year AI & DS Student
✨ Developed under the Project-Based Learning module.

```


