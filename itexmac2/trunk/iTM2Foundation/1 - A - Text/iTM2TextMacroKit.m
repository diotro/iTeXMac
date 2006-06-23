/*
//
//  @version Subversion: $Id$ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Thu Feb 21 2002.
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

#import <iTM2Foundation/iTM2TextMacroKit.h>
#import <iTM2Foundation/iTM2TextKit.h>
#import <iTM2Foundation/iTM2StringKit.h>
#import <iTM2Foundation/iTM2NotificationKit.h>
//#import <iTM2Foundation/iTM2LiteScanner.h>
//#import <iTM2Foundation/iTM2TextKit.h>

NSString * const iTM2MacroNameKey = @"__(MACRO_NAME)__";
NSString * const iTM2MacroInsertionKey = @"__(INS)__";
NSString * const iTM2MacroToolTipKey = @"__(MACRO_TOOLTIP)__";

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2TextMacro
/*"This class deals with macro strings. These are strings with some key words to control the insertion of the macro in the current text."*/
@interface NSTextView (iTM2TextMacro_PRIVATE)
+ (NSString *)tabAnchor;
- (NSString *)cachedSelection;
@end
@implementation iTM2TextMacro
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  macroV1WithBefore:selected:after:
+ (id)macroV1WithBefore:(NSString *)before selected:(NSString *)selected after:(NSString *)after;
/*"Compatibility with iTeXMac2 < 1.0.7.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSString * const iTM2MacroNameOld = @"iTM2:MacroName";
    NSString * const iTM2TextSelectionOld = @"iTM2:Selection";
    id result = [[[[self class] alloc] initWithString:nil] autorelease];
    id temp = [[before mutableCopy] autorelease];
    [temp replaceOccurrencesOfString:iTM2MacroNameOld withString:iTM2MacroNameKey
        options: 0L range: NSMakeRange(0, [(NSString *)temp length])];
    [temp replaceOccurrencesOfString:iTM2TextSelectionOld withString:iTM2TextSelectionAnchorKey
        options: 0L range: NSMakeRange(0, [(NSString *)temp length])];
    [result setMacroBefore:temp];
    temp = [[selected mutableCopy] autorelease];
    [temp replaceOccurrencesOfString:iTM2MacroNameOld withString:iTM2MacroNameKey
        options: 0L range: NSMakeRange(0, [(NSString *)temp length])];
    [temp replaceOccurrencesOfString:iTM2TextSelectionOld withString:iTM2TextSelectionAnchorKey
        options: 0L range: NSMakeRange(0, [(NSString *)temp length])];
    [result setMacroSelected:temp];
    temp = [[after mutableCopy] autorelease];
    [temp replaceOccurrencesOfString:iTM2MacroNameOld withString:iTM2MacroNameKey
        options: 0L range: NSMakeRange(0, [(NSString *)temp length])];
    [temp replaceOccurrencesOfString:iTM2TextSelectionOld withString:iTM2TextSelectionAnchorKey
        options: 0L range: NSMakeRange(0, [(NSString *)temp length])];
    [result setMacroAfter:temp];
    [result setToolTip:[NSString string]];
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  string
- (NSString *)string
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return ([[self macroSelected] length]>0)?
        [NSString stringWithFormat:@"%@%@%@%@%@%@%@",
            [self macroBefore], iTM2MacroInsertionKey, [self macroSelected], iTM2MacroInsertionKey, [self macroAfter],
                iTM2MacroToolTipKey, [self toolTip]]:
        (([[self macroAfter] length]>0)?
        [NSString stringWithFormat:@"%@%@%@%@%@",
            [self macroBefore], iTM2MacroInsertionKey, [self macroAfter], iTM2MacroToolTipKey, [self toolTip]]:
            [NSString stringWithFormat:@"%@%@%@",
            [self macroBefore], iTM2MacroToolTipKey, [self toolTip]]);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initWithString:
- (id)initWithString:(NSString *)argument
/*"Designated initializer.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(self = [super init])
    {
        [self setMacroBefore:nil];
        [self setMacroSelected:nil];
        [self setMacroAfter:nil];
        [self setToolTip:nil];
        if([argument isKindOfClass:[NSString class]])
        {
			NSRange R = [argument rangeOfString:@"___"];// obsolete
			if(R.length)
			{
				NSMutableString * MS = [[argument mutableCopy] autorelease];
				R.location = 0;
				R.length = [MS length];
				[MS replaceOccurrencesOfString:iTM2MacroNameKey withString:iTM2MacroNameKey options:0L range:R];
				R.length = [MS length];
				[MS replaceOccurrencesOfString:iTM2TextSelectionAnchorKey withString:iTM2TextSelectionAnchorKey options:0L range:R];
				R.length = [MS length];
				[MS replaceOccurrencesOfString:iTM2MacroInsertionKey withString:iTM2MacroInsertionKey options:0L range:R];
				R.length = [MS length];
				[MS replaceOccurrencesOfString:iTM2TextTabAnchorKey withString:iTM2TextTabAnchorKey options:0L range:R];
				R.length = [MS length];
				[MS replaceOccurrencesOfString:iTM2MacroToolTipKey withString:iTM2MacroToolTipKey options:0L range:R];
			}
            NSArray * RA = [argument componentsSeparatedByString:iTM2MacroToolTipKey];
            if([RA count]>1)
                [self setToolTip:[[RA subarrayWithRange:NSMakeRange(1, [RA count] - 1)]
                            componentsJoinedByString: iTM2MacroToolTipKey]];
			if([RA count])
				[self setMacroBefore:[RA objectAtIndex:0]];
			if([RA count]>2)
			{
				[self setMacroSelected:[RA objectAtIndex:1]];
				[self setMacroAfter:[[RA subarrayWithRange:NSMakeRange(2, [RA count] - 2)]
						componentsJoinedByString: [NSString string]]];
			}
			else if([RA count]==2)
				[self setMacroAfter:[RA objectAtIndex:1]];
        }
    }
    return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  macroWithBefore:selected:after:toolTip:
+ (id)macroWithBefore:(NSString *)before selected:(NSString *)selected after:(NSString *)after toolTip:(NSString *)toolTip;
/*"Designated initializer.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [[[self alloc] initWithBefore:before selected:selected after:after toolTip:toolTip] autorelease];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initWithBefore:selected:after:toolTip:
- (id)initWithBefore:(NSString *)before selected:(NSString *)selected after:(NSString *)after toolTip:(NSString *)toolTip;
/*"Designated initializer.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(self = [super init])
    {
        [self setMacroBefore:before];
        [self setMacroSelected:selected];
        [self setMacroAfter:after];
        [self setToolTip:toolTip];
    }
    return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initWithAttributedString:name:toolTip:
- (id)initWithAttributedString:(NSAttributedString *)attributedString name:(NSString *)name toolTip:(NSString *)toolTip;
/*"Description forthcoming. The selected range is relative to the returned string.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 11/19/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(self = [super init])
    {
        // separate the string according to the selected range, this is driven by the background color
        int roof = [attributedString length];
        int location = 0;
        NSString * before = @"";
        NSMutableString * selected = [NSMutableString string];
        NSString * after = @"";
        NSRange R;
        if(![attributedString attribute:NSBackgroundColorAttributeName atIndex:0
                    longestEffectiveRange: &R inRange: NSMakeRange(location, roof - location)])
        {
            before = [[attributedString string] substringWithRange:R];
            location = NSMaxRange(R);
        }
        if((location<roof) && ![attributedString attribute:NSBackgroundColorAttributeName atIndex:roof-1
                    longestEffectiveRange: &R inRange: NSMakeRange(location, roof-location)])
        {
            after = [[attributedString string] substringWithRange:R];
            roof = R.location;
        }
        while(location<roof)
        {
            if(![attributedString attribute:NSBackgroundColorAttributeName atIndex:location
                            longestEffectiveRange: &R inRange: NSMakeRange(location, roof-location)])
                [selected appendString:[[attributedString string] substringWithRange:R]];
            location+=R.length;
        }
        
        // replace the "name" with the iTM2MacroNameKey
        #define CLEAN(string)\
        {\
            NSMutableString * MS = [[string mutableCopy] autorelease];\
            [MS replaceOccurrencesOfString:name withString:iTM2MacroNameKey options:0L range:NSMakeRange(0, [MS length])];\
            string = [[MS copy] autorelease];\
        }
        CLEAN(before);
        CLEAN(selected);
        CLEAN(after);
        [self setMacroBefore:before];
        [self setMacroSelected:selected];
        [self setMacroAfter:after];
        [self setToolTip:toolTip];
    }
    return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  attributedStringForName:delimiter:
- (NSAttributedString *)attributedStringForName:(NSString *)name delimiter:(NSAttributedString *)delimiterAttributedString;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 11/19/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSMutableString * before = [[[self macroBefore] mutableCopy] autorelease];
    NSMutableString * selected = [[[self macroSelected] mutableCopy] autorelease];
    NSMutableString * after = [[[self macroAfter] mutableCopy] autorelease];

    [before replaceOccurrencesOfString:iTM2MacroNameKey withString:name options:0L range:NSMakeRange(0, [before length])];
    [selected replaceOccurrencesOfString:iTM2MacroNameKey withString:name options:0L range:NSMakeRange(0, [selected length])];
    [after replaceOccurrencesOfString:iTM2MacroNameKey withString:name options:0L range:NSMakeRange(0, [after length])];

    NSMutableAttributedString * MAS = [[NSMutableAttributedString new] autorelease];
    if([before length])
        [MAS appendAttributedString:[[[NSAttributedString alloc] initWithString:before] autorelease]];
    [MAS appendAttributedString:delimiterAttributedString];
    if([selected length])
    {
        [MAS appendAttributedString:[[[NSAttributedString alloc] initWithString:selected] autorelease]];
        [MAS appendAttributedString:delimiterAttributedString];
    }
    if([after length])
        [MAS appendAttributedString:[[[NSAttributedString alloc] initWithString:after] autorelease]];
    return MAS;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  macroStringForName:selection:indent:selectedRangePointer:
- (NSString *)macroStringForName:(NSString *)name selection:(NSString *)selection indent:(NSString *)indentPrefix
    selectedRangePointer: (NSRangePointer) aRangePtr
/*"Description forthcoming. The selected range is relative to the returned string.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(aRangePtr)
    {
        NSMutableString * before = [[[self macroBefore] mutableCopy] autorelease];
        NSMutableString * selected = [[[self macroSelected] mutableCopy] autorelease];
        NSMutableString * after = [[[self macroAfter] mutableCopy] autorelease];
        if(name)
        {
            [before replaceOccurrencesOfString:iTM2MacroNameKey withString:name
                                        options: 0L range: NSMakeRange(0, [before length])];
            [selected replaceOccurrencesOfString:iTM2MacroNameKey withString:name
                                        options: 0L range: NSMakeRange(0, [selected length])];
            [after replaceOccurrencesOfString:iTM2MacroNameKey withString:name
                                        options: 0L range: NSMakeRange(0, [after length])];
        }
        if([selection length])
        {
            [before replaceOccurrencesOfString:iTM2TextSelectionAnchorKey withString:selection
                                        options: 0L range: NSMakeRange(0, [before length])];
            [selected replaceOccurrencesOfString:iTM2TextSelectionAnchorKey withString:selection
                                        options: 0L range: NSMakeRange(0, [selected length])];
            [after replaceOccurrencesOfString:iTM2TextSelectionAnchorKey withString:selection
                                        options: 0L range: NSMakeRange(0, [after length])];
        }
        else
        {
            [before replaceOccurrencesOfString:iTM2TextSelectionAnchorKey withString:iTM2TextTabAnchorKey
                                        options: 0L range: NSMakeRange(0, [before length])];
            [selected replaceOccurrencesOfString:iTM2TextSelectionAnchorKey withString:iTM2TextTabAnchorKey
                                        options: 0L range: NSMakeRange(0, [selected length])];
            [after replaceOccurrencesOfString:iTM2TextSelectionAnchorKey withString:iTM2TextTabAnchorKey
                                        options: 0L range: NSMakeRange(0, [after length])];
            {
                NSRange foundRange = [before rangeOfString:iTM2TextTabAnchorKey
                                                    options: 0 range: NSMakeRange(0, [before length])];
                if(foundRange.length)
                {
                    NSString * newBefore = [before substringWithRange:NSMakeRange(0, foundRange.location)];
                    int i = NSMaxRange(foundRange);
                    after = (id)[[[before substringWithRange:NSMakeRange(i, [before length] - i)]
                                    stringByAppendingString: selected]
                                            stringByAppendingString: after];
                    selected = (id)iTM2TextTabAnchorKey;
                    before = (id)newBefore;
                }
            }
        }
        NSString * anchor = [NSTextView tabAnchor];
        [before replaceOccurrencesOfString:iTM2TextTabAnchorKey withString:anchor
                                    options: 0L range: NSMakeRange(0, [before length])];
        [selected replaceOccurrencesOfString:iTM2TextTabAnchorKey withString:anchor
                                    options: 0L range: NSMakeRange(0, [selected length])];
        [after replaceOccurrencesOfString:iTM2TextTabAnchorKey withString:anchor
                                    options: 0L range: NSMakeRange(0, [after length])];
        aRangePtr->location = [before length];
        aRangePtr->length = [selected length];
        return [[before stringByAppendingString:selected] stringByAppendingString:after];
    }
    else
    {
        NSMutableString * result = [[[self macroBefore] mutableCopy] autorelease];
        [result appendString:[self macroSelected]];
        [result appendString:[self macroAfter]];
        if([name length])
            [result replaceOccurrencesOfString:iTM2MacroNameKey withString:name
                                    options: 0L range: NSMakeRange(0, [result length])];
        if([selection length])
            [result replaceOccurrencesOfString:iTM2TextSelectionAnchorKey withString:selection
                                        options: 0L range: NSMakeRange(0, [result length])];
        else
            [result replaceOccurrencesOfString:iTM2TextSelectionAnchorKey withString:iTM2TextTabAnchorKey
                                        options: 0L range: NSMakeRange(0, [result length])];
        return result;
    }
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  macroBefore
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  macroSelected
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  macroAfter
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toolTip
#define GETTER(getter, source) - (NSString *) getter; {return source? source: [NSString string];}
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
GETTER(macroBefore, _Before);
GETTER(macroSelected, _Selected);
GETTER(macroAfter, _After);
GETTER(toolTip, _ToolTip);
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setMacroBefore:
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setMacroSelected:
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setMacroAfter:
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setToolTip:
#define SETTER(setter, source)\
- (void)setter:(NSString *)argument;\
{\
    if(![source isEqualToString:argument])\
    {\
        [source autorelease];\
        argument = [[argument mutableCopy] autorelease];\
        [(NSMutableString *)argument replaceOccurrencesOfString:iTM2MacroInsertionKey withString:[NSString string]\
                                    options: 0L range: NSMakeRange(0, [argument length])];\
        source = [argument copy];\
    }\
    return;\
}
SETTER(setMacroBefore, _Before);
SETTER(setMacroSelected, _Selected);
SETTER(setMacroAfter, _After);
SETTER(setToolTip, _ToolTip);
#if MAC_OS_X_VERSION_10_2 <= MAC_OS_X_VERSION_MAX_ALLOWED
    #warning 10.2 at least
#else
    #warning 10.1
#endif
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  dealloc
- (void)dealloc
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self setMacroBefore:nil];
    [self setMacroSelected:nil];
    [self setMacroAfter:nil];
    [self setToolTip:nil];
    [super dealloc];
    return;
}
@end

@implementation NSTextView (iTM2TextMacro)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  tabAnchor
+ (NSString *)tabAnchor;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [SUD stringForKey:iTM2UDTabAnchorStringKey];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertMacro:
- (void)insertMacro:(id)argument;
/*"Description forthcoming. argument is either a dictionary with strings for keys "before", "selected" and "after" or a string playing the role of before keyed object (the other strings are blank). When the argument is a NSMenuItem (or so) we add a pretreatment replacing the argument by its represented object.
Version history: jlaurens AT users DOT sourceforge DOT net (1.0.10)
- 1.2: 06/24/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self insertMacro:argument tabAnchor:[self tabAnchor]];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  delayedSetSelectedRangeValue:
- (void)delayedSetSelectedRangeValue:(id)rangeValue;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self setSelectedRange:[rangeValue rangeValue]];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertMacro:tabAnchor:
- (void)insertMacro:(id)argument tabAnchor:(NSString *)tabAnchor;
/*"Description forthcoming. argument is either a dictionary with strings for keys "before", "selected" and "after" or a string playing the role of before keyed object (the other strings are blank). When the argument is a NSMenuItem (or so) we add a pretreatment replacing the argument by its represented object.
Version history: jlaurens AT users DOT sourceforge DOT net (1.0.10)
- 1.2: 06/24/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(!tabAnchor)
        tabAnchor = @"";
    if([argument conformsToProtocol:@protocol(NSMenuItem)])
        argument = [argument representedObject];
// this new part concerns the new macro design. 2006
	if([argument isKindOfClass:[NSArray class]])
	{
		NSMutableArray * MRA = [NSMutableArray array];
		NSEnumerator * E = [argument objectEnumerator];
		NSMutableString * MS;
		while(MS = [E nextObject])
		{
			if([MS isKindOfClass:[NSString class]])
			{
				MS = [[MS mutableCopy] autorelease];
				NSString * cachedSelection = [self cachedSelection];
				if([cachedSelection isEqualToString:tabAnchor])
					cachedSelection = [NSString string];
				if([cachedSelection length])
				{
					[MS replaceOccurrencesOfString:iTM2TextSelectionAnchorKey withString:cachedSelection
												options: 0L range: NSMakeRange(0, [MS length])];
				}
				else
				{
					[MS replaceOccurrencesOfString:iTM2TextSelectionAnchorKey withString:iTM2TextTabAnchorKey
												options: 0L range: NSMakeRange(0, [MS length])];
				}
				[MS replaceOccurrencesOfString:iTM2TextTabAnchorKey withString:tabAnchor
											options: 0L range: NSMakeRange(0, [MS length])];
				[MRA addObject:MS];
			}
		}
		[self insertStringArray:MRA];
		return;
	}
    if([argument isKindOfClass:[NSString class]])
        argument = [[[iTM2TextMacro alloc] initWithString:argument] autorelease];
    if([argument isKindOfClass:[iTM2TextMacro class]])
    {
        argument = [NSDictionary dictionaryWithObjectsAndKeys:
            [argument macroBefore], @"before",
            [argument macroSelected], @"selected",
            [argument macroAfter], @"after", nil];
    }
    if(![argument isKindOfClass:[NSDictionary class]])
    {
        NSLog(@"Don't know what to do with this argument: %@", argument);
        return;
    }
//    NSString * S = [self string];
    #warning macro insertion is not compatible with indentation
    #if 0
    NSRange oldSelectedRange = [self selectedRange];
    {
        unsigned begin;
//NSLog(@"GLS");
        [S getLineStart:&begin end:nil contentsEnd:nil forRange:oldSelectedRange];
        if(begin < oldSelectedRange.location)
        {
            NSCharacterSet * blackLetterSet = [[NSCharacterSet whitespaceCharacterSet] invertedSet];
            unsigned length = [S rangeOfCharacterFromSet:blackLetterSet
                options: 0 range: NSMakeRange(begin, oldSelectedRange.location - begin)].location - begin;
            if(length)
                ;//[S substringWithRange:NSMakeRange(begin, length)];
        }
    }
    #endif
    NSMutableString * before = [argument objectForKey:@"before"];
    if(!before) before = [NSString string];
    before = [[before mutableCopy] autorelease];
    NSMutableString * selected = [argument objectForKey:@"selected"];
    if(!selected) selected = [NSString string];
    selected = [[selected mutableCopy] autorelease];
    NSMutableString * after = [argument objectForKey:@"after"];
    if(!after) after = [NSString string];
    after = [[after mutableCopy] autorelease];

//NSLog(@"argument: %@", argument);
//NSLog(@"before: <%@>", before);
//NSLog(@"selected: <%@>", selected);
//NSLog(@"after: <%@>", after);
    
    NSString * cachedSelection = [self cachedSelection];
    if([cachedSelection isEqualToString:tabAnchor])
        cachedSelection = [NSString string];
    if([cachedSelection length])
    {
        [before replaceOccurrencesOfString:iTM2TextSelectionAnchorKey withString:cachedSelection
                                    options: 0L range: NSMakeRange(0, [before length])];
        [selected replaceOccurrencesOfString:iTM2TextSelectionAnchorKey withString:cachedSelection
                                    options: 0L range: NSMakeRange(0, [selected length])];
        [after replaceOccurrencesOfString:iTM2TextSelectionAnchorKey withString:cachedSelection
                                    options: 0L range: NSMakeRange(0, [after length])];
    }
    else
    {
        [before replaceOccurrencesOfString:iTM2TextSelectionAnchorKey withString:iTM2TextTabAnchorKey
                                    options: 0L range: NSMakeRange(0, [before length])];
        [selected replaceOccurrencesOfString:iTM2TextSelectionAnchorKey withString:iTM2TextTabAnchorKey
                                    options: 0L range: NSMakeRange(0, [selected length])];
        [after replaceOccurrencesOfString:iTM2TextSelectionAnchorKey withString:iTM2TextTabAnchorKey
                                    options: 0L range: NSMakeRange(0, [after length])];
        {
            NSRange foundRange = [before rangeOfString:iTM2TextTabAnchorKey
                                                options: 0 range: NSMakeRange(0, [before length])];
            if(foundRange.length)
            {
                NSString * newBefore = [before substringWithRange:NSMakeRange(0, foundRange.location)];
                int i = NSMaxRange(foundRange);
                after = [[[[[before substringWithRange:NSMakeRange(i, [before length] - i)]
        stringByAppendingString: selected] stringByAppendingString: after] mutableCopy] autorelease];
                selected = [[iTM2TextTabAnchorKey mutableCopy] autorelease];
                before = [[newBefore mutableCopy] autorelease];
            }
        }
    }
    [before replaceOccurrencesOfString:iTM2TextTabAnchorKey withString:tabAnchor
                                options: 0L range: NSMakeRange(0, [before length])];
    [selected replaceOccurrencesOfString:iTM2TextTabAnchorKey withString:tabAnchor
                                options: 0L range: NSMakeRange(0, [selected length])];
    [after replaceOccurrencesOfString:iTM2TextTabAnchorKey withString:tabAnchor
                                options: 0L range: NSMakeRange(0, [after length])];
    if([after length] && [tabAnchor length] && ![after hasSuffix:tabAnchor])
        after = (id)[after stringByAppendingString:tabAnchor];

//NSLog(@"before: <%@>", before);
//NSLog(@"selected: <%@>", selected);
//NSLog(@"after: <%@>", after);
    [self breakTypingFlow];
    if(before)
        [self insertText:before];
//NSLog(@"%@ %#x IS DONE 1", __PRETTY_FUNCTION__, self);
    unsigned index = [self selectedRange].location;
    if(selected)
        [self insertText:selected];
//NSLog(@"%@ %#x IS DONE 2", __PRETTY_FUNCTION__, self);
    if(after)
        [self insertText:after];
//NSLog(@"%@ %#x IS DONE 3", __PRETTY_FUNCTION__, self);
	[self performSelector:@selector(delayedSetSelectedRangeValue:)
		withObject: [NSValue valueWithRange:NSMakeRange(index, [selected length])] afterDelay:0.01];
//    [self setSelectedRange:NSMakeRange(index, [selected length])];
//NSLog(@"%@ %#x IS DONE 4", __PRETTY_FUNCTION__, self);
    [self breakTypingFlow];
    return;
}
@end

@interface NSObject(NSTextStorage_iTeXMac2)
- (NSTextView *)mainTextView;
- (NSRange)rangeValue;
- (unsigned)index;
- (unsigned)insertionIndex;
- (unsigned)intValue;
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  NSTextStorage(iTM2Selection_MACRO)
/*"Description forthcoming."*/
@implementation NSTextStorage(iTM2Selection_MACRO)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  insertMacro:inRangeValue:
- (void)insertMacro:(id)argument inRangeValue:(id)rangeValue;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if([argument isKindOfClass:[NSString class]] || [argument isKindOfClass:[NSDictionary class]])
    {
        NSTextView * TV = [self mainTextView];
        if([rangeValue respondsToSelector:@selector(rangeValue)])
            [TV setSelectedRange:[rangeValue rangeValue]];
        [TV insertMacro:argument];        
    }
    else
    {
        NSLog(@"JL, you should have raised an exception!!! (code 1789)");
    }
    return;
}
@end

