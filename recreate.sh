#!/bin/sh

#Validate number of arguments
if [ $# -le 2 -o $# -gt 3 ]; then
    echo "Usage : <dup file> <where to place files> <blob folder>"
    exit
fi

#Assign arguments to variables for clarity
dupFile="$1"
outputFolder="$2"
blobFolder="$3"

#Confirm dupFile is present
if [ ! -f "$dupFile" ]; then
    echo "$dupFile" does not exist
fi

#Check if outputFolder already exists, if it does then ask for overwrite
#permission. If it doesnt exist, create it.
if [ -d "$outputFolder" ]; then
    read -p "\"$outputFolder\" already exists, want to overwrite (y/n) ? : " ans
    if [ "$ans" != "y" ]; then
        exit
    fi
else
    mkdir $outputFolder
fi

#Confirm blobFolder is present
if [ ! -d "$blobFolder" ]; then
    echo "$blobFolder" does not exist
    exit
fi

#Loop through dupFile and parse its contents.
#Copy and rename the blobs and create the tree accordingly.
while read line; do
if [ "$line" != "dedupe	2" ]; then
    type=$(echo $line | cut -d " " -f1)
    item=$(echo $line | cut -d " " -f8)
    hashFolder=$(echo $line | cut -d " " -f9 | cut -d "/" -f1)
    hashFile=$(echo $line | cut -d " " -f9 | cut -d "/" -f2)
    if [ "$type" = "f" -a ! -z "$hashFolder" -a ! -z "$hashFile" ]; then
        if [ -f "$blobFolder/$hashFolder/$hashFile" ]; then
            cp "$blobFolder/$hashFolder/$hashFile" "$outputFolder/$item"
        else
            echo "No blob for " $item " found"
        fi
    else
        mkdir -p $outputFolder/$item
    fi
fi
done < "$dupFile"
