# 📝 Flutter To-Do App

A simple, fully-featured **To-Do list application** built with **Flutter**, using **GetX** for state management, and **Firebase** for backend services. The app is responsive, reactive, and allows users to manage their daily tasks efficiently.

---

## 🚀 Features

- 🔐 **User Authentication** via Firebase
- ☁️ **Cloud Firestore** for storing and syncing tasks
- 💾 **Shared Preferences** for local user data caching
- ⚙️ **GetX State Management** for fast and reactive UI
- ✅ Create, update, complete, and delete tasks
- 📂 **Three-task tabs**: 
  - `Home`: Active To-Do List
  - `Add`: Tab to Create New Tasks
  - `Completed`: Finished Tasks

---

## 🔄 App Flow

1. **Login / Sign Up** with Firebase Authentication.
2. **Create Tasks** using a simple input interface.
3. Tasks are listed under the **Home tab**.
4. Once a task is **marked as completed**, it moves to the **Completed tab**.
5. Tasks can also be **updated** or **deleted** at any time.

---

## 🧰 Tech Stack

- **Flutter** (UI Framework)
- **Dart** (Programming Language)
- **GetX** (State Management, Routing, Dependency Injection)
- **Firebase**:
  - Authentication
  - Firestore (NoSQL Database)
- **Shared Preferences** (Local Storage)

---

## 📸 Screenshots

<img width="228" height="506" alt="image" src="https://github.com/user-attachments/assets/63950cd2-14f2-4a9d-acef-1d67d9e25f07" />
<img width="227" height="507" alt="image" src="https://github.com/user-attachments/assets/f2ef14ee-6b1d-43eb-88cf-657b10c264c4" />
<img width="227" height="505" alt="image" src="https://github.com/user-attachments/assets/11c0cfe5-7398-4ebd-adca-5b1b89e4c28b" />
<img width="229" height="505" alt="image" src="https://github.com/user-attachments/assets/cfd697a1-9205-409e-97d0-7e3cfadda05c" />
<img width="226" height="507" alt="image" src="https://github.com/user-attachments/assets/86a0d3ca-6a4f-47a9-b61a-0cf18b1876c8" />




-

## 🛠 Setup Instructions

1. **Clone the repo**
   ```bash
   git clone https://github.com/your-username/flutter-todo-app.git
   cd flutter-todo-app
Install dependencies

bash
Copy code
flutter pub get
Set up Firebase

Create a Firebase project

Enable Email/Password Authentication

Create a Firestore database

Download and place your google-services.json in android/app/

For iOS, add GoogleService-Info.plist to ios/Runner/

Run the app

bash
Copy code
flutter run


📌 Notes

The app is fully reactive using GetX — any change in data automatically updates the UI.

Shared Preferences are used to store basic user info like username and email for quick access.

Firebase handles all backend functionality, including user management and real-time data sync.

🧑‍💻 Author

Made with ❤️ using Flutter & Firebase.

📄 License

This project is licensed under the MIT License - see the LICENSE file for details.
