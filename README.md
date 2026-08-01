# Filamentory

Filamentory is an iOS app for keeping track of your 3D printing filament inventory: what you own, how much of it is left, what you need to buy, and how you're using it over time.

Built with SwiftUI and SwiftData as a hands-on learning project, following production-app conventions: feature-based architecture, MVVM-leaning structure, localization, native charts, and App Store readiness.

## Features

**Storage**
- Full filament inventory: brand, material type, color, weight, price, remaining amount, status (open/sealed)
- Mark filaments as favorites
- Low-stock visual highlighting
- Full-text search plus structured filters (type, brand, color, date added)

**Shopping List**
- Add, check off, and remove items you need to buy
- Automatic prompt to add a filament to the shopping list the moment it runs out

**Statistics**
- Total inventory value
- Low-stock alert list
- Material breakdown (donut chart)
- Monthly filament usage (bar chart)
- Most-used color

**Settings**
- Light / Dark / System appearance
- Live language switching (English / Spanish) — no restart required
- Configurable low-stock threshold
- Preferred currency
- Delete all inventory (with confirmation)

**Onboarding**
- First-launch welcome carousel introducing the app's main sections

## Tech stack

- **SwiftUI** — declarative UI
- **SwiftData** — local persistence, no external database or backend
- **Swift Charts** — native statistics visualizations
- **Observation** (`@Observable` / `@Bindable`) — state management
- iOS 18.6+

## Architecture

The project is organized by feature, not by file type:

```
Filamentory/
├── App/                  # App entry point, root view
├── Models/               # SwiftData models (Filament, UsageEvent, ShoppingListItem)
├── Extensions/            # Shared type extensions (e.g. Color <-> stored components)
└── Features/
    ├── Storage/           # Inventory list, search & filters
    ├── FilamentForm/       # Shared add/edit form fields
    ├── NewFilament/        # Add filament flow
    ├── EditFilament/       # Edit filament flow
    ├── DetailsFilament/    # Filament detail view
    ├── ShoppingList/       # Shopping list feature
    ├── Statistics/         # Charts and aggregated stats
    ├── Settings/           # App preferences
    └── Welcome/            # First-launch onboarding
```

Shared, cross-feature concerns (models, color conversion helpers) live at the top level; anything specific to a single screen or flow lives inside that feature's own folder.

## Privacy

Filamentory collects no data of any kind. Everything you enter is stored locally on your device via SwiftData — there is no network access, no analytics, and no third-party services.

Full privacy policy: https://soratadev.github.io/Filamentory/privacy-policy.html

## Getting started

1. Clone the repository.
2. Open `filamentory.xcodeproj` in Xcode.
3. Build and run on a simulator or device running iOS 18.6+.

No external dependencies or package managers required — the project uses only first-party Apple frameworks.

## License

All rights reserved. See [LICENSE.md](LICENSE.md) — this source code is shared publicly for portfolio and educational purposes only; reuse, modification, or redistribution is not permitted without explicit permission.
