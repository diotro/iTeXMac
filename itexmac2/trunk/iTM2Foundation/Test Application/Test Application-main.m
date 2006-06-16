//
//  iTeXMac2-main.m
//  iTM2
//
//  @version Subversion: $Id$ 
//
//  Created by Coder on 14/02/05.
//  Copyright Laurens'Tribune 2005. All rights reserved.
//

int main(int argc, char *argv[])
{
    return NSApplicationMain(argc, (const char **) argv);
}
#import <iTM2Foundation/iTeXMac2.h>
#import <OgreKit/OgreKit.h>

@interface NSObject(OgreKit)
-(void)setShouldHackFindMenu:(BOOL)yorn;
-(void)setUseStylesInFindPanel:(BOOL)yorn;
-(NSMenu *)findMenu;
@end
@implementation NSApplication(OgreKit)
-(void)ogreKitWillHackFindMenu:(id)textFinder
{
	NSMenuItem * mi = [[self mainMenu] deepItemWithAction:@selector(OgreFindMenuItemAction:)];
	if(mi)
	{
		NSMenu * menu = [[[textFinder findMenu] copy] autorelease];
		[mi setAction:NULL];
		[[mi menu] setSubmenu:menu forItem:mi];
	}
	else
	{
		iTM2_LOG(@"No OgreKit panel installed because there is no menu item with action OgreFindMenuItemAction: in %@", [self mainMenu]);
	}
	[textFinder setShouldHackFindMenu:NO];
	return;
}
-(void)ogreKitShouldUseStylesInFindPanel:(id)textFinder
{
	[textFinder setUseStylesInFindPanel:NO];
}
-(void)OgreKit_DidFinishLaunching;
{
	if([[OgreTextFinder alloc] init])// beware of the bug
	{
		iTM2_LOG(@"OgreKit Properly installed");
	}
	else
	{
		iTM2_LOG(@"OgreKit not installed");
	}
	return;
}
@end

@implementation OgreTextFinder(OgreKit)
-(NSMenu *)findMenu;
{
	return findMenu;
}
@end
