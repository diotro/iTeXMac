/*
//
//  @version Subversion: $Id: iTM2ProjectControllerKit.h 574 2007-10-08 23:21:41Z jlaurens $ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Tue Sep 11 2001.
//  Copyright © 2001-2004 Laurens'Tribune. All rights reserved.
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

#define SPC [iTM2ProjectController sharedProjectController]
#define iTM2WindowsMenuItemIndentationLevel [self contextIntegerForKey:@"iTM2WindowsMenuItemIndentationLevel" domain:iTM2ContextAllDomainsMask]

extern NSString * const iTM2ProjectContextDidChangeNotification;
extern NSString * const iTM2ProjectCurrentDidChangeNotification;

extern NSString * const TWSFactoryExtension;

extern NSString * const iTM2SubdocumentsInspectorMode;

extern NSString * const iTM2ProjectTable;

extern NSString * const TWSFrontendComponent;

extern NSString * const iTM2ProjectDefaultsKey;

extern NSString * const iTM2NewDocumentEnclosedInWrapperKey;
extern NSString * const iTM2NewProjectCreationModeKey;

/*!
    @const      iTM2OtherProjectWindowsAlphaValue
    @abstract   The alpha component of inactive project windows values
    @discussion The real alpha component is multiplied by this value if the project is not the active one.
*/
extern NSString * const iTM2OtherProjectWindowsAlphaValue;

typedef enum
{
	iTM2PCFilterRegular = 0,
	iTM2PCFilterAbsoluteLink = 1,
	iTM2PCFilterRelativeLink = 2,
	iTM2PCFilterAlias = 3,
	iTM2PCFilterBookmark = 4
} iTM2ProjectControllerFilter;

#import "iTM2Implementation.h"

/*!
    @class    	iTM2ProjectController
    @abstract   The project controller class.
    @discussion The project controller maintains a list of all project documents to map documents to their projects.
				Some project documents belong to the standard cocoa document architecture 
				and are owned by the document controller. The shared project controller can own a list of projects,
				different from the ones owned by the document controller. Those are known as base projects.
				The project controller and the document controller are not meant to own both the same documents.
				Some important remark on the object to project mapping.
				Each document has a project (possibly nil) returned by the -project message.
				The default implementation just asks the shared project controller for such an object.
				For project documents, there is no need to ask the shared project controller: they are their own projects.
				Moreover, the project for document is not the designated entry point to retrieve the project of a document.
*/

@class iTM2ProjectDocument;

@interface iTM2ProjectController: iTM2Object
{
@private
	__weak id currentProject4iTM3;
    id projects4iTM3;
    id base_projects4iTM3;
    id cached_projects4iTM3;
    id reentrant_projects4iTM3;
    id base_names_of_ancestors4iTM3;
    id base_URLs_4_project_name4iTM3;
}
@property (readonly,assign) id currentProject;
@property (readonly,assign) NSMutableDictionary * baseNamesOfAncestorsForBaseProjectName;//    Utility, only use when informed
@property (readonly,assign) NSMutableDictionary * baseURLs4ProjectName;

/*! 
    @method		projects
    @abstract   The projects.
    @discussion The base projects plus the ones in the various application support folders.
				Base projects are not listed here.
    @param		None
    @result		An array
*/
@property (readonly,retain) NSHashTable * projects;

/*!
    @method     sharedProjectController
    @abstract   The shared project controller.
    @discussion Discussion forthcoming.
    @param      None.
    @result     An \p iTM2ProjectController instance.
*/
+ (id)sharedProjectController;

/*!
    @method     setSharedProjectController
    @abstract   Set the shared project controller.
    @discussion No project management if the shared project controller does not exist.
				If you nee project control, you should create such a controller very early,
				more precisely before project documents are created.
    @param      None.
    @result     An \p iTM2ProjectController instance.
*/
+ (void)setSharedProjectController:(id)argument;

