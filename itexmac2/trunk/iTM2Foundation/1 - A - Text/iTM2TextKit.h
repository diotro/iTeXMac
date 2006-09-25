/*
//
//  @version Subversion: $Id$ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Sat Dec 08 2001.
//  Copyright © 2001-2002 Laurens'Tribune. All rights reserved.
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

/*!
@header iTM2TextKit
@discussion Description Forthcoming.
*/

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2TextKit

extern NSString * const iTM2StartPlaceholder;
extern NSString * const iTM2StopPlaceholder;
extern NSString * const iTM2TextTabAnchorKey;
extern NSString * const iTM2TextSelectionAnchorKey;
extern NSString * const iTM2TextInsertionAnchorKey;

@interface NSText(iTeXMac2)

/*!
@method breakTypingFlow
@abstract Breaks the typing flow with respect to undo management.
@discussion Used in the save document process and the insert macro one to separate the undo management.
*/
- (void)breakTypingFlow;

/*!
@method openSelectionQuickly:
@abstract Opens the selection quickly.
@discussion Description forthcoming.
*/
- (void)openSelectionQuickly:(id)sender;

@end


@interface NSText(iTM2TextKit_Highlight)

/*!
	@method		highlightAndScrollToVisibleLine:
	@abstract	Highlights and scrolls to visible the line with the given number.
	@discussion	Uses the receiver's highlightAndScrollToVisibleRange: message with the right argument..
	@param		aLine an integer.
	@result		None.
*/
- (void)highlightAndScrollToVisibleLine:(unsigned int)aLine;

/*!
	@method		highlightAndScrollToVisibleLine:column:length:
	@abstract	Highlights and scrolls to visible the line and column with the given numbers.
	@discussion	If the column number does not fit int the line range, the whole line is highlighted.
	@param		line an integer.
	@param		column an integer.
	@param		length an integer.
	@result		None.
*/
- (void)highlightAndScrollToVisibleLine:(unsigned int)line column:(unsigned int)column length:(unsigned int)length;

/*!
	@method		highlightAndScrollToVisibleLineRange:
	@abstract	Highlights and scrolls to visible the lines with the given range of numbers.
	@discussion	Uses the receiver's highlightAndScrollToVisibleRange: message with the right argument..
	@param		an NSRange.
*/
- (void)highlightAndScrollToVisibleLineRange:(NSRange)aLineRange;

/*!
	@method		highlightAndScrollToVisibleRange:
	@abstract	Highlights and scrolls to visible a range of characters.
	@discussion	Uses the receiver's textView's highlightAndScrollToVisibleRange: message with the right argument..
	@param		an NSString object.
*/
- (void)highlightAndScrollToVisibleRange:(NSRange)aRange;

/*!
	@method		highlightRange:cleanBefore:
	@abstract	Highlights the given range.
	@discussion	Uses the receiver's textView's highlightAndScrollToVisibleRange: message with the right argument..
	@param		an NSRange to be highlighted.
	@param		aFlag indicates whether previously highlighted ranges should be cleaned before.
*/
- (void)highlightRange:(NSRange)aRange cleanBefore:(BOOL)aFlag;

/*!
	@method		secondaryHighlightAtIndices:lengths:
	@abstract	Highlights and scrolls to visible a range of characters.
	@discussion	Uses the receiver's textView's highlightAndScrollToVisibleRange: message with the right argument..
	@param		an NSString object.
*/
- (void)secondaryHighlightAtIndices:(NSArray * )indices lengths:(NSArray *)lengths;

@end

@interface NSTextView(iTM2TextKit_Highlight)

/*!
    @method		insertStringArray:
    @abstract	Insert the list of texts at the insertion location.
    @discussion	This also manages the selected range. The text are concatenated
    @param		A list of strings.
    @result		None.
*/
- (void)insertStringArray:(NSArray *)textArray;

