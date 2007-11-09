/*
//
//  @version Subversion: $Id: iTM2MacroKit.m 490 2007-05-04 09:05:15Z jlaurens $ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Thu Feb 21 2002.
//  Copyright © 2006 Laurens'Tribune. All rights reserved.
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

#import "iTM2MacroKit.h"
#import "iTM2MacroKit_Tree.h"
#import "iTM2MacroKit_Prefs.h"
#import "iTM2MacroKit_Model.h"
#import "iTM2MacroKit_Controller.h"
#import <iTM2Foundation/iTM2MacroKit.h>
#import <iTM2Foundation/iTM2ContextKit.h>
#import <iTM2Foundation/iTM2BundleKit.h>
#import <iTM2Foundation/iTM2FileManagerKit.h>
#import <iTM2Foundation/iTM2PathUtilities.h>
#import <iTM2Foundation/iTM2PreferencesKit.h>

@interface iTM2MacroPrefPane: iTM2PreferencePane
- (void)setSelectedMode:(NSString *)mode;
-(void)setMacroSelection:(id)new;
-(void)setKeyBindingSelection:(id)new;
-(BOOL)isEditingKeyBinding;
@end

@interface iTM2HumanReadableActionNameValueTransformer: NSValueTransformer
+ (NSArray *)actionNames;
@end

@interface iTM2TabViewItemIdentifierForActionValueTransformer: NSValueTransformer
@end

@implementation iTM2MacroPrefPane
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= prefPaneIdentifier
- (NSString *)prefPaneIdentifier;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 09/21/2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return @"3.Macro";
}
#if 0
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  willUnselect
- (void)willUnselect;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[super willUnselect];
    return;
}
#endif
#pragma mark =-=-=-=-=-  BINDINGS
- (NSArray *)availableActionNames;
{
	return [iTM2HumanReadableActionNameValueTransformer actionNames];
}
- (NSArray *)orderedCodeNames;
{
	return [KCC orderedCodeNames];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  availableDomains
- (NSArray *)availableDomains;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Sun Nov  5 16:57:31 GMT 2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	id macroTree = [SMC macroTree];
	id keyBindingTree = [SMC keyBindingTree];
	id macroAvailableDomains = [macroTree availableDomains];
	NSMutableSet * macroSet = [NSMutableSet setWithArray:macroAvailableDomains];
	id keyAvailableDomains = [keyBindingTree availableDomains];
	NSMutableSet * keySet = [NSMutableSet setWithArray:keyAvailableDomains];
	NSSet * temp = [NSSet setWithSet:macroSet];
	[macroSet minusSet:keySet];
	[keySet minusSet:temp];
	NSString * mode;
	NSEnumerator * E = [keySet objectEnumerator];
	while(mode = [E nextObject])
	{
		[[[iTM2MacroDomainNode alloc] initWithParent:macroTree domain:mode] autorelease];
	}
	E = [macroSet objectEnumerator];
	while(mode = [E nextObject])
	{
		[[[iTM2MacroDomainNode alloc] initWithParent:keyBindingTree domain:mode] autorelease];
	}
    return [[SMC macroTree] availableDomains];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  selectedDomain
- (NSString *)selectedDomain;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Sun Nov  5 16:57:31 GMT 2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id MD = [self contextDictionaryForKey:@"iTM2MacroEditorSelection" domain:iTM2ContextAllDomainsMask];
	NSString * key = @".";
	id result = [MD objectForKey:key];
//iTM2_END;
    return result?:@"";
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  availableModes
- (NSArray *)availableModes;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Sun Nov  5 16:57:31 GMT 2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * domain = [self selectedDomain];
	iTM2MacroRootNode * root = [SMC macroTree];
	id macroNode = [root objectInChildrenWithDomain:domain];
	root = [SMC keyBindingTree];
	id keyNode = [root objectInChildrenWithDomain:domain];
	id macroAvailableModes = [macroNode availableCategories];
	NSMutableSet * macroSet = [NSMutableSet setWithArray:macroAvailableModes];
	id keyAvailableModes = [keyNode availableCategories];
	NSMutableSet * keySet = [NSMutableSet setWithArray:keyAvailableModes];
	NSSet * temp = [NSSet setWithSet:macroSet];
	[macroSet minusSet:keySet];
	[keySet minusSet:temp];
	NSString * category;
	NSEnumerator * E = [keySet objectEnumerator];
	while(category = [E nextObject])
	{
		[[[iTM2MacroCategoryNode alloc] initWithParent:macroNode category:category] autorelease];
	}
	E = [macroSet objectEnumerator];
	while(category = [E nextObject])
	{
		[[[iTM2MacroCategoryNode alloc] initWithParent:keyNode category:category] autorelease];
	}
//iTM2_END;
    return [macroNode availableCategories];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  selectedMode
- (NSString *)selectedMode;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Sun Nov  5 16:57:31 GMT 2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self selectedDomain];// side effect: the selected domain should be safe before anything else is used
	id MD = [self contextDictionaryForKey:@"iTM2MacroEditorSelection" domain:iTM2ContextAllDomainsMask];
	NSString * key = [self selectedDomain];
	id result = [MD objectForKey:key];
//iTM2_END;
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  macroEditor
- (id)macroEditor;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Sun Nov  5 16:57:31 GMT 2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self selectedMode];
	id node = [self valueForKey:@"macroEditor_meta"];
//iTM2_END;
    return node;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setMacroEditor:
- (void)setMacroEditor:(id)new;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Sun Nov  5 16:57:31 GMT 2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id old = [self valueForKey:@"macroEditor_meta"];
	if(![old isEqual:new])
	{
		[self setMacroSelection:nil];
		[self willChangeValueForKey:@"macroEditor"];
		[[old retain] autorelease];
		[self setValue:new forKey:@"macroEditor_meta"];
		[self didChangeValueForKey:@"macroEditor"];
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  keyBindingEditor
- (id)keyBindingEditor;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Sun Nov  5 16:57:31 GMT 2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self selectedMode];
	id node = [self valueForKey:@"keyBindingEditor_meta"];
//iTM2_END;
    return node;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setKeyBindingEditor:
- (void)setKeyBindingEditor:(id)new;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Sun Nov  5 16:57:31 GMT 2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id old = [self valueForKey:@"keyBindingEditor_meta"];
	if(![old isEqual:new])
	{
		[self setKeyBindingSelection:nil];
		[self willChangeValueForKey:@"keyBindingEditor"];
		[[old retain] autorelease];
		[self setValue:new forKey:@"keyBindingEditor_meta"];
		[self didChangeValueForKey:@"keyBindingEditor"];
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setSelectedMode:
- (void)setSelectedMode:(NSString *)newMode;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Sun Nov  5 16:57:31 GMT 2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
#ifdef __I_WANT_EXC_BAD_ACCESS__
	id new = nil;
	[self setMacroEditor:new];
	[self setKeyBindingEditor:new];
#else
	id new = nil;
	id old = [self valueForKey:@"macroEditor_meta"];
	if(![old isEqual:new])
	{
		[self setMacroSelection:nil];
		[self willChangeValueForKey:@"macroEditor"];
		[[old retain] autorelease];
		[self setValue:new forKey:@"macroEditor_meta"];
		[self didChangeValueForKey:@"macroEditor"];
	}
	old = [self valueForKey:@"keyBindingEditor_meta"];
	if(![old isEqual:new])
	{
		[self setKeyBindingSelection:nil];
		[self willChangeValueForKey:@"keyBindingEditor"];
		[[old retain] autorelease];
		[self setValue:new forKey:@"keyBindingEditor_meta"];
		[self didChangeValueForKey:@"keyBindingEditor"];
	}
#endif
	[self willChangeValueForKey:@"selectedMode"];
	NSString * oldMode = [self selectedMode];
	[self willChangeValueForKey:@"selectedMode"];
	id MD = [self contextDictionaryForKey:@"iTM2MacroEditorSelection" domain:iTM2ContextAllDomainsMask];
	MD = [[MD mutableCopy] autorelease];
	NSString * domain = [self selectedDomain];
	[[oldMode retain] autorelease];// why should I retain this? the observer is notified that there will be a change
	[MD setValue:newMode forKey:domain];
	[self setContextValue:MD forKey:@"iTM2MacroEditorSelection" domain:iTM2ContextAllDomainsMask];
	[self didChangeValueForKey:@"selectedMode"];
	// change the editors
	id editor = [SMC macroTree];
	editor = [editor objectInChildrenWithDomain:domain]?:
			[[[iTM2MacroDomainNode alloc] initWithParent:editor domain:domain] autorelease];
	editor = [editor objectInChildrenWithCategory:newMode]?:
			[[[iTM2MacroCategoryNode alloc] initWithParent:editor category:newMode] autorelease];
	editor = [editor objectInChildrenWithContext:@""]?:
			[[[iTM2MacroContextNode alloc] initWithParent:editor context:@""] autorelease];
	editor = [editor list];
	[self setMacroEditor:editor];
	editor = [SMC keyBindingTree];
	editor = [editor objectInChildrenWithDomain:domain]?:
			[[[iTM2MacroDomainNode alloc] initWithParent:editor domain:domain] autorelease];
	editor = [editor objectInChildrenWithCategory:newMode]?:
			[[[iTM2MacroCategoryNode alloc] initWithParent:editor category:newMode] autorelease];
	editor = [editor objectInChildrenWithContext:@""]?:
			[[[iTM2KeyBindingContextNode alloc] initWithParent:editor context:@""] autorelease];
	editor = [editor list];
	[self setKeyBindingEditor:editor];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setSelectedDomain:
- (void)setSelectedDomain:(NSString *)newDomain;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Sun Nov  5 16:57:31 GMT 2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self setSelectedMode:nil];
	[self willChangeValueForKey:@"availableModes"];
	[self willChangeValueForKey:@"selectedDomain"];
	NSString * key = @".";
	id MD = [self contextDictionaryForKey:@"iTM2MacroEditorSelection" domain:iTM2ContextAllDomainsMask];
	MD = [[MD mutableCopy] autorelease];
	[MD setValue:newDomain forKey:key];
	[self setContextValue:MD forKey:@"iTM2MacroEditorSelection" domain:iTM2ContextAllDomainsMask];
	[self didChangeValueForKey:@"selectedDomain"];
	[self didChangeValueForKey:@"availableModes"];
	NSString * newMode = [MD objectForKey:newDomain];
	NSArray * availableModes = [self availableModes];
	if(![availableModes containsObject:newMode])
	{
		newMode = [availableModes lastObject];
	}
	[self setSelectedMode:newMode];
//iTM2_END;
    return;
}
-(id)macrosArrayController;// nib outlets won't accept kvc (10.4)
{
	return metaGETTER;
}
-(void)setMacrosArrayController:(id)argument;
{
	id old = metaGETTER;
	if([old isEqual:argument] || old==argument)
	{
		return;
	}
	metaSETTER(argument);
	return;
}
-(id)macroSortDescriptors;// nib outlets won't accept kvc (10.4)
{
	return metaGETTER;
}
-(void)setMacroSortDescriptors:(id)argument;
{
	id old = metaGETTER;
	if([old isEqual:argument] || old==argument)
	{
		return;
	}
	[self willChangeValueForKey:@"macroSortDescriptors"];
	metaSETTER(argument);
	[self didChangeValueForKey:@"macroSortDescriptors"];
	return;
}
-(id)keysTreeController;
{
	return metaGETTER;
}
-(void)setKeysTreeController:(id)argument;
{
	id old = metaGETTER;
	if([old isEqual:argument] || old==argument)
	{
		return;
	}
	metaSETTER(argument);
	return;
}
-(id)selection;
{
	id result = [self valueForKey:@"selection_meta"];
	return result;
}
-(void)setSelection:(id)new;
{
	id old = [self valueForKey:@"selection_meta"];
#if 0
	ALLWAYS change the selections
	if([old isEqual:new])
	{
		return;
	}
#endif
	[self willChangeValueForKey:@"selection"];
	[[old retain] autorelease];
	[self setValue:new forKey:@"selection_meta"];
	[self didChangeValueForKey:@"selection"];
	return;
}
-(id)keyBindingSelection;
{
	id result = [self valueForKey:@"keyBindingSelection_meta"];
	return result;
}
-(void)setKeyBindingSelection:(id)new;
{
	id old = [self valueForKey:@"keyBindingSelection_meta"];
	if([old isEqual:[self selection]])
	{
		[self setSelection:nil];
	}
	if([old isEqual:new])
	{
		return;
	}
	[self willChangeValueForKey:@"canAddChildKeyBinding"];
	[self willChangeValueForKey:@"canAddKeyBinding"];
	[self willChangeValueForKey:@"keyBindingSelection"];
	[[old retain] autorelease];
	[self setValue:new forKey:@"keyBindingSelection_meta"];
	[self didChangeValueForKey:@"keyBindingSelection"];
	[self didChangeValueForKey:@"canAddKeyBinding"];
	[self didChangeValueForKey:@"canAddChildKeyBinding"];
	return;
}
-(id)macroSelection;
{
	id result = [self valueForKey:@"macroSelection_meta"];
	return result;
}
-(void)setMacroSelection:(id)new;
{
	id old = [self valueForKey:@"macroSelection_meta"];
	if([old isEqual:[self selection]])
	{
		[self setSelection:nil];
	}
	if([old isEqual:new])
	{
		return;
	}
	[self willChangeValueForKey:@"macroSelection"];
	[old removeObserver:self forKeyPath:@"ID"];
	[[old retain] autorelease];
	[self setValue:new forKey:@"macroSelection_meta"];
	[new addObserver:self forKeyPath:@"ID" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
	[self didChangeValueForKey:@"macroSelection"];
	return;
}
-(void)setupSelection;
{
	id keyBindingSelection = nil;
	id macroSelection = nil;
	id selections = nil;
	if([self isEditingKeyBinding])
	{
		selections = [self keysTreeController];
		selections = [selections selectedObjects];
		NSString * ID;
		if([selections count] == 1)
		{
			keyBindingSelection = [selections lastObject];
			ID = [keyBindingSelection ID];
			if(![keyBindingSelection countOfChildren])
			{
				macroSelection = [self macroEditor];
				macroSelection = [macroSelection objectInAvailableMacrosWithID:ID];
			}
		}
		else if([selections count] > 1)
		{
			id IDs = [selections valueForKey:@"ID"];
			IDs = [NSSet setWithArray:IDs];
			if([IDs count] == 1)
			{
				ID = [IDs anyObject];
				macroSelection = [self macroEditor];
				macroSelection = [macroSelection objectInAvailableMacrosWithID:ID];
			}
		}
	}
	else
	{
		selections = [self macrosArrayController];
		selections = [selections selectedObjects];
		if([selections count] == 1)
		{
			macroSelection = [selections lastObject];
		}
	}
	[self setKeyBindingSelection:keyBindingSelection];
	[self setMacroSelection:macroSelection];
	[self setSelection:(macroSelection?:keyBindingSelection)];
	return;
}
-(unsigned int)masterTabViewItemIndex;
{
	return [SUD integerForKey:@"iTM2MacroMasterTabViewItemIndex"];
}
-(void)setMasterTabViewItemIndex:(unsigned int)newIndex;// the macro/key tabView
{
	unsigned int oldIndex = [SUD integerForKey:@"iTM2MacroMasterTabViewItemIndex"];
	if(oldIndex != newIndex)
	{
		[self willChangeValueForKey:@"isEditingKeyBinding"];
		[self willChangeValueForKey:@"masterTabViewItemIndex"];
		[SUD setInteger:newIndex forKey:@"iTM2MacroMasterTabViewItemIndex"];
		[self didChangeValueForKey:@"masterTabViewItemIndex"];
		[self didChangeValueForKey:@"isEditingKeyBinding"];
		[self setupSelection];
	}
	return;
}
-(BOOL)isEditingKeyBinding;
{
	return [self masterTabViewItemIndex]!=0;
}
#if 0
THIS IS BUGGY, KVO spin lock
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  synchronizeMacroSelection
- (void)synchronizeMacroSelection;
/*"Synchronize macro and the receiver's selection.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([self isEditingKeyBinding])
	{
		// do nothing;
	}
	NSArrayController * macrosArrayController = [self macrosArrayController];
	NSArray * selectedObjects = [macrosArrayController selectedObjects];
	id selection = [self selection];
	if(!selection)
	{
		// if there is already one macro selected, use it as selection
		if([selectedObjects count] == 1)
		{
			selection = [selectedObjects lastObject];
			[self setSelection:selection];
		}
		return;
	}
	NSString * ID = [selection ID];
	id macro = [self macroEditor];
	if(macro = [macro objectInAvailableMacrosWithID:ID])
	{
		// select this macro;
		NSArray * arrangedObjects = [macrosArrayController arrangedObjects];
		unsigned int index = [arrangedObjects indexOfObject:macro];
		NSIndexSet * IS = [NSIndexSet indexSetWithIndex:index];
		[macrosArrayController setSelectionIndexes:IS];
	}
	else
	{
		[macrosArrayController setSelectionIndexes:nil];
	}
	return;
#if 0
	NSTreeController * keysTreeController = [self keysTreeController];
	NSArray * selectedObjects = [keysTreeController selectedObjects];
	NSIndexSet * indexes = [NSIndexSet indexSet];
	if([selectedObjects count] == 1)
	{
		id node = [selectedObjects lastObject];
		NSArray * arrangedObjects = [macrosArrayController arrangedObjects];
		NSEnumerator * E = [arrangedObjects objectEnumerator];
		unsigned index = 0;
		while(node = [E nextObject])
		{
			NSString * itsID = [node ID];
			if([itsID isEqual:ID])
			{
				indexes = [NSIndexSet indexSetWithIndex:index];
				break;
			}
			++index;
		}
	}
	[macrosArrayController setSelectionIndexes:indexes];
#endif
//iTM2_END;
	return;
}
- (void)synchronizeKeyBindingSelection;
{
	if(![self isEditingKeyBinding])
	{
		return;
	}
	id selection = [self selection];
	NSTreeController * keysTreeController = [self keysTreeController];
	NSArray * selectedObjects = [keysTreeController selectedObjects];
	if(!selection)
	{
		if([selectedObjects count] == 1)
		{
			selection = [selectedObjects lastObject];
			[self setSelection:selection];
			return;
		}
		[self setSelectionIndexPaths:nil];
		return;
	}
	NSString * newID = [selection ID];
	NSDictionary * contentArrayBindingDict = [keysTreeController infoForBinding:@"contentArray"];
	NSString * observedKeyPath = [contentArrayBindingDict objectForKey:NSObservedKeyPathKey];
	NSString * childrenKeyPath = [keysTreeController childrenKeyPath];
	NSMutableArray * childrenEnumeratorStack = [NSMutableArray array];
	unsigned index = 0;
	NSEnumerator * E = nil;		
	id controller = nil;
	NSIndexPath * IP = nil;
	id children = nil;
	if(controller = [contentArrayBindingDict objectForKey:NSObservedObjectKey])
	{
		if(children = [controller mutableArrayValueForKeyPath:observedKeyPath])
		{
			if([children count])
			{
#if 1
				controller = [children objectAtIndex:0];
				do
				{
					if([newID isEqual:[controller ID]])
					{
						if(![[controller children] count])
						{
							iTM2_LOG(@"FOUND:%@(%@)",controller,[controller indexPath]);
						}
					}
				}
				while(controller = [controller nextNode]);
#endif
pushed:
				E = [children objectEnumerator];
				index = 0;
poped:
				while(controller = [E nextObject])
				{
					if(children = [controller mutableArrayValueForKeyPath:childrenKeyPath])
					{
						if([children count])
						{
							IP = IP?[IP indexPathByAddingIndex:index]:[NSIndexPath indexPathWithIndex:index];
							[childrenEnumeratorStack addObject:[NSNumber numberWithUnsignedInt:index]];
							[childrenEnumeratorStack addObject:E];
							goto pushed;
						}
						else
						{
							NSString * itsID = [controller ID];
							if([itsID isEqual:newID])
							{
								IP = IP?[IP indexPathByAddingIndex:index]:[NSIndexPath indexPathWithIndex:index];
								childrenEnumeratorStack =  nil;
								E = nil;
								// this will break here
							}
						}
					}
					++index;
				}
				if(E = [childrenEnumeratorStack lastObject])
				{
					[childrenEnumeratorStack removeLastObject];
					index = [[childrenEnumeratorStack lastObject] unsignedIntValue];
					[childrenEnumeratorStack removeLastObject];
					IP = [IP indexPathByRemovingLastIndex];
					++index;
					goto poped;
				}
			}
		}
	}
	if(IP)
	{
		[keysTreeController setSelectionIndexPaths:[NSArray arrayWithObject:IP]];
	}
	else
	{
		[self setSelection:nil];
	}
	return;
}
#endif
- (void)macroNode:(iTM2MacroNode *)node didChangeIDFrom:(NSString *)oldID to:(NSString *)newID;
{
	if(!node)
	{
		return;
	}
	id parent = [node parent];
	id D = [parent valueForKeyPath:@"value.cachedChildrenIDs"];
	[D removeObjectForKey:oldID];
	[D setObject:node forKey:newID];
	NSTreeController * keysTreeController = [self keysTreeController];
	NSDictionary * contentArrayBindingDict = [keysTreeController infoForBinding:@"contentArray"];
	NSString * observedKeyPath = [contentArrayBindingDict objectForKey:NSObservedKeyPathKey];
	NSString * childrenKeyPath = [keysTreeController childrenKeyPath];
	NSMutableArray * childrenEnumeratorStack = [NSMutableArray array];
	NSEnumerator * E = nil;		
	id controller = nil;
	id children = nil;
	if(controller = [contentArrayBindingDict objectForKey:NSObservedObjectKey])
	{
		if(children = [controller mutableArrayValueForKeyPath:observedKeyPath])
		{
			if([children count])
			{
pushed:
				E = [children objectEnumerator];
poped:
				while(controller = [E nextObject])
				{
					if(children = [controller mutableArrayValueForKeyPath:childrenKeyPath])
					{
						if([children count])
						{
							[childrenEnumeratorStack addObject:E];
							goto pushed;
						}
						else
						{
							NSString * itsID = [controller ID];
							if([itsID isEqual:oldID])
							{
								[controller setID:newID];
							}
						}
					}
				}
				if(E = [childrenEnumeratorStack lastObject])
				{
					[childrenEnumeratorStack removeLastObject];
					goto poped;
				}
			}
		}
	}
}
- (void)keyBindingNode:(iTM2MacroNode *)node didChangeIDFrom:(NSString *)oldID to:(NSString *)newID;
{
	if(!node)
	{
		return;
	}
	[self setupSelection];
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  macroTestView
- (id)macroTestView;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return metaGETTER;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setMacroTestView:
- (void)setMacroTestView:(id)argument;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self willChangeValueForKey:@"macroTestView"];
    metaSETTER(argument);
	[self didChangeValueForKey:@"macroTestView"];
	return;
}
#pragma mark =-=-=-=-=-  MACROS
#warning edt: and browse: message suppor is missing (the 2 square buttons to edit external scripts)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  apply
- (IBAction)apply:(id)sender;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Sun Nov  5 16:57:31 GMT 2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	// did the argument text view saved its content?
	NSWindow * W = [sender window];
	NSResponder * firstResponder = [W firstResponder];
	[W makeFirstResponder:nil]; 
	id node = [SMC macroTree];
	[SMC saveTree:node];
	node = [SMC keyBindingTree];
	[SMC saveTree:node];
	[W makeFirstResponder:firstResponder]; 
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  canApply
- (BOOL)canApply;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Sun Nov  5 16:57:31 GMT 2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  cancel
- (IBAction)cancel:(id)sender;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Sun Nov  5 16:57:31 GMT 2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	// revert all the values to the default
	[SMC setMacroTree:nil];
	[SMC setKeyBindingTree:nil];
	[self setSelectedDomain:[self selectedDomain]];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  canCancel
- (BOOL)canCancel;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Sun Nov  5 16:57:31 GMT 2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  awakeFromNib
- (void)awakeFromNib;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Sun Nov  5 16:57:31 GMT 2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if ([[self superclass] instancesRespondToSelector:_cmd])
	{
		[super awakeFromNib];
	}
	[self addObserver:self forKeyPath:@"masterTabViewItemIndex_meta" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
	unsigned int index = [SUD integerForKey:@"iTM2MacroMasterTabViewItemIndex"];
	[self setMasterTabViewItemIndex:index];// otherwise the segmented control is not properly highlighted
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  observeValueForKeyPath:ofObject:change:context:
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Sun Nov  5 16:57:31 GMT 2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([keyPath isEqual:@"macrosArrayController.selectedObjects"]||[keyPath isEqual:@"keysTreeController.selectedObjects"])
	{
		[self setupSelection];
	}
	else if([keyPath isEqual:@"keyBindingSelection.prettyKey"])
	{
		[self willChangeValueForKey:@"canAddKeyBinding"];
		[self didChangeValueForKey:@"canAddKeyBinding"];
		[self willChangeValueForKey:@"canAddChildKeyBinding"];
		[self didChangeValueForKey:@"canAddChildKeyBinding"];
	}
	else if([keyPath isEqual:@"ID"])
	{
		// then change all the ID of the key bindings to the new one
		NSString * newID = [change objectForKey:NSKeyValueChangeNewKey];
		NSString * oldID = [change objectForKey:NSKeyValueChangeOldKey];
		id node = [self keyBindingEditor];
		while(node = [node nextNode])
		{
			if([[node ID] isEqual:oldID])
			{
				[node setID:newID];
			}
		}
	}
#if 0
	else
	{
		[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
	}
#endif
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  bindingsDealloc
- (void)bindingsDealloc;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Sun Nov  5 16:57:31 GMT 2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self setMacrosArrayController:nil];
	[self setKeysTreeController:nil];
	[self setSelection:nil];
	[self setMacroSelection:nil];
	[self setKeyBindingSelection:nil];
	[self removeObserver:self forKeyPath:@"macrosArrayController.selectedObjects"];
	[self removeObserver:self forKeyPath:@"keysTreeController.selectedObjects"];
	[self removeObserver:self forKeyPath:@"keyBindingSelection.prettyKey"];
//iTM2_END;
    return;
}
- (BOOL)canAddKeyBinding;
{
	NSTreeController * KTC = [self keysTreeController];
	NSArray * SOs = [KTC selectedObjects];
	if([SOs count] > 1)
	{
		return NO;
	}
	iTM2KeyBindingNode * node = nil;
	if([SOs count] == 0)
	{
		// can I add at the topmost level?
		node = [self keyBindingEditor];
	}
	else
	{
		node = [SOs lastObject];
		node = [node parent];// this will be remove in the method below
	}
	node = [node objectInAvailableKeyBindingsWithKey:@""];
	return node == nil;
}
- (BOOL)canAddChildKeyBinding;
{
	NSTreeController * KTC = [self keysTreeController];
	NSArray * SOs = [KTC selectedObjects];
	if([SOs count] > 1)
	{
		return NO;
	}
	iTM2KeyBindingNode * node = nil;
	if([SOs count] == 0)
	{
		// can I add at the topmost level?
		node = [self keyBindingEditor];
	}
	else
	{
		node = [SOs lastObject];// not its parent!
		if([node valueForKey:@"keyStroke"] == nil)
		{
			return NO;
		}
	}
	node = [node objectInAvailableKeyBindingsWithKey:@""];
	return node == nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  loadMainView
- (NSView *) loadMainView;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(![NSValueTransformer valueTransformerForName:@"iTM2HumanReadableActionName"])
	{
		iTM2HumanReadableActionNameValueTransformer * transformer = [[[iTM2HumanReadableActionNameValueTransformer alloc] init] autorelease];
		[NSValueTransformer setValueTransformer:transformer forName:@"iTM2HumanReadableActionName"];
	}
	if(![NSValueTransformer valueTransformerForName:@"iTM2TabViewItemIdentifierForAction"])
	{
		iTM2TabViewItemIdentifierForActionValueTransformer * transformer = [[[iTM2TabViewItemIdentifierForActionValueTransformer alloc] init] autorelease];
		[NSValueTransformer setValueTransformer:transformer forName:@"iTM2TabViewItemIdentifierForAction"];
	}
	// initialize the domains and modes
	id MD = [self contextDictionaryForKey:@"iTM2MacroEditorSelection" domain:iTM2ContextAllDomainsMask];
	if(!MD)
	{
		MD = [NSMutableDictionary dictionary];
	}
	NSString * selectedDomain = [self selectedDomain];
	NSArray * availableDomains = [self availableDomains];
	if(![availableDomains containsObject:selectedDomain])
	{
		selectedDomain = [availableDomains lastObject];
	}
	[self setSelectedDomain:selectedDomain];// this will cascade all the initialization	
	[self addObserver:self forKeyPath:@"macrosArrayController.selectedObjects" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
	[self addObserver:self forKeyPath:@"keysTreeController.selectedObjects" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
	[self addObserver:self forKeyPath:@"keyBindingSelection.prettyKey" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
//iTM2_END;
    return [super loadMainView];
}
@end

@implementation iTM2MacroList(Prefs_PRIVATE)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  _X_availableScripts
- (NSArray *)_X_availableScripts;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Sun Nov  5 16:57:31 GMT 2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSMutableArray * result = [self valueForKeyPath:@"value.availableScripts"];
	if(result)
	{
		return result;
	}
	result = [NSMutableArray array];
	id parent = [self parent];
	NSString * category = [parent valueForKeyPath:@"value.category"];
	parent = [parent parent];
	NSString * subpath = [parent valueForKeyPath:@"value.domain"];
	subpath = [subpath stringByAppendingPathComponent:category];
	subpath = [subpath stringByAppendingPathComponent:iTM2MacroScriptsComponent];
	NSBundle * MB = [NSBundle mainBundle];
	NSArray * RA = [MB allPathsForResource:iTM2MacrosDirectoryName ofType:iTM2LocalizedExtension];
	NSEnumerator * E = [RA objectEnumerator];
	NSString * path;
	while(path = [E nextObject])
	{
		if([DFM pushDirectory:path])
		{
			if([DFM pushDirectory:subpath])
			{
				NSDirectoryEnumerator * DE = [DFM enumeratorAtPath:@"."];
				while(path = [DE nextObject])
				{
					BOOL flag;
					if([path hasPrefix:@"."])
					{
						// do nothing, this is a hidden file
					}
					else
					{
						
						if([path hasPrefix:@"."])// missing finder test (kIsVisibleFlag?)
						{
							// do nothing, this is a hidden file here too
						}
						else if([DFM fileExistsAtPath:path isDirectory:&flag] && flag)
						{
							// do nothing, this is a directory
						}
						else
						{
							[result addObject:path];
						}
					}
				}
				[DFM popDirectory];
			}
			else if([DFM fileExistsAtPath:subpath isDirectory:nil])
			{
				iTM2_LOG(@"*** SILENT Error: could not push \"%@/%@\"",[DFM currentDirectoryPath],subpath);
			}
			[DFM popDirectory];
		}
		else
		{
			iTM2_LOG(@"*** SILENT Error: could not push \"%@\"",path);
		}
	}
	[result sortUsingSelector:@selector(compare:)];
	[self setValue:result forKeyPath:@"value.availableScripts"];
//iTM2_END;
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  countOfAvailableScripts
- (unsigned int)countOfAvailableScripts;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Sun Nov  5 16:57:31 GMT 2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return [[self _X_availableScripts] count];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  objectInAvailableScriptsAtIndex:
- (id)objectInAvailableScriptsAtIndex:(int) index;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Sun Nov  5 16:57:31 GMT 2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return [[self _X_availableScripts] objectAtIndex:index];
}
@end

/*"Description forthcoming."*/
@interface iTM2MacroArrayController: NSArrayController
@end

