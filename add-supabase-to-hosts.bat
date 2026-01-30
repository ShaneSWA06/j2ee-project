@echo off
echo ================================================
echo  Adding Supabase hostname to Windows hosts file
echo ================================================
echo.
echo This requires Administrator privileges.
echo.
echo Adding: 2406:da18:243:7424:bf4e:8b4b:d74:4526 db.gdhvmwsyrftemrjtydbv.supabase.co
echo.
echo %windir%\System32\drivers\etc\hosts >> %windir%\System32\drivers\etc\hosts 2>&1 && (
    echo 2406:da18:243:7424:bf4e:8b4b:d74:4526 db.gdhvmwsyrftemrjtydbv.supabase.co >> %windir%\System32\drivers\etc\hosts
    echo.
    echo SUCCESS! Hostname added to hosts file.
    echo.
    echo You can now test the database connection.
) || (
    echo.
    echo ERROR: Could not write to hosts file.
    echo Please run this script as Administrator!
    echo.
    echo Right-click this file and select "Run as Administrator"
)
echo.
pause
