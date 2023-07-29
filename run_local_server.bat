@echo off

rem go to release/web folder
cd website


call python -m http.server 8000

cd ..

rem open localhost:8000 in browser
start http://localhost:8000

rem go back to root folder
cd ..

