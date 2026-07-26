sudo apt install wget unzip -y

mkdir -p ~/.local/share/fonts

cd /tmp

# télécharge l'archive officielle de JetBrainsMono Nerd Font
wget https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip
unzip -o JetBrainsMono.zip -d ~/.local/share/fonts/
fc-cache -fv
rm /tmp/JetBrainsMono.zip