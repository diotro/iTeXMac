//
//  iTeXMac2-main.m
//  iTM2
//
//  @version Subversion: $Id$ 
//
//  Created by Coder on 14/02/05.
//  Copyright Laurens'Tribune 2005. All rights reserved.
//

#import <Cocoa/Cocoa.h>
int main(int argc, char *argv[])
{
NSLog(@"START now:%@",[NSDate date]);
    return NSApplicationMain(argc, (const char **) argv);
}
#import <iTM2Foundation/iTeXMac2.h>
#import <OgreKit/OgreKit.h>

@interface NSObject(OgreKit)
- (void)setShouldHackFindMenu:(BOOL)yorn;
- (void)setUseStylesInFindPanel:(BOOL)yorn;
- (NSMenu *)findMenu;
@end
@implementation NSApplication(OgreKit)
- (void)ogreKitWillHackFindMenu:(id)textFinder
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
		LOG4iTM3(@"No OgreKit panel installed because there is no menu item with action OgreFindMenuItemAction: in %@", [self mainMenu]);
	}
	[textFinder setShouldHackFindMenu:NO];
	return;
}
- (void)ogreKitShouldUseStylesInFindPanel:(id)textFinder
{
	[textFinder setUseStylesInFindPanel:NO];
}
- (void)OgreKit_CompleteDidFinishLaunching4iTM3;
{
	if([[OgreTextFinder alloc] init])// beware of the bug
	{
		LOG4iTM3(@"OgreKit Properly installed");
	}
	else
	{
		LOG4iTM3(@"OgreKit not installed");
	}
LOG4iTM3(@"now:%@",[NSDate date]);
	return;
}
@end

@implementation OgreTextFinder(OgreKit)
- (NSMenu *)findMenu;
{
	return findMenu;
}
@end
