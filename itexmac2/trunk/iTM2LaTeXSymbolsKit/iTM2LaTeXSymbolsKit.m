/*
//  iTM2LaTeXSymbolsKit.m
//  iTeXMac2
//
//  @version Subversion: $Id$ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Mon Jun 24 2002.
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


#import "iTM2LaTeXSymbolsKit.h"

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  iTM2SymbolMenu
/*"Description forthcoming."*/
@implementation iTM2SymbolMenu
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  awakeFromNib
- (void)awakeFromNib;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    while([self numberOfItems]>0)
        [self removeItemAtIndex:0];

    NSDictionary * D = [NSDictionary dictionaryWithContentsOfFile:
        [[NSBundle bundleForClass:[self class]]
            pathForResource: NSStringFromClass([self class]) ofType:@"dict"]];
    NSArray * RA = [D objectForKey:@"items"];
    NSEnumerator * E = [RA objectEnumerator];
    id O;
    unsigned idx = 0;
    while (O = [E nextObject])
    {
        NSMenuItem * MI = [[[NSMenuItem alloc] initWithTitle: @""
                action: @selector(executeSymbolsInstruction:) keyEquivalent: @""] autorelease];
        [MI setRepresentedObject:O];
        [MI setTarget:self];
        [self addItem:MI];
        [[self menuRepresentation]
            setMenuItemCell: [[[iTM2SymbolMenuItemCell alloc] init] autorelease]
                forItemAtIndex: idx];
        ++idx;
    }
    [_Image release];
    _Image = [[NSImage alloc] initWithContentsOfFile:
            [[NSBundle bundleForClass:[self class]] pathForImageResource:NSStringFromClass([self class])]];
    O = [D objectForKey:@"numberOfColumns"];
    [self setNumberOfColumns:[O respondsToSelector:@selector(intValue)]? MAX(1, [O intValue]):1];
    [[self menuRepresentation] setImagePosition:NSImageOnly];
    [[self menuRepresentation] setHorizontalEdgePadding:0];
//iTM2_LOG(@"%@ isFlipped %@", NSStringFromClass([[self menuRepresentation] class]), ([[self menuRepresentation] isFlipped]? @"Y": @"N"));
//iTM2_LOG(@"%@ isFlipped %@", NSStringFromClass([_Image class]), ([_Image isFlipped]? @"Y": @"N"));
//iTM2_LOG(@"number of columns %i", [self numberOfColumns]);
//iTM2_LOG(@"number of rows %i", [self numberOfRows]);
//iTM2_LOG(@"_Image path: %@", [[NSBundle bundleForClass:[self class]] pathForImageResource:NSStringFromClass([self class])]);
//iTM2_LOG(@"_Image size: %@", NSStringFromSize([_Image size]));
    [_Image setFlipped:[[self menuRepresentation] isFlipped]];
//NSLog(@"[self numberOfColumns] %u", [self numberOfColumns]);
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  image
- (NSImage *)image;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return _Image;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  executeSymbolsInstruction:
- (IBAction)executeSymbolsInstruction:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id target = [NSApp targetForAction:_cmd to:nil from:[sender representedObject]];
	if([NSApp sendAction:_cmd to:target from:[sender representedObject]])
	{
		if([target isKindOfClass:[NSView class]])
		{
//			[[target window] makeKeyAndOrderFront:self];
		}
	}
	else
	{
		iTM2_LOG(@"Could not insert: %@", [sender representedObject]);
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  validateMenuItem:
- (BOOL)validateMenuItem:(id <NSMenuItem>)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    id O = [sender representedObject];
    return (O != nil) && (![O isKindOfClass:[NSString class]] || ![O isEqualToString:@"noop:"]);
}
@end

