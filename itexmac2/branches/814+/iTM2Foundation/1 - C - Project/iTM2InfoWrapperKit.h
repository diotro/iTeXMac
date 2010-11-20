/*
//
//  @version Subversion: $Id: iTM2InfoWrapperKit.h 574 2007-10-08 23:21:41Z jlaurens $ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Tue Sep 11 2001.
//  Copyright © 2006-2010 Laurens'Tribune. All rights reserved.
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

#import "iTM2ProjectDocumentKit.h"
#import "iTM2ProjectControllerKit.h"

extern NSString * const TWSProjectKey;
extern NSString * const TWSContentsKey;
extern NSString * const TWSFactoryKey;
extern NSString * const TWSDotKey;
extern NSString * const TWSToolsKey;
extern NSString * const TWSTargetsKey;
extern NSString * const TWSKeyedFilesKey;
extern NSString * const TWSKeyedPropertiesKey;

extern NSString * const iTM2ParentKey;
extern NSString * const iTM2FinderAliasesKey;
extern NSString * const iTM2SoftLinksKey;

extern NSString * const iTM2ProjectLastKeyKey;
extern NSString * const iTM2ProjectFrontDocumentKey;

extern NSString * const iTM2ProjectPlistPathExtension;
extern NSString * const iTM2ProjectInfoComponent;
extern NSString * const iTM2ProjectInfoMetaComponent;
extern NSString * const iTM2ProjectCustomInfoComponent;


extern NSString * const iTM2ProjectInfoMainType;

@interface NSMethodSignature(iTeXMac2)
+(id)signatureWithObjCTypes:(const char *)types;// undocumented method
@end

/*!
	@class			iTM2InfoWrapper
	@abstract		This is a wrapper over a property list with convenient accessors.
	@discussion		Discussion forthcoming.
	@availability	iTM2.1
	@copyright		2008 jlaurens AT users DOT sourceforge DOT net and others.
*/

@interface iTM2InfoWrapper: iTM2Object
{
@private
    id model4iTM3;
    id modelKeyPath4iTM3;
    NSInteger changeCount4iTM3;
}

/*!
	@method			infoForKeys:
	@abstract		The designated local model accessor unless a more specific one exists.
	@discussion		Discussion forthcoming.
	@param			an array of key, for a plist dictionary entry.
	@result			an object from a property list.
	@availability	iTM2.1
	@copyright		2008 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (id)infoForKeys:(NSArray *)keys;

/*!
	@method			infoForKeyPaths:
	@abstract		The designated local model accessor unless a more specific one exists.
	@discussion		Convenient accessor: usage <code>[self infoForKeyPaths:@"first",@"second",nil]</code>.
					It converts the list of keys into an array, then returns <code>[self infoForKeys:arrayOfKeys]</code>
	@param			a list of key paths
	@result			an object from a property list.
	@availability	iTM2.1
	@copyright		2008 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (id)infoForKeyPaths:(NSString *)first,...;

/*!
	@method			setInfo:forKeys:
	@abstract		The designated model editor.
	@discussion		See <code>-model</code>. If intermediate objects do not exist, they are created as mutable dictionaries.
	@param			a value
	@param			an array of keys.
	@result			YES if the replacement is different from the replaced object.
	@availability	iTM2.1
	@copyright		2008 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (BOOL)setInfo:(id)info forKeys:(NSArray *)keys;

/*!
	@method			setInfo:forKeyPaths:
	@abstract		The designated model editor.
	@discussion		See <code>-model</code>. If intermediate objects do not exist, they are created as mutable dictionaries.
	@param			a value
	@param			a variable length list of paths.
	@result			YES if the replacement is different from the replaced object.
	@availability	iTM2.1
	@copyright		2008 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (BOOL)setInfo:(id)info forKeyPaths:(NSString *)first,...;

/*!
	@method			updateChangeCount:
	@abstract		Abstract forthcoming.
	@discussion		Description forthcoming.
	@param			Like NSDocument's eponym method
	@result			None.
	@availability	iTM2.1
	@copyright		2008 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (void)updateChangeCount:(NSDocumentChangeType)change;

/*!
	@method			initWithData:error:
	@abstract		init is the designated initializer.
	@discussion		Forthcoming.
	@param			aData
	@param			outErrorPtr
	@result			an info wrapper object.
	@availability	iTM3
	@copyright		2010 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (id)initWithData:(NSData *)aData error:(NSError **)outErrorPtr;

/*!
	@method			dataWithFormat:options:error:
	@abstract		The serialized model of the receiver.
	@discussion		Forthcoming.
	@param			format
	@param			opt
	@param			outErrorPtr
	@result			a data object.
	@availability	iTM3
	@copyright		2010 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (NSData *) dataWithFormat:(NSPropertyListFormat)format options:(NSPropertyListWriteOptions)opt error:(NSError **)outErrorPtr;

@end

/*
    @class			iTM2MainInfoWrapper
    @abstract		The main info wrapper object.
    @discussion		Every project has a main info wrapper. This is where file names are recorded.
					This object nor its contents cannot be inherited, contrary to the other kind of info
					managed by the infos controller.
	@availability	iTM2.11
	@copyright		2008 jlaurens AT users DOT sourceforge DOT net and others.
*/
@interface iTM2MainInfoWrapper:iTM2InfoWrapper
{
@private
    id projectURL4iTM3;
}
/*! 
    @method			initWithProjectURL:error:
    @abstract		Designated initializer.
    @discussion		Discussion forthcoming.
    @param			projectURL
    @param			outErrorPtr
    @result			an info wrapper
	@availability	iTM2.1
	@copyright		2008 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (id)initWithProjectURL:(NSURL *)projectURL error:(NSError **)outErrorPtr;

/*! 
    @method			projectURL
	@abstract		The owning project URL.
    @discussion		Discussion forthcoming.
    @param			None
    @result			An NSURL instance
	@availability	iTM2.1
	@copyright		2010 jlaurens AT users DOT sourceforge DOT net and others.
*/
@property (readonly, retain) NSURL * projectURL;

