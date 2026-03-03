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
