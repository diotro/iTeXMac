/*
//
//  @version Subversion: $Id: iTM2PathUtilities.h 795 2009-10-11 15:29:16Z jlaurens $ 
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
extern NSString * const iTM2PathFactoryComponent;

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= 
/*"Description forthcoming."*/
@interface NSString(iTM2PathUtilities)
- (BOOL)iTM2_isFinderAliasTraverseLink:(BOOL)aFlag isDirectory:(BOOL *)isDirectory;
- (NSString *)iTM2_stringByResolvingFinderAliasesInPath;
- (NSString *)iTM2_lazyStringByResolvingSymlinksAndFinderAliasesInPath;
- (NSString *)iTM2_stringByResolvingSymlinksAndFinderAliasesInPath;
- (NSString *)iTM2_stringByAbbreviatingWithDotsRelativeToDirectory:(NSString *)aPath;
- (NSString *)iTM2_shortestStringByAbbreviatingWithTildeInPath;
- (NSString *)iTM2_stringByDeletingAllPathExtensions;
- (NSString *)iTM2_stringByNormalizingPath;// removes void components, references to . and resolves .. as far as can do

/*!
	@method		iTM2_enclosingDirectoryForFileNames:
	@abstract	The enclosing doirectory for the given file names.
	@discussion Discussion forthcoming.
	@param		an array of file names.
	@result		The common path, at least the root directory. 
*/
+ (NSString*)iTM2_enclosingDirectoryForFileNames:(NSArray *)fileNames;

/*!
	@method		iTM2_isEqualToFileName:
	@abstract	Abstract forthcoming.
	@discussion Compares the lower case versions of both the receiver and the argument... Please use the iTM2_pathIsEqual: method instead
	@param		A file name.
	@result		yorn. 
*/
- (BOOL)iTM2_isEqualToFileName:(NSString *)otherFileName;

/*!
	@method		iTM2_pathIsEqual:
	@abstract	Abstract forthcoming.
	@discussion Compares the lower case versions of both the receiver and the argument...
				Use the compare: method to take into account unicode character decomposition.
				This method is necessary because until build 150, accented characters in paths would lead to inconsistency problems
				an exception raised in setProject:forFileName: method.
				Should replace the iTM2_isEqualToFileName:
	@param		A file name.
	@result		yorn. 
*/
- (BOOL)iTM2_pathIsEqual:(NSString *)otherPath;

/*!
	@method		iTM2_belongsToDirectory:
	@abstract	Abstract forthcoming.
	@discussion Discussion forthcoming...
	@param		A file name.
	@result		yorn. 
*/
- (BOOL)iTM2_belongsToDirectory:(NSString *)fileName;

/*!
 @method		iTM2_absolutePathWithPath:base:
 @abstract	Abstract forthcoming.
 @discussion If the given path is already absolute, it is returned as is.
 @param		path
 @param		base
 @result		absolute path. 
 */
+ (NSString *)iTM2_absolutePathWithPath:(NSString *)path base:(NSString *)base;

/*!
 @method	iTM2_pathWithComponents:
 @abstract	Custom method.
 @discussion The original <code>-pathComponents</code> and <code>-pathWithComponents:</code> methods are not reversed operations.
			If the receiver ends with a path separator and is not the root directory, the last component of the original <code>-pathComponents</code>
			is simply that separator. Unfortunately, the original <code>-pathWithComponents:</code> method ignores such ending path components.
			Moreover, <code>-pathWithComponents:</code> as of 10.6.1 does not conform to the documentation, see JL bug report 7274160
 @param		an array of path components
 @param		base
 @result	absolute path. 
 */
+ (NSString *)iTM2_pathWithComponents:(NSArray *)components;

@end

@interface NSURL(iTM2PathUtilities)

/*!
 @method	iTM2_path
 @abstract	The path.
 @discussion The original method does not add a trailing path separator when the receiver represents a directory
 @param		None
 @result	a NSString instance. 
 */
- (NSString *)iTM2_path;

/*!
	@method		iTM2_URLWithPath:relativeToURL:
	@abstract	URL creation.
	@discussion Convenient method that escapes the given string before forwarding to URLWithString:relativeToURL:
	@param		path
	@param		baseURL
	@result		an URL. 
*/
+ (id)iTM2_URLWithPath:(NSString *)path relativeToURL:(NSURL *)baseURL;

