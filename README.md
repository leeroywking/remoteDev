# Beginners guide to setting up VS Code's Remote Development plugin pairing with a free-tier AWS EC2 instance for a better Windows based web developer experience.

## Why do this?
This guide would be good for any developer who finds that their local development environment is resource constrained. Either through poor network performance or, in my case, because the Ubuntu WSL took four and a half minutes to run create-react-app. Remote development can free up your local system resources and provide access to significantly higher network bandwidth for people with slow internet connections. I picked Windows 10 and AWS because Windows 10 is very prolific and I saw people new to development stuggling with Windows Unix support. I chose AWS because I am more experienced with AWS than I am with the other cloud providers. 

## Assumptions 
- You have access to an AWS free tier account[1]
- You are using a version of Windows that has `ssh` available in the command line (Win 10 should be fine as of April 2018)
- You use VScode
- Stable(ish) internet connection
- As of today the t2.micro is still the free tier offering for AWS account. This guide will work with any instance size but the examples are written around the t2.micro



## Step 1: Create a free tier EC2 instance
- To launch a new instance:
  1.  Open your [AWS management console](https://aws.amazon.com/console/) and open the EC2 dashboard
  1. Click the launch instance button
  1. Select Ubuntu Server 18.04 LTS
  1. Select instance size (t2.micro or whatever is free today)
  1. Click **Review and Launch** then click **Launch**. A dialogue will open titled **Select an existing key pair or create a new key pair**
  1. In the first dropdown, select **Create a new key pair**
  1. Enter a name for your key pair. For this example, I will name the key ```sshkey``` 
  1. Click **Download Key Pair**. If you are using Chrome, the download will appear in the bottom left corner of your browser
  1. Click launch instance
  1. Move `sshkey.pem` from your downloads folder to `C:\sshkey.pem`
    Instructions for Chrome:
    1. Select **Show in folder** from the carrot symbol on the download
    1. Right click the folder name and select **cut**
    1. Go to **This PC** on the left hand side
    1. Go to **Local Disk** and in the folder, right click and select **paste**. This will prompt you for administrator permission to move. Click continue
-  Change your sshkey permissions
     - Amazon wont let you connect to an instance with an ssh key that is readable to other users on the system. Here is how we ensure other users on our system do not have permissions to the ssh key file. 
   - Open your powershell prompt
     - open your start menu and start typing ```powershell``` then click on **Windows Powershell** when you see it to open the terminal
     - should open to `C:\Users\yourusername`
     - type `cd /` (this will also work `cd \` )
     - this should bring you to `C:\` 
     - paste the following commands into your powershell prompt (if you did not name your keypair sshkey then you will need to modify these commands before you enter them)
```powershell
$acl = Get-Acl .\sshkey.pem
$acl.SetAccessRuleProtection($true,$false)
$whoami = whoami
$Ar = New-Object  system.security.accesscontrol.filesystemaccessrule("$whoami","FullControl","Allow")
$acl.SetAccessRule($Ar)
Set-Acl .\sshkey.pem $acl
``` 
- Confirm you can connect to the instance from the command line. To confirm:
    - In the AWS Console click on your instance and then click the button labeled **Connect**
    - This should show you a string that looks something like this ```ssh -i "sshkey.pem" ec2-user@ec2-34-219-68-139.us-west-2.compute.amazonaws.com ```
    - If you are still at ```C:\``` you should be able to copy and paste this command into your powershell prompt
    - after you copy/paste and hit enter you should see confirmation that the connection worked. You may need to type ```yes``` when prompted if you would like to trust the key the server is presenting
    - Save this command we will need it in a little bit

 ## Step 2 install remote development extension for VScode
- Installing remote development VS Code extension
   - click on the extensions tab in VS Code
   - search for ```Remote Development```
   - install it, a new button should show up under your extensions button
   - use the dropdown to select **SSH TARGETS**
   - click on the new button for remote development
   - click the "+" symbol to add a new SSH target 
   - paste the command from before into the prompt that opens at the top of VS Code
   - select the top configuration file
   - something like **C:\Users\lee\\.ssh\config**
   - there is a quirk right now in how it parses that command so you will need to slightly modify the configuration file this creates to fix that we have to change the path for the ssh key
     - click on the gear and then whichever configuration file you specified before
     - you will see your new configuration for the remote server here and there is a problem with the file path
     - Where it says ```sshkey.pem``` we have to change that to ```C:\sshkey.pem```
     - save the changes to the configuration file
    - After that change it should work so click the folder to open the connection
## Step 3 configuring server for web development and creating a React app
  - The following command will install NVM, node, npm, the npm package create-react-app and then create a new react app named demo
  - To open a new terminal in vscode look for the **Terminal** drop down menu at the top of the window, click on **New Terminal** or press the **Ctrl+Shift+`** and paste the following commands into it. (go to step 5 after they finish)
  
  
```
wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.1/install.sh | bash ;
source .bashrc ;
nvm install node ;
npm i -g create-react-app yarn;
create-react-app demo ;
```
  

  ## Step 4 Adding a local port forward for an even more convenient development experience
  - Open your remote development extension
  - Open the settings file by clicking on the gear and then clicking on configuration file you made for this in step 2
  - Add this line to the end of the configuration 
  - ```LocalForward 127.0.0.1:3000 127.0.0.1:3000 ```
  - You can use whatever port you normally use here but create-react-app defaults to 3000 so thats what I use in this example
  - You have to exit out and then reconnect to your remote server
  - When you do this your ssh connection will also forward the designated port on your local machine through the ssh connection to your remote development env. This means its as secure as your connection is and as convenient as opening your web browser and navigating to ``` http://localhost:3000 ```
## In closing
  - There are a lot of advantages to remote development
    - Its free
    - network placement (run a speedtest its great)
    - leveraging resources outside your local computer
    - Its Linux so no more WSL/linux emulation on Windows
  - There are also disadvantages
    - you probably can't work on an airplane
    - While SSH is pretty bandwidth friendly it does still require an active internet connection
    - For modern web frameworks you might have to modify system variables for monitoring the filesystem for changes since the default maximum number of files that can be modified is fairly low. (VS Code can walk you through this, you can see me close the tooltip in one of the gifs)
  - If there is interest I would love to do a version of this guide for different cloud/OS combinations. 
  
[1]: Please be careful with AWS free tier, set up a budget and alerts for if you go over, as of this writing they will not default to warn you when you are going to spend money. This guide should only use free tier resources but that is no substitute for setting up alerts.
