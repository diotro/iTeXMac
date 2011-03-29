/*
  iTM2TaskKit.m
  iTeXMac2

  Created by jlaurens AT users DOT sourceforge DOT net on Mon Jun 02 2003.
  Copyright © 2003 Laurens'Tribune. All rights reserved.

  This program is free software; you can redistribute it and/or modify it under the terms
  of the GNU General Public License as published by the Free Software Foundation; either
  version 2 of the License, or any later version modified by the addendum below.
  This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
  without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
  See the GNU General Public License for more details. You should have received a copy
  of the GNU General Public License along with this program; if not, write to the Free Software
  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
  GPL addendum: Any simple modification of the present code which purpose is to remove bug,
  improve efficiency in both code execution and code reading or writing should be addressed
  to the actual developper team.
*/

#import "iTM2TaskKit.h"
#import "iTM2PathUtilities.h"
#import "iTM2InstallationKit.h"
#import "iTM2Implementation.h"
#import "iTM2DocumentKit.h"
#import "iTM2WindowKit.h"
#import "iTM2ContextKit.h"
#import "iTM2BundleKit.h"
#import "iTM2DistributedObjectKit.h"
#import "iTM2CursorKit.h"
#import "iTM2MacroKit.h"
#import "iTM2Invocation.h"
#import "iTM2FileManagerKit.h"
#import "ICURegex.h"

#import	<sys/fcntl.h>
#import	<sys/stat.h>
#import <sys/file.h>
#import <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>

NSString * const iTM2TaskControllerIsDeafKey = @"iTM2TaskControllerIsDeaf";
NSString * const iTM2TaskControllerIsMuteKey = @"iTM2TaskControllerIsMute";
NSString * const iTM2TaskControllerIsBlindKey = @"iTM2TaskControllerIsBlind";

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2TaskInspector
/*"This object manages the UI of the task controller."*/
@interface iTM2TaskInspector()
@property (assign, readwrite) NSTextView * errorView;
@property (assign, readwrite) NSTextView * outputView;
@end

@implementation iTM2TaskInspector
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= windowFrameIdentifier4iTM3
- (NSString *)windowFrameIdentifier4iTM3;
/*"Subclasses should override this method. The default implementation returns a 0 length string, and deactivates the 'register current frame' process.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri May 21 07:52:07 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return @"Task Window";
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= windowPositionShouldBeObserved4iTM3
- (BOOL)windowPositionShouldBeObserved4iTM3;
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri May 21 07:52:07 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  cleanLog:
- (void)cleanLog:(id)sender;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/11/01)
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self.outputView setString:@""];
    [self.errorView setString:@""];
    return;
}
#pragma mark =-=-=-=-=-=-  OUTPUT
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  outputView
- (NSTextView *)outputView;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/11/01)
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (!iVarOutputView4iTM3) {
        [self window];
    }
    return iVarOutputView4iTM3;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setOutputView:
- (void)setOutputView:(NSTextView *)argument;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/11/01)
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    ASSERT_INCONSISTENCY4iTM3((!argument || [argument isKindOfClass:[NSTextView class]]));
    if (iVarOutputView4iTM3 != argument) {
        iVarOutputView4iTM3.delegate = nil;
        iVarOutputView4iTM3 = argument;
        iVarOutputView4iTM3.delegate = self;// used for clickedAtIndex:
        [iVarOutputView4iTM3 setTypingAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
            [NSFont userFixedPitchFontOfSize:[NSFont systemFontSize]], NSFontAttributeName, nil]];
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  logOutput:
- (void)logOutput:(NSString *)argument;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/11/01)
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSTextView * TV = self.outputView;
	NSScroller * S = [TV.enclosingScrollView verticalScroller];
	CGFloat old = S.floatValue;
    NSTextStorage * TS = [TV textStorage];
    [TS beginEditing];
    [[TS mutableString] appendString:argument];
    [TS endEditing];
	if (old>=1.0) {
		[TV scrollRangeToVisible:iTM3MakeRange(TS.length, ZER0)];
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  outputDidTerminate
- (void)outputDidTerminate;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/11/01)
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self logOutput:@"\niTM2:task terminated"];
//END4iTM3;
    return;
}
#pragma mark =-=-=-=-=-=-  CUSTOM
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  logCustom:
- (void)logCustom:(NSString *)argument;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/11/01)
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[self logOutput:argument];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  customDidTerminate
- (void)customDidTerminate;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/11/01)
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return;
}
#pragma mark =-=-=-=-=-=-  ERROR
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  errorView
- (NSTextView *)errorView;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/11/01)
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (!iVarErrorView4iTM3) {
        [self window];
    }
    return iVarErrorView4iTM3;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setErrorView:
- (void)setErrorView:(NSTextView *)argument;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/11/01)
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    ASSERT_INCONSISTENCY4iTM3(!argument || [argument isKindOfClass:[NSTextView class]]);
    if (iVarErrorView4iTM3 != argument) {
        iVarErrorView4iTM3.delegate = nil;
        iVarErrorView4iTM3 = argument;
        iVarErrorView4iTM3.delegate = self;// used for clickedAtIndex:
        [iVarErrorView4iTM3 setTypingAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
            [NSFont userFixedPitchFontOfSize:NSFont.systemFontSize], NSFontAttributeName, nil]];
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  logError:
- (void)logError:(NSString *)argument;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/11/01)
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSRange R;
    NSTextStorage * TS = self.errorView.textStorage;
    R.location = TS.length;
    [TS beginEditing];
    [[TS mutableString] appendString:argument];
    R.length = TS.length - R.location;
    [TS addAttribute:NSForegroundColorAttributeName value:[NSColor redColor] range:R];
    [TS endEditing];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  errorDidTerminate
- (void)errorDidTerminate;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/11/01)
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return;
}
#pragma mark =-=-=-=-=-  TASK
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= taskWillLaunch
- (void)taskWillLaunch;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/11/01)
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= taskDidTerminate
- (void)taskDidTerminate;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/11/01)
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//    [self logCustom:@"\n<iTM2Comment>Task terminated</iTM2Comment>"];// to be changed, some widget should change
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= execute:
- (void)execute:(NSString *)aCommand;
/*"Description Forthcoming. Rough input, no verification.
Version History: jlaurens AT users DOT sourceforge DOT net (09/11/01)
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[self.taskController execute:aCommand];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= cancel:
- (void)cancel:(NSString *)cancel;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/11/01)
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[(iTM2TaskController *)self.taskController stop];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initImplementation:
- (void)initImplementation;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/11/01)
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [super initImplementation];
    [self cleanLog:self];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  logInput:
- (void)logInput:(NSString *)argument;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[self logOutput:argument];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  updateOutputAndError:
- (void)updateOutputAndError:(id)irrelevant;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/11/01)
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setTaskController:
- (void)setTaskController:(iTM2TaskController *)argument;
/*"Description Forthcoming. The task controller is the owner.
 Version history: jlaurens AT users DOT sourceforge DOT net
 - for 1.3: Mon Jun 02 2003
 To Do List:
 "*/
{DIAGNOSTIC4iTM3;
	//START4iTM3;
    ASSERT_INCONSISTENCY4iTM3(!argument || [argument isKindOfClass:[iTM2TaskController class]]);
    if (![argument isEqual:iVarTaskController4iTM3]) {
        [iVarTaskController4iTM3 removeInspector:self];
        iVarTaskController4iTM3 = argument;
        [iVarTaskController4iTM3 addInspector:self];
    }
    return;
}
@synthesize taskController = iVarTaskController4iTM3;
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2TaskWindow


@implementation iTM2TaskWindow
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2TaskController

/*
NSString * const iTM3ServerConversationIDKey = @"ConversationID";
NSString * const iTM3ServerCommentsKey = @"Comments";
NSString * const iTM3ServerWarningsKey = @"Warnings";
NSString * const iTM3ServerErrorsKey = @"Errors";
NSString * const iTM3ServerComwarnerNotification = @"iTM3ServerComwarnerNotification";
*/
@interface iTM2TaskController()
@property (assign,readwrite) NSMutableArray * wrappers;
@property (assign,readwrite) NSString * conversation;
@end
@implementation iTM2TaskController
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  init
- (id)init;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if ((self = [super init])) {
        self.wrappers = [NSMutableArray array];
        self.conversation = [[NSProcessInfo processInfo] globallyUniqueString];
        self.inspectors = [NSHashTable hashTableWithWeakObjects];
        _FHGC = [NSMutableArray array];
        _NGC = [NSMutableArray array];
        self.customReadFileHandle = nil;
    }
    return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  isDeaf
