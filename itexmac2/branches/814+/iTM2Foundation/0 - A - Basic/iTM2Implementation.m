/*
//
//  @version Subversion: $Id: iTM2Implementation.m 798 2009-10-12 19:32:06Z jlaurens $ 
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

#import "iTM2InstallationKit.h"
#import "iTM2Implementation.h"
#import "iTM2Runtime.h"
#import "iTM2BundleKit.h"
#import "iTM2Invocation.h"
#import "iTM2DocumentControllerKit.h"

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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  SWZ_iTM2Impl_valueForUndefinedKey:
- (id)SWZ_iTM2Impl_valueForUndefinedKey:(NSString *)key;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if ([key hasSuffix:@"_meta"])
	{
		NSRange range = iTM3MakeRange(ZER0,key.length-5);
		if (range.length)
		{
			NSString * path = [key substringWithRange:range];
			path = [@"implementation.metaValues" stringByAppendingPathExtension:path];
			return [self valueForKeyPath:path];
		}
	}
	else if ([key isEqual:@"metaValues"])
	{
		return [self valueForKeyPath:@"implementation.metaValues"];
	}
	id model = [self.class defaultModel];
	return [model objectForKey:key]?
		[self.implementation modelValueForKey:key ofType:iTM2MainType]:
		[self SWZ_iTM2Impl_valueForUndefinedKey:key];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  SWZ_iTM2Impl_setValue:forUndefinedKey:
- (void)SWZ_iTM2Impl_setValue:(id)value forUndefinedKey:(NSString *)key;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if ([key hasSuffix:@"_meta"])
	{
		NSRange range = iTM3MakeRange(ZER0,key.length-5);
		if (range.length)
		{
			NSString * path = [key substringWithRange:range];
			path = [@"implementation.metaValues" stringByAppendingPathExtension:path];
			[self willChangeValueForKey:key];
			[self setValue:value forKeyPath:path];
			[self didChangeValueForKey:key];
			return;
		}
	}
	else if ([key isEqual:@"metaValues"])
	{
		[self setValue:value forKeyPath:@"implementation.metaValues"];
		return;
	}
	if ([[self.class defaultModel] objectForKey:key])
	{
		[self willChangeValueForKey:key];
		[self.implementation takeModelValue:value forKey:key ofType:iTM2MainType];
		[self didChangeValueForKey:key];
	}
	else
		[self SWZ_iTM2Impl_setValue:(id) value forUndefinedKey:(NSString *) key];
//END4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initImplementation
- (void)initImplementation;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon May 10 22:45:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self setImplementation:self.lazyImplementation];
	self.fixImplementation;
    self.observeImplementation;
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  fixImplementation
- (void)fixImplementation;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon May 10 22:45:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[self.implementation takeModel:[[[self.class defaultModel] mutableCopy] autorelease] ofType:iTM2MainType];
	NSInvocation * I;
	[[NSInvocation getInvocation4iTM3:&I withTarget:self retainArguments:NO] fixImplementation];
	[I invokeWithSelectors4iTM3:[iTM2Runtime instanceSelectorsOfClass:self.class withSuffix:@"FixImplementation4iTM3" signature:I.methodSignature inherited:YES]];
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [IMPNC removeObserver:self];
	NSString * suffix = @"ModelObjectDidChangeNotified4iTM3:";
	NSPointerArray * PA = [iTM2Runtime instanceSelectorsOfClass:self.class withSuffix:suffix signature:nil inherited:YES];
	NSUInteger i = PA.count;
	while(i--)
	{
		SEL selector = (SEL)[PA pointerAtIndex:i];
		NSString * S = NSStringFromSelector(selector);
		[IMPNC addObserver:self
			selector: selector
				name: [S substringWithRange:iTM3MakeRange(ZER0, S.length - suffix.length)]
					object: self.implementation];
    }
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  implementation
- (id)implementation;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon May 10 22:45:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  lazyImplementation
- (id)lazyImplementation;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon May 10 22:45:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [[[iTM2Implementation alloc] initWithOwner:self] autorelease];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setImplementation:
- (void)setImplementation:(id)argument;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon May 10 22:45:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (iTM2DebugEnabled)
	{
		LOG4iTM3(@"THIS DEFAULT IMPLEMENTATION DOES NOTHING, BEWARE...");
	}
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  replaceImplementation:
- (void)replaceImplementation:(id)argument;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon May 10 22:45:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    id old = self.implementation;
    if (old != argument)
    {
        self.implementationWillChange;
        [self setImplementation:argument];
        self.implementationDidChange;
    }
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  implementationWillChange
- (void)implementationWillChange;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon May 10 22:45:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  implementationDidChange
- (void)implementationDidChange;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon May 10 22:45:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self.implementation setOwner:self];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  defaultModel
+ (NSDictionary *)defaultModel;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
	return [NSDictionary dictionary];
}
@end

@interface iTM2Implementation()
- (id)_PropertyLists;
- (void)checkPropertyList:(id)PL againstFormat:(NSPropertyListFormat)format;
@property (readwrite,assign) id _MetaValueDictionary;
@end
@implementation iTM2Implementation
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initialize
+ (void)initialize;
/*"Designated Initializer.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: Thu Oct 10 2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
	INIT_POOL4iTM3;
//START4iTM3;
    static BOOL firstTime = YES;
    if (firstTime) {
        firstTime = NO;
        [SUD registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithInteger:NSPropertyListXMLFormat_v1_0], iTM2ItemPropertyListXMLFormatKey,
                nil]];
        Class C = NSClassFromString(@"NSKeyBindings");
        SEL S = @selector(suppressCapitalizedKeyWarning);
        if ([C respondsToSelector:S]) [(id)C performSelector:S];
    }
//END4iTM3;
	RELEASE_POOL4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initWithOwner:
- (id)initWithOwner:(id)owner;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Révisé par itexmac2: 2010-12-02 22:19:49 +0100
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if ((self = [super init])) {
        self.owner = owner;
    }
    return self;
}
@synthesize owner=_Owner;
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  root
- (id)root;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: Thu Oct 10 2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    id result = _Parent;
    id P;
    while ([result respondsToSelector:@selector(implementation)] && (P = [[result implementation] parent]))
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  name
- (id)name;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: Thu Oct 10 2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [self.owner respondsToSelector:@selector(fileName)]?
        [self.owner fileName]:(metaGETTER?:@"");
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setFileName:
- (void)setName:(id)argument;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: Thu Oct 10 2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (![self.owner respondsToSelector:@selector(setFileName:)])
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [self.owner respondsToSelector:@selector(modelType)]?
        [self.owner modelType]:(metaGETTER?:@"");
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setModelType:
- (void)setModelType:(id)argument;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: Thu Oct 10 2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (![self.owner respondsToSelector:@selector(setModelType:)])
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (!_MetaValueDictionary)
	{
		_MetaValueDictionary = [[NSMutableDictionary dictionary] retain];
		if (iTM2DebugEnabled)
		{
			LOG4iTM3(@"metaValues available");
		}
	}
//START4iTM3;
    return _MetaValueDictionary;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeMetaValues:
- (void)takeMetaValues:(NSDictionary *)argument;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: Thu Oct 10 2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [_MetaValueDictionary valueForKey:key];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  metaFlagForKey:
- (BOOL)metaFlagForKey:(NSString *)key;
/*"Basic getter.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: Thu Oct 10 2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [[_MetaValueDictionary valueForKey:key] boolValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeMetaValue:forKey:
- (void)takeMetaValue:(id)argument forKey:(NSString *)key;
/*"Basic getter.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: Thu Oct 10 2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if ([key respondsToSelector:@selector(copy)])
    {
        if (!_MetaValueDictionary)
            _MetaValueDictionary = [[NSMutableDictionary dictionary] retain];
        [_MetaValueDictionary setValue:argument forKey:key];// SIGTRAP received 
    }
    else
    {
        LOG4iTM3(@"WARNING: a bad key was given, this might be intentionnal but I doubt.");
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [_MetaValueDictionary valueForKeyPath:key];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeMetaValue:forKeyPath:
- (void)takeMetaValue:(id)argument forKeyPath:(NSString *)key;
/*"Basic getter.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: Thu Oct 10 2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if ([key respondsToSelector:@selector(copy)])
    {
        if (!_MetaValueDictionary)
            _MetaValueDictionary = [[NSMutableDictionary dictionary] retain];
        [_MetaValueDictionary setValue:argument forKeyPath:key];
    }
    else
    {
        LOG4iTM3(@"WARNING: a bad key was given, this might be intentionnal but I doubt.");
        NSLog(@"WARNING: Report as a bug in case of further problem.");
    }
    return;
}
#pragma mark =-=-=-=-=-=-=-=-=-=-  I/O
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= willSaveWithError:
- (BOOL)willSaveWithError:(NSError **)RORef;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Révisé par itexmac2: 2010-12-02 22:01:19 +0100
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    BOOL result = YES;
    NSInvocation * I;
    [[NSInvocation getInvocation4iTM3:&I withTarget:self] willSaveWithError:RORef];
    for (id child in self.children) {
        [I invokeWithTarget:child];
        if(result) [I getReturnValue:&result];
    }
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= didSaveWithError:
- (BOOL)didSaveWithError:(NSError **)RORef;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Révisé par itexmac2: 2010-12-02 22:02:02 +0100
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    BOOL result = YES;
    NSInvocation * I;
    [[NSInvocation getInvocation4iTM3:&I withTarget:self] didSaveWithError:RORef];
    for (id child in self.children) {
        [I invokeWithTarget:child];
        if(result) [I getReturnValue:&result];
    }
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= didReadWithError:
- (BOOL)didReadWithError:(NSError **)RORef;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Révisé par itexmac2: 2010-12-02 22:01:54 +0100
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    BOOL result = YES;
    NSInvocation * I;
    [[NSInvocation getInvocation4iTM3:&I withTarget:self] didReadWithError:RORef];
    for (id child in self.children) {
        [I invokeWithTarget:child];
        if(result) [I getReturnValue:&result];
    }
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  writeToParentImplementationWithError:
- (BOOL)writeToParentImplementationWithError:(NSError **)RORef;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed 05 mar 03
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//NSLog(@"data: %@", result);
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  readFromParentImplementationWithError:
- (BOOL)readFromParentImplementationWithError:(NSError **)RORef;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed 05 mar 03
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
//NSLog(@"data: %@", result);
    return [self._DataRepresentations allKeys];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  dataOfType:error:
- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)RORef;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed 05 mar 03
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//NSLog(@"data: %@", result);
    if ([typeName conformsToUTType4iTM3:(NSString *)kUTTypeData]) {
        return [self._DataRepresentations valueForKey:typeName];
    }
    OUTERROR4iTM3(1,@"! ERROR: the type does not conform to public.data",NULL);
    return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  readFromData:ofType:error:
- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)RORef;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed 05 mar 03
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self._DataRepresentations setValue:data forKey:typeName];
    return [self._DataRepresentations valueForKey:typeName] != nil;
}
NSString * const iTM2DataRepresentationsName = @"D";
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  writeToDirectoryWrapper:error:
- (BOOL)writeToDirectoryWrapper:(NSFileWrapper *)DW error:(NSError **)RORef;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed 05 mar 03
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    // if there is already a directory wrapper for the receiver.
    BOOL result = NO;
    if ([DW isDirectory]) {
        NSInvocation * I;
        [[NSInvocation getInvocation4iTM3:&I withTarget:self] writeToDirectoryWrapper:DW error:RORef];
        for (id child in self.children) {
            [I invokeWithTarget:child];
            if (result) [I getReturnValue:&result];
        }
        NSData * D = [self.owner respondsToSelector:@selector(dataOfType:error:)]
                            && [self.owner respondsToSelector:@selector(modelType)]?
                [self.owner dataOfType:[self.owner modelType] error:RORef]:
                [self dataOfType:self.modelType error:RORef];
        if (D) {
            if ([[DW fileWrappers] count]) {
                [DW removeFileWrapper:[[DW fileWrappers] objectForKey:iTM2DataRepresentationsName]];
                [DW addRegularFileWithContents:D preferredFilename:iTM2DataRepresentationsName];
                result = YES;
            }
        }
    }
    return [self writeToParentImplementationWithError:RORef] && result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  readFromDirectoryWrapper:error:
- (BOOL)readFromDirectoryWrapper:(NSFileWrapper *)DW error:(NSError **)RORef;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed 05 mar 03
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    BOOL result = [self readFromParentImplementationWithError:RORef];
    if ([DW isDirectory]) {
        NSFileWrapper * fw = [[DW fileWrappers] objectForKey:iTM2DataRepresentationsName];
        NSUInteger fireWall = 128;
        while((--fireWall > ZER0) && [fw isSymbolicLink])
            fw = [[[NSFileWrapper alloc] initWithPath:[fw symbolicLinkDestination]] autorelease];
        if ([fw isRegularFile])
        {
			NSString * type = [SDC typeForContentsOfURL:[NSURL fileURLWithPath:[fw preferredFilename]] error:RORef];
            result = result && ([self.owner respondsToSelector:@selector(readFromData:ofType:error:)]?
                [self.owner readFromData:[fw regularFileContents] ofType:type error:RORef]:
                [self readFromData:[fw regularFileContents] ofType:type error:RORef]);
        }
    }
    self.updateChildren;
    NSInvocation * I;
    [[NSInvocation getInvocation4iTM3:&I withTarget:self] readFromDirectoryWrapper:DW error:RORef];
    for (id child in self.children) {
        [I invokeWithTarget:child];
        if (result) [I getReturnValue:&result];
    }
    return result;
}
#pragma mark =-=-=-=-=-=-=-=  TREE HIERARCHY
@synthesize parent = _Parent;
NSString * iTM2ChildrenKey = @"C";
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  childDocuments
- (id)children;
/*"Description Forthcoming. Lazy intilaizer.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon May 10 22:45:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    id result = [self metaValueForKey:iTM2ChildrenKey];
    if (!result) {
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if ([self.owner respondsToSelector:_cmd])
        [self.owner performSelector:_cmd];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  childForName:
- (id)childForName:(NSString *)name;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Révisé par itexmac2: 2010-12-03 17:42:23 +0100
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    for (id child in self.children)
        if ([[child name] isEqualToString:name])
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSMutableArray * MRA = self.children;
    if (![MRA containsObject:argument]) {
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSMutableArray * MRA = self.children;
    if ([MRA containsObject:argument])
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
    id PLs = [self metaValueForKey:iTM2PropertyListsNameKey];
    if (!PLs)
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
    id formats = [self metaValueForKey:iTM2PLXMLFormatsNameKey];
    if (!formats)
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSNumber * N = [self._PLXMLFormats valueForKey:type];
    return N? [N integerValue]:[[NSUserDefaults standardUserDefaults] integerForKey:iTM2ItemPropertyListXMLFormatKey];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeModelFormat:ofType:
- (void)takeModelFormat:(NSPropertyListFormat)argument ofType:(NSString *)type;
/*"Description forthcoming. argument is retained. Lazy dataWrapper initializer as side effect.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: Thu Oct 10 2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self._PLXMLFormats setValue:[NSNumber numberWithInteger:argument] forKey:type];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  dataRepresentationOfModelOfType:error:
- (NSData *)dataRepresentationOfModelOfType:(NSString *)type error:(NSError**)RORef;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Révisé par itexmac2: 2010-12-03 17:46:05 +0100
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	id PL = [self modelOfType:type];
	if (PL) {
		NSString * errorString = nil;
        NSPropertyListFormat format = [self modelFormatOfType:type];
		id result = [NSPropertyListSerialization dataFromPropertyList:PL format:format errorDescription:&errorString];
		if (result) return result;
		OUTERROR4iTM3(1,
			([NSString stringWithFormat:@"Big problem\nReport BUG ref:iTM2861, error string:'%@' (format:%@)\nAnalyzing the property list (see console)",
				errorString, (format == NSPropertyListOpenStepFormat? @"OpenStep": (format == NSPropertyListXMLFormat_v1_0? @"XML": @"binary"))]),nil);
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if ([NSPropertyListSerialization propertyList:PL isValidForFormat:format])
		return;
    id K = nil;
	if ([PL isKindOfClass:[NSDictionary class]])
	{
		for (K in [PL keyEnumerator])
		{
			if (![NSPropertyListSerialization propertyList:K isValidForFormat:format])
			{
				LOG4iTM3(@"Bad key: %@ in dictionary %@", K, PL);
			}
			[self checkPropertyList:[PL objectForKey:K] againstFormat:format];
		}
	}
	else if ([PL isKindOfClass:[NSArray class]])
	{
		for (K in [PL objectEnumerator])
		{
			[self checkPropertyList:K againstFormat:format];
		}
	}
	else
	{
		LOG4iTM3(@"The object %@ of class %@ is not valid for %@", PL, [PL class], (format == NSPropertyListOpenStepFormat? @"OpenStep":(format == NSPropertyListXMLFormat_v1_0? @"XML":@"binary")));
	}
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  loadModelValueOfDataRepresentation:ofType:error:
- (BOOL)loadModelValueOfDataRepresentation:(NSData *)data ofType:(NSString *)type error:(NSError**)RORef;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed 05 mar 03
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (data.length) {
        NSString * errorString = nil;
        NSPropertyListFormat format;
        id DM = [NSPropertyListSerialization propertyListFromData:data
            mutabilityOption: NSPropertyListMutableContainersAndLeaves
                format: &format errorDescription: &errorString];
		OUTERROR4iTM3(1,
			([NSString stringWithFormat:@"NSPropertyListSerialization error string:'%@'", errorString]),nil);
//NSLog(@"DM: %@", DM);
        if (DM) {
//NSLog(@"THE MODEL LOADER IS ABOUT TO REPLACE THE item DATA.......");
            [self takeModelFormat:format ofType:type];
            [self takeModel:DM ofType:type];
            return YES;
        }
    } else if (data) {
		DEBUGLOG4iTM3(0,@"Loading a void data.");
		[self takeModelFormat:[SUD integerForKey:iTM2ItemPropertyListXMLFormatKey] ofType:type];
		[self takeModel:[NSMutableDictionary dictionary] ofType:type];
		return YES;
	} else {
		DEBUGLOG4iTM3(0,@"No data to load.");
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [self._PropertyLists allKeys];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  modelOfType:
- (id)modelOfType:(NSString *)type;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed 05 mar 03
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSAssert(type.length>ZER0, @"The type key must be non void");
    return [self._PropertyLists valueForKey:type];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeModel:ofType:
- (void)takeModel:(id)model ofType:(NSString *)type;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed 05 mar 03
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSAssert(type.length>ZER0, @"The type key must be non void");
//LOG4iTM3(@"Model is: %@", model);
//LOG4iTM3(@"Type is: %@", type);
    [self._PropertyLists setValue:model forKey:type];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  modelValueKeysOfType:
- (NSArray *)modelValueKeysOfType:(NSString *)type;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed 05 mar 03
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [[self modelOfType:type] allKeys];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  modelValueForKey:ofType:
- (id)modelValueForKey:(NSString *)key ofType:(NSString *)type;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed 05 mar 03
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	id PLs = self._PropertyLists;
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
	id PLs = self._PropertyLists;
    id model = [PLs valueForKey:type];
	if (!model) {
		[self._PropertyLists setValue:[NSMutableDictionary dictionary] forKey:type];
		model = [PLs valueForKey:type];
	}
    id previous = [model valueForKey:key];// IT MUST BE RETAIN/RELEASE
    if ([previous isEqual:PL])
        return;
    if (!previous && !PL)
        return;
	[[previous retain] autorelease];// !!! DANGER:previous will be released below
    [model setValue:PL forKey:key];
    [IMPNC postNotificationName:iTM2ImplementationDidChangeModelObjectNotification
        object: self userInfo: (previous?
        [NSDictionary dictionaryWithObjectsAndKeys:key, @"key", type, @"type", previous, @"previous", nil]:
        [NSDictionary dictionaryWithObjectsAndKeys:key, @"key", type, @"type", nil])];
    [IMPNC postNotificationName:key object:self
        userInfo: (previous? [NSDictionary dictionaryWithObjectsAndKeys:type, @"type", previous, @"previous", nil]:[NSDictionary dictionaryWithObjectsAndKeys:type, @"type", nil])];
    return;
}
@synthesize _MetaValueDictionary;
@end

NSString * iTM2KeyFromSelector(SEL selector)
/*"Basic getter.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Feb 25 21:08:18 GMT 2005
To Do List:
"*/
{
	if (!selector)
		return nil;
	char * _selname = (char *)sel_getName(selector);
	size_t n = strlen(_selname);
	char * selname = NSAllocateCollectable(n+1,ZER0);// + 1 for the \0 termination character
	if (!selname)
	{
		NSLog(@"*** iTM2KeyFromSelector: MISSING MEMORY, report problem");
		return nil;
	}
	if (!strcpy(selname, _selname))
	{
		NSLog(@"*** iTM2KeyFromSelector: COPY MEMORY, report problem");
		free(selname);
		return nil;
	}
	_selname = selname;
    while (YES) {
        if (!strncmp(_selname, "get", 3))
        {
            _selname += 3;
        }
        else if (!strncmp(_selname, "set", 3))
        {
            _selname[n-1] = '\0';
            _selname += 3;
        }
        else if (!strncmp(_selname, "take", 4))
        {
            _selname[n-1] = '\0';
            _selname += 4;
        }
        else if (!strncmp(_selname, "is", 2))
        {
            _selname += 2;
        }
        else if (!strncmp(_selname, "_", 1))
        {
            ++_selname;
            if (strlen(_selname))
                continue;
        }
        if (strlen(_selname)) {
            static const char * capitals = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
            if ((_selname[ZER0]>='a') && (_selname[ZER0]<='z'))
                _selname[ZER0] = capitals[_selname[ZER0]-'a'];
            NSString * K = [NSString stringWithCString:_selname encoding:NSASCIIStringEncoding];
            return K;	
        }
        return nil;
    }
}

