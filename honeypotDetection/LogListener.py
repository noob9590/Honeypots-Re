import win32evtlog
import time
from win32event import *
from threading import Lock


class LogListener:

    def __init__(self, server_name, log_t,):
        self.server = server_name
        self.log_type = log_t
        self.flags = win32evtlog.EVENTLOG_FORWARDS_READ | win32evtlog.EVENTLOG_SEQUENTIAL_READ
        self.handle = win32evtlog.OpenEventLog(self.server, self.log_type)

    def __detect_event_type(self, current_event_value):
        if current_event_value == 1:
            return "CRITICAL"
        elif current_event_value == 2:
            return "ERROR"
        elif current_event_value == 3:
            return "WARNING"
        elif current_event_value == 4:
            return "INFO"
        elif current_event_value == 5:
            return "VERBOSE"
        else:
            return "UNKNOWN"

    def __print_events_info(self, events):
        for event in events:
            print("[+] Log Type: ", self.log_type)
            print("[+] Events Category: ", event.EventCategory)
            print("[+] Time Generated: ", event.TimeGenerated)
            print("[+] Source Name: ", event.SourceName)
            print("[+] Event ID: ", event.EventID)
            print("[+] Event Type: ", self.__detect_event_type(event.EventType))
            print("[+] Computer Name: ", event.ComputerName)
            print("[+] Sid: ", event.Sid)
            data = event.StringInserts
            if data:
                print("DIR = ", data)
                # print("[+] Event Data:")
                # for msg in data:
                #     print(msg)
            print("\n\n")

    def __events_catcher(self, offset):
        while True:
            events = win32evtlog.ReadEventLog(self.handle, self.flags, offset)
            if not events:
                break
            self.__print_events_info(events)

    def listen(self, lock):
        prev_num_of_events = win32evtlog.GetNumberOfEventLogRecords(self.handle)
        event_handle = CreateEvent(None, True, True, None)
        win32evtlog.NotifyChangeEventLog(self.handle, event_handle)
        while True:
            event_signal_id = WaitForSingleObject(event_handle, 10000)
            if event_signal_id == WAIT_OBJECT_0:
                print("New Event(s): ")
                total_events = win32evtlog.GetNumberOfEventLogRecords(self.handle)
                new_events = total_events - prev_num_of_events
                offset = total_events - new_events
                lock.acquire()
                try:
                    self.__events_catcher(offset)
                finally:
                    lock.release()
                ResetEvent(event_handle)
                prev_num_of_events = total_events
            time.sleep(2)
