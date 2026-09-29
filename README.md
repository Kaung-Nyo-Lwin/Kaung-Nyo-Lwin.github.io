# Kaung Nyo Lwin · AI Engineer & Researcher

Personal portfolio: [kaung-nyo-lwin.github.io](https://kaung-nyo-lwin.github.io/).

The site is static HTML, CSS and a small JavaScript file, with self-hosted fonts. There
is no framework, build step or dependency install. It shares one visual system with the
CV in `cv/`: IBM Plex Sans; ink, deep teal (`#0A7587`) and indigo (`#3949B5`); a
gradient band; the network motif; section nodes; and a timeline rail.

## Preview locally

```sh
python3 -m http.server 8000 --bind 127.0.0.1
```

Open `http://127.0.0.1:8000`. Check desktop and phone widths in light and dark mode,
the chart tooltip (hover and keyboard focus), "View as table", the "What I built"
disclosures, the mobile menu, and the CV download. Content and navigation work without
JavaScript. Animation stops under `prefers-reduced-motion`.

## Files

| File | Purpose |
| --- | --- |
| `index.html` | Hero, selected results, work, research, experience, skills, education, contact |
| `research.html` | L2BC thesis: method, results, findings, limits, citation |
| `styles.css` | Design tokens (light and dark), layout, components, responsive rules |
| `script.js` | Mobile menu, chart tooltips, email copy, active-section marker |
| `cv/` | LaTeX and TikZ sources of the CV (`cv.tex` content, `aicv.cls` design) |
| `assets/Kaung_Nyo_Lwin_CV.pdf` | The CV that every download link points to |
| `assets/Kaung_Nyo_Lwin_AI_Engineer_Resume.pdf` | Same CV, kept at the previously published URL |
| `assets/fonts/` | IBM Plex Sans 400, 400 italic, 500 and 600 as subset WOFF2 (SIL OFL, see `LICENSE.txt`) |
| `assets/favicon.svg` | Mark: the motif's highlighted path on the brand gradient |
| `assets/social-card.svg` / `.png` | 1200 × 630 link preview (the PNG is rendered from the SVG) |
| `404.html` | Missing-page fallback |
| `experience.html`, `projects.html`, `skills.html`, `education.html`, `contact.html` | Legacy URLs that redirect to sections of the portfolio |
| `KaungNyoLwin_Resume_20102025.pdf` | Archived 2025 resume, not linked from the site |

## Updating content

The CV is the source of truth for roles, dates and results. When a career detail
changes, edit `cv/cv.tex`, rebuild, and update the matching text in `index.html` (and in
`research.html` for the thesis):

```sh
make -C cv                      # LuaLaTeX via latexmk -> cv/Kaung_Nyo_Lwin_CV.pdf
cp cv/Kaung_Nyo_Lwin_CV.pdf assets/Kaung_Nyo_Lwin_CV.pdf
cp cv/Kaung_Nyo_Lwin_CV.pdf assets/Kaung_Nyo_Lwin_AI_Engineer_Resume.pdf
```

The build needs TeX Live with LuaLaTeX and the `plex`, `tcolorbox`, `pgf`, `enumitem`,
`needspace`, `lastpage` and `refcount` packages. The CV is ATS-safe: every word is real
text in reading order, and TikZ only draws decoration.

## Charts

The L2BC chart on both pages is plain HTML and CSS: a legend, direct value labels,
tooltips on hover and focus, and a "View as table" twin. Its two series are an emphasis
pair (L2BC in teal, the best 7B baseline in de-emphasis gray), validated with the
dataviz palette checks for each mode's surface:

| Mode | L2BC | Baseline | Surface |
| --- | --- | --- | --- |
| Light | `#048A9C` | `#A3ACB9` | `#FFFFFF` |
| Dark | `#10A4B8` | `#57616F` | `#131B24` |

The gray's sub-3:1 contrast is covered by the direct labels and the table view.

## Checks before publishing

```sh
node --check script.js
git diff --check
```

GitHub Pages publishes the repository root from `main`. A push to `main` updates the
live site after the Pages build, usually within a minute or two.
