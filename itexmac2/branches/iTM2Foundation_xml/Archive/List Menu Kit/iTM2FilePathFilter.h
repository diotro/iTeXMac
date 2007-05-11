/*
//  iTM2FilePathFilter.h
//  list menu controller tutorial
//
//  Created by jlaurens@users.sourceforge.net on Mon Jun 18 2001.
//  Copyright © 2001-2004 Laurens'Tribune. All rights reserved.
//
//  This program is free software; you can redistribute it and/or modify it under the terms
//  of the GNU General Public License as published by the Free Software Foundation; either
//  version 2 of the License, or any later version.
//  This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
//  without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
//  See the GNU General Public License for more details. You should have received a copy
//  of the GNU General Public License along with this program; if not, write to the Free Software
//  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
//  GPL addendum: Any simple modification of the present code which purpose is to remove bug,
//  improve efficiency in both code execution and code reading or writing should be addressed
//  to the actual developper team.
*/


//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2FilePathFilter

@interface iTM2FilePathFilter : NSObject
{
@private
    NSArray * _HiddenFileNames;
    NSString * _HiddenName;
    struct __iTM2FPFFlags
    {
        unsigned int isOpen: 1;
        unsigned int RESERVED: 31;
    } _iTM2FPFFlags;
}
/*"Class methods"*/
+ (NSArray *) listMenuArrayAtPath: (NSString *) aPath;
+ (id) filterAtPath: (NSString *) aPath;
+ (id) openFilter;
+ (id) saveFilter;
/*"Setters and Getters"*/
- (NSArray *) hiddenFileNames;
- (void) setHiddenFileNames: (NSArray *) aHiddenFileNames;
- (BOOL) isOpen;
- (void) setOpen: (BOOL) aFlag;
/*"Main methods"*/
- (BOOL) isHiddenFileName: (NSString *) aLastPathComponent;
- (BOOL) isDotFileName: (NSString *) aLastPathComponent;
- (BOOL) isOpenParenFileName: (NSString *) aLastPathComponent;
- (BOOL) isValidFileName: (NSString *) aLastPathComponent;
- (id) initAtPath: (NSString *) aPath;
- (BOOL) panel: (id) aPanel shouldShowFilename: (NSString *) filename;
/*"Overriden methods"*/
- (void) dealloc;
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2FilePathFilter
