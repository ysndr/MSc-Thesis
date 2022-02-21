# Related work

The Nickel Language Server follows a history of previous research and development in the domain of modern language tooling and editor integration.
Most importantly, it is part of a growing set of LSP integrations.
As such, it is important to get a picture of the field of current LSP projects.
This chapter will survey a varied range of popular language servers, compare common capabilities, and implementation approaches.
Additionally, this part aims to recognize alternative approaches to the LSP, in the form of legacy protocols, extensible development platforms LSP extensions and the emerging Language Server Index Format.

## Language Servers

### Considerable dimensions

#### Language Complexity


### Representative LSP Projects

Since the number of implementations of the LSP is continuously growing, this thesis will present a selected set of notable projects.

1. Three highly advanced and complete implementations that are the de-facto standard tooling for their respective language:
   *rust-analyzer* [@rust-analyzer], *ocaml-lsp*/*merlin* [@ocaml-lsp,@merlin] and the *Haskell Language Server* [@hls]
2. Two projects that provide compelling alternatives for existing specialized solutions:
   *Metals* (for Scala) [@metals], *Java LSP* [@java-lsp]
3. Language Servers for especially small user languages in terms of complexity and userbase, highlighting one of the many use cases for the LSP.
   *rnix-lsp* [@rnix-lsp], *frege-lsp*



#### LSP as standard tooling

Today LSP based solutions serve as the go-to-method to implement language analysis tools.
Especially emerging languages without existing integration with major IDEs make extensive use of the flexibility and reach provided by the LSP.

Most languages profit greatly from the possibility to leverage existing tooling for the language.
For instance the Haskell language server facilitates a plugin system that allows it to integrate with existing tooling projects [@hls-plugin-search].
Plugins provide capabilities for linting [@hls-hlint-plugin], formatting [@hls-floskell-plugin,hls-ormolu-plugin] documentation [@hls-haddock-comments-plugin] and other code actions [@hls-tactics-plugin] across multiple compiler versions.
While this requires HSL to be compiled with the same compiler version in use by the IDE, it also avoids large scale reimplementations of compiler features in an entirely different language.

Similarly, the Ocaml language service builds on top of existing infrastructure by relying on the Merlin project introduced in [@sec:Merlin].
Here, the advantages of employing existing language components have been explored even before the LSP.

The rust-analyzer [@rust-analyzer] takes an intermediate approach.
It does not reuse or modify the existing compiler, but instead implements analysis functionality based on low level components.
This way the developers of rust-analyzer have greater freedom to adapt for more advanced features.
For instance rust-analyzer implements an analysis optimized parser with support for incremental processing.
Due to the complexity of the language, LSP requests are processed mainly lazily, with support for caching to ensure performance.
While many parts of the language have been reimplemented with a language server context in mind, the analyzer did not however implement detailed linting or the rust-specific borrow checker.
For these kinds of analysis, rust-analyzer falls back to calls to the rust build system.
### Honorable mentions

<!-- frege? -->


## Alternative approaches

### Platform plugins

### Legacy protocols

### LSP Extensions

### LSIF
