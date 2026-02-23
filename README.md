# humanlayer-scaffolding

A starting point for new projects using the HumanLayer Claude setup.

## Getting Started

1. **Fork this repo** on GitHub to use it as the base for your new project

2. **Clone your fork** locally
   ```bash
   git clone https://github.com/<your-username>/<your-new-repo>.git
   cd <your-new-repo>
   ```

3. **Init your tech stack**, for example if using Svelte:
   ```bash
   npm create svelte@latest .
   ```

4. **Add your design specs** — create markdown files in the `thoughts/` folder describing what you want to build

5. **Start building** — the `.claude/` folder is already set up and ready to use

## Global Plugins

These plugins should be installed globally in `~/.claude/settings.json` to get the full experience:

| Plugin | Purpose |
|--------|---------|
| **superpowers** | Structured dev workflow (brainstorming, TDD, subagent-driven dev) |
| **plugin-dev** | Tools for building Claude Code plugins |
| **frontend-design** | Production-grade frontend UI generation |
| **feature-dev** | Guided feature development with architecture focus |
| **github** | GitHub integration (issues, PRs, etc.) |
| **playwright** | Browser automation and testing |
| **claude-md-management** | Audit and improve CLAUDE.md files |
| **code-simplifier** | Refactor and simplify code for clarity |
| **stripe** | Stripe integration best practices and helpers |

All plugins are from the `claude-plugins-official` marketplace. Install them with:

```bash
/plugin marketplace add claude-plugins-official
/plugin install superpowers@claude-plugins-official
/plugin install plugin-dev@claude-plugins-official
/plugin install frontend-design@claude-plugins-official
/plugin install feature-dev@claude-plugins-official
/plugin install github@claude-plugins-official
/plugin install playwright@claude-plugins-official
/plugin install claude-md-management@claude-plugins-official
/plugin install code-simplifier@claude-plugins-official
/plugin install stripe@claude-plugins-official
```
