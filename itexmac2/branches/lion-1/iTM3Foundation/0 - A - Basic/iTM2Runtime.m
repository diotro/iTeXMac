/*
//
//  @version Subversion: $Id: iTM2Runtime.m 798 2009-10-12 19:32:06Z jlaurens $ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Mon May 10 22:45:25 GMT 2004.
//  Copyright © 2005 Laurens'Tribune. All rights reserved.
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

//#import "iTM2Invocation.h"
//#import "iTM2InstallationKit.h"
//#import "iTM2BundleKit.h"
//#import "iTM2NotificationKit.h"
#import "iTM2Runtime.h"
#import "ICURegEx.h"

#import <objc/objc.h>
#import <objc/objc-class.h>
#import <objc/objc-runtime.h>

@interface NSObject(iTM2Runtime_Private)
+ (id)instanceMethodSignatureForSelector4iTM3:(SEL)aSelector;
@end
@implementation NSObject(iTM2Runtime)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  swizzleInstanceMethodSelector4iTM3:
+ (BOOL)swizzleInstanceMethodSelector4iTM3:(SEL)selector error:(NSError **) RORef;
/*"swizzle instance selector.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Jan 29 10:15:13 UTC 2008
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	ICURegEx * RE = [ICURegEx regExWithSearchPattern:@"^SWZ_.*?_(.*)" error:RORef];
	if ([RE matchString:NSStringFromSelector(selector)]) {
		SEL swizzled = NSSelectorFromString([RE substringOfCaptureGroupAtIndex:1]);
        [RE forget];
//END4iTM3;
		return [iTM2Runtime swizzleInstanceMethodSelector:selector replacement:swizzled forClass:self error:RORef];
	}
//END4iTM3;
	return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  swizzleClassMethodSelector4iTM3:error:
+ (BOOL)swizzleClassMethodSelector4iTM3:(SEL)selector error:(NSError **)RORef;
/*"swizzle instance selector.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Jan 29 10:15:13 UTC 2008
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	ICURegEx * RE = [ICURegEx regExWithSearchPattern:@"^SWZ_.*?_(.*)" error:RORef];
	if ([RE matchString:NSStringFromSelector(selector)]) {
		SEL swizzled = NSSelectorFromString([RE substringOfCaptureGroupAtIndex:1]);
        [RE forget];
//END4iTM3;
		return [iTM2Runtime swizzleClassMethodSelector:selector replacement:swizzled forClass:self error:RORef];
	}
//END4iTM3;
	return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2Runtime_noop
+ (void)iTM2Runtime_noop;
/*"Designated Initializer.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: Thu Oct 10 2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
	if (iTM2DebugEnabled)
	{
		LOG4iTM3(@"Here I am");
	}
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2Runtime_noop
- (void)iTM2Runtime_noop;
/*"Designated Initializer.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: Thu Oct 10 2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
	if (iTM2DebugEnabled)
	{
		LOG4iTM3(@"Here I am");
	}
	return;
}
+ (id)instanceMethodSignatureForSelector4iTM3:(SEL)aSelector;
{
	id result = nil;
    if (aSelector == @selector(heartBeat:))
    {
NS_DURING
	result = [self instancesRespondToSelector:(SEL)aSelector]?[self instanceMethodSignatureForSelector:(SEL)aSelector]:nil;
NS_HANDLER
	result = nil;
	LOG4iTM3(@"Exception catched");
NS_ENDHANDLER
    }
    else {
        result = [self instancesRespondToSelector:(SEL)aSelector]?[self instanceMethodSignatureForSelector:(SEL)aSelector]:nil;
    }
	return result;
}
@end

@implementation iTM2Runtime
static id iTM2RuntimeDictionary = nil;
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  initialize
+ (void)initialize;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{DIAGNOSTIC4iTM3;
	INIT_POOL4iTM3;
//START4iTM3;
	[NSMethodSignature swizzleInstanceMethodSelector4iTM3:@selector(SWZ_iTM2_description) error:NULL];
    if (!iTM2RuntimeDictionary) {
		iTM2RuntimeDictionary = [NSMutableDictionary dictionary];
	}
//END4iTM3;
	RELEASE_POOL4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  swizzleInstanceMethodSelector:replacement:forClass:error:
+ (BOOL)swizzleInstanceMethodSelector:(SEL)origSel_ replacement:(SEL)altSel_ forClass:(Class)aClass error:(NSError **)RORef;
/*"Description forthcoming.
Code from cocoadev MethodSwizzle
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (RORef) {
		*RORef = nil;
	}
    if (!aClass) {
        LOG4iTM3(@"WARNING: Missing a  class, no swizzling.");
        return NO;
    }
    if (origSel_ == altSel_) {
        LOG4iTM3(@"Same selectors, no swizzling.");
        return NO;
    }
	Method origMethod = class_getInstanceMethod(aClass, origSel_);
	if (!origMethod) {
#define SetNSError(ERROR_VAR, FORMAT,...)       \
if (ERROR_VAR) {        \
NSString *errStr = [@"+[iTM2Runtime swizzleInstanceMethodSelector:replacement:forClass:error:]: " stringByAppendingFormat:FORMAT,##__VA_ARGS__];       \
*ERROR_VAR = [NSError errorWithDomain:@"NSCocoaErrorDomain" \
code:-1        \
userInfo:[NSDictionary dictionaryWithObject:errStr forKey:NSLocalizedDescriptionKey]]; \
}
		SetNSError(RORef, @"original method %@ not found for class %@", NSStringFromSelector(origSel_), [aClass className]);
		return NO;
	}
	
	Method altMethod = class_getInstanceMethod(aClass, altSel_);
	if (!altMethod) {
		SetNSError(RORef, @"alternate method %@ not found for class %@", NSStringFromSelector(altSel_), [aClass className]);
		return NO;
	}
	
	class_addMethod(aClass,
					origSel_,
					class_getMethodImplementation(aClass, origSel_),
					method_getTypeEncoding(origMethod));
	class_addMethod(aClass,
					altSel_,
					class_getMethodImplementation(aClass, altSel_),
					method_getTypeEncoding(altMethod));
	
	method_exchangeImplementations(class_getInstanceMethod(aClass, origSel_), class_getInstanceMethod(aClass, altSel_));
	return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  swizzleClassMethodSelector:replacement:forClass:error:
+ (BOOL)swizzleClassMethodSelector:(SEL)orig_sel replacement:(SEL)alt_sel forClass:(Class)aClass error:(NSError **) RORef;
/*"Description forthcoming.
Code from cocoadev MethodSwizzle
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (RORef)
	{
		*RORef = nil;
	}
	if (!aClass)
    {
        LOG4iTM3(@"WARNING: Missing a  class, no swizzling.");
        return NO;
    }
//END4iTM3;
	return [self swizzleInstanceMethodSelector:orig_sel replacement:alt_sel forClass:aClass->isa error:RORef];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  disableInstanceMethodSelector:forClass:
+ (BOOL)disableInstanceMethodSelector:(SEL)orig_sel forClass:(Class)aClass;
/*"Description forthcoming.
Code from cocoadev MethodSwizzle
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (!aClass)
    {
        LOG4iTM3(@"WARNING: Missing a  class, no swizzling.");
        return NO;
    }
	SEL alt_sel = @selector(iTM2Runtime_noop);
    if (orig_sel == alt_sel)
    {
        LOG4iTM3(@"Same selectors, no swizzling.");
        return NO;
    }
	if (!class_respondsToSelector(aClass, orig_sel))
    {
        LOG4iTM3(@"%s not mapped, no swizzling.", sel_getName(orig_sel));
        return NO;
    }
    Method orig_method = class_getInstanceMethod(aClass, orig_sel);
    Method alt_method = class_getInstanceMethod(aClass, alt_sel);
	Method clone_method;
	bcopy(&alt_method, &clone_method, sizeof(clone_method));
	method_exchangeImplementations(orig_method, clone_method);
	if (iTM2DebugEnabled)
	{
		LOG4iTM3(@"Instance method swizzling in %s\ninstance method %s disabled", object_getClassName(aClass), sel_getName(orig_sel));
	}
//END4iTM3;
	return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  disableClassMethodSelector:forClass:
+ (BOOL)disableClassMethodSelector:(SEL)orig_sel forClass:(Class)aClass;
/*"Description forthcoming.
Code from cocoadev MethodSwizzle
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (!aClass)
    {
        LOG4iTM3(@"WARNING: Missing a  class, no swizzling.");
        return NO;
    }
	return [self disableInstanceMethodSelector:orig_sel forClass:aClass->isa];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  bundleDidLoadNotified:
+ (void)bundleDidLoadNotified:(NSNotification *)notification;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[self flushCache];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  flushCache
+ (void)flushCache;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	// all the cached results are cleaned
	int oldNumClasses = self.numberOfClasses;
	int newNumClasses = objc_getClassList(NULL, ZER0);
	if (oldNumClasses != newNumClasses)
	{
//LOG4iTM3(@"New classes are available: old %i, new %i", oldNumClasses, newNumClasses);
		[iTM2RuntimeDictionary setValue:[NSMutableDictionary dictionary] forKey:@"Classes"];
		[iTM2RuntimeDictionary setValue:[NSArray array] forKey:@"Main"];
	}
	[iTM2RuntimeDictionary setObject:[NSMutableDictionary dictionary] forKey:@"Selectors"];
	[iTM2RuntimeDictionary setObject:[NSMutableDictionary dictionary] forKey:@"InheritedSelectors"];
	[iTM2RuntimeDictionary setObject:[NSMutableDictionary dictionary] forKey:@"ClassSelectors"];
	[iTM2RuntimeDictionary setObject:[NSMutableDictionary dictionary] forKey:@"InheritedClassSelectors"];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  allClassReferences
+ (NSPointerArray *)allClassReferences;
/*"Description forthcoming.
 Hash table with weak objects.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//LOG4iTM3(@"I AM CURRENLY LOOKING FOR ALL CLASSES");
	NSPointerArray * result = [iTM2RuntimeDictionary valueForKey:@"Main"];
	if (!result.count)
	{
		result = [NSPointerArray pointerArrayWithOptions:NSPointerFunctionsOpaqueMemory|NSPointerFunctionsOpaquePersonality];
		int numClasses = objc_getClassList(NULL, ZER0);
		Class * classes = NULL;
		if (numClasses > ZER0)
		{
			classes = NSAllocateCollectable(sizeof(Class) * numClasses,ZER0);
			(void) objc_getClassList(classes, numClasses);
			Class * ptr = classes;
//LOG4iTM3(@"CLASS number %i IS: %@", numClasses, NSStringFromClass(* ptr));
			while(numClasses--)
			{
				[result addPointerIfAbsent4iTM3:(void *)*ptr];
				++ptr;
//LOG4iTM3(@"CLASS number %i IS: %@", numClasses, NSStringFromClass(* ptr));
			}
			[iTM2RuntimeDictionary setValue:result forKey:@"Main"];
		}
	}
//LOG4iTM3(@"THAT'S ALL");
//END4iTM3;
	return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  subclassReferencesOfClass:
+ (NSPointerArray *)subclassReferencesOfClass:(Class)aClass;
/*"Description forthcoming.
 Hash table with weak objects.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSString * name = NSStringFromClass(aClass);
//LOG4iTM3(@"I AM CURRENLY LOOKING FOR SUBCLASSES OF: %@", name);
	id classDict = [iTM2RuntimeDictionary objectForKey:@"Classes"];
	NSPointerArray * result = [classDict objectForKey:name];
	if (!result)
	{
		result = [NSPointerArray pointerArrayWithOptions:NSPointerFunctionsOpaqueMemory|NSPointerFunctionsOpaquePersonality];
		Class * classes = NULL;
		int numClasses = objc_getClassList(NULL, ZER0);
		if (numClasses > ZER0 )
		{
			if ((classes = NSAllocateCollectable(sizeof(Class) * numClasses,ZER0)))
			{
				(void)objc_getClassList(classes, numClasses);
				Class * ptr = classes;
				const char * cName = [name UTF8String];
				while(numClasses--)
				{
//if ([NSStringFromClass(* ptr) hasPrefix:@"iTM2TeXP"])
//NSLog(@"DEBUGGGGGG");
					if ([self isClass:* ptr subclassOfClassNamed:cName])
					{
						[result addPointer:(void *)* ptr];
//LOG4iTM3(@"ADDED CLASS number %i IS: %@", numClasses, NSStringFromClass(* ptr));
					}
					else
					{
//LOG4iTM3(@"IGNORED CLASS number %i IS: %@", numClasses, NSStringFromClass(* ptr));
					}
					++ ptr;
				}
				[classDict setValue:result forKey:name];
			}
			else
			{
				LOG4iTM3(@"MEMORY problem, missing %i class locations", numClasses);
			}
		}
		else
		{
			[classDict setValue:result forKey:name];
		}
	}
//END4iTM3;
//LOG4iTM3(@"THE RESULT IS: %@", result);
	return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  isClass:subclassOfClass:
+ (BOOL)isClass:(Class)lhsClass subclassOfClass:(Class)rhsClass;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
	return [self isClass:lhsClass subclassOfClassNamed:[NSStringFromClass(rhsClass) UTF8String]];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  isClass:subclassOfClassNamed:
+ (BOOL)isClass:(Class)target subclassOfClassNamed:(const char *)className;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	Class super_class = class_getSuperclass(target);
	if (!super_class)
		return NO;
	else if (!strncmp(class_getName(target),"NSKVO",5))
		return NO;
	else if (!strcmp(class_getName(super_class), className))
		return YES;
	else
		return [self isClass:super_class subclassOfClassNamed:className];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  numberOfClasses
+ (NSInteger)numberOfClasses;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	return objc_getClassList(NULL, ZER0);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  instanceSelectorsOfClass:matchedBy:signature:inherited:
+ (NSPointerArray *)instanceSelectorsOfClass:(Class)theClass matchedBy:(ICURegEx *)RE signature:(NSMethodSignature *)signature inherited:(BOOL)yorn;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (!theClass)
		return [NSPointerArray pointerArrayWithOptions:NSPointerFunctionsOpaqueMemory|NSPointerFunctionsOpaquePersonality];
	NSString * selsKey = (yorn? @"InheritedSelectors": @"Selectors");
	NSMutableDictionary * sels = [iTM2RuntimeDictionary objectForKey:selsKey];
	if (![sels isKindOfClass:[NSMutableDictionary class]]) {
		[iTM2RuntimeDictionary setObject:[NSMutableDictionary dictionary] forKey:selsKey];
		sels = [iTM2RuntimeDictionary objectForKey:selsKey];
	}
	NSString * KEY = NSStringFromClass(theClass);
	NSMutableDictionary * MD = [sels objectForKey:KEY];
	if (![MD isKindOfClass:[NSMutableDictionary class]]) {
		[sels setObject:[NSMutableDictionary dictionary] forKey:KEY];
		MD = [sels objectForKey:KEY];
	}
    NSString * key = RE.searchPattern?:@"";
	id temp = [MD objectForKey:key];
	if (![temp isKindOfClass:[NSMutableDictionary class]]) {
		[MD setObject:[NSMutableDictionary dictionary] forKey:key];
		temp = [MD objectForKey:key];
	}
	MD = temp;
	NSString * methodKey = signature? [signature description]:@"";
	NSPointerArray * result = [MD objectForKey:methodKey];
	if (![result isKindOfClass:[NSPointerArray class]]) {
		result = [self realInstanceSelectorsOfClass:theClass matchedBy:RE signature:signature inherited:yorn];
        [MD setValue:result forKey:methodKey];
        result = [MD objectForKey:methodKey];
	}
	return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  instanceSelectorsOfClass:withSuffix:signature:inherited:
+ (NSPointerArray *)instanceSelectorsOfClass:(Class)theClass withSuffix:(NSString *)suffix signature:(NSMethodSignature *)signature inherited:(BOOL)yorn;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (!theClass)
		return [NSPointerArray pointerArrayWithOptions:NSPointerFunctionsOpaqueMemory|NSPointerFunctionsOpaquePersonality];
	NSString * selsKey = (yorn? @"InheritedSelectors": @"Selectors");
	NSMutableDictionary * sels = [iTM2RuntimeDictionary objectForKey:selsKey];
	if (![sels isKindOfClass:[NSMutableDictionary class]])
	{
		[iTM2RuntimeDictionary setObject:[NSMutableDictionary dictionary] forKey:selsKey];
		sels = [iTM2RuntimeDictionary objectForKey:selsKey];
	}
	NSString * KEY = NSStringFromClass(theClass);
	NSMutableDictionary * MD = [sels objectForKey:KEY];
	if (![MD isKindOfClass:[NSMutableDictionary class]])
	{
		[sels setObject:[NSMutableDictionary dictionary] forKey:KEY];
		MD = [sels objectForKey:KEY];
	}
	if (!suffix.length)
	{
		suffix = @"";
	}
	id temp = [MD objectForKey:suffix];
	if (![temp isKindOfClass:[NSMutableDictionary class]])
	{
		[MD setObject:[NSMutableDictionary dictionary] forKey:suffix];
		temp = [MD objectForKey:suffix];
	}
	MD = temp;
	NSString * methodKey = signature? [signature description]:@"";
	NSPointerArray * result = [MD objectForKey:methodKey];
	if (![result isKindOfClass:[NSPointerArray class]])
	{
		result = [self realInstanceSelectorsOfClass:theClass withSuffix:suffix signature:signature inherited:yorn];
        [MD setValue:result forKey:methodKey];
        result = [MD objectForKey:methodKey];
	}
	return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  realInstanceSelectorsOfClass:withSuffix:signature:inherited:
+ (NSPointerArray *)realInstanceSelectorsOfClass:(Class)aClass withSuffix:(NSString *)suffix signature:(NSMethodSignature *)signature inherited:(BOOL)yorn;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{DIAGNOSTIC4iTM3;
	//START4iTM3;
	[aClass class];// initialize if needed:this is absolutely necessary
	id SELs = [NSMutableSet set];
	id prepareSELs = [NSMutableSet set];
	SEL selector;
	NSString * name;
	Class originalClass = Nil;
	if (suffix.length)
	{
		if (signature)
		{
			do
			{
				unsigned int outCount;
				Method * methods = class_copyMethodList(aClass, &outCount);
				while(outCount--) {
					selector = method_getName(methods[outCount]);
					name = NSStringFromSelector(selector);
					if ([name hasSuffix:suffix]
					   && [signature isEqual:[aClass instanceMethodSignatureForSelector4iTM3:selector]])
					{
						if ([name hasPrefix:@"prepare"])
							[prepareSELs addObject:name];
						else
							[SELs addObject:name];
					}
				}
				free(methods);
				originalClass = aClass;
				aClass = class_getSuperclass(originalClass);
			}
			while(yorn && aClass && (aClass != originalClass));
		}
		else//if (!signature)
		{
			do
			{
				unsigned int outCount;
				Method * methods = class_copyMethodList(aClass, &outCount);
				while(outCount--) {
					selector = method_getName(methods[outCount]);
					name = NSStringFromSelector(selector);
					if ([name hasSuffix:suffix])
					{
						if ([name hasPrefix:@"prepare"])
							[prepareSELs addObject:name];
						else
							[SELs addObject:name];
					}
				}
				free(methods);
				originalClass = aClass;
				aClass = class_getSuperclass(originalClass);
			}
			while(yorn && aClass && (aClass != originalClass));
		}
	}
	else//if (!suffix.length)
	{
		if (signature)
		{
			do
			{
				unsigned int outCount;
				Method * methods = class_copyMethodList(aClass, &outCount);
				while(outCount--) {
					selector = method_getName(methods[outCount]);
					name = NSStringFromSelector(selector);
					if ([signature isEqual:[aClass instanceMethodSignatureForSelector4iTM3:selector]])
					{
						if ([name hasPrefix:@"prepare"])
							[prepareSELs addObject:name];
						else
							[SELs addObject:name];
					}
				}
				free(methods);
				originalClass = aClass;
				aClass = class_getSuperclass(originalClass);
			}
			while(yorn && aClass && (aClass != originalClass));
		}
		else//if (!signature)
		{
			do
			{
				unsigned int outCount;
				Method * methods = class_copyMethodList(aClass, &outCount);
				while(outCount--) {
					selector = method_getName(methods[outCount]);
					name = NSStringFromSelector(selector);
					if ([name hasPrefix:@"prepare"])
						[prepareSELs addObject:name];
					else
						[SELs addObject:name];
				}
				free(methods);
				originalClass = aClass;
				aClass = class_getSuperclass(originalClass);
			}
			while(yorn && aClass && (aClass != originalClass));
		}
	}
//LOG4iTM3(@"prepareSELs:%@",prepareSELs);
//LOG4iTM3(@"SELs:%@",SELs);
	NSMutableArray * preSELs = [NSMutableArray arrayWithArray:[prepareSELs allObjects]];
	SELs = [NSMutableArray arrayWithArray:[SELs allObjects]];
	[preSELs sortUsingSelector:@selector(compare:)];
	[preSELs addObjectsFromArray:[SELs sortedArrayUsingSelector:@selector(compare:)]];
	//LOG4iTM3(@"Class: %@ suffix: %@, sels: %@", theClass,suffix, prepareSELs);
	NSPointerArray * result = [NSPointerArray pointerArrayWithOptions:NSPointerFunctionsOpaqueMemory|NSPointerFunctionsOpaquePersonality];
	for(name in preSELs)
		[result addPointer:(void *)NSSelectorFromString(name)];
	return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  realInstanceSelectorsOfClass:matchedBy:signature:inherited:
+ (NSPointerArray *)realInstanceSelectorsOfClass:(Class)aClass matchedBy:(ICURegEx *)RE signature:(NSMethodSignature *)signature inherited:(BOOL)yorn;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{DIAGNOSTIC4iTM3;
	//START4iTM3;
	[aClass class];// initialize if needed: this is absolutely necessary
	id SELs = [NSMutableSet set];
	id prepareSELs = [NSMutableSet set];
	SEL selector;
	NSString * name;
	Class originalClass = Nil;
    if (RE) {
		if (signature) {
			do {
				unsigned int outCount;
				Method * methods = class_copyMethodList(aClass, &outCount);
				while(outCount--) {
					selector = method_getName(methods[outCount]);
					name = NSStringFromSelector(selector);
					if ([RE matchString:name]
                            && [signature isEqual:[aClass instanceMethodSignatureForSelector4iTM3:selector]]) {
						if ([name hasPrefix:@"prepare"])
							[prepareSELs addObject:name];
						else
							[SELs addObject:name];
					}
				}
				free(methods);
				originalClass = aClass;
				aClass = class_getSuperclass(originalClass);
			} while(yorn && aClass && (aClass != originalClass));
		} else /*if (!signature) */ {
			do {
				unsigned int outCount;
				Method * methods = class_copyMethodList(aClass, &outCount);
				while(outCount--) {
					selector = method_getName(methods[outCount]);
					name = NSStringFromSelector(selector);
					if ([RE matchString:name]) {
						if ([name hasPrefix:@"prepare"])
							[prepareSELs addObject:name];
						else
							[SELs addObject:name];
					}
				}
				free(methods);
				originalClass = aClass;
				aClass = class_getSuperclass(originalClass);
			} while(yorn && aClass && (aClass != originalClass));
		}
	} else /* if (!RE) */ {
		if (signature) {
			do {
				unsigned int outCount;
				Method * methods = class_copyMethodList(aClass, &outCount);
				while(outCount--) {
					selector = method_getName(methods[outCount]);
					name = NSStringFromSelector(selector);
					if ([signature isEqual:[aClass instanceMethodSignatureForSelector4iTM3:selector]]) {
						if ([name hasPrefix:@"prepare"])
							[prepareSELs addObject:name];
						else
							[SELs addObject:name];
					}
				}
				free(methods);
				originalClass = aClass;
				aClass = class_getSuperclass(originalClass);
			} while(yorn && aClass && (aClass != originalClass));
		} else /* if (!signature) */ {
			do {
				unsigned int outCount;
				Method * methods = class_copyMethodList(aClass, &outCount);
				while(outCount--) {
					selector = method_getName(methods[outCount]);
					name = NSStringFromSelector(selector);
					if ([name hasPrefix:@"prepare"])
						[prepareSELs addObject:name];
					else
						[SELs addObject:name];
				}
				free(methods);
				originalClass = aClass;
				aClass = class_getSuperclass(originalClass);
			} while(yorn && aClass && (aClass != originalClass));
		}
	}
