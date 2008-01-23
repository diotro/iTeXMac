/*
//
//  @version Subversion: $Id: iTM2InfoWrapperKit.h 574 2007-10-08 23:21:41Z jlaurens $ 
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

#import <iTM2Foundation/iTM2ProjectDocumentKit.h>
#import <iTM2Foundation/iTM2ProjectControllerKit.h>

extern NSString * const TWSProjectKey;
extern NSString * const TWSSourceKey;
extern NSString * const TWSFactoryKey;
extern NSString * const TWSToolsKey;
extern NSString * const TWSTargetsKey;
extern NSString * const TWSKeyedFilesKey;
extern NSString * const TWSKeyedPropertiesKey;

extern NSString * const iTM2ProjectLastKeyKey;
extern NSString * const iTM2ProjectFrontDocumentKey;

extern NSString * const iTM2ProjectInfoComponent;
extern NSString * const iTM2ProjectMetaInfoComponent;

// This macro turns a non void variable argument list of objects in an array.
// FIRST is the argument name that appears in the function header before the ",..."
// MRA is the name of the resulting array, it will be created
#define iTM2_VA_LIST_OF_PATHS_TO_ARRAY(FIRST,MRA)\
	NSMutableArray * MRA = [NSMutableArray array];\
	if(FIRST)\
	{\
		[MRA addObject:FIRST];\
		va_list list;\
		va_start(list,FIRST);\
		NSString * S;\
		while(S = va_arg (list, id))\
		{\
			[MRA addObjectsFromArray:[S componentsSeparatedByString:@"."]];\
		}\
		va_end(list);\
	}

@interface NSMethodSignature(iTeXMac2)
+(id)signatureWithObjCTypes:(const char *)types;// undocumented method
@end

/*!
	@class			iTM2InfoWrapper
	@abstract		This is a wrapper over a property list with convenient accessors.
	@discussion		Discussion forthcoming.
	@availability	iTM2.
	@copyright		2007 jlaurens AT users DOT sourceforge DOT net and others.
*/

@interface iTM2InfoWrapper: iTM2Object

