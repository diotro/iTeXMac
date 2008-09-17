/*
//
//  @version Subversion: $Id: iTM2InfoWrapperKit.m 574 2007-10-08 23:21:41Z jlaurens $ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Tue Jan  4 07:48:24 GMT 2005.
//  Copyright © 2005 Laurens'Tribune. All rights reserved.
//
//  This program is free software; you can redistribute it and/or modify it under the terms
//  of the GNU General Public License as published by the Free Software Foundation; either
//  version 2 of the License,or any later version,modified by the addendum below.
//  This program is distributed in the hope that it will be useful,but WITHOUT ANY WARRANTY;
//  without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
//  See the GNU General Public License for more details. You should have received a copy
//  of the GNU General Public License along with this program; if not,write to the Free Software
//  Foundation,Inc.,59 Temple Place - Suite 330,Boston,MA 02111-1307,USA.
//  GPL addendum:Any simple modification of the present code which purpose is to remove bug,
//  improve efficiency in both code execution and code reading or writing should be addressed
//  to the actual developper team.
//
//  Version history: (format "- date:contribution(contributor)")
//  To Do List:(format "- proposition(percentage actually done)")
*/

#import <iTM2Foundation/iTM2InfoWrapperKit.h>
#import <iTM2Foundation/iTM2ProjectControllerKit.h>
#import <iTM2Foundation/iTM2Implementation.h>
#import <iTM2Foundation/iTM2ContextKit.h>
#import <iTM2Foundation/iTM2PathUtilities.h>

NSString * const TWSProjectKey = @"project";
NSString * const TWSContentsKey = @"contents";
NSString * const TWSFactoryKey = @"factory";
NSString * const TWSToolsKey = @"tools";
NSString * const TWSTargetsKey = @"targets";
NSString * const TWSKeyedFilesKey = @"files";
NSString * const TWSKeyedPropertiesKey = @"properties";

NSString * const iTM2ParentKey = @"...iTM2Parent";
NSString * const iTM2FinderAliasesKey = @"...iTM2FinderAliases";
NSString * const iTM2SoftLinksKey = @"...iTM2SoftLinks";


NSString * const iTM2InfoWrapperType = @"iTM2 Property list wrapper";

NSString * const iTM2ProjectLastKeyKey = @"_LastKey";
NSString * const iTM2ProjectFrontDocumentKey = @"...iTM2FrontDocument";

@interface NSObject(iTM2InfoWrapper)
- (id)iTM2_deepMutableCopy;
@end

@implementation NSObject(iTM2InfoWrapper)
- (id)iTM2_deepMutableCopy;
{
	NSString * errorString = nil;
	id data = [NSPropertyListSerialization dataFromPropertyList:self format:NSPropertyListBinaryFormat_v1_0 errorDescription:&errorString];
	if(data)
	{
		id result = [[NSPropertyListSerialization propertyListFromData:data
			mutabilityOption: NSPropertyListMutableContainersAndLeaves
				format: nil errorDescription: &errorString] retain];
		if(result)
		{
			return result;
		}
		else if(errorString)
		{
			iTM2_LOG(@"! ERROR 2 while deep copying the model, internal inconsistency!");
			[errorString release];
		}
		iTM2_LOG(@"! ERROR: No deep copy of the model");
	}
	else if(errorString)
	{
		iTM2_LOG(@"! ERROR 1 while deep copying the model, bad entry: %@",self);
		[errorString release];
	}
	return [self respondsToSelector:@selector(mutableCopy)]?[self mutableCopy]:[self retain];
}
@end

@interface NSMutableDictionary(iTM2InfoWrapper)
- (void)iTM2_mergeEntriesFromDictionary:(NSDictionary *)otherDictionary;
@end

@implementation NSMutableDictionary(iTM2InfoWrapper)
- (void)iTM2_mergeEntriesFromDictionary:(NSDictionary *)otherDictionary;
{
	
	NSEnumerator * E = [self keyEnumerator];
	NSString * K;
	while(K = [E nextObject])
	{
		if([[self objectForKey:K] isEqual:@"Base"])// no more base due to the correct management of inheritancy
		{
			[self removeObjectForKey:@"Base"];
		}
	}
	E = [otherDictionary keyEnumerator];
	while(K = [E nextObject])
	{
		id left = [self objectForKey:K];
		id right = [otherDictionary objectForKey:K];
		if([left isKindOfClass:[NSDictionary class]] && [right isKindOfClass:[NSDictionary class]])
		{
			[left iTM2_mergeEntriesFromDictionary:right];
		}
		else if(![right isEqual:@"Base"])
		{
			[self setObject:right forKey:K];
		}
	}
}
@end

