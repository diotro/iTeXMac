/*
//
//  @version Subversion: $Id$ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Fri Sep 05 2003.
//  Copyright ¬© 2003 Laurens'Tribune. All rights reserved.
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


extern NSString * const iTM2UDKeepBackupFileKey;

extern NSString * const iTM2DefaultInspectorType;
extern NSString * const iTM2DefaultInspectorMode;
extern NSString * const iTM2DefaultInspectorVariant;
extern NSString * const iTM2SUDInspectorVariants;
extern NSString * const iTM2InspectorTable;

/*!
    @header		iTM2Document
    @abstract	Basic document.
    @discussion	Manages the IO, the interface type, the up to date state. Semi abstract class (does nothing?)
                The user interface management is special: the inspector is dynamically bound to the document,
                and the user can change the inspector according to its needs.
                Moreover, plugins will allow to extend the application functionality by adding more inspectors.
                There is a many to many mapping binding the inspectors to the documents they can apply to.
                Each user can choose to edit a document with one of the inspectors that can apply to the document.
                The user can change the inspector (the document must be saved during the change and more operations be performed for consistency reasons).
                There is a default inspector bound to any document, coders should supply this inspector along with their document class.
                Examples of document/inspector binding are based on iTeXMac2 purpose.
                Text files are all dealt by the same document model but the inspectors can be targeted to TeX, LaTeX, ConTeXt, MetaPost, and so on.
                Moreover, those inspectors can come in different flavours either simple or expert ones.
                PDF files correspond to another kind of document for which the preceeding inspectors does not fit.
                There must be another set of inspectors.
                Roughly speaking, there are four kinds of documents:
                - text documents
                - PDF documents
                - project documents
                - other graphics objects
                Identifiyng the inspectors:
                - the class objects are uniquely identified by an inspectorType and an inspectorMode.
                - the class objects also have a fileTypes array. Each inspector can apply to any document which file type is listed in this array,
                    but this is not limitating, and the inspector can apply to other documents too.
                Identifiyng the documents:
                - there is already a fileType in the AppKit
                - the class object has an inspector type that precisely tells what are all the inspectors that apply to that class.
                    There is no inheritance here: if a document accepts an inspector, it is possible that a subclass won't accept it.
                - the class objects also have a fileTypes array. Each inspector can apply to any document which file type is listed in this array,
                    but this is not limitating, and the inspector can apply to other documents too.
                The rules binding the documents and their inspectors are the following:
                - each inspector is uniquely identified by an inspectorType and a inspectorMode, it also has a documentTypes array used
                    by the document to find a default inspector for that document using its fileType.
                - each document class has an inspectorType, all the inspectors with that type are expected to fit that document.
                Concerning the tree hierarchy support. See the related methods below.
                Mutability is ensured by the data model and window controllers. This class should hardly ever subclassed.
				
				This design is still file centric because file wrappers are not sufficiently efficient for that purpose.
				TeX needs source files to be saved frequently and file wrappers are expected to contain much more than text files.
				Moreover, the wrapper is expected to change if third parties want to add their own private contents.
				Management would be a pain.
*/

@interface NSDocument(iTeXMac2)

/*!
    @method		inspectorType
    @abstract	The inspector type for the receiver.
    @discussion	The default implementation just returns a void string.
                Subclassers will override this to return typically one of the following identifiers:
                "text", "graphics", "project", whatsoever.
                Only the inspectors with that type are meant to edit the receiver's instances.
                Being a class method, the return value is not dynamic.
                Some documents may need to use many windows, this is the purpose of the mode specifier.
                Different kind of inspectors can be used with different modes.
                The type defines the kind of document the inspector will act on,
                the mode defines the way it displays the document.
                It is not required that a document only uses inspectors with the same type.
    @result		A unique identifier.
*/
+ (NSString *)inspectorType;

/*!
    @method		prettyInspectorType
    @abstract	The pretty inspector type of the receiver.
    @discussion	This corresponds to the human readable version of the major mode of the receiver. No check for uniquness is made.
    @result		The localized version of the major mode of the receiver (in the bundle of the receiver).
*/
+ (NSString *)prettyInspectorType;

/*!
    @method		originalFileName
    @abstract	The original file name.
    @discussion	Just in case the document has been filtered. This is the case for dvi documents than become pdf ones.
                The default implementation just returns the fileName.
                Not yet used.
    @param		None.
    @result		A full path.
*/
- (NSString *)originalFileName;

/*!
    @method		originalFileURL
    @abstract	The original file URL.
    @discussion	Just in case the document has been filtered. This is the case for dvi documents than become pdf ones.
                The default implementation just returns the fileURL.
                Not yet used.
    @param		None.
    @result		An URL.
*/
- (NSURL *)originalFileURL;

/*!
    @method		smartClose
    @abstract	Close if it can close...
    @discussion	If the document is authorized to close, it will send a documentWillClose,
				then close then send a documentDidClose message.
    @param		None.
    @result		None.
*/
- (void)smartClose;

