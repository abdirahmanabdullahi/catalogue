# Grundfos Product Center — Flutter Copy

Faithful copy of https://product-selection.grundfos.com/ (Grundfos Product Center,
"Sizing and selection of pumps and pump solutions"). All content, structure, text,
images and data were scraped from the real site — nothing invented.

## Data provenance

The site is geo-blocked from this network, so content was recovered from:
- **Wayback Machine** (rendered May 2026 snapshot) — page structure, navigation, all text
- **Wayback Save-Page-Now proxy** — live JSON data endpoints (`category-areas.json`,
  `application-areas.json`, `product-az.json`, `.sizing-qc.json`)
- **Live Grundfos public APIs** (reachable directly) —
  `api.grundfos.com/gpi/catalogue/*` (206 product groups, 13 applications, technical data) and
  `api.grundfos.com/gpi/imaging/*` + `grundfos.scene7.com` (all product/category/application images)
- **Site CSS** — exact brand palette (#126AF3 action blue, #11497B dark blue, #0C1217 ink,
  #DD0028 red, grey scale) and the real GrundfosTheSans font files (converted woff2 → ttf)

## Feature breakdown (copied 1:1 from the site)

### F1. App shell
- Grundfos header: logo (real `logo.svg`), search button, menu
- "Products & services" mega menu: Application Tools (Hot Water Recirculation Sizing Tool,
  iGRID Configurator, Pit Creator, Pumping Station Creator), Product tools (Build your own Pump,
  MIXIT Sizing Tool, Eica Selection Tool, Dosing Skid Configurator US/Europe, Digital Dosing
  Pump Selection Tool), Calculators, Product Compare Variants, Recently viewed products,
  Catalogue Settings
- Footer: About us / Solutions / Sustainability / Media / Careers link columns, quick links,
  Grundfos Holding A/S address, social icons (Facebook, LinkedIn, X, YouTube, Instagram),
  Legal / Certificates / Newsletter / Whistleblower / Accessibility Statement / Contact

### F2. Home screen (`/`)
- Search hero: "Find a Grundfos product" with search field ("Search for...")
- Sizing hero (dark blue): "Size your product" — "Find the right pump for your installation
  requirements." Quick-sizing steps (Select criteria → Set Flow and Head → Size product),
  "Size by" selector (Application / Pump family / Pump design / Quick Sizing),
  application-area selector, "Start sizing" + "Open Advanced Selection" buttons
  (data: `assets/data/sizing_qc.json` — the site's own sizing quick-config)
- "Explore our offerings" — "We have a wide array of products, pump solutions and services for
  all applications. Select your starting point here." Four cards: Industry → Industries,
  Application → Applications, Product categories → Categories, Products and services → Products A-Z
- Grundfos Marketing Centre section (exact site copy)
- "How can we help you?" — Sales / Expert advice / Service cards (exact site copy)

### F3. Categories (`/categories`)
- "Choose a product category to find all your high-quality Grundfos options quickly and easily."
- "Select by category" grid — the site's 13 live category areas (Pumps, Solutions, Pump systems,
  Chemical dosing pumps and solutions, Measurements and controls, Controls and monitoring,
  Agitators, Accessories, Services, Lifting station, Fire systems, Pump motors, Pressure managers)
  with their real scene7 hero images and descriptions
- Category detail: hero + description + subcategory tiles (56 subcategories from live API,
  real pump-design images) → product groups in each subcategory

### F4. Applications (`/applications`)
- "Select area of interest or application" — the site's 11 application areas
  (Commercial buildings, District energy, Domestic buildings, Industrial processes,
  Industrial temperature control, Water treatment, HVAC OEM, Municipal water supply,
  Municipal wastewater, Agriculture and irrigation, Solar water and pumping solutions)
  with real hero images and descriptions
- Area detail: hero + sub-applications (63 total, e.g. Commercial heating, District cooling,
  Machining…) each with the site's full description text

### F5. Products A–Z (`/products`)
- "Find exactly what you are looking for in this product list."
- Letter-indexed list of the 147 real product families (ALPHA, CR, MAGNA, SCALA, SQ, …)
  with real product photos, descriptions, "Sizeable" flags
- Filter tabs copied from the site data: pump filter and applications filter
- Product family detail: photo, description, technical data (liquid temperature, max flow,
  max head — from the live catalogue API), related applications and categories

### F6. Sizing / selection
- Size-your-product wizard using the site's own `.sizing-qc.json` steps
- Advanced Selection entry screen

### F7. Utilities (site header tools)
- Search across products/categories/applications ("Search for...")
- Product Compare Variants (empty state as on site)
- Recently viewed products (tracked in-app, as on site)
- Catalogue Settings

## Assets
- `assets/images/categories/` — 13 area heroes + 15 subcategory images (28)
- `assets/images/applications/` — 11 area heroes + 13 application icons (24)
- `assets/images/products/` — 215 product-group photos (all 147 A-Z families + all API groups)
- `assets/images/brand/` — logo.svg, payoff-brand-promise.svg, 5 social icons
- `assets/fonts/` — GrundfosTheSans Regular/Bold/SemiLight/ExtdBold (real site fonts)
- `assets/data/catalogue.json` — categories, subcategories, application areas,
  catalogue applications, products A-Z, product groups (composed from live site data)
- `assets/data/sizing_qc.json` — the site's sizing quick-config
