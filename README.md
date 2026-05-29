# Kōura habitat, behaviour, and the design of artificial reefs in New Zealand lakes

PhD Thesis — Olivier V. Raven, University of Waikato

## Repository structure

This repo contains the thesis "glue" files: `_quarto.yml`, front matter, chapter dividers, general introduction, general discussion, and references. Each data chapter lives in its own repository and must be cloned separately into the correct subfolder for rendering to work.

## Setup on a new machine

```bash
# 1. Clone this thesis repo
git clone https://github.com/OlivierRaven/Koura_PhD_Thesis.git 01_thesis_chapters

# 2. Clone each chapter repo into the correct subfolder
git clone https://github.com/OlivierRaven/Koura_NCE.git                  01_thesis_chapters/02_koura_fear
git clone https://github.com/OlivierRaven/Koura_shoreline_habitats.git   01_thesis_chapters/03_koura_shoreline_habitats
git clone https://github.com/OlivierRaven/Koura_Mesocosm.git             01_thesis_chapters/04_koura_mesocosm
git clone https://github.com/OlivierRaven/Stone_Piles_Rotoiti.git        01_thesis_chapters/05_stone_piles_rotoiti
```

## Rendering

Requires [Quarto](https://quarto.org) and R with required packages installed.

```bash
# HTML book
quarto render --to html

# PDF thesis
quarto render --to pdf
```

Output is written to the `_book/` folder.

## Chapter repositories

| Chapter                    | Folder                         | Repository |
|----------------------------|--------------------------------|------------|
| 2 — Kōura fear & behaviour | `02_koura_fear/`               | https://github.com/OlivierRaven/Koura_NCE |
| 3 — Shoreline habitats     | `03_koura_shoreline_habitats/` | https://github.com/OlivierRaven/Koura_shoreline_habitats |
| 4 — Mesocosm experiment    | `04_koura_mesocosm/`           | https://github.com/OlivierRaven/Koura_Mesocosm |
| 5 — Stone piles Rotoiti    | `05_stone_piles_rotoiti/`      | https://github.com/OlivierRaven/Stone_Piles_Rotoiti |
