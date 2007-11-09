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

NSString * const iTM2TPFEEnginesKey = @"Engines";// model
NSString * const iTM2TPFEEngineEnvironmentsKey = @"EngineEnvironments";
NSString * const iTM2TPFEEngineScriptsKey = @"EngineScripts";


@interface iTM2TeXPCompileInspector(PRIVATE)
- (id)editedEngine;
- (void)setEditedEngine:(NSString *)argument;
- (id)editedProject;
- (void)setEditedProject:(id)argument;
- (NSTabView *)tabView;
@end

@interface iTM2TeXPCompilePerformer: iTM2TeXPCommandPerformer
@end

@interface iTM2TeXPContinuousPerformer: iTM2TeXPCommandPerformer
@end

@interface iTM2TeXPCompilePerformer(PRIVATE)
+ (NSArray *)allBuiltInEngineModes;
+ (NSArray *)builtInEngineModes;
+ (NSDictionary *)environmentWithDictionary:(NSDictionary *)environment forProject:(iTM2TeXProjectDocument *)project;
@end

@implementation iTM2TeXPCommandsInspector(Compile)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  doEngineCompleteBackupModel
- (void)doEngineCompleteBackupModel;
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
		[self takeModelBackup:[[[TPD engines] copy] autorelease] forKey:iTM2TPFEEnginesKey];
		[self takeModelBackup:[[[TPD engineScripts] copy] autorelease] forKey:iTM2TPFEEngineScriptsKey];
		[self takeModelBackup:[[[TPD engineEnvironments] copy] autorelease] forKey:iTM2TPFEEngineEnvironmentsKey];
	}
	else
	{
		iTM2_LOG(@"NO PROJECT TO BACK UP...");
	}	
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  doEngineCompleteRestoreModel
- (void)doEngineCompleteRestoreModel;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    id TPD = (iTM2TeXProjectDocument *)[self document];
	[TPD setEngineWrappers:nil];// the command wrappers will be recreated from the correct model
	NSDictionary * newD = [self modelBackupForKey:iTM2TPFEEngineEnvironmentsKey];
	if(newD)
	{
		NSDictionary * D = [TPD engineEnvironments];
		NSEnumerator * E = [D keyEnumerator];
		NSString * engineName;
		while(engineName = [E nextObject])
			[TPD takeEnvironment:nil forEngineMode:engineName];
		E = [newD keyEnumerator];
		while(engineName = [E nextObject])
			[TPD takeEnvironment:[newD objectForKey:engineName] forEngineMode:engineName];
	}
	else
	{
		iTM2_LOG(@"NOTHING TO RESTORE, VERY BAD!!!");
	}
	newD = [self modelBackupForKey:iTM2TPFEEngineScriptsKey];
	if(newD)
	{
		NSDictionary * D = [TPD engineEnvironments];
		NSEnumerator * E = [D keyEnumerator];
		NSString * engineName;
		while(engineName = [E nextObject])
			[TPD takeScriptDescriptor:nil forEngineMode:engineName];
		E = [newD keyEnumerator];
		while(engineName = [E nextObject])
			[TPD takeScriptDescriptor:[newD objectForKey:engineName] forEngineMode:engineName];
	}
	else
	{
		iTM2_LOG(@"(engine scripts)NOTHING TO RESTORE, VERY BAD!!!");
	}
	newD = [self modelBackupForKey:iTM2TPFEEnginesKey];
	if(newD)
	{
		NSDictionary * D = [TPD engines];
		NSEnumerator * E = [D keyEnumerator];
		NSString * engineName;
		while(engineName = [E nextObject])
			[TPD takeModel:nil forEngineName:engineName];
//iTM2_LOG(@"THE ENGINES RETRIEVED ARE: %@", [self modelBackupForKey:iTM2TPFEEnginesKey]);
		E = [newD keyEnumerator];
		while(engineName = [E nextObject])
			[TPD takeModel:[newD objectForKey:engineName] forEngineName:engineName];
	}
	else
	{
		iTM2_LOG(@"(engines)NOTHING TO RESTORE, VERY BAD!!!");
	}
//iTM2_END;
    return;
}
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
    int index = [TV indexOfTabViewItemWithIdentifier:identifier];
    if(index !=  NSNotFound)
        [TV selectTabViewItemAtIndex:index];
    [super windowDidLoad];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateWindowContent
- (BOOL)validateWindowContent;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	// [self document] must be set,
	// you can't use initImplementation, only a late implementation
	if(![self editedProject])
	{
		iTM2TeXProjectDocument * TPD = (iTM2TeXProjectDocument *)[self document];
//iTM2_LOG(@"AFTER, [self document] is: %@", [self document]);
		iTM2TeXProjectDocument * myTPD = [[[[TPD class] allocWithZone:[TPD zone]] init] autorelease];
		// what I need for that editable copy myTPD is:
		// - the engine wrappers
		// - the engine scripts
		// - the engine environments
		// convenient info is the rest
		// - TWS information, read only
		// - the base project
		id projectImplementation = [TPD implementation];
		id myProjectImplementation = [myTPD implementation];
		NSData * D = [projectImplementation dataRepresentationOfModelOfType:iTM2TeXProjectInfoType];
		if(D && ![myProjectImplementation loadModelValueOfDataRepresentation:D ofType:iTM2TeXProjectInfoType])
		{
			iTM2_LOG(@"***: There is a problem, minor at first glance");
		}
		D = [projectImplementation dataRepresentationOfModelOfType:iTM2ProjectFrontendType];
		if(D && ![myProjectImplementation loadModelValueOfDataRepresentation:D ofType:iTM2ProjectFrontendType])
		{
			iTM2_LOG(@"***: There is a problem, minor at first glance");
		}
		NSString * name;
		NSEnumerator * E = [[TPD engineScripts] keyEnumerator];
		while(name = [E nextObject])
		{
			[myTPD takeScriptDescriptor:[TPD scriptDescriptorForEngineMode:name] forEngineMode:name];
		}
		E = [[TPD engineEnvironments] keyEnumerator];
		while(name = [E nextObject])
		{
			[myTPD takeEnvironment:[TPD environmentForEngineMode:name] forEngineMode:name];
		}
		[myTPD takeEnvironment:[TPD environmentForEngineMode:iTM2ProjectDefaultsKey] forEngineMode:iTM2ProjectDefaultsKey];
		E = [[iTM2TeXPCompilePerformer builtInEngineModes] objectEnumerator];
		NSMutableArray * MRA = [NSMutableArray array];
		while(name = [E nextObject])
		{
			iTM2TeXPEngineWrapper * CW = [[[iTM2TeXPEngineWrapper allocWithZone:[self zone]] init] autorelease];
			[CW setName:name];
			[CW setProject:myTPD];
			[CW setModel:[TPD modelForEngineName:name]];
			[MRA addObject:CW];
//iTM2_LOG(@"name is: %@, [TPD modelForEngineName:name] : %@", name, [TPD modelForEngineName:name]);
		}
		[myTPD setEngineWrappers:MRA];
		if(myTPD)
		{
			[self setEditedProject:myTPD];
		}
		else
		{
			iTM2_LOG(@"\n\n\nERROR: things won't work as expected\n\n\n");
		}
//iTM2_LOG(@"[TPD engineEnvironments] are: %@", [TPD engineEnvironments]);
//iTM2_LOG(@"[myTPD engineEnvironments] are: %@", [myTPD engineEnvironments]);
	}
	// fixing the project consistency:
	// this is something to be done when the project opens, perhaps.
	iTM2TeXProjectDocument * TPD = [self editedProject];
