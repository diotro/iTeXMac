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


#import <Carbon/Carbon.h>
#import <iTM2Foundation/iTM2PathUtilities.h>
#import <iTM2Foundation/iTM2BundleKit.h>
#import <iTM2Foundation/iTM2RuntimeBrowser.h>

NSString * const iTM2PathComponentsSeparator = @"/";
NSString * const iTM2PathDotComponent = @".";

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= 
/*"Description forthcoming."*/
@implementation NSString(iTM2PathUtilities)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2_isFinderAliasTraverseLink:isDirectory:
- (BOOL)iTM2_isFinderAliasTraverseLink:(BOOL)aFlag isDirectory:(BOOL *)isDirectory;
/*"Returns YES if the receiver is a Finder Alias.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
    self = [self stringByStandardizingPath];
//NSLog(@"introspecting %@", self);
    if([[[DFM fileAttributesAtPath:self traverseLink:aFlag] fileType]
        isEqualToString: NSFileTypeRegular])
    {
        FSRef fileSystemRef;
        int error = FSPathMakeRef( (UInt8 *)[DFM fileSystemRepresentationWithPath:self],
                        &fileSystemRef, (Boolean *)isDirectory );
        if(error == noErr)
        {
            BOOL aliasFileFlag;
            BOOL safeIsDirectory;
            if(!isDirectory)
                isDirectory = &safeIsDirectory;
            error = FSIsAliasFile ( &fileSystemRef, (Boolean *)&aliasFileFlag, (Boolean *)isDirectory );
            if(error == noErr)
                return aliasFileFlag;
            else
			{
                iTM2_LOG(@"FSIsAliasFile error: %d.", error);
			}
        }
        iTM2_LOG(@"FSPathMakeRef error: %d.", error);
    }
    return NO;
}
/*
OSStatus FSPathMakeRef ( const UInt8 *path, FSRef *ref, Boolean *isDirectory );
OSStatus FSRefMakePath ( const FSRef *ref, UInt8 *path, UInt32 pathSize );
 OSErr FSIsAliasFile ( const FSRef *fileRef, Boolean *aliasFileFlag, Boolean *folderFlag ); 
*/
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2_stringByResolvingFinderAliasesInPath
- (NSString *)iTM2_stringByResolvingFinderAliasesInPath;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
    NSString * path = self;
    NSMutableArray * PCs = [NSMutableArray array];
    borabora:
    if([DFM fileExistsAtPath:path])
    {
        NSString *resolvedPath;
        moorea:
        resolvedPath = nil;
        CFURLRef url = CFURLCreateWithFileSystemPath(NULL , (CFStringRef)path, kCFURLPOSIXPathStyle, NO);
        if(url)
        {
            FSRef fsRef;
            if(CFURLGetFSRef(url, &fsRef))
            {
                Boolean targetIsFolder, wasAliased;
                int error = 0;
                if(error = FSResolveAliasFile (&fsRef, true , &targetIsFolder, &wasAliased))
                {
                    iTM2_LOG(@"FSResolveAliasFile error: %d.", error);
                    return self;
                }
                else
                {
                    if(wasAliased)
                    {
                        CFURLRef resolvedUrl = CFURLCreateFromFSRef(NULL, &fsRef);
                        if(resolvedUrl != NULL)
                        {
                            resolvedPath = (NSString*) CFURLCopyFileSystemPath(resolvedUrl, kCFURLPOSIXPathStyle);
							[resolvedPath autorelease];
                            CFRelease(resolvedUrl);
                        }
                        else
                        {
                            iTM2_LOG(@"CFURLCreateFromFSRef error.");
                            return self;
                        }
                    }
                    else
                        resolvedPath = path;
                }
            }
            CFRelease(url);
        }
        if(!resolvedPath)
        {
//NSLog(@"3: %@, %@", path, PCs);
            return self;
        }
        else if([PCs count])
        {
            path = [resolvedPath stringByAppendingPathComponent:[PCs lastObject]];
            [PCs removeLastObject];
            if([DFM fileExistsAtPath:path])
				goto moorea;
            else
            {
//NSLog(@"2: %@, %@", path, PCs);
                return self;
            }
        }
        else
            return resolvedPath;
    }
    else
    {
        [PCs addObject:[path lastPathComponent]];
        path = [path stringByDeletingLastPathComponent];
        if([path length])
            goto borabora;
        else
        {
//NSLog(@"1: %@, %@", path, PCs);
            return self;
        }
    }
}
static NSMutableDictionary * lazyStringByResolvingSymlinksAndFinderAliasesInPath_cache = nil;
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2_lazyStringByResolvingSymlinksAndFinderAliasesInPath
- (NSString *)iTM2_lazyStringByResolvingSymlinksAndFinderAliasesInPath;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
	if(!lazyStringByResolvingSymlinksAndFinderAliasesInPath_cache)
	{
		lazyStringByResolvingSymlinksAndFinderAliasesInPath_cache = [[NSMutableDictionary dictionary] retain];
	}
    NSString * result = [lazyStringByResolvingSymlinksAndFinderAliasesInPath_cache objectForKey:self];
	if(result)
	{
		return result;
	}
	return [self iTM2_stringByResolvingSymlinksAndFinderAliasesInPath];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2_stringByResolvingSymlinksAndFinderAliasesInPath
