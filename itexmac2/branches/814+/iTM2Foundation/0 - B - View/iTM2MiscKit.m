/*
//
//  @version Subversion: $Id: iTM2MiscKit.m 798 2009-10-12 19:32:06Z jlaurens $ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Mon May 17 13:54:52 GMT 2004.
//  Copyright © 2005 Laurens'Tribune. All rights reserved.
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

#import "iTM2MiscKit.h"
#import "ICURegEx.h"
#import "iTM2Runtime.h"
#import "iTM2ResponderKit.h"
#import "iTM2BundleKit.h"
#import "iTM2InstallationKit.h"
#import "iTM2Implementation.h"
#import "iTM2ImageKit.h"

extern NSInteger iTM2DebugEnabled;

@implementation iTM2SharedResponder(MiscKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  checkForUpdate:
- (IBAction)checkForUpdate:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Jan 11 11:42:37 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSString * helper = [[[[NSBundle mainBundle] sharedSupportPath] stringByAppendingPathComponent:@"iTeXMac2(Updater)"] stringByAppendingPathExtension:@"app"];
    if (![DFM fileExistsAtPath:helper])
        NSRunAlertPanel(
                NSLocalizedStringFromTableInBundle(@"iTeXMac2 Installation Problem", @"General", self.classBundle4iTM3, "Panel Title"),
                NSLocalizedStringFromTableInBundle(@"No Updater Available.", @"General", self.classBundle4iTM3, ""),
                NSLocalizedStringFromTableInBundle(@"OK", @"General", self.classBundle4iTM3, "OK"),
                nil, nil);
    else
        [SWS launchApplication:helper];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= displayConsoleDebug:
- (void)displayConsoleDebug:(id)sender;
/*"This is the build number.
Version History: jlaurens AT users DOT sourceforge DOT net (today)
- 2.0:
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSString * logPath = [NSBundle NSLogOutputPath4iTM3];
	[SWS openFile:logPath withApplication:@"Console"];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= validateDisplayConsoleDebug:
- (BOOL)validateDisplayConsoleDebug:(NSMenuItem *)sender;
/*"This is the build number.
Version History: jlaurens AT users DOT sourceforge DOT net (today)
- 2.0:
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (!sender.image)
	{
		NSString * path = [SWS fullPathForApplication:@"Console"];
		NSImage * I = [SWS iconForFile:path];
		[I setSizeSmallIcon4iTM3];
		sender.image = I;//size
	}
//END4iTM3;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= takeDebugModeFromSenderTag:
- (void)takeDebugModeFromSenderTag:(NSMenuItem *)sender;
/*"This is the build number.
Version History: jlaurens AT users DOT sourceforge DOT net (today)
- 2.0:
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	switch(sender.tag) {
		case 0: iTM2DebugEnabled = ZER0; break;
		case 1: iTM2DebugEnabled = 1; break;
		case 2: iTM2DebugEnabled = 100; break;
		case 3: iTM2DebugEnabled = 10000; break;
	}
	if (iTM2DebugEnabled)
	{
		[SUD registerDefaults:[NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:1] forKey:@"NSScriptingDebugLogLevel"]];
	}
	else
	{
		[SUD registerDefaults:[NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:ZER0] forKey:@"NSScriptingDebugLogLevel"]];
	}
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= validateTakeDebugModeFromSenderTag:
- (BOOL)validateTakeDebugModeFromSenderTag:(NSMenuItem *)sender;
/*"This is the build number.
Version History: jlaurens AT users DOT sourceforge DOT net (today)
- 2.0:
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSUInteger tag;
	if (iTM2DebugEnabled<1)
	{
		tag = ZER0;// Off
	}
	else if (iTM2DebugEnabled<100)
	{
		tag = 1;// Simple
	}
	else if (iTM2DebugEnabled<10000)
	{
		tag = 2;// Advanced
	}
	else
	{
		tag = 3;// Expert
	}
	sender.state = (sender.tag==tag?NSOnState:NSOffState);
//END4iTM3;
    return YES;
}
@end

#import "iTM2CursorKit.h"
#import <objc/objc-runtime.h>
#import <objc/objc-class.h>

@implementation NSTextView(iTM2MiscKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= SWZ_iTM2Misc_resetCursorRects:
- (void)SWZ_iTM2Misc_resetCursorRects;
/*"Extracted from apple sample code (TextLinks).
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 06/19/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSAttributedString* attrString = self.textStorage;
    //	Figure what part of us is visible (we're typically inside a scrollview)
    NSPoint containerOrigin = self.textContainerOrigin;
    //	Figure the range of characters which is visible
    NSRect visRect = NSOffsetRect (self.visibleRect, -containerOrigin.x, -containerOrigin.y);
    NSRange visibleGlyphRange = [self.layoutManager glyphRangeForBoundingRect:visRect inTextContainer:self.textContainer];
    NSRange visibleCharRange = [self.layoutManager characterRangeForGlyphRange:visibleGlyphRange actualGlyphRange:nil];
    //	Prime for the loop
    NSRange attrsRange = iTM3MakeRange (visibleCharRange.location, ZER0);
    //	Loop until we reach the end of the visible range of characters
    while (iTM3MaxRange(attrsRange) < iTM3MaxRange(visibleCharRange)) // find all visible URLs and set up cursor rects
    {
        //	Find the next link inside the range
        if ([attrString attribute:NSLinkAttributeName atIndex:iTM3MaxRange(attrsRange) effectiveRange:&attrsRange] != nil)
        {
            NSUInteger rectCount, rectIndex;
            //	Find the rectangles where this range falls. (We could use -boundingRectForGlyphRange:...,
            //	but that gives a single rectangle, which might be overly large when a link runs
            //	through more than one line.)
            NSRectArray rects = [self.layoutManager rectArrayForCharacterRange:attrsRange
                withinSelectedCharacterRange: iTM3MakeRange (NSNotFound, ZER0)
                inTextContainer: self.textContainer
                rectCount: &rectCount];

            //	For each rectangle, find its visible portion and ask for the cursor to appear
            //	when they're over that rectangle.
            for (rectIndex = ZER0; rectIndex < rectCount; ++rectIndex)
            {
                [self addCursorRect:NSIntersectionRect (rects[rectIndex], self.visibleRect) cursor:[NSCursor pointingHandCursor]];
            }
        }
    }
    return;
}
@end

@interface NSObject(iTM2FontManager)
-(void)italic4iTM3:sender;
-(void)bold4iTM3:sender;
-(void)unitalic4iTM3:sender;
-(void)unbold4iTM3:sender;
-(void)smallCaps4iTM3:sender;
@end

NSString * const iTM2FontPanelWillOrderFrontNotification = @"iTM2FontPanelWillOrderFront";

#import "iTM2NotificationKit.h"

@interface NSFontManager_iTeXMac2: NSFontManager
@end


@implementation iTM2MainInstaller(NSFontManager)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  fontManagerCompleteInstallation4iTM3
+ (void)fontManagerCompleteInstallation4iTM3;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if ([SUD boolForKey:@"iTM2DontPoseAsFontManager"])
    {
        LOG4iTM3(@"No NSFontManager extension available:");
        NSLog(@"terminal%% defaults remove comp.text.TeX.iTeXMac2 iTM2DontPoseAsFontManager");
    }
    else
    {
		[NSFontManager swizzleInstanceMethodSelector4iTM3:@selector(SWZ_iTM2Misc_orderFrontFontPanel:) error:NULL];
		[NSFontManager swizzleInstanceMethodSelector4iTM3:@selector(SWZ_iTM2Misc_addFontTrait:) error:NULL];
	}
//END4iTM3;
    return;
}
@end

@implementation NSFontManager(iTM2MiscKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  SWZ_iTM2Misc_orderFrontFontPanel:
- (void)SWZ_iTM2Misc_orderFrontFontPanel:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[INC postNotificationName:iTM2FontPanelWillOrderFrontNotification object:nil];
	[self SWZ_iTM2Misc_orderFrontFontPanel:sender];
//END4iTM3;
    return;
}
- (void)SWZ_iTM2Misc_addFontTrait:(NSMenuItem *)sender;
{
	if ([sender respondsToSelector:@selector(tag)]) {
		NSInteger tag = sender.tag;
		id FR = [[NSApp mainWindow] firstResponder];
		BOOL done = NO;
		if (((NSItalicFontMask & tag) > ZER0) && [FR respondsToSelector:@selector(italic4iTM3:)])
		{
			[FR italic4iTM3:sender];
			done = YES;
		}
		if (((NSBoldFontMask & tag) > ZER0) && [FR respondsToSelector:@selector(bold4iTM3:)])
		{
			[FR bold4iTM3:sender];
			done = YES;
		}
		if (((NSUnitalicFontMask & tag) > ZER0) && [FR respondsToSelector:@selector(unitalic4iTM3:)])
		{
			[FR unitalic4iTM3:sender];
			done = YES;
		}
		if (((NSUnboldFontMask & tag) > ZER0) && [FR respondsToSelector:@selector(unbold4iTM3:)])
		{
			[FR unbold4iTM3:sender];
			done = YES;
		}
		if (((NSSmallCapsFontMask & tag) > ZER0) && [FR respondsToSelector:@selector(smallCaps4iTM3:)])
		{
			[FR smallCaps4iTM3:sender];
			done = YES;
		}
		if (done)
		{
			return;
		}
	}
	[self SWZ_iTM2Misc_addFontTrait:(id)sender];
	return;
}
@end

@implementation NSSavePanel(iTM2MiscKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  pushNavLastRootDirectory4iTM3
- (void)pushNavLastRootDirectory4iTM3;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	id old = [SUD stringForKey:@"NSNavLastRootDirectory"];
	if (old) {
		[SUD setObject:old forKey:@"NSNavLastRootDirectory_Saved"];
		[SUD removeObjectForKey:@"NSNavLastRootDirectory"];
	}
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  popNavLastRootDirectory4iTM3
- (void)popNavLastRootDirectory4iTM3;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	id old = [SUD stringForKey:@"NSNavLastRootDirectory_Saved"];
	if (old) {
		[SUD setObject:old forKey:@"NSNavLastRootDirectory"];
    }
//END4iTM3;
    return;
}
@end

NSString * const iTM2PrintInfoDidChangeNotification = @"iTM2PrintInfoDidChange";

@implementation NSPageLayout(iTM2MiscKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  SWZ_iTM2Misc_writePrintInfo
- (void)SWZ_iTM2Misc_writePrintInfo;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSDictionary * oldDictionary = self.printInfo.dictionary.copy;
	[self SWZ_iTM2Misc_writePrintInfo];
	[INC postNotificationName:iTM2PrintInfoDidChangeNotification object:self.printInfo userInfo:oldDictionary];
//END4iTM3;
    return;
}
@end
@implementation NSPrintInfo(iTM2MiscKit)
- (void)SWZ_iTM2Misc_setPaperName:(NSString *)name;
{
	NSDictionary * oldDictionary = [[self.dictionary copy] autorelease];
	[self SWZ_iTM2Misc_setPaperName:(NSString *)name];
	[INC postNotificationName:iTM2PrintInfoDidChangeNotification object:self userInfo:oldDictionary];
}
- (void)SWZ_iTM2Misc_setPaperSize:(NSSize)size;
{
	NSDictionary * oldDictionary = [[self.dictionary copy] autorelease];
	[self SWZ_iTM2Misc_setPaperSize:(NSSize)size];
	[INC postNotificationName:iTM2PrintInfoDidChangeNotification object:self userInfo:oldDictionary];
}
- (void) SWZ_iTM2Misc_setOrientation:(NSPrintingOrientation)orientation;
{
	NSDictionary * oldDictionary = [[self.dictionary copy] autorelease];
	[self SWZ_iTM2Misc_setOrientation:(NSPrintingOrientation)orientation];
	[INC postNotificationName:iTM2PrintInfoDidChangeNotification object:self userInfo:oldDictionary];
}
- (void)SWZ_iTM2Misc_setLeftMargin:(CGFloat)margin;
{
	NSDictionary * oldDictionary = [[self.dictionary copy] autorelease];
	[self SWZ_iTM2Misc_setLeftMargin:(CGFloat)margin];
	[INC postNotificationName:iTM2PrintInfoDidChangeNotification object:self userInfo:oldDictionary];
}
- (void)SWZ_iTM2Misc_setRightMargin:(CGFloat)margin;
{
	NSDictionary * oldDictionary = [[self.dictionary copy] autorelease];
	[self SWZ_iTM2Misc_setRightMargin:(CGFloat)margin];
	[INC postNotificationName:iTM2PrintInfoDidChangeNotification object:self userInfo:oldDictionary];
}
- (void)SWZ_iTM2Misc_setTopMargin:(CGFloat)margin;
{
	NSDictionary * oldDictionary = [[self.dictionary copy] autorelease];
	[self SWZ_iTM2Misc_setTopMargin:(CGFloat)margin];
	[INC postNotificationName:iTM2PrintInfoDidChangeNotification object:self userInfo:oldDictionary];
}
- (void)SWZ_iTM2Misc_setBottomMargin:(CGFloat)margin;
{
	NSDictionary * oldDictionary = [[self.dictionary copy] autorelease];
	[self SWZ_iTM2Misc_setBottomMargin:(CGFloat)margin];
	[INC postNotificationName:iTM2PrintInfoDidChangeNotification object:self userInfo:oldDictionary];
}
- (void)SWZ_iTM2Misc_setHorizontallyCentered:(BOOL)flag;
{
	NSDictionary * oldDictionary = [[self.dictionary copy] autorelease];
	[self SWZ_iTM2Misc_setHorizontallyCentered:(BOOL)flag];
	[INC postNotificationName:iTM2PrintInfoDidChangeNotification object:self userInfo:oldDictionary];
}
- (void)SWZ_iTM2Misc_setVerticallyCentered:(BOOL)flag;
{
	NSDictionary * oldDictionary = [[self.dictionary copy] autorelease];
	[self SWZ_iTM2Misc_setVerticallyCentered:(BOOL)flag];
	[INC postNotificationName:iTM2PrintInfoDidChangeNotification object:self userInfo:oldDictionary];
}
- (void)SWZ_iTM2Misc_setHorizontalPagination:(NSPrintingPaginationMode)mode;
{
	NSDictionary * oldDictionary = [[self.dictionary copy] autorelease];
	[self SWZ_iTM2Misc_setHorizontalPagination:(NSPrintingPaginationMode)mode];
	[INC postNotificationName:iTM2PrintInfoDidChangeNotification object:self userInfo:oldDictionary];
}
- (void)SWZ_iTM2Misc_setVerticalPagination:(NSPrintingPaginationMode)mode;
{
	NSDictionary * oldDictionary = [[self.dictionary copy] autorelease];
	[self SWZ_iTM2Misc_setVerticalPagination:(NSPrintingPaginationMode)mode];
	[INC postNotificationName:iTM2PrintInfoDidChangeNotification object:self userInfo:oldDictionary];
}
- (void)SWZ_iTM2Misc_setJobDisposition:(NSString *)disposition;
{
	NSDictionary * oldDictionary = [[self.dictionary copy] autorelease];
	[self SWZ_iTM2Misc_setJobDisposition:(NSString *)disposition];
	[INC postNotificationName:iTM2PrintInfoDidChangeNotification object:self userInfo:oldDictionary];
}
@end

#pragma mark -
#pragma mark =-=-=-=-=-  TOOLBAR

NSString * const iTM2ToolbarToggleDrawerItemIdentifier = @"toggleDrawer";
NSString * const iTM2ToolbarLockDocumentItemIdentifier = @"lockDocument";
NSString * const iTM2ToolbarOrderFrontColorPanelItemIdentifier = @"orderFrontColorPanel";
NSString * const iTM2ToolbarOrderFrontFontPanelItemIdentifier = @"orderFrontFontPanel";
NSString * const iTM2ToolbarSubscriptItemIdentifier = @"subscript";
NSString * const iTM2ToolbarSuperscriptItemIdentifier = @"superscript";
NSString * const iTM2ToolbarUnlockDocumentItemIdentifier = @"unlockDocument";

#define DEFINE_IMAGE(SELECTOR, IDENTIFIER)\
+ (NSImage *)SELECTOR;\
{\
	static NSImage * I = nil;\
	if (!I) {\
		NSString * component = [IDENTIFIER stringByAppendingString:@"ToolbarImage"];\
		NSURL * url = [[iTM2SharedResponder classBundle4iTM3] URLForImageResource:component];\
		I = [[NSImage alloc] initWithContentsOfURL:url];\
		component = [NSString stringWithFormat:@"iTM2:%@", IDENTIFIER];\
		[I setName:component];\
	}\
    return I;\
}
@implementation NSImage(iTM2MiscKit)
DEFINE_IMAGE(imageToggleDrawer, @"toggleDrawer");
DEFINE_IMAGE(imageLockDocument, @"imageLockDocument");
DEFINE_IMAGE(imageOrderFrontColorPanel, @"imageOrderFrontColorPanel");
DEFINE_IMAGE(imageOrderFrontFontPanel, @"imageOrderFrontFontPanel");
DEFINE_IMAGE(imageSubscript, @"imageSubscript");
DEFINE_IMAGE(imageSuperscript, @"imageSuperscript");
DEFINE_IMAGE(imageUnlockDocument, @"imageUnlockDocument");
+ (NSImage *)findImageNamed4iTM3:(NSString *)name;
{
	NSString * imageName = [name hasPrefix:@"iTM2:"]?name:[NSString stringWithFormat:@"iTM2:%@",name];
	NSImage * I;
	if (I = [self imageNamed:imageName]) {
		return I;
	}
	NSURL * imageURL = [[[NSBundle mainBundle] allURLsForImageResource4iTM3:name] lastObject];
	if (I = [[self.alloc initWithContentsOfURL:imageURL] autorelease]) {
		[I setName:imageName];
		return I;
	}
	if ([name hasSuffix:@"(small)"]) {
		imageName = [name substringWithRange:iTM3MakeRange(ZER0,name.length-7)];
		if ((I = [self findImageNamed4iTM3:imageName])) {
			I = [[I copy] autorelease];
			imageName = [name hasPrefix:@"iTM2:"]?name:[NSString stringWithFormat:@"iTM2:%@",name];
			[I setName:imageName];
			[I setScalesWhenResized:YES];
			[I setSize:NSMakeSize(16,16)];
			return I;
		}
	}
	if (iTM2DebugEnabled) {
		LOG4iTM3(@"! ERROR: [NSImage findImageNamed4iTM3:%@] is not found!", name);
	}
	return nil;
}
@end

@implementation NSView(iTM2MiscKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setToolbarSizeMode4iTM3:
- (void)setToolbarSizeMode4iTM3:(NSToolbarSizeMode)sizeMode;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return;
}
@end

#define DEFINE_TOOLBAR_ITEM(SELECTOR)\
+ (NSToolbarItem *)SELECTOR;{return [self toolbarItemWithIdentifier4iTM3:[self identifierFromSelector4iTM3:_cmd] inBundle:[iTM2MainInstaller classBundle4iTM3]];}

@implementation NSToolbarItem(iTM2MiscKit)
DEFINE_TOOLBAR_ITEM(toggleDrawerToolbarItem4iTM3)
DEFINE_TOOLBAR_ITEM(lockDocumentToolbarItem4iTM3)
DEFINE_TOOLBAR_ITEM(unlockDocumentToolbarItemToolbarItem4iTM3)
DEFINE_TOOLBAR_ITEM(subscriptToolbarItem4iTM3)
DEFINE_TOOLBAR_ITEM(superscriptDrawerToolbarItem4iTM3)
DEFINE_TOOLBAR_ITEM(orderFrontColorPanelToolbarItem4iTM3)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  orderFrontFontPanelToolbarItem4iTM3
+ (NSToolbarItem *)orderFrontFontPanelToolbarItem4iTM3;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;orderFrontFontPanel
	id result = [self toolbarItemWithIdentifier4iTM3:[self identifierFromSelector4iTM3:_cmd] inBundle:[iTM2MainInstaller classBundle4iTM3]];
	[result setTarget:[NSFontManager sharedFontManager]];
//END4iTM3;
	return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  identifierFromSelector4iTM3:
+ (NSString *)identifierFromSelector4iTM3:(SEL)aSelector;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
Latest Revision: Sat Jan 30 07:22:38 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	ICURegEx * RE = [ICURegEx regExForKey:@"iTM2_([:alpha:]+)ToolbarItem" error:NULL];
	NSString * result = [RE matchString:NSStringFromSelector(aSelector)]? [RE substringOfCaptureGroupAtIndex:1]:@"";
    RE.forget;
//END4iTM3;
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  selectorFromIdentifier4iTM3:
+ (SEL)selectorFromIdentifier4iTM3:(NSString *)anIdentifier;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSString * suffix = @"ToolbarItem";
//END4iTM3;
	return NSSelectorFromString([@"iTM2" stringByAppendingString:[anIdentifier stringByAppendingString:suffix]]);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toolbarItemWithIdentifier4iTM3:inBundle:
+ (NSToolbarItem *)toolbarItemWithIdentifier4iTM3:(NSString *)anIdentifier inBundle:(NSBundle *)bundle;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSParameterAssert(anIdentifier.length);
	NSParameterAssert(bundle);
	NSToolbarItem * toolbarItem = [[[NSToolbarItem alloc] initWithItemIdentifier:anIdentifier] autorelease];
	[toolbarItem setImage:[NSImage findImageNamed4iTM3:anIdentifier]];
	toolbarItem.label = 
		NSLocalizedStringFromTableInBundle([anIdentifier stringByAppendingString:@"Label"], @"Toolbar", bundle, "");
	toolbarItem.paletteLabel = 
		NSLocalizedStringFromTableInBundle([anIdentifier stringByAppendingString:@"PaletteLabel"], @"Toolbar", bundle, "");
	toolbarItem.toolTip = 
		NSLocalizedStringWithDefaultValue([anIdentifier stringByAppendingString:@"ToolTip"], @"Toolbar", bundle, @"", "");
//END4iTM3;
    return toolbarItem;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  seedToolbarItemWithIdentifier4iTM3:forToolbarIdentifier:
+ (NSToolbarItem *)seedToolbarItemWithIdentifier4iTM3:(NSString *)anIdentifier forToolbarIdentifier:(NSString *)toolbarIdentifier;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
Latest Revision: Sat Jan 30 07:27:45 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSParameterAssert(anIdentifier.length);
	NSParameterAssert(toolbarIdentifier);
	static NSMutableDictionary * _toolbarItems;
	if (!_toolbarItems) {
		_toolbarItems = [[NSMutableDictionary dictionary] retain];
	}
	NSMutableDictionary * toolbarItems = [_toolbarItems objectForKey:toolbarIdentifier];
	if (!toolbarItems) {
		[_toolbarItems setObject:[NSMutableDictionary dictionary] forKey:toolbarIdentifier];
		toolbarItems = [_toolbarItems objectForKey:toolbarIdentifier];
	}
	NSToolbarItem * toolbarItem;
	if (toolbarItem = [toolbarItems objectForKey:anIdentifier]) {
		return [[toolbarItem copy] autorelease];
	}
	SEL selector = [self selectorFromIdentifier4iTM3:anIdentifier];
	if ([self respondsToSelector:selector]) {
		toolbarItem = objc_msgSend(self, selector);
		[toolbarItems setObject:toolbarItem forKey:anIdentifier];
		// wtarting with leopard, this is a problem because the view is no longer archivable
		return [[toolbarItem copy] autorelease];
	}
	toolbarItem = [[[NSToolbarItem alloc] initWithItemIdentifier:anIdentifier] autorelease];
	NSImage * I = nil;
    NSBundle * MB = [NSBundle mainBundle];
	NSURL * imageURL = [[MB allURLsForImageResource4iTM3:anIdentifier] lastObject];
	if (imageURL.isFileURL) {
		if (I = [[NSImage alloc] initWithContentsOfURL:imageURL])
		{
			[I setName:anIdentifier];
			if (iTM2DebugEnabled) {
				LOG4iTM3(@"[NSImage imageNamed:%@] is:%@", anIdentifier, [NSImage imageNamed:anIdentifier]);
			}
			[toolbarItem setImage:[I autorelease]];
			I = [[[NSImage alloc] initWithContentsOfURL:imageURL] autorelease];
			NSBundle * bundle = [MB bundleForResourceAtURL4iTM3:imageURL];
			toolbarItem.label = 
				NSLocalizedStringFromTableInBundle([anIdentifier stringByAppendingString:@"Label"], @"Toolbar", bundle, "");
			toolbarItem.paletteLabel = 
				NSLocalizedStringFromTableInBundle([anIdentifier stringByAppendingString:@"PaletteLabel"], @"Toolbar", bundle, "");
			toolbarItem.toolTip = 
				NSLocalizedStringWithDefaultValue([anIdentifier stringByAppendingString:@"ToolTip"], @"Toolbar", bundle, @"", "");
		}
	} else {
		LOG4iTM3(@"*** iTM2 Packaging ERROR: missing image named: %@",anIdentifier);
		I = [[[NSImage imageMissingImage4iTM3] copy] autorelease];
		[I setSizeIcon4iTM3];
	}
	[I setName:anIdentifier];
	toolbarItem.image = I;
	[toolbarItems setObject:toolbarItem forKey:anIdentifier];
	return [[toolbarItem copy] autorelease];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setToolbarSizeMode4iTM3:
- (void)setToolbarSizeMode4iTM3:(NSToolbarSizeMode)sizeMode;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSView * v = self.view;
	if (v) {
		[v setToolbarSizeMode4iTM3:sizeMode];
		self.minSize = self.maxSize = v.frame.size;
	}
//END4iTM3;
    return;
}
@end
#undef DEFINE_TOOLBAR_ITEM

@implementation NSToolbar(iTM2MiscKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  SWZ_iTM2Misc_setSizeMode:
- (void)SWZ_iTM2Misc_setSizeMode:(NSToolbarSizeMode)sizeMode;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
	for (NSToolbarItem * TBI in self.items) {
		[TBI setToolbarSizeMode4iTM3:sizeMode];
    }
	[self SWZ_iTM2Misc_setSizeMode:sizeMode];
    return;
}
@end

#pragma mark -
#pragma mark =-=-=-=-=-  VALUE TRANSFORMER

@implementation iTM2ValueTransformer
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  transformerName
+ (NSString *)transformerName;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
Latest Revision: Sat Jan 30 07:34:08 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	ICURegEx * RE = [ICURegEx regExForKey:@"([:letter:][:alpha:]*)ValueTransformer" error:NULL];
//END4iTM3;
    NSString * result = [RE matchString:NSStringFromClass(self)]? [RE substringOfCaptureGroupAtIndex:1]:RE.inputString;
    RE.forget;
    return result;
}
@end

@implementation iTM2MainInstaller(ValueTransformer)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2ValueTransformerCompleteInstallation4iTM3
+ (void)iTM2ValueTransformerCompleteInstallation4iTM3;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
Latest Revision: Sat Jan 30 07:34:20 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSPointerArray * PA = [iTM2Runtime subclassReferencesOfClass:[iTM2ValueTransformer class]];
	NSUInteger i = PA.count;
	while (i--) {
		Class C = (Class)[PA pointerAtIndex:i];
        NSValueTransformer * VT = [[[C alloc] init] autorelease];
		[NSValueTransformer setValueTransformer:VT forName:[C transformerName]];
	}
//END4iTM3;
    return;
}
@end

@implementation NSValue(iTM2Range)
- (NSComparisonResult)compareRangeLocation4iTM2:(id)rhs;
{
	NSUInteger l = self.rangeValue.location;
	NSUInteger r = [rhs rangeValue].location;
	if (l<r) return NSOrderedAscending;
	if (l>r) return NSOrderedDescending;
	return NSOrderedSame;
}
@end

@implementation iTM2MainInstaller(MiscKit)
+ (void)prepareMiscKitCompleteInstallation4iTM3;
{
	if ([NSToolbar swizzleInstanceMethodSelector4iTM3:@selector(SWZ_iTM2Misc_setSizeMode:) error:NULL]) {
		MILESTONE4iTM3((@"NSToolbar(iTM2MiscKit)"),(@"setSizeMode: is not patched"));
	}
	if ([NSPrintInfo swizzleInstanceMethodSelector4iTM3:@selector(SWZ_iTM2Misc_setPaperName:) error:NULL]
		&& [NSPrintInfo swizzleInstanceMethodSelector4iTM3:@selector(SWZ_iTM2Misc_setPaperSize:) error:NULL]
		&& [NSPrintInfo swizzleInstanceMethodSelector4iTM3:@selector(SWZ_iTM2Misc_setOrientation:) error:NULL]
		&& [NSPrintInfo swizzleInstanceMethodSelector4iTM3:@selector(SWZ_iTM2Misc_setLeftMargin:) error:NULL]
		&& [NSPrintInfo swizzleInstanceMethodSelector4iTM3:@selector(SWZ_iTM2Misc_setRightMargin:) error:NULL]
		&& [NSPrintInfo swizzleInstanceMethodSelector4iTM3:@selector(SWZ_iTM2Misc_setTopMargin:) error:NULL]
		&& [NSPrintInfo swizzleInstanceMethodSelector4iTM3:@selector(SWZ_iTM2Misc_setBottomMargin:) error:NULL]
		&& [NSPrintInfo swizzleInstanceMethodSelector4iTM3:@selector(SWZ_iTM2Misc_setHorizontallyCentered:) error:NULL]
		&& [NSPrintInfo swizzleInstanceMethodSelector4iTM3:@selector(SWZ_iTM2Misc_setVerticallyCentered:) error:NULL]
		&& [NSPrintInfo swizzleInstanceMethodSelector4iTM3:@selector(SWZ_iTM2Misc_setHorizontalPagination:) error:NULL]
		&& [NSPrintInfo swizzleInstanceMethodSelector4iTM3:@selector(SWZ_iTM2Misc_setVerticalPagination:) error:NULL]
		&& [NSPrintInfo swizzleInstanceMethodSelector4iTM3:@selector(SWZ_iTM2Misc_setJobDisposition:) error:NULL]) {
		MILESTONE4iTM3((@"NSPrintInfo(iTM2MiscKit)"),(@"The print info is not patched, no advances available"));
	}
	if ([NSTextView swizzleInstanceMethodSelector4iTM3:@selector(SWZ_iTM2Misc_resetCursorRects) error:NULL]) {
		MILESTONE4iTM3((@"NSTextView(iTM2MiscKit)"),(@"No resetCursorRects patch available"));
	}
    if ([NSPageLayout swizzleInstanceMethodSelector4iTM3:@selector(SWZ_iTM2Misc_writePrintInfo) error:NULL]) {
		MILESTONE4iTM3((@"NSPageLayout(iTM2MiscKit)"),(@"No writePrintInfo patch available."));
	}
}
@end
