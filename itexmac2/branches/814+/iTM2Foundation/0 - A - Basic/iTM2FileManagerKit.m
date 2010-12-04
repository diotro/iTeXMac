/*
//
//  @version Subversion: $Id: iTM2FileManagerKit.m 799 2009-10-13 16:46:39Z jlaurens $ 
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

#import "iTM2Runtime.h"
#import "iTM2Invocation.h"
#import "iTM2PathUtilities.h"
#import "iTM2FileManagerKit.h"
#import <sys/stat.h>

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  NSFileManager(iTeXMac2)
/*"Description Forthcoming."*/
@implementation NSFileManager(iTeXMac2)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  makeFileWritableAtPath4iTM3:recursive:
- (void)makeFileWritableAtPath4iTM3:(NSString *)fileName recursive:(BOOL)recursive;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 06/01/03
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	BOOL isDirectory = NO;
	if ([self fileExistsAtPath:fileName isDirectory:&isDirectory])// traverse the link:bug in the documentation
	{
		NSMutableDictionary * fileAttributes = [[[self attributesOfItemAtPath:fileName error:NULL] mutableCopy] autorelease];
		NSUInteger oldPosixPermissions = [fileAttributes filePosixPermissions];
		struct stat myStat;
		if (noErr == stat([fileName fileSystemRepresentation], &myStat))
		{
			oldPosixPermissions = myStat.st_mode;
		}
		NSUInteger newPosixPermissions = oldPosixPermissions | S_IWUSR;
		if (oldPosixPermissions != newPosixPermissions)
		{
			if (chmod([fileName fileSystemRepresentation],newPosixPermissions) != noErr)
			{
				[fileAttributes setObject:[NSNumber numberWithUnsignedInteger:newPosixPermissions] forKey:NSFilePosixPermissions];
				[self setAttributes:fileAttributes ofItemAtPath:fileName error:NULL];
			}
		}
		if (recursive && [[fileAttributes objectForKey:NSFileType] isEqual:NSFileTypeDirectory])// beware, do not use isDirectory (Why? JL:2009/10/12)
		{
			for(NSString * component in [self contentsOfDirectoryAtPath:fileName error:NULL])
				[self makeFileWritableAtPath4iTM3:[fileName stringByAppendingPathComponent:component] recursive:recursive];
		}
	}
//END4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setExtensionHidden4iTM3:atURL:
- (BOOL)setExtensionHidden4iTM3:(BOOL)yorn atURL:(NSURL *)url;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 06/01/03
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
	return [url setResourceValue:[NSNumber numberWithBool:yorn] forKey:NSURLHasHiddenExtensionKey error:NULL];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  prettyNameAtPath4iTM3:
- (NSString *)prettyNameAtPath4iTM3:(NSString *)path;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 06/01/03
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
	return [[self attributesOfItemAtPath:path error:NULL] fileExtensionHidden]?
			path.lastPathComponent.stringByDeletingPathExtension:path.lastPathComponent;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  fileExistsAtPath4iTM3:isAlias:error:
- (BOOL)fileExistsAtPath4iTM3:(NSString *)path isAlias:(BOOL *)isAlias error:(NSError**)RORef;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 06/01/03
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if ([self fileExistsAtPath:path])//traverse links
	{
		FSRef ref = {ZER0};
		OSStatus status = FSPathMakeRef((UInt8 *)[path UTF8String], &ref, NULL);
		if (status)
		{
			if (RORef)
			{
				*RORef = [NSError errorWithDomain:__iTM2_PRETTY_FUNCTION__ code:status
					userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"Could not create an FSRef for %@", path] forKey:NSLocalizedDescriptionKey]];
			}
//END4iTM3;
			return YES;
		}
		OSErr err = FSIsAliasFile(&ref,(Boolean*)isAlias, NULL);
		if (err)
		{
			[NSError errorWithDomain:__iTM2_PRETTY_FUNCTION__ code:err
				userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"Could not check an alias at %@", path] forKey:NSLocalizedDescriptionKey]];
		}
//END4iTM3;
		return YES;
	}
//END4iTM3;
	return NO;
}
static NSMutableArray * iTM2FileManagerKitDirectoryStack = nil;
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  pushDirectory4iTM3:
- (BOOL)pushDirectory4iTM3:(NSString *)path;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 06/01/03
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (!iTM2FileManagerKitDirectoryStack)
	{
		iTM2FileManagerKitDirectoryStack = [[NSMutableArray array] retain];
	}
	NSString * currentDirectoryPath = [DFM currentDirectoryPath];
	if ([self changeCurrentDirectoryPath:path])
	{
		[iTM2FileManagerKitDirectoryStack addObject:currentDirectoryPath];
//END4iTM3;
		return YES;
	}
//END4iTM3;
	return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  popDirectory4iTM3
- (BOOL)popDirectory4iTM3;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 06/01/03
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSString * path = [iTM2FileManagerKitDirectoryStack lastObject];
	if (path && [self changeCurrentDirectoryPath:path])
	{
		[iTM2FileManagerKitDirectoryStack removeLastObject];
//END4iTM3;
		return YES;
	}
//END4iTM3;
	return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  fileOrLinkExistsAtPath4iTM3
- (BOOL)fileOrLinkExistsAtPath4iTM3:(NSString *)path;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 06/01/03
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
	return [self fileExistsAtPath:path] || [self linkExistsAtPath4iTM3:path];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  linkExistsAtPath4iTM3:
- (BOOL)linkExistsAtPath4iTM3:(NSString *)path;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 06/01/03
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
	return [[[self attributesOfItemAtPath:path error:NULL] fileType] isEqual:NSFileTypeSymbolicLink];
}
- (BOOL)isVisibleFileAtPath4iTM3:(NSString *)path;
{
//LOG4iTM3(@"path: %@", path);
	path = path.lastPathComponent;
	return ![path hasPrefix:@"."];
}
- (BOOL)trashedIsPrivateFileAtPath4iTM3:(NSString *)path;// never used
{
	return [[path pathComponents] containsObject:@".Trash"];
}
- (BOOL)isPrivateFileAtPath4iTM3:(NSString *)path;
{
//LOG4iTM3(@"path: %@", path);
    NSInvocation * I;
	[[NSInvocation getInvocation4iTM3:&I withTarget:self retainArguments:NO] isPrivateFileAtPath4iTM3:path];
    BOOL result = NO;
	// BEWARE, the didReadFromURL:ofType:methods are not called here because they do not have the appropriate signature!
	NSPointerArray * PA = [iTM2Runtime instanceSelectorsOfClass:self.class withSuffix:@"IsPrivateFileAtPath4iTM3:" signature:[I methodSignature] inherited:YES];
	NSUInteger i = PA.count;
	while (i--) {
        [I setSelector:(SEL)[PA pointerAtIndex:i]];
        [I invoke];
        BOOL R = NO;
        [I getReturnValue:&R];
        result = result || R;
    }
	return result;
}

