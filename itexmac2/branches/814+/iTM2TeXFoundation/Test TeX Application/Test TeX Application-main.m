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
#import "GTMAppKitUnitTestingUtilities.h"
#import "GTMFoundationUnitTestingUtilities.h"

//  This is the main function from GTMUnitTestingTest
int main(int argc, char *argv[]) {
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

  [GTMAppKitUnitTestingUtilities setUpForUIUnitTestsIfBeingTested];

  // Give ourselves a max of 10 minutes for the tests.  Sometimes (in automated
  // builds) the unittesting bundle fails to load which causes the app to keep
  // running forever.  This will force it to exit after a certain amount of time
  // instead of hanging running forever.
  [GTMFoundationUnitTestingUtilities installTestingTimeout:10*60.0];

  int result = NSApplicationMain(argc,  (const char **) argv);
  [pool drain];
  return result;
}

static id text = nil;

#include "iTM2TeXFoundationTestCases.m"

@implementation iTM2Application(Test)

- (void)prepare000000000CompleteDidFinishLaunching4iTM3;
{
    invoke_iTM2TeXFoundation_testCases();
#if 0
    [[[iTM2Test_RE alloc] init]invokeTest];
    [[[iTM2Test0A alloc] init]invokeTest];
    [[[iTM2Test0B alloc] init]invokeTest];
    [[[iTM2Test0C alloc] init]invokeTest];
    [[[iTM2Test0D alloc] init]invokeTest];
    [[[iTM2Test1A alloc] init]invokeTest];
    [[[iTM2Test1B alloc] init]invokeTest];
    [[[iTM2Test1C alloc] init]invokeTest];
    [[[iTM2Test2 alloc] init]invokeTest];
    [[[iTM2Test3A alloc] init]invokeTest];
    [[[iTM2Test3B alloc] init]invokeTest];
    [[[iTM2Test3C alloc] init]invokeTest];
    [[[iTM2Test4 alloc] init]invokeTest];
    [[[iTM2Test5 alloc] init]invokeTest];
    [[[iTM2Test6 alloc] init]invokeTest];
    [[[iTM2Test7 alloc] init]invokeTest];
    [[[iTM2Test3B alloc] init] invokeTest];
#endif
}

- (BOOL)canEditText;
{
	return YES;
}
- (NSAttributedString *) text;
{
	if (!text)
	{
		text = [[NSMutableAttributedString alloc] initWithString:@"Binding test: this text view MUST be editable"];
	}
	return text;
}
- (void)setText:(NSAttributedString *) newText;
{
	if (!text)
	{
		text = [[NSMutableAttributedString alloc] initWithString:@"Binding test: this text view MUST be editable"];
	}
	[text beginEditing];
	[text setString:(newText?[newText string]:@"")];
	[text endEditing];
	return;
}

@end