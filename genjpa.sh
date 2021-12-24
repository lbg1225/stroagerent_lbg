#!/bin/bash

Package=$1
Class=
Repository=
Model=
IdType=


#----------------------
# 문자열을 소문자로 치환
#----------------------
Tolower()
{
    input=$*
	Result=`echo ${input,,}`
}

#----------------------
# 문자열을 대문자로 치환
#----------------------
Toupper()
{
    input=$*
    Result=`echo ${input^^}`
}

#----------------------
# 문자열의 첫글자만 대문자로 치환
#----------------------
ToupperFirst()
{
    input=$*
    Result=`echo ${input^}`
}

#----------------------
# 스네이크 케이스 문자열을 카멜케이스로 변경
#----------------------
SnakeCaseToCamelCase()
{
    Result=`echo $1 | sed -E 's/[ _-]([a-z])/\U\1/gi;s/^([A-Z])/\l\1/'`
}


Initialize()
{
    for dir in `echo model persistence`
    do
	    if [ -d $dir ]
	    then
		    rm -rf $dir
	    fi
        mkdir $dir
	done
}

generationModel() 
{
   echo "package $Package.model;" | tee $Model

   cat $1 | tee -a $Model
}

setIdType()
{
    id=($(grep "@Id //" $1))
	IdType=${id[2]}
}

generationRepository() 
{
   echo "package $Package.persistence;" | tee $Persistence
   echo "" | tee -a $Persistence
   echo "import org.springframework.data.repository.PagingAndSortingRepository;" | tee -a $Persistence
   echo "import org.springframework.data.rest.core.annotation.RepositoryRestResource;" | tee -a $Persistence
   echo "import $Package.model.$Class"'Entity;' | tee -a $Persistence
   echo "" | tee -a $Persistence
   
   Tolower $Class
   tmp="$Result"s
   
   echo "@RepositoryRestResource(collectionResourceRel=\"$tmp\", path=\"$tmp\")" | tee -a $Persistence
   echo 'public interface '$Class'Repository extends PagingAndSortingRepository<'$Class"Entity, $IdType>{"  | tee -a $Persistence
   echo  "}" | tee -a $Persistence
}

main(){
   Initialize
   Package=$1
   cd tmp
   
   for file in `ls -1 *.java`
   do
       Class=`echo $file | sed 's/Entity.java//g'`
	   setIdType $file
	   Persistence="../persistence/$Class"Repository.java
	   Model="../model/$file"
       
	   generationModel $file
	   generationRepository
   done
}

if [ $# -ne 1 ]
then
    echo mssql jpa model '&' persistence generator
    echo usage : $0 package-path
else   
    main $1
fi
