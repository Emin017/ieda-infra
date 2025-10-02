# iEDA Version Bump - Complete Guide

This PR provides comprehensive tooling and documentation for bumping iEDA to the latest version using the "Nix way".

## 🎯 What This PR Provides

### 1. Automated Script: `update-ieda.sh`
A fully automated bash script that:
- Retrieves the current iEDA version
- Runs `nvfetcher` to fetch the latest version and compute the SHA256 hash
- Formats updated files with `nix fmt`
- Builds iEDA with `nix build -L` to verify the update
- Creates a commit with the proper message format based on git history analysis
- Provides clear status messages throughout the process

**Usage:**
```bash
./update-ieda.sh
```

### 2. General Documentation: `UPDATING.md`
Comprehensive guide covering:
- Prerequisites and system requirements
- Automated and manual update methods
- Commit message format (derived from git log analysis)
- Project structure and related files
- Troubleshooting common issues
- Integration with CI/CD workflows

### 3. Detailed Instructions: `MANUAL_BUMP_INSTRUCTIONS.md`
Step-by-step manual process with:
- Current version information (0-unstable-2025-09-01)
- Three different approaches (nvfetcher, GitHub Actions, manual)
- Complete verification steps
- Troubleshooting guide
- Next steps after committing

## 📊 Commit Message Format Analysis

From analyzing the repository's git history, the standard format for iEDA version bumps is:

```
iedaUnstable: <OLD_VERSION> -> <NEW_VERSION>
```

Examples from git log:
- `iedaUnstable: 0-unstable-2025-08-19 -> 0-unstable-2025-09-01 (#42)`
- `iedaUnstable: 0-unstable-2025-07-06 -> 0-unstable-2025-08-19 (#38)`
- `iedaUnstable: 0-unstable-2025-07-03 -> 0-unstable-2025-07-06 (#26)`

Version format: `0-unstable-YYYY-MM-DD` where the date comes from the `date` field in `nix/pkgs/_sources/generated.json`.

## 🔄 How nvfetcher Works (The "Nix Way")

nvfetcher is a Nix tool that:

1. **Reads** `nix/pkgs/nvfetcher.toml` configuration:
   ```toml
   [iEDA]
   src.git = "https://gitee.com/oscc-project/iEDA.git"
   src.branch = "master"
   fetch.git = "https://gitee.com/oscc-project/iEDA.git"
   git.fetchSubmodules = true
   ```

2. **Fetches** the latest commit from the configured git repository

3. **Computes** the SHA256 hash of the source (including submodules)

4. **Updates** two files:
   - `nix/pkgs/_sources/generated.nix` - Nix expression with fetchgit configuration
   - `nix/pkgs/_sources/generated.json` - Metadata including date and version

This is the "Nix way" because:
- ✅ Declarative configuration (nvfetcher.toml)
- ✅ Reproducible (deterministic hashing)
- ✅ Automated (no manual hash computation)
- ✅ Type-safe (generates valid Nix expressions)
- ✅ Version-controlled (all changes tracked in git)

## 🚀 Quick Start

Choose one of these methods:

### Method 1: Automated Script (Recommended)
```bash
./update-ieda.sh
```

### Method 2: GitHub Actions (Fully Automated)
1. Go to https://github.com/Emin017/ieda-infra/actions/workflows/bump.yml
2. Click "Run workflow" → Select "main" branch → Click "Run workflow"
3. Wait for completion and review the auto-generated PR

### Method 3: Manual (For Learning)
```bash
cd nix/pkgs
nix run nixpkgs#nvfetcher
nix fmt
cd ../..
nix build -L '.#iedaUnstable'
# If successful, commit the changes
```

## 📁 Files Modified During Update

The update process modifies these files:

- `nix/pkgs/_sources/generated.json` - Version metadata
- `nix/pkgs/_sources/generated.nix` - Nix source expression

These files should be the only changes in a version bump commit.

## ⚙️ Build and Test Process

The update script and workflow run `nix build -L '.#iedaUnstable'` which:

1. Fetches the iEDA source using the new hash
2. Applies patches from `nix/pkgs/ieda/src.nix`
3. Builds iEDA with all dependencies
4. Runs post-install steps
5. Outputs the result to `./result/bin/iEDA`

If the build succeeds, the hash is correct and the update is valid.

## 🔧 Integration with Existing Workflows

This complements the existing automated workflows:

- `.github/workflows/bump.yml` - Daily automated version bumps (08:00 UTC)
- `.github/workflows/update.yml` - Weekly flake lock updates
- `.github/workflows/build.yml` - CI builds and tests

## 📝 Current Status

- **Current iEDA Version**: 0-unstable-2025-09-01
- **Current Git Commit**: fd2edab9b8ab29b4848d727a5f8606623da879f1
- **Last Update**: September 1, 2025
- **Next Action**: Run update script or trigger automated workflow

## 🎓 Why This Approach?

This solution follows Nix best practices:

1. **Declarative**: Configuration in nvfetcher.toml defines what to fetch
2. **Reproducible**: SHA256 hashes ensure bit-for-bit identical builds
3. **Automated**: Scripts and workflows minimize manual intervention
4. **Verifiable**: Build step confirms the update works before committing
5. **Documented**: Clear guides for both automated and manual processes

## 🆘 Need Help?

- See `UPDATING.md` for general information
- See `MANUAL_BUMP_INSTRUCTIONS.md` for detailed step-by-step guide
- Check `.github/workflows/bump.yml` for the automated workflow
- Review past version bump commits in git history for examples

## 🎉 Next Steps

To bump iEDA to the latest version:

1. Ensure you have Nix installed with flakes enabled
2. Ensure you have internet access to gitee.com
3. Run: `./update-ieda.sh`
4. Push the created commit
5. Create a PR with the commit message as the title

That's it! The script handles everything else automatically.
