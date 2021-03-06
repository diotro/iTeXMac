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
#import <iTM2Foundation/iTM2PathUtilities.h>
#import <iTM2Foundation/iTM2BundleKit.h>

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
    if([path isAbsolutePath] && ![self changeCurrentDirectoryPath:NSOpenStepRootDirectory()])
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
					*outErrorPtr = [NSError errorWithDomain:__iTM2_PRETTY_FUNCTION__ code:1
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
					*outErrorPtr = [NSError errorWithDomain:__iTM2_PRETTY_FUNCTION__ code:2
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
				*outErrorPtr = [NSError errorWithDomain:__iTM2_PRETTY_FUNCTION__ code:2
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
		struct stat myStat;
		if(noErr == stat([fileName fileSystemRepresentation], &myStat))
		{
			oldPosixPermissions = myStat.st_mode;
		}
		unsigned int newPosixPermissions = oldPosixPermissions | S_IWUSR;
		if(oldPosixPermissions != newPosixPermissions)
		{
			if(chmod([fileName fileSystemRepresentation],newPosixPermissions) != noErr)
			{
				[fileAttributes setObject:[NSNumber numberWithUnsignedInt:newPosixPermissions] forKey:NSFilePosixPermissions];
				[self changeFileAttributes:fileAttributes atPath:fileName];
			}
		}
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
				*outErrorPtr = [NSError errorWithDomain:__iTM2_PRETTY_FUNCTION__ code:status
					userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"Could not create an FSRef for %@", path] forKey:NSLocalizedDescriptionKey]];
			}
