/*
//
//  @version Subversion: $Id: iTM2FileManagerKit.h 799 2009-10-13 16:46:39Z jlaurens $ 
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

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  NSFileManager(iTeXMac2)

extern NSString * const iTM2SoftLinkExtension;

@interface NSFileManager(iTeXMac2)

/*!
	@method			iTM2_makeFileWritableAtPath:recursive:
	@abstract		Abstract forthcoming.
	@discussion		Discussion forthcoming.
	@param			fileName
	@param			yorn.
	@result			None.
	@availability	iTM2.
	@copyright		2005 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (void)iTM2_makeFileWritableAtPath:(NSString *)fileName recursive:(BOOL)yorn;

/*!
	@method			iTM2_prettyNameAtPath:
	@abstract		Abstract forthcoming.
	@discussion		The display name at path traverses links. This one does not.
	@param			fileName
	@result			Non traversing link display name.
	@availability	iTM2.
	@copyright		2005 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (NSString *)iTM2_prettyNameAtPath:(NSString *)path;

/*!
	@method			iTM2_setExtensionHidden:atPath:
	@abstract		Abstract forthcoming.
	@discussion		The display name at path traverses links. This one does not.
	@param			yorn.
	@param			path
	@result			yorn.
	@availability	iTM2.
	@copyright		2006 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (BOOL)iTM2_setExtensionHidden:(BOOL)yorn atPath:(NSString *)path;

/*!
	@method			iTM2_pushDirectory:
	@abstract		Abstract forthcoming.
	@discussion		Something like the pushd command.
	@param			path
	@result			yorn.
	@availability	iTM2.
	@copyright		2006 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (BOOL)iTM2_pushDirectory:(NSString *)path;

/*!
	@method			iTM2_popDirectory
	@abstract		Abstract forthcoming.
	@discussion		Something like the popd command.
	@param			None
	@result			yorn.
	@availability	iTM2.
	@copyright		2006 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (BOOL)iTM2_popDirectory;

/*!
	@method			iTM2_fileOrLinkExistsAtPath
	@abstract		Abstract forthcoming.
	@discussion		Discussion forthcoming.
	@param			path
	@result			yorn.
	@availability	iTM2.
	@copyright		2006 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (BOOL)iTM2_fileOrLinkExistsAtPath:(NSString *)path;

/*!
	@method			iTM2_linkExistsAtPath
	@abstract		Abstract forthcoming.
	@discussion		Discussion forthcoming.
	@param			path
	@result			yorn.
	@availability	iTM2.
	@copyright		2006 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (BOOL)iTM2_linkExistsAtPath:(NSString *)path;

/*!
	@method			iTM2_isVisibleFileAtPath:
	@abstract		Abstract forthcoming.
	@discussion		Discussion forthcoming.
	@param			path
	@result			yorn.
	@availability	iTM2.
	@copyright		2006 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (BOOL)iTM2_isVisibleFileAtPath:(NSString *)path;

/*!
	@method			iTM2_pathContentOfSoftLinkAtPath:
	@abstract		The path contents of the soft link at the given path.
	@discussion		Due to the fact that soft links are not properly handled by some USB drivers
					(they hang out while copying broken symbolic links)
					we use a personal concept of soft links.
					They are just natural text files containing the target path.
					A "soft_link" extension is added to path, you should not add it yourself.
					Use it like <code>-pathContentOfSymbolicLinkAtPath:</code>.
	@param			the source path, no need to add any specific extension
	@result			the path contents at the given path.
	@availability	iTM2.
	@copyright		2007 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (NSString *)iTM2_pathContentOfSoftLinkAtPath:(NSString *)path;

/*!
	@method			iTM2_createSoftLinkAtPath:pathContent:
	@abstract		Abstract forthcoming.
	@discussion		See <code>-iTM2_pathContentOfSoftLinkAtPath:</code>.
	@param			path is the source path
	@param			otherpath is the target path
	@result			yorn.
	@availability	iTM2.
	@copyright		2007 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (BOOL)iTM2_createSoftLinkAtPath:(NSString *)path pathContent:(NSString *)otherpath;

/*!
	@method			iTM2_isPrivateFileAtPath:
	@abstract		Abstract forthcoming.
	@discussion		Discussion forthcoming.
	@param			path
	@result			yorn.
	@availability	iTM2.
	@copyright		2007 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (BOOL)iTM2_isPrivateFileAtPath:(NSString *)path;

/*!
 @method	iTM2_attributesOfItemOrDestinationOfSymbolicLinkAtPath:atPath:error:
 @abstract	This is a workaround for the dto be deprecated fileAttributesAtPath:traverseLink:YES method..
 @discussion This uses the resource fork.
 @param		path.
 @param		error will contain an error description if non void and if the return value is nil.
 @result	A dictionary of attributes. 
 */
- (NSDictionary *)iTM2_attributesOfItemOrDestinationOfSymbolicLinkAtPath:(NSString *)path error:(NSError **)errorRef;

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
	@method		iTM2_extendedFileAttributesInSpace:atPath:traverseLink:error:
	@abstract	Retrieve the extended attributes.
	@discussion This uses the resource fork. The resource fork being arranged with resource index, will limit the resource identifier.
				We do not rely on resource index but on resource name. The resource name is expected to be the key of the dictionary.
	@param		space is either a space name or a number wrapping the resource identifier.
	@param		path is the location where things should be stored.
	@param		outErrorPtr is the reference of an NSError object. Will contain error description on return, if any.
	@result		an NSDictionary. All the keys are NSString's (less than 255 characters in UTF8 representation)
				and the corresponding values are NSData objects. 
