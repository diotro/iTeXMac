/*
//
//  @version Subversion: $Id$ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Fri Sep 05 2003.
//  Copyright © 2003 Laurens'Tribune. All rights reserved.
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

extern NSString * const iTM2MainType;

#define IMPLEMENTATION [self implementation]
#define metaGETTER [[self implementation] metaValueForSelector:_cmd]
#define metaSETTER(argument) [[self implementation] takeMetaValue:argument forSelector:_cmd]
#define modelGETTER(type) [[self implementation] modelValueForSelector:_cmd ofType:type]
#define modelSETTER(argument, type) [[self implementation] takeModelValue:argument forSelector:_cmd ofType:type]
#define mainModelGETTER [[self implementation] modelValueForSelector:_cmd ofType:iTM2MainType]
#define mainModelSETTER(argument) [[self implementation] takeModelValue:argument forSelector:_cmd ofType:iTM2MainType]

/*!
    @function	iTM2KeyFromSelector
    @abstract   Selector to key mapping
    @discussion selectors named action, isAction, setAction, getAction all give key named @"Action"
    @param      selector is a valid selector
    @result     A key
*/
NSString * iTM2KeyFromSelector(SEL selector);

/*!
	@class		iTM2Implementation
	@abstract	The basic implementation controller.
	@discussion	This ensures the mutability part of the implementation layer of the document architecture.
				It implements a tree hierarchy.
				It maintains a dictionary of independant model object, each one possibly stored in its own file.
				Each model is meant to be a dictionary at first glance.
				This is a very low level object and the method names can conflict with other higher level ones.
				It is not very important since the context should be clear.
				This allows to have a dynamic data model for an object.
				Developers can have unlimited instance variables when posing or categorizing.
				When an object is said to have a private iTM2Implementation,
				you can use it to extend the number of instance variables without changing the header.
				To have access to a new instance variable without changing the header (which you cannot always do)
				you just have to implement setter and getters in which you will make calls to metaGETTER and metaSETTER().
				Both macros will act on objects and will store or retrieve the arguments with a KVC like design.
				There is somehow limitations: getFoo, isFoo, setFoo, foo, _setFoo, _getFoo will all refer to the same underlying data.
				You must not use at the same time the isFoo and getFoo selectors to access different data.
*/
@interface iTM2Implementation: NSObject
{
@private
	id _Owner;
	id _Parent;
	id _DataRepresentations;
	id _MetaValueDictionary;
}

/*! 
	@method 	initWithOwner:
	@abstract   Designated initializer.
	@discussion Discussion forthcoming.
				The owner is not retained, of course.
	@param  	The owner
	@result 	something
*/
- (id)initWithOwner:(id)owner;

/*!
	@method		implementation
	@abstract	The implementation controller of the receiver.
	@discussion	As the receiver is itself a implementation controller, it has no implementation controller:
				it is its own implementation controller. So this method just returns self.
				This is a tricky definition to allow the tree hierarchy to be disconnected to the iTM2Document class objects.
	@result		self.
*/
- (id)implementation;

/*!
	@method		owner
	@abstract	The document owning the receiver.
	@discussion	The receiver is assumed to be own by an iTM2Document. Therefore it will not own its owner to avoid memory leaks.
	@result		Basically, it is an iTM2Document.
*/
- (id)owner;

/*!
	@method		setOwner:
	@abstract	Basic setter.
	@discussion	The receiver is assumed to be own by an iTM2Document. Therefore it will not own its owner to avoid memory leaks.
	@param		Basically, it is an iTM2Document.
*/
- (void)setOwner:(id)argument;

/*!
	@method		root
	@abstract	The top of the owning hierarchy.
	@discussion	Description Forthcoming.
	@result		Basically, it is an iTM2Document.
*/
- (id)root;

/*!
	@method		name
	@abstract	The name of the receiver.
	@discussion	If there is an owner responding to the fileName message, its fileName is returned.
				Otherwise a local value is used.
	@result		A name.
*/
- (id)name;

/*!
	@method		setName:
	@abstract	Set the name of the receiver.
	@discussion	If there is an owner responding to the setFileName message, nothing is done,
				otherwise a local variable is used to store the argument.
	@param		A name.
	@result		None.
*/
- (void)setName:(id)argument;

/*!
	@method		modelType
	@abstract	The type of the receiver.
	@discussion	If there is an owner responding to the fileType message, its fileType is returned.
				Otherwise a local value is used.
	@result		A type.
*/
- (id)modelType;

