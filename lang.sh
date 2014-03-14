# /etc/profile.d/lang.sh - set i18n stuff

# revert special console/X11 settings if needed
if [ "$LC_SOURCED_CONSOLE" = 1 -a -n "$DISPLAY" ]; then
	unset LC_SOURCED
	unset LC_SOURCED_CONSOLE
elif [ "$LC_SOURCED_X11" = 1 -a -z "$DISPLAY" ]; then
	unset LC_SOURCED
	unset LC_SOURCED_X11
fi

# only source one of the possible files, and in that order;
# if system wide and user config are mixed and different, umpredictable
# things will happen...
for langfile in "$HOME/.i18n" /etc/locale.conf ; do
	[ -f $langfile -a "$LC_SOURCED" != 1 ] && . $langfile && LC_SOURCED=1 && export LC_SOURCED
done    

if [ "$LC_SOURCED" = 1 ]; then
    if [ -n "$LANG" ] ; then
       [ "$LANG" = "C" ] && LANG="en_US"
       export LANG
    else
       unset LANG
    fi
    [ -n "$LANG" ] && export LANG || unset LANG
    [ -n "$LC_ADDRESS" ] && export LC_ADDRESS || unset LC_ADDRESS
    [ -n "$LC_CTYPE" ] && export LC_CTYPE || unset LC_CTYPE
    [ -n "$LC_COLLATE" ] && export LC_COLLATE || unset LC_COLLATE
    [ -n "$LC_IDENTIFICATION" ] && export LC_IDENTIFICATION || unset LC_IDENTIFICATION
    [ -n "$LC_MEASUREMENT" ] && export LC_MEASUREMENT || unset LC_MEASUREMENT
    [ -n "$LC_MESSAGES" ] && export LC_MESSAGES || unset LC_MESSAGES
    [ -n "$LC_MONETARY" ] && export LC_MONETARY || unset LC_MONETARY
    [ -n "$LC_NAME" ] && export LC_NAME || unset LC_NAME
    [ -n "$LC_NUMERIC" ] && export LC_NUMERIC || unset LC_NUMERIC
    [ -n "$LC_PAPER" ] && export LC_PAPER || unset LC_PAPER
    [ -n "$LC_TELEPHONE" ] && export LC_TELEPHONE || unset LC_TELEPHONE
    [ -n "$LC_TIME" ] && export LC_TIME || unset LC_TIME
    if [ -n "$LC_ALL" ]; then
       if [ "$LC_ALL" != "$LANG" ]; then
         export LC_ALL
       else
         unset LC_ALL
       fi
    else
       unset LC_ALL
    fi
    [ -n "$LANGUAGE" ] && export LANGUAGE || unset LANGUAGE
    [ -n "$LINGUAS" ] && export LINGUAS || unset LINGUAS
    [ -n "$_XKB_CHARSET" ] && export _XKB_CHARSET || unset _XKB_CHARSET
    
    consoletype=$CONSOLETYPE
    if [ -z "$consoletype" ]; then
      consoletype=$(/sbin/consoletype stdout)
    fi

    if [ -n "$LANG" ]; then
      case $LANG in
    	*.utf8*|*.UTF-8*)
    	if [ "$TERM" = "linux" ]; then
    	    if [ "$consoletype" = "vt" ]; then
    	    	case $LANG in 
    	    		ja*) LANG=en_US.UTF-8 ;;
    	    		ko*) LANG=en_US.UTF-8 ;;
			si*) LANG=en_US.UTF-8 ;;
    	    		zh*) LANG=en_US.UTF-8 ;;
    	    		ar*) LANG=en_US.UTF-8 ;;
    	    		fa*) LANG=en_US.UTF-8 ;;
    	    		he*) LANG=en_US.UTF-8 ;;
    	    		en_IN*) ;;
    	    		*_IN*) LANG=en_US.UTF-8 ;;
    	    	esac
            fi
        fi
	;;
	*)
	if [ "$TERM" = "linux" ]; then
	    if [ "$consoletype" = "vt" ]; then
    	    	case $LANG in 
    	    		ja*) LANG=en_US ;;
    	    		ko*) LANG=en_US ;;
			si*) LANG=en_US ;;
    	    		zh*) LANG=en_US ;;
    	    		ar*) LANG=en_US ;;
    	    		fa*) LANG=en_US ;;
    	    		he*) LANG=en_US ;;
    	    		en_IN*) ;;
    	    		*_IN*) LANG=en_US ;;
    	    	esac
	    fi
	fi
	;;
      esac
    fi

    unset SYSFONTACM SYSFONT consoletype
fi
unset sourced
unset langfile
