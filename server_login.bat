@echo off


curl -s --head http://www.google.com >nul
if %errorlevel%==0 (
    echo Success Network connection
) else (
    echo Fail
    exit /b 1
)






net use * /delete

set SERVER=saclaopr18.spring8.or.jp
echo %SERVER%
ping -n 1 "%SERVER%" > nul
if %ERRORLEVEL% equ 0 (
    echo Ping OK:   %SERVER%
    rem なぜか接続が時々きれるので、net use でドライブマッピングする際に /persistent:yes を付けて、再起動後も保持してみる
    net use \\%SERVER%\ses-users /persistent:yes /user:sesopr ses@sacla5712
    net use \\%SERVER%\common /persistent:yes /user:SPRING8\xfelopr xfel5712    
) else (
    echo Ping Fail: %SERVER%
)
rem exit /b 1




    rem	LOG-Note & Calendar Server
    rem	http://saclaopr19.spring8.or.jp/~lognote/calendar/gantt-group-tasks-together.html
    rem	net use \\saclaoprfs01.spring8.or.jp /user:SPRING8\xfelopr xfel5712
    net use \\saclaoprfs01.spring8.or.jp /user:xfelopr xfel5712


    net use \\xfelfs-ts.spring8.or.jp /user:xfelopr xfel5712


    rem SMBv1を有効にしないといけない
    net use \\sesaccfs2.spring8.or.jp\operation /user:linac linac

    rem ちょっと待たないと接続状態にならないので、5秒まってからnet useで確認
    timeout /t 7
    net use



pause