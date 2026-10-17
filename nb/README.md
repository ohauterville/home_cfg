# nb - Command Line Note-Taking

This module provides `nb`, a command-line note-taking, bookmarking, and archiving utility. It is written in pure Bash, making it perfectly suited for our "Zero Sudo" and embedded-friendly philosophy.

## Architecture & Synchronization

- **Binary:** Installed locally in `~/.local/bin/nb`.
- **Storage:** Notes are stored in `~/home_cfg/nb/notes/`. A symlink is created from `~/.nb` to this directory.
- **Git Sync:** Because the notes are stored inside the `home_cfg` repository, they are versioned and synchronized across machines via standard `git pull` and `git push` on the dotfiles repository. `nb`'s native auto-commit feature is disabled to prevent Git history spam.

## Core Dependencies

`nb` natively integrates with the existing tools in our environment:
- **Neovim (`$EDITOR`):** For editing notes (with Markdown rendering).
- **Fzf:** For interactive searching and filtering.
- **Bat:** For syntax highlighting and previewing.
- **Ripgrep:** For fast full-text search.

## Main Features & Workflow

### 1. Note Taking (The Lab Notebook)
Take quick notes without leaving the terminal. Ideal for logging test results, hardware pinouts, or SSH commands.

- `nb add "Odometry test on grass: drift of 5cm over 10m."` - Create a quick one-line note.
- `nb edit` - Open the most recent note in Neovim.
- `nb edit 3` - Edit note ID 3.
- `nb ls` - List all notes.
- `nb delete 3` - Delete note ID 3.

### 2. Interactive Search
Quickly find information across all notes.

- `nb q` - Open an interactive `fzf` window with a `bat` preview to search through titles and contents.
- `nb search "I2C"` - Perform a fast full-text search using `ripgrep`.

### 3. Notebooks & Tags (Organization)
Keep robotics projects isolated and structured.

- `nb notebooks add robot_arm` - Create a new notebook.
- `nb use robot_arm` - Switch to the new notebook.
- `nb add "#calibration Needs new camera intrinsics"` - Add a tag directly within a note.
- `nb tags` - List all tags used across your notes.

### 4. Task Management (TODO lists)
Track small pending actions directly on the robot.

- `nb todo "Fix CAN bus baudrate mismatch"` - Add a new task.
- `nb todos` - List pending tasks.
- `nb do 1` - Mark task ID 1 as complete.

### 5. Bookmarking & Archiving
Save ROS 2 documentation or GitHub issues for offline reading.

- `nb add https://docs.ros.org/en/jazzy/index.html` - Save a bookmark.
- `nb extract 1` - Download the content of the bookmarked webpage as plain text/markdown for offline viewing (crucial for field testing without internet).

### 6. Security (Encryption)
Store sensitive lab passwords or temporary API keys securely.

- `nb encrypt 5` - Encrypt note ID 5 using GPG.
- `nb decrypt 5` - Decrypt the note.
