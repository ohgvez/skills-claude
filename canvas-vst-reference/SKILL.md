---
name: canvas-vst-reference
description: Specifica di riferimento per Art DSP Canvas 1.0 (il plugin VST3/AU/AAX di mixing visuale a blob 3D) e checklist di fedeltà per il suo clone JUCE/C++ "Canvas3D" in C:\Users\Trevor Ohhvez\Desktop\canvas3d\vst\Source\. Usa SEMPRE questa skill prima di modificare BlobShader.h, PluginProcessor.cpp/h o PluginEditor.cpp/h, o quando l'utente parla di "Canvas", "blob", "il VST del mixing 3D", "Art DSP", tool dock, Make Space, EXTREME, EQ editor, Mix Template, o chiede "così faceva l'originale?" / "manca qualcosa rispetto a Canvas?". Innesca anche su richieste generiche di modificare la forma dei blob, il raymarching, le mappature degli assi o il comportamento dei tool: verifica sempre qui prima di inventare un comportamento, perché il codice del clone diverge dall'originale in punti noti, documentati sotto.
---

# Canvas (Art DSP) — riferimento e checklist per il clone Canvas3D

Questa skill riassume, con parole proprie, il manuale ufficiale di **Canvas 1.0** (Art DSP,
plugin VST3/AU/AAX di visual mixing) e lo mette a confronto con lo stato del nostro clone
**Canvas3D** (JUCE/C++, `vst/Source/`). Serve come specifica di terra ferma: quando modifichi
il DSP o lo shader e non sei sicuro di come si comporta l'originale, la risposta è qui, non
va indovinata.

