host = 'pi@<address>'
dest = '/home/pi/<dest>'
paswd = sshpass -p '<password>'


codename = 'blink7.s'

#transport: GP(I)O
#	#copy directory
#	$(paswd) scp -r GPIO $(host):$(dest)
	
#	$(paswd) ssh -t $(host) "cd $(dest) && chmod 755 $(codename) ; bash --login"
	
	#remove directory, ready for next make run
#	$(paswd) ssh -t $(host) rm -rf $(dest)
	

#transport: C
	#copy directory
#	$(paswd) scp -r C $(host):$(dest)
	
	#compile the code
#	$(paswd) ssh -t $(host) make -C $(dest)
	
	#ssh in, run gdb, makefile pauses until 'logout' command used in ssh shell
#	$(paswd) ssh -t $(host) "cd $(dest) ; bash --login"
	
	#remove directory, ready for next make run
#	$(paswd) ssh -t $(host) rm -rf $(dest)

transport: asm
	#copy directory
	$(paswd) scp -r asm $(host):$(dest)
	
	#compile the code
	$(paswd) ssh -t $(host) make -C $(dest)
	
	#ssh in, run gdb, makefile pauses until 'logout' command used in ssh shell
	$(paswd) ssh -t $(host) "cd $(dest) && gdb ./blink7 ; bash --login"
	
	#remove directory, ready for next make run
	$(paswd) ssh -t $(host) rm -rf $(dest)

	
	

