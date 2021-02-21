default: 
		@echo "Please choose one of the following target: update, install."
		@exit 1

update:
		@cp ~/.zshrc ./zshrc
		@cp ~/.zprofile ./zprofile
		@echo "Updated config files present in the repo."

install:
		@cp ./zprofile ~/.zprofile
		@cp ./zshrc ~/.zshrc
		@echo "Installed zsh config files"


