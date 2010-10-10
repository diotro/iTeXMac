/*
//  iTM2FilePathFilter.m
//  list menu controller tutorial
//
//  Created by jlaurens@users.sourceforge.net on Mon Jun 18 2001.
//  Copyright © 2001-2002 Laurens'Tribune. All rights reserved.
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

#import <iTM2Foundation/iTM2FilePathFilter.h>


//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2FilePathFilter
/*"Description forthcoming."*/
@implementation iTM2FilePathFilter
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= listMenuArrayAtPath:
+ (NSArray *) listMenuArrayAtPath: (NSString *) aPath;
/*"Description forthcoming.
Version History: jlaurens@users.sourceforge.net
- < 1.1: 03/10/2002
To Do List:
"*/
{
    NSMutableArray * result = [NSMutableArray arrayWithCapacity: 1];
    NSEnumerator * enumerator = [[NSArray arrayWithContentsOfFile:
        [[[aPath stringByAppendingPathComponent: @"(List Menu)"] stringByAppendingPathExtension: @"plist"]
                        stringByStandardizingPath]] objectEnumerator];
    NSString * path;

    while(path = enumerator.nextObject)
        if(([result indexOfObject: path] == NSNotFound) || (path.length==0))
            [result addObject: path];
        else
            NSLog(@"-[iTM2FilePathFilter listMenuArrayAtPath:] refused path: %@", path);

    if(result.count>0)
        return result;
    else
        return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= filterAtPath:
+ (id) filterAtPath: (NSString *) aPath;
/*"Description forthcoming."*/
{
    return [[self.alloc initAtPath: aPath] autorelease];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= openFilter
+ (id) openFilter;
/*"Description forthcoming."*/
{
    id result = [[self.alloc initAtPath: nil] autorelease];
    [result setOpen: YES];
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= saveFilter
+ (id) saveFilter;
/*"Description forthcoming."*/
{
    id result = [[self.alloc initAtPath: nil] autorelease];
    [result setOpen: NO];
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= initAtPath:
- (id) initAtPath: (NSString *) aPath;
/*"Description forthcoming."*/
{
    self = [super init];
    [self setHiddenFileNames: [NSArray arrayWithContentsOfFile:
            [[aPath stringByAppendingPathComponent:
                    [@"(Hidden Files)" stringByAppendingPathExtension: @"plist"]] stringByStandardizingPath]]];
    return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= isOpen
- (BOOL) isOpen;
/*"Description forthcoming.
Version History: jlaurens@users.sourceforge.net
- < 1.1: 03/10/2002
To Do List:
"*/
{
    return _iTM2FPFFlags.isOpen;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= setOpen:
- (void) setOpen: (BOOL) aFlag;
/*"Description forthcoming."*/
{
    _iTM2FPFFlags.isOpen = aFlag? 1: 0;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= hiddenFileNames
- (NSArray *) hiddenFileNames;
/*"Description forthcoming."*/
{
    return _HiddenFileNames;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= setHiddenFileNames:
- (void) setHiddenFileNames: (NSArray *) hiddenFileNames;
/*"Description forthcoming."*/
{
    if(![_HiddenFileNames isEqual: hiddenFileNames])
    {
        [_HiddenFileNames autorelease];
        if (hiddenFileNames.count > 0)
            _HiddenFileNames = [hiddenFileNames retain];
        else
            _HiddenFileNames = nil;
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= isHiddenFileName:
- (BOOL) isHiddenFileName: (NSString *) aLastPathComponent;
/*"Description forthcoming."*/
{
    return ((self.hiddenFileNames.count>0) &&
                    ([self.hiddenFileNames indexOfObject: aLastPathComponent] != NSNotFound));
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= isDotFileName:
- (BOOL) isDotFileName: (NSString *) aLastPathComponent;
/*"Description forthcoming."*/
{
    return ([aLastPathComponent hasPrefix: @"."]);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= isOpenParenFileName:
- (BOOL) isOpenParenFileName: (NSString *) aLastPathComponent;
/*"Description forthcoming."*/
{
    return ([aLastPathComponent hasPrefix: @"("]);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= isValidFileName:
- (BOOL) isValidFileName: (NSString *) aLastPathComponent;
/*"Description forthcoming."*/
{
    return (![self isDotFileName: aLastPathComponent] &&
                ![self isOpenParenFileName: aLastPathComponent] &&
                    ![self isHiddenFileName: aLastPathComponent]);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= PANEL DELEGATING  =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= panel:shouldShowFilename:
- (BOOL) panel: (id) aPanel shouldShowFilename: (NSString *) filename;
{
    BOOL result = self.isOpen?
            [DFM isReadableFileAtPath: filename]:
            [DFM isWritableFileAtPath: filename];
    NSLog(@"-[iTM2FilePathFilter panel:shouldShowFilename:] %@, %d", filename, result);
    return NO && result;
}
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2FilePathFilter

