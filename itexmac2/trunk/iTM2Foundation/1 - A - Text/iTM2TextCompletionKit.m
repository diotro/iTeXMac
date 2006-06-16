/*
//
//  @version Subversion: $Id$ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Wed Apr 12 20:12:28 GMT 2006.
//  Copyright © 2006 Laurens'Tribune. All rights reserved.
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
//  Version history: (format "- date:contribution(contributor)") 
//  To Do List: (format "- proposition(percentage actually done)")
*/

#import <iTM2Foundation/iTM2TextCompletionKit.h>
#import <iTM2Foundation/iTM2BundleKit.h>
#import <iTM2Foundation/iTM2FileManagerKit.h>

NSString * const iTM2CompletionsDirectoryName = @"Completions.localized";
NSString * const iTM2CompletionsExtension = @"iTM2Completions";

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2TextCompletionKit
static id _iTM2_CompletionsServer_Data = nil;
@implementation iTM2CompletionsServer
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  reloadCompletions
+(void)reloadCompletions;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 02/03/2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
	iTM2_INIT_POOL;
//iTM2_START;
	if(!_iTM2_CompletionsServer_Data)
		_iTM2_CompletionsServer_Data = [[NSMutableDictionary dictionary] retain];
	// read the built in stuff
	// inside frameworks then bundles.
	NSArray * frameworks = [NSBundle allFrameworks];
	NSMutableArray * plugins = [NSMutableArray arrayWithArray:[NSBundle allBundles]];
	[plugins removeObjectsInArray:frameworks];// plugins are bundles
	NSBundle * mainBundle = [NSBundle mainBundle];
	[plugins removeObject:mainBundle];// plugins are bundles, except the main one
	// sorting the frameworks and plugins
	// separating them according to their domain
	NSString * networkPrefix = [[mainBundle pathForSupportDirectory:@"" inDomain:NSNetworkDomainMask create:NO] stringByAppendingString:iTM2PathComponentsSeparator];
	NSString * localPrefix = [[mainBundle pathForSupportDirectory:@"" inDomain:NSLocalDomainMask create:NO] stringByAppendingString:iTM2PathComponentsSeparator];
	NSString * userPrefix = [[mainBundle pathForSupportDirectory:@"" inDomain:NSUserDomainMask create:NO] stringByAppendingString:iTM2PathComponentsSeparator];
	
	NSMutableArray * networkFrameworks = [NSMutableArray array];
	NSMutableArray * localFrameworks = [NSMutableArray array];
	NSMutableArray * userFrameworks = [NSMutableArray array];
	NSMutableArray * otherFrameworks = [NSMutableArray array];
	NSEnumerator * E = [frameworks objectEnumerator];
	NSBundle * B = nil;
	while(B = [E nextObject])
	{
		NSString * P = [B bundlePath];
		if([P hasPrefix:userPrefix])
			[userFrameworks addObject:B];
		else if([P hasPrefix:localPrefix])
			[localFrameworks addObject:B];
		else if([P hasPrefix:networkPrefix])
			[networkFrameworks addObject:B];
		else
			[otherFrameworks addObject:B];
	}
	NSMutableArray * networkPlugIns = [NSMutableArray array];
	NSMutableArray * localPlugIns = [NSMutableArray array];
	NSMutableArray * userPlugIns = [NSMutableArray array];
	NSMutableArray * otherPlugIns = [NSMutableArray array];
	E = [frameworks objectEnumerator];
	while(B = [E nextObject])
	{
		NSString * P = [B bundlePath];
		if([P hasPrefix:userPrefix])
			[userPlugIns addObject:B];
		else if([P hasPrefix:localPrefix])
			[localPlugIns addObject:B];
		else if([P hasPrefix:networkPrefix])
			[networkPlugIns addObject:B];
		else
			[otherPlugIns addObject:B];
	}
	// reload
	#define RELOAD(ARRAY)\
	E = [ARRAY objectEnumerator];\
	while(B = [E nextObject]) [self reloadCompletionsAtPath:[B pathForResource:iTM2CompletionsDirectoryName ofType:nil]];
	RELOAD(otherFrameworks);
	RELOAD(otherPlugIns);
	[self reloadCompletionsAtPath:
		[mainBundle pathForResource:iTM2CompletionsDirectoryName ofType:nil]];
	RELOAD(networkFrameworks);
	RELOAD(networkPlugIns);
	[self reloadCompletionsAtPath:
		[mainBundle pathForSupportDirectory:iTM2CompletionsDirectoryName inDomain:NSNetworkDomainMask create:NO]];
	RELOAD(localFrameworks);
	RELOAD(localPlugIns);
	[self reloadCompletionsAtPath:
		[mainBundle pathForSupportDirectory:iTM2CompletionsDirectoryName inDomain:NSLocalDomainMask create:NO]];
	RELOAD(userFrameworks);
	RELOAD(userPlugIns);
	[self reloadCompletionsAtPath:
		[mainBundle pathForSupportDirectory:iTM2CompletionsDirectoryName inDomain:NSUserDomainMask create:YES]];
	#undef RELOAD
