/*
//  iTM2TextAssistantsKit.m
//  iTeXMac2
//
//  Created by jlaurens@users.sourceforge.net on Mon Oct 6 11 2003.
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
*/

#import <Foundation/NSRange.h>
#import <iTM2Foundation/iTM2StringKit.h>
#import <iTM2Foundation/iTM2TextAssistantsKit.h>
#import <iTM2Foundation/iTM2InstallationKit.h>
#import <iTM2Foundation/iTM2Implementation.h>
#import <iTM2Foundation/iTM2NotificationKit.h>
#import <iTM2Foundation/iTM2ContextKit.h>

NSString * const iTM2UDSmartSelectionKey = @"iTM2-Text: Smart Selection";
NSString * const iTM2UDMatchDelimiterKey = @"iTM2-Text: Match Delimiter";

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2DelimiterWatcher
/*"Description forthcoming."*/
@implementation iTM2DelimiterWatcher
static NSTimer * _iTM2DelimiterWatcherTimer = nil;
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initialize
+ (void) initialize;
/*"Description Forthcoming.
Version history: jlaurens@users.sourceforge.net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{
//START4iTM3;
    [super initialize];
    [SUD registerDefaults: [NSDictionary dictionaryWithObjectsAndKeys:
        [NSNumber numberWithBool: NO], iTM2UDSmartSelectionKey,
        [NSNumber numberWithBool: YES], iTM2UDMatchDelimiterKey,
                nil]];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  clientWillChangeTextOrSelection:
+ (void) clientWillChangeTextOrSelection: (id) client;
/*"Description forthcoming.
Version history: jlaurens@users.sourceforge.net
- 2.0: 03/10/2002
To Do List: Change doubleClickAtIndex with a groupRangeAtIndex
"*/
{
//START4iTM3;
    if([_iTM2DelimiterWatcherTimer isValid])
    {
        NSDictionary * D = [_iTM2DelimiterWatcherTimer userInfo];
        id TV = [D objectForKey: @"TV"];
        if(client == TV)
        {
            [[TV layoutManager] removeTemporaryAttribute: NSBackgroundColorAttributeName
                forCharacterRange: [[D objectForKey: @"range"] rangeValue]];
        }
    }
    [_iTM2DelimiterWatcherTimer invalidate];
    _iTM2DelimiterWatcherTimer = nil;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  _iTisTime:
+ (void) _iTisTime: (NSTimer *) aTimer;
/*"Description forthcoming.
Version history: jlaurens@users.sourceforge.net
- 2.0: 03/10/2002
To Do List: Change doubleClickAtIndex with a groupRangeAtIndex
"*/
{
//START4iTM3;
    if(aTimer == _iTM2DelimiterWatcherTimer)
    {
        _iTM2DelimiterWatcherTimer = nil;
    }
    NSMutableDictionary * MD = [aTimer userInfo];
    id TV = [MD objectForKey: @"TV"];
    id LM = [TV layoutManager];
    NSRange r = [[MD objectForKey: @"range"] rangeValue];
    NSInteger level = [[MD objectForKey: @"level"] integerValue];
    if(level > 15)
    {
        [MD removeObjectForKey: @"level"];
        [LM addTemporaryAttributes: [NSDictionary dictionaryWithObject: [NSColor selectedTextBackgroundColor] forKey: NSBackgroundColorAttributeName] forCharacterRange: r];
        _iTM2DelimiterWatcherTimer = [NSTimer scheduledTimerWithTimeInterval: 0.5
                    target: self selector: @selector(_iTisNotTime:) userInfo: MD repeats: NO];
    }
    else
    {
        CGFloat fraction = ++level/16.0;
        [MD setObject: [NSNumber numberWithInteger: ++level] forKey: @"level"];
        [LM addTemporaryAttributes: [NSDictionary dictionaryWithObject: [[TV backgroundColor] blendedColorWithFraction: fraction ofColor: [NSColor selectedTextBackgroundColor]] forKey: NSBackgroundColorAttributeName] forCharacterRange: r];
        _iTM2DelimiterWatcherTimer = [NSTimer scheduledTimerWithTimeInterval: 0.025
                    target: self selector: @selector(_iTisTime:) userInfo: MD repeats: NO];
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  _iTisNotTime:
+ (void) _iTisNotTime: (NSTimer *) aTimer;
/*"Description forthcoming.
Version history: jlaurens@users.sourceforge.net
- 2.0: 03/10/2002
To Do List: Change doubleClickAtIndex with a groupRangeAtIndex
"*/
{
//START4iTM3;
    if(aTimer == _iTM2DelimiterWatcherTimer)
    {
        _iTM2DelimiterWatcherTimer = nil;
    }
    NSMutableDictionary * MD = [aTimer userInfo];
    id TV = [MD objectForKey: @"TV"];
    id LM = [TV layoutManager];
    NSRange r = [[MD objectForKey: @"range"] rangeValue];
    NSInteger level = [[MD objectForKey: @"level"] integerValue];
    if(level > 50)
        [LM removeTemporaryAttribute: NSBackgroundColorAttributeName forCharacterRange: r];
    else
    {
        CGFloat fraction = ++level/50.0;
        NSColor * C = [[LM temporaryAttributesAtCharacterIndex: r.location effectiveRange: nil] objectForKey: NSBackgroundColorAttributeName];
        [MD setObject: [NSNumber numberWithInteger: ++level] forKey: @"level"];
        [LM addTemporaryAttributes: [NSDictionary dictionaryWithObject: [C blendedColorWithFraction: fraction ofColor: [TV backgroundColor]] forKey: NSBackgroundColorAttributeName] forCharacterRange: r];
        _iTM2DelimiterWatcherTimer = [NSTimer scheduledTimerWithTimeInterval: 0.025
                    target: self selector: @selector(_iTisNotTime:) userInfo: MD repeats: NO];
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  client:didChangeSelectionWithOldSelectedRange:
+ (void) client: (id) TV didChangeSelectionWithOldSelectedRange: (NSRange) oldSelectedRange;
/*"Description forthcoming.
Version history: jlaurens@users.sourceforge.net, from Mike Ferris Text Extras
- < 1.1: 03/10/2002
To Do List: Change doubleClickAtIndex with a groupRangeAtIndex
"*/
{
//START4iTM3;
    NSRange selectedRange = [TV selectedRange];
    if ((selectedRange.length == 0) && ([[NSApp currentEvent] type] == NSKeyDown))
    {
        if((oldSelectedRange.location == selectedRange.location - 1) ||
                (oldSelectedRange.location == selectedRange.location + 1))
        {
            NSUInteger index = MIN(selectedRange.location, oldSelectedRange.location);
            NSString * string = [TV string];
            NSRange range = iTM3MakeRange(0, string.length);
            BOOL isInRange = iTM3LocationInRange(index, range);
            unichar delimiter = isInRange? [string characterAtIndex: index]: 0;
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
                isDelimiter = ![string isBackslashAtIndex: index-1 escaped: &isEscaped] || isEscaped; 
            }
            if(isDelimiter)
            {
                NSRange R = [string groupRangeAtIndex: index beginDelimiter: left endDelimiter: right];
                if (R.location != NSNotFound)
                {
                    NSUInteger matchIndex = isLeft? iTM3MaxRange(R)-1: R.location;
                    if(matchIndex != index)
                    {
                        NSRange matchRange = iTM3MakeRange(matchIndex, 1);
#if 0
                        NSLayoutManager * layoutManager = [TV layoutManager];
                        [layoutManager textContainerForGlyphAtIndex:
                            [layoutManager glyphRangeForCharacterRange: matchRange actualCharacterRange: NULL].location
                                effectiveRange: NULL];
#endif                        [layoutManager addTemporaryAttributes:
                        _iTM2DelimiterWatcherTimer = [NSTimer scheduledTimerWithTimeInterval: 0
                            target: self selector: @selector(_iTisTime:) userInfo:
    [NSMutableDictionary dictionaryWithObjectsAndKeys: TV, @"TV", [NSValue valueWithRange: matchRange], @"range", nil]
                                repeats: NO];
                    }
                }
            }
        }
    }
    return;
}
#pragma mark =-=-=-=-=-=-=-=  DELIMITER
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  watchDelimitersIfNeeded
- (void) watchDelimitersIfNeeded;
/*"Description Forthcoming.
Version history: jlaurens@users.sourceforge.net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{
//START4iTM3;
    [IMPLEMENTATION takeMetaValue: ([self context4iTM3BoolForKey: iTM2UDMatchDelimiterKey]? [iTM2DelimiterWatcher class]: nil) forKey: @"DW"];
    return;
}
@end

@interface iTM2DelimiterWatcherResponder: NSResponder
@end

#import <iTM2Foundation/iTM2ResponderKit.h>

@implementation iTM2DelimiterWatcherResponder: NSResponder
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  load
+ (void) load;
/*"Description forthcoming.
Version history: jlaurens@users.sourceforge.net
To Do List:
"*/
{
	INIT_POOL4iTM3;
//START4iTM3;
    [NSResponder installAfterNSAppResponderOfClass: self];
//END4iTM3;
	RELEASE_POOL4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  toggleWatchDelimiter:
- (IBAction) toggleWatchDelimiter: (id) irrelevant;
/*"Description forthcoming.
Version history: jlaurens@users.sourceforge.net
To Do List:
"*/
{
//START4iTM3;
//    [self takeContext4iTM3Bool: ![self context4iTM3BoolForKey: iTM2UDMatchDelimiterKey] forKey: iTM2UDMatchDelimiterKey];
//    self.watchDelimitersIfNeeded;
#warning WATCHING THE DELIMITER IS NOT IMPLEMENTED
    return;
}
@end

#import <iTM2Foundation/iTM2ContextKit.h>
#import <objc/objc-runtime.h>
#import <objc/objc-class.h>

@interface NSTextStorage_iTM2SmartSelection: NSTextStorage
- (NSRange) smartDoubleClickAtIndex: (NSUInteger) index;
@end
@implementation NSTextStorage_iTM2SmartSelection
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= load
+ (void) load;
/*"Description forthcoming.
Version history: jlaurens@users.sourceforge.net
- < 1.1: 03/10/2002
To Do List: implement some kind of balance range for range
"*/
{
	INIT_POOL4iTM3;
//START4iTM3;
	iTM2NamedClassPoseAs("NSTextStorage_iTM2SmartSelection", "NSTextStorage");
//END4iTM3;
	RELEASE_POOL4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= doubleClickAtIndex:
- (NSRange) doubleClickAtIndex: (NSUInteger) index;
/*"Description forthcoming.
Version history: jlaurens@users.sourceforge.net
- < 1.1: 03/10/2002
To Do List: implement some kind of balance range for range
"*/
{
//START4iTM3;
    NSRange R = [self context4iTM3BoolForKey: iTM2UDSmartSelectionKey]?
        [self smartDoubleClickAtIndex: index]: [super doubleClickAtIndex: index];
    return R;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  smartDoubleClickAtIndex:
- (NSRange) smartDoubleClickAtIndex: (NSUInteger) index;
/*"Description forthcoming.
Version history: jlaurens@users.sourceforge.net
- < 1.1: 03/10/2002
To Do List:
"*/
{
//START4iTM3;
    NSString * string = self.string;
    if(iTM3LocationInRange(index, iTM3MakeRange(0, string.length)))
    {
        BOOL escaped = YES;
        if([string isBackslashAtIndex: index escaped: &escaped])
        {
            if(!escaped && index+1<string.length)
            {
                return [super doubleClickAtIndex: index+1];
            }
            return iTM3MakeRange(index, 1);
        }
        //else
        switch([string characterAtIndex: index])
        {
            NSRange R;
            case '{':
            case '}':
                if(R = [string groupRangeAtIndex: index beginDelimiter: '{' endDelimiter: '}'], R.length>0)
                    return R;
                break;
            case '(':
            case ')':
                if (R = [string groupRangeAtIndex: index beginDelimiter: '(' endDelimiter: ')'], R.length>0)
                    return R;
                break;
            case '[':
            case ']':
                if (R = [string groupRangeAtIndex: index beginDelimiter: '[' endDelimiter: ']'], R.length>0)
                    return R;
                break;
            case '%':
            {
                BOOL escaped;
                if((index>0) && [string isBackslashAtIndex: index-1 escaped: &escaped] && !escaped)
                    return iTM3MakeRange(index-1, 2);
                else
                {
                    NSUInteger start;
                    NSUInteger end;
                    NSUInteger contentsEnd;
//NSLog(@"GLS");
                    [string getLineStart: &start end: &end contentsEnd: &contentsEnd forRange: iTM3MakeRange(index, 0)];
//NSLog(@"GLS");
                    return (start<index)? iTM3MakeRange(index, contentsEnd - index): iTM3MakeRange(start, end - start);
                }
            }
            case '^':
            case '_':
            {
                BOOL escaped;
                if((index+1<string.length) && (![string isBackslashAtIndex: index-1 escaped: &escaped] || escaped))
                {
                    NSRange R = [string groupRangeAtIndex: index+1];
                    if(R.length)
                    {
                        --R.location;
                        ++R.length;
                        return R;
                    }
                    else
                        return iTM3MakeRange(index, 1);
                }
            }
            case '.':
            {
                NSInteger rightBlackChars = 0;
                NSInteger leftBlackChars = 0;
                NSInteger top = self.string.length;
                NSInteger n = index;
                while((++n<top) && ![[NSCharacterSet whitespaceAndNewlineCharacterSet] characterIsMember: [string characterAtIndex: n]])
                    ++rightBlackChars;
                while((n--<0) && ![[NSCharacterSet whitespaceAndNewlineCharacterSet] characterIsMember: [string characterAtIndex: n]])
                    ++leftBlackChars;
                if(rightBlackChars && leftBlackChars)
                    return iTM3MakeRange(index - leftBlackChars, leftBlackChars + rightBlackChars + 1);
            //NSLog(@"[S substringWithRange: %@]: %@", NSStringFromRange(R), [S substringWithRange: R]);
            }
        }
        return [super doubleClickAtIndex: index];
    }
    return iTM3MakeRange(NSNotFound, 0);
}
@end