/*!
	@method		setModelType:
	@abstract	Set the type of the receiver.
	@discussion	If there is an owner responding to the setFileType message, nothing is done,
				otherwise a local variable is used to store the argument.
	@param		A name.
	@result		None.
*/
- (void)setModelType:(id)argument;

/*!
	@method		metaValues
	@abstract	The meta data of the receiver.
	@discussion	Description forthcoming.
	@param		key is a key dictionary object
*/
- (id)metaValues;

/*!
	@method		metaValues
	@abstract	The meta data of the receiver.
	@discussion	Description forthcoming.
	@param		key is a key dictionary object
*/
- (id)metaValues;

/*!
	@method		takeMetaValues:
	@abstract	Abstract forthcoming.
	@discussion	Discussion forthcoming.
	@param		The new meta values
	@result		None
*/
- (void)takeMetaValues:(NSDictionary *)argument;

/*!
	@method		metaValueForKey:
	@abstract	The meta data of the receiver for the given key.
	@discussion	The receiver can store more information than just the data implementation.
	@param		key is a key dictionary object
*/
- (id)metaValueForKey:(NSString *)key;

/*!
	@method		takeMetaValue:forKey:
	@abstract	Take the given meta data for the given key.
	@discussion	Basic setter.
	@param		the argument is any kind of object
	@param		key is a key dictionary object
*/
- (void)takeMetaValue:(id)argument forKey:(NSString *)key;

/*!
	@method		metaValueForKeyPath:
	@abstract	The meta data of the receiver for the given key path.
	@discussion	The receiver can store more information than just the data implementation.
	@param		key is a key dictionary object
*/
- (id)metaValueForKeyPath:(NSString *)key;

/*!
	@method		takeMetaValue:forKeyPath:
	@abstract	Take the given meta data for the given key path.
	@discussion	Basic setter.
	@param		the argument is any kind of object
	@param		key is a key dictionary object
	@result		None.
*/
- (void)takeMetaValue:(id)argument forKeyPath:(NSString *)key;

/*!
	@method		metaFlagForKey:
	@abstract	Absract forthcoming.
	@discussion	Description forthcoming.
	@param		key is a key
	@result		a flag.
*/
- (BOOL)metaFlagForKey:(NSString *)key;

/*!
	@method		takeMetaFlag:forKey:
	@abstract	Absract forthcoming.
	@discussion	Description forthcoming.
	@param		yorn is a flag
	@param		key is a key
	@result		None.
*/
- (void)takeMetaFlag:(BOOL)yorn forKey:(NSString *)key;

/*!
	@method		dataRepresentationOfType:
	@abstract	The receiver's representation with the given key.
	@discussion	This default implementation returns the object contained in the data representation dictionary of
				the receiver which key is the given type.
	@param		type is a key dictionary type
	@result		a data object.
*/
- (NSData *)dataRepresentationOfType:(NSString *)type;

/*!
	@method		willSave
	@abstract	The document is going to save.
	@discussion	The document of the receiver will ask the receiver to perform some actions before it saves
				in its documentWillSave method. The default implementation just forwards the message to the children.
				Subclassers will append or prepend their own stuff, calling super method unless good reasons are invoked.
*/
- (void)willSave;

/*!
	@method		didSave
	@abstract	The document has just saved.
	@discussion	The document of the receiver will ask the receiver to perform some actions after it saved
				in its documentWillSave method. The default implementation just forwards the message to the children.
				Subclassers will append or prepend their own stuff, calling super method unless good reasons are invoked.
*/
- (void)didSave;

/*!
	@method		didRead
	@abstract	The document has just read its data.
	@discussion	The document of the receiver will ask the receiver to perform some actions before it saves
				in its documentDidRead method. The default implementation just forwards the message to the children.
				Subclassers will append or prepend their own stuff, calling super method unless good reasons are invoked.
				It is time now for thge receiver to read its data from the document or the parent
*/
- (void)didRead;

/*!
	@method		loadDataRepresentation:ofType:
	@abstract	Loads the given data representation, assuming its type.
	@discussion	This default implementation just stores the given data in its data representation dictionary, as is, with key, the given type. It overrides any previously loaded data representation with no precaution.
	@result		YES.
*/
- (BOOL)loadDataRepresentation:(NSData *)data ofType:(NSString *)type;

