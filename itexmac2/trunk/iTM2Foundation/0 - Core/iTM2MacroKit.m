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

#import <iTM2Foundation/iTM2MacroKit.h>
#import <iTM2Foundation/iTM2ContextKit.h>
#import <iTM2Foundation/iTM2MenuKit.h>
#import <iTM2Foundation/iTM2InheritanceKit.h>
#import <iTM2Foundation/iTM2BundleKit.h>

NSString * const iTM2MacroDomainKey = @"iTM2MacroDomain";
NSString * const iTM2MacroCategoryKey = @"iTM2MacroCategory";
NSString * const iTM2MacroContextKey = @"iTM2MacroContext";
NSString * const iTM2MacroScriptsComponent = @"Scripts.localized";

@implementation NSObject(_iTM2MacroKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= macroDomainKey
- (NSString *)macroDomainKey;
{
    return iTM2MacroDomainKey;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= defaultMacroDomain
- (NSString *)defaultMacroDomain;
{
    return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= macroDomain
- (NSString *)macroDomain;
{
	NSString * result = @"";
	NSString * key = [self macroDomainKey];
	if([key length])
	{
		result = [self contextStringForKey:key domain:iTM2ContextPrivateMask];
		if([result length])
		{
			return result;
		}
		result = [self inheritedValueForKey:@"defaultMacroDomain"];
		if(![result length])
		{
			result = [self contextStringForKey:key domain:iTM2ContextAllDomainsMask]?:@"";
		}
		[self setMacroDomain:result];
	}
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= setMacroDomain:
- (void)setMacroDomain:(NSString *)argument;
{
	argument = [argument description];
	NSString * key = [self macroDomainKey];
	NSString * old = [self contextStringForKey:key domain:iTM2ContextPrivateMask];
	if(![old isEqual:argument])
	{
		[self willChangeValueForKey:@"macroDomain"];
		[self takeContextValue:argument forKey:key domain:iTM2ContextPrivateMask|iTM2ContextExtendedProjectMask];
		[self didChangeValueForKey:@"macroDomain"];
	}
    return;
}//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= macroCategoryKey
- (NSString *)macroCategoryKey;
{
    return iTM2MacroCategoryKey;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= defaultMacroCategory
- (NSString *)defaultMacroCategory;
{
    return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= macroCategory
- (NSString *)macroCategory;
{
	NSString * result = @"";
	NSString * key = [self macroCategoryKey];
	if([key length])
	{
		result = [self contextStringForKey:key domain:iTM2ContextPrivateMask];
		if([result length])
		{
			return result;
		}
		result = [self inheritedValueForKey:@"defaultMacroCategory"];
		if(![result length])
		{
			result = [self contextStringForKey:key domain:iTM2ContextAllDomainsMask]?:@"";
		}
		if(![result length])
		{
			result = @"?";// reentrant code management
		}
		[self setMacroCategory:result];
	}
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= setMacroCategory:
- (void)setMacroCategory:(NSString *)argument;
{
	NSString * key = [self macroCategoryKey];
	argument = [argument description];
	NSString * old = [self contextStringForKey:key domain:iTM2ContextPrivateMask];
	if([old isEqual:argument])
	{
		return;
	}
	[self willChangeValueForKey:@"macroCategory"];
	[self takeContextValue:argument forKey:key domain:iTM2ContextPrivateMask|iTM2ContextExtendedProjectMask];
	[self didChangeValueForKey:@"macroCategory"];
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= macroContextKey
- (NSString *)macroContextKey;
{
    return iTM2MacroContextKey;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= defaultMacroContext
- (NSString *)defaultMacroContext;
{
    return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= macroContext
- (NSString *)macroContext;
{
	NSString * result = @"";
	NSString * key = [self macroContextKey];
	if([key length])
	{
		result = [self contextStringForKey:key domain:iTM2ContextPrivateMask];
		if([result length])
		{
			return result;
		}
		result = [self inheritedValueForKey:@"defaultMacroContext"];
		if(![result length])
		{
			result = [self contextStringForKey:key domain:iTM2ContextAllDomainsMask]?:@"";
		}
		[self setMacroContext:result];
	}
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= setMacroContext:
- (void)setMacroContext:(NSString *)argument;
{
	argument = [argument description];
	NSString * key = [self macroContextKey];
	NSString * old = [self contextStringForKey:key domain:iTM2ContextPrivateMask];
	if(![old isEqual:argument])
	{
		[self willChangeValueForKey:@"macroEditor"];
		[self takeContextValue:argument forKey:key domain:iTM2ContextPrivateMask|iTM2ContextExtendedProjectMask];
		[self setValue:nil forKey:@"macroEditor_meta"];
		[self didChangeValueForKey:@"macroEditor"];
	}
    return;
}
@end

@implementation NSView(iTM2MacroKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= macroDomainKey
- (NSString *)macroDomainKey;
{
    return [self superview]?[[self superview] macroDomainKey]:[[self window] macroDomainKey];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= macroCategoryKey
- (NSString *)macroCategoryKey;
{
    return [self superview]?[[self superview] macroCategoryKey]:([[self nextResponder] macroCategoryKey]?:[[self window] macroCategoryKey]);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= setMacroCategory:
- (void)setMacroCategory:(NSString *)argument;
{
	NSString * key = [self macroCategoryKey];
	NSString * old = [self contextStringForKey:key domain:iTM2ContextPrivateMask];
	if([old isEqual:argument])
	{
		return;
	}
	id superview = [self superview];
	if(superview)
	{
		[superview setMacroCategory:argument];
	}
	else
	{
		id window = [self window];
		if(window)
		{
			[window setMacroCategory:argument];
		}
	}
	[super setMacroCategory:argument];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= macroContextKey
- (NSString *)macroContextKey;
{
    return [self superview]?[[self superview] macroContextKey]:[[self window] macroContextKey];
}
@end

@implementation NSWindow(iTM2MacroKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= macroDomainKey
- (NSString *)macroDomainKey;
{
    return [self delegate]?[[self delegate] macroDomainKey]:([self windowController]?[[self windowController] macroDomainKey]:[super macroDomainKey]);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= macroCategoryKey
- (NSString *)macroCategoryKey;
{
    return [self delegate]?[[self delegate] macroCategoryKey]:([self windowController]?[[self windowController] macroCategoryKey]:[super macroCategoryKey]);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= setMacroCategory:
- (void)setMacroCategory:(NSString *)argument;
{
	NSString * key = [self macroCategoryKey];
	NSString * old = [self contextStringForKey:key domain:iTM2ContextPrivateMask];
	if([old isEqual:argument])
	{
		return;
	}
	id delegate = [self delegate];
	if(delegate)
	{
		[delegate setMacroCategory:argument];
	}
	id windowController = [self windowController];
	if(windowController)
	{
		[windowController setMacroCategory:argument];
	}
	[super setMacroCategory:argument];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= macroContextKey
- (NSString *)macroContextKey;
{
    return [self delegate]?[[self delegate] macroContextKey]:([self windowController]?[[self windowController] macroContextKey]:[super macroContextKey]);
}
@end

@implementation NSWindowController(iTM2MacroKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= macroDomainKey
- (NSString *)macroDomainKey;
{
    return [self document]?[[self document] macroDomainKey]:[super macroDomainKey];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= macroCategoryKey
- (NSString *)macroCategoryKey;
{
    return [self document]?[[self document] macroCategoryKey]:[super macroCategoryKey];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= setMacroCategory:
- (void)setMacroCategory:(NSString *)argument;
{
	NSString * key = [self macroCategoryKey];
	NSString * old = [self contextStringForKey:key domain:iTM2ContextPrivateMask];
	if([old isEqual:argument])
	{
		return;
	}
	id document = [self document];
	if(document)
	{
		[document setMacroCategory:argument];
	}
	[super setMacroCategory:argument];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= macroContextKey
- (NSString *)macroContextKey;
{
    return [self document]?[[self document] macroContextKey]:[super macroContextKey];
}
@end

@interface NSResponder(iTM2MacroKit_)
- (void)resetKeyBindingsManager;
@end

NSString * const iTM2DontUseSmartMacrosKey = @"iTM2DontUseSmartMacros";

#import <iTM2Foundation/iTM2PreferencesKit.h>

@implementation NSResponder(iTM2MacroKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleSmartMacros:
- (IBAction)toggleSmartMacros:(id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Jan 18 22:21:11 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    BOOL old = [self contextBoolForKey:iTM2DontUseSmartMacrosKey domain:iTM2ContextAllDomainsMask];
    [self takeContextBool:!old forKey:iTM2DontUseSmartMacrosKey domain:iTM2ContextPrivateMask|iTM2ContextProjectMask];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleSmartMacros:
- (BOOL)validateToggleSmartMacros:(id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Jan 18 22:21:11 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setState:([self contextBoolForKey:iTM2DontUseSmartMacrosKey domain:iTM2ContextAllDomainsMask]? NSOnState:NSOffState)];
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= takeMacroModeFromRepresentedObject:
- (IBAction)takeMacroModeFromRepresentedObject:(id)sender;
{
	id newMode = [sender representedString];
	if(newMode)
	{
		[self setMacroCategory:newMode];
	}
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= validateTakeMacroModeFromRepresentedObject:
- (BOOL)validateTakeMacroModeFromRepresentedObject:(id)sender;
{
	NSString * representedMode = [sender representedString];
	NSString * currentMode = [self macroCategory];
	[sender setState:([currentMode isEqual:representedMode]?NSOnState:NSOffState)];
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  macroEdit:
- (IBAction)macroEdit:(id)sender;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Sun Nov  5 16:57:31 GMT 2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[[iTM2PrefsController sharedPrefsController] displayPrefsPaneWithIdentifier:@"3.Macro"];
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= macroDomainKey
- (NSString *)macroDomainKey;
{
    return [self nextResponder]?[[self nextResponder] macroDomainKey]:[super macroDomainKey];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= macroCategoryKey
- (NSString *)macroCategoryKey;
{
    return [self nextResponder]?[[self nextResponder] macroCategoryKey]:[super macroCategoryKey];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= setMacroCategory:
- (void)setMacroCategory:(NSString *)argument;
{
	NSString * key = [self macroCategoryKey];
	NSString * old = [self contextStringForKey:key domain:iTM2ContextPrivateMask];
	if([old isEqual:argument])
	{
		return;
	}
	id nextResponder = [self nextResponder];
	if(nextResponder)
	{
		[nextResponder setMacroCategory:argument];
	}
	[super setMacroCategory:argument];
	// reentrant management
	id new = [self contextStringForKey:key domain:iTM2ContextPrivateMask];
	if([old isEqual:new])
	{
		return;
	}
	if(old == new)
	{
		return;
	}
	[self resetKeyBindingsManager];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= macroContextKey
- (NSString *)macroContextKey;
{
    return [self nextResponder]?[[self nextResponder] macroContextKey]:[super macroContextKey];
}
@end

@interface _iTM2KeyCodesController: iTM2KeyCodesController
{
	id keyCodesForNames;
	id orderedCodeNames;
}
@end

@interface iTM2HumanReadableCodeNameValueTransformer: NSValueTransformer
@end

static id iTM2SharedKeyCodesController = nil;

@implementation iTM2KeyCodesController
+ (void)initialize;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
	iTM2_INIT_POOL;
	[super initialize];
	if(![NSValueTransformer valueTransformerForName:@"iTM2HumanReadableCodeName"])
	{
		iTM2HumanReadableCodeNameValueTransformer * transformer = [[[iTM2HumanReadableCodeNameValueTransformer alloc] init] autorelease];
		[NSValueTransformer setValueTransformer:transformer forName:@"iTM2HumanReadableCodeName"];
	}
//iTM2_END;
	iTM2_RELEASE_POOL;
    return;
}
+ (id)sharedController;
{
	return iTM2SharedKeyCodesController?:(iTM2SharedKeyCodesController = [[_iTM2KeyCodesController alloc] init]);
}
- (id)init;
{
	if([self isKindOfClass:[_iTM2KeyCodesController class]])
	{
		return [super init];
	}
	[self dealloc];
	return [[iTM2KeyCodesController sharedController] retain];
}
- (id)initWithCoder:(NSCoder *)aDecoder;
{
	[self dealloc];
	return [[iTM2KeyCodesController sharedController] retain];
}
@end

@implementation _iTM2KeyCodesController
- (id)init;
{
	if(self = [super init])
	{
		keyCodesForNames = [[NSMutableDictionary dictionary] retain];
		NSArray * RA = [[NSBundle mainBundle] allPathsForResource:@"iTM2KeyCodes" ofType:@"xml"];
		if([RA count])
		{
			NSString * path = [RA objectAtIndex:0];
			NSURL * url = [NSURL fileURLWithPath:path];
			NSError * localError = nil;
			NSXMLDocument * doc = [[[NSXMLDocument alloc] initWithContentsOfURL:url options:NSXMLNodeCompactEmptyElement error:&localError] autorelease];
			if(localError)
			{
				[SDC presentError:localError];
			}
			else
			{
				NSArray * nodes = [doc nodesForXPath:@"/*/KEY" error:&localError];
				if(localError)
				{
					[SDC presentError:localError];
				}
				else
				{
					NSEnumerator * E = [nodes objectEnumerator];
					id node = nil;
					while(node = [E nextObject])
					{
						NSString * KEY = [node stringValue];//case sensitive
						if([KEY length])
						{
							if(node = [node attributeForName:@"CODE"])
							{
								NSString * stringCode = [node stringValue];
								NSScanner * scanner = [NSScanner scannerWithString:stringCode];
								unsigned int code = 0;
								if([scanner scanHexInt:&code])
								{
									NSNumber * codeValue = [NSNumber numberWithUnsignedInt:code];
									[keyCodesForNames setObject:codeValue forKey:KEY];
								}
							}
						}
					}
					iTM2_LOG(@"availableKeyCodes are: %@", keyCodesForNames);
				}
			}
		}
	}
	return self;
}
- (void)dealloc;
{
	[keyCodesForNames release];
	keyCodesForNames = nil;
	[orderedCodeNames release];
	orderedCodeNames = nil;
	[super dealloc];
	return;
}
- (NSArray *)orderedCodeNames;
{
	if(orderedCodeNames)
	{
		return orderedCodeNames;
	}
	NSArray * keyCodes = [keyCodesForNames allValues];
	keyCodes = [keyCodes sortedArrayUsingSelector:@selector(compare:)];
	orderedCodeNames = [NSMutableArray array];
	id code;
	NSEnumerator * E = [keyCodes objectEnumerator];
	while(code = [E nextObject])
	{
		keyCodes = [keyCodesForNames allKeysForObject:code];
		code = [keyCodes lastObject];
		[orderedCodeNames addObject:code];
	}
	return [orderedCodeNames retain];
}
- (unichar)keyCodeForName:(NSString *)name;
{
	NSNumber * N = [keyCodesForNames objectForKey:name];
	if(N)
	{
		return [N unsignedIntValue];
	}
	if([name length])
	{
		return [name characterAtIndex:0];
	}
	return 0;
}
- (NSString *)nameForKeyCode:(unichar) code;
{
	NSNumber * N = [NSNumber numberWithUnsignedInt:code];
	NSArray * keys = [keyCodesForNames allKeysForObject:N];
	if([keys count])
	{
		return [keys lastObject];
	}
	NSString * result = [NSString stringWithCharacters:&code length:1];
	return result;
}
- (NSString *)localizedNameForCodeName:(NSString *)codeName;
{
	NSString * result = NSLocalizedStringWithDefaultValue(codeName, @"iTM2KeyCodes", [NSBundle bundleForClass:[self class]], @"NO LOCALIZATION", "");
	return [result isEqualToString:@"NO LOCALIZATION"]?codeName:result;
}
- (NSString *)codeNameForLocalizedName:(NSString *)localizedName;
{
	NSEnumerator * E = [orderedCodeNames objectEnumerator];
	NSString * codeName;
	while(codeName = [E nextObject])
	{
		NSString * localized = [self localizedNameForCodeName:codeName];
		if([localized isEqual:localizedName])
		{
			return codeName;
		}
	}
	return localizedName;
}
@end

@implementation iTM2HumanReadableCodeNameValueTransformer
+ (BOOL)allowsReverseTransformation;
{
	return YES;
}
- (id)transformedValue:(id)value;
{
	if([value isKindOfClass:[NSArray class]])
	{
		NSMutableArray * result = [NSMutableArray array];
		NSEnumerator * E = [value objectEnumerator];
		while(value = [E nextObject])
		{
			id transformedValue = [self transformedValue:value];
			[result addObject:(transformedValue?:value)];
		}
		return result;
	}
	if(([value length]==1) && ([value characterAtIndex:0]>='a') && ([value characterAtIndex:0]<='z'))
	{
		value = [value uppercaseString];
	}
	return [KCC localizedNameForCodeName:value];
}
- (id)reverseTransformedValue:(id)value;
{
	if([value isKindOfClass:[NSArray class]])
	{
		NSMutableArray * result = [NSMutableArray array];
		NSEnumerator * E = [value objectEnumerator];
		while(value = [E nextObject])
		{
			id reverseTransformedValue = [self reverseTransformedValue:value];
			[result addObject:(reverseTransformedValue?:value)];
		}
		return result;
	}
	return [KCC codeNameForLocalizedName:value];
}
@end

#import "iTM2MacroKit_Controller.h"
@implementation iTM2GenericScriptButton
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= macroMenu
- (NSMenu *)macroMenu;// don't call this "menu"!
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * name = NSStringFromClass([self class]);
	NSRange R1 = [name rangeOfString:@"Script"];
	if(R1.length)
	{
		NSRange R2 = [name rangeOfString:@"Button"];
		if(R2.length && (R1.location += R1.length, (R2.location > R1.location)))
		{
			R1.length = R2.location - R1.location;
			NSString * context = [name substringWithRange:R1];
			NSString * category = [self macroCategory];
			NSString * domain = [self macroDomain];
			NSMenu * M = [SMC macroMenuForContext:context ofCategory:category inDomain:domain error:nil];
			M = [[M deepCopy] autorelease];
			// insert a void item for the title
			[M insertItem:[[[NSMenuItem alloc] initWithTitle:@"" action:NULL keyEquivalent:@""] autorelease] atIndex:0];// for the title
			return M;
		}
	}
//iTM2_END;
    return [[[NSMenu allocWithZone:[NSMenu menuZone]] initWithTitle:@""] autorelease];
}

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= awakeFromNib
- (void)awakeFromNib;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([[iTM2GenericScriptButton superclass] instancesRespondToSelector:_cmd])
		[super awakeFromNib];
	[[self retain] autorelease];
	NSView * superview = [self superview];
	[self removeFromSuperviewWithoutNeedingDisplay];
	[superview addSubview:self];
	[DNC addObserver:self selector:@selector(popUpButtonCellWillPopUpNotification:) name:NSPopUpButtonCellWillPopUpNotification object:[self cell]];
	[[self cell] setAutoenablesItems:YES];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= popUpButtonCellWillPopUpNotification:
- (void)popUpButtonCellWillPopUpNotification:(NSNotification *)notification;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self setMenu:[self macroMenu]];
	[DNC removeObserver:self];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= dealloc
- (void)dealloc;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[DNC removeObserver:self];
	[super dealloc];
//iTM2_END;
    return;
}
@end

#import "iTM2MacroKit_Model.h"

@implementation iTM2MacroNode
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= executeMacroWithTarget:selector:substitutions:
- (BOOL)executeMacroWithTarget:(id)target selector:(SEL)action substitutions:(NSDictionary *)substitutions;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(!target)
	{
		target = [[NSApp keyWindow] firstResponder];
	}
	BOOL result = NO;
	NSMethodSignature * MS = nil;
	if(action && (MS = [target methodSignatureForSelector:action]))
	{
here:
		if(substitutions)
		{
			[self setValue:substitutions forKeyPath:@"value.substitutions"];
		}
		if([MS numberOfArguments] == 3)
		{
			NS_DURING
			[target performSelector:action withObject:self];
			result = YES;
			NS_HANDLER
			NS_ENDHANDLER
		}
		else if([MS numberOfArguments] == 2)
		{
			NS_DURING
			[target performSelector:action];
			result = YES;
			NS_HANDLER
			NS_ENDHANDLER
		}
		else if(MS)
		{
		}
		else if([[[NSApp keyWindow] firstResponder] tryToPerform:action with:self]
			|| [[[NSApp mainWindow] firstResponder] tryToPerform:action with:self])
		{
			result = YES;
		}
		else
		{
			iTM2_LOG(@"No target for %@ with argument:%@", NSStringFromSelector(action),self);
		}
		[self setValue:nil forKeyPath:@"value.substitutions"];
//iTM2_END;
		return result;
	}
	if((action = [self action])
			&& (MS = [target methodSignatureForSelector:action]))
	{
		goto here;
	}
	if((action = NSSelectorFromString([self ID]))
		&& (MS = [target methodSignatureForSelector:action]))
	{
		goto here;
	}
	if((action = NSSelectorFromString(@"insertMacro:"))
		&& (MS = [target methodSignatureForSelector:action]))
	{
		goto here;
	}
//iTM2_END;
	return NO;
}
@end

#import "iTM2MacroKit_String.h"

NSString * const iTM2TextTabAnchorStringKey = @"iTM2TextTabAnchorString";

@implementation NSTextView(iTM2MacroKit_)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= load
+ (void)load;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
	iTM2_INIT_POOL;
	iTM2RedirectNSLogOutput();
//iTM2_START;
    [SUD registerDefaults:
        [NSDictionary dictionaryWithObjectsAndKeys:
            [NSString bullet], iTM2TextTabAnchorStringKey,
                nil]];
//iTM2_END;
	iTM2_RELEASE_POOL;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  tabAnchor
+ (NSString *)tabAnchor;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [SUD stringForKey:iTM2TextTabAnchorStringKey];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  selectFirstPlaceholder:
- (IBAction)selectFirstPlaceholder:(id)sender;
/*Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon Jan 10 21:45:41 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * S = [self string];
	NSString * tabAnchor = [self tabAnchor];
	NSRange firstPlaceholderRange = [S rangeOfNextPlaceholderAfterIndex:0 cycle:NO tabAnchor:tabAnchor ignoreComment:YES];
	if(!firstPlaceholderRange.length)
	{
		return;
	}
	// if it is already selected, remove, replace it
	NSRange selectedRange = [self selectedRange];
	if(!NSEqualRanges(selectedRange,firstPlaceholderRange))
	{
		[self setSelectedRange:firstPlaceholderRange];
		[self scrollRangeToVisible:[self selectedRange]];
		return;
	}
	NSString * replacement = @"";
	if(selectedRange.length>8)
	{
		selectedRange.location += 4;
		selectedRange.length -= 8;
		replacement = [S substringWithRange:selectedRange];
	}
	[self insertText:replacement];
	firstPlaceholderRange = [S rangeOfNextPlaceholderAfterIndex:selectedRange.location cycle:NO tabAnchor:tabAnchor ignoreComment:YES];
	if(firstPlaceholderRange.length)
	{
		[self setSelectedRange:firstPlaceholderRange];
		[self scrollRangeToVisible:[self selectedRange]];
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  selectNextPlaceholder:
- (IBAction)selectNextPlaceholder:(id)sender;
/*Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon Jan 10 21:45:41 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * S = [self string];
	NSString * tabAnchor = [self tabAnchor];
	NSRange selectedRange = [self selectedRange];
	NSRange actualPlaceholderRange = [S rangeOfNextPlaceholderAfterIndex:selectedRange.location cycle:NO tabAnchor:tabAnchor ignoreComment:YES];
	unsigned idx = NSMaxRange(selectedRange);
	NSRange firstPlaceholderRange = [S rangeOfNextPlaceholderAfterIndex:idx cycle:YES tabAnchor:tabAnchor ignoreComment:YES];
	if(firstPlaceholderRange.length==0)
	{
//iTM2_LOG(@"firstPlaceholderRange:%@",NSStringFromRange(firstPlaceholderRange));
		return;
	}
	// if it is already selected, remove, replace it
	if(!NSEqualRanges(selectedRange,actualPlaceholderRange))
	{
		[self setSelectedRange:firstPlaceholderRange];
		[self scrollRangeToVisible:firstPlaceholderRange];
		return;
	}
	NSString * replacement = @"";
	if(selectedRange.length>8)
	{
		selectedRange.location+=4;
		selectedRange.length -= 8;
		replacement = [S substringWithRange:selectedRange];
	}
	[self insertText:replacement];
	firstPlaceholderRange = [S rangeOfNextPlaceholderAfterIndex:selectedRange.location cycle:NO tabAnchor:tabAnchor ignoreComment:YES];
	if(firstPlaceholderRange.length)
	{
		[self setSelectedRange:firstPlaceholderRange];
		[self scrollRangeToVisible:[self selectedRange]];
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  selectPreviousPlaceholder:
- (IBAction)selectPreviousPlaceholder:(id)sender;
/*Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon Jan 10 21:45:41 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * S = [self string];
	NSString * tabAnchor = [self tabAnchor];
	NSRange selectedRange = [self selectedRange];
	NSRange firstPlaceholderRange = [S rangeOfPreviousPlaceholderBeforeIndex:selectedRange.location cycle:YES tabAnchor:tabAnchor ignoreComment:YES];
	if(!firstPlaceholderRange.length)
	{
		return;
	}
	// if it is already selected, remove, replace it
	if(!NSEqualRanges(selectedRange,firstPlaceholderRange))
	{
		[self setSelectedRange:selectedRange];
		[self scrollRangeToVisible:selectedRange];
		return;
	}
	NSString * replacement = @"";
	if(selectedRange.length>8)
	{
		selectedRange.location+=4;
		selectedRange.length -= 8;
		replacement = [S substringWithRange:selectedRange];
	}
	[self insertText:replacement];
	firstPlaceholderRange = [S rangeOfNextPlaceholderAfterIndex:selectedRange.location cycle:NO tabAnchor:tabAnchor ignoreComment:YES];
	if(firstPlaceholderRange.length)
	{
		[self setSelectedRange:firstPlaceholderRange];
		[self scrollRangeToVisible:[self selectedRange]];
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  tabAnchorKey
+ (NSString *)tabAnchorKey;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return iTM2TextTabAnchorStringKey;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  tabAnchor
- (NSString *)tabAnchor;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [self contextStringForKey:[[self class] tabAnchorKey] domain:iTM2ContextAllDomainsMask];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  numberOfSpacesPerTab
- (unsigned)numberOfSpacesPerTab;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [self contextIntegerForKey:iTM2TextNumberOfSpacesPerTabKey domain:iTM2ContextAllDomainsMask];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  cachedSelection
- (NSString *)cachedSelection;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (1.0.10)
- 1.2: 06/24/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [[self string] substringWithRange:[self selectedRange]];
}
@end

#pragma mark -
#pragma mark =====  NOTHING BELOW THIS POINT
#pragma mark -
#if 0
#import <iTM2Foundation/iTM2PathUtilities.h>
#import <iTM2Foundation/iTM2BundleKit.h>
#import <iTM2Foundation/iTM2TaskKit.h>
#import <iTM2Foundation/iTM2FileManagerKit.h>
#import <iTM2Foundation/iTM2MenuKit.h>
#import <iTM2Foundation/iTM2NotificationKit.h>

NSString * const iTM2TextPlaceholderMark = @"@@@";

NSString * const iTM2MacroControllerComponent = @"Macros.localized";
NSString * const iTM2MacroPersonalComponent = @"Personal";
NSString * const iTM2MacroPathExtension = @"iTM2-macros";
NSString * const iTM2MacroMenuPathExtension = @"iTM2-menu";

#pragma mark =-=-=-=-=-  CONCRETE CONTEXT NODES
@implementation iTM2MacroAbstractContextNode
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertObject:inAvailableMacrosAtIndex:
- (void)insertObject:(id)object inAvailableMacrosAtIndex:(int)index;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Sun Nov  5 16:57:31 GMT 2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * ID = [object ID];
	NSArray * IDs = [self availableIDs];
	if([IDs containsObject:ID])
	{
		// do nothing, this is already there
		return;
	}
	if(![ID length])
	{
		ID = @"macro";
		if([IDs containsObject:ID])
		{
			unsigned index = 0;
			do
			{
				ID = [NSString stringWithFormat:@"macro %i",++index];
			}
			while([IDs containsObject:ID]);
		}
	}
	[self insertObject:(id)object inAvailableMacrosAtIndex:(int)index withID:ID];
	IDs = [self availableIDs];// updated
	if(![IDs containsObject:ID])
	{
		iTM2_LOG(@"***  THE MACRO WAS NOT ADDED");
	}
//iTM2_END;
    return;
}
@end

#pragma mark =-=-=-=-=-  CONCRETE CONTEXT NODES
@implementation iTM2MacroContextNode
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  macroSortDescriptors
- (NSArray *)macroSortDescriptors;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Sun Nov  5 16:57:31 GMT 2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSSortDescriptor * SD = [[[NSSortDescriptor allocWithZone:[self zone]] initWithKey:@"ID" ascending:YES] autorelease];
//iTM2_END;
    return [NSArray arrayWithObject:SD];
}
@end

@interface iTM2MacroController(PRIVATE)
- (void)setSelectedMode:(NSString *)mode;
- (void)macroNode:(iTM2MacroNode *)node didChangeIDFrom:(NSString *)oldID to:(NSString *)newID;
- (id)keyBindingTree;
- (void)synchronizeMacroSelectionWithKeyBindingSelection;
- (void)synchronizeKeyBindingSelectionWithMacroSelection;
- (id)keysTreeController;
@end

@implementation iTM2MacroNode: iTM2TreeNode
- (BOOL)isVisible;
{
	return ![[self ID] hasPrefix:@"."];
}
- (NSString *)concreteArgument;
{
	id result = [self argument];
	if(!result)
	{
		result = [self ID];
	}
	id substitutions = [self valueForKeyPath:@"value.substitutions"];
	if([substitutions count])
	{
		NSString * string1, * string2;
		NSMutableString * result = [NSMutableString stringWithString:result];
		NSEnumerator * E = [substitutions keyEnumerator];
		NSRange range;
		while(string1 = [E nextObject])
		{
			string2 = [substitutions objectForKey:string1];
			range = NSMakeRange(0,[result length]);
			[result replaceOccurrencesOfString:string1 withString:string2 options:nil range:range];
		}
	}
	return result;
}
- (NSString *)macroDescription;
{
	NSXMLElement * element = [self XMLElement];
	NSError * localError = nil;
	NSArray * nodes = [element nodesForXPath:@"DESC" error:&localError];
	if(localError)
	{
		iTM2_LOG(@"localError: %@", localError);
		return @"Error: no description.";
	}
	NSXMLNode * node = [nodes lastObject];
	if(node)
	{
		return [node stringValue];
	}
	else
	{
		return @"No description available";
	}
}
- (NSString *)mode;
{
	NSXMLElement * element = [self XMLElement];
	NSError * localError = nil;
	NSArray * nodes = [element nodesForXPath:@"@MODE" error:&localError];
	if(localError)
	{
		iTM2_LOG(@"localError: %@", localError);
		return @"Error: MODE attribute?";
	}
	NSXMLNode * node = [nodes lastObject];
	if(node)
	{
		return [node stringValue];
	}
	else
	{
		return @"";
	}
}
@end

@interface iTM2MacroMenuNode: iTM2MacroContextNode
@end

@implementation iTM2MacroMenuNode
@end

@implementation iTM2MacroController

static id _iTM2MacroController = nil;
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= load
+ (void)load;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
	iTM2_INIT_POOL;
	iTM2RedirectNSLogOutput();
//iTM2_START;
	if(![NSValueTransformer valueTransformerForName:@"iTM2HumanReadableActionName"])
	{
		iTM2HumanReadableActionNameValueTransformer * transformer = [[[iTM2HumanReadableActionNameValueTransformer alloc] init] autorelease];
		[NSValueTransformer setValueTransformer:transformer forName:@"iTM2HumanReadableActionName"];
	}
	if(![NSValueTransformer valueTransformerForName:@"iTM2TabViewItemIdentifierForAction"])
	{
		iTM2TabViewItemIdentifierForActionValueTransformer * transformer = [[[iTM2TabViewItemIdentifierForActionValueTransformer alloc] init] autorelease];
		[NSValueTransformer setValueTransformer:transformer forName:@"iTM2TabViewItemIdentifierForAction"];
	}
//iTM2_END;
	iTM2_RELEASE_POOL;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= ___catch:
- (void)___catch:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= validate___catch:
- (BOOL)validate___catch:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= ___insertMacro:
- (void)___insertMacro:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSArray * RA = [sender representedObject];
	if([RA isKindOfClass:[NSArray class]] && [RA count])
	{
		NSString * ID = [RA objectAtIndex:0];
		NSString * context;
		NSString * category;
		NSString * domain;
		if([RA count] > 3)
		{
			context = [RA objectAtIndex:1];
			category = [RA objectAtIndex:2];
			domain = [RA objectAtIndex:3];
		}
		else
		{
			context = @"";
			if([RA count] > 2)
			{
				category = [RA objectAtIndex:1];
				domain = [RA objectAtIndex:2];
			}
			else
			{
				category = @"";
				if([RA count] > 1)
				{
					context = @"";
					domain = [RA objectAtIndex:1];
				}
				else
				{
					domain = @"";
				}
			}
		}
		if([ID length])
		{
			if([SMC executeMacroWithID:ID forContext:context ofCategory:category inDomain:domain target:nil])
			{
				NSMenu * recentMenu = [self macroMenuForContext:context ofCategory:@"Recent" inDomain:domain error:nil];
				int index = [recentMenu indexOfItemWithTitle:[sender title]];
				if(index!=-1)
				{
					[recentMenu removeItemAtIndex:index];
				}
				NSMenuItem * MI = [[[NSMenuItem alloc] initWithTitle:[sender title] action:[sender action] keyEquivalent:@""] autorelease];
				[MI setTarget:self];
				[MI setRepresentedObject:RA];
				[recentMenu insertItem:MI atIndex:1];
				NSMutableDictionary * MD = [NSMutableDictionary dictionary];
				index = 0;
				int max = [SUD integerForKey:@"iTM2NumberOfRecentMacros"];
				while([recentMenu numberOfItems] > max)
				{
					[recentMenu removeItemAtIndex:[recentMenu numberOfItems]-1];
				}
				while(++index < [recentMenu numberOfItems])
				{ 
					MI = [recentMenu itemAtIndex:index];
					RA = [MI  representedObject];
					if(RA)
					{
						[MD setObject:RA forKey:[MI title]];
					}
				}
				[SUD setObject:MD forKey:[NSString pathWithComponents:[NSArray arrayWithObjects:@"", @"Recent", domain, nil]]];
			}
		}
	}
	else if(RA)
	{
		iTM2_LOG(@"Unknown design [sender representedObject]:%@", RA);
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= validate___insertMacro:
- (BOOL)validate___insertMacro:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSArray * RA = [sender representedObject];
	if([RA isKindOfClass:[NSArray class]] && ([RA count] > 2))
	{
		NSString * ID = [RA objectAtIndex:0];
		if([ID length])
			return YES;
	}
	iTM2_LOG(@"sender is:%@",sender);
//iTM2_END;
    return [sender hasSubmenu];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= executeMacroWithText:forContext:ofCategory:inDomain:target:
- (BOOL)executeMacroWithText:(NSString *)text forContext:(NSString *)context ofCategory:(NSString *)category inDomain:(NSString *)domain target:(id)target;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	unsigned idx = 0;
	BOOL result = NO;
	while(idx<[text length])
	{
		NSString * type = nil;
		NSRange range = [text rangeOfNextPlaceholderMarkAfterIndex:idx getType:&type ignoreComment:YES];
		if(!range.length)
		{
			return NO;
		}
		else if(type)
		{
			NSRange fullRange = [text rangeOfPlaceholderAtIndex:range.location getType:nil ignoreComment:YES];
			if(fullRange.location == range.location && fullRange.length > range.length)
			{
				fullRange.length = NSMaxRange(fullRange);
				fullRange.location = NSMaxRange(range);
				if(fullRange.length>fullRange.location)
				{
					fullRange.length-=fullRange.location;
					if(fullRange.length>4)
					{
						fullRange.length-=4;
						text = [text substringWithRange:fullRange];
						iTM2MacroNode * leafNode = [self macroRunningNodeForID:text context:context ofCategory:category inDomain:domain];
						SEL action = NULL;
						NSString * actionName = [NSString stringWithFormat:@"insertMacro_%@:",type];
						action = NSSelectorFromString(actionName);
						result = result || [leafNode executeMacroWithTarget:target selector:action substitutions:nil];
					}
				}
			}
		}
		idx = NSMaxRange(range);
	}

//iTM2_START;
	return NO;
}
#pragma mark =-=-=-=-=-  PREFERENCES
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  awakeFromNib
- (void)awakeFromNib;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Sun Nov  5 16:57:31 GMT 2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if ([[self superclass] instancesRespondToSelector:_cmd])
	{
		[super awakeFromNib];
	}
	NSNumber * N = [NSNumber numberWithUnsignedInt:0];
	[self setValue:N forKey:@"masterTabViewItemIndex"];// unless the segmented control is not properly highlighted
	// try to bind something
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  availableDomains
- (NSArray *)availableDomains;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Sun Nov  5 16:57:31 GMT 2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	id macroTree = [self macroTree];
	id keyBindingTree = [self keyBindingTree];
	id macroAvailableDomains = [macroTree availableDomains];
	NSMutableSet * macroSet = [NSMutableSet setWithArray:macroAvailableDomains];
	id keyAvailableDomains = [keyBindingTree availableDomains];
	NSMutableSet * keySet = [NSMutableSet setWithArray:keyAvailableDomains];
	NSSet * temp = [NSSet setWithSet:macroSet];
	[macroSet minusSet:keySet];
	[keySet minusSet:temp];
	NSString * mode;
	NSEnumerator * E = [keySet objectEnumerator];
	while(mode = [E nextObject])
	{
		[[[iTM2MacroDomainNode alloc] initWithParent:macroTree domain:mode] autorelease];
	}
	E = [macroSet objectEnumerator];
	while(mode = [E nextObject])
	{
		[[[iTM2MacroDomainNode alloc] initWithParent:keyBindingTree domain:mode] autorelease];
	}
    return [[self macroTree] availableDomains];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  selectedDomain
- (NSString *)selectedDomain;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Sun Nov  5 16:57:31 GMT 2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id MD = [self contextDictionaryForKey:@"iTM2MacroEditorSelection" domain:iTM2ContextAllDomainsMask];
	if(!MD)
	{
		MD = [NSMutableDictionary dictionary];
		[self setContextValue:MD forKey:@"iTM2MacroEditorSelection" domain:iTM2ContextAllDomainsMask];
	}
	NSString * key = @".";
	id result = [MD objectForKey:key];
	NSArray * availableDomains = [self availableDomains];
	if([availableDomains containsObject:result])
	{
		// do nothing
	}
	else if(result = [[self availableDomains] lastObject])
	{
		MD = [[MD mutableCopy] autorelease];
		[MD setObject:result forKey:key];
		[self setContextValue:MD forKey:@"iTM2MacroEditorSelection" domain:iTM2ContextAllDomainsMask];
	}
//iTM2_END;
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setSelectedDomain:
- (void)setSelectedDomain:(NSString *)domain;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Sun Nov  5 16:57:31 GMT 2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * old = [self selectedDomain];
	if(![old isEqual:domain])
	{
		[self willChangeValueForKey:@"availableModes"];
		[self willChangeValueForKey:@"selectedDomain"];
		if(domain)
		{
			id MD = [self contextDictionaryForKey:@"iTM2MacroEditorSelection" domain:iTM2ContextAllDomainsMask];
			MD = [[MD mutableCopy] autorelease];
			NSString * key = @".";
			[MD setValue:domain forKey:key];
			[self setContextValue:MD forKey:@"iTM2MacroEditorSelection" domain:iTM2ContextAllDomainsMask];
		}
		[self didChangeValueForKey:@"selectedDomain"];
		[self didChangeValueForKey:@"availableModes"];
		[self setSelectedMode:nil];
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  availableModes
- (NSArray *)availableModes;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Sun Nov  5 16:57:31 GMT 2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * domain = [self selectedDomain];
	id macroNode = [[self macroTree] objectInChildrenWithDomain:domain];
	id keyNode = [[self keyBindingTree] objectInChildrenWithDomain:domain];
	id macroAvailableModes = [macroNode availableCategories];
	NSMutableSet * macroSet = [NSMutableSet setWithArray:macroAvailableModes];
	id keyAvailableModes = [keyNode availableCategories];
	NSMutableSet * keySet = [NSMutableSet setWithArray:keyAvailableModes];
	NSSet * temp = [NSSet setWithSet:macroSet];
	[macroSet minusSet:keySet];
	[keySet minusSet:temp];
	NSString * category;
	NSEnumerator * E = [keySet objectEnumerator];
	while(category = [E nextObject])
	{
		[[[iTM2MacroCategoryNode alloc] initWithParent:macroNode category:category] autorelease];
	}
	E = [macroSet objectEnumerator];
	while(category = [E nextObject])
	{
		[[[iTM2MacroCategoryNode alloc] initWithParent:keyNode category:category] autorelease];
	}
//iTM2_END;
    return [macroNode availableCategories];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  selectedMode
- (NSString *)selectedMode;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Sun Nov  5 16:57:31 GMT 2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id MD = [self contextDictionaryForKey:@"iTM2MacroEditorSelection" domain:iTM2ContextAllDomainsMask];
	if(!MD)
	{
		MD = [NSMutableDictionary dictionary];
		[self setContextValue:MD forKey:@"iTM2MacroEditorSelection" domain:iTM2ContextAllDomainsMask];
	}
	NSString * key = [self selectedDomain]?:@"";
	id result = [MD objectForKey:key];
	NSArray * availableModes = [self availableModes];
	if([availableModes containsObject:result])
	{
		// do nothing
	}
	else if(result = [[self availableModes] lastObject])
	{
		MD = [[MD mutableCopy] autorelease];
		[MD setObject:result forKey:key];
		[self setContextValue:MD forKey:@"iTM2MacroEditorSelection" domain:iTM2ContextAllDomainsMask];
	}
//iTM2_END;
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setSelectedMode:
- (void)setSelectedMode:(NSString *)mode;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Sun Nov  5 16:57:31 GMT 2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * old = [self selectedMode];
	if(![old isEqual:mode])
	{
		[self willChangeValueForKey:@"macroEditor"];
		[self willChangeValueForKey:@"keyBindingEditor"];
		[self willChangeValueForKey:@"selectedMode"];
		if(mode)
		{
			id MD = [self contextDictionaryForKey:@"iTM2MacroEditorSelection" domain:iTM2ContextAllDomainsMask];
			MD = [[MD mutableCopy] autorelease];
			NSString * key = [self selectedDomain]?:@"";
			[MD setValue:mode forKey:key];
			[self setContextValue:MD forKey:@"iTM2MacroEditorSelection" domain:iTM2ContextAllDomainsMask];
		}
		[self didChangeValueForKey:@"selectedMode"];
		[self setValue:nil forKey:@"keyBindingEditor_meta"];
		[self didChangeValueForKey:@"keyBindingEditor"];
		[self setValue:nil forKey:@"macroEditor_meta"];
		[self didChangeValueForKey:@"macroEditor"];
	}
//iTM2_END;
    return;
}
#pragma mark =-=-=-=-=-  MACROS
-(id)macrosArrayController;// nib outlets won't accept kvc (10.4)
{
	return metaGETTER;
}
-(void)setMacrosArrayController:(id)argument;
{
	[self willChangeValueForKey:@"selection"];
	[self willChangeValueForKey:@"selectedMacro"];
	metaSETTER(argument);
	[self didChangeValueForKey:@"selectedMacro"];
	[self didChangeValueForKey:@"selection"];
	return;
}
- (BOOL)canEditActionName;
{
	iTM2MacroNode * node = [self selectedMacro];
	return [node isVisible];
}
- (BOOL)canEdit;
{
	iTM2MacroNode * node = [self selectedMacro];
	return [node isVisible];
}
- (BOOL)canHideArgumentView;
{
	iTM2MacroNode * node = [self selectedMacro];
	NSString * argument = [node argument];
	return [argument length]==0;
}
- (BOOL)showArgumentView;
{
	id result = metaGETTER;
	if([result boolValue])
	{
		return YES;
	}
	iTM2MacroNode * node = [self selectedMacro];
	NSString * argument = [node argument];
	return [argument length]>0;
}
- (void)macroNode:(iTM2MacroNode *)node didChangeIDFrom:(NSString *)oldID to:(NSString *)newID;
{
	if(!node)
	{
		return;
	}
	id parent = [node parent];
	id D = [parent valueForKeyPath:@"value.cachedChildrenIDs"];
	[D removeObjectForKey:oldID];
	[D setObject:node forKey:newID];
	if(![parent isKindOfClass:[iTM2MacroContextNode class]])
	{
		[self synchronizeMacroSelectionWithKeyBindingSelection];
		return;
	}
	NSTreeController * keysTreeController = [self keysTreeController];
	NSDictionary * contentArrayBindingDict = [keysTreeController infoForBinding:@"contentArray"];
	NSString * observedKeyPath = [contentArrayBindingDict objectForKey:NSObservedKeyPathKey];
	NSString * childrenKeyPath = [keysTreeController childrenKeyPath];
	NSMutableArray * childrenEnumeratorStack = [NSMutableArray array];
	NSEnumerator * E = nil;		
	id controller = nil;
	id children = nil;
	if(controller = [contentArrayBindingDict objectForKey:NSObservedObjectKey])
	{
		if(children = [controller mutableArrayValueForKeyPath:observedKeyPath])
		{
			if([children count])
			{
pushed:
				E = [children objectEnumerator];
poped:
				while(controller = [E nextObject])
				{
					if(children = [controller mutableArrayValueForKeyPath:childrenKeyPath])
					{
						if([children count])
						{
							[childrenEnumeratorStack addObject:E];
							goto pushed;
						}
						else
						{
							NSString * itsID = [controller ID];
							if([itsID isEqual:oldID])
							{
								[controller setID:newID];
							}
						}
					}
				}
				if(E = [childrenEnumeratorStack lastObject])
				{
					[childrenEnumeratorStack removeLastObject];
					goto poped;
				}
			}
		}
	}
}
#pragma mark =-=-=-=-=-  BINDINGS
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  keyBindingEditor
- (id)keyBindingEditor;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Sun Nov  5 16:57:31 GMT 2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id node = [self valueForKey:@"keyBindingEditor_meta"];
	if(node)
	{
		return node;
	}
	NSString * domain = [self selectedDomain];
	node = [self keyBindingTree];
	node = [node objectInChildrenWithDomain:domain]?:
				[[[iTM2MacroDomainNode alloc] initWithParent:node domain:domain] autorelease];
	NSString * mode = [self selectedMode];
	node = [node objectInChildrenWithCategory:mode]?:
				[[[iTM2MacroCategoryNode alloc] initWithParent:node category:mode] autorelease];
	node = [node objectInChildrenWithContext:@""]?:
				[[[iTM2KeyBindingContextNode alloc] initWithParent:node context:@""] autorelease];
	[self setValue:node forKey:@"keyBindingEditor_meta"];
//iTM2_END;
    return node;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  selectedKeyBinding
- (id)selectedKeyBinding;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Sun Nov  5 16:57:31 GMT 2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return metaGETTER;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setSelectedKeyBinding:
- (void)setSelectedKeyBinding:(id)new;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Sun Nov  5 16:57:31 GMT 2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id old = [self selectedKeyBinding];
	if([old isEqual:new])
	{
		return;
	}
	[self willChangeValueForKey:@"selectedKeyBinding"];
	metaSETTER(new);
	[self didChangeValueForKey:@"selectedKeyBinding"];
//iTM2_END;
    return;
}
-(id)keysTreeController;
{
	return metaGETTER;
}
-(void)setKeysTreeController:(id)argument;
{
	[self willChangeValueForKey:@"selectedKeyBinding"];
	metaSETTER(argument);
	[self didChangeValueForKey:@"selectedKeyBinding"];
	return;
}
-(id)selection;
{
	return [[([self masterTabViewItemIndex]?[self keysTreeController]:[self macrosArrayController]) selectedObjects] lastObject];
}
#pragma mark =-=-=-=-=-  DELEGATE
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  menuNeedsUpdate:
- (void)menuNeedsUpdate:(NSMenu *)menu;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Sun Nov  5 16:57:31 GMT 2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	// availableModes:
	NSArray * itemArray = [menu itemArray];
	NSEnumerator * E = [itemArray objectEnumerator];
	NSMenuItem * MI = nil;
	SEL action = @selector(takeMacroModeFromRepresentedObject:);
	NSMutableArray * availableModes = [NSMutableArray array];
	NSString * mode;
	while(MI = [E nextObject])
	{
		if([MI action] == action)
		{
			mode = [MI representedObject];
			if(![availableModes containsObject:mode])
			{
				[availableModes addObject:mode];
			}
		}
	}
	// expected modes:
	id firstResponder = [NSApp keyWindow];
	firstResponder = [firstResponder firstResponder];
	NSString * domain = [firstResponder macroDomain];
	iTM2MacroRootNode * rootNode = [self macroTree];
	iTM2MacroDomainNode * domainNode = [rootNode objectInChildrenWithDomain:domain];
	NSArray * expectedModes = [domainNode availableCategories];
	//
	if([expectedModes isEqual:availableModes])
	{
		return;
	}
	// remove items with takeMacroModeFromRepresentedObject:
	E = [itemArray objectEnumerator];
	while(MI = [E nextObject])
	{
		if([MI action] == action)
		{
			[menu removeItem:MI];
		}
	}
	// recover the "Mode:" title menu item
	int index = [menu indexOfItemWithRepresentedObject:@"iTM2_PRIVATE_MacroModeMenuItem"];
	++index;

	E = [expectedModes objectEnumerator];
	while(mode = [E nextObject])
	{
		MI = [[[NSMenuItem allocWithZone:[menu zone]] initWithTitle:[mode description] action:action keyEquivalent:@""] autorelease];
		[MI setRepresentedObject:mode];
		[MI setIndentationLevel:1];
		[menu insertItem:MI atIndex:index++];
	}
	MI = [NSMenuItem separatorItem];
	[menu insertItem:MI atIndex:index++];
	[menu cleanSeparators];
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  outlineViewSelectionDidChange:
- (void)outlineViewSelectionDidChange:(NSNotification *)notification;
/*"Synchronize macro selection with key binding selection.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSOutlineView * outlineView = [notification object];
	NSWindow * W = [outlineView window];
	if(outlineView != [W firstResponder])
	{
		return;
	}
	[self synchronizeMacroSelectionWithKeyBindingSelection];
//iTM2_END;
	return;
}
- (void)tableViewSelectionDidChange:(NSNotification *)notification;
{
	NSTableView * TV = [notification object];
	NSWindow * W = [TV window];
	if(TV != [W firstResponder])
	{
		return;
	}
	[self synchronizeKeyBindingSelectionWithMacroSelection];
/	return;
}
- (void)synchronizeKeyBindingSelectionWithMacroSelection;
{
	NSArrayController * macrosArrayController = [self macrosArrayController];
	NSArray * selectedObjects = [macrosArrayController selectedObjects];
	if([selectedObjects count] == 1)
	{
		id selection = [selectedObjects lastObject];
		NSString * newID = [selection ID];
		NSTreeController * keysTreeController = [self keysTreeController];
		NSDictionary * contentArrayBindingDict = [keysTreeController infoForBinding:@"contentArray"];
		NSString * observedKeyPath = [contentArrayBindingDict objectForKey:NSObservedKeyPathKey];
		NSString * childrenKeyPath = [keysTreeController childrenKeyPath];
		NSMutableArray * childrenEnumeratorStack = [NSMutableArray array];
		unsigned index = 0;
		NSEnumerator * E = nil;		
		id controller = nil;
		NSIndexPath * IP = nil;
		id children = nil;
		if(controller = [contentArrayBindingDict objectForKey:NSObservedObjectKey])
		{
			if(children = [controller mutableArrayValueForKeyPath:observedKeyPath])
			{
				if([children count])
				{
pushed:
					E = [children objectEnumerator];
					index = 0;
poped:
					while(controller = [E nextObject])
					{
						if(children = [controller mutableArrayValueForKeyPath:childrenKeyPath])
						{
							if([children count])
							{
								IP = IP?[IP indexPathByAddingIndex:index]:[NSIndexPath indexPathWithIndex:index];
								[childrenEnumeratorStack addObject:E];
								goto pushed;
							}
							else
							{
								NSString * itsID = [controller ID];
								if([itsID isEqual:newID])
								{
									IP = IP?[IP indexPathByAddingIndex:index]:[NSIndexPath indexPathWithIndex:index];
									childrenEnumeratorStack =  nil;
									E = nil;
									// this will break here
								}
							}
						}
						++index;
					}
					if(E = [childrenEnumeratorStack lastObject])
					{
						[childrenEnumeratorStack removeLastObject];
						unsigned int length = [IP length];
						index = [IP indexAtPosition:length-1];
						IP = length>1?[IP indexPathByRemovingLastIndex]:nil;
						goto poped;
					}
				}
			}
		}
		[keysTreeController setSelectionIndexPath:IP];
	}
	return;
}
@end

#import <iTM2Foundation/iTM2InstallationKit.h>

@implementation iTM2MainInstaller(iTM2MacroKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2MacroKitCompleteInstallation
+ (void)iTM2MacroKitCompleteInstallation;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSMenu * M = [NSApp mainMenu];
	NSMenuItem * MI = [M deepItemWithAction:@selector(macroMode:)];
	if(MI)
	{
		M = [MI menu];
		[MI setAction:NULL];
		[MI setRepresentedObject:@"iTM2_PRIVATE_MacroModeMenuItem"];
		[M setDelegate:SMC];
	}
	else
	{
		iTM2_LOG(@"No macros menu");
	}
//iTM2_END;
    return;
}
@end

#pragma mark -
#import <iTM2Foundation/NSTextStorage_iTeXMac2.h>

#import <iTM2Foundation/iTM2StringKit.h>


#import <iTM2Foundation/NSTextStorage_iTeXMac2.h>

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  NSTextStorage(iTM2Selection_MACRO)
/*"Description forthcoming."*/
@implementation NSTextStorage(iTM2Selection_MACRO)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  insertMacro:inRangeValue:
- (void)insertMacro:(id)argument inRangeValue:(id)rangeValue;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if([argument isKindOfClass:[NSString class]] || [argument isKindOfClass:[NSDictionary class]])
    {
        NSTextView * TV = [self mainTextView];
        if([rangeValue respondsToSelector:@selector(rangeValue)])
            [TV setSelectedRange:[rangeValue rangeValue]];
        [TV insertMacro:argument];        
    }
    else
    {
        NSLog(@"JL, you should have raised an exception!!! (code 1789)");
    }
    return;
}
@end

/*"Description forthcoming."*/
@interface iTM2MacroArrayController: NSArrayController
@end

@implementation iTM2MacroArrayController
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  canRemove
- (BOOL)canRemove;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSIndexSet * indexSet = [self selectionIndexes];
	NSArray * RA = [self arrangedObjects];
	unsigned int index = [indexSet firstIndex];
	while(index != NSNotFound)
	{
		id O = [RA objectAtIndex:index];
		if([O respondsToSelector:@selector(isMutable)] && [O isMutable])
		{
			return YES;
		}
		index = [indexSet indexGreaterThanIndex:index];
	}
	RA = [self content];
//iTM2_END;
    return NO;
}
- (void)insertObject:(id)object atArrangedObjectIndex:(unsigned int)index;    // inserts into the content objects and the arranged objects (as specified by index in the arranged objects) - will raise an exception if the object does not match all filters currently applied
{
	[super insertObject:(id)object atArrangedObjectIndex:(unsigned int)index];
	NSArray * arrangedObjects = [self arrangedObjects];
	index = [arrangedObjects indexOfObject:object];
	[self setSelectionIndex:index];
	return;
}
@end










@interface iTM2MacroTableView:NSTableView
@end

@implementation iTM2MacroTableView
- (SEL)doubleAction;
{
	return @selector(executeMacro:);
}
- (void)copy:(id)sender;
{
	NSArray *columns = [self tableColumns];
	unsigned columnIndex = 0, columnCount = [columns count];
	NSDictionary *valueBindingDict = nil;
	for (; !valueBindingDict && columnIndex < columnCount; ++columnIndex) {
		valueBindingDict = [[columns objectAtIndex:columnIndex] infoForBinding:@"value"];
	}
	id arrayController = [valueBindingDict objectForKey:NSObservedObjectKey];
	if ([arrayController isKindOfClass:[NSArrayController class]]) {
		//	Found a column bound to an array controller.
		NSArray * selectedObjects = [arrayController selectedObjects];
		if([selectedObjects count])
		{
			NSMutableDictionary * copy = [NSMutableDictionary dictionary];
			NSMutableArray * IDs = [NSMutableArray array];
			[copy setObject:IDs forKey:@"IDs"];
			id node = [selectedObjects lastObject];
			node = [node parent];
			NSString * context = [node valueForKeyPath:@"value.context"];
			node = [node parent];
			NSString * category = [node valueForKeyPath:@"value.category"];
			node = [node parent];
			NSString * domain = [node valueForKeyPath:@"value.domain"];
			[copy setObject:domain forKey:@"domain"];
			[copy setObject:category forKey:@"category"];
			[copy setObject:context forKey:@"context"];
			NSEnumerator * E = [selectedObjects objectEnumerator];
			while(node = [E nextObject])
			{
				NSString * ID = [node ID];
				[IDs addObject:ID];
			}
			NSPasteboard * GP = [NSPasteboard generalPasteboard];
			NSString * type = @"iTM2MacroPBoard";
			NSArray * newTypes = [NSArray arrayWithObject:type];
			[GP declareTypes:newTypes owner:nil];
			[GP setPropertyList:copy forType:type];
		}
	}
	return;
}
- (BOOL)validateCopy:(id)sender;
{
	NSArray *columns = [self tableColumns];
	unsigned columnIndex = 0, columnCount = [columns count];
	NSDictionary *valueBindingDict = nil;
	for (; !valueBindingDict && columnIndex < columnCount; ++columnIndex) {
		valueBindingDict = [[columns objectAtIndex:columnIndex] infoForBinding:@"value"];
	}
	id arrayController = [valueBindingDict objectForKey:NSObservedObjectKey];
	if ([arrayController isKindOfClass:[NSArrayController class]]) {
		//	Found a column bound to an array controller.
		NSArray * selectedObjects = [arrayController selectedObjects];
		if([selectedObjects count])
		{
			return YES;
		}
	}
	return NO;
}
- (void)paste:(id)sender;
{
	NSPasteboard * GP = [NSPasteboard generalPasteboard];
	NSArray * types = [NSArray arrayWithObject:@"iTM2MacroPBoard"];
	NSString * availableType = [GP availableTypeFromArray:types];
	if(!availableType)
	{
		return;
	}
	NSDictionary * copies = [GP propertyListForType:availableType];
	NSString * domain = [copies objectForKey:@"domain"];
	NSString * category = [copies objectForKey:@"category"];
	NSString * context = [copies objectForKey:@"context"];
	NSArray * IDs = [copies objectForKey:@"IDs"];
	NSEnumerator * E = [IDs objectEnumerator];
	NSString * ID;
	id sourceTree = [SMC macroTree];
	sourceTree = [sourceTree objectInChildrenWithDomain:domain];
	sourceTree = [sourceTree objectInChildrenWithCategory:category];
	sourceTree = [sourceTree objectInChildrenWithContext:context];
	id targetTree = [SMC macroEditor];
	id node, alreadyNode;
	while(ID = [E nextObject])
	{
		if(node = [sourceTree objectInChildrenWithID:ID])
		{
			node = [node copy];
			if(alreadyNode = [targetTree objectInChildrenWithID:ID])
			{
				//The only thing I have to do is connect the last mutableXMLElement;
				NSURL * url = [targetTree personalURL];
				NSXMLDocument * personalDocument = [targetTree documentForURL:url];
				NSXMLElement * personalRootElement = [personalDocument rootElement];
				NSMutableArray * alreadyMutableXMLElements = [alreadyNode mutableXMLElements];
				NSXMLElement * element = [alreadyMutableXMLElements lastObject];
				if(element)
				{
					NSString * XPath = [NSString stringWithFormat:@"/@ID=\"%@\"",ID];
					NSArray * RA = [personalRootElement nodesForXPath:XPath error:nil];
					id elt;
					NSEnumerator * EE = [RA objectEnumerator];
					while(elt = [EE nextObject])
					{
						[elt detach];
					}
					NSXMLDocument * rootDocument = [element rootDocument];
					if([personalDocument isEqual:rootDocument])
					{
						[alreadyMutableXMLElements removeLastObject];
					}
					[element detach];
				}
				element = [node XMLElement];
				if(!element)
				{
					element = [NSXMLElement elementWithName:@"ACTION"];
					NSXMLNode * attribute = [NSXMLNode attributeWithName:@"ID" stringValue:ID];
					[element addAttribute:attribute];
				}
				[element detach];
				[personalRootElement addChild:element];
				[alreadyNode addMutableXMLElement:element];
			}
			else
			{
				[targetTree insertObject:node inAvailableMacrosAtIndex:0];
			}
		}
		else
		{
			iTM2_LOG(@"No macro with domain:%@, category:%@, context:%@, ID:%@",
				domain,category,context,ID);
		}
	}
	return;
}
- (BOOL)validatePaste:(id)sender;
{
	NSPasteboard * GP = [NSPasteboard generalPasteboard];
	NSArray * types = [NSArray arrayWithObject:@"iTM2MacroPBoard"];
	NSString * availableType = [GP availableTypeFromArray:types];
	return availableType != nil;
}
@end

@interface iTM2KeyBindingOutlineView:NSOutlineView
@end

@implementation iTM2KeyBindingOutlineView
- (void)keyDown:(NSEvent *)theEvent;
{
	if([self numberOfSelectedRows]==1)
	{
		unsigned int modifierFlags = [theEvent modifierFlags];
		modifierFlags = modifierFlags & NSDeviceIndependentModifierFlagsMask;
//		if((modifierFlags&NSFunctionKeyMask)==0)
		{
#if 0
			// this does not work
			int selectedRow = [self selectedRow];
			id item = [self itemAtRow:selectedRow];
			iTM2_LOG(@"item:%@",item);
#endif
			// see http://svn.sourceforge.net/viewvc/redshed/trunk/cocoa/NSTableView%2BCocoaBindingsDeleteKey/NSTableView%2BCocoaBindingsDeleteKey.m?view=markup
			NSArray *columns = [self tableColumns];
			unsigned columnIndex = 0, columnCount = [columns count];
			NSDictionary *valueBindingDict = nil;
			for (; !valueBindingDict && columnIndex < columnCount; ++columnIndex) {
				valueBindingDict = [[columns objectAtIndex:columnIndex] infoForBinding:@"value"];
			}
			id treeController = [valueBindingDict objectForKey:NSObservedObjectKey];
			if ([treeController isKindOfClass:[NSTreeController class]]) {
				//	Found a column bound to a tree controller.
				NSArray * selectedObjects = [treeController selectedObjects];
				id selection = [selectedObjects lastObject];
				// first turn the event into a key stroke object
				iTM2MacroKeyStroke * keyStroke = [theEvent macroKeyStroke];
				NSString * key = [keyStroke string];
				// is this key already used by the selection?
				if([key isEqual:[selection key]])
				{
					iTM2_LOG(@"No change: it is the same key.");
					return;
				}
				// is there already a binding with that key
				id parent = [selection parent];
				id alreadyBinding = [parent objectInAvailableKeyBindingsWithKey:key];
				NSError * error = nil;
				if(alreadyBinding)
				{
					// do they have the same ID
					NSString * ID = [selection ID];
					NSString * alreadyID = [alreadyBinding ID];
					if([ID isEqual:alreadyID])
					{
						iTM2_LOG(@"No change: this binding already exists.");
						return;
					}
					#warning Change the selection of the outline view
					//[SMC setSelection:selection];
					if([alreadyBinding beMutable] && [alreadyBinding validateID:&key error:&error])
					{
						[alreadyBinding setID:ID];// only now: before the object was not mutable and could not change its ID
						unsigned index = [parent indexOfObjectInAvailableKeyBindings:selection];
						[parent removeObjectFromAvailableKeyBindingsAtIndex:index];
						// now remove the selection
						// to remove the selection, there are different situation we must manage
						// the simplest one: the binding  was just created as is and did not come from a read only location.
						return;
					}
				}
				else if([selection beMutable] && [selection validateKey:&key error:&error])
				{
					[selection setKey:key];// only now: before the object was not mutable and could not change its key
					return;
				}
				iTM2_LOG(@"error:%@",error);
				return;
			}
#if 0
				NSAlphaShiftKeyMask =		1 << 16,
	 =		1 << 17,
	NSControlKeyMask =		1 << 18,
	NSAlternateKeyMask =		1 << 19,
	NSCommandKeyMask =		1 << 20,
	NSNumericPadKeyMask =		1 << 21,
	NSHelpKeyMask =			1 << 22,
	NSFunctionKeyMask =		1 << 23,
#endif
		}
	}
	[super keyDown:theEvent];
	return;
}
@end

@implementation iTM2MacroPrefPane
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= prefPaneIdentifier
- (NSString *)prefPaneIdentifier;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 09/21/2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return @"3.Macro";
}
#if 0
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  willUnselect
- (void)willUnselect;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[super willUnselect];
    return;
}
#endif
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  loadMainView
- (NSView *) loadMainView;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(![NSValueTransformer valueTransformerForName:@"iTM2HumanReadableActionName"])
	{
		iTM2HumanReadableActionNameValueTransformer * transformer = [[[iTM2HumanReadableActionNameValueTransformer alloc] init] autorelease];
		[NSValueTransformer setValueTransformer:transformer forName:@"iTM2HumanReadableActionName"];
	}
	if(![NSValueTransformer valueTransformerForName:@"iTM2TabViewItemIdentifierForAction"])
	{
		iTM2TabViewItemIdentifierForActionValueTransformer * transformer = [[[iTM2TabViewItemIdentifierForActionValueTransformer alloc] init] autorelease];
		[NSValueTransformer setValueTransformer:transformer forName:@"iTM2TabViewItemIdentifierForAction"];
	}
//iTM2_END;
    return [super loadMainView];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  macroTestView
- (id)macroTestView;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return metaGETTER;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setMacroTestView:
- (void)setMacroTestView:(id)argument;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    metaSETTER(argument);
	return;
}
@end

@interface iTM2MacroPopUpButton:NSPopUpButton
@end

@implementation iTM2MacroPopUpButton
- (void)awakeFromNib;
{
	if([[self superclass] instancesRespondToSelector:_cmd])
	{
		[super awakeFromNib];
	}
	NSView * superview = [self superview];
	[self retain];
	[self removeFromSuperviewWithoutNeedingDisplay];
	[superview addSubview:self positioned:NSWindowBelow relativeTo:nil];
	return;
}
@end

@interface iTM2MacroEditor:NSTextView
@end

@implementation iTM2MacroEditor
@end

#endif