# Setup a New Developer Computer

This script will help with the quick setup and installation of tools and applications for new computer.    
Original work by the awesome people at Vendasta. This repo was forked from https://github.com/vendasta/setup-new-computer-script/ but has been heavily modified.

## Installation Instructions

* Open Terminal and navigate to where you want to save the installation files. You can remove these later.
* Run the installation executable:
   ```sh
   sh -c "$(curl -fsSL https://raw.githubusercontent.com/Sandmania/setup-new-computer-script/master/install.sh)"
   ```
* Some installs will need your password
* You will be promted to fill out your git email and name. Use the email and name you use for Github


<br><br>


## Post Installation Instructions
Afer you have run the script, please complete the following steps to finish setting up your computers:

   
1. **Github Command-line SSH Authentication**\
   Do the following to authorize Github on your computer:
   - [Generate an SSH key for your new computer][generate key]
   - [Add the SSH public key to your Github account][add to github]
     
   [generate key]: https://help.github.com/en/github/authenticating-to-github/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent
   [add to github]: https://help.github.com/en/github/authenticating-to-github/adding-a-new-ssh-key-to-your-github-account
   
2. **Accept profile installation**
   The script installs a new macOs profile which enables immediate password prompt on screensaver. You need to accept the installation of this profile from System Preferences -> Profiles
<br><br>


## Post Installation Tips

**Fix ZSH Errors**\
If you are using ZSH as your shell (default in newer Mac OS versions) you may get this error after running the setup script:
 
> zsh compinit: insecure directories, run compaudit for list.\
> Ignore insecure directories and continue [y] or abort compinit [n]?

You can fix this by running the following command in your terminal:
```sh
compaudit | xargs chmod g-w
```

<br>
  
**Keeping your tools up-to-date**\
Homebrew can keep your commandline tools and languages up-to-date.
```sh
# List what needs to be updated
brew update
brew outdated
 
# Upgrade a specific app/formula (example: git)
brew upgrade git

# Upgrade everything
brew upgrade
  
# List previous versions installed (example: git)
brew switch git list
 
# Roll back to a currently installed previous version (example: git 2.25.0)
brew switch git 2.25.0
```

<br>

## Tips for using the script at your own company

- To customize the [welcome logo](https://github.com/vendasta/setup-new-computer-script/blob/47b7c97f21b293e143a0566cafecec2cfc69c528/setup-new-computer.sh#L74-L90) and add a bit of style, I used the handy [Text to ASCII Art Generator](https://patorjk.com/software/taag/#p=testall&f=Isometric1&t=Vendasta)
- This is MIT licensed, so be sure to include the [LICENSE file](https://github.com/vendasta/setup-new-computer-script/blob/master/LICENSE)


## Resources and inspiration

The following examples were helpful in building this script.
	
* macOS Dev Setup\
  https://github.com/nicolashery/mac-dev-setup
* dev-setup\
  https://github.com/donnemartin/dev-setup#dev-setup
* thoughtbot/laptop\
  https://github.com/thoughtbot/laptop


## Todo: Prep for M1 compatibility 

- Install Rosetta 2 (Is it not installed by default or automatically?)\
  `/usr/sbin/softwareupdate --install-rosetta` \
  or `sudo /usr/sbin/softwareupdate --install-rosetta agree-to-license`

- Set the new M1 location of homebrew up in the path \
  `/opt/homebrew/bin`

- More reading:
  - https://www.wisdomgeek.com/development/installing-intel-based-packages-using-homebrew-on-the-m1-mac/
  - https://github.com/Homebrew/discussions/discussions/417

## TODO

Things from hardening https://blog.bejarano.io/hardening-macos/

Enable Application Layer Firewall (we’ll call it ALF for short)
defaults write /Library/Preferences/com.apple.alf globalstate -int 1 

Profile:
AllowIdentifiedDevelopers https://mosen.github.io/profiledocs/payloads/mac/spctl.html#com.apple.systempolicy.control-AllowIdentifiedDevelopers-auto
