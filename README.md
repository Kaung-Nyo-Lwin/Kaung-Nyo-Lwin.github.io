# Kaung Nyo Lwin · AI Engineer & Researcher

Personal portfolio for computer vision, language model research, and software engineering. Intended site URL: [kaung-nyo-lwin.github.io](https://kaung-nyo-lwin.github.io/).

The site uses static HTML, CSS, and a small JavaScript file. Fonts are self-hosted; there is no framework, dependency install, or build step.

## Preview locally

```sh
python3 -m http.server 8000 --bind 127.0.0.1
```

Open `http://127.0.0.1:8000`. Test the desktop and mobile layouts, the work-area tabs, project disclosures, mobile menu, and resume downloads. Navigation and core content remain available without JavaScript. The site respects reduced-motion preferences.

## Edit the portfolio

| File | Purpose |
| --- | --- |
| `index.html` | Selected work, current and earlier experience, skills, education, contact |
| `research.html` | L2BC research overview, marked as a completed master's thesis |
| `styles.css` | Responsive layout, colors, typography, accessibility states |
| `script.js` | Mobile navigation, keyboard-accessible tabs, email copy action |
| `assets/` | Resume downloads, self-hosted fonts, monogram, social preview |
| `resume/` | Editable LaTeX sources for both resume layouts |
| `404.html` | Missing-page fallback |
| `sitemap.xml`, `robots.txt` | Search discovery |

The former `experience.html`, `projects.html`, `skills.html`, `education.html`, and `contact.html` URLs redirect to the corresponding portfolio sections. The dated 2025 resume is retained as an archive; all current download links use the new PDF in `assets/`.

Update titles and descriptions in both the HTML and `resume/resume-content.tex` when changing career details. Contact information and education also appear in the two resume layout files. No unpublished paper or internal project files are included in the site.

## Rebuild the resumes

Use XeLaTeX and `latexmk` from TeX Live, with the TeX Gyre Heros font and the packages named in the source files. From the repository root:

```sh
latexmk -cd -xelatex -interaction=nonstopmode -halt-on-error resume/resume.tex
latexmk -cd -xelatex -interaction=nonstopmode -halt-on-error resume/resume-ats.tex
cp resume/resume.pdf assets/Kaung_Nyo_Lwin_AI_Engineer_Resume.pdf
cp resume/resume-ats.pdf assets/Kaung_Nyo_Lwin_AI_Engineer_Application.pdf
```

`resume.tex` is the editorial layout; `resume-ats.tex` is the single-column application layout. Both use the same descriptions from `resume-content.tex`. Review the resulting PDFs before committing the updated downloads.

## Checks and publication

```sh
node --check script.js
git diff --check
```

Before publication, check the homepage and research page at desktop and phone widths, follow the legacy URLs, and download the resume. `assets/social-card.svg` is the editable 1200 × 630 source for the PNG social preview.

The repository is ready for GitHub Pages with the repository root as the publishing source. A local commit does not publish the changes; publication requires pushing to the branch configured in GitHub Pages.

Lato is distributed under the SIL Open Font License; see `assets/fonts/LICENSE.txt`.
