# Boton - Concrete Lab Management

Monorepo containing frontend (Flutter) and backend (Django) for concrete lab management.

## Structure

```
boton/
├── frontend/       # Flutter mobile/desktop app
│   ├── lib/        # Dart source code
│   ├── assets/     # Fonts and assets
│   ├── android/
│   ├── ios/
│   ├── web/
│   ├── windows/
│   ├── linux/
│   └── macos/
├── backend/        # Django REST API
│   ├── core/       # Django project settings
│   ├── api/        # API app (models, views, serializers)
│   └── data/       # Data dumps
└── .gitignore
```

## Setup

### Backend
```bash
cd backend
pip install -r requirements.txt
python manage.py migrate
python manage.py runserver
```

### Frontend
```bash
cd frontend
flutter pub get
flutter run
```
