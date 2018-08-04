create_env:
	@pip3 install virtualenv
	@pip3 install virtualenvwrapper
	( \
		source /usr/local/bin/virtualenvwrapper.sh; \
		mkvirtualenv ocap; \
		pip3 install -r requirements.txt; \
	)
