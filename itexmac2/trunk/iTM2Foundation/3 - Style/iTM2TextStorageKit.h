/*
//
//  @version Subversion: $Id$ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Tue Oct 16 2001.
//  Copyright © 2004 Laurens'Tribune. All rights reserved.
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

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2TextStorageKit
/*!
    @header 	The iTeXMac2 Text Storage Kit
    @abstract   This documentation comes in conjunction with the iTeXMac2 Text Attributes Kit.
    @discussion Here is a rapid description of the text storage design in iTeXMac2.
                The overall purpose is to provide the user with a performant and extendable syntax parsing.
                The text is stored in an NSTextStorage subclass: iTM2TextSorage.
                Each iTM2TextStorage instance has an iTM2TextSyntaxParser instance which purpose is to map attributes to text.
                Attributes are known indirectly through modes.
                Modes are tags that identify logically words/charachters/expression of the text.
                Each syntax parser has a shared attributes servers who really knowns
                what attributes should apply to text according to its mode tag.
                In other words, syntax coloring has two levels: syntax parsing and coloring.
                The mutability of syntax parsing is ensured by the iTM2TextSyntaxParser instances
                while the coloring mutability comes from the attributes servers variants.
                As the syntax parser and the attributes server are paired,
                it is recommanded to register them at the same time.
                This comment might not be completely relevant as implementation has become stronger.
                One question is to properly set up a view at initialization time.
                For that we use the meta values API's. 
*/


/*!
    @const      iTM2SyntaxParserStyleEnabledKey
    @abstract   Public iTeXMac2 attribute key.
    @discussion Description forthcoming.
*/
extern NSString * const iTM2SyntaxParserStyleEnabledKey;

/*!
    @const      iTM2TextModeAttributeName
    @abstract   Private iTeXMac2 attribute name.
    @discussion Description forthcoming.
*/
extern NSString * const iTM2TextModeAttributeName;

/*!
    @const      iTM2TextStyleKey
    @abstract   Private iTeXMac2 meta property name.
    @discussion Description forthcoming.
*/
extern NSString * const iTM2TextStyleKey;

/*!
    @const 	iTM2TextSyntaxParserVariantKey
    @abstract   Private iTeXMac2 meta property name.
    @discussion Description forthcoming.
*/
extern NSString * const iTM2TextSyntaxParserVariantKey;

enum
{
	kiTM2TextNoErrorSyntaxStatus = 0,
	kiTM2TextNoErrorIfNotLastSyntaxStatus,
	kiTM2TextWaitingSyntaxStatus,
	kiTM2TextRangeExceededSyntaxStatus,// too big
	kiTM2TextOutOfRangeSyntaxStatus,// too small
	kiTM2TextMissingModeSyntaxStatus,
	kiTM2TextErrorSyntaxStatus
};

enum
{
	kiTM2TextErrorSyntaxMask = 0xFF000000U,// only 8 kinds or independent errors are allowed, 256 different situations, bits 24 -> 31
	kiTM2TextModifiersSyntaxMask = 0x00FF0000U,// only 8 kinds or running
	kiTM2TextFlagsSyntaxMask = kiTM2TextErrorSyntaxMask|kiTM2TextModifiersSyntaxMask,
	kiTM2TextEndOfLineSyntaxMask = 0x00010000U,// EOLs are used to propagate errors, information. If a previousMode has a kiTM2TextEndOfLineSyntaxMask bit set, it comes from the previous line EOL. bits 20
};

/*!
    @const		kiTM2TextErrorSyntaxMode
    @abstract   Syntax mode for errors.
    @discussion Description forthcoming.
*/
/*!
    @const		kiTM2TextRegularSyntaxMode
    @abstract   Syntax mode for regular text.
    @discussion Regular text is in general the major part of the text.
				Inserting a regular character somewhere must not modify the syntax mode of the character at the previous location, if it is regular.
*/
/*!
    @const		kiTM2TextUnknownSyntaxMode
    @abstract   Initialization value for syntax mode to be fixed.
    @discussion This value must be overriden by further part of the code.
				As the mode is used to compute the attributes,
				an unknown mode will give an undefined set of attributes and thus an inconsistent result.
*/
enum 
{
    kiTM2TextErrorSyntaxMode = 0,
    kiTM2TextWhitePrefixSyntaxMode,
    kiTM2TextRegularSyntaxMode,
	kiTM2TextUnknownSyntaxMode = UINT_MAX & ~kiTM2TextFlagsSyntaxMask
};

/*!
    @class 	iTM2TextStorage
    @abstract   Private implementation of a text storage.
    @discussion This is just a wrapper over the concrete text storage of cocoa.
*/

@interface iTM2TextStorage: NSTextStorage
{
@private
    id _Model;
    id _SP;
	id _ACD;
}

/*!
    @method     syntaxParser
    @abstract   the syntax parser of the receiver
    @discussion Description forthcoming.
    @param      None
    @result     an iTM2SyntaxParser instance
*/
- (id)syntaxParser;

/*!
    @method     syntaxParserStyle
    @abstract   the syntax parser style of the receiver
    @discussion Shortcut to the eponym method of the receiver's syntax parser.
    @param      None
    @result     an NSString identifier
*/
- (NSString *)syntaxParserStyle;

/*!
    @method     syntaxParserVariant
    @abstract   the syntax parser variant of the receiver
    @discussion Shortcut to the eponym method of the receiver's syntax parser.
    @param      None
    @result     an NSString identifier
*/
- (NSString *)syntaxParserVariant;

/*!
    @method     replaceSyntaxParser:
    @abstract   Smart setter
    @discussion You should use this method instead of the lower level setParser:.
                Please, notice that this method invalidates the glyphs of all the layout managers of the receiver.
                Notice also that it sets the default attributes of the text views of the text storage.
                The style and variant of the argument are recorded as meta properties.
    @param      argument is the new parser
    @result     None
*/
- (void)replaceSyntaxParser:(id)argument;

/*!
    @method     setSyntaxParser:
    @abstract   basic setter
    @discussion Very low level setter.
    @param      argument is the new parser
    @result     None
*/
- (void)setSyntaxParser:(id)argument;

