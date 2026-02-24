#!/bin/bash
set -e

# -----------------------------------------------------------------------------
# setup-cloudflare.sh
# Creates a Cloudflare D1 database and writes the config into app/wrangler.toml.
# Run from the root of your forked humanlayer-scaffolding repo.
# Requires: wrangler installed and authenticated (wrangler login)
# -----------------------------------------------------------------------------

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
APP_DIR="$ROOT_DIR/app"
WRANGLER_TOML="$APP_DIR/wrangler.toml"

echo ""
echo "================================"
echo " Cloudflare D1 setup"
echo "================================"
echo ""

# Check wrangler is available
if ! command -v wrangler &> /dev/null; then
  echo "Error: wrangler not found. Install it with: npm install -g wrangler"
  exit 1
fi

# Check app/ exists
if [ ! -d "$APP_DIR" ]; then
  echo "Error: app/ directory not found. Run scripts/setup-app.sh first."
  exit 1
fi

# Prompt for app and DB names
read -p "Enter your app name (e.g. my-app): " APP_NAME
read -p "Enter your D1 database name (e.g. my-app-db): " DB_NAME

echo ""
echo "Logging in to Cloudflare (if not already)..."
wrangler whoami 2>/dev/null || wrangler login

echo ""
echo "Creating D1 database: $DB_NAME..."
DB_OUTPUT=$(wrangler d1 create "$DB_NAME" 2>&1)
echo "$DB_OUTPUT"

# Extract the database_id from wrangler output
DB_ID=$(echo "$DB_OUTPUT" | grep -oE '[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}' | head -1)

if [ -z "$DB_ID" ]; then
  echo ""
  echo "Could not automatically extract database ID from wrangler output."
  read -p "Please enter the database_id manually: " DB_ID
fi

echo ""
echo "Writing wrangler.toml..."

cat > "$WRANGLER_TOML" <<EOF
name = "$APP_NAME"
compatibility_date = "2025-01-01"
compatibility_flags = ["nodejs_compat"]
pages_build_output_dir = ".svelte-kit/cloudflare"

[[d1_databases]]
binding = "DB"
database_name = "$DB_NAME"
database_id = "$DB_ID"
EOF

echo ""
echo "================================"
echo " Cloudflare setup complete!"
echo "================================"
echo ""
echo "wrangler.toml written to: $WRANGLER_TOML"
echo ""
echo "Next steps:"
echo "  1. Add these secrets to your GitHub repo (Settings → Secrets → Actions):"
echo "     - CLOUDFLARE_API_TOKEN"
echo "     - CLOUDFLARE_ACCOUNT_ID"
echo "     - CLOUDFLARE_DATABASE_ID  (your DB ID: $DB_ID)"
echo "     - CLOUDFLARE_D1_TOKEN"
echo ""
echo "  2. Set up Cloudflare Pages:"
echo "     - Go to dash.cloudflare.com → Workers & Pages → Create"
echo "     - Connect your GitHub repo"
echo "     - Build command:        npm run build"
echo "     - Build output dir:     .svelte-kit/cloudflare"
echo ""
echo "  3. Apply migrations to production:"
echo "     cd app && npm run db:migrate:remote"
echo ""
echo "  4. Deploy by pushing to the cloudflare branch:"
echo "     git push origin main:cloudflare"
echo ""
