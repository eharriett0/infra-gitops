#!/bin/bash

# Define output file
OUTPUT_FILE="infra-gitops-all-yaml-files.txt"

# Move to the root of the repo (assumes this script is run from within the repo)
REPO_ROOT="$(git rev-parse --show-toplevel)"
cd "$REPO_ROOT" || exit 1

# Generate the combined YAML dump
find . -type f \( -name "*.yaml" -o -name "*.yml" \) \
  -exec echo -e "\n--- FILE: {} ---\n" \; \
  -exec cat {} \; > "../$OUTPUT_FILE"

echo "YAML dump created at ../$OUTPUT_FILE"