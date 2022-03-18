#!/bin/bash

#Description: Automates installation of SonarQube in Linux (Centos)
#Author: James K
#Date: March 17, 2022

#Installation need to be done using a regular user account.
echo "Checking to ensure user is logged in a regular user:"
sleep 2
if [ ${USER} = root ]
then
echo "You cannot install SonarQube as a root user. Please logout and log back in as a regular user..."
sleep 2
exit 1
else
echo "You are logged in as a regular user. Installation will proceed shortly....."
fi

#Java 11 Installation
echo "Installing Java 11...."
sleep 2
sudo yum update -y
sudo yum install java-11-openjdk-devel -y 

if [ $? -ne 0 ] then echo "Installation of Java 11 failed. Cannot proceed with SonarQube installation...."
sleep 2
exit 2
fi

#Downloading SonarQube's latest version
echo "Downloading the latest version of SonarQube...."
sleep 2
cd /opt  
sudo yum install wget -y
sudo wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-9.3.0.51899.zip

if [ $? -ne 0 ] then echo "Installation of latest version of Sonarqube failed...."
sleep 2
exit 3
fi 

#Extracting packages
echo "Extracting packages...."
sleep 2
sudo yum install unzip -y
sudo unzip /opt/sonarqube-9.3.0.51899.zip

if [ $? -ne 0 ] then echo "Extraction of files failed...."
sleep 2
exit 4
fi 

#Changing ownership to user and switching to linux binaries directory to start service
echo "Changing ownership to user and switching to linux binaries directory to start service....."
sleep 2
sudo chown -R vagrant:vagrant /opt/sonarqube-9.3.0.51899
cd /opt/sonarqube-9.3.0.51899/bin/linux-x86-64
./sonar.sh start

if [ $? -ne 0 ] then echo "Failed to start service...."
sleep 2
exit 5
fi 

#Ensuring firwewall is not enabled
echo "Opening port 9000 just in case firewall is enabled...."
sleep 2
sudo firewall-cmd --permanent --add-port=9000/tcpcd 
sudo firewall-cmd --reload

#Checking IP address
IP = `hostname -I`
echo "This is your IP address:$IP"
sleep 2
echo "Type the folling into your brower: $IP:9000"
