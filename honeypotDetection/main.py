import LogListener
import threading
import time
import win32evtlog
def event_log_pulling(l_type):
    print(l_type)
    current = LogListener.LogListener(l_type['server'], l_type['logType'])
    current.listen(mutex)
    return current


mutex = threading.Lock()
threads = []
log_types = [{'logType': "System", 'server': "localhost"}, {'logType': "Security", 'server': "localhost"}]
for log in log_types:
    t = threading.Thread(target=event_log_pulling, args=[log])
    t.daemon = True
    t.start()
    threads.append(t)

try:
    while True:
        time.sleep(2)
except KeyboardInterrupt:
    print(f'[-] Quitting the program')
