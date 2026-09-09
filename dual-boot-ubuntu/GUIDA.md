# Dual boot Windows 10 + Ubuntu LTS su laptop — requisiti e guida completa

Guida operativa per: **provare** Ubuntu senza toccare il disco (live USB / "trial boot") e poi
**installarlo in dual boot** accanto a Windows 10 su un portatile.

> Nota sui tempi: Windows 10 non riceve più aggiornamenti di sicurezza dall'ottobre 2025.
> Se il laptop non è idoneo a Windows 11, il dual boot (o il passaggio completo a Linux)
> è anche una scelta di sicurezza, non solo di curiosità.

---

## 0. Tre modi di "provare" Linux — scegli il livello di rischio

| Modo | Rischio per Windows | Prestazioni | A cosa serve |
|---|---|---|---|
| **Macchina virtuale** (VirtualBox / VMware / Hyper-V) | Nessuno | Basse, niente GPU vera | Vedere com'è il desktop, imparare i comandi |
| **Live USB / "trial boot"** | Quasi nullo (non scrive sul disco) | Medie (gira da USB) | **Verificare che il tuo hardware funzioni**: Wi-Fi, audio, touchpad, luminosità |
| **Dual boot** (installazione) | Reale: si toccano le partizioni | Piene | Uso quotidiano |

Il percorso corretto è: **live USB prima, dual boot dopo**. La live USB è il collaudo:
se lì il Wi-Fi non va, non andrà nemmeno installato (a meno di driver aggiuntivi).

---

## 1. Requisiti

### 1.1 Hardware minimo (Ubuntu Desktop LTS)

| Componente | Minimo | Consigliato |
|---|---|---|
| CPU | dual core 2 GHz (x86_64) | quad core recente |
| RAM | 4 GB | 8 GB o più |
| Spazio libero per Ubuntu | 25 GB | **60–120 GB** |
| Chiavetta USB | 4 GB | 8–16 GB (USB 3.0) |
| Rete | serve durante/dopo l'installazione | cavo o Wi-Fi funzionante |
| Firmware | UEFI (o BIOS legacy, gestibile) | UEFI + GPT |

Con 4 GB di RAM valuta una variante più leggera (Xubuntu, Lubuntu, Linux Mint XFCE):
GNOME su 4 GB è utilizzabile ma non brillante.

### 1.2 Materiale da avere pronto

- Chiavetta USB da almeno 8 GB (**verrà cancellata**).
- Un disco esterno per il backup dei tuoi file.
- Alimentatore collegato (mai installare a batteria).
- La ISO di Ubuntu LTS, scaricata da **ubuntu.com/download/desktop** (prendi la LTS proposta,
  es. 24.04 LTS o la LTS successiva; evita le versioni interim a 9 mesi di supporto).
- Lo strumento per scrivere la chiavetta: **Rufus** (Windows, consigliato), Ventoy o balenaEtcher.
- **La chiave di recupero BitLocker**, se BitLocker è attivo (vedi 2.2).
- Il tuo account Microsoft e la licenza Windows: la licenza è legata alla scheda madre,
  il dual boot non la invalida.

### 1.3 Requisiti "software/configurazione" da sistemare prima

Sono i cinque punti che fanno fallire il 90% dei dual boot:

1. **Spazio non allocato sufficiente** — ricavato restringendo Windows (§4).
2. **BitLocker sospeso o disattivato** — altrimenti Windows chiederà la chiave a ogni avvio.
3. **Fast Startup e ibernazione disattivati** — altrimenti la partizione NTFS resta "sporca"
   e Linux la monta in sola lettura (o la danneggia).
4. **Controller disco in modalità AHCI, non Intel RST/RAID** — l'installer Ubuntu altrimenti
   non vede il disco.
5. **Secure Boot**: si può lasciare attivo (Ubuntu è firmato), ma serve capire la password MOK
   se installi driver proprietari NVIDIA (§6.4).

---

## 2. Diagnostica: cosa controllare su Windows (10 minuti)

Apri **PowerShell come amministratore** (tasto Windows → digita `powershell` → "Esegui come amministratore").

### 2.1 UEFI o BIOS legacy?

```
msinfo32
```
Cerca la riga **"Modalità BIOS"**: deve dire `UEFI` (caso normale su un laptop degli ultimi 10 anni).
Se dice `Legacy`, il dual boot si fa comunque, ma Ubuntu va installato in modalità legacy/MBR
per coerenza con Windows: non mescolare i due modi.