/*!
    @method     setSyntaxParserStyle:variant:
    @abstract   Set the syntax parser style and variant of the receiver.
    @discussion This is the designated low level method to change the style and variant.
    @param      style is a style
    @param      variant is a variant
    @result     None
*/
- (void)setSyntaxParserStyle:(NSString *)style variant:(NSString *)variant;

/*!
    @method     replaceSyntaxParserStyle:variant:
    @abstract   Replace the syntax parser style and variant of the receiver.
    @discussion This is the designated high level method to change the style and variant.
                It uses -setSyntaxParserStyle:variant: and updates the meta properties.
                The meta properties are the style and the variant,
                this is the only method where they are set.
    @param      style is a style
    @param      variant is a variant
    @result     None
*/
- (void)replaceSyntaxParserStyle:(NSString *)style variant:(NSString *)variant;

/*!
    @method     replaceCharactersInRange:withString:
    @abstract   Standard replacer.
    @discussion This method just branches to the correct -textStorageInserted... -textStorageDeleted... of the syntax parser method.
    @param      range is similar to the second argument of -edited:range:changeInLength:
    @param      delta is similar to the last argument of -edited:range:changeInLength:
    @result     None
*/
- (void)replaceCharactersInRange:(NSRange)range withString:(NSString *)string;

/*!
    @method     attributesChangeDelegate
    @abstract   The delegate for the attributes change.
    @discussion The attributes are not expected to change in response to a standard user action,
				like setting the font or color using the font or color panel.
				However, when editing the syntax style, one has to catch the messages sent by the UI to the model.
				Every attributes change is forwarded to the delegate.
    @result     None
*/
- (id)attributesChangeDelegate;

/*!
    @method     setAttributesChangeDelegate:
    @abstract   Set the delegate for the attributes change.
    @discussion The delegate is not owned by the receiver.
				The delegate should implement the iTM2AttributesChangeProtocol informal protocol:
    @result     None
*/
- (void)setAttributesChangeDelegate:(id)delegate;

@end

@interface NSObject(iTM2AttributesChangeProtocol)

/*!
    @method     textStorage:wouldSetAttributes:range:
    @abstract   Informal protocol for an attributes change protocol.
    @discussion The text storage is receiveing a <code>setAttributes:range:</code> message.
	@param		TS is the text storage
	@param		attributes are the new attributes
	@param		range is the range
    @result     None
*/
- (void)textStorage:(iTM2TextStorage *)TS wouldSetAttributes:(id)attributes range:(NSRange)range;

/*!
    @method     textStorage:wouldAddAttribute:value:range:
    @abstract   Informal protocol for an attributes change protocol.
    @discussion The text storage is receiveing a <code>addAttribute:value:range:</code> message.
	@param		TS is the text storage
	@param		name is the name of the added attribute
	@param		value is the value of the added attribute
	@param		range is the range
    @result     None
*/
- (void)textStorage:(iTM2TextStorage *)TS wouldAddAttribute:(NSString *)name value:(id)value range:(NSRange)range;

@end

/*!
    @class	iTM2TextSyntaxParser
    @abstract	The root class for syntax parsing.
    @discussion	This is the delegate of the iTM2TextStorage object, responsible of the syntax parsing.
                It keeps track of the owning text storage.
*/

@class iTM2TextSyntaxParserAttributesServer;

@interface iTM2TextSyntaxParser: NSObject
{
@private
    id			_ModeLines;
    unsigned	_BadOffsetIndex;
    unsigned	_BadModeIndex;
    unsigned	_PreviousLineIndex;
    unsigned	_PreviousLocation;
@protected
    id _TS;
    id _AS;
}

/*!
    @method     syntaxParserStyle
    @abstract   The style of the receiver.
    @discussion Different syntax parsers will use different rules and different storages.
                This identifier allows to make the difference between all these parsers.
                There is a one to one mapping between styles and receiver.
    @result     a unique NSString style.
*/
+ (NSString *)syntaxParserStyle;

/*!
    @method     syntaxParserClassEnumerator
    @abstract   An enumerator of the registered syntax parsers classes.
    @discussion Description forthcoming.
    @param      None
    @result     An NSArray of unique strings.
*/
+ (NSEnumerator *)syntaxParserClassEnumerator;

/*!
    @method     syntaxParserClassForStyle:
    @abstract   The syntax parser class for the given style.
    @discussion Description forthcoming.
    @param      a style.
    @result     a syntax parser class.
*/
+ (id)syntaxParserClassForStyle:(NSString *)style;

/*!
    @method     syntaxParserWithStyle:variant:
    @abstract   A syntax parser for the given style and variant.
    @discussion Use this method to create syntax parsers. The proper class and the proper object will be returned.
                If the receiver does not know the given style, it give a compatible one of its own.
    @param      a style.
    @param      a variant.
    @result     a syntax parser class.
*/
+ (id)syntaxParserWithStyle:(NSString *)style variant:(NSString *)variant;

/*!
    @method     attributesServerClass
    @abstract   The attributes server class of the receiver.
    @discussion This is used to automatically create the shared attributes servers in the +initialize method.
                Subclassers should not override this.
                If a syntax parser is defined with class name "className",
                a class named "classNameAttributesServer" must also be defined as attributes class server.
                The attributes server is private to its syntax parser, such that no special class inheritance is required.
    @param	None.
    @result     None.
*/
+ (Class)attributesServerClass;

/*!
    @method     setUpAllTextViews
    @abstract   The receiver sets up all its connected text views.
    @discussion Scans the layout managers and text containers.
    @param      None.
    @result     None.
*/
- (void)setUpAllTextViews;

/*!
    @method     setUpTextView:
    @abstract   The receiver sets up the given text view.
    @discussion Sets the different colors and view options.
                Please, use this methode whenever you add a textview to an iTM2TextStorage.
                Beware dev, there might be an automatic design.
    @param      A text view
    @result     None.
*/
- (void)setUpTextView:(NSTextView *)TV;

/*!
    @method     badOffsetIndex
    @abstract   The bad offset index of the receiver.
    @discussion All the line modes with indices below this one have reliable offset.
                Do not assume that this index is les than the number of lines.
    @param      None
    @result     an index.
*/
- (unsigned)badOffsetIndex;

