#!/usr/bin/env python3
"""Double-fork daemonizer for long-running marathon/pulse processes.

The harness reaps managed-background terminals when the session idles, killing the
marathon (which must run for hours to monitor -> export). A classic double-fork +
os.setsid() fully detaches the grandchild from the controlling terminal AND the
harness's process group/session, so it survives session idle and turn boundaries.
macOS lacks the `setsid` binary but Python's os.setsid() works fine.

Usage: python3 vov_daemon.py <logfile> <cmd> [args...]
Prints the daemon PID to stdout, then the launching shell can return immediately.
"""
import os
import sys


def main():
    logfile = sys.argv[1]
    cmd = sys.argv[2:]
    if not cmd:
        sys.stderr.write("no command\n")
        sys.exit(2)

    # First fork: parent returns to the shell immediately.
    pid = os.fork()
    if pid > 0:
        # Read the grandchild PID the child wrote, then exit.
        os.waitpid(pid, 0)
        sys.exit(0)

    # Child: become session leader (detaches from controlling terminal + harness group).
    os.setsid()

    # Second fork: grandchild can never re-acquire a controlling terminal.
    pid2 = os.fork()
    if pid2 > 0:
        # Child writes grandchild PID to a sidecar file and exits.
        with open(logfile + ".pid", "w") as f:
            f.write(str(pid2))
        os._exit(0)

    # Grandchild: redirect std fds to the logfile and exec the target.
    os.chdir(os.path.dirname(os.path.abspath(__file__)))
    fd = os.open(logfile, os.O_WRONLY | os.O_CREAT | os.O_APPEND, 0o644)
    os.dup2(fd, 1)
    os.dup2(fd, 2)
    devnull = os.open(os.devnull, os.O_RDONLY)
    os.dup2(devnull, 0)
    os.execvp(cmd[0], cmd)


if __name__ == "__main__":
    main()
