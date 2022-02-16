# Related work

The Nickel Language Server follows a history of previous research and development in the domain of modern language tooling and editor integration.
Most importantly, it is part of a growing set of LSP integrations.
As such, it is important to get a picture of the field of current LSP projects.
This chapter will survey a varied range of popular language servers, compare common capabilities, and implementation approaches.
Additionally, this part aims to recognize alternative approaches to the LSP, in the form of legacy protocols, extensible development platforms LSP extensions and the emerging Language Server Index Format.

## Language Servers

The LSP project was announced [@lsp-announced] in 2016 to establish a common protocol over which language tooling could communicate with editors.
This way it is able to fully concentrate on source analysis instead of integration with specific editors by building custom GUI elements and being restricted to editors extension interface.

At the time of writing the LSP is available in version `3.16` [@Spec].
Microsoft's official website lists 172 implementations of the LSP[@implementations] for an equally impressive number of languages.

Assessing any majority of these is outside the scope of this work.
Yet, a few implementations stand out due to their sophisticate architecture, features, popularity or closeness to the presented work.

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
