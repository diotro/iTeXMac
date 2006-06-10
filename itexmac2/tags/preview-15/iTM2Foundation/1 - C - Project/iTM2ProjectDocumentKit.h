/*
//  iTM2ProjectDocumentKit.h
//  iTeXMac2
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
#define iTM2WindowsMenuItemIndentationLevel [self contextIntegerForKey:@"iTM2WindowsMenuItemIndentationLevel"]

extern NSString * const iTM2ProjectContextDidChangeNotification;
extern NSString * const iTM2ProjectCurrentDidChangeNotification;

extern NSString * const iTM2ProjectInfoComponent;
extern NSString * const iTM2ProjectMetaInfoComponent;

extern NSString * const iTM2ProjectMetaType;
#define metaModelGETTER [[self implementation] modelValueForSelector:_cmd ofType:iTM2ProjectMetaType]
#define metaModelSETTER(argument) [[self implementation] takeModelValue:argument forSelector:_cmd ofType:iTM2ProjectMetaType]

extern NSString * const iTM2ProjectDocumentType;
extern NSString * const iTM2ProjectInspectorType;
extern NSString * const iTM2ProjectInfoType;

extern NSString * const iTM2SubdocumentsInspectorMode;

extern NSString * const iTM2ProjectPlistPathExtension;

extern NSString * const iTM2ProjectTable;

extern NSString * const iTM2ProjectFrontendType;

extern NSString * const iTM2ProjectNoneKey;

extern NSString * const iTM2TWSKeyedFilesKey;
extern NSString * const iTM2TWSKeyedPropertiesKey;
extern NSString * const iTM2TWSFrontendComponent;

extern NSString * const iTM2ProjectDefaultKey;

/*!
    @const      iTM2ProjectPathExtension
    @abstract   .project
    @discussion The path extension of project file wrappers
*/
extern NSString * const iTM2ProjectPathExtension;

/*!
    @const      iTM2WrapperPathExtension
    @abstract   .wrapper
    @discussion The path extension of project file wrappers
*/
extern NSString * const iTM2WrapperPathExtension;

/*!
    @const      iTM2WrapperDocumentType
    @abstract   Wrapper Document
    @discussion The path extension of project file wrappers
*/
extern NSString * const iTM2WrapperDocumentType;

/*!
    @const      iTM2ProjectDocumentType
    @abstract   Project Document
    @discussion The path extension of project file wrappers
*/
extern NSString * const iTM2ProjectDocumentType;

/*!
    @const      iTM2OtherProjectWindowsAlphaValue
    @abstract   The alpha component of inactive project windows values
    @discussion The real alpha component is multiplied by this value if the project is not the active one.
*/
extern NSString * const iTM2OtherProjectWindowsAlphaValue;

#import <iTM2Foundation/iTM2DocumentKit.h>
#import <iTM2Foundation/iTM2DocumentControllerKit.h>
#import <iTM2Foundation/iTM2ResponderKit.h>

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2ProjectDocument

/*! 
    @class iTM2ProjectDocument
    @abstract   Semi abstract class to implement project design.
    @discussion Discussion forthcoming.
*/

@interface iTM2ProjectDocument: iTM2Document

/*! 
    @method     projectName
    @abstract   The project name of the receiver.
    @discussion If the receiver has a consistent wrapper file name,
				the project name is the extensionless last path component of the wrapper file name.
				Otherwise, the project name is the extensionless last path component of the receiver's file name.
    @param      None
    @result     The name
*/
- (NSString *) projectName;

/*! 
    @method     wrapperName
    @abstract   The wrapper file name of the receiver.
    @discussion The default implementation return the void string.
				See iTM2ProjectDocument for a real use of that when the project is part of a wrapper.
    @param      None
    @result     The wrapper file name
*/
- (NSString *) wrapperName;

/*! 
    @method     wrapperURL
    @abstract   The wrapper URL of the receiver.
    @discussion The default implementation returns nil.
				See iTM2ProjectDocument for a real use of that when the project is part of a wrapper.
    @param      None
    @result     The wrapper file name
*/
- (NSURL *) wrapperURL;

/*! 
    @method     wrapper
    @abstract   The wrapper document of the receiver if any.
    @discussion Discussion forthcoming.
    @param      None
    @result     The wrapper document
*/
- (id) wrapper;

/*! 
    @method     setWrapper:
    @abstract   Set the wrapper of the receiver.
    @discussion Discussion forthcoming.
    @param      The new wrapper document
    @result     None
*/
- (void) setWrapper: (id) argument;

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
- (id) subdocuments;

/*! 
    @method     saveSubdocuments:
    @abstract   Saves all the open documents related to the projects
    @discussion Discussion forthcoming.
    @param      Irrelevant.
    @result     None.
*/
- (void) saveSubdocuments: (id) sender;

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
- (void) addSubdocument: (id) document;

/*! 
    @method     removeSubdocument:
    @abstract   remove a document
    @discussion Once removed, a document no longer belongs to a project.
    @param      document to be removed.
    @result     None.
*/
- (void) removeSubdocument: (id) document;

