# SquareDeals Implementation Plan

> **Status: Superseded.** This plan targeted a standalone vanilla JS `index.html`. The actual implementation uses SvelteKit + shadcn-svelte. See `thoughts/plans/2026-02-28-slider-calculator.md` for the implemented plan.

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Build a single `index.html` page with three linked sliders (Price, Square Feet, Price Per Sq Foot) that maintain the relationship Price = SqFt × PricePerSqFt, with a mode button cycling which slider is the computed output.

**Architecture:** Single self-contained HTML file. Vanilla JS handles bidirectional sync between each slider and its text input, and recalculates the dependent slider on every change. A mode button cycles through 3 modes (one per dependent variable).

**Tech Stack:** HTML, CSS, vanilla JavaScript — no dependencies.

---

### Task 1: HTML Skeleton

**Files:**
- Create: `index.html`

**Step 1: Create the file with the basic structure**

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>SquareDeals</title>
  <style>
    /* placeholder */
  </style>
</head>
<body>
  <h1>SquareDeals</h1>

  <div id="mode-bar">
    <button id="mode-btn">Mode: Price is computed</button>
  </div>

  <div class="slider-row" id="row-price">
    <label>Price ($)</label>
    <input type="range" id="slider-price" min="50000" max="2000000" step="1000" value="300000">
    <input type="number" id="text-price" min="50000" max="2000000" step="1000" value="300000">
    <span class="auto-badge" id="badge-price">auto</span>
  </div>

  <div class="slider-row" id="row-sqft">
    <label>Square Feet</label>
    <input type="range" id="slider-sqft" min="200" max="10000" step="10" value="1500">
    <input type="number" id="text-sqft" min="200" max="10000" step="10" value="1500">
    <span class="auto-badge" id="badge-sqft">auto</span>
  </div>

  <div class="slider-row" id="row-ppsf">
    <label>Price Per Sq Ft ($)</label>
    <input type="range" id="slider-ppsf" min="50" max="1000" step="1" value="200">
    <input type="number" id="text-ppsf" min="50" max="1000" step="1" value="200">
    <span class="auto-badge" id="badge-ppsf">auto</span>
  </div>

  <script>
    // placeholder
  </script>
</body>
</html>
```

**Step 2: Open in browser and verify the structure renders**

Open `index.html` in a browser. You should see a heading, a mode button, and 3 slider rows each with a range input, number input, and an "auto" badge.

---

### Task 2: CSS Styling

**Files:**
- Modify: `index.html` — replace `/* placeholder */` in `<style>`

**Step 1: Add layout and visual styles**

```css
*, *::before, *::after { box-sizing: border-box; }

body {
  font-family: system-ui, sans-serif;
  max-width: 640px;
  margin: 40px auto;
  padding: 0 20px;
  background: #f5f5f5;
  color: #222;
}

h1 { font-size: 1.4rem; margin-bottom: 24px; }

#mode-bar {
  margin-bottom: 28px;
}

#mode-btn {
  padding: 8px 16px;
  font-size: 0.9rem;
  cursor: pointer;
  border: 2px solid #4a90d9;
  background: #fff;
  border-radius: 6px;
  color: #4a90d9;
  font-weight: 600;
  transition: background 0.15s, color 0.15s;
}

#mode-btn:hover {
  background: #4a90d9;
  color: #fff;
}

.slider-row {
  display: grid;
  grid-template-columns: 160px 1fr 110px 48px;
  align-items: center;
  gap: 12px;
  margin-bottom: 20px;
  padding: 14px 16px;
  background: #fff;
  border-radius: 8px;
  box-shadow: 0 1px 4px rgba(0,0,0,0.08);
  transition: opacity 0.2s;
}

.slider-row label { font-weight: 600; font-size: 0.9rem; }

