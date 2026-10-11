---
name: suno-metatags
description: "Reference for Suno AI song-generation metatags (bracket tags like [Verse], [Chorus], [Male Vocal], [Euphoric Build]). Use when writing or editing Suno song prompts/lyrics, structuring a song, or choosing instrumentation, vocal style, mood, or dynamics tags."
---

<!-- argument-hint: [category name, e.g. "vocal" or "mood"] -->

# Suno Cheat Sheet — Song Metatags
**Source**: Suno Cheat Sheet (user-provided PDF) | **Generated**: 2026-08-21

## How to Use This Skill

This is a flat reference, not a book — no chapters. Load it whenever writing a Suno prompt so structure/instrumental/vocal/mood/dynamics tags are used correctly and consistently, and never re-invent or misremember tag names.

Tags are written in square brackets `[Like This]`, placed on their own line before the section/lyrics they apply to. Multiple tags can combine (e.g. a mood tag + a vocal tag) before the same section.

---

## 1. Song Structure Tags
| Tag | Effect |
|---|---|
| `[Intro]` | Marks the beginning of the song |
| `[Verse]` | Verse section |
| `[Pre-Chorus]` | Prepares for the chorus |
| `[Chorus]` | Main chorus |
| `[Post-Chorus]` | Section after the chorus |
| `[Bridge]` | Contrasting section |
| `[Outro]` | Marks the end of the song |
| `[Hook]` | Emphasizes a catchy part |
| `[Break]` | A break in the song |
| `[Fade In]` | Gradually introduces a section |
| `[Fade Out]` | Gradually decreases volume to end the song |

## 2. Instrumental Tags
| Tag | Effect |
|---|---|
| `[Instrumental]` | Instrumental section |
| `[Guitar Solo]` | Guitar solo |
| `[Piano Solo]` | Piano solo |
| `[Drum Solo]` | Drum solo |
| `[Bass Solo]` | Bass solo |
| `[Instrumental Break]` | Insert an instrumental section |

## 3. Vocal Tags
| Tag | Effect |
|---|---|
| `[Male Vocal]` | Male vocals |
| `[Female Vocal]` | Female vocals |
| `[Duet]` | Duet |
| `[Choir]` | Choir vocals |
| `[Spoken Word]` | Spoken-word section |
| `[Harmonies]` | Vocal harmonies |
| `[Vulnerable Vocals]` | Raw, emotional vocal performance |
| `[Whisper]` | Softer, whispered vocals |

## 4. Specific Element Tags
| Tag | Effect |
|---|---|
| `[Catchy Hook]` | Memorable hook |
| `[Emotional Bridge]` | Emotionally intense bridge |
| `[Powerful Outro]` | Strong ending |
| `[Soft Intro]` | Song starts softly |
| `[Melodic Interlude]` | Melodic break |
| `[Percussion Break]` | Percussion-focused section |

## 5. Atmosphere & Mood Tags
| Tag | Effect |
|---|---|
| `[Eerie Whispers]` | Faint, unsettling background vocals |
| `[Ghostly Echoes]` | Reverb-heavy, ethereal sound |
| `[Ominous Drone]` | Low, continuous tone for tension |
| `[Spectral Melody]` | Haunting, otherworldly melody |
| `[Melancholic Atmosphere]` | Sad or reflective mood |
| `[Euphoric Build]` | Builds toward a joyful climax |
| `[Tense Underscore]` | Underlying tension |
| `[Serene Ambience]` | Peaceful, calm atmosphere |
| `[Nostalgic Tones]` | Sense of nostalgia |

## 6. Dynamics & Progression Tags
| Tag | Effect |
|---|---|
| `[Building Intensity]` | Gradually increases musical intensity |
| `[Climactic]` | Reaches a musical high point |
| `[Emotional Swell]` | Gradual build-up of emotional intensity |
| `[Layered Arrangement]` | Complex, multi-instrumental arrangement |
| `[Orchestral Build]` | Gradually introduces orchestral elements |
| `[Stripped Back]` | Reduces instrumentation to bare essentials |
| `[Sudden Break]` | Abrupt change |
| `[Crescendo]` | Gradually increases volume/intensity |
| `[Decrescendo]` | Gradually decreases volume/intensity |

## Decision Rules
- Combine a **structure** tag with a **mood/instrumental/vocal** tag on consecutive lines rather than inventing a new compound tag — Suno reads each bracket independently.
- Use `[Instrumental]`/solo tags for texture, not `[Break]` (break = pause/change in the arrangement, not necessarily instrument-only).
- For raw/emotional delivery on a specific line, prefer `[Vulnerable Vocals]` or `[Whisper]` right before that line, not the whole song.
- `[Spoken Word]` before a line makes it rapped/spoken rather than sung — use it for intros, ad-libs, or hooks that need a spoken-word cadence.

## Worked Example (from source)
```
[Intro: Jazzy piano chords with a lo-fi crackle, distant sleigh bells, and a laid-back drum loop.]
[Spoken Word]
"Yo, it's the most wonderful time… and the most stressful.
From the gift wrap to the setbacks, let's talk about it.
Detroit, let's vibe."
```
Note the pattern: `[Intro: <freeform instrumentation description>]` — the structure tag can carry a bracketed free-text description of the instrumentation, not just the bare tag name.

## Scope & Limits
This covers only the tags in the source cheat sheet. If a tag is needed that isn't listed here, it may still work in Suno (freeform bracket descriptions are allowed, as the worked example shows) — treat this list as the vetted/known-good set, not an exhaustive one.
