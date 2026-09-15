#!/usr/bin/env python3
"""Phase 6 – einfacher, abhängigkeitsfreier Mutationstest-Runner.

Hintergrund (siehe reports/phase6_mutation.md und
pipeline/00_offene_fragen.md): Diese Sandbox kann kein Dart/Flutter-SDK
lokal ausführen, daher lief die gesamte Pipeline bisher ausschließlich über
echte GitHub-Actions-CI-Läufe. Ein pub.dev-Paket für Mutationstests (z. B.
`mutation_test`) hätte hier vor dem Einsatz nicht gegen den echten
Paketindex geprüft werden können (pub.dev ist in dieser Sandbox durch
dieselbe Netzwerk-Policy blockiert wie storage.googleapis.com), und ein
Blindschuss auf eine mögliche falsche Paketversion hätte denselben
Trial-and-error-Zyklus über echte CI-Läufe erfordert wie ein eigenes,
vollständig kontrolliertes Skript – mit dem Unterschied, dass ein eigenes
Skript keine zusätzliche externe Abhängigkeit und kein unbekanntes
Konfigurationsformat einführt. Deshalb: ein kleines, selbst geschriebenes,
rein string-basiertes Mutationstest-Skript, das nur Python (auf
`ubuntu-latest`-Runnern vorinstalliert) und den bereits vorhandenen
`dart test`-Befehl braucht.

Funktionsweise:
  1. Baseline: `dart test test/domain` muss auf unverändertem Code grün sein
     (sonst Abbruch – ein Mutationstest auf bereits rotem Code ist sinnlos).
  2. Für jede Mutation in MUTATIONS: exakt einen (eindeutigen) String in
     einer Quelldatei durch eine mutierte Variante ersetzen, `dart test`
     laufen lassen, Originaldatei IMMER wiederherstellen (try/finally).
  3. Ein Mutant gilt als "getötet", wenn die Testsuite mit dem mutierten
     Code fehlschlägt (exit code != 0) – das ist der gewünschte Fall: ein
     Test hat die eingeschleuste Verhaltensänderung bemerkt.
  4. Überlebt ein Mutant (Tests bleiben trotz Mutation grün), ist das eine
     nachgewiesene Testlücke für genau diese Code-Stelle.

Exit code: 0 nur, wenn ALLE Mutanten getötet wurden. Jeder Überlebende
lässt das Skript (und damit den CI-Schritt) fehlschlagen – Mutationstests
sind nach Abschnitt 40 ("~80% kritische Logik") ein Qualitätstor, kein
optionaler Report.
"""
from __future__ import annotations

import subprocess
import sys
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent

# Jede Mutation zielt auf eine konkrete, im Kommentar begründete
# Code-Stelle kritischer Domain-Logik (Abschnitt 40). "old" muss in der
# Datei exakt EINMAL vorkommen (Sicherheitsnetz gegen Verwechslungen bei
# künftigen Refactorings – das Skript bricht sonst kontrolliert ab, statt
# stillschweigend die falsche Stelle zu mutieren).
MUTATIONS: list[dict[str, str]] = [
    {
        "id": "MUT-01",
        "file": "lib/domain/tool.dart",
        "description": "Tool-State-Machine: AVAILABLE -> DELETED aus erlaubten Übergängen entfernen",
        "req": "Abschnitt 10.2",
        "old": "ToolStatus.available: {ToolStatus.requested, ToolStatus.deleted},",
        "new": "ToolStatus.available: {ToolStatus.requested},",
    },
    {
        "id": "MUT-02",
        "file": "lib/domain/loan_request.dart",
        "description": "LoanRequest-State-Machine: PENDING -> CANCELLED aus erlaubten Übergängen entfernen",
        "req": "Abschnitt 11.1",
        "old": "    LoanRequestStatus.rejected,\n    LoanRequestStatus.cancelled,\n  },",
        "new": "    LoanRequestStatus.rejected,\n  },",
    },
    {
        "id": "MUT-03",
        "file": "lib/domain/conflict_resolution.dart",
        "description": "resolveConflict: isAfter -> isBefore im ersten Vergleich (Last-Writer-Wins invertiert)",
        "req": "Abschnitt 22 (ADR-04 Arbeitsannahme)",
        "old": "if (a.updatedAt.isAfter(b.updatedAt)) return a;",
        "new": "if (a.updatedAt.isBefore(b.updatedAt)) return a;",
    },
    {
        "id": "MUT-04",
        "file": "lib/domain/conflict_resolution.dart",
        "description": "resolveConflict: Tiebreak-Vergleichsrichtung umgekehrt (>= 0 -> <= 0)",
        "req": "Abschnitt 22 (ADR-04 Arbeitsannahme)",
        "old": "a.conflictTieBreakId.compareTo(b.conflictTieBreakId) >= 0 ? a : b;",
        "new": "a.conflictTieBreakId.compareTo(b.conflictTieBreakId) <= 0 ? a : b;",
    },
    {
        "id": "MUT-05",
        "file": "lib/domain/tool_service.dart",
        "description": "_assertActor: Vergleich invertiert (!= -> ==) – hebelt alle Berechtigungsprüfungen aus",
        "req": "Abschnitt 10.1/33",
        "old": "if (actual != expected) {",
        "new": "if (actual == expected) {",
    },
    {
        "id": "MUT-06",
        "file": "lib/domain/tool_service.dart",
        "description": "requestLoan: Duplicate-Request-Guard wird nie ausgelöst (REQ-249)",
        "req": "Abschnitt 11.1",
        "old": "existingActiveRequestsForTool.any((r) => r.isActive)",
        "new": "existingActiveRequestsForTool.any((r) => false)",
    },
    {
        "id": "MUT-07",
        "file": "lib/domain/loan.dart",
        "description": "Loan: returnedAt<->COMPLETED-Kopplung invertiert (== -> !=)",
        "req": "Abschnitt 12 (Guard: kein 'halb abgeschlossener' Zustand)",
        "old": "(status == LoanStatus.completed) == (returnedAt != null),",
        "new": "(status == LoanStatus.completed) != (returnedAt != null),",
    },
    {
        "id": "MUT-08",
        "file": "lib/domain/community.dart",
        "description": "hasActiveMember: active -> removed (Mitgliedscheck invertiert)",
        "req": "Abschnitt 9",
        "old": "m.pubkey == pubkey && m.status == MembershipStatus.active,",
        "new": "m.pubkey == pubkey && m.status == MembershipStatus.removed,",
    },
    {
        "id": "MUT-09",
        "file": "lib/domain/community.dart",
        "description": "withMemberRemoved: setzt fälschlich 'active' statt 'removed'",
        "req": "Abschnitt 9",
        "old": "status: MembershipStatus.removed) else m,",
        "new": "status: MembershipStatus.active) else m,",
    },
    {
        "id": "MUT-10",
        "file": "lib/domain/tool.dart",
        "description": "Tool.isOwnedBy: Gleichheitsprüfung invertiert (== -> !=)",
        "req": "Abschnitt 10.1",
        "old": "bool isOwnedBy(Pubkey pubkey) => ownerPubkey == pubkey;",
        "new": "bool isOwnedBy(Pubkey pubkey) => ownerPubkey != pubkey;",
    },
]


def run_tests() -> tuple[int, str, str]:
    result = subprocess.run(
        ["dart", "test", "test/domain", "--reporter=compact"],
        cwd=REPO_ROOT,
        capture_output=True,
        text=True,
        check=False,
    )
    return result.returncode, result.stdout, result.stderr


def main() -> int:
    print("== Baseline (unmutierter Code) ==")
    baseline_code, baseline_out, baseline_err = run_tests()
    print(baseline_out)
    if baseline_code != 0:
        print("FEHLER: Baseline ist bereits rot – Mutationstest wird abgebrochen.")
        print(baseline_err)
        return 2
    print("Baseline grün.\n")

    results = []
    for mutation in MUTATIONS:
        path = REPO_ROOT / mutation["file"]
        original = path.read_text(encoding="utf-8")
        occurrences = original.count(mutation["old"])
        if occurrences != 1:
            print(
                f"FEHLER: {mutation['id']}: Suchtext {occurrences}x in {mutation['file']} "
                "gefunden (erwartet genau 1). Datei hat sich vermutlich geändert – "
                "Mutation in tool/mutation_test.py aktualisieren."
            )
            return 2

        mutated = original.replace(mutation["old"], mutation["new"])
        path.write_text(mutated, encoding="utf-8")
        try:
            code, _out, _err = run_tests()
        finally:
            path.write_text(original, encoding="utf-8")

        killed = code != 0
        results.append({**mutation, "killed": killed})
        status = "GETÖTET " if killed else "ÜBERLEBT"
        print(f"[{status}] {mutation['id']} ({mutation['file']}): {mutation['description']}")

    total = len(results)
    killed_count = sum(1 for r in results if r["killed"])
    survivors = [r for r in results if not r["killed"]]

    print()
    print(f"Mutation Score: {killed_count}/{total} ({100 * killed_count / total:.1f}%)")

    if survivors:
        print("\nÜberlebende Mutanten (nachgewiesene Testlücken):")
        for r in survivors:
            print(f"  - {r['id']} [{r['file']}] {r['description']} (REQ: {r['req']})")
        return 1

    print("Alle Mutanten getötet.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
