@echo off
cd /d "%USERPROFILE%\Desktop"


REM 检查 ADB 工具是否已在环境变量中
where adb >nul 2>&1
if errorlevel 1 goto End

REM 检查 ADB 设备是否已连接
for /f "tokens=1,2" %%a in ('adb devices') do (
    if "%%b" == "device" (
        echo ADB 设备已连接.
		goto ExportLog
    )
)

goto NoDevice


:ExportLog
REM 获取当前日期和时间
FOR /F "tokens=1,2,3,4,5,6,7 delims=:/. " %%a IN ("%DATE% %TIME%") DO (
    SET YEAR=%%a
    SET MONTH=%%b
    SET DAY=%%c
    SET WEEK=%%d
    SET HOUR=%%e
    SET MINUTE=%%f
    SET SECOND=%%g
)
REM 创建目录
MD "log_%MONTH%%DAY%_%HOUR%%MINUTE%"
echo 目录 "log_%MONTH%%DAY%_%HOUR%%MINUTE%" 已创建.



echo 开始导出日志
REM adb pull /data/persistlogs/hsaelog    "log_%MONTH%%DAY%_%HOUR%%MINUTE%"
REM adb pull /data/persistlogs/sdrv_logs  "log_%MONTH%%DAY%_%HOUR%%MINUTE%"
REM adb pull /data/persistlogs/sde        "log_%MONTH%%DAY%_%HOUR%%MINUTE%"
adb pull /data/anr        "log_%MONTH%%DAY%_%HOUR%%MINUTE%"
adb pull /data/tombstones "log_%MONTH%%DAY%_%HOUR%%MINUTE%"
echo.
echo 日志导出成功 日志路径："%USERPROFILE%\Desktop\log_%MONTH%%DAY%_%HOUR%%MINUTE%"
echo.
goto End


:NoADB
echo 未找到 ADB 工具,请确保已正确安装并添加到环境变量.
goto End

:NoDevice
echo 未检测到 ADB 设备,请检查设备是否已连接并开启 USB 调试模式.
goto End

:End
pause