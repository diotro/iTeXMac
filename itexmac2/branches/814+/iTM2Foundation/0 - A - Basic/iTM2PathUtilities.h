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

/* From RFC 1808
5.  Examples and Recommended Practice

   Within an object with a well-defined base URL of

      Base: <URL:http://a/b/c/d;p?q#f>

   the relative URLs would be resolved as follows:

5.1.  Normal Examples

      g:h        = <URL:g:h>
      g          = <URL:http://a/b/c/g>
      ./g        = <URL:http://a/b/c/g>
      g/         = <URL:http://a/b/c/g/>
      /g         = <URL:http://a/g>
      //g        = <URL:http://g>
      ?y         = <URL:http://a/b/c/d;p?y>
      g?y        = <URL:http://a/b/c/g?y>
      g?y/./x    = <URL:http://a/b/c/g?y/./x>
      #s         = <URL:http://a/b/c/d;p?q#s>
      g#s        = <URL:http://a/b/c/g#s>
      g#s/./x    = <URL:http://a/b/c/g#s/./x>
      g?y#s      = <URL:http://a/b/c/g?y#s>
      ;x         = <URL:http://a/b/c/d;x>
      g;x        = <URL:http://a/b/c/g;x>
      g;x?y#s    = <URL:http://a/b/c/g;x?y#s>
      .          = <URL:http://a/b/c/>
      ./         = <URL:http://a/b/c/>
      ..         = <URL:http://a/b/>
      ../        = <URL:http://a/b/>
      ../g       = <URL:http://a/b/g>
      ../..      = <URL:http://a/>
      ../../     = <URL:http://a/>
      ../../g    = <URL:http://a/g>

5.2.  Abnormal Examples

   Although the following abnormal examples are unlikely to occur in
   normal practice, all URL parsers should be capable of resolving them
   consistently.  Each example uses the same base as above.

   An empty reference resolves to the complete base URL:

      <>            = <URL:http://a/b/c/d;p?q#f>

   Parsers must be careful in handling the case where there are more
   relative path ".." segments than there are hierarchical levels in the
   base URL's path.  Note that the ".." syntax cannot be used to change
   the <net_loc> of a URL.

      ../../../g    = <URL:http://a/../g>
      ../../../../g = <URL:http://a/../../g>

   Similarly, parsers must avoid treating "." and ".." as special when
   they are not complete components of a relative path.

      /./g          = <URL:http://a/./g>
      /../g         = <URL:http://a/../g>
      g.            = <URL:http://a/b/c/g.>
      .g            = <URL:http://a/b/c/.g>
      g..           = <URL:http://a/b/c/g..>
      ..g           = <URL:http://a/b/c/..g>

   Less likely are cases where the relative URL uses unnecessary or
   nonsensical forms of the "." and ".." complete path segments.

      ./../g        = <URL:http://a/b/g>
      ./g/.         = <URL:http://a/b/c/g/>
      g/./h         = <URL:http://a/b/c/g/h>
      g/../h        = <URL:http://a/b/c/h>

   Finally, some older parsers allow the scheme name to be present in a
   relative URL if it is the same as the base URL scheme.  This is
   considered to be a loophole in prior specifications of partial URLs
   [1] and should be avoided by future parsers.

      http:g        = <URL:http:g>
      http:         = <URL:http:>

5.3.  Recommended Practice

   Authors should be aware that path names which contain a colon ":"
   character cannot be used as the first component of a relative URL
   path (e.g., "this:that") because they will likely be mistaken for a
   scheme name.  It is therefore necessary to precede such cases with
   other components (e.g., "./this:that"), or to escape the colon
   character (e.g., "this%3Athat"), in order for them to be correctly
   parsed.  The former solution is preferred because it does not affect
   the absolute form of the URL.

   There is an ambiguity in the semantics for the ftp URL scheme
   regarding the use of a trailing slash ("/") character and/or a
   parameter ";type=d" to indicate a resource that is an ftp directory.
   If the result of retrieving that directory includes embedded relative
   URLs, it is necessary that the base URL path for that result include
   a trailing slash.  For this reason, we recommend that the ";type=d"
   parameter value not be used within contexts that allow relative URLs.
   
   From wikipedia, modified concerning the parameter string
      foo://username:password@example.com:8042/over/there/index.dtb;size=big?type=animal;name=ferret#nose
      \ /   \______/ \______/ \_________/ \__/            \___/ \_/ \______/ \____________/ \__/
       |       |         |         |       |                |    |      |           |         |
       |      user   password   host      port              |    |  parameter     query    fragment
       |    \________________________________/ \____________|____|/
    scheme                  |                          |    |    |
       |                authority                    path   |    |
       |                                                    |    |
       |            path                       interpretable as filename
       |   ___________|____________                              |
      / \ /                        \                             |
      urn:example:animal:ferret:nose               interpretable as extension

*/

