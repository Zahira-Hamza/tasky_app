# 📋 Tasky — Flutter To-Do App

A clean, production-ready task management app built with Flutter. Tasky supports dark/light themes, high-priority tasks, profile customization, and persistent local storage — all following a polished Figma design.

---

## 📸 Screenshots

### 🌑 Dark Mode

| Splash | Onboarding | Home | New Task |
|--------|------------|------|----------|
| ![Splash Dark](screenshots/splash_dark.png) | ![Onboarding Dark](screenshots/onboarding_dark.png) | ![Home Dark](screenshots/home_dark.png) | ![New Task Dark](screenshots/new_task_dark.png) |

| To Do | Completed | Profile | User Details |
|-------|-----------|---------|--------------|
| ![To Do Dark](screenshots/todo_dark.png) | ![Completed Dark](screenshots/completed_dark.png) | ![Profile Dark](screenshots/profile_dark.png) | ![User Details Dark](screenshots/user_details_dark.png) |

### 🌕 Light Mode

| Splash | Onboarding | Home | New Task |
|--------|------------|------|----------|
| ![Splash Light](screenshots/splash_light.png) | ![Onboarding Light](screenshots/onboarding_light.png) | ![Home Light](screenshots/home_light.png) | ![New Task Light](screenshots/new_task_light.png) |

| To Do | Completed | Profile | User Details |
|-------|-----------|---------|--------------|
| ![To Do Light](screenshots/todo_light.png) | ![Completed Light](screenshots/completed_light.png) | ![Profile Light](screenshots/profile_light.png) | ![User Details Light](screenshots/user_details_light.png) |

---

## ✨ Features

- **Onboarding** — Enter your name and optionally pick a profile picture on first launch
- **Home Screen** — Greeting based on time of day, circular progress indicator, high-priority task card, and full task list
- **Add Task** — Task name, description, and a high-priority toggle
- **To Do Tab** — All incomplete tasks with complete/delete options via the `⋮` menu
- **Completed Tab** — All finished tasks; tap to undo completion or delete
- **Profile Screen** — View/edit name and motivation quote, toggle dark mode, log out
- **User Details Screen** — Edit username and motivation quote with persistent save
- **Dark / Light Theme** — Toggled from both the home screen icon and the profile screen; persisted across sessions
- **Profile Image** — Pick from gallery; saved locally and shown across home and profile screens
- **Logout & Data Isolation** — Sign out clears all tasks and user data so each new user starts completely fresh
- **Persistent Storage** — All tasks and preferences stored locally with Hive (no internet required)

---

## 🛠 Tech Stack

| Layer | Technology |
|-------|-----------|
| Framework | Flutter 3.x |
| State Management | flutter_bloc (Cubit) |
| Local Storage | Hive + hive_flutter |
| Dependency Injection | get_it |
| UI Scaling | flutter_screenutil |
| Fonts | Google Fonts (Poppins) |
| Image Picker | image_picker |
| ID Generation | uuid |
| Splash Screen | flutter_native_splash |

---

## 📁 Project Structure

```
lib/
├── core/
│   ├── di/
│   │   └── service_locator.dart       # GetIt dependency injection setup
│   └── theme/
│       ├── app_colors.dart            # Color constants
│       └── app_theme.dart             # Light & dark ThemeData
│
├── data/
│   ├── models/
│   │   ├── task_model.dart            # Hive task model
│   │   └── task_model.g.dart          # Generated Hive adapter
│   └── repositories/
│       ├── task_repository.dart       # CRUD operations for tasks
│       └── user_repository.dart       # User name, quote, image persistence
│
├── logic/
│   ├── task_cubit/
│   │   ├── task_cubit.dart            # Task CRUD state management
│   │   └── task_state.dart            # TaskInitial / TaskLoading / TaskLoaded / TaskError
│   └── theme_cubit/
│       └── theme_cubit.dart           # Dark/light toggle with persistence
│
├── ui/
│   ├── screens/
│   │   ├── splash_screen.dart         # Animated splash + routing
│   │   ├── onboarding_screen.dart     # First-launch name + photo setup
│   │   ├── root_screen.dart           # Bottom nav host (IndexedStack)
│   │   ├── home_screen.dart           # Dashboard with progress + task lists
│   │   ├── new_task_screen.dart       # Add task form
│   │   ├── todo_screen.dart           # All incomplete tasks
│   │   ├── completed_screen.dart      # All completed tasks
│   │   ├── profile_screen.dart        # Profile view + settings
│   │   └── user_details_screen.dart   # Edit name & motivation quote
│   └── widgets/
│       ├── task_tile.dart             # Reusable task card with checkbox + menu
│       └── profile_avatar.dart        # Reusable avatar with optional edit mode
│
└── main.dart                          # App entry point
```

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK `>=3.0.0`
- Dart SDK `>=3.0.0`
- Android Studio / VS Code with Flutter plugin

### Installation

```bash
# 1. Clone the repository
git clone https://github.com/your-username/tasky.git
cd tasky

# 2. Install dependencies
flutter pub get

# 3. Generate Hive adapters (already committed, only needed if you change models)
dart run build_runner build --delete-conflicting-outputs

# 4. Generate native splash screens
dart run flutter_native_splash:create --path=flutter_native_splash.yaml

# 5. Run the app
flutter run
```

---

## 💡 Native Splash Screen Setup

The project uses `flutter_native_splash` with pre-prepared assets for Android 12+.

```yaml
# flutter_native_splash.yaml
flutter_native_splash:
  color: "#F7F7F7"
  image: assets/images/tasky_logo.png
  color_dark: "#121212"
  image_dark: assets/images/tasky_logo.png
  android_12:
    image: assets/images/splash_android12_light.png
    color: "#F7F7F7"
    image_dark: assets/images/splash_android12_dark.png
    color_dark: "#121212"
```

Run after any change to splash assets:

```bash
dart run flutter_native_splash:create --path=flutter_native_splash.yaml
```

---

## 🎨 Design

The app is a pixel-accurate Flutter implementation of the **Tasky** Figma design. Both dark and light variants are fully supported. The design uses:

- **Primary color:** `#1DB954` (vibrant green)
- **Dark background:** `#111111`
- **Light background:** `#F2F2F2`
- **Font:** Poppins (via Google Fonts)
- **Responsive sizing:** `flutter_screenutil` with a 390×844 design base

---

## 🐛 Known Issues Fixed

| Issue | Fix |
|-------|-----|
| `HiveError: This object is currently not in a box` | `copyWith()` creates a new object not tracked by Hive. Replaced `task.save()` with `_box.put(task.id, task)` |
| Three-dot menu marking all tasks complete | State getter logic fixed; each task update targets only its own key |
| Completed tab showing nothing | Added dedicated `completedTasks` getter in `TaskState`; screen now uses it |
| Back arrow appearing on To Do / Completed tabs | Added `automaticallyImplyLeading: false` to both AppBars |
| Splash always dark regardless of saved theme | `loadTheme()` now runs before the delay; splash reads from `ThemeCubit` state |
| Previous user's tasks visible after logout | Logout now calls `deleteAllTasks()` on the tasks box, `clearTasks()` on the cubit, and resets theme before navigating |

---

## 👩‍💻 Author

**Zahira Hamza**

---

## 📄 License

This project is for educational and portfolio purposes.
