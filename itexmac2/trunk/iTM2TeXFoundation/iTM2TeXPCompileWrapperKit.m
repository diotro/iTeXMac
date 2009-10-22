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

#import <iTM2TeXFoundation/iTM2TeXProjectFrontendKit.h>
#import <iTM2TeXFoundation/iTM2TeXPCompileWrapperKit.h>
#import <iTM2TeXFoundation/iTM2TeXProjectDocumentKit.h>

extern NSString * const iTM2TeXProjectFrontendTable;

NSString * const iTM2TPFEEngineIdentifier = @"iTM2_Engine_";
NSString * const iTM2TPFECompileEngines = @"iTM2_Compile_Engines";
extern NSString * const iTM2TPFELabelKey;
#define iVarLabel valueForKey: iTM2TPFELabelKey


@interface iTM2TeXPCompileInspector(PRIVATE)
- (id)editedEngine;
- (void)setEditedEngine:(NSString *)argument;
- (NSTabView *)tabView;
@end

@interface iTM2TeXPCompilePerformer: iTM2TeXPCommandPerformer
@end

@interface iTM2TeXPContinuousPerformer: iTM2TeXPCommandPerformer
@end

@interface iTM2TeXPCompilePerformer(PRIVATE)
+ (NSArray *)allBuiltInEngineModes;
+ (NSArray *)builtInEngineModes;
@end

#define myBundle [self classBundle]

@implementation iTM2TeXPCompileInspector
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  allEnvironmentVariables
+ (NSArray *)allEnvironmentVariables;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [NSArray array];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  infosKeyPathPrefix
- (NSString *)infosKeyPathPrefix;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initWithWindow:
- (id)initWithWindow:(NSWindow *)window;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(self = [super initWithWindow:window])
	{
		if(![self editedEngine])
		{
			[self setEditedEngine:[[[iTM2TeXPCompilePerformer builtInEngineModes] objectEnumerator] nextObject]];
		}
	}
//iTM2_END;
    return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  windowDidLoad
- (void)windowDidLoad;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSTabView * TV = [self tabView];
    NSString * identifier = [self contextStringForKey:@"Compile Inspector:Tab View Item Identifier" domain:iTM2ContextAllDomainsMask];
    NSUInteger index = [TV indexOfTabViewItemWithIdentifier:identifier];
    if(index !=  NSNotFound)
        [TV selectTabViewItemAtIndex:index];
    [super windowDidLoad];
	// changes since 536
	// get all the possible engines
	NSEnumerator * E = [[self infoForKeyPaths:iTM2TPFECommandsKey,nil] keyEnumerator];
	NSString * K;
	while(K = [E nextObject])
	{
		NSString * mode = [self infoForKeyPaths:iTM2TPFECommandsKey,K,iTM2TPFEScriptModeKey,nil];
		if([mode isEqualToString:iTM2TPFEBaseMode])
		{
			[self setInfo:nil forKeyPaths:iTM2TPFECommandsKey,K,iTM2TPFEScriptModeKey,nil];
		}
		mode = [self infoForKeyPaths:iTM2TPFECommandsKey,K,iTM2TPFEEnvironmentModeKey,nil];
		if([mode isEqualToString:iTM2TPFEBaseMode])
		{
			[self setInfo:nil forKeyPaths:iTM2TPFECommandsKey,K,iTM2TPFEEnvironmentModeKey,nil];
		}
	}
	[self saveChangesForKeyPaths:iTM2TPFECommandsKey, nil];
	E = [[self infoForKeyPaths:iTM2TPFEEnginesKey,nil] keyEnumerator];
	while(K = [E nextObject])
	{
		NSString * mode = [self infoForKeyPaths:iTM2TPFEEnginesKey,K,iTM2TPFEScriptModeKey,nil];
		if([mode isEqualToString:iTM2TPFEBaseMode])
		{
			[self setInfo:nil forKeyPaths:iTM2TPFEEnginesKey,K,iTM2TPFEScriptModeKey,nil];
		}
		mode = [self infoForKeyPaths:iTM2TPFEEnginesKey,K,iTM2TPFEEnvironmentModeKey,nil];
		if([mode isEqualToString:iTM2TPFEBaseMode])
		{
			[self setInfo:nil forKeyPaths:iTM2TPFEEnginesKey,K,iTM2TPFEEnvironmentModeKey,nil];
		}
	}
	[self saveChangesForKeyPaths:iTM2TPFEEnginesKey, nil];
//iTM2_END;
    return;
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
	NSString * name = [[self class] commandName];
	// saving the Compile environment
	BOOL yorn = [self saveChangesForKeyPaths:iTM2TPFECommandEnvironmentsKey,name,nil];
	yorn = [self saveChangesForKeyPaths:iTM2TPFEEnginesKey,nil] || yorn;
	yorn = [self saveChangesForKeyPaths:iTM2TPFEEngineScriptsKey,nil] || yorn;
	yorn = [self saveChangesForKeyPaths:iTM2TPFEEngineEnvironmentsKey,nil] || yorn;
	if(yorn)
	{
		[[self document] updateChangeCount:NSChangeDone];
	}
    [super OK:sender];