extern NSString * const iTM2PathComponentsSeparator;
extern NSString * const iTM2PathComponentDot;
extern NSString * const iTM2PathComponentDoubleDot;
extern NSString * const iTM2PathFactoryComponent;

extern NSString * const iTM2RegExpURLKey;
extern NSString * const iTM2RegExpURLSchemeName;
extern NSString * const iTM2RegExpURLLocationName;
extern NSString * const iTM2RegExpURLPathName;
extern NSString * const iTM2RegExpURLPathTrailerName;
extern NSString * const iTM2RegExpURLParametersName;
extern NSString * const iTM2RegExpURLQueryName;
extern NSString * const iTM2RegExpURLFragmentName;

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= 
/*"Description forthcoming."*/
@interface NSString(iTM2PathUtilities)
- (BOOL)isFinderAliasTraverseLink4iTM3:(BOOL)aFlag isDirectory:(BOOL *)isDirectory;
- (NSString *)stringByResolvingFinderAliasesInPath4iTM3;
- (NSString *)lazyStringByResolvingSymlinksAndFinderAliasesInPath4iTM3;
- (NSString *)stringByResolvingSymlinksAndFinderAliasesInPath4iTM3;
- (NSString *)stringByAbbreviatingWithDotsRelativeToDirectory4iTM3:(NSString *)aPath;
- (NSString *)stringByDeletingAllPathExtensions4iTM3;
- (NSString *)stringByNormalizingPath4iTM3;// removes void components, references to . and resolves .. as far as can do

/*!
	@method		isEqualToFileName4iTM3:
	@abstract	Abstract forthcoming.
	@discussion Compares the lower case versions of both the receiver and the argument... Please use the pathIsEqual4iTM3: method instead
	@param		A file name.
	@result		yorn. 
*/
- (BOOL)isEqualToFileName4iTM3:(NSString *)otherFileName;

/*!
	@method		pathIsEqual4iTM3:
	@abstract	Abstract forthcoming.
	@discussion Compares the lower case versions of both the receiver and the argument...
				Use the compare: method to take into account unicode character decomposition.
				This method is necessary because until build 150, accented characters in paths would lead to inconsistency problems
				an exception raised in setProject:forFileName: method.
				Should replace the isEqualToFileName4iTM3:
	@param		A file name.
	@result		yorn. 
*/
- (BOOL)pathIsEqual4iTM3:(NSString *)otherPath;

/*!
	@method		pathIsEquivalent4iTM3:
	@abstract	Abstract forthcoming.
	@discussion Compare the paths using URLs
	@param		A file name.
	@result		yorn. 
*/
- (BOOL)pathIsEquivalent4iTM3:(NSString *)otherPath;

/*!
	@method		belongsToDirectory4iTM3:
	@abstract	Abstract forthcoming.
	@discussion Discussion forthcoming...
	@param		A file name.
	@result		yorn. 
*/
- (BOOL)belongsToDirectory4iTM3:(NSString *)fileName;

/*!
	@method		isDirectoryPath4iTM3
	@abstract	Abstract forthcoming.
	@discussion Whether the receiver ends with a '/' or not
	@param		None.
	@result		yorn. 
*/
- (BOOL)isDirectoryPath4iTM3;