/*!
	@method			model
	@abstract		The model of the receiver.
	@discussion		The model is retrieved from the repository, with the given repositoryKeyPath.
	@param			None
	@result			a mutable property list dictionary.
	@availability	iTM2.
	@copyright		2007 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (id)model;

/*!
	@method			setModel:
	@abstract		Abstract forthcoming.
	@discussion		The mutable model is updated accordingly
					This method makes a deep copy of the receiver, just in case a mutable object was there, but this is subject to changes!
	@param			model is expected to be a property list dictionary
	@result			None.
	@availability	iTM2.
	@copyright		2007 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (void)setModel:(id)model;

/*!
	@method			infoForKeys:
	@abstract		The designated local model accessor unless a more specific one exists.
	@discussion		Discussion forthcoming.
	@param			an array of key, for a plist dictionary entry.
	@result			an object from a property list.
	@availability	iTM2.
	@copyright		2007 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (id)infoForKeys:(NSArray *)keys;

/*!
	@method			infoForKeys:
	@abstract		The designated local model accessor unless a more specific one exists.
	@discussion		Convenient accessor: usage <code>[self infoForKeyPaths:@"first",@"second",nil]</code>.
					It converts the list of keys into an array, then returns <code>[self infoForKeys:arrayOfKeys]</code>
	@param			a list of key paths
	@result			an object from a property list.
	@availability	iTM2.
	@copyright		2007 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (id)infoForKeyPaths:(NSString *)first,...;

/*!
	@method			takeInfo:forKeys:
	@abstract		The designated model editor.
	@discussion		See <code>-model</code>. If intermediate objects do not exist, they are created as mutable dictionaries.
	@param			a value
	@param			an array of keys.
	@result			YES if the replacement is different from the replaced object.
	@availability	iTM2.
	@copyright		2007 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (BOOL)takeInfo:(id)info forKeys:(NSArray *)keys;

/*!
	@method			takeInfo:forKeyPaths:
	@abstract		The designated model editor.
	@discussion		See <code>-model</code>. If intermediate objects do not exist, they are created as mutable dictionaries.
	@param			a value
	@param			a variable length list of paths.
	@result			YES if the replacement is different from the replaced object.
	@availability	iTM2.
	@copyright		2007 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (BOOL)takeInfo:(id)info forKeyPaths:(NSString *)first,...;

/*!
	@method			changeCount
	@abstract		Abstract forthcoming.
	@discussion		Description forthcoming.
	@param			None
	@result			The number of changes made since the last save or so.
	@availability	iTM2.
	@copyright		2007 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (int)changeCount;

/*!
	@method			updateChangeCount:
	@abstract		Abstract forthcoming.
	@discussion		Description forthcoming.
	@param			Like NSDocument's eponym method
	@result			None.
	@availability	iTM2.
	@copyright		2007 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (void)updateChangeCount:(NSDocumentChangeType)change;

@end

@interface iTM2MainInfoWrapper:iTM2InfoWrapper

/*! 
    @method			initWithProjectURL:error:
    @abstract		Designated initializer.
    @discussion		Discussion forthcoming.
    @param			projectURL
   @param			outErrorPtr
    @result			an info wrapper
	@availability	iTM2.
	@copyright		2008 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (id)initWithProjectURL:(NSURL *)projectURL error:(NSError **)outErrorPtr;

/*! 
    @method			sourceName
    @abstract		The name of the source directory where the files are stored.
    @discussion		The path will be used by a project, relative to its enclosing folder.
    @param			None
    @result			a relative path
	@availability	iTM2.
	@copyright		2007 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (NSString *)sourceName;

/*! 
    @method			setSourceName:
    @abstract		Set the the name of the source directory where the files are stored.
    @discussion		The path will be used by a project, relative to its enclosing folder.
    @param			a relative path
    @result			None
	@availability	iTM2.
	@copyright		2007 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (void)setSourceName:(NSString *)path;

/*! 
    @method			keyedNames
    @abstract		The files dictionary.
    @discussion		Discussion forthcoming.
					This is preferrably for private use.
					Direct setters/getters are given.
					A default void dictionary is given.
    @param			None
    @result			A dictionary
	@availability	iTM2.
	@copyright		2007 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (id)keyedNames;

/*! 
    @method			nameForFileKey:
    @abstract		The file name for the given key.
    @discussion		nil is returned if the key is not covered by the allKeys list.
					This file name can be either absolute or relative.
    @param			a key
    @result			an NSString
	@availability	iTM2.
	@copyright		2007 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (NSString *)nameForFileKey:(NSString *)key;

/*! 
    @method			takeFileName:forFileKey:
    @abstract		Set the file name for the given key.
    @discussion		Description forthcoming.
	@param			a file name
	@param			a key
    @result			None
	@availability	iTM2.
	@copyright		2007 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (void)takeName:(NSString *)path forFileKey:(NSString *)key;

/*! 
    @method			propertiesForFileKey:
    @abstract		The properties dictionary for the given key.
    @discussion		Discussion forthcoming.
    @param			The key
    @result			A dictionary
	@availability	iTM2.
	@copyright		2007 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (id)propertiesForFileKey:(NSString *)key;

/*! 
    @method			takeProperties:forFileKey:
    @abstract		Set the properties dictionary for the given key.
    @discussion		Discussion forthcoming.
    @param			The key
    @param			A dictionary
    @result			None
	@availability	iTM2.
	@copyright		2007 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (BOOL)takeProperties:(id)properties forFileKey:(NSString *)key;

/*! 
    @method			takePropertyValue:forKey:fileKey:
    @abstract		Set the properties dictionary for the given key.
    @discussion		Discussion forthcoming.
    @param			The property
    @param			The key
    @param			The fileKey
    @param			yorn
    @result			None
	@availability	iTM2.
	@copyright		2007 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (BOOL)takePropertyValue:(id)property forKey:(NSString *)key fileKey:(NSString *)fileKey;

/*! 
    @method			nextAvailableKey
    @abstract		The next available key.
    @discussion		A key is given only once. If it is removed, it won't be attributed another time.
					To ensure this, we store the next key to be used with a @".." file name.
					The .. refers to a directory outside the Wrapper and is likely not to be used.
					Controllers will look at this key to see if the attributes they store does refer to anything still in the project.
					If the key is not one of the keys of the project, the corresponding attributes should be removed.
					No Undo management planned.
					The keys are quite anything, however, the dotted keys are reserved for private use,
					and should not be assigned to any file.
					iTeXMac2 uses the @".extension" key to store default values on an extension based scheme.
					See the -takeContextValue:forKey:fileKey: discussion.
    @param			fileName is a full path name
    @result			a unique key identifier
	@availability	iTM2.
	@copyright		2007 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (NSString *)nextAvailableKey;

@end

/*!
	@class			iTM2ProjectInfos
	@abstract		Each project has one infos manager from which it retrieves all the relevant information.
	@discussion		Discussion forthcoming.
	@availability	iTM2.
	@copyright		2007 jlaurens AT users DOT sourceforge DOT net and others.
*/
@interface iTM2ProjectDocument(Infos)

