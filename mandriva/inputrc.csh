# but tcsh command line doesn't use inputrc, so we have to define the
# keys here:
bindkey "\e[3~" delete-char
bindkey "^[[^@" beginning-of-line
bindkey "[5~" down-history
bindkey "[6~" up-history
bindkey "\e[1~" beginning-of-line
bindkey "\e[4~" end-of-line
bindkey "\e\C-h" backward-delete-word
bindkey "\e\C-?" delete-word
bindkey "\e\e[3~" delete-word
# rxvt
bindkey "\e[7~" beginning-of-line
bindkey "\e[8~" end-of-line
# some xterms
bindkey "\e[H" beginning-of-line
bindkey "\e[F" end-of-line
# nxterms
bindkey "\e[\C-@" beginning-of-line
bindkey "\e[e" end-of-line
# some more X11 oddity
bindkey "\eOD" backward-char
bindkey "\eOC" forward-char
bindkey "\eOB" down-history
bindkey "\eOA" up-history

