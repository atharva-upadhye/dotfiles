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
		mv "$DEST_DIR/settings.json" "./vscode/settings.json.BKP_$TIMESTAMP.bak"
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

# Ask the user if they want to install recommended extensions
read -p "Do you want to install recommended VS Code extensions? (y/n): " install_extensions

if [[ "$install_extensions" == "y" || "$install_extensions" == "Y" ]]; then
	# Read extensions from vscode/extensions.jsonc
	if [ -f "./vscode/extensions.jsonc" ]; then
		# # Extract recommended extensions using jq (you might need to install jq if not installed)
		# extensions=$(jq -r '.recommendations[]' ./vscode/extensions.jsonc)

		# Use sed to remove comments (lines starting with // or /* ... */)
		cleaned_json=$(sed '/^\s*\/\//d; /^\s*\/\*/,/\*\//d' ./vscode/extensions.jsonc | perl -0777 -pe 's/\s*,\s*(\}|\])/\1/g')

		# Use jq to extract recommendations from cleaned JSON
		extensions=$(echo "$cleaned_json" | jq -r '.recommendations[]')

		# # Get a list of all currently installed extensions
		# installed_extensions=$(code --list-extensions)

		# # Loop through recommended extensions and install them if not already installed
		# for extension in $extensions; do
		# 	if echo "$installed_extensions" | grep -qi "^$extension$"; then
		# 		echo "$extension is already installed. Skipping..."
		# 	else
		# 		echo "Installing $extension..."
		# 		code --install-extension "$extension"
		# 	fi
		# done

		echo "VS Code extensions have been installed."
	else
		echo "No extensions.jsonc file found, skipping extension installation."
	fi
else
	echo "Skipping extension installation."
fi
