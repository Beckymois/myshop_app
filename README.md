# 📖 Guide d'utilisation — MyShop App

---

## 👤 PARTIE 1 — Guide Utilisateur

### 1. Connexion

Au lancement de l'application, une page de connexion s'affiche.
Entrez vos identifiants puis appuyez sur *"Connexion"* pour accéder à l'application.

---

### 2. Navigation principale

L'application comporte *3 onglets* accessibles via la barre de navigation en bas de l'écran :

| Icône | Onglet | Description |
|-------|--------|-------------|
| 🏠 | *Accueil* | Page de présentation de la boutique |
| 🛍️ | *Catalogue* | Liste de tous les produits ajoutés |
| ➕ | *Ajouter* | Formulaire pour ajouter un nouveau produit |

---

### 3. Consulter le catalogue

1. Appuyez sur l'onglet *Catalogue* (icône magasin)
2. Les produits s'affichent en *grille* par défaut
3. Pour passer en *vue liste*, appuyez sur l'icône en haut à droite de l'écran
4. Appuyez sur l'icône 🛒 d'un produit pour voir sa *fiche détaillée* (image, description, prix)
5. Dans la fiche, appuyez sur *"AJOUTE NAN PANYE"* pour ajouter au panier

> 💡 Si le catalogue est vide, un message vous invite à ajouter votre premier produit.

---

### 4. Ajouter un produit

1. Appuyez sur l'onglet *Ajouter* (icône boîte)
2. Remplissez les champs obligatoires :
   - *Nom du produit*
   - *Description*
   - *Prix* (nombre positif, ex : 29.99)
3. Appuyez sur *"Choisir une image"*
   - Sur *mobile* : choisissez entre Galerie ou Caméra
   - Sur *navigateur Web* : votre explorateur de fichiers s'ouvre directement
4. Un aperçu de l'image sélectionnée s'affiche
5. Appuyez sur *"AJOUTER LE PRODUIT"* pour valider
6. Vous êtes automatiquement redirigé vers le *Catalogue* où le produit apparaît

> ⚠️ Tous les champs sont obligatoires. Une image doit être sélectionnée pour pouvoir valider.

---

### 5. Se déconnecter

1. Appuyez sur l'icône 🚪 en haut à droite de l'écran
2. Une boîte de dialogue de confirmation s'affiche
3. Appuyez sur *"DÉCONNECTER"* pour confirmer, ou *"ANNULER"* pour rester connecté

---

---
---

## 🛠️ PARTIE 2 — Guide Développeur

### Prérequis

Avant de commencer, assurez-vous d'avoir installé :

- [Flutter SDK](https://docs.flutter.dev/get-started/install) *3.x ou supérieur*
- [Dart SDK](https://dart.dev/get-dart) (inclus avec Flutter)
- [Android Studio](https://developer.android.com/studio) ou [VS Code](https://code.visualstudio.com/) avec l'extension Flutter
- Git

Vérifiez votre installation Flutter :
bash
flutter doctor

Tous les éléments doivent afficher ✅ (ou au moins ceux pour votre cible de déploiement).

---

### Installation du projet

#### 1. Cloner le dépôt
bash
git clone https://github.com/ton-utilisateur/myshop_app.git
cd myshop_app


#### 2. Installer les dépendances
bash
flutter pub get


#### 3. Vérifier les dépendances dans pubspec.yaml
yaml
dependencies:
  flutter:
    sdk: flutter
  image_picker: ^1.1.2


---

### Configuration des permissions

#### Android
Fichier : android/app/src/main/AndroidManifest.xml
xml
<uses-permission android:name="android.permission.READ_MEDIA_IMAGES"/>
<uses-permission android:name="android.permission.CAMERA"/>


#### iOS
Fichier : ios/Runner/Info.plist
xml
<key>NSPhotoLibraryUsageDescription</key>
<string>Accès à la galerie pour choisir une image produit.</string>
<key>NSCameraUsageDescription</key>
<string>Accès à la caméra pour photographier un produit.</string>


---

### Lancer l'application

#### Sur émulateur ou appareil Android/iOS
bash
# Lister les appareils disponibles
flutter devices

# Lancer sur l'appareil détecté
flutter run

# Lancer sur un appareil spécifique
flutter run -d <device_id>


#### Sur navigateur Web (Chrome)
bash
flutter run -d chrome


#### En mode release (performances optimales)
bash
flutter run --release


---

### Compiler l'application

#### APK Android (installation manuelle)
bash
flutter build apk --release
# Fichier généré : build/app/outputs/flutter-apk/app-release.apk


#### App Bundle Android (Google Play Store)
bash
flutter build appbundle --release


#### iOS (nécessite macOS + Xcode)
bash
flutter build ios --release


#### Web
bash
flutter build web
# Fichier généré dans : build/web/


---

### Structure du code


lib/
├── main.dart                  # Point d'entrée de l'application
├── pages/
│   ├── home_page.dart         # Navigation + liste partagée _products
│   ├── login_page.dart        # Authentification
│   ├── catalogue_page.dart    # Affichage grille/liste des produits
│   └── add_product_page.dart  # Formulaire + image_picker
└── models/
    └── product.dart           # Modèle Product avec imageBytes (Web)


#### Points clés de l'architecture

- La liste _products vit dans _HomePageState et est passée en paramètre aux pages enfants — c'est le seul état global de l'app.
- AddProductPage reçoit un callback onProductAdded(Product) pour remonter les données.
- _buildProductImage() dans catalogue_page.dart gère 3 cas : Image.memory (Web), Image.file (Mobile), Image.asset (assets Flutter).

---

### Pistes d'évolution

- 💾 *Persistance des données* : intégrer shared_preferences ou sqflite
- 🔍 *Recherche* : ajouter une barre de recherche dans le catalogue
- 🗑️ *Suppression / modification* : permettre d'éditer ou supprimer un produit
- 🔐 *Authentification réelle* : connecter à un backend (Firebase, Supabase…)
- 🌐 *Internationalisation* : support multilingue (français  / anglais)