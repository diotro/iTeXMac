/*
//
//  @version Subversion: $Id: iTM2DocumentControllerKit.h 794 2009-10-04 12:33:28Z jlaurens $ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Fri Sep 05 2003.
//  Copyright © 2005 Laurens'Tribune. All rights reserved.
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

extern NSString * const iTM2AutosavingDelayKey;

/*! 
	@class		iTM2DocumentController
    @abstract   You are expected to use this document controller.
    @discussion Now come the important notes on the TeX document architecture.
                Documents are one of:
                - projects
                - flat documents
                Projects are standard or basic (these ones are used by standard projects as delegates),
                flat documents ares standalone or owned by standard projects.
                The shared document controller ownes standard projects and flat documents not owned by standard projects.
                There is a dedicated document controller that ownes the basic project documents.
                Each standard project document has a dedicated document controller to help it managing the documents it owns.
                The -documentForFileName: message is modified to return not only documents controlled by the shared document controller,
                but also documments controlled by projects.
				This document controller is used when you explicitely use the iTM2ApplicationDelegate.
*/

@interface iTM2DocumentController: NSDocumentController
{
	@private id _Implementation;
}
/*!
    @method		documentClassNameForTypeDictionary
    @abstract	A type to document class name map.
    @discussion	Plug-ins support. The extension <-> document type <-> document class relationship is managed by the main bundle and can be overriden by the plug-ins.
				All information coming from the main bundle Info.plist is not always managed by the standard cocoa methods as default.
				This method will manage what comes from all the other bundles.
    @param		None.
    @result		A dictionary of class names for document types.
*/
- (NSDictionary *)documentClassNameForTypeDictionary;

#if 0
/*!
    @method		typeFromFileExtensionDictionary
    @abstract	A type to file extensions (or HSF file types) map.
    @discussion	Plug-ins support. The extension <-> document type <-> document class relationship is managed by the main bundle and can be overriden by the plug-ins.
				All information coming from the main bundle Info.plist is still managed by the standard cocoa methods as default.
				This method will manage what comes from all the other bundles.
				The values are arrays of case insensitive file extensions, case sensitive HFS file types (4 chars)
				This is limited because the parsing of the Info.plist is not very strong,
				so the inherited method is first used to populate the base dictionary.
    @param		None.
    @result		A dictionary of file extension for document types.
	@status		Strongly deprecated in 2.1
*/
- (NSDictionary *)typeFromFileExtensionDictionary;
#endif

/*!
    @method		localizedTypeForContentsOfURL:error:
    @abstract	A localized name of document type.
    @discussion	Plug-ins support. The localized name is retrived from the various InfoPlist.strings files available.
				If the document type is not supported by the application, or has no localized entry,
				we use the NSWorkspace to find an application opening the file and retrieve the appropriate info from the app bundle.
				Something can be returned, even if typeForContentsOfURL:error: returns nil.
    @param		inAbsoluteURL, only file URL's are supported.
    @param		outErrorPtr.
    @result		A localized document type name owned by the receiver.
*/
- (NSString *)localizedTypeForContentsOfURL:(NSURL *)inAbsoluteURL error:(NSError **)outErrorPtr;

/*!
    @method		localizedDocumentTypesDictionary
    @abstract	A type to localized type dictionary.
    @discussion	Plug-ins support. See localizedTypeForContentsOfURL:error:.
    @param		None.
    @result		A dictionary.
*/
- (NSDictionary *)localizedDocumentTypesDictionary;

@property (retain) id _Implementation;
@end

@interface NSDocumentController(iTeXMac2)
- (void)saveAllDocumentsWithDelegate:(id)delegate didSaveAllSelector:(SEL)action contextInfo:(void *)contextInfo;

/*!
    @method		displayPageForLine:column:source:withHint:orderFront:
    @abstract	Abstract forthcoming.
    @discussion	Discussion forthcoming.
    @param		line: 1 based line index.
    @param		column: 1 based column index.
    @param		sourceURL: the URL of the source.
    @param		hint: dictionary containing hints.
    @param		yorn...
    @result		yorn.
*/
- (BOOL)displayPageForLine:(NSUInteger)line column:(NSUInteger)column source:(NSURL *)sourceURL withHint:(NSDictionary *)hint orderFront:(BOOL)yorn force:(BOOL)force;

