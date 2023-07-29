@echo off

call flutter clean
call flutter pub get
del pubspec.lock

call flutter build apk

xcopy /s /y build\app\outputs\flutter-apk\app-release.apk apks\
