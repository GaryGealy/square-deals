#!/bin/bash
set -e

# -----------------------------------------------------------------------------
# setup-app.sh
# Creates the app/ folder with a SvelteKit project and installs all dependencies.
# Run from the root of your forked humanlayer-scaffolding repo.
# -----------------------------------------------------------------------------

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
APP_DIR="$ROOT_DIR/app"

echo ""
echo "=============================="
echo " humanlayer-scaffolding setup"
echo "=============================="
echo ""

# Check Node.js version
NODE_VERSION=$(node -v | cut -d'v' -f2 | cut -d'.' -f1)
if [ "$NODE_VERSION" -lt 20 ]; then
  echo "Error: Node.js 20+ is required. Current version: $(node -v)"
  exit 1
fi

if [ -d "$APP_DIR" ]; then
  echo "Warning: app/ directory already exists. Skipping SvelteKit init."
else
  echo "Creating SvelteKit app in app/..."
  echo ""
  echo "When prompted, select:"
  echo "  - Template: SvelteKit minimal (skeleton)"
  echo "  - Type checking: TypeScript"
  echo "  - Add-ons: select none (we install manually below)"
  echo ""
  cd "$ROOT_DIR"
  npx sv create app
fi

cd "$APP_DIR"

echo ""
echo "Installing UI libraries..."
npm install bits-ui lucide-svelte svelte-sonner formsnap mode-watcher clsx tailwind-merge tailwind-variants @internationalized/date

echo ""
echo "Installing form & validation..."
npm install sveltekit-superforms zod valibot

echo ""
echo "Installing Tailwind CSS..."
npm install -D tailwindcss @tailwindcss/vite

echo ""
echo "Installing database (Drizzle + SQLite)..."
npm install drizzle-orm better-sqlite3
npm install -D drizzle-kit @types/better-sqlite3

echo ""
echo "Installing authentication..."
npm install bcryptjs
npm install -D @types/bcryptjs

echo ""
echo "Installing testing tools..."
npm install -D @playwright/test vitest @vitest/browser playwright-chromium @axe-core/playwright @faker-js/faker vitest-browser-svelte @vitest/browser

echo ""
echo "Installing code quality tools..."
npm install -D eslint @eslint/js typescript-eslint eslint-plugin-svelte eslint-config-prettier prettier prettier-plugin-svelte prettier-plugin-tailwindcss svelte-check

echo ""
echo "Installing Cloudflare tools..."
npm install -D wrangler @cloudflare/workers-types

echo ""
echo "Installing utilities..."
npm install -D tsx

echo ""
echo "Installing Playwright browsers..."
npx playwright install chromium

echo ""
echo "Copying .env.example..."
cp "$ROOT_DIR/scripts/.env.example" "$APP_DIR/.env.example"

echo ""
echo "=============================="
echo " Setup complete!"
echo "=============================="
echo ""
echo "Next steps:"
echo "  1. Run: bash scripts/setup-cloudflare.sh"
echo "  2. Copy: cp app/.env.example app/.env  (and fill in your values)"
echo "  3. Run:  cd app && npm run db:migrate:local"
echo "  4. Run:  cd app && npm run dev"
echo ""
