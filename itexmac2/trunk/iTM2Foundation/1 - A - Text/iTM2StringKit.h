/*
//
//  @version Subversion: $Id$ 
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

extern NSString * const iTM2UDTabAnchorStringKey;

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= NSString(iTeXMac2)

@interface NSString(iTeXMac2)
/*"Class methods"*/
+ (NSString *)bullet;
/*"Setters and Getters"*/
- (BOOL)getIntegerTrailer:(int *)intPtr;
- (NSRange)rangeForLine:(unsigned int)aLine nextLine:(unsigned int *)aNextLinePtr;
- (NSRange)rangeForLineRange:(NSRange)aLineRange nextLine:(unsigned int *)aNextLinePtr;
- (NSRange)rangeContentForLine:(unsigned int)aLine nextLine:(unsigned int *)aNextLinePtr;
- (unsigned)lineForRange:(NSRange)aRange;
- (unsigned)numberOfLines;
//- (NSString *) commentedStringForKey: (NSString *) aKey value: (NSString *) aValue;
- (NSString *)stringForCommentedKey:(NSString *)aKey forRange:(NSRange)aRange effectiveRange:(NSRangePointer)aRangePtr inHeader:(BOOL)aFlag;
- (NSString *)stringByRemovingTrailingWhites;
- (NSString*)stringWithSubstring:(NSString*)oldString replacedByString:(NSString*)newString;
- (int)compareUsingLastPathComponent:(NSString *)rhs;
/*"Main methods"*/
- (NSRange)rangeBySelectingParagraphIfNeededWithRange:(NSRange)range;
- (NSRange)doubleClickAtIndex:(unsigned)index;
/*!
    @method     rangeOfWordAtIndex:
    @abstract   The range of the word containing the character at the given index
    @discussion A word is a sequence of letters, possibly accented, numbers but no other characters
				If there is a white space or new line character at the given index,
				the first word range to the right is returned, if any.
				If there is another kind of characters at the given index,
				a 0 length word range at that index is returned because there is no word.
    @param		index
    @result     a range
*/
- (NSRange)rangeOfWordAtIndex:(unsigned int)index;

/*!
    @method     wordRangeForRange:
    @abstract   The range of the word containing the characters from the given range
    @discussion A word is a sequence of letters, possibly accented, numbers but no other characters.
				This methods extends the given range from both sides,
				as long as acceptable characters are found.
    @param		wordRange
    @result     a range
*/
- (NSRange)wordRangeForRange:(NSRange)wordRange;

/*!
    @method     rangeOfWord:options:range:
    @abstract   Find a word
    @discussion The first occurrence of a given word in the given range.
				The word is meant in the sense of rangeOfWordAtIndex:
    @param		aWord is the word to be found
    @param		mask: the same for rangeOfString:options:range:
    @param		searchRange: the same for rangeOfString:options:range:
    @result     a range
*/
- (NSRange)rangeOfWord:(NSString *)aWord options:(unsigned)mask range:(NSRange)searchRange;

- (NSArray *)componentsSeparatedByStrings:(NSString *)separator, ...;// nil or non NSString terminated list or arguments
/*"Overriden methods"*/
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= NSString(iTeXMac2)
