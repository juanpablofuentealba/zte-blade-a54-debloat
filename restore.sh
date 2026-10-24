#!/data/data/com.termux/files/usr/bin/bash
# Reinstala (revierte) los paquetes desinstalados por debloat.sh
# Uso: bash restore.sh

set -u
RISH="$HOME/rish"
PACKAGES=(
  cn.zte.recorder
  com.android.cellbroadcast.overlay
  com.android.egg
  com.android.providers.partnerbookmarks
  com.android.remoteprovisioner
  com.android.theme.font.notoserifsource
  com.android.traceur
  com.facebook.appmanager
  com.facebook.katana
  com.facebook.orca
  com.facebook.services
  com.google.android.adservices.api
  com.google.android.apps.docs
  com.google.android.apps.docs.editors.docs
  com.google.android.apps.docs.editors.sheets
  com.google.android.apps.maps
  com.google.android.apps.restore
  com.google.android.apps.translate
  com.google.android.apps.youtube.music
  com.google.android.as
  com.google.android.as.oss
  com.google.android.calculator
  com.google.android.calendar
  com.google.android.federatedcompute
  com.google.android.feedback
  com.google.android.gm
  com.google.android.gms.location.history
  com.google.android.gms.supervision
  com.google.android.gmsintegration
  com.google.android.keep
  com.google.android.ondevicepersonalization.services
  com.google.android.onetimeinitializer
  com.google.android.tag
  com.google.mainline.adservices
  com.instagram.android
  com.sprd.cameracalibration
  com.sprd.engineermode
  com.sprd.linkturbo
  com.sprd.logmanager
  com.sprd.srmi
  com.sprd.uasetting
  com.sprd.validationtools
  com.spreadtrum.sgps
  com.zhiliaoapp.musically
  com.zte.easymode
  com.zte.emode
  com.zte.onekeycp
  com.zte.privacyzone
  com.zte.setupwizard
  com.zte.zbackup.platservice
  com.zte.zdmdaemon
  com.zte.zdmdaemon.install
  zpub.res
)
echo "==> Reinstalando ${#PACKAGES[@]} paquetes..."
for pkg in "${PACKAGES[@]}"; do
  res=$("$RISH" -c "cmd package install-existing $pkg" 2>&1 | tr -d "\r" | head -1)
  echo "  $pkg -> $res"
  sleep 1
done
echo "==> Hecho."
