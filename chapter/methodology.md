# Method

This chapter contains a detailed guide through the various steps and components of the Nickel Language Server (NLS).
Being written in the same language (Rust[@rust]) as the Nickel interpreter allows NLS to integrate existing components for language analysis.
Complementary, NLS is tightly coupled to Nickel's Syntax definition.
Hence, in [@sec:nickel] this chapter will first detail parts of the AST that are of particular interest for the LSP and require special handling.
Based on that [@sec:linearization] will introduce the main datastructure underlying all higher level LSP interactions and how the AST is transformed into this form.
Finally, in [@sec:lsp-server] the implementation of current LSP features is discussed on the basis of the previously reviewed compontents.

## Nickel AST

### Basic Elements

### Meta Information

### Records

### Static access

## Linearization

### States

### Distinguished Elements

### Transfer from AST

#### Retyping

### Post-Processing

### Resolving Elements

## LSP Server

### Diagnostics and Caching

### Capabilities

#### Hover

#### Completion

#### Jump to Definition

#### Show references
