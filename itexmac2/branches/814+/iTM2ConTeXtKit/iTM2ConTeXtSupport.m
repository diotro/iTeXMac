/*
//  iTM2ConTeXtSupport.h
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

#import "iTM2ConTeXtSupport.h"
#import "iTM2ConTeXtPrefsKit.h"

NSString * const iTM2ConTeXtInspectorMode = @"ConTeXt Mode";
NSString * const iTM2ConTeXtToolbarIdentifier = @"iTM2 ConTeXt Inspector";
NSString * const iTM2ConTeXtManuals = @"iTM2 ConTeXt Manuals";
NSString * const iTM2ConTeXtManualsTable = @"iTM2ConTeXtManuals";

@interface NSMenu(iTM2ConTeXtSupport)
+ (NSMenu *)menuWithConTeXtGardenXMLElements:(NSArray *)elements;
@end

@implementation iTM2ConTeXtInspector
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inspectorMode
+ (NSString *)inspectorMode;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Sun Mar 14 17:30:25 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return iTM2ConTeXtInspectorMode;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= defaultMacroCategory
- (NSString *)defaultMacroCategory;
{
    return @"ConTeXt";
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= defaultMacroContext
- (NSString *)defaultMacroContext;
{
    return @"";
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= windowPositionShouldBeObserved4iTM3
- (BOOL)windowPositionShouldBeObserved4iTM3;
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Sun Mar 14 17:30:31 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= ConTeXtPragmaADEURL
+ (NSURL *)ConTeXtPragmaADEURL;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Sun Mar 14 17:33:25 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	static NSURL * URL = nil;
	if (!URL) {
		for (URL in [[NSBundle mainBundle] allURLsForResource4iTM3:@"ConTeXtURLs" withExtension:@"plist"]) {
			NSDictionary * D = [NSDictionary dictionaryWithContentsOfURL:URL];
			NSString * string = [D objectForKey:NSStringFromSelector(_cmd)];
			if (string) {
				return URL;
			}
		}
	}
//END4iTM3;
	return URL;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= ConTeXtGardenMainPageURL
+ (NSURL *)ConTeXtGardenMainPageURL;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	static NSURL * URL = nil;
	if (!URL) {
		for (URL in [[NSBundle mainBundle] allURLsForResource4iTM3:@"ConTeXtURLs" withExtension:@"plist"]) {
			NSDictionary * D = [NSDictionary dictionaryWithContentsOfURL:URL];
			NSString * string = [D objectForKey:NSStringFromSelector(_cmd)];
			if (string) {
				return URL;
			}
		}
	}
//END4iTM3;
	return URL;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= ConTeXtGardenPageURLWithRef:
+ (NSURL *)ConTeXtGardenPageURLWithRef:(NSString *)ref;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Sun Mar 14 17:35:44 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	for (NSURL * URL in [[NSBundle mainBundle] allURLsForResource4iTM3:@"ConTeXtURLs" withExtension:@"plist"]) {
		NSDictionary * D = [NSDictionary dictionaryWithContentsOfURL:URL];
		NSString * string = [D objectForKey:@"ConTeXtGardenURL"];
		if (string) {
			string = [string stringByAppendingPathComponent:ref];
			return [[[NSURL alloc] initWithString:string] autorelease];
		}
	}
//END4iTM3;
//	NSAssert(NO, @"ConTeXtURLs.plist is buggy!!!");
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  ConTeXtInspectorToolbarCompleteInstallation4iTM3
+ (void)ConTeXtInspectorToolbarCompleteInstallation4iTM3;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue May  3 16:20:26 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[SUD registerDefaults: [NSDictionary dictionaryWithObjectsAndKeys:
		[NSNumber numberWithBool:NO], @"iTM2ConTeXtToolbarAutosavesConfiguration",
		[NSNumber numberWithBool:YES], @"iTM2ConTeXtToolbarShareConfiguration",
			nil]];
//END4iTM3;
	return;
}
@end

#define DEFINE_TOOLBAR_ITEM(SELECTOR)\
+ (NSToolbarItem *)SELECTOR;{return [self toolbarItemWithIdentifier4iTM3:[self identifierFromSelector4iTM3:_cmd] inBundle:[iTM2ConTeXtInspector classBundle4iTM3]];}

@implementation NSToolbarItem(iTM2ConTeXt)
DEFINE_TOOLBAR_ITEM(ConTeXtSectionToolbarItem)
DEFINE_TOOLBAR_ITEM(ConTeXtLabelToolbarItem)
DEFINE_TOOLBAR_ITEM(ConTeXtAtPragmaADEToolbarItem)
DEFINE_TOOLBAR_ITEM(ConTeXtPragmaADEToolbarItem)
+ (NSToolbarItem *)ConTeXtAtGardenToolbarItem;
{
	NSToolbarItem * toolbarItem = [self toolbarItemWithIdentifier4iTM3:[self identifierFromSelector4iTM3:_cmd] inBundle:[iTM2ConTeXtInspector classBundle4iTM3]];
	NSRect frame = NSMakeRect(0, 0, 32, 32);
	iTM2MixedButton * B = [[[iTM2MixedButton alloc] initWithFrame:frame] autorelease];
	[B setButtonType:NSMomentaryChangeButton];
//	[B setButtonType:NSOnOffButton];
	B.image = toolbarItem.image;
	[B setImagePosition:NSImageOnly];
	B.action = @selector(ConTeXtAtGarden:);
	[B setBezelStyle:NSShadowlessSquareBezelStyle];
//	[. setHighlightsBy:NSMomentaryChangeButton];
	[B setBordered:NO];
	toolbarItem.view = B;
	toolbarItem.maxSize = toolbarItem.minSize = frame.size;
	B.target = nil;
	[B.cell setBackgroundColor:[NSColor clearColor]];
	NSURL * url = [[[[NSBundle mainBundle] allURLsForResource4iTM3:@"iTM2ConTeXtGardenMainPageAbstract" withExtension:@"xml"] objectEnumerator] nextObject];
	if (url.isFileURL) {
		NSXMLDocument * document = [[NSXMLDocument alloc] initWithContentsOfURL:url options:0 error:nil];
		NSMenu * M = [NSMenu menuWithConTeXtGardenXMLElements:[[document rootElement] children]];
		[M insertItem:[[NSMenuItem alloc] initWithTitle:@"COUCOU" action:NULL keyEquivalent:@""] atIndex:0];
		NSPopUpButton * PB = [[NSPopUpButton alloc] initWithFrame:NSZeroRect];
		[PB setMenu:M];
		[PB setPullsDown:YES];
		[B.cell setPopUpCell:PB.cell];
	} else {
		LOG4iTM3(@"MIssing iTM2ConTeXtGardenMainPageAbstract.xml");
	}
	return toolbarItem;
}
+ (NSToolbarItem *)ConTeXtManualsToolbarItem;
{
	NSToolbarItem * toolbarItem = [self toolbarItemWithIdentifier4iTM3:[self identifierFromSelector4iTM3:_cmd] inBundle:[iTM2ConTeXtInspector classBundle4iTM3]];
	NSRect frame = NSMakeRect(0, 0, 32, 32);
	iTM2MixedButton * B = [[[iTM2MixedButton alloc] initWithFrame:frame] autorelease];
	[B setButtonType:NSMomentaryChangeButton];
//	[B setButtonType:NSOnOffButton];
	B.image = toolbarItem.image;
	[B setImagePosition:NSImageOnly];
	B.action = @selector(ConTeXtManuals:);
	[B setBezelStyle:NSShadowlessSquareBezelStyle];
//	[B.cell setHighlightsBy:NSMomentaryChangeButton];
	[B setBordered:NO];
	toolbarItem.view = B;
	toolbarItem.maxSize = toolbarItem.minSize = frame.size;
	B.target = nil;
	[B.cell setBackgroundColor:[NSColor clearColor]];
	NSMenu * M = [[[NSMenu alloc] initWithTitle:@""] autorelease];
	NSPopUpButton * PB = [[[NSPopUpButton alloc] initWithFrame:NSZeroRect] autorelease];
	[PB setMenu:M];
	[PB setPullsDown:YES];
	[B.cell setPopUpCell:PB.cell];
	return toolbarItem;
}
@end

@implementation iTM2ConTeXtInspector(Toolbar)
#pragma mark =-=-=-=-=-  TOOLBAR
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setupToolbarWindowDidLoad4iTM3
- (void)setupToolbarWindowDidLoad4iTM3;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Sun Mar 14 17:39:40 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSToolbar * toolbar = [[[NSToolbar alloc] initWithIdentifier:iTM2ConTeXtToolbarIdentifier] autorelease];
	NSString * key = [NSString stringWithFormat:@"NSToolbar Configuration %@", [toolbar identifier]];
	if ([self contextBoolForKey:@"iTM2ConTeXtToolbarShareConfiguration" domain:iTM2ContextAllDomainsMask]) {
		NSDictionary * configDictionary = [SUD dictionaryForKey:key];
		if (configDictionary.count) {
			[toolbar setConfigurationFromDictionary:configDictionary];
			if (!toolbar.items.count) {
				[SUD removeObjectForKey:key];
				toolbar = [[[NSToolbar alloc] initWithIdentifier:iTM2ConTeXtToolbarIdentifier] autorelease];
			}
		}
	} else {
		NSDictionary * configDictionary = [SUD dictionaryForKey:key];
//LOG4iTM3(@"configDictionary: %@", configDictionary);
		configDictionary = [self contextDictionaryForKey:key domain:iTM2ContextAllDomainsMask];
//LOG4iTM3(@"configDictionary: %@", configDictionary);
		if (configDictionary.count)
			[toolbar setConfigurationFromDictionary:configDictionary];
		if (!toolbar.items.count) {
			configDictionary = [SUD dictionaryForKey:key];
//LOG4iTM3(@"configDictionary: %@", configDictionary);
			[self takeContextValue:nil forKey:key domain:iTM2ContextAllDomainsMask];
			if (configDictionary.count)
				[toolbar setConfigurationFromDictionary:configDictionary];
			if (!toolbar.items.count) {
				[SUD removeObjectForKey:key];
				toolbar = [[[NSToolbar alloc] initWithIdentifier:iTM2ConTeXtToolbarIdentifier] autorelease];
			}
		}
	}
	[toolbar setAutosavesConfiguration:YES];
    [toolbar setAllowsUserCustomization:YES];
//    [toolbar setSizeMode:NSToolbarSizeModeSmall];
    toolbar.delegate = self;
    [self.window setToolbar:toolbar];
//END4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleShareToolbarConfiguration:
- (void)toggleShareToolbarConfiguration:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Sun Mar 14 17:40:44 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	BOOL old = [self contextBoolForKey:@"iTM2ConTeXtToolbarShareConfiguration" domain:iTM2ContextAllDomainsMask];
	[self takeContextBool: !old forKey:@"iTM2ConTeXtToolbarShareConfiguration" domain:iTM2ContextAllDomainsMask];
	self.validateWindowContent4iTM3;
//END4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleShareToolbarConfiguration:
- (BOOL)validateToggleShareToolbarConfiguration:(NSButton *)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Sun Mar 14 17:40:50 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	sender.state = ([self contextBoolForKey:@"iTM2ConTeXtToolbarShareConfiguration" domain:iTM2ContextAllDomainsMask]? NSOnState:NSOffState);
//END4iTM3;
	return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  prepareToolbarConfigurationCompleteSaveContext4iTM3:
- (void)prepareToolbarConfigurationCompleteSaveContext4iTM3:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Sun Mar 14 17:40:56 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if ([self contextBoolForKey:@"iTM2ConTeXtToolbarAutosavesConfiguration" domain:iTM2ContextAllDomainsMask]) {
		NSToolbar * toolbar = self.window.toolbar;
		NSString * key = [NSString stringWithFormat:@"NSToolbar Configuration %@", toolbar.identifier];
		[self takeContextValue:toolbar.configurationDictionary forKey:key domain:iTM2ContextAllDomainsMask];
	}
//END4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toolbarDefaultItemIdentifiers:
- (NSArray *)toolbarDefaultItemIdentifiers:(NSToolbar *)toolbar;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Sun Mar 14 17:46:48 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    // Required delegate method:  Returns the ordered list of items to be shown in the toolbar by default    
    // If during the toolbar's initialization, no overriding values are found in the usermodel, or if the
    // user chooses to revert to the default items this set will be used 
//END4iTM3;
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
Latest Revision: Sun Mar 14 17:46:44 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    // Required delegate method:  Returns the list of all allowed items by identifier.  By default, the toolbar 
    // does not assume any items are allowed, even the separator.  So, every allowed item must be explicitly listed   
    // The set of allowed items is used to construct the customization palette 
//END4iTM3;
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
Latest Revision: Sun Mar 14 17:46:40 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[NSApp showConTeXtManualsPrefs:self];
//END4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  ConTeXtManualsWillPopUp:
- (BOOL)ConTeXtManualsWillPopUp:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Sun Mar 14 17:46:35 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSMenu * M = [[[NSMenu alloc] initWithTitle:@""] autorelease];
	[M addItemWithTitle:@"" action:NULL keyEquivalent:@""];// first item is used as title
	for (NSString * URLString in [SUD stringArrayForKey:iTM2ConTeXtManuals]) {
        NSURL * url = [NSURL URLWithString:URLString];
		NSString * key = url.lastPathComponent.stringByDeletingPathExtension;
		NSString * title = NSLocalizedStringFromTableInBundle(key, iTM2ConTeXtManualsTable, self.classBundle4iTM3, "");
		NSMenuItem * MI = [[[NSMenuItem alloc] initWithTitle: title
						action: @selector(openConTeXtManualFromRepresentedObject:) keyEquivalent: @""] autorelease];
		[M addItem:MI];
		MI.target = nil;
		MI.representedObject = url;
	}
	if(M.numberOfItems > 1)
		[M addItem:[NSMenuItem separatorItem]];
	NSString * title = NSLocalizedStringFromTableInBundle(@"showConTeXtManualsPrefs", iTM2ConTeXtManualsTable, self.classBundle4iTM3, "");
	NSMenuItem * MI = [[[NSMenuItem alloc] initWithTitle: title
					action: @selector(showConTeXtManualsPrefs:) keyEquivalent: @""] autorelease];
	[M addItem:MI];
	MI.target = nil;
	[[sender popUpCell] setMenu:M];
	return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  openConTeXtManualFromRepresentedObject:
- (IBAction)openConTeXtManualFromRepresentedObject:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Sun Mar 14 17:46:30 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSURL * url = [sender representedObject];
	[SPC setProject:nil forURL:url];
	if([SDC openDocumentWithContentsOfURL:url display:YES error:nil])
		return;
	for (url in [[NSBundle mainBundle] allURLsForResource4iTM3:url.lastPathComponent.stringByDeletingPathExtension
            withExtension:url.pathExtension subdirectory:@"Documentation/ConTeXt"]) {
		[SPC setProject:nil forURL:url];
		if([SDC openDocumentWithContentsOfURL:url display:YES error:nil])
			return;
	}
	[NSApp showConTeXtManualsPrefs:self];
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= ConTeXtAtGarden:
- (IBAction)ConTeXtAtGarden:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Sun Mar 14 17:46:58 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[SWS openURL:[self.class ConTeXtGardenMainPageURL]];
//END4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  ConTeXtAtGardenFromRepresentedURL:
- (IBAction)ConTeXtAtGardenFromRepresentedURL:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Sun Mar 14 17:47:02 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSURL * URL = [sender representedObject];
	if ([URL isKindOfClass:[NSURL class]]) {
		[SWS openURL:URL];
	}
//END4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= ConTeXtAtPragmaADE:
- (IBAction)ConTeXtAtPragmaADE:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Sun Mar 14 17:47:45 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[SWS openURL:[self.class ConTeXtPragmaADEURL]];
//END4iTM3;
	return;
}
@end

@implementation iTM2ConTeXtSectionButton
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= awakeFromNib
- (void)awakeFromNib;
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Sun Mar 14 17:47:51 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[super awakeFromNib];
	self.action = @selector(ConTeXtSectionButtonAction:);
	[self performSelector:@selector(initMenu) withObject:nil afterDelay:0.01];
	[DNC removeObserver: self
		name: NSPopUpButtonWillPopUpNotification
			object: self];
	[DNC addObserver: self
		selector: @selector(popUpButtonWillPopUpNotified:)
			name: NSPopUpButtonWillPopUpNotification
				object: self];
	NSView * superview = self.superview;
	self.removeFromSuperviewWithoutNeedingDisplay;
	[superview addSubview:self];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  popUpButtonWillPopUpNotified:
- (void)popUpButtonWillPopUpNotified:(NSNotification *)notification;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Sun Mar 14 17:48:05 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSMenu * M = [[self.window.windowController textStorage] ConTeXtSectionMenu];
	NSAssert(M, @"Missing ConTeXt menu: inconsistency");
	NSMenuItem * MI = [self.menu deepItemWithRepresentedObject4iTM3:@"ConTeXt Section Menu"];
	if (MI) {
		[MI.menu setSubmenu: (M.numberOfItems? M:nil) forItem:MI];
	} else if((MI = [self.menu deepItemWithAction4iTM3:@selector(gotoConTeXtSection:)])) {
		MI.action = NULL;
		MI.representedObject = @"ConTeXt Section Menu";
		[MI.menu setSubmenu: (M.numberOfItems? M:nil) forItem:MI];
	}
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= initMenu
- (void)initMenu;
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Sun Mar 14 17:51:38 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSView * owner = [[[NSView alloc] initWithFrame:NSZeroRect] autorelease];
	NSDictionary * context = [NSDictionary dictionaryWithObject:owner forKey:@"NSOwner"];
	Class class = self.class;
    while (YES) {
        NSURL * fileURL = [[NSBundle bundleForClass:class] URLForResource:@"iTM2ConTeXtSectionMenu" withExtension:@"nib"];
        if (fileURL.isFileURL) {
            NSString * title = self.title;
            if ([NSBundle loadNibFile:fileURL.path externalNameTable:context withZone:self.zone]) {
                NSMenu * M = owner.menu;
                [owner setMenu:nil];
                if (M.numberOfItems) {
                    for (NSMenuItem * MI in M.itemArray) {
                        SEL action = MI.action;
                        if (action) {
                            if ([NSStringFromSelector(action) hasPrefix:@"insert"]) {
                                if(![MI indentationLevel])
                                    MI.indentationLevel = 1;
                            }
                        }
                    }
                    [[M itemAtIndex:0] setTitle:title];
                    self.title = title;// will raise if the menu is void
                    [self setMenu:M];
                } else {
                    LOG4iTM3(@"..........  ERROR: Inconsistent file (Void menu) at %@", fileURL);
                }
            } else {
                LOG4iTM3(@"..........  ERROR: Corrupted file at %@", fileURL);
            }
        } else {
            Class superclass = [class superclass];
            if ((superclass) && (superclass != class)) {
                class = superclass;
                continue;
            }
        }
        break;
    }
//END4iTM3;
    return;
}
@end

@implementation iTM2ConTeXtLabelButton
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= awakeFromNib
- (void)awakeFromNib;
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Sun Mar 14 17:51:44 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[super awakeFromNib];
	self.action = @selector(ConTeXtLabelButtonAction:);
	[self performSelector:@selector(initMenu) withObject:nil afterDelay:0.01];
	[DNC removeObserver: self
		name: NSPopUpButtonWillPopUpNotification
			object: self];
	[DNC addObserver: self
		selector: @selector(popUpButtonWillPopUpNotified:)
			name: NSPopUpButtonWillPopUpNotification
				object: self];
	NSView * superview = self.superview;
	self.removeFromSuperviewWithoutNeedingDisplay;
	[superview addSubview:self];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= initMenu
- (void)initMenu;
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Sun Mar 14 17:52:07 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSView * owner = [[[NSView alloc] initWithFrame:NSZeroRect] autorelease];
	NSDictionary * context = [NSDictionary dictionaryWithObject:owner forKey:@"NSOwner"];
	Class class = self.class;
    while (YES) {
        NSURL * fileURL = [[NSBundle bundleForClass:class] URLForResource:@"iTM2ConTeXtLabelMenu" withExtension:@"nib"];
        if (fileURL.isFileURL) {
            NSString * title = self.title;
            if ([NSBundle loadNibFile:fileURL.path externalNameTable:context withZone:self.zone]) {
                NSMenu * M = owner.menu;
                [owner setMenu:nil];
                if (M.numberOfItems) {
                    for (NSMenuItem * MI in M.itemArray) {
                        SEL action = MI.action;
                        if (action) {
                            NSString * actionName = NSStringFromSelector(action);
                            if ([actionName hasPrefix:@"insert"] || [actionName hasPrefix:@"goto"]) {
                                if(![MI indentationLevel])
                                    MI.indentationLevel = 1;
                            }
                        }
                    }
                    [[M itemAtIndex:0] setTitle:title];
                    self.title = title;// will raise if the menu is void
                    [self setMenu:M];
                } else {
                    LOG4iTM3(@"..........  ERROR: Inconsistent file (Void menu) at %@", fileURL);
                }
            } else {
                LOG4iTM3(@"..........  ERROR: Corrupted file at %@", fileURL);
            }
        } else {
            Class superclass = [class superclass];
            if ((superclass) && (superclass != class)) {
                class = superclass;
                continue;
            }
        }
        break;
    }
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  popUpButtonWillPopUpNotified:
- (void)popUpButtonWillPopUpNotified:(NSNotification *)notification;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Sun Mar 14 17:55:33 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSMenu * labelMenu = nil;
	NSMenu * refMenu = nil;
	[[self.window.windowController textStorage] getConTeXtLabelMenu: &labelMenu refMenu: &refMenu];
	NSAssert(labelMenu, @"Missing ConTeXt label menu: inconsistency");
	NSAssert(refMenu, @"Missing ConTeXt ref menu: inconsistency");
	NSMenuItem * MI = [self.menu deepItemWithAction4iTM3:@selector(gotoConTeXtLabel:)];
	if (MI) {
		MI.action = NULL;
		MI.representedObject = @"ConTeXt Label Menu";
		[MI.menu setSubmenu: (labelMenu.numberOfItems? labelMenu:nil) forItem:MI];
	} else if (MI = [self.menu deepItemWithRepresentedObject4iTM3:@"ConTeXt Label Menu"]) {
		[MI.menu setSubmenu: (labelMenu.numberOfItems? labelMenu:nil) forItem:MI];
	}
	if(MI = [self.menu deepItemWithAction4iTM3:@selector(gotoConTeXtReference:)]) {
		MI.action = NULL;
		MI.representedObject = @"ConTeXt Reference Menu";
		[MI.menu setSubmenu: (refMenu.numberOfItems? refMenu:nil) forItem:MI];
	} else if(MI = [self.menu deepItemWithRepresentedObject4iTM3:@"ConTeXt Reference Menu"]) {
		[MI.menu setSubmenu: (refMenu.numberOfItems? refMenu:nil) forItem:MI];
	}
	for (MI in labelMenu.itemArray)
		if(MI.action == @selector(scrollConTeXtLabelToVisible:))
			MI.action = @selector(_insertConTeXtKnownReference:);
	if (MI = [self.menu deepItemWithAction4iTM3:@selector(insertConTeXtKnownReference:)]) {
		MI.action = NULL;
		MI.representedObject = @"ConTeXt Known Reference Menu";
		[MI.menu setSubmenu: (labelMenu.numberOfItems? labelMenu:nil) forItem:MI];
	} else if(MI = [self.menu deepItemWithRepresentedObject4iTM3:@"ConTeXt Known Reference Menu"]) {
		[MI.menu setSubmenu: (labelMenu.numberOfItems? labelMenu:nil) forItem:MI];
	}
//END4iTM3;
    return;
}
@end

#define TABLE @"iTM2InsertConTeXt"

@implementation iTM2ConTeXtEditor
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= clickedOnLink:atIndex:
- (void)clickedOnLink:(id)link atIndex:(NSUInteger)charIndex;
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSTextStorage * TS = self.textStorage;
    iTM2StringController * SC = self.stringController4iTM3;
	NSRange R = [SC TeXAwareWordRangeInAttributedString:TS atIndex:charIndex];
	if(R.length<2)
		return;
	++R.location;
	--R.length;
	NSString * S = TS.string;
	NSString * command = [S substringWithRange:R];
    ICURegEx * RE = [self ICURegExForKey4iTM3:command error:NULL];
    R.length = S.length - R.location;
    [RE setInputString:S range:R];
    S = nil;
    if ([RE nextMatch]) {
        S = [RE substringOfCaptureGroupWithName:@"url"];
        if (S.length) {
            S = [SC stringByRemovingTeXEscapeSequencesInString:S];
            if(![SWS openURL:[NSURL URLWithString:S]]) {
                LOG4iTM3(@"INFO: could not open url <%@>", S);
            }
            RE.forget;
            return;
        }
        S = [RE substringOfCaptureGroupWithName:@"name"];
        if (S.length) {
            S = [SC stringByRemovingTeXEscapeSequencesInString:S];
            #warning CONTINUE HERE
            RE.forget;
            return;
        }
        
    }
    //  to be continued
#warning THIS IS NOT COMPLETE
	if ([command isEqualToString:@"include"]) {
		NSUInteger start = iTM3MaxRange(R);
		if (start < S.length) {
			NSUInteger contentsEnd, TeXComment;
			[S getLineStart:nil end:nil contentsEnd: &contentsEnd TeXComment: &TeXComment forIndex:start];
			NSString * string = [S substringWithRange:
				iTM3MakeRange(start, (TeXComment == NSNotFound? contentsEnd: TeXComment) - start)];
			NSScanner * scanner = [NSScanner scannerWithString:string];
			[scanner scanString:@"{" intoString:nil];
			NSString * fileName;
			if ([scanner scanCharactersFromSet:[NSCharacterSet TeXFileNameLetterCharacterSet4iTM3] intoString: &fileName]) {
				if(![fileName hasPrefix:@"/"])
				{
					fileName = [[[[self.window.windowController document] fileName] stringByDeletingLastPathComponent] stringByAppendingPathComponent:fileName];
				}
				if(![SWS openFile:fileName])
				{
					fileName = [fileName stringByAppendingPathExtension:@"tex"];
					if(![SWS openFile:fileName])
					{
						LOG4iTM3(@"INFO: could not open file <%@>", fileName);
					}				
				}
			}
			return;
		}
	}
	else if([command isEqualToString:@"includegraphics"])
	{
		NSUInteger start = iTM3MaxRange(R);
		if(start < S.length)
		{
			NSUInteger contentsEnd, TeXComment;
			[S getLineStart:nil end:nil contentsEnd: &contentsEnd TeXComment: &TeXComment forIndex:start];
			NSString * string = [S substringWithRange:
				iTM3MakeRange(start, (TeXComment == NSNotFound? contentsEnd: TeXComment) - start)];
			NSScanner * scanner = [NSScanner scannerWithString:string];
			[scanner scanString:@"{" intoString:nil];
			NSString * fileName;
			if([scanner scanCharactersFromSet:[NSCharacterSet TeXFileNameLetterCharacterSet4iTM3] intoString: &fileName])
			{
				if(![fileName hasPrefix:@"/"])
				{
					fileName = [[[[self.window.windowController document] fileName] stringByDeletingLastPathComponent] stringByAppendingPathComponent:fileName];
				}
				if(![SWS openFile:fileName])
				{
					fileName = [fileName stringByAppendingPathExtension:@"tex"];
					if(![SWS openFile:fileName])
					{
						LOG4iTM3(@"INFO: could not open file <%@>", fileName);
					}				
				}
			}
			return;
		}
	}
	else if([command isEqualToString:@"url"])
	{
		NSUInteger start = iTM3MaxRange(R);
		if(start < S.length)
		{
			NSUInteger contentsEnd, TeXComment;
			[S getLineStart:nil end:nil contentsEnd: &contentsEnd TeXComment: &TeXComment forIndex:start];
			NSString * string = [S substringWithRange:
				iTM3MakeRange(start, (TeXComment == NSNotFound? contentsEnd: TeXComment) - start)];
			NSScanner * scanner = [NSScanner scannerWithString:string];
			[scanner scanString:@"{" intoString:nil];
			NSString * URLString;
			if ([scanner scanCharactersFromSet:[NSCharacterSet TeXFileNameLetterCharacterSet4iTM3] intoString: &URLString]) {
				if(URLString.length && ![SWS openURL:[NSURL URLWithString:URLString]]) {
					LOG4iTM3(@"INFO: could not open url <%@>", URLString);
				}
			}
			return;
		}
	}
	[super clickedOnLink:link atIndex:charIndex];
//END4iTM3;
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[self insertMacro: NSLocalizedStringWithDefaultValue(NSStringFromSelector(_cmd),
		TABLE, myBUNDLE, @"\\label{__(a label identifier)__}", "Inserting a  macro")];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateInsertConTeXtLabel:
- (BOOL)validateInsertConTeXtLabel:(id)sender; 
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  gotoConTeXtLabel:
- (IBAction)gotoConTeXtLabel:(NSControl *)sender; 
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSInteger tag = sender.tag;
	NSString * S = [self.textStorage string];
	if (tag>=0 && tag<S.length) {
		NSUInteger begin, end;
		[S getLineStart: &begin end: &end contentsEnd:nil forRange:iTM3MakeRange(tag, 0)];
		[self highlightAndScrollToVisibleRange:iTM3MakeRange(begin, end-begin)];
	}
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateGotoConTeXtLabel:
- (BOOL)validateGotoConTeXtLabel:(id)sender; 
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertConTeXtReference:
- (IBAction)insertConTeXtReference:(id)sender; 
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[self insertMacro: NSLocalizedStringWithDefaultValue(NSStringFromSelector(_cmd),
		TABLE, myBUNDLE, @"\\ref{__(a labeled identifier)__}", "Inserting a  macro")];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateInsertConTeXtReference:
- (BOOL)validateInsertConTeXtReference:(id)sender; 
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  gotoConTeXtReference:
- (IBAction)gotoConTeXtReference:(id)sender; 
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateGotoConTeXtReference:
- (BOOL)validateGotoConTeXtReference:(id)sender; 
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertConTeXtEquationReference:
- (IBAction)insertConTeXtEquationReference:(id)sender; 
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[self insertMacro: NSLocalizedStringWithDefaultValue(NSStringFromSelector(_cmd),
		TABLE, myBUNDLE, @"\\eqref{__(a labeled identifier)__}", "Inserting a  macro")];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateInsertConTeXtEquationReference:
- (BOOL)validateInsertConTeXtEquationReference:(id)sender; 
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  gotoConTeXtEquationReference:
- (IBAction)gotoConTeXtEquationReference:(id)sender; 
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateGotoConTeXtEquationReference:
- (BOOL)validateGotoConTeXtEquationReference:(id)sender; 
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  _insertConTeXtKnownReference:
- (IBAction)_insertConTeXtKnownReference:(id)sender; 
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[self insertMacro:[NSString stringWithFormat:@"\\ref{%@}__(SEL)__", [sender representedObject]]];
//END4iTM3;
    return;
}
#pragma mark -
#pragma mark =-=-=-=-=-  SECTIONS
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  gotoConTeXtSection:
- (IBAction)gotoConTeXtSection:(NSControl *)sender; 
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSInteger tag = sender.tag;
	NSString * S = [self.textStorage string];
	if(tag>=0 && tag<S.length)
	{
		NSUInteger begin, end;
		[S getLineStart: &begin end: &end contentsEnd:nil forRange:iTM3MakeRange(tag, 0)];
		[self highlightAndScrollToVisibleRange:iTM3MakeRange(begin, end-begin)];
	}
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateGotoConTeXtSection:
- (BOOL)validateGotoConTeXtSection:(id)sender; 
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertConTeXtChapter:
- (IBAction)insertConTeXtChapter:(id)sender; 
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[self insertMacro: NSLocalizedStringWithDefaultValue(NSStringFromSelector(_cmd),
		TABLE, myBUNDLE, @"\\chapter{__(a labeled identifier)__}", "Inserting a  macro")];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateInsertConTeXtChapter:
- (BOOL)validateInsertConTeXtChapter:(id)sender; 
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertConTeXtPart:
- (IBAction)insertConTeXtPart:(id)sender; 
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[self insertMacro: NSLocalizedStringWithDefaultValue(NSStringFromSelector(_cmd),
		TABLE, myBUNDLE, @"\\part{__(a labeled identifier)__}", "Inserting a  macro")];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateInsertConTeXtPart:
- (BOOL)validateInsertConTeXtPart:(id)sender; 
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertConTeXtSection:
- (IBAction)insertConTeXtSection:(id)sender; 
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[self insertMacro: NSLocalizedStringWithDefaultValue(NSStringFromSelector(_cmd),
		TABLE, myBUNDLE, @"\\section{__(a labeled identifier)__}", "Inserting a  macro")];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateInsertConTeXtSection:
- (BOOL)validateInsertConTeXtSection:(id)sender; 
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertConTeXtSubSection:
- (IBAction)insertConTeXtSubSection:(id)sender; 
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[self insertMacro: NSLocalizedStringWithDefaultValue(NSStringFromSelector(_cmd),
		TABLE, myBUNDLE, @"\\subsection{__(a labeled identifier)__}", "Inserting a  macro")];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateInsertConTeXtSubSection:
- (BOOL)validateInsertConTeXtSubSection:(id)sender; 
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertConTeXtSubSubSection:
- (IBAction)insertConTeXtSubSubSection:(id)sender; 
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[self insertMacro: NSLocalizedStringWithDefaultValue(NSStringFromSelector(_cmd),
		TABLE, myBUNDLE, @"\\subsusection{__(a labeled identifier)__}", "Inserting a  macro")];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateInsertConTeXtSubSubSection:
- (BOOL)validateInsertConTeXtSubSubSection:(id)sender; 
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertConTeXtTitle:
- (IBAction)insertConTeXtTitle:(id)sender; 
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[self insertMacro: NSLocalizedStringWithDefaultValue(NSStringFromSelector(_cmd),
		TABLE, myBUNDLE, @"\\title{__(a labeled identifier)__}", "Inserting a  macro")];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateInsertConTeXtTitle:
- (BOOL)validateInsertConTeXtTitle:(id)sender; 
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertConTeXtSubject:
- (IBAction)insertConTeXtSubject:(id)sender; 
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[self insertMacro: NSLocalizedStringWithDefaultValue(NSStringFromSelector(_cmd),
		TABLE, myBUNDLE, @"\\subject{__(a labeled identifier)__}", "Inserting a  macro")];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateInsertConTeXtSubject:
- (BOOL)validateInsertConTeXtSubject:(id)sender; 
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertConTeXtSubSubject:
- (IBAction)insertConTeXtSubSubject:(id)sender; 
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[self insertMacro: NSLocalizedStringWithDefaultValue(NSStringFromSelector(_cmd),
		TABLE, myBUNDLE, @"\\subsubject{__(a labeled identifier)__}", "Inserting a  macro")];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateInsertConTeXtSubSubject:
- (BOOL)validateInsertConTeXtSubSubject:(id)sender; 
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertConTeXtSubSubSubject:
- (IBAction)insertConTeXtSubSubSubject:(id)sender; 
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[self insertMacro: NSLocalizedStringWithDefaultValue(NSStringFromSelector(_cmd),
		TABLE, myBUNDLE, @"\\subsubsubject{__(a labeled identifier)__}", "Inserting a  macro")];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateInsertConTeXtSubSubSubject:
- (BOOL)validateInsertConTeXtSubSubSubject:(id)sender; 
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  scrollConTeXtLabelToVisible:
- (void)scrollConTeXtLabelToVisible:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[self scrollTaggedAndRepresentedStringToVisible:sender];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  scrollConTeXtReferenceToVisible:
- (void)scrollConTeXtReferenceToVisible:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[self scrollTaggedAndRepresentedStringToVisible:sender];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  scrollIncludeToVisible:
- (void)scrollIncludeToVisible:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[self performSelector:@selector(delayedScrollIncludeToVisible:) withObject:sender afterDelay:0.1];
	#if 0
    [NSInvocation delayInvocationWithTarget: self
        action: @selector(_ScrollIncludeToVisible:)
            sender: sender
                untilNotificationWithName: @"iTM2TDPerformScrollIn[clude|put]ToVisible"
                    isPostedFromObject: self];
	#endif
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  delayedScrollIncludeToVisible:
- (void)delayedScrollIncludeToVisible:(NSMenuItem *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSString * path = [[sender.menu.title  stringByAppendingPathComponent:
                                sender.representedObject] stringByStandardizingPath];
    if([DFM isReadableFileAtPath:path])
        [SDC openDocumentWithContentsOfURL:[NSURL fileURLWithPath:path] display:YES error:nil];
    else {
        NSString * P = [path stringByAppendingPathExtension:@"tex"];
        if([DFM isReadableFileAtPath:P])
            [SDC openDocumentWithContentsOfURL:[NSURL fileURLWithPath:P] display:YES error:nil];
        else {
            [sender setEnabled:NO];
            NSBeep();
            [self postNotificationWithStatus4iTM3:
                [NSString stringWithFormat:  NSLocalizedStringFromTableInBundle(@"No file at path: %@", @"TeX",
                            [NSBundle bundleForClass:self.class], "Could not complete the \\include action... 1 line only"), path]]; 
        }
    }
//END4iTM3;
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

#define _TextStorage (iTM2TextStorage *)iVarTS4iTM3

@implementation NSTextStorage(ConTeXt)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  ConTeXtSectionMenu
- (NSMenu *)ConTeXtSectionMenu;
/*"Description forthcoming. No consistency test.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{
//START4iTM3;
    BOOL withGraphics = ([[NSApp currentEvent] modifierFlags] & NSAlternateKeyMask)!=0;
    NSMenu * sectionMenu = [[[NSMenu alloc] initWithTitle:@""] autorelease];
    NSString * S = self.string;
    iTM2LiteScanner * scan = [iTM2LiteScanner scannerWithString:S charactersToBeSkipped:[NSCharacterSet whitespaceCharacterSet]];
    NSUInteger scanLocation = 0, end = S.length;
    NSUInteger sectionCount = 0, subsectionCount = 0, subsubsectionCount = 0;
    next:
    if (scanLocation < end) {
        NSInteger depth = 0;
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
                NSRange R1 = iTM3MakeRange(0, 0);
                if(theChar == 's')
                {
                    if(++scanLocation < end)
                    {
                        NSRange searchRange = iTM3MakeRange(scanLocation, end-scanLocation);
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
                            R1 = iTM3MakeRange(scanLocation, end-scanLocation);
                            NSRange R2 = [S rangeOfString:@"put" options:NSAnchoredSearch range:R1];
                            if(R2.length)
                            {
//NSLog(@"1");
                                [S getLineStart:nil end:nil contentsEnd: &scanLocation forRange:R2];
//NSLog(@"1");
                                [scan setScanLocation:iTM3MaxRange(R2)];
                                [scan scanString:@"{" intoString:nil];
                                NSString * object;
                                if([scan scanUpToString:@"}" intoString: &object beforeIndex:scanLocation] ||
                                    [scan scanCharactersFromSet:[[NSCharacterSet whitespaceAndNewlineCharacterSet] invertedSet]
                                        intoString: &object beforeIndex: scanLocation])
                                {
                                    object = [object stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];                            
                                    NSString * title = [NSString stringWithFormat:@"input: %@", object];
                                    title = (title.length > 48)?
                                                    [NSString stringWithFormat:@"%@[...]",
                                                            [title substringWithRange:iTM3MakeRange(0,43)]]: title;
                                    if(title.length)
                                    {
                                        NSMenuItem * MI = [sectionMenu addItemWithTitle: title
                                                                action: @selector(scrollInputToVisible:)
                                                                    keyEquivalent: [NSString string]];
                                        MI.representedObject = object;
                                        [MI setEnabled: (sectionMenu.title.length > 0)];
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
                                            scanLocation = iTM3MaxRange(R2);
                                        }
                                        else if(R2 = [S rangeOfString:@"graphicx" options:NSAnchoredSearch range:R1], R2.length)
                                        {
                                            selector = @selector(scrollTaggedToVisible:);
//                                                selector = @selector(scrollIncludeGraphicToVisible:);
                                            prefix = @"includegraphicx";// Localize???
                                            scanLocation = iTM3MaxRange(R2);
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
                                    NSUInteger contentsEnd;
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
                                            title = (title.length > 48)?
                                                            [NSString stringWithFormat:@"%@[...]",
                                                                    [title substringWithRange:iTM3MakeRange(0,43)]]: title;
                                            if(!title.length)
                                                title = @"?";
                                            NSMenuItem * MI = [sectionMenu addItemWithTitle: title
                                                                    action: selector keyEquivalent: [NSString string]];
                                            MI.tag = scanLocation;
                                            MI.representedObject = object;
                                            [MI setEnabled: (sectionMenu.title.length > 0)];
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
                        NSRange searchRange = iTM3MakeRange(scanLocation, end-scanLocation);
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
                        NSRange searchRange = iTM3MakeRange(scanLocation, end-scanLocation);
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
                NSUInteger contentsEnd;
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
                        if(!object.length)
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
                        title = (title.length > 48)?
                                        [NSString stringWithFormat:@"%@[...]",
                                                [title substringWithRange:iTM3MakeRange(0,43)]]: title;
                        if(!title.length)
                            title = @"?";
                        NSMenuItem * MI = [sectionMenu addItemWithTitle: title
                                                action: @selector(scrollTaggedToVisible:) keyEquivalent: [NSString string]];
                        MI.tag = scanLocation;
                        MI.representedObject = object;
                        [MI setEnabled: (sectionMenu.title.length > 0)];
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
//END4iTM3;
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
//START4iTM3;
    NSMenu * labelMenu = [[[NSMenu alloc] initWithTitle:@""] autorelease];
    NSMenu * refMenu = [[[NSMenu alloc] initWithTitle:@""] autorelease];
    NSMenu * eqrefMenu = [[[NSMenu alloc] initWithTitle:@""] autorelease];
    [labelMenu setAutoenablesItems:YES];
    [refMenu setAutoenablesItems:YES];
    [eqrefMenu setAutoenablesItems:YES];

    NSString * S = self.string;
    iTM2LiteScanner * scan = [iTM2LiteScanner scannerWithString:S charactersToBeSkipped:[NSCharacterSet whitespaceCharacterSet]];
    NSUInteger scanLocation = 0, end = S.length;
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
                    NSRange R1 = iTM3MakeRange(scanLocation, end-scanLocation);
                    NSRange R2 = [S rangeOfString:@"label" options:NSAnchoredSearch range:R1];
                    if(R2.length)
                    {
                        NSUInteger contentsEnd;
                        [S getLineStart:nil end:nil contentsEnd: &contentsEnd forRange:R2];
                        [scan setScanLocation:iTM3MaxRange(R2)];
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
                                NSString * title = (object.length > 48)?
                                                        [NSString stringWithFormat:@"%@[...]",
                                                            [object substringWithRange:iTM3MakeRange(0,43)]]: object;
                                if(title.length)
                                {
                                    NSMenuItem * MI = [labelMenu addItemWithTitle: title
                                                            action: @selector(scrollConTeXtLabelToVisible:)
                                                                keyEquivalent: [NSString string]];
                                    MI.tag = R2.location;
                                    MI.representedObject = object;
                                    [MI setEnabled: (labelMenu.title.length > 0)];
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
                        NSUInteger contentsEnd;
                        [S getLineStart:nil end:nil contentsEnd: &contentsEnd forRange:R2];
                        [scan setScanLocation:iTM3MaxRange(R2)];
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
                                NSString * title = (object.length > 48)?
                                                        [NSString stringWithFormat:@"%@[...]",
                                                            [object substringWithRange:iTM3MakeRange(0,43)]]: object;
                                if(title.length)
                                {
                                    NSMenuItem * MI = [refMenu addItemWithTitle: title
                                                            action: @selector(scrollConTeXtReferenceToVisible:)
                                                                keyEquivalent: [NSString string]];
                                    MI.tag = R2.location;
                                    MI.representedObject = object;
                                    [MI setEnabled: (refMenu.title.length > 0)];
                                }
                            }
                        }
                    }
                    else if(([S characterAtIndex:scanLocation] == 'i') &&
                                (++scanLocation < end) &&
                                    ([S characterAtIndex:scanLocation] == 'n') &&
                                        (++scanLocation < end))
                    {
                        NSRange R1 = iTM3MakeRange(scanLocation, end-scanLocation);
                        NSRange R2 = [S rangeOfString:@"put" options:NSAnchoredSearch range:R1];
                        if(R2.length)
                        {
                            SEL selector = @selector(scrollInputToVisible:);
                            NSString * prefix = @"Input";
                            [S getLineStart:nil end:nil contentsEnd: &scanLocation forRange:R2];
                            [scan setScanLocation:iTM3MaxRange(R2)];
                            [scan scanString:@"{" intoString:nil];
                            NSString * object;
                            if([scan scanUpToString:@"}" intoString: &object beforeIndex:scanLocation] ||
                                [scan scanCharactersFromSet:[[NSCharacterSet whitespaceAndNewlineCharacterSet] invertedSet]
                                    intoString: &object beforeIndex: scanLocation])
                            {
                                object = [object stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];                            
                                NSString * title = [NSString stringWithFormat:@"%@: %@", prefix, object];
                                title = (title.length > 48)?
                                                [NSString stringWithFormat:@"%@[...]",
                                                        [title substringWithRange:iTM3MakeRange(0,43)]]: title;
                                if(title.length)
                                {
                                    NSMenuItem * MI = [labelMenu addItemWithTitle:title action:selector keyEquivalent:[NSString string]];
                                    MI.representedObject = object;
                                    [MI setEnabled: (labelMenu.title.length > 0)];
                                }
                            }
                        }
                        else if(R2 = [S rangeOfString:@"clude" options:NSAnchoredSearch range:R1], R2.length)
                        {
                            SEL selector = @selector(scrollIncludeToVisible:);
                            NSString * prefix = @"Include";
                            NSUInteger contentsEnd;
                            [S getLineStart:nil end:nil contentsEnd: &contentsEnd forRange:R1];
                            [scan setScanLocation:iTM3MaxRange(R2)];
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
                                    title = (title.length > 48)?
                                                    [NSString stringWithFormat:@"%@[...]",
                                                            [title substringWithRange:iTM3MakeRange(0,43)]]: title;
                                    if(title.length)
                                    {
                                        NSMenuItem * MI = [labelMenu addItemWithTitle:title action:selector keyEquivalent:[NSString string]];
                                        MI.representedObject = object;
                                        [MI setEnabled: (labelMenu.title.length > 0)];
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= initialize
+ (void)initialize;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//LOG4iTM3(@"iTM2TeXParser");
    if(!_iTM2ConTeXtModeForModeArray)
        _iTM2ConTeXtModeForModeArray = [[NSArray arrayWithObjects:@"include", @"includegraphics", @"url", nil] retain];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= syntaxParserStyle
+ (NSString *)syntaxParserStyle;
/*"Designated initializer.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2: 12/05/2003
To Do List: Nothing
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return @"ConTeXt";
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  defaultModesAttributes
+ (NSDictionary *)defaultModesAttributes;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  getSyntaxMode:forCharacter:previousMode:
- (NSUInteger)getSyntaxMode:(NSUInteger *)newModeRef forCharacter:(unichar)theChar previousMode:(NSUInteger)previousMode;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Dec 12 22:44:56 GMT 2003
To Do List: 
"*/
{DIAGNOSTIC4iTM3;
	NSParameterAssert(newModeRef);
//START4iTM3;
//    if(previousMode != ( previousMode & ~kiTM2TeXErrorSyntaxMask))
//        NSLog(@"previousMode: 0X%x, mask: 0X%x, previousMode & ~mask: 0X%x",  previousMode, kiTM2TeXErrorSyntaxModeMask,  previousMode & ~kiTM2TeXErrorSyntaxMask);
	// this is for the added modes, but links should not happen here.
	NSUInteger switcher = previousMode & ~kiTM2TeXErrorSyntaxMask;
	switch (switcher) {
		case kiTM2ConTeXtIncludeSyntaxMode:
		case kiTM2ConTeXtIncludegraphicsSyntaxMode:
		case kiTM2ConTeXtURLSyntaxMode:
		if([[NSCharacterSet TeXLetterCharacterSet4iTM3] characterIsMember:theChar])
		{
			if([iVarAS4iTM3 character:theChar isMemberOfCoveredCharacterSetForMode:[_iTM2ConTeXtModeForModeArray objectAtIndex:switcher - 1000]])
				return previousMode;
			else
			{
	//LOG4iTM3(@"AN ERROR OCCURRED");
				return previousMode | kiTM2TeXErrorFontSyntaxMask;
			}
		}
		else
			return [super getSyntaxMode:newModeRef forCharacter:theChar previousMode:kiTM2TeXCommandContinueSyntaxMode];
		default:
			return [super getSyntaxMode:newModeRef forCharacter:theChar previousMode:previousMode];
	}
//END4iTM3;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  getSyntaxMode:forLocation:previousMode:effectiveLength:nextModeIn:before:
- (NSUInteger)getSyntaxMode:(NSUInteger *)newModeRef forLocation:(NSUInteger)location previousMode:(NSUInteger)previousMode effectiveLength:(NSUInteger *)lengthRef nextModeIn:(NSUInteger *)nextModeRef before:(NSUInteger)beforeIndex;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Dec 12 22:44:56 GMT 2003
To Do List: 
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSString * S = [_TextStorage string];
    NSParameterAssert(location<S.length);
	NSUInteger switcher = previousMode & ~kiTM2TeXErrorSyntaxMask;
	unichar theChar, status;
	NSCharacterSet * set = [NSCharacterSet TeXLetterCharacterSet4iTM3];
	if(kiTM2TeXCommandStartSyntaxMode == switcher)
	{
		theChar = [S characterAtIndex:location];
		if([set characterIsMember:theChar])
		{
			// is it a \include, \includegraphics, \url
			// scanning from location for the control sequence name
			NSUInteger start = location;
			NSUInteger end = start + 1;
			while(end<S.length && ((theChar = [S characterAtIndex:end]),[set characterIsMember:theChar]))
				++end;
			if(end == start+15)
			{
				if([@"includegraphics" isEqualToString:[S substringWithRange:iTM3MakeRange(start, end - start)]])
				{
					if(lengthRef)
						* lengthRef = end - start;
					if(nextModeRef && (end<S.length))
					{
						theChar = [S characterAtIndex:end];
						status = [self getSyntaxMode:nextModeRef forCharacter:theChar previousMode:kiTM2ConTeXtIncludegraphicsSyntaxMode];
					}
					// now we invalidate the cursor rects in order to have the links properly displayed
					//the delay is due to the reentrant problem
					[_TextStorage performSelector:@selector(invalidateCursorRects) withObject:nil afterDelay:0.01];
					* newModeRef = kiTM2ConTeXtIncludegraphicsSyntaxMode;
					return kiTM2TeXNoErrorSyntaxStatus;
				}
			}
			else if(end == start+7)
			{
				if([@"include" isEqualToString:[S substringWithRange:iTM3MakeRange(start, end - start)]])
				{
					if(lengthRef)
						* lengthRef = end - start;
					if(nextModeRef && (end<S.length))
					{
						theChar = [S characterAtIndex:end];
						status = [self getSyntaxMode:nextModeRef forCharacter:theChar previousMode:kiTM2ConTeXtIncludegraphicsSyntaxMode];
					}
					// now we invalidate the cursor rects in order to have the links properly displayed
					//the delay is due to the reentrant problem
					[_TextStorage performSelector:@selector(invalidateCursorRects) withObject:nil afterDelay:0.01];
					* newModeRef = kiTM2ConTeXtIncludeSyntaxMode;
					return kiTM2TeXNoErrorSyntaxStatus;
				}
			}
			else if(end == start+3)
			{
				if([@"url" isEqualToString:[S substringWithRange:iTM3MakeRange(start, end - start)]])
				{
					if(lengthRef)
						* lengthRef = end - start;
					if(nextModeRef && (end<S.length))
					{
						theChar = [S characterAtIndex:end];
						status = [self getSyntaxMode:nextModeRef forCharacter:theChar previousMode:kiTM2ConTeXtIncludegraphicsSyntaxMode];
					}
					// now we invalidate the cursor rects in order to have the links properly displayed
					//the delay is due to the reentrant problem
					[_TextStorage performSelector:@selector(invalidateCursorRects) withObject:nil afterDelay:0.01];
					* newModeRef = kiTM2ConTeXtURLSyntaxMode;
					return kiTM2TeXNoErrorSyntaxStatus;
				}
			}
		}
	}
	if(nextModeRef)
	{
		status = [super getSyntaxMode:newModeRef forLocation:location previousMode:previousMode effectiveLength:lengthRef nextModeIn:nextModeRef before:beforeIndex];
		if((*newModeRef == kiTM2TeXCommandStartSyntaxMode) && (*nextModeRef == kiTM2TeXCommandContinueSyntaxMode))
		{
			NSUInteger start = location+1;
			NSUInteger end = start;
			while(end<S.length && ((theChar = [S characterAtIndex:end]),[set characterIsMember:theChar]))
				++end;
			if(end == start+15)
			{
				if([@"includegraphics" isEqualToString:[S substringWithRange:iTM3MakeRange(start, end - start)]])
					*nextModeRef = kiTM2ConTeXtIncludegraphicsSyntaxMode;
			}
			else if(end == start+7)
			{
				if([@"include" isEqualToString:[S substringWithRange:iTM3MakeRange(start, end - start)]])
					*nextModeRef = kiTM2ConTeXtIncludeSyntaxMode;
			}
			else if(end == start+3)
			{
				if([@"url" isEqualToString:[S substringWithRange:iTM3MakeRange(start, end - start)]])
					*nextModeRef = kiTM2ConTeXtURLSyntaxMode;
			}
		}
		return status;
	}
	else
		return [super getSyntaxMode:newModeRef forLocation:location previousMode:previousMode effectiveLength:lengthRef nextModeIn:nil before:beforeIndex];
//END4iTM3;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  attributesAtIndex:effectiveRange:
- (NSDictionary *)attributesAtIndex:(NSUInteger)aLocation effectiveRange:(NSRangePointer)aRangePtr;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSUInteger mode;
	NSUInteger status = [self getSyntaxMode:&mode atIndex:aLocation longestRange:aRangePtr];
	NSUInteger switcher = mode & ~kiTM2TeXErrorSyntaxMask;
    switch (switcher) {
        case kiTM2TeXCommandStartSyntaxMode:
			if (aLocation + 1 < [self.textStorage length]) {
				NSUInteger nextMode;
				status = [self getSyntaxMode:&nextMode atIndex:aLocation+1 longestRange:aRangePtr];
				NSUInteger nextSwitcher = nextMode & ~kiTM2TeXErrorSyntaxMask;
				switch (nextSwitcher) {
					case kiTM2ConTeXtIncludeSyntaxMode:
					case kiTM2ConTeXtIncludegraphicsSyntaxMode:
					case kiTM2ConTeXtURLSyntaxMode: {
						if (aRangePtr) {
							aRangePtr->location -= 1;
							aRangePtr->length += 1;
						}
						return [iVarAS4iTM3 attributesForMode:[_iTM2ConTeXtModeForModeArray objectAtIndex:nextSwitcher - 1000]];
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
			if (aRangePtr) {
				NSUInteger max = iTM3MaxRange(*aRangePtr);
				aRangePtr->location = aLocation;
				aRangePtr->length = max - aLocation;
			}
            return [iVarAS4iTM3 attributesForMode:[_iTM2ConTeXtModeForModeArray objectAtIndex:switcher - 1000]];
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return @"ConTeXt-Xtd";
}
#if 1
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  attributesAtIndex:effectiveRange:
- (NSDictionary *)attributesAtIndex:(NSUInteger)aLocation effectiveRange:(NSRangePointer)aRangePtr;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSUInteger mode;
	NSUInteger status = [self getSyntaxMode:&mode atIndex:aLocation longestRange:aRangePtr];
	NSUInteger switcher = mode & ~kiTM2TeXErrorSyntaxMask;
    switch (switcher) {
        case kiTM2TeXCommandStartSyntaxMode:
			if (aLocation + 1 < [self.textStorage length]) {
				NSUInteger nextMode;
				status = [self getSyntaxMode:&nextMode atIndex:aLocation+1 longestRange:aRangePtr];
				NSUInteger nextSwitcher = nextMode & ~kiTM2TeXErrorSyntaxMask;
				switch (nextSwitcher) {
					case kiTM2ConTeXtIncludeSyntaxMode:
					case kiTM2ConTeXtIncludegraphicsSyntaxMode:
					case kiTM2ConTeXtURLSyntaxMode: {
						if (aRangePtr) {
							aRangePtr->location -= 1;
							aRangePtr->length += 1;
						}
						return [iVarAS4iTM3 attributesForMode:[_iTM2ConTeXtModeForModeArray objectAtIndex:nextSwitcher - 1000]];
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
			if (aRangePtr) {
				NSUInteger max = iTM3MaxRange(*aRangePtr);
				aRangePtr->location = aLocation;
				aRangePtr->length = max - aLocation;
			}
            return [iVarAS4iTM3 attributesForMode:[_iTM2ConTeXtModeForModeArray objectAtIndex:switcher - 1000]];
        default:
            return [super attributesAtIndex:aLocation effectiveRange:aRangePtr];
    }
}
#endif
@end

NSString * const iTM2ConTeXtParserAttributesInspectorType = @"iTM2ConTeXtParserAttributes";

@implementation iTM2ConTeXtParserAttributesDocument
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inspectorType4iTM3
+ (NSString *)inspectorType4iTM3;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return iTM2ConTeXtParserAttributesInspectorType;
}
@end

@implementation iTM2ConTeXtParserAttributesInspector
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inspectorType4iTM3
+ (NSString *)inspectorType4iTM3;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return iTM2ConTeXtParserAttributesInspectorType;
}
@end

NSString * const iTM2XtdConTeXtParserAttributesInspectorType = @"iTM2XtdConTeXtParserAttributes";

@implementation iTM2XtdConTeXtParserAttributesDocument
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inspectorType4iTM3
+ (NSString *)inspectorType4iTM3;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return iTM2XtdConTeXtParserAttributesInspectorType;
}
@end

@implementation iTM2XtdConTeXtParserAttributesInspector
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inspectorType4iTM3
+ (NSString *)inspectorType4iTM3;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return iTM2XtdConTeXtParserAttributesInspectorType;
}
@end

@implementation iTM2XtdConTeXtParserSymbolsInspector
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inspectorType4iTM3
+ (NSString *)inspectorType4iTM3;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
	return;
}  
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  ConTeXtLabelActionWillPopUp:
- (BOOL)ConTeXtLabelActionWillPopUp:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue May  3 16:20:26 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
	return YES;
}  
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  ConTeXtSectionAction:
- (IBAction)ConTeXtSectionAction:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue May  3 16:20:26 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
	return;
}  
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  ConTeXtSectionActionWillPopUp:
- (BOOL)ConTeXtSectionActionWillPopUp:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue May  3 16:20:26 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
	return YES;
}  
@end

