# print.sh
This bash script lets a user at uio print a file from their local computer without intstalling any additional software.
The only dependencies are scp, ssh, and a user at the University of Oslo.

#How to use
Change the variable username to your uio username:
```
username="yourusername"
```
Then run the script
```
./print.sh filename printername
```
#How to install
It is not necessary to install the script to use it.
However if you want any user to be able to use the script you can run the install script.
```
sudo ./install.sh
```
This will install print.sh under /usr/bin and create a symbolic link /usr/bin/print -> /usr/bin/print.sh.
WARNING THE INSTALL SCRIPT WILL OVERWRITE ANY FILE NAMED /usr/bin/print
The program can then be used by any user like this:
```
print filename printername
```