/*! 
    @method			replaceProjectURL:error:
    @abstract		Set the owning project URL.
    @discussion		The project must update this each time its own file URL changes.
    @param			url
	@param			errorRef
    @result			None
	@availability	iTM2.1
	@copyright		2008 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (void)replaceProjectURL:(NSURL *)url error:(NSError **)errorRef;

/*! 
    @method			fileKeys
    @abstract		The file keys.
    @discussion		Discussion forthcoming.
    @param			None
    @result			An array
	@availability	iTM2.1
	@copyright		2008 jlaurens AT users DOT sourceforge DOT net and others.
*/
@property (readonly,retain) NSArray * fileKeys;

- (NSString *)nameForFileKey:(NSString *)key;
- (NSArray *)namesForFileKeys:(NSArray *)keys;
- (NSString *)fileKeyForName:(NSString *)name;
- (BOOL)setName:(NSString *)name forFileKey:(NSString *)key;

/*! 
    @method			fileKeyForURL:
    @abstract		The file key for the given URL.
    @discussion		Discussion forthcoming.
    @param			a name
    @result			an NSString
	@availability	iTM2.1
	@copyright		2008 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (NSString *)fileKeyForURL:(NSURL *)url;

/*! 
    @method			URLForFileKey:
    @abstract		The URL for the given key.
    @discussion		nil is returned if the key is not covered by the fileKeys list,
					or if key is reserved.
					
					The projectURL parameter is the URL of the folder enclosing the project
					the receiver belongs to.
					
					The return URL is either absolute or relative.
					When it is relative, its base URL is the URL of the source subdirectory
					of the given parameter projectURL.
					
					This method is the central one to retrieve an URL given a key.
					It has the lowest level.
					Given a key, a project will return a corresponding URL by asking the shared project controller,
					and the shared project controller will in turn ask a main infos wrapper.
					The only exception concerns cached project related URLs for the contents, factory and parent.
    @param			a key
    @result			an NSURL
	@availability	iTM2.1
	@copyright		2008 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (NSURL *)URLForFileKey:(NSString *)key;

/*! 
    @method			setURL:forFileKey:
    @abstract		Set the file name for the given key and base URL.
    @discussion		Records the given URL.
					
					If the key is TWSProjectKey, nothing is performed, projectURL is returned as is.
					If the key is TWSFactoryKey, the path relative to project URL is recorded.
					This path must not go out the project URL.
					If the key is TWSContentsKey, the path relative to the project directory URL is recorded. 
					This path must not go out the project directory URL.
					
					If the given URL is nil, it means that the receiver will forget the given key.
					It makes sense only for file keys.
					
					If key is not one of the file keys of the receiver, it will be created provided the given file URL is not void.
					
					If the given file URL can be expressed relative to the contents of the project, then the relative part is recorded.
					This relative part must not contain any "..".
					
	@param			a file URL
	@param			a key
    @result			nil if the change failed or the no file URL was given
					otherwise an NSURL instance equivalent to the given one,
					but conforming to the project conventions.
	@availability	iTM2.1
	@copyright		2008 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (NSURL *)setURL:(NSURL *)url forFileKey:(NSString *)key;

/*! 
    @method			propertiesForFileKey:
    @abstract		The properties dictionary for the given key.
    @discussion		Discussion forthcoming.
    @param			The key
    @result			A dictionary
	@availability	iTM2.1
	@copyright		2008 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (id)propertiesForFileKey:(NSString *)key;

/*! 
    @method			setProperties:forFileKey:
    @abstract		Set the properties dictionary for the given key.
    @discussion		Discussion forthcoming.
    @param			The key
    @param			A dictionary
    @result			None
	@availability	iTM2.1
	@copyright		2008 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (BOOL)setProperties:(id)properties forFileKey:(NSString *)key;

/*! 
    @method			setPropertyValue:forKey:fileKey:
    @abstract		Set the properties dictionary for the given key.
    @discussion		Discussion forthcoming.
    @param			The property
    @param			The key
    @param			The fileKey
    @param			yorn
    @result			None
	@availability	iTM2.1
	@copyright		2008 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (BOOL)setPropertyValue:(id)property forKey:(NSString *)key fileKey:(NSString *)fileKey;

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
					See the -takeContext4iTM3Value:forKey:fileKey: discussion.
    @param			fileName is a full path name
    @result			a unique key identifier
	@availability	iTM2.1
	@copyright		2008 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (NSString *)nextAvailableKey;

@end

/*!
	@category		iTM2ProjectDocument(Infos)
	@abstract		Each project has one infos controller and a main infos wrapper from which it retrieves all the relevant information.
	@discussion		Discussion forthcoming.
	@availability	iTM2.1
	@copyright		2008 jlaurens AT users DOT sourceforge DOT net and others.
*/
@interface iTM2ProjectDocument(Infos)

