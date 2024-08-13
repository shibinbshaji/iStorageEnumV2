#!/bin/bash
args=("$@")
cd /var/mobile/Containers/Data/Application
cd ${args[0]}
find . -name "*.json"
find . -name "*.plist"
find . -name "*.sqlite"
find . -name "*.sql"
find . -name "*.db*"
find . -name "*.dat"
find . -name "*.bin"
find . -name "*.jpg"
find . -name "*.jpeg"
find . -name "*.png"
find . -name "*.gif"
find . -name "*.ktx"
find . -name "*.pdf"
find . -name "*.txt"
find . -name "*.text"
find . -name "*.localstorage"
find . -name "*.tmp"
find . -name "*.data"

