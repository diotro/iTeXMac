/*
//
//  @version Subversion: $Id: iTM2InfoWrapperKit.m 574 2007-10-08 23:21:41Z jlaurens $ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Tue Jan  4 07:48:24 GMT 2005.
//  Copyright © 2005-2010 Laurens'Tribune. All rights reserved.
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

#import "iTM2Runtime.h"
#import "iTM2FileManagerKit.h"
#import "iTM2ProjectControllerKit.h"
#import "iTM2Implementation.h"
#import "iTM2ContextKit.h"
#import "iTM2PathUtilities.h"
#import <objc/objc.h>
#import "iTM2InfoWrapperKit.h"

NSString * const TWSProjectKey = @"project";
NSString * const TWSContentsKey = @"contents";
NSString * const TWSFactoryKey = @"factory";
NSString * const TWSDotKey = @".";
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
- (id)deepMutableCopy4iTM3;
@end

@implementation NSObject(iTM2InfoWrapper)
- (id)deepMutableCopy4iTM3;
{
	NSString * errorString = nil;
	id data = [NSPropertyListSerialization dataFromPropertyList:self format:NSPropertyListBinaryFormat_v1_0 errorDescription:&errorString];
	if (data) {
		id result = [[NSPropertyListSerialization propertyListFromData:data
			mutabilityOption: NSPropertyListMutableContainersAndLeaves
				format: nil errorDescription: &errorString] retain];
		if (result) {
			return result;
		} else if (errorString) {
			LOG4iTM3(@"! ERROR 2 while deep copying the model, internal inconsistency!");
			[errorString release];
		}
		LOG4iTM3(@"! ERROR: No deep copy of the model");
	} else if (errorString) {
		LOG4iTM3(@"! ERROR 1 while deep copying the model, bad entry: %@",self);
		[errorString release];
	}
	return [self respondsToSelector:@selector(mutableCopy)]?[self mutableCopy]:[self retain];
}
@end

@interface NSMutableDictionary(iTM2InfoWrapper)
- (void)mergeEntriesFromDictionary4iTM3:(NSDictionary *)otherDictionary;
@end

@implementation NSMutableDictionary(iTM2InfoWrapper)
- (void)mergeEntriesFromDictionary4iTM3:(NSDictionary *)otherDictionary;
{
	
	NSEnumerator * E = self.keyEnumerator;
	NSString * K;
	while((K = E.nextObject))
	{
		if ([[self objectForKey:K] isEqual:@"Base"])// no more base due to the correct management of inheritancy
		{
			[self removeObjectForKey:@"Base"];
		}
	}
	E = otherDictionary.keyEnumerator;
	while((K = E.nextObject))
	{
		id left = [self objectForKey:K];
		id right = [otherDictionary objectForKey:K];
		if ([left isKindOfClass:[NSDictionary class]] && [right isKindOfClass:[NSDictionary class]])
		{
			[left mergeEntriesFromDictionary4iTM3:right];
		}
		else if (![right isEqual:@"Base"])
		{
			[self setObject:right forKey:K];
		}
	}
}
@end

@interface iTM2InfoWrapper()
/*!
	@method			model
	@abstract		The model of the receiver.
	@discussion		The model is retrieved from the repository, with the given repositoryKeyPath.
	@param			None
	@result			a mutable property list dictionary.
	@availability	iTM2.1
	@copyright		2008 jlaurens AT users DOT sourceforge DOT net and others.
*/
@property (readwrite,retain) NSMutableDictionary * model;

- (void)setData:(NSData *)aData error:(NSError **)RORef;

/*!
	@method			changeCount
	@abstract		Abstract forthcoming.
	@discussion		Description forthcoming.
	@param			None
	@result			The number of changes made since the last save or so.
	@availability	iTM2.1
	@copyright		2008 jlaurens AT users DOT sourceforge DOT net and others.
*/
@property (readwrite) NSInteger changeCount;

@property (readwrite,copy) NSString * modelKeyPath;

@end

@interface NSString (iTM2InfoWrapper)
- (NSArray *)keyPathComponents4iTM3;
@end

@implementation NSString (iTM2InfoWrapper)
- (NSArray *)keyPathComponents4iTM3;
{
    return [self isEqualToString:TWSDotKey]?
        [NSArray arrayWithObject:self]:
        [self componentsSeparatedByString:TWSDotKey];
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
	if ((self = [super init])) {
		self.model = [NSDictionary dictionary];
	}
	return self;
}
- (id)initWithData:(NSData *)aData error:(NSError **)RORef;
{
	if ((self = [super init])) {
		[self setData:aData error:RORef];
	} else if (RORef) {
        OUTERROR4iTM3(1,([NSString stringWithFormat:@"Problem creating the main infos wrapper"]),nil);
    } else {
        LOG4iTM3(@"! ERROR: Problem creating the main infos wrapper");
    }
	return self;
}
#pragma mark =-=-=-=-=-  LOCAL MODEL
- (void)setModel:(id)model;
{
	// make a mutable deep copy.
	// the local model needs to be mutable in order to make updates easily.
	// However, the receiver should be the only one to know that it -is- mutable...
	// and everyone else should simply ignore this fact.
	if (!model) {
		// reset the model
		model4iTM3 = [NSMutableDictionary dictionary];
		return;
	}
	// if this can't be done, it is not a valid property list
	// the programmer should be responsible of what he is doing but there is no safety guard here
	// get a data object
	NSString * errorString = nil;
	NSData * data = [NSPropertyListSerialization dataFromPropertyList:model format:NSPropertyListBinaryFormat_v1_0 errorDescription:&errorString];
	if (data) {
		// the model is a valid property list
		if ((model = [NSPropertyListSerialization propertyListFromData:data
			mutabilityOption: NSPropertyListMutableContainersAndLeaves
				format: nil errorDescription: &errorString])) {
			// this is a mean to retrieve a completely mutable model
			model4iTM3 = model;
			return;
		} else if (errorString) {
			LOG4iTM3(@"! ERROR 2 while deep copying the model, internal inconsistency!");
			[errorString release];
		}
		LOG4iTM3(@"! ERROR: No deep copy of the model");
	} else if (errorString) {
		LOG4iTM3(@"! ERROR 1 while deep copying the model, bad entry: %@",model);
		[errorString release];
	}
	model4iTM3 = [model mutableCopy];
	return;
}
- (NSData *) dataWithFormat:(NSPropertyListFormat)format options:(NSPropertyListWriteOptions)opt error:(NSError **)RORef;
{
    return [NSPropertyListSerialization dataWithPropertyList:self.model format:format options:opt error:RORef];
}
- (void)setData:(NSData *)aData error:(NSError **)RORef;
{
	if (aData.length) {
		// the model is a valid property list
        id model = nil;
		if ((model = [NSPropertyListSerialization propertyListWithData:aData
			options:NSPropertyListMutableContainersAndLeaves
				format:nil error:RORef])) {
			if ([model isKindOfClass:[NSDictionary class]]) {
                model4iTM3 = model;
            } else {
                OUTERROR4iTM3(1,(@"! The model must be a dictionary."),nil);
            }
			return;
		}
	} else {
        model4iTM3 = [NSMutableDictionary dictionary];
        return;
	}
    return;
}
@synthesize model = model4iTM3;
@synthesize modelKeyPath = modelKeyPath4iTM3;
@synthesize changeCount = changeCount4iTM3;
- (void)updateChangeCount:(NSDocumentChangeType)change;
{
	switch (change) {
		case  NSChangeDone: ++self.changeCount;return;
		case  NSChangeUndone: --self.changeCount;return;
		case  NSChangeCleared:
		default: self.changeCount = ZER0;return;
	}
}
- (id)infoForKeys:(NSArray *)keys;
{
	NSParameterAssert(keys.count);
	NSDictionary * model = self.model;
	id result = model;
	for (NSString * K in keys) {
        if (K.length) {
            //  We are not sure that model is a dictionary,
            //  except the very first time we enter the loop
            if ([result isKindOfClass:[NSDictionary class]]) {
                model = result;
                result = [model objectForKey:K];
                continue;
            } else {
                return nil;
            }
        }
	}
	return result;
}
//  This macro turns a non void variable argument list of objects into an array.
//  FIRST is the argument name that appears in the function header before the ",..."
//  MRA is the name of the resulting array, it will be created
#   define VA_LIST_OF_KEY_PATHS_TO_ARRAY4iTM3(FIRST,MRA)\
	NSMutableArray * MRA = [NSMutableArray array];\
	if (FIRST) {\
		[MRA addObjectsFromArray:[FIRST keyPathComponents4iTM3]];\
		va_list list;\
		va_start(list,FIRST);\
		NSString * S;\
		while((S = va_arg (list, id))) {\
			[MRA addObjectsFromArray:[S keyPathComponents4iTM3]];\
		}\
		va_end(list);\
	}

