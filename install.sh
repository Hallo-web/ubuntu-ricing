#!/bin/bash

# Default style
STYLE="nature"

# Parse arguments
for arg in "$@"; do
  case $arg in
    --coder)
      STYLE="coder"
      ;;
    --nature)
      STYLE="nature"
      ;;
    --remove)
      REMOVE=true
      ;;
  esac
done

if [ "$REMOVE" = true ]; then
  echo "🔁 Reverting changes..."
  rm -rf ~/.themes/orchis* ~/.icons/papirus* ~/.config/kitty ~/.zshrc ~/.zshrc_backup
  gsettings reset org.gnome.desktop.interface gtk-theme
  gsettings reset org.gnome.desktop.interface icon-theme
  gsettings reset org.gnome.shell.extensions.user-theme name
  echo "✅ Reverted to default."
  exit 0
fi

echo "🌿 Applying $STYLE style..."

# Backup
cp ~/.zshrc ~/.zshrc_backup 2>/dev/null

# Install dependencies
sudo apt update && sudo apt install -y zsh gnome-tweaks curl git fonts-jetbrains-mono papirus-icon-theme kitty unzip gnome-shell-extensions

# Set zsh as default
chsh -s $(which zsh)

# Setup Starship
curl -sS https://starship.rs/install.sh | sh -s -- -y
echo 'eval "$(starship init zsh)"' >> ~/.zshrc

# Kitty config
mkdir -p ~/.config/kitty
cp ./kitty/kitty.conf ~/.config/kitty/kitty.conf

# ZSH
cp ./zshrc/.zshrc ~/.zshrc

# Install themes and icons
mkdir -p ~/.themes ~/.icons
cp -r ./themes/$STYLE/gtk ~/.themes/orchis
cp -r ./themes/$STYLE/icons ~/.icons/papirus

# Set GNOME settings
gsettings set org.gnome.desktop.interface gtk-theme "orchis"
gsettings set org.gnome.desktop.interface icon-theme "papirus"
gsettings set org.gnome.shell.extensions.user-theme name "orchis"

# Extensions (manually install or use gnome-extension-cli if installed)

echo "🎉 Done! Please restart GNOME shell (Alt+F2, type 'r') or reboot."
