# 🚀 Superfile (spf) - Quick Cheatsheet

Superfile is a modern, terminal-based file manager built for keyboard-centric workflows. It uses Vim-like keybindings for navigation, and `Ctrl` modifiers for dangerous actions.

## 🧭 Navigation
| Key | Action |
| :--- | :--- |
| `j` / `k` | Move cursor Down / Up |
| `h` / `l` | Go to parent directory (`h`) / Enter directory (`l`) |
| `Enter` | Open file (in Neovim) or enter directory |
| `Backspace` | Go back to the previous directory |
| `Tab` | Switch focus between active file panels |
| `Space` | Select / Unselect a single item |
| `v` | **Visual Mode**: Toggle multi-selection mode (use `j`/`k` to select blocks) |
| `Esc` | Clear all selections or cancel current action |

## 🛠️ File & Directory Operations (Requires Ctrl)
*Note: Operations apply to the currently highlighted item OR all selected items.*

| Key | Action | Details |
| :--- | :--- | :--- |
| `Ctrl + n` | **N**ew | Create a new file. **Pro-tip:** Add a `/` at the end of the name to create a **directory** (e.g., `my_folder/`). |
| `Ctrl + r` | **R**ename | Rename the highlighted file or directory (or just `r`). |
| `Ctrl + d` | **D**elete | Move the file/directory to the Trash. |
| `Shift + d` | Destroy | **Permanently** delete the file/directory. |
| `e` | **E**dit | Open the selected file in your default editor (`nvim`). |

## 📋 Clipboard (Copy/Cut/Paste)
| Key | Action |
| :--- | :--- |
| `Ctrl + c` | **C**opy | Copies the selected items to the internal clipboard panel. |
| `Ctrl + x` | Cut | Cuts the selected items. |
| `Ctrl + v` | Paste | Pastes the copied/cut items into the current directory. |

## 🪟 UI & Panels (Toggles)
*Press the key once to jump into the panel. Press the **same key again** (or `Esc`) to jump back to the main file list.*

| Key | Action |
| :--- | :--- |
| `s` | Toggle **S**idebar (Disks, bookmarks, pinned folders). |
| `m` | Toggle **M**etadata panel (File permissions, size, dates). |
| `p` | Toggle **P**rocess panel (Shows active copy/paste/extract progress). |
| `f` | Toggle **F**ile preview panel (Shows file contents on the right). |

## 🔍 Search & Commands
| Key | Action |
| :--- | :--- |
| `/` | **Search/Filter:** Instantly filter the current directory by typing a name. |
| `:` | **Command Palette:** Open the command line (like in Vim). |

### Useful `:` Commands
Type `:` followed by:
* `split` : Split the current view into two parallel file panels.
* `close` : Close the current split panel.
* `cd <path>` : Jump directly to a specific path.
* `archive` : Compress selected files into a `.zip` or `.tar.gz`.
* `extract` : Unzip/extract the highlighted archive.
