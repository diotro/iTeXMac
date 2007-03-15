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

#import <iTM2Foundation/iTM2DocumentKit.h>
#import <iTM2Foundation/iTM2TextStorageKit.h>
#import <iTM2Foundation/iTM2ResponderKit.h>

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2TextStyleEditionKit

extern NSString * const iTM2TextStyleInspectorType;

/*!
	@class			iTM2TextStyleDocument
	@superclass		iTM2Document
	@abstract		The editSyntaxParserAttributes: message wrapper.
	@discussion		This responder is inserted in the responder chain after NSApp when initialized.
					It is responsible of ordering front the panel.
	@availability	iTM2.
	@copyright		2005 jlaurens AT users DOT sourceforge DOT net and others.
*/
@interface iTM2TextStyleDocument: iTM2Document
@end

@interface iTM2TextStyleInspector: iTM2Inspector
@end

/*!
	@class			iTM2TextStyleResponder
	@superclass		iTM2AutoInstallResponder
	@abstract		Abstract forthcoming.
	@discussion		Discussion forthcoming.
	@availability	iTM2.
	@copyright		2005 jlaurens AT users DOT sourceforge DOT net and others.
*/
@interface iTM2TextStyleResponder: iTM2AutoInstallResponder
- (IBAction)textStyleEdit:(id)sender;
- (IBAction)textStyleToggle:(id)sender;
- (IBAction)textStyleToggleEnabled:(id)sender;
@end

/*!
	@class			iTM2TextStyleResponder(IB)
	@abstract		Abstract forthcoming.
	@discussion		Discussion forthcoming.
	@availability	iTM2.
	@copyright		2005 jlaurens AT users DOT sourceforge DOT net and others.
*/
@interface iTM2TextStyleResponder(IB)
- (IBAction)textStyleName:(id)sender;// a "Style:" localized title
- (IBAction)textStyleFormat:(id)sender;// a "%@(%@ variant)" localized title
- (IBAction)textStyleVariant:(id)sender;// a "Variant:" localized title
@end

/*!
	@class			iTM2TextSyntaxMenu
	@superclass		NSMenu
	@abstract		Abstract forthcoming.
	@discussion		Discussion forthcoming.
	@availability	iTM2.
	@copyright		2005 jlaurens AT users DOT sourceforge DOT net and others.
*/
@interface iTM2TextSyntaxMenu: NSMenu
@end

/*!
	@category		iTM2TextSyntaxParser(TextStyleEditorKit)
	@abstract		Abstract forthcoming.
	@discussion		Discussion forthcoming.
	@availability	iTM2.
	@copyright		2005 jlaurens AT users DOT sourceforge DOT net and others.
*/
@interface iTM2TextSyntaxParser(TextStyleEditorKit)

/*!
    @method     attributesDocumentClass
    @abstract   The attributes editor class of the receiver.
    @discussion This is used to automatically create an attributes editor when requested.
                Subclassers should not override this.
                If a syntax parser is defined with class name "className",
                a class named "classNameAttributesDocument" should also be defined as attributes class editor.
                The only requirement is that an attributes editor is a window controller that implements the
                syntaxParserVariant and setSyntaxParserVariant: messages.
    @param		None.
    @result     None.
*/
+ (Class)attributesDocumentClass;

/*!
    @method     prettySyntaxParserStyle
    @abstract   The pretty style of the receiver.
    @discussion Discussion forthcoming.
    @result     a human readable style.
*/
+ (NSString *)prettySyntaxParserStyle;

@end

/*!
	@class			iTM2TextSyntaxParserAttributesDocument
	@superclass		iTM2Document
	@abstract		Abstract forthcoming.
	@discussion		Discussion forthcoming.
	@availability	iTM2.
	@copyright		2005 jlaurens AT users DOT sourceforge DOT net and others.
*/
@interface iTM2TextSyntaxParserAttributesDocument: iTM2Document
+ (Class)syntaxParserClass;
- (id)initWithSyntaxParserVariant:(NSString *)variant error:(NSError **)outErrorPtr;
- (NSString *)syntaxParserVariant;
@end

/*!
	@category		iTM2TextSyntaxParserAttributesServer(TextStyleEditorKit)
	@abstract		Abstract forthcoming.
	@discussion		Discussion forthcoming.
	@availability	iTM2.
	@copyright		2005 jlaurens AT users DOT sourceforge DOT net and others.
*/
@interface iTM2TextSyntaxParserAttributesServer(TextStyleEditorKit)

/*!
    @method     prettySyntaxParserVariant
    @abstract   The pretty variant of the receiver.
    @discussion Discussion forthcoming.
    @result     a human readable style.
*/
- (NSString *)prettySyntaxParserVariant;

@end

/*!
	@class			iTM2TextSyntaxParserAttributesInspector
	@superclass		iTM2Inspector
	@abstract		Abstract forthcoming.
	@discussion		All the text syntax parser attributes inspectors must be a subclass of iTM2TSPAInspector.
	@availability	iTM2.
	@copyright		2005 jlaurens AT users DOT sourceforge DOT net and others.
*/
@interface iTM2TextSyntaxParserAttributesInspector:iTM2Inspector
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2TextStyleEditionKit
