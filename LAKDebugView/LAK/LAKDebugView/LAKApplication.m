//
//  LAKApplication.m
//  LAKDebugView
//
//  Created by Leonard Ah Kun on 2013/04/14.
//  Copyright (c) 2013 Leonard Ah Kun. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import "LAKApplication.h"
#import "AppDelegate.h"
#import "LAKLogView.h"
#import "LAKLogViewHandler.h"

@implementation LAKApplication

- (void)sendEvent:(UIEvent *)event
{
    [super sendEvent: event];
    
    // Only want to reset the timer on a Began touch or an Ended touch, to reduce the number of timer resets.
    NSSet *allTouches = [event allTouches];
    if ([allTouches count] > 0)
    {
        // allTouches count only ever seems to be 1, so anyObject works here.
        UITouchPhase phase = ((UITouch *) [allTouches anyObject]).phase;
		UITouch *touch = (UITouch *) [allTouches anyObject];
        
		if (phase == UITouchPhaseEnded)
		{
			NSString *classString = NSStringFromClass([touch.view class]);
			self.touchedObject = touch.view;
			if ([classString isEqualToString:@"UIStatusBarForegroundView"]) {
				[self toggleDebugView];
			}
		}
    }
}

-(void) toggleDebugView
{
	UIWindow *window = [[UIApplication sharedApplication] delegate].window;
	LAKLogView *logView = [LAKLogViewHandler sharedInstance];
	if (!logView.superview) {
		[window addSubview:logView];
	} else {
		[logView removeFromSuperview];
	}
}

@end
