@echo off
setlocal EnableExtensions DisableDelayedExpansion
%SystemRoot%\System32\chcp.com 850 >nul
for /f "tokens=1-3 delims=:.," %%a in ("%time%") do (
    set /a "start=(%%a*3600)+(1%%b*60)+1%%c
)
cls

set Siege=0
set Niederlagen=0
set Unentschieden=0
set spiel=0
set SiP=0%
set NiP=0%
set UiP=0%
set SZ=00:00
set PC=0
set VPC=0
set Vf11=0
set Vf12=0
set Vf13=0
set Vf21=0
set Vf22=0
set Vf23=0
set Vf31=0
set Vf32=0
set Vf33=0

:menu

@echo off
if "%VPC%"=="0" set /a Scriptwahl=%random% %% 3 + 1

if "%VPC%"=="1" (
    if "%PC%"=="1" (
        set /a Vf11+=1
    ) else if "%PC%"=="2" (
        set /a Vf12+=1
    ) else if "%PC%"=="3" (
        set /a Vf13+=1
    )
)

if "%VPC%"=="2" (
    if "%PC%"=="1" (
        set /a Vf21+=1
    ) else if "%PC%"=="2" (
        set /a Vf22+=1
    ) else if "%PC%"=="3" (
        set /a Vf23+=1
    )
)

if "%VPC%"=="3" (
    if "%PC%"=="1" (
        set /a Vf31+=1
    ) else if "%PC%"=="2" (
        set /a Vf32+=1
    ) else if "%PC%"=="3" (
        set /a Vf33+=1
    )
)

set "VPC=%PC%"

if "%VPC%"=="1" (
    if %Vf11% gtr %Vf12% (
        if %Vf11% gtr %Vf13% (
            set Scriptwahl=2
        ) else (
            set Scriptwahl=1
        )
    ) else (
        if %Vf12% gtr %Vf13% (
            set Scriptwahl=3
        ) else (
            set Scriptwahl=1
        )
    )
)

if "%VPC%"=="2" (
    if %Vf21% gtr %Vf22% (
        if %Vf21% gtr %Vf23% (
            set Scriptwahl=2
        ) else (
            set Scriptwahl=1
        )
    ) else (
        if %Vf22% gtr %Vf23% (
            set Scriptwahl=3
        ) else (
            set Scriptwahl=1
        )
    )
)

if "%VPC%"=="3" (
    if %Vf31% gtr %Vf32% (
        if %Vf31% gtr %Vf33% (
            set Scriptwahl=2
        ) else (
            set Scriptwahl=1
        )
    ) else (
        if %Vf32% gtr %Vf33% (
            set Scriptwahl=3
        ) else (
            set Scriptwahl=1
        )
    )
)


set /a "SiP=(Siege*100)/spiele"
set /a "NiP=(Niederlagen*100)/spiele"
set /a "UiP=(Unentschieden*100)/spiele"

cls
color f
call :zeit
echo/                                                                                                                                       
echo Regeln:                                                                                        Statistik: 
echo - Schere schneidet Papier. Schere gewinnt!                                                     Spiele: %spiele%
echo - Papier bedeckt Stein. Papier gewinnt!                                                        Siege: %Siege% ^(%SiP%%%^)
echo - Stein bricht Schere. Stein gewinnt!                                                          Niederlagen: %Niederlagen% (^%NiP%%%^)
echo - Beide das gleiche ist Unentschieden!                                                         Unentschieden: %Unentschieden% (^%UiP%%%^): 
echo/                                                                                               Spielzeit: %SZ% Minuten
echo 1. Schere                                                    
echo 2. Stein                                              
echo 3. Papier                                             
echo/                                                       

%SystemRoot%\System32\choice.exe /c 123 /n /m "Bitte wählen Sie eine Zahl (1/2/3): "
set Userwahl=%errorlevel%
set /a spiele+=1

cls

if "%Userwahl%"=="1" set "PC=1"
if "%Userwahl%"=="2" set "PC=2"
if "%Userwahl%"=="3" set "PC=3"

if "%Userwahl%"=="1" set "Userwahl=Schere"
if "%Userwahl%"=="2" set "Userwahl=Stein"
if "%Userwahl%"=="3" set "Userwahl=Papier"

if "%Scriptwahl%"=="1" set "Scriptwahl=Schere"
if "%Scriptwahl%"=="2" set "Scriptwahl=Stein"
if "%Scriptwahl%"=="3" set "Scriptwahl=Papier"

if "%Userwahl%"=="%Scriptwahl%" (
    if "%Userwahl%"=="Schere" (
        call :show_schere_schere
    ) else if "%Userwahl%"=="Stein" (
        call :show_stein_stein
    ) else if "%Userwahl%"=="Papier" (
        call :show_papier_papier
    )
    %SystemRoot%\System32\timeout.exe /t 2 > nul
    call :unentschieden
    %SystemRoot%\System32\timeout.exe /t 2 > nul
    set /a Unentschieden+=1
) else if "%Userwahl%"=="Schere" (
    if "%Scriptwahl%"=="Papier" (
        call :show_schere_papier
        %SystemRoot%\System32\timeout.exe /t 2 > nul
        call :sieg
        set /a Siege+=1   
    ) else (
        call :show_schere_stein
        %SystemRoot%\System32\timeout.exe /t 2 > nul
        call :niederlage
        set /a Niederlagen+=1      
    )
    %SystemRoot%\System32\timeout.exe /t 2 > nul              
) else if "%Userwahl%"=="Stein" (
    if "%Scriptwahl%"=="Schere" (
        call :show_stein_schere
        %SystemRoot%\System32\timeout.exe /t 2 > nul
        call :sieg
        set /a Siege+=1
    ) else (
        call :show_stein_papier
        %SystemRoot%\System32\timeout.exe /t 2 > nul
        call :niederlage
        set /a Niederlagen+=1      
    )
    %SystemRoot%\System32\timeout.exe /t 2 > nul
) else if "%Userwahl%"=="Papier" (
    if "%Scriptwahl%"=="Stein" (
        call :show_papier_stein
        %SystemRoot%\System32\timeout.exe /t 2 > nul
        call :sieg
        set /a Siege+=1      
    ) else (
        call :show_papier_schere
        %SystemRoot%\System32\timeout.exe /t 2 > nul
        call :niederlage
        set /a Niederlagen+=1
    )
    %SystemRoot%\System32\timeout.exe /t 2 > nul
)

