# Design System Document: The Hidden Word (ስውር ቃል)

## 1. Overview & Creative North Star: "The Modern Meskel Square"
The Creative North Star for this design system is **"Cinematic Heritage."** We are not building a generic gaming app; we are crafting a digital ritual. This system balances the ancient soul of Ethiopian storytelling with the high-stakes tension of a modern social deduction game. 

To break the "template" look, we move away from symmetrical, centered layouts. Instead, we utilize **intentional asymmetry**—placing heavy display type against expansive negative space and using overlapping "physical" layers to create a sense of mystery. The UI should feel like a secret being whispered in a crowded room: bold, urgent, and layered.

---

## 2. Colors: Tonal Depth & The "No-Line" Rule
Our palette is rooted in the earth but electrified by the energy of the game.

### Palette Strategy
- **Background (`#1A1A1A`)**: A deep, "obsidian" black that provides a high-contrast stage for drama.
- **Primary Highlights (`#E63946`)**: A spectrum of deep reds and soft corals, used to signal tension, urgency, and the "heat" of the game.
- **Secondary Gold (`#FFD700`)**: Represents the "prize" and the light of truth. Use these for success states and focal points.
- **Tertiary Forest (`#006400`)**: A nod to Ethiopian highlands, used for "safe" zones and progress.

### The "No-Line" Rule
**Strict Prohibition:** Do not use 1px solid borders to section content. Boundaries must be defined through background color shifts. 
- Use `surface-container-low` for secondary sections sitting on a `surface` background.
- Use `surface-container-highest` for interactive elements to make them "pop" against the dark base.

### The "Glass & Gradient" Rule
To add "soul," never use flat fills for large CTAs. Use a subtle linear gradient from `primary` to `primary-container`. For floating overlays, apply **Glassmorphism**: use `surface-variant` at 60% opacity with a `20px` backdrop blur to allow the drama of the game board to bleed through the UI.

---

## 3. Typography: The Bilingual Narrative
The type system is designed to handle the structural differences between Latin and Ethiopic (Amharic) scripts without losing visual weight.

*   **Display & Headlines (Epilogue):** Chosen for its geometric but warm personality. Use `display-lg` (3.5rem) for game reveals to create "slight drama."
*   **Titles & Body (Be Vietnam Pro):** A modern sans-serif that maintains exceptional legibility at small sizes, specifically chosen because its x-height mirrors the visual density of Amharic glyphs.
*   **Labels (Manrope):** High-utility type for the "data" of the game (timers, scores, player counts).

**Hierarchy as Identity:** Use high-contrast scaling. A `display-sm` headline next to `body-sm` metadata creates an editorial, premium feel that a standard uniform scale cannot achieve.

---

## 4. Elevation & Depth: Tonal Layering
We abandon traditional "drop shadows" in favor of physical stacking.

*   **The Layering Principle:** Depth is achieved by "stacking" surface tiers.
    *   *Base:* `surface` (#1A1A1A)
    *   *Section:* `surface-container-low` (#1c1b1b)
    *   *Interactive Card:* `surface-container-high` (#2a2a2a)
*   **Ambient Shadows:** If a card must "float" (e.g., a card reveal), use a shadow with a `40px` blur, `0%` spread, and `8%` opacity, using the `on-surface` color as the tint.
*   **The Ghost Border:** If a boundary is required for accessibility, use `outline-variant` at **15% opacity**. This creates a "suggestion" of a container rather than a hard cage.

---

## 5. Components: Tactile & High-Stakes

### Large "Action" Buttons
Buttons in this system are oversized and tactile.
- **Primary:** `primary-container` fill with `on-primary-container` text. Use `xl` (1.5rem) roundedness.
- **Haptic Intent:** Add a `2px` inner-glow (bottom-aligned) using a lighter tint of the primary color to simulate a physical button being pressed.

### Privacy Reveal Cards
The core of the game.
- **Closed State:** Use a subtle pattern texture (inspired by Ethiopian *Tibeb* weaving) overlaid on `surface-container-highest`.
- **Open State:** Transition to `secondary-container` with a high-energy "shimmer" effect. 
- **Rule:** No dividers. Separate the card "header" from "body" using a vertical spacing of `spacing-4` (1.4rem).

### Input Fields
- **Style:** Underline-only or subtle "sunken" wells.
- **States:** When focused, the "Ghost Border" becomes a vibrant `secondary` (gold) glow.

### The "Secret" Indicator (Special Component)
A custom component for "The Hidden Word." A small, pulsating element using `tertiary` (forest green) with a heavy backdrop blur, placed in an asymmetrical corner of the screen to indicate a secret is active.

---

## 6. Do’s and Don’ts

### Do:
- **Do** use `spacing-10` and `spacing-12` for generous margins; white space is a luxury.
- **Do** overlap elements. Let a card sit 20px over a header to create depth.
- **Do** use "Warm Earth" tones for background surfaces and "Vibrant High-Energy" tones for interaction.

### Don't:
- **Don't** use 100% white (#FFFFFF). Use `secondary` (#fff9ef) for high-contrast text to reduce eye strain and maintain the "warm" heritage feel.
- **Don't** use standard "Material Design" shadows. They feel like software; we want this to feel like a game.
- **Don't** use dividers or lines. If you feel you need a line, use a `0.7rem` (spacing-2) gap instead.

### Accessibility Note:
Ensure that while we use "Ghost Borders" and tonal shifts, the contrast between `on-surface` text and `surface-container` backgrounds always meets a minimum of 4.5:1, especially for the Amharic script which requires higher clarity.