#define IMPL(arg) @implementation arg @end
IMPL(iTM2LaTeXArrowsMenu)
IMPL(iTM2LaTeXRelationsMenu)
IMPL(iTM2LaTeXRelationsNotMenu)
IMPL(iTM2LaTeXBinaryMenu)
IMPL(iTM2LaTeXMiscMenu)
IMPL(iTM2LaTeXCalMenu)
IMPL(iTM2LaTeXVariableMenu)
IMPL(iTM2LaTeXForeignMenu)
IMPL(iTM2LaTeXAccentMenu)
IMPL(iTM2LaTeXSymbolMenu)
IMPL(iTM2LaTeXGreekMenu)
IMPL(iTM2LaTeXGreekCapsMenu)
IMPL(iTM2AMSArrowsMenu)
IMPL(iTM2AMSBinaryMenu)
IMPL(iTM2AMSMiscMenu)
IMPL(iTM2AMSOrdinaryMenu)
IMPL(iTM2AMSRelationCurlMenu)
IMPL(iTM2AMSRelationMenu)
IMPL(iTM2AMSRelationSetMenu)
IMPL(iTM2AMSRelationSimMenu)
IMPL(iTM2AMSRelationTriangleMenu)
IMPL(iTM2AMSMathfrakMenu)
IMPL(iTM2AMSMathbbMenu)
IMPL(iTM2AMSMathfrakCapsMenu)
IMPL(iTM2MathbbMenu)
IMPL(iTM2MathbbCapsMenu)
IMPL(iTM2MathbbNumMenu)
IMPL(iTM2MathbbGreekMenu)
IMPL(iTM2MathrsfsMenu)
IMPL(iTM2MVSArrowsMenu)
IMPL(iTM2MVSMiscMenu)
IMPL(iTM2MVSDeskMenu)
IMPL(iTM2MVSZodiacMenu)
IMPL(iTM2MVSNumbersMenu)
IMPL(iTM2WSBoxMenu)
IMPL(iTM2WSMathMenu)
IMPL(iTM2WSMiscMenu)
IMPL(iTM2WSMhoMenu)
IMPL(iTM2WSZodiacMenu)
IMPL(iTM2PiFontMisc1Menu)
IMPL(iTM2PiFontMisc2Menu)
IMPL(iTM2PiFontDigitsMenu)
IMPL(iTM2PiFontArrowsMenu)
IMPL(iTM2PiFontStarsMenu)

NSString * const iTM2SymbolMenuBugKey = @"iTM2SymbolMenuBug";