/*!
	@method			mainInfos4iTM3
	@abstract		The main Info wrapper, containing the various file keys and properties.
	@discussion		The main infos contains something the project won't inherit from ancestors.
					No inheritance here yet.
	@param			None
	@result			an iTM2MainInfoWrapper instance
	@availability	iTM2.1
	@copyright		2008 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (id)mainInfos4iTM3;

/*! 
    @method			infosController4iTM3
    @abstract		The infos controller.
    @discussion		This controller controls all the infos of the receiver, except the main one.
    @param			None
    @result			an iTM2InfosController instance
	@availability	iTM2.1
	@copyright		2008 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (id)infosController4iTM3;


/*! 
    @method			infoCompleteWriteToURL4iTM3:ofType:error:
    @abstract		Where the various infos are written to disc.
    @discussion		This method is automatically called when saving.
					You are not expected to use this method directly.
					This API is presented just for subclassers.
    @param			absoluteURL
    @param			fileType
    @param			outErrorPtr
    @result			YES or NO, whether or not something was reaaly saved.
	@availability	iTM2.1
	@copyright		2008 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (BOOL)infoCompleteWriteToURL4iTM3:(NSURL *)absoluteURL ofType:(NSString *)fileType error:(NSError **)outErrorPtr;

@end

/*!
	@class			iTM2InfosController
	@abstract		This is a controller of the iTM2InfoWrapper's.
	@discussion		We already said that the main info can't be inherited.
					This is not exposed.
	@availability	iTM2.
	@copyright		2007 jlaurens AT users DOT sourceforge DOT net and others.
*/

@interface iTM2InfosController: NSObject
{
@private
	__weak id iVarProject4iTM3;
    id iVarPrefix4iTM3;
    BOOL iVarAtomic4iTM3;
}
@property (assign) __weak id project;

