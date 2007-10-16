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
#import <iTM2Foundation/iTM2ProjectDocumentKit.h>
#import <iTM2Foundation/iTM2ProjectControllerKit.h>
#import <iTM2Foundation/iTM2Implementation.h>

NSString * const TWSSourceKey = @"source";
NSString * const TWSKeyedPropertiesKey = @"properties";
NSString * const TWSKeyedFilesKey = @"files";

NSString * const iTM2InfoWrapperType = @"iTM2 Property list wrapper";

static NSString * const iTM2ProjectLastKeyKey = @"_LastKey";

@implementation iTM2InfoWrapper
- (id)init;
{
	if(self = [super init])
	{
		[self setModel:[NSDictionary dictionary]];
	}
	return self;
}
- (BOOL)readFromURL:(NSURL *)absoluteURL options:(unsigned)readOptionsMask error:(NSError **)outErrorPtr;
{
	NSData * data = [NSData dataWithContentsOfURL:absoluteURL options:readOptionsMask error:outErrorPtr];
	if(data)
	{
		id model = [NSDictionary dictionaryWithContentsOfURL:absoluteURL];
		if(model)
		{
			[self setModel:model];
			return YES;
		}
		iTM2_OUTERROR(1,([NSString stringWithFormat:@"! ERROR while reading the property list at %@", absoluteURL]),nil);
	}
	return NO;
}
- (BOOL)writeToURL:(NSURL *)absoluteURL options:(unsigned)flags error:(NSError **)outErrorPtr;
{
	[myMODEL takeValue:iTM2ProjectInfoType forKey:@"isa"];
	if([myMODEL writeToURL:absoluteURL atomically:flags&NSAtomicWrite])
	{
		return YES;
	}
	 // the atomically flag is ignored if url of a type that cannot be written atomically.
	iTM2_OUTERROR(3,([NSString stringWithFormat:@"Could not write to\n%@",absoluteURL]),nil);
	return NO;
}
- (id)model;
{
	return metaGETTER;
}
- (void)setModel:(id)model;
{
	// make a mutable deep copy.
	// if this can't be done, it is not a valid property list
	// the programmer should be responsible of what he is doing but there is no safety guard here
	// get a data object
	if(!model)
	{
		metaSETTER(model);
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
- (id)baseModel;
{
	return metaGETTER;
}
- (void)setBaseModel:(id)model;
{
	metaSETTER(model);
	return;
}
- (id)modelValueForKeyPath:(NSString *)path;
{
	NSArray * Ks = [path componentsSeparatedByString:@"."];
	NSEnumerator * E = [Ks objectEnumerator];
	NSString * K;
	id result;
	id model = [self model];
	while(K = [E nextObject])
	{
		result = [model objectForKey:K];
		model = [result isKindOfClass:[NSDictionary class]]?result:nil;
	}
	if(result)
		return result;
	E = [Ks objectEnumerator];
	model = [self baseModel];
	while(K = [E nextObject])
	{
		result = [model objectForKey:K];
		model = [result isKindOfClass:[NSDictionary class]]?result:nil;
	}
	return result;
}
- (id)takeModelValue:(id)value forKeyPath:(NSString *)path;
{
	metaSETTER(model);
	return;
}
@end

@implementation iTM2ProjectInfoWrapper

- (NSString *)sourceDirectory;
{
	return [myMODEL valueForKey:TWSSourceKey]?:@".";
}
- (void)setSourceDirectory:(NSString *)path;
{
	[myMODEL takeValue:path forKey:TWSSourceKey];
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
    id result = [myMODEL valueForKey:TWSKeyedFilesKey];
    if(!result)
    {
        [myMODEL takeValue:[NSMutableDictionary dictionary] forKey:TWSKeyedFilesKey];
        result = [myMODEL valueForKey:TWSKeyedFilesKey];
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
	[[self keyedFileNames] takeValue:path forKey:key];
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  allKeys
- (NSArray *)allKeys;
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  keyedProperties
- (id)keyedProperties;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    id result = [myMODEL valueForKey:TWSKeyedPropertiesKey];
    if(!result)
    {
        [myMODEL takeValue:[NSMutableDictionary dictionary] forKey:TWSKeyedPropertiesKey];
        result = [myMODEL valueForKey:TWSKeyedPropertiesKey];
    }
    return result;
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
    id Ps = [self keyedProperties];
    id result = [Ps valueForKey:key];
    if(!result)
    {
        [Ps takeValue:[NSMutableDictionary dictionary] forKey:key];
        result = [Ps valueForKey:key];
    }
    return result;
}
- (void)takeProperties:(id)properties forFileKey:(NSString *)key;
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [[self keyedProperties] takeValue:[[properties mutableCopy] autorelease] forKey:key];
    return;
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
	if(key = [keyedFileNames valueForKey:iTM2ProjectLastKeyKey])
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
@end

@implementation iTM2FrontendInfoWrapper

@end