//LOG4iTM3(@"prepareSELs:%@",prepareSELs);
//LOG4iTM3(@"SELs:%@",SELs);
	NSMutableArray * preSELs = [NSMutableArray arrayWithArray:[prepareSELs allObjects]];
	SELs = [NSMutableArray arrayWithArray:[SELs allObjects]];
	[preSELs sortUsingSelector:@selector(compare:)];
	[preSELs addObjectsFromArray:[SELs sortedArrayUsingSelector:@selector(compare:)]];
	//LOG4iTM3(@"Class: %@ key: %@, sels: %@", theClass,key, prepareSELs);
	NSPointerArray * result = [NSPointerArray pointerArrayWithOptions:NSPointerFunctionsOpaqueMemory|NSPointerFunctionsOpaquePersonality];
	for (name in preSELs) {
		[result addPointer:(void *)NSSelectorFromString(name)];
    }
	return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  classSelectorsOfClass:withSuffix:signature:inherited:
+ (NSPointerArray *)classSelectorsOfClass:(Class)theClass withSuffix:(NSString *)suffix signature:(NSMethodSignature *)signature inherited:(BOOL)yorn;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (!theClass)
		return [NSPointerArray pointerArrayWithOptions:NSPointerFunctionsOpaqueMemory|NSPointerFunctionsOpaquePersonality];
	NSString * selsKey = (yorn? @"InheritedClassSelectors": @"ClassSelectors");
	NSMutableDictionary * sels = [iTM2RuntimeDictionary objectForKey:selsKey];
	if (![sels isKindOfClass:[NSMutableDictionary class]])
	{
		[iTM2RuntimeDictionary setObject:[NSMutableDictionary dictionary] forKey:selsKey];
		sels = [iTM2RuntimeDictionary objectForKey:selsKey];
	}
    Class aClass = theClass;
	NSString * KEY = NSStringFromClass(aClass);
	NSMutableDictionary * MD = [sels objectForKey:KEY];
	if (![MD isKindOfClass:[NSMutableDictionary class]])
	{
		[sels setObject:[NSMutableDictionary dictionary] forKey:KEY];
		MD = [sels objectForKey:KEY];
	}
	if (!suffix.length)
	{
		suffix = @"";
	}
	id temp = [MD objectForKey:suffix];
	if (![temp isKindOfClass:[NSMutableDictionary class]])
	{
		[MD setObject:[NSMutableDictionary dictionary] forKey:suffix];
		temp = [MD objectForKey:suffix];
	}
	MD = temp;
	NSString * methodKey = signature? [signature description]:@"";
	NSPointerArray * result = [MD objectForKey:methodKey];
	if (![result isKindOfClass:[NSPointerArray class]])
	{
        [MD setValue:[self realClassSelectorsOfClass:aClass withSuffix:suffix signature:signature inherited:yorn] forKey:methodKey];
        result = [MD objectForKey:methodKey];
	}
	return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  classSelectorsOfClass:matchedBy:signature:inherited:
+ (NSPointerArray *)classSelectorsOfClass:(Class)theClass matchedBy:(ICURegEx *)RE signature:(NSMethodSignature *)signature inherited:(BOOL)yorn;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (!theClass) {
		return [NSPointerArray pointerArrayWithOptions:NSPointerFunctionsOpaqueMemory|NSPointerFunctionsOpaquePersonality];
    }
	NSString * selsKey = (yorn? @"InheritedClassSelectors": @"ClassSelectors");
	NSMutableDictionary * sels = [iTM2RuntimeDictionary objectForKey:selsKey];
	if (![sels isKindOfClass:[NSMutableDictionary class]]) {
		[iTM2RuntimeDictionary setObject:[NSMutableDictionary dictionary] forKey:selsKey];
		sels = [iTM2RuntimeDictionary objectForKey:selsKey];
	}
    Class aClass = theClass;
	NSString * KEY = NSStringFromClass(aClass);
	NSMutableDictionary * MD = [sels objectForKey:KEY];
	if (![MD isKindOfClass:[NSMutableDictionary class]]) {
		[sels setObject:[NSMutableDictionary dictionary] forKey:KEY];
		MD = [sels objectForKey:KEY];
	}
	NSString * key = RE.searchPattern?:@"";
	id temp = [MD objectForKey:key];
	if (![temp isKindOfClass:[NSMutableDictionary class]]) {
		[MD setObject:[NSMutableDictionary dictionary] forKey:key];
		temp = [MD objectForKey:key];
	}
	MD = temp;
	NSString * methodKey = signature? [signature description]:@"";
	NSPointerArray * result = [MD objectForKey:methodKey];
	if (![result isKindOfClass:[NSPointerArray class]]) {
        [MD setValue:[self realClassSelectorsOfClass:aClass matchedBy:RE signature:signature inherited:yorn] forKey:methodKey];
        result = [MD objectForKey:methodKey];
	}
	return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  realClassSelectorsOfClass:withSuffix:signature:inherited:
+ (NSPointerArray *)realClassSelectorsOfClass:(Class)aClass withSuffix:(NSString *)suffix signature:(NSMethodSignature *)signature inherited:(BOOL)yorn;
/*"Description forthcoming.
 Version history: jlaurens AT users DOT sourceforge DOT net
 To Do List:
 "*/
{DIAGNOSTIC4iTM3;
	//START4iTM3;
	[aClass class];// initialize if needed:this is absolutely necessary
	id SELs = [NSMutableSet set];
	id prepareSELs = [NSMutableSet set];
	SEL selector;
	NSString * name;
	Class originalClass = Nil;
	if (suffix.length)
	{
		if (signature)
		{
			do
			{
				unsigned int outCount;
				Method * methods = class_copyMethodList(aClass->isa, &outCount);
				while(outCount--) {
					selector = method_getName(methods[outCount]);
					name = NSStringFromSelector(selector);
					if ([name hasSuffix:suffix]
					   && [signature isEqual:[aClass->isa instanceMethodSignatureForSelector4iTM3:selector]])
					{
						if ([name hasPrefix:@"prepare"])
							[prepareSELs addObject:name];
						else
							[SELs addObject:name];
					}
				}
				free(methods);
				originalClass = aClass;
				aClass = class_getSuperclass(originalClass);
			}
			while(yorn && aClass && (aClass != originalClass));
		}
		else//if (!signature)
		{
			do
			{
				unsigned int outCount;
				Method * methods = class_copyMethodList(aClass->isa, &outCount);
				while(outCount--) {
					selector = method_getName(methods[outCount]);
					name = NSStringFromSelector(selector);
					if ([name hasSuffix:suffix])
					{
						if ([name hasPrefix:@"prepare"])
							[prepareSELs addObject:name];
						else
							[SELs addObject:name];
					}
				}
				free(methods);
				originalClass = aClass;
				aClass = class_getSuperclass(originalClass);
			}
			while(yorn && aClass && (aClass != originalClass));
		}
	}
	else//if (!suffix.length)
	{
		if (signature)
		{
			do
			{
				unsigned int outCount;
				Method * methods = class_copyMethodList(aClass->isa, &outCount);
				while(outCount--) {
					selector = method_getName(methods[outCount]);
					name = NSStringFromSelector(selector);
					if ([signature isEqual:[aClass->isa instanceMethodSignatureForSelector4iTM3:selector]])
					{
						if ([name hasPrefix:@"prepare"])
							[prepareSELs addObject:name];
						else
							[SELs addObject:name];
					}
				}
				free(methods);
				originalClass = aClass;
				aClass = class_getSuperclass(originalClass);
			}
			while(yorn && aClass && (aClass != originalClass));
		}
		else//if (!signature)
		{
			do
			{
				unsigned int outCount;
				Method * methods = class_copyMethodList(aClass->isa, &outCount);
				while(outCount--) {
					selector = method_getName(methods[outCount]);
					name = NSStringFromSelector(selector);
					if ([name hasPrefix:@"prepare"])
						[prepareSELs addObject:name];
					else
						[SELs addObject:name];
				}
				free(methods);
				originalClass = aClass;
				aClass = class_getSuperclass(originalClass);
			}
			while(yorn && aClass && (aClass != originalClass));
		}
	}
	prepareSELs = [NSMutableArray arrayWithArray:[prepareSELs allObjects]];
	SELs = [NSMutableArray arrayWithArray:[SELs allObjects]];
	[prepareSELs sortUsingSelector:@selector(compare:)];
	[prepareSELs addObjectsFromArray:[SELs sortedArrayUsingSelector:@selector(compare:)]];
	//LOG4iTM3(@"Class: %@ suffix: %@, sels: %@", theClass,suffix, prepareSELs);
	NSPointerArray * result = [NSPointerArray pointerArrayWithOptions:NSPointerFunctionsOpaqueMemory|NSPointerFunctionsOpaquePersonality];
	for(name in prepareSELs)
		[result addPointer:(void *)NSSelectorFromString(name)];
	return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  realClassSelectorsOfClass:matchedBy:signature:inherited:
+ (NSPointerArray *)realClassSelectorsOfClass:(Class)aClass matchedBy:(ICURegEx *)RE signature:(NSMethodSignature *)signature inherited:(BOOL)yorn;
/*"Description forthcoming.
 Version history: jlaurens AT users DOT sourceforge DOT net
 To Do List:
 "*/
{DIAGNOSTIC4iTM3;
	//START4iTM3;
	[aClass class];// initialize if needed:this is absolutely necessary
	id SELs = [NSMutableSet set];
	id prepareSELs = [NSMutableSet set];
	SEL selector;
	NSString * name;
	Class originalClass = Nil;
	if (RE) {
		if (signature) {
			do {
				unsigned int outCount;
				Method * methods = class_copyMethodList(aClass->isa, &outCount);
				while(outCount--) {
					selector = method_getName(methods[outCount]);
					name = NSStringFromSelector(selector);
					if ([RE matchString:name]
                            && [signature isEqual:[aClass->isa instanceMethodSignatureForSelector4iTM3:selector]]) {
						if ([name hasPrefix:@"prepare"])
							[prepareSELs addObject:name];
						else
							[SELs addObject:name];
					}
				}
				free(methods);
				originalClass = aClass;
				aClass = class_getSuperclass(originalClass);
			} while(yorn && aClass && (aClass != originalClass));
		} else /*if (!signature) */ {
			do {
				unsigned int outCount;
				Method * methods = class_copyMethodList(aClass->isa, &outCount);
				while(outCount--) {
					selector = method_getName(methods[outCount]);
					name = NSStringFromSelector(selector);
					if ([RE matchString:name]) {
						if ([name hasPrefix:@"prepare"])
							[prepareSELs addObject:name];
						else
							[SELs addObject:name];
					}
				}
				free(methods);
				originalClass = aClass;
				aClass = class_getSuperclass(originalClass);
			} while(yorn && aClass && (aClass != originalClass));
		}
	}
	else /* if (!suffix.length) */  {
		if (signature) {
			do {
				unsigned int outCount;
				Method * methods = class_copyMethodList(aClass->isa, &outCount);
				while(outCount--) {
					selector = method_getName(methods[outCount]);
					name = NSStringFromSelector(selector);
					if ([signature isEqual:[aClass->isa instanceMethodSignatureForSelector4iTM3:selector]]) {
						if ([name hasPrefix:@"prepare"])
							[prepareSELs addObject:name];
						else
							[SELs addObject:name];
					}
				}
				free(methods);
				originalClass = aClass;
				aClass = class_getSuperclass(originalClass);
			} while(yorn && aClass && (aClass != originalClass));
		} else /* if (!signature) */ {
			do {
				unsigned int outCount;
				Method * methods = class_copyMethodList(aClass->isa, &outCount);
				while(outCount--) {
					selector = method_getName(methods[outCount]);
					name = NSStringFromSelector(selector);
                    [([name hasPrefix:@"prepare"]?prepareSELs:SELs) addObject:name];
				}
				free(methods);
				originalClass = aClass;
				aClass = class_getSuperclass(originalClass);
			} while(yorn && aClass && (aClass != originalClass));
		}
	}
	prepareSELs = [NSMutableArray arrayWithArray:[prepareSELs allObjects]];
	SELs = [NSMutableArray arrayWithArray:[SELs allObjects]];
	[prepareSELs sortUsingSelector:@selector(compare:)];
	[prepareSELs addObjectsFromArray:[SELs sortedArrayUsingSelector:@selector(compare:)]];
	//LOG4iTM3(@"Class: %@ suffix: %@, sels: %@", theClass,suffix, prepareSELs);
	NSPointerArray * result = [NSPointerArray pointerArrayWithOptions:NSPointerFunctionsOpaqueMemory|NSPointerFunctionsOpaquePersonality];
	for(name in prepareSELs)
		[result addPointer:(void *)NSSelectorFromString(name)];
	return result;
}
#if 0
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  newSubclassOfClass:withName:
+ (Class)newSubclassOfClass:(Class)superClass withName:(NSString *)name;
/*"Sample code from apple documentation (Tiger).
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	Class newClass = NSClassFromString(name);
	if ([newClass isSubclassOfClass:superClass])
		return newClass;
	else if (newClass)
		return nil;

    // Find the root class
    Class rootClass = superClass;
	Class candidate;
    while(( candidate = class_getSuperclass(rootClass)) )
    {
        rootClass = candidate;
    }

    // Allocate space for the class and its metaclass
    newClass = calloc( 2, sizeof(struct objc_class) );
    Class metaClass = & newClass[1];
    // setup class
    newClass->isa      = metaClass;
    newClass->info     = CLS_CLASS;
    metaClass->info    = CLS_META;

    //
    // Create a copy of the class name.
    // For efficiency, we have the metaclass and the class itself 
    // to share this copy of the name, but this is not a requirement
    // imposed by the runtime.
    //
	NSUInteger maxBufferCount = [name lengthOfBytesUsingEncoding:NSUTF8StringEncoding] + 1;
	newClass->name = malloc (maxBufferCount);
	[name getCString:(char*)(newClass->name) maxLength:maxBufferCount encoding:NSUTF8StringEncoding];
    metaClass->name = newClass->name;
    //
    // Allocate empty method lists.
    // We can add methods later.
    //
    newClass->methodLists = calloc( 1, sizeof(struct objc_method_list *) );
    *newClass->methodLists = (struct objc_method_list *)-1;
    metaClass->methodLists = calloc( 1, sizeof(struct objc_method_list *) );
    *metaClass->methodLists = (struct objc_method_list *)-1;
    //
    // Connect the class definition to the class hierarchy:
    // Connect the class to the superclass.
    // Connect the metaclass to the metaclass of the superclass.
    // Connect the metaclass of the metaclass to
    //      the metaclass of the root class.
    newClass->super_class  = superClass;
    metaClass->super_class = superClass->isa;
    metaClass->isa         = (void *)rootClass->isa;
    // Finally, register the class with the runtime.
    objc_addClass( newClass ); 
    return newClass;
}
#endif
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  responderMessages:
+ (NSPointerArray *)responderMessages;
/*"Sample code from apple documentation (Tiger).
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSString * K = @"Responder Messages";
	id messages = [iTM2RuntimeDictionary objectForKey:K];
	if ([messages isKindOfClass:[NSPointerArray class]])
	{
		return messages;
	}
	// get all the NSResponder subclasses
	NSMethodSignature * MS = [self instanceMethodSignatureForSelector4iTM3:@selector(forwardInvocation:)];
	NSPointerArray * classes = [self subclassReferencesOfClass:[NSResponder class]];
	messages = [NSPointerArray pointerArrayWithOptions:NSPointerFunctionsOpaqueMemory|NSPointerFunctionsOpaquePersonality];
	NSUInteger i = classes.count;
	while(i--)
	{
		NSPointerArray * PA = [self realInstanceSelectorsOfClass:(Class)[classes pointerAtIndex:i] withSuffix:@"" signature:MS inherited:NO];
		NSUInteger j = PA.count;
		while(j--)
		{
			[classes addPointerIfAbsent4iTM3:[PA pointerAtIndex:j]];
		}
	}
	
//END4iTM3;
	[iTM2RuntimeDictionary setObject:messages forKey:K];
	return messages;
}
@end

@implementation NSMethodSignature(PRIVATE)
- (NSString *)SWZ_iTM2_description;
{
	NSMutableString * result = [NSMutableString string];
	[result appendFormat:@"<NSMethodSignature %x",self];
	NSUInteger numberOfArguments = self.numberOfArguments;
	[result appendFormat:@"\n numberOfArguments %u",numberOfArguments];
	while (numberOfArguments>0) {
		[result appendFormat:@"\n getArgumentTypeAtIndex %u->%s",numberOfArguments,[self getArgumentTypeAtIndex:numberOfArguments-1]];
        --numberOfArguments;
	}
	[result appendFormat:@"\n frameLength %u",self.frameLength];
	[result appendFormat:@"\n isOneway: %@",(self.isOneway?@"YES":@"NO")];
	[result appendFormat:@"\n methodReturnType %s:",self.methodReturnType];
	[result appendFormat:@"\n methodReturnLength %u:",self.methodReturnLength];
	[result appendString:@">"];
	return result;
}
@end

#if 0
Other swizzlers
// if the origSel isn't present in the class, pull it up from where it exists
// then do the swizzle
BOOL _MyPluginTemplate_PerformSwizzle(Class klass, SEL origSel, SEL altSel, BOOL forInstance) {
    // First, make sure the class isn't nil
	if (klass != nil) {
		Method origMethod = NULL, altMethod = NULL;
		
		// Next, look for the methods
		Class iterKlass = (forInstance ? klass : klass->isa);
		unsigned int * methodCount = ZER0;
		Method *mlist = class_copyMethodList(iterKlass, &methodCount);
		if (mlist != NULL) {
			unsigned int i;
			for (i = ZER0; i < methodCount; ++i) {
				
				if (method_getName(mlist[i]) == origSel) {
					origMethod = mlist[i];
					break;
				}
				if (method_getName(mlist[i]) == altSel) {
					altMethod = mlist[i];
					break;
				}
			}
		}
		
		if (origMethod == NULL || altMethod == NULL) {
			// one or both methods are not in the immediate class
			// try searching the entire hierarchy
			// remember, iterKlass is the class we care about - klass || klass->isa
			// class_getInstanceMethod on a metaclass is the same as class_getClassMethod on the real class
			BOOL pullOrig = NO, pullAlt = NO;
			if (origMethod == NULL) {
				origMethod = class_getInstanceMethod(iterKlass, origSel);
				pullOrig = YES;
			}
			if (altMethod == NULL) {
				altMethod = class_getInstanceMethod(iterKlass, altSel);
				pullAlt = YES;
			}
			
			// die now if one of the methods doesn't exist anywhere in the hierarchy
			// this way we won't make any changes to the class if we can't finish
			if (origMethod == NULL || altMethod == NULL) {
				return NO;
			}
			
			// we can safely assume one of the two methods, at least, will be pulled
			// pull them up
			size_t listSize = sizeof(Method);
			if (pullOrig && pullAlt) listSize += sizeof(Method); // need 2 methods
			if (pullOrig) {
				class_addMethod(iterKlass, method_getName(origMethod), method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
			}
			if (pullAlt) {
				class_addMethod(iterKlass, method_getName(altMethod), method_getImplementation(altMethod), method_getTypeEncoding(altMethod));
			}
		}
		
		// now swizzle
		method_exchangeImplementations(origMethod, altMethod);
		
		return YES;
	}
	return NO;
}


#endif


//