for /f "tokens=1-3 delims=:.," %%a in ("%time%") do (
    set /a "end=(%%a*3600)+(1%%b*60)+1%%c
)
set /a "diff=end-start"

set /a "minutes=diff/60"
set /a "seconds=diff%%60"
set "SZ=%minutes%:%seconds%"
goto menu

:show_stein_stein
echo  _____  _    _           _______     __      _______       _______           _  _______                  
echo ^|  __ \^| ^|  ^| ^|  _   ---'   ____^)    \ \    / / ____^|     (^____   '---   _  ^| ^|/ /_   _^|       
echo ^| ^|  ^| ^| ^|  ^| ^| ^(_^)        ^(_____^)    \ \  / / ^(___      (^_____^)        ^(_^) ^| ' /  ^| ^| 
echo ^| ^|  ^| ^| ^|  ^| ^|  _         ^(_____^)     \ \/ / \___ \     (^_____^)         _  ^|  ^<   ^| ^|     
echo ^| ^|__^| ^| ^|__^| ^| ^(_^)        ^(____^)       \  /  ____^) ^|     (^____^)        (_) ^| . \ _^| ^|_ 
echo ^|_____/ \____/       ---.__^(___^)         \^(_^)^|_____^(_^)     (^___^)__.---      ^|_^|\_\_____^|     
exit /b                      

:show_papier_papier          
echo  _____  _    _            ________         __      _______           ________           _  _______  
echo ^|  __ \^| ^|  ^| ^|  _    ---'    ____^)____    \ \    / / ____^|     ____^(____    '---   _  ^| ^|/ /_   _^| 
echo ^| ^|  ^| ^| ^|  ^| ^| ^(_^)              ______^)    \ \  / / ^(___      ^(______             ^(_^) ^| ' /  ^| ^|   
echo ^| ^|  ^| ^| ^|  ^| ^|  _              _______^)     \ \/ / \___ \     ^(_______             _  ^|  ^<   ^| ^|     
echo ^| ^|__^| ^| ^|__^| ^| ^(_^)            _______^)       \  /  ____^) ^|     ^(_______           ^(_^) ^| . \ _^| ^|_  
echo ^|_____/ \____/        ---.__________^)          \^(_^)^|_____^(_^)      ^(__________.---      ^|_^|\_\_____^|    
exit /b

:show_schere_schere
echo  _____  _    _            _______         __      _______            _______            _  _______  
echo ^|  __ \^| ^|  ^| ^|  _    ---'   ____^)____    \ \    / / ____^|      ____(^____   '---    _  ^| ^|/ /_   _^| 
echo ^| ^|  ^| ^| ^|  ^| ^| ^(_^)             ______^)    \ \  / / ^(___       (^______             ^(_^) ^| ' /  ^| ^|   
echo ^| ^|  ^| ^| ^|  ^| ^|  _           __________^)    \ \/ / \___ \     (^__________           _  ^|  ^<   ^| ^|   
echo ^| ^|__^| ^| ^|__^| ^| ^(_^)         ^(____^)           \  /  ____^) ^|          ^(____^)         ^(_^) ^| . \ _^| ^|_  
echo ^|_____/ \____/        ---.__^(___^)             \^(_^)^|_____^(_^)          ^(___^)__.---       ^|_^|\_\_____^|
exit /b

:show_schere_stein
echo  _____  _    _            _______         __      _______       _______            _  _______  
echo ^|  __ \^| ^|  ^| ^|  _    ---'   ____^)____    \ \    / / ____^|     ^(____   '---    _  ^| ^|/ /_   _^| 
echo ^| ^|  ^| ^| ^|  ^| ^| ^(_^)             ______^)    \ \  / / ^(___      ^(_____^)         ^(_^) ^| ' /  ^| ^|   
echo ^| ^|  ^| ^| ^|  ^| ^|  _           __________^)    \ \/ / \___ \     ^(_____^)           _ ^|  ^<   ^| ^|   
echo ^| ^|__^| ^| ^|__^| ^| ^(_^)         ^(____^)           \  /  ____^) ^|     ^(___^_)         ^(_^) ^| . \ _^| ^|_  
echo ^|_____/ \____/        ---.__^(___^)             \^(_^)^|_____^(_^)     ^(___^)__.---       ^|_^|\_\_____^| 
exit /b

