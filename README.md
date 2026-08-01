# Head Shooter

Minecraft-style bubble shooter — bubbles ki jagah mob heads. Built in **Defold**.
Mobile-first (720x1280, portrait, touch-perfect), GLES-friendly, low-end Android par bhi smooth chalega.

Engine ka full source `bob.jar` se GitHub Actions par hi build hota hai — koi PC/Defold-editor zaroori nahi.
Repo ko sirf `git push` karo, baaki sab CI karega.

---

## 1. Setup (one-time)

1. Ye poora folder apne GitHub repo mein push kar do (root mein `game.project` hona chahiye).
2. **GitHub Pages enable karo** (sirf ek baar):
   `Settings -> Pages -> Source -> "GitHub Actions"` select karo. Isके baad web build auto-deploy hoga.
3. **(Optional but recommended) Signed release APK ke liye keystore add karo:**
   ```bash
   keytool -genkeypair -v -keystore release.keystore -alias headshooter \
     -keyalg RSA -keysize 2048 -validity 10000
   base64 -w0 release.keystore > release.keystore.b64
   ```
   Fir repo mein `Settings -> Secrets and variables -> Actions` mein ye 3 secrets add karo:
   - `ANDROID_KEYSTORE_BASE64` -> `release.keystore.b64` ka content
   - `ANDROID_KEYSTORE_PASSWORD` -> keystore password
   - `ANDROID_KEY_ALIAS` -> `headshooter` (ya jo alias diya ho)

   Agar ye secrets nahi dete, CI apne aap ek debug key se sign karega (testing ke liye theek hai,
   Play Store upload ke liye nahi).

## 2. Build kaise trigger hota hai

`main` branch par har push par `.github/workflows/build.yml` chalta hai aur banata hai:

- `HeadShooter-universal.apk` — armv7 + arm64 dono, sabse safe/compatible APK
- `HeadShooter-arm64-v8a.apk` — sirf 64-bit devices, chhota size
- `HeadShooter-armeabi-v7a.apk` — sirf purane 32-bit devices
- `HeadShooter-web.zip` — HTML5 build ka zip
- Web build **GitHub Pages** par bhi auto-deploy hota hai

Sab ek fixed `latest` release tag ke andar upload hote hain — **har naya build purane assets ko replace
kar deta hai** (auto-delete-old, jaisa maanga tha), isliye release page hamesha sirf latest APKs dikhayega.

> ⚠️ **Important correction:** Defold mein Android ke sirf 2 hi architectures support hain —
> `armv7-android` aur `arm64-android`. `x86_64` Android target Defold mein exist hi nahi karta,
> isliye "4 formats" possible nahi tha — maine 3 real, working variants diye hain (universal /
> arm64-v8a / armeabi-v7a) jo Play Store ke liye bhi valid hain.

## 3. Controls

- **Drag** anywhere upar screen par aur **release** karo shoot karne ke liye — jitna upar/side drag karoge utna crossbow rotate hoga.
- **3 ya zyada same mob-head** touch honge to woh pop ho jayenge.
- Har 8 shots ke baad ek nayi row upar se aa jaati hai (difficulty ramp).
- Koi bhi row shooter ke paas pahunch gayi to **Game Over**.
- Top-right pause icon se pause/resume/restart/menu milta hai.

## 4. Project structure

```
main/            home screen (gui matches your screenshot: bg, header, play/settings/info/quit)
game/            gameplay: hex-grid logic, shooter, bubbles, HUD, pause/game-over
assets/ui/       tumhare uploaded assets (bg, buttons, bow, icons)
assets/mobs/     6 original blocky "mob head" sprites (procedurally generated pixel art —
                 Mojang ke exact textures copy nahi kiye, IP-safe original designs hain)
fonts/           Minecraft.ttf wired as a Defold font resource
.github/workflows/build.yml   CI: APKs + web build + release + pages deploy
```

## 5. Local test build (agar kabhi PC available ho)

```bash
curl -L -o bob.jar https://github.com/defold/defold/releases/latest/download/bob.jar
java -jar bob.jar resolve build   # needs JDK 25+
```

## 6. Known limitations / next steps

- Abhi sound/music nahi hai (assets nahi the) — `sound.gui_script` hooks easily add ho sakte hain.
- Mob head art original hai, Mojang ke actual textures nahi — chaho to apna khud ka pixel art
  `assets/mobs/*.png` mein replace kar sakte ho, naming same rakhna (`mob_*.png`, 6 types,
  `game/constants.lua` ke `MOB_TYPES` mein list hai).
- Ceiling-drop speed, colors count, shot speed sab `game/constants.lua` mein tweak-able hai.