/*!
    @method     validateOffsetsUpTo:
    @abstract   Validat the given offset index.
    @discussion Increase the bad offset index if necessary to pass the given argument.
    @param      argument
    @result     None.
*/
- (void)validateOffsetsUpTo:(unsigned)argument;

/*!
    @method     invalidateOffsetsFrom:
    @abstract   Invalidate offsets from the given offset index.
    @discussion Decrease the bad offset index if necessary to pass the given argument.
    @param      argument
    @result     None.
*/
- (void)invalidateOffsetsFrom:(unsigned)argument;

/*!
    @method     badModeIndex
    @abstract   the first index for which the mode information is bad.
    @discussion All the line modes with indices below this one have reliable mode information.
                Do not assume that this index is les than the number of lines.
    @param      None
    @result     an index.
*/
- (unsigned)badModeIndex;

/*!
    @method     validateModesUpTo:
    @abstract   Modify eventually the first index for which the mode information may be bad.
    @discussion There is no automatic management of this index,
                subclassers must ensure that this index always points
                to the expected location with respect to its meaning.
    @param      argument
    @result     None.
*/
- (void)validateModesUpTo:(unsigned)argument;

/*!
    @method     invalidateModesFrom:
    @abstract   Modify eventually the first index for which the mode information may be bad.
    @discussion There is no automatic management of this index,
                subclassers must ensure that this index always points
                to the expected location with respect to its meaning.
    @param      argument
    @result     None.
*/
- (void)invalidateModesFrom:(unsigned)argument;

/*!
    @method     lineIndexForLocation:
    @abstract   The line index for the given location.
    @discussion The result is the first index for a mode line (ML) such that
                [ML startOffset] <= argument < [ML end]
                or the last mode line if the previous inequalities cannot hold.
                Once this method returns, the bad offset index is at least one more than the returned value.
                This means that we can rely on the offset of each line mode which index is less than or equal
                to the return index. This does not use the string to compute the index,
                only cached information is used. This involves a loss of synchronization
                when the text storage has just been edited. More precisely,
                the line limits remains the same as long the line modes are not updated.
    @param      location
    @result     index
*/
- (unsigned int)lineIndexForLocation:(unsigned)location;

/*!
    @method     insertModeLine:atIndex:
    @abstract   Insert a mode line at the given index.
    @discussion Description forthcoming.
    @param      ML
    @param      index
    @result     None.
*/
- (void)insertModeLine:(id)ML atIndex:(unsigned)index;

/*!
    @method     numberOfModeLines
    @abstract   The number of mode lines.
    @discussion Description forthcoming.
    @result     unsigned.
*/
- (unsigned)numberOfModeLines;

/*!
    @method     modeLineAtIndex:
    @abstract   Get the mode line at the given index.
    @discussion Description forthcoming.
    @param      index
    @result     ML.
*/
- (id)modeLineAtIndex:(unsigned)index;

/*!
    @method     replaceModeLineAtIndex:withModeLine:
    @abstract   Replace a mode line with anothe one.
    @discussion Description forthcoming.
    @param      index
    @param      ML
    @result     None.
*/
- (void)replaceModeLineAtIndex:(unsigned)index withModeLine:(id)ML;

/*!
    @method     replaceModeLinesInRange:withModeLines:
    @abstract   Replace mode lines with others.
    @discussion Description forthcoming.
    @param      range
    @param      MLs
    @result     None.
*/
- (void)replaceModeLinesInRange:(NSRange)range withModeLines:(NSArray *)MLs;

/*!
    @method     attributesAtIndex:effectiveRange:
    @abstract   Description Forthcoming.
    @discussion Description Forthcoming.
    @param      aLocation
    @result     A dictionary of attributes
*/
- (NSDictionary *)attributesAtIndex:(unsigned)aLocation effectiveRange:(NSRangePointer)aRangePtr;

/*!
    @method     setAttributes:range:
    @abstract   set attributes.
    @discussion For subclassers only yet.
    @param      attributes
    @param      range
    @result     None.
*/
- (void)setAttributes:(NSDictionary *)attributes range:(NSRange)range;

/*!
    @method     addAttribute:value:range:
    @abstract   add attributes.
    @discussion For subclassers only yet.
    @param      name
    @param      value
    @param      range
    @result     None.
*/
- (void)addAttribute:(NSString *)name value:(id)value range:(NSRange)range;

/*!
    @method     attributesServer
    @abstract   The attributes server of the receiver.
    @discussion Description forthcoming.
    @param      None
    @result     an iTM2TextAttributesServer instance.
*/
- (id)attributesServer;

/*!
    @method    	replaceAttributesServer:
    @abstract   Set the attributes server of the receiver to the argument.
    @discussion The receiver is not the owner of the attributes server, on the contrary...
                Once the text storage has changed, a textStorageDidChange message is sent.
    @param      argument
    @result     None
*/
- (void)replaceAttributesServer:(iTM2TextSyntaxParserAttributesServer *)argument;

/*!
    @method     syntaxParserVariant
    @abstract   the syntax parser variant of the receiver
    @discussion Shortcut to the eponym method of the receiver's attributes server.
    @param      None
    @result     an NSString identifier
*/
- (NSString *)syntaxParserVariant;

/*!
    @method     textStorage
    @abstract   The text storage of the receiver.
    @discussion Description forthcoming.
    @param      None
    @result     an iTM2TextStorage instance.
*/
- (id)textStorage;

/*!
    @method     setTextStorage:
    @abstract   Set the text storage of the receiver to the argument.
    @discussion The receiver is not the owner of the text storage, on the contrary...
                Once the text storage has changed, a textStorageDidChange message is sent.
    @param      argument
    @result     None
*/
- (void)setTextStorage:(id)argument;

/*!
    @method     textStorageDidChange
    @abstract   The text storage of the receiver has changed.
    @discussion The receiver has got a chance to take the appropriate measures at initialization time.
                The default implementation creates the array of line modes. Subclassers will append their own material,
                after forwarding the message to super.
    @param      None
    @result     None
*/
- (void)textStorageDidChange;