/*!
    @method			normalizedURLWithURL:inProjectWithURL:
    @abstract		A normalized URL.
    @discussion		An URL if it can be properly decomposed with respect to the various project directories.
					
					If the given URL belongs to the factory of the project with projectURL,
					the returned NSURL instance is built based on the factory URL of this project.
					
					If the given URL belongs to the contents of the project with projectURL,
					the returned NSURL instance is built based on the contents URL of this project.

					If the given URL is not known by the project, then nil is returned.
					
					If the returned url is not nil, either it is absolute or it is relative to one of the various project directories.
					Whether an url must be absolute or relative is driven by the URL obtained with a regular filter.
					
					In all cases, url is returned if it is already normalized with respect to the project.
    @param			url is the NSURL to test.
    @param			projectURL is the project URL.
    @result			An NSURL instance.
	@availability	iTM2.
	@copyright		2008 jlaurens AT users DOT sourceforge DOT net and others.
*/
-(NSURL *)normalizedURLWithURL:(NSURL *)url inProjectWithURL:(NSURL *)projectURL;

/*!
    @method			reservedFileKeys
    @abstract		The list of reserved file keys.
    @discussion		The reserved file keys are ".", "project","source","factory","tool","target",...
    @param			key is the key to test.
    @result			An NSString instance.
	@availability	iTM2.
	@copyright		2008 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (NSArray *)reservedFileKeys;

/*!
    @method			isReservedFileKey:
    @abstract		Whether the given key is a reserved file key.
    @discussion		Discussion forthcoming.
    @param			key is the key to test.
    @result			yorn.
	@availability	iTM2.
	@copyright		2008 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (BOOL)isReservedFileKey:(NSString *)key;

/*!
    @method			URLForFileKey:filter:inProjectWithURL:
    @abstract		The URL for the given file key of the project with the given URL.
    @discussion		For reserved keys, this is either the project URL or the source URL...
					For file keys, this is either an absolute URL if the relative name is in fact an absolute URL
					or a the relative path of an URL based on the source URL of the given project URL.
    @param			key is a key.
    @param			filter is a filter that applies to the file, not the project.
    @param			projectURL is an URL.
    @result			A name.
	@availability	iTM2.
	@copyright		2008 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (NSURL *)URLForFileKey:(NSString *)key filter:(iTM2ProjectControllerFilter)filter inProjectWithURL:(NSURL *)projectURL;

/*!
    @method			fileKeysWithFilter:inProjectWithURL:
    @abstract		All the file keys of the project with the given URL.
    @discussion		For the regular filter, only file keys available in the main info property list are returned.
					The special keys for the project, factory and contents are not returned.
    @param			filter is a filter that applies to the file, not to projectURL.
    @param			projectURL is an URL.
    @result			An array of file keys.
	@availability	iTM2.
	@copyright		2008 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (NSArray *)fileKeysWithFilter:(iTM2ProjectControllerFilter)filter inProjectWithURL:(NSURL *)projectURL;

/*!
    @method			fileKeyForURL:filter:inProjectWithURL:
    @abstract		The file key for the given URL of the project with the given URL.
    @discussion		For all the -fileKeysOfProjectWithURL:,
					test whether the given fileURL is -URLForFileKey:inProjectWithURL:.
					If fileURL is one of the special URL's, namely the project, factory or contents one,
					the appropriate key is returned.
    @param			fileURL is an URL.
    @param			filter is a filter that applies to the file, not the project.
    @param			projectURL is an URL.
    @result			An array of file keys.
	@availability	iTM2.
	@copyright		2008 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (NSString *)fileKeyForURL:(NSURL *)fileURL filter:(iTM2ProjectControllerFilter)filter inProjectWithURL:(NSURL *)projectURL;

/*!
    @method     flushCaches
    @abstract   Abstract forthcoming.
    @discussion See below.
    @param      None.
    @result     None.
*/
- (void)flushCaches;

/*! 
    @method     projectForURL:
    @abstract   The project for the given URL.
    @discussion It just returns a project associate to the given file.
				At startup, this method allways returns nil and set the yornRef target to NO if relevant.
				While the program runs, projects are associate to file URLs (mainly by the -setProject:forURL: method).
				Once a project has been bound to a file URL, the subsequent calls to the present method will return that project.
				It is possible that a URL is explicitly bound to no project.
				Send the flushCaches message in order to reset all the file URL <-> project bindings,
				but beware not to send this message too often.
				This method is a MAJOR entry point.
    @param      fileURL is a full URL
    @result     A project document
*/
- (id)projectForURL:(NSURL *)fileURL;

