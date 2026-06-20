.PHONY: venv install-python-packages install-r install-rstudio install-all clean-venv help

PYTHON  := $(shell command -v python3 2>/dev/null || echo python3)
VENV    := /home/lubom/venvs/ai_workshop
VENV_PY := $(VENV)/bin/python3
VENV_PIP := $(VENV)/bin/pip
SHELL   := /bin/bash

help: ## Show this help message
	@echo "Available targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-25s\033[0m %s\n", $$1, $$2}'

venv: ## Create the Python virtual environment
	@echo "Creating venv at $(VENV)..."
	@if [ ! -d "$(VENV)" ]; then \
		$(PYTHON) -m venv $(VENV); \
	else \
		echo "Venv already exists at $(VENV)"; \
	fi

install-all: venv install-python-packages install-r install-rstudio ## Install everything (Python packages + R + RStudio)

install-python-packages: venv ## Install Python packages from requirements.txt into the venv
	@echo "Installing Python packages into $(VENV)..."
	$(VENV_PIP) install --upgrade pip
	$(VENV_PIP) install -r requirements.txt

install-r: ## Install R + littler
	@echo "Installing R..."
	sudo apt-get update
	sudo apt-get install -y r-base r-base-dev r-cran-littler
	@echo "R version:"
	R --version | head -1
	@echo "littler version:"
	r --version | head -1

install-rstudio: install-r ## Install RStudio Desktop
	@echo "Installing RStudio Desktop..."
	rm -f /tmp/rstudio.deb
	wget -O /tmp/rstudio.deb https://download1.rstudio.org/electron/jammy/amd64/rstudio-2026.05.1-225-amd64.deb
	sudo apt-get install -y /tmp/rstudio.deb
	rm -f /tmp/rstudio.deb
	@echo "RStudio installed."

clean-venv: ## Remove the virtual environment
	@echo "Removing venv at $(VENV)..."
	rm -rf $(VENV)
	@echo "Done."