- (BOOL)isDeaf;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [self context4iTM3BoolForKey:iTM2TaskControllerIsDeafKey domain:iTM2ContextAllDomainsMask];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setDeaf:
- (void)setDeaf:(BOOL)yorn;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self takeContext4iTM3Bool:yorn forKey:iTM2TaskControllerIsDeafKey domain:iTM2ContextAllDomainsMask];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  isMute
- (BOOL)isMute;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [self context4iTM3BoolForKey:iTM2TaskControllerIsMuteKey domain:iTM2ContextAllDomainsMask];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setMute:
- (void)setMute:(BOOL)yorn;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self takeContext4iTM3Bool:yorn forKey:iTM2TaskControllerIsMuteKey domain:iTM2ContextAllDomainsMask];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  isBlind
- (BOOL)isBlind;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [self context4iTM3BoolForKey:iTM2TaskControllerIsBlindKey domain:iTM2ContextAllDomainsMask];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setBlind:
- (void)setBlind:(BOOL)yorn;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self takeContext4iTM3Bool:yorn forKey:iTM2TaskControllerIsBlindKey domain:iTM2ContextAllDomainsMask];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  addInspector:
- (void)addInspector:(id <iTM2TaskInspector>)argument;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//NSLog(@"argument: %@", argument);
    if (argument) {
        ASSERT_INCONSISTENCY4iTM3([argument conformsToProtocol:@protocol(iTM2TaskInspector)]);
        if (![self.inspectors containsObject:argument]) {
            [self.inspectors addObject:argument];
            [argument setTaskController:self];
            [argument logOutput:self.output];
            [argument logError:self.errorStatus];
        }
    }
//NSLog(@"self.inspectors: %@", self.inspectors);
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  removeInspector:
- (void)removeInspector:(id <iTM2TaskInspector>)argument;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if ([self.inspectors containsObject:argument]) {
        [self.inspectors removeObject:argument];//  reentrant management
        [argument setTaskController:nil];
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  allInspectors
- (NSArray *)allInspectors;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSMutableArray * MRA = [NSMutableArray array];
    for(id O in self.inspectors) {
        [MRA addObject:O];
	}
    return [[MRA copy] autorelease];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  addTaskWrapper:
- (void)addTaskWrapper:(id <iTM2TaskWrapper>)argument;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    ASSERT_INCONSISTENCY4iTM3([argument isKindOfClass:[iTM2TaskWrapper class]]);
    [self.wrappers addObject:argument];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  restartWithTaskWrapper:
- (void)restartWithTaskWrapper:(iTM2TaskWrapper *)argument;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self flush];
    [self addTaskWrapper:argument];
    [self start];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  removeTaskWrapper:
- (void)removeTaskWrapper:(id <iTM2TaskWrapper>)argument;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 31 14:37:03 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    ASSERT_INCONSISTENCY4iTM3([argument isKindOfClass:[iTM2TaskWrapper class]]);
    if ([argument isEqual:_CurrentWrapper]) {
        _CurrentWrapper = nil;
        // now we terminate the current task
        if ([_CurrentTask isRunning]) {
            [_CurrentTask terminate];
         }
         _CurrentTask = nil;
    } else {
        [self.wrappers removeObject:argument];
    }
    [self start];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= stop
- (void)stop;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/11/01)
Latest Revision: Wed Mar 31 14:36:46 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [DNC removeObserver:self name:NSFileHandleDataAvailableNotification object:nil];
    [DNC removeObserver:self name:NSTaskDidTerminateNotification object:nil];
    if ([_CurrentTask isRunning]) {
        [_CurrentTask terminate];
    }
    _CurrentTask = nil;
    _CurrentWrapper = nil;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= start
- (void)start;
/*"Launching the first available task in the task stack. Connets the I/O, registers the receiver to the default notification center.
Version History: jlaurens AT users DOT sourceforge DOT net (09/11/01)
Latest Revision: Wed Mar 31 14:36:53 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//LOG4iTM3(@"0");
    if (_CurrentWrapper) {
		if (iTM2DebugEnabled) {
			LOG4iTM3(@"task already running: %@", _CurrentTask);
		}
        return;
	}
//LOG4iTM3(@"1");
    if (!self.wrappers.count) {
//#warning CLEAN THE FIFO!!!???
		if (iTM2DebugEnabled) {
			LOG4iTM3(@"Nothing to start.");
		}
		if ([_CurrentTask isRunning]) {
			[_CurrentTask terminate];
		}
		_CurrentTask = nil;
		_CurrentWrapper = nil;
		[self resignStandalone];// maybe collected now
        return;
    }
//LOG4iTM3(@"2");
    if ([_CurrentTask isRunning]) {
        [_CurrentTask terminate];
	}
	// stop observing
    [DNC removeObserver:self name:NSFileHandleDataAvailableNotification object:nil];
    [DNC removeObserver:self name:NSTaskDidTerminateNotification object:nil];
    _CustomReadFileHandle = nil;// not retained, only garbage collected
    _CurrentTask = nil;
    _CurrentWrapper = nil;
//LOG4iTM3(@"3");

    NSMutableDictionary * environment = [[[[NSProcessInfo processInfo] environment] mutableCopy] autorelease];

    NSLock * L = [[[NSLock alloc] init] autorelease];
    [L lock];
    _CurrentWrapper = [[self.wrappers objectAtIndex:ZER0] retain];
    [self.wrappers removeObjectAtIndex:ZER0];
    [L unlock];

    _CurrentTask = [[NSTask alloc] init];
//LOG4iTM3(@"4");

	// standard output and error:
    if (self.isMute) {
        [_CurrentTask setStandardOutput:[NSFileHandle fileHandleWithNullDevice]];
		[_CurrentTask setStandardError:[NSFileHandle fileHandleWithNullDevice]];
	} else {
        [_CurrentTask setStandardOutput:[NSPipe pipe]];
		[_CurrentTask setStandardError:[NSPipe pipe]];
		NSFileHandle * FH;
		if ((FH = [[_CurrentTask standardOutput] fileHandleForReading])) {
//LOG4iTM3(@"OBSERVING OUTPUT:%@",FH);
			[DNC addObserver:self
				selector: @selector(_outputDataAvailableNotified:)
					name: NSFileHandleDataAvailableNotification
						object: FH];
			[FH waitForDataInBackgroundAndNotify];
		}
		if ((FH = [[_CurrentTask standardError] fileHandleForReading])) {
//LOG4iTM3(@"OBSERVING ERROR:%@",FH);
			[DNC addObserver:self
				selector: @selector(_errorDataAvailableNotified:)
					name: NSFileHandleDataAvailableNotification
						object: FH];
			[FH waitForDataInBackgroundAndNotify];
		}
	}
//LOG4iTM3(@"1");
	// standard input
	[_CurrentTask setStandardInput:(self.isDeaf?
		[NSFileHandle fileHandleWithNullDevice]:
			[NSPipe pipe])];
//LOG4iTM3(@"2");
    
#if 0
	This was tested, but does not work properly
    [_CustomWriteFileHandle release];
    _CustomWriteFileHandle = nil;
    
    char name[12];
    strcpy(name, "/dev/pty??");

    static char	ptychar[] = "pqrstuvw";
    static char	ptyhexa[] = "0123456789abcdef";

    int i;
    for (i = ZER0; i < strlen(ptychar); i++)
    {
        strcpy(name, "/dev/ptyXY");
        name[8] = ptychar[i];
        int j;
        for (j = ZER0; j < strlen(ptyhexa); j++)
        {
            name[9] = ptyhexa[j];
//LOG4iTM3(@"Trying to open file: %s", name);
            int master_fd = open(name, O_RDWR);
            if (master_fd >= ZER0)
            {
                name[5] = 't';	/* change "/dev/pty??" to "/dev/tty??" */
                int slave_fd  = open(name, O_RDWR);
                if (slave_fd<ZER0)
                    close(master_fd);
                else
                {
                    _CustomReadFileHandle = [[NSFileHandle alloc]
                        initWithFileDescriptor: master_fd closeOnDealloc: YES];
                    _CustomWriteFileHandle = [[NSFileHandle alloc]
                        initWithFileDescriptor: slave_fd closeOnDealloc: YES];
                    [environment setObject:[NSString stringWithCString:name] forKey:@"Device4iTM3"];
                    if (FH = _CustomReadFileHandle)
                    {
                        [FH readInBackgroundAndNotify];
                        [DNC addObserver:self
                            selector: @selector(_customReadCompletion:)
                                name: NSFileHandleReadCompletionNotification
                                    object: FH];
                    }
                    NS_DURING
//                    [_CustomWriteFileHandle writeData:[@"<iTM2-ConnectionTest/>" dataUsingEncoding:NSUTF8StringEncoding]];
                    NS_HANDLER
                    LOG4iTM3(@"***  BAD CONNECTION, exception catched %@", [localException reason]);
                    [_CustomReadFileHandle release];
                    [_CustomWriteFileHandle release];
                    _CustomReadFileHandle = nil;
                    _CustomWriteFileHandle = nil;
                    NS_ENDHANDLER
                    goto followMe;
                }
            }
        }
    }
    [environment setObject:[NSString stringWithCString:"/dev/null"] forKey:@"Device4iTM3"];
    iTM2Beep();
    LOG4iTM3(@"There is no custom pipe available... iTeXMac2 will not completely work as expected");
    followMe:
