//
//  LAKDebugUtils.m
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


#import "LAKDebugUtils.h"
#import "AppDelegate.h"
#import "LAKLogView.h"
#import "LAKLogViewHandler.h"
#import "mach/mach.h" 

@implementation LAKDebugUtils

vm_size_t getUsedMemory(void) {
    struct task_basic_info info;
    mach_msg_type_number_t size = sizeof(info);
    kern_return_t kerr = task_info(mach_task_self(), TASK_BASIC_INFO, (task_info_t)&info, &size);
    return (kerr == KERN_SUCCESS) ? info.resident_size : 0; // size in bytes
}

vm_size_t getFreeMemory(void) {
    mach_port_t host_port = mach_host_self();
    mach_msg_type_number_t host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t pagesize;
    vm_statistics_data_t vm_stat;
	
    host_page_size(host_port, &pagesize);
    (void) host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size);
    return vm_stat.free_count * pagesize;
}

+(NSString*) logMemUsage
{
    // compute memory usage and log if different by >= 100k
    static long prevMemUsage = 0;
    long curMemUsage = getUsedMemory();
    long memUsageDiff = curMemUsage - prevMemUsage;
	
	// if (memUsageDiff > 100000 || memUsageDiff < -100000) {
	prevMemUsage = curMemUsage;
	return [NSString stringWithFormat:@"U:%7.1f (%+5.0f), F:%7.1f", curMemUsage/1000.0f, memUsageDiff/1000.0f, getFreeMemory()/1000.0f];
	// }
	//return @"";
}

+ (NSInteger)currentThreadNumber
{
    NSString    *threadString;
    NSRange      numRange;
    NSUInteger   numLength;
	
    threadString = [NSString stringWithFormat:@"%@", [NSThread currentThread]];
	
    numRange = [threadString rangeOfString:@"num = "];
	
    numLength = [threadString length] - numRange.location - numRange.length;
    numRange.location = numRange.location + numRange.length;
    numRange.length   = numLength - 1;
	
    threadString = [threadString substringWithRange:numRange];
    return [threadString integerValue];
} /* end currentThreadNumber */

+ (NSString*) logThread
{
	NSString *threadName = [[NSThread currentThread] name];
	if(threadName == nil)
    {
		return [NSString stringWithFormat:@"Thread %i",[LAKDebugUtils currentThreadNumber]];
	}
	return threadName;
}

+(void) log:(NSString*) logString
{
	[LAKLogViewHandler addLog:logString];
}



@end
