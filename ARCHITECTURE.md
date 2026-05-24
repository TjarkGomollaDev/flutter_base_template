# Clean Architecture Flutter Template

Dieses Projekt dient als strikte Vorlage (Template) für alle zukünftigen Flutter-Projekte. Die AI und Entwickler müssen sich zwingend an diese Struktur halten.

## Grundprinzipien
1. **Clean Architecture:** Die App ist in 4 Schichten (Layers) unterteilt. Abhängigkeiten fließen **immer nur nach unten**, niemals nach oben.
2. **BLoC (Business Logic Component):** Das einzige erlaubte State Management Pattern. Jegliche UI-Logik muss in BLoCs gekapselt werden.
3. **Dependency Injection:** Via `get_it`. Alles (BLoCs, Repositories, Datasources) muss in der `app_dependency_injection.dart` registriert und als Interface bereitgestellt werden.
4. **Zentrale Konfiguration:** Theme, Constants, Router und DI sind zentral in `app_*.dart` Dateien auf Root-Ebene des `lib` Ordners definiert.

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

### 3rd Layer: Domain (Business Logic & Interfaces)
*   **Zweck:** Der Kern der App. Hier liegen Entities (abstrakte Datentypen) und abstrakte Interfaces für Repositories/Datasources.
*   **Regel:** Dieser Layer darf absolut **keine** Abhängigkeiten zu Flutter-Paketen (`flutter/material.dart`, Firebase, HTTP, etc.) oder zum 4. Layer haben.

### 4th Layer: Infrastructure (Implementation & Models)
*   **Zweck:** Konkrete Implementierung der Interfaces aus dem 3. Layer. Hier finden API-Calls, Datenbank-Abfragen und das Parsing von JSON (`Models`) statt.
*   **Struktur:**
    *   `models/`: Erweitern (extends) die Entities aus Layer 3 und besitzen `fromJson` / `toJson` Methoden.
    *   `repositories/`: Implementieren die `Interface...Repository` aus Layer 3.
    *   `local_datasources/` / `remote_datasources/`: Implementieren die `Interface...Datasource` aus Layer 3.

---

## App-Konfiguration & Core

*   **`app_theme.dart`**: Verwaltet das komplette Styling. Verwendet saubere Paletten (`ColorPalette`, `ShadowPalette`) als Theme-Extensions. Neue Farben müssen als Light/Dark Varianten in diesen Paletten ergänzt werden.
*   **`app_constants.dart`**: Beinhaltet feste Werte für Paddings, Radii, Icon-Sizes etc. Es werden keine hartgecodeten Zahlen in der UI verwendet, sondern immer auf `AppConstants` zurückgegriffen.
*   **`app_dependency_injection.dart`**: Registriert alle BLoCs, Interfaces und externen Pakete.
*   **`core/`**: Beinhaltet Extensions, Fehler-Klassen und Enums, die App-weit gültig sind.

## Beispiel-Feature (`ExampleItem`)
Im Template existiert ein Dummy-Feature `ExampleItem`, das exakt demonstriert, wie die Verbindung von 3. zu 4. Layer funktioniert:
1.  **Domain:** `ExampleItemEntity` definiert die Properties. `InterfaceExampleItemRepository` definiert die Methoden.
2.  **Infrastructure:** `ExampleItemModel` extends `ExampleItemEntity` und fügt JSON-Parsing hinzu. `ExampleItemRepository` implements `InterfaceExampleItemRepository` und liefert Models zurück (die automatisch als Entities erkannt werden).