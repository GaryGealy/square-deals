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
