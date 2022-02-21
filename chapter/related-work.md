# Related work

The Nickel Language Server follows a history of previous research and development in the domain of modern language tooling and editor integration.
Most importantly, it is part of a growing set of LSP integrations.
As such, it is important to get a picture of the field of current LSP projects.
This chapter will survey a varied range of popular language servers, compare common capabilities, and implementation approaches.
Additionally, this part aims to recognize alternative approaches to the LSP, in the form of legacy protocols, extensible development platforms LSP extensions and the emerging Language Server Index Format.


## Previous Approaches

### IDEs

Before the invention of the Language Server Protocol, extensive language support used to be provided by an IDE.
Yet, the range of officially supported languages remained relatively small [@intellij-supported-languages].
While integration for popular languages was common, IDE grade support for less popular ones was all but guaranteed and relied mainly on community efforts.
In fact Eclipse[@eclipse-a-platform,eclipse-www], IntelliJ[@intelliJ], and Visual Studio[@VisualStudio], to this day the most popular IDE choices, Focus on a narrow subset of languages, historically, Java and .NET.
Additional languages can be integrated by custom (third-party) plugins or derivations of the base platform ([@list-of-eclipse,@jetbrains-all-products]).
Due to the proprietary nature of some of these products, plugins are not compatible between different platforms.
Many less popular languages therefore saw redundant implementations of what is essentially the same.
For Haskell separate efforts produced an eclipse based IDE [@haskell-ide-eclips], as well as independent IntelliJ plugins [@intellij-haskell,@HaskForce].
Importantly, the implementers of the former reported troubles with the language barrier between Haskell and the Eclipse base written in Java.

The Haskell language is an exceptional example since there is also a native Haskell IDE[@haskell-for-mac] albeit that it is available only to the MacOS operating system.
This showcases the difficulties of language tooling and its provision.

In general, developing language integrations, both as the vendor of an IDE or third-party plugin developer requires extensive resources.
[Table @tbl:plugins-size] gives an idea of the efforts-required.
Strikingly, since the IntelliJ platform is based on the JVM, its plugin system requires the use of JVM languages [@custom-language-support]
The Rust and Haskell integrations for instance contain at best only a fraction of code in their respective language.

| Plugin                    | lines of code                                                |
| ------------------------- | ------------------------------------------------------------ |
| intellij-haskell          | 17249 (Java) + 13476 (Scala) **+ 0 (Haskell)**               |
| intellij-rust             | 229131 (Kotlin) + 3958 (Rust)                                |
| intellij-scala            | 39382 (Java) + 478904 (Scala)                                |
| intellij-kotlin           | 182372 (Java) + 563394 (Kotlin)                              |
| intellij-community/python | 47720 (C) + 248177 (Java) + 37101 (Kotlin) + 277125 (Python) |

: Comparison of the size for different IntelliJ platform plugins {#tbl:plugins-size}

Naturally, development efforts at this size would gravitate around the most promising solution, stifling the progress on competing platforms [@intellij-comparison-eclipse].
Additionally, it would lock-in programmers into a specific platform for its language support regardless of their personal preference.

### IDE Abstraction

#### Monto

The authors of the Monto project[@monto,@monto-disintegrated] call this the "IDE Portability Problem".
They compare the situation with the task of compiling different high level languages to a set of CPU architectures.
The answer to that problem was an intermediate representation (IR).
Compilers could transform input languages into this IR and in turn generate assembly for different architectures from a single input format.

With Monto, Kreidel et al propose a similar idea for IDE portability.
The paper describes the *Monto IR* and how they use a *Message Broker* to receive events from the Editor and dispatch them to *Monto Services*.

The Monto IR is a language agnostic and editor independent, JSON serialized tree-like model.
Additionally, the IR maintains low level syntax highlighting information (font, color, style, etc.) but leaves the highlighting to the language specific service.

The processing and modification of the source code and IR is performed by *Monto Services*.
Services implement specific actions, e.g. parsing, outlining or highlighting.
A central broker connects the services with each other and the editor.

Since Monto performs all work on the IR, independent of the editor, and serializes the IR as JSON messages, the language used to implement *Monto Services* can be chosen freely giving even more flexibility.

The Editor extension's responsibility is to act as a source and sink for data.
It sends Monto compliant messages to the broker and receives processing results such as (error) reports.
The communication is based on the ZeroMQ[zeromq] technology which was chosen because it is lightweight and available in manly languages [@monto-disintegrated] allowing to make use of existing language tools

#### Merlin
## Language Servers

### Considerable dimensions

#### Language Complexity

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
