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

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= NSString(iTM2TeXKit)


@interface NSString(iTM2TeXKit)
/*"Main methods"*/
+ (unichar)backslashCharacter;
+ (unichar)commentCharacter;
+ (unichar)bgroupCharacter;
+ (unichar)egroupCharacter;
+ (NSString *)backslashString;
+ (NSString *)commentString;
+ (NSString *)bgroupString;
+ (NSString *)egroupString;
- (void)getLineStart:(unsigned *)startPtr end:(unsigned *)lineEndPtr contentsEnd:(unsigned *)contentsEndPtr TeXComment:(unsigned *)commentPtr forIndex:(unsigned) index;
- (BOOL)isTeXCommentAtIndex:(unsigned)index;
- (BOOL)isControlAtIndex:(unsigned)index escaped:(BOOL *)aFlagPtr;
- (NSRange)groupRangeAtIndex:(unsigned)index;
- (NSRange)groupRangeAtIndex:(unsigned)index beginDelimiter:(unichar)bgroup endDelimiter:(unichar)egroup;
- (NSRange)groupRangeForRange:(NSRange)range;
- (NSRange)groupRangeForRange:(NSRange)range beginDelimiter:(unichar)bgroup endDelimiter:(unichar)egroup;
+ (NSString *)stringByStrippingTeXTagsInString:(NSString *)string;

/*!
    @method     iTM2_getWordBefore:here:after:atIndex:mode:
    @abstract   (brief description)
    @discussion All the string returned are autoreleased strings owned by no one.
    @param		beforePtr will hold on return the word before
    @param		herePtr will hold on return the word at the hit index
    @param		afterPtr will hold on return the word after
    @param		index is the character index where the click occurred
    @param		isSyncTeX is yes or no, depending on SyncTeX use
	@result		The character index in the word here of the very character indexed by index in the receiver.
*/
- (unsigned int)iTM2_getWordBefore:(NSString **)beforePtr here:(NSString **)herePtr after:(NSString **)afterPtr atIndex:(unsigned int)index mode:(BOOL)isSyncTeX;

@end

@interface iTM2TeXStringController: NSObject
+ (NSRange)TeXAwareWordRangeInAttributedString:(NSAttributedString *)theAttributedString atIndex:(unsigned)index;
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= NSString(iTeXMac2)