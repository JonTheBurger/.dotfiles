################################################################################
# $CONSTANTS
################################################################################
.DEFAULT_GOAL := help
.PHONY: ${MAKECMDGOALS}
RED := \033[1;31m
BLU := \033[36m
RST := \033[0m

################################################################################
# $VARIABLES
################################################################################
## VERBOSE: [0] Set to 1 for more verbose output (VERBOSE=1)
ifdef VERBOSE
	STOWFLAGS += --verbose
endif

################################################################################
# $GOALS
################################################################################
help:  ## Shows this message
	@printf '${RED}Usage:\n  ${RST}${BLU}make <goal>\n${RST}'
	@printf '${RED}Goals:\n${RST}'
	@cat ${MAKEFILE_LIST} | awk -F'(:|##|])\\s*' '/[^:]*:[^:]+##\s.*$$/ {printf "  ${BLU}%-18s${RST} %s\n", $$1, $$3}'
	@printf '${RED}Variables:\n${RST}'
	@cat ${MAKEFILE_LIST} | awk -F'(:|##|])\\s*' '/##\s*[A-Z_]+:.*$$/ {printf "  ${BLU}%-18s ${RED}%s]${RST} %s\n", $$2, $$3, $$4}'

stow:  ## Distributes softlinks in home to dotfiles
	@rm -f "${HOME}/.gtkrc-2.0" # Some gtk jerk keeps removing my softlink
	stow home --no-folding --ignore='.*AppData.*' ${STOWFLAGS}

format:  ## Formats shell scripts
	shfmt -s -w .

lint:  ## Lints shell scripts
	find . -name '*.sh' -type f -exec shellcheck -x --color {} \;

jvim:
	mkdir -p "${HOME}/.local/bin/"
	echo "#!/bin/bash" > "${HOME}/.local/bin/jvim"
	echo "export NVIM_APPNAME=jvim" >> "${HOME}/.local/bin/jvim"
	echo 'nvim "$@"' >> "${HOME}/.local/bin/jvim"
	chmod +x "${HOME}/.local/bin/jvim"
	ln -s "${PWD}/home/.config/nvim/" "${HOME}/.config/jvim"

jvim.clean:
	rm -f "${HOME}/.local/bin/jvim"
	rm -rf "${HOME}/.cache/jvim"
	rm -rf "${HOME}/.config/jvim"
	rm -rf "${HOME}/.local/share/jvim"
	rm -rf "${HOME}/.local/state/jvim"
