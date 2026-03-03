<script lang="ts">
	import { Slider } from '$lib/components/ui/slider/index.js';
	import * as ToggleGroup from '$lib/components/ui/toggle-group/index.js';
	import * as Card from '$lib/components/ui/card/index.js';
	import { Input } from '$lib/components/ui/input/index.js';
	import { Label } from '$lib/components/ui/label/index.js';
	import { Badge } from '$lib/components/ui/badge/index.js';

	type Mode = 'price' | 'ppsf';

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
		} else {
			ppsf = roundTo(clamp(price / Math.max(sqft, 200), 50, 1000), 1);
		}
	});

	const sliders = [
		{ key: 'price' as Mode, label: 'Price ($)', min: 50000, max: 2000000, step: 1000 },
		{ key: 'ppsf' as Mode, label: 'Price Per Sq Ft ($)', min: 50, max: 1000, step: 1 }
	] as const;

	function getValue(key: Mode): number {
		if (key === 'price') return price;
		return ppsf;
	}

	function setValue(key: Mode, val: number): void {
		if (key === 'price') price = val;
		else ppsf = val;
	}
</script>

<svelte:head>
	<title>SquareDeals — Calculator</title>
</svelte:head>

<div class="mx-auto max-w-2xl px-4 py-10">
	<h1 class="mb-6 text-2xl font-bold">SquareDeals</h1>

	<div class="mb-8">
		<Label class="text-muted-foreground mb-2 block text-sm">Auto-compute:</Label>
		<ToggleGroup.Root type="single" bind:value={mode} variant="outline">
			<ToggleGroup.Item value="price" aria-label="Auto-compute price">Price</ToggleGroup.Item>
			<ToggleGroup.Item value="ppsf" aria-label="Auto-compute price per square foot"
				>$/Sq Ft</ToggleGroup.Item
			>
		</ToggleGroup.Root>
	</div>

	<Card.Root class="mb-4">
		<Card.Content class="pt-6">
			<div class="mb-3">
				<Label>Square Feet</Label>
			</div>
			<Input
				type="number"
				value={sqft}
				oninput={(e) => {
					const parsed = parseFloat(e.currentTarget.value);
					if (!isNaN(parsed)) sqft = clamp(parsed, 200, 10000);
				}}
				min={200}
				max={10000}
				step={10}
				class="w-32 text-right"
			/>
		</Card.Content>
	</Card.Root>

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
						onValueChange={(v: number) => setValue(s.key, v)}
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
