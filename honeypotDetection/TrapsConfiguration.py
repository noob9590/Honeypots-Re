import sys
import json
import os


class TrapsStructure:

    def __init__(self):
        self.configureList = [None] * 65535

    def __export_to_json_file(self):
        file_name = input("[+] Provide a name to the configuration file\n>>> ")
        _dir = os.path.dirname(__file__)
        file_path = os.path.join(_dir, file_name)
        with open(file_path, 'w+') as f:
            f.write(json.dumps(self.configureList))
            print(f"[+]Configuration was saved to: {file_name}")

    def configure(self):
        print("[+] Begins a configuration process ")
        index = 1
        while True:
            print("[+] Configuration: {}".format(index))
            event_id = input("[+] Event ID\n>>> ")
            try:
                self.configureList[int(event_id)] = {
                    "EventID": event_id,
                    "EventData": [],
                }
            except (ValueError, IndexError):
                if event_id == "exit":
                    self.__export_to_json_file()
                else:
                    print("[-] Invalid input\nQuitting the program")
                    sys.exit(1)
                return self.configureList
            input_param = ">>> "
            print("[+] EventData trap configuration")
            while True:
                event_data_param = input(input_param)
                if event_data_param == "done":
                    honeypot_name = input("Honeypot name\n>>>")
                    self.configureList[int(event_id)]['honeypotName'] = honeypot_name
                    print(f"[+] The configuration for EventID: {event_id} was saved")
                    break
                self.configureList[int(event_id)]['EventData'].append(event_data_param)
            index = index + 1









