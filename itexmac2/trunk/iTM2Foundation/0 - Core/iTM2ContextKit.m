/*
//
//  @version Subversion: $Id$ 
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


#import <iTM2Foundation/iTM2UserDefaultsKit.h>
#import <iTM2Foundation/iTM2ContextKit.h>
#import <iTM2Foundation/iTM2RuntimeBrowser.h>
#import <iTM2Foundation/iTM2InstallationKit.h>
#import <iTM2Foundation/iTM2Implementation.h>
#import <iTM2Foundation/iTM2BundleKit.h>

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
{iTM2_DIAGNOSTIC;
//iTM2_START;
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [self currentContextManager];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setContextManager:
- (void)setContextManager:(id)manager;
/*"Subclasses will most certainly override this method.
Default implementation returns the NSUserDefaults shared instance.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSAssert(NO, @"The default implementation does not set any context dictionary...");
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  contextValueForKey:domain:
- (id)contextValueForKey:(NSString *)aKey domain:(unsigned int)mask;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return [self getContextValueForKey:aKey domain:mask];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  getContextValueForKey:domain:
- (id)getContextValueForKey:(NSString *)aKey domain:(unsigned int)mask;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id result = nil;
	if(mask & iTM2ContextStandardLocalMask)
	{
		NSDictionary * D = [self contextDictionary];
		if(result = [D valueForKey:aKey])
		{
			return result;
		}
		id contextManager = [self contextManager];
		if((self != contextManager && SUD != contextManager) && (result = [contextManager contextValueForKey:aKey domain:mask]))
		{
			return result;
		}
	}
	if(mask & iTM2ContextDefaultsMask)
	{
		result = [SUD contextValueForKey:aKey domain:mask];
	}
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeContextValue:forKey:domain:
- (unsigned int)takeContextValue:(id)object forKey:(NSString *)aKey domain:(unsigned int)mask;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_LOG(@"[self contextDictionary] is:%@", [self contextDictionary]);
	unsigned int didChange = [self setContextValue:object forKey:aKey domain:mask];
	if(didChange)
	{
		id afterObject = [self contextValueForKey:aKey domain:mask];
	//iTM2_LOG(@"afterObject:%@",afterObject);
		if([object isEqual:afterObject] || (object == afterObject))
		{
			return YES;
		}
		if((didChange &= ~iTM2ContextNoContextMask) && (iTM2DebugEnabled>100))
		{
			iTM2_LOG(@"object:%@ <> afterObject %@", object,afterObject);
		}
	}
    return didChange;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setContextValue:forKey:domain:
- (unsigned int)setContextValue:(id)object forKey:(NSString *)aKey domain:(unsigned int)mask;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSAssert(aKey != nil, @"Unexpected nil aKey");
	unsigned int didChange = iTM2ContextNoContextMask;
	if(mask & iTM2ContextStandardLocalMask)
	{
		NSDictionary * D = [self contextDictionary];
		id contextManager = [self contextManager];
		if(D)
		{
			didChange = 0;
			id old = [D valueForKey:aKey];
			if(![old isEqual:object])
			{
				[D takeValue:object forKey:aKey];
				didChange |= iTM2ContextStandardLocalMask;
			}
		}
		if(contextManager && self != contextManager && SUD != contextManager)
		{
			didChange &= ~iTM2ContextNoContextMask;
			didChange |= [contextManager takeContextValue:object forKey:aKey domain:mask];
		}
	}
	if(mask & iTM2ContextDefaultsMask)
	{
		didChange &= ~iTM2ContextNoContextMask;
		didChange |= [SUD takeContextValue:object forKey:aKey domain:mask];
	}
	if(didChange &= ~iTM2ContextNoContextMask)
	{
		[self notifyContextChange];
	}
//iTM2_LOG(@"[self contextDictionary] is:%@", [self contextDictionary]);
    return didChange;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= contextFontForKey:domain:
- (NSFont *)contextFontForKey:(NSString *)aKey domain:(unsigned int)mask;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSDictionary * D = [self contextValueForKey:aKey domain:mask];
//iTM2_END;
    return [NSFont fontWithNameSizeDictionary:D];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= takeContextFont:forKey:domain:
- (void)takeContextFont:(NSFont *)aFont forKey:(NSString *)aKey domain:(unsigned int)mask;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSDictionary * D = [aFont nameSizeDictionary];
    [self takeContextValue:D forKey:aKey domain:mask];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= contextColorForKey:domain:
- (NSColor *)contextColorForKey:(NSString *)aKey domain:(unsigned int)mask;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSDictionary * D = [self contextValueForKey:aKey domain:mask];
//iTM2_END;
    return [NSColor colorWithRGBADictionary:D];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= takeContextColor:forKey:domain:
- (void)takeContextColor:(NSColor *)aColor forKey:(NSString *)aKey domain:(unsigned int)mask;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSDictionary * D = [aColor RGBADictionary];
    [self takeContextValue:D forKey:aKey domain:mask];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  contextStringForKey:domain:
- (NSString *)contextStringForKey:(NSString *)aKey domain:(unsigned int)mask;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id result = nil;
	if(mask & iTM2ContextStandardLocalMask)
	{
		NSDictionary * D = [self contextDictionary];
		if(result = [D valueForKey:aKey])
		{
			if([result isKindOfClass:[NSString class]])
			{
				return result;
			}
			if([result respondsToSelector:@selector(stringValue)])
			{
				return [result stringValue];
			}
		}
		id contextManager = [self contextManager];
		if((contextManager != self) && (contextManager != SUD)
			&& (result = [contextManager contextStringForKey:aKey domain:mask]))
		{
			return result;
		}
	}
	result = [SUD contextStringForKey:aKey domain:mask];
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  contextArrayForKey:domain:
- (NSArray *)contextArrayForKey:(NSString *)aKey domain:(unsigned int)mask;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id result = nil;
	if(mask & iTM2ContextStandardLocalMask)
	{
		if(result = [[self contextDictionary] valueForKey:aKey])
		{
			if([result isKindOfClass:[NSArray class]])
			{
				return result;
			}
		}
		id contextManager = [self contextManager];
		if((contextManager != self) && (contextManager != SUD)
			&& (result = [contextManager contextArrayForKey:aKey domain:mask]))
		{
			return result;
		}
	}
	result = [SUD contextArrayForKey:aKey domain:mask];
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  contextDictionaryForKey:domain:
- (NSDictionary *)contextDictionaryForKey:(NSString *)aKey domain:(unsigned int)mask;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id result = nil;
	if(mask & iTM2ContextStandardLocalMask)
	{
		if(result = [[self contextDictionary] valueForKey:aKey])
		{
			if([result isKindOfClass:[NSDictionary class]])
			{
				return result;
			}
		}
		id contextManager = [self contextManager];
		if((contextManager != self) && (contextManager != SUD)
			&& (result = [contextManager contextDictionaryForKey:aKey domain:mask]))
		{
			return result;
		}
	}
	result = [SUD contextDictionaryForKey:aKey domain:mask];
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  contextDataForKey:domain:
- (NSData *)contextDataForKey:(NSString *)aKey domain:(unsigned int)mask;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id result = nil;
	if(mask & iTM2ContextStandardLocalMask)
	{
		if(result = [[self contextDictionary] valueForKey:aKey])
		{
			if([result isKindOfClass:[NSData class]])
			{
				return result;
			}
		}
		id contextManager = [self contextManager];
		if((contextManager != self) && (contextManager != SUD)
			&& (result = [contextManager contextDataForKey:aKey domain:mask]))
		{
			return result;
		}
	}
	result = [SUD contextDataForKey:aKey domain:mask];
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  contextStringArrayForKey:domain:
- (NSArray *)contextStringArrayForKey:(NSString *)aKey domain:(unsigned int)mask;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id result = nil;
	if(mask & iTM2ContextStandardLocalMask)
	{
		NSEnumerator * E;
		NSString * S;
		if(result = [[self contextDictionary] valueForKey:aKey])
		{
			if([result isKindOfClass:[NSArray class]])
			{
				if([result count])
				{
					E = [result objectEnumerator];
					while(S = [E nextObject])
					{
						if(![S isKindOfClass:[NSString class]])
						{
							goto next;
						}
					}
				}
				return result;
			}
		}
next:;
		id contextManager = [self contextManager];
		if((contextManager != self) && (contextManager != SUD)
			&& (result = [contextManager contextStringArrayForKey:aKey domain:mask]))
		{
			return result;
		}
	}
	result = [SUD contextStringArrayForKey:aKey domain:mask];
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  contextIntegerForKey:domain:
- (int)contextIntegerForKey:(NSString *)aKey domain:(unsigned int)mask; 
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id value = nil;
	if(mask & iTM2ContextStandardLocalMask)
	{
		if(value = [[self contextDictionary] valueForKey:aKey])
		{
			if([value respondsToSelector:@selector(intValue)])
			{
				return [value intValue];
			}
		}
		id contextManager = [self contextManager];
		if((contextManager != self) && (contextManager != SUD)
			&& (value = [contextManager contextValueForKey:aKey domain:mask])
				&&([value respondsToSelector:@selector(intValue)]))
		{
			return [value intValue];
		}
	}
	int result = [SUD contextIntegerForKey:aKey domain:mask];
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  contextFloatForKey:domain:
- (float)contextFloatForKey:(NSString *)aKey domain:(unsigned int)mask; 
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id value = nil;
	if(mask & iTM2ContextStandardLocalMask)
	{
		if(value = [[self contextDictionary] valueForKey:aKey])
		{
			if([value respondsToSelector:@selector(floatValue)])
			{
				return [value floatValue];
			}
		}
		id contextManager = [self contextManager];
		if((contextManager != self) && (contextManager != SUD)
			&& (value = [contextManager contextValueForKey:aKey domain:mask])
				&& [value respondsToSelector:@selector(floatValue)])
		{
			return [value floatValue];
		}
	}
	float result = [SUD contextFloatForKey:aKey domain:mask];
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  contextBoolForKey:domain:
- (BOOL)contextBoolForKey:(NSString *)aKey domain:(unsigned int)mask;  
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id value = nil;
	if(mask & iTM2ContextStandardLocalMask)
	{
		NSDictionary * D = [self contextDictionary];
		if((value = [D valueForKey:aKey])
			&& [value respondsToSelector:@selector(boolValue)])
		{
			return [value boolValue];
		}
		id contextManager = [self contextManager];
		if((contextManager != self) && (contextManager != SUD)
			&& (value = [contextManager contextValueForKey:aKey domain:mask])
				&& [value respondsToSelector:@selector(boolValue)])
		{
			return [value boolValue];
		}
	}
	BOOL result = [SUD contextBoolForKey:aKey domain:mask];
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeContextInteger:forKey:domain:
- (void)takeContextInteger:(int)value forKey:(NSString *)aKey domain:(unsigned int)mask;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self takeContextValue:[NSNumber numberWithInt:value] forKey:aKey domain:mask];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeContextFloat:forKey:domain:
- (void)takeContextFloat:(float)value forKey:(NSString *)aKey domain:(unsigned int)mask;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self takeContextValue:[NSNumber numberWithFloat:value] forKey:aKey domain:mask];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeContextBool:forKey:domain:
- (void)takeContextBool:(BOOL)value forKey:(NSString *)aKey domain:(unsigned int)mask;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSMethodSignature * sig0 = [self methodSignatureForSelector:_cmd];
    NSInvocation * I = [NSInvocation invocationWithMethodSignature:sig0];
    [I setTarget:self];
	[I setArgument:&sender atIndex:2];
    NSEnumerator * E = [[iTM2RuntimeBrowser instanceSelectorsOfClass:[self class] withSuffix:@"CompleteSaveContext:" signature:sig0 inherited:YES] objectEnumerator];
    SEL selector;
    while(selector = (SEL)[[E nextObject] pointerValue])
    {
		if(iTM2DebugEnabled)
		{
			iTM2_LOG(@"Soon entering: %@,\n%@", NSStringFromSelector(selector), [self contextDictionary]);
		}
        [I setSelector:selector];
        [I invoke];
		if(iTM2DebugEnabled)
		{
			iTM2_LOG(@"Done: %@,\n%@", NSStringFromSelector(selector), [self contextDictionary]);
		}
    }
	[SUD synchronize];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  awakeFromContext:
- (void)awakeFromContext;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  loadContext:
- (void)loadContext:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSMethodSignature * sig0 = [self methodSignatureForSelector:_cmd];
    NSInvocation * I = [NSInvocation invocationWithMethodSignature:sig0];
    [I setTarget:self];
	[I setArgument:&sender atIndex:2];
    NSEnumerator * E = [[iTM2RuntimeBrowser instanceSelectorsOfClass:[self class] withSuffix:@"CompleteLoadContext:" signature:sig0 inherited:YES] objectEnumerator];
    SEL selector;
    while(selector = (SEL)[[E nextObject] pointerValue])
    {
        [I setSelector:selector];
        [I invoke];
    }
//iTM2_END;
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(contextDidChange) object:nil];
	[[self implementation] takeMetaValue:nil forKey:@"iTM2ContextRegistrationNeeded"];
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[[self implementation] takeMetaValue:[NSNumber numberWithBool:YES] forKey:@"iTM2ContextRegistrationNeeded"];
	[[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(contextDidChange) object:nil];
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [[[self implementation] metaValueForKey:@"iTM2ContextRegistrationNeeded"] boolValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  contextStateForKey:
- (unsigned int)contextStateForKey:(NSString *)aKey;  
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([self contextBoolForKey:aKey domain:iTM2ContextPrivateMask])
	{
		return NSOnState;
	}
	if([self contextValueForKey:aKey domain:iTM2ContextPrivateMask])
	{
		return NSOffState;
	}
	if([self contextBoolForKey:aKey domain:iTM2ContextAllDomainsMask])
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([self contextBoolForKey:aKey domain:iTM2ContextPrivateMask])
	{
		if([self contextBoolForKey:aKey domain:iTM2ContextAllDomainsMask&~iTM2ContextPrivateMask])
		{
			[self takeContextBool:NO forKey:aKey domain:iTM2ContextPrivateMask];
			return;
		}
		[self takeContextValue:nil forKey:aKey domain:iTM2ContextPrivateMask];
		return;
	}
	if([self contextBoolForKey:aKey domain:iTM2ContextAllDomainsMask&~iTM2ContextPrivateMask])
	{
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
{iTM2_DIAGNOSTIC;
//iTM2_START
    return [self document]?:[super currentContextManager];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  windowControllerCompleteSaveContext:
- (void)windowControllerCompleteSaveContext:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [[self window] saveContext:sender];
//iTM2_END;
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
{iTM2_DIAGNOSTIC;
//iTM2_START
	id delegate = [self delegate];
	if(delegate)
	{
		return delegate;
	}
	NSWindowController * windowController = [self windowController];
	if(windowController)
	{
		return windowController;
	}
	NSWindow * parentWindow = [self parentWindow];
	if(parentWindow)
	{
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
{iTM2_DIAGNOSTIC;
//iTM2_START
    return (id)[self nextResponder]?:[super currentContextManager];
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
{iTM2_DIAGNOSTIC;
//iTM2_START
    return (id)[self superview]?:(id)[self window];
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
{iTM2_DIAGNOSTIC;
//iTM2_START
    return [[[self layoutManagers] lastObject] firstTextView];
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
{iTM2_DIAGNOSTIC;
//iTM2_START
    return [self firstTextView];
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
{iTM2_DIAGNOSTIC;
//iTM2_START
    return SUD != self? SUD: nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  contextValueForKey:domain:
- (id)contextValueForKey:(NSString *)aKey domain:(unsigned int)mask;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return (mask & iTM2ContextDefaultsMask)?[self objectForKey:aKey]: nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setContextValue:forKey:domain:
- (unsigned int)setContextValue:(id)object forKey:(NSString *)aKey domain:(unsigned int)mask;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_LOG(@"[self takeContextValue:%@ forKey:%@]", object, aKey);
	NSParameterAssert((aKey != nil));
	if(mask & iTM2ContextDefaultsMask)
	{
		id old = [self objectForKey:aKey];
		if(![old isEqual:object] && (old != object))
		{
			if(object)
			{
				[self setObject:object forKey:aKey];
			}
			else
			{
				[self removeObjectForKey:aKey];
			}
			return iTM2ContextDefaultsMask;
		}
	}
    return 0;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  contextStringForKey:domain:
- (NSString *)contextStringForKey:(NSString *)aKey domain:(unsigned int)mask;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return mask & iTM2ContextStandardDefaultsMask?[self stringForKey:aKey]:nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  contextArrayForKey:domain:
- (NSArray *)contextArrayForKey:(NSString *)aKey domain:(unsigned int)mask;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return mask & iTM2ContextStandardDefaultsMask?[self arrayForKey:aKey]:nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  contextDictionaryForKey:domain:
- (NSDictionary *)contextDictionaryForKey:(NSString *)aKey domain:(unsigned int)mask;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return mask & iTM2ContextStandardDefaultsMask?[self dictionaryForKey:aKey]:nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  contextDataForKey:domain:
- (NSData *)contextDataForKey:(NSString *)aKey domain:(unsigned int)mask;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return mask & iTM2ContextStandardDefaultsMask?[self dataForKey:aKey]:nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  contextStringArrayForKey:domain:
- (NSArray *)contextStringArrayForKey:(NSString *)aKey domain:(unsigned int)mask;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return mask & iTM2ContextStandardDefaultsMask?[self stringArrayForKey:aKey]:nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  contextIntegerForKey:domain:
- (int)contextIntegerForKey:(NSString *)aKey domain:(unsigned int)mask; 
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return mask & iTM2ContextStandardDefaultsMask?[self integerForKey:aKey]:0;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  contextFloatForKey:domain:
- (float)contextFloatForKey:(NSString *)aKey domain:(unsigned int)mask; 
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return mask & iTM2ContextStandardDefaultsMask?[self floatForKey:aKey]:0.0;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  contextBoolForKey:domain:
- (BOOL)contextBoolForKey:(NSString *)aKey domain:(unsigned int)mask;  
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return mask & iTM2ContextStandardDefaultsMask?[self boolForKey:aKey]:NO;
}
@end

#import <objc/objc-runtime.h>
#import <objc/objc-class.h>

@interface NSDocument_iTM2ContextKit: NSDocument
@end

@implementation iTM2MainInstaller(iTM2ContextKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2ContextKitCompleteInstallation
+ (void)iTM2ContextKitCompleteInstallation;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [DNC addObserver:[NSDocument_iTM2ContextKit class] selector:@selector(iTM2ContextKit_ApplicationWillTerminateNotified:) name:NSApplicationWillTerminateNotification object:nil];
//iTM2_END;
    return;
}
@end

@implementation NSDocument_iTM2ContextKit
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  load
+ (void)load;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
    iTM2_INIT_POOL;
	iTM2RedirectNSLogOutput();
//iTM2_START;
	[NSDocument_iTM2ContextKit poseAsClass:[NSDocument class]];
//iTM2_END;
	iTM2_RELEASE_POOL;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2ContextKitCompleteInstallation
+ (void)iTM2ContextKitCompleteInstallation;// never called
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [DNC addObserver:self selector:@selector(iTM2ContextKit_ApplicationWillTerminateNotified:) name:NSApplicationWillTerminateNotification object:nil];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2ContextKit_ApplicationWillTerminateNotified:
+ (void)iTM2ContextKit_ApplicationWillTerminateNotified:(NSNotification *)notification;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [[SDC documents] makeObjectsPerformSelector:@selector(saveContext:) withObject:nil];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= canCloseDocumentWithDelegate:shouldCloseSelector:contextInfo:
- (void)canCloseDocumentWithDelegate:(id)delegate shouldCloseSelector:(SEL)shouldCloseSelector contextInfo:(void *)contextInfo;
/*"Description forthcoming. To ensure the context is properly saved
Version history: jlaurens AT users DOT sourceforge DOT net (10/04/2001)
- 1.4: Fri Apr 16 11:39:43 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_LOG(@"delegate is: %@, shouldCloseSelector is: %@, contextInfo is: %#x", delegate, NSStringFromSelector(shouldCloseSelector), contextInfo);
 	NSMethodSignature * MS = [delegate methodSignatureForSelector:shouldCloseSelector];
	if(MS)
	{
		NSInvocation * I = [NSInvocation invocationWithMethodSignature:MS];
		[I retainArguments];
		[I setArgument:&self atIndex:2];
		[I setTarget:delegate];
		[I setSelector:shouldCloseSelector];
		if(contextInfo)
			[I setArgument:&contextInfo atIndex:4];
		[super canCloseDocumentWithDelegate:self shouldCloseSelector:@selector(_Context_document:shouldClose:shouldCloseInvocation:) contextInfo:[I retain]];
//iTM2_END;
		return;
	}
	iTM2_LOG(@"A delegate is expected to implement a should close selector:\ndelegate; %@\nselector: %@", delegate, NSStringFromSelector(shouldCloseSelector));
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  _Context_document:shouldClose:shouldCloseInvocation:
- (void)_Context_document:(NSDocument *)doc shouldClose:(BOOL)shouldClose shouldCloseInvocation:(NSInvocation *)invocation;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Mon Mar 15 13:59:04 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_LOG(@"[doc fileName] is:%@, contextDictionary is:%#x", [doc fileName], contextDictionary);
	[invocation autorelease];
	if(shouldClose)
	{
		[doc saveContext:self];
    }
	[invocation setArgument:&shouldClose atIndex:3];
	[invocation invoke];
//iTM2_END;
    return;
}
@end

NSString * const iTM2ContextExtensionsKey = @"iTM2ContextExtensions";
NSString * const iTM2ContextTypesKey = @"iTM2ContextTypes";

@implementation NSDocument(iTM2ContextKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  getContextValueForKey:domain:
- (id)getContextValueForKey:(NSString *)aKey domain:(unsigned int)mask;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	// if there is no context value, looking in the general stuff for the file extension
	id result = nil;
	if(result = [super getContextValueForKey:aKey domain:mask&~iTM2ContextStandardDefaultsMask])
	{
		return result;
	}

	if(mask & iTM2ContextExtendedDefaultsMask)
	{
		NSString * extensionKey = [[self fileName] pathExtension];
		NSString * contextKey = nil;
		NSDictionary * D = nil;
		if([extensionKey length])
		{
			contextKey = [iTM2ContextExtensionsKey stringByAppendingPathExtension:extensionKey];
			D = [SUD dictionaryForKey:contextKey];
			if(result = [D objectForKey:aKey])
			{
				return result;
			}
		}
		NSString * type = [self fileType];
		if([type length])
		{
			contextKey = [iTM2ContextTypesKey stringByAppendingPathExtension:type];
			D = [SUD dictionaryForKey:contextKey];
			if(result = [D objectForKey:aKey])
			{
				return result;
			}
		}
		NSString * typeFromFileExtension = [SDC typeFromFileExtension:extensionKey];
		if([typeFromFileExtension length] && ![typeFromFileExtension isEqual:type])
		{
			contextKey = [iTM2ContextTypesKey stringByAppendingPathExtension:typeFromFileExtension];
			D = [SUD dictionaryForKey:contextKey];
			if(result = [D objectForKey:aKey])
			{
				return result;
			}
		}
	}
	result = [super getContextValueForKey:aKey domain:mask];// debug design
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setContextValue:forKey:domain:
- (unsigned int)setContextValue:(id)object forKey:(NSString *)aKey domain:(unsigned int)mask;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	unsigned int didChange = [super setContextValue:object forKey:aKey domain:mask];
	// Set the value in the user defaults data base with the file extension and document type
	if(mask & iTM2ContextExtendedDefaultsMask)
	{
		NSString * contextKey = nil;
		NSMutableDictionary * D = nil;
		NSString * fileName = [self fileName];
		NSString * extensionKey = [fileName pathExtension];
		id old = nil;
		if([extensionKey length])
		{
			contextKey = [iTM2ContextExtensionsKey stringByAppendingPathExtension:extensionKey];
			D = [[[SUD dictionaryForKey:contextKey] mutableCopy] autorelease]?:[NSMutableDictionary dictionary];
			old = [D objectForKey:aKey];
			if(![old isEqual:object] && (old != object))
			{
				[D takeValue:object forKey:aKey];
				[SUD setObject:D forKey:contextKey];
			}
		}
		NSString * type = [self fileType];
		if([type length])
		{
			contextKey = [iTM2ContextTypesKey stringByAppendingPathExtension:type];
			D = [[[SUD dictionaryForKey:contextKey] mutableCopy] autorelease]?:[NSMutableDictionary dictionary];
			if(![old isEqual:object] && (old != object))
			{
				[D takeValue:object forKey:aKey];
				[SUD setObject:D forKey:contextKey];
			}
		}
		NSString * typeFromFileExtension = [SDC typeFromFileExtension:extensionKey];
		if([typeFromFileExtension length] && ![typeFromFileExtension isEqual:type])
		{
			contextKey = [iTM2ContextTypesKey stringByAppendingPathExtension:typeFromFileExtension];
			D = [[[SUD dictionaryForKey:contextKey] mutableCopy] autorelease]?:[NSMutableDictionary dictionary];
			if(![old isEqual:object] && (old != object))
			{
				[D takeValue:object forKey:aKey];
				[SUD setObject:D forKey:contextKey];
			}
		}
	}
	if(didChange)
	{
		[self notifyContextChange];
	}
//iTM2_LOG(@"[self contextDictionary] is:%@", [self contextDictionary]);
    return didChange;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  documentCompleteSaveContext:
- (void)documentCompleteSaveContext:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [[self windowControllers] makeObjectsPerformSelector:@selector(saveContext:) withObject:sender];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  documentCompleteLoadContext:
- (void)documentCompleteLoadContext:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [[self windowControllers] makeObjectsPerformSelector:@selector(loadContext:) withObject:sender];
//iTM2_END;
    return;
}
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2ContextKit
