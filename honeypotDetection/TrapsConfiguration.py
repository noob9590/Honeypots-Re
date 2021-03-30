import sys
import json
import os

"""
This program is receiving windows event information for each honeypot configuration.
The program uses hashset in order to save different windows events configurations for the same event number.
The program either takes user input configuration and saves it to a txt file for future use.

"""

class TrapsStructure:

    # Constructor: initializes dictionary to use it as hashset.
    def __init__(self):
        self.configurations = dict()

    # Method: exports the user input configuration to a *.txt file in a json structure.
    def __export_to_json_file(self):
        file_name = input("[+] Provide a name to the configuration file\n>>> ")
        _dir = os.path.dirname(__file__)
        file_path = os.path.join(_dir, file_name)
        with open(file_path, 'w+') as f:
            f.write(json.dumps(self.configurations))
            print(f"[+]Configuration was saved to: {file_name}")

    # Method: Takes user input and saves it in the hashset
    # exit program if <event id> == exit
    # continue to next event configuration if <event data> == done
    def configure(self):
        print("[+] Begins a configuration process ")
        index = 1
        while True:
            print("[+] Configuration: {}".format(index))
            event_id = input("[+] Event ID\n>>> ")
            try:
                if event_id == "exit":
                    self.__export_to_json_file()
                    return self.configurations
                if self.configurations.get(event_id) is None:
                    self.configurations[event_id] = []
                self.configurations[event_id].append({
                    "EventID": event_id,
                    "EventData": [],
                })
            except (ValueError, IndexError):
                print("[-] Invalid input\nQuitting the program")
                sys.exit(1)
            input_param = ">>> "
            print("[+] EventData trap configuration")
            while True:
                event_data_param = input(input_param)
                if event_data_param == "done":
                    honeypot_name = input("[+] Honeypot name\n>>>")
                    self.configurations[event_id][-1]['honeypotName'] = honeypot_name
                    print(f"[+] The configuration for EventID: {event_id} was saved")
                    break
                self.configurations[event_id][-1]['EventData'].append(event_data_param)
            index = index + 1









