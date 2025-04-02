#!/bin/bash

# This script reads KIC IDs from matching_kic_ids.txt and finds matching entries in hlsp_iris_kepler_kepler_q01_kepler_v1.0_download

# First, check if the files exist
if [ ! -f "matching_kic_ids.txt" ]; then
    echo "Error: matching_kic_ids.txt not found!"
    exit 1
fi

if [ ! -f "hlsp_iris_kepler_kepler_q01_kepler_v1.0_download.sh" ]; then
    echo "Error: hlsp_iris_kepler_kepler_q01_kepler_v1.0_download not found!"
    exit 1
fi

echo "Creating filtered download script for Quarter 1..."

# Create a new script with the shebang line
echo "#!/bin/sh" > download_filtered_q01.sh

# Create a temporary sorted file of KIC IDs for faster searching
sort matching_kic_ids.txt > sorted_kic_ids.txt

# Initialize a counter for matches
match_count=0

# Process each line in the download script
while IFS= read -r line; do
    # Skip shebang lines and empty lines
    if [[ $line == \#\!* ]] || [[ -z "$line" ]]; then
        continue
    fi
    
    # Extract KIC ID from the download URL
    # Pattern looks like kplrXXXXXXXXX where XXXXXXXXX is the KIC ID with leading zeros
    if [[ $line =~ kplr0*([0-9]+) ]]; then
        # Get the KIC ID without leading zeros
        kic_id="${BASH_REMATCH[1]}"
        
        # Check if this KIC ID is in our sorted file
        if grep -q "^$kic_id$" sorted_kic_ids.txt; then
            echo "$line" >> download_filtered_q01.sh
            ((match_count++))
            echo "Found match for KIC $kic_id"
        fi
    fi
done < hlsp_iris_kepler_kepler_q01_kepler_v1.0_download.sh

# Clean up the temporary file
rm sorted_kic_ids.txt

# Make the new script executable
chmod +x download_filtered_q01.sh

echo "--------------------------------------------"
echo "Created download_filtered_q01.sh with $match_count matching KIC IDs"
echo "Run ./download_filtered_q01.sh to download the filtered FITS files"