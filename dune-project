(lang dune 3.15)
; The above stanza specifies the Dune language version being used.

; Declares the use of the Melange compiler with a specific version.
(using melange 0.1)

; Declares the use of the directory-targets extension, useful for managing
; directory-level build targets.
(using directory-targets 0.1)

; Sets the name of the project.
(name meleange)

; Indicates whether OPAM files should be automatically generated.
(generate_opam_files true)

; Provides the source location of the project, typically a GitHub repository.
(source
 (github davesnx/meleange))

; Lists the authors of the project.
(authors "David Sancho Moreno <dsnxmoreno@gmail.com>")

; Specifies the maintainers of the project, which can be different from authors.
(maintainers "David Sancho Moreno <dsnxmoreno@gmail.com>")

; Declares the license type under which the project is distributed.
(license MIT)

; Provides a link to the project's documentation.
(documentation https://github.com/davesnx/meleange)

; The package stanza defines the configuration for an OPAM package.
(package
 (name meleange)
 (synopsis "Enter a synopsis of your app here")
 (description "Enter a description of your app here")
 (depends
  (dune (>= 3.14))
  (melange (>= 3.0.0-51))
  (ocaml (>= 5.1.1))
  yojson
  eio
  lambdasoup

  (melange-json :with-dev-setup)
  (ocamlformat :with-dev-setup)
  (ocaml-lsp-server :with-dev-setup)
)
 (tags
  (reasonml, ocaml, melange)))
