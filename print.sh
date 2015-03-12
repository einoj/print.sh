#! /bin/bash
#===================================================================================================
# Description: print.sh is a program for printing files from a UiO printer from a personal laptop.
# It uses scp to transfer the files and prints the file using ssh and ppr.
# Dependencies: scp, ssh
# Author: einoj
# Devel version is available at https://github.com/einoj/print.sh
#====================================================================================================
VERSION="1.0"
#====================================================================================================
# The MIT License (MIT)
# 
# Copyright (c) 2015 Eino J. Oltedal
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#====================================================================================================

# chane username to your uio username
username="einojo"
red="\033[0;31m"
green="\033[0;32m"
nc="\033[0m"
usage="Usage: print filename printername"

if [ "$#" -ne 2 ]
then
  echo $usage
  exit 1
fi

filename=$1
printer_name=$2
printer_not_found="Server priss.uio.no:"
server="@login.ifi.uio.no"
file_path="tmp/"
printf "\nChecking if printer exists...  "
queue_msg=$(ssh $username$server ppq -P $printer_name 2> /dev/null) 

if [ "$queue_msg" == "$printer_not_found" ]
then
  echo -e "${red}FAIL${nc}"
  echo -e "No printer named $printer_name\n"
  echo $usage
  exit 1
fi

echo -e "${green}OK${nc}"

printf "Checking if file exists...     "
if [ ! -f $filename ]
then
  echo -e "${red}FAIL\n${nc}"
  echo $usage
  exit 1
fi

echo -e "${green}OK${nc}"
# send the file to be printed to uio
printf "Transferring file...           "
scp -q $filename $username$server":"$file_path
echo -e "${green}OK\n${nc}"

#remove path specifiers from the filename so only the filname remains.
filename=$(echo $filename | sed 's/.*\///')
echo -e "Printing $filename...\n"
#print file. -Xduplex=true enables printing on both sides of the paper.
ssh $username$server "ppr -Xduplex=true -v -P $printer_name $file_path$filename && rm $file_path$filename"