- (id)infoForKeyPaths:(NSString *)first,...;
{
	VA_LIST_OF_KEY_PATHS_TO_ARRAY4iTM3(first,keys);
	return [self infoForKeys:keys];
}
- (NSString *)stringForKeyPaths:(NSString *)first,...;
{
	VA_LIST_OF_KEY_PATHS_TO_ARRAY4iTM3(first,keys);
	NSString * S = [self infoForKeys:keys];
    if (![S isKindOfClass:[NSString class]]) {
        S = @"";
        [self setInfo:S forKeys:keys];
    }
    return S;
}
- (NSMutableDictionary *)mutableDictionaryForKeyPaths:(NSString *)first,...;
{
	VA_LIST_OF_KEY_PATHS_TO_ARRAY4iTM3(first,keys);
	NSMutableDictionary * MD = [self infoForKeys:keys];
    if (![MD isKindOfClass:[NSMutableDictionary class]]) {
        MD = [NSMutableDictionary dictionary];
        [self setInfo:MD forKeys:keys];
    }
    return MD;
}
- (BOOL)setInfo:(id)info forKeys:(NSArray *)keys;
{
	NSParameterAssert(keys.count);
	NSMutableDictionary * model = self.model;
	NSUInteger index = keys.count;
	NSEnumerator * E = [keys reverseObjectEnumerator];
	// we must treat the last key differently
	NSString * lastK = nil;
	while((lastK = E.nextObject) && !lastK.length)
	{
		--index;
	}
	NSString * K;
	E = keys.objectEnumerator;
    NSMutableDictionary * D = nil;
	if (info)
	{
		while(--index)
		{
			// for all the intermediate keys
			K = E.nextObject;
			if (K.length)
			{
				// create the intermediate dictionary object if necessary
				D = [model objectForKey:K];
				if (![D isKindOfClass:[NSDictionary class]])
				{
					D = [NSMutableDictionary dictionary];
					[model setObject:D forKey:K];
				}
				model = D;
			}
		}
		if (![info isEqual:[model objectForKey:lastK]])
		{
			[model setObject:info forKey:lastK];
			[self updateChangeCount:NSChangeDone];
			return YES;
		}
		return NO;
	} else {
		while (--index) {
			K = E.nextObject;
			if (K.length) {
				D = [model objectForKey:K];
				if (!D)
				{
					return NO;
				}
				else if (![D isKindOfClass:[NSDictionary class]])
				{
					[model removeObjectForKey:K];
					return NO;
				}
				model = D;
			}
		}
		if ([model objectForKey:lastK])
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
	VA_LIST_OF_KEY_PATHS_TO_ARRAY4iTM3(first,keys);
	return [self setInfo:info forKeys:keys];
}
const char * iTM2InfoWrapper_set_prefix = "setInfo:forPaths:";
const char * iTM2InfoWrapper_get_prefix = "infoForPaths:";
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
	// another convenient setter/getter pair, for example
	// id info = [self infoForPaths:components1:components2:components3:componentsN];
	// if ([self setInfo:info forPaths:components1:components2:components3:componentsN]) {...
	// where components is a dot separated list of path components
	// with the usual restrictions
	// Those path components are used as dictionary keys
	const char * sel_name = sel_getName(aSelector);
	// if sel_name matches /infoForPaths(:+)/ or /setInfo:forPaths(:+)/
	// the 
	size_t size = 4;//"c@:@" for the setter or "@@:@" for the getter
	char * signature = NULL;
	if (ZER0 == strncmp(sel_name,iTM2InfoWrapper_set_prefix,strlen(iTM2InfoWrapper_set_prefix)))
	{
		sel_name += strlen(iTM2InfoWrapper_set_prefix);
		while(*sel_name == ':')// each time a new ':' appears, a new object argument is required
		{
			++sel_name;
			++size;
		}
		if ((*sel_name == '\0')&&(signature = NSAllocateCollectable(size+1,ZER0)))// + termination
		{
			memset(signature+1,'@',size-1);
			signature[ZER0]='c';
finish:
			signature[size]='\0';
			signature[2]=':';
			id result = [NSMethodSignature signatureWithObjCTypes:signature];
			return result;
		}
	}
	else if (ZER0 == strncmp(sel_name,iTM2InfoWrapper_get_prefix,strlen(iTM2InfoWrapper_get_prefix)))
	{
		sel_name += strlen(iTM2InfoWrapper_get_prefix);
		while(*sel_name == ':')
		{
			++sel_name;
			++size;
		}
		if ((*sel_name == '\0')&&(signature = NSAllocateCollectable(size+1,ZER0)))
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
	const char * name = sel_getName([anInvocation selector]);
	NSUInteger index = 2;
	NSMutableArray * Ks = [NSMutableArray array];
	NSString * K;
	id O;
	if (!strncmp(name,iTM2InfoWrapper_get_prefix,strlen(iTM2InfoWrapper_get_prefix)))
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
			[Ks addObjectsFromArray:[K componentsSeparatedByString:TWSDotKey]];
		} while(++index<=strlen(name)-strlen(iTM2InfoWrapper_get_prefix)+2);
		O = [self infoForKeys:Ks];
		[anInvocation setReturnValue:&O];
		return;
	}
	else if (!strncmp(name,iTM2InfoWrapper_set_prefix,strlen(iTM2InfoWrapper_set_prefix)))
	{
		[anInvocation getArgument:&O atIndex:index];
		++index;
		// Like before
		// The total number of arguments is exactly strlen(name)-strlen(iTM2InfoWrapper_set_prefix)+1
		// index runs from 3 to strlen(name)-strlen(iTM2InfoWrapper_get_prefix)+3, included
		do {
			[anInvocation getArgument:&K atIndex:index];
			[Ks addObjectsFromArray:[K componentsSeparatedByString:TWSDotKey]];
		} while(++index<=strlen(name)-strlen(iTM2InfoWrapper_set_prefix)+3);
		BOOL result = [self setInfo:O forKeys:Ks];
		[anInvocation setReturnValue:&result];
		return;
	}
	[super forwardInvocation:anInvocation];
}
@end

