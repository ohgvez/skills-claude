# INVENTARIO — tutto quello che ho installato/scaricato per Claude

Second brain unico. Ogni volta che si scarica qualcosa (skill, plugin, MCP, repo, tool, app) si aggiunge una riga qui **e** nel [Registro](#registro-cronologico) in fondo.
Ultimo aggiornamento: 2026-10-11

Legenda stato: ✅ funziona · ⚠️ installato ma da completare · ❌ rotto/non connesso

---

## 1. Server MCP (strumenti che Claude usa per comandare app)

Config in `C:\Users\Federico\.claude.json` → `mcpServers`.

| Nome | Cosa fa | Dove sta | Fonte | Stato |
|---|---|---|---|---|
| blender-mcp | Comanda Blender | `uvx blender-mcp` + addon in `Desktop\blender-mcp-addon` | ahujasid/blender-mcp | ⚠️ si connette solo con Blender aperto |
| AfterEffectsMCP | Comanda After Effects | `C:\Users\Federico\after-effects-mcp` | github.com/Dakkshin/after-effects-mcp | ⚠️ serve AE aperto |
| fl-studio-mcp | Comanda FL Studio | `C:\Users\Federico\fl-studio-mcp` | github.com/calvinw/fl-studio-mcp | ⚠️ serve FL aperto |
| premiere-pro | Comanda Premiere | `C:\Users\Federico\premiere-pro-mcp` | github.com/leancoderkavy/premiere-pro-mcp | ⚠️ serve Premiere aperto |
| photoshop | Comanda Photoshop | npx `@alisaitteke/photoshop-mcp` | npm | ⚠️ serve PS aperto |
| houdini | Comanda Houdini | `Desktop\houdini-mcp` | github.com/capoomgit/houdini-mcp | ⚠️ serve Houdini aperto |
| vocaloid6-mcp | Comanda Vocaloid 6 | `Desktop\vocaloid6-mcp` | github.com/nigexiaolaji/vocaloid6-mcp | ⚠️ clonato, NON registrato |
| **REA** (rea-agents) | Reverse engineering di app/exe/siti | `Desktop\rea` (+ npm globale v6.4.0) | github.com/morluto/rea | ✅ registrato in Claude Code (attivo dopo riavvio). Per .exe serve Ghidra |

**REA — come è stato installato** (PowerShell blocca `npm`, usare `npm.cmd`):
```
npm.cmd i -g rea-agents
rea.cmd setup --client claude_code --yes
```
Backup config: `.claude.json.rea.backup`. Per analizzare .exe serve anche Ghidra 12.1 (`GHIDRA_INSTALL_DIR`).

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
| 2026-09-17 | Musica | — | suno-metatags (aggiunta dall'altro PC) |
| 2026-09-28 | Animazione/UI + altro | vari (altro PC) | animate, animate-expo, animation-vocabulary, apple-design, ask-sonner, emil-design-eng, find-animation-opportunities, improve-animations, pick-ui-library, review-animations, write-swift, houdini-foundations ⚠️ solo nel repo: su questo PC non sono ancora in `.claude\skills` |
| 2026-10-11 | Reverse engineering | morluto/rea | reverse-engineer-anything ✅ (installata da `rea setup`) |

## 4. Repo clonati / progetti

| Cartella | Cosa | Remote |
|---|---|---|
| `Desktop\skills-claude` | **Questo repo**: backup skill + inventario | github.com/ohgvez/skills-claude |
| `Desktop\flight-tracker` | Tracker voli Google Flights + ntfy (privato) | github.com/ohgvez/flight-tracker |
| `Desktop\vst\*` | Plugin VST miei: BlendForge, ChoirForge, ChopForge, FourCount, GeekForge, ilgranello, Lumitone, Machicut, MorseGate, RigForge, VocoForge, VoxForge | — |
| `Desktop\JUCE` | Framework per i VST | juce-framework/JUCE |
| `Desktop\depth-relief` | Video → rilievo 3D per ohhvez.it | — |
| `Desktop\giovani_soldi` | Video testo cromato in Houdini/Karma | — |
| `Desktop\MioMod` | Mod Minecraft Fabric | FabricMC/fabric-example-mod |
| `Desktop\agent-reach` | Ricerca su social/web | Panniantong/agent-reach |
| `Desktop\rea` | REA reverse engineering (sottomodulo unblob non scaricabile su Windows, non serve) | morluto/rea |

## 5. App / software installati rilevanti

After Effects 2026, Photoshop 2026, Premiere Pro 2026, FL Studio 2026, Blender 5.2, Houdini FX 20.0, Studio One 6 Pro, Synthesizer V Studio, Vocaloid 6, iZotope Nectar 4 / Neutron 5, Audacity 4.

---

## Registro cronologico

Una riga per ogni cosa scaricata. Più recente in alto.

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
