/*
//
//  @version Subversion: $Id$ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Sun June 01 2003.
//  Copyright © 2003-2004 Laurens'Tribune. All rights reserved.
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
//  Version history:(format "- date:contribution(contributor)")
//  To Do List:(format "- proposition(percentage actually done)")
*/

#import <iTM2Foundation/iTM2FileManagerKit.h>
#import <sys/stat.h>
#import <iTM2Foundation/iTM2RuntimeBrowser.h>
#import <iTM2Foundation/MoreFilesX.h>

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  NSFileManager(iTeXMac2)
/*"Description Forthcoming."*/
@interface NSFileManager(PRIVATE)
- (BOOL)_createDeepDirectoryAtPath:(NSString *)path attributes:(NSDictionary *)attributes seed:(NSFileWrapper *)son;
@end

@implementation NSFileManager(iTeXMac2)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  createDeepDirectoryAtPath:attributes:error:
- (BOOL)createDeepDirectoryAtPath:(NSString *)path attributes:(NSDictionary *)attributes error:(NSError**)outErrorPtr;
/*"Description forthcoming. mkdir -p
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 06/01/03
To Do List:
"*/
{//iTM2_DIAGNOSTIC;
//iTM2_START;
	NSParameterAssert([path length]);
	NSString * currentDirectoryPath = [self currentDirectoryPath];
    if([path isAbsolutePath] && ![self changeCurrentDirectoryPath:NSOpenStepRootDirectory()]
	{
		return NO;
	}
	NSEnumerator * E = [[path pathComponents] objectEnumerator];
	NSString * component;
	while(component = [E nextObject])
	{
		if([self changeCurrentDirectoryPath:component])
		{
			//that's ok, next slide please
		}
		else if([self fileExistsAtPath:component])
		{
			// may be it was a finder alias
			NSString * fullPath = [self currentDirectoryPath];
			fullPath = [fullPath stringByAppendingPathComponent:component];
			NSURL * url = [NSURL fileURLWithPath:fullPath];
			NSData * aliasData = [NSData aliasDataWithContentsOfURL:url error:nil];
			NSString * resolvedPath = [aliasData pathByResolvingDataAliasRelativeTo:nil error:nil];
			if([self changeCurrentDirectoryPath:resolvedPath])
			{
				//that's ok, next slide please
			}
			else
			{
				if(outErrorPtr)
				{
					*outErrorPtr = [NSError errorWithDomain:[NSString stringWithUTF8String:__PRETTY_FUNCTION__] code:1
						userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
							[NSString stringWithFormat:@"A (link to a)directory was expected at\n%@", fullPath], NSLocalizedDescriptionKey,
							fullPath, @"iTM2DirectoryPath",
								nil]];
				}
				return NO;
			}
		}
		else if([self createDirectoryAtPath:component attributes:nil])
		{
			if([self changeCurrentDirectoryPath:component])
			{
				//that's ok, next slide please
			}
			else
			{
				if(outErrorPtr)
				{
					NSString * fullPath = [[self currentDirectoryPath] stringByAppendingPathComponent:component];
					*outErrorPtr = [NSError errorWithDomain:[NSString stringWithUTF8String:__PRETTY_FUNCTION__] code:2
						userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
							[NSString stringWithFormat:@"Could not change to directory\n%@", fullPath], NSLocalizedDescriptionKey,
							fullPath, @"iTM2DirectoryPath",
								nil]];
				}
				return NO;
			}
		}
		else
		{
			if(outErrorPtr)
			{
				NSString * fullPath = [[self currentDirectoryPath] stringByAppendingPathComponent:component];
				*outErrorPtr = [NSError errorWithDomain:[NSString stringWithUTF8String:__PRETTY_FUNCTION__] code:2
					userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
						[NSString stringWithFormat:@"Could not create directory\n%@", fullPath], NSLocalizedDescriptionKey,
						fullPath, @"iTM2DirectoryPath",
							nil]];
			}
			return NO;
		}
	}
	[self changeCurrentDirectoryPath:currentDirectoryPath];
	return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  createDeepFileAtPath:contents:attributes:
- (BOOL)createDeepFileAtPath:(NSString *)path contents:(NSData *)data attributes:(NSDictionary *)attributes;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 06/01/03
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(![path isAbsolutePath])
        path = [[self currentDirectoryPath] stringByAppendingPathComponent:path];
    path = [path stringByStandardizingPath];
    if([self fileExistsAtPath:path] || [DFM pathContentOfSymbolicLinkAtPath:path])
    {
        return NO;
    }
    else
    {
        NSFileWrapper * son = [[[NSFileWrapper alloc] initRegularFileWithContents:data] autorelease];
        [son setPreferredFilename:[path lastPathComponent]];
        if(attributes)
            [son setFileAttributes:attributes];
        return [self _createDeepDirectoryAtPath:[path stringByDeletingLastPathComponent]
                            attributes: attributes seed: son];
    }
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  createDeepSymbolicLinkAtPath:pathContent:
- (BOOL)createDeepSymbolicLinkAtPath:(NSString *)path pathContent:(NSString *)otherpath;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 06/01/03
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(![path isAbsolutePath])
        path = [[self currentDirectoryPath] stringByAppendingPathComponent:path];
    path = [path stringByStandardizingPath];
    if([self fileExistsAtPath:path] || [DFM pathContentOfSymbolicLinkAtPath:path])
        return NO;
    else
    {
        NSFileWrapper * son = [[[NSFileWrapper alloc] initSymbolicLinkWithDestination:path] autorelease];
        [son setPreferredFilename:[path lastPathComponent]];
        return [self _createDeepDirectoryAtPath:[path stringByDeletingLastPathComponent]
                            attributes: nil seed: son];
    }
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  _createDeepDirectoryAtPath:attributes:seed:
- (BOOL)_createDeepDirectoryAtPath:(NSString *)path attributes:(NSDictionary *)attributes seed:(NSFileWrapper *)son;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 06/01/03
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(![path isAbsolutePath])
        path = [[self currentDirectoryPath] stringByAppendingPathComponent:path];
    path = [path stringByStandardizingPath];
    BOOL isDirectory;
oneMoreTime:
    if([self fileExistsAtPath:path isDirectory:&isDirectory])
    {
        return isDirectory && (!son
                    || [son writeToFile:[path stringByAppendingPathComponent:[son preferredFilename]]
                                atomically: YES updateFilenames: NO]);
    }
    else
    {
        if(son)
        {
            NSFileWrapper * newSon = [[[NSFileWrapper alloc] initDirectoryWithFileWrappers:nil] autorelease];
            [newSon addFileWrapper:son];
            son = newSon;
        }
        else
            son = [[[NSFileWrapper alloc] initDirectoryWithFileWrappers:nil] autorelease];
        [son setPreferredFilename:[path lastPathComponent]];
        if(attributes)
            [son setFileAttributes:attributes];
        NSString * newPath = [path stringByDeletingLastPathComponent];
        if([newPath length]<[path length])
        {
            path = newPath;
            goto oneMoreTime;
        }
        else
            return NO;
    }
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  makeFileWritableAtPath:recursive:
- (void)makeFileWritableAtPath:(NSString *)fileName recursive:(BOOL)recursive;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 06/01/03
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	BOOL isDirectory = NO;
	if([self fileExistsAtPath:fileName isDirectory:&isDirectory])// traverse the link:bug in the documentation
	{
		NSMutableDictionary * fileAttributes = [[[self fileAttributesAtPath:fileName traverseLink:NO] mutableCopy] autorelease];
		unsigned int oldPosixPermissions = [fileAttributes filePosixPermissions];
		unsigned int newPosixPermissions = oldPosixPermissions | S_IWUSR;
		[fileAttributes setObject:[NSNumber numberWithUnsignedInt:newPosixPermissions] forKey:NSFilePosixPermissions];
		[self changeFileAttributes:fileAttributes atPath:fileName];
		if(recursive && [[fileAttributes objectForKey:NSFileType] isEqual:NSFileTypeDirectory])// beware, do not use isDirectory
		{
			NSEnumerator * E = [[self directoryContentsAtPath:fileName] objectEnumerator];
			NSString * component;
			while(component = [E nextObject])
				[self makeFileWritableAtPath:[fileName stringByAppendingPathComponent:component] recursive:recursive];
		}
	}
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setExtensionHidden:atPath:
- (BOOL)setExtensionHidden:(BOOL)yorn atPath:(NSString *)path;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 06/01/03
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSMutableDictionary * attributes = [[[self fileAttributesAtPath:path traverseLink:NO] mutableCopy] autorelease];
	[attributes setObject:[NSNumber numberWithBool:yorn] forKey:NSFileExtensionHidden];
