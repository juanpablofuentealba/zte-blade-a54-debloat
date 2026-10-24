# ZTE Blade A54 — Debloat Guide (Android 13 / MyOS)

Guía completa para **desinstalar bloatware y spyware** del **ZTE Blade A54** (Android 13, MyOS) **sin root**, usando **Shizuku + rish** desde **Termux**.

> ✅ Probado y verificado en un ZTE Blade A54 real — **53 paquetes eliminados** sin root, sin PC y sin cable.
> ⚠️ Todos los cambios son **reversibles**.

---

## 📱 Dispositivo objetivo

| Dato | Valor |
|---|---|
| Modelo | ZTE Blade A54 |
| Código | P963F64 |
| Marca | ZTE |
| SoC | Unisoc SC9863A (`sp9863a`) |
| Plataforma | Unisoc L3R |
| RAM | 4 GB (3.96 GiB) |
| Android | 13 (SDK 33) |
| ROM | MyOS13.0.1_A54_WOM_CL |
| Build | `ZTE/P963F64/P963F64:13/TP1A.220624.014/20231121.104944:user/release-keys` |
| Parche de seguridad | 2023-11-05 |

---

## 🧰 Requisitos

- Un **ZTE Blade A54** (probablemente sirve en otros ZTE con MyOS/Unisoc).
- **Termux** instalado (F-Droid o GitHub, **no** Play Store).
- **Shizuku** instalado ([Play Store](https://play.google.com/store/apps/details?id=moe.shizuku.privileged.api) o [GitHub](https://github.com/RikkaApps/Shizuku)).
- **pi.dev** instalado en Termux (el agente que ejecuta la guía — ver abajo).
- Opcional: **Termux:API** (para leer datos de WiFi/batería).

> No necesitas root, ni PC, ni cable USB.

---

## 🤖 Paso 0 — Instalar pi.dev en Termux

Esta guía se diseñó para ejecutarse con **[pi](https://pi.dev)**, un agente de código para la terminal. Instálalo en Termux:

```bash
# Dentro de Termux
pkg update && pkg install -y nodejs
npm install -g @earendil-works/pi-coding-agent
```

Verifica la instalación:

```bash
pi --version
```

Luego inicia el agente dentro de la carpeta del repo:

```bash
cd zte-blade-a54-debloat
pi
```

> 💡 Con pi puedes pedirle cosas como *"lee el README y ejecuta el debloat paso a paso"*, y el agente te guía o ejecuta los comandos por ti.

> Si no quieres usar pi, igual puedes seguir la guía manualmente: los scripts `debloat.sh` y `restore.sh` funcionan solos con bash.

---

## 🚀 Método: Shizuku + rish (recomendado)

`rish` es un **cliente de shell** que Shizuku pone a disposición. Ejecuta comandos con **uid=2000 (shell)**, que es exactamente el privilegio que Android usa para ADB. Con eso, `pm uninstall` funciona.

### Paso 1 — Iniciar Shizuku

1. Activa **Opciones de desarrollador** (Ajustes → Acerca del teléfono → toca "Número de compilación" 7 veces).
2. En Opciones de desarrollador activa **Depuración inalámbrica**.
3. Abre **Shizuku** → "Iniciar por depuración inalámbrica" → sigue los pasos (empareja en Opciones de desarrollador → Depuración inalámbrica → "Emparejar dispositivo con código").
4. Verifica que Shizuku diga **"Shizuku en ejecución"**.

### Paso 2 — Instalar rish en Termux

Shizuku trae el script `rish` dentro de su app. Cópialo a Termux:

```bash
# Dentro de Termux
pkg install -y android-tools   # opcional, por si acaso

# Descarga rish y el dex desde el repo de Shizuku (o usa "Start" -> "Use Shizuku in terminal")
# Opción A: desde la app Shizuku -> menú -> "Usar Shizuku en terminal apps"
# Opción B: copia manual de rish + rish_shizuku.dex a ~/
```

Al final debes tener en tu home:

```bash
~/rish
~/rish_shizuku.dex
~/.rishrc   # opcional: export RISH_APPLICATION_ID=com.termux
```

El archivo `~/.rishrc` debe contener (si tu app de terminal es Termux):

```bash
export RISH_APPLICATION_ID=com.termux
export PATH="$HOME/bin:$PATH"
```

### Paso 3 — Verificar permisos

```bash
cd ~
./rish -c "id"
```

Debe mostrar **`uid=2000(shell)`**. Si aparece eso, ¡ya tienes privilegios de shell! 🎉

Si ves un error tipo:
```
Request timeout. The connection between the current app (com.termux) and Shizuku app may be blocked...
```
→ Shizuku se durmió. Ve a la sección [Problemas conocidos](#-problemas-conocidos).

### Paso 4 — Desinstalar el bloat

La lista completa está en [`debloat.sh`](debloat.sh). Ejecuta:

```bash
cd ~
bash debloat.sh
```

O manualmente, paquete por paquete:

```bash
./rish -c "pm uninstall --user 0 com.zte.zdmdaemon"
```

---

## 📋 Lista de paquetes eliminados (53)

Ver [`packages.json`](packages.json) para la lista completa con descripciones.

### Bloat / spyware ZTE y Unisoc/Spreadtrum

| Paquete | Qué es |
|---|---|
| `com.zte.zdmdaemon` | Rastreador ZTE — "logs inútiles, recolección de datos" |
| `com.zte.zdmdaemon.install` | Igual, recolector de datos |
| `com.spreadtrum.sgps` | **Spyware GPS chino** |
| `com.sprd.logmanager` | Logs ocultos (YLog) |
| `com.sprd.uasetting` | UserAgent setting, frameworks inútiles |
| `com.sprd.validationtools` | Tests de hardware ocultos, códigos secretos |
| `com.sprd.engineermode` | Modo test de hardware |
| `com.sprd.srmi` | Logs ocultos |
| `com.sprd.linkturbo` | "Turbo WiFi" con logs inútiles |
| `com.sprd.cameracalibration` | Calibración/test de cámara |
| `com.zte.emode` | Test de componentes de hardware |
| `com.zte.easymode` | Easy mode |
| `com.zte.onekeycp` | Phone Switch / PC Connect |
| `com.zte.privacyzone` | App Lock / Password Manager |
| `com.zte.setupwizard` | Solo necesario en primer arranque |
| `com.zte.zbackup.platservice` | Backup service con muchísimos permisos |
| `cn.zte.recorder` | Grabadora ZTE — **33 permisos, habla con servidores Baidu** |
| `zpub.res` | App de terceros preinstalada en ZTE |
| `com.zte.faceverify` | ⚠️ **NO incluido por defecto** — desbloqueo facial |

### Google innecesario

`com.google.android.apps.maps`, `.gm` (Gmail), `.calendar`, `.keep`, `.calculator`,
`.apps.translate`, `.apps.docs`, `.apps.docs.editors.docs`, `.apps.docs.editors.sheets`,
`.apps.youtube.music`, `.apps.restore`, `.feedback`, `.as`, `.as.oss`,
`.ondevicepersonalization.services`, `.federatedcompute`, `.adservices.api`,
`com.google.mainline.adservices`, `.gms.location.history`, `.gms.supervision`,
`.gmsintegration`, `.onetimeinitializer`, `.tag`

### AOSP inofensivo

`com.android.egg`, `com.android.traceur`, `com.android.providers.partnerbookmarks`,
`com.android.theme.font.notoserifsource`, `com.android.cellbroadcast.overlay`,
`com.android.remoteprovisioner`

### Redes sociales preinstaladas

`com.facebook.katana`, `com.facebook.orca`, `com.facebook.appmanager`,
`com.facebook.services`, `com.instagram.android`, `com.zhiliaoapp.musically` (TikTok)

---

## ⛔ NO desinstalar (romperías el teléfono)

| Paquete | Por qué |
|---|---|
| `com.zte.mifavor.launcher` (+ `.resource`, `.adapter`) | Es tu **launcher** |
| `com.zte.fingerprints`, `com.ztefingerprint.service` | **Huella dactilar** |
| `com.android.ztescreenshot` | **Capturas de pantalla** |
| `com.spreadtrum.ims` | **VoLTE / llamadas** |
| `com.android.unisoc.telephony.server` | **Llamadas entrantes** |
| `com.zte.zdm.omacp` | Configuración SMS |
| `com.android.phone` | Marcador/telefonía |
| `com.android.settings` | Ajustes |
| `com.android.systemui` | Interfaz del sistema |
| `com.google.android.gms` / `.gsf` | Play Services |
| `com.google.android.webview` | WebView (muchas apps lo usan) |

---

## 🔄 Revertir cambios

Como se desinstala a nivel de **usuario 0** (`--user 0`), el APK sigue en la partición de sistema. Para recuperar cualquier app:

```bash
./rish -c "cmd package install-existing com.zte.zdmdaemon"
```

También puedes reinstalar desde Play Store si la app está disponible.

---

## ⚠️ Problemas conocidos

### Shizuku se duerme / "Request timeout"

ZTE (MyOS) es **muy agresivo** matando procesos en segundo plano. Solución:

1. Ajustes → Apps → **Shizuku** → Batería → **Sin restricciones**.
2. Ajustes → Apps → **Termux** → Batería → **Sin restricciones**.
3. En MyOS: Ajustes → Batería → **Gestión de energía de apps** → busca ambas → "No restringir".
4. Vuelve a iniciar Shizuku si se detuvo.

Consejo: desinstala **de a pocos paquetes** con una pausa (`sleep 1`) entre cada uno para no saturar la conexión Shizuku↔Termux.

### `pm uninstall` da `NullPointerException`

Significa que **no** estás usando `rish` (o Shizuku no está activo). Ejecuta desde `./rish -c "..."`, no directamente desde Termux. Termux **no** hereda permisos de Shizuku por sí solo.

---

## 📊 Resultados

| Métrica | Antes | Después |
|---|---|---|
| Paquetes totales | ~236 | **217** |
| Apps de sistema | 236 | 189 |
| Bloat eliminado | — | **53** |

- Facebook/Instagram/TikTok: **0 rastros**
- Spyware ZTE/Spreadtrum: eliminado
- Launcher, huella, cámara, telefonía: **intactos**

---

## 📁 Contenido del repo

| Archivo | Descripción |
|---|---|
| `debloat.sh` | Script que desinstala toda la lista con pausas |
| `packages.json` | Lista de los 53 paquetes + descripción |
| `restore.sh` | Script para revertir (reinstalar) todo |
| `device-info.txt` | Información cruda del dispositivo |

---

## ⚖️ Aviso

Este procedimiento se probó en **un** dispositivo concreto (ZTE Blade A54, build `MyOS13.0.1_A54_WOM_CL`). Otras variantes/regiones pueden tener paquetes distintos. **Revisa la lista antes de ejecutar** y desinstala bajo tu propio riesgo. Siempre puedes revertir con `install-existing`.

---

## 🙏 Créditos

- [Universal Android Debloater NG](https://github.com/Universal-Debloater-Alliance/universal-android-debloater-next-generation) — fuente de las recomendaciones de qué es seguro quitar.
- [Shizuku](https://github.com/RikkaApps/Shizuku) — por hacer posible el shell sin root.
- [Canta](https://github.com/samolego/Canta) — alternativa con GUI usando Shizuku.
