#!/usr/bin/python
# sh_xgettext
# Arnaldo Carvalho de Melo <acme@conectiva.com.br>
# Wed Mar 10 10:24:35 EST 1999
# Copyright Conectiva Consultoria e Desenvolvimento de Sistemas LTDA
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
#
# Changelog
# Mon May 31 1999 Wanderlei Antonio Cavassin <cavassin@conectiva.com>
# * option --initscripts


from sys import argv, stderr, exit
from string import find, split, strip
from time import gmtime, strftime, time

s = {}

def xgettext(arq, tokens_i18n):
	line = 0
	f = open(arq, "r")
        while 1:
		l = f.readline()
		if not l: break
		line = line + 1
		if l[0:1] == '#':       continue
		elif l[0:1] == '\n':    continue
		else:
			for token in tokens_i18n:
				if not token[1]:
					pos = find(l, token[0] + ' $"')
					if pos == -1:
						pos = find(l, token[0] + ' "')
				else:
					pos = find(l, token[0] + ' "')
				if pos != -1:
					text = split(l[pos:], '"')[1]
					if not text: break
					if len(text) <= 2 or find(text, '$') != -1:
						continue
					if text[-1] == '\\':
						text = text[0:-1]
					if s.has_key(text):
						s[text].append((arq, line))
					else:
						s[text] = [(arq, line)]
	f.close()

def print_header():
	print '# SOME DESCRIPTIVE TITLE.'
	print '# Copyright (C) YEAR Free Software Foundation, Inc.'
	print '# FIRST AUTHOR <EMAIL@ADDRESS>, YEAR.'
	print '#'
	print '#, fuzzy'
	print 'msgid ""' 
	print 'msgstr ""' 
	print '"Project-Id-Version: initscripts VERSION\\n"'
	print strftime("\"POT-Creation-Date: %Y-%m-%d %H:%M+0000\\n\"",gmtime(time()))
	print '"PO-Revision-Date: YEAR-MO-DA HO:MI+ZONE\\n"'
	print '"Last-Translator: FULL NAME <EMAIL@ADDRESS>\\n"'
	print '"Language-Team: LANGUAGE <LL@li.org>\\n"'
	print '"MIME-Version: 1.0\\n"'
	print '"Content-Type: text/plain; charset=CHARSET\\n"'
	print '"Content-Transfer-Encoding: 8bit\\n"'
	print ''

def print_pot():
	print_header()

	for text in s.keys():
		print '#:',
		for p in s[text]:
			print '%s:%d' % p,
		if find(text, '%') != -1:
			print '\n#, c-format',
		print '\nmsgid "' + text + '"'
		print 'msgstr ""\n'
				
def main():
	i18n_tokens = []
	#i18n_tokens.append(('echo', 0))
	#i18n_tokens.append(('echo -n', 0))
	#i18n_tokens.append(('echo -e', 0))
	#i18n_tokens.append(('echo -en', 0))
	#i18n_tokens.append(('echo -ne', 0))
	i18n_tokens.append(('action', 0))
	i18n_tokens.append(('failure', 0))
	i18n_tokens.append(('passed', 0))
	i18n_tokens.append(('runcmd', 0))
	i18n_tokens.append(('success', 0))
	i18n_tokens.append(('gprintf', 1))
	i18n_tokens.append(('/sbin/getkey -c $AUTOFSCK_TIMEOUT -m', 0))

	for a in argv[1:]:
#		xgettext(a, i18n_tokens)
 		try:
 			xgettext(a, i18n_tokens)
 		except:
 			stderr.write('error while processing "%s" \n' % a)

	print_pot()

if __name__ == '__main__':
    main()
