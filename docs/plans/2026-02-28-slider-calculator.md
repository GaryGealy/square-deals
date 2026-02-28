# SquareDeals Slider Calculator Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Build a `/calculator` page with three linked sliders (Price, Square Feet, Price Per Sq Ft) that maintain the relationship `Price = SqFt x PricePerSqFt`, with a toggle group to select which value is auto-computed.

**Architecture:** A single SvelteKit page component using Svelte 5 runes for reactive state. Three `$state` variables hold the slider values, and a `$effect` recomputes the dependent value whenever inputs change. shadcn-svelte components (Slider, ToggleGroup, Card, Input, Label, Badge) provide the UI.

**Tech Stack:** SvelteKit 5, Svelte 5 runes, shadcn-svelte, Tailwind CSS 4

---

### Task 1: Install shadcn-svelte Slider and ToggleGroup Components

**Files:**
- Created by CLI: `app/src/lib/components/ui/slider/` (new)
- Created by CLI: `app/src/lib/components/ui/toggle-group/` (new)

**Step 1: Install the slider component**

Run from the `app/` directory:

```bash
cd app && npx shadcn-svelte@latest add slider
```

Expected: New files created in `app/src/lib/components/ui/slider/`.

**Step 2: Install the toggle-group component**

```bash
cd app && npx shadcn-svelte@latest add toggle-group
```

Expected: New files created in `app/src/lib/components/ui/toggle-group/`.

**Step 3: Verify installation**

```bash
ls app/src/lib/components/ui/slider/ app/src/lib/components/ui/toggle-group/
```

Expected: Both directories exist with `.svelte` files and `index.ts`.

**Step 4: Commit**

```bash
git add app/src/lib/components/ui/slider app/src/lib/components/ui/toggle-group
git commit -m "feat: install shadcn-svelte slider and toggle-group components"
```

---

### Task 2: Create the Calculator Page

**Files:**
- Create: `app/src/routes/calculator/+page.svelte`

**Step 1: Create the route directory**

```bash
mkdir -p app/src/routes/calculator
```

**Step 2: Write the calculator page**

Create `app/src/routes/calculator/+page.svelte`:

```svelte
<script lang="ts">
	import { Slider } from '$lib/components/ui/slider/index.js';
	import * as ToggleGroup from '$lib/components/ui/toggle-group/index.js';
	import * as Card from '$lib/components/ui/card/index.js';
	import { Input } from '$lib/components/ui/input/index.js';
	import { Label } from '$lib/components/ui/label/index.js';
	import { Badge } from '$lib/components/ui/badge/index.js';

	type Mode = 'price' | 'sqft' | 'ppsf';

	let mode: Mode = $state('price');
	let price = $state(300000);
	let sqft = $state(1500);
	let ppsf = $state(200);

	function clamp(val: number, min: number, max: number): number {
		return Math.min(Math.max(val, min), max);
	}

	function roundTo(val: number, step: number): number {
		return Math.round(val / step) * step;
	}

	$effect(() => {
		if (mode === 'price') {
			price = roundTo(clamp(sqft * ppsf, 50000, 2000000), 1000);
		} else if (mode === 'sqft') {
			sqft = roundTo(clamp(price / Math.max(ppsf, 50), 200, 10000), 10);
		} else {
			ppsf = roundTo(clamp(price / Math.max(sqft, 200), 50, 1000), 1);
		}
	});

	const sliders = [
		{ key: 'price' as Mode, label: 'Price ($)', min: 50000, max: 2000000, step: 1000 },
		{ key: 'sqft' as Mode, label: 'Square Feet', min: 200, max: 10000, step: 10 },
		{ key: 'ppsf' as Mode, label: 'Price Per Sq Ft ($)', min: 50, max: 1000, step: 1 }
	] as const;

	function getValue(key: Mode): number {
		if (key === 'price') return price;
		if (key === 'sqft') return sqft;
		return ppsf;
	}

	function setValue(key: Mode, val: number): void {
		if (key === 'price') price = val;
		else if (key === 'sqft') sqft = val;
		else ppsf = val;
	}
</script>

<svelte:head>
	<title>SquareDeals — Calculator</title>
</svelte:head>

<div class="mx-auto max-w-2xl px-4 py-10">
	<h1 class="mb-6 text-2xl font-bold">SquareDeals</h1>

	<div class="mb-8">
		<Label class="mb-2 block text-sm text-muted-foreground">Auto-compute:</Label>
		<ToggleGroup.Root type="single" bind:value={mode} variant="outline">
			<ToggleGroup.Item value="price" aria-label="Auto-compute price">Price</ToggleGroup.Item>
			<ToggleGroup.Item value="sqft" aria-label="Auto-compute square feet">Sq Ft</ToggleGroup.Item>
			<ToggleGroup.Item value="ppsf" aria-label="Auto-compute price per square foot">$/Sq Ft</ToggleGroup.Item>
		</ToggleGroup.Root>
	</div>

	{#each sliders as s (s.key)}
		{@const isComputed = mode === s.key}
		{@const val = getValue(s.key)}
		<Card.Root class="mb-4 {isComputed ? 'opacity-50' : ''}">
			<Card.Content class="pt-6">
				<div class="mb-3 flex items-center justify-between">
					<Label>{s.label}</Label>
					{#if isComputed}
						<Badge variant="secondary">auto</Badge>
					{/if}
				</div>
				<div class={isComputed ? 'pointer-events-none' : ''}>
					<Slider
						type="single"
						value={val}
						onValueChange={(v) => setValue(s.key, v)}
						min={s.min}
						max={s.max}
						step={s.step}
						class="mb-3"
					/>
					<Input
						type="number"
						value={val}
						oninput={(e) => {
							const parsed = parseFloat(e.currentTarget.value);
							if (!isNaN(parsed)) setValue(s.key, clamp(parsed, s.min, s.max));
						}}
						min={s.min}
						max={s.max}
						step={s.step}
						class="w-32 text-right"
					/>
				</div>
			</Card.Content>
		</Card.Root>
	{/each}
</div>
```

