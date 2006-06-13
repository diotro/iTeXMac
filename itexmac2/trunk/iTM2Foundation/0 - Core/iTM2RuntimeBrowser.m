/*
//
//  @version Subversion: $Id$ 
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

#import <iTM2Foundation/iTM2RuntimeBrowser.h>
#import <iTM2Foundation/iTM2BundleKit.h>
#import <iTM2Foundation/iTM2NotificationKit.h>
#import <objc/objc.h>
#import <objc/objc-class.h>
#import <objc/objc-runtime.h>

void _objc_flush_caches (Class cls);

@interface NSObject_iTM2RuntimeBrowser: NSObject
@end
@implementation NSObject_iTM2RuntimeBrowser: NSObject
+ (void) poseAsClass: (Class) aClass;
{iTM2_DIAGNOSTIC;
	[super poseAsClass:aClass];
	[iTM2RuntimeBrowser cleanCache];
	return;
}
@end
@implementation NSObject(iTM2RuntimeBrowser)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2_noop
+ (void) iTM2_noop;
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2_noop
- (void) iTM2_noop;
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
@end
@implementation iTM2RuntimeBrowser
static id iTM2RuntimeBrowserDictionary = nil;
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  load
+ (void) load;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
	iTM2_INIT_POOL;
#warning DEBUGGGG
//iTM2_START;
//	[NSObject_iTM2RuntimeBrowser poseAsClass:[NSObject class]];// methods are likely to change when posed as class...
    if(!iTM2RuntimeBrowserDictionary)
	{
		iTM2RuntimeBrowserDictionary = [[NSMutableDictionary dictionary] retain];
		[INC addObserver:self selector:@selector(bundleDidLoadNotified:) name:iTM2BundleDidLoadNotification object:nil];
	}
//iTM2_END;
	iTM2_RELEASE_POOL;
	return;
}
static NSMutableArray * _DelayedSwizzleInvocations;
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  initialize
+ (void) initialize;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
	iTM2_INIT_POOL;
//iTM2_START;
//	[NSObject_iTM2RuntimeBrowser poseAsClass:[NSObject class]];// methods are likely to change when posed as class...
    if(!iTM2RuntimeBrowserDictionary)
	{
		iTM2RuntimeBrowserDictionary = [[NSMutableDictionary dictionary] retain];
		[INC addObserver:self selector:@selector(bundleDidLoadNotified:) name:iTM2BundleDidLoadNotification object:nil];
	}
//iTM2_END;
	iTM2_RELEASE_POOL;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  applicationWillFinishLaunchingNotified:
+ (void) applicationWillFinishLaunchingNotified: (NSNotification *) notification;
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  swizzleInstanceMethodSelector:replacement:forClass:
+ (BOOL) swizzleInstanceMethodSelector: (SEL) orig_sel replacement: (SEL) alt_sel forClass: (Class) aClass;
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
    if(orig_sel == alt_sel)
    {
        iTM2_LOG(@"Same selectors, no swizzling.");
        return NO;
    }
    _objc_flush_caches(aClass);// THIS IS NECESSARY!!!
    if(!sel_isMapped(orig_sel))
    {
        iTM2_LOG(@"%s not mapped, no swizzling.", sel_getName(orig_sel));
        return NO;
    }
    _objc_flush_caches(aClass);// THIS IS NECESSARY!!!
    Method orig_method = class_getInstanceMethod(aClass, orig_sel);
    if(!orig_method)
    {
        iTM2_LOG(@"Original selector %s not implemented by %s instances, no swizzling.", sel_getName(orig_sel), object_getClassName(aClass));
        return NO;
    }
    if(!sel_isMapped(alt_sel))
    {
        iTM2_LOG(@"%s not mapped, no swizzling.", sel_getName(alt_sel));
        return NO;
    }
    Method alt_method = class_getInstanceMethod(aClass, alt_sel);
    if(!alt_method)
    {
        iTM2_LOG(@"*** Alternate selector %s not implemented by %s instances, no swizzling.", sel_getName(alt_sel), object_getClassName(aClass));
        return NO;
    }
    char * temp1 = orig_method->method_types;
    orig_method->method_types = alt_method->method_types;
    alt_method->method_types = temp1;

    IMP temp2 = orig_method->method_imp;
    orig_method->method_imp = alt_method->method_imp;
    alt_method->method_imp = temp2;
    if(iTM2DebugEnabled)
	{
		iTM2_LOG(@"Instance method swizzling in %s\ninstance method %s replaced by %s", object_getClassName(aClass), sel_getName(orig_sel), sel_getName(alt_sel));
	}
//iTM2_END;
    _objc_flush_caches(aClass);// THIS IS NECESSARY!!!
	return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  swizzleClassMethodSelector:replacement:forClass:
+ (BOOL) swizzleClassMethodSelector: (SEL) orig_sel replacement: (SEL) alt_sel forClass: (Class) aClass;
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
    if(orig_sel == alt_sel)
    {
        iTM2_LOG(@"Same selectors, no swizzling.");
        return NO;
    }
    if(!sel_isMapped(orig_sel))
    {
        iTM2_LOG(@"%s not mapped, no swizzling.", sel_getName(orig_sel));
        return NO;
    }
    _objc_flush_caches(aClass);// THIS IS NECESSARY!!!
    Method orig_method = class_getClassMethod(aClass, orig_sel);
    if(!orig_method)
    {
        iTM2_LOG(@"Original selector %s not implemented by %s, no swizzling.", sel_getName(orig_sel), object_getClassName(aClass));
        return NO;
    }
    if(!sel_isMapped(alt_sel))
    {
        iTM2_LOG(@"%s not mapped, no swizzling.", sel_getName(alt_sel));
        return NO;
    }
    Method alt_method = class_getClassMethod(aClass, alt_sel);
    if(!alt_method)
    {
        iTM2_LOG(@"*** Alternate selector %s not implemented by %s, no swizzling.", sel_getName(alt_sel), object_getClassName(aClass));
        return NO;
    }
    char * temp1 = orig_method->method_types;
    orig_method->method_types = alt_method->method_types;
    alt_method->method_types = temp1;

    IMP temp2 = orig_method->method_imp;
    orig_method->method_imp = alt_method->method_imp;
    alt_method->method_imp = temp2;
    
	if(iTM2DebugEnabled)
	{
		iTM2_LOG(@"Class method swizzling in %s\nclass method %s replaced by %s", object_getClassName(aClass), sel_getName(orig_sel), sel_getName(alt_sel));
	}
//iTM2_END;
    _objc_flush_caches(aClass);// THIS IS NECESSARY!!!
	return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  disableInstanceMethodSelector:forClass:
+ (BOOL) disableInstanceMethodSelector: (SEL) orig_sel forClass: (Class) aClass;
/*"Description forthcoming.
Code from cocoadev MethodSwizzle
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	SEL alt_sel = @selector(iTM2_noop);
    if(!aClass)
    {
        iTM2_LOG(@"WARNING: Missing a  class, no swizzling.");
        return NO;
    }
    if(orig_sel == alt_sel)
    {
        iTM2_LOG(@"Same selectors, no swizzling.");
        return NO;
    }
    _objc_flush_caches(aClass);// THIS IS NECESSARY!!!
    if(!sel_isMapped(orig_sel))
    {
        iTM2_LOG(@"%s not mapped, no swizzling.", sel_getName(orig_sel));
        return NO;
    }
    _objc_flush_caches(aClass);// THIS IS NECESSARY!!!
    Method orig_method = class_getInstanceMethod(aClass, orig_sel);
    if(!orig_method)
    {
        iTM2_LOG(@"Original selector %s not implemented by %s instances, no swizzling.", sel_getName(orig_sel), object_getClassName(aClass));
        return NO;
    }
    if(!sel_isMapped(alt_sel))
    {
        iTM2_LOG(@"%s not mapped, no swizzling.", sel_getName(alt_sel));
        return NO;
    }
    Method alt_method = class_getInstanceMethod(aClass, alt_sel);
    if(!alt_method)
    {
        iTM2_LOG(@"*** Alternate selector %s not implemented by %s instances, no swizzling.", sel_getName(alt_sel), object_getClassName(aClass));
        return NO;
    }
    orig_method->method_types = alt_method->method_types;
    orig_method->method_imp = alt_method->method_imp;
    
	if(iTM2DebugEnabled)
	{
		iTM2_LOG(@"Instance method swizzling in %s\ninstance method %s disabled", object_getClassName(aClass), sel_getName(orig_sel));
	}
//iTM2_END;
    _objc_flush_caches(aClass);// THIS IS NECESSARY!!!
	return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  disableClassMethodSelector:forClass:
+ (BOOL) disableClassMethodSelector: (SEL) orig_sel forClass: (Class) aClass;
/*"Description forthcoming.
Code from cocoadev MethodSwizzle
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	SEL alt_sel = @selector(iTM2_noop);
    if(!aClass)
    {
        iTM2_LOG(@"WARNING: Missing a  class, no swizzling.");
        return NO;
    }
    if(orig_sel == alt_sel)
    {
        iTM2_LOG(@"Same selectors, no swizzling.");
        return NO;
    }
    if(!sel_isMapped(orig_sel))
    {
        iTM2_LOG(@"%s not mapped, no swizzling.", sel_getName(orig_sel));
        return NO;
    }
    _objc_flush_caches(aClass);// THIS IS NECESSARY!!!
    Method orig_method = class_getClassMethod(aClass, orig_sel);
    if(!orig_method)
    {
        iTM2_LOG(@"Original selector %s not implemented by %s, no swizzling.", sel_getName(orig_sel), object_getClassName(aClass));
        return NO;
    }
    if(!sel_isMapped(alt_sel))
    {
        iTM2_LOG(@"%s not mapped, no swizzling.", sel_getName(alt_sel));
        return NO;
    }
    Method alt_method = class_getClassMethod(aClass, alt_sel);
    if(!alt_method)
    {
        iTM2_LOG(@"*** Alternate selector %s not implemented by %s, no swizzling.", sel_getName(alt_sel), object_getClassName(aClass));
        return NO;
    }

    orig_method->method_types = alt_method->method_types;
    orig_method->method_imp = alt_method->method_imp;
    
	if(iTM2DebugEnabled)
	{
		iTM2_LOG(@"Class method swizzling in %s\nclass method %s disabled", object_getClassName(aClass), sel_getName(orig_sel));
	}
//iTM2_END;
    _objc_flush_caches(aClass);// THIS IS NECESSARY!!!
	return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  delaySwizzleInstanceMethodSelector:replacement:forClassName:
+ (void) delaySwizzleInstanceMethodSelector: (SEL) orig_sel replacement: (SEL) alt_sel forClassName: (NSString *) aClassName;
/*"Description forthcoming.
Code from cocoadev MethodSwizzle
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
#warning Missing class, and [ initialize] if things do not work
	Class aClass = objc_getClass([aClassName cString]);
	NSParameterAssert(aClass);
    NSParameterAssert(orig_sel != alt_sel);
    SEL selector = @selector(swizzleInstanceMethodSelector:replacement:forClassName:);
    NSInvocation * I = [NSInvocation invocationWithMethodSignature:[self methodSignatureForSelector:selector]];
    [I setTarget:self];
    [I setSelector:selector];
    [I setArgument:&orig_sel atIndex:2];
    [I setArgument:&alt_sel atIndex:3];
    [I setArgument:&aClass atIndex:4];
    if(NSApp)
        [I invoke];
    else
    {
        if(!_DelayedSwizzleInvocations)
            _DelayedSwizzleInvocations = [[NSMutableArray array] retain];
        [_DelayedSwizzleInvocations addObject:I];
        [DNC removeObserver:self];
        [DNC addObserver:self selector:@selector(applicationWillFinishLaunchingNotified:) name:NSApplicationWillFinishLaunchingNotification object:nil];
    }
//iTM2_END;
    return;
}
static NSMutableArray * _DelayedSwizzleInvocations;
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  delaySwizzleInstanceMethodSelector:replacement:forClassName:
+ (void) delaySwizzleClassMethodSelector: (SEL) orig_sel replacement: (SEL) alt_sel forClassName: (NSString *) aClassName;
/*"Description forthcoming.
Code from cocoadev MethodSwizzle
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	Class aClass = objc_getClass([aClassName cString]);
	NSParameterAssert(aClass);
    NSParameterAssert(orig_sel != alt_sel);
    SEL selector = @selector(swizzleClassMethodSelector:replacement:forClassName:);
    NSInvocation * I = [NSInvocation invocationWithMethodSignature:[self methodSignatureForSelector:selector]];
    [I setTarget:self];
    [I setSelector:selector];
    [I setArgument:&orig_sel atIndex:2];
    [I setArgument:&alt_sel atIndex:3];
    [I setArgument:&aClass atIndex:4];
    if(NSApp)
        [I invoke];
    else
    {
        if(!_DelayedSwizzleInvocations)
            _DelayedSwizzleInvocations = [[NSMutableArray array] retain];
        [_DelayedSwizzleInvocations addObject:I];
        [DNC removeObserver:self];
        [DNC addObserver:self selector:@selector(applicationWillFinishLaunchingNotified:)  name:NSApplicationWillFinishLaunchingNotification object:nil];
    }
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  bundleDidLoadNotified:
+ (void) bundleDidLoadNotified: (NSNotification *) notification;
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
+ (void) cleanCache;
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
+ (NSArray *) allClassReferences;
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
+ (NSArray *) subclassReferencesOfClass: (Class) aClass;
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
				const char * cName = [name lossyCString];
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
+ (BOOL) isClass: (Class) lhsClass subclassOfClass: (Class) rhsClass;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	return [self isClass:lhsClass subclassOfClassNamed:[NSStringFromClass(rhsClass) lossyCString]];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  isClass:subclassOfClassNamed:
+ (BOOL) isClass: (Class) target subclassOfClassNamed: (const char *) className;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(!target->super_class)
		return NO;
	else if(!strcmp(target->super_class->name, className))
		return YES;
	else
		return [self isClass:target->super_class subclassOfClassNamed:className];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  numberOfClasses
+ (int) numberOfClasses;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	return [[self allClassReferences] count];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  instanceSelectorsOfClass:withSuffix:signature:inherited:
+ (NSArray *) instanceSelectorsOfClass: (Class) theClass withSuffix: (NSString *) suffix signature: (NSMethodSignature *) signature inherited: (BOOL) yorn;
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
+ (NSArray *) realInstanceSelectorsOfClass: (Class) theClass withSuffix: (NSString *) suffix signature: (NSMethodSignature *) signature inherited: (BOOL) yorn;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[theClass class];// initialize if needed:this is absolutely necessary
	id SELs = [NSMutableSet set];
	id prepareSELs = [NSMutableSet set];
	void * iterator = nil;
	struct objc_method_list * methodListRef = nil;
	SEL selector;
	NSString * name;
    Class aClass = theClass;
	Class originalClass = Nil;
	if([suffix length])
	{
		if(signature)
		{
			do
			{
				while(methodListRef = class_nextMethodList(aClass, &iterator))
				{
					int index = methodListRef->method_count;
					while(index)
					{
						selector = (methodListRef -> method_list[--index]).method_name;
						if(ISSELECTOR(selector))
						{
							name = NSStringFromSelector(selector);
							if([name hasSuffix:suffix]
								&& [signature isEqual:[aClass instanceMethodSignatureForSelector:selector]])
							{
								if([name hasPrefix:@"prepare"])
									[prepareSELs addObject:name];
								else
									[SELs addObject:name];
							}
						}
						else
						{
							iTM2_LOG(@"Unmapped selector...");
						}
					}
				}
				iterator = nil;
				originalClass = aClass;
				aClass = [originalClass superclass];
			}
			while(yorn && aClass && (aClass != originalClass));
		}
		else//if(!signature)
		{
			do
			{
				while(methodListRef = class_nextMethodList(aClass, &iterator))
				{
					int index = methodListRef->method_count;
					while(index)
					{
						selector = (methodListRef -> method_list[--index]).method_name;
						name = NSStringFromSelector(selector);
						if([name hasSuffix:suffix])
						{
							if([name hasPrefix:@"prepare"])
								[prepareSELs addObject:name];
							else
								[SELs addObject:name];
						}
					}
				}
				iterator = nil;
				originalClass = aClass;
				aClass = [originalClass superclass];
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
				while(methodListRef = class_nextMethodList(aClass, &iterator))
				{
					int index = methodListRef->method_count;
					while(index)
					{
						selector = (methodListRef -> method_list[--index]).method_name;
						name = NSStringFromSelector(selector);
						if([signature isEqual:[aClass instanceMethodSignatureForSelector:selector]])
						{
							if([name hasPrefix:@"prepare"])
								[prepareSELs addObject:name];
							else
								[SELs addObject:name];
						}
					}
				}
				iterator = nil;
				originalClass = aClass;
				aClass = [originalClass superclass];
			}
			while(yorn && aClass && (aClass != originalClass));
		}
		else//if(!signature)
		{
			do
			{
				while(methodListRef = class_nextMethodList(aClass, &iterator))
				{
					int index = methodListRef->method_count;
					while(index)
					{
						selector = (methodListRef -> method_list[--index]).method_name;
						name = NSStringFromSelector(selector);
						if([name hasPrefix:@"prepare"])
							[prepareSELs addObject:name];
						else
							[SELs addObject:name];
					}
				}
				iterator = nil;
				originalClass = aClass;
				aClass = [originalClass superclass];
			}
			while(yorn && aClass && (aClass != originalClass));
		}
	}
	prepareSELs = [NSMutableArray arrayWithArray:[prepareSELs allObjects]];
	SELs = [NSMutableArray arrayWithArray:[SELs allObjects]];
	if(iTM2DebugEnabled)
	{
		iTM2_LOG(@"prepareSELs: %@", prepareSELs);
		iTM2_LOG(@"SELs: %@", SELs);
	}
	[prepareSELs sortUsingSelector:@selector(compare:)];
	[prepareSELs addObjectsFromArray:[SELs sortedArrayUsingSelector:@selector(compare:)]];
	NSEnumerator * E = [prepareSELs objectEnumerator];
	SELs = [NSMutableArray array];
	while(name = [E nextObject])
		[SELs addObject:[NSValue valueWithPointer:NSSelectorFromString(name)]];
//iTM2_END;
	return [NSArray arrayWithArray:SELs];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  classSelectorsOfClass:withSuffix:signature:inherited:
+ (NSArray *) classSelectorsOfClass: (Class) theClass withSuffix: (NSString *) suffix signature: (NSMethodSignature *) signature inherited: (BOOL) yorn;
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
+ (NSArray *) realClassSelectorsOfClass: (Class) aClass withSuffix: (NSString *) suffix signature: (NSMethodSignature *) signature inherited: (BOOL) yorn;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[aClass class];// initialize if needed:this is absolutely necessary
	id SELs = [NSMutableSet set];
	id prepareSELs = [NSMutableSet set];
	void * iterator = nil;
	struct objc_method_list * methodListRef = nil;
	SEL selector;
	NSString * name;
	Class originalClass = Nil;
	if([suffix length])
	{
		if(signature)
		{
			do
			{
				while(methodListRef = class_nextMethodList(aClass->isa, &iterator))
				{
					int index = methodListRef->method_count;
					while(index)
					{
						selector = (methodListRef -> method_list[--index]).method_name;
						if(ISSELECTOR(selector))
						{
							name = NSStringFromSelector(selector);
							if([name hasSuffix:suffix]
								&& [signature isEqual:[aClass->isa instanceMethodSignatureForSelector:selector]])
							{
								if([name hasPrefix:@"prepare"])
									[prepareSELs addObject:name];
								else
									[SELs addObject:name];
							}
						}
						else
						{
							iTM2_LOG(@"Unmapped selector...");
						}
					}
				}
				iterator = nil;
				originalClass = aClass;
				aClass = [originalClass superclass];
			}
			while(yorn && aClass && (aClass != originalClass));
		}
		else//if(!signature)
		{
			do
			{
				while(methodListRef = class_nextMethodList(aClass->isa, &iterator))
				{
					int index = methodListRef->method_count;
					while(index)
					{
						selector = (methodListRef -> method_list[--index]).method_name;
						name = NSStringFromSelector(selector);
						if([name hasSuffix:suffix])
						{
							if([name hasPrefix:@"prepare"])
								[prepareSELs addObject:name];
							else
								[SELs addObject:name];
						}
					}
				}
				iterator = nil;
				originalClass = aClass;
				aClass = [originalClass superclass];
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
				while(methodListRef = class_nextMethodList(aClass->isa, &iterator))
				{
					int index = methodListRef->method_count;
					while(index)
					{
						selector = (methodListRef -> method_list[--index]).method_name;
						name = NSStringFromSelector(selector);
						if([signature isEqual:[aClass->isa instanceMethodSignatureForSelector:selector]])
						{
							if([name hasPrefix:@"prepare"])
								[prepareSELs addObject:name];
							else
								[SELs addObject:name];
						}
					}
				}
				iterator = nil;
				originalClass = aClass;
				aClass = [originalClass superclass];
			}
			while(yorn && aClass && (aClass != originalClass));
		}
		else//if(!signature)
		{
			do
			{
				while(methodListRef = class_nextMethodList(aClass->isa, &iterator))
				{
					int index = methodListRef->method_count;
					while(index)
					{
						selector = (methodListRef -> method_list[--index]).method_name;
						name = NSStringFromSelector(selector);
						if([name hasPrefix:@"prepare"])
							[prepareSELs addObject:name];
						else
							[SELs addObject:name];
					}
				}
				iterator = nil;
				originalClass = aClass;
				aClass = [originalClass superclass];
			}
			while(yorn && aClass && (aClass != originalClass));
		}
	}
	prepareSELs = [NSMutableArray arrayWithArray:[prepareSELs allObjects]];
	SELs = [NSMutableArray arrayWithArray:[SELs allObjects]];
	[prepareSELs sortUsingSelector:@selector(compare:)];
	[prepareSELs addObjectsFromArray:[SELs sortedArrayUsingSelector:@selector(compare:)]];
//iTM2_LOG(@"Class: %@ suffix: %@, sels: %@", theClass,suffix, prepareSELs);
	NSEnumerator * E = [prepareSELs objectEnumerator];
	SELs = [NSMutableArray array];
	while(name = [E nextObject])
		[SELs addObject:[NSValue valueWithPointer:NSSelectorFromString(name)]];
	if(iTM2DebugEnabled>999)
	{
		iTM2_LOG(@"SELs are: %@", prepareSELs);
	}
	return [NSArray arrayWithArray:SELs];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  newSubclassOfClass:withName:
+ (Class) newSubclassOfClass: (Class) superClass withName: (NSString *) name;
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
    while( rootClass->super_class != nil )
    {
        rootClass = rootClass->super_class;
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
    newClass->name = malloc ([name cStringLength] + 1);
    strcpy ((char*)newClass->name, [name lossyCString]);
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
@end
