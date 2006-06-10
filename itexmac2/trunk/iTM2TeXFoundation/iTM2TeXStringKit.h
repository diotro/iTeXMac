/*
//  iTM2TeXStringKit.h
//  iTeXMac2
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

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= NSString(iTM2TeXKit)


@interface NSString(iTM2TeXKit)
/*"Main methods"*/
+ (unichar) backslashCharacter;
+ (unichar) commentCharacter;
+ (unichar) bgroupCharacter;
+ (unichar) egroupCharacter;
+ (NSString *) backslashString;
+ (NSString *) commentString;
+ (NSString *) bgroupString;
+ (NSString *) egroupString;
- (void) getLineStart: (unsigned *) startPtr end: (unsigned *) lineEndPtr contentsEnd: (unsigned *) contentsEndPtr TeXComment: (unsigned *) commentPtr forIndex:(unsigned) index;
- (BOOL) isTeXCommentAtIndex: (unsigned) index;
- (BOOL) isControlAtIndex: (unsigned) index escaped: (BOOL *) aFlagPtr;
- (NSRange) groupRangeAtIndex: (unsigned) index;
- (NSRange) groupRangeAtIndex: (unsigned) index beginDelimiter: (unichar) bgroup endDelimiter: (unichar) egroup;
- (NSRange) groupRangeForRange: (NSRange) range;
- (NSRange) groupRangeForRange: (NSRange) range beginDelimiter: (unichar) bgroup endDelimiter: (unichar) egroup;
/*!
    @method     TeXAwareDoubleClick:atIndex:
    @abstract   A TeX Aware doubleClickAtIndex: like method
    @discussion The TeX aware range to be selected when double clicking the given string at the given index
				This is not a NSString instance method to allow dynamic overriding...
    @param		string is the target
    @param		index is the character index where the click occurred
	@result		None
*/
+ (NSRange) TeXAwareDoubleClick: (NSString *) string atIndex: (unsigned) index;
+ (NSString *) stringByStrippingTeXTagsInString: (NSString *) string;

/*!
    @method     getWordBefore:here:after:atIndex:
    @abstract   (brief description)
    @discussion All the string returned are autoreleased strings owned by no one.
    @param		string is the target
    @param		index is the character index where the click occurred
	@result		The character index in the word here of the very character indexed by index in the receiver.
*/
- (unsigned int) getWordBefore: (NSString **) beforePtr here: (NSString **) herePtr after: (NSString **) afterPtr atIndex: (unsigned int) index;

@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= NSString(iTeXMac2)