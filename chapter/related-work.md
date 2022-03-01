# Related work

The Nickel Language Server follows a history of previous research and development in the domain of modern language tooling and editor integration.
Most importantly, it is part of a growing set of LSP integrations.
As such, it is important to get a picture of the field of current LSP projects.
This chapter will survey a varied range of popular language servers, compare common capabilities, and implementation approaches.
Additionally, this part aims to recognize alternative approaches to the LSP, in the form of legacy protocols, extensible development platforms LSP extensions and the emerging Language Server Index Format.

## Language Servers

The LSP project was announced [@lsp-announced] in 2016 to establish a common protocol over which language tooling could communicate with editors.
The LSP helps the language intelligence tooling to fully concentrate on source analysis instead of integration with specific editors by building custom GUI elements and being restricted to editors extension interface.

At the time of writing the LSP is available in version `3.16` [@Spec].
Microsoft's official website lists 172 implementations of the LSP[@implementations] for an equally impressive number of languages.

An in-depth survey of these is outside the scope of this work.
Yet, a few implementations stand out due to their sophisticate architecture, features, popularity or closeness to the presented work.

### Considerable dimensions

To be able to compare and describe LSP projects objectively and comprehensively, the focus will be on the following dimensions.

Target Language
  ~ The complexity of implementing language servers is influenced severely by the targeted language.
    Feature rich languages naturally require more sophisticated solutions.
    Yet, existing tooling can often be leveraged to facilitate language servers.

Features
  ~ The LSP defines an extensive array of capabilities.
    The implementation of these protocol features is optional and servers and clients are able to communicate a set of *mutually supported* capabilities.
  ~ The Langserver [@langserver.org] project identified six basic capabilities that are most widely supported:

    1. Code completion,
    2. Hover information,
    3. Jump to definition,
    4. Find references,
    5. Workspace symbols,
    6. Diagnostics

  ~ Yet, not all of these are applicable in every case and some LSP implementations reach for a much more complete coverage of the protocol.

File Processing
  ~ Most language servers handling source code analysis in different ways.
    The complexity of the language can be a main influence for the choice of the approach.
    Distinctions appear in the way servers process *file indexes and changes* and how they respond to *requests*.
  ~ The LSP supports sending updates in form of diffs of atomic changes and complete transmission of changed files.
    The former requires incremental parsing and analysis, which are challenging to implement but make processing files much faster upon changes.
    An incremental approach makes use of an internal representation of the source code that allows efficient updates upon small changes to the source file.

    Additionally, to facilitate the parsing, an incremental approach must be able to provide a parser with the right context to correctly parse a changed fragment of code.
   In practice, most language servers process file changes by re-indexing the entire file, discarding the previous internal state entirely.
    This is a more approachable method, as it poses less requirements to the architects of the language server.
    Yet, it is far less performant.
    Unlike incremental processing (which updates only the affected portion of its internal structure), the smallest changes, including adding or removing lines effect the _reprocessing of the entire file_.
    While sufficient for small languages and codebases, non-incremental processing quickly becomes a performance bottleneck.
  ~ For code analysis LSP implementers have to decide between *lazy* or *greedy* approaches for processing files and answering requests.
    Dominantly greedy implementations resolve most available information during the indexing of the file.
    The server can then utilize this model to answer requests using mere lookups.
    This stands in contrast to lazy approaches where only minimal local information is resolved during the indexing.
    Requests invoke an ad-hoc resolution the results of which may be memoized for future requests.
    Lazy resolution is more prevalent in conjunction with incremental indexing, since it further reduces the work associated with file changes.
    This is essential in complex languages that would otherwise perform a great amount of redundant work.



#### LSP compliance

#### Features

#### File processing

##### Incremental

##### Full

### Comparative Projects

<!-- Rust Analyser -->
<!-- Merlin -->
<!-- rnix-lsp -->
<!-- pylance? -->
<!-- Scala & Java LSP (feature LSP extensions) -->
<!-- haskell LSP? (talk to tim) -->

### Honorable mentions


## Alternative approaches

### LSP Extensions

The LSP defines a large range of commands and capabilities which is continuously being extended by the maintainers of the protocol.
Yet, occasionally server developers find themselves in need of functionality not yet present in the protocol.
For example the LSP does not provide commands to exchange binary data such as files.
In [@sec:language-independence] the CodeCompass Language Server was introduced.
A stern feature of this server is the ability to generate and show diagrams in SVG format.
However, the LSP does not define the concept of *requesting diagrams*.
In particular Mészáros et al. describe different shortcomings of the LSP :

1. The "LSP doesn’t have a feature to place a context menu at an arbitrary spot in the document"
   Context menu entries are implemented by clients based on the agreed upon capabilities of the server.
   Undefined capabilities cannot be added to the context menu.

   In the case of CodeCompass the developers made up for this by using the code completion feature as an alternative dynamic context menu.

2. "LSP does not support displaying pictures (diagrams)".
   CodeCompass generates diagrams for selected code.
   Yet, there is no image transfer included with the LSP.
   Since the LSP is based on JSON-RPC messages, the authors' solution was to define a new command, specifically designed to tackle this non-standard use case.


Missing features of the protocol such as the ones pointed out by Mészáros et al. appear frequently, especially in complex language servers or ones that implement more than basic code processing.

The rust-analyzer defines almost thirty non-standard commands [@rust-analyzer-extensions], to enable different language specific actions.

Taking the idea of the CodeCompass project further, Rodriguez-Echeverria et al. propose a generic extension of the LSP for graphical modeling [@lsp-for-graphical-modeling].
Their approach is based on a generic intermediate representation of graphs which can be generated by language servers and turned into a graphical representation by the client implementation.

Similarly, in [@Specification-Language-Server-Protocol,@decoupling-core-analysis-support] the authors describe a method to develop language agnostic LSP extensions.
In their work they defined a language server protocol for specification languages (SLSP) which builds on top of the existing LSP, but adds several additional commands.
The commands are grouped by their use case in the domain of specification languages and handles by separate modules of the client extension implementing support for the SLSP.
Following the LSP example and defining commands language agnostic instead of tied to a specific language, allows to maintain the initial purpose of the LSP.
Since the extensions can be incorporated by specific implementations of language servers in the same domain, a single client implementation serves multiple languages.
The authors point out that while their approach specializes in specification languages, the idea can be transferred to other areas.

### LSIF
