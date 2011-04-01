/*
//
//  @version Subversion: $Id: iTM2AutoKit.m 750 2008-09-17 13:48:05Z jlaurens $ 
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

#import "iTM2AutoKit.h"
#import "iTM2DocumentKit.h"
#import "iTM2ContextKit.h"
#import "iTM2NotificationKit.h"
#import "iTM2InstallationKit.h"
#import "iTM2InstallationKit.h"
#import "iTM2Implementation.h"
#import "iTM2Runtime.h"
#import "iTM2BundleKit.h"
#import <objc/objc-runtime.h>

#define TABLE @"Basic"
#define BUNDLE [NSBundle bundleForClass:[iTM2AutoController class]]
NSString * const iTM2AutoUpdateEnabledKey = @"iTM2AutoUpdateEnabled";
NSString * const iTM2SmartUpdateEnabledKey = @"iTM2SmartUpdateEnabled";

@interface NSDocument(iTM2AutoKit_BIS)
- (BOOL)fileModificationDataCompleteDidWriteToURL4iTM3:(NSURL *)absoluteURL ofType:(NSString *) typeName forSaveOperation:(NSSaveOperationType) saveOperationType originalContentsURL:(NSURL *) originalAbsoluteContentsURL error:(NSError**)RORef;
- (BOOL)fileModificationDateCompleteDidReadFromURL4iTM3:(NSURL *)absoluteURL ofType:(NSString *) type error:(NSError**)RORef;
@end
@implementation NSDocument(iTM2AutoKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= canAutoUpdate4iTM3
- (BOOL)canAutoUpdate4iTM3;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Révisé par itexmac2: 2010-11-30 21:37:43 +0100
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    for (NSWindowController * WC in self.windowControllers)
        if ([WC canAutoUpdate4iTM3])
            return YES;
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  canAutoSave4iTM3
- (BOOL)canAutoSave4iTM3;
/*"Subclasses will return YES if they want to be auto saved at regular intervals.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1:05/04/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  fileModificationDateCompleteDidWriteToURL4iTM3:ofType:forSaveOperation:originalContentsURL:error:
- (void)fileModificationDateCompleteDidWriteToURL4iTM3:(NSURL *)absoluteURL ofType:(NSString *) typeName forSaveOperation:(NSSaveOperationType) saveOperationType originalContentsURL:(NSURL *) absoluteOriginalContentsURL error:(NSError**)RORef;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (saveOperationType != NSSaveToOperation)
	{
        [self recordFileModificationDateFromURL4iTM3:absoluteURL];
	}
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  SWZ_iTM2Auto_writeToURL:ofType:forSaveOperation:originalContentsURL:error:
- (BOOL)SWZ_iTM2Auto_writeToURL:(NSURL *)absoluteURL ofType:(NSString *)typeName forSaveOperation:(NSSaveOperationType)saveOperation originalContentsURL:(NSURL *)absoluteOriginalContentsURL error:(NSError **)RORef;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Jan 18 22:21:11 GMT 2005
To Do List:save the file, if it has disappeared from the HD.
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    BOOL result = [self SWZ_iTM2Auto_writeToURL:absoluteURL ofType:typeName forSaveOperation:saveOperation originalContentsURL:absoluteOriginalContentsURL error:RORef];
    if (result)
        [self fileModificationDateCompleteDidWriteToURL4iTM3:absoluteURL ofType:typeName forSaveOperation:saveOperation originalContentsURL:absoluteOriginalContentsURL error:RORef];
	// if result is NO the file modification date is not recorded
	// The method below offers a second chance to record this file modification date, see the iTM2Document design
//END4iTM3;
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= fileModificationDateCompleteDidReadFromURL4iTM3:ofType:error:
- (BOOL)fileModificationDateCompleteDidReadFromURL4iTM3:(NSURL *)absoluteURL ofType:(NSString *) type error:(NSError**)RORef;
/*"Description Forthcoming. Record the file modification date
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[self recordFileModificationDateFromURL4iTM3:absoluteURL];
//END4iTM3;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  SWZ_iTM2Auto_readFromURL:ofType:error:
- (BOOL)SWZ_iTM2Auto_readFromURL:(NSURL *)absoluteURL ofType:(NSString *)type error:(NSError**)RORef;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Jan 18 22:21:11 GMT 2005
To Do List:save the file, if it has disappeared from the HD.
"*/
{DIAGNOSTIC4iTM3;
    return [self SWZ_iTM2Auto_readFromURL:absoluteURL ofType:type error:RORef]
        && [self fileModificationDateCompleteDidReadFromURL4iTM3:absoluteURL ofType:type error:RORef];
}
@end

