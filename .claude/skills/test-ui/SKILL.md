---
name: test-ui
description: Testet die App-UI auf iOS-Simulator und/oder Android-Emulator via integration_test + flutter drive, macht Screenshots und prüft sie visuell. Nur manuell via /test-ui.
argument-hint: [ios|android|both] [optionaler Fokus/Screen]
allowed-tools: Bash(xcrun simctl:*), Bash(flutter:*), Bash(adb:*), Bash(open:*), Read
---

> **NUR MANUELL.** Dieser Skill wird ausschließlich ausgeführt, wenn der User
> ihn selbst per `/test-ui` aufruft. Claude darf ihn **niemals** von sich aus,
> automatisch oder „vorsorglich" starten – auch nicht als Teil eines anderen
> Tasks, einer Verifikation oder eines Reviews. Kein Simulator/Emulator-Boot und
> kein `flutter drive` ohne expliziten `/test-ui`-Aufruf des Users.

Gebootete iOS-Simulatoren: !`xcrun simctl list devices booted`
Verfügbare Geräte (flutter): !`flutter devices`

Du testest die App-UI echt auf dem Gerät und prüfst das Ergebnis visuell.

**Argumente:** `$ARGUMENTS`
- Erstes Wort, falls `ios`, `android` oder `both`: wählt die Plattform.
  **Ohne Angabe = `ios`** (Default).
- Der Rest ist ein optionaler visueller Fokus (z.B. "prüfe das Bottom-Nav-Highlight").

## Ablauf

1. **Plattform bestimmen** aus dem ersten Argument (Default `ios`).

2. **Gerät bereitstellen:**
   - **iOS:** Prüfe den Live-Kontext oben. Läuft kein Simulator, ein verfügbares
     iPhone booten (`xcrun simctl boot <udid>`) und `open -a Simulator`.
   - **Android:** Prüfe via `flutter devices`, ob ein Emulator läuft. Wenn nicht:
     `flutter emulators` auflisten, einen mit `flutter emulators --launch <id>`
     starten und mit `adb wait-for-device` auf die Bootbereitschaft warten.

3. **UI-Tests ausführen** (App am Ende **offen lassen** via `--keep-app-running`):
   ```
   flutter drive \
     --driver=test_driver/integration_test.dart \
     --target=integration_test/app_test.dart \
     -d <device-id> \
     --keep-app-running
   ```
   Bei `both`: erst iOS, dann Android nacheinander (je eigenes Gerät).

4. **Screenshots prüfen:** Die PNGs unter `integration_test/screenshots/` per Read
   öffnen und visuell gegen die Erwartung / den Fokus prüfen (Layout, Inhalte,
   Fehlerzustände). Die Dateien sind plattform-präfixiert
   (`ios_01_home.png`, `android_01_home.png`, …) — bei `both` beide Sätze
   vergleichen.

5. **Bericht:** Testergebnis (grün/rot) pro Plattform + visuelle Auffälligkeiten.

## Hinweise

- Die App bleibt nach dem Lauf absichtlich offen (`--keep-app-running`), damit man
  manuell weiterschauen kann. Ein erneuter `/test-ui`-Lauf startet ohnehin eine
  frische Instanz — die alte offen zu lassen ist unproblematisch.
- Screenshots sparsam einsetzen (Token-/Usage-Kosten ~1500 Tokens/Bild). Die
  Hauptarbeit sollen die Assertions im `integration_test` machen; Screenshots nur
  zur finalen visuellen Bestätigung heranziehen. `both` verdoppelt die Bild-Kosten.
