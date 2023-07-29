#!/system/bin/sh

# raidenTweaks™ by Raiden Ishigami (raidenkkj @ GitHub).
# If you use parts of this project, please credit the respective authors.

# Store module directory in a variable
modpath="/data/adb/modules_update/RTKS/"

# Enable 64-bit dex2oat and disable ARMv8.5-A memory tagging for 64-bit architecture
[[ "$IS64BIT" == "true" ]] && {
  sed -i '/dalvik.vm.dex2oat64.enabled/s/.*/dalvik.vm.dex2oat64.enabled=true/' "${modpath}system.prop"
  sed -i '/arm64.memtag.process.system_server/s/.*/arm64.memtag.process.system_server=off/' "${modpath}system.prop"
}

# List of modules to check and disable
MODULES="FDE:FDE.AI
ktweak:KTweak
ZeetaaTweaks:ZeetaaTweaks
lv-gpu-performance:Lv-gpu-performance
R.kashyap:Gamers Edition
ZTS:ZTS
MAGNETAR:MAGNETAR
Apollon:Apollon
Apollon-plus:Apollon Plus
gameexp:Improve Game Xperience
lspeed:LSpeed
fkm_spectrum_injector:FKM Injector
KTSR:KTSR
lazy:LazyTweaks
injector:NFSInjector
GamersExtreme:GamersExtreme
xengine:Xengine
PXT:PROJECT XTREME TWEAKS
Godspeed:GodSpeed
MTK_VEST:MTK_VEST
aosp_enhancer:AOSP Enhancer
GSFAB:GSMxFAB
GSNO:GODSPEED NET OPTIMIZER
PXT:PROJECT XTREME TWEAKS"

# List of apps to check and uninstall
APPS="com.magnetarapp:MAGNETAR
pedrozzz.king.tweaks:King Tweaks
com.paget96.lsandroid:LSpeed
com.feravolt.fdeai:FDE.AI
com.tweak.kitana:Kitana Tweak
com.nfs.nfsmanager:NFS Manager"

# Function to check and disable a module
check_module() {
  mod="$1"
  mod_location="$(echo "$mod" | cut -d':' -f 1)"
  mod_name="$(echo "$mod" | cut -d':' -f 2)"
  if [[ -d "$MODDIR"/"$mod_location" ]]; then
    module_detected=true
    ui_print "[!] $mod_name module detected, disabling for security reasons."
    touch "$MODDIR"/"$mod_location"/disable
  fi
}

# Function to check and uninstall an app
check_app() {
  app="$1"
  app_name="$(echo "$app" | cut -d':' -f 2)"
  app_package="$(echo "$app" | cut -d':' -f 1)"
  if pm list package "$app_package" | grep -o "$app_package)" | grep -q "$app_package"; then
    app_detected=true
    ui_print "[!] $app_name app has been detected, removing the app to avoid conflicts..."
    ui_print ""
    pm uninstall -k --user 0 "$app_package" > /dev/null 2>&1
  fi
}

# Conflict checker variables
mod_detected=false
app_detected=false

# Display raidenTweaks banner and version information
awk '{print}' "${modpath}common/rtks_banner"
ui_print ""
ui_print "VERSION: $(grep_prop version "${modpath}module.prop") - $(grep_prop bdate "${modpath}module.prop")"
ui_print ""
ui_print "CODENAME: $(grep_prop codename "${modpath}module.prop")"
sleep 2

# Display message about module
ui_print ""
ui_print "With this module you can choose one of"
ui_print "these profiles and improve your user experience."
sleep 3
ui_print ""

# Display message about fstrim and prompt user for input
sleep 0.5
ui_print "[*] - Do you want to fstrim the partitions? [Recommended]"
sleep 2
ui_print ""
ui_print " Vol + = Switch option"
sleep 0.2
ui_print " Vol - = Select option"
sleep 1
ui_print ""
ui_print " 1 - Yes "
sleep 0.5
ui_print " 2 - No "
ui_print ""
sleep 0.5

# Prompt the user to make a selection
ui_print "[*] - Select the desired option: "
ui_print ""

# Set the default option to 1
FSTEXT=1

# Loop until user selects an option
while true; do
   ui_print "  ${FSTEXT}"
   if ${VKSEL}; then
      FSTEXT=$((FSTEXT + 1))
   else
      break
   fi
   if [[ ${FSTEXT} -gt 2 ]]; then
      FSTEXT=1
   fi
done

case $FSTEXT in
   1)
      FSTEXT="Yes"
      ;;
   2)
      FSTEXT="No"
      ;;
esac

# Print the selected option to the user
ui_print ""
ui_print "[*] - Selected: $FSTEXT "
ui_print ""