/*!
    @method		documentWillClose
    @abstract	Close if it can close...
    @discussion	Automatically calls ...CompleteWillClose messages.
    @param		None.
    @result		None.
*/
- (void)documentWillClose;

/*!
    @method		documentDidClose
    @abstract	Close if it can close...
    @discussion	Automatically calls ...CompleteDidClose messages.
    @param		None.
    @result		None.
*/
- (void)documentDidClose;

/*! 
    @method     modelTypeForFileType:
    @abstract   The model type corresponding to the given file type
    @discussion The default implementation just returns the file type.
				The model type drives the way the model is managed.
				Different documpent types can lead to the same model management.
				But of course one document has only one model management at a time.
    @param      \p fileType is the document type.
    @result     A string identifying a model type.
*/
- (NSString *)modelTypeForFileType:(NSString *)fileType;

/*! 
    @method     modelType
    @abstract   The model type corresponding to the receiver's file type
    @discussion Discussion forthcoming.
    @param      None.
    @result     A string identifying a model type.
*/
- (NSString *)modelType;

/*!
    @method		frontWindow
    @abstract	The receiver's front most window.
    @discussion	Discussion forthcoming.
                The question is to implement a lazy intializer for that matter.
    @result		an NSWindow object.
*/
- (id)frontWindow;

/*!
    @method		cannotCloseWithNoFileImage
    @abstract	Whether the receiver cannot close when no file is present.
    @discussion	This is interesting if the document is not tagged as edited.
				The default implementation returns YES, such that if a file is removed from the finder,
				the user is still given a chance to save.
    @param      None.
    @result     yorn.
*/
- (BOOL)cannotCloseWithNoFileImage;

/*! 
    @method     contextDictionaryFromURL:
    @abstract   the context dictionary from the given file
    @discussion Load the context dictionary from the resources at that path.
    @param      fileURL is a file URL.
    @result     A dictionary.
*/
+ (id)contextDictionaryFromURL:(NSURL *)fileURL;

- (BOOL)readContextFromURL:(NSURL *)absoluteURL ofType:(NSString *)type error:(NSError **)outErrorPtr;
- (BOOL)writeContextToURL:(NSURL *)absoluteURL ofType:(NSString *)type error:(NSError **)outErrorPtr;

/*!
    @method		needsToUpdate
    @abstract	Whether the receiver needs an update.
    @discussion	This default implementation just compares the time stamps of the stored data
                with the last file modification date.
                If the stored file modification date is newer than the last one,
                it means that the file has been modified externally and should need to be updated.
    @param		None.
    @result		A yorn flag.
*/
- (BOOL)needsToUpdate;

/*!
    @method		updateIfNeeded
    @abstract	Abstract forthcoming.
    @discussion	Discussion Forthcoming.
    @param		None.
    @result		None.
*/
- (void)updateIfNeeded;

/*!
    @method		recordFileModificationDateFromURL:
    @abstract	Record the file modification date at the given file name.
    @discussion	The default implementation does nothing.
                Subclassers will implement their own method to record the file modification date,
                just like iTM2Document does, for example.
                This message is sent each time the saved data and the receiver should be considered as in synchronization.
    @param		fileName is a file name.
    @result		None.
*/
- (void)recordFileModificationDateFromURL:(NSURL *)absoluteURL;

/*!
    @method		showWindowsBelowFront
    @abstract	Show the receiver's windows just behind the main or key window.
    @discussion	The showWindowBelowFront: is sent to all the window controllers of the receiver.
    @param		Irrelevant sender.
    @result		None.
*/
- (void)showWindowsBelowFront:(id)sender;

/*!
    @method		environmentForExternalHelper
    @abstract	The dictionary for the external helper.
    @discussion	Discussion Forthcoming.
    @param		None.
    @result		None.
*/
- (NSDictionary *)environmentForExternalHelper;

/*!
    @method		childDocumentForFileName:
    @abstract	A child document for the given file name.
    @discussion	This is useful for composite documents.
				Composite documents are really file wrappers: they are composed with the contents of many different files.
				This is different from the concept of subdocuments of the project design.
				A project is just a manager of the set of its subdocuments.
				The default implementation simply returns nil.
    @param		None.
    @result		None.
*/
- (id)childDocumentForFileName:(NSString *)fileName;

/*!
    @method		childDocumentForURL:
    @abstract	A child document for the given URL.
    @discussion	See <code>-childDocumentForFileName:</code>.
    @param		None.
    @result		None.
*/
- (id)childDocumentForURL:(NSURL *)url;

@end

/*!
    @class		iTM2Document
    @abstract	The project document the receiver belongs to.
    @discussion	iTM2 expects each document to belong to one project document. What is a project document?
*/

@interface iTM2Document: NSDocument
{
@private
    id _Implementation;
}

/*!
    @method		dealloc
    @abstract	deallocates the memory.
    @discussion Automatically send all the ...CompleteDealloc messages the receiver can respond to.
				Then it just deallocates the implementation and removes the receiver
				from the iTeXMac2 and implementation notification centers, both as observer and observed.
    @param		None.
    @result		None.
*/
- (void)dealloc;

