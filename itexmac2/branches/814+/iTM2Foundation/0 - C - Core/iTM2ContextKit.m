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
/*"This object is used to store contextManager that might override some contextManager in a basic set of contextManager, typically the user defaults data base. It implements all the setters and getters of the NSUserDefaults instances. Beware when categories are created. All the setters really fill the contextManager, even if afterwards the values are the same in the contextManager and the base contextManager. This might be implemented in a different way driven by a flag. It is consistent now because the base contextManager are the user defaults data base: if those defaults are changed, the local contextManager are not.

When no basic contextManager are given on initialization time, the user defaults data base is used instead. The NSUserDefaults shared instance is cached.

Various categories are declared here, the NSDocument instances are the only object where contextManager are really stored, if ever."*/
@implementation NSObject(iTM2ContextKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  currentContextManager
- (id)currentContextManager;
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  contextManager
- (id)contextManager;
/*"Subclasses will most certainly override this method.
Default implementation returns the NSUserDefaults shared instance.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return self.currentContextManager;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setContextManager:
- (void)setContextManager:(id)manager;
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  updateContextManager
- (void)updateContextManager;
/*"Subclasses will most certainly override this method.
Default implementation returns the NSUserDefaults shared instance.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  contextDictionary
- (id)contextDictionary;
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setContextDictionary:
- (void)setContextDictionary:(id)dictionary;
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  contextValueForKey:domain:
- (id)contextValueForKey:(NSString *)aKey domain:(NSUInteger)mask;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return [self getContextValueForKey:aKey domain:mask];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  getContextValueForKey:domain:
- (id)getContextValueForKey:(NSString *)aKey domain:(NSUInteger)mask;
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
		NSDictionary * D = self.contextDictionary;
		if (result = [D valueForKey:aKey])
		{
			return result;
		}
		id contextManager = self.contextManager;
		if ((self != contextManager && SUD != contextManager) && (result = [contextManager contextValueForKey:aKey domain:mask]))
		{
			return result;
		}
	}
	if (mask & iTM2ContextDefaultsMask)
	{
		result = [SUD contextValueForKey:aKey domain:mask];
	}
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeContextValue:forKey:domain:
- (NSUInteger)takeContextValue:(id)object forKey:(NSString *)aKey domain:(NSUInteger)mask;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//LOG4iTM3(@"self.contextDictionary is:%@", self.contextDictionary);
	NSUInteger didChange = [self setContextValue:object forKey:aKey domain:mask];
	if (didChange) {
		id afterObject = [self contextValueForKey:aKey domain:mask];
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setContextValue:forKey:domain:
- (NSUInteger)setContextValue:(id)object forKey:(NSString *)aKey domain:(NSUInteger)mask;
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
		NSDictionary * D = self.contextDictionary;
		id contextManager = self.contextManager;
		if (D) {
			didChange = 0;
			id old = [D valueForKey:aKey];
			if (![old isEqual:object]) {
				[[old retain] autorelease];
				[D setValue:object forKey:aKey];
				didChange |= iTM2ContextStandardLocalMask;
			}
		}
		if (contextManager && self != contextManager && SUD != contextManager) {
			didChange &= ~iTM2ContextNoContextMask;
			didChange |= [contextManager takeContextValue:object forKey:aKey domain:mask];
		}
	}
	if (mask & iTM2ContextDefaultsMask) {
		didChange &= ~iTM2ContextNoContextMask;
		didChange |= [SUD takeContextValue:object forKey:aKey domain:mask];
	}
	if (didChange &= ~iTM2ContextNoContextMask) {
		self.notifyContextChange;
	}
//LOG4iTM3(@"self.contextDictionary is:%@", self.contextDictionary);
    return didChange;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= contextFontForKey:domain:
- (NSFont *)contextFontForKey:(NSString *)aKey domain:(NSUInteger)mask;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSDictionary * D = [self contextValueForKey:aKey domain:mask];
//END4iTM3;
    return [NSFont fontWithNameSizeDictionary:D];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= takeContextFont:forKey:domain:
- (void)takeContextFont:(NSFont *)aFont forKey:(NSString *)aKey domain:(NSUInteger)mask;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSDictionary * D = [aFont nameSizeDictionary];
    [self takeContextValue:D forKey:aKey domain:mask];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= contextColorForKey:domain:
- (NSColor *)contextColorForKey:(NSString *)aKey domain:(NSUInteger)mask;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSDictionary * D = [self contextValueForKey:aKey domain:mask];
//END4iTM3;
    return [NSColor colorWithRGBADictionary:D];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= takeContextColor:forKey:domain:
- (void)takeContextColor:(NSColor *)aColor forKey:(NSString *)aKey domain:(NSUInteger)mask;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSDictionary * D = [aColor RGBADictionary];
    [self takeContextValue:D forKey:aKey domain:mask];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  contextStringForKey:domain:
- (NSString *)contextStringForKey:(NSString *)aKey domain:(NSUInteger)mask;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	id result = nil;
	if (mask & iTM2ContextStandardLocalMask) {
		NSDictionary * D = self.contextDictionary;
		if ((result = [D valueForKey:aKey])) {
			if ([result isKindOfClass:[NSString class]]) {
				return result;
			}
			if ([result respondsToSelector:@selector(stringValue)]) {
				return [result stringValue];
			}
		}
		id contextManager = self.contextManager;
		if ((contextManager != self) && (contextManager != SUD)
                && (result = [contextManager contextStringForKey:aKey domain:mask])) {
			return result;
		}
	}
	result = [SUD contextStringForKey:aKey domain:mask];
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  contextArrayForKey:domain:
- (NSArray *)contextArrayForKey:(NSString *)aKey domain:(NSUInteger)mask;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	id result = nil;
	if (mask & iTM2ContextStandardLocalMask) {
		if (result = [self.contextDictionary valueForKey:aKey]) {
			if ([result isKindOfClass:[NSArray class]]) {
				return result;
			}
		}
		id contextManager = self.contextManager;
		if ((contextManager != self) && (contextManager != SUD)
                && (result = [contextManager contextArrayForKey:aKey domain:mask])) {
			return result;
		}
	}
	result = [SUD contextArrayForKey:aKey domain:mask];
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  contextDictionaryForKey:domain:
- (NSDictionary *)contextDictionaryForKey:(NSString *)aKey domain:(NSUInteger)mask;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	id result = nil;
	if (mask & iTM2ContextStandardLocalMask) {
		if ((result = [self.contextDictionary valueForKey:aKey])) {
			if ([result isKindOfClass:[NSDictionary class]]) {
				return result;
			}
		}
		id contextManager = self.contextManager;
		if ((contextManager != self) && (contextManager != SUD)
                && (result = [contextManager contextDictionaryForKey:aKey domain:mask])) {
			return result;
		}
	}
	result = [SUD contextDictionaryForKey:aKey domain:mask];
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  contextDataForKey:domain:
- (NSData *)contextDataForKey:(NSString *)aKey domain:(NSUInteger)mask;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	id result = nil;
	if (mask & iTM2ContextStandardLocalMask) {
		if ((result = [self.contextDictionary valueForKey:aKey])) {
			if ([result isKindOfClass:[NSData class]]) {
				return result;
			}
		}
		id contextManager = self.contextManager;
		if ((contextManager != self) && (contextManager != SUD)
                && (result = [contextManager contextDataForKey:aKey domain:mask])) {
			return result;
		}
	}
	result = [SUD contextDataForKey:aKey domain:mask];
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  contextStringArrayForKey:domain:
- (NSArray *)contextStringArrayForKey:(NSString *)aKey domain:(NSUInteger)mask;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSArray * result = nil;
	if (mask & iTM2ContextStandardLocalMask) {
		if (result = [self.contextDictionary valueForKey:aKey]) {
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
		id contextManager = self.contextManager;
		if ((contextManager != self) && (contextManager != SUD)
                && (result = [contextManager contextStringArrayForKey:aKey domain:mask])) {
			return result;
		}
	}
	result = [SUD contextStringArrayForKey:aKey domain:mask];
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  contextFloatForKey:domain:
- (CGFloat)contextFloatForKey:(NSString *)aKey domain:(NSUInteger)mask; 
/*"Description forthcoming.
 Version history: jlaurens AT users DOT sourceforge DOT net
 - 1.1.a6: 03/26/2002
 To Do List:
 "*/
{DIAGNOSTIC4iTM3;
	//START4iTM3;
	NSNumber * value = nil;
	if (mask & iTM2ContextStandardLocalMask) {
		if ((value = [self.contextDictionary valueForKey:aKey])) {
			if ([value respondsToSelector:@selector(floatValue)]) {
				return value.floatValue;
			}
		}
		id contextManager = self.contextManager;
		if ((contextManager != self) && (contextManager != SUD)
		   && ((value = [contextManager contextValueForKey:aKey domain:mask]))
                && [value respondsToSelector:@selector(floatValue)]) {
			return value.floatValue;
		}
	}
	CGFloat result = [SUD contextFloatForKey:aKey domain:mask];
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  contextIntegerForKey:domain:
- (NSInteger)contextIntegerForKey:(NSString *)aKey domain:(NSUInteger)mask; 
/*"Description forthcoming.
 Version history: jlaurens AT users DOT sourceforge DOT net
 - 1.1.a6: 03/26/2002
 To Do List:
 "*/
{DIAGNOSTIC4iTM3;
	//START4iTM3;
	id value = nil;
	if (mask & iTM2ContextStandardLocalMask) {
		if ((value = [self.contextDictionary valueForKey:aKey])) {
			if (([value respondsToSelector:@selector(integerValue)])) {
				return [value integerValue];
			}
		}
		id contextManager = self.contextManager;
		if ((contextManager != self) && (contextManager != SUD)
            && (value = [contextManager contextValueForKey:aKey domain:mask])
                &&([value respondsToSelector:@selector(integerValue)])) {
			return [value integerValue];
		}
	}
	NSInteger result = [SUD contextIntegerForKey:aKey domain:mask];
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  contextIntegerForKey:domain:
- (NSUInteger)contextUnsignedIntegerForKey:(NSString *)aKey domain:(NSUInteger)mask; 
/*"Description forthcoming.
 Version history: jlaurens AT users DOT sourceforge DOT net
 - 1.1.a6: 03/26/2002
 To Do List:
 "*/
{DIAGNOSTIC4iTM3;
	//START4iTM3;
	id value = nil;
	if (mask & iTM2ContextStandardLocalMask) {
		if ((value = [self.contextDictionary valueForKey:aKey])) {
			if ([value respondsToSelector:@selector(unsignedIntegerValue)]) {
				return [value unsignedIntegerValue];
			}
		}
		id contextManager = self.contextManager;
		if ((contextManager != self) && (contextManager != SUD)
            && (value = [contextManager contextValueForKey:aKey domain:mask])
                &&([value respondsToSelector:@selector(unsignedIntegerValue)])) {
			return [value unsignedIntegerValue];
		}
	}
	NSUInteger result = [SUD contextUnsignedIntegerForKey:aKey domain:mask];
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  contextBoolForKey:domain:
- (BOOL)contextBoolForKey:(NSString *)aKey domain:(NSUInteger)mask;  
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	id value = nil;
	if (mask & iTM2ContextStandardLocalMask) {
		NSDictionary * D = self.contextDictionary;
		if ((value = [D valueForKey:aKey])
			&& [value respondsToSelector:@selector(boolValue)]) {
			return [value boolValue];
		}
		id contextManager = self.contextManager;
		if ((contextManager != self) && (contextManager != SUD)
			&& ((value = [contextManager contextValueForKey:aKey domain:mask]))
				&& [value respondsToSelector:@selector(boolValue)]) {
			return [value boolValue];
		}
	}
	BOOL result = [SUD contextBoolForKey:aKey domain:mask];
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeContextInteger:forKey:domain:
- (void)takeContextInteger:(NSInteger)value forKey:(NSString *)aKey domain:(NSUInteger)mask;
/*"Description forthcoming.
 Version history: jlaurens AT users DOT sourceforge DOT net
 - 1.1.a6: 03/26/2002
 To Do List:
 "*/
{DIAGNOSTIC4iTM3;
	//START4iTM3;
    [self takeContextValue:[NSNumber numberWithInteger:value] forKey:aKey domain:mask];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeContextUnsignedInteger:forKey:domain:
- (void)takeContextUnsignedInteger:(NSUInteger)value forKey:(NSString *)aKey domain:(NSUInteger)mask;
/*"Description forthcoming.
 Version history: jlaurens AT users DOT sourceforge DOT net
 - 1.1.a6: 03/26/2002
 To Do List:
 "*/
{DIAGNOSTIC4iTM3;
	//START4iTM3;
    [self takeContextValue:[NSNumber numberWithUnsignedInteger:value] forKey:aKey domain:mask];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeContextFloat:forKey:domain:
- (void)takeContextFloat:(CGFloat)value forKey:(NSString *)aKey domain:(NSUInteger)mask;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self takeContextValue:[NSNumber numberWithFloat:value] forKey:aKey domain:mask];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeContextBool:forKey:domain:
- (void)takeContextBool:(BOOL)value forKey:(NSString *)aKey domain:(NSUInteger)mask;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self takeContextValue:[NSNumber numberWithBool:value] forKey:aKey domain:mask];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  saveContext:
- (void)saveContext:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSInvocation * I;
	[[NSInvocation getInvocation4iTM3:&I withTarget:self retainArguments:NO] saveContext:sender];
    for (id selector in [iTM2Runtime instanceSelectorsOfClass:self.class withSuffix:@"CompleteSaveContext4iTM3:" signature:[I methodSignature] inherited:YES]) {
        [I setSelector:(SEL)selector];
        [I invoke];
    }
	[SUD synchronize];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  awakeFromContext:
- (void)awakeFromContext;
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  loadContext:
- (void)loadContext:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSInvocation * I;
	[[NSInvocation getInvocation4iTM3:&I withTarget:self retainArguments:NO] loadContext:sender];
    for (id selector in [iTM2Runtime instanceSelectorsOfClass:self.class withSuffix:@"CompleteLoadContext4iTM3:" signature:[I methodSignature] inherited:YES]) {
        [I setSelector:(SEL)selector];
        [I invoke];
    }
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  contextDidChangeComplete
- (void)contextDidChangeComplete;
/*"This message discards any pending change in the context manager.
Send this message just before you return from your -contextDidChange method
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 10/20/2006
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[self.class cancelPreviousPerformRequestsWithTarget:self selector:@selector(contextDidChange) object:nil];
	[self.implementation takeMetaValue:nil forKey:@"iTM2ContextRegistrationNeeded"];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  notifyContextChange
- (void)notifyContextChange;
/*"This message should be sent each time the context have changed.
It is automatically sent by the takeContextValue:forKey:context: methods.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 10/20/2006
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[self.implementation takeMetaValue:[NSNumber numberWithBool:YES] forKey:@"iTM2ContextRegistrationNeeded"];
	[self.class cancelPreviousPerformRequestsWithTarget:self selector:@selector(contextDidChange) object:nil];
	[self performSelector:@selector(contextDidChange) withObject:nil afterDelay:0];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  contextDidChange
- (void)contextDidChange;
/*"This message is sent each time the contextManager have changed on the next loop after the change.
The receiver will take appropriate actions to synchronize its state with its contextManager.
Subclasses will most certainly override this method because the default implementation does nothing.
You must send a - contextDidChangeComplete just before returning. This addresses reentrant code problems.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  contextRegistrationNeeded
- (BOOL)contextRegistrationNeeded;
/*"This message is sent each time the contextManager have changed.
The receiver will take appropriate actions to synchronize its state with its contextManager.
Subclasses will most certainly override this method because the default implementation does nothing.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [[self.implementation metaValueForKey:@"iTM2ContextRegistrationNeeded"] boolValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  contextStateForKey:
- (NSUInteger)contextStateForKey:(NSString *)aKey;  
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if ([self contextBoolForKey:aKey domain:iTM2ContextPrivateMask])
	{
		return NSOnState;
	}
	if ([self contextValueForKey:aKey domain:iTM2ContextPrivateMask])
	{
		return NSOffState;
	}
	if ([self contextBoolForKey:aKey domain:iTM2ContextAllDomainsMask])
	{
		return NSMixedState;
	}
	return NSOffState;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleContextBoolForKey:
- (void)toggleContextBoolForKey:(NSString *)aKey;  
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if ([self contextBoolForKey:aKey domain:iTM2ContextPrivateMask]) {
		if ([self contextBoolForKey:aKey domain:iTM2ContextAllDomainsMask&~iTM2ContextPrivateMask]) {
			[self takeContextBool:NO forKey:aKey domain:iTM2ContextPrivateMask];
			return;
		}
		[self takeContextValue:nil forKey:aKey domain:iTM2ContextPrivateMask];
		return;
	}
	if ([self contextBoolForKey:aKey domain:iTM2ContextAllDomainsMask&~iTM2ContextPrivateMask]) {
		[self takeContextValue:nil forKey:aKey domain:iTM2ContextPrivateMask];
		return;
	}
	[self takeContextBool:YES forKey:aKey domain:iTM2ContextPrivateMask];
	return;
}
@end

@implementation NSWindowController(iTM2ContextKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  currentContextManager
- (id)currentContextManager;
/*"Returns the contextManager of its document.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3
    return self.document?:[super currentContextManager];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  windowControllerCompleteSaveContext4iTM3:
- (void)windowControllerCompleteSaveContext4iTM3:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self.window saveContext:sender];
//END4iTM3;
    return;
}
@end

@implementation NSWindow(iTM2ContextKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  currentContextManager
- (id)currentContextManager;
/*"Returns the contextManager of its window controller.
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
    return [super currentContextManager];
}
@end

@implementation NSResponder(iTM2ContextKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  currentContextManager
- (id)currentContextManager;
/*"Returns the contextManager of its window.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3
    return (id)self.nextResponder?:[super currentContextManager];
}
@end

@implementation NSView(iTM2ContextKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  currentContextManager
- (id)currentContextManager;
/*"Returns the contextManager of its window.
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  currentContextManager
- (id)currentContextManager;
/*"Returns the contextManager of the first text view of its first layout manager.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.b0: 04/17/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3
    return [[self.layoutManagers lastObject] firstTextView];
}
@end

@implementation NSLayoutManager(iTM2ContextKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  currentContextManager
- (id)currentContextManager;
/*"Returns the contextManager of the first text view of its first layout manager.
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  contextManager:
- (id)contextManager;
/*"Returns the contextManager of the first text view of its first layout manager.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.b0: 04/17/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3
    return SUD != self? SUD: nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  contextValueForKey:domain:
- (id)contextValueForKey:(NSString *)aKey domain:(NSUInteger)mask;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return (mask & iTM2ContextDefaultsMask)?[self objectForKey:aKey]: nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setContextValue:forKey:domain:
- (NSUInteger)setContextValue:(id)object forKey:(NSString *)aKey domain:(NSUInteger)mask;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//LOG4iTM3(@"[self takeContextValue:%@ forKey:%@]", object, aKey);
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
    return 0;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  contextStringForKey:domain:
- (NSString *)contextStringForKey:(NSString *)aKey domain:(NSUInteger)mask;
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  contextArrayForKey:domain:
- (NSArray *)contextArrayForKey:(NSString *)aKey domain:(NSUInteger)mask;
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  contextDictionaryForKey:domain:
- (NSDictionary *)contextDictionaryForKey:(NSString *)aKey domain:(NSUInteger)mask;
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  contextDataForKey:domain:
- (NSData *)contextDataForKey:(NSString *)aKey domain:(NSUInteger)mask;
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  contextStringArrayForKey:domain:
- (NSArray *)contextStringArrayForKey:(NSString *)aKey domain:(NSUInteger)mask;
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  contextIntegerForKey:domain:
- (NSInteger)contextIntegerForKey:(NSString *)aKey domain:(NSUInteger)mask; 
/*"Description forthcoming.
 Version history: jlaurens AT users DOT sourceforge DOT net
 - 1.1.a6: 03/26/2002
 To Do List:
 "*/
{DIAGNOSTIC4iTM3;
	//START4iTM3;
	//END4iTM3;
    return mask & iTM2ContextStandardDefaultsMask?[self integerForKey:aKey]:0;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  contextUnsignedIntegerForKey:domain:
- (NSUInteger)contextUnsignedIntegerForKey:(NSString *)aKey domain:(NSUInteger)mask; 
/*"Description forthcoming.
 Version history: jlaurens AT users DOT sourceforge DOT net
 - 1.1.a6: 03/26/2002
 To Do List:
 "*/
{DIAGNOSTIC4iTM3;
	//START4iTM3;
	//END4iTM3;
    return mask & iTM2ContextStandardDefaultsMask?(NSUInteger)[self integerForKey:aKey]:0;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  contextFloatForKey:domain:
- (CGFloat)contextFloatForKey:(NSString *)aKey domain:(NSUInteger)mask; 
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  contextBoolForKey:domain:
- (BOOL)contextBoolForKey:(NSString *)aKey domain:(NSUInteger)mask;  
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
+ (void)iTM2ContextKitCompleteInstallation4iTM3;// never called
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[NSDocument swizzleInstanceMethodSelector4iTM3:@selector(SWZ_iTM2ContextKit_canCloseDocumentWithDelegate:shouldCloseSelector:contextInfo:) error:NULL];
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
    [[SDC documents] makeObjectsPerformSelector:@selector(saveContext:) withObject:nil];
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
	if (MS)
	{
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
//LOG4iTM3(@"doc.fileURL.path is:%@, contextDictionary is:%#x", doc.fileURL.path, contextDictionary);
	[invocation autorelease];
	if (shouldClose)
	{
		[doc saveContext:self];
    }
	[invocation setArgument:&shouldClose atIndex:3];
	[invocation invoke];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  getContextValueForKey:domain:
- (id)getContextValueForKey:(NSString *)aKey domain:(NSUInteger)mask;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	// if there is no context value, looking in the general stuff for the file extension
	id result = nil;
	if (result = [super getContextValueForKey:aKey domain:mask&~iTM2ContextStandardDefaultsMask])
	{
		return result;
	}

	if (mask & iTM2ContextExtendedDefaultsMask)
	{
		NSString * contextKey = nil;
		NSDictionary * D = nil;
		NSString * type = self.fileType;
		if (type.length)
		{
			contextKey = [iTM2ContextTypesKey stringByAppendingPathExtension:type];
			D = [SUD dictionaryForKey:contextKey];
			if (result = [D objectForKey:aKey])
			{
				return result;
			}
		}
		NSString * type4URL = [SDC typeForContentsOfURL:self.fileURL error:NULL];
		if (type4URL.length && ![type4URL isEqualToUTType4iTM3:type])
		{
			contextKey = [iTM2ContextTypesKey stringByAppendingPathExtension:type4URL];
			D = [SUD dictionaryForKey:contextKey];
			if (result = [D objectForKey:aKey])
			{
				return result;
			}
		}
	}
	result = [super getContextValueForKey:aKey domain:mask];// debug design
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setContextValue:forKey:domain:
- (NSUInteger)setContextValue:(id)object forKey:(NSString *)aKey domain:(NSUInteger)mask;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSUInteger didChange = [super setContextValue:object forKey:aKey domain:mask];
	// Set the value in the user defaults data base with the file extension and document type
	if (mask & iTM2ContextExtendedDefaultsMask)
	{
		NSString * contextKey = nil;
		NSMutableDictionary * D = nil;
		NSString * type = self.fileType;
		id old = nil;
		if (type.length)
		{
			contextKey = [iTM2ContextTypesKey stringByAppendingPathExtension:type];
			D = [[[SUD dictionaryForKey:contextKey] mutableCopy] autorelease]?:[NSMutableDictionary dictionary];
			if (![old isEqual:object] && (old != object))
			{
				[D setValue:object forKey:aKey];
				[SUD setObject:D forKey:contextKey];
			}
		}
		NSString * type4URL = [SDC typeForContentsOfURL:self.fileURL error:NULL];
		if (type4URL.length && ![type4URL isEqualToUTType4iTM3:type])
		{
			contextKey = [iTM2ContextTypesKey stringByAppendingPathExtension:type4URL];
			D = [[[SUD dictionaryForKey:contextKey] mutableCopy] autorelease]?:[NSMutableDictionary dictionary];
			if (![old isEqual:object] && (old != object))
			{
				[D setValue:object forKey:aKey];
				[SUD setObject:D forKey:contextKey];
			}
		}
	}
	if (didChange)
	{
		self.notifyContextChange;
	}
//LOG4iTM3(@"self.contextDictionary is:%@", self.contextDictionary);
    return didChange;
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
    [self.windowControllers makeObjectsPerformSelector:@selector(saveContext:) withObject:sender];
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
    [self.windowControllers makeObjectsPerformSelector:@selector(loadContext:) withObject:sender];
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
	if ([self contextBoolForKey:@"iTM2NoAlertAfterFileOperationError" domain:iTM2ContextAllDomainsMask]
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
