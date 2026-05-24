# Flutter Base Template

Dieses Repository ist das offizielle **Template** für zukünftige Flutter-Projekte. Es ist strikt nach **Clean Architecture** Richtlinien aufgebaut und nutzt **BLoC** für das State Management.

Ziel ist es, jedem neuen Projekt – insbesondere bei der Zusammenarbeit mit einer AI – einen sofort einsatzbereiten, stabilen und extrem sauberen Startpunkt zu bieten. Das Risiko, aus der Struktur auszubrechen oder Code zu vermischen, wird dadurch stark minimiert.

## Kern-Konzepte

- **4-Schichten-Modell**: Strikte Trennung von `1st_layer_presentation`, `2nd_layer_application`, `3rd_layer_domain` und `4th_layer_infrastructure`.
- **Zentrale App-Konfiguration**: Alle systemweiten Einstellungen wie Theme (`app_theme.dart`), Konstanten (`app_constants.dart`), Router (`app_router.dart`) und Dependency Injection (`app_dependency_injection.dart`) sind zentral im `lib`-Root verankert.
- **Dependency Injection**: Über `get_it` ist garantiert, dass die Applikations- und Infrastruktur-Schicht über saubere Interfaces aus der Domain-Schicht entkoppelt sind.
- **Theming**: Vorgefertigte, wunderschöne Light/Dark-Theme-Struktur über Extension-Methods (`ColorPalette` und `ShadowPalette`), was das Hinzufügen neuer Farben vereinfacht.

## Wie starte ich ein neues Projekt?

1. Das Repository clonen/kopieren.
2. In der `ARCHITECTURE.md` (befindet sich im Root) sind alle exakten Regeln für die Entwicklung definiert. Die AI muss angewiesen werden, sich diese Datei durchzulesen, bevor sie Features implementiert.
3. Im Ordner `1st_layer_presentation/` können die existierenden Platzhalter (`page_2`, `page_3`, etc.) in echte Features umbenannt und aufgebaut werden.
4. Alle neuen BLoCs, Interfaces, Models und Repositories müssen den Regeln aus der `ARCHITECTURE.md` und dem `ExampleItem` Dummy-Feature folgen.

## Wichtige Dateien
- `ARCHITECTURE.md`: **Pflichtlektüre!** Das Herzstück für die Regeln der Architektur.
- `lib/app_theme.dart`: Zentrale Verwaltung des UIs und der Farb-Paletten.
- `lib/app_constants.dart`: Verwaltet alle Paddings, Radii, Margins und Standardgrößen.

---
*Erstellt als saubere Basis für alle zukünftigen Entwicklungen.*