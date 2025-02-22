
\selectlanguage{english}

\pagenumbering{none} \setcounter{page}{1}


<!-- \kthcover -->
<!-- \clearpage\thispagestyle{empty}\mbox{}  -->
<!-- % empty back of front cover -->

\titlepage

\bookinfopage

\setcounter{page}{1}
\begin{abstract}
  \markboth{\abstractname}{}

\begin{scontents}[store-env=lang]
eng
\end{scontents}

\begin{scontents}[store-env=abstracts,print-env=true]

The expansive Language Integration, i.e. code completion, debugging as well as static code analysis, refactoring and more, has typically been the hallmark of Integrated Development Environments (IDE).
Typical IDEs however focus on a selection of established languages to integrate which stifles the adoption of new languages.
Contrasting IDEs, modular text editors allow for plugin driven integration of languages as contributed by their respective communities.
Yet, providing language integration to multiple platforms requires repeated efforts for each one.
The Language Server Protocol aims to be a solution to this problem by connecting a language specific Language Server to editors which act as generic clients.
This work presents the design of a transferable Language Server architecture and its implementation for the Nickel languages.
The product is finally evaluated quantitatively for its performance and qualitatively for its perception by future users.

\end{scontents}

\subsection*{Keywords}
\begin{scontents}[store-env=keywords,print-env=true]
\InsertKeywords{english}
\end{scontents}
\end{abstract}
\cleardoublepage



\babelpolyLangStart{swedish}
\begin{abstract}
    \markboth{\abstractname}{}
\begin{scontents}[store-env=lang]
swe
\end{scontents}
\begin{scontents}[store-env=abstracts,print-env=true]

\section*{Sammanfattning}

Den expansiva språkintegrationen, dvs. kodkomplettering, felsökning och statisk kodanalys, omstrukturering med mera, har vanligtvis varit kännetecknande för integrerade utvecklingsmiljöer (IDE).
Typiska IDE:er fokuserar dock på ett urval av etablerade språk att integrera, vilket hämmar införandet av nya språk.
Modulära textredigerare, som kontrasterar till IDE, möjliggör plugin-driven integration av språk som bidragits av deras respektive grupper.
Att tillhandahålla språkintegration för flera plattformar kräver dock upprepade insatser för varje plattform.
Language Server Protocol syftar till att lösa detta problem genom att ansluta en språkspecifik Language Server till redaktörer som fungerar som generiska klienter.
I detta arbete presenteras utformningen av en överförbar Language Server-arkitektur och dess genomförande för nickelspråken.
Produkten utvärderas slutligen kvantitativt med avseende på dess prestanda och kvalitativt med avseende på hur den uppfattas av framtida användare.

\end{scontents}
\subsection*{Nyckelord}
\begin{scontents}[store-env=keywords,print-env=true]
\InsertKeywords{swedish}
\end{scontents}
\end{abstract}
\babelpolyLangStop{swedish}

\cleardoublepage

\section*{Acknowledgments}
\markboth{Acknowledgments}{}

I like to thank all the people who supported me throughout the development of this project, from the planning, implementation and final writing.
Special thanks go to my supervisors Yann and Martin.
To Martin for ensuring and teaching the academic rigor and writing style of this document.
To Yann for leading the Nickel project welcoming me to the Nickel team at eye level for the work on this feature and helping me write a complete, coherent academic piece of work through countless reviews.
I also want to acknowledge my close friends and family who stayed supportive and tolerant to my rubber ducking and made my time so much more enjoyable.

\acknowlegmentssignature



\pagenumbering{roman} \setcounter{page}{1}

\setcounter{secnumdepth}{3}
\setcounter{tocdepth}{3}
\tableofcontents
\cleardoublepage

\listoffigures
\cleardoublepage

\listoftables
\cleardoublepage

\listoflistings
\cleardoublepage

\pagenumbering{arabic} \setcounter{page}{1}

<!-- %% The following label is essential to know the page number of the last page of the preface -->
<!-- %% It is used to computer the data for the "For DIVA" pages -->
\label{pg:lastPageofPreface}
<!-- % Mainmatter is where the actual contents of the thesis goes -->
\mainmatter