/*! 
    @method     closeSubdocument:
    @abstract   Close a document
    @discussion Discussion Forthcoming.
    @param      document to be forgotten.
    @result     None.
*/
- (void) closeSubdocument: (id) document;

/*! 
    @method     ownsSubdocument:
    @abstract   Whether the receiver owns the given document.
    @discussion Discussion forthcoming.
    @param      document to be quesried about.
    @result     yorn.
*/
- (BOOL) ownsSubdocument: (id) document;

/*! 
    @method     keyForFileName:
    @abstract   The key for the given file name.
    @discussion Each file name is given a unique key identifier.
				Once given this identifier will not change as long as the file is living.
				The unique possibility is to remove it.
				A cached list is maintained.
				Keys are just numbers as strings.
				Different files with different names might have the same key if they represent the same document:
				they can use links or finder aliases. The first time this method is sent,
				it tries to use some information cached when one of the newKeyForFileName: or newKeyForFileName:context:
				was previously used. If no such information is available, it tries to guess the key based on some simple rules
				implemented in the private guessedKeyForFileName: method (this is for developpers only). This method manages the absolute/relative/link/alias/external problem.
				When the project is external, things are more complicated.
				The problem is to convert the absolute file name into a relative file name.
				Both the given file name and the project file name can live in the same domain
				with respect to the external projects directory. If not, one is converted to the other.
				This method does not create a new key for the file name. It just use the information that once was created
				either stored in the project or in a private cache.
				Use the newKeyForFileName: or newKeyForFileName:context: for that purpose.
    @param      fileName is a full path name, or relative to the project directory, posszibly converted if internal
    @result     An NSMutableDictionary
*/
- (NSString *) keyForFileName: (NSString *) fileName;

/*! 
    @method     showSubdocuments:
    @abstract   Show the files of the receiver.
    @discussion Discussion forthcoming.
    @param      irrelevant sender
    @result     None
*/
- (void) showSubdocuments: (id) sender;

/*! 
    @method     showSettings:
    @abstract   Show the settings of the receiver.
    @discussion This default implementation does nothing yet.
    @param      irrelevant sender
    @result     None
*/
- (void) showSettings: (id) sender;

/*! 
    @method     makeDefaultInspector
    @abstract   Creates the default project UI.
    @discussion If the receiver has no window controller (except the ghost one)
                a project document inspector is created unsing -makeSubdocumentsInspector message.
    @param      None
    @result     None
*/
- (void) makeDefaultInspector;

/*! 
    @method     makeSubdocumentsInspector
    @abstract   Creates the project documents UI.
    @discussion This default implementation does not implemnt anything yet.
                Subclassers will simply override the stuff.
    @param      None
    @result     None
*/
- (void) makeSubdocumentsInspector;
- (id) subdocumentsInspector;

/*! 
    @method     prepareFrontendCompleteWriteToURL:ofType:error:
    @abstract   Prepare writing process.
    @discussion One of the first message sent while writing.
				The prupose is to ensure that there is an existing directory at the given path.
    @param      None.
    @result     result forthcoming
*/
- (BOOL) prepareFrontendCompleteWriteToURL:(NSURL *)fileURL ofType:(NSString *) type error:(NSError**)outError;

/*! 
    @method     projectCompleteWillClose
    @abstract   Abstract forthcoming.
    @discussion Used to record the context state.
    @param      None.
    @result     result forthcoming
*/
- (void) projectCompleteWillClose;

/*! 
    @method     subdocumentMightHaveClosed
    @abstract   Abstract forthcoming.
    @discussion Used to force the window menu to update (subclassing).
    @param      None.
    @result     result forthcoming
*/
- (void) subdocumentMightHaveClosed;

/*! 
    @method     newKeyForFileName:
    @abstract   The key for the given file name.
    @discussion This method is obsolete, use the -newKeyForFileName:save: instead.
				It just forwards to the above mentionned method, not asking to save.
    @param      fileName is a full path name, or relative to the project directory
    @result     a unique key identifier
*/
- (NSString *) newKeyForFileName: (NSString *) fileName;

/*! 
    @method     newKeyForFileName:save:
    @abstract   The key for the given file name.
    @discussion If no key exists, a new one is created.
				A key is given only once. If it is removed, it won't be attributed another time.
				To ensure this, we store the next key to be used with a @".." file name.
				The .. refers to a directory outside the Wrapper and is likely not to be used.
    @param      fileName is a full path name, or relative to the project directory
    @param      yorn is a flag indicating whether the project should save if a new key is really created
    @result     a unique key identifier
*/
- (NSString *)newKeyForFileName:(NSString *)fileName save:(BOOL)yorn;

/*! 
    @method     saveAllSubdocumentsWithDelegate:didSaveAllSelector:contextInfo:
    @abstract   Abstract forthcoming.
    @discussion Discussion forthcoming.
    @param      delegate
    @param      selector
    @param      context info
    @result     None
*/
- (void) saveAllSubdocumentsWithDelegate: (id) delegate didSaveAllSelector: (SEL) action contextInfo: (void *) contextInfo;