/*! 
    @method     setProject:forURL:
    @abstract   Set the project for the given file name.
    @discussion Discussion forthcoming.
    @param      PD is any project document...
    @param		File name
	@result		None
*/
- (void)setProject:(id)PD forURL:(NSURL *)fileURL;

/*! 
    @method     projectForDocument:
    @abstract   The project for the given document.
    @discussion It asks for a project for the given document's file name.
				If there is one it is returned, and if it is the first time such a project is asked for,
				a new project is asked for through the -newProjectForFileNameRef: method.
				
				If no project is found, this document is marked as a "No project" document
				and the yornRef is set to point to NO if possible. This is the only situation where the value returned through yornRef is relevant.
				
				A primarily no project document has a chance to be associated to a project if its file name changes.
				<code>[SPC projectForDocument:document]</code>
				and <code>[SPC projectForURL:document.fileURL]</code>
				are not equivalent in the sense that the last one will never try to create a new project.
				This method is used by the default implementation of the document's -project method.
				You should not need to use this method except at initialization time or in your own implementation
				of the -project method.
				
				How does it work: first the cached project is returned if any.
				Then all the open projects are asked for their owning of the given document.
				When the document opens, is is expected that the correct project in the neighborhood is open too.
				If the document has a YES context bool for key: "_iTM2: Document With No Project",
				the nil project is returned.
				Finally, an open panel is presented for that purpose.
    @param      document is any document...
    @result     A project document
*/
- (id)projectForDocument:(NSDocument *)document;

/*! 
    @method     setProject:forDocument:
    @abstract   Set the project for the given document.
    @discussion This is the central method where the link from a document to its associate project is made.
				You must call this method to ensure that projectForDocument will return the expected answer.
				However, the project must already own the given document because this method does not take care of owning.
				If you pass nil as document, or an unnamed document, nothing happens.
				If you pass nil as project, the document is no longer associated to any project, despite it can still be owned by a project.
				You are expected to use this method once you have set up the correct owning links
				between the document and any project involved.
    @param      document is any document...
    @param		A project document in general owning the given document
	@result		None
*/
- (void)setProject:(id)PD forDocument:(NSDocument *)document;

/*! 
    @method     projectForSource:
    @abstract   The project for the given source.
    @discussion Any file MUST have a project, either useful or for convenience.
				For example, if iTM2 opens a text file or a dvi file just to see the contents
				for information purpose (suppose it's just a man or doc),
				there is no need of a real project, and a shared ghost project might be used.
				Standalone short files won't need any hard project,
				typically .tex files downloaded from the web will use convenient one shot projects stored in a temporary directory.
				If the directory containing the file is not writable, all the information of the project except the file
				itself will not be stored at the same level, whether in the file through embedded resources
				or in the file system as faraway resource. In that case, projects are stored either in the temporary directory if this makes sense,
				or in a dedicated location of a Caches subfolder. If the resource is not stored with the file, we must have a strong mapping
				binding the file and the associate resource. There can be problems if the file name changes.
				Given a file, we can use either the file name or an alias to the file to retrieve the project information.
				Both means should be used. If both lead to the same project, we have found that project.
				If both do not agree for the target project, the alias target should be used preferrably.
				We need two mappings: file name -> project, alias -> project.
				All the projects are referred to indirectly. We have different means to do that.
				If we take into account the user interface, the path components con be used for such a purpose.
				As such projects are collected in only one location, their path prefix is common.
				The next components will be used as key to uniquely identify the project.
				The key can be based on the file name of the original source file and a unique key identifier.
				What is the entropy put in this key? For the moment, nothing relevant.
				Here is the common location
				<code>~/Library/Application\ Support/Writable Projects.localized/...</code>
				to which we append the full path to the source base name with the correct path extension.
				This common location is referred to <code>[NSURL factoryURL4iTM3]</code>, because the projects are not stored near the file they are bound to.

				This is the mapping file name -> project.
				
				Question, what happens if a project is not writable?
				
				The file name is significantly longer than the one of the source.
				But this should not be a problem due to the actual size limit (4096 AFAIK).
				
				However, there might be a problem if different clients want to use this strategy. If they are concurrently creating a unique key,
				it is difficult to avoid collisions when each client does not know about the other one's intentions.
				
				The final components are the ones used by the user interface to display information to the user.
				Unlimited directory level should be used.
				
				Faraway projects are used for standalone documents.
    @param      The source is either a file name or a document.
    @result     A project document
*/
- (id)projectForSource:(id)source;