#elif 0
	this was tested and raised problems for "temporary ... unsvailable" NSException
	The garbage collector is not well implemented because it does not remove the FH when exception are raised
	The _FHGC _NGC pair should be replaced by a dictionary
    if (!_CustomReadFileHandle)
    {
        INIT_POOL4iTM3;
        int fireWall = 256;
        while(fireWall--)
        {
            NSString * path = [[NSBundle temporaryUniqueDirectory] stringByAppendingPathComponent:@"FIFO"];
            char * FSR = (char *)[path fileSystemRepresentation];
            if (iTM2DebugEnabled)
            {
                LOG4iTM3(@"FIFO communication channel is: %@", path);
            }
            if (mkfifo(FSR, S_IRUSR | S_IWUSR))
                break;
            int fd = open(FSR, O_RDONLY | O_NONBLOCK);
            if (fd)
            {
                _CustomReadFileHandle = [[[NSFileHandle alloc] initWithFileDescriptor:fd closeOnDealloc:YES] autorelease];
                [_FHGC addObject:_CustomReadFileHandle];
                [_NGC addObject:path];
                [DNC addObserver:self
                    selector: @selector(_customDataAvailableNotified:)
                        name: NSFileHandleDataAvailableNotification
                            object: _CustomReadFileHandle];
                [_CustomReadFileHandle waitForDataInBackgroundAndNotify];
                [environment setObject:path forKey:@"Device4iTM3"];
                goto theEnd;
            }
            else
                break;
        }
        LOG4iTM3(@"No FIFO available: communication of shell scripts with iTeXMac2 through FIFO is compromised...");
        theEnd:
        RELEASE_POOL4iTM3;
    }
#endif
    [DNC addObserver:self
        selector: @selector(_currentTaskDidTerminate:) 
            name: NSTaskDidTerminateNotification
                object: _CurrentTask];

//LOG4iTM3(@"3");
    [self.allInspectors makeObjectsPerformSelector:@selector(taskWillLaunch)];
    
    if (!_Output) {
        _Output = [[NSMutableString string] retain];
    }
    if (!_Custom) {
        _Custom = [[NSMutableString string] retain];
    }
    if (!_Error) {
        _Error = [[NSMutableString string] retain];
    }

//LOG4iTM3(@"4");
    [_CurrentWrapper taskWillLaunch:self];
    [environment setObject:self.conversation forKey:@"Conversation4iTM3"];
    [environment setObject:NSHomeDirectory() forKey:@"HOME4iTM3"];
    [environment setObject:NSBundle.mainBundle.temporaryDirectoryURL4iTM3.path forKey:@"TemporaryDirectory4iTM3"];
//NSLog(@"[_CurrentWrapper launchPath]:%@", [_CurrentTask launchPath]);
    [_CurrentTask setLaunchPath:[[_CurrentWrapper launchURL] path]];
//NSLog(@"[_CurrentTask launchPath]:%@", [_CurrentTask launchPath]);
	NSString * currentDirectory = [_CurrentWrapper currentDirectoryPath];
    if (currentDirectory.length) {
        [_CurrentTask setCurrentDirectoryPath:currentDirectory];
	}

//LOG4iTM3(@"5");
    NSString * PATH = [[_CurrentWrapper environment] objectForKey:iTM2TaskPATHKey];
    NSString * oldPATH = [environment objectForKey:iTM2TaskPATHKey];
    [environment addEntriesFromDictionary:[_CurrentWrapper environment]];
    if (PATH.length) {
        [environment setObject:[NSString stringWithFormat:([oldPATH hasPrefix:@":"]? @":%@%@":@":%@:%@"), PATH, oldPATH] forKey:iTM2TaskPATHKey];
	}
	[environment setObject:[NSConnection iTeXMac2ConnectionIdentifier] forKey:iTM2ConnectionIdentifierKey];
//NSLog(@"[_CurrentTask environment]:%@", [_CurrentTask environment]);
//NSLog(@"[_CurrentWrapper environment]:%@", [_CurrentWrapper environment]);
//NSLog(@"[[NSProcessInfo processInfo] environment]:%@", [[NSProcessInfo processInfo] environment]);
//NSLog(@"[[NSProcessInfo processInfo] arguments]:%@", [[NSProcessInfo processInfo] arguments]);
    if ([[_CurrentWrapper arguments] count]) {
        [_CurrentTask setArguments:[_CurrentWrapper arguments]];
	}
    [_CurrentTask setEnvironment:environment];
    [_CurrentTask launch];
	if (iTM2DebugEnabled) {
		LOG4iTM3(@"task: %@", _CurrentTask);
	}
//NSLog(@"_CurrentTask %@ (isRunning %@)", _CurrentTask, ([_CurrentTask isRunning]? @"Y":@"N"));
//NSLog(@"[_CurrentTask environment]:%@", [_CurrentTask environment]);
//LOG4iTM3(@"_CurrentWrapper is: %@", _CurrentWrapper);
    return;
}
static NSMutableSet * __iTM2StandaloneTaskControllers;
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= becomeStandalone
- (void)becomeStandalone;
/*"Description Forthcoming.
 Version History: jlaurens AT users DOT sourceforge DOT net (09/11/01)
 - for 1.3: Mon Jun 02 2003
 To Do List:
 "*/
{DIAGNOSTIC4iTM3;
	if (!__iTM2StandaloneTaskControllers) {
		__iTM2StandaloneTaskControllers = [NSMutableSet set];
	}
	//START4iTM3;
	[__iTM2StandaloneTaskControllers addObject:self];
	//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= resignStandalone
- (void)resignStandalone;
/*"Description Forthcoming.
 Version History: jlaurens AT users DOT sourceforge DOT net (09/11/01)
 - for 1.3: Mon Jun 02 2003
 To Do List:
 "*/
{DIAGNOSTIC4iTM3;
	//START4iTM3;
	[__iTM2StandaloneTaskControllers removeObject:self];
	//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= flush
- (void)flush;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/11/01)
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self stop];
    while(self.wrappers.count) {
        [self removeTaskWrapper:[self.wrappers lastObject]];
    }
    [self clean];
    _CustomReadFileHandle = nil;// not retained, only garbage collected, in some private sense
//#warning THE FIFO SHOULD BE CHANGED HERE
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= clean
- (void)clean;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/11/01)
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [_Output setString:[NSString string]];
    [_Custom setString:[NSString string]];
    [_Error setString:[NSString string]];
    [self.allInspectors makeObjectsPerformSelector:@selector(cleanLog:) withObject:self];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= output
- (NSString *)output;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/11/01)
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	return _Output? [[_Output copy] autorelease]:[NSString string];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= custom
- (NSString *)custom;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/11/01)
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return _Custom? [[_Custom copy] autorelease]:[NSString string];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= errorStatus
- (NSString *)errorStatus;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/11/01)
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return _Error? [[_Error copy] autorelease]:[NSString string];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= _outputDataAvailableNotified:
- (void)_outputDataAvailableNotified:(NSNotification *)aNotification;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/11/01)
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (![self.currentTask isRunning])
	{
		return;
	}
    NSFileHandle * FH = [aNotification object];
//LOG4iTM3(@"OBSERVED OUTPUT:%@",FH);
//LOG4iTM3(@"OBSERVED OUTPUT:%@",[self.currentTask standardOutput]);
//LOG4iTM3(@"OBSERVED OUTPUT:%@",[[self.currentTask standardOutput] fileHandleForReading]);
	// this can cause a spin lock too
	if (![FH isEqual:[[self.currentTask standardOutput] fileHandleForReading]])
	{
		return;
	}
    NSData * D = [FH availableData];
	if (D.length)
	{
		NSString * string = [[[NSString alloc] initWithData:D encoding:NSUTF8StringEncoding] autorelease];
		if (!string.length)
		{
			string = [[[NSString alloc] initWithData:D encoding:NSMacOSRomanStringEncoding] autorelease];
			LOG4iTM3(@"Output encoding problem.");
		}
		[self logOutput:string];
		[FH waitForDataInBackgroundAndNotify];
	}
    else
	{
		[DNC removeObserver:self name:[aNotification name] object:FH];
        [self.allInspectors makeObjectsPerformSelector:@selector(outputDidTerminate) withObject:nil];
	}
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  logOutput:
- (void)logOutput:(NSString *)string;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/11/01)
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (string.length>ZER0)
    {
        [_Output appendString:string];
//NSLog(@"self.allInspectors:%@", self.allInspectors);
        [self.allInspectors makeObjectsPerformSelector:_cmd withObject:string];
    }
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= _customDataAvailableNotified:
- (void)_customDataAvailableNotified:(NSNotification *)notification;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/11/01)
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//#warning NSException catching?
    NSFileHandle * FH = [notification object];
    NSData * D;
	NS_DURING
	D = [FH availableData];// RAISE:17/03/2005, reason "resource temporarily unavailable"
#if 0
If you see this message displayed on the console:
   Fork failed: Command[scoterm]System Error was:Resource temporarily unavailable

This message is usually caused by running out of virtual memory and can be easily remedied by adding more swap space. This must be done while in multiuser mode. When executed as root, these commands add approximately 30MB of virtual memory: 

touch /swap 
swap -a /swap ZER0 60000

The /swap file will only grow according to the actual swap requirements and may not actually consume 30MB of disk space. To avoid reissuing this command every time the system is rebooted, simply add the above commands to the /etc/rc.d/8/userdef file.

Virtual memory is tracked via the kernel variable availsmem, which tracks the available virtual memory in 4K pages. This variable is handled conservatively, and normally reserves more swap space than will actually be needed. Programs that use shared libraries will decrement availsmem. Programs that use the mmap(S) facility and map privately also require a large reserve of virtual memory.