//iTM2_END;
    return;
}
#pragma mark =-=-=-=-=-=-=-=-=-=-  EDITED ENGINE
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  editedEngine
- (id)editedEngine;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [self contextStringForKey:@"Compile Inspector:Edited Engine" domain:iTM2ContextAllDomainsMask];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setEditedEngine:
- (void)setEditedEngine:(NSString *)argument;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self takeContextValue:argument forKey:@"Compile Inspector:Edited Engine" domain:iTM2ContextAllDomainsMask];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  chooseEngine:
- (IBAction)chooseEngine:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Mar 26 08:41:36 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self setEditedEngine:[(id)[sender selectedItem] representedString]];
    [self iTM2_validateWindowContent];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateChooseEngine:
- (BOOL)validateChooseEngine:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Mar 26 08:41:36 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//NSLog(@"sender is: %@", sender);
    if([sender isKindOfClass:[NSPopUpButton class]])
    {
        if([sender numberOfItems] < 2)
        {
            [sender removeAllItems];
			NSEnumerator * E = [[iTM2TeXPCompilePerformer allBuiltInEngineModes] objectEnumerator];
			id O;
			while(O = [E nextObject])
			{
				if([O isKindOfClass:[NSString class]])
				{
					[sender addItemWithTitle:O];// may be we should use a localized string here
					[[sender lastItem] setRepresentedObject:O];
				}
				else if([O isKindOfClass:[NSArray class]])
				{
					NSMutableString * MS = [NSMutableString string];
					[sender addItemWithTitle:@""];
					NSEnumerator * e = [O objectEnumerator];
					id o;
					suite:
					o = [e nextObject];
					if([o isKindOfClass:[NSString class]])
					{
						[[sender lastItem] setRepresentedObject:o];
						[MS appendString:o];
					}
					else
						goto suite;
					while(o = [e nextObject])
						if([o isKindOfClass:[NSString class]])
							[MS appendFormat:@", %@", o];
					if([MS length])
						[[sender lastItem] setTitle:MS];
				}
			}
//#warning MISSING LOCALE DEBUG
//            [sender addItemWithTitle:@"Other"];//LOCALIZED?
//            [[sender lastItem] setRepresentedObject:@"unknown"];
        }
		NSInteger index = [sender indexOfItemWithRepresentedObject:[self editedEngine]];
		if(index>=0 && index < [sender numberOfItems])
			[sender selectItemAtIndex:index];
		else
			[sender selectItem:[sender lastItem]];
    }