/*!
	@method		dataRepresentationTypes
	@abstract	All the keys of the data representations.
	@discussion	Description forthcoming.
	@result		an array of NSString's.
*/
- (NSArray *)dataRepresentationTypes;

/*!
	@method		writeToParentImplementation
	@abstract	Write the data implementation of the
 to the implementation controller of the parent of ther receiver.
	@discussion	Description never forthcoming.
	@result		yorn.
*/
- (BOOL)writeToParentImplementation;

/*!
	@method		readFromParentImplementation
	@abstract	Read the data implementation of the owner from the implementation controller of the parent of ther receiver.
	@discussion	Description never forthcoming.
	@result		yorn.
*/
- (BOOL)readFromParentImplementation;

/*!
	@method		writeToDirectoryWrapper:
	@abstract	Write the data implementation of the receiver to the given diorectory wrapper.
	@discussion	Description never forthcoming.
	@result		yorn.
*/
- (BOOL)writeToDirectoryWrapper:(NSFileWrapper *)DW;

/*!
	@method		readFromDirectoryWrapper:
	@abstract	Read the data implementation of the owner from the given directory wrapper.
	@discussion	Description never forthcoming.
	@result		yorn.
*/
- (BOOL)readFromDirectoryWrapper:(NSFileWrapper *)DW;

/*!
	@method		parent
	@abstract	The parent document.
	@discussion	This is the first support for a tree hierarchy.
				The parent document owns the receiver but the receiver does not own its parent document.
	@result		Basically, it is an iTM2Document.
*/
- (id)parent;

/*!
	@method		setParent:
	@abstract	Basic setter.
	@discussion	Description forthcoming.
				This exposed method should not be used, the parent is automatically set by the parent itself in the addChild:
				and removeChild: methods. The receiver will not retain its parent. The parent is expected to own its children.
	@param		an iTM2Document.
	@result		None.
*/
- (void)setParent:(id)argument;

/*!
	@method		children
	@abstract	The child documents of the receiver.
	@discussion	The child documents are the leaves of the tree whereas the receiver is the node.
				It is a lazy initializer returning a void array at least.
	@result		Basically, it is an iTM2Document.
*/
- (id)children;

/*!
	@method		childForName:
	@abstract	The named child document of the receiver.
	@discussion	If the receiver has no child document with that name, nil is returned.
	@result		Basically, it is an iTM2Document, but it is not required.
*/
- (id)childForName:(NSString *)name;

/*!
	@method		addChild:
	@abstract	Basic adder.
	@discussion	Description forthcoming.
	@param		an iTM2Document.
*/
- (void)addChild:(id)argument;

/*!
	@method		removeChild:
	@abstract	Basic remover.
	@discussion	Description forthcoming.
	@param		an iTM2Document.
*/
- (void)removeChild:(id)argument;

/*!
	@method		updateChildren
	@abstract	Upadte the children of the receiver assuming the owner is given.
				The default implementation just forwards the message to its owner, if it responds to.
				iTeXMac2 project documents are hierarchical and are meant to contain children.
	@discussion	Description never forthcoming.
*/
- (void)updateChildren;

/*!
	@method		modelFormatOfType:
	@abstract	The format used to save the value property list.
	@discussion	Description never forthcoming.
	@param  	type is a type
	@result 	a NSPropertyListFormat
*/
- (NSPropertyListFormat)modelFormatOfType:(NSString *)type;

/*!
	@method		takeModelFormat:ofType:
	@abstract	Basic setter.
	@discussion	Description never forthcoming.
	@param  	argument is a NSPropertyListFormat
	@param  	key is a key
	@result 	None
*/
- (void)takeModelFormat:(NSPropertyListFormat)argument ofType:(NSString *)type;

/*!
	@method		dataRepresentationOfModelOfType:
	@abstract	A data representation of the model value for the given type.
	@discussion	Returns a property list serialized object with the appropriate format.
	@param  	type is a type
	@param  	outError is an NSError instance pointer
	@result 	a data object
*/
- (NSData *)dataRepresentationOfModelOfType:(NSString *)type error:(NSError**)outError;
- (NSData *)dataRepresentationOfModelOfType:(NSString *)type;//Deprecated, use the above method

