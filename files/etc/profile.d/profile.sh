#
# profile.sh:		 Set interactive profile environment
#
# Used configuration files:
#
#     /etc/sysconfig/windowmanager
#     /etc/sysconfig/suseconfig
#     /etc/sysconfig/mail
#     /etc/sysconfig/proxy
#     /etc/sysconfig/console
#

for sys in /etc/sysconfig/windowmanager	\
	   /etc/sysconfig/suseconfig	\
	   /etc/sysconfig/mail		\
	   /etc/sysconfig/proxy		\
	   /etc/sysconfig/console
do
    test -s $sys || continue
    while read line ; do
	case "$line" in
	\#*|"") continue ;;
        esac
	eval val=${line#*=}
	case "$line" in
	CWD_IN_ROOT_PATH=*)
	    test "$val" = "yes" || continue
	    test $UID -lt 100 && PATH=$PATH:.
	    ;;
	CWD_IN_USER_PATH=*)
	    test "$val" = "yes" || continue
	    test $UID -ge 100 && PATH=$PATH:.
	    ;;
	FROM_HEADER=*)
	    FROM_HEADER="${val}"
	    export FROM_HEADER
	    ;;
	SCANNER_TYPE=*)
	    SCANNER_TYPE="${val}"
	    export SCANNER_TYPE
	    ;;
	PROXY_ENABLED=*)
	    PROXY_ENABLED="${val}"
	    ;;
	HTTP_PROXY=*)
	    http_proxy="${val}"
	    export http_proxy
	    ;;
	HTTPS_PROXY=*)
	    https_proxy="${val}"
	    export https_proxy
	    ;;
	FTP_PROXY=*)
	    ftp_proxy="${val}"
	    export ftp_proxy
	    ;;
	GOPHER_PROXY=*)
	    gopher_proxy="${val}"
	    export gopher_proxy
	    ;;
	NO_PROXY=*)
	    no_proxy="${val}"
	    export no_proxy
	    ;;
	DEFAULT_WM=*)
	    DEFAULT_WM="${val}"
	    ;;
	CONSOLE_MAGIC=*)
	    CONSOLE_MAGIC="${val}"
	    ;;
	esac
    done < $sys
done
unset sys line val

if test -d /usr/lib/qt3 ; then
    QTDIR=/usr/lib/qt3
    export QTDIR
fi

if test -d /usr/lib/dvgt_help ; then
    DV_IMMED_HELP=/usr/lib/dvgt_help
    export DV_IMMED_HELP
fi

if test -d /usr/lib/rasmol ; then
    RASMOLPATH=/usr/lib/rasmol
    export RASMOLPATH
fi

if test "$PROXY_ENABLED" != "yes" ; then
    unset http_proxy https_proxy ftp_proxy gopher_proxy no_proxy
fi
unset PROXY_ENABLED

test -z "$DEFAULT_WM" && DEFAULT_WM=twm
SAVEPATH=$PATH
PATH=$PATH:/usr/X11R6/bin:/opt/gnome/bin:/usr/openwin/bin
WINDOWMANAGER="`type -p ${DEFAULT_WM##*/}`"
PATH=$SAVEPATH
export WINDOWMANAGER
unset DEFAULT_WM SAVEPATH

if test -n "$CONSOLE_MAGIC" ; then
    case "$(tty 2> /dev/null)" in
    /dev/tty*)
	if test "$TERM" = "linux" -a -t ; then
	    echo -en "\033$CONSOLE_MAGIC"
	fi
    esac
fi
#
# end of profile.sh
