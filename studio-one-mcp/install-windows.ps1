# Installa studio-one-mcp su Windows (Studio One 5/6/7, Studio Pro 8).
# Lancia in PowerShell:
#   irm https://raw.githubusercontent.com/ohgvez/skills-claude/claude/wonderful-cray-kvks1j/studio-one-mcp/install-windows.ps1 | iex
#
# Fa: Node.js + loopMIDI (via winget), scarica il server in %USERPROFILE%\studio-one-mcp,
# npm install, installa il device MCP Bridge in Studio One, registra il server in
# Claude Code e Claude Desktop, poi aspetta che Studio One risponda.
$ErrorActionPreference = 'Stop'
$Dest = Join-Path $env:USERPROFILE 'studio-one-mcp'
$Zip  = 'https://codeload.github.com/NeanderthalMan/studio-one-mcp/zip/refs/heads/main'
$Port = 'studio-one-mcp'

function Step($m) { Write-Host "`n==> $m" -ForegroundColor Cyan }
function Refresh-Path {
  $env:Path = [Environment]::GetEnvironmentVariable('Path', 'Machine') + ';' +
              [Environment]::GetEnvironmentVariable('Path', 'User')
}

Step 'Node.js'
$node = Get-Command node -ErrorAction SilentlyContinue
$major = if ($node) { [int]((& node -v).TrimStart('v').Split('.')[0]) } else { 0 }
if ($major -lt 20) {
  winget install -e --id OpenJS.NodeJS.LTS --accept-source-agreements --accept-package-agreements
  Refresh-Path
}
Write-Host "Node $(node -v)"

Step 'loopMIDI (porta MIDI virtuale)'
$loopExe = @("$env:ProgramFiles\Tobias Erichsen\loopMIDI\loopMIDI.exe",
             "${env:ProgramFiles(x86)}\Tobias Erichsen\loopMIDI\loopMIDI.exe") |
           Where-Object { Test-Path $_ } | Select-Object -First 1
if (-not $loopExe) {
  winget install -e --id TobiasErichsen.loopMIDI --accept-source-agreements --accept-package-agreements
  $loopExe = @("$env:ProgramFiles\Tobias Erichsen\loopMIDI\loopMIDI.exe",
               "${env:ProgramFiles(x86)}\Tobias Erichsen\loopMIDI\loopMIDI.exe") |
             Where-Object { Test-Path $_ } | Select-Object -First 1
}
if ($loopExe) { Start-Process $loopExe }
Write-Host @"
In loopMIDI: scrivi  $Port  nel campo 'New port-name' e clicca '+'.
(Tasto destro sull'icona di loopMIDI vicino all'orologio -> 'Autostart' per averla sempre.)
"@ -ForegroundColor Yellow
Read-Host 'Premi Invio quando la porta e'' creata'

Step "Scarico studio-one-mcp in $Dest"
$tmp = Join-Path $env:TEMP 'studio-one-mcp.zip'
Invoke-WebRequest $Zip -OutFile $tmp -UseBasicParsing
$unz = Join-Path $env:TEMP 'studio-one-mcp-unzip'
Remove-Item $unz -Recurse -Force -ErrorAction SilentlyContinue
Expand-Archive $tmp $unz -Force
if (Test-Path $Dest) { Remove-Item $Dest -Recurse -Force }
Move-Item (Get-ChildItem $unz -Directory | Select-Object -First 1).FullName $Dest
Remove-Item $tmp, $unz -Recurse -Force -ErrorAction SilentlyContinue

Step 'npm install'
Push-Location $Dest
try {
  npm install --no-fund --no-audit
  if ($LASTEXITCODE -ne 0) { throw 'npm install fallito' }

  if (Get-Process | Where-Object { $_.ProcessName -match 'Studio ?One|Studio ?Pro' }) {
    Write-Host 'Studio One e'' aperto: salva e chiudilo (deve ricaricare i device).' -ForegroundColor Yellow
    Read-Host 'Premi Invio quando Studio One e'' chiuso'
  }

  Step 'Registrazione in Claude Desktop'
  $js = @"
import { serverEntry, mergeDesktopConfig, desktopConfigPath } from './src/setup/checks.js';
import { mkdirSync } from 'node:fs';
import { dirname } from 'node:path';
mkdirSync(dirname(desktopConfigPath()), { recursive: true });
const { backup } = mergeDesktopConfig(serverEntry({ midiPort: '$Port' }));
console.log('Claude Desktop: ' + desktopConfigPath() + (backup ? ' (backup: ' + backup + ')' : ''));
"@
  Set-Content -Path '.\_desktop.mjs' -Value $js -Encoding UTF8
  try { node .\_desktop.mjs } catch { Write-Host "Claude Desktop non registrato: $_" }
  Remove-Item .\_desktop.mjs -ErrorAction SilentlyContinue

  Step 'Setup: installa il device MCP Bridge, registra Claude Code, aspetta Studio One'
  Write-Host @"
Quando il setup arriva al punto 5 e dice di aspettare:
  1. Apri Studio One 7
  2. Studio One -> Opzioni -> External Devices -> Add...
  3. Cartella 'studio-one-mcp' -> 'MCP Bridge'
  4. Receive From: $Port     Send To: None  -> OK
Hai circa 3 minuti.
"@ -ForegroundColor Yellow
  $env:STUDIO_ONE_MCP_MIDI_PORT = $Port
  node src/cli.js setup --yes
  if ($LASTEXITCODE -ne 0) { Step 'Qualcosa manca: doctor'; node src/cli.js doctor }
} finally { Pop-Location }

Write-Host "`nRiavvia Claude Desktop / Claude Code e chiedi: 'usa live_song'." -ForegroundColor Green
