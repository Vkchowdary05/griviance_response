# 🏛️ Online Grievance Redressal System (Flutter + Supabase + Firebase)

A **complete Flutter-based Online Grievance Redressal System** built as a 3rd-year college project to showcase **Flutter development skills**, **backend integration**, and **real-world app features**.  

This app allows citizens to **report grievances**, track their status, and upvote existing reports. Officers can **manage grievances**, escalate issues, and monitor analytics. The system uses **AI validation (Google Gemini)** to prevent spam and ensure relevant submissions. It also supports **offline mode**, **push notifications**, and **accessibility features**, making it production-ready.

---

## 🎯 Project Description

In many civic setups, citizens struggle to report issues efficiently and track their resolutions. This project solves that problem by providing:

- A **mobile-friendly interface** for citizens to submit grievances quickly.
- **Role-based access control**, ensuring officers can only see relevant problems.
- **Realtime updates and notifications**, so users stay informed on the status of their submissions.
- **Analytics dashboards** for officers to monitor trends, department workloads, and performance.
- **AI-powered spam detection**, ensuring only meaningful complaints are processed.
- A **modular, scalable architecture** using Flutter, Bloc, Supabase, and Firebase.

The project is ideal for showcasing **Flutter expertise**, **state management**, and **full-stack mobile development skills** to potential employers or for academic evaluation.

---

## 🎯 Features

### 👨‍👩‍👦 Citizens
- Register/login via **Firebase Authentication**
- Submit grievances with:
  - Auto location detection
  - Department selection
  - Description & optional image
- Track grievance status in a **timeline**
- Upvote existing grievances
- Receive **push notifications** on updates

### 🧑‍💼 Officers
- Role-based login and access
- View assigned grievances
- Resolve, update, or escalate grievances
- Monitor department performance with **analytics dashboard**

### 🌟 Extra Features
- **AI validation (Google Gemini)** → prevent spam & irrelevant submissions
- **Supabase backend** with relational tables: users, grievances, departments, status history
- **Offline mode** with local caching
- **Push notifications** via FCM
- **Accessibility support** (screen reader, text scaling)
- **Production-ready clean architecture** for easy scalability

---

## 🛠️ Tech Stack
- **Frontend:** Flutter, Bloc, Provider
- **Backend:** Supabase (PostgreSQL)
- **Authentication:** Firebase (Email/Password)
- **AI Validation:** Google Gemini API
- **Push Notifications:** Firebase Cloud Messaging
- **Database Schema:** Departments, Grievances, Users, Roles, Status History

---

## 📂 Folder Structure
citizen_connect/
├── lib/
│ ├── core/
│ ├── features/
│ │ ├── auth/
│ │ ├── grievance/
│ │ ├── officer/
│ │ └── common/
│ ├── services/
│ └── main.dart
├── android/
├── ios/
├── pubspec.yaml
└── README.md

---

## ⚙️ Setup Instructions

### 🔑 Firebase Authentication
1. Create a Firebase project → enable **Email/Password** login.
2. Download `google-services.json` (Android) & `GoogleService-Info.plist` (iOS).
3. Add them to your Flutter project under `android/app` and `ios/Runner`.

### 🗄️ Supabase
1. Create a Supabase project at [https://supabase.com](https://supabase.com).
2. Run SQL schema to create relational tables: `users`, `departments`, `grievances`, `status_history`.
3. Map Firebase `uid` to Supabase `users` for role-based access.

### 📦 Run the Project
```bash
flutter pub get
flutter run


---

## 📸 Screenshots (Generated)

Here are **2 mock UI screenshots** for your project:

### Login Screen  
<img width="1024" height="1536" alt="image" src="https://github.com/user-attachments/assets/33977c3a-766b-4666-bafb-ac8d5c725202" />
(sandbox:/mnt/data/grievance_login.png)  

### Submit Grievance Screen  
![Submit Screen](sandbox:/mnt/data/grievance_submit.png)  

---