/*! 
    @method			mainInfos
    @abstract		The main infos.
    @discussion		Access the main info stored in the main property list. No inheritance here yet.
    @param			None
    @result			an iTM2InfosController instance
	@availability	iTM2.
	@copyright		2007 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (id)mainInfos;

/*! 
    @method			infosController
    @abstract		The infos controller.
    @discussion		This controller controls all the infos of the receiver, except the main one.
    @param			None
    @result			an iTM2InfosController instance
	@availability	iTM2.
	@copyright		2007 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (id)infosController;


/*! 
    @method			infoCompleteWriteToURL:ofType:error:
    @abstract		Where the various infos are written to disc.
    @discussion		Discussion forthcoming.
    @param			absoluteURL
    @param			fileType
    @param			outErrorPtr
    @result			YES or NO, whether or not something was reaaly saved.
	@availability	iTM2.
	@copyright		2007 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (BOOL)infoCompleteWriteToURL:(NSURL *)absoluteURL ofType:(NSString *)fileType error:(NSError **)outErrorPtr;

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
- (void)saveContext:(id)irrelevant;

/*! 
    @method     contextValueForKey:fileKey:domain:
    @abstract   Abstract forthcoming.
    @discussion The project is expected to manage the contexts of the files it owns.
				The standard user defaults database is used in the end of the chain.
    @param      \p aKey is the context key
    @param      \p fileKey is the file key
	@param		\p mask is a context domain mask
    @result     An object.
*/
- (id)contextValueForKey:(NSString *)aKey fileKey:(NSString *)fileKey domain:(unsigned int)mask;

/*! 
    @method     getContextValueForKey:fileKey:domain:
    @abstract   Abstract forthcoming.
    @discussion The project is expected to manage the contexts of the files it owns.
				The standard user defaults database is used in the end of the chain.
				This is used only by subclassers when overriding.
    @param      \p aKey is the context key
    @param      \p fileKey is the file key
	@param		\p mask is a context domain mask
    @result     An object.
*/
- (id)getContextValueForKey:(NSString *)aKey fileKey:(NSString *)fileKey domain:(unsigned int)mask;

/*! 
    @method     takeContextValue:forKey:fileKey:domain:
    @abstract   Abstract forthcoming.
    @discussion See the \p -contextValueForKey:fileKey: comment.
    @param      the value, possibly nil.
    @param      \p aKey is the context key
    @param      \p fileKey is the file key
	@param		\p mask is a context domain mask
    @result     yorn whether something has changed.
*/
- (unsigned int)takeContextValue:(id)object forKey:(NSString *)aKey fileKey:(NSString *)fileKey domain:(unsigned int)mask;

/*! 
    @method     setContextValue:forKey:fileKey:domain:
    @abstract   Abstract forthcoming.
    @discussion See the \p -contextValueForKey:fileKey: comment.
				This should only be used by subclassers.
    @param      the value, possibly nil.
    @param      \p aKey is the context key
    @param      \p fileKey is the file key
	@param		\p mask is a context domain mask
    @result     yorn whether something has changed.
*/
- (unsigned int)setContextValue:(id)object forKey:(NSString *)aKey fileKey:(NSString *)fileKey domain:(unsigned int)mask;