/*! 
    @method     nextAvailableKey
    @abstract   The next available key.
    @discussion A key is given only once. If it is removed, it won't be attributed another time.
				To ensure this, we store the next key to be used with a @".." file name.
				The .. refers to a directory outside the Wrapper and is likely not to be used.
				Controllers will look at this key to see if the attributes they store does refer to anything still in the project.
				If the key is not one of the keys of the project, the corresponding attributes should be removed.
				No Undo management planned.
				The keys are quite anything, however, the dotted keys are reserved for private use,
				and should not be assigned to any file.
				iTeXMac2 uses the @".extension" key to store default values on an extension based scheme.
				See the -takeContextValue:forKey:fileKey: discussion.
    @param      fileName is a full path name
    @result     a unique key identifier
*/
- (NSString *) nextAvailableKey;

/*! 
    @method     removeKey:
    @abstract   Definitely forgets the key.
    @discussion The key is removed and all the attributes, properties for that key should be removed too.
				The receiver is not responsible for the attributes written in other files.
				No undo management is considered.
				The master key should be managed!!!
    @param      fileName is a full path name
    @result     a unique key identifier
*/
- (void) removeKey: (NSString *) key;

/*! 
    @method     allKeys
    @abstract   All the keys actually in use.
    @discussion Description forthcoming.
    @param      None
    @result     an NSArray
*/
- (NSArray *) allKeys;

/*! 
    @method     relativeFileNameForKey:
    @abstract   The file name for the given key.
    @discussion @"" is returned if the key is not covered by the allKeys list.
				This file name is relative to the directory containing the project file!
    @param      a key
    @result     an NSString
*/
- (NSString *) relativeFileNameForKey: (NSString *) key;

/*! 
    @method     absoluteFileNameForKey:
    @abstract   The file name for the given key.
    @discussion @"" is returned if the key is not covered by the allKeys list.
				This file name is absolute!
    @param      a key
    @result     an NSString
*/
- (NSString *) absoluteFileNameForKey: (NSString *) key;

/*! 
    @method     setFileName:forKey:makeRelative:
    @abstract   Changes the file name for the given key.
    @discussion This is a basic setter with NO side effect (except cleaning some private caches).
				If the key is not covered by the allKeys list of the receiver, nothing is done.
				The file name will be considered a full path if makeRelative is NO and a relative one otherwise,
				the project directory being the reference in that case.
				A full path will not break if the project is moved around
				whereas a relative path can break if the project and the pointed file don't move accorg-dingly.
    @param      fileName is the new file name, assumed to be a valid full path.
    @param      key is a key
    @param      flag is a flag
    @result     None.
*/
- (void) setFileName: (NSString *) fileName forKey: (NSString *) key makeRelative: (BOOL) flag;

/*! 
    @method     subdocumentForFileName:
    @abstract   The project document for the given file name.
    @discussion If the receiver does not declare a document with the given file name, nil is returned.
    @param      file name is a full path
    @result     a document.
*/
- (id) subdocumentForFileName: (NSString *) fileName;

/*! 
    @method     subdocumentForURL:
    @abstract   The project document for the given URL.
    @discussion Only file URL's are managed. If the receiver does not declare a document with the file name (given as URL), nil is returned.
    @param      file name is a full path
    @result     a project document.
*/
- (id)subdocumentForURL:(NSURL *)url;

/*! 
    @method     subdocumentURLForKey:
    @abstract   The project document URL for the given key.
    @discussion Discussion forthcoming.
    @param      key
    @result     an url.
*/
- (NSURL *)subdocumentURLForKey:(NSString *)key;

/*! 
    @method     externalSubdocumentURLForKey:
    @abstract   The project document external URL for the given key.
    @discussion Discussion forthcoming.
    @param      key
    @result     an url.
*/
- (NSURL *)externalSubdocumentURLForKey:(NSString *)key;

/*! 
    @method     keyedSubdocuments
    @abstract   The key project documents mapping.
    @discussion Description forthcoming.
    @param      None
    @result     a dictionary mapping keys to project documents.
*/
- (id) keyedSubdocuments;

/*! 
    @method     keyForSubdocument:
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
- (NSString *) keyForSubdocument: (id) subdocument;

/*! 
    @method     subdocumentForKey:
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
- (id) subdocumentForKey: (NSString *) key;

/*! 
    @method     propertyValueForKey:fileKey:
    @abstract   The property value for the given key and file key.
    @discussion If there is no property value for the given key and the given file key,
				defaults values restructed to the project context are returned instead.
				If there is still nothing to return, global user defaults values are returned.
    @param      key is a key
    @param      fileKey is a file name
    @result     a language.
*/
- (id) propertyValueForKey: (NSString *) key fileKey: (NSString *) fileKey;

