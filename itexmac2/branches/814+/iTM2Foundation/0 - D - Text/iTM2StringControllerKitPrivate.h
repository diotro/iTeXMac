/*
//
//  @version Subversion: $Id: iTM2StringControllerKitPrivate.h 750 2008-09-17 13:48:05Z jlaurens $ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Thu Nov  5 10:20:15 UTC 2009.
//  Copyright © 2009 Laurens'Tribune. All rights reserved.
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

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2StringController

@interface iTM2StringController(PRIVATE)

/*!
	@method		_indentationComponentsInString:atIndex:
	@abstract	Abstract forthcoming.
	@discussion	Private.
	@param		index.
	@param		aString.
    @result     a mutable array of private objects.
*/
- (NSMutableArray *)_indentationComponentsInString:(NSString *)aString atIndex:(NSUInteger)index;
- (NSMutableArray *)_indentationComponentsInString:(NSString *)aString atIndex:(NSUInteger)index beforeIndex:(NSUInteger)before;

- (NSString *)stringComplementForLength:(NSUInteger)length;
- (NSString *)indentationStringWithDepth:(NSUInteger)depth;

- (BOOL)_remove:(NSUInteger)level indentationComponentsIn:(NSMutableArray *)ICs;

- (NSInteger)_prepareIndentationAtIndex:(NSUInteger)start inString:(NSString *)S withReplacementString:(NSMutableArray *)replacementStrings affectedRanges:(NSMutableArray *)affectedRanges;
- (NSInteger)__prepareIndentationChange:(NSUInteger)change atIndex:(NSUInteger)start inString:(NSString *)S withReplacementString:(NSMutableArray *)replacementStrings affectedRanges:(NSMutableArray *)affectedRanges;
- (NSInteger) _prepareIndentationChange:(NSInteger)change atIndex:(NSUInteger)start inString:(NSString *)S withReplacementString:(NSMutableArray *)replacementStrings affectedRanges:(NSMutableArray *)affectedRanges indentations:(NSArray *)ICs inString:(NSString *)reference;

- (void)getIndentationComponents:(NSMutableArray **)ICsBeforeRef:(NSMutableArray**)ICsAfterRef withScanner:(iTM2LiteScanner *)LS;
- (NSInteger)getIndentationComponents:(NSMutableArray **)actualICsRef:(NSString **)actualSRef available:(NSArray *)avalableICs:(NSString *)availableS changeInDepth:(NSInteger)deltaDepth;
- (void)getIndentationPrefix:(NSString **)stringRef:(NSRangePointer)affectedRangeRef change:(NSUInteger)changeInDepth inString:(NSString *)actualS:(NSUInteger)actualIndex availablePrefix:(NSString *)availableS:(NSUInteger)availableIndex;
- (void)getUnindentationPrefix:(NSString **)stringRef:(NSRangePointer)affectedRangeRef change:(NSUInteger)changeInDepth inString:(NSString *)actualS:(NSUInteger)actualIndex;

@end

// private object
@interface _iTM2IndentationComponent:NSObject
@property (readonly) NSUInteger depth;
@property (readonly) NSUInteger whiteDepth;
@property (readonly) NSUInteger location;
@property (readonly) NSUInteger commentLocation;
@property (readonly) NSUInteger nextLocation;
@property (readonly) NSUInteger length;
@property (readonly) NSUInteger contentLength;
@property (readonly) NSUInteger commentLength;
@property (readonly) NSUInteger blackLength;
@property (readonly) NSUInteger afterLength;
@property (readonly) BOOL endsWithTab;
@property (readonly) BOOL shouldRemainAtTheEnd;
@property (readonly) NSRange range;
@property (readonly) NSRange commentRange;
@end

@interface __iTM2IndentationComponent: _iTM2IndentationComponent
{
@private
    NSUInteger depth;
    NSUInteger location;
    NSUInteger contentLength;// leading spaces
    NSUInteger commentLength;// first comment sequence after the leading spaces
    NSUInteger afterLength;
    NSUInteger blackLength;//
    BOOL endsWithTab;
}
+ (id)indentationComponent;
- (id)clone;
- (void)reset;
@property NSUInteger depth;
@property NSUInteger location;
@property NSUInteger contentLength;
@property NSUInteger commentLength;
@property NSUInteger afterLength;
@property NSUInteger blackLength;
@property BOOL endsWithTab;
@end

@interface NSArray(iTM2StringController)

/*!
	@method		indentationRange4iTM3
	@abstract	Abstract forthcoming.
	@discussion	Private. Beware, the indentation does contain comment switches if they are followed by a white or a special character.
	@param		None.
    @result     The union range of all the indentation components.
*/
- (NSRange)indentationRange4iTM3;

/*!
	@method		indentationDepth4iTM3
	@abstract	Abstract forthcoming.
	@discussion	Private. Beware, the indentation does contain comment switches if they are followed by a white or a special character.
	@param		None.
    @result     The total depth of all the indentation components.
*/
- (NSUInteger)indentationDepth4iTM3;

/*!
	@method		indentationWhiteDepth4iTM3
	@abstract	Abstract forthcoming.
	@discussion	Private.
	@param		None.
    @result     The total white depth of all the indentation components.
*/
- (NSUInteger)indentationWhiteDepth4iTM3;

/*!
	@method		indentationLength4iTM3
	@abstract	Abstract forthcoming.
	@discussion	Private. Beware, the indentation does contain comment switches if they are followed by a white or a special character.
	@param		None.
    @result     The total length of all the indentation components.
*/
- (NSUInteger)indentationLength4iTM3;

/*!
	@method		firstCommentedIndentationComponent4iTM3
	@abstract	Abstract forthcoming.
	@discussion	Private.
	@param		None.
    @result     The first commented indentation component or nil.
*/
- (_iTM2IndentationComponent *)firstCommentedIndentationComponent4iTM3;

@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= NSString(iTeXMac2)
