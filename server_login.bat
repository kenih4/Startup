 @echo off


curl -s --head http://www.google.com >nul
if %errorlevel%==0 (
    echo Success Network connection

rem	tasklist | findstr /i "ms-teams.exe" >nul
rem	if %errorlevel%==0 (
rem	    echo ms-teams.exe is RUNNING
	rem Open Channel [朝ミーティング]
rem	    start "" "https://teams.microsoft.com/l/channel/19%3Ab75283a8ac374119b1507a1e076cc817%40thread.tacv2/%E6%9C%9D%E3%83%9F%E3%83%BC%E3%83%86%E3%82%A3%E3%83%B3%E3%82%B0%EF%BC%88%E5%8A%A0%E9%80%9F%E5%99%A8%EF%BC%89?groupId=5dbfd7f4-6b93-4638-b960-fec23213fc2a&tenantId=b1ce6928-6dd8-436d-9cc8-427132b02adf"
rem	) else (
rem	    echo ms-teams.exe is NOT RUNNING
rem	    ms-teams.exe
rem	)


    net use * /delete

rem なぜか接続が時々きれるので、net use でドライブマッピングする際に /persistent:yes を付けて、再起動後も保持してみる
    net use \\saclaopr18.spring8.or.jp\ses-users /persistent:yes /user:sesopr ses@sacla5712
    net use \\saclaopr18.spring8.or.jp\common /persistent:yes /user:SPRING8\xfelopr xfel5712

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

) else (
    echo Fail
)



pause