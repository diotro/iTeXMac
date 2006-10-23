/*
//
//  @version Subversion: $Id$ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Tue Sep 11 2001.
//  Copyright © 2001-2004 Laurens'Tribune. All rights reserved.
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

#import <iTM2Foundation/iTM2InstallationKit.h>
#import <iTM2Foundation/iTM2Implementation.h>
#import <iTM2Foundation/iTM2ProjectDocumentKit.h>

@class 	iTM2TaskController;

extern NSString * const iTM2TeXProjectInfoComponent;

extern NSString * const iTM2TeXProjectDocumentType;
extern NSString * const iTM2TeXProjectPathExtension;
extern NSString * const iTM2TeXProjectInspectorType;
extern NSString * const iTM2TeXProjectInfoType;

extern NSString * const iTM2TeXWrapperDocumentType;
extern NSString * const iTM2TeXWrapperPathExtension;

extern NSString * const iTM2TeXPInfoKey;

extern NSString * const iTM2TeXProjectTable;

extern NSString * const TWSMasterFileKey;

extern NSString * iTM2ProjectLocalizedMasterName;

/*!
    @const      iTM2TeXProjectPathExtension
    @abstract   .texp
    @discussion The path extension of TeX project file wrappers
*/
extern NSString * const iTM2TeXProjectPathExtension;

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2TeXProjectDocument

/*! 
    @class		iTM2TeXProjectDocument
    @abstract   Abstract forthcoming.
    @discussion Discussion forthcoming.
*/

@interface iTM2TeXProjectDocument: iTM2ProjectDocument

/*! 
    @method     masterFileKey
    @abstract   The main key is the one for the main file.
    @discussion If this key is not present, one should be asked for.
				Do not assume that the key stored in the info property list is still valid.
				By default, this key should be ...iTM2FrontDocument, and will be dynamically
				replaced by the key of the project front most document.
    @param      None
    @result     a NSString
*/
- (NSString *)masterFileKey;
- (NSString *)realMasterFileKey;

/*! 
    @method     setMasterFileKey:
    @abstract   Set the main key.
    @discussion Description forthcoming.
    @param      key is the new key
    @result     None
*/
- (void)setMasterFileKey:(NSString *)key;

/*!
    @method     wasNotModified
    @abstract   (brief description)
    @discussion (comprehensive description)
    @result     (description)
*/
- (BOOL)wasNotModified;

/*!
    @method     setWasNotModified:
    @abstract   (brief description)
    @discussion Set it to no if the project has been edited in such a way that commands' behaviours are affected.
    @param      yorn (description)
    @result     None.
*/
- (void)setWasNotModified:(BOOL)yorn;

@end

@interface iTM2TeXPFilesWindow: NSWindow
@end

@interface iTM2TeXSubdocumentsInspector: iTM2SubdocumentsInspector

- (IBAction)help:(id)sender;
- (IBAction)projectPathEdited:(id)sender;
- (IBAction)takeMainFileFromRepresentedObject:(id)sender;
- (IBAction)fileNameEdited:(id)sender;
- (IBAction)takeStringEncodingFromTag:(id)sender;
- (IBAction)takeEOLFromTag:(id)sender;

@end

/*! 
    @class     	iTM2TeXProjectController:
    @abstract   The overriden project controller..
    @discussion iTeXMac2's shared project controller maintains a list of base projects.
                The purpose of base projects is to provide the user with built in settings to typeset documents.
                Base project are read from the different domains: built in iTeXMac2 application bundle,
				user domain, local domain, network domain "/library/Application Support/iTeXMac2/Base Projects".
                The latter overriden by the former.
                Those documents are not registered by the document controller.
                Projects will have a base one and will ask their associate base projects for default settings.
				For example, if a project does not know how to typeset a document,
				it will use the method defined by its base project.
                Projects will override these default settings if wanted.
                The project name is not case sensitive.
				There is no base project for a base project to avoid recursivity problems.
*/

@interface iTM2TeXProjectController: iTM2ProjectController

/*! 
    @method     updateTeXBaseProjectsNotified:
    @abstract   Update the cached list of base projects.
    @discussion All the base project documents are read from scratch.
    @param      the notification is not yet used
    @result     None
*/
- (void)updateTeXBaseProjectsNotified:(NSNotification *)irrelevant;

@end

@interface iTM2TeXWrapperDocument: iTM2WrapperDocument

/*!
    @method		representedClass
    @abstract	The represented class is the one targetted by the receiver
    @discussion	The default represented class is iTM2ProjectDocument.
    @param      None
    @result     None
*/
+ (id)representedClass;

@end

@interface NSWorkspace(iTM2TeXProjectDocumentKit)

/*!
    @method		isTeXProjectPackageAtPath:
    @abstract	Abstract forthcoming
    @discussion	Whether the given full path points to a TeX project.
    @param      None
    @result     None
*/
- (BOOL)isTeXProjectPackageAtPath:(NSString *)fullPath;

/*!
    @method		isTeXWrapperPackageAtPath:
    @abstract	Abstract forthcoming
    @discussion	Whether the given full path points to a TeX wrapper.
    @param      None
    @result     None
*/
- (BOOL)isTeXWrapperPackageAtPath:(NSString *)fullPath;

@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2TeXProjectDocument