/*!
 @method	pathWithComponents4iTM3:
 @abstract	Custom method.
 @discussion The original <code>-pathComponents</code> and <code>-pathWithComponents:</code> methods are not reversed operations.
			If the receiver ends with a path separator and is not the root directory, the last component of the original <code>-pathComponents</code>
			is simply that separator. Unfortunately, the original <code>-pathWithComponents:</code> method ignores such ending path components.
			Moreover, <code>-pathWithComponents:</code> as of 10.6.1 does not conform to the documentation, see JL bug report 7274160
 @param		an array of path components
 @param		base
 @result	absolute path. 
 */
+ (NSString *)pathWithComponents4iTM3:(NSArray *)components;

@end

@interface NSURL(iTM2PathUtilities)

/*!
 @method	path4iTM3
 @abstract	The path.
 @discussion The original method does not add a trailing path separator when the receiver represents a directory.
            This is the purpose of the present method.
 @param		None
 @result	a NSString instance. 
 */
- (NSString *)path4iTM3;

/*!
	@method		directoryURL4iTM3
	@abstract	If the receiver points to a directory, returns the receiver otherwise returns the parent.
	@discussion Discussion forthcoming.
	@param		None
	@result		an NSURL instance. 
*/
- (NSURL *)directoryURL4iTM3;

/*!
	@method		parentDirectoryURL4iTM3
	@abstract	Abstract forthcoming.
	@discussion Discussion forthcoming. nil if the receiver is the root.
	@param		None
	@result		an NSURL instance. 
*/
- (NSURL *)parentDirectoryURL4iTM3;

/*!
	@method		URLWithPath4iTM3:relativeToURL:
	@abstract	URL creation.
	@discussion Convenient method that escapes the given string before forwarding to URLWithString:relativeToURL:
	@param		path
	@param		baseURL
	@result		an URL. 
*/
+ (id)URLWithPath4iTM3:(NSString *)path relativeToURL:(NSURL *)baseURL;

/*!
	@method		URLWithDirectoryPath4iTM3:relativeToURL:
	@abstract	URL creation.
	@discussion Convenient method that escapes the given string before forwarding to URLWithString:relativeToURL:
	@param		path
	@param		baseURL
	@result		an URL. 
*/
+ (id)URLWithDirectoryPath4iTM3:(NSString *)path relativeToURL:(NSURL *)baseURL;

/*!
	@method		fileURLWithPath4iTM3:
	@abstract	URL creation.
	@discussion Convenient method that escapes the given string before forwarding properly to +fileURLWithPath:isDirectory:
	@param		path
	@param		baseURL
	@result		an URL. 
*/
+ (NSURL *)fileURLWithPath4iTM3:(NSString *)path;

/*!
	@method		fileURLWithPathComponents4iTM3:
	@abstract	URL creation.
	@discussion Just a wrapper over pathWithComponents4iTM3: method
	@param		path
	@param		baseURL
	@result		an URL. 
*/
+ (NSURL *)fileURLWithPathComponents4iTM3:(NSArray *)pathComponents;

/*!
	@method		pathComponents4iTM3
	@abstract	URL decomposition.
	@discussion Convenient method.
	@param		None
	@result		an array of path components. 
*/
- (NSArray *)pathComponents4iTM3;

/*!
	@method		fileURLWithPath4iTM3:isDirectory:
	@abstract	URL creation.
	@discussion Just a wrapper over +fileURLWithPath:isDirectory:
	@param		path
	@param		baseURL
	@result		an URL. 
*/
+ (NSURL *)fileURLWithPath4iTM3:(NSString *)path isDirectory:(BOOL)yorn;

/*!
	@method		isEquivalentToURL4iTM3:
	@abstract	URL comparison.
	@discussion URL's are equivalent when their absolute URL's are equal..
	@param		otherURL
	@result		yorn. 
*/
- (BOOL)isEquivalentToURL4iTM3:(NSURL *)otherURL;