Controlla anche **"Tipo di sistema"**: deve essere `x64`.

### 2.2 BitLocker attivo?

```
manage-bde -status
```
- `Protection On` → **è attivo**. Prima di continuare:
  1. Salva la chiave di recupero: vai su **account.microsoft.com/devices/recoverykey** e
     stampala o copiala su carta/telefono.
  2. Sospendilo o disattivalo: Pannello di controllo → Crittografia unità BitLocker →
     *Sospendi protezione* (o *Disattiva BitLocker* per decrittografare, più lento ma più sicuro
     per un dual boot permanente).
- `Protection Off` / errore "non trovato" → nulla da fare.

Su molti portatili con account Microsoft è attiva la "Crittografia dispositivo", che è BitLocker
sotto altro nome: controllala in *Impostazioni → Privacy e sicurezza → Crittografia dispositivo*.

### 2.3 Spazio disco e struttura delle partizioni

```
diskmgmt.msc
```
Guarda: quanti dischi fisici hai, quanto spazio libero c'è su `C:`, e se esistono partizioni
di ripristino OEM (Lenovo/HP/Dell ne mettono 2–4: **non toccarle**).

Regola pratica: lascia almeno **60 GB liberi a Windows** dopo il restringimento, altrimenti gli
aggiornamenti falliscono.

Se hai **due dischi** (es. SSD + HDD, o due slot NVMe) sei fortunato: installa Ubuntu sul secondo
disco e salti tutta la parte di restringimento.

### 2.4 Disattivare ibernazione e Fast Startup

```
powercfg /h off
```
Questo comando singolo disattiva ibernazione **e** Fast Startup, e libera anche diversi GB
(`hiberfil.sys`). Verifica poi in *Pannello di controllo → Opzioni risparmio energia →
Specifica comportamento pulsanti di alimentazione → Modifica impostazioni attualmente non disponibili*
che "Attiva avvio rapido" sia deselezionato.

**Perché è obbligatorio:** con Fast Startup, "spegni" Windows senza spegnerlo davvero. Se poi Linux
scrive sulla partizione NTFS, al ritorno in Windows il filesystem risulta incoerente.

### 2.5 Modalità del controller disco (Intel RST / RAID)

Apri **Gestione dispositivi** → *Controller IDE ATA/ATAPI* o *Controller di archiviazione*.
Se leggi **"Intel RST"**, **"Intel Rapid Storage"** o **"RAID"**, l'installer Ubuntu non vedrà l'SSD.

Passaggio ad AHCI senza reinstallare Windows:

```
bcdedit /set {current} safeboot minimal
```
1. Riavvia, entra nel firmware (§5.1) e imposta il controller SATA/NVMe su **AHCI**.
2. Windows parte in modalità provvisoria e installa i driver AHCI.
3. Torna in PowerShell da amministratore:
```
bcdedit /deletevalue {current} safeboot
```
4. Riavvia normalmente.

Su alcuni laptop la voce si chiama *SATA Mode*, *Storage Configuration* o va cambiata insieme a
"VMD Controller" (disattivalo).

### 2.6 Riepilogo hardware (utile per cercare aiuto nei forum)

```
systeminfo | findstr /C:"Nome sistema operativo" /C:"Produttore sistema" /C:"Modello sistema" /C:"Memoria fisica totale"
```

---

## 3. Backup — non è opzionale

Il dual boot su un disco che ha già Windows comporta la modifica della tabella delle partizioni.
Va bene il 99% delle volte. Il tuo piano deve funzionare anche nell'1%.

Prima di procedere:

- [ ] Copia **i tuoi file** (Documenti, Desktop, Immagini, download importanti) su disco esterno o cloud.
- [ ] Salva la **chiave di recupero BitLocker** fuori dal PC.
- [ ] Esporta le password dal browser o verifica che siano sincronizzate.
- [ ] Crea un **supporto di ripristino Windows** su una *seconda* chiavetta:
      tasto Windows → "Crea un'unità di ripristino" (spunta "Esegui backup dei file di sistema").
- [ ] Opzionale ma consigliato: immagine completa del disco con Macrium Reflect Free / Clonezilla.
- [ ] Nota il modello esatto del laptop e la versione del BIOS.

---

## 4. Fare spazio: restringere la partizione Windows

**Fallo da Windows**, non dall'installer di Ubuntu: Windows conosce i propri metadati.

