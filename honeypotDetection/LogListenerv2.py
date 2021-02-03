import win32evtlog, win32event, win32con
import json
import xmltodict
import requests
import socket
import lxml.etree as etree


class LogListenerv2:
    def __init__(self, log_type):
        self.query_text = '*'
        self.log_type = log_type

    def __identify_honeypot(self, evt_id, evt_format, honeypot_conf):
        if honeypot_conf[int(evt_id)] is None or honeypot_conf[int(evt_id)]['EventID'] != evt_id:
            return False
        for data in honeypot_conf[int(evt_id)]['EventData']:
            if data not in evt_format:
                return False
        return True

    def get_ip(self, hostname):
        ip_address = socket.gethostbyname(hostname)
        return ip_address

    def __find_user_name_from_eventdata(self, data, event_info):
        target_user_name = None
        subject_user_name = None
        for obj in data[event_info]:
            if obj['@Name'] == 'TargetUserName':
                target_user_name = obj['#text']
            if obj['@Name'] == 'SubjectUserName':
                subject_user_name = obj['#text']
            if subject_user_name is not None and target_user_name is not None:
                break
        if target_user_name is not None:
            return "Target: " + target_user_name
        if subject_user_name is None:
            return "No user information"
        return "Subject: " + subject_user_name

    def __find_user_from_userdata(self, data, event_info):
        event_info_keys = data[event_info].keys()
        for key in event_info_keys:
            try:
                return data[event_info][key]['SubjectUserName']
            except KeyError:
                continue
        return "No User Information"


    def __event_category(self, data):
        if self.log_type == 'Security' or ('RenderingInfo' in data['Event'] and data['Event']['RenderingInfo']['Channel'] == 'Security'):
            print("Security")
            if "EventData" in data['Event']:
                username = self.__find_user_name_from_eventdata(data['Event']['EventData'], 'Data')
            elif 'UserData' in data['Event']:
                username = self.__find_user_from_userdata(data['Event'], "UserData")
        elif "UserData" in data['Event']:
            username = self.__find_user_from_userdata(data['Event'], "UserData")
        else:
            username = "No User Information"
        return username

    def __alert(self, data, event_id, honeypot_n):
        honeypot_name = honeypot_n
        computer_name = data['Event']['System']['Computer']
        ip_address = self.get_ip(computer_name)
        system_time = data['Event']['System']['TimeCreated']['@SystemTime']
        username = self.__event_category(data)
        alert_format = {
            "honeypot": honeypot_name,
            "eventId": event_id,
            "ipAddress": ip_address,
            "computerName": computer_name,
            "systemTime": system_time,
            "username": username,
            "data": json.dumps(data, sort_keys=False, indent=4)
        }
        # print(json.dumps(alert_format, sort_keys=False, indent=4))
        requests.post("https://localhost:3002", data=alert_format, verify=False)

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
                    if self.__identify_honeypot(event_id, event_format_xml, honeypot_configuration):
                        self.__alert(event_format_dict, event_id, honeypot_configuration[int(event_id)]['honeypotName'])
            while True:
                print("waiting...")
                w = win32event.WaitForSingleObjectEx(h, 10000, True)
                if w == win32con.WAIT_OBJECT_0:
                    break
