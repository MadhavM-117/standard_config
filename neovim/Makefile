default: 
		@echo "Please choose one of the following target: update, install."
		@exit 1

update:
		@cp ~/.config/nvim/*.vim ./
		@echo "Updated config files present in the repo."

install:
		@cp ./*.vim ~/.config/nvim/
		@[ ! -d "$HOME/.config/nvim/plugged" ] && \
			mkdir ~/.config/nvim/plugged && \
			echo "created directory for neovim plugins"
		@nvim --headless +PlugInstall +qa
		@echo "Installed nvim config files & installed plugins"