//iTM2_LOG(@"0-- [self editedProject] is: %@ with engines: %@", TPD, [TPD engines]);
	NSString * editedEngine = [self editedEngine];
	iTM2TeXPEngineWrapper * CW = [TPD engineWrapperForName:editedEngine];
//iTM2_LOG(@"1-- CW is: %@", CW);
	NSString * environmentMode = [CW environmentMode];
	if(![environmentMode length])
	{
		[CW setEnvironmentMode:iTM2TPFEVoidMode];
		environmentMode = [CW environmentMode];
	}
	NSString * scriptMode = [CW scriptMode];
	if([scriptMode isEqualToString:iTM2TPFEBaseMode])
	{
		// the script is inherited: the option must be either inherited or eponym when customized
		if([environmentMode isEqualToString:iTM2TPFEVoidMode])
			[CW setEnvironmentMode:iTM2TPFEBaseMode];
		else if(![environmentMode isEqualToString:iTM2TPFEBaseMode]
				&& [SPC isBaseProject:TPD])
			[CW setEnvironmentMode:[[[TPD baseProject] engineWrapperForName:editedEngine] environmentMode]];
	}
//iTM2_LOG(@"2-- CW is: %@", CW);
//iTM2_END;
    return [super validateWindowContent];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  editedProject
- (id)editedProject;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return metaGETTER;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setEditedProject:
- (void)setEditedProject:(id)argument;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	metaSETTER(argument);
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  OK:
- (IBAction)OK:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	BOOL change = NO;
	iTM2TeXProjectDocument * TPD = (iTM2TeXProjectDocument *)[self document];
	iTM2TeXProjectDocument * myTPD = [self editedProject];
	NSString * name = nil;
	NSMutableArray * removeKeys = [[[[TPD engineScripts] allKeys] mutableCopy] autorelease];
	[removeKeys removeObjectsInArray:[[myTPD engineScripts] allKeys]];
	NSEnumerator * E = [[myTPD engineScripts] keyEnumerator];
	id old = nil;
	id new = nil;
	while(name = [E nextObject])
	{   
		old = [TPD scriptDescriptorForEngineMode:name];
		new = [myTPD scriptDescriptorForEngineMode:name];
		if(![new isEqual:old])
		{
			[TPD takeScriptDescriptor:new forEngineMode:name];
			change = YES;
//iTM2_LOG(@"CHANGE: script descriptor added or modified");
		}
		else
		{
//iTM2_LOG(@"NO CHANGE: %@ is equal %@", old, new);
		}
	}
	if([removeKeys count])
	{
		change = YES;
		E = [removeKeys objectEnumerator];
		while(name = [E nextObject])
			[TPD takeScriptDescriptor:nil forEngineMode:name];
//iTM2_LOG(@"CHANGE: script descriptor deleted");
	}
//iTM2_LOG(@"UPDATING THE ENVIRONMENTS");
	removeKeys = [[[[TPD engineEnvironments] allKeys] mutableCopy] autorelease];
	[removeKeys removeObjectsInArray:[[myTPD engineEnvironments] allKeys]];
	E = [[myTPD engineEnvironments] keyEnumerator];
	while(name = [E nextObject])
	{
		old = [TPD environmentForEngineMode:name];
		new = [myTPD environmentForEngineMode:name];
		if(![new isEqual:old])
		{
			[TPD takeEnvironment:new forEngineMode:name];
			change = YES;
//iTM2_LOG(@"CHANGE: environment added or modified");
		}
		else
		{
//iTM2_LOG(@"SAME ENVIRONMENT FOR NAME: %@", name);
		}
	}
	old = [TPD environmentForEngineMode:iTM2ProjectDefaultsKey];
	new = [myTPD environmentForEngineMode:iTM2ProjectDefaultsKey];
	if(![new isEqual:old])
	{
		[TPD takeEnvironment:new forEngineMode:name];
		change = YES;
//iTM2_LOG(@"CHANGE: environment added or modified");
	}
	else
	{
//iTM2_LOG(@"SAME ENVIRONMENT FOR NAME: %@", name);
	}
	if([removeKeys count])
	{
		change = YES;
		E = [removeKeys objectEnumerator];
		while(name = [E nextObject])
			[TPD takeEnvironment:nil forEngineMode:name];
//iTM2_LOG(@"CHANGE: environment deleted");
	}
//iTM2_LOG(@"UPDATING THE ENVIRONMENTS: DONE");
	E = [[myTPD engineWrappers] objectEnumerator];
	iTM2CommandWrapper *  O = nil;
	while(O = [E nextObject])
	{
		new = [O model];
//iTM2_LOG(@"new is: %@, [O name] is: %@", new, [O name]);
		old = [TPD modelForEngineName:[O name]];
		if(![old isEqual:new])
		{
			[TPD takeModel:new forEngineName:[O name]];
			change = YES;
		}
	}
	[TPD setEngineWrappers:nil];
	if(change)
	{
		NSEnumerator * E = [[[self document] windowControllers] objectEnumerator];
		NSWindowController * WC;
		while(WC = [E nextObject])
			if([WC isKindOfClass:[iTM2TeXPCommandsInspector class]])
				[WC setDocumentEdited:YES];
	}
	[self setEditedProject:nil];// clean
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
    [self validateWindowContent];
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
		int index = [sender indexOfItemWithRepresentedObject:[self editedEngine]];
		if(index>=0 && index < [sender numberOfItems])
			[sender selectItemAtIndex:index];
		else
			[sender selectItem:[sender lastItem]];
    }