#define ENCODING CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF16BE)
NSString * const iTM2SoftLinkExtension = @"soft_link";
- (void)convertSymbolicLinksToSoftLinksAtPath4iTM3:(NSString *)path;
{
	for(NSString * component in [self contentsOfDirectoryAtPath:path error:NULL])
	{
		component = [path stringByAppendingPathComponent:component];
		NSString * content = [self destinationOfSymbolicLinkAtPath:component error:NULL];
		if (content.length)
		{
			component = [component stringByAppendingPathExtension:iTM2SoftLinkExtension];
			[content writeToFile:component atomically:NO encoding:ENCODING error:nil];
		}
	}
}
- (NSString *)pathContentOfSoftLinkAtPath4iTM3:(NSString *)path;
{
	[self convertSymbolicLinksToSoftLinksAtPath4iTM3:path.stringByDeletingLastPathComponent];
	path = [path stringByAppendingPathExtension:iTM2SoftLinkExtension];
	return [NSString stringWithContentsOfFile:path encoding:ENCODING error:nil];
}
- (BOOL)createSoftLinkAtPath4iTM3:(NSString *)path pathContent:(NSString *)otherpath;
{
	[self convertSymbolicLinksToSoftLinksAtPath4iTM3:path.stringByDeletingLastPathComponent];
	path = [path stringByAppendingPathExtension:iTM2SoftLinkExtension];
	return [otherpath writeToFile:path atomically:NO encoding:ENCODING error:nil];
}
#undef ENCODING
- (NSDictionary *)attributesOfItemOrDestinationOfSymbolicLinkAtURL4iTM3:(NSURL *)url error:(NSError **)RORef;
{
	// is it a symbolic link?
    if (url.isFileURL) {
        NSString * destination = [self destinationOfSymbolicLinkAtPath:url.path error:nil];// ignore the ROR
        if (destination) {
            return [self attributesOfItemAtPath:destination error:RORef];
        }
        return [self attributesOfItemAtPath:url.path error:RORef];
    }
    return nil;
}
@end

@interface NSFileManager(_iTM2ExtendedAttributes)
- (NSDictionary *)extendedFileAttributesWithResourceType4iTM3:(ResType)resourceType atPath:(NSString *)path error:(NSError **)RORef;
- (NSData *)extendedFileAttribute4iTM3:(NSString *)attributeName withResourceType:(ResType)resourceType atPath:(NSString *)path error:(NSError **)RORef;
- (BOOL)addExtendedFileAttribute4iTM3:(NSString *)attributeName value:(NSData *)D withResourceType:(ResType)resourceType atPath:(NSString *)path error:(NSError **)RORef;
- (BOOL)removeExtendedFileAttribute4iTM3:(NSString *)attributeName withResourceType:(ResType)resourceType atPath:(NSString *)path error:(NSError **)RORef;
- (BOOL)changeExtendedFileAttributes4iTM3:(NSDictionary *)attributes withResourceType:(ResType)resourceType atPath:(NSString *)path error:(NSError **)RORef;
- (NSData *)extendedFileAttributeWithResourceType4iTM3:(ResType)resourceType resourceID:(ResID)resourceID atPath:(NSString *)path error:(NSError **)RORef;
- (BOOL)addExtendedFileAttribute4iTM3:(NSString*)attributeName value:(NSData *)D withResourceType:(ResType)resourceType resourceID:(ResID)resourceID atPath:(NSString *)path error:(NSError **)RORef;
@end

@implementation NSFileManager(iTM2ExtendedAttributes)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  extendedFileAttributesInDomain4iTM3:atPath:error:
- (NSDictionary *)extendedFileAttributesInSpace4iTM3:(id)space atPath:(NSString *)path error:(NSError **)RORef;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 06/01/03
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if ([space isKindOfClass:[NSNumber class]])
	{
		return [self extendedFileAttributesWithResourceType4iTM3:[space unsignedIntegerValue] atPath:path error:RORef];
	}
//END4iTM3;
	return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  extendedFileAttributesWithResourceType4iTM3:atPath:error:
- (NSDictionary *)extendedFileAttributesWithResourceType4iTM3:(ResType)resourceType atPath:(NSString *)path error:(NSError **)RORef;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 06/01/03
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	BOOL isDirectory;
	if (![DFM fileExistsAtPath:path isDirectory:&isDirectory] || isDirectory)
		return nil;
	// now we are ready to read the resources
	NSMutableDictionary * MD = [NSMutableDictionary dictionary];
	FSRef fileSystemReference;
	if (!CFURLGetFSRef((CFURLRef)[NSURL fileURLWithPath:path], &fileSystemReference))
	{
		return nil;
	}
	ResFileRefNum curResFile = CurResFile();
	OSErr resError;
	BOOL wasCurResFile = (noErr == ResError());
	ResFileRefNum fileSystemReferenceNumber = FSOpenResFile(&fileSystemReference, fsRdPerm);
	if (resError = ResError())
	{
		if (iTM2DebugEnabled)
		{
			LOG4iTM3(@"1 - Could not FSOpenResFile, at %@ error %i (fileSystemReferenceNumber: %i)",path,resError,fileSystemReferenceNumber);
		}
		OUTERROR4iTM3(kiTM2ExtendedAttributesResourceManagerError,([NSString stringWithFormat:@"1 - Could not FSOpenResFile, at %@ error %i (fileSystemReferenceNumber: %i)",path,resError,fileSystemReferenceNumber]),nil);
		return nil;
	}
	UseResFile(fileSystemReferenceNumber);// maybe this is useless, undocumented
	if (resError = ResError())
	{
		if (iTM2DebugEnabled)
		{
			LOG4iTM3(@"2 - Could not UseResFile, at %@ error %i (fileSystemReferenceNumber: %i)",path,resError,fileSystemReferenceNumber);
		}
		OUTERROR4iTM3(kiTM2ExtendedAttributesResourceManagerError,([NSString stringWithFormat:@"2 - Could not UseResFile, at %@ error %i (fileSystemReferenceNumber: %i)",path,resError,fileSystemReferenceNumber]),nil);
		CloseResFile(fileSystemReferenceNumber);
		if (resError = ResError())
		{
			if (iTM2DebugEnabled)
			{
				LOG4iTM3(@"2-Last - Could not CloseResFile, error %i", resError);
			}
			OUTERROR4iTM3(kiTM2ExtendedAttributesResourceManagerError,([NSString stringWithFormat:@"2-Last - Could not CloseResFile, error %i", resError]),nil);
		}
		return nil;
	}
	ResourceCount resourceIndex = Count1Resources(resourceType);
	while(resourceIndex)
	{
		Handle H = Get1IndResource(resourceType, resourceIndex);
		if ((resError = ResError())|| !H)
		{
			if (iTM2DebugEnabled)
			{
				LOG4iTM3(@"3 - Could not Get1Resource, error %i (resourceIndex is %i)", resError, resourceIndex);
			}
			OUTERROR4iTM3(kiTM2ExtendedAttributesResourceManagerError,([NSString stringWithFormat:@"3 - Could not Get1Resource, error %i (resourceIndex is %i)", resError, resourceIndex]),nil);
			--resourceIndex;
			continue;
		}
		if (iTM2DebugEnabled)
		{
			LOG4iTM3(@"4 - Could use Get1Resource, error %i (resourceIndex is %i)", resError, resourceIndex);
		}
		Str255 resourceName;
		GetResInfo(H, NULL, NULL, resourceName);
		if (resError = ResError())
		{
			if (iTM2DebugEnabled)
			{
				LOG4iTM3(@"5 - Could not GetResInfo, error %i (resourceIndex is %i)", resError, resourceIndex);
			}
			OUTERROR4iTM3(kiTM2ExtendedAttributesResourceManagerError,([NSString stringWithFormat:@"5 - Could not GetResInfo, error %i (resourceIndex is %i)", resError, resourceIndex]),nil);
			--resourceIndex;
			continue;
		}
		if (iTM2DebugEnabled)
		{
			LOG4iTM3(@"6 - Could use GetResInfo, error %i (resourceIndex is %i)", resError, resourceIndex);
		}
		HLock(H);
		NSData * D = [NSData dataWithBytes:*H length:GetHandleSize(H)];
		HUnlock(H);
		ReleaseResource(H);
		if (resError = ResError())
		{
			if (iTM2DebugEnabled)
			{
				LOG4iTM3(@"7 - Could not ReleaseResource, error %i (resourceIndex is %i)", resError, resourceIndex);
			}
			OUTERROR4iTM3(kiTM2ExtendedAttributesResourceManagerError,([NSString stringWithFormat:@"7 - Could not ReleaseResource, error %i (resourceIndex is %i)", resError, resourceIndex]),nil);
		}
		Str255 dst;
		memcpy(dst, resourceName+1, resourceName[ZER0]);
		dst[resourceName[ZER0]]='\0';
		NSString * key = [NSString stringWithUTF8String:(void *)dst];
		if (key.length)
			[MD setObject:D forKey:key];
		--resourceIndex;
	}
	CloseResFile(fileSystemReferenceNumber);
	if (resError = ResError())
	{
		if (iTM2DebugEnabled)
		{
			LOG4iTM3(@"8 - Could not CloseResFile, error %i", resError);
		}
		OUTERROR4iTM3(kiTM2ExtendedAttributesResourceManagerError,([NSString stringWithFormat:@"8 - Could not CloseResFile, error %i", resError]),nil);
	}
	if (wasCurResFile)
	{
		UseResFile(curResFile);
		if (resError = ResError())
		{
			if (iTM2DebugEnabled)
			{
				LOG4iTM3(@"9 - Could not UseResFile, error %i", resError);
			}
		}
		OUTERROR4iTM3(kiTM2ExtendedAttributesResourceManagerError,([NSString stringWithFormat:@"9 - Could not UseResFile, error %i", resError]),nil);
	}
//END4iTM3;
	return MD;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  extendedFileAttribute4iTM3:inSpace:atPath:error:
- (NSData *)extendedFileAttribute4iTM3:(NSString *)attributeName inSpace:(id)space atPath:(NSString *)path error:(NSError **)RORef;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 06/01/03
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
	if ([space isKindOfClass:[NSNumber class]])
		return [self extendedFileAttribute4iTM3:attributeName withResourceType:[space unsignedIntegerValue] atPath:path error:RORef];
	return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  extendedFileAttribute4iTM3:withResourceType:atPath:error:
- (NSData *)extendedFileAttribute4iTM3:(NSString *)attributeName withResourceType:(ResType)resourceType atPath:(NSString *)path error:(NSError **)RORef;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 06/01/03
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSData * D = nil;
	if (![DFM fileExistsAtPath:path])
	{
		OUTERROR4iTM3(kiTM2ExtendedAttributesNoFileAtPathError,([NSString stringWithFormat:@"No file at %@", path]),nil);
		return D;
	}
	const char * src = [attributeName UTF8String];
	if (strlen(src)>= 256)
	{
		if (RORef)
			* RORef = [NSError errorWithDomain:__iTM2_PRETTY_FUNCTION__
				code: kiTM2ExtendedAttributesBadNameError userInfo: nil];
		return D;
	}
	path = [path stringByResolvingSymlinksAndFinderAliasesInPath4iTM3];
	FSRef fileSystemReference;
	if (!CFURLGetFSRef((CFURLRef)[NSURL fileURLWithPath:path], &fileSystemReference))
	{
		return nil;
	}
	ResFileRefNum curResFile = CurResFile();
	OSErr resError;
	BOOL wasCurResFile = (noErr == ResError());
	ResFileRefNum fileSystemReferenceNumber = FSOpenResFile(&fileSystemReference, fsRdPerm);
	if (resError = ResError())
	{
		if (iTM2DebugEnabled)
		{
			LOG4iTM3(@"1 - Could not FSOpenResFile, at %@ error %i (fileSystemReferenceNumber: %i)",path,resError,fileSystemReferenceNumber);
		}
		if (RORef)
			* RORef = [NSError errorWithDomain:__iTM2_PRETTY_FUNCTION__
				code: kiTM2ExtendedAttributesResourceManagerError
					userInfo: [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:resError] forKey:@"ResError"]];
		return nil;
	}
	UseResFile(fileSystemReferenceNumber);
	if (resError = ResError())
	{
		if (iTM2DebugEnabled)
		{
			LOG4iTM3(@"2 - Could not UseResFile, at %@ error %i (fileSystemReferenceNumber: %i)",path,resError,fileSystemReferenceNumber);
		}
		if (RORef)
			* RORef = [NSError errorWithDomain:__iTM2_PRETTY_FUNCTION__
				code: kiTM2ExtendedAttributesResourceManagerError
					userInfo: [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:resError] forKey:@"ResError"]];
		CloseResFile(fileSystemReferenceNumber);
		return nil;
	}
	Str255 resourceName;
	memcpy(resourceName+1, src, strlen(src));
	resourceName[ZER0]=strlen(src);
	Handle H = Get1NamedResource(resourceType, resourceName);
	if ((resError = ResError())|| !H)
	{
		if (iTM2DebugEnabled)
		{
			LOG4iTM3(@"3 - Could not Get1NamedResource, error %i (attributeName is %@)", resError, attributeName);
		}
		if (RORef)
			* RORef = [NSError errorWithDomain:__iTM2_PRETTY_FUNCTION__
				code: kiTM2ExtendedAttributesResourceManagerError
					userInfo: [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:resError] forKey:@"ResError"]];
		return nil;
	}
	if (iTM2DebugEnabled)
	{
		LOG4iTM3(@"Could use Get1Resource, error %i (attributeName is %@)", resError, attributeName);
	}
	HLock(H);
	D = [NSData dataWithBytes:*H length:GetHandleSize(H)];
	HUnlock(H);
	ReleaseResource(H);
	if (resError = ResError())
	{
		if (iTM2DebugEnabled)
		{
			LOG4iTM3(@"4 - Could not ReleaseResource, error %i (attributeName is %@)", resError, attributeName);
		}
		if (RORef)
			* RORef = [NSError errorWithDomain:__iTM2_PRETTY_FUNCTION__
				code: kiTM2ExtendedAttributesResourceManagerError
					userInfo: [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:resError] forKey:@"ResError"]];
	}
	CloseResFile(fileSystemReferenceNumber);
	if (resError = ResError())
	{
		if (iTM2DebugEnabled)
		{
			LOG4iTM3(@"5 - Could not CloseResFile, error %i", resError);
		}
		if (RORef)
			* RORef = [NSError errorWithDomain:__iTM2_PRETTY_FUNCTION__
				code: kiTM2ExtendedAttributesResourceManagerError
					userInfo: [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:resError] forKey:@"ResError"]];
	}
	if (wasCurResFile)
	{
		UseResFile(curResFile);
		if (resError = ResError())
		{
			if (iTM2DebugEnabled)
			{
				LOG4iTM3(@"6 - Could not UseResFile, error %i", resError);
			}
			if (RORef)
				* RORef = [NSError errorWithDomain:__iTM2_PRETTY_FUNCTION__
					code: kiTM2ExtendedAttributesResourceManagerError
						userInfo: [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:resError] forKey:@"ResError"]];
		}
	}
