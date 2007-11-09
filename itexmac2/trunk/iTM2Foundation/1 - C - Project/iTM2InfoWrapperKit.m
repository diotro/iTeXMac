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

NSString * const TWSSourceKey = @"source";
NSString * const TWSKeyedPropertiesKey = @"properties";
NSString * const TWSKeyedFilesKey = @"files";

NSString * const iTM2InfoWrapperType = @"iTM2 Property list wrapper";

static NSString * const iTM2ProjectLastKeyKey = @"_LastKey";

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

#import <iTM2Foundation/ICURegEx.h>
@implementation iTM2InfoWrapper
static ICURegEx * _iTM2InfoWrapperSetRE = nil;
static ICURegEx * _iTM2InfoWrapperGetRE = nil;
+ (void) initialize;
{
	[super initialize];
	if(!_iTM2InfoWrapperSetRE)
	{
		_iTM2InfoWrapperSetRE = [[ICURegEx alloc] initWithSearchPattern:@"infoForPaths(:+)" options:0 error:nil];
		_iTM2InfoWrapperGetRE = [[ICURegEx alloc] initWithSearchPattern:@"takeInfo:forPaths(:+)" options:0 error:nil];
	}
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
	// the local model needs to be mutable in order to make updates easyly.
	// However, the receiver should be the only one to know that it -is- mutable...
	// and everyone else should simply ignore this fact.
	// if this can't be done, it is not a valid property list
	// the programmer should be responsible of what he is doing but there is no safety guard here
	// get a data object
	if(!model)
	{
		metaSETTER([NSMutableDictionary dictionary]);
		return;
	}
	NSString * errorString = nil;
	id data = [NSPropertyListSerialization dataFromPropertyList:model format:NSPropertyListBinaryFormat_v1_0 errorDescription:&errorString];
	if(data)
	{
		if(model = [NSPropertyListSerialization propertyListFromData:data
			mutabilityOption: NSPropertyListMutableContainersAndLeaves
				format: nil errorDescription: &errorString])
		{
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
			result = [model objectForKey:K];
			while(K = [E nextObject])
			{
				if([K length])
				{
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
- (id)infoForKeyPaths:(NSString *)first,...;
{
	iTM2_VA_LIST_OF_PATHS_TO_ARRAY(first,keys);
	return [self infoForKeys:keys];
}
- (BOOL)takeInfo:(id)info forKeys:(NSArray *)keys;
{
	NSParameterAssert([keys count]);
	id model = [self model];
	unsigned index = [keys count];
	NSEnumerator * E = [keys reverseObjectEnumerator];
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
			K = [E nextObject];
			if([K length])
			{
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
					D = [NSMutableDictionary dictionary];
					[model setObject:D forKey:K];
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
- (BOOL)takeInfo:(id)info forKeyPaths:(NSString *)first,...;
{
	iTM2_VA_LIST_OF_PATHS_TO_ARRAY(first,keys);
	return [self takeInfo:info forKeys:keys];
}
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
	NSString * name = NSStringFromSelector(aSelector);
	[_iTM2InfoWrapperSetRE setInputString:name];
	if([_iTM2InfoWrapperSetRE nextMatch])
	{
		NSMutableString * new = [[[_iTM2InfoWrapperSetRE substringOfCaptureGroupAtIndex:1] mutableCopy] autorelease];
		[new replaceOccurrencesOfString:@":" withString:@"@" options:0 range:NSMakeRange(0,[new length])];
		[new insertString:@"i@:" atIndex:0];
		return [NSMethodSignature signatureWithObjCTypes:[new UTF8String]];
	}
	[_iTM2InfoWrapperGetRE setInputString:name];
	if([_iTM2InfoWrapperGetRE nextMatch])
	{
		NSMutableString * new = [[[_iTM2InfoWrapperGetRE substringOfCaptureGroupAtIndex:1] mutableCopy] autorelease];
		[new replaceOccurrencesOfString:@":" withString:@"@" options:0 range:NSMakeRange(0,[new length])];
		[new insertString:@"@@:" atIndex:0];
		return [NSMethodSignature signatureWithObjCTypes:[new UTF8String]];
	}
	return [super methodSignatureForSelector:aSelector];
}
- (void)forwardInvocation:(NSInvocation *)anInvocation;
{
	NSString * name = NSStringFromSelector([anInvocation selector]);
	unsigned index = 2;
	NSMutableArray * Ks = [NSMutableArray array];
	NSString * K;
	id O;
	if([name hasPrefix:@"infoForPaths:"])
	{
		while(index<[name length]-12)
		{
			[anInvocation getArgument:&K atIndex:index];
			[Ks addObjectsFromArray:[K componentsSeparatedByString:@"."]];
			++index;
		}
		O = [self infoForKeys:Ks];
		[anInvocation setReturnValue:&O];
		return;
	}
	else if([name hasPrefix:@"takeInfo:forPaths:"])
	{
		[anInvocation getArgument:&O atIndex:index];
		while(++index<[name length]-17)
		{
			[anInvocation getArgument:&K atIndex:index];
			[Ks addObjectsFromArray:[K componentsSeparatedByString:@"."]];
		}
		[self takeInfo:O forKeys:Ks];
		return;
	}
	[super forwardInvocation:anInvocation];
}
@end

@interface iTM2ProjectDocument(PRIVATE)
/*!
	@method			mainInfos
	@abstract		The main Info wrapper.
	@discussion		Discussion forthcoming.
	@param			None
	@result			an iTM2InfoWrapper instance
	@availability	iTM2.
	@copyright		2007 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (id)mainInfos;

/*!
	@method			metaInfos
	@abstract		The meta Info wrapper.
	@discussion		Discussion forthcoming.
	@param			None
	@result			an iTM2InfoWrapper instance
	@availability	iTM2.
	@copyright		2007 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (id)metaInfos;

/*!
	@method			otherInfos
	@abstract		The editable local Info wrapper.
	@discussion		Discussion forthcoming.
	@param			None
	@result			an iTM2InfoWrapper instance
	@availability	iTM2.
	@copyright		2007 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (id)otherInfos;

/*!
	@method			customInfos
	@abstract		The custom Info wrapper.
	@discussion		Discussion forthcoming.
	@param			None
	@result			an iTM2InfoWrapper instance
	@availability	iTM2.
	@copyright		2007 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (id)customInfos;

/*!
	@method			mutableInfos
	@abstract		The mutable local Info wrapper.
	@discussion		Discussion forthcoming.
	@param			None
	@result			an iTM2InfoWrapper instance
	@availability	iTM2.
	@copyright		2007 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (id)mutableInfos;

@end

@interface iTM2InfosController(PRIVATE)
- (id)project;
- (void)setProject:(id)project;
- (NSArray *)prefix;
- (id)infoForKeyPath:(NSString *)path prefix:(NSString *)prefix;
@end


@implementation iTM2InfosController

- (id)project;
{
	return [metaGETTER nonretainedObjectValue];
}
- (void)setProject:(id)project;
{
	metaSETTER([NSValue valueWithNonretainedObject:project]);
	return;
}
- (NSArray *)prefix;
{
	return metaGETTER;
}
- (BOOL)isAtomic;
{
	return [metaGETTER boolValue];
}
- (id)initWithProject:(id)project atomic:(BOOL)yorn prefixWithKeyPaths:(NSString *)first,...;
{
	if(self = [super init])
	{
		[self setProject:project];
		NSMutableArray * MRA = [NSMutableArray array];
		if(first)
		{
			[MRA addObjectsFromArray:[first componentsSeparatedByString:@"."]];
			va_list list;
			va_start(list,first);
			NSString * S;
			while(S = va_arg(list, id))
			{
				[MRA addObjectsFromArray:[S componentsSeparatedByString:@"."]];
			}
			va_end(list);
		}
		[[self implementation] takeMetaValue:MRA forKey:@"Prefix"];
		[[self implementation] takeMetaValue:[NSNumber numberWithBool:yorn] forKey:@"Atomic"];
	}
	return self;
}
- (id)infos;
{
	return [self isAtomic]? [[self project] mutableInfos]:[[self project] otherInfos];
}
#pragma mark =-=-=-=-=-  GET/SET
- (id)inheritedInfoForKeys:(NSArray *)keys;
{
	NSString * name = [SPC isBaseProject:[self project]]?[[self project] fileName]:[[self project] baseProjectName];
	NSArray * RA = [SPC baseNamesOfAncestorsForBaseProjectName:name];
	NSEnumerator * E = [RA objectEnumerator];
	[E nextObject];// skip the first object: this is (quite) name
	while(name = [E nextObject])
	{
		id result = [[[SPC baseProjectWithName:name] otherInfos] infoForKeys:keys];
		if([result isKindOfClass:[NSDictionary class]])
		{
			result = [[result mutableCopy] autorelease];
			while(name = [E nextObject])
			{
				id r = [[[SPC baseProjectWithName:name] otherInfos] infoForKeys:keys];
				if([r isKindOfClass:[NSDictionary class]])
				{
					[result iTM2_mergeEntriesFromDictionary:r];
				}
				else
				{
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
	id result = [[self infos] infoForKeys:Ks];
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
	else if(result && ![result isEqual:@"Base"])
	{
		return result;
	}
	else
	{
		return [self inheritedInfoForKeys:Ks];
	}
}
- (BOOL)takeInfo:(id)info forKeys:(NSArray *)keys;
{
	NSMutableArray * Ks = [NSMutableArray arrayWithArray:[self prefix]];
	[Ks addObjectsFromArray:keys];
	return [[self infos] takeInfo:info forKeys:Ks];
}
- (BOOL)isInfoEditedForKeys:(NSArray *)keys;
{
	NSMutableArray * Ks = [NSMutableArray arrayWithArray:[self prefix]];
	[Ks addObjectsFromArray:keys];
	id lhs, rhs;
	if([self isAtomic])
	{
		lhs = [[[self project] otherInfos] infoForKeys:Ks];
		rhs = [[[self project] mutableInfos] infoForKeys:Ks];
	}
	else
	{
		lhs = [self inheritedInfoForKeys:Ks];
		rhs = [[[self project] otherInfos] infoForKeys:Ks];
	}
	return ![lhs isEqual:rhs] || (rhs != lhs);
}
- (id)localInfoForKeys:(NSArray *)keys;
{
	NSMutableArray * Ks = [NSMutableArray arrayWithArray:[self prefix]];
	[Ks addObjectsFromArray:keys];
	return [[[self project] otherInfos] infoForKeys:keys];
}
- (id)customInfoForKeys:(NSArray *)keys;
{
	NSMutableArray * Ks = [NSMutableArray arrayWithArray:[self prefix]];
	[Ks addObjectsFromArray:keys];
	return [[[self project] customInfos] infoForKeys:keys];
}
- (id)editInfoForKeys:(NSArray *)keys;
{
	NSMutableArray * Ks = [NSMutableArray arrayWithArray:[self prefix]];
	[Ks addObjectsFromArray:keys];
	return [[self infos] infoForKeys:keys];
}
#pragma mark =-=-=-=-=-  CUSTOM
- (void)backupCustomForKeys:(NSArray *)keys;
{
	NSMutableArray * Ks = [NSMutableArray arrayWithArray:[self prefix]];
	[Ks addObjectsFromArray:keys];
	id edit = [[self infos] editInfoForKeys:Ks];
	[[[self project] customInfos] takeInfo:edit forKeys:Ks];
	return;
}
- (BOOL)restoreCustomForKeys:(NSArray *)keys;
{
	NSMutableArray * Ks = [NSMutableArray arrayWithArray:[self prefix]];
	[Ks addObjectsFromArray:keys];
	id custom = [[[self project] customInfos] infoForKeys:Ks];
	if(custom)
	{
		[[self infos] takeInfo:custom forKeys:Ks];
		return YES;
	}
	return NO;
}
#pragma mark =-=-=-=-=-  EDIT
- (BOOL)saveChangesForKeys:(NSArray *)keys;
{
	if(![self isAtomic])
	{
		return YES;// nothing to save because eveything was edited in place
	}
	NSMutableArray * Ks = [NSMutableArray arrayWithArray:[self prefix]];
	[Ks addObjectsFromArray:keys];
	[self backupCustomForKeys:Ks];
	id edit = [[[self project] mutableInfos] infoForKeys:Ks];
	return [[[self project] otherInfos] takeInfo:edit forKeys:Ks];
}
- (BOOL)revertChangesForKeys:(NSArray *)keys;
{
	if(![self isAtomic])
	{
		return YES;// nothing to restore because eveything was edited in place
	}
	NSMutableArray * Ks = [NSMutableArray arrayWithArray:[self prefix]];
	[Ks addObjectsFromArray:keys];
	[self backupCustomForKeys:Ks];// not really well designed
	id edit = [[[self project] otherInfos] infoForKeys:Ks];
	return [[[self project] mutableInfos] takeInfo:edit forKeys:Ks];
}

@end

NSString * const iTM2ProjectOtherType = @"other";
NSString * const iTM2ProjectCustomType = @"custom";
NSString * const iTM2ProjectCustomInfoComponent = @"CustomInfo";
NSString * const iTM2ProjectMetaInfoComponent = @"MetaInfo";
NSString * const iTM2ProjectInfoComponent = @"Info";

#import <iTM2Foundation/iTM2RuntimeBrowser.h>

@implementation iTM2ProjectDocument(Infos)
#pragma mark =-=-=-=-=-  I/O
- (BOOL)infoCompleteWriteToURL:(NSURL *)absoluteURL ofType:(NSString *)fileType error:(NSError **)outErrorPtr;
{
	BOOL result = NO;
	id info = [self mainInfos];
	if([info changeCount])
	{
		[info takeInfo:iTM2ProjectInfoType forKeyPaths:@"isa",nil];
		NSURL * url;
		if(url = [SPC projectInfoURLFromFileURL:absoluteURL create:YES error:outErrorPtr])
		{
			[info updateChangeCount:NSChangeCleared];
			if([[info model] writeToURL:url atomically:YES])
			{
				result = YES;
				[info updateChangeCount:NSChangeCleared];
other:
				info = [self otherInfos];
				if([info changeCount])
				{
					[info takeInfo:iTM2ProjectOtherType forKeyPaths:@"isa",nil];
					if(url = [SPC projectFrontendInfoURLFromFileURL:absoluteURL create:YES error:outErrorPtr])
					{
						if([[info model] writeToURL:url atomically:YES])
						{
							result = YES;
							[info updateChangeCount:NSChangeCleared];
meta:
							info = [self metaInfos];
							if([info changeCount])
							{
								[info takeInfo:iTM2ProjectMetaInfoComponent forKeyPaths:@"isa",nil];
								if(url = [SPC projectMetaInfoURLFromFileURL:absoluteURL create:YES error:outErrorPtr])
								{
									if([[info model] writeToURL:url atomically:YES])
									{
										[info updateChangeCount:NSChangeCleared];
custom:
										info = [self customInfos];
										if([info changeCount])
										{
											[info takeInfo:iTM2ProjectCustomType forKeyPaths:@"isa",nil];
											if(url = [SPC projectCustomInfoURLFromFileURL:absoluteURL create:YES error:outErrorPtr])
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
	goto other;
	return NO;
}
- (BOOL)infoCompleteReadFromURL:(NSURL *)absoluteURL ofType:(NSString *)fileType error:(NSError **)outErrorPtr;
{
	[[self implementation] takeMetaValue:nil forKey:@"MainInfos"];
	[[self implementation] takeMetaValue:nil forKey:@"MetaInfos"];
	[[self implementation] takeMetaValue:nil forKey:@"OtherInfos"];
	[[self implementation] takeMetaValue:nil forKey:@"CustomInfos"];
	return YES;
}
#pragma mark =-=-=-=-=-  MAIN
- (id)mainInfos;
{
	id result = metaGETTER;
	if(!result)
	{
		result = [[[iTM2InfoWrapper allocWithZone:[self zone]] init] autorelease];
		metaSETTER(result);
		NSError * outError;
		NSURL * url = [SPC projectInfoURLFromFileURL:[self fileURL] create:NO error:&outError];
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
- (NSString *)sourceDirectory;
{
	return [[self mainInfos] infoForKeyPaths:TWSSourceKey,nil]?:@".";
}
- (void)setSourceDirectory:(NSString *)path;
{
	[[self mainInfos] takeInfo:path forKeyPaths:TWSSourceKey,nil];
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  keyedFileNames
- (id)keyedFileNames;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    id result = [[self mainInfos] infoForKeyPaths:TWSKeyedFilesKey,nil];
    if(!result)
    {
        [[self mainInfos] takeInfo:[NSMutableDictionary dictionary] forKeyPaths:TWSKeyedFilesKey,nil];
        result = [[self mainInfos] infoForKeyPaths:TWSKeyedFilesKey,nil];
    }
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  nameForFileKey:
- (NSString *)nameForFileKey:(NSString *)key;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([key isEqual:iTM2ProjectLastKeyKey])
	{
		return @"";
	}
	else if([key length])
	{
		return [[self keyedFileNames] valueForKey:key];
	}
//iTM2_END;
    return @"";
}
- (void)takeName:(NSString *)path forFileKey:(NSString *)key;
{
	[[self mainInfos] takeInfo:path forKeyPaths:TWSKeyedFilesKey,key,nil];
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  allFileKeys
- (NSArray *)allFileKeys;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSMutableArray * MRA = [[[[self keyedFileNames] allKeys] mutableCopy] autorelease];
    [MRA removeObject:iTM2ProjectLastKeyKey];
    return MRA;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  propertiesForFileKey
- (id)propertiesForFileKey:(NSString *)key;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSParameterAssert(key!=nil);
    return [[self mainInfos] infoForKeyPaths:TWSKeyedPropertiesKey,key,nil];
}
- (BOOL)takePropertyValue:(id)property forKey:(NSString *)key fileKey:(NSString *)fileKey;
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return [[self mainInfos] takeInfo:property forKeyPaths:TWSKeyedPropertiesKey,fileKey,key,nil];
}
- (BOOL)takeProperties:(id)properties forFileKey:(NSString *)key;
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return [[self mainInfos] takeInfo:[[properties mutableCopy] autorelease] forKeyPaths:TWSKeyedPropertiesKey,key,nil];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  nextAvailableKey
- (NSString *)nextAvailableKey;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSMutableDictionary * keyedFileNames = [self keyedFileNames];
	NSMutableIndexSet * set = [NSMutableIndexSet indexSet];
	NSEnumerator * E = [keyedFileNames keyEnumerator];
	NSString * key;
	while(key = [E nextObject])
	{
		[set addIndex:[key intValue]];
	}
	int last = 0;
	if(key = [keyedFileNames objectForKey:iTM2ProjectLastKeyKey])
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
	[keyedFileNames setObject:afterKey forKey:iTM2ProjectLastKeyKey];
//iTM2_LOG(@"afterKey: %@",afterKey);
//iTM2_LOG(@"result: %@",result);
    return result;
}
#pragma mark =-=-=-=-=-  META
- (id)metaInfos;
{
	id result = metaGETTER;
	if(!result)
	{
		result = [[[iTM2InfoWrapper allocWithZone:[self zone]] init] autorelease];
		metaSETTER(result);
		NSError * outError;
		NSURL * url = [SPC projectMetaInfoURLFromFileURL:[self fileURL] create:NO error:&outError];
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
#pragma mark =-=-=-=-=-  CONTEXT
static NSString * const iTM2ProjectContextKeyedFilesKey = @"FileContexts";
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  saveContext:
- (void)saveContext:(id)irrelevant;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	// really disable undo registration!!!
	BOOL needsToUpdate = [self needsToUpdate];
	NSUndoManager * UM = [self undoManager];
	BOOL isUndoRegistrationEnabled = [UM isUndoRegistrationEnabled];
	[UM disableUndoRegistration];
	[[self subdocuments] makeObjectsPerformSelector:_cmd withObject:irrelevant];
	[super saveContext:irrelevant];
	if(isUndoRegistrationEnabled)
		[UM enableUndoRegistration];
	NSURL * fileURL = [self fileURL];
	NSString * filetype = [self fileType];
	NSError ** outErrorPtr = nil;
    NSMethodSignature * sig0 = [self methodSignatureForSelector:@selector(writeToURL:ofType:error:)];
    NSInvocation * I = [[NSInvocation invocationWithMethodSignature:sig0] retain];
    [I setTarget:self];
    [I setArgument:&fileURL atIndex:2];
    [I setArgument:&filetype atIndex:3];
    [I setArgument:&outErrorPtr atIndex:4];
    NSEnumerator * E = [[iTM2RuntimeBrowser instanceSelectorsOfClass:isa withSuffix:@"MetaCompleteWriteToURL:ofType:error:" signature:sig0 inherited:YES] objectEnumerator];
    SEL selector;
    while(selector = (SEL)[[E nextObject] pointerValue])
    {
        [I setSelector:selector];
        [I invoke];
    }
	[I release];
	if(!needsToUpdate)
		[self recordFileModificationDateFromURL:fileURL];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  getContextValueForKey:domain:
- (id)getContextValueForKey:(NSString *)aKey domain:(unsigned int)mask;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id result = nil;
	if(result = [super getContextValueForKey:aKey domain:mask&iTM2ContextStandardLocalMask])
	{
		return result;
	}
	NSString * fileKey = @".";
	if(result = [self getContextValueForKey:aKey fileKey:fileKey domain:mask&iTM2ContextStandardLocalMask])
	{
		return result;
	}
    return [super getContextValueForKey:aKey domain:mask];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setContextValue:forKey:domain:
- (unsigned int)setContextValue:(id)object forKey:(NSString *)aKey domain:(unsigned int)mask;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	iTM2ProjectDocument * project = [self project];
	id contextManager = [self contextManager];
	NSAssert2(((project != contextManager) || (!project && !contextManager) || ((id)project == self)),@"*** %@ %#x The document's project must not be the context manager!",__iTM2_PRETTY_FUNCTION__, self);
	unsigned int didChange = [super setContextValue:object forKey:aKey domain:mask];
	NSString * fileKey = @".";// weird...
//iTM2_LOG(@"[self contextDictionary] is:%@",[self contextDictionary]);
    return didChange |= [self setContextValue:object forKey:aKey fileKey:fileKey domain:mask];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  contextValueForKey:fileKey:domain;
- (id)contextValueForKey:(NSString *)aKey fileKey:(NSString *)fileKey domain:(unsigned int)mask;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6:03/26/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_LOG(@"[self contextDictionary] is:%@",[self contextDictionary]);
//iTM2_END;
    return [self getContextValueForKey:aKey fileKey:fileKey domain:mask];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  getContextValueForKey:fileKey:domain;
- (id)getContextValueForKey:(NSString *)aKey fileKey:(NSString *)fileKey domain:(unsigned int)mask;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6:03/26/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id result = nil;
	if(mask&iTM2ContextStandardLocalMask)
	{
		if(result = [self metaInfoForKeyPaths:iTM2ProjectContextKeyedFilesKey,fileKey,aKey,nil])
		{
			return result;
		}
	}
	if(mask&iTM2ContextStandardProjectMask)
	{
		if(result = [self metaInfoForKeyPaths:iTM2ProjectContextKeyedFilesKey,iTM2ProjectDefaultsKey,aKey,nil])
		{
			return result;
		}
	}
	if(mask&iTM2ContextExtendedProjectMask)
	{
		NSString * fileName = [self relativeFileNameForKey:fileKey];
		NSString * extensionKey = [fileName pathExtension];
		if([extensionKey length])
		{
			if(result = [self metaInfoForKeyPaths:iTM2ContextExtensionsKey,extensionKey,aKey,nil])
			{
				return result;
			}
		}
		NSDocument * document = [self subdocumentForKey:fileKey];
		NSString * type = [document fileType];
		if([type length])
		{
			if(result = [self metaInfoForKeyPaths:iTM2ContextTypesKey,type,aKey,nil])
			{
				return result;
			}
		}
		if([extensionKey length])
		{
			NSString * typeFromFileExtension = [SDC typeFromFileExtension:extensionKey];
			if([typeFromFileExtension length] && ![typeFromFileExtension isEqual:type])
			{
				if(result = [self metaInfoForKeyPaths:iTM2ContextTypesKey,typeFromFileExtension,aKey,nil])
				{
					return result;
				}
			}
		}
	}
    return [fileKey isEqual:@"."]?[super getContextValueForKey:aKey domain:mask]:nil;// not self, reentrant code management
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeContextValue:forKey:fileKey:domain:
- (unsigned int)takeContextValue:(id)object forKey:(NSString *)aKey fileKey:(NSString *)fileKey domain:(unsigned int)mask;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6:03/26/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	return [self setContextValue:object forKey:aKey fileKey:fileKey domain:mask];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setContextValue:forKey:fileKey:domain:
- (unsigned int)setContextValue:(id)object forKey:(NSString *)aKey fileKey:(NSString *)fileKey domain:(unsigned int)mask;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6:03/26/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSParameterAssert(aKey != nil);
	NSString * fileName = [self relativeFileNameForKey:fileKey];// not the file name!
	if(![fileName length] && ![fileKey isEqual:iTM2ProjectDefaultsKey] && ![fileKey isEqual:@"."])
	{
		return NO;
	}
	unsigned int didChange = 0;
	if(mask & iTM2ContextStandardLocalMask)
	{
		if([self takeMetaInfo:object forKeyPaths:iTM2ProjectContextKeyedFilesKey,fileKey,aKey,nil])
		{
			didChange |= iTM2ContextStandardProjectMask;
		}
	}
	if(mask & iTM2ContextStandardProjectMask)
	{
		fileKey = iTM2ProjectDefaultsKey;
		if([self takeMetaInfo:object forKeyPaths:iTM2ProjectContextKeyedFilesKey,fileKey,aKey,nil])
		{
			didChange |= iTM2ContextStandardProjectMask;
		}
	}
	if(mask & iTM2ContextExtendedProjectMask)
	{
		NSString * extension = [fileName pathExtension];
		if([extension length])
		{
			if([self takeMetaInfo:object forKeyPaths:iTM2ContextExtensionsKey,extension,aKey,nil])
			{
				didChange |= iTM2ContextExtendedProjectMask;
			}
			NSString * typeFromFileExtension = [SDC typeFromFileExtension:extension];
			if([typeFromFileExtension length])
			{
				if([self takeMetaInfo:object forKeyPaths:iTM2ContextTypesKey,typeFromFileExtension,aKey,nil])
				{
					didChange |= iTM2ContextExtendedProjectMask;
				}
			}
		}
	}
    return didChange;
}
#pragma mark =-=-=-=-=-  OTHER
- (id)otherInfos;
{
	id result = metaGETTER;
	if(!result)
	{
		result = [[[iTM2InfoWrapper allocWithZone:[self zone]] init] autorelease];
		metaSETTER(result);
		[IMPLEMENTATION takeMetaValue:nil forKey:@"MutableInfos"];// next time mutableInfos is called, it will make a mutable copy of otherInfos
		NSError * outError;
		NSURL * url = [SPC projectFrontendInfoURLFromFileURL:[self fileURL] create:NO error:&outError];
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
#pragma mark =-=-=-=-=-  CUSTOM
- (id)customInfos;
{
	id result = metaGETTER;
	if(!result)
	{
		result = [[[iTM2InfoWrapper allocWithZone:[self zone]] init] autorelease];
		metaSETTER(result);
		NSError * outError;
		NSURL * url = [SPC projectCustomInfoURLFromFileURL:[self fileURL] create:NO error:&outError];
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
#pragma mark =-=-=-=-=-  MUTABLE
- (id)mutableInfos;
{
	id result = metaGETTER;
	if(!result)
	{
		result = [[[iTM2InfoWrapper allocWithZone:[self zone]] init] autorelease];
		[result setModel:[[[[self otherInfos] model] iTM2_deepMutableCopy] autorelease]];
		metaSETTER(result);
	}
	return result;
}
#pragma mark =-=-=-=-=-  INFOS CONTROLLER
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

@end

@implementation iTM2Inspector(Infos)
- (NSString *)infosKeyPathPrefix;
{
	return nil;
}
- (id)infosController;// lazy intializer, for the projects
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

@implementation NSObject(Infos)
- (id)metaInfos;
{
	NSAssert(NO,@"! ERROR: Unsupported metaInfos, report bug");
	return nil;
}
- (id)metaInfoForKeyPaths:(NSString *)first,...;
{
	iTM2_VA_LIST_OF_PATHS_TO_ARRAY(first,keys);
	return [[self metaInfos] infoForKeys:keys];
}
- (BOOL)takeMetaInfo:(id)info forKeyPaths:(NSString *)first,...;
{
	iTM2_VA_LIST_OF_PATHS_TO_ARRAY(first,keys);
	return [[self metaInfos] takeInfo:info forKeys:keys];
}
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
- (id)infoForKeyPaths:(NSString *)first,...;
{
	iTM2_VA_LIST_OF_PATHS_TO_ARRAY(first,keys);
	return [[self infosController] infoForKeys:keys];
}
- (BOOL)takeInfo:(id)info forKeyPaths:(NSString *)first,...;
{
	iTM2_VA_LIST_OF_PATHS_TO_ARRAY(first,keys);
	return [[self infosController] takeInfo:info forKeys:keys];
}
- (BOOL)isInfoEditedForKeyPaths:(NSString *)first,...;
{
	iTM2_VA_LIST_OF_PATHS_TO_ARRAY(first,keys);
	return [[self infosController] isInfoEditedForKeys:keys];
}
- (id)inheritedInfoForKeyPaths:(NSString *)first,...;
{
	iTM2_VA_LIST_OF_PATHS_TO_ARRAY(first,keys);
	return [[self infosController] inheritedInfoForKeys:keys];
}
- (id)localInfoForKeyPaths:(NSString *)first,...;
{
	iTM2_VA_LIST_OF_PATHS_TO_ARRAY(first,keys);
	return [[self infosController] localInfoForKeys:keys];
}
- (id)customInfoForKeyPaths:(NSString *)first,...;
{
	iTM2_VA_LIST_OF_PATHS_TO_ARRAY(first,keys);
	return [[self infosController] customInfoForKeys:keys];
}
- (id)editInfoForKeyPaths:(NSString *)first,...;
{
	iTM2_VA_LIST_OF_PATHS_TO_ARRAY(first,keys);
	return [[self infosController] editInfoForKeys:keys];
}
- (void)toggleInfoForKeyPaths:(NSString *)first,...;
{
	iTM2_VA_LIST_OF_PATHS_TO_ARRAY(first,keys);
	BOOL old = [[[self infosController] infoForKeys:keys] boolValue];
	[[self infosController] takeInfo:[NSNumber numberWithBool:!old] forKeys:keys];
}
- (void)backupCustomForKeyPaths:(NSString *)first,...;
{
	iTM2_VA_LIST_OF_PATHS_TO_ARRAY(first,keys);
	[[self infosController] backupCustomForKeys:keys];
	return;
}
- (BOOL)restoreCustomForKeyPaths:(NSString *)first,...;
{
	iTM2_VA_LIST_OF_PATHS_TO_ARRAY(first,keys);
	return [[self infosController] restoreCustomForKeys:keys];
}
- (BOOL)saveChangesForKeyPaths:(NSString *)first,...;
{
	iTM2_VA_LIST_OF_PATHS_TO_ARRAY(first,keys);
	return [[self infosController] saveChangesForKeys:keys];
}
- (BOOL)revertChangesForKeyPaths:(NSString *)first,...;
{
	iTM2_VA_LIST_OF_PATHS_TO_ARRAY(first,keys);
	return [[self infosController] revertChangesForKeys:keys];
}
@end

#import <iTM2Foundation/iTM2FileManagerKit.h>

@implementation iTM2ProjectController(Infos)

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  projectInfoURLFromFileURL:create:error:
- (NSURL *)projectInfoURLFromFileURL:(NSURL *)fileURL create:(BOOL)yorn error:(NSError **)outErrorPtr;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([fileURL isFileURL])
	{
		NSString * path = [fileURL path];
		if([DFM createDeepDirectoryAtPath:path attributes:nil error:outErrorPtr])
		{
			NSString * component = [iTM2ProjectInfoComponent stringByAppendingPathExtension:iTM2ProjectPlistPathExtension];
			path = [path stringByAppendingPathComponent:component];
			fileURL = [NSURL fileURLWithPath:path];
			return fileURL;
		}
	}
	else
	{
		iTM2_OUTERROR(1,([NSString stringWithFormat:@"File URL expected, instead of\n%@",fileURL]),nil);
	}
//iTM2_END;
    return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  projectFrontendInfoURLFromFileURL:create:error:
- (NSURL *)projectFrontendInfoURLFromFileURL:(NSURL *)fileURL create:(BOOL)yorn error:(NSError **)outErrorPtr;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([fileURL isFileURL])
	{
		NSString * fileName = [fileURL path];
		NSString * path = [[NSBundle mainBundle] bundleIdentifier];
		path = [TWSFrontendComponent stringByAppendingPathComponent:path];
		path = [fileName stringByAppendingPathComponent:path];
		if([DFM createDeepDirectoryAtPath:path attributes:nil error:outErrorPtr])
		{
			NSString * component = [iTM2ProjectInfoComponent stringByAppendingPathExtension:iTM2ProjectPlistPathExtension];
			path = [path stringByAppendingPathComponent:component];
			fileURL = [NSURL fileURLWithPath:path];
			return fileURL;
		}
	}
	else
	{
		iTM2_OUTERROR(1,([NSString stringWithFormat:@"File URL expected, instead of\n%@",fileURL]),nil);
	}
//iTM2_END;
    return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  projectMetaInfoURLFromFileURL:create:error:
- (NSURL *)projectMetaInfoURLFromFileURL:(NSURL *)fileURL create:(BOOL)yorn error:(NSError **)outErrorPtr;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([fileURL isFileURL])
	{
		NSString * fileName = [fileURL path];
		NSString * path = [[NSBundle mainBundle] bundleIdentifier];
		path = [TWSFrontendComponent stringByAppendingPathComponent:path];
		path = [fileName stringByAppendingPathComponent:path];
		if([DFM createDeepDirectoryAtPath:path attributes:nil error:outErrorPtr])
		{
			NSString * component = [iTM2ProjectMetaInfoComponent stringByAppendingPathExtension:iTM2ProjectPlistPathExtension];
			path = [path stringByAppendingPathComponent:component];
			fileURL = [NSURL fileURLWithPath:path];
			return fileURL;
		}
	}
	else
	{
		iTM2_OUTERROR(1,([NSString stringWithFormat:@"File URL expected, instead of\n%@",fileURL]),nil);
	}

//iTM2_END;
    return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  projectCustomInfoURLFromFileURL:create:error:
- (NSURL *)projectCustomInfoURLFromFileURL:(NSURL *)fileURL create:(BOOL)yorn error:(NSError **)outErrorPtr;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([fileURL isFileURL])
	{
		NSString * fileName = [fileURL path];
		NSString * path = [[NSBundle mainBundle] bundleIdentifier];
		path = [TWSFrontendComponent stringByAppendingPathComponent:path];
		path = [fileName stringByAppendingPathComponent:path];
		if([DFM createDeepDirectoryAtPath:path attributes:nil error:outErrorPtr])
		{
			NSString * component = [iTM2ProjectCustomInfoComponent stringByAppendingPathExtension:iTM2ProjectPlistPathExtension];
			path = [path stringByAppendingPathComponent:component];
			fileURL = [NSURL fileURLWithPath:path];
			return fileURL;
		}
	}
	else
	{
		iTM2_OUTERROR(1,([NSString stringWithFormat:@"File URL expected, instead of\n%@",fileURL]),nil);
	}

//iTM2_END;
    return nil;
}
@end