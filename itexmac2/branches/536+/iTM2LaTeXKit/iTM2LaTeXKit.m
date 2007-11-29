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
#import <iTM2Foundation/iTM2MacroKit.h>

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
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return iTM2LaTeXInspectorMode;
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  LaTeXInspectorToolbarCompleteInstallation
+ (void)LaTeXInspectorToolbarCompleteInstallation;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue May  3 16:20:26 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[SUD registerDefaults: [NSDictionary dictionaryWithObjectsAndKeys:
		[NSNumber numberWithBool:NO], @"iTM2LaTeXToolbarAutosavesConfiguration",
		[NSNumber numberWithBool:YES], @"iTM2LaTeXToolbarShareConfiguration",
			nil]];
//iTM2_END;
	return;
}
@end

#define DEFINE_TOOLBAR_ITEM(SELECTOR)\
+ (NSToolbarItem *)SELECTOR;{return [self toolbarItemWithIdentifier:[self identifierFromSelector:_cmd] inBundle:[iTM2TeXInspector classBundle]];}

@implementation NSToolbarItem(iTM2LaTeX)
DEFINE_TOOLBAR_ITEM(LaTeXSectionToolbarItem)
DEFINE_TOOLBAR_ITEM(LaTeXLabelToolbarItem)
@end

NSString * const iTM2ToolbarLaTeXSubscriptItemIdentifier = @"subscript";
NSString * const iTM2ToolbarLaTeXSuperscriptItemIdentifier = @"superscript";

