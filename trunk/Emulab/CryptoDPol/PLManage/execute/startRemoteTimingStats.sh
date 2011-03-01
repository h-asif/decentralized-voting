#!/bin/bash

source ../configure.sh

cd ../../$PROJECT_NAME/script/executor/;
./compJava.sh
cd -;
cd ../../;

java -classpath ../../$PROJECT_NAME/bin paillierp.testingPaillier.Testing -bitsnum $1 -servers $2 -threshold $3 -rounds $4 -candidatesLength $5

rsync -p -e "ssh -c arcfour -l $LOGIN_NAME -i $SSHHOME -o StrictHostKeyChecking=no -o ConnectTimeout=$SSH_TIMEOUT -o Compression=no -x" --timeout=$RSYNC_TIMEOUT -al --force --delete keys/pkeys  $LOGIN_NAME@$home_node:$PROJECT_HOME/keys/


rsync -p -e "ssh -c arcfour -l $LOGIN_NAME -i $SSHHOME -o StrictHostKeyChecking=no -o ConnectTimeout=$SSH_TIMEOUT -o Compression=no -x" --timeout=$RSYNC_TIMEOUT -al --force --delete $PROJECT_NAME/bin/ $LOGIN_NAME@$home_node:$BINHOME
cd -;
ssh -i $SSHHOME -o ConnectTimeout=$SSH_TIMEOUT -o StrictHostKeyChecking=no ${LOGIN_NAME}@$home_node "java -classpath $BINHOME paillierp.testingPaillier.Testing -bitsnum $1 -servers $2 -threshold $3 -rounds $4 -candidatesLength $5


