% aicv.cls -- a modern, ATS-friendly CV class with TikZ accents.
%
% Design rules
%   * One reading column. Every word is real, selectable text in reading order;
%     TikZ only draws decoration (band, network motif, icons, rail, nodes), so
%     nothing drawn ever reaches an applicant-tracking system as stray text.
%   * Hyphenation is off, so keywords such as "PyTorch" are never split.
%   * A 7 mm gutter left of the text column holds the section nodes and the
%     entry rail; all text shares one left edge.
%
% Engine: LuaLaTeX (fontspec). Build with latexmk (see .latexmkrc / Makefile).
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{aicv}[2026/09/29 v1.0 AI engineer and researcher CV]

\LoadClass[10pt]{article}

\RequirePackage{iftex}
\RequireLuaTeX

% ------------------------------------------------------------------ page grid
\RequirePackage[a4paper,top=12mm,bottom=12mm,left=21mm,right=14mm,
  headheight=0pt,headsep=0pt,footskip=0pt]{geometry}
\newlength\cvrailx \setlength\cvrailx{4.6mm} % rail/node centre, left of text

% --------------------------------------------------------------------- colour
\RequirePackage{xcolor}
\definecolor{ink}{HTML}{16202C}     % names, titles
\definecolor{body}{HTML}{2A3341}    % running text
\definecolor{muted}{HTML}{5B6576}   % dates, context lines
\definecolor{faint}{HTML}{A3ACB9}
\definecolor{accent}{HTML}{0A7587}  % deep teal
\definecolor{accent2}{HTML}{3949B5} % indigo, far end of the gradient
\definecolor{hair}{HTML}{D6DCE4}
\definecolor{tint}{HTML}{F0F6F7}
\colorlet{rail}{accent!32}

% ---------------------------------------------------------------------- fonts
% IBM Plex Sans ships with TeX Live. Common ligatures are disabled so text
% extracts letter for letter.
\RequirePackage{fontspec}
\defaultfontfeatures{Ligatures={TeX,NoCommon}}
\setmainfont{IBMPlexSans}[
  Extension=.otf, UprightFont=*-Regular, ItalicFont=*-Italic,
  BoldFont=*-SemiBold, BoldItalicFont=*-SemiBoldItalic]
\newfontfamily\cvmedium{IBMPlexSans}[
  Extension=.otf, UprightFont=*-Medium, ItalicFont=*-MediumItalic,
  BoldFont=*-Bold]

