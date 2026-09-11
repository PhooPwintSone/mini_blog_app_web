# Flutter Clean Architecture Blog App

A full-stack mobile blog application built to demonstrate advanced Flutter development, robust state management, and seamless backend integration. The project strictly adheres to **Clean Architecture** principles, ensuring the codebase is highly scalable, testable, and maintainable.

## 🚀 Features

* **Authentication:** Secure email and password login utilizing Supabase Auth.
* **Global Feed:** A dynamic home feed displaying blogs from all users.
* **Multi-Reaction System:** Interactive UI allowing users to react to posts (💖, 😂, 🥲, 🫨, 🤬) with precise database tracking.
* **User Profile Hub:** A dedicated feed for users to manage, edit, and delete their own authored content.
* **Offline Caching:** Local data storage for a smooth, uninterrupted user experience even on slow networks.
* **Granular Error Handling:** User-friendly UI feedback intercepting standard backend exceptions.

## 🛠️ Tech Stack

* **Frontend Framework:** Flutter
* **Architecture:** Clean Architecture (Domain, Data, Presentation layers)
* **State Management:** BLoC (Business Logic Component)
* **Backend & Database:** Supabase (PostgreSQL, Row Level Security)
* **Dependency Injection:** GetIt
* **Local Storage:** Hive
* **Functional Programming:** fpdart (for robust Either type error handling)

## 🏗️ Architecture Overview

The application is modularized into three core layers to separate concerns:
1. **Domain Layer:** Contains pure Dart code (Entities, Repository Interfaces, and UseCases) independent of any external libraries.
2. **Data Layer:** Manages API calls and local databases, utilizing Models (e.g., `BlogModel`, `ReactionModel`) that extend Domain Entities.
3. **Presentation Layer:** Houses the UI widgets and BLoC state managers, actively reacting to the data layer through Dependency Injection.

## ⚙️ Installation & Setup

1. Clone the repository:
   ```bash ```
     git clone [https://github.com/PhooPwintSone/mini_blog_app_web]( https://github.com/PhooPwintSone/mini_blog_app_web)<img width="637" height="977" alt="Screenshot 2026-09-11 161000" src="https://github.com/user-attachments/assets/7d6f32c3-0424-4d1a-83cb-a229b1cc1ebd" />
<img width="637" height="983" alt="Screenshot 2026-09-11 160952" src="https://github.com/user-attachments/assets/41e42d1e-efb2-42c5-84f9-81335c122bb2" />
<img width="637" height="985" alt="Screenshot 2026-09-11 160917" src="https://github.com/user-attachments/assets/ea0f0f31-c759-4d08-abf2-7990b51141d9" />

3. Navigate to the project directory and install dependencies:
   ``` flutter pub get ```
3.Set up your Supabase environment variables in a .env file or constants file (URL and Anon Key).
4.Run the app: ```flutter run ```
Developed by Phoo Pwint Sone
