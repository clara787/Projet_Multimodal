# Projet Multimodal - Moteur de Fusion Multimodal

## Description
L'objectif principal de ce projet est le développement d'un moteur multimodal permettant à l'utilisateur de créer des formes graphiques en choisissant une couleur spécifique. Le moteur intègre la reconnaissance de la parole, la reconnaissance de geste par dessin et le suivi des mouvements de la main (hand tracking). La position de la souris permet de positionner la forme à l'emplacement précis du curseur dans la fenêtre graphique.

Le moteur multimodal permet à l'utilisateur de choisir la forme et la couleur, puis d'interagir avec l'interface en utilisant des commandes vocales, des gestes de dessin et le suivi des mouvements de la main pour effectuer les actions demandées.

## Prérequis

Avant de commencer, assurez-vous que vous avez installé les éléments suivants :

### Logiciels et bibliothèques nécessaires :
- **Processing** : Pour exécuter les fichiers `.pde`.
- **Python** : Pour la partie reconnaissance vocale et hand tracking.

### Librairies Python requises :
Vous devez installer les bibliothèques suivantes :
- `SpeechRecognition`
- `ivy-python`
- `PyAudio`
- `opencv-python`
- `mediapipe`
- `numpy`

Vous pouvez installer toutes les dépendances nécessaires avec la commande suivante :

```bash
pip install -r requirements.txt
```
---

## Démarrer le Projet

### 1. Lancer le fichier principal
Pour démarrer le projet, ouvrez le fichier `ProjetMultimodal.pde` dans votre environnement de développement. Cela lancera les modules suivants :
- **Reconnaissance vocale**
- **Hand tracking** (suivi des mouvements de la main)

Lors de l'exécution de ce fichier, une fenêtre grise représentant l'interface graphique apparaîtra. Deux terminaux seront également ouverts :
- Un terminal pour afficher la sortie de la **reconnaissance vocale**.
- Un autre terminal pour afficher la sortie du **hand tracking**, ouvrant également une fenêtre de caméra pour suivre les mouvements de la main.

### 2. Lancer la reconnaissance de gestes
Pour activer la reconnaissance de gestes, ouvrez le fichier `OneDollarIvy.pde` situé dans le dossier `OneDollarIvy`. Une petite fenêtre blanche s'affichera. Appuyez sur la touche **"I"** pour démarrer la reconnaissance des gestes.

---

## Fonctionnalités

### Formes disponibles :
- **Carré**
- **Rectangle**
- **Triangle**
- **Cercle**

### Couleurs disponibles :
- **Rouge**
- **Bleu**
- **Vert**

### Actions possibles :
- **Créer**
- **Déplacer** : non disponible par le dessin
- **Supprimer** : non disponible par le dessin
- **Modifier** : non disponible pour la reconnaissance de geste

### Commandes et interactions :
- **Reconnaissance vocale** : Permet à l'utilisateur de spécifier la forme et la couleur de l'objet graphique à créer.
- **Reconnaissance de gestes par dessin** : Permet de dessiner des formes à l'écran à l'aide de gestes.
- **Hand Tracking** : Suivi des mouvements de la main pour effectuer des actions telles que le dessin ou le changement de forme à la position de la souris.

### Interface :
L'interface graphique affiche la fenêtre dans laquelle les formes seront dessinées à l'emplacement de la souris. Les formes peuvent être dessinées en fonction de la couleur et de la forme choisies par l'utilisateur.