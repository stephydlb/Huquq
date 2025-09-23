# Huquq Assistant

Une application mobile pour calculer et suivre les paiements du Ḥuqúqu’lláh selon les enseignements bahá'ís.

## Fonctionnalités

- **Calcul du surplus** : Calculez automatiquement votre surplus disponible (revenus - dépenses essentielles)
- **Ḥuqúqu’lláh (19%)** : Calcul du montant dû selon la loi bahá'íe
- **Conversion or** : Support pour les paiements en valeur d'or (mithqál)
- **Plan de paiement** : Échelonnez vos paiements mensuellement, trimestriellement ou annuellement
- **Historique** : Suivi complet de vos transactions et paiements
- **Mode hors-ligne** : Fonctionne sans connexion internet
- **Sécurité** : Chiffrement des données sensibles
- **Multilingue** : Support du français, anglais et arabe

## Installation

### Prérequis

- Node.js 16+
- React Native development environment
- Android Studio (pour Android)
- Xcode (pour iOS)

### Installation des dépendances

```bash
npm install
```

### Lancement

#### Android

```bash
npm run android
```

#### iOS

```bash
npm run ios
```

#### Développement

```bash
npm start
```

## Architecture

- **Frontend** : React Native avec TypeScript
- **Navigation** : React Navigation
- **UI** : React Native Paper
- **Stockage** : AsyncStorage + EncryptedStorage
- **État** : React Hooks

## Structure du projet

```
src/
├── components/     # Composants réutilisables
├── screens/        # Écrans de l'application
├── services/       # Services métier (calculs, stockage)
├── types/          # Définitions TypeScript
├── utils/          # Utilitaires
└── locales/        # Fichiers de traduction
```

## Sécurité

- Chiffrement AES-256 des données au repos
- Stockage sécurisé des paramètres sensibles
- Pas de transmission de données personnelles sans consentement

## Conformité

Cette application ne se substitue pas à un conseiller financier ou à une autorité religieuse. Consultez toujours les institutions bahá'íes officielles pour des questions spécifiques.

## Développement

Pour contribuer au développement :

1. Fork le repository
2. Créez une branche feature (`git checkout -b feature/nouvelle-fonctionnalite`)
3. Committez vos changements (`git commit -am 'Ajoute nouvelle fonctionnalité'`)
4. Pushez vers la branche (`git push origin feature/nouvelle-fonctionnalite`)
5. Créez une Pull Request

## Licence

Ce projet est sous licence MIT.
