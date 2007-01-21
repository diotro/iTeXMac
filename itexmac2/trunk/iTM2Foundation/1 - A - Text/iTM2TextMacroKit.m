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
#import <iTM2Foundation/iTM2KeyBindingsKit.h>
#import <iTM2Foundation/iTM2MacroKit.h>
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
    [temp replaceOccurrencesOfString:iTM2TextSelectionOld withString:iTM2TextSELPlaceholder
        options: 0L range: NSMakeRange(0, [(NSString *)temp length])];
    [result setMacroBefore:temp];
    temp = [[selected mutableCopy] autorelease];
    [temp replaceOccurrencesOfString:iTM2MacroNameOld withString:iTM2MacroNameKey
        options: 0L range: NSMakeRange(0, [(NSString *)temp length])];
    [temp replaceOccurrencesOfString:iTM2TextSelectionOld withString:iTM2TextSELPlaceholder
        options: 0L range: NSMakeRange(0, [(NSString *)temp length])];
    [result setMacroSelected:temp];
    temp = [[after mutableCopy] autorelease];
    [temp replaceOccurrencesOfString:iTM2MacroNameOld withString:iTM2MacroNameKey
        options: 0L range: NSMakeRange(0, [(NSString *)temp length])];
    [temp replaceOccurrencesOfString:iTM2TextSelectionOld withString:iTM2TextSELPlaceholder
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
				[MS replaceOccurrencesOfString:iTM2TextSELPlaceholder withString:iTM2TextSELPlaceholder options:0L range:R];
				R.length = [MS length];
				[MS replaceOccurrencesOfString:iTM2MacroInsertionKey withString:iTM2MacroInsertionKey options:0L range:R];
				R.length = [MS length];
				[MS replaceOccurrencesOfString:iTM2TextTABPlaceholder withString:iTM2TextTABPlaceholder options:0L range:R];
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
            [before replaceOccurrencesOfString:iTM2TextSELPlaceholder withString:selection
                                        options: 0L range: NSMakeRange(0, [before length])];
            [selected replaceOccurrencesOfString:iTM2TextSELPlaceholder withString:selection
                                        options: 0L range: NSMakeRange(0, [selected length])];
            [after replaceOccurrencesOfString:iTM2TextSELPlaceholder withString:selection
                                        options: 0L range: NSMakeRange(0, [after length])];
        }
        else
        {
            [before replaceOccurrencesOfString:iTM2TextSELPlaceholder withString:iTM2TextTABPlaceholder
                                        options: 0L range: NSMakeRange(0, [before length])];
            [selected replaceOccurrencesOfString:iTM2TextSELPlaceholder withString:iTM2TextTABPlaceholder
                                        options: 0L range: NSMakeRange(0, [selected length])];
            [after replaceOccurrencesOfString:iTM2TextSELPlaceholder withString:iTM2TextTABPlaceholder
                                        options: 0L range: NSMakeRange(0, [after length])];
            {
                NSRange foundRange = [before rangeOfString:iTM2TextTABPlaceholder
                                                    options: 0 range: NSMakeRange(0, [before length])];
                if(foundRange.length)
                {
                    NSString * newBefore = [before substringWithRange:NSMakeRange(0, foundRange.location)];
                    int i = NSMaxRange(foundRange);
                    after = (id)[[[before substringWithRange:NSMakeRange(i, [before length] - i)]
                                    stringByAppendingString: selected]
                                            stringByAppendingString: after];
                    selected = (id)iTM2TextTABPlaceholder;
                    before = (id)newBefore;
                }
            }
        }
        NSString * anchor = [NSTextView tabAnchor];
        [before replaceOccurrencesOfString:iTM2TextTABPlaceholder withString:anchor
                                    options: 0L range: NSMakeRange(0, [before length])];
        [selected replaceOccurrencesOfString:iTM2TextTABPlaceholder withString:anchor
                                    options: 0L range: NSMakeRange(0, [selected length])];
        [after replaceOccurrencesOfString:iTM2TextTABPlaceholder withString:anchor
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
            [result replaceOccurrencesOfString:iTM2TextSELPlaceholder withString:selection
                                        options: 0L range: NSMakeRange(0, [result length])];
        else
            [result replaceOccurrencesOfString:iTM2TextSELPlaceholder withString:iTM2TextTABPlaceholder
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
    return [SUD stringForKey:iTM2TextTabAnchorStringKey];
}
//=-=-=-=-=-=-=-=-=-=-=  performInsertActionWithArguments:attributes:
- (BOOL)performInsertActionWithArguments:(NSArray *)arguments attributes:(NSDictionary *)attributes;
/*"The default implementation does nothing."*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(iTM2DebugEnabled)
	{
		iTM2_LOG(@"arguments:%@",arguments);
		iTM2_LOG(@"attributes:%@",attributes);
	}
	if([arguments count])
	{
		NSString * replacementString = [arguments objectAtIndex:0];
		[self insertMacro:replacementString];
	}
//iTM2_END;
    return YES;
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
    if([argument isKindOfClass:[NSString class]])
	{
		argument = [argument stringByRemovingTipPlaceHolders];
		NSRange _RangeForUserCompletion = [self selectedRange];
		NSString * _Tab = nil;
		unsigned idx = [self numberOfSpacesPerTab];
		if(idx<=0)
		{
			_Tab = @"\t";
		}
		else
		{
			NSMutableString * MS = [NSMutableString string];
			while(idx--)
			{
				[MS appendString:@" "];
			}
			_Tab = [MS copy];
		}
		NSRange _SelectedRange = [self selectedRange];
		NSString * S = [self string];
		NSString * _OriginalSelectedString = [S substringWithRange:_SelectedRange];
		// Get the indentation level at the line where we are going to insert things
		int numberOfSpacesPerTab = [self numberOfSpacesPerTab]?:4;
		numberOfSpacesPerTab = abs(numberOfSpacesPerTab);
		unsigned start, contentsEnd;
		NSRange R = _RangeForUserCompletion;
		R.length = 0;
		[S getLineStart:&start end:nil contentsEnd:&contentsEnd forRange:R];
		unsigned _IndentationLevel = 0;
		unsigned currentLength = 0;
		while(start<contentsEnd)
		{
			unichar theChar = [S characterAtIndex:start++];
			if(theChar == ' ')
			{
				++currentLength;
			}
			else if(theChar == '\t')
			{
				++_IndentationLevel;
				_IndentationLevel += (2*currentLength)/numberOfSpacesPerTab;
				currentLength = 0;
			}
			else
			{
				break;
			}
		}
		_IndentationLevel += (2*currentLength)/numberOfSpacesPerTab;
		
		// get the indentation in the original selected string, starting at the second line
		// then split the selection into lines in order to manage the indentation
		// ensuring that the white prefix is of the apropriate format
		NSMutableArray * replacementLines = [NSMutableArray array];
		R = NSMakeRange(0,0);
		[_OriginalSelectedString getLineStart:nil end:&R.location contentsEnd:nil forRange:R];
		NSString * blackString = [_OriginalSelectedString substringWithRange:NSMakeRange(0,R.location)];
		[replacementLines addObject:blackString];
		NSMutableArray * whitePrefixes = [NSMutableArray array];
		NSMutableArray * blackStrings = [NSMutableArray array];
		unsigned indentationOfTheSelectedString = 0;
		NSNumber * N;
		unsigned end;
		unsigned lineIndentation = 0;
		if(R.location < [_OriginalSelectedString length])
		{
			indentationOfTheSelectedString = UINT_MAX;
			do
			{
				[_OriginalSelectedString getLineStart:nil end:&end contentsEnd:&contentsEnd forRange:R];
				lineIndentation = 0;
				while(R.location<contentsEnd)
				{
					unichar theChar = [_OriginalSelectedString characterAtIndex:R.location++];
					if(theChar == ' ')
					{
						++currentLength;
					}
					else if(theChar == '\t')
					{
						++lineIndentation;
						lineIndentation += (2*currentLength)/numberOfSpacesPerTab;
						currentLength = 0;
					}
					else
					{
						break;
					}
				}
				lineIndentation += (2*currentLength)/numberOfSpacesPerTab;
				if(lineIndentation<indentationOfTheSelectedString)
				{
					indentationOfTheSelectedString = lineIndentation;
				}
				N = [NSNumber numberWithUnsignedInt:lineIndentation];
				[whitePrefixes addObject:N];
				blackString = [_OriginalSelectedString substringWithRange:NSMakeRange(R.location,end-R.location)];
				[blackStrings addObject:blackString];
				R.location = end;
			}
			while(R.location < [_OriginalSelectedString length]);
		}
		NSEnumerator * whiteE = [whitePrefixes objectEnumerator];
		NSEnumerator * blackE = [blackStrings objectEnumerator];
		while((N = [whiteE nextObject]) && (blackString = [blackE nextObject]))
		{
			lineIndentation = [N unsignedIntValue];
			lineIndentation -= indentationOfTheSelectedString;
			if(lineIndentation)
			{
				NSMutableString * MS = [NSMutableString string];
				while(lineIndentation--)
				{
					[MS appendString:_Tab];
				}
				[MS appendString:blackString];
				[replacementLines addObject:MS];
			}
			else
			{
				[replacementLines addObject:blackString];
			}
		}

		NSString * completion = argument;
		NSMutableString * longCompletionString = [NSMutableString string];
		R = NSMakeRange(0,0);
		[completion getLineStart:nil end:&R.location contentsEnd:nil forRange:R];// first line
		blackString = [completion substringWithRange:NSMakeRange(0,R.location)];
		[longCompletionString appendString:blackString];
		if(R.location < [completion length])
		{
			do
			{
				[completion getLineStart:nil end:&end contentsEnd:&contentsEnd forRange:R];
				lineIndentation = 0;
				unsigned currentLength = 0;
				int numberOfSpacesPerTab = [self numberOfSpacesPerTab]?:4;
				while(R.location<contentsEnd)
				{
					unichar theChar = [completion characterAtIndex:R.location++];
					if(theChar == ' ')
					{
						++currentLength;
					}
					else if(theChar == '\t')
					{
						++lineIndentation;
						lineIndentation += (2*currentLength)/numberOfSpacesPerTab;
						currentLength = 0;
					}
					else
					{
						break;
					}
				}
				lineIndentation += (2*currentLength)/numberOfSpacesPerTab;
				NSMutableString * whitePrefix = [NSMutableString string];
				while(lineIndentation--)
				{
					[whitePrefix appendString:_Tab];
				}
				NSMutableString * line = [NSMutableString stringWithString:whitePrefix];
				blackString = [completion substringWithRange:NSMakeRange(R.location,end-R.location)];
				NSRange searchRange = NSMakeRange(0,0);
				searchRange.length = [blackString length] - searchRange.location;
				NSRange SELRange = [blackString rangeOfString:iTM2TextSELPlaceholder options:nil range:searchRange];
				if(SELRange.length)
				{
					NSString * s = [blackString substringWithRange:NSMakeRange(searchRange.location,SELRange.location-searchRange.location)];
					[line appendString:s];
					NSEnumerator * replacementE = [replacementLines objectEnumerator];
					s = [replacementE nextObject];
					[line appendString:s];
					while(s = [replacementE nextObject])
					{
						[line appendString:whitePrefix];
						[line appendString:s];
					}
next:
					searchRange.location = NSMaxRange(SELRange);
					if([blackString length]>searchRange.location)
					{
						searchRange.length = [blackString length] - searchRange.location;
						SELRange = [blackString rangeOfString:iTM2TextSELPlaceholder options:nil range:searchRange];
						if(SELRange.length)
						{
							s = [blackString substringWithRange:NSMakeRange(searchRange.location,SELRange.location-searchRange.location)];
							[line appendString:s];
							replacementE = [replacementLines objectEnumerator];
							s = [replacementE nextObject];
							[line appendString:s];
							while(s = [replacementE nextObject])
							{
								[line appendString:whitePrefix];
								[line appendString:s];
							}
							goto next;
						}
					}
				}
				else
				{
					[line appendString:blackString];
				}
				[longCompletionString appendString:line];
			}
			while(R.location < [completion length]);
		}

		NSArray * components = [longCompletionString componentsSeparatedByString:iTM2TextINSPlaceholder];
		NSString * replacementString = [components componentsJoinedByString:@""];
		NSMutableArray * selectedRanges = [NSMutableArray array];
		NSEnumerator * E = [components objectEnumerator];
		NSString * component;
		R = _RangeForUserCompletion;
		NSValue * V = nil;
		while(component = [E nextObject])
		{
			R.location += [component length];
			R.length = 0;
			if(component = [E nextObject])
			{
				R.length = [component length];
				V = [NSValue valueWithRange:R];
				[selectedRanges addObject:V];
			}
			else
			{
				break;
			}
		}
		if(![selectedRanges count])
		{
			// is there any place holder?
			R = [replacementString rangeOfPlaceholderFromIndex:0 cycle:NO tabAnchor:tabAnchor];
			if(R.length)
			{
				if(NSMaxRange(R)<[replacementString length])
				{
					R.location = [replacementString length];
					replacementString = [replacementString stringByAppendingString:iTM2TextTABPlaceholder];
					R.length = [replacementString length] - R.location;
				}
			}
			else
			{
				R.location = [replacementString length];
				R.length = 0;
			}
			R.location += _RangeForUserCompletion.location;
			NSValue * V = [NSValue valueWithRange:R];
			[selectedRanges addObject:V];
		}
		// if the last placeholder is selected wherease there is a placeholder before, remove the corresponding selected range
		R = [replacementString rangeOfPlaceholderToIndex:[replacementString length] cycle:NO tabAnchor:tabAnchor];
		if(R.length)
		{
			if(R.location)
			{
				if([replacementString rangeOfPlaceholderToIndex:R.location-1 cycle:NO tabAnchor:tabAnchor].length)
				{
					R.location += _RangeForUserCompletion.location;
					V = [NSValue valueWithRange:R];
					if([selectedRanges containsObject:V])
					{
						[selectedRanges removeObject:V];
						R.location = NSMaxRange(R);
						R.length = 0;
						V = [NSValue valueWithRange:R];
						[selectedRanges addObject:V];
					}
				}
			}
		}
		if([self shouldChangeTextInRange:_SelectedRange replacementString:replacementString])
		{
			[self replaceCharactersInRange:_SelectedRange withString:replacementString];
			[self didChangeText];
			[self setSelectedRanges:selectedRanges];
		}
		return;
	}
	if([argument isKindOfClass:[NSArray class]])
	{
		NSEnumerator * E = [argument objectEnumerator];
		while(argument = [E nextObject])
		{
			[self insertMacro:argument tabAnchor:tabAnchor];
		}
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
        [before replaceOccurrencesOfString:iTM2TextSELPlaceholder withString:cachedSelection
                                    options: 0L range: NSMakeRange(0, [before length])];
        [selected replaceOccurrencesOfString:iTM2TextSELPlaceholder withString:cachedSelection
                                    options: 0L range: NSMakeRange(0, [selected length])];
        [after replaceOccurrencesOfString:iTM2TextSELPlaceholder withString:cachedSelection
                                    options: 0L range: NSMakeRange(0, [after length])];
    }
    else
    {
        [before replaceOccurrencesOfString:iTM2TextSELPlaceholder withString:iTM2TextTABPlaceholder
                                    options: 0L range: NSMakeRange(0, [before length])];
        [selected replaceOccurrencesOfString:iTM2TextSELPlaceholder withString:iTM2TextTABPlaceholder
                                    options: 0L range: NSMakeRange(0, [selected length])];
        [after replaceOccurrencesOfString:iTM2TextSELPlaceholder withString:iTM2TextTABPlaceholder
                                    options: 0L range: NSMakeRange(0, [after length])];
        {
            NSRange foundRange = [before rangeOfString:iTM2TextTABPlaceholder
                                                options: 0 range: NSMakeRange(0, [before length])];
            if(foundRange.length)
            {
                NSString * newBefore = [before substringWithRange:NSMakeRange(0, foundRange.location)];
                int i = NSMaxRange(foundRange);
                after = [[[[[before substringWithRange:NSMakeRange(i, [before length] - i)]
        stringByAppendingString: selected] stringByAppendingString: after] mutableCopy] autorelease];
                selected = [[iTM2TextTABPlaceholder mutableCopy] autorelease];
                before = [[newBefore mutableCopy] autorelease];
            }
        }
    }
    [before replaceOccurrencesOfString:iTM2TextTABPlaceholder withString:tabAnchor
                                options: 0L range: NSMakeRange(0, [before length])];
    [selected replaceOccurrencesOfString:iTM2TextTABPlaceholder withString:tabAnchor
                                options: 0L range: NSMakeRange(0, [selected length])];
    [after replaceOccurrencesOfString:iTM2TextTABPlaceholder withString:tabAnchor
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  executeStringInstruction:
- (BOOL)executeStringInstruction:(NSString *)instruction;
/*"Description forthcoming. 
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([super executeStringInstruction:instruction])
	{
		return YES;
	}
	[self insertMacro:instruction];
//iTM2_END;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  handlesKeyStrokes
- (BOOL)handlesKeyStrokes;
/*"Description Forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- 2.0:Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return YES;
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

