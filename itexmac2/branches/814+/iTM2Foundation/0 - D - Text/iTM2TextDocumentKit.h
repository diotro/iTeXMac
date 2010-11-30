/*
//
//  @version Subversion: $Id$ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Fri Sep 05 2003.
//  Copyright © 2003 Laurens'Tribune. All rights reserved.
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

#import "iTM2DocumentKit.h"

extern NSString * const iTM3TextDocumentType;
extern NSString * const iTM2WildcardDocumentType;
extern NSString * const iTM2SupportTextComponent;
extern NSString * const iTM2TextInspectorType;

@class iTM2StringFormatController;

/*!
	@class		iTM2TextDocument
	@abstract	The basic text document.
	@discussion	Description forthcoming.
*/

@interface iTM2TextDocument: iTM2Document
{
@private
    NSString * iVarStringRepresentation4iTM3;
    iTM2StringFormatController * iVarStringFormatter4iTM3;
}
/*!
	@method		inspectorType4iTM3
	@abstract	Simply 'Text type'.
	@result		see above.
*/
+ (NSString *)inspectorType4iTM3;

/*!
	@property	textStorage
	@abstract	The text storage.
	@discussion	Forwards the message to its inspector.
	@result		For AppleScript® support at least.
*/
@property (assign, readonly) id textStorage;

/*!
	@method		stringRepresentation
	@abstract	String representation.
*/
@property (assign) NSString * stringRepresentation;

/*!
	@method		stringFormatter4iTM3
	@abstract	A string formatter.
	@discussion	The default implementation returns nil.
	@param		None
	@result		A string formatter.
*/
@property (assign) iTM2StringFormatController * stringFormatter4iTM3;
@property (readonly) id lazyStringFormatter;

/*!
	@property	EOL
	@abstract	Forwards the message to its string formatter wrapping in for undo support adding the undo management.
	@discussion Description forthcoming.
	@param		None
	@result		None
*/
@property (assign) NSUInteger EOL;

/*!
	@property	stringEncoding
	@abstract	Forwards the message to its string formatter wrapping in for undo support.
	@discussion Description forthcoming.
	@param		None
	@result		None
*/
@property (assign) NSStringEncoding stringEncoding;

/*!
	@property	stringEncodingHardCoded
	@abstract	Forwards the message to its string formatter wrapping in for undo support.
	@discussion Description forthcoming.
	@param		None
	@result		yorn
*/
@property (getter=isStringEncodingHardCoded) BOOL stringEncodingHardCoded;

/*!
	@method		revertDocumentToSavedWithStringEncoding:error:
	@abstract	Abstract forthcoming.
	@discussion Description forthcoming.
	@param		encoding is the encoding
	@param		outErrorPtr a pointer to an NSError instance.
	@result		yorn
*/
- (BOOL)revertDocumentToSavedWithStringEncoding:(NSStringEncoding)encoding error:(NSError **)outErrorPtr;

/*!
	@method			getLine:column:length:forHint:
	@abstract		Abstract forthcoming.
	@discussion		Discussion forthcoming.
	@param			lineRef points to a (valid) line number
	@param			columnRef points to a column number
	@param			lengthRef points to a length number
	@result			The level of the match, the smaller the better
	@availability	iTM2.
	@copyright		2005 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (NSUInteger)getLine:(NSUInteger *)lineRef column:(NSUInteger *)columnRef length:(NSUInteger *)lengthRef forHint:(NSDictionary *)hint;

@end

/*!
	@class		iTM2TextInspector
	@abstract	The basic text document inspector.
	@discussion	Subclassers are expected...
*/

@interface iTM2TextInspector: iTM2Inspector
{
@private
    NSTextStorage * iVarTextStorage4iTM3;
    NSMutableSet * iVarTextEditors4iTM3;
    NSTextView * iVarTextView4iTM3;
}
/*!
	@method		synchronizeWithDocument
	@abstract	This is where the inspector receives its text storage.
	@result		None.
*/
- (void)synchronizeWithDocument;

