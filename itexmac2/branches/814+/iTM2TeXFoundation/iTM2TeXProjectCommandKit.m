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
NSString * const iTM2TeXPCommandRegexKey = @"Command Name";
NSString * const iTM2TeXPCommandRegexName = @"name";

//#import <iTM2Foundation/iTM2MenuKit.h>
//#import <iTM2Foundation/iTM2WindowKit.h>

@interface iTM2TeXPCommandsInspector(FrontendKit)
- (id)editedCommand;
- (void)setEditedCommand:(id)argument;
@end

@implementation NSArray(iTM2TeXProjectCommandKit)
- (NSArray *)filteredArrayUsingPredicateValue:(NSString *)value forKey:(NSString *)key;
{
	if(value.length)
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSString * name = @"showCurrentProjectSettings(small)";
	NSImage * I = [NSImage cachedImageNamed4iTM3:name];
	if(![I isNotNullImage4iTM3])
	{
		I = [[NSImage cachedImageNamed4iTM3:@"showCurrentProjectSettings"] copy];
		[I setSizeSmallIcon4iTM3];
		[I setName:name];
	}
    return I;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inspectorType4iTM3
+ (NSString *)inspectorType4iTM3;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return iTM2TeXProjectInspectorType;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inspectorMode
+ (NSString *)inspectorMode;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return iTM2TeXProjectSettingsInspectorMode;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  windowDidLoad
- (void)windowDidLoad;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [super windowDidLoad];
    NSWindow * W = self.window;
    W.delegate = self;
    [INC addObserver: self
	    selector: @selector(flagsDidChangeNotified:)
		    name: iTM2FlagsDidChangeNotification
			    object: nil];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= windowPositionShouldBeObserved4iTM3
- (BOOL)windowPositionShouldBeObserved4iTM3;
/*"YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  flagsDidChangeNotified:
- (void)flagsDidChangeNotified:(NSNotification *)notification;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if([notification object] == self.window)
		self.validateWindowContent4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  windowTitleForDocumentDisplayName:
- (NSString *)windowTitleForDocumentDisplayName:(NSString *)displayName;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if(!displayName.length)
        displayName = [self.document displayName];// retrieve the "untitled" if relevant
    return [NSString stringWithFormat: 
        NSLocalizedStringFromTableInBundle(@"%1$@ (%2$@)", @"Project", [iTM2ProjectDocument classBundle4iTM3], "blah (project name)"),
        [self.class prettyInspectorMode],
            displayName];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  windowsMenuItemTitleForDocumentDisplayName4iTM3:
- (NSString *)windowsMenuItemTitleForDocumentDisplayName4iTM3:(NSString *)displayName;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    // the format trick allows to have a return value even if nothing is defined in the locales...
    // it might be useless...
    return [NSString stringWithFormat: @"%@",
        NSLocalizedStringFromTableInBundle([self.class prettyInspectorMode], @"Commands", myBUNDLE, "Description forthcoming"),
            displayName];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  windowShouldClose:
- (BOOL)windowShouldClose:(id)sender;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/11/01)
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self.window orderOut:self];
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  close
- (void)close;
/*"Before calling the inherited method, update the list of available projects.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[super close];
//END4iTM3;
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
    self.validateWindowContent4iTM3;
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
	id project = self.document;
	if([project isDocumentEdited])
	{
		[project removeFactory];
		[project saveDocument:self];
	}
#warning REMOVE THE BIN DIRECTORy instead?
    [self.window orderOut:self];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  switchToAdvancedSettings:
- (IBAction)switchToAdvancedSettings:(id)sender;
/*"Message sent by the "Advanced Settings" button in the basic project settings panel.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if([[self.class inspectorVariant] isEqualToString:[iTM2TeXPCommandsInspector inspectorVariant]])
	{
		// we can switch
		id doc = self.document;
		[doc saveDocument:sender];// to properly manage the undo stack
		[doc replaceInspectorMode:[self.class inspectorMode] variant:[iTM2TeXPXtdCommandsInspector inspectorVariant]];
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if(![[self.class inspectorVariant] isEqualToString:[iTM2TeXPCommandsInspector inspectorVariant]])
	{
		// we can switch
		id doc = self.document;
		[doc saveDocument:sender];// to properly manage the undo stack
		[doc replaceInspectorMode:[self.class inspectorMode] variant:[iTM2TeXPCommandsInspector inspectorVariant]];
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
    id TPD = (iTM2TeXProjectDocument *)self.document;
	if([SPC isBaseProject:TPD])
	{
		return;
	}
	NSString * oldBPN = [TPD baseProjectName];
	NSDictionary * oldTPPs = [oldBPN TeXProjectProperties4iTM3];
	NSString * newMode = [(id)[sender selectedItem] title];
	// get all the base project names with that new mode
	NSArray * TPPs = [[SPC baseProjectNames] valueForKey:@"TeXProjectProperties4iTM3"];
	// filter out with newMode, case sensitive
	NSArray * RA = [TPPs filteredArrayUsingPredicateValue:newMode forKey:iTM2TPDKModeKey];
	NSAssert(RA.count>0,@"Internal inconsistency, the new mode should exist!");
	// try to keep the extension
	NSArray * nextRA = [RA filteredArrayUsingPredicateValue:[oldTPPs valueForKey:iTM2TPDKExtensionKey] forKey:iTM2TPDKExtensionKey];
	if(nextRA.count)
	{
		RA = nextRA;
	}
	else
	{
		NSString * newBPN = nil;
the_end:
		newBPN = [[RA objectAtIndex:0] TeXBaseProjectName4iTM3];
		if(![[TPD baseProjectName] pathIsEqual4iTM3:newBPN])
		{
			[TPD setBaseProjectName:newBPN];
			[TPD updateChangeCount:NSChangeDone];
		}
		self.validateWindowContent4iTM3;
		return;
	}
	// try to keep the variant
	nextRA = [RA filteredArrayUsingPredicateValue:[oldTPPs valueForKey:iTM2TPDKVariantKey] forKey:iTM2TPDKVariantKey];
	if(nextRA.count)
	{
		RA = nextRA;
	}
	else
	{
		goto the_end;
	}
	// try to keep the ouput
	nextRA = [RA filteredArrayUsingPredicateValue:[oldTPPs valueForKey:iTM2TPDKOutputKey] forKey:iTM2TPDKOutputKey];
	if(nextRA.count)
	{
		RA = nextRA;
	}
	goto the_end;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateChooseBaseMode:
- (BOOL)validateChooseBaseMode:(NSPopUpButton *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Mar 26 08:41:36 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    id TPD = (iTM2TeXProjectDocument *)self.document;
	if([SPC isBaseProject:TPD])
	{
		return NO;
	}
//LOG4iTM3(@"sender is: %@", sender);
    if([sender isKindOfClass:[NSPopUpButton class]])
    {
		static NSString * voidTitle = nil;
		if(!voidTitle)
			voidTitle = [[sender.lastItem title] copy];
        [sender removeAllItems];
		// get the available modes of the array of the tex project properties of all the base project names
		NSArray * modes = [[[SPC baseProjectNames] valueForKey:@"TeXProjectProperties4iTM3"] valueForKey:iTM2TPDKModeKey];
		// get only one copy per mode
		modes = [[NSSet setWithArray:modes] allObjects];
		// sort the modes
		modes = [modes sortedArrayUsingSelector:@selector(compare:)];
		// feed the sender
        NSString * mode;
        for(mode in modes)
        {
			if(![mode isEqual:iTM2ProjectDefaultName])// the default mode is not added
			{
				[sender addItemWithTitle:mode];
				sender.lastItem.representedObject = mode;
			}
        }
		// select the proper item
		NSString * BPN = [TPD baseProjectName];
        NSDictionary * Ps = [BPN TeXProjectProperties4iTM3];
        mode = [Ps iVarMode];
        NSInteger idx = [sender indexOfItemWithRepresentedObject:mode];
        if(idx == -1)
        {
            if([sender numberOfItems])
				[sender.menu addItem:[NSMenuItem separatorItem]];
            [sender addItemWithTitle:[NSString stringWithFormat:@"%@(Unknown)", mode]];
            [sender selectItem:sender.lastItem];        
            sender.lastItem.representedObject = nil;// BEWARE!!!
			[sender.lastItem setEnabled: NO];
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
		return [(NSMenuItem *)sender representedObject] != nil;
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
    id TPD = (iTM2TeXProjectDocument *)self.document;
	if([SPC isBaseProject:TPD])
	{
		return;
	}
	NSString * oldBPN = [TPD baseProjectName];
	NSDictionary * oldTPPs = [oldBPN TeXProjectProperties4iTM3];
	// get all the base project names with that actual mode
	NSArray * TPPs = [[SPC baseProjectNames] valueForKey:@"TeXProjectProperties4iTM3"];
	TPPs = [TPPs filteredArrayUsingPredicateValue:[oldTPPs valueForKey:iTM2TPDKModeKey] forKey:iTM2TPDKModeKey];
	// filter out with newExtension, case sensitive
	NSString * newExtension = [(id)[sender selectedItem] representedObject];
	NSArray * RA = [TPPs filteredArrayUsingPredicateValue:newExtension forKey:iTM2TPDKExtensionKey];
	NSAssert(RA.count>0,@"Internal inconsistency, the new mode should exist!");
	// try to keep the variant
	NSArray * nextRA = [RA filteredArrayUsingPredicateValue:[oldTPPs valueForKey:iTM2TPDKVariantKey] forKey:iTM2TPDKVariantKey];
	if(nextRA.count)
	{
		RA = nextRA;
	}
	else
	{
		NSString * newBPN;
the_end:
		newBPN = [[RA objectAtIndex:0] TeXBaseProjectName4iTM3];
		if(![[TPD baseProjectName] pathIsEqual4iTM3:newBPN])
		{
			[TPD setBaseProjectName:newBPN];
			[TPD updateChangeCount:NSChangeDone];
		}
		self.validateWindowContent4iTM3;
		return;
	}
	// try to keep the ouput
	nextRA = [RA filteredArrayUsingPredicateValue:[oldTPPs valueForKey:iTM2TPDKOutputKey] forKey:iTM2TPDKOutputKey];
	if(nextRA.count)
	{
		RA = nextRA;
	}
	goto the_end;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateChooseExtension:
- (BOOL)validateChooseExtension:(NSPopUpButton *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Mar 26 08:41:36 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    id TPD = (iTM2TeXProjectDocument *)self.document;
	if([SPC isBaseProject:TPD])
	{
		return NO;
	}
//LOG4iTM3(@"sender is: %@", sender);
    if([sender isKindOfClass:[NSPopUpButton class]])
    {
		static NSString * voidTitle = nil;
		if(!voidTitle)
			voidTitle = [[sender.lastItem title] copy];
        [sender removeAllItems];
        NSDictionary * Ps = [[TPD baseProjectName] TeXProjectProperties4iTM3];
		// get all the base project names properties
		NSArray * TPPs = [[SPC baseProjectNames] valueForKey:@"TeXProjectProperties4iTM3"];
		// filter out those with the proper mode
		TPPs = [TPPs filteredArrayUsingPredicateValue:[Ps iVarMode] forKey:iTM2TPDKModeKey];
		// get the extensions
		NSArray * extensions = [TPPs valueForKey:iTM2TPDKExtensionKey];
		// get only one copy per extension
		extensions = [[NSSet setWithArray:extensions] allObjects];
		// sort the extensions
		extensions = [extensions sortedArrayUsingSelector:@selector(compare:)];
		// feed the sender
        NSString * extension;
        for(extension in extensions)
        {
			if(extension.length)
			{
				[sender addItemWithTitle:NSLocalizedStringFromTableInBundle([extension lowercaseString],iTM2TeXProjectFrontendTable,[NSBundle bundleForClass:[iTM2TeXProjectDocument class]],"")];
			}
			else
			{
				[sender addItemWithTitle:NSLocalizedStringFromTableInBundle(@"Standard",iTM2TeXProjectFrontendTable,[NSBundle bundleForClass:[iTM2TeXProjectDocument class]],"")];
			}
			sender.lastItem.representedObject = extension;
        }
        extension = [Ps iVarExtension];
        NSInteger idx = [sender indexOfItemWithRepresentedObject:extension];
        if(idx == -1)
        {
            if([sender numberOfItems])
				[sender.menu addItem:[NSMenuItem separatorItem]];
            [sender addItemWithTitle:[NSString stringWithFormat:@"%@(Unknown)", extension]];
            [sender selectItem:sender.lastItem];        
            sender.lastItem.representedObject = nil;// BEWARE!!!
			[sender.lastItem setEnabled: NO];
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
		return [(NSMenuItem *)sender representedObject] != nil;
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
    id TPD = (iTM2TeXProjectDocument *)self.document;
	if([SPC isBaseProject:TPD])
	{
		return;
	}
	NSString * oldBPN = [TPD baseProjectName];
	NSDictionary * oldTPPs = [oldBPN TeXProjectProperties4iTM3];
	// get all the base project names with that actual mode and extension
	NSArray * TPPs = [[SPC baseProjectNames] valueForKey:@"TeXProjectProperties4iTM3"];
	TPPs = [TPPs filteredArrayUsingPredicateValue:[oldTPPs iVarMode] forKey:iTM2TPDKModeKey];
	TPPs = [TPPs filteredArrayUsingPredicateValue:[oldTPPs iVarExtension] forKey:iTM2TPDKExtensionKey];
	// filter out with newVariant, case sensitive
	NSString * newVariant = [(id)[sender selectedItem] representedObject];
	NSArray * RA = [TPPs filteredArrayUsingPredicateValue:newVariant forKey:iTM2TPDKVariantKey];
	NSAssert(RA.count>0,@"Internal inconsistency, the new mode should exist!");
	// try to keep the output
	NSArray * nextRA = [RA filteredArrayUsingPredicateValue:[oldTPPs valueForKey:iTM2TPDKOutputKey] forKey:iTM2TPDKOutputKey];
	if(nextRA.count)
	{
		RA = nextRA;
	}
	NSString * newBPN = [[RA objectAtIndex:0] TeXBaseProjectName4iTM3];
	if(![[TPD baseProjectName] pathIsEqual4iTM3:newBPN])
	{
		[TPD setBaseProjectName:newBPN];
		[TPD updateChangeCount:NSChangeDone];
	}
	self.validateWindowContent4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateChooseVariant:
- (BOOL)validateChooseVariant:(NSPopUpButton *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Mar 26 08:41:36 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    id TPD = (iTM2TeXProjectDocument *)self.document;
	if([SPC isBaseProject:TPD])
	{
		return NO;
	}
//LOG4iTM3(@"sender is: %@", sender);
    if([sender isKindOfClass:[NSPopUpButton class]])
    {
		static NSString * voidTitle = nil;
		if(!voidTitle)
			voidTitle = [[sender.lastItem title] copy];
        [sender removeAllItems];
        NSDictionary * Ps = [[TPD baseProjectName] TeXProjectProperties4iTM3];
		// get all the base project names properties
		NSArray * TPPs = [[SPC baseProjectNames] valueForKey:@"TeXProjectProperties4iTM3"];
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
        NSString * variant;
        for(variant in variants)
        {
			if(variant.length)
			{
				[sender addItemWithTitle:variant];
			}
			else
			{
				[sender addItemWithTitle:NSLocalizedStringFromTableInBundle(@"Standard",iTM2TeXProjectFrontendTable,[NSBundle bundleForClass:[iTM2TeXProjectDocument class]],"")];
			}
			sender.lastItem.representedObject = variant;
        }
        variant = [Ps iVarVariant];
        NSInteger idx = [sender indexOfItemWithRepresentedObject:variant];
        if(idx == -1)
        {
            if([sender numberOfItems])
				[sender.menu addItem:[NSMenuItem separatorItem]];
            [sender addItemWithTitle:[NSString stringWithFormat:@"%@(Unknown)", variant]];
            [sender selectItem:sender.lastItem];        
            sender.lastItem.representedObject = nil;// BEWARE!!!
			[sender.lastItem setEnabled: NO];
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
		return [(NSMenuItem *)sender representedObject] != nil;
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
    id TPD = (iTM2TeXProjectDocument *)self.document;
	if([SPC isBaseProject:TPD])
	{
		return;
	}
	NSString * oldBPN = [TPD baseProjectName];
	NSDictionary * oldTPPs = [oldBPN TeXProjectProperties4iTM3];
	// get all the base project names with that actual mode and extension, variant
	NSArray * TPPs = [[SPC baseProjectNames] valueForKey:@"TeXProjectProperties4iTM3"];
	TPPs = [TPPs filteredArrayUsingPredicateValue:[oldTPPs iVarMode] forKey:iTM2TPDKModeKey];
	TPPs = [TPPs filteredArrayUsingPredicateValue:[oldTPPs iVarExtension] forKey:iTM2TPDKExtensionKey];
	TPPs = [TPPs filteredArrayUsingPredicateValue:[oldTPPs iVarVariant] forKey:iTM2TPDKVariantKey];
	// filter out with newVariant, case sensitive
	NSString * newOutput = [(id)[sender selectedItem] representedObject];
	NSArray * RA = [TPPs filteredArrayUsingPredicateValue:newOutput forKey:iTM2TPDKOutputKey];
	NSAssert(RA.count>0,@"Internal inconsistency, the new mode should exist!");
	NSString * newBPN = [[RA objectAtIndex:0] TeXBaseProjectName4iTM3];
	if(![[TPD baseProjectName] pathIsEqual4iTM3:newBPN])
	{
		[TPD setBaseProjectName:newBPN];
		[TPD updateChangeCount:NSChangeDone];
	}
	self.validateWindowContent4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateChooseOutput:
- (BOOL)validateChooseOutput:(NSPopUpButton *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Mar 26 08:41:36 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    id TPD = (iTM2TeXProjectDocument *)self.document;
	if([SPC isBaseProject:TPD])
	{
		return NO;
	}
//LOG4iTM3(@"sender is: %@", sender);
    if([sender isKindOfClass:[NSPopUpButton class]])
    {
		static NSString * voidTitle = nil;
		if(!voidTitle)
			voidTitle = [[sender.lastItem title] copy];
        [sender removeAllItems];
        NSDictionary * Ps = [[TPD baseProjectName] TeXProjectProperties4iTM3];
		// get all the base project names properties
		NSArray * TPPs = [[SPC baseProjectNames] valueForKey:@"TeXProjectProperties4iTM3"];
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
        NSString * output;
        for(output in outputs)
        {
			if(output.length)
			{
				[sender addItemWithTitle:output];
			}
			else
			{
				[sender addItemWithTitle:NSLocalizedStringFromTableInBundle(@"PDF",iTM2TeXProjectFrontendTable,[NSBundle bundleForClass:[iTM2TeXProjectDocument class]],"")];
			}
			sender.lastItem.representedObject = output;
        }
        output = [Ps iVarOutput];
        NSInteger idx = [sender indexOfItemWithRepresentedObject:output];
        if(idx == -1)
        {
            if([sender numberOfItems])
				[sender.menu addItem:[NSMenuItem separatorItem]];
            [sender addItemWithTitle:[NSString stringWithFormat:@"%@(Unknown)", output]];
            [sender selectItem:sender.lastItem];        
            sender.lastItem.representedObject = nil;// BEWARE!!!
			[sender.lastItem setEnabled: NO];
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
		return [(NSMenuItem *)sender representedObject] != nil;
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [self contextStringForKey:@"Commands Inspector:Edited Command" domain:iTM2ContextAllDomainsMask];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setEditedCommand:
- (void)setEditedCommand:(id)argument;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[self willChangeValueForKey:@"editedCommand"];
	[self takeContextValue:argument forKey:@"Commands Inspector:Edited Command" domain:iTM2ContextAllDomainsMask];
	[self didChangeValueForKey:@"editedCommand"];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  chooseEditCommand:
- (IBAction)chooseEditCommand:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Mar 26 08:41:36 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self setEditedCommand:[[sender selectedItem] representedObject]];
    self.validateWindowContent4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateChooseEditCommand:
- (BOOL)validateChooseEditCommand:(NSPopUpButton *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Mar 26 08:41:36 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
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
					sender.lastItem.representedObject = name;
				}
				[sender.menu addItem:[NSMenuItem separatorItem]];
			}
			if([sender.lastItem isSeparatorItem])
			{
				[sender.menu removeItem:sender.lastItem];
			}
        }
        NSInteger index = [sender indexOfItemWithRepresentedObject:self.editedCommand];
        if(index < 0)
        {
            [self setEditedCommand:[[[[[iTM2TeXPCommandManager orderedBuiltInCommandNames] objectEnumerator] nextObject] objectEnumerator] nextObject]];
            index = [sender indexOfItemWithRepresentedObject:self.editedCommand];
        }
        [sender selectItemAtIndex:index];
    }
    return YES;
}
#pragma mark =-=-=-=-=-=-=-=-=-=-  ACTION SCRIPTS MANAGEMENT
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  availableScriptCommands
- (NSDictionary *)availableScriptCommands;
{
	NSMutableDictionary * bins = [NSMutableDictionary dictionary];
    ICURegEx * RE = [ICURegEx regExForKey:iTM2TeXPCommandRegexKey inBundle:myBUNDLE error:NULL];
	for (NSURL * url in [NSBundle mainBundle].allURLsForSupportExecutables4iTM3) {
		if([RE matchString:url.lastPathComponent.stringByDeletingPathExtension]) {
			[bins setObject:url.path forKey:[RE substringOfCaptureGroupWithName:iTM2TeXPCommandRegexName]];
		}
	}
    RE.forget;
	return bins;
}
- (NSString *)editedScriptMode;
{
	NSString * editedCommand = self.editedCommand;
	NSString * mode = [self infoForKeyPaths:iTM2TPFECommandsKey,editedCommand,iTM2TPFEScriptModeKey,nil];
	if([mode isEqual:iTM2TPFEBaseMode])
	{
		[self setInfo:nil forKeyPaths:iTM2TPFECommandsKey,editedCommand,iTM2TPFEScriptModeKey,nil];
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSString * editedCommand = self.editedCommand;
	NSString * newMode = [(id)[sender selectedItem] representedString];
	if([newMode isEqual:iTM2TPFEBaseMode])
	{
		newMode = nil;
	}
	if([self setInfo:newMode forKeyPaths:iTM2TPFECommandsKey,editedCommand,iTM2TPFEScriptModeKey,nil])
	{
		[self setInfo:newMode forKeyPaths:iTM2TPFECommandsKey,editedCommand,iTM2TPFEEnvironmentModeKey,nil];
		[self.document updateChangeCount:NSChangeDone];
		self.validateWindowContent4iTM3;
	}
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateChooseScript:
- (BOOL)validateChooseScript:(NSPopUpButton *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Mar 26 08:41:36 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if([sender isKindOfClass:[NSPopUpButton class]])
    {
		// cleaning the menu
        [sender removeAllItems];
		// make a copy to keep the same fonts
        NSMenu * removeScriptMenu = [[sender.menu copy] autorelease]; 
        // populates with a "base" menu item
        [sender addItemWithTitle:NSLocalizedStringFromTableInBundle(@"Disabled", iTM2TeXProjectFrontendTable, myBUNDLE, "...")];
        sender.lastItem.representedObject = iTM2TPFEVoidMode;
        [sender addItemWithTitle:NSLocalizedStringFromTableInBundle(@"Base", iTM2TeXProjectFrontendTable, myBUNDLE, "...")];
        sender.lastItem.representedObject = iTM2TPFEBaseMode;
		// adding the built in scripts
		NSDictionary * commands = self.availableScriptCommands;
		NSString * commandName = nil;
		NSString * title;
		[sender.menu addItem:[NSMenuItem separatorItem]];
		if(commands.count) {
			title = NSLocalizedStringFromTableInBundle(@"Support Scripts", iTM2TeXProjectFrontendTable, myBUNDLE, "Description Forthcoming");
			[sender addItemWithTitle:title];
			sender.lastItem.representedObject = @"Disabled";
			for (commandName in [[commands allKeys] sortedArrayUsingSelector:@selector(compare:)]) {
				[sender addItemWithTitle:commandName];
				sender.lastItem.representedObject = [commands objectForKey:commandName];
				sender.lastItem.indentationLevel = 1;
			}
	//LOG4iTM3(@"THE editedCommand IS: %@", self.editedCommand);
			// This is a consistency test that should also be made before...
			[sender.menu addItem:[NSMenuItem separatorItem]];
		}
		title = NSLocalizedStringFromTableInBundle(@"Project Scripts", iTM2TeXProjectFrontendTable, myBUNDLE, "Description Forthcoming");
		[sender addItemWithTitle:title];
		sender.lastItem.representedObject = @"Disabled";
		commands = [self infoForKeyPaths:iTM2TPFECommandScriptsKey,nil];
		if(commands.count) {
			for (commandName in [[commands allKeys] sortedArrayUsingSelector:@selector(compare:)]) {
				NSString * label = [self infoForKeyPaths:iTM2TPFECommandScriptsKey,commandName,iTM2TPFELabelKey,nil];
				title = label.length? label:
					[NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"Script %@", iTM2TeXProjectFrontendTable, myBUNDLE, "Description Forthcoming"), commandName];
				[sender addItemWithTitle:title];
				sender.lastItem.representedObject = commandName;
				sender.lastItem.indentationLevel = 1;
				NSMenuItem * MI = [removeScriptMenu addItemWithTitle:title action:@selector(removeScript:) keyEquivalent:@""];
				MI.representedObject = commandName;
				MI.target = self;// MI belongs to the receivers window
			}
		}
        [sender addItemWithTitle:NSLocalizedStringFromTableInBundle(@"New", iTM2TeXProjectFrontendTable, myBUNDLE, "Description Forthcoming")];
        [sender.lastItem setAction:@selector(newScript:)];
        [sender.lastItem setTarget:self];// sender belongs to the receivers window
        if([removeScriptMenu numberOfItems])
        {
            [sender addItemWithTitle:NSLocalizedStringFromTableInBundle(@"Remove", iTM2TeXProjectFrontendTable, myBUNDLE, "Description Forthcoming")];
            [sender.lastItem setSubmenu:removeScriptMenu];
        }
//LOG4iTM3(@"CW is: %@", [CW description]);
		NSString * scriptMode = self.editedScriptMode;
        NSUInteger idx = -1;
		if(!scriptMode.length) {
			scriptMode = iTM2TPFEBaseMode;
		}
		idx = [sender indexOfItemWithRepresentedObject:scriptMode];
		if(idx != -1) {
			[sender selectItemAtIndex:idx];
		} else {
			if([removeScriptMenu numberOfItems])
				[sender.menu addItem:[NSMenuItem separatorItem]];
			[sender addItemWithTitle:NSLocalizedStringFromTableInBundle(@"Unsupported", iTM2TeXProjectFrontendTable, myBUNDLE, "Description Forthcoming")];
			title = scriptMode.stringByDeletingPathExtension;
			[sender addItemWithTitle:title];
			sender.lastItem.representedObject = scriptMode;
			[sender.lastItem setAction:@selector(noop:)];
			[sender.lastItem setTarget:self];// sender belongs to the receivers window
		}
		[sender.menu cleanSeparators4iTM3];
		return YES;
    } else if([sender isKindOfClass:[NSMenuItem class]]) {
		return ![[(NSMenuItem *)sender representedObject] isEqual:@"Disabled"];
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSArray * allActionModes = [[self infoForKeyPaths:iTM2TPFECommandScriptsKey,nil] allKeys];
    NSInteger idx = 0;
    NSString * scriptMode;
    while((scriptMode = [NSString stringWithFormat:@"%i", idx++]), [allActionModes containsObject:scriptMode]);
	[self setInfo:scriptMode forKeyPaths:iTM2TPFECommandsKey,self.editedCommand,iTM2TPFEScriptModeKey,nil];
	[self setInfo:@"" forKeyPaths:iTM2TPFECommandScriptsKey,scriptMode,iTM2TPFELabelKey,nil];
	[self.document updateChangeCount:NSChangeDone];
	self.validateWindowContent4iTM3;
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  removeScript:
- (IBAction)removeScript:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Mar 26 08:41:36 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSString * scriptMode = [(id)sender representedString];
	if([self setInfo:nil forKeyPaths:iTM2TPFECommandScriptsKey,scriptMode,nil])
	{
// remove the script reference for all the commands that used it
		NSEnumerator * E = [[self infoForKeyPaths:iTM2TPFECommandsKey, nil] keyEnumerator];
		NSString * name;
		while(name = [E nextObject])
		{
			if([scriptMode isEqual:[self infoForKeyPaths:iTM2TPFECommandsKey,name,iTM2TPFEScriptModeKey,nil]])
			{
				[self setInfo:nil forKeyPaths:iTM2TPFECommandsKey,name,iTM2TPFEScriptModeKey,nil];
			}
		}
		[self.document updateChangeCount:NSChangeDone];
		self.validateWindowContent4iTM3;
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if(![self.window attachedSheet])
    {
#warning DEBUG: Problem when cancelled, the edited status might remain despite it should not.
		iTM2TeXProjectDocument * TPD = (iTM2TeXProjectDocument *)self.document;
		NSString * scriptMode = self.editedScriptMode;
        iTM2TeXPShellScriptInspector * WC = [[[iTM2TeXPShellScriptInspector alloc]
			initWithWindowNibName: @"iTM2TeXPShellScriptInspector"] autorelease];
		iTM2InfosController * ic = [[[iTM2InfosController alloc] initWithProject:TPD atomic:NO prefixWithKeyPaths:iTM2TPFECommandScriptsKey,scriptMode,nil] autorelease];
		[WC setInfosController:ic];
		NSWindow * W = WC.window;
		if(W)
		{
			[TPD addWindowController:WC];
			[WC validateWindowContent4iTM3];
			[NSApp beginSheet: W
					modalForWindow: self.window
					modalDelegate: self
					didEndSelector: @selector(editScriptSheetDidEnd:returnCode:irrelevant:)
					contextInfo: nil];
		}
		else
		{
			LOG4iTM3(@"A window named iTM2TeXPShellScriptInspector was expected");
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if([SPC isBaseProject:self.document])
		return NO;
    return [[[self infoForKeyPaths:iTM2TPFECommandScriptsKey,nil] allKeys] containsObject:self.editedScriptMode];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  editScriptSheetDidEnd:returnCode:scriptMode:
- (void)editScriptSheetDidEnd:(NSWindow *)sheet returnCode:(NSInteger)returnCode irrelevant:(void *)unused;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [sheet orderOut:self];
    NSWindowController * WC = sheet.windowController;
    [WC.document removeWindowController:WC];
    self.validateWindowContent4iTM3;
    return;
}
#pragma mark =-=-=-=-=-=-=-=-=-=-  OPTIONS MANAGEMENT
- (NSString *)editedEnvironmentMode;
{
	NSString * editedCommand = self.editedCommand;
	NSString * mode = [self infoForKeyPaths:iTM2TPFECommandsKey,editedCommand,iTM2TPFEEnvironmentModeKey,nil];
	if([mode isEqual:iTM2TPFEBaseMode])
	{
		[self setInfo:nil forKeyPaths:iTM2TPFECommandsKey,editedCommand,iTM2TPFEEnvironmentModeKey,nil];
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
	return [self localInfoForKeyPaths:iTM2TPFECommandEnvironmentsKey,self.editedEnvironmentMode,nil]!=nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  chooseOptions:
- (IBAction)chooseOptions:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Mar 26 08:41:36 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSString * editedCommand = self.editedCommand;
	NSString * environmentMode = [(id)[sender selectedItem] representedString];
	if([environmentMode isEqual:iTM2TPFECustomMode])
	{
		[self setInfo:nil forKeyPaths:iTM2TPFECommandsKey,editedCommand,iTM2TPFEEnvironmentModeKey,nil];
		environmentMode = self.editedEnvironmentMode;
		// if there were something already customized, retrieve it
		if([self setInfo:environmentMode forKeyPaths:iTM2TPFECommandsKey,editedCommand,iTM2TPFEEnvironmentModeKey,nil])
		{
			if([self restoreCustomForKeyPaths:iTM2TPFECommandEnvironmentsKey,environmentMode,nil]
				|| [self setInfo:[NSMutableDictionary dictionary] forKeyPaths:iTM2TPFECommandEnvironmentsKey,environmentMode,nil])
			{
				NSAssert(self.isCustomEnvironmentMode,@"Custom environment mode expected");
				[self.document updateChangeCount:NSChangeDone];
				self.validateWindowContent4iTM3;
			}
		}
	}
	else if([environmentMode isEqual:iTM2TPFEBaseMode])
	{
		environmentMode = nil;
		if([self setInfo:environmentMode forKeyPaths:iTM2TPFECommandsKey,editedCommand,iTM2TPFEEnvironmentModeKey,nil])
		{
			environmentMode = self.editedEnvironmentMode;
			[self backupCustomForKeyPaths:iTM2TPFECommandEnvironmentsKey,environmentMode,nil];
			[self setInfo:nil forKeyPaths:iTM2TPFECommandEnvironmentsKey,environmentMode,nil];
			[self.document updateChangeCount:NSChangeDone];
			self.validateWindowContent4iTM3;
		}
	}
	else if([self setInfo:environmentMode forKeyPaths:iTM2TPFECommandsKey,editedCommand,iTM2TPFEEnvironmentModeKey,nil])
	{
		[self.document updateChangeCount:NSChangeDone];
		self.validateWindowContent4iTM3;
	}
//LOG4iTM3(@"CW is NOW: %@", CW);
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateChooseOptions:
- (BOOL)validateChooseOptions:(id)theSender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Mar 26 08:41:36 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSString * scriptMode = self.editedScriptMode;
    if([theSender isKindOfClass:[NSMenuItem class]])
	{
        #define sender ((NSMenuItem *)theSender)
		if([scriptMode isEqual:iTM2TPFEVoidMode]
			|| [[[self infoForKeyPaths:iTM2TPFECommandScriptsKey,nil] allKeys] containsObject:scriptMode])
		{
			return NO;
		}
		return YES;
        #undef sender
	}
    else if([theSender isKindOfClass:[NSPopUpButton class]])
	{
		#define sender ((NSPopUpButton *)theSender)
		[sender removeAllItems];
		NSString * editedCommand = self.editedCommand;
		NSString * environmentMode = self.editedEnvironmentMode;
//LOG4iTM3(@"editedCommand is: %@", editedCommand);
		if([[editedCommand lowercaseString] isEqualToString:@"special"]
			|| [scriptMode isEqualToString:iTM2TPFEVoidMode]
				|| [[[self infoForKeyPaths:iTM2TPFECommandScriptsKey,nil] allKeys] containsObject:scriptMode])
		{
			// No options for the special command
			[sender addItemWithTitle:NSLocalizedStringFromTableInBundle(@"No options", iTM2TeXProjectFrontendTable, myBUNDLE, "...")];
			sender.lastItem.representedObject = iTM2TPFEVoidMode;
			[sender selectItem:sender.lastItem];
			return NO;
		}
		// for the others, only Void, Base and Custom (=editedCommand)
		// populates with a "base" menu item
		if([self localInfoForKeyPaths:iTM2TPFECommandsKey,self.editedCommand,nil])
		{
			[sender addItemWithTitle:NSLocalizedStringFromTableInBundle(@"No options", iTM2TeXProjectFrontendTable, myBUNDLE, "...")];
			sender.lastItem.representedObject = iTM2TPFEVoidMode;
		}
		[sender addItemWithTitle:NSLocalizedStringFromTableInBundle(@"Base", iTM2TeXProjectFrontendTable, myBUNDLE, "...")];
		sender.lastItem.representedObject = iTM2TPFEBaseMode;
		[sender addItemWithTitle:NSLocalizedStringFromTableInBundle(@"Custom", iTM2TeXProjectFrontendTable, myBUNDLE, "...")];
		sender.lastItem.representedObject = iTM2TPFECustomMode;
		if([environmentMode isEqual:iTM2TPFEVoidMode])
		{
			[sender selectItemAtIndex:0];
		}
		else if(self.isCustomEnvironmentMode)
		{
			[sender selectItemAtIndex:[sender indexOfItemWithRepresentedObject:iTM2TPFECustomMode]];// index is 0 or 1
		}
		else
		{
			[sender selectItemAtIndex:[sender indexOfItemWithRepresentedObject:iTM2TPFEBaseMode]];// index is 1 or 2
		}
		return YES;
        #undef sender
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if(![self.window attachedSheet])
    {
		NSString * environmentMode = self.editedEnvironmentMode;
		Class C = [iTM2TeXPCommandInspector classForMode:environmentMode];
        iTM2TeXPCommandInspector * WC = [[[C alloc] initWithWindowNibName:[C windowNibName]] autorelease];
        iTM2TeXProjectDocument * TPD = (iTM2TeXProjectDocument *)self.document;
		[TPD addWindowController:WC];// now WC.document == TPD, and WC is retained, the WC document is the project
		NSWindow * W = WC.window;// may validate the window content as side effect
        if(W)
        {
//LOG4iTM3(@"The command inspector is: %@", WC);
			if(iTM2DebugEnabled>100)
			{
				LOG4iTM3(@"Starting to edit environment mode: %@", environmentMode);
			}
			[W setExcludedFromWindowsMenu:YES];
			[W validateContent4iTM3];
//LOG4iTM3(@"BEFORE validateWindowContent4iTM3, WC.document is: %@", WC.document);
            [NSApp beginSheet: W
                    modalForWindow: self.window
                    modalDelegate: self
                    didEndSelector: @selector(editOptionsSheetDidEnd:returnCode:irrelevant:)
                    contextInfo: nil];
        }
        else
        {
            NSLog(@"Could not find a class for: %@", environmentMode);
			[TPD removeWindowController:WC];// now WC.document == TPD, and WC is retained
        }
    }
    else
        iTM2Beep();
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  editOptionsSheetDidEnd:returnCode:irrelevant:
- (void)editOptionsSheetDidEnd:(NSWindow *)sheet returnCode:(NSInteger)returnCode irrelevant:(void *)unused;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [sheet orderOut:self];
    NSWindowController * WC = sheet.windowController;
//LOG4iTM3(@"return code: %i", returnCode);
    [WC.document removeWindowController:WC];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateEditOptions:
- (BOOL)validateEditOptions:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Mar 26 08:41:36 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if([SPC isBaseProject:self.document]
		|| [[self.editedCommand lowercaseString] isEqualToString:@"special"])
		return NO;
	return self.isCustomEnvironmentMode;
}
#pragma mark =-=-=-=-=-  DEFAULT
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  defaultCommand:
- (IBAction)defaultCommand:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Mar 26 08:41:36 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	BOOL yorn = [self setInfo:nil forKeyPaths:iTM2TPFECommandsKey,self.editedCommand,nil];
	if([self setInfo:nil forKeyPaths:iTM2TPFECommandEnvironmentsKey,self.editedCommand,nil] || yorn)
	{
		[self.document updateChangeCount:NSChangeDone];
	}
    self.validateWindowContent4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateDefaultCommand:
- (BOOL)validateDefaultCommand:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Mar 26 08:41:36 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	// turn to default if either the script mode is not base
	// or the environment mode is customized
    return ([self localInfoForKeyPaths:iTM2TPFECommandsKey,self.editedCommand,nil] != nil)
		|| self.isCustomEnvironmentMode;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  showHelp:
- (IBAction)showHelp:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return iTM2TeXProjectExtendedInspectorVariant;
}
@end

@interface iTM2TeXPCommandPerformer(PRIVATE)
+ (NSInteger)_commandLevel;
+ (NSInteger)_commandGroup;
@end

NSString * const iTM2TPFEDefaultEnvironmentKey = @"DefaultEnvironment";
//#import <iTM2Foundation/iTM2Runtime.h>
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [super initialize];
	if(!_iTM2TeXPCommandInspectors)
	{
		_iTM2TeXPCommandInspectors = [[NSMutableDictionary dictionary] retain];
//LOG4iTM3(@"_iTM2TeXPCommandInspectors are: %@", _iTM2TeXPCommandInspectors);
	}
    if([_iTM2TeXPCommandInspectors valueForKey:self.commandName] != self)
    {
        [_iTM2TeXPCommandInspectors setValue:self forKey:self.commandName];
		if(iTM2DebugEnabled)
		{
			LOG4iTM3(@"Registering command inspector %@ for action key: %@\n%@", NSStringFromClass(self), self.commandName, _iTM2TeXPCommandInspectors);
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
    Class C = [_iTM2TeXPCommandInspectors valueForKey:action];
    if(!C)
	{
		LOG4iTM3(@"No command inspector for action: %@\nwithin %@", action, _iTM2TeXPCommandInspectors);
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
	ICURegEx * RE = [[[ICURegEx alloc] initWithSearchPattern:@"iTM2TeXP(.*)Inspector" options:0 error:nil] autorelease];
	NSString * result = [RE matchString:NSStringFromClass(self)]? [RE substringOfCaptureGroupAtIndex:1]:@"";
    RE.forget;
    return result;
}
- (NSString *) infosKeyPathPrefix;
{
	return [iTM2TPFECommandsKey stringByAppendingPathExtension:[self.class commandName]];
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
	// saving the Compile environment
	[self saveChangesForKeyPaths:iTM2TPFECommandsKey,[self.class commandName],nil];
    [super OK:sender];
//END4iTM3;
    return;
}
@end

//#import <iTM2Foundation/iTM2BundleKit.h>
//#import <iTM2Foundation/iTM2Runtime.h>
//#import <iTM2Foundation/iTM2NotificationKit.h>

NSString * const TWSShellEnvironmentFrontKey = @"TWSFront";
NSString * const TWSShellEnvironmentProjectKey = @"TWSProject";

@implementation iTM2MainInstaller(TeXPCommandManager)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2TeXPCommandManager
+ (void)iTM2TeXPCommandManagerCompleteInstallation4iTM3;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [iTM2TeXPCommandManager setupTeXMenu];
//END4iTM3;
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [super initialize];
	[INC removeObserver:self];
	[INC addObserver:self selector:@selector(bundleDidLoadNotified:) name:iTM2BundleDidLoadNotification object:nil];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  bundleDidLoadNotified:
+ (void)bundleDidLoadNotified:(NSNotification *)notification;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	self.setupTeXMenu;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setupTeXMenu
+ (void)setupTeXMenu;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(_setupTeXMenu) object:nil];
	[self performSelector:@selector(_setupTeXMenu) withObject:nil afterDelay:0];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  _setupTeXMenu
+ (void)_setupTeXMenu;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
#if __iTM2_DEVELOPMENT__
#warning *** BUG TRACKING: OTHER TeX menu management
#pragma mark BUG TRACKING
	id MI = (NSMenuItem *)[[NSApp mainMenu] deepItemWithAction4iTM3:@selector(projectCurrent:)];
	if(!MI)
	{
		LOG4iTM3(@"NO TEX MENU: please report possible bug");
		return;
	}
	NSMenu * M = MI.menu;
	// removing all the menu items with command responders as represented objects
	// finding the first menu item like that
	NSInteger index = [M indexOfItem:MI] + 1;
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
//LOG4iTM3(@"FIRST TIME? NO MENU ITEM WITH A iTM2TeXPCommandPerformer INSTANCE REPRESENTED OBJECT");
	index = [M indexOfItem:MI] + 1;
	// inserting the stuff
	insert:;
//LOG4iTM3(@"THE MENU IS NOW: %@", M);
	NSEnumerator * E  = [self.orderedBuiltInCommandNames objectEnumerator];
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
			Class performer = [self commandPerformerForName:name];
			SEL action = @selector(performCommand:);
			if([performer respondsToSelector:action])
			{
				NSMenuItem * mi = [[[NSMenuItem alloc] initWithTitle:[[performer class] localizedNameForName:name]
						action: action
							keyEquivalent: [[performer class] keyEquivalentForName:name]] autorelease];
				[mi setKeyEquivalentModifierMask:[[performer class] keyEquivalentModifierMaskForName:name]];
				mi.representedObject = performer;
				mi.target = performer;// performer is expected to last forever
				if([[mi keyEquivalent] length])
				{
					NSMenuItem * mite;
					NSMenu * rootMenu4iTM3 = [M rootMenu4iTM3];
					while(mite = [rootMenu4iTM3 deepItemWithKeyEquivalent4iTM3:[mi keyEquivalent]
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
	NSMenuItem * MI = (NSMenuItem *)[[NSApp mainMenu] deepItemWithAction4iTM3:@selector(projectCurrent:)];
	if(!MI)
	{
		LOG4iTM3(@"NO TEX MENU: please report possible bug");
		return;
	}
	NSMenu * M = MI.menu;
	// removing all the menu items with command responders as represented objects
	// finding the first menu item like that
	NSInteger index = [M indexOfItem:MI] + 1;
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
//LOG4iTM3(@"FIRST TIME? NO MENU ITEM WITH A iTM2TeXPCommandPerformer INSTANCE REPRESENTED OBJECT");
	index = [M indexOfItem:MI] + 1;
	// inserting the stuff
	insert:;
//LOG4iTM3(@"THE MENU IS NOW: %@", M);
	NSEnumerator * E  = [self.orderedBuiltInCommandNames objectEnumerator];
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
			Class performer = [self commandPerformerForName:name];
			SEL action = @selector(performCommand:);
			if([performer respondsToSelector:action])
			{
				NSMenuItem * mi = [[[NSMenuItem alloc] initWithTitle:[[performer class] localizedNameForName:name]
						action: action keyEquivalent: [[performer class] keyEquivalentForName:name]] autorelease];
				[mi setKeyEquivalentModifierMask:[[performer class] keyEquivalentModifierMaskForName:name]];
				mi.representedObject = performer;
				mi.target = performer;// performer is expected to last forever
				// before we insert the menu item, we try to remove the items with the same keyEquivalent and modifier mask
				if([[mi keyEquivalent] length])
				{
					NSMenuItem * mite;
					NSMenu * rootMenu4iTM3 = [M rootMenu4iTM3];
					while(mite = [rootMenu4iTM3 deepItemWithKeyEquivalent4iTM3:[mi keyEquivalent]
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
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  builtInCommandNames
+ (NSArray *)builtInCommandNames;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	static NSInteger oldNumberOfClasses = 0;
	NSInteger newNumberOfClasses = [iTM2Runtime numberOfClasses];
    if(oldNumberOfClasses != newNumberOfClasses)
	{
		_iTM2TeXPBuiltInCommandNames = nil;
		NSMutableSet * set = [NSMutableSet set];
		NSPointerArray * PA = [iTM2Runtime subclassReferencesOfClass:[iTM2TeXPCommandPerformer class]];
		NSUInteger i = PA.count;
		while(i--)
		{
			Class C = (Class)[PA pointerAtIndex:i];
			if([C commandLevel])
			{
				[set addObject:[C commandName]];
			}
		}
		_iTM2TeXPBuiltInCommandNames = [[set allObjects] retain];
		oldNumberOfClasses = newNumberOfClasses;
		self.setupTeXMenu;
	}
//LOG4iTM3(@"_iTM2TeXPBuiltInCommandNames are: %@", _iTM2TeXPBuiltInCommandNames);
//END4iTM3;
    return _iTM2TeXPBuiltInCommandNames;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  orderedBuiltInCommandNames
+ (NSArray *)orderedBuiltInCommandNames;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSMutableDictionary * MD = [NSMutableDictionary dictionary];// NSMapTable here ?
	NSNumber * K;
	NSPointerArray * PA = [iTM2Runtime subclassReferencesOfClass:[iTM2TeXPCommandPerformer class]];
	NSUInteger i = PA.count;
	while(i--)
	{
		Class C = (Class)[PA pointerAtIndex:i];
		K = [NSNumber numberWithInteger:[C commandGroup]];
		NSMutableDictionary * md = [MD objectForKey:K];
		if(!md)
		{
			[MD setObject:[NSMutableDictionary dictionary] forKey:K];
			md = [MD objectForKey:K];
		}
		if([C commandLevel])
			[md setObject:[C commandName] forKey:[NSNumber numberWithInteger:[C commandLevel]]];
	}
	NSMutableArray * MRA = [NSMutableArray array];
	for(K in [[MD allKeys] sortedArrayUsingSelector:@selector(compare:)])
	{
		NSMutableArray * mra = [NSMutableArray array];
		NSDictionary * D = [MD objectForKey:K];
		for(NSNumber * k in [[D allKeys] sortedArrayUsingSelector:@selector(compare:)])
			[mra addObject:[D objectForKey:k]];
		if(mra.count)
			[MRA addObject:mra];
	}
	if(iTM2DebugEnabled)
	{
		LOG4iTM3(@"ORDERED BUILT IN COMMAND NAMES are: %@", MRA);
	}
    return MRA;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  commandPerformerForName:
+ (Class)commandPerformerForName:(NSString *)name;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if(!name.length)
		return nil;
	Class result = NSClassFromString([NSString stringWithFormat:@"iTM2TeXP%@Performer", name]);
	if(!result)
	{
		NSPointerArray * PA = [iTM2Runtime subclassReferencesOfClass:[iTM2TeXPCommandPerformer class]];
		NSUInteger i = PA.count;
		while(i--)
		{
			result = [PA pointerAtIndex:i];
			if([name isEqualToString:[result commandName]])
				return result;
		}
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[super initialize];// false? see http://lists.apple.com/archives/cocoa-dev//2005/Sep/msg00068.html
	NSMutableDictionary * MD = [NSMutableDictionary dictionary];
	for (NSURL * url in [[NSBundle mainBundle] allURLsForResource4iTM3:@"EnvironmentVariables" withExtension:@"plist"].reverseObjectEnumerator) {
		NSDictionary * D = [NSDictionary dictionaryWithContentsOfURL:url];
		[MD addEntriesFromDictionary:D];
	}
	[SUD registerDefaults:[NSDictionary dictionaryWithObject:MD forKey:iTM2EnvironmentVariablesKey]];
	[SUD registerDefaults:[NSDictionary dictionaryWithObject:MD forKey:iTM2FactoryEnvironmentVariablesKey]];
	//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  commandName
+ (NSString *)commandName;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	const char * _classname = [NSStringFromClass(self) cStringUsingEncoding:NSASCIIStringEncoding];
	if(!strncmp(_classname, "iTM2TeXP", strlen("iTM2TeXP")))
	{
		NSInteger n = strlen(_classname);
		if(n>strlen("iTM2TeXPPerformer"))
		{
			if(!strncmp(_classname + n - strlen("Performer"), "Performer", strlen("Performer")))
			{
				return [[[NSString alloc] initWithBytes:_classname+strlen("iTM2TeXP") length:n-strlen("iTM2TeXPPerformer") encoding:NSASCIIStringEncoding] autorelease];
			}
		}
	}
//END4iTM3;
    return @"";
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  localizedNameForName:
+ (NSString *)localizedNameForName:(NSString *)name;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return NSLocalizedStringFromTableInBundle(name, iTM2TeXPCommandTableName, myBUNDLE, "");
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  menuItemTitleForProject:
+ (NSString *)menuItemTitleForProject:(id)project;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return [self localizedNameForName:self.commandName];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  commandLevel
+ (NSInteger)commandLevel;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return 0;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  _commandLevel
+ (NSInteger)_commandLevel;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSString * S = NSLocalizedStringWithDefaultValue([self.commandName stringByAppendingPathExtension:@"level"],
				iTM2TeXPCommandTableName, myBUNDLE, ([NSString stringWithFormat:@"%i", self.commandLevel]), "");
//END4iTM3;
    return [S integerValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  commandGroup
+ (NSInteger)commandGroup;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return 0;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  _commandGroup
+ (NSInteger)_commandGroup;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSString * S = NSLocalizedStringWithDefaultValue([self.commandName stringByAppendingPathExtension:@"group"],
				iTM2TeXPCommandTableName, myBUNDLE, ([NSString stringWithFormat:@"%i", self.commandGroup]), "");
//END4iTM3;
    return [S integerValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  keyEquivalentForName:
+ (NSString *)keyEquivalentForName:(NSString *)name;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSString * result = NSLocalizedStringFromTableInBundle([name stringByAppendingPathExtension:@"keyEquivalent"],
				iTM2TeXPCommandTableName, myBUNDLE, "");
    return result.length != 1? @"":[result substringWithRange:iTM3MakeRange(0, 1)];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  keyEquivalentModifierMaskForName;
+ (NSUInteger)keyEquivalentModifierMaskForName:(NSString *)name;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSString * stringResult = NSLocalizedStringWithDefaultValue([name stringByAppendingPathExtension:@"modifierMask"],
				iTM2TeXPCommandTableName, myBUNDLE, @"NONE", "");
	NSUInteger result = 0;
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
	LOG4iTM3(@"FAILED: MISSING IMPLEMENTATION");
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  performCommand:
+ (IBAction)performCommand:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[self performCommandForProject:[SPC requiredTeXProjectForSource:nil]];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  canPerformCommandForProject:
+ (BOOL)canPerformCommandForProject:(iTM2TeXProjectDocument *)project;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return [[SDC currentDocument] isKindOfClass:[iTM2Document class]];//project != nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  performCommandForProject:
+ (void)performCommandForProject:(iTM2TeXProjectDocument *)project;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//LOG4iTM3(@"I HAVE RECEIVED THE ORDER TO START");
#if 1
	if(self.mustSaveProjectDocumentsBefore)
	{
		[project saveDocument:nil];
//LOG4iTM3(@"Documents are saved for the project command.");
//		[project writeSafelyToURL:project.fileURL ofType:[project fileType] forSaveOperation:NSSaveOperation error:nil];
	}
	[self doPerformCommandForProject:project];
#else
	if(self.mustSaveProjectDocumentsBefore)
		[project saveAllProjectDocumentsWithDelegate: self
			didSaveAllSelector: @selector(project:didSaveAllProjectDocuments:contextInfo:)
				contextInfo: nil];
	else
		[self doPerformCommandForProject:project];
#endif
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  project:didSaveAllProjectDocuments:contextInfo:
+ (void)project:(id)project didSaveAllProjectDocuments:(BOOL)flag contextInfo:(void *)contextInfo;
/*"Call back must have the following signature:
- (void)documentController:(if)DC didSaveAll:(BOOL)flag contextInfo:(void *)contextInfo;
Version History: jlaurens AT users DOT sourceforge DOT net (12/07/2001)
- < 1.1: 03/10/2002
To Do List: to be improved...
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[self doPerformCommandForProject:project];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  doPerformCommandForProject:
+ (void)doPerformCommandForProject:(iTM2TeXProjectDocument *)project;
/*"Call back must have the following signature:
- (void)documentController:(if)DC didSaveAll:(BOOL)flag contextInfo:(void *)contextInfo;
Version History: jlaurens AT users DOT sourceforge DOT net (12/07/2001)
- < 1.1: 03/10/2002
To Do List: to be improved...
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if(!project)
		return;
	static NSString * Launch4iTM3 = nil;
	if(!Launch4iTM3)
	{
		Launch4iTM3 = [@"bin" stringByAppendingPathComponent:@"Launch4iTM3.rb"];
		Launch4iTM3 = [[[iTM2TeXPCommandPerformer classBundle4iTM3] pathForAuxiliaryExecutable:Launch4iTM3] copy];// statically retained!
		if(![DFM isExecutableFileAtPath:Launch4iTM3])
		{
			LOG4iTM3(@"ERROR: THERE IS A BAD PROBLEM: Launch4iTM3 is not executable or missing... REPORT BUG 1!!!");
			return;
		}
	}
	NSString * commandName = self.commandName;
    if(project)
	{
		iTM2TaskController * TC = [project taskController];
#warning DEBUGGGGG: add a SUD default here, related to hidden and silent from the terminal window
		[project takeContextValue:commandName forKey:@"iTM2TeXProjectLastCommandName" domain:iTM2ContextAllDomainsMask];
		[project showTerminalInBackGroundIfNeeded:self];
		if(iTM2DebugEnabled>100)
		{
			LOG4iTM3(@"/\\/\\/\\/\\  performing action name: %@ for project: %@", commandName, project.fileURL);
		}
		NSString * localizedCommand = [self localizedNameForName:commandName];

		NSString * status = [NSString stringWithFormat:
			NSLocalizedStringFromTableInBundle(
				@"Performing action %@ for %@ of project %@...",
					iTM2TeXProjectFrontendTable,
						self.classBundle4iTM3, nil),
							localizedCommand,
								[project nameForFileKey:[project masterFileKey]],
									[project projectName]];
		[self postNotificationWithStatus4iTM3:status];
//        [project saveProjectDocuments:self]; this is already done if necessary
//LOG4iTM3(@"/\\/\\/\\/\\  1");
        iTM2TaskWrapper * TW = [[[iTM2TaskWrapper alloc] init] autorelease];
//LOG4iTM3(@"/\\/\\/\\/\\  2");
		[TW setLaunchURL:[NSURL fileURLWithPath:Launch4iTM3]];
//LOG4iTM3(@"/\\/\\/\\/\\  3");
		NSDictionary * D = [SUD dictionaryForKey:iTM2EnvironmentVariablesKey];
		[TW replaceEnvironment:D];
//LOG4iTM3(@"[project commandEnvironmentDictionary] is: %@", [project commandEnvironmentDictionary]);
//LOG4iTM3(@"[TW environment] is: %@", [TW environment]);
//LOG4iTM3(@"[TW environment] is: %@", [TW environment]);
		NSString * currentDirectory = [[TW environment] objectForKey:TWSShellEnvironmentProjectKey];
		currentDirectory = currentDirectory.stringByDeletingLastPathComponent;
        [TW setCurrentDirectoryPath:(currentDirectory?:@"")];
		[TW setEnvironmentString:[Launch4iTM3.stringByDeletingLastPathComponent stringByAppendingPathComponent:@"Gobble4iTM3"] forKey:@"CMD_Gobble4iTM3"];
		if([TC isMute])
		{
			[TW setEnvironmentString:[Launch4iTM3.stringByDeletingLastPathComponent stringByAppendingPathComponent:@"Gobble4iTM3"] forKey:@"CMD_Notify4iTM3"];
		}
		else
		{
			[TW setEnvironmentString:iTeXMac2 forKey:@"CMD_Notify4iTM3"];
		}
//		[TW setEnvironmentString:[Launch4iTM3.stringByDeletingLastPathComponent stringByAppendingPathComponent:@"Notify4iTM3"] forKey:@"CMD_Notify4iTM3"];
        [TW addArgument:@"-a"];
        [TW addArgument:commandName];
        [TW addArgument:@"-p"];
        [TW addArgument:project.fileURL.path];
        [TW addArgument:@"-m"];
 		[TW addArgument:[project masterFileKey]];
		[TW setEnvironmentString:[[NSURL factoryURL4iTM3] path] forKey:@"Faraway_Projects_Directory4iTM3"];
		[TW setEnvironmentString:[[[NSBundle mainBundle] temporaryBaseProjectsDirectoryURL4iTM3] path] forKey:@"Base_Projects_Directory4iTM3"];
		[TW setEnvironmentString:[project getTeXMFProgramsPath] forKey:@"PATH_TeX_Programs4iTM3"];
		[TW setEnvironmentString:[project getOtherProgramsPath] forKey:@"PATH_Other_Programs4iTM3"];
		[TW setEnvironmentString:[project getCompletePATHPrefix] forKey:@"PATH_Prefix4iTM3"];
		[TW setEnvironmentString:[project getCompletePATHSuffix] forKey:@"PATH_Suffix4iTM3"];
		[TW setEnvironmentString:[project getCompleteTEXMFOUTPUT] forKey:@"TEXMFOUTPUT4iTM3"];
		[TW setEnvironmentString:[[NSNumber numberWithInteger:iTM2DebugEnabled] description] forKey:@"Debug4iTM3"];
 		if([project getPATHUsesLoginShell])
		{
			[TW setEnvironmentString:@"YES" forKey:@"PATH_UsesLoginShell4iTM3"];// not yet used?
		}
//LOG4iTM3(@"component is: %@", component);
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[userInfo autorelease];
	if(iTM2DebugEnabled>100)
    {
        LOG4iTM3(@"Command %@ performed. Default implementation should be overriden", self.commandName);
    }
	userInfo = nil;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validatePerformCommand:
+ (BOOL)validatePerformCommand:(NSMenuItem *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    iTM2TeXProjectDocument * TPD = [SPC TeXProjectForSource:sender]?:[SPC currentTeXProject];
	[sender setTitle:[self menuItemTitleForProject:TPD]];
	if([SPC isBaseProject:TPD])
		return NO;
	// selector  names like projectXXXXX: are catched here
	NSString * lastCommandName = [TPD contextValueForKey:@"iTM2TeXProjectLastCommandName" domain:iTM2ContextAllDomainsMask];
	NSString * commandName = self.commandName;
	sender.state = ([lastCommandName isEqualToString:commandName]?NSMixedState:NSOffState);
	NSImage * I = [NSImage imageNamed:@"iTeXMac2Mini"];
	if(!I)
	{
		sender.state = NSMixedState;
		NSImage * I = [NSImage cachedImageNamed4iTM3:@"iTM2Gear"];
		[sender setMixedStateImage:I];
	}
	[sender setMixedStateImage:I];// this does not work yet, may be in leopard...
//LOG4iTM3(@"I: %@, MSI: %@", I, [sender mixedStateImage]);
	NSString * scriptMode = [TPD infoForKeyPaths:iTM2TPFECommandsKey,commandName,iTM2TPFEScriptModeKey,nil];
	if([scriptMode isEqualToString:iTM2TPFEVoidMode])
		return NO;
	if([scriptMode isEqual:iTM2TPFEBaseMode])
	{
		[TPD setInfo:nil forKeyPaths:iTM2TPFECommandsKey,commandName,iTM2TPFEScriptModeKey,nil];
		scriptMode = [TPD infoForKeyPaths:iTM2TPFECommandsKey,commandName,iTM2TPFEScriptModeKey,nil];
		if([scriptMode isEqual:iTM2TPFEBaseMode])
		{
			scriptMode = nil;
		}
		return YES;
	}
//LOG4iTM3(@"commandName is: %@, scriptMode is: %@", commandName, scriptMode);
	else if(scriptMode.length)
		return [TPD infoForKeyPaths:iTM2TPFECommandScriptsKey,scriptMode,nil] != nil;
	else
		return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= mustSaveProjectDocumentsBefore
+ (BOOL)mustSaveProjectDocumentsBefore;
/*"Sets up the riht file objects. The extension should be set by the one who will fill up a task environemnt.
Version history: jlaurens AT users DOT sourceforge DOT net
- Thu Oct 28 14:05:13 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
 //END4iTM3;
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
		return result;
	}
	return self = [super init];
}
@end
