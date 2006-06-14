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

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= 
/*"Description forthcoming."*/
@implementation NSString(iTM2PathUtilities)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= isFinderAliasTraverseLink:isDirectory:
- (BOOL) isFinderAliasTraverseLink: (BOOL) aFlag isDirectory: (BOOL *) isDirectory;
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
                NSLog(@"%@ FSIsAliasFile error: %d.", __PRETTY_FUNCTION__, error);
        }
        NSLog(@"%@ FSPathMakeRef error: %d.", __PRETTY_FUNCTION__, error);
    }
    return NO;
}
/*
OSStatus FSPathMakeRef ( const UInt8 *path, FSRef *ref, Boolean *isDirectory );
OSStatus FSRefMakePath ( const FSRef *ref, UInt8 *path, UInt32 pathSize );
 OSErr FSIsAliasFile ( const FSRef *fileRef, Boolean *aliasFileFlag, Boolean *folderFlag ); 
*/
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= stringByResolvingFinderAliasesInPath
- (NSString *) stringByResolvingFinderAliasesInPath;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
#if 1
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
                    NSLog(@"%@ FSResolveAliasFile error: %d.", __PRETTY_FUNCTION__, error);
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
                            CFRelease(resolvedUrl);
                        }
                        else
                        {
                            NSLog(@"%@ CFURLCreateFromFSRef error.", __PRETTY_FUNCTION__);
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
#else
{iTM2_DIAGNOSTIC;
    FSRef ref;
    OSErr error;
    error = FSPathMakeRef([DFM fileSystemRepresentationWithPath:self], &ref, nil);
    if(error)
    {
        NSLog(@"%@ FSPathMakeRef error: %d.", __PRETTY_FUNCTION__, error);
        return self;
    }
    else
    {
        BOOL isDirectory = NO;
        BOOL wasAlias = NO;
        error = FSResolveAliasFile(&ref, YES, &isDirectory, &wasAlias);
        if(error)
        {
            NSLog(@"%@ FSResolveAliasFile error: %d.", __PRETTY_FUNCTION__, error);
            return self;
        }
        else if(wasAlias)
        {
            char path[2048];
            error = FSRefMakePath (&ref, path, 2048);
            if(error)
            {
                NSLog(@"%@ FSResolveAliasFile error: %d.", __PRETTY_FUNCTION__, error);
                return self;
            }
            else
                return [NSString stringWithUTF8String:path];
        }
        else
            return self;
    }
}
#endif
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= stringByResolvingSymlinksAndFinderAliasesInPath
- (NSString *) stringByResolvingSymlinksAndFinderAliasesInPath;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
    int firewall = 257;
    NSString * temp;
    do
    {
        temp = self;
        self = [temp stringByResolvingSymlinksInPath];
        self = [self stringByStandardizingPath];
        self = [self stringByResolvingFinderAliasesInPath];
    }
    while((--firewall>0) && ![temp isEqualToString:self]);
    return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= stringByAbbreviatingWithDotsRelativeToDirectory:
- (NSString *) stringByAbbreviatingWithDotsRelativeToDirectory: (NSString *) aPath;
/*"It is not strong: the sender is responsible of the arguments, if they do not represent directory paths, the shame on it.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
    self = [self stringByNormalizingPath];
    aPath = [aPath stringByNormalizingPath];
    if([self length] && [aPath length] && ([self characterAtIndex:0]=='/') && ([aPath characterAtIndex:0]=='/'))
    {
        NSArray * components = [self pathComponents];
        NSArray * pathComponents = [aPath pathComponents];
        // common part
        int commonIdx = 0, index = 0;
        int bound = MIN([components count], [pathComponents count]);
        while((commonIdx < bound) &&
            [[components objectAtIndex:commonIdx] isEqualToString:[pathComponents objectAtIndex:commonIdx]])
                ++commonIdx;
        index = commonIdx;
        self = [NSString string];
        while(index++ < [pathComponents count])
            self = [self stringByAppendingPathComponent:@".."];
        index = commonIdx;
        while(index < [components count])
            self = [self stringByAppendingPathComponent:[components objectAtIndex:index++]];
    }
    return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= shortestStringByAbbreviatingWithTildeInPath
- (NSString *) shortestStringByAbbreviatingWithTildeInPath;
/*"In between the receiver and the path abbreviated with tilde, return the shortest one.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
    NSString * S = [self stringByAbbreviatingWithTildeInPath];
    return ([S length]<[self length]? S:self);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= stringByNormalizingPath
- (NSString *) stringByNormalizingPath;
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
		if([component isEqual:@"."])
		{
			[components removeObjectAtIndex:index];
		}
		else if([component isEqual:@".."])
		{
			component = [components objectAtIndex:index-1];
			if(![component isEqual:@"/"])
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
    return [NSString pathWithComponents:components];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= stringByDeletingAllPathExtensions
- (NSString *) stringByDeletingAllPathExtensions;
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  enclosingDirectoryForFileNames:
+ (NSString*)enclosingDirectoryForFileNames:(NSArray *)fileNames;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 06/01/03
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSMutableDictionary * tree = [NSMutableDictionary dictionary];// this will contain the partial file hierarchy of the project files
	// Getting the directory where all the files are stored
	NSEnumerator * E = [fileNames objectEnumerator];
	NSString * path = nil;
	while(path = [E nextObject])
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
	return [NSString pathWithComponents:commonComponents];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  isEqualToFileName:
- (BOOL)isEqualToFileName:(NSString *)otherFileName;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 06/01/03
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	return [otherFileName respondsToSelector:@selector(lowercaseString)]
		&& [[self lowercaseString] isEqual:[otherFileName lowercaseString]];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  isContainedInDirectory:
- (BOOL)isContainedInDirectory:(NSString *)dirName;
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
	while(component = [itsE nextObject])
	{
		if(![component isEqualToFileName:[myE nextObject]])
		{
			return NO;
		}
	}
//iTM2_END;
	return YES;
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
+ (void) iTM2PathUtilitiesCompleteInstallation;
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