@implementation iTM2MacroArrayController
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  canRemove
- (BOOL)canRemove;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSIndexSet * indexSet = [self selectionIndexes];
	NSArray * RA = [self arrangedObjects];
	unsigned int index = [indexSet firstIndex];
	while(index != NSNotFound)
	{
		id O = [RA objectAtIndex:index];
		if([O respondsToSelector:@selector(isMutable)] && [O isMutable])
		{
			return YES;
		}
		index = [indexSet indexGreaterThanIndex:index];
	}
	RA = [self content];
//iTM2_END;
    return NO;
}
- (void)insertObject:(id)object atArrangedObjectIndex:(unsigned int)index;    // inserts into the content objects and the arranged objects (as specified by index in the arranged objects) - will raise an exception if the object does not match all filters currently applied
{
	[super insertObject:(id)object atArrangedObjectIndex:(unsigned int)index];
	NSArray * arrangedObjects = [self arrangedObjects];
	index = [arrangedObjects indexOfObject:object];
	[self setSelectionIndex:index];
	return;
}
@end










@interface iTM2MacroTableView:NSTableView
@end

@implementation iTM2MacroTableView
- (void)copy:(id)sender;
{
	NSArray *columns = [self tableColumns];
	unsigned columnIndex = 0, columnCount = [columns count];
	NSDictionary *valueBindingDict = nil;
	for (; !valueBindingDict && columnIndex < columnCount; ++columnIndex) {
		valueBindingDict = [[columns objectAtIndex:columnIndex] infoForBinding:@"value"];
	}
	id arrayController = [valueBindingDict objectForKey:NSObservedObjectKey];
	if ([arrayController isKindOfClass:[NSArrayController class]]) {
		//	Found a column bound to an array controller.
		NSArray * selectedObjects = [arrayController selectedObjects];
		if([selectedObjects count])
		{
			NSMutableDictionary * copy = [NSMutableDictionary dictionary];
			NSMutableArray * IDs = [NSMutableArray array];
			[copy setObject:IDs forKey:@"IDs"];
			id node = [selectedObjects lastObject];
			node = [node parent];// the list
			node = [node parent];// the context
			NSString * context = [node valueForKeyPath:@"value.context"];
			node = [node parent];
			NSString * category = [node valueForKeyPath:@"value.category"];
			node = [node parent];
			NSString * domain = [node valueForKeyPath:@"value.domain"];
			[copy setObject:domain forKey:@"domain"];
			[copy setObject:category forKey:@"category"];
			[copy setObject:context forKey:@"context"];
			NSEnumerator * E = [selectedObjects objectEnumerator];
			while(node = [E nextObject])
			{
				NSString * ID = [node ID];
				[IDs addObject:ID];
			}
			NSPasteboard * GP = [NSPasteboard generalPasteboard];
			NSString * type = @"iTM2MacroPBoard";
			NSArray * newTypes = [NSArray arrayWithObject:type];
			[GP declareTypes:newTypes owner:nil];
			[GP setPropertyList:copy forType:type];
		}
	}
	return;
}
- (BOOL)validateCopy:(id)sender;
{
	NSArray *columns = [self tableColumns];
	unsigned columnIndex = 0, columnCount = [columns count];
	NSDictionary *valueBindingDict = nil;
	for (; !valueBindingDict && columnIndex < columnCount; ++columnIndex) {
		valueBindingDict = [[columns objectAtIndex:columnIndex] infoForBinding:@"value"];
	}
	id arrayController = [valueBindingDict objectForKey:NSObservedObjectKey];
	if ([arrayController isKindOfClass:[NSArrayController class]]) {
		//	Found a column bound to an array controller.
		NSArray * selectedObjects = [arrayController selectedObjects];
		if([selectedObjects count])
		{
			return YES;
		}
	}
	return NO;
}
- (void)paste:(id)sender;
{
	NSPasteboard * GP = [NSPasteboard generalPasteboard];
	NSArray * types = [NSArray arrayWithObject:@"iTM2MacroPBoard"];
	NSString * availableType = [GP availableTypeFromArray:types];
	if(!availableType)
	{
		return;
	}
	NSDictionary * copies = [GP propertyListForType:availableType];
	NSString * domain = [copies objectForKey:@"domain"];
	NSString * category = [copies objectForKey:@"category"];
	NSString * context = [copies objectForKey:@"context"];
	NSArray * IDs = [copies objectForKey:@"IDs"];
	NSEnumerator * E = [IDs objectEnumerator];
	NSString * ID;
	id sourceTree = [SMC macroTree];
	sourceTree = [sourceTree objectInChildrenWithDomain:domain];
	sourceTree = [sourceTree objectInChildrenWithCategory:category];
	sourceTree = [sourceTree objectInChildrenWithContext:context];
	sourceTree = [sourceTree list];
	id targetTree = [[self delegate] macroEditor];
	id node, alreadyNode;
	while(ID = [E nextObject])
	{
		if(node = [sourceTree objectInChildrenWithID:ID])
		{
			node = [node copy];
			if(alreadyNode = [targetTree objectInChildrenWithID:ID])
			{
				//The only thing I have to do is connect the last mutableXMLElement;
				NSURL * url = [targetTree personalURL];
				NSXMLDocument * personalDocument = [targetTree documentForURL:url];
				NSXMLElement * personalRootElement = [personalDocument rootElement];
				NSMutableArray * alreadyMutableXMLElements = [alreadyNode mutableXMLElements];
				NSXMLElement * element = [alreadyMutableXMLElements lastObject];
				if(element)
				{
					NSString * XPath = [NSString stringWithFormat:@"/@ID=\"%@\"",ID];
					NSArray * RA = [personalRootElement nodesForXPath:XPath error:nil];
					id elt;
					NSEnumerator * EE = [RA objectEnumerator];
					while(elt = [EE nextObject])
					{
						[elt detach];
					}
					NSXMLDocument * rootDocument = [element rootDocument];
					if([personalDocument isEqual:rootDocument])
					{
						[alreadyMutableXMLElements removeLastObject];
					}
					[element detach];
				}
				element = [node XMLElement];
				if(!element)
				{
					element = [NSXMLElement elementWithName:@"ACTION"];
					NSXMLNode * attribute = [NSXMLNode attributeWithName:@"ID" stringValue:ID];
					[element addAttribute:attribute];
				}
				[element detach];
				[personalRootElement addChild:element];
				[alreadyNode addMutableXMLElement:element];
			}
			else
			{
				[targetTree insertObject:node inAvailableMacrosAtIndex:0];
			}
		}
		else
		{
			iTM2_LOG(@"No macro with domain:%@, category:%@, context:%@, ID:%@",
				domain,category,context,ID);
		}
	}
	return;
}
- (BOOL)validatePaste:(id)sender;
{
	NSPasteboard * GP = [NSPasteboard generalPasteboard];
	NSArray * types = [NSArray arrayWithObject:@"iTM2MacroPBoard"];
	NSString * availableType = [GP availableTypeFromArray:types];
	return availableType != nil;
}
@end

