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
		iTM2_LOG(@"No OgreKit panel installed because there is no menu item with action OgreFindMenuItemAction: in %@", [self mainMenu]);
	}
	[textFinder setShouldHackFindMenu:NO];
	return;
}
- (void)ogreKitShouldUseStylesInFindPanel:(id)textFinder
{
	[textFinder setUseStylesInFindPanel:NO];
}
- (void)OgreKit_DidFinishLaunching;
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
- (NSMenu *)findMenu;
{
	return findMenu;
}
@end

#import <iTM2Foundation/iTM2TextDocumentKit.h>

@implementation iTM2TextEditor(Test)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  contextDictionary
- (id)contextDictionary;
/*"Subclasses will most certainly override this method.
Default implementation returns the NSUserDefaults shared instance.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id result = [self valueForKeyPath:@"implementation.metaValues.contextDictionary"];
	if(result)
	{
		return result;
	}
	result = [NSMutableDictionary dictionary];
	[self setValue:result forKeyPath:@"implementation.metaValues.contextDictionary"];
//iTM2_END;
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= handlesKeyBindings
- (BOOL)handlesKeyBindings;
/*"YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Dec 15 14:34:51 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return YES;
}
@end

#import <iTM2Foundation/iTM2PreferencesKit.h>

static id text = nil;
@implementation iTM2Application(Test)
- (void)prefsControllerDidFinishLaunching;
{
	[[iTM2PrefsController sharedPrefsController] displayPrefsPaneWithIdentifier:@"3.Macro"];
}
- (BOOL)canEditText;
{
	return YES;
}
- (NSAttributedString *) text;
{
	if(!text)
	{
		text = [[NSMutableAttributedString alloc] initWithString:@"Binding test: this text view MUST be editable"];
	}
	return text;
}
- (void)setText:(NSAttributedString *) newText;
{
	if(!text)
	{
		text = [[NSMutableAttributedString alloc] initWithString:@"Binding test: this text view MUST be editable"];
	}
	[text beginEditing];
	[text setString:(newText?[newText string]:@"")];
	[text endEditing];
	return;
}
@end