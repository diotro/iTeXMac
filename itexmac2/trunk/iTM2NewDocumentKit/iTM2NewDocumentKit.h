/*
//  iTM2NewDocumentKit.h
//  iTeXMac2
//
//  @version Subversion: $Id$ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Tue Sep 11 2001.
//  Copyright © 2005 Laurens'Tribune. All rights reserved.
//
//  This program is free software; you can redistribute it and/or modify it under the terms
//  of the GNU General public License as published by the Free Software Foundation; either
//  version 2 of the License, or any later version, modified by the addendum below.
//  This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
//  without even the implied warranty of MERCHANTABILITY or FITNESS FOR A pARTICULAR pURPOSE.
//  See the GNU General public License for more details. You should have received a copy
//  of the GNU General public License along with this program; if not, write to the Free Software
//  Foundation, Inc., 59 Temple place - Suite 330, Boston, MA 02111-1307, USA.
//  GPL addendum: Any simple modification of the present code which purpose is to remove bug,
//  improve efficiency in both code execution and code reading or writing should be addressed
//  to the actual developper team.
//
//  Version history: (format "- date:contribution(contributor)") 
//  To Do List: (format "- proposition(percentage actually done)")
*/

// all headers are private

/*!
    @header		iTM2NewDocumentKit
    @abstract   All the code for templates management
    @discussion Templates are documents used as seeds to create new documents.
				They are expected to be gathered in folders according to a logical organization.
				All the /Library/Application\ Support/iTeXMac2/Templates folders are involved
				with the usual precedence.
*/

extern NSString * const iTM2NewDDATEKey;// = @"__(DATE)__";
extern NSString * const iTM2NewDTIMEKey;// = @"__(TIME)__";
extern NSString * const iTM2NewDYEARKey;// = @"__(YEAR)__";
extern NSString * const iTM2NewDPROJECTNAMEKey;// = @"__(PROJECTNAME)__";
extern NSString * const iTM2NewDFULLUSERNAMEKey;// = @"__(FULLUSERNAME)__";
extern NSString * const iTM2NewDORGANIZATIONNAMEKey;// = @"__(ORGANIZATIONNAME)__";

extern NSString * const iTM2NewDPathComponent;

enum
{
	iTM2NewDOKReturn = 0,
	iTM2NewDCancelReturn = 1
};

/*!
    @class		iTM2NewDsController
    @abstract   Responsible for the management of templates and creation of new documents from templates.
    @discussion Description forthcoming
*/

@interface NSDocumentController(iTM2NewDocumentKit)

/*!
    @method     newDocumentFromRunningAssistantPanel:
    @abstract   New document created from an assistant panel.
    @discussion Present a panel where the user chooses a template document and a location to save 
				the new document to be created.
	@param		sender is an irrelevant argument, just like for all messages
	@result		A new document.
*/
- (IBAction)newDocumentFromRunningAssistantPanel:(id)sender;

/*!
    @method     newDocumentFromRunningAssistantPanelForProject:
    @abstract   New document created from an assistant panel, targeted to project.
    @discussion Present a panel where the user chooses a template document and a location to save 
				the new document to be created.
	@param		project
	@param		sender is an irrelevant argument, just like for all messages
	@result		A new document.
*/
- (void)newDocumentFromRunningAssistantPanelForProject:(id)project;

@end

@interface iTM2NewDocumentAssistant: iTM2Inspector

/*!
    @method     loadTemplates
    @abstract   Loads the templates in various places, either built in or plugged in.
    @discussion This not explains how the templates are organized. There is a localization problem addressed here.
				When the user chooses the new menu item, an assistant panel is ordered front and the user can choose within a list of documents.
				Templates documents are organized into folders.
				Template documents can be on of
				- tex project wrappers (extension texp)
				- standalone tex/other documents
				- whole projects wrapped in folders, either Mac OS X file wrappers or standard directories.
				When the user selects a template in the list, a small description and an image are provided in the panel, if they exist.
				The problems are
				- where to store the templates
				- to store this additional information
				- take into account localizations
				- make the difference between a template wrapped into a directory and a directory of templates.
				What makes the difference between a template wrapped into a directory and a directory of templates?
				We assume that a directory is considered a template as a whole when either
				- it is a file package or
				- it contains a file named "Contents", whenever it is a true file, symbolic linck or folder.
				When the template is copied to the final location, the "Contents" file embedded is wiped out.
				Where are templates stored?
				Templates are stored as built in or in the application support space in the "New Documents.localized" folder.
				When stored as built-in, templates are stored in the "New Documents.localized" folder of the current language resource folder.
				It is expected that each language has its own set of templates, and that tthe assistant panel will let the user change the language in order to have access to more specific templates.
				For example a french user will look at the us templates if he wants to write an article to an specific US journal.
				Moreover, some templatyes might have not yet been localized such that this approach won't hide part of iTM2 resources.
				New documents may live in any plug-in.
				How the description and image are stored?
				If the template is a whole folder, it is allowed to contain a "Contents" and is considered as a Mac OS X bundle by the assistant.
				More precisely, it will retrieve the description of the folder in a "templateDescription.txt" or preferrably a "templateDescription.rtf"
				located in the non localizable part of the folder:
				bundlePath/Contents/Resources/templateDescription.rtf
				The same for the template image, which should be located at
				bundlePath/Contents/Resources/templateImage.???
				For a standalone documents fully named foo.extension, the template description should be stored in a foo.extension.templateDescription
				bundle as above.
				How localization is managed?
				There is no specific localization management for the application support space.
				One more problem concerns the modifications made to the files when templates are duplicated.
				Nothing is completely done yet.
	@param		None.
	@result		None.
*/
+ (void)loadTemplates;

@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2NewDocumentKit
