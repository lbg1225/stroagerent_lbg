#!/bin/bash
ECR=739063312398.dkr.ecr.ap-northeast-2.amazonaws.com
build()
{
    cd $1
    mvn package -B -D maven.test.skip=true
    docker build -t $ECR/$1:$2 .
    docker push $ECR/$1:$2
    cd ..    
}

ver=v1
if [ $# -gt 0 ] 
then
    ver=$1
fi

if [ $# -gt 1 ]
then
    build $1 $2
else
    for pkg in `echo gateway message payment reservation storage viewpage`
    do
        build $pkg $ver
    done
fi