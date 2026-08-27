# texplate

Source files and reproducible build workflow papers written at METU `lfcs`.

## Prerequisites

Install the following tools:

- A TeX distribution with **LuaLaTeX**, `latexmk`, and `biber`
  - macOS: MacTeX or BasicTeX plus the required TeX Live packages
  - Linux: TeX Live
  - Windows: MiKTeX or TeX Live
- GNU Make
- Bash
- Python 3, used by `make section` to calculate the correct relative root path
- Optional: VS Code with the [LaTeX Workshop](https://marketplace.visualstudio.com/items?itemName=James-Yu.latex-workshop) extension

Verify the key TeX tools are available:

```sh
lualatex --version
latexmk --version
biber --version
make --version
python3 --version
```

## Project layout

```text
.
├── main.tex                   # Root document; always compile this file
├── latexmkrc                  # Shared LuaLaTeX and .build configuration
├── Makefile                   # Common build and authoring commands
├── tex/
│   ├── lfcs.sty              # Packages, formatting, and shared configuration
│   ├── metadata.tex           # Title, authors, dates, affiliations
│   ├── macros.tex             # Shared commands
│   └── notation.tex           # Mathematical notation
├── sections/                  # Paper text, split by section
├── tables/                    # LaTeX table fragments
├── figures/                   # Images and diagrams used in the paper
├── bibliography/
│   └── references.bib         # BibLaTeX bibliography database
├── scripts/
│   └── new-tex-section        # Repository-local section-file generator
├── .vscode/
│   └── settings.json          # Shared VS Code / LaTeX Workshop settings
└── .build/                    # Generated files; ignored by Git
```

## Building the paper

Always build the root document, `main.tex`.

```sh
make pdf
```

The compiled PDF is written to:

```text
.build/main.pdf
```

The project uses `latexmk` with **LuaLaTeX**. All auxiliary and generated build files are written to `.build/`.

### Continuous compilation

Use this while writing:

```sh
make watch
```

This runs `latexmk -pvc main.tex`, watches the TeX source files, and rebuilds the PDF after changes.

Stop the watcher with `Ctrl-C`.

### Cleaning build artifacts

Remove regenerable intermediate artifacts while retaining the generated PDF:

```sh
make clean
```

Remove all generated output, including the PDF:

```sh
make distclean
```

## Creating section files

Do not install the section generator globally. It is included in this repository and is invoked through `make`.

Create a standard section file:

```sh
make section SECTION=sections/03-methods
```

This creates `sections/03-methods.tex`:

```tex
% !TEX root = ../main.tex

% TODO: Write this section.
```

The `% !TEX root = ...` directive tells compatible TeX editors, including VS Code with LaTeX Workshop, which root document to compile.

### Nested section files

The command calculates the root path automatically, including for nested paths:

```sh
make section SECTION=sections/appendices/proofs/concentration
```

This creates:

```text
sections/appendices/proofs/concentration.tex
```

with:

```tex
% !TEX root = ../../main.tex

% TODO: Write this section.
```

The command creates missing directories and refuses to overwrite an existing file.

### Independently compilable subfiles

This project normally uses `\input` and builds only `main.tex`.

If the project uses the `subfiles` package and a section should also compile independently, create it with:

```sh
make subfile SECTION=sections/03-methods
```

This creates:

```tex
% !TEX root = ../main.tex
\documentclass[../main.tex]{subfiles}

\begin{document}

% TODO: Write this section.

\end{document}
```

Add `\usepackage{subfiles}` to `main.tex` and include such a file with:

```tex
\subfile{sections/03-methods}
```

For ordinary section files, use:

```tex
\input{sections/03-methods}
```

## Editing conventions

- Write paper prose in `sections/`.
- Keep `main.tex` limited to the document class, global configuration, document order, title, abstract, bibliography, and appendices.
- Put package declarations, formatting, and shared configuration in `tex/paper.sty`.
- Put shared commands in `tex/macros.tex`.
- Put mathematical notation in `tex/notation.tex`.
- Put bibliography entries in `bibliography/references.bib`.
- Put table source in `tables/` and include it with `\input{tables/<name>}`.
- Put figures in `figures/` and reference them using project-relative paths.
- Do not add `\documentclass`, `\usepackage`, `\begin{document}`, or `\end{document}` to standard files under `sections/`.
- Do not commit `.build/` or other generated LaTeX files.

## VS Code

The repository includes shared LaTeX Workshop settings in `.vscode/settings.json`.

To use the recommended editor workflow:

1. Install VS Code.
2. Install the [LaTeX Workshop](https://marketplace.visualstudio.com/items?itemName=James-Yu.latex-workshop) extension.
3. Open the repository folder in VS Code.
4. Open `main.tex`, or any section file containing a `% !TEX root = ...` directive.
5. Run **LaTeX Workshop: Build LaTeX project**.

LaTeX Workshop should compile the root document with LuaLaTeX and place generated files in `.build/`.

## Common commands

```sh
make help
make pdf
make watch
make clean
make distclean

make section SECTION=sections/01-introduction
make section SECTION=sections/03-methods
make section SECTION=sections/appendices/proofs

make subfile SECTION=sections/03-methods
```

## Git workflow

Before opening a pull request or merging another contributor’s work:

```sh
make pdf
git status
```

Only source files, configuration files, figures, tables, and bibliography data should normally appear as changed files. If `.build/` appears in `git status`, ensure it is ignored:

```gitignore
.build/
```

When adding a new section, create the file and then add it to `main.tex` at the intended location:

```tex
\input{sections/03-methods}
```
