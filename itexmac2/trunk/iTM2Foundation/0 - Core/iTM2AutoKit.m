/*
//
//  @version Subversion: $Id$ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Tue Jan 18 22:21:11 GMT 2005.
//  Copyright © 2005 Laurens'Tribune. All rights reserved.
//
//  This program is free software; you can redistribute it and/or modify it under the terms
//  of the GNU General Public License as published by the Free Software Foundation; either
//  version 2 of the License, or any later version, modified by the addendum below.
//  This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
//  without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
//  See the GNU General Public License for more details. You should have received a copy
//  of the GNU General Public License along with this program; if not, write to the Free Software
//  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
//  GPL addendum:Any simple modification of the present code which purpose is to remove bug,
//  improve efficiency in both code execution and code reading or writing should be addressed
//  to the actual developper team.
//
//  Version history: (format "- date:contribution(contributor)") 
//  To Do List:(format "- proposition(percentage actually done)")
*/

#import <iTM2Foundation/iTM2AutoKit.h>
#import <iTM2Foundation/iTM2DocumentKit.h>
#import <iTM2Foundation/iTM2ContextKit.h>
#import <iTM2Foundation/iTM2NotificationKit.h>
#import <iTM2Foundation/iTM2InstallationKit.h>
#import <iTM2Foundation/iTM2InstallationKit.h>
#import <iTM2Foundation/iTM2Implementation.h>
#import <iTM2Foundation/iTM2RuntimeBrowser.h>
#import <objc/objc-runtime.h>

#define TABLE @"Basic"
#define BUNDLE [NSBundle bundleForClass:[iTM2AutoController class]]
NSString * const iTM2AutoUpdateEnabledKey = @"iTM2AutoUpdateEnabled";
NSString * const iTM2SmartUpdateEnabledKey = @"iTM2SmartUpdateEnabled";

int iTM2AutoUpdateWindowNumberComparator(id, id, void *);

@interface NSDocument_iTM2AutoKit:NSDocument
- (void)fileModificationDataCompleteDidWriteToURL:(NSURL *)absoluteURL ofType:(NSString *) typeName forSaveOperation:(NSSaveOperationType) saveOperationType originalContentsURL:(NSURL *) originalAbsoluteContentsURL error:(NSError**)error;
- (void)fileModificationDataCompleteDidReadFromURL:(NSURL *)absoluteURL ofType:(NSString *) type error:(NSError**)error;
@end
@implementation NSDocument_iTM2AutoKit
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= load
+ (void)load;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Jan 18 22:21:11 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
    iTM2_INIT_POOL;
//iTM2_START;
    [NSDocument_iTM2AutoKit poseAsClass:[NSDocument class]];
//iTM2_END;
	iTM2_RELEASE_POOL;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= canAutoUpdate