/*!
	@method		loadModelValueOfDataRepresentation:ofType:
	@abstract	Basic loader.
	@discussion	Description never forthcoming.
	@param  	data is a data
	@param  	type is a key
	@param  	outError is an NSError instance pointer
	@result 	A flag indicating whther things have been done or not.
*/
- (BOOL)loadModelValueOfDataRepresentation:(NSData *)data ofType:(NSString *)type error:(NSError**)outError;
- (BOOL)loadModelValueOfDataRepresentation:(NSData *)data ofType:(NSString *)type;//Deprecated, use the above method

/*!
	@method		modelTypes
	@abstract	Basic getter.
	@discussion	Description never forthcoming.
	@param		None
	@result		an NSArray of NSString's.
*/
- (NSArray *)modelTypes;

/*!
	@method		modelOfType:
	@abstract	Basic getter.
	@discussion	Description never forthcoming.
	@param		type is a type
	@result		a model
*/
- (id)modelOfType:(NSString *)type;

/*!
	@method		takeModel:ofType:
	@abstract	Basic setter.
	@discussion	Description never forthcoming.
	@param		a model
	@param		type is a type
	@result		None
*/
- (void)takeModel:(id)model ofType:(NSString *)type;

/*!
	@method		modelValueKeysOfType:
	@abstract	Abstract forthcoming.
	@discussion	Description forthcoming.
	@param		None
	@result		an NSArray of NSString's.
*/
- (NSArray *)modelValueKeysOfType:(NSString *)type;

/*!
	@method		modelValueForKey:ofType:
	@method		takeModelValue:ofType:
	@abstract	Key/Value coding.
	@discussion	Discussion forthcomning.
	@param		key is a key
	@param		type is a type
	@result		a property list, if relevant.
*/
- (id)modelValueForKey:(NSString *)key ofType:(NSString *)type;

/*!
	@method		modelValueForKey:ofType:
	@method		takeModelValue:ofType:
	@abstract	Key/Value coding.
	@discussion	Discussion forthcomning.
	@param		PL, if relevant
	@param		key is a key
	@param		type is a type
	@result		None.
*/
- (void)takeModelValue:(id)PL forKey:(NSString *)key ofType:(NSString *)type;

@end

@interface iTM2Implementation(Selector)
/*!
	@method		metaValueForSelector:
	@abstract	Meta value for the given selector.
	@discussion	This a convenient method to avoid the alloc dealloc management.
				If an object declares an iTM2Implementation for a storage,
				it can easyly add setters and getters for meta value object.
				Model objects are not yet managed because this might be more sensitive.
				All methods
				- (id) myMetaValue;
				- (id) _MyMetaValue;
				- (id) getMyMetaValue;
				- (id) _getMyMetaValue;
				with implementation
				{
					return [[self implementation] metaValueForSelector:_cmd];
				}
				Will return the same object with key: @"MyMetaValue".
				It is extremely interesting because it allows subclasses to add their own setters and getters with no instance variables in the interface.
				That way, memory management is really made easier.
	@param		A getter selector
	@result		An object.
*/
- (id)metaValueForSelector:(SEL)selector;

/*!
	@method		takeMetaValue:forSelector:
	@abstract	set the Meta value for the given selector.
	@discussion	This a convenient method to avoid the alloc dealloc management.
				All methods
				- (void) takeMyMetaValue: (id) argument;
				- (void) _takeMyMetaValue: (id) argument;
				- (void) setMyMetaValue: (id) argument;
				- (void) _setMyMetaValue: (id) argument;
				with implementation
				{
					[[self implementation] takeMetaValueForSelector:_cmd];
					return;
				}
				Will replace the impolementation meta object for key: @"MyMetaValue" with the given one.
	@param		argument is an object.
	@param		A setter selector
	@result		None.
*/
- (void)takeMetaValue:(id)argument forSelector:(SEL)selector;

/*!
	@method		modelValueForSelector:ofType:
	@abstract	Model value for the given selector and type.
	@discussion	This a convenient method to avoid the alloc dealloc management.
				If an object declares an iTM2Implementation for a storage,
				it can easyly add setters and getters for meta value object.
				Model objects are not yet managed because this might be more sensitive.
				All methods
				- (id) myMetaValue;
				- (id) _MyMetaValue;
				- (id) getMyMetaValue;
				- (id) _getMyMetaValue;
				with implementation
				{
					return [[self implementation] modelValueForSelector:_cmd type:theType];
				}
				Will return the same object with key: @"MyMetaValue" in the model part type theType.
				It is extremely interesting because it allows subclasses to add their own setters and getters with no instance variables in the interface.
				That way, memory management is really made easier.
	@param		A getter selector
	@param		type is a type
	@result		An object.
*/
- (id)modelValueForSelector:(SEL)selector ofType:(NSString *)type;

