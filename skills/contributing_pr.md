---
name: contribute-to-public-repo
description: Contribuer proprement à un dépôt GitHub public à partir d'un fork (branche, tests, commit, rebase, push, pull request, revue, nettoyage). À utiliser dès qu'il faut proposer un correctif ou une fonctionnalité à un projet dont on n'est pas mainteneur, ou quand un push/rebase/PR pose problème.
---

# Contribuer à un dépôt public (fork → PR)

Variables utilisées dans cette note (à remplacer) :

| Variable | Exemple |
|---|---|
| `<user>` | ton compte GitHub |
| `<owner>/<repo>` | `open-navigation/opennav_coverage` |
| `<base>` | branche visée par la PR (`main`, `jazzy-v2`, …) |
| `<topic>` | ta branche de travail (`fix/swath_end`) |

Principes qui évitent 90 % des problèmes :

- **Une PR = un sujet.** Rien de sans rapport avec le correctif (pas de debug, pas de config locale).
- **Jamais de travail sur `<base>`** : toujours sur une branche dédiée.
- **Le test d'abord** : un test qui échoue avant le correctif et passe après.
- **`origin` = ton fork, `upstream` = le dépôt d'origine.** On pousse sur `origin`, on lit `upstream`.

---

## 1. Mise en place (une seule fois)

### 1.1 Fork et clone

1. Sur GitHub : bouton **Fork** du dépôt `<owner>/<repo>`.
2. Clone **ton fork** en SSH, puis ajoute le dépôt d'origine :

```bash
git clone git@github.com:<user>/<repo>.git
cd <repo>
git remote add upstream https://github.com/<owner>/<repo>.git
git fetch upstream
git remote -v        # origin = ton fork (SSH), upstream = dépôt d'origine
```

`upstream` peut rester en HTTPS : le dépôt est public et on ne pousse jamais dessus.

### 1.2 Authentification (SSH)

GitHub refuse les mots de passe de compte en HTTPS (« Password authentication is not supported »). Utilise SSH.

```bash
ssh -T git@github.com            # attendu : "Hi <user>! You've successfully authenticated"
git remote set-url origin git@github.com:<user>/<repo>.git   # si origin était en https://
```

Si tu as plusieurs comptes (pro / perso), un fichier de config par dossier :

```ini
# ~/.gitconfig
[includeIf "gitdir:~/github_perso/"]      # le "/" final est obligatoire
    path = ~/github_perso/.gitconfig

# ~/github_perso/.gitconfig
[user]
    name = Ton Nom
    email = ton.email@exemple.org
[core]
    sshCommand = ssh -i ~/.ssh/id_perso -o IdentitiesOnly=yes
```

Vérifier que la config s'applique bien au dépôt :

```bash
git config --show-origin -l | grep -i -E "sshcommand|user\.(name|email)"
ssh -vT git@github.com 2>&1 | grep -i -E "identity file|offering|permission"
```

Erreur `Permission denied (publickey)` : la clé proposée n'est pas enregistrée sur le bon compte
(GitHub → Settings → SSH and GPG keys) ou le `includeIf` ne couvre pas le dossier.

### 1.3 Lire les règles du projet

Avant de coder : `CONTRIBUTING.md`, le modèle de PR (`.github/pull_request_template.md`), les issues
ouvertes (le bug est peut-être déjà signalé ou corrigé), et les PR récemment fusionnées
(pour voir la **branche cible** et le style de message utilisés).

Points à relever : signature **DCO** exigée (`git commit -s`), linters, `pre-commit`, convention de
messages de commit.

---

## 2. Avant chaque contribution

### 2.1 Mettre le fork à jour

```bash
git fetch upstream
git switch <base>
git merge --ff-only upstream/<base>      # échoue s'il y a des commits locaux sur <base> : c'est un signal
git push origin <base>
# alternative GitHub CLI : gh repo sync <user>/<repo> --branch <base>
```

### 2.2 Créer la branche de travail depuis l'amont

```bash
git switch -c <topic> --no-track upstream/<base>
```

