#!/bin/zsh

# Generate Generic Password Items for Intune EAP-TLS Configuration Profile 
# https://macos.it-profs.de

NetworkName=$(defaults read /Library/Preferences/SystemConfiguration/com.apple.network.eapolclient.configuration.plist Profiles | grep UserDefinedName | awk -F"= \"" {'print $NF'} | tr -d ";\"")

for item in `security dump-keychain /Library/Keychains/System.keychain | sed -n 's#.*"svce".*="com.apple.network.eap.system.identity.profileid.\(.*\)"#com.apple.network.eap.system.item.profileid.\1#p'`
do

	security add-generic-password -a "`hostname`"'$' -l "$NetworkName"  -D "802.1X Password" -s "$item" -T /System/Library/SystemConfiguration/EAPOLController.bundle/Contents/Resources/eapolclient  -T "/System/Library/CoreServices/SystemUIServer.app"  /Library/Keychains/System.keychain
done

