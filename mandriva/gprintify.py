#!/usr/bin/python
#---------------------------------------------------------------
# Project         : Mandriva linux
# Module          : mandrake
# File            : gprintify.py
# Version         : $Id$
# Author          : Frederic Lepied
# Created On      : Tue Feb  6 18:39:14 2001
# Purpose         : rewrite $"bla $TOTO bla" in "bla %s bla" $TOTO
#                   and echo => gprintf
#                   and toto=$"sfdg" => toto=`gprintf "sdfg"`
#---------------------------------------------------------------

import sys
import re

echo_regex=re.compile('^(.*)echo +(-[en]+)?')
i18n_regex=re.compile('^(.*?)\$"([^"]+)"(.*)$')
var_regex=re.compile('(\$[a-zA-Z0-9_{}]+(?:\[\$[a-zA-Z0-9_{}]+\])?}?)')
assign_regex=re.compile('^([^\[=]+)=(\s*)$')

def process_start(start):
    res=echo_regex.findall(start)
    if res:
        if 'n' in res[0][1]:
            return [res[0][0] + 'gprintf "', '"', '']
        else:
            return [res[0][0] + 'gprintf "', '\\n"', '']
    else:
        res=assign_regex.findall(start)
        if res:
            return [res[0][0] + '=' + '`gprintf "', '"', '`']
        else:
            return [start + '"', '"', '', '']

def process_vars(str, trail):
    var_res=var_regex.findall(str)
    if var_res:
        ret=var_regex.sub('%s', str) + trail
        for v in var_res:
            ret = ret + ' ' + v
        return ret
    else:
        return str + trail

def process_line(line):
    res=i18n_regex.findall(line)
    if res: 
        res=res[0]
        start=process_start(res[0])
        str=process_vars(res[1], start[1])
        end=res[2]
        final=start[0] + str + start[2]
        
        res=i18n_regex.findall(end)
        if res:
            res=res[0]
            start=process_start(res[0])
            str=process_vars(res[1], start[1])
            end=res[2]
            return final + start[0] + str + start[2] + end + '\n'
        else:
            return final + end + '\n'
    else:
        return line

def process_file(filename):
    fd=open(filename, 'r')
    lines=fd.readlines()
    fd.close()

    fd=open(filename, 'w')
    for l in lines:
        fd.write(process_line(l))
    fd.close()
    
def main(args):
    for f in args:
        process_file(f)

if __name__ == '__main__':
    main(sys.argv[1:])

# gprintify.py ends here
