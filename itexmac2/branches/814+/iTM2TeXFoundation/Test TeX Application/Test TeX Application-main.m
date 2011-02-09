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

#import "../../build/EmbeddedTestCases/iTM2TeXFoundationTestCases.m"

@interface SenTestCase(MORE)
@end

static id text = nil;

@implementation iTM2Application(Test)

- (void)prepare000000000StringControllerCompleteDidFinishLaunching4iTM3;
{
    invoke_iTM2TeXFoundation_testCases();
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