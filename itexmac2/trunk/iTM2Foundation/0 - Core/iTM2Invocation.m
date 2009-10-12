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
+ (void)_044755320489327443212891840535;
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
	iTM2InvocatorProxy * instance = NSAllocateObject(self, 0, nil);
	instance->iVarInvocationRef = invocationRef;
	instance->iVarTarget = target;
	instance->iVarRetainArguments = retain;
	[(id)instance _044755320489327443212891840535];// do not remove this line
	return instance;
}

+ (void)_044755320489327443212891840535;
{// fake method, just to retrieve the signature...
	return;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
	if(aSelector == @selector(_044755320489327443212891840535))
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
		[forwardedInvocation setReturnValue:NULL];
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