# Process fstrim according to the option selected by the user
if [[ $FSTEXT == "Yes" ]]; then
   ui_print "[*] - Wait, process in progress..."
   ui_print ""
   sleep 1
   fstrim -v /system
   fstrim -v /data
   fstrim -v /cache
   fstrim -v /product
   ui_print ""
   ui_print "[*] - Fstrim successfully executed"
   ui_print ""
fi

# Display message about profile selection
ui_print "[*] - Do you want to select a default"
ui_print "      profile for Raiden Tweaks?"
ui_print ""
ui_print "[i] - By selecting a default profile, that profile"
ui_print "      will persist when you reboot."
ui_print ""
ui_print " Vol + = Switch option"
sleep 0.2
ui_print " Vol - = Select option"
sleep 1
ui_print ""
ui_print " 1 - None "
ui_print " 2 - Automatic "
ui_print " 3 - Battery "
ui_print " 4 - Balanced "
ui_print " 5 - Performance "
ui_print " 6 - Gaming "
ui_print " 7 - Thermal "

# Prompt the user to make a selection
ui_print ""
ui_print "[*] - Select which you want: "
ui_print ""

# Set the default option to 1
PRFTEXT=1

# Loop until user selects an option
while true; do
   ui_print "  ${PRFTEXT}"
   if ${VKSEL}; then
      PRFTEXT=$((PRFTEXT + 1))
   else
      break
   fi
   if [[ ${PRFTEXT} -gt 7 ]]; then
      PRFTEXT=1
   fi
done

case "$PRFTEXT" in

   1)
      PRFTEXT="✗ | None"
      ;;
   2)
      PRFTEXT="✓ | AUTOMATIC"
      sed -i '/persist.raidentweaks.mode/s/.*/persist.raidentweaks.mode=1/' "${modpath}system.prop"
      ;;
   3)
      PRFTEXT="✓ | BATTERY"
      sed -i '/persist.raidentweaks.mode/s/.*/persist.raidentweaks.mode=2/' "${modpath}system.prop"
      ;;
   4)
      PRFTEXT="✓ | BALANCED"
      sed -i '/persist.raidentweaks.mode/s/.*/persist.raidentweaks.mode=3/' "${modpath}system.prop"
      ;;
   5)
      PRFTEXT="✓ | PERFORMANCE"
      sed -i '/persist.raidentweaks.mode/s/.*/persist.raidentweaks.mode=4/' "${modpath}system.prop"
      ;;
   6)
      PRFTEXT="✓ | GAMING"
      sed -i '/persist.raidentweaks.mode/s/.*/persist.raidentweaks.mode=5/' "${modpath}system.prop"
      ;;
   7)
      PRFTEXT="✓ | THERMAL"
      sed -i '/persist.raidentweaks.mode/s/.*/persist.raidentweaks.mode=6/' "${modpath}system.prop"
      ;;
esac

# Print the selected profile to the user
ui_print ""
ui_print "[*] - Selected: $PRFTEXT "
ui_print ""
sleep 3

# Check each module and disable if necessary
ui_print "[*] Checking for possible conflicts with modules..."
for mod in $MODULES; do
  check_module "$mod"
done

# Print blank line if any module has been detected
if [[ "$module_detected" == "true" ]]; then
  ui_print ""
fi

# Check each app and uninstall if necessary
ui_print "[*] Checking for possible conflicts with apps..."
for app in $APPS; do
  check_app "$app"
done

# Print blank line if any application is detected
if [[ "$app_detected" == "true" ]]; then
  ui_print ""
fi

# Print message to let user know that conflict checker has already been run
ui_print "[*] Conflict checker executed!"
sleep 1.5