:show_stein_schere
echo  _____  _    _            _______     __      _______            _______            _  _______  
echo ^|  __ \^| ^|  ^| ^|  _    ---'   ____^)    \ \    / / ____^|      ____^(____   '---    _  ^| ^|/ /_   _^| 
echo ^| ^|  ^| ^| ^|  ^| ^| ^(_^)         ^(_____^)    \ \  / / ^(___       ^(______             ^(_^) ^| ' /  ^| ^|   
echo ^| ^|  ^| ^| ^|  ^| ^|  _          ^(_____^)     \ \/ / \___ \     ^(__________            _ ^|  ^<   ^| ^|   
echo ^| ^|__^| ^| ^|__^| ^| ^(_^)         ^(____^)       \  /  ____^) ^|          ^(____^)         ^(_^) ^| . \ _^| ^|_ 
echo ^|_____/ \____/        ---.__^(___^)         \^(_^)^|_____^(_^)          ^(___^)__.-         ^|_^|\_\_____^| 
exit /b

:show_stein_papier
echo  _____  _    _            _______     __      _______             ________         _  _______  
echo ^|  __ \^| ^|  ^| ^|  _    ---'   ____^)    \ \    / / ____^|      _____^(____    '--- _  ^| ^|/ /_   _^| 
echo ^| ^|  ^| ^| ^|  ^| ^| ^(_^)         ^(_____^)    \ \  / / ^(___       ^(______            ^(_^) ^| ' /  ^| ^|    
echo ^| ^|  ^| ^| ^|  ^| ^|  _          ^(_____^)     \ \/ / \___ \     ^(_______             _  ^|  ^<   ^| ^|   
echo ^| ^|__^| ^| ^|__^| ^| ^(_^)         ^(____^)       \  /  ____^) ^|     ^(_______           ^(_^) ^| . \ _^| ^|_  
echo ^|_____/ \____/        ---.__^(___^)         \^(_^)^|_____^(_^)     ^(__________.---       ^|_^|\_\_____^| 
exit /b

:show_papier_stein
echo  _____  _    _            ________         __      _______       _______            _  _______  
echo ^|  __ \^| ^|  ^| ^|  _    ---'    ____^)____    \ \    / / ____^|     ^(____   '---    _  ^| ^|/ /_   _^| 
echo ^| ^|  ^| ^| ^|  ^| ^| ^(_^)              ______^)    \ \  / / ^(___      ^(_____^)         ^(_^) ^| ' /  ^| ^|   
echo ^| ^|  ^| ^| ^|  ^| ^|  _              _______^)     \ \/ / \___ \     ^(_____^)          _  ^|  ^<   ^| ^|   
echo ^| ^|__^| ^| ^|__^| ^| ^(_^)            _______^)       \  /  ____^) ^|     ^(____^)         ^(_^) ^| . \ _^| ^|_  
echo ^|_____/ \____/        ---.__________^)          \^(_^)^|_____^(_^)     ^(___^)__.---       ^|_^|\_\_____^|     
exit /b

:show_papier_schere
echo  _____  _    _             _______         __      _______            _______            _  _______  
echo ^|  __ \^| ^|  ^| ^|  _    ---'    ____^)____    \ \    / / ____^|       ___^(____   '---    _  ^| ^|/ /_   _^| 
echo ^| ^|  ^| ^| ^|  ^| ^| ^(_^)              ______^)    \ \  / / ^(___       ^(______             ^(_^) ^| ' /  ^| ^|   
echo ^| ^|  ^| ^| ^|  ^| ^|  _              _______^)     \ \/ / \___ \     ^(__________           _  ^|  ^<   ^| ^|   
echo ^| ^|__^| ^| ^|__^| ^| ^(_^)            _______^)       \  /  ____^) ^|          ^(____^)         ^(_^) ^| . \ _^| ^|_   
echo ^|_____/ \____/        ---.__________^)          \^(_^)^|_____^(_^)          ^(___^)__.---       ^|_^|\_\_____^|  
exit /b