//iTM2_END;
	return [self changeFileAttributes:attributes atPath:path];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  prettyNameAtPath:
- (NSString *)prettyNameAtPath:(NSString *)path;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 06/01/03
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	return [[self fileAttributesAtPath:path traverseLink:NO] fileExtensionHidden]?
			[[path lastPathComponent] stringByDeletingPathExtension]:[path lastPathComponent];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  fileExistsAtPath:isAlias:error:
- (BOOL)fileExistsAtPath:(NSString *)path isAlias:(BOOL *)isAlias error:(NSError**)outErrorPtr;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 06/01/03
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([self fileExistsAtPath:path])//traverse links
	{
		FSRef ref = {0};
		OSStatus status = FSPathMakeRef((UInt8 *)[path UTF8String], &ref, NULL);
		if(status)
		{
			if(outErrorPtr)
			{
				*outErrorPtr = [NSError errorWithDomain:[NSString stringWithUTF8String:__PRETTY_FUNCTION__] code:status
					userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"Could not create an FSRef for %@", path] forKey:NSLocalizedDescriptionKey]];
			}
//iTM2_END;
			return YES;
		}
		OSErr err = FSIsAliasFile(&ref,(Boolean*)isAlias, NULL);
		if(err)
		{
			[NSError errorWithDomain:[NSString stringWithUTF8String:__PRETTY_FUNCTION__] code:err
				userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"Could not check an alias at %@", path] forKey:NSLocalizedDescriptionKey]];
		}
//iTM2_END;
		return YES;
	}
//iTM2_END;
	return NO;
}
static NSMutableArray * iTM2FileManagerKitDirectoryStack = nil;
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  pushDirectory:
- (BOOL)pushDirectory:(NSString *)path;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 06/01/03
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(!iTM2FileManagerKitDirectoryStack)
	{
		iTM2FileManagerKitDirectoryStack = [[NSMutableArray array] retain];
	}
	NSString * currentDirectoryPath = [DFM currentDirectoryPath];
	if([self changeCurrentDirectoryPath:path])
	{
		[iTM2FileManagerKitDirectoryStack addObject:currentDirectoryPath];
//iTM2_END;
		return YES;
	}
//iTM2_END;
	return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  popDirectory
- (BOOL)popDirectory;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 06/01/03
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * path = [iTM2FileManagerKitDirectoryStack lastObject];
	if(path && [self changeCurrentDirectoryPath:path])
	{
		[iTM2FileManagerKitDirectoryStack removeLastObject];
//iTM2_END;
		return YES;
	}
//iTM2_END;
	return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  popDirectory
- (BOOL)fileOrLinkExistsAtPath:(NSString *)path;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 06/01/03
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * path = [iTM2FileManagerKitDirectoryStack lastObject];
	if(path && [self changeCurrentDirectoryPath:path])
	{
		[iTM2FileManagerKitDirectoryStack removeLastObject];
//iTM2_END;
		return YES;
	}
//iTM2_END;
	return [self fileExistsAtPath:path] || [self linkExistsAtPath:path];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  linkExistsAtPath:
- (BOOL)linkExistsAtPath:(NSString *)path;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 06/01/03
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	return [self pathContentOfSymbolicLinkAtPath:path]!=nil;
}
#if 0
#warning *** DEBUGGING PURPOSE ONLY, to be removed
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  load
+ (void)load;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	iTM2_INIT_POOL;
//iTM2_START;
	if(![iTM2RuntimeBrowser swizzleInstanceMethodSelector:@selector(swizzled_removeFileAtPath:handler:)replacement:@selector(removeFileAtPath:handler:)forClass:[NSFileManager class]])
	{
		iTM2_LOG(@"WARNING: No hook available to init NSFileManager...");
	}
//iTM2_END;
	iTM2_RELEASE_POOL;
	return;
}
- (BOOL)swizzled_removeFileAtPath:(NSString *)path handler:handler;
{
//iTM2_LOG(@"path: %@", path);
	if([[path lastPathComponent] pathIsEqual:@"CV.tex"])
	{
		BOOL isAlias = NO;
		NSError * localError = nil;
		if([self fileExistsAtPath:path isAlias:&isAlias error:&localError] && !isAlias)
		{
			iTM2_LOG(@"FORBIDDEN");
		}
	}
	if([path rangeOfString:@".."].location != NSNotFound)
	{
		iTM2_LOG(@"NOT STANDARDIZED: %@", path);
	}
	return [self swizzled_removeFileAtPath:path handler:handler];
}
#endif
@end

@interface NSFileManager(_iTM2ExtendedAttributes)
- (NSDictionary *)extendedFileAttributesWithResourceType:(ResType)resourceType atPath:(NSString *)path error:(NSError **)outErrorPtr;
- (NSData *)extendedFileAttribute:(NSString *)attributeName withResourceType:(ResType)resourceType atPath:(NSString *)path error:(NSError **)outErrorPtr;
- (BOOL)addExtendedFileAttribute:(NSString *)attributeName value:(NSData *)D withResourceType:(ResType)resourceType atPath:(NSString *)path error:(NSError **)outErrorPtr;
- (BOOL)removeExtendedFileAttribute:(NSString *)attributeName withResourceType:(ResType)resourceType atPath:(NSString *)path error:(NSError **)outErrorPtr;
- (BOOL)changeExtendedFileAttributes:(NSDictionary *)attributes withResourceType:(ResType)resourceType atPath:(NSString *)path error:(NSError **)outErrorPtr;
- (NSData *)extendedFileAttributeWithResourceType:(ResType)resourceType resourceID:(ResID)resourceID atPath:(NSString *)path error:(NSError **)outErrorPtr;
- (BOOL)addExtendedFileAttribute:(NSString*)attributeName value:(NSData *)D withResourceType:(ResType)resourceType resourceID:(ResID)resourceID atPath:(NSString *)path error:(NSError **)outErrorPtr;
@end

@implementation NSFileManager(iTM2ExtendedAttributes)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  extendedFileAttributesInDomain:atPath:error:
- (NSDictionary *)extendedFileAttributesInSpace:(id)space atPath:(NSString *)path error:(NSError **)outErrorPtr;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 06/01/03
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([space isKindOfClass:[NSNumber class]])
	{
		return [self extendedFileAttributesWithResourceType:[space unsignedIntValue] atPath:path error:outErrorPtr];
	}
//iTM2_END;
	return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  extendedFileAttributesWithResourceType:atPath:error:
- (NSDictionary *)extendedFileAttributesWithResourceType:(ResType)resourceType atPath:(NSString *)path error:(NSError **)outErrorPtr;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 06/01/03
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	BOOL isDirectory;
	if(![DFM fileExistsAtPath:path isDirectory:&isDirectory] || isDirectory)
		return nil;
	// now we are ready to read the resources
	NSMutableDictionary * MD = [NSMutableDictionary dictionary];
	FSRef fileSystemReference;
	if(CFURLGetFSRef((CFURLRef)[NSURL fileURLWithPath:path], &fileSystemReference))
	{
		short curResFile = CurResFile();
		OSErr resError;
		BOOL wasCurResFile = (noErr == ResError());
		short fileSystemReferenceNumber = FSOpenResFile(&fileSystemReference, fsRdPerm);
		if(resError = ResError())
		{
			if(iTM2DebugEnabled)
			{
				iTM2_LOG(@"Could not FSOpenResFile, error %i (fileSystemReferenceNumber: %i)", resError, fileSystemReferenceNumber);
			}
			return nil;
		}
		UseResFile(fileSystemReferenceNumber);
		if(resError = ResError())
		{
			if(iTM2DebugEnabled)
			{
				iTM2_LOG(@"Could not UseResFile, error %i (fileSystemReferenceNumber: %i)", resError, fileSystemReferenceNumber);
			}
			CloseResFile(fileSystemReferenceNumber);
			return nil;
		}
		SInt16 resourceIndex = Count1Resources(resourceType);
		nextLoop:
		while(resourceIndex)
		{
			Handle H = Get1IndResource(resourceType, resourceIndex);
			if((resError = ResError())|| !H)
			{
				if(iTM2DebugEnabled)
				{
					iTM2_LOG(@"Could not Get1Resource, error %i (resourceIndex is %i)", resError, resourceIndex);
				}
				--resourceIndex;
				goto nextLoop;
			}
			if(iTM2DebugEnabled)
			{
				if(iTM2DebugEnabled)
				{
					iTM2_LOG(@"Could use Get1Resource, error %i (resourceIndex is %i)", resError, resourceIndex);
				}
			}
			Str255 resourceName;
			GetResInfo(H, nil, nil, resourceName);
			if(resError = ResError())
			{
				if(iTM2DebugEnabled)
				{
					iTM2_LOG(@"Could not GetResInfo, error %i (resourceIndex is %i)", resError, resourceIndex);
				}
				--resourceIndex;
				goto nextLoop;
			}
			if(iTM2DebugEnabled)
			{
				iTM2_LOG(@"Could use GetResInfo, error %i (resourceIndex is %i)", resError, resourceIndex);
			}
			HLock(H);
			NSData * D = [NSData dataWithBytes:*H length:GetHandleSize(H)];
			HUnlock(H);
			ReleaseResource(H);
			if(resError = ResError())
			{
				if(iTM2DebugEnabled)
				{
					iTM2_LOG(@"Could not ReleaseResource, error %i (resourceIndex is %i)", resError, resourceIndex);
				}
			}
			Str255 dst;
			memcpy(dst, resourceName+1, resourceName[0]);
			dst[resourceName[0]]='\0';
			NSString * key = [NSString stringWithUTF8String:(void *)dst];
			if([key length])
				[MD setObject:D forKey:key];
			--resourceIndex;
		}
		CloseResFile(fileSystemReferenceNumber);
		if(resError = ResError())
		{
			if(iTM2DebugEnabled)
			{
				iTM2_LOG(@"Could not CloseResFile, error %i", resError);
			}
		}
		if(wasCurResFile)
		{
			UseResFile(curResFile);
			if(resError = ResError())
			{
				if(iTM2DebugEnabled)
				{
					iTM2_LOG(@"Could not UseResFile, error %i", resError);
				}
			}
		}
		return MD;
	}
//iTM2_END;
	return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  extendedFileAttribute:inSpace:atPath:error:
- (NSData *)extendedFileAttribute:(NSString *)attributeName inSpace:(id)space atPath:(NSString *)path error:(NSError **)outErrorPtr;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 06/01/03
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	if([space isKindOfClass:[NSNumber class]])
		return [self extendedFileAttribute:attributeName withResourceType:[space unsignedIntValue] atPath:path error:outErrorPtr];
	return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  extendedFileAttribute:withResourceType:atPath:error:
- (NSData *)extendedFileAttribute:(NSString *)attributeName withResourceType:(ResType)resourceType atPath:(NSString *)path error:(NSError **)outErrorPtr;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 06/01/03
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSData * D = nil;
	if(![DFM fileExistsAtPath:path])
	{
		if(outErrorPtr)
			* outErrorPtr = [NSError errorWithDomain:[NSString stringWithUTF8String:__PRETTY_FUNCTION__]
				code: kiTM2ExtendedAttributesNoFileAtPathError userInfo: nil];
		return D;
	}
	path = [path stringByResolvingSymlinksAndFinderAliasesInPath];
	const char * src = [attributeName UTF8String];
	if(strlen(src)>= 256)
	{
		if(outErrorPtr)
			* outErrorPtr = [NSError errorWithDomain:[NSString stringWithUTF8String:__PRETTY_FUNCTION__]
				code: kiTM2ExtendedAttributesBadNameError userInfo: nil];
		return D;
	}
	FSRef fileSystemReference;
	if(CFURLGetFSRef((CFURLRef)[NSURL fileURLWithPath:path], &fileSystemReference))
	{
		short curResFile = CurResFile();
		OSErr resError;
		BOOL wasCurResFile = (noErr == ResError());
		short fileSystemReferenceNumber = FSOpenResFile(&fileSystemReference, fsRdPerm);
		if(resError = ResError())
		{
			if(iTM2DebugEnabled)
			{
				iTM2_LOG(@"Could not FSOpenResFile, error %i (fileSystemReferenceNumber: %i)", resError, fileSystemReferenceNumber);
			}
			if(outErrorPtr)
				* outErrorPtr = [NSError errorWithDomain:[NSString stringWithUTF8String:__PRETTY_FUNCTION__]
					code: kiTM2ExtendedAttributesResourceManagerError
						userInfo: [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:resError] forKey:@"ResError"]];
			return nil;
		}
		UseResFile(fileSystemReferenceNumber);
		if(resError = ResError())
		{
			if(iTM2DebugEnabled)
			{
				iTM2_LOG(@"Could not UseResFile, error %i (fileSystemReferenceNumber: %i)", resError, fileSystemReferenceNumber);
			}
			if(outErrorPtr)
				* outErrorPtr = [NSError errorWithDomain:[NSString stringWithUTF8String:__PRETTY_FUNCTION__]
					code: kiTM2ExtendedAttributesResourceManagerError
						userInfo: [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:resError] forKey:@"ResError"]];
			CloseResFile(fileSystemReferenceNumber);
			return nil;
		}
		Str255 resourceName;
		memcpy(resourceName+1, src, strlen(src));
		resourceName[0]=strlen(src);
		Handle H = Get1NamedResource(resourceType, resourceName);
		if((resError = ResError())|| !H)
		{
			if(iTM2DebugEnabled)
			{
				iTM2_LOG(@"Could not Get1NamedResource, error %i (attributeName is %@)", resError, attributeName);
			}
			if(outErrorPtr)
				* outErrorPtr = [NSError errorWithDomain:[NSString stringWithUTF8String:__PRETTY_FUNCTION__]
					code: kiTM2ExtendedAttributesResourceManagerError
						userInfo: [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:resError] forKey:@"ResError"]];
			return nil;
		}
		if(iTM2DebugEnabled)
		{
			iTM2_LOG(@"Could use Get1Resource, error %i (attributeName is %@)", resError, attributeName);
		}
		HLock(H);
		D = [NSData dataWithBytes:*H length:GetHandleSize(H)];
		HUnlock(H);
		ReleaseResource(H);
		if(resError = ResError())
		{
			if(iTM2DebugEnabled)
			{
				iTM2_LOG(@"Could not ReleaseResource, error %i (attributeName is %@)", resError, attributeName);
			}
			if(outErrorPtr)
				* outErrorPtr = [NSError errorWithDomain:[NSString stringWithUTF8String:__PRETTY_FUNCTION__]
					code: kiTM2ExtendedAttributesResourceManagerError
						userInfo: [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:resError] forKey:@"ResError"]];
		}
		CloseResFile(fileSystemReferenceNumber);
		if(resError = ResError())
		{
			if(iTM2DebugEnabled)
			{
				iTM2_LOG(@"Could not CloseResFile, error %i", resError);
			}
			if(outErrorPtr)
				* outErrorPtr = [NSError errorWithDomain:[NSString stringWithUTF8String:__PRETTY_FUNCTION__]
					code: kiTM2ExtendedAttributesResourceManagerError
						userInfo: [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:resError] forKey:@"ResError"]];
		}
		if(wasCurResFile)
		{
			UseResFile(curResFile);
			if(resError = ResError())
			{
				if(iTM2DebugEnabled)
				{
					iTM2_LOG(@"Could not UseResFile, error %i", resError);
				}
				if(outErrorPtr)
					* outErrorPtr = [NSError errorWithDomain:[NSString stringWithUTF8String:__PRETTY_FUNCTION__]
						code: kiTM2ExtendedAttributesResourceManagerError
							userInfo: [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:resError] forKey:@"ResError"]];
			}
		}
	}