/*! 
    @method     originalPropertyValueForKey:fileKey:
    @abstract   The original property value for the given key and file key.
    @discussion No default value is returned. Used in the UI to make the difference.
    @param      key is a key
    @param      fileKey is a file name
    @result     a language.
*/
- (id) originalPropertyValueForKey: (NSString *) key fileKey: (NSString *) fileKey;

/*! 
    @method     takePropertyValue:forKey:fileKey:
    @abstract   Set the given property for the given key and file key.
    @discussion Also sets default properties in the project context and in the user defaults data base.
    @param      property is a standard  property list object
    @param      key is a key
    @param      fileKey is a file name
    @result     a language.
*/
- (void) takePropertyValue: (id) property forKey: (NSString *) key fileKey: (NSString *) fileKey;

/*! 
    @method     keyedFileNames
    @abstract   The files dictionary.
    @discussion Discussion forthcoming.
                This is preferrably for private use.
                Direct setters/getters are given.
                A default void dictionary is given.
    @param      None
    @result     A dictionary
*/
- (id) keyedFileNames;

/*! 
    @method     keyedProperties
    @abstract   The properties dictionary.
    @discussion Discussion forthcoming.
                This is preferrably for private use.
                Direct setters/getters are given.
                A default void dictionary is given.
    @param      None
    @result     A dictionary
*/
- (id) keyedProperties;

/*! 
    @method     propertiesForFileKey:
    @abstract   The properties dictionary for the given key.
    @discussion Discussion forthcoming.
    @param      The key
    @result     A dictionary
*/
- (id) propertiesForFileKey: (NSString *) key;

/*! 
    @method     propertiesForFileName:
    @abstract   The properties dictionary for the given file name.
    @discussion Discussion forthcoming.
    @param      The file name
    @result     A dictionary
*/
- (id) propertiesForFileName: (NSString *) fileName;

/*! 
    @method     addGhostWindowController:
    @abstract   Abstract forthcoming.
    @discussion The ghost window controller ensures the project will not close when all the visible windows are closed.
				There is always one window that is not closable.
    @param      None
    @result     None
*/
- (void) addGhostWindowController;

/*! 
    @method     projectCompleteWriteToURL:ofType:error:
    @abstract   Where the data model is stored.
    @discussion The data model of the receiver of type iTM2ProjectFrontendType.
				Be sure the data model is consistent with your modifications in a prepare...WriteToFile:ofType: method
    @param      fileURL is a file URL
    @param      type is a type
    @param      outError points to an NSError instance if non void.
    @result     yorn
*/
- (BOOL) projectCompleteWriteToURL: (NSURL *) fileURL ofType: (NSString *) type error:(NSError**)outError;

/*! 
    @method     projectCompleteReadFromURL:ofType:error:
    @abstract   Reads the stored data model.
    @discussion The data model of the receiver of type iTM2ProjectFrontendType.
				Be sure the data model is consistent with your modifications in a prepare...WriteToFile:ofType: method
    @param      fileName is a file name
    @param      type is a type
    @param      outError points to an error instance
    @result     yorn
*/
- (BOOL) projectCompleteReadFromURL: (NSURL *) fileURL ofType: (NSString *) type error:(NSError**)outError;

/*! 
    @method     saveContext:
    @abstract   Abstract forthcoming.
    @discussion Overriding the inherited message.
				First all, the documents of the receiver are sent a -saveContext: message.
				Then the inherited method is performed.
				Finally, the receiver sends itself all the messages -...MetaWriteToFile:ofType:
				with the receiver's file name and file type as arguments.
				This gives third parties an opportunity to automatically save their own context stuff at appropriate time.
    @param      irrelevant sender
    @result     None
*/
- (void) saveContext: (id) irrelevant;

/*! 
    @method     contextValueForKey:fileKey:
    @abstract   Abstract forthcoming.
    @discussion The project is expected to manage the contexts of the files it owns.
				The standard user defaults database is used in the end of the chain.
    @param      \p aKey is the context key
    @param      \p fileKey is the file key
    @result     An object.
*/
- (id) contextValueForKey: (NSString *) aKey fileKey: (NSString *) fileKey;

/*! 
    @method     takeContextValue:forKey:fileKey:
    @abstract   Abstract forthcoming.
    @discussion See the \p -contextValueForKey:fileKey: comment.
    @param      the value, possibly nil.
    @param      \p aKey is the context key
    @param      \p fileKey is the file key
    @result     None.
*/
- (void) takeContextValue: (id) object forKey: (NSString *) aKey fileKey: (NSString *) fileKey;

/*! 
    @method     addFileName:
    @abstract   Abstract forthcoming.
    @discussion Description forthcoming.
    @param      fileName
    @result     None.
*/
- (void) addFileName: (NSString *) fileName;

/*! 
    @method     openSubdocumentWithContentsOfURL:context:display:error:
    @abstract   Open the project documennt.
    @discussion Once this method ends, the project used to be bound to the given url, wherever it is.
				Don't use this method to test if a project is bound to a given path.
    @param      irrelevant sender
    @result     None
*/
- (id)openSubdocumentWithContentsOfURL:(NSURL *)fileURL context:(NSDictionary *)context display:(BOOL)display error:(NSError**)outError;