- (NSString *)iTM2_stringByResolvingSymlinksAndFinderAliasesInPath;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
	if(!lazyStringByResolvingSymlinksAndFinderAliasesInPath_cache)
	{
		lazyStringByResolvingSymlinksAndFinderAliasesInPath_cache = [[NSMutableDictionary dictionary] retain];
	}
    NSString * result = self;
	NSString * temp = nil;
    int firewall = 257;
    do
    {
        temp = result;
        result = [temp stringByResolvingSymlinksInPath];
        result = [result stringByStandardizingPath];
        result = [result iTM2_stringByResolvingFinderAliasesInPath];
    }
    while((--firewall>0) && ![result iTM2_pathIsEqual:temp]);
	[lazyStringByResolvingSymlinksAndFinderAliasesInPath_cache setObject:result forKey:self];
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2_stringByAbbreviatingWithDotsRelativeToDirectory:
- (NSString *)iTM2_stringByAbbreviatingWithDotsRelativeToDirectory:(NSString *)aPath;
/*"It is not strong: the sender is responsible of the arguments, if they do not represent directory paths, the shame on it.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
    self = [self iTM2_stringByNormalizingPath];
    aPath = [aPath iTM2_stringByNormalizingPath];
    if([self length] && [aPath length] && ([self characterAtIndex:0]=='/') && ([aPath characterAtIndex:0]=='/'))
    {
        NSArray * myComponents = [self pathComponents];
        NSArray * pathComponents = [aPath pathComponents];
        // common part
        int commonIdx = 0, index = 0;
        int bound = MIN([myComponents count], [pathComponents count]);
        while((commonIdx < bound) &&
            [[myComponents objectAtIndex:commonIdx] iTM2_pathIsEqual:[pathComponents objectAtIndex:commonIdx]])
                ++commonIdx;
        index = commonIdx;
        self = [NSString string];
		NSMutableArray * components = [NSMutableArray array];
        while(index < [pathComponents count])
		{
			NSString * component = [pathComponents objectAtIndex:index++];
			if(![component isEqual:iTM2PathComponentsSeparator] && ![component isEqual:@""])
			{
				[components addObject:@".."];
			}
		}
        index = commonIdx;
        while(index < [myComponents count])
			[components addObject:[myComponents objectAtIndex:index++]];
		self = [NSString iTM2_pathWithComponents:components];
    }
    return [self length]?self:@".";
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2_shortestStringByAbbreviatingWithTildeInPath
- (NSString *)iTM2_shortestStringByAbbreviatingWithTildeInPath;
/*"In between the receiver and the path abbreviated with tilde, return the shortest one.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
    NSString * S = [self stringByAbbreviatingWithTildeInPath];
    return ([S length]<[self length]? S:self);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2_stringByNormalizingPath
- (NSString *)iTM2_stringByNormalizingPath;
/*"In between the receiver and the path abbreviated with tilde, return the shortest one.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSMutableArray * components = [NSMutableArray arrayWithArray:[self pathComponents]];
	unsigned index = 1;
	while(index<[components count])
	{
		NSString * component = [components objectAtIndex:index];
		if([component isEqualToString:@"."])
		{
			[components removeObjectAtIndex:index];
		}
		else if([component isEqualToString:@".."])
		{
			component = [components objectAtIndex:index-1];
			if(![component isEqualToString:iTM2PathComponentsSeparator])
			{
				[components removeObjectAtIndex:index];// the object at index is the first unread, if any
				[components removeObjectAtIndex:--index];// the object at index is now the first unread, if any
			}
		}
		else
		{
			++index;
		}
	}
//iTM2_END;
    return [NSString iTM2_pathWithComponents:components];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2_stringByDeletingAllPathExtensions
- (NSString *)iTM2_stringByDeletingAllPathExtensions;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
    unsigned newLength = [self length], length = 0;
    do
    {
        length = newLength;
        self = [self stringByDeletingPathExtension];
        newLength = [self length];
    }
    while(newLength<length);
    return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2_enclosingDirectoryForFileNames:
+ (NSString*)iTM2_enclosingDirectoryForFileNames:(NSArray *)fileNames;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 06/01/03
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSMutableDictionary * tree = [NSMutableDictionary dictionary];// this will contain the partial file hierarchy of the project files
	// Getting the directory where all the files are stored
	NSString * path = nil;
	for(path in fileNames)
	{
		NSMutableDictionary * subtree = tree;
		path = [path stringByDeletingLastPathComponent];
		NSArray * pathComponents = [path pathComponents];
		NSEnumerator * e = [pathComponents objectEnumerator];
		while(path = [e nextObject])
		{
			NSMutableDictionary * md = [subtree objectForKey:path];
			if([md count]>1)
			{
				// no need to go further
				break;
			}
			else if(!md)
			{
				[subtree setObject:[NSMutableDictionary dictionary] forKey:path];
				md = [subtree objectForKey:path];
			}
			subtree = md;
		}
	}
	NSMutableArray * commonComponents = [NSMutableArray array];
	while([tree count] == 1)
	{
		NSString * key = [[tree allKeys] lastObject];
		[commonComponents addObject:key];
		tree = [tree objectForKey:key];
	}
//iTM2_END;
	return [NSString iTM2_pathWithComponents:commonComponents];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2_isEqualToFileName:
- (BOOL)iTM2_isEqualToFileName:(NSString *)otherFileName;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 06/01/03
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	return [self iTM2_pathIsEqual:otherFileName];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2_pathIsEqual:
- (BOOL)iTM2_pathIsEqual:(NSString *)otherPath;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 06/01/03
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;

	if([otherPath respondsToSelector:@selector(lowercaseString)])
	{
		self = [self lowercaseString];
		self = [self stringByStandardizingPath];
		otherPath = [otherPath lowercaseString];
		otherPath = [otherPath stringByStandardizingPath];
		return [self compare:otherPath] == NSOrderedSame;
	}
	return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2_belongsToDirectory:
- (BOOL)iTM2_belongsToDirectory:(NSString *)dirName;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 06/01/03
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSArray * myComponents = [self pathComponents];
	NSEnumerator * myE = [myComponents objectEnumerator];
	NSArray * itsComponents = [dirName pathComponents];
	NSEnumerator * itsE = [itsComponents objectEnumerator];
	NSString * component = nil;
	if(component = [itsE nextObject])
	{
		do
		{
			if(![component iTM2_pathIsEqual:[myE nextObject]])
			{
				return NO;
			}
		}
		while(component = [itsE nextObject]);
		return YES;
	}
//iTM2_END;
	return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2_absolutePathWithPath:base:
+ (NSString *)iTM2_absolutePathWithPath:(NSString *)path base:(NSString *)base;
/*"Description forthcoming.
 Version history: jlaurens AT users DOT sourceforge DOT net
 - 2.0: 06/01/03
 To Do List:
 "*/
{iTM2_DIAGNOSTIC;
	//iTM2_START;
	if([path hasPrefix:iTM2PathComponentsSeparator])
	{
		return path;
	}
	NSURL * baseURL = [NSURL fileURLWithPath:base];
	path = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	NSURL * fileURL = [NSURL URLWithString:path relativeToURL:baseURL];
	//iTM2_END;
	return [fileURL iTM2_path];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2_pathWithComponents:
+ (NSString *)iTM2_pathWithComponents:(NSArray *)components;
/*"Description forthcoming.
 Version history: jlaurens AT users DOT sourceforge DOT net
 - 2.0: 06/01/03
 To Do List:
 "*/
{iTM2_DIAGNOSTIC;
	//iTM2_START;
	NSString * result = [self pathWithComponents:components];
	if(([[components lastObject] isEqual:@""] || [[components lastObject] isEqual:iTM2PathComponentsSeparator])
	   && ![result hasSuffix:iTM2PathComponentsSeparator])
	{
		result = [result stringByAppendingString:iTM2PathComponentsSeparator];
	}
	//iTM2_END;
	return result;
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
	if(!iTM2URLSingletons){
		iTM2URLSingletons = [[NSMutableDictionary dictionary] retain];
	}
	return;
}
- (id)copyWithZone:(NSZone *)zone;
{
	return [self retain];
}
- initWithScheme:(NSString *)scheme host:(NSString *)host path:(NSString *)path;
{
	NSParameterAssert([path length]);
	if(self = [super initWithScheme:scheme host:host path:path])
	{
		NSString * key = [self absoluteString];
		NSURL * singleton = [iTM2URLSingletons objectForKey:key];
		if(singleton)
		{
			[self autorelease];// maybe self == singleton
			return [singleton retain];
		}
		[iTM2URLSingletons setObject:self forKey:key];
	}
	return self;
}
- initWithString:(NSString *)URLString;
{
	NSParameterAssert([URLString length]);
	if(self = [super initWithString:URLString])
	{
		NSString * key = [self absoluteString];
		NSURL * singleton = [iTM2URLSingletons objectForKey:key];
		if(singleton)
		{
			[self autorelease];// maybe self == singleton
			return [singleton retain];
		}
		[iTM2URLSingletons setObject:self forKey:key];
	}
	return self;
}
- initWithString:(NSString *)URLString relativeToURL:(NSURL *)baseURL;
{
	NSParameterAssert([URLString length]);
	if(self = [super initWithString:URLString relativeToURL:baseURL])
	{
		NSString * key = [self absoluteString];
		NSURL * singleton = [iTM2URLSingletons objectForKey:key];
		if(singleton)
		{
			[self autorelease];// maybe self == singleton
			return [singleton retain];
		}
		[iTM2URLSingletons setObject:self forKey:key];
	}
	return self;
}
- initFileURLWithPath:(NSString *)path;
{
	NSParameterAssert([path length]);
	if(self = [super initFileURLWithPath:path])
	{
		NSString * key = [self absoluteString];
		NSURL * singleton = [iTM2URLSingletons objectForKey:key];
		if(singleton)
		{
			[self autorelease];// maybe self == singleton
			return [singleton retain];
		}
		[iTM2URLSingletons setObject:self forKey:key];
	}
	return self;
}
@end

#import <iTM2Foundation/iTM2BundleKit.h>

NSString * const iTM2PathFactoryComponent = @"Factory.localized";

@implementation NSURL(iTM2PathUtilities)
- (NSString *)iTM2_path;
{iTM2_DIAGNOSTIC;
	//iTM2_START;
	NSString * myPath = [[self path] stringByStandardizingPath];
	BOOL isDirectory;
	if([DFM fileExistsAtPath:myPath isDirectory:&isDirectory] && isDirectory && ![myPath hasSuffix:@"/"])
	{
		myPath = [myPath stringByAppendingString:@"/"];
	}
	//iTM2_END;
	return myPath;
}
+ (id)iTM2_URLWithPath:(NSString *)path relativeToURL:(NSURL *)baseURL;
{iTM2_DIAGNOSTIC;
	//iTM2_START;
	//iTM2_END;
	if([path hasPrefix:iTM2PathComponentsSeparator])
	{
		baseURL = [NSURL iTM2_rootURL];
		path = [path iTM2_stringByAbbreviatingWithDotsRelativeToDirectory:NSOpenStepRootDirectory()];
	}
	else if(!baseURL)
	{
		baseURL = [NSURL fileURLWithPath:NSOpenStepRootDirectory()];
	}
	return path.length?
	[self URLWithString:[path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] relativeToURL:baseURL]:
	baseURL;
}
- (BOOL)iTM2_isEquivalentToURL:(NSURL *)otherURL;
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSURL * lhURL = [self absoluteURL];
	NSURL * rhURL = [otherURL absoluteURL];
//iTM2_END;
	return [lhURL isEqual:rhURL];
}
- (NSURL *)iTM2_parentDirectoryURL;
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSURL * result = [[NSURL URLWithString:@".." relativeToURL:self] standardizedURL];
//iTM2_END;
	return [[result resourceSpecifier] hasSuffix:@".."]?nil:result;
}
- (NSURL *)iTM2_URLByDeletingPathExtension;
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSURL * baseURL = [self baseURL];
	NSString * relativePath = nil;
	if(baseURL)
	{
		relativePath = [self relativePath];
		relativePath = [relativePath stringByDeletingPathExtension];
		return [NSURL iTM2_URLWithPath:relativePath relativeToURL:baseURL];
	}
	relativePath = [self relativePath];
	relativePath = [relativePath stringByDeletingPathExtension];
	return [NSURL iTM2_URLWithPath:relativePath relativeToURL:nil];