/*!
	@method		isEqualToFileURL4iTM3:
	@abstract	Abstract forthcoming.
	@discussion Discussion forthcoming.
	@param		otherURL
	@result		No if one of the urls is not a file url, otherwise compares the paths using pathIsEqual4iTM3:. 
*/
- (BOOL)isEqualToFileURL4iTM3:(NSURL *)otherURL;

/*!
	@method		isRelativeToURL4iTM3:
	@abstract	Abstract forthcoming.
	@discussion Discussion forthcoming.
	@param		baseURL
	@result		No if on of the urls is not a file url, otherwise uses -belongsToDirectory4iTM3:. 
*/
- (BOOL)isRelativeToURL4iTM3:(NSURL *)baseURL;

/*!
	@method		pathRelativeToURL4iTM3:
	@abstract	Abstract forthcoming.
	@discussion The result if any has no percent escapes.
	@param		baseURL
	@result		A relative path. 
*/
- (NSString *)pathRelativeToURL4iTM3:(NSURL *)otherURL;

/*!
    @method		factoryURL4iTM3
    @abstract	The writable projects directory URL.
    @discussion	When a project can't be created because we have no write permission,
	            this folder is a repository where we definitely can write.
				It is useful either when we can't write inside a project or
				when we can't write where the project should be stored.
    @param		None.
    @result		A singleton URL.
*/
+ (NSURL *)factoryURL4iTM3;

/*!
    @method		volumesURL4iTM3
    @abstract	The Volumes directory URL.
    @discussion	Discussion forthcoming.
    @param		None.
    @result		A singleton URL.
*/
+ (NSURL *)volumesURL4iTM3;

/*!
    @method		volumeURLs4iTM3
    @abstract	The URL's of all the mounted volumes.
    @discussion	Discussion forthcoming.
    @param		None.
    @result		A singleton URL.
*/
+ (NSArray *)volumeURLs4iTM3;

/*!
    @method		rootURL4iTM3
    @abstract	The root directory URL.
    @discussion	Projects fileURL's can be relative to that directory.
    @param		None.
    @result		A singleton URL.
*/
+ (NSURL *)rootURL4iTM3;

/*!
    @method		networkURL4iTM3
    @abstract	The network directory URL.
    @discussion	Projects fileURL's can be relative to that directory.
    @param		None.
    @result		A singleton URL.
*/
+ (NSURL *)networkURL4iTM3;

/*!
    @method		userURL4iTM3
    @abstract	The user directory URL.
    @discussion	Projects fileURL's can be relative to that directory.
    @param		None.
    @result		A singleton URL.
*/
+ (NSURL *)userURL4iTM3;

/*!
    @method		normalizedURL4iTM3
    @abstract	normalized URL.
    @discussion	The return URL will be relative to the factory, the user folder, a mounted volume, the root.
	            The first decomposition found is adopted.
				If no such decomposition, url is returned unchanged.
				No query, ressource specifier, parameter are supported.
				This is exactly the kind of urls the documents should use.
    @param		None.
    @result		A singleton URL, unless the design has changed...
*/
- (NSURL *)normalizedURL4iTM3;

/*!
    @method		normalizedDirectoryURL4iTM3
    @abstract	normalized directory URL.
    @discussion	RFC 1808 tells us that paths ending with a '/' correspond to folders,
                otherwise they correspond to resources. This is problematic on OS X in which
                file wrappers are at the same time folders and resources.
                The normalizedDirectoryURL4iTM3 assumes that the receiver represents a directory
                and appends a '/' at the end of its path component if there is no '/' already.
                self is returned when nothing has changed.
                This is necessary to properly use the receiver as base URL.
    @param		None.
    @result		A singleton URL, unless the design has changed...
*/
- (NSURL *)normalizedDirectoryURL4iTM3;

