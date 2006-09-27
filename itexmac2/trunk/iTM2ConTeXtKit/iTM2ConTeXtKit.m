/*
//  iTM2ConTeXtKit.h
//  iTeXMac2
//
//  @version Subversion: $Id$ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Sun Jun 24 2001.
//  Copyright © 2001-2004 Laurens'Tribune. All rights reserved.
//
//  This program is free software; you can redistribute it and/or modify it under the terms
//  of the GNU General Public License as published by the Free Software Foundation; either
//  version 2 of the License, or any later version.
//  This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
//  without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
//  See the GNU General Public License for more details. You should have received a copy
//  of the GNU General Public License along with this program; if not, write to the Free Software
//  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
//  GPL addendum: Any simple modification of the present code which purpose is to remove bug,
//  improve efficiency in both code execution and code reading or writing should be addressed
//  to the actual developper team.
*/

#import "iTM2ConTeXtKit.h"
#import "iTM2ConTeXtPrefsKit.h"

NSString * const iTM2ConTeXtInspectorMode = @"ConTeXt Mode";
NSString * const iTM2ConTeXtToolbarIdentifier = @"iTM2 ConTeXt Inspector";
NSString * const iTM2ConTeXtManuals = @"iTM2 ConTeXt Manuals";
NSString * const iTM2ConTeXtManualsTable = @"iTM2ConTeXtManuals";

@interface NSMenu(iTM2ConTeXtKit)
+ (NSMenu *)menuWithConTeXtGardenXMLElements:(NSArray *)elements;
@end

@implementation iTM2ConTeXtInspector
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inspectorMode
+ (NSString *)inspectorMode;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return iTM2ConTeXtInspectorMode;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= windowPositionShouldBeObserved
- (BOOL)windowPositionShouldBeObserved;
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= ConTeXtPragmaADEURL
+ (NSURL *)ConTeXtPragmaADEURL;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	static NSURL * URL = nil;
	if(!URL)
	{
		NSEnumerator * E = [[[NSBundle mainBundle] allPathsForResource:@"ConTeXtURLs" ofType:@"plist"] objectEnumerator];
		NSString * path;
		while(path = [E nextObject])
		{
			NSDictionary * D = [NSDictionary dictionaryWithContentsOfFile:path];
			NSString * string = [D objectForKey:NSStringFromSelector(_cmd)];
			if(string)
			{
				URL = [[NSURL alloc] initWithString:string];
				return URL;
			}
		}
	}
//iTM2_END;
	return URL;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= ConTeXtGardenMainPageURL
+ (NSURL *)ConTeXtGardenMainPageURL;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	static NSURL * URL = nil;
	if(!URL)
	{
		NSEnumerator * E = [[[NSBundle mainBundle] allPathsForResource:@"ConTeXtURLs" ofType:@"plist"] objectEnumerator];
		NSString * path;
		while(path = [E nextObject])
		{
			NSDictionary * D = [NSDictionary dictionaryWithContentsOfFile:path];
			NSString * string = [D objectForKey:NSStringFromSelector(_cmd)];
			if(string)
			{
				URL = [[NSURL alloc] initWithString:string];
				return URL;
			}
		}
	}
//iTM2_END;
	return URL;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= ConTeXtGardenPageURLWithRef:
+ (NSURL *)ConTeXtGardenPageURLWithRef:(NSString *)ref;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSEnumerator * E = [[[NSBundle mainBundle] allPathsForResource:@"ConTeXtURLs" ofType:@"plist"] objectEnumerator];
	NSString * path;
	while(path = [E nextObject])
	{
		NSDictionary * D = [NSDictionary dictionaryWithContentsOfFile:path];
		NSString * string = [D objectForKey:@"ConTeXtGardenURL"];
		if(string)
		{
			return [[[NSURL alloc] initWithString:[string stringByAppendingPathComponent:ref]] autorelease];
		}
	}
//iTM2_END;
	NSAssert(NO, @"ConTeXtURLs.plist is buggy!!!");
	return nil;
}
@end

NSString * const iTM2ToolbarConTeXtLabelItemIdentifier = @"ConTeXtLabel";
NSString * const iTM2ToolbarConTeXtSectionItemIdentifier = @"ConTeXtSection";
NSString * const iTM2ToolbarConTeXtManualsItemIdentifier = @"ConTeXtManuals";
NSString * const iTM2ToolbarConTeXtAtGardenItemIdentifier = @"ConTeXtAtGarden";
NSString * const iTM2ToolbarConTeXtAtPragmaADEItemIdentifier = @"ConTeXtAtPragmaADE";
NSString * const iTM2ToolbarConTeXtPragmaADEItemIdentifier = @"ConTeXtPragmaADE";
//NSString * const iTM2ToolbarDoZoomToFitItemIdentifier = @"doZoomToFit";

@implementation iTM2MainInstaller(ConTeXtInspectorToolbar)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  ConTeXtInspectorToolbarCompleteInstallation
+ (void)ConTeXtInspectorToolbarCompleteInstallation;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue May  3 16:20:26 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[SUD registerDefaults: [NSDictionary dictionaryWithObjectsAndKeys:
		[NSNumber numberWithBool:NO], @"iTM2ConTeXtToolbarAutosavesConfiguration",
		[NSNumber numberWithBool:YES], @"iTM2ConTeXtToolbarShareConfiguration",
			nil]];
//iTM2_END;
	return;
}
@end

#define DEFINE_TOOLBAR_ITEM(SELECTOR)\
+ (NSToolbarItem *)SELECTOR;{return [self toolbarItemWithIdentifier:[self identifierFromSelector:_cmd] inBundle:[iTM2ConTeXtInspector classBundle]];}

@implementation NSToolbarItem(iTM2ConTeXt)
DEFINE_TOOLBAR_ITEM(ConTeXtSectionToolbarItem)
DEFINE_TOOLBAR_ITEM(ConTeXtLabelToolbarItem)
DEFINE_TOOLBAR_ITEM(ConTeXtAtPragmaADEToolbarItem)
DEFINE_TOOLBAR_ITEM(ConTeXtPragmaADEToolbarItem)
+ (NSToolbarItem *)ConTeXtAtGardenToolbarItem;
{
	NSToolbarItem * toolbarItem = [self toolbarItemWithIdentifier:[self identifierFromSelector:_cmd] inBundle:[iTM2ConTeXtInspector classBundle]];
	NSRect frame = NSMakeRect(0, 0, 32, 32);
	iTM2MixedButton * B = [[[iTM2MixedButton alloc] initWithFrame:frame] autorelease];
	[B setButtonType:NSMomentaryChangeButton];
//	[B setButtonType:NSOnOffButton];
	[B setImage:[toolbarItem image]];
	[B setImagePosition:NSImageOnly];
	[B setAction:@selector(ConTeXtAtGarden:)];
	[B setBezelStyle:NSShadowlessSquareBezelStyle];
//	[[B cell] setHighlightsBy:NSMomentaryChangeButton];
	[B setBordered:NO];
	[toolbarItem setView:B];
	[toolbarItem setMaxSize:frame.size];
	[toolbarItem setMinSize:frame.size];
	[B setTarget:nil];
	[[B cell] setBackgroundColor:[NSColor clearColor]];
	NSString * path = [[[[NSBundle mainBundle] allPathsForResource:@"iTM2ConTeXtGardenMainPageAbstract" ofType:@"xml"] objectEnumerator] nextObject];
	if([path length])
	{
		NSURL * url = [NSURL fileURLWithPath:path];
		NSXMLDocument * document = [[[NSXMLDocument alloc] initWithContentsOfURL:url options:0 error:nil] autorelease];
		NSMenu * M = [NSMenu menuWithConTeXtGardenXMLElements:[[document rootElement] children]];
		[M insertItem:[[[NSMenuItem allocWithZone:[NSMenu menuZone]] initWithTitle:@"COUCOU" action:NULL keyEquivalent:@""] autorelease] atIndex:0];
		NSPopUpButton * PB = [[[NSPopUpButton allocWithZone:[self zone]] initWithFrame:NSZeroRect] autorelease];
		[PB setMenu:M];
		[PB setPullsDown:YES];
		[[B cell] setPopUpCell:[PB cell]];
	}
	else
	{
		iTM2_LOG(@"MIssing iTM2ConTeXtGardenMainPageAbstract.xml");
	}
	return toolbarItem;
}
+ (NSToolbarItem *)ConTeXtManualsToolbarItem;
{
	NSToolbarItem * toolbarItem = [self toolbarItemWithIdentifier:[self identifierFromSelector:_cmd] inBundle:[iTM2ConTeXtInspector classBundle]];
	NSRect frame = NSMakeRect(0, 0, 32, 32);
	iTM2MixedButton * B = [[[iTM2MixedButton alloc] initWithFrame:frame] autorelease];
	[B setButtonType:NSMomentaryChangeButton];
//	[B setButtonType:NSOnOffButton];
	[B setImage:[toolbarItem image]];
	[B setImagePosition:NSImageOnly];
	[B setAction:@selector(ConTeXtManuals:)];
	[B setBezelStyle:NSShadowlessSquareBezelStyle];
//	[[B cell] setHighlightsBy:NSMomentaryChangeButton];
	[B setBordered:NO];
	[toolbarItem setView:B];
	[toolbarItem setMaxSize:frame.size];
	[toolbarItem setMinSize:frame.size];
	[B setTarget:nil];
	[[B cell] setBackgroundColor:[NSColor clearColor]];
	NSMenu * M = [[[NSMenu allocWithZone:[NSMenu menuZone]] initWithTitle:@""] autorelease];
	NSPopUpButton * PB = [[[NSPopUpButton allocWithZone:[self zone]] initWithFrame:NSZeroRect] autorelease];
	[PB setMenu:M];
	[PB setPullsDown:YES];
	[[B cell] setPopUpCell:[PB cell]];
	return toolbarItem;
}
@end

