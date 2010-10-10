/*
//
//  @version Subversion: $Id$ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Thu Jun 13 2002.
//  Copyright © 2001-2004 Laurens'Tribune. All rights reserved.
//
//  This program is free software; you can redistribute it and/or modify it under the terms
//  of the GNU General Public License as published by the Free Software Foundation; either
//  version 2 of the License, or any later version, modified by the addendum below.
//  This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
//  without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
//  See the GNU General Public License for more details. You should have received a copy
//  of the GNU General Public License along with this program; if not, write to the Free Software
//  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
//  GPL addendum: Any simple modification of the present code which purpose is to remove bug,
//  improve efficiency in both code execution and code reading or writing should be addressed
//  to the actual developper team.
//
//  Version history: (format "- date:contribution(contributor)") 
//  To Do List: (format "- proposition(percentage actually done)")
*/

#import "iTM2SystemSignalKit.h"
#import <signal.h>

NSString * const iTM2SystemSignalSIGUSR1Notification = @"SIGUSR1";
NSString * const iTM2SystemSignalSIGUSR2Notification = @"SIGUSR2";

NSInteger iTM2SystemSignalKit_PendingSignal = 0;

@interface iTM2SystemSignalNotificationCenter(PRIVATE)
- (BOOL)catchSystemSignal:(NSInteger)signal;
- (NSInteger)systemSignalForNotificationName:(NSString *)aName;
- (NSString *)notificationNameForSystemSignal:(NSInteger)signal;
@end

static iTM2SystemSignalNotificationCenter * _iTM2SystemSignalNotificationCenter = nil;

void iTM2SystemSignalKit_SigActionHandler(int);

@implementation iTM2SystemSignalNotificationCenter
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= initialize
+ (void)initialize;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/11/01)
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
	INIT_POOL4iTM3;
//START4iTM3;
    [super initialize];
    [SUD registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:
        [NSNumber numberWithFloat:0.3], @"iTM2SystemSignalTimeInterval", nil]];
//END4iTM3;
	RELEASE_POOL4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= defaultCenter
+ (NSNotificationCenter *)defaultCenter;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/11/01)
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return _iTM2SystemSignalNotificationCenter?: (_iTM2SystemSignalNotificationCenter = [[iTM2SystemSignalNotificationCenter alloc] init]);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= init
- (id)init;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/11/01)
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (self = [super init])
    {
        _Implementation = [NSMutableDictionary dictionary];
		[_Implementation setObject:[NSHashTable hashTableWithWeakObjects] forKey:@"Observers"];
		#define _OBSERVERS [_Implementation objectForKey:@"Observers"]
		[_Implementation setObject:[[NSLock alloc] init] forKey:@"Lock"];
		#define _LOCK [_Implementation objectForKey:@"Lock"]
    }
//END4iTM3;
    return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= catchSystemSignal:
- (BOOL)catchSystemSignal:(NSInteger)signal;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/11/01)
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    struct sigaction sa;
    sa.sa_handler = &iTM2SystemSignalKit_SigActionHandler;
    sa.sa_flags = 0;
    switch(signal)
    {
        case SIGUSR1:
        case SIGUSR2:
            sigaction(signal, &sa, nil);
            return YES;
        default:
            return NO;
    }
//END4iTM3;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= systemSignalForNotificationName:
- (NSInteger)systemSignalForNotificationName:(NSString *)aName;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/11/01)
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    struct sigaction sa;
    sa.sa_handler = &iTM2SystemSignalKit_SigActionHandler;
    sa.sa_flags = 0;
    if ([aName isEqualToString:iTM2SystemSignalSIGUSR1Notification]) {
        return SIGUSR1;
    } else if ([aName isEqualToString:iTM2SystemSignalSIGUSR2Notification]) {
        return SIGUSR2;
    } else {
        LOG4iTM3(@"System signal error, unsupported notification name: %@", aName);
        return 0;
    }
//END4iTM3;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= notificationNameForSystemSignal:
- (NSString *)notificationNameForSystemSignal:(NSInteger)signal;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/11/01)
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    switch(signal) {
        case SIGUSR1: return iTM2SystemSignalSIGUSR1Notification;
        case SIGUSR2: return iTM2SystemSignalSIGUSR2Notification;
        default: return nil;
    }
