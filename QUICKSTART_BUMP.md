# Quick Start: Bump iEDA Version

**TL;DR**: Run `./update-ieda.sh` if you have Nix installed, or trigger the GitHub Actions workflow.

## One-Command Solution

```bash
./update-ieda.sh
```

That's it! The script handles everything automatically.

## What It Does

1. ✅ Gets current version: `0-unstable-2025-09-01`
2. ✅ Runs `nvfetcher` to fetch latest iEDA
3. ✅ Updates hash in `nix/pkgs/_sources/`
4. ✅ Formats files with `nix fmt`
5. ✅ Tests with `nix build -L`
6. ✅ Creates commit: `iedaUnstable: 0-unstable-2025-09-01 -> 0-unstable-YYYY-MM-DD`

## Prerequisites

- Nix with flakes enabled
- Internet access to gitee.com

## Alternative: GitHub Actions

Don't have Nix? Use the automated workflow:

1. Visit: https://github.com/Emin017/ieda-infra/actions/workflows/bump.yml
2. Click "Run workflow"
3. Select "main" branch
4. Click "Run workflow" button
5. Review and merge the auto-generated PR

## Manual Method (3 Commands)

```bash
cd nix/pkgs && nix run nixpkgs#nvfetcher && nix fmt && cd ../..
nix build -L '.#iedaUnstable'
git add nix/pkgs/_sources/ && git commit -m "iedaUnstable: 0-unstable-2025-09-01 -> 0-unstable-$(date +%Y-%m-%d)"
```

## What Gets Changed

Only these files should be modified:
- `nix/pkgs/_sources/generated.json` (metadata)
- `nix/pkgs/_sources/generated.nix` (Nix expression with new hash)

## Need More Info?

- **Complete guide**: See `BUMP_IEDA_README.md`
- **General info**: See `UPDATING.md`
- **Detailed steps**: See `MANUAL_BUMP_INSTRUCTIONS.md`
- **Example workflow**: See `.github/workflows/bump.yml`

## Commit Message Format

Based on git history analysis:

```
iedaUnstable: <old_version> -> <new_version>
```

Example: `iedaUnstable: 0-unstable-2025-09-01 -> 0-unstable-2025-10-02`

## After Committing

1. Push: `git push origin <branch>`
2. Create PR with commit message as title
3. Wait for CI to pass
4. Merge!

---

**Current Status:**
- Version: 0-unstable-2025-09-01
- Commit: fd2edab9b8ab29b4848d727a5f8606623da879f1
- Ready to update! 🚀