//iTM2_END;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2_isEqualToFileURL:
- (BOOL)iTM2_isEqualToFileURL:(NSURL *)otherURL;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 06/01/03
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	if([self isFileURL] && [otherURL isFileURL])
	{
		NSString * myPath = [[self path] stringByStandardizingPath];
		NSString * otherPath = [[otherURL path] stringByStandardizingPath];
		return [myPath iTM2_pathIsEqual:otherPath];
	}
	return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2_isRelativeToURL:
- (BOOL)iTM2_isRelativeToURL:(NSURL *)otherURL;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 06/01/03
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	NSString * myPath = [[self path] stringByStandardizingPath];
	NSString * otherPath = [[otherURL path] stringByStandardizingPath];
	return [myPath iTM2_belongsToDirectory:otherPath];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2_pathRelativeToURL:
- (NSString *)iTM2_pathRelativeToURL:(NSURL *)otherURL;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 06/01/03
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	NSParameterAssert(otherURL);
	NSString * otherPath = [otherURL iTM2_path];
	NSString * myPath = [self iTM2_path];
	NSString * result = [myPath iTM2_stringByAbbreviatingWithDotsRelativeToDirectory:otherPath];
	if(![self iTM2_isEquivalentToURL:[NSURL iTM2_URLWithPath:result relativeToURL:otherURL]])
	{
		iTM2_LOG(@"HERE");
	}
	NSAssert([self iTM2_isEquivalentToURL:[NSURL iTM2_URLWithPath:result relativeToURL:otherURL]],@"**** HUGE ERROR: the operation is not revertible!");
	return result;
}
+ (void)load;
{
	iTM2_INIT_POOL;
	NSAssert([self iTM2_swizzleInstanceMethodSelector:@selector(SWZ_iTM2ProjectDocumentKit_initWithCoder:)],@"Program inconsistancy");
	//[NSURL iTM2_factoryURL];// cache the result, just in case initWithCoder: would need it
	iTM2_RELEASE_POOL;
	return;
}
- (id)SWZ_iTM2ProjectDocumentKit_initWithCoder:(NSCoder *)aDecoder;
{
	NSURL * url = [self SWZ_iTM2ProjectDocumentKit_initWithCoder:aDecoder];
	// if a singleton URL has already been created with that same absolute URL, then use it.
	NSURL * singleton = [iTM2URLSingletons objectForKey:[url absoluteString]];
	return singleton?[singleton retain]:url;
}
+ (NSURL *)iTM2_rootURL;
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * K = NSStringFromSelector(_cmd);
	iTM2URLSingleton * url = [iTM2URLSingletons objectForKey:K];
	if(!url)
	{
		NSString * path = @"/";
		url = [iTM2URLSingleton fileURLWithPath:path];
		[iTM2URLSingletons setObject:url forKey:K];
	}
	return url;
}
+ (NSURL *)iTM2_volumesURL;
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * K = NSStringFromSelector(_cmd);
	iTM2URLSingleton * url = [iTM2URLSingletons objectForKey:K];
	if(!url)
	{
		NSString * volumes = @"Volumes";
		url = [NSURL iTM2_URLWithPath:volumes relativeToURL:[self iTM2_rootURL]];
		[iTM2URLSingletons setObject:url forKey:K];
	}
	return url;
}
+ (NSArray *)iTM2_volumeURLs;
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSMutableArray * urls = [NSMutableArray array];
	NSURL * volumesURL = [self iTM2_volumesURL];
	NSEnumerator * E = [[DFM directoryContentsAtPath:[volumesURL path]] objectEnumerator];
	NSString * component;
	while(component = [E nextObject])
	{
		[urls addObject:[NSURL iTM2_URLWithPath:component relativeToURL:volumesURL]];
	}
	return urls;
}
+ (NSURL *)iTM2_userURL;
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * K = NSStringFromSelector(_cmd);
	iTM2URLSingleton * url = [iTM2URLSingletons objectForKey:K];
	if(!url)
	{
		url = [iTM2URLSingleton fileURLWithPath:NSHomeDirectory()];
		NSEnumerator * E = [[NSURL iTM2_volumeURLs] objectEnumerator];
		NSURL * baseURL = nil;
		NSString * relative = nil;
		while(baseURL = [E nextObject])
		{
			if([url iTM2_isRelativeToURL:baseURL])
			{
				relative = [url iTM2_pathRelativeToURL:baseURL];
				url = [NSURL iTM2_URLWithPath:relative relativeToURL:baseURL];
				goto url_is_normalized;
			}
		}
		baseURL = [self iTM2_rootURL];
		if([url iTM2_isRelativeToURL:baseURL])
		{
			relative = [url iTM2_pathRelativeToURL:baseURL];
			url = [NSURL iTM2_URLWithPath:relative relativeToURL:baseURL];
		}
url_is_normalized:
		[iTM2URLSingletons setObject:url forKey:K];
	}
	return url;
}
+ (NSURL *)iTM2_factoryURL;
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * K = NSStringFromSelector(_cmd);
	iTM2URLSingleton * url = [iTM2URLSingletons objectForKey:K];
	if([url isEqual:[NSNull null]])
	{
		return nil;
	}
	if(!url)
	{
		[iTM2URLSingletons setObject:[NSNull null] forKey:K];
		NSString * path = [[NSBundle mainBundle] iTM2_pathForSupportDirectory:iTM2PathFactoryComponent inDomain:NSUserDomainMask create:YES];
		NSMutableDictionary * attributes = [NSMutableDictionary dictionaryWithDictionary:[DFM fileAttributesAtPath:path traverseLink:NO]];
		[attributes setObject:[NSNumber numberWithBool:YES] forKey:NSFileExtensionHidden];
		[DFM changeFileAttributes:attributes atPath:path];
		url = [iTM2URLSingleton fileURLWithPath:path];// this should be a writable directory
		[iTM2URLSingletons setObject:[url iTM2_normalizedURL] forKey:K];
	}
	return url;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2_normalizedURL
