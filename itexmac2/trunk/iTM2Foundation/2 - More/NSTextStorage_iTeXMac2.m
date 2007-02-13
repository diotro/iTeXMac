/*
//  NSTextStorage_iTeXMac2.m
//
//  @version Subversion: $Id$ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Mon May 27 2002.
//  Copyright © 2001-2004 Laurens'Tribune. All rights reserved.
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

//
#import <iTM2Foundation/NSTextStorage_iTeXMac2.h>
#import <iTM2Foundation/iTM2StringKit.h>
#import <iTM2Foundation/NSObject_iTeXMac2.h>

@interface NSObject(NSTextStorage_iTeXMac2)
- (NSTextView *)mainTextView;
@end

@interface NSObject(iTM2Scripting_Private)
- (NSRange)rangeValue;
- (unsigned)index;
- (unsigned)insertionIndex;
- (unsigned)intValue;
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  NSTextStorage(iTM2Selection)
/*"Description forthcoming."*/
@implementation NSTextStorage(iTeXMac2)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  invalidateCursorRects
- (void)invalidateCursorRects;
/*"Default implementation does nothing.
The focus range is the range used to insert some text in the text storage when there is no UI.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSEnumerator * E = [[self layoutManagers] objectEnumerator];
	NSLayoutManager * LM;
	while(LM = [E nextObject])
	{
		NSEnumerator * ee = [[LM textContainers] objectEnumerator];
		NSTextContainer * TC;
		while(TC = [ee nextObject])
		{
			NSTextView * TV = [TC textView];
			[[TV window] invalidateCursorRectsForView:TV];
		}
	}
//iTM2_START;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  setFocusRange:
- (void)setFocusRange:(NSRange)range;
/*"Default implementation does nothing.
The focus range is the range used to insert some text in the text storage when there is no UI.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  focusRange
- (NSRange)focusRange;
/*"Default implementation returns the range at the end.
The focus range is the range used to insert some text in the text storage when there is no UI.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return NSMakeRange([self length], 0);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  firstTextView
- (NSTextView *)firstTextView;
/*"Scans the layout managers and their text containers for the first text view with a window.
If none is found, returns the first text view if any.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSEnumerator * E = [[self layoutManagers] objectEnumerator];
    NSLayoutManager * LM;
    NSTextView * cachedTV = nil;
    while(LM = [E nextObject])
    {
        NSEnumerator * EE = [[LM textContainers] objectEnumerator];
        NSTextContainer * TC;
        while(TC = [EE nextObject])
        {
            NSTextView * TV = [TC textView];
            if([TV window])
                return TV;
            else if(!cachedTV)
                cachedTV = TV;
        }
    }
    return cachedTV;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  mainTextView
- (NSTextView *)mainTextView;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSTextView * TV = [self firstTextView];
    NSWindowController * WC = [[[self firstTextView] window] windowController];
    if([WC respondsToSelector:@selector(mainTextView)])
        return [WC mainTextView];
    else
        return TV;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  selection
- (NSTextStorage *)selection;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [[[NSTextStorage allocWithZone:[self zone]]
        initWithString: [[self string] substringWithRange:[self selectedRange]]] autorelease];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  selectedRange
- (NSRange)selectedRange;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [[self mainTextView] selectedRange];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  setSelectedRange:
- (void)setSelectedRange:(NSRange)aRange;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [[self mainTextView] setSelectedRange:aRange];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  firstSelectedIndex
- (unsigned int)firstSelectedIndex;
/*"Description forthcoming. 1 based for AppleScript.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [self selectedRange].location + 1;// beware of 0 ves 1 based numeration
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  lastSelectedIndex
- (unsigned int)lastSelectedIndex;
/*"Description forthcoming. 1 based for AppleScript.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return NSMaxRange([self selectedRange]);// beware of 0 versus 1 based numeration
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  selectedRangeSpecifier
- (NSRangeSpecifier *)selectedRangeSpecifier;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSRange R = [self selectedRange];
    return [[[NSRangeSpecifier allocWithZone:[self zone]]
        initWithContainerClassDescription : nil
            containerSpecifier: nil
                key:  @""
                    startSpecifier: [[NSIndexSpecifier allocWithZone:[self zone]] 
            initWithContainerClassDescription: nil containerSpecifier:  nil key: @"" index: R.location]
                    	endSpecifier: [[NSIndexSpecifier allocWithZone:[self zone]]
    initWithContainerClassDescription: nil containerSpecifier:  nil key: @"" index: NSMaxRange(R)-1]
                                ] autorelease];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  setSelectedRangeValue:
- (void)setSelectedRangeValue:(id)argument;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSRange R = argument? [argument evaluatedRange]:NSMakeRange(NSNotFound, 0);
    if(R.location != NSNotFound)
    {
        unsigned length = [self length];
        NSTextView * TV = [self mainTextView];
        R.location = MIN(R.location, length);
        R.length = MIN(R.length, length - R.location);
        if(TV)
        {
            [TV setSelectedRange:R];
            [[TV window] makeFirstResponder:TV];
        }
        else
            [self setFocusRange:R];
    }
    else
        NSLog(@"%@ Don't know what to do with %@.", __PRETTY_FUNCTION__, argument);
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  selectAll:
- (void)selectAll:(id)irrelevant;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self setSelectedRangeValue:[NSValue valueWithRange:NSMakeRange(0, [self length])]];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  insertText:inRangeValue:
- (void)insertText:(id)text inRangeValue:(id)rangeValue;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if([text isKindOfClass:[NSString class]])
    {
        NSTextView * TV = [self mainTextView];
        if([rangeValue respondsToSelector:@selector(rangeValue)])
            [TV setSelectedRange:[rangeValue rangeValue]];
        [TV insertText:text];
    }
    else
    {
        NSLog(@"JL, you should have raised an exception!!! (code 1515)");
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= lineNumberAtIndex:
- (unsigned int)lineNumberAtIndex:(unsigned)index;
/*"Given a range, it returns the line number of the first char of the range.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: improve the search avoiding the whole scan of the string, refer to the midle of the string or to the first visible character.
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	return [[self string] lineNumberAtIndex:index];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= length
- (unsigned int)length;
/*"Given a range, it returns the line number of the first char of the range.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: improve the search avoiding the whole scan of the string, refer to the midle of the string or to the first visible character.
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [[self string] length];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= getLineStart:end:contentsEnd:forRange:
- (void)getLineStart:(unsigned *)startPtr end:(unsigned *)lineEndPtr contentsEnd:(unsigned *)contentsEndPtr forRange:(NSRange)range;
/*"Given a range, it returns the line number of the first char of the range.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: improve the search avoiding the whole scan of the string, refer to the midle of the string or to the first visible character.
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * string = [self string];
	[string getLineStart:startPtr end:lineEndPtr contentsEnd:contentsEndPtr forRange:range];
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= getRangeForLine:
- (NSRange)getRangeForLine:(unsigned int)aLine;
/*"Given a 1 based line number, it returns the line range including the ending characters.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * string = [self string];
	return [string getRangeForLine:aLine];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= getRangeForLineRange:
- (NSRange)getRangeForLineRange:(NSRange)aLineRange;
/*"Given a line range number, it returns the range including the ending characters.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * string = [self string];
	return [string getRangeForLineRange:(NSRange)aLineRange];
}
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  NSTextStorage(iTM2Selection)

