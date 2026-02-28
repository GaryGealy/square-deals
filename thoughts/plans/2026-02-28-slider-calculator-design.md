# SquareDeals Slider Calculator — Design

## Summary

A real estate calculator at `/calculator` with three linked sliders (Price, Square Feet, Price Per Sq Ft) that maintain the relationship `Price = SqFt x PricePerSqFt`. A toggle group lets the user choose which value is auto-computed. Built with SvelteKit 5, shadcn-svelte components, and Tailwind CSS 4.

## Behavior

### Core Relationship

```
Price = Square Feet x Price Per Square Foot
```

### Mode Selection

A 3-button toggle group (shadcn-svelte ToggleGroup, `type="single"`) lets the user pick which value is auto-computed:

- **Price** — SqFt and PricePerSqFt are user-controlled; Price is derived
- **Sq Ft** — Price and PricePerSqFt are user-controlled; SqFt is derived
- **$/Sq Ft** — Price and SqFt are user-controlled; PricePerSqFt is derived

When the mode changes, the previously-computed value freezes at its current value (written back to state), and the newly-selected value starts being derived.

### Slider Rows

Each row contains:
- **Label** (shadcn-svelte Label)
- **Slider** (shadcn-svelte Slider, `type="single"`, `bind:value`)
- **Number Input** (shadcn-svelte Input, `type="number"`, bidirectionally synced with slider)
- **Badge** (shadcn-svelte Badge) — shows "auto" only on the computed row

The computed row gets `opacity-50` and `pointer-events-none` on its interactive elements.

## Ranges

| Slider         | Min     | Max        | Step   |
|----------------|---------|------------|--------|
| Price          | $50,000 | $2,000,000 | $1,000 |
| Square Feet    | 200     | 10,000     | 10     |
| Price Per SqFt | $50     | $1,000     | $1     |

## Edge Cases

- **Division by zero**: Clamp denominator to its minimum value before dividing (SqFt min 200, PricePerSqFt min 50)
- **Out-of-range results**: Clamp computed values to their slider's min/max range
- **Mode switching**: Freeze the current computed value into state before switching

## Architecture

### Route

```
app/src/routes/calculator/+page.svelte
```

No server-side data loading needed — purely client-side calculator.

### State Model (Svelte 5 Runes)

```typescript
let mode: 'price' | 'sqft' | 'ppsf' = $state('price');
let price = $state(300000);
let sqft = $state(1500);
let ppsf = $state(200);
```

The computed value is derived using `$derived` based on the current mode. The two non-computed values are directly user-controlled via their sliders/inputs.

### Components Used

| Component    | Source          | Status     |
|-------------|-----------------|------------|
| Slider      | shadcn-svelte   | To install |
| ToggleGroup | shadcn-svelte   | To install |
| Card        | shadcn-svelte   | Installed  |
| Input       | shadcn-svelte   | Installed  |
| Label       | shadcn-svelte   | Installed  |
| Badge       | shadcn-svelte   | Installed  |

### Layout

Centered column (`max-w-2xl mx-auto`) with:
1. Page heading: "SquareDeals"
2. Mode toggle group (3 buttons)
3. Three slider row cards

### Styling

- Tailwind CSS utility classes throughout
- shadcn-svelte design tokens (no hardcoded colors)
- Computed row: reduced opacity + pointer-events-none + visible "auto" badge

## References

- Design spec: `thoughts/specs/2026-02-25-real-estate-slider-calculator-design.md`
- Original implementation plan (vanilla JS): `thoughts/specs/2026-02-25-real-estate-slider-calculator.md`