/*!
 @method		forgetRecentDocumentURL:
 @abstract	Abstract forthcoming.
 @discussion	Discussion forthcoming.
 @param		absoluteURL: the url the receiver should forget...
 @result		None.
 */
- (void)forgetRecentDocumentURL:(NSURL *)absoluteURL;

/*!
 @method		forgetRecentDocumentURL:
 @abstract	Abstract forthcoming.
 @discussion	Discussion forthcoming.
 @param		absoluteURL: the url the receiver should forget...
 @result		None.
 */
- (void)forgetRecentDocumentURL:(NSURL *)absoluteURL;

@end

@interface NSDocument(iTM2DocumentControllerKit)

/*!
    @method		displayLine:column:length:withHint:orderFront:
    @abstract	Used in backwards synchronization.
    @discussion	Discussion forthcoming.
    @param		line: 1 based line index.
    @param		column: 1 based column index.
    @param		length: number of characters to be selected
    @param		hint: dictionary containing hints.
    @param		yorn...
    @result		yorn.
*/
- (BOOL)displayLine:(NSUInteger)line column:(NSUInteger)column length:(NSUInteger)length withHint:(NSDictionary *)hint orderFront:(BOOL)yorn;

/*!
    @method		getLine:column:length:forHint:
    @abstract	Used in backwards synchronization.
    @discussion	Discussion forthcoming.
    @param		lineRef: 1 based line index.
    @param		columnRef: 1 based column index.
    @param		lengthRef: number of characters to be selected
    @param		hint: dictionary containing hints.
    @result		yorn like value.
*/
- (NSUInteger)getLine:(NSUInteger *)lineRef column:(NSUInteger *)columnRef length:(NSUInteger *)lengthRef forHint:(NSDictionary *)hint;

/*!
    @method		displayPageForLine:column:source:withHint:orderFront:
    @abstract	Used in forwards synchronization.
    @discussion	Discussion forthcoming.
    @param		line: 1 based line index.
    @param		column: 1 based column index.
    @param		sourceURL: the URL of the source.
    @param		hint: dictionary containing hints.
    @param		yorn...
    @result		A document.
*/
- (BOOL)displayPageForLine:(NSUInteger)line column:(NSUInteger)column source:(NSURL *)sourceURL withHint:(NSDictionary *)hint orderFront:(BOOL)yorn force:(BOOL)force;

@end

@interface NSDocument(iTM2DocumentController)

/*!
    @method		newRecentDocument
    @abstract	The new recent document that should appear in the recent docs menu.
    @discussion	This  default implementation just returns the receiver itself.
                This is used in the notNewRecentDocument: of the SDC.
                Subclassers will override this method to add their own management.
                To prevent a document for being added to the recent docs menu item,
                simply return nil.
                Another document can be returned, namely the project document instead of the document itself.
    @param		None.
    @result		A document.
*/
- (id)newRecentDocument;

@end

@interface iTM2OpenQuicklyMenu: NSMenu
@end

@interface NSText(iTM2OpenQuickly)

/*!
    @method		openSelectionQuickly:
    @abstract	Open the selection quickly.
    @discussion	Description forthcoming.
*/
- (IBAction)openSelectionQuickly:(id)sender;

@end

@interface iTM2GhostDocument: NSDocument
@end

@interface NSString(iTM2DocumentController)

/*!
    @method		isEqualToUTType4iTM3:
    @abstract	Abstract forthcoming.
    @discussion	Description forthcoming.
    @param      otherType
    @result     yorn
*/
- (BOOL)isEqualToUTType4iTM3:(NSString *)otherType;

/*!
    @method		conformsToUTType4iTM3:
    @abstract	Abstract forthcoming.
    @discussion	Description forthcoming.
    @param      otherType
    @result     yorn
*/
- (BOOL)conformsToUTType4iTM3:(NSString *)otherType;

@end

