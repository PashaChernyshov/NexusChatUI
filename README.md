# NexusChatUI — Messenger Interface

> 🇷🇺 Русская версия ниже • English version below

---

## 🇬🇧 English

### Overview
**NexusChatUI** is the **frontend** (UI only) of a corporate messenger built with **Flutter**.  
It currently serves as a visual shell for future backend integration and is under **active development**.

The purpose of this project is to design a clean, modern, and intuitive chat interface that will later support real-time communication once connected to a backend server.

### Status
🚧 **Work in progress** — This repository contains only the UI layer. Backend logic, database integration, and real-time messaging will be implemented in future updates.

### Current Features
- **Chat list screen** — displays contacts with avatars, names, and last messages
- **Conversation screen** — shows chat history and a text input bar
- **Dark theme** with accent colors
- **Responsive design** — adapts to desktop, tablet, and mobile devices
- **Custom theming** to match corporate identity

### Planned Features
- Real-time messaging via WebSocket or REST API
- Authentication & user profiles
- File sharing & attachments
- Push notifications

### Tech Stack
- **Flutter** — cross-platform framework
- **Dart** — programming language
- Material Design — consistent UI components
- Adaptive layout widgets

### Installation
```bash
# Clone repository
git clone <your-repo-url>.git
cd NexusChatUI

# Get Flutter dependencies
flutter pub get

# Run the project (choose your platform)
flutter run -d chrome   # Web
flutter run -d windows  # Windows
flutter run -d android  # Android
```

### Contributing
Since the project is in the early stages, contributions are welcome.  
You can open issues, suggest UI improvements, or submit pull requests.

---

## 🇷🇺 Русская версия

### Описание
**NexusChatUI** — это **фронтенд** (только интерфейс) корпоративного мессенджера, разработанный с использованием **Flutter**.  
На данный момент это визуальная оболочка для будущей интеграции с серверной частью и находится в стадии **активной разработки**.

Цель проекта — создать чистый, современный и удобный интерфейс чата, который в дальнейшем будет поддерживать обмен сообщениями в реальном времени после подключения к бэкенду.

### Статус
🚧 **Проект в разработке** — В текущей версии есть только интерфейс. Логика бэкенда, база данных и обмен сообщениями будут добавлены позже.

### Текущие возможности
- **Экран списка чатов** — показывает контакты с аватарками, именами и последними сообщениями
- **Экран переписки** — история сообщений и панель ввода текста
- **Тёмная тема** с акцентными цветами
- **Адаптивный дизайн** — корректно отображается на ПК, планшетах и телефонах
- **Кастомная цветовая схема** под корпоративный стиль

### Планируемые возможности
- Обмен сообщениями в реальном времени через WebSocket или REST API
- Авторизация и профили пользователей
- Отправка файлов и вложений
- Push-уведомления

### Стек технологий
- **Flutter** — кроссплатформенный фреймворк
- **Dart** — язык программирования
- Material Design — единый стиль UI-компонентов
- Виджеты адаптивной верстки

### Установка
```bash
# Клонировать репозиторий
git clone <your-repo-url>.git
cd NexusChatUI

# Установить зависимости Flutter
flutter pub get

# Запустить проект (выберите платформу)
flutter run -d chrome   # Web
flutter run -d windows  # Windows
flutter run -d android  # Android
```

### Как помочь проекту
Так как проект находится на раннем этапе, приветствуется любая помощь.  
Вы можете создавать задачи, предлагать улучшения UI или отправлять pull request’ы.