@interface iTM2MainInfoWrapper()
@property (readwrite,retain) NSURL * projectURL;
@end

NSString * const iTM2ProjectInfoProjectType = @"project";
NSString * const iTM2ProjectInfoCustomType = @"custom";
NSString * const iTM2ProjectInfoMetaComponent = @"MetaInfo";
NSString * const iTM2ProjectInfoComponent = @"Info";
NSString * const iTM2ProjectCustomInfoComponent = @"CustomInfo";
NSString * const iTM2ProjectPlistPathExtension = @"plist";

@implementation NSURL(iTM2InfoWrapper)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  mainInfoURL4iTM3WithCreate:error:
- (NSURL *)mainInfoURL4iTM3WithCreate:(BOOL)yorn error:(NSError **)RORef;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Thu Jan 28 22:03:17 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (self.isFileURL) {
		NSString * path = self.path;
		if (yorn) {
			[DFM createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:RORef];
		}
		NSString * component = [iTM2ProjectInfoComponent stringByAppendingPathExtension:iTM2ProjectPlistPathExtension];
		return [NSURL URLWithPath4iTM3:component relativeToURL:self];
	} else {
		OUTERROR4iTM3(1,([NSString stringWithFormat:@"File URL expected, instead of\n%@",self]),nil);
	}
//END4iTM3;
    return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  otherInfoURL4iTM3WithCreate:error:
- (NSURL *)otherInfoURL4iTM3WithCreate:(BOOL)yorn error:(NSError **)RORef;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Thu Jan 28 22:06:35 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (self.isFileURL) {
		NSString * fileName = self.path;
		NSString * path = [[NSBundle mainBundle] bundleIdentifier];
		path = [TWSFrontendComponent stringByAppendingPathComponent:path];
		path = [fileName stringByAppendingPathComponent:path];
		if (yorn) {
			[DFM createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:RORef];
		}
		NSString * component = [iTM2ProjectInfoComponent stringByAppendingPathExtension:iTM2ProjectPlistPathExtension];
		path = [path stringByAppendingPathComponent:component];
		return [NSURL URLWithPath4iTM3:path relativeToURL:self];
	} else {
		OUTERROR4iTM3(1,([NSString stringWithFormat:@"File URL expected, instead of\n%@",self]),nil);
	}
//END4iTM3;
    return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  metaInfoURL4iTM3WithCreate:error:
- (NSURL *)metaInfoURL4iTM3WithCreate:(BOOL)yorn error:(NSError **)RORef;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Thu Jan 28 22:06:23 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (self.isFileURL) {
		NSString * fileName = self.path;
		NSString * path = [[NSBundle mainBundle] bundleIdentifier];
		path = [TWSFrontendComponent stringByAppendingPathComponent:path];
		path = [fileName stringByAppendingPathComponent:path];
		if (yorn) {
			[DFM createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:RORef];
		}
		NSString * component = [iTM2ProjectInfoMetaComponent stringByAppendingPathExtension:iTM2ProjectPlistPathExtension];
		path = [path stringByAppendingPathComponent:component];
		return [NSURL URLWithPath4iTM3:path relativeToURL:self];
	} else {
		OUTERROR4iTM3(1,([NSString stringWithFormat:@"File URL expected, instead of\n%@",self]),nil);
	}
//END4iTM3;
    return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  customInfoURL4iTM3WithCreate:error:
- (NSURL *)customInfoURL4iTM3WithCreate:(BOOL)yorn error:(NSError **)RORef;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Thu Jan 28 22:07:11 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (self.isFileURL) {
		NSString * fileName = self.path;
		NSString * path = [[NSBundle mainBundle] bundleIdentifier];
		path = [TWSFrontendComponent stringByAppendingPathComponent:path];
		path = [fileName stringByAppendingPathComponent:path];
		if (yorn) {
			[DFM createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:RORef];
		}
		NSString * component = [iTM2ProjectCustomInfoComponent stringByAppendingPathExtension:iTM2ProjectPlistPathExtension];
		path = [path stringByAppendingPathComponent:component];
		return [NSURL URLWithPath4iTM3:path relativeToURL:self];
	} else {
		OUTERROR4iTM3(1,([NSString stringWithFormat:@"File URL expected, instead of\n%@",self]),nil);
	}
//END4iTM3;
    return nil;
}
@end

