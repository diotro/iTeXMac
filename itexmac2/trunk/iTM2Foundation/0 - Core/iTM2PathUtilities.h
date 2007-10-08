/*
//
//  @version Subversion: $Id$ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Sat Jun 16 2001.
//  Copyright © 2001-2004 Laurens'Tribune. All rights reserved.
//
//  This program is free software; you can redistribute it and/or modify it under the terms
//  of the GNU General Public License as published by the Free Software Foundation; either
//  version 2 of the License, or any later version.
//  This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
//  without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
//  See the GNU General Public License for more details. You should have received a copy
//  of the GNU General Public License along with this program; if not, write to the Free Software
//  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
//  GPL addendum: Any simple modification of the present code which purpose is to remove bug,
//  improve efficiency in both code execution and code reading or writing should be addressed
//  to the actual developper team.
*/

extern NSString * const iTM2PathComponentsSeparator;
extern NSString * const iTM2PathDotComponent;

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= 
/*"Description forthcoming."*/
@interface NSString(iTM2PathUtilities)
- (BOOL)isFinderAliasTraverseLink:(BOOL)aFlag isDirectory:(BOOL *)isDirectory;
- (NSString *)stringByResolvingFinderAliasesInPath;
- (NSString *)lazyStringByResolvingSymlinksAndFinderAliasesInPath;
- (NSString *)stringByResolvingSymlinksAndFinderAliasesInPath;
- (NSString *)stringByAbbreviatingWithDotsRelativeToDirectory:(NSString *)aPath;
- (NSString *)shortestStringByAbbreviatingWithTildeInPath;
- (NSString *)stringByDeletingAllPathExtensions;
- (NSString *)stringByNormalizingPath;// removes void components, references to . and resolves .. as far as can do

/*!
	@method		enclosingDirectoryForFileNames:
	@abstract	The enclosing doirectory for the given file names.
	@discussion Discussion forthcoming.
	@param		an array of file names.
	@result		The common path, at least the root directory. 
*/
+ (NSString*)enclosingDirectoryForFileNames:(NSArray *)fileNames;

/*!
	@method		isEqualToFileName:
	@abstract	Abstract forthcoming.
	@discussion Compares the lower case versions of both the receiver and the argument... Please use the pathIsEqual: method instead
	@param		A file name.
	@result		yorn. 
*/
- (BOOL)isEqualToFileName:(NSString *)otherFileName;

/*!
	@method		pathIsEqual:
	@abstract	Abstract forthcoming.
	@discussion Compares the lower case versions of both the receiver and the argument...
				Use the compare: method to take into account unicode character decomposition.
				This method is necessary because until build 150, accented characters in paths would lead to inconsistency problems
				an exception raised in setProject:forFileName: method.
				Should replace the isEqualToFileName:
	@param		A file name.
	@result		yorn. 
*/
- (BOOL)pathIsEqual:(NSString *)otherPath;

/*!
	@method		belongsToDirectory:
	@abstract	Abstract forthcoming.
	@discussion Discussion forthcoming...
	@param		A file name.
	@result		yorn. 
*/
- (BOOL)belongsToDirectory:(NSString *)fileName;

/*!
	@method		absolutePathWithPath:base:
	@abstract	Abstract forthcoming.
	@discussion If the given path is already absolute, it is returned as is.
	@param		path
	@param		base
	@result		absolute path. 
*/
+ (NSString *)absolutePathWithPath:(NSString *)path base:(NSString *)base;

@end

@interface NSURL(iTM2PathUtilities)

/*!
	@method		isEqualToFileURL:base:
	@abstract	Abstract forthcoming.
	@discussion Discussion forthcoming.
	@param		url
	@result		No if on of the urls is not a file url, otherwise compares the paths using pathIsEqual:. 
*/
- (BOOL)isEqualToFileURL:(NSURL *)otherURL;

@end


/*! 
    @const		iTM2PATHDomainX11BinariesKey
    @abstract   Description Forthcoming.
    @discussion Apple X11 server is supported. naries available in the standard user defaults datyabase.
				Here is the key for the X11 binaries. This is designed for PATH environment variable only
                (a : separated list of paths is returned)
                The default value is
                /usr/X11R6/bin:/usr/bin/X11:/usr/local/bin/X11
                but you can override it with
                defaults write comp.text.tex.iTeXMac2 "iTM2PATHX11Binaries" 'blah:bluh:bloh'
				Use [SUD stringForKey:iTM2PATHDomainX11BinariesKey];
*/
extern NSString * const iTM2PATHDomainX11BinariesKey;

extern NSString * const iTM2PATHPrefixKey;
extern NSString * const iTM2PATHSuffixKey;

@interface iTM2PATHServer: NSObject
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2PathUtilities
