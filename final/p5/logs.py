import os
import datetime
import time
import logging

logger = logging.getLogger()
logger.addHandler(logging.FileHandler('logs.log'))
logger.setLevel(logging.INFO)

last_log = None
i = 0
ct = datetime.datetime.now()
while datetime.datetime.now() - ct < datetime.timedelta(seconds=10):
    message = 'Current time: ' + str(datetime.datetime.now())
    logger.log(logging.INFO, message)
    last_log = message
    i += 1
    time.sleep(0.00001)

new_sz = os.path.getsize('logs.log')
print(f'Size of logs.log: {new_sz}, if logrotate is working, size should be less than {i * 41} bytes')

print('Checking logs.log file')
with open('logs.log', 'rb') as f:
    try:
        f.seek(-2, os.SEEK_END)
        while f.read(1) != b'\n':
            f.seek(-2, os.SEEK_CUR)
    except OSError:
        f.seek(0)
    last_line = f.readline().decode().strip()
if not last_line:
    print('logs.log is empty\nChecking logs.log.1 file')
    with open('logs.log.1', 'r') as f:
        try:
            f.seek(-2, os.SEEK_END)
            while f.read(1) != b'\n':
                f.seek(-2, os.SEEK_CUR)
        except OSError:
            f.seek(0)
        last_line = f.readline().decode().strip()

if last_line == last_log:
    print('Logs are the same')
else:
    print('Logs are not the same')
    print(f'Last log: {last_log}')
    print(f'Last line in logs.log: {last_line}')