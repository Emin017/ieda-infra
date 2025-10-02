# Manual iEDA Version Bump Instructions

This document provides step-by-step instructions for manually bumping the iEDA version when the automated workflow cannot be used or when you need to test locally before committing.

## Current Situation

- **Current Version**: 0-unstable-2025-09-01
- **Current Commit**: fd2edab9b8ab29b4848d727a5f8606623da879f1
- **Files to Update**: `nix/pkgs/_sources/generated.nix` and `nix/pkgs/_sources/generated.json`

## Prerequisites

✅ System with Nix installed (with flakes enabled)
✅ Internet access to gitee.com and nixpkgs
✅ Git configured for this repository

## Quick Start (Recommended)

If you have Nix installed with internet access:

```bash
./update-ieda.sh
```

This automated script will handle everything for you.

## Manual Process

### Option 1: Using nvfetcher (Recommended)

This is the "Nix way" as it's declarative and reproducible:

```bash
# 1. Navigate to the package directory
cd nix/pkgs

# 2. Run nvfetcher to fetch latest version and compute hash
nix run nixpkgs#nvfetcher

# 3. Format the updated files
nix fmt

# 4. Return to repository root
cd ../..

# 5. Build and test
nix build -L '.#iedaUnstable'

# 6. If build succeeds, commit
OLD_VERSION="0-unstable-2025-09-01"
NEW_DATE=$(jq -r '.iEDA.date' ./nix/pkgs/_sources/generated.json)
NEW_VERSION="0-unstable-${NEW_DATE}"
git add nix/pkgs/_sources/
git commit -m "iedaUnstable: ${OLD_VERSION} -> ${NEW_VERSION}"
```

### Option 2: Using GitHub Actions (Fully Automated)

The repository already has an automated workflow that can be triggered:

1. Go to https://github.com/Emin017/ieda-infra/actions/workflows/bump.yml
2. Click "Run workflow"
3. Select the main branch
4. Click "Run workflow" button
5. Wait for the workflow to complete
6. Review and merge the automatically created PR

### Option 3: Manual Hash Update (Not Recommended)

If you absolutely cannot use nvfetcher or GitHub Actions:

```bash
# 1. Find the latest commit on iEDA master branch
# Visit: https://gitee.com/oscc-project/iEDA/commits/master
# Or use git:
LATEST_COMMIT=$(git ls-remote https://gitee.com/oscc-project/iEDA.git HEAD | cut -f1)
echo "Latest commit: $LATEST_COMMIT"

# 2. Compute the SHA256 hash using nix-prefetch-git
nix run nixpkgs#nix-prefetch-git -- \
  --url https://gitee.com/oscc-project/iEDA.git \
  --rev "$LATEST_COMMIT" \
  --fetch-submodules \
  --quiet

# This will output something like:
# {
#   "url": "https://gitee.com/oscc-project/iEDA.git",
#   "rev": "abc123...",
#   "date": "2025-10-02T12:34:56+00:00",
#   "sha256": "sha256-xxxxx..."
# }

# 3. Manually update nix/pkgs/_sources/generated.json with new values
# Update: version, date, rev, sha256

# 4. Manually update nix/pkgs/_sources/generated.nix with new values
# Update: version, rev, sha256

# 5. Format files
nix fmt

# 6. Test build
nix build -L '.#iedaUnstable'

# 7. Commit if successful
git add nix/pkgs/_sources/
git commit -m "iedaUnstable: 0-unstable-2025-09-01 -> 0-unstable-$(date +%Y-%m-%d)"
```

## Verification Steps

After updating but before committing:

1. **Verify the hash is correct**:
   ```bash
   nix build -L '.#iedaUnstable'
   ```
   
   If you see a hash mismatch error, the hash in generated.nix is incorrect.

2. **Verify the build completes**:
   The build might fail if:
   - New iEDA version has breaking changes
   - Patches in `nix/pkgs/ieda/src.nix` no longer apply
   - New dependencies are required

3. **Check build output**:
   ```bash
   ls -lh result/bin/
   ./result/bin/iEDA --version
   ```

## Commit Message Format

Based on repository history, use this exact format:

```
iedaUnstable: <OLD_VERSION> -> <NEW_VERSION>
```

Examples:
- `iedaUnstable: 0-unstable-2025-08-19 -> 0-unstable-2025-09-01`
- `iedaUnstable: 0-unstable-2025-07-06 -> 0-unstable-2025-08-19`

The version format is always: `0-unstable-YYYY-MM-DD` where the date comes from the `date` field in `generated.json`.

## Troubleshooting

### "Nix is not installed"

Install Nix with flakes support:
```bash
sh <(curl -L https://nixos.org/nix/install) --daemon
# Then enable flakes in ~/.config/nix/nix.conf:
echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
```

### "nvfetcher: command not found"

Don't install nvfetcher globally. Use `nix run nixpkgs#nvfetcher` instead.

### "Hash mismatch" error during build

This means the hash in generated.nix doesn't match the actual content. Re-run nvfetcher or manually compute the hash with nix-prefetch-git.

### Build fails with patch errors

The new iEDA version might have changes that conflict with our patches in `nix/pkgs/ieda/src.nix`. You'll need to:
1. Review the patch
2. Update or remove it if no longer needed
3. Test the build again

### "Cannot access gitee.com"

You need internet access to gitee.com to fetch the iEDA source. If you're behind a firewall or proxy, configure git to use it:
```bash
git config --global http.proxy http://proxy.example.com:8080
```

## Next Steps After Committing

1. Push your changes:
   ```bash
   git push origin <your-branch>
   ```

2. Create a pull request with:
   - **Title**: Same as commit message (e.g., `iedaUnstable: 0-unstable-2025-09-01 -> 0-unstable-2025-10-02`)
   - **Description**: "Auto-generated PR to update iEDA to latest version"
   - **Reviewers**: @Emin017

3. Wait for CI checks to pass

4. Merge when approved

## Related Files

- `.github/workflows/bump.yml` - Automated bump workflow (runs daily)
- `nix/pkgs/nvfetcher.toml` - nvfetcher configuration
- `nix/pkgs/_sources/generated.nix` - Generated Nix expressions (updated by nvfetcher)
- `nix/pkgs/_sources/generated.json` - Generated metadata (updated by nvfetcher)
- `nix/pkgs/ieda/src.nix` - iEDA source with patches
- `nix/pkgs/ieda/ieda.nix` - iEDA build configuration
- `update-ieda.sh` - Automated update script
- `UPDATING.md` - General updating guide
