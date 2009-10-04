/*
//
//  @version Subversion: $Id$ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Mon May 10 22:45:25 GMT 2004.
//  Copyright ¬© 2005 Laurens'Tribune. All rights reserved.
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

#import <iTM2Foundation/iTM2RuntimeBrowser.h>
#import <iTM2Foundation/iTM2BundleKit.h>
#import <iTM2Foundation/iTM2NotificationKit.h>
#import <iTM2Foundation/ICURegEx.h>
#import <objc/objc.h>
#import <objc/objc-class.h>
#import <objc/objc-runtime.h>

void _objc_flush_caches (Class cls);

@interface NSObject(iTM2RuntimeBrowser_Private)
+ (id)iTM2_instanceMethodSignatureForSelector:(SEL)aSelector;
@end
@implementation NSObject(iTM2RuntimeBrowser)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2_swizzleInstanceMethodSelector:
+ (BOOL)iTM2_swizzleInstanceMethodSelector:(SEL)selector;
/*"swizzle instance selector.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Jan 29 10:15:13 UTC 2008
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(![self instancesRespondToSelector:selector])
	{
        iTM2_LOG(@"%#x is not a known selector, no swizzling.", selector);
        return NO;
	}
	const char * selector_name = sel_getName(selector);
	const char * prefix = "SWZ_";
	if(strncmp(selector_name,prefix,strlen(prefix))) {
        iTM2_LOG(@"%s is not a valid selector for short swizzling.", selector_name);
		return NO;
	}
	char * orig_selector_name = strstr(selector_name+strlen(prefix),"_");
	if(!orig_selector_name) {
        iTM2_LOG(@"%s is not a valid selector for short swizzling.", selector_name);
		return NO;
	}
	SEL orig_selector = sel_registerName(++orig_selector_name);
	return [iTM2RuntimeBrowser swizzleInstanceMethodSelector:orig_selector replacement:selector forClass:self error:nil];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2_swizzleClassMethodSelector:
+ (BOOL)iTM2_swizzleClassMethodSelector:(SEL)selector;
/*"swizzle instance selector.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Jan 29 10:15:13 UTC 2008
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	ICURegEx * RE = [ICURegEx regExWithSearchPattern:@"^SWZ_.*?_(.*)"];
	[RE setInputString:NSStringFromSelector(selector)];
	if([RE nextMatch])
	{
		SEL swizzled = NSSelectorFromString([RE substringOfCaptureGroupAtIndex:1]);
//iTM2_END;
		return [iTM2RuntimeBrowser swizzleClassMethodSelector:selector replacement:swizzled forClass:self error:nil];
	}
//iTM2_END;
	return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2Runtime_noop
+ (void)iTM2Runtime_noop;
/*"Designated Initializer.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: Thu Oct 10 2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
	if(iTM2DebugEnabled)
	{
		iTM2_LOG(@"Here I am");
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
{iTM2_DIAGNOSTIC;
	if(iTM2DebugEnabled)
	{
		iTM2_LOG(@"Here I am");
	}
	return;
}
+ (id)iTM2_instanceMethodSignatureForSelector:(SEL)aSelector;
{
	id result = nil;
NS_DURING
	result = [self instancesRespondToSelector:(SEL)aSelector]?[self instanceMethodSignatureForSelector:(SEL)aSelector]:nil;
NS_HANDLER
	result = nil;
	iTM2_LOG(@"Exception catched");
NS_ENDHANDLER
	return result;
}
@end

@implementation iTM2RuntimeBrowser
static id iTM2RuntimeBrowserDictionary = nil;
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  load
+ (void)load;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
	iTM2_INIT_POOL;
	iTM2RedirectNSLogOutput();
//iTM2_START;
    if(!iTM2RuntimeBrowserDictionary)
	{
		iTM2RuntimeBrowserDictionary = [[NSMutableDictionary dictionary] retain];
		[INC addObserver:self selector:@selector(bundleDidLoadNotified:) name:iTM2BundleDidLoadNotification object:nil];
	}
//iTM2_END;
	iTM2_RELEASE_POOL;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  initialize
+ (void)initialize;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
	iTM2_INIT_POOL;
//iTM2_START;
    if(!iTM2RuntimeBrowserDictionary)
	{
		iTM2RuntimeBrowserDictionary = [[NSMutableDictionary dictionary] retain];
		[INC addObserver:self selector:@selector(bundleDidLoadNotified:) name:iTM2BundleDidLoadNotification object:nil];
	}
//iTM2_END;
	iTM2_RELEASE_POOL;
	return;
}
static NSMutableArray * _DelayedSwizzleInvocations = nil;
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  applicationWillFinishLaunchingNotified:
+ (void)applicationWillFinishLaunchingNotified:(NSNotification *)notification;
/*"Description forthcoming.
Code from cocoadev MethodSwizzle
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [DNC removeObserver:self];
    [_DelayedSwizzleInvocations makeObjectsPerformSelector:@selector(invoke) withObject:nil];
    [_DelayedSwizzleInvocations autorelease];
    _DelayedSwizzleInvocations = nil;
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  swizzleInstanceMethodSelector:replacement:forClass:error:
+ (BOOL)swizzleInstanceMethodSelector:(SEL)origSel_ replacement:(SEL)altSel_ forClass:(Class)aClass error:(NSError **)errorRef;
/*"Description forthcoming.
Code from cocoadev MethodSwizzle
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(errorRef)
	{
		*errorRef = nil;
	}
    if(!aClass)
    {
        iTM2_LOG(@"WARNING: Missing a  class, no swizzling.");
        return NO;
    }
    if(origSel_ == altSel_)
    {
        iTM2_LOG(@"Same selectors, no swizzling.");
        return NO;
    }
	Method origMethod = class_getInstanceMethod(aClass, origSel_);
	if (!origMethod) {
#define SetNSError(ERROR_VAR, FORMAT,...)       \
if (ERROR_VAR) {        \
NSString *errStr = [@"+[NSObject(JRSwizzle) jr_swizzleMethod:withMethod:error:]: " stringByAppendingFormat:FORMAT,##__VA_ARGS__];       \
*ERROR_VAR = [NSError errorWithDomain:@"NSCocoaErrorDomain" \
code:-1        \
userInfo:[NSDictionary dictionaryWithObject:errStr forKey:NSLocalizedDescriptionKey]]; \
}
		SetNSError(errorRef, @"original method %@ not found for class %@", NSStringFromSelector(origSel_), [aClass className]);
		return NO;
	}
	
	Method altMethod = class_getInstanceMethod(aClass, altSel_);
	if (!altMethod) {
		SetNSError(errorRef, @"alternate method %@ not found for class %@", NSStringFromSelector(altSel_), [aClass className]);
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
+ (BOOL)swizzleClassMethodSelector:(SEL)orig_sel replacement:(SEL)alt_sel forClass:(Class)aClass error:(NSError **) errorRef;
/*"Description forthcoming.
Code from cocoadev MethodSwizzle
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(errorRef)
	{
		*errorRef = nil;
	}
	if(!aClass)
    {
        iTM2_LOG(@"WARNING: Missing a  class, no swizzling.");
        return NO;
    }
//iTM2_END;
	return [self swizzleInstanceMethodSelector:orig_sel replacement:alt_sel forClass:aClass->isa error:errorRef];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  disableInstanceMethodSelector:forClass:
+ (BOOL)disableInstanceMethodSelector:(SEL)orig_sel forClass:(Class)aClass;
/*"Description forthcoming.
Code from cocoadev MethodSwizzle
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(!aClass)
    {
        iTM2_LOG(@"WARNING: Missing a  class, no swizzling.");
        return NO;
    }
	SEL alt_sel = @selector(iTM2Runtime_noop);
    if(orig_sel == alt_sel)
    {
        iTM2_LOG(@"Same selectors, no swizzling.");
        return NO;
    }
	if(!class_respondsToSelector(aClass, orig_sel))
    {
        iTM2_LOG(@"%s not mapped, no swizzling.", sel_getName(orig_sel));
        return NO;
    }
    Method orig_method = class_getInstanceMethod(aClass, orig_sel);
    Method alt_method = class_getInstanceMethod(aClass, alt_sel);
	Method clone_method;
	bcopy(&alt_method, &clone_method, sizeof(clone_method));
	method_exchangeImplementations(orig_method, clone_method);
	if(iTM2DebugEnabled)
	{
		iTM2_LOG(@"Instance method swizzling in %s\ninstance method %s disabled", object_getClassName(aClass), sel_getName(orig_sel));
	}
//iTM2_END;
	return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  disableClassMethodSelector:forClass:
+ (BOOL)disableClassMethodSelector:(SEL)orig_sel forClass:(Class)aClass;
/*"Description forthcoming.
Code from cocoadev MethodSwizzle
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(!aClass)
    {
        iTM2_LOG(@"WARNING: Missing a  class, no swizzling.");
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self cleanCache];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  cleanCache
+ (void)cleanCache;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	// all the cached results are cleaned
	int oldNumClasses = [self numberOfClasses];
	int newNumClasses = objc_getClassList(NULL, 0);
	if(oldNumClasses != newNumClasses)
	{
//iTM2_LOG(@"New classes are available: old %i, new %i", oldNumClasses, newNumClasses);
		[iTM2RuntimeBrowserDictionary takeValue:[NSMutableDictionary dictionary] forKey:@"Classes"];
		[iTM2RuntimeBrowserDictionary takeValue:[NSArray array] forKey:@"Main"];
	}
	[iTM2RuntimeBrowserDictionary setObject:[NSMutableDictionary dictionary] forKey:@"Selectors"];
	[iTM2RuntimeBrowserDictionary setObject:[NSMutableDictionary dictionary] forKey:@"InheritedSelectors"];
	[iTM2RuntimeBrowserDictionary setObject:[NSMutableDictionary dictionary] forKey:@"ClassSelectors"];
	[iTM2RuntimeBrowserDictionary setObject:[NSMutableDictionary dictionary] forKey:@"InheritedClassSelectors"];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  allClassReferences
+ (NSArray *)allClassReferences;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_LOG(@"I AM CURRENLY LOOKING FOR ALL CLASSES");
	NSArray * result = [iTM2RuntimeBrowserDictionary valueForKey:@"Main"];
	if(![result count])
	{
		int numClasses = objc_getClassList(NULL, 0);
		Class * classes = NULL;
		if(numClasses > 0)
		{
			classes = malloc( sizeof(Class) * numClasses );
			(void) objc_getClassList(classes, numClasses);
			NSMutableArray * MRA = [NSMutableArray array];
			Class * ptr = classes;
			[MRA addObject:[NSValue valueWithNonretainedObject:*ptr]];
//iTM2_LOG(@"CLASS number %i IS: %@", numClasses, NSStringFromClass(* ptr));
			while(--numClasses>0)
			{
				++ptr;
				[MRA addObject:[NSValue valueWithNonretainedObject:*ptr]];
//iTM2_LOG(@"CLASS number %i IS: %@", numClasses, NSStringFromClass(* ptr));
			}
			free(classes);
			result = [NSArray arrayWithArray:MRA];
			[iTM2RuntimeBrowserDictionary takeValue:result forKey:@"Main"];
		}
	}
//iTM2_LOG(@"THAT'S ALL");
//iTM2_END;
	return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  subclassReferencesOfClass:
+ (NSArray *)subclassReferencesOfClass:(Class)aClass;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * name = NSStringFromClass(aClass);
//iTM2_LOG(@"I AM CURRENLY LOOKING FOR SUBCLASSES OF: %@", name);
	id classArray = [iTM2RuntimeBrowserDictionary objectForKey:@"Classes"];
	id result = [classArray objectForKey:name];
	if(!result)
	{
		Class * classes = NULL;
		int numClasses = objc_getClassList(NULL, 0);
		if(numClasses > 0 )
		{
			if(classes = malloc(sizeof(Class) * numClasses))
			{
				(void)objc_getClassList(classes, numClasses);
				NSMutableArray * MRA = [NSMutableArray arrayWithCapacity:numClasses];
				Class * ptr = classes;
				const char * cName = [name UTF8String];
				while(numClasses--)
				{
//if([NSStringFromClass(* ptr) hasPrefix:@"iTM2TeXP"])
//NSLog(@"DEBUGGGGGG");
					if([self isClass:* ptr subclassOfClassNamed:cName])
					{
						[MRA addObject:[NSValue valueWithNonretainedObject:* ptr]];
//iTM2_LOG(@"ADDED CLASS number %i IS: %@", numClasses, NSStringFromClass(* ptr));
					}
					else
					{
//iTM2_LOG(@"IGNORED CLASS number %i IS: %@", numClasses, NSStringFromClass(* ptr));
					}
					++ ptr;
				}
				free(classes);
				result = [NSArray arrayWithArray:MRA];
				[classArray takeValue:result forKey:name];
			}
			else
			{
				iTM2_LOG(@"MEMORY problem, missing %i class locations", numClasses);
			}
		}
		else
		{
			result = [NSArray array];
			[classArray takeValue:result forKey:name];
		}
	}
//iTM2_END;
//iTM2_LOG(@"THE RESULT IS: %@", result);
	return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  isClass:subclassOfClass:
+ (BOOL)isClass:(Class)lhsClass subclassOfClass:(Class)rhsClass;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	return [self isClass:lhsClass subclassOfClassNamed:[NSStringFromClass(rhsClass) UTF8String]];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  isClass:subclassOfClassNamed:
+ (BOOL)isClass:(Class)target subclassOfClassNamed:(const char *)className;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	Class super_class = class_getSuperclass(target);
	if(!super_class)
		return NO;
	else if(!strncmp(class_getName(target),"NSKVO",5))
		return NO;
	else if(!strcmp(class_getName(super_class), className))
		return YES;
	else
		return [self isClass:super_class subclassOfClassNamed:className];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  numberOfClasses
+ (int)numberOfClasses;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	return [[self allClassReferences] count];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  instanceSelectorsOfClass:withSuffix:signature:inherited:
+ (NSArray *)instanceSelectorsOfClass:(Class)theClass withSuffix:(NSString *)suffix signature:(NSMethodSignature *)signature inherited:(BOOL)yorn;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(!theClass)
		return [NSArray array];
	NSString * selsKey = (yorn? @"InheritedSelectors": @"Selectors");
	NSMutableDictionary * sels = [iTM2RuntimeBrowserDictionary objectForKey:selsKey];
	if(![sels isKindOfClass:[NSMutableDictionary class]])
	{
		[iTM2RuntimeBrowserDictionary setObject:[NSMutableDictionary dictionary] forKey:selsKey];
		sels = [iTM2RuntimeBrowserDictionary objectForKey:selsKey];
	}
	NSString * KEY = NSStringFromClass(theClass);
	NSMutableDictionary * MD = [sels objectForKey:KEY];
	if(![MD isKindOfClass:[NSMutableDictionary class]])
	{
		[sels setObject:[NSMutableDictionary dictionary] forKey:KEY];
		MD = [sels objectForKey:KEY];
	}
	if(![suffix length])
	{
		suffix = @"";
	}
	id temp = [MD objectForKey:suffix];
	if(![temp isKindOfClass:[NSMutableDictionary class]])
	{
		[MD setObject:[NSMutableDictionary dictionary] forKey:suffix];
		temp = [MD objectForKey:suffix];
	}
	MD = temp;
	NSString * methodKey = signature? [signature description]:@"";
	NSArray * result = [MD objectForKey:methodKey];
	if(![result isKindOfClass:[NSArray class]])
	{
		result = [self realInstanceSelectorsOfClass:(Class) theClass withSuffix:(NSString *) suffix signature:(NSMethodSignature *) signature inherited:(BOOL) yorn];
        [MD takeValue:result forKey:methodKey];
        result = [MD objectForKey:methodKey];
	}
	return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  realInstanceSelectorsOfClass:withSuffix:signature:inherited:
+ (NSArray *)realInstanceSelectorsOfClass:(Class)aClass withSuffix:(NSString *)suffix signature:(NSMethodSignature *)signature inherited:(BOOL)yorn;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
	//iTM2_START;
	[aClass class];// initialize if needed:this is absolutely necessary
	id SELs = [NSMutableSet set];
	id prepareSELs = [NSMutableSet set];
	SEL selector;
	NSString * name;
	Class originalClass = Nil;
	if([suffix length])
	{
		if(signature)
		{
			do
			{
				unsigned int outCount;
				Method * methods = class_copyMethodList(aClass, &outCount);
				while(outCount--) {
					selector = method_getName(methods[outCount]);
					name = NSStringFromSelector(selector);
					if([name hasSuffix:suffix]
					   && [signature isEqual:[aClass iTM2_instanceMethodSignatureForSelector:selector]])
					{
						if([name hasPrefix:@"prepare"])
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
		else//if(!signature)
		{
			do
			{
				unsigned int outCount;
				Method * methods = class_copyMethodList(aClass, &outCount);
				while(outCount--) {
					selector = method_getName(methods[outCount]);
					name = NSStringFromSelector(selector);
					if([name hasSuffix:suffix])
					{
						if([name hasPrefix:@"prepare"])
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
	else//if(![suffix length])
	{
		if(signature)
		{
			do
			{
				unsigned int outCount;
				Method * methods = class_copyMethodList(aClass, &outCount);
				while(outCount--) {
					selector = method_getName(methods[outCount]);
					name = NSStringFromSelector(selector);
					if([signature isEqual:[aClass iTM2_instanceMethodSignatureForSelector:selector]])
					{
						if([name hasPrefix:@"prepare"])
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
		else//if(!signature)
		{
			do
			{
				unsigned int outCount;
				Method * methods = class_copyMethodList(aClass, &outCount);
				while(outCount--) {
					selector = method_getName(methods[outCount]);
					name = NSStringFromSelector(selector);
					if([name hasPrefix:@"prepare"])
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
	//iTM2_LOG(@"Class: %@ suffix: %@, sels: %@", theClass,suffix, prepareSELs);
	SELs = [NSMutableArray array];
	for(name in prepareSELs)
		[SELs addObject:[NSValue valueWithPointer:NSSelectorFromString(name)]];
	if(iTM2DebugEnabled>999)
	{
		iTM2_LOG(@"SELs are: %@", prepareSELs);
	}
	return [NSArray arrayWithArray:SELs];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  classSelectorsOfClass:withSuffix:signature:inherited:
+ (NSArray *)classSelectorsOfClass:(Class)theClass withSuffix:(NSString *)suffix signature:(NSMethodSignature *)signature inherited:(BOOL)yorn;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(!theClass)
		return [NSArray array];
	NSString * selsKey = (yorn? @"InheritedClassSelectors": @"ClassSelectors");
	NSMutableDictionary * sels = [iTM2RuntimeBrowserDictionary objectForKey:selsKey];
	if(![sels isKindOfClass:[NSMutableDictionary class]])
	{
		[iTM2RuntimeBrowserDictionary setObject:[NSMutableDictionary dictionary] forKey:selsKey];
		sels = [iTM2RuntimeBrowserDictionary objectForKey:selsKey];
	}
    Class aClass = theClass;
	NSString * KEY = NSStringFromClass(aClass);
	NSMutableDictionary * MD = [sels objectForKey:KEY];
	if(![MD isKindOfClass:[NSMutableDictionary class]])
	{
		[sels setObject:[NSMutableDictionary dictionary] forKey:KEY];
		MD = [sels objectForKey:KEY];
	}
	if(![suffix length])
	{
		suffix = @"";
	}
	id temp = [MD objectForKey:suffix];
	if(![temp isKindOfClass:[NSMutableDictionary class]])
	{
		[MD setObject:[NSMutableDictionary dictionary] forKey:suffix];
		temp = [MD objectForKey:suffix];
	}
	MD = temp;
	NSString * methodKey = signature? [signature description]:@"";
	NSArray * result = [MD objectForKey:methodKey];
	if(![result isKindOfClass:[NSArray class]])
	{
        [MD takeValue:[self realClassSelectorsOfClass:(Class) aClass withSuffix:(NSString *) suffix signature:(NSMethodSignature *) signature inherited:(BOOL) yorn] forKey:methodKey];
        result = [MD objectForKey:methodKey];
	}
	return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  realClassSelectorsOfClass:withSuffix:signature:inherited:
+ (NSArray *)realClassSelectorsOfClass:(Class)aClass withSuffix:(NSString *)suffix signature:(NSMethodSignature *)signature inherited:(BOOL)yorn;
/*"Description forthcoming.
 Version history: jlaurens AT users DOT sourceforge DOT net
 To Do List:
 "*/
{iTM2_DIAGNOSTIC;
	//iTM2_START;
	[aClass class];// initialize if needed:this is absolutely necessary
	id SELs = [NSMutableSet set];
	id prepareSELs = [NSMutableSet set];
	SEL selector;
	NSString * name;
	Class originalClass = Nil;
	if([suffix length])
	{
		if(signature)
		{
			do
			{
				unsigned int outCount;
				Method * methods = class_copyMethodList(aClass->isa, &outCount);
				while(outCount--) {
					selector = method_getName(methods[outCount]);
					name = NSStringFromSelector(selector);
					if([name hasSuffix:suffix]
					   && [signature isEqual:[aClass->isa iTM2_instanceMethodSignatureForSelector:selector]])
					{
						if([name hasPrefix:@"prepare"])
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
		else//if(!signature)
		{
			do
			{
				unsigned int outCount;
				Method * methods = class_copyMethodList(aClass->isa, &outCount);
				while(outCount--) {
					selector = method_getName(methods[outCount]);
					name = NSStringFromSelector(selector);
					if([name hasSuffix:suffix])
					{
						if([name hasPrefix:@"prepare"])
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
	else//if(![suffix length])
	{
		if(signature)
		{
			do
			{
				unsigned int outCount;
				Method * methods = class_copyMethodList(aClass->isa, &outCount);
				while(outCount--) {
					selector = method_getName(methods[outCount]);
					name = NSStringFromSelector(selector);
					if([signature isEqual:[aClass->isa iTM2_instanceMethodSignatureForSelector:selector]])
					{
						if([name hasPrefix:@"prepare"])
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
		else//if(!signature)
		{
			do
			{
				unsigned int outCount;
				Method * methods = class_copyMethodList(aClass->isa, &outCount);
				while(outCount--) {
					selector = method_getName(methods[outCount]);
					name = NSStringFromSelector(selector);
					if([name hasPrefix:@"prepare"])
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
	//iTM2_LOG(@"Class: %@ suffix: %@, sels: %@", theClass,suffix, prepareSELs);
	SELs = [NSMutableArray array];
	for(name in prepareSELs)
		[SELs addObject:[NSValue valueWithPointer:NSSelectorFromString(name)]];
	if(iTM2DebugEnabled>999)
	{
		iTM2_LOG(@"SELs are: %@", prepareSELs);
	}
	return [NSArray arrayWithArray:SELs];
}
#if 0
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  newSubclassOfClass:withName:
+ (Class)newSubclassOfClass:(Class)superClass withName:(NSString *)name;
/*"Sample code from apple documentation (Tiger).
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	Class newClass = NSClassFromString(name);
	if([newClass isSubclassOfClass:superClass])
		return newClass;
	else if(newClass)
		return nil;

    // Find the root class
    Class rootClass = superClass;
	Class candidate;
    while( candidate = class_getSuperclass(rootClass) )
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
+ (NSArray *)responderMessages;
/*"Sample code from apple documentation (Tiger).
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * K = @"Responder Messages";
	id messages = [iTM2RuntimeBrowserDictionary objectForKey:K];
	if([messages isKindOfClass:[NSArray class]])
	{
		return messages;
	}
	// get all the NSResponder subclasses
	NSMethodSignature * MS = [self iTM2_instanceMethodSignatureForSelector:@selector(forwardInvocation:)];
	NSArray * classes = [self subclassReferencesOfClass:[NSResponder class]];
	messages = [NSMutableSet set];
	NSEnumerator * E = [classes objectEnumerator];
	Class C;
	while(C = [[E nextObject] pointerValue])
	{
		NSArray * RA = [self realInstanceSelectorsOfClass:C withSuffix:@"" signature:MS inherited:NO];
		[messages addObjectsFromArray:RA];
	}
//iTM2_END;
	messages = [messages allObjects];
	[iTM2RuntimeBrowserDictionary setObject:messages forKey:K];
	return messages;
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
		unsigned int methodCount = 0;
		Method *mlist = class_copyMethodList(iterKlass, &methodCount);
		if (mlist != NULL) {
			int i;
			for (i = 0; i < methodCount; ++i) {
				
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