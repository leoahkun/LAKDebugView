LAKDebugger
==============

This project contains a number of tricks you can use in your project.

LAKDebug/LAKDebug.h 
This overrides the standard NSLog. This is useful when creating app store builds to disable or NSLog outputs. To toggle, simply define DEBUG_ON. Remember to include this in your .pch file to work throughout your project.

LAKDebug/LAKDebugUtils.m
This class gets various memory usage info out which is I use in my NSLogs. It is useful for profiling to count your allocs and releases for legacy projects.

LAKDebugView/LAKApplication
Here we override the application to pickup global touch events. I use this to toggle the debugger when the status bar is tapped. For this to work, you must load it in the main.m.

LAKDebugView/LAKLogView.m
This is the actual log view. It extends LAKMovableView so that you can keep the log screen on your device wherever you want regardless of UI. See LAKMovableView project for more info.

LAKDebugView/LAKLogViewHandler.m
This is a static method which handles the logging. To get handle to an instance of LAKLogView, use the sharedInstance method. 

If you want to use this in your project, drag the LAK folder into your project.

In your .pch file include 
	#import "LAKDebug.h"
	
In your main.m file add @"LAKApplication"
	return UIApplicationMain(argc, argv, @"LAKApplication", NSStringFromClass([AppDelegate class]));