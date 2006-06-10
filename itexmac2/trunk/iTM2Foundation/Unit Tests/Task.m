//
//  Task.m
//  iTM2Foundation
//
//  Created by Coder on 02/02/06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import "Task.h"
#import "iTM2TaskKit.h"


@implementation Task
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  testTaskController
- (void) testTaskController;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 06/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
	iTM2_INIT_POOL;
//iTM2_START;
	[SUD registerDefaults:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:1] forKey:@"iTM2DebugEnabled"]];
	NSString * path = @"/bin/ls";
	iTM2TaskWrapper * TW = [[[iTM2TaskWrapper alloc] init] autorelease];
	[TW setLaunchPath:path];
	[TW addArgument:@"-alR"];
	[TW addArgument:@"/Applications/TextEdit.app"];
	iTM2TaskController * TC = [[[iTM2TaskController allocWithZone:[self zone]] init] autorelease];
	[TC addTaskWrapper:TW];
	[TC setMute:NO];
	[TC start];
	[TC waitUntilExit];
//iTM2_LOG(@"[TC output]:\n%@", [TC output]);
//iTM2_END;
	iTM2_RELEASE_POOL;
printf("the task controller should be dealloced now\n");
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  testTaskController1
- (void) testTaskController1;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 06/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
	iTM2_INIT_POOL;
//iTM2_START;
	[SUD registerDefaults:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:1] forKey:@"iTM2DebugEnabled"]];
	NSString * path = @"/bin/ls";
	iTM2TaskWrapper * TW = [[[iTM2TaskWrapper alloc] init] autorelease];
	[TW setLaunchPath:path];
	[TW addArgument:@"-R"];
	[TW addArgument:@"/Applications/TextEdit.app"];
	iTM2TaskController * TC = [[[iTM2TaskController allocWithZone:[self zone]] init] autorelease];
	[TC addTaskWrapper:TW];
	[TC setMute:YES];
	[TC setDeaf:YES];
	[TC start];
	[TC becomeStandalone];
	[TC retain];// this is for testing
	iTM2_RELEASE_POOL;
	int index = 10;
	while(index--)
	{
		if([[TC currentTask] isRunning])
		{
			[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1]];
		}
		else
		{
			NSAssert1([TC retainCount] == 1, @"THE RETAIN COUNT SHOULD BE 1 INSTEAD OF %i", [TC retainCount]);
			[TC release];
			TC = nil;
			break;
		}
	}
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  timed:
- (void) timed: (NSTimer *) aTimer;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 06/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSLog(@"I am the one");
//iTM2_END;
	return;
}
@end