- (NSURL *)iTM2_normalizedURL;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.1: Sun May  4 14:43:54 UTC 2008
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSURL * url = [self baseURL];
	NSString * relative = nil;
	if(url)
	{
		url = [url iTM2_normalizedURL];
		relative = [self relativePath];
normalize_and_return:
		url = [relative length]?[NSURL iTM2_URLWithPath:relative relativeToURL:url]:url;
		return [self isEqual:url]?self:url;
	}
	url = [NSURL iTM2_factoryURL];
	if([self iTM2_isRelativeToURL:url])
	{
set_relative:
		relative = [self iTM2_pathRelativeToURL:url];
//iTM2_END;
		goto normalize_and_return;
	}
	url = [NSURL iTM2_userURL];
	if([self iTM2_isRelativeToURL:url])
	{
		goto set_relative;
	}
	// separate the /Volume/name
	NSEnumerator * E = [[NSURL iTM2_volumeURLs] objectEnumerator];
	while(url = [E nextObject])
	{
		if([self iTM2_isRelativeToURL:url])
		{
			goto set_relative;
		}
	}
	url = [NSURL iTM2_rootURL];
	if([self iTM2_isRelativeToURL:url])
	{
		goto set_relative;
	}
//iTM2_END;
	return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2_URLByRemovingFactoryBaseURL
