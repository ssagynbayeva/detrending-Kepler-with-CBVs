#!/bin/bash

# This script organizes FITS files into directories based on their quarter number
# Example: hlsp_iris_kepler_kepler_kplr005023817-q01_kepler_v1.0_lc.fits -> Q01/

echo "Starting to organize FITS files by quarter..."

# Print some of the files to see their pattern
echo "Sample of FITS files in current directory:"
ls *.fits | head -5

# Ensure we have at least some files
file_count=$(ls *.fits 2>/dev/null | wc -l)
if [ "$file_count" -eq 0 ]; then
    echo "Error: No FITS files found in the current directory!"
    exit 1
fi

# Create an array of all possible quarters (01-17)
quarters=({01..17})

# Create directories for each quarter if they don't exist
for q in "${quarters[@]}"; do
    mkdir -p "Q$q"
    echo "Created directory Q$q (if it didn't already exist)"
done

# Counter for moved files
total_moved=0

# Try different pattern matching approaches
echo "Looking for files with q## pattern in filename..."

for file in *.fits; do
    # Skip if no matches found
    if [ ! -f "$file" ]; then
        continue
    fi
    
    # Print file for debugging
    echo "Examining file: $file"
    
    # Extract quarter information using regex
    if [[ $file =~ q([0-9][0-9]) ]]; then
        quarter="${BASH_REMATCH[1]}"
        echo "Found quarter $quarter in filename $file"
        
        # Move the file to the appropriate directory
        mv "$file" "Q$quarter/"
        echo "Moved $file to Q$quarter/"
        ((total_moved++))
    else
        echo "No quarter pattern found in $file"
    fi
done

echo "--------------------------------------------"
echo "Finished organizing files. Moved $total_moved files in total."
echo "If no files were moved, please run 'ls -la' and share a few example filenames."