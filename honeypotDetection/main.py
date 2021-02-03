import LogListenerv2
import threading
import time
import optparse
import TrapsConfiguration
import sys
import os
import json


def event_log_pulling(l_type, json_obj):
    current = LogListenerv2.LogListenerv2(l_type[0]['logType'])
    current.listen(json_obj)
    return current


def arguments_parser():
    parser = optparse.OptionParser()
    parser.add_option("-f", "--file", dest="file_path", help="The file path for the configuration file")
    parser.add_option("--start", dest="configuration", help="--start argument in order to begin configuration process")
    (options, arguments) = parser.parse_args()
    if options.file_path is None and options.configuration is None:
        parser.print_help()
        sys.exit(1)
    return options


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
