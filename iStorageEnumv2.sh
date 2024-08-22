#!/bin/bash

## Banner
echo "  _  _____ _                             ______                   __      _____    ___  "
echo " (_)/ ____| |                           |  ____|                  \ \    / /__ \  / _ \ "
echo "  _| (___ | |_ ___  _ __ __ _  __ _  ___| |__   _ __  _   _ _ __ __\ \  / /   ) || | | |"
echo " | |\___ \| __/ _ \| '__/ _\ |/ _\ |/ _ \  __| | '_ \| | | | '_ \ _ \ \/ /   / / | | | |"
echo " | |____) | || (_) | | | (_| | (_| |  __/ |____| | | | |_| | | | | | \  /   / /_ | |_| |"
echo " |_|_____/ \__\___/|_|  \__,_|\__, |\___|______|_| |_|\__,_|_| |_| |_|\/   |____(_)___/ "
echo "                        __/ / "                                                   
echo "                       |___/ "                                                    


echo ""
echo "Tip: We recommend setting the IP address of the iPhone and username as global variable to make the script easier to execute multiple times."
echo "Tip: Want to add more words for grep search? Add them to the file grepwords.txt"
echo ""

## Check if sshpass is available. If not, exit.
if ! command -v sshpass &> /dev/null
then
    echo "The script requires 'sshpass' to be installed. Install using 'sudo apt install sshpass'"
    echo ""
    exit 1
fi

## Check if sftp is available. If not, exit.
if ! command -v sftp &> /dev/null
then
    echo "The script requires 'sftp' to be installed. Install using 'sudo apt install sftp'"
    echo ""
    exit 1
fi

## Check if ssh is available. If not, exit.
if ! command -v ssh &> /dev/null
then
    echo "The script requires 'ssh' to be installed. Install using 'sudo apt install ssh'"
    echo ""
    exit 1
fi

## Check if grep is available. If not, exit.
if ! command -v grep &> /dev/null
then
    echo "The script requires 'grep' to be installed. Install using 'sudo apt install grep'"
    echo ""
    exit 1
fi

## If the environment variable IPHONE_IP is not set, ask for IP. If set, use that.
if [[ -z "${IPHONE_IP}" ]]; then
	read -p "Enter IP of iPhone:" iphoneip
else
  	iphoneip="${IPHONE_IP}"
  	echo -e "\033[33m [+] Using the IP ($iphoneip) from the environment variable\033[0m"
fi

## If the environment variable IPHONE_USER is not set, ask for USER. If set, use that.
if [[ -z "${IPHONE_USER}" ]]; then
	read -p "Enter Username of iPhone:" iphoneuser
else
  	iphoneuser="${IPHONE_USER}"
  	echo -e "\033[33m [+] Using the Username ($iphoneuser) from the environment variable\033[0m"
fi


echo ""
## Get the Binary name.
read -p "Enter the Binary file name from objection:" binaryname
echo -e "\033[33m [+] Enumerating files from phone!\033[0m"
## Done!

## SSH into the iphone and get the file names in files_1.txt
ssh $iphoneuser@$iphoneip 'bash -s' < browseStorage.sh $binaryname > files_1.txt
## SSH complete

## File Cleanup
echo -e "\033[33m [+] Cleaning up the output\033[0m"
sed 's/^\.\.\?\///g' files_1.txt > files_2.txt
sed 's/ /\\ /g' files_2.txt > files_3.txt
sed 's/^/get \/var\/mobile\/Containers\/Data\/Application\/'$binaryname'\//' files_3.txt > files_to_download
## File cleanup done! file name is files_to_download

## Remove temporary files
echo -e "\033[33m [+] Removing temporary files\033[0m"
rm files_1.txt
rm files_2.txt
rm files_3.txt
## Removed temporary files!
## in the future, optimize this by deleting the files right after the sed commands

## Make a folder with the binary name
echo -e "\033[33m [+] Making directory with the binary name\033[0m"
mkdir -p $binaryname

## cd into the directory. Will be refering to / from here
echo -e "\033[33m [+] Moving inside the new directory\033[0m"
cd $binaryname
## inside /

#################################### NOT WORKING!!! FOR FUTURE USE #############################

## Setting default password for ssh | not working as of now. 
echo -e "\033[33m [+] Using the default password for SSH in iPhone\033[0m"
export SSHPASS='alpine'

echo -e "\033[33m [+] Setting filename..\033[0m"

echo -e "\033[33m [+] Fetching files...\033[0m"
export SSHPASS='alpine'

#################################### NOT WORKING!!! FOR FUTURE USE #############################


#################################### SFTP and download the files #############################

## mkdir and cd into files folder
mkdir -p files
cd files
## inside /files

## fetching from the files_to_download (outside of /) 
filename='../../files_to_download'
sshpass -e sftp -oBatchMode=no -b $filename $iphoneuser@$iphoneip
echo -e "\033[33m [+] Files saved to directory!\033[0m"

#################################### SFTP and download completed #############################

## Exit back to /
cd ..

## Making new directory - /strings
mkdir -p strings

## Moving back to /files
cd files

############################ Converting to strings and storing it in /strings ###########################

for i in ./*; do strings $i > ../strings/$i.txt; done
echo "Converting to readable strings and storing it in $binaryname/strings folder"

#################################### Conversion Completed #############################

## moving out from /strings to /
cd ..
## Making new directory /GREP-results
mkdir -p GREP-results
## Moving back into /strings
cd strings

#################################### Searching for Base64 Values #############################
## if found, store it in ../base64.txt
echo -e "\033[33m [+] Searching for Base64 values\033[0m"
grep -rho "eyJ[A-Za-z0-9+/=]*" | sed 's/$/\n/' > ../base64.txt

#################################### Search complete #############################

#################################### Searching for keywords from grepwords.txt #############################

echo -e "\033[33m [+] Searching for keywords\033[0m"

while IFS="" read -r p || [ -n "$p" ]
do
	echo "Searching for keyword: "
	echo -e "\033[33m $p\033[0m"
  	grep -EHrin $p | sed G > ../GREP-results/$p.txt

done < ../../grepwords.txt

#################################### Search Complete! #############################

## Move into /GREP-results
cd ../GREP-results
## Delete empty files
find . -empty -type f -delete

echo -e "\033[33m Results will be available in $binaryname/GREP-results\033[0m"
