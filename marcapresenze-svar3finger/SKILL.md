---
name: marcapresenze-svar3finger
description: Reference for the SVAR3-FINGER/A attendance terminal and its Anviz software (Intelligent Management System + Communication Management Software). Use when the user asks about the office timbratura/marcapresenze system, employee clock-in setup, work shifts (orari e turni), downloading punches from the terminal, or attendance reports. Triggers on "marcapresenze", "SVAR", "Anviz", "timbratura", "terminale presenze", "orari e turni", "rilevazione presenze".
---

# Marcapresenze SVAR3-FINGER/A — riferimento rapido

Sistema: terminale SVAR3-FINGER/A (impronta/tessera) + software Anviz **Intelligent
Management System** (gestione) e **Communication Management Software** (comunicazione
col terminale). Fornitore: S.V.A.R., Mestre VE — 041 5322732 — info@svar1951.it.
Manuale sorgente: `Manuale software SVAR3finger_7 25.pdf` (07/2025).

Dettaglio completo passo-passo: [references/manuale-completo.md](references/manuale-completo.md).

## Indice rapido — "come si fa X"

| Vuoi fare... | Vai a |
|---|---|
| Installare il software / metterlo in italiano | §1 |
| Registrare un nuovo terminale nel software | §2 |
| Aggiungere/importare un dipendente | §2 |
| Impostare orari di lavoro (continuato o con pausa pranzo) | §3 |
| Creare un turno e assegnarlo ai dipendenti | §3 |
| Scaricare le timbrature (rete o chiavetta USB) | §4 |
| Leggere/stampare i report presenze | §5 |
| Entrare nel menu fisico del terminale | §4 |

---

## §1 — Installazione e lingua italiana

1. Scarica da `www.svar1951.it/assistenza-tecnica/sw.htm` → icona freccia in
   basso (sfondo nero) → `sw anviz 2019.zip` → cartella `SETUP` → `SETUP.EXE`.
2. Estrai tutto → Esegui → Next → Next → Install → Sì al prompt di sistema → Close.
3. Apri l'icona **Anviz Intelligent Management System** sul desktop, login
   vuoto (nessuna password, digita OK).
4. Per il software: menu **Device management** → **Connect to Time Attendance
   Device** → si apre "Communication Management Software" → tendina in alto
   (di default "English") → seleziona **Italian**.
5. Chiudi entrambi i programmi e riaprili: ora sono in italiano.

## §2 — Registrare terminale e dipendenti

1. Menu **Gestione Terminale** → **Connessione a Terminale** → **Aggiungi Terminale**.
   Un'operazione per ogni terminale fisico che hai.
2. Campo "Tipo Terminale": lascia **Impronta/Scheda Verifica** (non toccare).
3. Numero Terminale = Identificativo Terminale (stesso numero, es. `1`; se hai
   più terminali: 1, 2, 3...). Nel campo "Nome Terminale" scrivi dove si trova
   (es. "uffici", "magazzino").
4. Campo **LAN**: l'indirizzo IP che vuoi assegnare a quel terminale.
5. **OK** per salvare. Icona **blu** = collegato via rete Ethernet/LAN. Icona
   **arancione** = non in rete, timbrature scaricate solo via chiavetta USB.