/*!
	@method			mainInfos
	@abstract		The main Info wrapper, containing the file keys and properties.
	@discussion		The main infos contains something the project won't inherit from ancestors.
	@param			None
	@result			an iTM2MainInfoWrapper instance
	@availability	iTM2.
	@copyright		2007 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (id)mainInfos;

/*!
	@method			otherInfos
	@abstract		The editable local Info wrapper.
	@discussion		The other infos actually contains project commands and is specific to the frontend but it will change.
	@param			None
	@result			an iTM2InfoWrapper instance
	@availability	iTM2.
	@copyright		2007 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (id)otherInfos;

/*!
	@method			metaInfos
	@abstract		The meta Info wrapper, containing the meta data used by iTM2, for example the location of the windows...
	@discussion		The meta infos can be inherited. It is private to the frontend.
	@param			None
	@result			an iTM2InfoWrapper instance
	@availability	iTM2.
	@copyright		2007 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (id)metaInfos;

/*!
	@method			customInfos
	@abstract		The custom Info wrapper.
	@discussion		Discussion forthcoming.
	@param			None
	@result			an iTM2InfoWrapper instance
	@availability	iTM2.
	@copyright		2007 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (id)customInfos;

/*!
	@method			mutableInfos
	@abstract		The mutable local Info wrapper.
	@discussion		This is where all edited values of otherInfos are recorded. You must save your changes.
	@param			None
	@result			an iTM2InfoWrapper instance
	@availability	iTM2.
	@copyright		2007 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (id)mutableInfos;

@end

/*!
	@class			iTM2InfosController
	@abstract		This is a controller of the iTM2InfosWrapper.
	@discussion		Discussion forthcoming.
	@availability	iTM2.
	@copyright		2007 jlaurens AT users DOT sourceforge DOT net and others.
*/

@interface iTM2InfosController: iTM2Object

/*!
	@method			initWithProject:atomic:prefixWithKeyPaths:
	@abstract		Designated initializer.
	@discussion		The model is retrieved from the repository, with the given repository key paths.
	@param			project is the owner of the receiver 
	@param			yorn: YES to edit in the mutableInfo part and allow some global undo management, NO to edit directly in the info part.
	@param			prefix is prepended to any key
	@result			an iTM2InfoController instance.
	@availability	iTM2.
	@copyright		2007 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (id)initWithProject:(id)project atomic:(BOOL)yorn prefixWithKeyPaths:(NSString *)prefix,...;

/*!
	@method			inheritedInfoForKeys:
	@abstract		Inherited info for the given keys.
	@discussion		Inherited infos are retrieved from the infos controller of the base project of the owning project.
	@param			an array of keys.
	@result			an object from a property list.
	@availability	iTM2.
	@copyright		2007 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (id)inheritedInfoForKeys:(NSArray *)keys;

/*!
	@method			infoForKeys:
	@abstract		The designated local model accessor unless a more specific one exists.
	@discussion		If the info is not retrieved from the owning project, the inherited info will be returned.
					If the receiver was created with a YES atomic flag, the info is first taken from the mutableInfos dictionary of the owner.
					Otherwise it is taken from the otherInfos dictionary of the owner.
	@param			an array of keys.
	@result			an object from a property list.
	@availability	iTM2.
	@copyright		2007 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (id)infoForKeys:(NSArray *)keys;

/*!
	@method			takeInfo:forKeys:
	@abstract		The designated "immutable" model editor.
	@discussion		If the receiver was created with a YES atomic flag, the mutableInfos dictionary of the owner will take the new info for the given keys.
					Otherwise it is the otherInfos dictionary of the owner which will take the modification.
	@param			a value
	@param			an array of keys.
	@result			YES if the replacement is different from the replaced object.
	@availability	iTM2.
	@copyright		2007 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (BOOL)takeInfo:(id)info forKeys:(NSArray *)keys;

/*!
	@method			isInfoEditedForKeys:
	@abstract		Is info edited for the given key?
	@discussion		If the receiver is not atomic, edition took place in the mutable info part, and the old value is available.
					The 
	@param			an array of keys.
	@result			YES if the receiver is Atomic and the last replacement was different from the replaced object.
	@availability	iTM2.
	@copyright		2007 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (BOOL)isInfoEditedForKeys:(NSArray *)keys;

/*!
	@method			localInfoForKeys:
	@abstract		The designated "mutable" model editor.
	@discussion		It returns the contents of the mutableInfos dictionary of the owning project,
					if the receiver was created with a YES atomic flag.
					It returns the contents of the otherInfos dictionary of the receiver otherwise.
	@param			an array of keys.
	@result			an object from a property list.
	@availability	iTM2.
	@copyright		2007 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (id)localInfoForKeys:(NSArray *)keys;

/*!
	@method			saveChangesForKeys:
	@abstract		Save the changes.
	@discussion		Does nothing if the receiver is not "atomic",
					otherwise all the edited values migrate from the mutableInfos to the otherInfos of the receiver's owning project.
	@param			an array of keys.
	@result			YES if the replacement is different from the replaced object.
	@availability	iTM2.
	@copyright		2007 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (BOOL)saveChangesForKeys:(NSArray *)keys;

/*!
	@method			revertChangesForKeys:
	@abstract		Cancel the changes.
	@discussion		Does nothing if the receiver is not "atomic",
					otherwise all the unedited values migrate from the otherInfos to the mutableInfos of the receiver's owning project.
	@param			an array of keys.
	@result			YES if the replacement is different from the replaced object.
	@availability	iTM2.
	@copyright		2007 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (BOOL)revertChangesForKeys:(NSArray *)keys;

/*!
	@method			customInfoForKeys:
	@abstract		The designated "custom" model getter.
	@discussion		Retrieves the information from the customInfos of the owning project, for the given keys.
					The customInfos is the repository of changes not yet edited.
	@param			an array of keys.
	@result			an object from a property list.
	@availability	iTM2.
	@copyright		2007 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (id)customInfoForKeys:(NSArray *)keys;

/*!
	@method			backupCustomForKeys:
	@abstract		Make a copy of the edited values as custom.
	@discussion		All the edited values migrate to the customInfos of the receiver's owning project.
	@param			an array of keys.
	@result			YES if the replacement is different from the replaced object.
	@availability	iTM2.
	@copyright		2007 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (void)backupCustomForKeys:(NSArray *)keys;

/*!
	@method			restoreCustomForKeys:
	@abstract		Make a copy of the custom values for the given keys, for editing.
	@discussion		All the values migrate from the customInfos of the receiver's owning project to its edited model,
					id est the otheInfos when non atomic and the mutableInfos otherwise.
	@param			an array of keys.
	@result			YES if the replacement is different from the replaced object.
	@availability	iTM2.
	@copyright		2007 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (BOOL)restoreCustomForKeys:(NSArray *)keys;

@end

@interface iTM2Inspector(Infos)
- (NSString *)infosKeyPathPrefix;
- (id)infosController;
@end

/*!
	@category		NSObject(Infos)
	@abstract		This is a convenient API for the iTM2InfosController.
	@discussion		Use this API, the infos controller should be considered private.
	@availability	iTM2.
	@copyright		2007 jlaurens AT users DOT sourceforge DOT net and others.
*/
@interface NSObject(Infos)