@implementation iTM2ConTeXtInspector(Toolbar)
#pragma mark =-=-=-=-=-  TOOLBAR
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setupToolbarWindowDidLoad
- (void)setupToolbarWindowDidLoad;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue May  3 16:20:26 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSToolbar * toolbar = [[[NSToolbar alloc] initWithIdentifier:iTM2ConTeXtToolbarIdentifier] autorelease];
	NSString * key = [NSString stringWithFormat:@"NSToolbar Configuration %@", [toolbar identifier]];
	if([self contextBoolForKey:@"iTM2ConTeXtToolbarShareConfiguration"])
	{
		NSDictionary * configDictionary = [SUD dictionaryForKey:key];
		if([configDictionary count])
		{
			[toolbar setConfigurationFromDictionary:configDictionary];
			if(![[toolbar items] count])
			{
				[SUD removeObjectForKey:key];
				toolbar = [[[NSToolbar alloc] initWithIdentifier:iTM2ConTeXtToolbarIdentifier] autorelease];
			}
		}
	}
	else
	{
		NSDictionary * configDictionary = [SUD dictionaryForKey:key];
//iTM2_LOG(@"configDictionary: %@", configDictionary);
		configDictionary = [self contextDictionaryForKey:key];
//iTM2_LOG(@"configDictionary: %@", configDictionary);
		if([configDictionary count])
			[toolbar setConfigurationFromDictionary:configDictionary];
		if(![[toolbar items] count])
		{
			configDictionary = [SUD dictionaryForKey:key];
//iTM2_LOG(@"configDictionary: %@", configDictionary);
			[self takeContextValue:nil forKey:key];
			if([configDictionary count])
				[toolbar setConfigurationFromDictionary:configDictionary];
			if(![[toolbar items] count])
			{
				[SUD removeObjectForKey:key];
				toolbar = [[[NSToolbar alloc] initWithIdentifier:iTM2ConTeXtToolbarIdentifier] autorelease];
			}
		}
	}
	[toolbar setAutosavesConfiguration:YES];
    [toolbar setAllowsUserCustomization:YES];
//    [toolbar setSizeMode:NSToolbarSizeModeSmall];
    [toolbar setDelegate:self];
    [[self window] setToolbar:toolbar];
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleShareToolbarConfiguration:
- (void)toggleShareToolbarConfiguration:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue May  3 16:20:26 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	BOOL old = [self contextBoolForKey:@"iTM2ConTeXtToolbarShareConfiguration"];
	[self takeContextBool: !old forKey:@"iTM2ConTeXtToolbarShareConfiguration"];
	[self validateWindowContent];
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleShareToolbarConfiguration:
- (BOOL)validateToggleShareToolbarConfiguration:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue May  3 16:20:26 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[sender setState: ([self contextBoolForKey:@"iTM2ConTeXtToolbarShareConfiguration"]? NSOnState:NSOffState)];
//iTM2_END;
	return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  prepareToolbarConfigurationCompleteSaveContext:
- (void)prepareToolbarConfigurationCompleteSaveContext:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue May  3 16:20:26 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([self contextBoolForKey:@"iTM2ConTeXtToolbarAutosavesConfiguration"])
	{
		NSToolbar * toolbar = [[self window] toolbar];
		NSString * key = [NSString stringWithFormat:@"NSToolbar Configuration %@", [toolbar identifier]];
		[self takeContextValue:[toolbar configurationDictionary] forKey:key];
	}
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toolbarDefaultItemIdentifiers:
- (NSArray *)toolbarDefaultItemIdentifiers:(NSToolbar *)toolbar;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue May  3 16:20:26 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    // Required delegate method:  Returns the ordered list of items to be shown in the toolbar by default    
    // If during the toolbar's initialization, no overriding values are found in the usermodel, or if the
    // user chooses to revert to the default items this set will be used 
//iTM2_END;
    return [NSArray arrayWithObjects:
				NSToolbarPrintItemIdentifier, 
				NSToolbarSeparatorItemIdentifier,
				iTM2ToolbarTypesetItemIdentifier,
				iTM2ToolbarProjectTerminalItemIdentifier,
				NSToolbarSeparatorItemIdentifier,
				iTM2ToolbarProjectSettingsItemIdentifier,
				iTM2ToolbarProjectFilesItemIdentifier,
//				NSToolbarSeparatorItemIdentifier,
//				iTM2ToolbarBookmarkItemIdentifier,
//				iTM2ToolbarConTeXtLabelItemIdentifier,
//				iTM2ToolbarConTeXtSectionItemIdentifier,
				NSToolbarFlexibleSpaceItemIdentifier,
				iTM2ToolbarConTeXtManualsItemIdentifier,
				iTM2ToolbarConTeXtAtGardenItemIdentifier,
				iTM2ToolbarConTeXtAtPragmaADEItemIdentifier,
						nil];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toolbarAllowedItemIdentifiers:
- (NSArray *)toolbarAllowedItemIdentifiers:(NSToolbar *)toolbar;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue May  3 16:20:26 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    // Required delegate method:  Returns the list of all allowed items by identifier.  By default, the toolbar 
    // does not assume any items are allowed, even the separator.  So, every allowed item must be explicitly listed   
    // The set of allowed items is used to construct the customization palette 
//iTM2_END;
    return [NSArray arrayWithObjects:
					iTM2ToolbarTypesetItemIdentifier,
					iTM2ToolbarProjectTerminalItemIdentifier,
					iTM2ToolbarProjectSettingsItemIdentifier,
					iTM2ToolbarProjectFilesItemIdentifier,
					iTM2ToolbarConTeXtManualsItemIdentifier,
					iTM2ToolbarConTeXtAtGardenItemIdentifier,
					iTM2ToolbarConTeXtAtPragmaADEItemIdentifier,
//					iTM2ToolbarBookmarkItemIdentifier,
//					iTM2ToolbarConTeXtLabelItemIdentifier,
//					iTM2ToolbarConTeXtSectionItemIdentifier,
					NSToolbarSeparatorItemIdentifier,
					NSToolbarPrintItemIdentifier, 
					NSToolbarSpaceItemIdentifier,
					NSToolbarFlexibleSpaceItemIdentifier,
					NSToolbarCustomizeToolbarItemIdentifier,
//					NSToolbarShowColorsItemIdentifier,
//					NSToolbarShowFontsItemIdentifier,
							nil];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= ConTeXtManuals:
- (IBAction)ConTeXtManuals:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[NSApp showConTeXtManualsPrefs:self];
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  ConTeXtManualsWillPopUp:
- (BOOL)ConTeXtManualsWillPopUp:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue May  3 16:20:26 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSMenu * M = [[[NSMenu allocWithZone:[NSMenu menuZone]] initWithTitle:@""] autorelease];
	[M addItemWithTitle:@"" action:NULL keyEquivalent:@""];// first item is used as title
	NSEnumerator * E = [[SUD stringArrayForKey:iTM2ConTeXtManuals] objectEnumerator];
	NSString * path;
	while(path = [E nextObject])
	{
		NSString * key = [[path lastPathComponent] stringByDeletingPathExtension];
		NSString * title = NSLocalizedStringFromTableInBundle(key, iTM2ConTeXtManualsTable, [self classBundle], "");
		NSMenuItem * MI = [[[NSMenuItem allocWithZone:[NSMenu menuZone]] initWithTitle: title
						action: @selector(openConTeXtManualFromRepresentedObject:) keyEquivalent: @""] autorelease];
		[M addItem:MI];
		[MI setTarget:nil];
		[MI setRepresentedObject:path];
	}
	if([M numberOfItems] > 1)
		[M addItem:[NSMenuItem separatorItem]];
	NSString * title = NSLocalizedStringFromTableInBundle(@"showConTeXtManualsPrefs", iTM2ConTeXtManualsTable, [self classBundle], "");
	NSMenuItem * MI = [[[NSMenuItem allocWithZone:[NSMenu menuZone]] initWithTitle: title
					action: @selector(showConTeXtManualsPrefs:) keyEquivalent: @""] autorelease];
	[M addItem:MI];
	[MI setTarget:nil];
	[[sender popUpCell] setMenu:M];
	return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  openConTeXtManualFromRepresentedObject:
- (IBAction)openConTeXtManualFromRepresentedObject:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue May  3 16:20:26 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * path = [sender representedObject];
	[SPC setProject:nil forFileName:path];
	if([SDC openDocumentWithContentsOfURL:[NSURL fileURLWithPath:path] display:YES error:nil])
		return;
	NSEnumerator * E = [[[NSBundle mainBundle] allPathsForResource:[[path lastPathComponent] stringByDeletingPathExtension]
		ofType: [path pathExtension] inDirectory:@"Documentation/ConTeXt"] objectEnumerator];
	while(path = [E nextObject])
	{
		[SPC setProject:nil forFileName:path];
		if([SDC openDocumentWithContentsOfURL:[NSURL fileURLWithPath:path] display:YES error:nil])
			return;
	}
	[NSApp showConTeXtManualsPrefs:self];
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= ConTeXtAtGarden:
- (IBAction)ConTeXtAtGarden:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[SWS openURL:[[self class] ConTeXtGardenMainPageURL]];
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  ConTeXtAtGardenFromRepresentedURL:
- (IBAction)ConTeXtAtGardenFromRepresentedURL:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue May  3 16:20:26 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSURL * URL = [sender representedObject];
	if([URL isKindOfClass:[NSURL class]])
	{
		[[NSWorkspace sharedWorkspace] openURL:URL];
	}
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= ConTeXtAtPragmaADE:
- (IBAction)ConTeXtAtPragmaADE:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[SWS openURL:[[self class] ConTeXtPragmaADEURL]];
//iTM2_END;
	return;
}
@end

@implementation iTM2ConTeXtSectionButton
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= awakeFromNib
- (void)awakeFromNib;
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([[self superclass] instancesRespondToSelector:_cmd])
		[super awakeFromNib];
	[self setAction:@selector(ConTeXtSectionButtonAction:)];
	[self performSelector:@selector(initMenu) withObject:nil afterDelay:0.01];
	[DNC removeObserver: self
		name: NSPopUpButtonWillPopUpNotification
			object: self];
	[DNC addObserver: self
		selector: @selector(popUpButtonWillPopUpNotified:)
			name: NSPopUpButtonWillPopUpNotification
				object: self];
	NSView * superview = [self superview];
	[self removeFromSuperviewWithoutNeedingDisplay];
	[superview addSubview:self];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  popUpButtonWillPopUpNotified:
- (void)popUpButtonWillPopUpNotified:(NSNotification *)notification;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSMenu * M = [[[[self window] windowController] textStorage] ConTeXtSectionMenu];
	NSAssert(M, @"Missing ConTeXt menu: inconsistency");
	NSMenuItem * MI = [[self menu] deepItemWithRepresentedObject:@"ConTeXt Section Menu"];
	if(MI)
	{
		[[MI menu] setSubmenu: ([M numberOfItems]? M:nil) forItem:MI];
	}
	else if(MI = [[self menu] deepItemWithAction:@selector(gotoConTeXtSection:)])
	{
		[MI setAction:NULL];
		[MI setRepresentedObject:@"ConTeXt Section Menu"];
		[[MI menu] setSubmenu: ([M numberOfItems]? M:nil) forItem:MI];
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= initMenu
- (void)initMenu;
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSView * owner = [[[NSView allocWithZone:[self zone]] initWithFrame:NSZeroRect] autorelease];
	NSDictionary * context = [NSDictionary dictionaryWithObject:owner forKey:@"NSOwner"];
	NSString * fileName;
	Class class = [self class];
next:
	fileName = [[NSBundle bundleForClass:class] pathForResource:@"iTM2ConTeXtSectionMenu" ofType:@"nib"];
	if([fileName length])
	{
		NSString * title = [self title];
		if([NSBundle loadNibFile:fileName externalNameTable:context withZone:[self zone]])
		{
			NSMenu * M = [owner menu];
			[owner setMenu:nil];
			if([M numberOfItems])
			{
				NSMenuItem * MI;
				NSEnumerator * E = [[M itemArray] objectEnumerator];
				while(MI = [E nextObject])
				{
					SEL action = [MI action];
					if(action)
					{
						if([NSStringFromSelector(action) hasPrefix:@"insert"])
						{
							if(![MI indentationLevel])
								[MI setIndentationLevel:1];
						}
					}
				}
				[[M itemAtIndex:0] setTitle:title];
				[self setTitle:title];// will raise if the menu is void
				[self setMenu:M];
			}
			else
			{
				iTM2_LOG(@"..........  ERROR: Inconsistent file (Void menu) at %@", fileName);
			}
		}
		else
		{
			iTM2_LOG(@"..........  ERROR: Corrupted file at %@", fileName);
		}
	}
	else
	{
		Class superclass = [class superclass];
		if((superclass) && (superclass != class))
		{
			class = superclass;
			goto next;
		}
	}
//iTM2_END;
    return;
}
@end

@implementation iTM2ConTeXtLabelButton
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= awakeFromNib
- (void)awakeFromNib;
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([[self superclass] instancesRespondToSelector:_cmd])
		[super awakeFromNib];
	[self setAction:@selector(ConTeXtLabelButtonAction:)];
	[self performSelector:@selector(initMenu) withObject:nil afterDelay:0.01];
	[DNC removeObserver: self
		name: NSPopUpButtonWillPopUpNotification
			object: self];
	[DNC addObserver: self
		selector: @selector(popUpButtonWillPopUpNotified:)
			name: NSPopUpButtonWillPopUpNotification
				object: self];
	NSView * superview = [self superview];
	[self removeFromSuperviewWithoutNeedingDisplay];
	[superview addSubview:self];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= initMenu
- (void)initMenu;
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSView * owner = [[[NSView allocWithZone:[self zone]] initWithFrame:NSZeroRect] autorelease];
	NSDictionary * context = [NSDictionary dictionaryWithObject:owner forKey:@"NSOwner"];
	NSString * fileName;
	Class class = [self class];
next:
	fileName = [[NSBundle bundleForClass:class] pathForResource:@"iTM2ConTeXtLabelMenu" ofType:@"nib"];
	if([fileName length])
	{
		NSString * title = [self title];
		if([NSBundle loadNibFile:fileName externalNameTable:context withZone:[self zone]])
		{
			NSMenu * M = [owner menu];
			[owner setMenu:nil];
			if([M numberOfItems])
			{
				NSMenuItem * MI;
				NSEnumerator * E = [[M itemArray] objectEnumerator];
				while(MI = [E nextObject])
				{
					SEL action = [MI action];
					if(action)
					{
						NSString * actionName = NSStringFromSelector(action);
						if([actionName hasPrefix:@"insert"] || [actionName hasPrefix:@"goto"])
						{
							if(![MI indentationLevel])
								[MI setIndentationLevel:1];
						}
					}
				}
				[[M itemAtIndex:0] setTitle:title];
				[self setTitle:title];// will raise if the menu is void
				[self setMenu:M];
			}
			else
			{
				iTM2_LOG(@"..........  ERROR: Inconsistent file (Void menu) at %@", fileName);
			}
		}
		else
		{
			iTM2_LOG(@"..........  ERROR: Corrupted file at %@", fileName);
		}
	}
	else
	{
		Class superclass = [class superclass];
		if((superclass) && (superclass != class))
		{
			class = superclass;
			goto next;
		}
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  popUpButtonWillPopUpNotified:
- (void)popUpButtonWillPopUpNotified:(NSNotification *)notification;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSMenu * labelMenu = nil;
	NSMenu * refMenu = nil;
	[[[[self window] windowController] textStorage] getConTeXtLabelMenu: &labelMenu refMenu: &refMenu];
	NSAssert(labelMenu, @"Missing ConTeXt label menu: inconsistency");
	NSAssert(refMenu, @"Missing ConTeXt ref menu: inconsistency");
	NSMenuItem * MI = [[self menu] deepItemWithAction:@selector(gotoConTeXtLabel:)];
	if(MI)
	{
		[MI setAction:NULL];
		[MI setRepresentedObject:@"ConTeXt Label Menu"];
		[[MI menu] setSubmenu: ([labelMenu numberOfItems]? labelMenu:nil) forItem:MI];
	}
	else if(MI = [[self menu] deepItemWithRepresentedObject:@"ConTeXt Label Menu"])
	{
		[[MI menu] setSubmenu: ([labelMenu numberOfItems]? labelMenu:nil) forItem:MI];
	}
	if(MI = [[self menu] deepItemWithAction:@selector(gotoConTeXtReference:)])
	{
		[MI setAction:NULL];
		[MI setRepresentedObject:@"ConTeXt Reference Menu"];
		[[MI menu] setSubmenu: ([refMenu numberOfItems]? refMenu:nil) forItem:MI];
	}
	else if(MI = [[self menu] deepItemWithRepresentedObject:@"ConTeXt Reference Menu"])
	{
		[[MI menu] setSubmenu: ([refMenu numberOfItems]? refMenu:nil) forItem:MI];
	}
	labelMenu = [[labelMenu copy] autorelease];
	NSEnumerator * E = [[labelMenu itemArray] objectEnumerator];
	while(MI = [E nextObject])
		if([MI action] == @selector(scrollConTeXtLabelToVisible:))
			[MI setAction:@selector(_insertConTeXtKnownReference:)];
	if(MI = [[self menu] deepItemWithAction:@selector(insertConTeXtKnownReference:)])
	{
		[MI setAction:NULL];
		[MI setRepresentedObject:@"ConTeXt Known Reference Menu"];
		[[MI menu] setSubmenu: ([labelMenu numberOfItems]? labelMenu:nil) forItem:MI];
	}
	else if(MI = [[self menu] deepItemWithRepresentedObject:@"ConTeXt Known Reference Menu"])
	{
		[[MI menu] setSubmenu: ([labelMenu numberOfItems]? labelMenu:nil) forItem:MI];
	}
//iTM2_END;
    return;
}
@end

#define BUNDLE [self classBundle]
#define TABLE @"iTM2InsertConTeXt"

@implementation iTM2ConTeXtEditor
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= clickedOnLink:atIndex:
- (void)clickedOnLink:(id)link atIndex:(unsigned)charIndex;
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * S = [[self textStorage] string];
	NSRange R = [NSString TeXAwareDoubleClick:S atIndex:charIndex];
	if(R.length<2)
		return;
	++R.location;
	--R.length;
	NSString * command = [S substringWithRange:R];
	if([command isEqualToString:@"include"])
	{
		unsigned start = NSMaxRange(R);
		if(start < [S length])
		{
			unsigned contentsEnd, TeXComment;
			[S getLineStart:nil end:nil contentsEnd: &contentsEnd TeXComment: &TeXComment forIndex:start];
			NSString * string = [S substringWithRange:
				NSMakeRange(start, (TeXComment == NSNotFound? contentsEnd: TeXComment) - start)];
			NSScanner * scanner = [NSScanner scannerWithString:string];
			[scanner scanString:@"{" intoString:nil];
			NSString * fileName;
			if([scanner scanCharactersFromSet:[NSCharacterSet TeXFileNameLetterCharacterSet] intoString: &fileName])
			{
				if(![fileName hasPrefix:@"/"])
				{
					fileName = [[[[[[self window] windowController] document] fileName] stringByDeletingLastPathComponent] stringByAppendingPathComponent:fileName];
				}
				if(![SWS openFile:fileName])
				{
					fileName = [fileName stringByAppendingPathExtension:@"tex"];
					if(![SWS openFile:fileName])
					{
						iTM2_LOG(@"INFO: could not open file <%@>", fileName);
					}				
				}
			}
			return;
		}
	}
	else if([command isEqualToString:@"includegraphics"])
	{
		unsigned start = NSMaxRange(R);
		if(start < [S length])
		{
			unsigned contentsEnd, TeXComment;
			[S getLineStart:nil end:nil contentsEnd: &contentsEnd TeXComment: &TeXComment forIndex:start];
			NSString * string = [S substringWithRange:
				NSMakeRange(start, (TeXComment == NSNotFound? contentsEnd: TeXComment) - start)];
			NSScanner * scanner = [NSScanner scannerWithString:string];
			[scanner scanString:@"{" intoString:nil];
			NSString * fileName;
			if([scanner scanCharactersFromSet:[NSCharacterSet TeXFileNameLetterCharacterSet] intoString: &fileName])
			{
				if(![fileName hasPrefix:@"/"])
				{
					fileName = [[[[[[self window] windowController] document] fileName] stringByDeletingLastPathComponent] stringByAppendingPathComponent:fileName];
				}
				if(![SWS openFile:fileName])
				{
					fileName = [fileName stringByAppendingPathExtension:@"tex"];
					if(![SWS openFile:fileName])
					{
						iTM2_LOG(@"INFO: could not open file <%@>", fileName);
					}				
				}
			}
			return;
		}
	}
	else if([command isEqualToString:@"url"])
	{
		unsigned start = NSMaxRange(R);
		if(start < [S length])
		{
			unsigned contentsEnd, TeXComment;
			[S getLineStart:nil end:nil contentsEnd: &contentsEnd TeXComment: &TeXComment forIndex:start];
			NSString * string = [S substringWithRange:
				NSMakeRange(start, (TeXComment == NSNotFound? contentsEnd: TeXComment) - start)];
			NSScanner * scanner = [NSScanner scannerWithString:string];
			[scanner scanString:@"{" intoString:nil];
			NSString * URLString;
			if([scanner scanCharactersFromSet:[NSCharacterSet TeXFileNameLetterCharacterSet] intoString: &URLString])
			{
				if([URLString length] && ![SWS openURL:[[[NSURL alloc] initWithString:URLString] autorelease]])
				{
					iTM2_LOG(@"INFO: could not open url <%@>", URLString);
				}
			}
			return;
		}
	}
	[super clickedOnLink:link atIndex:charIndex];
