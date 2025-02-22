# kththesis
This is a LaTeX class for 1st and 2nd cycle theses at KTH. The guidelines are defined here:
https://intra.kth.se/en/administration/kommunikation/mallar/avhandlingarochexamensarbeten

The class does not define a cover page which is handled separately, instead it creates a flyleaf page with title, author, supervisor and examiner. The package contains example on how to use the class.

Earlier styles for reference are:
* Örjan Ekeberg's class, which is the basis for this class: http://www.csc.kth.se/~ekeberg/latex/
* Serafim Dahl's kth-mag.sty: http://www.nada.kth.se/~serafim/xjobb/
* Lars Engebretsen's kthesis: http://system.csc.kth.se/misc/tex/
* expands upon Giampi Salvi kthlatex-0.2rc4

Gerald Q. Maguire Jr. notes:
Now takes school and program codes to ensure a uniform naming of schools and programs.
Use get-school-acronyms-and-program-names-data.py to get the schools codes and program codes
this produces schools_and_programs.ins which is subsequently input to kththesis.cls

A number of examples of abstracts in additional languages besides English and Swedish.

A lot more structure of the template is filled out (not all of which will be necessary in each thesis, but it provides some guidelines and suggestions). There are also extensive notes in English and Swedish about the contents.

Many examples of some of the things that students might what to have in their thesis (to show format of packets, frames, ...).

Run:
pdflatex examplethesis.tex; pdflatex examplethesis.tex; bibtex examplethesis; makeglossaries examplethesis; pdflatex examplethesis.tex

For the latest version of the 1st and 2nd cycle thesis template: https://www.overleaf.com/read/xmrfhcchgnvq

For the latest version of the 3rd cycle template: https://www.overleaf.com/read/mfznqrmdgkvg

Added backref support as request by johnaug

Added improved support for abstracts, keywords, and national subject caterogy information.

Added PDF information - so when the file is generated it includes the meta data to be put into the PDF file.
