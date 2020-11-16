import win32evtlog, win32event, win32con
import json
import xmltodict
import requests
import socket


class LogListenerv2:
    def __init__(self, log_type):
        self.query_text = '*'
        self.log_type = log_type

    def __identify_honeypot(self, evt_id, evt_format, honeypot_conf):
        if honeypot_conf[int(evt_id)] is None:
            return False
        for data in honeypot_conf[int(evt_id)]['EventData']:
            if data not in evt_format:
                return False
        return True

    def get_ip(self, hostname):
        ip_address = socket.gethostbyname(hostname)
        return ip_address

    def __alert(self, data, event_id):
        username = ""
        honeypot_name = ""
        computer_name = data['Event']['System']['Computer']
        ip_address = self.get_ip(computer_name)
        system_time = data['Event']['System']['TimeCreated']['@SystemTime']
        if 'EventData' in data['Event'] and 'SubjectUserName' in data['Event']['EventData']:
            username = data['Event']['EventData']['SubjectUserName']
        elif 'UserData' in data['Event']:
            user_data_keys = data['Event']['UserData'].keys()
            subject_user_name_key = ""
            for key in user_data_keys:
                if 'SubjectUserName' in data['Event']['UserData'][key]:
                    subject_user_name_key = key
                    break
            username = data['Event']['UserData'][subject_user_name_key]['SubjectUserName']
        else:
            username = "No user information"
        alert_format = {
            "honeypot": honeypot_name,
            "eventId": event_id,
            "ipAddress": ip_address,
            "computerName": computer_name,
            "systemTime": system_time,
            "username": username,
            "data": json.dumps(data, sort_keys=False, indent=4)
        }
        print(json.dumps(alert_format, sort_keys=False, indent=4))
        requests.post("http://localhost:3000", data=alert_format)


    def listen(self, honeypot_configuration):
        h = win32event.CreateEvent(None, 0, 0, None)
        s = win32evtlog.EvtSubscribe(self.log_type, win32evtlog.EvtSubscribeStartAtOldestRecord, SignalEvent=h, Query=self.query_text)

        while True:
            while True:
                events = win32evtlog.EvtNext(s, 10)
                if len(events) == 0:
                    break
                for event in events:
                    event_id = None
                    event_format_xml = win32evtlog.EvtRender(event, win32evtlog.EvtRenderEventXml)
                    event_format_dict = xmltodict.parse(event_format_xml)
                    if isinstance(event_format_dict['Event']['System']['EventID'], str):
                        event_id = event_format_dict['Event']['System']['EventID']
                    else:
                        event_id = event_format_dict['Event']['System']['EventID']['#text']
                    if self.__identify_honeypot(event_id, event_format_xml, honeypot_configuration) is True:
                        self.__alert(event_format_dict, event_id)
            while True:
                print("waiting...")
                w = win32event.WaitForSingleObjectEx(h, 10000, True)
                if w == win32con.WAIT_OBJECT_0:
                    break




