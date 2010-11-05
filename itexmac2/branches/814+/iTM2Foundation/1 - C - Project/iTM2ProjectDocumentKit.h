/*
//
//  @version Subversion: $Id$ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Tue Sep 11 2001.
//  Copyright © 2001-2004 Laurens'Tribune. All rights reserved.
//
//  This program is free software; you can redistribute it and/or modify it under the terms
//  of the GNU General public License as published by the Free Software Foundation; either
//  version 2 of the License, or any later version, modified by the addendum below.
//  This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
//  without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
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

#import "iTM2ProjectControllerKit.h"

#define iTM2WindowsMenuItemIndentationLevel [self context4iTM3IntegerForKey:@"iTM2WindowsMenuItemIndentationLevel" domain:iTM2ContextAllDomainsMask]

extern NSString * const iTM2ProjectContextDidChangeNotification;
extern NSString * const iTM2ProjectCurrentDidChangeNotification;

extern NSString * const iTM2UTTypeWrapper;
extern NSString * const iTM2UTTypeProject;

extern NSString * const iTM2SubdocumentsInspectorMode;

extern NSString * const iTM2ProjectDefaultName;

extern NSString * const iTM2ProjectTable;

extern NSString * const TWSFrontendComponent;

extern NSString * const iTM2ProjectDefaultsKey;

extern NSString * const iTM2NewDocumentEnclosedInWrapperKey;
extern NSString * const iTM2NewProjectCreationModeKey;

extern NSString * const iTM2PROJECT_PATHComponent;

extern NSString * const iTM2ProjectFileKeyKey;

/*!
    @const      iTM2OtherProjectWindowsAlphaValue
    @abstract   The alpha component of inactive project windows values
    @discussion The real alpha component is multiplied by this value if the project is not the active one.
*/
extern NSString * const iTM2OtherProjectWindowsAlphaValue;

#import "iTM2DocumentKit.h"
#import "iTM2DocumentControllerKit.h"
#import "iTM2ResponderKit.h"

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2ProjectDocument

@interface iTM2SubdocumentsInspector: iTM2Inspector <NSWindowDelegate, NSTableViewDelegate, NSTableViewDataSource, NSOpenSavePanelDelegate>
{
@private
    NSMutableArray * iVarOrderedFileKeys4iTM3;
    NSTableView * iVarDocumentsView4iTM3;
}
/*! 
    @method     updateOrderedFileKeys
    @abstract   Updates the ordered list of file keys.
    @discussion Decription forthcoming.
    @param      None
    @result     a dictionary
*/
- (void)updateOrderedFileKeys;

/*! 
    @property   orderedFileKeys
    @abstract   Ordered list of file keys.
    @discussion This list is used while populating the receiver documents table view.
    @param      None
    @result     the new file keys
*/
@property (readonly, copy) NSMutableArray * orderedFileKeys;

/*! 
    @property     documentsView
    @abstract   The documents table view.
    @discussion Decription forthcoming.
    @param      None
    @result     a table view (or subclass)
*/
@property (readonly, assign) NSTableView * documentsView;

- (IBAction)newDocument:(id)sender;
- (IBAction)importDocument:(id)sender;
- (IBAction)removeDocument:(id)sender;
- (IBAction)help:(id)sender;
- (IBAction)projectPathEdited:(id)sender;

@end

/*! 
    @class iTM2ProjectDocument
    @abstract   Semi abstract class to implement project design.
    @discussion Complete discussion forthcoming.
				
				Now we discuss about subdocuments of the project.
				The subdocuments are or different types.
				Either they are refering to documents relative to the project, or they are absolute documents.
				Documents relative to the project are owned by the project and are not meant to be shared by different projects.
				On the contrary, absolute documents can be shared by different projects, the typical example concerns packages
				of a TeX distribution. For them, there is a versioning problem.
				Either we want a file relative to a specific distribution, or we want a file relative to the most recent distribution.
				Here we use the TeXDist structure which gives a path for the current distribution.
				That means that we must not always resolve symlinks.
				To manage all these situations, we use URL manipulation facilities.
				
				URL's must be properly formed.
				The shared project controller allows to normalize any URL with respect to a project see [SPC normalizedURLinProjectWithURL:].
*/

@interface iTM2ProjectDocument: iTM2Document
{
@private
    NSMutableSet * iVarMutableSubdocuments4iTM3;
}
/*! 
    @method     setFileURL:
    @abstract   Set the receiver file URL.
    @discussion The inherited method is overriden in order to have a normalized URL.
				We try to avoid absolute URL's to have more entropy.
				
				If the given URL is non void, we try to decompose it relative to the user's home directory or to the file system root.
    @param      None
    @result     None
*/
- (void)setFileURL:(NSURL*)url;

