host = '<username>@<address>'
dest = '/home/<username>/CCode'
paswd = sshpass -p '<password>'


codename = 'program'

transport: CCode
	#copy directory
	$(paswd) scp -r CCode $(host):$(dest)
	
	#compile the code
	$(paswd) ssh -t $(host) make -C $(dest)
	
	#ssh in, run gdb, makefile pauses until 'logout' command used in ssh shell
	$(paswd) ssh -t $(host) "cd $(dest) && gdb ./$(codename) ; bash --login"
	
	#remove directory, ready for next make run
	$(paswd) ssh -t $(host) rm -rf $(dest)
