#!/usr/bin/python
import sys
import subprocess

def setup_dirs():
    dir_script = """
      sudo mkdir -pv ./volumes/app/mattermost/{data,logs,config} \
      chown -R 2000:2000 ./volumes/app/mattermost/
    """
    subprocess.call([dir_script])

def run_all():
    # Add all your utility functions here.
    return True

if __name__ == '__main__':
    args = sys.argv
    if len(args) <= 0:
      run_all()
