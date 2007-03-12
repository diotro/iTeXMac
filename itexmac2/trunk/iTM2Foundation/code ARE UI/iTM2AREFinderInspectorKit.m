// iTM2AREFinderInspector.m
//
//  @version Subversion: $Id$ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Thu Jan 09 2003.
//  From source code of Mike Ferris's MOKit at http://mokit.sourcefoge.net
//  Copyright © 2003 Laurens'Tribune. All rights reserved.
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

//#import <iTM2Foundation/iTM2ResponderKit.h>
#import <iTM2Foundation/iTM2ValidationKit.h>
#import <iTM2Foundation/iTM2BundleKit.h>
#import <iTM2Foundation/iTM2StringKit.h>
#import <iTM2Foundation/iTM2AREFinderInspectorKit.h>
#import <iTM2Foundation/iTM2ARegularExpressionKit.h>
#import <iTM2Foundation/iTM2PathUtilities.h>
#import <iTM2Foundation/iTM2NotificationKit.h>
#import <iTM2Foundation/iTM2TextFieldKit.h>
#import <iTM2Foundation/iTM2ViewKit.h>
//#import <iTM2Foundation/iTM2TeXTextStorage.h>
#import <iTM2Foundation/iTM2LiteScanner.h>
#warning IS USED iTM2TeXTextStorage

NSString * const iTM2UDARegularExpressionsKey = @"Regular Expressions";
NSString * const iTM2UDARESaveFolderKey = @"iTM2UDARESaveFolder";
NSString * const iTM2AREFolderName = @"Templates For Regular Expressions";
NSString * const iTM2AREFindKey = @"Find";
NSString * const iTM2AREFindModeKey = @"FindMode";
NSString * const iTM2AREFindRangeKey = @"FindRange";
NSString * const iTM2AREReplaceKey = @"Replace";
NSString * const iTM2AREReplaceModeKey = @"ReplaceMode";
NSString * const iTM2AREOptionsKey = @"Options";
NSString * const iTM2AREToolTipKey = @"ToolTip";

@interface iTM2AREFinderInspector(PRIVATE)
- (void)setWindowController:(NSWindowController *)argument;
- (int)menu:(NSMenu *)M insertTemplatesMenuItemsAtPath:(NSString *)path atIndex:(int)index;
- (void)setRegularExpression:(iTM2ARegularExpression *)argument;
- (void)check:(id)sender;
- (BOOL)validateUserInterfaceItems;
- (void)prepareMainTextView;
- (void)reset;
- (void)cleanTemporaryAttributes;
- (void)tagRanges:(NSArray *)ranges highLight:(BOOL)yorn mark:(BOOL)flag;
- (BOOL)highlightAndScrollToVisibleRangesAtIndex:(int)index;
- (int)_replaceAllWithReplacement:(NSMutableArray *)replacement;
- (int)_replaceMarkedWithReplacement:(NSMutableArray *)replacement;
- (int)_replaceMatchAtIndex:(int)index withReplacement:(NSMutableArray *)replacement selectWhenDone:(BOOL)yorn;
- (void)showNext:(id)sender;
@end

@interface NSColor(ARE_PRIVATE)
+ (NSColor *)regularExpressionColor;
+ (NSColor *)selectedRegularExpressionColor;
@end

