import LogListenerv2
import threading
import time
import optparse
import TrapsConfiguration
import sys
import os
import json
"""
Windows events divided to several categories:
    
    Application    Security    System    Setup    Forwarded Events
    
In order to listen on each category there is a need of the use multi threading.
Each thread listen for a different category and one more thread for the main. 

The program manage the whole agent by the following order:

1) either starts the process the honeypot configuration and saves it into a *.txt file
    if the file already exists the program skip on the honeypot configuration
    
2) creates threads for the number of the event categories and uses LogListenerV2.py in order the identify an honeypot

3) endless loop to repeat the process

"""


# Method: event handler for threads
def event_log_pulling(l_type, json_obj):
    current = LogListenerv2.LogListenerv2(l_type[0]['logType'])
    current.listen(json_obj)
    return current


# Method: creates help menu for the agent
def arguments_parser():
    parser = optparse.OptionParser()
    parser.add_option("-f", "--file", dest="file_path", help="The file path for the configuration file")
    parser.add_option("--start", dest="configuration", help="--start argument in order to begin configuration process")
    (options, arguments) = parser.parse_args()
    if options.file_path is None and options.configuration is None:
        parser.print_help()
        sys.exit(1)
    return options


# Method: opens the configuration file from TrapsConfiguration.py
def open_configuration_file(file_path):
    try:
        if os.path.isdir(file_path):
            with open(os.path.dirname() + file_path, "r") as f:
                return json.load(f)
        else:
            with open(file_path, "r") as f:
                return json.load(f)
    except FileNotFoundError:
        print("No such file or directory")
        sys.exit(1)


# main
def main():
    json_file = None
    threads = []
    log_types = [{'logType': "System"}, {'logType': "Security"}, {'logType': 'Application'}, {'logType': "Setup"}, {'logType': "ForwardedEvents"}]
    option = arguments_parser()
    if option.file_path is None:
        conf = TrapsConfiguration.TrapsStructure()
        honeypot_configuration = conf.configure()
    else:
        honeypot_configuration = open_configuration_file(option.file_path)
    for log in log_types:
        t = threading.Thread(target=event_log_pulling, args=([log], honeypot_configuration))
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
