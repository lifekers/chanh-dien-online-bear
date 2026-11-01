@echo off
setlocal EnableExtensions

title Chanh Dien Online - Bear
set "ROOT=%~dp0"
set "LIVE=%~dp0live"
rem Dia chi IP may nay trong mang LAN (xem bang lenh ipconfig). De trong neu chi dung tren may nay.
set "LAN_IP=192.168.100.208"
rem Ten mien mien phi tu tro ve IP tren: nip.io (du phong: sslip.io). Chi dung trong mang LAN.
rem Ten dat rieng, cach nhau dau phay. Vi du: chanhdien.duckdns.org (tao mien phi tai duckdns.org)
set "LAN_NAMES=chanhdien.duckdns.org"
set "LAN_HOSTS="
if defined LAN_IP set "LAN_DASH=%LAN_IP:.=-%"
if defined LAN_IP set "LAN_HOSTS=%LAN_IP%,%LAN_IP%.nip.io,%LAN_IP%.sslip.io,chanhdien-%LAN_DASH%.sslip.io"
if defined LAN_NAMES if defined LAN_HOSTS set "LAN_HOSTS=%LAN_HOSTS%,%LAN_NAMES%"

where node >nul 2>nul
if errorlevel 1 (
  echo [LOI] Chua tim thay Node.js. Cai Node.js 20 tro len roi chay lai.
  pause
  exit /b 1
)

where npm >nul 2>nul
if errorlevel 1 (
  echo [LOI] Chua tim thay npm. Cai Node.js 20 tro len roi chay lai.
  pause
  exit /b 1
)

if not exist "%LIVE%\node_modules\ws" (
  echo [1/3] Dang cai dependency cho LIVE...
  pushd "%LIVE%"
  call npm install
  if errorlevel 1 (
    echo [LOI] npm install that bai.
    popd
    pause
    exit /b 1
  )
  popd
)

echo [2/3] Dang mo server LIVE tai http://localhost:3000 ...
start "Chanh Dien LIVE" /D "%LIVE%" cmd /k npm start

echo [3/3] Dang mo web tinh tai http://localhost:4173 ...
start "Chanh Dien Web" /D "%ROOT%" cmd /k npx --yes serve . -l tcp://0.0.0.0:4173

timeout /t 3 /nobreak >nul
start "" "http://localhost:4173"
start "" "http://localhost:3000/live/control.html"

echo.
echo Da mo xong.
echo Web:     http://localhost:4173
echo Control: http://localhost:3000/live/control.html
echo Overlay: http://localhost:3000/live/overlay.html
if defined LAN_IP (
  echo.
  echo Tu may khac trong mang LAN:
  echo Web:     http://chanhdien-%LAN_DASH%.sslip.io:4173
  echo Control: http://chanhdien-%LAN_DASH%.sslip.io:3000/live/control.html
  echo Overlay: http://chanhdien-%LAN_DASH%.sslip.io:3000/live/overlay.html
  if defined LAN_NAMES echo Ten rieng: %LAN_NAMES%  ^(cong 4173 web, 3000 control/overlay^)
  echo Du phong: %LAN_IP%.nip.io hoac %LAN_IP%
)
echo Dong hai cua so server de dung ung dung.
timeout /t 5 /nobreak >nul
endlocal
