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

#import <iTM2Foundation/iTM2TaskKit.h>
#import <iTM2Foundation/iTM2PathUtilities.h>
#import <iTM2Foundation/iTM2InstallationKit.h>
#import <iTM2Foundation/iTM2Implementation.h>
#import <iTM2Foundation/iTM2DocumentKit.h>
#import <iTM2Foundation/iTM2WindowKit.h>
#import <iTM2Foundation/iTM2ContextKit.h>
#import <iTM2Foundation/iTM2BundleKit.h>
#import <iTM2Foundation/iTM2DistributedObjectKit.h>
#import <iTM2Foundation/iTM2CursorKit.h>

NSString * const iTM2TaskControllerIsDeafKey = @"iTM2TaskControllerIsDeaf";
NSString * const iTM2TaskControllerIsMuteKey = @"iTM2TaskControllerIsMute";
NSString * const iTM2TaskControllerIsBlindKey = @"iTM2TaskControllerIsBlind";

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2TaskInspector
/*"This object manages the UI of the task controller."*/
@implementation iTM2TaskInspector
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= windowFrameIdentifier
- (NSString *)windowFrameIdentifier;
/*"Subclasses should override this method. The default implementation returns a 0 length string, and deactivates the 'register current frame' process.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri May 21 07:52:07 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return @"Task Window";
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= windowPositionShouldBeObserved
- (BOOL)windowPositionShouldBeObserved;
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri May 21 07:52:07 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  cleanLog:
- (void)cleanLog:(id)sender;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/11/01)
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [[self outputView] setString:@""];
    [[self errorView] setString:@""];
    return;
}
#pragma mark =-=-=-=-=-=-  OUTPUT
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  outputView
- (id)outputView;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/11/01)
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSTextView * TV = metaGETTER;
    if(!TV)
    {
        [self window];
        TV = metaGETTER;
    }
    return TV;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setOutputView:
- (void)setOutputView:(NSTextView *)argument;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/11/01)
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(argument && ![argument isKindOfClass:[NSTextView class]])
        [NSException raise:NSInvalidArgumentException format:@"%@ NSTextView class expected, got:%@.",
            __iTM2_PRETTY_FUNCTION__, argument];
    else
    {
        NSTextView * old = metaGETTER;
        if(old != argument)
        {
            [old setDelegate:nil];
            metaSETTER(argument);
            [argument setDelegate:self];// used for clickedAtIndex:
			[argument setTypingAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
				[NSFont userFixedPitchFontOfSize:[NSFont systemFontSize]], NSFontAttributeName, nil]];
        }
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSTextView * TV = [self outputView];
	NSScroller * S = [[TV enclosingScrollView] verticalScroller];
	float old = [S floatValue];
    NSTextStorage * TS = [TV textStorage];
    [TS beginEditing];
    [[TS mutableString] appendString:argument];
    [TS endEditing];
	if(old>=1.0)
		[TV scrollRangeToVisible:NSMakeRange([TS length], 0)];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  outputDidTerminate
- (void)outputDidTerminate;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/11/01)
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self logOutput:@"\niTM2:task terminated"];
//iTM2_END;
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self logOutput:argument];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  customDidTerminate
- (void)customDidTerminate;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/11/01)
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return;
}
#pragma mark =-=-=-=-=-=-  ERROR
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  errorView
- (id)errorView;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/11/01)
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSTextView * TV = metaGETTER;
    if(!TV)
    {
        [self window];
        TV = metaGETTER;
    }
    return TV;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setErrorView:
- (void)setErrorView:(NSTextView *)argument;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/11/01)
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(argument && ![argument isKindOfClass:[NSTextView class]])
        [NSException raise:NSInvalidArgumentException format:@"%@ NSTextView class expected, got:%@.",
            __iTM2_PRETTY_FUNCTION__, argument];
    else
    {
        NSTextView * old = metaGETTER;
        if(old != argument)
        {
            metaSETTER(argument);
            [argument setDelegate:self];// used for clickedAtIndex:
			[argument setTypingAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
				[NSFont userFixedPitchFontOfSize:[NSFont systemFontSize]], NSFontAttributeName, nil]];
        }
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSTextView * TV = [self errorView];
    NSRange R;
    NSTextStorage * TS = [TV textStorage];
    R.location = [TS length];
    [TS beginEditing];
    [[TS mutableString] appendString:argument];
    R.length = [TS length] - R.location;
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return;
}
#pragma mark =-=-=-=-=-  TASK
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  taskController
- (id)taskController;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [metaGETTER nonretainedObjectValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setTaskController:
- (void)setTaskController:(iTM2TaskController *)argument;
/*"Description Forthcoming. The task controller si not owned.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(argument && ![argument isKindOfClass:[iTM2TaskController class]])
        [NSException raise:NSInvalidArgumentException format:
            @"%@ iTM2TaskController argument expected: got %@.",
                __iTM2_PRETTY_FUNCTION__, argument];
    else
    {
        iTM2TaskController * oldTC = [metaGETTER nonretainedObjectValue];
        if(![argument isEqual:oldTC])
        {
            metaSETTER((argument? [NSValue valueWithNonretainedObject:argument]:nil));
            [oldTC removeInspector:self];
            [argument addInspector:self];
        }
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= taskWillLaunch
- (void)taskWillLaunch;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/11/01)
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= taskDidTerminate
- (void)taskDidTerminate;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/11/01)
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//    [self logCustom:@"\n<iTM2Comment>Task terminated</iTM2Comment>"];// to be changed, some widget should change
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= execute:
- (void)execute:(NSString *)aCommand;
/*"Description Forthcoming. Rough input, no verification.
Version History: jlaurens AT users DOT sourceforge DOT net (09/11/01)
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[[self taskController] execute:aCommand];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= cancel:
- (void)cancel:(NSString *)cancel;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/11/01)
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[(iTM2TaskController *)[self taskController] stop];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initImplementation:
- (void)initImplementation;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/11/01)
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self logOutput:argument];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  updateOutputAndError:
- (void)updateOutputAndError:(id)irrelevant;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/11/01)
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return;
}
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2TaskInspector


@implementation iTM2TaskWindow
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2TaskController

#import	"iTM2BundleKit.h"
#import	<sys/fcntl.h>
#import	<sys/stat.h>
#import <sys/file.h>
#import <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>

/*
NSString * const iTM2ServerConversationIDKey = @"ConversationID";
NSString * const iTM2ServerCommentsKey = @"Comments";
NSString * const iTM2ServerWarningsKey = @"Warnings";
NSString * const iTM2ServerErrorsKey = @"Errors";
NSString * const iTM2ServerComwarnerNotification = @"iTM2ServerComwarnerNotification";
*/
@implementation iTM2TaskController
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  init
- (id)init;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(self = [super init])
    {
        [[self implementation] takeMetaValue:[NSMutableArray array] forKey:@"_Wrappers"];
        [[self implementation] takeMetaValue:[[NSProcessInfo processInfo] globallyUniqueString] forKey:@"_Conversation"];
        [[self implementation] takeMetaValue:[NSMutableArray array] forKey:@"_Inspectors"];
        // NSMutableArray * _Inspectors = [[self implementation] metaValueForKey:@"_Inspectors"];
        _Inspectors = [[NSMutableArray array] retain];
        _FHGC = [[NSMutableArray array] retain];
        _NGC = [[NSMutableArray array] retain];
        _CustomReadFileHandle = nil;
		_Standalone = NO;
    }
    return self;
}
#if 0
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  retain
- (id)retain;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
	iTM2_LOG(@"=-=-=-=-=-=-=-=-=-=-  $$$  [self retainCount] is now:%i", [self retainCount] + 1);
	return [super retain];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  release
- (void)release;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
	iTM2_LOG(@"=-=-=-=-=-=-=-=-=-=-  $$$  [self retainCount] is now:%i", [self retainCount] - 1);
	[super release];
	return;
}
#endif
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  dealloc
- (void)dealloc;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
printf("%s %#x\n", __PRETTY_FUNCTION__, self);
    [DNC removeObserver:self];
    [[self allInspectors] makeObjectsPerformSelector:@selector(setTaskController:) withObject:nil];
    [_Inspectors release];
    _Inspectors = nil;
    [_FHGC release];
    _FHGC = nil;
    NSEnumerator * E = [_NGC objectEnumerator];
    NSString * path;
    while(path = [E nextObject])
        if([DFM removeFileAtPath:path handler:NULL])
            [DFM removeFileAtPath:[path stringByDeletingLastPathComponent] handler:NULL];
    [_NGC release];
    _NGC = nil;
    [_Error autorelease];
    _Error = nil;
    [_Output autorelease];
    _Output = nil;
    [_Custom autorelease];
    _Custom = nil;
    _CustomReadFileHandle = nil;// if not nil, a task has run and we are still listening to the output
    [self stop];