/*!
    @method     textStorageWillReplaceCharactersInRange:withString:
    @abstract   The text storage of the receiver is about to edit.
    @discussion Gives a chance to the syntax parser to take appropriate actions.
				This is a very critical and sensitive part of the code, modify with great care.
    @param      range, same meaning than -replaceCharactersInRange:withString:
    @param      string, same meaning than -replaceCharactersInRange:withString:
    @result     None
*/
- (void)textStorageWillReplaceCharactersInRange:(NSRange)range withString:(NSString *)string;

/*!
    @method     textStorageDidInsertCharacterAtIndex:editedAttributesRangeIn:
    @abstract   The text storage of the receiver has inserted one character at the given index
    @discussion Sent by the -textStorageEdited:range:changeInLength:.
				The default implementation forwards to -textStorageDidInsertCharactersAtIndex:count:,
				subclassers will override this method for a more efficient implementation.
				This is a very critical and sensitive part of the code, modify with great care.
    @param      location, where the character was inserted
    @param      editedAttributesRangePtr, on return points to the edited attributes range
    @result     None
*/
- (void)textStorageDidInsertCharacterAtIndex:(unsigned)location editedAttributesRangeIn:(NSRangePointer)editedAttributesRangePtr;

/*!
    @method     textStorageDidInsertCharactersAtIndex:count:editedAttributesRangeIn:
    @abstract   The text storage of the receiver has inserted count characters at the given index
    @discussion Sent by the -textStorageEdited:range:changeInLength:.
				The default implementation forwards to -textStorageDidInsertCharactersInRange:changeInLength:,
				subclassers will override this method for a more efficient implementation.
				This is a very critical and sensitive part of the code, modify with great care.
    @param      location, where the characters were inserted
    @param      editedAttributesRangePtr, on return points to the edited attributes range
    @result     None
*/
- (void)textStorageDidInsertCharactersAtIndex:(unsigned)location count:(unsigned)count editedAttributesRangeIn:(NSRangePointer)editedAttributesRangePtr;

/*!
    @method     textStorageDidDeleteCharacterAtIndex:editedAttributesRangeIn:
    @abstract   The text storage of the receiver has one character at the given index
    @discussion Sent by the -textStorageEdited:range:changeInLength:.
				The default implementation forwards to -textStorageDidDeleteCharactersAtIndex:count:,
				subclassers will override this method for a more efficient implementation.
				This is a very critical and sensitive part of the code, modify with great care.
    @param      location, where the character was deleted
    @param      editedAttributesRangePtr, on return points to the edited attributes range
    @result     None
*/
- (void)textStorageDidDeleteCharacterAtIndex:(unsigned)location editedAttributesRangeIn:(NSRangePointer)editedAttributesRangePtr;

/*!
    @method     textStorageDidDeleteCharactersAtIndex:count:editedAttributesRangeIn:
    @abstract   The text storage of the receiver has deleted count characters at the given index
    @discussion Sent by the -textStorageEdited:range:changeInLength:.
				The default implementation forwards to -textStorageDidInsertCharactersInRange:changeInLength:,
				subclassers will override this method for a more efficient implementation.
				Deleted characters were in the range (location, count)
				This is a very critical and sensitive part of the code, modify with great care.
    @param      location, where the characters were deleted
    @param      count
	@param      editedAttributesRangePtr, on return points to the edited attributes range
	@result     None
*/
- (void)textStorageDidDeleteCharactersAtIndex:(unsigned)location count:(unsigned)count editedAttributesRangeIn:(NSRangePointer)editedAttributesRangePtr;

/*!
    @method     textStorageDidReplaceCharactersAtIndex:count:withCount:editedAttributesRangeIn:
    @abstract   Abstract frothcoming
    @discussion Description forthcoming
				This is a very critical and sensitive part of the code, modify with great care.
    @param      location, where the characters were deleted
    @param      oldCount
    @param      newCount
	@param      editedAttributesRangePtr, on return points to the edited attributes range
	@result     None
*/
- (void)textStorageDidReplaceCharactersAtIndex:(unsigned)location count:(unsigned)oldCount withCount:(unsigned)newCount editedAttributesRangeIn:(NSRangePointer)editedAttributesRangePtr;

/*!
    @method     textStorageWillProcessEditing
    @abstract   The text storage of the receiver has ended editing
    @discussion Sent by the text storage of the receiver when the processEditing begins.
				Characters or attributes of the text storage of the receiver can be changed.
				This default implementation does nothing.
    @param      None
    @result     None
*/
- (void)textStorageWillProcessEditing;

/*!
    @method     textStorageDidProcessEditing
    @abstract   The text storage of the receiver has ended editing
    @discussion Sent by the text storage of the receiver when the processEditing ends.
Characters of the text storage of the receiver can not be changed, whereas attributes indeed can.
This default implementation does nothing.
    @param      None
    @result     None
*/
- (void)textStorageDidProcessEditing;

/*!
    @method     validEOLModeOfModeLine:forPreviousMode:
    @abstract   The valid last mode for the given line mode and previous mode.
    @discussion As side effect, the attributes are fixed.
                If the previous mode is 0, which means that the modes and attributes of the previous line are not valid,
                quite nothing should be done for performance reasons. Once this method returns with a returned valid mode,
                we are sure that all the attributes and modes are fixed.
                The implementation should be efficient.
                If the given mode is the actual previous mode, we don't fix the attributes before the invalid range,
                we then fix the atributes in the invalid range and finally we fix after as long as necessary using the old values.
                If the given mode is not the good one, we invalidate the range and we use the above method.
                If the given previous mode is 0, the EOL mode of the receiver should be returned with no computation.
                The receiver is given a chance to manage the change in the previous mode because a -setPreviousMode:ofModeLine:
                is sent at the very beginning, after some trivial cases are dealt with.
    @param      the mode line to be fixed
    @param      the previous mode which is the last mode of the previous line
    @result     the EOL mode once things are fixed
*/
- (unsigned)validEOLModeOfModeLine:(id)modeLine forPreviousMode:(unsigned)mode;