`--no-track` évite que la branche suive `upstream/<base>` par défaut (source de pushs confus).

---

## 3. Développer et tester

1. Écris **le test d'abord** et vérifie qu'il échoue sans le correctif.
2. Corrige, relance : il doit passer, ainsi que tous les tests existants.
3. Reste minimal : pas de reformatage de fichiers entiers, pas de renommages.

Projets ROS 2 / colcon :

```bash
colcon build --packages-select <package>
colcon test --packages-select <package> --event-handlers console_direct+
colcon test-result --verbose
# lints (si le paquet les active) : ament_uncrustify, ament_cpplint ; si le dépôt a un pre-commit :
pre-commit run --all-files
```

---

## 4. Committer

```bash
git status
git add <fichiers précis>          # éviter "git add ." qui embarque des fichiers parasites
git diff --staged                  # relire ce qui part
git commit -s                      # -s seulement si le projet exige le DCO
```

Message de commit :

- 1re ligne : impératif, ≤ 72 caractères (`Fix swath end points in coverage path message`).
- Corps : **pourquoi** (cause), puis ce qui change. `Fixes #123` si une issue existe.

Corriger le dernier commit : `git commit --amend` (message) ou `git add … && git commit --amend --no-edit`.

### Vérifier le contenu de la future PR

```bash
git log --oneline upstream/<base>..HEAD        # seulement TES commits
git diff --stat upstream/<base>...HEAD         # seulement TES fichiers (3 points = depuis l'ancêtre commun)
```

---

## 5. Garder la branche à jour : rebase

Quand l'amont a avancé (ou avant d'ouvrir la PR) :

```bash
git fetch upstream
git rebase upstream/<base>
```

En cas de conflit :

```bash
git status                       # fichiers en conflit
# éditer les fichiers (supprimer <<<<<<<, =======, >>>>>>>), puis :
git add <fichiers résolus>
git rebase --continue
# abandonner et revenir à l'état d'avant : git rebase --abort
```

Si la branche a **déjà été poussée**, le rebase réécrit l'historique, donc :

```bash
git push --force-with-lease origin <topic>
```

`--force-with-lease` refuse d'écraser un commit distant que tu n'as pas vu (plus sûr que `--force`).
Ne jamais forcer un push sur `<base>` ni sur une branche partagée.

### Rebase interactif : regrouper ou réordonner les commits

```bash
git rebase -i upstream/<base>
# dans l'éditeur : pick = garder, squash = fusionner (garde les 2 messages),
#                  fixup = fusionner (jette le message), reword = changer le message, drop = supprimer
```

Pour corriger un ancien commit après une revue :

```bash
git commit --fixup <hash>
git rebase -i --autosquash upstream/<base>
git push --force-with-lease origin <topic>
```

### Branche « polluée » (commits sans rapport) : repartir proprement

```bash
git log --oneline upstream/<base>..<topic>                 # repérer les hash utiles
git switch -c <topic>-clean --no-track upstream/<base>
git cherry-pick <hash1> [<hash2> …]                        # dans l'ordre
```

`cherry-pick` copie un commit précis sur la branche courante.

---

## 6. Pousser et ouvrir la PR

```bash
git push -u origin <topic>
```

### Par le navigateur

Après le push, GitHub affiche **Compare & pull request**. Vérifier :

- base repository : `<owner>/<repo>` ; **base** : `<base>` ;
- head repository : ton fork ; **compare** : `<topic>`.

### Avec la CLI GitHub

```bash
gh pr create --repo <owner>/<repo> --base <base> --head <user>:<topic> \
  --title "Titre court à l'impératif" --body-file pr_body.md          # ajouter --draft pour un brouillon
gh pr status
gh pr checks
```

### Modèle de description (en anglais pour un projet international)

```markdown
## Summary
What is wrong, in one or two sentences.

## Cause
Why it happens (the actual root cause).

## Fix
What this PR changes.

## Test
Which test was added; it fails before the fix and passes after.

## Reproduction (before the fix)
Minimal commands and the observed output.

## Limitations
What is not covered (be explicit).
```

