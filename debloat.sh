#!/data/data/com.termux/files/usr/bin/bash
# ZTE Blade A54 - Debloat via Shizuku + rish
# Desinstala bloatware/spyware sin root. Reversible.
# Uso: bash debloat.sh

set -u
cd "$(dirname "$0")" 2>/dev/null || true
RISH="$HOME/rish"

if [ ! -x "$RISH" ]; then
  echo "ERROR: no se encuentra rish en $RISH"
  echo "Copia rish y rish_shizuku.dex a tu home de Termux."
  exit 1
fi

echo "==> Verificando Shizuku..."
if ! "$RISH" -c "id" 2>/dev/null | grep -q "uid=2000"; then
  echo "ERROR: rish no responde como shell. Inicia Shizuku y desactiva la optimizacion de bateria."
  exit 1
fi
echo "OK: uid=2000(shell)"

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

echo ""
echo "==> Desinstalando ${#PACKAGES[@]} paquetes..."
ok=0; fail=0
for pkg in "${PACKAGES[@]}"; do
  for attempt in 1 2 3; do
    res=$("$RISH" -c "pm uninstall --user 0 $pkg" 2>&1 | tr -d "\r" | head -1)
    if echo "$res" | grep -q "Success"; then
      echo "  [OK]   $pkg"
      ok=$((ok+1)); break
    elif [ "$attempt" -eq 3 ]; then
      echo "  [FAIL] $pkg -> $res"
      fail=$((fail+1))
    else
      sleep 2
    fi
  done
  sleep 1
done

echo ""
echo "==> Listo. Desinstalados: $ok | Fallidos: $fail"
echo "Para revertir usa: bash restore.sh"