@implementation iTM2MainInfoWrapper
- (id)initWithProjectURL:(NSURL *)projectURL error:(NSError **)RORef;
{
	if ((self = [super init])) {
		[self replaceProjectURL:projectURL error:RORef];
	} else if (RORef) {
        OUTERROR4iTM3(1,([NSString stringWithFormat:@"Problem creating the main infos wrapper at URL:\n%@",projectURL]),nil);
    } else {
        LOG4iTM3(@"! ERROR: Problem creating the main infos wrapper at URL:\n%@",projectURL);
    }
	return self;
}
@synthesize projectURL = projectURL4iTM3;
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  replaceProjectURL:error:
- (void)replaceProjectURL:(NSURL *)projectURL error:(NSError **)RORef;
/*"The given projectURL must be non nil and must be the URL of a directory.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.1: Sat May  3 16:25:55 UTC 2008
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    //  The projectURL must end with a trailing /
	NSParameterAssert(projectURL);
	self.projectURL = projectURL;
	NSURL * url = [projectURL mainInfoURL4iTM3WithCreate:NO error:RORef];
	if (url) {
		id model = [NSDictionary dictionaryWithContentsOfURL:url];
		if (model) {
			self.model = model;
		} else if (url.isFileURL && [DFM fileExistsAtPath:url.path]) {
			OUTERROR4iTM3(1,([NSString stringWithFormat:@"! ERROR while reading the property list at %@", url]),nil);
		}
	}
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  fileKeys
- (NSArray *)fileKeys;
/*"All the file keys known by the receiver, except the reserved keys.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.1: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSMutableDictionary * info = [self mutableDictionaryForKeyPaths:TWSKeyedFilesKey,nil];
    NSMutableArray * result = [NSMutableArray array];
    for (NSString * K in info.keyEnumerator) {
        if (![SPC isReservedFileKey:K]) {
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (!key.length) {
		return nil;
	}
	NSString * result = [self stringForKeyPaths:TWSKeyedFilesKey,key,nil];
	if ([key isEqual:TWSContentsKey] && !result.length) {
		// default value
		result = @"";
	}
	if ([key isEqual:TWSFactoryKey] && !result.length) {
		// default value
		result = iTM2PathFactoryComponent;
	}
//END4iTM3;
	return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  namesForFileKeys:
- (NSArray *)namesForFileKeys:(NSArray *)keys;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 17 13:29:51 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSMutableSet * result = [NSMutableSet set];
	for (NSString * key in keys) {
		NSString * name = [self nameForFileKey:key];
		if (name.length) {
			[result addObject:name];
		}
	}
//END4iTM3;
    return result.allObjects;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  fileKeyForName:
- (NSString *)fileKeyForName:(NSString *)name;
/*"Description forthcoming. Return value cannot be a reserved key.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.1: Fri May  2 10:33:41 UTC 2008
To Do List:
"*/
{DIAGNOSTIC4iTM3;
    NSString * key = nil;
	for (key in self.fileKeys) {
		if ([name pathIsEqual4iTM3:[self nameForFileKey:key]]) {
			return key;
		}
	}
	for (key in [SPC reservedFileKeys]) {
		if ([name pathIsEqual4iTM3:[self nameForFileKey:key]]) {
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (!key.length) {
		return NO;
	}
	NSString * 	old = [self nameForFileKey:key];
	if (![old pathIsEqual4iTM3:name]) {
		return [self setInfo:name forKeyPaths:TWSKeyedFilesKey,key,nil];
	}
	return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  URLForFileKey:error:
- (NSURL *)URLForFileKey:(NSString *)key error:(NSError **)RORef;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.1: Tue May  6 14:25:43 UTC 2008
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSURL * projectURL = self.projectURL;
	if ([key isEqual:TWSProjectKey]) {
		return projectURL;
	}
	NSString * name = nil;
	NSURL * url = nil;
	id PD = [SPC projectForURL:projectURL error:RORef];
	if ([key isEqual:iTM2ParentKey]) {
		if ((url = [PD parentURL])) return url;
		return [NSURL URLWithString:@".." relativeToURL:[projectURL URLByRemovingFactoryBaseURL4iTM3]];
	} else if ([key isEqual:TWSContentsKey]) {
		if ((url = [PD contentsURL])) {
            return url;
        } else {
            name = [self nameForFileKey:key];
            url = [self URLForFileKey:iTM2ParentKey error:RORef];
            return name.length?[NSURL URLWithPath4iTM3:name relativeToURL:url]:url;
        }
	} else if ([key isEqual:TWSFactoryKey]) {
		if ((url = [PD factoryURL])) return url;
		name = [self nameForFileKey:key];
		return name.length?[NSURL URLWithPath4iTM3:name relativeToURL:projectURL]:projectURL;// we should always have name.length>ZER0
	} else if ([SPC isReservedFileKey:key]) {
		return nil;
	} else if (key.length) {
		name = [self nameForFileKey:key];
		url = [NSURL URLWithString:name];
		if (url.scheme.length) {
			return url;
		} else if ([name.pathExtension pathIsEqual4iTM3:TWSFactoryExtension]) {
			name = name.stringByDeletingPathExtension;
			url = [self URLForFileKey:TWSFactoryKey error:RORef];
			return [NSURL URLWithPath4iTM3:name relativeToURL:url];
		} else {
            url = [self URLForFileKey:TWSContentsKey error:RORef];
            return [NSURL URLWithPath4iTM3:name relativeToURL:url];
        }
	}
//END4iTM3;
    return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  URLsForFileKeys:error:
- (NSArray *)URLsForFileKeys:(NSArray *)keys error:(NSError **)RORef;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 17 13:35:57 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSMutableSet * result = [NSMutableSet set];
	for (NSString * key in keys) {
		NSURL * URL = [self URLForFileKey:key error:RORef];
		if (URL) {
			[result addObject:URL];
		}
	}
//END4iTM3;
    return result.allObjects;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  fileKeyForURL:error:
- (NSString *)fileKeyForURL:(NSURL *)url error:(NSError **)RORef;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.1: Sat May  3 09:41:58 UTC 2008
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSString * K = nil;
	for (K in self.fileKeys) {
		if ([[self URLForFileKey:K error:RORef] isEquivalentToURL4iTM3:url]) return K;
	}
	NSURL * projectURL = self.projectURL;
	if ([projectURL isEquivalentToURL4iTM3:url]) return TWSProjectKey;
	// next keys might correspond to cached URLs
	iTM2ProjectDocument * PD = [SPC projectForURL:projectURL error:RORef];
	if (PD) {
		if ([PD.contentsURL isEquivalentToURL4iTM3:url]) return TWSContentsKey;
		if ([PD.factoryURL isEquivalentToURL4iTM3:url])  return TWSFactoryKey;
		if ([PD.parentURL isEquivalentToURL4iTM3:url])   return iTM2ParentKey;
	} else {
#       define TEST [[SPC URLForFileKey:K filter:iTM2PCFilterRegular inProjectWithURL:projectURL error:RORef] isEquivalentToURL4iTM3:url]
		K = TWSContentsKey;if (TEST) return K;
		K = TWSFactoryKey; if (TEST) return K;
		K = iTM2ParentKey; if (TEST) return K;
#       undef TEST
	}
//END4iTM3;
    return @"";
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setURL:forFileKey:error:
- (NSURL *)setURL:(NSURL *)fileURL forFileKey:(NSString *)key error:(NSError **)RORef;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 17 20:00:17 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSURL * projectURL = self.projectURL;
	if ([key isEqual:TWSProjectKey]) {
		// Nonsense
		return projectURL;
	}
	NSURL * theURL = nil;
	NSString * relative = nil;
	if ([key isEqual:TWSContentsKey]) {
		// if the given URL is absolute, the contents must be relative to the parent directory of the project
		if (fileURL.baseURL) {
			theURL = [SPC URLForFileKey:iTM2ParentKey filter:iTM2PCFilterRegular inProjectWithURL:projectURL error:RORef];
			relative = [fileURL pathRelativeToURL4iTM3:theURL];
		} else {
			relative = [fileURL relativePath];
		}
		if ([relative hasPrefix:@".."]) {
			return nil;
		}
		[self setName:relative forFileKey:key];
		if ((theURL = [self URLForFileKey:key error:RORef])) {
            return [theURL isEquivalentToURL4iTM3:fileURL]?fileURL:theURL;
        }
        return nil;
	}
	if ([key isEqual:TWSFactoryKey]) {
		if ([fileURL baseURL]) {
			theURL = [projectURL URLByPrependingFactoryBaseURL4iTM3];
			relative = [fileURL pathRelativeToURL4iTM3:theURL];
		} else {
			relative = [fileURL relativePath];
		}
		if ([relative hasPrefix:@".."] || !relative.length) {
			return nil;
		}
		[self setName:relative forFileKey:key];
		if ((theURL = [self URLForFileKey:key error:RORef])) {
            return [theURL isEquivalentToURL4iTM3:fileURL]?fileURL:theURL;
        }
        return nil;
	}
	if ([SPC isReservedFileKey:key]) {
		// we can't change the URL's of the reserved keys
		return nil;
	}
	theURL = [SPC URLForFileKey:TWSFactoryKey filter:iTM2PCFilterRegular inProjectWithURL:projectURL error:RORef];
	if ([fileURL isRelativeToURL4iTM3:theURL]) {
		// When cached, all the file names are recorded relative to the Factory directory
		relative = [[fileURL pathRelativeToURL4iTM3:theURL] stringByAppendingPathExtension:TWSFactoryExtension];
		if (relative.length && ![relative hasPrefix:@".."])
		{
			goto relativeFound;
		}
	}
	theURL = [SPC URLForFileKey:TWSContentsKey filter:iTM2PCFilterRegular inProjectWithURL:projectURL error:RORef];
	if ([fileURL isRelativeToURL4iTM3:theURL]) {
		// the project is cached, it means that it could not be written in the correct location, write rights missing
		relative = [fileURL pathRelativeToURL4iTM3:theURL];
		if (relative.length && ![relative hasPrefix:@".."]) {
			goto relativeFound;
		}
	}
	relative = fileURL.standardizedURL.absoluteString;
relativeFound:
	[self setName:relative forFileKey:key];
	if ((theURL = [self URLForFileKey:key error:RORef])) {
        return [theURL isEquivalentToURL4iTM3:fileURL]?fileURL:theURL;
    }
    return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  propertiesForFileKey
- (id)propertiesForFileKey:(NSString *)key;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.1: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSParameterAssert(key!=nil);
    return [self mutableDictionaryForKeyPaths:TWSKeyedPropertiesKey,key,nil];
}
- (BOOL)setProperties:(id)properties forFileKey:(NSString *)key;
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return [self setInfo:[properties mutableCopy] forKeyPaths:TWSKeyedPropertiesKey,key,nil];
}
- (id)propertyValueForKey:(NSString *)key fileKey:(NSString *)fileKey;
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return [self info4iTM3ForKeyPaths:TWSKeyedPropertiesKey,fileKey,key,nil];
}
- (BOOL)setPropertyValue:(id)property forKey:(NSString *)key fileKey:(NSString *)fileKey;
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return [self setInfo:property forKeyPaths:TWSKeyedPropertiesKey,fileKey,key,nil];
}
@end

