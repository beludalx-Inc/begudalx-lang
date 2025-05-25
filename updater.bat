@echo off
setlocal enabledelayedexpansion

REM Настройки
set OWNER=begudalx-inc
set REPO=begudalx-lang
set FILTER=.exe

REM Получаем JSON с последним релизом
curl -s https://api.github.com/repos/%OWNER%/%REPO%/releases/latest > latest.json

REM Извлекаем ссылку на файл, имя которого содержит FILTER
for /f "delims=" %%i in ('jq -r ".assets[] | select(.name | contains(\"%FILTER%\")) | .browser_download_url" latest.json') do (
    set DOWNLOAD_URL=%%i
)

if not defined DOWNLOAD_URL (
    echo Не найден файл с расширением %FILTER% в релизе.
    goto :eof
)

echo Скачиваем %DOWNLOAD_URL%
curl -L -o latest_file.exe "%DOWNLOAD_URL%"

echo Готово! Файл сохранён как latest_file.exe

REM Можно добавить логику замены файла и перезапуска программы
pause
