@echo off

set year=%DATE:~10,4%
set month=%DATE:~4,2%
set day=%DATE:~7,2%
set hour=%TIME:~0,2%
set minute=%TIME:~3,2%
set second=%TIME:~6,2%
set date=%year%-%month%-%day% %hour%:%minute%:%second%

cd admin_panel_web

call flutter clean
call flutter pub get
del pubspec.lock

call flutter build web --web-renderer html --release

call firebase deploy --only hosting

cd ..

call git add .
call git commit -m "update website %date%"
call git push