/*!
	@method		iTM2_isEquivalentToURL:
	@abstract	URL comparison.
	@discussion URL's are equivalent when their absolute URL's are equal..
	@param		otherURL
	@result		yorn. 
*/
- (BOOL)iTM2_isEquivalentToURL:(NSURL *)otherURL;

/*!
	@method		iTM2_parentDirectoryURL
	@abstract	Abstract forthcoming.
	@discussion Discussion forthcoming.
	@param		otherURL
	@result		No if on of the urls is not a file url, otherwise compares the paths using iTM2_pathIsEqual:. 
*/
- (NSURL *)iTM2_parentDirectoryURL;

/*!
	@method		iTM2_isEqualToFileURL:
	@abstract	Abstract forthcoming.
	@discussion Discussion forthcoming.
	@param		otherURL
	@result		No if one of the urls is not a file url, otherwise compares the paths using iTM2_pathIsEqual:. 
*/
- (BOOL)iTM2_isEqualToFileURL:(NSURL *)otherURL;

/*!
	@method		iTM2_isRelativeToURL:
	@abstract	Abstract forthcoming.
	@discussion Discussion forthcoming.
	@param		baseURL
	@result		No if on of the urls is not a file url, otherwise uses -iTM2_belongsToDirectory:. 
*/
- (BOOL)iTM2_isRelativeToURL:(NSURL *)baseURL;

/*!
	@method		iTM2_pathRelativeToURL:
	@abstract	Abstract forthcoming.
	@discussion The result if any has no percent escapes.
	@param		baseURL
	@result		A relative path. 
*/
- (NSString *)iTM2_pathRelativeToURL:(NSURL *)otherURL;

/*!
	@method		iTM2_URLByDeletingPathExtension
	@abstract	Abstract forthcoming.
	@discussion Description forthcoming.
	@param		None
	@result		A relative path. 
*/
- (NSURL *)iTM2_URLByDeletingPathExtension;

/*!
    @method		iTM2_factoryURL
    @abstract	The writable projects directory URL.
    @discussion	When a project can't be created because we have no write permission,
	            this folder is a repository where we definitely can write.
				It is useful either when we can't write inside a project or
				when we can't write where the project should be stored.
    @param		None.
    @result		A singleton URL.
*/
+ (NSURL *)iTM2_factoryURL;

/*!
    @method		iTM2_volumesURL
    @abstract	The Volumes directory URL.
    @discussion	Discussion forthcoming.
    @param		None.
    @result		A singleton URL.
*/
+ (NSURL *)iTM2_volumesURL;

/*!
    @method		iTM2_volumeURLs
    @abstract	The URL's of all the mounted volumes.
    @discussion	Discussion forthcoming.
    @param		None.
    @result		A singleton URL.
*/
+ (NSArray *)iTM2_volumeURLs;

/*!
    @method		iTM2_rootURL
    @abstract	The root directory URL.
    @discussion	Projects fileURL's can be relative to that directory.
    @param		None.
    @result		A singleton URL.
*/
+ (NSURL *)iTM2_rootURL;

/*!
    @method		iTM2_userURL
    @abstract	The user directory URL.
    @discussion	Projects fileURL's can be relative to that directory.
    @param		None.
    @result		A singleton URL.
*/
+ (NSURL *)iTM2_userURL;

/*!
    @method		iTM2_normalizedURL
    @abstract	normalized URL.
    @discussion	The return URL will be relative to the factory, the user folder, a mounted volume, the root.
	            The first decomposition found is adopted.
				If no such decomposition, url is returned unchanged.
				No query, ressource specifier, parameter are supported.
				This is exactly the kind of urls the documents should use.
    @param		None.
    @result		A singleton URL, unless the design has changed...
*/
- (NSURL *)iTM2_normalizedURL;

/*!
    @method		iTM2_URLByRemovingFactoryBaseURL
    @abstract	The URL by removing the Writable Projects base URL.
    @discussion	If the base URL is the Writable Projects URL,
				a new URL is created and returned with exactly the same relative path but with the iTM2_rootURL base URL.
				If the base URL is not the Writable Projects URL,
				a new URL is created with exactly the same relative path but with the old base URL
				to which we applied iTM2_URLByRemovingFactoryBaseURL.
				If this newly created URL is equal to the receiver, self is returned.
    @param		None.
    @result		An URL.
*/
- (NSURL *)iTM2_URLByRemovingFactoryBaseURL;