//iTM2_END;
	return D;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  addExtendedFileAttribute:value:inSpace:atPath:error:
- (BOOL)addExtendedFileAttribute:(NSString *)attributeName value:(NSData *)D inSpace:(id)space atPath:(NSString *)path error:(NSError **)outErrorPtr;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 06/01/03
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([space isKindOfClass:[NSNumber class]])
		return [self addExtendedFileAttribute:attributeName value:D withResourceType:[space unsignedIntValue] atPath:path error:outErrorPtr];
//iTM2_END;
	return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  addExtendedFileAttribute:value:withResourceType:atPath:error:
- (BOOL)addExtendedFileAttribute:(NSString *)attributeName value:(NSData *)D withResourceType:(ResType)resourceType atPath:(NSString *)path error:(NSError **)outErrorPtr;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 06/01/03
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(![DFM fileExistsAtPath:path])
		return NO;
	path = [path stringByResolvingSymlinksAndFinderAliasesInPath];
	BOOL result = YES;
	const char * src = [attributeName UTF8String];
	if(strlen(src)>= 256)
		return NO;
	FSRef fileSystemReference;
	if(CFURLGetFSRef((CFURLRef)[NSURL fileURLWithPath:path], &fileSystemReference))
	{
		FSSpec spec;
		if(noErr == FSGetCatalogInfo(&fileSystemReference, kFSCatInfoNone, nil, nil, &spec, nil))
		{
			short curResFile = CurResFile();
			OSErr resError;
			BOOL wasCurResFile = (noErr == ResError());
			NSDictionary * fileAttributes = [DFM fileAttributesAtPath:path traverseLink:NO];
			FSpCreateResFile(&spec, [fileAttributes fileHFSCreatorCode], [fileAttributes fileHFSTypeCode], smRoman);
			// no error check needed
			short fileSystemReferenceNumber = FSOpenResFile(&fileSystemReference, fsWrPerm);
			if(resError = ResError())
			{
				if(iTM2DebugEnabled)
				{
					iTM2_LOG(@"Could not FSOpenResFile, error %i, fileSystemReferenceNumber: %i", resError, fileSystemReferenceNumber);
				}
				CloseResFile(fileSystemReferenceNumber);
				return NO;
			}
			UseResFile(fileSystemReferenceNumber);
			if(resError = ResError())
			{
				if(iTM2DebugEnabled)
				{
					iTM2_LOG(@"Could not UseResFile, error %i, fileSystemReferenceNumber: %i", resError, fileSystemReferenceNumber);
				}
				CloseResFile(fileSystemReferenceNumber);
				return NO;
			}
			Str255 resourceName;
			memcpy(resourceName+1, src, strlen(src));
			resourceName[0]=strlen(src);
			Handle H = Get1NamedResource(resourceType, resourceName);
			if(resError = ResError())
			{
				if(iTM2DebugEnabled)
				{
					iTM2_LOG(@"Could not Get1NamedResource, error %i (attributeName is %@)", resError, attributeName);
				}
			}
			else if(iTM2DebugEnabled)
			{
				iTM2_LOG(@"Could use Get1NamedResource, error %i (attributeName is %@)", resError, attributeName);
			}
			short resourceID;
			if(H)
			{
				GetResInfo(H, &resourceID, nil, resourceName);
				if(resError = ResError())
				{
					if(iTM2DebugEnabled)
					{
						iTM2_LOG(@"Could not GetResInfo, error %i (attributeName is %@)", resError, attributeName);
					}
				}
				else if(iTM2DebugEnabled)
				{
					iTM2_LOG(@"Could use GetResInfo, error %i (attributeName is %@)", resError, attributeName);
				}
				RemoveResource(H);
				DisposeHandle(H);
				H = nil;
			}
			else
			{
				resourceID = 256;
				while(H = Get1IndResource(resourceType, resourceID))
					++resourceID;
				
			}
			if(resError = PtrToHand([D bytes], &H, [D length]))
			{
				if(iTM2DebugEnabled)
				{
					iTM2_LOG(@"WARNING: Could not convert a Ptr into a handle");
				}
			}
			else
			{
				HLock(H);
				AddResource(H, resourceType, resourceID, resourceName);
				HUnlock(H);
				if(resError = ResError())
				{
					if(iTM2DebugEnabled)
					{
						iTM2_LOG(@"Could not AddResource, error %i", resError);
					}
					DisposeHandle(H);// hum the handle is considered the property of the resource manager now?
				}
				else if(iTM2DebugEnabled>99)
				{
					iTM2_LOG(@"Resource added: %u", resourceID);
				}
				// DisposeHandle(H);// hum the handle is considered the property of the resource manager now?
			}
			CloseResFile(fileSystemReferenceNumber);
			if(resError = ResError())
			{
				iTM2_LOG(@"Could not CloseResFile, error %i", resError);
			}
			if(wasCurResFile)
			{
				UseResFile(curResFile);
				if(resError = ResError())
				{
					if(iTM2DebugEnabled)
					{
						iTM2_LOG(@"Could not UseResFile, error %i", resError);
					}
				}
			}
		}
else NSLog(@"No spec");
	}
//iTM2_END;
    return result;// even if the resources could not be saved...
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  addExtendedFileAttribute:inSpace:atPath:error:
- (BOOL)removeExtendedFileAttribute:(NSString *)attributeName inSpace:(id)space atPath:(NSString *)path error:(NSError **)outErrorPtr;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 06/01/03
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([self isKindOfClass:[NSNumber class]])
		return [self removeExtendedFileAttribute:attributeName withResourceType:[space unsignedIntValue] atPath:path error:outErrorPtr];
