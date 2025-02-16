# noaa-uploader
A script used to automatically upload noaa/meteor images from raspberry-noaa-v2 to an FTP server


# 1. Installing the script
You essentially have 2 ways of installing the script, automatically or manually.

## Automatic (simple) way
You can install the script automatically by running a single command.
```sh
sudo bash -c "$(curl -s https://raw.githubusercontent.com/Lopastudio/noaa-uploader/refs/heads/main/installer.sh)"
```
This command will launch the installer directly from github so you can configure everything without even touching any linux garbagio.

## MANUAL (gigachad) WAY <br> <img src="https://i.pinimg.com/originals/25/bd/8b/25bd8b7f6e57cdfd17747b25d753b2ce.jpg" width="50" height="50"> 


First things first, change the directory to your home (or where you want the script to exist):
```sh
cd ~
```
It can be any directory, but I recomend your home directory, because it is guaranteed to work in there :) [that is what the ~ is, your home directory]

Next, paste the script into a file, using nano:
```sh
nano uploader.sh
```
it will open up a text editor, where you need to paste the `uploader.sh` file.

Now with the script pasted, you **WILL NEED TO CONFIGURE** the FTP credentials and directories.

Next, to exit and save the thing, just press CTRL + X, then Y and finally enter to save (thanks, networkchuck)

You will also need to add a permission to the script to make it executable. That can be done with this command:
```sh
sudo chmod +x uploader.sh
```

Finally, you should install the FTP dependency, using this command (debian/ubuntu/rasbian OS assumed) [if using some other linux distro, pls utfg (use the fricking google) to find the correct command]:
```sh
sudo apt-get install ftp curl -y
```

And we are finished. Just run this script and you are good to go. But it is not automatic YET. To make it automatic, there is the next chapter.

### Making it automatic (optional)

If you want to make this script run automatically, we´ll use crontab. 
To open the crontab config, you need to run this command:
```sh
crontab -e
```
choose your editor of choice (I recommend nano, because it is the easiest and we already used it a few steps earlier) and add the following text to the bottom of the file:

```
# Automatic FTP uploader for images
0 0 * * * /home/patrik/uploader.sh 
```
*Of course, you will need to **change the directory name** to where you installed the script in chapter 1.*

And you are good to go. To finalize, just restart your RPi with a simple command and the script should run every 24 hours, and automatically upload.
The time intervals can be adjusted in the crontab config file. [google finds it easily]
```sh
sudo reboot
```
Restarting is **NOT REQUIRED** but it always helps to prevent any random issues from occuring.

*I recommend running the script manually, to see if it works, to save you time and headaces.*


# What now?
Now the script is installed and SHOULD be working without any issues. If you want to customize the script, feel free to do so. 
Here are some potential modifications you may want to do:

## 1. Only uploading certain files
*[This MOD made by KD7AAT]*

If you want to only upload certain files, like John [KD7AAT] wanted to do, you can simply add the following to the FTP part of the script (on the bottom). Insted of

```sh
mput *
```
which uploads all of the contents of the directory, you can change it to:
```sh
mput *MCIR.jpg
mput *MSA.jpg
mput *spread_67.jpg
```
to, in this case, only upload files ending in [thats what the * is for] MCIR.jpg, MSA.jpg and spread_67.jpg.

## 2. well... no more mods, for now
If you have any ideas for modifications that can be applied to my script, feel free to open a pull request and write it into this readme file, or email me to "patrik.nagy@lopastudio.sk" THX :)


---
---

## License shinanigans
This project is licensed under the GNU GENERAL PUBLIC LICENSE v3 (GPL-3.0), which means:


-  You are free to use, modify, and distribute the project, either in its original form or modified, as long as you adhere to the terms of this license.
- When you distribute the modified code, you must make the source code available and provide the same license (GPL-3.0) with the distributed code.
- You cannot impose any additional restrictions on the rights granted by this license.
- The project comes with no warranty—use it at your own risk.

So you can basically do anything with it, cool :D