@implementation iTM2InfoWrapper
+ (void)initialize;
{
	[super initialize];
	NSAssert((!strcmp(@encode(BOOL),"c")),@"Unexpected runtime system");
	NSAssert((!strcmp(@encode(SEL),":")),@"Unexpected runtime system");
	NSAssert((!strcmp(@encode(id),"@")),@"Unexpected runtime system");
	return;
}
- (id)init;
{
	if(self = [super init])
	{
		[self setModel:[NSDictionary dictionary]];
	}
	return self;
}
#pragma mark =-=-=-=-=-  LOCAL MODEL
- (id)model;
{
	return metaGETTER;
}
- (void)setModel:(id)model;
{
	// make a mutable deep copy.
	// the local model needs to be mutable in order to make updates easily.
	// However, the receiver should be the only one to know that it -is- mutable...
	// and everyone else should simply ignore this fact.
	if(!model)
	{
		// reset the model
		metaSETTER([NSMutableDictionary dictionary]);
		return;
	}
	// if this can't be done, it is not a valid property list
	// the programmer should be responsible of what he is doing but there is no safety guard here
	// get a data object
	NSString * errorString = nil;
	NSData * data = [NSPropertyListSerialization dataFromPropertyList:model format:NSPropertyListBinaryFormat_v1_0 errorDescription:&errorString];
	if(data)
	{
		// the model is a valid property list
		if(model = [NSPropertyListSerialization propertyListFromData:data
			mutabilityOption: NSPropertyListMutableContainersAndLeaves
				format: nil errorDescription: &errorString])
		{
			// this is a mean to retrieve a completely mutable model
			metaSETTER(model);
			return;
		}
		else if(errorString)
		{
			iTM2_LOG(@"! ERROR 2 while deep copying the model, internal inconsistency!");
			[errorString release];
		}
		iTM2_LOG(@"! ERROR: No deep copy of the model");
	}
	else if(errorString)
	{
		iTM2_LOG(@"! ERROR 1 while deep copying the model, bad entry: %@",model);
		[errorString release];
	}
	metaSETTER([[model mutableCopy] autorelease]);
	return;
}
- (NSString *)modelKeyPath;
{
	return metaGETTER;
}
- (void)setModelKeyPath:(NSString *)path;
{
	metaSETTER(path);
}
- (int)changeCount;
{
	return [metaGETTER intValue];
}
- (void)updateChangeCount:(NSDocumentChangeType)change;
{
	int old = [[IMPLEMENTATION metaValueForSelector:@selector(changeCount)] intValue];
	switch(change)
	{
		case  NSChangeDone: ++old;break;
		case  NSChangeUndone: --old;break;
		case  NSChangeCleared:
		default: old = 0;break;
	}
	[IMPLEMENTATION takeMetaValue:[NSNumber numberWithInt:old] forSelector:@selector(changeCount)];
	return;
}
- (id)infoForKeys:(NSArray *)keys;
{
	NSParameterAssert([keys count]);
	id result = nil;
	id model = [self model];
	NSEnumerator * E = [keys objectEnumerator];
	NSString * K;
	while(K = [E nextObject])
	{
		if([K length])
		{
			// this is the first time we get here,
			// we know model is a dictionary
			result = [model objectForKey:K];
			while(K = [E nextObject])
			{
				if([K length])
				{
					// We are not sure that model is a dictionary
					if([result isKindOfClass:[NSDictionary class]])
					{
						model = result;
						result = [model objectForKey:K];
					}
					else
					{
						return nil;
					}
				}
			}
		}
	}
	return result;
}
//  This macro turns a non void variable argument list of objects into an array.
//  FIRST is the argument name that appears in the function header before the ",..."
//  MRA is the name of the resulting array, it will be created
#   define iTM2_VA_LIST_OF_KEY_PATHS_TO_ARRAY(FIRST,MRA)\
	NSMutableArray * MRA = [NSMutableArray array];\
	if(FIRST)\
	{\
		[MRA addObjectsFromArray:[FIRST componentsSeparatedByString:@"."]];\
		va_list list;\
		va_start(list,FIRST);\
		NSString * S;\
		while(S = va_arg (list, id))\
		{\
			[MRA addObjectsFromArray:[S componentsSeparatedByString:@"."]];\
		}\
		va_end(list);\
	}

- (id)infoForKeyPaths:(NSString *)first,...;
{
	iTM2_VA_LIST_OF_KEY_PATHS_TO_ARRAY(first,keys);
	return [self infoForKeys:keys];
}
- (BOOL)setInfo:(id)info forKeys:(NSArray *)keys;
{
	NSParameterAssert([keys count]);
	id model = [self model];
	unsigned index = [keys count];
	NSEnumerator * E = [keys reverseObjectEnumerator];
	// we must treat the last key differently
	NSString * lastK = nil;
	while((lastK = [E nextObject]) && ![lastK length])
	{
		--index;
	}
	NSString * K;
	E = [keys objectEnumerator];
	if(info)
	{
		while(--index)
		{
			// for all the intermediate keys
			K = [E nextObject];
			if([K length])
			{
				// create the intermediate dictionary object if necessary
				NSMutableDictionary * D = [model objectForKey:K];
				if(![D isKindOfClass:[NSDictionary class]])
				{
					D = [NSMutableDictionary dictionary];
					[model setObject:D forKey:K];
				}
				model = D;
			}
		}
		if(![info isEqual:[model objectForKey:lastK]])
		{
			[model setObject:info forKey:lastK];
			[self updateChangeCount:NSChangeDone];
			return YES;
		}
		return NO;
	}
	else
	{
		while(--index)
		{
			K = [E nextObject];
			if([K length])
			{
				NSMutableDictionary * D = [model objectForKey:K];
				if(!D)
				{
					return NO;
				}
				else if(![D isKindOfClass:[NSDictionary class]])
				{
					[model removeObjectForKey:K];
					return NO;
				}
				model = D;
			}
		}
		if([model objectForKey:lastK])
		{
			[model removeObjectForKey:lastK];
			[self updateChangeCount:NSChangeDone];
			return YES;
		}
		return NO;
	}
}
- (BOOL)setInfo:(id)info forKeyPaths:(NSString *)first,...;
{
	iTM2_VA_LIST_OF_KEY_PATHS_TO_ARRAY(first,keys);
	return [self setInfo:info forKeys:keys];
}
const char * iTM2InfoWrapper_set_prefix = "setInfo:forPaths:";
const char * iTM2InfoWrapper_get_prefix = "infoForPaths:";
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
	// another convenient setter/getter pair, for example
	// id info = [self infoForPaths:components1:components2:components3:componentsN];
	// if([self setInfo:info forPaths:components1:components2:components3:componentsN]) {...
	// where components is a dot separated list of path components
	// with the usual restrictions
	// Those path components are used as dictionary keys
	const char * sel_name = SELNAME(aSelector);
	// if sel_name matches /infoForPaths(:+)/ or /setInfo:forPaths(:+)/
	// the 
	size_t size = 4;//"c@:@" for the setter or "@@:@" for the getter
	char * signature = NULL;
	if(0 == strncmp(sel_name,iTM2InfoWrapper_set_prefix,strlen(iTM2InfoWrapper_set_prefix)))
	{
		sel_name += strlen(iTM2InfoWrapper_set_prefix);
		while(*sel_name == ':')// each time a new ':' appears, a new object argument is required
		{
			++sel_name;
			++size;
		}
		if((*sel_name == '\0')&&(signature = malloc(size+1)))// + termination
		{
			memset(signature+1,'@',size-1);
			signature[0]='c';
finish:
			signature[size]='\0';
			signature[2]=':';
			id result = [NSMethodSignature signatureWithObjCTypes:signature];
			free(signature);
			return result;
		}
	}
	else if(0 == strncmp(sel_name,iTM2InfoWrapper_get_prefix,strlen(iTM2InfoWrapper_get_prefix)))
	{
		sel_name += strlen(iTM2InfoWrapper_get_prefix);
		while(*sel_name == ':')
		{
			++sel_name;
			++size;
		}
		if((*sel_name == '\0')&&(signature = malloc(size+1)))
		{
			memset(signature,'@',size);
			goto finish;
		}
	}
	return [super methodSignatureForSelector:aSelector];
}
- (void)forwardInvocation:(NSInvocation *)anInvocation;
{
	// see methodSignatureForSelector above
	const char * name = SELNAME([anInvocation selector]);
	unsigned index = 2;
	NSMutableArray * Ks = [NSMutableArray array];
	NSString * K;
	id O;
	if(!strncmp(name,iTM2InfoWrapper_get_prefix,strlen(iTM2InfoWrapper_get_prefix)))
	{
		// we assume that name is prefix + '@' characters
		// there is at least one argument or type id
		// and possibly others
		// The total number of arguments is exactly strlen(name)-strlen(iTM2InfoWrapper_get_prefix)+1
		// +1 because the prefix already contains one such argument
		// index runs from 2 to strlen(name)-strlen(iTM2InfoWrapper_get_prefix)+2, included
		do
		{
			[anInvocation getArgument:&K atIndex:index];
			[Ks addObjectsFromArray:[K componentsSeparatedByString:@"."]];
		} while(++index<=strlen(name)-strlen(iTM2InfoWrapper_get_prefix)+2);
		O = [self infoForKeys:Ks];
		[anInvocation setReturnValue:&O];
		return;
	}
	else if(!strncmp(name,iTM2InfoWrapper_set_prefix,strlen(iTM2InfoWrapper_set_prefix)))
	{
		[anInvocation getArgument:&O atIndex:index];
		++index;
		// Like before
		// The total number of arguments is exactly strlen(name)-strlen(iTM2InfoWrapper_set_prefix)+1
		// index runs from 3 to strlen(name)-strlen(iTM2InfoWrapper_get_prefix)+3, included
		do
		{
			[anInvocation getArgument:&K atIndex:index];
			[Ks addObjectsFromArray:[K componentsSeparatedByString:@"."]];
		} while(++index<=strlen(name)-strlen(iTM2InfoWrapper_set_prefix)+3);
		BOOL result = [self setInfo:O forKeys:Ks];
		[anInvocation setReturnValue:&result];
		return;
	}
	[super forwardInvocation:anInvocation];
}
@end

