/*
//
//  @version Subversion: $Id: iTM2KeyBindingsKit.m 795 2009-10-11 15:29:16Z jlaurens $ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Mon Oct 6 11 2003.
//  Copyright © 2003 Laurens'Tribune. All rights reserved.
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

//

#import "iTM2TreeKit.h"
#import "iTM2Runtime.h"
#import "iTM2BundleKit.h"
#import "iTM2PathUtilities.h"
#import "iTM2InstallationKit.h"
#import "iTM2Implementation.h"
#import "iTM2ResponderKit.h"
#import "iTM2ContextKit.h"
#import "iTM2DocumentKit.h"

#import "iTM2MacroKit.h"
#import "iTM2MacroKit_Tree.h"
#import "iTM2KeyBindingsKit.h"


#define TABLE @"iTM2KeyBindingsKit"

NSString * const iTM2SelectorMapExtension = @"selectorMap";// Default system name
NSString * const iTM2KeyBindingsIdentifierKey = @"iTM2KeyBindingsIdentifier";
NSString * const iTM2TextKeyBindingsIdentifier = @"Text";
NSString * const iTM2PDFKeyBindingsIdentifier = @"PDF";
NSString * const iTM2NoKeyBindingsIdentifier = @"iTM2NoKeyBindings";
NSString * const iTM2KeyStrokeIntervalKey = @"iTM2KeyStrokeInterval";

@interface NSObject(iTM2KeyBindingsKit)
- (void)postNotificationWithStatus4iTM3:(NSString *)status;
@end

@interface NSResponder(PRIVATE)
- (void)cleanSelectionCache4iTM3:(id)irrelevant;
@end

static NSCharacterSet * KeyStroke_CharacterSet4iTM3 = nil;
static NSMapTable * KeyStroke_Selectors4iTM3 = nil;
static NSMutableArray * KeyStroke_Unmapped4iTM3 = nil;
static NSMutableDictionary * KeyStroke_Bases4iTM3 = nil;
static NSMutableDictionary * KeyStroke_Events4iTM3 = nil;
static NSMapTable * KeyStroke_Timers4iTM3 = nil;

@interface iTM2KeyBindingsManager(PRIVATE)
+ (id)getKeyBindingsForIdentifier:(NSString *)identifier;
+ (void)setKeyBindings:(id)keyBindings forIdentifier:(NSString *)identifier;
+ (id)getSelectorMapForIdentifier:(NSString *)identifier;
+ (void)setSelectorMap:(id)selectorMap forIdentifier:(NSString *)identifier;
@end

@implementation iTM2MainInstaller(iTM2KeyBindingsKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  iTM2KeyBindingsKitCompleteInstallation
+ (void)iTM2KeyBindingsKitCompleteInstallation;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[iTM2KeyBindingsManager class];
//END4iTM3;
}
@end

@interface NSObject(iTM2MacroRootNode_PRIVATE)
- (id)keyBindingTree;
- (id)objectInChildrenWithDomain:(NSString *)key;
- (id)objectInChildrenWithCategory:(NSString *)key;
- (id)objectInChildrenWithContext:(NSString *)key;
- (id)objectInChildrenWithAltKey:(NSString *)key;
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  iTM2KeyBindingsManager
/*"Description forthcoming. This input manager does not make use of #{doCommandBySelector:}"*/
@implementation iTM2KeyBindingsManager
static NSMutableDictionary * _iTM2_KeyBindings_Dictionary = nil;
static NSMutableDictionary * _iTM2_SelectorMap_Dictionary = nil;
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  load
+ (void)load
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{DIAGNOSTIC4iTM3;
    INIT_POOL4iTM3;
//START4iTM3;
	[NSText swizzleInstanceMethodSelector4iTM3:@selector(SWZ_iTM2KeyBindings_performKeyEquivalent:) error:NULL];
	[NSText swizzleInstanceMethodSelector4iTM3:@selector(SWZ_iTM2KeyBindings_interpretKeyEvents:) error:NULL];
	[NSWindow swizzleInstanceMethodSelector4iTM3:@selector(SWZ_iTM2KeyBindings_performMnemonic:) error:NULL];
	[NSResponder swizzleInstanceMethodSelector4iTM3:@selector(SWZ_iTM2KeyBindings_performKeyEquivalent:) error:NULL];
	[NSResponder swizzleInstanceMethodSelector4iTM3:@selector(SWZ_iTM2KeyBindings_performMnemonic:) error:NULL];
//START4iTM3;
    RELEASE_POOL4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  initialize
+ (void)initialize
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [super initialize];
    if ([SUD boolForKey:@"iTM2-Text:NoKeyBindings"])
    {
        LOG4iTM3(@"Key bindings are not available...\nYou can enable them by running from the terminal the following command:\nterminal%% defaults delete \'comp.text.tex.iTeXMac2\' \"%@\"", @"iTM2-Text:NoKeyBindings");
    }
    else if (![_iTM2_KeyBindings_Dictionary isKindOfClass:[NSMutableDictionary class]])
    {
        _iTM2_KeyBindings_Dictionary = [NSMutableDictionary dictionary];
        _iTM2_SelectorMap_Dictionary = [NSMutableDictionary dictionary];
        KeyStroke_CharacterSet4iTM3 = [NSCharacterSet characterSetWithCharactersInString:
									   @"_0123456789azertyuiopqsdfghjklmwxcvbnAZERTYUIOPQSDFGHJKLMWXCVBN"];
        if (!KeyStroke_Bases4iTM3)
            KeyStroke_Bases4iTM3 = [NSMutableDictionary dictionary];
        KeyStroke_Selectors4iTM3 = [NSMapTable mapTableWithKeyOptions:NSMapTableCopyIn
														 valueOptions:NSPointerFunctionsOpaqueMemory|NSPointerFunctionsOpaquePersonality];
        KeyStroke_Unmapped4iTM3 = [NSMutableArray array];
        KeyStroke_Events4iTM3 = [NSMapTable mapTableWithKeyOptions:NSMapTableZeroingWeakMemory|NSMapTableObjectPointerPersonality
													  valueOptions:NSMapTableStrongMemory];
        KeyStroke_Timers4iTM3 = [NSMapTable mapTableWithKeyOptions:NSMapTableZeroingWeakMemory|NSMapTableObjectPointerPersonality
													  valueOptions:NSMapTableStrongMemory];

        [SUD registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:
                    [NSNumber numberWithFloat:5.0], iTM2KeyStrokeIntervalKey,
                            nil]];
        // beware with old LOG4iTM3 versions: the sequel forces +initialize...
        LOG4iTM3(@"I am pleased to announce you that key bindings are available...\nIf this causes you any harm, you can disable them by running from the terminal the following commands:\nterminal%% defaults write \'comp.text.tex.iTeXMac2\' \"%@\" \"YES\"", @"iTM2-Text:NoKeyBindings");
		[SUD registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:
			@"^~w", @"iTM2KeyBindingsDeepEscape", @"^w", @"iTM2KeyBindingsEscape", nil]];
		NSString * path = [[NSBundle bundleForClass:[iTM2KeyBindingsManager class]] pathForResource:@"iTM2KeyStrokeSelectors" ofType:@"plist"];
		NSDictionary * D = [NSDictionary dictionaryWithContentsOfFile:path];
		if (D)
			[self addKeyStrokeSelectorsFromDictionary:D];
		else
		{
			LOG4iTM3(@"WARNING: Missing or corrupted iTM2KeyStrokeSelectors.plist, please reinstall and if it persists, report bug");
		}
    }
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  addKeyStrokeSelectorsFromDictionary
+ (void)addKeyStrokeSelectorsFromDictionary:(NSDictionary *)D;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (!KeyStroke_CharacterSet4iTM3)
    {
        LOG4iTM3(@"Key bindings are not available, see the above note to activate them...");
        return;
    }
