# KAMKAM — Application Flutter

**Kamerun Alerte Mentale** — Dispositif Intégré de Protection des Femmes au Cameroun.

> Frontend Flutter complet, architecture propre (MVC + Provider), base de données locale (Hive),
> routes fonctionnelles via `go_router`, design premium (style Apple) avec animations fluides.

## ✨ Fonctionnalités (Frontend)

- 🎨 **Onboarding** premium avec parallaxe
- 🔐 **Auth locale** (PIN secret) + mode discret KAMKAM Mama
- 🤖 **KAMKAM Care** — Chat IA Psychologue (simulé localement)
- ⚖️ **Mes Droits** — Chatbot juridique
- 🚨 **SOS / Alerte** — Triage avec score de danger
- 👥 **Réseau de confiance** — Contacts + mots de code
- 💬 **KAMKAM Espace** — Forum communautaire anonyme
- 🧘 **Module Hommes** — Gestion de la colère
- 📅 **Suivi post-crise** — J+1, J+3, J+7
- 📊 **Tableau de bord MINFEF**
- 🎭 **Mode discret** (calculatrice de couverture)
- 🌍 Multilingue (FR / EN / Fulfulde / Ewondo / Duala / Bamoun)

## 🚀 Démarrage

```bash
flutter pub get
flutter run
```

> Aucun backend requis. Toutes les données sont stockées localement avec **Hive**
> et **SharedPreferences**. Données de démo pré-chargées au premier lancement.

## 🏗️ Architecture

```
lib/
├── main.dart
├── models/        # Modèles Hive (User, Contact, Message, Alert, Post...)
├── screens/       # Écrans (≈ 20)
├── widgets/       # Composants réutilisables (premium UI)
├── services/      # Logique métier + persistence locale
├── routes/        # go_router (toutes les routes)
├── theme/         # Design system (couleurs, typo, animations)
└── utils/         # Helpers, constantes, i18n
```

## 🎨 Design System

- Palette : Violet profond `#4A148C`, Rose alerte `#E91E63`, Or `#FFB300`, Crème `#FAF7F2`
- Typo : **Playfair Display** (titres) + **Inter** (corps)
- Animations : `flutter_animate` (fade, slide, parallaxe, blur)
- Style inspiré iOS 17 — coins arrondis 24px, blur, ombres douces

---

© KAMKAM — Concours d'Innovation · MINFEF Cameroun
