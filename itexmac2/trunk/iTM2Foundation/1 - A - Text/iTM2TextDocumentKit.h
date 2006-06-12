/*
//  iTM2TextDocumentKit.h
//  iTeXMac2
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

#import <iTM2Foundation/iTM2DocumentKit.h>

extern NSString * const iTM2TextDocumentType;
extern NSString * const iTM2SupportTextComponent;
extern NSString * const iTM2WildcardDocumentType;
extern NSString * const iTM2TextInspectorType;

@class iTM2StringFormatController;

/*!
	@class		iTM2TextDocument
	@abstract	The basic text document.
	@discussion	Description forthcoming.
*/

@interface iTM2TextDocument: iTM2Document

/*!
	@method		inspectorType
	@abstract	Simply 'Text type'.
	@result		see above.
*/
+ (NSString *) inspectorType;

/*!
	@method		textStorage
	@abstract	The text storage.
	@discussion	Forwards the message to its inspector.
	@result		For AppleScript™ support.
*/
- (id) textStorage;

/*!
	@method		stringRepresentation
	@abstract	String representation.
*/
- (NSString *) stringRepresentation;

/*!
	@method		setStringRepresentation:
	@abstract	Setter of the string representation.
*/
- (void) setStringRepresentation: (NSString *) argument;

/*!
	@method		stringFormatter
	@abstract	A string formatter.
	@discussion	The default implementation returns nil.
	@param		None
	@result		A string formatter.
*/
- (id) stringFormatter;

/*!
	@method		setStringFormatter:
	@abstract	Basic setter.
	@discussion Description forthcoming.
	@param		None
	@result		None
*/
- (void) setStringFormatter: (id) argument;

/*!
	@method		EOL
	@abstract	Forwards the message to its string formatter wrapping in for undo support.
	@discussion Description forthcoming.
	@param		None
	@result		None
*/
- (unsigned int) EOL;

/*!
	@method		setEOL:
	@abstract	Forwards the message to its string formatter wrapping in for undo support adding the undo management.
	@discussion Description forthcoming.
	@param		None
	@result		None
*/
- (void) setEOL: (unsigned int) argument;

/*!
	@method		stringEncoding
	@abstract	Forwards the message to its string formatter wrapping in for undo support.
	@discussion Description forthcoming.
	@param		None
	@result		None
*/
- (NSStringEncoding) stringEncoding;

/*!
	@method		isStringEncodingHardCoded
	@abstract	Forwards the message to its string formatter wrapping in for undo support.
	@discussion Description forthcoming.
	@param		None
	@result		yorn
*/
- (BOOL) isStringEncodingHardCoded;

/*!
	@method		setStringEncoding:
	@abstract	Forwards the message to its string formatter adding the undo management.
	@discussion Description forthcoming.
	@param		None
	@result		None
*/
- (void) setStringEncoding: (NSStringEncoding) argument;

/*!
	@method		revertDocumentToSavedWithStringEncoding:
	@abstract	Abstract forthcoming.
	@discussion Description forthcoming.
	@param		encoding is the encoding
	@result		None
*/
- (void) revertDocumentToSavedWithStringEncoding: (NSStringEncoding) encoding;

/*!
	@method			getLine:column:forHint:
	@abstract		Abstract forthcoming.
	@discussion		Discussion forthcoming.
	@param			lineRef points to a (valid) line number
	@param			columnRef points to a column number
	@result			The level of the match, the smaller the better
	@availability	iTM2.
	@copyright		2005 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (unsigned int) getLine: (unsigned int *) lineRef column: (unsigned int *) columnRef forHint: (NSDictionary *) hint;

@end

/*!
	@class		iTM2TextInspector
	@abstract	The basic text document inspector.
	@discussion	Subclassers are expected...
*/

@interface iTM2TextInspector: iTM2Inspector

/*!
	@method		textStorage
	@abstract	This is the object edited.
	@result		an NSTextStorage like object.
*/
- (id) textStorage;

/*!
	@method		lazyTextStorage
	@abstract	This is the object edited. Lazy initializer.
	@result		an NSTextStorage like object.
*/
- (id) lazyTextStorage;

/*!
	@method		setTextStorage
	@abstract	Basic setter.
	@discussion	Description forthcoming.
	@param		an NSTextStorage like object.
*/
- (void) setTextStorage: (id) argument;

/*!
	@method		textEditors
	@abstract	The text views of the receiver.
	@discussion	Discussion forthcoming.
	@result		a mutable array of views.
*/
- (id) textEditors;

/*!
	@method		textView
	@abstract	The main text view of the receiver.
	@discussion	If the receiver manages many different text views,
				this one should be the one that currently has the focus,
				or at least the last one that received the focus.
	@result		an NSTextView object, may be only a NSText object but it is not required.
*/
- (id) textView;

/*!
	@method		highlightAndScrollToVisibleLine:column:
	@abstract	Abstract forthcoming.
	@discussion The default implementation forwards the message to the text view.
	@param		line is a line number
	@param		column is a column number
	@result		None
*/
- (void) highlightAndScrollToVisibleLine: (unsigned int) line column: (unsigned int) column;

/*!
	@method		EOL
	@abstract	Forwards the message to its string formatter wrapping in for undo support.
	@discussion Description forthcoming.
	@param		None
	@result		None
*/
- (unsigned int) EOL;

/*!
	@method		setEOL:
	@abstract	Forwards the message to its string formatter wrapping in for undo support adding the undo management.
	@discussion Description forthcoming.
	@param		None
	@result		None
*/
- (void) setEOL: (unsigned int) argument;

/*!
	@method		stringEncoding
	@abstract	Forwards the message to its string formatter wrapping in for undo support.
	@discussion Description forthcoming.
	@param		None
	@result		None
*/
- (NSStringEncoding) stringEncoding;

/*!
	@method		isStringEncodingHardCoded
	@abstract	Forwards the message to its string formatter wrapping in for undo support.
	@discussion Description forthcoming.
	@param		None
	@result		yorn
*/
- (BOOL) isStringEncodingHardCoded;

/*!
	@method		setStringEncoding:
	@abstract	Forwards the message to its string formatter adding the undo management.
	@discussion Description forthcoming.
	@param		None
	@result		None
*/
- (void) setStringEncoding: (NSStringEncoding) argument;

/*!
	@method		isStringEncodingHardCoded
	@abstract	Forwards the message to its document.
	@discussion Description forthcoming.
	@param		None
	@result		yorn
*/
- (BOOL) isStringEncodingHardCoded;

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
- (void) replaceCharactersInRange: (NSRange) range withString: (NSString *) string;

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
- (void) scrollTaggedToVisible: (id <NSMenuItem>) sender;
- (void) scrollTaggedAndRepresentedStringToVisible: (id <NSMenuItem>) sender;
@end
