# aiErtesites — Opencode feladat-értesítés iPhone-ra push-kal

Két megoldás található a repóban, amelyek push értesítést küldnek az iPhone-ra az ingyenes [ntfy.sh](https://ntfy.sh) szolgáltatáson keresztül, amikor egy opencode feladat befejeződik.

## Megoldások

| Megoldás | Mikor küld értesítést | Hogyan működik |
|----------|----------------------|----------------|
| **Opencode plugin** (ajánlott) | Amikor egy belső opencode feladat befejeződik, az opencode tovább fut | `.opencode/plugins/ntfy-notify.js` — opencode plugin, automatikusan betöltődik induláskor |
| **Wrapper szkript** | Az opencode bezárásakor (kilépéskor) | `opencode-errejtes.ps1` — futtatja az opencode-ot, majd értesít |

---

## Megoldás 1: Opencode plugin (ajánlott)

Ez a megoldás akkor küldi az értesítést, amikor egy **belső opencode feladat befejeződik**, de az opencode tovább fut a következő feladatra.

### 1. ntfy app telepítése az iPhone-ra

Töltse le az [ntfy appot az App Store-ból](https://apps.apple.com/app/ntfy/id1556433187).

### 2. Téma kiválasztása

Nyissa meg az ntfy appot, és feliratkozzon egy témára, például: `ai-ertesites-opencode`

### 3. Környezeti változó beállítása

PowerShell-ben (az aktuális ablakban):

```powershell
$env:NTFY_TOPIC = "ai-ertesites-opencode"
```

Stálásbe állításhoz adja hozzá a profilhoz:

```powershell
Add-Content $PROFILE '$env:NTFY_TOPIC = "ai-ertesites-opencode"'
```

### 4. Plugin telepítése

Másolja a `.opencode/plugins/ntfy-notify.js` fájlt az opencode konfigurációs könyvtárába:

- **Windows:** `%USERPROFILE%\.opencode\plugins\`
- **Linux/Mac:** `~/.opencode/plugins/`

Vagy futtassa az opencode-ot a repó mappájában, mert a projekt szintű `.opencode/plugins/` könyvtárból is automatikusan betöltődik a plugin.

### 5. Használat

Indítsa el az opencode-ot normál módon:

```powershell
opencode
```

Amikor egy belső feladat befejeződik, push értesítés érkezik az iPhone-ra.

---

## Megoldás 2: Wrapper szkript (alternatív)

Ez a megoldás csak akkor küldi az értesítést, **kikor kilép az opencode-ból** (az egész folyamat végződik).

### Használat

```powershell
./opencode-errejtes.ps1
```

Vagy argumentumokkal együtt:

```powershell
./opencode-errejtes.ps1 --args --ide
```

A szkript futtatja az `opencode`-t, és amikor bezáródik, push értesítés érkezik az iPhone-ra.

---

## Fájlok

| Fájl | Leírás |
|------|--------|
| `.opencode/plugins/ntfy-notify.js` | Opencode plugin — értesítés belső feladat befejezéskor |
| `opencode-errejtes.ps1` | Wrapper szkript — értesítés az opencode bezárásakor |
| `README.md` | Ez a dokumentáció |

---

## Megjegyzések

- Az ntfy.sh ingyenes, nem verlang regisztrációt, és nincs felhasználói fiók.
- Az értesítés csak akkor érkezik, ha az ntfy app fut az iPhone-on (háttérben is működik).
- A `NTFY_TOPIC` környezeti változóval bármilyen témát használhat.
- A plugin hibát nem okoz az opencode-nek, ha az értesítés küldése sikertelen (pl. nincs internet).
