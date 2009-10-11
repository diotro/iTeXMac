/*
//
//  @version Subversion: $Id$ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Mon May 10 22:45:25 GMT 2004.
//  Copyright © 2004 Laurens'Tribune. All rights reserved.
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

#import <iTM2Foundation/iTM2InstallationKit.h>
#import <iTM2Foundation/iTM2Implementation.h>
#import <iTM2Foundation/iTM2RuntimeBrowser.h>
#import <iTM2Foundation/iTM2BundleKit.h>
#import <iTM2Foundation/iTM2Invocation.h>

NSString * const iTM2ItemPropertyListXMLFormatKey = @"iTM2ItemPropertyListXMLFormat";
NSString * const iTM2MainType = @"main";

@interface NSObject(PRIVATE)

/*!
	@method		_DataRepresentations
	@abstract	The data representations of the receiver.
	@discussion	Assuming that the receiver is able to store different data representation
				depending on the type.
				This can be useful for wrappers when there is only one representation for a given document type.
				When a wrapper can contain many different data with the same type,
				this implementation is not convenient if we restrict ourselves to the "type" meaning given by the AppKit.
				But we can perfectly use this type just as a key.
				Concretely, documents will parse their directory wrappers and assign keys to the different files
				(maybe the last path component...)
	@result		a mutable dictionary object.
*/
- (id)_DataRepresentations;

@end

#import <objc/objc-runtime.h>
#import <objc/objc-class.h>
#import <objc/objc.h>

@implementation NSObject(iTM2Implementation)
#pragma mark =-=-=-=-=-  IMPLEMENTATION
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  load
+ (void)load;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
	iTM2_INIT_POOL;
	iTM2RedirectNSLogOutput();
//iTM2_START;
	[NSObject iTM2_swizzleInstanceMethodSelector:@selector(SWZ_iTM2Impl_valueForUndefinedKey:)];
	[NSObject iTM2_swizzleInstanceMethodSelector:@selector(SWZ_iTM2Impl_setValue:forUndefinedKey:)];
//iTM2_END;
	iTM2_RELEASE_POOL;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  SWZ_iTM2Impl_valueForUndefinedKey:
- (id)SWZ_iTM2Impl_valueForUndefinedKey:(NSString *)key;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([key hasSuffix:@"_meta"])
	{
		NSRange range = NSMakeRange(0,[key length]-5);
		if(range.length)
		{
			NSString * path = [key substringWithRange:range];
			path = [@"implementation.metaValues" stringByAppendingPathExtension:path];
			return [self valueForKeyPath:path];
		}
	}
	else if([key isEqual:@"metaValues"])
	{
		return [self valueForKeyPath:@"implementation.metaValues"];
	}
	id model = [[self class] defaultModel];
	return [model objectForKey:key]?
		[[self implementation] modelValueForKey:key ofType:iTM2MainType]:
		[self SWZ_iTM2Impl_valueForUndefinedKey:key];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  SWZ_iTM2Impl_setValue:forUndefinedKey:
- (void)SWZ_iTM2Impl_setValue:(id)value forUndefinedKey:(NSString *)key;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([key hasSuffix:@"_meta"])
	{
		NSRange range = NSMakeRange(0,[key length]-5);
		if(range.length)
		{
			NSString * path = [key substringWithRange:range];
			path = [@"implementation.metaValues" stringByAppendingPathExtension:path];
			[self willChangeValueForKey:key];
			[self setValue:value forKeyPath:path];
			[self didChangeValueForKey:key];
			return;
		}
	}
	else if([key isEqual:@"metaValues"])
	{
		[self setValue:value forKeyPath:@"implementation.metaValues"];
		return;
	}
	if([[[self class] defaultModel] objectForKey:key])
	{
		[self willChangeValueForKey:key];
		[[self implementation] takeModelValue:value forKey:key ofType:iTM2MainType];
		[self didChangeValueForKey:key];
	}
	else
		[self SWZ_iTM2Impl_setValue:(id) value forUndefinedKey:(NSString *) key];
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initImplementation
- (void)initImplementation;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon May 10 22:45:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self setImplementation:[self lazyImplementation]];
	[self fixImplementation];
    [self observeImplementation];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  fixImplementation