/*! 
    @method     factoryFileURL
    @abstract   The factory file URL.
    @discussion The factory serves two purposes.
				First, this is where the intermediate files are built.
				Second, this is where the project is stored if we have no write permission where it should be stored.
				
				The Factory domain is the directory
				~/Library/Application\ Support/iTeXMac2/Factory.localized
				
				Each project either belongs to the Factory domain or not. In the latter case, we say that the project is regular.
				
				If the project is regular, the factoryFileURL: is exactly the URL created with the relative path of the receiver and
				based on the main bundle's factoryURL.
				If the receiver belongs to the Factory domain, the fileURL and the factoryFileURL are the same.
    @param      None
    @result     an NSURL instance
*/
- (NSURL *)contentsURL;

/*! 
    @method     parentURL
    @abstract   The parent directory URL.
    @discussion If the receiver is not in the factory, the returned URL is the one of the parent directory.
				If the receiver is not in the factory, the returned URL is the regular counterpart of parent URL.
    @param      None
    @result     an NSURL instance
*/
- (NSURL *)parentURL;

/*! 
    @method     factoryURL
    @abstract   The factory directory URL.
    @discussion This is where intermediate files are stored while building.
				If the receivers belongs to a writable location,
				this is the "Factory" subdirectory of the receiver.
				If the receiver does not belong to a writable location,
				this is the cached counterpart.

				The result does have a base URL. The base URL is either
				<ul>
				<li>a real project URL if the receiver is writable and does not belong to the Writable Projects folder</li>
				<li>a fake project URL otherwise, which means the real project URL where the base URL is stripped down</li>
				</ul>
				
				Absolute path.
				
				This URL is cached by the project, as it is subject to change each time the file URL of the receiver changes
				it is not a good idea for a client to cache this value.
    @param      None
    @result     An  URL
*/
- (NSURL *)factoryURL;

/*! 
    @method     URLInFactoryForURL:
    @abstract   The URL in factory for the given URL.
    @discussion Files can live in different locations.
                Sometimes, they are built in intermediate places like the factory folder.
                This factory folder depends on the project and is not always located at the same relative place.
                Some files might be expected to be stored relative to the receiver's location but for some reason,
                they are stored in the factory folder instead. The given url must be relative to the receiver's location.
    @param      The original URL
    @result     An  URL
*/
- (NSURL *)URLInFactoryForURL:(NSURL *)theURL;

/*! 
    @method     removeFactory
    @abstract   Remove the Factory directory.
    @discussion Next build will have to create the whole build directory such that no cached information is available.
				This should be used whenever project options changed in such a way that cached information might be obsolete.
    @param      None
    @result     yes if something was deleted
*/
- (BOOL)removeFactory;

/*! 
    @method     projectName
    @abstract   The project name of the receiver.
    @discussion If the receiver has a consistent wrapper file name,
				the project name is the extensionless last path component of the wrapper file name.
				Otherwise, the project name is the extensionless last path component of the receiver's file name.
    @param      None
    @result     The name
*/
- (NSString *)projectName;
- (NSString *)baseProjectName;
- (void)setBaseProjectName:(NSString *)baseProjectName;


/*! 
    @method     wrapperURL
    @abstract   The wrapper URL of the receiver.
    @discussion The default implementation returns nil.
				See iTM2ProjectDocument for a real use of that when the project is part of a wrapper.
    @param      None
    @result     The wrapper file name
*/
- (NSURL *)wrapperURL;

/*! 
    @method     wrapper
    @abstract   The wrapper document of the receiver if any.
    @discussion Discussion forthcoming.
    @param      None
    @result     The wrapper document
*/
- (id)wrapper;

/*! 
    @method     setWrapper:
    @abstract   Set the wrapper of the receiver.
    @discussion Discussion forthcoming.
    @param      The new wrapper document
    @result     None
*/
- (void)setWrapper:(id)argument;

/*! 
    @method     setWrapper:
    @abstract   Set the wrapper of the receiver.
    @discussion Discussion forthcoming.
    @param      The new wrapper document
    @result     None
*/
- (void)setWrapper:(id)argument;

/*! 
 @method     subdocuments
 @abstract   The documents managed by the project
 @discussion A project is expected to manage a set of open documents.
 All open documents are to be owned by the project and not the shared document controller.
 If a project closes, it will record the list of open documents and open them the next time it opens.
 When project document are closed, they should be removed from the prohject document list.
 But you can do as you want...
 @param      Irrelevant.
 @result     None.
 */
@property (retain,readonly) NSSet * subdocuments;

/*! 
 @method     saveSubdocuments:
    @abstract   Saves all the open documents related to the projects
    @discussion Discussion forthcoming.
    @param      Irrelevant.
    @result     None.
*/
- (void)saveSubdocuments:(id)sender;

/*! 
    @method     addSubdocument:
    @abstract   add a document
    @discussion Does nothing if the document is the project, the wrapper or nothing.
				Does nothing if the document already belongs to the project.
				In all other cases, adds the document to the project, which means that the project becomes the owner of the document.
				The document is then remove from the list of documents owned by the shared document controller.
				That way, a document cannot be owned at the same time by a project and the share document controller.
    @param      document to be added.
    @result     None.
*/
- (void)addSubdocument:(NSDocument *)document;