To monitor availsmem, use the crash(ADM) utility:
   # crash
   dumpfile = /dev/mem, namelist = /unix, outfile = stdout
   > od -d availsmem
   f0175120:  0000011682
   > q

In this example, the value ``0000011682'' translates to 11,682 4K pages, or approximately 45.63 MB.
#endif
    if (_CustomReadFileHandle == FH)
    {
		NSString * string = [[[NSString alloc] initWithData:D encoding:NSUTF8StringEncoding] autorelease];
		if (D.length && !string.length)
		{
			string = [[[NSString alloc] initWithData:D encoding:NSMacOSRomanStringEncoding] autorelease];
			LOG4iTM3(@"Output encoding problem.");
		}
        [self logCustom:string];
    }
    if ([_CurrentTask isRunning] || D.length)
    {
        [FH waitForDataInBackgroundAndNotify];
        NS_VOIDRETURN;
    }
    if (_CustomReadFileHandle == FH)
    {
        [self.allInspectors makeObjectsPerformSelector:@selector(customDidTerminate) withObject:nil];
        _CustomReadFileHandle = nil;
    }
    [_FHGC removeObject:FH];
	NS_HANDLER
	[NSApp reportException:localException];
	NS_ENDHANDLER
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  outputDidTerminate
- (void)outputDidTerminate;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/11/01)
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[self.allInspectors makeObjectsPerformSelector:_cmd withObject:nil];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  logCustom:
- (void)logCustom:(NSString *)string;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/11/01)
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (string.length>ZER0)
    {
        NSMutableString * buffer = [self.implementation metaValueForKey:@"_CustomBuffer"];
//LOG4iTM3(@"buffer: <%@>", buffer);
        NSRange R = iTM3MakeRange(_Custom.length, ZER0);
        [_Custom getLineStart:&R.location end:nil contentsEnd:nil forRange:R];
        // R.location points to the beginning of the line where we are looking for iTM2 directives.
//LOG4iTM3(@"_Custom: %@", _Custom);
//LOG4iTM3(@"string: %@", string);
        [_Custom appendString:string];
        int newLength = _Custom.length;
        NSRange searchRange;
        if (buffer)
        {
CurrentModeOn:
//LOG4iTM3(@"CurrentModeOn");
            searchRange = iTM3MakeRange(R.location, newLength - R.location);
            if ([_Custom rangeOfString:@"</applescript>" options:NSAnchoredSearch range:searchRange].length)
            {
                // we found the end of the applescript
//LOG4iTM3(@"APPLESCRIPTING: ----\n%@\n----", buffer);
                [self executeAppleScript:buffer];
                buffer = nil;
                [_Custom getLineStart:nil end:&R.location contentsEnd:nil forRange:R];
                goto CurrentModeOff;
            }
            else
            {
                int start = R.location;
                [_Custom getLineStart:nil end:&R.location contentsEnd:nil forRange:R];
                [buffer appendString:[_Custom substringWithRange:iTM3MakeRange(start, R.location - start)]];
//LOG4iTM3(@"buffer: <%@>", buffer);
                if (R.location < newLength)
                    goto CurrentModeOn;
            }
        }
        else
        {
            // no apple script pending...
CurrentModeOff:
//LOG4iTM3(@"CurrentModeOff");
            searchRange = iTM3MakeRange(R.location, newLength - R.location);
            // R.location now points to the beginning of the next line
            if ([_Custom rangeOfString:@"<applescript>" options:NSAnchoredSearch range:searchRange].length)
            {
                //Ok we are starting an apple script
                // the rest of the line is ignored
                [_Custom getLineStart:nil end:&R.location contentsEnd:nil forRange:R];
                searchRange.location += [@"<applescript>" length];
                searchRange.length = R.location - searchRange.location;
                buffer = [NSMutableString stringWithString:[_Custom substringWithRange:searchRange]];
                goto CurrentModeOn;
            }
            else if (R.location < newLength)
            {
                [_Custom getLineStart:nil end:&R.location contentsEnd:nil forRange:R];
                goto CurrentModeOff;
            }
        }
        [self.implementation takeMetaValue:buffer forKey:@"_CustomBuffer"];
        if (iTM2DebugEnabled>999)
        {
            LOG4iTM3(@"Pending AppleScript: ----\n%@\n----", buffer);
        }
    }
    else if (iTM2DebugEnabled>100)
    {
//        LOG4iTM3(@"No custom data to log out.");
        if (iTM2DebugEnabled>999)
        {
            NSMutableString * buffer = [self.implementation metaValueForKey:@"_CustomBuffer"];
            if (buffer)
            {
                LOG4iTM3(@"Pending AppleScript: ----\n%@\n----", buffer);
            }
        }
    }
//NSLog(@"self.allInspectors:%@", self.allInspectors);
    [self.allInspectors makeObjectsPerformSelector:_cmd withObject:string];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= _errorDataAvailableNotified:
- (void)_errorDataAvailableNotified:(NSNotification *)aNotification;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/11/01)
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (![self.currentTask isRunning])
	{
		return;
	}
    NSFileHandle * FH = [aNotification object];
	/* Be carefull in next line, the next line hangs */
