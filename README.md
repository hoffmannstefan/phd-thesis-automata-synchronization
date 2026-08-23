This file contains my PhD thesis, which can be compiled in two formats:

1. The original format, according to the guidelines of Trier University.
2. Using the Springer Nature Monograph template.

### Build instructions

The main files are

> ./thesis-format/main.tex

and

> ./springer-mono-format/book.tex

Both should work out of the box using "latexmk", or "pdflatex" with "biber" and "makeindex". A makefile is also included for convenience.
This can be used in the following way.

```bash
make all      # Builds both variants using 'latexmk'

make thesis   # Builds the thesis in the format according to Trier University guidelines
make springer # Builds the thesis using the Springer Nature Monograph template
```

If you prefer building without latexmk:

```bash
make thesis-pdflatex   # Alternate build pipeline (pdflatex)
make springer-pdflatex # Alternate build pipeline (pdflatex)
```

Output directories:

> build/thesis/
> build/springer/

3. Cleaning

Remove build artifacts:

```bash
make clean
```

Remove all generated PDFs and build artifacts:

```bash
make distclean
```