@interface NSObject(Infos_Private)

/*! 
    @method			metaInfos4iTM3
    @abstract		The meta infos.
    @discussion		The default implementation raises an exception. Subclassers must provide the model.
    @param			None
    @result			an iTM2InfoWrapper instance
	@availability	iTM2.
	@copyright		2007 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (id)metaInfos4iTM3;

@end


@implementation iTM2ProjectDocument(Infos)
#pragma mark =-=-=-=-=-  INFOS
- (id)mainInfos4iTM3;
{
	id result = metaGETTER;
	if (!result) {
		NSError * outError = nil;
		result = [[[iTM2MainInfoWrapper alloc] initWithProjectURL:self.fileURL error:&outError] autorelease];
		metaSETTER(result);
	}
	return result;
}
/*	The project infos will store everything about the engines  */
- (id)otherInfos4iTM3;
{
	id result = metaGETTER;
	if (!result) {
		result = [[[iTM2InfoWrapper alloc] init] autorelease];
		metaSETTER(result);
		[IMPLEMENTATION takeMetaValue:nil forKey:@"MutableInfos"];// next time mutableProjectInfos is called, it will make a mutable copy of otherInfos4iTM3
		NSError * outError;
		NSURL * url = [self.fileURL otherInfoURL4iTM3WithCreate:NO error:&outError];
		if (url) {
			id model = [NSDictionary dictionaryWithContentsOfURL:url];
			if (model)
			{
				[result setModel:model];
			}
			else if (url.isFileURL && [DFM fileExistsAtPath:url.path])
			{
				REPORTERROR4iTM3(1,([NSString stringWithFormat:@"! ERROR while reading the property list at %@", url]),nil);
			}
		}
		else if (self.fileURL && outError)
		{
			REPORTERROR4iTM3(1,@"! ERROR",outError);
		}
	}
	return result;
}
- (id)customInfos4iTM3;
{
	id result = metaGETTER;
	if (!result)
	{
		result = [[[iTM2InfoWrapper alloc] init] autorelease];
		metaSETTER(result);
		NSError * outError;
		NSURL * url = [self.fileURL customInfoURL4iTM3WithCreate:NO error:&outError];
		if (url)
		{
			id model = [NSDictionary dictionaryWithContentsOfURL:url];
			if (model)
			{
				[result setModel:model];
			}
			else if (url.isFileURL && [DFM fileExistsAtPath:url.path])
			{
				REPORTERROR4iTM3(1,([NSString stringWithFormat:@"! ERROR while reading the property list at %@", url]),nil);
			}
		}
		else if (self.fileURL && outError)
		{
			REPORTERROR4iTM3(1,@"! ERROR",outError);
		}
	}
	return result;
}
- (id)mutableProjectInfos;
{
	id result = metaGETTER;
	if (!result)
	{
		result = [[[iTM2InfoWrapper alloc] init] autorelease];
		[result setModel:[self.otherInfos4iTM3 model]];// a mutable deep copy is done
		metaSETTER(result);
	}
	return result;
}
- (id)metaInfos4iTM3;
{
	id result = metaGETTER;
	if (!result)
	{
		result = [[[iTM2InfoWrapper alloc] init] autorelease];
		metaSETTER(result);
		NSError * outError;
		NSURL * url = [self.fileURL metaInfoURL4iTM3WithCreate:NO error:&outError];
		if (url)
		{
			id model = [NSDictionary dictionaryWithContentsOfURL:url];
			if (model)
			{
				[result setModel:model];
			}
			else if (url.isFileURL && [DFM fileExistsAtPath:url.path])
			{
				REPORTERROR4iTM3(1,([NSString stringWithFormat:@"! ERROR while reading the property list at %@", url]),nil);
			}
		}
		else if (self.fileURL && outError)
		{
			REPORTERROR4iTM3(1,@"! ERROR:",outError);
		}
	}
	return result;
}
- (id)infosController4iTM3;
{
	id result = metaGETTER;
	if (!result)
	{
		result = [[[iTM2InfosController alloc] initWithProject:self atomic:NO prefixWithKeyPaths:nil] autorelease];
		metaSETTER(result);
	}
	return result;
}
#pragma mark =-=-=-=-=-  I/O
- (BOOL)infoCompleteWriteToURL4iTM3:(NSURL *)absoluteURL ofType:(NSString *)fileType error:(NSError **)RORef;
{
	BOOL result = NO;
	iTM2MainInfoWrapper * info = nil;
    NSURL * url = nil;
    info = self.otherInfos4iTM3;
    if (info.changeCount) {
        [info setInfo4TM3:iTM2ProjectInfoProjectType forKeyPaths:@"self.class",nil];
        if ((url = [absoluteURL otherInfoURL4iTM3WithCreate:YES error:RORef])) {
            if ([info.model writeToURL:url atomically:YES]) {
                [info updateChangeCount:NSChangeCleared];
                result = YES;
meta:
                info = self.metaInfos4iTM3;
                if (info.changeCount) {
                    [info setInfo4TM3:iTM2ProjectInfoMetaComponent forKeyPaths:@"self.class",nil];
                    if ((url = [absoluteURL metaInfoURL4iTM3WithCreate:YES error:RORef])) {
                        if ([info.model writeToURL:url atomically:YES]) {
                            [info updateChangeCount:NSChangeCleared];
                            result = YES;
custom:
                            info = self.customInfos4iTM3;
                            if (info.changeCount) {
                                [info setInfo4TM3:iTM2ProjectInfoCustomType forKeyPaths:@"self.class",nil];
                                if ((url = [absoluteURL customInfoURL4iTM3WithCreate:YES error:RORef])) {
                                    if ([info.model writeToURL:url atomically:YES]) {
                                        [info updateChangeCount:NSChangeCleared];
                                        result = YES;
main:
                                        info = self.mainInfos4iTM3;
                                        if (info.changeCount ||!result) {
                                            [info setInfo4TM3:iTM2ProjectInfoMainType forKeyPaths:@"self.class",nil];
                                            if ((url = [absoluteURL mainInfoURL4iTM3WithCreate:YES error:RORef])) {
                                                if ([info.model writeToURL:url atomically:YES]) {
                                                    [info updateChangeCount:NSChangeCleared];
                                                    return YES;
                                                }
                                                 // the atomically flag is ignored if url of a type that cannot be written atomically.
                                                OUTERROR4iTM3(1,([NSString stringWithFormat:@"Could not write to\n%@",absoluteURL]),nil);
                                            }
                                        }
                                        return result;
                                    }
                                    OUTERROR4iTM3(4,([NSString stringWithFormat:@"Could not write to\n%@",absoluteURL]),nil);
                                }
                            }
                            goto main;
                        }
                        OUTERROR4iTM3(3,([NSString stringWithFormat:@"Could not write to\n%@",absoluteURL]),nil);
                    }
                }
                goto custom;
            }
            OUTERROR4iTM3(2,([NSString stringWithFormat:@"Could not write to\n%@",absoluteURL]),nil);
        }
    }
    goto meta;
}
- (BOOL)infoCompleteReadFromURL4iTM3:(NSURL *)absoluteURL ofType:(NSString *)fileType error:(NSError **)RORef;
{
	[self.implementation takeMetaValue:nil forKey:@"MainInfos"];
	[self.implementation takeMetaValue:nil forKey:@"MetaInfos4iTM3"];
	[self.implementation takeMetaValue:nil forKey:@"OtherInfo4iTM3s"];
	[self.implementation takeMetaValue:nil forKey:@"CustomInfo4iTM3s"];
	return YES;
}
@end

