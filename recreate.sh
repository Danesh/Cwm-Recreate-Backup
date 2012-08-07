#!/bin/sh
if [ $# -le 2 -o $# -gt 3 ]; then
    echo "Usage : <dup file> <where to place files> <blob folder>"
    exit
fi
if [ ! -f "$1" ]; then
    echo "$1" does not exist
fi
if [ -d "$2" ]; then
    read -p "\"$2\" already exists, want to overwrite (y/n) ? : " ans
    if [ "$ans" != "y" ]; then
        exit
    fi
else
    mkdir $2
fi
if [ ! -d "$3" ]; then
    echo "$3" does not exist
    exit
fi
while read line
do
if [ "$line" != "dedupe	2" ]; then
    type=$(echo $line | cut -d " " -f1)
    item=$(echo $line | cut -d " " -f8)
    hashFolder=$(echo $line | cut -d " " -f9 | cut -d "/" -f1)
    hashFile=$(echo $line | cut -d " " -f9 | cut -d "/" -f2)
    if [ "$type" = "f" -a ! -z "$hashFolder" -a ! -z "$hashFile" ]; then
        if [ -f "$3/$hashFolder/$hashFile" ]; then
            cp "$3/$hashFolder/$hashFile" "$2/$item"
        else
            echo "No blob for " $item " found"
        fi
    else
        mkdir -p $2/$item
    fi
fi
done < "$1"
