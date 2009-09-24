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
    if(!ISSELECTOR(selector))
    {
        iTM2_LOG(@"%#x is not a selector, no swizzling.", selector);
        return NO;
    }
	const char * selector_name = SELNAME(selector);
	const char * prefix = "SWZ_";
	if(strncmp(selector_name,prefix,strlen(prefix))) {
        iTM2_LOG(@"%s is not a valid selector for short swizzling.", selector_name);
		return NO;
	}
	Method method = class_getInstanceMethod(self,selector);
    if(!method)
    {
        iTM2_LOG(@"*** new selector %s not implemented by %s instances, no swizzling.", sel_getName(selector), object_getClassName(self));
        return NO;
    }
	char * new_selector_name = strstr(selector_name+strlen(prefix),"_");
	if(!new_selector_name) {
        iTM2_LOG(@"%s is not a valid selector for short swizzling.", selector_name);
		return NO;
	}
	SEL new_selector = sel_registerName(++new_selector_name);
	// is it an inherited method?
	Method new_method = NULL;
	void *iterator = NULL;
	struct objc_method_list *method_list = NULL;
	while (method_list = class_nextMethodList(self, &iterator)) {
		int i = method_list->method_count;
		while (i--) {
			if (method_list->method_list[i].method_name == new_selector) {
				/* No it is not an inherited method */
				new_method = method_list->method_list+i;
swizzle:
				{
					char * temp1 = new_method->method_types;
					new_method->method_types = method->method_types;
					method->method_types = temp1;
					IMP temp2 = new_method->method_imp;
					new_method->method_imp = method->method_imp;
					method->method_imp = temp2;
//iTM2_END;
					return YES;
				}
			}
		}
	}
	/* Yes it is an inherited method
	 * We must duplicate this method in self
	 * because we do not want superclasses to see their methods unexpectedly swizzled */
	Method inherited_method = class_getInstanceMethod(self, new_selector);
    if(!inherited_method)
    {
        iTM2_LOG(@"*** original selector %s not implemented by %s instances, no swizzling.", sel_getName(selector), object_getClassName(self));
        return NO;
    }
	method_list = malloc(sizeof(*method_list));
	method_list->method_count = 1;
	new_method = method_list->method_list;
    bcopy(inherited_method, new_method, sizeof(*inherited_method));
	class_addMethods(self, method_list);
	goto swizzle;
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
		return [iTM2RuntimeBrowser swizzleClassMethodSelector:selector replacement:swizzled forClass:self];
	}
//iTM2_END;
	return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2_noop