# Variables for specific games
WR="H+vs4DOggQi7ygb7biEG29+ee0AT3YUrUUmFwfzaAweezd+i0T2OeYM9la0wt1RM/vyNFDXYA71W99xcn7nFBWr/K1bnzYZ6XSfbg7m/7SrVCHUeW/OX4d+6QBD9+rtaElCIyoWuaGEWDf1Q2WDjYH3cxkm8AGwl/OCuwMt/BsQHOSZtKDF/nL8DX2gt3ZSckQJl9SNEzt4GL9PShRE/bB+/WX+qPIWgBTUcLb9HBChgMNMHIAvnObvXhAntpej+T6KOl3GVGDZGA6m14Nf0pm74RI1opbaWuGU9/WMG9+vEdV3e7reQwR1AKmzeExTw3gOQgI0sZoGa/oEsLmVtnIKF4wBnkkEUVdnOaIVVcU5cSw6Y5E6O0sN9f+yJHdsC0Ki8+81TTt5r6ol7qNPX8vEJ70qAn6xdHqm02pSwqm7bXx15LLfYlp1tbd5+hHOWb/PtL20Vc7YXUHssWIzRFEgBr1SieqolbhNXnlCCJ2Iz3OstFvgtEgB6HSYMEKBg0Oyi7fjdpymO3Hve6WL/dgEiK4rybIV9oc4ySirx46OUkE/UrE7lh1A2/j2z5WmAtWGcivDnOqPPpDKLRXFj40Ds/iAC175JT4UNsRc/fs6huhEIGzlkxujuVsJ/f2o2Ciu28okSlTKOyRs/gSARTEkt45GO/wnVZfrxDd9NSsLXeF52IG6BDUkG9aV3ABMuF7cj5yZcB90eEkh/uLBdS5y+BBjpq9yq8t2ai6VRp0kY3YeCPLwJv2fK/6Is7BC+gHxV8pVomvZ/sonAT9Ta2ZoP92motacbaWMGK7MGLpw+qAvLh4AKZD9qCwjIBjLQDhhFCRlaPyr2iKx7ZMXo9cLIfcjaCNsx5CbyrYL7L07z19KI6TBzEIkMEwSjWwXMM1KEiXQpbWK6DAZPBAH8pwVJfdRz8kC5BLoVJbbYKtu9oFRbUISu9luFqg1nUX8Qh82BQAMyQyNHqilzbYwgRnMN0uqD/AbTeW6Mou1WOAjwg9rwG2fT28lNqE0GAl9Ud34Ez895ltVHi22NMizvxNth8rZay0CzjnMI+g4BpiztCx09+qgi4s7KZo4LP7l1Wu4by0WxQCdXdxdcU7VeC/45M9YaFcO/Srl/gFv4mrNlP958GJ4lkXDlWch2eUx2wVgNpQkffvcv+dHgH41mZlBAoEc7y734nHTsvjthbaO/oRXO0EdgKZqSksWnKI9fHDL47JxR2rN9jqn8B3SJMorarPSqa8RTqvw2CWVagupPhDlbZk5Naj2DyvllLSLDLZC/fW9dmVUb9Cu7cHDWDYSFhG/HTVZHcpk16+7fvw4ib37kJ1zKrfCCcJFaQQak3aX93iK+l50JTRywysUWbKImCjIOmMZZoyBcMp5P2X9dzOhb/kC+CUICh+s5GkrzOlAKIyr1cEtegYWzHVezeUEtbX9n9CXM6wB+e3LWaoffMh6EegbKrUnxpmxdRHu3clI3F+IAtXtz5NcH9gOwPgdHbUh1H3xkt7nNiBS3224fQyJzhLgD6TkyZeCdm7QQEHbsSoQC+n57LJQ9gyOMtDxCQN8JJIeWmPk8egHY3XIaAQP5UiaYxc6uE6Fnhu5TXoXtkFyGndccqIVAQtaaIcPpdRimQ5+EaBAUDQmCZvYuoFo9tsWDdsPZCYDFYsgNMG9HEeqA6nDtzzgw5kdgogMjchoMmTYOdCgaPkkgPNx8S5DCC5rpSR9x1O7MiquoCQhSBdLGWpYWi80rheP0WQfnmVbIjFJpoWTFOQ3T/7H3DzYaniPox+gXDvhZaB0i9ksSWiXlXklfPsO4X2QK/HfNyVV+1aA4ONRuMTdVan2jn+meBjraWlniUBe1Hs54"
FTN="/data/data/com.epicgames.fortnite/files/UE4Game/FortniteGame/FortniteGame/Saved/Config/Android/GameUserSettings.ini"
LIFE="/data/media/0/Android/data/com.netease.mrzhna/files/netease/g66/Documents/configs/qualityconfig"
DBD="/data/data/com.bhvr.deadbydaylight/files/UE4Game/DeadByDaylight/DeadByDaylight/Saved/Config/Android/GameUserSettings.ini"
PUBGNS="/data/data/com.pubg.newstate/files/UE4Game/Extreme/Extreme/Saved/Config/Android/GameUserSettings.ini"

# Print the raidenUnlocker banner
awk '{print}' "${modpath}common/ru_banner" 
sleep 3

# Print warning messages
ui_print "[!] - Important: These settings can cause  "
ui_print "                  errors in system applications.  "
sleep 0.5
ui_print ""
ui_print "[!] - Might not work if you are using "
ui_print "       magiskhideprops or other like module. "
ui_print ""
ui_print " Vol + = Switch option"
sleep 0.2
ui_print " Vol - = Select option"
sleep 1
ui_print ""

# Print the available game setting options
ui_print " 1 - None"
ui_print " 2 - PUBG Mobile / BGMI / 90 FPS settings"
ui_print " 3 - PUBG: New State / MAX settings"
ui_print " 4 - COD Mobile And BlackDesert Mobile / MAX settings"
ui_print " 5 - Mobile Legends / MAX settings"
ui_print " 6 - Sky Children of the Light and Asphalt 9 / 60 FPS settings"
ui_print " 7 - COD Mobile / 120 FPS settings"
ui_print " 8 - Fortnite settings"
ui_print " 9 - Asphalt and PUBG Mobile / BGMI / 90 FPS settings"
ui_print " 10 - Forsaken World / 120 FPS settings"
ui_print " 11 - Life After / 120 FPS"
ui_print " 12 - Dead by Daylight / 120 FPS settings"
ui_print " 13 - LoL WR / MAX settings"
ui_print " 14 - LoL WR / MAX settings and Fortnite / 60 FPS"
ui_print " 15 - Game for Peace 90 FPS settings"
ui_print " 16 - Free Fire 90 FPS"

