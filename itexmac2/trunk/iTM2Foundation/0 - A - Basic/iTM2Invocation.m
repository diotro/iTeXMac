/*
 //
 //  @version Subversion: $$ 
 //
 //  Created by jlaurens AT users DOT sourceforge DOT net on Fri Sep 16 2009.
 //  Copyright © 2001-2009 Laurens'Tribune. All rights reserved.
 //
 //  This program is free software; you can redistribute it and/or modify it under the terms
 //  of the GNU General Public License as published by the Free Software Foundation; either
 //  version 2 of the License, or any later version.
 //  This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
 //  without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 //  See the GNU General Public License for more details. You should have received a copy
 //  of the GNU General Public License along with this program; if not, write to the Free Software
 //  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
 //  GPL addendum: Any simple modification of the present code which purpose is to remove bug,
 //  improve efficiency in both code execution and code reading or writing should be addressed
 //  to the actual developper team.
 */

#import "iTM2Invocation.h"
#import <objc/runtime.h>

@interface iTM2InvocatorProxy
{
	Class isa;
	NSInvocation ** iVarInvocationRef;
	id iVarTarget;
	BOOL iVarRetainArguments;
	NSUInteger iVarForwardingAddress;
	NSMethodSignature * iVarMethodSignature;
}
+ (void)initialize;
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector;
- (void)forwardInvocation:(NSInvocation *)forwardedInvocation;
@end

@implementation iTM2InvocatorProxy

+ (void)initialize
{
}
+ (id)iTM2_getInvocation:(NSInvocation **) invocationRef withTarget:(id)target retainArguments:(BOOL)retain;
{
	NSParameterAssert(invocationRef!=NULL);
	NSParameterAssert(target!=nil);
	iTM2InvocatorProxy * instance = NSZoneMalloc(nil, sizeof(iTM2InvocatorProxy));
	object_setClass(instance,self);
	instance->iVarInvocationRef = invocationRef;
	instance->iVarTarget = target;
	instance->iVarRetainArguments = retain;
	objc_msgSend((id)instance,@selector(setup_044755320489327443212891840535));// do not remove this line
	return instance;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
	if(aSelector == @selector(setup_044755320489327443212891840535))
	{
		iVarForwardingAddress = (NSUInteger)__builtin_return_address(0);
		return [NSObject methodSignatureForSelector:@selector(finalize)];
	}
	NSUInteger forwardingAddress = (NSUInteger)__builtin_return_address(0);
	if(iVarForwardingAddress != forwardingAddress)
	{
		//
		// Handle the case where methodSignatureForSelector: is the message sent
		// directly to the proxy.
		//
		// There is a chance that we have guessed wrong (i.e. if this is sent
		// from __forward__ but from a different code branch) but that won't
		// cause a fatal problem, just a redundant autoreleased NSInvocation
		// that will get safely autoreleased and ignored.
		//
		// Create an NSInvocation for methodSignatureForSelector: 
		//
		iVarMethodSignature = [iVarTarget methodSignatureForSelector:_cmd];
		*iVarInvocationRef = [NSInvocation invocationWithMethodSignature:iVarMethodSignature];
		[*iVarInvocationRef setTarget:iVarTarget];
		[*iVarInvocationRef setSelector:_cmd];
		[*iVarInvocationRef setArgument:&aSelector atIndex:2];
		if (iVarRetainArguments)
		{
			[*iVarInvocationRef retainArguments];
		}
		
		//
		// Deliberately fall through and still return the target's
		// methodSignatureForSelector: result (in case we guessed wrong).
		//
	}
	if(iVarMethodSignature = [iVarTarget methodSignatureForSelector:aSelector])
	{
		return iVarMethodSignature;
	}
	SEL failSEL = @selector(doesNotRecognizeSelector:);
	Method failMethod = class_getInstanceMethod([NSObject class], failSEL);
	IMP failImp = method_getImplementation(failMethod);
	failImp(self, failSEL, aSelector);
	return nil;
}

//
// forwardInvocation:
//
// This method is invoked by message forwarding.
//
- (void)forwardInvocation:(NSInvocation *)forwardedInvocation
{
	if([forwardedInvocation selector] == @selector(setup_044755320489327443212891840535))
	{
		NSLog(@"forwardInvocation:setup_044755320489327443212891840535");
		NSLog(@"forwardInvocation:%@",forwardedInvocation);
		return;
	}
	if([forwardedInvocation target] == self)
	{
		[forwardedInvocation setTarget:iVarTarget];
		*iVarInvocationRef = forwardedInvocation;
		if (iVarRetainArguments)
		{
			[*iVarInvocationRef retainArguments];
		}
		NSLog(@"- Farewell self");
		NSZoneFree(nil,self);
		return;
	}
	// Handle the case where forwardedInvocation is the message sent directly
	// to the proxy. We create an NSInvocation representing a forwardInvocation:
	// sent to the target instead.
	//
	iVarMethodSignature = [iVarTarget methodSignatureForSelector:_cmd];
	*iVarInvocationRef = [NSInvocation invocationWithMethodSignature:iVarMethodSignature];
	[*iVarInvocationRef setTarget:iVarTarget];
	[*iVarInvocationRef setSelector:_cmd];
	[*iVarInvocationRef setArgument:&forwardedInvocation atIndex:2];
	if (iVarRetainArguments)
	{
		[*iVarInvocationRef retainArguments];
	}
	NSZoneFree(nil,self);
	self = nil;
	NSLog(@"- Farewell self");
	return;
}

@end

@implementation NSInvocation(iTeXMac2)
+ (id)iTM2_getInvocation:(NSInvocation **) invocationRef withTarget:(id)target retainArguments:(BOOL)retain;
{
	NSParameterAssert(invocationRef!=NULL);
	NSParameterAssert(target!=nil);
	return [iTM2InvocatorProxy iTM2_getInvocation: invocationRef withTarget:target retainArguments:retain];
}
- (void)iTM2_invokeWithSelectors:(NSPointerArray *)selectors;
{
	NSUInteger i = [selectors count];
	while(i--) {
		SEL selector = (SEL)[selectors pointerAtIndex:i];
		if([[self target] respondsToSelector:selector])
		{
			[self setSelector:selector];
			[self invoke];
		}
		else
		{
			iTM2_LOG(@"%@ does not respond to %@",[self target], NSStringFromSelector(selector));
		}
	}
    return;
	
}
@end