- (void)fixImplementation;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon May 10 22:45:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[[self implementation] takeModel:[[[self class] defaultModel] mutableCopy] ofType:iTM2MainType];
	NSInvocation * I;
	[[NSInvocation iTM2_getInvocation:&I withTarget:self retainArguments:NO] fixImplementation];
	[I iTM2_invokeWithSelectors:[iTM2RuntimeBrowser instanceSelectorsOfClass:isa withSuffix:@"FixImplementation" signature:[I methodSignature] inherited:YES]];
   return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  observeImplementation
- (void)observeImplementation;
/*"
Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [IMPNC removeObserver:self];
	NSString * suffix = @"ModelObjectDidChangeNotified:";
    NSHashEnumerator HE = NSEnumerateHashTable([iTM2RuntimeBrowser instanceSelectorsOfClass:[self class] withSuffix:suffix signature:nil inherited:YES]);
	SEL selector;
	while(selector = NSNextHashEnumeratorItem(&HE))
    {
		NSString * S = NSStringFromSelector(selector);
		[IMPNC addObserver:self
			selector: selector
				name: [S substringWithRange:NSMakeRange(0, [S length] - [suffix length])]
					object: [self implementation]];
    }
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  implementation
- (id)implementation;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon May 10 22:45:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  lazyImplementation
- (id)lazyImplementation;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon May 10 22:45:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [[[iTM2Implementation alloc] initWithOwner:self] autorelease];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setImplementation:
- (void)setImplementation:(id)argument;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon May 10 22:45:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(iTM2DebugEnabled)
	{
		iTM2_LOG(@"THIS DEFAULT IMPLEMENTATION DOES NOTHING, BEWARE...");
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  replaceImplementation:
- (void)replaceImplementation:(id)argument;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon May 10 22:45:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    id old = [self implementation];
    if(old != argument)
    {
        [self implementationWillChange];
        [self setImplementation:argument];
        [self implementationDidChange];
    }
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  implementationWillChange
- (void)implementationWillChange;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon May 10 22:45:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  implementationDidChange
- (void)implementationDidChange;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon May 10 22:45:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [[self implementation] setOwner:self];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  defaultModel
+ (NSDictionary *)defaultModel;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	return [NSDictionary dictionary];
}
@end

@interface iTM2Implementation(PRIVATE1)
+ (void)_cleanDictionary:(id)MD;
- (id)_PropertyLists;
- (void)checkPropertyList:(id)PL againstFormat:(NSPropertyListFormat)format;
@end
@implementation iTM2Implementation
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initialize
+ (void)initialize;
/*"Designated Initializer.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: Thu Oct 10 2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
	iTM2_INIT_POOL;
//iTM2_START;
    [super initialize];
    static BOOL firstTime = YES;
    if(firstTime)
    {
        firstTime = NO;
        [SUD registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithInt:NSPropertyListXMLFormat_v1_0], iTM2ItemPropertyListXMLFormatKey,
                nil]];
        Class C = NSClassFromString(@"NSKeyBindings");
        SEL S = @selector(suppressCapitalizedKeyWarning);
        if([C respondsToSelector:S]) [(id)C performSelector:S];
    }
//iTM2_END;
	iTM2_RELEASE_POOL;
    return;
}
#if 0
static NSMutableDictionary * tracker;
static int trackerTag = 0;
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initWithOwner:
- (id)initWithOwner:(id)owner;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(self = [super init])
    {
        [self setOwner:owner];
    }
	if(!tracker)
		tracker = [[NSMutableDictionary dictionary] retain];
//if([@"iTM2TaskController" isEqual:NSStringFromClass([owner class])])
{iTM2_DIAGNOSTIC;
[tracker setObject:[NSValue valueWithNonretainedObject:self] forKey:[NSNumber numberWithInt:++trackerTag]];
//iTM2_LOG(@">>>>>>>>>  New implementation: %i, %@", trackerTag , owner);
}
    return self;
}
#else
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initWithOwner:
- (id)initWithOwner:(id)owner;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(self = [super init])
    {
        [self setOwner:owner];
    }
    return self;
}
#endif
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  owner
- (id)owner;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: Thu Oct 10 2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return _Owner;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setOwner:
- (void)setOwner:(id)argument;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: Thu Oct 10 2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    _Owner = argument;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  root
- (id)root;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: Thu Oct 10 2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    id result = _Parent;
    id P;
    while([result respondsToSelector:@selector(implementation)] && (P = [[result implementation] parent]))
        result = P;
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  implementation
- (id)implementation;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: Thu Oct 10 2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  name
- (id)name;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: Thu Oct 10 2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [_Owner respondsToSelector:@selector(fileName)]?
        [_Owner fileName]:(metaGETTER?:@"");
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setFileName:
- (void)setName:(id)argument;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: Thu Oct 10 2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(![_Owner respondsToSelector:@selector(setFileName:)])
        metaSETTER(argument);
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  modelType
- (id)modelType;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: Thu Oct 10 2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [_Owner respondsToSelector:@selector(modelType)]?
        [_Owner modelType]:(metaGETTER?:@"");
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setModelType:
- (void)setModelType:(id)argument;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: Thu Oct 10 2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(![_Owner respondsToSelector:@selector(setModelType:)])
        metaSETTER(argument);
    return;
}
#pragma mark =-=-=-=-=-=-=-=-=-=-  META
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  metaValues
- (id)metaValues;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: Thu Oct 10 2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(!_MetaValueDictionary)
	{
		_MetaValueDictionary = [[NSMutableDictionary dictionary] retain];
		if(iTM2DebugEnabled)
		{
			iTM2_LOG(@"metaValues available");
		}
	}
//iTM2_START;
    return _MetaValueDictionary;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeMetaValues:
- (void)takeMetaValues:(NSDictionary *)argument;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: Thu Oct 10 2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[_MetaValueDictionary autorelease];
	_MetaValueDictionary = [argument mutableCopy];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  metaValueForKey:
- (id)metaValueForKey:(NSString *)key;
/*"Basic getter.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: Thu Oct 10 2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [_MetaValueDictionary valueForKey:key];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  metaFlagForKey:
- (BOOL)metaFlagForKey:(NSString *)key;
/*"Basic getter.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: Thu Oct 10 2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [[_MetaValueDictionary valueForKey:key] boolValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeMetaValue:forKey:
- (void)takeMetaValue:(id)argument forKey:(NSString *)key;
/*"Basic getter.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: Thu Oct 10 2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if([key respondsToSelector:@selector(copy)])
    {
        if(!_MetaValueDictionary)
            _MetaValueDictionary = [[NSMutableDictionary dictionary] retain];
        [_MetaValueDictionary takeValue:argument forKey:key];// SIGTRAP received 
    }
    else
    {
        iTM2_LOG(@"WARNING: a bad key was given, this might be intentionnal but I doubt.");
        NSLog(@"WARNING: Report as a bug in case of further problem.");
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeMetaFlag:forKey:
- (void)takeMetaFlag:(BOOL)yorn forKey:(NSString *)key;
/*"Basic getter.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: Thu Oct 10 2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self takeMetaValue:[NSNumber numberWithBool:yorn] forKey:key];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  metaValueForKeyPath:
- (id)metaValueForKeyPath:(NSString *)key;
/*"Basic getter.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: Thu Oct 10 2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [_MetaValueDictionary valueForKeyPath:key];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeMetaValue:forKeyPath:
- (void)takeMetaValue:(id)argument forKeyPath:(NSString *)key;
/*"Basic getter.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: Thu Oct 10 2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if([key respondsToSelector:@selector(copy)])
    {
        if(!_MetaValueDictionary)
            _MetaValueDictionary = [[NSMutableDictionary dictionary] retain];
        [_MetaValueDictionary takeValue:argument forKeyPath:key];
    }
    else
    {
        iTM2_LOG(@"WARNING: a bad key was given, this might be intentionnal but I doubt.");
        NSLog(@"WARNING: Report as a bug in case of further problem.");
    }
    return;
}
#pragma mark =-=-=-=-=-=-=-=-=-=-  I/O
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= willSave
- (void)willSave;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon May 10 22:45:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [[self children] makeObjectsPerformSelector:_cmd];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= didSave
- (void)didSave;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon May 10 22:45:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [[self children] makeObjectsPerformSelector:_cmd];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= didRead
- (void)didRead;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon May 10 22:45:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [[self children] makeObjectsPerformSelector:_cmd];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  writeToParentImplementation
- (BOOL)writeToParentImplementation;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed 05 mar 03
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//NSLog(@"data: %@", result);
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  readFromParentImplementation
- (BOOL)readFromParentImplementation;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed 05 mar 03
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//NSLog(@"data: %@", result);
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  _DataRepresentations
- (id)_DataRepresentations;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed 05 mar 03
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//NSLog(@"data: %@", result);
    return _DataRepresentations? _DataRepresentations: (_DataRepresentations = [[NSMutableDictionary dictionary] retain]);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  dataRepresentationTypes
- (NSArray *)dataRepresentationTypes;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed 05 mar 03
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//NSLog(@"data: %@", result);
    return [[self _DataRepresentations] allKeys];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  dataOfType:error:
- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed 05 mar 03
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//NSLog(@"data: %@", result);
	if(outError)
	{
		* outError = nil;
	}
    return [self dataRepresentationOfType:typeName];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  dataRepresentationOfType:
- (NSData *)dataRepresentationOfType:(NSString *)type;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed 05 mar 03
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//NSLog(@"data: %@", result);
    return [[self _DataRepresentations] valueForKey:type];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  readFromData:ofType:error:
- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed 05 mar 03
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(outError)
	{
		* outError = nil;
	}
    return [self loadDataRepresentation:data ofType:typeName];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  loadDataRepresentation:ofType:
- (BOOL)loadDataRepresentation:(NSData *)data ofType:(NSString *)type;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed 05 mar 03
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [[self _DataRepresentations] takeValue:data forKey:type];
    return [[self _DataRepresentations] valueForKey:type] != nil;
}
NSString * const iTM2DataRepresentationsName = @"D";
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  writeToDirectoryWrapper:
- (BOOL)writeToDirectoryWrapper:(NSFileWrapper *)DW;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed 05 mar 03
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    // if there is already a directory wrapper for the receiver.
    BOOL result = NO;
    if([DW isDirectory])
    {
        [[self children] makeObjectsPerformSelector:_cmd withObject:DW];
        NSData * D = [_Owner respondsToSelector:@selector(dataRepresentationOfType:)]
                            && [_Owner respondsToSelector:@selector(modelType)]?
                [_Owner dataRepresentationOfType:[_Owner modelType]]:
                [self dataRepresentationOfType:[self modelType]];
        if(D)
        {
            if([[DW fileWrappers] count])
            {
                [DW removeFileWrapper:[[DW fileWrappers] objectForKey:iTM2DataRepresentationsName]];
                [DW addRegularFileWithContents:D preferredFilename:iTM2DataRepresentationsName];
                result = YES;
            }
        }
    }
    return [self writeToParentImplementation] && result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  readFromDirectoryWrapper:
- (BOOL)readFromDirectoryWrapper:(NSFileWrapper *)DW;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed 05 mar 03
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    BOOL result = [self readFromParentImplementation];
    if([DW isDirectory])
    {
        BOOL result = NO;
        NSFileWrapper * fw = [[DW fileWrappers] objectForKey:iTM2DataRepresentationsName];
        unsigned fireWall = 128;
        while((--fireWall > 0) && [fw isSymbolicLink])
            fw = [[[NSFileWrapper alloc] initWithPath:[fw symbolicLinkDestination]] autorelease];
        if([fw isRegularFile])
        {
			NSString * type = [SDC typeForContentsOfURL:[NSURL fileURLWithPath:[fw preferredFilename]] error:NULL];
            result = result && ([_Owner respondsToSelector:@selector(loadDataRepresentation:)]?
                [_Owner loadDataRepresentation:[fw regularFileContents] ofType:type]:
                [self loadDataRepresentation:[fw regularFileContents] ofType:type]);
        }
    }
    [self updateChildren];
    [[self children] makeObjectsPerformSelector:_cmd withObject:DW];
    return result;
}
#pragma mark =-=-=-=-=-=-=-=  TREE HIERARCHY
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  parent
- (id)parent;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon May 10 22:45:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return _Parent;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setParent:
- (void)setParent:(id)argument;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon May 10 22:45:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    _Parent = argument;
    return;
}
NSString * iTM2ChildrenKey = @"C";
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  childDocuments
- (id)children;
/*"Description Forthcoming. Lazy intilaizer.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon May 10 22:45:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    id result = [self metaValueForKey:iTM2ChildrenKey];
    if(!result)
    {
        [self takeMetaValue:[NSMutableArray array] forKey:iTM2ChildrenKey];
        result = [self metaValueForKey:iTM2ChildrenKey];
    }
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  updateChildren
- (void)updateChildren;
/*"Description Forthcoming. Must be subclassed.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon May 10 22:45:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if([_Owner respondsToSelector:_cmd])
        [_Owner performSelector:_cmd];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  childForName:
- (id)childForName:(NSString *)name;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon May 10 22:45:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSEnumerator * E = [[self children] objectEnumerator];
    id child;
    while(child = [E nextObject])
        if([[child name] isEqualToString:name])
            return child;
    return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  addChild:
- (void)addChild:(id)argument;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon May 10 22:45:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSMutableArray * MRA = [self children];
    if(![MRA containsObject:argument])
    {
        [MRA addObject:argument];
        [[argument implementation] setParent:self];
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  removeChild:
- (void)removeChild:(id)argument;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon May 10 22:45:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSMutableArray * MRA = [self children];
    if([MRA containsObject:argument])
    {
        [MRA removeObject:argument];
        [[argument implementation] setParent:self];
    }
    return;
}
#pragma mark =-=-=-=-=-=-=-=  MODEL
NSString * iTM2PropertyListsNameKey = @" P";
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  _PropertyLists
- (id)_PropertyLists;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: Thu Oct 10 2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    id PLs = [self metaValueForKey:iTM2PropertyListsNameKey];
    if(!PLs)
    {
        [self takeMetaValue:[NSMutableDictionary dictionary] forKey:iTM2PropertyListsNameKey];
        PLs = [self metaValueForKey:iTM2PropertyListsNameKey];
    }
    return PLs;
}
NSString * iTM2PLXMLFormatsNameKey = @" F";
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  _PLXMLFormats
- (id)_PLXMLFormats;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: Thu Oct 10 2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    id formats = [self metaValueForKey:iTM2PLXMLFormatsNameKey];
    if(!formats)
    {
        [self takeMetaValue:[NSMutableDictionary dictionary] forKey:iTM2PLXMLFormatsNameKey];
        formats = [self metaValueForKey:iTM2PLXMLFormatsNameKey];
    }
    return formats;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  modelFormatOfType:
- (NSPropertyListFormat)modelFormatOfType:(NSString *)type;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: Thu Oct 10 2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSNumber * N = [[self _PLXMLFormats] valueForKey:type];
    return N? [N intValue]:[[NSUserDefaults standardUserDefaults] integerForKey:iTM2ItemPropertyListXMLFormatKey];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeModelFormat:ofType:
- (void)takeModelFormat:(NSPropertyListFormat)argument ofType:(NSString *)type;
/*"Description forthcoming. argument is retained. Lazy dataWrapper initializer as side effect.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: Thu Oct 10 2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [[self _PLXMLFormats] takeValue:[NSNumber numberWithInt:argument] forKey:type];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  dataRepresentationOfModelOfType:
- (NSData *)dataRepresentationOfModelOfType:(NSString *)type;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed 05 mar 03
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSString * errorString = nil;
	id PL = [self modelOfType:type];
	if(PL)
	{
		NSPropertyListFormat format = [self modelFormatOfType:type];
		id result = [NSPropertyListSerialization dataFromPropertyList:PL format: format errorDescription: &errorString];
		if(errorString)
		{
			iTM2Beep();
			iTM2_LOG(@"Big problem\nReport BUG ref: iTM2861, error string: '%@' (format: %@)\nAnalyzing the property list",
				errorString, (format == NSPropertyListOpenStepFormat? @"OpenStep": (format == NSPropertyListXMLFormat_v1_0? @"XML": @"binary")));
			[errorString autorelease];
			errorString = nil;
			[self checkPropertyList:PL againstFormat:format];
		}
//NSLog(@"data: %@", result);
		return result;
	}
    return nil;// no model, no data
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  dataRepresentationOfModelOfType:error:
- (NSData *)dataRepresentationOfModelOfType:(NSString *)type error:(NSError**)outErrorPtr;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed 05 mar 03
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(outErrorPtr)
	{
		*outErrorPtr = nil;
	}
    NSString * errorString = nil;
	id PL = [self modelOfType:type];
	if(PL)
	{
		NSPropertyListFormat format = [self modelFormatOfType:type];
		id result = [NSPropertyListSerialization dataFromPropertyList:PL format:format errorDescription:&errorString];
		if(result)
		{
			return result;
		}
		iTM2_OUTERROR(1,
			([NSString stringWithFormat:@"Big problem\nReport BUG ref:iTM2861, error string:'%@' (format:%@)\nAnalyzing the property list (see console)",
				errorString, (format == NSPropertyListOpenStepFormat? @"OpenStep": (format == NSPropertyListXMLFormat_v1_0? @"XML": @"binary"))]),nil);
		[errorString autorelease];
		errorString = nil;
		[self checkPropertyList:PL againstFormat:format];
		return nil;
	}
    return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  checkPropertyList:againstFormat:
- (void)checkPropertyList:(id)PL againstFormat:(NSPropertyListFormat)format;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed 05 mar 03
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([NSPropertyListSerialization propertyList:PL isValidForFormat:format])
		return;
	if([PL isKindOfClass:[NSDictionary class]])
	{
		NSEnumerator * E = [PL keyEnumerator];
		id K;
		while(K = [E nextObject])
		{
			if(![NSPropertyListSerialization propertyList:K isValidForFormat:format])
			{
				iTM2_LOG(@"Bad key: %@ in dictionary %@", K, PL);
			}
			[self checkPropertyList:[PL objectForKey:K] againstFormat:format];
		}
	}
	else if([PL isKindOfClass:[NSArray class]])
	{
		NSEnumerator * E = [PL objectEnumerator];
		id K;
		while(K = [E nextObject])
		{
			[self checkPropertyList:K againstFormat:format];
		}
	}
	else
	{
		iTM2_LOG(@"The object %@ of class %@ is not valid for %@", PL, [PL class], (format == NSPropertyListOpenStepFormat? @"OpenStep":(format == NSPropertyListXMLFormat_v1_0? @"XML":@"binary")));
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  loadModelValueOfDataRepresentation:ofType:
- (BOOL)loadModelValueOfDataRepresentation:(NSData *)data ofType:(NSString *)type;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed 05 mar 03
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if([data length])
    {
        NSString * errorString = nil;
        NSPropertyListFormat format;
        id DM = [NSPropertyListSerialization propertyListFromData:data
            mutabilityOption: NSPropertyListMutableContainersAndLeaves
                format: &format errorDescription: &errorString];
        if(errorString)
        {
            iTM2Beep();
            NSLog(@"Big problem\nReport BUG ref: iTM2168");
            NSLog(@"error string: '%@'", errorString);
            [errorString autorelease];
            errorString = nil;
        }
//NSLog(@"DM: %@", DM);
        if(DM)
        {
//NSLog(@"THE MODEL LOADER IS ABOUT TO REPLACE THE item DATA.......");
            [self takeModelFormat:format ofType:type];
            [self takeModel:DM ofType:type];
            return YES;
        }
    }
	else if(data)
	{
		if(iTM2DebugEnabled)
		{
			iTM2_LOG(@"Loading a void data.");
		}
		[self takeModelFormat:[SUD integerForKey:iTM2ItemPropertyListXMLFormatKey] ofType:type];
		[self takeModel:[NSMutableDictionary dictionary] ofType:type];
		return YES;
	}
	else if(iTM2DebugEnabled)
	{
		iTM2_LOG(@"No data to load.");
	}
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  loadModelValueOfDataRepresentation:ofType:error:
- (BOOL)loadModelValueOfDataRepresentation:(NSData *)data ofType:(NSString *)type error:(NSError**)outErrorPtr;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed 05 mar 03
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if([data length])
    {
        NSString * errorString = nil;
        NSPropertyListFormat format;
        id DM = [NSPropertyListSerialization propertyListFromData:data
            mutabilityOption: NSPropertyListMutableContainersAndLeaves
                format: &format errorDescription: &errorString];
        if(errorString)
        {
			if(outErrorPtr)
			{
				*outErrorPtr = [NSError errorWithDomain:__iTM2_PRETTY_FUNCTION__ code:1
					userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"NSPropertyListSerialization error string:'%@'", errorString]
						forKey:NSLocalizedDescriptionKey]];
			}
			else
			{
				iTM2Beep();
				NSLog(@"Big problem\nReport BUG ref: iTM2168");
				NSLog(@"error string: '%@'", errorString);
				[errorString autorelease];
				errorString = nil;
			}
			return NO;
        }
//NSLog(@"DM: %@", DM);
        if(DM)
        {
//NSLog(@"THE MODEL LOADER IS ABOUT TO REPLACE THE item DATA.......");
            [self takeModelFormat:format ofType:type];
            [self takeModel:DM ofType:type];
            return YES;
        }
    }
	else if(data)
	{
		if(iTM2DebugEnabled)
		{
			iTM2_LOG(@"Loading a void data.");
		}
		[self takeModelFormat:[SUD integerForKey:iTM2ItemPropertyListXMLFormatKey] ofType:type];
		[self takeModel:[NSMutableDictionary dictionary] ofType:type];
		return YES;
	}
	else if(iTM2DebugEnabled)
	{
		iTM2_LOG(@"No data to load.");
	}
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  modelTypes
- (NSArray *)modelTypes;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed 05 mar 03
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [[self _PropertyLists] allKeys];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  modelOfType:
- (id)modelOfType:(NSString *)type;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed 05 mar 03
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSAssert([type length]>0, @"The type key must be non void");
    return [[self _PropertyLists] valueForKey:type];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeModel:ofType:
- (void)takeModel:(id)model ofType:(NSString *)type;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed 05 mar 03
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSAssert([type length]>0, @"The type key must be non void");
//iTM2_LOG(@"Model is: %@", model);
//iTM2_LOG(@"Type is: %@", type);
    [[self _PropertyLists] takeValue:model forKey:type];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  modelValueKeysOfType:
- (NSArray *)modelValueKeysOfType:(NSString *)type;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed 05 mar 03
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [[self modelOfType:type] allKeys];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  modelValueForKey:ofType:
- (id)modelValueForKey:(NSString *)key ofType:(NSString *)type;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed 05 mar 03
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id PLs = [self _PropertyLists];
    id model = [PLs valueForKey:type];
    return [model valueForKey:key];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeModelValue:forKey:ofType:
- (void)takeModelValue:(id)PL forKey:(NSString *)key ofType:(NSString *)type;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed 05 mar 03
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id PLs = [self _PropertyLists];
    id model = [PLs valueForKey:type];
	if(!model)
	{
		[[self _PropertyLists] takeValue:[NSMutableDictionary dictionary] forKey:type];
		model = [PLs valueForKey:type];
	}
    id previous = [model valueForKey:key];// IT MUST BE RETAIN/RELEASE
    if([previous isEqual:PL])
        return;
    if(!previous && !PL)
        return;
	[[previous retain] autorelease];// !!! DANGER:previous will be released below
    [model takeValue:PL forKey:key];
    [IMPNC postNotificationName:iTM2ImplementationDidChangeModelObjectNotification
        object: self userInfo: (previous?
        [NSDictionary dictionaryWithObjectsAndKeys:key, @"key", type, @"type", previous, @"previous", nil]:
        [NSDictionary dictionaryWithObjectsAndKeys:key, @"key", type, @"type", nil])];
    [IMPNC postNotificationName:key object:self
        userInfo: (previous? [NSDictionary dictionaryWithObjectsAndKeys:type, @"type", previous, @"previous", nil]:[NSDictionary dictionaryWithObjectsAndKeys:type, @"type", nil])];
    return;
}
@synthesize _Owner;
@synthesize _Parent;
@synthesize _MetaValueDictionary;
@end

NSString * iTM2KeyFromSelector(SEL selector)
/*"Basic getter.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Feb 25 21:08:18 GMT 2005
To Do List:
"*/
{
	if(!selector)
		return nil;
	char * _selname = (char *)sel_getName(selector);
	int n = strlen(_selname);
	char * selname = NSAllocateCollectable(n+1,0);// + 1 for the \0 termination character
	if(!selname)
	{
		NSLog(@"*** iTM2KeyFromSelector: MISSING MEMORY, report problem");
		return nil;
	}
	if(!strcpy(selname, _selname))
	{
		NSLog(@"*** iTM2KeyFromSelector: COPY MEMORY, report problem");
		free(selname);
		return nil;
	}
	_selname = selname;
	next:
	if(!strncmp(_selname, "get", 3))
	{
		_selname += 3;
		if(n = strlen(_selname))
			goto abacab;
	}
	else if(!strncmp(_selname, "set", 3))
	{
		_selname[n-1] = '\0';
		_selname += 3;
		if((n = strlen(_selname)))
			goto abacab;
	}
	else if(!strncmp(_selname, "take", 4))
	{
		_selname[n-1] = '\0';
		_selname += 4;
		if((n = strlen(_selname)))
			goto abacab;
	}
	else if(!strncmp(_selname, "is", 2))
	{
		_selname += 2;
		if(n = strlen(_selname))
			goto abacab;
	}
	else if(!strncmp(_selname, "_", 1))
	{
		++_selname;
		if(strlen(_selname))
			goto next;
	}
	else if(n = strlen(_selname))
		goto abacab;
	return nil;
abacab:;
    static const char * capitals = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    if((_selname[0]>='a') && (_selname[0]<='z'))
        _selname[0] = capitals[_selname[0]-'a'];
	NSString * K = [NSString stringWithCString:_selname encoding:NSASCIIStringEncoding];
	return K;	
}