\newcommand\cv@size[2]{\fontsize{#1}{#2}\selectfont}
\newcommand\cvnamefont{\cvmedium\cv@size{27}{31}\color{ink}}
\newcommand\cvtitlefont{\bfseries\cv@size{10.6}{13}\color{accent}\addfontfeatures{LetterSpace=4}}
\newcommand\cvcontactfont{\cv@size{8.7}{11.4}\color{body}}
\newcommand\cvsectionfont{\bfseries\cv@size{10}{12}\color{ink}\addfontfeatures{LetterSpace=4}}
\newcommand\cventrytitlefont{\bfseries\cv@size{10.2}{12.8}\color{ink}}
\newcommand\cvdatefont{\cv@size{8.8}{12.8}\color{muted}}
\newcommand\cvorgfont{\cvmedium\cv@size{9.1}{11.8}\color{accent}}
\newcommand\cvcontextfont{\itshape\cv@size{8.9}{11.6}\color{muted}}
\newcommand\cvbodyfont{\cv@size{9.25}{12.15}\color{body}}
\newcommand\cvlabelfont{\cvmedium\cv@size{9}{11.9}\color{ink}}
\newcommand\cvtagfont{\cvmedium\cv@size{8}{9.6}\color{accent!85!black}}

% ------------------------------------------------------------ text behaviour
\RequirePackage[protrusion=true,expansion=false]{microtype}
\hyphenpenalty=10000
\exhyphenpenalty=10000
\setlength\parindent{0pt}
\setlength\parskip{0pt}
\setlength\emergencystretch{3em}
\pagestyle{empty}
\AtBeginDocument{\raggedright\cvbodyfont}

% --------------------------------------------------------------- tikz, boxes
\RequirePackage{tikz}
\usetikzlibrary{calc}
\RequirePackage[many]{tcolorbox}
\RequirePackage{enumitem}
\RequirePackage{needspace}
\RequirePackage{lastpage}
\RequirePackage{refcount}

% A real bullet character (it extracts as U+2022), drawn in the accent colour.
\setlist[itemize]{label={\raisebox{0.05ex}{\color{accent}\cv@size{7.5}{9}\textbullet}},
  leftmargin=3.3mm, labelsep=1.7mm, topsep=2.2pt, itemsep=1.3pt,
  parsep=0pt, partopsep=0pt}

% ------------------------------------------------------------------ metadata
\newcommand\cv@name{}      \newcommand\cvname[1]{\renewcommand\cv@name{#1}}
\newcommand\cv@title{}     \newcommand\cvtitle[1]{\renewcommand\cv@title{#1}}
\newcommand\cv@focus{}     \newcommand\cvfocus[1]{\renewcommand\cv@focus{#1}}
\newcommand\cv@location{}  \newcommand\cvlocation[1]{\renewcommand\cv@location{#1}}
\newcommand\cv@phone{}     \newcommand\cv@phonelink{}
\newcommand\cvphone[2]{\renewcommand\cv@phone{#1}\renewcommand\cv@phonelink{#2}}
\newcommand\cv@email{}     \newcommand\cvemail[1]{\renewcommand\cv@email{#1}}
\newcommand\cv@web{}       \newcommand\cvweb[1]{\renewcommand\cv@web{#1}}
\newcommand\cv@github{}    \newcommand\cvgithub[1]{\renewcommand\cv@github{#1}}
\newcommand\cv@linkedin{}  \newcommand\cvlinkedin[1]{\renewcommand\cv@linkedin{#1}}

% ---------------------------------------------------------------------- icons
% Outline icons drawn with TikZ, sized in ex so they follow the contact font.
\tikzset{cvicon/.style={accent, line width=0.55pt, line cap=round, line join=round}}
\newcommand\cv@icon[1]{\tikz[baseline=0pt, x=1ex, y=1ex]{#1}}
\newcommand\iconpin{\cv@icon{%
  \draw[cvicon] (0.8,0.02) .. controls (0.62,0.55) and (0.05,0.95) .. (0.05,1.5)
    arc[start angle=180, end angle=0, radius=0.75]
    .. controls (1.55,0.95) and (0.98,0.55) .. (0.8,0.02) -- cycle;
  \draw[cvicon, line width=0.5pt] (0.8,1.5) circle (0.28);}}
\newcommand\iconphone{\cv@icon{%
  \draw[cvicon, rounded corners=0.28ex] (0,-0.05) rectangle (1.2,1.95);
  \draw[cvicon] (0.42,1.62) -- (0.78,1.62);
  \fill[accent] (0.6,0.3) circle (0.13);}}
\newcommand\iconmail{\cv@icon{%
  \draw[cvicon, rounded corners=0.18ex] (0,0.1) rectangle (2.1,1.6);
  \draw[cvicon] (0.1,1.5) -- (1.05,0.72) -- (2.0,1.5);}}
\newcommand\iconglobe{\cv@icon{%
  \draw[cvicon] (0.85,0.85) circle (0.85);
  \draw[cvicon, line width=0.42pt] (0.85,0.85) ellipse (0.36 and 0.85);
  \draw[cvicon, line width=0.42pt] (0,0.85) -- (1.7,0.85);}}
\newcommand\icongit{\cv@icon{%
  \draw[cvicon] (0.3,0.32) -- (0.3,1.5);
  \draw[cvicon] (1.25,1.27) .. controls (1.25,0.72) and (0.3,0.95) .. (0.3,0.52);
  \filldraw[cvicon, fill=white] (0.3,0.22) circle (0.24) (0.3,1.6) circle (0.24)
    (1.25,1.38) circle (0.24);}}
\newcommand\iconprofile{\cv@icon{%
  \draw[cvicon, rounded corners=0.3ex] (0,0) rectangle (1.9,1.8);
  \draw[cvicon] (0.95,1.13) circle (0.34);
  \draw[cvicon] (0.38,0.02) .. controls (0.45,0.6) and (1.45,0.6) .. (1.52,0.02);}}

% ------------------------------------------------------------ page furniture
% Gradient band on every page, the network motif on page 1, and page dots.
% The background hook's origin is the top-left corner of the paper, y upwards.
\newcommand\cv@motif{%
  \pgfmathsetseed{20260929}%
  \foreach \l/\n in {0/3,1/5,2/6,3/5,4/3}{%
    \foreach \i in {1,...,\n}{%
      \coordinate (m-\l-\i) at ({\l*10.5}, {(\i-(\n+1)/2)*4.1});}}%
  \foreach \l/\n/\m in {0/3/5,1/5/6,2/6/5,3/5/3}{%
    \pgfmathtruncatemacro\nx{\l+1}%
    \pgfmathtruncatemacro\mix{100-\l*25}%
    \colorlet{edge}{accent!\mix!accent2}%
    \foreach \i in {1,...,\n}{\foreach \j in {1,...,\m}{%
      \pgfmathsetmacro\op{0.07+0.22*rnd}%
      \draw[edge, opacity=\op, line width=0.3pt] (m-\l-\i) -- (m-\nx-\j);}}}%
  \foreach \a/\b/\k in {0-2/1-2/0,1-2/2-4/1,2-4/3-3/2,3-3/4-2/3}{%
    \pgfmathtruncatemacro\mix{100-\k*25}%
    \draw[accent!\mix!accent2, line width=0.8pt, line cap=round] (m-\a) -- (m-\b);}%
  \foreach \l/\n in {0/3,1/5,2/6,3/5,4/3}{%
    \pgfmathtruncatemacro\mix{100-\l*25}%
    \colorlet{node}{accent!\mix!accent2}%
    \foreach \i in {1,...,\n}{%
      \fill[white] (m-\l-\i) circle (0.95);
      \draw[node!60, line width=0.45pt] (m-\l-\i) circle (0.95);}}%
  \foreach \p/\k in {0-2/0,1-2/1,2-4/2,3-3/3,4-2/4}{%
    \pgfmathtruncatemacro\mix{100-\k*25}%
    \colorlet{node}{accent!\mix!accent2}%
    \fill[node, opacity=0.15] (m-\p) circle (2.1);
    \fill[node] (m-\p) circle (1.05);}}

\AddToHook{shipout/background}{%
  \put(0,0){%
    \begin{tikzpicture}[overlay, x=1mm, y=1mm]
      \shade[left color=accent, right color=accent2]
        (0,0) rectangle (\paperwidth,-2.2mm);
      \ifnum\value{page}=1
        \begin{scope}[shift={(152,-22.5)}]\cv@motif\end{scope}
      \fi
      \pgfmathtruncatemacro\cv@pages{max(\getpagerefnumber{LastPage},1)}%
      \foreach \i in {1,...,\cv@pages}{%
        \pgfmathsetmacro\cv@dotx{196-(\cv@pages-\i)*3.4}%
        \ifnum\i=\value{page}
          \fill[accent] (\cv@dotx,-289.5) circle (0.72);
        \else
          \draw[faint, line width=0.4pt] (\cv@dotx,-289.5) circle (0.72);
        \fi}%
    \end{tikzpicture}}}

% --------------------------------------------------------------------- header
\newcommand\cv@contact[2]{\mbox{#1\hspace{1.5mm}#2}}
\newcommand\makecvheader{%
  \begingroup
  \vspace*{1.2mm}%
  \noindent\begin{minipage}[t]{122mm}
    {\cvnamefont\cv@name\par}
    \vspace{2.2mm}
    {\cvtitlefont\MakeUppercase{\cv@title}\par}
    \vspace{2.4mm}
    \cv@focus\par
  \end{minipage}\par
  \vspace{4.2mm}
  \cvcontactfont
  \noindent
  \makebox[0.29\linewidth][l]{\cv@contact{\iconpin}{\cv@location}}%
  \makebox[0.29\linewidth][l]{\cv@contact{\iconphone}{\href{tel:\cv@phonelink}{\cv@phone}}}%
  \makebox[0.42\linewidth][l]{\cv@contact{\iconmail}{\href{mailto:\cv@email}{\cv@email}}}\par
  \vspace{1.2mm}\noindent
  \makebox[0.29\linewidth][l]{\cv@contact{\iconglobe}{\href{https://\cv@web/}{\cv@web}}}%
  \makebox[0.29\linewidth][l]{\cv@contact{\icongit}{\href{https://github.com/\cv@github}{github.com/\cv@github}}}%
  \makebox[0.42\linewidth][l]{\cv@contact{\iconprofile}{\href{https://www.linkedin.com/in/\cv@linkedin/}{linkedin.com/in/\cv@linkedin}}}\par
  \endgroup
  \vspace{1.5mm}}

% Focus areas as soft tags. Each tag is plain text on the baseline.
\newcommand\cvtag[1]{\tikz[baseline=(t.base)]\node[fill=accent!8, rounded corners=1.5mm,
  inner xsep=1.9mm, inner ysep=1.05mm, font=\cvtagfont] (t) {\strut #1};}
\newcommand\cvtagsep{\hspace{1.1mm}}

% ------------------------------------------------------------------- sections
\newcommand\cv@node{\tikz[baseline=-0.5ex]{%
  \fill[accent!16] (0,0) circle (3.5pt); \fill[accent] (0,0) circle (1.85pt);}}
\newcommand\cvsection[1]{%
  \par\addvspace{8.5pt}\needspace{5\baselineskip}%
  \noindent\makebox[0pt][r]{\cv@node\hspace{\dimexpr\cvrailx-3.5pt\relax}}%
  {\cvsectionfont\MakeUppercase{#1}}\hspace{2.6mm}%
  {\color{hair}\leaders\hrule height 0.64ex depth -0.57ex\hfill}\kern0pt\par
  \nopagebreak\vspace{5pt}}

% ---------------------------------------------------------------------- entry
% Each entry sits on the rail: a ring beside its title, and a line that fades
% out below its last bullet. Entries may break across pages.
\newlength\cv@ringdrop \setlength\cv@ringdrop{2.45mm}
\newlength\cv@entryskip \setlength\cv@entryskip{6pt}
\newtcolorbox{cv@entrybox}{enhanced jigsaw, breakable, blank,
  before skip=0pt, after skip=\cv@entryskip, before upper=\raggedright,
  overlay unbroken and first={%
    \coordinate (ring) at ([xshift=-\cvrailx, yshift=-\cv@ringdrop]frame.north west);
    \coordinate (end)  at ([xshift=-\cvrailx]frame.south west);
    \fill[rail] ([xshift=-0.3pt]ring) rectangle ([xshift=0.3pt, yshift=7mm]end);
    \shade[top color=rail, bottom color=white]
      ([xshift=-0.3pt, yshift=7mm]end) rectangle ([xshift=0.3pt, yshift=1pt]end);
    \filldraw[fill=white, draw=accent, line width=0.85pt] (ring) circle (2.05pt);},
  overlay middle and last={%
    \fill[rail] ([xshift=-\cvrailx-0.3pt]frame.north west)
      rectangle ([xshift=-\cvrailx+0.3pt]frame.south west);}}

\newcommand\cv@ifempty[3]{\if\relax\detokenize{#1}\relax#2\else#3\fi}
% The title gets a line of its own and the dates share the organisation line.
% With dates on the title line, Poppler-style extractors group consecutive
% short entries into columns and pair degrees with the wrong school.
\newcommand\cv@entryhead[4]{% title, dates, organisation, context
  \cv@ifempty{#3}%
    {{\cventrytitlefont #1}\hfill{\cvdatefont #2}\par}%
    {{\cventrytitlefont #1\par}{\cvorgfont #3}\hfill{\cvdatefont #2}\par}%
  \cv@ifempty{#4}{}{\vspace{0.4pt}{\cvcontextfont #4\par}}}

% \begin{cventry}{title}{dates}{organisation}{context} \item ... \end{cventry}
\newenvironment{cventry}[4]{%
  \begin{cv@entrybox}\cv@entryhead{#1}{#2}{#3}{#4}\begin{itemize}}
  {\end{itemize}\end{cv@entrybox}}

% \cvbrief{title}{dates}{organisation}{one-paragraph description}
\newcommand\cvbrief[4]{%
  \begin{cv@entrybox}\cv@entryhead{#1}{#2}{#3}{}%
  \cv@ifempty{#4}{}{\vspace{1.6pt}#4\par}%
  \end{cv@entrybox}}

% ----------------------------------------------------------- highlight card
% Tinted card whose accent edge sits on the rail line.
\newtcolorbox{cvcard}{enhanced, breakable, colback=tint, colframe=tint,
  boxrule=0pt, sharp corners, boxsep=0pt,
  grow to left by=\cvrailx, left=\cvrailx, right=3.2mm, top=2.6mm, bottom=2.8mm,
  borderline west={1.3pt}{0pt}{accent}, before skip=1pt, after skip=\cv@entryskip,
  before upper=\raggedright}

% \cvrole{title}{organisation}{dates}{description}: one-line head for
% shorter entries, title and organisation on the same baseline.
\newcommand\cvrole[4]{%
  \begin{cv@entrybox}%
  {\cventrytitlefont #1}\cv@ifempty{#2}{}{\hspace{0.5em}{\color{faint}\textperiodcentered}%
    \hspace{0.5em}{\cvorgfont #2}}\hfill{\cvdatefont #3}\par
  \cv@ifempty{#4}{}{\vspace{0.8pt}#4\par}%
  \end{cv@entrybox}}

% --------------------------------------------------------------------- skills
% One paragraph per category: a fixed-width label box, then the items with a
% hanging indent. It looks like a two-column table, but extractors read each
% label before its items (a real table lets them lift the label column out).
\newlength\cvlabelwidth \setlength\cvlabelwidth{37.5mm}
\newenvironment{cvskills}{\par}{\par}
\newcommand\cvskill[2]{%
  {\hangindent=\cvlabelwidth\hangafter=1\noindent
   \makebox[\cvlabelwidth][l]{\cvlabelfont #1}{\cvbodyfont #2}\par}\vspace{2.4pt}}

% -------------------------------------------------------------- publication
\newcommand\cvpub[1]{{\cv@size{8.9}{11.8}\color{body}#1\par}}

% ------------------------------------------------------------------- hyperref
\RequirePackage[hidelinks,pdfdisplaydoctitle=true]{hyperref}
\urlstyle{same}

\endinput