/*! 
    @method     openSubdocumentForKey:display:error:
    @abstract   Open the project documnt.
    @discussion Once this method ends, the project used to be bound to the given key.
				Don't use this method to test if a project is bound to a given path.
    @param      irrelevant sender
    @result     None
*/
- (id)openSubdocumentForKey:(NSString *)key display:(BOOL)display error:(NSError**)outError;

@end


@interface iTM2SubdocumentsInspector: iTM2Inspector

/*! 
    @method     updateOrderedFileKeys
    @abstract   Updates the ordered list of file keys.
    @discussion Decription forthcoming.
    @param      None
    @result     a dictionary
*/
- (void) updateOrderedFileKeys;

/*! 
    @method     orderedFileKeys
    @abstract   Abstract forthcoming.
    @discussion Decription forthcoming.
    @param      None
    @result     the new file keys
*/
- (NSMutableArray *) orderedFileKeys;

/*! 
    @method     setOrderedFileKeys:
    @abstract   Abstract forthcoming.
    @discussion Decription forthcoming.
    @param      the new file keys
    @result     None
*/
- (void) setOrderedFileKeys: (id) argument;

/*! 
    @method     documentsView
    @abstract   The documents table view.
    @discussion Decription forthcoming.
    @param      None
    @result     a table view (or subclass)
*/
- (NSTableView *) documentsView;

- (IBAction) newDocument: (id) sender;
- (IBAction) importDocument: (id) sender;
- (IBAction) removeDocument: (id) sender;
- (IBAction) help: (id) sender;
- (IBAction) projectPathEdited: (id) sender;

@end

#import <iTM2Foundation/iTM2Implementation.h>

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

@interface iTM2ProjectController: iTM2Object

/*!
    @method     sharedProjectController
    @abstract   The shared project controller.
    @discussion Discussion forthcoming.
    @param      None.
    @result     An \p iTM2ProjectController instance.
*/
+ (id) sharedProjectController;

/*!
    @method     setSharedProjectController
    @abstract   Set the shared project controller.
    @discussion No project management if the shared project controller does not exist.
				If you nee project control, you should create such a controller very early,
				more precisely before project documents are created.
    @param      None.
    @result     An \p iTM2ProjectController instance.
*/
+ (void) setSharedProjectController: (id) argument;

/*!
    @method     flushCaches
    @abstract   Abstract forthcoming.
    @discussion See below.
    @param      None.
    @result     None.
*/
- (void) flushCaches;

/*! 
    @method     projectForFileName:
    @abstract   The project for the given file name.
    @discussion It just returns a project associate to the given file.
				At startup, this method allways returns nil and set the yornRef target to NO if relevant.
				While the program runs, projects are associate to file names (mainly by the -setProject:forFileName: method).
				Once a project has been bound to a file name, the subsequent calls to the present method will return that project.
				It is possible that a file name is explicitly bound to no project.
				Send the flushCaches message in order to reset all the file name <-> project bindings, but beware not to send this message too often.
				This method is a MAJOR entry point.
    @param      fileName is a full path name
    @result     A project document
*/
- (id) projectForFileName: (NSString *) fileName;

/*! 
    @method     setProject:forFileName:
    @abstract   Set the project for the given file name.
    @discussion Discussion forthcoming.
    @param      PD is any project document...
    @param		File name
	@result		None
*/
- (void) setProject: (id) PD forFileName: (NSString *) fileName;

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
				and <code>[SPC projectForFileName:[document fileName]]</code>
				are not equivalent in the sense that the last one will never try to create a new project.
				This method is used by the default implementation of the document's -project method.
				You should not need to use this method except at initialization time or in your own implementation
				of the project method.
				
				How does it work: first the cached project is returned if any.
				Then all the open projects are asked for their owning of the given document.
				When the document opens, is is expected that the correct project in the neighborhood is open too.
				If the document has a YES context bool for key: "_iTM2: Document With No Project",
				the nil project is returned.
				Finally, an open panel is presented for that purpose.
    @param      document is any document...
    @result     A project document
*/
- (id) projectForDocument: (NSDocument *) document;

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
- (void) setProject: (id) PD forDocument: (NSDocument *) document;

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
				or in the file system as external resource. In that case, projects are stored either in the temporary directory if this makes sense,
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
				<code>~/Library/Application\ Support/Projects.put_aside/...</code>
				to which we append the full path to the source base name with the correct path extension.
				This common location is referred to <code>+externalProjectsDirectory</code>, because the projects are not stored near the file they are bound to.

				This is the mapping file name -> project.
				
				Question, what happens if a project is not writable?
				
				The file name is significantly longer than the one of the source.
				But this should not be a problem due to the actual size limit (4096 AFAIK).
				
				However, there might be a problem if different clients want to use this strategy. If they are concurrently creating a unique key,
				it is difficult to avoid collisions when each client does not know about the other one's intentions.
				
				The final components are the ones used by the user interface to display information to the user.
				Unlimited directory level should be used.
				The big question is how iTM2 will know that a file needs a one shot project or needs a hard one to be created.
				Most certainly, if the source file contains header information, a one shot project should be used.
				The user is asked for that kind of information. And a hard project is always created.
				This implies the management of the read only status when file are downloaded in a read only folder!
				Some file names don't need projects, we should only propose a shared ghost project.
				Let spend some time to discuss the problem of projects.
    @param      The source is either a file name or a document.
    @result     A project document
