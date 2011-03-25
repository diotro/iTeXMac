/*
//  iTM2LaTeXKit.h
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
//  Foundation, Inc., 59 Temple Place-Suite 330, Boston, MA 02111-1307, USA.
//  GPL addendum: Any simple modification of the present code which purpose is to remove bug,
//  improve efficiency in both code execution and code reading or writing should be addressed
//  to the actual developper team.
*/

#import "iTM2LaTeXKit.h"
#import <iTM2Foundation/iTM2Foundation.h>

NSString * const iTM2LaTeXInspectorMode = @"LaTeX Mode";
NSString * const iTM2LaTeXToolbarIdentifier = @"iTM2 LaTeX Toolbar: Tiger";

@implementation iTM2LaTeXInspector
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inspectorMode
+ (NSString *)inspectorMode;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return iTM2LaTeXInspectorMode;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= windowPositionShouldBeObserved4iTM3
- (BOOL)windowPositionShouldBeObserved4iTM3;
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= defaultMacroCategory
- (NSString *)defaultMacroCategory;
{
    return @"LaTeX";
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= defaultMacroContext
- (NSString *)defaultMacroContext;
{
    return @"";
}
@end

NSString * const iTM2ToolbarLaTeXLabelItemIdentifier = @"LaTeXLabel";
NSString * const iTM2ToolbarLaTeXSectionItemIdentifier = @"LaTeXSection";
//NSString * const iTM2ToolbarDoZoomToFitItemIdentifier = @"doZoomToFit";

@implementation iTM2MainInstaller(LaTeXInspectorToolbar)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  LaTeXInspectorToolbarCompleteInstallation4iTM3
+ (void)LaTeXInspectorToolbarCompleteInstallation4iTM3;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue May  3 16:20:26 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[SUD registerDefaults: [NSDictionary dictionaryWithObjectsAndKeys:
		[NSNumber numberWithBool:NO], @"iTM2LaTeXToolbarAutosavesConfiguration",
		[NSNumber numberWithBool:YES], @"iTM2LaTeXToolbarShareConfiguration",
			nil]];
//END4iTM3;
	return;
}
@end

#define DEFINE_TOOLBAR_ITEM(SELECTOR)\
+ (NSToolbarItem *)SELECTOR;{return [self toolbarItemWithIdentifier4iTM3:[self identifierFromSelector4iTM3:_cmd] inBundle:[iTM2TeXInspector classBundle4iTM3]];}

@implementation NSToolbarItem(iTM2LaTeX)
DEFINE_TOOLBAR_ITEM(LaTeXSectionToolbarItem)
DEFINE_TOOLBAR_ITEM(LaTeXLabelToolbarItem)
@end

NSString * const iTM2ToolbarLaTeXSubscriptItemIdentifier = @"subscript";
NSString * const iTM2ToolbarLaTeXSuperscriptItemIdentifier = @"superscript";