/*!
    @method     getSyntaxMode:forLocation:previousMode:effectiveLength:nextModeIn:before:
    @abstract   Returns the mode for the character at the given index and assuming the given previous mode.
                The effective length is returned.
                The returned value in nextModePtr if any is assumed to be different from the one returned by the method.
				beforeIndex is just an hint: no real need to look for the mode at indexes from beforIndex.
				The nextMode, if available, is the mode of the first character after the effective range
				where we can find the resulting mode.
				The effective length can lead to a character location after beforeIndex.
				It should do so to avoid bad state.
    @discussion Description forthcoming.
    @param      index
    @param      previousMode
    @param      lengthPtr is a pointer
    @param      nextModePtr is a pointer
    @param      beforeIndex is a wall
    @result     a mode
*/
- (unsigned)getSyntaxMode:(unsigned *)newModeRef forLocation:(unsigned)index previousMode:(unsigned)previousMode effectiveLength:(unsigned *)lengthPtr nextModeIn:(unsigned *)nextModePtr before:(unsigned)beforeIndex;

/*!
    @method     getSyntaxMode:forCharacter:previousMode:
    @abstract   Returns the mode for the character at the given index and previous mode.
    @discussion Description forthcoming.
    @param      index
    @param      previousMode
    @result     a mode
*/
- (unsigned)getSyntaxMode:(unsigned *)newModeRef forCharacter:(unichar)theChar previousMode:(unsigned)previousMode;

/*!
    @method     invalidateModesForCharacterRange:editedAttributesRangeIn:
    @abstract   Invalidates the modes in the given range.
    @discussion Description forthcoming.
    @param      range
    @param      editedAttributesRangePtr
    @result     non
*/
- (void)invalidateModesForCharacterRange:(NSRange)range editedAttributesRangeIn:(NSRangePointer)editedAttributesRangePtr;

/*!
    @method     EOLModeForPreviousMode:
    @abstract   Returns the EOL mode for the given previous mode.
    @discussion Description forthcoming.
    @param      previousMode
    @result     a mode
*/
- (unsigned)EOLModeForPreviousMode:(unsigned)previousMode;

/*!
    @method     getSyntaxMode:atIndex:longestRange:
    @abstract   Returns the mode for the given index.
    @discussion Description forthcoming.
    @param      aModeRef
    @param      aLocation
    @param      aRangePtr
    @result     a mode
*/
- (unsigned)getSyntaxMode:(unsigned *)modeRef atIndex:(unsigned)aLocation longestRange:(NSRangePointer)aRangePtr;

/*!
    @method     getSmartSyntaxMode:atIndex:longestRange:
    @abstract   Returns the smart mode for the given index.
    @discussion The smart mode is smarter than the syntax mode.
				For example, '\$' has 2 syntax modes, one for '\' and
				one for '$' but only one smart syntax mode for both characters.
    @param      aModeRef
    @param      aLocation
    @param      aRangePtr
    @result     a mode
*/
- (unsigned)getSmartSyntaxMode:(unsigned *)aModeRef atIndex:(unsigned)aLocation longestRange:(NSRangePointer)aRangePtr;

/*!
    @method     fixSyntaxModesInRange:
    @abstract   Description Forthcoming.
    @discussion Description forthcoming.
    @param      range
    @result     None
*/
- (void)fixSyntaxModesInRange:(NSRange)range;

- (BOOL)diagnostic;// private/debug use

@end

//#import <iTM2Foundation/iTM2ObjectsKit.h>
extern NSString * const iTM2TextSyntaxParserName;
extern NSString * const iTM2TextModesAttributesExtension;
extern NSString * const iTM2TextSymbolsAttributesExtension;
extern NSString * const iTM2TextDefaultSyntaxModeName;
extern NSString * const iTM2TextWhitePrefixSyntaxModeName;
extern NSString * const iTM2TextErrorSyntaxModeName;
extern NSString * const iTM2TextSelectionSyntaxModeName;
extern NSString * const iTM2TextBackgroundSyntaxModeName;
extern NSString * const iTM2TextInsertionSyntaxModeName;

extern NSString * const iTM2TextModeAttributeName;
extern NSString * const iTM2NoBackgroundAttributeName;
extern NSString * const iTM2CursorIsWhiteAttributeName;
extern NSString * const iTM2TextDefaultStyle;


/*!
@class iTM2ModeLine
    @abstract   The line mode objects store the mode for a line.
    @discussion This discussion is not completely up to date.
				Line modes objects are assumed to represent the mode for a full line of text.
                A parser is expected to maintain an array of line objects that reflect exactly the lines of the associate text.
                The line object caches information. The offset is the line start of the corresponding line.
                This value may not be accurate if the text has been edited in a previous line.
                The parser is responsible to maintain a flag to indicate whether the offset has a good value.
                The end and contentsEnd are similar to the result of -getLineStart:end:contentsEnd:forRange:.
                The only difference is that both are relative to the beginning of a line of text.
                That way, no need to update these values if the text is edited in another line.
                The line mode contains two mutable data that store a range length and a range mode, both are unsigned int's.
                The contentsEnd is expected to be the sum of all the lengths.
                Two successive modes should not have the same value but it is not required at first glance.
                In order to avoid computing the modes, information is cached.
                invalidOffset is the first index for which the mode information might be inaccurate.
                A value of -1 indicates for example that the modes have been successfully computed,
                but it is sufficient to have the end.
                The previous and last modes are responsible of the continuity of the text stream.
                Those values make the link between a line and its preceeding line or its following one.
                Here we assume that line switch is described by an unsigned integer.
                We must understand this as the mode of the switch between the line such that
                the last mode of a line mode is the previous mode of the next line.
                Similarly, the previous mode of a line mode is also the last mode of the previous line mode.
                If this is not fullfilled, the latter line mode is considered invalid.
                Some syntax attributes must jump over eols, like the math mode for example, if a '$' is inserted,
                all the attributes before the next '$' must have a chance to change, even if the next '$' is not on the same line.
                The big question now is to discuss about the mode fixing policy.
                All valid modes are positive, a 0 mode is considered an error from a syntax point of view.
*/
#undef __ELEPHANT_MODELINE__
#ifndef __ELEPHANT_MODELINE__
// comment the next lines to disable high cost debugging
//#define __ELEPHANT_MODELINE__
//#warning START ELEPHANT MODE: For debugging purpose only... comment this line
#warning NO ELEPHANT MODE: For debugging purpose only... uncomment the above lines
#endif