/*! 
    @method     currentProject
    @abstract   The current project.
    @discussion If the last current project owns (or is) the current document, it remains the current project.
				If the current document is not owned or is not the last current project,
				the project of the current document becomes the current project.
    @param      None
    @result     A project
*/
- (id)currentProject;

/*! 
    @method     registerProject:
    @abstract   register the given project.
    @discussion The project controller does not own the project. It only keeps a reference to the project.
				In general, the document controller will be the owner of the project.
				Subclassers will implement their own management for projects not owned by the document controller.
				The projectForURL: method returns one of the registered projects.
				Each time a project document is created, it is added as reference to the list of projects.
				Each time a project document is dealloced, its reference is removed from the list of project.
    @param      A project
    @result     None
*/
- (void)registerProject:(iTM2ProjectDocument *)project;

/*! 
    @method     forgetProject:
    @abstract   forget the given project.
    @discussion project are cached, so we must clean the cache when a project is closed or removed.
				This balances the -registerProject: above.
    @param      A project
    @result     None
*/
- (void)forgetProject:(id)project;

/*! 
    @method     bookmarksSubdirectory
    @abstract   The subdirectory where bookmarks are stored.
    @discussion The default implementation returns "frontends/comp.text.tex.iTeXMac2/Bookmarks". Subclasser should NOT override this.
    @param      None
    @result     a relative path
*/
- (NSString*)bookmarksSubdirectory;

/*! 
    @method     finderAliasesSubdirectory
    @abstract   The subdirectory where finder aliases are stored.
    @discussion The default implementation returns "frontends/comp.text.tex.iTeXMac2/Finder Aliases". Subclasser should NOT override this.
    @param      None
    @result     a relative path
*/
- (NSString*)finderAliasesSubdirectory;

/*! 
    @method     absoluteSoftLinksSubdirectory
    @abstract   The subdirectory where soft links are stored.
    @discussion The default implementation returns "frontends/comp.text.tex.iTeXMac2/Soft Links". Subclasser should NOT override this.
    @param      None
    @result     a relative path
*/
- (NSString*)absoluteSoftLinksSubdirectory;

/*! 
    @method     relativeSoftLinksSubdirectory
    @abstract   The subdirectory where relative soft links are stored.
    @discussion The default implementation returns "frontends/comp.text.tex.iTeXMac2/Relative Soft Links". Subclasser NOT should override this.
				The path stored is relative to the directory containing the *.texp folder.
    @param      None
    @result     a relative path
*/
- (NSString*)relativeSoftLinksSubdirectory;

/*! 
    @method     freshProjectForURLRef:display:error:
    @abstract   Create a new project.
    @discussion This method is split into different parts.
				This method is used by various other methods to ensure that some objects are really bound to a project.
				From build > 689, the policy has changed.
				No more standalone projects unless it is not possible to save.
				If there is a project located in a non writable location,
				we create a library counterpart which only contains the "Factory".
				An internal project is a directory wrapper found in the same directory or in a directory above.
				If the directory is not writable, the project is stored in an application support subfolder.
				In that case, it is called an library project.
				Let us explain this design in more details.
				Given the file name, the faraway project is always inside a wrapper.
				More precisely, if the file name is /my/dir/name/foo, then the associate wrapper is located in the folder
				Application\ Support/iTeXMac2/Projects/my/dir/name/
				or above. Which allows faraway projects to be shared by a file subhierarchy.
				In order to bind the wrapper and the source file, the wrapper will keep track of the source files.
				The included tex project will contain a list of finder aliases to the files they should be bound to.
				And soft links too.
				Managing recursivity. If a document is open, we are looking for an attached project.
				If the project is already open, we just have to verify that it knows about the document.
				If we try to open the project, we must be very careful in order to avoid recursive call.
				This method is expected to be reentrant. For that purpose, if the result is not already computed,
				it sends a willGetNewProjectForURL: message, make all the computations,
				then sends a final didGetNewProjectForURL: before it returns.
				The only purpose of these methods is just to break recursivity.
    @param      fileURLRef is a pointer to a file URL
    @param      display
    @param      outErrorPtr
    @result     A project.
*/
- (id)freshProjectForURLRef:(NSURL **)fileURLRef display:(BOOL)display error:(NSError **)outErrorPtr;

