/*
//
//  @version Subversion: $Id: iTM2StringControllerKit.h 750 2008-09-17 13:48:05Z jlaurens $ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Wed Oct 28 2009.
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

@interface NSObject(iTM2StringControllerDelagation)
- (NSString *)iTM2_indentationString;// is it used?
@end

@interface NSObject(iTM2StringKit)
- (id)iTM2_stringController;
@end

@interface iTM2StringController: NSObject
{
@private
    NSArray * _macroTypes;
    id __weak _delegate;
}
+ (id)defaultController;
- (id)initWithDelegate:(id)delegate;
- (NSString *)bullet;

/*!
	@method		_indentationComponentsAtIndex:inString:
	@abstract	Abstract forthcoming.
	@discussion	Private.
	@param		index.
	@param		aString.
    @result     an array of private objects.
*/
- (NSArray *)_indentationComponentsAtIndex:(NSUInteger)index inString:(NSString *)aString;

/*!
	@method		indentationLevelStartingAtIndex:isComment:inString:
	@abstract	Abstract forthcoming.
	@discussion	Discussion forthcoming.
	@param		indexRef.
	@param		yornRef.
	@param		aString.
    @result     level
*/
- (NSUInteger)indentationLevelStartingAtIndexRef:(NSUInteger *)indexRef isComment:(BOOL *)yornRef inString:(NSString *)aString;

/*!
	@method		indentationLevelAtIndex:isComment:inString:
	@abstract	Abstract forthcoming.
	@discussion	The message indentationLevelStartingAtIndexRef:inString: is sent where the provided index
                corresponds to the first character of the line that contains the given parameter "index".
	@param		index.
	@param		yornRef.
	@param		aString.
    @result     level
*/
- (NSUInteger)indentationLevelAtIndex:(NSUInteger)index isComment:(BOOL *)yornRef inString:(NSString *)aString;

/*!
	@method		stringByNormalizingIndentationInString:
	@abstract	Abstract forthcoming.
	@discussion	Discussion forthcoming.
	@param		aString.
    @result     Normalized NSString instance
*/
- (NSString *)stringByNormalizingIndentationInString:(NSString *)aString;

/*!
	@method		stringWithIndentationLevel:atIndex:inString:
	@abstract	Abstract forthcoming.
	@discussion	Discussion forthcoming.
	@param		level.
	@param		index.
	@param		aString.
    @result     the new string
*/
- (NSString *)stringWithIndentationLevel:(NSUInteger)indentation atIndex:(NSUInteger)index inString:(NSString *)aString;

/*!
	@method		standaloneCharacterAtIndex:inString:
	@abstract	Abstract forthcoming.
	@discussion	0 if the character at the given index is part of composed character sequence
                otherwise the NSString's characterAtIndex: is returned.
	@param		index.
	@param		aString.
    @result     yorn
*/
- (unichar)standaloneCharacterAtIndex:(NSUInteger)index inString:(NSString *)aString;

/*!
	@method		isEscapedCharacterAtIndex:inString:
	@abstract	Abstract forthcoming.
	@discussion	YES iff index>0 and there is an unescaped control sequence at index-1.
                Subclassers will use there own definition.
	@param		index.
	@param		aString.
    @result     yorn
*/
- (BOOL)isEscapedCharacterAtIndex:(NSUInteger)index inString:(NSString *)aString;

/*!
	@method		isCommentCharacterAtIndex:inString:
	@abstract	Abstract forthcoming.
	@discussion	YES iff '%' is the character at the given index, it is not escaped
                and it is not part of a composed character sequence.
                Subclassers will use there own definition.
	@param		index.
	@param		aString.
    @result     yorn
*/
- (BOOL)isCommentCharacterAtIndex:(NSUInteger)index inString:(NSString *)aString;

/*!
	@method		commentString
	@abstract	Abstract forthcoming.
	@discussion	The default implementation returns @"%". Subclassers may want to change this.
                This is readonly because it is synchronized with the is...Comment... methods.
	@param		None.
    @result     a string
*/
@property (readonly) NSString * commentString;

/*!
	@method		isStartingCommentSequenceAtIndexRef:inString:
	@abstract	Abstract forthcoming.
	@discussion	YES iff '%' there is a comment character att the given index.
                On return, indexRef points to the next character that is ont part the comment sequence.
                An example of such a sequence is '//' but not '/*'
                This is line centric, which means that we assume that comments end with the lines only
                C like comments are not allowed.
                The default implementation is just a wrapper over the isCommentCharacterAtIndex:inString: method.
	@param		indexRef.
	@param		aString.
    @result     yorn
*/
- (BOOL)isStartingCommentSequenceAtIndexRef:(NSUInteger *)indexRef inString:(NSString *)aString;

/*!
	@method		isControlCharacterAtIndex:inString:
	@abstract	Abstract forthcoming.
	@discussion	YES iff '\' is the character at the given index, it is not escaped
                and it is not part of a composed character sequence.
                Subclassers will use there own definition.
	@param		index.
	@param		aString.
    @result     yorn
*/
- (BOOL)isControlCharacterAtIndex:(NSUInteger)index inString:(NSString *)aString;

@property (assign) NSUInteger numberOfSpacesPerTab;
@property (assign) BOOL usesTabs;
@property (readonly) NSString * indentationString;
@property (readonly,retain) NSArray * macroTypes;
@property (assign) id __weak delegate;
@end

@interface NSTextView(iTM2StringKit)
- (id)iTM2_stringController;
@end

// private object
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


//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= NSString(iTeXMac2)
