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

@implementation iTM2TeXPCommandsWindow
@end

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
	NSImage * I = [NSImage imageNamed:@"iTM2:showCurrentProjectSettings(small)"];
	if(I)
	{
		return I;
	}
	I = [[NSImage imageNamed:@"iTM2:showCurrentProjectSettings"] copy];
	[I setScalesWhenResized:YES];
	[I setSize:NSMakeSize(16,16)];
	[I setName:@"iTM2:showCurrentProjectSettings(small)"];
    return I;
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateWindowContent
- (BOOL)validateWindowContent;
/*"Before calling the inherited method, update the list of available projects.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [IMPLEMENTATION takeMetaValue:[SPC TeXProjectsProperties] forKey:@"_TPPs"];// TeX Projects Properties
//iTM2_LOG(@"MD: %@", MD);
    return [super validateWindowContent];
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
	[(id)[self document] setWasNotModified:NO];
	[[self document] saveDocument:self];
    [[self window] orderOut:self];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  cancel:
- (IBAction)cancel:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self restoreModel];
	[self setDocumentEdited:NO];
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
#pragma mark =-=-=-=-=-=-=-=-=-=-  Backup/Cancel
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  doCommandCompleteBackupModel
- (void)doCommandCompleteBackupModel;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    id TPD = (iTM2TeXProjectDocument *)[self document];
	if(TPD)
	{
//iTM2_LOG(@"TPD is: %@", TPD);
//iTM2_LOG(@"[TPD baseProjectName] is: %@", [TPD baseProjectName]);
//iTM2_LOG(@"[TPD commandScripts] is: %@", [TPD commandScripts]);
//iTM2_LOG(@"[TPD commandEnvironments] is: %@", [TPD commandEnvironments]);
		[self takeModelBackup:[TPD baseProjectName] forKey:@"base project name"];
		[self takeModelBackup:[[[TPD commandScripts] copy] autorelease] forKey:iTM2TPFECommandScriptsKey];
		[self takeModelBackup:[[[TPD commandEnvironments] copy] autorelease] forKey:iTM2TPFECommandEnvironmentsKey];
	}
	else
	{
		iTM2_LOG(@"NO PROJECT TO BACKUP???");
	}
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  doCommandCompleteRestoreModel
- (void)doCommandCompleteRestoreModel;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id newBPN = [self modelBackupForKey:@"base project name"];
    id TPD = (iTM2TeXProjectDocument *)[self document];
    if(![[TPD baseProjectName] isEqualToString:newBPN])
        [TPD setBaseProjectName:newBPN];
	[TPD setCommandWrappers:nil];// the command wrappers will be recreated from the correct model
	NSDictionary * newD = [self modelBackupForKey:iTM2TPFECommandEnvironmentsKey];
	if(newD)
	{
		NSDictionary * D = [TPD commandEnvironments];
		NSEnumerator * E = [D keyEnumerator];
		NSString * commandName = nil;
		while(commandName = [E nextObject])
		{
			[TPD takeEnvironment:nil forCommandMode:commandName];
		}
		E = [newD keyEnumerator];
		while(commandName = [E nextObject])
		{
			[TPD takeEnvironment:[newD objectForKey:commandName] forCommandMode:commandName];
		}
	}
	else
	{
		iTM2_LOG(@"NOTHING TO RESTORE, VERY BAD!!!");
	}
	newD = [self modelBackupForKey:iTM2TPFECommandScriptsKey];
	if(newD)
	{
		NSDictionary * D = [TPD commandEnvironments];
		NSEnumerator * E = [D keyEnumerator];
		NSString * commandName;
		while(commandName = [E nextObject])
		{
			[TPD takeScriptDescriptor:nil forCommandMode:commandName];
		}
		E = [newD keyEnumerator];
		while(commandName = [E nextObject])
		{
			[TPD takeScriptDescriptor:[newD objectForKey:commandName] forCommandMode:commandName];
		}
	}
	else
	{
		iTM2_LOG(@"NOTHING TO RESTORE, VERY BAD!!!");
	}
	newD = [self modelBackupForKey:iTM2TPFECommandScriptsKey];
    return;
}
#pragma mark =-=-=-=-=-  BASE PROJECT
#if 1
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
    NSString * mode = [(id)[sender selectedItem] representedString];
    if([mode isEqualToString:[[[[TPD baseProjectName] TeXProjectProperties] iVarMode] lowercaseString]])
        return;
    NSDictionary * TPPs = [IMPLEMENTATION metaValueForKey:@"_TPPs"];// TeX Projects Properties...
    NSEnumerator * E = [TPPs keyEnumerator];
    NSDictionary * keyD;
    NSString * newBPN = @"";
    NSString * shortestName = @"";
    NSString * pdf = [iTM2TPFEPDFOutput lowercaseString];
    while(keyD = [E nextObject])
        if([[keyD iVarMode] isEqualToString:mode])
        {
            if([[keyD iVarVariant] isEqualToString:@""]
                && [[keyD iVarOutput] isEqualToString:pdf])
            {
                newBPN = [[TPPs objectForKey:keyD] iVarName];
                goto tahaa;
            }
            shortestName = [[TPPs objectForKey:keyD] iVarName];
            break;
        }
    while(keyD = [E nextObject])
        if([[keyD iVarMode] isEqualToString:mode])
        {
            if([[keyD iVarVariant] isEqualToString:@""]
                && [[keyD iVarOutput] isEqualToString:pdf])
            {
                newBPN = [[TPPs objectForKey:keyD] iVarName];
                goto tahaa;
            }
            NSString * varName = [[TPPs objectForKey:keyD] iVarName];
            if([varName length] < [shortestName length])
                shortestName = varName;
        }
    newBPN = shortestName;
    tahaa:
    if(![[TPD baseProjectName] pathIsEqual:newBPN])
    {
        [TPD setBaseProjectName:newBPN];
        [TPD updateChangeCount:NSChangeDone];
    }
    [self validateWindowContent];
    return;
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
//iTM2_LOG(@"sender is: %@", sender);
    id TPD = (iTM2TeXProjectDocument *)[self document];
    if([sender isKindOfClass:[NSPopUpButton class]])
    {
		static NSString * noModeTitle = nil;
		if(!noModeTitle)
			noModeTitle = [[[sender lastItem] title] copy];
        [sender removeAllItems];
		if(![[TPD baseProjectName] length])
		{
			[sender addItemWithTitle:noModeTitle];
			return NO;
		}
        NSMutableDictionary * MD = [NSMutableDictionary dictionary];
        NSDictionary * TPPs = [IMPLEMENTATION metaValueForKey:@"_TPPs"];
        NSEnumerator * E = [TPPs keyEnumerator];
        NSDictionary * D;
        while(D = [E nextObject])
        {
            [MD takeValue:[[[TPPs objectForKey:D] valueForKey:iTM2TeXPCommandPropertiesKey] iVarMode]
                forKey: [D iVarMode]];
        }
            // the key is lowercase!!! the value need not
        E = [[[MD allKeys] sortedArrayUsingSelector:@selector(compare:)] objectEnumerator];
        NSString * k;
        while(k = [E nextObject])
        {
            [sender addItemWithTitle:[MD valueForKey:k]];
            [[sender lastItem] setRepresentedObject:k];// the lowercase string
        }
        NSDictionary * Ps = [[TPD baseProjectName] TeXProjectProperties];
//iTM2_LOG(@"Ps are: %@ (from %@)", Ps, TPD);
        NSString * mode = [Ps iVarMode];
        int idx = [sender indexOfItemWithRepresentedObject:[mode lowercaseString]];
        if(idx == -1)
        {
            if([sender numberOfItems])
				[[sender menu] addItem:[NSMenuItem separatorItem]];
            [sender addItemWithTitle:[NSString stringWithFormat:@"%@(Unknown)", mode]];
            [sender selectItem:[sender lastItem]];        
            [[sender lastItem] setRepresentedObject:nil];// BEWARE!!!
        }
        else
        {
            [sender selectItemAtIndex:idx];
        }
#if 0
		idx = [sender numberOfItems];
		while(idx--)
		{
			iTM2_LOG(@"SELECTOR IS: %@", NSStringFromSelector([[sender itemAtIndex:idx] action]));
		}
#endif
		if([sender numberOfItems] < 2)
			return NO;
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
    NSString * variant = [[(id)[sender selectedItem] representedString] lowercaseString];
//iTM2_LOG(@"variant chosen is: %@", variant);
    if([variant isEqualToString:iTM2ProjectDefaultsKey])
        variant = @"";
    NSDictionary * oldTPPs = [[TPD baseProjectName] TeXProjectProperties];
    if([variant isEqualToString:[[oldTPPs iVarVariant] lowercaseString]])
        return;
    NSString * mode = [[oldTPPs iVarMode] lowercaseString];
    NSDictionary * TPPs = [IMPLEMENTATION metaValueForKey:@"_TPPs"];
    NSEnumerator * E = [TPPs keyEnumerator];
    NSDictionary * keyD;
    NSString * newBPN = @"";
    NSString * shortestName = @"";
    NSString * pdf = [iTM2TPFEPDFOutput lowercaseString];
    while(keyD = [E nextObject])
    {
//iTM2_LOG(@"keyD is: %@", keyD]);
        if([[keyD iVarMode] isEqualToString:mode]
            && [[keyD iVarVariant] isEqualToString:variant])
        {
            newBPN = [[TPPs objectForKey:keyD] iVarName];
            if([[keyD iVarOutput] isEqualToString:pdf])
                goto tahaa;
            shortestName = newBPN;
            break;
        }
//iTM2_LOG(@"shortestName is: %@ (%@) ----1", shortestName, [[TPPs objectForKey:keyD] iVarName]);
    }
    while(keyD = [E nextObject])
    {
//iTM2_LOG(@"keyD is: %@", keyD]);
        if([[keyD iVarMode] isEqualToString:mode]
            && [[keyD iVarVariant] isEqualToString:variant])
        {
            newBPN = [[TPPs objectForKey:keyD] iVarName];
            if([[keyD iVarOutput] isEqualToString:pdf])
                goto tahaa;
            else if([newBPN length] < [shortestName length])
                shortestName = newBPN;
        }
//iTM2_LOG(@"shortestName is: %@ (%@)", shortestName, [[TPPs objectForKey:keyD] iVarName]);
    }
    newBPN = shortestName;
    tahaa:
    if(![[TPD baseProjectName] isEqualToString:newBPN])
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
    if([sender isKindOfClass:[NSPopUpButton class]])
    {
		static NSString * noModeTitle = nil;
		if(!noModeTitle)
			noModeTitle = [[[sender lastItem] title] copy];
        [sender removeAllItems];
		if(![[TPD baseProjectName] length])
		{
			[sender addItemWithTitle:noModeTitle];
			return NO;
		}
        // the sender is populated with all the variants of the projects with the same mode
        [sender removeAllItems];
//iTM2_LOG(@"baseProjectName is: %@", [TPD baseProjectName]);
        NSDictionary * Ps = [[TPD baseProjectName] TeXProjectProperties];
        NSString * baseMode = [[Ps iVarMode] lowercaseString];
//iTM2_LOG(@"baseMode is: %@", baseMode);
        NSMutableDictionary * MD = [NSMutableDictionary dictionary];
        NSDictionary * TPPs = [IMPLEMENTATION metaValueForKey:@"_TPPs"];
        NSEnumerator * E = [TPPs keyEnumerator];
        NSDictionary * keyD;
        while(keyD = [E nextObject])
            if([[[keyD iVarMode] lowercaseString] isEqualToString:baseMode])
            {
//iTM2_LOG(@"GOOD keyD is: %@", keyD);
                NSString * variant = [keyD iVarVariant];
                if([variant length])
                    [MD takeValue:[[[TPPs objectForKey:keyD] valueForKey:iTM2TeXPCommandPropertiesKey] iVarVariant]
                        forKey: variant];
                else
#warning DEBUGGGGG LOCALIZATION???
                    [MD takeValue:@"None" forKey:iTM2ProjectDefaultsKey];
            }
            else
            {
//iTM2_LOG(@"BAD  keyD is: %@", keyD);
            }
        E = [[[MD allKeys] sortedArrayUsingSelector:@selector(compare:)] objectEnumerator];
        NSString * k;
        while(k = [E nextObject])
        {
            [sender addItemWithTitle:[MD valueForKey:k]];
            [[sender lastItem] setRepresentedObject:k];// the lowercase string
        }
        NSString * variant = [Ps iVarVariant];
//iTM2_LOG(@"variant for validation is %@", variant);
        int idx = [sender indexOfItemWithRepresentedObject: ([variant length]? [variant lowercaseString]:iTM2ProjectDefaultsKey)];
        if(idx == -1)
        {
			if([sender numberOfItems])
				[[sender menu] addItem:[NSMenuItem separatorItem]];
			[sender addItemWithTitle: ([variant length]? [NSString stringWithFormat:@"%@(Unknown)", variant]:noModeTitle)];
			[sender selectItem:[sender lastItem]];        
			[[sender lastItem] setRepresentedObject:nil];// BEWARE!!!
        }
        else
        {
            [sender selectItemAtIndex:idx];
        }
		if([sender numberOfItems] < 2)
			return NO;
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
    NSString * output = [(id)[sender selectedItem] representedString];
    NSDictionary * Ps = [[TPD baseProjectName] TeXProjectProperties];
    NSString * mode = [[Ps iVarMode] lowercaseString];
    NSString * variant = [[Ps iVarVariant] lowercaseString];
    NSDictionary * TPPs = [IMPLEMENTATION metaValueForKey:@"_TPPs"];
    NSEnumerator * E = [TPPs keyEnumerator];
    NSDictionary * keyD;
    while(keyD = [E nextObject])
    {
        if([[keyD iVarMode] isEqualToString:mode]
            && [[[keyD iVarVariant] lowercaseString] isEqualToString:variant]
                && [[[keyD iVarOutput] lowercaseString] isEqualToString:output])
        {
            NSString * newBPN = [[TPPs objectForKey:keyD] iVarName];
			if(![[TPD baseProjectName] isEqualToString:newBPN])
			{
				[TPD setBaseProjectName:newBPN];
				[TPD updateChangeCount:NSChangeDone];
			}
            break;
        }
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
    if([sender isKindOfClass:[NSPopUpButton class]])
    {
		static NSString * noModeTitle = nil;
		if(!noModeTitle)
			noModeTitle = [[[sender lastItem] title] copy];
        [sender removeAllItems];
		if(![[TPD baseProjectName] length])
		{
			[sender addItemWithTitle:noModeTitle];
			return NO;
		}
        [sender removeAllItems];

//iTM2_LOG(@"baseProjectName is: %@", [TPD baseProjectName]);
        NSDictionary * Ps = [[TPD baseProjectName] TeXProjectProperties];
//iTM2_LOG(@"Ps is: %@", Ps);
        NSString * mode = [[Ps iVarMode] lowercaseString];
        NSString * variant = [[Ps iVarVariant] lowercaseString];
        NSMutableDictionary * MD = [NSMutableDictionary dictionary];
        NSDictionary * TPPs = [IMPLEMENTATION metaValueForKey:@"_TPPs"];
        NSEnumerator * E = [TPPs keyEnumerator];
        NSDictionary * D;
        while(D = [E nextObject])
            if([[D iVarMode] isEqualToString:mode] && [[D iVarVariant] isEqualToString:variant])
            {
                NSString * output = [D iVarOutput];
                if([output length])
                    [MD takeValue:[[[TPPs objectForKey:D] valueForKey:iTM2TeXPCommandPropertiesKey] iVarOutput]
                        forKey: output];
            }
		[sender addItemWithTitle:iTM2TPFEPDFOutput];
		[[sender lastItem] setRepresentedObject:[iTM2TPFEPDFOutput lowercaseString]];// the lowercase string
        E = [[[MD allKeys] sortedArrayUsingSelector:@selector(compare:)] objectEnumerator];
        NSString * k;
        while(k = [E nextObject])
        {
            [sender addItemWithTitle:[MD valueForKey:k]];
            [[sender lastItem] setRepresentedObject:k];// the lowercase string
        }
        NSString * output = [Ps iVarOutput];
        int idx = [sender indexOfItemWithRepresentedObject:[([output length]? output:iTM2TPFEPDFOutput) lowercaseString]];
        if(idx == -1)
        {
            NSString * lastTitle = [NSString stringWithFormat:@"%@(Unknown)", output];
            [[sender menu] addItem:[NSMenuItem separatorItem]];
            [sender addItemWithTitle:lastTitle];
            [sender selectItem:[sender lastItem]];        
            [[sender lastItem] setRepresentedObject:nil];// BEWARE!!!
        }
        else
        {
            [sender selectItemAtIndex:idx];
        }
		if([sender numberOfItems] < 2)
			return NO;
    }
    return YES;
}
#else
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  chooseBaseMode:
- (IBAction)chooseBaseMode:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Mar 26 08:41:36 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSString * mode = [(id)[sender selectedItem] representedString];
    id TPD = (iTM2TeXProjectDocument *)[self document];
    NSString * oldBPN = [TPD baseProjectName];
    if([mode isEqualToString:[[[oldBPN TeXProjectProperties] iVarMode] lowercaseString]])
        return;
    NSDictionary * TPPs = [IMPLEMENTATION metaValueForKey:@"_TPPs"];// TeX Projects Properties...
    NSEnumerator * E = [TPPs keyEnumerator];
    NSDictionary * keyD;
    NSString * newBPN = @"";
    NSString * shortestName = @"";
    NSString * pdf = [iTM2TPFEPDFOutput lowercaseString];
    while(keyD = [E nextObject])
        if([[keyD iVarMode] isEqualToString:mode])
        {
            if([[keyD iVarVariant] isEqualToString:@""]
                && [[keyD iVarOutput] isEqualToString:pdf])
            {
                newBPN = [[TPPs objectForKey:keyD] iVarName];
                goto tahaa;
            }
            shortestName = [[TPPs objectForKey:keyD] iVarName];
            break;
        }
    while(keyD = [E nextObject])
        if([[keyD iVarMode] isEqualToString:mode])
        {
            if([[keyD iVarVariant] isEqualToString:@""]
                && [[keyD iVarOutput] isEqualToString:pdf])
            {
                newBPN = [[TPPs objectForKey:keyD] iVarName];
                goto tahaa;
            }
            NSString * N = [[TPPs objectForKey:keyD] iVarName];
            if([N length] < [shortestName length])
                shortestName = N;
        }
    newBPN = shortestName;
    tahaa:
    if(![[TPD baseProjectName] isEqualToString:newBPN])
    {
        [TPD setBaseProjectName:newBPN];
        [TPD updateChangeCount:NSChangeDone];
    }
    [self validateWindowContent];
    return;
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
//iTM2_LOG(@"sender is: %@", sender);
    if([sender isKindOfClass:[NSPopUpButton class]])
    {
        [sender removeAllItems];
        iTM2TeXProjectDocument * TPD = (iTM2TeXProjectDocument *)[self document];
		if([SPC isBaseProject:TPD])
			return NO;
        NSMutableDictionary * MD = [NSMutableDictionary dictionary];
        NSDictionary * TPPs = [IMPLEMENTATION metaValueForKey:@"_TPPs"];
        NSEnumerator * E = [TPPs keyEnumerator];
        NSDictionary * D;
        while(D = [E nextObject])
        {
            [MD takeValue:[[[TPPs objectForKey:D] valueForKey:iTM2TeXPCommandPropertiesKey] iVarMode]
                forKey: [D iVarMode]];
        }
            // the key is lowercase!!! the value need not
        E = [[[MD allKeys] sortedArrayUsingSelector:@selector(compare:)] objectEnumerator];
        NSString * k;
        while(k = [E nextObject])
        {
            [sender addItemWithTitle:[MD valueForKey:k]];
            [[sender lastItem] setRepresentedObject:k];// the lowercase string
        }
        NSString * BPN = [TPD baseProjectName];
        NSDictionary * Ps = [BPN TeXProjectProperties];
        NSString * mode = [Ps iVarMode];
        int idx = [sender indexOfItemWithRepresentedObject:[mode lowercaseString]];
        if(idx == -1)
        {
            NSString * lastTitle = [NSString stringWithFormat:@"%@(Unknown)", mode];
            [[sender menu] addItem:[NSMenuItem separatorItem]];
            [sender addItemWithTitle:lastTitle];
            [sender selectItem:[sender lastItem]];        
            [[sender lastItem] setRepresentedObject:nil];// BEWARE!!!
        }
        else
        {
            [sender selectItemAtIndex:idx];
        }
        [sender setEnabled:[sender numberOfItems]>1];           
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
    NSString * variant = [[(id)[sender selectedItem] representedString] lowercaseString];
//iTM2_LOG(@"variant chosen is: %@", variant);
    if([variant isEqualToString:iTM2ProjectDefaultsKey])
        variant = @"";
    id TPD = (iTM2TeXProjectDocument *)[self document];
    NSString * oldBPN = [TPD baseProjectName];
    NSDictionary * oldTPPs = [oldBPN TeXProjectProperties];
    if([variant isEqualToString:[[oldTPPs iVarVariant] lowercaseString]])
        return;
    NSString * mode = [[oldTPPs iVarMode] lowercaseString];
    NSDictionary * TPPs = [IMPLEMENTATION metaValueForKey:@"_TPPs"];
    NSEnumerator * E = [TPPs keyEnumerator];
    NSDictionary * keyD;
    NSString * newBPN = @"";
    NSString * shortestName = @"";
    NSString * pdf = [iTM2TPFEPDFOutput lowercaseString];
    while(keyD = [E nextObject])
    {
//iTM2_LOG(@"keyD is: %@", keyD]);
        if([[keyD iVarMode] isEqualToString:mode]
            && [[keyD iVarVariant] isEqualToString:variant])
        {
            newBPN = [[TPPs objectForKey:keyD] iVarName];
            if([[keyD iVarOutput] isEqualToString:pdf])
                goto tahaa;
            shortestName = newBPN;
            break;
        }
//iTM2_LOG(@"shortestName is: %@ (%@) ----1", shortestName, [[TPPs objectForKey:keyD] iVarName]);
    }
    while(keyD = [E nextObject])
    {
//iTM2_LOG(@"keyD is: %@", keyD]);
        if([[keyD iVarMode] isEqualToString:mode]
            && [[keyD iVarVariant] isEqualToString:variant])
        {
            newBPN = [[TPPs objectForKey:keyD] iVarName];
            if([[keyD iVarOutput] isEqualToString:pdf])
                goto tahaa;
            else if([newBPN length] < [shortestName length])
                shortestName = newBPN;
        }
//iTM2_LOG(@"shortestName is: %@ (%@)", shortestName, [[TPPs objectForKey:keyD] iVarName]);
    }
    newBPN = shortestName;
    tahaa:
    if(![oldBPN isEqualToString:newBPN])
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
//iTM2_LOG(@"sender is: %@", sender);
    if([sender isKindOfClass:[NSPopUpButton class]])
    {
        // the sender is populated with all the variants of the projects with the same mode
        [sender removeAllItems];
        iTM2TeXProjectDocument * TPD = (iTM2TeXProjectDocument *)[self document];
		if([SPC isBaseProject:TPD])
			return NO;
        NSString * BPN = [TPD baseProjectName];
//iTM2_LOG(@"baseProjectName is: %@", BPN);
        NSDictionary * Ps = [BPN TeXProjectProperties];
        NSString * baseMode = [[Ps iVarMode] lowercaseString];
//iTM2_LOG(@"baseMode is: %@", baseMode);
        NSMutableDictionary * MD = [NSMutableDictionary dictionary];
        NSDictionary * TPPs = [IMPLEMENTATION metaValueForKey:@"_TPPs"];
//iTM2_LOG(@"TPPs are is: %@", TPPs);
        NSEnumerator * E = [TPPs keyEnumerator];
        NSDictionary * keyD;
        while(keyD = [E nextObject])
            if([[keyD iVarMode] isEqualToString:baseMode])
            {
//iTM2_LOG(@"GOOD keyD is: %@", keyD);
                NSString * variant = [keyD iVarVariant];
                if([variant length])
                    [MD takeValue:[[[TPPs objectForKey:keyD] valueForKey:iTM2TeXPCommandPropertiesKey] iVarVariant]
                        forKey: variant];
                else
#warning DEBUGGGGG LOCALIZATION???
                    [MD takeValue:@"None" forKey:iTM2ProjectDefaultsKey];
            }
            else
            {
//iTM2_LOG(@"BAD  keyD is: %@", keyD);
            }
        E = [[[MD allKeys] sortedArrayUsingSelector:@selector(compare:)] objectEnumerator];
        NSString * k;
        while(k = [E nextObject])
        {
            [sender addItemWithTitle:[MD valueForKey:k]];
            [[sender lastItem] setRepresentedObject:k];// the lowercase string
        }
        NSString * variant = [Ps iVarVariant];
//iTM2_LOG(@"variant for validation is %@", variant);
        int idx = [sender indexOfItemWithRepresentedObject: ([variant length]? [variant lowercaseString]:iTM2ProjectDefaultsKey)];
        if(idx == -1)
        {
            NSString * lastTitle = [NSString stringWithFormat:@"%@(Unknown)", variant];
            [[sender menu] addItem:[NSMenuItem separatorItem]];
            [sender addItemWithTitle:lastTitle];
            [sender selectItem:[sender lastItem]];        
            [[sender lastItem] setRepresentedObject:nil];// BEWARE!!!
        }
        else
        {
            [sender selectItemAtIndex:idx];
        }
        [sender setEnabled:[sender numberOfItems]>1];           
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
    NSString * output = [(id)[sender selectedItem] representedString];
    id TPD = (iTM2TeXProjectDocument *)[self document];
    NSString * oldBPN = [TPD baseProjectName];
    NSDictionary * Ps = [oldBPN TeXProjectProperties];
    NSString * mode = [[Ps iVarMode] lowercaseString];
    NSString * variant = [[Ps iVarVariant] lowercaseString];
    NSDictionary * TPPs = [IMPLEMENTATION metaValueForKey:@"_TPPs"];
    NSEnumerator * E = [TPPs keyEnumerator];
    NSDictionary * keyD;
    while(keyD = [E nextObject])
    {
        if([[keyD iVarMode] isEqualToString:mode]
            && [[[keyD iVarVariant] lowercaseString] isEqualToString:variant]
                && [[[keyD iVarOutput] lowercaseString] isEqualToString:output])
        {
            NSString * new = [[TPPs objectForKey:keyD] iVarName];
            if(![oldBPN isEqualToString:new])
            {
                [TPD setBaseProjectName:new];
                [TPD updateChangeCount:NSChangeDone];
            }
            break;
        }
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
//iTM2_LOG(@"sender is: %@", sender);
    if([sender isKindOfClass:[NSPopUpButton class]])
    {
        [sender removeAllItems];
        iTM2TeXProjectDocument * TPD = (iTM2TeXProjectDocument *)[self document];
		if([SPC isBaseProject:TPD])
			return NO;
        NSString * BPN = [TPD baseProjectName];
//iTM2_LOG(@"baseProjectName is: %@", BPN);
        NSDictionary * Ps = [BPN TeXProjectProperties];
//iTM2_LOG(@"Ps is: %@", Ps);
        NSString * mode = [[Ps iVarMode] lowercaseString];
        NSString * variant = [[Ps iVarVariant] lowercaseString];
        NSMutableDictionary * MD = [NSMutableDictionary dictionary];
        NSDictionary * TPPs = [IMPLEMENTATION metaValueForKey:@"_TPPs"];
        NSEnumerator * E = [TPPs keyEnumerator];
        NSDictionary * D;
        while(D = [E nextObject])
            if([[D iVarMode] isEqualToString:mode] && [[D iVarVariant] isEqualToString:variant])
            {
                NSString * output = [D iVarOutput];
                if([output length])
                    [MD takeValue:[[[TPPs objectForKey:D] valueForKey:iTM2TeXPCommandPropertiesKey] iVarOutput]
                        forKey: output];
            }
        E = [[[MD allKeys] sortedArrayUsingSelector:@selector(compare:)] objectEnumerator];
        NSString * k;
        while(k = [E nextObject])
        {
            [sender addItemWithTitle:[MD valueForKey:k]];
            [[sender lastItem] setRepresentedObject:k];// the lowercase string
        }
        NSString * output = [Ps iVarOutput];
        int idx = [sender indexOfItemWithRepresentedObject:[([output length]? output:iTM2TPFEPDFOutput) lowercaseString]];
        if(idx == -1)
        {
            NSString * lastTitle = [NSString stringWithFormat:@"%@(Unknown)", output];
            [[sender menu] addItem:[NSMenuItem separatorItem]];
            [sender addItemWithTitle:lastTitle];
            [sender selectItem:[sender lastItem]];        
            [[sender lastItem] setRepresentedObject:nil];// BEWARE!!!
        }
        else
        {
            [sender selectItemAtIndex:idx];
        }
        [sender setEnabled:[sender numberOfItems]>1];           
    }
    return YES;
}
#endif
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
	[self takeContextValue:argument forKey:@"Commands Inspector:Edited Command" domain:iTM2ContextAllDomainsMask];
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  defaultCommand:
- (IBAction)defaultCommand:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Mar 26 08:41:36 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    iTM2TeXProjectDocument * TPD = (iTM2TeXProjectDocument *)[self document];
    NSString * commandName = [self editedCommand];
	iTM2CommandWrapper * CW = [TPD commandWrapperForName:commandName];
	id old = [CW environmentMode];
	if(![old isEqualToString:iTM2TPFEBaseMode])
	{
		[CW setEnvironmentMode:iTM2TPFEBaseMode];
		[TPD updateChangeCount:NSChangeDone];
	}
	old = [CW scriptMode];
	if(![old isEqualToString:iTM2TPFEBaseMode])
	{
		[CW setScriptMode:iTM2TPFEBaseMode];
		[TPD updateChangeCount:NSChangeDone];
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
    iTM2TeXProjectDocument * TPD = (iTM2TeXProjectDocument *)[self document];
	iTM2CommandWrapper * CW = [TPD commandWrapperForName:[self editedCommand]];
    NSString * environmentMode = [CW environmentMode];
    NSString * scriptMode = [CW scriptMode];
    [sender setEnabled: ([environmentMode length] && ![environmentMode isEqualToString:iTM2TPFEBaseMode])
		|| [[[TPD commandScripts] allKeys] containsObject:scriptMode]];
    return YES;
}
#pragma mark =-=-=-=-=-=-=-=-=-=-  ACTION SCRIPTS MANAGEMENT
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  chooseScript:
- (IBAction)chooseScript:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Mar 26 08:41:36 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    iTM2TeXProjectDocument * TPD = (iTM2TeXProjectDocument *)[self document];
	iTM2CommandWrapper * CW = [TPD commandWrapperForName:[self editedCommand]];
	NSString * oldMode = [CW scriptMode];
	NSString * newMode = [(id)[sender selectedItem] representedString];
	if(![newMode isEqualToString:oldMode])
	{
		[CW setEnvironmentMode:newMode];
		[CW setScriptMode:newMode];
		[TPD updateChangeCount:NSChangeDone];
		[self validateWindowContent];
	}
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
        [[sender menu] addItem:[NSMenuItem separatorItem]];
        iTM2TeXProjectDocument * TPD = (iTM2TeXProjectDocument *)[self document];
//iTM2_LOG(@"[TPD commandScripts] is: %@", [TPD commandScripts]);
        NSEnumerator * E = [[TPD commandScripts] keyEnumerator];
        NSString * commandName = nil;
        while(commandName = [E nextObject])
        {
            NSString * label = [[TPD scriptDescriptorForCommandMode:commandName] iVarLabel];
            NSString * title = [label length]? label:
                [NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"Custom script %@", iTM2TeXProjectFrontendTable, myBUNDLE, "Description Forthcoming"), commandName];
            [sender addItemWithTitle:title];
            [[sender lastItem] setRepresentedObject:commandName];
            NSMenuItem * MI = [removeScriptMenu addItemWithTitle:title action:@selector(removeShellScript:) keyEquivalent:@""];
            [MI setRepresentedObject:commandName];
            [MI setTarget:self];
        }
        if([removeScriptMenu numberOfItems])
            [[sender menu] addItem:[NSMenuItem separatorItem]];
        [sender addItemWithTitle:NSLocalizedStringFromTableInBundle(@"New shell script", iTM2TeXProjectFrontendTable, myBUNDLE, "Description Forthcoming")];
        [[sender lastItem] setAction:@selector(newShellScript:)];
        [[sender lastItem] setTarget:self];
        if([removeScriptMenu numberOfItems])
        {
            [sender addItemWithTitle:NSLocalizedStringFromTableInBundle(@"Remove shell script", iTM2TeXProjectFrontendTable, myBUNDLE, "Description Forthcoming")];
            [[sender lastItem] setSubmenu:removeScriptMenu];
        }
		iTM2CommandWrapper * CW = [TPD commandWrapperForName:[self editedCommand]];
		NSString * scriptMode = [CW scriptMode];
//iTM2_LOG(@"CW is: %@", [CW description]);
        unsigned idx = [sender indexOfItemWithRepresentedObject: ([scriptMode length]? scriptMode:iTM2TPFEBaseMode)];
//iTM2_LOG(@"THE editedCommand IS: %@", [self editedCommand]);
		// This is a consistency test that should also be made before...
		if(idx == -1)
		{
			[CW setScriptMode:iTM2TPFEBaseMode];
			scriptMode = [CW scriptMode];
			idx = [sender indexOfItemWithRepresentedObject: ([scriptMode length]? scriptMode:iTM2TPFEBaseMode)];
			if(idx != -1)
				[self performSelector:@selector(validateWindowContent) withObject:nil afterDelay:0];
		}
        [sender selectItemAtIndex:idx];
    }
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  newShellScript:
- (IBAction)newShellScript:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Mar 26 08:41:36 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    iTM2TeXProjectDocument * TPD = (iTM2TeXProjectDocument *)[self document];
    NSArray * allActionModes = [[TPD commandScripts] allKeys];
    int idx = 0;
    NSString * scriptMode;
    while((scriptMode = [NSString stringWithFormat:@"%i", idx++]), [allActionModes containsObject:scriptMode]);
//iTM2_LOG(@"[TPD scriptDescriptorForCommandMode:scriptMode] is: %@", [TPD scriptDescriptorForCommandMode:scriptMode]);
    [TPD takeScriptDescriptor:[NSDictionary dictionary] forCommandMode:scriptMode];
//iTM2_LOG(@"[TPD scriptDescriptorForCommandMode:scriptMode] is: %@", [TPD scriptDescriptorForCommandMode:scriptMode]);
//iTM2_LOG(@"[[TPD commandWrapperForName:[self editedCommand]] scriptMode] is: %@", [[TPD commandWrapperForName:[self editedCommand]] scriptMode]);
	[[TPD commandWrapperForName:[self editedCommand]] setScriptMode:scriptMode];
//iTM2_LOG(@"[[TPD commandWrapperForName:[self editedCommand]] scriptMode] is: %@", [[TPD commandWrapperForName:[self editedCommand]] scriptMode]);
    [TPD updateChangeCount:NSChangeDone];
    [self validateWindowContent];
//iTM2_LOG(@"[NSApp targetForAction:@selector(saveDocument:)] is: %@", [NSApp targetForAction:@selector(saveDocument:)]);
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  removeShellScript:
- (IBAction)removeShellScript:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Mar 26 08:41:36 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    iTM2TeXProjectDocument * TPD = (iTM2TeXProjectDocument *)[self document];
	NSString * scriptMode = [(id)sender representedString];
    [TPD takeScriptDescriptor:nil forCommandMode:scriptMode];
	iTM2CommandWrapper * CW = [TPD commandWrapperForName:[self editedCommand]];
	if([[CW scriptMode] isEqualToString:scriptMode])
		[CW setScriptMode:iTM2TPFEBaseMode];
    [TPD updateChangeCount:NSChangeDone];
    [self validateWindowContent];
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
	iTM2TeXProjectDocument * TPD = (iTM2TeXProjectDocument *)[self document];
	NSString * scriptMode = [[TPD commandWrapperForName:[self editedCommand]] scriptMode];
	if(![SPC isBaseProject:TPD] && [scriptMode isEqualToString:iTM2TPFEBaseMode])
	{
		unsigned modifierFlags = [[NSApp currentEvent] modifierFlags];
		BOOL option = (modifierFlags & NSAlternateKeyMask) && !(modifierFlags & NSCommandKeyMask);
		if(!option)
			return;
		TPD = (iTM2TeXProjectDocument *)[TPD baseProject];
		scriptMode = [[TPD commandWrapperForName:[self editedCommand]] scriptMode];
		if([[[TPD commandScripts] allKeys] containsObject:scriptMode]
			&& ![scriptMode isEqualToString:iTM2TPFEBaseMode]
				&& ![scriptMode isEqualToString:iTM2TPFEVoidMode])
		{
			[TPD makeWindowControllers];// will create a ghost window and add an entry in the windows menu
			id inspector = [TPD inspectorAddedWithMode:[[self class] inspectorMode]];
			[TPD showWindows];
			[[inspector window] makeKeyAndOrderFront:self];
			[inspector editScript:self];
		}
		return;
	}
    if(![[self window] attachedSheet])
    {
#warning DEBUG: Problem when cancelled, the edited status might remain despite it should not.
        iTM2TeXPShellScriptInspector * WC = [[[iTM2TeXPShellScriptInspector allocWithZone:[self zone]]
			initWithWindowNibName: @"iTM2TeXPShellScriptInspector"] autorelease];
		NSWindow * W = [WC window];
		if(W)
		{
			[WC setScriptDescriptor:[TPD scriptDescriptorForCommandMode:scriptMode]];
			[TPD addWindowController:WC];
			[WC validateWindowContent];
			[NSApp beginSheet: W
					modalForWindow: [self window]
					modalDelegate: self
					didEndSelector: @selector(editScriptSheetDidEnd:returnCode:scriptMode:)
					contextInfo: scriptMode];
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
    iTM2TeXProjectDocument * TPD = (iTM2TeXProjectDocument *)[self document];
	iTM2CommandWrapper * CW = [TPD commandWrapperForName:[self editedCommand]];
    NSString * scriptMode = [CW scriptMode];
	if(![SPC isBaseProject:TPD] && [scriptMode isEqualToString:iTM2TPFEBaseMode])
	{
		unsigned modifierFlags = [[NSApp currentEvent] modifierFlags];
		BOOL option = (modifierFlags & NSAlternateKeyMask) && !(modifierFlags & NSCommandKeyMask);
		if(!option)
			return NO;
		TPD = (iTM2TeXProjectDocument *)[TPD baseProject];
		CW = [TPD commandWrapperForName:[self editedCommand]];
		scriptMode = [CW scriptMode];
		return [[[TPD commandScripts] allKeys] containsObject:scriptMode]
			&& ![scriptMode isEqualToString:iTM2TPFEBaseMode]
				&& ![scriptMode isEqualToString:iTM2TPFEVoidMode];
	}
    return [[[TPD commandScripts] allKeys] containsObject:scriptMode];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  editScriptSheetDidEnd:returnCode:scriptMode:
- (void)editScriptSheetDidEnd:(NSWindow *)sheet returnCode:(int)returnCode scriptMode:(NSString *)scriptMode;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sheet orderOut:self];
    id WC = [sheet windowController];
    if(returnCode==NSAlertDefaultReturn)
    {
        iTM2TeXProjectDocument * TPD = (iTM2TeXProjectDocument *)[self document];
        id old = [TPD scriptDescriptorForCommandMode:scriptMode];
        id new = [WC scriptDescriptor];
        if(![old isEqual:new])
        {
            [TPD takeScriptDescriptor:new forCommandMode:scriptMode];
            [TPD updateChangeCount:NSChangeDone];
        }
    }
    [[WC document] removeWindowController:WC];
    [self validateWindowContent];
    return;
}
#pragma mark =-=-=-=-=-=-=-=-=-=-  OPTIONS MANAGEMENT
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  chooseOptions:
- (IBAction)chooseOptions:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Mar 26 08:41:36 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    iTM2TeXProjectDocument * TPD = (iTM2TeXProjectDocument *)[self document];
	NSString * commandName = [self editedCommand];
	iTM2CommandWrapper * CW = [TPD commandWrapperForName:commandName];
	NSString * oldEnvironmentMode = [CW environmentMode];
	NSString * newEnvironmentMode = [(id)[sender selectedItem] representedString];
	if(![newEnvironmentMode isEqualToString:oldEnvironmentMode]
		&& (newEnvironmentMode != oldEnvironmentMode)
			&& [TPD isValidEnvironmentMode: newEnvironmentMode
				forScriptMode: [CW scriptMode]
					commandName: commandName])
	{
		[CW setEnvironmentMode:newEnvironmentMode];
		[TPD updateChangeCount:NSChangeDone];
		[self validateWindowContent];
	}
	else if(iTM2DebugEnabled)
	{
		iTM2_LOG(@"No option change: old: %@, new: %@, command: %@", oldEnvironmentMode, newEnvironmentMode, commandName);
	}
//iTM2_LOG(@"CW is NOW: %@", CW);
//iTM2_LOG(@"[TPD commands] are: %@", [TPD commands]);
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
    if([sender isKindOfClass:[NSMenuItem class]])
	{
		NSString * editedCommand = [self editedCommand];
        iTM2TeXProjectDocument * TPD = (iTM2TeXProjectDocument *)[self document];
		iTM2CommandWrapper * CW = [TPD commandWrapperForName:editedCommand];
		id RO = [sender representedObject];
		return [TPD isValidEnvironmentMode:RO forScriptMode:[CW scriptMode] commandName:editedCommand];
	}
    else if([sender isKindOfClass:[NSPopUpButton class]])
	{
		[sender removeAllItems];
		// populates with a "base" menu item
		[sender addItemWithTitle:NSLocalizedStringFromTableInBundle(@"No options", iTM2TeXProjectFrontendTable, myBUNDLE, "...")];
		[[sender lastItem] setRepresentedObject:iTM2TPFEVoidMode];
		[sender addItemWithTitle:NSLocalizedStringFromTableInBundle(@"Base options", iTM2TeXProjectFrontendTable, myBUNDLE, "...")];
		[[sender lastItem] setRepresentedObject:iTM2TPFEBaseMode];
		[[sender menu] addItem:[NSMenuItem separatorItem]];
		NSEnumerator * E = [[iTM2TeXPCommandManager orderedBuiltInCommandNames] objectEnumerator];
		NSEnumerator * e;
		while(e = [[E nextObject] objectEnumerator])
		{
			NSString * name;
			while(name = [e nextObject])
			{
				if(![name hasPrefix:@"."])
				{
					[sender addItemWithTitle:[iTM2TeXPCommandPerformer localizedNameForName:name]];
					[[sender lastItem] setRepresentedObject:name];
				}
			}
			[[sender menu] addItem:[NSMenuItem separatorItem]];
		}
		if([[sender lastItem] isSeparatorItem])
		{
			[[sender menu] removeItem:[sender lastItem]];
		}
		// validating and selecting the proper item
		NSString * editedCommand = [self editedCommand];
//iTM2_LOG(@"editedCommand is: %@", editedCommand);
		iTM2TeXProjectDocument * TPD = (iTM2TeXProjectDocument *)[self document];
		iTM2CommandWrapper * CW = [TPD commandWrapperForName:editedCommand];
		if([[[CW name] lowercaseString] isEqualToString:@"special"])
		{
			NSString * scriptMode = [CW scriptMode];
			// special action: inherited base script means inherited base options
			// in all other cases, no options
			[CW setEnvironmentMode:
				([scriptMode isEqualToString:iTM2TPFEBaseMode]? iTM2TPFEBaseMode:iTM2TPFEVoidMode)];
			NSString * environmentMode = [CW environmentMode];
			unsigned idx = [sender indexOfItemWithRepresentedObject: ([environmentMode length]? environmentMode:iTM2TPFEBaseMode)];
			[sender selectItemAtIndex:idx];
			// the special action does not authorize options editors
			return NO;
		}
		else
		{
			NSString * scriptMode = [CW scriptMode];
			NSString * environmentMode = [CW environmentMode];
			// see the consistency check in the prepareFrontendFixImplementation method
			// here is a second one for security
			if([scriptMode isEqualToString:iTM2TPFEVoidMode])
			{
				environmentMode = iTM2TPFEVoidMode;
				unsigned idx = [sender indexOfItemWithRepresentedObject:environmentMode];
				[sender selectItemAtIndex:idx];
				return NO;
			}
			else if([scriptMode isEqualToString:iTM2TPFEBaseMode])
			{
				// the script is inherited: the option must be either inherited or same as base
//iTM2_LOG(@"The script is inherited: environement mode is: %@", environmentMode);
				if([environmentMode isEqualToString:iTM2TPFEVoidMode])
					[CW setEnvironmentMode:iTM2TPFEBaseMode];
				else if(![environmentMode isEqualToString:iTM2TPFEBaseMode])
				{
					iTM2CommandWrapper * baseCW = [[TPD baseProject] commandWrapperForName:editedCommand];
					if(baseCW)
					{
						// authorized environment modes are limited: base ot from base project
//iTM2_LOG(@"environmentMode is: %@", environmentMode);
//iTM2_LOG(@"[baseCW environmentMode] is: %@", [baseCW environmentMode]);
//iTM2_LOG(@"editedCommand is: %@", editedCommand);
						if(![environmentMode isEqualToString:[baseCW environmentMode]]
							&& ![environmentMode isEqualToString:editedCommand])
						{
							[CW setEnvironmentMode:[baseCW environmentMode]];
						}
					}
				}
				environmentMode = [CW environmentMode];
//iTM2_LOG(@"The script is inherited: environement mode is now: %@", environmentMode);
				unsigned idx = [sender indexOfItemWithRepresentedObject:environmentMode];
				[sender selectItemAtIndex:idx];
				return YES;
			}
			else
			{
				unsigned idx = [sender indexOfItemWithRepresentedObject: ([environmentMode length]? environmentMode:iTM2TPFEVoidMode)];
				if(idx == -1)
				{
					[CW setEnvironmentMode:iTM2TPFEVoidMode];
					environmentMode = [CW environmentMode];
					idx = [sender indexOfItemWithRepresentedObject: ([environmentMode length]? environmentMode:iTM2TPFEVoidMode)];
				}
				[sender selectItemAtIndex:idx];
				return YES;
			}
		}
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
		NSString * editedCommand = [self editedCommand];
        iTM2TeXProjectDocument * TPD = (iTM2TeXProjectDocument *)[self document];
		iTM2CommandWrapper * CW = [TPD commandWrapperForName:editedCommand];
		NSString * environmentMode = [CW environmentMode];
		if([environmentMode isEqualToString:iTM2TPFEBaseMode] && ![SPC isBaseProject:TPD])
		{
			unsigned modifierFlags = [[NSApp currentEvent] modifierFlags];
			if((modifierFlags & NSAlternateKeyMask) && !(modifierFlags & NSCommandKeyMask))
			{
				TPD = (iTM2TeXProjectDocument *)[TPD baseProject];
				CW = [TPD commandWrapperForName:editedCommand];
				environmentMode = [CW environmentMode];
				if(![environmentMode isEqualToString:iTM2TPFEBaseMode] && ![environmentMode isEqualToString:iTM2TPFEVoidMode])
				{
					[TPD makeWindowControllers];// will create a ghost window and add an entry in the windows menu
					id inspector = [TPD inspectorAddedWithMode:[[self class] inspectorMode]];
					[TPD showWindows];
					[[inspector window] makeKeyAndOrderFront:self];
					[inspector editOptions:self];
				}
			}
			 return;
		}
		Class C = [iTM2TeXPCommandInspector classForMode:environmentMode];
        iTM2TeXPCommandInspector * WC = [[[C allocWithZone:[self zone]] initWithWindowNibName:[C windowNibName]] autorelease];
		[TPD addWindowController:WC];// now [WC document] == TPD, and WC is retained, the WC document is the project
		[WC takeModel:[TPD environmentForCommandMode:environmentMode]];
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
                    didEndSelector: @selector(editOptionsSheetDidEnd:returnCode:environmentMode:)
                    contextInfo: environmentMode];
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  editOptionsSheetDidEnd:returnCode:environmentMode:
- (void)editOptionsSheetDidEnd:(NSWindow *)sheet returnCode:(int)returnCode environmentMode:(NSString *)environmentMode;
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
    if(returnCode==NSAlertDefaultReturn)
    {
        iTM2TeXProjectDocument * TPD = (iTM2TeXProjectDocument *)[self document];
		NSDictionary * new = [WC shellEnvironment];
		NSDictionary * old = [TPD environmentForCommandMode:environmentMode];
//iTM2_LOG(@"old is: %@", old);
//iTM2_LOG(@"new is: %@", new);
		if([old count]>0? ![old isEqual:new]:[new count])
		{
			// There might be a problemm when upgrading if we add some keys to the dictionary
			[TPD takeEnvironment:new forCommandMode:environmentMode];
			[TPD updateChangeCount:NSChangeDone];
		}
    }
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
	// the sender is disabled when
	// - the environment mode is void or void
	// - the environment mode is inherited from the base project and the option key is not pressed or the receiver is a base project itself
	// - the environment mode is not from the base project but it does not correspond to the kind of script
	iTM2TeXProjectDocument * TPD = (iTM2TeXProjectDocument *)[self document];
	NSString * editedCommand = [self editedCommand];
	iTM2CommandWrapper * CW = [TPD commandWrapperForName:editedCommand];
	NSString * environmentMode = [CW environmentMode];
	if(![environmentMode length] || [environmentMode isEqualToString:iTM2TPFEVoidMode])
		return NO;
	else if([SPC isBaseProject:TPD])
		return ![environmentMode isEqualToString:iTM2TPFEBaseMode];
	else if([environmentMode isEqualToString:iTM2TPFEBaseMode])
	{
		unsigned modifierFlags = [[NSApp currentEvent] modifierFlags];
		return (modifierFlags & NSAlternateKeyMask) && !(modifierFlags & NSCommandKeyMask);
	}
	else
	{
		NSString * scriptMode = [CW scriptMode];
		if([[[CW name] lowercaseString] isEqualToString:@"special"])
			return NO;
		else if([scriptMode isEqualToString:iTM2TPFEBaseMode])
			return [environmentMode isEqualToString:[[[TPD baseProject] commandWrapperForName:editedCommand] environmentMode]]
				|| [environmentMode isEqualToString:editedCommand];
		else
			return ![scriptMode isEqualToString:iTM2TPFEBaseMode];
	}
	return YES;
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

NSString * const iTM2TPFEEnvironmentModeKey = @"EnvironmentMode";
NSString * const iTM2TPFEScriptModeKey = @"ScriptMode";

//#import <iTM2Foundation/iTM2RuntimeBrowser.h>
//#import <iTM2Foundation/iTM2BundleKit.h>

@implementation iTM2CommandWrapper
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  description
- (NSString *)description;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [NSString stringWithFormat: @"<%@: name: %@, script mode: %@, environment mode: %@>",
		[super description], [self name], [self scriptMode], [self environmentMode]];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  metaFixImplementation
- (void)metaFixImplementation;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self setModel:[[self project] modelForCommandName:[self name]]];
	[self modelDidChange];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  modelDidChange
- (void)modelDidChange;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  name
- (NSString *)name;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return metaGETTER;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setName:
- (void)setName:(NSString *)name;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	metaSETTER(name);
	[self fixImplementation];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  project
- (id)project;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [metaGETTER nonretainedObjectValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setProject:
- (void)setProject:(id)project;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	metaSETTER([NSValue valueWithNonretainedObject:project]);
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  model
- (id)model;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [IMPLEMENTATION modelOfType:iTM2MainType];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setModel:
- (void)setModel:(NSDictionary *)model;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [IMPLEMENTATION takeModel: (model? [NSMutableDictionary dictionaryWithDictionary:model]:[NSMutableDictionary dictionary]) ofType:iTM2MainType];
	[self modelDidChange];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  scriptMode
- (id)scriptMode;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * result = [[self implementation] modelValueForKey:iTM2TPFEScriptModeKey ofType:iTM2MainType];
	if(![result length])
	{
		[[self implementation] takeModelValue:iTM2TPFEBaseMode forKey:iTM2TPFEScriptModeKey ofType:iTM2MainType];
		[[self implementation] takeModelValue:iTM2TPFEBaseMode forKey:iTM2TPFEEnvironmentModeKey ofType:iTM2MainType];
		result = [[self implementation] modelValueForKey:iTM2TPFEScriptModeKey ofType:iTM2MainType];
	}
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setScriptMode:
- (void)setScriptMode:(NSString *)mode;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[[self implementation] takeModelValue:mode forKey:iTM2TPFEScriptModeKey ofType:iTM2MainType];
	[self modelDidChange];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  environmentMode
- (id)environmentMode;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * result = [[self implementation] modelValueForKey:iTM2TPFEEnvironmentModeKey ofType:iTM2MainType];
	if(![result length])
	{
		[[self implementation] takeModelValue: ([[[self name] lowercaseString] isEqualToString:@"special"]? iTM2TPFEVoidMode: iTM2TPFEBaseMode)
			forKey: iTM2TPFEEnvironmentModeKey ofType: iTM2MainType];
		result = [[self implementation] modelValueForKey:iTM2TPFEEnvironmentModeKey ofType:iTM2MainType];
	}
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setEnvironmentMode:
- (void)setEnvironmentMode:(NSString *)mode;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[[self implementation] takeModelValue:mode forKey:iTM2TPFEEnvironmentModeKey ofType:iTM2MainType];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  isEqual:
- (BOOL)isEqual:(id)rhs;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	return [rhs isKindOfClass:[self class]]?
		[[self name] isEqualToString:[rhs name]] && [[self project] isEqual:[rhs project]] && [[self model] isEqual:[rhs model]]:
		[super isEqual:rhs];
}
@end

@implementation iTM2TeXPCommandWrapper
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  modelDidChange
- (void)modelDidChange;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([[[self name] lowercaseString] isEqualToString:@"special"])
	{
		// special action: inherited base script means inherited base options
		// in all other cases, no options
		if([[self scriptMode] isEqualToString:iTM2TPFEBaseMode])
			[self setEnvironmentMode:iTM2TPFEBaseMode];
		else
			[self setEnvironmentMode:iTM2TPFEVoidMode];
	}
	else
	{
		// not a special action
		if([[self scriptMode] isEqualToString:iTM2TPFEBaseMode])
		{
			// the script is inherited: the option must be either inherited or eponym
			NSString * environmentMode = [self environmentMode];
			if([environmentMode isEqualToString:iTM2TPFEVoidMode])
				[self setEnvironmentMode:iTM2TPFEBaseMode];
			else if(![environmentMode isEqualToString:iTM2TPFEBaseMode])
				[self setEnvironmentMode:[self name]];
		}
	}
    return;
}
@end

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
	const char * _classname = [NSStringFromClass(self) lossyCString];
	if(!strncmp(_classname, "iTM2TeXP", strlen("iTM2TeXP")))
	{
		int n = strlen(_classname);
		if(n>strlen("iTM2TeXPInspector"))
		{
			if(!strncmp(_classname + n - strlen("Inspector"), "Inspector", strlen("Inspector")))
			{
				return [NSString stringWithCString:_classname+strlen("iTM2TeXP") length:n - strlen("iTM2TeXPInspector")];
			}
		}
	}
    return @"";
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
#warning *** BUG TRACKING: CTHER TeX menu management
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
				[mi setTarget:performer];
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
				[mi setTarget:performer];
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  compare:
+ (NSComparisonResult)compare:(id)rhs;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([rhs isKindOfClass:[iTM2CommandWrapper class]])
	{
		return [self commandLevel] < [rhs commandLevel]? NSOrderedAscending:
			  ([self commandLevel] > [rhs commandLevel]? NSOrderedDescending: NSOrderedSame);
	}
    return NSOrderedAscending;
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
	[project setElementary:NO];
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
		iTM2_Launch = [[[iTM2TeXPCommandPerformer classBundle] pathForAuxiliaryExecutable:[@"bin" stringByAppendingPathComponent:@"iTM2_Launch"]] copy];// statically retained!
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
			iTM2_LOG(@"/\\/\\/\\/\\  performing action name: %@ for project: %@", [self commandName], [project fileName]);
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
		D = [[project baseProjectName] TeXProjectProperties];
		[TW mergeEnvironment:D];
		NSString * currentDirectory = [[TW environment] objectForKey:TWSShellEnvironmentProjectKey];
		currentDirectory = [currentDirectory stringByDeletingLastPathComponent];
        [TW setCurrentDirectoryPath:(currentDirectory?:@"")];
		if([project wasNotModified])
		{
			[TW setEnvironmentString:@"1" forKey:@"iTM2_XLR8"];// iTM2_Launch can use whatever he has cached, NYI
		}
		else
		{
			[project setWasNotModified:YES];// iTM2_Launch will be able to use whatever he has cached only next time
		}
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
        [TW addArgument:commandName];
		[TW setEnvironmentString:[NSString farawayProjectsDirectory] forKey:@"iTM2_Faraway_Projects_Directory"];
		[TW setEnvironmentString:[project getTeXMFProgramsPath] forKey:@"iTM2_PATH_TeX_Programs"];
		[TW setEnvironmentString:[project getOtherProgramsPath] forKey:@"iTM2_PATH_Other_Programs"];
		[TW setEnvironmentString:[project getPATHPrefix] forKey:@"iTM2_PATH_Prefix"];
		[TW setEnvironmentString:[project getPATHSuffix] forKey:@"iTM2_PATH_Suffix"];
		if([project getPATHUsesLoginShell])
		{
			[TW setEnvironmentString:@"YES" forKey:@"iTM2_PATH_UsesLoginShell"];
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
		[I setName:@"iTeXMac2Mini"];
	}
	[sender setMixedStateImage:I];// this does not work yet, may be in leopard...
//iTM2_LOG(@"I: %@, MSI: %@", I, [sender mixedStateImage]);
	NSString * scriptMode = [[TPD commandWrapperForName:commandName] scriptMode];
//iTM2_LOG(@"commandName is: %@, scriptMode is: %@", commandName, scriptMode);
	if([scriptMode isEqualToString:iTM2TPFEVoidMode])
		return NO;
	else if([scriptMode isEqualToString:iTM2TPFEBaseMode])
	{
		TPD = [TPD baseProject];
		iTM2CommandWrapper * commandWrapper = [TPD commandWrapperForName:commandName];
		scriptMode = [commandWrapper scriptMode];
		if([scriptMode isEqualToString:iTM2TPFEVoidMode])
			return NO;
		else if([scriptMode isEqualToString:iTM2TPFEBaseMode])
		{
			return YES;
		}
		else if(scriptMode)
			return [TPD scriptDescriptorForCommandMode:scriptMode] != nil;
		else
			return NO;
	}
	else if(scriptMode)
		return [TPD scriptDescriptorForCommandMode:scriptMode] != nil;
	else
		return TPD != nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= environmentScriptsForBaseProject:
+ (NSDictionary *)environmentScriptsForBaseProject:(iTM2TeXProjectDocument *)project;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- Thu Oct 28 14:05:13 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSMutableDictionary * ED = [NSMutableDictionary dictionary];
	// all the scripts...
	NSEnumerator * E = [[project commandScripts] keyEnumerator];
	NSString * mode;
	while(mode = [E nextObject])
	{
		NSDictionary * scriptDescriptor = [project scriptDescriptorForCommandMode:mode];
		if([scriptDescriptor count])
		{
			NSString * shellScript = [scriptDescriptor valueForKey:iTM2TPFEContentKey];
			if(shellScript)
				[ED setObject:shellScript forKey:[NSString stringWithFormat:@"iTM2_ShellScript_BaseCommand_%@", mode]];
		}
	}
//iTM2_END;
    return ED;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= environmentScriptsForProject:
+ (NSDictionary *)environmentScriptsForProject:(iTM2TeXProjectDocument *)project;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- Thu Oct 28 14:05:13 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSMutableDictionary * ED = [NSMutableDictionary dictionary];
	// all the scripts...
	NSEnumerator * E = [[project commandScripts] keyEnumerator];
	NSString * mode;
	while(mode = [E nextObject])
	{
		NSDictionary * scriptDescriptor = [project scriptDescriptorForCommandMode:mode];
		if([scriptDescriptor count])
		{
			NSString * shellScript = [scriptDescriptor valueForKey:iTM2TPFEContentKey];
			if(shellScript)
				[ED setObject:shellScript forKey:[NSString stringWithFormat:@"iTM2_ShellScript_Command_%@", mode]];
		}
	}
//iTM2_END;
    return ED;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= environmentWithDictionary:forBaseProject:
+ (NSDictionary *)environmentWithDictionary:(NSDictionary *)environment forBaseProject:(iTM2TeXProjectDocument *)project;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- Thu Oct 28 14:05:13 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSMutableDictionary * ED = [[environment mutableCopy] autorelease];
	NSString * command = [self commandName];
	// This is the default engine for any command
	NSString * key = [NSString stringWithFormat:@"iTM2_%@", command];//iTM2_Compile, iTM2_Index...
	iTM2CommandWrapper * CW = [project commandWrapperForName:command];
	NSString * mode = [CW scriptMode];
	if([mode isEqualToString:iTM2TPFEVoidMode])
	{
		[ED takeValue:@"iTM2_Command_DoNothing" forKey:key];
		return ED;
	}
	else if([mode isEqualToString:iTM2TPFEBaseMode])
	{
		[ED takeValue:[NSString stringWithFormat:@"iTM2_Command_%@", command] forKey:key];
	}
	else
	{
		[ED takeValue:[NSString stringWithFormat:@"iTM2_Command_%@", mode] forKey:key];
	}
	mode = [CW environmentMode];
	if(![mode isEqualToString:iTM2TPFEVoidMode] && ![mode isEqualToString:iTM2TPFEBaseMode])
	{
		[ED addEntriesFromDictionary:[project environmentForCommandMode:mode]];
	}
//iTM2_END;
    return ED;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= environmentWithDictionary:forProject:
+ (NSDictionary *)environmentWithDictionary:(NSDictionary *)environment forProject:(iTM2TeXProjectDocument *)project;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- Thu Oct 28 14:05:13 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSMutableDictionary * ED = [[environment mutableCopy] autorelease];
	NSString * command = [self commandName];
	// This is the default engine for any command
	NSString * key = [NSString stringWithFormat:@"iTM2_%@", command];//iTM2_Compile, iTM2_Index...
//iTM2_LOG(@"the key is: %@", key);
	iTM2CommandWrapper * CW = [project commandWrapperForName:command];
	NSString * mode = [CW scriptMode];
//iTM2_LOG(@"the mode is: %@", mode);
	if([mode isEqualToString:iTM2TPFEVoidMode])
	{
		[ED takeValue:@"iTM2_Command_DoNothing" forKey:key];
		return ED;
	}
	else if([mode isEqualToString:iTM2TPFEBaseMode])
	{
		if(![ED valueForKey:key])
		{
			[ED takeValue:[NSString stringWithFormat:@"iTM2_Command_%@", command] forKey:key];
		}
	}
	else
	{
		[ED takeValue:[NSString stringWithFormat:@"iTM2_Command_%@", mode] forKey:key];
	}
	mode = [CW environmentMode];
//iTM2_LOG(@"31-iTM2_Compile_tex is: %@", [ED objectForKey:@"iTM2_Compile_tex"]);
	if(![mode isEqualToString:iTM2TPFEVoidMode] && ![mode isEqualToString:iTM2TPFEBaseMode])
	{
		[ED addEntriesFromDictionary:[project environmentForCommandMode:mode]];
	}
//iTM2_LOG(@"32-iTM2_Compile_tex is: %@", [ED objectForKey:@"iTM2_Compile_tex"]);
//iTM2_END;
    return ED;
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
//iTM2_LOG(@"1-iTM2_Compile_tex is: %@", [result objectForKey:@"iTM2_Compile_tex"]);
	// base project related stuff
	NSMutableArray * baseProjects = [NSMutableArray array];
	id baseProject = [project baseProject];
	while(baseProject && ![baseProjects containsObject:baseProject])
	{
		[baseProjects addObject:baseProject];
		baseProject = [baseProject baseProject];
	}
	// basePProjects contains the stack of all the base projects ancestors of project
	NSEnumerator * E = [baseProjects reverseObjectEnumerator];
	while(baseProject = [E nextObject])
	{
		[result addEntriesFromDictionary:[self environmentScriptsForBaseProject:baseProject]];
//iTM2_LOG(@"result:%@",result);
		NSEnumerator * e = [[iTM2RuntimeBrowser subclassReferencesOfClass:[iTM2TeXPCommandPerformer class]] objectEnumerator];
		Class C;
		while(C = (Class)[[e nextObject] nonretainedObjectValue])
		{
			[result addEntriesFromDictionary:[C environmentWithDictionary:result forBaseProject:baseProject]];
//iTM2_LOG(@"result:%@",result);
//iTM2_LOG(@"2-iTM2_Compile_tex is: %@ from %@", [result objectForKey:@"iTM2_Compile_tex"], C);
		}
	}
//iTM2_LOG(@"2-iTM2_Compile_tex is: %@", [result objectForKey:@"iTM2_Compile_tex"]);
	// project related stuff
	[result addEntriesFromDictionary:[self environmentScriptsForProject:project]];
//iTM2_LOG(@"result:%@",result);
//iTM2_LOG(@"3-iTM2_Compile_tex is: %@", [result objectForKey:@"iTM2_Compile_tex"]);
	E = [[iTM2RuntimeBrowser subclassReferencesOfClass:[iTM2TeXPCommandPerformer class]] objectEnumerator];
	Class C = Nil;
	while(C = (Class)[[E nextObject] nonretainedObjectValue])
	{
		[result addEntriesFromDictionary:[C environmentWithDictionary:result forProject:project]];
//iTM2_LOG(@"result:%@",result);
	}
//iTM2_LOG(@"4-iTM2_Compile_tex is: %@", [result objectForKey:@"iTM2_Compile_tex"]);
	// more general stuff
    [result takeValue:[project wrapperName] forKey:TWSShellEnvironmentWrapperKey];
	NSDocument * CD = [SDC currentDocument];
	if(CD == project)
	{
		NSEnumerator * E = [[NSApp orderedWindows] objectEnumerator];
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
    [result takeValue:[project relativeFileNameForKey:[project keyForFileName:[CD fileName]]] forKey:TWSShellEnvironmentFrontKey];
	NSString * MFK = [project masterFileKey];
	if([MFK isEqualToString:@"...iTM2FrontDocument"])
	{
		MFK = [project keyForFileName:[CD fileName]];
	}
	else if(![MFK length])
	{
		// the project has not yet a master file key
		NSArray * Ks = [project allKeys];
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