/*!
    @method		fileAttributes
    @abstract	The file attributes of the receiver.
    @discussion	To be compared with the actual modification date,
                to keep in synch the loaded version and the stored one,
                just in case someone else has edited the file.
    @param		None.
    @result		A date.
*/
- (NSDictionary *)fileAttributes;

/*!
    @method		directoryName
    @abstract	The directory name of the receiver.
    @discussion	Value cached.
    @result		maybe nil if the receiver does not have a non void file name.
*/
- (NSString *)directoryName;

/*!
    @method		inspectorAddedWithMode:
    @abstract	Add a window controller with the given mode.
    @discussion	If a window controller instance is unique and already exists, it is returned
				You should use this method instead of the standard -addWindowController: route,
				because it takes care of inspector management.
    @param		The mode.
    @result		an inspector.
*/
- (id)inspectorAddedWithMode:(NSString *)mode;

/*!
    @method		inspectorAddedWithMode:error:
    @abstract	Add a window controller with the given mode.
    @discussion	If a window controller instance is unique and already exists, it is returned
				You should use this method instead of the standard -addWindowController: route,
				because it takes care of inspector management.
    @param		The mode.
    @param		The outErrorPtr is an NSError instance pointer.
    @result		an inspector.
*/
- (id)inspectorAddedWithMode:(NSString *) mode error:(NSError**)outErrorPtr;

/*!
    @method		replaceInspectorMode:variant:
    @abstract	Abstract forthcoming...
    @discussion	Discussion forthcoming...
    @param		mode is the new inspector mode.
    @param		variant is the new inspector variant.
    @result		None.
*/
- (void)replaceInspectorMode:(NSString *)mode variant:(NSString *)variant;

/*!
    @method		makeDefaultInspector
    @abstract	Abstract forthcoming...
    @discussion	Discussion forthcoming...
    @param		None.
    @result		None.
*/
- (void)makeDefaultInspector;

/*!
    @method		didAddWindowController:
    @abstract	The receiver has the opportunity to perform some action after the new user interface is created.
    @discussion	Subclassers will ensure that the user interface will display their data model...
				This message is not sent if the added  window controller is an iTM2ExternalInspector instance.
    @param		The window controller added.
    @result		None.
*/
- (void)didAddWindowController:(id)WC;

/*!
    @method		willRemoveWindowController:
    @abstract	The receiver has the opportunity to perform some action before the user interface is dismissed.
    @discussion	Subclassers will take into account the various pending editing processes.
				The default implementation just closes the window, if it is loaded...
				This message is not sent if the added  window controller is an iTM2ExternalInspector instance.
    @param		The window controller to be removed.
    @result		None.
*/
- (void)willRemoveWindowController:(id)WC;

/*!
    @method		writeToDirectoryWrapper:error:
    @abstract	Write data to the given directory wrapper.
    @discussion	If the receiver is part of a hierarchy, the parent will send this message to prepare its own file wrapper for saving operation.
                The receiver is given the opportunity to save its works. The receiver can either add its own files to the given file wrapper or
                modify the data model of its master document, if it is a mutable dictionary for example or more generally if the master document
                declares methods to allow third parties to write their own stuff in the parent's data model. Beware of the CVS directory:
                do not remove directory wrappers or other file wrappers, unless you are sure they are yours.
                Once all the child documents of one parent document have written their stuff into the directory wrapper,
                the parent will write its own data model in that wrapper and save it to disk.
                That way, modifications made by the child documents are saved.
				This is specific design for tree structured documents. Not used for projects nor document wrappers.
				The default implementation just forwards the message to the implementation.
	@param		DW is expected to be a directory wrapper. Behaviour is undefined yet if it is a link to a directory, see the code for details.
	@param		errorStringRef is a reference to an error string. It will eventually point to an error string if the result is NO. The error string is autoreleased.
    @result		yorn. The way the answer is handled is not that clear. It is left undefined.
*/
- (BOOL)writeToDirectoryWrapper:(NSFileWrapper *)DW error:(NSString **)errorStringRef;

/*!
    @method		synchronizeWindowControllers
    @abstract	Synchronize the window controllers with the receiver.
    @discussion	Send a -synchronizeWithDocument message to all its window controllers.
				Send this message whenever the data model has changed.
	@param		None.
    @result		NO is there are no window controllers.
*/
- (BOOL)synchronizeWindowControllers;

/*!
    @method		synchronizeWithWindowControllers;
    @abstract	Synchronize the receive with its window controllers.
    @discussion	Send a -synchronizeDocument message to all its window controllers.
				Send this message whenever the data model has been edited and you need an up to date model.
	@param		None.
    @result		None.
*/
- (void)synchronizeWithWindowControllers;