- (NSURL *)iTM2_URLByRemovingFactoryBaseURL;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
NOT YET VERIFIED
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	// this message makes sense for file URLs only
	if(![self isFileURL])
	{
		return self;
	}
	if([self isEqual:[NSURL iTM2_factoryURL]])
	{
		return [NSURL iTM2_rootURL];
	}
	NSURL * baseURL = [self baseURL];
	if(baseURL)
	{
		NSURL * newBaseURL = [baseURL iTM2_URLByRemovingFactoryBaseURL];
		if([baseURL isEqual:newBaseURL])
		{
	//iTM2_END;
			return self;
		}
		return [NSURL URLWithString:[self relativeString] relativeToURL:newBaseURL];
	}
	else if([self iTM2_isRelativeToURL:[NSURL iTM2_factoryURL]])
	{
		// OK, there is no base URL, but it does not mean that the receiver does not belong
		// to the Writable Projects directory.
		// This can be the case if 3rd parties have created this URL without conforming to
		// the rules (namely cocoa)
		NSString * relative2 = [self iTM2_pathRelativeToURL:[NSURL iTM2_factoryURL]];
		return [[NSURL iTM2_URLWithPath:relative2 relativeToURL:[NSURL iTM2_rootURL]] iTM2_normalizedURL];
	}
	return self;