//iTM2_END;
    return YES;
}
#pragma mark =-=-=-=-=-=-=-=-=-=-  ENGINE SCRIPTS MANAGEMENT
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  chooseScript:
- (IBAction)chooseScript:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Mar 26 08:41:36 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    iTM2TeXProjectDocument * TPD = [self editedProject];
	iTM2TeXPEngineWrapper * CW = [TPD engineWrapperForName:[self editedEngine]];
	NSString * oldMode = [CW scriptMode];
	NSString * newMode = [(id)[sender selectedItem] representedString];
	if(![newMode isEqualToString:oldMode])
	{
		[CW setEnvironmentMode:newMode];
		[CW setScriptMode:newMode];
		[TPD updateChangeCount:NSChangeDone];
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
		NSBundle * mainBundle = [NSBundle mainBundle];
		id bins = [mainBundle allPathsForSupportExecutables];
		NSEnumerator * E = [bins objectEnumerator];
        NSString * engineMode = nil;
		NSString * title = nil;
		bins = [NSMutableSet set];
		while(engineMode = [E nextObject])
        {
			engineMode = [engineMode lastPathComponent];
			[bins addObject:engineMode];
		}
		bins = [bins allObjects];
		bins = [bins sortedArrayUsingSelector:@selector(compare:)];
        E = [bins objectEnumerator];
        while(engineMode = [E nextObject])
        {
            title = [engineMode stringByDeletingPathExtension];
            [sender addItemWithTitle:title];
            [[sender lastItem] setRepresentedObject:engineMode];
        }
        [[sender menu] addItem:[NSMenuItem separatorItem]];
        iTM2TeXProjectDocument * TPD = [self editedProject];
        E = [[TPD engineScripts] keyEnumerator];
        while(engineMode = [E nextObject])
        {
            NSString * label = [[TPD scriptDescriptorForEngineMode:engineMode] iVarLabel];
            NSString * title = [label length]? label:
                [NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"Custom script %@", iTM2TeXProjectFrontendTable, myBUNDLE, "Description Forthcoming"), engineMode];
            [sender addItemWithTitle:title];
            [[sender lastItem] setRepresentedObject:engineMode];
            NSMenuItem * MI = [removeScriptMenu addItemWithTitle:title action:@selector(removeScript:) keyEquivalent:@""];
            [MI setRepresentedObject:engineMode];
            [MI setTarget:self];// MI belongs to the receiver window
        }
        if([removeScriptMenu numberOfItems])
            [[sender menu] addItem:[NSMenuItem separatorItem]];
        [sender addItemWithTitle:NSLocalizedStringFromTableInBundle(@"New shell script", iTM2TeXProjectFrontendTable, myBUNDLE, "Description Forthcoming")];
        [[sender lastItem] setAction:@selector(newScript:)];
        [[sender lastItem] setTarget:self];// sender belongs to the receiver window
        if([removeScriptMenu numberOfItems])
        {
            [sender addItemWithTitle:NSLocalizedStringFromTableInBundle(@"Remove shell script", iTM2TeXProjectFrontendTable, myBUNDLE, "Description Forthcoming")];
            [[sender lastItem] setSubmenu:removeScriptMenu];
        }
		[[sender menu] addItem:[NSMenuItem separatorItem]];
		E = [[iTM2TeXPEngineInspector engineReferences] objectEnumerator];
		id C;
		while(C = [[E nextObject] nonretainedObjectValue])
		{
			NSString * title = [C prettyEngineMode];
			if(![title hasPrefix:@"."])
			{
				[sender addItemWithTitle:title];
				[[sender lastItem] setRepresentedObject:[C engineMode]];
			}
		}
		iTM2TeXPEngineWrapper * CW = [TPD engineWrapperForName:[self editedEngine]];
		NSString * scriptMode = [CW scriptMode];
        unsigned idx = [sender indexOfItemWithRepresentedObject: ([scriptMode length]? scriptMode:iTM2TPFEBaseMode)];
