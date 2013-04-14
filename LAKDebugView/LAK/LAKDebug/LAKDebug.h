//
//  LAKDebug.h
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


#import <Foundation/Foundation.h>
#import "LAKDebugUtils.h"

#pragma mark -
#pragma mark Define debug settings

// define DEBUG_ON to turn on debug output
#define DEBUG_ON
// define DEBUG_STYLE_VERBOSE to turn on verbose debugging (only if DEBUG_ON is defined)
#define DEBUG_STYLE_VERBOSE

#pragma mark -
#pragma mark Debug logging macros

#ifdef DEBUG_ON
// debug logging turned on

#ifdef DEBUG_STYLE_VERBOSE
#pragma mark Debug output on (verbose)
// debug logging style verbose
#define NSLog( s, ... ) NSLog( @"<%@ %@ %s> %@", [LAKDebugUtils logMemUsage],[LAKDebugUtils logThread], __PRETTY_FUNCTION__, [NSString stringWithFormat:(s), ##__VA_ARGS__] );[LAKDebugUtils log:[NSString stringWithFormat:(s), ##__VA_ARGS__]]

#else
#pragma mark Debug output on (normal)
// debug logging style normal

#define NSLog( s, ... ) NSLog( @"%@", [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#endif

#else
#pragma mark Debug output off
// debug logging turned off
#define NSLog( s, ...)

#endif
