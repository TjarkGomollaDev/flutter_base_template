# Clean Architecture Flutter Template

Dieses Projekt dient als strikte Vorlage (Template) für alle zukünftigen Flutter-Projekte. Die AI und Entwickler müssen sich zwingend an diese Struktur halten.

## Grundprinzipien
1. **Clean Architecture:** Die App ist in 4 Schichten (Layers) unterteilt. Abhängigkeiten fließen **immer nur nach unten**, niemals nach oben.
2. **BLoC (Business Logic Component):** Das einzige erlaubte State Management Pattern. Jegliche UI-Logik muss in BLoCs gekapselt werden. Struktur: `bloc_name_bloc.dart`, `bloc_name_event.dart`, `bloc_name_state.dart`. Aufbau analog zum `ThemeBloc` (Events und States als `part of` Datei, `on<Event>`-Registrierung im Constructor).
3. **Dependency Injection:** Via `get_it`. Alles (BLoCs, Repositories, Datasources) muss in der `app_dependency_injection.dart` registriert und als Interface bereitgestellt werden.
4. **Zentrale Konfiguration:** Theme, Constants, Router und DI sind zentral in `app_*.dart` Dateien auf Root-Ebene des `lib` Ordners definiert.
5. **Kein Hardcoded Text:** Jeglicher UI-Text **muss** über das `l10n`-System (arb-Dateien) eingebunden werden (`context.l10n`). Die App-Sprache wird über den `LocaleBloc` verwaltet.
6. **Routing:** Verwendung von `go_router` für ein modernes, deklaratives Routing-System.
7. **Environment-Management:** API-URLs und Umgebungs-Konfigurationen liegen in `lib/app_environment.dart` (Root-Ebene).
8. **Logging & API:** Logging passiert App-weit über das `logger` Package (Singleton über DI verfügbar als `sl<Logger>()`). Der Logger soll nicht überall, sondern **nur an kritischen Knotenpunkten** (z.B. in `catch`-Blöcken von Repositories) eingesetzt werden. Für API-Traffic **muss zwingend** der injizierte `ApiClient` (`lib/core/network/api_client.dart`) verwendet werden. Niemals Standard `http` oder eigene `Dio` Instanzen verwenden! Der Client hat einen Interceptor, der Requests, Responses und Errors automatisch über den Logger ausgibt. Alle API-Fehler werden als `ApiException` geworfen.
9. **Extensions:** Bestehende Extensions in `lib/core/extensions/` **müssen** verwendet werden, wenn möglich. Bei Bedarf sind diese durch neue, generische Extensions zu ergänzen.
10. **Code Comments:** Alle Kommentare in der Codebase **müssen** auf Englisch verfasst sein und einen einheitlichen Stil verfolgen. Für Dokumentation von Klassen, Methoden und Eigenschaften sind `///` (Doc Comments) zu verwenden, für einfache Erklärungen im Code `//`.
11. **Equatable:** Verwende das Package `equatable` für BLoC States/Events sowie für alle Entities und Models. Dies garantiert Wertegleichheit (Value Equality) ohne manuellen Boilerplate-Code und verhindert unnötige UI-Rebuilds.
12. **UI-Test-Anker:** Interaktive Widgets ohne eindeutigen, stabilen Text-Anker (Icon-Buttons, Tab-Items, Felder, Listen-Items) bekommen einen `Key` nach Schema `Key('<screen>_<element>')` (z.B. `home_page`, `page_2_page`), damit UI-Tests sie sprachunabhängig finden können. Details siehe Abschnitt **UI-Testing**.
---

## Die 4 Schichten (Layers)

### 1st Layer: Presentation (UI)
*   **Zweck:** Alles, was der User sieht und womit er interagiert. BLoC Events abfeuern und auf BLoC States hören (`BlocBuilder`, `BlocConsumer`).
*   **Struktur:** 
    *   Jedes Feature bekommt einen eigenen Ordner (z.B. `home`, `page_2`).
    *   Im Feature-Ordner liegt die Page (`home_page.dart`) und ein Unterordner `widgets/` für alle Widgets, die nur auf dieser Page genutzt werden.
    *   Zentrale Widgets, die auf mehreren Seiten gebraucht werden, gehören in `core_widgets.dart/`.

### 2nd Layer: Application (State Management)
*   **Zweck:** BLoC Klassen. Sie verbinden UI mit der Domain-Schicht.
*   **Regel:** BLoCs dürfen **niemals** direkt auf den 4. Layer (Infrastructure) zugreifen. Sie kennen nur die Interfaces aus dem 3. Layer (Domain).
*   **Struktur:** Aufbau analog zum `ThemeBloc` (Events/States über `part`/`part of`).

