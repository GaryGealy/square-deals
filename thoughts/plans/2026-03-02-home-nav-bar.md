# Home Page & Navigation Bar Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Add a persistent top nav bar to every page and replace the placeholder home page with a tool dashboard (card grid), establishing SquareDeals as a multi-tool hub.

**Architecture:** A shared `tools.ts` config drives both the nav bar (in `+layout.svelte`) and the home page card grid (`+page.svelte`). Adding a new tool in the future requires only appending one entry to the tools array. The nav lives in the root layout so it renders on every page.

**Tech Stack:** SvelteKit 5, Svelte 5 runes, shadcn-svelte (Card, Button — already installed), Tailwind CSS 4, Lucide Svelte (already installed)

---

### Task 1: Create the Tools Config

**Files:**
- Create: `app/src/lib/tools.ts`

**Step 1: Create the tools config**

Create `app/src/lib/tools.ts`:

```ts
export interface Tool {
	name: string;
	description: string;
	href: string;
}

export const tools: Tool[] = [
	{
		name: 'Calculator',
		description: 'Explore the relationship between price, square footage, and price per sq ft.',
		href: '/calculator'
	}
];
```

**Step 2: Run type check**

```bash
cd app && npm run check
```

Expected: No errors.

**Step 3: Commit**

```bash
git add app/src/lib/tools.ts
git commit -m "feat: add tools config for nav and home page"
```

---

### Task 2: Replace Home Page with Tool Dashboard

**Files:**
- Modify: `app/src/routes/+page.svelte`

The home page becomes a card grid. Each tool gets a Card with its name, description, and an "Open" button that navigates to the tool. Uses the `tools` array from Task 1.

**Step 1: Replace the home page**

Overwrite `app/src/routes/+page.svelte` with:

```svelte
<script lang="ts">
	import { tools } from '$lib/tools';
	import * as Card from '$lib/components/ui/card/index.js';
	import { Button } from '$lib/components/ui/button/index.js';
</script>

<svelte:head>
	<title>SquareDeals</title>
</svelte:head>

<div class="mx-auto max-w-4xl px-4 py-10">
	<h1 class="mb-2 text-3xl font-bold">SquareDeals</h1>
	<p class="text-muted-foreground mb-8">Real estate tools to help you think clearly about price.</p>

	<div class="grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
		{#each tools as tool}
			<Card.Root>
				<Card.Header>
					<Card.Title>{tool.name}</Card.Title>
					<Card.Description>{tool.description}</Card.Description>
				</Card.Header>
				<Card.Footer>
					<Button href={tool.href}>Open</Button>
				</Card.Footer>
			</Card.Root>
		{/each}
	</div>
</div>
```

**Step 2: Run type check**

```bash
cd app && npm run check
```

Expected: No errors.

**Step 3: Commit**

```bash
git add app/src/routes/+page.svelte
git commit -m "feat: replace home page with tool dashboard card grid"
```

---

### Task 3: Add Nav Bar to Layout

**Files:**
- Modify: `app/src/routes/+layout.svelte`

The nav bar renders on every page (layout wraps all routes). It shows the app name as a home link on the left and tool links on the right, driven by the same `tools` array.

**Step 1: Update the layout**

Overwrite `app/src/routes/+layout.svelte` with:

```svelte
<script lang="ts">
	import '../app.css';
	import favicon from '$lib/assets/favicon.svg';
	import { tools } from '$lib/tools';

	let { children } = $props();
</script>

<svelte:head>
	<link rel="icon" href={favicon} />
</svelte:head>

<header class="border-b">
	<nav class="mx-auto flex max-w-4xl items-center gap-6 px-4 py-3">
		<a href="/" class="font-semibold tracking-tight">SquareDeals</a>
		{#each tools as tool}
			<a href={tool.href} class="text-muted-foreground hover:text-foreground text-sm transition-colors">
				{tool.name}
			</a>
		{/each}
	</nav>
</header>

{@render children()}
```

**Step 2: Run type check**

```bash
cd app && npm run check
```

Expected: No errors.

**Step 3: Commit**

```bash
git add app/src/routes/+layout.svelte
git commit -m "feat: add persistent top nav bar to layout"
```

---

### Task 4: Lint and Manual Verification

**Step 1: Run lint**

```bash
cd app && npm run lint
```

Expected: No errors. If Prettier flags formatting issues, run `npm run format` then re-check.

**Step 2: Start the dev server**

```bash
cd app && npm run dev
```

**Step 3: Manual verification checklist**

Navigate to `http://localhost:5173` and verify:

- [ ] Home page (`/`) shows "SquareDeals" heading and subtitle
- [ ] Home page shows a card for "Calculator" with description and "Open" button
- [ ] Clicking "Open" navigates to `/calculator`
- [ ] Nav bar is visible on the home page with "SquareDeals" brand link and "Calculator" link
- [ ] Nav bar is visible on the calculator page (`/calculator`)
- [ ] Clicking "SquareDeals" in the nav navigates to `/`
- [ ] Clicking "Calculator" in the nav navigates to `/calculator`
- [ ] Nav bar brand link and tool links are visually distinct (tool links muted, brand bold)

**Step 4: Commit any formatting fixes**

Only if `npm run format` made changes:

```bash
git add -A
git commit -m "style: apply prettier formatting"
```

---

## What We're NOT Doing

- No active/current-route highlighting on nav links (can be added later)
- No mobile hamburger menu (can be added when needed)
- No tool icons on the cards (can be added when more tools exist)
- No categories or grouping of tools
- No changes to the calculator page itself

## References

- Tools config: `app/src/lib/tools.ts`
- Layout: `app/src/routes/+layout.svelte`
- Home page: `app/src/routes/+page.svelte`
- Tech stack: `thoughts/tech-stack.md`