/*! 
    @method     infosController
    @abstract   Abstract forthcoming.
    @discussion Discussion forthcoming.
    @param      None
    @result     an infos controller
*/
- (id)infosController;

/*! 
    @method     setInfosController:
    @abstract   Abstract forthcoming.
    @discussion Discussion forthcoming.
    @param      An infos controller
    @result     None
*/
- (void)setInfosController:(id)infosController;


/*! 
    @method			metaInfos
    @abstract		The meta infos.
    @discussion		The default implementation raises an exception. Subclassers must provide the model.
    @param			None
    @result			an iTM2InfoWrapper instance
	@availability	iTM2.
	@copyright		2007 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (id)metaInfos;
- (id)metaInfoForKeyPaths:(NSString *)first,...;
- (BOOL)takeMetaInfo:(id)info forKeyPaths:(NSString *)first,...;

- (id)inheritedInfoForKeyPaths:(NSString *)first,...;
- (id)infoForKeyPaths:(NSString *)first,...;
- (BOOL)takeInfo:(id)info forKeyPaths:(NSString *)first,...;
- (BOOL)isInfoEditedForKeyPaths:(NSString *)first,...;

- (id)localInfoForKeyPaths:(NSString *)first,...;
- (id)editInfoForKeyPaths:(NSString *)first,...;

- (void)toggleInfoForKeyPaths:(NSString *)first,...;

- (id)customInfoForKeyPaths:(NSString *)first,...;
- (void)backupCustomForKeyPaths:(NSString *)first,...;
- (BOOL)restoreCustomForKeyPaths:(NSString *)first,...;

/*!
	@method			save
	@abstract		Save the changes.
	@discussion		Description forthcoming.
	@param			a non void list of key paths
	@result			a flag indicating whether the new value is different from the old one
	@availability	iTM2.
	@copyright		2007 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (BOOL)saveChangesForKeyPaths:(NSString *)first,...;
- (BOOL)revertChangesForKeyPaths:(NSString *)first,...;

@end
