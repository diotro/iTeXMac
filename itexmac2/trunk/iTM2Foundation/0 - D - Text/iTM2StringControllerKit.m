/*
//
//  @version Subversion: $Id: iTM2StringControllerKit.m 750 2008-09-17 13:48:05Z jlaurens $ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Sat Jun 16 2001.
//  Copyright © 2001-2009 Laurens'Tribune. All rights reserved.
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
#import "iTM2LiteScanner.h"
#import "iTM2StringControllerKit.h"
#import "iTM2ContextKit.h"
#import "iTM2InstallationKit.h"

NSString * const iTM2TextIndentationStringKey= @"iTM2TextIndentationString";
NSString * const iTM2TextNumberOfSpacesPerTabKey= @"iTM2TextNumberOfSpacesPerTab";
NSString * const iTM2TextIndentationUsesTabsKey= @"iTM2TextIndentationUsesTabs";

@implementation NSObject(iTM2StringKit)
- (id)iTM2_stringController;
{
    return [iTM2StringController defaultController];
}
@end

@interface iTM2IndentationComponent:NSObject
{
    NSUInteger location;
    NSUInteger length;
    NSUInteger depth;
    NSUInteger commentLocation;
}
+ (id)indentationComponent;
- (NSUInteger)nextLocation;
@property NSUInteger location;
@property NSUInteger length;
@property NSUInteger depth;
@property NSUInteger commentLocation;
@end

@implementation iTM2IndentationComponent
+ (id)indentationComponent;
{
    iTM2IndentationComponent * new = [iTM2IndentationComponent new];
    new.location = 0;
    new.length = 0;
    new.commentLocation = NSNotFound;
    new.depth = 0;
    return new;
}
- (NSUInteger)nextLocation;
{
    return self.location + self.length;
}
@synthesize location;
@synthesize length;
@synthesize commentLocation;
@synthesize depth;
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
- (NSArray *)indentationStartingAtIndex:(NSUInteger)index levelChange:(NSInteger)change inString:(NSString *)aString;
/*! The returned array contains exactly 2 objects.
The first one is the original range to be modified.
The second one is the new string that should replace the old one.
*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(index>=[aString length])
        return [NSArray array];// nothing to do

    const NSUInteger numberOfSpacesPerTab = self.numberOfSpacesPerTab;
    NSAssert(numberOfSpacesPerTab>0,@"What the hell? This is a HUUUUUGE bug 1002.");

    NSMutableArray * result = [NSMutableArray array];
    
    NSUInteger pending = 0;

    iTM2IndentationComponent * component = [iTM2IndentationComponent indentationComponent];
    component.location = index;
    iTM2LiteScanner * S = [iTM2LiteScanner scannerWithString:aString];
    S.scanLocation = index;
next_character:
    if([S scanCommentSequence])
    {
        // the line starts with a comment
        // scan the string until there is enough material to record an indentation component
        // somehow this first indentation component will be unbreakable
        component.length = S.scanLocation - index;
        component.commentLocation = index;// commentLocation will not be used afterwards
        if(component.length>=numberOfSpacesPerTab)
        {
            // there is already enough material for a full indentation component
register_space_or_comment_indentation_component:
            component.depth = component.length / numberOfSpacesPerTab;
            pending = component.length % numberOfSpacesPerTab;// the last pending characters should pertain to the next indentation component
            component.length -= pending;// so remove them from the actual one (see above)
register_tab_indentation_component:
            [result addObject:component];
            component = [iTM2IndentationComponent indentationComponent];
            component.location = [[result lastObject] nextLocation];
            component.length = pending;
            pending = 0;
            NSAssert([component nextLocation] == S.scanLocation,@"MISSED string controller: 1");
            // then scan the string for the rest of the indentation prefix
next_loop:
            index = S.scanLocation;
            if([S scanCommentSequence] || [S scanCharacter:' '])
            {
did_scan_space_or_comment:
                component.length += S.scanLocation - index;
                if(component.length>=numberOfSpacesPerTab)
                {
                    goto register_space_or_comment_indentation_component;
                }
            }
            else if([S scanCharacter:'\t'])
            {
did_scan_tab:
                component.length += 1;
                component.depth = 1;
                pending = 0;
                goto register_tab_indentation_component;
            }
            if([S isAtEnd])
            {
                [result addObject:component];
                component = nil;
                return result;
            }
            else
            {
                goto next_loop;
            }
            // unreachable point
        }
        else
        {
            index = S.scanLocation;
            if([S scanCommentSequence] || [S scanCharacter:' '])
            {
                goto did_scan_space_or_comment;
            }
            else if([S scanCharacter:'\t'])
            {
                goto did_scan_tab;
            }
            else
            {
                // not enough material to create a full indentation component
                // however, we do return the comment sequence prefix
                if(component.length)
                {
                    [result addObject:component];
                }
                return result;
            }
            // unreachable point
        }
        // unreachable point
    }
    // the line does not start with a comment
    // scan until we find a comment sequence
    // this external loop will be executed as long as there are available spaces of tabs
    else if([S scanCharacter:'\t'])
    {
        component.length += 1;
        component.depth = 1;
register_uncommented_component:
        [result addObject:component];
        component = [iTM2IndentationComponent indentationComponent];
        component.location = S.scanLocation;
    }
    else if([S scanCharacter:' '])
    {
        component.length += 1;
        if(component.length==numberOfSpacesPerTab)
        {
            component.depth = 1;
            goto register_uncommented_component;
        }
    }
    // no space, no tab, no comment
//iTM2_END;
    goto next_character;
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

@implementation NSTextView(iTM2StringControllerKit)
- (id)iTM2_stringController;
{
    return [[[self layoutManager] textStorage] iTM2_stringController];
}

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  indentSelection:
- (void)indentSelection:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users.sourceforge.net
- 2.0:
To Do List: Nothing at first glance.
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSArray * selectedRanges = [self selectedRanges];
	NSSortDescriptor * SD = [[[NSSortDescriptor alloc] initWithKey:@"iTM2_locationValueOfRangeValue" ascending:YES] autorelease];
	NSArray * sortDescriptors = [NSArray arrayWithObject:SD];
	selectedRanges = [selectedRanges sortedArrayUsingDescriptors:sortDescriptors];
    // the selected ranges are now ordered according to the location

	NSMutableArray * replacementStrings = [NSMutableArray array];
	NSMutableArray * affectedRanges = [NSMutableArray array];
	NSMutableArray * newSelectedRanges = [NSMutableArray array];
    
	iTM2StringController * SC = [self iTM2_stringController];
	
	NSInteger off7 = 0;
	NSInteger changeInLength = 0;
    NSUInteger start, end;
	NSString * S = [self string];

    NSEnumerator * E = [selectedRanges objectEnumerator];
    NSValue * V;
	NSRange R;
    NSEnumerator * EE = nil;
	if(V = [E nextObject])
	{
        // the first iteration of the loop is very different from the other ones
		R = [V rangeValue];
		R.length = 0;
        // get the indexes for the first line of the selection
		[S getLineStart:&start end:&end contentsEnd:nil forRange:R];
        // get the indentation for this line
        NSArray * indentationComponents = [SC indentationStartingAtIndex:start levelChange:1 inString:S];
        EE = [indentationComponents objectEnumerator];
        NSString * prefix = nil;
        if((V = [EE nextObject]) && (prefix = [EE nextObject]))
        {
            [affectedRanges addObject:V];
            R = [V rangeValue];
            [replacementStrings addObject:prefix];
            changeInLength = [prefix length] - R.length;
            [newSelectedRanges addObject:[NSValue valueWithRange:NSMakeRange(start+off7,end-start+changeInLength)]];
            off7 += changeInLength;
        }
        while(V = [E nextObject])
        {
            R = [V rangeValue];
            if(R.location>=end)
            {
                R.length = 0;
                // get the indexes for the first line of the selection
                [S getLineStart:&start end:&end contentsEnd:nil forRange:R];
                // get the indentation for this line
                NSArray * indentationComponents = [SC indentationStartingAtIndex:start levelChange:1 inString:S];
                EE = [indentationComponents objectEnumerator];
                NSString * prefix = nil;
                if((V = [EE nextObject]) && (prefix = [EE nextObject]))
                {
                    [affectedRanges addObject:V];
                    [replacementStrings addObject:prefix];
                    changeInLength = [prefix length] - R.length;
                    [newSelectedRanges addObject:[NSValue valueWithRange:NSMakeRange(start+off7,end-start+changeInLength)]];
                    off7 += changeInLength;
                }
            }
        }
        if([affectedRanges count] && [self shouldChangeTextInRanges:affectedRanges replacementStrings:replacementStrings])
        {
            E  = [affectedRanges reverseObjectEnumerator];
            NSEnumerator * EE = [replacementStrings reverseObjectEnumerator];
            while(V = [E nextObject])
            {
                if(S = [EE nextObject])
                {
                    R = [V rangeValue];
                    [self replaceCharactersInRange:R withString:S];
                }
                else
                {
                    iTM2_LOG(@"**** There is an awful BUG, affectedRanges and replacementStrings are not consistent...");
                }
            }
            [self didChangeText];
            R = [self selectedRange];
            if(!R.length)
            {
                if([selectedRanges count]>1)
                {
                    [self setSelectedRanges:newSelectedRanges];
                }
                else if(V = [selectedRanges lastObject])
                {
                    R = [V rangeValue];
                    if(R.length)
                    {
                        [self setSelectedRanges:newSelectedRanges];
                    }
                }
            }
        }
    }
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  indentSelection:
- (void)do_indentSelection:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users.sourceforge.net
- 2.0:
To Do List: Nothing at first glance.
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSArray * selectedRanges = [self selectedRanges];
	NSSortDescriptor * SD = [[[NSSortDescriptor alloc] initWithKey:@"iTM2_locationValueOfRangeValue" ascending:YES] autorelease];
	NSArray * sortDescriptors = [NSArray arrayWithObject:SD];
	selectedRanges = [selectedRanges sortedArrayUsingDescriptors:sortDescriptors];

	NSMutableArray * replacementStrings = [NSMutableArray array];
	NSMutableArray * affectedRanges = [NSMutableArray array];
	NSMutableArray * newSelectedRanges = [NSMutableArray array];
	NSUInteger off7 = 0;
	
	NSString * indentationPrefix = [[self iTM2_stringController] stringWithIndentationLevel:1 atIndex:0 inString:@""];
	NSEnumerator * E = [selectedRanges objectEnumerator];
	NSValue * V;
	NSRange range, searchRange,foundRange;
	NSUInteger start, end, contentsEnd,top;
	NSString * S = [self string];
	NSCharacterSet * blackCharacterSet = [NSCharacterSet whitespaceCharacterSet];
	blackCharacterSet = [blackCharacterSet invertedSet];
	NSString * whitePrefix;
	NSString * normalizedPrefix;
	for(V in selectedRanges)
	{
		range = [V rangeValue];
		top = NSMaxRange(range);
		searchRange = range;
		searchRange.length = 0;
		[S getLineStart:&start end:&end contentsEnd:&contentsEnd forRange:searchRange];
nextLine:
		searchRange = NSMakeRange(start,contentsEnd-start);
		foundRange = [S rangeOfCharacterFromSet:blackCharacterSet options:0L range:searchRange];
		if(foundRange.length)
		{
			searchRange.length = foundRange.location - searchRange.location;
			whitePrefix = [S substringWithRange:searchRange];
			normalizedPrefix = [[self iTM2_stringController] stringByNormalizingIndentationInString:whitePrefix];
			if([whitePrefix isEqual:normalizedPrefix])
			{
				searchRange.length = 0;
				whitePrefix = indentationPrefix;
			}
			else
			{
				whitePrefix = [indentationPrefix stringByAppendingString:normalizedPrefix];
			}
			V = [NSValue valueWithRange:searchRange];
			if(![affectedRanges containsObject:V])
			{
				[affectedRanges addObject:V];
				[replacementStrings addObject:whitePrefix];
				range = NSMakeRange(start,end-start);
				range.location += off7;
				range.length += [whitePrefix length];
				off7 += [whitePrefix length];
				V = [NSValue valueWithRange:range];
				[newSelectedRanges addObject:V];
			}
		}
		if(end<top)
		{
			start = end;
			searchRange.location = start;
			searchRange.length = 0;
			[S getLineStart:nil end:&end contentsEnd:&contentsEnd forRange:searchRange];
			goto nextLine;
		}
	}

	if([affectedRanges count] && [self shouldChangeTextInRanges:affectedRanges replacementStrings:replacementStrings])
	{
		E = [affectedRanges reverseObjectEnumerator];
		NSEnumerator * EE = [replacementStrings reverseObjectEnumerator];
		while(V = [E nextObject])
		{
			if(S = [EE nextObject])
			{
				range = [V rangeValue];
				[self replaceCharactersInRange:range withString:S];
			}
			else
			{
				iTM2_LOG(@"**** There is an awful BUG, affectedRanges and replacementStrings are not consistent...");
			}
		}
		[self didChangeText];
		range = [self selectedRange];
		if(!range.length)
		{
			if([selectedRanges count]>1)
			{
				[self setSelectedRanges:newSelectedRanges];
			}
			else if(V = [selectedRanges lastObject])
			{
				range = [V rangeValue];
				if(range.length)
				{
					[self setSelectedRanges:newSelectedRanges];
				}
			}
		}
	}

//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  unindentSelection:
- (void)unindentSelection:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users.sourceforge.net
- < 1.1: 03/10/2002
To Do List: Nothing at first glance.
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSArray * selectedRanges = [self selectedRanges];
	NSSortDescriptor * SD = [[[NSSortDescriptor alloc] initWithKey:@"iTM2_locationValueOfRangeValue" ascending:YES] autorelease];
	NSArray * sortDescriptors = [NSArray arrayWithObject:SD];
	selectedRanges = [selectedRanges sortedArrayUsingDescriptors:sortDescriptors];

	NSMutableArray * replacementStrings = [NSMutableArray array];
	NSMutableArray * affectedRanges = [NSMutableArray array];
	NSMutableArray * newSelectedRanges = [NSMutableArray array];
	NSUInteger off7 = 0;
	
	NSValue * V;
	NSRange range, searchRange,foundRange;
	NSUInteger start, end, contentsEnd,top;
	NSString * S = [self string];
	NSCharacterSet * blackCharacterSet = [NSCharacterSet whitespaceCharacterSet];
	blackCharacterSet = [blackCharacterSet invertedSet];
	NSString * whitePrefix;
	NSString * newPrefix;
	NSUInteger indentationLevel;
	for(V in selectedRanges)
	{
		range = [V rangeValue];
		top = NSMaxRange(range);
		searchRange = range;
		searchRange.length = 0;
		[S getLineStart:&start end:&end contentsEnd:&contentsEnd forRange:searchRange];
nextLine:
		searchRange = NSMakeRange(start,contentsEnd-start);
		foundRange = [S rangeOfCharacterFromSet:blackCharacterSet options:0L range:searchRange];
		if(foundRange.length)
		{
			searchRange.length = foundRange.location - searchRange.location;
			whitePrefix = [S substringWithRange:searchRange];
			indentationLevel = [[self iTM2_stringController] indentationLevelAtIndex:0 inString:whitePrefix];
			if(indentationLevel--)
			{
				newPrefix = [[self iTM2_stringController] stringWithIndentationLevel:indentationLevel atIndex:0 inString:whitePrefix];
				if([whitePrefix hasSuffix:newPrefix])
				{
					searchRange.length = [whitePrefix length] - [newPrefix length];
					newPrefix = @"";
				}
				else
				{
					searchRange.length = [whitePrefix length];
				}
				V = [NSValue valueWithRange:searchRange];
				if(![affectedRanges containsObject:V])
				{
					[affectedRanges addObject:V];
					[replacementStrings addObject:newPrefix];
					range = NSMakeRange(start,end-start);
					range.location -= off7;
					searchRange.length -= [newPrefix length];
					range.length -= searchRange.length;
					off7 += searchRange.length;
					V = [NSValue valueWithRange:range];
					[newSelectedRanges addObject:V];
				}
			}
		}
		if(end<top)
		{
			start = end;
			searchRange.location = start;
			searchRange.length = 0;
			[S getLineStart:nil end:&end contentsEnd:&contentsEnd forRange:searchRange];
			goto nextLine;
		}
	}
	
	if([affectedRanges count] && [self shouldChangeTextInRanges:affectedRanges replacementStrings:replacementStrings])
	{
		NSEnumerator * E = [affectedRanges reverseObjectEnumerator];
		NSEnumerator * EE = [replacementStrings reverseObjectEnumerator];
		while(V = [E nextObject])
		{
			if(S = [EE nextObject])
			{
				range = [V rangeValue];
				[self replaceCharactersInRange:range withString:S];
			}
			else
			{
				iTM2_LOG(@"**** There is an awful BUG, affectedRanges and replacementStrings are not consistent...");
			}
		}
		[self didChangeText];
		range = [self selectedRange];
		if(!range.length)
		{
			if([selectedRanges count]>1)
			{
				[self setSelectedRanges:newSelectedRanges];
			}
			else if(V = [selectedRanges lastObject])
			{
				range = [V rangeValue];
				if(range.length)
				{
					[self setSelectedRanges:newSelectedRanges];
				}
			}
		}
	}

//iTM2_END;
    return;
}

@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2StringControllerKit

