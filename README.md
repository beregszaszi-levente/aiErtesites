# aiErtesites — Opencode feladat-értesítés iPhone-ra push-kal

Egy PowerShell wrapper szkript, amely futtatja az `opencode` parancsot, és ha a feladat befejeződött, push értesítést küld az iPhone-ra az ingyenes [ntfy.sh](https://ntfy.sh) szolgáltatáson keresztül.

## Mit csinál?

- Futtatja az `opencode` parancsot átadott argumentumokkal.
- A végrehajtás utánpush értesítést küld az iPhone-ra (siker vagy hiba esetén).
- Visszaadja az opencode eredeti kilépési kódját.

## Beállítás

### 1. ntfy app telepítése az iPhone-ra

Töltse le az [ntfy appot az App Store-ból](https://apps.apple.com/app/ntfy/id1556433187).

### 2. Téma kiválasztása

Nyissa meg az ntfy appot, és feliratkozzon egy témára, például: `ai-ertesites-opencode`

Ez a téma lesz az értesítések célpontja. Bárki, aki tudja a témanevet, küldhet üzenetet rá, de csak az, aki feliratkozott, kapja meg az értesítéseket.

### 3. Környezeti változó beállítása (PowerShell)

Futtassa ezt a PowerShell-ben (az aktuális ablakban):

```powershell
$env:NTFY_TOPIC = "ai-ertesites-opencode"
```

Stálásbe állításhoz adja hozzá a profilhoz:

```powershell
Add-Content $PROFILE '$env:NTFY_TOPIC = "ai-ertesites-opencode"'
```

Vagy szerkessze közvetlenül az `opencode-errejtes.ps1` fájlban a `$defaultTopic` változót.

### 4. Futtatás

A terminálban (PowerShell), a repó mappájában:

```powershell
./opencode-errejtes.ps1
```

Vagy argumentumokkal együtt:

```powershell
./opencode-errejtes.ps1 --args --ide
```

A szkript futtatja az `opencode`-t, és amikor végzett, push értesítés érkezik az iPhone-ra.

## Fájlok

| Fájl | Leírás |
|------|--------|
| `opencode-errejtes.ps1` | A wrapper szkript, futtatja az opencode-ot és küldi az értesítést |
| `README.md` | Ez a dokumentáció |

## Megjegyzések

- Az ntfy.sh ingyenes, nem verlang regisztrációt, és nincs felhasználói fiók.
- Az értesítés csak akkor érkezik, ha az ntfy app fut az iPhone-on (háttérben is működik).
- A kilépési kód alapján a szkript különböző prioritást és ikont használ (siker: ✅ default, hiba: ❌ high).
