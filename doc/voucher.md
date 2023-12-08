# GraphQL Schema Erweiterung

## Gutschein Typ

Bild (URL und Quellenangabe)
Titel
Kategorie
Kurztext/Einschränkungen
Langtext
Variante (Rabattbetrag oder alter/neuer Preis)
Kontingent (Anzahl, Einlösehäufigkeit, Maximalanzahl pro Person)
Start- und Enddatum
Sichtbarkeitsstatus
QR-Code (mit App-Deeplink)

## API-Endpunkte

- GutscheinErstellenMutation: Erstellt einen neuen Gutschein.
- GutscheinBearbeitenMutation: Aktualisiert einen vorhandenen Gutschein.
- GutscheinLöschenMutation: Markiert einen Gutschein als gelöscht.
- GutscheineAnzeigenQuery: Listet Gutscheine auf, eventuell mit Filteroptionen.
- GutscheinEinlösenMutation: Aktiviert einen Gutschein für den Nutzer.
- KundenStatusValidierenQuery: Überprüft, ob die Kundennummer gültig ist.
- GutscheinTransaktionenAnzeigenQuery: Zeigt die Historie der eingelösten Gutscheine an.

# Backend-Logik

## Datenbank-Modellierung

- Erstellen Sie Tabellen für Gutscheine, Gutscheintransaktionen und Nutzer-Gutschein-Zuordnungen.
- Stellen Sie Beziehungen zwischen Gutscheinen und POIs her.

## Geschäftslogik

- Implementieren Sie Logik für das Erstellen, Bearbeiten und Löschen von Gutscheinen.
- Fügen Sie Logik hinzu, um Gutscheine basierend auf Verfügbarkeit, Nutzerstatus und anderen Kriterien anzuzeigen.
- Entwickeln Sie eine Methode zur Validierung von Kundennummern gegen den Stadtwerke-Server.
- Berücksichtigen Sie die Offline-Einlösung von Gutscheinen und synchronisieren Sie diese Daten bei Wiederherstellung der Internetverbindung.

## Sicherheitsmaßnahmen

Implementieren Sie SSL und zusätzliche Verschlüsselung für Anfragen.
Begrenzen Sie die Anzahl der Gutscheineinlösungen pro Zeiteinheit und Gerät.
Protokollieren Sie Meta-Daten bei Gutschein-Transaktionen, um Missbrauch zu erkennen.
Überlegen Sie den Einsatz von Captchas und eine Sperrliste für nicht-deutsche IPs.
Stellen Sie sicher, dass bestimmte Geräte-IDs erst nach Aktivität in der App Gutscheine einlösen können.