- (BOOL)canAutoUpdate;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Jan 18 22:21:11 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSEnumerator * E = [[self windowControllers] objectEnumerator];
    NSWindowController * WC;
    while(WC = [E nextObject])
        if([WC canAutoUpdate])
            return YES;
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  canAutoSave
- (BOOL)canAutoSave;
/*"Subclasses will return YES if they want to be auto saved at regular intervals.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1:05/04/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  writeToURL:ofType:forSaveOperation:originalContentsURL:error:
- (BOOL)writeToURL:(NSURL *)absoluteURL ofType:(NSString *)typeName forSaveOperation:(NSSaveOperationType)saveOperation originalContentsURL:(NSURL *)absoluteOriginalContentsURL error:(NSError **)outError;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Jan 18 22:21:11 GMT 2005
To Do List:save the file, if it has disappeared from the HD.
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    BOOL result = [super writeToURL:absoluteURL ofType:typeName forSaveOperation:saveOperation originalContentsURL:absoluteOriginalContentsURL error:outError];
    if(result)
        [self fileModificationDataCompleteDidWriteToURL:absoluteURL ofType:typeName forSaveOperation:saveOperation originalContentsURL:absoluteOriginalContentsURL error:outError];
	// if result is NO the file modification date is not recorded
	// The method below offers a second chance to record this file modification date, see the iTM2Document design
//iTM2_END;
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  fileModificationDataCompleteDidWriteToURL:ofType:forSaveOperation:originalContentsURL:error:
- (void)fileModificationDataCompleteDidWriteToURL:(NSURL *)absoluteURL ofType:(NSString *) typeName forSaveOperation:(NSSaveOperationType) saveOperationType originalContentsURL:(NSURL *) absoluteOriginalContentsURL error:(NSError**)error;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(saveOperationType != NSSaveToOperation)
        [self recordFileModificationDateFromURL:absoluteURL];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  readFromURL:ofType:error:
- (BOOL)readFromURL:(NSURL *)absoluteURL ofType:(NSString *)type error:(NSError**)error;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Jan 18 22:21:11 GMT 2005
To Do List:save the file, if it has disappeared from the HD.
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    BOOL result = [super readFromURL:absoluteURL ofType:type error:error];
    if(result)
		[self fileModificationDataCompleteDidReadFromURL:absoluteURL ofType:type error:error];
//iTM2_END;
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= fileModificationDataCompleteDidReadFromURL:ofType:error:
- (void)fileModificationDataCompleteDidReadFromURL:(NSURL *)absoluteURL ofType:(NSString *) type error:(NSError**)error;
/*"Description Forthcoming. Record the file modification date
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self recordFileModificationDateFromURL:absoluteURL];
//iTM2_END;
    return;
}
@end

@implementation NSWindowController(iTM2AutoKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= canAutoUpdate
- (BOOL)canAutoUpdate;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Jan 18 22:21:11 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return YES;
}
@end

#import <iTM2Foundation/iTM2InstallationKit.h>
#import <iTM2Foundation/iTM2Implementation.h>
#import <iTM2Foundation/iTM2RuntimeBrowser.h>
#import <iTM2Foundation/iTM2ResponderKit.h>

@implementation iTM2AutoResponder
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  contextManager
- (id)contextManager;
/*"Toggles the display mode between iTM2StickMode and iTM2LastMode.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Jan 18 22:21:11 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_LOG(@"contextManager is:%@", ([NSApp keyWindow]?:(id)SUD));
    return [NSApp keyWindow]?:(id)SUD;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleAutoUpdate:
- (IBAction)toggleAutoUpdate:(id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Jan 18 22:21:11 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self takeContextBool:([sender state] == NSOffState) forKey:iTM2AutoUpdateEnabledKey];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleAutoUpdate:
- (BOOL)validateToggleAutoUpdate:(id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Jan 18 22:21:11 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setState:([self contextBoolForKey:iTM2AutoUpdateEnabledKey]? NSOnState:NSOffState)];
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleSmartUpdate:
- (IBAction)toggleSmartUpdate:(id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Jan 18 22:21:11 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    BOOL wasOnState = ([sender state] != NSOffState);
    [self takeContextBool:!wasOnState forKey:iTM2SmartUpdateEnabledKey];
    if(!wasOnState)
        [self takeContextBool:YES forKey:iTM2AutoUpdateEnabledKey];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleSmartUpdate:
- (BOOL)validateToggleSmartUpdate:(id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Jan 18 22:21:11 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setState:([self contextBoolForKey:iTM2SmartUpdateEnabledKey]? NSOnState:NSOffState)];
    return [self contextBoolForKey:iTM2AutoUpdateEnabledKey];
}
@end

NSString * const iTM2AutoObserveWindowsEnabledKey = @"iTM2AutoObserveWindowsEnabled";
NSString * const iTM2AutoSaveDocumentsEnabledKey = @"iTM2AutoSaveDocumentsEnabled";
NSString * const iTM2AutoSaveIntervalKey = @"iTM2AutoSaveInterval";

#pragma mark =-=-=-=-=-=-=-=-  AUTO SAVE
@interface iTM2AutoController(PRIVATE)
+ (void)_UserDefaultsDidChange:(id) sender;
@end
@implementation iTM2MainInstaller(AutoController)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2AutoControllerCompleteInstallation
+ (void)iTM2AutoControllerCompleteInstallation;
/*"Description forthcoming;
Version History: jlaurens AT users DOT sourceforge DOT net (12/07/2001)
- 1.4 :jlaurens:20040514 
To Do List:to be improved... to allow different signature
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [iTM2AutoController class];
//iTM2_END;
    return;
}
@end
@implementation iTM2AutoController
static id _iTM2_AutoSave_Timer;
static NSTimeInterval _iTM2_AutoSave_TimeInterval; 
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initialize
+ (void)initialize;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon May 10 22:45:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
	iTM2_INIT_POOL;
//iTM2_START;
	[super initialize];
    [DNC removeObserver:self];
    [DNC addObserver:self
        selector:@selector(_UserDefaultsDidChange:)
            name:NSUserDefaultsDidChangeNotification
                object:SUD];
    [SUD registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithBool:YES], iTM2AutoObserveWindowsEnabledKey,
            [NSNumber numberWithBool:YES], iTM2AutoSaveDocumentsEnabledKey,
            [NSNumber numberWithFloat:750.0], iTM2AutoSaveIntervalKey,// in seconds
            [NSNumber numberWithBool:YES], iTM2AutoUpdateEnabledKey,
            [NSNumber numberWithBool:NO], iTM2SmartUpdateEnabledKey,
                nil]];
    [self _UserDefaultsDidChange:nil];
    [DNC addObserver:self
        selector:@selector(iTM2AutoUpdateWindowDidUpdateNotified:)
            name:NSWindowDidUpdateNotification
                object:nil];
//iTM2_END;
	iTM2_RELEASE_POOL;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  _UserDefaultsDidChange:
+ (void)_UserDefaultsDidChange:(id) sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1:05/04/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSTimeInterval newTimeInterval = [SUD floatForKey:iTM2AutoSaveIntervalKey]; 
    if(newTimeInterval != _iTM2_AutoSave_TimeInterval)
    {
        _iTM2_AutoSave_TimeInterval = newTimeInterval;
        [_iTM2_AutoSave_Timer invalidate];
        [_iTM2_AutoSave_Timer autorelease];
        _iTM2_AutoSave_Timer = [([self contextBoolForKey:iTM2AutoSaveDocumentsEnabledKey]?
            [NSTimer scheduledTimerWithTimeInterval:_iTM2_AutoSave_TimeInterval
                target:self selector:@selector(_TimedSaveAllDocuments:) userInfo:nil repeats:YES]
            :nil) retain];
    }
    else if([self contextBoolForKey:iTM2AutoSaveDocumentsEnabledKey])
    {
        if(!_iTM2_AutoSave_Timer)
            _iTM2_AutoSave_Timer = [[NSTimer scheduledTimerWithTimeInterval:_iTM2_AutoSave_TimeInterval
                target:self selector:@selector(_TimedSaveAllDocuments:) userInfo:nil repeats:YES] retain];
    }
    else if(_iTM2_AutoSave_Timer)
    {
        [_iTM2_AutoSave_Timer invalidate];
        [_iTM2_AutoSave_Timer autorelease];
        _iTM2_AutoSave_Timer = nil;
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  _TimedSaveAllDocuments:
+ (void)_TimedSaveAllDocuments:(id) sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1:05/04/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSEnumerator * E = [[SDC documents] objectEnumerator];
    NSDocument * D;
    [self postNotificationWithStatus:
		NSLocalizedStringFromTableInBundle(@"Auto saving the documents.", TABLE, BUNDLE, "Status")];
    while(D = [E nextObject])
        if([D canAutoSave])
            [D saveDocument:self];
    [self postNotificationWithStatus:
		NSLocalizedStringFromTableInBundle(@"Documents saved.", TABLE, BUNDLE, "Status")];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2AutoUpdateWindowDidUpdateNotified:
+ (void)iTM2AutoUpdateWindowDidUpdateNotified:(NSNotification *) aNotification;
/*"Subclasses should not need to override this method. Registers in the registration domain of the user defaults database the frame of aNotification object. The key used is the class frameIdentifier of this object.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Jan 18 22:21:11 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSWindow * W = [aNotification object];
    NSDocument * D = [[W windowController] document];
    if ([D canAutoUpdate]
            && [D contextBoolForKey:iTM2AutoUpdateEnabledKey]
                && [D needsToUpdate])
    {
        if([D contextBoolForKey:iTM2SmartUpdateEnabledKey])
        {
            // finding the front most window
            NSMutableArray * windows = [NSMutableArray array];
            NSEnumerator * E = [[NSApp orderedWindows] objectEnumerator];
            NSWindow * W;
            while(W = [E nextObject])
            {
                if([W isVisible] && [[[W windowController] document] isEqual:D])
                {
                    [windows addObject:W];
                }
            }
            W = [[windows objectEnumerator] nextObject];
            // is there a window?
            if(!W)
                return;
            // is there already a sheet attached to that window?
            if([W attachedSheet])
                return;
            // now we can work...
            NSBundle * B = [NSBundle bundleForClass:[iTM2AutoResponder class]];
                    NSBeginAlertSheet(
                        NSLocalizedStringFromTableInBundle(@"Update View", @"View", B,"Panel title"),
                    NSLocalizedStringFromTableInBundle( @"Update", @"View", B, "Button title"),
                NSLocalizedStringFromTableInBundle( @"Save a Copy Before...", @"View", B, "Button title"),//alt
            NSLocalizedStringFromTableInBundle( @"Ignore", @"View", B, "Button title"),//other
                    W,
                    self,
                    NULL,
                    @selector(autoUpdateSheetDidDismiss:returnCode:document:),
                    [D retain],// will be released below
                    NSLocalizedStringFromTableInBundle( @"%@\nhas been edited externally.",
                        @"View", B, "Panel Information"),
                    [D fileName]);
        }
        else
            [D updateIfNeeded];
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  autoUpdateSheetDidDismiss:returnCode:document:
+ (void)autoUpdateSheetDidDismiss:(NSWindow *) sheet returnCode:(int) returnCode document:(NSDocument *) D;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1:03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_LOG;
	[D autorelease];//was retained above
    switch(returnCode)
    {
        case NSAlertAlternateReturn:
            [D saveDocumentTo:self];//will try update once more
            break;
        case NSAlertOtherReturn://ignore the modification date
            [D recordFileModificationDateFromURL:[D fileURL]];
            break;
        case NSAlertDefaultReturn:
        default:;
            [D readFromURL:[D fileURL] ofType:[D fileType] error:nil];
            break;
    }
    return;
}
@end
