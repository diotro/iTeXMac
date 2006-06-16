/*
//  iTM2WindowsMenuKit.m
//  iTeXMac2
//
//  @version Subversion: $Id$ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Tue Jan  4 07:48:24 GMT 2005.
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
//  GPL addendum: Any simple modification of the present code which purpose is to remove bug,
//  improve efficiency in both code execution and code reading or writing should be addressed
//  to the actual developper team.
//
//  Version history: (format "- date:contribution(contributor)") 
//  To Do List: (format "- proposition(percentage actually done)")
*/

NSString * iTM2ProjectLocalizedDocumentsName = nil;
NSString * iTM2ProjectLocalizedNoDocumentName = nil;
NSString * iTM2ProjectLocalizedAddDocumentName = nil;
NSString * iTM2ProjectLocalizedAddCurrentDocumentName = nil;

#import "iTM2WindowsMenuKit.h"
#import <iTM2Foundation/iTM2ContextKit.h>
#import <iTM2Foundation/iTM2InstallationKit.h>
#import <iTM2Foundation/iTM2JAGUARSupportKit.h>
#import <iTM2Foundation/iTM2ProjectDocumentKit.h>
#import <iTM2Foundation/iTM2DocumentKit.h>
#import <iTM2Foundation/iTM2NotificationKit.h>
#import <iTM2Foundation/iTM2MenuKit.h>
#import <iTM2Foundation/iTM2WindowKit.h>

