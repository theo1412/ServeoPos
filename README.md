
# ServeoPos

**ServeoPos** is a Flutter-based Point of Sale (POS) mobile application built with Firebase for user authentication and state management using Provider.

## 🔧 Features

- ✨ Clean sign-up / login UI
- 🔐 Firebase Email & Password Authentication
- 📦 State management with `provider`
- ⚙️ Firebase initialization and configuration
- 📱 Android support (iOS/web planned)

## 🚀 Getting Started

### 1. Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- Firebase project (already created at [console.firebase.google.com](https://console.firebase.google.com))
- Android Studio / VS Code
- Android emulator or real device

### 2. Clone the Project

```bash
git clone https://github.com/your-username/ServeoPos.git
cd ServeoPos
```

### 3. Install Dependencies

```bash
flutter pub get
```

### 4. Set Up Firebase

#### a. Firebase Configuration

- Register your Android app in Firebase with this package name:  
  `com.serveo.pos`
- Add your **SHA-1 debug certificate fingerprint** to Firebase settings.

#### b. Download `google-services.json`

- Place it in:
  ```
  android/app/google-services.json
  ```

#### c. Initialize Firebase

Make sure `firebase_options.dart` is generated using:

```bash
flutterfire configure
```

### 5. Enable Authentication

In Firebase Console:
- Go to **Authentication → Sign-in method**
- Enable **Email/Password**

### 6. Run the App

```bash
flutter run
```

---

## 🧪 Testing

- Use the registration form to sign up with an email and password.
- Check Firebase Console → Authentication → Users to confirm.

---

## 📁 Structure

```
lib/
│
├── models/              # Data models
├── providers/           # State management
├── screens/             # UI screens
├── services/            # Firebase interaction
├── firebase_options.dart # Firebase generated config
└── main.dart            # App entry point
```

---

## 📌 Notes

- If you see `[CONFIGURATION_NOT_FOUND]`, check that:
  - Firebase is correctly initialized.
  - `firebase_options.dart` is up-to-date.
  - The method `Email/Password` is enabled.
  - `google-services.json` is in the correct location.

---

## 🛠️ Tech Stack

- Flutter
- Firebase Authentication
- Provider (state management)

---

## 📄 License

MIT – feel free to use and modify.
