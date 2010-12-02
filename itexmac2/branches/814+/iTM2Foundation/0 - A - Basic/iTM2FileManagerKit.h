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
	@method			makeFileWritableAtPath4iTM3:recursive:
	@abstract		Abstract forthcoming.
	@discussion		Discussion forthcoming.
	@param			fileName
	@param			yorn.
	@result			None.
	@availability	iTM2.
	@copyright		2005 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (void)makeFileWritableAtPath4iTM3:(NSString *)fileName recursive:(BOOL)yorn;

/*!
	@method			prettyNameAtPath4iTM3:
	@abstract		Abstract forthcoming.
	@discussion		The display name at path traverses links. This one does not.
	@param			fileName
	@result			Non traversing link display name.
	@availability	iTM2.
	@copyright		2005 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (NSString *)prettyNameAtPath4iTM3:(NSString *)path;

/*!
	@method			setExtensionHidden4iTM3:atURL:
	@abstract		Abstract forthcoming.
	@discussion		Forthcoming.
	@param			yorn.
	@param			URL
	@result			yorn.
	@availability	iTM2.
	@copyright		2010 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (BOOL)setExtensionHidden4iTM3:(BOOL)yorn atURL:(NSURL *)url;

/*!
	@method			pushDirectory4iTM3:
	@abstract		Abstract forthcoming.
	@discussion		Something like the pushd command.
	@param			path
	@result			yorn.
	@availability	iTM2.
	@copyright		2006 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (BOOL)pushDirectory4iTM3:(NSString *)path;

/*!
	@method			popDirectory4iTM3
	@abstract		Abstract forthcoming.
	@discussion		Something like the popd command.
	@param			None
	@result			yorn.
	@availability	iTM2.
	@copyright		2006 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (BOOL)popDirectory4iTM3;

/*!
	@method			fileOrLinkExistsAtPath4iTM3
	@abstract		Abstract forthcoming.
	@discussion		Discussion forthcoming.
	@param			path
	@result			yorn.
	@availability	iTM2.
	@copyright		2006 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (BOOL)fileOrLinkExistsAtPath4iTM3:(NSString *)path;

/*!
	@method			linkExistsAtPath4iTM3
	@abstract		Abstract forthcoming.
	@discussion		Discussion forthcoming.
	@param			path
	@result			yorn.
	@availability	iTM2.
	@copyright		2006 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (BOOL)linkExistsAtPath4iTM3:(NSString *)path;

/*!
	@method			isVisibleFileAtPath4iTM3:
	@abstract		Abstract forthcoming.
	@discussion		Discussion forthcoming.
	@param			path
	@result			yorn.
	@availability	iTM2.
	@copyright		2006 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (BOOL)isVisibleFileAtPath4iTM3:(NSString *)path;

/*!
	@method			pathContentOfSoftLinkAtPath4iTM3:
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
- (NSString *)pathContentOfSoftLinkAtPath4iTM3:(NSString *)path;

/*!
	@method			createSoftLinkAtPath4iTM3:pathContent:
	@abstract		Abstract forthcoming.
	@discussion		See <code>-pathContentOfSoftLinkAtPath4iTM3:</code>.
	@param			path is the source path
	@param			otherpath is the target path
	@result			yorn.
	@availability	iTM2.
	@copyright		2007 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (BOOL)createSoftLinkAtPath4iTM3:(NSString *)path pathContent:(NSString *)otherpath;

/*!
	@method			isPrivateFileAtPath4iTM3:
	@abstract		Abstract forthcoming.
	@discussion		Discussion forthcoming.
	@param			path
	@result			yorn.
	@availability	iTM2.
	@copyright		2007 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (BOOL)isPrivateFileAtPath4iTM3:(NSString *)path;

/*!
 @method	attributesOfItemOrDestinationOfSymbolicLinkAtURL4iTM3:error:
 @abstract	This is a workaround for the dto be deprecated fileAttributesAtPath:traverseLink:YES method..
 @discussion This uses the resource fork.
 @param		url.
 @param		error will contain an error description if non void and if the return value is nil.
 @result	A dictionary of attributes. 
 */
