\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{kthreport}[2016/06/21 KTH Report formatting /Giampiero Salvi]

\newif\ifinswedish
\DeclareOption{english}{}
\DeclareOption{swedish}{\inswedishtrue}

%% Send any unknown option to the report class
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}

\ProcessOptions\relax

\LoadClass[12pt]{article}

% Make it possible to conditionally depend on the TeX-engine used
\RequirePackage{ifxetex}
\RequirePackage{ifluatex}
\newif\ifxeorlua
\ifxetex\xeorluatrue\fi
\ifluatex\xeorluatrue\fi

%% Load other packages

\ifxeorlua
  \RequirePackage{polyglossia}
  \ifinswedish
    \setmainlanguage{swedish}
    \setotherlanguage{english}
  \else
    \setmainlanguage{english}
    \setotherlanguage{swedish}
  \fi
\else
  \RequirePackage[utf8]{inputenc}
  \RequirePackage[swedish,english]{babel}
\fi

\RequirePackage[a4paper,
  twoside,
  top=26mm,
  bottom=40mm,
  inner=26mm,
  outer=26mm,
  headsep=15mm,
  headheight=5mm,
  footskip=25mm]{geometry} % Set paper and contents dimensions
\RequirePackage{fancyhdr} % Take control of headers and footers
%\RequirePackage{emptypage} % Supress page numbers on otherwise empty pages
\RequirePackage[absolute]{textpos} % to place title box in first page
\setlength{\TPHorizModule}{1mm}%
\setlength{\TPVertModule}{1mm}%
\RequirePackage{graphicx} % to include the logo

\ifxeorlua
  \RequirePackage{fontspec}
  \defaultfontfeatures{Ligatures={TeX}} % This enables TeX style ligatures such as ---, '', ``, and so on
  \setmainfont{TeX Gyre Pagella} % Palatino from the TeX Gyre Project
\else
  \RequirePackage[T1]{fontenc}
  \RequirePackage{palatino}
\fi

% Set up the header and footer
\fancyhead{}
\fancyhead[RO]{}
\fancyhead[LE]{}
\fancyfoot{}
\renewcommand{\headrulewidth}{0pt}
\pagestyle{fancy}

% Add 5% extra linespacing
\linespread{1.05}

% Define commands for setting the user definable parts of the title page
\let\@diarienr\@empty
\newcommand{\diarienr}[1]{\def\@diarienr{#1}}
\let\@subtitle\@empty
\newcommand{\subtitle}[1]{\def\@subtitle{#1}}

% Command to print out the standardized title page
\renewcommand{\maketitle}{
  %\newgeometry{top=75mm,bottom=40mm,left=26mm,right=26mm}
  \thispagestyle{empty}
  \ifinswedish\selectlanguage{swedish}\fi
  \begin{textblock}{158}(10,15)%
    \begin{minipage}[t]{27mm}
      \vspace{0pt} % apparently needed to make the vertical alignment work
      \includegraphics[width=26mm]{KTH_Logotyp_CMYK_2013}
    \end{minipage}
    \begin{minipage}[t]{131mm}
      \vspace{0pt} % apparently needed to make the vertical alignment work
      \hfill
      \footnotesize
      \ifinswedish
      \begin{tabular}{p{3cm}p{3cm}p{3cm}}
        \textbf{RAPPORT} & \textbf{Dokumentdatum} & \textbf{Ev. diarienummer} \\
        & \@date & \@diarienr \\
        \multicolumn{3}{l}{\textbf{Skapat av}} \\
        \multicolumn{3}{l}{\@author} \\
      \end{tabular}
      \else
      \begin{tabular}{p{3cm}p{3cm}p{3cm}}
        \textbf{REPORT} & \textbf{Date} & \textbf{Reference number} \\
        & \@date & \@diarienr \\
        \multicolumn{3}{l}{\textbf{Created by}} \\
        \multicolumn{3}{l}{\@author} \\
      \end{tabular}
      \fi
    \end{minipage}
  \end{textblock}%
  \vspace*{3cm}
  \begin{huge}
    \begin{flushleft}
      \noindent\sffamily\bfseries \@title \par
    \end{flushleft}
  \end{huge}
  \ifx\@subtitle\@empty\relax
  \else
  \begin{Large}
    \vspace{-1ex}
    \begin{flushleft}
      \noindent\sffamily\bfseries \@subtitle \par
    \end{flushleft}
  \end{Large}
  \fi
}

\endinput
