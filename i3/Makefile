default: 
		@echo "Please choose one of the following target: update, install."
		@exit 1

update:
		@cp -r ~/.config/i3/config.d ~/.config/i3/i3-status.toml ./
		@echo "Updated config files present in the repo."

install:
		@cp ./i3-status.toml ~/.config/i3/
		@cp -r ./config.d ~/.config/i3/
		@cat ~/.config/i3/config.d/* > ~/.config/i3/config
		@i3 reload
		@echo "Installed i3 config files, and restarted i3"



