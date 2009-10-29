/*
//
//  @version Subversion: $Id: iTM2StringKit.m 750 2008-09-17 13:48:05Z jlaurens $ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Sat Jun 16 2001.
//  Copyright © 2001-2004 Laurens'Tribune. All rights reserved.
//
//  This program is free software; you can redistribute it and/or modify it under the terms
//  of the GNU General Public License as published by the Free Software Foundation; either
//  version 2 of the License, or any later version.
//  This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
//  without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
//  See the GNU General Public License for more details. You should have received a copy
//  of the GNU General Public License along with this program; if not, write to the Free Software
//  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
//  GPL addendum: Any simple modification of the present code which purpose is to remove bug,
//  improve efficiency in both code execution and code reading or writing should be addressed
//  to the actual developper team.
*/

#import "ICURegEx.h"
#import "iTM2StringKit.h"
#import "iTM2StringController.h"
#import "iTM2ContextKit.h"
#import "iTM2InstallationKit.h"

NSString * const iTM2TextIndentationStringKey= @"iTM2TextIndentationString";
NSString * const iTM2TextNumberOfSpacesPerTabKey= @"iTM2TextNumberOfSpacesPerTab";
NSString * const iTM2TextIndentationUsesTabsKey= @"iTM2TextIndentationUsesTabs";

@implementation NSTextView(iTM2StringKit)
- (id)iTM2_stringController;
{
    return [[[self layoutManager] textStorage] iTM2_stringController];
}
@end

@implementation NSObject(iTM2StringKit)
- (id)iTM2_stringController;
{
    return [iTM2StringController defaultController];
}
@end

iTM2StringController * _iTM2StringController = nil;
@implementation iTM2StringController
+ (void)initialize;
{
	[SUD registerDefaults:
		 [NSDictionary dictionaryWithObjectsAndKeys:
            @"	", iTM2TextIndentationStringKey,
            [NSNumber numberWithUnsignedInteger:4], iTM2TextNumberOfSpacesPerTabKey,
                nil]];
    _iTM2StringController = [[self alloc] init];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= bullet
- (NSString *)bullet;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	return @"\xE2\x80\xA2";//"•"
}
+ (id)defaultController;
{
    return _iTM2StringController;
}
- (void)setUpMacroTypes;
{
    NSString * path = [[NSBundle bundleForClass:[self class]]
        pathForResource:@"iTM2StringControllerMacroTypes" ofType:@"plist"];
    NSAssert(path,@"iTM2 would not work properly w/o macro types. Missing foundation resources, please report bug.");
    self->_macroTypes = [NSArray arrayWithContentsOfURL:[NSURL fileURLWithPath:path]];
}
- (id)initWithDelegate:(id)delegate;
{
    if(self=[super init])
    {
        [self setUpMacroTypes];
        self.delegate = delegate?:self;
    }
    return self;
}
- (NSUInteger)indentationLevelStartingAtIndexRef:(NSUInteger *)indexRef isComment:(BOOL *)yornRef inString:(NSString *)aString;
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSParameterAssert(indexRef);
    NSUInteger numberOfSpacesPerTab = self.numberOfSpacesPerTab;
	NSUInteger result = 0;
	NSUInteger numberOfSpaces = 0;
    NSUInteger index = 1;
	while(*indexRef<[aString length])
	{
		unichar theChar = [aString characterAtIndex:*indexRef];
		if(theChar == ' ')
		{
			++numberOfSpaces;
		}
		else if(theChar == '\t')
		{
			++result;
			result += numberOfSpaces/numberOfSpacesPerTab;
			numberOfSpaces = 0;
		}
		else
		{
            index = *indexRef;
            if([self isStartingCommentSequenceAtIndexRef:&index inString:aString])
            {
                index -= *indexRef;
                numberOfSpaces += index;
            }
            else
            {
                break;
            }
		}
        *indexRef+=index;
	}
	result += numberOfSpaces/numberOfSpacesPerTab;