//iTM2_END;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2_URLByPrependingFactoryBaseURL
- (NSURL *)iTM2_URLByPrependingFactoryBaseURL;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.1: Tue May  6 13:58:26 UTC 2008
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	// this message makes sense for file URLs only
	if(![self isFileURL])
	{
//iTM2_END;
		return self;
	}
	NSURL * baseURL = [self baseURL];
	if(!baseURL)
	{
		// OK, there is no base URL, but it does not mean that the receiver does not belong
		// to the Factory directory.
		// This can be the case if 3rd parties have created this URL without conforming to
		// the rules (namely cocoa)
		if([self iTM2_belongsToFactory])
		{
			return [self iTM2_normalizedURL];
		}
		NSString * relative = [self relativePath];
		relative = [[@"." stringByAppendingPathComponent:relative] stringByStandardizingPath];
		NSURL * url = [NSURL iTM2_URLWithPath:relative relativeToURL:[NSURL iTM2_factoryURL]];
		return [self isEqual:url]?url:self;
	}
	NSURL * newBaseURL = [baseURL iTM2_URLByPrependingFactoryBaseURL];
	if([baseURL isEqual:newBaseURL])
	{
//iTM2_END;
		return self;
	}
//iTM2_END;
	return [NSURL URLWithString:[self relativeString] relativeToURL:newBaseURL];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2_belongsToFactory