//iTM2_END;
	iTM2_RELEASE_POOL;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  reloadCompletionsAtPath:
+(void)reloadCompletionsAtPath:(NSString *)path;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 02/03/2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
	if(![path length])
		return;
	if(!_iTM2_CompletionsServer_Data)
		_iTM2_CompletionsServer_Data = [[NSMutableDictionary dictionary] retain];
	//path is expected to be the full path of a "Completions.localized" directory
	iTM2_INIT_POOL;
//iTM2_START;
	// We find all the .iTM2Completions files inside
	// those are xml file wonforming to the iTM2Completions DTD
	// then read them and append the result to the server data base.
	// The first directory level defines the category
	// the second directory level declares the context
	// All files below are merged into one database
	NSDirectoryEnumerator * DE = [DFM enumeratorAtPath:path];
	NSString * category = nil;
	NSArray * RA = nil;
	NSError * localError = nil;
	while(category = [DE nextObject])
	{
		NSString * subpath = [path stringByAppendingPathComponent:category];
		if([[category pathExtension] isEqual:iTM2CompletionsExtension])
		{
			if(RA = [self completionsWithContentsOfURL:[NSURL fileURLWithPath:subpath] error:&localError])
			{
				[self addCompletions:RA forContext:@"" ofCategory:@""];
			}
			else
			{
				iTM2_REPORTERROR(1, ([NSString stringWithFormat:@"Bad completions at path:",subpath]),localError);
			}
		}
		else
		{
			NSDirectoryEnumerator * de = [DFM enumeratorAtPath:subpath];
			NSString * context = nil;
			while(context = [de nextObject])
			{
				subpath = [subpath stringByAppendingPathComponent:context];
				if([[context pathExtension] isEqual:iTM2CompletionsExtension])
				{
					if(RA = [self completionsWithContentsOfURL:[NSURL fileURLWithPath:subpath] error:&localError])
					{
						[self addCompletions:RA forContext:@"" ofCategory:category];
					}
					else
					{
						iTM2_REPORTERROR(1, ([NSString stringWithFormat:@"Bad completions at path:",subpath]),localError);
					}
				}
				else
				{
					NSDirectoryEnumerator * subde = [DFM enumeratorAtPath:subpath];
					NSString * relativePath = nil;
					while(relativePath = [subde nextObject])
					{
						if([[relativePath pathExtension] isEqual:iTM2CompletionsExtension])
						{
							NSString * fullPath = [subpath stringByAppendingPathComponent:relativePath];
							if(RA = [self completionsWithContentsOfURL:[NSURL fileURLWithPath:fullPath] error:&localError])
							{
								[self addCompletions:RA forContext:context ofCategory:category];
							}
							else
							{
								iTM2_REPORTERROR(1, ([NSString stringWithFormat:@"Bad completions at path:",fullPath]),localError);
							}
						}
					}// while(relativePath = [subde nextObject])
				}
			}// while(context = [de nextObject])
		}
	}// while(category = [DE nextObject])
//iTM2_END;
	iTM2_RELEASE_POOL;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= addCompletions:forContext:ofCategory:
+(void)addCompletions:(NSArray *)completions forContext:(NSString *)context ofCategory:(NSString *)category;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSMutableDictionary * MD = [self storageForContext:context ofCategory:category];
	NSMutableDictionary * allCompletions = [MD objectForKey:@"Completions"];
	if(!allCompletions)
	{
		allCompletions = [NSMutableDictionary dictionary];
		[MD setObject:allCompletions forKey:@"Completions"];
	}
	NSEnumerator * E = [completions objectEnumerator];
	NSString * completion = nil;
	while(completion = [E nextObject])
	{
		if([completion length] > 2)
		{
			NSRange R = NSMakeRange(0,2);
			NSString * prefix = [completion substringWithRange:R];
			NSMutableArray * ra = [allCompletions objectForKey:prefix];
			if(!ra)
			{
				ra = [NSMutableArray array];
				[allCompletions setObject:ra forKey:prefix];
			}
			// insert it at the right location
			int index = 0;
once_more_joe:
			if(index < [ra count])
			{
				if([[ra objectAtIndex:index] compare:(id)completion] == NSOrderedDescending)
				{
					[ra insertObject:completion atIndex:index];
				}
				else
				{
					++index;
					goto once_more_joe;
				}
			}
			else
			{
				[ra insertObject:completion atIndex:index];
			}
		}
	}
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= storageForContext:ofCategory:
+(id)storageForContext:(NSString *)context ofCategory:(NSString *)category;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSMutableDictionary * MD = [_iTM2_CompletionsServer_Data objectForKey:category];
	if(!MD)
	{
		MD = [NSMutableDictionary dictionary];
		[_iTM2_CompletionsServer_Data setObject:MD forKey:category];
	}
	NSMutableDictionary * result = [MD objectForKey:context];
	if(!result)
	{
		result = [NSMutableDictionary dictionary];
		[MD setObject:result forKey:context];
	}
