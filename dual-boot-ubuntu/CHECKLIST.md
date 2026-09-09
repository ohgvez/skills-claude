# Checklist dual boot Windows 10 + Ubuntu — da stampare

Guida completa: [GUIDA.md](GUIDA.md)

## Prima di iniziare (su Windows)

- [ ] File personali copiati su disco esterno / cloud
- [ ] Chiave di recupero BitLocker salvata FUORI dal PC (account.microsoft.com/devices/recoverykey)
- [ ] Unità di ripristino Windows creata su una seconda chiavetta
- [ ] `msinfo32` → Modalità BIOS = UEFI ______  Tipo sistema = x64 ______
- [ ] `manage-bde -status` → BitLocker sospeso o disattivato
- [ ] `powercfg /h off` eseguito (ibernazione + Fast Startup OFF)
- [ ] Gestione dispositivi: controller = AHCI (non Intel RST / RAID)
- [ ] Spazio libero su C: almeno 60 GB dopo il restringimento
- [ ] Alimentatore collegato

## Preparazione

- [ ] ISO Ubuntu LTS scaricata da ubuntu.com/download/desktop
- [ ] `certutil -hashfile <iso> SHA256` confrontato con SHA256SUMS
- [ ] Chiavetta ≥ 8 GB scritta con Rufus (schema GPT, target UEFI)
- [ ] `diskmgmt.msc` → Riduci volume C: → ______ GB non allocati

## Trial boot (live USB) — collaudo hardware

- [ ] Avviata la live: "Prova Ubuntu" (NON Install)
- [ ] Wi-Fi   - [ ] Audio altoparlanti   - [ ] Jack cuffie   - [ ] Microfono
- [ ] Webcam  - [ ] Touchpad + gesture   - [ ] Tasti luminosità/volume
- [ ] Bluetooth   - [ ] HDMI/USB-C esterno   - [ ] Porte USB / lettore SD
- [ ] GPU dedicata: nessuno schermo nero
- [ ] Risoluzione e scalatura corrette

## Installazione

- [ ] Alimentatore + rete attivi
- [ ] Spuntato "Scarica aggiornamenti" e "Installa software di terze parti"
- [ ] Password MOK annotata: ______________________
- [ ] Scelto **"Installa Ubuntu a fianco di Windows Boot Manager"**
      (MAI "Cancella il disco e installa Ubuntu")
- [ ] Se manuale: `/boot/efi` = ESP esistente **non formattata**; bootloader sul DISCO, non su una partizione
- [ ] Utente e password annotati

## Dopo il primo riavvio

- [ ] Chiavetta rimossa
- [ ] Schermata MOK → Enroll MOK → password → Reboot (se richiesta)
- [ ] Il menu GRUB compare
- [ ] **Ubuntu si avvia**
- [ ] **Windows si avvia dal menu GRUB**
- [ ] Orologio coerente tra i due sistemi (`timedatectl set-local-rtc 0 --adjust-system-clock`)

## Rifinitura

- [ ] `sudo apt update && sudo apt full-upgrade -y`
- [ ] `sudo ubuntu-drivers autoinstall`
- [ ] `sudo apt install -y ubuntu-restricted-extras timeshift`
- [ ] Primo snapshot Timeshift creato
- [ ] Su Windows: file di paging e protezione sistema riattivati
- [ ] Su Windows: Fast Startup lasciato **disattivato** (definitivo)