//iTM2_LOG(@"THE editedEngine IS: %@", [self editedEngine]);
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
	else if([sender isKindOfClass:[NSMenuItem class]])
	{
		NSArray * IFEs = [[iTM2TeXPEngineInspector classForMode:[sender representedObject]] inputFileExtensions];
		return ![IFEs count] || [IFEs containsObject:[self editedEngine]];
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
    iTM2TeXProjectDocument * myTPD = [self editedProject];
    NSArray * allEngineModes = [[myTPD engineScripts] allKeys];
    int idx = 0;
    NSString * engineMode;
    while((engineMode = [NSString stringWithFormat:@"%i", idx++]), [allEngineModes containsObject:engineMode]);
//NSLog(@"engineMode=<%@>", engineMode);
    [myTPD takeScriptDescriptor:[NSDictionary dictionary] forEngineMode:engineMode];
//iTM2_LOG(@"[myTPD engineScripts]: %@", [myTPD engineScripts]);
	iTM2TeXPEngineWrapper * CW = [myTPD engineWrapperForName:[self editedEngine]];
	[CW setScriptMode:engineMode];
	[CW setEnvironmentMode:iTM2TPFEVoidMode];
	[myTPD updateChangeCount:NSChangeDone];
    [self validateWindowContent];
//iTM2_LOG(@"[myTPD engineScripts]: %@", [myTPD engineScripts]);
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
    iTM2TeXProjectDocument * myTPD = [self editedProject];
    [myTPD takeScriptDescriptor:nil forEngineMode:[(id)sender representedString]];
    [myTPD updateChangeCount:NSChangeDone];
    [self validateWindowContent];
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
		iTM2TeXProjectDocument * TPD = [self editedProject];
		NSString * scriptMode = [[TPD engineWrapperForName:[self editedEngine]] scriptMode];
        iTM2TeXPShellScriptInspector * WC = [[[iTM2TeXPShellScriptInspector allocWithZone:[self zone]]
			initWithWindowNibName: @"iTM2TeXPShellScriptInspector"] autorelease];
		id SD = [TPD scriptDescriptorForEngineMode:scriptMode];
		if(SD)
		{
			[WC setScriptDescriptor:SD];
			NSWindow * W = [WC window];
			if(W)
			{
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
    iTM2TeXProjectDocument * TPD = [self editedProject];
	iTM2TeXPEngineWrapper * CW = [TPD engineWrapperForName:[self editedEngine]];
    NSString * scriptMode = [CW scriptMode];
	if(![[[TPD engineScripts] allKeys] containsObject:scriptMode])
	{
		if([SPC isBaseProject:TPD])
			return NO;
		unsigned modifierFlags = [[NSApp currentEvent] modifierFlags];
		BOOL option = (modifierFlags & NSAlternateKeyMask) && !(modifierFlags & NSCommandKeyMask);
		if(!option)
			return NO;
		iTM2TeXProjectDocument * baseTPD = [TPD baseProject];
		scriptMode = [[baseTPD engineWrapperForName:[self editedEngine]] scriptMode];
		return [[[baseTPD engineScripts] allKeys] containsObject:scriptMode];
	}
//iTM2_END;
    return YES;
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
        iTM2TeXProjectDocument * TPD = [self editedProject];
        id old = [TPD scriptDescriptorForEngineMode:scriptMode];
        id new = [WC scriptDescriptor];
        if(![old isEqual:new])
        {
            [TPD takeScriptDescriptor:new forEngineMode:scriptMode];
            [TPD updateChangeCount:NSChangeDone];
        }
    }
    [[WC document] removeWindowController:WC];
    [self validateWindowContent];
//iTM2_END;
    return;
}
#pragma mark =-=-=-=-=-=-=-=-=-=-  OPTIONS
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  chooseOptions:
- (IBAction)chooseOptions:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Mar 26 08:41:36 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    iTM2TeXProjectDocument * TPD = [self editedProject];
	iTM2TeXPEngineWrapper * CW = [TPD engineWrapperForName:[self editedEngine]];
	NSString * oldEnvironmentMode = [CW environmentMode];
	NSString * newEnvironmentMode = [(id)[sender selectedItem] representedString];
//iTM2_LOG(@"\noldEnvironmentMode is: %@\nnewEnvironmentMode is: %@", oldEnvironmentMode, newEnvironmentMode);
	if(![newEnvironmentMode isEqualToString:oldEnvironmentMode]
		&& (newEnvironmentMode != oldEnvironmentMode))
	{
		[CW setEnvironmentMode:newEnvironmentMode];
		[TPD updateChangeCount:NSChangeDone];
		[self validateWindowContent];
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
	iTM2TeXProjectDocument * TPD = [self editedProject];
	NSString * editedEngine = [self editedEngine];
	iTM2TeXPEngineWrapper * CW = [TPD engineWrapperForName:editedEngine];
	NSString * scriptMode = [CW scriptMode];
	NSString * environmentMode = [CW environmentMode];
//iTM2_LOG(@"environmentMode is: %@", environmentMode);
    if([sender isKindOfClass:[NSMenuItem class]])
	{
		NSString * representedObject = [sender representedObject];
//iTM2_LOG(@"the sender is: %@", sender);
//iTM2_LOG(@"the [iTM2TeXPEngineInspector classForMode:representedObject] is: %@", [iTM2TeXPEngineInspector classForMode:representedObject]);
//iTM2_LOG(@"the representedObject is: %@", representedObject);
//iTM2_LOG(@"the scriptMode is: %@", scriptMode);
//iTM2_LOG(@"the [[TPD baseProject] engineWrapperForName:editedEngine] is: %@", [[TPD baseProject] engineWrapperForName:editedEngine]);
		if([SPC isBaseProject:TPD])
		{
			// void script means nothing
			if([scriptMode isEqualToString:iTM2TPFEVoidMode])
				return NO;
			else if([scriptMode isEqualToString:iTM2TPFEBaseMode])
				return [representedObject isEqualToString:iTM2TPFEBaseMode];
			else if([iTM2TeXPEngineInspector classForMode:scriptMode])
				// the script mode is one of the built in engines
				// the environment must be eponym
				return [representedObject isEqualToString:scriptMode];
			else if([representedObject isEqual:iTM2TPFEVoidMode])
			{
				// the script mode is one of the custom engines
				// the environment can be either void or eponym with one of the built in engines
				return YES;
			}
		}
		else if([scriptMode isEqualToString:iTM2TPFEVoidMode])
			[sender setEnabled:NO];
		else if([scriptMode isEqualToString:iTM2TPFEBaseMode])
			return ([representedObject isEqualToString:iTM2TPFEBaseMode]
				|| ([representedObject isEqualToString:[[[TPD baseProject] engineWrapperForName:editedEngine] environmentMode]]));
		else if([iTM2TeXPEngineInspector classForMode:scriptMode])
			// the script mode is one of the built in engines
			// the environment must be eponym
			return [representedObject isEqualToString:scriptMode];
		else if([representedObject isEqualToString:iTM2TPFEVoidMode])
		{
			// the script mode is one of the custom engines
			// the environment can be either void or eponym with one of the built in engines
			return YES;
		}
		else
		{
			// the script mode is one of the custom engines
			// the environment can be either void or eponym with one of the built in engines
			return [iTM2TeXPEngineInspector classForMode:representedObject] != nil;
		}
	}
    else if([sender isKindOfClass:[NSPopUpButton class]])
	{
		[sender removeAllItems];
		if([scriptMode isEqualToString:iTM2TPFEVoidMode])
		{
			[sender addItemWithTitle:NSLocalizedStringFromTableInBundle(@"No options", iTM2TeXProjectFrontendTable, myBUNDLE, "...")];
			[sender selectItemAtIndex:0];
			return NO;
		}
		// populates with a "base" menu item
#warning BEWARE, this bundle design might break if poseAsClass is used...
		[sender addItemWithTitle:NSLocalizedStringFromTableInBundle(@"No options", iTM2TeXProjectFrontendTable, myBUNDLE, "...")];
		[[sender lastItem] setRepresentedObject:iTM2TPFEVoidMode];
		[sender addItemWithTitle:NSLocalizedStringFromTableInBundle(@"Base options", iTM2TeXProjectFrontendTable, myBUNDLE, "...")];
		[[sender lastItem] setRepresentedObject:iTM2TPFEBaseMode];
		// filling the menu with inspectors
		[[sender menu] addItem:[NSMenuItem separatorItem]];
		NSEnumerator * E = [[iTM2TeXPEngineInspector engineReferences] objectEnumerator];
		id C;
		while(C = [[E nextObject] nonretainedObjectValue])
		{
			if(![[C engineMode] hasPrefix:@"."])
			{
				[sender addItemWithTitle:[C prettyEngineMode]];
				[[sender lastItem] setRepresentedObject:[C engineMode]];
			}
		}
		unsigned idx = [sender indexOfItemWithRepresentedObject:environmentMode];
		[sender selectItemAtIndex:idx];
		return (idx!=-1);
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
		NSString * editCommand = [self editedEngine];
        iTM2TeXProjectDocument * TPD = [self editedProject];
		iTM2TeXPEngineWrapper * CW = [TPD engineWrapperForName:editCommand];
		NSString * environmentMode = [CW environmentMode];
		Class C = [iTM2TeXPEngineInspector classForMode:environmentMode];
        iTM2TeXPCommandInspector * WC = [[[C allocWithZone:[self zone]] initWithWindowNibName:[C windowNibName]] autorelease];
		[TPD addWindowController:WC];// now [WC document] == TPD, and WC is retained, the WC document is the project
		[WC takeModel:[TPD environmentForEngineMode:environmentMode]];
		NSWindow * W = [WC window];// may validate the window content as side effect
        if(W)
        {
//iTM2_LOG(@"The inspector is: %@", WC);
			if(iTM2DebugEnabled>100)
			{
				iTM2_LOG(@"Starting to edit environment mode: %@", environmentMode);
			}
			[W setExcludedFromWindowsMenu:YES];
//iTM2_LOG(@"BEFORE validateWindowContent, [WC document] is: %@ and W is: %@", [WC document], W);
            [NSApp beginSheet: W
                    modalForWindow: [self window]
                    modalDelegate: self
                    didEndSelector: @selector(editOptionsSheetDidEnd:returnCode:environmentMode:)
                    contextInfo: [environmentMode retain]];// will be released below
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
- (void)editOptionsSheetDidEnd:(NSWindow *)sheet returnCode:(int)returnCode environmentMode:(NSString *)environmentMode;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [environmentMode autorelease];// was retained above
    [sheet orderOut:self];
    id WC = [sheet windowController];
//iTM2_LOG(@"return code: %i", returnCode);
    if(returnCode==NSAlertDefaultReturn)
    {
        id TPD = [self editedProject];
		NSDictionary * new = [WC shellEnvironment];
		NSDictionary * old = [TPD environmentForEngineMode:environmentMode];
//iTM2_LOG(@"old engine environmnt is: %@", old);
//iTM2_LOG(@"new engine environmnt is: %@", new);
		if([old count]>0? ![old isEqual:new]:[new count])
		{
			// There might be a problem when upgrading if we add some keys to the dictionary
			[TPD takeEnvironment:new forEngineMode:environmentMode];
			if(![[TPD environmentForEngineMode:environmentMode] isEqual:new])
			{
				iTM2_LOG(@"\n\nTHERE IS A BIG PROBLEM\n\nnew is: %@",[TPD environmentForEngineMode:environmentMode]);
			}
			[TPD updateChangeCount:NSChangeDone];
		}
		old = [TPD environmentForEngineMode:environmentMode];
//iTM2_LOG(@"actual engine environmnt is: %@", old);
    }
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
	iTM2TeXProjectDocument * TPD = [self editedProject];
	// base projects only have custom options settings
//	if([SPC isBaseProject:TPD])
//		return NO;
	NSString * editedEngine = [self editedEngine];
	iTM2TeXPEngineWrapper * CW = [TPD engineWrapperForName:editedEngine];
	NSString * environmentMode = [CW environmentMode];
	if(![environmentMode length] || [environmentMode isEqualToString:iTM2TPFEVoidMode])
		return NO;
	if([environmentMode isEqualToString:iTM2TPFEBaseMode])
	{
		// other projects cannot edit the base options, except when the option key is down (with no command key)
		unsigned modifierFlags = [[NSApp currentEvent] modifierFlags];
		BOOL option = (modifierFlags & NSAlternateKeyMask) && !(modifierFlags & NSCommandKeyMask);
		if(!option)
			return NO;
		// will I edit the base project?
		iTM2TeXPEngineWrapper * CW = [(id)[self document] engineWrapperForName:editedEngine];
		environmentMode = [CW environmentMode];
		return [[[[TPD baseProject] engineEnvironments] allKeys] containsObject:environmentMode];
	}
    else if([environmentMode isEqualToString:iTM2TPFEVoidMode])
        return NO;
    else
    {
        NSEnumerator * E = [[iTM2TeXPEngineInspector engineReferences] objectEnumerator];
		id C;
		while(C = [[E nextObject] nonretainedObjectValue])
            if([environmentMode isEqual:[C engineMode]])
                return YES;
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
	iTM2TeXProjectDocument * myTPD = [self editedProject];
    NSString * extension = [self editedEngine];
	NSAssert(extension != nil, @"Unexpected nil extension");
	NSMutableDictionary * environment = (NSMutableDictionary *)[myTPD environmentForCommandMode:[isa commandName]];
	if(![environment isKindOfClass:[NSDictionary class]])
		environment = (NSMutableDictionary *)[NSDictionary dictionary];
	environment = [[environment mutableCopy] autorelease];
	NSMutableDictionary * extensions = [environment objectForKey:iTM2TPFECompileEngines];
	if(![extensions isKindOfClass:[NSDictionary class]])
		extensions = [NSDictionary dictionary];
	extensions = [[extensions mutableCopy] autorelease];
    NSString * old = [extensions objectForKey:extension];
    if(!old)
    {
		[extensions removeObjectForKey:extension];
		[environment setObject:extensions forKey:iTM2TPFECompileEngines];
        [myTPD takeEnvironment:environment forEngineMode:[isa commandName]];
        [myTPD updateChangeCount:NSChangeDone];
    }
    [self validateWindowContent];
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
	iTM2TeXProjectDocument * myTPD = [self editedProject];
    NSString * extension = [self editedEngine];
	NSDictionary * environment = [myTPD environmentForCommandMode:[isa commandName]];
	if(![environment isKindOfClass:[NSDictionary class]])
        return NO;
	NSDictionary * extensions = [environment objectForKey:iTM2TPFECompileEngines];
	if(![extensions isKindOfClass:[NSDictionary class]])
		return NO;
    NSString * old = [extensions objectForKey:extension];
//iTM2_END;
    return (old != nil) && ![SPC isBaseProject:myTPD];
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
//    [self validateWindowContent]; now in the validation kit
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

@implementation iTM2TeXProjectDocument(Compile)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  engineFrontendProjectFixImplementation
- (void)engineFrontendProjectFixImplementation;
/*"Description forthcoming. Automatically called.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	// Ok, I assume that I have read the stored data and I am going to create the list of commands.
	// first we make some consistency test.
//iTM2_LOG(@"IMPLEMENTATION is: %@", IMPLEMENTATION);
	id O;
	#define CREATE(KEY)\
	O = [IMPLEMENTATION modelValueForKey:KEY ofType:iTM2ProjectFrontendType];\
	if([O isKindOfClass:[NSDictionary class]])\
		[IMPLEMENTATION takeModelValue:[NSMutableDictionary dictionaryWithDictionary:O] forKey:KEY ofType:iTM2ProjectFrontendType];\
	else\
		[IMPLEMENTATION takeModelValue:[NSMutableDictionary dictionary] forKey:KEY ofType:iTM2ProjectFrontendType];
	CREATE(iTM2TPFEEnginesKey);
//iTM2_LOG(@"[self engines] are: %@ and [IMPLEMENTATION modelValueForKey:iTM2TPFEEnginesKey ofType:iTM2ProjectFrontendType] are: %@", [self engines], [IMPLEMENTATION modelValueForKey:iTM2TPFEEnginesKey ofType:iTM2ProjectFrontendType]);
	CREATE(iTM2TPFEEngineEnvironmentsKey);
//iTM2_LOG(@"[self engineEnvironments] are: %@ and [IMPLEMENTATION modelValueForKey:iTM2TPFEEngineEnvironmentsKey ofType:iTM2ProjectFrontendType] are: %@", [self engineEnvironments], [IMPLEMENTATION modelValueForKey:iTM2TPFEEngineEnvironmentsKey ofType:iTM2ProjectFrontendType]);
	CREATE(iTM2TPFEEngineScriptsKey);
	[self setEngineWrappers:nil];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  modelForEngineName:
- (id)modelForEngineName:(NSString *)name;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [[self engines] valueForKey:name];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeModel:forEngineName:
- (void)takeModel:(id)argument forEngineName:(NSString *)name;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[[self engines] takeValue:[[argument copy] autorelease] forKey:name];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  environmentForEngineMode:
- (NSDictionary *)environmentForEngineMode:(NSString *)engineMode;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id C = [iTM2TeXPEngineInspector classForMode:engineMode];
	if(C)
	{
		id result = [NSMutableDictionary dictionaryWithDictionary:[C defaultShellEnvironment]];
		id engineEnvironment = [[self engineEnvironments] valueForKey:engineMode];
		if(engineEnvironment)
			[result addEntriesFromDictionary:engineEnvironment];
		return result;
	}
	else
		return [[[[self engineEnvironments] valueForKey:engineMode] retain] autorelease]?:[NSDictionary dictionary];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeEnvironment:forEngineMode:
- (void)takeEnvironment:(id)environment forEngineMode:(NSString *)engineMode;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	environment = [[environment copy] autorelease];
	id engineEnvironments = [self engineEnvironments];
	[engineEnvironments takeValue:environment forKey:engineMode];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  engines
- (NSDictionary *)engines;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [IMPLEMENTATION modelValueForKey:iTM2TPFEEnginesKey ofType:iTM2ProjectFrontendType];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  engineScripts
- (NSDictionary *)engineScripts;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [IMPLEMENTATION modelValueForKey:iTM2TPFEEngineScriptsKey ofType:iTM2ProjectFrontendType];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  engineEnvironments
- (NSDictionary *)engineEnvironments;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [IMPLEMENTATION modelValueForKey:iTM2TPFEEngineEnvironmentsKey ofType:iTM2ProjectFrontendType];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  scriptDescriptorForEngineMode:
- (NSDictionary *)scriptDescriptorForEngineMode:(NSString *)engineMode;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [[self engineScripts] valueForKey:engineMode]?:[NSDictionary dictionary];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeScriptDescriptor:forEngineMode:
- (void)takeScriptDescriptor:(id)script forEngineMode:(NSString *)engineMode;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [[self engineScripts] takeValue:[[script copy] autorelease] forKey:engineMode];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  engineWrapperForName:
- (id)engineWrapperForName:(NSString *)name;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSEnumerator * E = [[self engineWrappers] objectEnumerator];
	id result;
	while(result = [E nextObject])
		if([name isEqualToString:[result name]])
			return result;
	iTM2_LOG(@"NO ENGINE WRAPPER FOR NAME: %@ ([self engineWrappers] are: %@), may be you need to update", name, [self engineWrappers]);
	return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  engineWrappers
- (id)engineWrappers;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id result = metaGETTER;
	if(!result)
	{
		[self setEngineWrappers:[self lazyEngineWrappers]];
		result = metaGETTER;
	}
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  lazyEngineWrappers
- (id)lazyEngineWrappers;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSMutableArray * MRA = [NSMutableArray array];
	NSEnumerator * E = [[[iTM2TeXPCompilePerformer performer] builtInEngineModes] objectEnumerator];
	NSString * name;
	while(name = [E nextObject])
	{
		iTM2TeXPEngineWrapper * CW = [[[iTM2TeXPEngineWrapper allocWithZone:[self zone]] init] autorelease];
		[CW setName:name];
		[CW setProject:self];
		[CW setModel:[self modelForEngineName:name]];
//iTM2_LOG(@"New engine wrapper CW is: %@\nfrom model: %@\nname: %@", CW, [self modelForEngineName:name], name);
		[MRA addObject:CW];
	}
	return MRA;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setEngineWrappers:
- (void)setEngineWrappers:(NSArray *)argument;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	metaSETTER(argument);
//iTM2_END;
    return;
}
@end

@implementation iTM2TeXPEngineWrapper
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  modelDidChange
- (void)modelDidChange;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return;
}
@end

NSString * const iTM2ContinuousCompile = @"iTM2_ContinuousCompile";

@implementation iTM2TeXPContinuousPerformer
- (int)commandGroup;
{iTM2_DIAGNOSTIC;
	return 10;
}
- (int)commandLevel;
{iTM2_DIAGNOSTIC;
	return 100;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  performCommand:
- (IBAction)performCommand:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	iTM2TeXProjectDocument * TPD = [SPC TeXProjectForSource:nil];
	[TPD takeContextBool: ![TPD contextBoolForKey:iTM2ContinuousCompile domain:iTM2ContextPrivateMask] forKey:iTM2ContinuousCompile domain:iTM2ContextAllDomainsMask];
	[TPD updateChangeCount:NSChangeDone];
    return;
//iTM2_END;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validatePerformCommand:
- (BOOL)validatePerformCommand:(id)sender;
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
	[SUD registerDefaults:[NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:1] forKey:iTM2ContinuousCompileDelay]];
	return;
}
- (int)commandGroup;
{iTM2_DIAGNOSTIC;
	return 10;
}
- (int)commandLevel;
{iTM2_DIAGNOSTIC;
	return 10;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  allBuiltInEngineModes
- (NSArray *)allBuiltInEngineModes;
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
		allBuiltInEngineModes = [[NSMutableArray arrayWithContentsOfFile:P] retain];
		NSMutableSet * MS = [NSMutableSet set];
        NSEnumerator * E = [[iTM2TeXPEngineInspector engineReferences] objectEnumerator];
		id C;
		while(C = [[E nextObject] nonretainedObjectValue])
		{
            [MS addObjectsFromArray:[C inputFileExtensions]];
		}
		NSMutableSet * ms = [NSMutableSet setWithArray:allBuiltInEngineModes];
		E = [allBuiltInEngineModes objectEnumerator];
		while(C = [E nextObject])
		{
			if([C isKindOfClass:[NSArray class]])
			{
				[ms addObjectsFromArray:C];
			}
		}
		[MS minusSet:ms];
		[allBuiltInEngineModes addObjectsFromArray:[MS allObjects]];
	}
//iTM2_END;
    return allBuiltInEngineModes;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  builtInEngineModes
- (NSArray *)builtInEngineModes;
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
		NSEnumerator * E = [[self allBuiltInEngineModes] objectEnumerator];
		id O;
		while(O = [E nextObject])
		{
			if([O isKindOfClass:[NSString class]])
			{
				[MRA addObject:O];
			}
			else if([O isKindOfClass:[NSArray class]])
			{
				NSEnumerator * e = [O objectEnumerator];
				while(O = [e nextObject])
				{
					if([O isKindOfClass:[NSString class]])
					{
						[MRA addObject:O];
						break;
					}
				}
			}
		}
		builtInEngineModes = [MRA copyWithZone:[self zone]];
	}
//iTM2_END;
    return builtInEngineModes;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= environmentScriptsForBaseProject:
- (NSDictionary *)environmentScriptsForBaseProject:(iTM2TeXProjectDocument *)project;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- Thu Oct 28 14:05:13 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSMutableDictionary * ED = [NSMutableDictionary dictionaryWithDictionary:[super environmentScriptsForBaseProject:project]];
	// all the scripts...
	NSEnumerator * E = [[project engineScripts] keyEnumerator];
	NSString * mode;
	while(mode = [E nextObject])
	{
		NSDictionary * scriptDescriptor = [project scriptDescriptorForEngineMode:mode];
		if([scriptDescriptor count])
		{
			NSString * shellScript = [scriptDescriptor valueForKey:iTM2TPFEContentKey];
			if(shellScript)
				[ED setObject:shellScript forKey:[NSString stringWithFormat:@"iTM2_ShellScript_BaseEngine_%@", mode]];
		}
	}
//iTM2_END;
    return ED;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= environmentScriptsForProject:
- (NSDictionary *)environmentScriptsForProject:(iTM2TeXProjectDocument *)project;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- Thu Oct 28 14:05:13 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSMutableDictionary * ED = [NSMutableDictionary dictionaryWithDictionary:[super environmentScriptsForProject:project]];
	// all the scripts...
	NSEnumerator * E = [[project engineScripts] keyEnumerator];
	NSString * mode;
	while(mode = [E nextObject])
	{
		NSDictionary * scriptDescriptor = [project scriptDescriptorForEngineMode:mode];
		if([scriptDescriptor count])
		{
			NSString * shellScript = [scriptDescriptor valueForKey:iTM2TPFEContentKey];
			if(shellScript)
				[ED setObject:shellScript forKey:[NSString stringWithFormat:@"iTM2_ShellScript_Engine_%@", mode]];
		}
	}
//iTM2_END;
    return ED;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= environmentWithDictionary:forBaseProject:
- (NSDictionary *)environmentWithDictionary:(NSDictionary *)environment forBaseProject:(iTM2TeXProjectDocument *)project;
/*"Sets up the riht file objects. The extension should be set by the one who will fill up a task environemnt.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_LOG(@"Base project is: %@", project);
//iTM2_LOG(@"Base project model is: %@", [[project implementation] modelOfType:iTM2ProjectFrontendType]);
	// how things work:
	// the main matter here is two fold:
	// - on one hand I have to transmit shell scripts
	// - on the other hand I have to transmit the corresponding environment.
	// Two questions:
	// - what is the shell script?
	//   the shell script is either void, inherited from the base or built in the project.
	//   If the shell script is void, nothing is done
	NSString * command = [self commandName];//@"Compile"
	id CW = [project commandWrapperForName:command];
	NSString * mode = [CW scriptMode];
	if([mode isEqualToString:iTM2TPFEVoidMode])
		return [super environmentWithDictionary:environment forProject:project];
	NSDictionary * D = [super environmentWithDictionary:environment forProject:project];
    NSMutableDictionary * ED = [NSMutableDictionary dictionaryWithDictionary:D];
//iTM2_LOG(@"111-iTM2_Compile_tex is: %@", [ED objectForKey:@"iTM2_Compile_tex"]);
	mode = [CW environmentMode];
	if([mode isEqualToString:iTM2TPFEVoidMode])
	{
		NSEnumerator * E = [[self builtInEngineModes] objectEnumerator];
		id O;
		while(O = [E nextObject])
			[ED takeValue:[NSString stringWithFormat:@"iTM2_DoNothing"]
				forKey: [NSString stringWithFormat:@"iTM2_Compile_%@", O]];
	}
	else if([mode isEqualToString:iTM2TPFEBaseMode])
	{
		D = [project environmentForEngineMode:iTM2ProjectDefaultsKey];
		[ED addEntriesFromDictionary:D];
		NSEnumerator * E = [[self builtInEngineModes] objectEnumerator];
		id O;
		while(O = [E nextObject])
		{
			NSString * key = [NSString stringWithFormat:@"iTM2_Compile_%@", O];
			if(![ED valueForKey:key])
			{
				[ED takeValue:key forKey:key];
			}
		}
	}
	else
	{
		D = [project environmentForEngineMode:iTM2ProjectDefaultsKey];
		[ED addEntriesFromDictionary:D];
		NSEnumerator * E = [[self builtInEngineModes] objectEnumerator];
		id O;
		while(O = [E nextObject])
		{
			NSString * key = [NSString stringWithFormat:@"iTM2_Compile_%@", O];
			CW = [project engineWrapperForName:O];
			mode = [CW scriptMode];
//iTM2_LOG(@"222-key is: %@", key);
//iTM2_LOG(@"222-CW is: %@", CW);
			if([mode isEqualToString:iTM2TPFEBaseMode])
			{
			// the script is one of the default iTM2 script
				if(![ED valueForKey:key])
				{
					[ED takeValue:key forKey:key];
				}
			}
			else if([mode hasPrefix:@"iTM2_Engine_"])
			{
			// the script is one of the built in engines
				[ED takeValue:mode forKey:key];
			}
			else
			{
			// the script is one of the project customized scripts
				[ED takeValue:[NSString stringWithFormat:@"iTM2_BaseEngine_%@", mode] forKey:key];
			}
			mode = [CW environmentMode];
			D = [project environmentForEngineMode:mode];
			[ED addEntriesFromDictionary:D];
//iTM2_LOG(@"222-iTM2_Compile_tex is: %@", [ED objectForKey:@"iTM2_Compile_tex"]);
		}
	}
	if([project contextBoolForKey:iTM2ContinuousCompile domain:iTM2ContextAllDomainsMask])
		[ED setObject:[NSNumber numberWithBool:YES] forKey:iTM2ContinuousCompile];
//iTM2_END;
	return ED;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= environmentWithDictionary:forProject:
- (NSDictionary *)environmentWithDictionary:(NSDictionary *)environment forProject:(iTM2TeXProjectDocument *)project;
/*"Sets up the riht file objects. The extension should be set by the one who will fill up a task environemnt.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	// how things work:
	// the main matter here is two fold:
	// - on one hand I have to transmit shell scripts
	// - on the other hand I have to transmit the corresponding environment.
	// Two questions:
	// - what is the shell script?
	//   the shell script is either void, inherited from the base or built in the project.
	//   If the shell script is void, nothing is done
	NSString * command = [self commandName];//@"Compile"
	id CW = [project commandWrapperForName:command];
	NSString * mode = [CW scriptMode];
	if([mode isEqualToString:iTM2TPFEVoidMode])
		return [super environmentWithDictionary:environment forProject:project];
	NSDictionary * D = [super environmentWithDictionary:environment forProject:project];
    NSMutableDictionary * ED = [NSMutableDictionary dictionaryWithDictionary:D];
//iTM2_LOG(@"312-iTM2_Compile_tex is: %@", [ED objectForKey:@"iTM2_Compile_tex"]);
	mode = [CW environmentMode];
	if([mode isEqualToString:iTM2TPFEVoidMode])
	{
//iTM2_LOG(@"313-iTM2_Compile_tex is: %@", [ED objectForKey:@"iTM2_Compile_tex"]);
		NSEnumerator * E = [[self builtInEngineModes] objectEnumerator];
		id O;
		while(O = [E nextObject])
		{
			[ED takeValue:[NSString stringWithFormat:@"iTM2_DoNothing"]
				forKey: [NSString stringWithFormat:@"iTM2_Compile_%@", O]];
		}
	}
	else if([mode isEqualToString:iTM2TPFEBaseMode])
	{
//iTM2_LOG(@"314-iTM2_Compile_tex is: %@", [ED objectForKey:@"iTM2_Compile_tex"]);
		D = [project environmentForEngineMode:iTM2ProjectDefaultsKey];
		[ED addEntriesFromDictionary:D];
	}
	else
	{
//iTM2_LOG(@"315-iTM2_Compile_tex is: %@", [ED objectForKey:@"iTM2_Compile_tex"]);
		D = [project environmentForEngineMode:iTM2ProjectDefaultsKey];
		[ED addEntriesFromDictionary:D];
		NSEnumerator * E = [[self builtInEngineModes] objectEnumerator];
		id O;
		while(O = [E nextObject])
		{
			NSString * key = [NSString stringWithFormat:@"iTM2_Compile_%@", O];
			CW = [project engineWrapperForName:O];
			mode = [CW scriptMode];
//iTM2_LOG(@"scriptMode is: %@, key is: %@, project is: %@", scriptMode, key, project);
			if([mode isEqualToString:iTM2TPFEBaseMode])
			{
			// the script is inherited from the bas project
				;//[ED takeValue:key forKey:key];
			}
			else if([mode hasPrefix:@"iTM2_Engine_"])
			{
			// the script is one of the built in engines
				[ED takeValue:mode forKey:key];
			}
			else
			{
			// the script is one of the project customized scripts
				[ED takeValue:[NSString stringWithFormat:@"iTM2_Engine_%@", mode] forKey:key];
			}
			mode = [CW environmentMode];
			D = [project environmentForEngineMode:mode];
			[ED addEntriesFromDictionary:D];
		}
	}
	if([project contextBoolForKey:iTM2ContinuousCompile domain:iTM2ContextAllDomainsMask])
		[ED setObject:[NSNumber numberWithBool:YES] forKey:iTM2ContinuousCompile];
//iTM2_END;
//iTM2_LOG(@"316-iTM2_Compile_tex is: %@", [ED objectForKey:@"iTM2_Compile_tex"]);
	return ED;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  taskWrapperDidPerformCommand:taskController:userInfo:
- (void)taskWrapperDidPerformCommand:(iTM2TaskWrapper *)TW taskController:(iTM2TaskController *)TC userInfo:(id)userInfo;
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
- (void)_delayedPerformCommand:(NSTimer *)timer;
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
				[self performCommandForProject:TPD];
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
- (NSString *)menuItemTitleForProject:(id)project;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * commandName = [self commandName];
	id commandWrapper = [project commandWrapperForName:commandName];
	NSString * scriptMode = [commandWrapper scriptMode];
	if([scriptMode length])
	{
		NSString * label = [[project scriptDescriptorForCommandMode:scriptMode] iVarLabel];
		if([label length])
			return [NSString stringWithFormat: @"%@ (%@)",
				[super menuItemTitleForProject:project], label];
	}
	id baseProject = [project baseProject];
	commandWrapper = [baseProject commandWrapperForName:commandName];
	scriptMode = [commandWrapper scriptMode];
	if([scriptMode length])
	{
		NSString * label = [[project scriptDescriptorForCommandMode:scriptMode] iVarLabel];
		if([label length])
			return [NSString stringWithFormat: @"%@ (%@)",
				[super menuItemTitleForProject:project], label];
		label = [[baseProject scriptDescriptorForCommandMode:scriptMode] iVarLabel];
		if([label length])
			return [NSString stringWithFormat: @"%@ (%@)",
				[super menuItemTitleForProject:project], label];
	}
//iTM2_END;
    return [super menuItemTitleForProject:project];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validatePerformCommand:
- (BOOL)validatePerformCommand:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(![sender image])
	{
		NSImage * I = [NSImage imageNamed:@"iTM2:compilePerformer"];
		if(!I)
		{
			I = [NSImage imageNamed:@"iTM2:typesetCurrentProject"];
			I = [I copy];
			[I setName:@"iTM2:compilePerformer"];
			[I setScalesWhenResized:YES];
			[I setSize:NSMakeSize(16,16)];
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
    return ![TPD contextBoolForKey:iTM2ContinuousCompile domain:iTM2ContextPrivateMask] && [self contextBoolForKey:iTM2UDSmartUndoKey domain:iTM2ContextAllDomainsMask];
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
    return ![TPD contextBoolForKey:iTM2ContinuousCompile domain:iTM2ContextPrivateMask];
}
@end

//#import <iTM2Foundation/iTM2BundleKit.h>
//#import <iTM2Foundation/iTM2RuntimeBrowser.h>

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
	[[self classBundle] installBinaryWithName:[self engineMode]];
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
    NSEnumerator * E = [[self engineReferences] objectEnumerator];
	Class C;
	while(C = [[E nextObject] nonretainedObjectValue])
		if([[C engineMode] isEqualToString:action])
			return C;
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
+ (NSArray *)engineReferences;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [iTM2RuntimeBrowser subclassReferencesOfClass:[iTM2TeXPEngineInspector class]];
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
    [self validateWindowContent];
//iTM2_END;
    return;
}
#endif
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2TeXPCompileWrapperKit