@implementation iTM2LaTeXInspector(Toolbar)
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
    NSToolbar * toolbar = [[[NSToolbar alloc] initWithIdentifier:iTM2LaTeXToolbarIdentifier] autorelease];
	NSString * key = [NSString stringWithFormat:@"NSToolbar Configuration %@", [toolbar identifier]];
	if([self contextBoolForKey:@"iTM2LaTeXToolbarShareConfiguration" domain:iTM2ContextAllDomainsMask])
	{
		NSDictionary * configDictionary = [SUD dictionaryForKey:key];
		if([configDictionary count])
		{
			[toolbar setConfigurationFromDictionary:configDictionary];
			if(![[toolbar items] count])
			{
				[SUD removeObjectForKey:key];
				toolbar = [[[NSToolbar alloc] initWithIdentifier:iTM2LaTeXToolbarIdentifier] autorelease];
			}
		}
	}
	else
	{
		NSDictionary * configDictionary = [SUD dictionaryForKey:key];
//iTM2_LOG(@"configDictionary: %@", configDictionary);
		configDictionary = [self contextDictionaryForKey:key domain:iTM2ContextAllDomainsMask];
//iTM2_LOG(@"configDictionary: %@", configDictionary);
		if([configDictionary count])
			[toolbar setConfigurationFromDictionary:configDictionary];
		if(![[toolbar items] count])
		{
			configDictionary = [SUD dictionaryForKey:key];
//iTM2_LOG(@"configDictionary: %@", configDictionary);
			[self takeContextValue:nil forKey:key domain:iTM2ContextAllDomainsMask];
			if([configDictionary count])
				[toolbar setConfigurationFromDictionary:configDictionary];
			if(![[toolbar items] count])
			{
				[SUD removeObjectForKey:key];
				toolbar = [[[NSToolbar alloc] initWithIdentifier:iTM2LaTeXToolbarIdentifier] autorelease];
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
	BOOL old = [self contextBoolForKey:@"iTM2LaTeXToolbarShareConfiguration" domain:iTM2ContextAllDomainsMask];
	[self takeContextBool: !old forKey:@"iTM2LaTeXToolbarShareConfiguration" domain:iTM2ContextAllDomainsMask];
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
	[sender setState: ([self contextBoolForKey:@"iTM2LaTeXToolbarShareConfiguration" domain:iTM2ContextAllDomainsMask]? NSOnState:NSOffState)];
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
	if([self contextBoolForKey:@"iTM2LaTeXToolbarAutosavesConfiguration" domain:iTM2ContextAllDomainsMask])
	{
		NSToolbar * toolbar = [[self window] toolbar];
		NSString * key = [NSString stringWithFormat:@"NSToolbar Configuration %@", [toolbar identifier]];
		[self takeContextValue:[toolbar configurationDictionary] forKey:key domain:iTM2ContextAllDomainsMask];
	}
//iTM2_START;
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([[self superclass] instancesRespondToSelector:_cmd])
		[super awakeFromNib];
	[self setAction:@selector(LaTeXSectionButtonAction:)];
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
	NSMenu * M = [[[[self window] windowController] textStorage] LaTeXSectionMenu];
	NSAssert(M, @"Missing LaTeX menu: inconsistency");
	NSMenuItem * MI = [[self menu] deepItemWithRepresentedObject:@"LaTeX Section Menu"];
	if(MI)
	{
		[[MI menu] setSubmenu: ([M numberOfItems]? M:nil) forItem:MI];
	}
	else if(MI = [[self menu] deepItemWithAction:@selector(gotoLaTeXSection:)])
	{
		[MI setAction:NULL];
		[MI setRepresentedObject:@"LaTeX Section Menu"];
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
	fileName = [[NSBundle bundleForClass:class] pathForResource:@"iTM2LaTeXSectionMenu" ofType:@"nib"];
	if([fileName length])
	{
		NSString * title = [self title];
		if([NSBundle loadNibFile:fileName externalNameTable:context withZone:[self zone]])
		{
			NSMenu * M = [[[owner menu] retain] autorelease];
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

@implementation iTM2LaTeXLabelButton
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
	[self setAction:@selector(LaTeXLabelButtonAction:)];
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
	fileName = [[NSBundle bundleForClass:class] pathForResource:@"iTM2LaTeXLabelMenu" ofType:@"nib"];
	if([fileName length])
	{
		NSString * title = [self title];
		if([NSBundle loadNibFile:fileName externalNameTable:context withZone:[self zone]])
		{
			NSMenu * M = [[[owner menu] retain] autorelease];
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
	[[[[self window] windowController] textStorage] getLaTeXLabelMenu: &labelMenu refMenu: &refMenu];
	NSAssert(labelMenu, @"Missing LaTeX label menu: inconsistency");
	NSAssert(refMenu, @"Missing LaTeX ref menu: inconsistency");
	NSMenuItem * MI = [[self menu] deepItemWithAction:@selector(gotoLaTeXLabel:)];
	if(MI)
	{
		[MI setAction:NULL];
		[MI setRepresentedObject:@"LaTeX Label Menu"];
		[[MI menu] setSubmenu: ([labelMenu numberOfItems]? labelMenu:nil) forItem:MI];
	}
	else if(MI = [[self menu] deepItemWithRepresentedObject:@"LaTeX Label Menu"])
	{
		[[MI menu] setSubmenu: ([labelMenu numberOfItems]? labelMenu:nil) forItem:MI];
	}
	if(MI = [[self menu] deepItemWithAction:@selector(gotoLaTeXReference:)])
	{
		[MI setAction:NULL];
		[MI setRepresentedObject:@"LaTeX Reference Menu"];
		[[MI menu] setSubmenu: ([refMenu numberOfItems]? refMenu:nil) forItem:MI];
	}
	else if(MI = [[self menu] deepItemWithRepresentedObject:@"LaTeX Reference Menu"])
	{
		[[MI menu] setSubmenu: ([refMenu numberOfItems]? refMenu:nil) forItem:MI];
	}
	labelMenu = [[labelMenu copy] autorelease];
	NSEnumerator * E = [[labelMenu itemArray] objectEnumerator];
	while(MI = [E nextObject])
		if([MI action] == @selector(scrollLaTeXLabelToVisible:))
			[MI setAction:@selector(_insertLaTeXKnownReference:)];
	if(MI = [[self menu] deepItemWithAction:@selector(insertLaTeXKnownReference:)])
	{
		[MI setAction:NULL];
		[MI setRepresentedObject:@"LaTeX Known Reference Menu"];
		[[MI menu] setSubmenu: ([labelMenu numberOfItems]? labelMenu:nil) forItem:MI];
	}
	else if(MI = [[self menu] deepItemWithRepresentedObject:@"LaTeX Known Reference Menu"])
	{
		[[MI menu] setSubmenu: ([labelMenu numberOfItems]? labelMenu:nil) forItem:MI];
	}
//iTM2_END;
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

#define BUNDLE [self classBundle]
#define TABLE @"iTM2InsertLaTeX"

@implementation iTM2LaTeXEditor
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= handlesKeyBindings
- (BOOL)handlesKeyBindings;
/*"YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Dec 15 14:34:51 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  bold:
- (void)bold:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users.sourceforge.net
To Do List:
"*/
{
//iTM2_START;
#warning: MISSING we should guess the environment, math or text and use the appropriate command
	[self executeMacroWithID:@"\\textbf{}|text"];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  italic:
- (void)italic:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users.sourceforge.net
To Do List:
"*/
{
//iTM2_START;
	[self executeMacroWithID:@"\\textit{}|text"];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  underline:
- (void)underline:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users.sourceforge.net
To Do List:
"*/
{
//iTM2_START;
	[self executeMacroWithID:@"\\underline{}|text"];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  alignCenter:
- (void)alignCenter:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users.sourceforge.net
To Do List:
"*/
{
//iTM2_START;
	[self executeMacroWithID:@"\\begin{center}..."];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  alignRight:
- (void)alignRight:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users.sourceforge.net
To Do List:
"*/
{
//iTM2_START;
	[self executeMacroWithID:@"\\begin{flushright}..."];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  alignLeft:
- (void)alignLeft:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users.sourceforge.net
To Do List:
"*/
{
//iTM2_START;
	[self executeMacroWithID:@"\\begin{flushleft}..."];
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
//iTM2_START;

    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  tightenKerning:
- (void)tightenKerning:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users.sourceforge.net
To Do List:
"*/
{
//iTM2_START;

    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  loosenKerning:
- (void)loosenKerning:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users.sourceforge.net
To Do List:
"*/
{
//iTM2_START;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  useStandardKerning:
- (void)useStandardKerning:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users.sourceforge.net
To Do List:
"*/
{
//iTM2_START;

    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  turnOffLigatures:
- (void)turnOffLigatures:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users.sourceforge.net
To Do List:
"*/
{
//iTM2_START;

    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  useStandardLigatures:
- (void)useStandardLigatures:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users.sourceforge.net
To Do List:
"*/
{
//iTM2_START;

    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  useAllLigatures:
- (void)useAllLigatures:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users.sourceforge.net
To Do List:
"*/
{
//iTM2_START;

    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  raiseBaseline:
- (void)raiseBaseline:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users.sourceforge.net
To Do List:
"*/
{
//iTM2_START;

    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  lowerBaseline:
- (void)lowerBaseline:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users.sourceforge.net
To Do List:
"*/
{
//iTM2_START;

    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  toggleTraditionalCharacterShape:
- (void)toggleTraditionalCharacterShape:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users.sourceforge.net
To Do List:
"*/
{
//iTM2_START;

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
//iTM2_START;
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
//NSLog(@"-[%@ %@] 0x%x", [self class], NSStringFromSelector(_cmd), self);
    // find what is the name of the current environment...
    NSString * name = [[self string] lossyLaTeXEnvironmentNameAtIndex: [self selectedRange].location];
    if([name length])
    {
        [self insertText:[NSString stringWithFormat: @"\\end{%@}", name]];
    }
    else
    {
        // Nothing was found: stop it here
        NSBeep();
        [self postNotificationWithToolTip:
            NSLocalizedStringFromTableInBundle(@"No open environment found.", @"TeX", [NSBundle bundleForClass:[self class]], "used in completeLaTeXEnvironment")];
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
//NSLog(@"-[%@ %@] 0x%x", [self class], NSStringFromSelector(_cmd), self);
    BOOL escaped;
    NSString * S = [self string];
    NSRange R = [self selectedRange];
    if(!R.location || ![S isControlAtIndex:R.location-1 escaped: &escaped] || escaped)
    {
        [self insertText:[NSString backslashString]];
    }
    else
    {
        [[self undoManager] beginUndoGrouping];
        [self insertText:[NSString backslashString]];
        [self insertNewline:self];
        [[self undoManager] endUndoGrouping];
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self executeMacroWithID:@"\\label{identifier}"];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateInsertLaTeXLabel:
- (BOOL)validateInsertLaTeXLabel:(id)sender;
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  gotoLaTeXLabel:
- (IBAction)gotoLaTeXLabel:(id)sender;
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateGotoLaTeXLabel:
- (BOOL)validateGotoLaTeXLabel:(id)sender;
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertLaTeXReference:
- (IBAction)insertLaTeXReference:(id)sender;
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self executeMacroWithID:@"\\ref{identifier}"];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateInsertLaTeXReference:
- (BOOL)validateInsertLaTeXReference:(id)sender;
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  gotoLaTeXReference:
- (IBAction)gotoLaTeXReference:(id)sender;
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateGotoLaTeXReference:
- (BOOL)validateGotoLaTeXReference:(id)sender;
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertLaTeXEquationReference:
- (IBAction)insertLaTeXEquationReference:(id)sender;
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self executeMacroWithID:@"\\eqref{identifier}"];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateInsertLaTeXEquationReference:
- (BOOL)validateInsertLaTeXEquationReference:(id)sender;
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  gotoLaTeXEquationReference:
- (IBAction)gotoLaTeXEquationReference:(id)sender;
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateGotoLaTeXEquationReference:
- (BOOL)validateGotoLaTeXEquationReference:(id)sender;
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  _insertLaTeXKnownReference:
- (IBAction)_insertLaTeXKnownReference:(id)sender;
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * domain = [self macroDomain];
	NSString * category = [self macroCategory];
	NSString * context = [self macroContext];
	NSString * knownReference = [sender representedObject];
	iTM2MacroNode * leafNode = [SMC macroRunningNodeForID:@"\\ref{}|identifier" context:context ofCategory:category inDomain:domain];
	NSDictionary * substitutions = [NSDictionary dictionaryWithObject:knownReference forKey:@"identifier"];
	[leafNode executeMacroWithTarget:self selector:NULL substitutions:substitutions];
//iTM2_END;
    return;
}
#pragma mark =-=-=-=-=-  SECTIONS
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  gotoLaTeXSection:
- (IBAction)gotoLaTeXSection:(id)sender;
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateGotoLaTeXSection:
- (BOOL)validateGotoLaTeXSection:(id)sender;
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertLaTeXChapter:
- (IBAction)insertLaTeXChapter:(id)sender;
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self executeMacroWithID:@"\\chapter{}|text_content"];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateInsertLaTeXChapter:
- (BOOL)validateInsertLaTeXChapter:(id)sender;
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertLaTeXPart:
- (IBAction)insertLaTeXPart:(id)sender;
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self executeMacroWithID:@"\\part{}|text"];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateInsertLaTeXPart:
- (BOOL)validateInsertLaTeXPart:(id)sender;
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertLaTeXSection:
- (IBAction)insertLaTeXSection:(id)sender;
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self executeMacroWithID:@"\\section{}|text"];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateInsertLaTeXSection:
- (BOOL)validateInsertLaTeXSection:(id)sender;
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertLaTeXSubSection:
- (IBAction)insertLaTeXSubSection:(id)sender;
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self executeMacroWithID:@"\\subsection{}|text"];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateInsertLaTeXSubSection:
- (BOOL)validateInsertLaTeXSubSection:(id)sender;
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertLaTeXSubSubSection:
- (IBAction)insertLaTeXSubSubSection:(id)sender;
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self executeMacroWithID:@"\\subsubsection{}|text"];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateInsertLaTeXSubSubSection:
- (BOOL)validateInsertLaTeXSubSubSection:(id)sender;
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertLaTeXParagraph:
- (IBAction)insertLaTeXParagraph:(id)sender;
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self executeMacroWithID:@"\\paragraph{}|text"];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateInsertLaTeXParagraph:
- (BOOL)validateInsertLaTeXParagraph:(id)sender;
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertLaTeXSubParagraph:
- (IBAction)insertLaTeXSubParagraph:(id)sender;
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self executeMacroWithID:@"\\subparagraph{}|text"];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateInsertLaTeXSubParagraph:
- (BOOL)validateInsertLaTeXSubParagraph:(id)sender;
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  scrollLaTeXLabelToVisible:
- (void)scrollLaTeXLabelToVisible:(id <NSMenuItem>)sender;
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  scrollLaTeXReferenceToVisible:
- (void)scrollLaTeXReferenceToVisible:(id <NSMenuItem>)sender;
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  delayedScrollInputToVisible:
- (void)delayedScrollInputToVisible:(id <NSMenuItem>)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
#warning To be improved
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  scrollInputToVisible:
- (void)scrollInputToVisible:(id <NSMenuItem>)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self performSelector:@selector(delayedScrollInputToVisible:) withObject:sender afterDelay:0.1];
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  findLaTeXEnvironment:
- (void)findLaTeXEnvironment:(id)sender;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 02/03/2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    // find what is the name of the current environment...
    NSRange range;
    [[self string] LaTeXEnvironmentNameForRange:[self selectedRange] effectiveRange: &range];
    if(range.location == NSNotFound)
    {
        // Nothing was found: stop it here
        NSBeep();
        [self postNotificationWithToolTip:
            NSLocalizedStringFromTableInBundle(@"No environment found.", @"TeX", [NSBundle bundleForClass:[self class]], "used in completeLaTeXEnvironment")];
    }
    else
    {
        [self setSelectedRange:[[self string] rangeBySelectingParagraphIfNeededWithRange:range]];
    }
//iTM2_END;
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
//iTM2_START;
    if(([event clickCount]>2) && ![iTM2EventObserver isAlternateKeyDown])
    {
//NSLog(@"[event clickCount]: %i", [event clickCount]);
        NSString * S = [self string];
        NSRange SR = [self selectedRange];
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
        unsigned start, end;
        [S getLineStart: &start end: &end contentsEnd:nil forRange:CR];
        end -= start;
        NSRange PR = (end>SR.length)? NSMakeRange(start, end): NSMakeRange(0, [S length]);
        if(GR.location == NSNotFound)
        {
            if(ER.location == NSNotFound)
            {
                [self setSelectedRange:PR];
                return;
            }
            else
            {
                ER = [S rangeBySelectingParagraphIfNeededWithRange:ER];
				if((ER.location<=PR.location) && (NSMaxRange(ER)>=NSMaxRange(PR)))
					ER = PR;
				else if(NSLocationInRange(ER.location, PR))
					PR = ER;
				else if(NSLocationInRange(NSMaxRange(ER)-1, PR))
					PR = ER;
                [self setSelectedRange: (PR.length<ER.length? PR:ER)];
                return;
            }
        }
        else if(ER.location == NSNotFound)
        {
			if((GR.location<=PR.location) && (NSMaxRange(GR)>=NSMaxRange(PR)))
				GR = PR;
			else if(NSLocationInRange(GR.location, PR))
				PR = GR;
			else if(NSLocationInRange(NSMaxRange(GR)-1, PR))
				PR = GR;
			[self setSelectedRange: (GR.length<PR.length? GR:PR)];
            return;
        }
        else
        {
            ER = [S rangeBySelectingParagraphIfNeededWithRange:ER];
			// if PR is included in ER, we choose PR
			// we prefer consistant selections
//iTM2_LOG(@"ER: %@", NSStringFromRange(ER));
//iTM2_LOG(@"GR: %@", NSStringFromRange(GR));
//iTM2_LOG(@"PR: %@", NSStringFromRange(PR));
			if((ER.location<=PR.location) && (NSMaxRange(ER)>=NSMaxRange(PR)))
				ER = PR;
			else if(NSLocationInRange(ER.location, PR))
				PR = ER;
			else if(NSLocationInRange(NSMaxRange(ER)-1, PR))
				PR = ER;
			if((GR.location<=PR.location) && (NSMaxRange(GR)>=NSMaxRange(PR)))
				GR = PR;
			else if(NSLocationInRange(GR.location, PR))
				PR = GR;
			else if(NSLocationInRange(NSMaxRange(GR)-1, PR))
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
- (NSRange)_nextLaTeXEnvironmentDelimiterRangeAfterIndex:(unsigned)index effectiveName:(NSString **)namePtr isOpening:(BOOL *)flagPtr;
- (NSRange)_previousLaTeXEnvironmentDelimiterRangeBeforeIndex:(unsigned)index effectiveName:(NSString **)namePtr isOpening:(BOOL *)flagPtr;
@end

@implementation NSString (iTM2LaTeXKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= LaTeXEnvironmentNameForRange:effectiveRange:
- (NSString *)LaTeXEnvironmentNameForRange:(NSRange)range effectiveRange:(NSRangePointer)rangePtr;
/*"Given a selected range, returns the name of the latex environment and the effective range.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 02/03/2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSMutableArray * nameStack = [NSMutableArray array];
    NSString * name;
    BOOL isOpening;
    NSRange R = [self _previousLaTeXEnvironmentDelimiterRangeBeforeIndex: (range.location<[self length]? range.location+1:range.location) effectiveName: &name isOpening: &isOpening];
    if(R.location == NSNotFound)
        goto bail;
    if((range.location>=R.location) && (NSMaxRange(range)<=NSMaxRange(R)))
    {
//iTM2_LOG(@"Inside a latex environment delimiter...");
        // we just have to balance this range
        [nameStack addObject:name];
        if(isOpening)
        {
//iTM2_LOG(@"Opening...");
            unsigned anchor = R.location;
            NSString * otherName;
faaa:
            R = [self _nextLaTeXEnvironmentDelimiterRangeAfterIndex:NSMaxRange(R) effectiveName: &otherName isOpening: &isOpening];
            if(R.location == NSNotFound)
                goto bail;
            if(isOpening)
            {
                [nameStack addObject:otherName];
                goto faaa;
            }
            if(![otherName isEqualToString:[nameStack lastObject]])
                goto bail;
            if([nameStack count]>1)
            {
                [nameStack removeLastObject];
                goto faaa;
            }
            if(rangePtr)
                *rangePtr = NSMakeRange(anchor, NSMaxRange(R)-anchor);
            return [nameStack lastObject];
        }
        else
        {
//iTM2_LOG(@"Closing...");
            unsigned anchor = NSMaxRange(R);
            NSString * otherName;
fakarava:
            R = [self _previousLaTeXEnvironmentDelimiterRangeBeforeIndex:R.location effectiveName: &otherName isOpening: &isOpening];
            if(R.location == NSNotFound)
            {
                 [self postNotificationWithToolTip:
                    [NSString stringWithFormat:
                        NSLocalizedStringFromTableInBundle(@"Missing \\begin{%@}.", @"TeX",
                            [self classBundle], "used in LaTeX Environment management"), [nameStack lastObject]]];
                iTM2Beep();
                goto bail;
            }
            if(isOpening)
            {
                if(![otherName isEqualToString:[nameStack lastObject]])
                {
                    [self postNotificationWithToolTip:
                        [NSString stringWithFormat:
                            NSLocalizedStringFromTableInBundle(@"Missing \\begin{%@}.", @"TeX",
                                [self classBundle], "used in LaTeX Environment management"), [nameStack lastObject]]];
                    iTM2Beep();
                    goto bail;
                }
                if([nameStack count]>1)
                {
                    [nameStack removeLastObject];
                    goto fakarava;
                }
//iTM2_LOG(@"Normal...");
                if(rangePtr)
                    *rangePtr = NSMakeRange(R.location, anchor-R.location);
                return [nameStack lastObject];
            }
            [nameStack addObject:otherName];
            goto fakarava;
        }
        //unreachable code
    }
//iTM2_LOG(@"*****  NOT Inside a delimiter...");

	// we start by balancing this range

    unsigned leftAnchor = R.location;
    unsigned rightAnchor = NSMaxRange(R);
manihi:
    [nameStack addObject:name];
//iTM2_LOG(@"[nameStack lastObject]: %@", [nameStack lastObject]);
    if(isOpening)
    {
//iTM2_LOG(@"is opening");
        NSString * otherName;
huahine:
        R = [self _nextLaTeXEnvironmentDelimiterRangeAfterIndex:rightAnchor effectiveName: &otherName isOpening: &isOpening];
        if(R.location == NSNotFound)
            goto bail;
        if(isOpening)
        {
            [nameStack addObject:otherName];
            rightAnchor = NSMaxRange(R);
            goto huahine;
        }
        if(![otherName isEqualToString:[nameStack lastObject]])
            goto bail;
        if([nameStack count]>1)
        {
            [nameStack removeLastObject];
            rightAnchor = NSMaxRange(R);
            goto huahine;
        }
        rightAnchor = NSMaxRange(R);
        if(NSMaxRange(range)<rightAnchor)
        {
            if(rangePtr)
                *rangePtr = NSMakeRange(leftAnchor, rightAnchor-leftAnchor);
            return [nameStack lastObject];
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
//iTM2_LOG(@"is closing");
        NSString * otherName;
taiao:
        R = [self _previousLaTeXEnvironmentDelimiterRangeBeforeIndex:leftAnchor effectiveName: &otherName isOpening: &isOpening];
        if(R.location == NSNotFound)
        {
            [self postNotificationWithToolTip:
                [NSString stringWithFormat:
                    NSLocalizedStringFromTableInBundle(@"Missing \\begin{%@}.", @"TeX",
                        [self classBundle], "used in LaTeX Environment management"), [nameStack lastObject]]];
            iTM2Beep();
            goto bail;
        }
        leftAnchor = R.location;
        if(isOpening)
        {
            if(![otherName isEqualToString:[nameStack lastObject]])
            {
                [self postNotificationWithToolTip:
                    [NSString stringWithFormat:
                        NSLocalizedStringFromTableInBundle(@"Missing \\begin{%@}.", @"TeX",
                            [self classBundle], "used in LaTeX Environment management"), [nameStack lastObject]]];
                iTM2Beep();
                goto bail;
            }
            [nameStack removeLastObject];
            if([nameStack count])
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
        *rangePtr = NSMakeRange(NSNotFound, 0);
    return [NSString string];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= lossyLaTeXEnvironmentNameAtIndex:
- (NSString *)lossyLaTeXEnvironmentNameAtIndex:(unsigned)index;
/*"Given an index, returns the name of the latex environment.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 02/03/2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSMutableArray * nameStack = [NSMutableArray array];
    NSString * name;
    BOOL isOpening;
    NSRange R = [self _previousLaTeXEnvironmentDelimiterRangeBeforeIndex:index effectiveName: &name isOpening: &isOpening];
    if(R.location == NSNotFound)
        return [NSString string];
    if((index>R.location) && (index<NSMaxRange(R)))
        return [NSString string];
    
//iTM2_LOG(@"*****  NOT Inside a delimiter...");

        // we start by balancing this range
        
    unsigned leftAnchor = R.location;
    unsigned rightAnchor = NSMaxRange(R);
    manihi:
    [nameStack addObject:name];
//iTM2_LOG(@"[nameStack lastObject]: %@", [nameStack lastObject]);
    if(isOpening)
    {
//iTM2_LOG(@"is opening");
        NSString * otherName;
        huahine:
        R = [self _nextLaTeXEnvironmentDelimiterRangeAfterIndex:rightAnchor effectiveName: &otherName isOpening: &isOpening];
        if(R.location == NSNotFound)
        // eureka
            return [nameStack lastObject];
        else if(isOpening)
        {
            // a new envir is open, we must close it first
            [nameStack addObject:otherName];
            rightAnchor = NSMaxRange(R);
            goto huahine;
        }
        else if(![otherName isEqualToString:[nameStack lastObject]])
        // a closing environment which is not the current environment
        {
            if(index<=R.location)
                return [nameStack lastObject];
            else
                goto bail;
        }
        else if([nameStack count]>1)
        {
            [nameStack removeLastObject];
            rightAnchor = NSMaxRange(R);
            goto huahine;
        }
        rightAnchor = NSMaxRange(R);
        if(index<=R.location)
            return [nameStack lastObject];
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
//iTM2_LOG(@"is closing");
        NSString * otherName;
        taiao:
        R = [self _previousLaTeXEnvironmentDelimiterRangeBeforeIndex:leftAnchor effectiveName: &otherName isOpening: &isOpening];
        if(R.location == NSNotFound)
        {
            [self postNotificationWithToolTip:
                [NSString stringWithFormat:
                    NSLocalizedStringFromTableInBundle(@"Missing \\begin{%@}.", @"TeX",
                        [self classBundle], "used in LaTeX Environment management"), [nameStack lastObject]]];
            iTM2Beep();
            goto bail;
        }
        leftAnchor = R.location;
        if(isOpening)
        {
            if(![otherName isEqualToString:[nameStack lastObject]])
            {
                [self postNotificationWithToolTip:
                    [NSString stringWithFormat:
                        NSLocalizedStringFromTableInBundle(@"Missing \\begin{%@}.", @"TeX",
                            [self classBundle], "used in LaTeX Environment management"), [nameStack lastObject]]];
                iTM2Beep();
                goto bail;
            }
            [nameStack removeLastObject];
            if([nameStack count])
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
- (NSRange)_nextLaTeXEnvironmentDelimiterRangeAfterIndex:(unsigned)index effectiveName:(NSString **)namePtr isOpening:(BOOL *)flagPtr;
/*"Returns the first occurrence of something like regexp "\\begin\s*([.*?]\s*)*\{(.*?)\}" or \\end... (quite...)
searchRange.location<=result.location < index, result.location is the max
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 02/03/2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSRange R = [self _previousLaTeXEnvironmentDelimiterRangeBeforeIndex: (index<[self length]?index+1:index) effectiveName:namePtr isOpening:flagPtr];
    if(index < NSMaxRange(R))
        return R;
    iTM2LiteScanner * S = [iTM2LiteScanner scannerWithString:self];
    faaa:
    if(index < [self length])
    {
        R = [self rangeOfString:[NSString backslashString] options:0L range:NSMakeRange(index, [self length]-index)];
        if(R.location == NSNotFound)
            goto bail;
        BOOL escaped = NO;
        index = NSMaxRange(R);
        if(R.location && [self isControlAtIndex:R.location-1 escaped: &escaped] && !escaped)
            goto faaa;
        unsigned anchor = R.location;
        NSRange searchRange = NSMakeRange(anchor+1, [self length]-anchor-1);
        R = [self rangeOfString:@"end" options:NSAnchoredSearch range:searchRange];
        if(R.location == NSNotFound)
        {
            R = [self rangeOfString:@"begin" options:NSAnchoredSearch range:searchRange];
            if(R.location == NSNotFound)
                goto faaa;
            index = NSMaxRange(R);
            [S setScanLocation:index];
            while([S scanString:@"[" intoString:nil])
            {
                R = [self groupRangeAtIndex:[S scanLocation]-1 beginDelimiter: '[' endDelimiter: ']'];
                if(R.location == NSNotFound)
                {
                    iTM2Beep();
                    [self postNotificationWithToolTip:
                        [NSString stringWithFormat:
                            NSLocalizedStringFromTableInBundle(@"Bad optional LaTeX environment parameter.", @"TeX",
                                [self classBundle], "used in completeLaTeXEnvironment")]];
                    goto bail;
                }
                index = NSMaxRange(R);
                [S setScanLocation:index];
            }
            if(![S scanString:@"{" intoString:nil])
                goto bail;
            NSString * envirName = nil;
            if(![S scanUpToString:@"}" intoString: &envirName])
                goto bail;
            if([envirName length])
            {
                if(namePtr)
                    *namePtr = [[envirName stringByAppendingString:@" "]
                        stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
                if(flagPtr)
                    *flagPtr = YES;
                return NSMakeRange(anchor, [S scanLocation]+1-anchor);
            }
        }
        else
        {
            index = NSMaxRange(R);
            [S setScanLocation:index];
            if(![S scanString:@"{" intoString:nil])
                goto bail;
            NSString * envirName = nil;
            if(![S scanUpToString:@"}" intoString: &envirName])
                goto bail;
            if([envirName length])
            {
                if(namePtr)
                    *namePtr = [[envirName stringByAppendingString:@" "]
                        stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
                if(flagPtr)
                    *flagPtr = NO;
                return NSMakeRange(anchor, [S scanLocation]+1-anchor);
            }
        }
    }
    bail:
    if(namePtr)
        *namePtr = @"";
    if(flagPtr)
        *flagPtr = NO;// irrelevant!!!
    return NSMakeRange(NSNotFound, 0);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= _previousLaTeXEnvironmentDelimiterRangeBeforeIndex:effectiveName:isOpening:
- (NSRange)_previousLaTeXEnvironmentDelimiterRangeBeforeIndex:(unsigned)index effectiveName:(NSString **)namePtr isOpening:(BOOL *)flagPtr;
/*"Returns the first occurrence of something like regexp "\\begin\s*([.*?]\s*)*\{(.*?)\}" or \\end... (quite...)
searchRange.location<=result.location < index, result.location is the max
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 02/03/2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    iTM2LiteScanner * S = [iTM2LiteScanner scannerWithString:self];
    faaa:
    if(index <= [self length])
    {
        NSRange R = [self rangeOfString:[NSString backslashString] options:NSBackwardsSearch range:NSMakeRange(0, index)];
        if(R.location == NSNotFound)
            goto bail;
        BOOL escaped = NO;
        index = R.location;
        if(R.location && [self isControlAtIndex:R.location-1 escaped: &escaped] && !escaped)
            goto faaa;
        unsigned anchor = R.location;
        NSRange searchRange = NSMakeRange(anchor+1, [self length]-anchor-1);
        R = [self rangeOfString:@"end" options:NSAnchoredSearch range:searchRange];
        if(R.location == NSNotFound)
        {
            R = [self rangeOfString:@"begin" options:NSAnchoredSearch range:searchRange];
            if(R.location == NSNotFound)
                goto faaa;
            index = NSMaxRange(R);
            [S setScanLocation:index];
            while([S scanString:@"[" intoString:nil])
            {
                R = [self groupRangeAtIndex:[S scanLocation]-1 beginDelimiter: '[' endDelimiter: ']'];
                if(R.location == NSNotFound)
                {
                    iTM2Beep();
                    [self postNotificationWithToolTip:
                        [NSString stringWithFormat:
                            NSLocalizedStringFromTableInBundle(@"Bad optional LaTeX environment parameter.", @"TeX",
                                [self classBundle], "used in completeLaTeXEnvironment")]];
                    goto bail;
                }
                index = NSMaxRange(R);
                [S setScanLocation:index];
            }
            if(![S scanString:@"{" intoString:nil])
                goto bail;
            NSString * envirName = nil;
            if(![S scanUpToString:@"}" intoString: &envirName])
                goto bail;
            if([envirName length])
            {
                if(namePtr)
                    *namePtr = [[envirName stringByAppendingString:@" "]
                        stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
                if(flagPtr)
                    *flagPtr = YES;
//iTM2_LOG(envirName);
                return NSMakeRange(anchor, [S scanLocation]+1-anchor);
            }
        }
        else
        {
            index = NSMaxRange(R);
            [S setScanLocation:index];
            if(![S scanString:@"{" intoString:nil])
                goto bail;
            NSString * envirName = nil;
            if(![S scanUpToString:@"}" intoString: &envirName])
                goto bail;
            if([envirName length])
            {
                if(namePtr)
                    *namePtr = [[envirName stringByAppendingString:@" "]
                        stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
                if(flagPtr)
                    *flagPtr = NO;
//iTM2_LOG(envirName);
                return NSMakeRange(anchor, [S scanLocation]+1-anchor);
            }
        }
    }
    bail:
    if(namePtr)
        *namePtr = @"";
    if(flagPtr)
        *flagPtr = NO;// irrelevant!!!
//iTM2_LOG(@"NO environment");
    return NSMakeRange(NSNotFound, 0);
}
@end

@implementation iTM2LaTeXWindow
@end

@implementation iTM2LaTeXParserAttributesServer
@end

@implementation iTM2XtdLaTeXParserAttributesServer
@end

static id _iTM2LaTeXModeForModeArray = nil;

#define _TextStorage (iTM2TextStorage *)_TS
#if 0
@implementation NSNotificationCenter(ouam)
+ (void)load;
{
	iTM2_INIT_POOL;
	iTM2RedirectNSLogOutput();
	[iTM2RuntimeBrowser swizzleInstanceMethodSelector:@selector(postNotificationName:object:userInfo:) replacement:@selector(swizzled_postNotificationName:object:userInfo:) forClass:self];
	iTM2_RELEASE_POOL;
	return;
}
- (void)swizzled_postNotificationName:(NSString *)aName object:(id)anObject userInfo:(NSDictionary *)aUserInfo;
{
	if([aName isEqualToString:NSPopUpButtonWillPopUpNotification])
		NSLog(@"COUCOU");
	[self swizzled_postNotificationName:(NSString *)aName object:(id)anObject userInfo:(NSDictionary *)aUserInfo];
}
@end
#endif

@implementation NSTextView(iTM2LaTeXKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  proposedRangeForLaTeXUserCompletion:
- (NSRange)proposedRangeForLaTeXUserCompletion:(NSRange)range;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 02/03/2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(range.location)
	{
		NSString * S = [self string];
		unichar theChar = [S characterAtIndex:range.location-1];
		if(theChar == '\\')
		{
			--range.location;
			++range.length;
		}
	}
//iTM2_END;
	return range;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  concreteReplacementStringForLaTeXMacro:selection:line:
- (NSString *)concreteReplacementStringForLaTeXMacro:(NSString *)macro selection:(NSString *)selectedString line:(NSString *)line;
/*"Description forthcoming. Will be completely overriden by subclassers.
Version history: jlaurens AT users DOT sourceforge DOT net (1.0.10)
- 1.2: 06/24/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	// what is the policy of the replacement?
	// first split the whole string into tokens
	if([macro hasPrefix:@"\\"])
	{
		NSMutableString * replacementString = [NSMutableString string];
		NSArray * components = [macro componentsSeparatedByString:@"|"];
		NSEnumerator * E = [components objectEnumerator];
		macro = [E nextObject];
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
		NSEnumerator * EE = [components objectEnumerator];
		NSString * component;
		while(component = [EE nextObject])
		{
			[replacementString appendString:component];
			if(component = [EE nextObject])
			{
				NSString * argument;
				if([component isEqual:@"M"])
				{
					[replacementString appendString:@"{@@@("];
					argument = [E nextObject];
					if(![argument length])
					{
						argument = selectedString;
					}
					[replacementString appendString:argument];			
					[replacementString appendString:@")@@@}"];
				}
				else if([component isEqual:@"O"])
				{
					[replacementString appendString:@"@@@([@@@("];
					argument = [E nextObject];
					if(![argument length])
					{
						argument = selectedString;
					}
					[replacementString appendString:argument];			
					[replacementString appendString:@")@@@])@@@"];
				}
				else if([component isEqual:@"P"])
				{
					[replacementString appendString:@"@@@((@@@("];
					argument = [E nextObject];
					if(![argument length])
					{
						argument = selectedString;
					}
					[replacementString appendString:argument];			
					[replacementString appendString:@")@@@,@@@("];
					argument = [E nextObject];
					if(![argument length])
					{
						argument = selectedString;
					}
					[replacementString appendString:argument];			
					[replacementString appendString:@")@@@))@@@"];
				}
			}
		}
		NSRange R = [macro doubleClickAtIndex:0];
		if(R.length == [macro length])
		{
			[replacementString appendString:@" "];
		}
		macro = replacementString;
	}
	else
	{
		ICURegEx * RE = [ICURegEx regExWithSearchPattern:@"^([^\\{\\}]*)\\{\\}([^\\{\\}]*)$"];
		if([RE matchString:macro])
		{
			macro = [NSString stringWithFormat:
				([self contextBoolForKey:@"iTM2DontUseSmartMacros" domain:iTM2ContextAllDomainsMask]?@"%@{%@}%@":@"%@{@@@(%@)@@@}%@"),
				[RE substringOfCaptureGroupAtIndex:1],selectedString,[RE substringOfCaptureGroupAtIndex:2]];
			[RE forget];
		}
		else
		{
			RE = [ICURegEx regExWithSearchPattern:@"^([^\\[\\]]*)\\[\\]([^\\[\\]]*)$"];
			if([RE matchString:macro])
			{
				macro = [NSString stringWithFormat:
					([self contextBoolForKey:@"iTM2DontUseSmartMacros" domain:iTM2ContextAllDomainsMask]?@"%@[%@]%@":@"%@[@@@(%@)@@@]%@"),
					[RE substringOfCaptureGroupAtIndex:1],selectedString,[RE substringOfCaptureGroupAtIndex:2]];
				[RE forget];
			}
		}
	}
	macro = (id)[self concreteReplacementStringForMacro:macro selection:selectedString line:line];
//iTM2_END;
   return macro;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  smartLaTeXMacroWithMacro:substitutions;
- (NSString *)smartLaTeXMacroWithMacro:(NSString *)macro substitutions:(NSDictionary *)substitutions;
/*"Description forthcoming. Will be completely overriden by subclassers.
Version history: jlaurens AT users DOT sourceforge DOT net (1.0.10)
- 1.2: 06/24/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([substitutions count])
	{
		id argument = [[argument mutableCopy] autorelease];
		NSEnumerator * E = [substitutions keyEnumerator];
		NSString * old;
		while(old = [E nextObject])
		{
			NSString * new = [substitutions objectForKey:old];
			NSRange searchRange = NSMakeRange(0,[argument length]);
			[argument replaceOccurrencesOfString:old withString:new options:nil range:searchRange];
		}
		macro = [NSString stringWithString:argument];
	}
//iTM2_END;
    return macro;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  useLaTeXPackage:
- (IBAction)useLaTeXPackage:(id)sender;
/*".
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	BOOL escaped;
	unsigned end;
    if([sender isKindOfClass:[NSControl class]])
	{
		// what?
		NSString * packageName = [sender title];
		NSString * actionName = [NSString stringWithFormat:@"useLaTeXPackage_%@:",packageName];
		SEL action = NSSelectorFromString(actionName);
		if([self respondsToSelector:action])
		{
			[self performSelector:action withObject:nil];
			return;
		}
		NSString * what = [NSString stringWithFormat:@"@@@(\\usepackage{%@}\n)@@@",packageName];
		// where
		// find the last usepackage used
		NSString * S = [self string];
		NSRange searchRange = NSMakeRange(0,[S length]);
		NSRange R;
mordor:
		R = [S rangeOfString:@"usepackage" options:nil range:searchRange];
		if(R.length)
		{
			if((R.location>0) && [S isControlAtIndex:R.location-1 escaped:&escaped] && !escaped)
			{
next_usepackage:
				searchRange.location = NSMaxRange(R);
				searchRange.length = [S length] - searchRange.location;
				NSRange nextR = [S rangeOfString:@"usepackage" options:nil range:searchRange];
				if(nextR.length)
				{
					R = nextR;
					goto next_usepackage;
				}
				else
				{
conclude:
					[S getLineStart:nil end:&end contentsEnd:nil forRange:R];
					[self setSelectedRange:NSMakeRange(end,0)];
					[self insertMacro:what];
					return;
				}
			}
			searchRange.location = NSMaxRange(R);
			searchRange.length = [S length] - searchRange.location;
			goto mordor;
		}
		// No usepackage found, this is the first
next_documentclass:
		R = [S rangeOfString:@"documentclass" options:nil range:R];
		if(R.length)
		{
			if((R.location>0) &&[S isControlAtIndex:R.location-1 escaped:&escaped] && !escaped)
			{
				goto conclude;
			}
			goto next_documentclass;
		}
//		[[self window] makeKeyAndOrderFront:self];
	}
    NSBeep();
//iTM2_END;
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
//iTM2_START;
    BOOL withGraphics = ([[NSApp currentEvent] modifierFlags] & NSAlternateKeyMask)!=0;
    NSMenu * sectionMenu = [[[NSMenu allocWithZone:[NSMenu menuZone]] initWithTitle:@""] autorelease];
    NSString * S = [self string];
    iTM2LiteScanner * scan = [iTM2LiteScanner scannerWithString:S];
    unsigned scanLocation = 0, end = [S length];
    unsigned sectionCount = 0, subsectionCount = 0, subsubsectionCount = 0;
    next:
    if(scanLocation < end)//postN
    {
        int depth = 0;
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
                else if (theChar == 'p')
                {
                    if(++scanLocation<end)
                    {
                        NSRange searchRange = NSMakeRange(scanLocation, end-scanLocation);
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
        else if(theChar == 'b')
        {
            if(++scanLocation < end)
            {
                theChar = [S characterAtIndex:scanLocation];
                NSRange searchRange = NSMakeRange(scanLocation, end-scanLocation);
                NSRange R1 = [S rangeOfString:@"eginfig" options:NSAnchoredSearch range:searchRange];
                if(R1.length)
                {
                    scanLocation += 6;// section
                    depth = sectionDepth;
                    unsigned int contentsEnd;
    //NSLog(@"manihi: %i", depth);
    //NSLog(@"3");
                    [S getLineStart:nil end:nil contentsEnd: &contentsEnd forRange:R1];
    //NSLog(@"3");
                    [scan setScanLocation:scanLocation];
                    int numero;
                    if([scan scanString:@"(" intoString:nil] && [scan scanInt: &numero] && [scan scanString:@")" intoString:nil])
                    {
                        NSString * title;
                        title = [NSString stringWithFormat:@"figure: %i", numero];
                        title = ([title length] > 48)?
                                        [NSString stringWithFormat:@"%@[...]",
                                                [title substringWithRange:NSMakeRange(0,43)]]: title;
                        if(![title length])
                            title = @"?";
                        NSMenuItem * MI = [sectionMenu addItemWithTitle: title
                                                action: @selector(scrollTaggedToVisible:) keyEquivalent: [NSString string]];
                        [MI setTag:scanLocation];
                        //[MI setRepresentedObject:object];
                        [MI setEnabled: ([[sectionMenu title] length] > 0)];
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
//iT -ENDING SUCCESSFULLY", [self class], NSStringFromSelector(_cmd), self);
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
                                                            action: @selector(scrollLaTeXLabelToVisible:)
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
                                                            action: @selector(scrollLaTeXReferenceToVisible:)
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= load
+ (void)load;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
	iTM2_INIT_POOL;
	iTM2RedirectNSLogOutput();
//iTM2_START;
//iTM2_LOG(@"iTM2TeXParser");
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
    return @"LaTeX";
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
- (unsigned)getSyntaxMode:(unsigned *)newModeRef forCharacter:(unichar)theChar previousMode:(unsigned)previousMode;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Dec 12 22:44:56 GMT 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
	NSParameterAssert(newModeRef);
//iTM2_START;
	unsigned previousError = previousMode & kiTM2TeXErrorSyntaxMask;
	unsigned previousModifier = previousMode & kiTM2TeXModifiersSyntaxMask;
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
	unsigned previousModeWithoutModifiers = previousMode & ~kiTM2TeXFlagsSyntaxMask;
	unsigned newModifier = previousModifier;
	NSCharacterSet * set = [NSCharacterSet TeXLetterCharacterSet];
	unsigned newMode = previousModeWithoutModifiers;

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
			if([_AS character:theChar isMemberOfCoveredCharacterSetForMode:syntaxMode])
			{
				* newModeRef = newMode | previousError | newModifier;
				return kiTM2TeXNoErrorSyntaxStatus;
			}
			else
			{
	//iTM2_LOG(@"AN ERROR OCCURRED");
				* newModeRef = newMode | previousError | newModifier | kiTM2TeXErrorFontSyntaxMask;
				return kiTM2TeXErrorSyntaxStatus;
			}
		}
		else
			return [super getSyntaxMode:newModeRef forCharacter:theChar previousMode:kiTM2TeXCommandContinueSyntaxMode];
		default:
			return [super getSyntaxMode:newModeRef forCharacter:theChar previousMode:previousMode];
	}
//iTM2_END;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  getSyntaxMode:forLocation:previousMode:effectiveLength:nextModeIn:before:
- (unsigned)getSyntaxMode:(unsigned *)newModeRef forLocation:(unsigned)location previousMode:(unsigned)previousMode effectiveLength:(unsigned *)lengthRef nextModeIn:(unsigned *)nextModeRef before:(unsigned)beforeIndex;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Dec 12 22:44:56 GMT 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSParameterAssert(newModeRef);
    NSString * S = [_TextStorage string];
    NSParameterAssert(location<[S length]);
	NSString * substring;
	NSRange r;
	unsigned status;
//	unsigned previousError = previousMode & kiTM2TeXErrorSyntaxMask;
//	unsigned previousModifier = previousMode & kiTM2TeXModifiersSyntaxMask;
	unsigned previousModeWithoutModifiers = previousMode & ~kiTM2TeXFlagsSyntaxMask;
	unichar theChar = [S characterAtIndex:location];
	NSCharacterSet * set = [NSCharacterSet TeXLetterCharacterSet];
	if(kiTM2TeXCommandStartSyntaxMode == previousModeWithoutModifiers)
	{
		if([set characterIsMember:theChar])
		{
			// is it a \include, \includegraphics, \url
			// scanning from location for the control sequence name
			unsigned start = location-1;
			unsigned end = location+1;
			while(end<[S length] && ((theChar = [S characterAtIndex:end]),[set characterIsMember:theChar]))
				++end;
			if(end == start+16)
			{
				r = NSMakeRange(start, end-start);
				substring = [S substringWithRange:r];
#define RETURN_MODE(SyntaxModeName,SyntaxMode) if([SyntaxModeName isEqualToString:substring])\
				{\
					if(lengthRef)\
					{\
						* lengthRef = end-start-1;\
					}\
					* newModeRef = SyntaxMode;\
					if(nextModeRef && (end<[S length]))\
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
				r = NSMakeRange(start, end-start);
				substring = [S substringWithRange:r];
				RETURN_MODE(iTM2LaTeXSubsubsubparagraphSyntaxModeName,kiTM2LaTeXSubsubsubparagraphSyntaxMode)
			}
			else if(end == start+16)
			{
				r = NSMakeRange(start, end-start);
				substring = [S substringWithRange:r];
				RETURN_MODE(iTM2LaTeXSubsubparagraphSyntaxModeName,kiTM2LaTeXSubsubparagraphSyntaxMode)
			}
			else if(end == start+15)
			{
				r = NSMakeRange(start, end-start);
				substring = [S substringWithRange:r];
				RETURN_MODE(iTM2LaTeXIncludegraphixSyntaxModeName,kiTM2LaTeXIncludegraphixSyntaxMode);
			}
			else if(end == start+14)
			{
				r = NSMakeRange(start, end-start);
				substring = [S substringWithRange:r];
				RETURN_MODE(iTM2LaTeXSubsubsectionSyntaxModeName,kiTM2LaTeXSubsubsectionSyntaxMode)
			}
			else if(end == start+13)
			{
				r = NSMakeRange(start, end-start);
				substring = [S substringWithRange:r];
				RETURN_MODE(iTM2LaTeXSubparagraphSyntaxModeName,kiTM2LaTeXSubparagraphSyntaxMode)
			}
			else if(end == start+11)
			{
				r = NSMakeRange(start, end-start);
				substring = [S substringWithRange:r];
				RETURN_MODE(iTM2LaTeXSubsectionSyntaxModeName,kiTM2LaTeXSubsubsectionSyntaxMode)
			}
			else if(end == start+10)
			{
				r = NSMakeRange(start, end-start);
				substring = [S substringWithRange:r];
				RETURN_MODE(iTM2LaTeXParagraphSyntaxModeName,kiTM2LaTeXParagraphSyntaxMode)
			}
			else if(end == start+8)
			{
				r = NSMakeRange(start, end-start);
				substring = [S substringWithRange:r];
				RETURN_MODE(iTM2LaTeXIncludeSyntaxModeName,kiTM2LaTeXIncludeSyntaxMode)
				else
				RETURN_MODE(iTM2LaTeXSectionSyntaxModeName,kiTM2LaTeXSectionSyntaxMode)
			}
			else if(end == start+4)
			{
				r = NSMakeRange(start, end-start);
				substring = [S substringWithRange:r];
				RETURN_MODE(iTM2LaTeXURLSyntaxModeName,kiTM2LaTeXURLSyntaxMode)
			}
		}
	}
	if(nextModeRef)
	{
		unsigned result = [super getSyntaxMode:newModeRef forLocation:location previousMode:previousMode effectiveLength:lengthRef nextModeIn:nextModeRef before:beforeIndex];
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
//iTM2_END;
}
#import "iTM2LaTeXStorageAttributes.m"
#endif
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= didClickOnLink:atIndex:
- (BOOL)didClickOnLink:(id)link atIndex:(unsigned)charIndex;
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSTextStorage * TS = [self textStorage];
	NSRange R = [iTM2TeXStringController TeXAwareWordRangeInAttributedString:TS atIndex:charIndex];
	if(R.length>1)
	{
		NSString * S = [TS string];
		NSString * command = [S substringWithRange:R];
		if([command isEqualToString:iTM2LaTeXIncludeSyntaxModeName])
		{
			unsigned start = NSMaxRange(R);
			if(start < [S length])
			{
				unsigned contentsEnd, TeXComment;
				[S getLineStart:nil end:nil contentsEnd: &contentsEnd TeXComment: &TeXComment forIndex:start];
				NSString * string = [S substringWithRange:
					NSMakeRange(start, (TeXComment == NSNotFound? contentsEnd: TeXComment)-start)];
				NSScanner * scanner = [NSScanner scannerWithString:string];
				[scanner scanString:@"{" intoString:nil];
				NSString * fileName;
				if([scanner scanCharactersFromSet:[NSCharacterSet TeXFileNameLetterCharacterSet] intoString: &fileName])
				{
					if(![fileName hasPrefix:@"/"])
					{
						fileName = [[TS document] fileName];
						fileName = [[fileName stringByDeletingLastPathComponent] stringByAppendingPathComponent:fileName];
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
				return YES;
			}
		}
		else if([command isEqualToString:iTM2LaTeXIncludegraphicsSyntaxModeName]
					||[command isEqualToString:iTM2LaTeXIncludegraphixSyntaxModeName])
		{
			unsigned start = NSMaxRange(R);
			if(start < [S length])
			{
				unsigned contentsEnd, TeXComment;
				[S getLineStart:nil end:nil contentsEnd: &contentsEnd TeXComment: &TeXComment forIndex:start];
				NSString * string = [S substringWithRange:
					NSMakeRange(start, (TeXComment == NSNotFound? contentsEnd: TeXComment)-start)];
				NSScanner * scanner = [NSScanner scannerWithString:string];
				[scanner scanString:@"{" intoString:nil];
				NSString * fileName;
				if([scanner scanCharactersFromSet:[NSCharacterSet TeXFileNameLetterCharacterSet] intoString: &fileName])
				{
					if(![fileName hasPrefix:@"/"])
					{
						fileName = [[TS document] fileName];
						fileName = [[fileName stringByDeletingLastPathComponent] stringByAppendingPathComponent:fileName];
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
				return YES;
			}
		}
		else if([command isEqualToString:iTM2LaTeXURLSyntaxModeName])
		{
			unsigned start = NSMaxRange(R);
			if(start < [S length])
			{
				unsigned contentsEnd, TeXComment;
				[S getLineStart:nil end:nil contentsEnd: &contentsEnd TeXComment: &TeXComment forIndex:start];
				NSString * string = [S substringWithRange:
					NSMakeRange(start, (TeXComment == NSNotFound? contentsEnd: TeXComment)-start)];
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
				return YES;
			}
		}
	}
//iTM2_END;
	return [super didClickOnLink:link atIndex:charIndex];
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return @"LaTeX-Xtd";
}
#if 1
#import "iTM2LaTeXStorageAttributes.m"
#endif
@end

NSString * const iTM2LaTeXParserAttributesInspectorType = @"iTM2LaTeXParserAttributes";

@implementation iTM2LaTeXParserAttributesDocument
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inspectorType
+ (NSString *)inspectorType;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return iTM2LaTeXParserAttributesInspectorType;
}
@end

@implementation iTM2LaTeXParserAttributesInspector
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inspectorType
+ (NSString *)inspectorType;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return iTM2LaTeXParserAttributesInspectorType;
}
@end

NSString * const iTM2XtdLaTeXParserAttributesInspectorType = @"iTM2XtdLaTeXParserAttributes";

@implementation iTM2XtdLaTeXParserAttributesDocument
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inspectorType
+ (NSString *)inspectorType;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return iTM2XtdLaTeXParserAttributesInspectorType;
}
@end

@implementation iTM2XtdLaTeXParserAttributesInspector
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inspectorType
+ (NSString *)inspectorType;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return iTM2XtdLaTeXParserAttributesInspectorType;
}
@end

@implementation iTM2XtdLaTeXParserSymbolsInspector
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inspectorType
+ (NSString *)inspectorType;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  LaTeXLabelActionWillPopUp:
- (BOOL)LaTeXLabelActionWillPopUp:(id)sender;
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  LaTeXSectionAction:
- (IBAction)LaTeXSectionAction:(id)sender;
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  LaTeXSectionActionWillPopUp:
- (BOOL)LaTeXSectionActionWillPopUp:(id)sender;
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


@implementation iTM2LaTeXLogParser
static NSDictionary * _iTM2LaTeXLogColors = nil;
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  load
+ (void)load;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Apr 16 11:39:43 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
    iTM2_INIT_POOL;
	iTM2RedirectNSLogOutput();
//iTM2_START;
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
//iTM2_END;
	iTM2_RELEASE_POOL;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  key
+ (NSString *)key;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Apr 16 11:39:43 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return @"LaTeX";
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  attributedMessageWithString:previousMessage:
+ (id)attributedMessageWithString:(NSString *)string previousMessage:(NSAttributedString *)message;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/11/01)
- 1.4: Fri Apr 16 11:39:43 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//NSLog(@"****  The STRING IS: %@", string);
    NSDictionary * attributes = [message length]?
        [message attributesAtIndex:[message length] - 1 effectiveRange:nil]:
            nil;
    // looking for the last page number previously parsed (problem with non continuous page numbers...)
    // WHAT WAS PREVIOUSLY THERE?
    NSNumber * oldPageNumber = [attributes objectForKey:iTM2LogPageNumberAttributeName]?:[NSNumber numberWithInt:0];
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
    NSRange R = NSMakeRange(0, [MS length]);
    NSRange lineRange = NSMakeRange(0, 0);
    iTM2LiteScanner * scanner = [iTM2LiteScanner scannerWithString:string];
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
            int line;
            if([scanner scanInt: &line])
            {
                lineRange.length = [scanner scanLocation] - lineRange.location;
                [MAS addAttribute:NSLinkAttributeName value:[NSNull null] range:lineRange];
				NSNumber * N = [NSNumber numberWithInt:line];
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
            int line;
            if([scanner scanInt: &line])
            {
                lineRange.length = [scanner scanLocation] - lineRange.location;
                [MAS addAttribute:NSLinkAttributeName value:[NSNull null] range:lineRange];
                [MAS addAttribute:iTM2LogLinkLineAttributeName value:[NSNumber numberWithInt:line] range:lineRange];
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
		int line;
		if([scanner scanInt: &line])
		{
			lineRange.length = [scanner scanLocation] - lineRange.location;
			[MAS addAttribute:NSLinkAttributeName value:type range:lineRange];
			NSNumber * N = [NSNumber numberWithInt:line];
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
		NSRange fileRange = NSMakeRange(0, 0);
		fileRange.location = [scanner scanLocation];
		NSString * file;
		if([scanner scanCharactersFromSet:[NSCharacterSet TeXFileNameLetterCharacterSet] intoString: &file])
		{
			fileRange.length = [scanner scanLocation] - fileRange.location;
			[MAS addAttribute:NSLinkAttributeName value:[NSNull null] range:fileRange];
			[MAS addAttribute:iTM2LogLinkFileAttributeName value:file range:fileRange];
 		}
        goto finish;
	}
    else if([scanner scanString:@"Transcript written on " intoString:nil])
    {
		NSRange fileRange = NSMakeRange(0, 0);
		fileRange.location = [scanner scanLocation];
		NSString * file;
		if([scanner scanCharactersFromSet:[NSCharacterSet TeXFileNameLetterCharacterSet] intoString: &file])
		{
			fileRange.length = [scanner scanLocation] - fileRange.location;
			if([file hasSuffix:@"."])// there is a final "." unwanted
			{
				--fileRange.length;
				file = [file substringWithRange:NSMakeRange(0, [file length] - 1)];
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
        unsigned contentsEnd;
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
        [scanner setScanLocation:NSMaxRange(lineRange)];
        int line;
        if([scanner scanInt: &line])
        {
            lineRange.length = [scanner scanLocation] - lineRange.location;
			[MAS addAttribute:NSLinkAttributeName value:[NSNull null] range:lineRange];
			[MAS addAttribute:iTM2LogLinkLineAttributeName value:[NSNumber numberWithInt:line] range:lineRange];
        }
    }
    finish:
//NSLog(@"****  The type is: %@", type);
    if(dontIgnoreFilesAndPages)
    {
        NSRange attributeRange = NSMakeRange(0, [string length]);
        unsigned contentsEnd;
        [string getLineStart:nil end:nil contentsEnd: &contentsEnd forRange:attributeRange];
//NSLog(@"File or pages? %@", string);
        NSArray * files = [attributes objectForKey:iTM2LogFilesStackAttributeName]?:[NSArray array];
        if(contentsEnd>=[string length])
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
        NSRange openRange = [string rangeOfString:@"(" options:0L range:searchRange];
        NSRange closeRange = [string rangeOfString:@")" options:0L range:searchRange];
        openingOrClosingAFile:
//NSLog(@"Scanning: %@ (open is %@, close is: %@)", files, NSStringFromRange(openRange), NSStringFromRange(closeRange));
        if(openRange.location<closeRange.location)
        {
//NSLog(@"Opening");
            attributeRange.length = openRange.location + 1 - attributeRange.location;
            [MAS addAttribute:iTM2LogFilesStackAttributeName value:files range:attributeRange];
            attributeRange.location = NSMaxRange(attributeRange);
            attributeRange.length = [string length] - attributeRange.location;
            // opening first
            NSString * prefix;
            NSRange fileRange = NSMakeRange(0, 0);
            fileRange.location = openRange.location + 1;
            [scanner setScanLocation:fileRange.location];
            if([scanner scanString:@"/" intoString: &prefix]
                || [scanner scanString:@"." intoString: &prefix])
            {
                NSString * TeXFilenameTrailer;
                if([scanner scanCharactersFromSet:[NSCharacterSet TeXFileNameLetterCharacterSet] intoString: &TeXFilenameTrailer])
                {
                    fileRange.length = [scanner scanLocation] - fileRange.location;
                    NSString * file = [prefix stringByAppendingString:TeXFilenameTrailer];
                    [MAS addAttribute:NSLinkAttributeName value:[NSNull null] range:fileRange];
                    [MAS addAttribute:iTM2LogLinkFileAttributeName value:file range:fileRange];
                    files = [files arrayByAddingObject:file];
//NSLog(@"file name added: %@", file);
                    searchRange.location = NSMaxRange(openRange);
                    searchRange.length = [string length] - searchRange.location;
                    openRange = [string rangeOfString:@"(" options:0L range:searchRange];
                    goto openingOrClosingAFile;
                }
                else
                {
                    
//iTM2_START;
                    NSLog(@"No file to open: Missing characters after, \"(.\" or \"(/\"");
                    NSLog(@"<%@>", string);
                    [MAS addAttribute:iTM2LogFilesStackAttributeName value:files range:attributeRange];
                    goto finishEnd;
                }
            }
            else
            {
                
//iTM2_START;
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
            if([files count])
            {
                NSMutableArray * MRA = [NSMutableArray arrayWithArray:files];
                [MRA removeLastObject];
                attributeRange.length = closeRange.location - attributeRange.location;
                [MAS addAttribute:iTM2LogFilesStackAttributeName value:files range:attributeRange];
                attributeRange.location = NSMaxRange(attributeRange);
                attributeRange.length = [string length] - attributeRange.location;
                searchRange.location = NSMaxRange(closeRange);
                searchRange.length = [string length] - searchRange.location;
                closeRange = [string rangeOfString:@")" options:0L range:searchRange];
                files = [NSArray arrayWithArray:MRA];
                goto openingOrClosingAFile;
            }
            else
            {
                
//iTM2_START;
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
        [MAS addAttribute:iTM2LogFilesStackAttributeName value:files range:NSMakeRange(0, [string length])];
    }
    finishEnd:
    [MAS addAttribute:iTM2LogLineTypeAttributeName value:type range:R];
	NSColor * C = [self logColorForType:type];
    [MAS addAttribute:NSForegroundColorAttributeName value:C range:R];
    [MAS endEditing];
    return MAS;
    #endif
    #if 0
    unsigned scanLocation, oldScanLocation;
    NSRange aRange = NSMakeRange(0, [string length]);
    NSRange attributeRange = aRange;
    unsigned maxRange = [string length];
//NSLog(@"P: 0<=%d<%d", aRange.location, [string length]);
    scanLocation = 0;
//NSLog(@"<%@>(%u -> %u)", [[NSCalendarDate date] description], scanLocation, maxRange);
    while(scanLocation < maxRange)
    {
//NSLog(@"NEW LOOP: scanLocation: %i <%@>", scanLocation, [string substringWithRange:NSMakeRange(scanLocation, 1)]);
        [scanner setScanLocation:scanLocation];
        // leading whites
        attributeRange = NSMakeRange(scanLocation, 0);
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
            attributeRange = NSMakeRange(scanLocation, 0);
        }
        oldScanLocation = scanLocation;
        // now scanLocation points to the first black character
//NSLog(@"black character: <%@>", [string substringWithRange:NSMakeRange(scanLocation, 1)]);
//if([[NSCharacterSet whitespaceAndNewlineCharacterSet] characterIsMember:[string characterAtIndex:scanLocation]])
//NSLog(@"whitespaceAndNewlineCharacterSet");
//if([[[NSCharacterSet whitespaceAndNewlineCharacterSet] invertedSet] characterIsMember:[string characterAtIndex:scanLocation]])
//NSLog(@"not whitespaceAndNewlineCharacterSet");
        if([scanner scanString:@"!" intoString:nil])
        {
            unsigned end = 0;
            unsigned nextEnd = 0;
            unsigned nextStart = 0;
            unsigned lineNumber = 0;
            int counter;
            NSRange lineKeyRange;
            iTM2LiteScanner * subScanner;
            NSString * line;
//NSLog(@"GLS");
            [string getLineStart:nil end: &end contentsEnd:nil forRange:NSMakeRange(scanLocation, 0)];
            nextStart = end;
//NSLog(@"GLS");
            for(counter = 0; counter < 10; ++counter)
            {
                [string getLineStart:nil end: &nextEnd contentsEnd:nil forRange:NSMakeRange(nextStart, 0)];
                line = [string substringWithRange:NSMakeRange(nextStart, nextEnd - nextStart)];
                subScanner = [iTM2LiteScanner scannerWithString:line];
                [subScanner scanUpToString:@"l." intoString:nil];
                lineKeyRange.location = [subScanner scanLocation];
                if([subScanner scanString:@"l." intoString:nil] && [subScanner scanInt: &lineNumber])
                {
                    lineKeyRange.length = [subScanner scanLocation] - lineKeyRange.location;
                    lineKeyRange.location += nextStart;
                    [MAS addAttribute:iTM2LineAttributeName value:[NSNumber numberWithInt:lineNumber] range:lineKeyRange];
                    end = NSMaxRange(lineKeyRange);
                    break;
                }
                else
                {
//NSLog(@"I am missing a line number\n%i: %@", counter, line);
                    nextStart = nextEnd;
                    if(nextStart > [string length])
                    {
                        break;
                    }
                }
            }
            attributeRange = NSMakeRange(scanLocation, end - scanLocation);
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
            unsigned end = 0;
//NSLog(@"GLS");
            [string getLineStart:nil end: &end contentsEnd:nil forRange:NSMakeRange([scanner scanLocation], 0)];
            attributeRange = NSMakeRange(scanLocation, end - scanLocation);
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
            unsigned end = 0;
            unsigned line = 0;
            NSRange lineKeyRange;
            NSString * substring;
            iTM2LiteScanner * subScanner;
//NSLog(@"GLS");
            [string getLineStart: nil end: &end contentsEnd: nil
                                                forRange: NSMakeRange([scanner scanLocation], 0)];
            attributeRange = NSMakeRange(scanLocation, end - scanLocation);
            substring = [string substringWithRange:attributeRange];
            subScanner = [iTM2LiteScanner scannerWithString:substring];
//NSLog(@"substring: <%@>", substring);
            while(![subScanner isAtEnd])
            {
                if([subScanner scanUpToString:@"line" intoString:nil],
                    [subScanner scanString:@"line" intoString:nil])
                {
                    lineKeyRange.location = [subScanner scanLocation] - 4;
                    if([subScanner scanInt: &line])
                    {
                        lineKeyRange.length = [subScanner scanLocation] - lineKeyRange.location;
                        lineKeyRange.location += scanLocation;
//NSLog(@"Is this a bug? %@", NSStringFromRange(lineKeyRange));
                        [MAS addAttribute: iTM2LineAttributeName
                                        value: [NSNumber numberWithInt:line] range:lineKeyRange];
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
            unsigned end = 0;
            unsigned line = 0;
            NSRange lineKeyRange = NSMakeRange([scanner scanLocation], 0);
            NSString * substring;
            iTM2LiteScanner * subScanner;
            unsigned tmpAnchor = oldScanLocation;
//NSLog(@"GLS");
            [string getLineStart: nil end: &end contentsEnd: nil
                                                forRange: NSMakeRange([scanner scanLocation], 0)];
            attributeRange = NSMakeRange(scanLocation, end - scanLocation);
            substring = [string substringWithRange:attributeRange];
            subScanner = [iTM2LiteScanner scannerWithString:substring];
            [subScanner setScanLocation:2];
//NSLog(@"substring: <%@>", substring);
            if([subScanner scanInt: &line])
            {
                lineKeyRange.length = [subScanner scanLocation] - 2;
//NSLog(@"Is this a bug? %@", NSStringFromRange(lineKeyRange));
                [MAS addAttribute: iTM2LineAttributeName
                                value: [NSNumber numberWithInt:line] range:lineKeyRange];
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
            unsigned end = 0;
            [string getLineStart: nil end: &end contentsEnd: nil
                                                forRange: NSMakeRange([scanner scanLocation], 0)];
            attributeRange = NSMakeRange(scanLocation, end - scanLocation);
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
            unsigned end = 0;
            unsigned scanAnchor = [scanner scanLocation];
            unsigned tmpAnchor = [scanner scanUpToString:@"on input line" intoString:nil beforeIndex:end]?
                [scanner scanLocation]: scanAnchor;
//NSLog(@"GLS");
            [string getLineStart:nil end: &end contentsEnd:nil forRange:NSMakeRange(scanAnchor, 0)];
//NSLog(@"CTHER\n<%@>", [string substringWithRange:  NSMakeRange(scanAnchor, end - scanAnchor)]);
            if([scanner scanString:@"on input line" intoString:nil beforeIndex:end])
            {
                NSRange lineKeyRange;
                int line;
//NSLog(@"on input line: %@", [string substringWithRange:NSMakeRange(scanLocation, 20)]);
                lineKeyRange.location = [scanner scanLocation] - 4;
                if([scanner scanInt: &line])
                {
                    lineKeyRange.length = [scanner scanLocation] - lineKeyRange.location;
                    [MAS addAttribute: iTM2LineAttributeName
                                    value: [NSNumber numberWithInt:line] range:lineKeyRange];
                }
                attributeRange = NSMakeRange(scanLocation, end - scanLocation);
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
                unsigned tmpAnchor = [scanner scanLocation] - 1;
                end = [scanner scanLocation];
                attributeRange = NSMakeRange(scanAnchor, end - scanAnchor);
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
                    int entier;
                    scanLocation = end;
                    if([scanner scanInt: &entier])
                    {
//NSLog(@"1.1: entier: %d, currentPhysicalPage: %d (%@)", -entier, currentPhysicalPage, currentPhysicalPageNumber);
                        currentPhysicalPageNumber = [NSNumber numberWithInt: --currentPhysicalPage];
                        end = [scanner scanLocation];
                        attributeRange = NSMakeRange(scanLocation, end - scanLocation);
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
                            attributeRange = NSMakeRange(scanLocation, end - scanLocation);
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
                attributeRange = NSMakeRange(scanLocation, end - scanLocation);
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [_iTM2LaTeXLogColors objectForKey:type]?:[[self superclass] logColorForType:type];
}
@end

