# General Introduction — Kōura ecology, distribution, and lake habitat context

Olivier V. Raven | <olivier.raven@icloud.com>

## Overview

This chapter provides the ecological and spatial context for the thesis. It covers the global distribution of freshwater crayfish (family level), the New Zealand distribution of kōura (*Paranephrops* spp.), an overview of the Rotorua Te Arawa study lakes, and analyses of long-term water quality, thermal habitat, and bathymetric trends across the study system.

Key topics:

- Global crayfish family distribution map (Astacidae, Cambaridae, Cambaroididae, Parastacidae)
- Kōura distribution across New Zealand
- Study lake characterisation (bathymetry, hypsography, depth profiles)
- Spatial and temporal water quality trends (temperature, dissolved oxygen, livable habitat)
- Long-term persistence and trend mapping across lake pixels
- Meteorological context from continuous buoy monitoring

## Repository structure

```text
.
+-- data/
|   +-- raw/          # Raw GIS layers and downloaded data — NOT tracked (see below)
|   +-- derived/      # Processed/cached data files (.rds) — NOT tracked
+-- outputs/          # Generated figures (fig-*.png) and tables (tbl-*.csv) — tracked
+-- images/           # Chapter cover image
+-- references/       # Bibliography (.bib) and citation style files
+-- index.qmd         # Chapter text
+-- analysis.qmd      # Full analysis notebook (all figures generated here)
```

## Reproducing the analysis

This chapter is rendered as part of the parent thesis repository. All analyses are in `analysis.qmd`.

### Requirements

- R >= 4.4
- Quarto >= 1.4
- Internet access for any API-fetched data not already cached in `data/derived/`

### Render

```bash
quarto render analysis.qmd
```

Or render the full thesis from the parent directory:

```bash
quarto render
```

## Data sources

Raw data are fetched from public repositories at render time and are not tracked in this repository. Key sources:

| Source | Data | URL |
|--------|------|-----|
| **LINZ** (Land Information New Zealand) | Lake polygons, coastlines, roads, contours | <https://data.linz.govt.nz> |
| **Limnotrack / LERNZmp** | Continuous buoy monitoring (temperature, DO, meteorology) from BoPRC | <https://limnotrack.com> |
| **LAWA** (Land Air Water Aotearoa) | Long-term water quality monitoring across NZ lakes | <https://www.lawa.org.nz> |
| **NZFFWF** (NZ Freshwater Fish Database) | Kōura and fish occurrence records | <https://nzffdms.niwa.co.nz> |
| **rnaturalearth** | World country boundaries for distribution map | <https://www.naturalearthdata.com> |

## Licence

Code: [MIT License](../LICENSE)
Data: sourced from the public repositories listed above under their respective terms.