/*! 
    @method     forgetSubdocument:
    @abstract   forget a document
    @discussion Same as closeSubdocument: but without saving.
    @param      document to be removed.
    @result     None.
*/
- (void)forgetSubdocument:(NSDocument *)document;

/*! 
    @method     removeSubdocument:
    @abstract   remove a document
    @discussion Once removed, a document no longer belongs to a project.
    @param      document to be removed.
    @result     None.
*/
- (void)removeSubdocument:(NSDocument *)document;

/*! 
    @method     closeSubdocument:
    @abstract   Close a document
    @discussion Discussion Forthcoming.
    @param      document to be forgotten.
    @result     None.
*/
- (void)closeSubdocument:(NSDocument *)document;

/*! 
    @method     ownsSubdocument:
    @abstract   Whether the receiver owns the given document.
    @discussion Discussion forthcoming.
    @param      document to be quesried about.
    @result     yorn.
*/
- (BOOL)ownsSubdocument:(NSDocument *)document;

/*! 
    @method     fileKeyForURL:
    @abstract   The key for the given URL.
    @discussion Each file URL is given a unique key identifier.
				Once given this identifier will not change as long as the file is living.
				The unique possibility is to remove it.
				A cached list is maintained.
				Keys are just numbers as strings.
				Different files with different names might have the same key if they represent the same document:
				they can use links or finder aliases. The first time this method is sent,
				it tries to use some information cached when one of the createNewFileKeyForURL: or createNewFileKeyForURL:context:
				was previously used.
				When the project is cached, things are more complicated.
				The problem is to convert the absolute file name into a relative file name.
				Both the given file name and the project file name can live in the same domain
				with respect to the faraway projects directory. If not, one is converted to the other.
				This method does not create a new key for the file name. It just use the information that once was created
				either stored in the project or in a private cache.
				Use the createNewFileKeyForURL: or createNewFileKeyForURL:context: for that purpose.
    @param      fileURL is a full URL
    @result     An NSMutableDictionary
*/
- (NSString *)fileKeyForURL:(NSURL *)fileURL;

/*! 
    @method     showSubdocuments:
    @abstract   Show the files of the receiver.
    @discussion Discussion forthcoming.
    @param      irrelevant sender
    @result     None
*/
- (void)showSubdocuments:(id)sender;

/*! 
    @method     showSettings:
    @abstract   Show the settings of the receiver.
    @discussion This default implementation does nothing yet.
    @param      irrelevant sender
    @result     None
*/
- (void)showSettings:(id)sender;

/*! 
    @method     makeDefaultInspector
    @abstract   Creates the default project UI.
    @discussion If the receiver has no window controller (except the ghost one)
                a project document inspector is created unsing -makeSubdocumentsInspector message.
    @param      None
    @result     None
*/
- (void)makeDefaultInspector;

/*! 
    @method     makeSubdocumentsInspector
    @abstract   Creates the project documents UI.
    @discussion This default implementation does not implemnt anything yet.
                Subclassers will simply override the stuff.
    @param      None
    @result     None
*/
- (void)makeSubdocumentsInspector;
- (iTM2SubdocumentsInspector *)subdocumentsInspector;

/*! 
    @method     prepareFrontendCompleteWriteToURL4iTM3:ofType:error:
    @abstract   Prepare writing process.
    @discussion One of the first message sent while writing.
				The prupose is to ensure that there is an existing directory at the given path.
    @param      None.
    @result     result forthcoming
*/
- (BOOL)prepareFrontendCompleteWriteToURL4iTM3:(NSURL *)fileURL ofType:(NSString *) type error:(NSError**)outErrorPtr;

/*! 
    @method     projectCompleteWillClose4iTM3
    @abstract   Abstract forthcoming.
    @discussion Used to record the context state.
    @param      None.
    @result     result forthcoming
*/
- (void)projectCompleteWillClose4iTM3;

/*! 
    @method     subdocumentMightHaveClosed
    @abstract   Abstract forthcoming.
    @discussion Used to force the window menu to update (subclassing).
    @param      None.
    @result     result forthcoming
*/
- (void)subdocumentMightHaveClosed;

/*! 
    @method     createNewFileKeyForURL:
    @abstract   The key for the given file name.
    @discussion This method is obsolete, use the -(NSURL *)createNewFileKeyForURL:save: instead.
				It just forwards to the above mentionned method, not asking to save.
    @param      fileName is a full path name, or relative to the project directory
    @result     a unique key identifier
*/
- (NSString *)createNewFileKeyForURL:(NSURL *)fileURL;

