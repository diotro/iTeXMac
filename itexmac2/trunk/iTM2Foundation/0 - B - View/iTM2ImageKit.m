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
- (void)iTM2_setSizeSmallIcon;
- (void)iTM2_setSizeIcon;
@end

@interface iTM2NullImage: NSImage
@end
@implementation iTM2NullImage
- (id)copy;
{
	if(self = [super copy])
	{
		isa = [iTM2NullImage class];
	}
	return self;
}
@end

#import "iTM2InstallationKit.h"
#import "iTM2Runtime.h"

@implementation iTM2MainInstaller(iTM2ImageKit)
+ (void)iTM2ImageKitCompleteInstallation;
{
	NSAssert([NSImage iTM2_swizzleClassMethodSelector:@selector(SWZ_iTM2_imageNamed:)],@"**** Huge bug, please report");
}
@end

@implementation NSImage(iTeXMac2)
+ (id)SWZ_iTM2_imageNamed:(NSString *)name;
{
	NSImage * result = [self SWZ_iTM2_imageNamed:name];
	if(!result && [name length] && ![name hasPrefix:@"NS"])
	{
		NSString * path = [[[[NSBundle mainBundle] allPathsForImageResource:name] objectEnumerator] nextObject];
		if([path length])
		{
			result = [[[NSImage alloc] initWithContentsOfFile:path] autorelease];
			[result setName:name];
		}
	}
	return result;
}
+ (NSImage *)iTM2_cachedImageNamed:(NSString *)name;
{
	NSImage * result = [self SWZ_iTM2_imageNamed:name];// we assume that swizzling was successful
	if(result)
	{
		return result;
	}
	else if(result = [self  imageNamed:name])
	{
		return result;
	}
	else
	{
		result = [[NSImage iTM2_imageMissingImage] copy];
		[result iTM2_setSizeSmallIcon];
		[result setName:name];
	}
	return result;
}
+(NSImage *)iTM2_imageMissingImage;
{
	NSString * name = @"QuestionMark";
	NSImage * result = [self SWZ_iTM2_imageNamed:name];// we assume that swizzling was successful
	if(!result)
	{
		NSString * path = [[[[NSBundle mainBundle] allPathsForImageResource:name] objectEnumerator] nextObject];
		if([path length])
		{
			result = [[[iTM2NullImage alloc] initWithContentsOfFile:path] autorelease];
			[result setName:name];
		}
	}
	return result;
}
- (BOOL)iTM2_isNotNullImage;
{
	return ![self isKindOfClass:[iTM2NullImage class]];
}
#define DEFINE_IMAGE(SELECTOR, NAME)\
+ (NSImage *)SELECTOR;\
{\
	return [NSImage iTM2_cachedImageNamed:NAME];\
}
DEFINE_IMAGE(iTM2_imageReadOnlyPencil, @"iTM2ReadOnlyPencil");
DEFINE_IMAGE(iTM2_imageLock, @"iTM2Lock");
DEFINE_IMAGE(iTM2_imageUnlock, @"iTM2Unlock");
DEFINE_IMAGE(iTM2_imageJava, @"Java");
DEFINE_IMAGE(iTM2_imageBlueDimple, @"dimple_nib_aqua");
DEFINE_IMAGE(iTM2_imageGreyDimple, @"dimple_nib_grey_aqua");
DEFINE_IMAGE(iTM2_imageRedDimple, @"status-away");
DEFINE_IMAGE(iTM2_imageOrangeDimple, @"status-idle");
DEFINE_IMAGE(iTM2_imageGreenDimple, @"status-available");
DEFINE_IMAGE(iTM2_imageSplitClose, @"iTM2SplitClose");
DEFINE_IMAGE(iTM2_imageSplitHorizontal, @"iTM2SplitHorizontal");
DEFINE_IMAGE(iTM2_imageSplitVertical, @"iTM2SplitVertical");
DEFINE_IMAGE(iTM2_imageToggleDrawer, @"toggleDrawerToolbarImage");
DEFINE_IMAGE(iTM2_imageLockDocument, @"imageLockDocumentToolbarImage");
DEFINE_IMAGE(iTM2_imageOrderFrontColorPanel, @"imageOrderFrontColorPanelToolbarImage");
DEFINE_IMAGE(iTM2_imageOrderFrontFontPanel, @"imageOrderFrontFontPanelToolbarImage");
DEFINE_IMAGE(iTM2_imageSubscript, @"imageSubscriptToolbarImage");
DEFINE_IMAGE(iTM2_imageSuperscript, @"imageSuperscriptToolbarImage");
DEFINE_IMAGE(iTM2_imageUnlockDocument, @"imageUnlockDocumentToolbarImage");
DEFINE_IMAGE(iTM2_imageNERedArrow, @"NERedArrow-16");
- (void)iTM2_setSizeSmallIcon;
{
	[self setScalesWhenResized:YES];
	[self setSize:NSMakeSize(16,16)];
	return;
}
- (void)iTM2_setSizeIcon;
{
	[self setScalesWhenResized:YES];
	[self setSize:NSMakeSize(32,32)];
	return;
}
@end

