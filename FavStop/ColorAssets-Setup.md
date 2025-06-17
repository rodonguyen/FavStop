# Color Assets Setup Guide

To enable proper dark mode support, you need to create color assets in Xcode. Follow these steps:

## 1. Open Assets.xcassets in Xcode

## 2. Create Color Sets
Right-click on Assets.xcassets → New Color Set for each of these:

### Brand Colors
- **BrandPrimary**
  - Light: #28A55F (Green)
  - Dark: #34C759 (Brighter Green)

- **BrandSecondary** 
  - Light: #007AFF (Blue)
  - Dark: #0A84FF (Brighter Blue)

### Semantic Colors
- **Background**
  - Light: #FFFFFF (White)
  - Dark: #000000 (Black)

- **Surface**
  - Light: #F2F2F7 (Light Gray)
  - Dark: #1C1C1E (Dark Gray)

- **TextPrimary**
  - Light: #000000 (Black)
  - Dark: #FFFFFF (White)

- **TextSecondary**
  - Light: #6D6D80 (Gray)
  - Dark: #8E8E93 (Light Gray)

## 3. Configure Each Color Set
For each color set:
1. Select the color set
2. In Attributes Inspector, set "Appearances" to "Any, Dark"
3. Set the Light appearance color
4. Set the Dark appearance color

## 4. Alternative: Use System Colors
If you prefer to use system colors (which automatically adapt), the fallback colors in AppTheme.swift will handle this:
- `Color(.systemBackground)` for backgrounds
- `Color(.label)` for primary text
- `Color(.secondaryLabel)` for secondary text

## Current Status
The app currently uses fallback colors that automatically adapt to dark mode. You can optionally create the color assets above for more control over the exact colors used. 