/*!
    @method		readFromDirectoryWrapper:error:
    @abstract	Read the data model from the given directory wrapper.
    @discussion	If the receiver is part of a hierarchy, the parent will send this message to all its children once it has loaded its own data model.
                The child documents can then load their own data from the argument, they can also load their own data model from the data model of
                their parent document, and they can differ the loading of their data model until the data model is really needed.
                Conflicts are not managed here.
				This is specific design for tree structured documents. Not used for projects nor document wrappers.
				The default implementation just forwards the message to the implementation.
				If the read operation was successful, a didReadFromFile:ofType: is sent with nil arguments. Poor design at first glance.
	@param		DW is expected to be a directory wrapper. Behaviour is undefined yet if it is a link to a directory, see the code for details.
	@param		errorStringRef is a reference to an error string. It will eventually point to an error string if the result is NO. The error string is autoreleased.
    @result		yorn. The way the answer is handled is not that clear. It is left undefined.
*/
- (BOOL)readFromDirectoryWrapper:(NSFileWrapper *)DW error:(NSString **)errorStringRef;

/*!
    @method		contextDictionary
    @abstract	The context dictionary.
    @discussion	Discussion forthcoming.
    @result		an NSDictionary instance.
*/
- (id)contextDictionary;

/*!
    @method		userDefaultsDidChange:
    @abstract	The user defaults data base has been modified.
    @discussion	The receiver will take the changes into account by loading the new context info from the user defaults dictionary.
                This method should nopt be used nor subclassed. Consider it as private.
    @param		a notification.
*/
- (void)userDefaultsDidChange:(NSNotification *)notification;

/*!
    @method		loadFileWrapperRepresentation:ofType:
    @abstract	Pre Tiger API.
    @discussion	This overriden method ensures that pre Tiger document design won't load the data automatically.
				If you really need to read a file wrapper, use the readFromDirectoryWrapper:error:, writeToDirectoryWrapper:error:.
    @param		wrapper is an unused file wrapper.
    @param		type is an unused document type.
    @result		Allways NO.
*/
- (BOOL)loadFileWrapperRepresentation:(NSFileWrapper *)wrapper ofType:(NSString *)type;

/*!
    @method		willSave
    @abstract	The receiver is about to save its data.
    @discussion	Description forthcoming.
*/
- (void)willSave;

/*!
    @method		didSave
    @abstract	The receiver has just saved its data.
    @discussion	Description forthcoming.
				Subclassers have a hook point because any selector with the same signature as the message
				and suffix DidSave will be performed.
				Of course names should be chosen with care in order to avoid collisions.
    @param      None.
    @result     None.
*/
- (void)didSave;

/*! 
    @method     readFromURL:ofType:error:
    @abstract   read from the given file
    @discussion The inherited method is overriden.
				After the inherited method is performed,
                any message named prefixReadFromFile:ofType: the receiver responds to will be performed,
                as soon as the method signature is the one of readFromURL:ofType:error:.
                Subclassers will just have to implement their own fooReadFromURL:ofType:error:
                to read something from the project directory wrapper.
				The dataCompleteReadFromURL:ofType:error: is the only one method available.
                Actually, projectInfoReadFromURL:ofType:error: and frontendReadFromURL:ofType:error:
                are also implemented by the TeX project document.
                Arguments are passed through as is.
                You must implement such a method to provide something relevant.
				The loadDataRepresentation:ofType: has been deprecated in Tiger but was overriden here.
				When all the methods have been successfully performed, the receiver performs a final didReadFromURL:ofType:error: message.
				If you want some method to performed before the others, prefix it with "prepare".
				
				It is recommanded that you have one level of indirection in your various file reading method.
				For example, the dataCompleteReadFromURL:ofType:error: is just a wrapper over the loadDataRepresentation:ofType:
				
				If you override this method, do not forget to update the file modification date, see some auto update kit method.
    @param      absoluteURL is the new document url.
    @param      The document type.
    @param      outputError.
    @result     A flag.
*/
- (BOOL)readFromURL:(NSURL *)absoluteURL ofType:(NSString *)type error:(NSError**)outputError;

/*! 
    @method     dataCompleteReadFromURL:ofType:error:
    @abstract   read the data from the given url
    @discussion Preserves the resources.
				In cocoa, the document based design automatically loads data when reading from file,
				as soon as the loadDataRepresentation:ofType: (or a similar method) is implemented.
				We ensured this is no longer the case overriding the file wrapper stuff.
    @param      fullDocumentPath is the document path.
    @param      typeName is the document type.
    @param      outputError.
    @result     A flag.
*/
- (BOOL)dataCompleteReadFromURL:(NSURL *)absoluteURL ofType:(NSString *)typeName error:(NSError**)outputError;

/*! 
    @method     resourcesCompleteReadFromURL:ofType:error:
    @abstract   read the resources from the given url
    @discussion Preserves the resources.
                If the receiver implements a method like
                - (void) loadXXXIDResource: (id) resourceContent;
                Where XXX is an hexadecimal number from 128 to 255, the receiver will send this message
                with the resource contents with resource ID number XXX
                it may find in the resource fork.
    @param      absoluteURL is the document url.
    @param      typeName is the document type.
    @param      outputError.
    @result     A flag.
*/
- (BOOL)resourcesCompleteReadFromURL:(NSURL *)absoluteURL ofType:(NSString *)typeName error:(NSError**)outputError;

