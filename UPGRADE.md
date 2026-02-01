# 🔄 Guida Update - Zsh Starship Config

Questa guida spiega come aggiornare una installazione esistente di zsh-starship-config.

## 📋 Cosa cambia nella nuova versione

### Novità principali:

1. **Modalità Update (`--update`)**: Aggiorna automaticamente tutti i componenti
2. **Merge intelligente `.zshrc`**: Non sovrascrive più le tue personalizzazioni
3. **Installazione automatica font Windows**: Da WSL, installa i font direttamente in Windows (no manual install!)
4. **Verifica post-installazione**: Controlla che tutto funzioni correttamente
5. **Output verboso (`--verbose`)**: Debug dettagliato se serve

### Componenti aggiornabili:

- ✅ Starship (prompt)
- ✅ eza (modern ls)
- ✅ Nerd Fonts
- ✅ Claude Code statusline
- ✅ Configurazione Zsh

## 🚀 Come fare l'update

### Metodo 1: Update automatico (raccomandato)

```bash
cd ~/projects/zsh-starship-config
git pull  # Aggiorna il repository
./install.sh --update
```

Lo script:
- ✅ Rileva i componenti già installati
- ✅ Propone l'aggiornamento di ciascuno
- ✅ Preserva le tue personalizzazioni in `.zshrc`
- ✅ Verifica che tutto funzioni
- ✅ (WSL) Installa automaticamente i font su Windows

### Metodo 2: Update silenzioso

Se vuoi aggiornare tutto senza conferme interattive:

```bash
./install.sh --update --verbose
```

Nota: Il flag `--verbose` mostra output dettagliato durante l'installazione.

### Metodo 3: Update selettivo

Se vuoi aggiornare solo alcuni componenti:

```bash
# Solo Starship
./install.sh  # Quando rileva Starship, ti chiederà se aggiornare

# Solo eza
# Lo script rileverà eza e chiederà se aggiornare

# Solo .zshrc (merge)
./install.sh  # Farà merge automatico senza sovrascrivere
```

## ⚠️ Importante: Cosa NON viene sovrascritto

### `.zshrc` protetto

Il nuovo installer **non sovrascrive più** il tuo `.zshrc`!

**Comportamento intelligente:**

1. **Se .zshrc ha già Starship** → Fa merge di elementi mancanti (plugin, alias)
2. **Se .zshrc non ha Starship** → Chiede se sovrascrivere o aggiungere
3. **In modalità `--update`** → Chiede conferma prima di sovrascrivere

**Backup automatico:**
Ogni volta che modifica `.zshrc`, crea automaticamente backup:
```
~/.zshrc.backup.20260201_143022
```

### Ripristino backup

Se qualcosa va storto:

```bash
# Lista backup disponibili
ls -lt ~/.zshrc.backup.*

# Ripristina backup
cp ~/.zshrc.backup.YYYYMMDD_HHMMSS ~/.zshrc
```

## 🪟 WSL: Installazione automatica font Windows

### Novità importante per utenti WSL!

Prima dovevi:
1. Copiare i font in Downloads
2. Aprire Windows Explorer
3. Selezionare i file
4. Tasto destro → Installa

**Ora tutto automatico!** 🎉

Lo script:
1. Copia i font in `C:\Users\TuoNome\Downloads\NerdFonts_Zsh_Setup`
2. **Esegue PowerShell per installarli automaticamente** (no admin!)
3. Registra i font nel Registry di Windows
4. Pronto!

Devi solo:
- Riavviare Windows Terminal
- Configurare il font: Impostazioni → Profili → Ubuntu → Aspetto → Font: `MesloLGS NF`

### Se l'installazione automatica fallisce

Fallback manuale (come prima):
```
1. Apri C:\Users\TuoNome\Downloads\NerdFonts_Zsh_Setup
2. Seleziona tutti i .ttf
3. Tasto destro → Installa
```

## 🔍 Verifica installazione