:show_schere_papier          
echo  _____  _    _            _______         __      _______             ________         _  _______  
echo ^|  __ \^| ^|  ^| ^|  _    ---'   ____^)____    \ \    / / ____^|       ____^(____    '--- _  ^| ^|/ /_   _^| 
echo ^| ^|  ^| ^| ^|  ^| ^| ^(_^)             ______^)    \ \  / / ^(___       ^(______            ^(_^) ^| ' /  ^| ^|   
echo ^| ^|  ^| ^| ^|  ^| ^|  _           __________^)    \ \/ / \___ \     ^(_______             _  ^|  ^<   ^| ^|   
echo ^| ^|__^| ^| ^|__^| ^| ^(_^)         ^(____^)           \  /  ____^) ^|     ^(_______           ^(_^) ^| . \ _^| ^|_    
echo ^|_____/ \____/        ---.__^(___^)             \^(_^)^|_____^(_^)     ^(__________.---       ^|_^|\_\_____^| 
exit /b
:unentschieden
cls
color 6
echo        _    _ _   _ ______ _   _ _______ _____  _____ _    _ _____ ______ _____  ______ _   _ 
echo       ^| ^|  ^| ^| \ ^| ^|  ____^| \ ^| ^|__   __/ ____^|/ ____^| ^|  ^| ^|_   _^|  ____^|  __ \^|  ____^| \ ^| ^|
echo       ^| ^|  ^| ^|  \^| ^| ^|__  ^|  \^| ^|  ^| ^| ^| ^(___ ^| ^|    ^| ^|__^| ^| ^| ^| ^| ^|__  ^| ^|  ^| ^| ^|__  ^|  \^| ^|
echo       ^| ^|  ^| ^| . ^` ^|  __^| ^| . ^` ^|  ^| ^|  \___ \^| ^|    ^|  __  ^| ^| ^| ^|  __^| ^| ^|  ^| ^|  __^| ^| . ^` ^|
echo       ^| ^|__^| ^| ^|\  ^| ^|____^| ^|\  ^|  ^| ^|  ____^) ^| ^|____^| ^|  ^| ^|_^| ^|_^| ^|____^| ^|__^| ^| ^|____^| ^|\  ^|
echo        \____/^|_^| \_^|______^|_^| \_^|  ^|_^| ^|_____/ \_____^|_^|  ^|_^|_____^|______^|_____/^|______^|_^| \_^|
exit /b

:sieg
cls
color a
echo                                             _____ _____ ______ _____ 
echo                                            / ____^|_   _^|  ____/ ____^|
echo                                           ^| ^(___   ^| ^| ^| ^|__ ^| ^|  __ 
echo                                            \___ \  ^| ^| ^|  __^|^| ^| ^|_ ^|
echo                                            ____^) ^|_^| ^|_^| ^|___^| ^|__^| ^|
echo                                           ^|_____/^|_____^|______\_____^|
exit /b

:niederlage
cls
color 4

echo            _   _ _____ ______ _____  ______ _____  _               _____ ______              
echo           ^| \ ^| ^|_   _^  ____^|  __  \^|  ____^|  __ \^| ^|        /\   / ____^|  ____^|            
echo           ^|  \^| ^| ^| ^| ^| ^|__  ^| ^|  ^| ^| ^|__  ^| ^|__^) ^| ^|       /  \ ^| ^|  __^| ^|__                
echo           ^| . ` ^| ^| ^| ^|  __^| ^| ^|  ^| ^|  __^| ^|  _  /^| ^|      / /\ \^| ^| ^|_ ^|  __^|               
echo           ^| ^|\  ^|_^| ^|_^| ^|____^| ^|__^| ^| ^|____^| ^| \ \^| ^|____ / ____ \ ^|__^| ^| ^|____              
echo           ^|_^| \_^|_____^|______^|_____/^|______^|_^|  \_\______/_/    \_\_____^|______^|            

exit /b  

:zeit
set "zeit=%TIME:~0,2%"
call:%zeit%
exit /b

:06
for /f "tokens=1-3 delims=:," %%a in ("%TIME%") do (
    set "stunden=%%a"
    set "minuten=%%b"
    set "sekunden=%%c"
)
echo Willkommen im Spiel!                                                                             , - ~ ~ ~ - ,
echo/                                                                                             , '               ' ,
echo/    _______              _______         ________                                          ,  _                 _  ,
echo ---'   ____^)____     ---'   ____^)    ---'    ____^)____                                    ,  ( )               ( )  ,
echo           ______^)          ^(_____^)              ______^)                                 ,  (_x_)             (_x_)  ,
echo        __________^)         ^(_____^)             _______^)                                 o____j____%stunden%:%minuten%:%sekunden%_____j_____
echo       ^(____^)               ^(____^)             _______^)                                  ,    *  *                   ,
echo ---.__^(___^)         ---.___^(___^)     ---.__________^)                                     ,        *                ,
echo/                                                                                           ,         *    *        ,
echo/                                                                                             ,       *   *       ,
echo/                                                                                               ' - , _ _ _ , - '
exit /b

:07
for /f "tokens=1-3 delims=:," %%a in ("%TIME%") do (
    set "stunden=%%a"
    set "minuten=%%b"
    set "sekunden=%%c"
)
echo Willkommen im Spiel!                                                                              , - ~ ~ ~ - ,
echo/                                                                                              , '               ' ,
echo/    _______              _______         ________                                           ,  _                 _  ,
echo ---'   ____^)____     ---'   ____^)    ---'    ____^)____                                     ,  ( )               ( )  ,
echo           ______^)          ^(_____^)              ______^)                                  o  (_x_)             (_x_)  ,
echo        __________^)         ^(_____^)             _______^)                                  _____j____%stunden%:%minuten%:%sekunden%_____j_____
echo       ^(____^)               ^(____^)             _______^)                                   ,    *  *                   ,
echo ---.__^(___^)         ---.___^(___^)     ---.__________^)                                      ,        *                ,
echo/                                                                                            ,         *    *        ,
echo/                                                                                              ,       *   *       , 
echo/                                                                                                ' - , _ _ _ , - '
exit /b

:08
for /f "tokens=1-3 delims=:," %%a in ("%TIME%") do (
    set "stunden=%%a"
    set "minuten=%%b"
    set "sekunden=%%c"
)
echo Willkommen im Spiel!                                                                             , - ~ ~ ~ - ,
echo/                                                                                             , '               ' ,
echo/    _______              _______         ________                                          ,  _                 _  ,
echo ---'   ____^)____     ---'   ____^)    ---'    ____^)____                                    o  ( )               ( )  ,
echo           ______^)          ^(_____^)              ______^)                                 ,  (_x_)             (_x_)  ,
echo        __________^)         ^(_____^)             _______^)                                 _____j____%stunden%:%minuten%:%sekunden%_____j_____
echo       ^(____^)               ^(____^)             _______^)                                   ,    *  *                   ,
echo ---.__^(___^)         ---.___^(___^)     ---.__________^)                                      ,        *                ,
echo/                                                                                           ,         *    *        ,
echo/                                                                                             ,       *   *       , 
echo/                                                                                               ' - , _ _ _ , - '
exit /b