/*!
    @method		didReadFromURL:ofType:error:
    @abstract	The receiver has just read its data.
				Subclassers have hook points where they can add their own stuff:
				any selector with the same signature and suffix DidReadFromURL:ofType:error: will be performed.
				Of course names should be chosen with care in order to avoid collisions.
    @discussion	Description forthcoming.
    @param      absoluteURL is the document url.
    @param      typeName is the document type.
    @param      outputError.
    @result     None.
*/
- (void)didReadFromURL:(NSURL *)absoluteURL ofType:(NSString *)typeName error:(NSError**)outputError;

/*! 
    @method		writeToURL:ofType:error:
    @abstract   write to the given url
    @discussion Message sent by the receiver from its writeToURL:ofType:originalFile:saveOperation: method.
                Any message prefixWriteToURL:ofType:error: the receiver responds to will be performed,
                as soon as the method signature is the one of writeToURL:ofType:error:.
                Subclassers will just have to implement their own fooWriteToURL:ofType:error:
                to save something in the project directory wrapper.
                Actually, projectInfoWriteToURL:ofType:error: and frontendWriteToURL:ofType:error:
                are implemented by the TeX project document.
                Arguments are passed through as is.
    @param      absoluteURL is the document url.
    @param      typeName is the document type.
    @param      outputError.
    @result     A flag.
*/
- (BOOL)writeToURL:(NSURL *)absoluteURL ofType:(NSString *)typeName error:(NSError**)outputError;

/*! 
    @method     dataCompleteWriteToURL:ofType:error:
    @abstract   write the data to the given url
    @discussion The receiver's dataRepresentation with the given type will be saved at the given path.
    @param      absoluteURL is the document url.
    @param      typeName is the document type.
    @param      outputError.
    @result     A flag.
*/
- (BOOL)dataCompleteWriteToURL:(NSURL *)absoluteURL ofType:(NSString *)typeName error:(NSError**)outputError;

/*! 
    @method     resourcesCompleteWriteToURL:ofType:error:
    @abstract   write the resources to the given file
    @discussion Preserves the resources.
                If the receiver implements a method like
                - (void) getXXXIDResource: (id *) resourceContentPtr;
                Where XXX is a number from 128 and to 255, the receiver will send this message
                with the resource contents with resource ID number XXX
                it will save in the resource fork.
    @param      absoluteURL is the document url.
    @param      typeName is the document type.
    @param      outputError.
    @result     A flag.
*/
- (BOOL)resourcesCompleteWriteToURL:(NSURL *)absoluteURL ofType:(NSString *)typeName error:(NSError**)outputError;

/*! 
    @method     writeToURL:ofType:forSaveOperation:originalContentsURL:error:
    @abstract   write to the given file
    @discussion The inherited method is overriden.
                When copying, duplicates the whole information contained at the original path,
                to retrieve all the hidden information (SCM info mainly)
                Any message prefixWriteToURL:ofType:originalFile:saveOperation:error:
                the receiver responds to will be performed,
                as soon as the method signature is the one of writeToURL:ofType:originalFile:saveOperation:error:.
                Subclassers will just have to implement their own fooWriteToURL:ofType:originalFile:saveOperation:error:
                to save something in the project directory wrapper.
                Actually, projectInfoWriteToURL:... and frontendWriteToURL:...
                are implemented by the TeX project document.
                Arguments are passed through as is.
    @param      absoluteURL is the new document url.
    @param      The document type.
    @param      saveOperationType is the save operation type.
    @param      absoluteOriginalContentsURL is the old document path.
    @param      outputError.
    @result     A flag.
*/
- (BOOL)writeToURL:(NSURL *)absoluteURL ofType:(NSString *)typeName forSaveOperation:(NSSaveOperationType)saveOperationType originalContentsURL:(NSURL *)absoluteOriginalContentsURL error:(NSError**)error;

/*! 
    @method     dataRepresentation
    @abstract   The data representation of the receiver
    @discussion It is the dataRepresentationOfType: the receiver's file type.
                So never use this method from a dataRepresentationOfType: unless you want an infinite loop.
    @param      None.
    @result     A data.
*/
- (NSData *)dataRepresentation;

/*! 
    @method     setDataRepresentation:
    @abstract   Set the data representation of the receiver
    @discussion It just loadDataRepresentation:ofType: with the receiver's file type.
                So never use this method from a loadDataRepresentation:ofType: unless you want an infinite loop.
    @param      The document type.
    @result     A flag.
*/
- (void)setDataRepresentation:(NSData *)data;

/*! 
    @method     dataRepresentationOfType:
    @abstract   the data representation of the receiver for the given type
    @discussion Just asks the implementation to do the job.
    @param      The document type.
    @result     A flag.
*/
- (NSData *)dataRepresentationOfType:(NSString *)type;

/*! 
    @method     loadDataRepresentation:ofType:
    @abstract   Loads the given data representation of the given type
    @discussion Just asks the implementation to do the job.
    @param      data is tha data to be loaded.
    @param      The document type.
    @result     A flag indicating whether the operation succeeded of failed.
*/
- (BOOL)loadDataRepresentation:(NSData *)data ofType:(NSString *)type;

