/*
//
//  @version Subversion: $Id: iTM2ImageKit.m 795 2009-10-11 15:29:16Z jlaurens $ 
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

#import "iTM2ImageKit.h"
#import "iTM2Implementation.h"
#import "iTM2BundleKit.h"

@interface NSImage(PRIVATE)
- (void)setSizeSmallIcon4iTM3;
- (void)setSizeIcon4iTM3;
@end

@interface iTM2NullImage: NSImage
@end
@implementation iTM2NullImage
- (id)copy;
{
	if ((self = [super copy]))
	{
		isa = [iTM2NullImage class];
	}
	return self;
}
@end

#import "iTM2InstallationKit.h"
#import "iTM2Runtime.h"

@implementation iTM2MainInstaller(iTM2ImageKit)
+ (void)iTM2ImageKitCompleteInstallation4iTM3;
{
	NSAssert([NSImage swizzleClassMethodSelector4iTM3:@selector(SWZ_iTM2_imageNamed:) error:NULL],@"**** Huge bug, please report");
}
@end

@implementation NSImage(iTeXMac2)
+ (id)SWZ_iTM2_imageNamed:(NSString *)name;
{
	NSImage * result = [self SWZ_iTM2_imageNamed:name];
	if (!result && name.length && ![name hasPrefix:@"NS"])
	{
		NSURL * url = [[[[NSBundle mainBundle] allURLsForImageResource4iTM3:name] objectEnumerator] nextObject];
		if (url.isFileURL)
		{
			result = [[[NSImage alloc] initWithContentsOfURL:url] autorelease];
			[result setName:name];
		}
	}
	return result;
}
+ (NSImage *)cachedImageNamed4iTM3:(NSString *)name;
{
	NSImage * result = [self SWZ_iTM2_imageNamed:name];// we assume that swizzling was successful
	if (result)
	{
		return result;
	}
	else if ((result = [self  imageNamed:name]))
	{
		return result;
	}
	else
	{
		result = [[NSImage imageMissingImage4iTM3] copy];
		[result setSizeSmallIcon4iTM3];
		[result setName:name];
	}
	return result;
}
+(NSImage *)imageMissingImage4iTM3;
{
	NSString * name = @"QuestionMark";
	NSImage * result = [self SWZ_iTM2_imageNamed:name];// we assume that swizzling was successful
	if (!result)
	{
		NSURL * url = [[[[NSBundle mainBundle] allURLsForImageResource4iTM3:name] objectEnumerator] nextObject];
		if (url.isFileURL) {
			result = [[[iTM2NullImage alloc] initWithContentsOfURL:url] autorelease];
			[result setName:name];
		}
	}
	return result;
}
- (BOOL)isNotNullImage4iTM3;
{
	return ![self isKindOfClass:[iTM2NullImage class]];
}
#define DEFINE_IMAGE(SELECTOR, NAME)\
+ (NSImage *)SELECTOR;\
{\
	return [NSImage cachedImageNamed4iTM3:NAME];\
}
DEFINE_IMAGE(imageReadOnlyPencil4iTM3, @"iTM2ReadOnlyPencil");
DEFINE_IMAGE(imageLock4iTM3, @"iTM2Lock");
DEFINE_IMAGE(imageUnlock4iTM3, @"iTM2Unlock");
DEFINE_IMAGE(imageJava4iTM3, @"Java");
DEFINE_IMAGE(imageBlueDimple4iTM3, @"dimple_nib_aqua");
DEFINE_IMAGE(imageGreyDimple4iTM3, @"dimple_nib_grey_aqua");
DEFINE_IMAGE(imageRedDimple4iTM3, @"status-away");
DEFINE_IMAGE(imageOrangeDimple4iTM3, @"status-idle");
DEFINE_IMAGE(imageGreenDimple4iTM3, @"status-available");
DEFINE_IMAGE(imageSplitClose4iTM3, @"iTM2SplitClose");
DEFINE_IMAGE(imageSplitHorizontal4iTM3, @"iTM2SplitHorizontal");
DEFINE_IMAGE(imageSplitVertical4iTM3, @"iTM2SplitVertical");
DEFINE_IMAGE(imageToggleDrawer4iTM3, @"toggleDrawerToolbarImage");
DEFINE_IMAGE(imageLockDocument4iTM3, @"imageLockDocumentToolbarImage");
DEFINE_IMAGE(imageOrderFrontColorPanel4iTM3, @"imageOrderFrontColorPanelToolbarImage");
DEFINE_IMAGE(imageOrderFrontFontPanel4iTM3, @"imageOrderFrontFontPanelToolbarImage");
DEFINE_IMAGE(imageSubscript4iTM3, @"imageSubscriptToolbarImage");
DEFINE_IMAGE(imageSuperscript4iTM3, @"imageSuperscriptToolbarImage");
DEFINE_IMAGE(imageUnlockDocument4iTM3, @"imageUnlockDocumentToolbarImage");
DEFINE_IMAGE(imageNERedArrow4iTM3, @"NERedArrow-16");
- (void)setSizeSmallIcon4iTM3;
{
	[self setScalesWhenResized:YES];
	[self setSize:NSMakeSize(16,16)];
	return;
}
- (void)setSizeIcon4iTM3;
{
	[self setScalesWhenResized:YES];
	[self setSize:NSMakeSize(32,32)];
	return;
}
@end

