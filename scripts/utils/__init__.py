import os
import subprocess


def run_process(cmd, env=None):
    print("Execute cmd: %s with env %s" % (cmd, env))
    if isinstance(cmd, str):
        cmd = cmd.split()
    cur_env = os.environ
    if env:
        for k in env:
            cur_env[k] = env[k]
    return bytes.decode(subprocess.check_output(cmd, env=cur_env))
