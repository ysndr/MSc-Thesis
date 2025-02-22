%% forked from https://gits-15.sys.kth.se/giampi/kthlatex kthlatex-0.2rc4 on 2020-02-13
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{kththesis}[2018/04/26 KTH Thesis formatting]

\newif\ifdigitaloutput
\DeclareOption{digitaloutput}{\digitaloutputtrue}

% Add optional nomenclature pages following glossary
\newif\ifnomenclature
\DeclareOption{nomenclature}{\nomenclaturetrue}

\newif\ifinswedish
\DeclareOption{english}{}
\DeclareOption{swedish}{\inswedishtrue}

\newif\ifgfivepaper
\DeclareOption{a4paper}{}
\DeclareOption{g5paper}{\gfivepapertrue}

% options for bachelor or master thesis - not currently used
\newif\ifbachelor
\DeclareOption{bachelor}{\bachelortrue}
\DeclareOption{master}{}

\newif\ifbiblatex
\DeclareOption{bibtex}{}
\DeclareOption{biblatex}{\biblatextrue}

%% Send any unknown option to the report class
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{report}}

\ProcessOptions\relax

\ifgfivepaper
  \LoadClass[10pt]{report}
\else
  \LoadClass[12pt]{report}
\fi

% to do string comparison
\usepackage{xstring}

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
    \setotherlanguage[variant=us]{english}
    \setotherlanguages{french,spanish,italian,norsk,german,danish,dutch,estonian}
  \else
    \setmainlanguage[variant=us]{english}
    \setotherlanguages{swedish,french,spanish,italian,norsk,german,danish,dutch,estonian}
    %\setotherlanguage{swedish}
  \fi
\else
  \RequirePackage[utf8]{inputenc}
  \ifinswedish
    % can replace USenglish with UKenglish if desired
    \RequirePackage[main=swedish,english,french,spanish,italian,norsk,ngerman,danish,dutch,estonian]{babel}
  \else
    % can replace USenglish with UKenglish if desired
    \RequirePackage[main=english,swedish,french,spanish,italian,norsk,ngerman,danish,dutch,estonian]{babel}
  \fi
\fi

\ifgfivepaper
\RequirePackage[paperwidth=169mm,paperheight=239mm,twoside,
  top=30mm,bottom=30mm,inner=36mm,outer=18mm,
  headsep=10mm,headheight=5mm]{geometry} % Set paper and contents dimensions
\else
\RequirePackage[a4paper,twoside,
  top=37mm,bottom=50mm,inner=45mm,outer=35mm,
  headsep=15mm,headheight=6mm,footskip=25mm]{geometry} % Set paper and contents dimensions
\fi
\RequirePackage{fancyhdr} % Take control of headers and footers
%\RequirePackage{emptypage} % Supress page numbers on otherwise empty pages

\RequirePackage{pdfpages} % Used to include the preformatted KTH cover pages

\RequirePackage{titlesec} % Redefine the appearance of headers
% === Patch to circumvent a bug in the titlesec package version 2.10.1
\@ifpackagelater{titlesec}{2016/03/21}{%
 % Package titlesec is on version 2.10.2 or higher, nothing to do %
}{%
 % Check if package titlesec is on version 2.10.1 %
 \@ifpackagelater{titlesec}{2016/03/15}{%
  % Package titlesec on version 2.10.1, patch accordingly %
  \RequirePackage{etoolbox}%
  \patchcmd{\ttlh@hang}{\parindent\z@}{\parindent\z@\leavevmode}{}{}%
  \patchcmd{\ttlh@hang}{\noindent}{}{}{}%
 }{%
  % Package titlsecon is on version 2.10.0 or lower, nothing to do %
 }%
}
% === End ot titlesec patch

\ifxeorlua
  \RequirePackage{fontspec}
  \defaultfontfeatures{Ligatures={TeX}} % This enables TeX style ligatures such as ---, '', ``, and so on
  \setmainfont{TeX Gyre Termes}  %% Times like font
  \setsansfont{TeX Gyre Heros}   %% Helvetica like font
  \setmonofont{TeX Gyre Cursor}  %% Courier like font
\else
  \RequirePackage[T1]{fontenc}
  \RequirePackage{tgtermes}
  \RequirePackage{tgheros}
  \RequirePackage{tgcursor}
\fi

% Set up the header and footer
\fancyhead{}
%\fancyhead[RO]{\sffamily\small\leftmark\thinspace|\thinspace\thepage}
%\fancyhead[LE]{\sffamily\small\thepage\thinspace|\thinspace\leftmark}
% Without conversion to uppercase
\fancyhead[RO]{\sffamily\small\nouppercase\leftmark\thinspace|\thinspace\thepage}
\fancyhead[LE]{\sffamily\small\thepage\thinspace|\thinspace\nouppercase\leftmark}
\fancyfoot{}
\renewcommand{\headrulewidth}{0pt}
\pagestyle{fancy}

% Add 5% extra linespacing
\linespread{1.05}

% Set the proper format for the headers
\titleformat{\chapter}[display]
  {\normalfont\sffamily\huge\bfseries}
  {\chaptertitlename\ \thechapter}{20pt}{\Huge}
\titleformat{\section}
  {\normalfont\sffamily\Large\bfseries}
  {\thesection}{1em}{}
\titleformat{\subsection}
  {\normalfont\sffamily\large\bfseries}
  {\thesubsection}{1em}{}
\titleformat{\subsubsection}
  {\normalfont\sffamily\normalsize\bfseries}
  {\thesubsubsection}{1em}{}

\renewenvironment{abstract}{\section*{\abstractname}}

% Define commands for setting the user definable parts of the title page

