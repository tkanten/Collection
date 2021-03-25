import my_debugger

debugger = my_debugger.debugger()

def attach_program():
    #pid = raw_input("Please enter the PID of the process to attach to: ")
    pid = 3668
    debugger.attach(int(pid))

def cpu_reg():
    lst = debugger.enumerate_threads()
    for thread in lst:
        thread_context = debugger.get_thread_context(thread)
        print "[*] DUMPING 0x%08x [*]" % thread
        print "RIP: 0x%016x" % thread_context.Rip
        print "RSP: 0x%016x" % thread_context.Rsp
        print "RBP: 0x%016x" % thread_context.Rbp
        print "RAX: 0x%016x" % thread_context.Rax
        print "RBX: 0x%016x" % thread_context.Rbx
        print "RCX: 0x%016x" % thread_context.Rcx
        print "RDX: 0x%016x" % thread_context.Rdx
        print("[*] END DUMP [*]")


def detach_program():
    debugger.detach()


def main():
    attach_program()

    cpu_reg()

    detach_program()


if __name__ == "__main__":
    main()

