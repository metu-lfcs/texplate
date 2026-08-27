# texplate


A reproducible starting point for writing an academic paper collaboratively
with Git and LaTeX, at METU `lfcs`.

## Create a paper repository

Create a new repository from this template using your forge’s template feature.

- **GitHub:** select **Use this template**.
- **Codeberg:** create a new repository and select this repository in the **Template** field.

The resulting repository is independent of this template. Rename it, replace
the placeholder metadata, and adapt or remove example files as needed.


## Requirements

Install:

- A TeX distribution with LuaLaTeX, `latexmk`, and Biber
- GNU Make
- Bash
- Python 3 (used by the section-generation command)
- Editor suggestions: `neovim` or VS Code (with, if you like, [LaTeX Workshop](https://marketplace.visualstudio.com/items?itemName=James-Yu.latex-workshop) extension).


Verify the key TeX tools are available:

```sh
lualatex --version
latexmk --version
biber --version
make --version
python3 --version
```

## Collaboration conventions

- Protect `main`: do not push directly to it.
- Create a short-lived branch for each coherent change.
- Push your changes to that branch and open a pull request for review.
- Always delete the branch after merge.
- Do not commit generated files from `latex/.build/` (`.gitignore` already
  handles this, don't interfere).
- Keep commits focused: avoid combining prose revisions, bibliography changes,
  formatting changes, and unrelated refactoring in one commit.
- Best is to have each sentence on its own line, try your best. Or use
  `latexindent` if/when you get experienced with LaTeX.

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
├── bib/
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

If you're on `neovim`, use `vimtex`. I'm sure VS Code means for continuous
development, but you need to discover it yourself.

If the above do not apply, use this while writing:

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

Cleaning is your friend when LaTeX gets jammed.

## Creating section files

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

If your project will  use the `subfiles` package and a section should also compile independently, create it with:

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
- Put shared local commands in `tex/macros.tex`.
- Put custom mathematical notation in `tex/notation.tex`.
- Put bibliography entries in `bib/references.bib`.
- Put table source in `tables/` and include it with `\input{tables/<name>}`.
- Put figures in `figures/` and reference them using project-relative paths.
- Do not add `\documentclass`, `\usepackage`, `\begin{document}`, or `\end{document}` to standard files under `sections/`.

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
