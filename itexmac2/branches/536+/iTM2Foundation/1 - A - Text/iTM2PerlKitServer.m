/*
//
//  @version Subversion: $Id$ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Thu Feb 21 2002.
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

#import <iTM2Foundation/iTeXMac2.h>
#import <iTM2Foundation/iTM2BundleKit.h>
#import <iTM2Foundation/iTM2PerlKitServer.h>
#import <iTM2Foundation/iTM2InstallationKit.h>

@implementation iTM2Application(iTM2PerlKitServer)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  testSelector
+ (SEL)testSelector;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 01/15/2006
To Do List:
"*/
{//iTM2_DIAGNOSTIC;
//iTM2_START;
	return @selector(OULA:oula::);
//iTM2_END;
}
@end
@implementation NSApplication(iTM2PerlKitServer)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  activeWindow
- (NSWindow *)activeWindow;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 01/15/2006
To Do List:
"*/
{//iTM2_DIAGNOSTIC;
//iTM2_START;
	id result = [self keyWindow]?:([self mainWindow]?:([[[self orderedWindows] objectEnumerator] nextObject]));
//iTM2_LOG(@"result: %@", result);
	return result;
//iTM2_END;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  testSelector
- (SEL)testSelector;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 01/15/2006
To Do List:
"*/
{//iTM2_DIAGNOSTIC;
//iTM2_START;
	return @selector(PAMPELUNE:::);
//iTM2_END;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  vendedClassForName:
- (Class)vendedClassForName:(NSString *)name;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 01/15/2006
To Do List:
"*/
{//iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_LOG(@"name: %@", name);
	return NSClassFromString(name);
//iTM2_END;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  vendedClassForName:methodSignatureForSelector:
- (NSMethodSignature *)vendedClassForName:(NSString *)name methodSignatureForSelector:(SEL)aSelector;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 01/15/2006
To Do List:
"*/
{//iTM2_DIAGNOSTIC;
//iTM2_START;
	return [[self vendedClassForName:(NSString *) name] methodSignatureForSelector:(SEL) aSelector];
//iTM2_END;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  vendedClassForName:forwardInvocation:
- (void)vendedClassForName:(NSString *)name forwardInvocation:(NSInvocation *)invocation;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 01/15/2006
To Do List:
"*/
{
// THIS IS NOT EVENT BETA
iTM2_LOG(@"target: %@, invocation: %@", name, invocation);
	// this uses NSInvocation
    // Define a Perl context
	Class target = NSClassFromString(name);
	if(!target)
	{
		unsigned MRL = [[invocation methodSignature] methodReturnLength];
		void * returnValue = malloc(MRL);
		NSAssert(returnValue, @"Memory problem, could not malloc... 02133120");
		[invocation setReturnValue:&returnValue];
		free(returnValue);
		return;
	}
	[invocation setTarget:target];
	[invocation invoke];
//iTM2_END;;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  vendedClassForName:performSelector
- (id)vendedClassForName:(NSString *)name performSelector:(SEL)aSelector;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 01/15/2006
To Do List:
"*/
{//iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_LOG(@"Class: %@ should perform selector: %@", name, NSStringFromSelector(aSelector));
	id result = nil;
	Class C = NSClassFromString(name);
	NSMethodSignature * MS = [C methodSignatureForSelector:aSelector];
	if(!MS)
	{
		iTM2_LOG(@"Class: %@ does not implement selector: %@", name, NSStringFromSelector(aSelector));
		return nil;
	}
	NS_DURING
	if([MS numberOfArguments] == 2)
		result = [C performSelector:aSelector];
	NS_HANDLER
	iTM2_LOG(@"Exception catched: %@", [localException reason]);
	NS_ENDHANDLER
//iTM2_END;
	return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  vendedClassForName:performSelector:withObject:
- (id)vendedClassForName:(NSString *)name performSelector:(SEL)aSelector withObject:(id)object1;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 01/15/2006
To Do List:
"*/
{//iTM2_DIAGNOSTIC;
//iTM2_START;
	id result = nil;
	Class C = NSClassFromString(name);
	NSMethodSignature * MS = [C methodSignatureForSelector:aSelector];
	if(!MS)
		return nil;
	NS_DURING
	if([MS numberOfArguments] == 2)
		result = [C performSelector:aSelector];
	else if([MS numberOfArguments] == 3)
	{
		const char * argumentType = [MS getArgumentTypeAtIndex:2];
		// either an object or a pointer to a struct: very weak
		if(!strcmp("@", argumentType)
			|| ((strlen(argumentType)>2) && (argumentType[0]=='^') && (argumentType[1]=='{')))
		{
			result = [C performSelector:aSelector withObject:object1];
		}
	}
	NS_HANDLER
	iTM2_LOG(@"Exception catched: %@", [localException reason]);
	NS_ENDHANDLER
//iTM2_END;
	return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  vendedClassForName:performSelector:withObject:withObject:
- (id)vendedClassForName:(NSString *)name performSelector:(SEL)aSelector withObject:(id)object1 withObject:(id)object2;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 01/15/2006
To Do List:
"*/
{//iTM2_DIAGNOSTIC;
//iTM2_START;
	id result = nil;
	Class C = NSClassFromString(name);
	NSMethodSignature * MS = [C methodSignatureForSelector:aSelector];
	if(!MS)
		return nil;
	NS_DURING
	if([MS numberOfArguments] == 2)
		result = [C performSelector:aSelector];
	else if([MS numberOfArguments] == 3)
	{
		const char * argumentType = [MS getArgumentTypeAtIndex:2];
		// either an object or a pointer to a struct: very weak
		if(!strcmp("@", argumentType)
			|| ((strlen(argumentType)>2) && (argumentType[0]=='^') && (argumentType[1]=='{')))
		{
			result = [C performSelector:aSelector withObject:object1];
		}
	}
	else if([MS numberOfArguments] == 4)
	{
		const char * argumentType = [MS getArgumentTypeAtIndex:2];
		// either an object or a pointer to a struct: very weak
		if(!strcmp("@", argumentType)
			|| ((strlen(argumentType)>2) && (argumentType[0]=='^') && (argumentType[1]=='{')))
		{
			const char * argumentType = [MS getArgumentTypeAtIndex:3];
			// either an object or a pointer to a struct: very weak
			if(!strcmp("@", argumentType)
				|| ((strlen(argumentType)>2) && (argumentType[0]=='^') && (argumentType[1]=='{')))
			{
				result = [C performSelector:aSelector withObject:object1 withObject:object2];
			}
		}
	}
	NS_HANDLER
	iTM2_LOG(@"Exception catched: %@", [localException reason]);
	NS_ENDHANDLER
//iTM2_END;
	return result;
}
@end

@interface iTM2SimpleProxy: NSObject
{
	id _target;
}
+ (id)proxyForClass:(Class)aClass;
- (id)initWithTarget:(id)target;
@end

@implementation iTM2SimpleProxy
+ (id)proxyForClass:(Class)aClass;
{
	static NSMutableDictionary * D = nil;
	if(!D)
		D = [[NSMutableDictionary dictionary] retain];
	id key = [NSValue valueWithPointer:aClass];
	id result = [D objectForKey:key];
	if(result)
		return result;
	result = [[[iTM2SimpleProxy alloc] initWithTarget:aClass] autorelease];
	if(result)
		[D setObject:result forKey:key];
	return result;
}
- (id)initWithTarget:(id)target;
{
	if(self = [super init])
	{
		[_target autorelease];
		_target = [target retain];
	}
	return self;
}
- (void)dealloc;
{
	[_target autorelease];
	_target = nil;
	[super dealloc];
	return;
}
- (BOOL)respondsToSelector:(SEL)aSelector
{
//iTM2_LOG(@"aSelector: %@", NSStringFromSelector(aSelector));
    return [_target respondsToSelector:aSelector];
}
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
//iTM2_LOG(@"aSelector: %@", NSStringFromSelector(aSelector));
    return [_target methodSignatureForSelector:aSelector];
}
- (void)forwardInvocation:(NSInvocation *)anInvocation
{
//iTM2_LOG(@"anInvocation: %@", anInvocation);
    [anInvocation setTarget:_target];
    [anInvocation invoke];
    return;
}
@end

@implementation NSObject(iTM2PerlKitServer)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  classFromString
- (id)classFromString:(NSString *)aString;
/*"Usefull for DO connection through perl. We cannot use class from string...
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 01/15/2006
To Do List:
"*/
{//iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_LOG(@"class name is: %@, result is: %@", aString, NSClassFromString(aString));
	return NSClassFromString(aString);//[iTM2SimpleProxy proxyForClass:NSClassFromString(aString)];
//iTM2_END;
}
@end

#if 0
@interface _iTM2PerlKitServer: NSObject
@end
@implementation _iTM2PerlKitServer
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  load
+ (void)load;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 01/15/2006
To Do List:
"*/
{//iTM2_DIAGNOSTIC;
	iTM2_INIT_POOL;
	iTM2RedirectNSLogOutput();
//iTM2_START;
	[self poseAsClass:[NSObject class]];
	iTM2_LOG(@"poseAsClass");
//iTM2_END;
	iTM2_RELEASE_POOL;
}
@end
#endif
