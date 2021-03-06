.PHONY: help
.DEFAULT_GOAL := help
DOTBOT := ./dotbot/bin/dotbot

define PRINT_HELP_PYSCRIPT
import re, sys

print("{ln}{sp}HELP{sp}{ln}".format(ln=25*"=", sp=5*" "))
for line in sys.stdin:
	match = re.match(r'^([a-zA-Z_-]+):.*?## (.*)$$', line)
	if match:
		target, help = match.groups()
		print(" - {:26} {}".format(target, help))
endef
export PRINT_HELP_PYSCRIPT

include .env
export $(shell sed 's/=.*//' .env)

help:
	@python -c "$$PRINT_HELP_PYSCRIPT" < $(MAKEFILE_LIST)

git-init-submodules:
	@echo "===== Init git submodules ====="
	@git submodule update --init --recursive

set-shared: git-init-submodules ## Set shared jetbrains dotfiles symlinks in JetBrains dir.
	@echo "===== Jetbrains shared dotfiles setup ====="
	${DOTBOT} -c jetbrains.shared.dotbot.conf.yaml

set-linux: set-shared ## Set jetbrains dotfiles for linux.
	@echo "===== Jetbrains linux dotfiles setup ====="
	${DOTBOT} -c jetbrains.linux.dotbot.conf.yaml

set-macos: set-shared ## Set jetbrains dotfiles for macos.
	@echo "===== Jetbrains macos dotfiles setup ====="
	${DOTBOT} -c jetbrains.macos.dotbot.conf.yaml

dotbot-version: ## Show dotbot latest version.
	@echo "===== Dotbot versions ====="
	@cd dotbot && git fetch --all
	@echo "== Current =="
	@cd dotbot && git describe --tags
	@echo "== Latest =="
	@cd dotbot && git describe --tags `git rev-list --tags --max-count=1`

dotbot-update: ## Update dotbot to latest version.
	@echo "===== Update Dotbot version ====="
	@cd dotbot && git fetch --all
	@cd dotbot && git checkout `git rev-list --tags --max-count=1`
