default: 
		@echo "Please choose one of the following target: jetbrains.zip, install."
		@exit 1

jetbrains.zip:
		@curl https://download-cf.jetbrains.com/fonts/JetBrainsMono-2.225.zip > jetbrains.zip
		@echo "Downloaded Jetbrains font files."

install: jetbrains.zip
		@sudo apt-get install -y fonts-font-awesome fonts-powerline
		@unzip jetbrains.zip 
		@sudo cp -r ./fonts /usr/local/share/fonts/jetbrains
		@echo "Installed all required fonts"


