<script lang="ts">
	import { Slider } from '$lib/components/ui/slider/index.js';
	import * as Card from '$lib/components/ui/card/index.js';
	import { Input } from '$lib/components/ui/input/index.js';
	import { Label } from '$lib/components/ui/label/index.js';

	let price = $state(300000);
	let sqft = $state(1500);
	let ppsf = $state(200);

	function clamp(val: number, min: number, max: number): number {
		return Math.min(Math.max(val, min), max);
	}

	function roundTo(val: number, step: number): number {
		return Math.round(val / step) * step;
	}

	function onPriceChange(val: number) {
		price = val;
		ppsf = roundTo(clamp(price / Math.max(sqft, 200), 50, 1000), 1);
	}

	function onPpsfChange(val: number) {
		ppsf = val;
		price = roundTo(clamp(sqft * ppsf, 50000, 2000000), 1000);
	}

	function onSqftChange(val: number) {
		sqft = val;
		price = roundTo(clamp(sqft * ppsf, 50000, 2000000), 1000);
	}
</script>

<svelte:head>
	<title>SquareDeals — Calculator</title>
</svelte:head>

<div class="mx-auto max-w-2xl px-4 py-10">
	<h1 class="mb-6 text-2xl font-bold">SquareDeals</h1>

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
					if (!isNaN(parsed)) onSqftChange(clamp(parsed, 200, 10000));
				}}
				min={200}
				max={10000}
				step={10}
				class="w-32 text-right"
			/>
		</Card.Content>
	</Card.Root>

	<Card.Root class="mb-4">
		<Card.Content class="pt-6">
			<div class="mb-3">
				<Label>Price ($)</Label>
			</div>
			<Slider
				type="single"
				value={price}
				onValueChange={onPriceChange}
				min={50000}
				max={2000000}
				step={1000}
				class="mb-3"
			/>
			<Input
				type="number"
				value={price}
				oninput={(e) => {
					const parsed = parseFloat(e.currentTarget.value);
					if (!isNaN(parsed)) onPriceChange(clamp(parsed, 50000, 2000000));
				}}
				min={50000}
				max={2000000}
				step={1000}
				class="w-32 text-right"
			/>
		</Card.Content>
	</Card.Root>

	<Card.Root class="mb-4">
		<Card.Content class="pt-6">
			<div class="mb-3">
				<Label>Price Per Sq Ft ($)</Label>
			</div>
			<Slider
				type="single"
				value={ppsf}
				onValueChange={onPpsfChange}
				min={50}
				max={1000}
				step={1}
				class="mb-3"
			/>
			<Input
				type="number"
				value={ppsf}
				oninput={(e) => {
					const parsed = parseFloat(e.currentTarget.value);
					if (!isNaN(parsed)) onPpsfChange(clamp(parsed, 50, 1000));
				}}
				min={50}
				max={1000}
				step={1}
				class="w-32 text-right"
			/>
		</Card.Content>
	</Card.Root>
</div>