@implementation iTM2ProjectDocument(WindowMenuKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= updateWindowsSubmenu:
-(void)updateWindowsSubmenu:(NSMenu *)M;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (10/04/2001)
- 2.0: Fri Apr 16 11:39:43 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_LOG(@"=-=-=-=-=-  [SDC documents] are: %@", [SDC documents]);
	// populating the menu with project inspectors
	NSMutableArray * MRA = [NSMutableArray array];
#warning EVERYTHING IS WELL DECLARED, on 10.2 I have 2 warnings here
    NSString * type = [[self class] inspectorType];
	NSEnumerator * E = [[NSWindowController inspectorModesForType:type] objectEnumerator];
    NSString * mode;
	while(mode = [E nextObject])
	{
        Class inspectorClass = [NSWindowController inspectorClassForType:type mode:mode variant:iTM2DefaultInspectorVariant];
//iTM2_LOG(@"[inspectorClass inspectorType] is: %@(%@)", [inspectorClass inspectorType], type);
//iTM2_LOG(@"[inspectorClass inspectorMode] is: %@(%@)", [inspectorClass inspectorMode], mode);
//iTM2_LOG(@"[inspectorClass inspectorVariant] is: %@(%@)", [inspectorClass inspectorVariant], iTM2DefaultInspectorVariant);
        if(inspectorClass == Nil)
        {
            inspectorClass = [[NSWindowController inspectorClassesEnumeratorForType:type mode:mode] nextObject];
//iTM2_LOG(@"[C inspectorType] is: %@(%@)", [C inspectorType], type);
//iTM2_LOG(@"[C inspectorMode] is: %@(%@)", [C inspectorMode], mode);
//iTM2_LOG(@"[C inspectorVariant] is: %@(%@)", [C inspectorVariant], iTM2DefaultInspectorVariant);
        }
        if(inspectorClass != Nil)
        {
            NSMenuItem * MI = [[[NSMenuItem allocWithZone:[NSMenu menuZone]]
                initWithTitle: [inspectorClass prettyInspectorMode]
                    action: @selector(projectEditUsingRepresentedInspectorMode:) keyEquivalent: @""] autorelease];
            [MI setTarget:nil];
            [MI setRepresentedObject:mode];
            [MRA addObject:MI];
        }
	}
	if([MRA count])
	{
		E = [[MRA sortedArrayUsingSelector:@selector(compareUsingTitle:)] objectEnumerator];
		NSMenuItem * MI = nil;
		while(MI = [E nextObject])
			[M addItem:MI];
	}
#if 1
	// preparing the list of documents
	E = [[self allKeys] objectEnumerator];
	NSMutableDictionary * MD = [NSMutableDictionary dictionary];
	NSString * S;
	while(S = [E nextObject])
	{
		NSString * FN = [self relativeFileNameForKey:S];
		if([FN length])
			[MD setObject:S forKey:FN];
	}
	NSArray * sortedKeys = [[MD allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
#if 0
	// adding the master document
	NSString * key = [self masterFileKey];
	[M addItem:[NSMenuItem separatorItem]];
	[M addItemWithTitle:_iTM2ProjectLocalizedMasterName action:NULL keyEquivalent:@""];
	if([key length])
	{
		S = [self relativeFileNameForKey:key];
		NSMenuItem * MI = [[[NSMenuItem allocWithZone:[NSMenu menuZone]]
					initWithTitle: S
						action: @selector(projectEditDocumentUsingRepresentedObject:) keyEquivalent: @""] autorelease];
		[MI setIndentationLevel:iTM2WindowsMenuItemIndentationLevel];
		[M addItem:MI];
		[MI setTarget:nil];
		[MI setRepresentedObject:[MD objectForKey:S]];	
	}
	else
	{
		// get the list of file documents
		NSMenuItem * MI = [[[NSMenuItem allocWithZone:[NSMenu menuZone]]
					initWithTitle: _iTM2ProjectLocalizedChooseMasterName
						action: NULL keyEquivalent: @""] autorelease];
		[M addItem:MI];
		NSMenu * M = [[[NSMenu allocWithZone:[NSMenu menuZone]] initWithTitle:@""] autorelease];
		[M setSubmenu:M forItem:MI];
		E = [sortedKeys objectEnumerator];
		while(S = [E nextObject])
		{
			NSMenuItem * MI = [[[NSMenuItem allocWithZone:[NSMenu menuZone]] initWithTitle: S
							action: @selector(projectChooseMasterUsingRepresentedObject:) keyEquivalent: @""] autorelease];
			[M addItem:MI];
			[MI setTarget:nil];
			[MI setRepresentedObject:[MD objectForKey:S]];	
		}
		if(![M numberOfItems])
		{
			[M addItemWithTitle:iTM2ProjectLocalizedNoDocumentName action:NULL keyEquivalent:@""];
		}
	}
#endif
	// adding the documents
	if(![NSApp targetForAction:@selector(projectEditDocumentUsingRepresentedObject:)])
	{
		iTM2_LOG(@"..........  ERROR: the project responder is not yet installed!");
	}
	[M addItem:[NSMenuItem separatorItem]];
	[M addItemWithTitle:iTM2ProjectLocalizedDocumentsName action:NULL keyEquivalent:@""];
	// populating the menu with project documents
	if([sortedKeys count])
	{
		E = [sortedKeys objectEnumerator];
		while(S = [E nextObject])
		{
			NSMenuItem * MI = [[[NSMenuItem allocWithZone:[NSMenu menuZone]] initWithTitle: S
							action: @selector(projectEditDocumentUsingRepresentedObject:) keyEquivalent: @""] autorelease];
			[MI setIndentationLevel:iTM2WindowsMenuItemIndentationLevel];
			[M addItem:MI];
			[MI setTarget:nil];
			[MI setRepresentedObject:[MD objectForKey:S]];
		}
	}
#endif
//iTM2_END;
	return;
}
@end

@interface iTM2ProjectWindowSubmenu: NSMenu
@end

@implementation iTM2ProjectWindowSubmenu
@end

@interface iTM2WindowsMenuObserver: NSObject
+(void)registerNotifications;
+(void)updateWindowsMenu:(id)irrelevant;
@end

@implementation iTM2WindowsMenuObserver
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  registerNotifications
+(void)registerNotifications;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [DNC removeObserver:self];
#if 0
    [DNC addObserver: self
        selector: @selector(_windowsMenuDidChangeNotified:)
            name: NSMenuDidChangeItemNotification
                object: [NSApp windowsMenu]];// beware, the windows menu is not expected to change
#endif
    [DNC addObserver: self
        selector: @selector(windowsMenuDidChangeNotified:)
            name: NSMenuDidAddItemNotification
                object: [NSApp windowsMenu]];// beware, the windows menu is not expected to change
    [DNC addObserver: self
        selector: @selector(windowsMenuDidChangeNotified:)
            name: NSMenuDidRemoveItemNotification
                object: [NSApp windowsMenu]];// beware, the windows menu is not expected to change
     [DNC addObserver: self
        selector: @selector(windowsMenuDidChangeNotified:)
            name: NSMenuDidRemoveItemNotification
                object: [NSApp windowsMenu]];// beware, the windows menu is not expected to change
	[INC removeObserver:self];
	[INC addObserver: self
        selector: @selector(windowsMenuShouldUpdateNotified:)
            name: iTM2ProjectContextDidChangeNotification
                object: nil];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  windowsMenuDidChangeNotified:
+(void)windowsMenuDidChangeNotified:(NSNotification *)notification;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(![[notification object] isEqual:[NSApp windowsMenu]])
		return;
	[self cancelPreviousPerformRequestsWithTarget: self
		selector: @selector(updateWindowsMenu:)
			object: nil];
	[self performSelector: @selector(updateWindowsMenu:)
		withObject: nil
			afterDelay: 0.01];// not too long please
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  windowsMenuShouldUpdateNotified:
+(void)windowsMenuShouldUpdateNotified:(NSNotification *)notification;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self cancelPreviousPerformRequestsWithTarget: self
		selector: @selector(updateWindowsMenu:)
			object: nil];
	[self performSelector: @selector(updateWindowsMenu:)
		withObject: nil
			afterDelay: 0.01];// not too long please
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  updateWindowsMenu:
+(void)updateWindowsMenu:(id)irrelevant;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//    [DNC removeObserver:self name:[notification name] object:[notification object]];
    [DNC removeObserver:self];
	NSMenuItem * MI = nil;
	NSWindow * W = nil;
	id document = nil;
	NSString * fileName = @"";
	// cleaning the iTM2ProjectGhostWindow menu item
	NSMutableDictionary * namesToProjectMenuItems = [NSMutableDictionary dictionary];
	// namesToProjectMenuItems: keys are file names or display names, values are project menu items
	// keys are used to sort the menu items
	NSMutableDictionary * projectRefsToProjectWindowsMenuItems = [NSMutableDictionary dictionary];
	// projectRefsToProjectWindowsMenuItems: keys are NSValues containing the address of a Project Document
	// values are mutable arrays of menu items for windows of this project
	NSMutableDictionary * projectRefsToProjectDocumentsMenuItems = [NSMutableDictionary dictionary];
	// projectRefsToProjectDocumentsMenuItems: keys are NSValues containing the address of a Project Document
	// values are mutable arrays of menu items for windows of documents of this project
	NSMutableArray * otherMenuItems = [NSMutableArray array];
	int insertIndex = -1;
	NSMenu * windowsMenu = [NSApp windowsMenu];
	BOOL oldMenuChangedMessagesEnabled = [windowsMenu menuChangedMessagesEnabled];
	NSEnumerator * E = [[windowsMenu itemArray] objectEnumerator];
	while(MI = [E nextObject])
	{
		++insertIndex;
//iTM2_LOG(@"LOOP ----> [MI title] is: %@, insertIndex is: %i", [MI title], insertIndex);
		W = [MI target];
		if([W isKindOfClass:[NSWindow class]])
		{
			targetIsWindow:
//iTM2_LOG(@"1 - [MI title] is: %@", [MI title]);
			[MI setTitle:[W windowsMenuItemTitle]];
//iTM2_LOG(@"2 - [MI title] is: %@", [MI title]);
//iTM2_LOG(@"=-=-=-=-=-  target is window, modified [MI title] is: %@", [MI title]);
			document = [[W windowController] document];
			fileName = [document fileName];
			if([W isKindOfClass:[iTM2ProjectGhostWindow class]])
			{
//iTM2_LOG(@"=-=-=-=-=-  target is a ghost window");
				[MI setTarget:nil];
				[MI setAction:@selector(projectShowWindowsFromRepresentedObject:)];
				[MI setRepresentedObject:[NSValue valueWithNonretainedObject:document]];
//iTM2_LOG(@"=-=-=-=-=-  document is: %@", document);
//iTM2_LOG(@"=-=-=-=-=-  [MI representedObject] is: %@", [MI representedObject]);
//iTM2_LOG(@"=-=-=-=-=-  [SDC documents] are: %@", [SDC documents]);
				NSMenu * m = [[[iTM2ProjectWindowSubmenu allocWithZone:[NSMenu menuZone]] initWithTitle:[MI title]] autorelease];
				[[MI menu] setSubmenu:m forItem:MI];
				// [m addItemWithTitle:@"RIEN" action:NULL keyEquivalent:@""];
//                [self updateWindowsSubmenu:m];// once m is really a submenu!!!
                [document updateWindowsSubmenu:m];// once m is really a submenu!!!
//iTM2_LOG(@"=-=-=-=-=-  [MI submenu] is: %@", [MI submenu]);
				[W setExcludedFromWindowsMenu:YES];
				[MI setState:NSOffState];
				itemIsProject:
//iTM2_LOG(@"=-=-=-=-=-  menu item is project %#x", document);
				[namesToProjectMenuItems takeValue:MI forKey: ([fileName length]? fileName:
                    ([[document displayName] length]? [document displayName]:[NSString stringWithFormat:@"%#x", document]))];
				[windowsMenu removeItem:MI];

				nextMenuItem:
				MI = [E nextObject];
//iTM2_LOG(@"LOOP ----> [MI title] is: %@", [MI title]);
				W = [MI target];
				if([W isKindOfClass:[NSWindow class]])
					goto targetIsWindow;
				else if([MI hasSubmenu] && [[MI submenu] isKindOfClass:[iTM2ProjectWindowSubmenu class]])
					goto itemHasProjectSubmenu;
				else if(MI)
					goto nextMenuItem;
			}
			else if(document)
			{
				iTM2ProjectDocument * PD = [document project];
//iTM2_LOG(@"PD: %@", PD);
//iTM2_LOG(@"[PD fileName]: %@", [PD fileName]);
				if(document == PD)
				{
					id key = [NSValue valueWithNonretainedObject:PD];
					NSMutableArray * mra = [projectRefsToProjectWindowsMenuItems objectForKey:key];
					if(mra)
						[mra addObject:MI];
					else
						[projectRefsToProjectWindowsMenuItems setObject:[NSMutableArray arrayWithObject:MI] forKey:key];
//iTM2_LOG(@"=-=-=-=-=-  menu item is project item %#x, %@", PD, [document fileName]);
				}
				else if(PD)
				{
					id key = [NSValue valueWithNonretainedObject:PD];
					NSMutableArray * mra = [projectRefsToProjectDocumentsMenuItems objectForKey:key];
                    [MI setIndentationLevel:iTM2WindowsMenuItemIndentationLevel];
					if(mra)
						[mra addObject:MI];
					else
						[projectRefsToProjectDocumentsMenuItems setObject:[NSMutableArray arrayWithObject:MI] forKey:key];
//iTM2_LOG(@"=-=-=-=-=-  menu item is project document pertaining to %#x, %@, %@", PD, [PD fileName], [document fileName]);
				}
				else
				{
					[otherMenuItems addObject:MI];
//iTM2_LOG(@"=-=-=-=-=-  menu item is other");
				}
				[windowsMenu removeItem:MI];
				goto nextMenuItem;
			}
			else 
			{
//iTM2_LOG(@"=-=-=-=-=-  menu item with no document");
				[otherMenuItems addObject:MI];
				[windowsMenu removeItem:MI];
				goto nextMenuItem;
			}
		}
		else if([MI hasSubmenu] && [[MI submenu] isKindOfClass:[iTM2ProjectWindowSubmenu class]])
		{
			itemHasProjectSubmenu:;
//iTM2_LOG(@"=-=-=-=-=-  target has submenu");
			NSValue * V = [MI representedObject];
			id document = [V isKindOfClass:[NSValue class]]? [V nonretainedObjectValue]: nil;
			if([SPC isProject:document] || [SPC isBaseProject:document])
			{
				if(fileName = [document fileName])
				{
					NSMenu * m = [[[iTM2ProjectWindowSubmenu allocWithZone:[NSMenu menuZone]] initWithTitle:[MI title]] autorelease];
					[[MI menu] setSubmenu:m forItem:MI];
					[document updateWindowsSubmenu:m];// once m is really a submenu!!!
					goto itemIsProject;
				}
			}
			// document is no longer valid
			[windowsMenu removeItem:MI];// cleaning: either the project is no longer available or the file name is void!!!
		}
	}
//iTM2_LOG(@"=-=-=-=-=-  INSERTING OTHERS %i", [windowsMenu numberOfItems]);
	if(insertIndex < 0)
	    insertIndex = 0;// just in case no item was previously added...
	if(insertIndex > [windowsMenu numberOfItems])
	    insertIndex = [windowsMenu numberOfItems];// just in case no item was previously added...
	if([otherMenuItems count])
	{
		E = [[otherMenuItems sortedArrayUsingSelector:@selector(compareUsingTitle:)] reverseObjectEnumerator];
		while(MI = [E nextObject])
		{
	//iTM2_LOG(@"=-=-=-=-=-  inserted document MI is: %@", MI);
			[windowsMenu insertItem:MI atIndex:insertIndex];
		}
#if 1
		E = [[[namesToProjectMenuItems allValues] sortedArrayUsingSelector:@selector(compareUsingTitle:)] objectEnumerator];
		iTM2ProjectWindowSubmenu * addMenu = [[[iTM2ProjectWindowSubmenu allocWithZone:[iTM2ProjectWindowSubmenu menuZone]] initWithTitle:iTM2ProjectLocalizedAddCurrentDocumentName] autorelease];
		while(MI = [[[E nextObject] copy] autorelease])
		{
			[MI setSubmenu:nil];
			[MI setAction:@selector(projectAddCurrentDocument:)];
			[addMenu addItem:MI];
		}
		if([addMenu numberOfItems])
		{
			MI = [[[NSMenuItem allocWithZone:[NSMenu menuZone]] initWithTitle:[addMenu title]
							action: @selector(projectAddCurrentDocument:) keyEquivalent: @""] autorelease];
			[windowsMenu insertItem:MI atIndex:insertIndex];
			[windowsMenu setSubmenu:addMenu forItem:MI];
		}
#endif
		[windowsMenu insertItem:[NSMenuItem separatorItem] atIndex:insertIndex];
	}
//iTM2_LOG(@"=-=-=-=-=-  INSERTING PROJECTS %i", [windowsMenu numberOfItems]);
	E = [[[namesToProjectMenuItems allValues] sortedArrayUsingSelector:@selector(compareUsingTitle:)] reverseObjectEnumerator];
	while(MI = [E nextObject])
	{
//iTM2_LOG(@"=-=-=-=-=-  [MI title] is: %@", [MI title]);
//iTM2_LOG(@"=-=-=-=-=-  [MI submenu] is: %@", [MI submenu]);
		iTM2ProjectDocument * PD = [[MI representedObject] nonretainedObjectValue];
		if([SPC isBaseProject:PD])
		{
			[MI setAttributedTitle:[[[NSAttributedString allocWithZone:[MI zone]] initWithString:[MI title]
				attributes: [NSDictionary dictionaryWithObjectsAndKeys:
					[NSFont boldSystemFontOfSize:[NSFont systemFontSize]], NSFontAttributeName, nil]] autorelease]];
			NSValue * V = [MI representedObject]?:[NSValue valueWithNonretainedObject:nil];// hum, bad error management here
			NSArray * subs1 = [projectRefsToProjectWindowsMenuItems objectForKey:V];
			NSArray * subs2 = [projectRefsToProjectDocumentsMenuItems objectForKey:V];// no documents are expected at first, but things might change
			if([subs1 count] + [subs2 count])
			{
				NSEnumerator * e = [[subs2 sortedArrayUsingSelector:@selector(compareUsingTitle:)] reverseObjectEnumerator];
				NSMenuItem * mi;
				while(mi = [e nextObject])
				{
//iTM2_LOG(@"=-=-=-=-=-  inserted document mi is: %@", mi);
					[windowsMenu insertItem:mi atIndex:insertIndex];
					[mi setIndentationLevel:iTM2WindowsMenuItemIndentationLevel];
				}
				e = [[subs1 sortedArrayUsingSelector:@selector(compareUsingTitle:)] reverseObjectEnumerator];
				while(mi = [e nextObject])
				{
//iTM2_LOG(@"=-=-=-=-=-  inserted project item mi is: %@", mi);
					[windowsMenu insertItem:mi atIndex:insertIndex];
					[mi setIndentationLevel:iTM2WindowsMenuItemIndentationLevel];
				}
//iTM2_LOG(@"=-=-=-=-=-  inserted project MI is: %@", MI);
				[windowsMenu insertItem:MI atIndex:insertIndex];
				[windowsMenu insertItem:[NSMenuItem separatorItem] atIndex:insertIndex];
			}
			[projectRefsToProjectWindowsMenuItems removeObjectForKey:V];
			[projectRefsToProjectDocumentsMenuItems removeObjectForKey:V];
		}
		else
		{
			NSValue * V = [MI representedObject]?:[NSValue valueWithNonretainedObject:nil];// hum, bad error management here
			NSEnumerator * e = [[[projectRefsToProjectDocumentsMenuItems objectForKey:V] sortedArrayUsingSelector:@selector(compareUsingTitle:)] reverseObjectEnumerator];
			NSMenuItem * mi;
			while(mi = [e nextObject])
			{
//iTM2_LOG(@"=-=-=-=-=-  inserted document mi is: %@", mi);
				[windowsMenu insertItem:mi atIndex:insertIndex];
				[mi setIndentationLevel:iTM2WindowsMenuItemIndentationLevel];
			}
			e = [[[projectRefsToProjectWindowsMenuItems objectForKey:V] sortedArrayUsingSelector:@selector(compareUsingTitle:)] reverseObjectEnumerator];
			while(mi = [e nextObject])
			{
//iTM2_LOG(@"=-=-=-=-=-  inserted project item mi is: %@", mi);
				[windowsMenu insertItem:mi atIndex:insertIndex];
				[mi setIndentationLevel:iTM2WindowsMenuItemIndentationLevel];
			}
//iTM2_LOG(@"=-=-=-=-=-  inserted project MI is: %@", MI);
			[windowsMenu insertItem:MI atIndex:insertIndex];
			[windowsMenu insertItem:[NSMenuItem separatorItem] atIndex:insertIndex];
			[projectRefsToProjectWindowsMenuItems removeObjectForKey:V];
			[projectRefsToProjectDocumentsMenuItems removeObjectForKey:V];
		}
	}
//iTM2_LOG(@"=-=-=-=-=-  INSERTING REMAINING PROJECT ITEMS %i", [windowsMenu numberOfItems]);
	E = [[projectRefsToProjectWindowsMenuItems allValues] reverseObjectEnumerator];
	NSArray * ra;
	while(ra = [E nextObject])
	{
		NSEnumerator * e = [ra objectEnumerator];
		NSMenuItem * MI;
		while(MI = [e nextObject])
		{
//iTM2_LOG(@"=-=-=-=-=-  inserted remaining project item MI is: %@", MI);
			[windowsMenu insertItem:MI atIndex:insertIndex];
		}
	}
	[windowsMenu insertItem:[NSMenuItem separatorItem] atIndex:insertIndex];
//iTM2_LOG(@"=-=-=-=-=-  INSERTING DOCUMENTS %i", [windowsMenu numberOfItems]);
	if([projectRefsToProjectDocumentsMenuItems count])
	{
		NSMenuItem * MI;
		NSEnumerator * E = [[projectRefsToProjectDocumentsMenuItems allValues] reverseObjectEnumerator];
		NSEnumerator * e;
		while(e = [[E nextObject] objectEnumerator])
		{
			while(MI = [e nextObject])
			{
	//iTM2_LOG(@"=-=-=-=-=-  inserted DOCUMENTS item MI is: %@", MI);
				[windowsMenu insertItem:MI atIndex:insertIndex];
			}
		}
	}
//iTM2_LOG(@"=-=-=-=-=-  INSERTING THE ADD DOCUMENT TO PROJECT MENU, %i", [windowsMenu numberOfItems]);
	[windowsMenu insertItem:[NSMenuItem separatorItem] atIndex:insertIndex];
//iTM2_LOG(@"=-=-=-=-=-  CLEANING %i", [windowsMenu numberOfItems]);
	[windowsMenu cleanSeparators];
//iTM2_LOG(@"=-=-=-=-=-  CLEANED %i", [windowsMenu numberOfItems]);
//iTM2_LOG(@"=-=-=-=-=-  windowsMenu %@", windowsMenu);
	[self registerNotifications];
	[windowsMenu setMenuChangedMessagesEnabled:oldMenuChangedMessagesEnabled];
//iTM2_END;
	return;
}
@end

