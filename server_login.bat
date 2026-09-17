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



rem	LOG-Note & Calendar Server 今の所、使わないのでコメントアウトした
rem	http://saclaopr19.spring8.or.jp/~lognote/calendar/gantt-group-tasks-together.html
rem	net use \\saclaoprfs01.spring8.or.jp /user:SPRING8\xfelopr xfel5712
rem net use \\saclaoprfs01.spring8.or.jp /user:xfelopr xfel5712


net use \\xfelfs-ts.spring8.or.jp /user:xfelopr xfel5712


rem SMBv1を有効にしないといけない
net use \\sesaccfs2.spring8.or.jp\operation /user:linac linac


rem SSHFSでマウント  ScreenInfoなど用
cmdkey /add:ubuntu22pd /user:kenichi /pass:kenichi1
net use \\sshfs\kenichi@ubuntu22pd\q_ubuntu /user:kenichi kenichi1

cmdkey /add:ubuntu22pd /user:xfelopr /pass:xfel5712
net use \\sshfs\xfelopr@ubuntu22pd\users\kenichi\dvlp\xfel_scm_file_q\scm_if /user:xfelopr xfel5712

cmdkey /add:ubuntu22pd /user:oper /pass:spring8
net use \\sshfs\oper@ubuntu22pd\users\kenichi\dvlp\xfel_scm_file_q\scm_if /user:oper spring8



rem ちょっと待たないと接続状態にならないので、7秒まってからnet useで確認
timeout /t 7
net use

pause