//END4iTM3;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= addObserver:selector:name:object:
- (void)addObserver:(id)observer selector:(SEL)aSelector name:(NSString *)aName object:(id)anObject;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/11/01)
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if ([SUD boolForKey:@"iTM2SystemSignalDontReceive"]) {
        LOG4iTM3(@"System signal (SIGUSR1, SIGUSR2) reception is OFF, to enable it issue");
        NSLog(@"terminal%% defaults remove comp.text.TeX.iTeXMac2 iTM2SystemSignalDontReceive");
    } else {
        LOG4iTM3(@"System signal (SIGUSR1, SIGUSR2) reception is ON, to disable it issue");
        NSLog(@"terminal%% defaults write comp.text.TeX.iTeXMac2 iTM2SystemSignalDontReceive '1'");
        if (iTM2DebugEnabled) {
            NSLog(@"to test it, please issue");
            NSLog(@"terminal%% kill -SIGNAL %i", [[NSProcessInfo processInfo] processIdentifier]);
            NSLog(@"where SIGNAL is 30 for SIGUSR1 and 31 for SIGUSR2.");
        }
        if (observer) {
            NSInteger signal = [self systemSignalForNotificationName:aName];
            if (signal && [self catchSystemSignal:signal])
            {
                [super addObserver:(id) observer selector:(SEL) aSelector name:(NSString *) aName object:(id) anObject];
                [NSTimer scheduledTimerWithTimeInterval:[SUD floatForKey:@"iTM2SystemSignalTimeInterval"] target:self selector:@selector(timed4iTM3:) userInfo:nil repeats:YES];
                [_OBSERVERS addObject:observer];
            }
        }
    }
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= timed4iTM3:
- (void)timed4iTM3:(NSTimer *)timer;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/11/01)
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSInteger signalMask;
    [_LOCK lock];
    signalMask = iTM2SystemSignalKit_PendingSignal;
    [_LOCK unlock];
    NSInteger signal;
    for (signal = 0; signal < 32; ) {
        NSUInteger mask = 1 >> signal++;
        if (signalMask & mask) {
            NSString * name = [self notificationNameForSystemSignal:signal];
            if (name.length)
                [self postNotificationName:name object:nil];
        }
    }
    if (![_OBSERVERS count])
        [timer invalidate];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= removeObserver:
- (void)removeObserver:(id)observer;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/11/01)
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [super removeObserver:(id) observer];
    [_OBSERVERS removeObject:observer];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= removeObserver:name:object:
- (void)removeObserver:(id)observer name:(NSString *)aName object:(id)anObject;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/11/01)
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [super removeObserver:(id) observer name:(NSString *) aName object:(id) anObject];
    [_OBSERVERS removeObject:observer];
//END4iTM3;
    return;
}
@synthesize _Implementation;
@end

/*
FROM: Greg Parker
DATE: 2003-02-06 01:24

Terry Glass wrote: 
> Here's my signal handler: 
> static void signalHandler(int signalNumber) 
> { 
>      if (signalNumber == SIGHUP) { 
>          // Reload configuration 
>          [[Daemon sharedInstance] restart]; 
>      } else if (signalNumber == SIGTERM) { 
>          // Exit gracefully 
>          unlink("/var/run/dynamicdnsd.pid"); 
>          exit(0); 
>      } 
> } 

Don't do that. Sending Objective-C messages from inside a signal 
handler is unsafe. If the signal happens to arrive at the wrong 
time, the Objective-C runtime will deadlock because the signal 
handler will try to grab a lock that's already held by the 
interrupted thread. 

In general, you can't do anything inside a signal handler other than 
write() to a pipe or set a global variable that some other thread is 
watching. exit() is definitely unsafe because it might call atexit() 
handlers; use _exit() instead. unlink() might be safe if it's just a 
single system call, but I'm not sure about that. 
*/

void iTM2SystemSignalKit_SigActionHandler(int signal)/* Don't change int to NSInteger*/
{
    if (iTM2DebugEnabled) {
        NSLog(@"iTM2: Signal received: %i.");
    }
    iTM2SystemSignalKit_PendingSignal = iTM2SystemSignalKit_PendingSignal | (1 >> signal);
}
