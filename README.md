# Flutter Base Template

Dieses Repository dient als **Template** für alle zukünftigen Flutter-Projekte. Es ist strikt nach **Clean Architecture** Richtlinien aufgebaut und nutzt **BLoC** für das State Management.

Ziel ist es, jedem neuen Projekt – insbesondere bei der Zusammenarbeit mit einer AI – einen sofort einsatzbereiten, stabilen und extrem sauberen Startpunkt zu bieten.

## 🧩 Kern-Konzepte

- **4-Schichten-Modell**: Strikte Trennung von Presentation, Application (BLoC), Domain (Entities/Interfaces) und Infrastructure (Repositories/Models).
- **Zentrale App-Konfiguration**: Theme, Constants, Router (`go_router`), DI (`get_it`) und Environment-Handling (`app_environment.dart`) sind zentral im `lib`-Root verankert.
- **Modernes Routing**: Nutzung von `go_router` mit `StatefulShellRoute` für nahtlose Navigation mit `BottomNavigationBar`.
- **Internationalisierung**: Integriertes `l10n`-System für einfache Mehrsprachigkeit (Deutsch/Englisch).
- **Theming**: Vorgefertigte, robuste Light/Dark-Theme-Struktur über Extension-Methods (`ColorPalette`, `ShadowPalette`).

## 🧰 Wie starte ich ein neues Projekt?

1. Repository klonen.
2. Der genaue Plan samt Features für die gesamte App sollte in **PROMPT.md** hinterlegt und das UI-Design sollte in **DESIGN.md** spezifiziert werden.
3. Dann der AI mitteilen: *"Setze mir den Plan aus PROMPT.md um."* In der **AGENTS.md** wird bereits auf **ARCHITECTURE.md** und **DESIGN.md** verwiesen. Die **ARCHITECTURE.md** kann falls gewünscht natürlich noch erweitert werden.
4. Im weiteren Projekt-Verlauf sollten neue Feature-Prompts in seperate Dateien hinterlegt werden.

*Erstellt als saubere Basis für alle zukünftigen Entwicklungen.*
