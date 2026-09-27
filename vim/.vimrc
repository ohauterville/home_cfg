" =========================================================================
" VIM SURVIVAL CONFIG - Neovim Kickstart Clone (Zero Plugin)
" =========================================================================

" 1. PARAMÈTRES DE BASE (Sane Defaults)
set nocompatible            " Désactive la compatibilité avec le très vieux vi
syntax on                   " Coloration syntaxique de base
set encoding=utf-8
set number                  " Affiche les numéros de ligne
set mouse=a                 " Active la souris
set clipboard=unnamedplus   " Utilise le presse-papier système (copier/coller)
set ignorecase smartcase    " Recherche insensible à la casse
set splitbelow splitright   " Sens logique pour diviser l'écran
set scrolloff=8             " Garde 8 lignes de marge en scrollant
set updatetime=250

" Apparence
set t_Co=256
syntax on
" set termguicolors           " Couleurs vraies (True color) broken
colorscheme desert          " Thème sombre natif de Vim (très lisible)

" 2. LA TOUCHE LEADER (Espace)
let mapleader = " "
nnoremap <Space> <Nop>

" 3. RACCOURCIS DE BASE (Les mêmes que ton Neovim)
" Effacer le surlignage de la recherche avec Echap
nnoremap <Esc> :nohlsearch<CR>

" Naviguer entre les fenêtres avec Ctrl + h/j/k/l
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Sortir du mode Terminal avec Echap Echap (Vim 8+)
tnoremap <Esc><Esc> <C-\><C-n>

" 4. L'EXPLORATEUR DE FICHIERS (Remplacement de Neo-tree par Netrw)
" Netrw est l'explorateur intégré par défaut dans Vim
let g:netrw_banner = 0      " Cache la bannière moche en haut
let g:netrw_liststyle = 3   " Affichage en arbre (comme Neo-tree)
let g:netrw_winsize = 25    " Largeur de la fenêtre à 25%
let g:netrw_altv = 1        " Ouvre les fichiers à droite

" Raccourci pour afficher/masquer l'explorateur à gauche (Espace + e)
nnoremap <leader>e :Lexplore<CR>

" 5. LE MODE IDE (Espace + i)
" Recrée le layout: Explorateur à gauche, Terminal en bas, Code au centre
nnoremap <leader>i :Lexplore<CR><C-w>l:botright 15split<CR>:terminal<CR>i
