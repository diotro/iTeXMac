/*
//
//  @version Subversion: $Id: iTM2MacroKit_Prefs.h 494 2007-05-11 06:22:21Z jlaurens $ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Thu Feb 21 2002.
//  Copyright © 2001-2007 Laurens'Tribune. All rights reserved.
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

/*!
	@header			iTM2MacroKit_Prefs
	@abstract		Managing the macro preferences.
	@discussion		The preferences are more difficult to manage because we must read and write data.
	
	@availability	iTM2.
	@copyright		2007 jlaurens AT users DOT sourceforge DOT net and others.
	@updated		today
	@version		1
*/

@interface iTM2PrefsMacroNode:iTM2MacroNode
{
@private
	BOOL shouldShowArgument;
	id owner;
}
- (NSString *)actionName;
- (BOOL)isVisible;
- (BOOL)isMessage;
- (id)owner;
- (void)setOwner:(id)anOwner;
@end

@interface iTM2MutableMacroNode:iTM2PrefsMacroNode
- (void)setActionName:(NSString *)newActionName;
@end

#import <iTM2Foundation/iTM2MacroKit_Tree.h>
@interface iTM2MacroAbstractContextNode(Preferences)
- (id)list;// used by the pref pane
@end

// the iTM2MacroList maintains 2 list of macros (as dictionaries), the first one comes from the Personal.iTM2-macros file
// the other one comes from all the other macros files that have been merged
@interface iTM2MacroList:iTM2TreeNode
- (id)initWithParent:(id)parent;
- (NSMutableDictionary *)macros;
- (void)setMacros:(NSMutableDictionary *)newMacros;
- (NSMutableDictionary *)personalMacros;
- (void)setPersonalMacros:(NSMutableDictionary *)newMacros;
- (id)macroWithID:(NSString *)ID;
- (NSArray *)availableIDs;
- (void)insertObject:(id)object inAvailableMacrosAtIndex:(int)index;
- (id)objectInAvailableMacrosWithID:(NSString *)ID;
- (id)objectInAvailableMacrosAtIndex:(int)index;
- (NSIndexSet *)macroSelectionIndexes;
- (void)setMacroSelectionIndexes:(NSIndexSet *)indexes;
@end

@interface iTM2PrefsKeyBindingNode:iTM2KeyBindingNode
{
@private
	NSMutableDictionary * value;
}
@end

@interface iTM2MutableKeyBindingNode:iTM2PrefsKeyBindingNode
{
@private
	iTM2PrefsKeyBindingNode * otherNode;
}
@end

@interface iTM2KeyBindingList:iTM2MutableKeyBindingNode
{
@private
	NSArray * selectionIndexPaths;
}
- (id)initWithParent:(id)parent;// reads all the macro files
- (NSArray *)keyBindingSelectionIndexPaths;
- (void)setKeyBindingSelectionIndexPaths:(NSArray *)indexPaths;
@end
