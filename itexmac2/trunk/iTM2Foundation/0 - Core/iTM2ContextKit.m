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

NSString * const iTM2ContextDidChangeNotification = @"iTM2ContextDidChange";

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2ContextKit
/*"This object is used to store contextManager that might override some contextManager in a basic set of contextManager, typically the user defaults data base. It implements all the setters and getters of the NSUserDefaults instances. Beware when categories are created. All the setters really fill the contextManager, even if afterwards the values are the same in the contextManager and the base contextManager. This might be implemented in a different way driven by a flag. It is consistent now because the base contextManager are the user defaults data base: if those defaults are changed, the local contextManager are not.

When no basic contextManager are given on initialization time, the user defaults data base is used instead. The NSUserDefaults shared instance is cached.

Various categories are declared here, the NSDocument instances are the only object where contextManager are really stored, if ever."*/
@implementation NSObject(iTM2ContextKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  currentContextManager
- (id) currentContextManager;
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
- (id) contextManager;
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
- (void) setContextManager: (id) manager;
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
- (void) updateContextManager;
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
- (id) contextDictionary;
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
- (void) setContextDictionary: (id) dictionary;
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  contextValueForKey:
- (id) contextValueForKey: (NSString *) aKey;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id result = [[self contextDictionary] valueForKey:aKey];
	if(result)
		return result;
	id manager = [self contextManager];
	if(manager != self)
		result = [manager contextValueForKey:aKey];
	else
		result = [SUD contextValueForKey:aKey];
	if(iTM2DebugEnabled && !result)
	{
		iTM2_LOG(@"SUD is: %@", SUD);
	}
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeContextValue:forKey:
- (void) takeContextValue: (id) object forKey: (NSString *) aKey;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSAssert(aKey != nil, @"Unexpected nil aKey");
	if([self contextDictionary])
	{
		id old = [[self contextDictionary] valueForKey:aKey];
		if(![old isEqual:object])
		{
			[[self contextDictionary] takeValue:object forKey:aKey];
			[self contextDidChange];
		}
	}
	id contextManager = [self contextManager];
	if(contextManager && (self != contextManager))
		[contextManager takeContextValue:object forKey:aKey];
	else if(object)
		[SUD setObject:object forKey:aKey];
	else
		[SUD removeObjectForKey:aKey];
//iTM2_LOG(@"[self contextDictionary] is:%@", [self contextDictionary]);
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= contextFontForKey:
- (NSFont *) contextFontForKey: (NSString *) aKey;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [NSFont fontWithNameSizeDictionary:[self contextValueForKey:aKey]];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= takeContextFont:forKey:
- (void) takeContextFont: (NSFont *) aFont forKey: (NSString *) aKey;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self takeContextValue:[aFont nameSizeDictionary] forKey:aKey];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= contextColorForKey:
- (NSColor *) contextColorForKey: (NSString *) aKey;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [NSColor colorWithRGBADictionary:[self contextValueForKey:aKey]];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= takeContextColor:forKey:
- (void) takeContextColor: (NSColor *) aColor forKey: (NSString *) aKey;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self takeContextValue:[aColor RGBADictionary] forKey:aKey];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  contextStringForKey:
- (NSString *) contextStringForKey: (NSString *) key;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    id result = [self contextValueForKey:key];
    return [result isKindOfClass:[NSString class]]?
                result:
                    ([result respondsToSelector:@selector(stringValue)]? [result stringValue]:[NSString string]);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  contextArrayForKey:
- (NSArray *) contextArrayForKey: (NSString *) key;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    id result = [self contextValueForKey:key];
    return [result isKindOfClass:[NSArray class]]? result:nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  contextDictionaryForKey:
- (NSDictionary *) contextDictionaryForKey: (NSString *) key;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    id result = [self contextValueForKey:key];
    return [result isKindOfClass:[NSDictionary class]]? result:nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  contextDataForKey:
- (NSData *) contextDataForKey: (NSString *) key;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    id result = [self contextValueForKey:key];
    return [result isKindOfClass:[NSData class]]? result:nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  contextStringArrayForKey:
- (NSArray *) contextStringArrayForKey: (NSString *) key;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    BOOL OK = YES;
    id result = [self contextArrayForKey:key];
    NSMutableArray * MA = [NSMutableArray array];
    NSEnumerator * E = [result objectEnumerator];
    id object;
    while(object = [E nextObject])
        if([object isKindOfClass:[NSString class]])
            [MA addObject:object];
        else if([object respondsToSelector:@selector(stringValue)])
            [MA addObject:[object stringValue]];
        else
        {
            OK = NO;
            break;
        }
    return OK? result: nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  contextIntegerForKey:
- (int) contextIntegerForKey: (NSString *) key; 
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    id result = [self contextValueForKey:key];
    if((iTM2DebugEnabled > 100) && result && ![result respondsToSelector:@selector(intValue)])
    {
        iTM2_LOG(@"Weird defaults value for key: %@, got %@", key, result);
    }
    return [result respondsToSelector:@selector(intValue)]? [result intValue]:0;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  contextFloatForKey:
- (float) contextFloatForKey: (NSString *) key; 
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    id result = [self contextValueForKey:key];
    return [result respondsToSelector:@selector(floatValue)]? [result floatValue]:0;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  contextBoolForKey:
- (BOOL) contextBoolForKey: (NSString *) key;  
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    id result = [self contextValueForKey:key];
    return [result respondsToSelector:@selector(boolValue)]? [result boolValue]:NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeContextInteger:forKey:
