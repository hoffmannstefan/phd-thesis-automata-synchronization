# =========================================================
# LaTeX Multi-Build System
# - BibLaTeX + biber
# - Index support (makeindex explicit)
# - latexmk + pdflatex
# - build/ directory isolation
# =========================================================

LATEXMK = latexmk

LATEXMK_FLAGS = -pdf -interaction=nonstopmode -halt-on-error

THESIS_DIR   = thesis-format
SPRINGER_DIR = springer-mono-format

THESIS_MAIN   = main.tex
SPRINGER_MAIN = book.tex

BUILD_DIR = build

all: thesis springer

THESIS_BUILD   = $(BUILD_DIR)/thesis
SPRINGER_BUILD = $(BUILD_DIR)/springer

# =========================================================
# LATEXMK BUILDS (with explicit index step)
# =========================================================

thesis:
	@echo "Building Thesis (latexmk + biber + index)..."
	mkdir -p $(THESIS_BUILD)
	$(LATEXMK) $(LATEXMK_FLAGS) \
		-cd \
		-outdir=../$(THESIS_BUILD) \
		$(THESIS_DIR)/$(THESIS_MAIN)
	if [ -f $(THESIS_BUILD)/main.idx ]; then \
		echo "Running makeindex (Thesis)..."; \
		makeindex $(THESIS_BUILD)/main.idx -o $(THESIS_BUILD)/main.ind; \
	fi
	$(LATEXMK) $(LATEXMK_FLAGS) \
		-cd \
		-outdir=../$(THESIS_BUILD) \
		$(THESIS_DIR)/$(THESIS_MAIN)

springer:
	@echo "Building Springer (latexmk + biber + index)..."
	mkdir -p $(SPRINGER_BUILD)
	$(LATEXMK) $(LATEXMK_FLAGS) \
		-cd \
		-outdir=../$(SPRINGER_BUILD) \
		$(SPRINGER_DIR)/$(SPRINGER_MAIN)
	if [ -f $(SPRINGER_BUILD)/main.idx ]; then \
		echo "Running makeindex (Springer)..."; \
		makeindex $(SPRINGER_BUILD)/main.idx -o $(SPRINGER_BUILD)/main.ind; \
	fi
	$(LATEXMK) $(LATEXMK_FLAGS) \
		-cd \
		-outdir=../$(SPRINGER_BUILD) \
		$(SPRINGER_DIR)/$(SPRINGER_MAIN)

# =========================================================
# PDFLATEX BUILDS (manual pipeline)
# =========================================================

thesis-pdflatex:
	@echo "Building Thesis (pdflatex + biber + index)..."
	mkdir -p $(BUILD_DIR)/thesis-pdflatex

	cd $(THESIS_DIR) && \
	pdflatex -interaction=nonstopmode -halt-on-error \
		-output-directory=../$(BUILD_DIR)/thesis-pdflatex $(THESIS_MAIN)

	if [ -f $(BUILD_DIR)/thesis-pdflatex/main.idx ]; then \
		makeindex $(BUILD_DIR)/thesis-pdflatex/main.idx \
			-o $(BUILD_DIR)/thesis-pdflatex/main.ind; \
	fi

	cd $(THESIS_DIR) && \
	biber --output-directory=../$(BUILD_DIR)/thesis-pdflatex main

	cd $(THESIS_DIR) && \
	pdflatex -interaction=nonstopmode -halt-on-error \
		-output-directory=../$(BUILD_DIR)/thesis-pdflatex $(THESIS_MAIN)

	cd $(THESIS_DIR) && \
	pdflatex -interaction=nonstopmode -halt-on-error \
		-output-directory=../$(BUILD_DIR)/thesis-pdflatex $(THESIS_MAIN)


springer-pdflatex:
	@echo "Building Springer (pdflatex + biber + index)..."
	mkdir -p $(BUILD_DIR)/springer-pdflatex

	cd $(SPRINGER_DIR) && \
	pdflatex -interaction=nonstopmode -halt-on-error \
		-output-directory=../$(BUILD_DIR)/springer-pdflatex $(SPRINGER_MAIN)

	if [ -f $(BUILD_DIR)/springer-pdflatex/main.idx ]; then \
		makeindex $(BUILD_DIR)/springer-pdflatex/main.idx \
			-o $(BUILD_DIR)/springer-pdflatex/main.ind; \
	fi

	cd $(SPRINGER_DIR) && \
	biber --output-directory=../$(BUILD_DIR)/springer-pdflatex main

	cd $(SPRINGER_DIR) && \
	pdflatex -interaction=nonstopmode -halt-on-error \
		-output-directory=../$(BUILD_DIR)/springer-pdflatex $(SPRINGER_MAIN)

	cd $(SPRINGER_DIR) && \
	pdflatex -interaction=nonstopmode -halt-on-error \
		-output-directory=../$(BUILD_DIR)/springer-pdflatex $(SPRINGER_MAIN)

# =========================================================
# CLEAN
# =========================================================

clean:
	@echo "Cleaning build directory..."
	$(LATEXMK) -C -cd $(THESIS_DIR)/$(THESIS_MAIN)
	$(LATEXMK) -C -cd $(SPRINGER_DIR)/$(SPRINGER_MAIN)
	rm -rf $(BUILD_DIR)

distclean: clean
	rm -f $(THESIS_DIR)/*.pdf
	rm -f $(SPRINGER_DIR)/*.pdf

.PHONY: all thesis springer thesis-pdflatex springer-pdflatex clean distclean