@interface iTM2Inspector(Infos)
- (NSString *)infosKeyPathPrefix;
- (id)infosController4iTM3;
@end

@implementation iTM2Inspector(Infos)
- (NSString *)infosKeyPathPrefix;
{
	return nil;
}
- (id)infosController4iTM3;// lazy intializer, for the projects, it will break if the inspector changes its project
{
	id result = metaGETTER;
	if (!result)
	{
		iTM2ProjectDocument * PD = self.document;
		if ([PD isKindOfClass:[iTM2ProjectDocument class]])
		{
			result = [[[iTM2InfosController alloc] initWithProject:PD atomic:NO prefixWithKeyPaths:[self infosKeyPathPrefix],nil] autorelease];
			metaSETTER(result);
			result = metaGETTER;
		}
	}
	return result;
}
@end


@interface iTM2InfosController()
/*  The prefix is used to access the model repository.
 *  The repository is in general a big tree,
 *  the model of the receiver may correspond to only a subtree. */
@property (readwrite,copy) NSArray * prefix;
/*  If the receiver is atomic, project infos edition takes place on the real model,
 *  otherwise it takes place in a mutable copy of the model. */
@property (readwrite) BOOL isAtomic;
@end


@implementation iTM2InfosController
- (id)initWithProject:(id)project atomic:(BOOL)yorn prefixWithKeyPaths:(NSString *)first,...;
{
	if ((self = [super init])) {
		self.project = project;
		VA_LIST_OF_KEY_PATHS_TO_ARRAY4iTM3(first,MRA);
        self.prefix = MRA;
        self.isAtomic = yorn;
	}
	return self;
}
/*  The correct infos object to edit, whether the receiver is atomic or not */
- (id)infos;
{
	return self.isAtomic? [self.project mutableProjectInfos]:[self.project otherInfos4iTM3];
}
#pragma mark =-=-=-=-=-  GET/SET
/*  Whether the receiver is atomic or not does not make any difference here.
 *  The project information is always returned for the given list of keys is always returned. */
- (id)localInfoForKeys:(NSArray *)keys;
{
	NSMutableArray * Ks = [NSMutableArray arrayWithArray:self.prefix];
	[Ks addObjectsFromArray:keys];
	return [[self.project otherInfos4iTM3] infoForKeys:keys];
}
/*  If the receiver is not atomic, this is exactly [self localInfoForKeys:keys].
 *  Otherwise this is the lastly edited value. */
