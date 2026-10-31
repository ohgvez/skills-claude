# INVENTARIO — tutto quello che ho installato/scaricato per Claude

Second brain unico. Ogni volta che si scarica qualcosa (skill, plugin, MCP, repo, tool, app) si aggiunge una riga qui **e** nel [Registro](#registro-cronologico) in fondo.
Ultimo aggiornamento: 2026-10-24

Legenda stato: ✅ funziona · ⚠️ installato ma da completare · ❌ rotto/non connesso

---

## 1. Server MCP (strumenti che Claude usa per comandare app)

Config in `C:\Users\Federico\.claude.json` → `mcpServers`.

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

## 3. Skill (`C:\Users\Federico\.claude\skills`, backup in questo repo)

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
| `Desktop\PROGETTI AI\voicestudio` | VoiceStudio: alternativa locale a ElevenLabs — voice cloning, voice design, doppiaggio video, dettatura, trascrizione, audiolibri (646 lingue), ha anche API locale + MCP. Solo clonato (185 MB), non installato; su CPU senza GPU è lento | debpalash/voicestudio (AGPL-3.0) |

## 5. App / software installati rilevanti

Ghidra 12.1.4 (`C:\Users\Federico\ghidra`, decompilatore NSA, usato da REA), JDK 21 + 25 (Temurin), uv/uvx.

Android: platform-tools/adb 37.0.1 (winget `Google.PlatformTools`), cmdline-tools in `%LOCALAPPDATA%\Android\Sdk` (per compilare APK).

Fire TV Stick (AFTSSS, 192.168.1.164): Projectivy Launcher 4.72 (github.com/spocky/miproja1), SmartTube 32.68 (github.com/yuliskov/SmartTube) — YouTube senza pubblicità. 53 pacchetti Amazon disattivati (lista CleanYourTV).

After Effects 2026, Photoshop 2026, Premiere Pro 2026, FL Studio 2026, Blender 5.2, Houdini FX 20.0, Studio One 6 Pro, Synthesizer V Studio, Vocaloid 6, iZotope Nectar 4 / Neutron 5, Audacity 4.

Wii homebrew in `Desktop\WII` (chiavetta SanDisk 64GB): USB Loader GX v4.0-r1283, d2x cIOS v11-beta3, Nintendont, wit 3.05a, fat32format 1.07.

---

## Registro cronologico

Una riga per ogni cosa scaricata. Più recente in alto.

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
