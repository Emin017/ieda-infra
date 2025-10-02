# Updating iEDA Version

This guide explains how to bump iEDA to the latest version using Nix.

## Prerequisites

- Nix with flakes enabled
- Internet connection to access gitee.com and nixpkgs
- Git configured with appropriate credentials

## Automated Method

We provide a script that automates the entire update process:

```bash
./update-ieda.sh
```

This script will:
1. Get the current iEDA version from `nix/pkgs/_sources/generated.json`
2. Run `nvfetcher` to fetch the latest iEDA source and update the hash
3. Format the updated files with `nix fmt`
4. Build iEDA with `nix build` to verify the update works
5. Create a commit with the proper message format
6. Show you the next steps (push and create PR)

## Manual Method

If you prefer to do it manually or need more control:

### Step 1: Get Current Version

```bash
cd /path/to/ieda-infra
jq -r '.iEDA.date' ./nix/pkgs/_sources/generated.json
```

Save this value as it will be used in the commit message.

### Step 2: Update iEDA Source

The iEDA source is managed by nvfetcher. The configuration is in `nix/pkgs/nvfetcher.toml`:

```toml
[iEDA]
src.git = "https://gitee.com/oscc-project/iEDA.git"
src.branch = "master"
fetch.git = "https://gitee.com/oscc-project/iEDA.git"
git.fetchSubmodules = true
```

Run nvfetcher to update the source:

```bash
cd nix/pkgs
nix run nixpkgs#nvfetcher
```

This will update two files:
- `nix/pkgs/_sources/generated.nix` - Contains the Nix expression with the new hash
- `nix/pkgs/_sources/generated.json` - Contains metadata including the new date/version

### Step 3: Format Updated Files

```bash
nix fmt
cd ../..
```

### Step 4: Build and Test

Verify that the updated version builds successfully:

```bash
nix build -L '.#iedaUnstable'
```

If the build fails, you may need to:
- Update patches in `nix/pkgs/ieda/src.nix`
- Fix build configuration in `nix/pkgs/ieda/ieda.nix`
- Update dependencies if the new version requires them

### Step 5: Create Commit

Get the new version and create a commit:

```bash
NEW_DATE=$(jq -r '.iEDA.date' ./nix/pkgs/_sources/generated.json)
OLD_VERSION="0-unstable-<old-date>"  # From Step 1
NEW_VERSION="0-unstable-${NEW_DATE}"

git add nix/pkgs/_sources/
git commit -m "iedaUnstable: ${OLD_VERSION} -> ${NEW_VERSION}"
```

### Step 6: Push and Create PR

```bash
git push origin <your-branch>
```

Then create a pull request with the title matching the commit message.

## Commit Message Format

Based on the repository's git history, the commit message format for iEDA version bumps is:

```
iedaUnstable: <old_version> -> <new_version>
```

Examples from git history:
- `iedaUnstable: 0-unstable-2025-08-19 -> 0-unstable-2025-09-01 (#42)`
- `iedaUnstable: 0-unstable-2025-07-06 -> 0-unstable-2025-08-19 (#38)`
- `iedaUnstable: 0-unstable-2025-07-03 -> 0-unstable-2025-07-06 (#26)`

The PR number is automatically added by GitHub when the PR is merged.

## What Files Are Changed

When updating iEDA version, the following files are typically modified:

- `nix/pkgs/_sources/generated.nix` - Updated with new git revision and SHA256 hash
- `nix/pkgs/_sources/generated.json` - Updated with new version metadata and date

## Automated Workflow

This repository has a GitHub Actions workflow (`.github/workflows/bump.yml`) that automatically:
- Runs daily at 08:00 UTC
- Updates iEDA to the latest version
- Builds and tests the update
- Creates a pull request

You can also trigger it manually via the GitHub Actions web interface.

## Troubleshooting

### Build Failures

If `nix build` fails after updating:

1. Check if the error is related to patches:
   - Look at `nix/pkgs/ieda/src.nix` for patches
   - The new version might have fixed issues that patches addressed
   - Or the new version might have changed code that patches modify

2. Check for new dependencies:
   - The new version might require additional libraries
   - Update `buildInputs` in `nix/pkgs/ieda/ieda.nix`

3. Check for API changes:
   - Dependencies might have breaking changes
   - Update version pins or fix compatibility issues

### Hash Mismatch

If you see a hash mismatch error, nvfetcher should have updated it correctly. If you need to manually compute the hash:

```bash
nix-prefetch-git --url https://gitee.com/oscc-project/iEDA.git --rev <commit-sha> --fetch-submodules
```

## Related Files

- `.github/workflows/bump.yml` - Automated bump workflow
- `.github/workflows/update.yml` - Flake lock update workflow
- `nix/pkgs/nvfetcher.toml` - nvfetcher configuration
- `nix/pkgs/_sources/generated.nix` - Generated Nix expressions
- `nix/pkgs/_sources/generated.json` - Generated metadata
- `nix/pkgs/ieda/src.nix` - iEDA source preparation
- `nix/pkgs/ieda/ieda.nix` - iEDA build configuration