- (id)editInfoForKeys:(NSArray *)keys;
{
	NSMutableArray * Ks = [NSMutableArray arrayWithArray:self.prefix];
	[Ks addObjectsFromArray:keys];
	return [self.infos infoForKeys:keys];
}
/*  The inherited info for the given list of keys.
 *  If the result is a dictionary, it was obtained by merging all the dictionaries of the ancestors.
 *  Latest Revision: Sat Jan 30 09:25:17 UTC 2010
 */
- (id)inheritedInfo4iTM3ForKeys:(NSArray *)keys;
{
	NSString * name;
	NSEnumerator * E;
	iTM2ProjectDocument * P = self.project;
	if ([SPC isBaseProject:P]) {
        //  Things are special for base projects
        //  Inheritancy is managed by baseNamesOfAncestorsForBaseProjectName:
		name = P.fileURL.path;
		E = [[SPC baseNamesOfAncestorsForBaseProjectName:name] objectEnumerator];
		[E nextObject];// skip the first object: this is (quite) name 
	} else {
        //  This is not a base project
        //  Inherit from the base project
		name = P.baseProjectName;
		E = [[SPC baseNamesOfAncestorsForBaseProjectName:name] objectEnumerator];
	}
    while ((name = E.nextObject)) {
        NSError * ROR = nil;
		P = [SPC baseProjectWithName:name error:self.RORef4iTM3];
        if (ROR) {
            LOG4iTM3(@"YOUR ATTENTION PLEASE! There might be an error: %@",ROR);
            ROR = nil;
        }
		id result = [P.otherInfos4iTM3 infoForKeys:keys];
		/* if result is a dictionary, it should be merged with the dictionaries of other ancestors, if any */
		if ([result isKindOfClass:[NSDictionary class]]) {
			result = [[result mutableCopy] autorelease];
			while ((name = E.nextObject)) {
				P = [SPC baseProjectWithName:name error:self.RORef4iTM3];
                if (ROR) {
                    LOG4iTM3(@"YOUR ATTENTION PLEASE! There might be an error: %@",ROR);
                    ROR = nil;
                }
				NSDictionary * r = [P.otherInfos4iTM3 infoForKeys:keys];
				if ([r isKindOfClass:[NSDictionary class]]) {
					[result mergeEntriesFromDictionary4iTM3:r];
				} else if (r) {
					/* this is not a dictionary, it breaks the ancestor chain */
					return result;
				}
			}
			return result;
		} else if (result) {
			return result;
		}
	}
	return nil;
}
- (BOOL)isInfoInherited4iTM3ForKeys:(NSArray *)keys;
{
    return NO;
}
- (id)infoForKeys:(NSArray *)keys;
{
	NSMutableArray * Ks = [NSMutableArray arrayWithArray:self.prefix];
	[Ks addObjectsFromArray:keys];
	id result = [self.infos infoForKeys:Ks];// different behaviour depending on isAtomic.
	if ([result isKindOfClass:[NSDictionary class]]) {
		NSMutableDictionary * inherited = [self inheritedInfo4iTM3ForKeys:Ks];
		if ([inherited isKindOfClass:[NSDictionary class]]) {
			inherited = [[inherited deepMutableCopy4iTM3] autorelease];
			[inherited mergeEntriesFromDictionary4iTM3:result];
			return inherited;
		}
		return result;
	} else if ([result isEqual:@"\e"]) {
		/* A nil result means inheritancy,
		 * but we must also code for a really nil result.
		 * For that we asume that by default the values are inherited. */
		return nil;
	} else if (result) {
		return result;
	} else {
		return [self inheritedInfo4iTM3ForKeys:Ks];
	}
}
- (id)infoInherited4iTM3:(BOOL)yorn forKeys:(NSArray *)keys;
{
    if (yorn) {
        return [self infoForKeys:keys];
    }
	NSMutableArray * Ks = [NSMutableArray arrayWithArray:self.prefix];
	[Ks addObjectsFromArray:keys];
	id result = [self.infos infoForKeys:Ks];// different behaviour depending on isAtomic.
	if ([result isEqual:@"\e"]) {
		/* A nil result means inheritancy,
		 * but we must also code for a really nil result.
		 * For that we asume that by default the values are inherited. */
		return nil;
	} else {
		return result;
	}
}
- (BOOL)setInfo:(id)info forKeys:(NSArray *)keys;
{
	NSMutableArray * Ks = [NSMutableArray arrayWithArray:self.prefix];
	[Ks addObjectsFromArray:keys];
	if ([info isEqual:[NSNull null]]) {
		info = @"\e";
	}
	return [self.infos setInfo:info forKeys:Ks];
}
- (BOOL)isInfoEditedForKeys:(NSArray *)keys;
{
	NSMutableArray * Ks = [NSMutableArray arrayWithArray:self.prefix];
	[Ks addObjectsFromArray:keys];
	id lhs, rhs;
	iTM2ProjectDocument * P = self.project;
	if (self.isAtomic) {
		lhs = [P.otherInfos4iTM3 infoForKeys:Ks];
		if (!lhs) {
			lhs = [self inheritedInfo4iTM3ForKeys:Ks];
		}
		rhs = [P.mutableProjectInfos infoForKeys:Ks];
	} else {
		lhs = [self inheritedInfo4iTM3ForKeys:Ks];
		rhs = [P.otherInfos4iTM3 infoForKeys:Ks];
	}
	return ![lhs isEqual:rhs] || (rhs != lhs);
}
#pragma mark =-=-=-=-=-  CUSTOM
/*  The purpose of the custom info is to keep track of what is edited.
 *  Typically, one can edit the values in some panel but does not want to save the changes.
 *  When he reopens the same panel, he would be happy to recover the previously edited values. */
- (id)customInfo4iTM3ForKeys:(NSArray *)keys;
{
	NSMutableArray * Ks = [NSMutableArray arrayWithArray:self.prefix];
	[Ks addObjectsFromArray:keys];
	return [[self.project customInfos4iTM3] infoForKeys:keys];
}
/*  Backup the edited info.
 *  The user has started to edit the information but the change is not yet registered.
 *  We keep that information in case the user wants to continue edition. */
- (BOOL)backupCustomForKeys:(NSArray *)keys;
{
	NSMutableArray * Ks = [NSMutableArray arrayWithArray:self.prefix];
	[Ks addObjectsFromArray:keys];
	id edit = [self.infos editInfoForKeys:Ks];
	return [[self.project customInfos4iTM3] setInfo:edit forKeys:Ks];
}
/*  The user want to continue edition.
 *  We start from the last value edited. */
