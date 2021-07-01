#!/bin/bash

build()
{
    cd $1
    #mvn package -B -D maven.test.skip=true
    docker build -t lbg1225/$1:$2 .
    #docker push lbg1225/$1:$2
    cd ..    
}

ver=v1
if [ $# -gt 0 ] 
then
    ver=$1
fi

for pkg in `echo gateway message payment reservation storage viewpage`
do
    build $pkg $ver
done