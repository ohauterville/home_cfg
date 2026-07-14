#!/bin/bash

# Get the absolute path of the root directory (home_cfg)
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Starting global installation process..."

# Find all 'install.sh' files in subdirectories (minimum depth 2 to avoid the root dir)
# We store them in an array to handle paths with spaces safely
mapfile -t INSTALL_SCRIPTS < <(find "$ROOT_DIR" -mindepth 2 -name "install.sh" -type f)

# Check if any scripts were found
if [ ${#INSTALL_SCRIPTS[@]} -eq 0 ]; then
    echo "No install.sh scripts found in subdirectories."
    exit 0
fi

# Iterate over each found script
for script in "${INSTALL_SCRIPTS[@]}"; do
    # Get the relative path for cleaner output
    rel_path="${script#$ROOT_DIR/}"
    
    echo "--------------------------------------------------------"
    echo "Processing: $rel_path"
    
    # Make the script executable
    chmod +x "$script"
    
    # Execute the script
    # Running it via its absolute path
    "$script"
    
    # Check the exit status of the script
    if [ $? -ne 0 ]; then
        echo "Warning: $rel_path exited with a non-zero status."
    else
        echo "Successfully completed: $rel_path"
    fi
done

echo "--------------------------------------------------------"
echo "Global installation process finished."