- (NSDictionary *)attributesOfItemOrDestinationOfSymbolicLinkAtURL4iTM3:(NSURL *)url error:(NSError **)errorRef;

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
	@method		extendedFileAttributesInSpace4iTM3:atPath:traverseLink:error:
	@abstract	Retrieve the extended attributes.
	@discussion This uses the resource fork. The resource fork being arranged with resource index, will limit the resource identifier.
				We do not rely on resource index but on resource name. The resource name is expected to be the key of the dictionary.
	@param		space is either a space name or a number wrapping the resource identifier.
	@param		path is the location where things should be stored.
	@param		RORef is the reference of an NSError object. Will contain error description on return, if any.
	@result		an NSDictionary. All the keys are NSString's (less than 255 characters in UTF8 representation)
				and the corresponding values are NSData objects. 
*/
- (NSDictionary *)extendedFileAttributesInSpace4iTM3:(id)space atPath:(NSString *)path error:(NSError **)RORef;

/*!
	@method		extendedFileAttribute4iTM3:inSpace:atPath:error:
	@abstract	Retrieve the named extended attribute.
	@discussion This uses the resource fork.
	@param		attributeName is the attribute name.
	@param		space is either a space name or a number wrapping the resource identifier.
	@param		path is the location where things should be stored.
	@param		RORef is the reference of an NSError object. Will contain error description on return, if any.
	@result		an NSData objects. 
*/
- (NSData *)extendedFileAttribute4iTM3:(NSString *)attributeName inSpace:(id)space atPath:(NSString *)path error:(NSError **)RORef;

/*!
	@method		removeExtendedFileAttribute4iTM3:inSpace:atPath:traverseLink:error:
	@abstract	Remove the named extended attribute.
	@discussion This uses the resource fork.
	@param		attributeName is the attribute name.
	@param		space is either a space name or a number wrapping the resource identifier.
	@param		path is the location where things should be stored.
	@param		RORef is the reference of an NSError object. Will contain error description on return, if any.
	@result		a flag indicating success or failure.
*/
- (BOOL)removeExtendedFileAttribute4iTM3:(NSString *)attributeName inSpace:(id)space atPath:(NSString *)path error:(NSError **)RORef;

/*!
	@method		addExtendedFileAttribute4iTM3:value:inSpace:atPath:error:
	@abstract	Retrieve the named extended attribute.
	@discussion This uses the resource fork or the xattrs.
	@param		attributeName is the attribute name.
	@param		value is the new data.
	@param		space is either a space name or a number wrapping the resource identifier.
	@param		path is the location where things should be stored.
	@param		RORef is the reference of an NSError object. Will contain error description on return, if any.
	@result		a flag indicating success or failure.
*/
- (BOOL)addExtendedFileAttribute4iTM3:(NSString *)attributeName value:(NSData *)D inSpace:(id)space atPath:(NSString *)path error:(NSError **)RORef;

/*!
	@method		changeExtendedFileAttributes4iTM3:inSpace:atPath:error:
	@abstract	Write the new attributes.
	@discussion This uses the resource fork.
	@param		attributes are gathered in a dictionary which keys are NSString identifiers and values are NSData objects.
	@param		space is either a space name or a number wrapping the resource identifier.
	@param		path is the location where things should be stored.
	@param		RORef is the reference of an NSError object. Will contain error description on return, if any.
	@result		a flag indicating success or failure. 
*/
- (BOOL)changeExtendedFileAttributes4iTM3:(NSDictionary *)attributes inSpace:(id)space atPath:(NSString *)path error:(NSError **)RORef;

@end
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= NSFileManager(iTeXMac2)

@interface NSFileManager(iTM2Alias)

/*!
	@method			fileExistsAtPath4iTM3:isAlias:error:
	@abstract		Abstract forthcoming.
	@discussion		Whether there is a finder alias at the given path.
	@param			fileName
	@param			a pointer to a BOOL that will hold the result
	@param			a pointer to an error object.
	@result			A flag.
	@availability	iTM2.
	@copyright		2005 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (BOOL)fileExistsAtPath4iTM3:(NSString *)path isAlias:(BOOL *)isAlias error:(NSError**)errorPtr;

@end
