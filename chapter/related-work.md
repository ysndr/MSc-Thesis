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

To be able to compare and describe each project objectively and comprehensively, the focus will be on the following dimensions.

Target Language
  ~ The complexity of implementing language servers is influenced severely by the targeted language.
    Feature rich languages naturally require more sophisticated solutions.
    Conversely, self-hosted and interpreted languages can often leverage existing tooling.

Features
  ~ The LSP defines an extensive array of capabilities.
    The implementation of these protocol features is optional and servers and clients are able to communicate a set of *mutually supported* capabilities.
  ~ The Langserver.org^[https://langserver.org] project identified six basic capabilities that are most widely supported:

    1. Code completion,
    2. Hover information,
    3. Jump to definition,
    4. Find references,
    5. Workspace symbols,
    6. Diagnostics

  ~ Yet, not all of these are applicable in every case and some LSP implementations reach for a much more complete coverage of the protocol.

File Processing
  ~ Most language servers use very different methods of handling the source code they analyze.
    The means are mainly influenced by the complexity of the language.
    Distinctions appear in the way servers process *file indexes and changes* and how they respond to *requests*.
  ~ The LSP supports sending updates in form of diffs of atomic changes and complete transmission of changed files.
    The former requires incremental parsing and analysis, which are challenging to implement but make processing files much faster upon changes.
    An incremental approach makes use of an internal representation of the source code that allows to quickly derive analytic results from and can be updated efficiently.
    Additionally, to facilitate the parsing, it must be able to provide a parser with the right context to correctly parse a changed fragment of code.
   In practice, most language servers process file changes by re-indexing the entire file, discarding the previous internal state entirely.
    This is a more approachable method.
    Yet, it is less performant since entire files need to be processed, which becomes more noticeable as file sizes and edit frequency increase.
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

### Platform plugins

### Legacy protocols

### LSP Extensions

### LSIF
