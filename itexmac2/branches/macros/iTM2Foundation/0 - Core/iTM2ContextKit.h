/*
//
//  @version Subversion: $Id$ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Tue Mar 26 2002.
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


extern NSString * const iTM2ContextDidChangeNotification;
extern NSString * const iTM2ContextExtensionsKey;
extern NSString * const iTM2ContextTypesKey;

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2ContextKit

/*! 
    @category	iTM2ContextKit
    @abstract	Context management.
    @discussion	This has nothing to do with the ConTeXt macro package.
				Objects can retrieve defaults from locales user database.
				The user defaults database is not suitable for defaults tied to one peculiar document.
				If the document is meant to be shared by different people or edited on different machines,
				it's meta data cannot be stored in the central user defaults data base.
				How things work:
				Instead of asking the standardUserDefaults object, any object can ask itself for a context*ForKey
				where * is one of the common encontered types.
				If the receiver as an object for the given key in its own context dictionary, this will be used as return value.
				On the contrary, if the receiver has a contextManager, this manager will be asked for the same question.
				Finally, if no context manager is available, the user defaults data base is used.
				All the set methods follow the same management.
				It is the responsibility of the object to store and retrieve its own context metadata.
*/

@interface NSObject(iTM2ContextKit)

/*! 
    @method		contextManager
    @abstract	the context manager is responsible of the management of some data describing the context...
    @discussion	See the class description above. The default implementation just returns the current context manager.
                If no value is found in the receiver's context dictionary, the request is forwarded to the context manager.
    @param		None
    @result		A context manager
*/
-(id)contextManager;

/*! 
    @method		currentContextManager
    @abstract	the current context manager.
    @discussion	When no context manager is known at compile time, the current context manager is used.
				The default implementation just returns the standard user defaults database.
				Different objects might want to have different notions of current context manager such that
				there is no rule for current context management and storage.
				Subclassers can override this message as a whole and let peculiar object have the last word
				by overriding the currentContextManager message. Moreover, subclassers can choose a different strategy
				and return something different from the SUD.
				Beware of recursive calls.
    @param		None
    @result		A context manager
*/
-(id)currentContextManager;

/*! 
    @method		setContextManager:
    @abstract	setting the context manager.
    @discussion	The default implementation does nothing and must be overriden.
				The context manager is not retained by the receiver:
				you must be extremely careful when dealing with them, more precisely at dealloc time.
    @param		A new context manager
    @result		None
*/
-(void)setContextManager:(id)manager;

/*! 
    @method		updateContextManager
    @abstract	Update the context manager...
    @discussion	The default implementation does nothing. This is a design to let subclassers change the context manager.
				When something changes that should cause the context manager to change accordingly, this message should be sent.
				In particular, this message is sent in the iTMDocument setFileName: method,
				because it may also change the location where the context is stored to disk.
    @param		None
    @result		A context manager
*/
-(void)updateContextManager;

/*! 
    @method		contextDictionary
    @abstract	the context dictionary where local context meta data are stored...
    @discussion	The default implementation returns nil.
                This causes all the take... request to be forwarded to the receiver's context manager.
                If a subclasser returns a valid mutable dictionary, it will c&atch all the take... requests.
    @param		None
    @result		A NSDictionary
*/
-(id)contextDictionary;

/*! 
    @method		setContextDictionary:
    @abstract	setting the context dictionary.
    @discussion	The default implementation raises an exception and must be overriden.
    @param		A new NSDictionary
    @result		None
*/
-(void)setContextDictionary:(id)dictionary;

/*! 
    @method		contextValueForKey:
    @abstract	The context value for the given key.
    @discussion	Comes from the context dictionary if any, at least from the context manager.
    @param		key
    @result		None
*/
-(id)contextValueForKey:(NSString *)aKey;

/*! 
    @method		takeContextValue:forKey:
    @abstract	Records the given context value for the given key.
    @discussion	It forwards the request to the context manager,
                unless subclassers have overriden the contextDictionary to return a valid mutable dictionary.
    @param		value
    @param		key
    @result		None
*/
-(void)takeContextValue:(id)object forKey:(NSString *)aKey;

