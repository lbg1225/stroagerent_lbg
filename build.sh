#!/bin/bash
#------------------------------------------------------------------------------------------
# Build 스크립트 Created By 이병관
#------------------------------------------------------------------------------------------

#-- ECR정보
ECR=739063312398.dkr.ecr.ap-northeast-2.amazonaws.com   
build()
{
    cd $1
    mvn clean                                 #-- Clean
    mvn compile                               #-- Compile
    mvn package -B -D maven.test.skip=true    #-- Package Build
    docker build -t $ECR/$1:$2 .              #-- Docker 이미지 생성
    docker push $ECR/$1:$2                    #-- Docker 이미지 Push
    cd ..    
}

ver=v1                                        #-- 기본버전은 v1
if [ $# -gt 0 ]                               #-- 버전정보만 입력시 ./build.sh v2                              
then
    ver=$1
fi

if [ $# -gt 1 ]                               #-- 특정 패키지 시 ./build.sh gateway v2
then
    build $1 $2
else                                          #-- 전체 패키지 생성
    for pkg in `echo gateway message payment reservation storage viewpage`
    do
        build $pkg $ver
    done
fi