/*!
    @method		extendSelectionWithRange:
    @abstract	Add the range to the currently selected ranges.
    @discussion	Discussion forthcoming.
    @param		A range of characters.
    @result		None.
*/
- (void)extendSelectionWithRange:(NSRange)range;

/*!
    @method		visibleRange
    @abstract	Returns the visible range of characters.
    @discussion	Discussion forthcoming.
    @param		None.
    @result		A range of characters.
*/
- (NSRange)visibleRange;

/*!
	@method		highlightRange:cleanBefore:
	@abstract	Highlights the given range.
	@discussion	Uses the receiver's textView's highlightAndScrollToVisibleRange: message with the right argument..
	@param		an NSRange to be highlighted.
	@param		aFlag indicates whether previously highlighted ranges should be cleaned before.
*/
- (void)highlightRange:(NSRange)aRange cleanBefore:(BOOL)aFlag;

/*!
	@method		secondaryHighlightAtIndices:lengths:
	@abstract	Highlights and scrolls to visible a range of characters.
	@discussion	Uses the receiver's textView's highlightAndScrollToVisibleRange: message with the right argument..
	@param		an NSString object.
*/
- (void)secondaryHighlightAtIndices:(NSArray * )indices lengths:(NSArray *)lengths;

/*!
	@method		scaleFactor
	@abstract	The magnification of the receivcer.
	@discussion	The magnification is the ration of the frame width over the bounds width.
	@result		a positive ratio.
*/
- (float)scaleFactor;

/*!
	@method		setScaleFactor:
	@abstract	Change the magnification.
	@discussion	Set the receiver's magnification to the given value.
				The parameter must be a positive float
	@param		aMagnification is a positive float.
	@result		None
*/
- (void)setScaleFactor:(float)aMagnification;

- (IBAction)doZoomIn:(id)sender;
- (IBAction)doZoomOut:(id)sender;


@end

@interface NSLayoutManager(iTM2TextKit)

/*!
	@method		lineFragmentCharacterRangeForCharacterRange:
	@abstract	The character range of the line fragment containing the given character range
	@discussion	The given charater range corresponds to visible lines (taking auto wrapping into account)
				This methods returns the whole range of characters of these line fragments.
	@param		aCharacterRange is a character range. This must be a consistent character range.
	@param		yorn is a flag.
	@result		None
*/
- (NSRange)lineFragmentCharacterRangeForCharacterRange:(NSRange)aCharacterRange withoutAdditionalLayout:(BOOL)yorn;

@end

@interface NSColor(iTM2TextKit)

/*!
	@method		textRangeHighlightColor
	@abstract	Background color for highlighting range of text.
	@discussion	Red color...
	@param		an NSColor object.
*/
+ (NSColor *)textRangeHighlightColor;

@end

@interface NSTextView(Placeholder)
- (IBAction)selectNextPlaceholder:(id)sender;
- (IBAction)selectPreviousPlaceholder:(id)sender;
+ (NSString *)tabAnchorKey;
- (NSString *)tabAnchor;
- (void)selectNextTabAnchor:(id)sender;
- (void)selectPreviousTabAnchor:(id)sender;
- (void)selectNextTabAnchorAndDelete:(id)sender;
@end

@interface NSString(iTM2Placeholder)

/*!
	@method		rangeOfPlaceholderAtIndex:
	@abstract	Abstract forthcoming.
	@discussion	Discussion forthcoming.
	@param		An index.
*/
- (NSRange)rangeOfPlaceholderAtIndex:(unsigned)index;

/*!
	@method		componentsBySeparatingPlaceholders
	@abstract	Abstract forthcoming.
	@discussion	Turns the receiver into a list of strings, each one being a placeholder (enclosed in a "__(" ")__" pair)
				or contains no place holder at all. Placeholders are not allowed inside placeholders, "__(" and ")__" are added to ensure that.
	@param		None.
    @result     An array of strings
*/
- (NSArray *)componentsBySeparatingPlaceholders;

@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2TextKit
