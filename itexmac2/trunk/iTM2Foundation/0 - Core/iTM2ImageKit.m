/*
//
//  @version Subversion: $Id$ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Fri Dec 13 2002.
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

#import <iTM2Foundation/iTM2ImageKit.h>
#import <iTM2Foundation/iTM2Implementation.h>
#import <iTM2Foundation/iTM2BundleKit.h>

#define DEFINE_IMAGE(SELECTOR, NAME)\
+ (NSImage *)SELECTOR;\
{\
	static NSImage * I = nil;\
	if(!I)\
	{\
		I = [[NSImage allocWithZone:[self zone]] initWithContentsOfFile:\
            [[iTM2Implementation classBundle] pathForImageResource:NAME]];\
		[I setName:[NSString stringWithFormat:@"iTM2:%@", NAME]];\
	}\
    return I;\
}

@implementation NSImage(iTM2ButtonKit_RWStatus)
DEFINE_IMAGE(imageReadOnlyPencil, @"iTM2ReadOnlyPencil");
DEFINE_IMAGE(imageLock, @"iTM2Lock");
DEFINE_IMAGE(imageUnlock, @"iTM2Unlock");
DEFINE_IMAGE(imageJava, @"Java");
DEFINE_IMAGE(imageMissingImage, @"missing_image");
DEFINE_IMAGE(imageBlueDimple, @"dimple_nib_aqua");
DEFINE_IMAGE(imageGreyDimple, @"dimple_nib_grey_aqua");
DEFINE_IMAGE(imageRedDimple, @"status-away");
DEFINE_IMAGE(imageOrangeDimple, @"status-idle");
DEFINE_IMAGE(imageGreenDimple, @"status-available");
DEFINE_IMAGE(imageSplitClose, @"iTM2SplitClose");
DEFINE_IMAGE(imageSplitHorizontal, @"iTM2SplitHorizontal");
DEFINE_IMAGE(imageSplitVertical, @"iTM2SplitVertical");
@end
