# iEDA Version Bump Documentation Index

Welcome! This directory contains complete documentation and tooling for bumping iEDA to the latest version.

## 🚀 Quick Navigation

Choose your path based on your needs:

### I want to update iEDA right now
→ **[QUICKSTART_BUMP.md](QUICKSTART_BUMP.md)** - One command: `./update-ieda.sh`

### I want to understand what this PR provides
→ **[PR_SUMMARY.md](PR_SUMMARY.md)** - Complete overview of the solution

### I want comprehensive documentation
→ **[BUMP_IEDA_README.md](BUMP_IEDA_README.md)** - Full guide with context

### I want general updating information
→ **[UPDATING.md](UPDATING.md)** - Methods and workflows

### I want detailed step-by-step instructions
→ **[MANUAL_BUMP_INSTRUCTIONS.md](MANUAL_BUMP_INSTRUCTIONS.md)** - With troubleshooting

## 📁 File Overview

| File | Size | Lines | Purpose |
|------|------|-------|---------|
| **update-ieda.sh** | 2.9K | 86 | Automated bump script |
| **QUICKSTART_BUMP.md** | 2.0K | 80 | TL;DR quick reference |
| **UPDATING.md** | 4.7K | 171 | General guide |
| **MANUAL_BUMP_INSTRUCTIONS.md** | 5.8K | 206 | Detailed instructions |
| **BUMP_IEDA_README.md** | 5.4K | 168 | Complete overview |
| **PR_SUMMARY.md** | 6.9K | 235 | Implementation summary |
| **BUMP_DOCS_INDEX.md** | ~1K | ~70 | This file |

**Total**: ~30K of documentation and automation

## 🎯 By Use Case

### Use Case: First Time User
1. Read **[QUICKSTART_BUMP.md](QUICKSTART_BUMP.md)** for immediate action
2. Check **[BUMP_IEDA_README.md](BUMP_IEDA_README.md)** if you want more context
3. Run `./update-ieda.sh` when ready

### Use Case: Automated Update
1. Run **[update-ieda.sh](update-ieda.sh)**
2. Review and push the commit it creates
3. Create PR with the commit message as title

### Use Case: Manual Process
1. Read **[MANUAL_BUMP_INSTRUCTIONS.md](MANUAL_BUMP_INSTRUCTIONS.md)**
2. Follow the step-by-step guide
3. Use the troubleshooting section if needed

### Use Case: Understanding the System
1. Read **[PR_SUMMARY.md](PR_SUMMARY.md)** for overview
2. Read **[BUMP_IEDA_README.md](BUMP_IEDA_README.md)** for "the Nix way"
3. Check **[UPDATING.md](UPDATING.md)** for integration details

### Use Case: GitHub Actions
1. No documentation needed
2. Just trigger: https://github.com/Emin017/ieda-infra/actions/workflows/bump.yml
3. Review the auto-generated PR

## 📊 Commit Message Format

All documentation references this format (from git history):

```
iedaUnstable: 0-unstable-YYYY-MM-DD -> 0-unstable-YYYY-MM-DD
```

Current version: **0-unstable-2025-09-01**

## 🔧 What Gets Updated

Only two files are modified in a version bump:
- `nix/pkgs/_sources/generated.json`
- `nix/pkgs/_sources/generated.nix`

## ✨ The Nix Way

All documentation explains how we use **nvfetcher** for:
- Declarative configuration (`nvfetcher.toml`)
- Reproducible hashing (deterministic SHA256)
- Automated updates (no manual hash computation)
- Verification via `nix build -L`

## 🔗 Related Files in Repository

- `.github/workflows/bump.yml` - Automated daily workflow
- `.github/workflows/update.yml` - Flake lock updates
- `nix/pkgs/nvfetcher.toml` - nvfetcher configuration
- `nix/pkgs/_sources/generated.nix` - Generated expressions
- `nix/pkgs/_sources/generated.json` - Generated metadata

## 🎓 Learning Path

**Beginner**: QUICKSTART → update script → done  
**Intermediate**: QUICKSTART → BUMP_IEDA_README → update script  
**Advanced**: PR_SUMMARY → UPDATING → MANUAL_INSTRUCTIONS → manual process  
**Contributor**: All documents → understand workflows → enhance system

## ✅ Verification

All files have been:
- ✅ Syntax validated (bash scripts)
- ✅ Readability confirmed
- ✅ Permissions verified
- ✅ Git committed

## 🚀 Next Steps

1. Choose your path from the navigation above
2. Follow the appropriate documentation
3. Update iEDA to latest version
4. Enjoy! 🎉

---

**Questions?** All documentation includes troubleshooting sections.  
**Ready?** Run `./update-ieda.sh` now!