//LOG4iTM3(@"D is: %@", D);
    NSMutableDictionary * MD = [KeyStroke_Bases4iTM3 mutableCopy];
    NSCharacterSet * nonCSet = [KeyStroke_CharacterSet4iTM3 invertedSet];
    NSCharacterSet * nonHexaSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789abcdef"] invertedSet];
    NSCharacterSet * nonZeroSet = [[NSCharacterSet characterSetWithCharactersInString:@"0"] invertedSet];
    NSEnumerator * E = [D keyEnumerator];
    NSString * k;
    while(k = [E nextObject])
        if ([k isKindOfClass:[NSString class]])
        {
            k = [k lowercaseString];
            NSRange R = [k rangeOfCharacterFromSet:nonHexaSet];
            if (!R.length)
            {
                R = [k rangeOfCharacterFromSet:nonZeroSet];
                if (R.length)
                {
                    if (R.location)
                    {
                        R.length = k.length - R.location;
                        k = [k substringWithRange:R];
                    }
                    // k is acceptable.
                    id v = [D objectForKey:k];
                    if ([v isKindOfClass:[NSString class]])
                    {
                        R = [k rangeOfCharacterFromSet:nonCSet];
                        if (!R.length)
                        {
                            // v is acceptable.
                            [MD setObject:v forKey:k];
                        }
                        else
                        {
                            LOG4iTM3(@"Unexpected value: %@", v);
                        }
                    }
                    else
                    {
                        LOG4iTM3(@"Unexpected value class: %@", v);
                    }
                }
            }
        }
        else
        {
            LOG4iTM3(@"Unexpected key class: %@", k);
        }
    KeyStroke_Bases4iTM3 = [MD copy];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  registerKeyBindingsForIdentifier:
+ (void)registerKeyBindingsForIdentifier:(NSString *)identifier;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Sat Jan 30 09:35:11 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (!identifier.length) {
		return;
    }
	if (iTM2DebugEnabled) {
		LOG4iTM3(@"identifier: %@", identifier);
	}
	NSString * shorterIdentifier = identifier.stringByDeletingLastPathComponent;
	NSMutableDictionary * keyBindings = [NSMutableDictionary dictionary];
	NSMutableDictionary * selectorMap = [NSMutableDictionary dictionary];
	if (shorterIdentifier.length < identifier.length) {
		[self registerKeyBindingsForIdentifier:shorterIdentifier];
		[keyBindings addEntriesFromDictionary:[self keyBindingsForIdentifier:shorterIdentifier]];
		[selectorMap addEntriesFromDictionary:[self selectorMapForIdentifier:shorterIdentifier]];
	}
	NSDictionary * D;
	NSBundle * MB = [NSBundle mainBundle];
	NSArray * RA = [MB allURLsForResource4iTM3:identifier withExtension:iTM2KeyBindingPathExtension subdirectory:iTM2MacroControllerComponent];
	NSURL * url;
	for (url in [RA reverseObjectEnumerator]) {
		if (D = [NSDictionary dictionaryWithContentsOfURL:url]) {
			[keyBindings addEntriesFromDictionary:D];
		} else if (iTM2DebugEnabled) {
			LOG4iTM3(@"???  No key bindings at url: %@, please report incident", url);
		}
	}
	RA = [MB allURLsForResource4iTM3:identifier withExtension:iTM2SelectorMapExtension subdirectory:iTM2MacroControllerComponent];
	for (url in [RA reverseObjectEnumerator]) {
		if (D = [NSDictionary dictionaryWithContentsOfURL:url]) {
			[selectorMap addEntriesFromDictionary:D];
		} else if (iTM2DebugEnabled) {
			LOG4iTM3(@"No selector map at url: %@", url);
		}
	}
	if (keyBindings.count) {
		[self setKeyBindings:[NSDictionary dictionaryWithDictionary:keyBindings] forIdentifier:identifier];
		if (iTM2DebugEnabled) {
			LOG4iTM3(@"key bindings: %@", keyBindings);
		}
	} else if (iTM2DebugEnabled) {
		LOG4iTM3(@"No key bindings found");
	}
	if (selectorMap.count) {
		[self setSelectorMap:[NSDictionary dictionaryWithDictionary:selectorMap] forIdentifier:identifier];
		if (iTM2DebugEnabled) {
			LOG4iTM3(@"selector map: %@", selectorMap);
		}
	} else if (iTM2DebugEnabled) {
		LOG4iTM3(@"No selector map found");
	}
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  keyBindingsForIdentifier:
+ (id)keyBindingsForIdentifier:(NSString *)identifier;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (!identifier.length)
        return nil;
    id result;
    if (result = [self getKeyBindingsForIdentifier:identifier])
        return result;
    if ([identifier hasPrefix:@"./"])
    {
        // these are absolute paths (or relative to absolute locations...)
        #warning THE PROJECT HERE? foo.texp/Frontends/main bundle identifier/iTM2MacroControllerComponent/identifier
        NSString * dirName = [[[SDC currentDocument] fileName] stringByDeletingLastPathComponent];
        NSString * helperIdentifier = identifier;
        NSString * key;
shorter:
        key = [[dirName stringByAppendingPathComponent:helperIdentifier] stringByStandardizingPath];
        if (!(result = [NSDictionary dictionaryWithContentsOfFile:key]))
        {
            NSString * newIdentifier = helperIdentifier.stringByDeletingLastPathComponent;
            if (newIdentifier.length < helperIdentifier.length)
            {
                if (result = [self getKeyBindingsForIdentifier:newIdentifier])
                    return result;
                helperIdentifier = newIdentifier;
                goto shorter;
            }
            LOG4iTM3(@"Could not find a key binding dictionary at path %@.\nIdentifier %@ ignored (1).", key, identifier);
            result = [NSDictionary dictionary];
        }
        [self setKeyBindings:result forIdentifier:identifier];
        return result;
    }
    else if ([identifier hasPrefix:@"~"] || [identifier hasPrefix:@"/"])
    {
        // these are absolute paths (or relative to absolute locations...)
        NSString * key = [identifier stringByStandardizingPath];
        NSString * helperKey = key;
otherShorter:
        if (result = [self getKeyBindingsForIdentifier:key])
            return result;
        if (!(result = [NSDictionary dictionaryWithContentsOfFile:key]))
        {
            NSString * newKey = helperKey.stringByDeletingPathExtension;
            if (newKey.length < helperKey.length)
            {
                if (result = [self getKeyBindingsForIdentifier:newKey])
                    return result;
                helperKey = newKey;
                goto otherShorter;
            }
            LOG4iTM3(@"Could not find a key binding dictionary at path %@.\nkey %@ ignored (2).", key, identifier);
            result = [NSDictionary dictionary];
        }
        [self setKeyBindings:result forIdentifier:identifier];
        return result;
    }
	if (result = [self getKeyBindingsForIdentifier:identifier])
		return result;
	[self setKeyBindings:nil forIdentifier:identifier];
//END4iTM3;
    return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  getKeyBindingsForIdentifier:
+ (id)getKeyBindingsForIdentifier:(NSString *)identifier;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
	return [_iTM2_KeyBindings_Dictionary objectForKey:identifier];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  getKeyBindings:forIdentifier:
+ (void)setKeyBindings:(id)keyBindings forIdentifier:(NSString *)identifier;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (keyBindings)
		[_iTM2_KeyBindings_Dictionary setObject:keyBindings forKey:identifier];
	else
		[_iTM2_KeyBindings_Dictionary removeObjectForKey:identifier];
//END4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  selectorMapForIdentifier:
+ (id)selectorMapForIdentifier:(NSString *)identifier;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (!identifier.length)
        return [NSDictionary dictionary];
    id result;
    if (result = [self getSelectorMapForIdentifier:identifier])
        return result;
//END4iTM3;
    return [NSDictionary dictionary];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  getSelectorMapForIdentifier:
+ (id)getSelectorMapForIdentifier:(NSString *)identifier;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
	return [_iTM2_SelectorMap_Dictionary objectForKey:identifier];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  setSelectorMap:forIdentifier:
+ (void)setSelectorMap:(id)selectorMap forIdentifier:(NSString *)identifier;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (selectorMap)
		[_iTM2_SelectorMap_Dictionary setObject:selectorMap forKey:identifier];
	else
		[_iTM2_SelectorMap_Dictionary removeObjectForKey:identifier];
//END4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  initWithIdentifier:handleKeyBindings:handleKeyStrokes:
- (id)initWithIdentifier:(NSString *)identifier handleKeyBindings:(BOOL)handleKeyBindings handleKeyStrokes:(BOOL)handleKeyStrokes;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (self = [super init])
    {
        _SM = [[[self class] selectorMapForIdentifier:identifier] retain];
        _KBS = [NSMutableArray array];
		_iTM2IMFlags.handlesKeyStrokes = handleKeyStrokes? 1: ZER0;
		_iTM2IMFlags.handlesKeyBindings = handleKeyBindings? 1: ZER0;
		if (iTM2DebugEnabled)
		{
			LOG4iTM3(@"Identifier is: %@", identifier);
		}
    }
    return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  description
- (NSString *)description;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
	return [NSString stringWithFormat:@"<%@ %#x, handleKeyBindings:%@, handlesKeyStrokes:%@>",
		NSStringFromClass(self.class), self, (_iTM2IMFlags.handlesKeyBindings? @"Y":@"N"), (_iTM2IMFlags.handlesKeyStrokes? @"Y":@"N")];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  currentKey
