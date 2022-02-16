# Introduction

Integrated Development Environments (IDEs) and other more lightweight code editors are by far the most used tool of software developers.
Yet, improvements of language intelligence, i.e. code completion, debugging as well as static code analysis refactoring and enrichment, have traditionally been subject to both the language and the editor used.
Language support is thereby brought to IDEs by the means of platform dependent extensions that require repeated efforts for each platform and hence varied a lot in performance, feature-richness and availability.
<!-- Comparison here? -->
Recent years have seen different works [refs?] towards editor-independent code intelligence implementations and unified language-independent protocols.
The to date most successful approach is the Language Server Protocol (LSP).
The protocol specifies how editors can communicate with language servers which are separate, editor independent implementations of language analyzers.
It allows to express a wide variance of language intelligence.
LSP servers allow editors to jump to definitions, find usages, decorate elements with additional information inline or when hovering elements, list symbols and much more.
The LSP is discussed in more detail in [@sec:language-server-protocol].
These approaches reduce the effort required to bring language intelligence to editors.
Instead of rewriting what is essentially the same language extension for every editor, any editor that implements a LSP client can connect to the same server.
Moreover, LSP client implementations are independent of the servers.
Hence, editor communities can focus on developing the best possible and uniform experience which all LSP servers can leverage.
As a side effect this also allows for developers to stay in their preferred developing environment instead of needing to resort to e.g. Vim or Emacs emulation or loosing access to other plugins.

<!-- graphic here or in the backgroudn chapter -->

Being independent of the editors, the developer of the language server is free to choose the optimal implementing language.
In effect, it is possible for language developers to integrate essential parts of the existing language implementation for a language server.
By now the LSP has become the most popular choice for cross-platform language tooling with implementations [langservers and microsoft] for all major and many smaller languages.

Speaking of smaller languages is significant, as both research communities and industry continuously develop and experiment with new languages for which tooling is unsurprisingly scarce.
Additionally, previous research [ref], that shows the importance of language tools for the selection of a language, highlights the importance of tooling for new languages to be adopted by a wider community.
While previously implementing language tools that integrate with the developer's environment was practically unfeasible for small projects due to the incompatibility between different extension systems, leveraging the LSP reduces the amount of work required considerably.


## Motivation

Since its release, the LSP has grown to be supported by a multitude of languages and editors[@langservers @lsp-website], solving a long-standing problem with traditional IDEs.

Before the inception of language servers, implementing specialized features for every language of interest was the sole responsibility of the developers of code editors.
Under the constraint of limited resources, editors had to position themselves on a spectrum between specializing on integrated support for a certain subset of languages and being generic over the language providing only limited support.
As the former approach offers a greater business value, especially for proprietary products most professional IDEs gravitate towards excellent (and exclusive) support for single major languages, i.e., XCode and Visual Studio for the native languages for Apple and Microsoft Products respectively as well as JetBrains' IntelliJ platform and RedHat's Eclipse.
Problematically, this results in less choice for developers and possible lock-in into products subjectively less favored but unique in their features for a certain language.
The latter approach was taken by most text editors which in turn offered only limited support for any language.

Popularity statistics^[https://web.archive.org/web/20160625140610/https://pypl.github.io/IDE.html] shows that except Vim and Sublime Text, both exceptional general text editors, the top 10 most popular IDEs were indeed specialized products.
Regardless that some IDEs offer support for more languages through (third-party) extensions, developing any sort of language support to $N$ platforms requires the implementation of $N$ integrations.
Missing standards, incompatible implementing languages and often proprietary APIs highlight this problem.

This is especially difficult for emerging languages, with possibly limited development resources to be put towards the development of language tooling.
Consequently, efforts of language communities vary in scope, feature completeness and availability.

The Language Server Protocol aims to solve this issue by specifying an API that editors (clients) can use to communicate with language servers.
Language servers are programs that implement a set of IDE features for one language and expose access to these features through the LSP.
This allows developers to focus resources to a single project that is above all unrelated to editor-native APIs for analytics processing code representation and GUI integration.
Now only a single implementation of a language server is required, instead of an individual plugin for each editor.
Editor maintainers can concentrate on offering the best possible LSP client support independent of the language.

### Problem Definition

The problem this thesis will address is the current lack of documentation and evaluation of the applied methods for existing Language Servers.

While most of the implementations of LSP servers are freely available as Open Source Software [ref?], the methodology is often poorly documented, especially for smaller languages.
There are some experience reports [ref: merlin, and others] and a detailed video series on the Rust Analyzer[ref or footnote] project, but implementations remain very opinionated and poorly guided through.
The result is that new implementations keep repeating to develop existing solutions.

Moreover, most projects do not formally evaluate the Language Server on even basic requirements.
Naïvely, that is, the server should be *performant* enough not to slow down the developer, it should offer *useful* information and capabilities and of course be *correct* as well as *complete*.

## Research Questions

To guide future implementations of language servers for primarily small scale languages the research presented in this thesis aims to answer the following research questions at the example of the Nickel Project^[https://nickel-lang.org]:

RQ.1
  ~ How to develop a language server for a new language with the abovementioned requirements in mind?

RQ.2
  ~ How can we assess the implementation both quantitatively based on performance measures and qualitatively based on user satisfaction?

RQ.3
  ~ Do the methods used to answer RQ.1 meet the expected requirements under the assessment developed in RQ.2?


The goal of this research is to describe a reusable approach for representing programs that can be used to query data to answer requests on the Language Server Protocol efficiently. 
The research is conducted on an implementation of the open source language Nickel[^https://nickel-lang.org] which provides the *Diagnostics*, *Jump to \** and *Hover* features as well as limited *Auto-Completion* and *Symbol resolution*.
Although implemented for and with integration of the Nickel runtime, the objective is to keep the internal format largely language independent.
Similarly, the Rust based implementation should be described abstractly enough to be implemented in other languages.
To support the chosen approach, a user study will show whether the implementation is able to meet the expectations of its users and maintain its performance in real-world scenarios.

## Non-Goals

The reference solution portrayed in this work is specific for the Nickel language.
Greatest care is given to present the concepts as generically and transferable as possible.
However, it is not a goal to explicitly cover a problem space larger than the Nickel language, which is a pure functional language based on lambda calculus with JSON data types, gradual typing, higher-order contracts and a record merging operation.

## Research Methodology

What are the scientific methods


## Structure of the thesis
