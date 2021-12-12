#!/bin/bash

BaseDir=tmp
ClassName=
FileName=
Result=
Table=
BuilderTmp=builder.tmp
Builder=
FirstCol=

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

ClassAddLine()
{
    echo $@ | tee -a $FileName
}
     
#-------------------------------------
# CREATE TABLE [dbo].[TABLE]( 문자열 처리
# Class명 및 파일명 생성
#-------------------------------------
TableProc()
{
    input=$*
	
	Tolower $3
	SnakeCaseToCamelCase `echo $Result | sed 's/\[dbo\]\.\[//' | sed 's/\](//g'`
	ToupperFirst $Result
	
	Table=$Result
	ClassName=$Table'Entity'
	FileName=$BaseDir/$ClassName.java
	
	# echo $ClassName
	# echo $FileName
}

BaseClass()
{
    cat /dev/null > $FileName
	cat /dev/null > $BuilderTmp
	Builder=""
	FirstCol=""
	
    # ClassAddLine 'package com.weni.tmes.example.model;'
    ClassAddLine 'import java.math.BigDecimal;'
    ClassAddLine 'import java.sql.Date;'
    ClassAddLine 'import java.sql.Time;'
    ClassAddLine 'import java.sql.Timestamp;'
	ClassAddLine 'import java.io.Serializable;'
	ClassAddLine 'import javax.persistence.*;'
    ClassAddLine 'import org.springframework.beans.BeanUtils;'
    ClassAddLine 'import lombok.AccessLevel;'
    ClassAddLine 'import lombok.Builder;'
    ClassAddLine 'import lombok.Data;'
    ClassAddLine 'import lombok.EqualsAndHashCode;'
    ClassAddLine 'import lombok.Getter;'
    ClassAddLine 'import lombok.NoArgsConstructor;'
    ClassAddLine ''
    ClassAddLine '@Entity'
    ClassAddLine '@Getter'
    ClassAddLine "@Table(name=\"$Table\")"
    ClassAddLine '@NoArgsConstructor(access = AccessLevel.PROTECTED) // AccessLevel.PUBLIC'
	ClassAddLine "public class $ClassName implements Serialize {"
}

PrePostFunc()
{
	for func in `echo Persist Updata Remove`
	do
	    for gubun in `echo Pre Post`
		do    
	        echo "" | tee -a $FileName
	        echo "    @$gubun$func" | tee -a $FileName
            echo "    public void on$gubun$func() {" | tee -a $FileName
	        echo "         " | tee -a $FileName	
	        echo "" | tee -a $FileName	
	        echo "" | tee -a $FileName	
            echo "    }" | tee -a $FileName
		done
	done		
}

BuilderFunc()
{
    echo "" | tee -a $FileName
    echo "    @Builder" | tee -a $FileName
	echo "    public $ClassName($Builder) {" | tee -a $FileName
    cat $BuilderTmp | tee -a $FileName
	echo "    }" | tee -a $FileName
}

#--- Mapping SQL and Java Data Types------------------------+
#+-----------------+----------------+-----------------------+
#|SQL data type    |Java data type                          | 
#+-----------------+----------------+-----------------------+
#|                 |Simply mappable | Object mappable       | 
#+-----------------+----------------+-----------------------+
#|CHARACTER        |                | String                |
#|VARCHAR          |                | String                |
#|LONGVARCHAR      |                | String                |
#|NUMERIC          |                | java.math.BigDecimal  |
#|DECIMAL          |                | java.math.BigDecimal  |
#|BIT              | boolean        | Boolean               |
#|TINYINT          | byte           | Integer               |
#|SMALLINT         | short          | Integer               |
#|INTEGER          | int            | Integer               |
#|BIGINT           | long           | Long                  |
#|REAL             | float          | Float                 |
#|FLOAT            | double         | Double                |
#|DOUBLE PRECISION | double         | Double                |
#|BINARY           |                | byte[]                |
#|VARBINARY        |                | byte[]                |
#|LONGVARBINARY    |                | byte[]                |
#|DATE             |                | java.sql.Date         |
#|TIME             |                | java.sql.Time         |
#|TIMESTAMP        |                | java.sql.Timestamp    |
#+-----------------+----------------+-----------------------+
ColumnProc()
{
    Tolower `echo $1 | sed 's/\[//g' | sed 's/\]//g'`
    SnakeCaseToCamelCase $Result
    col=$Result
	Tolower $*
	datatype=$Result
	javatype=""
	
	case $datatype in
	    *bit*)       javatype="Boolean";;
	#   *tinyint*)   javatype="short";;   
    #	*smalint*)   javatype="short";;
	#   *bigint*)    javatype="long" ;;
		*int*)       javatype="Integer" ;;
		*real*)      javatype="Float" ;;
		*float*)     javatype="Double" ;;
		*double*)    javatype="Double" ;;
		*binary*)    javatype="byte[]" ;;
	    *char*)      javatype="String" ;;
	    *numer*)     javatype="BigDecimal" ;;
		*money*)     javatype="BigDecimal" ;;
		*decimal*)   javatype="BigDecimal" ;;
		*timestamp*) javatype="Timestamp" ;;
		*date*)      javatype="Date" ;;
		*time*)      javatype="Time" ;;
        *)           echo "----- $datatype" ;;		
	esac	
	
	# ------ Builder
	if [ "$FirstCol" == "" ]
	then 
	    FirstCol="T"
		echo "    @Id //  $javatype" | tee -a $FileName
		echo "    private $javatype $col;" | tee -a $FileName
		return
	elif [ "$Builder" == "" ]
	then
	    Builder=`echo $javatype $col`
	else
	    Builder=`echo $Builder, $javatype $col`
	fi 
	echo "    private $javatype $col;" | tee -a $FileName
	echo "        this.$col = $col;" >> $BuilderTmp
	# ------ Builder
}

AnalReadLine()
{
   input=$*
   
   case $input in 
      *CREATE*TABLE*)
	      TableProc $input 
          BaseClass
	      ;;
      \)?ON*)
	      BuilderFunc
		  PrePostFunc
	      ClassName="" 
          ClassAddLine "}"
          ClassAddLine ""		  
		  ;;
      *)
          if [ "$ClassName" != "" ]
          then[InternetShortcut]
URL=https://github.com/lbg1225/stroagerent_lbg

		      ColumnProc $input
          fi
		  ;;
   esac
}   

Initialize()
{
    if [ -d $BaseDir ]
	then
		rm -rf $BaseDir
	fi
    mkdir $BaseDir
}

main()
{
   Initialize
   
   while read line
   do
       AnalReadLine $line
   done < $1
   
   rm $BuilderTmp
}

if [ $# -ne 1 ]
then
    echo mssql jpa model base java generator
    echo usage : $0 create-sql-script-file-name
elif [ ! -f $1 ] 
then
    echo $1 '(create-sql-script-file-namecreate-sql-script-file-name) no exist!!'
else   
    main $1
fi