//iTM2_END;
    return;
}
#pragma mark =-=-=-=-=-  LABELS & REFERENCES
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertConTeXtLabel:
- (IBAction)insertConTeXtLabel:(id)sender;
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self insertMacro: NSLocalizedStringWithDefaultValue(NSStringFromSelector(_cmd),
		TABLE, BUNDLE, @"\\label{__(a label identifier)__}", "Inserting a  macro")];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateInsertConTeXtLabel:
- (BOOL)validateInsertConTeXtLabel:(id)sender; 
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  gotoConTeXtLabel:
- (IBAction)gotoConTeXtLabel:(id)sender; 
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	int tag = [sender tag];
	NSString * S = [[self textStorage] string];
	if(tag>=0 && tag<[S length])
	{
		unsigned begin, end;
		[S getLineStart: &begin end: &end contentsEnd:nil forRange:NSMakeRange(tag, 0)];
		[self highlightAndScrollToVisibleRange:NSMakeRange(begin, end-begin)];
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateGotoConTeXtLabel:
- (BOOL)validateGotoConTeXtLabel:(id)sender; 
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertConTeXtReference:
- (IBAction)insertConTeXtReference:(id)sender; 
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self insertMacro: NSLocalizedStringWithDefaultValue(NSStringFromSelector(_cmd),
		TABLE, BUNDLE, @"\\ref{__(a labeled identifier)__}", "Inserting a  macro")];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateInsertConTeXtReference:
- (BOOL)validateInsertConTeXtReference:(id)sender; 
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  gotoConTeXtReference:
- (IBAction)gotoConTeXtReference:(id)sender; 
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateGotoConTeXtReference:
- (BOOL)validateGotoConTeXtReference:(id)sender; 
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertConTeXtEquationReference:
- (IBAction)insertConTeXtEquationReference:(id)sender; 
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self insertMacro: NSLocalizedStringWithDefaultValue(NSStringFromSelector(_cmd),
		TABLE, BUNDLE, @"\\eqref{__(a labeled identifier)__}", "Inserting a  macro")];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateInsertConTeXtEquationReference:
- (BOOL)validateInsertConTeXtEquationReference:(id)sender; 
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  gotoConTeXtEquationReference:
- (IBAction)gotoConTeXtEquationReference:(id)sender; 
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateGotoConTeXtEquationReference:
- (BOOL)validateGotoConTeXtEquationReference:(id)sender; 
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  _insertConTeXtKnownReference:
- (IBAction)_insertConTeXtKnownReference:(id)sender; 
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self insertMacro:[NSString stringWithFormat:@"\\ref{%@}__(SEL)__", [sender representedObject]]];
//iTM2_END;
    return;
}
#pragma mark -
#pragma mark =-=-=-=-=-  SECTIONS
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  gotoConTeXtSection:
- (IBAction)gotoConTeXtSection:(id)sender; 
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	int tag = [sender tag];
	NSString * S = [[self textStorage] string];
	if(tag>=0 && tag<[S length])
	{
		unsigned begin, end;
		[S getLineStart: &begin end: &end contentsEnd:nil forRange:NSMakeRange(tag, 0)];
		[self highlightAndScrollToVisibleRange:NSMakeRange(begin, end-begin)];
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateGotoConTeXtSection:
- (BOOL)validateGotoConTeXtSection:(id)sender; 
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertConTeXtChapter:
- (IBAction)insertConTeXtChapter:(id)sender; 
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self insertMacro: NSLocalizedStringWithDefaultValue(NSStringFromSelector(_cmd),
		TABLE, BUNDLE, @"\\chapter{__(a labeled identifier)__}", "Inserting a  macro")];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateInsertConTeXtChapter:
- (BOOL)validateInsertConTeXtChapter:(id)sender; 
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertConTeXtPart:
- (IBAction)insertConTeXtPart:(id)sender; 
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self insertMacro: NSLocalizedStringWithDefaultValue(NSStringFromSelector(_cmd),
		TABLE, BUNDLE, @"\\part{__(a labeled identifier)__}", "Inserting a  macro")];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateInsertConTeXtPart:
- (BOOL)validateInsertConTeXtPart:(id)sender; 
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertConTeXtSection:
- (IBAction)insertConTeXtSection:(id)sender; 
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self insertMacro: NSLocalizedStringWithDefaultValue(NSStringFromSelector(_cmd),
		TABLE, BUNDLE, @"\\section{__(a labeled identifier)__}", "Inserting a  macro")];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateInsertConTeXtSection:
- (BOOL)validateInsertConTeXtSection:(id)sender; 
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertConTeXtSubSection:
- (IBAction)insertConTeXtSubSection:(id)sender; 
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self insertMacro: NSLocalizedStringWithDefaultValue(NSStringFromSelector(_cmd),
		TABLE, BUNDLE, @"\\subsection{__(a labeled identifier)__}", "Inserting a  macro")];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateInsertConTeXtSubSection:
- (BOOL)validateInsertConTeXtSubSection:(id)sender; 
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertConTeXtSubSubSection:
- (IBAction)insertConTeXtSubSubSection:(id)sender; 
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self insertMacro: NSLocalizedStringWithDefaultValue(NSStringFromSelector(_cmd),
		TABLE, BUNDLE, @"\\subsusection{__(a labeled identifier)__}", "Inserting a  macro")];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateInsertConTeXtSubSubSection:
- (BOOL)validateInsertConTeXtSubSubSection:(id)sender; 
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertConTeXtTitle:
- (IBAction)insertConTeXtTitle:(id)sender; 
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self insertMacro: NSLocalizedStringWithDefaultValue(NSStringFromSelector(_cmd),
		TABLE, BUNDLE, @"\\title{__(a labeled identifier)__}", "Inserting a  macro")];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateInsertConTeXtTitle:
- (BOOL)validateInsertConTeXtTitle:(id)sender; 
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertConTeXtSubject:
- (IBAction)insertConTeXtSubject:(id)sender; 
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self insertMacro: NSLocalizedStringWithDefaultValue(NSStringFromSelector(_cmd),
		TABLE, BUNDLE, @"\\subject{__(a labeled identifier)__}", "Inserting a  macro")];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateInsertConTeXtSubject:
- (BOOL)validateInsertConTeXtSubject:(id)sender; 
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertConTeXtSubSubject:
- (IBAction)insertConTeXtSubSubject:(id)sender; 
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self insertMacro: NSLocalizedStringWithDefaultValue(NSStringFromSelector(_cmd),
		TABLE, BUNDLE, @"\\subsubject{__(a labeled identifier)__}", "Inserting a  macro")];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateInsertConTeXtSubSubject:
- (BOOL)validateInsertConTeXtSubSubject:(id)sender; 
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertConTeXtSubSubSubject:
- (IBAction)insertConTeXtSubSubSubject:(id)sender; 
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self insertMacro: NSLocalizedStringWithDefaultValue(NSStringFromSelector(_cmd),
		TABLE, BUNDLE, @"\\subsubsubject{__(a labeled identifier)__}", "Inserting a  macro")];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateInsertConTeXtSubSubSubject:
- (BOOL)validateInsertConTeXtSubSubSubject:(id)sender; 
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  scrollConTeXtLabelToVisible:
- (void)scrollConTeXtLabelToVisible:(id <NSMenuItem>)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self scrollTaggedAndRepresentedStringToVisible:sender];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  scrollConTeXtReferenceToVisible:
- (void)scrollConTeXtReferenceToVisible:(id <NSMenuItem>)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self scrollTaggedAndRepresentedStringToVisible:sender];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  scrollIncludeToVisible:
- (void)scrollIncludeToVisible:(id <NSMenuItem>)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self performSelector:@selector(delayedScrollIncludeToVisible:) withObject:sender afterDelay:0.1];
	#if 0
    [NSInvocation delayInvocationWithTarget: self
        action: @selector(_ScrollIncludeToVisible:)
            sender: sender
                untilNotificationWithName: @"iTM2TDPerformScrollIn[clude|put]ToVisible"
                    isPostedFromObject: self];
	#endif
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  delayedScrollIncludeToVisible:
- (void)delayedScrollIncludeToVisible:(id <NSMenuItem>)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSString * path = [[[[sender menu] title]  stringByAppendingPathComponent:
                                [sender representedObject]] stringByStandardizingPath];
    if([DFM isReadableFileAtPath:path])
        [SDC openDocumentWithContentsOfURL:[NSURL fileURLWithPath:path] display:YES error:nil];
    else
    {
        NSString * P = [path stringByAppendingPathExtension:@"tex"];
        if([[NSFileManager defaultManager] isReadableFileAtPath:P])
            [SDC openDocumentWithContentsOfURL:[NSURL fileURLWithPath:P] display:YES error:nil];
        else
        {
            [sender setEnabled:NO];
            NSBeep();
            [self postNotificationWithStatus:
                [NSString stringWithFormat:  NSLocalizedStringFromTableInBundle(@"No file at path: %@", @"TeX",
                            [NSBundle bundleForClass:[self class]], "Could not complete the \\include action... 1 line only"), path]]; 
        }
    }