//iTM2_END;
    [super dealloc];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  currentTask
- (NSTask *)currentTask;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return _CurrentTask;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  isDeaf
- (BOOL)isDeaf;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [self contextBoolForKey:iTM2TaskControllerIsDeafKey domain:iTM2ContextAllDomainsMask];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setDeaf:
- (void)setDeaf:(BOOL)yorn;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self takeContextBool:yorn forKey:iTM2TaskControllerIsDeafKey domain:iTM2ContextAllDomainsMask];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  isMute
- (BOOL)isMute;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [self contextBoolForKey:iTM2TaskControllerIsMuteKey domain:iTM2ContextAllDomainsMask];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setMute:
- (void)setMute:(BOOL)yorn;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self takeContextBool:yorn forKey:iTM2TaskControllerIsMuteKey domain:iTM2ContextAllDomainsMask];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  isBlind
- (BOOL)isBlind;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [self contextBoolForKey:iTM2TaskControllerIsBlindKey domain:iTM2ContextAllDomainsMask];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setBlind:
- (void)setBlind:(BOOL)yorn;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self takeContextBool:yorn forKey:iTM2TaskControllerIsBlindKey domain:iTM2ContextAllDomainsMask];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  currentWrapper
- (id <iTM2TaskWrapper>)currentWrapper;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return _CurrentWrapper;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  addInspector:
- (void)addInspector:(id <iTM2TaskInspector>)argument;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//NSLog(@"argument: %@", argument);
    if(argument)
    {
        if(![argument conformsToProtocol:@protocol(iTM2TaskInspector)])
            [NSException raise:NSInvalidArgumentException format:@"%@ protocol iTM2TaskInspector argument expected:got %@.",
                __iTM2_PRETTY_FUNCTION__, argument];
        else
        {
            NSValue * V = [NSValue valueWithNonretainedObject:argument];
            if(V && ![_Inspectors containsObject:V])
            {
                [_Inspectors addObject:V];
                [argument setTaskController:self];
                [argument logOutput:[self output]];
                [argument logError:[self errorStatus]];
            }
        }
    }