@implementation iTM2MainInstaller(WindowsMenuKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2WindowsMenuObserverCompleteInstallation
+(void)iTM2WindowsMenuObserverCompleteInstallation;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [iTM2WindowsMenuObserver registerNotifications];
    [SUD registerDefaults: [NSDictionary dictionaryWithObjectsAndKeys:
        [NSNumber numberWithInt:1], @"iTM2WindowsMenuItemIndentationLevel", nil]];
	[iTM2ProjectLocalizedNoDocumentName  autorelease];
	[iTM2ProjectLocalizedDocumentsName autorelease];
	[iTM2ProjectLocalizedAddDocumentName autorelease];
	[iTM2ProjectLocalizedAddCurrentDocumentName autorelease];
//	[_iTM2ProjectLocalizedMasterName autorelease];
//	[_iTM2ProjectLocalizedChooseMasterName autorelease];
	NSMenuItem * MI = (NSMenuItem *)[[NSApp mainMenu] deepItemWithAction:@selector(projectNoDocument:)];
	NSString * proposal = [MI title];
	if(![proposal length] || [proposal rangeOfString:@"%"].length)
	{
		iTM2_LOG(@"Localization BUG, the menu item with action projectNoDocument: must exist and contain no %% (%@)", proposal);
		proposal = @"No document";
	}
	iTM2ProjectLocalizedNoDocumentName = [proposal copy];
	NSMenu * M = [MI menu];
	MI = (NSMenuItem *)[M itemWithAction:@selector(projectDocuments:)];
	proposal = [MI title];
	if(![proposal length] || [proposal rangeOfString:@"%"].length)
	{
		iTM2_LOG(@"Localization BUG, the menu item with action projectDocuments: must exist and contain no %% (%@)", proposal);
		proposal = @"Documents:";
	}
	iTM2ProjectLocalizedDocumentsName = [proposal copy];
	MI = (NSMenuItem *)[M itemWithAction:@selector(projectAddDocument:)];
	proposal = [MI title];
	if(![proposal length] || [proposal rangeOfString:@"%"].length)
	{
		iTM2_LOG(@"Localization BUG, the menu item with action projectAddDocument: must exist and contain no %%(%@)", proposal);
		proposal = @"Add Document...";
	}
	iTM2ProjectLocalizedAddDocumentName = [proposal copy];
	NSMenu * supermenu = [M supermenu];
	[supermenu removeItem:[supermenu itemAtIndex:[supermenu indexOfItemWithSubmenu:M]]];
	MI = (NSMenuItem *)[[NSApp mainMenu] deepItemWithAction:@selector(projectAddCurrentDocument:)];
	proposal = [MI title];
	if(![proposal length] || [proposal rangeOfString:@"%"].length)
	{
		iTM2_LOG(@"Localization BUG, the menu item with action projectAddCurrentDocument: must exist and contain exactly no %% (%@)", proposal);
		proposal = @"Add To Project";
	}
	iTM2ProjectLocalizedAddCurrentDocumentName = [proposal copy];
	[[MI menu] removeItem:MI];
//iTM2_END;
    return;
}
@end