/*! 
    @method     createNewFileKeyForURL:save:
    @abstract   The key for the given file name.
    @discussion If no key exists, a new one is created.
				A key is given only once. If it is removed, it won't be attributed another time.
				To ensure this, we store the next key to be used with a @".." file name.
				The .. refers to a directory outside the Wrapper and is likely not to be used.
    @param      fileName is a full path name, or relative to the project directory
    @param      yorn is a flag indicating whether the project should save if a new key is really created
    @result     a unique key identifier
*/
- (NSString *)createNewFileKeyForURL:(NSURL *)fileURL save:(BOOL)yorn;

/*! 
    @method     saveAllSubdocumentsWithDelegate:didSaveAllSelector:contextInfo:
    @abstract   Abstract forthcoming.
    @discussion Discussion forthcoming.
    @param      delegate
    @param      selector
    @param      context info
    @result     None
*/
- (void)saveAllSubdocumentsWithDelegate:(id)delegate didSaveAllSelector:(SEL)action contextInfo:(void *)contextInfo;

/*! 
    @property		fileKeys
    @abstract		All the file keys actually in use.
    @discussion		Description forthcoming.
    @param			None
    @result			an NSArray
	@availability	iTM2.
	@copyright		2007 jlaurens AT users DOT sourceforge DOT net and others.
*/
@property (assign,readonly) NSArray * fileKeys;

/*! 
    @method     keysDidChange
    @abstract   Abstract forthcoming.
    @discussion Discussion forthcoming.
    @param      None
    @result     None
*/
- (void)keysDidChange;

/*! 
    @method     removeFileKey:
    @abstract   Definitely forgets the key.
    @discussion The key is removed and all the attributes, properties for that key should be removed too.
				The receiver is not responsible for the attributes written in other files.
				No undo management is considered.
				The master key should be managed!!!
    @param      fileName is a full path name
    @result     a unique key identifier
*/
- (void)removeFileKey:(NSString *)key;

/*! 
    @method     namesForFileKeys:
    @abstract   The relative file names for the given keys.
    @discussion Discussion forthcoming
    @param      an array of keys
    @result     an NSString
*/
- (NSArray *)namesForFileKeys:(NSArray *)keys;

/*! 
    @method     URLForFileKey:
    @abstract   The file URL for the given key.
    @discussion This is a convenience shortcut to the SPC's -URLForFileKey:filter:inProjectWithURL: method.
    @param      a key
    @param      filter
    @result     an NSURL
*/
- (NSURL *)URLForFileKey:(NSString *)key;
- (NSArray *)URLsForFileKeys:(NSArray *)keys;

/*! 
    @method     setURL:forFileKey:
    @abstract   Changes the file URL for the given key.
    @discussion This is a basic setter with NO side effect (except cleaning some private caches).
				If the key is not covered by the allKeys list of the receiver, nothing is done.
    @param      fileName is the new file name, assumed to be a valid full path.
    @param      key is a key
    @param      flag is a flag
    @result     A normalized URL.
*/
- (NSURL *)setURL:(NSURL *)fileURL forFileKey:(NSString *)key;

/*! 
    @method     factoryURLForFileKey:
    @abstract   The factory file URL for the given key.
    @discussion Discussion forthcoming.
    @param      a key
    @result     an NSURL
*/
- (NSURL *)factoryURLForFileKey:(NSString *)key;// different from URLForFileKey: for factory projects ATTENTION

/*! 
    @method     nameForFileKey:
    @abstract   The name for the given file key.
    @discussion Discussion forthcoming.
	@param      key is a file key
    @result     The name.
*/
- (NSString *)nameForFileKey:(NSString *)key;

/*! 
    @method     setName:forFileKey:
    @abstract   Changes the name for the given file key.
    @discussion Discussion forthcoming.
    @param      name is the new file name, assumed to be a valid relative name.
    @param      key is a file key
    @result     None.
*/
- (void)setName:(NSString *)name forFileKey:(NSString *)key;

/*! 
    @method     subdocumentForURL:
    @abstract   The project document for the given URL.
    @discussion Only file URL's are managed. If the receiver does not declare a document with the file name (given as URL), nil is returned.
    @param      file name is a full path
    @result     a project document.
*/
- (id)subdocumentForURL:(NSURL *)url;

/*! 
    @method     fileKeyForSubdocument:
    @abstract   The key for the given project document.
    @discussion If no key is returned, the given document is not part of the receiver as a project.
				This message is a central node that links documents with their projects.
				It is assumed that once an NSDocument instance belongs to one project, it won't change its owner!
				It is possible for a NSDocument instances owned by the shared document controller,
				to change its owner, but it is the only possibility.
				By the way, there is something possibly problematic when two projects own the same document.
				Besides this is a weird situation, we can imagine that two different projects can act differently on the same document.
				Then it would be difficult to link the document to both projects.
    @param      \p subdocument is a document
    @result     a key identifier.
*/
- (NSString *)fileKeyForSubdocument:(NSDocument *)subdocument;