/*!
	@method			initWithProject:atomic:prefixWithKeyPaths:
	@abstract		Designated initializer.
	@discussion		The model is retrieved from the repository, with the given repository key paths.
					If the controller is atomic, its mutableProjectInfos is used to edit infos.
					In that case any modification is made on a copy and the original value is still available.
					If the controller is not atomic, each info edited is modified directly in the project's otheInfos.
	@param			project is the owner of the receiver 
	@param			yorn: YES to edit in the mutableInfo part and allow some global undo management, NO to edit directly in the info part.
	@param			prefix is prepended to any key
	@result			an iTM2InfoController instance.
	@availability	iTM2.
	@copyright		2007 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (id)initWithProject:(id)project atomic:(BOOL)yorn prefixWithKeyPaths:(NSString *)prefix,...;

/*!
	@method			inheritedInfo4iTM3ForKeys:
	@abstract		Inherited info for the given keys.
	@discussion		Inherited infos are retrieved from the infos controller of the base project of the owning project.
	@param			an array of keys.
	@result			an object from a property list.
	@availability	iTM2.
	@copyright		2007 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (id)inheritedInfo4iTM3ForKeys:(NSArray *)keys;

/*!
	@method			isInfoInherited4iTM3ForKeys:
	@abstract		Inherited info for the given keys.
	@discussion		Inherited infos are retrieved from the infos controller of the base project of the owning project.
	@param			an array of keys.
	@result			yron.
	@availability	iTM2.
	@copyright		2010 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (BOOL)isInfoInherited4iTM3ForKeys:(NSArray *)keys;

/*!
	@method			infoForKeys:
	@abstract		The designated local model accessor unless a more specific one exists.
	@discussion		If the info is not retrieved from the owning project, the inherited info will be returned.
					If the receiver was created with a YES atomic flag, the info is first taken from the mutableProjectInfos dictionary of the owner.
					Otherwise it is taken from the otherInfos4iTM3 dictionary of the owner.
	@param			an array of keys.
	@result			an object from a property list.
	@availability	iTM2.
	@copyright		2007 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (id)infoForKeys:(NSArray *)keys;
- (id)infoInherited4iTM3:(BOOL)yorn forKeys:(NSArray *)keys;

/*!
	@method			setInfo:forKeys:
	@abstract		The designated "immutable" model editor.
	@discussion		If the receiver was created with a YES atomic flag, the mutableProjectInfos dictionary of the owner will take the new info for the given keys.
					Otherwise it is the otherInfos4iTM3 dictionary of the owner which will take the modification.
	@param			a value
	@param			an array of keys.
	@result			YES if the replacement is different from the replaced object.
	@availability	iTM2.
	@copyright		2007 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (BOOL)setInfo:(id)info forKeys:(NSArray *)keys;

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
	@discussion		It returns the contents of the mutableProjectInfos dictionary of the owning project,
					if the receiver was created with a YES atomic flag.
					It returns the contents of the otherInfos4iTM3 dictionary of the receiver otherwise.
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
					otherwise all the edited values migrate from the mutableProjectInfos to the otherInfos4iTM3 of the receiver's owning project.
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
					otherwise all the unedited values migrate from the otherInfos4iTM3 to the mutableProjectInfos of the receiver's owning project.
	@param			an array of keys.
	@result			YES if the replacement is different from the replaced object.
	@availability	iTM2.
	@copyright		2007 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (BOOL)revertChangesForKeys:(NSArray *)keys;

/*!
	@method			customInfo4iTM3ForKeys:
	@abstract		The designated "custom" model getter.
	@discussion		Retrieves the information from the customInfos4iTM3 of the owning project, for the given keys.
					The customInfos4iTM3 is the repository of changes not yet edited.
	@param			an array of keys.
	@result			an object from a property list.
	@availability	iTM2.
	@copyright		2007 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (id)customInfo4iTM3ForKeys:(NSArray *)keys;

/*!
	@method			backupCustomForKeys:
	@abstract		Make a copy of the edited values as custom.
	@discussion		All the edited values migrate to the customInfos4iTM3 of the receiver's owning project.
	@param			an array of keys.
	@result			YES if the replacement is different from the replaced object.
	@availability	iTM2.
	@copyright		2007 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (BOOL)backupCustomForKeys:(NSArray *)keys;

/*!
	@method			restoreCustomForKeys:
	@abstract		Make a copy of the custom values for the given keys, for editing.
	@discussion		All the values migrate from the customInfos4iTM3 of the receiver's owning project to its edited model,
					id est the otheInfos when non atomic and the mutableProjectInfos otherwise.
	@param			an array of keys.
	@result			YES if the replacement is different from the replaced object.
	@availability	iTM2.
	@copyright		2007 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (BOOL)restoreCustomForKeys:(NSArray *)keys;

@end

/*!
	@category		NSObject(Infos)
	@abstract		This is a convenient API to manage the infos.
	@discussion		Using this API activates a hidden infos controller that properly manages edition and inheritancy.
	@availability	iTM2.1
	@copyright		2008 jlaurens AT users DOT sourceforge DOT net and others.
*/
@interface NSObject(Infos)

