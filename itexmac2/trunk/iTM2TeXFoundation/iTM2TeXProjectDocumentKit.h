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

extern NSString * const iTM2TeXWrapperDocumentType;
extern NSString * const iTM2TeXWrapperPathExtension;

extern NSString * const iTM2TeXPInfoKey;

extern NSString * const iTM2TeXProjectTable;

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
    @method     helperProject
    @abstract   (brief description)
    @discussion Set it to no if the project has been edited in such a way that commands' behaviours are affected.
    @param      yorn (description)
    @result     None.
*/
- (id)helperProject;

/*!
    @method     setHelperProject:
    @abstract   (brief description)
    @discussion Set it to no if the project has been edited in such a way that commands' behaviours are affected.
    @param      yorn (description)
    @result     None.
*/
- (void)setHelperProject:(id)baseProject;

@end

#define iVarMode valueForKey: iTM2TPDKModeKey
#define iVarExtension valueForKey: iTM2TPDKExtensionKey
#define iVarPrettyExtension valueForKey: iTM2TPDKPrettyExtensionKey
#define iVarVariant valueForKey: iTM2TPDKVariantKey
#define iVarName valueForKey: iTM2TPDKNameKey
#define iVarOutput valueForKey: iTM2TPDKOutputKey

extern NSString * const iTM2TPDKModeKey;
extern NSString * const iTM2TPDKExtensionKey;
extern NSString * const iTM2TPDKPrettyExtensionKey;
extern NSString * const iTM2TPDKVariantKey;
extern NSString * const iTM2TPDKOutputKey;
extern NSString * const iTM2TPDKNameKey;

@interface NSString(iTM2TeXProjectDocumentKit)

/*! 
    @method     TeXProjectProperties
    @abstract   The receiver translated as TeX projects properties.
    @discussion Used by the inspectors in the mode/extension/output/variant choice.
				The name of the project is parsed to match (extension)mode+output-variant.
    @param      None
    @result     A dictionary
*/
- (NSDictionary *)TeXProjectProperties;

@end

@interface NSDictionary(TeXProjectProperties)

/*! 
    @method     TeXBaseProjectName
    @abstract   The receiver as TeX projects properties translated into a project name.
    @discussion Given the extension, core, variant and output, returns the name.
    @param      None
    @result     A NSString
*/
- (NSString *)TeXBaseProjectName;

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
    @method		iTM2_isTeXProjectPackageAtURL:
    @abstract	Abstract forthcoming
    @discussion	Whether the given full path points to a TeX project.
    @param      None
    @result     None
*/
- (BOOL)iTM2_isTeXProjectPackageAtURL:(NSURL *)url;

/*!
    @method		iTM2_isTeXWrapperPackageAtURL:
    @abstract	Abstract forthcoming
    @discussion	Whether the given full path points to a TeX wrapper.
    @param      None
    @result     None
*/
- (BOOL)iTM2_isTeXWrapperPackageAtURL:(NSURL *)url;

@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2TeXProjectDocument