*/
- (id) projectForSource: (id) source;

/*! 
    @method		projects
    @abstract   The projects.
    @discussion The base projects plus the ones in the various application support folders.
				Base projects are not listed here.
    @param		None
    @result		An array
*/
- (NSArray *) projects;

/*! 
    @method     currentProject
    @abstract   The current project.
    @discussion If the last current project owns (or is) the current document, it remains the current project.
				If the current document is not owned or is not the last current project,
				the project of the current document becomes the current project.
    @param      None
    @result     A project
*/
- (id) currentProject;

/*! 
    @method     registerProject:
    @abstract   register the given project.
    @discussion The project controller does not own the project. It only keeps a reference to the project.
				In general, the document controller will be the owner of the project.
				Subclassers will implement their own management for projects not owned by the document controller.
				The projectForFileName: method returns one of the added projects.
				Each time a project document is created, it is added as reference to the list of projects.
				Each time a project document is dealloced, its reference is removed from the list of project.
    @param      A project
    @result     None
*/
- (void) registerProject: (id) project;

/*! 
    @method     forgetProject:
    @abstract   forget the given project.
    @discussion project are cached, so we must clean the cache when a project is closed or removed.
    @param      A project
    @result     None
*/
- (void) forgetProject: (id) project;

/*! 
    @method     finderAliasesSubdirectory
    @abstract   The subdirectory where finder aliases are stored.
    @discussion The default implementation returns "frontends/comp.text.tex.iTeXMac2/Finder Aliases". Subclasser should override this.
    @param      None
    @result     a relative path
*/
- (NSString*) finderAliasesSubdirectory;

/*! 
    @method     softLinksSubdirectory
    @abstract   The subdirectory where soft links are stored.
    @discussion The default implementation returns "frontends/comp.text.tex.iTeXMac2/Soft Links". Subclasser should override this.
    @param      None
    @result     a relative path
*/
- (NSString*) softLinksSubdirectory;

/*! 
    @method     newProjectForFileNameRef:display:error:
    @abstract   Create a new project.
    @discussion This method is split into different parts.
				This method is used by various other methods to ensure that some objects are really bound to a project.
				An internal project is a directory wrapper found in the same directory or in a directory above.
				If the directory is not writable, or if the user does not want a project near the source file,
				the project is stored in an application support subfolder. In that case, it is called an external project.
				Let us explain this design in more details.
				Given the file name, the external project is always inside a wrapper.
				More precisely, if the file name is /my/dir/name/foo, then the associate wrapper is located in the folder
				Application\ Support/iTeXMac2/Projects/my/dir/name/
				or above. Which allows external projects to be shared by a file subhierarchy.
				In order to bind the wrapper and the source file, the wrapper will keep track of the source files.
				The included tex project will contain a list of finder aliases to the files they should be bound to.
				And soft links too.
				Managing recursivity. If a document is open, we are looking for an attached project.
				If the project is already open, we just have to verify that it knows about the document.
				If we try to open the project, we must be very careful in order to avoid recursive call.
				This method is expected to be reentrant. For that purpose, if the result is not already computed,
				it sends a willGetNewProjectForFileNameRef: message, make all the computations,
				then sends a final didGetNewProjectForFileNameRef: before it returns.
				The only purpose of these methods is just to break recursivity.
    @param      fileNameRef is a pointer to a file name
    @param      display
    @param      outError
    @result     A project.
*/
- (id)newProjectForFileNameRef:(NSString **)fileNameRef display:(BOOL)display error:(NSError **)outError;
- (void) willGetNewProjectForFileNameRef:(NSString **)fileNameRef;
- (void) didGetNewProjectForFileNameRef:(NSString **)fileNameRef;
- (BOOL) canGetNewProjectForFileNameRef:(NSString **)fileNameRef;
- (id)newExternalProjectForFileName:(NSString *)fileName display:(BOOL)display error:(NSError **)outError;