//iTM2_END;
    return;
}
@end

@implementation iTM2ConTeXtWindow
@end

@implementation iTM2ConTeXtParserAttributesServer
@end

@implementation iTM2XtdConTeXtParserAttributesServer
@end

static id _iTM2ConTeXtModeForModeArray = nil;

#define _TextStorage (iTM2TextStorage *)_TS

@implementation NSTextStorage(ConTeXt)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  ConTeXtSectionMenu
- (NSMenu *)ConTeXtSectionMenu;
/*"Description forthcoming. No consistency test.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{
//iTM2_START;
    BOOL withGraphics = ([[NSApp currentEvent] modifierFlags] & NSAlternateKeyMask)!=0;
    NSMenu * sectionMenu = [[[NSMenu allocWithZone:[NSMenu menuZone]] initWithTitle:@""] autorelease];
    NSString * S = [self string];
    iTM2LiteScanner * scan = [iTM2LiteScanner scannerWithString:S];
    unsigned scanLocation = 0, end = [S length];
    unsigned sectionCount = 0, subsectionCount = 0, subsubsectionCount = 0;
    next:
    if(scanLocation < end)
    {
        int depth = 0;
        #define partDepth 1
        #define chapterDepth 2
        #define sectionDepth 3
        #define subsectionDepth 4
        #define subsubsectionDepth 5
        #define titleDepth 100
        #define subjectDepth 101
        #define subsubjectDepth 102
        #define subsubsubjectDepth 103
        unichar theChar = [S characterAtIndex:scanLocation];
        if(theChar == '\\')
        {
            if(++scanLocation < end)
            {
                theChar = [S characterAtIndex:scanLocation];
                NSRange R1 = NSMakeRange(0, 0);
                if(theChar == 's')
                {
                    if(++scanLocation < end)
                    {
                        NSRange searchRange = NSMakeRange(scanLocation, end-scanLocation);
                        if(R1 = [S rangeOfString:@"ection" options:NSAnchoredSearch range:searchRange], R1.length)
                        {
                            scanLocation += 6;// section
                            depth = sectionDepth;
                            goto manihi;
                        }
                        else if(R1 = [S rangeOfString:@"ub" options:NSAnchoredSearch range:searchRange], R1.length)
                        {
                            searchRange.location += 2;
                            searchRange.length -= 2;
                            if(R1 = [S rangeOfString:@"section" options:NSAnchoredSearch range:searchRange], R1.length)
                            {
                                scanLocation += 9;// subsection
                                depth = subsectionDepth;
                                goto manihi;
                            }
                            else if(R1 = [S rangeOfString:@"ject" options:NSAnchoredSearch range:searchRange], R1.length)
                            {
                                scanLocation += 6;// subject
                                depth = subjectDepth;
                                goto manihi;
                            }
                            else if(R1 = [S rangeOfString:@"sub" options:NSAnchoredSearch range:searchRange], R1.length)
                            {
                                searchRange.location += 3;
                                searchRange.length -= 3;
                                if(R1 = [S rangeOfString:@"section" options:NSAnchoredSearch range:searchRange], R1.length)
                                {
                                    scanLocation += 12;// subsubsection
                                    depth = subsubsectionDepth;
                                    goto manihi;
                                }
                                else if(R1 = [S rangeOfString:@"ject" options:NSAnchoredSearch range:searchRange], R1.length)
                                {
                                    scanLocation += 9;// subsubject
                                    depth = subsubjectDepth;
                                    goto manihi;
                                }
                                else if(R1 = [S rangeOfString:@"sub" options:NSAnchoredSearch range:searchRange], R1.length)
                                {
                                    searchRange.location += 3;
                                    searchRange.length -= 3;
                                    if(R1 = [S rangeOfString:@"ject" options:NSAnchoredSearch range:searchRange], R1.length)
                                    {
                                        scanLocation += 12;// subsubsubject
                                        depth = subsubsubjectDepth;
                                        goto manihi;
                                    }
                                }
                            }
                        }
                        goto next;
                    }
                    else
                        goto endOfString;
                }
                else if(theChar == 'i')
                {
                    if(++scanLocation >= end)
                        goto endOfString;
                    else if([S characterAtIndex:scanLocation] == 'n')
                    {
                        if(++scanLocation >= end)
                            goto endOfString;
                        else
                        {
                            R1 = NSMakeRange(scanLocation, end-scanLocation);
                            NSRange R2 = [S rangeOfString:@"put" options:NSAnchoredSearch range:R1];
                            if(R2.length)
                            {
//NSLog(@"1");
                                [S getLineStart:nil end:nil contentsEnd: &scanLocation forRange:R2];
//NSLog(@"1");
                                [scan setScanLocation:NSMaxRange(R2)];
                                [scan scanString:@"{" intoString:nil];
                                NSString * object;
                                if([scan scanUpToString:@"}" intoString: &object beforeIndex:scanLocation] ||
                                    [scan scanCharactersFromSet:[[NSCharacterSet whitespaceAndNewlineCharacterSet] invertedSet]
                                        intoString: &object beforeIndex: scanLocation])
                                {
                                    object = [object stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];                            
                                    NSString * title = [NSString stringWithFormat:@"input: %@", object];
                                    title = ([title length] > 48)?
                                                    [NSString stringWithFormat:@"%@[...]",
                                                            [title substringWithRange:NSMakeRange(0,43)]]: title;
                                    if([title length])
                                    {
                                        NSMenuItem * MI = [sectionMenu addItemWithTitle: title
                                                                action: @selector(scrollInputToVisible:)
                                                                    keyEquivalent: [NSString string]];
                                        [MI setRepresentedObject:object];
                                        [MI setEnabled: ([[sectionMenu title] length] > 0)];
                                    }
                                }
                            }
                            else
                            {
                                SEL selector = NULL;
                                NSString * prefix = [NSString string];
                                R2 = [S rangeOfString:@"clude" options:NSAnchoredSearch range:R1];
                                if(R2.length)
                                {
                                    R1.location += 5;
                                    R1.length -= 5;
                                    if(withGraphics)
                                    {
                                        R2 = [S rangeOfString:@"graphics" options:NSAnchoredSearch range:R1];
                                        if(R2.length)
                                        {
                                            selector = @selector(scrollTaggedToVisible:);
//                                                selector = @selector(scrollIncludeGraphicToVisible:);
                                            prefix = @"includegraphics";// Localize???
                                            scanLocation = NSMaxRange(R2);
                                        }
                                        else if(R2 = [S rangeOfString:@"graphicx" options:NSAnchoredSearch range:R1], R2.length)
                                        {
                                            selector = @selector(scrollTaggedToVisible:);
//                                                selector = @selector(scrollIncludeGraphicToVisible:);
                                            prefix = @"includegraphicx";// Localize???
                                            scanLocation = NSMaxRange(R2);
                                        }
                                        else
                                        {
                                            selector = @selector(scrollIncludeToVisible:);
                                            prefix = @"include";
                                            scanLocation = R1.location;
                                        }
                                    }
                                    else
                                    {
                                        selector = @selector(scrollIncludeToVisible:);
                                        prefix = @"include";
                                        scanLocation = R1.location;
                                    }
                                    unsigned int contentsEnd;
//NSLog(@"2");
                                    [S getLineStart:nil end:nil contentsEnd: &contentsEnd forRange:R1];
//NSLog(@"2");
                                    [scan setScanLocation:scanLocation];
                                    if([scan scanString:@"[" intoString:nil])
                                    {
                                        [scan scanUpToString:@"]" intoString:nil];
                                        [scan scanString:@"]" intoString:nil];
                                    }
                                    if([scan scanString:@"{" intoString:nil])
                                    {
                                        NSString * object;
                                        if([scan scanUpToString:@"}" intoString: &object beforeIndex:contentsEnd])
                                        {
                                            object = [object stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                                            NSString * title = [NSString stringWithFormat:@"%@: %@", prefix, object];
                                            title = ([title length] > 48)?
                                                            [NSString stringWithFormat:@"%@[...]",
                                                                    [title substringWithRange:NSMakeRange(0,43)]]: title;
                                            if(![title length])
                                                title = @"?";
                                            NSMenuItem * MI = [sectionMenu addItemWithTitle: title
                                                                    action: selector keyEquivalent: [NSString string]];
                                            [MI setTag:scanLocation];
                                            [MI setRepresentedObject:object];
                                            [MI setEnabled: ([[sectionMenu title] length] > 0)];
                                            goto manihi;
                                        }
                                    }
                                    scanLocation = [scan scanLocation];
                                    goto next;
                                }
                            }
                        }
                    }
                }
                else if (theChar == 'c')
                {
                    if(++scanLocation<end)
                    {
                        NSRange searchRange = NSMakeRange(scanLocation, end-scanLocation);
                        if(R1 = [S rangeOfString:@"hapter" options:NSAnchoredSearch range:searchRange], R1.length)
                        {
                            scanLocation += 6;// chapter
                            depth = chapterDepth;
                            goto manihi;
                        }
                    }
                }
                else if (theChar == 't')
                {
                    if(++scanLocation<end)
                    {
                        NSRange searchRange = NSMakeRange(scanLocation, end-scanLocation);
                        if(R1 = [S rangeOfString:@"itle" options:NSAnchoredSearch range:searchRange], R1.length)
                        {
                            scanLocation += 4;// title
                            depth = titleDepth;
                            goto manihi;
                        }
                    }
                }
                ++scanLocation;
                goto next;
                unsigned int contentsEnd;
manihi:
//NSLog(@"manihi: %i", depth);
//NSLog(@"3");
                [S getLineStart:nil end:nil contentsEnd: &contentsEnd forRange:R1];
//NSLog(@"3");
                [scan setScanLocation:scanLocation];
                if([scan scanString:@"[" intoString:nil])
                {
                    [scan scanUpToString:@"]" intoString:nil];
                    [scan scanString:@"]" intoString:nil];
                }
                if([scan scanString:@"{" intoString:nil])
                {
                    NSString * object;
                    if([scan scanUpToString:@"}" intoString: &object beforeIndex:contentsEnd])
                    {
                        object = [object stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                        if(![object length])
                            object = @"?";
                        NSString * prefix;
                        switch(depth)
                        {
                            case partDepth:
                                prefix = @"Part: ";
                                sectionCount = subsectionCount = subsubsectionCount = 0;
                                break;
                            case chapterDepth:
                                prefix = @"Chap: ";
                                sectionCount = subsectionCount = subsubsectionCount = 0;
                                break;
                            default:
                                prefix = @"";
                                break;
                            case sectionDepth:
                                prefix = [NSString stringWithFormat:@"%d. ", ++sectionCount];
                                subsectionCount = subsubsectionCount = 0;
                                break;
                            case subsectionDepth:
                                prefix = [NSString stringWithFormat:@"%d.%c. ", sectionCount, ++subsectionCount+'a'-1];
                                subsubsectionCount = 0;
                                break;
                            case subsubsectionDepth:
                                prefix = [NSString stringWithFormat:@"%d.%c.%d. ", sectionCount, subsectionCount+'a'-1, ++subsubsectionCount];
                                break;
                            case titleDepth:
                                prefix = @"Title: ";
                                break;
                            case subjectDepth:
                                prefix = @"";
                                break;
                            case subsubjectDepth:
                                prefix = @".";
                                break;
                            case subsubsubjectDepth:
                                prefix = @"..";
                                break;
                        }
                    
                        NSString * title;
                        title = [NSString stringWithFormat:@"%@%@", prefix, object];
                        title = ([title length] > 48)?
                                        [NSString stringWithFormat:@"%@[...]",
                                                [title substringWithRange:NSMakeRange(0,43)]]: title;
                        if(![title length])
                            title = @"?";
                        NSMenuItem * MI = [sectionMenu addItemWithTitle: title
                                                action: @selector(scrollTaggedToVisible:) keyEquivalent: [NSString string]];
                        [MI setTag:scanLocation];
                        [MI setRepresentedObject:object];
                        [MI setEnabled: ([[sectionMenu title] length] > 0)];
                        scanLocation = [scan scanLocation];
                        goto next;
                    }
                    else
                    {
                        scanLocation = [scan scanLocation];
                        goto next;
                    }
                }
                else
                {
                    scanLocation = [scan scanLocation];
                    goto next;
                }
            }// end
        }
        else
        {
            ++scanLocation;
            goto next;
        }
    }
    endOfString:
//iTM2_END;
    return sectionMenu;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  getConTeXtLabelMenu:refMenu:
- (void)getConTeXtLabelMenu:(NSMenu **)labelMenuRef refMenu:(NSMenu **)refMenuRef;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: ...
"*/
{    
//iTM2_START;
    NSMenu * labelMenu = [[[NSMenu allocWithZone:[NSMenu menuZone]] initWithTitle:@""] autorelease];
    NSMenu * refMenu = [[[NSMenu allocWithZone:[NSMenu menuZone]] initWithTitle:@""] autorelease];
    NSMenu * eqrefMenu = [[[NSMenu allocWithZone:[NSMenu menuZone]] initWithTitle:@""] autorelease];
    [labelMenu setAutoenablesItems:YES];
    [refMenu setAutoenablesItems:YES];
    [eqrefMenu setAutoenablesItems:YES];

    NSString * S = [self string];
    iTM2LiteScanner * scan = [iTM2LiteScanner scannerWithString:S];
    unsigned scanLocation = 0, end = [S length];
    unichar theChar;
    while(scanLocation < end)
    {
        theChar = [S characterAtIndex:scanLocation];
        switch(theChar)
        {
            case '\\':
            {
                if(++scanLocation < end)
                {
                    NSRange R1 = NSMakeRange(scanLocation, end-scanLocation);
                    NSRange R2 = [S rangeOfString:@"label" options:NSAnchoredSearch range:R1];
                    if(R2.length)
                    {
                        unsigned int contentsEnd;
                        [S getLineStart:nil end:nil contentsEnd: &contentsEnd forRange:R2];
                        [scan setScanLocation:NSMaxRange(R2)];
                        if([scan scanString:@"{" intoString:nil])
                        {
                            NSString * object;
                            scanLocation = [scan scanLocation];
                            if([scan scanUpToString:@"}" intoString: &object beforeIndex:contentsEnd] ||
                                [scan scanCharactersFromSet:[[NSCharacterSet whitespaceAndNewlineCharacterSet] invertedSet]
                                    intoString: &object beforeIndex: contentsEnd])
                            {
                                scanLocation = [scan scanLocation];
                                object = [object stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];                            
                                NSString * title = ([object length] > 48)?
                                                        [NSString stringWithFormat:@"%@[...]",
                                                            [object substringWithRange:NSMakeRange(0,43)]]: object;
                                if([title length])
                                {
                                    NSMenuItem * MI = [labelMenu addItemWithTitle: title
                                                            action: @selector(scrollConTeXtLabelToVisible:)
                                                                keyEquivalent: [NSString string]];
                                    [MI setTag:R2.location];
                                    [MI setRepresentedObject:object];
                                    [MI setEnabled: ([[labelMenu title] length] > 0)];
                                }
                            }
                        }
                    }
                    else if((R2 = [S rangeOfString:@"ref" options:NSAnchoredSearch range:R1], R2.length) ||
                        (R2 = [S rangeOfString:@"eqref" options:NSAnchoredSearch range:R1], R2.length) ||
                        (R2 = [S rangeOfString:@"secref" options:NSAnchoredSearch range:R1], R2.length) ||
                        (R2 = [S rangeOfString:@"figref" options:NSAnchoredSearch range:R1], R2.length) ||
                        (R2 = [S rangeOfString:@"pageref" options:NSAnchoredSearch range:R1], R2.length))
                    {
                        unsigned int contentsEnd;
                        [S getLineStart:nil end:nil contentsEnd: &contentsEnd forRange:R2];
                        [scan setScanLocation:NSMaxRange(R2)];
                        if([scan scanString:@"{" intoString:nil])
                        {
                            NSString * object;
                            scanLocation = [scan scanLocation];
                            if([scan scanUpToString:@"}" intoString: &object beforeIndex:contentsEnd] ||
                                [scan scanCharactersFromSet:[[NSCharacterSet whitespaceAndNewlineCharacterSet] invertedSet]
                                    intoString: &object beforeIndex: contentsEnd])
                            {
                                scanLocation = [scan scanLocation];
                                object = [object stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];                            
                                NSString * title = ([object length] > 48)?
                                                        [NSString stringWithFormat:@"%@[...]",
                                                            [object substringWithRange:NSMakeRange(0,43)]]: object;
                                if([title length])
                                {
                                    NSMenuItem * MI = [refMenu addItemWithTitle: title
                                                            action: @selector(scrollConTeXtReferenceToVisible:)
                                                                keyEquivalent: [NSString string]];
                                    [MI setTag:R2.location];
                                    [MI setRepresentedObject:object];
                                    [MI setEnabled: ([[refMenu title] length] > 0)];
                                }
                            }
                        }
                    }
                    else if(([S characterAtIndex:scanLocation] == 'i') &&
                                (++scanLocation < end) &&
                                    ([S characterAtIndex:scanLocation] == 'n') &&
                                        (++scanLocation < end))
                    {
                        NSRange R1 = NSMakeRange(scanLocation, end-scanLocation);
                        NSRange R2 = [S rangeOfString:@"put" options:NSAnchoredSearch range:R1];
                        if(R2.length)
                        {
                            SEL selector = @selector(scrollInputToVisible:);
                            NSString * prefix = @"Input";
                            [S getLineStart:nil end:nil contentsEnd: &scanLocation forRange:R2];
                            [scan setScanLocation:NSMaxRange(R2)];
                            [scan scanString:@"{" intoString:nil];
                            NSString * object;
                            if([scan scanUpToString:@"}" intoString: &object beforeIndex:scanLocation] ||
                                [scan scanCharactersFromSet:[[NSCharacterSet whitespaceAndNewlineCharacterSet] invertedSet]
                                    intoString: &object beforeIndex: scanLocation])
                            {
                                object = [object stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];                            
                                NSString * title = [NSString stringWithFormat:@"%@: %@", prefix, object];
                                title = ([title length] > 48)?
                                                [NSString stringWithFormat:@"%@[...]",
                                                        [title substringWithRange:NSMakeRange(0,43)]]: title;
                                if([title length])
                                {
                                    NSMenuItem * MI = [labelMenu addItemWithTitle:title action:selector keyEquivalent:[NSString string]];
                                    [MI setRepresentedObject:object];
                                    [MI setEnabled: ([[labelMenu title] length] > 0)];
                                }
                            }
                        }
                        else if(R2 = [S rangeOfString:@"clude" options:NSAnchoredSearch range:R1], R2.length)
                        {
                            SEL selector = @selector(scrollIncludeToVisible:);
                            NSString * prefix = @"Include";
                            unsigned int contentsEnd;
                            [S getLineStart:nil end:nil contentsEnd: &contentsEnd forRange:R1];
                            [scan setScanLocation:NSMaxRange(R2)];
                            if([scan scanString:@"[" intoString:nil beforeIndex:contentsEnd])
                            {
                                [scan scanUpToString:@"]" intoString:nil];
                                [scan scanString:@"]" intoString:nil];
                            }
                            if([scan scanString:@"{" intoString:nil beforeIndex:contentsEnd])
                            {
                                NSString * object;
                                if([scan scanUpToString:@"}" intoString: &object beforeIndex:contentsEnd])
                                {
                                    object = [object stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                                    NSString * title = [NSString stringWithFormat:@"%@: %@", prefix, object];
                                    title = ([title length] > 48)?
                                                    [NSString stringWithFormat:@"%@[...]",
                                                            [title substringWithRange:NSMakeRange(0,43)]]: title;
                                    if([title length])
                                    {
                                        NSMenuItem * MI = [labelMenu addItemWithTitle:title action:selector keyEquivalent:[NSString string]];
                                        [MI setRepresentedObject:object];
                                        [MI setEnabled: ([[labelMenu title] length] > 0)];
                                    }
                                }
                            }
                            else
                                NSLog(@"No file to include");
                        }
                        else
                            break;
                    }
                    else
                    {
                        ++scanLocation;
                    }
                }
            }
            break;
            case '%':
            {
                [scan setScanLocation: ++scanLocation];
                NSString * object = nil;
                [scan scanUpToCharactersFromSet:
                        [NSCharacterSet characterSetWithCharactersInString:@"\r\n"]
                            intoString: &object];
                scanLocation = [scan scanLocation];
            }
            default:
                ++scanLocation;
        }
    }
	if(labelMenuRef)
		*labelMenuRef = labelMenu;
	if(refMenuRef)
		*refMenuRef = refMenu;
    return;
}
@end

@implementation iTM2ConTeXtParser
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= load
+ (void)load;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
	iTM2_INIT_POOL;
//iTM2_START;
//iTM2_LOG(@"iTM2TeXParser");
    if(!_iTM2ConTeXtModeForModeArray)
        _iTM2ConTeXtModeForModeArray = [[NSArray arrayWithObjects:@"include", @"includegraphics", @"url", nil] retain];
	iTM2_RELEASE_POOL;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= syntaxParserStyle
+ (NSString *)syntaxParserStyle;
/*"Designated initializer.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2: 12/05/2003
To Do List: Nothing
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return @"ConTeXt";
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  defaultModesAttributes
+ (NSDictionary *)defaultModesAttributes;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSMutableDictionary * include = [NSMutableDictionary dictionaryWithDictionary:
									[[super defaultModesAttributes] objectForKey:@"input"]];
	[include setObject:@"include" forKey:iTM2TextModeAttributeName];
	[include setObject:@"" forKey:NSLinkAttributeName];
    NSMutableDictionary * includegraphics = [NSMutableDictionary dictionaryWithDictionary:
									[[super defaultModesAttributes] objectForKey:@"input"]];
	[includegraphics setObject:@"includegraphics" forKey:iTM2TextModeAttributeName];
	[includegraphics setObject:@"" forKey:NSLinkAttributeName];
    NSMutableDictionary * url = [NSMutableDictionary dictionaryWithDictionary:
									[[super defaultModesAttributes] objectForKey:@"input"]];
	[url setObject:@"url" forKey:iTM2TextModeAttributeName];
	[url setObject:@"" forKey:NSLinkAttributeName];
    NSMutableDictionary * MD = [[[super defaultModesAttributes] mutableCopy] autorelease];
    [MD setObject:[[include copy] autorelease] forKey:[include objectForKey:iTM2TextModeAttributeName]];
    [MD setObject:[[includegraphics copy] autorelease] forKey:[includegraphics objectForKey:iTM2TextModeAttributeName]];
    [MD setObject:[[url copy] autorelease] forKey:[url objectForKey:iTM2TextModeAttributeName]];
    return [NSDictionary dictionaryWithDictionary:MD];
}
#if 1
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  syntaxModeForCharacter:previousMode:
- (unsigned)syntaxModeForCharacter:(unichar)theChar previousMode:(unsigned)previousMode;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Dec 12 22:44:56 GMT 2003
To Do List: 
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//    if(previousMode != ( previousMode & ~kiTM2TeXErrorSyntaxMask))
//        NSLog(@"previousMode: 0X%x, mask: 0X%x, previousMode & ~mask: 0X%x",  previousMode, kiTM2TeXErrorSyntaxModeMask,  previousMode & ~kiTM2TeXErrorSyntaxMask);
	// this is for the added modes, but links should not happen here.
	unsigned switcher = previousMode & ~kiTM2TeXErrorSyntaxMask;
	switch(switcher)
	{
		case kiTM2ConTeXtIncludeSyntaxMode:
		case kiTM2ConTeXtIncludegraphicsSyntaxMode:
		case kiTM2ConTeXtURLSyntaxMode:
		if([[NSCharacterSet TeXLetterCharacterSet] characterIsMember:theChar])
		{
			if([_AS character:theChar isMemberOfCoveredCharacterSetForMode:[_iTM2ConTeXtModeForModeArray objectAtIndex:switcher - 1000]])
				return previousMode;
			else
			{
	//iTM2_LOG(@"AN ERROR OCCURRED");
				return previousMode | kiTM2TeXErrorFontSyntaxMask;
			}
		}
		else
			return [super syntaxModeForCharacter:theChar previousMode:kiTM2TeXCommandSyntaxMode];
		default:
			return [super syntaxModeForCharacter:theChar previousMode:previousMode];
	}
//iTM2_END;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  syntaxModeForLocation:previousMode:effectiveLength:nextModeIn:before:
- (unsigned)syntaxModeForLocation:(unsigned)location previousMode:(unsigned)previousMode effectiveLength:(unsigned *)lengthRef nextModeIn:(unsigned *)nextModeRef before:(unsigned)beforeIndex;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Dec 12 22:44:56 GMT 2003
To Do List: 
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSString * S = [_TextStorage string];
    NSParameterAssert(location<[S length]);
	unsigned switcher = previousMode & ~kiTM2TeXErrorSyntaxMask;
	if(kiTM2TeXBeginCommandSyntaxMode == switcher)
	{
		if([[NSCharacterSet TeXLetterCharacterSet] characterIsMember:[S characterAtIndex:location]])
		{
			// is it a \include, \includegraphics, \url
			// scanning from location for the control sequence name
			unsigned start = location;
			unsigned end = start + 1;
			while(end<[S length] && [[NSCharacterSet TeXLetterCharacterSet] characterIsMember:[S characterAtIndex:end]])
				++end;
			if(end == start+15)
			{
				if([@"includegraphics" isEqualToString:[S substringWithRange:NSMakeRange(start, end - start)]])
				{
					if(lengthRef)
						* lengthRef = end - start;
					if(nextModeRef && (end<[S length]))
					{
						* nextModeRef = [self syntaxModeForCharacter:[S characterAtIndex:end] previousMode:kiTM2ConTeXtIncludegraphicsSyntaxMode];
					}
					// now we invalidate the cursor rects in order to have the links properly displayed
					//the delay is due to the reentrant problem
					[_TextStorage performSelector:@selector(invalidateCursorRects) withObject:nil afterDelay:0.01];
					return kiTM2ConTeXtIncludegraphicsSyntaxMode;
				}
			}
			else if(end == start+7)
			{
				if([@"include" isEqualToString:[S substringWithRange:NSMakeRange(start, end - start)]])
				{
					if(lengthRef)
						* lengthRef = end - start;
					if(nextModeRef && (end<[S length]))
					{
						* nextModeRef = [self syntaxModeForCharacter:[S characterAtIndex:end] previousMode:kiTM2ConTeXtIncludegraphicsSyntaxMode];
					}
					// now we invalidate the cursor rects in order to have the links properly displayed
					//the delay is due to the reentrant problem
					[_TextStorage performSelector:@selector(invalidateCursorRects) withObject:nil afterDelay:0.01];
					return kiTM2ConTeXtIncludeSyntaxMode;
				}
			}
			else if(end == start+3)
			{
				if([@"url" isEqualToString:[S substringWithRange:NSMakeRange(start, end - start)]])
				{
					if(lengthRef)
						* lengthRef = end - start;
					if(nextModeRef && (end<[S length]))
					{
						* nextModeRef = [self syntaxModeForCharacter:[S characterAtIndex:end] previousMode:kiTM2ConTeXtIncludegraphicsSyntaxMode];
					}
					// now we invalidate the cursor rects in order to have the links properly displayed
					//the delay is due to the reentrant problem
					[_TextStorage performSelector:@selector(invalidateCursorRects) withObject:nil afterDelay:0.01];
					return kiTM2ConTeXtURLSyntaxMode;
				}
			}
		}
	}
	if(nextModeRef)
	{
		unsigned result = [super syntaxModeForLocation:location previousMode:previousMode effectiveLength:lengthRef nextModeIn:nextModeRef before:beforeIndex];
		if((result == kiTM2TeXBeginCommandSyntaxMode) && (*nextModeRef == kiTM2TeXCommandSyntaxMode))
		{
			unsigned start = location+1;
			unsigned end = start;
			while(end<[S length] && [[NSCharacterSet TeXLetterCharacterSet] characterIsMember:[S characterAtIndex:end]])
				++end;
			if(end == start+15)
			{
				if([@"includegraphics" isEqualToString:[S substringWithRange:NSMakeRange(start, end - start)]])
					*nextModeRef = kiTM2ConTeXtIncludegraphicsSyntaxMode;
			}
			else if(end == start+7)
			{
				if([@"include" isEqualToString:[S substringWithRange:NSMakeRange(start, end - start)]])
					*nextModeRef = kiTM2ConTeXtIncludeSyntaxMode;
			}
			else if(end == start+3)
			{
				if([@"url" isEqualToString:[S substringWithRange:NSMakeRange(start, end - start)]])
					*nextModeRef = kiTM2ConTeXtURLSyntaxMode;
			}
		}
		return result;
	}
	else
		return [super syntaxModeForLocation:location previousMode:previousMode effectiveLength:lengthRef nextModeIn:nil before:beforeIndex];
//iTM2_END;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  attributesAtIndex:effectiveRange:
- (NSDictionary *)attributesAtIndex:(unsigned)aLocation effectiveRange:(NSRangePointer)aRangePtr;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    unsigned mode = [self syntaxModeAtIndex:aLocation longestRange:aRangePtr];
	unsigned switcher = mode & ~kiTM2TeXErrorSyntaxMask;
    switch(switcher)
    {
        case kiTM2TeXBeginCommandSyntaxMode:
			if(aLocation + 1 < [[self textStorage] length])
			{
				unsigned nextMode = [self syntaxModeAtIndex:aLocation + 1 longestRange:aRangePtr];
				unsigned nextSwitcher = nextMode & ~kiTM2TeXErrorSyntaxMask;
				switch(nextSwitcher)
				{
					case kiTM2ConTeXtIncludeSyntaxMode:
					case kiTM2ConTeXtIncludegraphicsSyntaxMode:
					case kiTM2ConTeXtURLSyntaxMode:
					{
						if(aRangePtr)
						{
							aRangePtr->location -= 1;
							aRangePtr->length += 1;
						}
						return [_AS attributesForMode:[_iTM2ConTeXtModeForModeArray objectAtIndex:nextSwitcher - 1000]];
					}
					default:
						return [super attributesAtIndex:aLocation effectiveRange:aRangePtr];
				}
			}
			else
				return [super attributesAtIndex:aLocation effectiveRange:aRangePtr];
        case kiTM2ConTeXtIncludeSyntaxMode:
        case kiTM2ConTeXtIncludegraphicsSyntaxMode:
        case kiTM2ConTeXtURLSyntaxMode:
			if(aRangePtr)
			{
				unsigned max = NSMaxRange(*aRangePtr);
				aRangePtr->location = aLocation;
				aRangePtr->length = max - aLocation;
			}
            return [_AS attributesForMode:[_iTM2ConTeXtModeForModeArray objectAtIndex:switcher - 1000]];
        default:
            return [super attributesAtIndex:aLocation effectiveRange:aRangePtr];
    }
}
#endif
@end

@implementation iTM2XtdConTeXtParser
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= syntaxParserStyle
+ (NSString *)syntaxParserStyle;
/*"Designated initializer.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2: 12/05/2003
To Do List: Nothing
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return @"ConTeXt-Xtd";
}
#if 1
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  attributesAtIndex:effectiveRange:
- (NSDictionary *)attributesAtIndex:(unsigned)aLocation effectiveRange:(NSRangePointer)aRangePtr;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    unsigned mode = [self syntaxModeAtIndex:aLocation longestRange:aRangePtr];
	unsigned switcher = mode & ~kiTM2TeXErrorSyntaxMask;
    switch(switcher)
    {
        case kiTM2TeXBeginCommandSyntaxMode:
			if(aLocation + 1 < [[self textStorage] length])
			{
				unsigned nextMode = [self syntaxModeAtIndex:aLocation + 1 longestRange:aRangePtr];
				unsigned nextSwitcher = nextMode & ~kiTM2TeXErrorSyntaxMask;
				switch(nextSwitcher)
				{
					case kiTM2ConTeXtIncludeSyntaxMode:
					case kiTM2ConTeXtIncludegraphicsSyntaxMode:
					case kiTM2ConTeXtURLSyntaxMode:
					{
						if(aRangePtr)
						{
							aRangePtr->location -= 1;
							aRangePtr->length += 1;
						}
						return [_AS attributesForMode:[_iTM2ConTeXtModeForModeArray objectAtIndex:nextSwitcher - 1000]];
					}
					default:
						return [super attributesAtIndex:aLocation effectiveRange:aRangePtr];
				}
			}
			else
				return [super attributesAtIndex:aLocation effectiveRange:aRangePtr];
        case kiTM2ConTeXtIncludeSyntaxMode:
        case kiTM2ConTeXtIncludegraphicsSyntaxMode:
        case kiTM2ConTeXtURLSyntaxMode:
			if(aRangePtr)
			{
				unsigned max = NSMaxRange(*aRangePtr);
				aRangePtr->location = aLocation;
				aRangePtr->length = max - aLocation;
			}
            return [_AS attributesForMode:[_iTM2ConTeXtModeForModeArray objectAtIndex:switcher - 1000]];
        default:
            return [super attributesAtIndex:aLocation effectiveRange:aRangePtr];
    }
}
#endif
@end

NSString * const iTM2ConTeXtParserAttributesInspectorType = @"iTM2ConTeXtParserAttributes";

@implementation iTM2ConTeXtParserAttributesDocument
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inspectorType
+ (NSString *)inspectorType;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return iTM2ConTeXtParserAttributesInspectorType;
}
@end

@implementation iTM2ConTeXtParserAttributesInspector
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inspectorType
+ (NSString *)inspectorType;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return iTM2ConTeXtParserAttributesInspectorType;
}
@end

NSString * const iTM2XtdConTeXtParserAttributesInspectorType = @"iTM2XtdConTeXtParserAttributes";

@implementation iTM2XtdConTeXtParserAttributesDocument
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inspectorType
+ (NSString *)inspectorType;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return iTM2XtdConTeXtParserAttributesInspectorType;
}
@end

@implementation iTM2XtdConTeXtParserAttributesInspector
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inspectorType
+ (NSString *)inspectorType;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return iTM2XtdConTeXtParserAttributesInspectorType;
}
@end

@implementation iTM2XtdConTeXtParserSymbolsInspector
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inspectorType
+ (NSString *)inspectorType;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return iTM2XtdConTeXtParserAttributesInspectorType;
}
@end

@implementation iTM2ProjectDocumentResponder(ConTeXt)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  ConTeXtLabelAction:
- (IBAction)ConTeXtLabelAction:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue May  3 16:20:26 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	return;
}  
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  ConTeXtLabelActionWillPopUp:
- (BOOL)ConTeXtLabelActionWillPopUp:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue May  3 16:20:26 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	return YES;
}  
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  ConTeXtSectionAction:
- (IBAction)ConTeXtSectionAction:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue May  3 16:20:26 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	return;
}  
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  ConTeXtSectionActionWillPopUp:
- (BOOL)ConTeXtSectionActionWillPopUp:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue May  3 16:20:26 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	return YES;
}  
@end

@implementation NSMenu(iTM2ConTeXtKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  menuWithConTeXtGardenXMLElements:
+ (NSMenu *)menuWithConTeXtGardenXMLElements:(NSArray *)elements;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue May  3 16:20:26 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSMenu * result = [[[NSMenu alloc] initWithTitle:@""] autorelease];
	NSEnumerator * E = [elements objectEnumerator];
	NSXMLElement * element;
	while(element = [E nextObject])
	{
		NSString * title = [[[element elementsForName:@"title"] lastObject] stringValue];
		if([title length])
		{
			NSMenuItem * MI = [[[NSMenuItem alloc] initWithTitle:title action:NULL keyEquivalent:@""] autorelease];
			[result addItem:MI];
			NSMenu * M = [self menuWithConTeXtGardenXMLElements:[[[element elementsForName:@"items"] lastObject] children]];
			if(M)
				[result setSubmenu:M forItem:MI];
			[MI setToolTip:[[[element elementsForName:@"tooltip"] lastObject] stringValue]];
			[MI setRepresentedObject:[iTM2ConTeXtInspector ConTeXtGardenPageURLWithRef:[[element attributeForName:@"href"] stringValue]]];
			[MI setAction:@selector(ConTeXtAtGardenFromRepresentedURL:)];
			[MI setTarget:nil];
		}
	}
//iTM2_END;
	return [result numberOfItems] > 0? result: nil;
}  
@end

#undef DEFINE_TOOLBAR_ITEM
#define DEFINE_TOOLBAR_ITEM(SELECTOR)\
+ (NSToolbarItem *)SELECTOR;{return [self toolbarItemWithIdentifier:[self identifierFromSelector:_cmd] inBundle:[iTM2TeXProjectInspector classBundle]];}

#import <iTM2TeXFoundation/iTM2TeXPCommandWrapperKit.h>
#if 0
@implementation NSToolbarItem(iTM2ConTeXt)
+ (NSToolbarItem *)ConTeXtLabelToolbarItem;
{
	NSToolbarItem * toolbarItem = [self toolbarItemWithIdentifier:[self identifierFromSelector:_cmd] inBundle:[iTM2TeXProjectInspector classBundle]];
	NSRect frame = NSMakeRect(0, 0, 32, 32);
	iTM2MixedButton * B = [[[iTM2MixedButton alloc] initWithFrame:frame] autorelease];
	[B setButtonType:NSMomentaryChangeButton];
//	[B setButtonType:NSOnOffButton];
	[B setImage:[toolbarItem image]];
	[B setImagePosition:NSImageOnly];
	[B setBezelStyle:NSShadowlessSquareBezelStyle];
//	[[B cell] setHighlightsBy:NSMomentaryChangeButton];
	[B setBordered:NO];
	[toolbarItem setView:B];
	[toolbarItem setMaxSize:frame.size];
	[toolbarItem setMinSize:frame.size];
	[B setTarget:nil];
	[[B cell] setBackgroundColor:[NSColor clearColor]];
	NSMenu * M = [[[NSMenu allocWithZone:[NSMenu menuZone]] initWithTitle:@""] autorelease];
	NSPopUpButton * PB = [[[NSPopUpButton allocWithZone:[self zone]] initWithFrame:NSZeroRect] autorelease];
	[PB setMenu:M];
	[PB setPullsDown:YES];
	[PB setAction:@selector(ConTeXtLabelAction:)];
	[[B cell] setPopUpCell:[PB cell]];
	return toolbarItem;
}
+ (NSToolbarItem *)ConTeXtSectionToolbarItem;
{
	NSToolbarItem * toolbarItem = [self toolbarItemWithIdentifier:[self identifierFromSelector:_cmd] inBundle:[iTM2TeXProjectInspector classBundle]];
	NSRect frame = NSMakeRect(0, 0, 32, 32);
	iTM2MixedButton * B = [[[iTM2MixedButton alloc] initWithFrame:frame] autorelease];
	[B setButtonType:NSMomentaryChangeButton];
//	[B setButtonType:NSOnOffButton];
	[B setImage:[toolbarItem image]];
	[B setImagePosition:NSImageOnly];
	[B setBezelStyle:NSShadowlessSquareBezelStyle];
//	[[B cell] setHighlightsBy:NSMomentaryChangeButton];
	[B setBordered:NO];
	[toolbarItem setView:B];
	[toolbarItem setMaxSize:frame.size];
	[toolbarItem setMinSize:frame.size];
	[B setTarget:nil];
	[[B cell] setBackgroundColor:[NSColor clearColor]];
	NSMenu * M = [[[NSMenu allocWithZone:[NSMenu menuZone]] initWithTitle:@""] autorelease];
	NSPopUpButton * PB = [[[NSPopUpButton allocWithZone:[self zone]] initWithFrame:NSZeroRect] autorelease];
	[PB setMenu:M];
	[PB setPullsDown:YES];
	[PB setAction:@selector(ConTeXtSectionAction:)];
	[[B cell] setPopUpCell:[PB cell]];
	return toolbarItem;
}
@end
#endif
///usr/local/teTeX/share/texmf.tetex/doc/context/
/*
This is for sherlock
*/