Les remarques sans rapport (autre bug repéré) vont dans une **issue séparée**.

---

## 7. Pendant la revue

- Réponds à chaque commentaire ; n'ouvre pas une nouvelle PR pour les retouches.
- Ajoute des commits (ou `--fixup`) puis pousse sur la même branche : la PR se met à jour toute seule.
- Si la CI échoue : lire le log, corriger localement, relancer les tests, pousser.
- Si les mainteneurs demandent de rebaser ou de « squasher » : voir §5.
- Si on te demande une autre branche cible : change la **base** de la PR dans l'interface
  (ou rebase sur la nouvelle base, puis `--force-with-lease`).

---

## 8. Après la fusion

```bash
git switch <base>
git fetch upstream
git merge --ff-only upstream/<base>
git push origin <base>
git branch -d <topic>
git push origin --delete <topic>
```

Un rétroportage vers une autre branche de version se demande dans la PR ou se fait avec
`git cherry-pick <hash_du_commit_fusionné>` sur une branche partie de cette autre branche.

---

## 9. Dépannage

| Symptôme | Cause probable | Action |
|---|---|---|
| `Password authentication is not supported` | `origin` en HTTPS | `git remote set-url origin git@github.com:<user>/<repo>.git` |
| `Permission denied (publickey)` | mauvaise clé ou clé non enregistrée | §1.2 : `ssh -vT`, ajouter la clé publique au compte |
| `Permission to <owner>/<repo> denied` au push | `origin` pointe sur le dépôt d'origine, pas sur le fork | `git remote set-url origin` vers le fork |
| `rejected … non-fast-forward` | historique réécrit ou distant plus avancé | `git fetch`, vérifier, puis `git push --force-with-lease` si c'est ta branche |
| PR contient des commits en trop | branche partie de la mauvaise base | §5 : rebase ou cherry-pick propre |
| Commits faits sur `<base>` par erreur | | `git branch <topic>` (garde les commits), `git switch <base>`, `git reset --hard upstream/<base>` |
| Mauvais email d'auteur | `includeIf` non appliqué | corriger la config, puis `git commit --amend --reset-author --no-edit` |
| Fichier parasite commité | `git add .` | `git restore --staged <f>` (avant commit) ou `git rm --cached <f>` + amend |
| Besoin d'annuler le dernier commit | | `git reset --soft HEAD~1` (garde les modifications) |
| « J'ai tout cassé » | | `git reflog` puis `git reset --hard <hash d'avant>` (⚠ perd les modifications non commitées) |

---

## 10. Checklist avant d'ouvrir la PR

- [ ] `origin` = fork (SSH), `upstream` = dépôt d'origine.
- [ ] Branche créée depuis `upstream/<base>`, à jour (rebase fait).
- [ ] `git log --oneline upstream/<base>..HEAD` : seulement mes commits.
- [ ] `git diff --stat upstream/<base>...HEAD` : seulement les fichiers voulus, pas de debug.
- [ ] Test ajouté, échoue sans le correctif, passe avec.
- [ ] Build, tests et linters passent en local.
- [ ] Message de commit clair (et DCO si exigé).
- [ ] Branche cible vérifiée (dernières PR fusionnées).
- [ ] Description rédigée (résumé, cause, correctif, test, reproduction, limites).
- [ ] Remarques annexes mises en issues séparées.

---

## Annexe : cas en cours (opennav_coverage)

- Dépôt : `open-navigation/opennav_coverage`, branche de travail `fix/swath_end` créée depuis `jazzy-v2`.
- Correctif : `toCoveragePathMsg(const Path &, …)` dans `utils.hpp` (la fin d'un swath = point de départ + `len` × cap).
- Test : `TesttoCoveragePathMsgSwathEndPoints` dans `test_utils.cpp`.
- Limite à mentionner : cas GPS non couvert (conversion de CRS avant la boucle).
- Issue séparée possible : `return` manquant après `terminate_current(result)` quand `validateGoal` échoue
  dans `computeCoveragePath()` du serveur row.