/*! 
    @method     subdocumentForFileKey:
    @abstract   The project subdocument for the given key.
    @discussion It is not advisable to identify the project a document belongs to through its key
				despite it would be technically possible whereas very expensive.
				This is why this message must be targeted to the right project.
				This method returning nil does not mean that the key is not a valid key for that project.
				It just means that there is no open project document for that key, that's all.
				The key <-> subdocument is one to one
    @param      a key identifier
    @result     a project document.
*/
- (id)subdocumentForFileKey:(NSString *)key;

/*! 
    @method     propertyValueForKey:fileKey:contextDomain:
    @abstract   The property value for the given key and file key.
    @discussion If there is no property value for the given key and the given file key,
				defaults values restructed to the project context are returned instead.
				If there is still nothing to return, global user defaults values are returned.
    @param      key is a key
    @param      fileKey is a file name
	@param		mask is a context domain mask
    @result     a language.
*/
- (id)propertyValueForKey:(NSString *)key fileKey:(NSString *)fileKey contextDomain:(NSUInteger)mask;

/*! 
    @method     fileKeyForRecordedURL:
    @abstract   Only use the links or finder aliases.
    @discussion Discussion forthcoming.
    @param      (NSURL *) is a file URL
    @result     a key.
*/
- (NSString *)fileKeyForRecordedURL:(NSURL *)fileURL;// only use the links or finder aliases

/*! 
    @method     setPropertyValue:forKey:fileKey:contextDomain:
    @abstract   Set the given property for the given key and file key.
    @discussion Also sets default properties in the project context and in the user defaults data base.
    @param      property is a standard  property list object
    @param      key is a key
    @param      fileKey is a file name
    @param      mask is a context domain mask
    @result     a value.
*/
- (void)setPropertyValue:(id)property forKey:(NSString *)key fileKey:(NSString *)fileKey contextDomain:(NSUInteger)mask;

/*! 
    @method     addGhostWindowController:
    @abstract   Abstract forthcoming.
    @discussion The ghost window controller ensures the project will not close when all the visible windows are closed.
				There is always one window that is not closable.
    @param      None
    @result     None
*/
- (void)addGhostWindowController;

/*! 
    @method     addURL:
    @abstract   Abstract forthcoming.
    @discussion Description forthcoming.
    @param      fileName
    @result     None.
*/
- (void)addURL:(NSURL *)fileURL;

/*! 
    @method     openSubdocumentWithContentsOfURL:context:display:error:
    @abstract   Open the project documennt.
    @discussion Once this method ends, the project used to be bound to the given url, wherever it is.
				Don't use this method to test if a project is bound to a given path.
    @param      irrelevant sender
    @result     None
*/
- (id)openSubdocumentWithContentsOfURL:(NSURL *)fileURL context:(NSDictionary *)context display:(BOOL)display error:(NSError**)outErrorPtr;

/*! 
    @method     openSubdocumentForKey:display:error:
    @abstract   Open the project documnt.
    @discussion Once this method ends, the project used to be bound to the given key.
				Don't use this method to test if a project is bound to a given path.
    @param      irrelevant sender
    @result     None
*/
- (id)openSubdocumentForKey:(NSString *)key display:(BOOL)display error:(NSError**)outErrorPtr;

/*! 
    @method     shouldCloseWhenLastSubdocumentClosed
    @abstract   Close when last subdocument closed.
    @discussion Whether the receiver should close when its last subdocument closed.
    @param      None
    @result     a flag
*/
- (BOOL)shouldCloseWhenLastSubdocumentClosed;

/*! 
    @method     setShouldCloseWhenLastSubdocumentClosed:
    @abstract   Set the receiver closing behavior.
    @discussion Sets whether the receiver should close when its last subdocument closed.
				At initialization time, this flag is set to NO.
				This flag is automatically set to YES while exiting the showWindows method.
    @param      yorn
    @result     None
*/
- (void)setShouldCloseWhenLastSubdocumentClosed:(BOOL)yorn;

/*! 
    @method     fixProjectConsistency
    @abstract   Fix the consistency of the receiver.
    @discussion Just in case someone has moved files around.
    @param      None
    @result     yorn
*/
- (BOOL)fixProjectConsistency;

- (void)dissimulateWindows;
- (void)exposeWindows;

/*! 
    @method     saveContext4iTM3:
    @abstract   Abstract forthcoming.
    @discussion Overriding the inherited message.
				First of all, the documents of the receiver are sent a -saveContext4iTM3: message.
				Then the inherited method is performed.
				Finally, the receiver sends itself all the messages -...MetaWriteToFile:ofType:
				with the receiver's file name and file type as arguments.
				This gives third parties an opportunity to automatically save their own context stuff at appropriate time.
    @param      irrelevant sender
    @result     None
*/
- (void)saveContext4iTM3:(id)irrelevant;

