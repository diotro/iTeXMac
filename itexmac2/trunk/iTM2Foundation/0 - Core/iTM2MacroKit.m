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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= macroWithID:
/* This is a central method.
*/
- (id)macroWithID:(NSString *)ID;
{
	// this will be overriden by the text view used for testing macros and key bindings in the prefs pane
	return [SMC macroRunningNodeForID:ID context:[self macroDomain] ofCategory:[self macroCategory] inDomain:[self macroDomain]];
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
	[self toggleContextBoolForKey:iTM2DontUseSmartMacrosKey];
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
	unsigned int state = [self contextStateForKey:iTM2DontUseSmartMacrosKey];
    [sender setState:state];
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
@property (retain) id keyCodesForNames;
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
			NSXMLDocument * doc = [[[NSXMLDocument alloc] initWithContentsOfURL:url options:0 error:&localError] autorelease];
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
					id node = nil;
					for(node in nodes)
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
									NSString * codeValue = [NSString stringWithFormat:@"%C",code];
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
	NSArray * keyCodes = [[keyCodesForNames allValues] sortedArrayUsingSelector:@selector(compare:)];
	orderedCodeNames = [NSMutableArray array];
	id code;
	for(code in keyCodes)
	{
		[orderedCodeNames addObject:[[keyCodesForNames allKeysForObject:code] lastObject]];
	}
	return [orderedCodeNames retain];
}
- (NSString *)keyCodeForName:(NSString *)name;
{
	return [keyCodesForNames objectForKey:name]?:name;
}
- (NSString *)nameForKeyCode:(NSString *) code;
{
	return [[keyCodesForNames allKeysForObject:code] lastObject]?:code;
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
@synthesize keyCodesForNames;
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