@end

/*!
    @class		NSWindowController
    @abstract	The basic window controller extensions.
    @discussion	Declares a type, the class object is a manager...
*/

@interface NSWindowController(iTM2DocumenKit)

/*!
    @method		smallImageLogo
    @abstract	Abstract forthcoming.
    @discussion	Description forthcoming.
    @param		None.
    @result		an image.
*/
+ (NSImage *)smallImageLogo;

/*!
    @method		isInstanceUnique
    @abstract	Is the instance unique.
    @discussion	Default inspectors are unique: the same document is not viewed through different inspectors of the same type, mode and variant.
                Subclassers are allowed to use different instances of the same window controller class,
                as long as they manage correctly the synchronization problem.
				IN general, a subclasser that accepts different variants will propably return NO,
				if the variants can coexist. iTeXMac2 always returns YES in normal (not advanced) use.
                If you try to add a window controller whereas another one of the same class already exists
                and isInstanceUnsique returns YES, nothing happens.
    @result		yorn.
*/
+ (BOOL)isInstanceUnique;

/*!
    @method		inspectorType
    @abstract	The inspector type of the receiver.
    @discussion	Default implementation just returns a "default" string as default value
                but subclassers are expected to return their own value.
                Standard types should be large categories such "text",
                "graphics", "project", "macros", and so on
                There can be different inspectors of the same type,
                but they all should be able to deal with the same kind of data,
                and less precisely on the same API.
                A document with a given inspector type should be view through one or many inspectors of the same type.
                To make different inspectors, change their modes.
                The inspector type should be as far as possible related to the document type of the receiver.
                It is designed with that link in mind but their should be
                a logical link rather than a programmatic one.
    @result		a uniquely used identifier.
*/
+ (NSString *)inspectorType;

/*!
    @method		prettyInspectorType
    @abstract	The pretty inspector type of the receiver.
    @discussion	This corresponds to the human readable version of the major mode of the receiver. No check for uniquness is made.
    @result		The localized version of the major mode of the receiver (in the bundle of the receiver).
*/
+ (NSString *)prettyInspectorType;

/*!
    @method		inspectorMode
    @abstract	The inspector mode of the receiver.
    @discussion	Default implementation just returns a "default" string as default value
                but subclassers are expected to return their own value.
                For text type, standard modes could be Plain, LaTeX, ConTeXt, MetaPost,
                for graphics type, standard modes could be PDF, Bitmap...
                The variant is a further identifying string. It can be for example "simple", "advanced" and "expert".
    @result		a uniquely used identifier.
*/
+ (NSString *)inspectorMode;

/*!
    @method		prettyInspectorMode
    @abstract	The pretty inspector mode of the receiver.
    @discussion	This corresponds to the human readable version of the minor mode of the receiver. No check for uniquness is made.
                It is a localized string for key [self inspectorMode]
    @param		None.
    @result		The localized version of the identifier of the receiver (in the bundle of the receiver).
*/
+ (NSString *)prettyInspectorMode;

/*!
    @method		inspectorVariant
    @abstract	The inspector variant of the receiver.
    @discussion	Each mode has a variant, one document can have many different inspectors each one with its own mode,
                we can choose between different variants, for example wa can have simple and expert variants of the same mode.
    @result		a uniquely used identifier.
*/
+ (NSString *)inspectorVariant;

/*!
    @method		prettyInspectorVariant
    @abstract	The pretty inspector variant of the receiver.
    @discussion	This corresponds to the human readable version of the variant of the receiver. No check for uniquness is made.
                It is a localized string for key [self inspectorVariant]
                When a variant is not available, the default one is used instead.
    @param		None.
    @result		The localized version of the identifier of the receiver (in the bundle of the receiver).
*/
+ (NSString *)prettyInspectorVariant;

/*!
    @method		allInspectorVariantsForType:
    @abstract	All the inspector variants the receiver can handle.
    @discussion	The default implementation just returns an array containing its inspector variant
				if the given inspector type matches the inspector type of the receiver,
				otherwise the result is a void array.
				Subclassers will return whatever they need to, iTM2ExternalInspector uses this feature.
    @param		type is an inspector type.
    @result		an array
*/
+ (NSArray *)allInspectorVariantsForType:(NSString *)type;

/*!
    @method		windowNibName
    @abstract	The receiver's window nib name.
    @discussion	Used as default value to create new window controllers.
				Subclassers will be able change the inspector type, but not the window nib name.
    @param		None.
    @result		a window nib name
*/
+ (NSString *)windowNibName;

/*!
    @method		inspectorVariant
    @abstract	The inspector variant of the receiver.
    @discussion	While each class and instances are expected to have only one type and one mode,
				the same class can convenir to different variants.
				Namely, when external viewers or editors are used, the type and mode are the same,
				but the variants are different. The actions are different according to the variant.
				The default implementation just returns the class variant,
				but subclassers are expected to return the values stored during a -setInspectorVariant:
				This is the case of the iTM2Inspector subclass, if the inspector variant has been set,
				it returns the set inspector variant, otherwise it returns the inherited stuff.
    @result		a uniquely used identifier.
*/
- (NSString *)inspectorVariant;