@interface iTM2ModeLine: NSObject
{
@private
    // global coordinates
    unsigned int _StartOff7;//primitive
    unsigned int _CommentOff7;//:=_StartOff7+_UncommentedLength, possibly UINT_MAX
    unsigned int _ContentsEndOff7;//:=_StartOff7+_ContentsLength
    unsigned int _EndOff7;//:=_StartOff7+_Length
    // local coordinates
    unsigned int _UncommentedLength;//primitive, _UncommentedLength = UINT_MAX
    unsigned int _ContentsLength;//primitive
    unsigned int _Length;//_Length:=_ContentsLength + _EOLLength
    unsigned int _EOLLength;//primitive
    NSRange  _InvalidLocalRange;
    // modes
    unsigned int _PreviousMode;
    unsigned int _EOLMode;
    unsigned int _NumberOfSyntaxWords;
    unsigned int _MaxNumberOfSyntaxWords;
    unsigned int * __SyntaxWordOff7s;
    unsigned int * __SyntaxWordLengths;
    unsigned int * __SyntaxWordEnds;
    unsigned int * __SyntaxWordModes;
#ifdef __ELEPHANT_MODELINE__
@public
	NSString * originalString;
#endif
}
/*"Class methods"*/
+ (id)modeLine;
/*"Setters and Getters"*/
- (unsigned)startOffset;
- (unsigned)commentOffset;
- (unsigned)contentsEndOffset;
- (unsigned)endOffset;
- (void)setStartOffset:(unsigned)argument;
- (unsigned)EOLLength;
- (unsigned)contentsLength;

/*!
    @method     uncommentedLength
    @abstract   The length of the comment.
    @discussion Positive when there is a comment.
				A comment is expected to start with a special character %, # are such examples
				The number of commented characters excluding the EOL.
    @param      argument
    @result     None
*/
- (unsigned)uncommentedLength;

/*!
    @method     setEOLLength:
    @abstract   Set the EOL length of the receiver.
    @discussion This is one of 0, 1 or 2.
    @param      argument
    @result     None
*/
- (void)setEOLLength:(unsigned)argument;
- (unsigned)length;

/*!
    @method     contentsLength
    @abstract   The length of the contents of the receiver.
    @discussion Discussion forthcoming.
    @param      argument
    @result     None
*/
- (unsigned)contentsLength;

/*!
    @method     invalidLocalRange
    @abstract   The invalid range of the receiver.
    @discussion The invalid range of the receiver is the range of all the location for which the mode information is not reliable.
                In fact there is a deterministic rule to compute the mode at location i knowing the mode at location i-1
                (or the previous mode if i is 0). For all the indices not in the invalid range, we have the following proposition:
                If the preceding mode is true, then the current one is true. This allows to avoid computations when only a part of
                the line has been edited and the effect of the edition is limited, which occurs very often.
    @param      None
    @result     a local coordinate range
*/
- (NSRange)invalidLocalRange;

/*!
    @method     invalidLocalRange
    @abstract   The invalid range of the receiver.
    @discussion The invalid range of the receiver is the range of all the location for which the mode information is not reliable.
                In fact there is a deterministic rule to compute the mode at location i knowing the mode at location i-1
                (or the previous mode if i is 0). For all the indices not in the invalid range, we have the following proposition:
                If the preceding mode is true, then the current one is true. This allows to avoid computations when only a part of
                the line has been edited and the effect of the edition is limited, which occurs very often.
    @param      None
    @result     a local coordinate range
*/
- (NSRange)invalidGlobalRange;

/*!
    @method     validateLocalRange:
    @abstract   Validate the range.
    @discussion A valid range consists of indices for which the mode information is reliable,
                provided the mode information at the previous index is also reliable.
                As soon as the mode are fixed in a range of characters, this message should be sent.
                It does not suffice to validate the actual invalid range to have all the mode information reliable:
                you must ensure that the previous mode information is reliable too.
                The converse operation is -invalidateLocalRange:
                The range is given in global coordinates.
    @param      The range to be validated
    @result     None
*/
- (void)validateLocalRange:(NSRange)argument;

/*!
    @method     validateGlobalRange:
    @abstract   Validate the range.
    @discussion This is the same as -validateLocalRange: except that the argument is now given in global coordinates.
    @param      The range to be validated
    @result     None
*/
- (void)validateGlobalRange:(NSRange)argument;

/*!
    @method     invalidateLocalRange:
    @abstract   Invalidates the range.
    @discussion An invalid range consists of indices for which the mode information is not reliable,
                provided the mode information at the previous index is also reliable.
                This message must be sent as soon as some action may result in a change of the mode when further fixed.
                If a character is inserted somewhere, the mode is subject to changes. If we find the same mode as before,
                the status of the next mode information does not change: if it was reliable, it still remains reliable.
                On the contrary, if the mode found is not the same, the next information mode must not be considered as reliable,
                the appropriate range should be invalidated.
                The converse operation is -validateLocalRange:
    @param      The proposed invalid range in local coordinates.
    @result     None
*/
- (void)invalidateLocalRange:(NSRange)argument;


/*!
    @method     invalidateGlobalRange:
    @abstract   Invalidates the range.
    @discussion Discussion forthcoming:
    @param      The proposed invalid range in local coordinates.
    @result     None
*/
- (void)invalidateGlobalRange:(NSRange)argument;

/*!
    @method     previousMode
    @abstract   The previous mode of the receiver.
    @discussion When positive, this value is the one used to compute all the valid modes declared in the receiver.
                Do not assume that this previous mode matches only a part of all the possible ranges,
                the receiver will automatically set the previous mode to a value from one line mode.
				A line mode with an unknown or error syntax mode will not see its syntax modes fixed bay the validEOL... method
				This means that the first linie mode of a syntax marser MUST have a regular previous syntax mode.
    @param      None
    @result     mode
*/
- (unsigned)previousMode;

/*!
    @method     setPreviousMode:
    @abstract   Set the previous mode of the receiver.
    @discussion The mode an unsigned int value.
    @param      argument
    @result     None
*/
- (void)setPreviousMode:(unsigned)argument;