//iTM2_END;
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  completionsWithContentsOfURL:error:
+(NSArray *)completionsWithContentsOfURL:(NSURL *)url error:(NSError **)outError;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 02/03/2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSXMLDocument * doc = [[[NSXMLDocument alloc] initWithContentsOfURL:url options:NSXMLNodeOptionsNone error:outError] autorelease];
	NSArray * nodes = [doc nodesForXPath:@"//STRING" error:outError];
	NSEnumerator * E = [nodes objectEnumerator];
	id node;
	NSMutableArray * result = [NSMutableArray array];
	while(node = [E nextObject])
	{
		NSString * string = [node stringValue];
		if([string length]>2)
		{
			[result addObject:string];
		}
	}
//iTM2_END;
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  completionsForPartialWord:inContext:ofCategory:
+(NSArray *)completionsForPartialWord:(NSString *)partialWord inContext:(NSString *)context ofCategory:(NSString *)category;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 02/03/2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([partialWord length]<3)
	{
		return [NSArray array];
	}
	NSMutableDictionary * MD = [self storageForContext:context ofCategory:category];
	NSMutableDictionary * allCompletions = [MD objectForKey:@"Completions"];
	NSRange R = NSMakeRange(0, 2);
	NSString * substring = [partialWord substringWithRange:R];
	NSArray * ra = [allCompletions objectForKey:substring];	
	unsigned partialWordLength = [partialWord length];
	R.location = 2;
	R.length = partialWordLength - 2;
	NSEnumerator * E = [ra objectEnumerator];
	NSString * candidate = nil;
	NSMutableArray * result = [NSMutableArray array];
	while(candidate = [E nextObject])
	{
		if([candidate  length] >= partialWordLength)
		{
			NSString * substring = [candidate substringWithRange:R];
			if([substring isEqual:partialWord])
			{
				[result addObject:substring];
			}
		}
	}
//iTM2_END;
    return result;
}
@end

#import <iTM2Foundation/iTM2TextDocumentKit.h>

/*"Description forthcoming."*/
@implementation iTM2TextEditor(iTM2TextCompletionKit)
#if 0
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  complete:
-(void)complete:(id)sender;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 02/03/2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  rangeForUserCompletion
-(NSRange)rangeForUserCompletion;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 02/03/2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return [super rangeForUserCompletion];
}
#endif
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  completionsForPartialWordRange:indexOfSelectedItem:
-(NSArray *)completionsForPartialWordRange:(NSRange)charRange indexOfSelectedItem:(int *)index;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 02/03/2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSArray * RA = [super completionsForPartialWordRange:(NSRange)charRange indexOfSelectedItem:(int *)index];
	// RA contains words no longer that charRange, which is a mess for completion...
	if(charRange.length>0)
	{
		NSString * context = @"";
		NSString * category = @"";
		[self getContext:&context category:&category forPartialWordRange:(NSRange)charRange];
		NSString * partialWord = [[self string] substringWithRange:charRange];
		NSArray * ra = [iTM2CompletionsServer
			completionsForPartialWord:partialWord inContext:context ofCategory:category];
		if([ra count])
		{
			if(index)
			{
				*index = 0;
			}
			return [ra arrayByAddingObjectsFromArray:RA];
		}
	}
//iTM2_END;
    return RA;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  getContext:category:forPartialWordRange:
-(BOOL)getContext:(NSString **)contextPtr category:(NSString **)categoryPtr forPartialWordRange:(NSRange)charRange;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 02/03/2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(contextPtr)
	{
		*contextPtr = @"";
	}
	if(categoryPtr)
	{
		*categoryPtr = @"";
	}
//iTM2_END;
    return YES;
}
#if 0
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertCompletion:forPartialWordRange:movement:isFinal:
-(void)insertCompletion:(NSString *)word forPartialWordRange:(NSRange)charRange movement:(int)movement isFinal:(BOOL)flag;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 02/03/2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return;
}
#endif
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2TextCompletionKit