//END4iTM3;
	return D;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  addExtendedFileAttribute4iTM3:value:inSpace:atPath:error:
- (BOOL)addExtendedFileAttribute4iTM3:(NSString *)attributeName value:(NSData *)D inSpace:(id)space atPath:(NSString *)path error:(NSError **)RORef;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 06/01/03
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if ([space isKindOfClass:[NSNumber class]])
		return [self addExtendedFileAttribute4iTM3:attributeName value:D withResourceType:[space unsignedIntegerValue] atPath:path error:RORef];
//END4iTM3;
	return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  addExtendedFileAttribute4iTM3:value:withResourceType:atPath:error:
- (BOOL)addExtendedFileAttribute4iTM3:(NSString *)attributeName value:(NSData *)D withResourceType:(ResType)resourceType atPath:(NSString *)path error:(NSError **)RORef;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 06/01/03
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	path = [path stringByResolvingSymlinksAndFinderAliasesInPath4iTM3];
	if (![DFM fileExistsAtPath:path])
	{
		if (RORef)
			* RORef = [NSError errorWithDomain:__iTM2_PRETTY_FUNCTION__
												code: kiTM2ExtendedAttributesNoFileAtPathError
											userInfo: [NSDictionary dictionaryWithObject:path forKey:@"Path"]];		
		return NO;
	}
	BOOL result = YES;
	const char * src = [attributeName UTF8String];
	if (strlen(src)>= 256)
		return NO;
	ResFileRefNum curResFile = CurResFile();
	BOOL wasCurResFile = (noErr == ResError());
	FSRef fsRef;
	NSURL * myURL = [NSURL fileURLWithPath:path];
	if (!CFURLGetFSRef((CFURLRef)myURL, &fsRef))
	{
		if (iTM2DebugEnabled)
		{
			LOG4iTM3(@"CFURLGetFSRef error.");
		}
		return NO;
	}
	HFSUniStr255 resourceForkName;
	OSErr resError = FSGetResourceForkName (&resourceForkName);
	if (resError != noErr) {
		NSLog(@"FSGetResourceForkName error:%i.",resError);
		return -1;
	}
	ResFileRefNum fileSystemReferenceNumber;
	resError = FSOpenResourceFile (&fsRef,resourceForkName.length,resourceForkName.unicode,fsRdWrPerm,&fileSystemReferenceNumber);
	if (resError != noErr) {
		if (iTM2DebugEnabled)
		{
			LOG4iTM3(@"FSOpenResourceFile error.");
		}
		return NO;
	}
	UseResFile(fileSystemReferenceNumber);
	if (resError = ResError())
	{
		if (iTM2DebugEnabled)
		{
			LOG4iTM3(@"2 - Could not UseResFile, at %@, error %i, fileSystemReferenceNumber: %i",path,resError,fileSystemReferenceNumber);
		}
		result = NO;
terminate:
		CloseResFile(fileSystemReferenceNumber);
		if (resError = ResError())
		{
			LOG4iTM3(@"10 - Could not CloseResFile, error %i", resError);
		}
		if (wasCurResFile)
		{
			UseResFile(curResFile);
			if (resError = ResError())
			{
				if (iTM2DebugEnabled)
				{
					LOG4iTM3(@"11 - Could not UseResFile, error %i", resError);
				}
			}
		}
		//END4iTM3;
		return result;// even if the resources could not be saved...
	}
	Str255 resourceName;
	memcpy(resourceName+1, src, strlen(src));
	resourceName[ZER0]=strlen(src);
	Handle H = Get1NamedResource(resourceType, resourceName);
	if (resError = ResError())
	{
		if (iTM2DebugEnabled)
		{
			LOG4iTM3(@"3 - Could not Get1NamedResource, error %i (attributeName is %@)", resError, attributeName);
		}
	}
	else if (iTM2DebugEnabled)
	{
		LOG4iTM3(@"4 - Could use Get1NamedResource, error %i (attributeName is %@)", resError, attributeName);
	}
	ResID resourceID;
	if (H)
	{
		GetResInfo(H, &resourceID, nil, resourceName);
		if (resError = ResError())
		{
			if (iTM2DebugEnabled)
			{
				LOG4iTM3(@"5 - Could not GetResInfo, error %i (attributeName is %@)", resError, attributeName);
			}
		}
		else if (iTM2DebugEnabled)
		{
			LOG4iTM3(@"6 - Could use GetResInfo, error %i (attributeName is %@)", resError, attributeName);
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
	if (resError = PtrToHand([D bytes], &H, D.length))
	{
		if (iTM2DebugEnabled)
		{
			LOG4iTM3(@"7 - WARNING: Could not convert a Ptr into a handle, error %i", resError);
		}
	}
	else
	{
		HLock(H);
		AddResource(H, resourceType, resourceID, resourceName);
		HUnlock(H);
		if (resError = ResError())
		{
			if (iTM2DebugEnabled)
			{
				LOG4iTM3(@"8 - Could not AddResource, error %i", resError);
			}
			DisposeHandle(H);// hum the handle is considered the property of the resource manager now?
		}
		else if (iTM2DebugEnabled>99)
		{
			LOG4iTM3(@"9 - Resource added: %u", resourceID);
		}
		// DisposeHandle(H);// hum the handle is considered the property of the resource manager now?
	}
	goto terminate;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  addExtendedFileAttribute4iTM3:inSpace:atPath:error:
- (BOOL)removeExtendedFileAttribute4iTM3:(NSString *)attributeName inSpace:(id)space atPath:(NSString *)path error:(NSError **)RORef;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 06/01/03
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if ([self isKindOfClass:[NSNumber class]])
		return [self removeExtendedFileAttribute4iTM3:attributeName withResourceType:[space unsignedIntegerValue] atPath:path error:RORef];
//END4iTM3;
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  removeExtendedFileAttribute4iTM3:withResourceType:atPath:error:
- (BOOL)removeExtendedFileAttribute4iTM3:(NSString *)attributeName withResourceType:(ResType)resourceType atPath:(NSString *)path error:(NSError **)RORef;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 06/01/03
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (![DFM fileExistsAtPath:path])
	{
		if (RORef)
			* RORef = [NSError errorWithDomain:__iTM2_PRETTY_FUNCTION__
				code: kiTM2ExtendedAttributesNoFileAtPathError userInfo: nil];
		return NO;
	}
	path = [path stringByResolvingSymlinksAndFinderAliasesInPath4iTM3];
	BOOL result = YES;
	const char * src = [attributeName UTF8String];
	if (strlen(src)>= 256)
	{
		if (RORef)
			* RORef = [NSError errorWithDomain:__iTM2_PRETTY_FUNCTION__
				code: kiTM2ExtendedAttributesBadNameError userInfo: nil];
		return NO;
	}
	FSRef fileSystemReference;
	if (!CFURLGetFSRef((CFURLRef)[NSURL fileURLWithPath:path], &fileSystemReference))
	{
		if (RORef)
			* RORef = [NSError errorWithDomain:__iTM2_PRETTY_FUNCTION__
												code: kiTM2ExtendedAttributesNoFileAtPathError userInfo: nil];
		return NO;
	}
	short curResFile = CurResFile();
	BOOL wasCurResFile = (noErr == ResError());
	HFSUniStr255 resourceForkName;
	OSErr resError = FSGetResourceForkName (&resourceForkName);
	if (resError != noErr) {
		NSLog(@"FSGetResourceForkName error:%i.",resError);
		return -1;
	}
	ResFileRefNum fileSystemReferenceNumber;
	if (resError = FSOpenResourceFile (&fileSystemReference,resourceForkName.length,resourceForkName.unicode,fsRdWrPerm,&fileSystemReferenceNumber)) {
		if (iTM2DebugEnabled)
		{
			LOG4iTM3(@"1 - Could not FSOpenResFile, at %@, error %i, fileSystemReferenceNumber: %i",path,resError,fileSystemReferenceNumber);
		}
		CloseResFile(fileSystemReferenceNumber);
		if (RORef)
			* RORef = [NSError errorWithDomain:__iTM2_PRETTY_FUNCTION__
				code: kiTM2ExtendedAttributesResourceManagerError
					userInfo: [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:resError] forKey:@"ResError"]];
		return NO;
	}
	UseResFile(fileSystemReferenceNumber);
	if (resError = ResError())
	{
		if (iTM2DebugEnabled)
		{
			LOG4iTM3(@"2 - Could not UseResFile, at %@, error %i, fileSystemReferenceNumber: %i",path,resError,fileSystemReferenceNumber);
		}
		CloseResFile(fileSystemReferenceNumber);
		if (RORef)
			* RORef = [NSError errorWithDomain:__iTM2_PRETTY_FUNCTION__
				code: kiTM2ExtendedAttributesResourceManagerError
					userInfo: [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:resError] forKey:@"ResError"]];
		return NO;
	}
	Str255 resourceName;
	memcpy(resourceName+1, src, strlen(src));
	resourceName[ZER0]=strlen(src);
	Handle H = Get1NamedResource(resourceType, resourceName);
	if (resError = ResError())
	{
		if (iTM2DebugEnabled)
		{
			LOG4iTM3(@"Could not Get1NamedResource, error %i (attributeName is %@)", resError, attributeName);
		}
		if (RORef)
			* RORef = [NSError errorWithDomain:__iTM2_PRETTY_FUNCTION__
				code: kiTM2ExtendedAttributesResourceManagerError
					userInfo: [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:resError] forKey:@"ResError"]];
	}
	else if (iTM2DebugEnabled)
	{
		LOG4iTM3(@"Could use Get1NamedResource, error %i (attributeName is %@)", resError, attributeName);
	}
	if (H)
	{
		RemoveResource(H);
		if (resError = ResError())
		{
			if (iTM2DebugEnabled)
			{
				LOG4iTM3(@"Could not GetResInfo, error %i (attributeName is %@)", resError, attributeName);
			}
			if (RORef)
				* RORef = [NSError errorWithDomain:__iTM2_PRETTY_FUNCTION__
					code: kiTM2ExtendedAttributesResourceManagerError
						userInfo: [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:resError] forKey:@"ResError"]];
		}
		else if (iTM2DebugEnabled)
		{
			if (iTM2DebugEnabled)
			{
				LOG4iTM3(@"Could use GetResInfo, error %i (attributeName is %@)", resError, attributeName);
			}
			if (RORef)
				* RORef = [NSError errorWithDomain:__iTM2_PRETTY_FUNCTION__
					code: kiTM2ExtendedAttributesResourceManagerError
						userInfo: [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:resError] forKey:@"ResError"]];
		}
		DisposeHandle(H);
		H = nil;
	}
	CloseResFile(fileSystemReferenceNumber);
	if (resError = ResError())
	{
		if (iTM2DebugEnabled)
		{
			LOG4iTM3(@"Could not CloseResFile, error %i", resError);
		}
		if (RORef)
			* RORef = [NSError errorWithDomain:__iTM2_PRETTY_FUNCTION__
				code: kiTM2ExtendedAttributesResourceManagerError
					userInfo: [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:resError] forKey:@"ResError"]];
	}
	if (wasCurResFile)
	{
		UseResFile(curResFile);
		if (resError = ResError())
		{
			if (iTM2DebugEnabled)
			{
				LOG4iTM3(@"Could not UseResFile, error %i", resError);
			}
			if (RORef)
				* RORef = [NSError errorWithDomain:__iTM2_PRETTY_FUNCTION__
					code: kiTM2ExtendedAttributesResourceManagerError
						userInfo: [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:resError] forKey:@"ResError"]];
		}
	}
