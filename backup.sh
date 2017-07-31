#!/bin/bash
#author:        gieey
LogFile=/backup/log/`date +"%Y-%m-%d"`.log
if [ ! -f $LogFile ];  then
  touch "$LogFile"
  echo "create log file" > $LogFile
fi

DATE=`date +"%Y-%m-%d"`
SourceDir=/mnt
BakDir=/backup
RetainDay=7
ProjectLst=/backup/project.list
echo "backup start at $(date +"%Y-%m-%d %H:%M:%S")" > $LogFile
echo "--------------------------------------------------" >> $LogFile
cd $BakDir
PROJECTLIST=`cat $ProjectLst`
for Project in $PROJECTLIST
do
	ProjectData=$SourceDir/$Project
	DestDir=$BakDir/$Project
        if [ ! -f $DestDir ]; then
            mkdir -p $DestDir
	    echo "create DestDir $DestDir" >> $LogFile
        fi
	PackFile=$DATE.$Project.tar.gz
	PackPath=${PackFile/'/'/_}
        echo "pack path $PackPath" >> $LogFile
	if [ -f $BakDir/$PackFile ]
	then
		echo "backup file have exist !" >>$LogFile
	else
                echo "projectData $ProjectData OutSource $DestDir" >> $LogFile
                echo "project $Project" >> $LogFile
		File="${Project%/*}"
                echo "file $File"
		cp  -RHpf $ProjectData $DestDir > /dev/null
                echo "pack path $PackPath"
		tar -Pzcvf $PackPath $DestDir > /dev/null
		echo "backup $DestDir done into $PachPath ">>$LogFile
		ncftpput -u user -p password -R -P ip 目标目录/ $ordatabak $PackPath
                echo "send ftp $PackPath success " >>$LogFile
		rm -rf $DestDir
	fi
done
find $BakDir  -type f -name "*.tar.gz" -mtime +$RetainDay -exec rm -rf {} \;
echo "--------------------------------------------------" >> $LogFile
echo "backup end at $(date +"%Y-%m-%d %H:%M:%S")" >> $LogFile
echo " " >> $LogFile
exit 0