/*! 
    @method     context4iTM3ValueForKey:fileKey:domain:
    @abstract   Abstract forthcoming.
    @discussion The project is expected to manage the contexts of the files it owns.
				The standard user defaults database is used in the end of the chain.
    @param      \p aKey is the context key
    @param      \p fileKey is the file key
	@param		\p mask is a context domain mask
    @result     An object.
*/
- (id)context4iTM3ValueForKey:(NSString *)aKey fileKey:(NSString *)fileKey domain:(NSUInteger)mask;

/*! 
    @method     getContext4iTM3ValueForKey:fileKey:domain:
    @abstract   Abstract forthcoming.
    @discussion The project is expected to manage the contexts of the files it owns.
				The standard user defaults database is used in the end of the chain.
				This is used only by subclassers when overriding.
    @param      \p aKey is the context key
    @param      \p fileKey is the file key
	@param		\p mask is a context domain mask
    @result     An object.
*/
- (id)getContext4iTM3ValueForKey:(NSString *)aKey fileKey:(NSString *)fileKey domain:(NSUInteger)mask;

/*! 
    @method     takeContext4iTM3Value:forKey:fileKey:domain:
    @abstract   Abstract forthcoming.
    @discussion See the \p -context4iTM3ValueForKey:fileKey: comment.
    @param      the value, possibly nil.
    @param      \p aKey is the context key
    @param      \p fileKey is the file key
	@param		\p mask is a context domain mask
    @result     yorn whether something has changed.
*/
- (NSUInteger)takeContext4iTM3Value:(id)object forKey:(NSString *)aKey fileKey:(NSString *)fileKey domain:(NSUInteger)mask;

/*! 
    @method     setContext4iTM3Value:forKey:fileKey:domain:
    @abstract   Abstract forthcoming.
    @discussion See the \p -context4iTM3ValueForKey:fileKey: comment.
				This should only be used by subclassers.
    @param      the value, possibly nil.
    @param      \p aKey is the context key
    @param      \p fileKey is the file key
	@param		\p mask is a context domain mask
    @result     yorn whether something has changed.
*/
- (NSUInteger)setContext4iTM3Value:(id)object forKey:(NSString *)aKey fileKey:(NSString *)fileKey domain:(NSUInteger)mask;

/*! 
    @method     allowsSubdocumentsInteraction
    @abstract   Whether the subdocuments interactions.
    @discussion When the receiver is opening its subdocuments,
				some bad user experience can happen.
				In particular if 2 subdocuments must be synchronized,
				something weird can happen.
				This message returns YES in general, except when the
				receiver opens all its subdocuments.
    @param      None
    @result     None
*/
- (BOOL)allowsSubdocumentsInteraction;

@end

/*!
    @const		iTM2ProjectBookmarkKey
    @abstract   Context key
    @discussion value: @"iTM2ProjectBookmark"
*/
extern NSString * const iTM2ProjectBookmarkKey;

/*!
    @const		iTM2ProjectAbsolutePathKey
    @abstract   Context key
    @discussion value: @"iTM2ProjectAbsolutePath"
*/
extern NSString * const iTM2ProjectAbsolutePathKey;

/*!
    @const		iTM2ProjectRelativePathKey
    @abstract   Context key
    @discussion value: @"iTM2ProjectRelativePathKey"
*/
extern NSString * const iTM2ProjectRelativePathKey;

/*!
    @const		iTM2ProjectOwnRelativePathKey
    @abstract   Context key
    @discussion value: @"iTM2ProjectOwnRelativePathKey"
*/
extern NSString * const iTM2ProjectOwnRelativePathKey;

/*!
    @const		iTM2ProjectOwnAbsolutePathKey
    @abstract   Context key
    @discussion value: @"iTM2ProjectOwnAbsolutePathKey"
*/
extern NSString * const iTM2ProjectOwnAbsolutePathKey;

/*!
    @const		iTM2ProjectOwnAliasKey
    @abstract   Context key
    @discussion value: @"iTM2ProjectOwnAliasKey"
*/
extern NSString * const iTM2ProjectOwnAliasKey;

/*!
    @const		iTM2ProjectAliasKey
    @abstract   Context key
    @discussion value: @"iTM2ProjectAliasKey"
*/
extern NSString * const iTM2ProjectAliasKey;

/*!
    @const		iTM2ProjectURLKey
    @abstract   Context key
    @discussion value: @"iTM2ProjectURLKey"
*/
extern NSString * const iTM2ProjectURLKey;

@interface NSDocument(iTM2ProjectKit)

/*! 
    @method     project4iTM3
    @abstract   Abstract forthcoming.
    @discussion Convenient method as shortcut. If the resceiver -hasProject, the default implementation
				uses the shared project controller -projectForURL: message to return a value.
    @param      None
    @result     A project
*/
- (id)project4iTM3;

/*! 
    @method     wrapper4iTM3
    @abstract   Abstract forthcoming.
    @discussion Convenient method as shortcut to the project wrapper, if it makes sense.
    @param      None
    @result     A wrapper
*/
- (id)wrapper4iTM3;

