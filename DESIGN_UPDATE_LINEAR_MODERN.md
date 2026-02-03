# 🌌 Design Update: Linear / Modern

## Overview

The application has been completely transformed to match the **Linear / Modern** design system from `prompt.xml`. This is a sophisticated dark theme with cinematic depth, ambient lighting, and premium developer-tool aesthetics.

## Core Design Principles

### Visual Identity

- **Deep Space Palette**: Near-black backgrounds (#050506) with indigo accents (#5E6AD2)
- **Layered Ambient Lighting**: Multiple animated gradient blobs create cinematic lighting pools
- **Glass Morphism**: Translucent surfaces with backdrop blur and subtle borders
- **Multi-Layer Shadows**: Every elevated surface uses 3-4 shadow layers for realistic depth
- **Precision Micro-Interactions**: 200-300ms transitions with expo-out easing

### Signature Elements

#### 1. Animated Ambient Blobs

Three large, heavily blurred gradient shapes float across the canvas:

- **Primary Blob**: Top-center, indigo accent, 900×1400px
- **Secondary Blob**: Left side, purple/pink mix, 600×800px
- **Tertiary Blob**: Right side, indigo/blue mix, 500×700px

#### 2. Glass Morphism Components

- Cards: Gradient backgrounds with backdrop blur
- Navbar: Semi-transparent with blur effect
- Forms: Elevated glass containers

#### 3. Accent Glow System

- Primary buttons feature signature indigo glow
- Multi-layer shadows: border highlight + diffuse shadow + accent glow
- Inner highlights on interactive surfaces

## Design Tokens

### Colors

```css
--background-deep: #020203 --background-base: #050506
  --background-elevated: #0a0a0c --surface: rgba(255, 255, 255, 0.05)
  --foreground: #ededef --foreground-muted: #8a8f98 --accent: #5e6ad2
  --accent-bright: #6872d9 --border-default: rgba(255, 255, 255, 0.06);
```

### Typography

- **Font**: Inter (400, 500, 600, 700 weights)
- **Tracking**: Tight for headlines, normal for body
- **Line Heights**: Tight for display, relaxed for body

### Shadows

- **Card Default**: Multi-layer with border highlight
- **Card Hover**: Enhanced with accent glow
- **Accent Glow**: Signature indigo glow for CTAs

### Interactions

- **Timing**: 200-300ms cubic-bezier(0.16, 1, 0.3, 1)
- **Hover Movement**: 2-4px translateY
- **Active State**: scale(0.98)

## Component Updates

### Buttons

- **Primary**: Indigo background with accent glow
- **Secondary**: Glass surface with subtle border
- **Outline**: Minimal with border only
- **Ghost**: Text-only with hover background

### Cards

- Gradient backgrounds (white 8% → 2%)
- Backdrop blur for depth
- Inner glow line at top edge
- Hover: Enhanced glow + translateY(-4px)

### Forms

- Glass container with backdrop blur
- Inputs: Dark elevated background
- Focus: Accent border with glow ring
- Rounded corners throughout

### Navbar

- Semi-transparent with backdrop blur
- Subtle bottom border with highlight
- Smooth 300ms transitions

## Files Modified

### CSS

- `app.css`: Complete rewrite of design system
- `ambient-blobs.css`: New file for animated lighting

### JSP

- `header.jsp`: Updated fonts (Inter), added ambient blobs, v=15

## 🚀 How to See Changes

1. **Hard Refresh**: `Ctrl + Shift + R` (Windows) or `Cmd + Shift + R` (Mac)
2. The page should now feature:
   - Deep dark background with floating gradient blobs
   - Indigo accent buttons with glow effects
   - Glass-like cards with subtle transparency
   - Smooth, cinematic interactions

## Design Philosophy

This design feels like **premium developer tools** (Linear, Vercel, Raycast):

- Fast and responsive
- Obsessively crafted details
- Cinematic but not ostentatious
- Technical but inviting
- Dark but not oppressive

The aesthetic is "looking through frosted glass into a high-end application running at night."
