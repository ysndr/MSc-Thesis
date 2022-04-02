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
The presented projects exemplify different approaches with respect to reusing and interacting with the existing language implementation of the targeted language.
In particular the following five approaches are discussed:

1. Three complete implementations that tightly integrate with the implementation level tooling of the respective language:
   *rust-analyzer* [@rust-analyzer], *ocaml-lsp*/*merlin* [@ocaml-lsp,@merlin] and the *Haskell Language Server* [@hls]
2. A project that indirectly interacts with the language implementation through an interactive programming shell (REPL).
   *Frege LSP [@frege-lsp]*
3. A Language Server that is completely independent of the target language's runtime.
   Highlighting how basic LSP support can be implemented even for small languages in terms of userbase and complexity.
   *rnix-lsp* [@rnix-lsp]
4. Two projects that facilitate the LSP as an interface to an existing tool via HTTP or command line.
   *CPAchecker*[@cpachecker-lsp] and *CodeCompass*[@comprehension-features]
5. An approach to generate language servers from domain specific language specifications [@multi-editor-support].


#### Integrating with the Compiler/Runtime

Today LSP-based solutions serve as the go-to method to implement language analysis tools.
Emerging languages in particular take advantage from the flexibility and reach of the LSP.
Especially the freedom of choice for the implementing language, is facilitated by multiple languages by integrating modules of the original compiler or runtime into the language server.

##### HLS

For instance the Haskell language server facilitates a plugin system that allows it to integrate with existing tooling projects [@hls-plugin-search].
Plugins provide capabilities for linting [@hls-hlint-plugin], formatting [@hls-floskell-plugin,hls-ormolu-plugin], documentation [@hls-haddock-comments-plugin] and other code actions [@hls-tactics-plugin] across multiple compiler versions.
This architecture allows writing an LSP in a modular fashion in the targeted language at the expense of requiring HSL to use the same compiler version in use by the IDE and its plugins.
This is to ensure API compatibility between plugins and the compiler.

##### Ocaml LSP

Similarly, the Ocaml language service builds on top of existing infrastructure by relying on the Merlin project introduced in [@sec:Merlin].
Here, the advantages of employing existing language components have been explored even before the LSP.

##### Rust-Analyzer

The rust-analyzer [@rust-analyzer] takes an intermediate approach.
It does not reuse or modify the existing compiler, but instead implements analysis functionality based on low level components.
This way the developers of rust-analyzer have greater freedom to adapt for more advanced features.
For instance rust-analyzer implements an analysis optimized parser with support for incremental processing.
Due to the complexity of the language, LSP requests are processed lazily, with support for caching to ensure performance.
While many parts of the language have been reimplemented with a language-server-context in mind, the analyzer did not however implement detailed linting or the rust-specific borrow checker.
For these kinds of analysis, rust-analyzer falls back to calls to the rust build system.

##### Frege LSP

While the previous projects integrated into the compiler pipeline and processed the results separately, other approaches explored the possiblity to shift the entire analysis to existing modules.
A good example for this method is given by the Frege language [@frege-github].

Frege as introduced in [@frege-paper] is a JVM based functional language with a Haskell-like syntax.
It features lazy evaluation, user-definable operators, type classes and integration with Java.  
While previously providing an eclipse plugin [@frege-eclipse], the tooling efforts have since been put towards an LSP implementation.
The initial development of this language server has been reported on in [@frege-lsp-report].
The author shows though multiple increments how they utilized the JVM to implement a language server in Java for the (JVM based) Frege language.
In the final proof-of-concept, the authors build a minimal language server through the use of Frege's existing REPL and interpreter modules.
The file loaded into the REPL environment providing basic syntax and type error reporting.
The Frege LSP then translates LSP requests into expressions, evaluates them in the REPL environment and wraps the result in a formal LSP response.
Being written in Java, allows the server to make use of other community efforts such as the LSP4J project which provide abstractions over the interaction with LSP clients.
Through the use of abstraction like the Frege REPL, servers can focus on the implementation of capabilities only, albeit with the limits set by the interactive environment.

#### Runtime independent LSP implementations

While many projects do so, language servers do not need to reuse any existing infrastructure of a targeted language at all.
Often, language implementations do not expose the required language interfaces (parsing, AST, Types, etc..), or pose various other impediments such as a closed source, licensing, or the absence of LSP abstractions available for the host language.

An instance of this type is the rnix-lsp[@rnix-git] language server for the Nix[@nixos.org] programming language.
Despite the Nix language being written in C++ [@nix-repo], its language server builds on a custom parser called "rnix" [@rnix] in Rust.
However, since rnix does not implement an interpreter for nix expressions the rnix based language server is limited to syntactic analysis and changes. 

#### Language Server as an Interface to CLI tools

While language servers are commonly used to provide code based analytics and actions such as refactoring, it also proved suitable as a general interface for existing external tools.
These programs may provide common LSP features or be used to extend past the LSP.

##### CPAchecker

The work presented by Leimeister in [@cpachecker-lsp] exemplifies how LSP functionality can be provided by external tools.
The server can be used to automatically perform software verification in the background using CPAchecker[@cpachecker].
CPAchecker is a platform for automatic and extensible software verification.
The program is written in Java and provides a command line interface to be run locally.
Additionally, it is possible to execute resource intensive verification through an HTTP-API on more powerful machines or clusters [@cpa-google-cloud,@cpa-clusters].
The LSP server supports both modes of operation.
While it can interface directly with the Java modules provided by the CPAchecker library, it is also  able to utilize an HTTP-API provided by a server instance of the verifier.

##### CodeCompass

Similar to the work by Leimeister (c.f. [@sec:cpachecker]), in [@comprehension-features] Mészáros et al. present a proof of concept leveraging the LSP to integrate (stand-alone) code comprehension tools with the LSP compliant VSCode editor.
Code comprehension tools support the work with complex code bases by "providing various textual information, visualization views and source code metrics on multiple abstraction levels".
Pushing the boundaries of LSP use-cases, code comprehension tools do not only analyze specific source code, but also take into account contextual information.
One of such tools is CodeCompass [@code-compass].
The works of Mészáros yielded a language server that allowed to access the analysis features of CodeCompass in VSCode.
In their paper they specifically describe the generation of source code diagrams.
Commands issued by the client are processed by a CodeCompass plugin which acts as an LSP server and interacts with CodeCompass through internal APIs.


#### Language Servers generation for Domain Specific Languages

Bünder and Kuchen [@multi-editor-support] highlight the importance of the LSP in the area of Domain Specific Languages (DSL).
Compared to general purpose languages, DSLs often targets both technical and non-technical users.
While DSL creation workbenches like Xtext [@eclipse-xtext], Spoofax [@spoofax] or MPS[@jetpbrains-mps] allow for the implementation and provision of Eclipse or IntelliJ based DSLs, tooling for these languages is usually tied to the underlying platform.
Requiring a specific development platform does not satisfy every user of the language.
Developers have their editor of choice, that they don't easily give up on.
Non-technical users could easily be overwhelmed by a complex software like Eclipse.
For those non-technical users, a light editor would be more adapted, or even one that is directly integrated into their business application.
The authors of [@multi-editor-support] present how Xtext can generate an LSP server for a custom DSL, providing multi-editor support.
The authors especially mention the Monaco Editor [@monaco-editor], a reusable HTML component for code editing using web technologies.
It is used in products like VSCode [@vscode], Theia [@theia] and other web accessible code editors.
The Monaco Editor supports the LSP as a client (that is, on the editor side).
Such LSP-capable web editors make integrating DSLs directly into web applications easier than ever before.


### Honorable mentions

<!-- frege? -->


## Alternative approaches

### Platform plugins

### Legacy protocols

### LSP Extensions

### LSIF