:09
for /f "tokens=1-3 delims=:," %%a in ("%TIME%") do (
    set "stunden=%%a"
    set "minuten=%%b"
    set "sekunden=%%c"
)
echo Willkommen im Spiel!                                                                             , - ~ ~ ~ - ,
echo/                                                                                             , '               ' ,
echo/    _______              _______         ________                                          o  _                 _  ,
echo ---'   ____^)____     ---'   ____^)    ---'    ____^)____                                    ,  ( )               ( )  ,
echo           ______^)          ^(_____^)              ______^)                                 ,  (_x_)             (_x_)  ,
echo        __________^)         ^(_____^)             _______^)                                 _____j____%stunden%:%minuten%:%sekunden%_____j_____
echo       ^(____^)               ^(____^)             _______^)                                  ,    *  *                   ,
echo ---.__^(___^)         ---.___^(___^)     ---.__________^)                                     ,        *                ,
echo/                                                                                           ,         *    *        ,
echo/                                                                                             ,       *   *       , 
echo/                                                                                               ' - , _ _ _ , - '
exit /b

:10
for /f "tokens=1-3 delims=:," %%a in ("%TIME%") do (
    set "stunden=%%a"
    set "minuten=%%b"
    set "sekunden=%%c"
)
echo Willkommen im Spiel!                                                                              , - ~ ~ ~ - ,
echo/                                                                                              o '               ' ,
echo/    _______              _______         ________                                           ,  _                 _  ,
echo ---'   ____^)____     ---'   ____^)    ---'    ____^)____                                     ,  ( )               ( )  ,
echo           ______^)          ^(_____^)              ______^)                                  ,  (_x_)             (_x_)  ,
echo        __________^)         ^(_____^)             _______^)                                  _____j____%stunden%:%minuten%:%sekunden%_____j_____
echo       ^(____^)               ^(____^)             _______^)                                   ,    *  *                   ,
echo ---.__^(___^)         ---.___^(___^)     ---.__________^)                                      ,        *                ,
echo/                                                                                            ,         *    *        ,
echo/                                                                                              ,       *   *       , 
echo/                                                                                                ' - , _ _ _ , - '
exit /b

:11
for /f "tokens=1-3 delims=:," %%a in ("%TIME%") do (
    set "stunden=%%a"
    set "minuten=%%b"
    set "sekunden=%%c"
)
echo Willkommen im Spiel!                                                                             , - ~ o ~ - ,
echo/                                                                                             , '               ' ,
echo/    _______              _______         ________                                          ,  _                 _  ,
echo ---'   ____^)____     ---'   ____^)    ---'    ____^)____                                    ,  ( )               ( )  ,
echo           ______^)          ^(_____^)              ______^)                                 ,  (_x_)             (_x_)  ,
echo        __________^)         ^(_____^)             _______^)                                 _____j____%stunden%:%minuten%:%sekunden%_____j_____
echo       ^(____^)               ^(____^)             _______^)                                  ,    *  *                   ,
echo ---.__^(___^)         ---.___^(___^)     ---.__________^)                                     ,        *                ,
echo/                                                                                           ,         *    *        ,
echo/                                                                                             ,       *   *       , 
echo/                                                                                               ' - , _ _ _ , - '
exit /b

:12
for /f "tokens=1-3 delims=:," %%a in ("%TIME%") do (
    set "stunden=%%a"
    set "minuten=%%b"
    set "sekunden=%%c"
)
echo Willkommen im Spiel!                                                                            , - ~ o ~ - ,
echo/                                                                                            , '               ' ,
echo/    _______              _______         ________                                         ,  _                 _  ,
echo ---'   ____^)____     ---'   ____^)    ---'    ____^)____                                   ,  ( )               ( )  ,
echo           ______^)          ^(_____^)              ______^)                                 ,  (_x_)             (_x_)  ,
echo        __________^)         ^(_____^)             _______^)                                 _____j____%stunden%:%minuten%:%sekunden%_____j_____
echo       ^(____^)               ^(____^)             _______^)                                  ,    *  *                   ,
echo ---.__^(___^)         ---.___^(___^)     ---.__________^)                                     ,        *                ,
echo/                                                                                          ,         *    *        ,
echo/                                                                                            ,       *   *       , 
echo/                                                                                              ' - , _ _ _ , - '
exit /b

:13
for /f "tokens=1-3 delims=:," %%a in ("%TIME%") do (
    set "stunden=%%a"
    set "minuten=%%b"
    set "sekunden=%%c"
)
echo Willkommen im Spiel!                                                                             , - ~ ~ ~ - o
echo/                                                                                             , '               ' ,
echo/    _______              _______         ________                                          ,  _                 _  ,
echo ---'   ____^)____     ---'   ____^)    ---'    ____^)____                                    ,  ( )               ( )  ,
echo           ______^)          ^(_____^)              ______^)                                 ,  (_x_)             (_x_)  ,
echo        __________^)         ^(_____^)             _______^)                                 _____j____%stunden%:%minuten%:%sekunden%_____j_____
echo       ^(____^)               ^(____^)             _______^)                                  ,    *  *                   ,
echo ---.__^(___^)         ---.___^(___^)     ---.__________^)                                     ,        *                ,
echo/                                                                                           ,         *    *        ,
echo/                                                                                             ,       *   *       , 
echo/                                                                                               ' - , _ _ _ , - '
exit /b

