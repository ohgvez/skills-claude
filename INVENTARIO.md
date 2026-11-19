# INVENTARIO — tutto quello che ho installato/scaricato per Claude

Second brain unico. Ogni volta che si scarica qualcosa (skill, plugin, MCP, repo, tool, app) si aggiunge una riga qui **e** nel [Registro](#registro-cronologico) in fondo.
Ultimo aggiornamento: 2026-11-19

Legenda stato: ✅ funziona · ⚠️ installato ma da completare · ❌ rotto/non connesso

**Due PC, un solo inventario.** Dove non è scritto altro, percorsi e installazioni sono del **PC Federico** (`C:\Users\Federico`). Le righe con **(PC MSI)** riguardano il portatile MSI GE65 (`C:\Users\Trevor Ohhvez`). Su entrambi il repo sta in `Desktop\PROGETTI AI\skills-claude`; prima di aggiornare fare sempre `git pull`.

---

## 1. Server MCP (strumenti che Claude usa per comandare app)

Config in `C:\Users\Federico\.claude.json` → `mcpServers`. (PC MSI): nessun MCP registrato in Claude Code (al 2026-11-01).

**Avvio intelligente (dal 2026-10-11):** gli MCP delle app (Blender, After Effects, FL, Premiere, Photoshop, Houdini) passano da `C:\Users\Federico\.claude\mcp-gate\gate.js`: partono **solo se il programma è già aperto**, altrimenti escono in ~1s. Quindi: prima apri il programma, poi avvia/riavvia Claude. Backup config prima della modifica: `.claude.json.before-gate.bak`. REA invece parte sempre.

| Nome | Cosa fa | Dove sta | Fonte | Stato |
|---|---|---|---|---|
| blender-mcp | Comanda Blender | `uvx blender-mcp` + addon in `Desktop\blender-mcp-addon` | ahujasid/blender-mcp | ⚠️ si connette solo con Blender aperto |
| AfterEffectsMCP | Comanda After Effects | `C:\Users\Federico\after-effects-mcp` | github.com/Dakkshin/after-effects-mcp | ⚠️ serve AE aperto |
| fl-studio-mcp | Comanda FL Studio | `C:\Users\Federico\fl-studio-mcp` | github.com/calvinw/fl-studio-mcp | ⚠️ serve FL aperto |
| premiere-pro | Comanda Premiere | `C:\Users\Federico\premiere-pro-mcp` | github.com/leancoderkavy/premiere-pro-mcp | ⚠️ serve Premiere aperto |
| photoshop | Comanda Photoshop | npx `@alisaitteke/photoshop-mcp` | npm | ⚠️ serve PS aperto |
| houdini | Comanda Houdini | `Desktop\houdini-mcp` | github.com/capoomgit/houdini-mcp | ⚠️ serve Houdini aperto |
| graphify-mcp | Knowledge graph del codice (opzionale) | `uv tool` graphifyy | github.com/safishamsi/graphify | ⚠️ disponibile, non registrato |
| vocaloid6-mcp | Comanda Vocaloid 6 | `Desktop\vocaloid6-mcp` | github.com/nigexiaolaji/vocaloid6-mcp | ⚠️ clonato, NON registrato |
| **REA** (rea-agents) | Reverse engineering di app/exe/siti | `Desktop\rea` (+ npm globale v6.4.0) | github.com/morluto/rea | ✅ registrato in Claude Code con Ghidra 12.1.4 + JDK 21 → analizza anche .exe/.dll |
| earshot | Fa ascoltare/analizzare/generare suoni a Claude (16 tool) | `PROGETTI AI\earshot` | github.com/Leonxlnx/earshot | ✅ registrato (user scope), EARSHOT_THREADS=2 |
| misterdownloadmanager | Gestisce i download di Mister Download Manager: list_downloads, add_download, pause/resume/remove_downloads, start_queue | `%LOCALAPPDATA%\Programs\Mister Download Manager\misterdownloadmanager-mcp.exe` (nessun argomento) | github.com/anefzaoui/misterdownloadmanager | ✅ registrato 2026-11-19 (user scope, senza gate, backup `.claude.json.bak-mdm`); API di automazione accesa con `misterdownloadmanager-cli api on` (solo locale); per elencare/mettere in pausa serve MDM aperto. Testato: 6 tool, list_downloads ok |
| scrapling | Scraping web: make_request (HTTP con impronta browser), browser_fetch_once / browser_open + browser_fetch (browser stealth, JavaScript, Cloudflare), browser_actions/extract/screenshot/evaluate, cronologia rete, salvataggio login. 17 tool | `Desktop\PROGETTI AI\Scrapling\.venv\Scripts\scrapling-mcp.exe` (env PYTHONUTF8=1, PLAYWRIGHT_BROWSERS_PATH=`...\Scrapling\.browsers`) | github.com/D4Vinci/Scrapling | ✅ registrato 2026-11-19 (user scope, senza gate, backup `.claude.json.bak-scrapling`). Testato via stdio: 17 tool, make_request ok; 17 tool, make_request ok, browser_fetch_once ok (pagina JavaScript letta) |

**REA — come è stato installato** (PowerShell blocca `npm`, usare `npm.cmd`):
```
npm.cmd i -g rea-agents
rea.cmd setup --client claude_code --yes
```
Backup config: `.claude.json.rea.backup`. Ghidra in `C:\Users\Federico\ghidra\ghidra_12.1.4_PUBLIC`, Java `C:\Program Files\Eclipse Adoptium\jdk-21.0.12.101-hotspot`: per ricollegarli rilanciare `rea.cmd setup --client claude_code --yes` con `$env:GHIDRA_INSTALL_DIR` e `$env:JAVA_HOME` impostati.

## 2. Plugin di Claude Code

| Nome | Cosa fa | Stato |
|---|---|---|
| pdf-viewer | Apri/annota/firma/compila PDF | ✅ |
| design (Anthropic) | critique, handoff, design-system, ux-copy, accessibilità, user research | ✅ (connettori Figma/Notion/Slack… non autorizzati) |
| pixelbin | Generazione/editing immagini | ✅ |
| watermarks-remover 0.5.0 (guillaumemeyer/watermarks-remover) | remove-ai-marks, clean-user-facing-text come plugin | ✅ (PC MSI), installato 2026-08-30 |
| agent-skills 0.6.15 (addyosmani/agent-skills, MIT) | 25 skill di ingegneria (spec → plan → build → test → review → ship: TDD, debugging, sicurezza, performance, API, ADR, git, CI/CD…) + 9 comandi `/spec` `/plan` `/build` `/test` `/review` `/ship` `/code-simplify` `/constraints` `/webperf` (se il nome è già preso: `/agent-skills:review`) + 4 agenti (code-reviewer, security-auditor, test-engineer, web-performance-auditor). Nessun hook attivo (quelli in `hooks/` sono opzionali, da collegare a mano) | ✅ (PC MSI). Installazione: `claude plugin marketplace add https://github.com/addyosmani/agent-skills.git` poi `claude plugin install agent-skills@addy-agent-skills`; senza chiavi SSH serve forzare HTTPS (`url.https://github.com/.insteadOf git@github.com:`). Skill non copiate nel repo: è un plugin, si aggiorna da sé |

## 3. Skill (`C:\Users\Federico\.claude\skills`, (PC MSI) `C:\Users\Trevor Ohhvez\.claude\skills`, backup in questo repo)

Le cartelle del repo senza `SKILL.md` in cima (Amagine3D, Ear, NodeGraphQt, blender-mcp, book-to-skill, emilkowalski-skills, pixelbin-media-generation, rea, react-bits, txqr, yt-dlp) sono repo di riferimento, non skill: non vanno copiate in `.claude\skills`.

| Data | Gruppo | Fonte | Skill |
|---|---|---|---|
| 2026-08-14 | Marketing + SEO + Three.js (backup iniziale) | vari (fonte non registrata) | ab-testing, ad-creative, ads, ai-seo, analytics, aso, attribution, book-to-skill, churn-prevention, co-marketing, cold-email, community-marketing, competitor-profiling, competitors, content-strategy, copy-editing, copywriting, cro, customer-research, directory-submissions, emails, find-skills, framer, framer-code-components, free-tools, image, influencer-marketing, launch, lead-magnets, marketing-council, marketing-ideas, marketing-loops, marketing-plan, marketing-psychology, offers, onboarding, paywalls, popups, pricing, product-marketing, programmatic-seo, prospecting, public-relations, referrals, revops, sales-enablement, schema, seo + 30 seo-*, signup, site-architecture, sms, social, threejs-* (10), video |
| 2026-08-16 | UI/UX | ui-ux-pro-max | ui-ux-pro-max, design, design-system, brand, banner-design, ui-styling, slides |
| 2026-08-17 | Taste | taste-skill | brandkit, brutalist-skill, gpt-tasteskill, image-to-code-skill, imagegen-frontend-mobile/web, minimalist-skill, output-skill, redesign-skill, soft-skill, stitch-skill, taste-skill |
| 2026-08-17 | Cline skills (37) | github.com/cline/skills | amazon-location-service, amplify-workflow, attorney-assist, building-pydantic-ai-agents, cline-session-search, convex-design, cosmosdb-best-practices, data-analyst, dataproc-skills, desktop-commander-overview, dr-bedrock, dsql, endor-setup, exa-search, firestore-data, frontend-design, gcp-to-aws, knowledge-catalog-discovery, linear-sdk-scripting, math-olympiad, mintlify, oracledb, playground, review-team, sap-fiori-add-visual-filter, save-to-spotify, searching-sourcegraph, sentry-cli, session-report, site-specification, skill-creator, spanner-data, teamcity-cli, ui5-typescript-conversion, use-railway, vibe-prospecting, windsor-ai-business-data |
| 2026-08-17 | GSAP | GreenSock | gsap-core, -frameworks, -performance, -plugins, -react, -scrolltrigger, -timeline, -utils |
| 2026-08-17 | Singole | — | agent-reach (+ repo `Desktop\agent-reach`), design-dna, motion-design (LottieFiles) |
| 2026-08-20 | Matt Pocock (33) | github.com/mattpocock/skills | ask-matt, claude-handoff, code-review, codebase-design, diagnosing-bugs, domain-modeling, git-guardrails-claude-code, grill-me, grill-with-docs, grilling, handoff, implement, improve-codebase-architecture, loop-me, migrate-to-shoehorn, prototype, research, resolving-merge-conflicts, scaffold-exercises, setup-matt-pocock-skills, setup-pre-commit, setup-ts-deep-modules, tdd, teach, to-questionnaire, to-spec, to-tickets, triage, wait-what, wayfinder, wizard, writing-beats/-for-agents/-fragments/-shape |
| 2026-08-24 | Testo | guillaumemeyer/watermarks-remover | remove-ai-marks, clean-user-facing-text |
| 2026-08-24 | Personali | — | i-have-adhd, marcapresenze-svar3finger |
| 2026-08-25 | Repo di riferimento | — | NodeGraphQt (Python/Qt node graph), txqr (dati via QR animati) |
| 2026-08-27 | Design/animazione | emilkowalski/skills, react-bits | emilkowalski-skills, react-bits |
| 2026-08-27 | Video tool | yt-dlp, video-use | yt-dlp, video-use |
| 2026-08-31 | CAD | Amagine3D | Amagine3D |
| 2026-09-03 | Scrittura | petergyang | no-ai-slop |
| 2026-09-04 | Immagini/media | Anthropic + vari | anydesign, canvas-design, image-enhancer, theme-factory, pixelbin-media-generation, Ear, blender-mcp, imagen, video-downloader, youtube-transcript |
| 2026-09-09 | Remotion (12) | remotion-dev/claude-code-plugin | remotion-best-practices, -captions, -create, -docs, -interactivity, -maps, -markup, -multimedia, -render, -saas, -studio, -upgrade |
| 2026-09-14 | ffmpeg | — | claude-ffmpeg-skill |
| 2026-09-17 | Musica | — | suno-metatags (aggiunta dall'altro PC) ✅ |
| 2026-09-28 | Animazione/UI + altro | vari (altro PC) | animate, animate-expo, animation-vocabulary, apple-design, ask-sonner, emil-design-eng, find-animation-opportunities, improve-animations, pick-ui-library, review-animations, write-swift, houdini-foundations ✅ copiate anche sul laptop (2026-10-11) |
| 2026-10-11 | Knowledge graph / meno token | github.com/safishamsi/graphify (pip `graphifyy`, via `uv tool install`) | graphify ✅ — uso: `/graphify .` dentro un progetto; ha creato `C:\Users\Federico\.claude\CLAUDE.md` |
| 2026-10-11 | Reverse engineering | morluto/rea | reverse-engineer-anything ✅ (installata da `rea setup`) |
| 2026-10-24 | Codice minimo (6) | github.com/DietrichGebert/ponytail (MIT, v5.3.2) | ponytail, ponytail-audit, ponytail-debt, ponytail-gain, ponytail-help, ponytail-review ✅ — uso: `/ponytail` (lite/full/ultra), `/ponytail-review`, `/ponytail-audit` |
| 2026-10-11 | Clonare app (11) | github.com/Jakeschincariol/replica-skill (MIT, repo in `Desktop\replica-skill`) | replica-recon → architect → design → build → backend → test → diff → entrepreneur → brand → launch → deploy ✅ (da usare in ordine, scrivono in `replica/` nel progetto) |
| 2026-11-01 | VST (PC MSI) | personale | canvas-vst-reference ✅: specifica di Art DSP Canvas 1.0 + checklist di fedeltà per il clone JUCE Canvas3D (`Desktop\canvas3d`) |
| 2026-11-18 | CLI per agenti (3) | github.com/HKUDS/CLI-Anything (Apache-2.0) | cli-anything ✅ (wrapper locale del plugin: legge `PROGETTI AI\CLI-Anything\cli-anything-plugin`, uso `/cli-anything <sorgente o repo>`, anche refine/test/validate/list), cli-hub-meta-skill ✅ (trova e installa CLI pronte con `cli-hub`), cli-anything-blender ✅ (scene Blender da riga di comando), cli-anything-audacity ✅ (editing audio a progetto JSON, export solo WAV). Note locali in cima a ogni SKILL.md; comandi di avvio (shim) di backup in `cli-hub-meta-skill\shims` |
| 2026-11-18 | Computer use (2) | github.com/vercel-labs/agent-desktop (Apache-2.0) | agent-desktop ✅ (loop snapshot → azione → verifica con nota locale sui test), agent-desktop-windows ✅ (differenze Windows: apici in PowerShell, `--headed`, UIPI, Electron) |
| 2026-11-19 | Scraping (1) | github.com/D4Vinci/Scrapling (BSD-3-Clause), cartella `agent-skill\Scrapling-Skill` | scrapling-official ✅ (CLI `scrapling extract`, fetcher, spider, parsing adattivo; nota locale: percorso del venv, PYTHONUTF8, preferire l'MCP) |

## 4. Repo clonati / progetti

| Cartella | Cosa | Remote |
|---|---|---|
| `Desktop\PROGETTI AI\skills-claude` | **Questo repo**: backup skill + inventario (spostato in PROGETTI AI) | github.com/ohgvez/skills-claude |
| `Desktop\PROGETTI AI\FireStick-backup` | Backup pacchetti Fire TV Stick + registro modifiche + APK (Projectivy, SmartTube) | — |
| `Desktop\PROGETTI AI\FireStick-launcher` | Launcher stile Apple TV per Fire Stick: `cleanyourtv` + `firetv-tvos` (in costruzione) | Gathin23/cleanyourtv, NikhilSiddhu/firetv-tvos |
| `Desktop\flight-tracker` | Tracker voli Google Flights + ntfy (privato) | github.com/ohgvez/flight-tracker |
| `Desktop\vst\*` | Plugin VST miei: BlendForge, ChoirForge, ChopForge, FourCount, GeekForge, ilgranello, Lumitone, Machicut, MorseGate, RigForge, VocoForge, VoxForge | — |
| `Desktop\JUCE` | Framework per i VST | juce-framework/JUCE |
| `Desktop\depth-relief` | Video → rilievo 3D per ohhvez.it | — |
| `Desktop\giovani_soldi` | Video testo cromato in Houdini/Karma | — |
| `Desktop\MioMod` | Mod Minecraft Fabric | FabricMC/fabric-example-mod |
| `Desktop\agent-reach` | Ricerca su social/web | Panniantong/agent-reach |
| `Desktop\rea` | REA reverse engineering (sottomodulo unblob non scaricabile su Windows, non serve) | morluto/rea |
| `Desktop\PROGETTI AI\freellmapi` | FreeLLMAPI: unisce i free tier di 34 provider LLM (Groq, Gemini, Cerebras, OpenRouter…) dietro un unico endpoint `/v1` OpenAI/Anthropic-compatibile, con failover automatico. Funziona con Claude Code, Cursor, Cline ecc. ✅ Installato e avviato (build Node, dashboard http://localhost:3001; avvio: `AVVIA.bat` nella cartella; `.env` con ENCRYPTION_KEY — NON perderla). Mancano account dashboard + chiavi provider | tashfeenahmed/freellmapi (MIT) |
| `Desktop\PROGETTI AI\voicestudio` | VoiceStudio: alternativa locale a ElevenLabs — voice cloning, voice design, doppiaggio video, dettatura, trascrizione, audiolibri (646 lingue), ha anche API locale + MCP. ✅ App v0.5.7 installata (`%LOCALAPPDATA%\Programs\VoiceStudio`, icona sul Desktop); repo = solo codice sorgente. Su CPU usare il preset leggero (KittenTTS/Supertonic/PocketTTS + Whisper piccolo) | debpalash/voicestudio (AGPL-3.0) |
| `Desktop\PROGETTI AI\earshot` | earshot: "orecchie" per agenti AI — descrive/valuta suoni, trova momenti in registrazioni lunghe, sync audio-video, critica launch video, genera SFX in codice (forge, banca 252 suoni). CLI + Python + server MCP, solo CPU. ✅ Installato (venv `.venv` Python 3.13, torch CPU, modelli CLAP+AST 1,1 GB in `.cache`) e registrato come MCP `earshot` | Leonxlnx/earshot (MIT) |
| `Desktop\PROGETTI AI\RobustVideoMatting` | RVM: scontorna persone nei video (green screen / alpha), veloce anche su CPU. Clonato + modello leggero `rvm_mobilenetv3.pth` (15 MB); ✅ pronto: venv `.venv` (torch 2.15 CPU, av 19), **trascina un video su `GREENSCREEN.bat`** → cartella `<nome>_greenscreen` con `_green.mp4` (audio originale) + `_alpha.mp4` (maschera); `--png` = sequenza trasparente, `--hq` = resnet50. Patch PyAV 19 in `inference_utils.py`. Velocità ~30 s per 1 s di video a 960x540 su questo portatile | PeterL1n/RobustVideoMatting (GPL-3.0) |
| `Desktop\PROGETTI AI\open-seo` | OpenSEO: alternativa open source a Semrush/Ahrefs (keyword research, rank tracking, competitor, backlink, site audit, visibilità AI) con server MCP + skill per Claude. Solo clonato (57 MB); per usarlo serve Docker o Cloudflare + chiave DataForSEO a consumo | every-app/open-seo (MIT) |
| `Desktop\PROGETTI AI\agent-skills` | (PC MSI) Sorgente del plugin agent-skills di Addy Osmani (1,4 MB), clonato per controllarlo prima di installarlo; il plugin vero sta in `.claude\plugins\cache\addy-agent-skills` | addyosmani/agent-skills (MIT) |
| `Desktop\PROGETTI AI\ai-job-search` | AI Job Search: framework per cercare lavoro con Claude Code — comandi /setup (profilo), /scrape (annunci), /rank, /apply (CV + lettera su misura), /interview, /outcome. Si apre la cartella in Claude Code e si lancia /setup. Solo clonato (6 MB) | ai-job-search-dev/ai-job-search (MIT) |
| `Desktop\PROGETTI AI\agent-desktop` | agent-desktop (Vercel Labs): "computer use" per agenti **senza screenshot** — legge l'albero di accessibilità delle app desktop (su Windows UI Automation) e lo restituisce come JSON con un ref per ogni elemento; l'agente clicca/scrive sui ref e rilegge per verificare. CLI (61 comandi: snapshot, click, type, launch, finestre, clipboard, notifiche…) + libreria C + server MCP (`agent-desktop mcp`) + skill. Repo = sorgente Rust (111 MB). ✅ **Installato 1.3.1** (2026-11-18) con `npm.cmd i -g agent-desktop` → comando `agent-desktop` (npm ha bloccato lo script post-installazione, ma il binario Windows è già nel pacchetto e l'hash corrisponde). Testato sul Blocco note: lettura ok (`status`, `launch`, `snapshot`, `list-windows`, `get`); scrittura NON affidabile (`set-value` rifiutato, `--headed type` dice "verificato" ma il testo non compariva) → `--headed` manda tasti veri alla finestra in primo piano, controllare sempre con `screenshot`. In PowerShell i ref vanno tra apici (`'@s8f3k2p9:e8'`). Skill `agent-desktop` + `agent-desktop-windows` installate. MCP non registrato | vercel-labs/agent-desktop (Apache-2.0) |
| `Desktop\PROGETTI AI\CLI-Anything` | CLI-Anything (HKUDS): rende qualsiasi programma usabile dagli agenti AI tramite una CLI (output JSON, `--help`). ~70 CLI già pronte (Blender, Audacity, GIMP, Krita, Kdenlive, Shotcut, OBS, MuseScore, ComfyUI, Rekordbox, LibreOffice, draw.io, Obsidian, Ollama, FreeCAD, Godot…), ognuna con la sua skill in `skills/`, + generatore in 7 fasi per crearne di nuove. ✅ Installato (2026-11-18): **CLI-Hub 0.4.1** nel venv `.venv` della cartella (Python 3.13), comando `cli-hub` funziona da bash e PowerShell (shim in `C:\Users\Federico\.local\bin`, statistiche d'uso disattivate con `CLI_HUB_NO_ANALYTICS=1`, `PYTHONUTF8=1` obbligatorio su Windows). Uso: `cli-hub list` / `cli-hub search <parola>` / `cli-hub install <nome>`; i CLI installati finiscono in `.venv\Scripts` (non nel PATH: usare `cli-hub launch <nome>` o creare uno shim). Installato e testato **cli-anything-blender 1.0.0** (render di prova WORKBENCH ok con Blender 5.2; `render execute` scrive solo lo script, poi va lanciato `blender.exe --background --python <script>`). Installato e testato anche **cli-anything-audacity 1.0.0**: NON comanda Audacity 4, è un editor audio in Python (tracce, clip, 16 effetti: fade, echo, compress, pitch, tempo, noise_reduction…); sox non serve; l'export è **sempre WAV** anche con `-p mp3` (limite del codice originale) → convertire con ffmpeg. **Obsidian**: il CLI ufficiale è già dentro Obsidian 1.14.5 (`C:\Program Files\Obsidian\Obsidian.com`), va solo attivato in Obsidian → Impostazioni → Generale → Command line interface. Per gli altri tuoi programmi (FL, Studio One, Adobe, Houdini, Synth V, Vocaloid) CLI-Hub non ha niente: restano gli MCP. Plugin Claude Code non installato come plugin (niente comando `claude` nel PATH): sostituito dalla skill `cli-anything` | HKUDS/CLI-Anything (Apache-2.0) |
| `Desktop\PROGETTI AI\Scrapegraph-ai` | ScrapeGraphAI 2.3.1: libreria Python che estrae dati da siti e documenti (HTML, JSON, XML, CSV, Markdown) **descrivendo a parole cosa vuoi** — un LLM legge la pagina e restituisce JSON. Tanti tipi di pipeline: SmartScraper (una pagina), Multi (più pagine), Search (cerca sul web e estrae), Depth (segue i link), Markdownify, Screenshot, CodeGenerator (scrive lo scraper in Python). Solo clonato (9,6 MB). Per usarlo: venv Python 3.12+ → `pip install scrapegraphai` + `playwright install chromium`; serve un LLM: chiave API (OpenAI, Groq, Mistral…), Ollama in locale (pesante per questo portatile) oppure il router **freellmapi** già installato (endpoint OpenAI-compatibile su :3001, mancano le chiavi provider). Il loro MCP/SDK/CLI (`scrapegraph-mcp`, `just-scrape`) usano invece l'API a pagamento scrapegraphai.com | ScrapeGraphAI/Scrapegraph-ai (MIT) |
| `Desktop\PROGETTI AI\ClaudeAnimationBase` | Claude Animation Base (John Heibel): kit per far animare a Claude un personaggio (Clawd) in stile disegnato a mano con p5.js + p5.brush → video MP4. Si apre la cartella in Claude Code e si chiede es. "Leggi ANIMATION_GUIDE.md e fai un video di 15 secondi di Clawd che …": Claude fa lo storyboard, costruisce le scene, controlla i fotogrammi e scrive `out/video.mp4`. Emozioni, viste, cappelli, balli, transizioni a pennellata. Solo clonato (16 MB). Serve Node + Chrome + ffmpeg (ci sono): `npm install` poi `node render.mjs --clip --out=out/video.mp4`; `studio.html` in Chrome per scorrere. Le campiture ad acquerello sono lente senza GPU dedicata | JohnHeibel/ClaudeAnimationBase (MIT) |
| `Desktop\PROGETTI AI\SCSKiller` | SCSKiller (Shader Compilation Stutter Killer): compila in anticipo gli shader dei giochi nella cache del driver GPU, così il gioco non si blocca a compilarli mentre giochi (scatti da 20 ms fino a 2 s). Trova da solo i giochi di Steam, Epic, EA, GOG, Ubisoft, Xbox, Battle.net, Riot…; DirectX 12 su NVIDIA/AMD, DirectX 11 solo su NVIDIA; ricompila dopo gli aggiornamenti del driver. "Recorder" opzionale: mette una DLL proxy nella cartella del gioco per registrare gli shader mentre giochi (con giochi con anti-cheat è disattivato di default, rischio ban se lo attivi). Solo clonato (19 MB, sorgente C#/C++). Utile sul PC con la 4080, non su questo (GeForce 920MX). Installazione: solo da Releases ufficiali (`SCSKiller-Setup.exe`, per utente, niente admin; non firmato → confrontare lo SHA-256 nelle note di rilascio). Ultima versione v1.4.8 (2026-11-15) | BlueHeisenberg/SCSKiller (GPL-3.0) |
| `Desktop\PROGETTI AI\Scrapling` | Scrapling 0.5.1: framework Python per lo scraping, dal singolo URL al crawl di un sito intero. Richieste HTTP veloci, browser "stealth" per siti con JavaScript/anti-bot (anche Cloudflare), selettori CSS/XPath che si adattano se il sito cambia, spider con proxy/riprova/pausa-ripresa, export JSON/CSV/XML, pagine → Markdown pulito. **Non serve un LLM** (a differenza di ScrapeGraphAI). Ha un server MCP per Claude, una Agent Skill (`agent-skill\Scrapling-Skill`), comandi da terminale e una shell interattiva. Repo = sorgente (17 MB). ✅ **Installato 0.5.1** (2026-11-19) da PyPI in `Scrapling\.venv` (Python 3.13) con `scrapling[all]`; browser (Chromium Playwright + Chromium patchright, 1,5 GB; venv 379 MB) in `Scrapling\.browsers` con `PLAYWRIGHT_BROWSERS_PATH` (in `%LOCALAPPDATA%` dall'app Claude finivano nella cache virtuale e Chrome non partiva). Comando `scrapling` = shim in `~\.local\bin` (sh + .cmd, copie in `scrapling-official\shims`). MCP `scrapling` registrato, skill `scrapling-official` installata. Non lanciare Python dentro la cartella del repo (importerebbe il sorgente) | D4Vinci/Scrapling (BSD-3-Clause) |
| `Desktop\PROGETTI AI\console-skill` | The Console skill (Jake Schincariol) v1.0: 11 skill per portare su PC giochi PS2 che possiedi, tramite PS2Recomp (ricompila il codice MIPS in C++ nativo, non è un emulatore): console-reverse (analizza ISO/ELF, guida tutto il port), -backend (syscall, I/O, IOP), -graphics (texture, widescreen), -controller, -mod (modifiche descritte a parole → codice), -levels, -sound, -physics, -saves (memory card), -anywhere (Windows/Mac/Linux/Steam Deck/Android/Vita), -tester. Strumenti Python puri, niente pip. Serve: disco PS2 tuo + lettore DVD, PS2Recomp compilato (CMake + C++20), Ghidra + estensione EmotionEngine Reloaded; opzionali PCSX2, GhydraMCP, PCSX2-MCP. Lavoro di settimane per gioco. Solo clonato (2 MB), skill non installate | Jakeschincariol/console-skill (MIT) |
| `Desktop\PROGETTI AI\claude-video` | Watch 0.3.2 (Bradley Bonanno): skill `/watch` per far "vedere" un video a Claude (URL YouTube/Vimeo/TikTok… o file locale). Motore locale: yt-dlp scarica, ffmpeg estrae fotogrammi con timestamp, trascrizione dai sottotitoli o, se mancano, WhisperX locale / Groq / OpenAI. Motore Gemini (chiave gratuita): il video viene mandato a Google che lo guarda tutto, audio compreso. Plugin Claude Code con hook SessionStart (controllo setup). Qui c'è ffmpeg; mancano yt-dlp e Deno (`winget install yt-dlp.yt-dlp`, `DenoLand.Deno`). Solo clonato (0,9 MB), non installato | bradautomates/claude-video (MIT) |

## 5. App / software installati rilevanti

Ghidra 12.1.4 (`C:\Users\Federico\ghidra`, decompilatore NSA, usato da REA), JDK 21 + 25 (Temurin), uv/uvx.

Android: platform-tools/adb 37.0.1 (winget `Google.PlatformTools`), cmdline-tools in `%LOCALAPPDATA%\Android\Sdk` (per compilare APK).

Fire TV Stick (AFTSSS, 192.168.1.164): Projectivy Launcher 4.72 (github.com/spocky/miproja1), SmartTube 32.68 (github.com/yuliskov/SmartTube) — YouTube senza pubblicità. 53 pacchetti Amazon disattivati (lista CleanYourTV).

After Effects 2026, Photoshop 2026, Premiere Pro 2026, FL Studio 2026, Blender 5.2, Houdini FX 20.0, Studio One 6 Pro, Synthesizer V Studio, Vocaloid 6, iZotope Nectar 4 / Neutron 5, Audacity 4.

pluginval 1.0.4 (github.com/Tracktion/pluginval, release ufficiale, zip SHA256 C08E61CE…15AB, exe non firmato): validatore standard dei plugin VST3, in `PROGETTI AI\tools\pluginval-1.0.4\bin\pluginval.exe` — usato per testare SeedForge.

Mister Download Manager 0.5.2 (github.com/anefzaoui/misterdownloadmanager, GPL-3.0, winget `AhmedNefzaoui.MisterDownloadManager`): download manager gratis tipo IDM (fino a 32 connessioni, ripresa, video da 1000+ siti, torrent, scheduler, estrazione archivi). In `%LOCALAPPDATA%\Programs\Mister Download Manager`, installato il 2026-11-19 alle 00:16; eseguibili NON firmati ma identici a quelli dello zip ufficiale v0.5.2 (SHA-256 verificati). Contiene anche `misterdownloadmanager-cli.exe` e `misterdownloadmanager-mcp.exe` (server MCP per far gestire i download a Claude: registrato, vedi sezione 1). Estensione browser da aggiungere a mano: Chrome Web Store / Firefox Add-ons. Aggiornamenti: dall'app o `winget upgrade AhmedNefzaoui.MisterDownloadManager`.

Wii homebrew in `Desktop\WII` (chiavetta SanDisk 64GB): USB Loader GX v4.0-r1283, d2x cIOS v11-beta3, Nintendont, wit 3.05a, fat32format 1.07.

---

## Registro cronologico

Una riga per ogni cosa scaricata. Più recente in alto.

- 2026-11-19 — **claude-video / Watch 0.3.2** (github.com/bradautomates/claude-video, MIT): skill /watch per guardare video (fotogrammi + trascrizione), clonato in `PROGETTI AI\claude-video` (0,9 MB), non installato
- 2026-11-19 — **console-skill 1.0** (github.com/Jakeschincariol/console-skill, MIT): 11 skill per portare giochi PS2 su PC con PS2Recomp, clonato in `PROGETTI AI\console-skill` (2 MB), non installato
- 2026-11-19 — **Scrapling 0.5.1 installato** (PyPI, venv `PROGETTI AI\Scrapling\.venv`) + Chromium Playwright + MCP `scrapling` registrato (backup `.claude.json.bak-scrapling`) + skill `scrapling-official`; MCP testato: 17 tool, make_request ok, browser_fetch_once ok (pagina JavaScript letta)
- 2026-11-19 — **Scrapling** (github.com/D4Vinci/Scrapling, BSD-3-Clause): framework di scraping con MCP + skill, clonato in `PROGETTI AI\Scrapling` (17 MB), non installato
- 2026-11-19 — **MCP misterdownloadmanager** registrato in `~\.claude.json` (backup `.claude.json.bak-mdm`) + API di automazione di MDM accesa; testato via stdio
- 2026-11-19 — **Mister Download Manager 0.5.2** (github.com/anefzaoui/misterdownloadmanager, GPL-3.0): già installato quando è partito winget (nessun aggiornamento disponibile); eseguibili confrontati con lo zip ufficiale: identici
- 2026-11-19 — **SCSKiller** (github.com/BlueHeisenberg/SCSKiller, GPL-3.0): precompila gli shader dei giochi contro gli scatti, clonato in `PROGETTI AI\SCSKiller` (19 MB), non installato
- 2026-11-18 — **ClaudeAnimationBase** (github.com/JohnHeibel/ClaudeAnimationBase, MIT): kit animazione p5.js/p5.brush per Claude, clonato in `PROGETTI AI\ClaudeAnimationBase` (16 MB), `npm install` non fatto
- 2026-11-18 — **agent-desktop 1.3.1 installato** (npm globale, binario verificato) + skill `agent-desktop`, `agent-desktop-windows`; test sul Blocco note: lettura ok, scrittura non affidabile
- 2026-11-18 — **ScrapeGraphAI** (github.com/ScrapeGraphAI/Scrapegraph-ai, MIT): scraping con LLM a prompt, clonato in `PROGETTI AI\Scrapegraph-ai` (9,6 MB), non installato
- 2026-11-18 — **cli-anything-audacity** 1.0.0 (PyPI, via `cli-hub install audacity`): testato (WAV con effetti ok, MP3 = WAV rinominato), shim in `~\.local\bin` + skill `cli-anything-audacity`; CLI Obsidian ufficiale da attivare nelle impostazioni dell'app
- 2026-11-18 — **CLI-Anything installato**: `cli-anything-hub` 0.4.1 (PyPI) in `PROGETTI AI\CLI-Anything\.venv` + shim `cli-hub`/`cli-anything-blender` in `~\.local\bin`; **cli-anything-blender** 1.0.0 (PyPI, via `cli-hub install blender`) testato con render; skill `cli-anything`, `cli-hub-meta-skill`, `cli-anything-blender` in `.claude\skills` + backup qui
- 2026-11-18 — **CLI-Anything** (github.com/HKUDS/CLI-Anything, Apache-2.0): CLI per agenti su ~70 programmi + generatore di nuove CLI, clonato in `PROGETTI AI\CLI-Anything` (95 MB), non installato
- 2026-11-18 — **agent-desktop** (github.com/vercel-labs/agent-desktop, Apache-2.0): computer use tramite albero di accessibilità (CLI + MCP), clonato in `PROGETTI AI\agent-desktop` (111 MB), non installato
- 2026-11-01 — (PC MSI) **agent-skills 0.6.15** (github.com/addyosmani/agent-skills, MIT): plugin Claude Code con 25 skill + 9 comandi + 4 agenti per tutto il ciclo di sviluppo; hook non collegati; sorgente clonato in `PROGETTI AI\agent-skills`
- 2026-11-01 — (PC MSI) collegato all'inventario: repo clonato in `Desktop\PROGETTI AI\skills-claude`, regola in `~\.claude\CLAUDE.md` per aggiornare inventario + commit a ogni installazione
- 2026-11-01 — (PC MSI) installate dal repo le 151 skill mancanti (ponytail, replica, remotion, gsap, mattpocock, cline…) → 252 skill in `C:\Users\Trevor Ohhvez\.claude\skills`
- 2026-11-01 — (PC MSI) aggiunta al repo **canvas-vst-reference**, che esisteva solo sul portatile
- 2026-10-31 — **pluginval 1.0.4** (github.com/Tracktion/pluginval, GPL-3.0): zip ufficiale 2.4 MB, SHA256 C08E61CE3B96DB41636F8EC7E76F4C7E2C13EBDAC7FA1B5A1F52B4F32EC715AB, in `PROGETTI AI\tools\pluginval-1.0.4` — test di SeedForge
- 2026-10-31 — **ai-job-search** (github.com/ai-job-search-dev/ai-job-search, MIT): job search con Claude Code, clonato in `PROGETTI AI\ai-job-search`
- 2026-10-31 — **open-seo** (github.com/every-app/open-seo, MIT): tool SEO + MCP, clonato in `PROGETTI AI\open-seo`, non installato
- 2026-10-31 — **RobustVideoMatting** preparato: venv + `greenscreen.py` + `GREENSCREEN.bat` drag&drop, testato ok
- 2026-10-31 — **RobustVideoMatting** (github.com/PeterL1n/RobustVideoMatting): clonato in `PROGETTI AI\RobustVideoMatting` + modello mobilenetv3 dalla release v1.0.0
- 2026-10-31 — **earshot** installato: venv + torch CPU + `doctor --fetch` ok; MCP aggiunto a `~/.claude.json` (backup `.claude.json.bak-earshot`)
- 2026-10-31 — **earshot** (github.com/Leonxlnx/earshot, MIT): ascolto/analisi/generazione suoni per agenti, clonato in `PROGETTI AI\earshot`, non installato
- 2026-10-31 — **VoiceStudio 0.5.7** installato (installer GitHub release, SHA256 verificato, setup per-utente)
- 2026-10-31 — **voicestudio** (github.com/debpalash/voicestudio, AGPL-3.0): voice cloning/dubbing locale, clonato in `PROGETTI AI\voicestudio`, non installato
- 2026-10-31 — **freellmapi** avviato: `npm install` + `npm run build`, server su :3001, launcher `AVVIA.bat`
- 2026-10-31 — **freellmapi** (github.com/tashfeenahmed/freellmapi, MIT): router gratuito multi-provider LLM, clonato in `PROGETTI AI\freellmapi` (31 MB), non ancora avviato
- 2026-10-24 — **ponytail** (DietrichGebert/ponytail, MIT): 6 skill "codice minimo" in `.claude\skills` + backup qui
- 2026-10-24 — **Android cmdline-tools** (dl.google.com) → `%LOCALAPPDATA%\Android\Sdk`; clonati `Gathin23/cleanyourtv` + `NikhilSiddhu/firetv-tvos` in `PROGETTI AI\FireStick-launcher`
- 2026-10-24 — **Fire TV Stick**: adb (winget Google.PlatformTools 37.0.1), Projectivy 4.72 (spocky/miproja1), SmartTube 32.68 (yuliskov/SmartTube), 53 pacchetti disattivati → backup in `PROGETTI AI\FireStick-backup`

- 2026-10-24 — **Wii USB loader**: USB Loader GX v4.0-r1283 (github.com/wiidev/usbloadergx), d2x cIOS installer v11-beta3 (github.com/wiidev/d2x-cios), Nintendont (github.com/FIX94/Nintendont), wit 3.05a (wit.wiimm.de), fat32format 1.07 (ridgecrop.co.uk) → `Desktop\WII` (CHIAVETTA + FORMATTA-E-PREPARA.bat). Chiavetta formattata FAT32 32KB e pronta
- 2026-10-11 — **replica-skill** (Jakeschincariol): 11 skill per clonare app (recon, build, test, diff…), clonato in `Desktop\replica-skill`, installato in `.claude\skills`
- 2026-10-11 — MCP delle app ora partono solo se l'app è aperta (`.claude\mcp-gate\gate.js`), così non rallentano l'avvio e REA si connette
- 2026-10-11 — REA in timeout anche a 120s quando partono tutti gli MCP insieme (da solo ci mette 17-31s): `MCP_TIMEOUT` portato a 300000 (5 min)
- 2026-10-11 — REA connesso in Claude (~180 strumenti). Test ok: javac.exe aperto con Ghidra → 126 funzioni, 106 stringhe
- 2026-10-11 — REA andava in timeout all'avvio (~17s, limite 30s): messo `MCP_TIMEOUT=120000` in `~/.claude/settings.json` → `env`
- 2026-10-11 — **graphify** (safishamsi/graphify): CLI via uv + skill `/graphify`
- 2026-10-11 — **Ghidra 12.1.4** da GitHub NSA, estratto in `C:\Users\Federico\ghidra`, collegato a REA con JDK 21
- 2026-10-11 — Copiate sul laptop le 13 skill dell'altro PC (animazioni, apple-design, write-swift, houdini-foundations, suno-metatags…)
- 2026-10-11 — **REA** (morluto/rea) clonato in `Desktop\rea` + sottomoduli. Installato globale (npm.cmd) + `rea setup --client claude_code`. Creato questo INVENTARIO.
- 2026-09-28 — (altro PC) 12 skill animazione/UI, write-swift, houdini-foundations
- 2026-09-17 — (altro PC) suno-metatags
- 2026-09-14 — skill claude-ffmpeg-skill
- 2026-09-09 — 12 skill Remotion
- 2026-09-04 — anydesign, canvas-design, image-enhancer, theme-factory, pixelbin, Ear, blender-mcp, imagen, video-downloader, youtube-transcript
- 2026-09-03 — no-ai-slop
- 2026-08-31 — Amagine3D
- 2026-08-27 — emilkowalski-skills, react-bits, yt-dlp, video-use
- 2026-08-25 — NodeGraphQt, txqr
- 2026-08-24 — remove-ai-marks, clean-user-facing-text, i-have-adhd, marcapresenze-svar3finger
- 2026-08-20 — 33 skill mattpocock
- 2026-08-17 — taste-skill (12), cline/skills (37), GSAP (8), agent-reach, design-dna, motion-design
- 2026-08-16 — skill UI/UX (7)
- 2026-08-14 — backup iniziale skill (marketing, SEO, Three.js)
