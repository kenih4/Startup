@echo off
setlocal

rem ネットワーク接続確認
curl -s --head http://www.google.com >nul
if %errorlevel%==0 (
    echo Success Network connection
) else (
    echo Fail
    exit /b 1
)

net use * /delete

rem なぜか接続が時々きれるので、net use でドライブマッピングする際に /persistent:yes を付けて、再起動後も保持してみる
call :ConnectIfAlive saclaopr18.spring8.or.jp
if %ERRORLEVEL% equ 0 (
    net use \\saclaopr18.spring8.or.jp\ses-users /persistent:yes /user:sesopr ses@sacla5712
    net use \\saclaopr18.spring8.or.jp\common /persistent:yes /user:SPRING8\xfelopr xfel5712
)

rem	LOG-Note & Calendar Server 今の所、使わないのでコメントアウトした
rem	http://saclaopr19.spring8.or.jp/~lognote/calendar/gantt-group-tasks-together.html
rem	net use \\saclaoprfs01.spring8.or.jp /user:SPRING8\xfelopr xfel5712
rem net use \\saclaoprfs01.spring8.or.jp /user:xfelopr xfel5712

call :ConnectIfAlive xfelfs-ts.spring8.or.jp
if %ERRORLEVEL% equ 0 (
    net use \\xfelfs-ts.spring8.or.jp /user:xfelopr xfel5712
)

rem SMBv1を有効にしないといけない
rem 当面使う予定がないのでコメントアウト
rem call :ConnectIfAlive sesaccfs2.spring8.or.jp
rem if %ERRORLEVEL% equ 0 (
rem     net use \\sesaccfs2.spring8.or.jp\operation /user:linac linac
rem )

rem SSHFSでマウント  ScreenInfoなど用
call :ConnectIfAlive ubuntu22pd
if %ERRORLEVEL% equ 0 (
    cmdkey /add:ubuntu22pd /user:kenichi /pass:kenichi1
    net use \\sshfs\kenichi@ubuntu22pd\q_ubuntu /user:kenichi kenichi1

    cmdkey /add:ubuntu22pd /user:xfelopr /pass:xfel5712
    net use \\sshfs\xfelopr@ubuntu22pd\users\kenichi\dvlp\xfel_scm_file_q\scm_if /user:xfelopr xfel5712

    cmdkey /add:ubuntu22pd /user:oper /pass:spring8
    net use \\sshfs\oper@ubuntu22pd\users\kenichi\dvlp\xfel_scm_file_q\scm_if /user:oper spring8
)

rem ちょっと待たないと接続状態にならないので、7秒まってからnet useで確認
timeout /t 7
net use

pause
goto :EOF

rem ---------------------------------------------
rem 指定サーバーに ping を打ち、疎通できれば ERRORLEVEL=0 を返す
rem 使い方: call :ConnectIfAlive <サーバー名>
rem ---------------------------------------------
:ConnectIfAlive
set "SERVER=%~1"
echo %SERVER%
ping -n 1 "%SERVER%" > nul
if %ERRORLEVEL% equ 0 (
    echo Ping OK:   %SERVER%
    exit /b 0
) else (
    echo Ping Fail: %SERVER%
    exit /b 1
)