/*! 
    @method     hasProject4iTM3
    @abstract   Abstract forthcoming.
    @discussion Not all documents naturally pertain to projects.
				The default implementation always return NO for documents with no implementation.
				Subclassers will either oeverride the methods to provide some storage or implement an implementation.
				The iTM2Document subclass implements an implementation but does not have any project by default.
				Wrapper is reentrant such that you can have a nil wrapper despite there should be non void one.
				This is simply due to the fact that the wrapper is being computed.
				In general, you should be careful because of this nil feature.
				For example, one of the related problems is to read context info whilst the project and the wrapper are not known...
    @param      None
    @result     yorn
*/
- (BOOL)hasProject4iTM3;

/*! 
    @method     setHasProject4iTM3:
    @abstract   Abstract forthcoming.
    @discussion Basic setter with no side effect. This method should be used at initialization time
				if the subclass does have a project. It is expected for documents to keep their status unchanged
				with respect to projects. In extremely rare situation will you need to change the status dynamically.
    @param      yorn
    @result     None
*/
- (void)setHasProject4iTM3:(BOOL)yorn;

/*! 
    @method     context4iTM3ValueForKey:domain:
    @abstract   Abstract forthcoming.
    @discussion See the -takeContext4iTM3Value:forKey: discussion below.
    @param      key
    @result     A project
*/
- (id)context4iTM3ValueForKey:(NSString *)key domain:(NSUInteger)mask;

/*! 
    @method     takeContext4iTM3Value:forKey:domain:
    @abstract   Abstract forthcoming.
    @discussion This is the setter entry point for the context of documents owned by a project.
				The project records the context of each document of it own.
				Some file keys are reserved: dotted file keys.
				It also maintains a copy of each context value based on the file extension.
				Then scheme is the following:
				1 - saving a context value
				- one object asks to save the context value
				- the document is asked to save the context value
				- the project document is asked to save the context value
				The project is saving in 6 different location
				a - in the area reserved by the project to the document
				b - in an area reserved by the project to the documents which file names have the same extension
				c - in an area reserved by the project to the documents of the same type
				d - in the user defaults data base area reserved to the documents
					which file names have the same extension
				e - in the user defaults data base area reserved to the documents of the same type
				f - in the user defaults data base
				2 - retrieving a context value, for a document owned by a project
				The management of the context for the other documents remains unchanged 
				- one object asks for a context value
				- the document is asked for the context value
				- the project document is asked for the context value
				a - if the context value exists in the area reserved by the project to the document, it is returned
				b - if the context value exists in an area reserved by the project to the documents which file names
					have the same extension, it is returned
				c - if the context value exists in an area reserved by the project to the documents of the same type,
					it is returned
				d - if the context value exists in the user defaults data base area reserved to the documents
					which file names have the same extension, it is returned
				e - if the context value exists in the user defaults data base area reserved to the documents
					of the same type, it is returned
				f - if the context value exists in the user defaults data base, it is returned
    @param      value is the new value
    @param      key is the context value key
    @result     yorn whether something has changed.
*/
- (NSUInteger)takeContext4iTM3Value:(id)value forKey:(NSString *)key domain:(NSUInteger)mask;

/*!
	@method			documentProjectCompleteSaveContext4iTM3:
	@abstract		Save the project related information.
	@discussion		Automatically called by the -saveContext4iTM3: message.
					Save some info about the project. This overrides the standard behaviour declared in the iTM2ContextKit
	@result			None.
	@availability	iTM2.
	@copyright		2005 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (void)documentProjectCompleteSaveContext4iTM3:(id)sender;

@end

extern NSString * const iTM2WrapperInspectorType;

/*!
    @class		iTM2WrapperDocument
    @abstract	Wrapper document class
    @discussion	In this design there is only one project per project wrapper.
				In the future there could be many different projects for one wrapper,
				we will have then to manage a current project.
				The wrapper is owned by the project it represents.
*/
@interface iTM2WrapperDocument: iTM2Document

/*!
    @method		project
    @abstract	The represented project is the one wrapped by the receiver
    @discussion	The wrapper document is expected to be a folder with a project document inside.
				The project document is expected to live sometimes with possibly no wrapper,
				such that there is the need of an independant wrapper document.
*/
- (id)project4iTM3;

@end

@interface iTM2ProjectGhostWindow: NSWindow
@end

@interface NSDocumentController(ProjectDocumentKit)

/*!
    @method		projectDocumentType4iTM3
    @abstract	The project document type.
    @discussion	The default implementation just returns "Project Document".
    @param		None.
    @result		A project document type.
*/
- (NSString *)projectDocumentType4iTM3;

/*!
    @method		projectPathExtension4iTM3
    @abstract	The project path extension.
    @discussion	The default implementation just returns @"project".
    @param		None.
    @result		A project path extension.
*/
- (NSString *)projectPathExtension4iTM3;

/*!
    @method		wrapperDocumentType4iTM3
    @abstract	The project wrapper document type.
    @discussion	The default implementation just returns "Wrapper Document".
    @param		None.
    @result		A project document type.
*/
- (NSString *)wrapperDocumentType4iTM3;