input[type="range"] { width: 100%; accent-color: #4a90d9; }

input[type="number"] {
  width: 100%;
  padding: 6px 8px;
  border: 1px solid #ccc;
  border-radius: 4px;
  font-size: 0.9rem;
  text-align: right;
}

.auto-badge {
  font-size: 0.7rem;
  font-weight: 700;
  text-transform: uppercase;
  color: #fff;
  background: #4a90d9;
  border-radius: 4px;
  padding: 2px 6px;
  visibility: hidden; /* shown via JS when row is computed */
}

.slider-row.is-computed {
  opacity: 0.7;
}

.slider-row.is-computed .auto-badge {
  visibility: visible;
}

.slider-row.is-computed input[type="range"],
.slider-row.is-computed input[type="number"] {
  pointer-events: none;
}
```

**Step 2: Verify in browser**

Reload. The rows should be white cards with a label, slider, number box, and hidden badge. The mode button should be styled with a blue border.

---

### Task 3: JavaScript Logic

**Files:**
- Modify: `index.html` — replace `// placeholder` in `<script>`

**Step 1: Add the full JS**

```javascript
const sliders = {
  price: { slider: document.getElementById('slider-price'), text: document.getElementById('text-price'), row: document.getElementById('row-price'), badge: document.getElementById('badge-price') },
  sqft:  { slider: document.getElementById('slider-sqft'),  text: document.getElementById('text-sqft'),  row: document.getElementById('row-sqft'),  badge: document.getElementById('badge-sqft') },
  ppsf:  { slider: document.getElementById('slider-ppsf'),  text: document.getElementById('text-ppsf'),  row: document.getElementById('row-ppsf'),  badge: document.getElementById('badge-ppsf') },
};

// modes[i] = which key is the computed (dependent) slider
const modes = ['price', 'sqft', 'ppsf'];
const modeLabels = ['Price is computed', 'Sq Ft is computed', 'Price/SqFt is computed'];
let currentMode = 0;

const modeBtn = document.getElementById('mode-btn');

function getValues() {
  return {
    price: parseFloat(sliders.price.slider.value),
    sqft:  parseFloat(sliders.sqft.slider.value),
    ppsf:  parseFloat(sliders.ppsf.slider.value),
  };
}

function clamp(val, min, max) {
  return Math.min(Math.max(val, min), max);
}

function compute() {
  const computed = modes[currentMode];
  const v = getValues();

  let result;
  if (computed === 'price') {
    result = v.sqft * v.ppsf;
    result = clamp(result, 50000, 2000000);
    setValue('price', result);
  } else if (computed === 'sqft') {
    const denom = Math.max(v.ppsf, 50); // avoid div by zero
    result = v.price / denom;
    result = clamp(result, 200, 10000);
    setValue('sqft', result);
  } else {
    const denom = Math.max(v.sqft, 200); // avoid div by zero
    result = v.price / denom;
    result = clamp(result, 50, 1000);
    setValue('ppsf', result);
  }
}

function setValue(key, val) {
  const rounded = Math.round(val);
  sliders[key].slider.value = rounded;
  sliders[key].text.value = rounded;
}

function applyModeUI() {
  const computed = modes[currentMode];
  for (const key of Object.keys(sliders)) {
    sliders[key].row.classList.toggle('is-computed', key === computed);
  }
  modeBtn.textContent = 'Mode: ' + modeLabels[currentMode];
}

modeBtn.addEventListener('click', () => {
  currentMode = (currentMode + 1) % modes.length;
  applyModeUI();
  compute();
});

// Wire up each slider and text input
for (const [key, els] of Object.entries(sliders)) {
  els.slider.addEventListener('input', () => {
    els.text.value = els.slider.value;
    compute();
  });

  els.text.addEventListener('input', () => {
    const val = parseFloat(els.text.value);
    if (!isNaN(val)) {
      els.slider.value = val;
      compute();
    }
  });
}

// Initialize
applyModeUI();
compute();
```

**Step 2: Verify in browser**

1. Page loads with Price in "auto" mode (greyed, badge visible)
2. Move the SqFt slider → Price updates
3. Move the PricePerSqFt slider → Price updates
4. Click Mode button → Sq Ft becomes computed
5. Move Price or PricePerSqFt → SqFt updates
6. Click Mode again → PricePerSqFt becomes computed
7. Type a value into a text box → corresponding slider moves, computed value updates

---