:14
for /f "tokens=1-3 delims=:," %%a in ("%TIME%") do (
    set "stunden=%%a"
    set "minuten=%%b"
    set "sekunden=%%c"
)
echo Willkommen im Spiel!                                                                             , - ~ ~ ~ - ,
echo/                                                                                             , '               ' o
echo/    _______              _______         ________                                          ,  _                 _  ,
echo ---'   ____^)____     ---'   ____^)    ---'    ____^)____                                    ,  ( )               ( )  ,
echo           ______^)          ^(_____^)              ______^)                                 ,  (_x_)             (_x_)  ,
echo        __________^)         ^(_____^)             _______^)                                 _____j____%stunden%:%minuten%:%sekunden%_____j_____
echo       ^(____^)               ^(____^)             _______^)                                  ,    *  *                   ,
echo ---.__^(___^)         ---.___^(___^)     ---.__________^)                                     ,        *                ,
echo/                                                                                           ,         *    *        ,
echo/                                                                                             ,       *   *       , 
echo/                                                                                               ' - , _ _ _ , - '
exit /b

:15
for /f "tokens=1-3 delims=:," %%a in ("%TIME%") do (
    set "stunden=%%a"
    set "minuten=%%b"
    set "sekunden=%%c"
)
echo Willkommen im Spiel!                                                                             , - ~ ~ ~ - ,
echo/                                                                                             , '                ' ,
echo/    _______              _______         ________                                          ,  _                 _  o
echo ---'   ____^)____     ---'   ____^)    ---'    ____^)____                                    ,  ( )               ( )  ,
echo           ______^)          ^(_____^)              ______^)                                 ,  (_x_)             (_x_)  ,
echo        __________^)         ^(_____^)             _______^)                                 _____j____%stunden%:%minuten%:%sekunden%_____j_____
echo       ^(____^)               ^(____^)             _______^)                                  ,    *  *                   ,
echo ---.__^(___^)         ---.___^(___^)     ---.__________^)                                     ,        *                ,
echo/                                                                                           ,         *    *        ,
echo/                                                                                             ,       *   *       , 
echo/                                                                                               ' - , _ _ _ , - '
exit /b

:16
for /f "tokens=1-3 delims=:," %%a in ("%TIME%") do (
    set "stunden=%%a"
    set "minuten=%%b"
    set "sekunden=%%c"
)
echo Willkommen im Spiel!                                                                              , - ~ ~ ~ - ,
echo/                                                                                             ,  '               ' ,
echo/    _______              _______         ________                                          ,  _                 _  ,
echo ---'   ____^)____     ---'   ____^)    ---'    ____^)____                                    ,  ( )               ( )  o
echo           ______^)          ^(_____^)              ______^)                                  ,  (_x_)             (_x_)  ,
echo        __________^)         ^(_____^)             _______^)                                  _____j____%stunden%:%minuten%:%sekunden%_____j_____
echo       ^(____^)               ^(____^)             _______^)                                   ,    *  *                   ,
echo ---.__^(___^)         ---.___^(___^)     ---.__________^)                                      ,        *                ,
echo/                                                                                           ,          *    *       ,
echo/                                                                                             ,        *   *      , 
echo/                                                                                               ' - , _ _ _ , - '
exit /b

:17
for /f "tokens=1-3 delims=:," %%a in ("%TIME%") do (
    set "stunden=%%a"
    set "minuten=%%b"
    set "sekunden=%%c"
)
echo Willkommen im Spiel!                                                                             , - ~ ~ ~ - ,
echo/                                                                                            , '               ' ,
echo/    _______              _______         ________                                         ,  _                 _  ,
echo ---'   ____^)____     ---'   ____^)    ---'    ____^)____                                   ,  ( )               ( )  ,
echo           ______^)          ^(_____^)              ______^)                                 ,  (_x_)             (_x_)  o
echo        __________^)         ^(_____^)             _______^)                                 _____j____%stunden%:%minuten%:%sekunden%_____j_____
echo       ^(____^)               ^(____^)             _______^)                                  ,    *  *                   ,
echo ---.__^(___^)         ---.___^(___^)     ---.__________^)                                     ,        *                ,
echo/                                                                                          ,         *    *        ,
echo/                                                                                            ,       *   *       , 
echo/                                                                                              ' - , _ _ _ , - '
exit /b

:18
for /f "tokens=1-3 delims=:," %%a in ("%TIME%") do (
    set "stunden=%%a"
    set "minuten=%%b"
    set "sekunden=%%c"
)
echo Willkommen im Spiel!                                                                          , - ~ ~ ~ - ,
echo/                                                                                          , '               ' ,
echo/    _______              _______         ________                                       ,  _                 _  ,
echo ---'   ____^)____     ---'   ____^)    ---'    ____^)____                                 ,  ( )               ( )  ,
echo           ______^)          ^(_____^)              ______^)                               ,  (_x_)             (_x_)  ,
echo        __________^)         ^(_____^)             _______^)                               _____j____%stunden%:%minuten%:%sekunden%_____j____o
echo       ^(____^)               ^(____^)             _______^)                                ,    *  *                   ,
echo ---.__^(___^)         ---.___^(___^)     ---.__________^)                                   ,        *                ,
echo/                                                                                        ,         *    *        ,
echo/                                                                                          ,       *   *       , 
echo/                                                                                            ' - , _ _ _ , - '
exit /b

:19
for /f "tokens=1-3 delims=:," %%a in ("%TIME%") do (
    set "stunden=%%a"
    set "minuten=%%b"
    set "sekunden=%%c"
)
echo Willkommen im Spiel!                                                                             , - ~ ~ ~ - ,
echo/                                                                                             , '               ' ,
echo/    _______              _______         ________                                          ,  _                 _  ,
echo ---'   ____^)____     ---'   ____^)    ---'    ____^)____                                    ,  ( )               ( )  ,
echo           ______^)          ^(_____^)              ______^)                                  ,  (_x_)             (_x_)  ,
echo        __________^)         ^(_____^)             _______^)                                  _____j____%stunden%:%minuten%:%sekunden%_____j_____
echo       ^(____^)               ^(____^)             _______^)                                   ,    *  *                   o
echo ---.__^(___^)         ---.___^(___^)     ---.__________^)                                      ,        *                ,
echo/                                                                                           ,         *    *        ,
echo/                                                                                             ,       *   *       , 
echo/                                                                                               ' - , _ _ _ , - '
exit /b

