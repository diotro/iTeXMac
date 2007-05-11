/*
//  iTM2TextFinderKit.m
//  iTeXMac2
//
//  Created by jlaurens@users.sourceforge.net on Mon Sep 03 2001.
//  Copyright © 2001-2002 Laurens'Tribune. All rights reserved.
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


#import <iTM2Foundation/iTM2ValidationKit.h>
#import <iTM2Foundation/iTM2BundleKit.h>
#import <iTM2Foundation/iTM2ResponderKit.h>
#import <iTM2Foundation/iTM2TextFinderKit.h>
#import <iTM2Foundation/iTM2NotificationKit.h>
#import <iTM2Foundation/iTM2InstallationKit.h>
#import <iTM2Foundation/iTM2Implementation.h>
#import <iTM2Foundation/iTM2ContextKit.h>

#define TABLE @"iTM2TextFinder"
#define BUNDLE [self classBundle]
#define MAIN @"Main"
#define STF [iTM2TextFinder sharedTextFinder]

@interface iTM2TextFinder(PRIVATE)
- (id) textView;// non retained, where the find/replace will occur
- (void) setTextView: (id) argument;
- (id) findWidget;
- (void) setFindWidget: (id) argument;
- (id) replaceWidget;
- (void) setReplaceWidget: (id) argument;
- (void) synchronizeFromUserInterface;
- (NSMutableArray *) findContexts;
- (void) recordFindContext;
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2TextFinder
/*"It is very very very closely based on the text finder sample provided by apple™. 
Fortunately, improvements have been made. However, I removed what concerns the attributes...
and added a validation process."*/
@implementation iTM2TextFinder
static id _iTM2TextFinder = nil;
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  load
+ (void) load;
/*"Description Forthcoming.
Version History: jlaurens@users.sourceforge.net (09/02/2001)
- 2.0: Fri Feb 25 09:23:47 GMT 2005
To Do List:
"*/
{
	iTM2_INIT_POOL;
//iTM2_START;
    [NSObject completeInstallationOf: self];
//iTM2_END;
	iTM2_RELEASE_POOL;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  textFinderCompleteInstallation
+ (void) textFinderCompleteInstallation;
/*"Description Forthcoming.
Version History: jlaurens@users.sourceforge.net (09/02/2001)
- 2.0: Fri Feb 25 09:23:47 GMT 2005
To Do List:
"*/
{
//iTM2_START;
	_iTM2TextFinder = [[self allocWithZone: [NSApp zone]] initWithWindowNibName: NSStringFromClass(self)];
	[SUD registerDefaults:
		[NSDictionary dictionaryWithObjectsAndKeys:
			[NSNumber numberWithInt: 10], @"iTM2TextFinderContextMaxCount", nil]];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  sharedTextFinder
+ (id) sharedTextFinder;
/*"Description Forthcoming.
Version History: jlaurens@users.sourceforge.net (09/02/2001)
- 1.1: 03/10/2002
To Do List:
"*/
{
//iTM2_START;
    return _iTM2TextFinder;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initWithWindow:
- (id) initWithWindow: (NSWindow *) window;
/*"Description Forthcoming.
Version History: jlaurens@users.sourceforge.net (09/02/2001)
- 2.0: Fri Feb 25 09:23:47 GMT 2005
To Do List:
"*/
{
//iTM2_START;
    if(_iTM2TextFinder)
    {
        if(![self isEqual: _iTM2TextFinder])
            [self release];
        return [_iTM2TextFinder retain];
    }
    else
    {
        if(self = [super initWithWindow: window])
        {
            [self setWrap: YES];
        }
        return _iTM2TextFinder = self;
    }
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initWithCoder
- (id) initWithCoder: (NSCoder *) aDecoder;
/*"Description Forthcoming.
Version History: jlaurens@users.sourceforge.net (09/02/2001)
- 2.0: Fri Feb 25 09:23:47 GMT 2005
To Do List: TEST
"*/
{
//iTM2_START;
    if(_iTM2TextFinder)
    {
        if(![self isEqual: _iTM2TextFinder])
            [self release];
        return [_iTM2TextFinder retain];
    }
    else
    {
        return _iTM2TextFinder = [super initWithCoder: aDecoder];
    }
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initWithTextView:
- (id) initWithTextView: (NSTextView *) TV;
/*"The only way to create an unshared instance. With no UI.
Version History: jlaurens@users.sourceforge.net (09/02/2001)
- 2.0: Fri Feb 25 09:23:47 GMT 2005
To Do List: TEST
"*/
{
//iTM2_START;
    if(self = [super init])
    {
        [self setTextView: TV];
    }
    return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  windowWillLoad
- (void) windowWillLoad;
/*"Description Forthcoming.
Version History: jlaurens@users.sourceforge.net (09/02/2001)
- 2.0: Fri Feb 25 09:23:47 GMT 2005
To Do List:
"*/
{
//iTM2_START;
    [super windowDidLoad];
    [self setWindowFrameAutosaveName: NSStringFromClass([self class])];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2TextFinderFixImplementation
- (void) iTM2TextFinderFixImplementation;
/*"Description Forthcoming.
Version History: jlaurens@users.sourceforge.net (09/02/2001)
- 2.0: Fri Feb 25 09:23:47 GMT 2005
To Do List:
"*/
{
//iTM2_START;
	id findContexts = [self findContexts];
	if([findContexts count])
		[IMPLEMENTATION takeModel: [NSMutableDictionary dictionaryWithDictionary: [findContexts objectAtIndex: 0]] ofType: MAIN];
	else
		[IMPLEMENTATION takeModel: [NSMutableDictionary dictionary] ofType: MAIN];
	[self enterFindPboardSelection: self];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  windowDidLoad
- (void) windowDidLoad;
/*"Description Forthcoming.
Version History: jlaurens@users.sourceforge.net (09/02/2001)
- 2.0: Fri Feb 25 09:23:47 GMT 2005
To Do List:
"*/
{
//iTM2_START;
    #warning use the defaults here
    NS_DURING
    [super windowDidLoad];
    findStringChangedSinceLastPasteboardUpdate = YES;
    [self validateWindowContent];
    [[self window] setDelegate: self];
    NS_HANDLER
    [NSApp reportException: localException];
    NS_ENDHANDLER
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  applicationWillResignActive:
- (void) applicationWillResignActive: (NSNotification *) aNotification;
/*"Description Forthcoming.
Version History: jlaurens@users.sourceforge.net (09/02/2001)
- 2.0: Fri Feb 25 09:23:47 GMT 2005
To Do List:
"*/
{
//iTM2_START;
    NSString * findString = [self findString];
    if([findString length]>0)
    {
        NSPasteboard *pasteboard = [NSPasteboard pasteboardWithName: NSFindPboard];
        [pasteboard declareTypes: [NSArray arrayWithObject: NSStringPboardType] owner: nil];
        [pasteboard setString: [self findString] forType: NSStringPboardType];
    }
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  enterFindPboardSelection:
- (void) enterFindPboardSelection: (id) irrelevant;
/*"Description Forthcoming.
Version History: jlaurens@users.sourceforge.net (09/02/2001)
- 2.0: Fri Feb 25 09:23:47 GMT 2005
To Do List:
"*/
{
//iTM2_START;
    NSPasteboard *pasteboard = [NSPasteboard pasteboardWithName: NSFindPboard];
    if ([[pasteboard types] containsObject: NSStringPboardType])
    {
        NSString *string = [pasteboard stringForType: NSStringPboardType];
        if ([string length])
        {
            [self setFindString: string];
        }
    }
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  isFindStringChangedSinceLastPboardUpdate
- (BOOL) isFindStringChangedSinceLastPboardUpdate;
/*"Description Forthcoming.
Version History: jlaurens@users.sourceforge.net (09/02/2001)
- 2.0: Fri Feb 25 09:23:47 GMT 2005
To Do List:
"*/
{
//iTM2_START;
    return [metaGETTER boolValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setFindStringChangedSinceLastPboardUpdate:
- (void) setFindStringChangedSinceLastPboardUpdate: (BOOL) yorn;
/*"Description Forthcoming.
Version History: jlaurens@users.sourceforge.net (09/02/2001)
- 2.0: Fri Feb 25 09:23:47 GMT 2005
To Do List:
"*/
{
//iTM2_START;
    metaSETTER([NSNumber numberWithBool: yorn]);
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  textView
- (id) textView;
/*"Description Forthcoming.
Version History: jlaurens@users.sourceforge.net (09/02/2001)
- 2.0: Fri Feb 25 09:23:47 GMT 2005
To Do List:
"*/
{
//iTM2_START;
    return [metaGETTER nonretainedObjectValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setTextView:
- (void) setTextView: (id) argument;
/*"Description Forthcoming.
Version History: jlaurens@users.sourceforge.net (09/02/2001)
- 2.0: Fri Feb 25 09:23:47 GMT 2005
To Do List:
"*/
{
//iTM2_START;
    metaSETTER([NSValue valueWithNonretainedObject: argument]);
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  findString
- (NSString *) findString;
/*"Description Forthcoming.
Version History: jlaurens@users.sourceforge.net (09/02/2001)
- 2.0: Fri Feb 25 09:23:47 GMT 2005
To Do List:
"*/
{
//iTM2_START;
    return modelGETTER(MAIN)?: [NSString string];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setFindString:
- (void) setFindString: (NSString *) aString;
/*"Description Forthcoming.
Version History: jlaurens@users.sourceforge.net (09/02/2001)
- 2.0: Fri Feb 25 09:23:47 GMT 2005
To Do List:
"*/
{
//iTM2_START;
    if(![aString isEqualToString: modelGETTER(MAIN)])
    {
        [self setFindStringChangedSinceLastPboardUpdate: YES];
        modelSETTER([[aString copy] autorelease], MAIN);
        [self setNumberOfOperations: 0];
    }
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  replaceString
- (NSString *) replaceString;
/*"Description Forthcoming.
Version History: jlaurens@users.sourceforge.net (09/02/2001)
- 2.0: Fri Feb 25 09:23:47 GMT 2005
To Do List:
"*/
{
//iTM2_START;
    return modelGETTER(MAIN)?: [NSString string];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setReplaceString:
- (void) setReplaceString: (NSString *) aString;
/*"Description Forthcoming.
Version History: jlaurens@users.sourceforge.net (09/02/2001)
- 2.0: Fri Feb 25 09:23:47 GMT 2005
To Do List:
"*/
{
//iTM2_START;
    if(![aString isEqualToString: modelGETTER(MAIN)])
    {
        modelSETTER([[aString copy] autorelease], MAIN);
        [self setNumberOfOperations: 0];
    }
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  isMute
- (BOOL) isMute;
/*"Description Forthcoming. Selection vs entire
Version History: jlaurens@users.sourceforge.net (09/02/2001)
- 1.2: 07/18/2002
To Do List: Collect the flags in a struct...
"*/
{
//iTM2_START;
    return [metaGETTER boolValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setMute:
- (void) setMute: (BOOL) flag;
/*"Description Forthcoming. Selection vs entire
Version History: jlaurens@users.sourceforge.net (09/02/2001)
- 1.2: 07/18/2002
To Do List: Collect the flags in a struct...
"*/
{
//iTM2_START;
    metaSETTER([NSNumber numberWithBool: flag]);
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  isEntireFile
- (BOOL) isEntireFile;
/*"Description Forthcoming. Selection vs entire
Version History: jlaurens@users.sourceforge.net (09/02/2001)
- 2.0: Fri Feb 25 09:23:47 GMT 2005
To Do List: Collect the flags in a struct...
"*/
{
//iTM2_START;
    return [modelGETTER(MAIN) boolValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setEntireFile:
- (void) setEntireFile: (BOOL) aFlag;
/*"Description Forthcoming.
Version History: jlaurens@users.sourceforge.net (09/02/2001)
- 2.0: Fri Feb 25 09:23:47 GMT 2005
To Do List:
"*/
{
//iTM2_START;
    modelSETTER([NSNumber numberWithBool: aFlag], MAIN);
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  isCaseSensitive
- (BOOL) isCaseSensitive;
/*"Description Forthcoming.
Version History: jlaurens@users.sourceforge.net (09/02/2001)
- 2.0: Fri Feb 25 09:23:47 GMT 2005
To Do List:
"*/
{
//iTM2_START;
    return [modelGETTER(MAIN) boolValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setCaseSensitive:
- (void) setCaseSensitive: (BOOL) aFlag;
/*"Description Forthcoming.
Version History: jlaurens@users.sourceforge.net (09/02/2001)
- 2.0: Fri Feb 25 09:23:47 GMT 2005
To Do List:
"*/
{
//iTM2_START;
    modelSETTER([NSNumber numberWithBool: aFlag], MAIN);
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  isWrap
- (BOOL) isWrap;
/*"Description Forthcoming.
Version History: jlaurens@users.sourceforge.net (09/02/2001)
- 1.1: 03/10/2002
To Do List:
"*/
{
//iTM2_START;
    return [modelGETTER(MAIN) boolValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setWrap:
- (void) setWrap: (BOOL) aFlag;
/*"Description Forthcoming.
Version History: jlaurens@users.sourceforge.net (09/02/2001)
- 1.1: 03/10/2002
To Do List:
"*/
{
//iTM2_START;
    modelSETTER([NSNumber numberWithBool: aFlag], MAIN);
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  numberOfOperations
- (unsigned) numberOfOperations;
/*"Description Forthcoming.
Version History: jlaurens@users.sourceforge.net (09/02/2001)
- 1.1: 03/10/2002
To Do List:
"*/
{
//iTM2_START;
    return [metaGETTER unsignedIntValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setNumberOfOperations:
- (void) setNumberOfOperations: (unsigned ) nops;
/*"Description Forthcoming.
Version History: jlaurens@users.sourceforge.net (09/02/2001)
- 1.1: 03/10/2002
To Do List:
"*/
{
//iTM2_START;
    metaSETTER([NSNumber numberWithUnsignedInt: nops]);
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  textViewToSearchIn:
- (NSTextView *) textViewToSearchIn;
/*"Description Forthcoming.
Version History: jlaurens@users.sourceforge.net (09/02/2001)
- 2.0: Fri Feb 25 09:23:47 GMT 2005
To Do List:
"*/
{
//iTM2_START;
	id _TextView = metaGETTER;
    if(_TextView)
        return _TextView;
    else
    {
		metaSETTER([NSApp targetForAction: @selector(iTM2TextFinderKit_NSText_Catcher:)]);
		return metaGETTER;
    }
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  findWidget
- (id) findWidget;
/*"Description Forthcoming.
Version History: jlaurens@users.sourceforge.net (09/02/2001)
- 2.0: Fri Feb 25 09:23:47 GMT 2005
To Do List:
"*/
{
//iTM2_START;
    return [metaGETTER nonretainedObjectValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setFindWidget:
- (void) setFindWidget: (id) argument;
/*"Description Forthcoming.
Version History: jlaurens@users.sourceforge.net (09/02/2001)
- 2.0: Fri Feb 25 09:23:47 GMT 2005
To Do List:
"*/
{
//iTM2_START;
    metaSETTER([NSValue valueWithNonretainedObject: argument]);
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  replaceWidget
- (id) replaceWidget;
/*"Description Forthcoming.
Version History: jlaurens@users.sourceforge.net (09/02/2001)
- 2.0: Fri Feb 25 09:23:47 GMT 2005
To Do List:
"*/
{
//iTM2_START;
    return [metaGETTER nonretainedObjectValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setReplaceWidget:
- (void) setReplaceWidget: (id) argument;
/*"Description Forthcoming.
Version History: jlaurens@users.sourceforge.net (09/02/2001)
- 2.0: Fri Feb 25 09:23:47 GMT 2005
To Do List:
"*/
{
//iTM2_START;
    metaSETTER([NSValue valueWithNonretainedObject: argument]);
//iTM2_END;
    return;
}
#pragma mark =-=-=-=-=-=-=-=-=-=-  TEXT FIELDS EDITED
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  findNextAndOrderFindPanelOut:
- (void) findNextAndOrderFindPanelOut: (id) sender;
/*"Description Forthcoming. USEFULL ???
Version History: jlaurens@users.sourceforge.net (09/02/2001)
- 2.0: Fri Feb 25 09:23:47 GMT 2005
To Do List:
"*/
{
//iTM2_START;
    [self findNext: sender];
    if ([self isLastFindSuccessful])
        [[self window] orderOut: sender];
    [self validateWindowContent];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateFindNextAndOrderFindPanelOut:
- (BOOL) validateFindNextAndOrderFindPanelOut: (id) sender;
/*"Description Forthcoming. USEFULL ???
Version History: jlaurens@users.sourceforge.net (09/02/2001)
- 2.0: Fri Feb 25 09:23:47 GMT 2005
To Do List:
"*/
{
//iTM2_START;
	// retrieving the find string field
	// this method is tricky and not really orthodox.
	// Some direct method could be used instead with the aid of the tag number
	// but I am not really fond of that
	if(![self findWidget] && sender)
	{
		[self setFindWidget: sender];
	}
    [sender setStringValue: [self findString]];
	if(![self isLastFindSuccessful])
		[sender selectText: nil];
//iTM2_END;
    return ([self textViewToSearchIn] != nil);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  replaceStringEdited:
- (void) replaceStringEdited: (id) sender;
/*"Description Forthcoming. USEFULL ???
Version History: jlaurens@users.sourceforge.net (09/02/2001)
- 2.0: Fri Feb 25 09:23:47 GMT 2005
To Do List:
"*/
{
//iTM2_START;
    [self synchronizeFromUserInterface];
	[self recordFindContext];
    [self replace: sender];
    if ([self isLastFindSuccessful])
        [[self window] orderOut: sender];
    [self validateWindowContent];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateReplaceStringEdited:
- (BOOL) validateReplaceStringEdited: (id) sender;
/*"Description Forthcoming. USEFULL ???
Version History: jlaurens@users.sourceforge.net (09/02/2001)
- 2.0: Fri Feb 25 09:23:47 GMT 2005
To Do List:
"*/
{
//iTM2_START;
	if(![self replaceWidget] && sender)
	{
		[self setReplaceWidget: sender];
	}
    [sender setStringValue: [self replaceString]];
//iTM2_END;
    return ([self textViewToSearchIn] != nil);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  synchronizeFromUserInterface
- (void) synchronizeFromUserInterface;
/*"Description Forthcoming. Tag = position in the matrix
Version History: jlaurens@users.sourceforge.net (09/02/2001)
- 2.0: Fri Feb 25 09:23:47 GMT 2005
To Do List:
"*/
{
//iTM2_START;
    if([self findWidget])
		[self setFindString: [[self findWidget] stringValue]];
    if([self replaceWidget])
		[self setReplaceString: [[self replaceWidget] stringValue]];
    [[self findWidget] selectText: nil];
    [[self replaceWidget] selectText: nil];
//iTM2_END;
    return;
}
#pragma mark =-=-=-=-=-=-=-=-=-=-  COMBO BOXING
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeFindStringFromStringValue:
- (void) takeFindStringFromStringValue: (id) sender;
/*"Description Forthcoming. USEFULL ???
Version History: jlaurens@users.sourceforge.net (09/02/2001)
- 2.0: Fri Feb 25 09:23:47 GMT 2005
To Do List:
"*/
{
//iTM2_START;
	NSEnumerator * E = [[self findContexts] objectEnumerator];
	NSDictionary * D;
	NSString * senderString = [sender stringValue];
	while(D = [E nextObject])
	{
		if([[D objectForKey: @"FindString"] isEqual: senderString])
		{
			[IMPLEMENTATION takeModel: D ofType: MAIN];
			[self validateWindowContent];			
			return;
		}
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateTakeFindStringFromStringValue:
- (BOOL) validateTakeFindStringFromStringValue: (id) sender;
/*"Description Forthcoming. USEFULL ???
Version History: jlaurens@users.sourceforge.net (09/02/2001)
- 2.0: Fri Feb 25 09:23:47 GMT 2005
To Do List:
"*/
{
//iTM2_START;
	// retrieving the find string field
	// this method is tricky and not really orthodox.
	// Some direct method could be used instead with the aid of the tag number
	// but I am not really fond of that
	[sender setUsesDataSource: YES];
	[sender setDataSource: self];
	[sender setDelegate: self];
	[sender reloadData];
//iTM2_END;
    return ([self textViewToSearchIn] != nil);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  findContexts
- (NSMutableArray *) findContexts;
/*"Description Forthcoming.
Version History: jlaurens@users.sourceforge.net (09/02/2001)
- 2.0: Fri Feb 25 09:23:47 GMT 2005
To Do List:
"*/
{
//iTM2_START;
	NSMutableArray * result = metaGETTER;
	[self contextValueForKey: @"iTM2TextFinderContexts"];
	if(!result)
	{
		id lazyResult = [self contextValueForKey: @"iTM2TextFinderContexts"];
		metaSETTER(([lazyResult isKindOfClass: [NSArray class]]? [[lazyResult mutableCopy] autorelease]: [NSMutableArray array]));
		result = metaGETTER;
		[self takeContextValue: result forKey: @"iTM2TextFinderContexts"];
	}
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  recordFindContext
- (void) recordFindContext;
/*"Description Forthcoming.
Version History: jlaurens@users.sourceforge.net (09/02/2001)
- 2.0: Fri Feb 25 09:23:47 GMT 2005
To Do List:
"*/
{
//iTM2_START;
	id context = [IMPLEMENTATION modelOfType: MAIN];
	NSMutableArray * findContexts = [self findContexts];
	NSEnumerator * E = [findContexts objectEnumerator];
	NSMutableArray * MRA = [NSMutableArray array];
	NSDictionary * D;
	NSString * findString = [self findString];
	while(D = [E nextObject])
	{
		if([[D objectForKey: @"FindString"] isEqual: findString])
		{
			[MRA addObject: D];
		}
	}
	[findContexts removeObjectsInArray: MRA];
	int wall = [SUD integerForKey: @"iTM2TextFinderContextMaxCount"];
	while([findContexts count] > wall)
		[findContexts removeLastObject];
	[findContexts insertObject: [NSDictionary dictionaryWithDictionary: context] atIndex: 0];
//iTM2_LOG(@"CONTEXT RECORDED: %@", [findContexts objectAtIndex: 0]);
	[self takeContextValue: findContexts forKey: @"iTM2TextFinderContexts"];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  numberOfItemsInComboBox:
- (int) numberOfItemsInComboBox: (NSComboBox *) aComboBox;
/*"Description Forthcoming.
Version History: jlaurens@users.sourceforge.net (09/02/2001)
- 2.0: Fri Feb 25 09:23:47 GMT 2005
To Do List:
"*/
{
//iTM2_START;
//iTM2_END;
//iTM2_LOG(@"[self findContexts] are: %@", [self findContexts]);
	return [[self findContexts] count];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  comboBox:objectValueForItemAtIndex:
- (id) comboBox: (NSComboBox *) aComboBox objectValueForItemAtIndex: (int) index;
/*"Description Forthcoming.
Version History: jlaurens@users.sourceforge.net (09/02/2001)
- 2.0: Fri Feb 25 09:23:47 GMT 2005
To Do List:
"*/
{
//iTM2_START;
	NSArray * findContexts = [self findContexts];
	if((index < 0) || !(index < [findContexts count]))
		return nil;
//iTM2_LOG(@"[findContexts objectAtIndex: index] is: %@", [findContexts objectAtIndex: index]);
	return [[findContexts objectAtIndex: index] objectForKey: @"FindString"];
//iTM2_END;
    return nil;
}
#if 0
- (void)comboBoxWillPopUp:(NSNotification *)notification;
- (void)comboBoxWillDismiss:(NSNotification *)notification;
- (void)comboBoxSelectionDidChange:(NSNotification *)notification;
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  comboBox:indexOfItemWithStringValue:
- (unsigned int) comboBox: (NSComboBox *) aComboBox indexOfItemWithStringValue: (NSString *) string;
/*"Description Forthcoming.
Version History: jlaurens@users.sourceforge.net (09/02/2001)
- 2.0: Fri Feb 25 09:23:47 GMT 2005
To Do List:
"*/
{
//iTM2_START;
//iTM2_END;
    return 0;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  comboBox:completedString:
- (NSString *) comboBox: (NSComboBox *) aComboBox completedString: (NSString *) string;
/*"Description Forthcoming.
Version History: jlaurens@users.sourceforge.net (09/02/2001)
- 2.0: Fri Feb 25 09:23:47 GMT 2005
To Do List:
"*/
{
//iTM2_START;
//iTM2_END;
    return string;
}
#endif

#pragma mark =-=-=-=-=-=-=-=-=-=-  FIND ACTIONS
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  find:
- (BOOL) find: (BOOL) direction;
/*"Description Forthcoming.
Version History: jlaurens@users.sourceforge.net (09/02/2001)
- 2.0: Fri Feb 25 09:23:47 GMT 2005
To Do List:
"*/
{
//iTM2_START;
    NSTextView * textView = [self textViewToSearchIn];
    NSString * textString = [textView string];
    NSString * findString = [self findString];
    unsigned _NumberOfOps = 0;
    if ([textString length] > 0)
    {
        if ([findString length] > 0)
        {
            NSRange range;
            unsigned options = 0;
            if (direction == Backward)
                options |= NSBackwardsSearch;
            if (![self isCaseSensitive])
                options |= NSCaseInsensitiveSearch;
            range = [textString rangeOfString: findString
                            selectedRange: [textView selectedRange] options: options wrap: [self isWrap]];
            if (range.length)
            {
                [textView setSelectedRange: range];
                [textView scrollRangeToVisible: range];
                _NumberOfOps = 1;
            }
        }
        else
        {
            if(![self isMute]) iTM2Beep();
            [self postNotificationWithStatus:
                NSLocalizedStringFromTableInBundle(@"No textView found.", TABLE, BUNDLE, nil)];
        }
    }
    else
    {
        if(![self isMute]) iTM2Beep();
        [self postNotificationWithStatus:
            NSLocalizedStringFromTableInBundle(@"No textView to search in.", TABLE, BUNDLE, nil)];
    }
	[self setNumberOfOperations: _NumberOfOps];
    if (![self isLastFindSuccessful])
    {
        if(![self isMute]) iTM2Beep();
        [self postNotificationWithStatus:
                NSLocalizedStringFromTableInBundle(@"Not found", TABLE, BUNDLE,
                        @"Status displayed in find panel when the find string is not found.")];
    }
    else
    {
        [self postNotificationWithStatus: @"OK"];
    }
    return [self isLastFindSuccessful];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  centerSelectionInVisibleArea:
- (void) centerSelectionInVisibleArea: (id) sender;
/*"Action forwarded the self's textFinder.
Version History: jlaurens@users.sourceforge.net (09/02/2001)
- 2.0: Fri Feb 25 09:23:47 GMT 2005
To Do List:
"*/
{
//iTM2_START;
    NSTextView * textView = [self textViewToSearchIn];
    [textView scrollRangeToVisible: [textView selectedRange]];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  findNext:
- (void) findNext: (id) sender;
/*"Description Forthcoming.
Version History: jlaurens@users.sourceforge.net (09/02/2001)
- 2.0: Fri Feb 25 09:23:47 GMT 2005
To Do List:
"*/
{
//iTM2_START;
    [self synchronizeFromUserInterface];
	[self recordFindContext];
    [self find: Forward];
    [self validateWindowContent];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateFindNext:
- (BOOL) validateFindNext: (id) sender;
/*"Description Forthcoming.
Version History: jlaurens@users.sourceforge.net (09/02/2001)
- 2.0: Fri Feb 25 09:23:47 GMT 2005
To Do List:
"*/
{
//iTM2_START;
//iTM2_END;
    return ([self textViewToSearchIn] != nil);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  findPrevious:
- (void) findPrevious: (id) sender;
/*"Description Forthcoming.
Version History: jlaurens@users.sourceforge.net (09/02/2001)
- 2.0: Fri Feb 25 09:23:47 GMT 2005
To Do List:
"*/
{
//iTM2_START;
    [self synchronizeFromUserInterface];
	[self recordFindContext];
    [self find: Backward];
    [self validateWindowContent];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateFindPrevious:
- (BOOL) validateFindPrevious: (id) sender;
/*"Description Forthcoming.
Version History: jlaurens@users.sourceforge.net (09/02/2001)
- 2.0: Fri Feb 25 09:23:47 GMT 2005
To Do List:
"*/
{
//iTM2_START;
//iTM2_END;
    return ([self textViewToSearchIn] != nil);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  replace:
- (void) replace: (id) sender;
/*"Description Forthcoming.
Version History: jlaurens@users.sourceforge.net (09/02/2001)
- 2.0: Fri Feb 25 09:23:47 GMT 2005
To Do List:
"*/
{
//iTM2_START;
    [self synchronizeFromUserInterface];
	[self recordFindContext];
    [[self textViewToSearchIn] insertText: [self replaceString]];
    [self validateWindowContent];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateReplace:
- (BOOL) validateReplace: (id) sender;
/*"Description Forthcoming.
Version History: jlaurens@users.sourceforge.net (09/02/2001)
- 2.0: Fri Feb 25 09:23:47 GMT 2005
To Do List:
"*/
{
//iTM2_START;
//iTM2_END;
    return ([self isLastFindSuccessful] && [self textViewToSearchIn]);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  replaceAndFind:
- (void) replaceAndFind: (id) sender;
/*"Description Forthcoming.
Version History: jlaurens@users.sourceforge.net (09/02/2001)
- 2.0: Fri Feb 25 09:23:47 GMT 2005
To Do List:
"*/
{
//iTM2_START;
    [self synchronizeFromUserInterface];
    [self replace: sender];
    [self findNext: sender];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateReplaceAndFind:
- (BOOL) validateReplaceAndFind: (id) sender;
/*"Description Forthcoming.
Version History: jlaurens@users.sourceforge.net (09/02/2001)
- 2.0: Fri Feb 25 09:23:47 GMT 2005
To Do List:
"*/
{
//iTM2_START;
//iTM2_END;
    return ([self isLastFindSuccessful] && [self textViewToSearchIn]);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  replaceAll:
- (void) replaceAll: (id) sender;
/*" The replaceAll: code is somewhat complex, and more complex than it used to be in DR1.  The main reason for this is to support undo. To play along with the undo mechanism in the textView object, this method goes through the shouldChangeTextInRange:replacementString: mechanism. In order to do that, it precomputes the section of the string that is being updated. An alternative would be for this guy to handle the undo for the replaceAll: operation itself, and register the appropriate changes. However, this is simpler...

Turns out this approach of building the new string and inserting it at the appropriate place in the actual textView storage also has an added benefit performance; it avoids copying the contents of the string around on every replace, which is significant in large files with many replacements. Of course there is the added cost of the temporary replacement string, but we try to compute that as tightly as possible beforehand to reduce the memory requirements.
Version History: Apple
- 2.0: Fri Feb 25 09:23:47 GMT 2005
To Do List: rewrite this to replace all in range...
"*/
{
//iTM2_START;
    NSTextView * textView = [self textViewToSearchIn];
    if (!textView)
    {
        if (![self isMute]) iTM2Beep();
        NSLog(@"No text view to search in found.");
//iTM2_END;
        return;
    }
    unsigned _NumberOfOps = 0;
    [self synchronizeFromUserInterface];
 	[self recordFindContext];
   NSString *findString = [self findString];
    if([findString length])
    {
        NSTextStorage *textStorage = [textView textStorage];
        NSString *textString = [textView string];
        NSRange replaceRange = [self isEntireFile] ? NSMakeRange(0, [textStorage length]) : [textView selectedRange];
        unsigned searchOption = ([self isCaseSensitive] ? 0: NSCaseInsensitiveSearch);
        NSRange firstOccurence;
        
        // Find the first occurence of the string being replaced; if not found, we're done!
        firstOccurence = [textString rangeOfString:findString options:searchOption range:replaceRange];
        if (firstOccurence.length > 0)
        {
	    NSAutoreleasePool *pool;
	    NSString *targetString = findString;
	    NSString *replaceString = [self replaceString];
            NSMutableAttributedString *temp;	/* This is the temporary work string in which we will do the replacements... */
            NSRange rangeInOriginalString;	/* Range in the original string where we do the searches */

	    // Find the last occurence of the string and union it with the first occurence to compute the tightest range...
            rangeInOriginalString = replaceRange = NSUnionRange(firstOccurence, [textString rangeOfString:targetString options:NSBackwardsSearch|searchOption range:replaceRange]);

            temp = [[NSMutableAttributedString alloc] init];

            [temp beginEditing];

	    // The following loop can execute an unlimited number of times, and it could have autorelease activity.
	    // To keep things under control, we use a pool, but to be a bit efficient, instead of emptying everytime through
	    // the loop, we do it every so often. We can only do this as long as autoreleased items are not supposed to
	    // survive between the invocations of the pool!

    	    pool = [[NSAutoreleasePool alloc] init];

            while (rangeInOriginalString.length > 0) {
                NSRange foundRange = [textString rangeOfString:targetString options:searchOption range:rangeInOriginalString];
		// Because we computed the tightest range above, foundRange should always be valid.
		NSRange rangeToCopy = NSMakeRange(rangeInOriginalString.location, foundRange.location - rangeInOriginalString.location + 1);	// Copy upto the start of the found range plus one char (to maintain attributes with the overlap)...
                [temp appendAttributedString:[textStorage attributedSubstringFromRange:rangeToCopy]];
                [temp replaceCharactersInRange:NSMakeRange([temp length] - 1, 1) withString:replaceString];
                rangeInOriginalString.length -= NSMaxRange(foundRange) - rangeInOriginalString.location;
                rangeInOriginalString.location = NSMaxRange(foundRange);
                _NumberOfOps++;
	  	if (_NumberOfOps % 100 == 0) {	// Refresh the pool... See warning above!
		    [pool release];
		    pool = [[NSAutoreleasePool alloc] init];
		}
            }

	    [pool release];

            [temp endEditing];

	    // Now modify the original string
            if ([textView shouldChangeTextInRange:replaceRange replacementString:[temp string]]) {
                [textStorage replaceCharactersInRange:replaceRange withAttributedString:temp];
                [textView didChangeText];
//                [textView replaceCharactersInRange:replaceRange withAttributedString:temp];
            } else {	// For some reason the string didn't want to be modified. Bizarre...
                _NumberOfOps = 0;
            }
            [temp autorelease];
        }
        if ([self isLastFindSuccessful])
        {
            [self postNotificationWithStatus:
                [NSString localizedStringWithFormat:NSLocalizedStringFromTableInBundle(@"%d replaced",
                    TABLE, BUNDLE,
                        @"Status displayed in find panel when indicated number of matches are replaced."),
                            _NumberOfOps]];
        }
        else
        {
            if(![self isMute]) iTM2Beep();
            [self postNotificationWithStatus:
                NSLocalizedStringFromTableInBundle(@"Not found",
                    TABLE, BUNDLE,
                        @"Status displayed in find panel when the find string is not found.")];
        }
    }
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateReplaceAll:
- (BOOL) validateReplaceAll: (id) sender;
/*"Description Forthcoming.
Version History: jlaurens@users.sourceforge.net (09/02/2001)
- 2.0: Fri Feb 25 09:23:47 GMT 2005
To Do List:
"*/
{
//iTM2_START;
//iTM2_END;
    return ([self textViewToSearchIn] != nil);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  replaceAllInSelection:
- (void) replaceAllInSelection: (id) sender;
/*" The replaceAll: code is somewhat complex, and more complex than it used to be in DR1.  The main reason for this is to support undo. To play along with the undo mechanism in the textView object, this method goes through the shouldChangeTextInRange:replacementString: mechanism. In order to do that, it precomputes the section of the string that is being updated. An alternative would be for this guy to handle the undo for the replaceAll: operation itself, and register the appropriate changes. However, this is simpler...

Turns out this approach of building the new string and inserting it at the appropriate place in the actual textView storage also has an added benefit performance; it avoids copying the contents of the string around on every replace, which is significant in large files with many replacements. Of course there is the added cost of the temporary replacement string, but we try to compute that as tightly as possible beforehand to reduce the memory requirements.
Version History: Apple
- 2.0: Fri Feb 25 09:23:47 GMT 2005
To Do List: rewrite this to replace all in range...
"*/
{
//iTM2_START;
    NSTextView * textView = [self textViewToSearchIn];
    if (!textView)
    {
        if (![self isMute]) iTM2Beep();
        NSLog(@"No text view to search in found.");
//iTM2_END;
        return;
    }
    [self synchronizeFromUserInterface];
	[self recordFindContext];
    NSString *findString = [self findString];
    unsigned _NumberOfOps = 0;
    if([findString length])
    {
        NSTextStorage *textStorage = [textView textStorage];
        NSString *textString = [textView string];
        NSRange replaceRange = [self isEntireFile] ? NSMakeRange(0, [textStorage length]) : [textView selectedRange];
        unsigned searchOption = ([self isCaseSensitive] ? 0: NSCaseInsensitiveSearch);
        NSRange firstOccurence;
        
        // Find the first occurence of the string being replaced; if not found, we're done!
        firstOccurence = [textString rangeOfString:findString options:searchOption range:replaceRange];
        if (firstOccurence.length > 0)
        {
	    NSAutoreleasePool *pool;
	    NSString *targetString = findString;
	    NSString *replaceString = [self replaceString];
            NSMutableAttributedString *temp;	/* This is the temporary work string in which we will do the replacements... */
            NSRange rangeInOriginalString;	/* Range in the original string where we do the searches */

	    // Find the last occurence of the string and union it with the first occurence to compute the tightest range...
            rangeInOriginalString = replaceRange = NSUnionRange(firstOccurence, [textString rangeOfString:targetString options:NSBackwardsSearch|searchOption range:replaceRange]);

            temp = [[NSMutableAttributedString alloc] init];

            [temp beginEditing];

	    // The following loop can execute an unlimited number of times, and it could have autorelease activity.
	    // To keep things under control, we use a pool, but to be a bit efficient, instead of emptying everytime through
	    // the loop, we do it every so often. We can only do this as long as autoreleased items are not supposed to
	    // survive between the invocations of the pool!

    	    pool = [[NSAutoreleasePool alloc] init];

            while (rangeInOriginalString.length > 0) {
                NSRange foundRange = [textString rangeOfString:targetString options:searchOption range:rangeInOriginalString];
		// Because we computed the tightest range above, foundRange should always be valid.
		NSRange rangeToCopy = NSMakeRange(rangeInOriginalString.location, foundRange.location - rangeInOriginalString.location + 1);	// Copy upto the start of the found range plus one char (to maintain attributes with the overlap)...
                [temp appendAttributedString:[textStorage attributedSubstringFromRange:rangeToCopy]];
                [temp replaceCharactersInRange:NSMakeRange([temp length] - 1, 1) withString:replaceString];
                rangeInOriginalString.length -= NSMaxRange(foundRange) - rangeInOriginalString.location;
                rangeInOriginalString.location = NSMaxRange(foundRange);
                _NumberOfOps++;
	  	if (_NumberOfOps % 100 == 0) {	// Refresh the pool... See warning above!
		    [pool release];
		    pool = [[NSAutoreleasePool alloc] init];
		}
            }

	    [pool release];

            [temp endEditing];

	    // Now modify the original string
            if ([textView shouldChangeTextInRange:replaceRange replacementString:[temp string]]) {
                [textStorage replaceCharactersInRange:replaceRange withAttributedString:temp];
                [textView didChangeText];
//                [textView replaceCharactersInRange:replaceRange withAttributedString:temp];
            } else {	// For some reason the string didn't want to be modified. Bizarre...
                _NumberOfOps = 0;
            }

            [temp autorelease];
        }
        if ([self isLastFindSuccessful])
        {
            [self postNotificationWithStatus:
                [NSString localizedStringWithFormat:NSLocalizedStringFromTableInBundle(@"%d replaced",
                    TABLE, BUNDLE,
                        @"Status displayed in find panel when indicated number of matches are replaced."),
                            _NumberOfOps]];
        }
        else
        {
            if(![self isMute]) iTM2Beep();
            [self postNotificationWithStatus:
                NSLocalizedStringFromTableInBundle(@"Not found",
                    TABLE, BUNDLE,
                        @"Status displayed in find panel when the find string is not found.")];
        }
    }
	[self setNumberOfOperations: _NumberOfOps];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateReplaceAllInSelection:
- (BOOL) validateReplaceAllInSelection: (id) sender;
/*"Description Forthcoming.
Version History: jlaurens@users.sourceforge.net (09/02/2001)
- 2.0: Fri Feb 25 09:23:47 GMT 2005
To Do List:
"*/
{
//iTM2_START;
//iTM2_END;
    return ([self textViewToSearchIn] != nil);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleWrap:
- (IBAction) toggleWrap: (id) sender;
/*"Description Forthcoming.
Version History: jlaurens@users.sourceforge.net (09/02/2001)
- 2.0: Fri Feb 25 09:23:47 GMT 2005
To Do List:
"*/
{
//iTM2_START;
	BOOL old = [self isWrap];
	[self setWrap: !old];
	[self validateWindowContent];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleWrap:
- (BOOL) validateToggleWrap: (id) sender;
/*"Description Forthcoming.
Version History: jlaurens@users.sourceforge.net (09/02/2001)
- 2.0: Fri Feb 25 09:23:47 GMT 2005
To Do List:
"*/
{
//iTM2_START;
	[sender setState: ([self isWrap]? NSOnState: NSOffState)];
//iTM2_END;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleIgnoreCase:
- (IBAction) toggleIgnoreCase: (id) sender;
/*"Description Forthcoming.
Version History: jlaurens@users.sourceforge.net (09/02/2001)
- 2.0: Fri Feb 25 09:23:47 GMT 2005
To Do List:
"*/
{
//iTM2_START;
	BOOL old = [self isCaseSensitive];
	[self setCaseSensitive: !old];
	[self validateWindowContent];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleIgnoreCase:
- (BOOL) validateToggleIgnoreCase: (id) sender;
/*"Description Forthcoming.
Version History: jlaurens@users.sourceforge.net (09/02/2001)
- 2.0: Fri Feb 25 09:23:47 GMT 2005
To Do List:
"*/
{
//iTM2_START;
	[sender setState: ([self isCaseSensitive]? NSOffState: NSOnState)];
//iTM2_END;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeReplaceAllScopeFromSelectedCellTag:
- (IBAction) takeReplaceAllScopeFromSelectedCellTag: (id) sender;
/*"Description Forthcoming.
Version History: jlaurens@users.sourceforge.net (09/02/2001)
- 2.0: Fri Feb 25 09:23:47 GMT 2005
To Do List:
"*/
{
//iTM2_START;
	[self setEntireFile: ([[sender selectedCell] tag] == 0)];
	[self validateWindowContent];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateTakeReplaceAllScopeFromSelectedCellTag:
- (BOOL) validateTakeReplaceAllScopeFromSelectedCellTag: (id) sender;
/*"Description Forthcoming.
Version History: jlaurens@users.sourceforge.net (09/02/2001)
- 2.0: Fri Feb 25 09:23:47 GMT 2005
To Do List:
"*/
{
//iTM2_START;
	[sender deselectAllCells];
	if([self isEntireFile])
		[sender selectCellWithTag: 0];
	else
		[sender selectCellWithTag: 1];
//iTM2_END;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  enterSelection:
- (void) enterSelection: (id) sender;
/*"Description Forthcoming.
Version History: jlaurens@users.sourceforge.net (09/02/2001)
- 2.0: Fri Feb 25 09:23:47 GMT 2005
To Do List:
"*/
{
//iTM2_START;
    NSText * text = [NSApp targetForAction: @selector(iTM2TextFinderKit_NSText_Catcher:)];
    NSRange selectedRange = [text selectedRange];
    if((selectedRange.length > 0) && [text respondsToSelector: @selector(string)])
    {
        NSString * S = [[text string] substringWithRange: [text selectedRange]];
        [self setFindString: S];
        [[self findWidget] setStringValue: S];
    }
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  isLastFindSuccessful
- (BOOL) isLastFindSuccessful;
/*"Description Forthcoming.
Version History: jlaurens@users.sourceforge.net (09/02/2001)
- 2.0: Fri Feb 25 09:23:47 GMT 2005
To Do List:
"*/
{
//iTM2_START;
    return [self numberOfOperations] > 0;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  windowDidBecomeKey:
- (void) windowDidBecomeKey: (NSNotification *) notification;
/*"Description forthcoming.
Version History: jlaurens@users.sourceforge.net (09/02/2001)
- 2.0: Fri Feb 25 09:23:47 GMT 2005
To Do List:
"*/
{
//iTM2_START;
    [[notification object] makeFirstResponder: [self findWidget]];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  showFindPanel:
- (void) showFindPanel: (id) irrelevant;
/*"Description Forthcoming and avalidates the user interface.
Version History: jlaurens@users.sourceforge.net (09/02/2001)
- 2.0: Fri Feb 25 09:23:47 GMT 2005
To Do List:
"*/
{
//iTM2_START;
    [self postNotificationWithStatus: @""];
    [self validateWindowContent];
    [[self window] makeKeyAndOrderFront: nil];
//iTM2_END;
    return;
}
#if 0
- (IBAction) findNextAndOrderFindPanelOut: (id) sender;
- (IBAction) replaceStringEdited: (id) sender;
#endif
@end


@implementation NSString (iTM2TextFinderKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  rangeOfString:selectedRange:options:wrap:
- (NSRange) rangeOfString: (NSString *) aString selectedRange: (NSRange) aSelectedRange options: (unsigned) options wrap: (BOOL) wrap;
/*"Description Forthcoming.
Version History: Apple, jlaurens@users.sourceforge.net (09/02/2001)
- 2.0: Fri Feb 25 09:23:47 GMT 2005
To Do List:
"*/
{
//iTM2_START;
//NSLog(@"self: <%@>", self);
//NSLog(@"rangeOfString: <%@>", aString);
//NSLog(@"selectedRange: %@", NSStringFromRange(aSelectedRange));
//NSLog(@"options: %i", options);
//NSLog(@"wrap: %@", (wrap? @"Y": @"N"));
    BOOL forwards = (options & NSBackwardsSearch) == 0;
    unsigned length = [self length];
    NSRange searchRange, range;
    if (forwards)
	{
		searchRange.location = NSMaxRange(aSelectedRange);
		searchRange.length = length - searchRange.location;
		range = [self rangeOfString: aString options: options range: searchRange];
		if ((range.length == 0) && wrap)
		{	/* If not found look at the first part of the string */
		searchRange.location = 0;
			searchRange.length = aSelectedRange.location;
			range = [self rangeOfString: aString options: options range: searchRange];
		}
	}
    else
    {
	searchRange.location = 0;
	searchRange.length = aSelectedRange.location;
        range = [self rangeOfString: aString options: options range: searchRange];
//NSLog(NSStringFromRange(searchRange));
//NSLog(NSStringFromRange(range));
        if ((range.length == 0) && wrap)
        {
            searchRange.location = NSMaxRange(aSelectedRange);
            searchRange.length = length - searchRange.location;
            range = [self rangeOfString: aString options: options range: searchRange];
        }
//NSLog(@"DOUBLE");
//NSLog(NSStringFromRange(range));
    }
    return range;
}        
@end

@implementation NSText(iTM2TextFinder)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2TextFinderKit_NSText_Catcher:
- (IBAction) iTM2TextFinderKit_NSText_Catcher: (id) sender;
/*"Description Forthcoming.
Version History: jlaurens@users.sourceforge.net (09/02/2001)
- 2.0: Fri Feb 25 09:23:47 GMT 2005
To Do List:
"*/
{
//iTM2_START;
//iTM2_END;
    return;
}
@end

@interface NSTextView_iTM2TextFinder: NSTextView
- (IBAction) performFindPanelAction: (id) sender;
@end

#import <objc/objc-runtime.h>
#import <objc/objc-class.h>

@implementation NSTextView_iTM2TextFinder
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  load
+ (void) load;
/*"Description Forthcoming.
Version History: jlaurens@users.sourceforge.net (09/02/2001)
- 2.0: Fri Feb 25 09:23:47 GMT 2005
To Do List:
"*/
{
	iTM2_INIT_POOL;
//iTM2_START;
    [NSObject fixInstallationOf: self];
//iTM2_END;
	iTM2_RELEASE_POOL;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  textFinderFixInstallation
+ (void) textFinderFixInstallation;
/*"Description Forthcoming.
Version History: jlaurens@users.sourceforge.net (09/02/2001)
- 2.0: Fri Feb 25 09:23:47 GMT 2005
To Do List:
"*/
{
//iTM2_START;
	if(![NSTextView instancesRespondToSelector: @selector(performFindPanelAction:)]
			|| ![SUD boolForKey: @"iTM2UseCocoaFindPanel"])
		iTM2NamedClassPoseAs("NSTextView_iTM2TextFinder", "NSTextView");
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  performFindPanelAction:
- (IBAction) performFindPanelAction: (id) sender
/*"Description Forthcoming.
Version History: jlaurens@users.sourceforge.net (09/02/2001)
- 2.0: Fri Feb 25 09:23:47 GMT 2005
To Do List:
"*/
{
//iTM2_START;
	switch([sender tag])
	{
		case iTM2FindPanelActionNext: [STF findNext: sender]; return;
		case iTM2FindPanelActionPrevious: [STF findPrevious: sender]; return;
		case iTM2FindPanelActionReplaceAll: [STF replaceAll: sender]; return;
		case iTM2FindPanelActionReplace: [STF replace: sender]; return;
		case iTM2FindPanelActionReplaceAndFind: [STF replaceAndFind: sender]; return;
		case iTM2FindPanelActionSetFindString: [STF enterSelection: sender]; return;
		case iTM2FindPanelActionReplaceAllInSelection: [STF replaceAllInSelection: sender]; return;
		case iTM2FindPanelActionShowFindPanel:
		default: [STF showFindPanel: sender]; return;
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validatePerformFindPanelAction:
- (BOOL) validatePerformFindPanelAction: (NSMenuItem *) sender;
/*"Example. the object is not in the responder chain.
Version History: jlaurens@users.sourceforge.net (09/02/2001)
- 2.0: Fri Feb 25 09:23:47 GMT 2005
To Do List:
"*/
{
//iTM2_START;
	id target = [STF textViewToSearchIn];
	if(!target)
		return [sender tag] == iTM2FindPanelActionShowFindPanel;
	switch([sender tag])
	{
		case iTM2FindPanelActionNext:
		case iTM2FindPanelActionPrevious:
		case iTM2FindPanelActionReplace:
		case iTM2FindPanelActionReplaceAndFind:
		case iTM2FindPanelActionReplaceAll:
		case iTM2FindPanelActionReplaceAllInSelection: return ([[STF findString] length]>0)&&([[target string] length]>0);
		case iTM2FindPanelActionSetFindString: return [target selectedRange].length > 0;
		case iTM2FindPanelActionShowFindPanel:
		default: return YES;
	}
    return NO;
}
@end


@implementation NSTextView(iTM2TextFinder)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  performMoreFindAction:
- (void) performMoreFindAction: (id) sender
/*"Description Forthcoming.
Version History: jlaurens@users.sourceforge.net (09/02/2001)
- 2.0: Fri Feb 25 09:23:47 GMT 2005
To Do List:
"*/
{
//iTM2_START;
//iTM2_LOG(@"[sender tag] is: %i", [sender tag]);
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validatePerformMoreFindAction:
- (BOOL) validatePerformMoreFindAction: (id) sender
/*"Description Forthcoming.
Version History: jlaurens@users.sourceforge.net (09/02/2001)
- 2.0: Fri Feb 25 09:23:47 GMT 2005
To Do List:
"*/
{
//iTM2_START;
//iTM2_END;
    return YES;
}
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2FindResponder
/*"Description forthcoming."*/
#if 0
@implementation iTM2FindResponder
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  textFinder
- (id) textFinder;
/*"Defaults implementation returns the iTM2TextFinder defaults instance.
Version History: jlaurens@users.sourceforge.net (09/02/2001)
- 2.0: Fri Feb 25 09:23:47 GMT 2005
To Do List:
"*/
{
    return _iTM2TextFinder;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  findPrevious:
- (void) findPrevious: (id) sender;
/*"Action forwarded the self's textFinder.
Version History: jlaurens@users.sourceforge.net (09/02/2001)
- 2.0: Fri Feb 25 09:23:47 GMT 2005
To Do List:
"*/
{
//iTM2_START;
    [[self textFinder] performSelector: _cmd withObject: sender];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  replace:
- (void) replace: (id) sender;
/*"Action forwarded the self's textFinder.
Version History: jlaurens@users.sourceforge.net (09/02/2001)
- 2.0: Fri Feb 25 09:23:47 GMT 2005
To Do List:
"*/
{
//iTM2_START;
    [[self textFinder] performSelector: _cmd withObject: sender];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  replaceAndFind:
- (void) replaceAndFind:(id) sender;
/*"Action forwarded the self's textFinder.
Version History: jlaurens@users.sourceforge.net (09/02/2001)
- 2.0: Fri Feb 25 09:23:47 GMT 2005
To Do List:
"*/
{
//iTM2_START;
    [[self textFinder] performSelector: _cmd withObject: sender];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  enterSelection:
- (void) enterSelection: (id) sender;
/*"Action forwarded the self's textFinder.
Version History: jlaurens@users.sourceforge.net (09/02/2001)
- 2.0: Fri Feb 25 09:23:47 GMT 2005
To Do List:
"*/
{
//iTM2_START;
    [[self textFinder] performSelector: _cmd withObject: sender];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  enterFindPboardSelection:
- (void) enterFindPboardSelection: (id) sender;
/*"Action forwarded the self's textFinder.
Version History: jlaurens@users.sourceforge.net (09/02/2001)
- 2.0: Fri Feb 25 09:23:47 GMT 2005
To Do List:
"*/
{
//iTM2_START;
    [[self textFinder] performSelector: _cmd withObject: sender];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  centerSelectionInVisibleArea:
- (void) centerSelectionInVisibleArea: (id) sender;
/*"Action forwarded the self's textFinder.
Version History: jlaurens@users.sourceforge.net (09/02/2001)
- 2.0: Fri Feb 25 09:23:47 GMT 2005
To Do List:
"*/
{
//iTM2_START;
    NSTextView * textView = [[self textFinder] textViewToSearchIn];
    [textView scrollRangeToVisible: [textView selectedRange]];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  replaceAll:
- (void) replaceAll: (id) sender;
/*"Action forwarded the self's textFinder.
Version History: jlaurens@users.sourceforge.net (09/02/2001)
- 2.0: Fri Feb 25 09:23:47 GMT 2005
To Do List:
"*/
{
//iTM2_START;
    [[self textFinder] performSelector: _cmd withObject: sender];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  showFindPanel:
- (void) showFindPanel: (id) sender;
/*"Description Forthcoming.
Version History: jlaurens@users.sourceforge.net (09/02/2001)
- 2.0: Fri Feb 25 09:23:47 GMT 2005
To Do List:
"*/
{
//iTM2_START;
    [[self textFinder] performSelector: _cmd withObject: sender];
    return;
}
@end
#endif
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2TextFinderKit

#if 0
@interface NSButton_iTM2TextFinder: NSButton
- (void) performFindPanelAction: (id) sender;
@end

@implementation NSButton_iTM2TextFinder
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  load
+ (void) load;
/*"Description Forthcoming.
Version History: jlaurens@users.sourceforge.net (09/02/2001)
- 2.0: Fri Feb 25 09:23:47 GMT 2005
To Do List:
"*/
{
	iTM2_INIT_POOL;
//iTM2_START;
	iTM2NamedClassPoseAs("NSButton_iTM2TextFinder", "NSButton");
//iTM2_END;
	iTM2_RELEASE_POOL;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setEnabled:
- (void)setEnabled:(BOOL)flag;
/*"Description Forthcoming.
Version History: jlaurens@users.sourceforge.net (09/02/2001)
- 2.0: Fri Feb 25 09:23:47 GMT 2005
To Do List:
"*/
{
//iTM2_START;
	if(!flag && [self action] == @selector(performFindPanelAction:))
	{
//iTM2_LOG(@"NOOOOOOOOOOO...");
		[super setEnabled: ([[iTM2TextFinder sharedTextFinder] textViewToSearchIn] != nil)];
	}
	else
		[super setEnabled: flag];
//iTM2_END;
    return;
}
@end
#endif
