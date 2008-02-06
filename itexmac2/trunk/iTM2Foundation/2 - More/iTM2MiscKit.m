/*
//
//  @version Subversion: $Id$ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Mon May 17 13:54:52 GMT 2004.
//  Copyright ¬© 2005 Laurens'Tribune. All rights reserved.
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

#import <iTM2Foundation/iTM2MiscKit.h>
#import <iTM2Foundation/iTM2RuntimeBrowser.h>
#import <iTM2Foundation/iTM2ResponderKit.h>
#import <iTM2Foundation/iTM2BundleKit.h>
#import <iTM2Foundation/iTM2InstallationKit.h>
#import <iTM2Foundation/iTM2Implementation.h>
#import <iTM2Foundation/iTM2ImageKit.h>

extern int iTM2DebugEnabled;

@implementation iTM2SharedResponder(MiscKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  checkForUpdate:
- (IBAction)checkForUpdate:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Jan 11 11:42:37 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSString * helper = [[[[NSBundle mainBundle] sharedSupportPath] stringByAppendingPathComponent:@"iTeXMac2(Updater)"] stringByAppendingPathExtension:@"app"];
    if(![DFM fileExistsAtPath:helper])
        NSRunAlertPanel(
                NSLocalizedStringFromTableInBundle(@"iTeXMac2 Installation Problem", @"General", [self classBundle], "Panel Title"),
                NSLocalizedStringFromTableInBundle(@"No Updater Available.", @"General", [self classBundle], ""),
                NSLocalizedStringFromTableInBundle(@"OK", @"General", [self classBundle], "OK"),
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * logPath = [NSBundle NSLogOutputPath];
	[SWS openFile:logPath withApplication:@"Console"];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= validateDisplayConsoleDebug:
- (BOOL)validateDisplayConsoleDebug:(id)sender;
/*"This is the build number.
Version History: jlaurens AT users DOT sourceforge DOT net (today)
- 2.0:
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(![sender image])
	{
		NSString * path = [SWS fullPathForApplication:@"Console"];
		NSImage * I = [SWS iconForFile:path];
		[I iTM2_setSizeSmallIcon];
		[sender setImage:I];//size
	}
//iTM2_END;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= takeDebugModeFromSenderTag:
- (void)takeDebugModeFromSenderTag:(id)sender;
/*"This is the build number.
Version History: jlaurens AT users DOT sourceforge DOT net (today)
- 2.0:
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	switch([sender tag])
	{
		case 0: iTM2DebugEnabled = 0; break;
		case 1: iTM2DebugEnabled = 1; break;
		case 2: iTM2DebugEnabled = 100; break;
		case 3: iTM2DebugEnabled = 10000; break;
	}
	if(iTM2DebugEnabled)
	{
		[SUD registerDefaults:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:1] forKey:@"NSScriptingDebugLogLevel"]];
	}
	else
	{
		[SUD registerDefaults:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:0] forKey:@"NSScriptingDebugLogLevel"]];
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= validateTakeDebugModeFromSenderTag:
- (BOOL)validateTakeDebugModeFromSenderTag:(id)sender;
/*"This is the build number.
Version History: jlaurens AT users DOT sourceforge DOT net (today)
- 2.0:
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	unsigned tag;
	if(iTM2DebugEnabled<1)
	{
		tag = 0;// Off
	}
	else if(iTM2DebugEnabled<100)
	{
		tag = 1;// Simple
	}
	else if(iTM2DebugEnabled<10000)
	{
		tag = 2;// Advanced
	}
	else
	{
		tag = 3;// Expert
	}
	[sender setState:([sender tag]==tag?NSOnState:NSOffState)];
//iTM2_END;
    return YES;
}
@end

#import <iTM2Foundation/iTM2CursorKit.h>
#import <objc/objc-runtime.h>
#import <objc/objc-class.h>

@implementation NSTextView(iTM2Misc)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= load
+ (void)load;
/*"Extracted from apple sample code (TextLinks).
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 06/19/2002
To Do List:
"*/
{
    iTM2_INIT_POOL;
	iTM2RedirectNSLogOutput();
//iTM2_START;
	[NSTextView iTM2_swizzleInstanceMethodSelector:@selector(SWZ_iTM2Misc_resetCursorRects)];
//iTM2_END;
	iTM2_RELEASE_POOL;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= SWZ_iTM2Misc_resetCursorRects:
- (void)SWZ_iTM2Misc_resetCursorRects;
/*"Extracted from apple sample code (TextLinks).
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 06/19/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSAttributedString* attrString = [self textStorage];
    //	Figure what part of us is visible (we're typically inside a scrollview)
    NSPoint containerOrigin = [self textContainerOrigin];
    //	Figure the range of characters which is visible
    NSRect visRect = NSOffsetRect ([self visibleRect], -containerOrigin.x, -containerOrigin.y);
    NSRange visibleGlyphRange = [[self layoutManager] glyphRangeForBoundingRect:visRect inTextContainer:[self textContainer]];
    NSRange visibleCharRange = [[self layoutManager] characterRangeForGlyphRange:visibleGlyphRange actualGlyphRange:nil];
    //	Prime for the loop
    NSRange attrsRange = NSMakeRange (visibleCharRange.location, 0);
    //	Loop until we reach the end of the visible range of characters
    while (NSMaxRange(attrsRange) < NSMaxRange(visibleCharRange)) // find all visible URLs and set up cursor rects
    {
        //	Find the next link inside the range
        if ([attrString attribute:NSLinkAttributeName atIndex:NSMaxRange(attrsRange) effectiveRange:&attrsRange] != nil)
        {
            unsigned int rectCount, rectIndex;
            //	Find the rectangles where this range falls. (We could use -boundingRectForGlyphRange:...,
            //	but that gives a single rectangle, which might be overly large when a link runs
            //	through more than one line.)
            NSRectArray rects = [[self layoutManager] rectArrayForCharacterRange:attrsRange
                withinSelectedCharacterRange: NSMakeRange (NSNotFound, 0)
                inTextContainer: [self textContainer]
                rectCount: &rectCount];

            //	For each rectangle, find its visible portion and ask for the cursor to appear
            //	when they're over that rectangle.
            for (rectIndex = 0; rectIndex < rectCount; ++rectIndex)
            {
                [self addCursorRect:NSIntersectionRect (rects[rectIndex], [self visibleRect]) cursor:[NSCursor pointingHandCursor]];
            }
        }
    }
    return;
}
@end

@interface NSObject(iTM2FontManager)
-(void)iTM2_italic:sender;
-(void)iTM2_bold:sender;
-(void)iTM2_unitalic:sender;
-(void)iTM2_unbold:sender;
-(void)iTM2_smallCaps:sender;
@end

NSString * const iTM2FontPanelWillOrderFrontNotification = @"iTM2FontPanelWillOrderFront";

#import <iTM2Foundation/iTM2NotificationKit.h>

@interface NSFontManager_iTeXMac2: NSFontManager
@end


@implementation iTM2MainInstaller(NSFontManager)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  fontManagerCompleteInstallation
+ (void)fontManagerCompleteInstallation;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if([SUD boolForKey:@"iTM2DontPoseAsFontManager"])
    {
        iTM2_LOG(@"No NSFontManager extension available:");
        NSLog(@"terminal%% defaults remove comp.text.TeX.iTeXMac2 iTM2DontPoseAsFontManager");
    }
    else
    {
		[NSFontManager iTM2_swizzleInstanceMethodSelector:@selector(SWZ_iTM2Misc_orderFrontFontPanel:)];
		[NSFontManager iTM2_swizzleInstanceMethodSelector:@selector(SWZ_iTM2Misc_addFontTrait:)];
	}
//iTM2_END;
    return;
}
@end

@implementation NSFontManager(iTM2Misc)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  SWZ_iTM2Misc_orderFrontFontPanel:
- (void)SWZ_iTM2Misc_orderFrontFontPanel:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[INC postNotificationName:iTM2FontPanelWillOrderFrontNotification object:nil];
	[self SWZ_iTM2Misc_orderFrontFontPanel:sender];
//iTM2_END;
    return;
}
- (void)SWZ_iTM2Misc_addFontTrait:(id)sender;
{
	if([sender respondsToSelector:@selector(tag)])
	{
		int tag = [sender tag];
		id FR = [[NSApp mainWindow] firstResponder];
		BOOL done = NO;
		if(((NSItalicFontMask & tag) > 0) && [FR respondsToSelector:@selector(iTM2_italic:)])
		{
			[FR iTM2_italic:sender];
			done = YES;
		}
		if(((NSBoldFontMask & tag) > 0) && [FR respondsToSelector:@selector(iTM2_bold:)])
		{
			[FR iTM2_bold:sender];
			done = YES;
		}
		if(((NSUnitalicFontMask & tag) > 0) && [FR respondsToSelector:@selector(iTM2_unitalic:)])
		{
			[FR iTM2_unitalic:sender];
			done = YES;
		}
		if(((NSUnboldFontMask & tag) > 0) && [FR respondsToSelector:@selector(iTM2_unbold:)])
		{
			[FR iTM2_unbold:sender];
			done = YES;
		}
		if(((NSSmallCapsFontMask & tag) > 0) && [FR respondsToSelector:@selector(iTM2_smallCaps:)])
		{
			[FR iTM2_smallCaps:sender];
			done = YES;
		}
		if(done)
		{
			return;
		}
	}
	[self SWZ_iTM2Misc_addFontTrait:(id)sender];
	return;
}
@end

@implementation NSSavePanel(iTM2MiscKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  pushNavLastRootDirectory
- (void)pushNavLastRootDirectory;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id old = [SUD stringForKey:@"NSNavLastRootDirectory"];
	if(old)
	{
		[SUD setObject:old forKey:@"NSNavLastRootDirectory_Saved"];
		[SUD removeObjectForKey:@"NSNavLastRootDirectory"];
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  popNavLastRootDirectory
- (void)popNavLastRootDirectory;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id old = [SUD stringForKey:@"NSNavLastRootDirectory_Saved"];
	if(old)
		[SUD setObject:old forKey:@"NSNavLastRootDirectory"];
//iTM2_END;
    return;
}
@end

NSString * const iTM2PrintInfoDidChangeNotification = @"iTM2PrintInfoDidChange";

@interface NSPageLayout_iTeXMac2: NSPageLayout
@end
@implementation NSPageLayout_iTeXMac2
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  load
+ (void)load;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{
	iTM2_INIT_POOL;
	iTM2RedirectNSLogOutput();
//iTM2_START;
	[NSPageLayout iTM2_swizzleInstanceMethodSelector:@selector(SWZ_iTM2Misc_writePrintInfo)];
//iTM2_END;
	iTM2_RELEASE_POOL;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  SWZ_iTM2Misc_writePrintInfo
- (void)SWZ_iTM2Misc_writePrintInfo;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSDictionary * oldDictionary = [[[[self printInfo] dictionary] copy] autorelease];
	[self SWZ_iTM2Misc_writePrintInfo];
	[INC postNotificationName:iTM2PrintInfoDidChangeNotification object:[self printInfo] userInfo:oldDictionary];
//iTM2_END;
    return;
}
@end
@interface NSPrintInfo_iTeXMac2: NSPrintInfo
@end
@implementation NSPrintInfo_iTeXMac2
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  load
+ (void)load;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{
	iTM2_INIT_POOL;
	iTM2RedirectNSLogOutput();
//iTM2_START;
	[NSPrintInfo iTM2_swizzleInstanceMethodSelector:@selector(SWZ_iTM2Misc_setPaperName:)];
	[NSPrintInfo iTM2_swizzleInstanceMethodSelector:@selector(SWZ_iTM2Misc_setPaperSize:)];
	[NSPrintInfo iTM2_swizzleInstanceMethodSelector:@selector(SWZ_iTM2Misc_setOrientation:)];
	[NSPrintInfo iTM2_swizzleInstanceMethodSelector:@selector(SWZ_iTM2Misc_setLeftMargin:)];
	[NSPrintInfo iTM2_swizzleInstanceMethodSelector:@selector(SWZ_iTM2Misc_setRightMargin:)];
	[NSPrintInfo iTM2_swizzleInstanceMethodSelector:@selector(SWZ_iTM2Misc_setTopMargin:)];
	[NSPrintInfo iTM2_swizzleInstanceMethodSelector:@selector(SWZ_iTM2Misc_setBottomMargin:)];
	[NSPrintInfo iTM2_swizzleInstanceMethodSelector:@selector(SWZ_iTM2Misc_setHorizontallyCentered:)];
	[NSPrintInfo iTM2_swizzleInstanceMethodSelector:@selector(SWZ_iTM2Misc_setVerticallyCentered:)];
	[NSPrintInfo iTM2_swizzleInstanceMethodSelector:@selector(SWZ_iTM2Misc_setHorizontalPagination:)];
	[NSPrintInfo iTM2_swizzleInstanceMethodSelector:@selector(SWZ_iTM2Misc_setVerticalPagination:)];
	[NSPrintInfo iTM2_swizzleInstanceMethodSelector:@selector(SWZ_iTM2Misc_setJobDisposition:)];
//iTM2_END;
	iTM2_RELEASE_POOL;
    return;
}
- (void)SWZ_iTM2Misc_setPaperName:(NSString *)name;
{
	NSDictionary * oldDictionary = [[[self dictionary] copy] autorelease];
	[self SWZ_iTM2Misc_setPaperName:(NSString *)name];
	[INC postNotificationName:iTM2PrintInfoDidChangeNotification object:self userInfo:oldDictionary];
}
- (void)SWZ_iTM2Misc_setPaperSize:(NSSize)size;
{
	NSDictionary * oldDictionary = [[[self dictionary] copy] autorelease];
	[self SWZ_iTM2Misc_setPaperSize:(NSSize)size];
	[INC postNotificationName:iTM2PrintInfoDidChangeNotification object:self userInfo:oldDictionary];
}
- (void) SWZ_iTM2Misc_setOrientation:(NSPrintingOrientation)orientation;
{
	NSDictionary * oldDictionary = [[[self dictionary] copy] autorelease];
	[self SWZ_iTM2Misc_setOrientation:(NSPrintingOrientation)orientation];
	[INC postNotificationName:iTM2PrintInfoDidChangeNotification object:self userInfo:oldDictionary];
}
- (void)SWZ_iTM2Misc_setLeftMargin:(float)margin;
{
	NSDictionary * oldDictionary = [[[self dictionary] copy] autorelease];
	[self SWZ_iTM2Misc_setLeftMargin:(float)margin];
	[INC postNotificationName:iTM2PrintInfoDidChangeNotification object:self userInfo:oldDictionary];
}
- (void)SWZ_iTM2Misc_setRightMargin:(float)margin;
{
	NSDictionary * oldDictionary = [[[self dictionary] copy] autorelease];
	[self SWZ_iTM2Misc_setRightMargin:(float)margin];
	[INC postNotificationName:iTM2PrintInfoDidChangeNotification object:self userInfo:oldDictionary];
}
- (void)SWZ_iTM2Misc_setTopMargin:(float)margin;
{
	NSDictionary * oldDictionary = [[[self dictionary] copy] autorelease];
	[self SWZ_iTM2Misc_setTopMargin:(float)margin];
	[INC postNotificationName:iTM2PrintInfoDidChangeNotification object:self userInfo:oldDictionary];
}
- (void)SWZ_iTM2Misc_setBottomMargin:(float)margin;
{
	NSDictionary * oldDictionary = [[[self dictionary] copy] autorelease];
	[self SWZ_iTM2Misc_setBottomMargin:(float)margin];
	[INC postNotificationName:iTM2PrintInfoDidChangeNotification object:self userInfo:oldDictionary];
}
- (void)SWZ_iTM2Misc_setHorizontallyCentered:(BOOL)flag;
{
	NSDictionary * oldDictionary = [[[self dictionary] copy] autorelease];
	[self SWZ_iTM2Misc_setHorizontallyCentered:(BOOL)flag];
	[INC postNotificationName:iTM2PrintInfoDidChangeNotification object:self userInfo:oldDictionary];
}
- (void)SWZ_iTM2Misc_setVerticallyCentered:(BOOL)flag;
{
	NSDictionary * oldDictionary = [[[self dictionary] copy] autorelease];
	[self SWZ_iTM2Misc_setVerticallyCentered:(BOOL)flag];
	[INC postNotificationName:iTM2PrintInfoDidChangeNotification object:self userInfo:oldDictionary];
}
- (void)SWZ_iTM2Misc_setHorizontalPagination:(NSPrintingPaginationMode)mode;
{
	NSDictionary * oldDictionary = [[[self dictionary] copy] autorelease];
	[self SWZ_iTM2Misc_setHorizontalPagination:(NSPrintingPaginationMode)mode];
	[INC postNotificationName:iTM2PrintInfoDidChangeNotification object:self userInfo:oldDictionary];
}
- (void)SWZ_iTM2Misc_setVerticalPagination:(NSPrintingPaginationMode)mode;
{
	NSDictionary * oldDictionary = [[[self dictionary] copy] autorelease];
	[self SWZ_iTM2Misc_setVerticalPagination:(NSPrintingPaginationMode)mode];
	[INC postNotificationName:iTM2PrintInfoDidChangeNotification object:self userInfo:oldDictionary];
}
- (void)SWZ_iTM2Misc_setJobDisposition:(NSString *)disposition;
{
	NSDictionary * oldDictionary = [[[self dictionary] copy] autorelease];
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

#if 0
#define DEFINE_IMAGE(SELECTOR, IDENTIFIER)\
+ (NSImage *)SELECTOR;\
{\
	static NSImage * I = nil;\
	if(!I)\
	{\
		NSString * component = [IDENTIFIER stringByAppendingString:@"ToolbarImage"];\
		NSString * path = [[NSPrintInfo_iTeXMac2 classBundle] pathForImageResource:component];\
		I = [[NSImage allocWithZone:[self zone]] initWithContentsOfFile:path];\
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
+ (NSImage *)findImageNamed:(NSString *)name;
{
	NSString * imageName = [name hasPrefix:@"iTM2:"]?name:[NSString stringWithFormat:@"iTM2:%@",name];
	NSImage * I;
	if(I = [self imageNamed:imageName])
	{
		return I;
	}
	NSString * imagePath = [[[NSBundle mainBundle] allPathsForImageResource:name] lastObject];
	if(I = [[[self allocWithZone:[self zone]] initWithContentsOfFile:imagePath] autorelease])
	{
		[I setName:imageName];
		return I;
	}
	if([name hasSuffix:@"(small)"])
	{
		imageName = [name substringWithRange:NSMakeRange(0,[name length]-7)];
		if(I = [self findImageNamed:imageName])
		{
			I = [[I copy] autorelease];
			imageName = [name hasPrefix:@"iTM2:"]?name:[NSString stringWithFormat:@"iTM2:%@",name];
			[I setName:imageName];
			[I setScalesWhenResized:YES];
			[I setSize:NSMakeSize(16,16)];
			return I;
		}
	}
	if(iTM2DebugEnabled)
	{
		iTM2_LOG(@"! ERROR: [NSImage findImageNamed:%@] is not found!", name);
	}
	return nil;
}
@end
#endif

@implementation NSToolbarItem(iTM2MiscKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleDrawerToolbarItem:
+ (NSToolbarItem *)toggleDrawerToolbarItem;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	return [self toolbarItemWithIdentifier:[self identifierFromSelector:_cmd] inBundle:[iTM2MainInstaller classBundle]];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  lockDocumentToolbarItem:
+ (NSToolbarItem *)lockDocumentToolbarItem;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	return [self toolbarItemWithIdentifier:[self identifierFromSelector:_cmd] inBundle:[iTM2MainInstaller classBundle]];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  unlockDocumentToolbarItemToolbarItem:
+ (NSToolbarItem *)unlockDocumentToolbarItemToolbarItem;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	return [self toolbarItemWithIdentifier:[self identifierFromSelector:_cmd] inBundle:[iTM2MainInstaller classBundle]];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  subscriptToolbarItem:
+ (NSToolbarItem *)subscriptToolbarItem;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	return [self toolbarItemWithIdentifier:[self identifierFromSelector:_cmd] inBundle:[iTM2MainInstaller classBundle]];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  superscriptDrawerToolbarItem:
+ (NSToolbarItem *)superscriptDrawerToolbarItem;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	return [self toolbarItemWithIdentifier:[self identifierFromSelector:_cmd] inBundle:[iTM2MainInstaller classBundle]];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  orderFrontColorPanelToolbarItem:
+ (NSToolbarItem *)orderFrontColorPanelToolbarItem;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	return [self toolbarItemWithIdentifier:[self identifierFromSelector:_cmd] inBundle:[iTM2MainInstaller classBundle]];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  orderFrontFontPanelToolbarItem:
+ (NSToolbarItem *)orderFrontFontPanelToolbarItem;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;orderFrontFontPanel
	id result = [self toolbarItemWithIdentifier:[self identifierFromSelector:_cmd] inBundle:[iTM2MainInstaller classBundle]];
	[result setTarget:[NSFontManager sharedFontManager]];
//iTM2_END;
	return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  identifierFromSelector:
+ (NSString *)identifierFromSelector:(SEL)aSelector;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * name = NSStringFromSelector(aSelector);
	NSString * suffix = @"ToolbarItem";
//iTM2_END;
	return [name hasSuffix:suffix]? [name substringWithRange:NSMakeRange(0, [name length] - [suffix length])]:@"";
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  selectorFromIdentifier:
+ (SEL)selectorFromIdentifier:(NSString *)anIdentifier;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * suffix = @"ToolbarItem";
//iTM2_END;
	return NSSelectorFromString([anIdentifier stringByAppendingString:suffix]);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toolbarItemWithIdentifier:inBundle:
+ (NSToolbarItem *)toolbarItemWithIdentifier:(NSString *)anIdentifier inBundle:(NSBundle *)bundle;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSParameterAssert([anIdentifier length]);
	NSParameterAssert(bundle);
	NSImage * I = [NSImage iTM2_cachedImageNamed:anIdentifier];
	if(![I iTM2_isNotNullImage])
	{
		NSString * component = [anIdentifier stringByAppendingString:@"ToolbarImage"];
		I = [NSImage iTM2_cachedImageNamed:component];
	}
	NSToolbarItem * toolbarItem = [[[NSToolbarItem alloc] initWithItemIdentifier:anIdentifier] autorelease];
	[toolbarItem setImage:[NSImage findImageNamed:anIdentifier]];
	[toolbarItem setLabel:
		NSLocalizedStringFromTableInBundle([anIdentifier stringByAppendingString:@"Label"], @"Toolbar", bundle, "")];
	[toolbarItem setPaletteLabel:
		NSLocalizedStringFromTableInBundle([anIdentifier stringByAppendingString:@"PaletteLabel"], @"Toolbar", bundle, "")];
	[toolbarItem setToolTip:
		NSLocalizedStringWithDefaultValue([anIdentifier stringByAppendingString:@"ToolTip"], @"Toolbar", bundle, @"", "")];
//iTM2_END;
    return toolbarItem;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  seedToolbarItemWithIdentifier:forToolbarIdentifier:
+ (NSToolbarItem *)seedToolbarItemWithIdentifier:(NSString *)anIdentifier forToolbarIdentifier:(NSString *)anotherIdentifier;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSParameterAssert([anIdentifier length]);
	NSParameterAssert(anotherIdentifier);
	static NSMutableDictionary * _toolbarItems;
	if(!_toolbarItems)
	{
		_toolbarItems = [[NSMutableDictionary dictionary] retain];
	}
	NSMutableDictionary * toolbarItems = [_toolbarItems objectForKey:anotherIdentifier];
	if(!toolbarItems)
	{
		[_toolbarItems setObject:[NSMutableDictionary dictionary] forKey:anotherIdentifier];
		toolbarItems = [_toolbarItems objectForKey:anotherIdentifier];
	}
	NSToolbarItem * toolbarItem;
	if(toolbarItem = [toolbarItems objectForKey:anIdentifier])
		return [[toolbarItem copy] autorelease];
	
	SEL selector = [self selectorFromIdentifier:anIdentifier];
	if([self respondsToSelector:selector])
	{
		toolbarItem = objc_msgSend(self, selector);
		[toolbarItems setObject:toolbarItem forKey:anIdentifier];
		// wtarting with leopard, this is a problem because the view is no longer archivable
		return [[toolbarItem copy] autorelease];
	}
	toolbarItem = [[[NSToolbarItem alloc] initWithItemIdentifier:anIdentifier] autorelease];
	NSImage * I = nil;
	NSString * imagePath = [[[NSBundle mainBundle] allPathsForImageResource:anIdentifier] lastObject];
	if([imagePath length])
	{
		if(I = [[NSImage allocWithZone:[self zone]] initWithContentsOfFile:imagePath])
		{
			[I setName:anIdentifier];
			if(iTM2DebugEnabled)
			{
				iTM2_LOG(@"[NSImage imageNamed:%@] is:%@", anIdentifier, [NSImage imageNamed:anIdentifier]);
			}
			[toolbarItem setImage:I];
			I = [[[NSImage allocWithZone:[self zone]] initWithContentsOfFile:imagePath] autorelease];
			NSBundle * bundle = [NSBundle bundleForResourceAtPath:imagePath];
			[toolbarItem setLabel:
				NSLocalizedStringFromTableInBundle([anIdentifier stringByAppendingString:@"Label"], @"Toolbar", bundle, "")];
			[toolbarItem setPaletteLabel:
				NSLocalizedStringFromTableInBundle([anIdentifier stringByAppendingString:@"PaletteLabel"], @"Toolbar", bundle, "")];
			[toolbarItem setToolTip:
				NSLocalizedStringWithDefaultValue([anIdentifier stringByAppendingString:@"ToolTip"], @"Toolbar", bundle, @"", "")];
		}
	}
	else
	{
		iTM2_LOG(@"*** iTM2 Packaging ERROR: missing image named: %@",anIdentifier);
		I = [[[NSImage iTM2_imageMissingImage] copy] autorelease];
		[I iTM2_setSizeIcon];
	}
	[I setName:anIdentifier];
	[toolbarItem setImage:I];
	[toolbarItems setObject:toolbarItem forKey:anIdentifier];
	return [[toolbarItem copy] autorelease];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setToolbarSizeMode:
- (void)setToolbarSizeMode:(NSToolbarSizeMode)sizeMode;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSView * v = [self view];
	if(v)
	{
		[v setToolbarSizeMode:sizeMode];
		[self setMinSize:[v frame].size];
		[self setMaxSize:[v frame].size];
	}
//iTM2_END;
    return;
}
@end


@implementation NSView(iTM2MiscKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setToolbarSizeMode:
- (void)setToolbarSizeMode:(NSToolbarSizeMode)sizeMode;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return;
}
@end

@implementation NSToolbar(iTM2Misc)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  load
+ (void)load;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
	iTM2_INIT_POOL;
	iTM2RedirectNSLogOutput();
//iTM2_START;
	[NSToolbar iTM2_swizzleInstanceMethodSelector:@selector(SWZ_iTM2Misc_setSizeMode:)];
//iTM2_END;
	iTM2_RELEASE_POOL;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  SWZ_iTM2Misc_setSizeMode:
- (void)SWZ_iTM2Misc_setSizeMode:(NSToolbarSizeMode)sizeMode;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSEnumerator * E = [[self items] objectEnumerator];
	NSToolbarItem * TBI;
	while(TBI = [E nextObject])
		[TBI setToolbarSizeMode:sizeMode];
	[self SWZ_iTM2Misc_setSizeMode:sizeMode];
//iTM2_END;
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
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * result = NSStringFromClass(self);
//iTM2_END;
    return [result length] > 11? [result substringWithRange:NSMakeRange(0, [result length] - 11)]:result;
}
@end

@implementation iTM2MainInstaller(ValueTransformer)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2ValueTransformerCompleteInstallation
+ (void)iTM2ValueTransformerCompleteInstallation;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSEnumerator * E = [[iTM2RuntimeBrowser subclassReferencesOfClass:[iTM2ValueTransformer class]] objectEnumerator];
	Class C;
	while(C = [[E nextObject] pointerValue])
		[NSValueTransformer setValueTransformer:[[[C alloc] init] autorelease] forName:[C transformerName]];
//iTM2_END;
    return;
}
@end

@implementation NSValue(iTM2Range)
- (NSComparisonResult)iTM2_compareRangeLocation:(id)rhs;
{
	unsigned l = [self rangeValue].location;
	unsigned r = [rhs rangeValue].location;
	if(l<r) return NSOrderedAscending;
	if(l>r) return NSOrderedDescending;
	return NSOrderedSame;
}
@end