//LOG4iTM3(@"OBSERVED ERROR:%@",FH);
//LOG4iTM3(@"OBSERVED ERROR:%@",[self.currentTask standardError]);
//LOG4iTM3(@"OBSERVED ERROR:%@",[[self.currentTask standardError] fileHandleForReading]);
	if (![FH isEqual:[[self.currentTask standardError] fileHandleForReading]])
	{
//LOG4iTM3(@"SAVED ERROR!");
NSBeep();
NSBeep();
NSBeep();
NSBeep();
		return;
	}
    NSData * D = [FH availableData];
	if (D.length)
	{
		NSString * string = [[[NSString alloc] initWithData:D encoding:NSUTF8StringEncoding] autorelease];
		if (!string.length)
		{
			string = [[[NSString alloc] initWithData:D encoding:NSMacOSRomanStringEncoding] autorelease];
			LOG4iTM3(@"Output encoding problem.");
		}
		[self logError:string];
		[FH waitForDataInBackgroundAndNotify];
	}
    else
	{
		[DNC removeObserver:self name:[aNotification name] object:FH];
        [self.allInspectors makeObjectsPerformSelector:@selector(errorDidTerminate) withObject:nil];
	}
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  logError:
- (void)logError:(NSString *)string;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/11/01)
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (string.length>ZER0)
    {
//NSLog(@"error string: %@", string);
        [_Error appendString:string];
        [self.allInspectors makeObjectsPerformSelector:_cmd withObject:string];
//NSLog(@"self.errorStatus:%@", self.errorStatus);
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  errorDidTerminate
- (void)errorDidTerminate;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/11/01)
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[self.allInspectors makeObjectsPerformSelector:_cmd withObject:nil];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= _currentTaskDidTerminate:
- (void)_currentTaskDidTerminate:(NSNotification *)aNotification;
/*"Description Forthcoming. Not orthogonal.
Version History: jlaurens AT users DOT sourceforge DOT net (09/11/01)
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (iTM2DebugEnabled)
	{
		LOG4iTM3(@"task: %@", [aNotification object]);
	}
    if (![_CurrentTask isEqual:[aNotification object]])
        return;
//START4iTM3;
    [DNC removeObserver:self name:NSTaskDidTerminateNotification object:_CurrentTask];
//LOG4iTM3(@"_CurrentWrapper is: %@", _CurrentWrapper);
	if (!self.isMute)
	{
		NSFileHandle * FH = nil;
		NSData * D = nil;
		NSString * string = nil;
		// got an exception here: *** -[NSNullFileHandle fileHandleForReading]:selector not recognized [self = 0x14a1070]
		id IO = [_CurrentTask standardOutput];
		if ([IO respondsToSelector:@selector(fileHandleForReading)])
		{
			FH = [IO fileHandleForReading];// there is a problem here if the process was killed externally, no pipe and infinite loop
			D = [FH readDataToEndOfFile];
			string = [[[NSString alloc] initWithData:D encoding:NSUTF8StringEncoding] autorelease];
			if (D.length && !string.length)
			{
				string = [[[NSString alloc] initWithData:D encoding:NSMacOSRomanStringEncoding] autorelease];
				LOG4iTM3(@"Output encoding problem.");
			}
			[self logOutput:string];
		}
		else if ([IO respondsToSelector:@selector(readDataToEndOfFile)])
		{
			D = [IO readDataToEndOfFile];
			string = [[[NSString alloc] initWithData:D encoding:NSUTF8StringEncoding] autorelease];
			if (D.length && !string.length)
			{
				string = [[[NSString alloc] initWithData:D encoding:NSMacOSRomanStringEncoding] autorelease];
				LOG4iTM3(@"Output encoding problem.");
			}
			[self logOutput:string];
		}
		IO = [_CurrentTask standardError];
		if ([IO respondsToSelector:@selector(fileHandleForReading)])
		{
			FH = [IO fileHandleForReading];
			D = [FH readDataToEndOfFile];
			string = [[[NSString alloc] initWithData:D encoding:NSUTF8StringEncoding] autorelease];
			if (D.length && !string.length)
			{
				string = [[[NSString alloc] initWithData:D encoding:NSMacOSRomanStringEncoding] autorelease];
				LOG4iTM3(@"Output encoding problem.");
			}
			[self logError:string];
		}
		else if ([IO respondsToSelector:@selector(readDataToEndOfFile)])
		{
			D = [IO readDataToEndOfFile];
			string = [[[NSString alloc] initWithData:D encoding:NSUTF8StringEncoding] autorelease];
			if (D.length && !string.length)
			{
				string = [[[NSString alloc] initWithData:D encoding:NSMacOSRomanStringEncoding] autorelease];
				LOG4iTM3(@"Output encoding problem.");
			}
			[self logError:string];
		}
	}
    [_CurrentWrapper taskDidTerminate:self];
    [self.allInspectors makeObjectsPerformSelector:@selector(taskDidTerminate)];
    _CurrentTask = nil;
    _CurrentWrapper = nil;
    [self start];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= executeAppleScript:
- (void)executeAppleScript:(NSString *)source;
/*"Description Forthcoming. Rough input, no verification.
Version History: jlaurens AT users DOT sourceforge DOT net (09/11/01)
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//LOG4iTM3(@"source is: %@", source);
    NSAppleScript * AS = [[[NSAppleScript alloc] initWithSource:source] autorelease];
    if (AS)
    {
        NSDictionary * errorInfo = nil;
        [AS executeAndReturnError:&errorInfo];
        if (errorInfo)
        {
            NSMutableString * MS = [NSMutableString stringWithString:@"\n! AppleScript execution error:\n"];
            NSString * message;
            if ((message = [errorInfo objectForKey:NSAppleScriptErrorAppName]))
                [MS appendFormat:@"! Application:%@\n", message];
            if ((message = [errorInfo objectForKey:NSAppleScriptErrorMessage]))
                [MS appendFormat:@"! Reason:%@\n", message];
            if ((message = [errorInfo objectForKey:NSAppleScriptErrorNumber]))
                [MS appendFormat:@"! Error number:%@\n", message];
            if ((message = [errorInfo objectForKey:NSAppleScriptErrorBriefMessage]))
                [MS appendFormat:@"! Brief reason:%@\n", message];
            if ((message = [errorInfo objectForKey:NSAppleScriptErrorRange]))
                [MS appendFormat:@"! Error range:%@\n", message];
            [self.allInspectors makeObjectsPerformSelector:@selector(logCustom:) withObject:MS];
        }
    }
    else
    {
        [self.allInspectors makeObjectsPerformSelector:@selector(logCustom:) withObject:@"\n!  Bad script\n"];
    }
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  waitUntilExit
- (void)waitUntilExit;
/*"Description Forthcoming. Rough input, no verification.
Version History: jlaurens AT users DOT sourceforge DOT net (09/11/01)
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[[NSCursor cancelCursor] push];
	NSString * string = nil;
	NSTimeInterval timeInterval = [SUD floatForKey:@"iTM2TaskInterruptDelay"]?:0.25;
	timeInterval = MAX(timeInterval,ZER0);
start:
	if ([_CurrentWrapper canInterruptTask])
	{
		while([_CurrentTask isRunning])
		{
			NSDate * date = [NSDate dateWithTimeIntervalSinceNow:timeInterval];
			NSEvent * E = [NSApp nextEventMatchingMask:NSKeyDownMask|NSKeyUpMask untilDate:date inMode:NSDefaultRunLoopMode dequeue:YES];
			if (E)
			{
				string = [E characters];
				if (string.length && ([string characterAtIndex:ZER0] == '.'))
				{
					NSUInteger modifierFlags = [E modifierFlags];
					modifierFlags &= NSDeviceIndependentModifierFlagsMask;
					modifierFlags &= ~NSShiftKeyMask;
					if (modifierFlags == NSCommandKeyMask)
					{
						[self clean];
						[NSCursor pop];
						return;
					}
				}
			}
		}
	}
	else
	{
		[_CurrentTask waitUntilExit];
	}
	NSFileHandle * FH = [[_CurrentTask standardOutput] fileHandleForReading];
    NSData * D;
	NS_DURING
	D = [_CurrentTask isRunning]?[FH availableData]:[FH readDataToEndOfFile];//: Interrupted system call?
	NS_HANDLER
	D = nil;
	NS_ENDHANDLER
	while(D.length)
	{
		string = [[[NSString alloc] initWithData:D encoding:NSUTF8StringEncoding] autorelease];
		if (!string.length)
		{
			string = [[[NSString alloc] initWithData:D encoding:NSMacOSRomanStringEncoding] autorelease];
			LOG4iTM3(@"Output encoding problem.");
		}
		[_Output appendString:string];
		NS_DURING
		D = [_CurrentTask isRunning]?[FH availableData]:[FH readDataToEndOfFile];//: Interrupted system call?
		NS_HANDLER
		D = nil;
		NS_ENDHANDLER
	}
	FH = [[_CurrentTask standardError] fileHandleForReading];
	NS_DURING
	D = [_CurrentTask isRunning]?[FH availableData]:[FH readDataToEndOfFile];//: Interrupted system call?
	NS_HANDLER
	D = nil;
	NS_ENDHANDLER
	string = nil;
	while(D.length)
	{
		string = [[[NSString alloc] initWithData:D encoding:NSUTF8StringEncoding] autorelease];
		if (!string.length)
		{
			string = [[[NSString alloc] initWithData:D encoding:NSMacOSRomanStringEncoding] autorelease];
			LOG4iTM3(@"Output encoding problem.");
		}
		[_Output appendString:string];
		NS_DURING
		D = [_CurrentTask isRunning]?[FH availableData]:[FH readDataToEndOfFile];//: Interrupted system call?
		NS_HANDLER
		D = nil;
		NS_ENDHANDLER
	}
	_CurrentTask = nil;
	_CurrentWrapper = nil;
	[self start];
	if (_CurrentWrapper)
	{
		goto start;
	}
	[NSCursor pop];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= execute:
- (void)execute:(NSString *)aCommand;
/*"Description Forthcoming. Rough input, no verification.
Version History: jlaurens AT users DOT sourceforge DOT net (09/11/01)
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if ([_CurrentTask isRunning] && aCommand.length)
    {
        NSLog(@"Executing: %@", aCommand);
        [self.allInspectors makeObjectsPerformSelector:@selector(logInput:) withObject:aCommand];
		NSData * D = [aCommand dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        [[[_CurrentTask standardInput] fileHandleForWriting] writeData:D];
        if (![aCommand hasSuffix:@"\n"])
        {
            [[[_CurrentTask standardInput] fileHandleForWriting] writeData:
                [@"\n" dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES]];
            [self.allInspectors makeObjectsPerformSelector:@selector(logInput:) withObject:@"\n"];
        }
    }
    else
    {
        NSLog(@"%@ %#x", NSStringFromClass(self.class), NSStringFromSelector(_cmd), self);
        NSLog(@"Ignored: <%@>", aCommand);
    }
    return;
}
@synthesize wrappers=_Wrappers;
@synthesize conversation=_Conversation;
@synthesize inspectors=_Inspectors;
@synthesize currentWrapper=_CurrentWrapper;
@synthesize currentTask=_CurrentTask;
@synthesize customReadFileHandle=_CustomReadFileHandle;
@synthesize output=_Output;
@synthesize custom=_Custom;
@synthesize error=_Error;
@synthesize _FHGC;
@synthesize _NGC;
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2TaskController

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2TaskWrapper

NSString * const iTM2TaskEnvironmentKey = @"iTM2TaskEnvironment";
#define iVarTaskEnvironment [self.implementation metaValueForKey:iTM2TaskEnvironmentKey]
NSString * const iTM2TaskArgumentsKey = @"iTM2TaskArguments";
#define iVarArguments [self.implementation metaValueForKey:iTM2TaskArgumentsKey]
NSString * const iTM2TaskLaunchURLKey = @"iTM2TaskLaunchURL";
#define iVarLaunchURL [self.implementation metaValueForKey:iTM2TaskLaunchURLKey]
NSString * const iTM2TaskCurrentDirectoryPathKey = @"iTM2TaskCurrentDirectoryPath";
#define iVarCurrentDirectoryPath [self.implementation metaValueForKey:iTM2TaskCurrentDirectoryPathKey]
NSString * const iTM2TaskLaunchInvocationKey = @"iTM2TaskLaunchInvocation";
NSString * const iTM2TaskInterruptInvocationKey = @"iTM2TaskInterruptInvocation";
NSString * const iTM2TaskTerminateInvocationKey = @"iTM2TaskTerminateInvocation";
NSString * const iTM2TaskTerminationStatusKey = @"iTM2TaskTerminationStatus";
#define iVarTerminationStatus [[self.implementation metaValueForKey:iTM2TaskTerminationStatusKey] integerValue]
NSString * const iTM2TaskCanInterruptKey = @"iTM2TaskCanInterrupt";

NSString * const iTM2TaskPATHKey = @"PATH";

@implementation iTM2TaskWrapper
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initImplementation
- (void)initImplementation;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [super initImplementation];
    [IMPLEMENTATION takeMetaValue:[NSMutableDictionary dictionary] forKey:iTM2TaskEnvironmentKey];
    [IMPLEMENTATION takeMetaValue:[NSString string] forKey:iTM2TaskCurrentDirectoryPathKey];
    [IMPLEMENTATION takeMetaValue:[NSMutableArray array] forKey:iTM2TaskArgumentsKey];
    #warning: this is not the best location.
    [self setEnvironmentString:@":0.0" forKey:@"DISPLAY"];// this is for the xdvi support
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  delegate
- (id)delegate;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSInvocation * I = [self.implementation metaValueForKey:iTM2TaskLaunchInvocationKey];
    return I? I.target:[[self.implementation metaValueForKey:iTM2TaskTerminateInvocationKey] target];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  userInfo
- (id)userInfo;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    id result = nil;
    NSInvocation * _Launch = [self.implementation metaValueForKey:iTM2TaskLaunchInvocationKey];
    if (_Launch)
        [_Launch getArgument:&result atIndex:4];
    else
    {
        NSInvocation * _Terminate = [self.implementation metaValueForKey:iTM2TaskTerminateInvocationKey];
        if (_Terminate)
            [_Terminate getArgument:&result atIndex:4];
		else
		{
			NSInvocation * _Interrupt = [self.implementation metaValueForKey:iTM2TaskInterruptInvocationKey];
			if (_Interrupt)
				[_Interrupt getArgument:&result atIndex:4];
		}
    }
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTeXMac2_callbackTemplate:::
- (void)iTeXMac2_callbackTemplate:(iTM2TaskWrapper *)arg1 :(iTM2TaskController *)taskController :(id)userInfo;
/*"Description Forthcoming.
 Version history: jlaurens AT users DOT sourceforge DOT net
 - for 1.3: Mon Jun 02 2003
 To Do List:
 "*/
{DIAGNOSTIC4iTM3;
	//START4iTM3;
	//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setDelegate:launchCallback:terminateCallback:interruptCallback:userInfo:
- (void)setDelegate:(id)delegate launchCallback:(SEL)LCB terminateCallback:(SEL)TCB interruptCallback:(SEL)ICB userInfo:(id)userInfo;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (delegate && delegate != self)
    {
        NSMethodSignature * template = [self methodSignatureForSelector:@selector(_callbackTemplate:::)];
        if (LCB)
        {
            NSMethodSignature * MS = [delegate methodSignatureForSelector:LCB];
            if ([template isEqual:MS])
            {
                NSInvocation * _Launch = [NSInvocation invocationWithMethodSignature:MS];
                [_Launch retainArguments];// for the userInfo!!! but will retain the target too
                _Launch.target = delegate;
                [delegate autorelease];// compensate the setTarget:retain, see the cleanInvocations
                [_Launch setSelector:LCB];
                [_Launch setArgument:&userInfo atIndex:4];
                [IMPLEMENTATION takeMetaValue:_Launch forKey:iTM2TaskLaunchInvocationKey];
            }
            else
                LOG4iTM3(@"Bad selector: %@", NSStringFromSelector(LCB));
        }
        if (TCB)
        {
            NSMethodSignature * MS = [delegate methodSignatureForSelector:TCB];
            if ([template isEqual:MS])
            {
                NSInvocation * _Terminate = [NSInvocation invocationWithMethodSignature:MS];
                [_Terminate retainArguments];// for the userInfo!!!
                _Terminate.target = delegate;
                [delegate autorelease];// compensate the setTarget:retain, see the cleanInvocations
                [_Terminate setSelector:TCB];
                [_Terminate setArgument:&userInfo atIndex:4]; 
                [IMPLEMENTATION takeMetaValue:_Terminate forKey:iTM2TaskTerminateInvocationKey];
            }
            else
                LOG4iTM3(@"Bad selector: %@", NSStringFromSelector(TCB));
        }
        if (ICB)
        {
            NSMethodSignature * MS = [delegate methodSignatureForSelector:ICB];
            if ([template isEqual:MS])
            {
                NSInvocation * _Interrupt = [NSInvocation invocationWithMethodSignature:MS];
                [_Interrupt retainArguments];// for the userInfo!!!
                _Interrupt.target = delegate;
                [delegate autorelease];// compensate the setTarget:retain, see the cleanInvocations
                [_Interrupt setSelector:TCB];
                [_Interrupt setArgument:&userInfo atIndex:4]; 
                [IMPLEMENTATION takeMetaValue:_Interrupt forKey:iTM2TaskInterruptInvocationKey];
            }
            else
                LOG4iTM3(@"Bad selector: %@", NSStringFromSelector(ICB));
        }
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  launchURL
- (NSURL *)launchURL;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Sat Jan 30 15:37:08 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return iVarLaunchURL;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setLaunchURL:
- (void)setLaunchURL:(NSURL *)argument;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Sat Jan 30 15:37:11 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (argument && ![argument isEquivalentToURL4iTM3:iVarLaunchURL]) {
        [IMPLEMENTATION takeMetaValue:[[argument copy] autorelease] forKey:iTM2TaskLaunchURLKey];
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  arguments
- (NSMutableArray *)arguments;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return iVarArguments;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setArguments:
- (void)setArguments:(NSArray *)argument;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (argument && ![argument isKindOfClass:[NSArray class]])
        [NSException raise:NSInvalidArgumentException format:@"%@ NSArray argument expected:got %@.",
            __iTM2_PRETTY_FUNCTION__, argument];
    else if (![argument isEqual:iVarArguments])
        [IMPLEMENTATION takeMetaValue:[[argument copy] autorelease] forKey:iTM2TaskArgumentsKey];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  addArgument:
- (void)addArgument:(NSString *)argument;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (argument && ![argument isKindOfClass:[NSString class]])
        [NSException raise:NSInvalidArgumentException format:@"%@ NSString argument expected:got %@.",
            __iTM2_PRETTY_FUNCTION__, argument];
    else if (argument.length)
    {
        [self.arguments addObject:argument];
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  addArguments:
- (void)addArguments:(NSArray *)argument;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (argument && ![argument isKindOfClass:[NSArray class]])
        [NSException raise:NSInvalidArgumentException format:@"%@ NSArray argument expected:got %@.",
            __iTM2_PRETTY_FUNCTION__, argument];
    else
    {
        NSEnumerator * E = argument.objectEnumerator;
        NSString * S;
        NSMutableArray * MRA = [NSMutableArray array];
        while((S = E.nextObject))
        {
            if ([argument isKindOfClass:[NSString class]] && S.length)
                [MRA addObject:S];
        }
        [self.arguments addObjectsFromArray:MRA];
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  environment
- (NSMutableDictionary *)environment;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return iVarTaskEnvironment;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setEnvironment:
- (void)setEnvironment:(NSMutableDictionary *)argument;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (argument && ![argument isKindOfClass:[NSDictionary class]])
        [NSException raise:NSInvalidArgumentException format:@"%@ NSDictionary argument expected:got %@.",
            __iTM2_PRETTY_FUNCTION__, argument];
    else if (![argument isEqual:iVarTaskEnvironment])
        [IMPLEMENTATION takeMetaValue:[[argument mutableCopy] autorelease] forKey:iTM2TaskEnvironmentKey];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  replaceEnvironment:
- (void)replaceEnvironment:(NSDictionary *)argument;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (![argument isKindOfClass:[NSDictionary class]])
        [NSException raise:NSInvalidArgumentException format:@"%@ NSDictionary argument expected:got %@.",
            __iTM2_PRETTY_FUNCTION__, argument];
    else if (![argument isEqual:self.environment])
    {
        [self.environment setDictionary:argument];
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  mergeEnvironment:
- (void)mergeEnvironment:(NSDictionary *)argument;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (argument && ![argument isKindOfClass:[NSDictionary class]])
        [NSException raise:NSInvalidArgumentException format:@"%@ NSDictionary argument expected:got %@.",
            __iTM2_PRETTY_FUNCTION__, argument];
    else
    {
        [self.environment addEntriesFromDictionary:argument];
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setEnvironmentString:forKey:
- (void)setEnvironmentString:(NSString *)argument forKey:(NSString *)key;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSAssert(key != nil, @"Unexpected nil key");
    if (![argument isKindOfClass:[NSString class]])
        [NSException raise:NSInvalidArgumentException format:@"%@ NSString argument expected:got %@.",
            __iTM2_PRETTY_FUNCTION__, argument];
    else if (![key isKindOfClass:[NSString class]])
        [NSException raise:NSInvalidArgumentException format:@"%@ NSString key expected:got %@.",
            __iTM2_PRETTY_FUNCTION__, key];
    else
    {
        [self.environment setObject:argument forKey:key];
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  appendPATHComponent:
- (void)appendPATHComponent:(NSString *)path;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (path && ![path isKindOfClass:[NSString class]])
        [NSException raise:NSInvalidArgumentException format:@"%@ NSString argument expected:got %@.",
            __iTM2_PRETTY_FUNCTION__, path];
    else if (path.length)
    {
        NSString * oldPATH = [self.environment objectForKey:iTM2TaskPATHKey];
        NSMutableArray * PCs = [[[(oldPATH? oldPATH:@"") componentsSeparatedByString:@":"] mutableCopy] autorelease];
        [PCs removeObject:path];
        [PCs addObject:path];
        [self.environment setObject:[PCs componentsJoinedByString:@":"] forKey:iTM2TaskPATHKey];
		if (iTM2DebugEnabled>999)
		{
			LOG4iTM3(@"The component %@ has been appended to PATH, the result is: %@", path, [self.environment objectForKey:iTM2TaskPATHKey]);
		}
    }
	else if (iTM2DebugEnabled)
	{
		LOG4iTM3(@"Ignoring PATH component: %@", path);
	}
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  prependPATHComponent:
- (void)prependPATHComponent:(NSString *)path;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (path && ![path isKindOfClass:[NSString class]])
        [NSException raise:NSInvalidArgumentException format:@"%@ NSString argument expected:got %@.",
            __iTM2_PRETTY_FUNCTION__, path];
    else if (path.length)
    {
		path = [path stringByStandardizingPath];
        NSString * oldPATH = [self.environment objectForKey:iTM2TaskPATHKey];
        NSMutableArray * oldPCs = [[[(oldPATH? oldPATH:@"") componentsSeparatedByString:@":"] mutableCopy] autorelease];
        [oldPCs removeObject:path];
		if (![path hasPrefix:iTM2PathComponentsSeparator] && ![path hasPrefix:@"."])
		{
			path = [@"." stringByAppendingPathComponent:path];
			[oldPCs removeObject:path];
		}
        NSMutableArray * PCs = [NSMutableArray arrayWithObject:path];
        [PCs addObjectsFromArray:oldPCs];
        [self.environment setObject:[PCs componentsJoinedByString:@":"] forKey:iTM2TaskPATHKey];
		if (iTM2DebugEnabled>999)
		{
			LOG4iTM3(@"The component %@ has been prepended to PATH, the result is: %@", path, [self.environment objectForKey:iTM2TaskPATHKey]);
		}
    }
	else if (iTM2DebugEnabled)
	{
		LOG4iTM3(@"Ignoring PATH component: %@", path);
	}
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  currentDirectoryPath
- (NSString *)currentDirectoryPath;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return iVarCurrentDirectoryPath;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setCurrentDirectoryPath:
- (void)setCurrentDirectoryPath:(NSString *)argument;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (argument && ![argument isKindOfClass:[NSString class]])
        [NSException raise:NSInvalidArgumentException format:@"%@ NSString argument expected:got %@.",
            __iTM2_PRETTY_FUNCTION__, argument];
    else if (![argument pathIsEqual4iTM3:iVarCurrentDirectoryPath])
        [IMPLEMENTATION takeMetaValue:[[argument copy] autorelease] forKey:iTM2TaskCurrentDirectoryPathKey];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  terminationStatus
- (NSInteger)terminationStatus;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return iVarTerminationStatus;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setTerminationStatus:
- (void)setTerminationStatus:(NSInteger)argument;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [IMPLEMENTATION takeMetaValue:[NSNumber numberWithInteger:argument] forKey:iTM2TaskTerminationStatusKey];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  context4iTM3Manager
- (id)context4iTM3Manager;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return self.delegate?:[super context4iTM3Manager];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  taskWillLaunch:
- (void)taskWillLaunch:(iTM2TaskController *)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
#warning THE TEX PROJECT MUST OVERRIDE THIS METHOD TO ADD ITS OWN STUFF
//LOG4iTM3(@"complete self.environment:%@", self.environment);
	id context4iTM3Manager = ((id)self.delegate?:((id)sender?:(id)SUD));
    [self prependPATHComponent:[context4iTM3Manager context4iTM3ValueForKey:iTM2PATHPrefixKey domain:iTM2ContextAllDomainsMask ROR4iTM3]];
    [self appendPATHComponent:[context4iTM3Manager context4iTM3ValueForKey:iTM2PATHDomainX11BinariesKey domain:iTM2ContextAllDomainsMask ROR4iTM3]];
    [self appendPATHComponent:[context4iTM3Manager context4iTM3ValueForKey:iTM2PATHSuffixKey domain:iTM2ContextAllDomainsMask ROR4iTM3]];
    [self setEnvironmentString:NSBundle.mainBundle.defaultWritableFolderURL4iTM3.path forKey:@"iTM2WritableFolderPATH"];
    id truc = self;
    NSInvocation * I = [self.implementation metaValueForKey:iTM2TaskLaunchInvocationKey];
    [I setArgument:&truc atIndex:2];
    [I setArgument:&sender atIndex:3];
	[[sender retain] autorelease];
    [I invoke];
    id ghost = nil;
    [I setArgument:&ghost atIndex:2];// release
    [I setArgument:&ghost atIndex:3];// release
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  taskDidTerminate:
- (void)taskDidTerminate:(iTM2TaskController *)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    id truc = self;
    NSInvocation * I = [self.implementation metaValueForKey:iTM2TaskTerminateInvocationKey];
    [I setArgument:&truc atIndex:2];
    [I setArgument:&sender atIndex:3];
	[[sender retain] autorelease];
    [I invoke];
    id ghost = nil;
    [I setArgument:&ghost atIndex:2];// release
    [I setArgument:&ghost atIndex:3];// release
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  taskInterruptIfNeeded:
- (void)taskInterruptIfNeeded:(iTM2TaskController *)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    id truc = self;
    NSInvocation * I = [self.implementation metaValueForKey:iTM2TaskInterruptInvocationKey];
    [I setArgument:&truc atIndex:2];
    [I setArgument:&sender atIndex:3];
	[[sender retain] autorelease];
    [I invoke];
    id ghost = nil;
    [I setArgument:&ghost atIndex:2];// release
    [I setArgument:&ghost atIndex:3];// release
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  canInterruptTask
- (BOOL)canInterruptTask;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [self.implementation metaValueForKey:iTM2TaskInterruptInvocationKey] != nil || [[self.implementation metaValueForKey:iTM2TaskCanInterruptKey] boolValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  modalStatusAndOutput:error:
- (NSInteger)modalStatusAndOutput:(NSString **)outputPtr error:(NSError **)RORef;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    iTM2TaskController * TC = [[[iTM2TaskController alloc] init] autorelease];
    [TC addTaskWrapper:self];
	[self.implementation takeMetaValue:[NSNumber numberWithBool:YES] forKey:iTM2TaskCanInterruptKey];
	[TC setDeaf:YES];// no input pipe
    [TC start];
	[TC waitUntilExit];
//LOG4iTM3(@"[TC output]:%@",[TC output]);
	OUTERROR4iTM3(1,([TC errorStatus]),nil);
    if (outputPtr)
        *outputPtr = [TC output];
    return [[TC currentTask] terminationStatus];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  modalStatusOfScript:output:error:
+ (NSInteger)modalStatusOfScript:(NSString *)script output:(NSString **)outputPtr error:(NSError **)RORef;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    iTM2TaskWrapper * TW = [[[iTM2TaskWrapper alloc] init] autorelease];
    [TW setLaunchURL:[NSURL fileURLWithPath:@"/bin/sh"]];
    iTM2TaskController * TC = [[[iTM2TaskController alloc] init] autorelease];
    [TC addTaskWrapper:TW];
    [TC start];
    [TC execute:script];
    [TC execute:@"exit"];
    [TC waitUntilExit];
	OUTERROR4iTM3(2,([TC errorStatus]),nil);
    if (outputPtr)
        *outputPtr = [TC output];
    return [[TC currentTask] terminationStatus];
}
#if 0
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  release
- (void)release;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//LOG4iTM3(@"RELEASE = %i", self.retainCount-1);
    [super release];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  retain;
- (id)retain;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//LOG4iTM3(@"RETAIN = %i", self.retainCount+1);
    return [super retain];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  autorelease;
- (id)autorelease;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//LOG4iTM3(@"AUTORELEASE = %i", self.retainCount);
    return [super autorelease];
}
#endif
@end

@implementation iTM2TaskControllerResponder
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleTaskControllerDeaf:
- (IBAction)toggleTaskControllerDeaf:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self takeContext4iTM3Bool:![self context4iTM3BoolForKey:iTM2TaskControllerIsDeafKey domain:iTM2ContextAllDomainsMask] forKey:iTM2TaskControllerIsDeafKey domain:iTM2ContextAllDomainsMask];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleTaskControllerDeaf:
- (BOOL)validateToggleTaskControllerDeaf:(NSMenuItem *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    sender.state=[self context4iTM3BoolForKey:iTM2TaskControllerIsDeafKey domain:iTM2ContextAllDomainsMask]? NSOnState:NSOffState;
	return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleTaskControllerMute:
- (IBAction)toggleTaskControllerMute:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self takeContext4iTM3Bool:![self context4iTM3BoolForKey:iTM2TaskControllerIsMuteKey domain:iTM2ContextAllDomainsMask] forKey:iTM2TaskControllerIsMuteKey domain:iTM2ContextAllDomainsMask];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleTaskControllerMute:
- (BOOL)validateToggleTaskControllerMute:(NSMenuItem *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    sender.state = [self context4iTM3BoolForKey:iTM2TaskControllerIsMuteKey domain:iTM2ContextAllDomainsMask]? NSOnState:NSOffState;
	return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleTaskControllerBlind:
- (IBAction)toggleTaskControllerBlind:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self takeContext4iTM3Bool:![self context4iTM3BoolForKey:iTM2TaskControllerIsBlindKey domain:iTM2ContextAllDomainsMask] forKey:iTM2TaskControllerIsBlindKey domain:iTM2ContextAllDomainsMask];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleTaskControllerBlind:
- (BOOL)validateToggleTaskControllerBlind:(NSMenuItem *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    sender.state = [self context4iTM3BoolForKey:iTM2TaskControllerIsBlindKey domain:iTM2ContextAllDomainsMask]? NSOnState:NSOffState;
	return YES;
}
@end
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2TaskController

@implementation NSResponder(iTM2TaskKit)
- (NSString *)stringByExecutingScriptAtURL4iTM3:(NSURL *)scriptURL;
{
	if (iTM2DebugEnabled) {
		LOG4iTM3(@"Executing script at path:%@",scriptURL.path);
	}
	NSAppleScript * AS = [[[NSAppleScript alloc] initWithContentsOfURL:scriptURL error:nil] autorelease];
	if (AS) {
		NSDictionary * errorInfo = nil;
		//NSAppleEventDescriptor * descriptor = 
		NSAppleEventDescriptor * descriptor = [AS executeAndReturnError:&errorInfo];
		if (errorInfo) {
			LOG4iTM3(@"errorInfo is:%@",errorInfo);
			NSString * message = [errorInfo objectForKey:NSAppleScriptErrorMessage];
			REPORTERROR4iTM3(1,message,nil);
		}
		return [descriptor stringValue];
	}
	if ([DFM isExecutableFileAtPath:scriptURL.path]) {
		iTM2TaskWrapper * TW = [[[iTM2TaskWrapper alloc] init] autorelease];
		[TW setLaunchURL:scriptURL];
		NSError * localError = nil;
		NSString * output = nil;
		//int status = 
		[TW modalStatusAndOutput:&output error:&localError];
		if (localError) {
			[NSApp presentError:localError];
		}
		return output;
	}
	return nil;
}
- (void)executeAsScript:(id)sender;
{
	NSString * script = [sender insertion];
	// is it a lua script?
	ICURegEx * RE = [ICURegEx regExForKey:@"^#!\\S*/([^/\\s]+)" error:NULL];
	if ([RE matchString:script]) {
		NSString * shell = [RE substringOfCaptureGroupAtIndex:1];// the length is at least 1 but we force it
        [RE forget];
		NSAssert(shell.length>ZER0,@"Bad programing, a regular expression does not gove the expected result, report BUG or FIX ME (code 78355)");
		NSString * selName = [NSString stringWithFormat:@"executeAs%@Script:",shell.capitalizedString];
		SEL selector = NSSelectorFromString(selName);
		if ([self respondsToSelector:selector]) {
			[self performSelector:selector withObject:script];
			return;
		}
	}
    RE = nil;
	// save the script somewhere
	NSURL * url = [[NSBundle mainBundle].temporaryBinaryDirectoryURL4iTM3 URLByAppendingPathComponent:@"macro_script"];
	NSError * error = nil;
	if ([script writeToURL:url atomically:NO encoding:NSUTF8StringEncoding error:&error]) {
		// make it executable
		NSNumber * permission = [NSNumber numberWithUnsignedInteger:S_IRWXU];
		NSDictionary * attributes = [NSDictionary dictionaryWithObject:permission forKey:NSFilePosixPermissions];
		if ([DFM setAttributes:attributes ofItemAtPath:url.path error:NULL]) {
			[self executeScriptAtPath:url.path];
		} else {
			REPORTERROR4iTM3(1,([NSString stringWithFormat:@"Could not set posix permission at\n%@",url]),nil);
		}
	} else if (error) {
		[NSApp performSelectorOnMainThread:@selector(presentError:) withObject:error waitUntilDone:NO];
	}
	return;
}
- (void)executeScriptAtPath:(NSString *)scriptPath;// or iTM2MacroNode, bad design
{
#warning THIS MUST BE REVISITED because the url is not managed properly
	if ([scriptPath isKindOfClass:[iTM2MacroNode class]]) {
		scriptPath = [(iTM2MacroNode *)scriptPath macroID];
	}
	NSWindow * W = [NSApp keyWindow];
	id FR = W.firstResponder;
	if ([DFM fileExistsAtPath:scriptPath]) {
		[FR executeMacroWithText4iTM3:[FR stringByExecutingScriptAtURL4iTM3:[NSURL fileURLWithPath:scriptPath isDirectory:NO]]];//delayed?
		return;
	}
	NSString * subpath = [[self.macroDomain stringByAppendingPathComponent:self.macroCategory]
							stringByAppendingPathComponent:iTM2MacroScriptsComponent];
	for (NSURL * url in [[[NSBundle mainBundle] allURLsForResource4iTM3:iTM2MacrosDirectoryName withExtension:iTM2LocalizedExtension] reverseObjectEnumerator]) {
		if (url.isFileURL && [DFM pushDirectory4iTM3:url.path]) {
			if ([DFM pushDirectory4iTM3:subpath]) {
				NSString * path = [DFM currentDirectoryPath];
				path = [path stringByAppendingPathComponent:scriptPath];
				if ([DFM fileExistsAtPath:scriptPath]) {
					[FR executeMacroWithText4iTM3:[FR stringByExecutingScriptAtURL4iTM3:[NSURL fileURLWithPath:scriptPath isDirectory:NO]]];//delayed?
					[DFM popDirectory4iTM3];[DFM popDirectory4iTM3];
					return;
				}
				[DFM popDirectory4iTM3];
			} else if ([DFM fileExistsAtPath:subpath isDirectory:nil]) {
				LOG4iTM3(@"*** SILENT Error: could not push \"%@/%@\"",[DFM currentDirectoryPath],subpath);
			}
			[DFM popDirectory4iTM3];
		} else {
			LOG4iTM3(@"*** SILENT Error: could not push \"%@\"",url);
		}
	}
    LOG4iTM3(@"*** SILENT Error: could not execute script at \"%@\"",scriptPath);
}
- (void)executeScriptAtURL:(NSURL *)scriptURL;// or iTM2MacroNode, bad design
{
    if (scriptURL.isFileURL) {
        [self executeScriptAtPath:scriptURL.path];
    }
}
@end

@implementation NSTextView(iTM2TaskKit)
- (NSString *)stringByExecutingScriptAtURL4iTM3:(NSURL *)scriptURL;
{
	if (iTM2DebugEnabled) {
		LOG4iTM3(@"Executing script at:%@",scriptURL);
	}
	NSAppleScript * AS = [[[NSAppleScript alloc] initWithContentsOfURL:scriptURL error:nil] autorelease];
	if (AS) {
		NSDictionary * errorInfo = nil;
		//NSAppleEventDescriptor * descriptor = 
		NSAppleEventDescriptor * descriptor = [AS executeAndReturnError:&errorInfo];
		if (errorInfo) {
			LOG4iTM3(@"errorInfo is:%@",errorInfo);
			NSString * message = [errorInfo objectForKey:NSAppleScriptErrorMessage];
			REPORTERROR4iTM3(1,message,nil);
		}
		return [descriptor stringValue];
	}
	NSError * localError = nil;
	NSString * script = [[[NSString alloc] initWithContentsOfURL:scriptURL encoding:NSUTF8StringEncoding error:&localError] autorelease];
	if (script.length) {
		NSString * selection = nil;//[self preparedSelectedStringForMacroInsertion];
		NSString * line = nil;//[self preparedSelectedLineForMacroInsertion];
		script = [self concreteReplacementStringForMacro4iTM3:script selection:selection line:line];
#warning THIS IS BUGGY
		NSString * scriptPath = [[NSProcessInfo processInfo] globallyUniqueString];
		NSURL * url = [[NSBundle mainBundle].temporaryDirectoryURL4iTM3 URLByAppendingPathComponent:scriptPath];
		if ([script writeToURL:url atomically:YES encoding:NSUTF8StringEncoding error:&localError]) {
			NSNumber * permissions = [NSNumber numberWithInteger:S_IRWXU];
			NSDictionary * attributes = [NSDictionary dictionaryWithObject:permissions forKey:NSFilePosixPermissions];
			if ([DFM setAttributes:attributes ofItemAtPath:url.path error:NULL]) {
				iTM2TaskWrapper * TW = [[[iTM2TaskWrapper alloc] init] autorelease];
				[TW setLaunchURL:url];
				NSString * macro = nil;
				//int status = [TW modalStatusAndOutput:&output error:&localError];
				[TW modalStatusAndOutput:&macro error:&localError];
				if (localError) {
					[NSApp presentError:localError];
				}
				return macro;
			} else {
				REPORTERROR4iTM3(1,([NSString stringWithFormat:@"Problem: Cannot set permission at %@",scriptPath]),nil);
                [DFM removeItemAtURL:url error:NULL];
			}
		} else if (localError) {
			LOG4iTM3(@"localError:%@",localError);
			LOG4iTM3(@"url:%@",url);
			[NSApp presentError:localError];
		}
	} else if (localError) {
		[NSApp presentError:localError];
	}
	return @"";
}
@end