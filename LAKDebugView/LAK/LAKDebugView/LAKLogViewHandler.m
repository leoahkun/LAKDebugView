//
//  LAKLogViewHandler.m
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

#import "LAKLogViewHandler.h"
#import "LAKLogView.h"

static LAKLogView *logView;

@implementation LAKLogViewHandler

+(LAKLogView*) sharedInstance
{	
	if (!logView) {
		CGFloat debugStartHeight = 20;
		if ([UIApplication sharedApplication].statusBarHidden){
			debugStartHeight = 0;
		}
		logView = [[LAKLogView alloc] initWithFrame:CGRectMake(0, debugStartHeight, 200, 200)];
	}
	return logView;
}

+(LAKLogView*) sharedLogView
{
	return logView;
}

+(void) addLog:(NSString*) log
{
	if (!logView) {
		CGFloat debugStartHeight = 20;
		if ([UIApplication sharedApplication].statusBarHidden){
			debugStartHeight = 0;
		}
		logView = [[LAKLogView alloc] initWithFrame:CGRectMake(0, debugStartHeight, 200, 200)];
	}
	[logView addLog:log];
}
@end