//iTM2_END;
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  removeExtendedFileAttribute:withResourceType:atPath:error:
- (BOOL)removeExtendedFileAttribute:(NSString *)attributeName withResourceType:(ResType)resourceType atPath:(NSString *)path error:(NSError **)outErrorPtr;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 06/01/03
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(![DFM fileExistsAtPath:path])
	{
		if(outErrorPtr)
			* outErrorPtr = [NSError errorWithDomain:[NSString stringWithUTF8String:__PRETTY_FUNCTION__]
				code: kiTM2ExtendedAttributesNoFileAtPathError userInfo: nil];
		return NO;
	}
	path = [path stringByResolvingSymlinksAndFinderAliasesInPath];
	BOOL result = YES;
	const char * src = [attributeName UTF8String];
	if(strlen(src)>= 256)
	{
		if(outErrorPtr)
			* outErrorPtr = [NSError errorWithDomain:[NSString stringWithUTF8String:__PRETTY_FUNCTION__]
				code: kiTM2ExtendedAttributesBadNameError userInfo: nil];
		return NO;
	}
	FSRef fileSystemReference;
	if(CFURLGetFSRef((CFURLRef)[NSURL fileURLWithPath:path], &fileSystemReference))
	{
		FSSpec spec;
		if(noErr == FSGetCatalogInfo(&fileSystemReference, kFSCatInfoNone, nil, nil, &spec, nil))
		{
			short curResFile = CurResFile();
			OSErr resError;
			BOOL wasCurResFile = (noErr == ResError());
			NSDictionary * fileAttributes = [DFM fileAttributesAtPath:path traverseLink:NO];
			FSpCreateResFile(&spec, [fileAttributes fileHFSCreatorCode], [fileAttributes fileHFSTypeCode], smRoman);
			// no error check needed
			short fileSystemReferenceNumber = FSOpenResFile(&fileSystemReference, fsWrPerm);
			if(resError = ResError())
			{
				if(iTM2DebugEnabled)
				{
					iTM2_LOG(@"Could not FSOpenResFile, error %i, fileSystemReferenceNumber: %i", resError, fileSystemReferenceNumber);
				}
				CloseResFile(fileSystemReferenceNumber);
				if(outErrorPtr)
					* outErrorPtr = [NSError errorWithDomain:[NSString stringWithUTF8String:__PRETTY_FUNCTION__]
						code: kiTM2ExtendedAttributesResourceManagerError
							userInfo: [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:resError] forKey:@"ResError"]];
				return NO;
			}
			UseResFile(fileSystemReferenceNumber);
			if(resError = ResError())
			{
				if(iTM2DebugEnabled)
				{
					iTM2_LOG(@"Could not UseResFile, error %i, fileSystemReferenceNumber: %i", resError, fileSystemReferenceNumber);
				}
				CloseResFile(fileSystemReferenceNumber);
				if(outErrorPtr)
					* outErrorPtr = [NSError errorWithDomain:[NSString stringWithUTF8String:__PRETTY_FUNCTION__]
						code: kiTM2ExtendedAttributesResourceManagerError
							userInfo: [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:resError] forKey:@"ResError"]];
				return NO;
			}
			Str255 resourceName;
			memcpy(resourceName+1, src, strlen(src));
			resourceName[0]=strlen(src);
			Handle H = Get1NamedResource(resourceType, resourceName);
			if(resError = ResError())
			{
				if(iTM2DebugEnabled)
				{
					iTM2_LOG(@"Could not Get1NamedResource, error %i (attributeName is %@)", resError, attributeName);
				}
				if(outErrorPtr)
					* outErrorPtr = [NSError errorWithDomain:[NSString stringWithUTF8String:__PRETTY_FUNCTION__]
						code: kiTM2ExtendedAttributesResourceManagerError
							userInfo: [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:resError] forKey:@"ResError"]];
			}
			else if(iTM2DebugEnabled)
			{
				iTM2_LOG(@"Could use Get1NamedResource, error %i (attributeName is %@)", resError, attributeName);
			}
			if(H)
			{
				RemoveResource(H);
				if(resError = ResError())
				{
					if(iTM2DebugEnabled)
					{
						iTM2_LOG(@"Could not GetResInfo, error %i (attributeName is %@)", resError, attributeName);
					}
					if(outErrorPtr)
						* outErrorPtr = [NSError errorWithDomain:[NSString stringWithUTF8String:__PRETTY_FUNCTION__]
							code: kiTM2ExtendedAttributesResourceManagerError
								userInfo: [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:resError] forKey:@"ResError"]];
				}
				else if(iTM2DebugEnabled)
				{
					if(iTM2DebugEnabled)
					{
						iTM2_LOG(@"Could use GetResInfo, error %i (attributeName is %@)", resError, attributeName);
					}
					if(outErrorPtr)
						* outErrorPtr = [NSError errorWithDomain:[NSString stringWithUTF8String:__PRETTY_FUNCTION__]
							code: kiTM2ExtendedAttributesResourceManagerError
								userInfo: [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:resError] forKey:@"ResError"]];
				}
				DisposeHandle(H);
				H = nil;
			}
			CloseResFile(fileSystemReferenceNumber);
			if(resError = ResError())
			{
				if(iTM2DebugEnabled)
				{
					iTM2_LOG(@"Could not CloseResFile, error %i", resError);
				}
				if(outErrorPtr)
					* outErrorPtr = [NSError errorWithDomain:[NSString stringWithUTF8String:__PRETTY_FUNCTION__]
						code: kiTM2ExtendedAttributesResourceManagerError
							userInfo: [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:resError] forKey:@"ResError"]];
			}
			if(wasCurResFile)
			{
				UseResFile(curResFile);
				if(resError = ResError())
				{
					if(iTM2DebugEnabled)
					{
						iTM2_LOG(@"Could not UseResFile, error %i", resError);
					}
					if(outErrorPtr)
						* outErrorPtr = [NSError errorWithDomain:[NSString stringWithUTF8String:__PRETTY_FUNCTION__]
							code: kiTM2ExtendedAttributesResourceManagerError
								userInfo: [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:resError] forKey:@"ResError"]];
				}
			}
		}
else NSLog(@"No spec");
	}
//iTM2_END;
    return result;// even if the resources could not be saved...
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  changeExtendedFileAttributes:inSpace:atPath:error:
- (BOOL)changeExtendedFileAttributes:(NSDictionary *)attributes inSpace:(id)space atPath:(NSString *)path error:(NSError **)outErrorPtr;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 06/01/03
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([space isKindOfClass:[NSNumber class]])
		return [self changeExtendedFileAttributes:attributes withResourceType:[space unsignedIntValue] atPath:path error:outErrorPtr];