@implementation NSMenu(iTM2ConTeXtSupport)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  menuWithConTeXtGardenXMLElements:
+ (NSMenu *)menuWithConTeXtGardenXMLElements:(NSArray *)elements;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue May  3 16:20:26 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSMenu * result = [[[NSMenu alloc] initWithTitle:@""] autorelease];
	for (NSXMLElement * element in elements) {
		NSString * title = [[[element elementsForName:@"title"] lastObject] stringValue];
		if (title.length) {
			NSMenuItem * MI = [[[NSMenuItem alloc] initWithTitle:title action:NULL keyEquivalent:@""] autorelease];
			[result addItem:MI];
			NSMenu * M = [self menuWithConTeXtGardenXMLElements:[[[element elementsForName:@"items"] lastObject] children]];
			if(M) {
				[result setSubmenu:M forItem:MI];
            }
			MI.toolTip = [[[element elementsForName:@"tooltip"] lastObject] stringValue];
			MI.representedObject = [iTM2ConTeXtInspector ConTeXtGardenPageURLWithRef:[[element attributeForName:@"href"] stringValue]];
			MI.action = @selector(ConTeXtAtGardenFromRepresentedURL:);
			MI.target = nil;
		}
	}
//END4iTM3;
	return result.numberOfItems > 0? result: nil;
}  
@end