//NSLog(@"_Inspectors: %@", _Inspectors);
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  removeInspector:
- (void)removeInspector:(id <iTM2TaskInspector>)argument;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSValue * V = [NSValue valueWithNonretainedObject:argument];
    if([_Inspectors containsObject:V])
    {
        [argument setTaskController:nil];
        [_Inspectors removeObject:V];
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inspectorsEnumerator
- (NSEnumerator *)inspectorsEnumerator;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSMutableArray * MRA = [NSMutableArray array];
    NSEnumerator * E = [_Inspectors objectEnumerator];
    id O;
    while(O = [[E nextObject] nonretainedObjectValue])
	{
        [MRA addObject:O];
	}
    return [MRA objectEnumerator];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  allInspectors
- (NSArray *)allInspectors;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSMutableArray * MRA = [NSMutableArray array];
    NSEnumerator * E = [_Inspectors objectEnumerator];
    id O;
    while(O = [[E nextObject] nonretainedObjectValue])
	{
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(![argument isKindOfClass:[iTM2TaskWrapper class]])
        [NSException raise:NSInvalidArgumentException format:@"%@ iTM2TaskWrapper argument expected:got %@.",
            __iTM2_PRETTY_FUNCTION__, argument];
    else
    {
        [[[self implementation] metaValueForKey:@"_Wrappers"] addObject:argument];
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  restartWithTaskWrapper:
- (void)restartWithTaskWrapper:(iTM2TaskWrapper *)argument;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self flush];
    [self addTaskWrapper:argument];
    [self start];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  removeTaskWrapper:
- (void)removeTaskWrapper:(id <iTM2TaskWrapper>)argument;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(![argument isKindOfClass:[iTM2TaskWrapper class]])
        [NSException raise:NSInvalidArgumentException format:@"%@ iTM2TaskWrapper argument expected:got %@.",
            __iTM2_PRETTY_FUNCTION__, argument];
    else if([argument isEqual:_CurrentWrapper])
    {
        [_CurrentWrapper release];
        _CurrentWrapper = nil;
        // now we terminate the current task
        if([_CurrentTask isRunning])
            [_CurrentTask terminate];
        [_CurrentTask dealloc];
        _CurrentTask = nil;
    }
    else
    {
        [[[self implementation] metaValueForKey:@"_Wrappers"] removeObject:argument];
    }
    [self start];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= stop
- (void)stop;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/11/01)
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [DNC removeObserver:self name:NSFileHandleDataAvailableNotification object:nil];
    [DNC removeObserver:self name:NSTaskDidTerminateNotification object:nil];
    if([_CurrentTask isRunning])
        [_CurrentTask terminate];
    [_CurrentTask release];
    _CurrentTask = nil;
    [_CurrentWrapper release];
    _CurrentWrapper = nil;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= start
- (void)start;
/*"Launching the firts available task in the task stack. Connets the I/O, registers the receiver to the default notification center.
Version History: jlaurens AT users DOT sourceforge DOT net (09/11/01)
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_LOG(@"0");
    if(_CurrentWrapper)
	{
		if(iTM2DebugEnabled)
		{
			iTM2_LOG(@"task already running: %@", _CurrentTask);
		}
        return;
	}
//iTM2_LOG(@"1");
    NSMutableArray * _Wrappers = [[self implementation] metaValueForKey:@"_Wrappers"];
    if(![_Wrappers count])
    {
//#warning CLEAN THE FIFO!!!???
		if(iTM2DebugEnabled)
		{
			iTM2_LOG(@"Nothing to start.");
		}
		if(_Standalone)
		{
//iTM2_LOG(@"Standalone: autorelease");
			[self autorelease];
		}
		if([_CurrentTask isRunning])
		{
			[_CurrentTask terminate];
		}
		[_CurrentTask release];
		_CurrentTask = nil;
		[_CurrentWrapper release];
		_CurrentWrapper = nil;
        return;
    }
//iTM2_LOG(@"2");
    if([_CurrentTask isRunning])
	{
        [_CurrentTask terminate];
	}
    NSFileHandle * FH;
    if(FH = [[_CurrentTask standardOutput] fileHandleForReading])
        [DNC removeObserver:self name:NSFileHandleDataAvailableNotification object:FH];
    if(FH = [[_CurrentTask standardError] fileHandleForReading])
        [DNC removeObserver:self name:NSFileHandleDataAvailableNotification object:FH];
    _CustomReadFileHandle = nil;// not retained, only garbage collected
    if(_CurrentTask)
        [DNC removeObserver:self name:NSTaskDidTerminateNotification object:_CurrentTask];
    [_CurrentTask release];
    _CurrentTask = nil;
    [_CurrentWrapper release];
    _CurrentWrapper = nil;
//iTM2_LOG(@"3");

    NSMutableDictionary * environment = [[[[NSProcessInfo processInfo] environment] mutableCopy] autorelease];

    NSLock * L = [[[NSLock alloc] init] autorelease];
    [L lock];
    _CurrentWrapper = [[_Wrappers objectAtIndex:0] retain];
    [_Wrappers removeObjectAtIndex:0];
    [L unlock];

    _CurrentTask = [[NSTask alloc] init];
//iTM2_LOG(@"4");

	// standard output and error:
    if([self isMute])
	{
        [_CurrentTask setStandardOutput:[NSFileHandle fileHandleWithNullDevice]];
		[_CurrentTask setStandardError:[NSFileHandle fileHandleWithNullDevice]];
	}
	else
	{
        [_CurrentTask setStandardOutput:[NSPipe pipe]];
		[_CurrentTask setStandardError:[NSPipe pipe]];
		if(FH = [[_CurrentTask standardOutput] fileHandleForReading])
		{
			[DNC addObserver:self
				selector: @selector(_outputDataAvailableNotified:)
					name: NSFileHandleDataAvailableNotification
						object: FH];
			[FH waitForDataInBackgroundAndNotify];
		}
		if(FH = [[_CurrentTask standardError] fileHandleForReading])
		{
			[DNC addObserver:self
				selector: @selector(_errorDataAvailableNotified:)
					name: NSFileHandleDataAvailableNotification
						object: FH];
			[FH waitForDataInBackgroundAndNotify];
		}
	}
//iTM2_LOG(@"1");
	// standard input
	[_CurrentTask setStandardInput:([self isDeaf]?
		[NSFileHandle fileHandleWithNullDevice]:
			[NSPipe pipe])];
//iTM2_LOG(@"2");
    
#if 0
	This was tested, but does not work properly
    [_CustomWriteFileHandle release];
    _CustomWriteFileHandle = nil;
    
    char name[12];
    strcpy(name, "/dev/pty??");

    static char	ptychar[] = "pqrstuvw";
    static char	ptyhexa[] = "0123456789abcdef";

    int i;
    for (i = 0; i < strlen(ptychar); i++)
    {
        strcpy(name, "/dev/ptyXY");
        name[8] = ptychar[i];
        int j;
        for (j = 0; j < strlen(ptyhexa); j++)
        {
            name[9] = ptyhexa[j];
//iTM2_LOG(@"Trying to open file: %s", name);
            int master_fd = open(name, O_RDWR);
            if (master_fd >= 0)
            {
                name[5] = 't';	/* change "/dev/pty??" to "/dev/tty??" */
                int slave_fd  = open(name, O_RDWR);
                if(slave_fd<0)
                    close(master_fd);
                else
                {
                    _CustomReadFileHandle = [[NSFileHandle allocWithZone:[self zone]]
                        initWithFileDescriptor: master_fd closeOnDealloc: YES];
                    _CustomWriteFileHandle = [[NSFileHandle allocWithZone:[self zone]]
                        initWithFileDescriptor: slave_fd closeOnDealloc: YES];
                    [environment setObject:[NSString stringWithCString:name] forKey:@"iTM2_Device"];
                    if(FH = _CustomReadFileHandle)
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
                    iTM2_LOG(@"***  BAD CONNECTION, exception catched %@", [localException reason]);
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
    [environment setObject:[NSString stringWithCString:"/dev/null"] forKey:@"iTM2_Device"];
    iTM2Beep();
    iTM2_LOG(@"There is no custom pipe available... iTeXMac2 will not completely work as expected");
    followMe:
#elif 0
	this was tested and raised problems for "temporary ... unsvailable" NSException
	The garbage collector is not well implemented because it does not remove the FH when exception are raised
	The _FHGC _NGC pair should be replaced by a dictionary
    if(!_CustomReadFileHandle)
    {
        iTM2_INIT_POOL;
        int fireWall = 256;
        while(fireWall--)
        {
            NSString * path = [[NSBundle temporaryUniqueDirectory] stringByAppendingPathComponent:@"FIFO"];
            char * FSR = (char *)[path fileSystemRepresentation];
            if(iTM2DebugEnabled)
            {
                iTM2_LOG(@"FIFO communication channel is: %@", path);
            }
            if(mkfifo(FSR, S_IRUSR | S_IWUSR))
                break;
            int fd = open(FSR, O_RDONLY | O_NONBLOCK);
            if(fd)
            {
                _CustomReadFileHandle = [[[NSFileHandle allocWithZone:[self zone]] initWithFileDescriptor:fd closeOnDealloc:YES] autorelease];
                [_FHGC addObject:_CustomReadFileHandle];
                [_NGC addObject:path];
                [DNC addObserver:self
                    selector: @selector(_customDataAvailableNotified:)
                        name: NSFileHandleDataAvailableNotification
                            object: _CustomReadFileHandle];
                [_CustomReadFileHandle waitForDataInBackgroundAndNotify];
                [environment setObject:path forKey:@"iTM2_Device"];
                goto theEnd;
            }
            else
                break;
        }
        iTM2_LOG(@"No FIFO available: communication of shell scripts with iTeXMac2 through FIFO is compromised...");
        theEnd:
        iTM2_RELEASE_POOL;
    }
#endif
    [DNC addObserver:self
        selector: @selector(_currentTaskDidTerminate:) 
            name: NSTaskDidTerminateNotification
                object: _CurrentTask];

//iTM2_LOG(@"3");
    [[self allInspectors] makeObjectsPerformSelector:@selector(taskWillLaunch)];
    
    if(!_Output)
        _Output = [[NSMutableString string] retain];
    if(!_Custom)
        _Custom = [[NSMutableString string] retain];
    if(!_Error)
        _Error = [[NSMutableString string] retain];

//iTM2_LOG(@"4");
    [_CurrentWrapper taskWillLaunch:self];
    [environment setObject:[[self implementation] metaValueForKey:@"_Conversation"] forKey:@"iTM2_Conversation"];
    [environment setObject:NSHomeDirectory() forKey:@"iTM2_HOME"];
    [environment setObject:[NSBundle temporaryDirectory] forKey:@"iTM2_TemporaryDirectory"];
//NSLog(@"[_CurrentWrapper launchPath]:%@", [_CurrentTask launchPath]);
    [_CurrentTask setLaunchPath:[_CurrentWrapper launchPath]];
//NSLog(@"[_CurrentTask launchPath]:%@", [_CurrentTask launchPath]);
	NSString * currentDirectory = [_CurrentWrapper currentDirectoryPath];
    if([currentDirectory length])
	{
        [_CurrentTask setCurrentDirectoryPath:currentDirectory];
	}

//iTM2_LOG(@"5");
    NSString * PATH = [[_CurrentWrapper environment] objectForKey:iTM2TaskPATHKey];
    NSString * oldPATH = [environment objectForKey:iTM2TaskPATHKey];
    [environment addEntriesFromDictionary:[_CurrentWrapper environment]];
    if([PATH length])
	{
        [environment setObject:[NSString stringWithFormat:([oldPATH hasPrefix:@":"]? @":%@%@":@":%@:%@"), PATH, oldPATH] forKey:iTM2TaskPATHKey];
	}
	[environment setObject:[NSConnection iTeXMac2ConnectionIdentifier] forKey:iTM2ConnectionIdentifierKey];
//NSLog(@"[_CurrentTask environment]:%@", [_CurrentTask environment]);
//NSLog(@"[_CurrentWrapper environment]:%@", [_CurrentWrapper environment]);
//NSLog(@"[[NSProcessInfo processInfo] environment]:%@", [[NSProcessInfo processInfo] environment]);
//NSLog(@"[[NSProcessInfo processInfo] arguments]:%@", [[NSProcessInfo processInfo] arguments]);
    if([[_CurrentWrapper arguments] count])
	{
        [_CurrentTask setArguments:[_CurrentWrapper arguments]];
	}
    [_CurrentTask setEnvironment:environment];
    [_CurrentTask launch];
	if(iTM2DebugEnabled)
	{
		iTM2_LOG(@"task: %@", _CurrentTask);
	}
//NSLog(@"_CurrentTask %@ (isRunning %@)", _CurrentTask, ([_CurrentTask isRunning]? @"Y":@"N"));
//NSLog(@"[_CurrentTask environment]:%@", [_CurrentTask environment]);
//iTM2_LOG(@"_CurrentWrapper is: %@", _CurrentWrapper);
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= becomeStandalone
- (void)becomeStandalone;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/11/01)
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(_Standalone)
		return;
	_Standalone = YES;
	[self retain];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= flush
- (void)flush;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/11/01)
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self stop];
    NSMutableArray * _Wrappers = [[self implementation] metaValueForKey:@"_Wrappers"];
    while([_Wrappers count])
        [self removeTaskWrapper:[_Wrappers lastObject]];
    [self clean];
    _CustomReadFileHandle = nil;// not retained, only garbage collected
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [_Output setString:[NSString string]];
    [_Custom setString:[NSString string]];
    [_Error setString:[NSString string]];
    [[self allInspectors] makeObjectsPerformSelector:@selector(cleanLog:) withObject:self];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= output