//iTM2_END;
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  changeExtendedFileAttributes:withResourceType:atPath:error:
- (BOOL)changeExtendedFileAttributes:(NSDictionary *)attributes withResourceType:(ResType)resourceType atPath:(NSString *)path error:(NSError **)outErrorPtr;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 06/01/03
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(![DFM fileExistsAtPath:path])
	{
		return NO;
	}
	path = [path stringByResolvingSymlinksAndFinderAliasesInPath];
	BOOL result = YES;
	FSRef fileSystemReference;
	if(CFURLGetFSRef((CFURLRef)[NSURL fileURLWithPath:path], &fileSystemReference))
	{
		FSSpec spec;
		if(noErr == FSGetCatalogInfo(&fileSystemReference, kFSCatInfoNone, nil, nil, &spec, nil))
		{
			short curResFile = CurResFile();
			OSErr resError;
			BOOL wasCurResFile = (noErr == ResError());
			NSDictionary * fileAttributes = [DFM fileAttributesAtPath:path traverseLink:NO];
			FSpCreateResFile(&spec, [fileAttributes fileHFSCreatorCode], [fileAttributes fileHFSTypeCode], smRoman);
			// no error check needed
			short fileSystemReferenceNumber = FSOpenResFile(&fileSystemReference, fsWrPerm);
			if(resError = ResError())
			{
				if(iTM2DebugEnabled)
				{
					iTM2_LOG(@"Could not FSOpenResFile, error %i, fileSystemReferenceNumber: %i", resError, fileSystemReferenceNumber);
				}
				CloseResFile(fileSystemReferenceNumber);
				return NO;
			}
			UseResFile(fileSystemReferenceNumber);
			if(resError = ResError())
			{
				if(iTM2DebugEnabled)
				{
					iTM2_LOG(@"Could not UseResFile, error %i, fileSystemReferenceNumber: %i", resError, fileSystemReferenceNumber);
				}
				CloseResFile(fileSystemReferenceNumber);
				return NO;
			}
			// we are retrieving the actual resources
			// we will compare the resourceName with the keys of the attributes dictionary
			// if there is a match, the resource is modified, if not it is removed.
			// This means that only one app can write some resources of a given type.
			NSMutableDictionary * badAttributes = [NSMutableDictionary dictionary];
			NSMutableArray * attributeKeys = [[[attributes allKeys] mutableCopy] autorelease];
			SInt16 resourceIndex = Count1Resources(resourceType);
			NSString * key;
			Str255 resourceName;
			short resourceID;
			Handle H;
			nextLoop:
			while(resourceIndex)
			{
				H = Get1IndResource(resourceType, resourceIndex);
				if((resError = ResError())|| !H)
				{
					if(iTM2DebugEnabled)
					{
						iTM2_LOG(@"Could not Get1Resource, error %i (resourceIndex is %i)", resError, resourceIndex);
					}
					--resourceIndex;
					goto nextLoop;
				}
				if(iTM2DebugEnabled)
				{
					iTM2_LOG(@"Could use Get1Resource, error %i (resourceIndex is %i)", resError, resourceIndex);
				}
				GetResInfo(H, &resourceID, nil, resourceName);
				if(resError = ResError())
				{
					if(iTM2DebugEnabled)
					{
						iTM2_LOG(@"Could not GetResInfo, error %i (resourceIndex is %i)", resError, resourceIndex);
					}
					--resourceIndex;
					goto nextLoop;
				}
				if(iTM2DebugEnabled)
				{
					iTM2_LOG(@"Could use GetResInfo, error %i (resourceIndex is %i)", resError, resourceIndex);
				}
				Str255 dst;
				memcpy(dst, resourceName+1, resourceName[0]);
				dst[resourceName[0]]='\0';
				key = [NSString stringWithUTF8String:(void*)dst];
				if([key length])
				{
					RemoveResource(H);
					if(resError = ResError())
					{
						if(iTM2DebugEnabled)
						{
							iTM2_LOG(@"Could not RemoveResource, error %i (resourceIndex is %i)", resError, resourceIndex);
						}
					}
					DisposeHandle(H);
					[attributeKeys removeObject:key];
					NSData * D = [attributes objectForKey:key];
					if([D isKindOfClass:[NSData class]])
					{
						if(resError = PtrToHand([D bytes], &H, [D length]))
						{
							if(iTM2DebugEnabled)
							{
								iTM2_LOG(@"WARNING: Could not convert a Ptr into a handle");
							}
						}
						else
						{
							HLock(H);
							AddResource(H, resourceType, resourceID, resourceName);
							HUnlock(H);
							if(resError = ResError())
							{
								if(iTM2DebugEnabled)
								{
									iTM2_LOG(@"Could not AddResource, error %i", resError);
								}
								DisposeHandle(H);// hum the handle is considered the property of the resource manager now?
							}
							else if(iTM2DebugEnabled>99)
							{
								iTM2_LOG(@"Resource added: %u", resourceID);
							}
							// DisposeHandle(H);// hum the handle is considered the property of the resource manager now?
						}
					}
					else if(D)
					{
						[badAttributes setObject:D forKey:key];
					}
				}
				else
				{
					ReleaseResource(H);
				}
				--resourceIndex;
			}
			NSEnumerator * E = [attributeKeys objectEnumerator];
			while(key = [E nextObject])
			{
				NSData * D = [attributes objectForKey:key];
				const char * src = [key UTF8String];
				if(strlen(src)<256)
				{
					memcpy(resourceName+1, src, strlen(src));
					resourceName[0]=strlen(src);
					if([D isKindOfClass:[NSData class]])
					{
						if(resError = PtrToHand([D bytes], &H, [D length]))
						{
							if(iTM2DebugEnabled)
							{
								iTM2_LOG(@"WARNING: Could not convert a Ptr into a handle");
							}
							result = NO;
						}
						else
						{
							resourceID = Unique1ID(resourceType);
							if(resError = ResError())
							{
								if(iTM2DebugEnabled)
								{
									iTM2_LOG(@"WARNING: Could not find a unique ID %i", resError);
								}
								result = NO;
							}
							else
							{
								HLock(H);
								AddResource(H, resourceType, resourceID, resourceName);
								HUnlock(H);
								if(resError = ResError())
								{
									if(iTM2DebugEnabled)
									{
										iTM2_LOG(@"Could not AddResource, error %i", resError);
									}
									DisposeHandle(H);// hum the handle is considered the property of the resource manager now?
									result = NO;
								}
								else if(iTM2DebugEnabled>99)
								{
									iTM2_LOG(@"Resource added: %u", resourceID);
								}
								// DisposeHandle(H);// hum the handle is considered the property of the resource manager now?
							}
						}
					}
					else if(D)
					{
						[badAttributes setObject:D forKey:key];
					}
				}
				else if(D)
				{
					[badAttributes setObject:D forKey:key];
				}
			}
			CloseResFile(fileSystemReferenceNumber);
			if(resError = ResError())
			{
				if(iTM2DebugEnabled)
				{
					iTM2_LOG(@"Could not CloseResFile, error %i", resError);
				}
			}
			if(wasCurResFile)
			{
				UseResFile(curResFile);
				if(resError = ResError())
				{
					if(iTM2DebugEnabled)
					{
						iTM2_LOG(@"Could not UseResFile, error %i", resError);
					}
				}
			}
			if([badAttributes count])
			{
				if(iTM2DebugEnabled)
				{
					iTM2_LOG(@"ERROR: Some attributes were not accepted (bad data, bad key)%@", badAttributes);
				}
				result = NO;
			}
		}
else NSLog(@"No spec");
	}
