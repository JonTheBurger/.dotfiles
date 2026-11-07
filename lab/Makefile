################################################################################
# Constants
################################################################################
.ONESHELL:
.PHONY: ${MAKECMDGOALS}
MAKEFILE_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
RED := \033[1;31m
BLU := \033[36m
RST := \033[0m

################################################################################
# Variables
################################################################################
## CI: [0] Set to 1 to enable CI mode
ifdef CI
else
endif

## UNSAFE: [0] Set to 1 to enable unsafe auto-fixes
ifdef UNSAFE
  RUFF_FLAGS += --unsafe-fixes
else
endif

## TRACE: [0] Set to 1 to enable extremely verbose output
ifdef TRACE
  export VERBOSE=1
  MYPY_FLAGS += -vvv
  PYREFLY_FLAGS += -v
  RUFF_FLAGS += -v
else
endif

## VERBOSE: [0] Set to 1 to increase verbosity
ifdef VERBOSE
  MYPY_FLAGS += --pretty
else
  PYREFLY_FLAGS += --output-format=min-text
  RUFF_FLAGS += --output-format concise
endif

################################################################################
# Goals
################################################################################
help: ## Shows this message
	@
	printf '${RED}Usage:\n  ${RST}${BLU}make [<VARIABLE>=<value>] <goal>\n${RST}'
	printf '${RED}Targets:\n${RST}'
	cat ${MAKEFILE_LIST} | awk -F'(:|##|])[ \t]*' '/[^:]*:[^:]+##[ \t]/ {printf "  ${BLU}%-18s${RST} %s\n", $$1, $$3}'
	printf '${RED}Variables:\n${RST}'
	cat ${MAKEFILE_LIST} | awk -F'(:|##|])[ \t]*' '/##[ \t]*[A-Z_]+:/ {printf "  ${BLU}%-18s ${RED}%s]${RST} %s\n", $$2, $$3, $$4}'

.venv: ## Create virtual environment for development
	uv sync --all-extras --all-groups

clean: ## Delete build artifacts
	rm -rf .artifacts .build .cache

distclean: clean ## Resets the repo back to its state at checkout
	git clena -xdff

dist: ## Build package for distribution
	uv build --out-dir .build

lint.pyrefly:
	uv run pyrefly check ${PYREFLY_FLAGS} .

lint.ruff:
	uv run ruff check ${RUFF_FLAGS} .

lint.mypy:
	uv run mypy ${MYPY_FLAGS} .

lint: lint.ruff lint.pyrefly lint.mypy ## Run static analysis (lint.<tool> to run one)

test: ## Run unit tests
	uv run pytest

check: lint test ## Run pre-commit checks

fmt: ## Format source code
	uv run ruff format

format: fmt

fix: fmt ## Fix auto-fixable problems
	uv run ruff check ${RUFF_FLAGS} --fix

run:
	uv run homelab