#undef DEFINE_TOOLBAR_ITEM
#define DEFINE_TOOLBAR_ITEM(SELECTOR)\
+ (NSToolbarItem *)SELECTOR;{return [self toolbarItemWithIdentifier4iTM3:[self identifierFromSelector4iTM3:_cmd] inBundle:[iTM2TeXProjectInspector classBundle4iTM3]];}

#import <iTM2TeXFoundation/iTM2TeXPCommandWrapperKit.h>
#if 0
@implementation NSToolbarItem(iTM2ConTeXt)
+ (NSToolbarItem *)ConTeXtLabelToolbarItem;
{
	NSToolbarItem * toolbarItem = [self toolbarItemWithIdentifier4iTM3:[self identifierFromSelector4iTM3:_cmd] inBundle:[iTM2TeXProjectInspector classBundle4iTM3]];
	NSRect frame = NSMakeRect(0, 0, 32, 32);
	iTM2MixedButton * B = [[[iTM2MixedButton alloc] initWithFrame:frame] autorelease];
	[B setButtonType:NSMomentaryChangeButton];
//	[B setButtonType:NSOnOffButton];
	B.image = toolbarItem.image;
	[B setImagePosition:NSImageOnly];
	[B setBezelStyle:NSShadowlessSquareBezelStyle];
//	[. setHighlightsBy:NSMomentaryChangeButton];
	B.isBordered = NO;
	toolbarItem.view = B;
	toolbarItem.maxSize = toolbarItem.minSize = frame.size;
	B.target = nil;
	[. setBackgroundColor:[NSColor clearColor]];
	NSMenu * M = [[[NSMenu alloc] initWithTitle:@""] autorelease];
	NSPopUpButton * PB = [[[NSPopUpButton alloc] initWithFrame:NSZeroRect] autorelease];
	[PB setMenu:M];
	[PB setPullsDown:YES];
	PB.action = @selector(ConTeXtLabelAction:);
	[. setPopUpCell:.];
	return toolbarItem;
}
+ (NSToolbarItem *)ConTeXtSectionToolbarItem;
{
	NSToolbarItem * toolbarItem = [self toolbarItemWithIdentifier4iTM3:[self identifierFromSelector4iTM3:_cmd] inBundle:[iTM2TeXProjectInspector classBundle4iTM3]];
	NSRect frame = NSMakeRect(0, 0, 32, 32);
	iTM2MixedButton * B = [[[iTM2MixedButton alloc] initWithFrame:frame] autorelease];
	[B setButtonType:NSMomentaryChangeButton];
//	[B setButtonType:NSOnOffButton];
	B.image = toolbarItem.image;
	[B setImagePosition:NSImageOnly];
	[B setBezelStyle:NSShadowlessSquareBezelStyle];
//	[. setHighlightsBy:NSMomentaryChangeButton];
	B.isBordered = NO;
	toolbarItem.view = B;
	toolbarItem.maxSize = toolbarItem.minSize = frame.size;
	B.target = nil;
	[. setBackgroundColor:[NSColor clearColor]];
	NSMenu * M = [[[NSMenu alloc] initWithTitle:@""] autorelease];
	NSPopUpButton * PB = [[[NSPopUpButton alloc] initWithFrame:NSZeroRect] autorelease];
	[PB setMenu:M];
	[PB setPullsDown:YES];
	PB.action = @selector(ConTeXtSectionAction:);
	[. setPopUpCell:.];
	return toolbarItem;
}
@end
#endif
///usr/local/teTeX/share/texmf.tetex/doc/context/
/*
This is for sherlock
*/