#import <iTM2Foundation/iTM2KeyBindingsKit.h>

@interface iTM2KeyBindingOutlineView:NSOutlineView
@end

@implementation iTM2KeyBindingOutlineView
- (void)keyDown:(NSEvent *)theEvent;
{
	unsigned int modifierFlags = [theEvent modifierFlags];
	modifierFlags = modifierFlags & NSDeviceIndependentModifierFlagsMask;
	if(((modifierFlags&NSFunctionKeyMask)==0) && [self numberOfSelectedRows]==1)
	{
//		if((modifierFlags&NSFunctionKeyMask)==0)
		{
#if 0
			// this does not work
			int selectedRow = [self selectedRow];
			id item = [self itemAtRow:selectedRow];
			iTM2_LOG(@"item:%@",item);
#endif
			// see http://svn.sourceforge.net/viewvc/redshed/trunk/cocoa/NSTableView%2BCocoaBindingsDeleteKey/NSTableView%2BCocoaBindingsDeleteKey.m?view=markup
			NSArray *columns = [self tableColumns];
			unsigned columnIndex = 0, columnCount = [columns count];
			NSDictionary *valueBindingDict = nil;
			for (; !valueBindingDict && columnIndex < columnCount; ++columnIndex) {
				valueBindingDict = [[columns objectAtIndex:columnIndex] infoForBinding:@"value"];
			}
			id treeController = [valueBindingDict objectForKey:NSObservedObjectKey];
			if ([treeController isKindOfClass:[NSTreeController class]]) {
				//	Found a column bound to a tree controller.
				NSArray * selectedObjects = [treeController selectedObjects];
				id selection = [selectedObjects lastObject];
				// first turn the event into a key stroke object
				iTM2MacroKeyStroke * keyStroke = [theEvent macroKeyStroke];
				NSString * key = [keyStroke string];
				// is this key already used by the selection?
				if([key isEqual:[selection key]])
				{
					iTM2_LOG(@"No change: it is the same key.");
					return;
				}
				// is there already a binding with that key
				id parent = [selection parent];
				id alreadyBinding = [parent objectInAvailableKeyBindingsWithKey:key];
				NSError * error = nil;
				if(alreadyBinding)
				{
					// do they have the same ID
					NSString * ID = [selection ID];
					NSString * alreadyID = [alreadyBinding ID];
					if([ID isEqual:alreadyID])
					{
						iTM2_LOG(@"No change: this binding already exists.");
						return;
					}
					#warning Change the selection of the outline view
					if([alreadyBinding beMutable] && [alreadyBinding validateID:&key error:&error])
					{
						[alreadyBinding setID:ID];// only now: before the object was not mutable and could not change its ID
						if([[selection XMLElements] lastObject])
						{
							[selection beMutable];
							[selection setID:@"noop:"];
						}
						else
						{
							unsigned index = [parent indexOfObjectInAvailableKeyBindings:selection];
							[parent removeObjectFromAvailableKeyBindingsAtIndex:index];
						}
						NSIndexPath * IP = [alreadyBinding indexPath];
						[treeController setSelectionIndexPath:IP];
						[[self delegate] setupSelection];
						return;
					}
				}
				else if([selection beMutable] && [selection validateKey:&key error:&error])
				{
					[selection setKey:key];// only now: before the object was not mutable and could not change its key
					return;
				}
				iTM2_LOG(@"error:%@",error);
				return;
			}
#if 0
				NSAlphaShiftKeyMask =		1 << 16,
	 =		1 << 17,
	NSControlKeyMask =		1 << 18,
	NSAlternateKeyMask =		1 << 19,
	NSCommandKeyMask =		1 << 20,
	NSNumericPadKeyMask =		1 << 21,
	NSHelpKeyMask =			1 << 22,
	NSFunctionKeyMask =		1 << 23,
#endif
		}
	}
	[super keyDown:theEvent];
	return;
}
@end

