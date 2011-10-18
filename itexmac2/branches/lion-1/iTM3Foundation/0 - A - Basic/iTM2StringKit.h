/*
//
//  @version Subversion: $Id: iTM2StringKit.h 750 2008-09-17 13:48:05Z jlaurens $ 
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

#import <Foundation/NSString.h>

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= NSString(iTeXMac2)

@interface NSString(iTeXMac2)
/*"Class methods"*/

/*!
    @method     stringWithUUID4iTM3
    @abstract   Unique string
    @discussion Better than process info globally unique string.
                See https://gist.github.com/486765
    @param		None
    @result     a string
*/
+ (NSString*)stringWithUUID4iTM3;

/*"Setters and Getters"*/
- (BOOL)getIntegerTrailer4iTM3:(NSInteger *)intPtr;
- (NSRange)getRangeForLine4iTM3:(NSUInteger)aLine;
- (NSRange)getRangeForLine4iTM3Range:(NSRange)aLineRange;
- (NSUInteger)lineIndexForLocation4iTM3:(NSUInteger)index;
- (NSUInteger)numberOfLines4iTM3;
//- (NSString *) commentedStringForKey: (NSString *) aKey value: (NSString *) aValue;
- (NSString *)stringForCommentedKey4iTM3:(NSString *)aKey forRange:(NSRange)aRange effectiveRange:(NSRangePointer)aRangePtr inHeader:(BOOL)aFlag;
- (NSString *)stringByRemovingTrailingWhites4iTM3;
- (NSString*)stringWithSubstring4iTM3:(NSString*)oldString replacedByString:(NSString*)newString;
- (NSComparisonResult)compareUsingLastPathComponent4iTM3:(NSString *)rhs;
/*"Main methods"*/
- (NSRange)rangeBySelectingParagraphIfNeededWithRange4iTM3:(NSRange)range;
- (NSRange)doubleClickAtIndex:(NSUInteger)index;
/*!
    @method     rangeOfWordAtIndex4iTM3:
    @abstract   The range of the word containing the character at the given index
    @discussion A word is a sequence of letters, possibly accented, numbers but no other characters
				If there is a white space or new line character at the given index,
				the first word range to the right is returned, if any.
				If there is another kind of characters at the given index,
				a 0 length word range at that index is returned because there is no word.
    @param		index
    @result     a range
*/
- (NSRange)rangeOfWordAtIndex4iTM3:(NSUInteger)index;

/*!
    @method     wordRangeForRange4iTM3:
    @abstract   The range of the word containing the characters from the given range
    @discussion A word is a sequence of letters, possibly accented, numbers but no other characters.
				This methods extends the given range from both sides,
				as long as acceptable characters are found.
    @param		wordRange
    @result     a range
*/
- (NSRange)wordRangeForRange4iTM3:(NSRange)wordRange;

/*!
    @method     rangeOfWord:options:range:
    @abstract   Find a word
    @discussion The first occurrence of a given word in the given range.
				The word is meant in the sense of rangeOfWordAtIndex4iTM3:
    @param		aWord is the word to be found
    @param		mask: the same for rangeOfString:options:range:
    @param		searchRange: the same for rangeOfString:options:range:
    @result     a range
*/
- (NSRange)rangeOfWord:(NSString *)aWord options:(NSUInteger)mask range:(NSRange)searchRange;

- (NSArray *)componentsSeparatedByStrings4iTM3:(NSString *)separator, ...;// nil or non NSString terminated list or arguments
/*"Overriden methods"*/

/*  Levenshtein distance between the receiver and the given word */
- (NSUInteger)editDistanceToString4iTM3:(NSString *)aString;

- (NSString *)stringByEscapingPerlControlCharacters4iTM3;

/*!
 @method		lineComponents4iTM3
 @abstract	Abstract forthcoming.
 @discussion	Discussion forthcoming.
 @param		None.
 @result     NSArray, receiver split into lines
 */
- (NSArray *)lineComponents4iTM3;

/*!
 @method		lastCharacter4iTM3
 @abstract      Abstract forthcoming.
 @discussion	Discussion forthcoming.
 @param         None.
 @result        unichar or 0
 */
- (unichar)lastCharacter4iTM3;

@end

@interface NSMutableString(iTM2StringKit)

/*!
 @method		prependString4iTM3:
 @abstract      Abstract forthcoming.
 @discussion	Discussion forthcoming.
 @param         None.
 @result        a string
 */
- (void)prependString4iTM3:(NSString *)aString;

@end

@interface NSTextStorage(iTM2StringKit)
/*"Class methods"*/
/*"Setters and Getters"*/
- (NSUInteger)lineIndexForLocation4iTM3:(NSUInteger)index;
- (void)getLineStart:(NSUInteger *)startPtr end:(NSUInteger *)lineEndPtr contentsEnd:(NSUInteger *)contentsEndPtr forRange:(NSRange)range;
- (NSRange)getRangeForLine4iTM3:(NSUInteger)aLine;
- (NSRange)getRangeForLine4iTM3Range:(NSRange)aLineRange;
- (NSUInteger)length;
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= NSString(iTeXMac2)