Dopo l'update, lo script esegue automaticamente verifiche:

```
✓ Zsh: v5.9
✓ Starship: v1.19.0
✓ Font MesloLGS NF: installato
✓ eza: v0.18.0
✓ Claude Code statusline: configurata
✓ .zshrc: configurato con Starship
```

### Verifica manuale

```bash
# Verifica Starship
starship --version

# Verifica eza
eza --version

# Verifica font
fc-list | grep "MesloLGS"

# Test rendering Starship
starship prompt
```

## 🐛 Troubleshooting

### Problema: "Starship non si aggiorna"

**Soluzione:**
```bash
./install.sh --update
# Quando chiede se aggiornare Starship, rispondi 's'
```

### Problema: ".zshrc sovrascritto per errore"

**Soluzione:**
```bash
# Ripristina dal backup
ls -lt ~/.zshrc.backup.*
cp ~/.zshrc.backup.YYYYMMDD_HHMMSS ~/.zshrc
source ~/.zshrc
```

### Problema: "Font non funzionano su WSL"

**Soluzione 1 (automatica):**
```bash
cd ~/projects/zsh-starship-config
./install.sh --update
# Lo script reinstallerà i font su Windows
```

**Soluzione 2 (manuale PowerShell):**
```powershell
# Da PowerShell su Windows
cd C:\Users\TuoNome\Downloads\NerdFonts_Zsh_Setup
Get-ChildItem *.ttf | ForEach-Object {
    $dest = "$env:LOCALAPPDATA\Microsoft\Windows\Fonts\$($_.Name)"
    Copy-Item $_.FullName -Destination $dest -Force
}
```

### Problema: "Claude Code statusline non aggiornata"

**Soluzione:**
```bash
./install.sh --update
# Riavvia Claude Code
```

## 📊 Comparazione: Prima vs Dopo

| Aspetto | Versione Vecchia | Versione Nuova |
|---------|------------------|----------------|
| Update componenti | ❌ Reinstalla tutto | ✅ Aggiorna solo necessario |
| .zshrc | ❌ Sovrascrive sempre | ✅ Merge intelligente |
| Backup | ✅ Crea backup | ✅ Crea backup |
| Font WSL | ⚠️ Copia + manual install | ✅ Installazione automatica |
| Verifica | ❌ Nessuna | ✅ Verifica automatica |
| Flag CLI | ❌ No opzioni | ✅ --update, --verbose, --help |

## 💡 Best Practices

### Update periodico consigliato

```bash
# Ogni 1-2 mesi
cd ~/projects/zsh-starship-config
git pull
./install.sh --update
```

### Backup personalizzazioni importanti

```bash
# Salva le tue personalizzazioni prima di update maggiori
cp ~/.zshrc ~/.zshrc.my-custom
cp ~/.config/starship.toml ~/.config/starship.toml.my-custom
```

### Test in ambiente sicuro

Se hai molte personalizzazioni:

```bash
# 1. Fai backup completo
cp ~/.zshrc ~/.zshrc.safe
cp ~/.config/starship.toml ~/.config/starship.toml.safe

# 2. Esegui update
./install.sh --update

# 3. Se qualcosa va storto
cp ~/.zshrc.safe ~/.zshrc
source ~/.zshrc
```

## 📖 Documentazione aggiuntiva

- [README.md](README.md) - Guida completa
- [QUICK_START.md](QUICK_START.md) - Quick start
- [EXAMPLES.md](EXAMPLES.md) - Esempi configurazione
- [CHANGELOG.md](CHANGELOG.md) - Changelog versioni

## 🆘 Supporto

Se riscontri problemi durante l'update:

1. Controlla i log: `./install.sh --update --verbose`
2. Verifica backup: `ls -lt ~/.zshrc.backup.*`
3. Ripristina da backup se necessario
4. Rileggi questa guida

---

**Creato con ❤️ per aggiornamenti sicuri e senza stress**
