@echo off
d:
cd d:\uhserver
del diigo.*

net stop UHServer 
svn update
net start UHServer 
path=%path%;C:\Program Files\Firefox_3.5
firefox http://localhost:6666/uha_books