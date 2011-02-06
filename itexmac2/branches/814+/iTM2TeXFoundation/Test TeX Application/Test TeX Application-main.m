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