@implementation iTM2LaTeXInspector(Toolbar)
#pragma mark =-=-=-=-=-  TOOLBAR
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setupToolbarWindowDidLoad4iTM3
- (void)setupToolbarWindowDidLoad4iTM3;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue May  3 16:20:26 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSToolbar * toolbar = [[[NSToolbar alloc] initWithIdentifier:iTM2LaTeXToolbarIdentifier] autorelease];
	NSString * key = [NSString stringWithFormat:@"NSToolbar Configuration %@", [toolbar identifier]];
	if([self context4iTM3BoolForKey:@"iTM2LaTeXToolbarShareConfiguration" domain:iTM2ContextAllDomainsMask])
	{
		NSDictionary * configDictionary = [SUD dictionaryForKey:key];
		if(configDictionary.count)
		{
			[toolbar setConfigurationFromDictionary:configDictionary];
			if(!toolbar.items.count)
			{
				[SUD removeObjectForKey:key];
				toolbar = [[[NSToolbar alloc] initWithIdentifier:iTM2LaTeXToolbarIdentifier] autorelease];
			}
		}
	}
	else
	{
		NSDictionary * configDictionary = [SUD dictionaryForKey:key];
//LOG4iTM3(@"configDictionary: %@", configDictionary);
		configDictionary = [self context4iTM3DictionaryForKey:key domain:iTM2ContextAllDomainsMask];
//LOG4iTM3(@"configDictionary: %@", configDictionary);
		if(configDictionary.count)
			[toolbar setConfigurationFromDictionary:configDictionary];
		if(!toolbar.items.count)
		{
			configDictionary = [SUD dictionaryForKey:key];
//LOG4iTM3(@"configDictionary: %@", configDictionary);
			[self takeContext4iTM3Value:nil forKey:key domain:iTM2ContextAllDomainsMask];
			if(configDictionary.count)
				[toolbar setConfigurationFromDictionary:configDictionary];
			if(!toolbar.items.count)
			{
				[SUD removeObjectForKey:key];
				toolbar = [[[NSToolbar alloc] initWithIdentifier:iTM2LaTeXToolbarIdentifier] autorelease];
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
- 2.0: Tue May  3 16:20:26 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	BOOL old = [self context4iTM3BoolForKey:@"iTM2LaTeXToolbarShareConfiguration" domain:iTM2ContextAllDomainsMask];
	[self takeContext4iTM3Bool: !old forKey:@"iTM2LaTeXToolbarShareConfiguration" domain:iTM2ContextAllDomainsMask];
	[self isWindowContentValid4iTM3];
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
	sender.state = ([self context4iTM3BoolForKey:@"iTM2LaTeXToolbarShareConfiguration" domain:iTM2ContextAllDomainsMask]? NSOnState:NSOffState);
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
	if([self context4iTM3BoolForKey:@"iTM2LaTeXToolbarAutosavesConfiguration" domain:iTM2ContextAllDomainsMask])
	{
		NSToolbar * toolbar = [self.window toolbar];
		NSString * key = [NSString stringWithFormat:@"NSToolbar Configuration %@", [toolbar identifier]];
		[self takeContext4iTM3Value:[toolbar configurationDictionary] forKey:key domain:iTM2ContextAllDomainsMask];
	}
//START4iTM3;
	return;
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
				NSToolbarSeparatorItemIdentifier,
				iTM2ToolbarLaTeXSubscriptItemIdentifier,
				iTM2ToolbarLaTeXSuperscriptItemIdentifier,
//				iTM2ToolbarBookmarkItemIdentifier,
//				iTM2ToolbarLaTeXLabelItemIdentifier,
//				iTM2ToolbarLaTeXSectionItemIdentifier,
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
//					iTM2ToolbarLaTeXLabelItemIdentifier,
//					iTM2ToolbarLaTeXSectionItemIdentifier,
					NSToolbarSeparatorItemIdentifier,
					NSToolbarPrintItemIdentifier,
					NSToolbarSpaceItemIdentifier,
					NSToolbarFlexibleSpaceItemIdentifier,
					NSToolbarCustomizeToolbarItemIdentifier,
//					NSToolbarShowGraphicssItemIdentifier,
//					NSToolbarShowFontsItemIdentifier,
							nil];
}
@end

@implementation iTM2LaTeXSectionButton
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= awakeFromNib
- (void)awakeFromNib;
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[super awakeFromNib];
	self.action = @selector(LaTeXSectionButtonAction:);
	[self performSelector:@selector(initMenu) withObject:nil afterDelay:0.01];
	[DNC removeObserver: self
		name: NSPopUpButtonWillPopUpNotification
			object: self];
	[DNC addObserver: self
		selector: @selector(popUpButtonWillPopUpNotified:)
			name: NSPopUpButtonWillPopUpNotification
				object: self];
	NSView * superview = self.superview;
	[self removeFromSuperviewWithoutNeedingDisplay];
	[superview addSubview:self];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  popUpButtonWillPopUpNotified:
- (void)popUpButtonWillPopUpNotified:(NSNotification *)notification;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSMenu * M = [[self.window.windowController textStorage] LaTeXSectionMenu];
	NSAssert(M, @"Missing LaTeX menu: inconsistency");
	NSMenuItem * MI = [self.menu deepItemWithRepresentedObject4iTM3:@"LaTeX Section Menu"];
	if(MI)
	{
		[MI.menu setSubmenu: ([M numberOfItems]? M:nil) forItem:MI];
	}
	else if(MI = [self.menu deepItemWithAction4iTM3:@selector(gotoLaTeXSection:)])
	{
		MI.action = NULL;
		MI.representedObject = @"LaTeX Section Menu";
		[MI.menu setSubmenu: ([M numberOfItems]? M:nil) forItem:MI];
	}
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= initMenu
- (void)initMenu;
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSView * owner = [[[NSView alloc] initWithFrame:NSZeroRect] autorelease];
	NSDictionary * context = [NSDictionary dictionaryWithObject:owner forKey:@"NSOwner"];
	NSString * fileName;
	Class class = self.class;
next:
	fileName = [[NSBundle bundleForClass:class] pathForResource:@"iTM2LaTeXSectionMenu" ofType:@"nib"];
	if(fileName.length)
	{
		NSString * title = self.title;
		if([NSBundle loadNibFile:fileName externalNameTable:context withZone:self.zone])
		{
			NSMenu * M = [[owner.menu retain] autorelease];
			[owner setMenu:nil];
			if([M numberOfItems])
			{
				NSMenuItem * MI;
				NSEnumerator * E = [M.itemArray objectEnumerator];
				while(MI = E.nextObject)
				{
					SEL action = MI.action;
					if(action)
					{
						if([NSStringFromSelector(action) hasPrefix:@"insert"])
						{
							if(![MI indentationLevel])
								MI.indentationLevel = 1;
						}
					}
				}
				[[M itemAtIndex:ZER0] setTitle:title];
				self.title = title;// will raise if the menu is void
				[self setMenu:M];
			}
			else
			{
				LOG4iTM3(@"..........  ERROR: Inconsistent file (Void menu) at %@", fileName);
			}
		}
		else
		{
			LOG4iTM3(@"..........  ERROR: Corrupted file at %@", fileName);
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
//END4iTM3;
    return;
}
@end

@implementation iTM2LaTeXLabelButton
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= awakeFromNib
- (void)awakeFromNib;
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[super awakeFromNib];
	self.action = @selector(LaTeXLabelButtonAction:);
	[self performSelector:@selector(initMenu) withObject:nil afterDelay:0.01];
	[DNC removeObserver: self
		name: NSPopUpButtonWillPopUpNotification
			object: self];
	[DNC addObserver: self
		selector: @selector(popUpButtonWillPopUpNotified:)
			name: NSPopUpButtonWillPopUpNotification
				object: self];
	NSView * superview = self.superview;
	[self removeFromSuperviewWithoutNeedingDisplay];
	[superview addSubview:self];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= initMenu
- (void)initMenu;
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSView * owner = [[[NSView alloc] initWithFrame:NSZeroRect] autorelease];
	NSDictionary * context = [NSDictionary dictionaryWithObject:owner forKey:@"NSOwner"];
	NSString * fileName;
	Class class = self.class;
next:
	fileName = [[NSBundle bundleForClass:class] pathForResource:@"iTM2LaTeXLabelMenu" ofType:@"nib"];
	if(fileName.length)
	{
		NSString * title = self.title;
		if([NSBundle loadNibFile:fileName externalNameTable:context withZone:self.zone])
		{
			NSMenu * M = [[owner.menu retain] autorelease];
			[owner setMenu:nil];
			if([M numberOfItems])
			{
				NSMenuItem * MI;
				NSEnumerator * E = [M.itemArray objectEnumerator];
				while(MI = E.nextObject)
				{
					SEL action = MI.action;
					if(action)
					{
						NSString * actionName = NSStringFromSelector(action);
						if([actionName hasPrefix:@"insert"] || [actionName hasPrefix:@"goto"])
						{
							if(![MI indentationLevel])
								MI.indentationLevel = 1;
						}
					}
				}
				[[M itemAtIndex:ZER0] setTitle:title];
				self.title = title;// will raise if the menu is void
				[self setMenu:M];
			}
			else
			{
				LOG4iTM3(@"..........  ERROR: Inconsistent file (Void menu) at %@", fileName);
			}
		}
		else
		{
			LOG4iTM3(@"..........  ERROR: Corrupted file at %@", fileName);
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
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  popUpButtonWillPopUpNotified:
- (void)popUpButtonWillPopUpNotified:(NSNotification *)notification;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSMenu * labelMenu = nil;
	NSMenu * refMenu = nil;
	[[self.window.windowController textStorage] getLaTeXLabelMenu: &labelMenu refMenu: &refMenu];
	NSAssert(labelMenu, @"Missing LaTeX label menu: inconsistency");
	NSAssert(refMenu, @"Missing LaTeX ref menu: inconsistency");
	NSMenuItem * MI = [self.menu deepItemWithAction4iTM3:@selector(gotoLaTeXLabel:)];
	if(MI)
	{
		MI.action = NULL;
		MI.representedObject = @"LaTeX Label Menu";
		[MI.menu setSubmenu: ([labelMenu numberOfItems]? labelMenu:nil) forItem:MI];
	}
	else if(MI = [self.menu deepItemWithRepresentedObject4iTM3:@"LaTeX Label Menu"])
	{
		[MI.menu setSubmenu: ([labelMenu numberOfItems]? labelMenu:nil) forItem:MI];
	}
	if(MI = [self.menu deepItemWithAction4iTM3:@selector(gotoLaTeXReference:)])
	{
		MI.action = NULL;
		MI.representedObject = @"LaTeX Reference Menu";
		[MI.menu setSubmenu: ([refMenu numberOfItems]? refMenu:nil) forItem:MI];
	}
	else if(MI = [self.menu deepItemWithRepresentedObject4iTM3:@"LaTeX Reference Menu"])
	{
		[MI.menu setSubmenu: ([refMenu numberOfItems]? refMenu:nil) forItem:MI];
	}
	labelMenu = [[labelMenu copy] autorelease];
	NSEnumerator * E = [labelMenu.itemArray objectEnumerator];
	while(MI = E.nextObject)
		if(MI.action == @selector(scrollLaTeXLabelToVisible:))
			MI.action = @selector(_insertLaTeXKnownReference:);
	if(MI = [self.menu deepItemWithAction4iTM3:@selector(insertLaTeXKnownReference:)])
	{
		MI.action = NULL;
		MI.representedObject = @"LaTeX Known Reference Menu";
		[MI.menu setSubmenu: ([labelMenu numberOfItems]? labelMenu:nil) forItem:MI];
	}
	else if(MI = [self.menu deepItemWithRepresentedObject4iTM3:@"LaTeX Known Reference Menu"])
	{
		[MI.menu setSubmenu: ([labelMenu numberOfItems]? labelMenu:nil) forItem:MI];
	}
//END4iTM3;
    return;
}
@end

@implementation iTM2LaTeXScriptDocumentButton
@end

@implementation iTM2LaTeXScriptTextButton
@end

@implementation iTM2LaTeXScriptMathButton
@end

@implementation iTM2LaTeXScriptMiscellaneousButton
@end

@implementation iTM2LaTeXScriptGraphicsButton
@end

@implementation iTM2LaTeXScriptUserButton
@end

@implementation iTM2LaTeXScriptRecentButton
@end

#define BUNDLE self.classBundle4iTM3
#define TABLE @"iTM2InsertLaTeX"

@implementation iTM2LaTeXEditor
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= handlesKeyBindings4iTM3
- (BOOL)handlesKeyBindings4iTM3;
/*"YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Dec 15 14:34:51 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  bold4iTM3:
- (void)bold4iTM3:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users.sourceforge.net
To Do List:
"*/
{
//START4iTM3;
#warning: MISSING we should guess the environment, math or text and use the appropriate command
	[self executeMacroWithID4iTM3:@"\\textbf{}|text"];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  italic4iTM3:
- (void)italic4iTM3:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users.sourceforge.net
To Do List:
"*/
{
//START4iTM3;
	[self executeMacroWithID4iTM3:@"\\textit{}|text"];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  smallCaps4iTM3:
- (void)smallCaps4iTM3:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users.sourceforge.net
To Do List:
"*/
{
//START4iTM3;
	[self executeMacroWithID4iTM3:@"\\textsc{}|text"];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  underline:
- (void)underline:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users.sourceforge.net
To Do List:
"*/
{
//START4iTM3;
	[self executeMacroWithID4iTM3:@"\\underline{}|text"];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  alignCenter:
- (void)alignCenter:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users.sourceforge.net
To Do List:
"*/
{
//START4iTM3;
	[self executeMacroWithID4iTM3:@"\\begin{center}..."];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  alignRight:
- (void)alignRight:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users.sourceforge.net
To Do List:
"*/
{
//START4iTM3;
	[self executeMacroWithID4iTM3:@"\\begin{flushright}..."];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  alignLeft:
- (void)alignLeft:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users.sourceforge.net
To Do List:
"*/
{
//START4iTM3;
	[self executeMacroWithID4iTM3:@"\\begin{flushleft}..."];
    return;
}
#if 0
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  turnOffKerning:
- (void)turnOffKerning:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users.sourceforge.net
To Do List:
"*/
{
//START4iTM3;

    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  tightenKerning:
- (void)tightenKerning:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users.sourceforge.net
To Do List:
"*/
{
//START4iTM3;

    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  loosenKerning:
- (void)loosenKerning:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users.sourceforge.net
To Do List:
"*/
{
//START4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  useStandardKerning:
- (void)useStandardKerning:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users.sourceforge.net
To Do List:
"*/
{
//START4iTM3;

    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  turnOffLigatures:
- (void)turnOffLigatures:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users.sourceforge.net
To Do List:
"*/
{
//START4iTM3;

    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  useStandardLigatures:
- (void)useStandardLigatures:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users.sourceforge.net
To Do List:
"*/
{
//START4iTM3;

    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  useAllLigatures:
- (void)useAllLigatures:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users.sourceforge.net
To Do List:
"*/
{
//START4iTM3;

    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  raiseBaseline:
- (void)raiseBaseline:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users.sourceforge.net
To Do List:
"*/
{
//START4iTM3;

    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  lowerBaseline:
- (void)lowerBaseline:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users.sourceforge.net
To Do List:
"*/
{
//START4iTM3;

    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  toggleTraditionalCharacterShape:
- (void)toggleTraditionalCharacterShape:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users.sourceforge.net
To Do List:
"*/
{
//START4iTM3;

    return;
}
#endif
#if 0
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  alignJustified:
- (void)alignJustified:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users.sourceforge.net
To Do List:
"*/
{
//START4iTM3;
    return;
}
#endif
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  completeLaTeXEnvironment:
- (void) completeLaTeXEnvironment: (id) sender;
/*"Desription Forthcoming.
Version history: jlaurens AT users.sourceforge.net
- 1.3: 02/03/2003
To Do List:
"*/
{
//NSLog(@"-[%@ %@] 0x%x", self.class, NSStringFromSelector(_cmd), self);
    // find what is the name of the current environment...
    NSString * name = [self.string lossyLaTeXEnvironmentNameAtIndex: self.selectedRange.location];
    if(name.length)
    {
        [self insertText:[NSString stringWithFormat: @"\\end{%@}", name]];
    }
    else
    {
        // Nothing was found: stop it here
        NSBeep();
        [self postNotificationWithToolTip4iTM3:
            NSLocalizedStringFromTableInBundle(@"No open environment found.", @"TeX", [NSBundle bundleForClass:self.class], "used in completeLaTeXEnvironment")];
    }
    return;
}
#pragma mark -
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertControl:
- (void)insertControl:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users.sourceforge.net
- < 1.1: 03/10/2002
To Do List: Nothing at first glance.
"*/
{
//NSLog(@"-[%@ %@] 0x%x", self.class, NSStringFromSelector(_cmd), self);
    BOOL escaped;
    NSString * S = self.string;
    NSRange R = self.selectedRange;
    if(!R.location || ![S isControlAtIndex:R.location-1 escaped: &escaped] || escaped)
    {
        [self insertText:[NSString backslashString]];
    }
    else
    {
        [self.undoManager beginUndoGrouping];
        [self insertText:[NSString backslashString]];
        [self insertNewline:self];
        [self.undoManager endUndoGrouping];
    }
    return;
}
#pragma mark =-=-=-=-=-  LABELS & REFERENCES
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertLaTeXLabel:
- (IBAction)insertLaTeXLabel:(id)sender;
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[self executeMacroWithID4iTM3:@"\\label{identifier}"];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateInsertLaTeXLabel:
- (BOOL)validateInsertLaTeXLabel:(id)sender;
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  gotoLaTeXLabel:
- (IBAction)gotoLaTeXLabel:(NSControl *)sender;
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 10 19:50:59 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSInteger tag = sender.tag;
	NSString * S = [self.textStorage string];
	if (tag>=ZER0 && tag<S.length) {
		NSUInteger begin, end;
		[S getLineStart: &begin end: &end contentsEnd:nil forRange:iTM3MakeRange(tag, ZER0)];
		[self highlightAndScrollToVisibleRange:iTM3MakeRange(begin, end-begin)];
	}
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateGotoLaTeXLabel:
- (BOOL)validateGotoLaTeXLabel:(id)sender;
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertLaTeXReference:
- (IBAction)insertLaTeXReference:(id)sender;
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[self executeMacroWithID4iTM3:@"\\ref{identifier}"];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateInsertLaTeXReference:
- (BOOL)validateInsertLaTeXReference:(id)sender;
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  gotoLaTeXReference:
- (IBAction)gotoLaTeXReference:(id)sender;
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateGotoLaTeXReference:
- (BOOL)validateGotoLaTeXReference:(id)sender;
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertLaTeXEquationReference:
- (IBAction)insertLaTeXEquationReference:(id)sender;
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[self executeMacroWithID4iTM3:@"\\eqref{identifier}"];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateInsertLaTeXEquationReference:
- (BOOL)validateInsertLaTeXEquationReference:(id)sender;
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  gotoLaTeXEquationReference:
- (IBAction)gotoLaTeXEquationReference:(id)sender;
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateGotoLaTeXEquationReference:
- (BOOL)validateGotoLaTeXEquationReference:(id)sender;
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  _insertLaTeXKnownReference:
- (IBAction)_insertLaTeXKnownReference:(NSMenuItem *)sender;
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSString * domain = self.macroDomain;
	NSString * category = self.macroCategory;
	NSString * context = self.macroContext;
	NSString * knownReference = sender.representedObject;
	iTM2MacroNode * leafNode = [SMC macroRunningNodeForID:@"\\ref{}|identifier" context:context ofCategory:category inDomain:domain];
	NSDictionary * substitutions = [NSDictionary dictionaryWithObject:knownReference forKey:@"identifier"];
	[leafNode executeMacroWithTarget:self selector:NULL substitutions:substitutions];
//END4iTM3;
    return;
}
#pragma mark =-=-=-=-=-  SECTIONS
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  gotoLaTeXSection:
- (IBAction)gotoLaTeXSection:(NSMenuItem *)sender;
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSInteger tag = sender.tag;
	NSString * S = [self.textStorage string];
	if (tag>=ZER0 && tag<S.length) {
		NSUInteger begin, end;
		[S getLineStart: &begin end: &end contentsEnd:nil forRange:iTM3MakeRange(tag, ZER0)];
		[self highlightAndScrollToVisibleRange:iTM3MakeRange(begin, end-begin)];
	}
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateGotoLaTeXSection:
- (BOOL)validateGotoLaTeXSection:(id)sender;
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertLaTeXChapter:
- (IBAction)insertLaTeXChapter:(id)sender;
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[self executeMacroWithID4iTM3:@"\\chapter{}|text_content"];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateInsertLaTeXChapter:
- (BOOL)validateInsertLaTeXChapter:(id)sender;
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertLaTeXPart:
- (IBAction)insertLaTeXPart:(id)sender;
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[self executeMacroWithID4iTM3:@"\\part{}|text"];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateInsertLaTeXPart:
- (BOOL)validateInsertLaTeXPart:(id)sender;
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertLaTeXSection:
- (IBAction)insertLaTeXSection:(id)sender;
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[self executeMacroWithID4iTM3:@"\\section{}|text"];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateInsertLaTeXSection:
- (BOOL)validateInsertLaTeXSection:(id)sender;
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertLaTeXSubSection:
- (IBAction)insertLaTeXSubSection:(id)sender;
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[self executeMacroWithID4iTM3:@"\\subsection{}|text"];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateInsertLaTeXSubSection:
- (BOOL)validateInsertLaTeXSubSection:(id)sender;
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertLaTeXSubSubSection:
- (IBAction)insertLaTeXSubSubSection:(id)sender;
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[self executeMacroWithID4iTM3:@"\\subsubsection{}|text"];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateInsertLaTeXSubSubSection:
- (BOOL)validateInsertLaTeXSubSubSection:(id)sender;
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertLaTeXParagraph:
- (IBAction)insertLaTeXParagraph:(id)sender;
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[self executeMacroWithID4iTM3:@"\\paragraph{}|text"];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateInsertLaTeXParagraph:
- (BOOL)validateInsertLaTeXParagraph:(id)sender;
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertLaTeXSubParagraph:
- (IBAction)insertLaTeXSubParagraph:(id)sender;
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[self executeMacroWithID4iTM3:@"\\subparagraph{}|text"];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateInsertLaTeXSubParagraph:
- (BOOL)validateInsertLaTeXSubParagraph:(id)sender;
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  scrollLaTeXLabelToVisible:
- (void)scrollLaTeXLabelToVisible:(id)sender;
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  scrollLaTeXReferenceToVisible:
- (void)scrollLaTeXReferenceToVisible:(id)sender;
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
Latest Revision: Wed Mar 10 19:53:19 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSString * path = [[sender.menu.title  stringByAppendingPathComponent:
                                sender.representedObject] stringByStandardizingPath];
    if ([DFM isReadableFileAtPath:path]) {
        [SDC openDocumentWithContentsOfURL:[NSURL fileURLWithPath:path] display:YES error:nil];
    } else {
        NSString * P = [path stringByAppendingPathExtension:@"tex"];
        if ([DFM isReadableFileAtPath:P]) {
            [SDC openDocumentWithContentsOfURL:[NSURL fileURLWithPath:P] display:YES error:nil];
        } else {
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  delayedScrollInputToVisible:
- (void)delayedScrollInputToVisible:(NSMenuItem *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
#warning To be improved
    NSString * path = [[sender.menu.title  stringByAppendingPathComponent:
                                sender.representedObject] stringByStandardizingPath];
    if([DFM isReadableFileAtPath:path]) {
        [SDC openDocumentWithContentsOfURL:[NSURL fileURLWithPath:path] display:YES error:nil];
    } else {
        NSString * P = [path stringByAppendingPathExtension:@"tex"];
        if ([DFM isReadableFileAtPath:P]) {
            [SDC openDocumentWithContentsOfURL:[NSURL fileURLWithPath:P] display:YES error:nil];
        } else {
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  scrollInputToVisible:
- (void)scrollInputToVisible:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[self performSelector:@selector(delayedScrollInputToVisible:) withObject:sender afterDelay:0.1];
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  findLaTeXEnvironment:
- (void)findLaTeXEnvironment:(id)sender;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 02/03/2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    // find what is the name of the current environment...
    NSRange range;
    [self.string LaTeXEnvironmentNameForRange:self.selectedRange effectiveRange: &range];
    if(range.location == NSNotFound)
    {
        // Nothing was found: stop it here
        NSBeep();
        [self postNotificationWithToolTip4iTM3:
            NSLocalizedStringFromTableInBundle(@"No environment found.", @"TeX", [NSBundle bundleForClass:self.class], "used in completeLaTeXEnvironment")];
    }
    else
    {
        [self setSelectedRange:[self.string rangeBySelectingParagraphIfNeededWithRange4iTM3:range]];
    }
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  mouseDown:
- (void)mouseDown:(NSEvent * )event
/*"Description Forthcoming
Version history: jlaurens AT users.sourceforge.net
- < 1.1: 03/10/2002
To Do List:
"*/
{
//START4iTM3;
    if((event.clickCount>2) && ![iTM2EventObserver isAlternateKeyDown])
    {
//NSLog(@"event.clickCount: %i", event.clickCount);
        NSString * S = self.string;
        NSRange SR = self.selectedRange;
		// trimming the white spaces in the selected range 
        NSRange CR = SR;
		NSCharacterSet * set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
		while(CR.length && [set characterIsMember:[S characterAtIndex:CR.location+CR.length-1]])
		{
			--CR.length;
		}
		while(CR.length && [set characterIsMember:[S characterAtIndex:CR.location]])
		{
			++CR.location;
			--CR.length;
		}
        NSRange GR = [S groupRangeForRange:SR];
//NSLog(NSStringFromRange(GR));
        NSRange ER;// environment range
        [S LaTeXEnvironmentNameForRange:CR effectiveRange: &ER];
        NSUInteger start, end;
        [S getLineStart: &start end: &end contentsEnd:nil forRange:CR];
        end -= start;
        NSRange PR = (end>SR.length)? iTM3MakeRange(start, end): iTM3MakeRange(ZER0, S.length);
        if(GR.location == NSNotFound)
        {
            if(ER.location == NSNotFound)
            {
                [self setSelectedRange:PR];
                return;
            }
            else
            {
                ER = [S rangeBySelectingParagraphIfNeededWithRange4iTM3:ER];
				if((ER.location<=PR.location) && (iTM3MaxRange(ER)>=iTM3MaxRange(PR)))
					ER = PR;
				else if(iTM3LocationInRange(ER.location, PR))
					PR = ER;
				else if(iTM3LocationInRange(iTM3MaxRange(ER)-1, PR))
					PR = ER;
                [self setSelectedRange: (PR.length<ER.length? PR:ER)];
                return;
            }
        }
        else if(ER.location == NSNotFound)
        {
			if((GR.location<=PR.location) && (iTM3MaxRange(GR)>=iTM3MaxRange(PR)))
				GR = PR;
			else if(iTM3LocationInRange(GR.location, PR))
				PR = GR;
			else if(iTM3LocationInRange(iTM3MaxRange(GR)-1, PR))
				PR = GR;
			[self setSelectedRange: (GR.length<PR.length? GR:PR)];
            return;
        }
        else
        {
            ER = [S rangeBySelectingParagraphIfNeededWithRange4iTM3:ER];
			// if PR is included in ER, we choose PR
			// we prefer consistant selections
//LOG4iTM3(@"ER: %@", NSStringFromRange(ER));
//LOG4iTM3(@"GR: %@", NSStringFromRange(GR));
//LOG4iTM3(@"PR: %@", NSStringFromRange(PR));
			if((ER.location<=PR.location) && (iTM3MaxRange(ER)>=iTM3MaxRange(PR)))
				ER = PR;
			else if(iTM3LocationInRange(ER.location, PR))
				PR = ER;
			else if(iTM3LocationInRange(iTM3MaxRange(ER)-1, PR))
				PR = ER;
			if((GR.location<=PR.location) && (iTM3MaxRange(GR)>=iTM3MaxRange(PR)))
				GR = PR;
			else if(iTM3LocationInRange(GR.location, PR))
				PR = GR;
			else if(iTM3LocationInRange(iTM3MaxRange(GR)-1, PR))
				PR = GR;
            if(GR.length>ER.length)
                GR = ER;
            if(GR.length>PR.length)
                GR = PR;
            [self setSelectedRange:GR];
            return;
        }
    }
    else
        [super mouseDown:event];
    return;
}
@end

@interface NSString (iTM2LaTeXKit_PRIVATE)
- (NSRange)_nextLaTeXEnvironmentDelimiterRangeAfterIndex:(NSUInteger)index effectiveName:(NSString **)namePtr isOpening:(BOOL *)flagPtr;
- (NSRange)_previousLaTeXEnvironmentDelimiterRangeBeforeIndex:(NSUInteger)index effectiveName:(NSString **)namePtr isOpening:(BOOL *)flagPtr;
@end

@implementation NSString (iTM2LaTeXKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= LaTeXEnvironmentNameForRange:effectiveRange:
- (NSString *)LaTeXEnvironmentNameForRange:(NSRange)range effectiveRange:(NSRangePointer)rangePtr;
/*"Given a selected range, returns the name of the latex environment and the effective range.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 02/03/2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSMutableArray * nameStack = [NSMutableArray array];
    NSString * name;
    BOOL isOpening;
    NSRange R = [self _previousLaTeXEnvironmentDelimiterRangeBeforeIndex: (range.location<self.length? range.location+1:range.location) effectiveName: &name isOpening: &isOpening];
    if(R.location == NSNotFound)
        goto bail;
    if((range.location>=R.location) && (iTM3MaxRange(range)<=iTM3MaxRange(R)))
    {
//LOG4iTM3(@"Inside a latex environment delimiter...");
        // we just have to balance this range
        [nameStack addObject:name];
        if(isOpening)
        {
//LOG4iTM3(@"Opening...");
            NSUInteger anchor = R.location;
            NSString * otherName;
faaa:
            R = [self _nextLaTeXEnvironmentDelimiterRangeAfterIndex:iTM3MaxRange(R) effectiveName: &otherName isOpening: &isOpening];
            if(R.location == NSNotFound)
                goto bail;
            if(isOpening)
            {
                [nameStack addObject:otherName];
                goto faaa;
            }
            if(![otherName isEqualToString:nameStack.lastObject])
                goto bail;
            if(nameStack.count>1)
            {
                [nameStack removeLastObject];
                goto faaa;
            }
            if(rangePtr)
                *rangePtr = iTM3MakeRange(anchor, iTM3MaxRange(R)-anchor);
            return nameStack.lastObject;
        }
        else
        {
//LOG4iTM3(@"Closing...");
            NSUInteger anchor = iTM3MaxRange(R);
            NSString * otherName;
fakarava:
            R = [self _previousLaTeXEnvironmentDelimiterRangeBeforeIndex:R.location effectiveName: &otherName isOpening: &isOpening];
            if(R.location == NSNotFound)
            {
                 [self postNotificationWithToolTip4iTM3:
                    [NSString stringWithFormat:
                        NSLocalizedStringFromTableInBundle(@"Missing \\begin{%@}.", @"TeX",
                            self.classBundle4iTM3, "used in LaTeX Environment management"), nameStack.lastObject]];
                iTM2Beep();
                goto bail;
            }
            if(isOpening)
            {
                if(![otherName isEqualToString:nameStack.lastObject])
                {
                    [self postNotificationWithToolTip4iTM3:
                        [NSString stringWithFormat:
                            NSLocalizedStringFromTableInBundle(@"Missing \\begin{%@}.", @"TeX",
                                self.classBundle4iTM3, "used in LaTeX Environment management"), nameStack.lastObject]];
                    iTM2Beep();
                    goto bail;
                }
                if(nameStack.count>1)
                {
                    [nameStack removeLastObject];
                    goto fakarava;
                }
//LOG4iTM3(@"Normal...");
                if(rangePtr)
                    *rangePtr = iTM3MakeRange(R.location, anchor-R.location);
                return nameStack.lastObject;
            }
            [nameStack addObject:otherName];
            goto fakarava;
        }
        //unreachable code
    }
//LOG4iTM3(@"*****  NOT Inside a delimiter...");

	// we start by balancing this range

    NSUInteger leftAnchor = R.location;
    NSUInteger rightAnchor = iTM3MaxRange(R);
manihi:
    [nameStack addObject:name];
//LOG4iTM3(@"nameStack.lastObject: %@", nameStack.lastObject);
    if(isOpening)
    {
//LOG4iTM3(@"is opening");
        NSString * otherName;
huahine:
        R = [self _nextLaTeXEnvironmentDelimiterRangeAfterIndex:rightAnchor effectiveName: &otherName isOpening: &isOpening];
        if(R.location == NSNotFound)
            goto bail;
        if(isOpening)
        {
            [nameStack addObject:otherName];
            rightAnchor = iTM3MaxRange(R);
            goto huahine;
        }
        if(![otherName isEqualToString:nameStack.lastObject])
            goto bail;
        if(nameStack.count>1)
        {
            [nameStack removeLastObject];
            rightAnchor = iTM3MaxRange(R);
            goto huahine;
        }
        rightAnchor = iTM3MaxRange(R);
        if(iTM3MaxRange(range)<rightAnchor)
        {
            if(rangePtr)
                *rangePtr = iTM3MakeRange(leftAnchor, rightAnchor-leftAnchor);
            return nameStack.lastObject;
        }
        [nameStack removeLastObject];
        R = [self _previousLaTeXEnvironmentDelimiterRangeBeforeIndex:leftAnchor effectiveName: &name isOpening: &isOpening];
        if(R.location == NSNotFound)
            goto bail;
        leftAnchor = R.location;
        goto manihi;
    }
    else
    {
//LOG4iTM3(@"is closing");
        NSString * otherName;
taiao:
        R = [self _previousLaTeXEnvironmentDelimiterRangeBeforeIndex:leftAnchor effectiveName: &otherName isOpening: &isOpening];
        if(R.location == NSNotFound)
        {
            [self postNotificationWithToolTip4iTM3:
                [NSString stringWithFormat:
                    NSLocalizedStringFromTableInBundle(@"Missing \\begin{%@}.", @"TeX",
                        self.classBundle4iTM3, "used in LaTeX Environment management"), nameStack.lastObject]];
            iTM2Beep();
            goto bail;
        }
        leftAnchor = R.location;
        if(isOpening)
        {
            if(![otherName isEqualToString:nameStack.lastObject])
            {
                [self postNotificationWithToolTip4iTM3:
                    [NSString stringWithFormat:
                        NSLocalizedStringFromTableInBundle(@"Missing \\begin{%@}.", @"TeX",
                            self.classBundle4iTM3, "used in LaTeX Environment management"), nameStack.lastObject]];
                iTM2Beep();
                goto bail;
            }
            [nameStack removeLastObject];
            if(nameStack.count)
                goto taiao;
            R = [self _previousLaTeXEnvironmentDelimiterRangeBeforeIndex:leftAnchor effectiveName: &name isOpening: &isOpening];
            if(R.location == NSNotFound)
                goto bail;
            leftAnchor = R.location;
            goto manihi;
        }
        else
        {
            [nameStack addObject:otherName];
            goto taiao;
        }
    }
    bail:
    if(rangePtr)
        *rangePtr = iTM3MakeRange(NSNotFound, ZER0);
    return [NSString string];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= lossyLaTeXEnvironmentNameAtIndex:
- (NSString *)lossyLaTeXEnvironmentNameAtIndex:(NSUInteger)index;
/*"Given an index, returns the name of the latex environment.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 02/03/2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSMutableArray * nameStack = [NSMutableArray array];
    NSString * name;
    BOOL isOpening;
    NSRange R = [self _previousLaTeXEnvironmentDelimiterRangeBeforeIndex:index effectiveName: &name isOpening: &isOpening];
    if(R.location == NSNotFound)
        return [NSString string];
    if((index>R.location) && (index<iTM3MaxRange(R)))
        return [NSString string];
    
//LOG4iTM3(@"*****  NOT Inside a delimiter...");

        // we start by balancing this range
        
    NSUInteger leftAnchor = R.location;
    NSUInteger rightAnchor = iTM3MaxRange(R);
    manihi:
    [nameStack addObject:name];
//LOG4iTM3(@"nameStack.lastObject: %@", nameStack.lastObject);
    if(isOpening)
    {
//LOG4iTM3(@"is opening");
        NSString * otherName;
        huahine:
        R = [self _nextLaTeXEnvironmentDelimiterRangeAfterIndex:rightAnchor effectiveName: &otherName isOpening: &isOpening];
        if(R.location == NSNotFound)
        // eureka
            return nameStack.lastObject;
        else if(isOpening)
        {
            // a new envir is open, we must close it first
            [nameStack addObject:otherName];
            rightAnchor = iTM3MaxRange(R);
            goto huahine;
        }
        else if(![otherName isEqualToString:nameStack.lastObject])
        // a closing environment which is not the current environment
        {
            if(index<=R.location)
                return nameStack.lastObject;
            else
                goto bail;
        }
        else if(nameStack.count>1)
        {
            [nameStack removeLastObject];
            rightAnchor = iTM3MaxRange(R);
            goto huahine;
        }
        rightAnchor = iTM3MaxRange(R);
        if(index<=R.location)
            return nameStack.lastObject;
        else if(index<rightAnchor)
            goto bail;
        [nameStack removeLastObject];
        R = [self _previousLaTeXEnvironmentDelimiterRangeBeforeIndex:leftAnchor effectiveName: &name isOpening: &isOpening];
        if(R.location == NSNotFound)
            goto bail;
        leftAnchor = R.location;
        goto manihi;
    }
    else
    {
//LOG4iTM3(@"is closing");
        NSString * otherName;
        taiao:
        R = [self _previousLaTeXEnvironmentDelimiterRangeBeforeIndex:leftAnchor effectiveName: &otherName isOpening: &isOpening];
        if(R.location == NSNotFound)
        {
            [self postNotificationWithToolTip4iTM3:
                [NSString stringWithFormat:
                    NSLocalizedStringFromTableInBundle(@"Missing \\begin{%@}.", @"TeX",
                        self.classBundle4iTM3, "used in LaTeX Environment management"), nameStack.lastObject]];
            iTM2Beep();
            goto bail;
        }
        leftAnchor = R.location;
        if(isOpening)
        {
            if(![otherName isEqualToString:nameStack.lastObject])
            {
                [self postNotificationWithToolTip4iTM3:
                    [NSString stringWithFormat:
                        NSLocalizedStringFromTableInBundle(@"Missing \\begin{%@}.", @"TeX",
                            self.classBundle4iTM3, "used in LaTeX Environment management"), nameStack.lastObject]];
                iTM2Beep();
                goto bail;
            }
            [nameStack removeLastObject];
            if(nameStack.count)
                goto taiao;
            R = [self _previousLaTeXEnvironmentDelimiterRangeBeforeIndex:leftAnchor effectiveName: &name isOpening: &isOpening];
            if(R.location == NSNotFound)
                goto bail;
            leftAnchor = R.location;
            goto manihi;
        }
        else
        {
            [nameStack addObject:otherName];
            goto taiao;
        }
    }
    bail:
    return [NSString string];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= _nextLaTeXEnvironmentDelimiterRangeAfterIndex:effectiveName:isOpening:
- (NSRange)_nextLaTeXEnvironmentDelimiterRangeAfterIndex:(NSUInteger)index effectiveName:(NSString **)namePtr isOpening:(BOOL *)flagPtr;
/*"Returns the first occurrence of something like regexp "\\begin\s*([.*?]\s*)*\{(.*?)\}" or \\end... (quite...)
searchRange.location<=result.location < index, result.location is the max
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 02/03/2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSRange R = [self _previousLaTeXEnvironmentDelimiterRangeBeforeIndex: (index<self.length?index+1:index) effectiveName:namePtr isOpening:flagPtr];
    if(index < iTM3MaxRange(R))
        return R;
    iTM2LiteScanner * S = [iTM2LiteScanner scannerWithString:self charactersToBeSkipped:[NSCharacterSet whitespaceCharacterSet]];
    faaa:
    if(index < self.length)
    {
        R = [self rangeOfString:[NSString backslashString] options:ZER0 range:iTM3MakeRange(index, self.length-index)];
        if(R.location == NSNotFound)
            goto bail;
        BOOL escaped = NO;
        index = iTM3MaxRange(R);
        if(R.location && [self isControlAtIndex:R.location-1 escaped: &escaped] && !escaped)
            goto faaa;
        NSUInteger anchor = R.location;
        NSRange searchRange = iTM3MakeRange(anchor+1, self.length-anchor-1);
        R = [self rangeOfString:@"end" options:NSAnchoredSearch range:searchRange];
        if(R.location == NSNotFound)
        {
            R = [self rangeOfString:@"begin" options:NSAnchoredSearch range:searchRange];
            if(R.location == NSNotFound)
                goto faaa;
            index = iTM3MaxRange(R);
            [S setScanLocation:index];
            while([S scanString:@"[" intoString:nil])
            {
                R = [self groupRangeAtIndex:S.scanLocation-1 beginDelimiter: '[' endDelimiter: ']'];
                if(R.location == NSNotFound)
                {
                    iTM2Beep();
                    [self postNotificationWithToolTip4iTM3:
                        NSLocalizedStringFromTableInBundle(@"Bad optional LaTeX environment parameter.", @"TeX",
                                self.classBundle4iTM3, "used in completeLaTeXEnvironment")];
                    goto bail;
                }
                index = iTM3MaxRange(R);
                S.scanLocation = index;
            }
            if(![S scanString:@"{" intoString:nil])
                goto bail;
            NSString * envirName = nil;
            if(![S scanUpToString:@"}" intoString: &envirName])
                goto bail;
            if(envirName.length)
            {
                if(namePtr)
                    *namePtr = [[envirName stringByAppendingString:@" "]
                        stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
                if(flagPtr)
                    *flagPtr = YES;
                return iTM3MakeRange(anchor, [S scanLocation]+1-anchor);
            }
        }
        else
        {
            index = iTM3MaxRange(R);
            [S setScanLocation:index];
            if(![S scanString:@"{" intoString:nil])
                goto bail;
            NSString * envirName = nil;
            if(![S scanUpToString:@"}" intoString: &envirName])
                goto bail;
            if(envirName.length)
            {
                if(namePtr)
                    *namePtr = [[envirName stringByAppendingString:@" "]
                        stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
                if(flagPtr)
                    *flagPtr = NO;
                return iTM3MakeRange(anchor, [S scanLocation]+1-anchor);
            }
        }
    }
    bail:
    if(namePtr)
        *namePtr = @"";
    if(flagPtr)
        *flagPtr = NO;// irrelevant!!!
    return iTM3MakeRange(NSNotFound, ZER0);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= _previousLaTeXEnvironmentDelimiterRangeBeforeIndex:effectiveName:isOpening:
- (NSRange)_previousLaTeXEnvironmentDelimiterRangeBeforeIndex:(NSUInteger)index effectiveName:(NSString **)namePtr isOpening:(BOOL *)flagPtr;
/*"Returns the first occurrence of something like regexp "\\begin\s*([.*?]\s*)*\{(.*?)\}" or \\end... (quite...)
searchRange.location<=result.location < index, result.location is the max
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 02/03/2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    iTM2LiteScanner * S = [iTM2LiteScanner scannerWithString:self charactersToBeSkipped:[NSCharacterSet whitespaceCharacterSet]];
    faaa:
    if(index <= self.length)
    {
        NSRange R = [self rangeOfString:[NSString backslashString] options:NSBackwardsSearch range:iTM3MakeRange(ZER0, index)];
        if(R.location == NSNotFound)
            goto bail;
        BOOL escaped = NO;
        index = R.location;
        if(R.location && [self isControlAtIndex:R.location-1 escaped: &escaped] && !escaped)
            goto faaa;
        NSUInteger anchor = R.location;
        NSRange searchRange = iTM3MakeRange(anchor+1, self.length-anchor-1);
        R = [self rangeOfString:@"end" options:NSAnchoredSearch range:searchRange];
        if(R.location == NSNotFound)
        {
            R = [self rangeOfString:@"begin" options:NSAnchoredSearch range:searchRange];
            if(R.location == NSNotFound)
                goto faaa;
            index = iTM3MaxRange(R);
            [S setScanLocation:index];
            while([S scanString:@"[" intoString:nil])
            {
                R = [self groupRangeAtIndex:[S scanLocation]-1 beginDelimiter: '[' endDelimiter: ']'];
                if(R.location == NSNotFound)
                {
                    iTM2Beep();
                    [self postNotificationWithToolTip4iTM3:
                        NSLocalizedStringFromTableInBundle(@"Bad optional LaTeX environment parameter.", @"TeX",
                                self.classBundle4iTM3, "used in completeLaTeXEnvironment")];
                    goto bail;
                }
                index = iTM3MaxRange(R);
                [S setScanLocation:index];
            }
            if(![S scanString:@"{" intoString:nil])
                goto bail;
            NSString * envirName = nil;
            if(![S scanUpToString:@"}" intoString: &envirName])
                goto bail;
            if(envirName.length)
            {
                if(namePtr)
                    *namePtr = [[envirName stringByAppendingString:@" "]
                        stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
                if(flagPtr)
                    *flagPtr = YES;
//LOG4iTM3(envirName);
                return iTM3MakeRange(anchor, [S scanLocation]+1-anchor);
            }
        }
        else
        {
            index = iTM3MaxRange(R);
            [S setScanLocation:index];
            if(![S scanString:@"{" intoString:nil])
                goto bail;
            NSString * envirName = nil;
            if(![S scanUpToString:@"}" intoString: &envirName])
                goto bail;
            if(envirName.length)
            {
                if(namePtr)
                    *namePtr = [[envirName stringByAppendingString:@" "]
                        stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
                if(flagPtr)
                    *flagPtr = NO;
//LOG4iTM3(envirName);
                return iTM3MakeRange(anchor, [S scanLocation]+1-anchor);
            }
        }
    }
    bail:
    if(namePtr)
        *namePtr = @"";
    if(flagPtr)
        *flagPtr = NO;// irrelevant!!!
//LOG4iTM3(@"NO environment");
    return iTM3MakeRange(NSNotFound, ZER0);
}
@end

@implementation iTM2LaTeXWindow
@end

@implementation iTM2LaTeXParserAttributesServer
@end

@implementation iTM2XtdLaTeXParserAttributesServer
@end

static NSArray * _iTM2LaTeXModeForModeArray = nil;

#define _TextStorage (iTM2TextStorage *)iVarTS4iTM3

@implementation NSTextView(iTM2LaTeXKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  proposedRangeForLaTeXUserCompletion:
- (NSRange)proposedRangeForLaTeXUserCompletion:(NSRange)range;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 02/03/2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if(range.location)
	{
		NSString * S = self.string;
		unichar theChar = [S characterAtIndex:range.location-1];
		if(theChar == '\\')
		{
			--range.location;
			++range.length;
		}
	}
//END4iTM3;
	return range;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  concreteReplacementStringForLaTeXMacro4iTM3:selection:line:
- (NSString *)concreteReplacementStringForLaTeXMacro4iTM3:(NSString *)macro selection:(NSString *)selectedString line:(NSString *)line;
/*"Description forthcoming. Will be completely overriden by subclassers.
Version history: jlaurens AT users DOT sourceforge DOT net (1.0.10)
- 1.2: 06/24/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	// what is the policy of the replacement?
	// first split the whole string into tokens
	if([macro hasPrefix:@"\\"])
	{
		NSMutableString * replacementString = [NSMutableString string];
		NSArray * components = [macro componentsSeparatedByString:@"|"];
		NSEnumerator * E = components.objectEnumerator;
		macro = E.nextObject;
		components = [macro componentsSeparatedByString:@"[]"];
		NSString * separator = @"%&$#@!,?";
		NSString * connector = [NSString stringWithFormat:@"%@O%@",separator,separator];// O-ptional
		macro = [components componentsJoinedByString:connector];
		components = [macro componentsSeparatedByString:@"{}"];
		connector = [NSString stringWithFormat:@"%@M%@",separator,separator];// M-andatory
		macro = [components componentsJoinedByString:connector];
		components = [macro componentsSeparatedByString:@"(,)"];
		connector = [NSString stringWithFormat:@"%@P%@",separator,separator];// P-ositional
		macro = [components componentsJoinedByString:connector];
		components = [macro componentsSeparatedByString:separator];
		NSEnumerator * EE = components.objectEnumerator;
		NSString * component;
		while(component = EE.nextObject)
		{
			[replacementString appendString:component];
			if(component = EE.nextObject)
			{
				NSString * argument;
				if([component isEqual:@"M"])
				{
					[replacementString appendString:@"{__("];
					argument = E.nextObject;
					if(!argument.length)
					{
						argument = selectedString;
					}
					[replacementString appendString:argument];			
					[replacementString appendString:@")__}"];
				}
				else if([component isEqual:@"O"])
				{
					[replacementString appendString:@"__([__("];
					argument = E.nextObject;
					if(argument.length == ZER0)
					{
						argument = selectedString;
					}
					[replacementString appendString:argument];			
					[replacementString appendString:@")__])__"];
				}
				else if([component isEqual:@"P"])
				{
					[replacementString appendString:@"__((__("];
					argument = E.nextObject;
					if(argument.length == ZER0)
					{
						argument = selectedString;
					}
					[replacementString appendString:argument];			
					[replacementString appendString:@")__,__("];
					argument = E.nextObject;
					if(argument.length == ZER0)
					{
						argument = selectedString;
					}
					[replacementString appendString:argument];			
					[replacementString appendString:@")__))__"];
				}
			}
		}
		NSRange R = [macro doubleClickAtIndex:ZER0];
		if(R.length == macro.length)
		{
			[replacementString appendString:@" "];
		}
		macro = replacementString;
	}
	else
	{
		ICURegEx * RE = [ICURegEx regExWithSearchPattern:@"^([^\\{\\}]*)\\{\\}([^\\{\\}]*)$" error:NULL];
		if([RE matchString:macro])
		{
			macro = [NSString stringWithFormat:
				([self context4iTM3BoolForKey:@"iTM2DontUseSmartMacros" domain:iTM2ContextAllDomainsMask]?@"%@{%@}%@":@"%@{__(%@)__}%@"),
				[RE substringOfCaptureGroupAtIndex:1],selectedString,[RE substringOfCaptureGroupAtIndex:2]];
			[RE forget];
		}
		else
		{
			RE = [ICURegEx regExWithSearchPattern:@"^([^\\[\\]]*)\\[\\]([^\\[\\]]*)$" error:NULL];
			if([RE matchString:macro])
			{
				macro = [NSString stringWithFormat:
					([self context4iTM3BoolForKey:@"iTM2DontUseSmartMacros" domain:iTM2ContextAllDomainsMask]?@"%@[%@]%@":@"%@[__(%@)__]%@"),
					[RE substringOfCaptureGroupAtIndex:1],selectedString,[RE substringOfCaptureGroupAtIndex:2]];
				[RE forget];
			}
		}
	}
	macro = (id)[self concreteReplacementStringForMacro4iTM3:macro selection:selectedString line:line];
//END4iTM3;
   return macro;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  smartLaTeXMacroWithMacro:substitutions;
- (NSString *)smartLaTeXMacroWithMacro:(NSString *)macro substitutions:(NSDictionary *)substitutions;
/*"Description forthcoming. Will be completely overriden by subclassers.
Version history: jlaurens AT users DOT sourceforge DOT net (1.0.10)
Latest Revision: Wed Mar 10 19:57:05 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (substitutions.count) {
		NSMutableString * argument = [macro mutableCopy];
		for (NSString * old in substitutions.keyEnumerator) {
			NSString * new = [substitutions objectForKey:old];
			NSRange searchRange = iTM3MakeRange(ZER0,argument.length);
			[argument replaceOccurrencesOfString:old withString:new options:ZER0 range:searchRange];
		}
		macro = [NSString stringWithString:argument];
	}
//END4iTM3;
    return macro;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  useLaTeXPackage:
- (IBAction)useLaTeXPackage:(NSButton *)sender;
/*".
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 10 19:57:24 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	BOOL escaped;
	NSUInteger end;
    if ([sender isKindOfClass:[NSButton class]]) {
		// what?
		NSString * packageName = sender.title;
		NSString * actionName = [NSString stringWithFormat:@"useLaTeXPackage_%@:",packageName];
		SEL action = NSSelectorFromString(actionName);
		if ([self respondsToSelector:action]) {
			[self performSelector:action withObject:nil];
			return;
		}
        iTM2StringController * SC = self.stringController4iTM3;
		NSString * what = [NSString stringWithFormat:@"%@\\usepackage{%@}\n%@",SC.startPlaceholderMark, packageName, SC.stopPlaceholderMark];
		// where
		// find the last usepackage used
		NSString * S = self.string;
		NSRange searchRange = iTM3MakeRange(ZER0,S.length);
		NSRange R;
mordor:
		R = [S rangeOfString:@"usepackage" options:ZER0 range:searchRange];
		if (R.length) {
			if ((R.location>ZER0) && [S isControlAtIndex:R.location-1 escaped:&escaped] && !escaped) {
next_usepackage:
				searchRange.location = iTM3MaxRange(R);
				searchRange.length = S.length - searchRange.location;
				NSRange nextR = [S rangeOfString:@"usepackage" options:ZER0 range:searchRange];
				if(nextR.length) {
					R = nextR;
					goto next_usepackage;
				} else {
conclude:
					[S getLineStart:nil end:&end contentsEnd:nil forRange:R];
					[self setSelectedRange:iTM3MakeRange(end,ZER0)];
					[self insertMacro:what];
					return;
				}
			}
			searchRange.location = iTM3MaxRange(R);
			searchRange.length = S.length - searchRange.location;
			goto mordor;
		}
		// No usepackage found, this is the first
next_documentclass:
		R = [S rangeOfString:@"documentclass" options:ZER0 range:R];
		if(R.length) {
			if((R.location>ZER0) &&[S isControlAtIndex:R.location-1 escaped:&escaped] && !escaped) {
				goto conclude;
			}
			goto next_documentclass;
		}
//		[self.window makeKeyAndOrderFront:self];
	}
    NSBeep();
//END4iTM3;
    return;
}
@end

@implementation NSTextStorage(LaTeX)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  LaTeXSectionMenu
- (NSMenu *)LaTeXSectionMenu;
/*"Description forthcoming. No consistency test.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{
//START4iTM3;
    BOOL withGraphics = ([[NSApp currentEvent] modifierFlags] & NSAlternateKeyMask)!=ZER0;
    NSMenu * sectionMenu = [[[NSMenu alloc] initWithTitle:@""] autorelease];
    NSString * S = self.string;
    iTM2LiteScanner * scan = [iTM2LiteScanner scannerWithString:S charactersToBeSkipped:[NSCharacterSet whitespaceCharacterSet]];
    NSUInteger scanLocation = ZER0, end = S.length;
    NSUInteger sectionCount = ZER0, subsectionCount = ZER0, subsubsectionCount = ZER0;
    next:
    if(scanLocation < end)//postN
    {
        NSUInteger depth = ZER0;
        #define partDepth 1
        #define chapterDepth 2
        #define sectionDepth 3
        #define subsectionDepth 4
        #define subsubsectionDepth 5
        #define subsubsubsectionDepth 6
        #define paragraphDepth 6
        #define subparagraphDepth 7
        #define subsubparagraphDepth 8
        #define subsubsubparagraphDepth 9
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
                NSRange R1 = iTM3MakeRange(ZER0, ZER0);
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
                                else if(R1 = [S rangeOfString:@"paragraph" options:NSAnchoredSearch range:searchRange], R1.length)
                                {
                                    scanLocation += 11;// subparagraph
                                    depth = subparagraphDepth;
                                    goto manihi;
                                }
                                else if(R1 = [S rangeOfString:@"sub" options:NSAnchoredSearch range:searchRange], R1.length)
                                {
                                    searchRange.location += 3;
                                    searchRange.length -= 3;
                                    if(R1 = [S rangeOfString:@"section" options:NSAnchoredSearch range:searchRange], R1.length)
                                    {
                                        scanLocation += 15;// subsubsubsection
                                        depth = subsubsubsectionDepth;
                                        goto manihi;
                                    }
									else if(R1 = [S rangeOfString:@"paragraph" options:NSAnchoredSearch range:searchRange], R1.length)
									{
										scanLocation += 11;// subparagraph
										depth = subsubparagraphDepth;
										goto manihi;
									}
									else if(R1 = [S rangeOfString:@"subparagraph" options:NSAnchoredSearch range:searchRange], R1.length)
									{
										scanLocation += 14;// subparagraph
										depth = subsubsubparagraphDepth;
										goto manihi;
									}
                                    else if(R1 = [S rangeOfString:@"ject" options:NSAnchoredSearch range:searchRange], R1.length)
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
                                                            [title substringWithRange:iTM3MakeRange(ZER0,43)]]: title;
                                    if(title.length)
                                    {
                                        NSMenuItem * MI = [sectionMenu addItemWithTitle: title
                                                                action: @selector(scrollInputToVisible:)
                                                                    keyEquivalent: [NSString string]];
                                        MI.representedObject = object;
                                        [MI setEnabled: (sectionMenu.title.length > ZER0)];
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
                                                                    [title substringWithRange:iTM3MakeRange(ZER0,43)]]: title;
                                            if(!title.length)
                                                title = @"?";
                                            NSMenuItem * MI = [sectionMenu addItemWithTitle: title
                                                                    action: selector keyEquivalent: [NSString string]];
                                            MI.tag = scanLocation;
                                            MI.representedObject = object;
                                            [MI setEnabled: (sectionMenu.title.length > ZER0)];
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
                else if (theChar == 'p')
                {
                    if(++scanLocation<end)
                    {
                        NSRange searchRange = iTM3MakeRange(scanLocation, end-scanLocation);
                        if(R1 = [S rangeOfString:@"ar" options:NSAnchoredSearch range:searchRange], R1.length)
                        {
                            searchRange.location += 2;
                            searchRange.length -= 2;
                            if (R1 = [S rangeOfString:@"t" options:NSAnchoredSearch range:searchRange], R1.length)
                            {
                                scanLocation += 3;// part
                                depth = partDepth;
                                goto manihi;
                            }
                            else if (R1 = [S rangeOfString:@"agraph" options:NSAnchoredSearch range:searchRange], R1.length)
                            {
                                scanLocation += 8;// paragraph
                                depth = paragraphDepth;
                                goto manihi;
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
                                sectionCount = subsectionCount = subsubsectionCount = ZER0;
                                break;
                            case chapterDepth:
                                prefix = @"Chap: ";
                                sectionCount = subsectionCount = subsubsectionCount = ZER0;
                                break;
                            default:
                                prefix = @"";
                                break;
                            case sectionDepth:
                                prefix = [NSString stringWithFormat:@"%d. ", ++sectionCount];
                                subsectionCount = subsubsectionCount = ZER0;
                                break;
                            case subsectionDepth:
                                prefix = [NSString stringWithFormat:@"%d.%c. ", sectionCount, ++subsectionCount+'a'-1];
                                subsubsectionCount = ZER0;
                                break;
                            case subsubsectionDepth:
                                prefix = [NSString stringWithFormat:@"%d.%c.%d. ", sectionCount, subsectionCount+'a'-1, ++subsubsectionCount];
                                break;
                            case paragraphDepth:
                                prefix = @"...";
                                break;
                            case subparagraphDepth:
                                prefix = @"....";
                                break;
                            case subsubparagraphDepth:
                                prefix = @".....";
                                break;
                            case subsubsubparagraphDepth:
                                prefix = @".....";
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
                                                [title substringWithRange:iTM3MakeRange(ZER0,43)]]: title;
                        if(!title.length)
                            title = @"?";
                        NSMenuItem * MI = [sectionMenu addItemWithTitle: title
                                                action: @selector(scrollTaggedToVisible:) keyEquivalent: [NSString string]];
                        MI.tag = scanLocation;
                        MI.representedObject = object;
                        [MI setEnabled: (sectionMenu.title.length > ZER0)];
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
        else if(theChar == 'b')
        {
            if(++scanLocation < end)
            {
                theChar = [S characterAtIndex:scanLocation];
                NSRange searchRange = iTM3MakeRange(scanLocation, end-scanLocation);
                NSRange R1 = [S rangeOfString:@"eginfig" options:NSAnchoredSearch range:searchRange];
                if(R1.length)
                {
                    scanLocation += 6;// section
                    depth = sectionDepth;
                    NSUInteger contentsEnd;
    //NSLog(@"manihi: %i", depth);
    //NSLog(@"3");
                    [S getLineStart:nil end:nil contentsEnd: &contentsEnd forRange:R1];
    //NSLog(@"3");
                    [scan setScanLocation:scanLocation];
                    NSInteger numero = ZER0;
                    if([scan scanString:@"(" intoString:nil] && [scan scanInteger: &numero] && [scan scanString:@")" intoString:nil])
                    {
                        NSString * title;
                        title = [NSString stringWithFormat:@"figure: %i", numero];
                        title = (title.length > 48)?
                                        [NSString stringWithFormat:@"%@[...]",
                                                [title substringWithRange:iTM3MakeRange(ZER0,43)]]: title;
                        if(!title.length)
                            title = @"?";
                        NSMenuItem * MI = [sectionMenu addItemWithTitle: title
                                                action: @selector(scrollTaggedToVisible:) keyEquivalent: [NSString string]];
                        MI.tag = scanLocation;
                        //MI.representedObject = object;
                        [MI setEnabled: (sectionMenu.title.length > ZER0)];
                        scanLocation = [scan scanLocation];
                    }
                }
            }
            goto next;
        }
        else
        {
            ++scanLocation;
            goto next;
        }
    }
    endOfString:
//iT -ENDING SUCCESSFULLY", self.class, NSStringFromSelector(_cmd), self);
    return sectionMenu;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  getLaTeXLabelMenu:refMenu:
- (void)getLaTeXLabelMenu:(NSMenu **)labelMenuRef refMenu:(NSMenu **)refMenuRef;
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
    NSUInteger scanLocation = ZER0, end = S.length;
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
                                                            [object substringWithRange:iTM3MakeRange(ZER0,43)]]: object;
                                if(title.length)
                                {
                                    NSMenuItem * MI = [labelMenu addItemWithTitle: title
                                                            action: @selector(scrollLaTeXLabelToVisible:)
                                                                keyEquivalent: [NSString string]];
                                    MI.tag = R2.location;
                                    MI.representedObject = object;
                                    [MI setEnabled: (labelMenu.title.length > ZER0)];
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
                                                            [object substringWithRange:iTM3MakeRange(ZER0,43)]]: object;
                                if(title.length)
                                {
                                    NSMenuItem * MI = [refMenu addItemWithTitle: title
                                                            action: @selector(scrollLaTeXReferenceToVisible:)
                                                                keyEquivalent: [NSString string]];
                                    MI.tag = R2.location;
                                    MI.representedObject = object;
                                    [MI setEnabled: (refMenu.title.length > ZER0)];
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
                                                        [title substringWithRange:iTM3MakeRange(ZER0,43)]]: title;
                                if(title.length)
                                {
                                    NSMenuItem * MI = [labelMenu addItemWithTitle:title action:selector keyEquivalent:[NSString string]];
                                    MI.representedObject = object;
                                    [MI setEnabled: (labelMenu.title.length > ZER0)];
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
                                                            [title substringWithRange:iTM3MakeRange(ZER0,43)]]: title;
                                    if(title.length)
                                    {
                                        NSMenuItem * MI = [labelMenu addItemWithTitle:title action:selector keyEquivalent:[NSString string]];
                                        MI.representedObject = object;
                                        [MI setEnabled: (labelMenu.title.length > ZER0)];
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

static NSString * const iTM2LaTeXIncludeSyntaxModeName = @"\\include";
static NSString * const iTM2LaTeXIncludegraphicsSyntaxModeName = @"\\includegraphics";
static NSString * const iTM2LaTeXIncludegraphixSyntaxModeName = @"\\includegraphix";
static NSString * const iTM2LaTeXURLSyntaxModeName = @"\\url";
static NSString * const iTM2LaTeXPartSyntaxModeName = @"\\part";
static NSString * const iTM2LaTeXChapterSyntaxModeName = @"\\chapter";
static NSString * const iTM2LaTeXSectionSyntaxModeName = @"\\section";
static NSString * const iTM2LaTeXSubsectionSyntaxModeName = @"\\subsection";
static NSString * const iTM2LaTeXSubsubsectionSyntaxModeName = @"\\subsubsection";
static NSString * const iTM2LaTeXParagraphSyntaxModeName = @"\\paragraph";
static NSString * const iTM2LaTeXSubparagraphSyntaxModeName = @"\\subparagraph";
static NSString * const iTM2LaTeXSubsubparagraphSyntaxModeName = @"\\subsubparagraph";
static NSString * const iTM2LaTeXSubsubsubparagraphSyntaxModeName = @"\\subsubsubparagraph";
extern NSString * const iTM2TeXCommandSyntaxModeName;

@implementation iTM2LaTeXParser
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= initialize
+ (void)initialize;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
	INIT_POOL4iTM3;
//START4iTM3;
//LOG4iTM3(@"iTM2TeXParser");
    if(!_iTM2LaTeXModeForModeArray)
        _iTM2LaTeXModeForModeArray = [[NSArray arrayWithObjects:
			iTM2LaTeXIncludeSyntaxModeName,
			iTM2LaTeXIncludegraphicsSyntaxModeName,
			iTM2LaTeXIncludegraphixSyntaxModeName,
			iTM2LaTeXURLSyntaxModeName,
			iTM2LaTeXPartSyntaxModeName,
			iTM2LaTeXChapterSyntaxModeName,
			iTM2LaTeXSectionSyntaxModeName,
			iTM2LaTeXSubsectionSyntaxModeName,
			iTM2LaTeXSubsubsectionSyntaxModeName,
			iTM2LaTeXParagraphSyntaxModeName,
			iTM2LaTeXSubparagraphSyntaxModeName,
			iTM2LaTeXSubsubparagraphSyntaxModeName,
			iTM2LaTeXSubsubsubparagraphSyntaxModeName,
				nil] retain];
	RELEASE_POOL4iTM3;
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
    return @"LaTeX";
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
    NSMutableDictionary * MD = [[[super defaultModesAttributes] mutableCopy] autorelease];
    NSMutableDictionary * include = [NSMutableDictionary dictionaryWithDictionary:
									[[super defaultModesAttributes] objectForKey:iTM2TeXCommandSyntaxModeName]];
	[include setObject:iTM2LaTeXIncludeSyntaxModeName forKey:iTM2TextModeAttributeName];
	[include setObject:@"" forKey:NSLinkAttributeName];
    [MD setObject:[[include copy] autorelease] forKey:[include objectForKey:iTM2TextModeAttributeName]];
    NSMutableDictionary * includegraphics = [NSMutableDictionary dictionaryWithDictionary:
									[[super defaultModesAttributes] objectForKey:iTM2TeXCommandSyntaxModeName]];
	[includegraphics setObject:iTM2LaTeXIncludegraphicsSyntaxModeName forKey:iTM2TextModeAttributeName];
	[includegraphics setObject:@"" forKey:NSLinkAttributeName];
    [MD setObject:[[includegraphics copy] autorelease] forKey:[includegraphics objectForKey:iTM2TextModeAttributeName]];
	[includegraphics setObject:iTM2LaTeXIncludegraphixSyntaxModeName forKey:iTM2TextModeAttributeName];
    [MD setObject:[[includegraphics copy] autorelease] forKey:[includegraphics objectForKey:iTM2TextModeAttributeName]];
    NSMutableDictionary * url = [NSMutableDictionary dictionaryWithDictionary:
									[[super defaultModesAttributes] objectForKey:iTM2TeXCommandSyntaxModeName]];
	[url setObject:iTM2LaTeXURLSyntaxModeName forKey:iTM2TextModeAttributeName];
	[url setObject:@"" forKey:NSLinkAttributeName];
    [MD setObject:[[url copy] autorelease] forKey:[url objectForKey:iTM2TextModeAttributeName]];
	NSMutableDictionary * md = [NSMutableDictionary dictionaryWithDictionary:[[super defaultModesAttributes] objectForKey:iTM2TeXCommandSyntaxModeName]];
	[md setObject:iTM2LaTeXPartSyntaxModeName forKey:iTM2TextModeAttributeName];
    [MD setObject:[[md copy] autorelease] forKey:[md objectForKey:iTM2TextModeAttributeName]];
	[md setObject:iTM2LaTeXChapterSyntaxModeName forKey:iTM2TextModeAttributeName];
    [MD setObject:[[md copy] autorelease] forKey:[md objectForKey:iTM2TextModeAttributeName]];
	[md setObject:iTM2LaTeXSectionSyntaxModeName forKey:iTM2TextModeAttributeName];
    [MD setObject:[[md copy] autorelease] forKey:[md objectForKey:iTM2TextModeAttributeName]];
	[md setObject:iTM2LaTeXSubsectionSyntaxModeName forKey:iTM2TextModeAttributeName];
    [MD setObject:[[md copy] autorelease] forKey:[md objectForKey:iTM2TextModeAttributeName]];
	[md setObject:iTM2LaTeXSubsubsectionSyntaxModeName forKey:iTM2TextModeAttributeName];
    [MD setObject:[[md copy] autorelease] forKey:[md objectForKey:iTM2TextModeAttributeName]];
	[md setObject:iTM2LaTeXParagraphSyntaxModeName forKey:iTM2TextModeAttributeName];
    [MD setObject:[[md copy] autorelease] forKey:[md objectForKey:iTM2TextModeAttributeName]];
	[md setObject:iTM2LaTeXSubparagraphSyntaxModeName forKey:iTM2TextModeAttributeName];
    [MD setObject:[[md copy] autorelease] forKey:[md objectForKey:iTM2TextModeAttributeName]];
	[md setObject:iTM2LaTeXSubsubparagraphSyntaxModeName forKey:iTM2TextModeAttributeName];
    [MD setObject:[[md copy] autorelease] forKey:[md objectForKey:iTM2TextModeAttributeName]];
	[md setObject:iTM2LaTeXSubsubsubparagraphSyntaxModeName forKey:iTM2TextModeAttributeName];
    [MD setObject:[[md copy] autorelease] forKey:[md objectForKey:iTM2TextModeAttributeName]];
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
	NSUInteger previousError = previousMode & kiTM2TeXErrorSyntaxMask;
	NSUInteger previousModifier = previousMode & kiTM2TeXModifiersSyntaxMask;
	if(previousModifier & kiTM2TeXEndOfLineSyntaxMask)
	{
		// this is the first character of the line
		if(theChar == ' ')
		{
			* newModeRef = kiTM2TeXWhitePrefixSyntaxMode | previousError | previousModifier;
			return kiTM2TeXNoErrorSyntaxStatus;
		}
		previousModifier &= ~kiTM2TeXEndOfLineSyntaxMask;
	}
	NSUInteger previousModeWithoutModifiers = previousMode & ~kiTM2TeXFlagsSyntaxMask;
	NSUInteger newModifier = previousModifier;
	NSCharacterSet * set = [NSCharacterSet TeXLetterCharacterSet4iTM3];
	NSUInteger newMode = previousModeWithoutModifiers;

	switch(previousModeWithoutModifiers)
	{
		case kiTM2LaTeXIncludeSyntaxMode:
		case kiTM2LaTeXIncludegraphicsSyntaxMode:
		case kiTM2LaTeXIncludegraphixSyntaxMode:
		case kiTM2LaTeXURLSyntaxMode:
		case kiTM2LaTeXSectionSyntaxMode:
		if([set characterIsMember:theChar])
		{
			NSString * syntaxMode = [_iTM2LaTeXModeForModeArray objectAtIndex:previousModeWithoutModifiers-kiTM2LaTeXFirstSyntaxMode];
			if([iVarAS4iTM3 character:theChar isMemberOfCoveredCharacterSetForMode:syntaxMode])
			{
				* newModeRef = newMode | previousError | newModifier;
				return kiTM2TeXNoErrorSyntaxStatus;
			}
			else
			{
	//LOG4iTM3(@"AN ERROR OCCURRED");
				* newModeRef = newMode | previousError | newModifier | kiTM2TeXErrorFontSyntaxMask;
				return kiTM2TeXErrorSyntaxStatus;
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
	NSParameterAssert(newModeRef);
    NSString * S = [_TextStorage string];
    NSParameterAssert(location<S.length);
	NSString * substring;
	NSRange r;
	NSUInteger status;
//	NSUInteger previousError = previousMode & kiTM2TeXErrorSyntaxMask;
//	NSUInteger previousModifier = previousMode & kiTM2TeXModifiersSyntaxMask;
	NSUInteger previousModeWithoutModifiers = previousMode & ~kiTM2TeXFlagsSyntaxMask;
	unichar theChar = [S characterAtIndex:location];
	NSCharacterSet * set = [NSCharacterSet TeXLetterCharacterSet4iTM3];
	if(kiTM2TeXCommandStartSyntaxMode == previousModeWithoutModifiers)
	{
		if([set characterIsMember:theChar])
		{
			// is it a \include, \includegraphics, \url
			// scanning from location for the control sequence name
			NSUInteger start = location-1;
			NSUInteger end = location+1;
			while(end<S.length && ((theChar = [S characterAtIndex:end]),[set characterIsMember:theChar]))
				++end;
			if(end == start+16)
			{
				r = iTM3MakeRange(start, end-start);
				substring = [S substringWithRange:r];
#define RETURN_MODE(SyntaxModeName,SyntaxMode) if([SyntaxModeName isEqualToString:substring])\
				{\
					if(lengthRef)\
					{\
						* lengthRef = end-start-1;\
					}\
					* newModeRef = SyntaxMode;\
					if(nextModeRef && (end<S.length))\
					{\
						theChar = [S characterAtIndex:end];\
						status = [self getSyntaxMode:nextModeRef forCharacter:theChar previousMode:* newModeRef];\
					}\
					[_TextStorage performSelector:@selector(invalidateCursorRects) withObject:nil afterDelay:0.01];\
					return kiTM2TeXNoErrorSyntaxStatus;\
				}
				RETURN_MODE(iTM2LaTeXIncludegraphicsSyntaxModeName,kiTM2LaTeXIncludegraphicsSyntaxMode);
			}
			else if(end == start+19)
			{
				r = iTM3MakeRange(start, end-start);
				substring = [S substringWithRange:r];
				RETURN_MODE(iTM2LaTeXSubsubsubparagraphSyntaxModeName,kiTM2LaTeXSubsubsubparagraphSyntaxMode)
			}
			else if(end == start+16)
			{
				r = iTM3MakeRange(start, end-start);
				substring = [S substringWithRange:r];
				RETURN_MODE(iTM2LaTeXSubsubparagraphSyntaxModeName,kiTM2LaTeXSubsubparagraphSyntaxMode)
			}
			else if(end == start+15)
			{
				r = iTM3MakeRange(start, end-start);
				substring = [S substringWithRange:r];
				RETURN_MODE(iTM2LaTeXIncludegraphixSyntaxModeName,kiTM2LaTeXIncludegraphixSyntaxMode);
			}
			else if(end == start+14)
			{
				r = iTM3MakeRange(start, end-start);
				substring = [S substringWithRange:r];
				RETURN_MODE(iTM2LaTeXSubsubsectionSyntaxModeName,kiTM2LaTeXSubsubsectionSyntaxMode)
			}
			else if(end == start+13)
			{
				r = iTM3MakeRange(start, end-start);
				substring = [S substringWithRange:r];
				RETURN_MODE(iTM2LaTeXSubparagraphSyntaxModeName,kiTM2LaTeXSubparagraphSyntaxMode)
			}
			else if(end == start+11)
			{
				r = iTM3MakeRange(start, end-start);
				substring = [S substringWithRange:r];
				RETURN_MODE(iTM2LaTeXSubsectionSyntaxModeName,kiTM2LaTeXSubsubsectionSyntaxMode)
			}
			else if(end == start+10)
			{
				r = iTM3MakeRange(start, end-start);
				substring = [S substringWithRange:r];
				RETURN_MODE(iTM2LaTeXParagraphSyntaxModeName,kiTM2LaTeXParagraphSyntaxMode)
			}
			else if(end == start+8)
			{
				r = iTM3MakeRange(start, end-start);
				substring = [S substringWithRange:r];
				RETURN_MODE(iTM2LaTeXIncludeSyntaxModeName,kiTM2LaTeXIncludeSyntaxMode)
				else
				RETURN_MODE(iTM2LaTeXSectionSyntaxModeName,kiTM2LaTeXSectionSyntaxMode)
			}
			else if(end == start+4)
			{
				r = iTM3MakeRange(start, end-start);
				substring = [S substringWithRange:r];
				RETURN_MODE(iTM2LaTeXURLSyntaxModeName,kiTM2LaTeXURLSyntaxMode)
			}
		}
	}
	if(nextModeRef)
	{
		NSUInteger result = [super getSyntaxMode:newModeRef forLocation:location previousMode:previousMode effectiveLength:lengthRef nextModeIn:nextModeRef before:beforeIndex];
		if(!result
			&&((*newModeRef & ~kiTM2TeXFlagsSyntaxMask) == kiTM2TeXCommandStartSyntaxMode)
				&&((*nextModeRef & ~kiTM2TeXFlagsSyntaxMask) == kiTM2TeXCommandContinueSyntaxMode))
		{
			*nextModeRef = kiTM2TeXUnknownSyntaxMode;
		}
		return result;
	}
	else
		return [super getSyntaxMode:newModeRef forLocation:location previousMode:previousMode effectiveLength:lengthRef nextModeIn:nil before:beforeIndex];
//END4iTM3;
}
#import "iTM2LaTeXStorageAttributes.m"
#endif
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= didClickOnLink4iTM3:atIndex:
- (BOOL)didClickOnLink4iTM3:(id)link atIndex:(NSUInteger)charIndex;
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
	if(R.length>1)
	{
		NSString * S = [TS string];
		NSString * command = [S substringWithRange:R];
		if([command isEqualToString:iTM2LaTeXIncludeSyntaxModeName])
		{
			NSUInteger start = iTM3MaxRange(R);
			if(start < S.length)
			{
				NSUInteger contentsEnd, TeXComment;
				[S getLineStart:nil end:nil contentsEnd: &contentsEnd TeXComment: &TeXComment forIndex:start];
				NSString * string = [S substringWithRange:
					iTM3MakeRange(start, (TeXComment == NSNotFound? contentsEnd: TeXComment)-start)];
				NSScanner * scanner = [NSScanner scannerWithString:string];
				[scanner scanString:@"{" intoString:nil];
				NSString * fileName;
				if([scanner scanCharactersFromSet:[NSCharacterSet TeXFileNameLetterCharacterSet4iTM3] intoString: &fileName])
				{
					if(![fileName hasPrefix:@"/"])
					{
						fileName = [[[[[[[[[TS layoutManagers] lastObject] textContainers] lastObject] textView] window] windowController] document] fileName];
						fileName = [fileName.stringByDeletingLastPathComponent stringByAppendingPathComponent:fileName];
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
				return YES;
			}
		}
		else if([command isEqualToString:iTM2LaTeXIncludegraphicsSyntaxModeName]
					||[command isEqualToString:iTM2LaTeXIncludegraphixSyntaxModeName])
		{
			NSUInteger start = iTM3MaxRange(R);
			if(start < S.length)
			{
				NSUInteger contentsEnd, TeXComment;
				[S getLineStart:nil end:nil contentsEnd: &contentsEnd TeXComment: &TeXComment forIndex:start];
				NSString * string = [S substringWithRange:
					iTM3MakeRange(start, (TeXComment == NSNotFound? contentsEnd: TeXComment)-start)];
				NSScanner * scanner = [NSScanner scannerWithString:string];
				[scanner scanString:@"{" intoString:nil];
				NSString * fileName;
				if([scanner scanCharactersFromSet:[NSCharacterSet TeXFileNameLetterCharacterSet4iTM3] intoString: &fileName])
				{
					if(![fileName hasPrefix:@"/"])
					{
						fileName = [[[[[[[[[TS layoutManagers] lastObject] textContainers] lastObject] textView] window] windowController] document] fileName];
						fileName = [fileName.stringByDeletingLastPathComponent stringByAppendingPathComponent:fileName];
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
				return YES;
			}
		}
		else if([command isEqualToString:iTM2LaTeXURLSyntaxModeName])
		{
			NSUInteger start = iTM3MaxRange(R);
			if(start < S.length)
			{
				NSUInteger contentsEnd, TeXComment;
				[S getLineStart:nil end:nil contentsEnd: &contentsEnd TeXComment: &TeXComment forIndex:start];
				NSString * string = [S substringWithRange:
					iTM3MakeRange(start, (TeXComment == NSNotFound? contentsEnd: TeXComment)-start)];
				NSScanner * scanner = [NSScanner scannerWithString:string];
				[scanner scanString:@"{" intoString:nil];
				NSString * URLString;
				if([scanner scanCharactersFromSet:[NSCharacterSet TeXFileNameLetterCharacterSet4iTM3] intoString: &URLString])
				{
					if(URLString.length && ![SWS openURL:[[[NSURL alloc] initWithString:URLString] autorelease]])
					{
						LOG4iTM3(@"INFO: could not open url <%@>", URLString);
					}
				}
				return YES;
			}
		}
	}
//END4iTM3;
	return [super didClickOnLink4iTM3:link atIndex:charIndex];
}
@end

@implementation iTM2XtdLaTeXParser
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= syntaxParserStyle
+ (NSString *)syntaxParserStyle;
/*"Designated initializer.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2: 12/05/2003
To Do List: Nothing
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return @"LaTeX-Xtd";
}
#if 1
#import "iTM2LaTeXStorageAttributes.m"
#endif
@end

NSString * const iTM2LaTeXParserAttributesInspectorType = @"iTM2LaTeXParserAttributes";

@implementation iTM2LaTeXParserAttributesDocument
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inspectorType4iTM3
+ (NSString *)inspectorType4iTM3;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return iTM2LaTeXParserAttributesInspectorType;
}
@end

@implementation iTM2LaTeXParserAttributesInspector
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inspectorType4iTM3
+ (NSString *)inspectorType4iTM3;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return iTM2LaTeXParserAttributesInspectorType;
}
@end

NSString * const iTM2XtdLaTeXParserAttributesInspectorType = @"iTM2XtdLaTeXParserAttributes";

@implementation iTM2XtdLaTeXParserAttributesDocument
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inspectorType4iTM3
+ (NSString *)inspectorType4iTM3;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return iTM2XtdLaTeXParserAttributesInspectorType;
}
@end

@implementation iTM2XtdLaTeXParserAttributesInspector
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inspectorType4iTM3
+ (NSString *)inspectorType4iTM3;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return iTM2XtdLaTeXParserAttributesInspectorType;
}
@end

@implementation iTM2XtdLaTeXParserSymbolsInspector
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inspectorType4iTM3
+ (NSString *)inspectorType4iTM3;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return iTM2XtdLaTeXParserAttributesInspectorType;
}
@end

@implementation iTM2ProjectDocumentResponder(LaTeX)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  LaTeXLabelAction:
- (IBAction)LaTeXLabelAction:(id)sender;
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  LaTeXLabelActionWillPopUp:
- (BOOL)LaTeXLabelActionWillPopUp:(id)sender;
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  LaTeXSectionAction:
- (IBAction)LaTeXSectionAction:(id)sender;
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  LaTeXSectionActionWillPopUp:
- (BOOL)LaTeXSectionActionWillPopUp:(id)sender;
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


@implementation iTM2LaTeXLogParser
static NSDictionary * _iTM2LaTeXLogColors = nil;
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initialize
+ (void)initialize;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Apr 16 11:39:43 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
    INIT_POOL4iTM3;
//START4iTM3;
    [self registerParser];
    if(!_iTM2LaTeXLogColors)
        _iTM2LaTeXLogColors = [[NSDictionary dictionaryWithObjectsAndKeys:
            [NSColor blackColor], @"Normal",
            [NSColor blackColor], @"Ignore",
            [NSColor blackColor], @"Ignore Next",
            [NSColor colorWithCalibratedRed:1 green:0.0 blue:0.0 alpha:1.0], @"iTeXMac2 Error",
            [NSColor colorWithCalibratedRed:0.5 green:0.0 blue:0.0 alpha:1.0], @"iTeXMac2 Comment",
            [NSColor colorWithCalibratedRed:0.0 green:0.25 blue:0.0 alpha:1.0], @"LaTeX Font Info",
            [NSColor colorWithCalibratedRed:0.0 green:0.25 blue:0.0 alpha:1.0], @"LaTeX Info",
            [NSColor colorWithCalibratedRed:0.0 green:0.25 blue:0.0 alpha:1.0], @"TeX Info",
            [NSColor colorWithCalibratedRed:1.0 green:0.33 blue:0.0 alpha:1.0], @"LaTeX Font Warning",
            [NSColor colorWithCalibratedRed:1.0 green:0.33 blue:0.0 alpha:1.0], @"LaTeX Warning",
            [NSColor colorWithCalibratedRed:0.0 green:0.0 blue:0.5 alpha:1.0], @"Package",
            [NSColor colorWithCalibratedRed:0.0 green:0.0 blue:0.5 alpha:1.0], @"File",
            [NSColor colorWithCalibratedRed:1.0 green:0.33 blue:0.0 alpha:1.0], @"TeX Warning",
            [NSColor colorWithCalibratedRed:0.75 green:0.0 blue:0.0 alpha:1.0], @"TeX Error",
            [NSColor colorWithCalibratedRed:0.75 green:0.0 blue:0.0 alpha:1.0], @"TeX Error line",
            [NSColor colorWithCalibratedRed:0.75 green:0.0 blue:0.0 alpha:1.0], @"TeX Error query",
            [NSColor colorWithCalibratedRed:0.75 green:0.0 blue:0.0 alpha:1.0], @"TeX Error file:line", nil] retain];
//END4iTM3;
	RELEASE_POOL4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  key
+ (NSString *)key;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Apr 16 11:39:43 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return @"LaTeX";
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  attributedMessageWithString:previousMessage:
+ (id)attributedMessageWithString:(NSString *)string previousMessage:(NSAttributedString *)message;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/11/01)
- 1.4: Fri Apr 16 11:39:43 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//NSLog(@"****  The STRING IS: %@", string);
    NSDictionary * attributes = message.length?
        [message attributesAtIndex:message.length - 1 effectiveRange:nil]:
            nil;
    // looking for the last page number previously parsed (problem with non continuous page numbers...)
    // WHAT WAS PREVIOUSLY THERE?
    NSNumber * oldPageNumber = [attributes objectForKey:iTM2LogPageNumberAttributeName]?:[NSNumber numberWithInteger:ZER0];
    NSString * type = [attributes objectForKey:iTM2LogLineTypeAttributeName]?: @"Normal";
    // what kind of info will be passed through?
    // 1 - the current physical page number
    // 2 - the type of the error, it is line wide
    // 3 - the file
    // 4 - the files stack
    // special lines starting with
    // "." assumed to be in file line error style
    // "" (void line) assumed to end a file line error style comment
    // "!" assumed to be a LaTeX error
    // " " assumed to be a comment: the attributes are passed through
    // "LaTeX Info:" assumed to be a 
    // "LaTeX Font Info:" assumed to be a 
    // "LaTeX Warning:" assumed to be a 
    // "LaTeX Font Warning:" assumed to be a 
    // "pdfTeX Warning:" assumed to be a 
    // "Warning:"
    // "Overfull "
    // "Underfull "
    // "Package"
    // "" assumed to be a 
    // "" assumed to be a 
    // "" assumed to be a 
    NSMutableAttributedString * MAS = [[[NSMutableAttributedString alloc] init] autorelease];
    [MAS beginEditing];
    NSMutableString * MS = [MAS mutableString];
    [MS appendString:string];
    NSRange R = iTM3MakeRange(ZER0, MS.length);
    NSRange lineRange = iTM3MakeRange(ZER0, ZER0);
    iTM2LiteScanner * scanner = [iTM2LiteScanner scannerWithString:string charactersToBeSkipped:[NSCharacterSet whitespaceCharacterSet]];
    [MAS addAttribute:iTM2LogPageNumberAttributeName value:oldPageNumber range:R];
    BOOL dontIgnoreFilesAndPages = NO;
    if([scanner scanString:@"/" intoString:nil])
    {
        // this is supposed to be a file:line:error line
        // no hint will be used to manage the list of files
		NSString * path;
		lineRange.location = [scanner scanLocation] - 1;
        if([scanner scanUpToString:@":" intoString: &path] && [scanner scanString:@":" intoString:nil])
        {
            type = @"TeX Error file:line";
            lineRange.location = [scanner scanLocation];
            NSInteger line;
            if([scanner scanInteger: &line])
            {
                lineRange.length = [scanner scanLocation] - lineRange.location;
                [MAS addAttribute:NSLinkAttributeName value:[NSNull null] range:lineRange];
				NSNumber * N = [NSNumber numberWithInteger:line];
                [MAS addAttribute:iTM2LogLinkLineAttributeName value:N range:lineRange];
				path = [NSOpenStepRootDirectory() stringByAppendingPathComponent:path];
				path = [path stringByStandardizingPath];
                [MAS addAttribute:iTM2LogLinkFileAttributeName value:path range:lineRange];
            }
        }
        else
        {
            type = @"Normal";
            dontIgnoreFilesAndPages = YES;
        }
        goto finish;
    }
    else if([scanner scanString:@"." intoString:nil])
    {
        // this is supposed to be a file:line:error line
        // no hint will be used to manage the list of files
		NSString * path;
		lineRange.location = [scanner scanLocation] - 1;
        if([scanner scanUpToString:@":" intoString: &path] && [scanner scanString:@":" intoString:nil])
        {
            type = @"TeX Error file:line";
            lineRange.location = [scanner scanLocation];
            NSInteger line;
            if([scanner scanInteger: &line])
            {
                lineRange.length = [scanner scanLocation] - lineRange.location;
                [MAS addAttribute:NSLinkAttributeName value:[NSNull null] range:lineRange];
                [MAS addAttribute:iTM2LogLinkLineAttributeName value:[NSNumber numberWithInteger:line] range:lineRange];
                [MAS addAttribute:iTM2LogLinkFileAttributeName value:[[@"." stringByAppendingPathComponent:path] stringByStandardizingPath] range:lineRange];
            }
        }
        else
        {
            type = @"Normal";
            dontIgnoreFilesAndPages = YES;
        }
        goto finish;
    }
    else if([scanner scanString:@"LaTeX" intoString:nil])
    {
        if([scanner scanString:@"Font" intoString:nil])
        {
            if([scanner scanString:@"Info:" intoString:nil])
            {
                type = @"LaTeX Font Info";
            }
            else if([scanner scanString:@"Warning:" intoString:nil])
            {
                type = @"LaTeX Font Warning";
            }
        }
        else if([scanner scanString:@"Info:" intoString:nil])
        {
            type = @"LaTeX Info";
        }
        else if([scanner scanString:@"Warning:" intoString:nil])
        {
            type = @"LaTeX Warning";
        }
        goto finish;
    }
    else if([scanner scanString:@"Package" intoString:nil])
    {
        type = @"Package";
        goto finish;
    }
    else if([scanner scanString:@"File" intoString:nil])
    {
        type = @"File";
        goto finish;
    }
    else if([scanner scanString:@"Language" intoString:nil])
    {
        type = @"File";
        goto finish;
    }
    else if([scanner scanString:@"Underfull" intoString:nil])
    {
        type = @"TeX Warning";
        goto scanLine;
    }
    else if([scanner scanString:@"Overfull" intoString:nil])
    {
        type = @"TeX Warning";
        goto scanLine;
    }
    else if([scanner scanString:@"!" intoString:nil])
    {
        type = @"TeX Error";
        goto finish;
    }
    else if([scanner scanString:@"l." intoString:nil])
    {
        type = @"TeX Error line";
        lineRange.location = [scanner scanLocation];
		NSInteger line;
		if([scanner scanInteger: &line])
		{
			lineRange.length = [scanner scanLocation] - lineRange.location;
			[MAS addAttribute:NSLinkAttributeName value:type range:lineRange];
			NSNumber * N = [NSNumber numberWithInteger:line];
			[MAS addAttribute:iTM2LogLinkLineAttributeName value:N range:lineRange];
		}
        goto finish;
    }
    else if([scanner scanString:@"?" intoString:nil])
    {
        type = @"TeX Error query";
		// I should clean the attributes here
        goto finish;
    }
    else if([scanner scanString:@"Output written on " intoString:nil])
    {
		NSRange fileRange = iTM3MakeRange(ZER0, ZER0);
		fileRange.location = [scanner scanLocation];
		NSString * file;
		if([scanner scanCharactersFromSet:[NSCharacterSet TeXFileNameLetterCharacterSet4iTM3] intoString: &file])
		{
			fileRange.length = [scanner scanLocation] - fileRange.location;
			[MAS addAttribute:NSLinkAttributeName value:[NSNull null] range:fileRange];
			[MAS addAttribute:iTM2LogLinkFileAttributeName value:file range:fileRange];
 		}
        goto finish;
	}
    else if([scanner scanString:@"Transcript written on " intoString:nil])
    {
		NSRange fileRange = iTM3MakeRange(ZER0, ZER0);
		fileRange.location = [scanner scanLocation];
		NSString * file;
		if([scanner scanCharactersFromSet:[NSCharacterSet TeXFileNameLetterCharacterSet4iTM3] intoString: &file])
		{
			fileRange.length = [scanner scanLocation] - fileRange.location;
			if([file hasSuffix:@"."])// there is a final "." unwanted
			{
				--fileRange.length;
				file = [file substringWithRange:iTM3MakeRange(ZER0, file.length - 1)];
			}
			[MAS addAttribute:NSLinkAttributeName value:[NSNull null] range:fileRange];
			[MAS addAttribute:iTM2LogLinkFileAttributeName value:file range:fileRange];
 		}
        goto finish;
	}
    else if([type isEqualToString:@"TeX Error line"])
    {
        type = @"Ignore Next";
        goto finish;
    }
    else if([type isEqualToString:@"Ignore Next"])
    {
        NSUInteger contentsEnd;
        [string getLineStart:nil end:nil contentsEnd: &contentsEnd forRange:R];
        type = contentsEnd? @"Ignore": @"Normal";
        goto finish;
    }
    else if([type isEqualToString:@"LaTeX Font Info"])
    {
        // this is a "(Font)              <7> on input line 157." information
        type = @"Normal";
        dontIgnoreFilesAndPages = YES;
        goto scanLine;
    }
    #if 1
    type = @"Normal";
    if([string hasPrefix:@"  "])
    {
        // this line is generally following the ! one
        type = @"Ignore";
        goto finish;
    }
    else if([scanner scanString:@"\\" intoString:nil])
    {
        // This line is starting y a control sequence
        type = @"Ignore";
        goto finish;
    }
    else if([scanner scanString:@"*" intoString:nil])
    {
        // this line is generally following the ! one
        type = @"TeX Info";
        goto finish;
    }
    else
    {
        dontIgnoreFilesAndPages = YES;
        goto finish;
    }
    scanLine:
    lineRange = [string rangeOfString:@"line "];
    if(lineRange.location != NSNotFound)
    {
        [scanner setScanLocation:iTM3MaxRange(lineRange)];
        NSInteger line;
        if([scanner scanInteger: &line])
        {
            lineRange.length = [scanner scanLocation] - lineRange.location;
			[MAS addAttribute:NSLinkAttributeName value:[NSNull null] range:lineRange];
			[MAS addAttribute:iTM2LogLinkLineAttributeName value:[NSNumber numberWithInteger:line] range:lineRange];
        }
    }
    finish:
//NSLog(@"****  The type is: %@", type);
    if(dontIgnoreFilesAndPages)
    {
        NSRange attributeRange = iTM3MakeRange(ZER0, string.length);
        NSUInteger contentsEnd;
        [string getLineStart:nil end:nil contentsEnd: &contentsEnd forRange:attributeRange];
//NSLog(@"File or pages? %@", string);
        NSArray * files = [attributes objectForKey:iTM2LogFilesStackAttributeName]?:[NSArray array];
        if(contentsEnd>=string.length)
        {
            [MAS addAttribute:iTM2LogFilesStackAttributeName value:files range:attributeRange];
            goto finishEnd;
        }
        // Here is a little note about the file stack management
        // The attribute value is the list of all the currently open files
        // the currently scanned file is the last in the list
        // or the master one if the list is void
        // when a new file is opened, the stack array is duplicated and an entry is added
        // when a file is closed, the stack array is duplicated and the last entry is deleted
        // The difficulty is to understand when files are opened or closed
        NSRange searchRange = attributeRange;
        NSRange openRange = [string rangeOfString:@"(" options:ZER0 range:searchRange];
        NSRange closeRange = [string rangeOfString:@")" options:ZER0 range:searchRange];
        openingOrClosingAFile:
//NSLog(@"Scanning: %@ (open is %@, close is: %@)", files, NSStringFromRange(openRange), NSStringFromRange(closeRange));
        if(openRange.location<closeRange.location)
        {
//NSLog(@"Opening");
            attributeRange.length = openRange.location + 1 - attributeRange.location;
            [MAS addAttribute:iTM2LogFilesStackAttributeName value:files range:attributeRange];
            attributeRange.location = iTM3MaxRange(attributeRange);
            attributeRange.length = string.length - attributeRange.location;
            // opening first
            NSString * prefix;
            NSRange fileRange = iTM3MakeRange(ZER0, ZER0);
            fileRange.location = openRange.location + 1;
            [scanner setScanLocation:fileRange.location];
            if([scanner scanString:@"/" intoString: &prefix]
                || [scanner scanString:@"." intoString: &prefix])
            {
                NSString * TeXFilenameTrailer;
                if([scanner scanCharactersFromSet:[NSCharacterSet TeXFileNameLetterCharacterSet4iTM3] intoString: &TeXFilenameTrailer])
                {
                    fileRange.length = [scanner scanLocation] - fileRange.location;
                    NSString * file = [prefix stringByAppendingString:TeXFilenameTrailer];
                    [MAS addAttribute:NSLinkAttributeName value:[NSNull null] range:fileRange];
                    [MAS addAttribute:iTM2LogLinkFileAttributeName value:file range:fileRange];
                    files = [files arrayByAddingObject:file];
//NSLog(@"file name added: %@", file);
                    searchRange.location = iTM3MaxRange(openRange);
                    searchRange.length = string.length - searchRange.location;
                    openRange = [string rangeOfString:@"(" options:ZER0 range:searchRange];
                    goto openingOrClosingAFile;
                }
                else
                {
                    
//START4iTM3;
                    NSLog(@"No file to open: Missing characters after, \"(.\" or \"(/\"");
                    NSLog(@"<%@>", string);
                    [MAS addAttribute:iTM2LogFilesStackAttributeName value:files range:attributeRange];
                    goto finishEnd;
                }
            }
            else
            {
                
//START4iTM3;
                NSLog(@"No file to open: I don't understand the syntax, \"(.\" or \"(/\" expected");
                NSLog(@"<%@>", string);
                [MAS addAttribute:iTM2LogFilesStackAttributeName value:files range:attributeRange];
                goto finishEnd;
            }
            // now we are trying to scan a TeX file name
        }
        else if(closeRange.location<NSNotFound)
        {
//NSLog(@"Closing:");
            // closing first
            if(files.count)
            {
                NSMutableArray * MRA = [NSMutableArray arrayWithArray:files];
                [MRA removeLastObject];
                attributeRange.length = closeRange.location - attributeRange.location;
                [MAS addAttribute:iTM2LogFilesStackAttributeName value:files range:attributeRange];
                attributeRange.location = iTM3MaxRange(attributeRange);
                attributeRange.length = string.length - attributeRange.location;
                searchRange.location = iTM3MaxRange(closeRange);
                searchRange.length = string.length - searchRange.location;
                closeRange = [string rangeOfString:@")" options:ZER0 range:searchRange];
                files = [NSArray arrayWithArray:MRA];
                goto openingOrClosingAFile;
            }
            else
            {
                
//START4iTM3;
                NSLog(@"No file to close: I don't understand the syntax");
                NSLog(@"<%@>", string);
                [MAS addAttribute:iTM2LogFilesStackAttributeName value:files range:attributeRange];
                goto finishEnd;
            }
        }
        else
        {
//NSLog(@"Nothing");
            [MAS addAttribute:iTM2LogFilesStackAttributeName value:files range:attributeRange];
            goto finishEnd;
        }
    }
    else
    {
        NSArray * files = [attributes objectForKey:iTM2LogFilesStackAttributeName]?:[NSArray array];
        [MAS addAttribute:iTM2LogFilesStackAttributeName value:files range:iTM3MakeRange(ZER0, string.length)];
    }
    finishEnd:
    [MAS addAttribute:iTM2LogLineTypeAttributeName value:type range:R];
	NSColor * C = [self logColorForType:type];
    [MAS addAttribute:NSForegroundColorAttributeName value:C range:R];
    [MAS endEditing];
    return MAS;
    #endif
    #if 0
    NSUInteger scanLocation, oldScanLocation;
    NSRange aRange = iTM3MakeRange(ZER0, string.length);
    NSRange attributeRange = aRange;
    NSUInteger maxRange = string.length;
//NSLog(@"P: ZER0<=%d<%d", aRange.location, string.length);
    scanLocation = ZER0;
//NSLog(@"<%@>(%u -> %u)", [[NSCalendarDate date] description], scanLocation, maxRange);
    while(scanLocation < maxRange)
    {
//NSLog(@"NEW LOOP: scanLocation: %i <%@>", scanLocation, [string substringWithRange:iTM3MakeRange(scanLocation, 1)]);
        [scanner setScanLocation:scanLocation];
        // leading whites
        attributeRange = iTM3MakeRange(scanLocation, ZER0);
        [scanner scanCharactersFromSet:[NSCharacterSet whitespaceAndNewlineCharacterSet] intoString:nil];
        scanLocation = [scanner scanLocation];
        if(scanLocation > attributeRange.location)
        {
            attributeRange.length = [scanner scanLocation] - attributeRange.location;
            [MAS removeAttribute:diTM2IAN range:attributeRange];
            if(currentPhysicalPageNumber)
                [MAS addAttribute:@"P" value:currentPhysicalPageNumber range:attributeRange];
            else
                [MAS removeAttribute:@"P" range:attributeRange];
//NSLog(@"0-Setting P attribute: %@ in range %@", currentPhysicalPageNumber, NSStringFromRange(attributeRange));
            if(scanLocation >= maxRange)
                break;
            attributeRange = iTM3MakeRange(scanLocation, ZER0);
        }
        oldScanLocation = scanLocation;
        // now scanLocation points to the first black character
//NSLog(@"black character: <%@>", [string substringWithRange:iTM3MakeRange(scanLocation, 1)]);
//if([[NSCharacterSet whitespaceAndNewlineCharacterSet] characterIsMember:[string characterAtIndex:scanLocation]])
//NSLog(@"whitespaceAndNewlineCharacterSet");
//if([[[NSCharacterSet whitespaceAndNewlineCharacterSet] invertedSet] characterIsMember:[string characterAtIndex:scanLocation]])
//NSLog(@"not whitespaceAndNewlineCharacterSet");
        if([scanner scanString:@"!" intoString:nil])
        {
            NSUInteger end = ZER0;
            NSUInteger nextEnd = ZER0;
            NSUInteger nextStart = ZER0;
            NSUInteger lineNumber = ZER0;
            NSInteger counter;
            NSRange lineKeyRange;
            iTM2LiteScanner * subScanner;
            NSString * line;
//NSLog(@"GLS");
            [string getLineStart:nil end: &end contentsEnd:nil forRange:iTM3MakeRange(scanLocation, ZER0)];
            nextStart = end;
//NSLog(@"GLS");
            for(counter = ZER0; counter < 10; ++counter)
            {
                [string getLineStart:nil end: &nextEnd contentsEnd:nil forRange:iTM3MakeRange(nextStart, ZER0)];
                line = [string substringWithRange:iTM3MakeRange(nextStart, nextEnd - nextStart)];
                subScanner = [iTM2LiteScanner scannerWithString:line charactersToBeSkipped:[NSCharacterSet whitespaceCharacterSet]];
                [subScanner scanUpToString:@"l." intoString:nil];
                lineKeyRange.location = [subScanner scanLocation];
                if([subScanner scanString:@"l." intoString:nil] && [subScanner scanInteger: &lineNumber])
                {
                    lineKeyRange.length = [subScanner scanLocation] - lineKeyRange.location;
                    lineKeyRange.location += nextStart;
                    [MAS addAttribute:iTM2LineAttributeName value:[NSNumber numberWithInteger:lineNumber] range:lineKeyRange];
                    end = iTM3MaxRange(lineKeyRange);
                    break;
                }
                else
                {
//NSLog(@"I am missing a line number\n%i: %@", counter, line);
                    nextStart = nextEnd;
                    if(nextStart > string.length)
                    {
                        break;
                    }
                }
            }
            attributeRange = iTM3MakeRange(scanLocation, end - scanLocation);
            [MAS addAttribute:diTM2IAN value:iTM2ErrorInput range:attributeRange];
            if(currentPhysicalPageNumber)
                [MAS addAttribute:@"P" value:currentPhysicalPageNumber range:attributeRange];
            else
                [MAS removeAttribute:@"P" range:attributeRange];
//NSLog(@"1-Setting P attribute: %@ in range %@", currentPhysicalPageNumber, NSStringFromRange(attributeRange));
            scanLocation = end;
        }
        #if 1
        else if([scanner scanString:@"Package:" intoString:nil])
        {// two lines parsing
            NSUInteger end = ZER0;
//NSLog(@"GLS");
            [string getLineStart:nil end: &end contentsEnd:nil forRange:iTM3MakeRange([scanner scanLocation], ZER0)];
            attributeRange = iTM3MakeRange(scanLocation, end - scanLocation);
            [MAS addAttribute:diTM2IAN value:iTM2InfoInput range:attributeRange];
            if(currentPhysicalPageNumber)
                [MAS addAttribute:@"P" value:currentPhysicalPageNumber range:attributeRange];
            else
                [MAS removeAttribute:@"P" range:attributeRange];
//NSLog(@"3-Setting P attribute: %@ in range %@", currentPhysicalPageNumber, NSStringFromRange(attributeRange));
            scanLocation = end;
        }
        #endif
        #if 1
        else if([scanner scanString:@"LaTeX Info:" intoString:nil] ||
                    [scanner scanString:@"LaTeX Font Info:" intoString:nil])
        {// two lines parsing
            NSUInteger end = ZER0;
            NSUInteger line = ZER0;
            NSRange lineKeyRange;
            NSString * substring;
            iTM2LiteScanner * subScanner;
//NSLog(@"GLS");
            [string getLineStart: nil end: &end contentsEnd: nil
                                                forRange: iTM3MakeRange([scanner scanLocation], ZER0)];
            attributeRange = iTM3MakeRange(scanLocation, end - scanLocation);
            substring = [string substringWithRange:attributeRange];
            subScanner = [iTM2LiteScanner scannerWithString:substring charactersToBeSkipped:[NSCharacterSet whitespaceCharacterSet]];
//NSLog(@"substring: <%@>", substring);
            while(![subScanner isAtEnd])
            {
                if([subScanner scanUpToString:@"line" intoString:nil],
                    [subScanner scanString:@"line" intoString:nil])
                {
                    lineKeyRange.location = [subScanner scanLocation] - 4;
                    if([subScanner scanInteger: &line])
                    {
                        lineKeyRange.length = [subScanner scanLocation] - lineKeyRange.location;
                        lineKeyRange.location += scanLocation;
//NSLog(@"Is this a bug? %@", NSStringFromRange(lineKeyRange));
                        [MAS addAttribute: iTM2LineAttributeName
                                        value: [NSNumber numberWithInteger:line] range:lineKeyRange];
                        break;
                    }
                }
            }
            [MAS addAttribute:diTM2IAN value:iTM2InfoInput range:attributeRange];
            if(currentPhysicalPageNumber)
                [MAS addAttribute:@"P" value:currentPhysicalPageNumber range:attributeRange];
            else
                [MAS removeAttribute:@"P" range:attributeRange];
//NSLog(@"4-Setting P attribute: %@ in range %@", currentPhysicalPageNumber, NSStringFromRange(attributeRange));
            scanLocation = end;
        }
        #endif
        else if([scanner scanString:@"l." intoString:nil])
        {
            NSUInteger end = ZER0;
            NSUInteger line = ZER0;
            NSRange lineKeyRange = iTM3MakeRange([scanner scanLocation], ZER0);
            NSString * substring;
            iTM2LiteScanner * subScanner;
            NSUInteger tmpAnchor = oldScanLocation;
//NSLog(@"GLS");
            [string getLineStart: nil end: &end contentsEnd: nil
                                                forRange: iTM3MakeRange([scanner scanLocation], ZER0)];
            attributeRange = iTM3MakeRange(scanLocation, end - scanLocation);
            substring = [string substringWithRange:attributeRange];
            subScanner = [iTM2LiteScanner scannerWithString:substring charactersToBeSkipped:[NSCharacterSet whitespaceCharacterSet]];
            [subScanner setScanLocation:2];
//NSLog(@"substring: <%@>", substring);
            if([subScanner scanInteger: &line])
            {
                lineKeyRange.length = [subScanner scanLocation] - 2;
//NSLog(@"Is this a bug? %@", NSStringFromRange(lineKeyRange));
                [MAS addAttribute: iTM2LineAttributeName
                                value: [NSNumber numberWithInteger:line] range:lineKeyRange];
            }
            [MAS addAttribute:diTM2IAN value:iTM2InfoInput range:attributeRange];
            if(currentPhysicalPageNumber)
                [MAS addAttribute:@"P" value:currentPhysicalPageNumber range:attributeRange];
            else
                [MAS removeAttribute:@"P" range:attributeRange];
//NSLog(@"4-Setting P attribute: %@ in range %@", currentPhysicalPageNumber, NSStringFromRange(attributeRange));
            scanLocation = end;
        }
        else if([scanner scanString:@"?" intoString:nil])
        {
            NSUInteger end = ZER0;
            [string getLineStart: nil end: &end contentsEnd: nil
                                                forRange: iTM3MakeRange([scanner scanLocation], ZER0)];
            attributeRange = iTM3MakeRange(scanLocation, end - scanLocation);
            [MAS addAttribute:diTM2IAN value:iTM2ErrorInput range:attributeRange];
            if(currentPhysicalPageNumber)
                [MAS addAttribute:@"P" value:currentPhysicalPageNumber range:attributeRange];
            else
                [MAS removeAttribute:@"P" range:attributeRange];
//NSLog(@"4-Setting P attribute: %@ in range %@", currentPhysicalPageNumber, NSStringFromRange(attributeRange));
            scanLocation = end;
        }
        else
        {
            NSUInteger end = ZER0;
            NSUInteger scanAnchor = [scanner scanLocation];
            NSUInteger tmpAnchor = [scanner scanUpToString:@"on input line" intoString:nil beforeIndex:end]?
                [scanner scanLocation]: scanAnchor;
//NSLog(@"GLS");
            [string getLineStart:nil end: &end contentsEnd:nil forRange:iTM3MakeRange(scanAnchor, ZER0)];
//NSLog(@"CTHER\n<%@>", [string substringWithRange:  iTM3MakeRange(scanAnchor, end - scanAnchor)]);
            if([scanner scanString:@"on input line" intoString:nil beforeIndex:end])
            {
                NSRange lineKeyRange;
                NSInteger line;
//NSLog(@"on input line: %@", [string substringWithRange:iTM3MakeRange(scanLocation, 20)]);
                lineKeyRange.location = [scanner scanLocation] - 4;
                if([scanner scanInteger: &line])
                {
                    lineKeyRange.length = [scanner scanLocation] - lineKeyRange.location;
                    [MAS addAttribute: iTM2LineAttributeName
                                    value: [NSNumber numberWithInteger:line] range:lineKeyRange];
                }
                attributeRange = iTM3MakeRange(scanLocation, end - scanLocation);
                [MAS addAttribute:diTM2IAN value:iTM2InfoInput range:attributeRange];
                if(currentPhysicalPageNumber)
                    [MAS addAttribute:@"P" value:currentPhysicalPageNumber range:attributeRange];
                else
                    [MAS removeAttribute:@"P" range:attributeRange];
//NSLog(@"5-Setting P attribute: %@ in range %@", currentPhysicalPageNumber, NSStringFromRange(attributeRange));
                scanLocation = end;
            }
            else if([scanner setScanLocation:scanAnchor], [scanner scanUpToString:@"["//]
                    intoString: nil beforeIndex: end], [scanner scanString:@"["//]
                        intoString: nil])
            {
                BOOL escaped = NO;
                NSUInteger tmpAnchor = [scanner scanLocation] - 1;
                end = [scanner scanLocation];
                attributeRange = iTM3MakeRange(scanAnchor, end - scanAnchor);
                if(currentPhysicalPageNumber)
                    [MAS addAttribute:@"P" value:currentPhysicalPageNumber range:attributeRange];
                else
                    [MAS removeAttribute:@"P" range:attributeRange];
//NSLog(@"6-Setting P attribute: %@ in range %@", currentPhysicalPageNumber, NSStringFromRange(attributeRange));
//NSLog(@"0");
                if((end<2) || ![string isControlAtIndex:end-2 escaped: &escaped] || escaped)
                {
                    // Ok, that seems to be a "[#page{something?}]"
//NSLog(@"1");
                    NSInteger entier;
                    scanLocation = end;
                    if([scanner scanInteger: &entier])
                    {
//NSLog(@"1.1: entier: %d, currentPhysicalPage: %d (%@)", -entier, currentPhysicalPage, currentPhysicalPageNumber);
                        currentPhysicalPageNumber = [NSNumber numberWithInteger: --currentPhysicalPage];
                        end = [scanner scanLocation];
                        attributeRange = iTM3MakeRange(scanLocation, end - scanLocation);
                        [MAS addAttribute:iTM2LineAttributeName value:currentPhysicalPageNumber range:attributeRange];
                        #warning WHAT THE HELL IS THIS? (ABOVE)
                        [MAS addAttribute:@"P" value:currentPhysicalPageNumber range:attributeRange];
//NSLog(@"7-Setting P attribute: %@ in range %@", currentPhysicalPageNumber, NSStringFromRange(attributeRange));
                        scanLocation = end;
                        if([scanner scanUpToString:@"]"//[
                            intoString: nil], [scanner scanString:@"]"//[
                                intoString: nil])
                        {
                            end = [scanner scanLocation];
//NSLog(@"1.1.1");
                            attributeRange = iTM3MakeRange(scanLocation, end - scanLocation);
                            [MAS setAttributes:nil range:attributeRange];
                            [MAS addAttribute:@"P" value:currentPhysicalPageNumber range:attributeRange];
//NSLog(@"8-Setting P attribute: %@ in range %@", currentPhysicalPageNumber, NSStringFromRange(attributeRange));
                            scanLocation = end;
                        }
                    }
//NSLog(@"2");
                }
//NSLog(@"\nXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX\nPage: <%@>", [string substringWithRange:attributeRange]);
                if(currentPhysicalPageNumber)
                    [MAS addAttribute:@"P" value:currentPhysicalPageNumber range:attributeRange];
                else
                    [MAS removeAttribute:@"P" range:attributeRange];
//NSLog(@"9-Setting P attribute: %@ in range %@", currentPhysicalPageNumber, NSStringFromRange(attributeRange));
                scanLocation = end;
            }
            #if 1
            else
            {
//NSLog(@"regular");
                attributeRange = iTM3MakeRange(scanLocation, end - scanLocation);
                [MAS removeAttribute:diTM2IAN range:attributeRange];
                if(currentPhysicalPageNumber)
                    [MAS addAttribute:@"P" value:currentPhysicalPageNumber range:attributeRange];
                else
                    [MAS removeAttribute:@"P" range:attributeRange];
//NSLog(@"10-Setting P attribute: %@ in range %@", currentPhysicalPageNumber, NSStringFromRange(attributeRange));
            }
            #endif
            scanLocation = end;
        }
        while(scanLocation<=oldScanLocation)
        {
//NSLog(@"defect: 2");
            ++scanLocation;
        }
//NSLog(@"scanLocation at the end: %u", scanLocation);
    }
//NSLog(@"Attributes are fixed %@>", [[NSCalendarDate date] description]);
    // Critical: aRange must not be used!!!
    // no return is allowed
//NSLog(@"Attributes fixed until: %i", scanLocation);
    [MAS endEditing];
    return MAS;
    #endif
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  logColorForType:
+ (NSColor *)logColorForType:(NSString *)type;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Apr 16 11:39:43 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [_iTM2LaTeXLogColors objectForKey:type]?:[self.superclass logColorForType:type];
}
@end

#include "../build/Milestones/iTM2LaTeXKit.m"
