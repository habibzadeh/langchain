#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail
set -o xtrace

SCRIPT_DIR="$(cd "$(dirname "$0")"; pwd)"
cd "${SCRIPT_DIR}"

mkdir -p ../_dist
rsync -ruv . ../_dist
cd ../_dist
poetry run python scripts/model_feat_table.py
find . -name "*.ipynb" -exec sed -i 's/```/\\`\\`\\`/g' {} \;
poetry run nbdoc_build --srcdir docs --pause 0
cp ../cookbook/README.md src/pages/cookbook.mdx
cp ../.github/CONTRIBUTING.md docs/contributing.md
mkdir -p docs/templates
cp ../templates/docs/INDEX.md docs/templates/index.md
wget https://raw.githubusercontent.com/langchain-ai/langserve/main/README.md -O docs/langserve.md
poetry run python scripts/generate_api_reference_links.py
yarn install
yarn start