- (NSString *)output;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/11/01)
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	return _Output? [[_Output copy] autorelease]:[NSString string];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= custom
- (NSString *)custom;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/11/01)
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return _Custom? [[_Custom copy] autorelease]:[NSString string];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= errorStatus
- (NSString *)errorStatus;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/11/01)
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return _Error? [[_Error copy] autorelease]:[NSString string];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= _outputDataAvailableNotified:
- (void)_outputDataAvailableNotified:(NSNotification *)aNotification;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/11/01)
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSFileHandle * FH = [aNotification object];
    NSData * D = [FH availableData];
	if([D length])
	{
		NSString * string = [[[NSString alloc] initWithData:D encoding:NSUTF8StringEncoding] autorelease];
		if(![string length])
		{
			string = [[[NSString alloc] initWithData:D encoding:NSMacOSRomanStringEncoding] autorelease];
			iTM2_LOG(@"Output encoding problem.");
		}
		[self logOutput:string];
		[FH waitForDataInBackgroundAndNotify];
	}
    else
	{
		[DNC removeObserver:self name:[aNotification name] object:self];
        [[self allInspectors] makeObjectsPerformSelector:@selector(outputDidTerminate) withObject:nil];
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  logOutput:
- (void)logOutput:(NSString *)string;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/11/01)
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if([string length]>0)
    {
        [_Output appendString:string];
//NSLog(@"[self allInspectors]:%@", [self allInspectors]);
        [[self allInspectors] makeObjectsPerformSelector:_cmd withObject:string];
    }
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= _customDataAvailableNotified:
- (void)_customDataAvailableNotified:(NSNotification *)notification;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/11/01)
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
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
swap -a /swap 0 60000

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
    if(_CustomReadFileHandle == FH)
    {
		NSString * string = [[[NSString alloc] initWithData:D encoding:NSUTF8StringEncoding] autorelease];
		if([D length] && ![string length])
		{
			string = [[[NSString alloc] initWithData:D encoding:NSMacOSRomanStringEncoding] autorelease];
			iTM2_LOG(@"Output encoding problem.");
		}
        [self logCustom:string];
    }
    if([_CurrentTask isRunning] || [D length])
    {
        [FH waitForDataInBackgroundAndNotify];
        NS_VOIDRETURN;
    }
    if(_CustomReadFileHandle == FH)
    {
        [[self allInspectors] makeObjectsPerformSelector:@selector(customDidTerminate) withObject:nil];
        _CustomReadFileHandle = nil;
    }
    [_FHGC removeObject:FH];
	NS_HANDLER
	[NSApp reportException:localException];
	NS_ENDHANDLER
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  outputDidTerminate
- (void)outputDidTerminate;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/11/01)
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[[self allInspectors] makeObjectsPerformSelector:_cmd withObject:nil];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  logCustom:
- (void)logCustom:(NSString *)string;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/11/01)
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if([string length]>0)
    {
        NSMutableString * buffer = [[self implementation] metaValueForKey:@"_CustomBuffer"];
//iTM2_LOG(@"buffer: <%@>", buffer);
        NSRange R = NSMakeRange([_Custom length], 0);
        [_Custom getLineStart:&R.location end:nil contentsEnd:nil forRange:R];
        // R.location points to the beginning of the line where we are looking for iTM2 directives.
//iTM2_LOG(@"_Custom: %@", _Custom);
//iTM2_LOG(@"string: %@", string);
        [_Custom appendString:string];
        int newLength = [_Custom length];
        NSRange searchRange;
        if(buffer)
        {
CurrentModeOn:
//iTM2_LOG(@"CurrentModeOn");
            searchRange = NSMakeRange(R.location, newLength - R.location);
            if([_Custom rangeOfString:@"</applescript>" options:NSAnchoredSearch range:searchRange].length)
            {
                // we found the end of the applescript
//iTM2_LOG(@"APPLESCRIPTING: ----\n%@\n----", buffer);
                [self executeAppleScript:buffer];
                buffer = nil;
                [_Custom getLineStart:nil end:&R.location contentsEnd:nil forRange:R];
                goto CurrentModeOff;
            }
            else
            {
                int start = R.location;
                [_Custom getLineStart:nil end:&R.location contentsEnd:nil forRange:R];
                [buffer appendString:[_Custom substringWithRange:NSMakeRange(start, R.location - start)]];
//iTM2_LOG(@"buffer: <%@>", buffer);
                if(R.location < newLength)
                    goto CurrentModeOn;
            }
        }
        else
        {
            // no apple script pending...
CurrentModeOff:
//iTM2_LOG(@"CurrentModeOff");
            searchRange = NSMakeRange(R.location, newLength - R.location);
            // R.location now points to the beginning of the next line
            if([_Custom rangeOfString:@"<applescript>" options:NSAnchoredSearch range:searchRange].length)
            {
                //Ok we are starting an apple script
                // the rest of the line is ignored
                [_Custom getLineStart:nil end:&R.location contentsEnd:nil forRange:R];
                searchRange.location += [@"<applescript>" length];
                searchRange.length = R.location - searchRange.location;
                buffer = [NSMutableString stringWithString:[_Custom substringWithRange:searchRange]];
                goto CurrentModeOn;
            }
            else if(R.location < newLength)
            {
                [_Custom getLineStart:nil end:&R.location contentsEnd:nil forRange:R];
                goto CurrentModeOff;
            }
        }
        [[self implementation] takeMetaValue:buffer forKey:@"_CustomBuffer"];
        if(iTM2DebugEnabled>999)
        {
            iTM2_LOG(@"Pending AppleScript: ----\n%@\n----", buffer);
        }
    }
    else if(iTM2DebugEnabled>100)
    {
//        iTM2_LOG(@"No custom data to log out.");
        if(iTM2DebugEnabled>999)
        {
            NSMutableString * buffer = [[self implementation] metaValueForKey:@"_CustomBuffer"];
            if(buffer)
            {
                iTM2_LOG(@"Pending AppleScript: ----\n%@\n----", buffer);
            }
        }
    }
//NSLog(@"[self allInspectors]:%@", [self allInspectors]);
    [[self allInspectors] makeObjectsPerformSelector:_cmd withObject:string];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= _errorDataAvailableNotified:
- (void)_errorDataAvailableNotified:(NSNotification *)aNotification;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/11/01)
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSFileHandle * FH = [aNotification object];
    NSData * D = [FH availableData];
	if([D length])
	{
		NSString * string = [[[NSString alloc] initWithData:D encoding:NSUTF8StringEncoding] autorelease];
		if(![string length])
		{
			string = [[[NSString alloc] initWithData:D encoding:NSMacOSRomanStringEncoding] autorelease];
			iTM2_LOG(@"Output encoding problem.");
		}
		[self logError:string];
		[FH waitForDataInBackgroundAndNotify];
	}
    else
	{
		[DNC removeObserver:self name:[aNotification name] object:self];
        [[self allInspectors] makeObjectsPerformSelector:@selector(errorDidTerminate) withObject:nil];
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  logError:
- (void)logError:(NSString *)string;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/11/01)
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if([string length]>0)
    {
//NSLog(@"error string: %@", string);
        [_Error appendString:string];
        [[self allInspectors] makeObjectsPerformSelector:_cmd withObject:string];
//NSLog(@"[self errorStatus]:%@", [self errorStatus]);
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[[self allInspectors] makeObjectsPerformSelector:_cmd withObject:nil];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= _currentTaskDidTerminate:
- (void)_currentTaskDidTerminate:(NSNotification *)aNotification;
/*"Description Forthcoming. Not orthogonal.
Version History: jlaurens AT users DOT sourceforge DOT net (09/11/01)
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(iTM2DebugEnabled)
	{
		iTM2_LOG(@"task: %@", [aNotification object]);
	}
    if(![_CurrentTask isEqual:[aNotification object]])
        return;
//iTM2_START;
    [DNC removeObserver:self name:NSTaskDidTerminateNotification object:_CurrentTask];
//iTM2_LOG(@"_CurrentWrapper is: %@", _CurrentWrapper);
	if(![self isMute])
	{
		NSFileHandle * FH = nil;
		NSData * D = nil;
		NSString * string = nil;
		// got an exception here: *** -[NSNullFileHandle fileHandleForReading]:selector not recognized [self = 0x14a1070]
		id IO = [_CurrentTask standardOutput];
		if([IO respondsToSelector:@selector(fileHandleForReading)])
		{
			FH = [IO fileHandleForReading];
			D = [FH readDataToEndOfFile];
			string = [[[NSString alloc] initWithData:D encoding:NSUTF8StringEncoding] autorelease];
			if([D length] && ![string length])
			{
				string = [[[NSString alloc] initWithData:D encoding:NSMacOSRomanStringEncoding] autorelease];
				iTM2_LOG(@"Output encoding problem.");
			}
			[self logOutput:string];
		}
		else if([IO respondsToSelector:@selector(readDataToEndOfFile)])
		{
			D = [IO readDataToEndOfFile];
			string = [[[NSString alloc] initWithData:D encoding:NSUTF8StringEncoding] autorelease];
			if([D length] && ![string length])
			{
				string = [[[NSString alloc] initWithData:D encoding:NSMacOSRomanStringEncoding] autorelease];
				iTM2_LOG(@"Output encoding problem.");
			}
			[self logOutput:string];
		}
		IO = [_CurrentTask standardError];
		if([IO respondsToSelector:@selector(fileHandleForReading)])
		{
			FH = [IO fileHandleForReading];
			D = [FH readDataToEndOfFile];
			string = [[[NSString alloc] initWithData:D encoding:NSUTF8StringEncoding] autorelease];
			if([D length] && ![string length])
			{
				string = [[[NSString alloc] initWithData:D encoding:NSMacOSRomanStringEncoding] autorelease];
				iTM2_LOG(@"Output encoding problem.");
			}
			[self logError:string];
		}
		else if([IO respondsToSelector:@selector(readDataToEndOfFile)])
		{
			D = [IO readDataToEndOfFile];
			string = [[[NSString alloc] initWithData:D encoding:NSUTF8StringEncoding] autorelease];
			if([D length] && ![string length])
			{
				string = [[[NSString alloc] initWithData:D encoding:NSMacOSRomanStringEncoding] autorelease];
				iTM2_LOG(@"Output encoding problem.");
			}
			[self logError:string];
		}
	}
    [_CurrentWrapper taskDidTerminate:self];
    [[self allInspectors] makeObjectsPerformSelector:@selector(taskDidTerminate)];
    [_CurrentTask release];
    _CurrentTask = nil;
    [_CurrentWrapper release];
    _CurrentWrapper = nil;
    [self start];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= executeAppleScript:
- (void)executeAppleScript:(NSString *)source;
/*"Description Forthcoming. Rough input, no verification.
Version History: jlaurens AT users DOT sourceforge DOT net (09/11/01)
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_LOG(@"source is: %@", source);
    NSAppleScript * AS = [[[NSAppleScript allocWithZone:[self zone]] initWithSource:source] autorelease];
    if(AS)
    {
        NSDictionary * errorInfo = nil;
        [AS executeAndReturnError:&errorInfo];
        if(errorInfo)
        {
            NSMutableString * MS = [NSMutableString stringWithString:@"\n! AppleScript execution error:\n"];
            NSString * message;
            if(message = [errorInfo objectForKey:NSAppleScriptErrorAppName])
                [MS appendFormat:@"! Application:%@\n", message];
            if(message = [errorInfo objectForKey:NSAppleScriptErrorMessage])
                [MS appendFormat:@"! Reason:%@\n", message];
            if(message = [errorInfo objectForKey:NSAppleScriptErrorNumber])
                [MS appendFormat:@"! Error number:%@\n", message];
            if(message = [errorInfo objectForKey:NSAppleScriptErrorBriefMessage])
                [MS appendFormat:@"! Brief reason:%@\n", message];
            if(message = [errorInfo objectForKey:NSAppleScriptErrorRange])
                [MS appendFormat:@"! Error range:%@\n", message];
            [[self allInspectors] makeObjectsPerformSelector:@selector(logCustom:) withObject:MS];
        }
    }
    else
    {
        [[self allInspectors] makeObjectsPerformSelector:@selector(logCustom:) withObject:@"\n!  Bad script\n"];
    }
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  waitUntilExit
- (void)waitUntilExit;
/*"Description Forthcoming. Rough input, no verification.
Version History: jlaurens AT users DOT sourceforge DOT net (09/11/01)
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[[NSCursor cancelCursor] push];
	NSString * string = nil;
	NSTimeInterval timeInterval = [SUD floatForKey:@"iTM2TaskInterruptDelay"]?:0.25;
	timeInterval = MAX(timeInterval,0);
start:
	if([_CurrentWrapper canInterruptTask])
	{
		while([_CurrentTask isRunning])
		{
			NSDate * date = [NSDate dateWithTimeIntervalSinceNow:timeInterval];
			NSEvent * E = [NSApp nextEventMatchingMask:NSKeyDownMask|NSKeyUpMask untilDate:date inMode:NSDefaultRunLoopMode dequeue:YES];
			if(E)
			{
				string = [E characters];
				if([string length] && ([string characterAtIndex:0] == '.'))
				{
					unsigned modifierFlags = [E modifierFlags];
					modifierFlags &= NSDeviceIndependentModifierFlagsMask;
					modifierFlags &= ~NSShiftKeyMask;
					if(modifierFlags == NSCommandKeyMask)
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
	while([D length])
	{
		string = [[[NSString alloc] initWithData:D encoding:NSUTF8StringEncoding] autorelease];
		if(![string length])
		{
			string = [[[NSString alloc] initWithData:D encoding:NSMacOSRomanStringEncoding] autorelease];
			iTM2_LOG(@"Output encoding problem.");
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
	while([D length])
	{
		string = [[[NSString alloc] initWithData:D encoding:NSUTF8StringEncoding] autorelease];
		if(![string length])
		{
			string = [[[NSString alloc] initWithData:D encoding:NSMacOSRomanStringEncoding] autorelease];
			iTM2_LOG(@"Output encoding problem.");
		}
		[_Output appendString:string];
		NS_DURING
		D = [_CurrentTask isRunning]?[FH availableData]:[FH readDataToEndOfFile];//: Interrupted system call?
		NS_HANDLER
		D = nil;
		NS_ENDHANDLER
	}
	[_CurrentTask release];
	_CurrentTask = nil;
	[_CurrentWrapper release];
	_CurrentWrapper = nil;
	[self start];
	if(_CurrentWrapper)
	{
		goto start;
	}
	[NSCursor pop];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= execute:
- (void)execute:(NSString *)aCommand;
/*"Description Forthcoming. Rough input, no verification.
Version History: jlaurens AT users DOT sourceforge DOT net (09/11/01)
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if([_CurrentTask isRunning] && [aCommand length])
    {
        NSLog(@"Executing: %@", aCommand);
        [[self allInspectors] makeObjectsPerformSelector:@selector(logInput:) withObject:aCommand];
		NSData * D = [aCommand dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        [[[_CurrentTask standardInput] fileHandleForWriting] writeData:D];
        if(![aCommand hasSuffix:@"\n"])
        {
            [[[_CurrentTask standardInput] fileHandleForWriting] writeData:
                [@"\n" dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES]];
            [[self allInspectors] makeObjectsPerformSelector:@selector(logInput:) withObject:@"\n"];
        }
    }
    else
    {
        NSLog(@"%@ %#x", NSStringFromClass([self class]), NSStringFromSelector(_cmd), self);
        NSLog(@"Ignored: <%@>", aCommand);
    }
    return;
}
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2TaskController

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2TaskWrapper

NSString * const iTM2TaskEnvironmentKey = @"iTM2TaskEnvironment";
#define iVarTaskEnvironment [[self implementation] metaValueForKey:iTM2TaskEnvironmentKey]
NSString * const iTM2TaskArgumentsKey = @"iTM2TaskArguments";
#define iVarArguments [[self implementation] metaValueForKey:iTM2TaskArgumentsKey]
NSString * const iTM2TaskLaunchPathKey = @"iTM2TaskLaunchPath";
#define iVarLaunchPath [[self implementation] metaValueForKey:iTM2TaskLaunchPathKey]
NSString * const iTM2TaskCurrentDirectoryPathKey = @"iTM2TaskCurrentDirectoryPath";
#define iVarCurrentDirectoryPath [[self implementation] metaValueForKey:iTM2TaskCurrentDirectoryPathKey]
NSString * const iTM2TaskLaunchInvocationKey = @"iTM2TaskLaunchInvocation";
NSString * const iTM2TaskInterruptInvocationKey = @"iTM2TaskInterruptInvocation";
NSString * const iTM2TaskTerminateInvocationKey = @"iTM2TaskTerminateInvocation";
NSString * const iTM2TaskTerminationStatusKey = @"iTM2TaskTerminationStatus";
#define iVarTerminationStatus [[[self implementation] metaValueForKey:iTM2TaskTerminationStatusKey] intValue]
NSString * const iTM2TaskCanInterruptKey = @"iTM2TaskCanInterrupt";

NSString * const iTM2TaskPATHKey = @"PATH";

@interface iTM2TaskWrapper(PRIVATE)
- (void)cleanInvocations;
@end
@implementation iTM2TaskWrapper
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  dealloc
- (void)dealloc;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//NSLog(@"DEALLOCING A TASK WRAPPER: %#x", self);
    [self cleanInvocations];
    [super dealloc];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  cleanInvocations
- (void)cleanInvocations;
/*"The _Launch and _Terminate invocations are private, use them with care.
There can be problems with retain/release of the target.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSInvocation * _Launch = [IMPLEMENTATION metaValueForKey:iTM2TaskLaunchInvocationKey];
    [[_Launch target] retain];
	[_Launch setTarget:nil];
    [IMPLEMENTATION takeMetaValue:nil forKey:iTM2TaskLaunchInvocationKey];
    NSInvocation * _Terminate = [IMPLEMENTATION metaValueForKey:iTM2TaskTerminateInvocationKey];
    [[_Terminate target] retain];
	[_Terminate setTarget:nil];
    [IMPLEMENTATION takeMetaValue:nil forKey:iTM2TaskTerminateInvocationKey];
    NSInvocation * _Interrupt = [IMPLEMENTATION metaValueForKey:iTM2TaskInterruptInvocationKey];
    [[_Interrupt target] retain];
	[_Interrupt setTarget:nil];
    [IMPLEMENTATION takeMetaValue:nil forKey:iTM2TaskTerminateInvocationKey];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initImplementation
- (void)initImplementation;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [super initImplementation];
    [IMPLEMENTATION takeMetaValue:[NSMutableDictionary dictionary] forKey:iTM2TaskEnvironmentKey];
    [IMPLEMENTATION takeMetaValue:[NSString string] forKey:iTM2TaskCurrentDirectoryPathKey];
    [IMPLEMENTATION takeMetaValue:[NSMutableArray array] forKey:iTM2TaskArgumentsKey];
    #warning: this is not the best location.
    [self setEnvironmentString:@":0.0" forKey:@"DISPLAY"];// this is for the xdvi support
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  delegate
- (id)delegate;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    id I = [[self implementation] metaValueForKey:iTM2TaskLaunchInvocationKey];
    return I? [I target]:[[[self implementation] metaValueForKey:iTM2TaskTerminateInvocationKey] target];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  userInfo
- (id)userInfo;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    id result = nil;
    NSInvocation * _Launch = [[self implementation] metaValueForKey:iTM2TaskLaunchInvocationKey];
    if(_Launch)
        [_Launch getArgument:&result atIndex:4];
    else
    {
        NSInvocation * _Terminate = [[self implementation] metaValueForKey:iTM2TaskTerminateInvocationKey];
        if(_Terminate)
            [_Terminate getArgument:&result atIndex:4];
		else
		{
			NSInvocation * _Interrupt = [[self implementation] metaValueForKey:iTM2TaskInterruptInvocationKey];
			if(_Interrupt)
				[_Interrupt getArgument:&result atIndex:4];
		}
    }
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setDelegate:launchCallback:terminateCallback:interruptCallback:userInfo:
- (void)setDelegate:(id)delegate launchCallback:(SEL)LCB terminateCallback:(SEL)TCB interruptCallback:(SEL)ICB userInfo:(id)userInfo;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self cleanInvocations];
    if(delegate)
    {
        NSMethodSignature * template = [self methodSignatureForSelector:@selector(_callbackTemplate:::)];
        if(LCB)
        {
            NSMethodSignature * MS = [delegate methodSignatureForSelector:LCB];
            if([template isEqual:MS])
            {
                NSInvocation * _Launch = [NSInvocation invocationWithMethodSignature:MS];
                [_Launch retainArguments];// for the userInfo!!! but will retain the target too
                [_Launch setTarget:delegate];
                [delegate autorelease];// compensate the above setTarget:retain, see the cleanInvocations
                [_Launch setSelector:LCB];
                [_Launch setArgument:&userInfo atIndex:4];
                [IMPLEMENTATION takeMetaValue:_Launch forKey:iTM2TaskLaunchInvocationKey];
            }
            else
                NSLog(@"Bad selector: %@", NSStringFromSelector(LCB));
        }
        if(TCB)
        {
            NSMethodSignature * MS = [delegate methodSignatureForSelector:TCB];
            if([template isEqual:MS])
            {
                NSInvocation * _Terminate = [NSInvocation invocationWithMethodSignature:MS];
                [_Terminate retainArguments];// for the userInfo!!!
                [_Terminate setTarget:delegate];
                [delegate autorelease];// compensate the setTarget:retain, see the cleanInvocations
                [_Terminate setSelector:TCB];
                [_Terminate setArgument:&userInfo atIndex:4]; 
                [IMPLEMENTATION takeMetaValue:_Terminate forKey:iTM2TaskTerminateInvocationKey];
            }
            else
                NSLog(@"Bad selector: %@", NSStringFromSelector(TCB));
        }
        if(ICB)
        {
            NSMethodSignature * MS = [delegate methodSignatureForSelector:ICB];
            if([template isEqual:MS])
            {
                NSInvocation * _Interrupt = [NSInvocation invocationWithMethodSignature:MS];
                [_Interrupt retainArguments];// for the userInfo!!!
                [_Interrupt setTarget:delegate];
                [delegate autorelease];// compensate the setTarget:retain, see the cleanInvocations
                [_Interrupt setSelector:TCB];
                [_Interrupt setArgument:&userInfo atIndex:4]; 
                [IMPLEMENTATION takeMetaValue:_Interrupt forKey:iTM2TaskInterruptInvocationKey];
            }
            else
                NSLog(@"Bad selector: %@", NSStringFromSelector(TCB));
        }
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  _callbackTemplate:::
- (void)_callbackTemplate:(iTM2TaskWrapper *)arg1 :(iTM2TaskController *)taskController :(id)userInfo;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  launchPath
- (NSString *)launchPath;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return iVarLaunchPath;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setLaunchPath:
- (void)setLaunchPath:(NSString *)argument;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(argument && ![argument isKindOfClass:[NSString class]])
        [NSException raise:NSInvalidArgumentException format:@"%@ NSString argument expected:got %@.",
            __iTM2_PRETTY_FUNCTION__, argument];
    else if(![argument pathIsEqual:iVarLaunchPath])
        [IMPLEMENTATION takeMetaValue:[[argument copy] autorelease] forKey:iTM2TaskLaunchPathKey];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  arguments
- (NSMutableArray *)arguments;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return iVarArguments;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setArguments:
- (void)setArguments:(NSArray *)argument;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(argument && ![argument isKindOfClass:[NSArray class]])
        [NSException raise:NSInvalidArgumentException format:@"%@ NSArray argument expected:got %@.",
            __iTM2_PRETTY_FUNCTION__, argument];
    else if(![argument isEqual:iVarArguments])
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(argument && ![argument isKindOfClass:[NSString class]])
        [NSException raise:NSInvalidArgumentException format:@"%@ NSString argument expected:got %@.",
            __iTM2_PRETTY_FUNCTION__, argument];
    else if([argument length])
    {
        [[self arguments] addObject:argument];
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(argument && ![argument isKindOfClass:[NSArray class]])
        [NSException raise:NSInvalidArgumentException format:@"%@ NSArray argument expected:got %@.",
            __iTM2_PRETTY_FUNCTION__, argument];
    else
    {
        NSEnumerator * E = [argument objectEnumerator];
        NSString * S;
        NSMutableArray * MRA = [NSMutableArray array];
        while(S = [E nextObject])
        {
            if([argument isKindOfClass:[NSString class]] && [S length])
                [MRA addObject:S];
        }
        [[self arguments] addObjectsFromArray:MRA];
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return iVarTaskEnvironment;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setEnvironment:
- (void)setEnvironment:(NSMutableDictionary *)argument;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(argument && ![argument isKindOfClass:[NSDictionary class]])
        [NSException raise:NSInvalidArgumentException format:@"%@ NSDictionary argument expected:got %@.",
            __iTM2_PRETTY_FUNCTION__, argument];
    else if(![argument isEqual:iVarTaskEnvironment])
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(![argument isKindOfClass:[NSDictionary class]])
        [NSException raise:NSInvalidArgumentException format:@"%@ NSDictionary argument expected:got %@.",
            __iTM2_PRETTY_FUNCTION__, argument];
    else if(![argument isEqual:[self environment]])
    {
        [[self environment] setDictionary:argument];
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(argument && ![argument isKindOfClass:[NSDictionary class]])
        [NSException raise:NSInvalidArgumentException format:@"%@ NSDictionary argument expected:got %@.",
            __iTM2_PRETTY_FUNCTION__, argument];
    else
    {
        [[self environment] addEntriesFromDictionary:argument];
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSAssert(key != nil, @"Unexpected nil key");
    if(![argument isKindOfClass:[NSString class]])
        [NSException raise:NSInvalidArgumentException format:@"%@ NSString argument expected:got %@.",
            __iTM2_PRETTY_FUNCTION__, argument];
    else if(![key isKindOfClass:[NSString class]])
        [NSException raise:NSInvalidArgumentException format:@"%@ NSString key expected:got %@.",
            __iTM2_PRETTY_FUNCTION__, key];
    else
    {
        [[self environment] setObject:argument forKey:key];
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(path && ![path isKindOfClass:[NSString class]])
        [NSException raise:NSInvalidArgumentException format:@"%@ NSString argument expected:got %@.",
            __iTM2_PRETTY_FUNCTION__, path];
    else if([path length])
    {
        NSString * oldPATH = [[self environment] objectForKey:iTM2TaskPATHKey];
        NSMutableArray * PCs = [[[(oldPATH? oldPATH:@"") componentsSeparatedByString:@":"] mutableCopy] autorelease];
        [PCs removeObject:path];
        [PCs addObject:path];
        [[self environment] setObject:[PCs componentsJoinedByString:@":"] forKey:iTM2TaskPATHKey];
		if(iTM2DebugEnabled>999)
		{
			iTM2_LOG(@"The component %@ has been appended to PATH, the result is: %@", path, [[self environment] objectForKey:iTM2TaskPATHKey]);
		}
    }
	else if(iTM2DebugEnabled)
	{
		iTM2_LOG(@"Ignoring PATH component: %@", path);
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(path && ![path isKindOfClass:[NSString class]])
        [NSException raise:NSInvalidArgumentException format:@"%@ NSString argument expected:got %@.",
            __iTM2_PRETTY_FUNCTION__, path];
    else if([path length])
    {
		path = [path stringByStandardizingPath];
        NSString * oldPATH = [[self environment] objectForKey:iTM2TaskPATHKey];
        NSMutableArray * oldPCs = [[[(oldPATH? oldPATH:@"") componentsSeparatedByString:@":"] mutableCopy] autorelease];
        [oldPCs removeObject:path];
		if(![path hasPrefix:iTM2PathComponentsSeparator] && ![path hasPrefix:@"."])
		{
			path = [@"." stringByAppendingPathComponent:path];
			[oldPCs removeObject:path];
		}
        NSMutableArray * PCs = [NSMutableArray arrayWithObject:path];
        [PCs addObjectsFromArray:oldPCs];
        [[self environment] setObject:[PCs componentsJoinedByString:@":"] forKey:iTM2TaskPATHKey];
		if(iTM2DebugEnabled>999)
		{
			iTM2_LOG(@"The component %@ has been prepended to PATH, the result is: %@", path, [[self environment] objectForKey:iTM2TaskPATHKey]);
		}
    }
	else if(iTM2DebugEnabled)
	{
		iTM2_LOG(@"Ignoring PATH component: %@", path);
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  currentDirectoryPath
- (NSString *)currentDirectoryPath;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return iVarCurrentDirectoryPath;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setCurrentDirectoryPath:
- (void)setCurrentDirectoryPath:(NSString *)argument;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(argument && ![argument isKindOfClass:[NSString class]])
        [NSException raise:NSInvalidArgumentException format:@"%@ NSString argument expected:got %@.",
            __iTM2_PRETTY_FUNCTION__, argument];
    else if(![argument pathIsEqual:iVarCurrentDirectoryPath])
        [IMPLEMENTATION takeMetaValue:[[argument copy] autorelease] forKey:iTM2TaskCurrentDirectoryPathKey];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  terminationStatus
- (int)terminationStatus;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return iVarTerminationStatus;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setTerminationStatus:
- (void)setTerminationStatus:(int)argument;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [IMPLEMENTATION takeMetaValue:[NSNumber numberWithInt:argument] forKey:iTM2TaskTerminationStatusKey];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  contextManager
- (id)contextManager;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [self delegate]?:[super contextManager];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  taskWillLaunch:
- (void)taskWillLaunch:(iTM2TaskController *)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
#warning THE TEX PROJECT MUST OVERRIDE THIS METHOD TO ADD ITS OWN STUFF
	if(iTM2DebugEnabled>999)
	{
		iTM2_LOG(@"[self contextValueForKey:iTM2PATHPrefixKey]:%@", [self contextValueForKey:iTM2PATHPrefixKey domain:iTM2ContextAllDomainsMask]);
		iTM2_LOG(@"[self contextValueForKey:iTM2PATHSuffixKey]:%@", [self contextValueForKey:iTM2PATHSuffixKey domain:iTM2ContextAllDomainsMask]);
		iTM2_LOG(@"[self contextValueForKey:iTM2PATHDomainX11BinariesKey]:%@", [self contextValueForKey:iTM2PATHDomainX11BinariesKey domain:iTM2ContextAllDomainsMask]);
	}
//iTM2_LOG(@"complete [self environment]:%@", [self environment]);
	id contextManager = ((id)[self delegate]?:((id)sender?:(id)SUD));
    [self prependPATHComponent:[contextManager contextValueForKey:iTM2PATHPrefixKey domain:iTM2ContextAllDomainsMask]];
    [self appendPATHComponent:[contextManager contextValueForKey:iTM2PATHDomainX11BinariesKey domain:iTM2ContextAllDomainsMask]];
    [self appendPATHComponent:[contextManager contextValueForKey:iTM2PATHSuffixKey domain:iTM2ContextAllDomainsMask]];
    [self setEnvironmentString:[NSBundle defaultWritableFolderPath] forKey:@"iTM2WritableFolderPATH"];
    id truc = self;
    NSInvocation * I = [[self implementation] metaValueForKey:iTM2TaskLaunchInvocationKey];
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
    id truc = self;
    NSInvocation * I = [[self implementation] metaValueForKey:iTM2TaskTerminateInvocationKey];
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
    id truc = self;
    NSInvocation * I = [[self implementation] metaValueForKey:iTM2TaskInterruptInvocationKey];
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [[self implementation] metaValueForKey:iTM2TaskInterruptInvocationKey] != nil || [[[self implementation] metaValueForKey:iTM2TaskCanInterruptKey] boolValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  modalStatusAndOutput:error:
- (int)modalStatusAndOutput:(NSString **)outputPtr error:(NSError **)outErrorPtr;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    iTM2TaskController * TC = [[[iTM2TaskController allocWithZone:[self zone]] init] autorelease];
    [TC addTaskWrapper:self];
	[[self implementation] takeMetaValue:[NSNumber numberWithBool:YES] forKey:iTM2TaskCanInterruptKey];
	[TC setDeaf:YES];// no input pipe
    [TC start];
	[TC waitUntilExit];
iTM2_LOG(@"[TC output]:%@",[TC output]);
	iTM2_OUTERROR(1,([TC errorStatus]),nil);
    if(outputPtr)
        *outputPtr = [TC output];
    return [[TC currentTask] terminationStatus];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  modalStatusOfScript:output:error:
+ (int)modalStatusOfScript:(NSString *)script output:(NSString **)outputPtr error:(NSError **)outErrorPtr;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    iTM2TaskWrapper * TW = [[[iTM2TaskWrapper alloc] init] autorelease];
    [TW setLaunchPath:@"/bin/sh"];
    iTM2TaskController * TC = [[[iTM2TaskController allocWithZone:[self zone]] init] autorelease];
    [TC addTaskWrapper:TW];
    [TC start];
    [TC execute:script];
    [TC execute:@"exit"];
    [TC waitUntilExit];
	iTM2_OUTERROR(2,([TC errorStatus]),nil);
    if(outputPtr)
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_LOG(@"RELEASE = %i", [self retainCount]-1);
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_LOG(@"RETAIN = %i", [self retainCount]+1);
    return [super retain];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  autorelease;
- (id)autorelease;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_LOG(@"AUTORELEASE = %i", [self retainCount]);
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self takeContextBool:![self contextBoolForKey:iTM2TaskControllerIsDeafKey domain:iTM2ContextAllDomainsMask] forKey:iTM2TaskControllerIsDeafKey domain:iTM2ContextAllDomainsMask];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleTaskControllerDeaf:
- (BOOL)validateToggleTaskControllerDeaf:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setState:([self contextBoolForKey:iTM2TaskControllerIsDeafKey domain:iTM2ContextAllDomainsMask]? NSOnState:NSOffState)];
	return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleTaskControllerMute:
- (IBAction)toggleTaskControllerMute:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self takeContextBool:![self contextBoolForKey:iTM2TaskControllerIsMuteKey domain:iTM2ContextAllDomainsMask] forKey:iTM2TaskControllerIsMuteKey domain:iTM2ContextAllDomainsMask];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleTaskControllerMute:
- (BOOL)validateToggleTaskControllerMute:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setState:([self contextBoolForKey:iTM2TaskControllerIsMuteKey domain:iTM2ContextAllDomainsMask]? NSOnState:NSOffState)];
	return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleTaskControllerBlind:
- (IBAction)toggleTaskControllerBlind:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self takeContextBool:![self contextBoolForKey:iTM2TaskControllerIsBlindKey domain:iTM2ContextAllDomainsMask] forKey:iTM2TaskControllerIsBlindKey domain:iTM2ContextAllDomainsMask];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleTaskControllerBlind:
- (BOOL)validateToggleTaskControllerBlind:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setState:([self contextBoolForKey:iTM2TaskControllerIsBlindKey domain:iTM2ContextAllDomainsMask]? NSOnState:NSOffState)];
	return YES;
}
@end
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2TaskController

#import <iTM2Foundation/iTM2MacroKit.h>
#import <iTM2Foundation/iTM2CursorKit.h>
#import <iTM2Foundation/iTM2FileManagerKit.h>
#import <Lua/iTM2LuaInterpreter.h>

@implementation NSResponder(iTM2TaskKit)
- (NSString *)stringByExecutingScriptAtPath:(NSString *)scriptPath;
{
	if(iTM2DebugEnabled)
	{
		iTM2_LOG(@"Executing script at path:%@",scriptPath);
	}
	NSURL * url = [NSURL fileURLWithPath:scriptPath];
	NSAppleScript * AS = [[[NSAppleScript allocWithZone:[self zone]] initWithContentsOfURL:url error:nil] autorelease];
	if(AS)
	{
		NSDictionary * errorInfo = nil;
		//NSAppleEventDescriptor * descriptor = 
		NSAppleEventDescriptor * descriptor = [AS executeAndReturnError:&errorInfo];
		if(errorInfo)
		{
			iTM2_LOG(@"errorInfo is:%@",errorInfo);
			NSString * message = [errorInfo objectForKey:NSAppleScriptErrorMessage];
			iTM2_REPORTERROR(1,message,nil);
		}
		return [descriptor stringValue];
	}
	if([DFM isExecutableFileAtPath:scriptPath])
	{
		iTM2TaskWrapper * TW = [[[iTM2TaskWrapper allocWithZone:[self zone]] init] autorelease];
		[TW setLaunchPath:scriptPath];
		NSError * localError = nil;
		NSString * output = nil;
		//int status = 
		[TW modalStatusAndOutput:&output error:&localError];
		if(localError)
		{
			[NSApp presentError:localError];
		}
		return output;
	}
	return nil;
}
- (void)executeAsScript:(id)sender;
{
	NSString * script = [sender argument];
	// is it a lua script?
	NSRange R = NSMakeRange(0,0);
	[script getLineStart:nil end:nil contentsEnd:&R.length forRange:R];
	NSString * line = [script substringWithRange:R];
	if([line hasPrefix:@"#!"] && [line hasSuffix:@"lua"])
	{
		iTM2LuaInterpreter * interpreter = [iTM2LuaInterpreter interpreter];
		[interpreter executeString:script];
		return;
	}
	// save the script somewhere
	NSString * path = [NSBundle temporaryBinaryDirectory];
	path = [path stringByAppendingPathComponent:@"macro_script"];
	NSURL * url = [NSURL fileURLWithPath:path];
	NSError * error = nil;
	if([script writeToURL:url atomically:NO encoding:NSUTF8StringEncoding error:&error])
	{
		// make it executable
		NSNumber * permission = [NSNumber numberWithUnsignedInt:S_IRWXU];
		NSDictionary * attributes = [NSDictionary dictionaryWithObject:permission forKey:NSFilePosixPermissions];
		if([DFM changeFileAttributes:attributes atPath:path])
		{
			[self executeScriptAtPath:path];
		}
		else
		{
			iTM2_REPORTERROR(1,([NSString stringWithFormat:@"Could not set posix permission at\n%@",path]),nil);
		}
	}
	else if(error)
	{
		[NSApp performSelectorOnMainThread:@selector(presentError:) withObject:error waitUntilDone:NO];
	}
	return;
}
- (void)executeScriptAtPath:(NSString *)scriptPath;
{
	NSWindow * W = [NSApp keyWindow];
	id FR = [W firstResponder];
	NSString * context = [FR macroContext];
	NSString * category = [FR macroCategory];
	NSString * domain = [FR macroDomain];
	NSString * result = nil;
	if([DFM isExecutableFileAtPath:scriptPath])
	{
		result = [FR stringByExecutingScriptAtPath:scriptPath];
		[SMC executeMacroWithText:result forContext:context ofCategory:category inDomain:domain target:FR];//delayed?
		return;
	}
	NSString * subpath = [domain stringByAppendingPathComponent:category];
	subpath = [subpath stringByAppendingPathComponent:iTM2MacroScriptsComponent];
	NSBundle * MB = [NSBundle mainBundle];
	NSArray * RA = [MB allPathsForResource:iTM2MacrosDirectoryName ofType:iTM2LocalizedExtension];
	NSEnumerator * E = [RA reverseObjectEnumerator];
	NSString * path;
	while(path = [E nextObject])
	{
		if([DFM pushDirectory:path])
		{
			if([DFM pushDirectory:subpath])
			{
				path = [DFM currentDirectoryPath];
				path = [path stringByAppendingPathComponent:scriptPath];
				if([DFM fileExistsAtPath:scriptPath isDirectory:nil])
				{
					result = [FR stringByExecutingScriptAtPath:scriptPath];
					[SMC executeMacroWithText:result forContext:context ofCategory:category inDomain:domain target:FR];//delayed?
					[DFM popDirectory];
					return;
				}
				[DFM popDirectory];
			}
			else if([DFM fileExistsAtPath:subpath isDirectory:nil])
			{
				iTM2_LOG(@"*** SILENT Error: could not push \"%@/%@\"",[DFM currentDirectoryPath],subpath);
			}
			[DFM popDirectory];
		}
		else
		{
			iTM2_LOG(@"*** SILENT Error: could not push \"%@\"",path);
		}
	}
}
@end

@implementation NSTextView(iTM2TaskKit)
- (NSString *)stringByExecutingScriptAtPath:(NSString *)scriptPath;
{
	if(iTM2DebugEnabled)
	{
		iTM2_LOG(@"Executing script at path:%@",scriptPath);
	}
	NSURL * url = [NSURL fileURLWithPath:scriptPath];
	NSAppleScript * AS = [[[NSAppleScript allocWithZone:[self zone]] initWithContentsOfURL:url error:nil] autorelease];
	if(AS)
	{
		NSDictionary * errorInfo = nil;
		//NSAppleEventDescriptor * descriptor = 
		NSAppleEventDescriptor * descriptor = [AS executeAndReturnError:&errorInfo];
		if(errorInfo)
		{
			iTM2_LOG(@"errorInfo is:%@",errorInfo);
			NSString * message = [errorInfo objectForKey:NSAppleScriptErrorMessage];
			iTM2_REPORTERROR(1,message,nil);
		}
		return [descriptor stringValue];
	}
	NSError * localError = nil;
	url = [NSURL fileURLWithPath:scriptPath];
	NSString * script = [[[NSString allocWithZone:[self zone]] initWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&localError] autorelease];
	if([script length])
	{
		NSString * selection = [self preparedSelectedStringForMacroInsertion];
		NSString * line = [self preparedSelectedLineForMacroInsertion];
		script = [self concreteReplacementStringForMacro:script selection:selection line:line];
		NSString * path = [NSBundle temporaryDirectory];
		scriptPath = [[NSProcessInfo processInfo] globallyUniqueString];
		scriptPath = [path stringByAppendingPathComponent:scriptPath];
		url = [NSURL fileURLWithPath:scriptPath];
		if([script writeToURL:url atomically:YES encoding:NSUTF8StringEncoding error:&localError])
		{
			NSNumber * permissions = [NSNumber numberWithInt:S_IRWXU];
			NSDictionary * attributes = [NSDictionary dictionaryWithObject:permissions forKey:NSFilePosixPermissions];
			if([DFM changeFileAttributes:attributes atPath:scriptPath])
			{
				iTM2TaskWrapper * TW = [[[iTM2TaskWrapper allocWithZone:[self zone]] init] autorelease];
				[TW setLaunchPath:scriptPath];
				NSString * macro = nil;
				//int status = [TW modalStatusAndOutput:&output error:&localError];
				[TW modalStatusAndOutput:&macro error:&localError];
				if(localError)
				{
					[NSApp presentError:localError];
				}
				return macro;
			}
			else
			{
				iTM2_REPORTERROR(1,([NSString stringWithFormat:@"Problem: Cannot set permission at %@",scriptPath]),nil);
			}
			[DFM removeFileAtPath:scriptPath handler:nil];
		}
		else if(localError)
		{
			iTM2_LOG(@"localError:%@",localError);
			iTM2_LOG(@"scriptPath:%@",scriptPath);
			[NSApp presentError:localError];
		}
	}
	else if(localError)
	{
		[NSApp presentError:localError];
	}
	return @"";
}
@end