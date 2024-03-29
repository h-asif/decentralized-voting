#!/bin/bash

# This script allows to start a bootstrap
#
# Usage: command [bootstrap_name:[bootstrap_port]] [log_file]

source ../configure.sh

if [ $# -ne 2 ]
then
   echo -e "\e[35;33mNo arguments provided, using default: $BOOTSTRAP:$BOOTSTRAP_PORT"; tput sgr0 # magenta
   echo -e "\e[35;33mIf you want to define a bootstrap, a port and a log file, use the following syntax $0 bootstrapName:port filename"; tput sgr0
else
   if [[ `expr $1 : "[a-zA-Z.]*:[0-9]*"` ]]
   then
      BOOTSTRAP_PORT=${1#*:}
      BOOTSTRAP=${1%:*} #`expr match $1 '\([a-zA-Z\.]*\)'`

   else
      BOOTSTRAP=${1%:*}
   fi
fi

echo -e "\e[32;32mUsing bootstrap: $BOOTSTRAP and port $BOOTSTRAP_PORT"; tput sgr0 # green

echo -e "\e[32;32mLaunching bootstrap ($BOOTSTRAP) on port $BOOTSTRAP_PORT at time `date`"; tput sgr0 # green
ssh -i $SSHHOME -o ConnectTimeout=$SSH_TIMEOUT -o StrictHostKeyChecking=no ${LOGIN_NAME}@$full_bname "pkill -9 java; pkill -9 java; $JAVA_ -classpath $BINHOME $BOOTSTRAPCLASSNAME -bname $BOOTSTRAP -bport $BOOTSTRAP_PORT -votercount $VOTERCOUNT"


wait

echo -e "Finished at time `date`"
exit 0
