#!/bin/sh

# Define the URL and the output file name
URL="https://downloads.arduino.cc/arduino-ide/arduino-ide_2.3.2_Linux_64bit.zip"
OUTPUT_FILE="arduino-ide_2.3.2_Linux_64bit.zip"

# Download the file
echo "Downloading Arduino IDE..."
wget -O $OUTPUT_FILE $URL

# Check if the download was successful
if [ $? -eq 0 ]; then
    echo "Download completed successfully."

    # Extract the downloaded ZIP file
    echo "Extracting the ZIP file..."
    unzip $OUTPUT_FILE

    # Check if the extraction was successful
    if [ $? -eq 0 ]; then
        echo "Extraction completed successfully."
    else
        echo "Failed to extract the ZIP file."
    fi
else
    echo "Failed to download the file."
fi