/*!
    @method		prettyInspectorVariant
    @abstract	The pretty inspector variant of the receiver.
    @discussion	This corresponds to the human readable version of the variant of the receiver.
				No check for uniquness is made.
                It is a localized string for key [self inspectorVariant]
                When a variant is not available, the default one is used instead.
    @param		None.
    @result		The localized version of the identifier of the receiver (in the bundle of the receiver).
*/
- (NSString *)prettyInspectorVariant;

/*!
    @method		setInspectorVariant:
    @abstract	set the inspector variant of the receiver.
    @discussion	If the inspector class is sensitive to its variant, you must provide an inspector variant in time.
				The inspectorAddedWithMode: will do the job for you automatically,
				taking care of existing variants for consistency.
				The default implementation does nothing,
				but subclassers are expected to really implement this setter if they accept different variants.
				This is the case of the iTM2Inspector subclass, see the -inspectorVariant comment for details.
    @param		a uniquely used identifier.
    @result		None.
*/
- (void)setInspectorVariant:(NSString *)argument;

/*!
    @method		inspectorClassForType:mode:variant:
    @abstract	The class object for the given type, mode and variant arguments.
    @discussion	Returns the NSWindowController subclass object that has the argument as type, mode and variant.
				A window controller is said to have a variant if all its allInspectorVariants contains the variant.
    @param		type is a unique NSString identifier.
    @param		mode is a unique NSString identifier within the same type class.
    @result		an NSWindowController subclass object.
*/
+ (Class)inspectorClassForType:(NSString *)type mode:(NSString *)mode variant:(NSString *)variant;

/*!
    @method		inspectorClassesForType:mode:
    @abstract	The class objects for the given type and mode arguments.
    @discussion	Discussion forthcoming.
    @param		type is a unique NSString identifier.
    @param		mode is a unique NSString identifier.
    @result		an enumerator.
*/
+ (NSArray *)inspectorClassesForType:(NSString *)type mode:(NSString *)mode;

/*!
    @method		inspectorModesForType:
    @abstract	Abstract forthcoming.
    @discussion	Discussion forthcoming.
    @param      type
    @result     array of modes
*/
+ (NSArray *)inspectorModesForType:(NSString *)type;

/*!
    @method		synchronizeDocument
    @abstract	Abstract forthcoming.
    @discussion	This message should be sent to have the document in synch with its inspectors. Useful when you are about to save your document.
                Subclasseres will prepend their own stuff. We should be sure that the use interface always reflects the state of the stored data.
*/
- (void)synchronizeDocument;

/*!
    @method		synchronizeWithDocument
    @abstract	Synchronize the receiver with its document.
    @discussion	This message should be sent to have the receiver in synch with its document.
                Useful when you have just loaded your document and want the user interface to be in synch with your newly read data model.
                The default implementation does nothing but setting the document edited flag to NO, subclassers know what to do.
				This message is sent each time a window controller is added to a document in the -didAddWindowController: method.
*/
- (void)synchronizeWithDocument;

/*!
    @method		isInspectorEdited
    @abstract	Whether the receiver is edited.
    @discussion	The AppKit document based architecture assumes that any change made must be registered in an undo stack to be reflected
                by the window close button. Here, documents will ask their window controllers too.
    @result		a flag.
*/
- (BOOL)isInspectorEdited;

/*!
    @method		setInspectorEdited:
    @abstract	Sets whether the receiver is edited.
    @discussion	The AppKit document based architecture assumes that any change made must be registered in an undo stack to be reflected
                by the window close button. Here, documents will ask their window controllers too.
    @result		a flag.
*/
- (void)setInspectorEdited:(BOOL)flag;

/*!
    @method		updateChangeCount:
    @abstract	Updates the change count of the receiver.
    @discussion	Similar to the NSDocument's method.
    @param		change.
    @result		a flag.
*/
- (void)updateChangeCount:(NSDocumentChangeType)change;

/*!
    @method		showWindowBelowFront
    @abstract	Show the receiver's window just behind the main or key window.
    @discussion	Discussion forthcoming.
    @param		Irrelevant sender.
    @result		None.
*/
- (void)showWindowBelowFront:(id)sender;

+ (NSString *)allInspectorsDescription;// intentionnally undocumented

@end

@interface NSWindowController(iTM2DocumentKit)

/*!
    @method		windowWillLoad
    @abstract	Overriden behaviour.
    @discussion	With the standard behaviour, all the message blahWindowWillLoad are sent.
				The inherited ones are not sent by the receiver because they are expected to be sent by the ancestor.
				Inherited messages are sent before the receiver's ones.
    @param		None.
    @result		None.
*/
- (void)windowWillLoad;

/*!
    @method		windowDidLoad
    @abstract	Overriden behaviour.
    @discussion	With the standard behaviour, all the message blahWindowDidLoad are sent.
				The inherited ones are not sent by the receiver because they are expected to be sent by the ancestor.
				Inherited messages are sent before the receiver's ones.
    @param		None.
    @result		None.
*/
- (void)windowDidLoad;