//iTM2_END;
    return YES;
}
#pragma mark =-=-=-=-=-=-=-=-=-=-  ENGINE SCRIPTS MANAGEMENT
- (NSDictionary *)availableBuiltInEngines;
{
	NSString * editedEngine = [self editedEngine];
	NSEnumerator * E = [[self inheritedInfoForKeyPaths:iTM2TPFEEnginesKey,nil] keyEnumerator];
	NSString * engineName = nil;
	id bins = [NSMutableDictionary dictionary];
	while(engineName = [E nextObject])
	{
		NSString * key = [[engineName lastPathComponent] stringByDeletingPathExtension];
		if([key hasPrefix:@"iTM2_Engine_"]
			&& [[self inheritedInfoForKeyPaths:iTM2TPFEEngineEnvironmentsKey,engineName,@"Input",nil] isEqual:editedEngine])
		{
			[bins setObject:engineName forKey:[key substringWithRange:NSMakeRange(12,[key length]-12)]];
		}
	}
	return bins;
}
- (NSDictionary *)availableScriptEngines;
{
	NSBundle * mainBundle = [NSBundle mainBundle];
	NSEnumerator * E = [[mainBundle allPathsForSupportExecutables] objectEnumerator];
	NSString * engineName = nil;
	id bins = [NSMutableDictionary dictionary];
	NSDictionary * builtIn = [self availableBuiltInEngines];// if scripts are overloading built in engines they are not listed here.
	while(engineName = [E nextObject])
	{
		NSString * key = [[engineName lastPathComponent] stringByDeletingPathExtension];
		if([key hasPrefix:@"iTM2_Engine_"] && ![builtIn objectForKey:key])
		{
			[bins setObject:key forKey:[key substringWithRange:NSMakeRange(12,[key length]-12)]];
		}
	}
	return bins;
}
- (NSString *)editedScriptMode;
{
	NSString * editedEngine = [self editedEngine];
	NSString * commandName = [[self class] commandName];
	NSString * mode = [self infoForKeyPaths:iTM2TPFECommandEnvironmentsKey,commandName,editedEngine,iTM2TPFEScriptModeKey,nil];
	if([mode isEqual:iTM2TPFEBaseMode])
	{
		[self setInfo:nil forKeyPaths:iTM2TPFECommandEnvironmentsKey,commandName,editedEngine,iTM2TPFEScriptModeKey,nil];
		mode = [self infoForKeyPaths:iTM2TPFECommandEnvironmentsKey,commandName,editedEngine,iTM2TPFEScriptModeKey,nil];
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
	NSString * editedEngine = [self editedEngine];
	NSString * commandName = [[self class] commandName];
	NSString * newMode = [(id)[sender selectedItem] representedString];
	if([newMode isEqual:iTM2TPFEBaseMode])
	{
		newMode = nil;
	}
	if([self setInfo:newMode forKeyPaths:iTM2TPFECommandEnvironmentsKey,commandName,editedEngine,iTM2TPFEScriptModeKey,nil])
	{
		[self setInfo:newMode forKeyPaths:iTM2TPFECommandEnvironmentsKey,commandName,editedEngine,iTM2TPFEEnvironmentModeKey,nil];
//		[[self document] updateChangeCount:NSChangeDone];
		[self iTM2_validateWindowContent];
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
		NSDictionary * engines = [self availableScriptEngines];
		NSString * engineName = nil;
		NSEnumerator * E = nil;
		NSString * title;
		[[sender menu] addItem:[NSMenuItem separatorItem]];
		if([engines count])
		{
			title = NSLocalizedStringFromTableInBundle(@"Support Scripts", iTM2TeXProjectFrontendTable, myBUNDLE, "Description Forthcoming");
			[sender addItemWithTitle:title];
			[[sender lastItem] setRepresentedObject:@"Disabled"];
			E = [[[engines allKeys] sortedArrayUsingSelector:@selector(compare:)] objectEnumerator];
			while(engineName = [E nextObject])
			{
				[sender addItemWithTitle:engineName];
				[[sender lastItem] setRepresentedObject:[engines objectForKey:engineName]];
				[[sender lastItem] setIndentationLevel:1];
			}
	//iTM2_LOG(@"THE editedCommand IS: %@", [self editedCommand]);
			// This is a consistency test that should also be made before...
			[[sender menu] addItem:[NSMenuItem separatorItem]];
		}
		engines = [self availableBuiltInEngines];
		if([engines count])
		{
			title = NSLocalizedStringFromTableInBundle(@"Built in Scripts", iTM2TeXProjectFrontendTable, myBUNDLE, "Description Forthcoming");
			[sender addItemWithTitle:title];
			[[sender lastItem] setRepresentedObject:@"Disabled"];
			E = [[[engines allKeys] sortedArrayUsingSelector:@selector(compare:)] objectEnumerator];
			while(engineName = [E nextObject])
			{
				[sender addItemWithTitle:engineName];
				[[sender lastItem] setRepresentedObject:[engines objectForKey:engineName]];
				[[sender lastItem] setIndentationLevel:1];
			}
			[[sender menu] addItem:[NSMenuItem separatorItem]];
		}
		title = NSLocalizedStringFromTableInBundle(@"Project Scripts", iTM2TeXProjectFrontendTable, myBUNDLE, "Description Forthcoming");
		[sender addItemWithTitle:title];
		[[sender lastItem] setRepresentedObject:@"Disabled"];
		engines = [self editInfoForKeyPaths:iTM2TPFEEngineScriptsKey,nil];
		if([engines count])
		{
			E = [[[engines allKeys] sortedArrayUsingSelector:@selector(compare:)] objectEnumerator];
			while(engineName = [E nextObject])
			{
				NSString * label = [self editInfoForKeyPaths:iTM2TPFEEngineScriptsKey,engineName,iTM2TPFELabelKey,nil];
				title = [label length]? label:
					[NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"Script %@", iTM2TeXProjectFrontendTable, myBUNDLE, "Description Forthcoming"), engineName];
				[sender addItemWithTitle:title];
				[[sender lastItem] setRepresentedObject:engineName];
				[[sender lastItem] setIndentationLevel:1];
				NSMenuItem * MI = [removeScriptMenu addItemWithTitle:title action:@selector(removeScript:) keyEquivalent:@""];
				[MI setRepresentedObject:engineName];
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
		NSString * scriptMode = [self editedScriptMode];
        NSUInteger idx = -1;
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
//iTM2_END;
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
    NSArray * allEngineModes = [[self infoForKeyPaths:iTM2TPFEEngineScriptsKey,nil] allKeys];
    NSInteger idx = 0;
    NSString * engineMode;
    while((engineMode = [NSString stringWithFormat:@"%i", idx++]), [allEngineModes containsObject:engineMode]);
	NSString * editedEngine = [self editedEngine];
	NSString * commandName = [[self class] commandName];
	[self setInfo:engineMode forKeyPaths:iTM2TPFECommandEnvironmentsKey,commandName,editedEngine,iTM2TPFEScriptModeKey,nil];
	[self setInfo:@"" forKeyPaths:iTM2TPFEEngineScriptsKey,engineMode,iTM2TPFELabelKey,nil];
//	[[self document] updateChangeCount:NSChangeDone];
    [self iTM2_validateWindowContent];
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
    if([self setInfo:nil forKeyPaths:iTM2TPFEEngineScriptsKey, scriptMode, nil])
    {
// remove the script reference for all the commands that used it
		NSString * commandName = [[self class] commandName];
		NSEnumerator * E = [[self infoForKeyPaths:iTM2TPFECommandEnvironmentsKey, commandName, nil] keyEnumerator];
		NSString * name;
		while(name = [E nextObject])
		{
			if([scriptMode isEqual:[self infoForKeyPaths:iTM2TPFECommandEnvironmentsKey, commandName,name,iTM2TPFEScriptModeKey,nil]])
			{
				[self setInfo:nil forKeyPaths:iTM2TPFECommandEnvironmentsKey, commandName,name,iTM2TPFEScriptModeKey,nil];
			}
		}
//		[[self document] updateChangeCount:NSChangeDone];
		[self iTM2_validateWindowContent];
	}
//iTM2_END;
    return;
}
#if 1
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
        iTM2TeXPShellScriptInspector * WC = [[[iTM2TeXPShellScriptInspector alloc]
			initWithWindowNibName: @"iTM2TeXPShellScriptInspector"] autorelease];
		iTM2InfosController * IC = [[[iTM2InfosController alloc] initWithProject:TPD atomic:YES prefixWithKeyPaths:iTM2TPFEEngineScriptsKey,scriptMode,nil] autorelease];
		[WC setInfosController:IC];
		NSWindow * W = [WC window];
		if(W)
		{
			[TPD addWindowController:WC];
			[WC iTM2_validateWindowContent];
			[NSApp beginSheet: W
					modalForWindow: [self window]
					modalDelegate: self
					didEndSelector: @selector(editScriptSheetDidEnd:returnCode:context:)
					contextInfo: nil];
		}
		else
		{
			iTM2_LOG(@"A window named iTM2TeXPShellScriptInspector was expected");
		}
    }
    else
        iTM2Beep();
//iTM2_END;
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
//iTM2_END;
	return [[[self infoForKeyPaths: iTM2TPFEEngineScriptsKey,nil] allKeys] containsObject:[self editedScriptMode]];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  editScriptSheetDidEnd:returnCode:context:
- (void)editScriptSheetDidEnd:(NSWindow *)sheet returnCode:(NSInteger)returnCode context:(id)irrelevant;
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
    [self iTM2_validateWindowContent];
//iTM2_END;
    return;
}
#pragma mark =-=-=-=-=-=-=-=-=-=-  OPTIONS
- (NSString *)editedEnvironmentMode;
{
	NSString * editedEngine = [self editedEngine];
	NSString * commandName = [[self class] commandName];
	NSString * mode = [self infoForKeyPaths:iTM2TPFECommandEnvironmentsKey,commandName,editedEngine,iTM2TPFEEnvironmentModeKey,nil];
	if([mode isEqual:iTM2TPFEBaseMode])
	{
		[self setInfo:nil forKeyPaths:iTM2TPFECommandEnvironmentsKey,commandName,editedEngine,iTM2TPFEEnvironmentModeKey,nil];
		mode = [self infoForKeyPaths:iTM2TPFECommandEnvironmentsKey,commandName,editedEngine,iTM2TPFEEnvironmentModeKey,nil];
		if([mode isEqual:iTM2TPFEBaseMode])
		{
			mode = nil;
		}
	}
	if(!mode)
	{
		mode = editedEngine;
	}
	return mode;
}
- (BOOL)isCustomEnvironmentMode;
{
	return [self editInfoForKeyPaths:iTM2TPFEEngineEnvironmentsKey,[self editedEnvironmentMode],nil]!=nil;
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
//iTM2_LOG(@"\noldEnvironmentMode is: %@\nnewEnvironmentMode is: %@", oldEnvironmentMode, newEnvironmentMode);
	NSString * environmentMode = [(id)[sender selectedItem] representedString];
	if([environmentMode isEqual:iTM2TPFECustomMode])
	{
		environmentMode = [self editedEnvironmentMode];
		// if there were something already customized, retrieve it
		if([self restoreCustomForKeyPaths:iTM2TPFEEngineEnvironmentsKey,environmentMode,nil]
			|| [self setInfo:[NSMutableDictionary dictionary] forKeyPaths:iTM2TPFEEngineEnvironmentsKey,environmentMode,nil])
		{
			NSAssert([self isCustomEnvironmentMode],@"Custom environment mode expected");
//				[[self document] updateChangeCount:NSChangeDone];
			[self iTM2_validateWindowContent];
		}
	}
	else if([environmentMode isEqual:iTM2TPFEBaseMode])
	{
		environmentMode = [self editedEnvironmentMode];
		[self backupCustomForKeyPaths:iTM2TPFEEngineEnvironmentsKey,environmentMode,nil];
		[self setInfo:nil forKeyPaths:iTM2TPFEEngineEnvironmentsKey,environmentMode,nil];
//			[[self document] updateChangeCount:NSChangeDone];
		[self iTM2_validateWindowContent];
	}
//iTM2_END;
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
			|| [[[self editInfoForKeyPaths:iTM2TPFEEngineScriptsKey,nil] allKeys] containsObject:scriptMode])
		{
			return NO;
		}
		return YES;
	}
