# 📸 Esempi Prompt

## Situazioni Comuni

### 1. Home Directory
```
 dawid ~
⮕
```

### 2. In una Repository Git
```
 dawid ~/projects/my-app  main
⮕
```

### 3. Git con Modifiche Non Staged
```
 dawid ~/projects/my-app  main  ✏️
⮕
```

### 4. Git con File Staged
```
 dawid ~/projects/my-app  main  ✅2
⮕
```

### 5. Git Ahead (commit da pushare)
```
 dawid ~/projects/my-app  main  ⬆️3
⮕
```

### 6. Git Behind (commit da pullare)
```
 dawid ~/projects/my-app  main  ⬇️2
⮕
```

### 7. Git Branch Divergenti
```
 dawid ~/projects/my-app  main  ⚠️ ⬆️2⬇️1
⮕
```

### 8. Progetto Python con Virtual Environment
```
 dawid ~/projects/my-api  main  (venv)
⮕
```

### 9. Progetto Python con Modifiche Git
```
 dawid ~/projects/my-api  main  ✏️2 ✅1  (venv)
⮕
```

### 10. Multiple Languages Detected
```
 dawid ~/projects/fullstack  main  📦 v18.0.0  (venv)
⮕
```

### 11. Comando che Richiede Tempo
```
 dawid ~/projects/my-app  main
⮕ npm run build
# ... dopo il comando
 dawid ~/projects/my-app  main took 12s
⮕
```

### 12. Comando Fallito (Exit Code != 0)
```
 dawid ~/projects/my-app  main
⮕ exit 1
 dawid ~/projects/my-app  main
⮕  # Freccia rossa indica errore
```

### 13. File Untracked in Git
```
 dawid ~/projects/my-app  main  ❓3
⮕
```

### 14. File Rinominati
```
 dawid ~/projects/my-app  main  📝2
⮕
```

### 15. File Cancellati
```
 dawid ~/projects/my-app  main  🗑️1
⮕
```

### 16. Con Stash Attivo
```
 dawid ~/projects/my-app  main  📦
⮕
```

### 17. Conflitti Git (Merge/Rebase)
```
 dawid ~/projects/my-app  main  ⚠️
⮕
```

### 18. Tutto Insieme (Scenario Reale)
```
 dawid ~/projects/api-service  feature/auth  ⬆️2 ✏️5 ✅3 ❓1  (venv) took 3s
⮕
```

## Legenda Icone

| Icona | Codice | Significato |
|-------|---------|-------------|
| 🐧 | \uf17c | Linux (Tux) |
| 🐙 | \uf1d3 | GitHub Repository |
| 🌿 | \ue0a0 | Git Branch |
| 🐍 | \ue73c | Python |
| 📦 | (Node) | Node.js |
| ✏️ | \uf040 | Modified (non staged) |
| ✅ | \uf00c | Staged |
| ❓ | \uf128 | Untracked |
| 🗑️ | \uf05e | Deleted |
| 📝 | \uf02b | Renamed |
| ⬆️ | \uf0aa | Ahead |
| ⬇️ | \uf0ab | Behind |
| ⚠️ | \uf0ec | Diverged/Conflicts |
| 📦 | \uf448 | Stash |
| ⮕ | - | Prompt (verde=ok, rosso=errore) |

## Test Manuale

Puoi testare ogni scenario:

### Test Git Status
```bash
# Setup repo test
mkdir /tmp/test-prompt && cd /tmp/test-prompt
git init
git config user.name "Test"
git config user.email "test@test.com"

# Untracked file
touch README.md
# Prompt dovrebbe mostrare: ❓

# Staged file
git add README.md
# Prompt dovrebbe mostrare: ✅1

# Modified file
echo "test" > README.md
# Prompt dovrebbe mostrare: ✏️

# Commit
git commit -m "Initial"
# Prompt pulito

# Ahead
echo "change" >> README.md
git commit -am "Change"
# Se c'è un remote: ⬆️1
```

### Test Python
```bash
# Setup progetto Python
mkdir /tmp/test-python && cd /tmp/test-python
touch requirements.txt
# Prompt dovrebbe mostrare:

# Con venv
python -m venv venv
source venv/bin/activate
# Prompt dovrebbe mostrare:  (venv)
```

### Test Command Duration
```bash
# Comando lungo
sleep 3
# Dopo il comando: took 3s
```

### Test Error
```bash
# Comando che fallisce
false
# Freccia ⮕ diventa ROSSA
```

## Tips per Screenshot

Se vuoi fare screenshot per documentazione:

1. **Pulisci il prompt**: `clear`
2. **Setup repo**: Crea un repo git di esempio
3. **Aggiungi contenuto**: File di esempio per linguaggi
4. **Crea stati interessanti**: Modifiche, staged, etc.
5. **Cattura**: Usa `gnome-screenshot` o strumenti simili

---

**Divertiti con il tuo nuovo prompt! 🎨**
