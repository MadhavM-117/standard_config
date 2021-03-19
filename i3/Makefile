default: 
		@echo "Please choose one of the following target: update, install."
		@exit 1

update-laptop:
		@cp -r ~/.config/i3/config.d ~/.config/i3/i3-status.toml ./laptop/
		@cp ~/.config/dunst/dunstrc ./laptop/dunstrc
		@cp ~/.config/i3/rofi.conf ./laptop/rofi.conf
		@echo "Updated config files for laptop present in the repo."

install-laptop:
		@cp ./laptop/i3-status.toml ~/.config/i3/
		@cp -r ./laptop/config.d ~/.config/i3/
		@cat ~/.config/i3/config.d/* > ~/.config/i3/config
		@cp ./laptop/dunstrc ~/.config/dunst/dunstrc 
		@cp ./laptop/rofi.conf ~/.config/i3/rofi.conf
		@i3 reload
		@echo "Installed i3 config files, and restarted i3"

update-desktop:
		@cp -r ~/.config/i3/config.d ~/.config/i3/i3-status.toml ./desktop/
		@cp ~/.config/dunst/dunstrc ./desktop/dunstrc
		@cp ~/.config/i3/rofi.conf ./desktop/rofi.conf
		@echo "Updated config files for desktop present in the repo."

install-desktop:
		@cp ./desktop/i3-status.toml ~/.config/i3/
		@cp -r ./desktop/config.d ~/.config/i3/
		@cat ~/.config/i3/config.d/* > ~/.config/i3/config
		@cp ./desktop/dunstrc ~/.config/dunst/dunstrc 
		@cp ./desktop/rofi.conf ~/.config/i3/rofi.conf
		@i3 reload
		@echo "Installed i3 config files, and restarted i3"




