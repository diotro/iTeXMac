/*
//
//  @version Subversion: $Id: iTM2ImageKit.h 750 2008-09-17 13:48:05Z jlaurens $ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Tue May 10 11:15:35 GMT 2005.
//  Copyright © 2001-2005 Laurens'Tribune. All rights reserved.
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


@interface NSImage(iTeXMac2)
+ (NSImage *)iTM2_imageReadOnlyPencil;
+ (NSImage *)iTM2_imageLock;
+ (NSImage *)iTM2_imageUnlock;
+ (NSImage *)iTM2_imageJava;
+ (NSImage *)iTM2_imageBlueDimple;
+ (NSImage *)iTM2_imageGreyDimple;
+ (NSImage *)iTM2_imageRedDimple;
+ (NSImage *)iTM2_imageOrangeDimple;
+ (NSImage *)iTM2_imageGreenDimple;
+ (NSImage *)iTM2_imageSplitClose;
+ (NSImage *)iTM2_imageSplitHorizontal;
+ (NSImage *)iTM2_imageSplitVertical;
+ (NSImage *)iTM2_imageMissingImage;
+ (NSImage *)iTM2_imageNERedArrow;
+ (NSImage *)iTM2_cachedImageNamed:(NSString *)name;
- (void)iTM2_setSizeSmallIcon;
- (void)iTM2_setSizeIcon;
- (BOOL)iTM2_isNotNullImage;
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2ImageKit