/*"Description forthcoming."*/
@implementation iTM2SymbolMenuItemCell
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initialize
+ (void)initialize;
/*"Patch for old system: there is a problem between systeme 10.1 and 10.1.5.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{
//NSLog(@"+[%@ %@] 0x%x", [self class], NSStringFromSelector(_cmd), self);
    [[NSUserDefaults standardUserDefaults] registerDefaults:
            [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:iTM2SymbolMenuBugKey]];        
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleFixSymbolMenuBug:
+ (void)toggleFixSymbolMenuBug:(id)sender;
/*"Patch for old system: there is a problem between systeme 10.1 and 10.1.5.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{
//NSLog(@"+[%@ %@] 0x%x", [self class], NSStringFromSelector(_cmd), self);
    [[NSUserDefaults standardUserDefaults] setBool: ![[NSUserDefaults standardUserDefaults] boolForKey:iTM2SymbolMenuBugKey]
        forKey: iTM2SymbolMenuBugKey];        
    NSLog(@"Trying to fix the symbol drawer bug, you might have to restart iteXMac...(%@)",
        ([[NSUserDefaults standardUserDefaults] boolForKey:iTM2SymbolMenuBugKey]? @"YES": @"NO"));
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateMenuItem:
+ (BOOL)validateMenuItem:(id <NSMenuItem>)sender;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (11/10/2001).
To do list:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setState: ([[NSUserDefaults standardUserDefaults] boolForKey:iTM2SymbolMenuBugKey]? NSOnState:NSOffState)];
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  init
- (id)init;
/*"Patch for old system: there is a problem between systeme 10.1 and 10.1.5.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(self = [super init])
    {
        _Bug = [[NSUserDefaults standardUserDefaults] boolForKey:iTM2SymbolMenuBugKey];
//iTM2_LOG(@"Bug:%@",(_Bug?@"Y":@"N"));
    }
    return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  cellSize
- (NSSize)cellSize;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    id M = [[self menuItem] menu];
    NSSize S = [[M image] size];
    S.height /= 2;
    return NSMakeSize(S.width / [M numberOfColumns], S.height / [M numberOfRows]);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  imageWidth
- (float)imageWidth;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [self cellSize].width;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  drawImageWithFrame:inView:
- (void)drawImageWithFrame:(NSRect)cellFrame inView:(NSView *)controlView;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    id M = [[self menuItem] menu];
    unsigned index = [M indexOfItem:[self menuItem]];
    unsigned column = [M columnForItemIndex:index];
    unsigned row = [M rowForItemIndex:index];
    NSRect R = NSZeroRect;
    NSImage * MI = [M image];
//NSLog(@"drawImageWithFrame:inView: %@, index %i", NSStringFromRect(cellFrame), [M indexOfItem:[self menuItem]]);
    R.size = [self cellSize];
    R.origin.x += column * R.size.width;
    if(_Bug)
        R.origin.y += ([M numberOfRows] * ([self isHighlighted]? 1: 2) - row - 1) * R.size.height;
    else
        R.origin.y += ([M numberOfRows] * ([self isHighlighted]? 1: 0) + row) * R.size.height;
    [MI drawInRect:[self imageRectForBounds:cellFrame] fromRect:R operation:NSCompositeSourceAtop fraction:1.0];
    #if 0
    if(index == 0)
    {
        NSLog(NSStringFromRect(R));
        NSLog(@"[self isHighlighted]: %@", ([self isHighlighted]? @"Y": @"N"));
        NSLog(@"NSOnState: %@", ([self state] == NSOnState? @"Y": @"N"));
    }
    #endif
//NSLog(@"drawImageWithFrame:inView:\nindex %5i, row: %5u, column: %5u, H: %@\ncellFrame: %@,\nR        : %@",\
//            [M indexOfItem:[self menuItem]], row, column, ([self isHighlighted]? @"Y": @"N"),\
//        NSStringFromRect(cellFrame), NSStringFromRect(R));
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  imageRectForBounds:
- (NSRect)imageRectForBounds:(NSRect)cellFrame;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSRect R = cellFrame;
    R.size = [self cellSize];
    if(R.size.width < cellFrame.size.width)
        R.origin.x += (cellFrame.size.width - R.size.width)/2;
    if(R.size.height < cellFrame.size.height)
        R.origin.y += (cellFrame.size.height - R.size.height)/2;
    return R;
}
@end

/*"Description forthcoming."*/
@implementation NSTextView(iTM2LaTeXSymbolsKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  useLaTeXPackage:
- (IBAction)useLaTeXPackage:(id)sender;
/*".
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if([sender isKindOfClass:[NSControl class]])
	{
		[self insertMacro: [NSDictionary dictionaryWithObject:
//		[self tryToPerform: @selector(insertMacro:)with: [NSDictionary dictionaryWithObject:
#warning THE JAPANESE IS NOT YET SUPPORTED
                [NSString stringWithFormat:@"\\usepackage{%@}\n", [sender title]]
                    forKey: @"selected"]];
//		[[self window] makeKeyAndOrderFront:self];
	}
    else
        NSBeep();
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  executeSymbolsInstruction:
- (void)executeSymbolsInstruction:(id)instruction;
/*"Description forthcoming.
If the event is a 1 char key down, it will ask the current key binding for instruction.
The key and its modifiers are 
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{
//iTM2_START;
	[self performSelector:@selector(iTM2_executeSymbolsInstruction:) withObject:instruction afterDelay:0.01];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  iTM2_executeSymbolsInstruction:
- (void)iTM2_executeSymbolsInstruction:(id)instruction;
/*"Description forthcoming.
If the event is a 1 char key down, it will ask the current key binding for instruction.
The key and its modifiers are 
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{
//iTM2_START;
    if([instruction isKindOfClass:[NSArray class]])
    {
        NSEnumerator * E = [instruction objectEnumerator];
        while(instruction = [E nextObject])
            [self iTM2_executeSymbolsInstruction:instruction];
    }
    else if([instruction isKindOfClass:[NSDictionary class]])
    {
        NSString * toolTip = [instruction objectForKey:@"toolTip"];
        NSString * stringSel = [instruction objectForKey:@"selector"];
        if([toolTip length])
            [self postNotificationWithStatus: ([toolTip isKindOfClass:[NSString class]]? toolTip:nil)];
        if([stringSel isKindOfClass:[NSString class]])
            [self tryToPerform:NSSelectorFromString(stringSel) with:[instruction objectForKey:@"argument"]];
        else
        {
            NSLog(@"-[%@ %@] unrecognized object: %@", [self class], NSStringFromSelector(_cmd), stringSel);
        }
    }
    else if([instruction isKindOfClass:[NSString class]])
    {
        if(!([self tryToPerform:NSSelectorFromString(instruction) with:nil]) && [(NSString *)instruction length])
        {
            [self tryToPerform:@selector(insertMacro:) with:instruction];
        }
        else
        {
            [self insertText:instruction];
        }
    }
    return;
}
@end

@implementation iTM2LaTeXSymbolsPanelController
@end

@implementation iTM2LaTeXSymbolsPanel
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  sharedPanel
+ (id)sharedPanel;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{
    static NSWindowController * WC;
	if(!WC)
	{
		WC = [[iTM2LaTeXSymbolsPanelController alloc] initWithWindowNibName:NSStringFromClass(self)];
	}
    return [WC window];
}
///=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  windowPositionShouldBeObserved
- (BOOL)canBecomeKeyWindow;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  windowPositionShouldBeObserved
- (BOOL)windowPositionShouldBeObserved;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  frameIdentifier
- (NSString *)frameIdentifier;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{
    return @"LaTeX Symbols";
}
@end

@implementation iTM2SharedResponder(iTM2LaTeXSymbolsKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  orderFrontLaTeXSymbolsPanel:
- (IBAction)orderFrontLaTeXSymbolsPanel:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{
    [[iTM2LaTeXSymbolsPanel sharedPanel] makeKeyAndOrderFront:sender];
    return;
}
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  iTM2SymbolMenu