- (void)willGetNewProjectForURL:(NSURL *)fileURL;
- (void)didGetNewProjectForURL:(NSURL *)fileURL;
- (BOOL)canGetNewProjectForURL:(NSURL *)fileURL error:(NSError **)outErrorPtr;
- (id)createNewWritableProjectForURL:(NSURL *)fileURL display:(BOOL)display error:(NSError **)outErrorPtr;

/*! 
    @method     getProjectFromPanelForURLRef:display:error:
    @abstract   Create or open a new project document.
    @discussion The file name can change if the original document is moved around,
				in particular when making a TeX document wrapper.
				Problems of wrappers is not closed, in particular, the file name should change and the wrapper is replaced by its included project.
				It is expected that no project already exist for that file name,
				so use this method only when projectForURL: returns nil.
				This is a reentrant management: if there is already a panel waiting for the user input, NO is returned.
				There are only a few situations managed by this method.
				This is the user interface controller, to either create a new project or choose an already existing one.
				If no project is returned, it is what is wanted for the given file name,
				except when there is an error.
    @param      fileNameRef is a pointer to a file name
    @param      display is a flag to indicate if the UI is required
    @param      outErrorPtr is a pointer to an NSError instance
    @result     project document.
*/
- (id)getProjectFromPanelForURLRef:(NSURL **)fileURLRef display:(BOOL)display error:(NSError **)outErrorPtr;

/*! 
    @method		getProjectURLInWrapperForURL:error:
    @abstract   Abstract Forthcoming.
    @discussion Discussion Forthcoming.
    @param		fileName
    @param		outErrorPtr
    @result		An array of project file names
*/
- (NSURL *)getProjectURLInWrapperForURL:(NSURL *)fileURL error:(NSError **)outErrorPtr;

/*! 
    @method		getProjectURLsInHierarchyForURL:error:
    @abstract   Abstract Forthcoming.
    @discussion Discussion Forthcoming.
    @param		fileName
    @param		outErrorPtr
    @result		An array of project file names
*/
- (NSArray *)getProjectURLsInHierarchyForURL:(NSURL *)fileURL error:(NSError **)outErrorPtr;

/*! 
    @method		baseProjectNames
    @abstract   The base projects names known by the project controller.
    @discussion Discussion forthcoming.
    @param		None
    @result		A dictionary
*/
- (NSArray *)baseProjectNames;

/*! 
    @method		orderedBaseProjectNames
    @abstract   The base projects names known by the project controller, ordered from the shortest to the longest.
    @discussion Discussion forthcoming.
    @param		None
    @result		A dictionary
*/
- (NSArray *)orderedBaseProjectNames;

/*! 
    @method     countOfBaseProjects
    @abstract   The number of base projects.
    @discussion Discussion forthcoming.
    @param      None
    @result     A number
*/
- (NSUInteger)countOfBaseProjects;

/*! 
    @method     baseProjectWithName:
    @abstract   A project given its name.
    @discussion The name of the project is the base name of its path.
                Many different projects may have the same name.
                Particularly, when base projects are overriden by plugins.
                The return project inherits from all the other base projects with the same name.
    @param      projectName
    @result     A project
*/
- (id)baseProjectWithName:(NSString *)projectName;

/*! 
    @method     baseNamesOfAncestorsForBaseProjectName:
    @abstract   The names of the ancestors of the given base project name.
    @discussion This is a central point for base project inheritance mechanism.
				The lazy version is called and cached.
    @param      projectName
    @result     A project
*/
- (NSArray *)baseNamesOfAncestorsForBaseProjectName:(NSString *)name;

/*! 
    @method     lazyBaseNamesOfAncestorsForBaseProjectName:
    @abstract   For subclassers.
    @discussion Discussion forthcoming.
    @param      projectName
    @result     A project
*/
- (NSArray *)lazyBaseNamesOfAncestorsForBaseProjectName:(NSString *)name;

/*! 
    @method     isBaseProject:
    @abstract   Whether the receiver is a base project.
    @discussion A project is not a base project.
    @param      argument is the object to be tested
    @result     yorn.
*/
- (BOOL)isBaseProject:(id)argument;

