@echo off

setlocal enabledelayedexpansion

for /f "tokens=4-7 delims=[.] " %%i in ('ver') do (
	if %i==Version (
		set winver=%%j.%%k
	) else (
		set winver=%%i.%%j
	)
)

if "%winver:~0,1%" == "5" (
	set "saveFile=%homepath%\Local Settings\Ronin\save.ini"
) else (
	set "saveFile=%localappdata%\Ronin\save.ini"
)


set levels=basic_tutorial,advanced_tutorial,samurai_showdown,testing_facility,skyscraper,disco,neurotoxins_lab,underground_base,rooftop_escape,military_outpost,wartime_research,raid,comm_station,missile_factory,finale

set ng=false
set currentLevel=1
set skillPoints=0

:menu
cls

echo.
echo.:::: RONIN Save Builder
echo.::
echo.:: 1	Unlock NG+	(%ng%)
echo.:: 2	Current Level	(%currentLevel%/15)
echo.:: 3	Skill Points	(%skillPoints%/15)
echo.::
echo.:: 4	Max
echo.::
echo.:: 5	BUILD SAVE
echo.::
echo.:: 0	Exit
echo.::

choice /c 123450 /n /m ":::: "


if %errorlevel% == 1 call :toggle_ng
if %errorlevel% == 2 call :inc_var currentLevel
if %errorlevel% == 3 call :inc_var skillPoints
if %errorlevel% == 4 call :max
if %errorlevel% == 5 call :build
if %errorlevel% == 6 exit


goto:menu


:toggle_ng

if %ng% == false (
	set ng=true
) else (
	set ng=false
)

goto:eof


:inc_var

if !%1! == 15 (
	set %1=1
) else (
	set /a %1+=1
)

goto:eof


:max

set currentLevel=15
set skillPoints=15

goto:eof


:build

if exist "%saveFile%" del /f /q %saveFile%

if %ng% == true (
	call :output [persistent]
	call :output new_game_plus_unlocked="1.000000"
)

if not %skillPoints% == 0 (
	if %ng% == false (
		call :output [misc]
		call :output skill_points="%skillPoints%.000000"
	)
)

call :build_levels

echo.
echo.Save built successfully!

pause > nul

goto:eof


:build_levels

set t_level=%currentLevel%
set t_skill=%skillPoints%

for %%a in ( %levels% ) do ( 
	if not !t_level! == 0 (
		call :output [%%a]
		call :output completed="1.000000"
		if not !t_skill! == 0 (
			if %ng% == false (
				call :output skill_point_earned="1.000000"
				set /a t_skill-=1
			)
		)
		set /a t_level-=1
	)
)

goto:eof



:output

echo.%*>>%saveFile%

goto:eof