//
//  iTeXMac2-main.m
//  iTM2
//
//  @version Subversion: $Id: Test Application-main.m 800 2009-10-22 21:10:32Z jlaurens $ 
//
//  Created by Coder on 14/02/05.
//  Copyright Laurens'Tribune 2005. All rights reserved.
//

int main (int argc, const char * argv[]) {
    return NSApplicationMain(argc, (const char **) argv);
}

@interface iTM2ApplicationDelegate:NSObject
@end

#import "iTM2LaTeXSymbolsKit.h"

@implementation iTM2ApplicationDelegate
- (void)applicationCompleteDidFinishLaunching4iTM3:(NSNotification *)notification;
{
	NSMenu * M = [NSApp mainMenu];
	NSMenuItem * MI = [M itemWithTag:123];
	M = [MI submenu];
	MI = [[NSMenuItem alloc] initWithTitle:@"" action:NULL keyEquivalent:@""];
	[M addItem:MI];
	iTM2DSymbolView * V = [[iTM2DSymbolView alloc] initWithFrame:NSZeroRect];
	[V setupWithName:@"iTM2MathbbMenu" bundle:[NSBundle mainBundle]];
	[MI setView:V];
	[V release];
	[MI release];
}
@end