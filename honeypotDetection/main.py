import LogListenerv2
import threading
import time


def event_log_pulling(l_type):
    print(l_type)
    current = LogListenerv2.LogListenerv2(l_type['logType'])
    current.listen()
    return current


def main():
    threads = []
    log_types = [{'logType': "Security"}]
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


if __name__ == '__main__':
    main()
