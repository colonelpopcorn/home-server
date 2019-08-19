#!/usr/bin/python
import sys
import os
import subprocess

def enable_ipvs():
    enable_script = """
    modprobe ip_vs
    """
    subprocess.call(['sh', '-c', enable_script])

def init_keep_alive_daemon():
    sysname = os.uname()[1]
    sysnamedict = {
        "swarm-manager": 100,
        "swarm-worker-1": 200,
        "swarm-worker-1": 300,
    }
    keepalived_priority = sysnamedict.get(sysname, 100)
    daemon_script = """
    docker run -d --name keepalived --restart=always \
    --cap-add=NET_ADMIN --net=host \
    -e KEEPALIVED_UNICAST_PEERS="#PYTHON2BASH:['10.0.5.12', '10.0.5.11', '10.0.5.10']" \
    -e KEEPALIVED_VIRTUAL_IPS=10.0.5.15 \
    -e KEEPALIVED_PRIORITY={} \
    osixia/keepalived:2.0.17
    """.format(keepalived_priority)
    subprocess.call(['sh', '-c', daemon_script])



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

def main():
    # Add all your utility functions here.
    init_keep_alive_daemon()
    return True

# Jinja template the toml config for reusability
def prep_toml():
    return True

if __name__ == '__main__':
    print("Hello World")
    args = sys.argv
    print(args)
    func_dict = {
        "InstallKeepAliveD": init_keep_alive_daemon
    }
    if len(args) > 1:
        func_to_run = func_dict.get(args[1], None)
        if func_to_run is not None:
            func_to_run()
        else:
            print("That function doesn't exist!")
    else:
        assert(main())