//iTM2_LOG(@"environmentMode is: %@", environmentMode);
    else if([sender isKindOfClass:[NSPopUpButton class]])
	{
		[sender removeAllItems];
		// if the script mode is one of the built in engines
		// the environment must be eponym, when it exists
		// either we have base options or we have custom ones
		// there are only two possibilities
		if([self inheritedInfoForKeyPaths:iTM2TPFEEngineEnvironmentsKey,scriptMode,nil])
		{
			[sender addItemWithTitle:NSLocalizedStringFromTableInBundle(@"Base", iTM2TeXProjectFrontendTable, myBUNDLE, "...")];
			[[sender lastItem] setRepresentedObject:iTM2TPFEBaseMode];
			[sender addItemWithTitle:NSLocalizedStringFromTableInBundle(@"Custom", iTM2TeXProjectFrontendTable, myBUNDLE, "...")];
			[[sender lastItem] setRepresentedObject:iTM2TPFECustomMode];
			// it is base if there is not edit environment
			if([self editInfoForKeyPaths:iTM2TPFEEngineEnvironmentsKey,scriptMode,nil])
			{
				[sender selectItemAtIndex:[sender indexOfItemWithRepresentedObject:iTM2TPFECustomMode]];
			}
			else
			{
				[sender selectItemAtIndex:[sender indexOfItemWithRepresentedObject:iTM2TPFEBaseMode]];
			}
			return YES;
		}
		[sender addItemWithTitle:NSLocalizedStringFromTableInBundle(@"No options", iTM2TeXProjectFrontendTable, myBUNDLE, "...")];
		[[sender lastItem] setRepresentedObject:iTM2TPFEVoidMode];
		[sender selectItemAtIndex:0];
		return NO;
	}
