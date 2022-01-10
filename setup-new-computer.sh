#!/bin/bash

VERSION="v2.0.1"
#===============================================================================
# title           setup-new-computer.sh
# author          jkesler@vendasta.com
#                 https://github.com/joelkesler
# modifications   Sandmania
#                 https://github.com/sandmania
# 
#===============================================================================
#   A shell script to help with the quick setup and installation of tools and 
#   applications for new developers at Vendasta.
# 
#   Quick Instructions:
#
#   1. Make the script executable:
#      chmod +x ./setup-new-computer.sh
#
#   2. Run the script:
#      ./setup-new-computer.sh
#
#   3. Some installs will need your password
#
#   4. You will be promted to fill out your git email and name. 
#      Use the email and name you use for Github
#
#   5. Follow the Post Installation Instructions in the Readme:
README="https://github.com/vendasta/setup-new-computer-script#post-installation-instructions"
#  
#===============================================================================


# IDEs to make availabe. Please also adjust code to brew cask install
#options[0]="Visual Studio Code";    devtoolchoices[0]=""
#options[5]="Sublime Text";          devtoolchoices[4]=""
#options[6]="iTerm2";                devtoolchoices[5]=""

cloudoptions[0]="AWS CLI"                       cloudchoices[0]=""
cloudoptions[1]="Azure CLI"                     cloudchoices[1]=""
cloudoptions[1]="Azure Functions Core Tools"    cloudchoices[2]=""


#===============================================================================
#  Functions
#===============================================================================

cleanup() {
    printHeading "Cleanup"
    printStep "Remove file that was used to initiate password profile."  "rm askforpassworddelay.mobileconfig"
}
trap cleanup EXIT

printHeading() {
    printf "\n\n\n\e[0;36m$1\e[0m \n"
}

printDivider() {
    printf %"$COLUMNS"s |tr " " "-"
    printf "\n"
}

printError() {
    printf "\n\e[1;31m"
    printf %"$COLUMNS"s |tr " " "-"
    if [ -z "$1" ]      # Is parameter #1 zero length?
    then
        printf "     There was an error ... somewhere\n"  # no parameter passed.
    else
        printf "\n     Error Installing $1\n" # parameter passed.
    fi
    printf %"$COLUMNS"s |tr " " "-"
    printf " \e[0m\n"
}

printStep() {
    printf %"$COLUMNS"s |tr " " "-"
    printf "\nInstalling $1...\n";
    $2 || printError "$1"
}

printLogo() {
cat << "EOT"

███████  █████  ███    ██ ██████  ███    ███  █████  ███    ██ 
██      ██   ██ ████   ██ ██   ██ ████  ████ ██   ██ ████   ██ 
███████ ███████ ██ ██  ██ ██   ██ ██ ████ ██ ███████ ██ ██  ██ 
     ██ ██   ██ ██  ██ ██ ██   ██ ██  ██  ██ ██   ██ ██  ██ ██ 
███████ ██   ██ ██   ████ ██████  ██      ██ ██   ██ ██   ████ 
        ------------------------------------------
            Q U I C K   S E T U P   S C R I P T


            NOTE:
            You can exit the script at any time by
            pressing CONTROL+C a bunch
EOT
}

showIDEMenuLoop() {
    # from https://serverfault.com/a/777849
    printLogo
    printHeading "Select Optional IDEs and Tools"
    printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
        echo ""
        for NUM in "${!options[@]}"; do
            echo "[""${devtoolchoices[NUM]:- }""]" $(( NUM+1 ))") ${options[NUM]}"
        done
        echo ""
}

showCloudMenuLoop() {
    printLogo
    printHeading "Select optional cloud tools"
    printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
        echo ""
        for NUM in "${!cloudoptions[@]}"; do
            echo "[""${cloudchoices[NUM]:- }""]" $(( NUM+1 ))") ${cloudoptions[NUM]}"
        done
        echo ""
}

writetoZshProfile() {
cat << EOT >> ~/.zprofile


# --------------------------------------------------------------------
# Begin ZSH autogenerated content from setup-new-computer.sh   $VERSION
# --------------------------------------------------------------------

# Setting up Path for Homebrew
export PATH=/usr/local/sbin:\$PATH

# Setup Path for Local Python Installs
export PATH=\$PATH:\$HOME/Library/Python/2.7/bin

# Brew Autocompletion
if type brew &>/dev/null; then
    fpath+=\$(brew --prefix)/share/zsh/site-functions
fi

# Zsh Autocompletion
# Note: must run after Brew Autocompletion
autoload -U +X compinit && compinit
autoload -U +X bashcompinit && bashcompinit
fpath=(/usr/local/share/zsh-completions \$fpath)

# --------------------------------------------------------------------
# End autogenerated content from setup-new-computer.sh   $VERSION
# --------------------------------------------------------------------


EOT
}

