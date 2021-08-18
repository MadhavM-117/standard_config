default: 
		@echo "Please choose one of the following target: update, install."
		@exit 1

update:
		@cp ~/.config/alacritty/* ./ 
		@echo "Updated config files for alacritty."

install:
		@mkdir -p ~/.config/alacritty
		@cp ./alacritty.yml ./alacritty.default.yml ~/.config/alacritty/
		@echo "Installed config files for alacritty."

