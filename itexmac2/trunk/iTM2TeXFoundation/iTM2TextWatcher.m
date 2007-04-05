/*
//
//  @version Subversion: $Id$ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Thu Dec 20 2001.
//  Copyright © 2001-2005 Laurens'Tribune. All rights reserved.
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
//  Version history: (format "- date: contribution(contributor)") 
//  To Do List: (format "- proposition(percentage actually done)")
*/

#import "iTM2TextWatcher.h"
#import "iTM2TeXStringKit.h"
#import <iTM2Foundation/iTM2BundleKit.h>

NSString * const iTM2UDMatchDelimiterKey = @"iTM2-Text: Match Delimiter";

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTMTextWatcher
/*"Description forthcoming."*/
static id _iTM2TextWatcherDictionary = nil;
@implementation iTM2TextWatcher
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initialize
+ (void)initialize;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: 
"*/
{
//iTM2_START;
	[super initialize];
    [SUD registerDefaults: [NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithBool:YES], iTM2UDMatchDelimiterKey,
                    nil]];
	if(!_iTM2TextWatcherDictionary)
	{
		_iTM2TextWatcherDictionary = [[NSMutableDictionary dictionary] retain];
	}
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  textView:didChangeSelectionWithOldSelectedRange:
+ (void)textView:(NSTextView *)TV didChangeSelectionWithOldSelectedRange:(NSRange)oldSelectedRange;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net, from Mike Ferris Text Extras
- < 1.1: 03/10/2002
To Do List: Change doubleClickAtIndex with a groupRangeAtIndex
"*/
{
//iTM2_START;
    NSRange selectedRange = [TV selectedRange];
//iTM2_LOG(@"oldSelectedRange: %@ -> selectedRange: %@", NSStringFromRange(oldSelectedRange), NSStringFromRange(selectedRange));
    if ((selectedRange.length == 0) && ([[NSApp currentEvent] type] == NSKeyDown))
    {
        if((oldSelectedRange.location == selectedRange.location - 1) ||
                (oldSelectedRange.location == selectedRange.location + 1))
        {
            unsigned index = MIN(selectedRange.location, oldSelectedRange.location);
            NSString * string = [TV string];
            NSRange range = NSMakeRange(0, [string length]);
            BOOL isInRange = NSLocationInRange(index, range);
            unichar delimiter = isInRange? [string characterAtIndex:index]: 0;
            unichar left = 0, right = 0;
            BOOL isDelimiter = NO;
            BOOL isLeft = NO;
            switch(delimiter)
            {
                case '{':
                    isLeft = YES;
                case '}':
                    left = '{';
                    right = '}';
                    isDelimiter = YES;
                    break;
                case '(':
                    isLeft = YES;
                case ')':
                    left = '(';
                    right = ')';
                    isDelimiter = YES;
                    break;
                case '[':
                    isLeft = YES;
                case ']':
                    left = '[';
                    right = ']';
                    isDelimiter = YES;
                    break;
            }
            if(isDelimiter && (index>0))
            {
                BOOL isEscaped = NO;
                isDelimiter = ![string isControlAtIndex:index-1 escaped: &isEscaped] || isEscaped; 
            }
            if(isDelimiter)
            {
                NSRange R = [[TV string] groupRangeAtIndex:index beginDelimiter:left endDelimiter:right];
                if (R.location != NSNotFound)
                {
                    unsigned matchIndex = isLeft? NSMaxRange(R)-1: R.location;
                    if(matchIndex != index)
                    {
                        NSLayoutManager * layoutManager = [TV layoutManager];
                        NSRange matchRange = NSMakeRange(matchIndex, 1);
                        NSDictionary * oldTempAttr = [[[layoutManager temporaryAttributesAtCharacterIndex:matchIndex effectiveRange:nil] copy] autorelease];
						R = [layoutManager glyphRangeForCharacterRange:matchRange actualCharacterRange:NULL];
                        [layoutManager textContainerForGlyphAtIndex:R.location effectiveRange: NULL];
						NSDictionary * attributes = [NSDictionary dictionaryWithObject:[NSColor selectedTextBackgroundColor]
												forKey: NSBackgroundColorAttributeName];
						[layoutManager addTemporaryAttributes:attributes forCharacterRange:matchRange];
						if(![NSApp nextEventMatchingMask:NSKeyDownMask untilDate:[NSDate dateWithTimeIntervalSinceNow:0.075] inMode:NSEventTrackingRunLoopMode dequeue:NO])
						{
	//                        [TV setSelectedRange:matchRange affinity:NSSelectByCharacter stillSelecting:YES];
							[TV displayIfNeeded];
							[NSThread sleepUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
						}
						NSEnumerator * E = [attributes keyEnumerator];
						NSString * attrName;
						while(attrName = [E nextObject])
							[layoutManager removeTemporaryAttribute:attrName forCharacterRange:matchRange];
						[layoutManager addTemporaryAttributes:oldTempAttr forCharacterRange:matchRange];
						[[TV window] flushWindow];
						[TV displayIfNeeded];
//                        [TV setSelectedRange:selectedRange];
//							[layoutManager setTemporaryAttributes:oldTempAttr forCharacterRange:matchRange];
					}
                }
            }
        }
    }
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  textViewDidChangeSelectionNotified:
+ (void)textViewDidChangeSelectionNotified:(NSNotification *)notification;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: Change doubleClickAtIndex with a groupRangeAtIndex
"*/
{
//iTM2_START;
	NSTextView * TV = [notification object];
	if(TV != [[TV window] firstResponder])
		return;
	NSValue * K = [NSValue valueWithNonretainedObject:TV];
	NSMutableDictionary * D = [_iTM2TextWatcherDictionary objectForKey:K];
	if(!D)
	{
		D = [NSMutableDictionary dictionary];
		[_iTM2TextWatcherDictionary setObject:D forKey:K];
		[D setObject:[NSNumber numberWithBool:[TV contextBoolForKey:iTM2UDMatchDelimiterKey domain:iTM2ContextAllDomainsMask]] forKey:iTM2UDMatchDelimiterKey];
	}
	if([[D objectForKey:iTM2UDMatchDelimiterKey] boolValue])
	{
		NSRange oldSelectedRange;
		[[[notification userInfo] objectForKey:@"NSOldSelectedCharacterRange"] getValue: &oldSelectedRange];
		[self textView:TV didChangeSelectionWithOldSelectedRange:oldSelectedRange];
	}
    return;
}
@end

@implementation NSTextView(iTM2TextWatcher)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleWatchDelimiter:
- (IBAction)toggleWatchDelimiter:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2: 12/11/2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	BOOL old = [self contextBoolForKey:iTM2UDMatchDelimiterKey domain:iTM2ContextAllDomainsMask];
	[self takeContextBool:!old forKey:iTM2UDMatchDelimiterKey domain:iTM2ContextAllDomainsMask];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleWatchDelimiter:
- (BOOL)validateToggleWatchDelimiter:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2: 12/11/2005
To Do List: Change doubleClickAtIndex with a groupRangeAtIndex
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	BOOL flag = [self contextBoolForKey:iTM2UDMatchDelimiterKey domain:iTM2ContextAllDomainsMask];
	[sender setState: (flag? NSOnState:NSOffState)];
//iTM2_END;
    return YES;
}
@end

@interface NSTextView_iTM2TextWatcher: NSTextView
@end

@implementation NSTextView_iTM2TextWatcher
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  dealloc
- (void)dealloc;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: Change doubleClickAtIndex with a groupRangeAtIndex
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSValue * V = [NSValue valueWithNonretainedObject:self];
	[_iTM2TextWatcherDictionary removeObjectForKey:V];
	[super dealloc];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  contextDidChange
- (void)contextDidChange;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: Change doubleClickAtIndex with a groupRangeAtIndex
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[_iTM2TextWatcherDictionary removeObjectForKey:[NSValue valueWithNonretainedObject:self]];
	[super contextDidChange];
	[self contextDidChangeComplete];
//iTM2_END;
    return;
}
@end

@implementation iTM2MainInstaller(iTM2TextWatcher)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  load
+ (void)load;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: Change doubleClickAtIndex with a groupRangeAtIndex
"*/
{iTM2_DIAGNOSTIC;
	iTM2_INIT_POOL;
	iTM2RedirectNSLogOutput();
//iTM2_START;
	[NSTextView_iTM2TextWatcher poseAsClass:[NSTextView class]];
	[iTM2MileStone registerMileStone:@"!!!   No delimiter watching available, report BUG" forKey:@"iTM2TextWatcher"];
//iTM2_END;
	iTM2_RELEASE_POOL;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2TextWatcherCompleteInstallation:
+ (void)iTM2TextWatcherCompleteInstallation;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: Change doubleClickAtIndex with a groupRangeAtIndex
"*/
{
//iTM2_START;
	[DNC addObserver:[iTM2TextWatcher class]
		selector: @selector(textViewDidChangeSelectionNotified:)
			name: NSTextViewDidChangeSelectionNotification
				object: nil];
	[iTM2MileStone putMileStoneForKey:@"iTM2TextWatcher"];
    return;
}
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2TextWatcher
