# 🧠 Mental Health Partner App

<div align="center">

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Django](https://img.shields.io/badge/Django-092E20?style=for-the-badge&logo=django&logoColor=white)](https://djangoproject.com)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](https://opensource.org/licenses/MIT)

*A comprehensive Flutter application designed to support mental health through mood tracking, journaling, community support, and gamification.*

[Features](#-features) • [Getting Started](#-getting-started) • [Screenshots](#-screenshots) • [Contributing](#-contributing)

</div>

---

## ✨ Features

### 📱 Frontend (Flutter)
- **🔐 Authentication** - Secure login and registration system
- **📊 Mood Tracking** - Record and analyze mood patterns over time
- **📝 Journaling** - Create and manage personal journal entries
- **👥 Community** - Join discussion groups and participate in challenges
- **🎮 Gamification** - Complete quests and earn rewards for engagement
- **📈 Analytics** - View personalized insights into your mental health journey

### ⚙️ Backend (Django REST Framework)
- **👤 User Management** - Secure authentication with email verification
- **💬 Community Features** - Discussion forums with robust moderation
- **🤖 AI Chat** - AI-assisted conversations with built-in safety checks
- **🏆 Achievement System** - Badges, quests, and progress tracking
- **📋 Data Management** - Secure storage for journals and mood data
- **🔌 RESTful APIs** - Clean, documented endpoints for frontend integration

---

## 🚀 Getting Started

### Prerequisites

Before you begin, ensure you have the following installed:

- **Flutter SDK** `>= 3.0.0` ([Install Flutter](https://docs.flutter.dev/get-started/install))
- **Dart SDK** `>= 2.17.0` (included with Flutter)
- **Android Studio** or **Xcode** (for mobile development)
- **VS Code** (recommended IDE with Flutter extensions)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/mental-health-partner.git
   cd mental-health-partner
   ```

2. **Install Flutter dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure environment variables**
   
   Create a `.env` file in the root directory:
   ```env
   API_BASE_URL=https://your-api-url.com
   ENCRYPTION_KEY=your_encryption_key_here
   ```

4. **Run the application**
   ```bash
   flutter run
   ```

### Backend Setup

For the Django backend setup, refer to the [backend documentation](./backend/README.md).

---

## 📁 Project Structure

```
lib/
├── 🔧 config/          # Configuration files and constants
├── 💎 core/            # Core utilities, extensions, and helpers
├── 📊 data/            # Data layer (repositories, API services)
├── 💉 di/              # Dependency injection setup
├── 🎯 domain/          # Business logic and use cases
└── 🎨 presentation/    # UI layer (screens, widgets, controllers)
    ├── pages/          # Screen implementations
    ├── widgets/        # Reusable UI components
    └── controllers/    # State management
```

---

## 📸 Screenshots

<div align="center">

| Home Screen | Mood Tracking | Journal Entry |
|-------------|---------------|---------------|
| ![Home](screenshots/home.png) | ![Mood](screenshots/mood.png) | ![Journal](screenshots/journal.png) |

| Community | Analytics | Gamification |
|-----------|-----------|--------------|
| ![Community](screenshots/community.png) | ![Analytics](screenshots/analytics.png) | ![Games](screenshots/games.png) |

</div>

---

## 🛠️ Development

### Code Style
This project follows Flutter's official style guide. Run the following commands to maintain code quality:

```bash
# Format code
flutter format .

# Analyze code
flutter analyze

# Run tests
flutter test
```

### Building for Production

```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release
```

---

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guidelines](CONTRIBUTING.md) for details.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

## 📋 Roadmap

- [ ] **Dark mode** support
- [ ] **Offline functionality** for core features
- [ ] **Data export** capabilities
- [ ] **Multiple language** support
- [ ] **Wearable device** integration
- [ ] **Advanced analytics** with ML insights

---

## 🆘 Support

If you encounter any issues or have questions:

- 📧 **Email**: support@mentalhealthpartner.com
- 🐛 **Bug Reports**: [GitHub Issues](https://github.com/yourusername/mental-health-partner/issues)
- 💬 **Discussions**: [GitHub Discussions](https://github.com/yourusername/mental-health-partner/discussions)

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

<div align="center">

**Made with ❤️ for mental health awareness**

⭐ Star this repository if it helped you!

</div>