**Key design decisions in this code:**

- **`$effect` for computation**: Reads the two non-computed values and writes the computed one. No infinite loop because the written variable is never read in the same branch.
- **`roundTo()`**: Rounds computed values to match each slider's step size (Price to nearest $1,000, SqFt to nearest 10, PricePerSqFt to nearest $1).
- **Mode switching**: When mode changes, the `$effect` re-runs and uses whatever values are currently in state — the previously-computed value naturally freezes at its last value.
- **`pointer-events-none`**: Prevents interaction with the computed row's slider and input.
- **`onValueChange` on Slider**: Using the callback prop rather than `bind:value` because the Slider component's `value` prop for `type="single"` might be typed as a single number while `bind:value` might expect array handling. The callback gives us explicit control.
- **`oninput` on Input**: Using native event handler instead of `bind:value` for the number input so we can parse and clamp the value before updating state.

**Step 3: Run type checking**

```bash
cd app && npm run check
```

Expected: No type errors.

**Step 4: Commit**

```bash
git add app/src/routes/calculator/+page.svelte
git commit -m "feat: add calculator page with linked sliders"
```

---

### Task 3: Verify in Browser

**Step 1: Start the dev server**

```bash
cd app && npm run dev
```

**Step 2: Open http://localhost:5173/calculator**

**Step 3: Manual verification checklist**

#### Automated Verification:

- [ ] Type checking passes: `npm run check`
- [ ] Linting passes: `npm run lint`

#### Manual Verification:

- [ ] Page loads with "Price" toggle active and Price row showing "auto" badge at reduced opacity
- [ ] Moving the SqFt slider updates the Price value
- [ ] Moving the $/SqFt slider updates the Price value
- [ ] Clicking "Sq Ft" toggle: SqFt row becomes auto, Price row becomes interactive
- [ ] Moving Price or $/SqFt sliders updates SqFt value
- [ ] Clicking "$/Sq Ft" toggle: $/SqFt row becomes auto
- [ ] Moving Price or SqFt sliders updates $/SqFt value
- [ ] Typing in a number input updates the corresponding slider position
- [ ] Computed values stay within their min/max range
- [ ] Computed row's slider and input are not interactive (pointer-events-none)

**Implementation Note**: After completing this task and all automated verification passes, pause here for manual confirmation from the human that the manual testing was successful.

---

### Task 4: Fix Issues and Final Commit

After manual verification, address any issues found. This task is only needed if adjustments are required from Task 3 manual testing.

**Step 1: Fix any identified issues**

Make targeted fixes based on manual testing feedback.

**Step 2: Run checks**

```bash
cd app && npm run check && npm run lint
```

**Step 3: Commit**

```bash
git add -A
git commit -m "fix: address calculator feedback from manual testing"
```

---

## What We're NOT Doing

- No server-side data loading (purely client-side calculator)
- No database changes
- No unit or e2e tests (unless explicitly requested)
- No dark mode support beyond what shadcn-svelte provides by default
- No URL parameter persistence for slider values
- No changes to the root page or layout
- No number formatting (commas, dollar signs) in inputs

## References

- Design doc: `docs/plans/2026-02-28-slider-calculator-design.md`
- Original design spec: `thoughts/specs/2026-02-25-real-estate-slider-calculator-design.md`
- Original vanilla JS plan: `thoughts/specs/2026-02-25-real-estate-slider-calculator.md`
