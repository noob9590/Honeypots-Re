import win32evtlog, win32event, win32con
import json
import xmltodict


class LogListenerv2:
    def __init__(self, log_type):
        self.query_text = '*'
        self.log_type = log_type

    def listen(self):
        h = win32event.CreateEvent(None, 0, 0, None)
        s = win32evtlog.EvtSubscribe(self.log_type, win32evtlog.EvtSubscribeStartAtOldestRecord, SignalEvent=h, Query=self.query_text)

        while True:
            while True:
                events = win32evtlog.EvtNext(s, 10)
                if len(events) == 0:
                    break
                for event in events:
                    event_format_xml = win32evtlog.EvtRender(event, win32evtlog.EvtRenderEventXml)
                    event_format_dict = xmltodict.parse(event_format_xml)
                    if isinstance(event_format_dict['Event']['System']['EventID'], str):
                        event_id = event_format_dict['Event']['System']['EventID']
                    else:
                        event_id = event_format_dict['Event']['System']['EventID']['#text']
                    print(event_id)
            while True:
                print("waiting...")
                w = win32event.WaitForSingleObjectEx(h, 10000, True)
                if w == win32con.WAIT_OBJECT_0:
                    break