@implementation iTM2Implementation(Selector)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  metaValueForSelector:
- (id)metaValueForSelector:(SEL)selector;
/*"Basic getter.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: Thu Oct 10 2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * K = iTM2KeyFromSelector(selector);
	return K? [_MetaValueDictionary valueForKey:K]:nil;	
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeMetaValue:forSelector:
- (void)takeMetaValue:(id)argument forSelector:(SEL)selector;
/*"Basic getter.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: Thu Oct 10 2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(!_MetaValueDictionary)
		_MetaValueDictionary = [[NSMutableDictionary dictionary] retain];
	NSString * K = iTM2KeyFromSelector(selector);
	if(K) [_MetaValueDictionary takeValue:argument forKey:K];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  modelValueForSelector:ofType:
- (id)modelValueForSelector:(SEL)selector ofType:(NSString *)type;
/*"Basic getter.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: Thu Oct 10 2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * K = iTM2KeyFromSelector(selector);
	return K? [[[self _PropertyLists] valueForKey:type] valueForKey:K]:nil;	
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeModelValue:forSelector:ofType:
- (void)takeModelValue:(id)argument forSelector:(SEL)selector ofType:(NSString *)type;
/*"Basic getter.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: Thu Oct 10 2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * K = iTM2KeyFromSelector(selector);
	if([K length])
	{
		NSDictionary * PLs = [self _PropertyLists];
		NSDictionary * model = [PLs valueForKey:type];
		NSNumber * arg = argument;
		[model takeValue:arg forKey:K];
	}
    return;
}
@end

NSString * const iTM2ImplementationDidChangeModelObjectNotification = @"iTM2ImplementationDidChangeModelObject";

@implementation NSNotificationCenter(Implementation)
static NSNotificationCenter * _iTM2ImplementationNotificationCenter = nil;
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  load
+ (void)load;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed 05 mar 03
To Do List:
"*/
{iTM2_DIAGNOSTIC;
    iTM2_INIT_POOL;
	iTM2RedirectNSLogOutput();
//iTM2_START;
    if(!_iTM2ImplementationNotificationCenter)
         _iTM2ImplementationNotificationCenter = [[NSNotificationCenter alloc] init];
//iTM2_END;
	iTM2_RELEASE_POOL;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  implementationCenter
+ (NSNotificationCenter *)implementationCenter;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed 05 mar 03
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return _iTM2ImplementationNotificationCenter;
}