- (BOOL)iTM2_belongsToFactory;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
NOT YET VERIFIED
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(![self isFileURL])
	{
		return NO;
	}
	NSURL * url= [self baseURL];
	if(url)
	{
		return [url iTM2_belongsToFactory];
	}
	url = [self iTM2_URLByRemovingFactoryBaseURL];
//iTM2_END;
	return ![self iTM2_isEquivalentToURL:url];
}
@end

@implementation NSArray(iTM2PathUtilities)
- (BOOL)iTM2_containsURL:(NSURL *)url;
{
	return [url isKindOfClass:[NSURL class]]
		&& [[self valueForKey:@"absoluteURL"] containsObject:[url absoluteURL]];
}
@end

NSString * const iTM2PATHDomainX11BinariesKey = @"iTM2PATHX11Binaries";
NSString * const iTM2PATHPrefixKey = @"iTM2PATHPrefix";
NSString * const iTM2PATHSuffixKey = @"iTM2PATHSuffix";

#import <iTM2Foundation/iTM2InstallationKit.h>
#import <iTM2Foundation/iTM2Implementation.h>
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2PATHServer
/*"A SUD declarator."*/
@implementation iTM2PATHServer
@end

@implementation iTM2MainInstaller(iTM2PathUtilities)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2PathUtilitiesCompleteInstallation
+ (void)iTM2PathUtilitiesCompleteInstallation;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[SUD registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:
		@"/usr/X11R6/bin:/usr/bin/X11:/usr/local/bin/X11", iTM2PATHDomainX11BinariesKey,
		@"", iTM2PATHPrefixKey,
		@"", iTM2PATHSuffixKey,
			nil]];

    return;
}
@end
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2PATHServer