//iTM2_END;
    return NO;
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
		NSString * editedEngine = [self editedEngine];
        iTM2TeXProjectDocument * TPD = [self document];
		NSString * environmentMode = [self infoForKeyPaths:iTM2TPFEEnginesKey,editedEngine,iTM2TPFEEnvironmentModeKey,nil];
		Class C = [iTM2TeXPEngineInspector classForMode:environmentMode];
        iTM2TeXPCommandInspector * WC = [[[C alloc] initWithWindowNibName:[C windowNibName]] autorelease];
		[TPD addWindowController:WC];// now [WC document] == TPD, and WC is retained, the WC document is the project
		iTM2InfosController * IC = [[[iTM2InfosController alloc] initWithProject:TPD atomic:YES prefixWithKeyPaths:iTM2TPFEEngineEnvironmentsKey, environmentMode, nil] autorelease];
		[WC setInfosController:IC];
		NSWindow * W = [WC window];// may validate the window content as side effect
        if(W)
        {
//iTM2_LOG(@"The inspector is: %@", WC);
			if(iTM2DebugEnabled>100)
			{
				iTM2_LOG(@"Starting to edit environment mode: %@", environmentMode);
			}
			[W setExcludedFromWindowsMenu:YES];
//iTM2_LOG(@"BEFORE iTM2_validateWindowContent, [WC document] is: %@ and W is: %@", [WC document], W);
            [NSApp beginSheet: W
                    modalForWindow: [self window]
                    modalDelegate: self
                    didEndSelector: @selector(editOptionsSheetDidEnd:returnCode:irrelevant:)
                    contextInfo: nil];// will be released below
        }
        else
        {
            iTM2_LOG(@"Could not find a class for: %@", environmentMode);
			[TPD removeWindowController:WC];
        }
    }
    else
        iTM2Beep();
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  editOptionsSheetDidEnd:returnCode:environmentMode:
- (void)editOptionsSheetDidEnd:(NSWindow *)sheet returnCode:(NSInteger)returnCode irrelevant:(void *)unused;
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
//iTM2_END;
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
	// base projects only have custom options settings
//	if([SPC isBaseProject:TPD])
//		return NO;
	NSString * editedEngine = [self editedEngine];
	NSString * environmentMode = [self infoForKeyPaths:iTM2TPFEEnginesKey,editedEngine,iTM2TPFEEnvironmentModeKey,nil];
	if([environmentMode isEqualToString:iTM2TPFEBaseMode])
	{
		[self setInfo:nil forKeyPaths:iTM2TPFEEnginesKey,editedEngine,iTM2TPFEEnvironmentModeKey,nil];
		environmentMode = [self infoForKeyPaths:iTM2TPFEEnginesKey,editedEngine,iTM2TPFEEnvironmentModeKey,nil];
	}
	if(![environmentMode length] || [environmentMode isEqualToString:iTM2TPFEVoidMode] || [environmentMode isEqualToString:iTM2TPFEBaseMode])
	{
		return NO;
	}
    else
    {
		NSPointerArray * PA = [iTM2TeXPEngineInspector engineReferences];
		NSUInteger i = [PA count];
		while(i--)
		{
			Class C = (Class)[PA pointerAtIndex:i];
			if([environmentMode isEqual:[C engineMode]])
                return YES;
		}
    }
//iTM2_END;
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  defaultEngine:
- (IBAction)defaultEngine:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Mar 26 08:41:36 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSString * editedEngine = [self editedEngine];
	[self setInfo:nil forKeyPaths:iTM2TPFECommandEnvironmentsKey,[[self class] commandName],editedEngine,nil];
	NSString * scriptMode = [self editedScriptMode];
	NSString * environmentMode = [self infoForKeyPaths:iTM2TPFEEnginesKey,scriptMode,iTM2TPFEEnvironmentModeKey,nil];
	// if there is a customized stuff here, we backup in the customInfos
	[self backupCustomForKeyPaths:iTM2TPFEEngineEnvironmentsKey,environmentMode,nil];
	[self setInfo:nil forKeyPaths:iTM2TPFEEngineEnvironmentsKey,environmentMode,nil];
	// the scripts are not removed because it is difficult to have them back
	// removing scripts should be made by hand.
	[self iTM2_validateWindowContent];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateDefaultEngine:
- (BOOL)validateDefaultEngine:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Mar 26 08:41:36 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([self editInfoForKeyPaths:iTM2TPFECommandEnvironmentsKey,[[self class] commandName],[self editedEngine],nil] != nil)
		return YES;
	NSString * scriptMode = [self editedScriptMode];
	NSString * environmentMode = [self infoForKeyPaths:iTM2TPFEEnginesKey,scriptMode,iTM2TPFEEnvironmentModeKey,nil];
	if([environmentMode isKindOfClass:[NSDictionary class]])
	{
		iTM2_LOG(@"! ERROR");
	}
	if(	[self editInfoForKeyPaths:iTM2TPFEEngineEnvironmentsKey,environmentMode,nil])
		return YES;
