net use * /delete
net use
net use \\saclaopr18.spring8.or.jp\common /user:sesopr ses@sacla5712
net use \\saclaopr18.spring8.or.jp\common /user:SPRING8\xfelopr xfel5712




rem	LOG-Note & Calendar Server
rem	http://saclaopr19.spring8.or.jp/~lognote/calendar/gantt-group-tasks-together.html
rem	net use \\saclaoprfs01.spring8.or.jp /user:SPRING8\xfelopr xfel5712
net use \\saclaoprfs01.spring8.or.jp /user:xfelopr xfel5712


rem pingは通るが、、、、　　　ping sesaccfs2.spring8.or.jp    SMBv1を一時的に有効にしないといけない
net use \\sesaccfs2.spring8.or.jp\operation /user:linac linac

pause