/*!
    @method     EOLMode:
    @abstract   The EOL mode of the receiver.
    @discussion This mode should be the previous mode of the next mode line.
                It is 0 if the receiver has a non void invalid range.
    @param      None
    @result     A mode
*/
- (unsigned)EOLMode;
- (void)setEOLMode:(unsigned)argument;

/*!
    @method     deleteModesInRange:
    @abstract   Deletes the modes for the given character range.
    @discussion The receiver will only manage the character range it is concerned with.
                If the given character lies before one of the receiver, the offset will be updated accordingly.
    @param      None
    @result     A flag indicating whether the receiver did remove some modes, ie its length as decreased.
*/
- (BOOL)deleteModesInRange:(NSRange)aRange;

/*!
    @method     moreStorage
    @abstract   allocates more storage for the receiver.
    @discussion Send this message when _NumberOfSyntaxWords equals _MaxNumberOfSyntaxWords.
    @param      None
    @result     A flag indicating whether the increase succeeded.
*/
- (BOOL)moreStorage;

- (BOOL)enlargeSyntaxModeAtGlobalLocation:(unsigned)aLocation length:(unsigned)length;
- (void)appendSyntaxMode:(unsigned)mode length:(unsigned)length;// beware: the _Length is updated too
- (BOOL)removeLastMode;// NO if no storage for modes
- (void)swapContentsWithModeLine:(iTM2ModeLine *)ML;

/*!
    @method     getSyntaxMode:atGlobalLocation:longestRange:
    @abstract   The syntax mode at the given location.
    @discussion Beware, if the _EOLMode is 0, the longest range is extended to include the EOL.
    @param      aModeRef
    @param      aLocation is a global location where we are looking for the mode
    @param      ref is a range reference where the mode range is returned
    @result     A flag indicating whether the increase succeeded.
*/

- (unsigned)getSyntaxMode:(unsigned *)modeRef atGlobalLocation:(unsigned)aLocation longestRange:(NSRangePointer)ref;
/*!
    @method     getPreviousSyntaxMode:notEqualTo:atGlobalLocation:longestRange:
    @abstract   The syntax mode at the given location.
    @discussion Used with excludeMode = regular text mode.
    @param      aModeRef
    @param      excludeMode
    @param      aLocation is a global location where we are looking for the mode
    @param      ref is a range reference where the mode range is returned
    @result     A flag indicating whether the increase succeeded.
*/
- (unsigned)getPreviousSyntaxMode:(unsigned *)modeRef notEqualTo:(unsigned)excludeMode atGlobalLocation:(unsigned)aGlobalLocation longestRange:(NSRangePointer)aRangePtr;

- (unsigned)numberOfSyntaxWords;
- (unsigned)syntaxModeAtIndex:(unsigned)index;
- (unsigned)syntaxLengthAtIndex:(unsigned)index;
//All these should be private
/*"Main methods"*/
- (id)initWithString:(NSString *)aString atCursor:(unsigned *)cursor;
- (void)describe;
/*"Overriden methods"*/
- (void)dealloc;
#ifdef __ELEPHANT_MODELINE__
- (NSString *)originalString;
#endif
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2TextStorageKit


/*!
    @const 		iTM2TextModeAttributeName
    @abstract   Private iTeXMac2 style extension.
    @discussion The value is "iTM2-Style".
                It is the file extension of a style wrapper.
*/
extern NSString * const iTM2TextStyleExtension;
extern NSString * const iTM2TextVariantExtension;

/*!
    @const 		iTM2TextStyleComponent
    @abstract   "Style" component.
    @discussion Styles are stored in Application\ Support/iTeXMac2/Style.
*/
extern NSString * const iTM2TextStyleComponent;

extern NSString * const iTM2TextAttributesModesComponent;
extern NSString * const iTM2TextAttributesDidChangeNotification;
extern NSString * const iTM2TextDefaultStyle;
extern NSString * const iTM2TextDefaultVariant;

@interface iTM2TextSyntaxParser(Attributes)

/*!
    @method	defaultModesAttributes
    @abstract	The default modes attributes of the receiver's instances.
    @discussion	If no external definition is found, these will be used.
                At least, you must define mode named:
                - iTM2TextDefaultSyntaxModeName,
                - iTM2TextErrorSyntaxModeName,
                - iTM2TextSelectionSyntaxModeName,
                - iTM2TextInsertionSyntaxModeName,
                - iTM2TextBackgroundSyntaxModeName.
                This is the minimal set that ensures that everything works ok.
                So, subclassers should add their own stuff to this dictionary to ensure some kind of forward compatibility.
    @param	None.
    @result	a dictionary.
*/
+ (NSDictionary *)defaultModesAttributes;

/*!
    @method	syntaxParserVariantsForStyle:
    @abstract	Abstract forthcoming.
    @discussion	Discussion forthcoming.
    @param	style is the style identifier
    @result	an attributes server class
*/
+ (NSDictionary *)syntaxParserVariantsForStyle:(NSString  *)style;

/*!
    @method	attributesServerWithStyle:variant:
    @abstract	Abstract forthcoming.
    @discussion	Discussion forthcoming.
    @param	style is the style identifier
    @param	variant is the variant identifier
    @result	a shared attributes server
*/
+ (id)attributesServerWithStyle:(NSString  *)style variant:(NSString *)variant;

/*!
    @method	createAttributesServerWithStyle:variant:
    @abstract	Abstract forthcoming.
    @discussion	Discussion forthcoming.
    @param	style is the style identifier
    @param	variant is the variant identifier
    @result	None
*/
+ (void)createAttributesServerWithStyle:(NSString  *)style variant:(NSString *)variant;

/*!
    @method	removeAttributesServerWithStyle:variant:
    @abstract	Abstract forthcoming.
    @discussion	Discussion forthcoming.
                This is the converse operation than the previous one.
    @param	style is the style identifier
    @param	variant is the variant identifier
    @result	None
*/
+ (void)removeAttributesServerWithStyle:(NSString  *)style variant:(NSString *)variant;

@end