@end

@implementation iTM2Object
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  init
- (id)init;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(self = [super init])
    {
        [self initImplementation];
    }
    return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  implementation
- (id)implementation;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return _Implementation;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setImplementation:
- (void)setImplementation:(id)argument;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(_Implementation != argument)
    {
        [_Implementation autorelease];
        _Implementation = [argument retain];
    }
    return;
}
@synthesize _Implementation;
@end

@implementation iTM2Proxy
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  init
- (id)init;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self initImplementation];
    return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initImplementation
- (void)initImplementation;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon May 10 22:45:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//    [self setImplementation:[self lazyImplementation]];
	[self fixImplementation];
    [self observeImplementation];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  fixImplementation
- (void)fixImplementation;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon May 10 22:45:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSInvocation * I;
	[[NSInvocation iTM2_getInvocation:&I withTarget:self retainArguments:NO] fixImplementation];
	[I iTM2_invokeWithSelectors:[iTM2RuntimeBrowser instanceSelectorsOfClass:isa withSuffix:@"FixImplementation" signature:[I methodSignature] inherited:YES]];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  observeImplementation
- (void)observeImplementation;
/*"
Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [IMPNC removeObserver:self];
	NSString * suffix = @"ModelObjectDidChangeNotified:";
    NSHashEnumerator HE = NSEnumerateHashTable([iTM2RuntimeBrowser instanceSelectorsOfClass:[self class] withSuffix:suffix signature:nil inherited:YES]);
	SEL selector;
	while(selector = (SEL)NSNextHashEnumeratorItem(&HE))
	{
		NSString * S = NSStringFromSelector(selector);
		[IMPNC addObserver:self
			selector: selector
				name: [S substringWithRange:NSMakeRange(0, [S length] - [suffix length])]
					object: [self implementation]];
    }
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  implementation
- (id)implementation;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return _Implementation;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setImplementation:
- (void)setImplementation:(id)argument;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(_Implementation != argument)
    {
        [_Implementation autorelease];
        _Implementation = [argument retain];
    }
//iTM2_END;
    return;
}
@synthesize _Implementation;
@end