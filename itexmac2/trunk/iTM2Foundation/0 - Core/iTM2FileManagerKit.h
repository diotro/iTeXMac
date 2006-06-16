/*
//
//  @version Subversion: $Id$ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Sun June 01 2003.
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

#import <Foundation/Foundation.h>

extern NSString * const iTM2PathComponentsSeparator;

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  NSFileManager(iTeXMac2)

@interface NSFileManager(iTeXMac2)

/*! 
	@method		createDeepDirectoryAtPath:attributes:error:
	@abstract	creates a directory and the whole hierarchy if necessary. Returns YES if the file exists
	@discussion The given path must be non void. If it does not start with a / character, it will be appended to the current directoy path.
				If the answer is NO and there was an error, an explanation is returned.
				If no error is returned, the specified directory do exist.
				In the user info dictionary of the returned error, youwill find the faulty path with the key @"iTM2DirectoryPath"
	@param		path is the path where the directory should be created, if the path is not absolute (ie if it does not start with a /, it is appended to the current directory.
	@param		attributes are the attributes of all the created directories.
	@param		errorPtr points to an NSError place holder.
	@result		yorn.
*/
-(BOOL)createDeepDirectoryAtPath:(NSString *)path attributes:(NSDictionary *)attributes error:(NSError**)errorPtr;

/*! 
	@method		createDeepFileAtPath:contents:attributes:
	@abstract	creates a file and the whole hierarchy if necessary. Returns YES if the file is created, No if the file can't be created or is already existing.
	@discussion	Description Forthcoming.
	@param		path is the path where the directory should be created, if the path is not absolute (ie if it does not start with a /, it is appended to the current directory.
	@param		contents is the file contents.
	@param		attributes are the attributes of all the created directories.
	@result		yorn.
*/
-(BOOL)createDeepFileAtPath:(NSString *)path contents:(NSData *)data attributes:(NSDictionary *)attributes;

/*!
	@method		createDeepSymbolicLinkAtPath:pathContent:
	@abstract	creates a link and the whole hierarchy if necessary. Returns YES if the link is created, no otherwise. If there exists something at path, No is returned.
	@discussion Description Forthcoming.
	@param		path is the path where the directory should be created, if the path is not absolute (ie if it does not start with a /, it is appended to the current directory.
	@param		otherpath is the target.
	@result		yorn.
*/
-(BOOL)createDeepSymbolicLinkAtPath:(NSString *)path pathContent:(NSString *)otherpath;

/*!
	@method			makeFileWritableAtPath:recursive:
	@abstract		Abstract forthcoming.
	@discussion		Discussion forthcoming.
	@param			fileName
	@param			yorn.
	@result			None.
	@availability	iTM2.
	@copyright		2005 jlaurens AT users DOT sourceforge DOT net and others.
*/
-(void)makeFileWritableAtPath:(NSString *)fileName recursive:(BOOL)yorn;

/*!
	@method			prettyNameAtPath:
	@abstract		Abstract forthcoming.
	@discussion		The display name at path traverses links. This one does not.
	@param			fileName
	@result			Non traversing link display name.
	@availability	iTM2.
	@copyright		2005 jlaurens AT users DOT sourceforge DOT net and others.
*/
-(NSString *)prettyNameAtPath:(NSString *)path;

/*!
	@method			hideExtensionAtPath:
	@abstract		Abstract forthcoming.
	@discussion		The display name at path traverses links. This one does not.
	@param			path
	@result			yorn.
	@availability	iTM2.
	@copyright		2006 jlaurens AT users DOT sourceforge DOT net and others.
*/
-(BOOL)hideExtensionAtPath:(NSString *)path;

/*!
	@method			showExtensionAtPath:
	@abstract		Abstract forthcoming.
	@discussion		The display name at path traverses links. This one does not.
	@param			path
	@result			yorn.
	@availability	iTM2.
	@copyright		2006 jlaurens AT users DOT sourceforge DOT net and others.
*/
-(BOOL)showExtensionAtPath:(NSString *)path;

@end

/*!
	@class			NSFileManager(iTM2ExtendedAttributes)
	@abstract		Extended file attributes class category.
	@discussion		Accessors for extended file attributes.
					Those metadata are stored either in resource forks or extended attributes as introduced in Tiger.
	@availability	iTM2.
	@copyright		2005 jlaurens AT users DOT sourceforge DOT net and others.
*/

extern NSString * const iTM2ExtendedAttributesErrorDomain;
enum 
{
	kiTM2ExtendedAttributesNoFileAtPathError = 1,
	kiTM2ExtendedAttributesBadNameError = 2,
	kiTM2ExtendedAttributesResourceManagerError = 3,
	kiTM2ExtendedAttributesOtherError = -1
};

@interface NSFileManager(iTM2ExtendedAttributes)