@implementation iTM2AppleScriptMacro
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initWithScript:
- (id)initWithScript:(NSString *)argument;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1: 06/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(self = [super init])
    {
        [self setScript:argument];
    }
    return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initWithEncodedScript:
- (id)initWithEncodedScript:(NSString *)argument;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1: 06/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSArray * A = [argument componentsSeparatedByString:iTM2MacroToolTipKey];
    if(self = [self initWithScript:([A count]? [A objectAtIndex:0]:@"")])
    {
        if([A count] > 1)
        [self setToolTip:[A objectAtIndex:1]];
    }
    return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  dealloc
- (void)dealloc;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1: 06/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self setScript:nil];
    [self setToolTip:nil];
    [super dealloc];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  script
- (NSString *)script;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1: 06/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return _Script;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  encodedScript
- (NSString *)encodedScript;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1: 06/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [_ToolTip length]?
        [NSString stringWithFormat:@"%@%@%@", _Script, iTM2MacroToolTipKey, _ToolTip]:
            _Script;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setScript:
- (void)setScript:(NSString *)argument;
/*"Description forthcoming.
No copy made, just retain.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1: 06/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(argument && ![argument isKindOfClass:[NSString class]])
        [NSException raise:NSInvalidArgumentException format:@"%@ NSString argument expected:%@.",
            __PRETTY_FUNCTION__, argument];
    if(![_Script isEqualToString:argument])
    {
        [_Script autorelease];
        _Script = [argument retain];
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toolTip
- (NSString *)toolTip;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1: 06/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return _ToolTip;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setToolTip:
- (void)setToolTip:(NSString *)argument;
/*"Description forthcoming.
No copy made, just retain.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1: 06/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(argument && ![argument isKindOfClass:[NSString class]])
        [NSException raise:NSInvalidArgumentException format:@"%@ NSString argument expected:%@.",
            __PRETTY_FUNCTION__, argument];
    if(![_ToolTip isEqualToString:argument])
    {
        [_ToolTip autorelease];
        _ToolTip = [argument retain];
    }
    return;
}
@end

@implementation iTM2AppleScriptFileMacro
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initWithPath:
- (id)initWithPath:(NSString *)argument;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1: 06/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(self = [super init])
    {
        [self setPath:argument];
    }
    return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initWithEncodedPath:
- (id)initWithEncodedPath:(NSString *)argument;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1: 06/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSArray * A = [argument componentsSeparatedByString:iTM2MacroToolTipKey];
    if(self = [self initWithPath:([A count]? [A objectAtIndex:0]:@"")])
    {
        if([A count] > 1)
        [self setToolTip:[A objectAtIndex:1]];
    }
    return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  dealloc
- (void)dealloc;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1: 06/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self setPath:nil];
    [self setToolTip:nil];
    [super dealloc];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  path
- (NSString *)path;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1: 06/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return _Path;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  encodedPath
- (NSString *)encodedPath;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1: 06/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [_ToolTip length]?
        [NSString stringWithFormat:@"%@%@%@", _Path, iTM2MacroToolTipKey, _ToolTip]:
            _Path;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setPath:
- (void)setPath:(NSString *)argument;
/*"Description forthcoming.
No copy made, just retain.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1: 06/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(argument && ![argument isKindOfClass:[NSString class]])
        [NSException raise:NSInvalidArgumentException format:@"%@ NSString argument expected:%@.",
            __PRETTY_FUNCTION__, argument];
    if(![_Path isEqualToString:argument])
    {
        [_Path autorelease];
        _Path = [argument retain];
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toolTip
- (NSString *)toolTip;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1: 06/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return _ToolTip;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setToolTip:
- (void)setToolTip:(NSString *)argument;
/*"Description forthcoming.
No copy made, just retain.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1: 06/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
#warning DID YOU IMPLEMENT THE TOOLTIP SHORTCUT
    if(argument && ![argument isKindOfClass:[NSString class]])
        [NSException raise:NSInvalidArgumentException format:@"%@ NSString argument expected:%@.",
            __PRETTY_FUNCTION__, argument];
    if(![_ToolTip isEqualToString:argument])
    {
        [_ToolTip autorelease];
        _ToolTip = [argument retain];
    }
    return;
}
@end
