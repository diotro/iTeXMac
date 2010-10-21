/*
//
//  @version Subversion: $Id: iTM2PathUtilities.m 799 2009-10-13 16:46:39Z jlaurens $ 
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


#import <Carbon/Carbon.h>
#import "iTM2Runtime.h"
#import "iTM2InstallationKit.h"
#import "iTM2PathUtilities.h"

NSString * const iTM2PathComponentsSeparator = @"/";
NSString * const iTM2PathComponentDot = @".";
NSString * const iTM2PathComponentDoubleDot = @"..";

NSString * const iTM2RegExpURLKey = @"URL";
NSString * const iTM2RegExpURLSchemeName = @"scheme";
NSString * const iTM2RegExpURLLocationName = @"network location";
NSString * const iTM2RegExpURLPathName = @"path";
NSString * const iTM2RegExpURLPathTrailerName = @"slash dots path trailer";
NSString * const iTM2RegExpURLParametersName = @"parameters";
NSString * const iTM2RegExpURLQueryName = @"query";
NSString * const iTM2RegExpURLFragmentName = @"fragment";

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= 
/*"Description forthcoming."*/

@implementation NSBundle(iTM2PathUtilities)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  searchPathsForSupportInDomains4iTM3:withName:
+ (NSArray *)searchPathsForSupportInDomains4iTM3:(NSSearchPathDomainMask)domainMask withName:(NSString *)appName;
/*"Description forthcoming. Does not check for existence.
 Returns a subarray of (assuming appName is "iTeXMac2")
 ~/Library/Application\ Support/iTeXMac2/
 /Library/Application\ Support/iTeXMac2/
 /Network/Library/Application\ Support/iTeXMac2/
 IGNORED: /System/Library/Application\ Support/iTeXMac2/
 according to the flags given in argument
 Version history: jlaurens AT users DOT sourceforge DOT net
 To Do List:
 "*/
{//DIAGNOSTIC4iTM3;
	//START4iTM3;
	NSParameterAssert(appName.length>0);
    NSMutableArray * MRA = [NSMutableArray array];
#define ADD_OBJECT(DOMAIN)\
if (domainMask&DOMAIN)\
[MRA addObject:[[[[NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, DOMAIN, YES) lastObject]\
stringByResolvingSymlinksAndFinderAliasesInPath4iTM3] stringByAppendingPathComponent:appName] stringByAppendingString:iTM2PathComponentsSeparator]];
    ADD_OBJECT(NSUserDomainMask);
    ADD_OBJECT(NSLocalDomainMask);
    ADD_OBJECT(NSNetworkDomainMask);
	//    ADD_OBJECT(NSSystemDomainMask);
    return [[MRA copy] autorelease];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  supportDirectoryRelativePath4iTM3
+ (NSString *)supportDirectoryRelativePath4iTM3;
{
    //  return @"./Library/Application Support/."
    //  In a system independant way
 	static NSString * supportDirectoryRelativePath4iTM3 = nil;// @"Library/Application Support/"
    if (!supportDirectoryRelativePath4iTM3) {
        NSUInteger count = [[NSOpenStepRootDirectory() pathComponents] count];
        NSString * P = [NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSLocalDomainMask, YES) lastObject];
        NSArray * PCs = [P pathComponents];
        if (PCs.count>count) {
            NSMutableArray * MRA = [[PCs mutableCopy] autorelease];
            while (count--) {
                [MRA removeObjectAtIndex:0];
            }
            [MRA insertObject:iTM2PathComponentDot atIndex:0];
            [MRA addObject:iTM2PathComponentDot];
            supportDirectoryRelativePath4iTM3 = [NSString pathWithComponents: MRA];
        } else {
            supportDirectoryRelativePath4iTM3 = [NSString pathWithComponents:
                    [NSArray arrayWithObjects:iTM2PathComponentDot,@"Library",@"Application Support",iTM2PathComponentDot,nil]];
        }
    }
    return supportDirectoryRelativePath4iTM3;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  searchURLsForSupportInDomains4iTM3:withName:
+ (NSArray *)searchURLsForSupportInDomains4iTM3:(NSSearchPathDomainMask)domainMask withName:(NSString *)appName;
/*"Description forthcoming. Does not check for existence.
 Returns a subarray of
 ~/Library/Application\ Support/iTeXMac2/
 /Library/Application\ Support/iTeXMac2/
 /Network/Library/Application\ Support/iTeXMac2/
 IGNORED: /System/Library/Application\ Support/iTeXMac2/
 according to the flags given in argument
 Version history: jlaurens AT users DOT sourceforge DOT net
 Latest Revision: Fri Jan 29 13:07:21 UTC 2010
 To Do List:
 "*/
{//DIAGNOSTIC4iTM3;
	//START4iTM3;
	NSParameterAssert(appName.length>0);
    NSMutableArray * MRA = [NSMutableArray array];
    if (domainMask) {
        NSURL * url = nil;
        if (domainMask & NSUserDomainMask) {
            url = [NSURL URLWithPath4iTM3:self.supportDirectoryRelativePath4iTM3 relativeToURL:[NSURL userURL4iTM3]];
            url = [NSURL URLWithPath4iTM3:[appName stringByAppendingPathComponent:iTM2PathComponentDot] relativeToURL:url];
            [MRA addObject:url];
        }
        if (domainMask & NSLocalDomainMask) {
            url = [NSURL URLWithPath4iTM3:self.supportDirectoryRelativePath4iTM3 relativeToURL:[NSURL rootURL4iTM3]];
            url = [NSURL URLWithPath4iTM3:[appName stringByAppendingPathComponent:iTM2PathComponentDot] relativeToURL:url];
            [MRA addObject:url];
        }
        if (domainMask & NSNetworkDomainMask) {
            url = [NSURL URLWithPath4iTM3:self.supportDirectoryRelativePath4iTM3 relativeToURL:[NSURL networkURL4iTM3]];
            url = [NSURL URLWithPath4iTM3:[appName stringByAppendingPathComponent:iTM2PathComponentDot] relativeToURL:url];
            [MRA addObject:url];
        }
    }
    return [[MRA copy] autorelease];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  URLForSupportDirectory4iTM3:inDomain:withName:create:
+ (NSURL *)URLForSupportDirectory4iTM3:(NSString *)subpath inDomain:(NSSearchPathDomainMask)domainMask withName:(NSString *)appName create:(BOOL)create;
/*"Description Forthcoming.
 Version history: jlaurens AT users DOT sourceforge DOT net
 Latest Revision: Mon Oct  4 13:15:17 UTC 2010
 To Do List:
 "*/
{//DIAGNOSTIC4iTM3;
	//START4iTM3;
	if (!appName.length) {
		return nil;
    }
    if (!subpath.length) {
        subpath = iTM2PathComponentDot;
    }
    NSURL * url = [[self searchURLsForSupportInDomains4iTM3:domainMask withName:appName] lastObject];
    url = [NSURL URLWithPath4iTM3:subpath relativeToURL:url];
    if (url.isFileURL) {
        NSString * path = url.path;
        if ([DFM fileExistsAtPath:path]) {
            return url;
        }
        NSError * localError = nil;
        if ([DFM destinationOfSymbolicLinkAtPath:path error:NULL]
                && ![DFM removeItemAtPath:path error:NULL]) {
            localError = [NSError errorWithDomain:__iTM2_PRETTY_FUNCTION__ code:1
                                         userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                                                   [NSString stringWithFormat:@"Could not remove\n%@", path], NSLocalizedDescriptionKey,
                                                   path, @"iTM2BundleKit",
                                                   nil]];
            [NSApp presentError:localError];
        }
        if (create && [DFM createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&localError]) {
            return url;
        } else if (localError) {
            [NSApp presentError:localError];
        }
    }
    return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  pathForSupportDirectory4iTM3:inDomain:withName:create:
+ (NSString *)pathForSupportDirectory4iTM3:(NSString *)subpath inDomain:(NSSearchPathDomainMask)domainMask withName:(NSString *)appName create:(BOOL)create;
/*"Description Forthcoming.
 Version history: jlaurens AT users DOT sourceforge DOT net
 - 2.0: Thu Jul 21 22:54:06 GMT 2005
 To Do List:
 "*/
{//DIAGNOSTIC4iTM3;
	//START4iTM3;
	if (!appName.length)
		return [NSString string];
    if (!subpath)
        subpath = [NSString string];
    NSString * path = [[self searchPathsForSupportInDomains4iTM3:domainMask withName:appName] lastObject];
    path = [path stringByAppendingPathComponent:subpath];
    path = [path stringByResolvingSymlinksAndFinderAliasesInPath4iTM3];
	if ([DFM fileExistsAtPath:path])
	{
		return path;
	}
	NSError * localError = nil;
	if ([DFM destinationOfSymbolicLinkAtPath:path error:NULL]
	   && ![DFM removeItemAtPath:path error:NULL])
	{
		localError = [NSError errorWithDomain:__iTM2_PRETTY_FUNCTION__ code:1
									 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
											   [NSString stringWithFormat:@"Could not remove\n%@", path], NSLocalizedDescriptionKey,
											   path, @"iTM2BundleKit",
											   nil]];
		[NSApp presentError:localError];
	}
	if (create && [DFM createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&localError])
	{
		return path;
	}
	if (localError)
	{
		[NSApp presentError:localError];
	}
    return [NSString string];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  bundleName4iTM3
- (NSString *)bundleName4iTM3;
/*"Description forthcoming. Does not check for existence.
 Version history: jlaurens AT users DOT sourceforge DOT net
 To Do List:
 "*/
{//DIAGNOSTIC4iTM3;
	//START4iTM3;
	id result = [self.infoDictionary objectForKey:(NSString *) kCFBundleNameKey];
    return result? result: (self == [NSBundle mainBundle]? self.bundlePath.lastPathComponent.stringByDeletingPathExtension:self.bundleIdentifier);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  pathForSupportDirectory4iTM3:inDomain:create:
- (NSString *)pathForSupportDirectory4iTM3:(NSString *)subpath inDomain:(NSSearchPathDomainMask)domainMask create:(BOOL)create;
/*"Description Forthcoming.
 Version history: jlaurens AT users DOT sourceforge DOT net
 - 2.0: Thu Jul 21 22:54:06 GMT 2005
 To Do List:
 "*/
{//DIAGNOSTIC4iTM3;
	//START4iTM3;
    return [self.class pathForSupportDirectory4iTM3:subpath inDomain:domainMask withName:self.bundleName4iTM3 create:create];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  URLForSupportDirectory4iTM3:inDomain:create:
- (NSURL *)URLForSupportDirectory4iTM3:(NSString *)subpath inDomain:(NSSearchPathDomainMask)domainMask create:(BOOL)create;
/*"Description Forthcoming.
 Version history: jlaurens AT users DOT sourceforge DOT net
 - 2.0: Thu Jul 21 22:54:06 GMT 2005
 To Do List:
 "*/
{//DIAGNOSTIC4iTM3;
	//START4iTM3;
    return [self.class URLForSupportDirectory4iTM3:subpath inDomain:domainMask withName:self.bundleName4iTM3 create:create];
}
@end

@implementation NSString(iTM2PathUtilities)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= isFinderAliasTraverseLink4iTM3:isDirectory:
- (BOOL)isFinderAliasTraverseLink4iTM3:(BOOL)aFlag isDirectory:(BOOL *)isDirectory;
/*"Returns YES if the receiver is a Finder Alias.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{//DIAGNOSTIC4iTM3;
    if (aFlag) {
        self = self.stringByResolvingSymlinksInPath;
    }
//NSLog(@"introspecting %@", self);
    if ([[[DFM attributesOfItemAtPath:self error:NULL] fileType] isEqualToString: NSFileTypeRegular]) {
        FSRef fileSystemRef;
        OSStatus error = FSPathMakeRef((UInt8 *)[DFM fileSystemRepresentationWithPath:self],
                        &fileSystemRef, (Boolean *)isDirectory );
        if (error == noErr) {
            BOOL aliasFileFlag;
            BOOL safeIsDirectory;
            if (!isDirectory)
                isDirectory = &safeIsDirectory;
            error = FSIsAliasFile ( &fileSystemRef, (Boolean *)&aliasFileFlag, (Boolean *)isDirectory );
            if (error == noErr) {
                return aliasFileFlag;
            } else {
                LOG4iTM3(@"FSIsAliasFile error: %d.", error);
			}
        }
        LOG4iTM3(@"FSPathMakeRef error: %d.", error);
    }
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= stringByResolvingFinderAliasesInPath4iTM3
- (NSString *)stringByResolvingFinderAliasesInPath4iTM3;
/*"Only the last component is resolved.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Mon Mar 29 14:11:00 UTC 2010
To Do List:
"*/
{//DIAGNOSTIC4iTM3;
    NSURL * URL = [NSURL fileURLWithPath:self];
    if (URL.isFileURL) {
        NSData * bookmarkData = [NSURL bookmarkDataWithContentsOfURL:URL error:NULL];
        if (bookmarkData) {
            //  This is an alias
            NSURL * resolvedURL = [NSURL URLByResolvingBookmarkData:bookmarkData options:NSURLBookmarkResolutionWithoutUI relativeToURL:nil bookmarkDataIsStale:NULL error:NULL];
            if (resolvedURL) {
                URL = resolvedURL;
            }
        }
    }
    return URL.path;
}
static NSMutableDictionary * lazyStringByResolvingSymlinksAndFinderAliasesInPath_cache = nil;
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= lazyStringByResolvingSymlinksAndFinderAliasesInPath4iTM3
- (NSString *)lazyStringByResolvingSymlinksAndFinderAliasesInPath4iTM3;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{//DIAGNOSTIC4iTM3;
	if (!lazyStringByResolvingSymlinksAndFinderAliasesInPath_cache)
	{
		lazyStringByResolvingSymlinksAndFinderAliasesInPath_cache = [[NSMutableDictionary dictionary] retain];
	}
    NSString * result = [lazyStringByResolvingSymlinksAndFinderAliasesInPath_cache objectForKey:self];
	if (result)
	{
		return result;
	}
	return self.stringByResolvingSymlinksAndFinderAliasesInPath4iTM3;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= stringByResolvingSymlinksAndFinderAliasesInPath4iTM3
- (NSString *)stringByResolvingSymlinksAndFinderAliasesInPath4iTM3;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{//DIAGNOSTIC4iTM3;
	if (!lazyStringByResolvingSymlinksAndFinderAliasesInPath_cache) {
		lazyStringByResolvingSymlinksAndFinderAliasesInPath_cache = [[NSMutableDictionary dictionary] retain];
	}
    NSString * result = self;
	NSString * temp = nil;
    NSUInteger firewall = 257;
    do {
        temp = result;
        result = temp.stringByResolvingSymlinksInPath;
        result = [result stringByStandardizingPath];
        result = [result stringByResolvingFinderAliasesInPath4iTM3];
    } while ((--firewall>0) && ![result pathIsEqual4iTM3:temp]);
	[lazyStringByResolvingSymlinksAndFinderAliasesInPath_cache setObject:result forKey:self];
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= stringByAbbreviatingWithDotsRelativeToDirectory4iTM3:
- (NSString *)stringByAbbreviatingWithDotsRelativeToDirectory4iTM3:(NSString *)aPath;
/*"It is not strong: the sender is responsible of the arguments, if they do not represent directory paths, the shame on it.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{//DIAGNOSTIC4iTM3;
    self = self.stringByNormalizingPath4iTM3;
    aPath = aPath.stringByNormalizingPath4iTM3;
    if (self.length && aPath.length && [self hasPrefix:iTM2PathComponentsSeparator] && [aPath hasPrefix:iTM2PathComponentsSeparator]) {
        NSArray * myComponents = self.pathComponents;
        NSArray * pathComponents = aPath.pathComponents;
        // common part
        NSUInteger commonIdx = 0, index = 0;
        NSUInteger bound = MIN(myComponents.count, pathComponents.count);
        while ((commonIdx < bound) &&
            [[myComponents objectAtIndex:commonIdx] pathIsEqual4iTM3:[pathComponents objectAtIndex:commonIdx]])
                ++commonIdx;
        index = commonIdx;
        NSMutableArray * components = [NSMutableArray array];
        while (index < pathComponents.count) {
			NSString * component = [pathComponents objectAtIndex:index++];
			if (![component isEqual:iTM2PathComponentsSeparator] && ![component isEqual:@""]) {
				[components addObject:iTM2PathComponentDoubleDot];
			}
		}
        index = commonIdx;
        while (index < myComponents.count)
			[components addObject:[myComponents objectAtIndex:index++]];
		self = [NSString pathWithComponents4iTM3:components];
    }
    return self.length?self:iTM2PathComponentDot;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= stringByNormalizingPath4iTM3
- (NSString *)stringByNormalizingPath4iTM3;
/*"Removes void components, references to . and resolves .. as far as can do
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Thu Mar 18 21:40:12 UTC 2010
To Do List:
"*/
{//DIAGNOSTIC4iTM3;
//START4iTM3;
	NSMutableArray * components = [NSMutableArray arrayWithArray:self.pathComponents];
	NSUInteger index = 1;
    NSString * component = nil;
	while (index + 1<components.count) {
		component = [components objectAtIndex:index];
		if (!component.length || [component isEqualToString:iTM2PathComponentDot]) {
			[components removeObjectAtIndex:index];
		} else if ([component isEqualToString:iTM2PathComponentDoubleDot]) {
			component = [components objectAtIndex:index-1];
			if (![component isEqualToString:iTM2PathComponentsSeparator]) {
				[components removeObjectAtIndex:index];// the object at index is the first unread, if any
				[components removeObjectAtIndex:--index];// the object at index is now the first unread, if any
			}
		} else {
			++index;
		}
	}
    if (components.count>1) {
        if ([components.lastObject isEqualToString:iTM2PathComponentDot]) {
            [components removeLastObject];
            [components addObject:@""];
        } else if  ([components.lastObject isEqualToString:iTM2PathComponentDoubleDot]) {
			component = [components objectAtIndex:components.count-2];
			if (![component isEqualToString:iTM2PathComponentsSeparator]) {
                [components removeLastObject];
                [components removeLastObject];
                [components addObject:@""];
			}
        }
    }
    if (components.count>1) {
        component = [components objectAtIndex:0];
        if ([[components objectAtIndex:0] isEqualToString:iTM2PathComponentDot]
                && ![[components objectAtIndex:1] isEqualToString:iTM2PathComponentsSeparator]) {
            [components removeObjectAtIndex:0];
        }
    }
    if (components.count == 1) {
        component = [components objectAtIndex:0];
        if ([component isEqualToString:iTM2PathComponentDot] || [component isEqualToString:iTM2PathComponentDoubleDot]) {
            [components addObject:@""];
        }
    }
//END4iTM3;
    return [NSString pathWithComponents4iTM3:components];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= stringByDeletingAllPathExtensions4iTM3
- (NSString *)stringByDeletingAllPathExtensions4iTM3;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{//DIAGNOSTIC4iTM3;
    NSUInteger newLength = self.length, length = 0;
    do
    {
        length = newLength;
        self = self.stringByDeletingPathExtension;
        newLength = self.length;
    }
    while(newLength<length);
    return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  isEqualToFileName4iTM3:
- (BOOL)isEqualToFileName4iTM3:(NSString *)otherFileName;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 06/01/03
To Do List:
"*/
{//DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
	return [self pathIsEqual4iTM3:otherFileName];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  pathIsEqual4iTM3:
- (BOOL)pathIsEqual4iTM3:(NSString *)otherPath;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Thu Mar 18 22:41:43 UTC 2010
To Do List:
"*/
{//DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
	if ([otherPath respondsToSelector:@selector(lowercaseString)]) {
		self = self.lowercaseString.stringByStandardizingPath;
		otherPath = otherPath.lowercaseString.stringByStandardizingPath;
		return [self compare:otherPath] == NSOrderedSame;
	}
	return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  pathIsEquivalent4iTM3:
- (BOOL)pathIsEquivalent4iTM3:(NSString *)otherPath;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Thu Mar 18 22:41:43 UTC 2010
To Do List:
"*/
{//DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
	if ([otherPath respondsToSelector:@selector(lowercaseString)]) {
		self = self.lowercaseString.stringByStandardizingPath;
		otherPath = otherPath.lowercaseString.stringByStandardizingPath;
		return [self compare:otherPath] == NSOrderedSame;
	}
	return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  belongsToDirectory4iTM3:
- (BOOL)belongsToDirectory4iTM3:(NSString *)dirName;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Thu Mar 18 22:41:34 UTC 2010
To Do List:
"*/
{//DIAGNOSTIC4iTM3;
//START4iTM3;
	NSArray * myComponents = self.pathComponents;
	NSEnumerator * myE = myComponents.objectEnumerator;
	NSArray * itsComponents = [dirName pathComponents];
	NSEnumerator * itsE = itsComponents.objectEnumerator;
	NSString * component = nil;
	if (component = itsE.nextObject) {
		do {
			if (![component pathIsEqual4iTM3:myE.nextObject]) {
				return NO;
			}
		} while(component = itsE.nextObject);
		return YES;
	}
//END4iTM3;
	return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  pathWithComponents4iTM3:
+ (NSString *)pathWithComponents4iTM3:(NSArray *)components;
/*"Description forthcoming.
 Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Thu Mar 18 08:51:42 UTC 2010
 To Do List:
 "*/
{//DIAGNOSTIC4iTM3;
	//START4iTM3;
	NSString * result = [self pathWithComponents:components];
	if (components.count>1
        && ([components.lastObject isEqual:@""] || [components.lastObject isEqual:iTM2PathComponentDot] || [components.lastObject isEqual:iTM2PathComponentDoubleDot] || [components.lastObject isEqual:iTM2PathComponentsSeparator])
            && !result.isDirectoryPath4iTM3) {
		result = [result stringByAppendingString:iTM2PathComponentsSeparator];
	}
	if (components.count>1 && [[components objectAtIndex:0] isEqual:@""]) {
		result = [iTM2PathComponentsSeparator stringByAppendingString:result];
	}
	//END4iTM3;
	return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  isDirectoryPath4iTM3
- (BOOL)isDirectoryPath4iTM3;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Thu Mar 18 08:32:10 UTC 2010
To Do List:
"*/
{//DIAGNOSTIC4iTM3;
	//START4iTM3;
	//END4iTM3;
	return [self hasSuffix:iTM2PathComponentsSeparator];
}
@end

/*!
    @class		iTM2URLSingleton
    @abstract	For URL singletons.
    @discussion	To return unique instances.
    @param		None.
    @result		An URL.
*/
@interface iTM2URLSingleton:NSURL
@end

static NSMutableDictionary * iTM2URLSingletons = nil;
@implementation iTM2URLSingleton
+ (void)initialize;
{
	[super initialize];
	if (!iTM2URLSingletons){
		iTM2URLSingletons = [[NSMutableDictionary dictionary] retain];
	}
	return;
}
- (id)copyWithZone:(NSZone *)zone;
{
	return self;
}
- initWithScheme:(NSString *)scheme host:(NSString *)host path:(NSString *)path;
{
	NSParameterAssert(path.length);
	if (self = [super initWithScheme:scheme host:host path:path])
	{
		NSString * key = self.absoluteString;
		NSURL * singleton = [iTM2URLSingletons objectForKey:key];
		if (singleton) {
			return singleton;
		}
		[iTM2URLSingletons setObject:self forKey:key];
	}
	return self;
}
- initWithString:(NSString *)URLString;
{
	NSParameterAssert(URLString.length);
	if (self = [super initWithString:URLString])
	{
		NSString * key = self.absoluteString;
		NSURL * singleton = [iTM2URLSingletons objectForKey:key];
		if (singleton) {
			return singleton;
		}
		[iTM2URLSingletons setObject:self forKey:key];
	}
	return self;
}
- initWithString:(NSString *)URLString relativeToURL:(NSURL *)baseURL;
{
	NSParameterAssert(URLString.length);
	if (self = [super initWithString:URLString relativeToURL:baseURL])
	{
		NSString * key = self.absoluteString;
		NSURL * singleton = [iTM2URLSingletons objectForKey:key];
		if (singleton) {
			return singleton;
		}
		[iTM2URLSingletons setObject:self forKey:key];
	}
	return self;
}
- initFileURLWithPath:(NSString *)path isDirectory:(BOOL)yorn;
{
	NSParameterAssert(path.length);
	if (self = [super initFileURLWithPath:path isDirectory:yorn]) {
		NSString * key = self.absoluteString;
		NSURL * singleton = [iTM2URLSingletons objectForKey:key];
		if (singleton) {
			return singleton;
		}
		[iTM2URLSingletons setObject:self forKey:key];
	}
	return self;
}
- initFileURLWithPath:(NSString *)path;
{
	NSParameterAssert(path.length);
	if (self = [super initFileURLWithPath:path]) {
		NSString * key = self.absoluteString;
		NSURL * singleton = [iTM2URLSingletons objectForKey:key];
		if (singleton) {
			return singleton;
		}
		[iTM2URLSingletons setObject:self forKey:key];
	}
	return self;
}
@end

NSString * const iTM2PathFactoryComponent = @"Factory.localized";

@implementation NSURL(iTM2PathUtilities)
+ (NSURL *)fileURLWithPathComponents4iTM3:(NSArray *)pathComponents;
{//DIAGNOSTIC4iTM3;
    if (pathComponents.count) {
        return [self fileURLWithPath4iTM3:[NSString pathWithComponents4iTM3:pathComponents]];
    }
    return [self fileURLWithPath4iTM3:nil];
}
- (NSArray *)pathComponents4iTM3;
{//DIAGNOSTIC4iTM3;
    if (!self.isFileURL) {
        return nil;
    }
    NSArray * ra = self.path.pathComponents;
    self = self.absoluteURL.standardizedURL;
    if (self.absoluteString.isDirectoryPath4iTM3 && ![ra.lastObject isEqual:iTM2PathComponentsSeparator]) {
        return [ra arrayByAddingObject:iTM2PathComponentsSeparator];
    }
    return ra;
}
+ (NSURL *)fileURLWithPath4iTM3:(NSString *)path;
{//DIAGNOSTIC4iTM3;
    //  This is a workaround for a limitation of fileURLWithPath:
    //  Suppose we have successfully [[NSFileManager defaultManager] changeCurrentDirectoryPath:@"/Applications/"]
    //  [NSURL fileURLWithPath:@"/Applications/a"] and [NSURL fileURLWithPath:@"a"] are equal
    //  whereas [NSURL fileURLWithPath:@"/Applications/a/"] and [NSURL fileURLWithPath:@"a/"] are not
    //  In particular, the latter does not seem to point to a folder
    if (path.isDirectoryPath4iTM3) {
        return [self fileURLWithPath:path isDirectory:YES];
    }
    if (path.length) {
        return [self fileURLWithPath:path];
    }
    if (path) {
        return [[[self fileURLWithPath:iTM2PathComponentDot isDirectory:YES] absoluteURL] standardizedURL];
    }
    return [[[[self fileURLWithPath:iTM2PathComponentsSeparator] URLByDeletingLastPathComponent] absoluteURL] standardizedURL];
}
+ (NSURL *)fileURLWithPath4iTM3:(NSString *)path isDirectory:(BOOL)yorn;
{//DIAGNOSTIC4iTM3;
    //  just a wrapper, to be in parallel with what is before
    if (path.isDirectoryPath4iTM3) {
        return [self fileURLWithPath:path isDirectory:YES];
    }
    if (path.length) {
        return [self fileURLWithPath:path isDirectory:yorn];
    }
    if (path) {
        return [[[self fileURLWithPath:iTM2PathComponentDot isDirectory:YES] absoluteURL] standardizedURL];
    }
    return [[[[self fileURLWithPath:iTM2PathComponentsSeparator] URLByDeletingLastPathComponent] absoluteURL] standardizedURL];
}
+ (id)URLWithPath4iTM3:(NSString *)path relativeToURL:(NSURL *)baseURL;
{//DIAGNOSTIC4iTM3;
    if ([path hasPrefix:iTM2PathComponentsSeparator] || !baseURL) {
        return [self fileURLWithPath4iTM3:path];
	}
    if (path.length) {
        path = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        return [self URLWithString:path relativeToURL:baseURL?:[NSURL fileURLWithPath4iTM3:@""]];
    }
    if (path) {
        return [self URLWithString:iTM2PathComponentDot relativeToURL:baseURL?:[NSURL fileURLWithPath4iTM3:@""]];
    }
    return [NSURL fileURLWithPath4iTM3:nil];
}
+ (id)URLWithDirectoryPath4iTM3:(NSString *)path relativeToURL:(NSURL *)baseURL;
{//DIAGNOSTIC4iTM3;
    if ([path hasPrefix:iTM2PathComponentsSeparator] || !baseURL) {
        return [self fileURLWithPath4iTM3:path];
	}
    if (path.length) {
        path = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        return [self URLWithString:[path stringByAppendingPathComponent:iTM2PathComponentDot] relativeToURL:baseURL?:[NSURL fileURLWithPath4iTM3:@""]];
    }
    if (path) {
        return [self URLWithString:iTM2PathComponentDot relativeToURL:baseURL?:[NSURL fileURLWithPath4iTM3:@""]];
    }
    return [NSURL fileURLWithPath4iTM3:nil];
}
- (NSString *)path4iTM3;
{//DIAGNOSTIC4iTM3;
	//START4iTM3;
    if (self.isFileURL) {
        NSString * myPath = [self.path stringByStandardizingPath];
        BOOL isDirectory = NO;
        if ([DFM fileExistsAtPath:myPath isDirectory:&isDirectory] && isDirectory && !myPath.isDirectoryPath4iTM3) {
            myPath = [myPath stringByAppendingString:iTM2PathComponentsSeparator];
        }
        //END4iTM3;
        return myPath;
    }
    //END4iTM3;
    return self.path;
}
- (NSURL *)directoryURL4iTM3;
{//DIAGNOSTIC4iTM3;
//START4iTM3;
    return self.isFileURL?
        (self.path.isDirectoryPath4iTM3?
            self:[NSURL URLWithString:iTM2PathComponentDot relativeToURL:self]):nil;
}
- (NSURL *)parentDirectoryURL4iTM3;
{//DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    self = self.directoryURL4iTM3;//    this always exist
    if (self.path.length<2 || [self.path hasPrefix:iTM2PathComponentDoubleDot]) {// Only '/'
        return nil;
    }
    return self.baseURL?
        (self.relativePath.length?[self URLByAppendingPathComponent:iTM2PathComponentDoubleDot]
            :[NSURL URLWithString:iTM2PathComponentDoubleDot relativeToURL:self.baseURL])
            :[NSURL URLWithString:iTM2PathComponentDoubleDot relativeToURL:self];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  isEquivalentToURL4iTM3:
- (BOOL)isEquivalentToURL4iTM3:(NSURL *)otherURL;
{//DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    self = self.absoluteURL.standardizedURL;
    otherURL = otherURL.absoluteURL.standardizedURL;
    return [self isEqual:otherURL];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  isEqualToFileURL4iTM3:
- (BOOL)isEqualToFileURL4iTM3:(NSURL *)otherURL;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 17 19:33:19 UTC 2010
To Do List:
"*/
{//DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
	return self.isFileURL && otherURL.isFileURL
        && [self.URLByResolvingSymlinksAndFinderAliasesInPath4iTM3.path.stringByStandardizingPath pathIsEqual4iTM3:otherURL.URLByResolvingSymlinksAndFinderAliasesInPath4iTM3.path.stringByStandardizingPath];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  isRelativeToURL4iTM3:
- (BOOL)isRelativeToURL4iTM3:(NSURL *)otherURL;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 17 19:33:04 UTC 2010
To Do List:
"*/
{//DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    if (self.isFileURL) {
        return otherURL.isFileURL
            && [self.path.stringByStandardizingPath belongsToDirectory4iTM3:otherURL.path.stringByStandardizingPath];
    } else if (otherURL.isFileURL) {
        return NO;
    } else if (otherURL) {
        //  None are file urls
        return NO;
    } else {
        return NO;
    }
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  pathRelativeToURL4iTM3:
- (NSString *)pathRelativeToURL4iTM3:(NSURL *)otherURL;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 17 19:32:37 UTC 2010
To Do List:
"*/
{//DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    if ([self.baseURL isEqual: otherURL]) {
        return self.relativePath;
    }
    if ((otherURL = otherURL.directoryURL4iTM3)) {
        NSString * result = [self.path4iTM3 stringByAbbreviatingWithDotsRelativeToDirectory4iTM3:otherURL.path4iTM3];
        NSURL * url = nil;
        if (self.absoluteString.isDirectoryPath4iTM3
            && !result.isDirectoryPath4iTM3
                && ![result.lastPathComponent isEqual:iTM2PathComponentDot]
                    && ![result.lastPathComponent isEqual:iTM2PathComponentDoubleDot]) {
            result = [result stringByAppendingPathComponent:iTM2PathComponentDot];
        }
        url = [NSURL URLWithPath4iTM3:result relativeToURL:otherURL];// gdb does not see this local variable when declared as NSURL * (BUG 25754)
        NSAssert(url,@"MISSED");
        NSAssert3([self isEquivalentToURL4iTM3:url],
            @"**** HUGE ERROR: the operation is not revertible!\nresult:%@,\nleft:%@\nright:%@",
                result,self,url);
        return result;
    }
    return self.absoluteURL.path;
}
- (id)SWZ_iTM2ProjectDocumentKit_initWithCoder:(NSCoder *)aDecoder;
{
	NSURL * url = [self SWZ_iTM2ProjectDocumentKit_initWithCoder:aDecoder];
	// if a singleton URL has already been created with that same absolute URL, then use it.
	NSURL * singleton = [iTM2URLSingletons objectForKey:url.absoluteString];
	return singleton?:url;
}
+ (NSURL *)rootURL4iTM3;
{//DIAGNOSTIC4iTM3;
//START4iTM3;
	NSString * K = NSStringFromSelector(_cmd);
	iTM2URLSingleton * url = [iTM2URLSingletons objectForKey:K];
	if (!url) {
		url = [iTM2URLSingleton fileURLWithPath:NSOpenStepRootDirectory() isDirectory:YES];
		[iTM2URLSingletons setObject:url forKey:K];
	}
	return url;
}
+ (NSURL *)networkURL4iTM3;
{//DIAGNOSTIC4iTM3;
//START4iTM3;
	NSString * K = NSStringFromSelector(_cmd);
	iTM2URLSingleton * url = [iTM2URLSingletons objectForKey:K];
	if (!url) {
        NSString * P = [NSSearchPathForDirectoriesInDomains(NSApplicationDirectory, NSNetworkDomainMask, YES) lastObject];
        P = P.stringByDeletingLastPathComponent;
		url = [iTM2URLSingleton fileURLWithPath:P isDirectory:YES];
		[iTM2URLSingletons setObject:url forKey:K];
	}
	return url;
}
+ (NSURL *)volumesURL4iTM3;
{//DIAGNOSTIC4iTM3;
//START4iTM3;
	NSString * K = NSStringFromSelector(_cmd);
	iTM2URLSingleton * url = [iTM2URLSingletons objectForKey:K];
	if (!url) {
		NSString * volumes = @"Volumes";
		url = [NSURL URLWithPath4iTM3:volumes relativeToURL:self.rootURL4iTM3];
		[iTM2URLSingletons setObject:url forKey:K];
	}
	return url;
}
+ (NSArray *)volumeURLs4iTM3;
{//DIAGNOSTIC4iTM3;
//START4iTM3;
	NSMutableArray * urls = [NSMutableArray array];
	for (NSString * component in [DFM contentsOfDirectoryAtPath:self.volumesURL4iTM3.path error:NULL]) {
		[urls addObject:[NSURL URLWithPath4iTM3:component relativeToURL:self.volumesURL4iTM3]];
	}
	return urls;
}
+ (NSURL *)userURL4iTM3;
{//DIAGNOSTIC4iTM3;
//START4iTM3;
	NSString * K = NSStringFromSelector(_cmd);
	iTM2URLSingleton * url = [iTM2URLSingletons objectForKey:K];
	if (!url) {
		url = [iTM2URLSingleton fileURLWithPath:NSHomeDirectory() isDirectory:YES];
		NSURL * baseURL = nil;
		NSString * relative = nil;
		for (baseURL in [NSURL volumeURLs4iTM3]) {
			if ([url isRelativeToURL4iTM3:baseURL]) {
				relative = [url pathRelativeToURL4iTM3:baseURL];
				url = [NSURL URLWithPath4iTM3:relative relativeToURL:baseURL];
				goto url_is_normalized;
			}
		}
		baseURL = self.rootURL4iTM3;
		if ([url isRelativeToURL4iTM3:baseURL]) {
			relative = [url pathRelativeToURL4iTM3:baseURL];
			url = [NSURL URLWithPath4iTM3:relative relativeToURL:baseURL];
		}
url_is_normalized:
		[iTM2URLSingletons setObject:url forKey:K];
	}
	return url;
}
+ (NSURL *)factoryURL4iTM3;
{//DIAGNOSTIC4iTM3;
//START4iTM3;
	NSString * K = NSStringFromSelector(_cmd);
	iTM2URLSingleton * url = [iTM2URLSingletons objectForKey:K];
	if ([url isEqual:[NSNull null]]) {
		return nil;
	}
	if (!url) {
		[iTM2URLSingletons setObject:[NSNull null] forKey:K];
		NSString * path = [[NSBundle mainBundle] pathForSupportDirectory4iTM3:iTM2PathFactoryComponent inDomain:NSUserDomainMask create:YES];
		NSMutableDictionary * attributes = [NSMutableDictionary dictionaryWithDictionary:[DFM attributesOfItemAtPath:path error:NULL]];
		[attributes setObject:[NSNumber numberWithBool:YES] forKey:NSFileExtensionHidden];
		[DFM setAttributes:attributes ofItemAtPath:path error:NULL];
		url = [iTM2URLSingleton fileURLWithPath:path isDirectory:YES];// this should be a writable directory
		[iTM2URLSingletons setObject:url.normalizedURL4iTM3 forKey:K];
	}
	return url;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  normalizedDirectoryURL4iTM3
- (NSURL *)normalizedDirectoryURL4iTM3;
/*"Ensure the path ends with a /.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Fri Sep 17 08:19:34 UTC 2010
To Do List:
"*/
{//DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
	return [self.normalizedURL4iTM3 URLByAppendingPathComponent:iTM2PathComponentDot].standardizedURL;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  normalizedURL4iTM3
- (NSURL *)normalizedURL4iTM3;
/*"The idea was to use the baseURL.
Unfortunately, the baseURL is always an absolute URL.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Oct  6 18:52:31 UTC 2010
To Do List:
"*/
{//DIAGNOSTIC4iTM3;
//START4iTM3;
    self = self.standardizedURL;// remove the dots in the relative path or everything when no base url
	NSURL * url = self.baseURL.standardizedURL;
	NSString * relative = nil;
	if (url) {
		url = url.normalizedURL4iTM3;
		relative = self.relativePath;
normalize_and_return:
		url = relative.length?[NSURL URLWithPath4iTM3:relative relativeToURL:url]:url;
		return [self isEqual:url]?self:url;
	}
	url = [NSURL factoryURL4iTM3];
	if ([self isRelativeToURL4iTM3:url]) {
set_relative:
		relative = [self pathRelativeToURL4iTM3:url];
//END4iTM3;
		goto normalize_and_return;
	}
	url = [NSURL userURL4iTM3];
	if ([self isRelativeToURL4iTM3:url]) {
		goto set_relative;
	}
	// separate the /Volume/name
	for (url in [NSURL volumeURLs4iTM3]) {
		if ([self isRelativeToURL4iTM3:url]) {
			goto set_relative;
		}
	}
	url = [NSURL rootURL4iTM3];
	if ([self isRelativeToURL4iTM3:url]) {
		goto set_relative;
	}
//END4iTM3;
	return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  URLByRemovingFactoryBaseURL4iTM3
- (NSURL *)URLByRemovingFactoryBaseURL4iTM3;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 17 19:25:06 UTC 2010
To Do List:
"*/
{//DIAGNOSTIC4iTM3;
//START4iTM3;
	// this method makes sense for file URLs only
	if (!self.isFileURL) {
		return self;
	}
	if ([self isEqual:[NSURL factoryURL4iTM3]]) {
		return [NSURL rootURL4iTM3];
	}
	NSURL * baseURL = self.baseURL;
	if (baseURL) {
		NSURL * newBaseURL = [baseURL URLByRemovingFactoryBaseURL4iTM3];
		if ([baseURL isEqual:newBaseURL]) {
	//END4iTM3;
			return self;
		}
		return [NSURL URLWithString:self.relativeString relativeToURL:newBaseURL];
	} else if (self.belongsToFactory4iTM3) {
		// OK, there is no base URL, but it does not mean that the receiver does not belong
		// to the Writable Projects directory.
		// This can be the case if 3rd parties have created this URL without conforming to
		// the rules (namely cocoa)
		NSString * relative2 = [self pathRelativeToURL4iTM3:[NSURL factoryURL4iTM3]];
		return [[NSURL URLWithPath4iTM3:relative2 relativeToURL:[NSURL rootURL4iTM3]] normalizedURL4iTM3];
	}
	return self;
//END4iTM3;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  URLByPrependingFactoryBaseURL4iTM3
- (NSURL *)URLByPrependingFactoryBaseURL4iTM3;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Fri Mar 19 19:50:42 UTC 2010
To Do List:
"*/
{//DIAGNOSTIC4iTM3;
//START4iTM3;
	// this message makes sense for file URLs only
	if (!self.isFileURL) {
//END4iTM3;
		return self;
	}
	NSURL * baseURL = self.baseURL;
	if (!baseURL) {
		// OK, there is no base URL, but it does not mean that the receiver does not belong
		// to the Factory directory.
		// This can be the case if 3rd parties have created this URL without conforming to
		// the rules (namely cocoa)
		if (self.belongsToFactory4iTM3) {
			return self.normalizedURL4iTM3;
		}
		NSString * relative = [iTM2PathComponentDot stringByAppendingPathComponent:self.path4iTM3];
		NSURL * url = [NSURL URLWithPath4iTM3:relative relativeToURL:[NSURL factoryURL4iTM3]];
		return [self isEquivalentToURL4iTM3:url]?self:url;
	}
	NSURL * newBaseURL = baseURL.URLByPrependingFactoryBaseURL4iTM3;
	if ([baseURL isEquivalentToURL4iTM3:newBaseURL]) {
//END4iTM3;
		return self;
	}
//END4iTM3;
	return [NSURL URLWithString:self.relativeString relativeToURL:newBaseURL];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  belongsToFactory4iTM3
- (BOOL)belongsToFactory4iTM3;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 17 19:28:47 UTC 2010
To Do List:
"*/
{//DIAGNOSTIC4iTM3;
//START4iTM3;
	if (!self.isFileURL) {
		return NO;
	}
	if (self.baseURL) {
		return self.baseURL.belongsToFactory4iTM3;
	}
    NSString * P = [self pathRelativeToURL4iTM3:[NSURL factoryURL4iTM3]];
//END4iTM3;
	return ![P hasPrefix:iTM2PathComponentDoubleDot];
}
- (NSURL *)URLByDeletingParentLastPathComponent4iTM3;
{
//  Latest Revision: Fri Oct  8 06:44:02 UTC 2010
    return [self.URLByDeletingLastPathComponent.URLByDeletingLastPathComponent URLByAppendingPathComponent:self.lastPathComponent];
}
- (NSURL *)URLByRemovingParentPathExtension4iTM3;
{
//  Latest Revision: Fri Oct  8 06:46:58 UTC 2010
    return [self.URLByDeletingLastPathComponent.URLByDeletingPathExtension URLByAppendingPathComponent:self.lastPathComponent];
}
- (NSURL *)URLByAppendingEponymParentPathComponent4iTM3;
{
//  Latest Revision: Fri Oct  8 06:46:58 UTC 2010
    return [[self.URLByDeletingLastPathComponent.URLByDeletingLastPathComponent URLByAppendingPathComponent:self.lastPathComponent.stringByDeletingPathExtension]
        URLByAppendingPathComponent:self.lastPathComponent];
}
- (NSURL *)URLByResolvingSymlinksAndFinderAliasesInPath4iTM3;
{
//Latest Revision: Mon Mar 29 14:19:05 UTC 2010
    NSUInteger firewall = 256;
    while (firewall--) {
        self = self.URLByResolvingSymlinksInPath;
        if (self.isFileURL) {
            NSData * bookmarkData = [NSURL bookmarkDataWithContentsOfURL:self error:NULL];
            if (bookmarkData) {
                //  This is an alias
                NSURL * resolvedURL = [NSURL URLByResolvingBookmarkData:bookmarkData options:NSURLBookmarkResolutionWithoutUI relativeToURL:nil bookmarkDataIsStale:NULL error:NULL];
                if (resolvedURL) {
                    self = resolvedURL;
                    continue;
                }
            }
        }
        break;
    }
    return self;
}
- (NSURL *)URLByResolvingSymlinksAndBookmarkDataWithOptions:(NSURLBookmarkResolutionOptions)options relativeToURL:(NSURL *)relativeURL error4iTM3:(NSError **)errorRef;
{
//  Latest Revision: Wed Oct  6 19:09:19 UTC 2010
    if (self.isFileURL) {
        NSUInteger firewall = 256;
        while (firewall--) {
            self = self.URLByResolvingSymlinksInPath;
            NSData * bookmarkData = [NSURL bookmarkDataWithContentsOfURL:self error:errorRef];
            if (bookmarkData) {
                //  This is an alias
                NSURL * resolvedURL = [NSURL URLByResolvingBookmarkData:bookmarkData options:options relativeToURL:relativeURL bookmarkDataIsStale:NULL error:errorRef];
                if (resolvedURL) {
                    self = resolvedURL;
                    continue;
                }
            }
            break;
        }
    }
    return self.normalizedURL4iTM3;
}
- (NSURL *)standardizedURL4iTM3;
{
    return self.URLByStandardizingPath;
}
- (NSString *) nameOrError4iTM3:(NSError**)errorRef;
{
	return [[self resourceValuesForKeys:[NSArray arrayWithObject:NSURLNameKey] error:errorRef] objectForKey:NSURLNameKey];
}
- (NSString *) localizedNameOrError4iTM3:(NSError**)errorRef;
{
	return [[self resourceValuesForKeys:[NSArray arrayWithObject:NSURLLocalizedNameKey] error:errorRef] objectForKey:NSURLLocalizedNameKey];
}
- (BOOL) isRegularFileOrError4iTM3:(NSError**)errorRef;
{
	return [[[self resourceValuesForKeys:[NSArray arrayWithObject:NSURLIsRegularFileKey] error:errorRef] objectForKey:NSURLIsRegularFileKey] boolValue];
}
- (BOOL) isDirectoryOrError4iTM3:(NSError**)errorRef;
{
	return [[[self resourceValuesForKeys:[NSArray arrayWithObject:NSURLIsDirectoryKey] error:errorRef] objectForKey:NSURLIsDirectoryKey] boolValue];
}
- (BOOL) isSymbolicLinkOrError4iTM3:(NSError**)errorRef;
{
	return [[[self resourceValuesForKeys:[NSArray arrayWithObject:NSURLIsSymbolicLinkKey] error:errorRef] objectForKey:NSURLIsSymbolicLinkKey] boolValue];
}
- (BOOL) isVolumeOrError4iTM3:(NSError**)errorRef;
{
	return [[[self resourceValuesForKeys:[NSArray arrayWithObject:NSURLIsVolumeKey] error:errorRef] objectForKey:NSURLIsVolumeKey] boolValue];
}
- (BOOL) isPackageOrError4iTM3:(NSError**)errorRef;
{
	return [[[self resourceValuesForKeys:[NSArray arrayWithObject:NSURLIsPackageKey] error:errorRef] objectForKey:NSURLIsPackageKey] boolValue];
}
- (BOOL) isSystemImmutableOrError4iTM3:(NSError**)errorRef;
{
	return [[[self resourceValuesForKeys:[NSArray arrayWithObject:NSURLIsSystemImmutableKey] error:errorRef] objectForKey:NSURLIsSystemImmutableKey] boolValue];
}
- (BOOL) isUserImmutableOrError4iTM3:(NSError**)errorRef;
{
	return [[[self resourceValuesForKeys:[NSArray arrayWithObject:NSURLIsUserImmutableKey] error:errorRef] objectForKey:NSURLIsUserImmutableKey] boolValue];
}
- (BOOL) isHiddenOrError4iTM3:(NSError**)errorRef;
{
	return [[[self resourceValuesForKeys:[NSArray arrayWithObject:NSURLIsHiddenKey] error:errorRef] objectForKey:NSURLIsHiddenKey] boolValue];
}
- (BOOL) hasHiddenExtensionOrError4iTM3:(NSError**)errorRef;
{
	return [[[self resourceValuesForKeys:[NSArray arrayWithObject:NSURLHasHiddenExtensionKey] error:errorRef] objectForKey:NSURLHasHiddenExtensionKey] boolValue];
}
- (NSDate *) creationDateOrError4iTM3:(NSError**)errorRef;
{
	return [[self resourceValuesForKeys:[NSArray arrayWithObject:NSURLCreationDateKey] error:errorRef] objectForKey:NSURLCreationDateKey];
}
- (NSDate *) contentAccessDateOrError4iTM3:(NSError**)errorRef;
{
	return [[self resourceValuesForKeys:[NSArray arrayWithObject:NSURLContentAccessDateKey] error:errorRef] objectForKey:NSURLContentAccessDateKey];
}
- (NSDate *) contentModificationDateOrError4iTM3:(NSError**)errorRef;
{
	return [[self resourceValuesForKeys:[NSArray arrayWithObject:NSURLContentModificationDateKey] error:errorRef] objectForKey:NSURLContentModificationDateKey];
}
- (NSDate *) attributeModificationDateOrError4iTM3:(NSError**)errorRef;
{
	return [[self resourceValuesForKeys:[NSArray arrayWithObject:NSURLAttributeModificationDateKey] error:errorRef] objectForKey:NSURLAttributeModificationDateKey];
}
- (NSUInteger) linkCountOrError4iTM3:(NSError**)errorRef;
{
	return [[[self resourceValuesForKeys:[NSArray arrayWithObject:NSURLLinkCountKey] error:errorRef] objectForKey:NSURLLinkCountKey] unsignedIntegerValue];
}
- (NSURL *) parentDirectoryURLOrError4iTM3:(NSError**)errorRef;
{
	return [[self resourceValuesForKeys:[NSArray arrayWithObject:NSURLParentDirectoryURLKey] error:errorRef] objectForKey:NSURLParentDirectoryURLKey];
}
- (NSURL *) volumeURLOrError4iTM3:(NSError**)errorRef;
{
	return [[self resourceValuesForKeys:[NSArray arrayWithObject:NSURLVolumeURLKey] error:errorRef] objectForKey:NSURLVolumeURLKey];
}
- (NSString *) typeIdentifierOrError4iTM3:(NSError**)errorRef;
{
	return [[self resourceValuesForKeys:[NSArray arrayWithObject:NSURLTypeIdentifierKey] error:errorRef] objectForKey:NSURLTypeIdentifierKey];
}
- (NSString *) localizedTypeDescriptionOrError4iTM3:(NSError**)errorRef;
{
	return [[self resourceValuesForKeys:[NSArray arrayWithObject:NSURLLocalizedTypeDescriptionKey] error:errorRef] objectForKey:NSURLLocalizedTypeDescriptionKey];
}
- (NSUInteger) labelNumberOrError4iTM3:(NSError**)errorRef;
{
	return [[[self resourceValuesForKeys:[NSArray arrayWithObject:NSURLLabelNumberKey] error:errorRef] objectForKey:NSURLLabelNumberKey] unsignedIntegerValue];
}
- (NSColor *) labelColorOrError4iTM3:(NSError**)errorRef;
{
	return [[self resourceValuesForKeys:[NSArray arrayWithObject:NSURLLabelColorKey] error:errorRef] objectForKey:NSURLLabelColorKey];
}
- (NSString *) localizedLabelOrError4iTM3:(NSError**)errorRef;
{
	return [[self resourceValuesForKeys:[NSArray arrayWithObject:NSURLLocalizedLabelKey] error:errorRef] objectForKey:NSURLLocalizedLabelKey];
}
- (NSImage *) effectiveIconOrError4iTM3:(NSError**)errorRef;
{
	return [[self resourceValuesForKeys:[NSArray arrayWithObject:NSURLEffectiveIconKey] error:errorRef] objectForKey:NSURLEffectiveIconKey];
}
- (NSImage *) customIconOrError4iTM3:(NSError**)errorRef;
{
	return [[self resourceValuesForKeys:[NSArray arrayWithObject:NSURLCustomIconKey] error:errorRef] objectForKey:NSURLCustomIconKey];
}

/* File Properties 
*/
- (NSUInteger) fileSizeOrError4iTM3:(NSError**)errorRef;
{
	return [[[self resourceValuesForKeys:[NSArray arrayWithObject:NSURLFileSizeKey] error:errorRef] objectForKey:NSURLFileSizeKey] unsignedIntegerValue];
}
- (NSUInteger) fileAllocatedSizeOrError4iTM3:(NSError**)errorRef;
{
	return [[[self resourceValuesForKeys:[NSArray arrayWithObject:NSURLFileAllocatedSizeKey] error:errorRef] objectForKey:NSURLFileAllocatedSizeKey] unsignedIntegerValue];
}
- (BOOL) isAliasFileOrError4iTM3:(NSError**)errorRef;
{
	return [[[self resourceValuesForKeys:[NSArray arrayWithObject:NSURLIsAliasFileKey] error:errorRef] objectForKey:NSURLIsAliasFileKey] boolValue];
}

/* Volume Properties

As a convenience, volume properties can be requested from any file system URL. The value returned will reflect the property value for the volume on which the resource is located.
*/
- (NSString *) volumeLocalizedFormatDescriptionOrError4iTM3:(NSError**)errorRef;
{
	return [[self resourceValuesForKeys:[NSArray arrayWithObject:NSURLVolumeLocalizedFormatDescriptionKey] error:errorRef] objectForKey:NSURLVolumeLocalizedFormatDescriptionKey];
}
- (NSUInteger) volumeTotalCapacityOrError4iTM3:(NSError**)errorRef;
{
	return [[[self resourceValuesForKeys:[NSArray arrayWithObject:NSURLVolumeTotalCapacityKey] error:errorRef] objectForKey:NSURLVolumeTotalCapacityKey] unsignedIntegerValue];
}
- (NSUInteger) volumeAvailableCapacityOrError4iTM3:(NSError**)errorRef;
{
	return [[[self resourceValuesForKeys:[NSArray arrayWithObject:NSURLVolumeAvailableCapacityKey] error:errorRef] objectForKey:NSURLVolumeAvailableCapacityKey] unsignedIntegerValue];
}
- (NSUInteger) volumeResourceCountOrError4iTM3:(NSError**)errorRef;
{
	return [[[self resourceValuesForKeys:[NSArray arrayWithObject:NSURLVolumeResourceCountKey] error:errorRef] objectForKey:NSURLVolumeResourceCountKey] unsignedIntegerValue];
}
#if 0
- (BOOL) volumeSupportsPersistentIDsOrError4iTM3:(NSError**)errorRef;
{
	return [[[self resourceValuesForKeys:[NSArray arrayWithObject:NSURLVolumeSupportsPersistentIDsKey] error:errorRef] objectForKey:NSURLVolumeSupportsPersistentIDsKey] boolValue];
}
- (BOOL) volumeSupportsSymbolicLinksOrError4iTM3:(NSError**)errorRef;
{
	return [[[self resourceValuesForKeys:[NSArray arrayWithObject:NSURLVolumeSupportsSymbolicLinksKey] error:errorRef] objectForKey:NSURLVolumeSupportsSymbolicLinksKey] boolValue];
}
- (BOOL) volumeSupportsHardLinksOrError4iTM3:(NSError**)errorRef;
{
	return [[[self resourceValuesForKeys:[NSArray arrayWithObject:NSURLVolumeSupportsHardLinksKey] error:errorRef] objectForKey:NSURLVolumeSupportsHardLinksKey] boolValue];
}
- (BOOL) volumeSupportsJournalingOrError4iTM3:(NSError**)errorRef;
{
	return [[[self resourceValuesForKeys:[NSArray arrayWithObject:NSURLVolumeSupportsJournalingKey] error:errorRef] objectForKey:NSURLVolumeSupportsJournalingKey] boolValue];
}
- (BOOL) volumeIsJournalingOrError4iTM3:(NSError**)errorRef;
{
	return [[[self resourceValuesForKeys:[NSArray arrayWithObject:NSURLVolumeIsJournalingKey] error:errorRef] objectForKey:NSURLVolumeIsJournalingKey] boolValue];
}
- (BOOL) volumeSupportsSparseFilesOrError4iTM3:(NSError**)errorRef;
{
	return [[[self resourceValuesForKeys:[NSArray arrayWithObject:NSURLVolumeSupportsSparseFilesKey] error:errorRef] objectForKey:NSURLVolumeSupportsSparseFilesKey] boolValue];
}
- (BOOL) volumeSupportsZeroRunsOrError4iTM3:(NSError**)errorRef;
{
	return [[[self resourceValuesForKeys:[NSArray arrayWithObject:NSURLVolumeSupportsZeroRunsKey] error:errorRef] objectForKey:NSURLVolumeSupportsZeroRunsKey] boolValue];
}
- (BOOL) volumeSupportsCaseSensitiveNamesOrError4iTM3:(NSError**)errorRef;
{
	return [[[self resourceValuesForKeys:[NSArray arrayWithObject:NSURLVolumeSupportsCaseSensitiveNamesKey] error:errorRef] objectForKey:NSURLVolumeSupportsCaseSensitiveNamesKey] boolValue];
}
- (BOOL) volumeSupportsCasePreservedNamesOrError4iTM3:(NSError**)errorRef;
{
	return [[[self resourceValuesForKeys:[NSArray arrayWithObject:NSURLVolumeSupportsCasePreservedNamesKey] error:errorRef] objectForKey:NSURLVolumeSupportsCasePreservedNamesKey] boolValue];
}
#endif
@end

@implementation NSArray(iTM2PathUtilities)
- (BOOL)containsURL4iTM3:(NSURL *)url;
{
	return [url isKindOfClass:[NSURL class]]
		&& [[self valueForKeyPath:@"absoluteURL.standardizedURL"] containsObject:url.absoluteURL.standardizedURL];
}
- (NSArray *)arrayWithCommon1stObjectsOfArray4iTM3:(NSArray *)array;
{
	NSEnumerator * E1 = self.objectEnumerator;
	id O1 = nil;
	NSEnumerator * E2 = array.objectEnumerator;
	id O2 = nil;
	NSMutableArray * result = [NSMutableArray array];
	while ((O1=[E1 nextObject])&&(O2=[E2 nextObject])&&[O1 isEqual:O2]) {
		[result addObject:O1];
	}
	return result;
}
@end

NSString * const iTM2PATHDomainX11BinariesKey = @"iTM2PATHX11Binaries";
NSString * const iTM2PATHPrefixKey = @"iTM2PATHPrefix";
NSString * const iTM2PATHSuffixKey = @"iTM2PATHSuffix";

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2PATHServer
/*"A SUD declarator."*/
@implementation iTM2PATHServer
@end

@implementation iTM2MainInstaller(PathUtilities)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2PathUtilitiesCompleteInstallation4iTM3
+ (void)iTM2PathUtilitiesCompleteInstallation4iTM3;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{//DIAGNOSTIC4iTM3;
//START4iTM3;
	[SUD registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:
		@"/usr/X11R6/bin:/usr/bin/X11:/usr/local/bin/X11", iTM2PATHDomainX11BinariesKey,
		@"", iTM2PATHPrefixKey,
		@"", iTM2PATHSuffixKey,
			nil]];

    return;
}
+ (void) preparePathUtilitiesCompleteInstallation4iTM3;
{
	if ([NSURL swizzleInstanceMethodSelector4iTM3:@selector(SWZ_iTM2ProjectDocumentKit_initWithCoder:) error:NULL]) {
		MILESTONE4iTM3((@"NSURL(iTM2PathUtilities)"),(@"Program inconsistancy"));
	}
}
@end
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2PATHServer
