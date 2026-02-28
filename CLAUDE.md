# Claude Code Instructions

## Git & GitHub

- **Never commit to main directly**: Always create a branch, even for hotfixes — `git checkout -b fix/description`
- **Standard flow**: `git checkout -b feature-name` → commit → push → PR → merge → cleanup
- **PR workflow**: Use `gh pr create`, `gh pr merge`, `gh pr view` for PR operations
- **No PR template**: Create PRs with Summary + Test plan sections manually
- **Branch cleanup**: After merge, delete local (`git branch -d`) and remote (`git push origin --delete`) branches

## Code Quality

- **Pre-PR checks**: Run type checks, lint, and tests before creating PRs
- **Reproducible installs**: Use `npm ci` instead of `npm install` to match CI environment

## Project Structure

- **All dev commands run from `app/`**: `cd app && npm run dev|check|lint|build`
- **Dev server**: `http://localhost:5173`
- **Svelte 5 runes**: Use `$state`, `$derived`, `$effect` — not older reactive stores or `$:` syntax
- **shadcn-svelte components**: Install with `npx shadcn-svelte@latest add <component>` from `app/`
- **Specs**: `thoughts/specs/` for design/feature specs
- **Plans**: `thoughts/plans/` for implementation plans
