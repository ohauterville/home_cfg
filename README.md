# Dotfiles - Robotics & Development Environment

This repository contains my personal development environment, highly optimized for robotics, ROS 2, and embedded systems. 

## Core Philosophy

* **Modular Architecture:** Each tool has its own directory containing an idempotent `install.sh` script.
* **Zero Sudo:** Binaries are downloaded and installed locally in `~/.local/bin`. 
* **Symlink Based:** Configuration files are tracked in this repository and symlinked to `~/.config/` or `$HOME`.
* **Container Ready:** Designed to work natively on the host and seamlessly inside Apptainer or SSH environments (auto-detects x86_64 and aarch64 architectures).

## Desktop & Window Management

* **Feh:** Lightweight background image viewer/manager.
* **JetBrainsMono Nerd Font:** System-wide monospace font for programming ligatures and terminal icons.

## Terminal & Multiplexer

* **Terminator:** Terminal emulator. Configured with a default profile that attaches to Tmux, and a classic profile for isolated execution. Handles copy-on-selection directly.
* **Tmux:** Terminal multiplexer. Configured with a custom, lightweight Powerline theme. Includes plugins for sensible defaults (`tmux-sensible`) and hardware monitoring (`tmux-cpu`).

## Shell & CLI Utilities

* **Bash:** 
* **Starship:** Fast, customizable, cross-shell prompt.
* **Zoxide (z):** Smarter `cd` command that learns your habits.
* **Fzf:** Command-line fuzzy finder. Integrated into bash for reverse history search and file finding (with `bat` and `tree` previews).
* **Superfile (spf):** Fast, terminal-based file manager with Vim keybindings.
* **Eza:** Modern replacement for `ls` with colors, icons, and Git integration.
* **Bat:** Modern replacement for `cat` with syntax highlighting.
* **Tealdeer (tldr):** Fast, Rust-based implementation of tldr for simplified man pages.
* **Navi:** Interactive CLI cheatsheet. Used heavily to store complex ROS 2, Git, and Docker commands using dynamic variables.
* **Btop:** Visually comprehensive system resource monitor.
* **Lnav:** Advanced log file navigator. Essential for merging, reading, and filtering multiple ROS 2 log files chronologically.

## Development & Task Management

* **Lazygit:** Terminal UI for Git operations.
* **Just:** Command runner (modern alternative to Make). Used as the primary entry point to manage Apptainer executions and ROS 2 launch recipes.

## Neovim (The IDE)

A highly customized Neovim setup built upon Kickstart.nvim, utilizing the native `vim.pack` package manager for zero-overhead plugin management.

* **UI & Layout:** Custom toggleable VS Code-style layout combining `neo-tree` (file explorer) and `toggleterm` (integrated terminal). Buffers are managed with `bufferline.nvim` and safely closed with `bufdelete.nvim`.
* **Formatting:** Managed by `conform.nvim` (black, isort, clang-format via Mason).
* **Completion & Snippets:** The standard `nvim-cmp` stack with `LuaSnip`. Includes custom JSON snippets for ROS 2 standard and lifecycle nodes in C++ and Python.
* **Markdown:** `render-markdown.nvim` for rendering headers, tables, and code blocks directly inside the terminal.
* **ROS 2 Integration:** `nvim-ros2` plugin. Provides Telescope pickers for the ROS graph, an interactive Parameter Tuner, and dynamic RPC buffer generation to call services/actions.
* **Remote Development:** `remote-nvim.nvim` powered by a local `devpod` binary. Allows seamless connection to remote robots via SSH or local `.devcontainer` environments, injecting this exact configuration into the target without leaving the local UI.

## Installation

To deploy this configuration on a new machine or an embedded robot:

```bash
# Run the global installer
chmod +x *.sh 
./install_all.sh