/*! 
    @method     getProjectFromPanelForFileNameRef:display:error:
    @abstract   Create or open a new project document.
    @discussion The file name can change if the original document is moved around,
				in particular when making a TeX document wrapper.
				Problems of wrappers is not closed, in particular, the file name should change and the wrapper is replaced by its included project.
				It is expected that no project already exist for that file name,
				so use this method only when projectForFileName: returns nil.
				This is a reentrant management: if there is already a panel waiting for the user input, NO is returned.
				There are only a few situations managed by this method.
				This is the user interface controller, to either create a new project or choose an already existing one.
				If no project is returned, it is what is wanted for the given file name,
				except when there is an error.
    @param      fileNameRef is a pointer to a file name
    @param      display is a flag to indicate if the UI is required
    @param      outError is a pointer to an NSError instance
    @result     project document.
*/
- (id)getProjectFromPanelForFileNameRef:(NSString **)fileNameRef display:(BOOL)display error:(NSError **)outError;

/*! 
    @method		baseProjects
    @abstract   The base projects owned by the project controller.
    @discussion The keys are the file names, the values are the projects.
    @param		None
    @result		A dictionary
*/
- (NSDictionary *) baseProjects;

/*! 
    @method     baseProjectWithName:
    @abstract   A project given its name.
    @discussion Discussion forthcoming.
    @param      projectName
    @result     A project
*/
- (id) baseProjectWithName: (NSString *) projectName;

/*! 
    @method     addBaseProject:
    @abstract   add the given project.
    @discussion The project controller owns the project not the document controller.
				The given project is not registered and is not meant a priori to contain editable documents.
    @param      A project
    @result     None
*/
- (void) addBaseProject: (id) project;

/*! 
    @method     removeBaseProject:
    @abstract   remove the given base project.
    @discussion Description forthcoming.
    @param      A project
    @result     None
*/
- (void) removeBaseProject: (id) project;

/*! 
    @method     isBaseProject:
    @abstract   Whether the receiver is a base project.
    @discussion A project is not a base project.
    @param      argument is the object to be tested
    @result     yorn.
*/
- (BOOL) isBaseProject: (id) argument;

/*! 
    @method     isProject:
    @abstract   Whether the receiver is a valid project.
    @discussion A valid project is either a base project or project owned by the shared document controller.
				Base projects are not considered as standard projects, such that isProject: ands -isBaseProject:
				are not expected to return YES at the same time.
    @param      argument is the object to be tested
    @result     yorn.
*/
- (BOOL) isProject: (id) argument;

/*! 
    @method     availableProjectsForPath:
    @abstract   Abstract forthcoming.
    @discussion Discussion forthcoming.
    @param      path...
    @result     an array of projects
*/
- (id)availableProjectsForPath:(NSString *)dirName;

@end

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
    @const		iTM2ProjectAliasPathKey
    @abstract   Context key
    @discussion value: @"iTM2ProjectAliasPathKey"
*/
extern NSString * const iTM2ProjectAliasPathKey;// unused

@interface NSDocument(iTM2ProjectKit)

/*! 
    @method     project
    @abstract   Abstract forthcoming.
    @discussion Convenient method as shortcut. If the resceiver -hasProject, the default implementation
				uses the shared project controller -projectForFileName: message to return a value.
    @param      None
    @result     A project
*/
- (id) project;

/*! 
    @method     wrapper
    @abstract   Abstract forthcoming.
    @discussion Convenient method as shortcut to the project wrapper, if it makes sense.
    @param      None
    @result     A wrapper
*/
- (id) wrapper;

/*! 
    @method     hasProject
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
- (BOOL) hasProject;

/*! 
    @method     setHasProject:
    @abstract   Abstract forthcoming.
    @discussion Basic setter with no side effect. This method should be used at initialization time
				if the subclass does have a project. It is expected for documents to keep their status unchanged
				with respect to projects. In extremely rare situation will you need to change the status dynamically.
    @param      yorn
    @result     None
*/
- (void) setHasProject: (BOOL) yorn;

/*! 
    @method     contextValueForKey:
    @abstract   Abstract forthcoming.
    @discussion See the -takeContextValue:forKey: discussion below.
    @param      key
    @result     A project
*/
- (id) contextValueForKey: (NSString *) key;

/*! 
    @method     takeContextValue:forKey:
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
    @result     None
*/
- (void) takeContextValue: (id) value forKey: (NSString *) key;

/*!
	@method			documentProjectCompleteSaveContext:
	@abstract		Save the project related information.
	@discussion		Automatically called by the -saveContext: message.
					Save some info about the project.
	@result			None.
	@availability	iTM2.
	@copyright		2005 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (void) documentProjectCompleteSaveContext: (id) sender;

@end

@interface iTM2ProjectGhostWindow: NSWindow
@end

@interface iTM2PDocumentController: iTM2DocumentController

/*!
    @method		openSubdocumentWithContentsOfURL:display:error:
    @abstract	Entry point for the document creation.
    @discussion	This implementation manages the complex wrapper/project/document architecture.
				Roughly speaking, you have wrappers with projects and documents,
				projects with documents but no wrapper, and document with no wrapper nor project.
				As the wrapper is the most intrusive design it is not central in the code.
				The project design is central, so everything is project centric.
				Each project owns its documents, not the document controller!
				And when there is a wrapper, the project is owned by the wrapper, not the document controller.
				Finally the wrapper if any is owned by the document controller.
				But when we have wrappers, we have to automatically open (or create) the associated project,
				and also manage the save as and save to actions in a fancy way.
				See the inherited method for details on the parameters and the result.
    @param		fileName.
    @param		display.
    @result		A document.
*/
- (id) openDocumentWithContentsOfURL: (NSURL *) URL display: (BOOL) display error: (NSError **) error;

