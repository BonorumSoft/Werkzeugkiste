# Traceability-Matrix REQ ↔ TC

Requirements gesamt: 420 | Testfälle gesamt: 432

Requirements ohne Testfall: 0 | Testfälle ohne gültige Requirement-Referenz: 0

| REQ-ID | Quelle | Kategorie | Beschreibung | Test-IDs |
|---|---|---|---|---|
| REQ-001 | 1 | Funktional | Nutzer kann sehen, welche Werkzeuge innerhalb seiner Communities vorhanden sind | TC-001 |
| REQ-002 | 1 | Funktional | Nutzer kann eigene Werkzeuge anbieten | TC-002 |
| REQ-003 | 1 | Funktional | Nutzer kann Werkzeuge anderer Mitglieder anfragen | TC-003 |
| REQ-004 | 1 | Funktional | Nutzer kann Leihanfragen bestätigen oder ablehnen | TC-004 |
| REQ-005 | 1 | Funktional | Nutzer kann ausgeliehene Werkzeuge zurückgeben und die Rückgabe bestätigen | TC-005 |
| REQ-006 | 1 | Historie | Nutzer kann jederzeit nachvollziehen, was er wann von wem geliehen bzw. an wen verliehen hat | TC-006 |
| REQ-007 | 1 | Nicht-Funktional | Die Anwendung funktioniert ohne zentrale Betreiberplattform | TC-007 |
| REQ-008 | 1.1 | Nicht-Funktional | Leitprinzip: Private Communities statt öffentlichem Marktplatz | TC-008 |
| REQ-009 | 1.1 | Explizit-Ausgeschlossen | Leitprinzip: Kein Geld innerhalb des MVP | TC-009 |
| REQ-010 | 1.1 | Nicht-Funktional | Leitprinzip: Kein zentraler Betreiber-Server als Single Point of Failure | TC-010 |
| REQ-011 | 1.1 | Offline-Sync | Leitprinzip: Local-first / Offline-first | TC-011 |
| REQ-012 | 1.1 | Security | Leitprinzip: Ende-zu-Ende-Verschlüsselung | TC-012 |
| REQ-013 | 1.1 | Nicht-Funktional | Leitprinzip: Datensparsamkeit | TC-013 |
| REQ-014 | 1.1 | Security | Leitprinzip: Nutzer besitzt seine Identität und Daten | TC-014 |
| REQ-015 | 1.1 | Nicht-Funktional | Leitprinzip: Keine zentrale Benutzerverwaltung | TC-015 |
| REQ-016 | 1.1 | Nicht-Funktional | Leitprinzip: Keine zentrale Datenbank | TC-016 |
| REQ-017 | 1.1 | UI | Leitprinzip: Keine unnötige Bürokratie oder komplexe Bedienung | TC-017 |
| REQ-018 | 2 | Nicht-Funktional | Die Community ist grundsätzlich geschlossen | TC-018 |
| REQ-019 | 2 | Explizit-Ausgeschlossen | Öffentliche Suche nach Werkzeugen oder Nutzern gehört nicht zum MVP | TC-019 |
| REQ-020 | 3 | Funktional | Community erstellen | TC-020 |
| REQ-021 | 3 | Funktional | Community beitreten | TC-021 |
| REQ-022 | 3 | Funktional | Mitglieder einladen | TC-022 |
| REQ-023 | 3 | Funktional | Ein Nutzer kann Mitglied mehrerer Communities gleichzeitig sein | TC-023 |
| REQ-024 | 3 | Funktional | Mitglieder einer Community anzeigen | TC-024, TC-421, TC-422 |
| REQ-025 | 3 | Funktional | Community verlassen | TC-025 |
| REQ-026 | 3 | Funktional | Werkzeug anlegen | TC-026 |
| REQ-027 | 3 | Funktional | Eigenes Werkzeug bearbeiten | TC-027 |
| REQ-028 | 3 | Funktional | Eigenes Werkzeug löschen | TC-028 |
| REQ-029 | 3 | Funktional | Werkzeuge anderer Mitglieder der Community anzeigen | TC-029 |
| REQ-030 | 3 | Funktional | Ein Werkzeug besitzt eine Werkzeugkategorie | TC-030 |
| REQ-031 | 3 | Funktional | Ein Werkzeug besitzt eine Bezeichnung | TC-031 |
| REQ-032 | 3 | Funktional | Ein Werkzeug kann optional Hersteller/Modell besitzen | TC-032 |
| REQ-033 | 3 | Funktional | Ein Werkzeug kann optional eine Beschreibung besitzen | TC-033 |
| REQ-034 | 3 | Funktional | Ein Werkzeug kann optional Fotos besitzen | TC-034 |
| REQ-035 | 3 | Funktional | Ein Werkzeug kann optional einen Zustand besitzen | TC-035 |
| REQ-036 | 3 | Funktional | Ein Werkzeug besitzt einen Verfügbarkeitsstatus | TC-036 |
| REQ-037 | 3 | Funktional | Leihanfrage stellen | TC-037 |
| REQ-038 | 3 | Funktional | Leihanfrage ablehnen | TC-038 |
| REQ-039 | 3 | Funktional | Leihanfrage bestätigen | TC-039 |
| REQ-040 | 3 | Funktional | Werkzeug wird bei Bestätigung als verliehen markiert | TC-040 |
| REQ-041 | 3 | Funktional | Rückgabe bestätigen | TC-041 |
| REQ-042 | 3 | Funktional | Werkzeug wird nach Rückgabebestätigung wieder verfügbar | TC-042 |
| REQ-043 | 3 | Historie | Persönliche Leihhistorie ist Bestandteil des MVP | TC-043 |
| REQ-044 | 3 | Offline-Sync | Offline-Nutzung ist unterstützt | TC-044 |
| REQ-045 | 3 | Offline-Sync | Lokale Speicherung aller Kerndaten ist vorhanden | TC-045 |
| REQ-046 | 3 | Offline-Sync | Synchronisation erfolgt bei bestehender Verbindung | TC-046 |
| REQ-047 | 3 | Offline-Sync | Fehlgeschlagene Synchronisation wird wiederholt | TC-047 |
| REQ-048 | 3 | Offline-Sync | Konflikterkennung ist vorhanden | TC-048 |
| REQ-049 | 3 | Offline-Sync | Konfliktbehandlung ist deterministisch | TC-049 |
| REQ-050 | 3 | Security | Jeder Nutzer besitzt eine kryptografische Identität | TC-050 |
| REQ-051 | 3 | Security | Ende-zu-Ende-Verschlüsselung ist implementiert | TC-051 |
| REQ-052 | 3 | Security | Sichere Speicherung privater Schlüssel ist implementiert | TC-052 |
| REQ-053 | 3 | Security | Fotos werden verschlüsselt gespeichert/übertragen | TC-053 |
| REQ-054 | 3 | Security | Backups sind geschützt | TC-054 |
| REQ-055 | 4 | Explizit-Ausgeschlossen | Nicht Bestandteil des MVP: öffentliche Werkzeugangebote | TC-055 |
| REQ-056 | 4 | Explizit-Ausgeschlossen | Nicht Bestandteil des MVP: öffentliche Nutzerprofile | TC-056 |
| REQ-057 | 4 | Explizit-Ausgeschlossen | Nicht Bestandteil des MVP: Bewertungen | TC-057 |
| REQ-058 | 4 | Explizit-Ausgeschlossen | Nicht Bestandteil des MVP: Sterne/Ratings | TC-058 |
| REQ-059 | 4 | Explizit-Ausgeschlossen | Nicht Bestandteil des MVP: Vertrauensscores | TC-059 |
| REQ-060 | 4 | Explizit-Ausgeschlossen | Nicht Bestandteil des MVP: Bezahlung | TC-060 |
| REQ-061 | 4 | Explizit-Ausgeschlossen | Nicht Bestandteil des MVP: Mietpreise | TC-061 |
| REQ-062 | 4 | Explizit-Ausgeschlossen | Nicht Bestandteil des MVP: Kaution | TC-062 |
| REQ-063 | 4 | Explizit-Ausgeschlossen | Nicht Bestandteil des MVP: Vertragsverwaltung | TC-063 |
| REQ-064 | 4 | Explizit-Ausgeschlossen | Nicht Bestandteil des MVP: digitale Mietverträge | TC-064 |
| REQ-065 | 4 | Explizit-Ausgeschlossen | Nicht Bestandteil des MVP: Zahlungsabwicklung | TC-065 |
| REQ-066 | 4 | Explizit-Ausgeschlossen | Nicht Bestandteil des MVP: Kalenderbuchungen | TC-066 |
| REQ-067 | 4 | Explizit-Ausgeschlossen | Nicht Bestandteil des MVP: zentrale Administration | TC-067 |
| REQ-068 | 4 | Explizit-Ausgeschlossen | Nicht Bestandteil des MVP: zentrale Benutzerkonten | TC-068 |
| REQ-069 | 4 | Explizit-Ausgeschlossen | Nicht Bestandteil des MVP: serverseitige Push-Infrastruktur | TC-069 |
| REQ-070 | 4 | Explizit-Ausgeschlossen | Nicht Bestandteil des MVP: Social Recovery | TC-070 |
| REQ-071 | 4 | Explizit-Ausgeschlossen | Nicht Bestandteil des MVP: komplexe Multi-Device-Identitäten | TC-071 |
| REQ-072 | 4 | Explizit-Ausgeschlossen | Nicht Bestandteil des MVP: direkte Bluetooth-/Wi-Fi-P2P-Synchronisation | TC-072 |
| REQ-073 | 4/7/10 | Explizit-Ausgeschlossen | Gleichzeitiges Anbieten desselben physischen Werkzeugs in mehreren Communities ist kein MVP-Fall | TC-073 |
| REQ-074 | 4/12/44.3 | Explizit-Ausgeschlossen | Leihfristen, Fälligkeitsdaten und Rückgabe-Erinnerungen sind kein MVP-Bestandteil | TC-074 |
| REQ-075 | 5.1 | Security | Als technisches Identitätsmodell wird eine Nostr-artige Public-/Private-Key-Identität vorgesehen | TC-075 |
| REQ-076 | 5.1 | Security | Der Public Key dient als technische Identität des Nutzers | TC-076 |
| REQ-077 | 5.1 | Security | Der Private Key darf das Gerät nicht ungeschützt verlassen | TC-077 |
| REQ-078 | 5.1 | Security | Der Private Key darf nicht in Logs auftauchen | TC-078 |
| REQ-079 | 5.1 | Security | Der Private Key darf nicht an einen Server übertragen werden | TC-079 |
| REQ-080 | 5.1 | Security | Der Private Key muss sicher auf dem Gerät gespeichert werden | TC-080 |
| REQ-081 | 5.1 | Security | Biometrische Authentifizierung soll als Zugriffsschutz verwendet werden | TC-081 |
| REQ-082 | 5.2 | Nicht-Funktional | Die technische Identität des Nutzers ist nicht vom Anzeigenamen abhängig | TC-082 |
| REQ-083 | 5.2 | Funktional | Ein Nutzer kann einen lokalen Anzeigenamen besitzen | TC-083 |
| REQ-084 | 5.2 | Nicht-Funktional | Fachliche Zuordnung von Werkzeugbesitzer/Ausleiher/Mitglied erfolgt über die kryptografische Identität | TC-084 |
| REQ-085 | 6 | Security | Nutzer muss seine Identität sichern können | TC-085 |
| REQ-086 | 6 | Security | Geschütztes Plattform-Backup ist vorgesehen | TC-086 |
| REQ-087 | 6 | Security | Manueller Export des Seeds bzw. Schlüsselmaterials ist vorgesehen | TC-087 |
| REQ-088 | 6 | UI | App zeigt verständlichen Sicherungsstatus an | TC-088 |
| REQ-089 | 6 | Nicht-Funktional | Verlust des privaten Schlüssels darf nicht stillschweigend zu einem Verlust der Identität führen | TC-089 |
| REQ-090 | 7 | Funktional | Eine Community besitzt mindestens eine Community ID | TC-090 |
| REQ-091 | 7 | Security | Eine Community besitzt einen kryptografischen Community-Schlüssel | TC-091 |
| REQ-092 | 7 | Funktional | Eine Community besitzt eine Liste der bekannten Mitglieder | TC-092 |
| REQ-093 | 7 | Funktional | Eine Community besitzt Community-Metadaten | TC-093 |
| REQ-094 | 7 | Funktional | Ein Nutzer darf gleichzeitig Mitglied mehrerer Communities sein | TC-094 |
| REQ-095 | 7 | Security | Daten einer Community dürfen nicht automatisch für andere Communities sichtbar sein | TC-095 |
| REQ-096 | 7 | Funktional | Ein Werkzeug ist im MVP genau einer Community zugeordnet | TC-096 |
| REQ-097 | 8 | Security | Eine Einladung besteht logisch aus Community ID, Community Key und Invite Token | TC-097 |
| REQ-098 | 8 | Security | Der Invite Token wird zufällig erzeugt | TC-098 |
| REQ-099 | 8 | Security | Der Invite Token ist nicht erratbar | TC-099 |
| REQ-100 | 8 | Funktional | Der Invite Token kann optional zeitlich begrenzt werden | TC-100 |
| REQ-101 | 8 | Funktional | Der Invite Token kann optional nur einmal verwendet werden | TC-101 |
| REQ-102 | 8 | Funktional | Eine gültige Einladung gewährt dem Empfänger Zugriff auf die entsprechende Community | TC-102 |
| REQ-103 | 8 | Security | Ein dauerhaft öffentlich geteilter Community-Schlüssel soll nach Möglichkeit vermieden werden | TC-103 |
| REQ-104 | 9 | Funktional | Mitgliederanzeige enthält mindestens Anzeigename | TC-104 |
| REQ-105 | 9 | Funktional | Mitgliederanzeige enthält mindestens Public Key bzw. technische Identität | TC-105 |
| REQ-106 | 9 | Funktional | Mitgliederanzeige enthält mindestens Mitgliedsstatus | TC-106 |
| REQ-107 | 9 | Funktional | Ein Nutzer kann eine Community verlassen | TC-107 |
| REQ-108 | 9 | Nicht-Funktional | Beim Verlassen wird keine vollständige kryptografische Rücknahme bereits verteilter Daten garantiert (MVP-Einschränkung) | TC-108 |
| REQ-109 | 9 | Security | Ein entferntes Mitglied kann ohne Schlüsselrotation weiterhin gültig signierte Events einspeisen (bekannte MVP-Einschränkung) | TC-109 |
| REQ-110 | 10 | Funktional | Tool-Datensatz besitzt mindestens das Feld tool_id | TC-110 |
| REQ-111 | 10 | Funktional | Tool-Datensatz besitzt mindestens das Feld owner_pubkey | TC-111 |
| REQ-112 | 10 | Funktional | Tool-Datensatz besitzt mindestens das Feld community_id | TC-112 |
| REQ-113 | 10 | Funktional | Tool-Datensatz besitzt mindestens das Feld name | TC-113 |
| REQ-114 | 10 | Funktional | Tool-Datensatz besitzt mindestens das Feld category | TC-114 |
| REQ-115 | 10 | Funktional | Tool-Datensatz besitzt mindestens das Feld model (optional) | TC-115 |
| REQ-116 | 10 | Funktional | Tool-Datensatz besitzt mindestens das Feld description (optional) | TC-116 |
| REQ-117 | 10 | Funktional | Tool-Datensatz besitzt mindestens das Feld photos (optional) | TC-117 |
| REQ-118 | 10 | Funktional | Tool-Datensatz besitzt mindestens das Feld condition (optional) | TC-118 |
| REQ-119 | 10 | Funktional | Tool-Datensatz besitzt mindestens das Feld status | TC-119 |
| REQ-120 | 10 | Funktional | Tool-Datensatz besitzt mindestens das Feld updated_at | TC-120 |
| REQ-121 | 10 | Funktional | Tool-Datensatz besitzt mindestens das Feld schema_version | TC-121 |
| REQ-122 | 10 | Funktional | Tool.community_id ist ein Einzelwert (kein Array) | TC-122 |
| REQ-123 | 10.1 | Security | Der Besitzer eines Werkzeugs wird über owner_pubkey bestimmt | TC-123 |
| REQ-124 | 10.1 | Security | Ein Nutzer darf grundsätzlich nur eigene Werkzeuge verändern oder löschen | TC-124, TC-429, TC-430 |
| REQ-125 | 10.2 | Funktional | Ein Werkzeug besitzt einen eindeutigen Zustand aus einer festen Zustandsmenge | TC-125 |
| REQ-126 | 10.2 | Funktional | Zustandsübergang AVAILABLE → REQUESTED ist gültig | TC-126 |
| REQ-127 | 10.2 | Funktional | Zustandsübergang REQUESTED → LOANED ist gültig (Bestätigung) | TC-127 |
| REQ-128 | 10.2 | Funktional | Zustandsübergang LOANED → AVAILABLE ist gültig (Rückgabe) | TC-128 |
| REQ-129 | 10.2 | Funktional | Zustandsübergang REQUESTED → AVAILABLE ist gültig (Ablehnung oder Rücknahme) | TC-129 |
| REQ-130 | 10.2 | Funktional | Der Zustand DELETED existiert zusätzlich zum Kernzyklus | TC-130 |
| REQ-131 | 10.2 | Funktional | Ungültige Zustandsübergänge müssen von der Domain-Logik verhindert werden | TC-131, TC-425, TC-426, TC-427, TC-428 |
| REQ-132 | 11 | Funktional | LoanRequest-Datensatz besitzt mindestens das Feld request_id | TC-132 |
| REQ-133 | 11 | Funktional | LoanRequest-Datensatz besitzt mindestens das Feld tool_id | TC-133 |
| REQ-134 | 11 | Funktional | LoanRequest-Datensatz besitzt mindestens das Feld community_id | TC-134 |
| REQ-135 | 11 | Funktional | LoanRequest-Datensatz besitzt mindestens das Feld requester_pubkey | TC-135 |
| REQ-136 | 11 | Funktional | LoanRequest-Datensatz besitzt mindestens das Feld owner_pubkey | TC-136 |
| REQ-137 | 11 | Funktional | LoanRequest-Datensatz besitzt mindestens das Feld requested_at | TC-137 |
| REQ-138 | 11 | Funktional | LoanRequest-Datensatz besitzt mindestens das Feld status | TC-138 |
| REQ-139 | 11 | Funktional | LoanRequest-Datensatz besitzt mindestens das Feld schema_version | TC-139 |
| REQ-140 | 11 | Funktional | Mögliche LoanRequest-Zustände sind PENDING, ACCEPTED, REJECTED, CANCELLED | TC-140 |
| REQ-141 | 11.1 | Funktional | Für ein Werkzeug darf maximal eine aktive Leihanfrage existieren (pro Werkzeug, nicht pro Werkzeug+Anfragendem) | TC-141, TC-431 |
| REQ-142 | 11.1 | Funktional | Der Eigentümer kann eine Anfrage annehmen | TC-142 |
| REQ-143 | 11.1 | Funktional | Der Eigentümer kann eine Anfrage ablehnen | TC-143 |
| REQ-144 | 11.1 | Funktional | Der Anfragende kann eine offene Anfrage zurückziehen | TC-144 |
| REQ-145 | 12 | Funktional | Der Leihvorgang beginnt exakt mit der Bestätigung durch den Eigentümer | TC-145 |
| REQ-146 | 12 | Explizit-Ausgeschlossen | Es gibt keinen separaten Übergabezeitpunkt/manuellen Übergabe-bestätigen-Schritt im MVP | TC-146 |
| REQ-147 | 12 | Funktional | Loan-Datensatz besitzt mindestens das Feld loan_id | TC-147 |
| REQ-148 | 12 | Funktional | Loan-Datensatz besitzt mindestens das Feld tool_id | TC-148 |
| REQ-149 | 12 | Funktional | Loan-Datensatz besitzt mindestens das Feld community_id | TC-149 |
| REQ-150 | 12 | Funktional | Loan-Datensatz besitzt mindestens das Feld owner_pubkey | TC-150 |
| REQ-151 | 12 | Funktional | Loan-Datensatz besitzt mindestens das Feld borrower_pubkey | TC-151 |
| REQ-152 | 12 | Funktional | Loan-Datensatz besitzt mindestens das Feld requested_at | TC-152 |
| REQ-153 | 12 | Funktional | Loan-Datensatz besitzt mindestens das Feld accepted_at | TC-153 |
| REQ-154 | 12 | Funktional | Loan-Datensatz besitzt mindestens das Feld returned_at | TC-154 |
| REQ-155 | 12 | Funktional | Loan-Datensatz besitzt mindestens das Feld status | TC-155 |
| REQ-156 | 12 | Funktional | Loan-Datensatz besitzt mindestens das Feld schema_version | TC-156 |
| REQ-157 | 12 | Funktional | requested_at bezeichnet den Zeitpunkt der Anfrage | TC-157 |
| REQ-158 | 12 | Funktional | accepted_at bezeichnet Zeitpunkt der Eigentümer-Bestätigung und Beginn der Ausleihe | TC-158 |
| REQ-159 | 12 | Funktional | returned_at bezeichnet den Zeitpunkt der vom Eigentümer bestätigten Rückgabe | TC-159 |
| REQ-160 | 12 | Explizit-Ausgeschlossen | Es gibt kein separates Feld lent_at | TC-160, TC-423 |
| REQ-161 | 12 | Explizit-Ausgeschlossen | Ein Feld für eine erwartete Rückgabe (expected_return_at) ist im MVP bewusst nicht enthalten | TC-161, TC-424 |
| REQ-162 | 13 | Funktional | Bei Bestätigung wird accepted_at auf den aktuellen Zeitpunkt gesetzt | TC-162 |
| REQ-163 | 13 | Funktional | Bei Rückgabebestätigung wird returned_at auf den aktuellen Zeitpunkt gesetzt | TC-163 |
| REQ-164 | 14 | Funktional | Rückgabe wird vom Eigentümer bestätigt | TC-164 |
| REQ-165 | 14 | Funktional | Rückgabebestätigung beendet den aktiven Leihvorgang | TC-165 |
| REQ-166 | 14 | Funktional | Rückgabebestätigung setzt returned_at | TC-166 |
| REQ-167 | 14 | Funktional | Rückgabebestätigung setzt den Loan-Status auf COMPLETED | TC-167 |
| REQ-168 | 14 | Funktional | Rückgabebestätigung setzt das Werkzeug wieder auf AVAILABLE | TC-168 |
| REQ-169 | 14 | Funktional | Nach Abschluss kann eine erneute Ausleihe beantragt werden | TC-169 |
| REQ-170 | 15 | Historie | Historie ist keine öffentliche Statistik und kein Bewertungsprofil | TC-170 |
| REQ-171 | 15.1 | Historie | Nutzer sieht Perspektive „Von anderen geliehen" | TC-171 |
| REQ-172 | 15.2 | Historie | Nutzer sieht Perspektive „An andere verliehen" | TC-172 |
| REQ-173 | 15 | Historie | Für einen aktuell laufenden Leihvorgang wird kein Rückgabezeitpunkt angezeigt | TC-173 |
| REQ-174 | 16 | Historie | Historieneintrag enthält mindestens: Werkzeug | TC-174 |
| REQ-175 | 16 | Historie | Historieneintrag enthält mindestens: Community | TC-175 |
| REQ-176 | 16 | Historie | Historieneintrag enthält mindestens: Gegenpartei | TC-176 |
| REQ-177 | 16 | Historie | Historieneintrag enthält mindestens: Leihbeginn | TC-177 |
| REQ-178 | 16 | Historie | Historieneintrag enthält mindestens: Rückgabezeitpunkt (sofern abgeschlossen) | TC-178 |
| REQ-179 | 16 | Historie | Historieneintrag enthält mindestens: aktueller bzw. historischer Status | TC-179 |
| REQ-180 | 16 | Historie | Historieneintrag enthält mindestens: Richtung (geliehen/verliehen) | TC-180 |
| REQ-181 | 16 | Historie | Historie ist lokal und offline verfügbar | TC-181 |
| REQ-182 | 16 | Historie | Historie ist filterbar nach Community | TC-182 |
| REQ-183 | 16 | Historie | Historie ist filterbar nach Werkzeug | TC-183 |
| REQ-184 | 16 | Historie | Historie ist filterbar nach Zeitraum | TC-184 |
| REQ-185 | 16 | Historie | Historie ist filterbar nach Richtung | TC-185 |
| REQ-186 | 17 | Funktional | „Wo" bezeichnet im MVP die Community, in der der Leihvorgang stattfand | TC-186 |
| REQ-187 | 17 | Explizit-Ausgeschlossen | Physische Ortsangabe/GPS-Position ist nicht Bestandteil des MVP | TC-187 |
| REQ-188 | 18.1 | Nicht-Funktional | Technischer Event-Verlauf umfasst u. a. das Event ToolCreated | TC-188 |
| REQ-189 | 18.1 | Nicht-Funktional | Technischer Event-Verlauf umfasst u. a. das Event ToolUpdated | TC-189 |
| REQ-190 | 18.1 | Nicht-Funktional | Technischer Event-Verlauf umfasst u. a. das Event LoanRequested | TC-190 |
| REQ-191 | 18.1 | Nicht-Funktional | Technischer Event-Verlauf umfasst u. a. das Event LoanAccepted | TC-191 |
| REQ-192 | 18.1 | Nicht-Funktional | Technischer Event-Verlauf umfasst u. a. das Event LoanReturned | TC-192 |
| REQ-193 | 18.1 | Nicht-Funktional | Technischer Event-Verlauf umfasst u. a. das Event ToolDeleted | TC-193 |
| REQ-194 | 18.2 | Historie | Die persönliche Historie ist eine abgeleitete, nutzerorientierte Sicht auf die relevanten Leihdaten | TC-194 |
| REQ-195 | 18.2 | Historie | Die persönliche Historie muss nicht als eigenständiger unveränderlicher Event-Datensatz gespeichert werden | TC-195 |
| REQ-196 | 19 | Historie | Nutzer kann seine lokal gespeicherte persönliche Historie löschen | TC-196 |
| REQ-197 | 19 | Historie | Löschen der eigenen lokalen Historie darf nicht die historischen Daten anderer Community-Mitglieder zerstören | TC-197 |
| REQ-198 | 19 | Historie | Löschen der lokalen Historie bedeutet nicht automatisch das Löschen zugehöriger Events aus dem verteilten Netzwerk | TC-198 |
| REQ-199 | 20 | Offline-Sync | Offline lokal möglich: Communities anzeigen | TC-199 |
| REQ-200 | 20 | Offline-Sync | Offline lokal möglich: Werkzeuge anzeigen | TC-200 |
| REQ-201 | 20 | Offline-Sync | Offline lokal möglich: eigene Werkzeuge bearbeiten | TC-201 |
| REQ-202 | 20 | Offline-Sync | Offline lokal möglich: Leihanfragen vorbereiten | TC-202 |
| REQ-203 | 20 | Offline-Sync | Offline lokal möglich: verfügbare lokale Daten anzeigen | TC-203 |
| REQ-204 | 20 | Offline-Sync | Offline lokal möglich: persönliche Historie anzeigen | TC-204 |
| REQ-205 | 20 | Offline-Sync | Aktionen, die eine Synchronisation benötigen, werden lokal als ausstehend gespeichert | TC-205 |
| REQ-206 | 20 | Offline-Sync | Sync-Zustandsmodell umfasst LOCAL → PENDING → SYNCING → SYNCED | TC-206 |
| REQ-207 | 20 | Offline-Sync | Bei Fehler wechselt der Sync-Status zu FAILED | TC-207 |
| REQ-208 | 20 | Offline-Sync | Bei Konflikten wechselt der Sync-Status zu CONFLICT und wird nach deterministischen Regeln zu SYNCED aufgelöst | TC-208 |
| REQ-209 | 20 | Offline-Sync | Netzwerkfehler dürfen niemals zum Verlust einer bereits lokal bestätigten Benutzeraktion führen | TC-209 |
| REQ-210 | 21 | Offline-Sync | Die Anwendung funktioniert ohne zentralen Datenbankserver | TC-210 |
| REQ-211 | 21 | Offline-Sync | Primärer Sync-Mechanismus im MVP ist ein Nostr-basiertes Modell | TC-211 |
| REQ-212 | 21 | Offline-Sync | Mehrere Relays werden unterstützt | TC-212 |
| REQ-213 | 21 | Offline-Sync | Ein einzelner Relay darf kein Single Point of Failure sein | TC-213 |
| REQ-214 | 21 | Offline-Sync | Lokale Datenbank dient u. a. als Offline-Datenspeicher | TC-214 |
| REQ-215 | 21 | Offline-Sync | Lokale Datenbank dient u. a. als lokaler Cache | TC-215 |
| REQ-216 | 21 | Offline-Sync | Lokale Datenbank dient u. a. als Event-Index | TC-216 |
| REQ-217 | 21 | Offline-Sync | Lokale Datenbank dient u. a. als Pending-Queue | TC-217 |
| REQ-218 | 21 | Offline-Sync | Lokale Datenbank dient u. a. als Statusspeicher | TC-218 |
| REQ-219 | 22 | Offline-Sync | Die Domain-Schicht behandelt Konflikte anhand deterministischer Regeln | TC-219 |
| REQ-220 | 22 | Nicht-Funktional | Konfliktauflösungsregeln werden in einem separaten ADR spezifiziert (ADR-04) | TC-220 |
| REQ-221 | 22 | Nicht-Funktional | Konfliktauflösung darf nicht von UI oder Netzwerkcode abhängen | TC-221 |
| REQ-222 | 23 | Security | Ende-zu-Ende-Verschlüsselung gilt insbesondere für: Werkzeugdaten | TC-222 |
| REQ-223 | 23 | Security | Ende-zu-Ende-Verschlüsselung gilt insbesondere für: Mitgliedsinformationen | TC-223 |
| REQ-224 | 23 | Security | Ende-zu-Ende-Verschlüsselung gilt insbesondere für: Leihanfragen | TC-224 |
| REQ-225 | 23 | Security | Ende-zu-Ende-Verschlüsselung gilt insbesondere für: Leihhistorie | TC-225 |
| REQ-226 | 23 | Security | Ende-zu-Ende-Verschlüsselung gilt insbesondere für: private Metadaten | TC-226 |
| REQ-227 | 23 | Security | Ende-zu-Ende-Verschlüsselung gilt insbesondere für: Fotos | TC-227 |
| REQ-228 | 23 | Security | Ein Relay-Betreiber darf keine lesbaren privaten Informationen gewinnen können | TC-228 |
| REQ-229 | 23 | Security | Es dürfen ausschließlich etablierte und geprüfte kryptografische Verfahren und Bibliotheken verwendet werden | TC-229 |
| REQ-230 | 23 | Security | Keine eigene Kryptografie | TC-230 |
| REQ-231 | 24 | Security | EXIF-Daten werden vor dem Upload entfernt | TC-231 |
| REQ-232 | 24 | Security | GPS-Daten werden insbesondere vor dem Upload entfernt | TC-232 |
| REQ-233 | 24 | Nicht-Funktional | Bild wird ggf. vor Upload verkleinert/komprimiert | TC-233 |
| REQ-234 | 24 | Security | Bild wird vor Übertragung verschlüsselt | TC-234 |
| REQ-235 | 24 | Security | Es wird ausschließlich das verschlüsselte Bild übertragen | TC-235 |
| REQ-236 | 24 | Security | Es reicht nicht, nur URL/Referenz auf ein unverschlüsseltes Bild zu verschlüsseln – die Bilddatei selbst muss verschlüsselt sein | TC-236 |
| REQ-237 | 25 | Nicht-Funktional | Für Bilder wird ein Blossom-kompatibler Ansatz verwendet | TC-237 |
| REQ-238 | 25 | Nicht-Funktional | Die Anwendung darf nicht dauerhaft von einem einzelnen Storage-Anbieter abhängig sein | TC-238 |
| REQ-239 | 25 | Nicht-Funktional | Wo sinnvoll, werden mehrere Speicheranbieter unterstützt bzw. Bilder repliziert | TC-239 |
| REQ-240 | 25 | Security | Der eigentliche Bildinhalt bleibt verschlüsselt | TC-240 |
| REQ-241 | 25 | Nicht-Funktional | In den verschlüsselten Daten wird eine Referenz bzw. ein Content Hash gespeichert | TC-241 |
| REQ-242 | 26 | Nicht-Funktional | Anwendung folgt Privacy by Design und Privacy by Default | TC-242 |
| REQ-243 | 26 | Nicht-Funktional | Es werden möglichst wenige personenbezogene Daten erhoben (Datensparsamkeit) | TC-243 |
| REQ-244 | 26 | Nicht-Funktional | Keine unnötige zentrale Sammlung von: E-Mail-Adressen | TC-244 |
| REQ-245 | 26 | Nicht-Funktional | Keine unnötige zentrale Sammlung von: Telefonnummern | TC-245 |
| REQ-246 | 26 | Nicht-Funktional | Keine unnötige zentrale Sammlung von: Standortdaten | TC-246 |
| REQ-247 | 26 | Nicht-Funktional | Keine unnötige zentrale Sammlung von: Gerätekennungen | TC-247 |
| REQ-248 | 26 | Nicht-Funktional | Keine unnötige zentrale Sammlung von: Trackingdaten | TC-248 |
| REQ-249 | 27 | Nicht-Funktional | Es kann nicht garantiert werden, dass ein veröffentlichtes Event aus jedem Relay vollständig verschwindet | TC-249 |
| REQ-250 | 27 | Nicht-Funktional | Die App nutzt vorhandene Löschmechanismen | TC-250 |
| REQ-251 | 27 | UI | Dem Nutzer wird transparent erklärt, dass lokales Löschen zuverlässig, vollständiges Löschen aus fremden/verteilten Speichern aber nicht garantierbar ist | TC-251 |
| REQ-252 | 28 | Security | Im MVP besitzt ein Nutzer grundsätzlich eine kryptografische Identität | TC-252 |
| REQ-253 | 28 | Security | Diese Identität kann auf einem weiteren Gerät wiederhergestellt werden | TC-253 |
| REQ-254 | 28 | Security | Der Transfer erfolgt über einen geschützten Backup-/Recovery-Mechanismus | TC-254 |
| REQ-255 | 28 | Nicht-Funktional | Bekannte MVP-Einschränkung: kein Widerruf eines einzelnen verlorenen/gestohlenen Geräts ohne vollständigen Identitätswechsel | TC-255 |
| REQ-256 | 29 | Explizit-Ausgeschlossen | Serverbasierte Push-Benachrichtigungen sind nicht Bestandteil des MVP | TC-256 |
| REQ-257 | 29 | Offline-Sync | Synchronisation kann erfolgen bei: App-Start | TC-257 |
| REQ-258 | 29 | Offline-Sync | Synchronisation kann erfolgen bei: manueller Refresh | TC-258 |
| REQ-259 | 29 | Offline-Sync | Synchronisation kann erfolgen bei: aktiver Synchronisationsvorgang | TC-259 |
| REQ-260 | 29 | Offline-Sync | Synchronisation kann erfolgen bei: geeignete Hintergrundmechanismen des Betriebssystems | TC-260 |
| REQ-261 | 30 | UI | UI-Bereich Communities: Meine Communities | TC-261 |
| REQ-262 | 30 | UI | UI-Bereich Communities: Community auswählen | TC-262 |
| REQ-263 | 30 | UI | UI-Bereich Communities: Mitglieder | TC-263 |
| REQ-264 | 30 | UI | UI-Bereich Communities: Einladung | TC-264 |
| REQ-265 | 30 | UI | UI-Bereich Werkzeuge: Alle Werkzeuge | TC-265 |
| REQ-266 | 30 | UI | UI-Bereich Werkzeuge: Meine Werkzeuge | TC-266 |
| REQ-267 | 30 | UI | UI-Bereich Werkzeuge: Verfügbare Werkzeuge | TC-267 |
| REQ-268 | 30 | UI | UI-Bereich Werkzeuge: verliehene Werkzeuge | TC-268 |
| REQ-269 | 30 | UI | UI-Bereich Werkzeuge: Werkzeugdetails | TC-269 |
| REQ-270 | 30 | UI | UI-Bereich Anfragen: eingehende Anfragen | TC-270 |
| REQ-271 | 30 | UI | UI-Bereich Anfragen: eigene Anfragen | TC-271 |
| REQ-272 | 30 | UI | UI-Bereich Anfragen: Anfrage bestätigen | TC-272 |
| REQ-273 | 30 | UI | UI-Bereich Anfragen: Anfrage ablehnen | TC-273 |
| REQ-274 | 30 | UI | UI-Bereich Anfragen: Anfrage zurückziehen | TC-274 |
| REQ-275 | 30 | UI | UI-Bereich Ausleihen: aktuell geliehene Werkzeuge | TC-275 |
| REQ-276 | 30 | UI | UI-Bereich Ausleihen: aktuell verliehene Werkzeuge | TC-276 |
| REQ-277 | 30 | UI | UI-Bereich Ausleihen: Rückgabe bestätigen | TC-277 |
| REQ-278 | 30 | UI | UI-Bereich Historie: von anderen geliehen | TC-278 |
| REQ-279 | 30 | UI | UI-Bereich Historie: an andere verliehen | TC-279 |
| REQ-280 | 30 | UI | UI-Bereich Historie: Filter | TC-280 |
| REQ-281 | 31 | UI | Der Status eines Werkzeugs muss eindeutig erkennbar sein | TC-281 |
| REQ-282 | 31 | UI | Der Status darf nicht ausschließlich über Farbe vermittelt werden | TC-282 |
| REQ-283 | 32 | UI | Barrierefreiheit: Unterstützung von Screenreader | TC-283 |
| REQ-284 | 32 | UI | Barrierefreiheit: Unterstützung von ausreichende Kontraste | TC-284 |
| REQ-285 | 32 | UI | Barrierefreiheit: Unterstützung von dynamische Schriftgrößen | TC-285 |
| REQ-286 | 32 | UI | Barrierefreiheit: Unterstützung von ausreichend große Touch-Ziele | TC-286 |
| REQ-287 | 32 | UI | Barrierefreiheit: Unterstützung von semantische Beschriftungen | TC-287 |
| REQ-288 | 32 | UI | Barrierefreiheit: Unterstützung von keine ausschließliche Farbcodierung | TC-288 |
| REQ-289 | 33 | Security | Sicherheitsanforderung: sichere Zufallszahlengenerierung | TC-289 |
| REQ-290 | 33 | Security | Sicherheitsanforderung: sichere Schlüsselablage | TC-290 |
| REQ-291 | 33 | Security | Sicherheitsanforderung: biometrischer/PIN-basierter Zugriff | TC-291 |
| REQ-292 | 33 | Security | Sicherheitsanforderung: keine Secrets in Logs | TC-292 |
| REQ-293 | 33 | Security | Sicherheitsanforderung: keine Secrets im Repository | TC-293 |
| REQ-294 | 33 | Security | Sicherheitsanforderung: verschlüsselte private Daten | TC-294 |
| REQ-295 | 33 | Security | Sicherheitsanforderung: verschlüsselte Fotos | TC-295 |
| REQ-296 | 33 | Security | Sicherheitsanforderung: Eingabevalidierung | TC-296 |
| REQ-297 | 33 | Security | Sicherheitsanforderung: Berechtigungsprüfung in der Domain-Schicht | TC-297 |
| REQ-298 | 33 | Security | Sicherheitsanforderung: Dependency Security Scanning | TC-298 |
| REQ-299 | 33 | Security | Sicherheitsanforderung: Secret Scanning | TC-299 |
| REQ-300 | 33 | Security | Sicherheitsanforderung: Schutz vor manipulierten Events | TC-300 |
| REQ-301 | 34 | Security | Lokale Schutzmechanismen: ungültige Events verwerfen | TC-301 |
| REQ-302 | 34 | Security | Lokale Schutzmechanismen: unbekannte Signaturen verwerfen | TC-302 |
| REQ-303 | 34 | Security | Lokale Schutzmechanismen: ungültige Zustandsübergänge ablehnen | TC-303 |
| REQ-304 | 34 | Security | Lokale Schutzmechanismen: manipulierte Daten erkennen | TC-304 |
| REQ-305 | 34 | Security | Lokale Schutzmechanismen: übermäßig große Datenmengen begrenzen | TC-305 |
| REQ-306 | 35 | Nicht-Funktional | Die Anwendung wird plattformübergreifend entwickelt (eine Codebasis für iOS/Android) | TC-306 |
| REQ-307 | 35 | Nicht-Funktional | Tech-Stack-Kandidaten (Flutter/Dart, Riverpod, Drift/SQLite oder Isar, Nostr-Dart-Lib) sind durch ADRs zu bestätigen | TC-307 |
| REQ-308 | 35 | Nicht-Funktional | Die Domain-Logik darf keine direkte Abhängigkeit zu Flutter besitzen | TC-308 |
| REQ-309 | 35 | Nicht-Funktional | Die Domain-Logik darf keine direkte Abhängigkeit zu SQLite besitzen | TC-309 |
| REQ-310 | 35 | Nicht-Funktional | Die Domain-Logik darf keine direkte Abhängigkeit zu Nostr besitzen | TC-310 |
| REQ-311 | 35 | Nicht-Funktional | Die Domain-Logik darf keine direkte Abhängigkeit zu konkrete Storage-Anbieter besitzen | TC-311 |
| REQ-312 | 36 | Nicht-Funktional | Anwendung ist in Schichten strukturiert: UI/Presentation → Application/State → Domain → Data/Infrastructure | TC-312 |
| REQ-313 | 36 | Nicht-Funktional | Domain-Schicht umfasst Community, Tool, Loan, State Machine, Conflict Resolution | TC-313 |
| REQ-314 | 36 | Nicht-Funktional | Die Domain muss unabhängig von konkreten technischen Implementierungen testbar sein | TC-314 |
| REQ-315 | 37 | Nicht-Funktional | Lokale Datenbank verwaltet mindestens: Communities | TC-315 |
| REQ-316 | 37 | Nicht-Funktional | Lokale Datenbank verwaltet mindestens: Mitglieder | TC-316 |
| REQ-317 | 37 | Nicht-Funktional | Lokale Datenbank verwaltet mindestens: Werkzeuge | TC-317 |
| REQ-318 | 37 | Nicht-Funktional | Lokale Datenbank verwaltet mindestens: Leihanfragen | TC-318 |
| REQ-319 | 37 | Nicht-Funktional | Lokale Datenbank verwaltet mindestens: Leihvorgänge | TC-319 |
| REQ-320 | 37 | Nicht-Funktional | Lokale Datenbank verwaltet mindestens: persönliche Historie | TC-320 |
| REQ-321 | 37 | Nicht-Funktional | Lokale Datenbank verwaltet mindestens: technische Events | TC-321 |
| REQ-322 | 37 | Nicht-Funktional | Lokale Datenbank verwaltet mindestens: Pending Events | TC-322 |
| REQ-323 | 37 | Nicht-Funktional | Lokale Datenbank verwaltet mindestens: Synchronisationsstatus | TC-323 |
| REQ-324 | 37 | Nicht-Funktional | Lokale Datenbank verwaltet mindestens: Fotometadaten | TC-324 |
| REQ-325 | 37 | Nicht-Funktional | Lokale Datenbank verwaltet mindestens: Schlüsselreferenzen | TC-325 |
| REQ-326 | 37 | Historie | Die persönliche Historie ist als optimierte lokale Ansicht verfügbar | TC-326 |
| REQ-327 | 38 | Nicht-Funktional | Das Event-Modell muss versioniert werden | TC-327 |
| REQ-328 | 38 | Nicht-Funktional | Event-Modell benötigt mindestens den Event-Typ ToolCreated | TC-328 |
| REQ-329 | 38 | Nicht-Funktional | Event-Modell benötigt mindestens den Event-Typ ToolUpdated | TC-329 |
| REQ-330 | 38 | Nicht-Funktional | Event-Modell benötigt mindestens den Event-Typ ToolDeleted | TC-330 |
| REQ-331 | 38 | Nicht-Funktional | Event-Modell benötigt mindestens den Event-Typ LoanRequested | TC-331 |
| REQ-332 | 38 | Nicht-Funktional | Event-Modell benötigt mindestens den Event-Typ LoanAccepted | TC-332 |
| REQ-333 | 38 | Nicht-Funktional | Event-Modell benötigt mindestens den Event-Typ LoanRejected | TC-333 |
| REQ-334 | 38 | Nicht-Funktional | Event-Modell benötigt mindestens den Event-Typ LoanCancelled | TC-334 |
| REQ-335 | 38 | Nicht-Funktional | Event-Modell benötigt mindestens den Event-Typ LoanReturned | TC-335 |
| REQ-336 | 38 | Security | Jedes Event benötigt eine eindeutige Identifikation | TC-336 |
| REQ-337 | 38 | Security | Jedes Event muss kryptografisch authentifiziert werden | TC-337 |
| REQ-338 | 38 | Nicht-Funktional | Die konkrete Nostr-/NIP-Ausgestaltung wird in einem ADR festgelegt (ADR-01) | TC-338 |
| REQ-339 | 39 | Nicht-Funktional | Teststrategie Domain: intensive Testabdeckung für Werkzeug-State-Machine | TC-339 |
| REQ-340 | 39 | Nicht-Funktional | Teststrategie Domain: intensive Testabdeckung für Leihprozess | TC-340 |
| REQ-341 | 39 | Nicht-Funktional | Teststrategie Domain: intensive Testabdeckung für Berechtigungen | TC-341 |
| REQ-342 | 39 | Nicht-Funktional | Teststrategie Domain: intensive Testabdeckung für Konfliktauflösung | TC-342 |
| REQ-343 | 39 | Nicht-Funktional | Teststrategie Domain: intensive Testabdeckung für Eventvalidierung | TC-343 |
| REQ-344 | 39 | Nicht-Funktional | Teststrategie Security: intensive Testabdeckung für Schlüsselverwaltung | TC-344 |
| REQ-345 | 39 | Nicht-Funktional | Teststrategie Security: intensive Testabdeckung für Verschlüsselung | TC-345 |
| REQ-346 | 39 | Nicht-Funktional | Teststrategie Security: intensive Testabdeckung für Signaturprüfung | TC-346 |
| REQ-347 | 39 | Nicht-Funktional | Teststrategie Security: intensive Testabdeckung für Manipulation | TC-347 |
| REQ-348 | 39 | Nicht-Funktional | Teststrategie Security: intensive Testabdeckung für ungültige Events | TC-348 |
| REQ-349 | 39 | Nicht-Funktional | Teststrategie Offline: intensive Testabdeckung für Netzwerkverlust | TC-349 |
| REQ-350 | 39 | Nicht-Funktional | Teststrategie Offline: intensive Testabdeckung für Wiederverbindung | TC-350 |
| REQ-351 | 39 | Nicht-Funktional | Teststrategie Offline: intensive Testabdeckung für doppelte Events | TC-351 |
| REQ-352 | 39 | Nicht-Funktional | Teststrategie Offline: intensive Testabdeckung für verzögerte Events | TC-352 |
| REQ-353 | 39 | Nicht-Funktional | Teststrategie Offline: intensive Testabdeckung für Konflikte | TC-353 |
| REQ-354 | 39 | Nicht-Funktional | Teststrategie Historie: intensive Testabdeckung für korrekte Zuordnung geliehen/verliehen | TC-354 |
| REQ-355 | 39 | Nicht-Funktional | Teststrategie Historie: intensive Testabdeckung für korrekter Leihbeginn | TC-355 |
| REQ-356 | 39 | Nicht-Funktional | Teststrategie Historie: intensive Testabdeckung für korrekter Rückgabezeitpunkt | TC-356 |
| REQ-357 | 39 | Nicht-Funktional | Teststrategie Historie: intensive Testabdeckung für aktive vs. abgeschlossene Leihen | TC-357 |
| REQ-358 | 39 | Nicht-Funktional | Teststrategie Historie: intensive Testabdeckung für Löschen lokaler Historie | TC-358 |
| REQ-359 | 40 | Nicht-Funktional | Zielgröße von ca. 80 % Testabdeckung für kritische Logik wird angestrebt | TC-359 |
| REQ-360 | 40 | Nicht-Funktional | Ein Fehler in der Leih-State-Machine darf nicht ausschließlich durch UI-Tests unentdeckt bleiben können | TC-360 |
| REQ-361 | 41 | Nicht-Funktional | CI/CD führt bei jedem Pull Request mindestens aus: Formatting | TC-361 |
| REQ-362 | 41 | Nicht-Funktional | CI/CD führt bei jedem Pull Request mindestens aus: Linting | TC-362 |
| REQ-363 | 41 | Nicht-Funktional | CI/CD führt bei jedem Pull Request mindestens aus: Static Analysis | TC-363 |
| REQ-364 | 41 | Nicht-Funktional | CI/CD führt bei jedem Pull Request mindestens aus: Unit Tests | TC-364 |
| REQ-365 | 41 | Nicht-Funktional | CI/CD führt bei jedem Pull Request mindestens aus: Widget Tests | TC-365 |
| REQ-366 | 41 | Nicht-Funktional | CI/CD führt bei jedem Pull Request mindestens aus: Integration Tests (soweit relevant) | TC-366 |
| REQ-367 | 41 | Nicht-Funktional | CI/CD führt bei jedem Pull Request mindestens aus: Security Scans | TC-367 |
| REQ-368 | 41 | Nicht-Funktional | CI/CD führt bei jedem Pull Request mindestens aus: Secret Scanning | TC-368 |
| REQ-369 | 41 | Nicht-Funktional | CI/CD führt bei jedem Pull Request mindestens aus: Dependency Checks | TC-369 |
| REQ-370 | 41 | Nicht-Funktional | Ein Merge ist grundsätzlich nur bei erfolgreicher Pipeline möglich | TC-370 |
| REQ-371 | 41 | Nicht-Funktional | Produktionsfehler werden nach Möglichkeit als Regressionstest aufgenommen | TC-371 |
| REQ-372 | 42 | Nicht-Funktional | Beta-Test deckt ab: zwei Smartphones | TC-372 |
| REQ-373 | 42 | Nicht-Funktional | Beta-Test deckt ab: mehrere Nutzer | TC-373 |
| REQ-374 | 42 | Nicht-Funktional | Beta-Test deckt ab: mehrere Communities | TC-374 |
| REQ-375 | 42 | Nicht-Funktional | Beta-Test deckt ab: instabile Netzwerkverbindung | TC-375 |
| REQ-376 | 42 | Nicht-Funktional | Beta-Test deckt ab: Offline-Betrieb | TC-376 |
| REQ-377 | 42 | Nicht-Funktional | Beta-Test deckt ab: Relay-Ausfall | TC-377 |
| REQ-378 | 42 | Nicht-Funktional | Beta-Test deckt ab: Storage-Ausfall | TC-378 |
| REQ-379 | 42 | Nicht-Funktional | Beta-Test deckt ab: konkurrierende Änderungen | TC-379 |
| REQ-380 | 42 | Nicht-Funktional | Beta-Test deckt ab: Foto-Upload | TC-380 |
| REQ-381 | 42 | Nicht-Funktional | Beta-Test deckt ab: Wiederherstellung einer Identität | TC-381 |
| REQ-382 | 43 | Security | Fehler-/Crash-Reporting darf nicht übertragen: Private Keys | TC-382 |
| REQ-383 | 43 | Security | Fehler-/Crash-Reporting darf nicht übertragen: Community Keys | TC-383 |
| REQ-384 | 43 | Security | Fehler-/Crash-Reporting darf nicht übertragen: unverschlüsselte Tool-Daten | TC-384 |
| REQ-385 | 43 | Security | Fehler-/Crash-Reporting darf nicht übertragen: Leihinformationen | TC-385 |
| REQ-386 | 43 | Security | Fehler-/Crash-Reporting darf nicht übertragen: Fotos | TC-386 |
| REQ-387 | 43 | Security | Fehler-/Crash-Reporting darf nicht übertragen: private Event-Payloads | TC-387 |
| REQ-388 | 43 | Nicht-Funktional | Fehlerdiagnose soll möglichst über technische Metadaten erfolgen | TC-388 |
| REQ-389 | 45 | Nicht-Funktional | Vor öffentlicher Veröffentlichung ist zu prüfen: App-Store-Richtlinien | TC-389 |
| REQ-390 | 45 | Nicht-Funktional | Vor öffentlicher Veröffentlichung ist zu prüfen: Datenschutzanforderungen | TC-390 |
| REQ-391 | 45 | Nicht-Funktional | Vor öffentlicher Veröffentlichung ist zu prüfen: Verschlüsselungs-/Exportanforderungen | TC-391 |
| REQ-392 | 45 | Nicht-Funktional | Vor öffentlicher Veröffentlichung ist zu prüfen: rechtliche Anforderungen für Deutschland/EU | TC-392 |
| REQ-393 | 45 | Nicht-Funktional | Vor öffentlicher Veröffentlichung ist zu prüfen: Anforderungen an Drittanbieterbibliotheken | TC-393 |
| REQ-394 | 45 | Nicht-Funktional | Vor öffentlicher Veröffentlichung ist zu prüfen: Lizenzbedingungen verwendeter Komponenten | TC-394 |
| REQ-395 | 47 | Nicht-Funktional | ADR-01 muss vor der Implementierung konkret entschieden und dokumentiert werden: Nostr Event-Modell (Event-Typen, NIPs, Tags, Signaturen, Verschlüsselungsverfahren) | TC-395 |
| REQ-396 | 47 | Nicht-Funktional | ADR-02 muss vor der Implementierung konkret entschieden und dokumentiert werden: Community-Verschlüsselung (Schlüsselverteilung, -rotation, Umgang mit ausgeschiedenen Mitgliedern) | TC-396 |
| REQ-397 | 47 | Nicht-Funktional | ADR-03 muss vor der Implementierung konkret entschieden und dokumentiert werden: Invite-System (Tokenformat, Ablauf, Einmalverwendung, sichere Schlüsselübertragung) | TC-397 |
| REQ-398 | 47 | Nicht-Funktional | ADR-04 muss vor der Implementierung konkret entschieden und dokumentiert werden: Konfliktauflösung (Prioritätsregeln, Event-Reihenfolge, konkurrierende Anfragen/Änderungen) | TC-398 |
| REQ-399 | 47 | Nicht-Funktional | ADR-05 muss vor der Implementierung konkret entschieden und dokumentiert werden: Foto-Storage (Blossom-Anbieter, Redundanz, Upload-/Download-Protokoll, Content Hash) | TC-399 |
| REQ-400 | 47 | Nicht-Funktional | ADR-06 muss vor der Implementierung konkret entschieden und dokumentiert werden: Backup/Recovery (Plattformbackup, Seed Export, Wiederherstellung, Geräte-Widerruf) | TC-400 |
| REQ-401 | 47 | Nicht-Funktional | ADR-07 muss vor der Implementierung konkret entschieden und dokumentiert werden: Lokale Datenbank (Drift/SQLite vs. Isar, Verschlüsselung, Migrationen) | TC-401 |
| REQ-402 | 47 | Nicht-Funktional | ADR-08 muss vor der Implementierung konkret entschieden und dokumentiert werden: Relay-/Blob-Storage-Betrieb (öffentliche Relays vs. eigene Instanz, Finanzierung, Kostenmodell, Skalierung) | TC-402 |
| REQ-403 | 48 | Funktional | E2E-Akzeptanzszenario: Person A erstellt eine private Community | TC-403, TC-E2E-001 |
| REQ-404 | 48 | Funktional | E2E-Akzeptanzszenario: Person A lädt Person B ein und Person B tritt bei | TC-404, TC-E2E-001 |
| REQ-405 | 48 | Funktional | E2E-Akzeptanzszenario: Person A legt einen Bohrhammer an und Person B sieht ihn | TC-405, TC-E2E-001 |
| REQ-406 | 48 | Funktional | E2E-Akzeptanzszenario: Person B stellt Leihanfrage, Person A sieht und bestätigt sie | TC-406, TC-E2E-001 |
| REQ-407 | 48 | Funktional | E2E-Akzeptanzszenario: Werkzeug steht nach Bestätigung auf VERLIEHEN für beide Seiten sichtbar | TC-407, TC-E2E-001 |
| REQ-408 | 48 | Offline-Sync | E2E-Akzeptanzszenario: Beide Geräte verlieren die Netzwerkverbindung, lokale Historie bleibt verfügbar | TC-408, TC-E2E-001 |
| REQ-409 | 48 | Funktional | E2E-Akzeptanzszenario: Person A bestätigt später die Rückgabe; returned_at wird gesetzt, Loan wird COMPLETED, Tool wird AVAILABLE | TC-409, TC-E2E-001 |
| REQ-410 | 48 | Historie | E2E-Akzeptanzszenario: Beide Nutzer sehen den abgeschlossenen Leihvorgang in ihrer persönlichen Historie | TC-410, TC-E2E-001 |
| REQ-411 | 48 | Nicht-Funktional | Im Akzeptanzszenario ist kein zentraler Benutzeraccount erforderlich | TC-411, TC-E2E-001 |
| REQ-412 | 48 | Nicht-Funktional | Im Akzeptanzszenario ist keine zentrale Datenbank erforderlich | TC-412, TC-E2E-001 |
| REQ-413 | 48 | Offline-Sync | Ein einzelner Relay-Ausfall macht die Anwendung im Szenario nicht dauerhaft unbrauchbar | TC-413, TC-E2E-001 |
| REQ-414 | 48 | Security | Der Relay-Betreiber kann die privaten Community-Inhalte im Szenario nicht lesen | TC-414, TC-E2E-001 |
| REQ-415 | 49 | UI | Erfolgskriterium Einfach: Werkzeug auswählen → Anfrage stellen → Besitzer bestätigt → geliehen | TC-415 |
| REQ-416 | 49 | Historie | Erfolgskriterium Nachvollziehbar: Jeder Nutzer kann seine persönliche Leihhistorie einsehen | TC-416 |
| REQ-417 | 49 | Security | Erfolgskriterium Privat: Außenstehende können die privaten Inhalte nicht lesen | TC-417 |
| REQ-418 | 49 | Nicht-Funktional | Erfolgskriterium Dezentral: kein einzelner Betreiber kontrolliert die Community-Daten | TC-418 |
| REQ-419 | 49 | Offline-Sync | Erfolgskriterium Robust: temporäre Netzwerk-/Relay-Ausfälle dürfen keine lokalen Daten zerstören | TC-419 |
| REQ-420 | 49 | Funktional | Erfolgskriterium Klar: Eigentümer-Bestätigung ist zugleich Beginn der Ausleihe, ohne zusätzliche Übergabebestätigung | TC-420 |