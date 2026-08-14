# Synthesis — General discussion

Olivier V. Raven | <olivier.raven@icloud.com>

## Overview

This chapter synthesises findings across the four data chapters of the thesis, drawing together insights on kōura habitat, behaviour, and the design and deployment of artificial reef structures in New Zealand lakes. It also includes supplementary analyses not covered in earlier chapters, including a CPUE comparison across reef types at Lake Ōkaro and additional monitoring data from deep stone pile deployments at Lake Rotoiti.

## Repository structure

```text
.
+-- data/
|   +-- raw/          # Raw monitoring data — NOT tracked (see below)
|   +-- derived/      # Processed data files — NOT tracked
+-- outputs/          # Generated figures (fig-*.png) — tracked
+-- images/           # Chapter cover image
+-- index.qmd         # Synthesis chapter text
+-- analysis.qmd      # Supplementary analysis notebook
```

## Reproducing the analysis

This chapter is rendered as part of the parent thesis repository. Supplementary analyses are in `analysis.qmd`.

### Requirements

- R >= 4.4
- Quarto >= 1.4

### Render

```bash
quarto render analysis.qmd
```

Or render the full thesis from the parent directory:

```bash
quarto render
```

## Data sources

Raw data are fetched from public repositories or provided by BoPRC and are not tracked in this repository. Key sources:

| Source | Data | URL |
|--------|------|-----|
| **LAWA** (Land Air Water Aotearoa) | Long-term TLI and water quality monitoring | <https://www.lawa.org.nz> |
| **NZFFWF** (NZ Freshwater Fish Database) | Kōura and fish occurrence records | <https://nzffdms.niwa.co.nz> |
| **Limnotrack / LERNZmp** | Continuous buoy monitoring (temperature, DO) from BoPRC | <https://limnotrack.com> |
| **BoPRC** (Bay of Plenty Regional Council) | CTD profiles and water quality records | <https://www.boprc.govt.nz> |

## Licence

Code: [MIT License](../LICENSE)
Data: sourced from the public repositories listed above under their respective terms.
