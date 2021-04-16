DOTPATH    := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))
CANDIDATES := $(wildcard .??*)
EXCLUSIONS := .DS_Store .git .gitmodules .travis.yml
DOTFILES   := $(filter-out $(EXCLUSIONS), $(CANDIDATES))

THISYEAR := $(shell date "+%Y")

list: ## Show dotfiles in this repository
	@$(foreach val, $(DOTFILES), /bin/ls -dF $(val);)

install: ## Create symlink to home directory
	@echo 'Copyright (c) 2015-$(THISYEAR) t-okkn All Rights Reserved.'
	@echo '==> Start to deploy dotfiles to home directory.'
	@echo ''
	@$(foreach val, $(DOTFILES), ln -sfnv $(abspath $(val)) $(HOME)/$(val);)

uninstall: clean ## Remove the dotfiles and this repository
	@echo ''
	@echo 'Next, remove this repository in your home directory...'
	-rm -rf $(DOTPATH)
	@echo 'Done.'
	@echo 'Thank you for using t-okkn/gotfiles!!'

clean: ## Remove the dotfiles
	@echo 'Remove dotfiles in your home directory...'
	@-$(foreach val, $(DOTFILES), rm -vrf $(HOME)/$(val);)

reinstall: clean ## Reinstall the dotfiles
	@echo ''
	@echo 'Next, install dotfiles in your home directory...'
	@$(foreach val, $(DOTFILES), ln -sfnv $(abspath $(val)) $(HOME)/$(val);)
	@echo ''
	@echo 'Reinstalled successful!!'

help: ## Self-documented Makefile
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-12s\033[0m %s\n", $$1, $$2}'

