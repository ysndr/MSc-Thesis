# Conclusion

This chapter summarizes the outcomes of the research underlying this thesis and how they answer the research questions raised in [@sec:research-questions].
Moreover, it will discuss the limitations of the Language Server implementation as discovered in [@sec:evaluation].
Finally, it suggests some short and long term research opportunities in the field of language servers.

## Study Outcome

This thesis project was driven by two central research questions:

> RQ.1
>   ~ a) How to develop a language server for a new language that
>   ~ b) satisfies its users' needs while being performant enough not to slow them down?
>
> RQ.2
>   ~ How can we assess the implementation both quantitatively based on performance measures and qualitatively based on user satisfaction?

[Chapter @sec:design-and-implementation] introduced an approach to implement language server based on the Language Server Protocol.
[Section @sec:high-level-architecture] describes how the NLS consists of three modules: A generic Language Server Interface, an implementation of the interface for the target language Nickel as well as minimal adaptions to Nickel itself.
The architecture aims to provide generalizability to other languages by replacing the implementation of the Language Server Interface.

At the core of the interface stands the Linearization -- a data structure that represents the syntactic structure of a program linearly as opposed to in a tree-like structure.
However, elements can contain references (e.g. variable usages reference elements representing the corresponding declaration), constituting a graph on top of the linear structure.
The data structure is populated using a single tree traversal.
In NLS, this traversal is implemented by Nickel's type checking which was modified to pass typed AST nodes into the linearization.
The linearization allows efficient access to analysis results for arbitrary positions.
NLS implements handlers for several requests of the LSP that exploit this property to provide capabilities like Jump-to-Declaration, Hover and Auto-Completion as detailed in [@sec:lsp-server-implementation].

While [@sec:design-and-implementation] answers RQ.1a), to answer RQ.1b) its ability to efficiently provide satisfying results had to be assessed objectively.
This research relies on both qualitative and quantitative data to address RQ.1b).
[Chapter @sec:evaluation] describes the process of the evaluation which answers RQ.2.
Tweag employees helped to evaluate the NLS taking part in a workshop and sharing their expectations and experiences through separate surveys.
The data showed fairly polarized satisfaction with the tool.


## Limitations

While the NLS project yielded a working and under good conditions performant implementation of the LSP, limitations standing in the way of its adaption remain.
During the evaluation, users criticized that some features were only usable in a limited scope.
References to imported files were not followed and autocompletion only worked for top level variable names.
Moreover, performance issues were reported.
A quantitative analysis of the latencies shown by the NLS supported the performance concerns brought up in the surveys.
Processing files can be observed to be slower as file sizes increase.
At the same time what constitutes a "file change" is an implementation detail of the LSP client and may issues as frequent as on every keystroke.
Since requests are processed synchronously, files are needlessly processes multiple times.
The limitations are discussed in detail in [@sec:discussion].

## Future Work

The apart from discussing the shortcoming found during the evaluation, [@sec:discussion] brings up several opportunities around criticized features for future research and implementation.
Improving the highly demanded features such as Auto-Completion and cross file references are easy targets for work in the short term future.

Advancing over simple feature additions, future work should look into
improving performance by reducing server load.
Alternatively implementing incremental processing capabilities to the linearization could be a more involved but more sustainable research.
This way only the changed contents of files would be transmitted and integrated into NLS's data model.
It's open how type checking and other diagnostics can be integrated into this process.

Additionally, some platforms start to use the static Language Server Index Format (LSIF) to provide code aware navigation in static contexts such as websites where running a language server is impractical.
The Linearization already represents a static view on a file that underlies all LSP methods.
Hence, it is conceivable to implement a translation into LSIF to be used by supported platforms.