/*!
	@method		takeModelValue:forSelector:ofType:
	@abstract	set the Meta value for the given selector.
	@discussion	This a convenient method to avoid the alloc dealloc management.
				All methods
				- (void) takeMyMetaValue: (id) argument;
				- (void) _takeMyMetaValue: (id) argument;
				- (void) setMyMetaValue: (id) argument;
				- (void) _setMyMetaValue: (id) argument;
				with implementation
				{
					[[self implementation] takeModelValueForSelector:_cmd ofType:theType];
					return;
				}
				Will replace the implementation theType model object for key: @"MyMetaValue" with the given one.
	@param		argument is an object.
	@param		A setter selector
	@param		type is a type
	@result		None.
*/
- (void)takeModelValue:(id)argument forSelector:(SEL)selector ofType:(NSString *)type;

@end

/*!
	@category	iTM2Implementation
	@abstract	The basic protocol any object conforms to.
	@discussion	Subclassers of NSObject that plan to use this implementation must implement the implementation and setImplementation:
				Their designated initializer should send a initImplementation to itself to set tup the implementation object.
				The lazy implementation is used to initialize the implementation object in the initImplementation method.
				The implementation prefixed method are directly connected to the implementation.
				Beware of conflicting name declarations.
*/
@interface NSObject(iTM2Implementation)

/*!
	@method		defaultModel
	@abstract	The default model.
	@discussion	The default implementation returns a void dictionary.
				Subclassers will return the model used for KVC.
				This is a shortcut, valueForUndefinedKey: and setValue:forUndefinedKey: simply use the main model for the keys declared in the defaultModel dictionary.
	@param		None.
	@result		None.
*/
+ (NSDictionary *)defaultModel;

/*!
	@method		initImplementation
	@abstract	Init's the implementation of the receiver.
	@discussion	This method should balance a forthcoming used dealloc Implementation.
				This method is using fixImplementation to setup the implementation.
				You should not override this method.
	@param		None.
	@result		None.
*/
- (void)initImplementation;

/*!
	@method		fixImplementation
	@abstract	Fixes the implementation of the receiver.
	@discussion	Each method xxxFixImplementation the receiver is responding to will be called.
				No order in the calls is defined even for inherited methods.
				You should not override this method.
	@param		None.
	@result		None.
*/
- (void)fixImplementation;

/*!
	@method		deallocImplementation
	@abstract	Dealloc's the implementation of the receiver.
	@discussion	This method should balance an already used initImplementation.
				Subclassers won't forget to call the inherited method.
	@param		None.
	@result		None.
*/
- (void)deallocImplementation;

/*!
	@method		observeImplementation
	@abstract	Abstract forthcoming.
	@discussion	Discussion forthcoming.
				Observe model changes in the implementation.
				Automatic registration of notifications.
				For each method the receiver implements, which name is keyModelObjectDidChangeNotified:
				for various "key", the receiver is registered to observe a "key" notification sent by its implementation.
				Beware, all the instance methods implemented by the class are searched:
				inherited methods are included.
				You can override this method to implement nothing to bypass this registration process.
				By default, the implementation is observed.
	@param		None.
	@result		None.
*/
- (void)observeImplementation;

/*!
	@method		implementation
	@abstract	The implementation object af the receiver.
	@discussion	Less basic getter, the default implementation is a lazy initializer.
				Subclassers won't forget to call the inherited method.
	@param		None.
	@result		an iTM2Implementation instance.
*/
- (id)implementation;

/*!
	@method		lazyImplementation
	@abstract	The lazy implementation object af the receiver.
	@discussion	Used to initialize lazyly.
	@param		None.
	@result		an iTM2Implementation instance.
*/
- (id)lazyImplementation;

/*!
	@method		setImplementation:
	@abstract	set the implementation object af the receiver.
	@discussion	Basic setter, must be implemented by subclassers because the defaault implementation does nothing.
	@param		an iTM2Implementation instance.
	@result		None
*/
- (void)setImplementation:(id)argument;

/*!
	@method		replaceImplementation:
	@abstract	Replace the data implementation.
	@discussion	If relevant, implementationWillChange and implementationDidChange are sent.
	@result		an iTM2Implementation instance.
*/
- (void)replaceImplementation:(id)argument;