:20
for /f "tokens=1-3 delims=:," %%a in ("%TIME%") do (
    set "stunden=%%a"
    set "minuten=%%b"
    set "sekunden=%%c"
)
echo Willkommen im Spiel!                                                                             , - ~ ~ ~ - ,
echo/                                                                                             , '               ' ,
echo/    _______              _______         ________                                          ,  _                 _  ,
echo ---'   ____^)____     ---'   ____^)    ---'    ____^)____                                    ,  ( )               ( )  ,
echo           ______^)          ^(_____^)              ______^)                                  ,  (_x_)             (_x_)  ,
echo        __________^)         ^(_____^)             _______^)                                  _____j____%stunden%:%minuten%:%sekunden%_____j_____
echo       ^(____^)               ^(____^)             _______^)                                   ,    *  *                   ,
echo ---.__^(___^)         ---.___^(___^)     ---.__________^)                                      ,        *                o
echo/                                                                                           ,         *    *        ,
echo/                                                                                             ,       *   *       , 
echo/                                                                                               ' - , _ _ _ , - '
exit /b

:21
for /f "tokens=1-3 delims=:," %%a in ("%TIME%") do (
    set "stunden=%%a"
    set "minuten=%%b"
    set "sekunden=%%c"
)
echo Willkommen im Spiel!                                                                             , - ~ ~ ~ - ,
echo/                                                                                             , '               ' ,
echo/    _______              _______         ________                                          ,  _                 _  ,
echo ---'   ____^)____     ---'   ____^)    ---'    ____^)____                                    ,  ( )               ( )  ,
echo           ______^)          ^(_____^)              ______^)                                  ,  (_x_)             (_x_)  ,
echo        __________^)         ^(_____^)             _______^)                                  _____j____%stunden%:%minuten%:%sekunden%_____j_____
echo       ^(____^)               ^(____^)             _______^)                                   ,    *  *                   ,
echo ---.__^(___^)         ---.___^(___^)     ---.__________^)                                      ,        *                ,
echo/                                                                                           ,         *    *        o
echo/                                                                                             ,       *   *       , 
echo/                                                                                               ' - , _ _ _ , - '
exit /b

:22
for /f "tokens=1-3 delims=:," %%a in ("%TIME%") do (
    set "stunden=%%a"
    set "minuten=%%b"
    set "sekunden=%%c"
)
echo Willkommen im Spiel!                                                                             , - ~ ~ ~ - ,
echo/                                                                                             , '               ' ,
echo/    _______              _______         ________                                          ,  _                 _  ,
echo ---'   ____^)____     ---'   ____^)    ---'    ____^)____                                    ,  ( )               ( )  ,
echo           ______^)          ^(_____^)              ______^)                                  ,  (_x_)             (_x_)  ,
echo        __________^)         ^(_____^)             _______^)                                  _____j____%stunden%:%minuten%:%sekunden%_____j_____
echo       ^(____^)               ^(____^)             _______^)                                   ,    *  *                   ,
echo ---.__^(___^)         ---.___^(___^)     ---.__________^)                                      ,        *                ,
echo/                                                                                           ,         *    *        ,
echo/                                                                                             ,       *   *       o 
echo/                                                                                               ' - , _ _ _ , - '
exit /b

:23
for /f "tokens=1-3 delims=:," %%a in ("%TIME%") do (
    set "stunden=%%a"
    set "minuten=%%b"
    set "sekunden=%%c"
)
echo Willkommen im Spiel!                                                                             , - ~ ~ ~ - ,
echo/                                                                                             , '               ' ,
echo/     ______              _______         ________                                          ,  _                 _  ,
echo ---'   ____^)____     ---'   ____^)    ---'    ____^)____                                    ,  ( )               ( )  ,
echo           ______^)          ^(_____^)              ______^)                                  ,  (_x_)             (_x_)  ,
echo        __________^)         ^(_____^)             _______^)                                  _____j____%stunden%:%minuten%:%sekunden%_____j_____
echo       ^(____^)               ^(____^)             _______^)                                   ,    *  *                   ,
echo ---.__^(___^)         ---.___^(___^)     ---.__________^)                                      ,        *                ,
echo/                                                                                           ,         *    *        ,
echo/                                                                                             ,       *   *       , 
echo/                                                                                               ' - , _ _ _ o - '
exit /b

:00
for /f "tokens=1-3 delims=:," %%a in ("%TIME%") do (
    set "stunden=%%a"
    set "minuten=%%b"
    set "sekunden=%%c"
)
echo Willkommen im Spiel!                                                                             , - ~ ~ ~ - ,
echo/                                                                                             , '               ' ,
echo/    _______              _______         ________                                          ,  _                 _  ,
echo ---'   ____^)____     ---'   ____^)    ---'    ____^)____                                    ,  ( )               ( )  ,
echo           ______^)          ^(_____^)              ______^)                                  ,  (_x_)             (_x_)  ,
echo        __________^)         ^(_____^)             _______^)                                  _____j____%stunden%:%minuten%:%sekunden%_____j_____
echo       ^(____^)               ^(____^)             _______^)                                   ,    *  *                   ,
echo ---.__^(___^)         ---.___^(___^)     ---.__________^)                                      ,        *                ,
echo/                                                                                           ,         *    *        ,
echo/                                                                                             ,       *   *       , 
echo/                                                                                               ' - , _ o _ , - '
exit /b