# Prompt the user to make a selection
ui_print ""
ui_print "[*] - Select which you want: "
ui_print ""

# Set the default option to 1
RU=1

# Loop until user selects an option
while true; do
   ui_print "  ${RU}"
   if ${VKSEL}; then
      RU=$((RU + 1))
   else
      break
   fi
   if [[ ${RU} -gt 16 ]]; then
      RU=1
   fi
done

# Print empty line that serves as a divider
ui_print ""

# Set the game settings based on the selected option
for GS in /data/media/0/Android/data/com.riotgames.league.wildrift/files/SaveData/Local/*/Setting; do
   case "$RU" in
      1)
         TEXT="✗ | None"
         UNTEXT="None"
         ;;
      2)
         TEXT="✓ | PUBG Mobile / BGMI / 90 FPS "
         UNTEXT="PUBG Mobile and BGMI 90 FPS"
         sed -i '/ro.product.model/s/.*/ro.product.model=M2102K1C/' "${modpath}system.prop"
         sed -i '/ro.product.odm.model/s/.*/ro.product.odm.model=M2102K1C/' "${modpath}system.prop"
         sed -i '/ro.product.system.model/s/.*/ro.product.system.model=M2102K1C/' "${modpath}system.prop"
         sed -i '/ro.product.vendor.model/s/.*/ro.product.vendor.model=M2102K1C/' "${modpath}system.prop"
         sed -i '/ro.product.system_ext.model/s/.*/ro.product.system_ext.model=M2102K1C/' "${modpath}system.prop"
         ;;
      3)
         TEXT="✓ | PUBG: New State / MAX settings "
         UNTEXT="PUBG: New State MAX settings"
         chmod 0777 "$PUBGNS"
         magiskhide enable
         magiskhide add com.pubg.newstate
         settings put global adb_enabled 0 settings put global development_settings_enabled 0 magisk --denylist rm com.google.android.gms
         mv /data/media/0/TWRP /data/media/0/PRWT
         mv /data/media/0/Download/magisk_patched.img /data/media/0/Download/ksigam_dehctap.img
         force-stop com.pubg.newstate
         sed -i -e 's/InGameSetting=*/InGameSetting=(Brightness=135.000000,3e5fb0f167=HD,CameraFOV_FPP=95.000000,ee1cce4781=ULTRA,0e36c7ab25=ULTRA,52acd236cf=EXTREME90,30db48eba4=ULTRA,388652a957=OFF,CameraFOV_TPP=80.000000,d08a7d9304=ULTRA,AntiAliasingType=ON,d67592353d=ULTRA,728fe36b3e=ULTRA)/g' "$PUBGNS"
         sed -i -e 's/FrameRateLimit=30.000000/FrameRateLimit=90.000000/g' "$PUBGNS"
         sed -i -e 's/FrameRateLimit=30.000000/FrameRateLimit=90.000000/g' "$PUBGNS"
         sed -i -e 's/FrameRateLimit=60.000000/FrameRateLimit=90.000000/g' "$PUBGNS"
         sed -i -e 's/FrameRateLimit=60.000000/FrameRateLimit=90.000000/g' "$PUBGNS"
         sed -i -e 's/AudioQualityLevel=2/AudioQualityLevel=0/g' "$PUBGNS"
         sed -i -e 's/AudioQualityLevel=1/AudioQualityLevel=0/g' "$PUBGNS"
         sed -i -e 's/LastConfirmedAudioQualityLevel=2/LastConfirmedAudioQualityLevel=0/g' "$PUBGNS"
         sed -i -e 's/LastConfirmedAudioQualityLevel=1/LastConfirmedAudioQualityLevel=0/g' "$PUBGNS"
         chmod 0440 "$PUBGNS"
         ;;
      4)
         TEXT="✓ | COD Mobile And BlackDesert Mobile / MAX settings"
         UNTEXT="COD Mobile And BlackDesert Mobile MAX settings"
         sed -i '/ro.product.model/s/.*/ro.product.model=SM-G965F/' "${modpath}system.prop"
         sed -i '/ro.product.odm.model/s/.*/ro.product.odm.model=SM-G965F/' "${modpath}system.prop"
         sed -i '/ro.product.system.model/s/.*/ro.product.system.model=SM-G965F/' "${modpath}system.prop"
         sed -i '/ro.product.vendor.model/s/.*/ro.product.vendor.model=SM-G965F/' "${modpath}system.prop"
         sed -i '/ro.product.system_ext.model/s/.*/ro.product.system_ext.model=SM-G965F/' "${modpath}system.prop"
         ;;
      5)
         TEXT="✓ | Mobile Legends / MAX settings "
         UNTEXT="Mobile Legends MAX settings"
         sed -i '/ro.product.model/s/.*/ro.product.model=Mi 10 Pro/' "${modpath}system.prop"
         sed -i '/ro.product.odm.model/s/.*/ro.product.odm.model=Mi 10 Pro/' "${modpath}system.prop"
         sed -i '/ro.product.system.model/s/.*/ro.product.system.model=Mi 10 Pro/' "${modpath}system.prop"
         sed -i '/ro.product.vendor.model/s/.*/ro.product.vendor.model=Mi 10 Pro/' "${modpath}system.prop"
         sed -i '/ro.product.system_ext.model/s/.*/ro.product.system_ext.model=Mi 10 Pro/' "${modpath}system.prop"
         ;;
      6)
         TEXT="✓ | Sky Children of the Light and Asphalt 9 / 60 FPS"
         UNTEXT="Sky Children of the Light and Asphalt 9 60 FPS settings"
         sed -i '/ro.product.model/s/.*/ro.product.model=GM1917/' "${modpath}system.prop"
         ;;
      7)
         TEXT="✓ | COD Mobile / 120 FPS "
         UNTEXT="COD Mobile / 120 FPS settings"
         sed -i '/ro.product.model/s/.*/ro.product.model=SO-52A/' "${modpath}system.prop"
         sed -i '/ro.product.odm.model/s/.*/ro.product.odm.model=SO-52A/' "${modpath}system.prop"
         sed -i '/ro.product.system.model/s/.*/ro.product.system.model=SO-52A/' "${modpath}system.prop"
         sed -i '/ro.product.vendor.model/s/.*/ro.product.vendor.model=SO-52A/' "${modpath}system.prop"
         sed -i '/ro.product.system_ext.model/s/.*/ro.product.system_ext.model=SO-52A/' "${modpath}system.prop"
         ;;
      8)
         TEXT="✓ | Fortnite settings "
         UNTEXT="Fortnite settings"
         chmod 0777 "$FTN"
         magiskhide enable
         magiskhide add com.epicgames.fortnite
         settings put global adb_enabled 0 magisk --denylist rm com.google.android.gms
         mv /data/media/0/TWRP /data/media/0/PRWT
         mv /data/media/0/Download/magisk_patched.img /data/media/0/Download/ksigam_dehctap.img
         am force-stop com.epicgames.fortnite
         sed -i -e 's/MobileFPSMode=Mode_20Fps/MobileFPSMode=Mode_60Fps/g' "$FTN"
         sed -i -e 's/MobileFPSMode=Mode_30Fps/MobileFPSMode=Mode_60Fps/g'  "$FTN"
         sed -i -e 's/MobileFPSMode=Mode_45Fps/MobileFPSMode=Mode_60Fps/g'  "$FTN"
         sed -i -e 's/MobileFPSMode=Mode_60Fps/MobileFPSMode=Mode_60Fps/g'  "$FTN"
         sed -i -e 's/MobileFPSMode=Mode_120Fps/MobileFPSMode=Mode_60Fps/g'  "$FTN"
         chmod 0440 "$FTN"
         ;;
      9)
         TEXT="✓ | Asphalt and PUBG Mobile / BGMI / 90 FPS"
         UNTEXT="Asphalt and PUBG Mobile and BGMI 90 FPS"
         sed -i '/ro.product.model/s/.*/ro.product.model=GM1917/' "${modpath}system.prop"
         sed -i '/ro.product.odm.model/s/.*/ro.product.odm.model=GM1917/' "${modpath}system.prop"
         sed -i '/ro.product.system.model/s/.*/ro.product.system.model=GM1917/' "${modpath}system.prop"
         sed -i '/ro.product.vendor.model/s/.*/ro.product.vendor.model=GM1917/' "${modpath}system.prop"
         sed -i '/ro.product.system_ext.model/s/.*/ro.product.system_ext.model=GM1917/' "${modpath}system.prop"
         ;;
      10)
         TEXT="✓ | Forsaken World / 120 FPS"
         UNTEXT="Forsaken World 120 FPS"
         sed -i '/ro.product.model/s/.*/ro.product.model=ZS673KS-1B063IN/' "${modpath}system.prop"
         ;;
      11)
         TEXT="✓ | Life After / 120 FPS"
         UNTEXT="Life After / 120 FPS"
         am force-stop com.netease.mrzhna 2>/dev/null
         sed -i 's/"frame": 1,/"frame": 4,/g' "$LIFE"
         sed -i 's/"frame": 2,/"frame": 4,/g' "$LIFE"
         sed -i 's/"frame": 3,/"frame": 4,/g' "$LIFE"
         ;;
      12)
         TEXT="✓ | Dead by Daylight / 120 FPS"
         UNTEXT="Dead by Daylight 120 FPS"
         am force-stop com.bhvr.deadbydaylight 2>/dev/null
         sed -i 's/FrameRateLimit=30/FrameRateLimit=120/g' "$DBD"
         sed -i 's/FrameRateLimit=60/FrameRateLimit=120/g' "$DBD"
         ;;
      13)
         TEXT="✓ | LoL WR / MAX settings"
         UNTEXT="LoL WR MAX settings"
         sed -i '/ro.product.model/s/.*/ro.product.model=SM-G9880/' "${modpath}system.prop"
         ;;
      14)
         TEXT="✓ | LoL WR / MAX settings and Fortnite / 60 FPS"
         UNTEXT="LoL WR MAX settings and Fortnite 60 FPS"
         am force-stop com.epicgames.fortnite
         sed -i 's/MobileFPSMode=Mode_20Fps/MobileFPSMode=Mode_60Fps/g' "$FTN"
         sed -i 's/MobileFPSMode=Mode_30Fps/MobileFPSMode=Mode_60Fps/g' "$FTN"
         sed -i 's/MobileFPSMode=Mode_45Fps/MobileFPSMode=Mode_60Fps/g' "$FTN"
         sed -i '/ro.product.model/s/.*/ro.product.model=A2218/' "${modpath}system.prop"
         ;;
      15)
         TEXT="✓ | Game for Peace / 90 FPS settings"
         UNTEXT="Game for Peace 90 FPS settings"
         sed -i '/ro.product.model/s/.*/ro.product.model=GM1917/' "${modpath}system.prop"
         ;;
      16)
         TEXT="✓ | Free Fire 90 FPS"
         UNTEXT="Free Fire 90 FPS"
         sed -i '/ro.product.manufacturer/s/.*/ro.product.manufacturer=asus/' "${modpath}system.prop"
         sed -i '/ro.product.model/s/.*/ro.product.model=ASUS_Z01QD/' "${modpath}system.prop"
         ;;
      esac