//iTM2_END;
    return result;// even if the resources could not be saved...
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  extendedFileAttributeWithResourceType:resourceID:atPath:error:
- (NSData *)extendedFileAttributeWithResourceType:(ResType)resourceType resourceID:(ResID)resourceID atPath:(NSString *)path error:(NSError **)outErrorPtr;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 06/01/03
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSData * D = nil;
	if(![DFM fileExistsAtPath:path])
	{
		if(outErrorPtr)
			* outErrorPtr = [NSError errorWithDomain:[NSString stringWithUTF8String:__PRETTY_FUNCTION__]
				code: kiTM2ExtendedAttributesNoFileAtPathError userInfo: nil];
		return D;
	}
	path = [path stringByResolvingSymlinksAndFinderAliasesInPath];
	FSRef fileSystemReference;
	if(CFURLGetFSRef((CFURLRef)[NSURL fileURLWithPath:path], &fileSystemReference))
	{
		short curResFile = CurResFile();
		OSErr resError;
		BOOL wasCurResFile = (noErr == ResError());
		short fileSystemReferenceNumber = FSOpenResFile(&fileSystemReference, fsRdPerm);
		if(resError = ResError())
		{
			if(iTM2DebugEnabled)
			{
				iTM2_LOG(@"Could not FSOpenResFile, error %i (fileSystemReferenceNumber: %i)", resError, fileSystemReferenceNumber);
			}
			if(outErrorPtr)
				* outErrorPtr = [NSError errorWithDomain:[NSString stringWithUTF8String:__PRETTY_FUNCTION__]
					code: kiTM2ExtendedAttributesResourceManagerError
						userInfo: [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:resError] forKey:@"ResError"]];
			return nil;
		}
		UseResFile(fileSystemReferenceNumber);
		if(resError = ResError())
		{
			if(iTM2DebugEnabled)
			{
				iTM2_LOG(@"Could not UseResFile, error %i (fileSystemReferenceNumber: %i)", resError, fileSystemReferenceNumber);
			}
			if(outErrorPtr)
				* outErrorPtr = [NSError errorWithDomain:[NSString stringWithUTF8String:__PRETTY_FUNCTION__]
					code: kiTM2ExtendedAttributesResourceManagerError
						userInfo: [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:resError] forKey:@"ResError"]];
			CloseResFile(fileSystemReferenceNumber);
			return nil;
		}
		Handle H = Get1Resource(resourceType, resourceID);
		if((resError = ResError())|| !H)
		{
			if(iTM2DebugEnabled)
			{
				iTM2_LOG(@"Could not Get1Resource, error %i (resourceID is %i)", resError, resourceID);
			}
			if(outErrorPtr)
				* outErrorPtr = [NSError errorWithDomain:[NSString stringWithUTF8String:__PRETTY_FUNCTION__]
					code: kiTM2ExtendedAttributesResourceManagerError
						userInfo: [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:resError] forKey:@"ResError"]];
			return nil;
		}
		if(iTM2DebugEnabled)
		{
			iTM2_LOG(@"Could use Get1Resource, error %i (resourceID is %i)", resError, resourceID);
		}
		HLock(H);
		D = [NSData dataWithBytes:*H length:GetHandleSize(H)];
		HUnlock(H);
		ReleaseResource(H);
		if(resError = ResError())
		{
			if(iTM2DebugEnabled)
			{
				iTM2_LOG(@"Could not ReleaseResource, error %i (resourceID is %@)", resError, resourceID);
			}
			if(outErrorPtr)
				* outErrorPtr = [NSError errorWithDomain:[NSString stringWithUTF8String:__PRETTY_FUNCTION__]
					code: kiTM2ExtendedAttributesResourceManagerError
						userInfo: [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:resError] forKey:@"ResError"]];
		}
		CloseResFile(fileSystemReferenceNumber);
		if(resError = ResError())
		{
			if(iTM2DebugEnabled)
			{
				iTM2_LOG(@"Could not CloseResFile, error %i", resError);
			}
			if(outErrorPtr)
				* outErrorPtr = [NSError errorWithDomain:[NSString stringWithUTF8String:__PRETTY_FUNCTION__]
					code: kiTM2ExtendedAttributesResourceManagerError
						userInfo: [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:resError] forKey:@"ResError"]];
		}
		if(wasCurResFile)
		{
			UseResFile(curResFile);
			if(resError = ResError())
			{
				if(iTM2DebugEnabled)
				{
					iTM2_LOG(@"Could not UseResFile, error %i", resError);
				}
				if(outErrorPtr)
					* outErrorPtr = [NSError errorWithDomain:[NSString stringWithUTF8String:__PRETTY_FUNCTION__]
						code: kiTM2ExtendedAttributesResourceManagerError
							userInfo: [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:resError] forKey:@"ResError"]];
			}
		}
	}
//iTM2_END;
	return D;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  addExtendedFileAttribute:value:withResourceType:resourceID:atPath:error:
- (BOOL)addExtendedFileAttribute:(NSString*)attributeName value:(NSData *)D withResourceType:(ResType)resourceType resourceID:(ResID)resourceID atPath:(NSString *)path error:(NSError **)outErrorPtr;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 06/01/03
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(![DFM fileExistsAtPath:path])
	{
		return NO;
	}
	path = [path stringByResolvingSymlinksAndFinderAliasesInPath];
	BOOL result = YES;
	FSRef fileSystemReference;
	if(CFURLGetFSRef((CFURLRef)[NSURL fileURLWithPath:path], &fileSystemReference))
	{
		FSSpec spec;
		if(noErr == FSGetCatalogInfo(&fileSystemReference, kFSCatInfoNone, nil, nil, &spec, nil))
		{
			short curResFile = CurResFile();
			OSErr resError;
			BOOL wasCurResFile = (noErr == ResError());
			NSDictionary * fileAttributes = [DFM fileAttributesAtPath:path traverseLink:NO];
			FSpCreateResFile(&spec, [fileAttributes fileHFSCreatorCode], [fileAttributes fileHFSTypeCode], smRoman);
			// no error check needed
			short fileSystemReferenceNumber = FSOpenResFile(&fileSystemReference, fsWrPerm);
			if(resError = ResError())
			{
				if(iTM2DebugEnabled)
				{
					iTM2_LOG(@"Could not FSOpenResFile, error %i, fileSystemReferenceNumber: %i", resError, fileSystemReferenceNumber);
				}
				CloseResFile(fileSystemReferenceNumber);
				return NO;
			}
			UseResFile(fileSystemReferenceNumber);
			if(resError = ResError())
			{
				if(iTM2DebugEnabled)
				{
					iTM2_LOG(@"Could not UseResFile, error %i, fileSystemReferenceNumber: %i", resError, fileSystemReferenceNumber);
				}
				CloseResFile(fileSystemReferenceNumber);
				return NO;
			}
			Handle H = Get1Resource(resourceType, resourceID);
			if(resError = ResError())
			{
				if(iTM2DebugEnabled)
				{
					iTM2_LOG(@"Could not Get1Resource, error %i (resourceID is %i)", resError, resourceID);
				}
			}
			else if(iTM2DebugEnabled)
			{
				iTM2_LOG(@"Could use Get1Resource, error %i (resourceID is %i)", resError, resourceID);
			}
			if(resError = PtrToHand([D bytes], &H, [D length]))
			{
				if(iTM2DebugEnabled)
				{
					iTM2_LOG(@"WARNING: Could not convert a Ptr into a handle");
				}
			}
			else
			{
				NSRange r = NSMakeRange(0, [attributeName length]);
				if(r.length>255)
				{
					r.length = 255;
					attributeName = [attributeName substringWithRange:r];
				}
				const char * src = nil;
createSrc:
				src = [attributeName UTF8String];
				if((strlen(src)> 255) && r.length)
				{
					--r.length;
					attributeName = [attributeName substringWithRange:r];
					goto createSrc;
				}
				Str255 resourceName;
				memcpy(resourceName+1, src, strlen(src));
				resourceName[0]=strlen(src);
				HLock(H);
				AddResource(H, resourceType, resourceID, resourceName);
				HUnlock(H);
				if(resError = ResError())
				{
					if(iTM2DebugEnabled)
					{
						iTM2_LOG(@"Could not AddResource, error %i", resError);
					}
					DisposeHandle(H);// hum the handle is considered the property of the resource manager now?
				}
				else if(iTM2DebugEnabled>99)
				{
					iTM2_LOG(@"Resource added: %u", resourceID);
				}
				// DisposeHandle(H);// hum the handle is considered the property of the resource manager now?
			}
			CloseResFile(fileSystemReferenceNumber);
			if(resError = ResError())
			{
				iTM2_LOG(@"Could not CloseResFile, error %i", resError);
			}
			if(wasCurResFile)
			{
				UseResFile(curResFile);
				if(resError = ResError())
				{
					if(iTM2DebugEnabled)
					{
						iTM2_LOG(@"Could not UseResFile, error %i", resError);
					}
				}
			}
		}
else NSLog(@"No spec");
	}
