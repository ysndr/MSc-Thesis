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
3. Language Servers for small languages in terms of complexity and userbase, highlighting one of the many use cases for the LSP.
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
Due to the complexity of the language, LSP requests are processed lazily, with support for caching to ensure performance.
While many parts of the language have been reimplemented with a language-server-context in mind, the analyzer did not however implement detailed linting or the rust-specific borrow checker.
For these kinds of analysis, rust-analyzer falls back to calls to the rust build system.


#### Rapid implementation of LSP features

The LSP makes it possible to bring language support to many editors at once.
Emerging languages are profiting from this in particular since development resources are typically scarce and the core is quite volatile.
To mitigate this, core language components can often be reused or integrated through command line calls.

A good example is given by the Frege language [@frege-github].
Frege as introduced in [@frege-paper] is a JVM based functional language with a Haskell-like syntax.
It features lazy evaluation, user-definable operators, type classes and integration with Java.  
While previously providing an eclipse plugin [@frege-eclipse], the tooling efforts have since been put towards an LSP implementation.
The initial development of this language server has been reported on in [@frege-lsp-report].
The author shows though multiple increments how they utilized the JVM to implement a language server in Java for the (JVM based) Frege language.
In the final proof-of-concept, the authors build a minimal language server through the use of Frege's existing REPL and interpreter modules.
Being written in Java, allows the server to make use of other community efforts such as the LSP4J project which provide abstractions over the interaction with LSP clients.
Through the use for such abstractions, servers can focus on the implementation of capabilities only.


#### Language Independence

The LSP is truly language independent.
Many language implementations do not expose the required language interfaces (parsing, AST, Types, etc..), or pose various other impediments such as a closed source, licensing, or the absence of LSP abstractions available for the host language.

An instance of this type is the rnix-lsp[@rnix-git] language server for the nix[@nixos.org] programming language.
Despite the nix language being written in C++ [@nix-repo], its language server builds on a custom parser[@rnix] in Rust.

The work presented by Leimeister in [@cpachecker-lsp] exemplifies how functionality can be provided by entirely external tools as well.
The server can be used to automatically perform software verification in the background using CPAchecker[@cpachecker].
CPAchecker is a platform for automatic, extensible, software verification.
The program is written in Java and provides a command line interface to be run locally.
Additionally, it is possible to execute resource intensive verification through an HTTP-API on more powerful machines or clusters [@cpa-google-cloud,@cpa-clusters].
The LSP-Server supports both modes of operation.
On one hand it interfaces directly with the Java modules provided by the CPAchecker library, on the other it is able to utilize an HTTP-API provided by a server instance of the verifier.

Similar to the work by Leimeister, in [@comprehension-features] Mészáros et al. present a proof of concept leveraging the LSP to integrate (stand-alone) code comprehension tools with the LSP compliant VSCode editor.
Code comprehension tools support the work with complex code bases by "providing various textual information, visualization views and source code metrics on multiple abstraction levels".
Pushing the boundaries of LSP use-cases, code comprehension tools do not only analyze specific source code, but also take into account contextual information.
One of such tools is CodeCompass [@code-compass].



### Honorable mentions

<!-- frege? -->


## Alternative approaches

### Platform plugins

### Legacy protocols

### LSP Extensions

### LSIF