# Print the selected option to the user
ui_print "[*] - Selected option: $TEXT "
ui_print ""

# Set unlocker in module.prop
sed -i -e "/unlocker=/s/=.*/=${UNTEXT}/" "${modpath}module.prop"
sleep 1

# Provide information/idea on how branches are 
ui_print "[*] - Select the branch for Raiden Tweaks!!"
ui_print ""
ui_print "[*] - The branch is from where the scripts will be downloaded from"
ui_print "      each branch has its specific peculiarity, like the"
ui_print "      tests branch, intended for testing."
ui_print ""
ui_print " Vol + = Switch option"
sleep 0.2
ui_print " Vol - = Select option"
sleep 1
ui_print ""

# Display the options to the user
ui_print " 1 - Stable (default) "
ui_print " 2 - Beta (not recommended yet) "
ui_print " 3 - Tests (maybe unstable) "

# Prompt the user to make a selection
ui_print ""
ui_print "[*] - Select which you want: "
ui_print ""

# Set the default option to 1
TEXTBRANCH=1

# Loop until user selects an option
while true; do
   ui_print "  ${TEXTBRANCH}"
   if ${VKSEL}; then
      TEXTBRANCH=$((TEXTBRANCH + 1))
   else
      break
   fi
   if [[ ${TEXTBRANCH} -gt 3 ]]; then
      TEXTBRANCH=1
   fi
