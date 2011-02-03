/*
//
//  @version Subversion: $Id: iTM2PerlKitServer.m 795 2009-10-11 15:29:16Z jlaurens $ 
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

#import "iTeXMac2.h"
#import "iTM2BundleKit.h"
#import "iTM2PerlKitServer.h"
#import "iTM2InstallationKit.h"

@implementation NSApplication(iTM2PerlKitServer)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  activeWindow
- (NSWindow *)activeWindow;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 01/15/2006
To Do List:
"*/
{//DIAGNOSTIC4iTM3;
//START4iTM3;
	id result = self.keyWindow?:(self.mainWindow?:([[self.orderedWindows objectEnumerator] nextObject]));
//LOG4iTM3(@"result: %@", result);
	return result;
//END4iTM3;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  vendedClassForName:
- (Class)vendedClassForName:(NSString *)name;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 01/15/2006
To Do List:
"*/
{//DIAGNOSTIC4iTM3;
//START4iTM3;
//LOG4iTM3(@"name: %@", name);
	return NSClassFromString(name);
//END4iTM3;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  vendedClassForName:methodSignatureForSelector:
- (NSMethodSignature *)vendedClassForName:(NSString *)name methodSignatureForSelector:(SEL)aSelector;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 01/15/2006
To Do List:
"*/
{//DIAGNOSTIC4iTM3;
//START4iTM3;
	return [[self vendedClassForName:(NSString *) name] methodSignatureForSelector:(SEL) aSelector];
//END4iTM3;
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
//LOG4iTM3(@"target: %@, invocation: %@", name, invocation);
	// this uses NSInvocation
    // Define a Perl context
	Class target = NSClassFromString(name);
	if (!target)
	{
		NSUInteger MRL = [[invocation methodSignature] methodReturnLength];
		void * returnValue = NSAllocateCollectable(MRL,ZER0);
		NSAssert(returnValue, @"Memory problem, could not malloc... 02133120");
		[invocation setReturnValue:&returnValue];
		return;
	}
	invocation.target = target;
	[invocation invoke];
//END4iTM3;;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  vendedClassForName:performSelector
- (id)vendedClassForName:(NSString *)name performSelector:(SEL)aSelector;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 01/15/2006
To Do List:
"*/
{//DIAGNOSTIC4iTM3;
//START4iTM3;
//LOG4iTM3(@"Class: %@ should perform selector: %@", name, NSStringFromSelector(aSelector));
	id result = nil;
	Class C = NSClassFromString(name);
	NSMethodSignature * MS = [C methodSignatureForSelector:aSelector];
	if (!MS)
	{
		LOG4iTM3(@"Class: %@ does not implement selector: %@", name, NSStringFromSelector(aSelector));
		return nil;
	}
	NS_DURING
	if ([MS numberOfArguments] == 2)
		result = [C performSelector:aSelector];
	NS_HANDLER
	LOG4iTM3(@"Exception catched: %@", [localException reason]);
	NS_ENDHANDLER
//END4iTM3;
	return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  vendedClassForName:performSelector:withObject:
- (id)vendedClassForName:(NSString *)name performSelector:(SEL)aSelector withObject:(id)object1;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 01/15/2006
To Do List:
"*/
{//DIAGNOSTIC4iTM3;
//START4iTM3;
	id result = nil;
	Class C = NSClassFromString(name);
	NSMethodSignature * MS = [C methodSignatureForSelector:aSelector];
	if (!MS)
		return nil;
	NS_DURING
	if ([MS numberOfArguments] == 2)
		result = [C performSelector:aSelector];
	else if ([MS numberOfArguments] == 3)
	{
		const char * argumentType = [MS getArgumentTypeAtIndex:2];
		// either an object or a pointer to a struct: very weak
		if (!strcmp("@", argumentType)
			|| ((strlen(argumentType)>2) && (argumentType[ZER0]=='^') && (argumentType[1]=='{')))
		{
			result = [C performSelector:aSelector withObject:object1];
		}
	}
	NS_HANDLER
	LOG4iTM3(@"Exception catched: %@", [localException reason]);
	NS_ENDHANDLER
//END4iTM3;
	return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  vendedClassForName:performSelector:withObject:withObject:
- (id)vendedClassForName:(NSString *)name performSelector:(SEL)aSelector withObject:(id)object1 withObject:(id)object2;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 01/15/2006
To Do List:
"*/
{//DIAGNOSTIC4iTM3;
//START4iTM3;
	id result = nil;
	Class C = NSClassFromString(name);
	NSMethodSignature * MS = [C methodSignatureForSelector:aSelector];
	if (!MS)
		return nil;
	NS_DURING
	if ([MS numberOfArguments] == 2)
		result = [C performSelector:aSelector];
	else if ([MS numberOfArguments] == 3)
	{
		const char * argumentType = [MS getArgumentTypeAtIndex:2];
		// either an object or a pointer to a struct: very weak
		if (!strcmp("@", argumentType)
			|| ((strlen(argumentType)>2) && (argumentType[ZER0]=='^') && (argumentType[1]=='{')))
		{
			result = [C performSelector:aSelector withObject:object1];
		}
	}
	else if ([MS numberOfArguments] == 4)
	{
		const char * argumentType = [MS getArgumentTypeAtIndex:2];
		// either an object or a pointer to a struct: very weak
		if (!strcmp("@", argumentType)
			|| ((strlen(argumentType)>2) && (argumentType[ZER0]=='^') && (argumentType[1]=='{')))
		{
			const char * argumentType = [MS getArgumentTypeAtIndex:3];
			// either an object or a pointer to a struct: very weak
			if (!strcmp("@", argumentType)
				|| ((strlen(argumentType)>2) && (argumentType[ZER0]=='^') && (argumentType[1]=='{')))
			{
				result = [C performSelector:aSelector withObject:object1 withObject:object2];
			}
		}
	}
	NS_HANDLER
	LOG4iTM3(@"Exception catched: %@", [localException reason]);
	NS_ENDHANDLER
//END4iTM3;
	return result;
}
@end

@interface iTM2SimpleProxy: NSObject
{
	id _target;
}
+ (id)proxyForClass:(Class)aClass;
- (id)initWithTarget:(id)target;
@property (retain) id _target;
@end

@implementation iTM2SimpleProxy
+ (id)proxyForClass:(Class)aClass;
{
	static NSMutableDictionary * D = nil;
	if (!D)
		D = [[NSMutableDictionary dictionary] retain];
	id key = [NSValue valueWithPointer:aClass];
	id result = [D objectForKey:key];
	if (result)
		return result;
	result = [[[iTM2SimpleProxy alloc] initWithTarget:aClass] autorelease];
	if (result)
		[D setObject:result forKey:key];
	return result;
}
- (id)initWithTarget:(id)target;
{
	if ((self = [super init]))
	{
		[_target autorelease];
		_target = [target retain];
	}
	return self;
}
- (BOOL)respondsToSelector:(SEL)aSelector
{
//LOG4iTM3(@"aSelector: %@", NSStringFromSelector(aSelector));
    return [_target respondsToSelector:aSelector];
}
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
//LOG4iTM3(@"aSelector: %@", NSStringFromSelector(aSelector));
    return [_target methodSignatureForSelector:aSelector];
}
- (void)forwardInvocation:(NSInvocation *)anInvocation
{
//LOG4iTM3(@"anInvocation: %@", anInvocation);
    anInvocation.target = _target;
    [anInvocation invoke];
    return;
}
@synthesize _target;
@end

@implementation NSObject(iTM2PerlKitServer)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  classFromString
- (id)classFromString:(NSString *)aString;
/*"Usefull for DO connection through perl. We cannot use class from string...
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 01/15/2006
To Do List:
"*/
{//DIAGNOSTIC4iTM3;
//START4iTM3;
//LOG4iTM3(@"class name is: %@, result is: %@", aString, NSClassFromString(aString));
	return NSClassFromString(aString);//[iTM2SimpleProxy proxyForClass:NSClassFromString(aString)];
//END4iTM3;
}
@end