:01
for /f "tokens=1-3 delims=:," %%a in ("%TIME%") do (
    set "stunden=%%a"
    set "minuten=%%b"
    set "sekunden=%%c"
)
echo Willkommen im Spiel!                                                                             , - ~ ~ ~ - ,
echo/                                                                                             , '               ' ,
echo/    _______              _______         ________                                          ,  _                 _  ,
echo ---'   ____^)____     ---'   ____^)    ---'    ____^)____                                    ,  ( )               ( )  ,
echo           ______^)          ^(_____^)              ______^)                                  ,  (_x_)             (_x_)  ,
echo        __________^)         ^(_____^)             _______^)                                  _____j____%stunden%:%minuten%:%sekunden%_____j_____
echo       ^(____^)               ^(____^)             _______^)                                   ,    *  *                   ,
echo ---.__^(___^)         ---.___^(___^)     ---.__________^)                                      ,        *                ,
echo/                                                                                           ,         *    *        ,
echo/                                                                                             ,       *   *       , 
echo/                                                                                               ' - o _ _ _ , - '
exit /b

:02
for /f "tokens=1-3 delims=:," %%a in ("%TIME%") do (
    set "stunden=%%a"
    set "minuten=%%b"
    set "sekunden=%%c"
)
echo Willkommen im Spiel!                                                                             , - ~ ~ ~ - ,
echo/                                                                                             , '               ' ,
echo/    _______              _______         ________                                          ,  _                 _  ,
echo ---'   ____^)____     ---'   ____^)    ---'    ____^)____                                    ,  ( )               ( )  ,
echo           ______^)          ^(_____^)              ______^)                                  ,  (_x_)             (_x_)  ,
echo        __________^)         ^(_____^)             _______^)                                  _____j____%stunden%:%minuten%:%sekunden%_____j_____
echo       ^(____^)               ^(____^)             _______^)                                   ,    *  *                   ,
echo ---.__^(___^)         ---.___^(___^)     ---.__________^)                                      ,        *                ,
echo/                                                                                           ,         *    *        ,
echo/                                                                                             o       *   *       , 
echo/                                                                                               ' - , _ _ _ , - '
exit /b

:03
for /f "tokens=1-3 delims=:," %%a in ("%TIME%") do (
    set "stunden=%%a"
    set "minuten=%%b"
    set "sekunden=%%c"
)
echo Willkommen im Spiel!                                                                             , - ~ ~ ~ - ,
echo/                                                                                             , '               ' ,
echo/    _______              _______         ________                                          ,  _                 _  ,
echo ---'   ____^)____     ---'   ____^)    ---'    ____^)____                                    ,  ( )               ( )  ,
echo           ______^)          ^(_____^)              ______^)                                  ,  (_x_)             (_x_)  ,
echo        __________^)         ^(_____^)             _______^)                                  _____j____%stunden%:%minuten%:%sekunden%_____j_____
echo       ^(____^)               ^(____^)             _______^)                                   ,    *  *                   ,
echo ---.__^(___^)         ---.___^(___^)     ---.__________^)                                      ,        *                ,
echo/                                                                                           o         *    *        ,
echo/                                                                                             ,       *   *       , 
echo/                                                                                               ' - , _ _ _ , - '
exit /b

:04
for /f "tokens=1-3 delims=:," %%a in ("%TIME%") do (
    set "stunden=%%a"
    set "minuten=%%b"
    set "sekunden=%%c"
)
echo Willkommen im Spiel!                                                                             , - ~ ~ ~ - ,
echo/                                                                                             , '               ' ,
echo/    _______              _______         ________                                          ,  _                 _  ,
echo ---'   ____^)____     ---'   ____^)    ---'    ____^)____                                    ,  ( )               ( )  ,
echo           ______^)          ^(_____^)              ______^)                                  ,  (_x_)             (_x_)  ,
echo        __________^)         ^(_____^)             _______^)                                  _____j____%stunden%:%minuten%:%sekunden%_____j_____
echo       ^(____^)               ^(____^)             _______^)                                   ,    *  *                   ,
echo ---.__^(___^)         ---.___^(___^)     ---.__________^)                                      o        *                ,
echo/                                                                                           ,         *    *        ,
echo/                                                                                             ,       *   *       , 
echo/                                                                                               ' - , _ _ _ , - '
exit /b

:05
for /f "tokens=1-3 delims=:," %%a in ("%TIME%") do (
    set "stunden=%%a"
    set "minuten=%%b"
    set "sekunden=%%c"
)
echo Willkommen im Spiel!                                                                             , - ~ ~ ~ - ,
echo/                                                                                             , '               ' ,
echo/    _______              _______         ________                                          ,  _                 _  ,
echo ---'   ____^)____     ---'   ____^)    ---'    ____^)____                                    ,  ( )               ( )  ,
echo           ______^)          ^(_____^)              ______^)                                  ,  (_x_)             (_x_)  ,
echo        __________^)         ^(_____^)             _______^)                                  _____j____%stunden%:%minuten%:%sekunden%_____j_____
echo       ^(____^)               ^(____^)             _______^)                                   o    *  *                   ,
echo ---.__^(___^)         ---.___^(___^)     ---.__________^)                                      ,        *                ,
echo/                                                                                           ,         *    *        ,
echo/                                                                                             ,       *   *       , 
echo/                                                                                               ' - , _ _ _ , - '
exit /b
 