/*!
    @method		URLByRemovingFactoryBaseURL4iTM3
    @abstract	The URL by removing the Writable Projects base URL.
    @discussion	If the base URL is the Writable Projects URL,
				a new URL is created and returned with exactly the same relative path but with the rootURL4iTM3 base URL.
				If the base URL is not the Writable Projects URL,
				a new URL is created with exactly the same relative path but with the old base URL
				to which we applied URLByRemovingFactoryBaseURL4iTM3.
				If this newly created URL is equal to the receiver, self is returned.
    @param		None.
    @result		An URL.
*/
- (NSURL *)URLByRemovingFactoryBaseURL4iTM3;

/*!
    @method		URLByPrependingFactoryBaseURL4iTM3
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
- (NSURL *)URLByPrependingFactoryBaseURL4iTM3;

- (NSURL *)URLByResolvingSymlinksAndFinderAliasesInPath4iTM3;

- (NSURL *)URLByResolvingSymlinksAndBookmarkDataWithOptions:(NSURLBookmarkResolutionOptions)options relativeToURL:(NSURL *)relativeURL error4iTM3:(NSError **)errorRef;

- (NSURL *)URLByDeletingParentLastPathComponent4iTM3;

- (NSURL *)URLByRemovingParentPathExtension4iTM3;

- (NSURL *)URLByAppendingEponymParentPathComponent4iTM3;

/*!
    @method		belongsToFactory4iTM3
    @abstract	Whether the receiver belongs to the Wtitable Projects directory.
    @discussion	Discussion forthcoming.
    @param		None.
    @result		An URL.
*/
- (BOOL)belongsToFactory4iTM3;

- (NSURL *)standardizedURL4iTM3;

- (NSString *) nameOrError4iTM3:(NSError**)errorRef;

- (NSString *) localizedNameOrError4iTM3:(NSError**)errorRef;

- (BOOL) isRegularFileOrError4iTM3:(NSError**)errorRef;

- (BOOL) isDirectoryOrError4iTM3:(NSError**)errorRef;

- (BOOL) isSymbolicLinkOrError4iTM3:(NSError**)errorRef;

- (BOOL) isVolumeOrError4iTM3:(NSError**)errorRef;

- (BOOL) isPackageOrError4iTM3:(NSError**)errorRef;

- (BOOL) isSystemImmutableOrError4iTM3:(NSError**)errorRef;

- (BOOL) isUserImmutableOrError4iTM3:(NSError**)errorRef;

- (BOOL) isHiddenOrError4iTM3:(NSError**)errorRef;

- (BOOL) hasHiddenExtensionOrError4iTM3:(NSError**)errorRef;

- (NSDate *) creationDateOrError4iTM3:(NSError**)errorRef;

- (NSDate *) contentAccessDateOrError4iTM3:(NSError**)errorRef;

- (NSDate *) contentModificationDateOrError4iTM3:(NSError**)errorRef;

- (NSDate *) attributeModificationDateOrError4iTM3:(NSError**)errorRef;

- (NSUInteger) linkCountOrError4iTM3:(NSError**)errorRef;

- (NSURL *) parentDirectoryURLOrError4iTM3:(NSError**)errorRef;

- (NSURL *) volumeURLOrError4iTM3:(NSError**)errorRef;

- (NSString *) typeIdentifierOrError4iTM3:(NSError**)errorRef;

- (NSString *) localizedTypeDescriptionOrError4iTM3:(NSError**)errorRef;

- (NSUInteger) labelNumberOrError4iTM3:(NSError**)errorRef;

- (NSColor *) labelColorOrError4iTM3:(NSError**)errorRef;

- (NSString *) localizedLabelOrError4iTM3:(NSError**)errorRef;

- (NSImage *) effectiveIconOrError4iTM3:(NSError**)errorRef;

- (NSImage *) customIconOrError4iTM3:(NSError**)errorRef;


/* File Properties 
*/
- (NSUInteger) fileSizeOrError4iTM3:(NSError**)errorRef;

- (NSUInteger) fileAllocatedSizeOrError4iTM3:(NSError**)errorRef;

- (BOOL) isAliasFileOrError4iTM3:(NSError**)errorRef;

