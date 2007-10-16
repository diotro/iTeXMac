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

extern NSString * const TWSKeyedPropertiesKey;
extern NSString * const TWSKeyedFilesKey;

@interface iTM2InfoWrapper: iTM2Object

/*!
	@method			readFromURL:options:error:
	@abstract		Abstract forthcoming.
	@discussion		Discussion forthcoming.
	@param			None
	@param			options: standard flags (none is supported)
	@param			outErrorPtr a pointer to a possibly returned error
	@result			yorn
	@availability	iTM2.
	@copyright		2007 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (BOOL)readFromURL:(NSURL *)absoluteURL options:(unsigned)readOptionsMask error:(NSError **)outErrorPtr;

/*!
	@method			writeToURL:options:error:
	@abstract		Abstract forthcoming.
	@discussion		Discussion forthcoming.
	@param			None
	@param			options: standard flags (only atomic write is supported)
	@param			outErrorPtr a pointer to a possibly returned error
	@result			yorn
	@availability	iTM2.
	@copyright		2007 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (BOOL)writeToURL:(NSURL *)absoluteURL options:(unsigned)flags error:(NSError **)outErrorPtr;

/*!
	@method			model
	@abstract		The model of the receiver.
	@discussion		In fact the model is divided into 2 components: the base read only part and the mutable part.
					<code>-baseModel</code> is the read only part whereas <code>-model</code> is the mutable part.
					The read only part is used to implement inheritancy.
					The base model is set by the owner of the receiver at creation time, and in general the model is read from disc.
					Querying the model is made through <code>-modelValueForKeyPath:</code>,
					it returns the <code>-valueForKeyPath:</code> provided by the model, if not nil, or by the base model.
					Editiong the model is made though <code>-takeModelValue:forKeyPath:</code>, only the mutable part is modified.
	@param			None
	@result			a mutable property list dictionary.
	@availability	iTM2.
	@copyright		2007 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (id)model;

#define myMODEL [self model]

/*!
	@method			setModel:
	@abstract		Abstract forthcoming.
	@discussion		This method makes a deep copy of the receiver, just in case a mutable object was there.
	@param			model is expected to be a property list dictionary
	@result			None.
	@availability	iTM2.
	@copyright		2007 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (void)setModel:(id)model;

#define myBASEMODEL [self baseModel]

/*!
	@method			baseModel
	@abstract		The base model.
	@discussion		See <code>-model</code>.
	@param			None
	@result			a dictionary.
	@availability	iTM2.
	@copyright		2007 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (id)baseModel;

/*!
	@method			setBaseModel:
	@abstract		Set the base model.
	@discussion		See <code>-model</code>.
	@param			model is expected to be a property list dictionary
	@result			None.
	@availability	iTM2.
	@copyright		2007 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (void)setBaseModel:(id)model;

/*!
	@method			modelValueForKeyPath:
	@abstract		The designated model access.
	@discussion		See <code>-model</code>.
	@param			a key path: dot separated list of strings, this is weakier than cocoa concept of key path.
	@result			an object from a property list.
	@availability	iTM2.
	@copyright		2007 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (id)modelValueForKeyPath:(NSString *)path;

/*!
	@method			takeModelValue:forKeyPath:
	@abstract		The designated model editor.
	@discussion		See <code>-model</code>. If intermediate objects do not exist, they are created as mutable dictionaries.
	@param			a value
	@param			a key path
	@result			an object from a property list.
	@availability	iTM2.
	@copyright		2007 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (id)takeModelValue:(id)value forKeyPath:(NSString *)path;

@end

@interface iTM2ProjectInfoWrapper: iTM2InfoWrapper

/*! 
    @method			sourceDirectory
    @abstract		The source directory where the files are stored.
    @discussion		The path will be used by a project, relative to its enclosing folder.
    @param			None
    @result			a relative path
	@availability	iTM2.
	@copyright		2007 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (NSString *)sourceDirectory;

/*! 
    @method			setSourceDirectory:
    @abstract		Set the she source directory where the files are stored.
    @discussion		The path will be used by a project, relative to its enclosing folder.
    @param			a relative path
    @result			None
	@availability	iTM2.
	@copyright		2007 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (void)setSourceDirectory:(NSString *)path;

/*! 
    @method			allKeys
    @abstract		All the keys actually in use.
    @discussion		Description forthcoming.
    @param			None
    @result			an NSArray
	@availability	iTM2.
	@copyright		2007 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (NSArray *)allKeys;

/*! 
    @method			keyedFileNames
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
- (id)keyedFileNames;

/*! 
    @method			nameForFileKey:
    @abstract		The file name for the given key.
    @discussion		@"" is returned if the key is not covered by the allKeys list.
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
    @method			keyedProperties
    @abstract		The properties dictionary.
    @discussion		Discussion forthcoming.
					This is preferrably for private use.
					Direct setters/getters are given.
					A default void dictionary is given.
    @param			None
    @result			A dictionary
	@availability	iTM2.
	@copyright		2007 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (id)keyedProperties;

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
- (void)takeProperties:(id)properties forFileKey:(NSString *)key;

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

@interface iTM2FrontendInfoWrapper: iTM2InfoWrapper

@end
