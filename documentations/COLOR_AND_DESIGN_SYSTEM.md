# TokenX Color & Design System

## Primary Brand Colors

| Element | Color | Hex Code |
|---------|-------|----------|
| Background | Deep Dark Blue | `#0F0F1E` |
| Primary Brand | Purple | `#667EEA` |
| Primary Dark | Dark Purple | `#764BA2` |
| Text Primary | White | `#FFFFFF` |
| Text Secondary | White 70% | `rgba(255,255,255,0.7)` |
| Text Tertiary | White 60% | `rgba(255,255,255,0.6)` |
| Border | White 10% | `rgba(255,255,255,0.1)` |

## Experiment Tag Color Gradients

### Tag → Gradient Mapping

```
'Deep Learning'     → #667EEA → #764BA2  (Purple gradient)
'NLP'               → #F093FB → #F5576C  (Pink to Red)
'LLM'               → #4FACFE → #00F2FE  (Cyan gradient)
'CNN'               → #FA709A → #FECE34  (Orange to Yellow)
'Classification'    → #30CFD0 → #330867  (Teal to Purple)
'Transformers'      → #1FA2FF → #12D8FA  (Blue to Cyan)
'Vector DB'         → #A8EDEA → #FED6E3  (Mint to Pink)
'RAG'               → #FF9A56 → #FF6A88  (Orange to Red)
```

### Difficulty Badge Colors

| Difficulty | Color | Hex Code | Icon |
|------------|-------|----------|------|
| Beginner | Green | `#10B981` | 🟢 |
| Intermediate | Amber | `#FBBF24` | 🟡 |
| Advanced | Red | `#EF4444` | 🔴 |

## Typography

- **Display Large** (64px, Bold) - Main "TokenX" heading
- **Display Small** (45px, Bold) - Section titles like "Latest Experiments"
- **Headline Small** (24px, Semi-bold) - "Solve with AI" tagline
- **Body Large** (16px, Regular) - Main paragraph text
- **Body Medium** (14px, Regular) - Card descriptions
- **Body Small** (12px, Regular) - Secondary text
- **Label Large** (14px, Semi-bold) - Buttons
- **Label Small** (12px, Semi-bold) - Tags, badges

## Component Sizing

### Experiment Card
- **Width**: Full container width (responsive)
- **Padding**: 16px (mobile), 24px (tablet+)
- **Border Radius**: 16px
- **Shadow**: 
  - Normal: `blur: 10px, offset: (0, 4), opacity: 0.1`
  - Hover: `blur: 20px, offset: (0, 8), opacity: 0.3`

### Hero Section Logo (TX)
- **Width/Height**: 80px (mobile), 120px (tablet+)
- **Border Radius**: 24px
- **Shadow**: `blur: 30px, spread: 5px, opacity: 0.3`

### Buttons (CTA)
- **Padding**: 32px horizontal, 14px vertical
- **Border Radius**: 12px
- **Font Weight**: 600
- **Shadow**: `blur: 20px, opacity: 0.3`

## Spacing Scale

```
4px  - Micro spacing (0.25rem)
8px  - Small spacing (0.5rem)
12px - Medium spacing (0.75rem)
16px - Padding (1rem) - Card padding mobile
24px - Large spacing (1.5rem) - Card padding tablet+
32px - Extra large (2rem)
40px - Section spacing (2.5rem)
48px - Large section padding (3rem)
60px - Hero padding (3.75rem)
80px - XL section spacing (5rem)
100px - XXL hero padding (6.25rem)
```

## Animation Timings

- **Fast**: 200ms (button interactions, hover states)
- **Normal**: 600-800ms (page transitions, card appears)
- **Slow**: 1000-3000ms (hero section, shimmer effects)
- **Easing**: Curves.easeInOut (smooth animation curves)

## Shadow System

### Subtle (Cards at rest)
```dart
BoxShadow(
  color: Colors.black.withOpacity(0.1),
  blurRadius: 10,
  offset: Offset(0, 4),
)
```

### Medium (Cards on hover)
```dart
BoxShadow(
  color: Colors.black.withOpacity(0.3),
  blurRadius: 20,
  offset: Offset(0, 8),
)
```

### Brand (Logo, buttons)
```dart
BoxShadow(
  color: Color(0xFF667EEA).withOpacity(0.3),
  blurRadius: 30,
  spreadRadius: 5,
)
```

## Responsive Breakpoints

```
Mobile:   < 600px   - Vertical stacking, 24px padding
Tablet:   600-1200px - 2-column layouts, 48px padding
Desktop:  > 1200px  - Full layouts, responsive max-width
```

## Border Styling

- **Primary Border**: 1px solid white@10% opacity
- **Accent Border**: 1.5px solid white@10% opacity
- **Difficulty Badge Border**: 1px solid matching color (10B981, FBBF24, EF4444)

## Opacity Hierarchy

```
100% - Primary text, actionable elements
90%  - Secondary text on cards
80%  - Descriptions, body text
70%  - Secondary labels
60%  - Tertiary information
50%  - Disabled states
30%  - Background colors, subtle borders
10%  - Very subtle backgrounds, borders
5%   - Minimal gradient overlays
```

## Implementation Notes

- All colors use Material 3 principles
- Dark theme optimized for reduced eye strain
- Gradients used strategically for visual hierarchy
- Accessibility: Sufficient contrast ratios throughout
- Mobile-first responsive design approach

---

**Use these values consistently across the application for a cohesive, professional design.**
