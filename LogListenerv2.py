import json
import socket
import requests
import win32con
import win32event
import win32evtlog
import xmltodict

"""
This program receives the honeypots configuration from TrapsConfiguration.py and searches for the corresponding data.

Windows events have the following structure:
<Event xlmns="...">
    <System>
        {some System information}
        <IP>
        <ComputerName>
        ...
    </System>
    <EventData>
        <Data Name = "ProcessId">{Process ID}</Data>
        ...
        ...
    </EventData>
</Event>

if the data from the configuration file found in windows events:
    the event is forwarding to the server in order to alert the system administrator from unauthorized entity

in addition, the program categorize the event information for the convenience of the system administrator.

"""


class LogListenerv2:
    # Constructor: initializes to search for any kind of event in the system for the specified log category.
    def __init__(self, log_type):
        self.query_text = '*'
        self.log_type = log_type

    # Method: helper method for __identify_honeypot  - checks for corresponding data from windows event
    def __is_data_in_winevt(self, evt_data, evt_format):
        for data in evt_data:
            if data not in evt_format:
                return False
        return True

    # Method: filtering the windows event by <event id> and then searches
    # for corresponding information from 'honetpot_conf' file
    # Returns the honeypot name when corresponding information is found
    def __identify_honeypot(self, evt_id, evt_format, honeypot_conf):
        if honeypot_conf.get(evt_id) is None:
            return None
        for events in honeypot_conf[evt_id]:
            if self.__is_data_in_winevt(events['EventData'], evt_format) is True:
                return events['honeypotName']
        return None

    # Method: resolves hostname to ip address
    def get_ip(self, hostname):
        ip_address = socket.gethostbyname(hostname)
        return ip_address

    # Method: retrieves the username from the <EventData> section in windows event xml
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

    # Method: retrieves the username from the <UserData> section in windows event xml
    def __find_user_from_userdata(self, data, event_info):
        event_info_keys = data[event_info].keys()
        for key in event_info_keys:
            try:
                return data[event_info][key]['SubjectUserName']
            except KeyError:
                continue
        return "No User Information"

    # Method: identifying if windows event has category of <UserData> or <EventData>
    def __event_category(self, data):
        if self.log_type == 'Security' or (
                'RenderingInfo' in data['Event'] and data['Event']['RenderingInfo']['Channel'] == 'Security'):
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

    # Method: sending an alert for the server after data filtration
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
        requests.post("https://localhost:3002", data=alert_format, verify=False)

    # This method is managing the class and act like the "main of the class".
    # Method: listens for windows events
    #         categorizes the data in windows event and filters the require data
    #         checks for corresponding event information in order to alert the system administrator
    #         sends the alerts to the server
    def listen(self, honeypot_configuration):
        h = win32event.CreateEvent(None, 0, 0, None)
        s = win32evtlog.EvtSubscribe(self.log_type, win32evtlog.EvtSubscribeStartAtOldestRecord, SignalEvent=h,
                                     Query=self.query_text)
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
                    honeypot = self.__identify_honeypot(event_id, event_format_xml, honeypot_configuration)
                    if honeypot is not None:
                        self.__alert(event_format_dict, event_id, honeypot)
            while True:
                print("Waiting " + self.log_type)
                w = win32event.WaitForSingleObjectEx(h, 10000, True)
                if w == win32con.WAIT_OBJECT_0:
                    break
