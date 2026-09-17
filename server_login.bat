@echo off
setlocal

rem 文字色を変えるためのエスケープ文字を取得(エラー/失敗を赤字表示するために使用)
for /F %%a in ('echo prompt $E^| cmd') do set "ESC=%%a"

rem ネットワーク接続確認
curl -s --head http://www.google.com >nul
if %errorlevel%==0 (
    echo Success Network connection
) else (
    echo %ESC%[91mFail%ESC%[0m
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

rem プログラムを統一する意味で、こちらも /persistent:yes を付けておく
call :ConnectIfAlive xfelfs-ts.spring8.or.jp
if %ERRORLEVEL% equ 0 (
    net use \\xfelfs-ts.spring8.or.jp /persistent:yes /user:xfelopr xfel5712
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
rem 起動直後などはまだ応答がないことがあるので、失敗したら少し待って
rem 最大3回までリトライする。3回とも失敗したら赤字で表示する
rem 使い方: call :ConnectIfAlive <サーバー名>
rem ---------------------------------------------
:ConnectIfAlive
set "SERVER=%~1"
set "RETRY=0"
echo %SERVER%

:ConnectIfAlive_Retry
ping -n 1 -w 1000 "%SERVER%" > nul
if %ERRORLEVEL% equ 0 (
    echo Ping OK:   %SERVER%
    exit /b 0
)
set /a RETRY+=1
if %RETRY% lss 3 (
    echo %ESC%[91mPing Fail: %SERVER% ^(%RETRY%/3、2秒待って再試行^)%ESC%[0m
    ping -n 3 127.0.0.1 > nul
    goto :ConnectIfAlive_Retry
)
echo %ESC%[91mPing Fail: %SERVER%%ESC%[0m
exit /b 1