/* Volume Properties

As a convenience, volume properties can be requested from any file system URL. The value returned will reflect the property value for the volume on which the resource is located.
*/
- (NSString *) volumeLocalizedFormatDescriptionOrError4iTM3:(NSError**)errorRef;

- (NSUInteger) volumeTotalCapacityOrError4iTM3:(NSError**)errorRef;

- (NSUInteger) volumeAvailableCapacityOrError4iTM3:(NSError**)errorRef;

- (NSUInteger) volumeResourceCountOrError4iTM3:(NSError**)errorRef;

#if ZERO
- (BOOL) volumeSupportsPersistentIDsOrError4iTM3:(NSError**)errorRef;

- (BOOL) volumeSupportsZeroRunsOrError4iTM3:(NSError**)errorRef;

- (BOOL) volumeSupportsCasePreservedNamesOrError4iTM3:(NSError**)errorRef;

- (BOOL) volumeSupportsHardLinksOrError4iTM3:(NSError**)errorRef;

- (BOOL) volumeIsJournalingOrError4iTM3:(NSError**)errorRef;

- (BOOL) volumeSupportsCaseSensitiveNamesOrError4iTM3:(NSError**)errorRef;

- (BOOL) volumeSupportsSymbolicLinksOrError4iTM3:(NSError**)errorRef;

- (BOOL) volumeSupportsJournalingOrError4iTM3:(NSError**)errorRef;

- (BOOL) volumeSupportsSparseFilesOrError4iTM3:(NSError**)errorRef;

#endif

@end

@interface NSArray(iTM2PathUtilities)
- (BOOL)containsURL4iTM3:(NSURL *)url;
- (NSArray *)arrayWithCommon1stObjectsOfArray4iTM3:(NSArray *)array;
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
    @method 	bundleName4iTM3
    @abstract	The name of the application.
    @discussion	Description forthcoming.
    @result	The main bundle name from the info dictionary.
*/
- (NSString *)bundleName4iTM3;

/*!
    @method 	searchURLsForSupportInDomains4iTM3:withName:
    @discussion	Returns objects of
                1- ~/Library/Application\ Support/APPLICATION_NAME/
                2- /Library/Application\ Support/APPLICATION_NAME/
                3- /Network/Library/Application\ Support/APPLICATION_NAME/
                The system domain is ignored, not the others (fortunately, no other domain is defined)
    @param      domainMask is concerning one of the user, local or network domains, but NOT the system nor the built in one...
    @param      appName: application's given name.
    @result     an array of the paths
*/
+ (NSArray *)searchURLsForSupportInDomains4iTM3:(NSSearchPathDomainMask)domainMask withName:(NSString *)appName;

/*!
    @method 	URLForSupportDirectory4iTM3:inDomain:withName:create:
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
+ (NSURL *)URLForSupportDirectory4iTM3:(NSString *)subpath inDomain:(NSSearchPathDomainMask)domainMask withName:(NSString *)appName create:(BOOL)create;

/*!
    @method 	URLForSupportDirectory4iTM3:inDomain:withName:create:
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
- (NSURL *)URLForSupportDirectory4iTM3:(NSString *)subpath inDomain:(NSSearchPathDomainMask)domainMask create:(BOOL)create;

@end

@interface NSURL (xattrs4iTM3)

- (NSData *) getXtdAttribute4iTM3ForName:(NSString *)name options:(NSUInteger) options error:(NSError **)RORef; 
- (BOOL) setXtdAttribute4iTM3:(NSData *)data forName:(NSString *)name options:(NSUInteger)options error:(NSError **)RORef; 
- (BOOL) removeXtdAttribute4iTM3ForName:(NSString *)name options:(NSUInteger) options error:(NSError **)RORef;
- (NSArray *) getXtdAttributeNames4iTM3WithOptions:(NSUInteger) options error:(NSError **)RORef;
- (NSString *) lastXtdAttributes4iTM3ErrorStatus;

@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2PathUtilities
