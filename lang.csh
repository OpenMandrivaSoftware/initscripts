# /etc/profile.d/lang.csh - set i18n stuff

if (! $?LC_SOURCED) then
    set LC_SOURCED=0
endif

foreach file ("$HOME/.i18n" /etc/locale.conf /etc/sysconfig/i18n)
	if ($LC_SOURCED != 1 && -f $file ) then
	    eval `sed 's|=C$|=en_US|g' $file | sed 's|^#.*||' | sed 's|\([^=]*\)=\([^=]*\)|setenv \1 \2|g' | sed 's|$|;|' `
	    setenv LC_SOURCED 1
	endif
end

if ($LC_SOURCED == 1) then
    if ($?LC_ALL && $?LANG) then
        if ($LC_ALL == $LANG) then
            unsetenv LC_ALL
        endif
    endif
    
    set consoletype=`/sbin/consoletype stdout`

    if ($?CHARSET) then
        switch ($CHARSET)
            case 8859-1:
            case 8859-2:
            case 8859-5:
	    case 8859-8:
            case 8859-15:
            case KOI*:
            case LATIN2*:
                if ( $?TERM ) then
                    if ( "$TERM" == "linux" ) then
                        if ( "$consoletype" == "vt" ) then
                            /bin/echo -n -e '\033(K' >/dev/tty
                        endif
                    endif
                endif
                breaksw
	endsw
    endif
    if ($?SYSFONTACM) then
        switch ($SYSFONTACM)
	    case iso01*:
	    case iso02*:
	    case iso05*:
	    case iso08*:
	    case iso15*:
	    case koi*:
	    case latin2-ucw*:
	        if ( $?TERM ) then
		    if ( "$TERM" == "linux" ) then
		        if ( "$consoletype" == "vt" ) then
			    /bin/echo -n -e '\033(K' > /dev/tty
		        endif
		    endif
		endif
		breaksw
	endsw
    endif
    if ($?LANG) then
        switch ($LANG)
	    case *.utf8*:
	    case *.UTF-8*:
		if ( $?TERM ) then
		    if ( "$TERM" == "linux" ) then
			if ( "$consoletype" == "vt" ) then
			    switch ($LANG)
			    	case en_IN*:
			    		breaksw
			    	case ja*:
			    	case ko*:
			    	case si*:
			    	case zh*:
			    	case ar*:
			    	case fa*:
			    	case he*:
			    	case *_IN*:
			    		setenv LANG en_US.UTF-8
			    		breaksw
			    endsw
			    if ( -x /bin/unicode_start ) then
			      if { /sbin/consoletype fg } then
			        if ( $?SYSFONT ) then
			          if ( $?SYSFONTACM ) then
			            unicode_start $SYSFONT $SYSFONTACM
			          else
			            unicode_start $SYSFONT
			          endif
			        endif
			      endif
			    endif
			endif
		    endif
		endif
		breaksw
	    case *:
		if ( $?TERM ) then
		    if ( "$TERM" == "linux" ) then
			if ( "$consoletype" == "vt" ) then
			    switch ($LANG)
			    	case en_IN*:
			    		breaksw
			    	case ja*:
			    	case ko*:
			    	case si*:
			    	case zh*:
			    	case ar*:
			    	case fa*:
			    	case he*:
			    	case *_IN*:
			    		setenv LANG en_US
			    		breaksw
			    endsw
			    if ( -x /bin/unicode_stop ) then
                              if { /sbin/consoletype fg } then
                                /bin/unicode_stop
                              endif
                            endif
			endif
		    endif
		endif
		breaksw
	endsw
    endif    
    unsetenv SYSFONTACM
    unsetenv SYSFONT
    unset consoletype
endif