@implementation NSWindowController(iTM2AutoKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= canAutoUpdate4iTM3
- (BOOL)canAutoUpdate4iTM3;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Jan 18 22:21:11 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return YES;
}
@end

#import "iTM2InstallationKit.h"
#import "iTM2Implementation.h"
#import "iTM2ResponderKit.h"

@implementation iTM2AutoResponder
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  context4iTM3Manager
- (id)context4iTM3Manager;
/*"Toggles the display mode between iTM2StickMode and iTM2LastMode.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Jan 18 22:21:11 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//LOG4iTM3(@"context4iTM3Manager is:%@", ([NSApp keyWindow]?:(id)SUD));
    return [NSApp keyWindow]?:(id)SUD;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleAutoUpdate:
- (IBAction)toggleAutoUpdate:(id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Jan 18 22:21:11 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self takeContext4iTM3Bool:([sender state] == NSOffState) forKey:iTM2AutoUpdateEnabledKey domain:iTM2ContextAllDomainsMask];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleAutoUpdate:
- (BOOL)validateToggleAutoUpdate:(NSButton *) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Jan 18 22:21:11 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    sender.state = [self context4iTM3BoolForKey:iTM2AutoUpdateEnabledKey domain:iTM2ContextAllDomainsMask]? NSOnState:NSOffState;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleSmartUpdate:
- (IBAction)toggleSmartUpdate:(id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Jan 18 22:21:11 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    BOOL wasOnState = ([sender state] != NSOffState);
    [self takeContext4iTM3Bool:!wasOnState forKey:iTM2SmartUpdateEnabledKey domain:iTM2ContextAllDomainsMask];
    if (!wasOnState)
        [self takeContext4iTM3Bool:YES forKey:iTM2AutoUpdateEnabledKey domain:iTM2ContextAllDomainsMask];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleSmartUpdate:
- (BOOL)validateToggleSmartUpdate:(NSButton *) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Jan 18 22:21:11 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    sender.state = [self context4iTM3BoolForKey:iTM2SmartUpdateEnabledKey domain:iTM2ContextAllDomainsMask]? NSOnState:NSOffState;
    return [self context4iTM3BoolForKey:iTM2AutoUpdateEnabledKey domain:iTM2ContextAllDomainsMask];
}
@end

NSString * const iTM2AutoObserveWindowsEnabledKey = @"iTM2AutoObserveWindowsEnabled";
NSString * const iTM2AutoSaveDocumentsEnabledKey = @"iTM2AutoSaveDocumentsEnabled";
NSString * const iTM2AutoSaveIntervalKey = @"iTM2AutoSaveInterval";

#pragma mark =-=-=-=-=-=-=-=-  AUTO SAVE
@interface iTM2AutoController(PRIVATE)
+ (void)_UserDefaultsDidChange:(id) sender;
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
{DIAGNOSTIC4iTM3;
	INIT_POOL4iTM3;
//START4iTM3;
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
//END4iTM3;
	RELEASE_POOL4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  _UserDefaultsDidChange:
+ (void)_UserDefaultsDidChange:(id) sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1:05/04/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSTimeInterval newTimeInterval = [SUD floatForKey:iTM2AutoSaveIntervalKey]; 
    if (newTimeInterval != _iTM2_AutoSave_TimeInterval)
    {
        _iTM2_AutoSave_TimeInterval = newTimeInterval;
        [_iTM2_AutoSave_Timer invalidate];
        [_iTM2_AutoSave_Timer autorelease];
        _iTM2_AutoSave_Timer = [([self context4iTM3BoolForKey:iTM2AutoSaveDocumentsEnabledKey domain:iTM2ContextAllDomainsMask]?
            [NSTimer scheduledTimerWithTimeInterval:_iTM2_AutoSave_TimeInterval
                target:self selector:@selector(_TimedSaveAllDocuments:) userInfo:nil repeats:YES]
            :nil) retain];
    }
    else if ([self context4iTM3BoolForKey:iTM2AutoSaveDocumentsEnabledKey domain:iTM2ContextAllDomainsMask])
    {
        if (!_iTM2_AutoSave_Timer)
            _iTM2_AutoSave_Timer = [[NSTimer scheduledTimerWithTimeInterval:_iTM2_AutoSave_TimeInterval
                target:self selector:@selector(_TimedSaveAllDocuments:) userInfo:nil repeats:YES] retain];
    }
    else if (_iTM2_AutoSave_Timer)
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSEnumerator * E = [[SDC documents] objectEnumerator];
    NSDocument * D;
    [self postNotificationWithStatus4iTM3:
		NSLocalizedStringFromTableInBundle(@"Auto saving the documents.", TABLE, BUNDLE, "Status")];
    while((D = [E nextObject]))
        if ([D canAutoSave4iTM3])
            [D saveDocument:self];
    [self postNotificationWithStatus4iTM3:
		NSLocalizedStringFromTableInBundle(@"Documents saved.", TABLE, BUNDLE, "Status")];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2AutoUpdateWindowDidUpdateNotified:
+ (void)iTM2AutoUpdateWindowDidUpdateNotified:(NSNotification *) aNotification;
/*"Subclasses should not need to override this method.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Jan 18 22:21:11 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSWindow * W = [aNotification object];
    NSDocument * D = [W.windowController document];
    if ([D canAutoUpdate4iTM3]
            && [D context4iTM3BoolForKey:iTM2AutoUpdateEnabledKey domain:iTM2ContextAllDomainsMask]
                && [D needsToUpdate4iTM3])
    {
        if ([D context4iTM3BoolForKey:iTM2SmartUpdateEnabledKey domain:iTM2ContextAllDomainsMask])
        {
            // finding the front most window
            NSMutableArray * windows = [NSMutableArray array];
            NSEnumerator * E = [[NSApp orderedWindows] objectEnumerator];
            NSWindow * W;
            while((W = [E nextObject]))
            {
                if ([W isVisible] && [[W.windowController document] isEqual:D])
                {
                    [windows addObject:W];
                }
            }
            W = [windows.objectEnumerator nextObject];
            // is there a window?
            if (!W)
                return;
            // is there already a sheet attached to that window?
            if ([W attachedSheet])
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
                    D.fileURL);
        } else {
            NSError * ROR = nil;
            [D updateIfNeeded4iTM3Error:self.RORef4iTM3];
            REPORTERRORINMAINTHREAD4iTM3(1,@"",ROR);
        }
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  autoUpdateSheetDidDismiss:returnCode:document:
+ (void)autoUpdateSheetDidDismiss:(NSWindow *) sheet returnCode:(NSInteger) returnCode document:(NSDocument *) D;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1:03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//LOG4iTM3;
	[D autorelease];//was retained above
    switch(returnCode)
    {
        case NSAlertAlternateReturn:
            [D saveDocumentTo:self];//will try update once more
            break;
        case NSAlertOtherReturn://ignore the modification date
            [D recordFileModificationDateFromURL4iTM3:D.fileURL];
            break;
        case NSAlertDefaultReturn:
        default:;
            [D readFromURL:D.fileURL ofType:[D fileType] error:D.RORef4iTM3];
            break;
    }
    return;
}
@end

@implementation iTM2MainInstaller(AutoController)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2AutoControllerCompleteInstallation4iTM3
+ (void)zzzz_iTM2AutoControllerCompleteInstallation4iTM3;
/*"Description forthcoming;
 Version History: jlaurens AT users DOT sourceforge DOT net (12/07/2001)
 - 1.4 :jlaurens:20040514 
 To Do List:to be improved... to allow different signature
 "*/
{DIAGNOSTIC4iTM3;
	//START4iTM3;
    [iTM2AutoController class];
	//END4iTM3;
    return;
}
+ (void)prepareAutoKitCompleteInstallation4iTM3;
{
	if ([NSDocument swizzleInstanceMethodSelector4iTM3:@selector(SWZ_iTM2Auto_writeToURL:ofType:forSaveOperation:originalContentsURL:error:) error:NULL]
		&& [NSDocument swizzleInstanceMethodSelector4iTM3:@selector(SWZ_iTM2Auto_readFromURL:ofType:error:) error:NULL])
	{
		MILESTONE4iTM3((@"NSDocument(iTM2AutoKit)"),(@"No readFromURL:... patch, potential problems"));
	}	
}
@end
