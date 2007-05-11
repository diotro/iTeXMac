/*
//  iTM2TextScriptingKit.h
//  iTeXMac2
//
//  Created by jlaurens@users.sourceforge.net on Thu Jun 06 2002.
//  Copyright (c) 2001 Laurens'Tribune. All rights reserved.
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

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  iTM2FindScriptCommand

@interface iTM2FindScriptCommand : NSScriptCommand
{
@private
    NSValue * findRangeValue;
    id findTarget;
    id findString;
}
/*"Class methods"*/
/*"Setters and Getters"*/
- (BOOL) backwardsFlag;
- (BOOL) caseInsensitiveFlag;
- (BOOL) cycleFlag;
- (id) findRangeValue;
- (id) findTarget;
- (id) findString;
/*"Main methods"*/
/*"Overriden methods"*/
- (void) dealloc;
- (id) performDefaultImplementation;
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  iTM2InsertScriptCommand

@interface iTM2InsertScriptCommand : NSScriptCommand
{
@private
    NSValue * insertionRangeValue;
    id insertionTarget;
}
/*"Class methods"*/
/*"Setters and Getters"*/
- (id) insertionRangeValue;
- (id) insertionTarget;
- (id) insertionString;
/*"Main methods"*/
/*"Overriden methods"*/
- (id) performDefaultImplementation;
- (void) dealloc;
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  iTM2InsertMacroScriptCommand

@interface iTM2InsertMacroScriptCommand: iTM2InsertScriptCommand
/*"Class methods"*/
/*"Setters and Getters"*/
- (id) insertionSelected;
- (id) insertionAfter;
/*"Main methods"*/
/*"Overriden methods"*/
- (id) performDefaultImplementation;
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  iTM2ReplaceScriptCommand

@interface iTM2ReplaceScriptCommand : NSScriptCommand
{
@private
    NSValue * findRangeValue;
    id findTarget;
    id findString;
    id replaceString;
}
/*"Class methods"*/
/*"Setters and Getters"*/
- (BOOL) backwardsFlag;
- (BOOL) caseInsensitiveFlag;
- (BOOL) cycleFlag;
- (BOOL) changeAllFlag;
- (BOOL) entireFileFlag;
- (id) findRangeValue;
- (id) findTarget;
- (id) findString;
- (id) replaceString;
/*"Main methods"*/
/*"Overriden methods"*/
- (void) dealloc;
- (id) performDefaultImplementation;
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  iTM2SelectScriptCommand

@interface iTM2SelectScriptCommand : NSScriptCommand
/*"Class methods"*/
/*"Setters and Getters"*/
/*"Main methods"*/
/*"Overriden methods"*/
- (id) performDefaultImplementation;
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  iTM2TextScriptingKit