/*!
    @method		wrapperPathExtension4iTM3
    @abstract	The wrapper path extension.
    @discussion	The default implementation just returns @"wrapper".
    @param		None.
    @result		A wrapper path extension.
*/
- (NSString *)wrapperPathExtension4iTM3;

@end

/*!
    @class		iTM2ProjectDocumentResponder
    @abstract	Abstract forthcoming
    @discussion	Description forthcoming. No public API yet.
*/
@interface iTM2ProjectDocumentResponder: iTM2AutoInstallResponder
@end

@interface NSWorkspace(iTM2ProjectDocumentKit)

/*!
    @method		isFilePackageAtURL4iTM3:
    @abstract	Abstract forthcoming
    @discussion	Whether the given url points to a file package.
    @param      The url
    @result     yorn
*/
- (BOOL)isFilePackageAtURL4iTM3:(NSURL *)url;

/*!
    @method		isProjectPackageAtURL4iTM3:
    @abstract	Abstract forthcoming
    @discussion	Whether the given url points to a project.
				If the receiver returns YES to a method named fooProjectPackageAtURL4iTM3:
				except this one of course, the answer is YES.
				For example, a TeX project manager can implement in a category a method named isTeXProjectPackageAtURL4iTM3:
				Otherwise it's NO
    @param      The url
    @result     yorn
*/
- (BOOL)isProjectPackageAtURL4iTM3:(NSURL *)url;

/*!
    @method		isBackupAtURL4iTM3:
    @abstract	Abstract forthcoming
    @discussion	Whether the given url points to a backup.
    @param      The url
    @result     yorn
*/
- (BOOL)isBackupAtURL4iTM3:(NSURL *)url;

/*!
    @method		isWrapperPackageAtURL4iTM3:
    @abstract	Abstract forthcoming
    @discussion	Whether the given url points to a wrapper.
				If the receiver returns YES to a method named fooWrapperPackageAtURL4iTM3:
				except this one of course, the answer is YES.
				Otherwise it's NO
    @param      The url
    @result     yorn
*/
- (BOOL)isWrapperPackageAtURL4iTM3:(NSURL *)url;

@end

/*!
    @category	NSURL(iTM2ProjectDocumentKit)
    @abstract	NSURL facts related to project management
    @discussion	This implementation and its facts are very important.
				We do rely on NSURL form.
				This means that we do not expect cocoa or anyone else to change the NSURL behind
				our back. More precisely, when an url is given with and absolute and a relative part,
				we expect that this split remains unchanged through the execution of the program.
				The base URL is something we do use actively.
				More precisely, a project URL can have 2 forms:
				<ul>
				<li>in the Application Support's Writable Projects folder, the baseURL is the URL of the
				Writable Projects folder, the relative URL starts from here.
				We call it a "Writable Project URL".</li>
				<li>in a standard location: an absolute URL.
				We call it a "Normal Projects URL".</li>
				</ul>
				
				As a consequence, the base URL of any project URL is either the Writable Projects folder URL or
				void.
				
				For document URLs, there are 2 possibilities:
				<ul>
				<li>The document does not belong to any project.</li>
				<li>The document belongs to one or many project.
				The base URL of the document URL must be either the source folder URL or the factory URL of one of its owning projects.</li>
				</ul>
				As a consequence, if the base URL is either a source URL or a factory URL, we have a document.
				
				Source and factory URLs must also contain information about their owning project URL in their base URL.
				The base URL of the source URL is a normal project URL
				whereas the factory project URL is either a normal project URL when we have write access or
				a writable project URL otherwise.
				
*/
@interface NSURL(iTM2ProjectDocumentKit)

- (NSURL *)enclosingWrapperURL4iTM3;

- (NSURL *)enclosingProjectURL4iTM3;

- (NSArray *)enclosedProjectURLs4iTM3;

@end

@class iTM2ProjectDocumentResponderRootNode;

//  4 Interface Builder
@interface iTM2ProjectToggleWrapperInspector: iTM2Inspector <NSTableViewDelegate>
{
@private
    id iVarCopyView4iTM3;
    id iVarErrorView4iTM3;
    id iVarRoot4iTM3;
    id iVarNodes4iTM3;
    id iVarTreeController4iTM3;
    id iVarArrayController4iTM3;
}
@property (readonly) iTM2ProjectDocumentResponderRootNode * root;
@property (assign) IBOutlet NSTreeController * treeController;
@property (assign) IBOutlet NSArrayController * arrayController;
@property (assign) IBOutlet NSView * copyView;
@property (assign) IBOutlet NSView * errorView;
@property (assign,readonly) NSArray * nodes;
- (IBAction)OK:(id)sender;
- (IBAction)cancel:(id)sender;
- (IBAction)revert:(id)sender;
- (IBAction)revertAll:(id)sender;
@end


//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2ProjectDocument
