@echo off
:build

call flutter clean
del pubspec.lock
call flutter pub get

goto end
:end