/*!
	@method		implementationWillChange
	@abstract	The implementation is going to change.
	@discussion	Sucbclassers will prepend their stuff.
				The default implementation just sets the owner of old the reveiver's implementation to nil.
	@param		None.
	@result		None.
*/
- (void)implementationWillChange;

/*!
	@method		implementationDidChange
	@abstract	The implementation has changed.
	@discussion	Sucbclassers will append their stuff.
				The default implementation just sets the owner of the reveiver's implementation to itself to the new one.
	@param		None.
	@result		None.
*/
- (void)implementationDidChange;

/*!
	@method		willDealloc
	@abstract	The receiver will dealloc.
	@discussion	Automatically sends all the message which names match the regular expression .*CompleteDealloc.
				You seldomly need to override this method.
				In your .*CompleteDealloc, you will be given a chance to perform various operations.
	@param		None.
	@result		None.
*/
- (void)willDealloc;

@end


/*!
	@category	NSNotificationCenter(Implementation)
	@abstract	Abstract Forthcoming.
	@discussion	Each time an implementation object changes one of its model objects,
				it sends an iTM2ImplementationDidChangeModelObjectNotification to this center with itself as object.
				The user info is a dictionary containing the key of the modified object and the previous value if relevant.
				The respective keys are: @"key" and "previous". The current value can be retrieved with the object and the key.
				THEN it sends a notification to the same center which name is the key and the object is the the implementation.
				The user info is a dictionary containing only the previous value if relevant.
				That way, observers can both observe changes as a whole, or observe only peculiar parts.
*/

extern NSString * const iTM2ImplementationDidChangeModelObjectNotification;

#define IMPNC [NSNotificationCenter implementationCenter]

@interface NSNotificationCenter(Implementation)

/*!
	@method		implementationCenter
	@abstract	A private notification center.
	@discussion	See the general discussion above.
	@param		None.
	@result		NSNotificationCenter.
*/
+ (NSNotificationCenter *)implementationCenter;

@end

@interface iTM2Object: NSObject
{
@private
	id _Implementation;
}
/*!
	@method		implementation
	@abstract	Abstract forthcoming.
	@discussion	Discussion forthcoming.
	@param		None.
	@result		an iTM2Implementation object.
*/
- (id)implementation;

/*!
	@method		setImplementation:
	@abstract	Abstract forthcoming.
	@discussion	Discussion forthcoming.
	@param		None.
	@result		None.
*/
- (void)setImplementation:(id)argument;

@end

/*!
	@class		iTM2Proxy
	@abstract	Semi abstract class to manage the implementation.
	@discussion	Discussion forthcoming.
*/
@interface iTM2Proxy: NSProxy
{
@private
	id _Implementation;
}
/*!
	@method		implementation
	@abstract	Abstract forthcoming.
	@discussion	Discussion forthcoming.
	@param		None.
	@result		an iTM2Implementation object.
*/
- (id)implementation;

/*!
	@method		setImplementation:
	@abstract	Abstract forthcoming.
	@discussion	Discussion forthcoming.
	@param		None.
	@result		None.
*/
- (void)setImplementation:(id)argument;

- (void)initImplementation;

/*!
	@method		fixImplementation
	@abstract	Fixes the implementation of the receiver.
	@discussion	Each method xxxFixImplementation the receiver is responding to will be called.
				No order in the calls is defined even for inherited methods.
				You should not override this method.
	@param		None.
	@result		None.
*/
- (void)fixImplementation;

/*!
	@method		deallocImplementation
	@abstract	Dealloc's the implementation of the receiver.
	@discussion	This method should balance an already used initImplementation.
				Subclassers won't forget to call the inherited method.
	@param		None.
	@result		None.
*/
- (void)deallocImplementation;

/*!
	@method		observeImplementation
	@abstract	Abstract forthcoming.
	@discussion	Discussion forthcoming.
				Observe model changes in the implementation.
				Automatic registration of notifications.
				For each method the receiver implements, which name is keyModelObjectDidChangeNotified:
				for various "key", the receiver is registered to observe a "key" notification sent by its implementation.
				Beware, all the instance methods implemented by the class are searched:
				inherited methods are included.
				You can override this method to implement nothing to bypass this registration process.
				By default, the implementation is observed.
	@param		None.
	@result		None.
*/
- (void)observeImplementation;

@end