//END4iTM3;
    return result;// even if the resources could not be saved...
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  changeExtendedFileAttributes4iTM3:inSpace:atPath:error:
- (BOOL)changeExtendedFileAttributes4iTM3:(NSDictionary *)attributes inSpace:(id)space atPath:(NSString *)path error:(NSError **)RORef;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 06/01/03
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if ([space isKindOfClass:[NSNumber class]])
		return [self changeExtendedFileAttributes4iTM3:attributes withResourceType:[space unsignedIntegerValue] atPath:path error:RORef];
//END4iTM3;
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  changeExtendedFileAttributes4iTM3:withResourceType:atPath:error:
- (BOOL)changeExtendedFileAttributes4iTM3:(NSDictionary *)attributes withResourceType:(ResType)resourceType atPath:(NSString *)path error:(NSError **)RORef;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 06/01/03
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	BOOL isDirectory = NO;
	if (![DFM fileExistsAtPath:path isDirectory:&isDirectory] || isDirectory)
	{
		return NO;
	}
	path = [path stringByResolvingSymlinksAndFinderAliasesInPath4iTM3];
	BOOL result = YES;
	ResFileRefNum curResFile = CurResFile();
	BOOL wasCurResFile = (noErr == ResError());
	FSRef fsRef;
	NSURL * myURL = [NSURL fileURLWithPath:path];
	if (!CFURLGetFSRef((CFURLRef)myURL, &fsRef))
	{
		if (iTM2DebugEnabled)
		{
			LOG4iTM3(@"CFURLGetFSRef error.");
		}
		return NO;
	}
	HFSUniStr255 resourceForkName;
	OSErr resError = FSGetResourceForkName (&resourceForkName);
	if (resError != noErr) {
		NSLog(@"FSGetResourceForkName error:%i.",resError);
		return -1;
	}
	resError = FSCreateResourceFork(&fsRef,resourceForkName.length,resourceForkName.unicode,0);
	if (resError == errFSForkExists) {
		if (iTM2DebugEnabled)
		{
			LOG4iTM3(@"FSCreateResourceFork error.%i==errFSForkExists(%i)",resError,errFSForkExists);
		}
	} else if (resError != noErr) {
		if (iTM2DebugEnabled)
		{
			LOG4iTM3(@"FSCreateResourceFork error.%i",resError);
		}
		return NO;
	}
	ResFileRefNum fileSystemReferenceNumber;
	if (resError = FSOpenResourceFile (&fsRef,resourceForkName.length,resourceForkName.unicode,fsRdWrPerm,&fileSystemReferenceNumber))
	{
		if (iTM2DebugEnabled)
		{
			LOG4iTM3(@"1 - Could not FSOpenResFile, at %@, error %i, fileSystemReferenceNumber: %i",path,resError,fileSystemReferenceNumber);
		}
		CloseResFile(fileSystemReferenceNumber);
		OUTERROR4iTM3(kiTM2ExtendedAttributesResourceManagerError,([NSString stringWithFormat:@"1 - Could not FSOpenResFile, at %@, error %i, fileSystemReferenceNumber: %i",path,resError,fileSystemReferenceNumber]),nil);
		return NO;
	}
	UseResFile(fileSystemReferenceNumber);
	if (resError = ResError())
	{
		if (iTM2DebugEnabled)
		{
			LOG4iTM3(@"2 - Could not UseResFile, at %@, error %i, fileSystemReferenceNumber: %i",path,resError,fileSystemReferenceNumber);
		}
		OUTERROR4iTM3(kiTM2ExtendedAttributesResourceManagerError,([NSString stringWithFormat:@"2 - Could not UseResFile, at %@, error %i, fileSystemReferenceNumber: %i",path,resError,fileSystemReferenceNumber]),nil);
		CloseResFile(fileSystemReferenceNumber);
		return NO;
	}
	// we are retrieving the actual resources
	// we will compare the resourceName with the keys of the attributes dictionary
	// if there is a match, the resource is modified, if not it is removed.
	// This means that only one app can write some resources of a given type.
	NSMutableDictionary * badAttributes = [NSMutableDictionary dictionary];
	NSMutableArray * attributeKeys = [[[attributes allKeys] mutableCopy] autorelease];
	ResourceCount resourceIndex = Count1Resources(resourceType);
	NSString * key;
	Str255 resourceName;
	short resourceID;
	Handle H;
	nextLoop:
	while(resourceIndex)
	{
		H = Get1IndResource(resourceType, resourceIndex);
		if ((resError = ResError())|| !H)
		{
			if (iTM2DebugEnabled)
			{
				LOG4iTM3(@"3 - Could not Get1Resource, error %i (resourceIndex is %i)", resError, resourceIndex);
				OUTERROR4iTM3(3,([NSString stringWithFormat:@"3 - Could not Get1Resource, error %i (resourceIndex is %i)", resError, resourceIndex]),nil);
			}
			--resourceIndex;
			goto nextLoop;
		}
		if (iTM2DebugEnabled)
		{
			LOG4iTM3(@"4 - Could use Get1Resource, error %i (resourceIndex is %i)", resError, resourceIndex);
		}
		GetResInfo(H, &resourceID, nil, resourceName);
		if (resError = ResError())
		{
			if (iTM2DebugEnabled)
			{
				LOG4iTM3(@"5 - Could not GetResInfo, error %i (resourceIndex is %i)", resError, resourceIndex);
				OUTERROR4iTM3(3,([NSString stringWithFormat:@"5 - Could not GetResInfo, error %i (resourceIndex is %i)", resError, resourceIndex]),nil);
			}
			--resourceIndex;
			goto nextLoop;
		}
		if (iTM2DebugEnabled)
		{
			LOG4iTM3(@"6 - Could use GetResInfo, error %i (resourceIndex is %i)", resError, resourceIndex);
		}
		Str255 dst;
		memcpy(dst, resourceName+1, resourceName[ZER0]);
		dst[resourceName[ZER0]]='\0';
		key = [NSString stringWithUTF8String:(void*)dst];
		if (key.length)
		{
			RemoveResource(H);
			if (resError = ResError())
			{
				if (iTM2DebugEnabled)
				{
					LOG4iTM3(@"7 - Could not RemoveResource, error %i (resourceIndex is %i)", resError, resourceIndex);
				}
			}
			DisposeHandle(H);
			[attributeKeys removeObject:key];
			NSData * D = [attributes objectForKey:key];
			if ([D isKindOfClass:[NSData class]])
			{
				if (resError = PtrToHand([D bytes], &H, D.length))
				{
					if (iTM2DebugEnabled)
					{
						LOG4iTM3(@"WARNING: Could not convert a Ptr into a handle, error %i", resError);
					}
				}
				else
				{
					HLock(H);
					AddResource(H, resourceType, resourceID, resourceName);
					HUnlock(H);
					if (resError = ResError())
					{
						if (iTM2DebugEnabled)
						{
							LOG4iTM3(@"8 - Could not AddResource, error %i", resError);
						}
						DisposeHandle(H);// hum the handle is considered the property of the resource manager now?
					}
					else if (iTM2DebugEnabled>99)
					{
						LOG4iTM3(@"9 - Resource added: %u", resourceID);
					}
					// DisposeHandle(H);// hum the handle is considered the property of the resource manager now?
				}
			}
			else if (D)
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
	for(key in attributeKeys)
	{
		NSData * D = [attributes objectForKey:key];
		const char * src = [key UTF8String];
		if (strlen(src)<256)
		{
			memcpy(resourceName+1, src, strlen(src));
			resourceName[ZER0]=strlen(src);
			if ([D isKindOfClass:[NSData class]])
			{
				if (resError = PtrToHand([D bytes], &H, D.length))
				{
					if (iTM2DebugEnabled)
					{
						LOG4iTM3(@"10 - WARNING: Could not convert a Ptr into a handle, error %i", resError);
					}
					result = NO;
				}
				else
				{
					resourceID = Unique1ID(resourceType);
					if (resError = ResError())
					{
						if (iTM2DebugEnabled)
						{
							LOG4iTM3(@"11 - WARNING: Could not find a unique ID %i", resError);
						}
						result = NO;
					}
					else
					{
						HLock(H);
						AddResource(H, resourceType, resourceID, resourceName);
						HUnlock(H);
						if (resError = ResError())
						{
							if (iTM2DebugEnabled)
							{
								LOG4iTM3(@"12 - Could not AddResource, error %i", resError);
							}
							DisposeHandle(H);// hum the handle is considered the property of the resource manager now?
							result = NO;
						}
						else if (iTM2DebugEnabled>99)
						{
							LOG4iTM3(@"13 - Resource added: %u", resourceID);
						}
						// DisposeHandle(H);// hum the handle is considered the property of the resource manager now?
					}
				}
			}
			else if (D)
			{
				[badAttributes setObject:D forKey:key];
			}
		}
		else if (D)
		{
			[badAttributes setObject:D forKey:key];
		}
	}
	CloseResFile(fileSystemReferenceNumber);
	if (resError = ResError())
	{
		if (iTM2DebugEnabled)
		{
			LOG4iTM3(@"14 - Could not CloseResFile, error %i", resError);
		}
	}
	if (wasCurResFile)
	{
		UseResFile(curResFile);
		if (resError = ResError())
		{
			if (iTM2DebugEnabled)
			{
				LOG4iTM3(@"15 - Could not UseResFile, error %i", resError);
			}
		}
	}
	if (badAttributes.count)
	{
		if (iTM2DebugEnabled)
		{
			LOG4iTM3(@"16 - ERROR: Some attributes were not accepted (bad data, bad key)%@", badAttributes);
		}
		result = NO;
	}
//END4iTM3;
    return result;// even if the resources could not be saved...
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  extendedFileAttributeWithResourceType4iTM3:resourceID:atPath:error:
- (NSData *)extendedFileAttributeWithResourceType4iTM3:(ResType)resourceType resourceID:(ResID)resourceID atPath:(NSString *)path error:(NSError **)RORef;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 06/01/03
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSData * D = nil;
	if (![DFM fileExistsAtPath:path])
	{
		if (RORef)
			* RORef = [NSError errorWithDomain:__iTM2_PRETTY_FUNCTION__
				code: kiTM2ExtendedAttributesNoFileAtPathError userInfo: nil];
		return D;
	}
	path = path.stringByResolvingSymlinksInPath;// no finder alias resolution!!!
	FSRef fileSystemReference;
	NSURL * myURL = [NSURL fileURLWithPath:path];
	if (!CFURLGetFSRef((CFURLRef)myURL, &fileSystemReference))
	{
		if (iTM2DebugEnabled)
		{
			LOG4iTM3(@"CFURLGetFSRef error.");
		}
		return D;
	}
	short curResFile = CurResFile();
	BOOL wasCurResFile = (noErr == ResError());
	HFSUniStr255 resourceForkName;
	OSErr resError = FSGetResourceForkName (&resourceForkName);
	if (resError != noErr) {
		NSLog(@"FSGetResourceForkName error:%i.",resError);
		return D;
	}
	ResFileRefNum fileSystemReferenceNumber;
	if (resError = FSOpenResourceFile (&fileSystemReference,resourceForkName.length,resourceForkName.unicode,fsRdPerm,&fileSystemReferenceNumber))
	{
		if (iTM2DebugEnabled)
		{
			LOG4iTM3(@"1 - Could not FSOpenResourceFile at %@ error %i (fileSystemReferenceNumber: %i)",path,resError,fileSystemReferenceNumber);
		}
		if (RORef)
			* RORef = [NSError errorWithDomain:__iTM2_PRETTY_FUNCTION__
				code: kiTM2ExtendedAttributesResourceManagerError
					userInfo: [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:resError] forKey:@"ResError"]];
		return nil;
	}
	UseResFile(fileSystemReferenceNumber);
	if (resError = ResError())
	{
		if (iTM2DebugEnabled)
		{
			LOG4iTM3(@"2 - Could not UseResFile, at %@ error %i (fileSystemReferenceNumber: %i)",path,resError,fileSystemReferenceNumber);
		}
		if (RORef)
			* RORef = [NSError errorWithDomain:__iTM2_PRETTY_FUNCTION__
				code: kiTM2ExtendedAttributesResourceManagerError
					userInfo: [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:resError] forKey:@"ResError"]];
		CloseResFile(fileSystemReferenceNumber);
		return nil;
	}
	Handle H = Get1Resource(resourceType, resourceID);
	if ((resError = ResError())|| !H)
	{
		if (iTM2DebugEnabled)
		{
			LOG4iTM3(@"3 - Could not Get1Resource, at %@ error %i (resourceID is %i)", path,resError,resourceID);
			OUTERROR4iTM3(2,([NSString stringWithFormat:@"Could not Get1Resource, at %@ error %i (resourceID is %i)", path,resError,resourceID]),nil);
		}
		if (RORef)
			* RORef = [NSError errorWithDomain:__iTM2_PRETTY_FUNCTION__
				code: kiTM2ExtendedAttributesResourceManagerError
					userInfo: [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:resError] forKey:@"ResError"]];
		return nil;
	}
	if (iTM2DebugEnabled)
	{
		LOG4iTM3(@"4 - Could use Get1Resource, at %@ error %i (resourceID is %i)", path,resError,resourceID);
	}
	HLock(H);
	D = [NSData dataWithBytes:*H length:GetHandleSize(H)];
	HUnlock(H);
	ReleaseResource(H);
	if (resError = ResError())
	{
		if (iTM2DebugEnabled)
		{
			LOG4iTM3(@"5 - Could not ReleaseResource, at %@ error %i (resourceID is %@)",path,resError,resourceID);
		}
		if (RORef)
			* RORef = [NSError errorWithDomain:__iTM2_PRETTY_FUNCTION__
				code: kiTM2ExtendedAttributesResourceManagerError
					userInfo: [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:resError] forKey:@"ResError"]];
	}
	CloseResFile(fileSystemReferenceNumber);
	if (resError = ResError())
	{
		if (iTM2DebugEnabled)
		{
			LOG4iTM3(@"6 - Could not CloseResFile, error %i", resError);
		}
		if (RORef)
			* RORef = [NSError errorWithDomain:__iTM2_PRETTY_FUNCTION__
				code: kiTM2ExtendedAttributesResourceManagerError
					userInfo: [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:resError] forKey:@"ResError"]];
	}
	if (wasCurResFile)
	{
		UseResFile(curResFile);
		if (resError = ResError())
		{
			if (iTM2DebugEnabled)
			{
				LOG4iTM3(@"7 - Could not UseResFile, error %i", resError);
			}
			if (RORef)
				* RORef = [NSError errorWithDomain:__iTM2_PRETTY_FUNCTION__
					code: kiTM2ExtendedAttributesResourceManagerError
						userInfo: [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:resError] forKey:@"ResError"]];
		}
	}
