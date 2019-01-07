#!/usr/bin/python
import sys
import subprocess

def setup_dirs():
    dir_script = """
    sudo mkdir -pv ./volumes/app/mattermost/{data,logs,config} \
    chown -R 2000:2000 ./volumes/app/mattermost/
    """
    subprocess.call(['sh', '-c', dir_script])

def load_env():
    ps_script = """
        foreach($line in Get-Content $args[0]) {
            $envSplit = $line.Split("="); if (!$envSplit[0].startsWith("#")) {
                [System.Environment]::SetEnvironmentVariable($envSplit[0], $envSplit[1], [EnvironmentVariableTarget]::Process)
            }
        }
    """

def run_all():
    # Add all your utility functions here.
    setup_dirs()
    load_env()
    return True

# Jinja template the toml config for reusability
def prep_toml():
    return True

if __name__ == '__main__':
    args = sys.argv
    if len(args) <= 0:
    run_all()