@implementation iTM2Implementation(Selector)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  metaValueForSelector:
- (id)metaValueForSelector:(SEL)selector;
/*"Basic getter.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: Thu Oct 10 2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (!_MetaValueDictionary)
		_MetaValueDictionary = [[NSMutableDictionary dictionary] retain];
	NSString * K = iTM2KeyFromSelector(selector);
	if (K) [_MetaValueDictionary setValue:argument forKey:K];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  modelValueForSelector:ofType:
- (id)modelValueForSelector:(SEL)selector ofType:(NSString *)type;
/*"Basic getter.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: Thu Oct 10 2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSString * K = iTM2KeyFromSelector(selector);
	return K? [[self._PropertyLists valueForKey:type] valueForKey:K]:nil;	
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeModelValue:forSelector:ofType:
- (void)takeModelValue:(id)argument forSelector:(SEL)selector ofType:(NSString *)type;
/*"Basic getter.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: Thu Oct 10 2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSString * K = iTM2KeyFromSelector(selector);
	if (K.length)
	{
		NSDictionary * PLs = self._PropertyLists;
		NSDictionary * model = [PLs valueForKey:type];
		NSNumber * arg = argument;
		[model setValue:arg forKey:K];
	}
    return;
}
@end

NSString * const iTM2ImplementationDidChangeModelObjectNotification = @"iTM2ImplementationDidChangeModelObject";

@implementation NSNotificationCenter(Implementation)
static NSNotificationCenter * _iTM2ImplementationNotificationCenter = nil;
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  implementationCenter
+ (NSNotificationCenter *)implementationCenter;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed 05 mar 03
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return _iTM2ImplementationNotificationCenter?:(_iTM2ImplementationNotificationCenter = [[NSNotificationCenter alloc] init]);
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if ((self = [super init]))
    {
        self.initImplementation;
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return _Implementation;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setImplementation:
- (void)setImplementation:(id)argument;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (_Implementation != argument)
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
    self.initImplementation;
    return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initImplementation
- (void)initImplementation;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon May 10 22:45:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//    [self setImplementation:self.lazyImplementation];
	self.fixImplementation;
    self.observeImplementation;
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  fixImplementation
- (void)fixImplementation;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon May 10 22:45:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSInvocation * I;
	[[NSInvocation getInvocation4iTM3:&I withTarget:self retainArguments:NO] fixImplementation];
	[I invokeWithSelectors4iTM3:[iTM2Runtime instanceSelectorsOfClass:self.class withSuffix:@"FixImplementation4iTM3" signature:I.methodSignature inherited:YES]];
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [IMPNC removeObserver:self];
	NSString * suffix = @"ModelObjectDidChangeNotified4iTM3:";
	NSPointerArray * PA = [iTM2Runtime instanceSelectorsOfClass:self.class withSuffix:suffix signature:nil inherited:YES];
	NSUInteger i = PA.count;
	while(i--)
	{
		SEL selector = (SEL)[PA pointerAtIndex:i];
    	NSString * S = NSStringFromSelector(selector);
		[IMPNC addObserver:self
			selector: selector
				name: [S substringWithRange:iTM3MakeRange(ZER0, S.length - suffix.length)]
					object: self.implementation];
    }
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  implementation
- (id)implementation;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return _Implementation;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setImplementation:
- (void)setImplementation:(id)argument;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (_Implementation != argument)
    {
        [_Implementation autorelease];
        _Implementation = [argument retain];
    }
//END4iTM3;
    return;
}
@synthesize _Implementation;
@end

@implementation iTM2MainInstaller(Implementation)
+ (void)prepareImplementationCompleteInstallation4iTM3;
{
	if ([NSObject swizzleInstanceMethodSelector4iTM3:@selector(SWZ_iTM2Impl_valueForUndefinedKey:) error:NULL]
		&& [NSObject swizzleInstanceMethodSelector4iTM3:@selector(SWZ_iTM2Impl_setValue:forUndefinedKey:) error:NULL])
	{
		MILESTONE4iTM3((@"NSObject(iTM2Implementation)"),(@"setValue:forUndefinedKey: does not take into account the implementation design"));
	}
}

@end

//