@end

/*!
    @class		iTM2Inspector
    @abstract	The basic window controller with a model controller.
    @discussion	This window controller will store its edited stuf in its model controller and will synchronize with its document when saving or loading files...
*/

@interface iTM2Inspector: NSWindowController
{
@private
    id _Implementation;
}

/*!
    @method		backupModel
    @abstract	Backup the model.
    @discussion	This message is sent in the windowDidLoad method.
				You are not expected to subclass this message but you can send it whenever you want.
				This is a launcher message, which means that like read/write messages or the NSDocument class
				it sends other messages that are hook points.
				Any relevant selector matching *CompleteBackupModel is sent to the receiver.
				This allows to keep a track of what was there before the inspector edits the data model such that
				if edition is cancelled we have a track of what was there before and we are able to retrieve the previous state.
				Convenience methods are declared to store and retrieve the previous model parts.
				This atomic design allows to spread the backup / restore code whenever the model is edited and not in only one central method.
    @param		None.
    @result		None.
*/
- (void)backupModel;

/*!
    @method		restoreModel
    @abstract	Restore the model.
    @discussion	This message is sent in the windowDidLoad method.
				You are not expected to subclass this message but you can send it whenever you want.
				This is a launcher message, which means that like read/write messages or the NSDocument class
				it sends other messages that are hook points.
				Any relevant selector matching *RestoreModel is sent to the receiver.
    @param		None.
    @result		None.
*/
- (void)restoreModel;

/*!
    @method		takeModelBackup:forKey:
    @abstract	Stores the given object for a further restore.
    @discussion	Key should be chosen with care to avoid collisions.
    @param		backup.
    @param		key.
    @result		None.
*/
- (void)takeModelBackup:(id)backup forKey:(NSString *)key;

/*!
    @method		modelBackupForKey:
    @abstract	Retrieves a previously backed up object.
    @discussion	Similar to the NSDocument's method.
    @param		key.
    @result		an object.
*/
- (id)modelBackupForKey:(NSString *)key;

/*!
    @method		windowNibPath
    @abstract	The window nib path.
    @discussion Subclass to extend the search to the bundles of the receiver'superclasses.
    @param		None.
    @result		a path.
*/
- (NSString *)windowNibPath;  

@end

@interface iTM2InspectorMenu: NSMenu
@end

extern NSString * const iTM2UDSmartUndoKey;
extern NSString * const iTM2UDLevelsOfUndoKey;

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2UndoManager

/*!
    @class		iTM2UndoManager
    @abstract	Extanded undo manager √† la project builder.
    @discussion	Displays an alert panel: save past the last save point...
*/
@interface iTM2UndoManager: NSUndoManager
@end

@interface NSResponder(iTM2UndoManager)
- (IBAction)toggleSmartUndo:(id)sender;
- (BOOL)hasSmartUndo;
- (BOOL)canToggleSmartUndo;
@end

extern NSString * const iTM2ExternalInspectorMode;

/*!
    @const		iTM2ExternalInspectorMode
    @abstract	External inspector mode.
    @discussion	The external inpector mode is used by the abstract iTM2ExternalInspector class.
*/
extern NSString * const iTM2ExternalInspectorMode;
/*!
    @class		iTM2ExternalInspector
    @abstract	bridge between the app and external helpers, essentially document editors and viewers.
    @discussion	The inspector type is left void such that subclassing is necessary to allow external inspectors.
				The principle is quite simple: this inspector does not interfere with the data model
				such that the document can use lazy initialization to avoid loading useless data.
				The window of the receiver is a far away window, that never really gets main or key.
				When this window is asked to order front, the message is simply forwarded to the helper.
				A helper is declared in a codeless bundle which cannot be loaded but can contain resources.
				A helper is declared in a script file located in the standard application support files.
				Those locations are
				/Library/Application\ Support/iTeXMac2/
*/
@interface iTM2ExternalInspector: iTM2Inspector

/*!
    @method		inspectorMode
    @abstract	The inspector mode of the receiver.
    @discussion	Don't override this unless you loose the benefit of the external helper design.
    @param		None.
    @result		iTM2ExternalInspectorMode.
*/
+ (NSString *)inspectorMode;

/*!
    @method		switchToExternalHelperWithEnvironment:
    @abstract	Abstarct forthcoming.
    @discussion	Discussion forthcoming.
    @param		environment is an environment.
    @result		yorn.
*/
- (BOOL)switchToExternalHelperWithEnvironment:(NSDictionary *)environment;

/*!
    @method		allInspectorVariantsForType:
    @abstract	All the inspector variants the receiver can handle.
    @discussion	iTM2ExternalInspector being some kind of wildcard inspector,
				it can represent different types and variants.
    @param		type is an inspector type.
    @result		an array
*/
+ (NSArray *)allInspectorVariantsForType:(NSString *)type;

@end

@interface iTM2ExternalWindow: NSWindow
@end

@interface iTM2WildcardDocument: NSDocument
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2DocumentKit
