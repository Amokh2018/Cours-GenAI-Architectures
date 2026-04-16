# ──────────────────────────────────────────────────────────────────────────────
#  Makefile — Cours 17 : GenAI Architectures & LLMOps
#  MSc IAG · Certificat 3 · AIvancity
#
#  Usage:
#    make install      → create venv + install all lab dependencies
#    make jupyter      → start Jupyter Lab inside the venv
#    make kernel       → register the venv as a Jupyter kernel
#    make clean        → remove the virtual environment
#    make help         → show this help
# ──────────────────────────────────────────────────────────────────────────────

VENV      := .venv
PYTHON    := python3
PIP       := $(VENV)/bin/pip
JUPYTER   := $(VENV)/bin/jupyter
IPYTHON   := $(VENV)/bin/python
KERNEL    := genai-architectures

LLAMA_MODEL := llama3.2:3b

.DEFAULT_GOAL := help

# ── Colours ───────────────────────────────────────────────────────────────────
BOLD  := \033[1m
CYAN  := \033[36m
GREEN := \033[32m
RESET := \033[0m

# ──────────────────────────────────────────────────────────────────────────────
.PHONY: help
help:
	@echo ""
	@echo "$(BOLD)$(CYAN)Cours 17 — GenAI Architectures & LLMOps$(RESET)"
	@echo "$(BOLD)Available targets:$(RESET)"
	@echo "  $(GREEN)make install$(RESET)   — create .venv and install all Lab dependencies"
	@echo "  $(GREEN)make jupyter$(RESET)   — launch Jupyter Lab (runs inside .venv)"
	@echo "  $(GREEN)make kernel$(RESET)    — register .venv as a Jupyter kernel named '$(KERNEL)'"
	@echo "  $(GREEN)make clean$(RESET)     — delete the virtual environment"
	@echo "  $(GREEN)make freeze$(RESET)    — print currently installed packages (pinned versions)"
	@echo ""
	@echo "$(BOLD)Ollama (Lab 2 — local LLMs):$(RESET)"
	@echo "  $(GREEN)make install-ollama$(RESET)  — install Ollama on Linux (requires sudo)"
	@echo "  $(GREEN)make pull-llama$(RESET)      — pull $(LLAMA_MODEL) model via Ollama"
	@echo ""

# ──────────────────────────────────────────────────────────────────────────────
.PHONY: install
install: $(VENV)/bin/activate
	@echo ""
	@echo "$(GREEN)✅  Virtual environment ready.$(RESET)"
	@echo "    Activate with:  source $(VENV)/bin/activate"
	@echo "    Or run:         make jupyter"
	@echo ""

$(VENV)/bin/activate: requirements.txt
	@echo "$(CYAN)▶  Creating virtual environment in $(VENV)/ ...$(RESET)"
	$(PYTHON) -m venv $(VENV)
	@echo "$(CYAN)▶  Upgrading pip ...$(RESET)"
	$(PIP) install --quiet --upgrade pip setuptools wheel
	@echo "$(CYAN)▶  Installing Lab requirements ...$(RESET)"
	$(PIP) install --quiet -r requirements.txt
	@touch $(VENV)/bin/activate

# ──────────────────────────────────────────────────────────────────────────────
.PHONY: kernel
kernel: install
	@echo "$(CYAN)▶  Registering Jupyter kernel '$(KERNEL)' ...$(RESET)"
	$(IPYTHON) -m ipykernel install --user --name $(KERNEL) --display-name "GenAI Architectures ($(KERNEL))"
	@echo "$(GREEN)✅  Kernel '$(KERNEL)' registered.$(RESET)"
	@echo "    Select it in Jupyter:  Kernel → Change Kernel → GenAI Architectures"

# ──────────────────────────────────────────────────────────────────────────────
.PHONY: jupyter
jupyter: install
	@echo "$(CYAN)▶  Starting Jupyter Lab ...$(RESET)"
	$(JUPYTER) lab --no-browser

# ──────────────────────────────────────────────────────────────────────────────
.PHONY: freeze
freeze:
	@$(PIP) freeze

# ──────────────────────────────────────────────────────────────────────────────
.PHONY: install-ollama
install-ollama:
	@echo "$(CYAN)▶  Installing Ollama on Linux ...$(RESET)"
	@curl -fsSL https://ollama.com/install.sh | sh
	@echo "$(GREEN)✅  Ollama installed.$(RESET)"
	@echo "    Check status:  ollama --version"
	@echo "    Start server:  ollama serve"

# ──────────────────────────────────────────────────────────────────────────────
.PHONY: pull-llama
pull-llama:
	@echo "$(CYAN)▶  Pulling $(LLAMA_MODEL) ...$(RESET)"
	@if ! command -v ollama > /dev/null 2>&1; then \
		echo "$(BOLD)Ollama not found. Run:  make install-ollama$(RESET)"; \
		exit 1; \
	fi
	ollama pull $(LLAMA_MODEL)
	@echo "$(GREEN)✅  $(LLAMA_MODEL) ready.$(RESET)"
	@echo "    Test it:  ollama run $(LLAMA_MODEL)"

# ──────────────────────────────────────────────────────────────────────────────
.PHONY: clean
clean:
	@echo "$(CYAN)▶  Removing virtual environment ...$(RESET)"
	rm -rf $(VENV)
	@echo "$(GREEN)✅  Clean done.$(RESET)"
