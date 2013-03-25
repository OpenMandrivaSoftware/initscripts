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

R /var/lib/gdm/core.*