done

case "$TEXTBRANCH" in

   1)
      TEXTBRANCH="Stable (Default)"
			sed -i -e "/dbranch=/s/=.*/=stable/" "${modpath}module.prop"
			;;
   2)
	  TEXTBRANCH="Beta"
			sed -i '/https:\/\/raw.githubusercontent.com\/raidenkkj\/Raiden-Tweaks\/stable\/system\/bin\/raidentweaks/s/.*/wget -qO "${modpath}system\/bin\/raidentweaks" "https:\/\/raw.githubusercontent.com\/raidenkkj\/Raiden-Tweaks\/beta\/system\/bin\/raidentweaks"/' "${modpath}service.sh"
			sed -i '/https:\/\/raw.githubusercontent.com\/raidenkkj\/Raiden-Tweaks\/stable\/system\/bin\/raidenauto/s/.*/wget -qO "${modpath}system\/bin\/raidenauto" "https:\/\/raw.githubusercontent.com\/raidenkkj\/Raiden-Tweaks\/beta\/system\/bin\/raidenauto"/' "${modpath}service.sh"
			sed -i '/https:\/\/raw.githubusercontent.com\/raidenkkj\/Raiden-Tweaks\/stable\/system\/bin\/rtksmenu/s/.*/wget -qO "${modpath}system\/bin\/rtksmenu" "https:\/\/raw.githubusercontent.com\/raidenkkj\/Raiden-Tweaks\/beta\/system\/bin\/rtksmenu"/' "${modpath}service.sh"
			sed -i '/https:\/\/raw.githubusercontent.com\/raidenkkj\/Raiden-Tweaks\/stable\/system\/bin\/lmkmenu/s/.*/wget -qO "${modpath}system\/bin\/lmkmenu" "https:\/\/raw.githubusercontent.com\/raidenkkj\/Raiden-Tweaks\/beta\/system\/bin\/lmkmenu"/' "${modpath}service.sh"
			sed -i '/https:\/\/raw.githubusercontent.com\/raidenkkj\/Raiden-Tweaks\/stable\/system\/bin\/unlockermenu/s/.*/wget -qO "${modpath}system\/bin\/unlockermenu" "https:\/\/raw.githubusercontent.com\/raidenkkj\/Raiden-Tweaks\/beta\/system\/bin\/unlockermenu"/' "${modpath}service.sh"
			sed -i '/https:\/\/raw.githubusercontent.com\/raidenkkj\/Raiden-Tweaks\/stable\/cleaner/s/.*/wget -qO "${modpath}system\/bin\/cleaner" "https:\/\/raw.githubusercontent.com\/raidenkkj\/Raiden-Tweaks\/beta\/cleaner"/' "${modpath}service.sh"
			sed -i '/https:\/\/raw.githubusercontent.com\/raidenkkj\/Raiden-Tweaks\/stable\/fstrim/s/.*/wget -qO "${modpath}system\/bin\/fstrim" "https:\/\/raw.githubusercontent.com\/raidenkkj\/Raiden-Tweaks\/beta\/fstrim"/' "${modpath}service.sh"
			sed -i '/https:\/\/raw.githubusercontent.com\/raidenkkj\/Raiden-Tweaks\/stable\/mod-util.sh/s/.*/wget -qO "${modpath}mod-util.sh" "https:\/\/raw.githubusercontent.com\/raidenkkj\/Raiden-Tweaks\/beta\/mod-util.sh"/' "${modpath}service.sh"
      ;;
   3)
      TEXTBRANCH="Tests"
			sed -i -e "/dbranch=/s/=.*/=tests/" "${modpath}module.prop"
			sed -i '/https:\/\/raw.githubusercontent.com\/raidenkkj\/Raiden-Tweaks\/stable\/system\/bin\/raidentweaks/s/.*/wget -qO "${modpath}system\/bin\/raidentweaks" "https:\/\/raw.githubusercontent.com\/raidenkkj\/Raiden-Tweaks\/tests\/system\/bin\/raidentweaks"/' "${modpath}service.sh"
			sed -i '/https:\/\/raw.githubusercontent.com\/raidenkkj\/Raiden-Tweaks\/stable\/system\/bin\/raidenauto/s/.*/wget -qO "${modpath}system\/bin\/raidenauto" "https:\/\/raw.githubusercontent.com\/raidenkkj\/Raiden-Tweaks\/tests\/system\/bin\/raidenauto"/' "${modpath}service.sh"
			sed -i '/https:\/\/raw.githubusercontent.com\/raidenkkj\/Raiden-Tweaks\/stable\/system\/bin\/rtksmenu/s/.*/wget -qO "${modpath}system\/bin\/rtksmenu" "https:\/\/raw.githubusercontent.com\/raidenkkj\/Raiden-Tweaks\/tests\/system\/bin\/rtksmenu"/' "${modpath}service.sh"
			sed -i '/https:\/\/raw.githubusercontent.com\/raidenkkj\/Raiden-Tweaks\/stable\/system\/bin\/lmkmenu/s/.*/wget -qO "${modpath}system\/bin\/lmkmenu" "https:\/\/raw.githubusercontent.com\/raidenkkj\/Raiden-Tweaks\/tests\/system\/bin\/lmkmenu"/' "${modpath}service.sh"
			sed -i '/https:\/\/raw.githubusercontent.com\/raidenkkj\/Raiden-Tweaks\/stable\/system\/bin\/unlockermenu/s/.*/wget -qO "${modpath}system\/bin\/unlockermenu" "https:\/\/raw.githubusercontent.com\/raidenkkj\/Raiden-Tweaks\/tests\/system\/bin\/unlockermenu"/' "${modpath}service.sh"
			sed -i '/https:\/\/raw.githubusercontent.com\/raidenkkj\/Raiden-Tweaks\/stable\/cleaner/s/.*/wget -qO "${modpath}system\/bin\/cleaner" "https:\/\/raw.githubusercontent.com\/raidenkkj\/Raiden-Tweaks\/tests\/cleaner"/' "${modpath}service.sh"
			sed -i '/https:\/\/raw.githubusercontent.com\/raidenkkj\/Raiden-Tweaks\/stable\/fstrim/s/.*/wget -qO "${modpath}system\/bin\/fstrim" "https:\/\/raw.githubusercontent.com\/raidenkkj\/Raiden-Tweaks\/tests\/fstrim"/' "${modpath}service.sh"
			sed -i '/https:\/\/raw.githubusercontent.com\/raidenkkj\/Raiden-Tweaks\/stable\/mod-util.sh/s/.*/wget -qO "${modpath}mod-util.sh" "https:\/\/raw.githubusercontent.com\/raidenkkj\/Raiden-Tweaks\/tests\/mod-util.sh"/' "${modpath}service.sh"
      ;;

