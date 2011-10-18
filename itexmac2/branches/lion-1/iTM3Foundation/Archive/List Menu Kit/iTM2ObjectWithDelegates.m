/*
//  iTM2ObjectWithDelegates.m
//  CO Tutorial
//
//  Created by jerome.laurens@u-bourgogne.fr on Mon May 14 2001.
//  Copyright © 2001-2002 Laurens'Tribune. All rights reserved.
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

#import <iTM2Foundation/iTM2ObjectWithDelegates.h>


//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- iTM2ObjectWithDelegates
/*"Description forthcoming."*/
@implementation iTM2ObjectWithDelegates
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- defaultKey
+ (NSString *) defaultKey;
/*"This default key is always valid."*/
{
    return @"(default)";
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- objectWithDelegate:forKey:
+ (id) objectWithDelegate: (id) aDelegate forKey: (NSString *) aKey;
/*"Description forthcoming.
History: jerome.laurens@u-bourgogne.fr
To Do List:
"*/
{
    return [self objectWithDelegates: [NSDictionary dictionaryWithObjectsAndKeys: aDelegate, aKey, nil]];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- objectWithDelegate:
+ (id) objectWithDelegate: (id) aDelegate;
/*"aDelegate is the default delegate."*/
{
    return [self objectWithDelegate: aDelegate forKey: self.defaultKey];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- objectWithDelegates:
+ (id) objectWithDelegates: (NSDictionary *) aDictionary;
/*"Description forthcoming.
History: jerome.laurens@u-bourgogne.fr
To Do List:
"*/
{
    return [[self.alloc initWithDelegates: aDictionary] autorelease];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- mainDelegate
- (id) mainDelegate;
/*"Description forthcoming.
History: jerome.laurens@u-bourgogne.fr
To Do List:
"*/
{
    return [self.delegates objectForKey: self.mainDelegateKey];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- mainDelegateKey
- (NSString *) mainDelegateKey;
/*"Description forthcoming.
History: jerome.laurens@u-bourgogne.fr
To Do List:
"*/
{
    return [[_MainDelegateKey copy] autorelease];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- setMainDelegateKey:
- (void) setMainDelegateKey: (NSString *) aKey;
/*"Description forthcoming.
History: jerome.laurens@u-bourgogne.fr
To Do List:
"*/
{
    if(![_MainDelegateKey isEqualToString: aKey])
    {
        [_MainDelegateKey autorelease];
        _MainDelegateKey = [aKey copy];
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- delegateForKey:
- (id) delegateForKey: (NSString *) aKey;
/*"Description forthcoming.
History: jerome.laurens@u-bourgogne.fr
To Do List:
"*/
{
    return [self.delegates objectForKey: aKey];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- delegateForKey:
- (id) delegate;
/*Send #{-delegateForKey:} with the #{+defaultKey}."*/
{
    return [self delegateForKey: [self.class defaultKey]];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- delegates
- (NSDictionary *) delegates;
/*"Description forthcoming.
History: jerome.laurens@u-bourgogne.fr
To Do List:
"*/
{
    return _Delegates;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- setDelegate:forKey:
- (void) setDelegate: (id) aDelegate forKey: (NSString *) aKey;
/*"Description forthcoming.
History: jerome.laurens@u-bourgogne.fr
To Do List:
"*/
{
    if(aKey && aDelegate)
    {
        NSMutableDictionary * newDelegates = [NSMutableDictionary dictionaryWithCapacity: self.delegates.count+1];
        [newDelegates setDictionary: self.delegates];
        [newDelegates setObject: (id) aDelegate forKey: aKey];
        [self setDelegates: newDelegates];
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- setDelegates:
- (void) setDelegates: (NSDictionary *) aDictionary;
/*"Each delegates must be valid."*/
{
    if(![aDictionary isEqual: _Delegates])
    {
	NSEnumerator *enumerator = aDictionary.keyEnumerator;
	NSString * key;
	while ((key = enumerator.nextObject))
            [self isValidDelegate: [aDictionary objectForKey: key] forKey: key];
        [_Delegates autorelease];
        _Delegates = [aDictionary retain];
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- isValidKey:
- (BOOL) isValidKey: (NSString *) aKey;
/*"If there are required keys, test if aKey lies amongst them. If there are no required keys (either nil or ZER0) the result is YES."*/
{
    return (self.authorizedKeys==nil)||
                (self.authorizedKeys.count==ZER0)||
                    [[self.class defaultKey] isEqualToString: aKey]||
                        ([self.authorizedKeys indexOfObject: aKey]!=NSNotFound);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- authorizedKeys
- (NSArray *) authorizedKeys;
/*"While overriding this method, subclasses will not forget to mention the inherited list of authorized keys. This root implementation simply returns nil. the #{+defaultKey} is always authorized."*/
{
    return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- isValidDelegate:forKey:
- (BOOL) isValidDelegate: (id) aDelegate forKey: (NSString *) aKey;
/*"Returns YES if a Delegate responds to all messages listed in #{-requiredStringSelectors}. Subclasses will adapt #{-requiredStringSelectors} to their needs."*/
{
    if([self isValidKey: aKey])
    {
        NSEnumerator * enumerator = [[self.requiredStringSelectors objectForKey: aKey] objectEnumerator];
        stringSelector;
        for (NSString * stringSelector in [self.requiredStringSelectors objectForKey: aKey])
            NSAssert2([aDelegate respondsToSelector: NSSelectorFromString(stringSelector)],
                            @"Bad Delegate: %@ does not respond to %@.", [aDelegate description], stringSelector);
    }
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- requiredStringSelectors
- (NSDictionary *) requiredStringSelectors;
/*"While overriding this method, subclasses will not forget to mention the inherited list of required string selectors. This root implementation simply returns nil."*/
{
    return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- initWithDelegate:
- (id) initWithDelegate: (id) aDelegate;
/*"Description forthcoming.
History: jerome.laurens@u-bourgogne.fr
To Do List:
"*/
{
    return [self initWithDelegate: aDelegate forKey: [self.class defaultKey]];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- initWithDelegate:forKey:
- (id) initWithDelegate: (id) aDelegate forKey: (NSString *) aKey;
/*"Description forthcoming.
History: jerome.laurens@u-bourgogne.fr
To Do List:
"*/
{
    return [self initWithDelegates: [NSDictionary dictionaryWithObjectsAndKeys: aDelegate, aKey, nil]];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- initWithDelegates:
- (id) initWithDelegates: (NSDictionary *) aDictionary;
/*"Description forthcoming.
History: jerome.laurens@u-bourgogne.fr
To Do List:
"*/
{
    self = self.init;
    [self setDelegates: aDictionary];
    return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- description
- (NSString *) description;
/*"Description forthcoming.
History: jerome.laurens@u-bourgogne.fr
To Do List:
"*/
{
    return [NSString stringWithFormat: @"<%@\nDelegates: %@>",
                            [super description], [self.delegates description]];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- safePerformSelector:
- (id) safePerformSelector: (SEL) aSelector;
/*"Calls #{-erformSelector:} if possible."*/
{
    if ([self respondsToSelector: aSelector])
        return [self performSelector: aSelector];
    return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- safePerformSelector:withObject:
- (id) safePerformSelector: (SEL) aSelector withObject: (id) anObject;
/*"Asks the receiver before performing to avoid exceptions."*/
{
    if ([self respondsToSelector: aSelector])
        return [self performSelector: aSelector withObject: anObject];
    return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- safePerformSelector:withObject:withObject:
- (id) safePerformSelector: (SEL) aSelector withObject: (id) anObject1 withObject: (id) anObject2;
/*"Asks the receiver before performing to avoid exceptions."*/
{
    if ([self respondsToSelector: aSelector])
        return [self performSelector: aSelector withObject: anObject1 withObject: anObject2];
    return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- DELEGATING  =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- methodSignatureForSelector:
- (NSMethodSignature *) methodSignatureForSelector: (SEL) aSelector
/*"Helps in forwarding messages to the delegate. Asks super, the main delegate, the delegate, their classes, the receiver's class... If none of them is able to respond, returns nil."*/
{
    if ([super respondsToSelector: aSelector])
        return [super methodSignatureForSelector: aSelector];
    else if ([self.mainDelegate respondsToSelector: aSelector])
        return [self.mainDelegate methodSignatureForSelector: aSelector];
    else
    {
        NSString * key;
        NSEnumerator * enumerator = [self.delegates keyEnumerator];
        while(key=enumerator.nextObject)
        {
            id object = [self.delegates objectForKey: key];
            if ([object respondsToSelector: aSelector])
                return [object methodSignatureForSelector: aSelector];
        }
        if ([[self.mainDelegate class] respondsToSelector: aSelector])
            return [[self.mainDelegate class] methodSignatureForSelector: aSelector];
        enumerator = [self.delegates keyEnumerator];
        while(key=enumerator.nextObject)
        {
            id object = [[self.delegates objectForKey: key] class];
            if ([object respondsToSelector: aSelector])
                return [object methodSignatureForSelector: aSelector];
        }
        if ([self.class respondsToSelector: aSelector])
            return [self.class methodSignatureForSelector: aSelector];
        else 
            return nil;
    }
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- forwardInvocation:
- (void) forwardInvocation: (NSInvocation *) anInvocation;
/*"The forwarding helpers are super, the main delegate, the delegate, the main delegate's class, the delegate's class object and the receiver's class object. This methods forwards anInvocation to the first object of this list able to respond to it. When all else failed, it sends the inherited message.
This provides 3 ways to adapt the behaviour of the present class."*/
{
    if ([super respondsToSelector: [anInvocation selector]])
        [anInvocation invokeWithTarget: self];
    else if ([self.mainDelegate respondsToSelector: [anInvocation selector]])
        [anInvocation invokeWithTarget: self.mainDelegate];
    else
    {
        NSString * key;
        NSEnumerator * enumerator = [self.delegates keyEnumerator];
        while(key=enumerator.nextObject)
        {
            id object = [self.delegates objectForKey: key];
            if ([object respondsToSelector: [anInvocation selector]])
            {
                [anInvocation invokeWithTarget: object];
                return;
            }
        }
        if ([[self.mainDelegate class] respondsToSelector: [anInvocation selector]])
        {
            [anInvocation invokeWithTarget: [self.mainDelegate class]];
            return;
        }
        enumerator = [self.delegates keyEnumerator];
        while(key=enumerator.nextObject)
        {
            id object = [[self.delegates objectForKey: key] class];
            if ([object respondsToSelector: [anInvocation selector]])
            {
                [anInvocation invokeWithTarget: object];
                return;
            }
        }
        if ([self.class respondsToSelector: [anInvocation selector]])
        {
            [anInvocation invokeWithTarget: self.class];
            return;
        }
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- respondsToSelector:
- (BOOL) respondsToSelector: (SEL) aSelector;
/*"Query to super, the delegates, their classes, the receiver's class in that order."*/
{
    if ([super respondsToSelector: aSelector])
        return YES;
    else
    {
        NSString * key;
        NSEnumerator * enumerator = [self.delegates keyEnumerator];
        while(key=enumerator.nextObject)
            if ([[self.delegates objectForKey: key] respondsToSelector: aSelector])
                return YES;
        enumerator = [self.delegates keyEnumerator];
        while(key=enumerator.nextObject)
            if ([[[self.delegates objectForKey: key] class] respondsToSelector: aSelector])
                return YES;
        return [self.class respondsToSelector: aSelector];
    }
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- isMemberOfClass:
- (BOOL) isMemberOfClass: (Class) aClass;
/*"Query to super, the delegates in that order."*/
{
    if ([super isMemberOfClass: aClass])
        return YES;
    else
    {
        NSString * key;
        NSEnumerator * enumerator = [self.delegates keyEnumerator];
        while(key=enumerator.nextObject)
            if ([[self.delegates objectForKey: key] isMemberOfClass: aClass])
                return YES;
    }
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- isKindOfClass:
- (BOOL) isKindOfClass: (Class) aClass;
/*"Query to super, the delegate in that order."*/
{
    if ([super isKindOfClass: aClass])
        return YES;
    else
    {
        NSString * key;
        NSEnumerator * enumerator = [self.delegates keyEnumerator];
        while(key=enumerator.nextObject)
            if ([[self.delegates objectForKey: key] isKindOfClass: aClass])
                return YES;
    }
    return NO;
}
@end
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=- iTM2ObjectWithDelegates

