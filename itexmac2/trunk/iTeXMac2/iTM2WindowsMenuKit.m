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

@interface iTM2ProjectDocument(WindowMenuKit)
- (void)updateWindowsSubmenu:(NSMenu *)M;
@end

@implementation iTM2ProjectDocument(WindowMenuKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= updateWindowsSubmenu:
- (void)updateWindowsSubmenu:(NSMenu *)M;
/*"Update the windows submenu with inspectors and registered documents
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
	NSString * mode;
	for(mode in [NSWindowController inspectorModesForType:type])
	{
        Class inspectorClass = [NSWindowController inspectorClassForType:type mode:mode variant:iTM2DefaultInspectorVariant];
//iTM2_LOG(@"[inspectorClass inspectorType] is: %@(%@)", [inspectorClass inspectorType], type);
//iTM2_LOG(@"[inspectorClass inspectorMode] is: %@(%@)", [inspectorClass inspectorMode], mode);
//iTM2_LOG(@"[inspectorClass inspectorVariant] is: %@(%@)", [inspectorClass inspectorVariant], iTM2DefaultInspectorVariant);
        if(inspectorClass == Nil)
        {
			NSArray * inspectorClasses = [NSWindowController inspectorClassesForType:type mode:mode];
			if([inspectorClasses count])
			{
				inspectorClass = [inspectorClasses objectAtIndex:0];
			}
//iTM2_LOG(@"[C inspectorType] is: %@(%@)", [C inspectorType], type);
//iTM2_LOG(@"[C inspectorMode] is: %@(%@)", [C inspectorMode], mode);
//iTM2_LOG(@"[C inspectorVariant] is: %@(%@)", [C inspectorVariant], iTM2DefaultInspectorVariant);
        }
        if(inspectorClass != Nil)
        {
            NSMenuItem * MI = [[[NSMenuItem alloc]
                initWithTitle: [inspectorClass prettyInspectorMode]
                    action: @selector(projectEditUsingRepresentedInspectorMode:) keyEquivalent: @""] autorelease];
            [MI setTarget:nil];
            [MI setRepresentedObject:mode];
            [MRA addObject:MI];
			NSImage * I = [inspectorClass smallImageLogo];
			[MI setImage:I];
        }
	}
	if([MRA count])
	{
		NSSortDescriptor * SD = [[[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES selector:@selector(caseInsensitiveCompare:)] autorelease];
		NSArray * sortDescriptors = [NSArray arrayWithObject:SD];
		[MRA sortUsingDescriptors:sortDescriptors];
		NSMenuItem * MI = nil;
		for(MI in MRA)
			[M addItem:MI];
	}
#if 1
	// preparing the list of documents
	NSMutableDictionary * MD = [NSMutableDictionary dictionary];
	NSString * S;
	for(S in [self fileKeys])
	{
		NSString * FN = [[[self URLForFileKey:S] path] lastPathComponent];
		if([FN length])
			[MD setObject:S forKey:FN];
	}
	NSArray * sortedKeys = [MD allKeys];
	sortedKeys = [sortedKeys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
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
		for(S in sortedKeys)
		{
			NSMenuItem * MI = [[[NSMenuItem alloc] initWithTitle: S
							action: @selector(projectEditDocumentUsingRepresentedObject:) keyEquivalent: @""] autorelease];
			[M addItem:MI];
			[MI setTarget:nil];
			S = [MD objectForKey:S];
			[MI setRepresentedObject:S];
			NSString * path = [[self URLForFileKey:S] path];
			NSImage * I = [SWS iconForFile:path];
			[I iTM2_setSizeSmallIcon];
			[MI setImage:I];
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
+ (void)registerNotifications;
+ (void)updateWindowsMenu:(id)irrelevant;
@end

@implementation iTM2WindowsMenuObserver
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  registerNotifications
+ (void)registerNotifications;
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
     [DNC addObserver:self
        selector:@selector(windowWillClosedNotified:)
            name:NSWindowWillCloseNotification
                object:nil];
#endif
	[[NSApp windowsMenu] setDelegate:self];
	[INC removeObserver:self];
	[INC addObserver: self
        selector: @selector(windowsMenuShouldUpdateNotified:)
            name: iTM2ProjectContextDidChangeNotification
                object: nil];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  menuNeedsUpdate:
+ (void)menuNeedsUpdate:(NSMenu *)menu
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self updateWindowsMenu:self];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  windowWillClosedNotified:
+ (void)windowWillClosedNotified:(NSNotification *)notification;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSWindow * W = [notification object];
	NSMenu * M = [NSApp windowsMenu];
	NSArray * RA = [M itemArray];
	NSMenuItem * MI;
	for(MI in RA)
	{
		if([MI target] == W)
		{
			[MI setTarget:nil];
			[MI setAction:@selector(__REMOVE_ME_ACTION:)];
		}
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  windowsMenuDidChangeNotified:
+ (void)windowsMenuDidChangeNotified:(NSNotification *)notification;
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
			afterDelay: 0];// not too long please
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  windowsMenuShouldUpdateNotified:
+ (void)windowsMenuShouldUpdateNotified:(NSNotification *)notification;
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
			afterDelay: 0];// not too long please
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  updateWindowsMenu:
+ (void)updateWindowsMenu:(id)irrelevant;
/*"We patch the windows submenu.
The overall structure is the same except that documents are organized differently.
Windows are collected according to the project they are related to.
In general:
project name, with a submenu
indented list of windows
menu separator
First, we remove all the menu items related to windows or project, the we sort them, finally, we insert them at the right location.
There are 3 kinds of menu items
1 - main projects menu items
2 - document windows pertaining to a project
3 - windows not belonging to any kind of project
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
	NSWindowController * WC = nil;
	id document = nil;
	iTM2ProjectDocument * PD = nil;
	// cleaning the iTM2ProjectGhostWindow menu item
	NSMapTable * projectRefsToProjectWindowsMenuItems = [NSMapTable mapTableWithKeyOptions:NSPointerFunctionsOpaqueMemory|NSPointerFunctionsOpaquePersonality
																			  valueOptions:NSPointerFunctionsStrongMemory];
	// projectRefsToProjectWindowsMenuItems: keys are addresses of Project Documents
	// values are mutable arrays of menu items for windows of this project
	NSMutableDictionary * projectRefsToProjectDocumentsMenuItems = [NSMapTable mapTableWithKeyOptions:NSPointerFunctionsOpaqueMemory|NSPointerFunctionsOpaquePersonality
																						 valueOptions:NSPointerFunctionsStrongMemory];
	// projectRefsToProjectDocumentsMenuItems: keys are NSValues containing the address of a Project Document
	// values are mutable arrays of menu items for windows of documents of this project
	NSMutableArray * otherMenuItems = [NSMutableArray array];
	NSMenu * windowsMenu = [NSApp windowsMenu];
	BOOL oldMenuChangedMessagesEnabled = [windowsMenu menuChangedMessagesEnabled];
	// collecting all the application ghost windows to have all the projects
	id key = nil;
	NSURL * url = nil;
	NSMutableArray * MRA = nil;
	id set = [NSMutableSet set];
	// first we scan all the application windows
	// for each project, we prepare the 2 dictionaries above
	NSArray * RA = [NSApp windows];
	for(W in RA)
	{
		if([W isKindOfClass:[iTM2ProjectGhostWindow class]])// a ghost window is an awfull trick to have the projects listed in the windows menu, and other side effects
		{
//iTM2_LOG(@"=-=-=-=-=-  target is a ghost window");
			WC = [W windowController];
			if(PD = [WC document])
			{
				if(![projectRefsToProjectWindowsMenuItems objectForKey:PD])
				{
					[projectRefsToProjectWindowsMenuItems setObject:[NSMutableArray array] forKey:PD];
				}
				if(![projectRefsToProjectDocumentsMenuItems objectForKey:PD])
				{
					[projectRefsToProjectDocumentsMenuItems setObject:[NSMutableArray array] forKey:PD];
				}
				url = [PD fileURL];
				if([set containsObject:url])
				{
					iTM2_REPORTERROR(1,([NSString stringWithFormat:@"Report bug: Duplicate ghost window for\n%@",[url path]]),nil);
				}
				else if([url iTM2_belongsToFactory])
				{
					url = [[url iTM2_URLByRemovingFactoryBaseURL] iTM2_parentDirectoryURL];
					if([set containsObject:[url path]])
					{
						iTM2_REPORTERROR(2,([NSString stringWithFormat:@"Report bug: Duplicate ghost window for (faraway)\n%@",[url path]]),nil);
					}
					else
					{
						[set addObject:[url path]];
					}
				}
				else if(url)
				{
					[set addObject:[url path]];
				}
			}
		}
	}
	// remove all the menu items that where tagged 
	RA = [windowsMenu itemArray];
	for(MI in RA)
	{
		if([MI action] == @selector(__REMOVE_ME_ACTION:))
		{
			[windowsMenu removeItem:MI];// cleaning: create this on later
		}
	}
	// then we scan the windows menu 
	RA = [windowsMenu itemArray];
	int insertIndex = [RA count];// the index where all the doc menu items will live
	int idx = insertIndex;// will hold the new candidate for insertIndex
	for(MI in RA)
	{
		if([MI hasSubmenu] && [[MI submenu] isKindOfClass:[iTM2ProjectWindowSubmenu class]])
		{
			idx = [windowsMenu indexOfItem:MI];
			[windowsMenu removeItem:MI];// cleaning: recreate this on later
		}
		else if(W = [MI target],[W isKindOfClass:[NSWindow class]])// SIGTRAP catched?
		{
			[MI setTitle:[W iTM2_windowsMenuItemTitle]];
			WC = [W windowController];
			if(document = [WC document])
			{
				if(![MI image])
				{
					NSImage * I = [[WC class] smallImageLogo];
					if(!I)
					{
						NSString * FN = [document fileName];
						I = [SWS iconForFile:FN];
						[I iTM2_setSizeSmallIcon];
					}
					[MI setImage:I];
				}
				// the current menu item has a window
				// this window has a document
				PD = [document project];
				if(document == PD)
				{
					// this window is a project window
					if(MRA = [projectRefsToProjectWindowsMenuItems objectForKey:PD])
					{
						[MRA addObject:MI];
					}
					else
					{
						MRA = [NSMutableArray arrayWithObject:MI];
						[projectRefsToProjectWindowsMenuItems setObject:MRA forKey:PD];
					}
//iTM2_LOG(@"=-=-=-=-=-  menu item is project item %#x, %@", PD, [document fileName]);
				}
				else if(PD)
				{
					// this window is a project document window
					if(MRA = [projectRefsToProjectDocumentsMenuItems objectForKey:PD])
					{
						[MRA addObject:MI];
					}
					else
					{
						MRA = [NSMutableArray arrayWithObject:MI];
						[projectRefsToProjectDocumentsMenuItems setObject:MRA forKey:PD];
					}
					if(![MI image])
					{
						[MI setIndentationLevel:iTM2WindowsMenuItemIndentationLevel];
					}
				}
				else
				{
					[otherMenuItems addObject:MI];// no project for this menu item
				}
			}
			else 
			{
				[otherMenuItems addObject:MI];// no document for this window
			}
			idx = [windowsMenu indexOfItem:MI];
			[windowsMenu removeItem:MI];
		}
		if(idx<insertIndex)
		{
			insertIndex = idx;
		}
	}
//iTM2_LOG(@"0 - windowsMenu:%@",windowsMenu);
//iTM2_LOG(@"otherMenuItems:%@:",otherMenuItems);
//iTM2_LOG(@"projectRefsToProjectDocumentsMenuItems:%@:",projectRefsToProjectDocumentsMenuItems);
//iTM2_LOG(@"projectRefsToProjectWindowsMenuItems:%@:",projectRefsToProjectWindowsMenuItems);
	// updating with 
//iTM2_LOG(@"=-=-=-=-=-  INSERTING OTHERS %i", [windowsMenu numberOfItems]);
	if(insertIndex < 0)
	    insertIndex = 0;// just in case no item was previously added...
	if(insertIndex > [windowsMenu numberOfItems])
	    insertIndex = [windowsMenu numberOfItems];// just in case no item was previously added...
	NSSortDescriptor * SD = [[[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES] autorelease];
	NSArray * sortDescriptors = [NSArray arrayWithObject:SD];
	NSEnumerator * E;
	if([otherMenuItems count])
	{
		RA = [otherMenuItems sortedArrayUsingDescriptors:sortDescriptors];
		E = [RA reverseObjectEnumerator];
		while(MI = [E nextObject])
		{
	//iTM2_LOG(@"=-=-=-=-=-  inserted document MI is: %@", MI);
			[MI setIndentationLevel:0];
			[windowsMenu insertItem:MI atIndex:insertIndex];
		}
		[windowsMenu insertItem:[NSMenuItem separatorItem] atIndex:insertIndex];
	}
	// sorting all the project names using an array of trees
	NSMutableArray * roots = [NSMutableArray array];
	iTM2TreeNode * root = nil;
	iTM2TreeNode * node = nil;
	iTM2TreeNode * child = nil;
	NSString * component = nil;
	NSString * path = nil;
	for(PD in [projectRefsToProjectDocumentsMenuItems allKeys])
	{
		url = [PD fileURL];
		RA = [[url path] pathComponents];
		MRA = [RA mutableCopy];
		if(path = [MRA lastObject])
		{
//iTM2_LOG(@"path component:%@",path);
			NSPredicate *predicate = [NSPredicate predicateWithFormat:@"value like %@",path];
			RA = [roots filteredArrayUsingPredicate:predicate];
			if([RA count])
			{
				node = [RA lastObject];
			}
			else
			{
				node = [[[iTM2TreeNode alloc] initWithParent:nil value:path] autorelease];
				[roots addObject:node];
				RA = [roots filteredArrayUsingPredicate:predicate];
				NSAssert([RA count]>0,@"Aie");
			}
			[MRA removeLastObject];
			while(component = [MRA lastObject])
			{
				path = [component stringByAppendingPathComponent:path];
//iTM2_LOG(@"path component:%@",path);
				if(child = [node objectInChildrenWithValue:path])
				{
					node = child;
				}
				else
				{
					node = [[[iTM2TreeNode alloc] initWithParent:node value:path] autorelease];
				}
				[MRA removeLastObject];
			}
			[node setNonretainedValue:PD];
		}
	}
	unsigned index = 0;
	unsigned count = 0;
	for(root in roots)
	{
		node = root;
		child = node;
down:
		while([child countOfChildren])
		{
			child = [child objectInChildrenAtIndex:0];
		}
up:
		if(node = [child parent])
		{
			count = [node countOfChildren];
			if(count == 1)
			{
				[node setNonretainedValue:[child nonretainedValue]];
				[node removeObjectFromChildren:child];
				child = node;
				goto up;
			}
			else if((index = [node indexOfObjectInChildren:child]),(++index < count))
			{
				child = [node objectInChildrenAtIndex:index];
				goto down;
			}
			else
			{
otherUp:
				if(node = [child parent])
				{
					if((index = [node indexOfObjectInChildren:child]),(++index < [node countOfChildren]))
					{
						child = [node objectInChildrenAtIndex:index];
						goto down;
					}
					else
					{
						child = node;// crashed once: see 23 janvier 2007 22:07:58 HNEC
						goto otherUp;
					}
				}
			}
		}
	}
	// now all the leaf nodes correspond to a different name
	// record these names
	NSMapTable * shortProjectNames = [NSMapTable mapTableWithKeyOptions:NSPointerFunctionsZeroingWeakMemory|NSPointerFunctionsObjectPointerPersonality
																	valueOptions:NSPointerFunctionsStrongMemory];
	for(root in roots)
	{
		node = root;
		child = node;
down1:
		while([child countOfChildren])
		{
			child = [child objectInChildrenAtIndex:0];
		}
		if(PD = [child nonretainedValue])
		{
			component = [child value];
			[shortProjectNames setObject:component forKey:PD];
up1:
			if(node = [child parent])
			{
				if((index = [node indexOfObjectInChildren:child]),(++index < [node countOfChildren]))
				{
					child = [node objectInChildrenAtIndex:index];
					goto down1;
				}
				else
				{
					child = node;
					goto up1;
				}
			}
		}
	}
	// shorten these file names
	// first step give the candidates
	NSCountedSet * shortProjectNamesSet = [NSCountedSet set];
	NSString * dirName = nil;
	NSString * lastPathComponent = nil;
//iTM2_LOG(@"00 - shortProjectNames:%@",shortProjectNames);
	for(PD in [shortProjectNames keyEnumerator])
	{
		path = [shortProjectNames objectForKey:key];
		lastPathComponent = [PD displayName];
		dirName = [path stringByDeletingLastPathComponent];
		RA = [dirName pathComponents];
		if([RA count]>1)
		{
			component = [RA objectAtIndex:0];
			component = [NSString stringWithFormat:@"%@ (...%@/...)",lastPathComponent,component];
		}
		else if([RA count])
		{
			component = [RA objectAtIndex:0];
			component = [NSString stringWithFormat:@"%@ (...%@/)",lastPathComponent,component];
		}
		else
		{
			component = lastPathComponent;
		}
		[shortProjectNamesSet addObject:component];
	}
	// second step, same loop taking the previous set into account
//iTM2_LOG(@"0 - shortProjectNames:%@",shortProjectNames);
	for(PD in [shortProjectNames keyEnumerator])
	{
		path = [shortProjectNames objectForKey:key];
		lastPathComponent = [PD displayName];
		dirName = [path stringByDeletingLastPathComponent];
		RA = [dirName pathComponents];
		if([RA count]>1)
		{
			component = [RA objectAtIndex:0];
			component = [NSString stringWithFormat:@"%@ - ...%@/...",lastPathComponent,component];
			if([shortProjectNamesSet countForObject:path]<2)
			{
				[shortProjectNames setObject:component forKey:PD];
			}
		}
		else if([RA count])
		{
			component = [RA objectAtIndex:0];
			component = [NSString stringWithFormat:@"%@ - ...%@/",lastPathComponent,component];
			if([shortProjectNamesSet countForObject:path]<2)
			{
				[shortProjectNames setObject:component forKey:PD];
			}
		}
	}
	
	NSMenuItem * mi = nil;
//iTM2_LOG(@"0 - shortProjectNames:%@",shortProjectNames);
//iTM2_LOG(@"projectRefsToProjectDocumentsMenuItems:%@",projectRefsToProjectDocumentsMenuItems);
//iTM2_LOG(@"projectRefsToProjectWindowsMenuItems:%@",projectRefsToProjectWindowsMenuItems);
//iTM2_LOG(@"1 - windowsMenu:%@",windowsMenu);
	RA = [[shortProjectNames objectEnumerator] allObjects];
	RA = [RA sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
	for(path in [RA reverseObjectEnumerator])
	{
//iTM2_LOG(@"=-=-=-=-=-  [MI title] is: %@", [MI title]);
//iTM2_LOG(@"=-=-=-=-=-  [MI submenu] is: %@", [MI submenu]);
		for(PD in [shortProjectNames keyEnumerator])
		{
			if([[shortProjectNames objectForKey:key] isEqual:path])
				break;
		}
		dirName = [path stringByDeletingLastPathComponent];
		if([dirName length])
		{
			path = [PD displayName];
			RA = [dirName pathComponents];
			component = [RA objectAtIndex:0];
			if([RA count]>1)
			{
				path = [NSString stringWithFormat:@"%@ (.../%@/...)",path,component];
			}
			else
			{
				path = [NSString stringWithFormat:@"%@ (.../%@/)",path,component];
			}
		}
		MI = [[[NSMenuItem alloc] initWithTitle:path action:@selector(showSubdocuments:) keyEquivalent:@""] autorelease];
#warning FAILED
		[MI setTarget:PD];// IS THE PD LIVING LONG ENOUGH
		[MI setRepresentedObject:[NSValue valueWithNonretainedObject:PD]];
		if([SPC isBaseProject:PD])
		{
			[MI setAttributedTitle:[[[NSAttributedString alloc] initWithString:[MI title]
				attributes: [NSDictionary dictionaryWithObjectsAndKeys:
					[NSFont boldSystemFontOfSize:[NSFont systemFontSize]], NSFontAttributeName, nil]] autorelease]];
		}
		RA = [projectRefsToProjectDocumentsMenuItems objectForKey:PD];// no documents are expected at first, but things might change
		RA = [RA sortedArrayUsingDescriptors:sortDescriptors];
		for(mi in [RA reverseObjectEnumerator])
		{
//iTM2_LOG(@"=-=-=-=-=-  inserted document mi is: %@", mi);
			[windowsMenu insertItem:mi atIndex:insertIndex];
			if(![mi image])
			{
				[mi setIndentationLevel:iTM2WindowsMenuItemIndentationLevel];
			}
		}
		[projectRefsToProjectDocumentsMenuItems removeObjectForKey:PD];
		RA = [projectRefsToProjectWindowsMenuItems objectForKey:PD];
		RA = [RA sortedArrayUsingDescriptors:sortDescriptors];
		for(mi in [RA reverseObjectEnumerator])
		{
//iTM2_LOG(@"=-=-=-=-=-  inserted project item mi is: %@", mi);
			[windowsMenu insertItem:mi atIndex:insertIndex];
			if(![mi image])
			{
				[mi setIndentationLevel:iTM2WindowsMenuItemIndentationLevel];
			}
		}
		[projectRefsToProjectWindowsMenuItems removeObjectForKey:PD];
//iTM2_LOG(@"=-=-=-=-=-  inserted project MI is: %@", MI);
		[windowsMenu insertItem:MI atIndex:insertIndex];
		NSMenu * M = [[[iTM2ProjectWindowSubmenu alloc] initWithTitle:@""] autorelease];
		[windowsMenu setSubmenu:M forItem:MI];
		[PD updateWindowsSubmenu:M];
		[windowsMenu insertItem:[NSMenuItem separatorItem] atIndex:insertIndex];
	}
//iTM2_LOG(@"projectRefsToProjectDocumentsMenuItems:%@",projectRefsToProjectDocumentsMenuItems);
//iTM2_LOG(@"projectRefsToProjectWindowsMenuItems:%@",projectRefsToProjectWindowsMenuItems);
//iTM2_LOG(@"2 - windowsMenu:%@",windowsMenu);
//iTM2_LOG(@"=-=-=-=-=-  INSERTING REMAINING PROJECT ITEMS %i", [windowsMenu numberOfItems]);
//iTM2_LOG(@"=-=-=-=-=-  INSERTING THE ADD DOCUMENT TO PROJECT MENU, %i", [windowsMenu numberOfItems]);
	[windowsMenu insertItem:[NSMenuItem separatorItem] atIndex:insertIndex];
//iTM2_LOG(@"=-=-=-=-=-  CLEANING %i", [windowsMenu numberOfItems]);
	[windowsMenu cleanSeparators];
//iTM2_LOG(@"=-=-=-=-=-  CLEANED %i", [windowsMenu numberOfItems]);
//iTM2_LOG(@"=-=-=-=-=-  windowsMenu %@", windowsMenu);
//iTM2_LOG(@"3 - windowsMenu:%@",   windowsMenu);
	[self registerNotifications];
	[windowsMenu setMenuChangedMessagesEnabled:oldMenuChangedMessagesEnabled];
//iTM2_END;
	return;
}
@end

@implementation iTM2MainInstaller(WindowsMenuKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2WindowsMenuObserverCompleteInstallation
+ (void)iTM2WindowsMenuObserverCompleteInstallation;
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
