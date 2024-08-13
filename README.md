# iStorageEnumV2
Advanced version of iStorageEnum (https://github.com/shibinbshaji/iStorageEnum)
Used to fetch interesting files within an application's Data Directory from a **jailbroken** iOS device. Earlier version just gives a list of interesting files that are available inside an iOS applications Data Directory. The newer version downloads the file to our local machine and runs a `grep` command to possibly fetch sensitive files. I have tried to optimize it to require less input as possible.


## Installation
Just `git clone` this repo and you're good to go! Its as simple as that.

`git clone https://github.com/shibinbshaji/iStorageEnumV2.git`

## Usage (iOS)
1. Requirement: APP_ID
   
  This can be fetched using `objection`.
  
  `objection -g <App Name / Bundle Name> explore`
  
  After objection fires up the application, use `env` command to find out the environment, ie. the storage location the application writes to. A long gibberish which looks like a hash with upper case characters is the thing we are looking for.
  
2. Give necessary write permissions to the script by running the command:

`chmod +x iStorageEnumv2.sh`

Then, run the script using 

`./iStorageEnumv2.sh`

![image](https://github.com/user-attachments/assets/39982968-9d53-412a-a950-da472cbc75e5)


### Optional 
You can add the IP address of the iPhone and the username of the iPhone as environment variables. This will make it easier to run the script without having to enter these information over and over again (which is frustrating).
Add them using:

`export IPHONE_IP=192.xxx.xxx.xxx`

`export IPHONE_USER=user`

The script uses`grep` command which would be run against the words that are available in '_grepword.txt_' file. If you wish to add more words to search for, add them to this file and run the script.

## Planned Features
* Remove multiple prompts for iPhone SSH password.
* Print the output nicely to a file.
* Maybe include more test cases.


Ofcourse! You are free to contribute to the script to improve this and add new features. Reach me out on X (formerly known as Twitter) to suggest new features: shibinbshaji06.


