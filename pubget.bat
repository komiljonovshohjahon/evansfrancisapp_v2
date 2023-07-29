@echo off

cd dependency_plugin

call flutter pub get

cd ..

cd admin_panel_web

call flutter pub get

cd ..

call flutter pub get