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
static id _iTM2TextWatcherMapTable = nil;
@implementation iTM2TextWatcher
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initialize
+ (void)initialize;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: 
"*/
{
//START4iTM3;
	[super initialize];
    [SUD registerDefaults: [NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithBool:YES], iTM2UDMatchDelimiterKey,
                    nil]];
	if(!_iTM2TextWatcherMapTable)
	{
		_iTM2TextWatcherMapTable = [NSMapTable mapTableWithKeyOptions:NSMapTableZeroingWeakMemory|NSMapTableObjectPointerPersonality
														 valueOptions:NSMapTableStrongMemory];
		
		 
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
//START4iTM3;
    NSRange selectedRange = [TV selectedRange];
//LOG4iTM3(@"oldSelectedRange: %@ -> selectedRange: %@", NSStringFromRange(oldSelectedRange), NSStringFromRange(selectedRange));
    if ((selectedRange.length == ZER0) && ([[NSApp currentEvent] type] == NSKeyDown))
    {
        if((oldSelectedRange.location == selectedRange.location - 1) ||
                (oldSelectedRange.location == selectedRange.location + 1)) {
            NSInteger index = MIN(selectedRange.location, oldSelectedRange.location);
            NSString * string = [TV string];
            NSRange range = iTM3MakeRange(ZER0, string.length);
            BOOL isInRange = iTM3LocationInRange(index, range);
            unichar delimiter = isInRange? [string characterAtIndex:index]: ZER0;
            unichar left = ZER0, right = ZER0;
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
            if(isDelimiter && (index>ZER0))
            {
                BOOL isEscaped = NO;
                isDelimiter = ![string isControlAtIndex:index-1 escaped: &isEscaped] || isEscaped; 
            }
            if(isDelimiter)
            {
                NSRange R = [[TV string] groupRangeAtIndex:index beginDelimiter:left endDelimiter:right];
                if (R.location != NSNotFound)
                {
                    NSInteger matchIndex = isLeft? iTM3MaxRange(R)-1: R.location;
                    if(matchIndex != index)
                    {
                        NSLayoutManager * layoutManager = [TV layoutManager];
                        NSRange matchRange = iTM3MakeRange(matchIndex, 1);
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
						[TV.window flushWindow];
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
//START4iTM3;
	NSTextView * TV = [notification object];
	if(TV != TV.window.firstResponder)
		return;
	NSMutableDictionary * D = [_iTM2TextWatcherMapTable objectForKey:TV];
	if(!D)
	{
		D = [NSMutableDictionary dictionary];
		[_iTM2TextWatcherMapTable setObject:D forKey:TV];
		[D setObject:[NSNumber numberWithBool:[TV context4iTM3BoolForKey:iTM2UDMatchDelimiterKey domain:iTM2ContextAllDomainsMask]] forKey:iTM2UDMatchDelimiterKey];
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
	BOOL old = [self context4iTM3BoolForKey:iTM2UDMatchDelimiterKey domain:iTM2ContextAllDomainsMask];
	[self takeContext4iTM3Bool:!old forKey:iTM2UDMatchDelimiterKey domain:iTM2ContextAllDomainsMask];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleWatchDelimiter:
- (BOOL)validateToggleWatchDelimiter:(NSButton *)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2: 12/11/2005
To Do List: Change doubleClickAtIndex with a groupRangeAtIndex
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	BOOL flag = [self context4iTM3BoolForKey:iTM2UDMatchDelimiterKey domain:iTM2ContextAllDomainsMask];
	sender.state = (flag? NSOnState:NSOffState);
//END4iTM3;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  context4iTM3DidChange
- (void)context4iTM3DidChange;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: Change doubleClickAtIndex with a groupRangeAtIndex
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[_iTM2TextWatcherMapTable removeObjectForKey:self];
	[super context4iTM3DidChange];
	self.context4iTM3DidChangeComplete;
//END4iTM3;
    return;
}
@end


@implementation iTM2MainInstaller(TextWatcher)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2TextWatcherCompleteInstallation4iTM3:
+ (void)iTM2TextWatcherCompleteInstallation4iTM3;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: Change doubleClickAtIndex with a groupRangeAtIndex
"*/
{
//START4iTM3;
	[DNC addObserver:[iTM2TextWatcher class]
		selector: @selector(textViewDidChangeSelectionNotified:)
			name: NSTextViewDidChangeSelectionNotification
				object: nil];
	MILESTONE4iTM3(@"iTM2TextWatcher",(@"!!!   No delimiter watching available, report BUG"));
    return;
}
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2TextWatcher