esac

# Print the selected option to the user
ui_print ""
ui_print "[*] - Selected: $TEXTBRANCH "
ui_print ""
sleep 3

done

ui_print "[*] - Downloading the latest script(s) / application from Github..."
ui_print ""
wget -O "${modpath}system/bin/raidentweaks" "https://raw.githubusercontent.com/raidenkkj/Raiden-Tweaks/stable/system/bin/raidentweaks"
wget -O "${modpath}system/bin/raidenauto" "https://raw.githubusercontent.com/raidenkkj/Raiden-Tweaks/stable/system/bin/raidenauto"
wget -O "${modpath}system/bin/rtksmenu" "https://raw.githubusercontent.com/raidenkkj/Raiden-Tweaks/stable/system/bin/rtksmenu"
wget -O "${modpath}system/bin/lmkmenu" "https://raw.githubusercontent.com/raidenkkj/Raiden-Tweaks/stable/system/bin/lmkmenu"
wget -O "${modpath}system/bin/cleaner" "https://raw.githubusercontent.com/raidenkkj/Raiden-Tweaks/stable/cleaner"
wget -O "${modpath}system/bin/unlockermenu" "https://raw.githubusercontent.com/raidenkkj/Raiden-Tweaks/stable/system/bin/unlockermenu"
wget -O "${modpath}system/bin/rfstrim" "https://raw.githubusercontent.com/raidenkkj/Raiden-Tweaks/stable/rfstrim"
wget -O "${modpath}mod-util.sh" "https://raw.githubusercontent.com/raidenkkj/Raiden-Tweaks/stable/mod-util.sh"
wget -O "/data/local/tmp/RaidenTweaks.apk" "https://github.com/raidenkkj/Raiden-Tweaks/blob/stable/RaidenTweaks.apk?raw=true"
wget -O "/data/local/tmp/RDToast.apk" "https://github.com/raidenkkj/Raiden-Tweaks/blob/stable/RDToast.apk?raw=true"