@end

@interface NSDocumentController(ProjectDocumentKit)

/*!
    @method		projectDocumentType
    @abstract	The project document type.
    @discussion	The default implementation just returns "Project Document".
    @param		None.
    @result		A project document type.
*/
- (NSString *) projectDocumentType;

/*!
    @method		projectPathExtension
    @abstract	The project path extension.
    @discussion	The default implementation just returns @"project".
    @param		None.
    @result		A project path extension.
*/
- (NSString *) projectPathExtension;

/*!
    @method		wrapperDocumentType
    @abstract	The project wrapper document type.
    @discussion	The default implementation just returns "Wrapper Document".
    @param		None.
    @result		A project document type.
*/
- (NSString *) wrapperDocumentType;

/*!
    @method		wrapperPathExtension
    @abstract	The wrapper path extension.
    @discussion	The default implementation just returns @"wrapper".
    @param		None.
    @result		A wrapper path extension.
*/
- (NSString *) wrapperPathExtension;

@end

enum {iTM2ToggleOldProjectMode = 0, iTM2ToggleNewProjectMode, iTM2ToggleStandaloneMode, iTM2ToggleNoProjectMode, iTM2ToggleUnknownProjectMode};

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
- (id) project;

@end

/*!
    @class		iTM2ProjectDocumentResponder
    @abstract	Abstract frothcoming
    @discussion	Description forthcoming. No public API yet.
*/
@interface iTM2ProjectDocumentResponder: iTM2AutoInstallResponder
@end

@interface NSWorkspace(iTM2ProjectDocumentKit)

/*!
    @method		isProjectPackageAtPath:
    @abstract	Abstract forthcoming
    @discussion	Whether the given full path points to a project.
				If the receiver returns YES to a method named fooProjectPackageAtPath:
				except this one of course, the answer is YES.
				For example, a TeX project manager can implement in a category a method named isTeXProjectPackageAtPath:
				Otherwise it's NO
    @param      None
    @result     None
*/
- (BOOL) isProjectPackageAtPath: (NSString *) fullPath;

/*!
    @method		isWrapperPackageAtPath:
    @abstract	Abstract forthcoming
    @discussion	Whether the given full path points to a wrapper.
				If the receiver returns YES to a method named fooProjectPackageAtPath:
				except this one of course, the answer is YES.
				Otherwise it's NO
    @param      None
    @result     None
*/
- (BOOL) isWrapperPackageAtPath: (NSString *) fullPath;

@end

@interface NSString(iTM2ProjectDocumentKit)

/*!
    @method     externalProjectsDirectory
    @abstract   The directory where external projects are stored.
    @discussion Returns
					~/Library/Application\ Support/AppName/Projects.put_aside.
				The extension is used to hide the contents of this directory to the end user by declaring the extension as a wrapper tag.
    @param      None
    @result     An NSString instance.
*/
+ (NSString *) externalProjectsDirectory;

/*!
    @method		belongsToExternalProjectsDirectory
    @abstract	Abstract forthcoming
    @discussion	Discussion forthcoming.
    @param      None
    @result     yorn
*/
-(BOOL)belongsToExternalProjectsDirectory;

-(NSString *)stringByStrippingExternalProjectsDirectory;

/*!
    @method		enclosingWrapperFileName
    @abstract	The enclosing wrapper name of the receiver.
    @discussion	Return the first ancestor which path extension is a wrapper extension.
    @param		None.
    @result		A full wrapper path.
*/
- (NSString *) enclosingWrapperFileName;

/*!
    @method		enclosingProjectFileName
    @abstract	The enclosing project name of the receiver.
    @discussion	Return the first ancestor which path extension is a project extension.
    @param		None.
    @result		A full project path.
*/
- (NSString *)enclosingProjectFileName;

/*!
    @method		enclosedProjectFileNames
    @abstract	The enclosed project names of the receiver.
    @discussion	Return an array of project paths in the receiver as directory.
				If the receiver is not a directory, or if it does not contain any project, nothing is returned.
				The project are returned, how deep they can be.
				But, links are not followed (a priori to avoid problems of recursivity)
    @param		None.
    @result		An array or project paths relative to the receiver.
*/
- (NSArray *) enclosedProjectFileNames;

@end

@interface iTM2NoProjectSheetController: NSWindowController

/*!
    @method		alertForWindow:
    @abstract	Abstract forthcoming
    @discussion	Return one of the iTM2Toggle...ProjectMode's.
    @param		window is the sheet receiver.
    @result		YES if the user really wants no project.
*/
+ (BOOL) alertForWindow: (id) window;

@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2ProjectDocument
