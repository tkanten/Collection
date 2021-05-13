host = '<username>@<address>'
dest = '/home/<username>/Assembly'
paswd = sshpass -p '<password>'
codename = 'assemb'

transport: Assembly
	#remove directory, clearing last make run
	$(paswd) ssh -t $(host) rm -rf $(dest)
	
	#copy directory
	$(paswd) scp -r Assembly $(host):$(dest)
	
	#compile the code
	$(paswd) ssh -t $(host) make -C $(dest)
	
	#ssh in, run gdb, makefile pauses until 'logout' command used in ssh shell
	$(paswd) ssh -t $(host) "cd $(dest) && gdb ./$(codename) ; bash --login"
	