//iTM2_END;
    return result;// even if the resources could not be saved...
}
@end
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= NSFileManager(iTeXMac2)

@implementation NSData(iTM2ALias)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  writeAsFinderAliasToURL:options:error:
- (BOOL)writeAsFinderAliasToURL:(NSURL *)url options:(unsigned)writeOptionsMask error:(NSError **)outErrorPtr;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 06/01/03
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_LOG(@"0");
	if(![url isFileURL])
	{
		if(outErrorPtr)
		{
			*outErrorPtr = [NSError errorWithDomain:[NSString stringWithUTF8String:__PRETTY_FUNCTION__] code:1
							userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"Could not create a finder alias at\n%@\nfile url required.", url]
								forKey:NSLocalizedDescriptionKey]];
		}
		return NO;
	}
//iTM2_LOG(@"1");
	NSString * path = [url path];
	if(([DFM fileExistsAtPath:path] || [DFM pathContentOfSymbolicLinkAtPath:path]) && ![DFM removeFileAtPath:path handler:NULL])
	{
		if(outErrorPtr)
		{
			*outErrorPtr = [NSError errorWithDomain:[NSString stringWithUTF8String:__PRETTY_FUNCTION__] code:2
							userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"Could not remove file at\n%@", path]
								forKey:NSLocalizedDescriptionKey]];
		}
		return NO;
	}
//iTM2_LOG(@"2");
	BOOL result = [[NSData data] writeToURL:url options:writeOptionsMask error:outErrorPtr];
	if(result
		&& [DFM addExtendedFileAttribute:@"Alias" value:self withResourceType:'alis' resourceID:0 atPath:path error:outErrorPtr])
#if 0
	{
		result = NO;
		FSRef theFSRef;
		FSSpec theFSSpec;
		struct FInfo theInfo = { 0 };

		if( (!CFURLGetFSRef ((CFURLRef)url, &theFSRef)) && FSpGetFInfo( &theFSSpec, &theInfo) == noErr )
		{
			theInfo.fdFlags = kIsAlias | (theInfo.fdFlags & !kIsAlias);
			theInfo.fdType = 'alis';
			theInfo.fdCreator = 'MACS';

			result = FSpSetFInfo( &theFSSpec, &theInfo) == noErr;
		}
	}
#else
	{
//iTM2_LOG(@"3");
		FSRef theFSRef;
		if(CFURLGetFSRef ((CFURLRef)url, &theFSRef))
		{
//iTM2_LOG(@"4");
			FinderInfo finderInfo = {0};
			OSErr error = FSGetFinderInfo(&theFSRef, &finderInfo, NULL, NULL);
			if(error)
			{
				return NO;
			}
//iTM2_LOG(@"5");
			finderInfo.file.finderFlags = kIsAlias | (finderInfo.file.finderFlags & !kIsAlias);
			finderInfo.file.fileType = 'alis';
			finderInfo.file.fileCreator = 'MACS';
			error = FSSetFinderInfo(&theFSRef, &finderInfo, nil);
			if(error)
			{
				return NO;
			}
//iTM2_LOG(@"6");
		}
	}
#endif
//iTM2_END;
	return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  aliasDataWithContentsOfURL:error:
+ (NSData *)aliasDataWithContentsOfURL:(NSURL *)absoluteURL error:(NSError **)error;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 06/01/03
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;

//iTM2_END;
	return [absoluteURL isFileURL]?
		[DFM extendedFileAttributeWithResourceType:'alis' resourceID:0 atPath:[absoluteURL path] error:nil]
		: nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  pathByResolvingDataAlias:relativeTo:error:
- (NSString*)pathByResolvingDataAliasRelativeTo:(NSString *)base error:(NSError **)error;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 06/01/03
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	FSRef * fromFile = NULL;
	FSRef baseRef;
	BOOL isDirectory;
	base = [base stringByResolvingSymlinksInPath];
	OSErr theErr;
	if([DFM fileExistsAtPath:base isDirectory:&isDirectory] && isDirectory)
	{
		if(!CFURLGetFSRef ((CFURLRef)[NSURL fileURLWithPath:base], &baseRef))
		{
			theErr = 1;
			goto jail;
		}
		fromFile = &baseRef;
	}
	AliasHandle dstHndl = NULL;
	if(theErr = PtrToHand([self bytes], (Handle*)&dstHndl, [self length]))
	{
		goto jail;
	}
	FSRef targetRef;
	Boolean wasChanged;
	if(theErr = FSResolveAlias(NULL, dstHndl, &targetRef, &wasChanged))
	{
		goto jail;
	}
    UInt32 maxPathSize = 6400;
	UInt8 * path = calloc(maxPathSize, sizeof(UInt8));
	if(!path)
	{
		theErr = MemError();
		goto jail;
	}
	if(theErr = FSRefMakePath (&targetRef, path, maxPathSize))
	{
		goto jail;
	}
//iTM2_END;
	return [NSString stringWithUTF8String:(const char *)path];
jail:
	if(error)
		*error = [NSError errorWithDomain:[NSString stringWithUTF8String:__PRETTY_FUNCTION__] code:theErr userInfo:nil];
//iTM2_END;
	return nil;
}
@end

@implementation NSString(iTM2FileManagerKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  dataAliasRelativeTo:error:
- (NSData*)dataAliasRelativeTo:(NSString *)base error:(NSError **)error;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 06/01/03
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	OSErr theErr = noErr;
	FSRef * fromFile = NULL;
	FSRef baseRef;
	BOOL isDirectory;
	if([DFM fileExistsAtPath:base isDirectory:&isDirectory] && isDirectory)
	{
		if(!CFURLGetFSRef ((CFURLRef)[NSURL fileURLWithPath:base], &baseRef))
		{
			if(error)
				*error = [NSError errorWithDomain:[NSString stringWithUTF8String:__PRETTY_FUNCTION__] code:1 userInfo:nil];
			return nil;
		}
		fromFile = &baseRef;
	}
	FSRef targetParentRef;
	NSString * dirName = [self stringByDeletingLastPathComponent];
	if(!CFURLGetFSRef ((CFURLRef)[NSURL fileURLWithPath:dirName], &targetParentRef))
	{
		if(error)
			*error = [NSError errorWithDomain:[NSString stringWithUTF8String:__PRETTY_FUNCTION__] code:2 userInfo:nil];
		return nil;
	}
	NSString * baseName = [self lastPathComponent];
	UniCharCount targetNameLength = [baseName length];
	NSAssert(sizeof(UniChar)==sizeof(unichar), @"Inconsistent size of unicode character.");
	UniChar * targetName = calloc(targetNameLength, sizeof(UniChar));
	if(!targetName)
	{
		theErr = MemError();
		goto jail;
	}
	[baseName getCharacters:targetName];
	AliasHandle	inAlias;
	NSData * result = nil;
	if(theErr = FSNewAliasUnicode(fromFile, &targetParentRef, targetNameLength, targetName, &inAlias, NULL))
	{
		goto jail;
	}
	else
	{
		HLock((Handle)inAlias);
		Size size = GetPtrSize((Ptr)*inAlias);
		if(!size)
		{
			if(theErr = MemError())
			{
				goto jail;
			}
		}
		else
		{
			result = [NSData dataWithBytes:*inAlias length:size];
			HUnlock((Handle)inAlias);
			DisposeHandle((Handle)inAlias);
			if(theErr = MemError())
			{
				goto jail;
			}
		}
	}
	goto theEnd;
jail:
	if(error)
		*error = [NSError errorWithDomain:[NSString stringWithUTF8String:__PRETTY_FUNCTION__] code:theErr userInfo:nil];
theEnd:
//iTM2_END;
	free(targetName);
	return result;
}
@end
