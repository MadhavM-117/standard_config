default: 
		@echo "Please choose one of the following target: update, install."
		@exit 1

update:
		@cp ~/.config/Code/User/*.json ./
		@echo "Updated config files present in the repo."

install:
		@mkdir -p ~/.config/Code/User
		@cp ./*.json ~/.config/Code/User/
		@echo "Installed vs-code config files"


