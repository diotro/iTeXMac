/*
//
//  @version Subversion: $Id: iTM2MacroKit.m 795 2009-10-11 15:29:16Z jlaurens $ 
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

#import "iTM2ContextKit.h"
#import "iTM2MenuKit.h"
#import "iTM2InheritanceKit.h"
#import "iTM2BundleKit.h"
#import "iTM2PreferencesKit.h"
#import "iTM2TextDocumentKit.h"

#import "iTM2StringControllerKit.h"
#import "iTM2MacroKit.h"
#import "iTM2MacroKit_Action.h"
#import "iTM2MacroKit_String.h"
#import "iTM2MacroKit_Controller.h"


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
	if (key.length)
	{
		result = [self context4iTM3StringForKey:key domain:iTM2ContextPrivateMask];
		if (result.length)
		{
			return result;
		}
		result = [self inheritedValueForKey:@"defaultMacroDomain"];
		if (!result.length)
		{
			result = [self context4iTM3StringForKey:key domain:iTM2ContextAllDomainsMask]?:@"";
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
	NSString * old = [self context4iTM3StringForKey:key domain:iTM2ContextPrivateMask];
	if (![old isEqual:argument])
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
	if (key.length)
	{
		result = [self context4iTM3StringForKey:key domain:iTM2ContextPrivateMask];
		if (result.length)
		{
			return result;
		}
		result = [self inheritedValueForKey:@"defaultMacroCategory"];
		if (!result.length)
		{
			result = [self context4iTM3StringForKey:key domain:iTM2ContextAllDomainsMask]?:@"";
		}
		if (!result.length)
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
	NSString * old = [self context4iTM3StringForKey:key domain:iTM2ContextPrivateMask];
	if ([old isEqual:argument])
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
	if (key.length)
	{
		result = [self context4iTM3StringForKey:key domain:iTM2ContextPrivateMask];
		if (result.length)
		{
			return result;
		}
		result = [self inheritedValueForKey:@"defaultMacroContext"];
		if (!result.length)
		{
			result = [self context4iTM3StringForKey:key domain:iTM2ContextAllDomainsMask]?:@"";
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
	NSString * old = [self context4iTM3StringForKey:key domain:iTM2ContextPrivateMask];
	if (![old isEqual:argument])
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
    return [self superview]?[[self superview] macroDomainKey]:[self.window macroDomainKey];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= macroCategoryKey
- (NSString *)macroCategoryKey;
{
    return [self superview]?[[self superview] macroCategoryKey]:([self.nextResponder macroCategoryKey]?:[self.window macroCategoryKey]);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= setMacroCategory:
- (void)setMacroCategory:(NSString *)argument;
{
	NSString * key = [self macroCategoryKey];
	NSString * old = [self context4iTM3StringForKey:key domain:iTM2ContextPrivateMask];
	if ([old isEqual:argument])
	{
		return;
	}
	id superview = [self superview];
	if (superview)
	{
		[superview setMacroCategory:argument];
	}
	else
	{
		id window = self.window;
		if (window)
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
    return [self superview]?[[self superview] macroContextKey]:[self.window macroContextKey];
}
@end

@implementation NSWindow(iTM2MacroKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= macroDomainKey
- (NSString *)macroDomainKey;
{
    return [self delegate]?[(id)[self delegate] macroDomainKey]:(self.windowController?[self.windowController macroDomainKey]:[super macroDomainKey]);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= macroCategoryKey
- (NSString *)macroCategoryKey;
{
    return [self delegate]?[(id)[self delegate] macroCategoryKey]:(self.windowController?[self.windowController macroCategoryKey]:[super macroCategoryKey]);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= setMacroCategory:
- (void)setMacroCategory:(NSString *)argument;
{
	NSString * key = [self macroCategoryKey];
	NSString * old = [self context4iTM3StringForKey:key domain:iTM2ContextPrivateMask];
	if ([old isEqual:argument])
	{
		return;
	}
	id delegate = [self delegate];
	if (delegate)
	{
		[delegate setMacroCategory:argument];
	}
	id windowController = self.windowController;
	if (windowController)
	{
		[windowController setMacroCategory:argument];
	}
	[super setMacroCategory:argument];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= macroContextKey
- (NSString *)macroContextKey;
{
    return [self delegate]?[(id)[self delegate] macroContextKey]:(self.windowController?[self.windowController macroContextKey]:[super macroContextKey]);
}
@end

@implementation NSWindowController(iTM2MacroKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= macroDomainKey
- (NSString *)macroDomainKey;
{
    return self.document?[self.document macroDomainKey]:[super macroDomainKey];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= macroCategoryKey
- (NSString *)macroCategoryKey;
{
    return self.document?[self.document macroCategoryKey]:[super macroCategoryKey];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= setMacroCategory:
- (void)setMacroCategory:(NSString *)argument;
{
	NSString * key = [self macroCategoryKey];
	NSString * old = [self context4iTM3StringForKey:key domain:iTM2ContextPrivateMask];
	if ([old isEqual:argument])
	{
		return;
	}
	id document = self.document;
	if (document)
	{
		[document setMacroCategory:argument];
	}
	[super setMacroCategory:argument];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= macroContextKey
- (NSString *)macroContextKey;
{
    return self.document?[self.document macroContextKey]:[super macroContextKey];
}
@end

@interface NSResponder(iTM2MacroKit_)
- (void)resetKeyBindingsManager4iTM3;
@end

NSString * const iTM2DontUseSmartMacrosKey = @"iTM2DontUseSmartMacros";

@implementation NSResponder(iTM2MacroKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleSmartMacros:
- (IBAction)toggleSmartMacros:(id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Jan 18 22:21:11 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[self toggleContext4iTM3BoolForKey:iTM2DontUseSmartMacrosKey];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleSmartMacros:
- (BOOL)validateToggleSmartMacros:(NSButton *) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Jan 18 22:21:11 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	sender.state = [self contextStateForKey:iTM2DontUseSmartMacrosKey];
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= takeMacroModeFromRepresentedObject:
- (IBAction)takeMacroModeFromRepresentedObject:(NSMenuItem *)sender;
{
	id newMode = sender.representedString;
	if (newMode) {
		[self setMacroCategory:newMode];
	}
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= validateTakeMacroModeFromRepresentedObject:
- (BOOL)validateTakeMacroModeFromRepresentedObject:(NSMenuItem *)sender;
{
	sender.state = ([self.macroCategory isEqual:sender.representedObject]?NSOnState:NSOffState);
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  macroEdit:
- (IBAction)macroEdit:(id)sender;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Sun Nov  5 16:57:31 GMT 2006
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[[iTM2PrefsController sharedPrefsController] displayPrefsPaneWithIdentifier:@"3.Macro"];
//END4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= macroDomainKey
- (NSString *)macroDomainKey;
{
    return self.nextResponder?[self.nextResponder macroDomainKey]:[super macroDomainKey];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= macroCategoryKey
- (NSString *)macroCategoryKey;
{
    return self.nextResponder?[self.nextResponder macroCategoryKey]:[super macroCategoryKey];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= setMacroCategory:
- (void)setMacroCategory:(NSString *)argument;
{
	NSString * key = [self macroCategoryKey];
	NSString * old = [self context4iTM3StringForKey:key domain:iTM2ContextPrivateMask];
	if ([old isEqual:argument])
	{
		return;
	}
	id nextResponder = self.nextResponder;
	if (nextResponder)
	{
		[nextResponder setMacroCategory:argument];
	}
	[super setMacroCategory:argument];
	// reentrant management
	id new = [self context4iTM3StringForKey:key domain:iTM2ContextPrivateMask];
	if ([old isEqual:new])
	{
		return;
	}
	if (old == new)
	{
		return;
	}
	[self resetKeyBindingsManager4iTM3];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= macroContextKey
- (NSString *)macroContextKey;
{
    return self.nextResponder?[self.nextResponder macroContextKey]:[super macroContextKey];
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
{DIAGNOSTIC4iTM3;
	INIT_POOL4iTM3;
	[super initialize];
	if (![NSValueTransformer valueTransformerForName:@"iTM2HumanReadableCodeName"])
	{
		iTM2HumanReadableCodeNameValueTransformer * transformer = [[[iTM2HumanReadableCodeNameValueTransformer alloc] init] autorelease];
		[NSValueTransformer setValueTransformer:transformer forName:@"iTM2HumanReadableCodeName"];
	}
	//END4iTM3;
	RELEASE_POOL4iTM3;
    return;
}
+ (id)sharedController;
{
	return iTM2SharedKeyCodesController?:(iTM2SharedKeyCodesController = [[_iTM2KeyCodesController alloc] init]);
}
- (id)init;
{
	if ([self isKindOfClass:[_iTM2KeyCodesController class]])
	{
		return [super init];
	}
	return [iTM2KeyCodesController sharedController];
}
- (id)initWithCoder:(NSCoder *)aDecoder;
{
	return [iTM2KeyCodesController sharedController];
}
@end

@implementation _iTM2KeyCodesController
/*
Latest Revision: Sat Jan 30 09:40:05 UTC 2010
*/
- (id)init;
{
	if (self = [super init]) {
		keyCodesForNames = [[NSMutableDictionary dictionary] retain];
		NSArray * RA = [[NSBundle mainBundle] allURLsForResource4iTM3:@"iTM2KeyCodes" withExtension:@"xml"];
		if (RA.count) {
			NSURL * url = [RA objectAtIndex:0];
			NSError * localError = nil;
			NSXMLDocument * doc = [[[NSXMLDocument alloc] initWithContentsOfURL:url options:0 error:&localError] autorelease];
			if (localError) {
				[SDC presentError:localError];
			} else {
				NSArray * nodes = [doc nodesForXPath:@"/*/KEY" error:&localError];
				if (localError) {
					[SDC presentError:localError];
				} else {
					for (id O in nodes) {
                        //  O is a node
						NSString * KEY = [O stringValue];//case sensitive
						if (KEY.length) {
							if (O = [O attributeForName:@"CODE"]) {
                                //  O is an element
								NSString * stringCode = [O stringValue];
								NSScanner * scanner = [NSScanner scannerWithString:stringCode];
								unsigned int code = 0;
								if ([scanner scanHexInt:&code]) {
									NSString * codeValue = [NSString stringWithFormat:@"%C",code];
									[keyCodesForNames setObject:codeValue forKey:KEY];
								}
							}
						}
					}
					LOG4iTM3(@"availableKeyCodes are: %@", keyCodesForNames);
				}
			}
		}
	}
	return self;
}
- (NSArray *)orderedCodeNames;
{
	if (orderedCodeNames)
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
	for (NSString * codeName in orderedCodeNames)
	{
		NSString * localized = [self localizedNameForCodeName:codeName];
		if ([localized isEqual:localizedName])
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
	if ([value isKindOfClass:[NSArray class]])
	{
		NSMutableArray * result = [NSMutableArray array];
		for (id transformedValue in value) {
			[result addObject:([self transformedValue:transformedValue]?:transformedValue)];
		}
		return result;
	}
	return [KCC localizedNameForCodeName:value];
}
- (id)reverseTransformedValue:(id)value;
{
	if ([value isKindOfClass:[NSArray class]])
	{
		NSMutableArray * result = [NSMutableArray array];
		for (id reverseTransformedValue in value) {
			[result addObject:([self reverseTransformedValue:reverseTransformedValue]?:reverseTransformedValue)];
		}
		return result;
	}
	return [KCC codeNameForLocalizedName:value];
}
@end

@implementation iTM2GenericScriptButton
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= macroMenu
- (NSMenu *)macroMenu;// don't call this "menu"!
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSString * name = NSStringFromClass([self class]);
	NSRange R1 = [name rangeOfString:@"Script"];
	if (R1.length)
	{
		NSRange R2 = [name rangeOfString:@"Button"];
		if (R2.length && (R1.location += R1.length, (R2.location > R1.location)))
		{
			R1.length = R2.location - R1.location;
			NSString * context = [name substringWithRange:R1];
			NSString * category = [self macroCategory];
			NSString * domain = [self macroDomain];
			NSMenu * M = [SMC macroMenuForContext:context ofCategory:category inDomain:domain error:nil];
			M = [[M deepCopy4iTM3] autorelease];
			// insert a void item for the title
			[M insertItem:[[[NSMenuItem alloc] initWithTitle:@"" action:NULL keyEquivalent:@""] autorelease] atIndex:0];// for the title
			return M;
		}
	}
//END4iTM3;
    return [[[NSMenu alloc] initWithTitle:@""] autorelease];
}

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= awakeFromNib
- (void)awakeFromNib;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[super awakeFromNib];
	[[self retain] autorelease];
	NSView * superview = [self superview];
	[self removeFromSuperviewWithoutNeedingDisplay];
	[superview addSubview:self];
	[DNC addObserver:self selector:@selector(popUpButtonCellWillPopUpNotification:) name:NSPopUpButtonCellWillPopUpNotification object:self.cell];
	[self.cell setAutoenablesItems:YES];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= popUpButtonCellWillPopUpNotification:
- (void)popUpButtonCellWillPopUpNotification:(NSNotification *)notification;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[self setMenu:[self macroMenu]];
	[DNC removeObserver:self];
//END4iTM3;
    return;
}
@end

@implementation NSTextView(iTM2MacroKit_)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  select1stPlaceholder:
- (IBAction)select1stPlaceholder:(id)sender;
/*Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon Jan 10 21:45:41 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    ICURegEx * placeholder = self.stringController4iTM3.placeholderICURegEx;
    if (placeholder.nextMatch) {
        //  a placeholder is found
        NSRange R = placeholder.rangeOfMatch;
        NSRange selectedRange = self.selectedRange;
        if (iTM3EqualRanges(selectedRange,R)) {
            NSString * replacement = [placeholder macroDefaultString4iTM3];
            if (!replacement.length) {
                replacement = [placeholder macroTypeName4iTM3];
            }
            [self insertText:replacement];// replacement = nil
            if ([placeholder nextMatchAfterIndex:self.selectedRange.location]) {
                //  It was the selected placeholder, found another one
                R = placeholder.rangeOfMatch;
            } else {
                return;
            }
        }
        [self setSelectedRange:R];
        [self scrollRangeToVisible:R];
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  selectNextPlaceholder:
- (IBAction)selectNextPlaceholder:(id)sender;
/*Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon Jan 10 21:45:41 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    iTM2StringController * SC = self.stringController4iTM3;
    ICURegEx * escape = SC.escapeICURegEx;
    ICURegEx * placeholder = SC.placeholderICURegEx;
    NSRange selectedRange = self.selectedRange;
    //  1st, unscan all the escaped characters
    NSUInteger i = selectedRange.location + 1;
    NSRange R;
    placeholder.inputString = escape.inputString = self.string;
    while (i && [escape matchesAtIndex:--i extendToTheEnd:NO]) {
        continue;
    }
    if ([placeholder nextMatchAfterIndex:i]) {
        //  a placeholder is found
        R = placeholder.rangeOfMatch;
        if (iTM3EqualRanges(selectedRange,R)) {
            NSString * replacement = [placeholder macroDefaultString4iTM3];
            if (!replacement.length) {
                replacement = [placeholder macroTypeName4iTM3];
            }
            [self insertText:replacement];
            if (!placeholder.nextMatch) {
                return;
            }
        } else {
            [self setSelectedRange:R];
            [self scrollRangeToVisible:R];
            return;
        }
    } else if (![placeholder nextMatchAfterIndex:0]) {
        return;
    }
    //  This was the selected placeholder, find another one
    //  either after the previous 
    R = placeholder.rangeOfMatch;
    [self setSelectedRange:R];
    [self scrollRangeToVisible:R];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  selectPreviousPlaceholder:
- (IBAction)selectPreviousPlaceholder:(id)sender;
/*Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon Jan 10 21:45:41 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    iTM2StringController * SC = self.stringController4iTM3;
    ICURegEx * escape = SC.escapeICURegEx;
    ICURegEx * mark = SC.startPlaceholderMarkICURegEx;
    ICURegEx * placeholder = SC.placeholderICURegEx;
    NSRange selectedRange = self.selectedRange;
	NSUInteger i = selectedRange.location + 1;
    NSRange R;
    mark.inputString = placeholder.inputString = escape.inputString = self.string;
previous_mark:
    while (i) {
        if ([mark matchesAtIndex:--i extendToTheEnd:NO]) {
            //  is it escaped ?
            while (i && [escape matchesAtIndex:--i extendToTheEnd:NO]) {
                if (i && [escape matchesAtIndex:--i extendToTheEnd:NO]) {
                    continue;
                } else {
                    //  This is escaped, find another mark
                    goto previous_mark;
                }
            }
            if ([placeholder matchesAtIndex:i extendToTheEnd:NO]) {
                R = placeholder.rangeOfMatch;
                if (iTM3EqualRanges(selectedRange,R)) {
                    NSString * replacement = [placeholder macroDefaultString4iTM3];
                    if (!replacement.length) {
                        replacement = [placeholder macroTypeName4iTM3];
                    }
                    [self insertText:replacement];
                } else {
                    [self setSelectedRange:R];
                    [self scrollRangeToVisible:R];
                    return;
                }
            }
        }
    }
    //  cycling from the end
    i = self.string.length;
previous_mark_bis:
    while (i > selectedRange.location) {
        if ([mark matchesAtIndex:--i extendToTheEnd:NO]) {
            //  is it escaped ?
            while (i && [escape matchesAtIndex:--i extendToTheEnd:NO]) {
                if (i && [escape matchesAtIndex:--i extendToTheEnd:NO]) {
                    continue;
                } else {
                    //  This is escaped, find another mark
                    goto previous_mark_bis;
                }
            }
            if ([placeholder matchesAtIndex:i extendToTheEnd:NO]) {
                R = placeholder.rangeOfMatch;
                [self setSelectedRange:R];
                [self scrollRangeToVisible:R];
            }
        }
    }
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  cachedSelection
- (NSString *)cachedSelection;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (1.0.10)
- 1.2: 06/24/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [[self string] substringWithRange:[self selectedRange]];
}
@end

@implementation iTM2TextInspector(MacroKit)
#pragma mark =-=-=-=-=-  MACROS
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= defaultMacroDomain
- (NSString *)defaultMacroDomain;
{
    return @"Text";
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= defaultMacroCategory
- (NSString *)defaultMacroCategory;
{
    return @"";
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= defaultMacroContext
- (NSString *)defaultMacroContext;
{
    return @"";
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= macroDomainKey
- (NSString *)macroDomainKey;
{
    return [[[super macroDomainKey]
			 stringByAppendingPathExtension:[[self class] inspectorMode]]
			stringByAppendingPathExtension:[[self class] inspectorType4iTM3]];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= macroCategoryKey
- (NSString *)macroCategoryKey;
{
    return [[[super macroCategoryKey]
			 stringByAppendingPathExtension:[[self class] inspectorMode]]
			stringByAppendingPathExtension:[[self class] inspectorType4iTM3]];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= macroContextKey
- (NSString *)macroContextKey;
{
    return [[[super macroContextKey]
			 stringByAppendingPathExtension:[[self class] inspectorMode]]
			stringByAppendingPathExtension:[[self class] inspectorType4iTM3]];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setupMacroWindowWillLoad4iTM3
- (void)setupMacroWindowWillLoad4iTM3;
/*"You will be able to remove this when the macroDomain is retrieved properly by objects.
 Version history: jlaurens AT users DOT sourceforge DOT net
 - 2.0: Tue May  3 16:20:26 GMT 2005
 To Do List:
 "*/
{DIAGNOSTIC4iTM3;
	//START4iTM3;
	NSString * key = [self macroDomainKey];
	NSString * macroDomain = [self context4iTM3StringForKey:key domain:iTM2ContextPrivateMask];
	if (!macroDomain.length)
	{
		macroDomain = [self defaultMacroDomain];
		[self setMacroDomain:macroDomain];
	}
	key = [self macroCategoryKey];
	NSString * macroCategory = [self context4iTM3StringForKey:key domain:iTM2ContextPrivateMask];
	if (!macroCategory.length)
	{
		macroCategory = [self defaultMacroCategory];
		[self setMacroCategory:macroCategory];
	}
	key = [self macroContextKey];
	NSString * macroContext = [self context4iTM3StringForKey:key domain:iTM2ContextPrivateMask];
	if (!macroContext)
	{
		macroContext = [self defaultMacroContext];
		[self setMacroContext:macroContext];
	}
	//END4iTM3;
    return;
}
@end