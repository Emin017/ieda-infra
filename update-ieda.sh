#!/usr/bin/env bash
# Script to bump iEDA to the latest version in the Nix way
# This script follows the same process as the bump.yml workflow

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}Starting iEDA version bump process...${NC}"

# Step 1: Get the old version before update
echo -e "${YELLOW}Step 1: Getting current iEDA version...${NC}"
if ! command -v jq &> /dev/null; then
    echo -e "${RED}Error: jq is not installed. Installing with Nix...${NC}"
    OLD_VERSION=$(nix run nixpkgs#jq -- -r '.iEDA.date' ./nix/pkgs/_sources/generated.json)
else
    OLD_VERSION=$(jq -r '.iEDA.date' ./nix/pkgs/_sources/generated.json)
fi
echo -e "${GREEN}Current version: 0-unstable-${OLD_VERSION}${NC}"

# Step 2: Update iEDA source using nvfetcher
echo -e "${YELLOW}Step 2: Updating iEDA source with nvfetcher...${NC}"
cd nix/pkgs
if ! nix run nixpkgs#nvfetcher; then
    echo -e "${RED}Error: nvfetcher failed to update sources${NC}"
    exit 1
fi
echo -e "${GREEN}Source updated successfully${NC}"

# Step 3: Format the updated files
echo -e "${YELLOW}Step 3: Formatting updated files...${NC}"
if ! nix fmt; then
    echo -e "${RED}Error: nix fmt failed${NC}"
    exit 1
fi
cd -
echo -e "${GREEN}Files formatted successfully${NC}"

# Step 4: Get the new version
echo -e "${YELLOW}Step 4: Getting new iEDA version...${NC}"
if ! command -v jq &> /dev/null; then
    NEW_DATE=$(nix run nixpkgs#jq -- -r '.iEDA.date' ./nix/pkgs/_sources/generated.json)
else
    NEW_DATE=$(jq -r '.iEDA.date' ./nix/pkgs/_sources/generated.json)
fi
NEW_VERSION="0-unstable-${NEW_DATE}"
echo -e "${GREEN}New version: ${NEW_VERSION}${NC}"

# Step 5: Build iEDA to verify the update
echo -e "${YELLOW}Step 5: Building iEDA to verify the update...${NC}"
if ! nix build -L '.#iedaUnstable'; then
    echo -e "${RED}Error: Build failed. Please fix the issues before committing.${NC}"
    exit 1
fi
echo -e "${GREEN}Build successful!${NC}"

# Step 6: Create commit with appropriate message
echo -e "${YELLOW}Step 6: Creating commit...${NC}"
COMMIT_MESSAGE="iedaUnstable: 0-unstable-${OLD_VERSION} -> ${NEW_VERSION}"
echo -e "${GREEN}Commit message: ${COMMIT_MESSAGE}${NC}"

# Add the updated files
git add nix/pkgs/_sources/

# Check if there are changes to commit
if git diff --quiet --cached --exit-code; then
    echo -e "${YELLOW}No changes to commit. iEDA is already at the latest version.${NC}"
    exit 0
fi

# Show the diff
echo -e "${YELLOW}Changes to be committed:${NC}"
git diff --cached --stat

# Commit the changes
git commit -m "${COMMIT_MESSAGE}"
echo -e "${GREEN}Committed successfully!${NC}"

echo -e "${GREEN}iEDA version bump completed successfully!${NC}"
echo -e "${YELLOW}Next steps:${NC}"
echo -e "  1. Push the changes: git push"
echo -e "  2. Create a pull request with title: ${COMMIT_MESSAGE}"