/*! 
    @method		contextFontForKey:
    @abstract	Abstract forthcoming.
    @discussion	Discussion forthcoming.
    @param		key
    @result		None
*/
-(NSFont *)contextFontForKey:(NSString *)aKey;

/*! 
    @method		takeContextFont:forKey:
    @abstract	Abstract forthcoming.
    @discussion	Discussion forthcoming.
    @param		value
    @param		key
    @result		None
*/
-(void)takeContextFont:(NSFont *)aFont forKey:(NSString *)aKey;

/*! 
    @method		contextColorForKey:
    @abstract	Abstract forthcoming.
    @discussion	Discussion forthcoming.
    @param		key
    @result		None
*/
-(NSColor *)contextColorForKey:(NSString *)key;

/*! 
    @method		takeContextColor:forKey:
    @abstract	Abstract forthcoming.
    @discussion	Discussion forthcoming.
    @param		value
    @param		key
    @result		None
*/
-(void)takeContextColor:(NSColor *)value forKey:(NSString *)key;

/*! 
    @method		contextStringForKey:
    @abstract	Abstract forthcoming.
    @discussion	Discussion forthcoming.
    @param		key
    @result		None
*/
-(NSString *)contextStringForKey:(NSString *)key;

/*! 
    @method		contextArrayForKey:
    @abstract	Abstract forthcoming.
    @discussion	Discussion forthcoming.
    @param		key
    @result		None
*/
-(NSArray *)contextArrayForKey:(NSString *)key;

/*! 
    @method		contextDictionaryForKey:
    @abstract	Abstract forthcoming.
    @discussion	Discussion forthcoming.
    @param		key
    @result		None
*/
-(NSDictionary *)contextDictionaryForKey:(NSString *)key;

/*! 
    @method		contextDataForKey:
    @abstract	Abstract forthcoming.
    @discussion	Discussion forthcoming.
    @param		key
    @result		None
*/
-(NSData *)contextDataForKey:(NSString *)key;

/*! 
    @method		contextStringArrayForKey
    @abstract	Abstract forthcoming.
    @discussion	Discussion forthcoming.
    @param		key
    @result		None
*/
-(NSArray *)contextStringArrayForKey:(NSString *)key;

/*! 
    @method		contextIntegerForKey:
    @abstract	Abstract forthcoming.
    @discussion	Discussion forthcoming.
    @param		key
    @result		None
*/
-(int)contextIntegerForKey:(NSString *)key; 

/*! 
    @method		contextFloatForKey:
    @abstract	Abstract forthcoming.
    @discussion	Discussion forthcoming.
    @param		key
    @result		None
*/
-(float)contextFloatForKey:(NSString *)key; 

/*! 
    @method		contextBoolForKey:
    @abstract	Abstract forthcoming.
    @discussion	Discussion forthcoming.
    @param		key
    @result		None
*/
-(BOOL)contextBoolForKey:(NSString *)key;  

/*! 
    @method		takeContextInteger:forKey:
    @abstract	Abstract forthcoming.
    @discussion	Discussion forthcoming.
    @param		value
    @param		key
    @result		None
*/
-(void)takeContextInteger:(int)value forKey:(NSString *)key;

/*! 
    @method		takeContextFloat:forKey:
    @abstract	Abstract forthcoming.
    @discussion	Discussion forthcoming.
    @param		value
    @param		key
    @result		None
*/
-(void)takeContextFloat:(float)value forKey:(NSString *)key;

/*! 
    @method		takeContextBool:forKey:
    @abstract	Abstract forthcoming.
    @discussion	Discussion forthcoming.
    @param		value
    @param		key
    @result		None
*/
-(void)takeContextBool:(BOOL)value forKey:(NSString *)key;