Il testo completo estratto dal PDF ufficiale (scaricato da artdsp.net) sta in
`references/manual-fulltext.txt`, per citazioni puntuali o dettagli non riassunti qui sotto.
**Le schermate dell'originale** sono estratte in
`C:\Users\Trevor Ohhvez\Desktop\canvas3d\reference\pages\` (i file `img-obj*-1440x900.png`
sono le 13 viste dell'interfaccia): guardale prima di toccare l'estetica, perché il manuale
a parole non basta a giudicare come sono fatti i corpi e la stanza.
**Non riprodurlo verbatim in output rivolti all'utente oltre una breve citazione** — è materiale
con copyright di Art DSP; questa skill esiste per lavorare sul codice, non per ridistribuire il
manuale.

Il nostro `SPEC-canvas-originale.md` (in `canvas3d/`) è la fonte già esistente e più aggiornata
sullo stato di fedeltà del clone: leggila insieme a questa skill, non al suo posto.

## Il concetto

Ogni traccia è un blob colorato disegnato **in tempo reale dall'audio stesso**, non posizionato
a mano. Tre assi, tutti e tre letture di cosa fa davvero il suono:

- **X (sinistra-destra)** = posizione stereo (pan).
- **Y (basso-alto)** = **frequenza**, scala logaritmica da 0/20 Hz sul pavimento a 18 kHz sul
  soffitto. Non è uno shelf, non è un tilt: è dove sta la campana EQ (bell) che modula
  quell'enfasi.
- **Z (dietro-avanti)** = **loudness**: i suoni forti vengono avanti, i deboli affondano verso il
  fondo. Non è un parametro trascinabile: è una lettura derivata dal volume (o dalla loudness
  misurata, a seconda della modalità Depth).

La forma segue l'audio reale: un suono mono è **una colonna singola**; un hard-pan doppio è
**due lobi con un vuoto in mezzo**; **l'altezza del blob copre le frequenze che il suono occupa
davvero**, non un punto fisso.

## Multi-istanza condivisa

Un'istanza per traccia, tutte registrate in un registro condiviso nel processo host: aprire una
finestra qualsiasi mostra (e permette di muovere) tutti i blob del progetto. Le istanze si vedono
**solo dentro lo stesso formato plugin** — VST3 vede VST3, AU vede AU, AAX vede AAX; mescolare i
formati spezza il mix in stanze separate. (`SharedStage` nel clone replica questo, ma per un
motivo diverso: è un singleton nel processo, non ha il concetto di "formato".)

## Il dock strumenti (una lettera per tool)

Ogni tool agisce sul blob **selezionato**. Lo scroll fa quasi sempre qualcosa di utile; il tasto
destro su un pulsante del dock resetta ciò che quel tool controlla.

| tool | tasto | cosa fa |
|---|---|---|
| Select | Q | click seleziona; shift+drag muove liberamente (frequenza + pan insieme) |
| Grab | G | "fratello" di Select nello stesso slot: drag libero senza modificatore |
| Auto-Select | X | toggle: click seleziona con qualsiasi tool attivo (i pennelli restano l'eccezione) |
| Freq | F | sposta una **campana EQ statica**: drag verticale = frequenza, scroll verticale = intensità (gain), scroll orizzontale = Q/ampiezza |
| Shelf | S | due linee tratteggiate = cutoff high/low shelf; drag verticale nella zona = gain; ctrl/cmd+drag sulla linea = cutoff; scroll = Q; shift-drag ("stretch") muove i due shelf in opposizione, un gesto solo schiarisce sopra e ammorbidisce sotto |
| Add | A | pennello: tenendo premuto dipinge un boost EQ, cresce col tempo di pressione; genera punti EQ editabili (max 12) |
| Subtract | Z | pennello opposto: scava la banda sotto il cursore |
| Widen | W | drag destra/sinistra = larghezza stereo; tre stili nella barra opzioni (vedi sotto) |
| Pan | P | solo pan, non tocca l'EQ |
| Vol | V | volume post-effetti (stesso parametro della manopola nel Track Panel) |

**EXTREME** (accanto a Freq): EQ dinamico che isola il suono dentro la campana. Fuori taglia fino
a 64 dB; dentro misura quanta energia c'è davvero nella banda e compensa il guadagno per tenere
il suono a piena loudness — una banda vuota riceve una spinta grande, una piena quasi nulla.

**Stili di Widen:**
- *Modern* — allargamento broadband pulito, mono-safe.
- *Haas* — ritardo breve, più senso di profondità, resta mono-safe (il ritardo sta sotto la
  soglia di percezione dell'eco).
- *PingPong* — echi ritmici hard L/R, dichiaratamente **non** mono-compatibile.

**Right-click su un blob selezionato:** Solo, Mute, Hide (nasconde dal canvas senza toccare
l'audio — l'occhio nel Track Panel fa lo stesso), Reset Blob (con conferma, riporta EQ/shelf/pan
/width/volume ai default).

## EQ Editor

Tutto quello che i pennelli dipingono si condensa in **punti EQ editabili (max 12)**, mostrati
su una curva sopra l'analizzatore live. Drag = frequenza+gain, scroll = larghezza/Q, doppio
click = elimina. Automatizzabili dalla DAW.

## Auto-Gain

Mantiene costante la loudness del canale mentre lavori: confronta il livello prima e dopo la
catena e compensa, così il confronto durante l'EQ non è falsato dal volume.

## Disable / Bypass

L'audio passa intatto, il blob diventa **grigio** (continua a essere disegnato, solo senza
colore identità — l'analisi non si ferma).

## Track Panel (tasto Tab)

Una riga per traccia: striscia colore, nome (sync dal nome DAW, o rinominabile a mano — il nome
manuale ha precedenza), badge **SC** (Make Space attivo su questa traccia), manopola volume
(stesso parametro del tool Vol), e **due controlli separati** a fine riga:

- **mute dot** → mute/unmute **audio**; right-click → solo audio.
- **eye** → mostra/nasconde **solo la vista** (il blob sparisce dal canvas, l'audio continua);
  right-click → solo visivo.
- Shift unisce i due in un'unica capsula (mute+hide insieme).

Right-click su una riga: Enabled/bypass, colore (palette identità), **Copy/Paste settings**
(sposta l'intero trattamento — EQ, pan, width, **incluso il sidechain** — da una traccia
all'altra), Rename/Reset name. Righe riordinabili, ordine condiviso fra le finestre.

## Make Space (ducking spettrale)

Si configura **dalla traccia che PRENDE lo spazio**, scegliendo quali tracce devono cederglielo
(non il contrario). Per ogni link: On/off, **Amount** (quanto spazio viene preso), **Attack /
Release**, **Trigger**: *Amplitude* (morbido, segue il livello) o *Transient* (scattante, segue
i colpi). Il duck si concentra dove sta davvero l'energia del trigger banda per banda — un kick
può togliere spazio in basso a un pad senza toccarne le alte. Si vede disegnato **in arancione**
nell'EQ editor della traccia che cede, in tempo reale.

## Preset & Mix Template

- **Preset per traccia**: cattura EQ, campana, shelf, punti dipinti, pan, width, volume di UN
  suono. Non include nome né i link di Make Space (quelli appartengono al progetto).
- **Mix Template** (sperimentale, nell'originale): analizza l'intero mix, riconosce il ruolo di
  ogni traccia dal nome (kick, bass, vocal, ecc.), chiede di azzerare i fader DAW e mettere
  Canvas ultimo in catena, poi applica EQ/pan/width/sidechain/volume in base al ruolo
  riconosciuto. Le tracce non riconosciute vanno taggate a mano o vengono saltate.

## Scorciatoie da tastiera

`Q` Select · `G` Grab · `X` Auto-select toggle · `F` Freq (Shift+F = freq+pan insieme) ·
`S` Shelf · `A` Add · `Z` Subtract · `W` Widen · `P` Pan · `V` Vol · `Tab` apre/chiude il
Track Panel · `Esc` chiude i dialoghi (mai la finestra) · tenere premuto mentre si trascina
= controllo fine su manopole/valori.

---

## Checklist di fedeltà: cosa ha ancora il nostro clone da allineare

Lo stato dettagliato vive in `canvas3d/SPEC-canvas-originale.md` — rileggilo prima di lavorare,
perché viene aggiornato man mano che il clone si avvicina. Al momento dell'ultima lettura
(2026-08-24), il clone copre correttamente assi, campana EQ, shelf, pennelli, EXTREME,
Auto-Gain, width a 3 stili, Make Space, Track Panel, preset per traccia, viste Front/Free.

Dopo la passata estetica del 2026-08-24 (blob solidi illuminati, stanza completa con le due
scale, dock a sinistra, pannello a destra, manopole per tool, etichette sui blob) mancano
ancora, esplicitamente:

1. **Mix Template** — analisi dell'intero progetto, riconoscimento automatico del ruolo di ogni
   traccia e applicazione automatica di EQ/pan/width/sidechain/volume. Nell'originale è marcata
   come sperimentale, quindi non è la priorità più urgente, ma se l'utente la richiede è un
   pezzo di UI + analisi nuovo, non una piccola patch. La barra "Mix template" in cima al
   pannello tracce **è disegnata ma non fa ancora nulla**.
2. **EQ editor ridimensionabile** — ora è una finestra mobile che si apre dall'icona sotto il
   dock, ma non si trascina né si ridimensiona dall'angolo.
3. **Preset per traccia dalla barra in alto** — "Apply preset to ..." è disegnata ma non apre
   ancora il menu dei preset (il salvataggio/caricamento esiste già nel processore).
4. **Undo/redo** e le impostazioni Source Blob (Form, Frequency Sensitivity, Width Averaging,
   Smoothness, Hold Time) come controlli veri: al momento sono costanti nello shader.

Differenza **voluta**, non un bug: i blob del clone sono più luminosi e "shiny" dell'originale
— l'utente lo ha confermato esplicitamente. Non provare ad "aggiustarla".

## Dove guardare nel codice quando serve confrontare

- `vst/Source/SharedStage.h/.cpp` — registro condiviso, palette, bande di frequenza/ducking.
- `vst/Source/PluginProcessor.h/.cpp` — DSP: `CanvasMap` (le costanti degli assi), campana/shelf/
  punti EQ, EXTREME, Auto-Gain, Make Space, width, analisi spettrale FFT a 32 bande.
- `vst/Source/PluginEditor.h/.cpp` — camera, tool dock (`kTools`, `applyToolDrag`), picking,
  Track Panel, EQ curve, menu contestuali.
- `vst/Source/BlobShader.h` — il raymarching: qui la forma del blob diventa pixel. Se l'utente
  lamenta che "non sembra un blob" o "sembra un'onda/striscia", il problema è quasi sempre qui
  dentro (letture della texture spettro, soglie di densità, isosuperficie).