//iTM2_END;
			return YES;
		}
		OSErr err = FSIsAliasFile(&ref,(Boolean*)isAlias, NULL);
		if(err)
		{
			[NSError errorWithDomain:__iTM2_PRETTY_FUNCTION__ code:err
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
- (BOOL)isVisibleFileAtPath:(NSString *)path;
{
//iTM2_LOG(@"path: %@", path);
	path = [path lastPathComponent];
	return ![path hasPrefix:@"."];
}
- (BOOL)trashedIsPrivateFileAtPath:(NSString *)path;
{
	return [[path pathComponents] containsObject:@".Trash"];
}
- (BOOL)isPrivateFileAtPath:(NSString *)path;
{
//iTM2_LOG(@"path: %@", path);
    NSMethodSignature * sig0 = [self methodSignatureForSelector:_cmd];
    NSInvocation * I = [NSInvocation invocationWithMethodSignature:sig0];
    [I setTarget:self];
    [I setArgument:&path atIndex:2];
    BOOL result = NO;
	NSEnumerator * E = [[iTM2RuntimeBrowser instanceSelectorsOfClass:isa withSuffix:@"IsPrivateFileAtPath:" signature:sig0 inherited:YES] objectEnumerator];
	// BEWARE, the didReadFromURL:ofType:methods are not called here because they do not have the appropriate signature!
    SEL selector;
    while(selector = (SEL)[[E nextObject] pointerValue])
    {
        if(iTM2DebugEnabled>99)
        {
            iTM2_LOG(@"Performing:%@", NSStringFromSelector(selector));
//iTM2_LOG(@"Base project model is:%@", [[self implementation] modelOfType:@"frontends"]);
        }
        [I setSelector:selector];
        [I invoke];
        BOOL R = NO;
        [I getReturnValue:&R];
        if(iTM2DebugEnabled>99)
        {
            iTM2_LOG(@"Performed:%@ with result:%@", NSStringFromSelector(selector), (R? @"YES":@"NO"));
//iTM2_LOG(@"Base project model is:%@", [[self implementation] modelOfType:@"frontends"]);
        }
        result = result || R;
    }
	return result;
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
	iTM2RedirectNSLogOutput();
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
				iTM2_LOG(@"1 - Could not FSOpenResFile, at %@ error %i (fileSystemReferenceNumber: %i)",path,resError,fileSystemReferenceNumber);
			}
			iTM2_OUTERROR(kiTM2ExtendedAttributesResourceManagerError,([NSString stringWithFormat:@"1 - Could not FSOpenResFile, at %@ error %i (fileSystemReferenceNumber: %i)",path,resError,fileSystemReferenceNumber]),nil);
			return nil;
		}
		UseResFile(fileSystemReferenceNumber);
		if(resError = ResError())
		{
			if(iTM2DebugEnabled)
			{
				iTM2_LOG(@"2 - Could not UseResFile, at %@ error %i (fileSystemReferenceNumber: %i)",path,resError,fileSystemReferenceNumber);
			}
			iTM2_OUTERROR(kiTM2ExtendedAttributesResourceManagerError,([NSString stringWithFormat:@"2 - Could not UseResFile, at %@ error %i (fileSystemReferenceNumber: %i)",path,resError,fileSystemReferenceNumber]),nil);
			CloseResFile(fileSystemReferenceNumber);
			if(resError = ResError())
			{
				if(iTM2DebugEnabled)
				{
					iTM2_LOG(@"2-Last - Could not CloseResFile, error %i", resError);
				}
				iTM2_OUTERROR(kiTM2ExtendedAttributesResourceManagerError,([NSString stringWithFormat:@"2-Last - Could not CloseResFile, error %i", resError]),nil);
			}
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
					iTM2_LOG(@"3 - Could not Get1Resource, error %i (resourceIndex is %i)", resError, resourceIndex);
				}
				iTM2_OUTERROR(kiTM2ExtendedAttributesResourceManagerError,([NSString stringWithFormat:@"3 - Could not Get1Resource, error %i (resourceIndex is %i)", resError, resourceIndex]),nil);
				--resourceIndex;
				goto nextLoop;
			}
			if(iTM2DebugEnabled)
			{
				iTM2_LOG(@"4 - Could use Get1Resource, error %i (resourceIndex is %i)", resError, resourceIndex);
			}
			Str255 resourceName;
			GetResInfo(H, nil, nil, resourceName);
			if(resError = ResError())
			{
				if(iTM2DebugEnabled)
				{
					iTM2_LOG(@"5 - Could not GetResInfo, error %i (resourceIndex is %i)", resError, resourceIndex);
				}
				iTM2_OUTERROR(kiTM2ExtendedAttributesResourceManagerError,([NSString stringWithFormat:@"5 - Could not GetResInfo, error %i (resourceIndex is %i)", resError, resourceIndex]),nil);
				--resourceIndex;
				goto nextLoop;
			}
			if(iTM2DebugEnabled)
			{
				iTM2_LOG(@"6 - Could use GetResInfo, error %i (resourceIndex is %i)", resError, resourceIndex);
			}
			HLock(H);
			NSData * D = [NSData dataWithBytes:*H length:GetHandleSize(H)];
			HUnlock(H);
			ReleaseResource(H);
			if(resError = ResError())
			{
				if(iTM2DebugEnabled)
				{
					iTM2_LOG(@"7 - Could not ReleaseResource, error %i (resourceIndex is %i)", resError, resourceIndex);
				}
				iTM2_OUTERROR(kiTM2ExtendedAttributesResourceManagerError,([NSString stringWithFormat:@"7 - Could not ReleaseResource, error %i (resourceIndex is %i)", resError, resourceIndex]),nil);
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
				iTM2_LOG(@"8 - Could not CloseResFile, error %i", resError);
			}
			iTM2_OUTERROR(kiTM2ExtendedAttributesResourceManagerError,([NSString stringWithFormat:@"8 - Could not CloseResFile, error %i", resError]),nil);
		}
		if(wasCurResFile)
		{
			UseResFile(curResFile);
			if(resError = ResError())
			{
				if(iTM2DebugEnabled)
				{
					iTM2_LOG(@"9 - Could not UseResFile, error %i", resError);
				}
			}
			iTM2_OUTERROR(kiTM2ExtendedAttributesResourceManagerError,([NSString stringWithFormat:@"9 - Could not UseResFile, error %i", resError]),nil);
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
			* outErrorPtr = [NSError errorWithDomain:__iTM2_PRETTY_FUNCTION__
				code: kiTM2ExtendedAttributesNoFileAtPathError userInfo: nil];
		return D;
	}
	path = [path stringByResolvingSymlinksAndFinderAliasesInPath];
	const char * src = [attributeName UTF8String];
	if(strlen(src)>= 256)
	{
		if(outErrorPtr)
			* outErrorPtr = [NSError errorWithDomain:__iTM2_PRETTY_FUNCTION__
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
				iTM2_LOG(@"1 - Could not FSOpenResFile, at %@ error %i (fileSystemReferenceNumber: %i)",path,resError,fileSystemReferenceNumber);
			}
			if(outErrorPtr)
				* outErrorPtr = [NSError errorWithDomain:__iTM2_PRETTY_FUNCTION__
					code: kiTM2ExtendedAttributesResourceManagerError
						userInfo: [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:resError] forKey:@"ResError"]];
			return nil;
		}
		UseResFile(fileSystemReferenceNumber);
		if(resError = ResError())
		{
			if(iTM2DebugEnabled)
			{
				iTM2_LOG(@"2 - Could not UseResFile, at %@ error %i (fileSystemReferenceNumber: %i)",path,resError,fileSystemReferenceNumber);
			}
			if(outErrorPtr)
				* outErrorPtr = [NSError errorWithDomain:__iTM2_PRETTY_FUNCTION__
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
				iTM2_LOG(@"3 - Could not Get1NamedResource, error %i (attributeName is %@)", resError, attributeName);
			}
			if(outErrorPtr)
				* outErrorPtr = [NSError errorWithDomain:__iTM2_PRETTY_FUNCTION__
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
				iTM2_LOG(@"4 - Could not ReleaseResource, error %i (attributeName is %@)", resError, attributeName);
			}
			if(outErrorPtr)
				* outErrorPtr = [NSError errorWithDomain:__iTM2_PRETTY_FUNCTION__
					code: kiTM2ExtendedAttributesResourceManagerError
						userInfo: [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:resError] forKey:@"ResError"]];
		}
		CloseResFile(fileSystemReferenceNumber);
		if(resError = ResError())
		{
			if(iTM2DebugEnabled)
			{
				iTM2_LOG(@"5 - Could not CloseResFile, error %i", resError);
			}
			if(outErrorPtr)
				* outErrorPtr = [NSError errorWithDomain:__iTM2_PRETTY_FUNCTION__
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
					iTM2_LOG(@"6 - Could not UseResFile, error %i", resError);
				}
				if(outErrorPtr)
					* outErrorPtr = [NSError errorWithDomain:__iTM2_PRETTY_FUNCTION__
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
					iTM2_LOG(@"1 - Could not FSOpenResFile, at %@, error %i, fileSystemReferenceNumber: %i",path,resError,fileSystemReferenceNumber);
				}
				CloseResFile(fileSystemReferenceNumber);
				return NO;
			}
			UseResFile(fileSystemReferenceNumber);
			if(resError = ResError())
			{
				if(iTM2DebugEnabled)
				{
					iTM2_LOG(@"2 - Could not UseResFile, at %@, error %i, fileSystemReferenceNumber: %i",path,resError,fileSystemReferenceNumber);
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
					iTM2_LOG(@"3 - Could not Get1NamedResource, error %i (attributeName is %@)", resError, attributeName);
				}
			}
			else if(iTM2DebugEnabled)
			{
				iTM2_LOG(@"4 - Could use Get1NamedResource, error %i (attributeName is %@)", resError, attributeName);
			}
			short resourceID;
			if(H)
			{
				GetResInfo(H, &resourceID, nil, resourceName);
				if(resError = ResError())
				{
					if(iTM2DebugEnabled)
					{
						iTM2_LOG(@"5 - Could not GetResInfo, error %i (attributeName is %@)", resError, attributeName);
					}
				}
				else if(iTM2DebugEnabled)
				{
					iTM2_LOG(@"6 - Could use GetResInfo, error %i (attributeName is %@)", resError, attributeName);
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
					iTM2_LOG(@"7 - WARNING: Could not convert a Ptr into a handle");
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
						iTM2_LOG(@"8 - Could not AddResource, error %i", resError);
					}
					DisposeHandle(H);// hum the handle is considered the property of the resource manager now?
				}
				else if(iTM2DebugEnabled>99)
				{
					iTM2_LOG(@"9 - Resource added: %u", resourceID);
				}
				// DisposeHandle(H);// hum the handle is considered the property of the resource manager now?
			}
			CloseResFile(fileSystemReferenceNumber);
			if(resError = ResError())
			{
				iTM2_LOG(@"10 - Could not CloseResFile, error %i", resError);
			}
			if(wasCurResFile)
			{
				UseResFile(curResFile);
				if(resError = ResError())
				{
					if(iTM2DebugEnabled)
					{
						iTM2_LOG(@"11 - Could not UseResFile, error %i", resError);
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
			* outErrorPtr = [NSError errorWithDomain:__iTM2_PRETTY_FUNCTION__
				code: kiTM2ExtendedAttributesNoFileAtPathError userInfo: nil];
		return NO;
	}
	path = [path stringByResolvingSymlinksAndFinderAliasesInPath];
	BOOL result = YES;
	const char * src = [attributeName UTF8String];
	if(strlen(src)>= 256)
	{
		if(outErrorPtr)
			* outErrorPtr = [NSError errorWithDomain:__iTM2_PRETTY_FUNCTION__
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
					iTM2_LOG(@"1 - Could not FSOpenResFile, at %@, error %i, fileSystemReferenceNumber: %i",path,resError,fileSystemReferenceNumber);
				}
				CloseResFile(fileSystemReferenceNumber);
				if(outErrorPtr)
					* outErrorPtr = [NSError errorWithDomain:__iTM2_PRETTY_FUNCTION__
						code: kiTM2ExtendedAttributesResourceManagerError
							userInfo: [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:resError] forKey:@"ResError"]];
				return NO;
			}
			UseResFile(fileSystemReferenceNumber);
			if(resError = ResError())
			{
				if(iTM2DebugEnabled)
				{
					iTM2_LOG(@"2 - Could not UseResFile, at %@, error %i, fileSystemReferenceNumber: %i",path,resError,fileSystemReferenceNumber);
				}
				CloseResFile(fileSystemReferenceNumber);
				if(outErrorPtr)
					* outErrorPtr = [NSError errorWithDomain:__iTM2_PRETTY_FUNCTION__
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
					* outErrorPtr = [NSError errorWithDomain:__iTM2_PRETTY_FUNCTION__
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
						* outErrorPtr = [NSError errorWithDomain:__iTM2_PRETTY_FUNCTION__
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
						* outErrorPtr = [NSError errorWithDomain:__iTM2_PRETTY_FUNCTION__
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
					* outErrorPtr = [NSError errorWithDomain:__iTM2_PRETTY_FUNCTION__
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
						* outErrorPtr = [NSError errorWithDomain:__iTM2_PRETTY_FUNCTION__
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
	BOOL isDirectory = NO;
	if(![DFM fileExistsAtPath:path isDirectory:&isDirectory] || isDirectory)
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
			if(resError = ResError())
			{
				if(iTM2DebugEnabled)
				{
					iTM2_LOG(@"0 - Could not FSpCreateResFile, error %i (-48 is OK)", resError);
				}
			}
			// no error check needed
			short fileSystemReferenceNumber = FSOpenResFile(&fileSystemReference, fsWrPerm);
			if(resError = ResError())
			{
				if(iTM2DebugEnabled)
				{
					iTM2_LOG(@"1 - Could not FSOpenResFile, at %@, error %i, fileSystemReferenceNumber: %i",path,resError,fileSystemReferenceNumber);
				}
				CloseResFile(fileSystemReferenceNumber);
				iTM2_OUTERROR(kiTM2ExtendedAttributesResourceManagerError,([NSString stringWithFormat:@"1 - Could not FSOpenResFile, at %@, error %i, fileSystemReferenceNumber: %i",path,resError,fileSystemReferenceNumber]),nil);
				return NO;
			}
			UseResFile(fileSystemReferenceNumber);
			if(resError = ResError())
			{
				if(iTM2DebugEnabled)
				{
					iTM2_LOG(@"2 - Could not UseResFile, at %@, error %i, fileSystemReferenceNumber: %i",path,resError,fileSystemReferenceNumber);
				}
				iTM2_OUTERROR(kiTM2ExtendedAttributesResourceManagerError,([NSString stringWithFormat:@"2 - Could not UseResFile, at %@, error %i, fileSystemReferenceNumber: %i",path,resError,fileSystemReferenceNumber]),nil);
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
						iTM2_LOG(@"3 - Could not Get1Resource, error %i (resourceIndex is %i)", resError, resourceIndex);
						iTM2_OUTERROR(3,([NSString stringWithFormat:@"3 - Could not Get1Resource, error %i (resourceIndex is %i)", resError, resourceIndex]),nil);
					}
					--resourceIndex;
					goto nextLoop;
				}
				if(iTM2DebugEnabled)
				{
					iTM2_LOG(@"4 - Could use Get1Resource, error %i (resourceIndex is %i)", resError, resourceIndex);
				}
				GetResInfo(H, &resourceID, nil, resourceName);
				if(resError = ResError())
				{
					if(iTM2DebugEnabled)
					{
						iTM2_LOG(@"5 - Could not GetResInfo, error %i (resourceIndex is %i)", resError, resourceIndex);
						iTM2_OUTERROR(3,([NSString stringWithFormat:@"5 - Could not GetResInfo, error %i (resourceIndex is %i)", resError, resourceIndex]),nil);
					}
					--resourceIndex;
					goto nextLoop;
				}
				if(iTM2DebugEnabled)
				{
					iTM2_LOG(@"6 - Could use GetResInfo, error %i (resourceIndex is %i)", resError, resourceIndex);
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
							iTM2_LOG(@"7 - Could not RemoveResource, error %i (resourceIndex is %i)", resError, resourceIndex);
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
									iTM2_LOG(@"8 - Could not AddResource, error %i", resError);
								}
								DisposeHandle(H);// hum the handle is considered the property of the resource manager now?
							}
							else if(iTM2DebugEnabled>99)
							{
								iTM2_LOG(@"9 - Resource added: %u", resourceID);
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
								iTM2_LOG(@"10 - WARNING: Could not convert a Ptr into a handle");
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
									iTM2_LOG(@"11 - WARNING: Could not find a unique ID %i", resError);
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
										iTM2_LOG(@"12 - Could not AddResource, error %i", resError);
									}
									DisposeHandle(H);// hum the handle is considered the property of the resource manager now?
									result = NO;
								}
								else if(iTM2DebugEnabled>99)
								{
									iTM2_LOG(@"13 - Resource added: %u", resourceID);
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
					iTM2_LOG(@"14 - Could not CloseResFile, error %i", resError);
				}
			}
			if(wasCurResFile)
			{
				UseResFile(curResFile);
				if(resError = ResError())
				{
					if(iTM2DebugEnabled)
					{
						iTM2_LOG(@"15 - Could not UseResFile, error %i", resError);
					}
				}
			}
			if([badAttributes count])
			{
				if(iTM2DebugEnabled)
				{
					iTM2_LOG(@"16 - ERROR: Some attributes were not accepted (bad data, bad key)%@", badAttributes);
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
			* outErrorPtr = [NSError errorWithDomain:__iTM2_PRETTY_FUNCTION__
				code: kiTM2ExtendedAttributesNoFileAtPathError userInfo: nil];
		return D;
	}
	path = [path stringByResolvingSymlinksInPath];// no finder alias resolution!!!
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
				iTM2_LOG(@"1 - Could not FSOpenResFile at %@ error %i (fileSystemReferenceNumber: %i)",path,resError,fileSystemReferenceNumber);
			}
			if(outErrorPtr)
				* outErrorPtr = [NSError errorWithDomain:__iTM2_PRETTY_FUNCTION__
					code: kiTM2ExtendedAttributesResourceManagerError
						userInfo: [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:resError] forKey:@"ResError"]];
			return nil;
		}
		UseResFile(fileSystemReferenceNumber);
		if(resError = ResError())
		{
			if(iTM2DebugEnabled)
			{
				iTM2_LOG(@"2 - Could not UseResFile, at %@ error %i (fileSystemReferenceNumber: %i)",path,resError,fileSystemReferenceNumber);
			}
			if(outErrorPtr)
				* outErrorPtr = [NSError errorWithDomain:__iTM2_PRETTY_FUNCTION__
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
				iTM2_LOG(@"3 - Could not Get1Resource, at %@ error %i (resourceID is %i)", path,resError,resourceID);
				iTM2_OUTERROR(2,([NSString stringWithFormat:@"Could not Get1Resource, at %@ error %i (resourceID is %i)", path,resError,resourceID]),nil);
			}
			if(outErrorPtr)
				* outErrorPtr = [NSError errorWithDomain:__iTM2_PRETTY_FUNCTION__
					code: kiTM2ExtendedAttributesResourceManagerError
						userInfo: [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:resError] forKey:@"ResError"]];
			return nil;
		}
		if(iTM2DebugEnabled)
		{
			iTM2_LOG(@"4 - Could use Get1Resource, at %@ error %i (resourceID is %i)", path,resError,resourceID);
		}
		HLock(H);
		D = [NSData dataWithBytes:*H length:GetHandleSize(H)];
		HUnlock(H);
		ReleaseResource(H);
		if(resError = ResError())
		{
			if(iTM2DebugEnabled)
			{
				iTM2_LOG(@"5 - Could not ReleaseResource, at %@ error %i (resourceID is %@)",path,resError,resourceID);
			}
			if(outErrorPtr)
				* outErrorPtr = [NSError errorWithDomain:__iTM2_PRETTY_FUNCTION__
					code: kiTM2ExtendedAttributesResourceManagerError
						userInfo: [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:resError] forKey:@"ResError"]];
		}
		CloseResFile(fileSystemReferenceNumber);
		if(resError = ResError())
		{
			if(iTM2DebugEnabled)
			{
				iTM2_LOG(@"6 - Could not CloseResFile, error %i", resError);
			}
			if(outErrorPtr)
				* outErrorPtr = [NSError errorWithDomain:__iTM2_PRETTY_FUNCTION__
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
					iTM2_LOG(@"7 - Could not UseResFile, error %i", resError);
				}
				if(outErrorPtr)
					* outErrorPtr = [NSError errorWithDomain:__iTM2_PRETTY_FUNCTION__
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
	path = [path stringByResolvingSymlinksInPath];// No Finder alias resolution!!! because I can have to add an extended attribute to a, alias file.
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
					iTM2_LOG(@"1 - Could not FSOpenResFile, at %@, error %i, fileSystemReferenceNumber: %i",path,resError,fileSystemReferenceNumber);
				}
				CloseResFile(fileSystemReferenceNumber);
				return NO;
			}
			UseResFile(fileSystemReferenceNumber);
			if(resError = ResError())
			{
				if(iTM2DebugEnabled)
				{
					iTM2_LOG(@"2 - Could not UseResFile, at %@, error %i, fileSystemReferenceNumber: %i",path,resError,fileSystemReferenceNumber);
				}
				CloseResFile(fileSystemReferenceNumber);
				if(resError = ResError())
				{
					if(iTM2DebugEnabled)
					{
						iTM2_LOG(@"2-End - Could not CloseResFile, at %@ error %i (resourceID is %i)", path,resError,resourceID);
					}
				}
				return NO;
			}
			Handle H = Get1Resource(resourceType, resourceID);
			if(resError = ResError())
			{
				if(iTM2DebugEnabled)
				{
					iTM2_LOG(@"3 - Could not Get1Resource, at %@ error %i (resourceID is %i)", path,resError,resourceID);
					iTM2_OUTERROR(3,([NSString stringWithFormat:@"3 - Could not Get1Resource, at %@ error %i (resourceID is %i)", path,resError,resourceID]),nil);
				}
			}
			else if(iTM2DebugEnabled)
			{
				iTM2_LOG(@"4 - Could use Get1Resource, at %@ error %i (resourceID is %i)", path,resError,resourceID);
			}
			if(resError = PtrToHand([D bytes], &H, [D length]))
			{
				if(iTM2DebugEnabled)
				{
					iTM2_LOG(@"5 - WARNING: Could not convert a Ptr into a handle");
					iTM2_OUTERROR(3,([NSString stringWithFormat:@"5 - WARNING: Could not convert a Ptr into a handle"]),nil);
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
						iTM2_LOG(@"6 - Could not AddResource, error %i", resError);
					}
					DisposeHandle(H);// hum the handle is considered the property of the resource manager now?
				}
				else if(iTM2DebugEnabled>99)
				{
					iTM2_LOG(@"7 - Resource added: %u", resourceID);
				}
				// DisposeHandle(H);// hum the handle is considered the property of the resource manager now?
			}
			CloseResFile(fileSystemReferenceNumber);
			if(resError = ResError())
			{
				iTM2_LOG(@"8 - Could not CloseResFile, error %i", resError);
				iTM2_OUTERROR(3,([NSString stringWithFormat:@"8 - Could not CloseResFile, error %i", resError]),nil);
			}
			if(wasCurResFile)
			{
				UseResFile(curResFile);
				if(resError = ResError())
				{
					if(iTM2DebugEnabled)
					{
						iTM2_LOG(@"9 - Could not UseResFile, error %i", resError);
					}
					iTM2_OUTERROR(3,([NSString stringWithFormat:@"9 - Could not UseResFile, error %i", resError]),nil);
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

@implementation NSData(iTM2Alias)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  writeAsFinderAliasToURL:options:error:
- (BOOL)writeAsFinderAliasToURL:(NSURL *)url options:(unsigned)writeOptionsMask error:(NSError **)outErrorPtr;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 06/01/03
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_LOG(@"url:%@",url);
	if(![url isFileURL])
	{
		if(outErrorPtr)
		{
			*outErrorPtr = [NSError errorWithDomain:__iTM2_PRETTY_FUNCTION__ code:1
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
			*outErrorPtr = [NSError errorWithDomain:__iTM2_PRETTY_FUNCTION__ code:2
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
			if(iTM2DebugEnabled)
			{
				NSError * error = nil;
				NSData * d = [NSData aliasDataWithContentsOfURL:url error:&error];
				if(![self isEqualToData:d])
				{
					d = [NSData aliasDataWithContentsOfURL:url error:&error];
				}
				NSAssert([self isEqualToData:d],@"**** There is a big problem: the alias is not persistent");
 			}
//iTM2_LOG(@"6");
		}
	}
#endif
//iTM2_END;
	return result;
}

#if 0
http://developer.apple.com/technotes/tn/tn1188.html
/* MakeRelativeAliasFile creates a new alias file located at
    aliasDest referring to the targetFile.  relative path
    information is stored in the new file. */

OSErr MakeRelativeAliasFile(FSSpec *targetFile, FSSpec *aliasDest) {
    FInfo fndrInfo;
    AliasHandle theAlias;
    Boolean fileCreated;
    short rsrc;
    OSErr err;
        /* set up locals */
    theAlias = NULL;
    fileCreated = false;
    rsrc = -1;
        /* set up our the alias' file information */
    err = FSpGetFInfo(targetFile, &fndrInfo);
    if (err != noErr) goto bail;
    if (fndrInfo.fdType == 'APPL')
        fndrInfo.fdType = kApplicationAliasType;
    fndrInfo.fdFlags = kIsAlias; /* implicitly clear the inited bit */
        /* create the new file */
    FSpCreateResFile(aliasDest, 'TEMP', 'TEMP', smSystemScript);
    if ((err = ResError()) != noErr) goto bail;
    fileCreated = true;
        /* set the file information or the new file */
    err = FSpSetFInfo(aliasDest, &fndrInfo);
    if (err != noErr) goto bail;
        /* create the alias record, relative to the new alias file */
    err = NewAlias(aliasDest, targetFile, &theAlias);
    if (err != noErr) goto bail;
        /* save the resource */
    rsrc = FSpOpenResFile(aliasDest, fsRdWrPerm);
    if (rsrc == -1) { err = ResError(); goto bail; }
    UseResFile(rsrc);
    AddResource((Handle) theAlias, rAliasType, 0, aliasDest->name);
    if ((err = ResError()) != noErr) goto bail;
    theAlias = NULL;
    CloseResFile(rsrc);
    rsrc = -1;
    if ((err = ResError()) != noErr) goto bail;
        /* done */
    return noErr;
bail:
    if (rsrc != -1) CloseResFile(rsrc);
    if (fileCreated) FSpDelete(aliasDest);
    if (theAlias != NULL) DisposeHandle((Handle) theAlias);
    return err;
}
// 10.4 savvy:
OSErr MakeRelativeAliasFile(FSSpec *targetFile, FSSpec *aliasDest) {
    FInfo fndrInfo;// only for compatibility
    AliasHandle theAlias;
    Boolean fileCreated;
    short rsrc;
    OSErr err;
        /* set up locals */
    theAlias = NULL;
    fileCreated = false;
    rsrc = -1;
        /* set up our the alias' file information */
//Deprecated:    err = FSpGetFInfo(targetFile, &fndrInfo);
	extern OSErr  FSGetCatalogInfo(const FSRef *ref, FSCatalogInfoBitmap whichInfo, FSCatalogInfo *catalogInfo, HFSUniStr255 *outName, FSSpec *fsSpec, FSRef *parentRef) AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER;

    if (err != noErr) goto bail;
    if (fndrInfo.fdType == 'APPL')
        fndrInfo.fdType = kApplicationAliasType;
    fndrInfo.fdFlags = kIsAlias; /* implicitly clear the inited bit */
        /* create the new file */
    FSpCreateResFile(aliasDest, 'TEMP', 'TEMP', smSystemScript);// not thread safe
    if ((err = ResError()) != noErr) goto bail;
    fileCreated = true;
        /* set the file information or the new file */
//Deprecated:    err = FSpSetFInfo(aliasDest, &fndrInfo);
	extern OSErr  FSSetCatalogInfo(const FSRef *ref, FSCatalogInfoBitmap whichInfo, const FSCatalogInfo *catalogInfo)   AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER;

    if (err != noErr) goto bail;
        /* create the alias record, relative to the new alias file */
//Deprecated:    err = NewAlias(aliasDest, targetFile, &theAlias);

	extern OSErr 
FSNewAlias(
  const FSRef *  fromFile,       /* can be NULL */
  const FSRef *  target,
  AliasHandle *  inAlias)                                     AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER;


    if (err != noErr) goto bail;
        /* save the resource */
    rsrc = FSpOpenResFile(aliasDest, fsRdWrPerm);
    if (rsrc == -1) { err = ResError(); goto bail; }
    UseResFile(rsrc);
    AddResource((Handle) theAlias, rAliasType, 0, aliasDest->name);
    if ((err = ResError()) != noErr) goto bail;
    theAlias = NULL;
    CloseResFile(rsrc);
    rsrc = -1;
    if ((err = ResError()) != noErr) goto bail;
        /* done */
    return noErr;
bail:
    if (rsrc != -1) CloseResFile(rsrc);
    if (fileCreated) //Deprecated:FSpDelete(aliasDest);
	extern OSErr  FSDeleteObject(const FSRef * ref)               AVAILABLE_MAC_OS_X_VERSION_10_0_AND_LATER;

    if (theAlias != NULL) DisposeHandle((Handle) theAlias);
    return err;
}

The basic summary is that the Finder alias is a resource file, with one 'alis' resource inside. The sample Apple provides makes a relative alias, but you can also create a non-relative (absolute) alias by passing NULL for the "fromFile" parameter of NewAlias?. There are two important bits of metadata that you must set on the file:

First, set the "kIsAlias" bit in the flags (FileInfo?.finderFlags or FInfo?.fdFlags). When you set it, you must also clear the "kHasBeenInited" bit, which tells the Finder that you've been poking around with the file, so that it can fix it up if needed.

Second, set the file type of the alias (FileInfo?.fileType or FInfo?.fdType). If you look in CarbonCore/Finder.h, you'll see a bunch of special alias file types. These are used by the Finder to provide special icons for certain kinds of aliases. You should make an attempt to set the type correctly, but the list is rather large so it might not be simple to do so for all possible alias targets. If you're just creating one particular type of alias it's easier. (The Apple sample code above checked for the application type, 'APPL', and set the file type to kApplicationAliasType / 'adrp'.)

http://www.cocoadev.com/index.pl?CreatingFinderTypeAliases

#endif
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  aliasDataWithContentsOfURL:error:
+ (NSData *)aliasDataWithContentsOfURL:(NSURL *)absoluteURL error:(NSError **)outErrorPtr;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 06/01/03
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;

//iTM2_END;
	return [absoluteURL isFileURL]?
		[DFM extendedFileAttributeWithResourceType:'alis' resourceID:0 atPath:[absoluteURL path] error:outErrorPtr]
		: nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  pathByResolvingDataAlias:relativeTo:error:
- (NSString*)pathByResolvingDataAliasRelativeTo:(NSString *)base error:(NSError **)outErrorPtr;
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
	if(outErrorPtr)
		*outErrorPtr = [NSError errorWithDomain:__iTM2_PRETTY_FUNCTION__ code:theErr userInfo:nil];
//iTM2_END;
	return nil;
}
@end

@implementation NSString(iTM2FileManagerKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  dataAliasRelativeTo:error:
- (NSData*)dataAliasRelativeTo:(NSString *)base error:(NSError **)outErrorPtr;
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
			if(outErrorPtr)
				*outErrorPtr = [NSError errorWithDomain:__iTM2_PRETTY_FUNCTION__ code:1 userInfo:nil];
			return nil;
		}
		fromFile = &baseRef;
	}
	FSRef targetParentRef;
	NSString * dirName = [self stringByDeletingLastPathComponent];
	if(!CFURLGetFSRef ((CFURLRef)[NSURL fileURLWithPath:dirName], &targetParentRef))
	{
		if(outErrorPtr)
			*outErrorPtr = [NSError errorWithDomain:__iTM2_PRETTY_FUNCTION__ code:2 userInfo:nil];
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
	if(outErrorPtr)
		*outErrorPtr = [NSError errorWithDomain:__iTM2_PRETTY_FUNCTION__ code:theErr userInfo:nil];
theEnd:
//iTM2_END;
	free(targetName);
	return result;
}
@end