//iTM2_END;
	return result;
}
- (NSArray *)indentationComponentsStartingAtIndex:(NSUInteger)index inString:(NSString *)aString;
/*! The returned array contains 2*N paired elements.
The first object is a number containing the length of the original indentation component.
The second object is the indentation component as it should appear.
For example, if the string is @"\t" and indentation uses tabs with 4 spaces by tab,
the returned array contains 2 objects, one with "1" as unsigned integer value,
the other one being @"    "
We force the comment characters to be at the beginning of the line
*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    const NSUInteger numberOfSpacesPerTab = self.numberOfSpacesPerTab;
    NSAssert(numberOfSpacesPerTab>0,@"What the hell? This is a HUUUUUGE bug 1002.");
	NSMutableArray * result = [NSMutableArray array];
	NSUInteger numberOfCharacters = 0;
	NSUInteger numberOfCharactersToSkip = 0;
    BOOL shouldSkipSpaces = YES;
    NSUInteger firstUncopiedCharIndex = 0;
    NSString * commentSequence = nil;
    NSString * const indentationString = self.indentationString;
    while(index<[aString length])
	{
		unichar theChar = [aString characterAtIndex:index];
		if(theChar == ' ')
		{
            ++index;
            if(shouldSkipSpaces)
                ++numberOfCharactersToSkip;
			if(++numberOfCharacters==numberOfSpacesPerTab)
            {
nextComponent:
                [result addObject:[NSNumber numberWithUnsignedInteger:index-firstUncopiedCharIndex]];
                [result addObject:indentationString];
                firstUncopiedCharIndex = index;
                numberOfCharacters = numberOfCharactersToSkip = 0;
                shouldSkipSpaces = YES;
            }
            continue;
 		}
		if(theChar == '\t')
		{
            ++index;
            goto nextComponent;
		}
		else
		{
            NSUInteger idx = index;
            if([self isStartingCommentSequenceAtIndexRef:&index inString:aString])
            {
                numberOfCharacters += index-idx;
                if(commentSequence)
                {
                    numberOfCharactersToSkip += index-idx;
                }
                else
                {
                    commentSequence = [aString substringWithRange:NSMakeRange(idx,index-idx)];
                }
                shouldSkipSpaces = NO;
                if(numberOfCharacters>=numberOfSpacesPerTab)
                {
                    goto nextComponent;
                }
            }
            else
            {
                break;
            }
		}
    }
    if([result count])
    {
        if([commentSequence length])
        {
            id component = [NSMutableString stringWithString:[result objectAtIndex:1]];
            if([component length]>[commentSequence length])
            {
                [component replaceCharactersInRange:NSMakeRange(0,[commentSequence length]) withString:commentSequence];
            }
            else if([component length]>1) // this is not a tab
            {
                component = commentSequence;
            }
            else
            {
                [component replaceCharactersInRange:NSMakeRange(0,0) withString:commentSequence];
            }
            [result replaceObjectAtIndex:1 withObject:component];
        }
        if(index>firstUncopiedCharIndex) {
            [result addObject:[NSNumber numberWithUnsignedInteger:index-firstUncopiedCharIndex]];
            [result addObject:@""];
            firstUncopiedCharIndex = index;
        }
    }
    else if(numberOfCharactersToSkip)
    {
        [result addObject:[NSNumber numberWithUnsignedInteger:numberOfCharactersToSkip]];
        [result addObject:@""];
    }
//iTM2_END;
	return result;
}
- (NSUInteger)indentationLevelAtIndex:(NSUInteger)index isComment:(BOOL *)yornRef inString:(NSString *)aString;
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [aString getLineStart:&index end:nil contentsEnd:nil forRange:NSMakeRange(index,0)];
	return [self indentationLevelStartingAtIndexRef:&index isComment:yornRef inString:aString];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= stringByNormalizingIndentationInString:
- (NSString *)stringByNormalizingIndentationInString:(NSString *)aString;
/*"Description forthcoming.
 Version history: jlaurens AT users.sourceforge.net
 - 2.0: 
 To Do List: ?
 "*/
{iTM2_DIAGNOSTIC;
	//iTM2_START;
	NSArray * lineComponents = [aString iTM2_lineComponents];
	NSMutableArray * normalizedComponents = [NSMutableArray arrayWithCapacity:[lineComponents count]];
	for(NSString * line in lineComponents)
	{
        NSArray * indentationComponents = [self indentationComponentsStartingAtIndex:0 inString:line];
        NSEnumerator * E = [indentationComponents objectEnumerator];
        NSNumber * N = nil;
        NSString * component = nil;
        NSUInteger charIndex = 0;
        while((N = [E nextObject]) && (component = [E nextObject]))
        {
            charIndex += [N unsignedIntegerValue];
            [normalizedComponents addObject:component];
        }
        if(charIndex<[line length])
        {
            NSString * tail = [line substringFromIndex:charIndex];
            [normalizedComponents addObject:tail];
        }
	}
	//iTM2_END;
	return [normalizedComponents componentsJoinedByString:@""];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= stringWithIndentationLevel:atIndex:inString:
- (NSString *)stringWithIndentationLevel:(NSUInteger)indentation atIndex:(NSUInteger)index inString:(NSString *)aString;
/*"Description forthcoming.
 Version history: jlaurens AT users.sourceforge.net
 - 2.0: 02/15/2006
 To Do List: ?
 "*/
{iTM2_DIAGNOSTIC;
	//iTM2_START;
    NSUInteger numberOfSpacesPerTab = self.numberOfSpacesPerTab;
	NSMutableString * result = [NSMutableString string];
	NSRange lineRange = NSMakeRange(index,0);
	lineRange = [aString lineRangeForRange:lineRange];// the line range containing the given index
	NSString * string = [aString substringToIndex:lineRange.location];// everything before the line
	[result appendString:string];// copied as is
	// now append the expected indentation for the line containing index
	NSString * tabString = nil;
	NSUInteger idx = numberOfSpacesPerTab;
	if(idx<=0)
	{
		tabString = @"\t";
	}
	else
	{
		NSMutableString * MS = [NSMutableString string];
		while(idx--)
		{
			[MS appendString:@" "];
		}
		tabString = [MS copy];
	}
	while(indentation--)
	{
		[result appendString:tabString];
	}
	// now copying the line without its white prefix
	NSUInteger top = NSMaxRange(lineRange);
	NSCharacterSet * whiteSet = [NSCharacterSet whitespaceCharacterSet];
	while(lineRange.location<top)
	{
		unichar theChar = [aString characterAtIndex:lineRange.location];
		if(![whiteSet characterIsMember:theChar])
		{
			break;
		}
		++lineRange.location;
	}
	lineRange.length = top - lineRange.location;
	string = [aString substringWithRange:lineRange];
	[result appendString:string];
	// finally copy the rest of the receiver as is
	string = [aString substringFromIndex:top];
	[result appendString:string];
	//iTM2_END;
	return result;
}
- (unichar)standaloneCharacterAtIndex:(NSUInteger)index inString:(NSString *)aString;
{
    NSRange R = [aString rangeOfComposedCharacterSequenceAtIndex:index];
    if(R.length!=1 || [self isEscapedCharacterAtIndex:index inString:aString])
        return 0;
    return [aString characterAtIndex:index];
}
- (BOOL)isEscapedCharacterAtIndex:(NSUInteger)index inString:(NSString *)aString;
{
    return index>0 && [self isControlCharacterAtIndex:index-1 inString:aString];
}
- (BOOL)isControlCharacterAtIndex:(NSUInteger)index inString:(NSString *)aString;
{
    return [aString characterAtIndex:index] == '\\'
        && ![self isEscapedCharacterAtIndex:index inString:aString];
}
- (BOOL)isCommentCharacterAtIndex:(NSUInteger)index inString:(NSString *)aString;
{
    return [aString characterAtIndex:index] == '%'
        && ![self isEscapedCharacterAtIndex:index inString:aString];
}
- (BOOL)isStartingCommentSequenceAtIndexRef:(NSUInteger *)indexRef inString:(NSString *)aString;
{
    NSParameterAssert(indexRef != NULL);
    return [self isCommentCharacterAtIndex:*indexRef inString:aString]?++(*indexRef),YES:NO;
}
-(BOOL)usesTabs;
{
    return [self contextBoolForKey:iTM2TextIndentationUsesTabsKey domain:iTM2ContextAllDomainsMask];
}
-(void)setUsesTabs:(BOOL)new;
{
    return [self takeContextBool:new forKey:iTM2TextIndentationUsesTabsKey domain:iTM2ContextStandardMask];
}
-(NSUInteger)numberOfSpacesPerTab;
{
    return [self contextUnsignedIntegerForKey:iTM2TextNumberOfSpacesPerTabKey domain:iTM2ContextAllDomainsMask];
}
-(void)setNumberOfSpacesPerTab:(NSUInteger)new;
{
    return [self takeContextUnsignedInteger:new forKey:iTM2TextNumberOfSpacesPerTabKey domain:iTM2ContextStandardMask];
}
- (id)currentContextManager;
{
    return self.delegate;
}
- (NSString *)indentationString;
{
    if(self.usesTabs) return @"\t";
    NSMutableDictionary * cache = nil;
    NSUInteger numberOfSpacesPerTab = self.numberOfSpacesPerTab;
    NSNumber * K = [NSNumber numberWithUnsignedInteger:numberOfSpacesPerTab];
    id V = [cache objectForKey:K];
    if(V)
    {
        return V;
    }
    if(!cache)
    {
        cache = [NSMutableDictionary dictionary];
    }
    V = [NSMutableString stringWithCapacity:numberOfSpacesPerTab];
    while(numberOfSpacesPerTab--)
    {
        [V appendString:@" "];
    }
    [cache setObject:V forKey:K];
    return V;
}
- (NSString *)commentString;
{
    return @"%";
}
@synthesize macroTypes=_macroTypes;
@synthesize delegate=_delegate;
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= NSString(iTeXMac2)