/*!
    @method		iTM2_URLByPrependingFactoryBaseURL
    @abstract	The URL by prepending the Writable Projects base URL.
    @discussion	If the receiver does not "belong" to the Writable Projects directory,
				this URL is prepended. The resulting URL has a relative part,
				its base URL is the Writable Projects directory URL,
				or is relative to the Writable Projects directory URL,
				or is relative to an URL relative to the Writable Projects directory URL,
				or is relative to an URL relative to an URL relative to the Writable Projects directory URL...
    @param		None.
    @result		An URL.
*/
- (NSURL *)iTM2_URLByPrependingFactoryBaseURL;

/*!
    @method		iTM2_belongsToFactory
    @abstract	Whether the receiver belongs to the Wtitable Projects directory.
    @discussion	Discussion forthcoming.
    @param		None.
    @result		An URL.
*/
- (BOOL)iTM2_belongsToFactory;

@end

@interface NSArray(iTM2PathUtilities)
- (BOOL)iTM2_containsURL:(NSURL *)url;
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

@interface NSBundle(iTM2PathUtilities)
/*!
    @method 	iTM2_bundleName
    @abstract	The name of the application.
    @discussion	Description forthcoming.
    @result	The main bundle name from the info dictionary.
*/
- (NSString *)iTM2_bundleName;

/*!
    @method 	iTM2_searchPathsForSupportInDomains:withName:application's given name.
    @discussion	Returns objects of
                1- ~/Library/Application\ Support/APPLICATION_NAME/
                2- /Library/Application\ Support/APPLICATION_NAME/
                3- /Network/Library/Application\ Support/APPLICATION_NAME/
                The system domain is ignored, not the others (fortunately, no other domain is defined)
    @param	domainMask is concerning one of the user, local or network domains, but NOT the system nor the built in one...
    @result	an array of the paths
*/
+ (NSArray *)iTM2_searchPathsForSupportInDomains:(NSSearchPathDomainMask)domainMask withName:(NSString *)appName;

/*!
    @method 	iTM2_pathForSupportDirectory:inDomain:withName:create:
    @abstract	The application support subdirectory.
    @discussion	Returns objects of
                1- ~/Library/Application\ Support/APP_NAME/subpath
                2- /Library/Application\ Support/APP_NAME/subpath
                3- /Network/Library/Application\ Support/APP_NAME/subpath
                The system domain is ignored, not the others (fortunately, no other domain is defined)
    @param		subpath is a subpath, yeah.
    @param		domainMask is concerning one of the user, local or network domains, but NOT the system nor the built in one...
                If more than one domain is given, the first ones are ignored and only the last one is taken into consideration.
    @param		appName is an appName, yeah.
    @param		create is a flag, if set to YES, the directory will be created.
    @result		a full path, possibly empty if it does not exist or could not be created while create is YES.
*/
+ (NSString *)iTM2_pathForSupportDirectory:(NSString *)subpath inDomain:(NSSearchPathDomainMask)domainMask withName:(NSString *)appName create:(BOOL)create;

/*!
    @method 	iTM2_pathForSupportDirectory:inDomain:withName:create:
    @abstract	The application support subdirectory.
    @discussion	Returns objects of
                
				1- ~/Library/Application\ Support/APP_NAME/subpath
                
				2- /Library/Application\ Support/APP_NAME/subpath
                
				3- /Network/Library/Application\ Support/APP_NAME/subpath
                
				The system domain is ignored, not the others (fortunately, no other domain is defined)
				If the path does not point to an existing file or folder, then either
				we create the directory if the create flag is yes, or
				we return a void string.
    @param		subpath is a subpath.
    @param		domainMask is concerning one of the user, local or network domains, but NOT the system nor the built in one...
                If more than one domain is given, the first one are ignored and only the last one is taken into consideration.
    @param		create is a flag.
    @result		a full path or @"" if the requested path does not exist or could not be created while create is YES.
*/
- (NSString *)iTM2_pathForSupportDirectory:(NSString *)subpath inDomain:(NSSearchPathDomainMask)domainMask create:(BOOL)create;
@end
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2PathUtilities