*/
- (NSDictionary *)iTM2_extendedFileAttributesInSpace:(id)space atPath:(NSString *)path error:(NSError **)outErrorPtr;

/*!
	@method		iTM2_extendedFileAttribute:inSpace:atPath:error:
	@abstract	Retrieve the named extended attribute.
	@discussion This uses the resource fork.
	@param		attributeName is the attribute name.
	@param		space is either a space name or a number wrapping the resource identifier.
	@param		path is the location where things should be stored.
	@param		outErrorPtr is the reference of an NSError object. Will contain error description on return, if any.
	@result		an NSData objects. 
*/
- (NSData *)iTM2_extendedFileAttribute:(NSString *)attributeName inSpace:(id)space atPath:(NSString *)path error:(NSError **)outErrorPtr;

/*!
	@method		iTM2_removeExtendedFileAttribute:inSpace:atPath:traverseLink:error:
	@abstract	Remove the named extended attribute.
	@discussion This uses the resource fork.
	@param		attributeName is the attribute name.
	@param		space is either a space name or a number wrapping the resource identifier.
	@param		path is the location where things should be stored.
	@param		outErrorPtr is the reference of an NSError object. Will contain error description on return, if any.
	@result		a flag indicating success or failure.
*/
- (BOOL)iTM2_removeExtendedFileAttribute:(NSString *)attributeName inSpace:(id)space atPath:(NSString *)path error:(NSError **)outErrorPtr;

/*!
	@method		iTM2_addExtendedFileAttribute:value:inSpace:atPath:error:
	@abstract	Retrieve the named extended attribute.
	@discussion This uses the resource fork or the xattrs.
	@param		attributeName is the attribute name.
	@param		value is the new data.
	@param		space is either a space name or a number wrapping the resource identifier.
	@param		path is the location where things should be stored.
	@param		outErrorPtr is the reference of an NSError object. Will contain error description on return, if any.
	@result		a flag indicating success or failure.
*/
- (BOOL)iTM2_addExtendedFileAttribute:(NSString *)attributeName value:(NSData *)D inSpace:(id)space atPath:(NSString *)path error:(NSError **)outErrorPtr;

/*!
	@method		iTM2_changeExtendedFileAttributes:inSpace:atPath:error:
	@abstract	Write the new attributes.
	@discussion This uses the resource fork.
	@param		attributes are gathered in a dictionary which keys are NSString identifiers and values are NSData objects.
	@param		space is either a space name or a number wrapping the resource identifier.
	@param		path is the location where things should be stored.
	@param		outErrorPtr is the reference of an NSError object. Will contain error description on return, if any.
	@result		a flag indicating success or failure. 
*/
- (BOOL)iTM2_changeExtendedFileAttributes:(NSDictionary *)attributes inSpace:(id)space atPath:(NSString *)path error:(NSError **)outErrorPtr;

@end
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= NSFileManager(iTeXMac2)

@interface NSFileManager(iTM2Alias)

/*!
	@method			iTM2_fileExistsAtPath:isAlias:error:
	@abstract		Abstract forthcoming.
	@discussion		Whether there is a finder alias at the given path.
	@param			fileName
	@param			a pointer to a BOOL that will hold the result
	@param			a pointer to an error object.
	@result			A flag.
	@availability	iTM2.
	@copyright		2005 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (BOOL)iTM2_fileExistsAtPath:(NSString *)path isAlias:(BOOL *)isAlias error:(NSError**)errorPtr;

@end

@interface NSData(iTM2Alias)

/*!
	@method		iTM2_pathByResolvingDataAliasRelativeTo:error:
	@abstract	Resolved path from the receiver as data alias.
	@discussion Discussion forthcoming.
	@param		base is the base path, can be nil.
	@param		error is an NSError pointer, can be nil.
	@result		a path or nil in case of error. 
*/
- (NSString*)iTM2_pathByResolvingDataAliasRelativeTo:(NSString *)base error:(NSError **)error;
- (BOOL)iTM2_writeAsFinderAliasToURL:(NSURL *)url options:(NSUInteger)writeOptionsMask error:(NSError **)errorPtr;
+ (NSData *)iTM2_aliasDataWithContentsOfURL:(NSURL *)absoluteURL error:(NSError **)error;
- (NSURL *)iTM2_URLByResolvingDataAliasRelativeToURL:(NSURL *)baseURL error:(NSError **)outErrorPtr;

@end

@interface NSString(iTM2AliasKit)

/*!
	@method		iTM2_dataAliasRelativeTo:error:
	@abstract	Wraps the receiver in a data alias object.
	@discussion Discussion forthcoming.
	@param		base is the base path, can be nil.
	@param		error is an NSError pointer, can be nil.
	@result		a data object containing a dereferenced AliasHandle. 
*/
- (NSData*)iTM2_dataAliasRelativeTo:(NSString *)base error:(NSError **)error;

@end