//iTM2_END;
    return NO;
}
#endif
#pragma mark =-=-=-=-=-  TAB VIEW
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  tabView
- (NSTabView *)tabView;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/11/01)
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSTabView * TV = metaGETTER;
    if(!TV)
    {
        [self window];
        TV = metaGETTER;
    }
    return TV;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setTabView:
- (void)setTabView:(NSTabView *)argument;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/11/01)
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(argument && ![argument isKindOfClass:[NSTabView class]])
        [NSException raise: NSInvalidArgumentException format: @"%@ NSTabView class expected, got: %@.",
            __iTM2_PRETTY_FUNCTION__, argument];
    else
    {
        NSTabView * old = metaGETTER;
        if(old != argument)
        {
            [old setDelegate:nil];
            metaSETTER(argument);
            [argument setDelegate:self];
        }
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  tabView:didSelectTabViewItem:
- (void)tabView:(NSTabView *)tabView didSelectTabViewItem:(NSTabViewItem *)tabViewItem;
/*"Description forthcoming. Automatically called.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self takeContextValue:[tabViewItem identifier] forKey:@"Compile Inspector:Tab View Item Identifier" domain:iTM2ContextAllDomainsMask];
//    [self iTM2_validateWindowContent]; now in the validation kit
//iTM2_END;
    return;
}
#if 0
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  tabView:shouldSelectTabViewItem:
- (BOOL)tabView:(NSTabView *)tabView shouldSelectTabViewItem:(NSTabViewItem *)tabViewItem;
/*"Description forthcoming. Automatically called.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  tabView:willSelectTabViewItem:
- (void)tabView:(NSTabView *)tabView willSelectTabViewItem:(NSTabViewItem *)tabViewItem;
/*"Description forthcoming. Automatically called.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  tabViewDidChangeNumberOfTabViewItems:
- (void)tabViewDidChangeNumberOfTabViewItems:(NSTabView *)TabView;
/*"Description forthcoming. Automatically called.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return;
}
#endif
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  saveDocument:
- (IBAction)saveDocument:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Mar 26 08:41:36 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateSaveDocument:
- (BOOL)validateSaveDocument:(id <NSMenuItem>)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Mar 26 08:41:36 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return NO;
//iTM2_END;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  saveDocumentAs:
- (IBAction)saveDocumentAs:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Mar 26 08:41:36 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateSaveDocumentAs:
- (BOOL)validateSaveDocumentAs:(id <NSMenuItem>)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Mar 26 08:41:36 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return NO;
//iTM2_END;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  saveDocumentTo:
- (IBAction)saveDocumentTo:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Mar 26 08:41:36 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateSaveDocumentTo:
- (BOOL)validateSaveDocumentTo:(id <NSMenuItem>)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Mar 26 08:41:36 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return NO;
//iTM2_END;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  revertDocumentToSaved:
- (IBAction)revertDocumentToSaved:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Mar 26 08:41:36 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateRevertDocumentToSaved:
- (BOOL)validateRevertDocumentToSaved:(id <NSMenuItem>)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Mar 26 08:41:36 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return NO;
//iTM2_END;
}
@end

NSString * const iTM2ContinuousCompile = @"iTM2_ContinuousCompile";

@implementation iTM2TeXPContinuousPerformer
+ (NSInteger)commandGroup;
{iTM2_DIAGNOSTIC;
	return 10;
}
+ (NSInteger)commandLevel;
{iTM2_DIAGNOSTIC;
	return 100;
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
	iTM2TeXProjectDocument * TPD = [SPC TeXProjectForSource:nil];
	[TPD takeContextBool: ![TPD contextBoolForKey:iTM2ContinuousCompile domain:iTM2ContextAllDomainsMask] forKey:iTM2ContinuousCompile domain:iTM2ContextAllDomainsMask];
	[TPD updateChangeCount:NSChangeDone];
    return;
//iTM2_END;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validatePerformCommand:
+ (BOOL)validatePerformCommand:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	iTM2TeXProjectDocument * TPD = [SPC TeXProjectForSource:nil];
	[sender setState: ([TPD contextBoolForKey:iTM2ContinuousCompile domain:iTM2ContextAllDomainsMask]? NSOnState:NSOffState)];
    return TPD != nil;
//iTM2_END;
}
@end

#import "iTM2TeXProjectTaskKit.h"

NSString * const iTM2ContinuousCompileDelay = @"iTM2ContinuousCompileDelay";

@implementation iTM2TeXPCompilePerformer
+ (void)initialize;
{iTM2_DIAGNOSTIC;
	[super initialize];
	[SUD registerDefaults:[NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:5] forKey:iTM2ContinuousCompileDelay]];
	return;
}
+ (NSInteger)commandGroup;
{iTM2_DIAGNOSTIC;
	return 10;
}
+ (NSInteger)commandLevel;
{iTM2_DIAGNOSTIC;
	return 10;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  allBuiltInEngineModes
+ (NSArray *)allBuiltInEngineModes;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	static NSMutableArray * allBuiltInEngineModes = nil;
	if(!allBuiltInEngineModes)
	{
		// the purpose of the CompileFileExtensions.plist is to order the list of built in engine modes
		// all other extensions possibly declared in a plugin will be listed after this default list
		NSString * P = [[[NSBundle mainBundle] pathsForSupportResource:@"CompileFileExtensions" ofType:@"plist" inDirectory:@"TeX" domains:NSAllDomainsMask] lastObject];
		if(![P length])
		{
			P = [myBUNDLE pathForResource:@"CompileFileExtensions" ofType:@"plist"];
			if(![P length])
			{
				iTM2_LOG(@"There is a missing CompileFileExtensions.plist file");
			}
		}
		allBuiltInEngineModes = [NSMutableArray arrayWithContentsOfFile:P];
		NSMutableSet * MS = [NSMutableSet set];
		NSPointerArray * PA = [iTM2TeXPEngineInspector engineReferences];
		NSUInteger i = [PA count];
		while(i--)
		{
			Class C = (Class)[PA pointerAtIndex:i];
            [MS addObjectsFromArray:[C inputFileExtensions]];
		}
		NSMutableSet * ms = [NSMutableSet setWithArray:allBuiltInEngineModes];
		for(NSArray * RA in allBuiltInEngineModes)
		{
			if([RA isKindOfClass:[NSArray class]])
			{
				[ms addObjectsFromArray:RA];
			}
		}
		[MS minusSet:ms];
		[allBuiltInEngineModes addObjectsFromArray:[MS allObjects]];
	}
//iTM2_END;
    return allBuiltInEngineModes;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  builtInEngineModes
+ (NSArray *)builtInEngineModes;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	static NSArray * builtInEngineModes = nil;
	if(!builtInEngineModes)
	{
		NSMutableArray * MRA = [NSMutableArray array];
		for(id O in [self allBuiltInEngineModes])
		{
			if([O isKindOfClass:[NSString class]])
			{
				[MRA addObject:O];
			}
			else if([O isKindOfClass:[NSArray class]])
			{
				for(id o in O)
				{
					if([o isKindOfClass:[NSString class]])
					{
						[MRA addObject:o];
						break;
					}
				}
			}
		}
		builtInEngineModes = [MRA copy];
	}
//iTM2_END;
    return builtInEngineModes;
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
//iTM2_LOG(@"I HAVE BEEN NOTIFIED OF THE TASK TERMINATION");
	[userInfo autorelease];
	iTM2TeXProjectDocument * TPD = [[userInfo objectForKey:@"ProjectRef"] nonretainedObjectValue];
	if([SPC isProject:TPD])
	{
		if([TPD contextBoolForKey:iTM2ContinuousCompile domain:iTM2ContextAllDomainsMask])
		{
			[NSTimer scheduledTimerWithTimeInterval:[self contextFloatForKey:iTM2ContinuousCompileDelay domain:iTM2ContextAllDomainsMask] target: self
				selector: @selector(_delayedPerformCommand:) userInfo: userInfo repeats: NO];
		}
	}
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  _delayedPerformCommand:
+ (void)_delayedPerformCommand:(NSTimer *)timer;
/*"Here come the actions to be performed when the Index task has completed.
userInfo is still owned by the receiver and should be released.
Subclassers will prepend their own stuff.
Version History: jlaurens AT users DOT sourceforge DOT net 
- 1: 09/02/2001
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	iTM2TeXProjectDocument * TPD = [[[timer userInfo] objectForKey:@"ProjectRef"] nonretainedObjectValue];
	if([SPC isProject:TPD])
	{
		NSEnumerator * E = [[TPD subdocuments] objectEnumerator];
		NSDocument * D;
		while(D = [E nextObject])
			if([D isDocumentEdited])
			{
				if([self mustSaveProjectDocumentsBefore])
				{
					[TPD saveDocument:nil];
			//		[project writeSafelyToURL:[TPD fileURL] ofType:[TPD fileType] forSaveOperation:NSSaveOperation error:nil];
				}
				[self doPerformCommandForProject:TPD];
//EQUIV
//				[self performCommandForProject:TPD];
				return;
			}
		if([TPD contextBoolForKey:iTM2ContinuousCompile domain:iTM2ContextAllDomainsMask])
		{
			[NSTimer scheduledTimerWithTimeInterval:[self contextFloatForKey:iTM2ContinuousCompileDelay domain:iTM2ContextAllDomainsMask] target: self
				selector: @selector(_delayedPerformCommand:) userInfo: [timer userInfo] repeats:NO];
		}
	}
    return;
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
	NSString * commandName = [self commandName];
	NSString * scriptMode = [self infoForKeyPaths:iTM2TPFECommandsKey,commandName,iTM2TPFEScriptModeKey,nil];
	
	if([scriptMode isEqual:iTM2TPFEBaseMode])
	{
		[self setInfo:nil forKeyPaths:iTM2TPFECommandsKey,commandName,iTM2TPFEScriptModeKey,nil];
		scriptMode = [self infoForKeyPaths:iTM2TPFECommandsKey,commandName,iTM2TPFEScriptModeKey,nil];
		if([scriptMode isEqual:iTM2TPFEBaseMode])
		{
			[self setInfo:iTM2TPFEVoidMode forKeyPaths:iTM2TPFECommandsKey,commandName,iTM2TPFEScriptModeKey,nil];
			scriptMode = [self infoForKeyPaths:iTM2TPFECommandsKey,commandName,iTM2TPFEScriptModeKey,nil];
		}
	}
	if([scriptMode length])
	{
		NSString * label = [self infoForKeyPaths:iTM2TPFECommandScriptsKey,scriptMode,iTM2TPFELabelKey,nil];
		if([label length])
			return [NSString stringWithFormat: @"%@ (%@)",
				[super menuItemTitleForProject:project], label];
	}
//iTM2_END;
    return [super menuItemTitleForProject:project];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validatePerformCommand:
+ (BOOL)validatePerformCommand:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(![sender image])
	{
		NSImage * I = [NSImage iTM2_cachedImageNamed:@"compilePerformer"];
		if(![I iTM2_isNotNullImage])
		{
			I = [[NSImage iTM2_cachedImageNamed:@"typesetCurrentProject"] copy];
			[I setName:@"compilePerformer"];
			[I iTM2_setSizeSmallIcon];
		}
		[sender setImage:I];//size
	}
    return [super validatePerformCommand:(id)sender];
//iTM2_END;
}
@end

@implementation iTM2Window(iTM2UndoManager)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  hasSmartUndo
- (BOOL)hasSmartUndo;// smart undo is disabled in continuous mode
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net.
To do list:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id TPD = [SPC projectForSource:self];
//iTM2_END;
    return ![TPD contextBoolForKey:iTM2ContinuousCompile domain:iTM2ContextAllDomainsMask] && [self contextBoolForKey:iTM2UDSmartUndoKey domain:iTM2ContextAllDomainsMask];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  canToggleSmartUndo
- (BOOL)canToggleSmartUndo;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net.
To do list:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id TPD = [SPC projectForSource:self];
//iTM2_END;
    return ![TPD contextBoolForKey:iTM2ContinuousCompile domain:iTM2ContextAllDomainsMask];
}
@end

//#import <iTM2Foundation/iTM2BundleKit.h>
//#import <iTM2Foundation/iTM2Runtime.h>

@implementation NSBundle(iTM2CompileWrapperKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  installBinaryWithName:
- (void)installBinaryWithName:(NSString *)aName;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
	iTM2_INIT_POOL;
//iTM2_START;
	NSString * path = [@"bin" stringByAppendingPathComponent:aName];
	NSString * executable = [self pathForAuxiliaryExecutable:path];
	if([executable length])
	{
		NSError * error = nil;
		if(![NSBundle createSymbolicLinkWithExecutableContent:executable error: &error])
		{
			[NSApp presentError:error];
		}
	}
	else
	{
		NSBundle * bundle = [iTM2TeXPEngineInspector classBundle];
		[NSApp presentError: [NSError errorWithDomain: iTM2TeXFoundationErrorDomain code: 1 userInfo:
				[NSDictionary dictionaryWithObjectsAndKeys:
					NSLocalizedStringFromTableInBundle(@"Setup failure", iTM2LocalizedExtension, bundle, ""), NSLocalizedDescriptionKey,
					[NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"Missing executable %@ in bundle %@", iTM2LocalizedExtension, bundle, ""), aName, bundle], NSLocalizedFailureReasonErrorKey,
					NSLocalizedStringFromTableInBundle(@"Reinstall iTeXMac2 and if it happens again, report a bug", iTM2LocalizedExtension, bundle, ""), NSLocalizedRecoverySuggestionErrorKey,
						nil]]];
		iTM2_LOG(@".........  ERROR: Missing executable (bundle: %@, aName: %@, target, %@)...",
			bundle, aName, executable);
	}
//iTM2_END;
	iTM2_RELEASE_POOL;
    return;
}
@end

NSString * const iTM2TeXProjectEngineTable = @"Engine";

@implementation iTM2TeXPEngineInspector
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initialize
+ (void)initialize;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
	iTM2_INIT_POOL;
//iTM2_START;
	[iTM2TeXPEngineInspector installBinary];
//iTM2_END;
	iTM2_RELEASE_POOL;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  installBinary
+ (void)installBinary;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
	iTM2_INIT_POOL;
//iTM2_START;
	NSString * name = [self engineMode];
	name = [name stringByAppendingPathExtension:@"rb"];
	[[self classBundle] installBinaryWithName:name];
//iTM2_END;
	iTM2_RELEASE_POOL;
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
	NSPointerArray * PA = [iTM2TeXPEngineInspector engineReferences];
	NSUInteger i = [PA count];
	while(i--)
	{
		Class C = (Class)[PA pointerAtIndex:i];
		if([[C engineMode] isEqualToString:action])
			return C;
	}
    return Nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  engineMode
+ (NSString *)engineMode;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return @"iTM2_Engine_Unknown";
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  prettyEngineMode
+ (NSString *)prettyEngineMode;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return NSLocalizedStringFromTableInBundle([self engineMode], iTM2TeXProjectEngineTable, myBUNDLE, "Description Forthcoming");
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
    return [[self prettyEngineMode] compare:[rhs prettyEngineMode]];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  engineReferences
+ (NSPointerArray *)engineReferences;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [iTM2Runtime subclassReferencesOfClass:[iTM2TeXPEngineInspector class]];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inputFileExtensions
+ (NSArray *)inputFileExtensions;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [NSArray array];
}
#if 0
I don''t remember why I put this here
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  tabView:didSelectTabViewItem:
- (void)tabView:(NSTabView *)tabView didSelectTabViewItem:(NSTabViewItem *)tabViewItem;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self iTM2_validateWindowContent];
//iTM2_END;
    return;
}
#endif
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2TeXPCompileWrapperKit