- (void) takeContextInteger: (int) value forKey: (NSString *) key;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self takeContextValue:[NSNumber numberWithInt:value] forKey:key];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeContextFloat:forKey:
- (void) takeContextFloat: (float) value forKey: (NSString *) key;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self takeContextValue:[NSNumber numberWithFloat:value] forKey:key];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeContextBool:forKey:
- (void) takeContextBool: (BOOL) value forKey: (NSString *) key;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self takeContextValue:[NSNumber numberWithBool:value] forKey:key];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  saveContext:
- (void) saveContext: (id) sender;
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
- (void) awakeFromContext;
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
- (void) loadContext: (id) sender;
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  contextDidChange
- (void) contextDidChange;
/*"This message is sent each time the contextManager have changed.
The receiver will take appropriate actions to synchronize its state with its contextManager.
Subclasses will most certainly override this method because the default implementation does nothing.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[[self implementation] takeMetaValue:[NSNumber numberWithBool:YES] forKey:@"iTM2ContextRegistrationNeeded"];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  contextRegistrationNeeded
- (BOOL) contextRegistrationNeeded;
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
@end

@implementation NSWindowController(iTM2ContextKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  currentContextManager
- (id) currentContextManager;
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
- (void) windowControllerCompleteSaveContext: (id) sender;
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
- (id) currentContextManager;
/*"Returns the contextManager of its window controller.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START
    return [self windowController]?:[super currentContextManager];// delegate?
}
@end

#if 0
I am no sure this is a godd design idea
@implementation NSResponder(iTM2ContextKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  currentContextManager
- (id) currentContextManager;
/*"Returns the contextManager of its window.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START
    return (id)[[self nextResponder] contextManager]?:[super currentContextManager];
}
@end
#endif

@implementation NSView(iTM2ContextKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  currentContextManager
- (id) currentContextManager;
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
- (id) currentContextManager;
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
- (id) currentContextManager;
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
- (id) contextManager;
/*"Returns the contextManager of the first text view of its first layout manager.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.b0: 04/17/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START
    return SUD != self? SUD: nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  contextValueForKey:
- (id) contextValueForKey: (NSString *) aKey;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [self objectForKey:aKey];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeContextValue:forKey:
- (void) takeContextValue: (id) object forKey: (NSString *) aKey;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_LOG(@"[self takeContextValue:%@ forKey:%@]", object, aKey);
	if(object)
		[self setObject:object forKey:aKey];
	else
		[self removeObjectForKey:aKey];
    return;
}
@end

#import <objc/objc-runtime.h>
#import <objc/objc-class.h>

@interface NSDocument_iTM2ContextKit: NSDocument
@end

@implementation iTM2MainInstaller(iTM2ContextKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2ContextKitCompleteInstallation
+ (void) iTM2ContextKitCompleteInstallation;
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
+ (void) load;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
    iTM2_INIT_POOL;
//iTM2_START;
	[NSDocument_iTM2ContextKit poseAsClass:[NSDocument class]];
//iTM2_END;
	iTM2_RELEASE_POOL;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2ContextKitCompleteInstallation
+ (void) iTM2ContextKitCompleteInstallation;
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
+ (void) iTM2ContextKit_ApplicationWillTerminateNotified: (NSNotification *) notification;
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
- (void) canCloseDocumentWithDelegate: (id) delegate shouldCloseSelector: (SEL) shouldCloseSelector contextInfo: (void *) contextInfo;
/*"Description forthcoming.
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
- (void) _Context_document: (NSDocument *) doc shouldClose: (BOOL) shouldClose shouldCloseInvocation: (NSInvocation *) invocation;
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  contextValueForKey:
- (id) contextValueForKey: (NSString *) aKey;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	// if there is no context value, looking in the general stuff for the file extension
	id result = [[self contextDictionary] valueForKey:aKey];
	if(result)
		return result;
	if(([self contextManager] != self)
			&& ([self contextManager] != SUD)
				&& (result = [[self contextManager] contextValueForKey:aKey]))
			return result;
		
	NSString * extensionKey = [[self fileName] pathExtension];
	if([extensionKey length])
	{
		if(result = [[SUD dictionaryForKey:[iTM2ContextExtensionsKey stringByAppendingPathExtension:extensionKey]] objectForKey:aKey])
			return result;
		NSString * type = [SDC typeFromFileExtension:extensionKey];
		if([type length] && (result = [[SUD dictionaryForKey:[iTM2ContextTypesKey stringByAppendingPathExtension:type]] objectForKey:aKey]))
			return result;
	}
	NSString * type = [self fileType];
	if([type length] && (result = [[SUD dictionaryForKey:[iTM2ContextTypesKey stringByAppendingPathExtension:type]] objectForKey:aKey]))
		return result;
	// Finally, trying in the inherited behaviour
    return [super contextValueForKey:aKey];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeContextValue:forKey:
- (void) takeContextValue: (id) object forKey: (NSString *) aKey;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSParameterAssert(aKey != nil);
	[super takeContextValue:object forKey:aKey];
	// Set the value in the user defaults data base with the file extension
	NSString * extensionKey = [[self fileName] pathExtension];
	if([extensionKey length])
	{
		NSString * contextKey = [iTM2ContextExtensionsKey stringByAppendingPathExtension:extensionKey];
		NSDictionary * D = [[[SUD dictionaryForKey:contextKey] mutableCopy] autorelease]?:
			[NSMutableDictionary dictionary];
		[D takeValue:object forKey:aKey];
		[SUD setObject:D forKey:contextKey];
		NSString * type = [self fileType];
		if([type length])
		{
			contextKey = [iTM2ContextTypesKey stringByAppendingPathExtension:type];
			D = [[[SUD dictionaryForKey:contextKey] mutableCopy] autorelease]?:
					[NSMutableDictionary dictionary];
			[D takeValue:object forKey:aKey];
			[SUD setObject:D forKey:contextKey];
		}
		NSString * newType = [SDC typeFromFileExtension:extensionKey];
		if([newType length] && ![newType isEqual:type])
		{
			contextKey = [iTM2ContextTypesKey stringByAppendingPathExtension:newType];
			D = [[[SUD dictionaryForKey:contextKey] mutableCopy] autorelease]?:
				[NSMutableDictionary dictionary];
			[D takeValue:object forKey:aKey];
			[SUD setObject:D forKey:contextKey];
		}
	}
	else
	{
		NSString * contextKey = iTM2ContextExtensionsKey;
		NSDictionary * D = [[[SUD dictionaryForKey:contextKey] mutableCopy] autorelease]?:
			[NSMutableDictionary dictionary];
		[D takeValue:object forKey:aKey];
		[SUD setObject:D forKey:contextKey];
		NSString * type = [self fileType];
		if([type length])
		{
			contextKey = [iTM2ContextTypesKey stringByAppendingPathExtension:type];
			D = [[[SUD dictionaryForKey:contextKey] mutableCopy] autorelease]?:
					[NSMutableDictionary dictionary];
			[D takeValue:object forKey:aKey];
			[SUD setObject:D forKey:contextKey];
		}
	}
//iTM2_LOG(@"[self contextDictionary] is:%@", [self contextDictionary]);
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  documentCompleteSaveContext:
- (void) documentCompleteSaveContext: (id) sender;
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
- (void) documentCompleteLoadContext: (id) sender;
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
