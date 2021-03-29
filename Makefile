default: 
		@echo "No target specified. Specify one of: update, install."

update: 
		@$(MAKE) -C ./neovim update
		@$(MAKE) -C ./i3 update
		@$(MAKE) -C ./tmux update
		@$(MAKE) -C ./vscode update
		@$(MAKE) -C ./zsh update

install:
		@$(MAKE) -C ./fonts install
		@$(MAKE) -C ./i3 install
		@$(MAKE) -C ./neovim install 
		@$(MAKE) -C ./tmux install 
		@$(MAKE) -C ./vscode install
		@$(MAKE) -C ./zsh install


install-st:
	@$(MAKE) -C ./st clean install


