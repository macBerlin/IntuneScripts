#!/bin/zsh
# Must be run as root/sudo
# Generate Generic Password Items for Intune EAP-TLS Configuration Profile 
# https://macos.it-profs.de/microsoft-intune-and-the-missing-802-1x-settings/

NetworkName=$(defaults read /Library/Preferences/SystemConfiguration/com.apple.network.eapolclient.configuration.plist Profiles | grep UserDefinedName | awk -F"= \"" {'print $NF'} | tr -d ";\"")

security find-generic-password -l "$NetworkName" >/dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "The 802.1X Settings looks good."
else
    echo "The 802.1X items does not exist or is expired."
    for item in `security dump-keychain /Library/Keychains/System.keychain | sed -n 's#.*"svce".*="com.apple.network.eap.system.identity.profileid.\(.*\)"#com.apple.network.eap.system.item.profileid.\1#p'`
    do
            # Delete old password item
            security  delete-generic-password -D "802.1X Password" -a "`hostname`"'$' >/dev/null 2>&1

            security add-generic-password -a "`hostname`"'$' -l "$NetworkName"  -D "802.1X Password" -s "$item" -T /System/Library/SystemConfiguration/EAPOLController.bundle/Contents/Resources/eapolclient  -T "/System/Library/CoreServices/SystemUIServer.app"  /Library/Keychains/System.keychain
    done
fi
