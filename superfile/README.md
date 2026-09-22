### 🚀 Guide de Survie : Les commandes Superfile (`spf`)

Pour lancer le gestionnaire de fichiers, tape simplement **`spf`** dans ton terminal. 
Voici les commandes indispensables pour naviguer comme un pro de Vim !

#### 🧭 1. Naviguer et Sélectionner
*   **`h`, `j`, `k`, `l`** : Naviguer dans les dossiers (H pour reculer/dossier parent, L pour entrer dans un dossier).
*   **`Entrée`** : Entrer dans un dossier (ou ouvrir un fichier).
*   **`Espace`** : Sélectionner un ou plusieurs fichiers (ils changent de couleur).
*   **`Tab`** : Changer de panneau (si tu as divisé ton écran).

#### 🛠️ 2. Manipuler les Fichiers (Les Bases)
*   **`e`** : Éditer le fichier sélectionné. *Puisqu'on a configuré Neovim, ça ouvrira directement Neovim !*
*   **`Ctrl + n`** : Créer un nouveau fichier. *(💡 Astuce : Si tu ajoutes un `/` à la fin du nom, ça crée un dossier au lieu d'un fichier !)*
*   **`Ctrl + r`** : Renommer le fichier sélectionné.
*   **`Ctrl + d`** : Supprimer le fichier. *(Appuie 2 fois pour confirmer).*

#### 📋 3. Copier, Couper, Coller
*   **`Ctrl + c`** : Copier le(s) fichier(s) sélectionné(s) (avec la touche Espace).
*   **`Ctrl + x`** : Couper le(s) fichier(s).
*   **`Ctrl + v`** : Coller dans le dossier actuel. Tu verras une barre de progression en direct en bas à gauche (très pratique pour les gros transferts de bags ROS !).

#### 📦 4. Les Superpouvoirs (Archives & Recherche)
*   **`/` (Slash)** : Mode Recherche. Tape un mot et il filtre instantanément le dossier actuel.
*   **`Ctrl + a`** : Archiver (Compresser) les fichiers sélectionnés.
*   **`Ctrl + e`** : Extraire (Décompresser) une archive.

#### 🎛️ 5. Le Panneau de Commande
Exactement comme dans Vim, tu peux appuyer sur **`:`** pour ouvrir la barre de commande de Superfile.
*   Tape `:split` ➡️ Coupe l'écran en deux panneaux.
*   Tape `:close` ➡️ Ferme le panneau actuel.
*   Tape n'importe quelle commande shell (ex: `:echo hello` ou `:ros2 topic list`) et elle s'exécutera dans le dossier en cours.