@implementation iTM2AREFinderInspector
static id _iTM2AREFinderInspector = nil;
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  sharedInspector
+ (id)sharedInspector;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 03/10/2002
To Do List: ...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return _iTM2AREFinderInspector? _iTM2AREFinderInspector: (_iTM2AREFinderInspector = [[self alloc] init]);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initialize
+ (void)initialize;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 03/10/2002
To Do List: ...
"*/
{
	iTM2_INIT_POOL;
//iTM2_START;
    [super initialize];
    [SUD registerDefaults:
        [NSDictionary dictionaryWithObjectsAndKeys:@"", iTM2UDARESaveFolderKey, nil]];
//iTM2_END;
	iTM2_RELEASE_POOL;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  init
- (id)init;
/*"One shot designated initializer.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 03/10/2002
To Do List: ...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(self = [[super init] autorelease])
    {
        _Options = iTM2AREAdvancedMask;
//NSLog(@"_Options: %x", _Options);
        _HighLightIndex = NSNotFound;
        _MarkIndexes = [[NSArray array] retain];
        [[NSNotificationCenter defaultCenter] removeObserver:self
            name: NSWindowDidBecomeMainNotification
                object: nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
            selector: @selector(windowDidBecomeMainNotified:)
                name: NSWindowDidBecomeMainNotification
                    object: nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self
            name: NSWindowDidResignMainNotification
                object: nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
            selector: @selector(windowDidResignMainNotified:)
                name: NSWindowDidResignMainNotification
                    object: nil];
    }
    return [self retain];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  dealloc
- (void)dealloc;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 03/10/2002
To Do List: ...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self setWindowController:nil];
    [self setAllRanges:nil];
    [_MarkIndexes autorelease];
    _MarkIndexes = nil;
    [_TemplatesMenu autorelease];
    _TemplatesMenu = nil;
    [self setRegularExpression:nil];
    [super dealloc];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  allRanges
- (NSArray *)allRanges;
/*"Lazy intializer.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 03/10/2002
To Do List: ...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return _AllRanges;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  replaceAllRanges:
- (void)replaceAllRanges:(NSArray *)argument;
/*"The argument is retained such that everything else is retained, the windowController, its content view and all the subviews.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 03/10/2002
To Do List: ...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if (argument && ![argument isKindOfClass:[NSArray class]]) 
        [NSException raise:NSInvalidArgumentException format:@"%@ NSArray argument expected:got %@.",
            __iTM2_PRETTY_FUNCTION__ , argument];
    else if(![_AllRanges isEqual:argument])
    {
        [_AllRanges autorelease];
        _AllRanges = [argument retain];
        [_MarkIndexes autorelease];
        _MarkIndexes = [[NSArray array] retain];
        _HighLightIndex = NSNotFound;
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setAllRanges:
- (void)setAllRanges:(NSArray *)argument;
/*"The argument is retained such that everything else is retained, the windowController, its content view and all the subviews.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 03/10/2002
To Do List: ...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if (argument && ![argument isKindOfClass:[NSArray class]]) 
        [NSException raise:NSInvalidArgumentException format:@"%@ NSArray argument expected:got %@.",
            __iTM2_PRETTY_FUNCTION__ , argument];
    else if(![_AllRanges isEqual:argument])
    {
        [_AllRanges autorelease];
        _AllRanges = [argument retain];
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  windowController
- (id)windowController;
/*"Lazy intializer.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 03/10/2002
To Do List: ...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(!_WC)
    {
        [self setWindowController:[[[NSWindowController allocWithZone:[self zone]]
            initWithWindowNibName: NSStringFromClass([self class]) owner:self] autorelease]];
    }
    return _WC;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setWindowController:
- (void)setWindowController:(NSWindowController *)argument;
/*"The argument is retained such that everything else is retained, the windowController, its content view and all the subviews.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 03/10/2002
To Do List: ...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if (argument && ![argument isKindOfClass:[NSWindowController class]]) 
        [NSException raise:NSInvalidArgumentException format:@"%@ NSWindowController argument expected:got %@.",
            __iTM2_PRETTY_FUNCTION__ , argument];
    else if(![_WC isEqual:argument])
    {
        [_WC release];
        _WC = [argument retain];
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  regularExpression
- (iTM2ARegularExpression *)regularExpression;
/*"Lazy intializer.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 03/10/2002
To Do List: ...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(!_RE)
        [self check:self];
    return _RE;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setRegularExpression:
- (void)setRegularExpression:(iTM2ARegularExpression *)argument;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 03/10/2002
To Do List: ...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if (argument && ![argument isKindOfClass:[iTM2ARegularExpression class]]) 
        [NSException raise:NSInvalidArgumentException format:
            @"%@ iTM2ARegularExpression argument expected: got %@.",
                __iTM2_PRETTY_FUNCTION__ , argument];
    else if(![_RE isEqual:argument])
    {
        [_RE autorelease];
        _RE = [argument retain];
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  show
- (void)show;
/*"The argument is retained such that everything else is retained, the windowController, its content view and all the subviews.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 03/10/2002
To Do List: ...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [[[self windowController] window] makeKeyAndOrderFront:self];
    [self validateUserInterfaceItems];
    [self postNotificationWithStatus:@"OK"];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateUserInterfaceItems
- (BOOL)validateUserInterfaceItems;
/*"The argument is retained such that everything else is retained, the windowController, its content view and all the subviews.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 03/10/2002
To Do List: ...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(![[self windowController] isWindowLoaded] || ![[[self windowController] window] isVisible])
        return YES;
    [self prepareMainTextView];
    NSString * S = [[[[_MainTextView window] windowController] document] displayName]? :@"...";
    NSWindow * W = [[self windowController] window];
    [W setTitle:[NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"Find RE in %@",
                        @"iTM2AREFinder", myBUNDLE, ""), S]];
    BOOL flag = [[W contentView] validateUserInterfaceItems];
    if(![[findTextView string] length])
        [self postNotificationWithToolTip:NSLocalizedStringFromTableInBundle(@"Enter an RE in the find text view",
            @"iTM2AREFinder", myBUNDLE, "")];
    return flag;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setWindow:
- (void)setWindow:(NSWindow *)argument;
/*"The argument is retained such that everything else is retained, the windowController, its content view and all the subviews.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 03/10/2002
To Do List: ...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if (argument && ![argument isKindOfClass:[NSWindow class]]) 
        [NSException raise:NSInvalidArgumentException format:@"%@ NSWindow argument expected:got %@.",
            __iTM2_PRETTY_FUNCTION__ , argument];
    else
    {
        [_WC setWindow:argument];
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  windowControllerDidLoadNib:
- (void)windowControllerDidLoadNib:(NSWindowController *)WC;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 03/10/2002
To Do List: ...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [spinningWheel setUsesThreadedAnimation:NO];
    [spinningWheel setDisplayedWhenStopped:NO];
    [[WC window] setDelegate:self];
//    [[findTextView layoutManager] replaceTextStorage:[[[iTM2TextStorage alloc] init] autorelease]];
    [findTextView setDelegate:self];
//    [[replaceTextView layoutManager] replaceTextStorage:[[[iTM2TeXTextStorage alloc] init] autorelease]];
    [replaceTextView setDelegate:self];
    [self validateUserInterfaceItems];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  textViewDidChangeSelection:
- (void)textViewDidChangeSelection:(NSNotification *)notification;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 03/10/2002
To Do List: ...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self validateUserInterfaceItems];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  textDidChange:
- (void)textDidChange:(NSNotification *)notification;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 03/10/2002
To Do List: ...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if([notification object] == findTextView)
    {
        [self setRegularExpression:nil];
    }
    [self validateUserInterfaceItems];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  textStorageDidProcessEditingNotified:
- (void)textStorageDidProcessEditingNotified:(NSNotification *)notification;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 03/10/2002
To Do List: ...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self reset];
    [self validateUserInterfaceItems];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  windowDidBecomeMainNotified:
- (void)windowDidBecomeMainNotified:(NSNotification *)notification;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 03/10/2002
To Do List: ...
"*/
{
//NSLog(@"%@ %#x, %%: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), self, [[notification userInfo] objectForKey:@"Done"]);
    [self validateUserInterfaceItems];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  windowDidResignMainNotified:
- (void)windowDidResignMainNotified:(NSNotification *)notification;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 03/10/2002
To Do List: ...
"*/
{
//NSLog(@"%@ %#x, %%: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), self, [[notification userInfo] objectForKey:@"Done"]);
    [self reset];
    [self validateUserInterfaceItems];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  windowWillClose:
- (void)windowWillClose:(NSNotification *)notification;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 03/10/2002
To Do List: ...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//NSLog(@"[notification object]:%@", [notification object]);
//NSLog(@"[[self windowController] window]:%@", [[self windowController] window]);
    if([notification object] == [[self windowController] window])
    {
        [self prepareMainTextView];
        [self reset];
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  windowWillResize:toSize:
- (NSSize)windowWillResize:(NSWindow *)sender toSize:(NSSize)frameSize;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 03/10/2002
To Do List: ...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    frameSize.width = [sender frame].size.width;
    return frameSize;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  check:
- (void)check:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: Thu Jan 09 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    iTM2ARegularExpression * RE = [iTM2ARegularExpression regularExpressionWithString:[findTextView string]];
    [RE setOptions:_Options];
    if([RE expressionValue])
        [self setRegularExpression:RE];
    [self postNotificationWithToolTip:[RE compilationStatusString]];
    [self validateUserInterfaceItems];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateCheck:
- (BOOL)validateCheck:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 03/10/2002
To Do List: ...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return ([[findTextView string] length] && (!_RE || ![_RE compilationStatus]));
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  find:
- (void)find:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 03/10/2002
To Do List: ...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self performSelector:@selector(findDelayed:) withObject:nil afterDelay:0];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  progressInfoNotified:
- (void)progressInfoNotified:(NSNotification *)notification;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 03/10/2002
To Do List: ...
"*/
{
//NSLog(@"%@ %#x, %%: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), self, [[notification userInfo] objectForKey:@"Done"]);
    [spinningWheel setDoubleValue:[[[notification userInfo] objectForKey:@"Done"] doubleValue]];
    [spinningWheel displayIfNeeded];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  listenToProgressInfoFromObject:
- (void)listenToProgressInfoFromObject:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 03/10/2002
To Do List: ...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [[NSNotificationCenter defaultCenter] removeObserver:self
        name: @"iTM2ProgressInfoNotification"
            object: nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
        selector: @selector(progressInfoNotified:)
            name: @"iTM2ProgressInfoNotification"
                object: sender];
    [spinningWheel setIndeterminate:NO];
    [spinningWheel setMinValue:(double)0.0];
    [spinningWheel setMaxValue:(double)1.0];
    [[NSNotificationCenter defaultCenter]
        postNotificationName: @"iTM2ProgressInfoNotification"
            object: sender
                userInfo: [NSDictionary dictionaryWithObject:
                    [NSNumber numberWithFloat:0.0] forKey:@"Done"]];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  dontListenToProgressInfo
- (void)dontListenToProgressInfo;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 03/10/2002
To Do List: ...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [[NSNotificationCenter defaultCenter] removeObserver:self
        name: @"iTM2ProgressInfoNotification"
            object: nil];
    [spinningWheel setDoubleValue:(double)0];
    [spinningWheel stopAnimation:self];
    [spinningWheel setDisplayedWhenStopped:NO];
    [spinningWheel displayIfNeeded];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  findDelayed:
- (void)findDelayed:(id)irrelevant;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 03/10/2002
To Do List: ...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    iTM2ARegularExpression * RE = [self regularExpression];
    if([RE compilationStatus])
        return;
    if(RE)
    {
        [self postNotificationWithToolTip:
            NSLocalizedStringFromTableInBundle(@"Searching...\nPlease wait until operation is complete.", @"iTM2AREFinder",
                myBUNDLE, "")];
        [self prepareMainTextView];
        [_MarkIndexes autorelease];
        _MarkIndexes = [[NSArray array] retain];
        [self cleanTemporaryAttributes];
        if(_FindMode==iTM2AREFindAllMode)
        {
            NSRange range = (_FindRange==iTM2ARERangeAllMode)?
                NSMakeRange(0, [[_MainTextView string] length]):[_MainTextView selectedRange];
            [self listenToProgressInfoFromObject:[_MainTextView string]];
            [self replaceAllRanges:[[_MainTextView string] allRangesOfRegularExpression:[self regularExpression]
                    options: _Options range: range]];
            [self dontListenToProgressInfo];
        }
        else if(_FindRange==iTM2ARERangeAllMode)
        {
            NSRange range;
            if([[self allRanges] count] > 0)
            {
                NSArray * RA = [[self allRanges] objectAtIndex:[[self allRanges] count] - 1];
                if([RA isKindOfClass:[NSArray class]] && [RA count])
                {
                    NSValue * V = [RA objectAtIndex:0];
                    if([V isKindOfClass:[NSValue class]])
                    {
                        range = [V rangeValue];
                        if(range.length)
                        {
                            range.location = NSMaxRange([V rangeValue]);
                            goto next;
                        }
                    }
                }
                range.location = [_MainTextView selectedRange].location;
            }
            else
                range.location = 0;
            next:
            if(range.location<[[_MainTextView string] length])
            {
                range.length = [[_MainTextView string] length] - range.location;
            }
            else
                range = NSMakeRange(0, [[_MainTextView string] length]);
            [self replaceAllRanges:[NSArray arrayWithObject:
                [[_MainTextView string] rangesOfRegularExpression:[self regularExpression] options:_Options range:range]]];
        }
        else
        {
            NSRange range;
            range.location = [_MainTextView selectedRange].location;
            if(range.location<[[_MainTextView string] length])
            {
                range.length = [[_MainTextView string] length] - range.location;
            }
            else
                range = NSMakeRange(0, [[_MainTextView string] length]);
            [self replaceAllRanges:[NSArray arrayWithObject:
                [[_MainTextView string] rangesOfRegularExpression:[self regularExpression] options:_Options range:range]]];
        }
        int CNT = [[self allRanges] count];
        if(CNT)
        {
            [_MainTextView setSelectedRange:NSMakeRange(NSMaxRange([_MainTextView selectedRange]), 0)];
            [self tagAllRanges:[self allRanges]];
            if(!NSLocationInRange(_HighLightIndex, NSMakeRange(0, CNT)))
                _HighLightIndex = 0;
            if([self highlightAndScrollToVisibleRangesAtIndex:_HighLightIndex])
            {
                NSString * resultStatus = @"";
                int cnt = [[self allRanges] count];
                switch(cnt)
                {
                    case 0:
                        resultStatus = NSLocalizedStringFromTableInBundle(@"No match.", @"iTM2AREFinder",
                                myBUNDLE, "");
                        break;
                    case 1:
                        resultStatus = NSLocalizedStringFromTableInBundle(@"One match.", @"iTM2AREFinder",
                                myBUNDLE, "");
                        break;
                    default:
                        resultStatus = [NSString stringWithFormat:
                            NSLocalizedStringFromTableInBundle(@"%i matches.", @"iTM2AREFinder",
                                myBUNDLE, ""), cnt];
                        break;
                }
                [self postNotificationWithToolTip:resultStatus];
                [self dontListenToProgressInfo];
                [self validateUserInterfaceItems];
                return;
            }
        }
        [self postNotificationWithToolTip:
            [NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"No match.", @"iTM2AREFinder", myBUNDLE, ""), [[self allRanges] count]]];
//NSLog(@"[self allRanges]:%@", [self allRanges]);
    }
    else
    {
        iTM2Beep();
        NSLog(@"BAD _RE: %@", [findTextView string]);
    }
    [self dontListenToProgressInfo];
    [self validateUserInterfaceItems];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateFind:
- (BOOL)validateFind:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 03/10/2002
To Do List: ...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return ([[_MainTextView string] length] && [[findTextView string] length]);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  replace:
- (void)replace:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 03/10/2002
To Do List: ...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self listenToProgressInfoFromObject:self];
    [self postNotificationWithToolTip:
        NSLocalizedStringFromTableInBundle(@"Replacing...\nPlease wait until operation is complete.", @"iTM2AREFinder",
            myBUNDLE, "")];
    [self prepareMainTextView];

    NSMutableArray * replacement = [NSMutableArray array];
    NSCharacterSet * noControlSet = [[NSCharacterSet characterSetWithCharactersInString:@"\\"] invertedSet];
    NSCharacterSet * voidCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@""];
    NSString * replaceString = [replaceTextView string];
    iTM2LiteScanner * S = [iTM2LiteScanner scannerWithString:replaceString];
    int start = 0, top = [replaceString length];
    huahine:
    [S setCharactersToBeSkipped:noControlSet];
    if([S scanString:@"\\" intoString:nil])
    {
        int anchor = [S scanLocation] - 1;// anchor points to the \ char, which can be the one immediately following the string to add
        int n;
        [S setCharactersToBeSkipped:voidCharacterSet];
        if([S scanInt:&n])
        {
            // we found an escape sequence
            if(start < anchor)
                [replacement addObject:
                    [[replaceString substringWithRange:NSMakeRange(start, anchor - start)] RE2TeXConvertedString]];
            [replacement addObject:[NSNumber numberWithInt:n]];
            start = [S scanLocation];
        }
        else
        {
            // just advance one step beyond, nothing to save yet
            [S setScanLocation:[S scanLocation] + 1];
        }
        goto huahine;
    }
    else if(start < [replaceString length])
    {
        [replacement addObject:
            [[replaceString substringWithRange:NSMakeRange(start, top - start)] RE2TeXConvertedString]];
    }

    int result;
    switch(_ReplaceMode)
    {
        case iTM2AREReplaceCurrentMode:
        default:
        result = [self _replaceMatchAtIndex:_HighLightIndex withReplacement:replacement selectWhenDone:YES];
        break;
        case iTM2AREReplaceAndNextMode:
        {
            int index = _HighLightIndex;
            if(result = [self _replaceMatchAtIndex:index withReplacement:replacement selectWhenDone:NO])
                if([[self allRanges] count])
                {
                    [self tagAllRanges:[self allRanges]];
//NSLog(@"_HighLightIndex: %i", _HighLightIndex);
                    _HighLightIndex = index - 1;
//NSLog(@"_HighLightIndex: %i", _HighLightIndex);
                    [self showNext:sender];
                }
                else
                    [self find:sender];
        }
        break;
        case iTM2AREReplaceMarkedMode:
        result = [self _replaceMarkedWithReplacement:replacement];
        [self tagAllRanges:[self allRanges]];
        break;
        case iTM2AREReplaceAllMode:
        result = [self _replaceAllWithReplacement:replacement];
        break;
    }
    NSString * resultStatus = @"";
    switch(result)
    {
        case 0:
            resultStatus = NSLocalizedStringFromTableInBundle(@"No match replaced.", @"iTM2AREFinder",
                    myBUNDLE, "");
            break;
        case 1:
            resultStatus = NSLocalizedStringFromTableInBundle(@"One match replaced.", @"iTM2AREFinder",
                    myBUNDLE, "");
            break;
        default:
            resultStatus = [NSString stringWithFormat:
                NSLocalizedStringFromTableInBundle(@"%i matches replaced.", @"iTM2AREFinder",
                    myBUNDLE, ""), result];
            break;
    }
    [self postNotificationWithToolTip:resultStatus];
    [self dontListenToProgressInfo];
    [self validateUserInterfaceItems];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  _replaceAllWithReplacement:
- (int)_replaceAllWithReplacement:(NSMutableArray *)replacement;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 03/10/2002
To Do List: ...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    int result = 0;
    float max = MAX(1, [[self allRanges] count]);
    int done = 0;
    while([[self allRanges] count])
    {
	result += [self _replaceMatchAtIndex:0 withReplacement:replacement selectWhenDone:NO];
        ++done;
        [[NSNotificationCenter defaultCenter]
            postNotificationName: @"iTM2ProgressInfoNotification"
                object: self
                    userInfo: [NSDictionary dictionaryWithObject:
                        [NSNumber numberWithFloat:done/max] forKey:@"Done"]];
    }
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  _replaceMarkedWithReplacement:
- (int)_replaceMarkedWithReplacement:(NSMutableArray *)replacement;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 03/10/2002
To Do List: ...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    int result = 0;
    float max = MAX(1, [_MarkIndexes count]);
    int done = 0;
    manihi:
    if([_MarkIndexes count])
    {
        ++ done;
        [[NSNotificationCenter defaultCenter]
            postNotificationName: @"iTM2ProgressInfoNotification"
                object: self
                    userInfo: [NSDictionary dictionaryWithObject:
                        [NSNumber numberWithFloat:done/max] forKey:@"Done"]];
        NSNumber * N = [_MarkIndexes objectAtIndex:0];
        if([N isKindOfClass:[NSNumber class]])
        {
            int n = [N intValue];
            if(NSLocationInRange(n, NSMakeRange(0, [[self allRanges] count])))
            {
                result += [self _replaceMatchAtIndex:n withReplacement:replacement selectWhenDone:NO];
                goto manihi;
            }
        }
        goto manihi;
    }
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  _replaceMatchAtIndex:withReplacement:selectWhenDone:
- (int)_replaceMatchAtIndex:(int)index withReplacement:(NSMutableArray *)replacement selectWhenDone:(BOOL)yorn;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 03/10/2002
To Do List: ...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//NSLog(@"replacement: %@", replacement);
    if(![replacement isKindOfClass:[NSArray class]]) 
        [NSException raise:NSInvalidArgumentException format:@"%@ non nil NSArray argument expected:got %@.",
            __iTM2_PRETTY_FUNCTION__, replacement];
    if(!NSLocationInRange(index, NSMakeRange(0, [[self allRanges] count])))
        [NSException raise:NSInvalidArgumentException format:@"%@ bad index:got 0 <= %i < %i.",
            __iTM2_PRETTY_FUNCTION__, index, [[self allRanges] count]];

    // preparing the replacement, no clever process
    NSArray * RA = [[self allRanges] objectAtIndex:index];
    if(![RA isKindOfClass:[NSArray class]]) 
        [NSException raise:NSInternalInconsistencyException format:@"%@ NSArray expected:got %@.",
            __iTM2_PRETTY_FUNCTION__, replacement];
    if([RA count])
    {
        NSValue * V = [RA objectAtIndex:0];
        if(![V isKindOfClass:[NSValue class]])
            [NSException raise:NSInternalInconsistencyException format:
                @"%@ NSValue object expected: got %@.",
                    __iTM2_PRETTY_FUNCTION__, V];
        
        NSRange ACR = [V rangeValue];
        if(NSMaxRange(ACR)>[[_MainTextView string] length])
            [NSException raise:NSInternalInconsistencyException format:@"%@ bad character range:got %@ (%i).",
                __iTM2_PRETTY_FUNCTION__, V, [[_MainTextView string] length]];

        replacement = [[replacement mutableCopy] autorelease];
        NSMutableDictionary * cache = [NSMutableDictionary dictionary];
        int idx = 0;
        while(idx<[replacement count])
        {
            id O = [replacement objectAtIndex:idx];
            if([O isKindOfClass:[NSNumber class]])
            {
                NSString * S = [cache objectForKey:O];
                if(!S)
                {
                    int n = [O intValue];
                    if(NSLocationInRange(n, NSMakeRange(0, [RA count])))
                    {
                        NSValue * V = [RA objectAtIndex:n];
                        if(![V isKindOfClass:[NSValue class]])
                            [NSException raise:NSInternalInconsistencyException format:
                                @"%@ NSValue object expected: got %@.",
                                    __iTM2_PRETTY_FUNCTION__, V];
                        NSRange R = [V rangeValue];
                        if(n>0)
                        {
                            // the range is an offset!!!
                            if(NSMaxRange(R)>ACR.length)
                        [NSException raise:NSInternalInconsistencyException format:
                    @"%@ bad subexpression range: got %@ (%@).",
                __iTM2_PRETTY_FUNCTION__, NSStringFromRange(R), NSStringFromRange(ACR)];
                            R.location += ACR.location;
                        }
                        S = [[_MainTextView string] substringWithRange:R];
                    }
                    else
                        S = [SUD objectForKey:iTM2TextPlaceholder];
                    [cache setObject:(S?:@"") forKey:O];
                }
                [replacement replaceObjectAtIndex:idx withObject:[cache objectForKey:O]];
            }
            else if(![O isKindOfClass:[NSString class]])
                [NSException raise:NSInternalInconsistencyException format:
                    @"%@ NSString or NSNumber object expected: got %@.",
                        __iTM2_PRETTY_FUNCTION__, O];
            ++idx;
        }
        NSString * RS = [replacement componentsJoinedByString:@""];
        if([_MainTextView shouldChangeTextInRange:ACR replacementString:RS])
        {
            NSMutableArray * MRA = [[[self allRanges] mutableCopy] autorelease];// early
            NSMutableArray * marked = [[_MarkIndexes mutableCopy] autorelease];// early
            [_MainTextView replaceCharactersInRange:ACR withString:RS];
            [_MainTextView didChangeText];
            if(yorn)
                [_MainTextView scrollRangeToVisible:NSMakeRange(ACR.location, [RS length])];
            else
                [_MainTextView scrollRangeToVisible:NSMakeRange(ACR.location + [RS length], 0)];
            // cleaning the marked ranges
            NSMutableArray * newMarked = [NSMutableArray arrayWithCapacity:1 + [marked count]];
            NSEnumerator * E = [marked objectEnumerator];
            NSNumber * N;
            NSRange ARR = NSMakeRange(0, [MRA count]);
            while(N = [E nextObject])
            {
                if([N isKindOfClass:[NSNumber class]])
                {
                    int n = [N intValue];
                    if(NSLocationInRange(n, ARR))
                    {
                        if(n<index)
                            [newMarked addObject:N];
                        else if(n>index)
                            [newMarked addObject:[NSNumber numberWithInt:n-1]];
                    }
                }
            }
            [_MarkIndexes release];
            _MarkIndexes = [newMarked retain];
            int idx = [MRA indexOfObject:RA];
            [MRA removeObject:RA];
            int changeInLength = [RS length] - ACR.length;
            int frontier = NSMaxRange(ACR);
            if(changeInLength)
            {
                rurutu:
                if(idx<[MRA count])
                {
                    NSMutableArray * mra = [[[MRA objectAtIndex:idx] mutableCopy] autorelease];
                    if([mra count])
                    {
                        NSValue * V = [mra objectAtIndex:0];
                        if([V isKindOfClass:[NSValue class]])
                        {
                            NSRange R = [V rangeValue];
                            if(R.location >= frontier)
                            {
                                R.location += changeInLength;
                                [mra replaceObjectAtIndex:0 withObject:[NSValue valueWithRange:R]];
                                [MRA replaceObjectAtIndex:idx withObject:mra];
                                ++idx;
                                goto rurutu;
                            }
                        }
                    }
                    [MRA removeObjectAtIndex:idx];
                    goto rurutu;
                }
            }
            [self setAllRanges:MRA];
            return 1;
        }
    }
    return 0;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateReplace:
- (BOOL)validateReplace:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 03/10/2002
To Do List: ...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    switch(_ReplaceMode)
    {
        case iTM2AREReplaceCurrentMode:
        case iTM2AREReplaceAndNextMode:
            return NSLocationInRange(_HighLightIndex, NSMakeRange(0, [_AllRanges count])) && [[replaceTextView string] length];
        break;
        case iTM2AREReplaceMarkedMode:
            return [_MarkIndexes count] && [[replaceTextView string] length];
        break;
        case iTM2AREReplaceAllMode:
            return [_AllRanges count] && [[replaceTextView string] length];
    }
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  showEdited:
- (void)showEdited:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 03/10/2002
To Do List: ...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    int new = [sender intValue]-1;
    if(NSLocationInRange(new, NSMakeRange(0, [[self allRanges] count])))
    {
        [self highlightAndScrollToVisibleRangesAtIndex:new];
        [[sender window] makeFirstResponder:[sender nextKeyView]];
    }
    [self validateUserInterfaceItems];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateShowEdited:
- (BOOL)validateShowEdited:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 03/10/2002
To Do List: ...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    iTM2NavigationFormatter * F = [sender formatter];
    if(!F)
    {
        F = [[[iTM2NavigationFormatter alloc] init] autorelease];
        [F setNavigationFormat:NSLocalizedStringFromTableInBundle(@"Match:%1$@ / %2$@", @"iTM2AREFinder",
                                                myBUNDLE, "Navigation format")];
        [F setMinimum:(id)[NSNumber numberWithInt:1]];
        [F setAttributedStringForNotANumber:[[[NSAttributedString alloc] initWithString:NSLocalizedStringFromTableInBundle(@"No match.", @"iTM2AREFinder",
                                                myBUNDLE, "Navigation format")] autorelease]];
        [sender setFormatter:F];
    }
    int CNT = [[self allRanges] count];
    [F setMaximum:(id)[NSNumber numberWithInt:CNT]];
    if(NSLocationInRange(_HighLightIndex, NSMakeRange(0, CNT)))
    {
        [sender setObjectValue:[NSNumber numberWithInt:_HighLightIndex+1]];
    }
    else
    {
        [sender setObjectValue:[NSDecimalNumber notANumber]];
    }
    return (CNT>1);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  showNext:
- (void)showNext:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 03/10/2002
To Do List: ...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(_HighLightIndex + 1 < [[self allRanges] count])
        [self highlightAndScrollToVisibleRangesAtIndex:_HighLightIndex+1];
    else if([[self allRanges] count])
        [self highlightAndScrollToVisibleRangesAtIndex:0];
    [self validateUserInterfaceItems];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateShowNext:
- (BOOL)validateShowNext:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 03/10/2002
To Do List: ...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return ([[self allRanges] count]>1);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  showNextMarked:
- (void)showNextMarked:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 03/10/2002
To Do List: ...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if([_MarkIndexes count])
    {
        NSRange bigRange = NSMakeRange(0, [[self allRanges] count]);
        int n0 = NSLocationInRange(_HighLightIndex, bigRange)? _HighLightIndex: 0;
        NSEnumerator * E = [_MarkIndexes objectEnumerator];
        NSNumber * N = nil;
        while(N = [E nextObject])
        {
            if([N isKindOfClass:[NSNumber class]])
            {
                int n = [N intValue];
                if(NSLocationInRange(n, bigRange) && (n>n0))
                {
                    [self highlightAndScrollToVisibleRangesAtIndex:n];
                    [self validateUserInterfaceItems];
                    return;
                }
            }
        }
        N = [_MarkIndexes objectAtIndex:0];
        if([N isKindOfClass:[NSNumber class]])
        {
            [self highlightAndScrollToVisibleRangesAtIndex:[N intValue]];
            [self validateUserInterfaceItems];
        }
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateShowNextMarked:
- (BOOL)validateShowNextMarked:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 03/10/2002
To Do List: ...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return ([_MarkIndexes count]);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  showNextUnmarked:
- (void)showNextUnmarked:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 03/10/2002
To Do List: ...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if([_MarkIndexes count]<[[self allRanges] count])
    {
        int n = MAX(_HighLightIndex, -1);
        mars:
        if(++n<[[self allRanges] count])
        {
            NSNumber * N = [NSNumber numberWithInt:n];
            if([_MarkIndexes indexOfObject:N] == NSNotFound)
            {
                [self highlightAndScrollToVisibleRangesAtIndex:n];
                [self validateUserInterfaceItems];
                return;
            }
            goto mars;
        }
        n = 0;
        int n0 = MIN([[self allRanges] count], _HighLightIndex);
        while(n<n0)
        {
            NSNumber * N = [NSNumber numberWithInt:n];
            if([_MarkIndexes indexOfObject:N] == NSNotFound)
            {
                [self highlightAndScrollToVisibleRangesAtIndex:n];
                [self validateUserInterfaceItems];
                return;
            }
            ++n;
        }
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateShowNextUnmarked:
- (BOOL)validateShowNextUnmarked:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 03/10/2002
To Do List: ...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return ([_MarkIndexes count]<[[self allRanges] count]);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  showPrevious:
- (void)showPrevious:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 03/10/2002
To Do List: ...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(_HighLightIndex > 0)
    {
        if(_HighLightIndex-1<[[self allRanges] count])
            [self highlightAndScrollToVisibleRangesAtIndex:_HighLightIndex-1];
    }
    else if([[self allRanges] count])
        [self highlightAndScrollToVisibleRangesAtIndex:[[self allRanges] count]-1];
    [self validateUserInterfaceItems];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateShowPrevious:
- (BOOL)validateShowPrevious:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 03/10/2002
To Do List: ...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return ([[self allRanges] count]>1);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  showPreviousMarked:
- (void)showPreviousMarked:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 03/10/2002
To Do List: ...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if([_MarkIndexes count])
    {
        NSRange bigRange = NSMakeRange(0, [[self allRanges] count]);
        int n0 = NSLocationInRange(_HighLightIndex, bigRange)? _HighLightIndex: [[self allRanges] count]-1;
        NSEnumerator * E = [_MarkIndexes reverseObjectEnumerator];
        NSNumber * N = nil;
        while(N = [E nextObject])
        {
            if([N isKindOfClass:[NSNumber class]])
            {
                int n = [N intValue];
                if(NSLocationInRange(n, bigRange) && (n<n0))
                {
                    [self highlightAndScrollToVisibleRangesAtIndex:n];
                    [self validateUserInterfaceItems];
                    return;
                }
            }
        }
        N = [_MarkIndexes lastObject];
        if([N isKindOfClass:[NSNumber class]])
        {
            [self highlightAndScrollToVisibleRangesAtIndex:[N intValue]];
            [self validateUserInterfaceItems];
        }
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateShowPreviousMarked:
- (BOOL)validateShowPreviousMarked:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 03/10/2002
To Do List: ...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return ([_MarkIndexes count]);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  showPreviousUnmarked:
- (void)showPreviousUnmarked:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 03/10/2002
To Do List: ...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if([_MarkIndexes count]<[[self allRanges] count])
    {
        int n = _HighLightIndex;
        while(n-->0)
        {
            NSNumber * N = [NSNumber numberWithInt:n];
            if([_MarkIndexes indexOfObject:N] == NSNotFound)
            {
                [self highlightAndScrollToVisibleRangesAtIndex:n];
                [self validateUserInterfaceItems];
                return;
            }
        }
        n = [[self allRanges] count];
        int n0 = MAX(0, _HighLightIndex);
        while(--n>n0)
        {
            NSNumber * N = [NSNumber numberWithInt:n];
            if([_MarkIndexes indexOfObject:N] == NSNotFound)
            {
                [self highlightAndScrollToVisibleRangesAtIndex:n];
                [self validateUserInterfaceItems];
                return;
            }
        }
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateShowPreviousUnmarked:
- (BOOL)validateShowPreviousUnmarked:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 03/10/2002
To Do List: ...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return ([_MarkIndexes count]<[[self allRanges] count]);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleIgnoreCase:
- (void)toggleIgnoreCase:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 03/10/2002
To Do List: ...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    _Options ^= iTM2ARECaseIndependentMask;
    [self validateUserInterfaceItems];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleIgnoreCase:
- (BOOL)validateToggleIgnoreCase:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 03/10/2002
To Do List: ...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setState:(_Options & iTM2ARECaseIndependentMask? NSOnState:NSOffState)];
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleFindMode:
- (void)toggleFindMode:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 03/10/2002
To Do List: ...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    _FindMode = [[sender selectedCell] tag];
    [self validateUserInterfaceItems];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleFindMode:
- (BOOL)validateToggleFindMode:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 03/10/2002
To Do List: ...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender selectCellWithTag:_FindMode];
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleFindRange:
- (void)toggleFindRange:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 03/10/2002
To Do List: ...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    _FindRange = [[sender selectedCell] tag];
    [self validateUserInterfaceItems];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleFindRange:
- (BOOL)validateToggleFindRange:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 03/10/2002
To Do List: ...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender selectCellWithTag:_FindRange];
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleMarked:
- (void)toggleMarked:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 03/10/2002
To Do List: ...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(NSLocationInRange(_HighLightIndex, NSMakeRange(0, [[self allRanges] count])))
    {
        NSArray * ranges = [[self allRanges] objectAtIndex:_HighLightIndex];
        NSNumber * N = [NSNumber numberWithInt:_HighLightIndex];
        NSMutableArray * MRA = [[_MarkIndexes mutableCopy] autorelease];
        BOOL shouldMark = NO;
        if([MRA indexOfObject:N] == NSNotFound)
        {
            int idx = 0;
            tahiti:
            if(idx<[MRA count])
            {
                if([(NSNumber *)[MRA objectAtIndex:idx] compare:N] == NSOrderedDescending)
                    [MRA insertObject:N atIndex:idx];
                else
                {
                    ++idx;
                    goto tahiti;
                }
            }
            else
                [MRA addObject:N];
            shouldMark = YES;
        }
        else
        {
            do
                [MRA removeObject:N];
            while([MRA indexOfObject:N] != NSNotFound);
        }
        [_MarkIndexes autorelease];
        _MarkIndexes = [MRA copy];
        [self tagRanges:ranges highLight:YES mark:shouldMark];
        [self validateUserInterfaceItems];
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleMarked:
- (BOOL)validateToggleMarked:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 03/10/2002
To Do List: ...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(NSLocationInRange(_HighLightIndex, NSMakeRange(0, [[self allRanges] count])))
    {
        NSNumber * N = [NSNumber numberWithInt:_HighLightIndex];
        [sender setState:([_MarkIndexes indexOfObject:N] == NSNotFound? NSOffState:NSOnState)];
        return YES;
    }
    else
    {
        [sender setState:NSOffState];
        return NO;
    }
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleReplaceMode:
- (void)toggleReplaceMode:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 03/10/2002
To Do List: ...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    _ReplaceMode = [[sender selectedCell] tag];
    [self validateUserInterfaceItems];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleReplaceMode:
- (BOOL)validateToggleReplaceMode:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 03/10/2002
To Do List: ...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender selectCellWithTag:_ReplaceMode];
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  RE2TeXFind:
- (void)RE2TeXFind:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 03/10/2002
To Do List: ...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSRange SR = [findTextView selectedRange];
    if(SR.length)
    {
        NSString * S = [[[findTextView string] substringWithRange:SR] RE2TeXConvertedString];
        if([findTextView shouldChangeTextInRange:SR replacementString:S])
        {
            [findTextView replaceCharactersInRange:SR withString:S];
            [findTextView didChangeText];
        }
        [self validateUserInterfaceItems];
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateRE2TeXFind:
- (BOOL)validateRE2TeXFind:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 03/10/2002
To Do List: ...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [findTextView selectedRange].length;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  RE2TeXReplace:
- (void)RE2TeXReplace:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 03/10/2002
To Do List: ...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSRange SR = [replaceTextView selectedRange];
    if(SR.length)
    {
        NSString * S = [[[replaceTextView string] substringWithRange:SR] RE2TeXConvertedString];
        if([replaceTextView shouldChangeTextInRange:SR replacementString:S])
        {
            [replaceTextView replaceCharactersInRange:SR withString:S];
            [replaceTextView didChangeText];
        }
        [self validateUserInterfaceItems];
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateRE2TeXReplace:
- (BOOL)validateRE2TeXReplace:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 03/10/2002
To Do List: ...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [replaceTextView selectedRange].length;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  TeX2REFind:
- (void)TeX2REFind:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 03/10/2002
To Do List: ...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSRange SR = [findTextView selectedRange];
    if(SR.length)
    {
        NSString * S = [[[findTextView string] substringWithRange:SR] TeX2REConvertedString];
        if([findTextView shouldChangeTextInRange:SR replacementString:S])
        {
            [findTextView replaceCharactersInRange:SR withString:S];
            [findTextView didChangeText];
        }
        [self validateUserInterfaceItems];
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateTeX2REFind:
- (BOOL)validateTeX2REFind:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 03/10/2002
To Do List: ...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [findTextView selectedRange].length;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  TeX2REReplace:
- (void)TeX2REReplace:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 03/10/2002
To Do List: ...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSRange SR = [replaceTextView selectedRange];
    if(SR.length)
    {
        NSString * S = [[[replaceTextView string] substringWithRange:SR] TeX2REConvertedString];
        if([replaceTextView shouldChangeTextInRange:SR replacementString:S])
        {
            [replaceTextView replaceCharactersInRange:SR withString:S];
            [replaceTextView didChangeText];
        }
        [self validateUserInterfaceItems];
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateTeX2REReplace:
- (BOOL)validateTeX2REReplace:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 03/10/2002
To Do List: ...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [replaceTextView selectedRange].length;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  showHelp:
- (void)showHelp:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 03/10/2002
To Do List: ...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSBundle * B = myBUNDLE;
    NSString * key = NSLocalizedStringFromTableInBundle(iTM2UDARegularExpressionsKey, iTM2UDARegularExpressionsKey, B, "the localized name of the rtf help file");
    NSString * fileName = [B pathForResource:key ofType:@"rtf"];
    if([fileName length])
        [[NSWorkspace sharedWorkspace] openFile:fileName];
    else
    {
	//iTM2_START;
	NSLog(@"Missing ARE Help File");
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateShowHelp:
- (BOOL)validateShowHelp:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 03/10/2002
To Do List: ...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setEnabled:YES];
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  templatePopUp:
- (void)templatePopUp:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 03/10/2002
To Do List: ...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateTemplatePopUp:
- (BOOL)validateTemplatePopUp:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 03/10/2002
To Do List: ...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    // first we list all the user templates
    if(_DontUpdateTemplates)
        return YES;
    _DontUpdateTemplates = YES;
    if(!_TemplatesMenu)
    {
        _TemplatesMenu = [[sender menu] copy];
    }
    NSMenu * senderMenu = [[_TemplatesMenu copy] autorelease];
    NSMenu * M = [[_TemplatesMenu copy] autorelease];
    while([M numberOfItems])
        [M removeItemAtIndex:0];
    NSBundle * B = [NSBundle mainBundle];
#warning DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD ERROR ERROR???
	NSString * path = [[B pathsForSupportResource:nil ofType:nil inDirectory:iTM2AREFolderName domains:NSUserDomainMask] lastObject];
    int before = MIN(1, [senderMenu numberOfItems]);
    int after = [self menu:senderMenu insertTemplatesMenuItemsAtPath:path atIndex:before];
    if(after>before)
        [senderMenu insertItem:[NSMenuItem separatorItem] atIndex:after];

    id MI;
    if(MI = [senderMenu itemWithTag:-1])// built in
    {
        NSMenu * MM = [[M copy] autorelease];
        path = [myBUNDLE pathForResource:nil ofType:nil inDirectory:iTM2AREFolderName];
#warning DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD ERROR ERROR
#warning DOES IT WORK?
//iTM2_LOG(@"path: %@");
        if([self menu:MM insertTemplatesMenuItemsAtPath:path atIndex:0])
            [MI setSubmenu:MM];
        else
            [senderMenu removeItem:MI];
    }
    if(MI = [senderMenu itemWithTag:NSLocalDomainMask])// local domain mask
    {
        NSMenu * MM = [[M copy] autorelease];
        path = [[B pathsForSupportResource:nil ofType:nil inDirectory:iTM2AREFolderName domains:NSLocalDomainMask] lastObject];
        if([self menu:MM insertTemplatesMenuItemsAtPath:path atIndex:0])
            [MI setSubmenu:MM];
        else
            [senderMenu removeItem:MI];
    }
    if(MI = [senderMenu itemWithTag:NSNetworkDomainMask])// network domain mask
    {
        NSMenu * MM = [[M copy] autorelease];
        path = [[B pathsForSupportResource:nil ofType:nil inDirectory:iTM2AREFolderName domains:NSNetworkDomainMask] lastObject];
        if([self menu:MM insertTemplatesMenuItemsAtPath:path atIndex:0])
            [MI setSubmenu:MM];
        else
        {
            int index = [senderMenu indexOfItem:MI];
            if((index>0) && [[senderMenu itemAtIndex:index - 1] isEqual:[NSMenuItem separatorItem]]
                && ((index==[senderMenu numberOfItems]-1)
                        || [[senderMenu itemAtIndex:index + 1] isEqual:[NSMenuItem separatorItem]]))
                [senderMenu removeItemAtIndex:index -1];
            [senderMenu removeItem:MI];
        }
    }
    [sender removeAllItems];
    [sender setMenu:senderMenu];
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  menu:insertTemplatesMenuItemsAtPath:atIndex:
- (int)menu:(NSMenu *)M insertTemplatesMenuItemsAtPath:(NSString *)path atIndex:(int)index;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 03/10/2002
To Do List: ...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//NSLog(@"path: %@", path);
    NSMenu * templateMenu = [[M copy] autorelease];
    while([templateMenu numberOfItems])
        [templateMenu removeItemAtIndex:0];
    NSEnumerator * E = [[DFM directoryContentsAtPath:path] objectEnumerator];
    NSMutableArray * dirMenus = [NSMutableArray array];
    NSString * subpath;
    while(subpath = [E nextObject])
    {
        BOOL isDirectory = NO;
        NSString * RO = [[path stringByAppendingPathComponent:subpath] stringByResolvingSymlinksAndFinderAliasesInPath];
//NSLog(@"\n\nRO: %@\n\n", RO);
        if([DFM fileExistsAtPath:RO isDirectory:&isDirectory])
        {
            if(isDirectory)
            {
                NSMenu * menu = [[templateMenu copy] autorelease];
                [menu setTitle:[subpath stringByDeletingPathExtension]];
                if([self menu:menu insertTemplatesMenuItemsAtPath:RO atIndex:0])
                    [dirMenus addObject:menu];
            }
            else if([[[subpath pathExtension] lowercaseString] isEqualToString:@"dict"])
            {
                NSMenuItem * MI = [M insertItemWithTitle:[subpath stringByDeletingPathExtension]
                    action: @selector(useRepresentedObjectAsTemplatePath:) keyEquivalent: @"" atIndex: index];
                [MI setRepresentedObject:RO];
                [MI setTarget:self];
                ++index;
            }
        }
    }
    E = [dirMenus objectEnumerator];
    NSMenu * menu;
    while(menu = [E nextObject])
        [[M insertItemWithTitle:[menu title] action:NULL keyEquivalent:@"" atIndex:index++] setSubmenu:menu];
    return index;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  useRepresentedObjectAsTemplatePath:
- (void)useRepresentedObjectAsTemplatePath:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 03/10/2002
To Do List: ...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//NSLog(@"RO: %@", [sender representedObject]);
    NSDictionary * template = [NSDictionary dictionaryWithContentsOfFile:[sender representedObject]];
    if(template)
    {
        [findTextView setSelectedRange:NSMakeRange(0, [[findTextView string] length])];
        NSLog([findTextView string]);
//NSLog(@"[[findTextView string] length]:%i", [[findTextView string] length]);
        id O = [template objectForKey:iTM2AREFindKey];
        [findTextView insertMacro:(O? O:@"")];
        NSLog([replaceTextView string]);
//NSLog(@"[[replaceTextView string] length]:%i", [[replaceTextView string] length]);
        [replaceTextView setSelectedRange:NSMakeRange(0, [[replaceTextView string] length])];
        O = [template objectForKey:iTM2AREReplaceKey];
        [replaceTextView insertMacro:(O? O:@"")];
        [self postNotificationWithToolTip:([template objectForKey:iTM2AREToolTipKey]? :@"")];
        NSNumber * N;
        N = [template objectForKey:iTM2AREFindModeKey];
        if([N isKindOfClass:[NSNumber class]])
            _FindMode = [N intValue];
        else
            _FindMode = 0;
        N = [template objectForKey:iTM2AREReplaceModeKey];
        if([N isKindOfClass:[NSNumber class]])
            _ReplaceMode = [N intValue];
        else
            _ReplaceMode = 0;
        N = [template objectForKey:iTM2AREOptionsKey];
        if([N isKindOfClass:[NSNumber class]])
            _Options = [N intValue];
        else
            _Options = iTM2AREAdvancedMask;
    //NSLog(@"_Options: %x", _Options);
        N = [template objectForKey:iTM2AREFindRangeKey];
        if([N isKindOfClass:[NSNumber class]])
            _FindRange = [N intValue];
        else
            _FindRange = 0;
        [self validateUserInterfaceItems];
    }
    else
    {
        NSLog(@"A dictionary was expected at path: %@", [sender representedObject]);
    }
//NSLog(@"This is the end...");
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  saveAsTemplate:
- (void)saveAsTemplate:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 03/10/2002
To Do List: ...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSSavePanel * SP = [NSSavePanel savePanel];
    [SP setPrompt:NSLocalizedStringFromTableInBundle(@"Save RE Find Template:",
                        @"iTM2AREFinder", myBUNDLE, "Save panel prompt")];
    [SP setTitle:NSLocalizedStringFromTableInBundle(@"iTeXMac2 Regular Expression Template",
                        @"iTM2AREFinder", myBUNDLE, "Save panel title")];
    [SP setRequiredFileType:@"dict"];
    [SP setTreatsFilePackagesAsDirectories:NO];
    [SP setExtensionHidden:YES];
    NSString * UDFN = [NSBundle pathForSupportDirectory:iTM2AREFolderName inDomain:NSUserDomainMask withName:[[NSBundle mainBundle] bundleName] create:YES];// HERE to use the create side effect
    NSString * path = [SUD stringForKey:iTM2UDARESaveFolderKey];
    if(![path length])
        path = UDFN;
    if(![path length])
        path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]? :NSHomeDirectory();
    [SP beginSheetForDirectory:path
        file: @""
            modalForWindow: [[self windowController] window]
                modalDelegate: self
                    didEndSelector: @selector(savePanelDidEnd:returnCode:contextInfo:)
                        contextInfo: [SUD stringForKey:@"NSDefaultOpenDirectory"]];
//NSLog(@"file name: %@", [SP filename]);
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  savePanelDidEnd:returnCode:
- (void)savePanelDidEnd:(NSSavePanel *)SP returnCode:(int)returnCode contextInfo:(NSString *)defaultOpenDirectory;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 03/10/2002
To Do List: ...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    BOOL isDirectory;
    if([DFM fileExistsAtPath:defaultOpenDirectory isDirectory:&isDirectory] && isDirectory)
        [SUD setObject:defaultOpenDirectory forKey:@"NSDefaultOpenDirectory"];
    if(returnCode == NSOKButton)
    {
        NSString * path = [SP filename];
        NSString * folder = [path stringByDeletingLastPathComponent];
        if([DFM isWritableFileAtPath:folder])
        {
            [SUD setObject:folder forKey:iTM2UDARESaveFolderKey];
            NSMutableDictionary * MD = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                [NSNumber numberWithInt:_FindMode], iTM2AREFindModeKey,
                [NSNumber numberWithInt:_ReplaceMode], iTM2AREReplaceModeKey,
                [NSNumber numberWithInt:_Options], iTM2AREOptionsKey,
                [NSNumber numberWithInt:_FindRange], iTM2AREFindRangeKey,
                nil];
            NSMutableDictionary * md = [NSMutableDictionary dictionary];
            // let's code for the find RE
            NSRange SR = [findTextView selectedRange];
            NSString * S = [findTextView string];
            NSString * s = [S substringWithRange:NSMakeRange(0, SR.location)];
            if([s length])
                [md setObject:s forKey:@"before"];
            s = [S substringWithRange:SR];
            if([s length])
                [md setObject:s forKey:@"selected"];
            SR.location = NSMaxRange(SR);
            SR.length = [S length] - SR.location;
            s = [S substringWithRange:SR];
            if([s length])
                [md setObject:s forKey:@"after"];
            if([md count])
                [MD setObject:md forKey:iTM2AREFindKey];
            // let's archive the replace string
            md = [NSMutableDictionary dictionary];
            SR = [replaceTextView selectedRange];
            S = [replaceTextView string];
            s = [S substringWithRange:NSMakeRange(0, SR.location)];
            if([s length])
                [md setObject:s forKey:@"before"];
            s = [S substringWithRange:SR];
            if([s length])
                [md setObject:s forKey:@"selected"];
            SR.location = NSMaxRange(SR);
            SR.length = [S length] - SR.location;
            s = [S substringWithRange:SR];
            if([s length])
                [md setObject:s forKey:@"after"];
            if([md count])
                [MD setObject:md forKey:iTM2AREReplaceKey];
            
            if(![MD writeToFile:path atomically:YES])
                NSBeginAlertSheet(
                    NSLocalizedStringFromTableInBundle(@"Write error", @"iTM2AREFinder", myBUNDLE, nil),
                    nil, nil, nil, nil, nil, NULL, NULL, nil,//(void *) TS,
                    NSLocalizedStringFromTableInBundle(@"Problem saving template at:\n%@", @"iTM2AREFinder",
                                    myBUNDLE, "Discussion"),
                    path);
            else
            {
                _DontUpdateTemplates = NO;
                [self validateUserInterfaceItems];
            }
        }
        else
            NSBeginAlertSheet(
                NSLocalizedStringFromTableInBundle(@"Unwritable destination", @"iTM2AREFinder", myBUNDLE, nil),
                nil, nil, nil, nil, nil, NULL, NULL, nil,//(void *) TS,
                NSLocalizedStringFromTableInBundle(@"You don't have permission to write at:\n%@", @"iTM2AREFinder",
                                myBUNDLE, "Discussion"),
                folder);
    }
//NSLog(@"This is the end");
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateMenuItem:
- (BOOL)validateMenuItem:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 03/10/2002
To Do List: ...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  showOptions:
- (void)showOptions:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 03/10/2002
To Do List: ...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    iTM2AREFinderOptionsInspector * inspector =
        [[[iTM2AREFinderOptionsInspector allocWithZone:[self zone]] initWithOptions:_Options] autorelease];
    int newOptions = [inspector optionsByRunningModalConfigurationSheetForWindow:[[self windowController] window]];
//NSLog(@"newOptions: %x", newOptions);
//NSLog(@"_Options: %x", _Options);
    if(newOptions != _Options)
    {
        _Options = newOptions;
        [self setRegularExpression:nil];
        [self validateUserInterfaceItems];
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  cleanTemporaryAttributes
- (void)cleanTemporaryAttributes;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 03/10/2002
To Do List: ...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSRange bigRange = NSMakeRange(0, [[_MainTextView string] length]);
    if(bigRange.length)
    {
        NSEnumerator * E = [[[[_MainTextView layoutManager] textStorage] layoutManagers] objectEnumerator];
        NSLayoutManager * LM;
        while(LM = [E nextObject])
            [LM setTemporaryAttributes:nil forCharacterRange:bigRange];
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  prepareMainTextView
- (void)prepareMainTextView;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/02/2001)
- 1.3: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSTextView * TV = (NSTextView *)[[NSApp mainWindow] firstResponder];
    if(![TV isKindOfClass:[NSTextView class]])
    {
        [self reset];// before!!!
        [[NSNotificationCenter defaultCenter]
            removeObserver: self
                name: NSTextStorageDidProcessEditingNotification
                    object: nil];
        _MainTextView = nil;    
    }
    else if([[_MainTextView layoutManager] textStorage] != [[TV layoutManager] textStorage])
    {
        [self reset];// before!!!
        [[NSNotificationCenter defaultCenter]
            removeObserver: self
                name: NSTextStorageDidProcessEditingNotification
                    object: nil];
        _MainTextView = TV;
        [[NSNotificationCenter defaultCenter]
            addObserver: self
                selector: @selector(textStorageDidProcessEditingNotified:)
                    name: NSTextStorageDidProcessEditingNotification
                        object: [[_MainTextView layoutManager] textStorage]];
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  reset
- (void)reset;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/02/2001)
- 1.3: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self replaceAllRanges:nil];
    [self cleanTemporaryAttributes];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  tagAllRanges:
- (void)tagAllRanges:(NSArray *)allRanges;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 03/10/2002
To Do List: ...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if (allRanges && ![allRanges isKindOfClass:[NSArray class]]) 
        [NSException raise:NSInvalidArgumentException format:@"%@ NSArray argument expected:got %@.",
            __iTM2_PRETTY_FUNCTION__ , allRanges];
    else
    {
        int index = 0;
        while(index <  [allRanges count])
        {
            [self tagRanges:[allRanges objectAtIndex:index] highLight:NO
                mark: ([_MarkIndexes indexOfObject:[NSNumber numberWithInt:index]]!= NSNotFound)];
            ++index;
        }
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  highlightAndScrollToVisibleFoundRangesAtIndex:
- (BOOL)highlightAndScrollToVisibleRangesAtIndex:(int)index;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 03/10/2002
To Do List: ...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSArray * aRs = [self allRanges];
    int top = [aRs count];
    if(index != _HighLightIndex)
        if(NSLocationInRange(_HighLightIndex, NSMakeRange(0, top)))
        {
            [self tagRanges:[aRs objectAtIndex:_HighLightIndex] highLight:NO
                        mark: ([_MarkIndexes indexOfObject:[NSNumber numberWithInt:_HighLightIndex]]!= NSNotFound)];
        }
    if(NSLocationInRange(index, NSMakeRange(0, top)))
    {
        NSArray * RA = [aRs objectAtIndex:index];
        if([RA isKindOfClass:[NSArray class]] && [RA count])
        {
            NSValue * V = [RA objectAtIndex:0];
            if([V isKindOfClass:[NSValue class]])
            {
                NSRange R = NSIntersectionRange(NSMakeRange(0, [[_MainTextView string] length]), [V rangeValue]);
                if(R.length)
                {
                    [_MainTextView scrollRangeToVisible:R];
                    _HighLightIndex = index;
                    [self tagRanges:RA highLight:YES
                        mark: ([_MarkIndexes indexOfObject:[NSNumber numberWithInt:index]]!= NSNotFound)];
                    return YES;
                }
            }
        }
    }
    _HighLightIndex = NSNotFound;
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  tagRanges:highLight:mark:
- (void)tagRanges:(NSArray *)ranges highLight:(BOOL)yorn mark:(BOOL)flag;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 03/10/2002
To Do List: ...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if (ranges)
    {
        if(![ranges isKindOfClass:[NSArray class]])
            [NSException raise:NSInvalidArgumentException format:@"%@ NSArray argument expected:got %@.",
                __iTM2_PRETTY_FUNCTION__, ranges];
        else if([ranges count])
        {
            NSRange bigRange = NSMakeRange(0, [[_MainTextView string] length]);
            NSEnumerator * E = [ranges objectEnumerator];
            NSValue * V = [E nextObject];
            if (![V isKindOfClass:[NSValue class]]) 
                [NSException raise:NSInvalidArgumentException format:@"%@ NSValue object expected:got %@.",
                    __iTM2_PRETTY_FUNCTION__ , V];

            NSRange lightRange = [V rangeValue];
            if((lightRange.location<0) || (NSMaxRange(lightRange)>bigRange.length))
                [NSException raise:NSInternalInconsistencyException format:
                    @"%@ valid range value expected: got %@.",
                        __iTM2_PRETTY_FUNCTION__ , V];
            if(lightRange.length)
            {
                NSMutableArray * MRA = [NSMutableArray array];
                while(V = [E nextObject])
                {
                    if (![V isKindOfClass:[NSValue class]]) 
                        [NSException raise:NSInvalidArgumentException format:
                            @"%@ NSValue object expected here too: got %@.",
                                __iTM2_PRETTY_FUNCTION__ , V];
                    else
                    {
                        NSRange r = [V rangeValue];
                        if((r.location<0) || (NSMaxRange(r)>lightRange.length))
                            [NSException raise:NSInternalInconsistencyException format:
                                @"%@ valid range value expected: got %@.",
                                    __iTM2_PRETTY_FUNCTION__ , V];
                        else
                        {
                            r.location += lightRange.location;// don't forget the offset!!!
                            [MRA addObject:[NSValue valueWithRange:r]];
                        }
                    }
                }
                if(lightRange.length)
                {
                    NSColor * C = yorn?[NSColor selectedRegularExpressionColor]:[NSColor regularExpressionColor];
                    NSDictionary * lightAttrs = flag?
                            [NSDictionary dictionaryWithObjectsAndKeys:
                                C, NSBackgroundColorAttributeName,
                                    [NSNumber numberWithInt:2], NSUnderlineStyleAttributeName, nil]:
                            [NSDictionary dictionaryWithObjectsAndKeys:
                                C,
                                    NSBackgroundColorAttributeName, nil];
                    NSDictionary * darkAttrs = [NSDictionary dictionaryWithObjectsAndKeys:
                        [C blendedColorWithFraction:0.1 ofColor:[NSColor blackColor]], NSBackgroundColorAttributeName, nil];
                    NSDictionary * otherDarkAttrs = [NSDictionary dictionaryWithObjectsAndKeys:
                        [C blendedColorWithFraction:0.2 ofColor:[NSColor blackColor]], NSBackgroundColorAttributeName, nil];
                    E = [[[[_MainTextView layoutManager] textStorage] layoutManagers] objectEnumerator];
                    NSLayoutManager * LM;
                    while(LM = [E nextObject])
                    {
                        [LM setTemporaryAttributes:lightAttrs forCharacterRange:lightRange];
                        NSEnumerator * EE = [MRA objectEnumerator];
                        while(V = [EE nextObject])
                        {
                            [LM addTemporaryAttributes:darkAttrs forCharacterRange:[V rangeValue]];
                            id swap = darkAttrs;
                            darkAttrs = otherDarkAttrs;
                            otherDarkAttrs = swap;
                        }
                    }
                }
            }
        }
    }
    else
        [NSException raise:NSInvalidArgumentException format:@"%@ Missing argument.",
            __iTM2_PRETTY_FUNCTION__];
    return;
}
@end


//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  NSWindow(ARE)
/*"Description forthcoming."*/
@implementation NSWindow(iTM2_ARE)
- (void)showAREFindPanel:(id)sender;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/02/2001)
- < 1.1: 03/10/2002
To Do List:
"*/
{
    [self postNotificationWithStatus:@""];
    [[iTM2AREFinderInspector sharedInspector] show];
    return;
}
@end

@implementation NSColor(ARE_PRIVATE)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  regularExpressionColor:
+ (NSColor *)regularExpressionColor;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/02/2001)
- < 1.1: 03/10/2002
To Do List:
"*/
{
    return [NSColor colorWithCalibratedRed:0.85 green:0.85 blue:0.94 alpha:1.0];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  selectedRegularExpressionColor:
+ (NSColor *)selectedRegularExpressionColor;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/02/2001)
- < 1.1: 03/10/2002
To Do List:
"*/
{
    return [NSColor colorWithCalibratedRed:0.95 green:0.82 blue:0.82 alpha:1.0];
}
@end

#import <iTM2Foundation/iTM2ValidationKit.h>
#import <iTM2Foundation/iTM2ARegularExpressionKit.h>
#import <iTM2Foundation/iTM2AREFinderInspectorKit.h>
#import <iTM2Foundation/iTM2AREFinderOptionsInspector_Private.h>


@implementation iTM2AREFinderOptionsInspector
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initWithOptions:
- (id)initWithOptions:(int)flags;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 01/30/2003
To Do List: ...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(self = [super initWithWindowNibName:NSStringFromClass([self class])])
    {
        _OldOptions = flags;
        _NewOptions = flags;
    }
    return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  optionsByRunningModalConfigurationSheetForWindow:
- (int)optionsByRunningModalConfigurationSheetForWindow:(NSWindow *)aWindow;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 01/30/2003
To Do List: ...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSWindow * W = [self window];
    if(W)
    {
        [self validateUserInterfaceItems];
        [NSApp beginSheet:W
                modalForWindow: aWindow
                modalDelegate: nil
                didEndSelector: nil
                contextInfo: nil];
        [NSApp runModalForWindow:W];
        // Sheet is up here.
        [NSApp endSheet:W];
        [W close];
    }
    return _OldOptions;
}
@end

@implementation iTM2AREFinderOptionsInspector(PRIVATE)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateUserInterfaceItems
- (BOOL)validateUserInterfaceItems;
/*"The argument is retained such that everything else is retained, the windowController, its content view and all the subviews.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 03/10/2002
To Do List: ...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [[[self window] contentView] validateUserInterfaceItems];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleExpanded:
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleIgnoreSubexpressions:
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleNewlineAnchor:
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleNewlineStop:
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleQuote:
#define MAKEVALIDATETOGGLE(validateToggleOption, mask)\
- (BOOL)validateToggleOption:(id)sender;\
{\
    [sender setState:(_NewOptions & mask? NSOnState:NSOffState)];\
    return YES;\
}
MAKEVALIDATETOGGLE(validateToggleExpanded, iTM2AREExpandedMask);
MAKEVALIDATETOGGLE(validateToggleIgnoreSubexpressions, iTM2AREIgnoreSubexpressionsMask);
MAKEVALIDATETOGGLE(validateToggleNewlineAnchor, iTM2AREInversePartialNewlineSensitiveMask);
MAKEVALIDATETOGGLE(validateToggleNewlineStop, iTM2AREPartialNewlineSensitiveMask);
MAKEVALIDATETOGGLE(validateToggleQuote, iTM2AREQuoteMask);
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleNewlineSensitive:
- (BOOL)validateToggleNewlineSensitive:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 01/30/2003
To Do List: ...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [[sender cell] setAllowsMixedState:YES];
    NSCellStateValue state =  (_NewOptions & iTM2AREInversePartialNewlineSensitiveMask)?
        ((_NewOptions & iTM2AREPartialNewlineSensitiveMask)? NSOnState: NSMixedState):
        ((_NewOptions & iTM2AREPartialNewlineSensitiveMask)? NSMixedState: NSOffState);
    [sender setState:state];
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleType:
- (BOOL)validateToggleType:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 01/30/2003
To Do List: ...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    int tag = (_NewOptions & iTM2AREExtendedMask)? ((_NewOptions & iTM2AREAdvancedFeatureMask)? 2: 1): 0;
    [sender selectCellWithTag:tag];
    return YES;
}
@end

@implementation iTM2AREFinderOptionsInspector(IB)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  OK:
- (IBAction)OK:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 01/30/2003
To Do List: ...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    _OldOptions = _NewOptions;
    [NSApp stopModal];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  cancel:
- (IBAction)cancel:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 01/30/2003
To Do List: ...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [NSApp stopModal];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleExpanded:
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleIgnoreSubexpressions:
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleNewlineAnchor:
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleNewlineStop:
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleQuote:
#define MAKETOGGLE(toggleOption, mask)\
- (IBAction)toggleOption:(id)sender;\
{\
    _NewOptions ^= mask;\
    [self validateUserInterfaceItems];\
    return;\
}
MAKETOGGLE(toggleExpanded, iTM2AREExpandedMask);
MAKETOGGLE(toggleIgnoreSubexpressions, iTM2AREIgnoreSubexpressionsMask);
MAKETOGGLE(toggleNewlineAnchor, iTM2AREInversePartialNewlineSensitiveMask);
MAKETOGGLE(toggleNewlineStop, iTM2AREPartialNewlineSensitiveMask);
MAKETOGGLE(toggleQuote, iTM2AREQuoteMask);
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleNewlineSensitive:
- (IBAction)toggleNewlineSensitive:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 01/30/2003
To Do List: ...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if((_NewOptions & iTM2AREInversePartialNewlineSensitiveMask) && (_NewOptions & iTM2AREPartialNewlineSensitiveMask))
    {
        _NewOptions &= ~iTM2AREInversePartialNewlineSensitiveMask;
        _NewOptions &= ~iTM2AREPartialNewlineSensitiveMask;
    }
    else
    {
        _NewOptions |= iTM2AREInversePartialNewlineSensitiveMask;
        _NewOptions |= iTM2AREPartialNewlineSensitiveMask;
    }
    [self validateUserInterfaceItems];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleType:
- (IBAction)toggleType:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 01/30/2003
To Do List: ...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    switch([[sender selectedCell] tag])
    {
        case 0:
            _NewOptions &= ~iTM2AREExtendedMask;
            _NewOptions &= ~iTM2AREAdvancedFeatureMask;
        break;
        case 1:
            _NewOptions |= iTM2AREExtendedMask;
            _NewOptions &= ~iTM2AREAdvancedFeatureMask;
        break;
        case 2:
        default:
            _NewOptions |= iTM2AREExtendedMask;
            _NewOptions |= iTM2AREAdvancedFeatureMask;
        break;
    }
    [self validateUserInterfaceItems];
    return;
}
@end

#import <iTM2Foundation/iTM2NotificationKit.h>

@interface NSMenu(iTM2AREPullDownButton)
- (void)_REAddItemsFromArray:(NSArray *)RA action:(SEL)action target:(id)T;
@end

@implementation iTM2AREPullDownButton
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  awakeFromNib:
- (void)awakeFromNib;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: ...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self setPullsDown:YES];
    [self setUpMenu];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setUpMenu;
- (void)setUpMenu;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: ...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    while([[self menu] numberOfItems]>1)
        [[self menu] removeItemAtIndex:1];
    NSString * path = [myBUNDLE pathForResource:[self resourceName] ofType:@"plist"];
//NSLog(@"[self resourceName]:%@", [self resourceName]);
//NSLog(@"path: %@", path);
    [[self menu] _REAddItemsFromArray:[NSArray arrayWithContentsOfFile:path]
        action: @selector(insertRepresentedObject:) target: self];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  resourceName
- (NSString *)resourceName;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: ...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return NSStringFromClass([self class]);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertRepresentedObject:
- (void)insertRepresentedObject:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: ...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    static NSDictionary * DRO = nil;
    if(!DRO)
    {
            NSString * path = [myBUNDLE pathForResource:@"iTM2ARERepresentedObject" ofType:@"strings"];
        DRO = [NSDictionary dictionaryWithContentsOfFile:path]?:[NSDictionary dictionary];
        [DRO retain];
//NSLog(@"path %@", path);
//NSLog(@"DRO %@", DRO);
    }
    id RO = [sender representedObject];
    if([RO isKindOfClass:[NSString class]])
    {
        id target = [self target];
        id sender = [DRO objectForKey:RO]? :RO;
        SEL selector = @selector(insertMacro:);
        if([target respondsToSelector:selector])
        {
//NSLog(@"Inserting macro");
            [target performSelector:selector withObject:sender];
            if([target isKindOfClass:[NSView class]])
                [[target window] makeFirstResponder:target];
        }
        else
        {
            selector = @selector(insertText:);
            if([target respondsToSelector:selector])
            {
//NSLog(@"Inserting text");
                [target performSelector:selector withObject:RO];
                if([target isKindOfClass:[NSView class]])
                    [[target window] makeFirstResponder:target];
            }
            else
                return;
        }
        static NSDictionary * DT = nil;
        if(!DT)
        {
                NSString * path = [myBUNDLE pathForResource:@"iTM2AREToolTip" ofType:@"strings"];
            DT = [NSDictionary dictionaryWithContentsOfFile:path]?:[NSDictionary dictionary];
            [DT retain];
//NSLog(@"path %@", path);
//NSLog(@"DT %@", DT);
        }
        id toolTip = [DT objectForKey:RO];
        if([toolTip isKindOfClass:[NSString class]] && [(NSString *)toolTip length])
            [self postNotificationWithToolTip:toolTip];
    }
    else
        iTM2Beep();
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateMenuItem:
- (BOOL)validateMenuItem:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: ...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if([sender action] == @selector(insertRepresentedObject:))
    {
        return [self target] != nil;
//        return [[[self window] firstResponder] respondsToSelector:@selector(replaceCharactersInRange:withString:)];
    }
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setAction:
- (void)setAction:(SEL)aSelector;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: ...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [super setAction:NULL];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setTarget:
- (void)setTarget:(id)argument;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: ...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [super setTarget:argument];
    if(argument && ![argument respondsToSelector:@selector(replaceCharactersInRange:withString:)])
    {
	//iTM2_START;
        NSLog(@"Bad target...");
    }
    return;
}
@end

@implementation iTM2AREReferencePullDownButton
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setUpMenu;
- (void)setUpMenu;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: ...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSMenu * M = [self menu];
    while([M numberOfItems]>1)
        [M removeItemAtIndex:1];
    id MI;
    NSString * RO;
    RO = @"Whole match";
    MI = [M addItemWithTitle:NSLocalizedStringFromTableInBundle(RO, @"iTM2AREPrettyTitle", myBUNDLE, "Human readable names...") action:@selector(insertRepresentedObject:) keyEquivalent:@""];
    [MI setTarget:self];
    [MI setRepresentedObject:RO];
    RO = @"\\1";
    MI = [M addItemWithTitle:NSLocalizedStringFromTableInBundle(RO, @"iTM2AREPrettyTitle", myBUNDLE, "Human readable names...") action:@selector(insertRepresentedObject:) keyEquivalent:@""];
    [MI setTarget:self];
    [MI setRepresentedObject:RO];
    RO = @"\\2";
    MI = [M addItemWithTitle:NSLocalizedStringFromTableInBundle(RO, @"iTM2AREPrettyTitle", myBUNDLE, "Human readable names...") action:@selector(insertRepresentedObject:) keyEquivalent:@""];
    [MI setTarget:self];
    [MI setRepresentedObject:RO];
    RO = @"\\3";
    MI = [M addItemWithTitle:NSLocalizedStringFromTableInBundle(RO, @"iTM2AREPrettyTitle", myBUNDLE, "Human readable names...") action:@selector(insertRepresentedObject:) keyEquivalent:@""];
    [MI setTarget:self];
    [MI setRepresentedObject:RO];
    RO = @"Back Reference";
    MI = [M addItemWithTitle:NSLocalizedStringFromTableInBundle(RO, @"iTM2AREPrettyTitle", myBUNDLE, "Human readable names...") action:@selector(insertRepresentedObject:) keyEquivalent:@""];
    [MI setTarget:self];
    [MI setRepresentedObject:RO];
    return;
}
@end


@implementation iTM2AREAtomPullDownButton : iTM2AREPullDownButton
@end
@implementation iTM2AREQuantifierPullDownButton : iTM2AREPullDownButton
@end
@implementation iTM2AREConstraintPullDownButton : iTM2AREPullDownButton
@end
@implementation iTM2AREFilePopUpButton : NSPopUpButton
@end

@implementation NSMenu(iTM2AREPullDownButton)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  _REAddItemsFromArray:target:
- (void)_REAddItemsFromArray:(NSArray *)RA action:(SEL)action target:(id)T;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: Thu Oct 10 2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if([RA isKindOfClass:[NSArray class]])
    {
        NSEnumerator * E = [RA objectEnumerator];
        id O = [E nextObject];
        [self setTitle:([O isKindOfClass:[NSString class]]? O:@"")];
        while(O = [E nextObject])
        {
            if([O isKindOfClass:[NSArray class]])
            {
                NSMenu * M = [[self copy] autorelease];
                while([M numberOfItems]) [M removeItemAtIndex:0];
                [M _REAddItemsFromArray:O action:action target:T];
                [self addItemWithTitle:NSLocalizedStringFromTableInBundle([M title], @"iTM2AREPrettyTitle", [[T classBundle], "Human readable names...") action:NULL keyEquivalent:@""] setSubmenu:M];
            }
            else if([O isKindOfClass:[NSString class]])
            {
                if([(NSString *)O length])
                {
                    if([O hasPrefix:@"<enabled=NO>"])
                    {
                        O = [O substringWithRange:NSMakeRange(12, [(NSString *)O length] - 12)];
                        id MI = [self addItemWithTitle:NSLocalizedStringFromTableInBundle(O, @"iTM2AREPrettyTitle", [[T classBundle], "Human readable names...")
                            action: @selector(noop:)  keyEquivalent: @""];
                        [MI setTarget:T];
                    }
                    else
                    {
//NSLog(@"O: <%@>", O);
//NSLog(@"title: O: <%@>", NSLocalizedStringFromTableInBundle(O, @"iTM2AREPrettyTitle", myBUNDLE, "Human readable names..."));
                        id MI = [self addItemWithTitle:NSLocalizedStringFromTableInBundle(O, @"iTM2AREPrettyTitle", [[T classBundle], "Human readable names...")
                            action: action  keyEquivalent: @""];
                        [MI setTarget:T];
                        [MI setRepresentedObject:O];
                    }
                }
                else
                {
                    [self addItem:[NSMenuItem separatorItem]];
                }
            }
        }
    }
    else if(RA)
        [NSException raise:NSInvalidArgumentException format:@"%@ NSArray expected:got %@",
            __iTM2_PRETTY_FUNCTION__, RA];
    return;
}
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2ARTEFinderInspectorKit


