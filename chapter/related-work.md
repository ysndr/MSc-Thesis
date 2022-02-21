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

### Honorable mentions

<!-- frege? -->


## Alternative approaches

### Platform plugins

### Legacy protocols

### LSP Extensions

### LSIF