1. Se hai un HDD meccanico: deframmenta (`dfrgui`). Su SSD **no**, salta.
2. `diskmgmt.msc` → clic destro su `C:` → **Riduci volume**.
3. Inserisci lo spazio da liberare **in MB**:
   - 40 000 MB (~40 GB) = minimo vivibile
   - 80 000–120 000 MB (~80–120 GB) = consigliato
   - 200 000+ MB se Linux diventerà il sistema principale
4. Il risultato deve essere **"Non allocato"**. Lascialo così: sarà l'installer di Ubuntu a usarlo.

### Se Windows non ti lascia restringere abbastanza

Il limite è dato dai file inamovibili a fine partizione. In ordine:

```
powercfg /h off
```
Poi disattiva temporaneamente:
- **File di paging**: Sistema → Impostazioni di sistema avanzate → Prestazioni → Avanzate →
  Memoria virtuale → *Nessun file di paging* → riavvia.
- **Protezione sistema / punti di ripristino**: `SystemPropertiesProtection` → Disattiva → Elimina.
- Pulizia disco: `cleanmgr` → *Pulizia file di sistema* (rimuove installazioni Windows precedenti).

Riavvia, riprova il restringimento, poi **riattiva file di paging e protezione sistema**.

Ultima risorsa: restringere con **GParted** dalla live USB di Ubuntu (funziona bene, ma richiede
BitLocker disattivato e un chkdsk pulito prima; è l'opzione con più rischio).

---

## 5. Preparare la chiavetta e fare il "trial boot" (live USB)

### 5.1 Scrivere la ISO

**Verifica prima l'integrità del download** (evita installazioni fallite a metà):
```
certutil -hashfile C:\percorso\ubuntu-XX.XX-desktop-amd64.iso SHA256
```
Confronta la stringa con quella pubblicata su `releases.ubuntu.com` (file `SHA256SUMS`).

Con **Rufus**:
- Dispositivo: la tua chiavetta
- Selezione boot: la ISO di Ubuntu
- Schema partizione: **GPT**, Sistema destinazione: **UEFI (non CSM)** — se §2.1 diceva UEFI
- Modalità di scrittura: **DD Image** se Rufus lo propone
- Avvia, conferma la cancellazione della chiavetta

Alternativa comoda: **Ventoy** — installi Ventoy una volta sulla chiavetta e poi ci copi dentro
più ISO come file normali, scegliendo al boot quale provare.

### 5.2 Avviare dalla chiavetta

Chiavetta inserita (**porta USB 2.0/nera se possibile**, più compatibile), poi:

- Metodo affidabile da Windows: *Impostazioni → Sistema → Ripristino → Avvio avanzato → Riavvia ora*
  → **Usa un dispositivo** (oppure *Risoluzione problemi → Opzioni avanzate → Impostazioni firmware UEFI*).
- Oppure tieni premuto **Shift** mentre clicchi *Riavvia*.
- Oppure il tasto del menu di boot all'accensione:

| Marca | Menu di boot | Setup firmware |
|---|---|---|
| Lenovo | F12 (o tasto Novo) | F1 / F2 |
| HP | F9 (o Esc → menu) | F10 |
| Dell | F12 | F2 |
| Acer | F12 (da abilitare nel BIOS) | F2 |
| Asus | Esc o F8 | F2 / Del |
| MSI | F11 | Del |
| Samsung | Esc / F2 | F2 |
| Toshiba / Dynabook | F12 | F2 |
| Microsoft Surface | tieni premuto Volume Su all'accensione | — |

Nel firmware, se serve: disattiva **Fast Boot** (quello del BIOS, non di Windows), lascia
**Secure Boot** attivo (Ubuntu è firmato), non attivare CSM/Legacy se Windows è in UEFI.

### 5.3 Il collaudo: cosa provare nella sessione live

Al menu scegli **"Try Ubuntu" / "Prova Ubuntu"** (non "Install"). Non viene scritto nulla sul disco.

Checklist da spuntare davvero:

- [ ] **Wi-Fi**: vede le reti e si connette? (il punto che fallisce più spesso, tipicamente su Broadcom/Realtek)
- [ ] **Audio**: suono dagli altoparlanti *e* dal jack cuffie
- [ ] **Microfono e webcam** (apri Cheese o le impostazioni audio)
- [ ] **Touchpad**: click, scorrimento a due dita, gesture
- [ ] **Tasti funzione**: luminosità schermo, volume, retroilluminazione tastiera, blocco Wi-Fi
- [ ] **Bluetooth**: associa le cuffie
- [ ] **Uscita video**: HDMI/USB-C verso un monitor esterno
- [ ] **Scheda video dedicata** (se NVIDIA/AMD): la sessione parte senza schermo nero?
- [ ] **Lettore di impronte / SD / porte USB**
- [ ] Risoluzione e scalatura corretta su schermo HiDPI

Comandi utili nel terminale live (Ctrl+Alt+T):
```
inxi -Fxz            # panoramica hardware (installalo con: sudo apt install inxi)
lspci -k             # dispositivi PCI e driver kernel in uso
ip a                 # interfacce di rete
lsblk -f             # dischi, partizioni, filesystem, UUID
sudo dmesg | grep -i firmware   # firmware mancanti
```

Aspettative realistiche: la live è **lenta** (gira da USB), non conserva nulla al riavvio, e
sospensione/risparmio energetico non sono rappresentativi del sistema installato.
Se un componente non funziona in live, cercalo online come *"<modello laptop> ubuntu <componente>"*
**prima** di installare.

---

## 6. Installazione in dual boot

Dalla sessione live, doppio clic su **"Install Ubuntu"** (o riavvia scegliendo *Install*).
Alimentatore collegato, rete attiva.

### 6.1 Le prime schermate

- Lingua e tastiera: prova la disposizione nel campo di test (italiano ≠ US).
- Connettiti al Wi-Fi.
- Tipo di installazione: **Installazione normale**.
- Spunta **"Scarica aggiornamenti"** e **"Installa software di terze parti"** (driver Wi-Fi/NVIDIA,
  codec). Attivandola ti verrà chiesta una password MOK: vedi §6.4.

### 6.2 Il passaggio critico: il partizionamento

Ti verranno proposte queste opzioni:

| Opzione | Quando usarla |
|---|---|
| **Installa Ubuntu a fianco di Windows Boot Manager** | Caso normale: automatico, usa lo spazio non allocato che hai creato. **È la scelta consigliata.** |
| **Cancella il disco e installa Ubuntu** | ⚠️ **CANCELLA WINDOWS.** Mai, se vuoi il dual boot. |
| **Altro / Qualcosa d'altro (manuale)** | Se vuoi partizioni separate, o se l'automatico non riconosce Windows |

Se scegli **manuale**, schema consigliato su UEFI:

| Punto di mount | Dimensione | Filesystem | Note |
|---|---|---|---|
| `/boot/efi` | la ESP **esistente** (~100–500 MB, FAT32) | — | **Selezionala, NON formattarla**: è condivisa con Windows |
| `/` | tutto lo spazio non allocato (min 40 GB) | ext4 | Se preferisci separare: 60 GB per `/` e il resto su `/home` |
| swap | opzionale | swap | Ubuntu crea da sé un file di swap. Serve una partizione swap **solo** se vuoi ibernare: in quel caso dimensione ≈ RAM |

E soprattutto: **"Dispositivo su cui installare il boot loader"** = il **disco** (`/dev/nvme0n1`,
`/dev/sda`), non una partizione.

Se hai un secondo disco dedicato, puntalo lì e usa comunque la ESP del disco principale (o creane
una nuova da 512 MB FAT32 flag `boot,esp` sul secondo disco, se vuoi i due sistemi indipendenti).

Sulla **crittografia LUKS**: valida per sicurezza, ma complica ridimensionamenti futuri e va
combinata con attenzione a BitLocker. Per un primo dual boot: senza.

### 6.3 Fuso orario, utente, installazione

Fuso orario Europa/Roma, nome utente e password (segnatela), poi *Installa ora* e conferma la
scrittura delle modifiche. 10–30 minuti.

### 6.4 Secure Boot e password MOK

Se hai spuntato "software di terze parti" con Secure Boot attivo, l'installer chiede una
**password Secure Boot / MOK**. Al primo riavvio compare una schermata blu **MOK Management**:

1. *Enroll MOK* → *Continue* → *Yes* → inserisci **quella** password → *Reboot*.

È l'unico momento in cui ti serve. Se la sbagli o salti la schermata, i driver proprietari non si
caricano: si rifà con `sudo mokutil --import /var/lib/shim-signed/mok/MOK.der`.
In alternativa puoi disattivare Secure Boot nel firmware, ma non è necessario.

---

## 7. Primo avvio: GRUB

Al riavvio (chiavetta rimossa) dovresti vedere il menu **GRUB**:

```
Ubuntu
Advanced options for Ubuntu
Windows Boot Manager (on /dev/nvme0n1p1)
UEFI Firmware Settings
```

Le frecce scelgono, Invio conferma, il timeout è ~10 secondi. **Verifica subito che Windows parta.**

### 7.1 GRUB non appare, parte direttamente Windows

Il firmware sta ignorando la voce Ubuntu. Entra nel setup UEFI (§5.1) → *Boot* → metti **ubuntu**
prima di *Windows Boot Manager*. Su molti Lenovo/HP serve anche disattivare *Fast Boot* nel BIOS.

Da Ubuntu (anche live) puoi ispezionare e correggere l'ordine:
```
efibootmgr -v
sudo efibootmgr -o 0002,0001        # imposta l'ordine con gli ID mostrati sopra
```
Se la voce Ubuntu manca del tutto, da live USB installa e lancia **Boot Repair**:
```
sudo add-apt-repository ppa:yannubuntu/boot-repair && sudo apt update
sudo apt install -y boot-repair && boot-repair
```
→ *Riparazione raccomandata*.

### 7.2 GRUB appare ma manca Windows

Da Ubuntu:
```
sudo apt install -y os-prober
sudo os-prober
sudo update-grub
```
Se `os-prober` non trova nulla, controlla che in `/etc/default/grub` non ci sia
`GRUB_DISABLE_OS_PROBER=true` (se c'è, commentala e rilancia `sudo update-grub`).

### 7.3 Windows chiede la chiave BitLocker

Normale se BitLocker era attivo: la modifica della configurazione di boot invalida il sigillo TPM.
Inserisci la chiave di recupero (quella che hai salvato in §2.2), entra in Windows e
**sospendi/riattiva** la protezione per rigenerare il sigillo. Se accade a ogni avvio, disattiva
BitLocker o riattivalo dopo aver stabilizzato l'ordine di boot.

### 7.4 L'orologio di Windows è sbagliato di 1–2 ore

Linux tiene l'orologio hardware in UTC, Windows in ora locale. Sistemalo da Ubuntu:
```
timedatectl set-local-rtc 0 --adjust-system-clock
```
e su Windows, in PowerShell da amministratore:
```
reg add "HKLM\SYSTEM\CurrentControlSet\Control\TimeZoneInformation" /v RealTimeIsUniversal /t REG_DWORD /d 1 /f
```

### 7.5 Schermo nero dopo l'installazione (GPU NVIDIA)

Al menu GRUB premi `e` sulla voce Ubuntu, aggiungi `nomodeset` alla riga che inizia con `linux`,
poi F10 per avviare. Una volta dentro:
```
sudo ubuntu-drivers autoinstall
sudo reboot
```

---

## 8. Post-installazione (30 minuti ben spesi)

```
sudo apt update && sudo apt full-upgrade -y     # aggiornamenti
ubuntu-drivers devices                          # driver proprietari disponibili
sudo ubuntu-drivers autoinstall                 # installali (tipicamente NVIDIA)
sudo apt install -y ubuntu-restricted-extras    # codec audio/video, font Microsoft
sudo apt install -y timeshift                   # snapshot di sistema: configuralo subito
fwupdmgr refresh && fwupdmgr get-updates        # aggiornamenti firmware/BIOS via Linux
sudo apt install -y tlp tlp-rdw                 # gestione energia migliore sui portatili
```

Altre cose sensate:
- **Timeshift**: primo snapshot ora, prima di mettere mano al sistema.
- **Accesso ai file di Windows**: la partizione NTFS si monta dal file manager. Funziona in
  lettura/scrittura **solo se** Fast Startup e ibernazione restano disattivati su Windows (§2.4).
- **Ridurre il timeout di GRUB**: `/etc/default/grub` → `GRUB_TIMEOUT=5` → `sudo update-grub`.
- **Avviare Windows per default**: installa `grub-customizer`, oppure imposta
  `GRUB_DEFAULT="Windows Boot Manager (on /dev/...)"` in `/etc/default/grub` e `sudo update-grub`.
- Non installare aggiornamenti del BIOS da Windows mentre stai a metà del processo: fallo prima o molto dopo.

---

## 9. Problemi comuni e soluzioni

| Sintomo | Causa probabile | Soluzione |
|---|---|---|
| L'installer non vede nessun disco | Controller in Intel RST/RAID | Passa ad AHCI (§2.5) |
| "No bootable device found" dopo l'installazione | Ordine di boot UEFI / voce EFI mancante | §7.1, poi Boot Repair |
| La chiavetta non compare nel menu di boot | Scritta in MBR mentre il PC è UEFI, o Secure Boot con ISO non firmata | Riscrivi con Rufus in GPT/UEFI; prova un'altra porta USB |
| "Unable to find a medium containing a live file system" | ISO corrotta o chiavetta difettosa | Verifica lo SHA256, riscrivi, cambia porta/chiavetta |
| Windows non si avvia più dal GRUB | Voce EFI di Windows persa | Da Windows (supporto di ripristino → Prompt): `bootrec /rebuildbcd`, poi `bcdboot C:\Windows` |
| Wi-Fi assente in live e dopo l'installazione | Firmware proprietario mancante | Collega un cavo ethernet o tethering USB dal telefono, poi `sudo ubuntu-drivers autoinstall` |
| Windows monta la NTFS in sola lettura | Ibernazione/Fast Startup | `powercfg /h off` da Windows (§2.4) |
| Batteria dura molto meno su Ubuntu | GPU ibrida sempre attiva / tuning assente | `tlp`, `powertop --auto-tune`, profilo grafico Intel via `nvidia-settings` |
| Sospensione non si risveglia | Bug firmware/kernel su quel modello | Aggiorna il BIOS, prova un kernel HWE più recente |

Quando cerchi aiuto, il formato che ottiene risposte è: *modello esatto del laptop + versione Ubuntu
+ output di `inxi -Fxz` + testo esatto dell'errore*.

---

## 10. Come tornare indietro (rimuovere Ubuntu)

1. Da Windows, `diskmgmt.msc`: elimina le partizioni Linux (ext4/swap — non hanno lettera di unità)
   e **estendi** `C:` sullo spazio liberato.
2. Rimuovi la voce di boot di Ubuntu, da PowerShell amministratore:
```
bcdedit /enum firmware
```
   oppure, più semplice, dal setup UEFI cancella la voce `ubuntu` e riporta *Windows Boot Manager* al primo posto.
3. Se il PC non parte più: avvia dal supporto di ripristino Windows → *Prompt dei comandi*:
```
bootrec /fixmbr
bootrec /fixboot
bcdboot C:\Windows
```
4. Non toccare la partizione EFI oltre alla cancellazione della cartella `\EFI\ubuntu`.

---

## 11. Sequenza rapida (per chi ha già letto tutto)

```
1.  Backup file + chiave BitLocker + unità di ripristino Windows
2.  msinfo32 (UEFI?) · manage-bde -status (BitLocker) · Gestione dispositivi (RST?)
3.  powercfg /h off · BitLocker sospeso · controller in AHCI
4.  diskmgmt.msc → Riduci volume C: → 80 GB non allocati
5.  Download ISO LTS + certutil -hashfile SHA256 + Rufus (GPT/UEFI)
6.  Boot da USB → "Prova Ubuntu" → checklist hardware (§5.3)
7.  Install Ubuntu → aggiornamenti + software terze parti → "a fianco di Windows"
8.  Riavvio → Enroll MOK (se richiesto) → verifica che GRUB avvii ENTRAMBI i sistemi
9.  apt full-upgrade · ubuntu-drivers autoinstall · restricted-extras · Timeshift
10. Riattiva ciò che avevi disattivato su Windows (file di paging, protezione sistema) — MA lascia Fast Startup OFF
```

---

## Appendice — glossario minimo

- **UEFI**: il firmware moderno che sostituisce il BIOS; gestisce più sistemi operativi tramite voci di boot.
- **ESP / partizione EFI**: piccola partizione FAT32 dove ogni sistema mette il proprio bootloader. **Condivisa**: non formattarla.
- **GPT / MBR**: i due schemi di tabella delle partizioni. GPT va con UEFI, MBR con il BIOS legacy.
- **Secure Boot**: consente l'avvio solo di codice firmato. Ubuntu è firmato, quindi può restare attivo.
- **MOK**: la "chiave del proprietario" che autorizza i moduli kernel non firmati da Canonical (es. driver NVIDIA) con Secure Boot attivo.
- **GRUB**: il menu di avvio di Linux, che elencherà anche Windows.
- **Live USB**: sistema completo avviato da chiavetta, in RAM, senza scrivere sul disco.
- **Swap**: spazio su disco usato come estensione della RAM; necessario come partizione solo per l'ibernazione.
- **LUKS**: la crittografia del disco su Linux (l'equivalente di BitLocker).
