#!/bin/sh
#
# userspace-oomkiller <summary>
#

### BEGIN INIT INFO
# Provides: userspace-oomkiller 
# Required-Start: cgconfig
# Required-Stop: 
# Should-Start: 
# Should-Stop: 
# Default-Start: 2 3 4 5
# Default-Stop: 0 1 6
# Short-Description: 
# Description:      
### END INIT INFO

# Source function library.
. /etc/rc.d/init.d/functions

exec="/sbin/userspace-oomkiller"
prog="userspace-oomkiller"
cg="EXAMPLE_MEMORY_CGROUP"

[ -e /etc/sysconfig/$prog ] && . /etc/sysconfig/$prog

lockfile=/var/lock/subsys/$prog

start() {
    [ -x $exec ] || exit 5
    echo -n $"Starting $prog: "
    # if not running, start it up here, usually something like "daemon $exec"
    $exec -g "$cg" -d -p "$lockfile"
    return 0
}

stop() {
    echo -n $"Stopping $prog: "
    # stop it here, often "killproc $prog"
    kill `cat "$lockfile"`
    retval=$?
    echo
    [ $retval -eq 0 ] && rm -f $lockfile
    return $retval
}

restart() {
    stop
    start
}

reload() {
    restart
}

force_reload() {
    restart
}

rh_status() {
    # run checks to determine if the service is running or use generic status
    status $prog
}

rh_status_q() {
    rh_status >/dev/null 2>&1
}


case "$1" in
    start)
        rh_status_q && exit 0
        $1
        ;;
    stop)
        rh_status_q || exit 0
        $1
        ;;
    restart)
        $1
        ;;
    reload)
        rh_status_q || exit 7
        $1
        ;;
    force-reload)
        force_reload
        ;;
    status)
        rh_status
        ;;
    condrestart|try-restart)
        rh_status_q || exit 0
        restart
        ;;
    *)
        echo $"Usage: $0 {start|stop|status|restart|condrestart|try-restart|reload|force-reload}"
        exit 2
esac
exit $?
