/*
//  iTM2TextButtonKit.m
//  iTeXMac2
//
//  Created by jlaurens@users.sourceforge.net on Fri Dec 13 2002.
//  Copyright © 2004 Laurens'Tribune. All rights reserved.
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

#import <iTM2Foundation/iTM2TextButtonKit.h>
#import <iTM2Foundation/iTM2NotificationKit.h>
#import <iTM2Foundation/iTM2TextDocumentKit.h>
#import <iTM2Foundation/iTM2TextKit.h>

@interface iTM2ButtonText(PRIVATE)
- (void) scrollTaggedToVisible: (id <NSMenuItem>) sender;
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2TextButtonKit
/*"Description forthcoming."*/
@implementation iTM2ButtonText
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= initWithFrame:
- (id) initWithFrame: (NSRect) R;
/*"Private use only. Description Forthcoming.
Version history: jlaurens@users.sourceforge.net
- 2.0: Fri May 21 11:07:09 GMT 2004
To Do List:
"*/
{
//iTM2_START;
	if(self = [super initWithFrame: R])
	{
		[self setAction: @selector(action:)];
		[self setTarget: self];
		[self setMixedAction: @selector(notifyAllDelayedInvocations:)];
	}
//iTM2_END;
	return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  notifyAllDelayedInvocations:
- (void) notifyAllDelayedInvocations: (id) sender;
/*"Description forthcoming.
Version History: jlaurens@users.sourceforge.net
- < 1.1: 03/10/2002
To Do List:
"*/
{
//iTM2_START;
    [INC postNotificationName: @"iTM2TDPerformScrollIn[clude|put]ToVisible"
            object: self];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  scrollIncludeToVisible:
- (void) scrollIncludeToVisible: (id <NSMenuItem>) sender;
/*"Description forthcoming.
Version History: jlaurens@users.sourceforge.net
- < 1.1: 03/10/2002
To Do List:
"*/
{
//iTM2_START;
    [NSInvocation __delayInvocationWithTarget: self
        action: @selector(_ScrollIncludeToVisible:)
            sender: sender
                untilNotificationWithName: @"iTM2TDPerformScrollIn[clude|put]ToVisible"
                    isPostedFromObject: self];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  _ScrollIncludeToVisible:
- (void) _ScrollIncludeToVisible: (id <NSMenuItem>) sender;
/*"Description forthcoming.
Version History: jlaurens@users.sourceforge.net
- < 1.1: 03/10/2002
To Do List:
"*/
{
//iTM2_START;
    NSString * path = [[[[sender menu] title] stringByAppendingPathComponent:
                                [sender representedObject]] stringByStandardizingPath];
    if([DFM isReadableFileAtPath: path])
        [SDC openDocumentWithContentsOfFile: path display: YES];
    else
    {
        path = [path stringByAppendingPathExtension: @"tex"];
        if([DFM isReadableFileAtPath: path])
            [SDC openDocumentWithContentsOfFile: path display: YES];
        else
        {
            [sender setEnabled: NO];
            iTM2Beep();
        }
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  scrollInputToVisible:
- (void) scrollInputToVisible: (id <NSMenuItem>) sender;
/*"Description forthcoming.
Version History: jlaurens@users.sourceforge.net
- < 1.1: 03/10/2002
To Do List:
"*/
{
//iTM2_START;
    [NSInvocation __delayInvocationWithTarget: self
        action: @selector(_ScrollInputToVisible:)
            sender: sender
                untilNotificationWithName: @"iTM2TDPerformScrollIn[clude|put]ToVisible"
                    isPostedFromObject: self];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  _ScrollInputToVisible:
- (void) _ScrollInputToVisible: (id <NSMenuItem>) sender;
/*"Description forthcoming.
Version History: jlaurens@users.sourceforge.net
- < 1.1: 03/10/2002
To Do List: include the tetex path...
"*/
{
//iTM2_START;
    NSString * path = [[[[[sender menu] title]  stringByAppendingPathComponent:
                                [sender representedObject]] stringByResolvingSymlinksInPath] stringByStandardizingPath];
    if([DFM isReadableFileAtPath: path])
        [SDC openDocumentWithContentsOfFile: path display: YES];
    else
    {
        path = [path stringByAppendingPathExtension: @"tex"];
        if([DFM isReadableFileAtPath: path])
            [SDC openDocumentWithContentsOfFile: path display: YES];
        else
        {
            [sender setEnabled: NO];
            iTM2Beep();
        }
    }
    return;
}
#if 1
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  scrollTaggedToVisible:
- (void) scrollTaggedToVisible: (id <NSMenuItem>) sender;
/*"Description forthcoming.
Version History: jlaurens@users.sourceforge.net
- < 1.1: 03/10/2002
To Do List:
"*/
{
//iTM2_START;
    unsigned begin, end;
//NSLog(@"GLS");
	id TV = [[[self window] windowController] textView];
    [[TV string] getLineStart: &begin end: &end contentsEnd: nil forRange: NSMakeRange([sender tag], 0)];
    [TV highlightAndScrollToVisibleRange: NSMakeRange(begin, end-begin)];
    return;
}
#else
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  scrollTaggedToVisible:
- (void) scrollTaggedToVisible: (id <NSMenuItem>) sender;
/*"Description forthcoming.
Version History: jlaurens@users.sourceforge.net
- < 1.1: 03/10/2002
To Do List:
"*/
{
//iTM2_START;
    unsigned int location = 0;
    NSMenu * menu = [sender menu];
    int ceiling = [menu indexOfItem: sender];
    int index = 0;
    for(; index<=ceiling ; ++index)
        location += [[menu itemAtIndex: index] tag];

    unsigned begin, end;
//NSLog(@"GLS");
	id TV = [[[self window] windowController] textView]
    [[textView string] getLineStart: &begin end: &end contentsEnd: nil forRange: NSMakeRange(location, 0)];
    [textView highlightAndScrollToVisibleRange: NSMakeRange(begin, end-begin)];

    return;
}
#endif
@end

@implementation iTM2ButtonTextMark
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  action:
- (void) action: (id <NSMenuItem>) sender;
/*"Description forthcoming.
Version History: jlaurens@users.sourceforge.net
- < 1.1: 03/10/2002
To Do List:
"*/
{
//iTM2_START;
	[self scrollTaggedToVisible: sender];
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= willPopUp
- (BOOL) willPopUp;
/*"Private use only. Description Forthcoming.
Version history: jlaurens@users.sourceforge.net
- 2.0: Fri May 21 11:07:09 GMT 2004
To Do List:
"*/
{
//iTM2_START;
    int tagNumber = 0;
    BOOL isCommand;
    /*" Here again we use C strings: UTF8 are not aligned..."*/
    const char * stringPtr = [[[[[self window] windowController] textView] string] lossyCString];
    const char * scanPtr = stringPtr;
    const char * max = strchr(stringPtr,'\0');
    const char * utf8Backslash = [[NSString stringWithUTF8String: "\\"] cString];
    NSString * fileName = [[[[self window] windowController] document] fileName];
    NSString * title = fileName? [fileName stringByDeletingLastPathComponent]: [NSString string];
    NSMenu * markMenu = [[[NSMenu allocWithZone: [NSMenu menuZone]] initWithTitle: title] autorelease];
    [markMenu setMenuRepresentation: [[[NSMenuView alloc] initWithFrame: NSZeroRect] autorelease]];
    [[markMenu menuRepresentation] setFont: [NSFont menuFontOfSize: [NSFont smallSystemFontSize]]];
    [markMenu addItemWithTitle:
            NSLocalizedStringFromTableInBundle(@"Marks:", @"TeX",
				myBUNDLE, "Title of the first item of the mark menu")
                    action: NULL keyEquivalent: [NSString string]];
    [markMenu setAutoenablesItems: YES];
    while(YES)
    {
        const char * scanBackslash =  strstr(scanPtr, utf8Backslash);
        const char * scanComment = strchr(scanPtr, '%');
        while(YES)
        {
            if(!scanBackslash) scanBackslash = max;
            if(!scanComment) scanComment = max;
            if(scanComment < scanBackslash)
            {
                isCommand = NO;
                break;
            }
            else if(scanBackslash < max)
            {
                scanBackslash += strlen(utf8Backslash);
                if(scanBackslash < max)
                {
                    if (*(scanBackslash) == '%')
                    {
                        ++scanBackslash;
                        scanBackslash = strstr(scanBackslash, utf8Backslash);
                        scanComment = strchr(scanBackslash, '%');
                    }
                    else if(!strncmp(scanBackslash, utf8Backslash, strlen(utf8Backslash)))
                    {
                        scanBackslash += strlen(utf8Backslash);
                        scanBackslash = strstr(scanBackslash, utf8Backslash);
                    }
                    else
                    {
                        isCommand = YES;
                        break;
                    }
                }
                else
                {
                    isCommand = YES;
                    break;
                }
            }
            else
            {
                isCommand = YES;
                break;
            }
        }
        if(isCommand && (scanBackslash < max))
        {
            scanPtr = scanBackslash;
            if(!strncmp(scanPtr, "in", 2))
            {
                scanPtr+=2;
                if(!strncmp(scanPtr, "clude", 5))
                {
                    unsigned char bgroup = '{';//}
                    scanPtr+=5;
                    while((* scanPtr == ' ') || (* scanPtr == '\r') || (* scanPtr == '\n')) ++scanPtr;
                    if(* scanPtr == bgroup)
                    {//{
                        unsigned char egroup = '}';
                        scanPtr+=1;
                        //semi critical: read the comments here
                        scanBackslash = scanPtr;
                        scanPtr = strchr(scanPtr, egroup);
                        if(scanPtr)
                        {
                            NSString * object = [[[NSString stringWithCString: scanBackslash length: (unsigned)(scanPtr - scanBackslash)]
                                    stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]]
                                        stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString: @"{}"]];
                            NSString * title = ([object length] > 48)?
                                                    [NSString stringWithFormat: @"%@[...]",
                                                            [object substringWithRange: NSMakeRange(0,43)]]: object;
                            if([title length])
                            {
                                NSMenuItem * MI = [markMenu addItemWithTitle: title
                                                        action: @selector(scrollIncludeToVisible:)
                                                            keyEquivalent: [NSString string]];
                                [MI setTarget: self];
                                [MI setRepresentedObject: object];
                                [MI setEnabled: ([[markMenu title] length] > 0)];
                            }
                        }
                    }
                }
                else if(!strncmp(scanPtr, "put", 3))
                {
                    scanPtr+=3;
                    while((* scanPtr == ' ') || (* scanPtr == '\r') || (* scanPtr == '\n')) ++scanPtr;
                    {
                        char * SPACE = strchr(scanPtr, ' ');
                        char * CR = strchr(scanPtr, '\r');
                        char * LF = strchr(scanPtr, '\n');
                        char * end = (char *) scanPtr;
                        end = SPACE? (CR? MIN(SPACE, CR): SPACE): CR;
                        end = end? (LF? MIN(LF, end): end): (LF? LF: strchr(scanPtr, '\0'));
                        {
                            NSString * object = [[[NSString stringWithCString: scanPtr length: (unsigned)(end - scanPtr)]
                                    stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]]
                                        stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString: @"{}"]];
                            NSString * title = ([object length] > 48)?
                                                    [NSString stringWithFormat: @"%@[...]",
                                                        [object substringWithRange: NSMakeRange(0,43)]]: object;
                            if([title length])
                            {
                                NSMenuItem * MI = [markMenu addItemWithTitle: title
                                                        action: @selector(scrollInputToVisible:)
                                                            keyEquivalent: [NSString string]];
                                [MI setTarget: self];
                                [MI setRepresentedObject: object];
                                [MI setEnabled: ([[markMenu title] length] > 0)];
                            }
                        }
                    }
                }
            }
        }
        else if(scanComment < max)
        {
            scanPtr = ++scanComment;
            if((tagNumber<32))
            {
                while((* scanPtr == ' ')) ++scanPtr;
                if(!strncmp(scanPtr, "!", 1))
                {
                    scanPtr += 1;
                    while((* scanPtr == ' ')) ++scanPtr;
                    if(!strncasecmp(scanPtr, "itexmac", 7))
                    {
                        scanPtr += 7;
                        while((* scanPtr == ' ')) ++scanPtr;
                        if(!strncmp(scanPtr, "(", 1))//)
                        {
                            scanPtr += 1;
                            while((* scanPtr == ' ')) ++scanPtr;
                            if(!strncasecmp(scanPtr, "mark", 4))
                            {
                                scanPtr += 4;
                                while((* scanPtr == ' ')) ++scanPtr;//(
                                if(!strncmp(scanPtr, ")", 1))
                                {
                                    scanPtr += 1;
                                    while((* scanPtr == ' ')) ++scanPtr;
                                    if(!strncmp(scanPtr, ":", 1))
                                    {
                                        scanPtr += 1;
                                        while((* scanPtr == ' ')) ++scanPtr;
                                        {
                                            const char * CR = strchr(scanPtr, '\r');
                                            const char * LF = strchr(scanPtr, '\n');
                                            scanComment = scanPtr;
                                            scanPtr = CR? (LF? MIN(CR, LF): CR): (LF? LF: strchr(scanPtr, '\0'));
                                            {
                                                NSString * object =
                                                    [[[NSString stringWithCString: scanComment  length: (unsigned)(scanPtr - scanComment)]
                                                stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]]
                                            stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString: @"{}"]];
                                                NSString * title = ([object length] > 48)?
                                                        [NSString stringWithFormat: @"%@[...]",
                                                            [object substringWithRange: NSMakeRange(0,43)]]: object;
                                                if([title length] == 0)
                                                    title = @"...";
                                                {
                                                    NSMenuItem * MI = [markMenu addItemWithTitle: title
                                                                            action: @selector(scrollTaggedToVisible:)
                                                                                keyEquivalent: [NSString string]];
                                                    [MI setTag: scanComment - stringPtr];
                                                    [MI setRepresentedObject: object];
                                                    ++tagNumber;
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            else
            {
                const char * CR = strchr(scanPtr, '\r');
                const char * LF = strchr(scanPtr, '\n');
                scanPtr = CR? (LF? MIN(CR, LF): CR): (LF? LF: strchr(scanPtr, '\0'));
            }
        }
        else
            break;
    }
    [self setMenu: markMenu];
    [self setEnabled: YES];
//iTM2_END;
    return YES;
}
@end

@implementation iTM2ButtonTextSection
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  action:
- (void) action: (id <NSMenuItem>) sender;
/*"Description forthcoming.
Version History: jlaurens@users.sourceforge.net
- < 1.1: 03/10/2002
To Do List:
"*/
{
//iTM2_START;
	[self scrollTaggedToVisible: sender];
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= willPopUp
- (BOOL) willPopUp;
/*"Description forthcoming.
Version history: jlaurens@users.sourceforge.net
- < 1.1: 03/10/2002
To Do List:
"*/
{
//iTM2_START;
//    static unsigned int meter;
    const char * cString = [[[[[self window] windowController] textView] string] lossyCString];
    const char * scanPtr = cString;
    const char * backslashPtr;
    const char * bgroupPtr;
    const char * egroupPtr;
    char bgroup = '{';
    char egroup = '}';
    #define partDepth 1
    #define chapterDepth 2
    #define sectionDepth 3
    #define subsectionDepth 4
    #define subsubsectionDepth 5
    #define subsubsubsectionDepth 6
    #define paragraphDepth 6
    #define subparagraphDepth 7
    #define subsubparagraphDepth 8
    #define includeDepth 9
    #define inputDepth 10
    unsigned sectionCount = 0, subsectionCount = 0, subsubsectionCount = 0;
    NSString * fileName = [[[[self window] windowController] document] fileName];
    NSString * title = fileName? [fileName stringByDeletingLastPathComponent]: [NSString string];
    NSMenu * sectionMenu = [[[NSMenu allocWithZone: [NSMenu menuZone]] initWithTitle: title] autorelease];
    [sectionMenu setMenuRepresentation: [[[NSMenuView alloc] initWithFrame: NSZeroRect] autorelease]];
    [[sectionMenu menuRepresentation] setFont: [NSFont menuFontOfSize: [NSFont smallSystemFontSize]]];
    [sectionMenu addItemWithTitle:
            NSLocalizedStringFromTableInBundle(@"Sections:", @"TeX",
                            myBUNDLE, "Title of the first item of the section menu")
                    action: NULL keyEquivalent: [NSString string]];
//    NSLog(@"validateSectionButton: index error = %d", indexError);
    while(backslashPtr = strchr(scanPtr, '\\'))
    {
        int depth = 0;
        scanPtr = backslashPtr + 1;
        if(*scanPtr == 's')
        {
            ++scanPtr;
            if(!strncmp(scanPtr, "ection", 6))
            {
                scanPtr+=6;
                depth = sectionDepth;
            }
            else if(!strncmp(scanPtr, "ub", 2))
            {
                scanPtr+=2;
                if(!strncmp(scanPtr, "section", 7))
                {
                    scanPtr+=7;
                    depth = subsectionDepth;
                }
                else if(!strncmp(scanPtr, "paragraph", 9))
                {
                    scanPtr+=9;
                    depth = subparagraphDepth;
                }
                else if(!strncmp(scanPtr, "sub", 3))
                {
                    scanPtr+=3;
                    if(!strncmp(scanPtr, "section", 7))
                    {
                        scanPtr+=7;
                        depth = subsubsectionDepth;
                    }
                    else if(!strncmp(scanPtr, "paragraph", 9))
                    {
                        scanPtr+=9;
                        depth = subsubparagraphDepth;
                    }
                    else if(!strncmp(scanPtr, "subsection", 10))
                    {
                        scanPtr+=10;
                        depth = subsubsubsectionDepth;
                    }
                }
            }
        }
        else if(!strncmp(scanPtr, "chapter", 7))
        {
            scanPtr+=7;
            depth = chapterDepth;
        }
        else if(!strncmp(scanPtr, "par", 3))
        {
            scanPtr+=3;
            if(*scanPtr == 't')
            {
                ++scanPtr;
                depth = partDepth;
            }
            else if(!strncmp(scanPtr, "agraph", 6))
            {
                scanPtr+=6;
                depth = paragraphDepth;
            }
        }
        else if(!strncmp(scanPtr, "in", 2))
        {
            scanPtr+=2;
            if(!strncmp(scanPtr, "clude", 5))
            {
                scanPtr+=5;
                depth = includeDepth;
            }
            else if(!strncmp(scanPtr, "put", 3))
            {
                scanPtr+=3;
                depth = inputDepth;
            }
        }
        if(depth)
        {
            NSString * title = nil;
            NSString * object = nil;
            NSMenuItem * MI = [[[NSMenuItem allocWithZone: [NSMenu menuZone]] init] autorelease];
            while((* scanPtr == ' ') || (* scanPtr == '\r') || (* scanPtr == '\n')) ++scanPtr;
//            char openBracket = '[', closeBracket = ']';
            if(inputDepth == depth)
            {
                char * l1, * l2, * l3;
                l1 = strchr(scanPtr, ' ');
                l2 = strchr(scanPtr, '\r');
                l3 = l1? (l2? MIN(l1, l2): l1): l2;
                l2 = strchr(scanPtr, '\n');
                l1 = l3? (l2? MIN(l3, l2): l3): (l2? l2: strchr(scanPtr, '\0'));
                object = [NSString stringWithCString: scanPtr length:(unsigned)(l1-scanPtr)];
                [MI setAction: @selector(scrollInputToVisible:)];
                [MI setEnabled: ([[sectionMenu title] length] > 0)];
            }
            else if((bgroupPtr = strchr(scanPtr, bgroup)) && (egroupPtr = strchr(bgroupPtr, egroup)))
            {
                object = [NSString stringWithCString: bgroupPtr length:(unsigned)(egroupPtr-bgroupPtr)];
                [MI setAction: (depth == includeDepth? @selector(scrollIncludeToVisible:):
                    @selector(scrollTaggedToVisible:))];
                [MI setEnabled: ([[sectionMenu title] length] > 0)];
            }
            object = [[object stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]]
                        stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString: @"{}"]];
            if([object length])
            {
                switch(depth)
                {
                    case partDepth:
                    case chapterDepth:
                        sectionCount = subsectionCount = subsubsectionCount = 0;
                    default:
                        title = object;
                        break;
                    case sectionDepth:
                        title = [NSString stringWithFormat: @"%d. %@", ++sectionCount, object];
                        subsectionCount = subsubsectionCount = 0;
                        break;
                    case subsectionDepth:
                        title = [NSString stringWithFormat: @"%d.%c. %@", sectionCount, ++subsectionCount+'a'-1, object];
                        subsubsectionCount = 0;
                        break;
                    case subsubsectionDepth:
                        title = [NSString stringWithFormat: @"%d.%c.%d. %@",
                                                    sectionCount, subsectionCount+'a'-1, ++subsubsectionCount, object];
                        break;
                    case paragraphDepth:
                        title = [NSString stringWithFormat: @"...%@", object];
                        break;
                    case subparagraphDepth:
                        title = [NSString stringWithFormat: @"....%@", object];
                        break;
                    case subsubparagraphDepth:
                        title = [NSString stringWithFormat: @".....%@", object];
                        break;
                }
                if([title length] > 48)
                    title = [NSString stringWithFormat: @"%@[...]", [title substringWithRange: NSMakeRange(0,43)]];
                if([title length])
                {
                    [MI setTitle: title];
                    [MI setRepresentedObject: object];
                    [MI setTag: backslashPtr - cString];
                    [MI setTarget: self];
                    [sectionMenu addItem: MI];
                }
                else if(title)
                    iTM2Beep();
            }
            else if(title)
                iTM2Beep();
        }
        #if 0
        if(((unsigned)scanPtr)/1000 > meter)
        {
            meter = ((unsigned)scanPtr)/1000;
            NSLog(@"meter: %d", meter);
        }
        #endif
    }
    [self setMenu: sectionMenu];
    [self setEnabled: YES];
//iTM2_END;
    return [super willPopUp];
}
@end

#import <iTM2Foundation/iTM2LiteScanner.h>

@implementation iTM2ButtonTextLabel
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  action:
- (void) action: (id <NSMenuItem>) sender;
/*"Description forthcoming.
Version History: jlaurens@users.sourceforge.net
- < 1.1: 03/10/2002
To Do List:
"*/
{
//iTM2_START;
    unsigned modifierFlags = [[NSApp currentEvent] modifierFlags];
    if(modifierFlags & NSAlternateKeyMask)
    {
		id textView = [[[self window] windowController] textView];
        iTM2LiteScanner * S = [iTM2LiteScanner scannerWithString: [textView string]];
        NSString * string;
        [S setCharactersToBeSkipped: nil];
        [S setScanLocation: [sender tag]];
        if([S scanUpToString: //{
            @"}" intoString: &string])
            [textView insertText: [NSString stringWithFormat: @"\\%@ref%@}",
                ((modifierFlags & NSShiftKeyMask)? @"eq": @""), string]];
    }
    else
        [self scrollTaggedToVisible: sender];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= willPopUp
- (BOOL) willPopUp;
/*"Private use only. Description Forthcoming.
Version history: jlaurens@users.sourceforge.net
- 2.0: Fri May 21 11:07:09 GMT 2004
To Do List:
"*/
{
//iTM2_START;
//iTM2_START;
    int countL = 0;
    int countR = 0;
    BOOL isCommand;
    /*" We use C strings. With UTF8 strings, we should manage shifts. "*/
    const char * stringPtr = [[[[[self window] windowController] textView] string] lossyCString];
    const char * scanPtr = stringPtr;
    const char * max = strchr(stringPtr, '\0');
    const char * utf8Backslash = [[NSString stringWithUTF8String: "\\"] cString];
    NSString * fileName = [[[[self window] windowController] document] fileName];
    NSString * title = fileName? [fileName stringByDeletingLastPathComponent]: [NSString string];
    NSMenu * labelMenu = [[[NSMenu allocWithZone: [NSMenu menuZone]] initWithTitle: title] autorelease];
    NSMenu * refMenu = [[[NSMenu allocWithZone: [NSMenu menuZone]] initWithTitle: [NSString string]] autorelease];

    [labelMenu setMenuRepresentation: [[[NSMenuView alloc] initWithFrame: NSZeroRect] autorelease]];
    [[labelMenu menuRepresentation] setFont: [NSFont menuFontOfSize: [NSFont smallSystemFontSize]]];
    [labelMenu addItemWithTitle:
            NSLocalizedStringFromTableInBundle(@"Labels:", @"TeX",
                            myBUNDLE, "Title of the first item of the labels menu")
                    action: NULL keyEquivalent: [NSString string]];
    [labelMenu setAutoenablesItems: NO];

    [refMenu setMenuRepresentation: [[[NSMenuView alloc] initWithFrame: NSZeroRect] autorelease]];
    [[refMenu menuRepresentation] setFont: [NSFont menuFontOfSize: [NSFont smallSystemFontSize]]];
    [refMenu setAutoenablesItems: NO];

    while(YES)
    {
        const char * scanBackslash =  strstr(scanPtr, utf8Backslash);
        const char * scanComment = strchr(scanPtr, '%');
        while(YES)
        {
            if(!scanBackslash) scanBackslash = max;
            if(!scanComment) scanComment = max;
            if(scanComment < scanBackslash)
            {
                isCommand = NO;
                break;
            }
            else if(scanBackslash < max)
            {
                scanBackslash += strlen(utf8Backslash);
                if (*(scanBackslash) == '%')
                {
                    ++scanBackslash;
                    scanBackslash = strstr(scanBackslash, utf8Backslash);
                    scanComment = strchr(scanBackslash, '%');
                }
                else if(!strncmp(scanBackslash, utf8Backslash, strlen(utf8Backslash)))
                {
                    scanBackslash += strlen(utf8Backslash);
                    scanBackslash = strstr(scanBackslash, utf8Backslash);
                }
                else
                {
                    isCommand = YES;
                    break;
                }
            }
            else
            {
                isCommand = YES;
                break;
            }
        }
        if(isCommand && (scanBackslash < max))
        {
            scanPtr = scanBackslash;
            if(!strncmp(scanPtr, "in", 2))
            {
                scanPtr+=2;
                if(!strncmp(scanPtr, "clude", 5))
                {
                    unsigned char bgroup = '{';//}
                    scanPtr+=5;
                    while((* scanPtr == ' ') || (* scanPtr == '\r') || (* scanPtr == '\n')) ++scanPtr;
                    if(* scanPtr == bgroup)
                    {//{
                        unsigned char egroup = '}';
                        scanPtr+=1;
                        //semi critical: read the comments here
                        scanBackslash = scanPtr;
                        scanPtr = strchr(scanPtr, egroup);
                        if(scanPtr)
                        {
                            NSString *  object = [[[NSString stringWithCString: scanBackslash length: (unsigned)(scanPtr - scanBackslash)]
                                        stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]]
                                        stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString: @"{}"]];
                            NSString * title = ([object length] > 48)?
                                                    [NSString stringWithFormat: @"%@[...]",
                                                            [object substringWithRange: NSMakeRange(0,43)]]: object;
                            if([title length])
                            {
                                NSMenuItem * MI = [labelMenu addItemWithTitle: title
                                                        action: @selector(scrollIncludeToVisible:)
                                                            keyEquivalent: [NSString string]];
                                [MI setTarget: self];
                                [MI setRepresentedObject: object];
                                [MI setEnabled: ([[labelMenu title] length] > 0)];
                            }
                        }
                    }
                }
                else if(!strncmp(scanPtr, "put", 3))
                {
                    scanPtr+=3;
                    // scans all the white chars
                    while((* scanPtr == ' ') || (* scanPtr == '\r') || (* scanPtr == '\n')) ++scanPtr;
                    // now scanPtr points to something else
                    {
                        // SPACE points to the first space
                        const char * SPACE = strchr(scanPtr, ' ');
                        // SPACE points to the first return
                        const char * CR = strchr(scanPtr, '\r');
                        // SPACE points to the first newline
                        const char * LF = strchr(scanPtr, '\n');
                        // scanPtr points to the first non white char
                        char * end = (char *)scanPtr;
                        // end will point to the first white char
                        // the min between SPACE and CR, excluding 0!!!
                        end = (char *)(SPACE? (CR? MIN(SPACE, CR): SPACE): CR);
                        end = (char *)(end? (LF? MIN(LF, end): end): (LF? LF: strchr(scanPtr, '\0')));
                        {
                            NSString * object = [[[NSString stringWithCString: scanPtr length: (unsigned)(end - scanPtr)]
                                    stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]]
                                        stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString: @"{}"]];
                            NSString * title = ([object length] > 48)?
                                                    [NSString stringWithFormat: @"%@[...]",
                                                        [object substringWithRange: NSMakeRange(0,43)]]: object;
                            if([title length])
                            {
                                NSMenuItem * MI = [labelMenu addItemWithTitle: title
                                                        action: @selector(scrollInputToVisible:)
                                                            keyEquivalent: [NSString string]];
                                [MI setTarget: self];
                                [MI setRepresentedObject: object];
                                [MI setEnabled: ([[labelMenu title] length] > 0)];
                            }
                        }
                    }
                }
            }
            else if(!strncmp(scanPtr, "label", 5))
            {
                unsigned char bgroup = '{';//}
                scanPtr+=5;
                while((* scanPtr == ' ') || (* scanPtr == '\r') || (* scanPtr == '\n')) ++scanPtr;
                if(* scanPtr == bgroup)
                {//{
                    unsigned char egroup = '}';
                    const char * tag = scanPtr;
                    scanPtr+=1;
                    //semi critical: read the comments here
                    scanBackslash = scanPtr;
                    scanPtr = strchr(scanPtr, egroup);
                    if(scanPtr)
                    {
                        NSString * object = [[[NSString stringWithCString: scanBackslash length: (unsigned)(scanPtr - scanBackslash)]
                                stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]]
                                    stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString: @"{}"]];
                        NSString * title = ([object length] > 41)?
                                                [NSString stringWithFormat: @"%@[...]",
                                                        [object substringWithRange: NSMakeRange(0,36)]]: object;
                        if([title length])
                        {
                            NSMenuItem * MI = [labelMenu addItemWithTitle:
                                                [NSString stringWithFormat: @"%4d %@", countL++, title]
                                                    action: @selector(scrollLabelToVisible:)
                                                        keyEquivalent: [NSString string]];
                            [MI setTarget: self];
                            [MI setTag: (tag - stringPtr)];
                            [MI setRepresentedObject: object];
                            [MI setEnabled: ([[labelMenu title] length] > 0)];
                        }
                    }
                }
            }
            else if(!strncmp(scanPtr, "ref", 3))
            {
                unsigned char bgroup = '{';//}
                scanPtr+=3;
                while((* scanPtr == ' ') || (* scanPtr == '\r') || (* scanPtr == '\n')) ++scanPtr;
                if(* scanPtr == bgroup)
                {//{
                    unsigned char egroup = '}';
                    scanPtr+=1;
                    //semi critical: read the comments here
                    scanBackslash = scanPtr;
                    scanPtr = strchr(scanPtr, egroup);
                    if(scanPtr)
                    {
                        NSString * object = [[[NSString stringWithCString: scanBackslash length: (unsigned)(scanPtr - scanBackslash)]
                                stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]]
                                    stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString: @"{}"]];
                        NSString * title = ([object length] > 43)?
                                                [NSString stringWithFormat: @"%@[...]",
                                                        [object substringWithRange: NSMakeRange(0,38)]]: object;
                        if([title length])
                        {
                            NSMenuItem * MI = [refMenu addItemWithTitle:
                                                    [NSString stringWithFormat: @"%4d %@", countR++, title]
                                                        action: @selector(scrollTaggedToVisible:)
                                                            keyEquivalent: [NSString string]];
                            [MI setTarget: self];
                            [MI setTag: scanBackslash - stringPtr];
                            [MI setRepresentedObject: object];
                            [MI setEnabled: ([[labelMenu title] length] > 0)];
                        }
                    }
                }
            }
            else if(!strncmp(scanPtr, "eqref", 5))
            {
                unsigned char bgroup = '{';//}
                scanPtr+=5;
                while((* scanPtr == ' ') || (* scanPtr == '\r') || (* scanPtr == '\n')) ++scanPtr;
                if(* scanPtr == bgroup)
                {//{
                    unsigned char egroup = '}';
                    scanPtr+=1;
                    //semi critical: read the comments here
                    scanBackslash = scanPtr;
                    scanPtr = strchr(scanPtr, egroup);
                    if(scanPtr)
                    {
                        NSString * object = [[[NSString stringWithCString: scanBackslash length: (unsigned)(scanPtr - scanBackslash)]
                                    stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]]
                                        stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString: @"{}"]];
                        NSString * title = ([object length] > 41)?
                                                [NSString stringWithFormat: @"%@[...]",
                                                        [object substringWithRange: NSMakeRange(0,36)]]: object;
                        if([title length])
                        {
                            NSMenuItem * MI = [refMenu addItemWithTitle:
                                                    [NSString stringWithFormat: @"%4d %@ (eq)", countR++, title]
                                                        action: @selector(scrollTaggedToVisible:)
                                                            keyEquivalent: [NSString string]];
                            [MI setTarget: self];
                            [MI setTag: scanBackslash - stringPtr];
                            [MI setRepresentedObject: object];
                            [MI setEnabled: ([[labelMenu title] length] > 0)];
                        }
                    }
                }
            }
        }
        else if(scanComment < max)
        {
            scanPtr = ++scanComment;
            {
                const char * CR = strchr(scanPtr, '\r');
                const char * LF = strchr(scanPtr, '\n');
                scanPtr = CR? (LF? MIN(CR, LF): CR): (LF? LF: strchr(scanPtr, '\0'));
            }
        }
        else
            break;
    }
    {
        NSMenuItem * MI = [labelMenu insertItemWithTitle: @"ref" action: NULL keyEquivalent: [NSString string] atIndex: 1];
        [MI setSubmenu: refMenu];
    }
    [self setMenu: labelMenu];
    [self setEnabled: YES];
//iTM2_END;
    return [super willPopUp];
}
@end

@implementation NSButton(iTM2TextButtonKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  buttonTextMark
+ (NSButton *) buttonTextMark;
/*"Public use. Description Forthcoming.
Version history: jlaurens@users.sourceforge.net
- 2.0: Fri May 21 11:07:09 GMT 2004
To Do List:
"*/
{
//iTM2_START;
    return [[[iTM2ButtonTextMark alloc] initWithFrame: NSZeroRect] autorelease];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  buttonTextSection
+ (NSButton *) buttonTextSection;
/*"Public use. Description Forthcoming.
Version history: jlaurens@users.sourceforge.net
- 2.0: Fri May 21 11:07:09 GMT 2004
To Do List:
"*/
{
//iTM2_START;
    return [[[iTM2ButtonTextSection alloc] initWithFrame: NSZeroRect] autorelease];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  buttonTextLabel
+ (NSButton *) buttonTextLabel;
/*"Public use. Description Forthcoming.
Version history: jlaurens@users.sourceforge.net
- 2.0: Fri May 21 11:07:09 GMT 2004
To Do List:
"*/
{
//iTM2_START;
    return [[[iTM2ButtonTextLabel alloc] initWithFrame: NSZeroRect] autorelease];
}
@end
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2TextButtonKit

@implementation NSInvocation(iTM2TextButtonKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  __delayInvocationWithTarget:action:sender:untilNotificationWithName:isPostedFromObject:
+ (void) __delayInvocationWithTarget: (id) target action: (SEL) action sender: (id) sender
untilNotificationWithName: (NSString *) name isPostedFromObject: (id) object;
/*"Description forthcoming.
Version History: jlaurens@users.sourceforge.net
- < 1.1: 03/10/2002
To Do List: ...
"*/
{
//iTM2_START;
    NSInvocation * invocation = [NSInvocation invocationWithMethodSignature:
        [target methodSignatureForSelector: action]];
    [invocation retainArguments];
    [invocation setArgument: (sender? &sender: nil) atIndex: 2];
    [invocation setTarget: target];
    [invocation setSelector: action];
    [INC addObserver: invocation selector: @selector(delayedInvokeNotified:) name: name object: object];
    [invocation retain];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  delayedInvokeNotified:
- (void) delayedInvokeNotified: (NSNotification *) aNotification;
/*"Description forthcoming.
Version History: jlaurens@users.sourceforge.net
- < 1.1: 03/10/2002
To Do List: ...
"*/
{
//iTM2_START;
    [self invoke];
    [INC removeObserver: self name: [aNotification name] object: [aNotification object]];
    [self autorelease];
    return;
}
@end
