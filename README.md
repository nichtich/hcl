# Hypermedia Content Locator

The command line tool `hcl`, included in this repository, helps to retrieve
**document segments** via **content locators** to support hypermedia
transclusion.

## Motivation

In order to implement **Xanalogical Hypertext** as proposed by Ted Nelson since
the 1960s it requires (Voß 2019a,b):

* **documents** retrievable via **document identifiers**
* **content locators** to select segments from documents
* **edit lists** to assemble documents from document segments  

As [described before](https://jakobib.github.io/hypertext2019/#content-locators)
several standards and technologies exist to express content locators, for instance
[URI Fragment Identifiers], [Web Annotation Selectors], and [IIIF Image API].

This repository collects content locator implementations to reference document
segments. The primary motivation is to **avoid copy & paste**.

[URI Fragment Identifiers]: http://www.w3.org/TR/fragid-best-practices/
[Web Annotation Selectors]: https://www.w3.org/TR/annotation-model/#selectors
[IIIF Image API]: https://iiif.io/api/image/

## Requirements and installation

The tool is written in Perl 5.14 without non-core dependencies, so it should
run on any Unix-like operating system. Just copy the file [hcl](hcl) to your
PATH and make it executable.

## References

* Voß (2019a): _[Infrastructure-Agnostic Hypertext](https://jakobib.github.io/hypertext2019/)_ <https://arxiv.org/abs/1907.00259>
* Voß (2019b): _[We were promised Xanadu! An Infrastructure-Agnostic Model of Hypertext](https://doi.org/10.5281/zenodo.3339295)_. <https://doi.org/10.5281/zenodo.3339295>

## License

Hypertext must be available to anyone so feel free to use as you like!
References are welcome nevertheless.

