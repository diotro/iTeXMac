//
//  iTeXMac2-main.m
//  iTM2
//
//  @version Subversion: $Id: Test Application-main.m 794 2009-10-04 12:33:28Z jlaurens $ 
//
//  Created by Coder on 14/02/05.
//  Copyright Laurens'Tribune 2005. All rights reserved.
//

int main (int argc, const char * argv[]) {
    return NSApplicationMain(argc, (const char **) argv);
}

#if 1

static id text = nil;
@implementation iTM2Application(Test)
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
#endif