/*!
    @class	iTM2TextSyntaxParserAttributesServer
    @abstract	The attributes server.
    @discussion	The class object maintains a list of attributes servers.
                Each syntax aprser has its own attributes server.
                It asks this object for attributes.
                Attributes servers are identified by the style and the variant.
                The style defines the class of the attributes server.
                The variants identifie for example the different sets of colors and fonts available.
                Any attributes server should have a default built in variant that is overriden by other variants if necessary.
                This is to anticipate changes.
                iTeXMac2 is shipped with a set of built in styles and variants.
                The user has the opportunity to override these built in variants or create new ones.
                iTeXMac2 reads as usual all its resources from built in domain to the user domain,
                such that built in is overriden by network, which is overriden by local, and finally overriden by user.
                All the style files are stored in an Application\ Support/iTeXMac2/Editor folder.
                The Editor contains folders named with the different styles.
                The style folders contain folders named with the variants.
                Those folders are file wrappers which contents are private, despite public.
                You can only edit the user domain. But you can copy the resulting files wherever you want
                to make it available to others.
*/
@interface iTM2TextSyntaxParserAttributesServer: NSObject
{
@private
    NSString * _Variant;
    BOOL _UpToDate;
@protected
    id _ModesAttributes;
}

/*!
    @method	initWithVariant:
    @abstract	Inits the receiver with the given variant. Designate initializer.
    @discussion	This method does not register the receiver as a shared attributes server.
                This is useful for the attributes editor.
                The syntax parser style is already known by the receiver.
    @param	variant is the variant identifier
    @result	an attributes server
*/
- (id)initWithVariant:(NSString *)variant;

/*!
    @method	shouldUpdateAttributes
    @abstract	Update the attributes of the receiver.
    @discussion	Don't use attributesDidChange, this method ensures that the attributes are updated only once,
                even if the attributes erver receives an update message from various syntax parsers.
    @param	None
    @result	None
*/
- (void)shouldUpdateAttributes;

/*!
    @method	attributesDidChange
    @abstract	Inform the receiver that the attributes did change.
    @discussion	The receiver is given a chance to preform any needed operation to remain up to date.
                This default implementation just resets the attributes to the default modes attributes,
                then it loads the modes attributes for its variant.
                Subclassers will append their own stuff.
                This message is sent from the -shouldUpdateAttributes method, if relevant.
    @param	None
    @result	None
*/
- (void)attributesDidChange;

/*!
    @method	syntaxParserVariant
    @abstract	The syntax parser variant of the receiver.
    @discussion	See the iTM2TextStorage documentation.
    @param	None
    @result	an NSString identifier
*/
- (NSString *)syntaxParserVariant;

/*!
    @method	modesAttributes
    @abstract	The attributes for all the modes.
    @discussion	Description forthcoming.
    @param	Node.
    @result	a dictionary of dictionaries of modes attributes.
*/
- (NSDictionary *)modesAttributes;

/*!
    @method	attributesForMode:
    @abstract	The attributes for the given mode.
    @discussion	Description forthcoming.
    @param	a mode.
    @result	a dictionary of mode attributes.
*/
- (NSDictionary *)attributesForMode:(NSString *)mode;

/*!
    @method	setAttributes:forMode:
    @abstract	Change the attributes for the given mode.
    @discussion	Description forthcoming.
    @param	the new attributes.
    @param	a mode.
    @result	None.
*/
- (void)setAttributes:(NSDictionary *)dictionary forMode:(NSString *)mode;

/*!
    @method	loadModesAttributesWithVariant:error:
    @abstract	The receiver loads the modes attributes with the given variant.
    @discussion	It loads the built in default attributes,
                then it loads the built in attributes if they are different,
                and finally it loads the other customized attributes from the various domains.
    @param	an NSString variant identifier
    @param	outErrorPtr is a pointer to an NSError instance
    @result	None
*/
+ (NSDictionary *)modesAttributesWithVariant:(NSString *)variant error:(NSError **)outErrorPtr;

/*!
    @method		builtInStylePaths
    @abstract	The built in style paths.
    @discussion	The built in style paths start from the framework containing the receiver,
				then scan the other frameworks and finally the main bundle.
				For all these frameworks, we look for resources Styles/style.iTM2-Style
				where style is the style of the receiver.
    @param		None
    @result		An array of paths
*/
+ (NSArray *)builtInStylePaths;

/*!
    @method		otherStylePaths
    @abstract	The other style paths.
    @discussion	They should be store in the various support folders at path
                /Network/Library/Application\ Support/iTeXMac2/Styles/syntaxParserStyle.iTM2-Style
                /Library/Application\ Support/iTeXMac2/Styles/syntaxParserStyle.iTM2-Style
                ~/Library/Application\ Support/iTeXMac2/Styles/syntaxParserStyle.iTM2-Style
                They are read in that listed such that the latter is given a chance to override the contents of the former.
    @param		None
    @result		An array of paths
*/
+ (NSArray *)otherStylePaths;

/*!
    @method	writeModesAttributes:toFile:error:
    @abstract	Store the given modes attributes to the given file location.
    @discussion	The storage model design is also here.
    @param	The attributes.
    @param	The file location.
    @param	outErrorPtr is a pointer to an NSError instance.
    @result	a flag indicating success or failure.
*/
+ (BOOL)writeModesAttributes:(NSDictionary *)dictionary toFile:(NSString *)fileName error:(NSError **)outErrorPtr;

/*!
    @method	modesAttributesWithContentsOfFile:error:
    @abstract	Mode attributes with the contents of the given file.
    @discussion	The storage model is here.
    @param	The file name.
    @param	outErrorPtr is a pointer to an NSError instance.
    @result	a dictionary.
*/
+ (NSDictionary *)modesAttributesWithContentsOfFile:(NSString *)fileName error:(NSError **)outErrorPtr;

/*!
    @method	character:isMemberOfCoveredCharacterSetForMode:
    @abstract	Whether the given character can be represented in the given mode.
    @discussion	The ASCII characters are assumed to be represented in any mode.
    @param	theChar
    @param	mode
    @result	a flag
*/
- (BOOL)character:(unichar)theChar isMemberOfCoveredCharacterSetForMode:(NSString *)mode;

@end
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2TextSyntaxAttributesKit