//END4iTM3;
	return D;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  addExtendedFileAttribute4iTM3:value:withResourceType:resourceID:atPath:error:
- (BOOL)addExtendedFileAttribute4iTM3:(NSString*)attributeName value:(NSData *)D withResourceType:(ResType)resourceType resourceID:(ResID)resourceID atPath:(NSString *)path error:(NSError **)RORef;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 06/01/03
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (![DFM fileExistsAtPath:path]) {
		return NO;
	}
	BOOL result = YES;
	path = path.stringByResolvingSymlinksInPath;// No Finder alias resolution!!! because I can have to add an extended attribute to a, alias file.
	ResFileRefNum curResFile = CurResFile();
	BOOL wasCurResFile = (noErr == ResError());
	FSRef fsRef;
	NSURL * myURL = [NSURL fileURLWithPath:path];
	if (!CFURLGetFSRef((CFURLRef)myURL, &fsRef)) {
		if (iTM2DebugEnabled) {
			LOG4iTM3(@"CFURLGetFSRef error.");
		}
		return NO;
	}
	HFSUniStr255 resourceForkName;
	OSErr resError = FSGetResourceForkName (&resourceForkName);
	if (resError != noErr) {
		NSLog(@"FSGetResourceForkName error:%i.",resError);
		return -1;
	}
	resError = FSCreateResourceFork(&fsRef,resourceForkName.length,resourceForkName.unicode,0);
	if (resError == errFSForkExists) {
		if (iTM2DebugEnabled) {
			LOG4iTM3(@"FSCreateResourceFork error.%i==errFSForkExists(%i)",resError,errFSForkExists);
		}
	} else if (resError != noErr) {
		if (iTM2DebugEnabled) {
			LOG4iTM3(@"FSCreateResourceFork error.%i",resError);
		}
		return NO;
	}
	ResFileRefNum fileSystemReferenceNumber;
	if (resError = FSOpenResourceFile (&fsRef,resourceForkName.length,resourceForkName.unicode,fsRdWrPerm,&fileSystemReferenceNumber)) {
		if (iTM2DebugEnabled) {
			LOG4iTM3(@"1 - Could not FSOpenResFile, at %@, error %i, fileSystemReferenceNumber: %i",path,resError,fileSystemReferenceNumber);
		}
		CloseResFile(fileSystemReferenceNumber);
		OUTERROR4iTM3(kiTM2ExtendedAttributesResourceManagerError,([NSString stringWithFormat:@"1 - Could not FSOpenResFile, at %@, error %i, fileSystemReferenceNumber: %i",path,resError,fileSystemReferenceNumber]),nil);
		return NO;
	}
	UseResFile(fileSystemReferenceNumber);
	if (resError = ResError()) {
		if (iTM2DebugEnabled) {
			LOG4iTM3(@"2 - Could not UseResFile, at %@, error %i, fileSystemReferenceNumber: %i",path,resError,fileSystemReferenceNumber);
		}
		OUTERROR4iTM3(kiTM2ExtendedAttributesResourceManagerError,([NSString stringWithFormat:@"2 - Could not UseResFile, at %@, error %i, fileSystemReferenceNumber: %i",path,resError,fileSystemReferenceNumber]),nil);
		CloseResFile(fileSystemReferenceNumber);
		return NO;
	}
	Handle H = Get1Resource(resourceType, resourceID);
	if (resError = ResError()) {
		if (iTM2DebugEnabled) {
			LOG4iTM3(@"3 - Could not Get1Resource, at %@ error %i (resourceID is %i)", path,resError,resourceID);
			OUTERROR4iTM3(3,([NSString stringWithFormat:@"3 - Could not Get1Resource, at %@ error %i (resourceID is %i)", path,resError,resourceID]),nil);
		}
	} else if (iTM2DebugEnabled) {
		LOG4iTM3(@"4 - Could use Get1Resource, at %@ error %i (resourceID is %i)", path,resError,resourceID);
	}
	if (resError = PtrToHand([D bytes], &H, D.length)) {
		if (iTM2DebugEnabled) {
			LOG4iTM3(@"5 - WARNING: Could not convert a Ptr into a handle, error %i", resError);
			OUTERROR4iTM3(3,([NSString stringWithFormat:@"5 - WARNING: Could not convert a Ptr into a handle"]),nil);
		}
	} else {
		NSRange r = iTM3MakeRange(0, attributeName.length);
		if (r.length>255)
		{
			r.length = 255;
			attributeName = [attributeName substringWithRange:r];
		}
		const char * src = nil;
createSrc:
		src = [attributeName UTF8String];
		if ((strlen(src)> 255) && r.length)
		{
			--r.length;
			attributeName = [attributeName substringWithRange:r];
			goto createSrc;
		}
		Str255 resourceName;
		memcpy(resourceName+1, src, strlen(src));
		resourceName[ZER0]=strlen(src);
		HLock(H);
		AddResource(H, resourceType, resourceID, resourceName);
		HUnlock(H);
		if (resError = ResError()) {
			if (iTM2DebugEnabled) {
				LOG4iTM3(@"6 - Could not AddResource, error %i", resError);
			}
			DisposeHandle(H);// hum the handle is considered the property of the resource manager now?
		} else if (iTM2DebugEnabled>99) {
			LOG4iTM3(@"7 - Resource added: %u", resourceID);
		}
		// DisposeHandle(H);// hum the handle is considered the property of the resource manager now?
	}
	CloseResFile(fileSystemReferenceNumber);
	if (resError = ResError()) {
		LOG4iTM3(@"8 - Could not CloseResFile, error %i", resError);
		OUTERROR4iTM3(3,([NSString stringWithFormat:@"8 - Could not CloseResFile, error %i", resError]),nil);
	}
	if (wasCurResFile) {
		UseResFile(curResFile);
		if (resError = ResError()) {
			if (iTM2DebugEnabled) {
				LOG4iTM3(@"9 - Could not UseResFile, error %i", resError);
			}
			OUTERROR4iTM3(3,([NSString stringWithFormat:@"9 - Could not UseResFile, error %i", resError]),nil);
		}
	}
//END4iTM3;
    return result;// even if the resources could not be saved...
}
@end


//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= NSFileManager(iTeXMac2)
