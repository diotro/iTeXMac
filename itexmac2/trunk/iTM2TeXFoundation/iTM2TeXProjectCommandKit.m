/*
//
//  @version Subversion: $Id$ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Tue Sep 11 2001.
//  Copyright © 2001-2004 Laurens'Tribune. All rights reserved.
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

#import "iTM2TeXProjectCommandKit.h"
#import "iTM2TeXInfoWrapperKit.h"
#import "iTM2TeXProjectFrontendKit.h"
#import "iTM2TeXProjectTaskKit.h"
#import <Carbon/Carbon.h>
//#import <objc/objc-runtime.h>

NSString * const iTM2TeXProjectHelpPage = @"pgs/004.htm";

//#import <iTM2Foundation/iTM2MenuKit.h>
//#import <iTM2Foundation/iTM2WindowKit.h>

@interface iTM2TeXPCommandsInspector(FrontendKit)
- (id)editedCommand;
- (void)setEditedCommand:(id)argument;
@end

@implementation NSArray(iTM2TeXProjectCommandKit)
- (NSArray *)filteredArrayUsingPredicateValue:(NSString *)value forKey:(NSString *)key;
{
	if([value length])
		return [self filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"%K LIKE %@",key,value]];
	else
		return [self filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"%K MATCHES %@",key,@"^$"]];
}
@end

@implementation iTM2TeXPCommandsWindow
@end

NSString * const iTM2TPFEEnvironmentModeKey = @"EnvironmentMode";
NSString * const iTM2TPFEScriptModeKey = @"ScriptMode";

NSString * const iTM2TPFECommandsKey = @"Commands";
NSString * const iTM2TPFECommandEnvironmentsKey = @"CommandEnvironments";
NSString * const iTM2TPFECommandScriptsKey = @"CommandScripts";

NSString * const iTM2TPFEEnginesKey = @"Engines";// model
NSString * const iTM2TPFEEngineEnvironmentsKey = @"EngineEnvironments";
NSString * const iTM2TPFEEngineScriptsKey = @"EngineScripts";

@implementation iTM2TeXPCommandsInspector
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  smallImageLogo
+ (NSImage *)smallImageLogo;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [NSImage findImageNamed:@"showCurrentProjectSettings(small)"];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inspectorType
+ (NSString *)inspectorType;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return iTM2TeXProjectInspectorType;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inspectorMode
+ (NSString *)inspectorMode;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return iTM2TeXProjectSettingsInspectorMode;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  dealloc
- (void)dealloc;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[INC removeObserver:self];
    [super dealloc];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  windowDidLoad
- (void)windowDidLoad;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [super windowDidLoad];
    NSWindow * W = [self window];
    [W setDelegate:self];
    [INC addObserver: self
	    selector: @selector(flagsDidChangeNotified:)
		    name: iTM2FlagsDidChangeNotification
			    object: nil];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= windowPositionShouldBeObserved
- (BOOL)windowPositionShouldBeObserved;
/*"YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  flagsDidChangeNotified:
- (void)flagsDidChangeNotified:(NSNotification *)notification;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([notification object] == [self window])
		[self validateWindowContent];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  windowTitleForDocumentDisplayName:
- (NSString *)windowTitleForDocumentDisplayName:(NSString *)displayName;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(![displayName length])
        displayName = [[self document] displayName];// retrieve the "untitled" if relevant
    return [NSString stringWithFormat: 
        NSLocalizedStringFromTableInBundle(@"%1$@ (%2$@)", @"Project", [iTM2ProjectDocument classBundle], "blah (project name)"),
        [isa prettyInspectorMode],
            displayName];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  windowsMenuItemTitleForDocumentDisplayName:
- (NSString *)windowsMenuItemTitleForDocumentDisplayName:(NSString *)displayName;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    // the format trick allows to have a return value even if nothing is defined in the locales...
    // it might be useless...
    return [NSString stringWithFormat: @"%@",
        NSLocalizedStringFromTableInBundle([isa prettyInspectorMode], @"Commands", myBUNDLE, "Description forthcoming"),
            displayName];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  windowShouldClose:
- (BOOL)windowShouldClose:(id)sender;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/11/01)
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [[self window] orderOut:self];
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  close
- (void)close;
/*"Before calling the inherited method, update the list of available projects.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[super close];
//iTM2_END;
    return;
}
#if 0
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  tabView:didSelectTabViewItem:
- (void)tabView:(NSTabView *)tabView didSelectTabViewItem:(NSTabViewItem *)tabViewItem;
/*"Validates the window contents whenever the tabviewitem changes.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Mar 26 08:41:36 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self validateWindowContent];
    return;
}
#endif
#pragma mark =-=-=-=-=-=-=-=-=-=-  GUI
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  OK:
- (IBAction)OK:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id project = [self document];
	if([project isDocumentEdited])
	{
		[project removeBuildDirectory];
		[project saveDocument:self];
	}
#warning REMOVE THE BIN DIRECTORy instead?
    [[self window] orderOut:self];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  switchToAdvancedSettings:
- (IBAction)switchToAdvancedSettings:(id)sender;
/*"Message sent by the "Advanced Settings" button in the basic project settings panel.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([[isa inspectorVariant] isEqualToString:[iTM2TeXPCommandsInspector inspectorVariant]])
	{
		// we can switch
		id doc = [self document];
		[doc saveDocument:sender];// to properly manage the undo stack
		[doc replaceInspectorMode:[[self class] inspectorMode] variant:[iTM2TeXPXtdCommandsInspector inspectorVariant]];
	}
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  switchToSimpleSettings:
- (IBAction)switchToSimpleSettings:(id)sender;
/*"Message sent by the "Advanced Settings" button in the basic project settings panel.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(![[isa inspectorVariant] isEqualToString:[iTM2TeXPCommandsInspector inspectorVariant]])
	{
		// we can switch
		id doc = [self document];
		[doc saveDocument:sender];// to properly manage the undo stack
		[doc replaceInspectorMode:[[self class] inspectorMode] variant:[iTM2TeXPCommandsInspector inspectorVariant]];
	}
    return;
}
#pragma mark =-=-=-=-=-  BASE PROJECT
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  chooseBaseMode:
- (IBAction)chooseBaseMode:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Mar 26 08:41:36 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    id TPD = (iTM2TeXProjectDocument *)[self document];
	if([SPC isBaseProject:TPD])
	{
		return;
	}
	NSString * oldBPN = [TPD baseProjectName];
	NSDictionary * oldTPPs = [oldBPN TeXProjectProperties];
	NSString * newMode = [(id)[sender selectedItem] title];
	// get all the base project names with that new mode
	NSArray * TPPs = [[SPC baseProjectNames] valueForKey:@"TeXProjectProperties"];
	// filter out with newMode, case sensitive
	NSArray * RA = [TPPs filteredArrayUsingPredicateValue:newMode forKey:iTM2TPDKModeKey];
	NSAssert([RA count]>0,@"Internal inconsistency, the new mode should exist!");
	// try to keep the extension
	NSArray * nextRA = [RA filteredArrayUsingPredicateValue:[oldTPPs valueForKey:iTM2TPDKExtensionKey] forKey:iTM2TPDKExtensionKey];
	if([nextRA count])
	{
		RA = nextRA;
	}
	else
	{
		NSString * newBPN;
the_end:
		newBPN = [[RA objectAtIndex:0] TeXBaseProjectName];
		if(![[TPD baseProjectName] pathIsEqual:newBPN])
		{
			[TPD setBaseProjectName:newBPN];
			[TPD updateChangeCount:NSChangeDone];
		}
		[self validateWindowContent];
		return;
	}
	// try to keep the variant
	nextRA = [RA filteredArrayUsingPredicateValue:[oldTPPs valueForKey:iTM2TPDKVariantKey] forKey:iTM2TPDKVariantKey];
	if([nextRA count])
	{
		RA = nextRA;
	}
	else
	{
		goto the_end;
	}
	// try to keep the ouput
	nextRA = [RA filteredArrayUsingPredicateValue:[oldTPPs valueForKey:iTM2TPDKOutputKey] forKey:iTM2TPDKOutputKey];
	if([nextRA count])
	{
		RA = nextRA;
	}
	goto the_end;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateChooseBaseMode:
- (BOOL)validateChooseBaseMode:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Mar 26 08:41:36 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    id TPD = (iTM2TeXProjectDocument *)[self document];
	if([SPC isBaseProject:TPD])
	{
		return NO;
	}
//iTM2_LOG(@"sender is: %@", sender);
    if([sender isKindOfClass:[NSPopUpButton class]])
    {
		static NSString * voidTitle = nil;
		if(!voidTitle)
			voidTitle = [[[sender lastItem] title] copy];
        [sender removeAllItems];
		// get the available modes of the array of the tex project properties of all the base project names
		NSArray * modes = [[[SPC baseProjectNames] valueForKey:@"TeXProjectProperties"] valueForKey:iTM2TPDKModeKey];
		// get only one copy per mode
		modes = [[NSSet setWithArray:modes] allObjects];
		// sort the modes
		modes = [modes sortedArrayUsingSelector:@selector(compare:)];
		// feed the sender
		NSEnumerator * E = [modes objectEnumerator];
        NSString * mode;
        while(mode = [E nextObject])
        {
			if(![mode isEqual:iTM2ProjectDefaultName])// the default mode is not added
			{
				[sender addItemWithTitle:mode];
				[[sender lastItem] setRepresentedObject:mode];
			}
        }
		// select the proper item
		NSString * BPN = [TPD baseProjectName];
        NSDictionary * Ps = [BPN TeXProjectProperties];
        mode = [Ps iVarMode];
        int idx = [sender indexOfItemWithRepresentedObject:mode];
        if(idx == -1)
        {
            if([sender numberOfItems])
				[[sender menu] addItem:[NSMenuItem separatorItem]];
            [sender addItemWithTitle:[NSString stringWithFormat:@"%@(Unknown)", mode]];
            [sender selectItem:[sender lastItem]];        
            [[sender lastItem] setRepresentedObject:nil];// BEWARE!!!
			[[sender lastItem] setEnabled: NO];
        }
        else
        {
            [sender selectItemAtIndex:idx];
        }
		if([sender numberOfItems] < 2)
		{
			[sender setEnabled: NO];
			return NO;
		}
	}
	else if([sender isKindOfClass:[NSMenuItem class]])
	{
		return [sender representedObject] != nil;
	}
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  chooseExtension:
- (IBAction)chooseExtension:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Mar 26 08:41:36 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    id TPD = (iTM2TeXProjectDocument *)[self document];
	if([SPC isBaseProject:TPD])
	{
		return;
	}
	NSString * oldBPN = [TPD baseProjectName];
	NSDictionary * oldTPPs = [oldBPN TeXProjectProperties];
	// get all the base project names with that actual mode
	NSArray * TPPs = [[SPC baseProjectNames] valueForKey:@"TeXProjectProperties"];
	TPPs = [TPPs filteredArrayUsingPredicateValue:[oldTPPs valueForKey:iTM2TPDKModeKey] forKey:iTM2TPDKModeKey];
	// filter out with newExtension, case sensitive
	NSString * newExtension = [(id)[sender selectedItem] representedObject];
	NSArray * RA = [TPPs filteredArrayUsingPredicateValue:newExtension forKey:iTM2TPDKExtensionKey];
	NSAssert([RA count]>0,@"Internal inconsistency, the new mode should exist!");
	// try to keep the variant
	NSArray * nextRA = [RA filteredArrayUsingPredicateValue:[oldTPPs valueForKey:iTM2TPDKVariantKey] forKey:iTM2TPDKVariantKey];
	if([nextRA count])
	{
		RA = nextRA;
	}
	else
	{
		NSString * newBPN;
the_end:
		newBPN = [[RA objectAtIndex:0] TeXBaseProjectName];
		if(![[TPD baseProjectName] pathIsEqual:newBPN])
		{
			[TPD setBaseProjectName:newBPN];
			[TPD updateChangeCount:NSChangeDone];
		}
		[self validateWindowContent];
		return;
	}
	// try to keep the ouput
	nextRA = [RA filteredArrayUsingPredicateValue:[oldTPPs valueForKey:iTM2TPDKOutputKey] forKey:iTM2TPDKOutputKey];
	if([nextRA count])
	{
		RA = nextRA;
	}
	goto the_end;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateChooseExtension:
- (BOOL)validateChooseExtension:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Mar 26 08:41:36 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    id TPD = (iTM2TeXProjectDocument *)[self document];
	if([SPC isBaseProject:TPD])
	{
		return NO;
	}
//iTM2_LOG(@"sender is: %@", sender);
    if([sender isKindOfClass:[NSPopUpButton class]])
    {
		static NSString * voidTitle = nil;
		if(!voidTitle)
			voidTitle = [[[sender lastItem] title] copy];
        [sender removeAllItems];
        NSDictionary * Ps = [[TPD baseProjectName] TeXProjectProperties];
		// get all the base project names properties
		NSArray * TPPs = [[SPC baseProjectNames] valueForKey:@"TeXProjectProperties"];
		// filter out those with the proper mode
		TPPs = [TPPs filteredArrayUsingPredicateValue:[Ps iVarMode] forKey:iTM2TPDKModeKey];
		// get the extensions
		NSArray * extensions = [TPPs valueForKey:iTM2TPDKExtensionKey];
		// get only one copy per extension
		extensions = [[NSSet setWithArray:extensions] allObjects];
		// sort the extensions
		extensions = [extensions sortedArrayUsingSelector:@selector(compare:)];
		// feed the sender
		NSEnumerator * E = [extensions objectEnumerator];
        NSString * extension;
        while(extension = [E nextObject])
        {
			if([extension length])
			{
				[sender addItemWithTitle:NSLocalizedStringFromTableInBundle([extension lowercaseString],iTM2TeXProjectFrontendTable,[NSBundle bundleForClass:[iTM2TeXProjectDocument class]],"")];
			}
			else
			{
				[sender addItemWithTitle:NSLocalizedStringFromTableInBundle(@"Standard",iTM2TeXProjectFrontendTable,[NSBundle bundleForClass:[iTM2TeXProjectDocument class]],"")];
			}
			[[sender lastItem] setRepresentedObject:extension];
        }
        extension = [Ps iVarExtension];
        int idx = [sender indexOfItemWithRepresentedObject:extension];
        if(idx == -1)
        {
            if([sender numberOfItems])
				[[sender menu] addItem:[NSMenuItem separatorItem]];
            [sender addItemWithTitle:[NSString stringWithFormat:@"%@(Unknown)", extension]];
            [sender selectItem:[sender lastItem]];        
            [[sender lastItem] setRepresentedObject:nil];// BEWARE!!!
			[[sender lastItem] setEnabled: NO];
        }
        else
        {
            [sender selectItemAtIndex:idx];
        }
		if([sender numberOfItems] < 2)
		{
			[sender setEnabled: NO];
			return NO;
		}
	}
	else if([sender isKindOfClass:[NSMenuItem class]])
	{
		return [sender representedObject] != nil;
	}
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  chooseVariant:
- (IBAction)chooseVariant:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Mar 26 08:41:36 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    id TPD = (iTM2TeXProjectDocument *)[self document];
	if([SPC isBaseProject:TPD])
	{
		return;
	}
	NSString * oldBPN = [TPD baseProjectName];
	NSDictionary * oldTPPs = [oldBPN TeXProjectProperties];
	// get all the base project names with that actual mode and extension
	NSArray * TPPs = [[SPC baseProjectNames] valueForKey:@"TeXProjectProperties"];
	TPPs = [TPPs filteredArrayUsingPredicateValue:[oldTPPs iVarMode] forKey:iTM2TPDKModeKey];
	TPPs = [TPPs filteredArrayUsingPredicateValue:[oldTPPs iVarExtension] forKey:iTM2TPDKExtensionKey];
	// filter out with newVariant, case sensitive
	NSString * newVariant = [(id)[sender selectedItem] representedObject];
	NSArray * RA = [TPPs filteredArrayUsingPredicateValue:newVariant forKey:iTM2TPDKVariantKey];
	NSAssert([RA count]>0,@"Internal inconsistency, the new mode should exist!");
	// try to keep the output
	NSArray * nextRA = [RA filteredArrayUsingPredicateValue:[oldTPPs valueForKey:iTM2TPDKOutputKey] forKey:iTM2TPDKOutputKey];
	if([nextRA count])
	{
		RA = nextRA;
	}
	NSString * newBPN = [[RA objectAtIndex:0] TeXBaseProjectName];
	if(![[TPD baseProjectName] pathIsEqual:newBPN])
	{
		[TPD setBaseProjectName:newBPN];
		[TPD updateChangeCount:NSChangeDone];
	}
	[self validateWindowContent];
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateChooseVariant:
- (BOOL)validateChooseVariant:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Mar 26 08:41:36 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    id TPD = (iTM2TeXProjectDocument *)[self document];
	if([SPC isBaseProject:TPD])
	{
		return NO;
	}
//iTM2_LOG(@"sender is: %@", sender);
    if([sender isKindOfClass:[NSPopUpButton class]])
    {
		static NSString * voidTitle = nil;
		if(!voidTitle)
			voidTitle = [[[sender lastItem] title] copy];
        [sender removeAllItems];
        NSDictionary * Ps = [[TPD baseProjectName] TeXProjectProperties];
		// get all the base project names properties
		NSArray * TPPs = [[SPC baseProjectNames] valueForKey:@"TeXProjectProperties"];
		// filter out those with the proper mode, extension
		TPPs = [TPPs filteredArrayUsingPredicateValue:[Ps iVarMode] forKey:iTM2TPDKModeKey];
		TPPs = [TPPs filteredArrayUsingPredicateValue:[Ps iVarExtension] forKey:iTM2TPDKExtensionKey];
		// get the variants
		NSArray * variants = [TPPs valueForKey:iTM2TPDKVariantKey];
		// get only one copy per extension
		variants = [[NSSet setWithArray:variants] allObjects];
		// sort the extensions
		variants = [variants sortedArrayUsingSelector:@selector(compare:)];
		// feed the sender
		NSEnumerator * E = [variants objectEnumerator];
        NSString * variant;
        while(variant = [E nextObject])
        {
			if([variant length])
			{
				[sender addItemWithTitle:variant];
			}
			else
			{
				[sender addItemWithTitle:NSLocalizedStringFromTableInBundle(@"Standard",iTM2TeXProjectFrontendTable,[NSBundle bundleForClass:[iTM2TeXProjectDocument class]],"")];
			}
			[[sender lastItem] setRepresentedObject:variant];
        }
        variant = [Ps iVarVariant];
        int idx = [sender indexOfItemWithRepresentedObject:variant];
        if(idx == -1)
        {
            if([sender numberOfItems])
				[[sender menu] addItem:[NSMenuItem separatorItem]];
            [sender addItemWithTitle:[NSString stringWithFormat:@"%@(Unknown)", variant]];
            [sender selectItem:[sender lastItem]];        
            [[sender lastItem] setRepresentedObject:nil];// BEWARE!!!
			[[sender lastItem] setEnabled: NO];
        }
        else
        {
            [sender selectItemAtIndex:idx];
        }
		if([sender numberOfItems] < 2)
		{
			[sender setEnabled: NO];
			return NO;
		}
	}
	else if([sender isKindOfClass:[NSMenuItem class]])
	{
		return [sender representedObject] != nil;
	}
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  chooseOutput:
- (IBAction)chooseOutput:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Mar 26 08:41:36 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    id TPD = (iTM2TeXProjectDocument *)[self document];
	if([SPC isBaseProject:TPD])
	{
		return;
	}
	NSString * oldBPN = [TPD baseProjectName];
	NSDictionary * oldTPPs = [oldBPN TeXProjectProperties];
	// get all the base project names with that actual mode and extension, variant
	NSArray * TPPs = [[SPC baseProjectNames] valueForKey:@"TeXProjectProperties"];
	TPPs = [TPPs filteredArrayUsingPredicateValue:[oldTPPs iVarMode] forKey:iTM2TPDKModeKey];
	TPPs = [TPPs filteredArrayUsingPredicateValue:[oldTPPs iVarExtension] forKey:iTM2TPDKExtensionKey];
	TPPs = [TPPs filteredArrayUsingPredicateValue:[oldTPPs iVarVariant] forKey:iTM2TPDKVariantKey];
	// filter out with newVariant, case sensitive
	NSString * newOutput = [(id)[sender selectedItem] representedObject];
	NSArray * RA = [TPPs filteredArrayUsingPredicateValue:newOutput forKey:iTM2TPDKOutputKey];
	NSAssert([RA count]>0,@"Internal inconsistency, the new mode should exist!");
	NSString * newBPN = [[RA objectAtIndex:0] TeXBaseProjectName];
	if(![[TPD baseProjectName] pathIsEqual:newBPN])
	{
		[TPD setBaseProjectName:newBPN];
		[TPD updateChangeCount:NSChangeDone];
	}
	[self validateWindowContent];
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateChooseOutput:
- (BOOL)validateChooseOutput:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Mar 26 08:41:36 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    id TPD = (iTM2TeXProjectDocument *)[self document];
	if([SPC isBaseProject:TPD])
	{
		return NO;
	}
//iTM2_LOG(@"sender is: %@", sender);
    if([sender isKindOfClass:[NSPopUpButton class]])
    {
		static NSString * voidTitle = nil;
		if(!voidTitle)
			voidTitle = [[[sender lastItem] title] copy];
        [sender removeAllItems];
        NSDictionary * Ps = [[TPD baseProjectName] TeXProjectProperties];
		// get all the base project names properties
		NSArray * TPPs = [[SPC baseProjectNames] valueForKey:@"TeXProjectProperties"];
		// filter out those with the proper mode, extension
		TPPs = [TPPs filteredArrayUsingPredicateValue:[Ps iVarMode] forKey:iTM2TPDKModeKey];
		TPPs = [TPPs filteredArrayUsingPredicateValue:[Ps iVarExtension] forKey:iTM2TPDKExtensionKey];
		TPPs = [TPPs filteredArrayUsingPredicateValue:[Ps iVarVariant] forKey:iTM2TPDKVariantKey];
		// get the outputs
		NSArray * outputs = [TPPs valueForKey:iTM2TPDKOutputKey];
		// get only one copy per extension
		outputs = [[NSSet setWithArray:outputs] allObjects];
		// sort the extensions
		outputs = [outputs sortedArrayUsingSelector:@selector(compare:)];
		// feed the sender
		NSEnumerator * E = [outputs objectEnumerator];
        NSString * output;
        while(output = [E nextObject])
        {
			if([output length])
			{
				[sender addItemWithTitle:output];
			}
			else
			{
				[sender addItemWithTitle:NSLocalizedStringFromTableInBundle(@"PDF",iTM2TeXProjectFrontendTable,[NSBundle bundleForClass:[iTM2TeXProjectDocument class]],"")];
			}
			[[sender lastItem] setRepresentedObject:output];
        }
        output = [Ps iVarOutput];
        int idx = [sender indexOfItemWithRepresentedObject:output];
        if(idx == -1)
        {
            if([sender numberOfItems])
				[[sender menu] addItem:[NSMenuItem separatorItem]];
            [sender addItemWithTitle:[NSString stringWithFormat:@"%@(Unknown)", output]];
            [sender selectItem:[sender lastItem]];        
            [[sender lastItem] setRepresentedObject:nil];// BEWARE!!!
			[[sender lastItem] setEnabled: NO];
        }
        else
        {
            [sender selectItemAtIndex:idx];
        }
		if([sender numberOfItems] < 2)
		{
			[sender setEnabled: NO];
			return NO;
		}
	}
	else if([sender isKindOfClass:[NSMenuItem class]])
	{
		return [sender representedObject] != nil;
	}
    return YES;
}
#pragma mark =-=-=-=-=-=-=-=-=-=-  ADVANCED TYPESETTING MANAGEMENT
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  editedCommand
- (id)editedCommand;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [self contextStringForKey:@"Commands Inspector:Edited Command" domain:iTM2ContextAllDomainsMask];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setEditedCommand:
- (void)setEditedCommand:(id)argument;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self willChangeValueForKey:@"editedCommand"];
	[self takeContextValue:argument forKey:@"Commands Inspector:Edited Command" domain:iTM2ContextAllDomainsMask];
	[self didChangeValueForKey:@"editedCommand"];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  chooseEditCommand:
- (IBAction)chooseEditCommand:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Mar 26 08:41:36 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self setEditedCommand:[[sender selectedItem] representedObject]];
    [self validateWindowContent];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateChooseEditCommand:
- (BOOL)validateChooseEditCommand:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Mar 26 08:41:36 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
#warning THIS MENU might not be up to date when there are new commands registered by plug ins, notification?
    if([sender isKindOfClass:[NSPopUpButton class]])
    {
        if([sender numberOfItems] < 2)
        {
            [sender removeAllItems];
			NSEnumerator * E = [[iTM2TeXPCommandManager orderedBuiltInCommandNames] objectEnumerator];
			NSEnumerator * e;
			while(e = [[E nextObject] objectEnumerator])
			{
				NSString * name;
				while(name = [e nextObject])
				{
					[sender addItemWithTitle:[iTM2TeXPCommandPerformer localizedNameForName:name]];
					[[sender lastItem] setRepresentedObject:name];
				}
				[[sender menu] addItem:[NSMenuItem separatorItem]];
			}
			if([[sender lastItem] isSeparatorItem])
			{
				[[sender menu] removeItem:[sender lastItem]];
			}
        }
        int index = [sender indexOfItemWithRepresentedObject:[self editedCommand]];
        if(index < 0)
        {
            [self setEditedCommand:[[[[[iTM2TeXPCommandManager orderedBuiltInCommandNames] objectEnumerator] nextObject] objectEnumerator] nextObject]];
            index = [sender indexOfItemWithRepresentedObject:[self editedCommand]];
        }
        [sender selectItemAtIndex:index];
    }
    return YES;
}
#pragma mark =-=-=-=-=-=-=-=-=-=-  ACTION SCRIPTS MANAGEMENT
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  availableScriptCommands
- (NSDictionary *)availableScriptCommands;
{
	NSBundle * mainBundle = [NSBundle mainBundle];
	NSEnumerator * E = [[mainBundle allPathsForSupportExecutables] objectEnumerator];
	NSString * commandName = nil;
	id bins = [NSMutableDictionary dictionary];
	while(commandName = [E nextObject])
	{
		NSString * key = [[commandName lastPathComponent] stringByDeletingPathExtension];
		if([key hasPrefix:@"iTM2_Command_"])
		{
			[bins setObject:commandName forKey:[key substringWithRange:NSMakeRange(13,[key length]-13)]];
		}
	}
	return bins;
}
- (NSString *)editedScriptMode;
{
	NSString * editedCommand = [self editedCommand];
	NSString * mode = [self infoForKeyPaths:iTM2TPFECommandsKey,editedCommand,iTM2TPFEScriptModeKey,nil];
	if([mode isEqual:iTM2TPFEBaseMode])
	{
		[self takeInfo:nil forKeyPaths:iTM2TPFECommandsKey,editedCommand,iTM2TPFEScriptModeKey,nil];
		mode = [self infoForKeyPaths:iTM2TPFECommandsKey,editedCommand,iTM2TPFEScriptModeKey,nil];
		if([mode isEqual:iTM2TPFEBaseMode])
		{
			mode = nil;
		}
	}
	return mode;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  chooseScript:
- (IBAction)chooseScript:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Mar 26 08:41:36 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * editedCommand = [self editedCommand];
	NSString * newMode = [(id)[sender selectedItem] representedString];
	if([newMode isEqual:iTM2TPFEBaseMode])
	{
		newMode = nil;
	}
	if([self takeInfo:newMode forKeyPaths:iTM2TPFECommandsKey,editedCommand,iTM2TPFEScriptModeKey,nil])
	{
		[self takeInfo:newMode forKeyPaths:iTM2TPFECommandsKey,editedCommand,iTM2TPFEEnvironmentModeKey,nil];
		[[self document] updateChangeCount:NSChangeDone];
		[self validateWindowContent];
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateChooseScript:
- (BOOL)validateChooseScript:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Mar 26 08:41:36 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if([sender isKindOfClass:[NSPopUpButton class]])
    {
		// cleaning the menu
        [sender removeAllItems];
		// make a copy to keep the same fonts
        NSMenu * removeScriptMenu = [[[sender menu] copy] autorelease]; 
        // populates with a "base" menu item
        [sender addItemWithTitle:NSLocalizedStringFromTableInBundle(@"Disabled", iTM2TeXProjectFrontendTable, myBUNDLE, "...")];
        [[sender lastItem] setRepresentedObject:iTM2TPFEVoidMode];
        [sender addItemWithTitle:NSLocalizedStringFromTableInBundle(@"Base", iTM2TeXProjectFrontendTable, myBUNDLE, "...")];
        [[sender lastItem] setRepresentedObject:iTM2TPFEBaseMode];
		// adding the built in scripts
		NSDictionary * commands = [self availableScriptCommands];
		NSString * commandName = nil;
		NSEnumerator * E = nil;
		NSString * title;
		[[sender menu] addItem:[NSMenuItem separatorItem]];
		if([commands count])
		{
			title = NSLocalizedStringFromTableInBundle(@"Support Scripts", iTM2TeXProjectFrontendTable, myBUNDLE, "Description Forthcoming");
			[sender addItemWithTitle:title];
			[[sender lastItem] setRepresentedObject:@"Disabled"];
			E = [[[commands allKeys] sortedArrayUsingSelector:@selector(compare:)] objectEnumerator];
			while(commandName = [E nextObject])
			{
				[sender addItemWithTitle:commandName];
				[[sender lastItem] setRepresentedObject:[commands objectForKey:commandName]];
				[[sender lastItem] setIndentationLevel:1];
			}
	//iTM2_LOG(@"THE editedCommand IS: %@", [self editedCommand]);
			// This is a consistency test that should also be made before...
			[[sender menu] addItem:[NSMenuItem separatorItem]];
		}
		title = NSLocalizedStringFromTableInBundle(@"Project Scripts", iTM2TeXProjectFrontendTable, myBUNDLE, "Description Forthcoming");
		[sender addItemWithTitle:title];
		[[sender lastItem] setRepresentedObject:@"Disabled"];
		commands = [self infoForKeyPaths:iTM2TPFECommandScriptsKey,nil];
		if([commands count])
		{
			E = [[[commands allKeys] sortedArrayUsingSelector:@selector(compare:)] objectEnumerator];
			while(commandName = [E nextObject])
			{
				NSString * label = [self infoForKeyPaths:iTM2TPFECommandScriptsKey,commandName,iTM2TPFELabelKey,nil];
				title = [label length]? label:
					[NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"Script %@", iTM2TeXProjectFrontendTable, myBUNDLE, "Description Forthcoming"), commandName];
				[sender addItemWithTitle:title];
				[[sender lastItem] setRepresentedObject:commandName];
				[[sender lastItem] setIndentationLevel:1];
				NSMenuItem * MI = [removeScriptMenu addItemWithTitle:title action:@selector(removeScript:) keyEquivalent:@""];
				[MI setRepresentedObject:commandName];
				[MI setTarget:self];// MI belongs to the receivers window
			}
		}
        [sender addItemWithTitle:NSLocalizedStringFromTableInBundle(@"New", iTM2TeXProjectFrontendTable, myBUNDLE, "Description Forthcoming")];
        [[sender lastItem] setAction:@selector(newScript:)];
        [[sender lastItem] setTarget:self];// sender belongs to the receivers window
        if([removeScriptMenu numberOfItems])
        {
            [sender addItemWithTitle:NSLocalizedStringFromTableInBundle(@"Remove", iTM2TeXProjectFrontendTable, myBUNDLE, "Description Forthcoming")];
            [[sender lastItem] setSubmenu:removeScriptMenu];
        }
//iTM2_LOG(@"CW is: %@", [CW description]);
		NSString * scriptMode = [self editedScriptMode];
        unsigned idx = -1;
		if(![scriptMode length])
		{
			scriptMode = iTM2TPFEBaseMode;
		}
		idx = [sender indexOfItemWithRepresentedObject:scriptMode];
		if(idx != -1)
		{
			[sender selectItemAtIndex:idx];
		}
		else
		{
			if([removeScriptMenu numberOfItems])
				[[sender menu] addItem:[NSMenuItem separatorItem]];
			[sender addItemWithTitle:NSLocalizedStringFromTableInBundle(@"Unsupported", iTM2TeXProjectFrontendTable, myBUNDLE, "Description Forthcoming")];
			title = [scriptMode stringByDeletingPathExtension];
			[sender addItemWithTitle:title];
			[[sender lastItem] setRepresentedObject:scriptMode];
			[[sender lastItem] setAction:@selector(noop:)];
			[[sender lastItem] setTarget:self];// sender belongs to the receivers window
		}
		[[sender menu] cleanSeparators];
		return YES;
    }
	else if([sender isKindOfClass:[NSMenuItem class]])
	{
		return ![[sender representedObject] isEqual:@"Disabled"];
	}
	return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  newScript:
- (IBAction)newScript:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Mar 26 08:41:36 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSArray * allActionModes = [[self infoForKeyPaths:iTM2TPFECommandScriptsKey,nil] allKeys];
    int idx = 0;
    NSString * scriptMode;
    while((scriptMode = [NSString stringWithFormat:@"%i", idx++]), [allActionModes containsObject:scriptMode]);
	[self takeInfo:scriptMode forKeyPaths:iTM2TPFECommandsKey,[self editedCommand],iTM2TPFEScriptModeKey,nil];
	[self takeInfo:@"" forKeyPaths:iTM2TPFECommandScriptsKey,scriptMode,iTM2TPFELabelKey,nil];
	[[self document] updateChangeCount:NSChangeDone];
	[self validateWindowContent];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  removeScript:
- (IBAction)removeScript:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Mar 26 08:41:36 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * scriptMode = [(id)sender representedString];
	if([self takeInfo:nil forKeyPaths:iTM2TPFECommandScriptsKey,scriptMode,nil])
	{
// remove the script reference for all the commands that used it
		NSEnumerator * E = [[self infoForKeyPaths:iTM2TPFECommandsKey, nil] keyEnumerator];
		NSString * name;
		while(name = [E nextObject])
		{
			if([scriptMode isEqual:[self infoForKeyPaths:iTM2TPFECommandsKey,name,iTM2TPFEScriptModeKey,nil]])
			{
				[self takeInfo:nil forKeyPaths:iTM2TPFECommandsKey,name,iTM2TPFEScriptModeKey,nil];
			}
		}
		[[self document] updateChangeCount:NSChangeDone];
		[self validateWindowContent];
	}
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  editScript:
- (IBAction)editScript:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Mar 26 08:41:36 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(![[self window] attachedSheet])
    {
#warning DEBUG: Problem when cancelled, the edited status might remain despite it should not.
		iTM2TeXProjectDocument * TPD = (iTM2TeXProjectDocument *)[self document];
		NSString * scriptMode = [self editedScriptMode];
        iTM2TeXPShellScriptInspector * WC = [[[iTM2TeXPShellScriptInspector allocWithZone:[self zone]]
			initWithWindowNibName: @"iTM2TeXPShellScriptInspector"] autorelease];
		iTM2InfosController * ic = [[[iTM2InfosController alloc] initWithProject:TPD atomic:NO prefixWithKeyPaths:iTM2TPFECommandScriptsKey,scriptMode,nil] autorelease];
		[WC setInfosController:ic];
		NSWindow * W = [WC window];
		if(W)
		{
			[TPD addWindowController:WC];
			[WC validateWindowContent];
			[NSApp beginSheet: W
					modalForWindow: [self window]
					modalDelegate: self
					didEndSelector: @selector(editScriptSheetDidEnd:returnCode:irrelevant:)
					contextInfo: nil];
		}
		else
		{
			iTM2_LOG(@"A window named iTM2TeXPShellScriptInspector was expected");
		}
    }
    else
        iTM2Beep();
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateEditScript:
- (BOOL)validateEditScript:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Mar 26 08:41:36 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([SPC isBaseProject:[self document]])
		return NO;
    return [[[self infoForKeyPaths:iTM2TPFECommandScriptsKey,nil] allKeys] containsObject:[self editedScriptMode]];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  editScriptSheetDidEnd:returnCode:scriptMode:
- (void)editScriptSheetDidEnd:(NSWindow *)sheet returnCode:(int)returnCode irrelevant:(void *)unused;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sheet orderOut:self];
    id WC = [sheet windowController];
    [[WC document] removeWindowController:WC];
    [self validateWindowContent];
    return;
}
#pragma mark =-=-=-=-=-=-=-=-=-=-  OPTIONS MANAGEMENT
- (NSString *)editedEnvironmentMode;
{
	NSString * editedCommand = [self editedCommand];
	NSString * mode = [self infoForKeyPaths:iTM2TPFECommandsKey,editedCommand,iTM2TPFEEnvironmentModeKey,nil];
	if([mode isEqual:iTM2TPFEBaseMode])
	{
		[self takeInfo:nil forKeyPaths:iTM2TPFECommandsKey,editedCommand,iTM2TPFEEnvironmentModeKey,nil];
		mode = [self infoForKeyPaths:iTM2TPFECommandsKey,editedCommand,iTM2TPFEEnvironmentModeKey,nil];
		if([mode isEqual:iTM2TPFEBaseMode])
		{
			mode = nil;
		}
	}
	if(!mode)
	{
		mode = editedCommand;
	}
	return mode;
}
- (BOOL)isCustomEnvironmentMode;
{
	return [self localInfoForKeyPaths:iTM2TPFECommandEnvironmentsKey,[self editedEnvironmentMode],nil]!=nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  chooseOptions:
- (IBAction)chooseOptions:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Mar 26 08:41:36 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * editedCommand = [self editedCommand];
	NSString * environmentMode = [(id)[sender selectedItem] representedString];
	if([environmentMode isEqual:iTM2TPFECustomMode])
	{
		[self takeInfo:nil forKeyPaths:iTM2TPFECommandsKey,editedCommand,iTM2TPFEEnvironmentModeKey,nil];
		environmentMode = [self editedEnvironmentMode];
		// if there were something already customized, retrieve it
		if([self takeInfo:environmentMode forKeyPaths:iTM2TPFECommandsKey,editedCommand,iTM2TPFEEnvironmentModeKey,nil])
		{
			if([self restoreCustomForKeyPaths:iTM2TPFECommandEnvironmentsKey,environmentMode,nil]
				|| [self takeInfo:[NSMutableDictionary dictionary] forKeyPaths:iTM2TPFECommandEnvironmentsKey,environmentMode,nil])
			{
				NSAssert([self isCustomEnvironmentMode],@"Custom environment mode expected");
				[[self document] updateChangeCount:NSChangeDone];
				[self validateWindowContent];
			}
		}
	}
	else if([environmentMode isEqual:iTM2TPFEBaseMode])
	{
		environmentMode = nil;
		if([self takeInfo:environmentMode forKeyPaths:iTM2TPFECommandsKey,editedCommand,iTM2TPFEEnvironmentModeKey,nil])
		{
			environmentMode = [self editedEnvironmentMode];
			[self backupCustomForKeyPaths:iTM2TPFECommandEnvironmentsKey,environmentMode,nil];
			[self takeInfo:nil forKeyPaths:iTM2TPFECommandEnvironmentsKey,environmentMode,nil];
			[[self document] updateChangeCount:NSChangeDone];
			[self validateWindowContent];
		}
	}
	else if([self takeInfo:environmentMode forKeyPaths:iTM2TPFECommandsKey,editedCommand,iTM2TPFEEnvironmentModeKey,nil])
	{
		[[self document] updateChangeCount:NSChangeDone];
		[self validateWindowContent];
	}
//iTM2_LOG(@"CW is NOW: %@", CW);
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateChooseOptions:
- (BOOL)validateChooseOptions:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Mar 26 08:41:36 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * scriptMode = [self editedScriptMode];
    if([sender isKindOfClass:[NSMenuItem class]])
	{
		if([scriptMode isEqual:iTM2TPFEVoidMode]
			|| [[[self infoForKeyPaths:iTM2TPFECommandScriptsKey,nil] allKeys] containsObject:scriptMode])
		{
			return NO;
		}
		return YES;
	}
    else if([sender isKindOfClass:[NSPopUpButton class]])
	{
		[sender removeAllItems];
		NSString * editedCommand = [self editedCommand];
		NSString * environmentMode = [self editedEnvironmentMode];
//iTM2_LOG(@"editedCommand is: %@", editedCommand);
		if([[editedCommand lowercaseString] isEqualToString:@"special"]
			|| [scriptMode isEqualToString:iTM2TPFEVoidMode]
				|| [[[self infoForKeyPaths:iTM2TPFECommandScriptsKey,nil] allKeys] containsObject:scriptMode])
		{
			// No options for the special command
			[sender addItemWithTitle:NSLocalizedStringFromTableInBundle(@"No options", iTM2TeXProjectFrontendTable, myBUNDLE, "...")];
			[[sender lastItem] setRepresentedObject:iTM2TPFEVoidMode];
			[sender selectItem:[sender lastItem]];
			return NO;
		}
		// for the others, only Void, Base and Custom (=editedCommand)
		// populates with a "base" menu item
		if([self localInfoForKeyPaths:iTM2TPFECommandsKey,[self editedCommand],nil])
		{
			[sender addItemWithTitle:NSLocalizedStringFromTableInBundle(@"No options", iTM2TeXProjectFrontendTable, myBUNDLE, "...")];
			[[sender lastItem] setRepresentedObject:iTM2TPFEVoidMode];
		}
		[sender addItemWithTitle:NSLocalizedStringFromTableInBundle(@"Base", iTM2TeXProjectFrontendTable, myBUNDLE, "...")];
		[[sender lastItem] setRepresentedObject:iTM2TPFEBaseMode];
		[sender addItemWithTitle:NSLocalizedStringFromTableInBundle(@"Custom", iTM2TeXProjectFrontendTable, myBUNDLE, "...")];
		[[sender lastItem] setRepresentedObject:iTM2TPFECustomMode];
		if([environmentMode isEqual:iTM2TPFEVoidMode])
		{
			[sender selectItemAtIndex:0];
		}
		else if([self isCustomEnvironmentMode])
		{
			[sender selectItemAtIndex:[sender indexOfItemWithRepresentedObject:iTM2TPFECustomMode]];// index is 0 or 1
		}
		else
		{
			[sender selectItemAtIndex:[sender indexOfItemWithRepresentedObject:iTM2TPFEBaseMode]];// index is 1 or 2
		}
		return YES;
	}
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  editOptions:
- (IBAction)editOptions:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Mar 26 08:41:36 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(![[self window] attachedSheet])
    {
		NSString * environmentMode = [self editedEnvironmentMode];
		Class C = [iTM2TeXPCommandInspector classForMode:environmentMode];
        iTM2TeXPCommandInspector * WC = [[[C allocWithZone:[self zone]] initWithWindowNibName:[C windowNibName]] autorelease];
        iTM2TeXProjectDocument * TPD = (iTM2TeXProjectDocument *)[self document];
		[TPD addWindowController:WC];// now [WC document] == TPD, and WC is retained, the WC document is the project
		NSWindow * W = [WC window];// may validate the window content as side effect
        if(W)
        {
//iTM2_LOG(@"The command inspector is: %@", WC);
			if(iTM2DebugEnabled>100)
			{
				iTM2_LOG(@"Starting to edit environment mode: %@", environmentMode);
			}
			[W setExcludedFromWindowsMenu:YES];
			[W validateContent];
//iTM2_LOG(@"BEFORE validateWindowContent, [WC document] is: %@", [WC document]);
            [NSApp beginSheet: W
                    modalForWindow: [self window]
                    modalDelegate: self
                    didEndSelector: @selector(editOptionsSheetDidEnd:returnCode:irrelevant:)
                    contextInfo: nil];
        }
        else
        {
            NSLog(@"Could not find a class for: %@", environmentMode);
			[TPD removeWindowController:WC];// now [WC document] == TPD, and WC is retained
        }
    }
    else
        iTM2Beep();
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  editOptionsSheetDidEnd:returnCode:irrelevant:
- (void)editOptionsSheetDidEnd:(NSWindow *)sheet returnCode:(int)returnCode irrelevant:(void *)unused;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sheet orderOut:self];
    id WC = [sheet windowController];
//iTM2_LOG(@"return code: %i", returnCode);
    [[WC document] removeWindowController:WC];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateEditOptions:
- (BOOL)validateEditOptions:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Mar 26 08:41:36 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([SPC isBaseProject:[self document]]
		|| [[[self editedCommand] lowercaseString] isEqualToString:@"special"])
		return NO;
	return [self isCustomEnvironmentMode];
}
#pragma mark =-=-=-=-=-  DEFAULT
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  defaultCommand:
- (IBAction)defaultCommand:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Mar 26 08:41:36 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	BOOL yorn = [self takeInfo:nil forKeyPaths:iTM2TPFECommandsKey,[self editedCommand],nil];
	if([self takeInfo:nil forKeyPaths:iTM2TPFECommandEnvironmentsKey,[self editedCommand],nil] || yorn)
	{
		[[self document] updateChangeCount:NSChangeDone];
	}
    [self validateWindowContent];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateDefaultCommand:
- (BOOL)validateDefaultCommand:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Mar 26 08:41:36 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	// turn to default if either the script mode is not base
	// or the environment mode is customized
    return ([self localInfoForKeyPaths:iTM2TPFECommandsKey,[self editedCommand],nil] != nil)
		|| [self isCustomEnvironmentMode];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  showHelp:
- (IBAction)showHelp:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//    [iTM2HelpManager showHelp:iTM2TeXProjectHelpPage anchor:iTM2TeXProjectHelpAnchor];
#if 0
OSStatus status = AHSearch (
   (CFStringRef)iTeXMac2HelpBookName,
   (CFStringRef) @"projet"
);
    if(status)
        NSLog(@"There was an error: %u", status);

#elif 1
    OSStatus status = AHGotoPage(
        (CFStringRef)iTeXMac2HelpBookName,
        (CFStringRef)iTM2TeXProjectHelpPage,
            nil);
    if(status)
        NSLog(@"There was an error: %u", status);
#endif
    return;
}
@end

@implementation iTM2TeXPXtdCommandsInspector
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inspectorVariant
+ (NSString *)inspectorVariant;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return iTM2TeXProjectExtendedInspectorVariant;
}
@end

@interface iTM2TeXPCommandPerformer(PRIVATE)
+ (int)_commandLevel;
+ (int)_commandGroup;
@end

NSString * const iTM2TPFEDefaultEnvironmentKey = @"DefaultEnvironment";
//#import <iTM2Foundation/iTM2RuntimeBrowser.h>
//#import <iTM2Foundation/iTM2BundleKit.h>

static NSMutableDictionary * _iTM2TeXPCommandInspectors = nil;

@implementation iTM2TeXPCommandInspector
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initialize
+ (void)initialize;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [super initialize];
	if(!_iTM2TeXPCommandInspectors)
	{
		_iTM2TeXPCommandInspectors = [[NSMutableDictionary dictionary] retain];
//iTM2_LOG(@"_iTM2TeXPCommandInspectors are: %@", _iTM2TeXPCommandInspectors);
	}
    if([_iTM2TeXPCommandInspectors valueForKey:[self commandName]] != self)
    {
        [_iTM2TeXPCommandInspectors takeValue:self forKey:[self commandName]];
		if(iTM2DebugEnabled)
		{
			iTM2_LOG(@"Registering command inspector %@ for action key: %@\n%@", NSStringFromClass(self), [self commandName], _iTM2TeXPCommandInspectors);
		}
		// automatic initializing class "self"Responder if any.
		NSString * className = [NSStringFromClass(self) stringByAppendingString:@"Performer"];
		Class C = NSClassFromString(className);
		[C class];// Now we are sure that a +initialize has been sent
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  classForMode:
+ (id)classForMode:(NSString *)action;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    Class C = [_iTM2TeXPCommandInspectors valueForKey:action];
    if(!C)
	{
		iTM2_LOG(@"No command inspector for action: %@\nwithin %@", action, _iTM2TeXPCommandInspectors);
		C = [iTM2TeXPCommandInspector class];
	}
    return C;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  commandName
+ (NSString *)commandName;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	ICURegEx * RE = [[[ICURegEx alloc] initWithSearchPattern:@"iTM2TeXP(.*)Inspector" options:0 error:nil] autorelease];
	[RE setInputString:NSStringFromClass(self)];
	if([RE nextMatch])
	{
		return [RE substringOfCaptureGroupAtIndex:1];
	}
    return @"";
}
- (NSString *) infosKeyPathPrefix;
{
	return [iTM2TPFECommandsKey stringByAppendingPathExtension:[[self class] commandName]];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  OK:
- (IBAction)OK:(id)sender;
/*"This action is send to validate editing of the compile command.
Editing the compile command consists in choosing engines and engines environments for path extensions.
It also consists in managing the engine scripts except their contents.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	// saving the Compile environment
	[self saveChangesForKeyPaths:iTM2TPFECommandsKey,[[self class] commandName],nil];
    [super OK:sender];
//iTM2_END;
    return;
}
@end

//#import <iTM2Foundation/iTM2BundleKit.h>
//#import <iTM2Foundation/iTM2RuntimeBrowser.h>
//#import <iTM2Foundation/iTM2NotificationKit.h>

NSString * const TWSShellEnvironmentWrapperKey = @"TWSWrapper";
NSString * const TWSShellEnvironmentMasterKey = @"TWSMaster";
NSString * const TWSShellEnvironmentFrontKey = @"TWSFront";
NSString * const TWSShellEnvironmentProjectKey = @"TWSProject";

@implementation iTM2MainInstaller(TeXPCommandManager)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2TeXPCommandManager
+ (void)iTM2TeXPCommandManagerCompleteInstallation;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [iTM2TeXPCommandManager setupTeXMenu];
//iTM2_END;
    return;
}
@end

@implementation iTM2TeXPCommandManager
static NSArray * _iTM2TeXPBuiltInCommandNames = nil;
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initialize
+ (void)initialize;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [super initialize];
	[INC removeObserver:self];
	[INC addObserver:self selector:@selector(bundleDidLoadNotified:) name:iTM2BundleDidLoadNotification object:nil];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  bundleDidLoadNotified:
+ (void)bundleDidLoadNotified:(NSNotification *)notification;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self setupTeXMenu];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setupTeXMenu
+ (void)setupTeXMenu;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(_setupTeXMenu) object:nil];
	[self performSelector:@selector(_setupTeXMenu) withObject:nil afterDelay:0];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  _setupTeXMenu
+ (void)_setupTeXMenu;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
#if __iTM2_DEVELOPMENT__
#warning *** BUG TRACKING: OTHER TeX menu management
#pragma mark BUG TRACKING
	id MI = (NSMenuItem *)[[NSApp mainMenu] deepItemWithAction:@selector(projectCurrent:)];
	if(!MI)
	{
		iTM2_LOG(@"NO TEX MENU: please report possible bug");
		return;
	}
	NSMenu * M = [MI menu];
	// removing all the menu items with command responders as represented objects
	// finding the first menu item like that
	int index = [M indexOfItem:MI] + 1;
	while(index < [M numberOfItems])
	{
		NSMenuItem * mi = [M itemAtIndex:index];
		if([[mi representedObject] isSubclassOfClass:[iTM2TeXPCommandPerformer class]])
		{
			[M removeItemAtIndex:index];
			while(index < [M numberOfItems])
			{
				mi = (NSMenuItem *)[M itemAtIndex:index];
				if([[mi representedObject] isSubclassOfClass:[iTM2TeXPCommandPerformer class]] || [mi isSeparatorItem])
					[M removeItemAtIndex:index];
				else
					goto insert;
			}
		}
		++index;
	}
	// this is the first time I insert the stuff
//iTM2_LOG(@"FIRST TIME? NO MENU ITEM WITH A iTM2TeXPCommandPerformer INSTANCE REPRESENTED OBJECT");
	index = [M indexOfItem:MI] + 1;
	// inserting the stuff
	insert:;
//iTM2_LOG(@"THE MENU IS NOW: %@", M);
	NSEnumerator * E  = [[self orderedBuiltInCommandNames] objectEnumerator];
	NSEnumerator * e;
	while(e = [[E nextObject] objectEnumerator])
	{
		if([[M itemAtIndex:index] isSeparatorItem])
			++index;
		else if(![[M itemAtIndex:index-1] isSeparatorItem])
			[M insertItem:[NSMenuItem separatorItem] atIndex:index++];
		NSString * name;
		while(name = [e nextObject])
		{
			id performer = [self commandPerformerForName:name];
			SEL action = @selector(performCommand:);
			if([performer respondsToSelector:action])
			{
				NSMenuItem * mi = [[[NSMenuItem allocWithZone:[M zone]] initWithTitle:[[performer class] localizedNameForName:name]
						action: action
							keyEquivalent: [[performer class] keyEquivalentForName:name]] autorelease];
				[mi setKeyEquivalentModifierMask:[[performer class] keyEquivalentModifierMaskForName:name]];
				[mi setRepresentedObject:performer];
				[mi setTarget:performer];// performer is expected to last forever
				if([[mi keyEquivalent] length])
				{
					NSMenuItem * mite;
					NSMenu * rootMenu = [M rootMenu];
					while(mite = [rootMenu deepItemWithKeyEquivalent:[mi keyEquivalent]
							modifierMask: [mi keyEquivalentModifierMask]])
						[mite setKeyEquivalent:@""];
				}
				[M insertItem:mi atIndex:index++];
			}
		}
	}
	if((index < [M numberOfItems]) && ![[M itemAtIndex:index] isSeparatorItem])
	{
		[M insertItem:[NSMenuItem separatorItem] atIndex:index];
	}
#else
	id MI = (NSMenuItem *)[[NSApp mainMenu] deepItemWithAction:@selector(projectCurrent:)];
	if(!MI)
	{
		iTM2_LOG(@"NO TEX MENU: please report possible bug");
		return;
	}
	NSMenu * M = [MI menu];
	// removing all the menu items with command responders as represented objects
	// finding the first menu item like that
	int index = [M indexOfItem:MI] + 1;
	while(index < [M numberOfItems])
	{
		NSMenuItem * mi = [M itemAtIndex:index];
		if([[mi representedObject] isSubclassOfClass:[iTM2TeXPCommandPerformer class]])
		{
			[M removeItemAtIndex:index];
			while(index < [M numberOfItems])
			{
				mi = (NSMenuItem *)[M itemAtIndex:index];
				if([[mi representedObject] isSubclassOfClass:[iTM2TeXPCommandPerformer class]] || [mi isSeparatorItem])
					[M removeItemAtIndex:index];
				else
					goto insert;
			}
		}
		++index;
	}
	// this is the first time I insert the stuff
//iTM2_LOG(@"FIRST TIME? NO MENU ITEM WITH A iTM2TeXPCommandPerformer INSTANCE REPRESENTED OBJECT");
	index = [M indexOfItem:MI] + 1;
	// inserting the stuff
	insert:;
//iTM2_LOG(@"THE MENU IS NOW: %@", M);
	NSEnumerator * E  = [[self orderedBuiltInCommandNames] objectEnumerator];
	NSEnumerator * e;
	while(e = [[E nextObject] objectEnumerator])
	{
		if([[M itemAtIndex:index] isSeparatorItem])
			++index;
		else if(![[M itemAtIndex:index-1] isSeparatorItem])
			[M insertItem:[NSMenuItem separatorItem] atIndex:index++];
		NSString * name;
		while(name = [e nextObject])
		{
			id performer = [self commandPerformerForName:name];
			SEL action = @selector(performCommand:);
			if([performer respondsToSelector:action])
			{
				NSMenuItem * mi = [[[NSMenuItem allocWithZone:[M zone]] initWithTitle:[[performer class] localizedNameForName:name]
						action: action keyEquivalent: [[performer class] keyEquivalentForName:name]] autorelease];
				[mi setKeyEquivalentModifierMask:[[performer class] keyEquivalentModifierMaskForName:name]];
				[mi setRepresentedObject:performer];
				[mi setTarget:performer];// performer is expected to last forever
				// before we insert the menu item, we try to remove the items with the same keyEquivalent and modifier mask
				if([[mi keyEquivalent] length])
				{
					NSMenuItem * mite;
					NSMenu * rootMenu = [M rootMenu];
					while(mite = [rootMenu deepItemWithKeyEquivalent:[mi keyEquivalent]
							modifierMask: [mi keyEquivalentModifierMask]])
						[mite setKeyEquivalent:@""];
				}
				[M insertItem:mi atIndex:index++];
			}
		}
	}
	if((index < [M numberOfItems]) && ![[M itemAtIndex:index] isSeparatorItem])
	{
		[M insertItem:[NSMenuItem separatorItem] atIndex:index];
	}
#endif
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  builtInCommandNames
+ (NSArray *)builtInCommandNames;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	static int oldNumberOfClasses = 0;
	int newNumberOfClasses = [iTM2RuntimeBrowser numberOfClasses];
    if(oldNumberOfClasses != newNumberOfClasses)
	{
		[_iTM2TeXPBuiltInCommandNames autorelease];
		_iTM2TeXPBuiltInCommandNames = nil;
		NSMutableSet * set = [NSMutableSet set];
		NSEnumerator * E = [[iTM2RuntimeBrowser subclassReferencesOfClass:[iTM2TeXPCommandPerformer class]] objectEnumerator];
		Class C;
		while(C = (Class)[[E nextObject] nonretainedObjectValue])
		{
			if([C commandLevel])
			{
				[set addObject:[C commandName]];
			}
		}
		_iTM2TeXPBuiltInCommandNames = [[set allObjects] retain];
		oldNumberOfClasses = newNumberOfClasses;
		[self setupTeXMenu];
	}
//iTM2_LOG(@"_iTM2TeXPBuiltInCommandNames are: %@", _iTM2TeXPBuiltInCommandNames);
//iTM2_END;
    return _iTM2TeXPBuiltInCommandNames;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  orderedBuiltInCommandNames
+ (NSArray *)orderedBuiltInCommandNames;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSMutableDictionary * MD = [NSMutableDictionary dictionary];
	NSEnumerator * E = [[iTM2RuntimeBrowser subclassReferencesOfClass:[iTM2TeXPCommandPerformer class]] objectEnumerator];
	Class C;
	NSNumber * K;
	while(C = (Class)[[E nextObject] nonretainedObjectValue])
	{
		K = [NSNumber numberWithInt:[C commandGroup]];
		NSMutableDictionary * md = [MD objectForKey:K];
		if(!md)
		{
			[MD setObject:[NSMutableDictionary dictionary] forKey:K];
			md = [MD objectForKey:K];
		}
		if([C commandLevel])
			[md setObject:[C commandName] forKey:[NSNumber numberWithInt:[C commandLevel]]];
	}
	NSMutableArray * MRA = [NSMutableArray array];
	E = [[[MD allKeys] sortedArrayUsingSelector:@selector(compare:)] objectEnumerator];
	while(K = [E nextObject])
	{
		NSMutableArray * mra = [NSMutableArray array];
		NSDictionary * D = [MD objectForKey:K];
		NSEnumerator * e = [[[D allKeys] sortedArrayUsingSelector:@selector(compare:)] objectEnumerator];
		NSNumber * k;
		while(k = [e nextObject])
			[mra addObject:[D objectForKey:k]];
		if([mra count])
			[MRA addObject:mra];
	}
	if(iTM2DebugEnabled)
	{
		iTM2_LOG(@"ORDERED BUILT IN COMMAND NAMES are: %@", MRA);
	}
    return MRA;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  commandPerformerForName:
+ (id)commandPerformerForName:(NSString *)name;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(![name length])
		return nil;
	id result = NSClassFromString([NSString stringWithFormat:@"iTM2TeXP%@Performer", name]);
	if(!result)
	{
		NSEnumerator * E = [[iTM2RuntimeBrowser subclassReferencesOfClass:[iTM2TeXPCommandPerformer class]] objectEnumerator];
		while(result = [[E nextObject] nonretainedObjectValue])
			if([name isEqualToString:[result commandName]])
				return result;
	}
    return result;
}
@end

NSString * const iTM2TeXPCommandTableName = @"Commands";
NSString * const iTM2EnvironmentVariablesKey = @"iTM2EnvironmentVariables";
NSString * const iTM2FactoryEnvironmentVariablesKey = @"iTM2FactoryEnvironmentVariables";

@implementation iTM2TeXPCommandPerformer
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initialize
+ (void)initialize;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 09/21/2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[super initialize];
	NSArray * paths = [[NSBundle mainBundle] allPathsForResource:@"EnvironmentVariables" ofType:@"plist"];
	NSEnumerator * E = [paths reverseObjectEnumerator];
	NSString * path = nil;
	NSMutableDictionary * MD = [NSMutableDictionary dictionary];
	while(path = [E nextObject])
	{
		NSDictionary * D = [NSDictionary dictionaryWithContentsOfFile:path];
		[MD addEntriesFromDictionary:D];
	}
	[SUD registerDefaults:[NSDictionary dictionaryWithObject:MD forKey:iTM2EnvironmentVariablesKey]];
	[SUD registerDefaults:[NSDictionary dictionaryWithObject:MD forKey:iTM2FactoryEnvironmentVariablesKey]];
	//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  commandName
+ (NSString *)commandName;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	const char * _classname = [NSStringFromClass(self) lossyCString];
	if(!strncmp(_classname, "iTM2TeXP", strlen("iTM2TeXP")))
	{
		int n = strlen(_classname);
		if(n>strlen("iTM2TeXPPerformer"))
		{
			if(!strncmp(_classname + n - strlen("Performer"), "Performer", strlen("Performer")))
			{
				return [NSString stringWithCString:_classname+strlen("iTM2TeXP") length:n - strlen("iTM2TeXPPerformer")];
			}
		}
	}
    return @"";
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  localizedNameForName:
+ (NSString *)localizedNameForName:(NSString *)name;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return NSLocalizedStringFromTableInBundle(name, iTM2TeXPCommandTableName, myBUNDLE, "");
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  menuItemTitleForProject:
+ (NSString *)menuItemTitleForProject:(id)project;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [self localizedNameForName:[self commandName]];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  commandLevel
+ (int)commandLevel;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return 0;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  _commandLevel
+ (int)_commandLevel;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * S = NSLocalizedStringWithDefaultValue([[self commandName] stringByAppendingPathExtension:@"level"],
				iTM2TeXPCommandTableName, myBUNDLE, ([NSString stringWithFormat:@"%i", [self commandLevel]]), "");
    return [S intValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  commandGroup
+ (int)commandGroup;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return 0;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  _commandGroup
+ (int)_commandGroup;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * S = NSLocalizedStringWithDefaultValue([[self commandName] stringByAppendingPathExtension:@"group"],
				iTM2TeXPCommandTableName, myBUNDLE, ([NSString stringWithFormat:@"%i", [self commandGroup]]), "");
    return [S intValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  keyEquivalentForName:
+ (NSString *)keyEquivalentForName:(NSString *)name;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * result = NSLocalizedStringFromTableInBundle([name stringByAppendingPathExtension:@"keyEquivalent"],
				iTM2TeXPCommandTableName, myBUNDLE, "");
    return [result length] != 1? @"":[result substringWithRange:NSMakeRange(0, 1)];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  keyEquivalentModifierMaskForName;
+ (unsigned int)keyEquivalentModifierMaskForName:(NSString *)name;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * stringResult = NSLocalizedStringWithDefaultValue([name stringByAppendingPathExtension:@"modifierMask"],
				iTM2TeXPCommandTableName, myBUNDLE, @"NONE", "");
	unsigned int result = 0;
	if([stringResult rangeOfString:@"^"].location != NSNotFound)
		result = result | NSControlKeyMask;
	if([stringResult rangeOfString:@"$"].location != NSNotFound)
		result = result | NSShiftKeyMask;
	if([stringResult rangeOfString:@"~"].location != NSNotFound)
		result = result | NSAlternateKeyMask;
	if([stringResult rangeOfString:@"@"].location != NSNotFound)
		result = result | NSCommandKeyMask;
	if(!result)
		result = NSCommandKeyMask;
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  launchAction:withEngine:forMaster:ofProject:
+ (void)launchAction:(NSString *)action withEngine:(NSString *)engine forMaster:(NSString *)master ofProject:(NSString *)project;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	iTM2_LOG(@"FAILED: MISSING IMPLEMENTATION");
    return;
//iTM2_END;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  performCommand:
+ (IBAction)performCommand:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self performCommandForProject:[SPC requiredTeXProjectForSource:nil]];
    return;
//iTM2_END;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  canPerformCommandForProject:
+ (BOOL)canPerformCommandForProject:(iTM2TeXProjectDocument *)project;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [[SDC currentDocument] isKindOfClass:[iTM2Document class]];//project != nil;
//iTM2_END;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  performCommandForProject:
+ (void)performCommandForProject:(iTM2TeXProjectDocument *)project;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_LOG(@"I HAVE RECEIVED THE ORDER TO START");
#if 1
	if([self mustSaveProjectDocumentsBefore])
	{
		[project saveDocument:nil];
//		[project writeSafelyToURL:[project fileURL] ofType:[project fileType] forSaveOperation:NSSaveOperation error:nil];
	}
	[self doPerformCommandForProject:project];
#else
	if([self mustSaveProjectDocumentsBefore])
		[project saveAllProjectDocumentsWithDelegate: self
			didSaveAllSelector: @selector(project:didSaveAllProjectDocuments:contextInfo:)
				contextInfo: nil];
	else
		[self doPerformCommandForProject:project];
#endif
    return;
//iTM2_END;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  project:didSaveAllProjectDocuments:contextInfo:
+ (void)project:(id)project didSaveAllProjectDocuments:(BOOL)flag contextInfo:(void *)contextInfo;
/*"Call back must have the following signature:
- (void)documentController:(if)DC didSaveAll:(BOOL)flag contextInfo:(void *)contextInfo;
Version History: jlaurens AT users DOT sourceforge DOT net (12/07/2001)
- < 1.1: 03/10/2002
To Do List: to be improved...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self doPerformCommandForProject:project];
    return;
//iTM2_END;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  doPerformCommandForProject:
+ (void)doPerformCommandForProject:(iTM2TeXProjectDocument *)project;
/*"Call back must have the following signature:
- (void)documentController:(if)DC didSaveAll:(BOOL)flag contextInfo:(void *)contextInfo;
Version History: jlaurens AT users DOT sourceforge DOT net (12/07/2001)
- < 1.1: 03/10/2002
To Do List: to be improved...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(!project)
		return;
	static NSString * iTM2_Launch = nil;
	if(!iTM2_Launch)
	{
		iTM2_Launch = [@"bin" stringByAppendingPathComponent:@"iTM2_Launch.rb"];
		iTM2_Launch = [[[iTM2TeXPCommandPerformer classBundle] pathForAuxiliaryExecutable:iTM2_Launch] copy];// statically retained!
		if(![DFM isExecutableFileAtPath:iTM2_Launch])
		{
			iTM2_LOG(@"ERROR: THERE IS A BAD PROBLEM: iTM2_Launch is not executable or missing... REPORT BUG 1!!!");
			return;
		}
	}
	NSString * commandName = [self commandName];
    if(project)
	{
		iTM2TaskController * TC = [project taskController];
#warning DEBUGGGGG: add a SUD default here, related to hidden and silent from the terminal window
		[project takeContextValue:commandName forKey:@"iTM2TeXProjectLastCommandName" domain:iTM2ContextAllDomainsMask];
		[project showTerminalInBackGroundIfNeeded:self];
		if(iTM2DebugEnabled>100)
		{
			iTM2_LOG(@"/\\/\\/\\/\\  performing action name: %@ for project: %@", commandName, [project fileName]);
		}
		NSString * localizedCommand = [self localizedNameForName:commandName];

		NSString * status = [NSString stringWithFormat:
			NSLocalizedStringFromTableInBundle(
				@"Performing action %@ for %@ of project %@...",
					iTM2TeXProjectFrontendTable,
						[self classBundle], nil),
							localizedCommand,
								[project relativeFileNameForKey:[project masterFileKey]],
									[project projectName]];
		[self postNotificationWithStatus:status];
//        [project saveProjectDocuments:self]; this is already done if necessary
//iTM2_LOG(@"/\\/\\/\\/\\  1");
        iTM2TaskWrapper * TW = [[[iTM2TaskWrapper allocWithZone:[self zone]] init] autorelease];
//iTM2_LOG(@"/\\/\\/\\/\\  2");
		NSString * MFK = [project masterFileKey];
		NSDocument * CD = [SDC currentDocument];
		if([MFK isEqualToString:@"...iTM2FrontDocument"])
		{
			MFK = [CD fileName];
			MFK = [project keyForFileName:MFK];
		}
		else if(![MFK length])
		{
			// the project has not yet a master file key
			NSArray * Ks = [project allFileKeys];
#warning ERROR: IT IS NOT CLEAR
			if([Ks count] == 1)
			{
				MFK = [Ks lastObject];
				[project setMasterFileKey:MFK];
			}
			else
			{
				MFK = [CD fileName];
				MFK = [project keyForFileName:MFK];
				[project setMasterFileKey:@"...iTM2FrontDocument"];
			}
		}
		NSString * master = [project relativeFileNameForKey:MFK];
		[TW setLaunchPath:iTM2_Launch];
//iTM2_LOG(@"/\\/\\/\\/\\  3");
		NSDictionary * D = [SUD dictionaryForKey:iTM2EnvironmentVariablesKey];
		[TW replaceEnvironment:D];
		D = [self concreteEnvironmentDictionaryForProject:project]?:[NSDictionary dictionary];
//iTM2_LOG(@"D is:%@",D);
        [TW mergeEnvironment: D];
//iTM2_LOG(@"[project commandEnvironmentDictionary] is: %@", [project commandEnvironmentDictionary]);
//iTM2_LOG(@"[TW environment] is: %@", [TW environment]);
//iTM2_LOG(@"[TW environment] is: %@", [TW environment]);
		NSString * currentDirectory = [[TW environment] objectForKey:TWSShellEnvironmentProjectKey];
		currentDirectory = [currentDirectory stringByDeletingLastPathComponent];
        [TW setCurrentDirectoryPath:(currentDirectory?:@"")];
		[TW setEnvironmentString:[[iTM2_Launch stringByDeletingLastPathComponent] stringByAppendingPathComponent:@"iTM2_Gobble"] forKey:@"iTM2_CMD_Gobble"];
		if([TC isMute])
		{
			[TW setEnvironmentString:[[iTM2_Launch stringByDeletingLastPathComponent] stringByAppendingPathComponent:@"iTM2_Gobble"] forKey:@"iTM2_CMD_Notify"];
		}
		else
		{
			[TW setEnvironmentString:iTeXMac2 forKey:@"iTM2_CMD_Notify"];
		}
//		[TW setEnvironmentString:[[iTM2_Launch stringByDeletingLastPathComponent] stringByAppendingPathComponent:@"iTM2_Notify"] forKey:@"iTM2_CMD_Notify"];
        [TW addArgument:@"-a"];
        [TW addArgument:commandName];
        [TW addArgument:@"-p"];
        [TW addArgument:[project fileName]];
        [TW addArgument:@"-m"];
        [TW addArgument:master];
		[TW setEnvironmentString:[NSString farawayProjectsDirectory] forKey:@"iTM2_Faraway_Projects_Directory"];
		[TW setEnvironmentString:[NSBundle temporaryBaseProjectsDirectory] forKey:@"iTM2_Base_Projects_Directory"];
		[TW setEnvironmentString:[project getTeXMFProgramsPath] forKey:@"iTM2_PATH_TeX_Programs"];
		[TW setEnvironmentString:[project getOtherProgramsPath] forKey:@"iTM2_PATH_Other_Programs"];
		[TW setEnvironmentString:[project getCompletePATHPrefix] forKey:@"iTM2_PATH_Prefix"];
		[TW setEnvironmentString:[project getCompletePATHSuffix] forKey:@"iTM2_PATH_Suffix"];
		[TW setEnvironmentString:[project getCompleteTEXMFOUTPUT] forKey:@"iTM2_TEXMFOUTPUT"];
		if([project getPATHUsesLoginShell])
		{
			[TW setEnvironmentString:@"YES" forKey:@"iTM2_PATH_UsesLoginShell"];// not yet used?
		}
//iTM2_LOG(@"component is: %@", component);
		[TW setDelegate: self
            launchCallback: NULL
                terminateCallback: @selector(taskWrapperDidPerformCommand:taskController:userInfo:)
					interruptCallback: NULL
						userInfo: [[NSDictionary dictionaryWithObject:[NSValue valueWithNonretainedObject:project] forKey:@"ProjectRef"] retain]];
        [project smartShowTerminal:self];
        [TC restartWithTaskWrapper:TW];
    }
    else
    {
        [SDC openDocument:self];
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  taskWrapperDidPerformCommand:taskController:userInfo:
+ (void)taskWrapperDidPerformCommand:(iTM2TaskWrapper *)TW taskController:(iTM2TaskController *)TC userInfo:(id)userInfo;
/*"Here come the actions to be performed when the Index task has completed.
userInfo is still owned by the receiver and should be released.
Subclassers will prepend their own stuff.
Version History: jlaurens AT users DOT sourceforge DOT net 
- 1: 09/02/2001
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[userInfo autorelease];
	if(iTM2DebugEnabled>100)
    {
        iTM2_LOG(@"Command %@ performed. Default implementation should be overriden", [self commandName]);
    }
	userInfo = nil;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validatePerformCommand:
+ (BOOL)validatePerformCommand:(id <NSMenuItem>)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    iTM2TeXProjectDocument * TPD = [SPC TeXProjectForSource:sender]?:[SPC currentTeXProject];
	[sender setTitle:[self menuItemTitleForProject:TPD]];
	if([SPC isBaseProject:TPD])
		return NO;
	// selector  names like projectXXXXX: are catched here
	NSString * lastCommandName = [TPD contextValueForKey:@"iTM2TeXProjectLastCommandName" domain:iTM2ContextAllDomainsMask];
	NSString * commandName = [self commandName];
	[sender setState:([lastCommandName isEqualToString:commandName]?NSMixedState:NSOffState)];
	NSImage * I = [NSImage imageNamed:@"iTeXMac2Mini"];
	if(!I)
	{
		NSString * path = [[NSBundle bundleForClass:self] pathForImageResource:@"iTeXMac2Mini"];
		I = [[NSImage alloc] initWithContentsOfFile:path];
		[I setName:@"iTeXMac2Mini"];// Who is the owner?
	}
	[sender setMixedStateImage:I];// this does not work yet, may be in leopard...
//iTM2_LOG(@"I: %@, MSI: %@", I, [sender mixedStateImage]);
	NSString * scriptMode = [TPD infoForKeyPaths:iTM2TPFECommandsKey,commandName,iTM2TPFEScriptModeKey,nil];
	if([scriptMode isEqualToString:iTM2TPFEVoidMode])
		return NO;
	if([scriptMode isEqual:iTM2TPFEBaseMode])
	{
		[TPD takeInfo:nil forKeyPaths:iTM2TPFECommandsKey,commandName,iTM2TPFEScriptModeKey,nil];
		scriptMode = [TPD infoForKeyPaths:iTM2TPFECommandsKey,commandName,iTM2TPFEScriptModeKey,nil];
		if([scriptMode isEqual:iTM2TPFEBaseMode])
		{
			scriptMode = nil;
		}
	}
//iTM2_LOG(@"commandName is: %@, scriptMode is: %@", commandName, scriptMode);
	else if([scriptMode length])
		return [TPD infoForKeyPaths:iTM2TPFECommandScriptsKey,scriptMode,nil] != nil;
	else
		return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= concreteEnvironmentDictionaryForProject:
+ (NSDictionary *)concreteEnvironmentDictionaryForProject:(iTM2TeXProjectDocument *)project;
/*"Sets up the riht file objects. The extension should be set by the one who will fill up a task environemnt.
Version history: jlaurens AT users DOT sourceforge DOT net
- Thu Oct 28 14:05:13 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSMutableDictionary * result = [NSMutableDictionary dictionary];
//iTM2_LOG(@"4-iTM2_Compile_tex is: %@", [result objectForKey:@"iTM2_Compile_tex"]);
	// more general stuff
    [result takeValue:[project wrapperName] forKey:TWSShellEnvironmentWrapperKey];
	NSDocument * CD = [SDC currentDocument];
	if(CD == project)
	{
		NSArray * RA = [NSApp orderedWindows];
		NSEnumerator * E = [RA objectEnumerator];
		NSWindow * W;
blablabla:
		if(W = [E nextObject])
		{
			if(project == [SPC projectForSource:W])
			{
				id doc = [[W windowController] document];
				if(project != doc)
				{
					CD = doc;
				}
				else
				{
					goto blablabla;
				}
			}
		}
	}
	NSString * MFK = [CD fileName];
	MFK = [project keyForFileName:MFK];
	MFK = [project relativeFileNameForKey:MFK];
    [result takeValue:MFK forKey:TWSShellEnvironmentFrontKey];
	MFK = [project masterFileKey];
	if([MFK isEqualToString:@"...iTM2FrontDocument"])
	{
		MFK = [project keyForFileName:[CD fileName]];
	}
	else if(![MFK length])
	{
		// the project has not yet a master file key
		NSArray * Ks = [project allFileKeys];
#warning ERROR: IT IS NOT CLEAR
		if([Ks count] == 1)
		{
			MFK = [Ks lastObject];
			[project setMasterFileKey:MFK];
		}
		else
		{
			MFK = [project keyForFileName:[CD fileName]];
			[project setMasterFileKey:@"...iTM2FrontDocument"];
		}
	}
#warning THIS SHOULD CHANGE TO THE RELATIVE FILENAME
	NSString * master = [project absoluteFileNameForKey:MFK];
    [result takeValue:master forKey:TWSShellEnvironmentMasterKey];
    [result takeValue:[project fileName] forKey:TWSShellEnvironmentProjectKey];
    [result takeValue:[NSNumber numberWithInt:iTM2DebugEnabled] forKey:@"iTM2_Debug"];
//iTM2_LOG(@"=+=+=+=+=  -2-");
	if(iTM2DebugEnabled>100)
	{
		iTM2_LOG(@"result for project %@ is: %@", project, result);
	}
 //iTM2_END;
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= mustSaveProjectDocumentsBefore
+ (BOOL)mustSaveProjectDocumentsBefore;
/*"Sets up the riht file objects. The extension should be set by the one who will fill up a task environemnt.
Version history: jlaurens AT users DOT sourceforge DOT net
- Thu Oct 28 14:05:13 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
 //iTM2_END;
    return YES;
}
+ (void)encodeWithCoder:(NSCoder *)aCoder;
{
	[aCoder encodeObject:NSStringFromClass(self) forKey:@"performerClassName"];
}
- (void)encodeWithCoder:(NSCoder *)aCoder;
{
	return;
}
- (id)initWithCoder:(NSCoder *)aDecoder;
{
	NSString * performerClassName = [aDecoder decodeObjectForKey:@"performerClassName"];
	id result = NSClassFromString(performerClassName);
	if(result)
	{
		[self dealloc];
		self = nil;
		return result;
	}
	return self = [super init];
}
@end