/*!
	@property	textStorage
	@abstract	This is the object edited.
	@result		an NSTextStorage like object.
*/
@property (assign) id textStorage;

/*!
	@property	lazyTextStorage
	@abstract	This is the object edited. Lazy initializer.
	@result		an NSTextStorage like object.
*/
@property (readonly) id lazyTextStorage;

/*!
	@property		textEditors
	@abstract	The text views of the receiver.
	@discussion	Discussion forthcoming.
	@result		a mutable array of views.
*/
@property (retain, readonly) NSMutableArray * textEditors;

/*!
	@property		textView
	@abstract	The main text view of the receiver.
	@discussion	If the receiver manages many different text views,
				this one should be the one that currently has the focus,
				or at least the last one that received the focus.
	@result		an NSTextView object, may be only a NSText object but it is not required.
*/
@property (retain, readonly) NSTextView * textView;

/*!
	@method		highlightAndScrollToVisibleLine:column:length:withHint:
	@abstract	Abstract forthcoming.
	@discussion The default implementation forwards the message to the text view.
	@param		line is a line number
	@param		column is a column number
	@param		length is a length number
	@result		None
*/
- (void)highlightAndScrollToVisibleLine:(NSUInteger)line column:(NSUInteger)column length:(NSUInteger)length;

/*!
	@property	EOL
	@abstract	Forwards the message to its string formatter wrapping in for undo support adding the undo management.
	@discussion Description forthcoming.
	@param		None
	@result		None
*/
@property (assign) NSUInteger EOL;

/*!
	@property	stringEncoding
	@abstract	Forwards the message to its string formatter wrapping in for undo support.
	@discussion Description forthcoming.
	@param		None
	@result		None
*/
@property (assign) NSStringEncoding stringEncoding;

/*!
	@method		isStringEncodingHardCoded
	@abstract	Forwards the message to its document.
	@discussion Description forthcoming.
	@param		None
	@result		yorn
*/
@property (readonly) BOOL isStringEncodingHardCoded;

@end

@interface iTM2TextDocument(Scripting)

/*!
	@method		replaceCharactersInRange:withString:
	@abstract	Abstract forthcoming.
	@discussion	Discussion forthcoming.
	@param		range is a range.
	@param		string is an NSString object.
	@result		None
*/
- (void)replaceCharactersInRange:(NSRange)range withString:(NSString *)string;

@end

@interface iTM2TextWindow: NSWindow
@end

/*!
	@protocol		iTM2TextEditor
	@abstract		Abstract forthcoming.
	@discussion		This is just a catcher protocol. Every NSTextView subclass conforming to this protocol
					is meant to share the text storage of the inspector. That way, there is no need for a real link
					in the nib, when the window is loaded, we just have to scan all the subviews,
					and configure properly the text views conforming to that protocol.
					For example, you can put into the nib any number of such text view,
					you are sure that they will share the same text storage (the one of the inspector...)
					Of course, this won't work if you need different text storages and automatic management...
	@availability	iTM2.
	@copyright		2005 jlaurens AT users DOT sourceforge DOT net and others.
*/

@protocol iTM2TextEditor
@end

/*!
	@class			iTM2TextEditor
	@superclass		NSTextView <iTM2TextEditor>
	@abstract		Abstract forthcoming.
	@discussion		This is the real editor implementing the protocol.
	@availability	iTM2.
	@copyright		2005 jlaurens AT users DOT sourceforge DOT net and others.
*/
@interface iTM2TextEditor: NSTextView <iTM2TextEditor>
{
@private
	id _Implementation;
}
- (void)scrollTaggedToVisible:(id)sender;
- (void)scrollTaggedAndRepresentedStringToVisible:(id)sender;
@property (readonly,retain) id implementation;
@end