@interface iTM2MacroPopUpButton:NSPopUpButton
@end

@implementation iTM2MacroPopUpButton
- (void)awakeFromNib;
{
	if([[self superclass] instancesRespondToSelector:_cmd])
	{
		[super awakeFromNib];
	}
	NSView * superview = [self superview];
	[self retain];
	[self removeFromSuperviewWithoutNeedingDisplay];
	[superview addSubview:self positioned:NSWindowBelow relativeTo:nil];
	return;
}
@end

@interface iTM2MacroEditor:NSTextView
@end

@implementation iTM2MacroEditor
@end

#import <iTM2Foundation/iTM2TextDocumentKit.h>

@interface iTM2MacroTestView:iTM2TextEditor
@end

#import "iTM2MacroKit_Action.h"

@implementation iTM2MacroTestView
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= testMacro:
- (void)testMacro:(id)sender;// the sender is the table view sometimes
{
	//sender is an array of selected objects
	NSEnumerator * E = [sender objectEnumerator];
	while(sender = [E nextObject])
	{
		if([sender respondsToSelector:@selector(executeMacroWithTarget:selector:substitutions:)])
		{
			[sender executeMacroWithTarget:self selector:NULL substitutions:nil];
		}
		else if([sender isKindOfClass:[iTM2KeyBindingNode class]])
		{
			NSString * ID = [sender ID];
			NSString * domain = [self macroDomain];
			NSString * category = [self macroCategory];
			NSString * context = @"";//[self macroContext];
			[SMC executeMacroWithID:ID forContext:context ofCategory:category inDomain:domain target:self];
		}
	}
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= macroDomain
- (NSString *)macroDomain;
{
    return [[self delegate] selectedDomain];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= macroCategory
- (NSString *)macroCategory;
{
    return [[self delegate] selectedMode];
}
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
@end

#import <iTM2Foundation/iTM2BundleKit.h>

static id iTM2HumanReadableActionNames = nil;
@implementation iTM2HumanReadableActionNameValueTransformer
+ (void)initialize;
{
	[super initialize];
	if(!iTM2HumanReadableActionNames)
	{
		iTM2HumanReadableActionNames = [[NSMutableDictionary dictionary] retain];
		NSBundle * MB = [NSBundle mainBundle];
		NSArray * RA = [MB allPathsForResource:@"iTM2HumanReadableActionNames" ofType:@"plist"];
		NSEnumerator * E = [RA objectEnumerator];
		NSString * path;
		while(path = [E nextObject])
		{
			NSDictionary * D = [NSDictionary dictionaryWithContentsOfFile:path];
			if(D)
			{
				[iTM2HumanReadableActionNames addEntriesFromDictionary:D];
			}
		}
	}
	return;
}
+ (NSArray *)actionNames;
{
	return [iTM2HumanReadableActionNames allKeys];
}
+ (BOOL)allowsReverseTransformation;
{
	return YES;
}
- (id)transformedValue:(id)value;
{
	id result = nil;
	if([value isKindOfClass:[NSArray class]])
	{
		result = [NSMutableArray array];
		NSEnumerator * E = [value objectEnumerator];
		while(value = [E nextObject])
		{
			id transformedValue = [self transformedValue:value];
			[result addObject:(transformedValue?:value)];
		}
		return result;
	}
	if(result = [iTM2HumanReadableActionNames objectForKey:value])
	{
		return result;
	}
	return value;
}
- (id)reverseTransformedValue:(id)value;
{
	if([value isKindOfClass:[NSArray class]])
	{
		NSMutableArray * result = [NSMutableArray array];
		NSEnumerator * E = [value objectEnumerator];
		while(value = [E nextObject])
		{
			id reverseTransformedValue = [self reverseTransformedValue:value];
			[result addObject:(reverseTransformedValue?:value)];
		}
		return result;
	}
	id result = [iTM2HumanReadableActionNames allKeysForObject:value];
	return [result lastObject]?:value;
}
@end

@implementation iTM2TabViewItemIdentifierForActionValueTransformer
+ (BOOL)allowsReverseTransformation;
{
	return NO;
}
- (id)transformedValue:(NSString *)value;
{
	return [value hasSuffix:@"Path:"]?@"path":@"macro";
}
- (id)reverseTransformedValue:(id)value;
{
	return value;
}
@end

@implementation iTM2MacroNode(Prefs)
+ (void)prefsInitBindings;
{
    [self setKeys:[NSArray arrayWithObjects:@"argument",@"shouldShowArgument",nil]
		triggerChangeNotificationsForDependentKey:@"hiddenArgument"];
    [self setKeys:[NSArray arrayWithObjects:@"argument",nil]
		triggerChangeNotificationsForDependentKey:@"mustShowArgument"];
    [self setKeys:[NSArray arrayWithObjects:@"ID",nil]
		triggerChangeNotificationsForDependentKey:@"isVisible"];
    [self setKeys:[NSArray arrayWithObjects:@"ID",nil]
		triggerChangeNotificationsForDependentKey:@"actionName"];
    [self setKeys:[NSArray arrayWithObjects:@"actionName",nil]
		triggerChangeNotificationsForDependentKey:@"macroTabViewItemIdentifier"];
	return;
}
- (BOOL)shouldShowArgument;
{
	NSNumber * N = [self valueForKeyPath:@"value.shouldShowArgument"];
	return [N boolValue];
}
- (void)setShouldShowArgument:(BOOL)flag;
{
	if(flag != [self shouldShowArgument])
	{
		[self willChangeValueForKey:@"shouldShowArgument"];
		NSNumber * N = [NSNumber numberWithBool:flag];
		[self setValue:N forKeyPath:@"value.shouldShowArgument"];
		[self didChangeValueForKey:@"shouldShowArgument"];
	}
	return;
}
- (BOOL)mustShowArgument;
{
	return [[self argument] length] != 0;
}
- (BOOL)hiddenArgument;
{
	return ![self mustShowArgument] && ![self shouldShowArgument];
}
@end

#pragma mark -
#pragma mark =-=-=-=-=-  NOTHING BELOW THIS POINT
#pragma mark -

#if 0
#pragma mark =-=-=-=-=-  CONCRETE CONTEXT NODES
@implementation iTM2MacroAbstractContextNode

@end

#pragma mark =-=-=-=-=-  CONCRETE CONTEXT NODES
@implementation iTM2MacroContextNode
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  macroSortDescriptors
- (NSArray *)macroSortDescriptors;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Sun Nov  5 16:57:31 GMT 2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSSortDescriptor * SD = [[[NSSortDescriptor allocWithZone:[self zone]] initWithKey:@"ID" ascending:YES] autorelease];
//iTM2_END;
    return [NSArray arrayWithObject:SD];
}
@end

@interface iTM2MacroController(PRIVATE)
-- (void)setSelectedMode:(NSString *)mode;
- (void)macroNode:(iTM2MacroNode *)node didChangeIDFrom:(NSString *)oldID to:(NSString *)newID;
- (id)keyBindingTree;
- (void)synchronizeMacroSelectionWithKeyBindingSelection;
- (void)synchronizeKeyBindingSelection;
- (id)keysTreeController;
@end

@implementation iTM2MacroNode: iTM2TreeNode
- (BOOL)isVisible;
{
	return ![[self ID] hasPrefix:@"."];
}
- (NSString *)macroDescription;
{
	NSXMLElement * element = [self XMLElement];
	NSError * localError = nil;
	NSArray * nodes = [element nodesForXPath:@"DESC" error:&localError];
	if(localError)
	{
		iTM2_LOG(@"localError: %@", localError);
		return @"Error: no description.";
	}
	NSXMLNode * node = [nodes lastObject];
	if(node)
	{
		return [node stringValue];
	}
	else
	{
		return @"No description available";
	}
}
- (NSString *)mode;
{
	NSXMLElement * element = [self XMLElement];
	NSError * localError = nil;
	NSArray * nodes = [element nodesForXPath:@"@MODE" error:&localError];
	if(localError)
	{
		iTM2_LOG(@"localError: %@", localError);
		return @"Error: MODE attribute?";
	}
	NSXMLNode * node = [nodes lastObject];
	if(node)
	{
		return [node stringValue];
	}
	else
	{
		return @"";
	}
}
@end

@interface iTM2MacroMenuNode: iTM2MacroContextNode
@end

@implementation iTM2MacroMenuNode
@end


@implementation iTM2MacroController

static id _iTM2MacroController = nil;
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= load
+ (void)load;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
	iTM2_INIT_POOL;
	iTM2RedirectNSLogOutput();
//iTM2_START;
	if(![NSValueTransformer valueTransformerForName:@"iTM2HumanReadableActionName"])
	{
		iTM2HumanReadableActionNameValueTransformer * transformer = [[[iTM2HumanReadableActionNameValueTransformer alloc] init] autorelease];
		[NSValueTransformer setValueTransformer:transformer forName:@"iTM2HumanReadableActionName"];
	}
	if(![NSValueTransformer valueTransformerForName:@"iTM2TabViewItemIdentifierForAction"])
	{
		iTM2TabViewItemIdentifierForActionValueTransformer * transformer = [[[iTM2TabViewItemIdentifierForActionValueTransformer alloc] init] autorelease];
		[NSValueTransformer setValueTransformer:transformer forName:@"iTM2TabViewItemIdentifierForAction"];
	}
//iTM2_END;
	iTM2_RELEASE_POOL;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= ___catch:
- (void)___catch:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= validate___catch:
- (BOOL)validate___catch:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= ___insertMacro:
- (void)___insertMacro:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSArray * RA = [sender representedObject];
	if([RA isKindOfClass:[NSArray class]] && [RA count])
	{
		NSString * ID = [RA objectAtIndex:0];
		NSString * context;
		NSString * category;
		NSString * domain;
		if([RA count] > 3)
		{
			context = [RA objectAtIndex:1];
			category = [RA objectAtIndex:2];
			domain = [RA objectAtIndex:3];
		}
		else
		{
			context = @"";
			if([RA count] > 2)
			{
				category = [RA objectAtIndex:1];
				domain = [RA objectAtIndex:2];
			}
			else
			{
				category = @"";
				if([RA count] > 1)
				{
					context = @"";
					domain = [RA objectAtIndex:1];
				}
				else
				{
					domain = @"";
				}
			}
		}
		if([ID length])
		{
			if([SMC executeMacroWithID:ID forContext:context ofCategory:category inDomain:domain target:nil])
			{
				NSMenu * recentMenu = [self macroMenuForContext:context ofCategory:@"Recent" inDomain:domain error:nil];
				int index = [recentMenu indexOfItemWithTitle:[sender title]];
				if(index!=-1)
				{
					[recentMenu removeItemAtIndex:index];
				}
				NSMenuItem * MI = [[[NSMenuItem alloc] initWithTitle:[sender title] action:[sender action] keyEquivalent:@""] autorelease];
				[MI setTarget:self];// self is expected to last forever
				[MI setRepresentedObject:RA];
				[recentMenu insertItem:MI atIndex:1];
				NSMutableDictionary * MD = [NSMutableDictionary dictionary];
				index = 0;
				int max = [SUD integerForKey:@"iTM2NumberOfRecentMacros"];
				while([recentMenu numberOfItems] > max)
				{
					[recentMenu removeItemAtIndex:[recentMenu numberOfItems]-1];
				}
				while(++index < [recentMenu numberOfItems])
				{ 
					MI = [recentMenu itemAtIndex:index];
					RA = [MI  representedObject];
					if(RA)
					{
						[MD setObject:RA forKey:[MI title]];
					}
				}
				[SUD setObject:MD forKey:[NSString pathWithComponents:[NSArray arrayWithObjects:@"", @"Recent", domain, nil]]];
			}
		}
	}
	else if(RA)
	{
		iTM2_LOG(@"Unknown design [sender representedObject]:%@", RA);
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= validate___insertMacro:
- (BOOL)validate___insertMacro:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSArray * RA = [sender representedObject];
	if([RA isKindOfClass:[NSArray class]] && ([RA count] > 2))
	{
		NSString * ID = [RA objectAtIndex:0];
		if([ID length])
			return YES;
	}
	iTM2_LOG(@"sender is:%@",sender);
//iTM2_END;
    return [sender hasSubmenu];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= executeMacroWithText:forContext:ofCategory:inDomain:target:
- (BOOL)executeMacroWithText:(NSString *)text forContext:(NSString *)context ofCategory:(NSString *)category inDomain:(NSString *)domain target:(id)target;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	unsigned idx = 0;
	BOOL result = NO;
	while(idx<[text length])
	{
		NSString * type = nil;
		NSRange range = [text rangeOfNextPlaceholderMarkAfterIndex:idx getType:&type ignoreComment:YES];
		if(!range.length)
		{
			return NO;
		}
		else if(type)
		{
			NSRange fullRange = [text rangeOfPlaceholderAtIndex:range.location getType:nil ignoreComment:YES];
			if(fullRange.location == range.location && fullRange.length > range.length)
			{
				fullRange.length = NSMaxRange(fullRange);
				fullRange.location = NSMaxRange(range);
				if(fullRange.length>fullRange.location)
				{
					fullRange.length-=fullRange.location;
					if(fullRange.length>4)
					{
						fullRange.length-=4;
						text = [text substringWithRange:fullRange];
						iTM2MacroNode * leafNode = [self macroRunningNodeForID:text context:context ofCategory:category inDomain:domain];
						SEL action = NULL;
						NSString * actionName = [NSString stringWithFormat:@"insertMacro_%@:",type];
						action = NSSelectorFromString(actionName);
						result = result || [leafNode executeMacroWithTarget:target selector:action substitutions:nil];
					}
				}
			}
		}
		idx = NSMaxRange(range);
	}

//iTM2_START;
	return NO;
}
#pragma mark =-=-=-=-=-  PREFERENCES
- (BOOL)canEditActionName;
{
	iTM2MacroNode * node = [self selectedMacro];
	return [node isVisible];
}
- (BOOL)canEdit;
{
	iTM2MacroNode * node = [self selectedMacro];
	return [node isVisible];
}
- (BOOL)canHideArgumentView;
{
	iTM2MacroNode * node = [self selectedMacro];
	NSString * argument = [node argument];
	return [argument length]==0;
}
- (BOOL)showArgumentView;
{
	id result = metaGETTER;
	if([result boolValue])
	{
		return YES;
	}
	iTM2MacroNode * node = [self selectedMacro];
	NSString * argument = [node argument];
	return [argument length]>0;
}
#pragma mark =-=-=-=-=-  DELEGATE
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  menuNeedsUpdate:
- (void)menuNeedsUpdate:(NSMenu *)menu;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Sun Nov  5 16:57:31 GMT 2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	// availableModes:
	NSArray * itemArray = [menu itemArray];
	NSEnumerator * E = [itemArray objectEnumerator];
	NSMenuItem * MI = nil;
	SEL action = @selector(takeMacroModeFromRepresentedObject:);
	NSMutableArray * availableModes = [NSMutableArray array];
	NSString * mode;
	while(MI = [E nextObject])
	{
		if([MI action] == action)
		{
			mode = [MI representedObject];
			if(![availableModes containsObject:mode])
			{
				[availableModes addObject:mode];
			}
		}
	}
	// expected modes:
	id firstResponder = [NSApp keyWindow];
	firstResponder = [firstResponder firstResponder];
	NSString * domain = [firstResponder macroDomain];
	iTM2MacroRootNode * rootNode = [self macroTree];
	iTM2MacroDomainNode * domainNode = [rootNode objectInChildrenWithDomain:domain];
	NSArray * expectedModes = [domainNode availableCategories];
	//
	if([expectedModes isEqual:availableModes])
	{
		return;
	}
	// remove items with takeMacroModeFromRepresentedObject:
	E = [itemArray objectEnumerator];
	while(MI = [E nextObject])
	{
		if([MI action] == action)
		{
			[menu removeItem:MI];
		}
	}
	// recover the "Mode:" title menu item
	int index = [menu indexOfItemWithRepresentedObject:@"iTM2_PRIVATE_MacroModeMenuItem"];
	++index;

	E = [expectedModes objectEnumerator];
	while(mode = [E nextObject])
	{
		MI = [[[NSMenuItem allocWithZone:[menu zone]] initWithTitle:[mode description] action:action keyEquivalent:@""] autorelease];
		[MI setRepresentedObject:mode];
		[MI setIndentationLevel:1];
		[menu insertItem:MI atIndex:index++];
	}
	MI = [NSMenuItem separatorItem];
	[menu insertItem:MI atIndex:index++];
	[menu cleanSeparators];
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  outlineViewSelectionDidChange:
- (void)outlineViewSelectionDidChange:(NSNotification *)notification;
/*"Synchronize macro selection with key binding selection.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSOutlineView * outlineView = [notification object];
	NSWindow * W = [outlineView window];
	if(outlineView != [W firstResponder])
	{
		return;
	}
	[self synchronizeMacroSelectionWithKeyBindingSelection];
//iTM2_END;
	return;
}
@end

#import <iTM2Foundation/iTM2InstallationKit.h>

@implementation iTM2MainInstaller(iTM2MacroKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2MacroKitCompleteInstallation
+ (void)iTM2MacroKitCompleteInstallation;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSMenu * M = [NSApp mainMenu];
	NSMenuItem * MI = [M deepItemWithAction:@selector(macroMode:)];
	if(MI)
	{
		M = [MI menu];
		[MI setAction:NULL];
		[MI setRepresentedObject:@"iTM2_PRIVATE_MacroModeMenuItem"];
		[M setDelegate:SMC];
	}
	else
	{
		iTM2_LOG(@"No macros menu");
	}
//iTM2_END;
    return;
}
@end


@implementation iTM2GenericScriptButton
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= macroMenu
- (NSMenu *)macroMenu;// don't call this "menu"!
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * name = NSStringFromClass([self class]);
	NSRange R1 = [name rangeOfString:@"Script"];
	if(R1.length)
	{
		NSRange R2 = [name rangeOfString:@"Button"];
		if(R2.length && (R1.location += R1.length, (R2.location > R1.location)))
		{
			R1.length = R2.location - R1.location;
			NSString * context = [name substringWithRange:R1];
			NSString * category = [self macroCategory];
			NSString * domain = [self macroDomain];
			NSMenu * M = [SMC macroMenuForContext:context ofCategory:category inDomain:domain error:nil];
			M = [[M deepCopy] autorelease];
			// insert a void item for the title
			[M insertItem:[[[NSMenuItem alloc] initWithTitle:@"" action:NULL keyEquivalent:@""] autorelease] atIndex:0];// for the title
			return M;
		}
	}
//iTM2_END;
    return [[[NSMenu allocWithZone:[NSMenu menuZone]] initWithTitle:@""] autorelease];
}

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= awakeFromNib
- (void)awakeFromNib;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([[iTM2GenericScriptButton superclass] instancesRespondToSelector:_cmd])
		[super awakeFromNib];
	[[self retain] autorelease];
	NSView * superview = [self superview];
	[self removeFromSuperviewWithoutNeedingDisplay];
	[superview addSubview:self];
	[DNC addObserver:self selector:@selector(popUpButtonCellWillPopUpNotification:) name:NSPopUpButtonCellWillPopUpNotification object:[self cell]];
	[[self cell] setAutoenablesItems:YES];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= popUpButtonCellWillPopUpNotification:
- (void)popUpButtonCellWillPopUpNotification:(NSNotification *)notification;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self setMenu:[self macroMenu]];
	[DNC removeObserver:self];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= dealloc
- (void)dealloc;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[DNC removeObserver:self];
	[super dealloc];
//iTM2_END;
    return;
}
@end

#pragma mark -
#import <iTM2Foundation/iTM2StringKit.h>


#import <iTM2Foundation/NSTextStorage_iTeXMac2.h>

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  NSTextStorage(iTM2Selection_MACRO)
/*"Description forthcoming."*/
@implementation NSTextStorage(iTM2Selection_MACRO)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  insertMacro:inRangeValue:
- (void)insertMacro:(id)argument inRangeValue:(id)rangeValue;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if([argument isKindOfClass:[NSString class]] || [argument isKindOfClass:[NSDictionary class]])
    {
        NSTextView * TV = [self mainTextView];
        if([rangeValue respondsToSelector:@selector(rangeValue)])
            [TV setSelectedRange:[rangeValue rangeValue]];
        [TV insertMacro:argument];        
    }
    else
    {
        NSLog(@"JL, you should have raised an exception!!! (code 1789)");
    }
    return;
}
@end
#endif