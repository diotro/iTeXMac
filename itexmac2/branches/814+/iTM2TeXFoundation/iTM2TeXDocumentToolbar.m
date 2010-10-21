/*
//
//  @version Subversion: $Id$ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Fri Sep 05 2003.
//  Copyright © 2003 Laurens'Tribune. All rights reserved.
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

#import "iTM2TeXDocumentToolbar.h"
#import "iTM2TeXDocumentKit.h"
#import "iTM2TeXPCommandWrapperKit.h"

#define TABLE @"iTM2TextKit"
#define BUNDLE [iTM2TextDocument classBundle4iTM3]

NSString * const iTM2TeXToolbarIdentifier = @"TeX Inspector";

NSString * const iTM2ToolbarBookmarkItemIdentifier = @"bookmark";
//NSString * const iTM2ToolbarDoZoomToFitItemIdentifier = @"doZoomToFit";

@implementation iTM2MainInstaller(TeXInspectorToolbar)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  TeXInspectorToolbarCompleteInstallation4iTM3
+ (void)TeXInspectorToolbarCompleteInstallation4iTM3;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue May  3 16:20:26 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[SUD registerDefaults: [NSDictionary dictionaryWithObjectsAndKeys:
		[NSNumber numberWithBool:NO], @"iTM2TeXToolbarAutosavesConfiguration",
		[NSNumber numberWithBool:YES], @"iTM2TeXToolbarShareConfiguration",
			nil]];
//END4iTM3;
	return;
}
@end

#define DEFINE_TOOLBAR_ITEM(SELECTOR)\
+ (NSToolbarItem *)SELECTOR;{return [self toolbarItemWithIdentifier4iTM3:[self identifierFromSelector4iTM3:_cmd] inBundle:[iTM2TeXInspector classBundle4iTM3]];}

#import <iTM2TeXFoundation/iTM2TeXPCommandWrapperKit.h>

@implementation NSToolbarItem(iTM2TeX)
DEFINE_TOOLBAR_ITEM(bookmarkToolbarItem)
@end

@implementation iTM2TeXInspector(Toolbar)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setupToolbarWindowDidLoad4iTM3
- (void)setupToolbarWindowDidLoad4iTM3;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue May  3 16:20:26 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSToolbar * toolbar = [[[NSToolbar alloc] initWithIdentifier:iTM2TeXToolbarIdentifier] autorelease];
	NSString * key = [NSString stringWithFormat:@"NSToolbar Configuration %@", [toolbar identifier]];
	if([self contextBoolForKey:@"iTM2TeXToolbarShareConfiguration" domain:iTM2ContextAllDomainsMask])
	{
		NSDictionary * configDictionary = [SUD dictionaryForKey:key];
		if(configDictionary.count)
		{
			[toolbar setConfigurationFromDictionary:configDictionary];
			if(!toolbar.items.count)
			{
				[SUD removeObjectForKey:key];
				toolbar = [[[NSToolbar alloc] initWithIdentifier:iTM2TeXToolbarIdentifier] autorelease];
			}
		}
	}
	else
	{
		NSDictionary * configDictionary = [SUD dictionaryForKey:key];
//LOG4iTM3(@"configDictionary: %@", configDictionary);
		configDictionary = [self contextDictionaryForKey:key domain:iTM2ContextAllDomainsMask];
//LOG4iTM3(@"configDictionary: %@", configDictionary);
		if(configDictionary.count)
			[toolbar setConfigurationFromDictionary:configDictionary];
		if(!toolbar.items.count)
		{
			configDictionary = [SUD dictionaryForKey:key];
//LOG4iTM3(@"configDictionary: %@", configDictionary);
			[self takeContextValue:nil forKey:key domain:iTM2ContextAllDomainsMask];
			if(configDictionary.count)
				[toolbar setConfigurationFromDictionary:configDictionary];
			if(!toolbar.items.count)
			{
				[SUD removeObjectForKey:key];
				toolbar = [[[NSToolbar alloc] initWithIdentifier:iTM2TeXToolbarIdentifier] autorelease];
			}
		}
	}
	[toolbar setAutosavesConfiguration:YES];
    [toolbar setAllowsUserCustomization:YES];
//    [toolbar setSizeMode:NSToolbarSizeModeSmall];
    toolbar.delegate = self;
	[toolbar setShowsBaselineSeparator:NO];
    [self.window setToolbar:toolbar];
//END4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleShareToolbarConfiguration:
- (void)toggleShareToolbarConfiguration:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue May  3 16:20:26 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	BOOL old = [self contextBoolForKey:@"iTM2TeXToolbarShareConfiguration" domain:iTM2ContextAllDomainsMask];
	[self takeContextBool: !old forKey:@"iTM2TeXToolbarShareConfiguration" domain:iTM2ContextAllDomainsMask];
	self.validateWindowContent4iTM3;
//END4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleShareToolbarConfiguration:
- (BOOL)validateToggleShareToolbarConfiguration:(NSButton *)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue May  3 16:20:26 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	sender.state = ([self contextBoolForKey:@"iTM2TeXToolbarShareConfiguration" domain:iTM2ContextAllDomainsMask]? NSOnState:NSOffState);
//END4iTM3;
	return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  prepareToolbarConfigurationCompleteSaveContext4iTM3:
- (void)prepareToolbarConfigurationCompleteSaveContext4iTM3:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue May  3 16:20:26 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if([self contextBoolForKey:@"iTM2TeXToolbarAutosavesConfiguration" domain:iTM2ContextAllDomainsMask])
	{
		NSToolbar * toolbar = [self.window toolbar];
		NSString * key = [NSString stringWithFormat:@"NSToolbar Configuration %@", [toolbar identifier]];
		[self takeContextValue:[toolbar configurationDictionary] forKey:key domain:iTM2ContextAllDomainsMask];
	}
//START4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toolbar:itemForItemIdentifier:willBeInsertedIntoToolbar:
- (NSToolbarItem *)toolbar:(NSToolbar *)toolbar itemForItemIdentifier:(NSString *)itemIdent willBeInsertedIntoToolbar:(BOOL)willBeInserted;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue May  3 16:20:26 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    // Required delegate method:  Given an item identifier, this method returns an item 
    // The toolbar will use this method to obtain toolbar items that can be displayed in the customization sheet, or in the toolbar itself 
    NSToolbarItem * toolbarItem = nil;
	SEL action = NSSelectorFromString([itemIdent stringByAppendingString:@":"]);
	if(action) {
//id objc_msgSend(id theReceiver, SEL theSelector, ...);
		toolbarItem = [NSToolbarItem seedToolbarItemWithIdentifier4iTM3:itemIdent forToolbarIdentifier:toolbar.identifier];
		toolbarItem.action = action;
		toolbarItem.target = nil;
	}
	if(willBeInserted) {
		NSView * v = toolbarItem.view;
		if(v) {
			[v setToolbarSizeMode4iTM3:toolbar.sizeMode];
			toolbarItem.minSize = toolbarItem.maxSize = v.frame.size;
		}
	}
//END4iTM3;
    return toolbarItem;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toolbarDefaultItemIdentifiers:
- (NSArray *)toolbarDefaultItemIdentifiers:(NSToolbar *)toolbar;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue May  3 16:20:26 GMT 2005
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
						nil];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toolbarAllowedItemIdentifiers:
- (NSArray *)toolbarAllowedItemIdentifiers:(NSToolbar *)toolbar;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue May  3 16:20:26 GMT 2005
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
//					iTM2ToolbarBookmarkItemIdentifier,
					NSToolbarSeparatorItemIdentifier,
					NSToolbarPrintItemIdentifier, 
					NSToolbarSpaceItemIdentifier,
					NSToolbarFlexibleSpaceItemIdentifier,
					NSToolbarCustomizeToolbarItemIdentifier,
//					NSToolbarShowColorsItemIdentifier,
//					NSToolbarShowFontsItemIdentifier,
							nil];
}
#if 0
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toolbarWillAddItem:
- (void)toolbarWillAddItem:(NSNotification *)notif;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue May  3 16:20:26 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    // Optional delegate method:  Before an new item is added to the toolbar, this notification is posted.
    // This is the best place to notice a new item is going into the toolbar.  For instance, if you need to 
    // cache a reference to the toolbar item or need to set up some initial state, this is the best place 
    // to do it.  The notification object is the toolbar to which the item is being added.  The item being 
    // added is found by referencing the @"item" key in the userInfo 
    NSToolbar *toolbar = [notif object];
    NSToolbarItem *toolbarItem = [[notif userInfo] objectForKey:@"item"];
//END4iTM3;
    return;
}  
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toolbarDidRemoveItem:
- (void)toolbarDidRemoveItem:(NSNotification *)notif;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue May  3 16:20:26 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    // Optional delegate method:  Before an new item is added to the toolbar, this notification is posted.
    // This is the best place to notice a new item is going into the toolbar.  For instance, if you need to 
    // cache a reference to the toolbar item or need to set up some initial state, this is the best place 
    // to do it.  The notification object is the toolbar to which the item is being added.  The item being 
    // added is found by referencing the @"item" key in the userInfo 
    NSToolbarItem * removedItem = [[notif userInfo] objectForKey:@"item"];
	if([[removedItem itemIdentifier] isEqualToString:iTM2ToolbarPageItemIdentifier])
	{
		[IMPLEMENTATION takeMetaValue:nil forKey:@"toolbar page field"];
	}
//END4iTM3;
    return;
}  
#endif
@end