# Permissions 
set_perm_recursive "${modpath}system/bin" 0 0 0777 0755

# Uninstalling old version (if exists) and installing new version of the main application...
ui_print "[*] - Uninstalling old (if u have) and installing new version of the main application..."

if [ "$(pm list package org.rtks.raiden)" ]; then
   pm uninstall -k --user 0 org.rtks.raiden
elif [ "$(pm list package com.raidentweaks)" ]; then
   pm uninstall -k --user 0 com.raidentweaks
fi

pm install /data/local/tmp/RaidenTweaks.apk

# Uninstalling old version (if exists) and installing new version of the toast application...
ui_print ""
ui_print "[*] - Uninstalling old (if u have) and installing new version of the toast application..."

# Uninstall the app if installed
if [ "$(pm list package bellavita.toast)" ]; then
   pm uninstall -k --user 0 bellavita.toast
fi

pm install /data/local/tmp/RDToast.apk

ui_print ""
ui_print " - Created by raidenkk @ (Telegram) "
sleep 0.5
ui_print ""
ui_print " - Contributors / credits:"
sleep 0.5
ui_print ""
ui_print " - King Tweaks dev: pedro3z0 @ (Telegram) "
sleep 0.5
ui_print ""
ui_print " - Spectrum dev: frap129 @ (GitHub) "
sleep 0.5
ui_print ""
ui_print " - Zeus Tweaks dev: KiraaDeath @ (Telegram) "
sleep 0.5
ui_print ""
ui_print " - Apollon dev: Haxis_Lancelot @ (Telegram) "
sleep 0.5
ui_print ""
ui_print " - Mod Utils dev: Veez21 @ (GitHub) "
sleep 0.5
ui_print ""
ui_print " - MMT-Extended dev: Zackptg5 @ (GitHub) "
sleep 0.5
ui_print ""
ui_print " - Join my support group: @raidenprjksgroup (Telegram) "
sleep 0.5
ui_print ""
ui_print " - Thanks to everyone for the feedback, it helps a lot. ❤️"
sleep 0.5

# Displaying message about installation logs and recommendations
ui_print ""
ui_print "[i] - The logs are in a hidden place"
ui_print "      if you want the logs, get it using rtksmenu."
ui_print ""
ui_print "[!] - Consider saving installation logs to"
ui_print "      resolve potential issues if necessary."
echo ""
sleep 2
