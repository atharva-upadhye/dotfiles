#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Get the operating system name
OS=$(uname -s)

# Define the destination directory for the settings.json file
DEST_DIR=""

# Determine the correct destination based on the OS
case "$OS" in
"Linux")
	DEST_DIR="$HOME/.config/Code/User/"
	;;
"Darwin")
	DEST_DIR="$HOME/Library/Application Support/Code/User/"
	;;
"MINGW64_NT"*) # For Git Bash on Windows
	DEST_DIR="$HOME/AppData/Roaming/Code/User/"
	;;
*)
	echo "Unknown operating system: $OS"
	exit 1
	;;
esac

# Check if the destination file settings.json exists
if [ -f "$DEST_DIR/settings.json" ]; then
	# Compute the hash of both the existing and the new settings.json
	DEST_HASH=$(sha256sum "$DEST_DIR/settings.json" | awk '{ print $1 }')
	SOURCE_HASH=$(sha256sum ./vscode/settings.json | awk '{ print $1 }')

	# Check if the hashes are different
	if [ "$DEST_HASH" != "$SOURCE_HASH" ]; then
		# Generate a timestamp with milliseconds (format: YYYY-MM-DD_HH-MM-SS_MS)
		TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S_%3N")

		# Create a backup with timestamp and .bak extension
		mv "$DEST_DIR/settings.json" "$DEST_DIR/settings.json.BKP_$TIMESTAMP.bak"
		echo "Backup created: settings.json.BKP_$TIMESTAMP.bak"

		# Move the new settings.json to the destination
		cp ./vscode/settings.json "$DEST_DIR"
		echo "settings.json moved to $DEST_DIR"
	else
		echo "settings.json is already up-to-date. No action taken."
	fi
else
	# If settings.json does not exist at the destination, just copy it
	cp ./vscode/settings.json "$DEST_DIR"
	echo "settings.json copied to $DEST_DIR"
fi

# Install VS Code Extensions
extensions=(
	aaron-bond.better-comments
	bocovo.dbml-erd-visualizer
	bradlc.vscode-tailwindcss
	chwoerz.ts-worksheet
	codezombiech.gitignore
	DanielSanMedium.dscodegpt
	dbaeumer.vscode-eslint
	eamodio.gitlens
	editorconfig.editorconfig
	esbenp.prettier-vscode
	foam.foam-vscode
	foxundermoon.shell-format
	github.vscode-github-actions
	Gruntfuggly.todo-tree
	hediet.vscode-drawio
	maptz.camelcasenavigation
	matt-meyers.vscode-dbml
	ms-azuretools.vscode-docker
	ms-playwright.playwright
	ms-vscode-remote.remote-containers
	mtxr.sqltools
	mushan.vscode-paste-image
	PWABuilder.pwa-studio
	qufiwefefwoyn.inline-sql-syntax
	redhat.vscode-yaml
	ritwickdey.liveserver
	shd101wyy.markdown-preview-enhanced
	streetsidesoftware.code-spell-checker
	usernamehw.errorlens
	vivaxy.vscode-conventional-commits
	YoavBls.pretty-ts-errors
	yzhang.markdown-all-in-one
	# batisteo.vscode-django
	# charliermarsh.ruff
	# esbenp.prettier-vscode
	# formulahendry.code-runner
	# foxundermoon.shell-format
	# mechatroner.rainbow-csv
	# monosans.djlint
	# ms-python.python
	# ms-toolsai.jupyter
	# ms-vscode.theme-predawnkit
	# mtxr.sqltools
	# mtxr.sqltools-driver-sqlite
	# ritwickdey.LiveServer
	# tamasfe.even-better-toml
	# teabyii.ayu
	# tomoki1207.pdf
)

# Get a list of all currently installed extensions.
installed_extensions=$(code --list-extensions)

for extension in "${extensions[@]}"; do
	if echo "$installed_extensions" | grep -qi "^$extension$"; then
		echo "$extension is already installed. Skipping..."
	else
		echo "Installing $extension..."
		code --install-extension "$extension"
	fi
done

echo "VS Code extensions have been installed."
