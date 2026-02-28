# SquareDeals — Design

## Summary

A single self-contained `index.html` file that lets users explore the relationship between
Price, Square Feet, and Price Per Square Foot using synchronized sliders and text inputs.

## Behavior

Three sliders, each with a bidirectionally synced text box to the right.

Mathematical relationship: `Price = Square Feet × Price Per Sq Foot`

A **Mode button** cycles through which slider is the computed (dependent) output:
- Mode 1: **Price** auto-updates (SqFt × PricePerSqFt → Price)
- Mode 2: **Square Feet** auto-updates (Price ÷ PricePerSqFt → SqFt)
- Mode 3: **Price Per Sq Foot** auto-updates (Price ÷ SqFt → PricePerSqFt)

The computed slider and text box are visually indicated (greyed out / labeled "auto").

## Ranges

| Slider          | Min    | Max    | Step  |
|-----------------|--------|--------|-------|
| Price           | $50,000 | $2,000,000 | $1,000 |
| Square Feet     | 200    | 10,000 | 10    |
| Price Per SqFt  | $50    | $1,000 | $1    |

## Edge Cases

- Division by zero: clamp denominator to its minimum value before dividing.

## Implementation

- Vanilla JS, single HTML file, no dependencies.
