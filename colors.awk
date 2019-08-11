#!/bin/bash
#############################################################
# to use on ALL arguments instead of just the first. replace	${1}	with	${@}
#############################################################
#EXAMPLE


### Colors defined ###
# Underline 	\033[4;##m
# Italic		\033[3;##m
# Background	\033[4#m
#----- Font Color ------#---------------- BOLD Font Color -------#
	black="\033[0;30m"			;		blackb="\033[1;30m"
	white="\033[0;37m"			;		whiteb="\033[1;37m"
	red="\033[0;31m"			;		redb="\033[1;31m"
	green="\033[0;32m"			;		greenb="\033[1;32m"
	yellow="\033[0;33m"			;		yellowb="\033[1;33m"
	blue="\033[0;34m"			;		blueb="\033[1;34m"
	purple="\033[0;35m"			;		purpleb="\033[1;35m"
	lightblue="\033[0;36m"		;		lightblueb="\033[1;36m"
# Clearing the color
	end="\033[0m"

### functions start ###
#---------- Font Color ---------------------------------#---------------- Text Background ------------------------------#
function black		{ printf "${black}${1}${end}";		};	function blackb		{ printf "${blackb}${1}${end}";		}
function white		{ printf "${white}${1}${end}";		};	function whiteb		{ printf "${whiteb}${1}${end}";		}
function red		{ printf "${red}${1}${end}";		};	function redb		{ printf "${redb}${1}${end}";		}
function green		{ printf "${green}${1}${end}";		};	function greenb		{ printf "${greenb}${1}${end}";		}
function yellow		{ printf "${yellow}${1}${end}";		};	function yellowb	{ printf "${yellowb}${1}${end}";	}
function blue 		{ printf "${blue}${1}${end}";		};	function blueb 		{ printf "${blueb}${1}${end}";		}
function purple 	{ printf "${purple}${1}${end}";		};	function purpleb 	{ printf "${purpleb}${1}${end}";	}
function lightblue	{ printf "${lightblue}${1}${end}";	};	function lightblueb	{ printf "${lightblueb}${1}${end}";	}

### EXAMPLE
# You want to color the phrase "leet hax" red
red "leet hax\n"




################################################################################################################
################################################################################################################
################################################################################################################
### functions start Original ###
function black {
  echo -e "${black}${1}${end}"
}

function blackb {
  echo -e "${blackb}${1}${end}"
}

function white {
  echo -e "${white}${1}${end}"
}

function whiteb {
  echo -e "${whiteb}${1}${end}"
}

function red {
  echo -e "${red}${1}${end}"
}

function redb {
  echo -e "${redb}${1}${end}"
}

function green {
  echo -e "${green}${1}${end}"
}

function greenb {
  echo -e "${greenb}${1}${end}"
}

function yellow {
  echo -e "${yellow}${1}${end}"
}

function yellowb {
  echo -e "${yellowb}${1}${end}"
}

function blue {
  echo -e "${blue}${1}${end}"
}

function blueb {
  echo -e "${blueb}${1}${end}"
}

function purple {
  echo -e "${purple}${1}${end}"
}

function purpleb {
  echo -e "${purpleb}${1}${end}"
}

function lightblue {
  echo -e "${lightblue}${1}${end}"
}

function lightblueb {
  echo -e "${lightblueb}${1}${end}"
}


##############
# can't seem to make it work (pretty sure these are the awk specific ones)
##############

function  BLACK(X)             { return "\033[30m"   X "\033[0m" }
function  RED(X)               { return "\033[31m"   X "\033[0m" }
function  GREEN(X)             { return "\033[32m"   X "\033[0m" }
function  YELLOW(X)            { return "\033[33m"   X "\033[0m" }
function  BLUE(X)              { return "\033[34m"   X "\033[0m" }
function  MAGENTA(X)           { return "\033[35m"   X "\033[0m" }
function  CYAN(X)              { return "\033[36m"   X "\033[0m" }
function  WHITE(X)             { return "\033[37m"   X "\033[0m" }
function  BRIGHT_BLACK(X)      { return "\033[90m"   X "\033[0m" }
function  BRIGHT_RED(X)        { return "\033[91m"   X "\033[0m" }
function  BRIGHT_GREEN(X)      { return "\033[92m"   X "\033[0m" }
function  BRIGHT_YELLOW(X)     { return "\033[93m"   X "\033[0m" }
function  BRIGHT_BLUE(X)       { return "\033[94m"   X "\033[0m" }
function  BRIGHT_MAGENTA(X)    { return "\033[95m"   X "\033[0m" }
function  BRIGHT_CYAN(X)       { return "\033[96m"   X "\033[0m" }
function  BRIGHT_WHITE(X)      { return "\033[97m"   X "\033[0m" }
function  BG_BLACK(X)          { return "\033[40m"   X "\033[0m" }
function  BG_RED(X)            { return "\033[41m"   X "\033[0m" }
function  BG_GREEN(X)          { return "\033[42m"   X "\033[0m" }
function  BG_YELLOW(X)         { return "\033[43m"   X "\033[0m" }
function  BG_BLUE(X)           { return "\033[44m"   X "\033[0m" }
function  BG_MAGENTA(X)        { return "\033[45m"   X "\033[0m" }
function  BG_CYAN(X)           { return "\033[46m"   X "\033[0m" }
function  BG_WHITE(X)          { return "\033[47m"   X "\033[0m" }
function  BG_BRIGHT_BLACK(X)   { return "\033[100m"  X "\033[0m" }
function  BG_BRIGHT_RED(X)     { return "\033[101m"  X "\033[0m" }
function  BG_BRIGHT_GREEN(X)   { return "\033[102m"  X "\033[0m" }
function  BG_BRIGHT_YELLOW(X)  { return "\033[103m"  X "\033[0m" }
function  BG_BRIGHT_BLUE(X)    { return "\033[104m"  X "\033[0m" }
function  BG_BRIGHT_MAGENTA(X) { return "\033[105m"  X "\033[0m" }
function  BG_BRIGHT_CYAN(X)    { return "\033[106m"  X "\033[0m" }
function  BG_BRIGHT_WHITE(X)   { return "\033[107m"  X "\033[0m" }
function  SKYBLUE(X)           { return "\033[38;2;40;177;249m" X "\033[0m" }