### 3rd Layer: Domain (Business Logic & Interfaces)
*   **Zweck:** Der Kern der App. Hier liegen Entities (abstrakte Datentypen) und abstrakte Interfaces für Repositories/Datasources.
*   **Regel:** Dieser Layer darf absolut **keine** Abhängigkeiten zu Flutter-Paketen (`flutter/material.dart`, Firebase, HTTP, etc.) oder zum 4. Layer haben.

### 4th Layer: Infrastructure (Implementation & Models)
*   **Zweck:** Konkrete Implementierung der Interfaces aus dem 3. Layer. Hier finden API-Calls, Datenbank-Abfragen und das Parsing von JSON (`Models`) statt.
*   **Struktur:**
    *   `models/`: Hier liegen die Models.
    *   `repositories/`: Implementieren die `Interface...Repository` aus Layer 3.
    *   `local_datasources/` / `remote_datasources/`: Implementieren die `Interface...Datasource` aus Layer 3.

---

## App-Konfiguration und wichtige Pfade

*   **`app_theme.dart`**: Verwaltet das komplette Styling. Verwendet saubere Paletten (`ColorPalette`, `ShadowPalette`) als Theme-Extensions. Neue Farben müssen als Light/Dark Varianten in diesen Paletten ergänzt werden.
*   **`app_constants.dart`**: Beinhaltet feste Werte für Paddings, Radii, Icon-Sizes etc. Es werden keine hartgecodeten Zahlen in der UI verwendet, sondern immer auf `AppConstants` zurückgegriffen.
*   **`app_dependency_injection.dart`**: Registriert alle BLoCs, Interfaces und externen Pakete.
*   **`app_router`**: Definition der `go_router` Konfiguration.
*   **`app_enviroment`**: API-Urls und Umgebungs-Konfiguration.
*   **`core/`**: Beinhaltet Extensions, Fehler-Klassen und Enums, die App-weit gültig sind.
    *   `core/network/api_client.dart`: Zentraler API-Client basierend auf Dio. **Muss** zwingend für alle Netzwerk-Anfragen in den Remote-Datasources verwendet werden. Reicht Fehler als `ApiException` weiter.
    *   `core/exceptions/api_exceptions.dart`: Vereinheitlichte Fehlerklasse für Netzwerk-/Serverfehler. Inklusive `ApiErrorType` Enum, um in der UI saubere Übersetzungen anzeigen zu können.
*   **`app_bloc_observer.dart`**: Beobachtet und loggt automatisch alle BLoC Events und State-Changes via `logger`.
*   **`l10n/`**:: Alle Übersetzungs-Dateien (`.arb`).

## Beispiel-Feature (`ExampleItem`)
Im Template existiert ein Dummy-Feature `ExampleItem`, das exakt demonstriert, wie die Verbindung von 3. zu 4. Layer funktioniert:
1.  **Domain:** `ExampleItemEntity` definiert die Properties. `InterfaceExampleItemRepository` definiert die Methoden.
2.  **Infrastructure:** `ExampleItemModel` mit JSON-Parsing und falls gebraucht Domain-Parsing. `ExampleItemRepository` implements `InterfaceExampleItemRepository` und liefert Models zurück (die automatisch als Entities erkannt werden).

## UI-Testing

*   **Keys als Test-Anker:** Interaktive Widgets ohne eindeutigen, stabilen Text-Anker (Icon-Buttons, Tab-Items, Felder, Listen-Items) bekommen einen `Key` nach Schema `Key('<screen>_<element>')` (z.B. `home_page`, `page_2_page`).
*   **Statischer Text braucht keinen Key:** Elemente mit sichtbarem, STATISCHEM Text werden im Test via `find.text(...)` gefunden. Lokalisierte Texte (`context.l10n`) sind als Finder NICHT zuverlässig (sprachabhängig) -> dort Keys setzen.
*   **Barrierefreiheit vor totem Key:** Wo Barrierefreiheit sinnvoll ist, `Semantics(label:)` statt totem Key verwenden (doppelter Nutzen: Screenreader + `find.bySemanticsLabel`).
*   **Kein Wildwuchs:** Keys nur setzen, wo der Test sonst nichts Eindeutiges hat.
*   **Ort & Ausführung:** UI-Tests liegen in `integration_test/` (Beispiel: `integration_test/app_test.dart`), laufen echt auf dem Simulator via `flutter drive` und schreiben Screenshots nach `integration_test/screenshots/`. Ausführbar über den `/test-ui`-Skill.