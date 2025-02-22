%%
%% This is file `kthletter.cls',
%%
%% AUTHOR:
%% Giampiero Salvi <giampi@kth.se>
%% 
%% For the copyright see the source file.
%% 
\NeedsTeXFormat{LaTeX2e}[2000/01/01]
\ProvidesClass{kthletter}
              [2016/09/28 v0.1 KTH letters]
\DeclareOption{a4paper}{}
\DeclareOption{a5paper}{\OptionNotUsed}
\DeclareOption{b5paper}{\OptionNotUsed}
\DeclareOption{letterpaper}{\OptionNotUsed}
\DeclareOption{legalpaper}{\OptionNotUsed}
\DeclareOption{executivepaper}{\OptionNotUsed}
\DeclareOption{landscape}{\OptionNotUsed}
\DeclareOption{10pt}{\renewcommand\@ptsize{0}}
\DeclareOption{11pt}{\renewcommand\@ptsize{1}}
\DeclareOption{12pt}{\renewcommand\@ptsize{2}}
\newcommand{\@ptsize}{1}
\DeclareOption{twoside}{\@twosidetrue  \@mparswitchtrue}
\DeclareOption{oneside}{\@twosidefalse \@mparswitchfalse}
\DeclareOption{draft}{\setlength\overfullrule{5pt}}
\DeclareOption{final}{\setlength\overfullrule{0pt}}
\DeclareOption{leqno}{\input{leqno.clo}}
\DeclareOption{fleqn}{\input{fleqn.clo}}
% use English instead of Swedish rules
\newif\if@kthletterenglish\@kthletterenglishfalse
\DeclareOption{english}{
  \@kthletterenglishtrue
}
\newif\if@kthletter@head \@kthletter@headtrue
\newif\if@kthletter@foot \@kthletter@foottrue
\DeclareOption{nohead}{\@kthletter@headfalse}
\DeclareOption{nofoot}{\@kthletter@footfalse}
\newcommand{\@kthletter@layout}{KTH}
\DeclareOption{DIN}{\renewcommand\@kthletter@layout{DIN}}
\DeclareOption{SS}{\renewcommand\@kthletter@layout{SS}}
\newcommand{\logotype}[1]{\renewcommand{\@kthletter@logo}{#1}}
\newcommand{\@kthletter@logo}{KTH-logo}
\newcommand{\@kthletter@dnrstr}{Ev diarienummer}
\newcommand{\@kthletter@recipientstr}{Mottagare}
\ProcessOptions
\if@kthletterenglish
  \renewcommand{\@kthletter@dnrstr}{Ev dossier number}
  \renewcommand{\@kthletter@recipientstr}{Recipient}
  \RequirePackage[english]{babel}
\else
  \RequirePackage[swedish]{babel}
\fi
\RequirePackage[utf8]{inputenc}
\RequirePackage[T1]{fontenc}
\RequirePackage{times}
\RequirePackage[a4paper]{geometry}
\RequirePackage{graphics}
\RequirePackage{ifpdf}
\RequirePackage[T1]{url}
\input{size1\@ptsize.clo}
\if@twoside
\geometry{a4paper,twoside,nohead,footskip=10mm,includefoot,
          left=62mm,right=25mm,top=30mm,bottom=12mm}
\else
\geometry{a4paper,nohead,footskip=10mm,includefoot,
          left=62mm,right=25mm,top=30mm,bottom=12mm}
\fi
\setlength{\lineskip}{1pt}
\setlength{\normallineskip}{1pt}
\renewcommand\baselinestretch{}
\setlength{\parskip}{0.7em}
\setlength{\parindent}{0pt}
\setlength{\medskipamount}{\parskip}
\@lowpenalty   51
\@medpenalty  151
\@highpenalty 301
\setlength{\footnotesep}{12pt}
\setlength{\skip\footins}{10pt \@plus 2pt \@minus 4pt}
\def\ps@empty{%
  \let\@oddfoot\@empty\let\@oddhead\@empty
  \let\@evenfoot\@empty\let\@evenhead\@empty}
\def\ps@plain{%
  \let\@oddhead\@empty
  \def\@oddfoot{\if@kthletter@foot
    \fontencoding{T1}\fontfamily{cmss}\selectfont
    \fontsize{7}{8.5}\selectfont
    \parbox{\textwidth}{\offinterlineskip
      %\setlength{\lineskip}{4pt}
      %\setlength{\normallineskip}{4pt}
      \begin{center}
        \begin{tabular}{p{0.9\textwidth}p{0.1\textwidth}}
          \textbf{KTH} & \\
          \fromaddress & \\
          \telephonenum\ | \@kthletter@email\ | \@kthletter@web &
          \ifnum\@nameuse{@kthletter@lastpage\the@kthletter@letter}=1%
          \else
            \hfill\thepage
            \ifnum\@nameuse{@kthletter@lastpage\the@kthletter@letter}=0%
              \G@refundefinedtrue
            \else
              \space(\@nameuse{@kthletter@lastpage\the@kthletter@letter})%
            \fi
          \fi
        \end{tabular}
      \end{center}}%end parbox
    \fi}%end oddfoot
  \let\@evenfoot\@oddfoot}% end plain
\newcommand*{\name}[1]{\def\fromname{#1}}
\newsavebox{\@kthletter@signature}
\newcounter{@kthletter@signature}
\newlength{\@kthletter@signaturewidth}
\newcommand*{\signature}[2][2]{%
  \setlength{\@kthletter@signaturewidth}{\textwidth}%
  \divide \@kthletter@signaturewidth by #1
  \def\and{\end{tabular}\end{minipage}%
    \addtocounter{@kthletter@signature}{1}%
    \ifnum#1=\value{@kthletter@signature}%
      \setcounter{@kthletter@signature}{0}%
      \\*[5\medskipamount]%
    \fi
    \begin{minipage}[t]{\@kthletter@signaturewidth}
      \begin{tabular}[t]{@{}l}}
  \begin{lrbox}{\@kthletter@signature}\normalfont
    \begin{minipage}{\textwidth}
      \begin{minipage}[t]{\@kthletter@signaturewidth}
        \begin{tabular}[t]{@{}l}
          #2
        \end{tabular}
      \end{minipage}
    \end{minipage}
  \end{lrbox}
}
\newcommand*{\accounts}[1]{\def\@kthletter@accounts{#1}}
\newcommand*{\address}[2][\fromaddress]{%
  \def\fromaddress{#2}\def\@kthletter@return{#1}}
\newcommand*{\location}[2][\fromlocation]{%
  \def\fromlocation{#2}\def\@kthletter@loc{#1}}
\newcommand*{\telephone}[1]{\def\telephonenum{#1}}
\newcommand*{\telefax}[1]{\def\@kthletter@fax{#1}}
\def\@kthletter@url{\begingroup \urlstyle{same}\Url}
\def\email{\urldef{\@kthletter@email}\@kthletter@url}
\def\web{\urldef{\@kthletter@web}\@kthletter@url}
\address[\@kthletter@loc\\SE-100 44~Stockholm\\Sweden]%
        {\fromlocation\\SE-100 44~Stockholm\\Sweden}
\location[KTH]{Brinellvägen 8, 100 44 Stockholm}
\telephone{08~-~790~xx~xx}
\telefax{08~-~790~xx~xx}
\accounts{Pg:~1~56~53-9. Bg:~895-9223. Momsreg.nr/VAT:~SE202100305401.}
\date{Stockholm, \today}
\email{inst@kth.se}
\web{www.kth.se}
\InputIfFileExists{kthletter.cfg}
    {\typeout{Loading local letter configuration file.}}{}
\AtBeginDocument{%
  \@ifpackageloaded{babel}{\let\dateswedish=\datesymd}{}}
\newcommand*{\returnaddress}{\fromname\\KTH -- \@kthletter@return}
\newcommand*{\makelabels}{%
  \AtBeginDocument{%
     \let\@startlabels\startlabels
     \let\@mlabel\mlabel
     \if@filesw
       \immediate\write\@mainaux{\string\@startlabels}\fi}%
  \AtEndDocument{%
     \if@filesw\immediate\write\@mainaux{\string\clearpage}\fi}}
\@onlypreamble\makelabels
\newcounter{@kthletter@letter}
\def\@kthletter@writelastpage{%
  \addtocounter{page}{-1}%
  \immediate\write\@auxout{%
    \string\global\string\@namedef
    {@kthletter@lastpage\the@kthletter@letter}{\thepage}}%
  \addtocounter{page}{1}%
  \addtocounter{@kthletter@letter}{1}%
}
\AtEndDocument{\@kthletter@writelastpage}
\newenvironment{letter}[2][\relax]{%
  \newpage
  \@kthletter@writelastpage
  \@ifundefined{@kthletter@lastpage\the@kthletter@letter}%
  {\@namedef{@kthletter@lastpage\the@kthletter@letter}{0}}{}%
  \if@twoside
    \ifodd\c@page \else\thispagestyle{empty}\null\newpage\fi
  \fi
  \setcounter{page}{1}%
  \setcounter{footnote}{0}%
  \interlinepenalty=200 % smaller than the TeXbook value
  \def\@kthletter@dnr{#1}%
  \@processto{\leavevmode\ignorespaces #2}%
}{%
  \stopletter\par\pagebreak\par
  \if@filesw
    \begingroup
    \let\\=\relax
    \let\protect\@unexpandable@protect
    \immediate\write\@auxout{%
      \string\@mlabel{\returnaddress}{\toname\\\toaddress}}%
    \endgroup
  \fi
}
\long\def\@processto#1{%
  \@xproc #1\\@@@%
  \ifx\toaddress\@empty
  \else
    \@yproc #1@@@%
  \fi}
\long\def\@xproc #1\\#2@@@{\def\toname{#1}\def\toaddress{#2}}
\long\def\@yproc #1\\#2@@@{\def\toaddress{#2}}
\newcommand*{\stopbreaks}{%
  \interlinepenalty\@M
  \def\par{\@@par\nobreak}%
  \let\\\@nobreakcr
  \let\vspace\@nobreakvspace}
\DeclareRobustCommand\@nobreakvspace
   {\@ifstar\@nobreakvspacex\@nobreakvspacex}
\def\@nobreakvspacex#1{%
  \ifvmode
    \nobreak\vskip #1\relax
  \else
    \@bsphack\vadjust{\nobreak\vskip #1}\@esphack
  \fi}
\def\@nobreakcr{\@ifstar{\@normalcr*}{\@normalcr*}}
\newcommand*{\startbreaks}{%
  \let\\\@normalcr
  \interlinepenalty 200%
  \def\par{\@@par\penalty 200\relax}}
\newcommand*{\@kthletter@DIN}{%
  \put(5,-105){\line(1,0){2}}
  \put(5,-210){\line(1,0){2}}
  \put(148,-5){\line(0,-1){2}}
  \put( 20,-45){\line( 1,0){1}}  \put( 20,-45){\line(0,-1){1}}
  \put(105,-45){\line(-1,0){1}}  \put(105,-45){\line(0,-1){1}}
  \put( 20,-50){\line( 1,0){1}}
  \put(105,-50){\line(-1,0){1}}
  \put( 20,-90){\line( 1,0){1}}  \put( 20,-90){\line(0, 1){1}}
  \put(105,-90){\line(-1,0){1}}  \put(105,-90){\line(0, 1){1}}
  \put( 25,-50){\makebox(0,5)[l]{\tiny
      \parbox{105mm}{\def\\{; }\noindent
        \fromname\\KTH -- \@kthletter@return}}}
  \put( 25,-90){\makebox(0,40)[l]{%
      \begin{tabular}{@{}l}\toname\\\toaddress\end{tabular}}}}
\newcommand*{\@kthletter@KTH}{%
  \put(5,-105){\line(1,0){2}}
  \put(5,-210){\line(1,0){2}}
  \put(25,-80){\makebox(0,0)[lb]{%
      \begin{tabular}{@{}l}\toname\\\toaddress\end{tabular}}}}
\newcommand*{\@kthletter@SS}{%
  \put(5,-105){\line(1,0){2}}
  \put(5,-210){\line(1,0){2}}
  \put(120,-64){\makebox(0,22)[l]{%
      \begin{tabular}{@{}l}\toname\\\toaddress\end{tabular}}}}
\newcommand*{\opening}[1]{%
  \centerline{%
    \setlength{\unitlength}{1mm}
    \begin{picture}(0,0)
      \if@kthletter@head
        \put(-95,20){\makebox(0,0)[t]{%
            \scalebox{0.25}{\includegraphics{\@kthletter@logo}}}}
        \put(22,10){\makebox(0,0)[lb]{%ciao}}%
            \begin{tabular}{p{0.45\textwidth}}%
              {\small\textbf{\@kthletter@dnrstr}}\\%
              \@kthletter@dnr\end{tabular}}}
      \fi
      %\@nameuse{@kthletter@\@kthletter@layout}
      %\put(120,-80){\makebox(0,0)[lb]{%
      %    \begin{tabular}{@{}l}\@kthletter@dnr\end{tabular}}}
      %\put(120,-85){\makebox(0,0)[lt]{%
      %    \begin{tabular}{@{}l}\@date\end{tabular}}}
    \end{picture}}
  %\begin{tabular}{p{0.6\textwidth}p{0.45\textwidth}}
  %  & \@kthletter@dnrstr \\
  %  & \@kthletter@dnr
  %\end{tabular}
  \vspace{5mm}
  \hfill
  \begin{minipage}{0.65\textwidth}
    \textbf{\@kthletter@recipientstr}\\
    \toname\\
    \toaddress
  \end{minipage}

  \vspace*{5mm}
  \@date\\[5mm]
  #1\par\nobreak}
\newcommand{\closing}[1]{\par\nobreak\vspace{\parskip}%
  \stopbreaks
  \noindent #1\\[4\medskipamount]%
  \ifdim\wd\@kthletter@signature=0pt
    \fromname
  \else
    \usebox{\@kthletter@signature}%
  \fi
  \par}
\newcommand*{\cc}[1]{%
  \par\noindent
  \parbox[t]{\textwidth}{%
    \@hangfrom{\normalfont\ccname: }%
    \ignorespaces #1\strut}\par}
\newcommand*{\encl}[1]{%
  \par\noindent
  \parbox[t]{\textwidth}{%
    \@hangfrom{\normalfont\enclname: }%
    \ignorespaces #1\strut}\par}
\newcommand*{\ps}{\par\startbreaks}
\newcommand*{\stopletter}{}
\newcount\labelcount
\newcommand*{\startlabels}{\labelcount\z@
  \pagestyle{empty}%
  \let\@texttop\relax
  \topmargin -50\p@
  \headsep \z@
  \oddsidemargin -35\p@
  \evensidemargin -35\p@
  \textheight 10in
  \@colht\textheight  \@colroom\textheight \vsize\textheight
  \textwidth 550\p@
  \columnsep 26\p@
  \ifcase \@ptsize\relax
    \normalsize
  \or
    \small
  \or
    \footnotesize
  \fi
  \baselineskip \z@
  \lineskip \z@
  \boxmaxdepth \z@
  \parindent \z@
  \twocolumn\relax}
\let\@startlabels=\relax
\newcommand*{\mlabel}[2]{%
  \parbox[b][2in][c]{262\p@}{\strut\ignorespaces #2}%
  }
\let\@mlabel=\@gobbletwo
\setlength\leftmargini   {2.5em}
\setlength\leftmarginii  {2.2em}
\setlength\leftmarginiii {1.87em}
\setlength\leftmarginiv  {1.7em}
\setlength\leftmarginv   {1em}
\setlength\leftmarginvi  {1em}
\setlength\leftmargin    {\leftmargini}
\setlength  \labelsep  {5\p@}
\setlength  \labelwidth{\leftmargini}
\addtolength\labelwidth{-\labelsep}
\setlength\partopsep{0\p@}
\@beginparpenalty -\@lowpenalty
\@endparpenalty   -\@lowpenalty
\@itempenalty     -\@lowpenalty
\def\@listI{\setlength\leftmargin{\leftmargini}%
            \setlength\parsep {0\p@}%
            \setlength\topsep {.4em}%
            \setlength\itemsep{.4em}}
\let\@listi\@listI
\@listi
\def\@listii {\setlength  \leftmargin{\leftmarginii}%
              \setlength  \labelwidth{\leftmarginii}%
              \addtolength\labelwidth{-\labelsep}}
\def\@listiii{\setlength  \leftmargin{\leftmarginiii}%
              \setlength  \labelwidth{\leftmarginiii}%
              \addtolength\labelwidth{-\labelsep}%
              \setlength  \topsep    {.2em}%
              \setlength  \itemsep   {\topsep}}
\def\@listiv {\setlength  \leftmargin{\leftmarginiv}%
              \setlength  \labelwidth{\leftmarginiv}%
              \addtolength\labelwidth{-\labelsep}}
\def\@listv  {\setlength  \leftmargin{\leftmarginv}%
              \setlength  \labelwidth{\leftmarginv}%
              \addtolength\labelwidth{-\labelsep}}
\def\@listvi {\setlength  \leftmargin{\leftmarginvi}%
              \setlength  \labelwidth{\leftmarginvi}%
              \addtolength\labelwidth{-\labelsep}}
\renewcommand\theenumi{\@arabic\c@enumi}
\renewcommand\theenumii{\@alph\c@enumii}
\renewcommand\theenumiii{\@roman\c@enumiii}
\renewcommand\theenumiv{\@Alph\c@enumiv}
\newcommand\labelenumi{\theenumi.}
\newcommand\labelenumii{(\theenumii)}
\newcommand\labelenumiii{\theenumiii.}
\newcommand\labelenumiv{\theenumiv.}
\renewcommand\p@enumii{\theenumi}
\renewcommand\p@enumiii{\theenumi(\theenumii)}
\renewcommand\p@enumiv{\p@enumiii\theenumiii}
\newcommand\labelitemi{\textbullet}
\newcommand\labelitemii{\normalfont\bfseries \textendash}
\newcommand\labelitemiii{\textasteriskcentered}
\newcommand\labelitemiv{\textperiodcentered}
\newenvironment{description}
               {\list{}{\labelwidth\z@ \itemindent-\leftmargin
                        \let\makelabel\descriptionlabel}}
               {\endlist}
\newcommand*{\descriptionlabel}[1]{\hspace\labelsep
                                \normalfont\bfseries #1}
\newenvironment{verse}
               {\let\\=\@centercr
                \list{}{\setlength\itemsep{\z@}%
                        \setlength\itemindent{-15\p@}%
                        \setlength\listparindent{\itemindent}%
                        \setlength\rightmargin{\leftmargin}%
                        \addtolength\leftmargin{15\p@}}%
                \item[]}
               {\endlist}
\newenvironment{quotation}
               {\list{}{\setlength\listparindent{1.5em}%
                        \setlength\itemindent{\listparindent}%
                        \setlength\rightmargin{\leftmargin}}%
                \item[]}
               {\endlist}
\newenvironment{quote}
               {\list{}{\setlength\rightmargin{\leftmargin}}%
                \item[]}
               {\endlist}
\setlength\arraycolsep{5\p@}
\setlength\tabcolsep{6\p@}
\setlength\arrayrulewidth{.4\p@}
\setlength\doublerulesep{2\p@}
\setlength\tabbingsep{\labelsep}
\skip\@mpfootins = \skip\footins
\setlength\fboxsep{3\p@}
\setlength\fboxrule{.4\p@}
\renewcommand\theequation{\@arabic\c@equation}
\DeclareOldFontCommand{\rm}{\normalfont\rmfamily}{\mathrm}
\DeclareOldFontCommand{\sf}{\normalfont\sffamily}{\mathsf}
\DeclareOldFontCommand{\tt}{\normalfont\ttfamily}{\mathtt}
\DeclareOldFontCommand{\bf}{\normalfont\bfseries}{\mathbf}
\DeclareOldFontCommand{\it}{\normalfont\itshape}{\mathit}
\DeclareOldFontCommand{\sl}{\normalfont\slshape}{\relax}
\DeclareOldFontCommand{\sc}{\normalfont\scshape}{\relax}
\DeclareRobustCommand*{\cal}{\@fontswitch{\relax}{\mathcal}}
\DeclareRobustCommand*{\mit}{\@fontswitch{\relax}{\mathnormal}}
\renewcommand\footnoterule{%
  \kern-\p@
  \hrule \@width .4\columnwidth
  \kern .6\p@}
\long\def\@makefntext#1{%
    \noindent
    \hangindent 5\p@
    \hb@xt@5\p@{\hss\@makefnmark}#1}
\newcommand*{\ccname}{cc}
\newcommand*{\enclname}{encl}
\newcommand*{\pagename}{Page}
\newcommand*{\headtoname}{To}
\newcommand*{\today}{\ifcase\month\or
  January\or February\or March\or April\or May\or June\or
  July\or August\or September\or October\or November\or December\fi
  \space\number\day, \number\year}
\setlength\columnsep{10\p@}
\setlength\columnseprule{0\p@}
\pagestyle{plain}
\pagenumbering{arabic}
\raggedbottom
\onecolumn
\endinput
%%
%% End of file `kthletter.cls'.