/*! 
    @method     isProject:
    @abstract   Whether the receiver is a valid project.
    @discussion A valid project is either a base project or project owned by the shared document controller.
				Base projects are not considered as standard projects, such that isProject: ands -isBaseProject:
				are not expected to return YES at the same time.
    @param      argument is the object to be tested
    @result     yorn.
*/
- (BOOL)isProject:(id)argument;

/*! 
    @method     availableProjectsForURL:
    @abstract   Abstract forthcoming.
    @discussion Discussion forthcoming.
    @param      url...
    @result     an array of projects
*/
- (id)availableProjectsForURL:(NSURL *)url;

@end

enum {
	iTM2ToggleOldProjectMode = 0,		/* file belongs to an old project */
	iTM2ToggleNewProjectMode = 1,		/* create a new project for the file */
	iTM2ToggleStandaloneMode = 2,		/* No longer supported */
	iTM2ToggleNoProjectMode = 3,		/* Useful? */
	iTM2ToggleUnknownProjectMode = 4,	/* Useful? */
	iTM2ToggleForbiddenProjectMode=-1	/* Useful? */
};

@interface NSWorkspace(iTM2ProjectControllerKit)

/*!
    @method		isProjectPackageAtURL4iTM3:
    @abstract	Abstract forthcoming
    @discussion	Whether the given url points to a project.
				If the receiver returns YES to a method named fooProjectPackageAtURL4iTM3:
				except this one of course, the answer is YES.
				For example, a TeX project manager can implement in a category a method named isTeXProjectPackageAtURL4iTM3:
				Otherwise it's NO
    @param      None
    @result     None
*/
- (BOOL)isProjectPackageAtURL4iTM3:(NSURL *)url;

/*!
    @method		isWrapperPackageAtURL4iTM3:
    @abstract	Abstract forthcoming
    @discussion	Whether the given url points to a wrapper.
				If the receiver returns YES to a method named fooWrapperPackageAtURL4iTM3:
				except this one of course, the answer is YES.
				Otherwise it's NO
    @param      None
    @result     None
*/
- (BOOL)isWrapperPackageAtURL4iTM3:(NSURL *)url;

/*!
    @method		isBackupAtURL4iTM3:
    @abstract	Abstract forthcoming
    @discussion	Whether the given url points to a wrapper.
				If the receiver returns YES to a method named fooWrapperPackageAtURL4iTM3:
				except this one of course, the answer is YES.
				Otherwise it's NO
    @param      None
    @result     None
*/
- (BOOL)isBackupAtURL4iTM3:(NSURL *)url;

@end

@interface iTM2NoProjectSheetController: NSWindowController

/*!
    @method		alertForWindow:
    @abstract	Abstract forthcoming
    @discussion	Return one of the iTM2Toggle...ProjectMode's. Should be deprecated.
    @param		window is the sheet receiver.
    @result		YES if the user really wants no project.
*/
+ (BOOL)alertForWindow:(id)window;

@end

extern NSString * const iTM2ProjectBaseComponent;
extern NSString * const iTM3ProjectWritableProjectsComponent;

extern NSString * const iTM3ProjectPreferWrappers;

@interface NSBundle(iTM2Project)

/*!
    @method		temporaryBaseProjectsDirectoryURL4iTM3
    @abstract	The base projects directory url
    @discussion	This is the unique location where all the base projects are gathered by iTeXMac2.
				In fact it only contains symlinks to real base projects that are stored somewhere else.
				This folder contains links to various directories where base projects are to be found.
				The links are named with numbers starting from "0".
				Given a project name (for example "LaTeX"), gathering all the project for that name by browsing all the linked directories
				in alphabetical order (starting from "0", "1"...) will give the list of all the projects for that name,
				ordered from the most important to the lesser one.
				When looking for an information in a project given its name,
				one iterates the list of the gathered projects and stop when a project provides the expected information.
				In general, projects at the end of the list belong to the application bundle.
				Plugins come before and can override application base projects.
				Base projects in the various Library folders come before and can override both plugins and application defined base projects.
    @param		None.
    @result		The url.
*/
- (NSURL *)temporaryBaseProjectsDirectoryURL4iTM3;

@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2ProjectController
