# The following was present in rc.sysinit

r /fsckoptions
r /.autofsck
r /halt
r /poweroff
r /.suspended
r /etc/killpower

# The following should really go away after /var/run and /var/lock
# are converted to tmpfs
R /var/lock/cvs/*
R /var/run/screen/*

r /tmp/.lock.*
r /tmp/.s.PGSQL.*
R /tmp/hsperfdata_*
R /tmp/kde-*
R /tmp/ksocket-*
R /tmp/mc-*
R /tmp/mcop-*
R /tmp/orbit-*
R /tmp/ssh-*
R /tmp/.fam_socket
R /tmp/.esd
R /tmp/.esd-*
R /tmp/pulse-*
R /tmp/.sawfish-*
R /tmp/esrv*
R /tmp/kio*
R /var/lib/gdm/core.*

R /tmp/gpg-*