+ (void)iTM2_noop;
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
- (void)iTM2_noop;
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  swizzleInstanceMethodSelector:replacement:forClass:
+ (BOOL)swizzleInstanceMethodSelector:(SEL)orig_sel replacement:(SEL)alt_sel forClass:(Class)aClass;
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
+ (BOOL)swizzleClassMethodSelector:(SEL)orig_sel replacement:(SEL)alt_sel forClass:(Class)aClass;
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
+ (BOOL)disableInstanceMethodSelector:(SEL)orig_sel forClass:(Class)aClass;
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
+ (BOOL)disableClassMethodSelector:(SEL)orig_sel forClass:(Class)aClass;
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
+ (void)delaySwizzleInstanceMethodSelector:(SEL)orig_sel replacement:(SEL)alt_sel forClassName:(NSString *)aClassName;
/*"Description forthcoming.
Code from cocoadev MethodSwizzle
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
#warning Missing class, and [ initialize] if things do not work
	Class aClass = objc_getClass([aClassName cStringUsingEncoding:NSASCIIStringEncoding]);
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
		{
            _DelayedSwizzleInvocations = [[NSMutableArray array] retain];
		}
        [_DelayedSwizzleInvocations addObject:I];
        [DNC removeObserver:self];
        [DNC addObserver:self selector:@selector(applicationWillFinishLaunchingNotified:) name:NSApplicationWillFinishLaunchingNotification object:nil];
    }
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  delaySwizzleInstanceMethodSelector:replacement:forClassName:
+ (void)delaySwizzleClassMethodSelector:(SEL)orig_sel replacement:(SEL)alt_sel forClassName:(NSString *)aClassName;
/*"Description forthcoming.
Code from cocoadev MethodSwizzle
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	Class aClass = objc_getClass([aClassName cStringUsingEncoding:NSASCIIStringEncoding]);
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
		{
            _DelayedSwizzleInvocations = [[NSMutableArray array] retain];
		}
        [_DelayedSwizzleInvocations addObject:I];
        [DNC removeObserver:self];
        [DNC addObserver:self selector:@selector(applicationWillFinishLaunchingNotified:)  name:NSApplicationWillFinishLaunchingNotification object:nil];
    }
//iTM2_END;
    return;
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
	if(!target->super_class)
		return NO;
	else if(!strncmp(target->name,"NSKVO",5))
		return NO;
	else if(!strcmp(target->super_class->name, className))
		return YES;
	else
		return [self isClass:target->super_class subclassOfClassNamed:className];
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
+ (NSArray *)realInstanceSelectorsOfClass:(Class)theClass withSuffix:(NSString *)suffix signature:(NSMethodSignature *)signature inherited:(BOOL)yorn;
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
	NSMethodSignature * MS = nil;
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
							if([name hasSuffix:suffix])
							{
								MS = [aClass iTM2_instanceMethodSignatureForSelector:selector];
								if([signature isEqual:MS])
								{
									if([name hasPrefix:@"prepare"])
										[prepareSELs addObject:name];
									else
										[SELs addObject:name];
								}
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
						if(ISSELECTOR(selector) && selector != @selector(heartBeat:))
						{
							MS = [aClass iTM2_instanceMethodSignatureForSelector:selector];
							if([signature isEqual:MS])
							{
								name = NSStringFromSelector(selector);
								if([name hasPrefix:@"prepare"])
									[prepareSELs addObject:name];
								else
									[SELs addObject:name];
							}
						}
						else
						{
							iTM2_LOG(@"Unmapped selector or heartBeat:...");
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
		iTM2_LOG(@"Introspection:\nclass: %@\nselector suffix:%@\nsignature:%@\ninherited:%@", NSStringFromClass(theClass), suffix, signature, (yorn?@"Y":@"N"));
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
								&& [signature isEqual:[aClass->isa iTM2_instanceMethodSignatureForSelector:selector]])
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
						if([signature isEqual:[aClass->isa iTM2_instanceMethodSignatureForSelector:selector]])
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


#import "JRSwizzle.h"
#import <objc/objc-class.h>

#define SetNSError(ERROR_VAR, FORMAT,...)       \
		if (ERROR_VAR) {        \
				NSString *errStr = [@"+[NSObject(JRSwizzle) jr_swizzleMethod:withMethod:error:]: " stringByAppendingFormat:FORMAT,##__VA_ARGS__];       \
				*ERROR_VAR = [NSError errorWithDomain:@"NSCocoaErrorDomain" \
																				 code:-1        \
																		 userInfo:[NSDictionary dictionaryWithObject:errStr forKey:NSLocalizedDescriptionKey]]; \
		}

@implementation NSObject (JRSwizzle)

+ (BOOL)jr_swizzleMethod:(SEL)origSel_ withMethod:(SEL)altSel_ error:(NSError**)error_ {
#if OBJC_API_VERSION >= 2
		Method origMethod = class_getInstanceMethod(self, origSel_);
		if (!origMethod) {
				SetNSError(error_, @"original method %@ not found for class %@", NSStringFromSelector(origSel_), [self className]);
				return NO;
		}
	   
		Method altMethod = class_getInstanceMethod(self, altSel_);
		if (!altMethod) {
				SetNSError(error_, @"alternate method %@ not found for class %@", NSStringFromSelector(altSel_), [self className]);
				return NO;
		}
	   
		class_addMethod(self,
										origSel_,
										class_getMethodImplementation(self, origSel_),
										method_getTypeEncoding(origMethod));
		class_addMethod(self,
										altSel_,
										class_getMethodImplementation(self, altSel_),
										method_getTypeEncoding(altMethod));
	   
		method_exchangeImplementations(class_getInstanceMethod(self, origSel_), class_getInstanceMethod(self, altSel_));
		return YES;
#else
		//      Scan for non-inherited methods.
		Method directOriginalMethod = NULL, directAlternateMethod = NULL;
	   
		void *iterator = NULL;
		struct objc_method_list *mlist = class_nextMethodList(self, &iterator);
		while (mlist) {
				int method_index = 0;
				for (; method_index < mlist->method_count; method_index++) {
						if (mlist->method_list[method_index].method_name == origSel_) {
								assert(!directOriginalMethod);
								directOriginalMethod = &mlist->method_list[method_index];
						}
						if (mlist->method_list[method_index].method_name == altSel_) {
								assert(!directAlternateMethod);
								directAlternateMethod = &mlist->method_list[method_index];
						}
				}
				mlist = class_nextMethodList(self, &iterator);
		}
	   
		//      If either method is inherited, copy it up to the target class to make it non-inherited.
		if (!directOriginalMethod || !directAlternateMethod) {
				Method inheritedOriginalMethod = NULL, inheritedAlternateMethod = NULL;
				if (!directOriginalMethod) {
						inheritedOriginalMethod = class_getInstanceMethod(self, origSel_);
						if (!inheritedOriginalMethod) {
								SetNSError(error_, @"original method %@ not found for class %@", NSStringFromSelector(origSel_), [self className]);
								return NO;
						}
				}
				if (!directAlternateMethod) {
						inheritedAlternateMethod = class_getInstanceMethod(self, altSel_);
						if (!inheritedAlternateMethod) {
								SetNSError(error_, @"alternate method %@ not found for class %@", NSStringFromSelector(altSel_), [self className]);
								return NO;
						}
				}
			   
				int hoisted_method_count = !directOriginalMethod && !directAlternateMethod ? 2 : 1;
				struct objc_method_list *hoisted_method_list = malloc(sizeof(struct objc_method_list) + (sizeof(struct objc_method)*(hoisted_method_count-1)));
				hoisted_method_list->method_count = hoisted_method_count;
				Method hoisted_method = hoisted_method_list->method_list;
			   
				if (!directOriginalMethod) {
						bcopy(inheritedOriginalMethod, hoisted_method, sizeof(struct objc_method));
						directOriginalMethod = hoisted_method++;
				}
				if (!directAlternateMethod) {
						bcopy(inheritedAlternateMethod, hoisted_method, sizeof(struct objc_method));
						directAlternateMethod = hoisted_method;
				}
				class_addMethods(self, hoisted_method_list);
		}
	   
		//      Swizzle.
		IMP temp = directOriginalMethod->method_imp;
		directOriginalMethod->method_imp = directAlternateMethod->method_imp;
		directAlternateMethod->method_imp = temp;
	   
		return YES;
#endif
}

+ (BOOL)jr_swizzleClassMethod:(SEL)origSel_ withClassMethod:(SEL)altSel_ error:(NSError**)error_ {
		assert(0);
		return NO;
}

@end
#endif