- (NSString *)currentKey;
/*"Description forthcoming. Lazy initializer: the root key binding is returned when nothing else is available
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return _CK? _CK: (_CK = [NSString string]);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  selectorMap
- (NSDictionary *)selectorMap;
/*"Description forthcoming. Lazy initializer: the root key binding is returned when nothing else is available
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return _SM;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  setCurrentKey:
- (void)setCurrentKey:(NSString *)argument;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
 //NSLog(@"setCurrentKey: %@ %x", argument, (argument.length? [argument characterAtIndex:argument.length-1]:ZER0));
    _CK = [argument copy];
	if (iTM2DebugEnabled)
	{
		LOG4iTM3(@"The current key is: %@ (%#x)", _CK, (_CK.length? [_CK characterAtIndex:ZER0]:ZER0));
	}
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  currentKeyBindingsOfClient:
- (id)currentKeyBindingsOfClient:(id)client;
/*"Description forthcoming. Lazy initializer: the root key binding is returned when nothing else is available
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
	return [_KBS lastObject]?:[client rootKeyBindings];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  setCurrentKeyBindings:
- (void)setCurrentKeyBindings:(id)keyBindings;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if ([keyBindings countOfChildren])
    {
        [_KBS addObject:keyBindings];
#warning DEBUG NYI: this is a problem
#if 0
        {
            id V = [keyBindings objectForKey:@"permanent"];
            _iTM2IMFlags.isPermanent = [V respondsToSelector:@selector(boolValue)] && [V boolValue]? 1:ZER0;
        }
#endif
        _iTM2IMFlags.canEscape = ZER0;
#if 0
        {
            NSString * toolTip = [keyBindings objectForKey:@"toolTip"];
            [self postNotificationWithStatus4iTM3:
                    ([toolTip isKindOfClass:[NSString class]]? toolTip:[NSString string])];
    //                if ([toolTip isKindOfClass:[NSString class]] && toolTip.length)
    //                    [self postNotificationWithStatus4iTM3:toolTip];
        }
#endif
    }
	else if (!keyBindings)
	{
		[_KBS removeAllObjects];
	}
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  setCurrentClient:
- (void)setCurrentClient:(id)client;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (_CC != client)
    {
        _CC = client;
        [self postNotificationWithStatus4iTM3:nil];
        [_KBS removeAllObjects];
    }
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  escapeCurrentKeyBindingsIfAllowed
- (void)escapeCurrentKeyBindingsIfAllowed;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.2: 06/20/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
 //NSLog(@"escapeCurrentKeyBindingsIfAllowed");
    if (_iTM2IMFlags.canEscape)
    {
        while((_KBS.count > ZER0) && (!_iTM2IMFlags.isPermanent))
        {
            [_KBS removeLastObject];
#if 0
            {
                id V = [[_KBS lastObject] objectForKey:@"permanent"];
                _iTM2IMFlags.isPermanent = [V respondsToSelector:@selector(boolValue)] && [V boolValue]? 1:ZER0;
            }
#endif
        }
#if 0
        {
            NSString * toolTip = [[self currentKeyBindings] objectForKey:@"toolTip"];
            [self postNotificationWithStatus4iTM3:
                    ([toolTip isKindOfClass:[NSString class]]? toolTip:[NSString string])];
//                if ([toolTip isKindOfClass:[NSString class]] && toolTip.length)
//                    [self postNotificationWithStatus4iTM3:toolTip];
        }
#endif
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  client:performKeyEquivalent:
- (BOOL)client:(id)C performKeyEquivalent:(NSEvent *)theEvent;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//NSLog(@"C: %#x", C);
    if ([theEvent type] == NSKeyDown)
    {
        [self setCurrentClient:C];
//NSLog(@"[theEvent charactersIgnoringModifiers]:%@", [theEvent charactersIgnoringModifiers]);
//NSLog(@"[theEvent characters]:%@", [theEvent characters]);
		iTM2KeyStroke * KS = [iTM2KeyStroke keyStrokeWithEvent:theEvent];
		if (!KS)
		{
			return NO;
		}
		NSString * key = [KS key];
		if ([key isEqualToString:[C context4iTM3ValueForKey:@"iTM2KeyBindingsDeepEscape" domain:iTM2ContextAllDomainsMask]])
		{
			[self toggleDeepEscape:self];
			return YES;
		}
		else if ([key isEqualToString:[C context4iTM3ValueForKey:@"iTM2KeyBindingsEscape" domain:iTM2ContextAllDomainsMask]])
		{
			[self toggleEscape:self];
			return YES;
		}
		_iTM2IMFlags.canEscape = -1;
		return [self client:C interpretKeyEvent:theEvent];
    }
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  client:performMnemonic:
- (BOOL)client:(id)C performMnemonic:(NSString *)theString;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//NSLog(@"C: %#x", C);
//LOG4iTM3(@"theString: %@", theString);
    [self setCurrentClient:C];
    NSEvent * theEvent = [([C respondsToSelector:@selector(currentEvent)]? C:
            ([C respondsToSelector:@selector(window)]?[C window]:NSApp)) currentEvent];
    if (theString.length)
    {
        NSUInteger flags = [[NSApp currentEvent] modifierFlags];
        unichar U = [theString characterAtIndex:ZER0];
		NSString * unmodifiedCharacters = [NSString stringWithCharacters:&U length:1];
        NSString * key = [NSString stringWithFormat:@"%@%@%@%@%@",
                    (flags & NSCommandKeyMask? @"@": @""),
                    (flags & NSControlKeyMask? @"^": @""),
                    (flags & NSAlternateKeyMask? @"~": @""),
                    (flags & NSShiftKeyMask? @"$": @""),
                    unmodifiedCharacters];
        if ([key isEqualToString:[C context4iTM3ValueForKey:@"iTM2KeyBindingsDeepEscape" domain:iTM2ContextAllDomainsMask]])
        {
            [self toggleDeepEscape:self];
            return YES;
        }
        else if ([key isEqualToString:[C context4iTM3ValueForKey:@"iTM2KeyBindingsEscape" domain:iTM2ContextAllDomainsMask]])
        {
            [self toggleEscape:self];
            return YES;
        }
        U = [theString characterAtIndex:ZER0];
        key = [NSString stringWithFormat:@"%@%@%@",
                    (flags & NSCommandKeyMask? @"@": @""),
                    (flags & NSControlKeyMask? @"^": @""),
                    unmodifiedCharacters];
        if ([key isEqualToString:[C context4iTM3ValueForKey:@"iTM2KeyBindingsDeepEscape" domain:iTM2ContextAllDomainsMask]])
        {
            [self toggleDeepEscape:self];
            return YES;
        }
        else if ([key isEqualToString:[C context4iTM3ValueForKey:@"iTM2KeyBindingsEscape" domain:iTM2ContextAllDomainsMask]])
        {
            [self toggleEscape:self];
            return YES;
        }
        _iTM2IMFlags.canEscape = -1;
		BOOL result = [self client:C interpretKeyEvent:theEvent];
        return result;
    }
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  client:executeBindingForKeyStroke:
- (BOOL)client:(id)C executeBindingForKeyStroke:(iTM2KeyStroke *)keyStroke;
/*"Description forthcoming.
If the event is a 1 char key down, it will ask the current key binding for instruction.
The key and its modifiers are 
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
#warning FAILED 7 bits accents support is missing
//STOP4iTM3;
	return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  client:interpretKeyEvent:
- (BOOL)client:(id)C interpretKeyEvent:(NSEvent *)theEvent;
/*"Description forthcoming.
If the event is a 1 char key down, it will ask the current key binding for instruction.
The key and its modifiers are 
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	iTM2KeyStroke * KS = [iTM2KeyStroke keyStrokeWithEvent:theEvent];
	if (!KS)
	{
		// this was a dead key
		return NO;
	}
    [self setCurrentClient:C];
	if (!_iTM2IMFlags.isDeepEscaped && !_iTM2IMFlags.isEscaped)
	{
		if ([C handlesKeyBindings4iTM3])
		{
			if ([self client:C executeBindingForKeyStroke:KS])// early entry point for 7bits accents
			{
				return YES;
			}
			id CKB = [self currentKeyBindingsOfClient:C];
			id keyBinding = [CKB objectInChildrenWithKeyStroke:KS];
			if ([keyBinding countOfChildren]>ZER0)
			{
				// down a level
				[self setCurrentKeyBindings:keyBinding];// this is where we wait for a further key stroke
				if ([C respondsToSelector:@selector(cleanSelectionCache4iTM3:)])
				{
					[C cleanSelectionCache4iTM3:self];
				}
				return YES;
			}
			else if (keyBinding)
			{
				_iTM2IMFlags.isEscaped = ZER0;
				_iTM2IMFlags.canEscape = 1;
				iTM2MacroNode * macro = [C macroWithID:[keyBinding macroID]];
				if (macro)
				{
					// is there a dead key around?
					if ([C respondsToSelector:@selector(hasMarkedText)]  && [C hasMarkedText])
					{
						[C deleteBackward:nil];// this is the only mean I found to properly manage the undo stack
					}
					if ([macro executeMacroWithTarget:C selector:NULL substitutions:nil])
					{
#warning ! FAILED: missing the escape key bindings stuff
						[self setCurrentKeyBindings:nil];// do not forget this, in order to to 
						return YES;
					}
				}
				return NO;
			}
			[self setCurrentKeyBindings:nil];
		}
		_iTM2IMFlags.isEscaped = ZER0;
		_iTM2IMFlags.canEscape = 1;
		if ([C isKindOfClass:[NSResponder class]])
//                    else if (_iTM2IMFlags.handlesKeyStrokes && [C isKindOfClass:[NSResponder class]])
		{
			NSString * characters = [theEvent characters];
			return [C interpretKeyStroke4iTM3:characters];
		}
		else
		{
			return NO;
		}
	}
    _iTM2IMFlags.isEscaped = ZER0;
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleEscape:
- (IBAction)toggleEscape:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu May 13 21:02:03 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (_iTM2IMFlags.isDeepEscaped == ZER0)
    {
        if (_iTM2IMFlags.isEscaped != ZER0)
        {
            [self postNotificationWithStatus4iTM3:nil];
            _iTM2IMFlags.isEscaped = ZER0;
        }
        else if (_KBS.count)
        {
            [_KBS removeLastObject];
            [self postNotificationWithStatus4iTM3:[[_KBS lastObject] objectForKey:@"toolTip"]];
        }
        else
        {
            [self postNotificationWithStatus4iTM3:
                NSLocalizedStringFromTableInBundle(@"Escaped mode.", TABLE,
                    myBUNDLE, "status displayed when the escaped key is pressed")];
            _iTM2IMFlags.isEscaped = -1;
        }
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleDeepEscape:
- (IBAction)toggleDeepEscape:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu May 13 21:02:03 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (_iTM2IMFlags.isDeepEscaped != ZER0)
    {
        [self postNotificationWithStatus4iTM3:nil];
        _iTM2IMFlags.isDeepEscaped = ZER0;
    }
    else if (_KBS.count)
    {
        [self postNotificationWithStatus4iTM3:nil];
        [_KBS removeAllObjects];
    }
    else
    {
        [self postNotificationWithStatus4iTM3:
            NSLocalizedStringFromTableInBundle(@"Deep Escaped mode.", TABLE,
                myBUNDLE, "status displayed when the ctrl + escaped key are pressed")];
        _iTM2IMFlags.isDeepEscaped = -1;
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  loadKeyBindingsAtPath:
- (IBAction)loadKeyBindingsAtPath:(NSString *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu May 13 21:02:03 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    LOG4iTM3(@"loading: %@", sender);
    if ([sender isKindOfClass:[NSString class]]) {
        NSDictionary * result = [self.class keyBindingsForIdentifier:sender];
        if (result.count)
        {
            NSString * toolTip = [result objectForKey:@"toolTip"];
            if (![toolTip isKindOfClass:[NSString class]])
                toolTip = [NSString stringWithFormat:@"Loading %@",
                    sender.lastPathComponent.stringByDeletingPathExtension];
            [self postNotificationWithStatus4iTM3:toolTip];
            [self setCurrentKeyBindings:result];
            return;
        }
        [self postNotificationWithStatus4iTM3:[NSString stringWithFormat:@"Nothing at:%@", sender]];
        LOG4iTM3(@"bad file at: %@ (relative path)", sender);
        NSBeep();
        return;
    }
    [self postNotificationWithStatus4iTM3:@"Internal error, ignored"];
    LOG4iTM3(@"bad argument: %@", sender);
    NSBeep();
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  flushKeyBindings:
- (void)flushKeyBindings:(id)irrelevant;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Sun Feb 21 13:17:21 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    _iTM2_KeyBindings_Dictionary = [NSMutableDictionary dictionary];
    [self postNotificationWithStatus4iTM3:
        [NSString stringWithFormat:NSLocalizedStringFromTableInBundle
            (@"Flushing Key Bindings.", TABLE, myBUNDLE, "status info format, no object placeholder"), nil]];
    _iTM2IMFlags.canEscape = ZER0;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  postNotificationWithStatus4iTM3:
- (void)postNotificationWithStatus4iTM3:(NSString *)status;
/*"Description forthcoming.
If the event is a 1 char key down, it will ask the current key binding for instruction.
The key and its modifiers are 
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Sun Feb 21 13:17:31 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if ([[self superclass] instancesRespondToSelector:_cmd])
        [super postNotificationWithStatus4iTM3:status];
//END4iTM3;
    return;
}
@synthesize _SM;
@synthesize _KBS;
@synthesize _CK;
@synthesize _CC;
@end

@implementation NSResponder(iTM2KeyBindingsKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= handlesKeyBindings4iTM3
- (BOOL)handlesKeyBindings4iTM3;
/*"YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Dec 15 14:34:51 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  keyBindingsManager4iTM3
- (id)keyBindingsManager4iTM3;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu May 13 21:02:03 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (([self handlesKeyBindings4iTM3] || [self handlesKeyStrokes4iTM3])
        && ![self context4iTM3BoolForKey:iTM2NoKeyBindingsIdentifier domain:iTM2ContextAllDomainsMask])
    {
LOG4iTM3(@"KBM:%@",[self valueForKeyPath:@"implementation.metaValues.KeyBindingsManager4iTM3"]);
		id KBM = metaGETTER;
LOG4iTM3(@"KBM:%@",KBM);
        if (!KBM)
        {
			NSString * identifier = [self macroCategory];
			KBM = [[iTM2KeyBindingsManager alloc]
				   initWithIdentifier:identifier
				   handleKeyBindings:[self handlesKeyBindings4iTM3]
				   handleKeyStrokes:[self handlesKeyStrokes4iTM3]];
            metaSETTER(KBM);
			if (iTM2DebugEnabled > 1000)
			{
				LOG4iTM3(@"Available key binding manager: %@", KBM);
			}
            KBM = metaGETTER;
        }
        return KBM;
    }
    else
        return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  resetKeyBindingsManager4iTM3;
- (void)resetKeyBindingsManager4iTM3;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu May 13 21:02:03 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[self setValue:nil forKeyPath:@"implementation.metaValues.KeyBindingsManager4iTM3"];
	[self keyBindingsManager4iTM3];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  cleanSelectionCache4iTM3:
- (void)cleanSelectionCache4iTM3:(id)irrelevant;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu May 13 21:02:03 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  postNotificationWithStatus4iTM3:
- (void)postNotificationWithStatus4iTM3:(NSString *)status;
/*"Description forthcoming.
If the event is a 1 char key down, it will ask the current key binding for instruction.
The key and its modifiers are 
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if ([[self superclass] instancesRespondToSelector:_cmd])
        [super postNotificationWithStatus4iTM3:status];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= keyStrokeEvents4iTM3
- (id)keyStrokeEvents4iTM3;
/*"YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Dec 15 14:34:51 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    id result = [KeyStroke_Events4iTM3 objectForKey:self];
    if (!result)
    {
        result = [NSMutableArray array];
        [KeyStroke_Events4iTM3 setObject:result forKey:self];
    }
//END4iTM3;
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= keyStrokes4iTM3
- (NSString *)keyStrokes4iTM3;
/*"YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Dec 15 14:34:51 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    id result = [NSMutableString string];
    for(NSEvent * e in [self keyStrokeEvents4iTM3])
        [result appendString:[e characters]];
//LOG4iTM3(@"result is: %@", result);
//END4iTM3;
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= pushKeyStrokeEvent4iTM3:
- (void)pushKeyStrokeEvent4iTM3:(NSEvent *)event;
/*"YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Dec 15 14:34:51 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSTimer * T = [KeyStroke_Timers4iTM3 objectForKey:self];
    [T invalidate];
    [[self keyStrokeEvents4iTM3] addObject:[event copy]];
    T = [NSTimer scheduledTimerWithTimeInterval:[SUD floatForKey:iTM2KeyStrokeIntervalKey]
        target: self selector: @selector(timedFlushKeyStrokeEvents4iTM3:)
            userInfo: nil repeats: NO];
    [KeyStroke_Timers4iTM3 setObject:T forKey:self];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= timedFlushKeyStrokeEvents4iTM3:
- (void)timedFlushKeyStrokeEvents4iTM3:(NSTimer *)timer;
/*"YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Dec 15 14:34:51 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self flushKeyStrokeEvents4iTM3:self];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= flushKeyStrokeEvents4iTM3:
- (void)flushKeyStrokeEvents4iTM3:(id)sender;
/*"YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Dec 15 14:34:51 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (iTM2DebugEnabled)
	{
		LOG4iTM3(@"Nothing left...");
	}
    [KeyStroke_Timers4iTM3 removeObjectForKey:self];
    [[self keyStrokeEvents4iTM3] removeAllObjects];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= flushLastKeyStrokeEvent4iTM3:
- (void)flushLastKeyStrokeEvent4iTM3:(id)sender;
/*"YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Dec 15 14:34:51 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [[self keyStrokeEvents4iTM3] removeLastObject];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= selectorFromKeyStroke:
+ (SEL)selectorFromKeyStroke:(NSString *)key;
/*"YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Dec 15 14:34:51 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//LOG4iTM3(@"entry key is: %@", key);
    if (key.length == 1)
    {
		SEL result = (SEL)NSMapGet(KeyStroke_Selectors4iTM3,key);
		if (iTM2DebugEnabled > 999)
		{
			LOG4iTM3(@"result: %@", result);
		}
		if (result)
			return result;
		if ([KeyStroke_Unmapped4iTM3 containsObject:key])
		{
			return NULL;
		}
        unichar U = [key characterAtIndex:ZER0];
//LOG4iTM3(@"unichar is: %#x(%u)", U, U);
        NSString * base = [KeyStroke_Bases4iTM3 objectForKey:[NSString stringWithFormat:@"%x", U]];
//LOG4iTM3(@"base is: %@", base);
        if (!base)
            if ([KeyStroke_CharacterSet4iTM3 characterIsMember:U])
                base = key;
            else
                switch(U)
                {
                    case 0xa:
                    case 0x3:	base = @"Enter";			break;
                    case 0xd:	base = @"Return";			break;
                    case 0x9:	base = @"HorizontalTab";	break;
                    case 0xb:	base = @"VerticalTab";		break;
                    case 0x7f:
                    case 0x8:	base = @"Backspace";		break;
                    case ' ':	base = @"Space";			break;
                    case '!':	base = @"Exclamation";		break;
                    case '"':	base = @"Quotes";			break;
                    case '#':	base = @"Sharp";			break;
                    case '$':	base = @"Dollar";			break;
                    case '%':	base = @"Percent";			break;
                    case '&':	base = @"Ampersand";		break;
                    case '\'':	base = @"SingleQuote";		break;
                    case '(':	base = @"LeftParenthesis";	break;
                    case ')':	base = @"RightParenthesis";	break;
                    case '*':	base = @"Asterisk";		break;
                    case '+':	base = @"Plus";			break;
                    case ',':	base = @"Comma";		break;
                    case '-':	base = @"Minus";		break;
                    case '.':	base = @"Dot";			break;
                    case '/':	base = @"Solidus";		break;
                    case ':':	base = @"Colon";		break;
                    case ';':	base = @"Semicolon";	break;
                    case '<':	base = @"LessThan";		break;
                    case '=':	base = @"Equals";		break;
                    case '>':	base = @"GreaterThan";	break;
                    case '?':	base = @"Question";		break;
                    case '@':	base = @"At";			break;
                    case '[':	base = @"LeftBracket";	break;
                    case '\\':	base = @"Sudilos";		break;
                    case ']':	base = @"RightBracket";	break;
                    case '^':	base = @"Control";		break;
                    case '`':	base = @"Grave";		break;
                    case '{':	base = @"LeftCurlyBracket";	break;
                    case '|':	base = @"Pipe";				break;
                    case '}':	base = @"RightCurlyBracket";	break;
                    case '~':	base = @"Tilde";			break;
                    case 0x00a1: //¡
									base = @"Noitamalcxe";	break;
                    case 0x00a2: //¢
									base = @"Cent";			break;
                    case 0x00a3: //£
                                    base = @"Pound";		break;
                    case 0x00a4: //¤
                                    base = @"Currency";		break;
                    case 0x00a5: //¥
                                    base = @"Yen";			break;
                    case 0x00a6: //¦
                                    base = @"BrokenPipe";	break;
                    case 0x00a7: //§
                                    base = @"Section";		break;
                    case 0x00a8: //¨
                                    base = @"Diaeresis";	break;
                    case 0x00a9: //©
                                    base = @"Copyright";	break;
                    case 0x00aa: //ª
                                    base = @"Feminine";		break;
                    case 0x00ab: //«
                                    base = @"LeftQuote";	break;
                    case 0x00ac: //¬
                                    base = @"Not";			break;
                    case 0x00ad: //­
                                    base = @"Hyphen";		break;
                    case 0x00ae: //®
                                    base = @"Registered";	break;
                    case 0x00af: //¯
                                    base = @"Macron";		break;
                    case 0x00b0: //°
                                    base = @"Degree";		break;
                    case 0x00b1: //±
                                    base = @"PlusMinus";	break;
                    case 0x00b2: //²
                                    base = @"SuperScript2";	break;
                    case 0x00b3: //³
                                    base = @"SuperScript3";	break;
                    case 0x00b4: //´
                                    base = @"Acute";		break;
                    case 0x00b5: //µ
                                    base = @"Micro";		break;
                    case 0x00b6: //¶
                                    base = @"Pilcrow";		break;
                    case 0x00b7: //·
                                    base = @"MiddleDot";	break;
                    case 0x00b8: //¸
                                    base = @"Cedilla";		break;
                    case 0x00b9: //¹
                                    base = @"SuperScript1";	break;
                    case 0x00ba: //º
                                    base = @"Masculine";	break;
                    case 0x00bb: //»
                                    base = @"RightQuote";	break;
                    case 0x00bc: //¼
                                    base = @"OneQuarter";	break;
                    case 0x00bd: //½
                                    base = @"OneHalf";		break;
                    case 0x00be: //¾
                                    base = @"ThreeQuarters";	break;
                    case 0x00bf: //¿
                                    base = @"Noitseuq";		break;
                    case 0x00d7: //×
                                    base = @"Times";		break;
                    case 0x00f7: //÷
                                    base = @"Division";		break;
                    case NSUpArrowFunctionKey:		base = @"UpArrow";	break;
                    case NSDownArrowFunctionKey:	base = @"DownArrow";	break;
                    case NSLeftArrowFunctionKey:	base = @"LeftArrow";	break;
                    case NSRightArrowFunctionKey:	base = @"RightArrow";	break;
                    case NSF1FunctionKey:		base = @"F1";		break;
                    case NSF2FunctionKey:		base = @"F2";		break;
                    case NSF3FunctionKey:		base = @"F3";		break;
                    case NSF4FunctionKey:		base = @"F4";		break;
                    case NSF5FunctionKey:		base = @"F5";		break;
                    case NSF6FunctionKey:		base = @"F6";		break;
                    case NSF7FunctionKey:		base = @"F7";		break;
                    case NSF8FunctionKey:		base = @"F8";		break;
                    case NSF9FunctionKey:		base = @"F9";		break;
                    case NSF10FunctionKey:		base = @"F10";		break;
                    case NSF11FunctionKey:		base = @"F11";		break;
                    case NSF12FunctionKey:		base = @"F12";		break;
                    case NSF13FunctionKey:		base = @"F13";		break;
                    case NSF14FunctionKey:		base = @"F14";		break;
                    case NSF15FunctionKey:		base = @"F15";		break;
                    case NSF16FunctionKey:		base = @"F16";		break;
                    case NSF17FunctionKey:		base = @"F17";		break;
                    case NSF18FunctionKey:		base = @"F18";		break;
                    case NSF19FunctionKey:		base = @"F19";		break;
                    case NSF20FunctionKey:		base = @"F20";		break;
                    case NSF21FunctionKey:		base = @"F21";		break;
                    case NSF22FunctionKey:		base = @"F22";		break;
                    case NSF23FunctionKey:		base = @"F23";		break;
                    case NSF24FunctionKey:		base = @"F24";		break;
                    case NSF25FunctionKey:		base = @"F25";		break;
                    case NSF26FunctionKey:		base = @"F26";		break;
                    case NSF27FunctionKey:		base = @"F27";		break;
                    case NSF28FunctionKey:		base = @"F28";		break;
                    case NSF29FunctionKey:		base = @"F29";		break;
                    case NSF30FunctionKey:		base = @"F30";		break;
                    case NSF31FunctionKey:		base = @"F31";		break;
                    case NSF32FunctionKey:		base = @"F32";		break;
                    case NSF33FunctionKey:		base = @"F33";		break;
                    case NSF34FunctionKey:		base = @"F34";		break;
                    case NSF35FunctionKey:		base = @"F35";		break;
                    case NSInsertFunctionKey:		base = @"Insert";	break;
                    case NSDeleteFunctionKey:		base = @"Delete";	break;
                    case NSHomeFunctionKey:			base = @"Home";		break;
                    case NSBeginFunctionKey:		base = @"Begin";	break;
                    case NSEndFunctionKey:			base = @"End";		break;
                    case NSPageUpFunctionKey:		base = @"PageUp";	break;
                    case NSPageDownFunctionKey:		base = @"PageDown";	break;
                    case NSPrintScreenFunctionKey:	base = @"PrintScreen";	break;
                    case NSScrollLockFunctionKey:	base = @"ScrollLock";	break;
                    case NSPauseFunctionKey:		base = @"Pause";	break;
                    case NSSysReqFunctionKey:		base = @"SysReq";	break;
                    case NSBreakFunctionKey:		base = @"Break";	break;
                    case NSResetFunctionKey:		base = @"Reset";	break;
                    case NSStopFunctionKey:			base = @"Stop";		break;
                    case NSMenuFunctionKey:			base = @"Menu";		break;
                    case NSUserFunctionKey:			base = @"User";		break;
                    case NSSystemFunctionKey:		base = @"System";	break;
                    case NSPrintFunctionKey:		base = @"Print";	break;
                    case NSClearLineFunctionKey:	base = @"ClearLine";	break;
                    case NSClearDisplayFunctionKey:	base = @"ClearDisplay";	break;
                    case NSInsertLineFunctionKey:	base = @"InsertLine";	break;
                    case NSDeleteLineFunctionKey:	base = @"DeleteLine";	break;
                    case NSInsertCharFunctionKey:	base = @"InsertChar";	break;
                    case NSDeleteCharFunctionKey:	base = @"DeleteChar";	break;
                    case NSPrevFunctionKey:			base = @"Prev";		break;
                    case NSNextFunctionKey:			base = @"Next";		break;
                    case NSSelectFunctionKey:		base = @"Select";	break;
                    case NSExecuteFunctionKey:		base = @"Execute";	break;
                    case NSUndoFunctionKey:			base = @"Undo";		break;
                    case NSRedoFunctionKey:			base = @"Redo";		break;
                    case NSFindFunctionKey:			base = @"Find";		break;
                    case NSHelpFunctionKey:			base = @"Help";		break;
                    case NSModeSwitchFunctionKey:	base = @"ModeSwitch";	break;
                    default:
						if (iTM2DebugEnabled>999)
						{
							LOG4iTM3(@"unmapped key stroke is: %@(%#x)", key, [key characterAtIndex:ZER0]);
						}
						[KeyStroke_Unmapped4iTM3 addObject:[key copy]];
						return NULL;
                }
        NSString * selectorName = [NSString stringWithFormat:@"interpretKeyStroke%@:", base];
		if (iTM2DebugEnabled>999)
		{
			LOG4iTM3(@"selectorName is: %@", selectorName);
		}
        result = NSSelectorFromString(selectorName);
		NSMapInsert(KeyStroke_Selectors4iTM3,key,result);
		return result;
    }
//END4iTM3;
    return NULL;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= interpretKeyStroke4iTM3:
- (BOOL)interpretKeyStroke4iTM3:(NSString *)key;
/*"YES.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Sat Jan 30 16:42:38 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//LOG4iTM3(@"entry key is: %@", key);
    SEL selector = [[self class] selectorFromKeyStroke:key];
//END4iTM3;
	if (!selector) {
		return NO;
    }
	if ([self tryToReallyPerform4iTM3:selector with:nil]) {
		return YES;
    }
	selector = (SEL)[[[[self keyBindingsManager4iTM3] selectorMap] objectForKey:[NSValue valueWithPointer:selector]] pointerValue];
    return selector != NULL && [self tryToReallyPerform4iTM3:selector with:nil];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= tryToReallyPerform4iTM3:with:
- (BOOL)tryToReallyPerform4iTM3:(SEL)action with:(id)argument;
/*"YES.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Sat Jan 30 16:41:51 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSMethodSignature * MS = [self methodSignatureForSelector:action];
    if (MS) {
        NSInvocation * I = [NSInvocation invocationWithMethodSignature:MS];
        [I setSelector:action];
        [I setArgument:&argument atIndex:2];
        NSMethodSignature * myMS = [self methodSignatureForSelector:@selector(__reallyPerformSelectorTemplate4iTM3:)];
        NSMethodSignature * myOtherMS = [self methodSignatureForSelector:@selector(forwardInvocation:)];
        if ([MS isEqual:myMS] || [MS isEqual:myOtherMS]) {
            [I invokeWithTarget:self];
            if ([MS methodReturnLength] >= sizeof(BOOL) ) {
                BOOL result;
                [I getReturnValue:&result];
                return result;
            }
            return YES;
        }
    }
	return [[self nextResponder] tryToReallyPerform4iTM3:action with:argument];
//END4iTM3;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= __reallyPerformSelectorTemplate4iTM3:
- (BOOL)__reallyPerformSelectorTemplate4iTM3:(id)argument;
/*"YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Dec 15 14:34:51 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return NO;
}
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  iTM2KeyBindingsManager


@implementation NSWindowController(iTM2KeyBindingsKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= handlesKeyStrokes4iTM3
- (BOOL)handlesKeyStrokes4iTM3;
/*"YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Dec 15 14:34:51 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return [self.document handlesKeyStrokes4iTM3]
        || (![[self owner] isEqual:self] && [[self owner] handlesKeyStrokes4iTM3]);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= interpretKeyStroke4iTM3:
- (BOOL)interpretKeyStroke4iTM3:(NSString *)key;
/*"YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Dec 15 14:34:51 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return ([self.document handlesKeyStrokes4iTM3] && [self.document interpretKeyStroke4iTM3:key])
        || (![[self owner] isEqual:self] && [[self owner] handlesKeyStrokes4iTM3] && [[self owner] interpretKeyStroke4iTM3:key])
        || [super interpretKeyStroke4iTM3:key];
//END4iTM3;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= pushKeyStroke:
- (void)pushKeyStroke:(id)sender;
/*"YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Dec 15 14:34:51 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[self.window pushKeyStroke:sender];
//END4iTM3;
    return;
}
@end

@implementation NSWindow(iTM2KeyBindingsKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= interpretKeyStroke4iTM3:
- (BOOL)interpretKeyStroke4iTM3:(NSString *)key;
/*"YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Dec 15 14:34:51 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    SEL selector = [self.class selectorFromKeyStroke:key];
    if ([self tryToReallyPerform4iTM3:selector with:nil])
        return YES;
    else if ([self handlesKeyStrokes4iTM3])
    {
		[self pushKeyStroke:key];
		return YES;
    }
//END4iTM3;
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= pushKeyStroke:
- (void)pushKeyStroke:(id)sender;
/*"YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Dec 15 14:34:51 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSEvent * e = [self currentEvent];
	if (!e)
		e = [NSApp currentEvent];
	if ([e type] == NSKeyDown)
	{
		[self pushKeyStrokeEvent4iTM3:e];
	}
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= handlesKeyStrokes4iTM3
- (BOOL)handlesKeyStrokes4iTM3;
/*"YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Dec 15 14:34:51 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return [self.windowController handlesKeyStrokes4iTM3];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= tryToReallyPerform4iTM3:with:
- (BOOL)tryToReallyPerform4iTM3:(SEL)action with:(id)argument;
/*"YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Dec 15 14:34:51 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (!action) {
        return NO;
    }
    NSMethodSignature * MS = [self methodSignatureForSelector:action];
    NSInvocation * I = nil;
    if (MS.numberOfArguments == 3) {
        I = [NSInvocation invocationWithMethodSignature:MS];
        [I setSelector:action];
        [I setArgument:&argument atIndex:2];
        [I invokeWithTarget:self];
        if (MS.methodReturnLength > sizeof(BOOL)) {
            BOOL result;
            [I getReturnValue:&result];
            return result;
        }
        return YES;
    }
    if ([[self nextResponder] tryToReallyPerform4iTM3:action with:argument]) {
        return YES;
    }
    
    MS = [(id)[self delegate] methodSignatureForSelector:action];
    if (MS.numberOfArguments == 3) {
        I = [NSInvocation invocationWithMethodSignature:MS];
        [I setSelector:action];
        [I setArgument:&argument atIndex:2];
        [I invokeWithTarget:[self delegate]];
        if (MS.methodReturnLength > sizeof(BOOL)) {
            BOOL result;
            [I getReturnValue:&result];
            return result;
        }
        return YES;
    }

    if (![[self nextResponder] isEqual:self.windowController] && ![[self delegate] isEqual:self.windowController]) {
		return [self.windowController tryToReallyPerform4iTM3:action with:argument];
    }
    
    return NO;
//END4iTM3;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  SWZ_iTM2KeyBindings_performMnemonic:
- (BOOL)SWZ_iTM2KeyBindings_performMnemonic:(NSString *)theString;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu May 13 21:02:03 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if ([self SWZ_iTM2KeyBindings_performMnemonic:theString])
	{
		return YES;
	}
	NSResponder * FR = self.firstResponder;
	if ([[FR keyBindingsManager4iTM3] client:FR performMnemonic:theString])
		return YES;
	BOOL result = [[self keyBindingsManager4iTM3] client:self performMnemonic:theString];
    return result;
}
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= NSApplication(iTM2KeyStrokeKit)
/*"Description forthcoming."*/
@implementation NSApplication(iTM2KeyBindingsKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= tryToReallyPerform4iTM3:with:
- (BOOL)tryToReallyPerform4iTM3:(SEL)action with:(id)argument;
/*"YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Dec 15 14:34:51 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSMethodSignature * MS = [self methodSignatureForSelector:action];
    NSMethodSignature * myMS = [self methodSignatureForSelector:@selector(__reallyPerformSelectorTemplate4iTM3:)];
    NSMethodSignature * myOtherMS = [self methodSignatureForSelector:@selector(forwardInvocation:)];
    if ([MS isEqual:myMS])
    {
        NSInvocation * I = [NSInvocation invocationWithMethodSignature:MS];
        [I setSelector:action];
        if (argument)
            [I setArgument:&argument atIndex:2];
        [I invokeWithTarget:self];
        BOOL result;
        [I getReturnValue:&result];
        return result;
    }
    if ([MS isEqual:myOtherMS])
    {
        NSInvocation * I = [NSInvocation invocationWithMethodSignature:MS];
        [I setSelector:action];
        if (argument)
            [I setArgument:&argument atIndex:2];
        [I invokeWithTarget:self];
        return YES;
    }
    if ([[self nextResponder] tryToReallyPerform4iTM3:action with:argument])
        return YES;
    MS = [(id)[self delegate] methodSignatureForSelector:action];
    if ([MS isEqual:myMS])
    {
        NSInvocation * I = [NSInvocation invocationWithMethodSignature:MS];
        [I setSelector:action];
        if (argument)
            [I setArgument:&argument atIndex:2];
        [I invokeWithTarget:[self delegate]];
        BOOL result;
        [I getReturnValue:&result];
        return result;
    }
    if ([MS isEqual:myMS])
    {
        NSInvocation * I = [NSInvocation invocationWithMethodSignature:MS];
        [I setSelector:action];
        if (argument)
            [I setArgument:&argument atIndex:2];
        [I invokeWithTarget:[self delegate]];
        return YES;
    }
    return NO;
//END4iTM3;
}
@end

@implementation NSText(iTM2KeyBindings)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  SWZ_iTM2KeyBindings_performKeyEquivalent:
- (BOOL)SWZ_iTM2KeyBindings_performKeyEquivalent:(NSEvent *)theEvent;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (11/10/2001).
To do list: problem when more than one key is pressed.
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	iTM2KeyBindingsManager * KBM = [self keyBindingsManager4iTM3];
    return ([self isEqual:self.window.firstResponder] && [KBM client:self performKeyEquivalent:theEvent])
                || [self SWZ_iTM2KeyBindings_performKeyEquivalent:theEvent];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  SWZ_iTM2KeyBindings_interpretKeyEvents:
- (void)SWZ_iTM2KeyBindings_interpretKeyEvents:(NSArray *)eventArray;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu May 13 21:02:03 GMT 2004
To Do List: Nothing at first glance.
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	iTM2KeyBindingsManager * KBM = [self keyBindingsManager4iTM3];
//LOG4iTM3(@"KBM is: %@", KBM);
    NSEvent * event;
//NSLog(NSStringFromSelector(_cmd));
    for(event in eventArray)
    {
        if (![KBM client:self interpretKeyEvent:event])
            [self SWZ_iTM2KeyBindings_interpretKeyEvents:[NSArray arrayWithObject:event]];
    }
//if ([[self string] length]>ZER0) NSLog(@"My last character code is:%i, %#x", [[self string] characterAtIndex:[[self string] length]-1], [[self string] characterAtIndex:[[self string] length]-1]);
    return;
}
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= NSResponder(iTM2KeyStrokeKit)
/*"Description forthcoming."*/
@implementation NSResponder(iTM2KeyBindings)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= SWZ_iTM2KeyBindings_performKeyEquivalent:
- (BOOL)SWZ_iTM2KeyBindings_performKeyEquivalent:(NSEvent *)theEvent;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Dec 15 14:34:51 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [[self keyBindingsManager4iTM3] client:self performKeyEquivalent:theEvent]
        || [self SWZ_iTM2KeyBindings_performKeyEquivalent:theEvent];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= SWZ_iTM2KeyBindings_performMnemonic:
- (BOOL)SWZ_iTM2KeyBindings_performMnemonic:(NSString *)theKey;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Dec 15 14:34:51 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [[self keyBindingsManager4iTM3] client:self performMnemonic:theKey]
        || [self SWZ_iTM2KeyBindings_performMnemonic:theKey];
}
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= NSObject(iTM2KeyStrokeKit)
/*"Description forthcoming."*/
@implementation NSObject(iTM2KeyStrokeKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= handlesKeyStrokes4iTM3
- (BOOL)handlesKeyStrokes4iTM3;
/*"YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Dec 15 14:34:51 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= interpretKeyStroke4iTM3:
- (BOOL)interpretKeyStroke4iTM3:(NSString *)key;
/*"YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Dec 15 14:34:51 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return NO;
//END4iTM3;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  rootKeyBindings
- (id)rootKeyBindings;
/*"Description forthcoming. Lazy initializer: the root key binding is returned when nothing else is available
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	id result = [SMC keyBindingTree];
	NSString * key = [self macroDomain];
	result = [result objectInChildrenWithDomain:key];
	key = [self macroCategory];
	result = [result objectInChildrenWithCategory:key];
#warning NO context mode supported
	key = @"";//[self macroContext];
	result = [result objectInChildrenWithContext:key];
	return [result keyBindings];
}
@end


//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2Inspector(iTM2KeyBindingsKitSupport)
/*"Description forthcoming."*/
@implementation iTM2KeyBindingsResponder
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  context4iTM3Manager
- (id)context4iTM3Manager;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSWindow * W = [NSApp keyWindow];
    return W.firstResponder? [W.firstResponder context4iTM3Manager]:[W context4iTM3Manager];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  toggleNoKeyBindings:
- (IBAction)toggleNoKeyBindings:(id)irrelevant;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self takeContext4iTM3Bool:![self context4iTM3BoolForKey:iTM2NoKeyBindingsIdentifier domain:iTM2ContextAllDomainsMask] forKey:iTM2NoKeyBindingsIdentifier domain:iTM2ContextAllDomainsMask];
    [self flushKeyBindings:nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  validateToggleNoKeyBindings:
- (BOOL)validateToggleNoKeyBindings:(NSButton *)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    sender.state = [self context4iTM3BoolForKey:iTM2NoKeyBindingsIdentifier domain:iTM2ContextAllDomainsMask]? NSOffState:NSOnState;
    return YES;
}
@end