/*!
	@method		extendedFileAttributesInSpace:atPath:traverseLink:error:
	@abstract	Retrieve the extended attributes.
	@discussion This uses the resource fork. The resource fork being arranged with resource index, will limit the resource identifier.
				We do not rely on resource index but on resource name. The resource name is expected to be the key of the dictionary.
	@param		space is either a space name or a number wrapping the resource identifier.
	@param		path is the location where things should be stored.
	@param		outError is the reference of an NSError object. Will contain error description on return, if any.
	@result		an NSDictionary. All the keys are NSString's (less than 255 characters in UTF8 representation)
				and the corresponding values are NSData objects. 
*/
-(NSDictionary *)extendedFileAttributesInSpace:(id)space atPath:(NSString *)path error:(NSError **)outError;

/*!
	@method		extendedFileAttribute:inSpace:atPath:error:
	@abstract	Retrieve the named extended attribute.
	@discussion This uses the resource fork.
	@param		attributeName is the attribute name.
	@param		space is either a space name or a number wrapping the resource identifier.
	@param		path is the location where things should be stored.
	@param		outError is the reference of an NSError object. Will contain error description on return, if any.
	@result		an NSData objects. 
*/
-(NSData *)extendedFileAttribute:(NSString *)attributeName inSpace:(id)space atPath:(NSString *)path error:(NSError **)outError;

/*!
	@method		removeExtendedFileAttribute:inSpace:atPath:traverseLink:error:
	@abstract	Remove the named extended attribute.
	@discussion This uses the resource fork.
	@param		attributeName is the attribute name.
	@param		space is either a space name or a number wrapping the resource identifier.
	@param		path is the location where things should be stored.
	@param		outError is the reference of an NSError object. Will contain error description on return, if any.
	@result		a flag indicating success or failure.
*/
-(BOOL)removeExtendedFileAttribute:(NSString *)attributeName inSpace:(id)space atPath:(NSString *)path error:(NSError **)outError;

/*!
	@method		addExtendedFileAttribute:value:inSpace:atPath:error:
	@abstract	Retrieve the named extended attribute.
	@discussion This uses the resource fork or the xattrs.
	@param		attributeName is the attribute name.
	@param		value is the new data.
	@param		space is either a space name or a number wrapping the resource identifier.
	@param		path is the location where things should be stored.
	@param		outError is the reference of an NSError object. Will contain error description on return, if any.
	@result		a flag indicating success or failure.
*/
-(BOOL)addExtendedFileAttribute:(NSString *)attributeName value:(NSData *)D inSpace:(id)space atPath:(NSString *)path error:(NSError **)outError;

/*!
	@method		changeExtendedFileAttributes:inSpace:atPath:error:
	@abstract	Write the new attributes.
	@discussion This uses the resource fork.
	@param		attributes are gathered in a dictionary which keys are NSString identifiers and values are NSData objects.
	@param		space is either a space name or a number wrapping the resource identifier.
	@param		path is the location where things should be stored.
	@param		outError is the reference of an NSError object. Will contain error description on return, if any.
	@result		a flag indicating success or failure. 
*/
-(BOOL)changeExtendedFileAttributes:(NSDictionary *)attributes inSpace:(id)space atPath:(NSString *)path error:(NSError **)outError;

@end
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= NSFileManager(iTeXMac2)

@interface NSFileManager(iTM2Alias)

/*!
	@method			fileExistsAtPath:isAlias:error:
	@abstract		Abstract forthcoming.
	@discussion		Whether there is a finder alias at the given path.
	@param			fileName
	@param			a pointer to a BOOL that will hold the result
	@param			a pointer to an error object.
	@result			A flag.
	@availability	iTM2.
	@copyright		2005 jlaurens AT users DOT sourceforge DOT net and others.
*/
-(BOOL)fileExistsAtPath:(NSString *)path isAlias:(BOOL *)isAlias error:(NSError**)errorPtr;

@end

@interface NSData(iTM2Alias)

/*!
	@method		pathByResolvingDataAliasRelativeTo:error:
	@abstract	Resolved path from the receiver as data alias.
	@discussion Discussion forthcoming.
	@param		base is the base path, can be nil.
	@param		error is an NSError pointer, can be nil.
	@result		a path or nil in case of error. 
*/
-(NSString*)pathByResolvingDataAliasRelativeTo:(NSString *)base error:(NSError **)error;
-(BOOL)writeAsFinderAliasToURL:(NSURL *)url options:(unsigned)writeOptionsMask error:(NSError **)errorPtr;
+(NSData *)aliasDataWithContentsOfURL:(NSURL *)absoluteURL error:(NSError **)error;

@end

@interface NSString(iTM2AliasKit)

/*!
	@method		dataAliasRelativeTo:error:
	@abstract	Wraps the receiver in a data alias object.
	@discussion Discussion forthcoming.
	@param		base is the base path, can be nil.
	@param		error is an NSError pointer, can be nil.
	@result		a data object containing a dereferenced AliasHandle. 
*/
-(NSData*)dataAliasRelativeTo:(NSString *)base error:(NSError **)error;

@end