- (BOOL)restoreCustomForKeys:(NSArray *)keys;
{
	NSMutableArray * Ks = [NSMutableArray arrayWithArray:self.prefix];
	[Ks addObjectsFromArray:keys];
	id custom = [[self.project customInfos4iTM3] infoForKeys:Ks];
	if (custom)
	{
		[self.infos setInfo:custom forKeys:Ks];
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
	if (![self isAtomic]) {
		return YES;// nothing to save because everything was edited in place
	}
	NSMutableArray * Ks = [NSMutableArray arrayWithArray:self.prefix];
	[Ks addObjectsFromArray:keys];
	[self backupCustomForKeys:Ks];
	iTM2ProjectDocument * P = self.project;
	id edit = [P.mutableProjectInfos infoForKeys:Ks];
	return [P.otherInfos4iTM3 setInfo:edit forKeys:Ks];
}
/*  If the user has made some changes, but do not want to use them anymore,
 *  He can revert to the original value.
 *  The result is YES if the revert operation was successful, NO otherwise. */
- (BOOL)revertChangesForKeys:(NSArray *)keys;
{
	if (![self isAtomic]) {
		return YES;// nothing to revert because everything was edited in place
	}
	NSMutableArray * Ks = [NSMutableArray arrayWithArray:self.prefix];
	[Ks addObjectsFromArray:keys];
	[self backupCustomForKeys:Ks];// not really well designed, why?
	iTM2ProjectDocument * P = self.project;
	id edit = [P.otherInfos4iTM3 infoForKeys:Ks];
	return [P.mutableProjectInfos setInfo:edit forKeys:Ks];
}
@synthesize project = iVarProject4iTM3;
@synthesize isAtomic = iVarAtomic4iTM3;
@synthesize prefix = iVarPrefix4iTM3;
@end

@implementation NSObject(Infos)
- (id)infosController4iTM3;// lazy intializer, for the projects
{
	id result = metaGETTER;
	return result;
}
- (void)setInfosController4iTM3:(id)controller;
{
	metaSETTER(controller);
	return;
}
- (id)metaInfos4iTM3;
{
	NSAssert(NO,@"! ERROR: Unsupported metaInfos4iTM3, report bug");
	return nil;
}
- (id)metaInfo4iTM3ForKeyPaths:(NSString *)first,...;
{
	VA_LIST_OF_KEY_PATHS_TO_ARRAY4iTM3(first,keys);
	return [self.metaInfos4iTM3 infoForKeys:keys];
}
- (BOOL)setMetaInfo4iTM3:(id)info forKeyPaths:(NSString *)first,...;
{
	VA_LIST_OF_KEY_PATHS_TO_ARRAY4iTM3(first,keys);
	return [self.metaInfos4iTM3 setInfo:info forKeys:keys];
}
- (id)infoInherited4iTM3:(BOOL)yorn forKeyPaths:(NSString *)first,...;
{
	VA_LIST_OF_KEY_PATHS_TO_ARRAY4iTM3(first,keys);
	return [[self infosController4iTM3] infoInherited4iTM3:yorn forKeys:keys];
}
- (id)info4iTM3ForKeyPaths:(NSString *)first,...;
{
	VA_LIST_OF_KEY_PATHS_TO_ARRAY4iTM3(first,keys);
	return [[self infosController4iTM3] infoForKeys:keys];
}
- (BOOL)setInfo4TM3:(id)info forKeyPaths:(NSString *)first,...;
{
	VA_LIST_OF_KEY_PATHS_TO_ARRAY4iTM3(first,keys);
	return [[self infosController4iTM3] setInfo:info forKeys:keys];
}
- (BOOL)isInfo4iTM3EditedForKeyPaths:(NSString *)first,...;
{
	VA_LIST_OF_KEY_PATHS_TO_ARRAY4iTM3(first,keys);
	return [[self infosController4iTM3] isInfoEditedForKeys:keys];
}
- (id)inheritedInfo4iTM3ForKeyPaths:(NSString *)first,...;
{
	VA_LIST_OF_KEY_PATHS_TO_ARRAY4iTM3(first,keys);
	return [[self infosController4iTM3] inheritedInfo4iTM3ForKeys:keys];
}
- (BOOL)isInfoInherited4iTM3ForKeyPaths:(NSString *)first,...;
{
	VA_LIST_OF_KEY_PATHS_TO_ARRAY4iTM3(first,keys);
	return [[self infosController4iTM3] isInfoInherited4iTM3ForKeys:keys];
}
- (id)localInfo4iTM3ForKeyPaths:(NSString *)first,...;
{
	VA_LIST_OF_KEY_PATHS_TO_ARRAY4iTM3(first,keys);
	return [[self infosController4iTM3] localInfoForKeys:keys];
}
- (id)customInfo4iTM3ForKeyPaths:(NSString *)first,...;
{
	VA_LIST_OF_KEY_PATHS_TO_ARRAY4iTM3(first,keys);
	return [[self infosController4iTM3] customInfo4iTM3ForKeys:keys];
}
- (id)editInfo4iTM3ForKeyPaths:(NSString *)first,...;
{
	VA_LIST_OF_KEY_PATHS_TO_ARRAY4iTM3(first,keys);
	return [[self infosController4iTM3] editInfoForKeys:keys];
}
- (BOOL)toggleInfo4iTM3ForKeyPaths:(NSString *)first,...;
{
	VA_LIST_OF_KEY_PATHS_TO_ARRAY4iTM3(first,keys);
	BOOL old = [[[self infosController4iTM3] infoForKeys:keys] boolValue];
	return [[self infosController4iTM3] setInfo:[NSNumber numberWithBool:!old] forKeys:keys];
}
- (BOOL)backupCustomInfo4iTM3ForKeyPaths:(NSString *)first,...;
{
	VA_LIST_OF_KEY_PATHS_TO_ARRAY4iTM3(first,keys);
	return [[self infosController4iTM3] backupCustomForKeys:keys];
}
- (BOOL)restoreCustomInfo4iTM3ForKeyPaths:(NSString *)first,...;
{
	VA_LIST_OF_KEY_PATHS_TO_ARRAY4iTM3(first,keys);
	return [[self infosController4iTM3] restoreCustomForKeys:keys];
}
- (BOOL)saveChanges4iTM3ForKeyPaths:(NSString *)first,...;
{
	VA_LIST_OF_KEY_PATHS_TO_ARRAY4iTM3(first,keys);
	return [[self infosController4iTM3] saveChangesForKeys:keys];
}
- (BOOL)revertChanges4iTM3ForKeyPaths:(NSString *)first,...;
{
	VA_LIST_OF_KEY_PATHS_TO_ARRAY4iTM3(first,keys);
	return [[self infosController4iTM3] revertChangesForKeys:keys];
}
@end