# Get root user for later. Brew needs the user to be admin to install 
sudo ls > /dev/null


#===============================================================================
# Installer: Settings
#===============================================================================


# Show IDE Selection Menu
clear
while 
    showIDEMenuLoop && \
    read -r -e -p "Enable or Disable by typing number. Hit ENTER to continue " \
    -n1 SELECTION && [[ -n "$SELECTION" ]]; \
do
    clear
    if [[ "$SELECTION" == *[[:digit:]]* && $SELECTION -ge 1 && $SELECTION -le ${#options[@]} ]]; then
        (( SELECTION-- ))
        if [[ "${devtoolchoices[SELECTION]}" == "+" ]]; then
            devtoolchoices[SELECTION]=""
        else
            devtoolchoices[SELECTION]="+"
        fi
            ERROR=" "
    else
        ERROR="Invalid option: $SELECTION"
    fi
done
printDivider

clear
while 
    showCloudMenuLoop && \
    read -r -e -p "Enable or Disable by typing number. Hit ENTER to continue " \
    -n1 SELECTION && [[ -n "$SELECTION" ]]; \
do
    clear
    if [[ "$SELECTION" == *[[:digit:]]* && $SELECTION -ge 1 && $SELECTION -le ${#cloudoptions[@]} ]]; then
        (( SELECTION-- ))
        if [[ "${cloudchoices[SELECTION]}" == "+" ]]; then
            cloudchoices[SELECTION]=""
        else
            cloudchoices[SELECTION]="+"
        fi
            ERROR=" "
    else
        ERROR="Invalid option: $SELECTION"
    fi
done
printDivider



#===============================================================================
#  Installer: Set up shell profiles
#===============================================================================


# Create .zprofile if they dont exist
printHeading "Prep Zsh"
printDivider
    echo "✔ Touch ~/.zprofile"
        touch ~/.zprofile
printDivider
    # Zsh profile
    if grep --quiet "setup-new-computer.sh" ~/.zprofile; then
        echo "✔ .zprofile already modified. Skipping"
    else
        writetoZshProfile
        echo "✔ Added to .zprofile"
    fi
printDivider
    echo "(zsh) Rebuild zcompdump"
    rm -f ~/.zcompdump

#===============================================================================
#  Installer: Main Payload
#===============================================================================


# Install xcode cli development tools
printHeading "Installing xcode cli development tools"
printDivider
    xcode-select --install && \
        read -n 1 -r -s -p $'\n\nWhen Xcode cli tools are installed, press ANY KEY to continue...\n\n' || \
            printDivider && echo "✔ Xcode cli tools already installed. Skipping"
printDivider


# Install Brew
printHeading "Installing Homebrew"
printDivider
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
printDivider
    echo "✔ Setting Path to /usr/local/bin:\$PATH"
        export PATH=/usr/local/bin:$PATH
printDivider
    echo "✔ Opting out from Homebrew analytics"
        brew analytics off
printDivider
    echo "(zsh) Fix insecure directories warning"
    chmod go-w "$(brew --prefix)/share"
printDivider

# Install Utilities
printHeading "Installing Brew Packages"
    printStep "Git"                         "brew install git"
    printStep "HTTPie"                      "brew install httpie"
printDivider


# Install  Apps
printHeading "Installing Applications"
    printStep "Slack"                       "brew install --cask slack"
    printStep "Firefox"                     "brew install --cask firefox"
    printStep "Spotify"                     "brew install --cask spotify"
    printStep "Docker for Mac"              "brew install --cask docker"
    printStep "Visual Studio Code"          "brew install --cask visual-studio-code"
    printStep "IntelliJ IDEA Ultimate"      "brew install --cask intellij-idea"
    printStep "iTerm2"                      "brew install --cask iterm2"
    echo "✔ SDKMAN!: Download and install"
    sh -c "$(curl -s https://get.sdkman.io)"
printDivider


# Install Mac OS Python Pip and Packages
# Run this before "Homebrew Python 3" to make sure "Homebrew Python 3" will overwrite pip3
printHeading "Installing Mac OS Python"
    printDivider
        echo "Installing Pip for MacOS Python..."
            sudo -H /usr/bin/easy_install pip==20.3.4
    printDivider
        echo "Upgrading Pip for MacOS Python..."
            sudo -H pip install --upgrade "pip < 21.0"
printDivider


# Install Homebrew Python 3
printHeading "Installing Homebrew Python 3"
    printStep "Homebrew Python 3 with Pip"       "brew reinstall python"
printDivider


# Install AWS Components
printHeading "Install cloud tools"
    # Install aws cli
    if [[ "${cloudchoices[0]}" == "+" ]]; then
        printStep "Homebrew AWS CLI"       "brew install awscli"
    fi
    # Install azure cli
    if [[ "${cloudchoices[1]}" == "+" ]]; then
        printStep "Homebre Azure CLI"       "brew install azure-cli"
    fi
    # Install azure cli
    if [[ "${cloudchoices[2]}" == "+" ]]; then
        printStep "Tapping Azure Functions Core tools"      "brew tap azure/functions"
        printStep "Homebrew Azure Functions Core Tools"     "brew install azure-functions-core-tools@4"
    fi
printDivider


# Install System Tweaks
printHeading "System Tweaks"
    printDivider
    echo "✔ General: Expand save and print panel by default"
        defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
        defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true
        defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
        defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true
    echo "✔ General: Save to disk (not to iCloud) by default"
        defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false
    echo "✔ General: Avoid creating .DS_Store files on network volumes"
        defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
    printDivider
        
    echo "✔ Typing: Disable smart quotes and dashes as they cause problems when typing code"
        defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
        defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
    printDivider

    echo "✔ Finder: Show status bar and path bar"
        defaults write com.apple.finder ShowStatusBar -bool true
        defaults write com.apple.finder ShowPathbar -bool true
    echo "✔ Finder: Disable the warning when changing a file extension"
        defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
    echo "✔ Finder: Show the ~/Library folder"
        chflags nohidden ~/Library
    printDivider
printDivider


# TODO FIXME: Installing oh-my-zsh like this will stop the script after installation is finished. Maybe look into https://github.com/jotyGill/ezsh
# Shell and visuals
#printHeading "Installing shell and visual stuff"
#    echo "✔ Installing oh-my-zsh"
#    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
#printDivider


# Security and hardening
printHeading "Security and hardening"
    printStep "Firewall: install additiona firewall - LuLu"             "brew install lulu"
    echo "✔ Firewall: Enabling macOS inbuilt Application Level Firewall (ALF)."
    defaults write /Library/Preferences/com.apple.alf globalstate -int 1
    printStep "brew blockblock"                                         "brew install blockblock"
    printDivider
    echo "✔ Profiles: Installing ask for password porfile. This will open Profiles from System Preferenes."
        sed -e "s/\${USER}/$(id -un)/" askforpassworddelay.mobileconfig.template > askforpassworddelay.mobileconfig
        open askforpassworddelay.mobileconfig
        open -b com.apple.systempreferences /System/Library/PreferencePanes/Profiles.prefPane
    printDivider
printDivider

#===============================================================================
#  Installer: Git
#===============================================================================


# Set up Git
printHeading "Set Up Git"

# Configure git to always ssh when dealing with https github repos
git config --global url."git@github.com:".insteadOf https://github.com/

printDivider
    echo "✔ Set Git to store credentials in Keychain"
    git config --global credential.helper osxkeychain
printDivider
    if [ -n "$(git config --global user.email)" ]; then
        echo "✔ Git email is set to $(git config --global user.email)"
    else
        read -p 'What is your Git email address?: ' gitEmail
        git config --global user.email "$gitEmail"
    fi
printDivider
    if [ -n "$(git config --global user.name)" ]; then
        echo "✔ Git display name is set to $(git config --global user.name)"
    else
        read -p 'What is your Git display name (Firstname Lastname)?: ' gitName
        git config --global user.name "$gitName"
    fi
printDivider
    if [ -n "$(git config --global core.excludesfile)" ]; then
        echo "✔ Git global gitignore file is set to $(git config --global core.excludesfile)"
    else
        echo "✔ Copy .gitignore to ~/.gitignore and use it as a global gitignore file"
        cp .gitignore ~/.gitignore
        git config --global core.excludesfile ~/.gitignore
    fi
printDivider



#===============================================================================
#  Installer: Complete
#===============================================================================

printHeading "Script Complete"
printDivider

tput setaf 2 # set text color to green
cat << "EOT"

   ╭─────────────────────────────────────────────────────────────────╮
   │░░░░░░░░░░░░░░░░░░░░░░░░░░░ Next Steps ░░░░░░░░░░░░░░░░░░░░░░░░░░│
   ├─────────────────────────────────────────────────────────────────┤
   │                                                                 │
   │   There are still a few steps you need to do to finish setup.   │
   │                                                                 │
   │  1. Accept the installation of password delay settings profile. │
   │                                                                 │
   │        The link below has Post Installation Instructions        │
   │                                                                 │
   └─────────────────────────────────────────────────────────────────┘

EOT
tput sgr0 # reset text
echo "Link:"
echo $README
echo ""
echo ""
tput bold # bold text
read -n 1 -r -s -p $'             Press any key to to open the link in a browser...\n\n'
open $README
tput sgr0 # reset text

echo ""
echo ""
echo "Please open a new terminal window to continue your setup steps"


exit
