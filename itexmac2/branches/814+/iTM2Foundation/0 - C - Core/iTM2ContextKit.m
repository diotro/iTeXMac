/*
//
//  @version Subversion: $Id: iTM2ContextKit.m 795 2009-10-11 15:29:16Z jlaurens $ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Tue Mar 26 2002.
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
//  Version history: (format "- date:contribution (contributor) ") 
//  To Do List: (format "- proposition (percentage actually done) ") 
*/


#import "iTM2PathUtilities.h"
#import "iTM2DocumentControllerKit.h"
#import "iTM2Runtime.h"
#import "iTM2StringKit.h"
#import "iTM2InstallationKit.h"
#import "iTM2Implementation.h"
#import "iTM2BundleKit.h"
#import "iTM2Invocation.h"
#import "iTM2UserDefaultsKit.h"
#import "iTM2ContextKit.h"

NSString * const iTM2ContextDidChangeNotification = @"iTM2ContextDidChange";

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2ContextKit
/*"This object is used to store context4iTM3Manager that might override some context4iTM3Manager in a basic set of context4iTM3Manager, typically the user defaults data base. It implements all the setters and getters of the NSUserDefaults instances. Beware when categories are created. All the setters really fill the context4iTM3Manager, even if afterwards the values are the same in the context4iTM3Manager and the base context4iTM3Manager. This might be implemented in a different way driven by a flag. It is consistent now because the base context4iTM3Manager are the user defaults data base: if those defaults are changed, the local context4iTM3Manager are not.

When no basic context4iTM3Manager are given on initialization time, the user defaults data base is used instead. The NSUserDefaults shared instance is cached.

Various categories are declared here, the NSDocument instances are the only object where context4iTM3Manager are really stored, if ever."*/
@implementation NSObject(iTM2ContextKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  currentContext4iTM3Manager
- (id)currentContext4iTM3Manager;
/*"Subclasses will most certainly override this method.
Default implementation returns the NSUserDefaults shared instance.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return SUD;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  context4iTM3Manager
- (id)context4iTM3Manager;
/*"Subclasses will most certainly override this method.
Default implementation returns the NSUserDefaults shared instance.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return self.currentContext4iTM3Manager;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setContext4iTM3Manager:
- (void)setContext4iTM3Manager:(id)manager;
/*"Subclasses will most certainly override this method.
Default implementation returns the NSUserDefaults shared instance.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSAssert(NO, @"The default implementation does not set any context manager...");
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  updateContext4iTM3Manager
- (void)updateContext4iTM3Manager;
/*"Subclasses will most certainly override this method.
Default implementation does nothing. It is never overriden so it is not used. maybe we can safey remove this.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  context4iTM3Dictionary
- (id)context4iTM3Dictionary;
/*"Subclasses will most certainly override this method.
Default implementation returns the NSUserDefaults shared instance.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setContext4iTM3Dictionary:
- (void)setContext4iTM3Dictionary:(id)dictionary;
/*"Subclasses will most certainly override this method.
Default implementation returns the NSUserDefaults shared instance.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSAssert(NO, @"The default implementation does not set any context dictionary...");
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  context4iTM3ValueForKey:domain:
- (id)context4iTM3ValueForKey:(NSString *)aKey domain:(NSUInteger)mask;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return [self getContext4iTM3ValueForKey:aKey domain:mask];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  getContext4iTM3ValueForKey:domain:
- (id)getContext4iTM3ValueForKey:(NSString *)aKey domain:(NSUInteger)mask;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	id result = nil;
	if (mask & iTM2ContextStandardLocalMask)
	{
		NSDictionary * D = self.context4iTM3Dictionary;
		if (result = [D valueForKey:aKey])
		{
			return result;
		}
		id context4iTM3Manager = self.context4iTM3Manager;
		if ((self != context4iTM3Manager && SUD != context4iTM3Manager) && (result = [context4iTM3Manager context4iTM3ValueForKey:aKey domain:mask]))
		{
			return result;
		}
	}
	if (mask & iTM2ContextDefaultsMask)
	{
		result = [SUD context4iTM3ValueForKey:aKey domain:mask];
	}
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeContext4iTM3Value:forKey:domain:
- (NSUInteger)takeContext4iTM3Value:(id)object forKey:(NSString *)aKey domain:(NSUInteger)mask;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//LOG4iTM3(@"self.context4iTM3Dictionary is:%@", self.context4iTM3Dictionary);
	NSUInteger didChange = [self setContext4iTM3Value:object forKey:aKey domain:mask];
	if (didChange) {
		id afterObject = [self context4iTM3ValueForKey:aKey domain:mask];
//LOG4iTM3(@"afterObject:%@",afterObject);
		if ([object isEqual:afterObject] || (object == afterObject)) {
			return YES;
		}
		if ((didChange &= ~iTM2ContextNoContextMask) && (iTM2DebugEnabled>100)) {
			LOG4iTM3(@"object:%@ <> afterObject %@", object,afterObject);
		}
	}
    return didChange;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setContext4iTM3Value:forKey:domain:
- (NSUInteger)setContext4iTM3Value:(id)object forKey:(NSString *)aKey domain:(NSUInteger)mask;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSAssert(aKey != nil, @"Unexpected nil aKey");
	NSUInteger didChange = iTM2ContextNoContextMask;
	if (mask & iTM2ContextStandardLocalMask) {
		NSDictionary * D = self.context4iTM3Dictionary;
		id context4iTM3Manager = self.context4iTM3Manager;
		if (D) {
			didChange = ZER0;
			id old = [D valueForKey:aKey];
			if (![old isEqual:object]) {
				[[old retain] autorelease];
				[D setValue:object forKey:aKey];
				didChange |= iTM2ContextStandardLocalMask;
			}
		}
		if (context4iTM3Manager && self != context4iTM3Manager && SUD != context4iTM3Manager) {
			didChange &= ~iTM2ContextNoContextMask;
			didChange |= [context4iTM3Manager takeContext4iTM3Value:object forKey:aKey domain:mask];
		}
	}
	if (mask & iTM2ContextDefaultsMask) {
		didChange &= ~iTM2ContextNoContextMask;
		didChange |= [SUD takeContext4iTM3Value:object forKey:aKey domain:mask];
	}
//LOG4iTM3(@"self.context4iTM3Dictionary is:%@", self.context4iTM3Dictionary);
    return (didChange &= ~iTM2ContextNoContextMask) && self.notifyContext4iTM3Change;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= context4iTM3FontForKey:domain:
- (NSFont *)context4iTM3FontForKey:(NSString *)aKey domain:(NSUInteger)mask;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSDictionary * D = [self context4iTM3ValueForKey:aKey domain:mask];
//END4iTM3;
    return [NSFont fontWithNameSizeDictionary:D];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= takeContext4iTM3Font:forKey:domain:
- (void)takeContext4iTM3Font:(NSFont *)aFont forKey:(NSString *)aKey domain:(NSUInteger)mask;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSDictionary * D = [aFont nameSizeDictionary];
    [self takeContext4iTM3Value:D forKey:aKey domain:mask];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= context4iTM3ColorForKey:domain:
- (NSColor *)context4iTM3ColorForKey:(NSString *)aKey domain:(NSUInteger)mask;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSDictionary * D = [self context4iTM3ValueForKey:aKey domain:mask];
//END4iTM3;
    return [NSColor colorWithRGBADictionary:D];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= takeContext4iTM3Color:forKey:domain:
- (void)takeContext4iTM3Color:(NSColor *)aColor forKey:(NSString *)aKey domain:(NSUInteger)mask;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSDictionary * D = [aColor RGBADictionary];
    [self takeContext4iTM3Value:D forKey:aKey domain:mask];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  context4iTM3StringForKey:domain:
- (NSString *)context4iTM3StringForKey:(NSString *)aKey domain:(NSUInteger)mask;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	id result = nil;
	if (mask & iTM2ContextStandardLocalMask) {
		NSDictionary * D = self.context4iTM3Dictionary;
		if ((result = [D valueForKey:aKey])) {
			if ([result isKindOfClass:[NSString class]]) {
				return result;
			}
			if ([result respondsToSelector:@selector(stringValue)]) {
				return [result stringValue];
			}
		}
		id context4iTM3Manager = self.context4iTM3Manager;
		if ((context4iTM3Manager != self) && (context4iTM3Manager != SUD)
                && (result = [context4iTM3Manager context4iTM3StringForKey:aKey domain:mask])) {
			return result;
		}
	}
	result = [SUD context4iTM3StringForKey:aKey domain:mask];
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  context4iTM3ArrayForKey:domain:
- (NSArray *)context4iTM3ArrayForKey:(NSString *)aKey domain:(NSUInteger)mask;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	id result = nil;
	if (mask & iTM2ContextStandardLocalMask) {
		if (result = [self.context4iTM3Dictionary valueForKey:aKey]) {
			if ([result isKindOfClass:[NSArray class]]) {
				return result;
			}
		}
		id context4iTM3Manager = self.context4iTM3Manager;
		if ((context4iTM3Manager != self) && (context4iTM3Manager != SUD)
                && (result = [context4iTM3Manager context4iTM3ArrayForKey:aKey domain:mask])) {
			return result;
		}
	}
	result = [SUD context4iTM3ArrayForKey:aKey domain:mask];
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  context4iTM3DictionaryForKey:domain:
- (NSDictionary *)context4iTM3DictionaryForKey:(NSString *)aKey domain:(NSUInteger)mask;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	id result = nil;
	if (mask & iTM2ContextStandardLocalMask) {
		if ((result = [self.context4iTM3Dictionary valueForKey:aKey])) {
			if ([result isKindOfClass:[NSDictionary class]]) {
				return result;
			}
		}
		id context4iTM3Manager = self.context4iTM3Manager;
		if ((context4iTM3Manager != self) && (context4iTM3Manager != SUD)
                && (result = [context4iTM3Manager context4iTM3DictionaryForKey:aKey domain:mask])) {
			return result;
		}
	}
	result = [SUD context4iTM3DictionaryForKey:aKey domain:mask];
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  context4iTM3DataForKey:domain:
- (NSData *)context4iTM3DataForKey:(NSString *)aKey domain:(NSUInteger)mask;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	id result = nil;
	if (mask & iTM2ContextStandardLocalMask) {
		if ((result = [self.context4iTM3Dictionary valueForKey:aKey])) {
			if ([result isKindOfClass:[NSData class]]) {
				return result;
			}
		}
		id context4iTM3Manager = self.context4iTM3Manager;
		if ((context4iTM3Manager != self) && (context4iTM3Manager != SUD)
                && (result = [context4iTM3Manager context4iTM3DataForKey:aKey domain:mask])) {
			return result;
		}
	}
	result = [SUD context4iTM3DataForKey:aKey domain:mask];
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  context4iTM3StringArrayForKey:domain:
- (NSArray *)context4iTM3StringArrayForKey:(NSString *)aKey domain:(NSUInteger)mask;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSArray * result = nil;
	if (mask & iTM2ContextStandardLocalMask) {
		if (result = [self.context4iTM3Dictionary valueForKey:aKey]) {
			if ([result isKindOfClass:[NSArray class]]) {
				if (result.count) {
					for (NSString * S in result) {
						if (![S isKindOfClass:[NSString class]]) {
                            //  This is not an array of strings
							goto next;
						}
					}
				}
				return result;
			}
		}
next:;
		id context4iTM3Manager = self.context4iTM3Manager;
		if ((context4iTM3Manager != self) && (context4iTM3Manager != SUD)
                && (result = [context4iTM3Manager context4iTM3StringArrayForKey:aKey domain:mask])) {
			return result;
		}
	}
	result = [SUD context4iTM3StringArrayForKey:aKey domain:mask];
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  context4iTM3FloatForKey:domain:
- (CGFloat)context4iTM3FloatForKey:(NSString *)aKey domain:(NSUInteger)mask; 
/*"Description forthcoming.
 Version history: jlaurens AT users DOT sourceforge DOT net
 - 1.1.a6: 03/26/2002
 To Do List:
 "*/
{DIAGNOSTIC4iTM3;
	//START4iTM3;
	NSNumber * value = nil;
	if (mask & iTM2ContextStandardLocalMask) {
		if ((value = [self.context4iTM3Dictionary valueForKey:aKey])) {
			if ([value respondsToSelector:@selector(floatValue)]) {
				return value.floatValue;
			}
		}
		id context4iTM3Manager = self.context4iTM3Manager;
		if ((context4iTM3Manager != self) && (context4iTM3Manager != SUD)
		   && ((value = [context4iTM3Manager context4iTM3ValueForKey:aKey domain:mask]))
                && [value respondsToSelector:@selector(floatValue)]) {
			return value.floatValue;
		}
	}
	CGFloat result = [SUD context4iTM3FloatForKey:aKey domain:mask];
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  context4iTM3IntegerForKey:domain:
- (NSInteger)context4iTM3IntegerForKey:(NSString *)aKey domain:(NSUInteger)mask; 
/*"Description forthcoming.
 Version history: jlaurens AT users DOT sourceforge DOT net
 - 1.1.a6: 03/26/2002
 To Do List:
 "*/
{DIAGNOSTIC4iTM3;
	//START4iTM3;
	id value = nil;
	if (mask & iTM2ContextStandardLocalMask) {
		if ((value = [self.context4iTM3Dictionary valueForKey:aKey])) {
			if (([value respondsToSelector:@selector(integerValue)])) {
				return [value integerValue];
			}
		}
		id context4iTM3Manager = self.context4iTM3Manager;
		if ((context4iTM3Manager != self) && (context4iTM3Manager != SUD)
            && (value = [context4iTM3Manager context4iTM3ValueForKey:aKey domain:mask])
                &&([value respondsToSelector:@selector(integerValue)])) {
			return [value integerValue];
		}
	}
	NSInteger result = [SUD context4iTM3IntegerForKey:aKey domain:mask];
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  context4iTM3IntegerForKey:domain:
- (NSUInteger)context4iTM3UnsignedIntegerForKey:(NSString *)aKey domain:(NSUInteger)mask; 
/*"Description forthcoming.
 Version history: jlaurens AT users DOT sourceforge DOT net
 - 1.1.a6: 03/26/2002
 To Do List:
 "*/
{DIAGNOSTIC4iTM3;
	//START4iTM3;
	id value = nil;
	if (mask & iTM2ContextStandardLocalMask) {
		if ((value = [self.context4iTM3Dictionary valueForKey:aKey])) {
			if ([value respondsToSelector:@selector(unsignedIntegerValue)]) {
				return [value unsignedIntegerValue];
			}
		}
		id context4iTM3Manager = self.context4iTM3Manager;
		if ((context4iTM3Manager != self) && (context4iTM3Manager != SUD)
            && (value = [context4iTM3Manager context4iTM3ValueForKey:aKey domain:mask])
                &&([value respondsToSelector:@selector(unsignedIntegerValue)])) {
			return [value unsignedIntegerValue];
		}
	}
	NSUInteger result = [SUD context4iTM3UnsignedIntegerForKey:aKey domain:mask];
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  context4iTM3BoolForKey:domain:
- (BOOL)context4iTM3BoolForKey:(NSString *)aKey domain:(NSUInteger)mask;  
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	id value = nil;
	if (mask & iTM2ContextStandardLocalMask) {
		NSDictionary * D = self.context4iTM3Dictionary;
		if ((value = [D valueForKey:aKey])
			&& [value respondsToSelector:@selector(boolValue)]) {
			return [value boolValue];
		}
		id context4iTM3Manager = self.context4iTM3Manager;
		if ((context4iTM3Manager != self) && (context4iTM3Manager != SUD)
			&& ((value = [context4iTM3Manager context4iTM3ValueForKey:aKey domain:mask]))
				&& [value respondsToSelector:@selector(boolValue)]) {
			return [value boolValue];
		}
	}
	BOOL result = [SUD context4iTM3BoolForKey:aKey domain:mask];
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeContext4iTM3Integer:forKey:domain:
- (void)takeContext4iTM3Integer:(NSInteger)value forKey:(NSString *)aKey domain:(NSUInteger)mask;
/*"Description forthcoming.
 Version history: jlaurens AT users DOT sourceforge DOT net
 - 1.1.a6: 03/26/2002
 To Do List:
 "*/
{DIAGNOSTIC4iTM3;
	//START4iTM3;
    [self takeContext4iTM3Value:[NSNumber numberWithInteger:value] forKey:aKey domain:mask];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeContext4iTM3UnsignedInteger:forKey:domain:
- (void)takeContext4iTM3UnsignedInteger:(NSUInteger)value forKey:(NSString *)aKey domain:(NSUInteger)mask;
/*"Description forthcoming.
 Version history: jlaurens AT users DOT sourceforge DOT net
 - 1.1.a6: 03/26/2002
 To Do List:
 "*/
{DIAGNOSTIC4iTM3;
	//START4iTM3;
    [self takeContext4iTM3Value:[NSNumber numberWithUnsignedInteger:value] forKey:aKey domain:mask];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeContext4iTM3Float:forKey:domain:
- (void)takeContext4iTM3Float:(CGFloat)value forKey:(NSString *)aKey domain:(NSUInteger)mask;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self takeContext4iTM3Value:[NSNumber numberWithFloat:value] forKey:aKey domain:mask];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeContext4iTM3Bool:forKey:domain:
- (void)takeContext4iTM3Bool:(BOOL)value forKey:(NSString *)aKey domain:(NSUInteger)mask;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self takeContext4iTM3Value:[NSNumber numberWithBool:value] forKey:aKey domain:mask];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  saveContext4iTM3Error:
- (BOOL)saveContext4iTM3Error:(NSError **)outErrorPtr;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    BOOL result = YES;
	NSInvocation * I;
	[[NSInvocation getInvocation4iTM3:&I withTarget:self retainArguments:NO] saveContext4iTM3Error:outErrorPtr];
    for (id selector in [iTM2Runtime instanceSelectorsOfClass:self.class withSuffix:@"CompleteSaveContext4iTM3:" signature:I.methodSignature inherited:YES]) {
        [I setSelector:(SEL)selector];
        I.invoke;
        if (!result) {
            [I getReturnValue:&result];
        }
    }
	[SUD synchronize];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  awakeFromContext4iTM3:
- (void)awakeFromContext4iTM3;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  loadContext4iTM3Error:
- (BOOL)loadContext4iTM3Error:(NSError **)outErrorPtr;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSInvocation * I;
	[[NSInvocation getInvocation4iTM3:&I withTarget:self retainArguments:NO] loadContext4iTM3Error:outErrorPtr];
    BOOL result = YES;
    for (id selector in [iTM2Runtime instanceSelectorsOfClass:self.class withSuffix:@"CompleteLoadContext4iTM3Error:" signature:I.methodSignature inherited:YES]) {
        [I setSelector:(SEL)selector];
        I.invoke;
        if (result) {
            [I getReturnValue:&result];
        }
    }
//END4iTM3;
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  context4iTM3DidChangeComplete
- (void)context4iTM3DidChangeComplete;
/*"This message discards any pending change in the context manager.
Send this message just before you return from your -context4iTM3DidChange method
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 10/20/2006
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[self.class cancelPreviousPerformRequestsWithTarget:self selector:@selector(context4iTM3DidChange) object:nil];
	[self.implementation takeMetaValue:nil forKey:@"iTM2ContextRegistrationNeeded"];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  notifyContext4iTM3Change
- (BOOL)notifyContext4iTM3Change;
/*"This message should be sent each time the context have changed.
It is automatically sent by the takeContext4iTM3Value:forKey:context: methods.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 10/20/2006
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[self.implementation takeMetaValue:[NSNumber numberWithBool:YES] forKey:@"iTM2ContextRegistrationNeeded"];
	[self.class cancelPreviousPerformRequestsWithTarget:self selector:@selector(context4iTM3DidChange) object:nil];
	[self performSelector:@selector(context4iTM3DidChange) withObject:nil afterDelay:ZER0];
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  context4iTM3DidChange
- (void)context4iTM3DidChange;
/*"This message is sent each time the context4iTM3Manager have changed on the next loop after the change.
The receiver will take appropriate actions to synchronize its state with its context4iTM3Manager.
Subclasses will most certainly override this method because the default implementation does nothing.
You must send a - context4iTM3DidChangeComplete just before returning. This addresses reentrant code problems.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  context4iTM3RegistrationNeeded
- (BOOL)context4iTM3RegistrationNeeded;
/*"This message is sent each time the context4iTM3Manager have changed.
The receiver will take appropriate actions to synchronize its state with its context4iTM3Manager.
Subclasses will most certainly override this method because the default implementation does nothing.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [[self.implementation metaValueForKey:@"iTM2ContextRegistrationNeeded"] boolValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  context4iTM3StateForKey:
- (NSUInteger)context4iTM3StateForKey:(NSString *)aKey;  
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if ([self context4iTM3BoolForKey:aKey domain:iTM2ContextPrivateMask])
	{
		return NSOnState;
	}
	if ([self context4iTM3ValueForKey:aKey domain:iTM2ContextPrivateMask])
	{
		return NSOffState;
	}
	if ([self context4iTM3BoolForKey:aKey domain:iTM2ContextAllDomainsMask])
	{
		return NSMixedState;
	}
	return NSOffState;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleContext4iTM3BoolForKey:
- (void)toggleContext4iTM3BoolForKey:(NSString *)aKey;  
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if ([self context4iTM3BoolForKey:aKey domain:iTM2ContextPrivateMask]) {
		if ([self context4iTM3BoolForKey:aKey domain:iTM2ContextAllDomainsMask&~iTM2ContextPrivateMask]) {
			[self takeContext4iTM3Bool:NO forKey:aKey domain:iTM2ContextPrivateMask];
			return;
		}
		[self takeContext4iTM3Value:nil forKey:aKey domain:iTM2ContextPrivateMask];
		return;
	}
	if ([self context4iTM3BoolForKey:aKey domain:iTM2ContextAllDomainsMask&~iTM2ContextPrivateMask]) {
		[self takeContext4iTM3Value:nil forKey:aKey domain:iTM2ContextPrivateMask];
		return;
	}
	[self takeContext4iTM3Bool:YES forKey:aKey domain:iTM2ContextPrivateMask];
	return;
}
@end

@implementation NSWindowController(iTM2ContextKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  currentContext4iTM3Manager
- (id)currentContext4iTM3Manager;
/*"Returns the context4iTM3Manager of its document.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3
    return self.document?:[super currentContext4iTM3Manager];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  windowControllerCompleteSaveContext4iTM3Error:
- (void)windowControllerCompleteSaveContext4iTM3Error:(NSError **)outErrorPtr;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
    return [self.window saveContext4iTM3Error:outErrorPtr];
}
@end

@implementation NSWindow(iTM2ContextKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  currentContext4iTM3Manager
- (id)currentContext4iTM3Manager;
/*"Returns the context4iTM3Manager of its window controller.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3
	id delegate = self.delegate;
	if (delegate) {
		return delegate;
	}
	NSWindowController * windowController = self.windowController;
	if (windowController) {
		return windowController;
	}
	NSWindow * parentWindow = self.parentWindow;
	if (parentWindow) {
		return parentWindow;
	}
    return [super currentContext4iTM3Manager];
}
@end

@implementation NSResponder(iTM2ContextKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  currentContext4iTM3Manager
- (id)currentContext4iTM3Manager;
/*"Returns the context4iTM3Manager of its window.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3
    return (id)self.nextResponder?:[super currentContext4iTM3Manager];
}
@end

@implementation NSView(iTM2ContextKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  currentContext4iTM3Manager
- (id)currentContext4iTM3Manager;
/*"Returns the context4iTM3Manager of its window.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3
    return (id)self.superview?:(id)self.window;
}
@end

@implementation NSTextStorage(iTM2ContextKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  currentContext4iTM3Manager
- (id)currentContext4iTM3Manager;
/*"Returns the context4iTM3Manager of the first text view of its first layout manager.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.b0: 04/17/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3
    return [[self.layoutManagers lastObject] currentContext4iTM3Manager];
}
@end

@implementation NSLayoutManager(iTM2ContextKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  currentContext4iTM3Manager
- (id)currentContext4iTM3Manager;
/*"Returns the context4iTM3Manager of the first text view of its first layout manager.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.b0: 04/17/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3
    return self.firstTextView;
}
@end

@implementation NSUserDefaults(iTM2ContextKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  context4iTM3Manager:
- (id)context4iTM3Manager;
/*"Returns the context4iTM3Manager of the first text view of its first layout manager.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.b0: 04/17/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3
    return SUD != self? SUD: nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  context4iTM3ValueForKey:domain:
- (id)context4iTM3ValueForKey:(NSString *)aKey domain:(NSUInteger)mask;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return (mask & iTM2ContextDefaultsMask)?[self objectForKey:aKey]: nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setContext4iTM3Value:forKey:domain:
- (NSUInteger)setContext4iTM3Value:(id)object forKey:(NSString *)aKey domain:(NSUInteger)mask;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//LOG4iTM3(@"[self takeContext4iTM3Value:%@ forKey:%@]", object, aKey);
	NSParameterAssert((aKey != nil));
	if (mask & iTM2ContextDefaultsMask) {
		id old = [self objectForKey:aKey];
		if (![old isEqual:object] && (old != object)) {
			if (object) {
				[self setObject:object forKey:aKey];
			} else {
				[self removeObjectForKey:aKey];
			}
			return iTM2ContextDefaultsMask;
		}
	}
    return ZER0;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  context4iTM3StringForKey:domain:
- (NSString *)context4iTM3StringForKey:(NSString *)aKey domain:(NSUInteger)mask;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return mask & iTM2ContextStandardDefaultsMask?[self stringForKey:aKey]:nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  context4iTM3ArrayForKey:domain:
- (NSArray *)context4iTM3ArrayForKey:(NSString *)aKey domain:(NSUInteger)mask;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return mask & iTM2ContextStandardDefaultsMask?[self arrayForKey:aKey]:nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  context4iTM3DictionaryForKey:domain:
- (NSDictionary *)context4iTM3DictionaryForKey:(NSString *)aKey domain:(NSUInteger)mask;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return mask & iTM2ContextStandardDefaultsMask?[self dictionaryForKey:aKey]:nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  context4iTM3DataForKey:domain:
- (NSData *)context4iTM3DataForKey:(NSString *)aKey domain:(NSUInteger)mask;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return mask & iTM2ContextStandardDefaultsMask?[self dataForKey:aKey]:nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  context4iTM3StringArrayForKey:domain:
- (NSArray *)context4iTM3StringArrayForKey:(NSString *)aKey domain:(NSUInteger)mask;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return mask & iTM2ContextStandardDefaultsMask?[self stringArrayForKey:aKey]:nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  context4iTM3IntegerForKey:domain:
- (NSInteger)context4iTM3IntegerForKey:(NSString *)aKey domain:(NSUInteger)mask; 
/*"Description forthcoming.
 Version history: jlaurens AT users DOT sourceforge DOT net
 - 1.1.a6: 03/26/2002
 To Do List:
 "*/
{DIAGNOSTIC4iTM3;
	//START4iTM3;
	//END4iTM3;
    return mask & iTM2ContextStandardDefaultsMask?[self integerForKey:aKey]:ZER0;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  context4iTM3UnsignedIntegerForKey:domain:
- (NSUInteger)context4iTM3UnsignedIntegerForKey:(NSString *)aKey domain:(NSUInteger)mask; 
/*"Description forthcoming.
 Version history: jlaurens AT users DOT sourceforge DOT net
 - 1.1.a6: 03/26/2002
 To Do List:
 "*/
{DIAGNOSTIC4iTM3;
	//START4iTM3;
	//END4iTM3;
    return mask & iTM2ContextStandardDefaultsMask?(NSUInteger)[self integerForKey:aKey]:ZER0;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  context4iTM3FloatForKey:domain:
- (CGFloat)context4iTM3FloatForKey:(NSString *)aKey domain:(NSUInteger)mask; 
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return mask & iTM2ContextStandardDefaultsMask?[self floatForKey:aKey]:0.0;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  context4iTM3BoolForKey:domain:
- (BOOL)context4iTM3BoolForKey:(NSString *)aKey domain:(NSUInteger)mask;  
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return mask & iTM2ContextStandardDefaultsMask?[self boolForKey:aKey]:NO;
}
@end

#import <objc/objc-runtime.h>
#import <objc/objc-class.h>

@interface NSDocument_iTM2ContextKit: NSDocument
@end

@implementation iTM2MainInstaller(iTM2ContextKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2ContextKitCompleteInstallation4iTM3
+ (void)iTM2ContextKitCompleteInstallation4iTM3;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [DNC addObserver:[NSDocument class] selector:@selector(iTM2ContextKit_ApplicationWillTerminateNotified:) name:NSApplicationWillTerminateNotification object:nil];
//END4iTM3;
    return;
}
@end

NSString * const iTM2ContextExtensionsKey = @"iTM2ContextExtensions";
NSString * const iTM2ContextTypesKey = @"iTM2ContextTypes";

@implementation NSDocument(iTM2ContextKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2ContextKitCompleteInstallation4iTM3
+ (void)iTM2ContextKitCompleteInstallation4iTM3;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSError * ROR = nil;
	if ([NSDocument swizzleInstanceMethodSelector4iTM3:@selector(SWZ_iTM2ContextKit_canCloseDocumentWithDelegate:shouldCloseSelector:contextInfo:) error:&ROR])
	{
		MILESTONE4iTM3((@"NSDocument(iTM2ContextKit)"),(@"WARNING: canCloseDocumentWithDelegate:... message could not be patched..."));
	} else if (ROR) {
        LOG4iTM3(@"ROR: %@",ROR);
    }
    [DNC addObserver:self selector:@selector(iTM2ContextKit_ApplicationWillTerminateNotified:) name:NSApplicationWillTerminateNotification object:nil];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2ContextKit_ApplicationWillTerminateNotified:
+ (void)iTM2ContextKit_ApplicationWillTerminateNotified:(NSNotification *)notification;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [[SDC documents] makeObjectsPerformSelector:@selector(saveContext4iTM3:) withObject:nil];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= SWZ_iTM2ContextKit_canCloseDocumentWithDelegate:shouldCloseSelector:contextInfo:
- (void)SWZ_iTM2ContextKit_canCloseDocumentWithDelegate:(id)delegate shouldCloseSelector:(SEL)shouldCloseSelector contextInfo:(void *)contextInfo;
/*"Description forthcoming. To ensure the context is properly saved
Version history: jlaurens AT users DOT sourceforge DOT net (10/04/2001)
- 1.4: Fri Apr 16 11:39:43 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//LOG4iTM3(@"delegate is: %@, shouldCloseSelector is: %@, contextInfo is: %#x", delegate, NSStringFromSelector(shouldCloseSelector), contextInfo);
 	NSMethodSignature * MS = [delegate methodSignatureForSelector:shouldCloseSelector];
	if (MS) {
		NSInvocation * I = [NSInvocation invocationWithMethodSignature:MS];
		[I retainArguments];
		[I setArgument:&self atIndex:2];
		I.target = delegate;
		[I setSelector:shouldCloseSelector];
		if (contextInfo)
			[I setArgument:&contextInfo atIndex:4];
		[self SWZ_iTM2ContextKit_canCloseDocumentWithDelegate:self shouldCloseSelector:@selector(_Context_document:shouldClose:shouldCloseInvocation:) contextInfo:[I retain]];
//END4iTM3;
		return;
	}
	LOG4iTM3(@"A delegate is expected to implement a should close selector:\ndelegate; %@\nselector: %@", delegate, NSStringFromSelector(shouldCloseSelector));
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  _Context_document:shouldClose:shouldCloseInvocation:
- (void)_Context_document:(NSDocument *)doc shouldClose:(BOOL)shouldClose shouldCloseInvocation:(NSInvocation *)invocation;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Mon Mar 15 13:59:04 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//LOG4iTM3(@"doc.fileURL.path is:%@, context4iTM3Dictionary is:%#x", doc.fileURL.path, context4iTM3Dictionary);
	[invocation autorelease];
	if (shouldClose) {
        NSError * ROR = nil;
		[doc saveContext4iTM3Error:&ROR];
        REPORTERROR4iTM3(1,@"",ROR);
    }
	[invocation setArgument:&shouldClose atIndex:3];
	[invocation invoke];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  getContext4iTM3ValueForKey:domain:
- (id)getContext4iTM3ValueForKey:(NSString *)aKey domain:(NSUInteger)mask;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	// if there is no context value, looking in the general stuff for the file extension
	id result = nil;
	if ((result = [super getContext4iTM3ValueForKey:aKey domain:mask&~iTM2ContextStandardDefaultsMask])) {
		return result;
	}

	if (mask & iTM2ContextExtendedDefaultsMask) {
		NSString * contextKey = nil;
		NSDictionary * D = nil;
		NSString * type = self.fileType;
		if (type.length) {
			contextKey = [iTM2ContextTypesKey stringByAppendingPathExtension:type];
			D = [SUD dictionaryForKey:contextKey];
			if ((result = [D objectForKey:aKey])) {
				return result;
			}
		}
		NSString * type4URL = [SDC typeForContentsOfURL:self.fileURL error:NULL];
		if (type4URL.length && ![type4URL isEqualToUTType4iTM3:type]) {
			contextKey = [iTM2ContextTypesKey stringByAppendingPathExtension:type4URL];
			D = [SUD dictionaryForKey:contextKey];
			if ((result = [D objectForKey:aKey])) {
				return result;
			}
		}
	}
	result = [super getContext4iTM3ValueForKey:aKey domain:mask];// debug design
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setContext4iTM3Value:forKey:domain:
- (NSUInteger)setContext4iTM3Value:(id)object forKey:(NSString *)aKey domain:(NSUInteger)mask;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSUInteger didChange = [super setContext4iTM3Value:object forKey:aKey domain:mask];
	// Set the value in the user defaults data base with the file extension and document type
	if (mask & iTM2ContextExtendedDefaultsMask) {
		NSString * contextKey = nil;
		NSMutableDictionary * D = nil;
		NSString * type = self.fileType;
		id old = nil;
		if (type.length) {
			contextKey = [iTM2ContextTypesKey stringByAppendingPathExtension:type];
			D = [[[SUD dictionaryForKey:contextKey] mutableCopy] autorelease]?:[NSMutableDictionary dictionary];
			if (![old isEqual:object] && (old != object)) {
				[D setValue:object forKey:aKey];
				[SUD setObject:D forKey:contextKey];
			}
		}
		NSString * type4URL = [SDC typeForContentsOfURL:self.fileURL error:NULL];
		if (type4URL.length && ![type4URL isEqualToUTType4iTM3:type]) {
			contextKey = [iTM2ContextTypesKey stringByAppendingPathExtension:type4URL];
			D = [[[SUD dictionaryForKey:contextKey] mutableCopy] autorelease]?:[NSMutableDictionary dictionary];
			if (![old isEqual:object] && (old != object)) {
				[D setValue:object forKey:aKey];
				[SUD setObject:D forKey:contextKey];
			}
		}
	}
//LOG4iTM3(@"self.context4iTM3Dictionary is:%@", self.context4iTM3Dictionary);
    return didChange && self.notifyContext4iTM3Change;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  documentCompleteSaveContext4iTM3:
- (void)documentCompleteSaveContext4iTM3:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self.windowControllers makeObjectsPerformSelector:@selector(saveContext4iTM3:) withObject:sender];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  documentCompleteLoadContext4iTM3:
- (void)documentCompleteLoadContext4iTM3:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self.windowControllers makeObjectsPerformSelector:@selector(loadContext4iTM3:) withObject:sender];
//END4iTM3;
    return;
}
@end

@implementation NSObject (iTM2CopyLinkMoveHandler)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  fileManager:shouldProceedAfterError:
-(BOOL)fileManager:(NSFileManager *)manager shouldProceedAfterError:(NSDictionary *)errorInfo;
/*"Description forthcoming.
 Version History: jlaurens AT users DOT sourceforge DOT net
 - 2.0: Fri Feb 20 13:19:00 GMT 2004
 To Do List:
 "*/
{DIAGNOSTIC4iTM3;
	if ([self context4iTM3BoolForKey:@"iTM2NoAlertAfterFileOperationError" domain:iTM2ContextAllDomainsMask]
	   && !iTM2DebugEnabled)
	{
		return NO;
	}
	//START4iTM3;
    NSInteger result = NSRunCriticalAlertPanel([[NSBundle mainBundle] bundleName4iTM3], @"File operation error:\
										 %@ with file: %@", @"Proceed Anyway", @"Cancel",  NULL, 
										 [errorInfo objectForKey:@"Error"], 
										 [errorInfo objectForKey:@"Path"]);
	LOG4iTM3(@"**** FILE MANAGER OPERATION ERROR: %@", errorInfo);
	//END4iTM3;
    return (result == NSAlertDefaultReturn);
}
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2ContextKit
