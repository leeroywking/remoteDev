# Beginners guide to setting up VS Code's Remote Development plugin pairing with a free-tier AWS EC2 Instance for a better Windows based web developer experience.

This guide would be good for any developer who finds that their local development environment is resource constrained. Either through poor network performance or in my case because the Ubuntu WSL took four and a half minutes to run create-react-app. I made gifs of the steps and did my best to type out actual steps that I did in the gifs.

## Assumptions 
- You have access to an AWS free tier account[1]
- You are using a version of windows/unix/linux that has `ssh` available to the command line[2] (this guide is for Windows because unix/linux is honestly a lot more straightforward)
- You use VScode
- stable(ish) internet connection



## Step 1 create a free tier EC2 instance
- As of this writing the t2.micro is still the free tier offering for AWS accounts, this guide will work with any instance size but the examples are written around the t2.micro
- Create the ec2 instance
  ![Launch a new Instance](https://github.com/leeroywking/remoteDev/blob/master/gifs/instance1.gif)
  - 1 Open your AWS management console and open the EC2 dashboard
  - 2 Click on the launch instance button
  - 3 choose your linux flavor of choice, for this demo I will be using ubuntu 18.04
  - 4 accept defaults for the instance size (t2.micro or whatever is free today), storage, and security groups
  - Create and save your pem key I suggest a short name and an easy to path location.
- confirm you can connect to the instance from the command line
  - change your sshkey permissions 
  ![changing permissions](https://github.com/leeroywking/remoteDev/blob/master/gifs/modifyPemKey.gif)
    - 1 Right click on sshkey and click the properties 
    - 2 click on the security tab
    - 3 Click on Advanced
    - 4 click disable inheritance and convert inherited permissions
    - 5 start removing users leaving only one
    - 6 exit the advanced menu
    - 7 click edit users
    - 8 click add
    - 9 add a specific user (I use my main account on this machine "lee")
    - 10 remove all other permissions from the file

  - ![connecting to instance](https://github.com/leeroywking/remoteDev/blob/master/gifs/connectToInstance.gif)
    - In the AWS Console click on your instance and then click the button labeled "connect"
    - This should show you a string that looks something like this ```ssh -i "sshkey.pem" ec2-user@ec2-34-219-68-139.us-west-2.compute.amazonaws.com ```
    - We are going to modify it slightly so that it works in a windows machine and uses an absolute path to our key
    - I saved my key in the root directory of my C: drive to keep this example short
    - ``` ssh -i C:\sshkey.pem ec2-user@ec2-34-219-68-139.us-west-2.compute.amazonaws.com```
    - right now just ssh to the instance and make sure it works before we bring vscode into this
    - Save this command we will need it in a little bit

 ## Step 2 install remote development extension for VScode
- ![Install remote Development VS Code extension](https://github.com/leeroywking/remoteDev/blob/master/gifs/remoteDevSetup.gif)
  - click on the extensions tab in VS Code
  - search for ```Remote Development```
  - install it, a new button should show up under your extensions button.
  - click on the new button for remote development
  - click the "+" symbol to add a new SSH target 
  - paste the command from before into the prompt that opens at the top of VS Code
  - there is a bug right now in how it parses that command so you will need to slightly modify the configuration file this creates 
  - click on the gear and then whichever configuration file you specified before
  - you will see your new configuration for the remote server here and there is a problem with the file path
  - Where it says ```C:sshkey.pem``` we have to change that to ```C:\sshkey.pem```.
  - After that change it should work so click the folder to open the connection
## Step 3 configuring server for web development
- ![Setting up workspace](https://github.com/leeroywking/remoteDev/blob/master/gifs/settingUpWorkspace.gif)
  - I use nodejs as my daily driver so NVM is a must have for me. You can get a one-liner for installing it from [NVM github](https://github.com/nvm-sh/nvm)
  - ```wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.1/install.sh | bash ```
  - NVM changes your .bashrc file for the aliases so I source the bashrc file 
  - ```source .bashrc ```
  - next use nvm to install the latest version of node
  - ``` nvm install node ```
  - then you use npm to install create-react-app
  - ``` npm i -g create-react-app ```
  - if you are feeling daring here are all of them in one shot
  - last create a new react app!
  - ``` create-react-app demo ```

  - ```bash
  wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.1/install.sh | bash ;
  source .bashrc ;
  nvm install node ;
  npm i -g create-react-app ;
  create-react-app demo ;
  ```
- ![Launching React](https://github.com/leeroywking/remoteDev/blob/master/gifs/launchingReact.gif)
- ![Adding a Local Forward](https://github.com/leeroywking/remoteDev/blob/master/gifs/addingLocalForward.gif)







[1]: Please be careful with AWS free tier, set up a budget and alerts for if you go over, as of this writing they will not default to warn you when you are going to spend money. This guide should only use free tier resources but that is no substitute for setting up alerts.

[2]: Example of ssh working (this is in cmd on windows)
```powershell
C:\Users\dev>ssh
usage: ssh [-46AaCfGgKkMNnqsTtVvXxYy] [-B bind_interface]
           [-b bind_address] [-c cipher_spec] [-D [bind_address:]port]
           [-E log_file] [-e escape_char] [-F configfile] [-I pkcs11]
           [-i identity_file] [-J [user@]host[:port]] [-L address]
           [-l login_name] [-m mac_spec] [-O ctl_cmd] [-o option] [-p port]
           [-Q query_option] [-R address] [-S ctl_path] [-W host:port]
           [-w local_tun[:remote_tun]] destination [command]
```