@implementation iTM2MainInfoWrapper
- (id)initWithProjectURL:(NSURL *)projectURL error:(NSError **)outErrorPtr;
{
	NSParameterAssert(projectURL);
	if(self = [super init])
	{
		[self setProjectURL:projectURL error:outErrorPtr];
	}
	return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  projectURL
- (NSURL *)projectURL;
/*"Discussion forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.1: Sat May  3 16:25:49 UTC 2008
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	return metaGETTER;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setProjectURL:error:
- (void)setProjectURL:(NSURL *)projectURL error:(NSError **)outErrorPtr;
/*"Discussion forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.1: Sat May  3 16:25:55 UTC 2008
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSParameterAssert(projectURL);
	metaSETTER(projectURL);
	NSURL * url = [SPC mainInfoURLFromURL:projectURL create:NO error:outErrorPtr];
	if(url)
	{
		id model = [NSDictionary dictionaryWithContentsOfURL:url];
		if(model)
		{
			[self setModel:model];
		}
		else if([url isFileURL] && [DFM fileExistsAtPath:[url path]])
		{
			iTM2_OUTERROR(1,([NSString stringWithFormat:@"! ERROR while reading the property list at %@", url]),nil);
		}
	}
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  fileKeys
- (id)fileKeys;
/*"All the file keys known by the receiver, except the reserved keys.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.1: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    id result = [NSMutableArray array];
	NSEnumerator * E = [[self infoForKeyPaths:TWSKeyedFilesKey,nil] keyEnumerator];
	NSString * K;
	while(K = [E nextObject])
	{
		if(![SPC isReservedFileKey:K])
		{
			[result addObject:K];
		}
	}
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  nameForFileKey:
- (NSString *)nameForFileKey:(NSString *)key;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.1: Sat May  3 08:59:56 UTC 2008
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(![key length])
	{
		return nil;
	}
	NSString * result = [self infoForKeyPaths:TWSKeyedFilesKey,key,nil];
	if([key isEqual:TWSContentsKey] && ![result length])
	{
		// default value
		result = @"";
	}
	if([key isEqual:TWSFactoryKey] && ![result length])
	{
		// default value
		result = iTM2PathFactoryComponent;
	}
//iTM2_END;
	return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  fileKeyForName:
- (NSString *)fileKeyForName:(NSString *)name;
/*"Description forthcoming. Return value cannot be a reserved key.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.1: Fri May  2 10:33:41 UTC 2008
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	NSEnumerator * E = [[self fileKeys] objectEnumerator];
	NSString * key;
	while(key = [E nextObject])
	{
		if([name iTM2_pathIsEqual:[self nameForFileKey:key]])
		{
			return key;
		}
	}
	E = [[SPC reservedFileKeys] objectEnumerator];
	while(key = [E nextObject])
	{
		if([name iTM2_pathIsEqual:[self nameForFileKey:key]])
		{
			return key;
		}
	}
	return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setName:forFileKey:
- (BOOL)setName:(NSString *)name forFileKey:(NSString *)key;
/*"Description forthcoming. yes if something did change
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon Jan 21 21:39:25 UTC 2008
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(![key length])
	{
		return NO;
	}
	NSString * 	old = [self nameForFileKey:key];
	if(![old iTM2_pathIsEqual:name])
	{
		return [self setInfo:name forKeyPaths:TWSKeyedFilesKey,key,nil];
	}
	return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  URLForFileKey:
- (NSURL *)URLForFileKey:(NSString *)key;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.1: Tue May  6 14:25:43 UTC 2008
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSURL * projectURL = [self projectURL];
	if([key isEqual:TWSProjectKey])
	{
		return projectURL;
	}
	NSString * name = nil;
	NSURL * url = nil;
	id PD = [SPC projectForURL:projectURL];
	if([key isEqual:iTM2ParentKey])
	{
		if(url = [PD parentURL]) return url;
		return [NSURL URLWithString:@".." relativeToURL:[projectURL iTM2_URLByRemovingFactoryBaseURL]];
	}
	else if([key isEqual:TWSContentsKey])
	{
		if(url = [PD contentsURL]) return url;
		name = [self nameForFileKey:key];
		url = [self URLForFileKey:iTM2ParentKey];
		return [name length]?[NSURL iTM2_URLWithPath:name relativeToURL:url]:url;
	}
	else if([key isEqual:TWSFactoryKey])
	{
		if(url = [PD factoryURL]) return url;
		name = [self nameForFileKey:key];
		return [name length]?[NSURL iTM2_URLWithPath:name relativeToURL:projectURL]:projectURL;// we should always have [name length]>0
	}
	if([SPC isReservedFileKey:key])
	{
		return nil;
	}
	else if([key length])
	{
		name = [self nameForFileKey:key];
		NSURL * url = [NSURL URLWithString:name];
		if([[url scheme] length] || !projectURL)
		{
			return url;
		}
		if([[name pathExtension] isEqual:TWSFactoryExtension])
		{
			name = [name stringByDeletingPathExtension];
			url = [self URLForFileKey:TWSFactoryKey];
			return [NSURL iTM2_URLWithPath:name relativeToURL:[self URLForFileKey:TWSFactoryKey]];
		}
		url = [self URLForFileKey:TWSContentsKey];
		return [NSURL iTM2_URLWithPath:name relativeToURL:url];
	}
//iTM2_END;
    return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  fileKeyForURL:
- (NSString *)fileKeyForURL:(NSURL *)url;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.1: Sat May  3 09:41:58 UTC 2008
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSURL * projectURL = [self projectURL];
	NSEnumerator * E = [[self fileKeys] objectEnumerator];
	NSString * K;
	while(K = [E nextObject])
	{
		if([[self URLForFileKey:K] iTM2_isEquivalentToURL:url]) return K;
	}
	if([projectURL iTM2_isEquivalentToURL:url]) return TWSProjectKey;
	// next keys might correspond to cached URLs
	id PD = [SPC projectForURL:projectURL];
	if(PD)
	{
		if([[PD contentsURL] iTM2_isEquivalentToURL:url]) return TWSContentsKey;
		if([[PD factoryURL] iTM2_isEquivalentToURL:url])  return TWSFactoryKey;
		if([[PD parentURL] iTM2_isEquivalentToURL:url])   return iTM2ParentKey;
	}
	else
	{
#       define TEST [[SPC URLForFileKey:K filter:iTM2PCFilterRegular inProjectWithURL:projectURL] iTM2_isEquivalentToURL:url]
		K = TWSContentsKey;if(TEST) return K;
		K = TWSFactoryKey; if(TEST) return K;
		K = iTM2ParentKey; if(TEST) return K;
#       undef TEST
	}
//iTM2_END;
    return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setURL:forFileKey:
- (NSURL *)setURL:(NSURL *)fileURL forFileKey:(NSString *)key;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.1: Fri May  2 15:57:01 UTC 2008
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSURL * projectURL = [self projectURL];
	if([key isEqual:TWSProjectKey])
	{
		// Nonsense
		return projectURL;
	}
	NSURL * theURL = nil;
	NSString * relative = nil;
	if([key isEqual:TWSContentsKey])
	{
		// if the given URL is absolute, the contents must be relative to the parent directory of the project
		if([fileURL baseURL])
		{
			theURL = [SPC URLForFileKey:iTM2ParentKey filter:iTM2PCFilterRegular inProjectWithURL:projectURL];
			relative = [fileURL iTM2_pathRelativeToURL:theURL];
		}
		else
		{
			relative = [fileURL relativePath];
		}
		if([relative hasPrefix:@".."])
		{
			return nil;
		}
		[self setName:relative forFileKey:key];
		theURL = [self URLForFileKey:key];
		return [theURL isEqual:fileURL]?fileURL:theURL;
	}
	if([key isEqual:TWSFactoryKey])
	{
		if([fileURL baseURL])
		{
			theURL = [projectURL iTM2_URLByPrependingFactoryBaseURL];
			relative = [fileURL iTM2_pathRelativeToURL:theURL];
		}
		else
		{
			relative = [fileURL relativePath];
		}
		if([relative hasPrefix:@".."] || ![relative length])
		{
			return nil;
		}
		[self setName:relative forFileKey:key];
		theURL = [self URLForFileKey:key];
		return [theURL isEqual:fileURL]?fileURL:theURL;
	}
	if([SPC isReservedFileKey:key])
	{
		// we can't change the URL's of the reserved keys
		return nil;
	}
	theURL = [SPC URLForFileKey:TWSFactoryKey filter:iTM2PCFilterRegular inProjectWithURL:projectURL];
	if([fileURL iTM2_isRelativeToURL:theURL])
	{
		// When cached, all the file names are recorded relative to the Factory directory
		relative = [[fileURL iTM2_pathRelativeToURL:theURL] stringByAppendingPathExtension:TWSFactoryExtension];
		if([relative length] && ![relative hasPrefix:@".."])
		{
			goto relativeFound;
		}
	}
	theURL = [SPC URLForFileKey:TWSContentsKey filter:iTM2PCFilterRegular inProjectWithURL:projectURL];
	if([fileURL iTM2_isRelativeToURL:theURL])
	{
		// the project is cached, it means that it could not be written in the correct location, write rights missing
		relative = [fileURL iTM2_pathRelativeToURL:theURL];
		if([relative length] && ![relative hasPrefix:@".."])
		{
			goto relativeFound;
		}
	}
	relative = [[fileURL standardizedURL] absoluteString];
relativeFound:
	[self setName:relative forFileKey:key];
	theURL = [self URLForFileKey:key];
	return [theURL isEqual:fileURL]?fileURL:theURL;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  propertiesForFileKey
- (id)propertiesForFileKey:(NSString *)key;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.1: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSParameterAssert(key!=nil);
    return [self infoForKeyPaths:TWSKeyedPropertiesKey,key,nil];
}
- (BOOL)setProperties:(id)properties forFileKey:(NSString *)key;
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return [self setInfo:[[properties mutableCopy] autorelease] forKeyPaths:TWSKeyedPropertiesKey,key,nil];
}
- (id)propertyValueForKey:(NSString *)key fileKey:(NSString *)fileKey;
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return [self infoForKeyPaths:TWSKeyedPropertiesKey,fileKey,key,nil];
}
- (BOOL)setPropertyValue:(id)property forKey:(NSString *)key fileKey:(NSString *)fileKey;
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return [self setInfo:property forKeyPaths:TWSKeyedPropertiesKey,fileKey,key,nil];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  nextAvailableKey
- (NSString *)nextAvailableKey;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.1: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSMutableDictionary * keyedNames = [self infoForKeyPaths:TWSKeyedFilesKey,nil];
	NSMutableIndexSet * set = [NSMutableIndexSet indexSet];
	NSEnumerator * E = [keyedNames keyEnumerator];
	NSString * key;
	while(key = [E nextObject])
	{
		[set addIndex:[key intValue]];
	}
	int last = 0;
	if(key = [keyedNames objectForKey:iTM2ProjectLastKeyKey])
	{
		[set addIndex:[key intValue]];
		last = [set lastIndex];
	}
	else if([set count])
	{
		last = [set lastIndex];
	}
	NSString * result = [NSString stringWithFormat:@"%i",last];
	NSString * afterKey = [NSString stringWithFormat:@"%i",last + 1];
	[keyedNames setObject:afterKey forKey:iTM2ProjectLastKeyKey];
//iTM2_LOG(@"afterKey: %@",afterKey);
//iTM2_LOG(@"result: %@",result);
    return result;
}
@end

@interface NSObject(Infos_Private)

/*! 
    @method			metaInfos
    @abstract		The meta infos.
    @discussion		The default implementation raises an exception. Subclassers must provide the model.
    @param			None
    @result			an iTM2InfoWrapper instance
	@availability	iTM2.
	@copyright		2007 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (id)metaInfos;

@end

NSString * const iTM2ProjectInfoProjectType = @"project";
NSString * const iTM2ProjectInfoCustomType = @"custom";
NSString * const iTM2ProjectInfoMetaComponent = @"MetaInfo";
NSString * const iTM2ProjectInfoComponent = @"Info";

#import <iTM2Foundation/iTM2RuntimeBrowser.h>

@implementation iTM2ProjectDocument(Infos)
#pragma mark =-=-=-=-=-  INFOS
- (id)mainInfos;
{
	id result = metaGETTER;
	if(!result)
	{
		NSError * outError = nil;
		result = [[[iTM2MainInfoWrapper allocWithZone:[self zone]] initWithProjectURL:[self fileURL] error:&outError] autorelease];
		metaSETTER(result);
	}
	return result;
}
/*	The project infos will store everything about the engines  */
- (id)otherInfos;
{
	id result = metaGETTER;
	if(!result)
	{
		result = [[[iTM2InfoWrapper allocWithZone:[self zone]] init] autorelease];
		metaSETTER(result);
		[IMPLEMENTATION takeMetaValue:nil forKey:@"MutableInfos"];// next time mutableProjectInfos is called, it will make a mutable copy of otherInfos
		NSError * outError;
		NSURL * url = [SPC otherInfoURLFromURL:[self fileURL] create:NO error:&outError];
		if(url)
		{
			id model = [NSDictionary dictionaryWithContentsOfURL:url];
			if(model)
			{
				[result setModel:model];
			}
			else if([url isFileURL] && [DFM fileExistsAtPath:[url path]])
			{
				iTM2_REPORTERROR(1,([NSString stringWithFormat:@"! ERROR while reading the property list at %@", url]),nil);
			}
		}
		else if([self fileURL] && outError)
		{
			iTM2_REPORTERROR(1,@"! ERROR",outError);
		}
	}
	return result;
}
- (id)customInfos;
{
	id result = metaGETTER;
	if(!result)
	{
		result = [[[iTM2InfoWrapper allocWithZone:[self zone]] init] autorelease];
		metaSETTER(result);
		NSError * outError;
		NSURL * url = [SPC customInfoURLFromURL:[self fileURL] create:NO error:&outError];
		if(url)
		{
			id model = [NSDictionary dictionaryWithContentsOfURL:url];
			if(model)
			{
				[result setModel:model];
			}
			else if([url isFileURL] && [DFM fileExistsAtPath:[url path]])
			{
				iTM2_REPORTERROR(1,([NSString stringWithFormat:@"! ERROR while reading the property list at %@", url]),nil);
			}
		}
		else if([self fileURL] && outError)
		{
			iTM2_REPORTERROR(1,@"! ERROR",outError);
		}
	}
	return result;
}
- (id)mutableProjectInfos;
{
	id result = metaGETTER;
	if(!result)
	{
		result = [[[iTM2InfoWrapper allocWithZone:[self zone]] init] autorelease];
		[result setModel:[[self otherInfos] model]];// a mutable deep copy is done
		metaSETTER(result);
	}
	return result;
}
- (id)metaInfos;
{
	id result = metaGETTER;
	if(!result)
	{
		result = [[[iTM2InfoWrapper allocWithZone:[self zone]] init] autorelease];
		metaSETTER(result);
		NSError * outError;
		NSURL * url = [SPC metaInfoURLFromURL:[self fileURL] create:NO error:&outError];
		if(url)
		{
			id model = [NSDictionary dictionaryWithContentsOfURL:url];
			if(model)
			{
				[result setModel:model];
			}
			else if([url isFileURL] && [DFM fileExistsAtPath:[url path]])
			{
				iTM2_REPORTERROR(1,([NSString stringWithFormat:@"! ERROR while reading the property list at %@", url]),nil);
			}
		}
		else if([self fileURL] && outError)
		{
			iTM2_REPORTERROR(1,@"! ERROR:",outError);
		}
	}
	return result;
}
- (id)infosController;
{
	id result = metaGETTER;
	if(!result)
	{
		result = [[[iTM2InfosController allocWithZone:[self zone]] initWithProject:self atomic:NO prefixWithKeyPaths:nil] autorelease];
		metaSETTER(result);
	}
	return result;
}
#pragma mark =-=-=-=-=-  I/O
- (BOOL)infoCompleteWriteToURL:(NSURL *)absoluteURL ofType:(NSString *)fileType error:(NSError **)outErrorPtr;
{
	BOOL result = NO;
	id info = [self mainInfos];
	if([info changeCount])
	{
		[info setInfo:iTM2ProjectInfoMainType forKeyPaths:@"isa",nil];
		NSURL * url;
		if(url = [SPC mainInfoURLFromURL:absoluteURL create:YES error:outErrorPtr])
		{
			[info updateChangeCount:NSChangeCleared];
			if([[info model] writeToURL:url atomically:YES])
			{
				result = YES;
				[info updateChangeCount:NSChangeCleared];
project:
				info = [self otherInfos];
				if([info changeCount])
				{
					[info setInfo:iTM2ProjectInfoProjectType forKeyPaths:@"isa",nil];
					if(url = [SPC otherInfoURLFromURL:absoluteURL create:YES error:outErrorPtr])
					{
						if([[info model] writeToURL:url atomically:YES])
						{
							result = YES;
							[info updateChangeCount:NSChangeCleared];
meta:
							info = [self metaInfos];
							if([info changeCount])
							{
								[info setInfo:iTM2ProjectInfoMetaComponent forKeyPaths:@"isa",nil];
								if(url = [SPC metaInfoURLFromURL:absoluteURL create:YES error:outErrorPtr])
								{
									if([[info model] writeToURL:url atomically:YES])
									{
										[info updateChangeCount:NSChangeCleared];
custom:
										info = [self customInfos];
										if([info changeCount])
										{
											[info setInfo:iTM2ProjectInfoCustomType forKeyPaths:@"isa",nil];
											if(url = [SPC customInfoURLFromURL:absoluteURL create:YES error:outErrorPtr])
											{
												if([[info model] writeToURL:url atomically:YES])
												{
													[info updateChangeCount:NSChangeCleared];
													return YES;
												}
												iTM2_OUTERROR(4,([NSString stringWithFormat:@"Could not write to\n%@",absoluteURL]),nil);
											}
										}
										return result;
									}
									iTM2_OUTERROR(3,([NSString stringWithFormat:@"Could not write to\n%@",absoluteURL]),nil);
								}
							}
							goto custom;
						}
						iTM2_OUTERROR(2,([NSString stringWithFormat:@"Could not write to\n%@",absoluteURL]),nil);
					}
				}
				goto meta;
			}
			 // the atomically flag is ignored if url of a type that cannot be written atomically.
			iTM2_OUTERROR(1,([NSString stringWithFormat:@"Could not write to\n%@",absoluteURL]),nil);
		}
	}
	goto project;
}
- (BOOL)infoCompleteReadFromURL:(NSURL *)absoluteURL ofType:(NSString *)fileType error:(NSError **)outErrorPtr;
{
	[[self implementation] takeMetaValue:nil forKey:@"MainInfos"];
	[[self implementation] takeMetaValue:nil forKey:@"MetaInfos"];
	[[self implementation] takeMetaValue:nil forKey:@"OtherInfos"];
	[[self implementation] takeMetaValue:nil forKey:@"CustomInfos"];
	return YES;
}
#pragma mark =-=-=-=-=-  URL
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setFileURL:
- (void)setFileURL:(NSURL*)url;
/*"Projects are no close documents!!!
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Mar 30 15:52:06 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSURL * old = [self fileURL];
	if(![old isEqual:url])
	{
		// CLEAN the cached data
		[SPC flushCaches];
		// the following lines have no effect
		[IMPLEMENTATION takeMetaValue:nil forKey:iTM2KeyFromSelector(@selector(factoryURL))];
		[IMPLEMENTATION takeMetaValue:nil forKey:iTM2KeyFromSelector(@selector(sourceURL))];
		[IMPLEMENTATION takeMetaValue:nil forKey:iTM2KeyFromSelector(@selector(writableURL))];
	}
    [super setFileURL:url];
    return;
}
@end

@interface iTM2Inspector(Infos)
- (NSString *)infosKeyPathPrefix;
- (id)infosController;
@end

@implementation iTM2Inspector(Infos)
- (NSString *)infosKeyPathPrefix;
{
	return nil;
}
- (id)infosController;// lazy intializer, for the projects, it will break if the inspector changes its project
{
	id result = metaGETTER;
	if(!result)
	{
		iTM2ProjectDocument * PD = [self document];
		if([PD isKindOfClass:[iTM2ProjectDocument class]])
		{
			result = [[[iTM2InfosController allocWithZone:[self zone]] initWithProject:PD atomic:NO prefixWithKeyPaths:[self infosKeyPathPrefix],nil] autorelease];
			metaSETTER(result);
			result = metaGETTER;
		}
	}
	return result;
}
@end

#import <iTM2Foundation/iTM2FileManagerKit.h>

@interface iTM2InfosController(PRIVATE)
- (id)project;
- (void)setProject:(id)project;
- (NSArray *)prefix;
- (id)infoForKeyPath:(NSString *)path prefix:(NSString *)prefix;
@end


@implementation iTM2InfosController
/*  Each project has a unique infos controller, each controller belongs to a unique project.
 *  The project is the owner of the infos controller. */
- (id)project;
{
	return [metaGETTER nonretainedObjectValue];
}
- (void)setProject:(id)project;
{
	metaSETTER([NSValue valueWithNonretainedObject:project]);
	return;
}
/*  The prefix is used to access the model repository.
 *  The repository is in general a big tree,
 *  the model of the receiver may correspond to only a subtree. */
- (NSArray *)prefix;
{
	return metaGETTER;
}
/*  If the receiver is atomic, project infos edition takes place on the real model,
 *  otherwise it takes place in a mutable copy. */
- (BOOL)isAtomic;
{
	return [metaGETTER boolValue];
}
- (id)initWithProject:(id)project atomic:(BOOL)yorn prefixWithKeyPaths:(NSString *)first,...;
{
	if(self = [super init])
	{
		[self setProject:project];
		iTM2_VA_LIST_OF_KEY_PATHS_TO_ARRAY(first,MRA);
		[IMPLEMENTATION takeMetaValue:MRA forKey:iTM2KeyFromSelector(@selector(Prefix))];
		[IMPLEMENTATION takeMetaValue:[NSNumber numberWithBool:yorn] forKey:iTM2KeyFromSelector(@selector(isAtomic))];
	}
	return self;
}
/*  The correct infos object to edit, whether the receiver is atomic or not */
- (id)infos;
{
	return [self isAtomic]? [[self project] mutableProjectInfos]:[[self project] otherInfos];
}
#pragma mark =-=-=-=-=-  GET/SET
/*  Whether the receiver is atomic or not does not make any difference here.
 *  The project information is always returned for the given list of keys is always returned. */
- (id)localInfoForKeys:(NSArray *)keys;
{
	NSMutableArray * Ks = [NSMutableArray arrayWithArray:[self prefix]];
	[Ks addObjectsFromArray:keys];
	return [[[self project] otherInfos] infoForKeys:keys];
}
/*  If the receiver is not atomic, this is exactly [self localInfoForKeys:keys].
 *  Otherwise this is the lastly edited value. */
- (id)editInfoForKeys:(NSArray *)keys;
{
	NSMutableArray * Ks = [NSMutableArray arrayWithArray:[self prefix]];
	[Ks addObjectsFromArray:keys];
	return [[self infos] infoForKeys:keys];
}
/*  The inherited info for the given list of keys.
 *  If the result is a dictionary, it was obtained by merging all the dictionaries of the ancestors. */
- (id)inheritedInfoForKeys:(NSArray *)keys;
{
	id P = [self project];
	NSString * name;
	NSEnumerator * E;
	if([SPC isBaseProject:P])
	{
		name = [P fileName];
		E = [[SPC baseNamesOfAncestorsForBaseProjectName:name] objectEnumerator];
		[E nextObject];// skip the first object: this is (quite) name 
	}
	else
	{
		name = [P baseProjectName];
		E = [[SPC baseNamesOfAncestorsForBaseProjectName:name] objectEnumerator];
	}
	while(name = [E nextObject])
	{
		P = [SPC baseProjectWithName:name];
		id result = [[P otherInfos] infoForKeys:keys];
		/* if result is a dictionary, it should be merged with the dictionaries of other ancestors, if any */
		if([result isKindOfClass:[NSDictionary class]])
		{
			result = [[result mutableCopy] autorelease];
			while(name = [E nextObject])
			{
				P = [SPC baseProjectWithName:name];
				id r = [[P otherInfos] infoForKeys:keys];
				if([r isKindOfClass:[NSDictionary class]])
				{
					[result iTM2_mergeEntriesFromDictionary:r];
				}
				else if(r)
				{
					/* this is not a dictionary, it breaks the ancestor chain */
					return result;
				}
			}
			return result;
		}
		else if(result)
		{
			return result;
		}
	}
	return nil;
}
- (id)infoForKeys:(NSArray *)keys;
{
	NSMutableArray * Ks = [NSMutableArray arrayWithArray:[self prefix]];
	[Ks addObjectsFromArray:keys];
	id result = [[self infos] infoForKeys:Ks];// different behaviour depending on isAtomic.
	if([result isKindOfClass:[NSDictionary class]])
	{
		id inherited = [self inheritedInfoForKeys:Ks];
		if([inherited isKindOfClass:[NSDictionary class]])
		{
			inherited = [[inherited iTM2_deepMutableCopy] autorelease];
			[inherited iTM2_mergeEntriesFromDictionary:result];
			return inherited;
		}
		return result;
	}
	else if([result isEqual:@"\e"])
	{
		/* A nil result means inheritancy,
		 * but we must also code for a really nil result.
		 * For that we asume that by default the values are inherited. */
		return nil;
	}
	else if(result)
	{
		return result;
	}
	else
	{
		return [self inheritedInfoForKeys:Ks];
	}
}
- (BOOL)setInfo:(id)info forKeys:(NSArray *)keys;
{
	NSMutableArray * Ks = [NSMutableArray arrayWithArray:[self prefix]];
	[Ks addObjectsFromArray:keys];
	if([info isEqual:[NSNull null]])
	{
		info = @"\e";
	}
	return [[self infos] setInfo:info forKeys:Ks];
}
- (BOOL)isInfoEditedForKeys:(NSArray *)keys;
{
	NSMutableArray * Ks = [NSMutableArray arrayWithArray:[self prefix]];
	[Ks addObjectsFromArray:keys];
	id lhs, rhs;
	id P = [self project];
	if([self isAtomic])
	{
		lhs = [[P otherInfos] infoForKeys:Ks];
		if(!lhs)
		{
			lhs = [self inheritedInfoForKeys:Ks];
		}
		rhs = [[P mutableProjectInfos] infoForKeys:Ks];
	}
	else
	{
		lhs = [self inheritedInfoForKeys:Ks];
		rhs = [[P otherInfos] infoForKeys:Ks];
	}
	return ![lhs isEqual:rhs] || (rhs != lhs);
}
#pragma mark =-=-=-=-=-  CUSTOM
/*  The purpose of the custom info is to keep track of what is edited.
 *  Typically, one can edit the values in some panel but does not want to save the changes.
 *  When he reopens the same panel, he would be happy to recover the previously edited values. */
- (id)customInfoForKeys:(NSArray *)keys;
{
	NSMutableArray * Ks = [NSMutableArray arrayWithArray:[self prefix]];
	[Ks addObjectsFromArray:keys];
	return [[[self project] customInfos] infoForKeys:keys];
}
/*  Backup the edited info.
 *  The user has started to edit the information but the change is not yet registered.
 *  We keep that information in case the user wants to continue edition. */
- (BOOL)backupCustomForKeys:(NSArray *)keys;
{
	NSMutableArray * Ks = [NSMutableArray arrayWithArray:[self prefix]];
	[Ks addObjectsFromArray:keys];
	id edit = [[self infos] editInfoForKeys:Ks];
	return [[[self project] customInfos] setInfo:edit forKeys:Ks];
}
/*  The user want to continue edition.
 *  We start from the last value edited. */
- (BOOL)restoreCustomForKeys:(NSArray *)keys;
{
	NSMutableArray * Ks = [NSMutableArray arrayWithArray:[self prefix]];
	[Ks addObjectsFromArray:keys];
	id custom = [[[self project] customInfos] infoForKeys:Ks];
	if(custom)
	{
		[[self infos] setInfo:custom forKeys:Ks];
		return YES;
	}
	return NO;
}
/*  When the info is edited, one must register the changes.
 *  This is particularly necessary when the receiver is atomic because
 *  edition takes place in a mutable repository. */
#pragma mark =-=-=-=-=-  EDIT
- (BOOL)saveChangesForKeys:(NSArray *)keys;
{
	if(![self isAtomic])
	{
		return YES;// nothing to save because everything was edited in place
	}
	NSMutableArray * Ks = [NSMutableArray arrayWithArray:[self prefix]];
	[Ks addObjectsFromArray:keys];
	[self backupCustomForKeys:Ks];
	id P = [self project];
	id edit = [[P mutableProjectInfos] infoForKeys:Ks];
	return [[P otherInfos] setInfo:edit forKeys:Ks];
}
/*  If the user has made some changes, but do not want to use them anymore,
 *  He can revert to the original value.
 *  The result is YES if the revert operation was successful, NO otherwise. */
- (BOOL)revertChangesForKeys:(NSArray *)keys;
{
	if(![self isAtomic])
	{
		return YES;// nothing to revert because everything was edited in place
	}
	NSMutableArray * Ks = [NSMutableArray arrayWithArray:[self prefix]];
	[Ks addObjectsFromArray:keys];
	[self backupCustomForKeys:Ks];// not really well designed, why?
	id P = [self project];
	id edit = [[P otherInfos] infoForKeys:Ks];
	return [[P mutableProjectInfos] setInfo:edit forKeys:Ks];
}

@end

@implementation NSObject(Infos)
- (id)infosController;// lazy intializer, for the projects
{
	id result = metaGETTER;
	return result;
}
- (void)setInfosController:(id)controller;
{
	metaSETTER(controller);
	return;
}
- (id)metaInfos;
{
	NSAssert(NO,@"! ERROR: Unsupported metaInfos, report bug");
	return nil;
}
- (id)metaInfoForKeyPaths:(NSString *)first,...;
{
	iTM2_VA_LIST_OF_KEY_PATHS_TO_ARRAY(first,keys);
	return [[self metaInfos] infoForKeys:keys];
}
- (BOOL)setMetaInfo:(id)info forKeyPaths:(NSString *)first,...;
{
	iTM2_VA_LIST_OF_KEY_PATHS_TO_ARRAY(first,keys);
	return [[self metaInfos] setInfo:info forKeys:keys];
}
- (id)infoForKeyPaths:(NSString *)first,...;
{
	iTM2_VA_LIST_OF_KEY_PATHS_TO_ARRAY(first,keys);
	return [[self infosController] infoForKeys:keys];
}
- (BOOL)setInfo:(id)info forKeyPaths:(NSString *)first,...;
{
	iTM2_VA_LIST_OF_KEY_PATHS_TO_ARRAY(first,keys);
	return [[self infosController] setInfo:info forKeys:keys];
}
- (BOOL)isInfoEditedForKeyPaths:(NSString *)first,...;
{
	iTM2_VA_LIST_OF_KEY_PATHS_TO_ARRAY(first,keys);
	return [[self infosController] isInfoEditedForKeys:keys];
}
- (id)inheritedInfoForKeyPaths:(NSString *)first,...;
{
	iTM2_VA_LIST_OF_KEY_PATHS_TO_ARRAY(first,keys);
	return [[self infosController] inheritedInfoForKeys:keys];
}
- (id)localInfoForKeyPaths:(NSString *)first,...;
{
	iTM2_VA_LIST_OF_KEY_PATHS_TO_ARRAY(first,keys);
	return [[self infosController] localInfoForKeys:keys];
}
- (id)customInfoForKeyPaths:(NSString *)first,...;
{
	iTM2_VA_LIST_OF_KEY_PATHS_TO_ARRAY(first,keys);
	return [[self infosController] customInfoForKeys:keys];
}
- (id)editInfoForKeyPaths:(NSString *)first,...;
{
	iTM2_VA_LIST_OF_KEY_PATHS_TO_ARRAY(first,keys);
	return [[self infosController] editInfoForKeys:keys];
}
- (BOOL)toggleInfoForKeyPaths:(NSString *)first,...;
{
	iTM2_VA_LIST_OF_KEY_PATHS_TO_ARRAY(first,keys);
	BOOL old = [[[self infosController] infoForKeys:keys] boolValue];
	return [[self infosController] setInfo:[NSNumber numberWithBool:!old] forKeys:keys];
}
- (BOOL)backupCustomForKeyPaths:(NSString *)first,...;
{
	iTM2_VA_LIST_OF_KEY_PATHS_TO_ARRAY(first,keys);
	return [[self infosController] backupCustomForKeys:keys];
}
- (BOOL)restoreCustomForKeyPaths:(NSString *)first,...;
{
	iTM2_VA_LIST_OF_KEY_PATHS_TO_ARRAY(first,keys);
	return [[self infosController] restoreCustomForKeys:keys];
}
- (BOOL)saveChangesForKeyPaths:(NSString *)first,...;
{
	iTM2_VA_LIST_OF_KEY_PATHS_TO_ARRAY(first,keys);
	return [[self infosController] saveChangesForKeys:keys];
}
- (BOOL)revertChangesForKeyPaths:(NSString *)first,...;
{
	iTM2_VA_LIST_OF_KEY_PATHS_TO_ARRAY(first,keys);
	return [[self infosController] revertChangesForKeys:keys];
}
@end