6. Se in rete, il software verifica da solo che il terminale risponda, poi fai
   la **Sincronizzazione Data e Ora** (manda l'orario del PC al terminale).
7. Le tessere/impronte sono già registrate nel terminale dal fornitore. Per
   portarle nel software: **Scarica Utenti da Terminale** → crea la lista utenti.
8. Per l'anagrafica: **Gestione Utenti** → doppio click sinistro sul numero
   utente → compila nome e cognome → **Salva**.

## §3 — Orari e turni

Due fasi obbligatorie in quest'ordine: prima gli **orari**, poi i **turni**
che li combinano. Sezione: **Orari e Turni** (dalla home, dopo aver chiuso la
maschera "gestione terminali" con la X in alto a destra).

**Fase 1 — Gestione Orari:**
- Orario **continuato**: 2 timbrature/giorno, es. 08:00–16:00.
- Orario **spezzato** (con pausa pranzo): 4 timbrature/giorno, servono
  **due orari separati** — es. "mattina" 08:00–12:30 e "pomeriggio" 13:30–17:00.
- **Inizio/Termine Orario Ingresso**: finestra oraria in cui è valida la
  timbratura di entrata. Stesso concetto per **Uscita**.
- **Tolleranza Ritardo / Anticipo** (minuti): margine senza sanzione. Es. 5
  min → entrare fino alle 08:05 o uscire dalle 15:55 conta come orario pieno.
- **Considera come giorno lavorativo**: `1` per un orario continuato pieno;
  `0,5` per ciascuna metà di un orario spezzato (mattina + pomeriggio = 1).
- **Considera come tempo lavorativo** (minuti): `480` per 8h continuate;
  `240` + `240` per uno spezzato mattina/pomeriggio.
- Flag "timbratura obbligatoria ingresso/uscita": il dipendente **deve**
  timbrare entrambe.
- Flag straordinario: marca l'intero orario come tempo straordinario
  (usalo solo per turni dedicati allo straordinario).

**Fase 2 — Gestione Turni:**
- Un turno = uno o più orari combinati, con una ciclicità (giornaliera,
  settimanale...). Se l'orario è identico ogni giorno/settimana per un
  dipendente, basta **un solo turno**.

**Assegnare il turno ai dipendenti — menu Pianificazione:**
1. Seleziona utente/i.
2. **Organizza**.
3. Scegli il turno dall'elenco + periodo di validità (Inizio/Fine).
4. **Aggiungi** → **OK**. Compare la barra di salvataggio.

## §4 — Scaricare le timbrature

**Terminale in rete (Ethernet):**
Home → **Gestione Terminale** → **Connessione a Terminale** →
**Scarica Nuove Registrazioni**.

**Terminale non in rete (chiavetta USB, max 64 MB):**
1. Sul terminale fisico, entra nel menu: tasto menu → `0` + OK → password
   **12345** → OK. (Tasti IN/OUT muovono tra i menu, OK conferma.)
2. Vai in **data** → **Esporta** → **Timbratura** → OK → aspetta
   "operazione conclusa".
3. Il terminale scrive sulla chiavetta una cartella `000001` (numero varia
   per terminale) con un file criptato `bak.kq`. Riusando la stessa
   chiavetta, il file viene sovrascritto.
4. Esci dal menu del terminale (tasto indietro finché non torna data/ora).
5. Inserisci la chiavetta nel PC → apri Anviz → **Gestione Terminale** →
   **Connessione a Terminale** → **Gestione USB**.
6. Il software assegna da solo una lettera all'unità USB (es. `U:/`) →
   **Leggi Record da U Disk** → mostra il risultato delle timbrature scaricate.

## §5 — Report presenze

Home → **Rapporti** → scegli utente/i + periodo (da/a data) → **Calcola**.

4 report generati:

1. **Attendance Exceptions** — lista timbrature nel periodo + eventuali
   errori di timbratura.
2. **Shift Exceptions** — turno, timbrature, ritardi in entrata, anticipi in
   uscita, ore straordinarie.
3. **Other Exceptions** — timbrature sabato/domenica/festivi, assenze per
   malattia o ferie (secondo turno e calendario).
4. **Calculated Items** — riepilogo per dipendente: giorni lavorativi totali,
   giorni effettivi lavorati, giorni di presenza, minuti totali di ritardo,
   minuti totali di anticipo, giorni di assenza, ore straordinarie totali
   (+ normali, weekend, festive separate), totale ore lavorate "Worktime"
   (ore e centesimi).

Nota: ritardi e anticipi vengono scalati automaticamente dal Worktime totale.
La voce "straordinari" è **cumulativa** (somma normali + weekend + festivi).

Esportazione: tasto **Esporta** → Excel, per tutti e 4 i report.
Stampa: tasto **Rapporto** → "Crea Report per Griglia Corrente" (stampa quello
che vedi a video) → puoi anche salvarlo in altri formati.

## Domande frequenti

- **"Il dipendente è entrato in ritardo, conta?"** → Solo se supera la
  Tolleranza Ritardo impostata sull'orario di quel turno (§3).
- **"Come faccio un turno con pausa pranzo?"** → Due orari separati
  (mattina/pomeriggio), ciascuno vale 0,5 giorno lavorativo (§3).
- **"Il terminale non è in rete, come prendo le timbrature?"** → Chiavetta
  USB, procedura completa in §4.
- **"Dove vedo le ore di straordinario di un dipendente?"** → Report
  **Shift Exceptions** o il totale in **Calculated Items** (§5).
- **"Ho più terminali, come li distinguo?"** → Numero + Identificativo
  Terminale progressivi, e un Nome Terminale descrittivo (es. reparto) (§2).
