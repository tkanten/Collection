from ctypes import *
from my_debugger_defines import *

kernel32 = windll.kernel32


class debugger:

    def __init__(self):
        self.h_process = None
        self.pid = None
        self.debugger_active = False

    def attach(self, pid):

        self.h_process = self.open_process(pid)

        # We attempt to attach to the process
        # if this fails we exit the call
        if kernel32.DebugActiveProcess(pid):
            self.debugger_active = True
            self.pid = int(pid)

            self.run()

        else:
            print "Unable to attach to the process"

    def open_process(self, pid):
        h_process = kernel32.OpenProcess(PROCESS_ALL_ACCESS, False, pid)
        return h_process

    def run(self):

        # Now we have to poll the debuggee for
        # debugging events
        while self.debugger_active:
            # and not keyboard.:
            self.get_debug_event()

    def get_debug_event(self):
        debug_event = DEBUG_EVENT()
        continue_status = DBG_CONTINUE

        # waits for a debug event for an infinite amount of time/or a keystroke
        if kernel32.WaitForDebugEvent(byref(debug_event), INFINITE):
            raw_input("Attached to %d! Press a key to continue..." % self.pid)
            self.debugger_active = False  # sets flag to false for outer while loop

            kernel32.ContinueDebugEvent(debug_event.dwProcessId, debug_event.dwThreadId, continue_status)

    def detach(self):

        if kernel32.DebugActiveProcessStop(self.pid):
            print("Finished debugging. Exiting...")
            return True
        else:
            print("There was an error")
            return False

    def open_thread(self, thread_id):
        h_thread = kernel32.OpenThread(THREAD_ALL_ACCESS, None, thread_id)

        if h_thread is not None:
            return h_thread
        else:
            print "Could not obtain a valid thread handle"
            return False

    def enumerate_threads(self):

        thread_entry = THREADENTRY32()
        thread_list = []
        snapshot = kernel32.CreateToolhelp32Snapshot(TH32CS_SNAPTHREAD, self.pid)

        if snapshot is not None:
            # set size of struct so call doesn't fail
            thread_entry.dwSize = sizeof(thread_entry)
            success = kernel32.Thread32First(snapshot, byref(thread_entry))

            while success:
                if thread_entry.th32OwnerProcessID == self.pid:
                    thread_list.append(thread_entry.th32ThreadID)

                success = kernel32.Thread32Next(snapshot, byref(thread_entry))

            kernel32.CloseHandle(snapshot)
            return thread_list
        else:
            return False

    def get_thread_context(self, thread_id=None, h_thread=None):
        context = CONTEXT64()
        context.ContextFlags = CONTEXT_FULL | CONTEXT_DEBUG_REGISTERS

        # get a handle to the thread

        h_thread = self.open_thread(thread_id)

        if kernel32.GetThreadContext(h_thread, byref(context)):
            kernel32.CloseHandle(h_thread)
            return context
        else:
            return False
