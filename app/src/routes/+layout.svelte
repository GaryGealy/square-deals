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
		<a href="/" class="flex items-center gap-2 font-semibold tracking-tight">
			<img src="/square-deals-logo.png" alt="SquareDeals logo" class="h-8 w-auto" />
			SquareDeals
		</a>
		{#each tools as tool}
			<a
				href={tool.href}
				class="text-muted-foreground hover:text-foreground text-sm transition-colors"
			>
				{tool.name}
			</a>
		{/each}
	</nav>
</header>

{@render children()}