/*!
	@method			infosController4iTM3
	@abstract		The infos controller.
	@discussion		Discussion forthcoming.
	@param			None
	@result			The infos controller
	@availability	iTM2.1
	@copyright		2008 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (id)infosController4iTM3;

/*!
	@method			setInfosController4iTM3:
	@abstract		Set the infos controller to the given object.
	@discussion		This is manly for frontend private use.
					Not inherited.
	@param			The new infos controller
	@result			None
	@availability	iTM2.1
	@copyright		2008 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (void)setInfosController4iTM3:(id)controller;

/*!
	@method			metaInfo4iTM3ForKeyPaths:
	@abstract		The meta information for the given key paths.
	@discussion		This is manly for frontend private use.
					Not inherited.
	@param			a non void list of key paths
	@result			a flag indicating whether the new value is different from the old one
	@availability	iTM2.1
	@copyright		2008 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (id)metaInfo4iTM3ForKeyPaths:(NSString *)first,...;
- (BOOL)setMetaInfo4iTM3:(id)info forKeyPaths:(NSString *)first,...;

/*!
	@method			inheritedInfo4iTM3ForKeyPaths:
	@abstract		The inherited information for the given key paths.
	@discussion		This is another kind of inheritancy concerning data.
	@param			a non void list of key paths
	@result			some property list object
	@availability	iTM2.1
	@copyright		2008 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (id)inheritedInfo4iTM3ForKeyPaths:(NSString *)first,...;

/*!
	@method			inheritedInfo4iTM3ForKeyPaths:
	@abstract		The inherited information for the given key paths.
	@discussion		This is another kind of inheritancy concerning data.
	@param			a non void list of key paths
	@result			some property list object
	@availability	iTM2.1
	@copyright		2008 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (BOOL)isInfoInherited4iTM3ForKeyPaths:(NSString *)first,...;

/*!
	@method			info4iTM3ForKeyPaths:
	@abstract		The information for the given key paths.
	@discussion		This is either a local information or an inherited one if the local information is null.
	@param			a non void list of key paths
	@result			an object suitable for a property lits
	@availability	iTM2.1
	@copyright		2008 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (id)info4iTM3ForKeyPaths:(NSString *)first,...;
- (id)infoInherited4iTM3:(BOOL)yorn forKeyPaths:(NSString *)first,...;
/*!
	@method			setInfo4TM3:forKeyPaths:
	@abstract		Set the information for the given key paths.
	@discussion		Setting this info to nil means "remove the local info"
					which in turns mean "use the inherited info".
					In order to really set the info to nil and override the inherited info
					set the info to [NSNull null].
	@param			a non void list of key paths
	@result			a flag indicating whether the new value is different from the old one
	@availability	iTM2.1
	@copyright		2008 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (BOOL)setInfo4TM3:(id)info forKeyPaths:(NSString *)first,...;
/*!
	@method			isInfo4iTM3EditedForKeyPaths:
	@abstract		Whether the information is edited for the given key paths.
	@discussion		.
	@param			a non void list of key paths
	@result			a flag indicating whether the info is edited
	@availability	iTM2.1
	@copyright		2008 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (BOOL)isInfo4iTM3EditedForKeyPaths:(NSString *)first,...;

/*!
	@method			saveChanges4iTM3ForKeyPaths:
	@abstract		Save the changes.
	@discussion		Description forthcoming.
	@param			a non void list of key paths
	@result			a flag indicating whether the new value is different from the old one
	@availability	iTM2.1
	@copyright		2008 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (BOOL)saveChanges4iTM3ForKeyPaths:(NSString *)first,...;

/*!
	@method			revertChanges4iTM3ForKeyPaths:
	@abstract		Revert the changes.
	@discussion		Description forthcoming.
	@param			a non void list of key paths
	@result			a flag indicating whether the new value is different from the old one
	@availability	iTM2.1
	@copyright		2008 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (BOOL)revertChanges4iTM3ForKeyPaths:(NSString *)first,...;

/*!
	@method			localInfo4iTM3ForKeyPaths:
	@abstract		The information for the given key paths.
	@discussion		This is either a local information or an inherited one if the local information is null.
	@param			a non void list of key paths
	@result			an object suitable for a property list
	@availability	iTM2.1
	@copyright		2008 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (id)localInfo4iTM3ForKeyPaths:(NSString *)first,...;

- (id)editInfo4iTM3ForKeyPaths:(NSString *)first,...;

- (id)customInfo4iTM3ForKeyPaths:(NSString *)first,...;

/*!
	@method			toggleInfo4iTM3ForKeyPaths:
	@abstract		Toggle the information at the given path if it represents a bool.
	@discussion		It will cut out inheritancy if applied twice.
	@param			a non void list of key paths
	@result			a flag indicating whether the cahnge could take place.
	@availability	iTM2.1
	@copyright		2008 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (BOOL)toggleInfo4iTM3ForKeyPaths:(NSString *)first,...;

/*!
	@method			backupCustomInfo4iTM3ForKeyPaths:
	@abstract		Abstract forthcoming.
	@discussion		Discussion forthcoming.
	@param			a non void list of key paths
	@result			a flag indicating whether the cahnge could take place.
	@availability	iTM2.1
	@copyright		2008 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (BOOL)backupCustomInfo4iTM3ForKeyPaths:(NSString *)first,...;

/*!
	@method			restoreCustomInfo4iTM3ForKeyPaths:
	@abstract		Abstract forthcoming.
	@discussion		Discussion forthcoming.
	@param			a non void list of key paths
	@result			a flag indicating whether the cahnge could take place.
	@availability	iTM2.1
	@copyright		2008 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (BOOL)restoreCustomInfo4iTM3ForKeyPaths:(NSString *)first,...;

@end



@interface NSURL(iTM2InfoWrapper)

/*!
    @method			mainInfoURL4iTM3WithCreate:create:error:
    @abstract		The URL of the main Info property list storage.
    @discussion		The main info property list contains the base project name, the source directory name,
					all the file keys and their relative names.
					It also contains meta info like string encoding, line ending (but this should not be the case).
    @param			fileURL is an URL.
	@param			yorn is a flag.
	@param			outErrorPtr a pointer to an error.
    @result			An URL.
	@availability	iTM2.
	@copyright		2008 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (NSURL *)mainInfoURL4iTM3WithCreate:(BOOL)yorn error:(NSError **)outErrorPtr;

/*!
    @method			otherInfoURL4iTM3WithCreate:error:
    @abstract		The URL of the other Infos property list storage.
    @discussion		Discussion forthcoming.
    @param			fileURL is an URL.
	@param			yorn is a flag.
	@param			outErrorPtr a pointer to an error.
    @result			An URL.
	@availability	iTM2.
	@copyright		2008 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (NSURL *)otherInfoURL4iTM3WithCreate:(BOOL)yorn error:(NSError **)outErrorPtr;

/*!
    @method			metaInfoURL4iTM3WithCreate:error:
    @abstract		The URL of the meta Info property list storage.
    @discussion		Discussion forthcoming.
    @param			fileURL is an URL.
	@param			yorn is a flag.
	@param			outErrorPtr a pointer to an error.
    @result			An URL.
	@availability	iTM2.
	@copyright		2008 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (NSURL *)metaInfoURL4iTM3WithCreate:(BOOL)yorn error:(NSError **)outErrorPtr;

/*!
    @method			customInfoURL4iTM3WithCreate:error:
    @abstract		The URL of the custom Info property list storage.
    @discussion		Discussion forthcoming.
    @param			fileURL is an URL.
	@param			yorn is a flag.
	@param			outErrorPtr a pointer to an error.
    @result			An URL.
	@availability	iTM2.
	@copyright		2008 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (NSURL *)customInfoURL4iTM3WithCreate:(BOOL)yorn error:(NSError **)outErrorPtr;

@end
