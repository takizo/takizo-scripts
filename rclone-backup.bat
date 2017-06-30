@echo off

	REM SET THE ZIP PROGRAM, WE USE 7ZIP to Compress the Folder
	SET ZIPPRO="c:\Program Files\7-Zip\7z.exe"

	REM SET THE ACCOUNTING DIRECTORY FOR BACKUP
	SET ACCDIR="C:\Accounting"

	REM Backup to Google Drive with rclone 
	SET REMOTEBACKUPDIR=GDrive:AccountingBackup\%dtStamp%\

	REM Set the datetime format to readable format. 
	SET HOUR=%time:~0,2%
	SET dtStamp9=%date:~-4%%date:~4,2%%date:~7,2%_0%time:~1,1%%time:~3,2%%time:~6,2% 
	SET dtStamp24=%date:~-4%%date:~4,2%%date:~7,2%_%time:~0,2%%time:~3,2%%time:~6,2%

	if "%HOUR:~0,1%" == " " (SET dtStamp=%dtStamp9%) else (SET dtStamp=%dtStamp24%)


	REM change to rclone directory 
	cd C:\rclone

	echo "Compressing the backup files"

	REM Start to zip the folder 
	%ZIPPRO% a -t7z Backup.%dtStamp%.7z %ACCDIR% -ssw >> c:\rclone\logfile.txt 2>&1

	echo "Backup compress files into Google Drive"

	REM Copy the files to Google Drive
	rclone.exe -vvvvv sync Backup.%dtStamp%.7z %REMOTEBACKUPDIR% >> c:\rclone\logfile.txt 2>&1

	REM Delete the file after backup
	del Backup.%dtStamp%.7z >> c:\rclone\logfile.txt 2>&1