\let\@subtitle\@empty
\newcommand{\subtitle}[1]{\def\@subtitle{#1}}
\let\@alttitle\@empty
\newcommand{\alttitle}[1]{\def\@alttitle{#1}}
\let\@altsubtitle\@empty
\newcommand{\altsubtitle}[1]{\def\@altsubtitle{#1}}
\let\@hostcompany\@empty
\newcommand{\hostcompany}[1]{\def\@hostcompany{#1}}
\let\@hostorganization\@empty
\newcommand{\hostorganization}[1]{\def\@hostorganization{#1}}

\let\@school\@empty
\newcommand{\school}[1]{\def\@school{#1}}

% First author's information
\let\@authorsLastname\@empty
\newcommand{\authorsLastname}[1]{\def\@authorsLastname{#1}}
\let\@authorsFirstname\@empty
\newcommand{\authorsFirstname}[1]{\def\@authorsFirstname{#1}}
\let\@email\@empty
\newcommand{\email}[1]{\def\@email{#1}}
\let\@kthid\@empty
\newcommand{\kthid}[1]{\def\@kthid{#1}}
%\let\@orcid\@empty
%\newcommand{\orcid}[1]{\def\@orcid{#1}}
\let\@authorsSchool\@empty
\newcommand{\authorsSchool}[1]{\def\@authorsSchool{#1}}
\let\@authorsDepartment\@empty
\newcommand{\authorsDepartment}[1]{\def\@authorsDepartment{#1}}
% Information about the city and country for the acknowledgement
\let\@authorCity\@empty
\newcommand{\authorCity}[1]{\def\@authorCity{#1}}
\let\@authorCountry\@empty
\newcommand{\authorCountry}[1]{\def\@authorCountry{#1}}
\let\@authorCityCountryDate\@empty
% Define the command so that if a date is not specified it will not output the comma; it only outputs the comma if there is a date.
\ExplSyntaxOn
\cs_set_eq:NN  \IfEmptyTF  \tl_if_blank:nTF
\ExplSyntaxOff
\NewDocumentCommand{\authorCityCountryDate}{m}{
\def\@authorCityCountryDate{\ifx\@authorCity\@empty%
    Stockholm%
    \else%
    \ifx\@authorCountry\@empty%
    \@authorCity%
    \else%
    \@authorCity, \@authorCountry%
    \fi%
    \fi%
    \IfEmptyTF{#1}{}{, #1}%
    }%
}
\authorCityCountryDate{\MONTH\enspace\the\year} % default month and year for the acknowledgement signature

% Second author's information
\let\@secondAuthorsLastname\@empty
\newcommand{\secondAuthorsLastname}[1]{\def\@secondAuthorsLastname{#1}}
\let\@secondAuthorsFirstname\@empty
\newcommand{\secondAuthorsFirstname}[1]{\def\@secondAuthorsFirstname{#1}}
\let\@secondemail\@empty
\newcommand{\secondemail}[1]{\def\@secondemail{#1}}
\let\@secondkthid\@empty
\newcommand{\secondkthid}[1]{\def\@secondkthid{#1}}
%\let\@secondorcid\@empty
%\newcommand{\secondorcid}[1]{\def\@secondorcid{#1}}
\let\@secondAuthorsSchool\@empty
\newcommand{\secondAuthorsSchool}[1]{\def\@secondAuthorsSchool{#1}}
\let\@secondAuthorsDepartment\@empty
\newcommand{\secondAuthorsDepartment}[1]{\def\@secondAuthorsDepartment{#1}}
% Information about the city and country for the acknowledgement
\let\@secondAuthorCity\@empty
\newcommand{\secondAuthorCity}[1]{\def\@secondAuthorCity{#1}}
\let\@secondAuthorCountry\@empty
\newcommand{\secondAuthorCountry}[1]{\def\@secondAuthorCountry{#1}}
\let\@secondAuthorCityCountryDate\@empty
% Define the command so if a date is not specified it will not output the comma; it only outputs the comma if there is a date.
\NewDocumentCommand{\secondAuthorCityCountryDate}{m}{
\def\@secondAuthorCityCountryDate{\ifx\@secondAuthorCity\@empty%
    Stockholm%
    \else%
    \ifx\@secondAuthorCountry\@empty%
    \@secondAuthorCity%
    \else%
    \@secondAuthorCity, \@secondAuthorCountry%
    \fi%
    \fi%
    \IfEmptyTF{#1}{}{, #1}%%
    }%
}

\let\@supervisorAsLastname\@empty
\newcommand{\supervisorAsLastname}[1]{\def\@supervisorAsLastname{#1}}
\let\@supervisorAsFirstname\@empty
\newcommand{\supervisorAsFirstname}[1]{\def\@supervisorAsFirstname{#1}}
\let\@supervisorAsEmail\@empty
\newcommand{\supervisorAsEmail}[1]{\def\@supervisorAsEmail{#1}}
\let\@supervisorAsKTHID\@empty
\newcommand{\supervisorAsKTHID}[1]{\def\@supervisorAsKTHID{#1}}
\let\@supervisorAsOrganization\@empty
\newcommand{\supervisorAsOrganization}[1]{\def\@supervisorAsOrganization{#1}}
\let\@supervisorAsSchool\@empty
\newcommand{\supervisorAsSchool}[1]{\def\@supervisorAsSchool{#1}}
\let\@supervisorAsDepartment\@empty
\newcommand{\supervisorAsDepartment}[1]{\def\@supervisorAsDepartment{#1}}

\let\@supervisorBsLastname\@empty
\newcommand{\supervisorBsLastname}[1]{\def\@supervisorBsLastname{#1}}
\let\@supervisorBsFirstname\@empty
\newcommand{\supervisorBsFirstname}[1]{\def\@supervisorBsFirstname{#1}}
\let\@supervisorBsEmail\@empty
\newcommand{\supervisorBsEmail}[1]{\def\@supervisorBsEmail{#1}}
\let\@supervisorBsKTHID\@empty
\newcommand{\supervisorBsKTHID}[1]{\def\@supervisorBsKTHID{#1}}
\let\@supervisorBsOrganization\@empty
\newcommand{\supervisorBsOrganization}[1]{\def\@supervisorBsOrganization{#1}}
\let\@supervisorBsSchool\@empty
\newcommand{\supervisorBsSchool}[1]{\def\@supervisorBsSchool{#1}}
\let\@supervisorBsDepartment\@empty
\newcommand{\supervisorBsDepartment}[1]{\def\@supervisorBsDepartment{#1}}

\let\@supervisorCsLastname\@empty
\newcommand{\supervisorCsLastname}[1]{\def\@supervisorCsLastname{#1}}
\let\@supervisorCsFirstname\@empty
\newcommand{\supervisorCsFirstname}[1]{\def\@supervisorCsFirstname{#1}}
\let\@supervisorCsEmail\@empty
\newcommand{\supervisorCsEmail}[1]{\def\@supervisorCsEmail{#1}}
\let\@supervisorCsKTHID\@empty
\newcommand{\supervisorCsKTHID}[1]{\def\@supervisorCsKTHID{#1}}
\let\@supervisorCsOrganization\@empty
\newcommand{\supervisorCsOrganization}[1]{\def\@supervisorCsOrganization{#1}}
\let\@supervisorCsSchool\@empty
\newcommand{\supervisorCsSchool}[1]{\def\@supervisorCsSchool{#1}}
\let\@supervisorCsDepartment\@empty
\newcommand{\supervisorCsDepartment}[1]{\def\@supervisorCsDepartment{#1}}

\let\@examinersLastname\@empty
\newcommand{\examinersLastname}[1]{\def\@examinersLastname{#1}}
\let\@examinersFirstname\@empty
\newcommand{\examinersFirstname}[1]{\def\@examinersFirstname{#1}}
\let\@examinersEmail\@empty
\newcommand{\examinersEmail}[1]{\def\@examinersEmail{#1}}
\let\@examinersKTHID\@empty
\newcommand{\examinersKTHID}[1]{\def\@examinersKTHID{#1}}
\let\@examinersOrganization\@empty
\newcommand{\examinersOrganization}[1]{\def\@examinersOrganization{#1}}
\let\@examinersSchool\@empty
\newcommand{\examinersSchool}[1]{\def\@examinersSchool{#1}}
\let\@examinersDepartment\@empty
\newcommand{\examinersDepartment}[1]{\def\@examinersDepartment{#1}}

\let\@courseCycle\@empty
\newcommand{\courseCycle}[1]{\def\@courseCycle{#1}}
\let\@courseCode\@empty
\newcommand{\courseCode}[1]{\def\@courseCode{#1}}
\let\@courseCredits\@empty
\newcommand{\courseCredits}[1]{\def\@courseCredits{#1}}

\let\@degreeName\@empty
\newcommand{\degreeName}[1]{\def\@degreeName{#1}}
\let\@subjectArea\@empty
\newcommand{\subjectArea}[1]{\def\@subjectArea{#1}}

\let\@secondDegreeName\@empty
\newcommand{\secondDegreeName}[1]{\def\@secondDegreeName{#1}}
\let\@secondSubjectArea\@empty
\newcommand{\secondSubjectArea}[1]{\def\@secondSubjectArea{#1}}

% Data related to the oral presentation
\let\@presentationDateAndTimeISO\@empty
\newcommand{\presentationDateAndTimeISO}[1]{\def\@presentationDateAndTimeISO{#1}}
\let\@presentationLanguage\@empty
\newcommand{\presentationLanguage}[1]{\def\@presentationLanguage{#1}}
\let\@presentationRoom\@empty
\newcommand{\presentationRoom}[1]{\def\@presentationRoom{#1}}
\let\@presentationAddress\@empty
\newcommand{\presentationAddress}[1]{\def\@presentationAddress{#1}}
\let\@presentationCity\@empty
\newcommand{\presentationCity}[1]{\def\@presentationCity{#1}}

\let\@opponentsNames\@empty
\newcommand{\opponentsNames}[1]{\def\@opponentsNames{#1}}

% Data for DIVA National Subject Cateories fields
\let\@nationalsubjectcategories\@empty
\newcommand{\nationalsubjectcategories}[1]{\def\@nationalsubjectcategories{#1}}

% Keywords
\let\@EnglishKeywords\@empty
\newcommand{\EnglishKeywords}[1]{\def\@EnglishKeywords{#1}}

\let\@SwedishKeywords\@empty
\newcommand{\SwedishKeywords}[1]{\def\@SwedishKeywords{#1}}

\ExplSyntaxOn
\cs_new_eq:NN \strcompare \str_if_eq:nnTF
\ExplSyntaxOff

\makeatletter
%% Changed to use expl3 strcompare rather than xstring's IfEqCase, since the later is not expandable
%% The insight for this is from Enrico Gregorio - egreg's posing of 26 April 2016 at 
%% https://tex.stackexchange.com/questions/306484/how-do-i-perform-an-expandable-string-comparison

\newcommand{\InsertKeywords}[1]{
\strcompare{#1}{english}{\@EnglishKeywords}{}%
\strcompare{#1}{swedish}{\@SwedishKeywords}{}%
}
\makeatletter


\let\@programcode\@empty
\newcommand{\programcode}[1]{%
\def\@programcode{#1}%
\edef\@prgmcode{\programmecode{#1}}}

\let\@secondProgramcode\@empty
\newcommand{\secondProgramcode}[1]{%
\def\@secondProgramcode{#1}%
\edef\@secondprgmcode{\programmecode{#1}}}

\let\@edprogram\@empty
\newcommand{\edprogram}[1]{%
\def\@edprogram{#1}}

\let\@secondedProgram\@empty
\newcommand{\secondedProgram}[1]{%
\def\@secondedProgram{#1}}

% to store the user's choice of copyright or copyleft
\let\@copyrightleft\@empty
% note that the command has to change the definiton of \@copyrightleft globally, hence \gdef and not \def
\newcommand{\thesiscopyrightleft}[1]{\gdef\@copyrightleft{#1}}

% get all of the information about the school codes and program codes
\input{lib/schools_and_programs.ins}

\newcommand{\MONTH}{%
  \ifinswedish
  \ifcase\the\month
  \or januari% 1
  \or februari% 2
  \or mars% 3
  \or april% 4
  \or maj% 5
  \or juni% 6
  \or juli% 7
  \or augusti% 8
  \or september% 9
  \or oktober% 10
  \or november% 11
  \or december% 12
  \fi
  \else
  \ifcase\the\month
  \or January% 1
  \or February% 2
  \or March% 3
  \or April% 4
  \or May% 5
  \or June% 6
  \or July% 7
  \or August% 8
  \or September% 9
  \or October% 10
  \or November% 11
  \or December% 12
  \fi
\fi
}

% Get and store information about the series and the number within this series, i.e, TRITA numbers
%"Series": \{
%	"Title of series": "TRITA-ICT-EX",
%	"No. in series": "2019:00"
\let\@thesisSeries\@empty
\let\@thesisSeriesNumber\@empty
\newcommand{\trita}[2]{\def\@thesisSeries{#1}\def\@thesisSeriesNumber{#2}}

% for new KTH cover
% Load the Arial font as it is used for the KTH covers
% 
\ifluatex
\newfontfamily\coverlfont[Ligatures=TeX]{Arial}
    
\newfontfamily\coverbfont[Ligatures=TeX]{Arial Bold}
\else
\ifxetex
\newfontfamily\coverlfont[Mapping=tex-text]{Arial}
    
\newfontfamily\coverbfont[Mapping=tex-text]{Arial Bold}
%\newfontfamily\coversbfont[Mapping=tex-text]{Arial Medium}
\else
\newcommand\coverlfont{\fontfamily{helvet}\selectfont\sffamily}
\newcommand\coverbfont{\fontfamily{helvet}\selectfont\sffamily\bfseries}
\fi
\fi
% For information about the page layout see https://www.overleaf.com/learn/latex/Page_size_and_margins
\newcommand{\kthcover}{
% Note that the values have only been adjusted for A4 paper!
\ifgfivepaper
  \newgeometry{top=65mm,bottom=30mm,left=62mm,right=18mm}
\else
  \newgeometry{top=56mm,bottom=30mm,left=74pt, right=35mm} % formerly {top=56mm,bottom=30mm,left=74pt, right=35mm}
\fi

\thispagestyle{empty}

% Note that the English cover has additional text on it, sop generate it
\ifinswedish
\null
\else
\begin{textblock*}{100pt}(451.559pt, 33.88pt) % {block width} (coords) - formerly 481.748pt, 28pt
\includegraphics{KTH_ROYAL_INSTITUTE_OF_TECHNOLOGY_logotype.png} % formerly width=76.2pt, height=76.2pt
%\noindent{\fontsize{9.5}{10}\coverbfont
%    \textcolor{black}{KTH ROYAL INSTITUTE} % formerly     \textcolor{black!80!}{KTH ROYAL INSTITUTE}
%}
\end{textblock*}
%\begin{textblock*}{85pt}(451.559pt, 44.22pt) % {block width} (coords) -formerly 481.748pt, 38pt
%\noindent{\fontsize{9.5}{10}\coverbfont
%    \textcolor{black}{OF TECHNOLOGY}
%}
%\end{textblock*}
\fi

\begin{textblock*}{72.85pt}(20pt, 33.88pt) % formerly 20pt, 40pt
\includegraphics[width=72.85pt, height=72.85pt, keepaspectratio]{kth_logo.png} % formerly width=76.2pt, height=76.2pt
\end{textblock*}
\begin{flushleft}

% look for a second subject
\ifx\@secondSubjectArea\@empty
{\coverlfont \fontsize{12}{13}
  \ifinswedish
  Examensarbete inom \@subjectArea\\
  \addvspace{8pt}
  \IfEqCase{\@courseCycle}{%
    {1}{Grundnivå,}%
    {2}{Avancerad nivå,}%
  }[\typeout{unknown cycle}]
~\IfEqCase{\@courseCredits}{%
    {5.0}{5}%
    {7.5}{7,5}%
    {10.0}{10}%
    {12.0}{12}%
    {14.0}{14}%
    {15.0}{15}%
    {16.0}{16}%
    {18.0}{18}%
    {20.0}{20}%
    {22.5}{22,5}%
    {28.0}{28}%
    {30.0}{30}%
    {35.0}{33}%
    {37.5}{37,5}%
    {45.0}{45}%
    {60.0}{60}%
    {90.0}{90}%
    {120.0}{120}%
    {180.0}{180}%
    {210.0}{210}%
    {240.0}{240}%
    {300.0}{300}%
    {330.0}{330}%
    }[\typeout{unknown credits}]%
~hp\\
  \else
  Degree Project in \@subjectArea\\
  \addvspace{8pt}
  \IfEqCase{\@courseCycle}{%
    {1}{First cycle,}%
    {2}{Second cycle,}%
  }[\typeout{unknown cycle}]
\,\IfEqCase{\@courseCredits}{%
    {5.0}{5}%
    {7.5}{7.5}%
    {10.0}{10}%
    {12.0}{12}%
    {14.0}{14}%
    {15.0}{15}%
    {16.0}{16}%
    {18.0}{18}%
    {20.0}{20}%
    {22.5}{22.5}%
    {28.0}{28}%
    {30.0}{30}%
    {35.0}{33}%
    {37.5}{37.5}%
    {45.0}{45}%
    {60.0}{60}%
    {90.0}{90}%
    {120.0}{120}%
    {180.0}{180}%
    {210.0}{210}%
    {240.0}{240}%
    {300.0}{300}%
    {330.0}{330}%
    }[\typeout{unknown credits}]%
~credits\\
  \fi
    
}
\else
{\coverlfont \fontsize{12}{13}
  \ifinswedish
      \ifthenelse{\equal{\@subjectArea}{\@secondSubjectArea}}
    {Examensarbete inom teknikområdet och huvudområdet \@subjectArea\\}
    {Examensarbete inom teknikområdet \@subjectArea\ och huvudområdet \@secondSubjectArea\\}%
%  \IfEqCase{\@degreeName}{%
%    {Both}{Examensarbete inom teknikområdet \@subjectArea\ och huvudområdet \@secondSubjectArea\\}%
%    {Same}{Examensarbete inom teknikområdet och huvudområdet \@subjectArea\\}%
%  }[\typeout{unknown degree name in case for both Masters degrees}]
  \addvspace{8pt}
  \IfEqCase{\@courseCycle}{%
    {1}{Grundnivå,}%
    {2}{Avancerad nivå,}%
  }[\typeout{unknown cycle}]
~\IfEqCase{\@courseCredits}{%
    {15.0}{15}%
    {30.0}{30}%
    }[\typeout{unknown credits}]%
~hp\\
  \else
  \ifthenelse{\equal{\@subjectArea}{\@secondSubjectArea}}
    {Degree Project in the Field of Technology and the Main Field of Study \@subjectArea\\}
    {Degree Project in the Field of Technology \@subjectArea\ and the Main Field of Study \@secondSubjectArea\\}%
%    \IfEqCase{\@degreeName}{%
%    {Both}{Degree Project in the Field of Technology \@subjectArea\ and the Main Field of Study \@secondSubjectArea\\}%
%    {Same}{Degree Project in the Field of Technology and the Main Field of Study \@subjectArea\\}%
%  }[\typeout{unknown degree name in case for both Masters degrees}]
  
  \addvspace{8pt}
  \IfEqCase{\@courseCycle}{%
    {1}{First cycle,}%
    {2}{Second cycle,}%
  }[\typeout{unknown cycle}]
\,\IfEqCase{\@courseCredits}{%
    {15.0}{15}%
    {30.0}{30}%
    }[\typeout{unknown credits}]%
~credits\\
  \fi
    
}
\fi
\addvspace{40pt}
{\fontsize{26}{30}\coverbfont \@title \par }


\ifx\@subtitle\@empty\relax
\else
\addvspace{12pt}
    {\fontsize{16}{18}\coverlfont  \@subtitle \par }
\fi

\addvspace{30pt}
    {\fontsize{12}{13}\coverbfont
    \expandafter\MakeUppercase\expandafter\@authorsFirstname\space\expandafter\MakeUppercase\expandafter\@authorsLastname \par
    \ifx\@secondAuthorsLastname\@empty\relax
    \else\addvspace{2pt}\expandafter\MakeUppercase\expandafter\@secondAuthorsFirstname\space\expandafter\MakeUppercase\expandafter\@secondAuthorsLastname \par
    \fi
    }
\end{flushleft}
\vfill
\begin{textblock*}{510pt}(38.83pt, {\paperheight - 46pt}) % {block width} (coords) 
\ifinswedish
\noindent{\fontsize{8}{10}\coverlfont Stockholm, Sverige, \the\year{}}\\
  \else
\noindent{\fontsize{8}{10}\coverlfont Stockholm, Sweden, \the\year{}}\\
  \fi
\end{textblock*}
\begin{textblock*}{510pt}(37.7pt, {\paperheight - 34pt}) % {block width} (coords) 
%\vspace*{-22pt}
\begin{tikzpicture}
\draw[kth-blue, line width=1.0 pt] (0pt,0pt) -- (510pt,0pt);
\end{tikzpicture}
\end{textblock*}
\restoregeometry
\clearpage
}

\newcommand{\kthbackcover}{
% Note that the values have only been adjusted for A4 paper!
\ifgfivepaper
  \newgeometry{top=65mm,bottom=30mm,left=62mm,right=18mm}
\else
  \newgeometry{top=65mm,bottom=30mm,left=74pt, right=35mm}
\fi

\thispagestyle{empty}

% Generate the back cover with the TRITA number and the fixed graphical elements
\begin{textblock*}{5cm}(38.83pt, {\paperheight - 72pt}) % {block width} (coords) 
\noindent{\fontsize{10}{12}\coverlfont 
    \ifx\@thesisSeries\@empty %\relax
        TRITA xxxx:yyy
        \else
        	\@thesisSeries-
        	\ifx\@thesisSeriesNumber\@empty\relax
            \else
            \@thesisSeriesNumber
             \fi
    \fi\\
}
\end{textblock*}
\begin{textblock*}{5cm}(38.83pt, {\paperheight - 44pt}) % {block width} (coords)  - was 44pt
\noindent{\fontsize{8}{9}\coverlfont
    \textcolor{kth-blue}{www.kth.se}
}
\end{textblock*}
\begin{textblock*}{510pt}(19pt, {\paperheight - 34pt}) % {block width} (coords) - was 24.634pt
%\vspace*{-22pt}
\begin{tikzpicture}
\draw[kth-blue, line width=1.0 pt] (0pt,0pt) -- (510pt,0pt);
\end{tikzpicture}
\end{textblock*}
\restoregeometry
\null\newpage
}

% Command to print out the standardized title page
\renewcommand{\titlepage}{
\ifgfivepaper
  \newgeometry{top=65mm,bottom=30mm,left=62mm,right=18mm}
\else
  \newgeometry{top=65mm,bottom=30mm,left=74pt,right=35mm} % formerly left=50mm
\fi

\thispagestyle{empty}

\ifinswedish\selectlanguage{swedish}\fi

\begin{huge}
  \begin{flushleft}
    \noindent\sffamily\bfseries \@title \par
  \end{flushleft}
\end{huge}

\ifx\@subtitle\@empty\relax
\else
\begin{Large}
  \vspace{1ex}
  \begin{flushleft}
    \noindent\sffamily\bfseries \@subtitle \par
  \end{flushleft}
\end{Large}
\fi


\vspace{10mm}
\begin{large}
  \begin{flushleft}
    \sffamily
    \expandafter\MakeUppercase\expandafter\@authorsFirstname\space\expandafter\MakeUppercase\expandafter\@authorsLastname \par
    \ifx\@secondAuthorsLastname\@empty\relax
    \else\vspace{1ex}\expandafter\MakeUppercase\expandafter\@secondAuthorsFirstname\space\expandafter\MakeUppercase\expandafter\@secondAuthorsLastname \par
    \fi
  \end{flushleft}
\end{large}

\vfill

\begin{flushleft}
  \sffamily
  \ifinswedish
%    \programmecode{\@programcode}\par
%    \ifx\@secondProgramcode och \programmecode{\@secondProgramcode} \par \fi  % for a second program
    \@prgmcode\par
    \ifx\@prgmcode och \@secondprgmcode \par  \fi   % for a second program
    \ifx\@date\@empty\relax\else Datum: \@date\\ \vspace{5mm} \fi
    \ifx\@supervisorCsLastname\@empty
    \ifx\@supervisorBsLastname\@empty
    Handledare: \@supervisorAsFirstname\space\@supervisorAsLastname
        \else
    Handledare: \@supervisorAsFirstname\space\@supervisorAsLastname,  \@supervisorBsFirstname\space\@supervisorBsLastname
        \fi
    \else
        Handledare: \@supervisorAsFirstname\space\@supervisorAsLastname,  \@supervisorBsFirstname\space\@supervisorBsLastname,
            \@supervisorCsFirstname\space\@supervisorCsLastname
    \par
    \fi
    Examinator: \@examinersFirstname\space\@examinersLastname\par
    \quad\@examinersSchool\par
    \ifx\@hostcompany\@empty\relax\else Uppdragsgivare: \@hostcompany \par \fi
    \ifx\@hostorganization\@empty\relax\else Uppdragsgivare: \@hostorganization \par \fi
    \ifx\@alttitle\empty\relax\else Engelsk titel: %
    \begin{otherlanguage}{english}\sffamily\@alttitle\end{otherlanguage} \fi
    \ifx\@altsubtitle\@empty\relax
    \else
    English subtitle \begin{otherlanguage}{english}\sffamily\@altsubtitle\end{otherlanguage} \\
    \fi
  \else
    \@prgmcode\par
    \ifx\@prgmcode och \@secondprgmcode \par  \fi   % for a second program
    \ifx\@date\@empty\relax\else Date: \@date\\ \vspace{5mm} \fi
    
    \ifx\@supervisorCsLastname\@empty
        \ifx\@supervisorBsLastname\@empty
    Supervisor: \@supervisorAsFirstname\space\@supervisorAsLastname
        \else
    Supervisors: \@supervisorAsFirstname\space\@supervisorAsLastname,  \@supervisorBsFirstname\space\@supervisorBsLastname
        \fi
    \else
        Supervisors: \@supervisorAsFirstname\space\@supervisorAsLastname,  \@supervisorBsFirstname\space\@supervisorBsLastname,
            \@supervisorCsFirstname\space\@supervisorCsLastname
    \par
    \fi

    Examiner: \@examinersFirstname\space\@examinersLastname\par
    \quad\@examinersSchool\par
    \ifx\@hostcompany\@empty\relax\else Host company: \@hostcompany \par \fi
    \ifx\@hostorganization\@empty\relax\else Host organization: \@hostorganization \par \fi
    \ifx\@alttitle\empty\relax\else Swedish title: %
        \begin{otherlanguage}{swedish}\sffamily\@alttitle\end{otherlanguage}  \par \fi
    \ifx\@altsubtitle\@empty\relax \else Swedish subtitle: %
        \begin{otherlanguage}{swedish}\sffamily\@altsubtitle\end{otherlanguage} \par \fi
  \fi
\end{flushleft}
\restoregeometry
\clearpage
}

% Command to print out the standardized document information page
\newcommand{\bookinfopage}{
\ifgfivepaper
  \newgeometry{top=140mm,bottom=30mm,left=12.25mm,right=35mm}
\else
  \newgeometry{top=250mm,bottom=30mm,left=74pt,right=35mm}
\fi
\thispagestyle{empty}
\begin{flushleft}
  \sffamily
  \copyright\enspace\the\year\quad\@authorsFirstname\space\@authorsLastname 
  \ifx\@secondAuthorsLastname\@empty\relax
  \else
    \ifinswedish
      \enspace och\enspace\@secondAuthorsFirstname\space\@secondAuthorsLastname \\
    \else
      \enspace and\enspace\@secondAuthorsFirstname\space\@secondAuthorsLastname \\
    \fi
  \fi
\end{flushleft}
\thesiscopyrightleft{copyright}
\restoregeometry
\clearpage
}

% bookinfo page with CC license
% CC BY (Attribution)
% CC BY-NC (Attribution + Non-commercial)
% CC BY-ND (Attribution + No derivatives)
% CC BY-NC-ND (Attribution + Non-commercial + No derivatives)
% CC BY-SA (Attribution + ShareAlike)
% CC BY-NC-SA (Attribution + Non-commercial + ShareAlike)
% CC0 (Zero)
\newcommand{\bookinfopageCC}{
\ifgfivepaper
  \newgeometry{top=130mm,bottom=30mm,left=12.25mm,right=35mm}
\else
  \newgeometry{top=220mm,bottom=30mm,left=74pt,right=35mm}
\fi
\thispagestyle{empty}
\begin{flushleft}
  \sffamily
  \IfEqCase{\doclicense@modifier}{%
    {by}{CC BY}%
    {by-nc}{CC BY-NC}%
    {by-nd}{CC BY-ND}%
    {by-nc-nd}{CC BY-NC-ND}%
    {by-sa}{CC BY-SA}%
    {by-nc-sa}{CC BY-NC-SA}%
    {zero}{CC0}%
  }[\typeout{Creative Commons code  \doclicense@modifier not found}\copyright]
  \enspace\the\year\quad\@authorsFirstname\space\@authorsLastname 
  \ifx\@secondAuthorsLastname\@empty\relax
  \else
    \ifinswedish
      \enspace och\enspace\@secondAuthorsFirstname\space\@secondAuthorsLastname \\
    \else
      \enspace and\enspace\@secondAuthorsFirstname\space\@secondAuthorsLastname \\
    \fi
  \fi
  \doclicenseThis
\end{flushleft}
\thesiscopyrightleft{\doclicense@modifier}
\restoregeometry
\clearpage
}

% If the doclicense pacakage is installed, the use the \bookinfoCC when encountering a \bookinfo command
\AtBeginDocument{\@ifpackageloaded{doclicense}
  {%
    \renewcommand{\bookinfopage}{\bookinfopageCC}
  }
  {\relax}
}

\newcommand{\acknowlegmentssignature}{
 \ifx\@secondAuthorsLastname\@empty
 \begin{flushleft}
\@authorCityCountryDate\\
    \@authorsFirstname\space\@authorsLastname
 \end{flushleft}
\else
\begin{flushleft}
\begin{tabular}{l l}
\@authorCityCountryDate & \@secondAuthorCityCountryDate \\
    \@authorsFirstname\space\@authorsLastname &
    \@secondAuthorsFirstname\space\@secondAuthorsLastname \\
%       \ifinswedish
%       \enspace & \enspace\@secondAuthorsFirstname\space\@secondAuthorsLastname \\
%       \else
%       \enspace and\enspace\@secondAuthorsFirstname\space\@secondAuthorsLastname \\
%       \fi
\end{tabular}
\end{flushleft}
\fi

\cleardoublepage
}

\newcommand{\frontmatter}{
  \pagenumbering{roman}
  % when using backref with hyperref one cannot manually reset the page numbers, but needs to use different numbering schemes - see https://tex.stackexchange.com/questions/93889/why-does-backref-refer-to-wrong-page
%  \setcounter{page}{1}
}

\newcommand{\mainmatter}{
  \cleardoublepage
  \pagenumbering{arabic}
}

% {
%    "Author1":{
%	"Last name": "Maguire Jr.",
%	"First name": "Gerald Q.",
%	"Local User Id": "u1d13i2c",
%	"Research group": "CCS",
%	"E-mail": "maguire@kth.se",
%	"organisation": {"L1": "School of Information and Communication Technology (ICT)",
%			 "L2": "Communication Systems, CoS"
%			}
%    },
%    "Author2":{
%	"Last name": "Noz",
%	"First name": "Marilyn E.",
%	"E-mail": "men@bogus.org",
%	"Other organisation": "NYU"
%    },
%
%    "Cooperation":{
%	"Partner_name": "ABBBBA"
%    },
%    "Title":{
%	"Main title": "This is a long title in English",
%	"Subtitle": "This is an even longer subtitle in English",
%	"Language": "eng"	
%    },
%    "Alternative title":{
%	"Main title": "Detta är en lång titel på svenska",
%	"Subtitle": "Detta är en ännu längre undertexter på svenska",
%	"Language": "swe"
%    },
%    "Degree":{
%	"Level": "Independent thesis Basic level (degree of Bachelor)",
%	"University credits": "15 HE credits",
%	"Educational program": "Bachelor of Science in Engineering - Computer Engineering",
%	"Subject_course": "Communications Systems"
%    },
%    "Content category":{
%    },
%    "Other information":{
%	"Year": "2019",
%	"Number of pages": "xiii,72"
%    },
%    "Series":{
%	"Title of series": "TRITA-ICT-EX",
%	"No. in series": "2019:00"
%    },
%    "Other series":{
%	"Title of series": "",
%	"ISSN": "",
%	"EISSN": "",
%	"No. in series": ""
%    },
%    "Identifiers":{
%	"ISRN": "",
%	"DOI": "",
%	"DOI_Free_full_text": "",
%	"URL": "",
%	"URL label": "",
%	"URL_Free_full_text": ""
%    },
%    "National subject category":{
%	"L1": "Engineering and Technology",
%	"L2": "Electrical Engineering, Electronic Engineering, Information Engineering",
%	"L3": "Communication Systems"
%    },
%    "Part of project":{
%    },
%    "Part of other project":{
%	"Project_name": ""
%    },
%    "Keywords1":{
%	"Keywords": "Fiddle,Fee,Foo,Fum",
%	"Language": "eng"
%    },
%    "Keywords2":{
%	"Keywords": "Faddle,Fåå,Fää,Fööm",
%	"Language": "swe"
%    },
%    "Abstract1":{
%	"Abstract":	"<p>This is a abstract for an non existant thesis about <sup>18</sup>F<sup>-</sup></p>",
%	"Language": "eng"
%    },
%    "Abstract2":{
%	"Abstract":	"<p>Detta är ett abstrakt för en icke-existerande avhandling om <sup>18</sup>F<sup>-</sup></p>",
%	"Language": "swe"
%    },
%    "Supervisor1":{
%	"Last name": "Västberg",
%	"First name": "Anders",
%	"Academic title": "universitetslektor",
%	"Local User Id": "u1ft3a12",
%	"Research group": "RS",
%	"ORCiD": "0000-0002-4226-9652",
%	"E-mail": "vastberg@kth.se",
%	"organisation": {"L1": "School of Information and Communication Technology (ICT)",
%			 "L2": "Communication Systems, CoS",
%			 "L3": "Radio Systems Laboratory (RS Lab)"}
%    },
%    "Supervisor2":{
%	"Last name": "Normal",
%	"First name": "A. B.",
%	"E-mail": "ABNormal@example.org",
%	"Other organisation": "Famous Anvils"
%    },
%    "Examiner1":{
%	"Last name": "Maguire Jr.",
%	"First name": "Gerald Q.",
%	"Academic title": "professor",
%	"Local User Id": "u1d13i2c",
%	"ORCiD": "0000-0002-6066-746X",
%	"Research group": "CCS",
%	"E-mail": "maguire@kth.se",
%	"organisation": {"L1": "School of Information and Communication Technology (ICT)",
%			 "L2": "Communication Systems, CoS",
%			 "L3": "Radio Systems Laboratory (RS Lab)"}
%    },
%    "Presentation":{
%	"Date": "2019-07-25 4:31",
%	"Language": "eng",
%	"Room": "Seminar room Grimeton at COM",
%	"Address": "Kistagången 16, East, Floor 4, Elevator B",
%	"City": "Kista"
%    },
%    "Note" :{
%	"Note": "<p><span style='color: red;'>A completely bogus entry for testing with Puppeteer using diva5.js</span></p>"
%    },
%    "File" :{
%	"Filename": "/home/maguire/Diva/z2.pdf",
%	"Accept full text": "true"
%    }
%
%}

\newcommand{\divainfo}[2]{
\thispagestyle{empty}
    \sffamily\tiny
    \begin{flushleft}
    \{\\
        "Author1": \{ \ifx\@authorsLastname\@empty\relax
     \else
     "Last name": "\@authorsLastname",\\
     \fi
     \ifx\@authorsFirstname\@empty\relax
     \else
     "First name": "\@authorsFirstname",\\
     \fi
     \ifx\@kthid\@empty\relax
     \else
     "Local User Id": "\@kthid",\\
     \fi
     \ifx\@email\@empty\relax
     \else
     "E-mail": "\@email",\\
     \fi
     \ifx\@authorsSchool\@empty\relax
     \else
     "organisation": \{"L1": "\@authorsSchool",\\
     \ifx\@authorsDepartment\@empty\relax
     \else
     ,"L2": "\@authorsDepartment"
     \fi
     \}\\
     \fi
    \},\\
    \ifx\@secondAuthorsLastname\@empty\relax
    \else
        "Author2": \{ \ifx\@secondAuthorsLastname\@empty\relax
            \else
        "Last name": "\@secondAuthorsLastname",\\
        \fi
        \ifx\@secondAuthorsFirstname\@empty\relax
            \else
        "First name": "\@secondAuthorsFirstname",\\
        \fi
        \ifx\@secondkthid\@empty\relax
            \else
        "Local User Id": "\@secondkthid",\\
        \fi
        \ifx\@secondemail\@empty\relax
            \else
        "E-mail": "\@secondemail",\\
        \fi
        \ifx\@secondAuthorsSchool\@empty\relax
        \else
        "organisation": \{"L1": "\@secondAuthorsSchool",\\
        \ifx\@secondAuthorsDepartment\@empty\relax
        \else
        "L2": "\@secondAuthorsDepartment"
        \fi
        \}\\
		\fi
    \},\\
    \fi
    \ifx\@courseCycle\@empty\relax
    \else
    "Cycle": "\@courseCycle",\\
    \fi
    \ifx\@courseCode\@empty\relax
    \else
    "Course code": "\@courseCode",\\
    \fi
    \ifx\@courseCredits\@empty\relax
    \else
    "Credits": "\@courseCredits",\\
     \fi

       "Degree1": \{"Educational program": "\@prgmcode"\\ % 
       \ifx\@programcode\@empty\relax
       \else
       ,"programcode": "\@programcode"\\
       \fi

        \ifx\@degreeName\@empty\relax
       \else
       ,"Degree": "\@degreeName"\\
       \fi
        \ifx\@subjectArea\@empty\relax
       \else
       ,"subjectArea": "\@subjectArea"\\
       \fi
       \},\\
       \ifx\@secondProgramcode\@empty\relax            %% If there is a second program code then add this element
       \else
        "Degree2": \{"Educational program": "\@secondprgmcode"\\
        \ifx\@secondProgramcode\@empty\relax
         \else
         ,"programcode": "\@secondProgramcode"\\
         \fi
         \ifx\@secondDegreeName\@empty\relax
        \else
        ,"Degree": "\@secondDegreeName"\\
        \fi
            \ifx\@secondSubjectArea\@empty\relax
        \else
         ,"SubjectArea": "\@secondSubjectArea"\\
         \fi
         \},\\
       \fi
       "Title": \{\\
       "Main title": "\@title",\\
       \ifx\@subtitle\@empty\relax
       \else
       "Subtitle": "\@subtitle",\\
       \fi
       \ifinswedish
       "Language": "swe"
       \else
       "Language": "eng"
       \fi
       \},\\
    "Alternative title": \{\\
    "Main title": "\@alttitle",\\
    \ifx\@altsubtitle\@empty\relax
    \else
    "Subtitle": "\@altsubtitle",\\
    \fi
    \ifinswedish
    "Language": "eng"\\
    \else
    "Language": "swe"\\
    \fi
    \},\\
     \ifx\@supervisorAsLastname\@empty\relax
        \else
    "Supervisor1": \{ "Last name": "\@supervisorAsLastname",\\
    \ifx\@supervisorAsFirstname\@empty\relax
    \else
    "First name": "\@supervisorAsFirstname",\\
    \fi
    \ifx\@supervisorAsKTHID\@empty\relax
    \else
    "Local User Id": "\@supervisorAsKTHID",\\
    \fi
    \ifx\@supervisorAsEmail\@empty\relax
    \else
    "E-mail": "\@supervisorAsEmail",\\
    \fi
    \ifx\@supervisorAsOrganization\@empty
    \ifx\@supervisorAsSchool\@empty\relax
    \else
    "organisation": \{"L1": "\@supervisorAsSchool",\\
    \ifx\@supervisorAsDepartment\@empty\relax
    \else
    "L2": "\@supervisorAsDepartment"
    \fi
    \}\\
    \fi
    \else
    "Other organisation": "\@supervisorAsOrganization"\\
    \fi
    \},\\
    \fi
    \ifx\@supervisorBsLastname\@empty\relax
    \else
    "Supervisor2": \{ "Last name": "\@supervisorBsLastname",\\
    \ifx\@supervisorBsFirstname\@empty\relax
    \else
    "First name": "\@supervisorBsFirstname",\\
    \fi
    \ifx\@supervisorBsKTHID\@empty\relax
    \else
    "Local User Id": "\@supervisorBsKTHID",\\
    \fi
    \ifx\@supervisorBsEmail\@empty\relax
    \else
    "E-mail": "\@supervisorBsEmail",\\
    \fi
    \ifx\@supervisorBsOrganization\@empty
    \ifx\@supervisorBsSchool\@empty\relax
    \else
    "organisation": \{"L1": "\@supervisorBsSchool",\\
    \ifx\@supervisorBsDepartment\@empty\relax
    \else
    "L2": "\@supervisorBsDepartment"
    \fi
    \}\\
    \fi
    \else
    "Other organisation": "\@supervisorBsOrganization"\\
    \fi
    \},\\
    \fi
        \ifx\@supervisorCsLastname\@empty\relax
    \else
    "Supervisor3": \{ "Last name": "\@supervisorCsLastname",\\
    \ifx\@supervisorCsFirstname\@empty\relax
    \else
    "First name": "\@supervisorCsFirstname",\\
    \fi
    \ifx\@supervisorCsKTHID\@empty\relax
    \else
    "Local User Id": "\@supervisorCsKTHID",\\
    \fi
    \ifx\@supervisorCsEmail\@empty\relax
    \else
    "E-mail": "\@supervisorCsEmail",\\
    \fi
    \ifx\@supervisorCsOrganization\@empty
    \ifx\@supervisorCsSchool\@empty\relax
    \else
    "organisation": \{"L1": "\@supervisorCsSchool",\\
    \ifx\@supervisorCsDepartment\@empty\relax
    \else
    "L2": "\@supervisorCsDepartment"
    \fi
    \}\\
    \fi
    \else
    "Other organisation": "\@supervisorCsOrganization"\\
    \fi
    \},\\
    \fi
    \ifx\@examinersLastname\@empty\relax
        \else
    "Examiner1": \{ "Last name": "\@examinersLastname",\\
    \ifx\@examinersFirstname\@empty\relax
    \else
    "First name": "\@examinersFirstname",\\
    \fi
    \ifx\@examinersKTHID\@empty\relax
    \else
    "Local User Id": "\@examinersKTHID",\\
    \fi
    \ifx\@examinersEmail\@empty\relax
    \else
    "E-mail": "\@examinersEmail",\\
    \fi
    \ifx\@examinersOrganization\@empty
    \ifx\@examinersSchool\@empty\relax
    \else
    "organisation": \{"L1": "\@examinersSchool",\\
    \ifx\@examinersDepartment\@empty\relax
    \else
    "L2": "\@examinersDepartment"
    \fi
    \}\\
    \fi
    \else
    "Other organisation": "\@examinersOrganization"\}\\
    \fi
    \},\\
    \fi
    \ifx\@hostcompany\@empty\relax
    \else
    "Cooperation": \{ "Partner\_name": "\@hostcompany"\},\\
    \fi
    \ifx\@nationalsubjectcategories\@empty\relax
    \else
    \textquotedbl\relax National Subject Categories\textquotedbl\relax: \textquotedbl\relax\@nationalsubjectcategories\textquotedbl\relax,\\
    \fi
    % \ifx\@hostorganization\@empty\relax\else Host organization: \@hostorganization\\\fi
    "Other information": \{"Year": "\the\year", "Number of pages": \char`\"\pageref{#1},\pageref{#2}\char`\"
    \},\\
    \ifx\@copyrightleft\@empty
    "Copyrightleft": "None",\\
    \else
    "Copyrightleft": "\@copyrightleft",\\
    \fi
    "Series": \{
    \ifx\@thesisSeries\@empty\relax
        \else
        	"Title of series": "\@thesisSeries"
        	\ifx\@thesisSeriesNumber\@empty\relax
            \else
            , "No. in series": "\@thesisSeriesNumber"
             \fi
    \fi
    \},\\
        \ifx\@opponentsNamea\@empty\relax
        \else
    "Opponents": \{ "Name": "\@opponentsNames"\},\\
       \fi
        \ifx\@presentationDateAndTimeISO\@empty\relax
        \else
       "Presentation": \{ "Date": "\@presentationDateAndTimeISO"\par
        \ifx\@presentationLanguage\@empty\relax
        \else
        ,"Language":"\@presentationLanguage"\par
        \fi
        \ifx\@presentationRoom\@empty\relax
        \else
        ,"Room": "\@presentationRoom"\par
        \fi
        \ifx\@presentationAddress\@empty\relax
        \else
        ,"Address": "\@presentationAddress"\par
        \fi
        \ifx\@presentationCity\@empty\relax
        \else
        ,"City": "\@presentationCity"
        \fi
        \},\par
    \fi
    "Number of lang instances": \textquotedbl\relax\countsc{lang}\textquotedbl\relax,\\
    \foreach \i in {1,...,\countsc{lang}} {
      "Abstract[\getstored[\i]{lang}]": €€€€\\
      \ifxeorlua
       % if using XeLaTeX or LuaLaTeX get the unprocessed saved abstracts (i.e., in latex form)
      \typestoredx{\i}{abstracts}
      \else
      % if using pdflatex get the processed saved abstracts - otherwise it will have problems with utf-8 characters
      \getstored[\i]{abstracts}
      \fi
      €€€€,\\
      "Keywords[\getstored[\i]{lang}]": €€€€\\
      \getstored[\i]{keywords}
      €€€€,\\
    }
   \}
   \end{flushleft}
\clearpage

\makeatletter
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% for writing to a JSON file
\newwrite\jsonfile
\immediate\openout\jsonfile=fordiva.json
\immediate\write\jsonfile{\@charlb}
\immediate\write\jsonfile{"Author1": \@charlb \ifx\@authorsLastname\@empty%\relax
     \else
     "Last name": "\@authorsLastname",
     \fi
     \ifx\@authorsFirstname\@empty%\relax
     \else
     "First name": "\@authorsFirstname",
     \fi
     \ifx\@kthid\@empty%\relax
     \else
     "Local User Id": "\@kthid",
     \fi
     \ifx\@email\@empty%\relax
     \else
     "E-mail": "\@email",
     \fi
     \ifx\@authorsSchool\@empty%\relax
     \else
     "organisation": \@charlb"L1": "\@authorsSchool"
     \ifx\@authorsDepartment\@empty%\relax
     \else
     ,"L2": "\@authorsDepartment"
     \fi
     \@charrb
     \fi
\@charrb,}
\ifx\@secondAuthorsLastname\@empty\relax
\else
\immediate\write\jsonfile{
        "Author2": \@charlb \ifx\@secondAuthorsLastname\@empty%\relax
            \else
        "Last name": "\@secondAuthorsLastname",
        \fi
        \ifx\@secondAuthorsFirstname\@empty%\relax
            \else
        "First name": "\@secondAuthorsFirstname",
        \fi
        \ifx\@secondkthid\@empty%\relax
            \else
        "Local User Id": "\@secondkthid",
        \fi
        \ifx\@secondemail\@empty%\relax
            \else
        "E-mail": "\@secondemail",
        \fi
        \ifx\@secondAuthorsSchool\@empty%\relax
        \else
        "organisation": \@charlb"L1": "\@secondAuthorsSchool"
        \ifx\@secondAuthorsDepartment\@empty%\relax
        \else
        ,"L2": "\@secondAuthorsDepartment"
        \fi
        \@charrb
		\fi
\@charrb,}
\fi % end of conditional for secondAuthorsLastname
\immediate\write\jsonfile{\ifx\@courseCycle\@empty%\relax
\else
"Cycle": "\@courseCycle",
\fi
\ifx\@courseCode\@empty%\relax
\else
"Course code": "\@courseCode",
\fi
\ifx\@courseCredits\@emptyv
\else
"Credits": "\@courseCredits",
\fi
}
\immediate\write\jsonfile{"Degree1": \@charlb"Educational program": "\@prgmcode"% 
       \ifx\@programcode\@empty%\relax
       \else
       ,"programcode": "\@programcode"
       \fi
        \ifx\@degreeName\@empty%\relax
       \else
       ,"Degree": "\@degreeName"
       \fi
        \ifx\@subjectArea\@empty%\relax
       \else
       ,"subjectArea": "\@subjectArea"
       \fi
       \@charrb,
       }
       \ifx\@secondProgramcode\@empty%\relax           %% If there is a second program code then add this element
       \else
        \immediate\write\jsonfile{
        "Degree2": \@charlb"Educational program": "\@secondprgmcode" %
        \ifx\@secondProgramcode\@empty%\relax
         \else
         ,"programcode": "\@secondProgramcode"
         \fi
         \ifx\@secondDegreeName\@empty%\relax
        \else
        ,"Degree": "\@secondDegreeName"
        \fi
            \ifx\@secondSubjectArea\@empty%\relax
        \else
         ,"SubjectArea": "\@secondSubjectArea"
         \fi
         \@charrb,\\
       }
     \fi
\immediate\write\jsonfile{"Title": \@charlb
       "Main title": "\@title",
       \ifx\@subtitle\@empty%\relax
       \else
       "Subtitle": "\@subtitle",
       \fi
       \ifinswedish
       "Language": "swe"
       \else
       "Language": "eng"
       \fi
       \@charrb,
    "Alternative title": \@charlb
    "Main title": "\@alttitle",
    \ifx\@altsubtitle\@empty%\relax
    \else
    "Subtitle": "\@altsubtitle",
    \fi
    \ifinswedish
    "Language": "eng"
    \else
    "Language": "swe"
    \fi
    \@charrb,
}
\ifx\@supervisorAsLastname\@emptyv
        \else
\immediate\write\jsonfile{"Supervisor1": \@charlb "Last name": "\@supervisorAsLastname",
    \ifx\@supervisorAsFirstname\@emptyv
    \else
    "First name": "\@supervisorAsFirstname",
    \fi
    \ifx\@supervisorAsKTHID\@empty%\relax
    \else
    "Local User Id": "\@supervisorAsKTHID",
    \fi
    \ifx\@supervisorAsEmail\@empty%\relax
    \else
    "E-mail": "\@supervisorAsEmail",
    \fi
    \ifx\@supervisorAsOrganization\@empty
    \ifx\@supervisorAsSchool\@empty%\relax
    \else
    "organisation": \@charlb"L1": "\@supervisorAsSchool"
    \ifx\@supervisorAsDepartment\@empty%\relax
    \else
    ,"L2": "\@supervisorAsDepartment"
    \fi
    \@charrb
    \fi
    \else
    "Other organisation": "\@supervisorAsOrganization"
    \fi
    \@charrb,
}
\fi
\ifx\@supervisorBsLastname\@empty%\relax
\else
\immediate\write\jsonfile{"Supervisor2": \@charlb "Last name": "\@supervisorBsLastname",
    \ifx\@supervisorBsFirstname\@empty%\relax
    \else
    "First name": "\@supervisorBsFirstname",
    \fi
    \ifx\@supervisorBsKTHID\@empty%\relax
    \else
    "Local User Id": "\@supervisorBsKTHID",
    \fi
    \ifx\@supervisorBsEmail\@empty%\relax
    \else
    "E-mail": "\@supervisorBsEmail",
    \fi
    \ifx\@supervisorBsOrganization\@empty
    \ifx\@supervisorBsSchool\@empty%\relax
    \else
    "organisation": \@charlb"L1": "\@supervisorBsSchool"
    \ifx\@supervisorBsDepartment\@empty%\relax
    \else
    ,"L2": "\@supervisorBsDepartment"
    \fi
    \@charrb
    \fi
    \else
    "Other organisation": "\@supervisorBsOrganization"
    \fi
    \@charrb,
}
\fi
\ifx\@supervisorCsLastname\@empty%\relax
\else
\immediate\write\jsonfile{"Supervisor3": \@charlb "Last name": "\@supervisorCsLastname",
    \ifx\@supervisorCsFirstname\@empty%\relax
    \else
    "First name": "\@supervisorCsFirstname",
    \fi
    \ifx\@supervisorCsKTHID\@empty%\relax
    \else
    "Local User Id": "\@supervisorCsKTHID",
    \fi
    \ifx\@supervisorCsEmail\@empty%\relax
    \else
    "E-mail": "\@supervisorCsEmail",
    \fi
    \ifx\@supervisorCsOrganization\@empty
    \ifx\@supervisorCsSchool\@empty%\relax
    \else
    "organisation": \@charlb"L1": "\@supervisorCsSchool"
    \ifx\@supervisorCsDepartment\@empty%\relax
    \else
    ,"L2": "\@supervisorCsDepartment"
    \fi
    \@charrb
    \fi
    \else
    "Other organisation": "\@supervisorCsOrganization"
    \fi
    \@charrb,
}
\fi
\ifx\@examinersLastname\@empty%\relax
\else
\immediate\write\jsonfile{"Examiner1": \@charlb "Last name": "\@examinersLastname",
    \ifx\@examinersFirstname\@empty%\relax
    \else
    "First name": "\@examinersFirstname",
    \fi
    \ifx\@examinersKTHID\@empty%\relax
    \else
    "Local User Id": "\@examinersKTHID",
    \fi
    \ifx\@examinersEmail\@empty%\relax
    \else
    "E-mail": "\@examinersEmail",
    \fi
    \ifx\@examinersOrganization\@empty
    \ifx\@examinersSchool\@empty%\relax
    \else
    "organisation": \@charlb"L1": "\@examinersSchool"
    \ifx\@examinersDepartment\@empty%\relax
    \else
    ,"L2": "\@examinersDepartment"
    \fi
    \@charrb
    \fi
    \else
    "Other organisation": "\@examinersOrganization"\@charrb
    \fi
    \@charrb,
}
\fi
\immediate\write\jsonfile{\ifx\@hostcompany\@empty%\relax
\else
"Cooperation": \@charlb "Partner_name": "\@hostcompany"\@charrb,
\fi
}
\ifx\@nationalsubjectcategories\@empty%\relax
\else
\immediate\write\jsonfile{"National Subject Categories": "\@nationalsubjectcategories",
}
\fi
% \ifx\@hostorganization\@empty\relax\else Host organization: \@hostorganization\\\fi
% "\pageref{pg:lastPageofPreface},\pageref{pg:lastPageofMainmatter}" \@charrb,
\immediate\write\jsonfile{"Other information": \@charlb"Year": "\the\year", "Number of pages": 
    "\getpagerefnumber{pg:lastPageofPreface},\getpagerefnumber{pg:lastPageofMainmatter}" \@charrb,
}
\ifx\@copyrightleft\@empty
\immediate\write\jsonfile{"Copyrightleft": "None",
}
\else
\immediate\write\jsonfile{"Copyrightleft": "\@copyrightleft",
}
\fi
\immediate\write\jsonfile{"Series": \@charlb
    \ifx\@thesisSeries\@empty\relax,
        \else
        	"Title of series": "\@thesisSeries"
        	\ifx\@thesisSeriesNumber\@empty\relax
            \else
            , "No. in series": "\@thesisSeriesNumber"
             \fi
    \fi
    \@charrb,
}
\ifx\@opponentsNamea\@empty\relax
\else
\immediate\write\jsonfile{"Opponents": \@charlb "Name": "\@opponentsNames"\@charrb,
}
\fi
\ifx\@presentationDateAndTimeISO\@empty%\relax,
\else
\immediate\write\jsonfile{"Presentation": \@charlb "Date": "\@presentationDateAndTimeISO"
        \ifx\@presentationLanguage\@empty%\relax,
        \else
        ,"Language": "\@presentationLanguage"
        \fi
        \ifx\@presentationRoom\@empty%
        \else
        ,"Room": "\@presentationRoom"
        \fi
        \ifx\@presentationAddress\@empty%\relax,
        \else
        ,"Address": "\@presentationAddress"
        \fi
        \ifx\@presentationCity\@empty%\relax,
        \else
        ,"City": "\@presentationCity"
        \fi
        \@charrb,
}
\fi
\immediate\write\jsonfile{"Number of lang instances": "\countsc{lang}",}
% pdflatex cannot handle the abstracts or the keywords in the code below,
% it generates a "! TeX capacity exceeded, sorry [input stack size=5000]." 
% error message.
\ifxeorlua
\immediate\write\jsonfile{"abstracts": \@charlb}
 \foreach \i in {1,...,\countsc{lang}} {
 %\getstored[\i]{lang}
  \newcommand{\templangs}{\qgetstored{\i}{lang}}
  \tokenize{\lang}{\templangs}
  \immediate\write\jsonfile{"\lang": €€€€}
  \immediate\write\jsonfile{"\qgetstored{\i}{abstracts}"}
  \immediate\write\jsonfile{€€€€,}
}
\immediate\write\jsonfile{\@charrb,} % end the abstracts dict

\immediate\write\jsonfile{"keywords": \@charlb}
\foreach \i in {1,...,\countsc{lang}} {
    \newcommand{\templangs}{\qgetstored{\i}{lang}}
    \tokenize{\lang}{\templangs}
    \newcommand{\fee}{\qgetstored{\i}{keywords}}
    % Because \qgetstored{\i}{keywords} returned a string,
    % we need to convert this string into tokens so it can be evaluated
    % we do this using the function \tokenisze from the xstring package
    \tokenize{\fumble}{\fee}
    \immediate\write\jsonfile{"\lang": €€€€}
    %\immediate\write\jsonfile{"\fee"}  %% This would write out the contents of the stored keywords
    \immediate\write\jsonfile{"\fumble"} %% This expands the macros in the keywords and write the results
    \immediate\write\jsonfile{€€€€,}
}
    \immediate\write\jsonfile{\@charrb} % end the keywords dict
\fi % end of the ifxeorlua

    \immediate\write\jsonfile{\@charrb} % end the JSON dict

    \closeout\jsonfile
}

\makeatother
% Due to parsing problems with Overleaf's checking for balance of
% start and ends of beginning and ending use of "otherlanguage" and
% because babel and polyglossia & biblatex use different names for Norsk and German
% the following new commands have been added

\ifxeorlua
    \newcommand{\babelpolyLangStop}[1]{\end{#1}}
\else
    \newcommand{\babelpolyLangStop}[1]{\end{otherlanguage}}
\fi

\ifxeorlua
   \newcommand{\babelpolyLangStart}[1]{\begin{#1}}
\else
    \newcommand{\babelpolyLangStart}[1]{\begin{otherlanguage}{#1}}
\fi

\ExplSyntaxOn
% Note that this function returns the _string_ stored in the scontents buffer
\cs_new:Npn \qgetstored #1 #2
{
\__scontents_getfrom_seq:nn {#1} {#2}
}
\ExplSyntaxOff

\endinput