/*! 
    @method     saveContext:
    @abstract	Abstract forthcoming.
    @discussion	Will send any message of the form ...CompleteSaveContext:.
				You should not subclass this method unless you really know what you are doing...
				Typically, subclassers define their ...CompleteSaveContext: to store some meta information.
				This message is sent at termination time or when a document is asked for closing.
				The window controller is sent this message just before it closes.
				The documents are sent this message when the application terminates.
                The also documents forward the messages to all the window controllers.
                Some naming convention should be followed in order to avoid conflicts:
                the blahClassNameSaveContext: should only be declared by a class named ??ClassName.
                Subclassers will be able to override the inherited behaviour and implement its own patch independently from the other stuff.
                Saving the context should be made before closing the documents.
                Thus a document sends this message just before the canClose.... is called.
                You should not call the saveContext: method yourself
                but you are free to call your blablablaCompleteSaveContext... of course!
    @param      None
    @result     None
*/
-(void)saveContext:(id)sender;

/*! 
    @method     loadContext
    @abstract	Abstract forthcoming.
    @discussion	Reverse saveContext: operation.
	@param      None
    @result     None
*/
-(void)loadContext:(id)sender;

/*! 
    @method     awakeFromContext
    @abstract	Abstract forthcoming.
    @discussion	Default implementation does quite nothing.
	@param      None
    @result     None
*/
-(void)awakeFromContext;

/*! 
    @method     contextDidChange
    @abstract	Abstract forthcoming.
    @discussion	You should send this message whenever the context will need a registration at appropriate time.
				The default implementation does nothing else unless the receiver has an implementation.
				(see iTM2Implementation.h)
    @param      None
    @result     None
*/
-(void)contextDidChange;

/*! 
    @method     contextRegistrationNeeded
    @abstract	Abstract forthcoming.
    @discussion	Whether the coontext needs registration.
				The saveContext: method always forwards the message as ...SaveContext: submessages,
				whatever contextRegistrationNeeded returns. It is up to the ...SaveContext: to decide what to do
				according to this flag, possibly ignoring the return value. When saveContext: returns,
				contextRegistrationNeeded returns NO until a contextDidChange is sent.
				The default implementation always return NO unless the receiver has an implementation.
				(see iTM2Implementation.h)
    @param      None
    @result     yorn
*/
-(BOOL)contextRegistrationNeeded;

@end

@interface NSDocument(iTM2ContextKit)

/*! 
    @method     contextValueForKey:
    @abstract   Abstract forthcoming.
    @discussion See the -takeContextValue:forKey: discussion below.
    @param      key
    @result     A value
*/
-(id)contextValueForKey:(NSString *)key;

/*! 
    @method     takeContextValue:forKey:
    @abstract   Abstract forthcoming.
    @discussion This is the setter entry point for the context of documents.
				It also maintains a copy of each context value based on the file extension.
				Thes scheme is the following:
				1 - saving a context value
				- one object asks to save the context value
				- the document is asked to save the context value
				The documents is saving in 3 different location
				a - in the user defaults data base area reserved to the documents
					which file names have the same extension
				b - in the user defaults data base area reserved to the documents of the same type
				c - in the user defaults data base
				2 - retrieving a context value, for a document owned by a project
				The management of the context for the other documents remains unchanged 
				- one object asks for a context value
				- the document is asked for the context value
				a - if the context value exists in the user defaults data base area reserved to the documents
					which file names have the same extension, it is returned
				b - if the context value exists in the user defaults data base area reserved to the documents
					of the same type, it is returned
				c - if the context value exists in the user defaults data base, it is returned
				We do not want to reserve a placeholder for each document in the user defaults database.
				Only file extensions and document types are authorized such that a limited amount of info is stored.
    @param      value is the new value
    @param      key is the context value key
    @result     None
*/
-(void)takeContextValue:(id)value forKey:(NSString *)key;

/*! 
    @method     documentCompleteSaveContext:
    @abstract	Abstract forthcoming.
    @discussion	Sends a saveContext: message to each window controller.
    @param      sender
    @result     None
*/
-(IBAction)documentCompleteSaveContext:(id)sender;

/*! 
    @method     documentCompleteLoadContext:
    @abstract	Abstract forthcoming.
    @discussion	Sends a loadContext: message to each window controller.
    @param      sender
    @result     None
*/
-(IBAction)documentCompleteLoadContext:(id)sender;

@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2ContextKit
