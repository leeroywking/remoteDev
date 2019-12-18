# Beginners guide to remote development using AWS free tier

This guide would be good for any developer who finds that their local development environment is resource constrained. Either through poor network performance or in my case because the ubuntu WSL took four and a half minutes to run create-react-app.

## Assumptions 
- You have access to an AWS free tier account[1]
- You are using a version of windows/unix/linux that has `ssh` available to the command line[2]
- You use VScode



## Step 1 create a free tier EC2 instance
- As of this writing the t2.micro is still the free tier offering for AWS accounts, this guide will work with any instance size but the examples are written around the t2.micro
- Create the ec2 instance
  - 1 ![Launch a new Instance](https://github.com/leeroywking/remoteDev/blob/master/instancecreation/insance1.gif)
  - 2
  - 3
  - Save your ssh key somewhere that you can path to easily for this example I will save it at my root directory C:\sshkey.pem
  - 5
- confirm you can connect to the instance from the command line
 - ``` ssh -i C:\sshkey.pem ec2-user@ec2-34-219-68-139.us-west-2.compute.amazonaws.com```
 - if this works then you should save this command and move to the next step

 ## Step 2 install remote development extension for VScode
- 1
- 2
- 3
- 4
- 5

 ## Step 3 Connect and configure
- vs code steps
  - 1
  - 2
  - 3
- remote steps
  - 1
  - 2
  - 3








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