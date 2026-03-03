import type { Pathname } from '$app/types';

export interface Tool {
	name: string;
	description: string;
	href: Pathname;
}

export const tools: Tool[] = [
	{
		name: 'Calculator',
		description: 'Explore the relationship between price, square footage, and price per sq ft.',
		href: '/calculator'
	}
];
