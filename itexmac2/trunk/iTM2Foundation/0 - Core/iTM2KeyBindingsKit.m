/*
//
//  @version Subversion: $Id$ 
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

#import <iTM2Foundation/iTM2KeyBindingsKit.h>
#import <iTM2Foundation/iTM2BundleKit.h>
#import <iTM2Foundation/iTM2DocumentKit.h>
#import <iTM2Foundation/iTM2InstallationKit.h>
#import <iTM2Foundation/iTM2Implementation.h>
#import <iTM2Foundation/iTM2ContextKit.h>
#import <iTM2Foundation/iTM2PathUtilities.h>

#define TABLE @"iTM2KeyBindingsKit"

NSString * const iTM2KeyBindingsComponent = @"Key Bindings.localized";// Default system name
NSString * const iTM2KeyBindingsExtension = @"dict";// Default system name
NSString * const iTM2SelectorMapExtension = @"selectorMap";// Default system name
NSString * const iTM2TextKeyBindingsIdentifier = @"Text";
NSString * const iTM2PDFKeyBindingsIdentifier = @"PDF";
NSString * const iTM2NoKeyBindingsIdentifier = @"iTM2NoKeyBindings";
NSString * const iTM2KeyStrokeIntervalKey = @"iTM2KeyStrokeInterval";

@interface NSObject(iTM2KeyBindingsKit)
- (void)postNotificationWithStatus:(NSString *)status;
@end

@interface NSResponder(PRIVATE)
- (void)cleanSelectionCache:(id)irrelevant;
@end

@interface NSText_iTM2KeyBindingsKit: NSText
@end

@interface NSWindow_iTM2KeyBindingsKit: NSWindow
@end

@interface NSResponder_iTM2KeyStrokeKit: NSResponder
@end

static NSCharacterSet * iTM2_KeyStroke_CharacterSet = nil;
static NSMutableDictionary * iTM2_KeyStroke_Selectors = nil;
static NSMutableArray * iTM2_KeyStroke_Unmapped = nil;
static NSMutableDictionary * iTM2_KeyStroke_Bases = nil;
static NSMutableDictionary * iTM2_KeyStroke_Events = nil;
static NSMutableDictionary * iTM2_KeyStroke_Timers = nil;

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
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[iTM2KeyBindingsManager class];
//iTM2_END;
}
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
{iTM2_DIAGNOSTIC;
    iTM2_INIT_POOL;
//iTM2_START;
	[NSText_iTM2KeyBindingsKit poseAsClass:[NSText class]];
	[NSWindow_iTM2KeyBindingsKit poseAsClass:[NSWindow class]];
	[NSResponder_iTM2KeyStrokeKit poseAsClass:[NSResponder class]];
//iTM2_START;
    iTM2_RELEASE_POOL;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  initialize
+ (void)initialize
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [super initialize];
    if([SUD boolForKey:@"iTM2-Text:NoKeyBindings"])
    {
        iTM2_LOG(@"Key bindings are not available...\nYou can enable them by running from the terminal the following command:\nterminal%% defaults delete \'comp.text.tex.iTeXMac2\' \"%@\"", @"iTM2-Text:NoKeyBindings");
    }
    else if(![_iTM2_KeyBindings_Dictionary isKindOfClass:[NSMutableDictionary class]])
    {
        [_iTM2_KeyBindings_Dictionary autorelease];
        _iTM2_KeyBindings_Dictionary = [[NSMutableDictionary dictionary] retain];
        [_iTM2_SelectorMap_Dictionary autorelease];
        _iTM2_SelectorMap_Dictionary = [[NSMutableDictionary dictionary] retain];
        iTM2_KeyStroke_CharacterSet = [[NSCharacterSet characterSetWithCharactersInString:
                @"_0123456789azertyuiopqsdfghjklmwxcvbnAZERTYUIOPQSDFGHJKLMWXCVBN"] retain];
        if(!iTM2_KeyStroke_Bases)
            iTM2_KeyStroke_Bases = [[NSMutableDictionary dictionary] retain];
        iTM2_KeyStroke_Selectors = [[NSMutableDictionary dictionary] retain];
        iTM2_KeyStroke_Unmapped = [[NSMutableArray array] retain];
        iTM2_KeyStroke_Events = [[NSMutableDictionary dictionary] retain];
        iTM2_KeyStroke_Timers = [[NSMutableDictionary dictionary] retain];
        [SUD registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:
                    [NSNumber numberWithFloat:5.0], iTM2KeyStrokeIntervalKey,
                            nil]];
        // beware with old iTM2_LOG versions: the sequel forces +initialize...
        iTM2_LOG(@"I am pleased to announce you that key bindings are available...\nIf this causes you any harm, you can disable them by running from the terminal the following commands:\nterminal%% defaults write \'comp.text.tex.iTeXMac2\' \"%@\" \"YES\"", @"iTM2-Text:NoKeyBindings");
    }
    [SUD registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:
        @"^~w", @"iTM2KeyBindingsDeepEscape", @"^w", @"iTM2KeyBindingsEscape", nil]];
    NSString * path = [[NSBundle bundleForClass:self] pathForResource:@"iTM2KeyStrokeSelectors" ofType:@"plist"];
    NSDictionary * D = [NSDictionary dictionaryWithContentsOfFile:path];
    if(D)
        [self addKeyStrokeSelectorsFromDictionary:D];
    else
    {
        iTM2_LOG(@"WARNING: Missing or corrupted iTM2KeyStrokeSelectors.plist, please reinstall and if it persists, report bug");
    }
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  addKeyStrokeSelectorsFromDictionary
+ (void)addKeyStrokeSelectorsFromDictionary:(NSDictionary *)D;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(!iTM2_KeyStroke_CharacterSet)
    {
        iTM2_LOG(@"Key bindings are not available, see the above note to activate them...");
        return;
    }
//iTM2_LOG(@"D is: %@", D);
    NSMutableDictionary * MD = [[iTM2_KeyStroke_Bases mutableCopy] autorelease];
    NSCharacterSet * nonCSet = [iTM2_KeyStroke_CharacterSet invertedSet];
    NSCharacterSet * nonHexaSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789abcdef"] invertedSet];
    NSCharacterSet * nonZeroSet = [[NSCharacterSet characterSetWithCharactersInString:@"0"] invertedSet];
    NSEnumerator * E = [D keyEnumerator];
    NSString * k;
    while(k = [E nextObject])
        if([k isKindOfClass:[NSString class]])
        {
            k = [k lowercaseString];
            NSRange R = [k rangeOfCharacterFromSet:nonHexaSet];
            if(!R.length)
            {
                R = [k rangeOfCharacterFromSet:nonZeroSet];
                if(R.length)
                {
                    if(R.location)
                    {
                        R.length = [k length] - R.location;
                        k = [k substringWithRange:R];
                    }
                    // k is acceptable.
                    id v = [D objectForKey:k];
                    if([v isKindOfClass:[NSString class]])
                    {
                        R = [k rangeOfCharacterFromSet:nonCSet];
                        if(!R.length)
                        {
                            // v is acceptable.
                            [MD setObject:v forKey:k];
                        }
                        else
                        {
                            iTM2_LOG(@"Unexpected value: %@", v);
                        }
                    }
                    else
                    {
                        iTM2_LOG(@"Unexpected value class: %@", v);
                    }
                }
            }
        }
        else
        {
            iTM2_LOG(@"Unexpected key class: %@", k);
        }
    iTM2_KeyStroke_Bases = [MD copy];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  registerKeyBindingsForIdentifier:
+ (void)registerKeyBindingsForIdentifier:(NSString *)identifier;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(![identifier length])
		return;
	if(iTM2DebugEnabled)
	{
		iTM2_LOG(@"identifier: %@", identifier);
	}
	NSString * shorterIdentifier = [identifier stringByDeletingLastPathComponent];
	NSMutableDictionary * keyBindings = [NSMutableDictionary dictionary];
	NSMutableDictionary * selectorMap = [NSMutableDictionary dictionary];
	if([shorterIdentifier length] < [identifier length])
	{
		[self registerKeyBindingsForIdentifier:shorterIdentifier];
		[keyBindings addEntriesFromDictionary:[self keyBindingsForIdentifier:shorterIdentifier]];
		[selectorMap addEntriesFromDictionary:[self selectorMapForIdentifier:shorterIdentifier]];
	}
	NSDictionary * D;
	NSEnumerator * E = [[[NSBundle mainBundle] allPathsForResource:identifier ofType:iTM2KeyBindingsExtension inDirectory:iTM2KeyBindingsComponent] reverseObjectEnumerator];
	NSString * path;
	while(path = [E nextObject])
		if(D = [NSDictionary dictionaryWithContentsOfFile:path])
		{
			[keyBindings addEntriesFromDictionary:D];
		}
		else if(iTM2DebugEnabled)
		{
			iTM2_LOG(@"???  No key bindings at path: %@, please report incident", path);
		}
	E = [[[NSBundle mainBundle] allPathsForResource:identifier ofType:iTM2SelectorMapExtension inDirectory:iTM2KeyBindingsComponent] reverseObjectEnumerator];
	while(path = [E nextObject])
		if(D = [NSDictionary dictionaryWithContentsOfFile:path])
		{
			[selectorMap addEntriesFromDictionary:D];
		}
		else if(iTM2DebugEnabled)
		{
			iTM2_LOG(@"No selector map at path: %@", path);
		}
	if([keyBindings count])
	{
		[self setKeyBindings:[NSDictionary dictionaryWithDictionary:keyBindings] forIdentifier:identifier];
		if(iTM2DebugEnabled)
		{
			iTM2_LOG(@"key bindings: %@", keyBindings);
		}
	}
	else if(iTM2DebugEnabled)
	{
		iTM2_LOG(@"No key bindings found");
	}
	if([selectorMap count])
	{
		[self setSelectorMap:[NSDictionary dictionaryWithDictionary:selectorMap] forIdentifier:identifier];
		if(iTM2DebugEnabled)
		{
			iTM2_LOG(@"selector map: %@", selectorMap);
		}
	}
	else if(iTM2DebugEnabled)
	{
		iTM2_LOG(@"No selector map found");
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  keyBindingsForIdentifier:
+ (id)keyBindingsForIdentifier:(NSString *)identifier;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(![identifier length])
        return nil;
    id result;
    if(result = [self getKeyBindingsForIdentifier:identifier])
        return result;
    if([identifier hasPrefix:@"./"])
    {
        // these are absolute paths (or relative to absolute locations...)
        #warning THE PROJECT HERE? foo.texp/Frontends/main bundle identifer/iTM2KeyBindingsComponent/identifier
        NSString * dirName = [[[SDC currentDocument] fileName] stringByDeletingLastPathComponent];
        NSString * helperIdentifier = identifier;
        NSString * key;
        shorter:
        key = [[dirName stringByAppendingPathComponent:helperIdentifier] stringByStandardizingPath];
        if(!(result = [NSDictionary dictionaryWithContentsOfFile:key]))
        {
            NSString * newIdentifier = [helperIdentifier stringByDeletingLastPathComponent];
            if([newIdentifier length] < [helperIdentifier length])
            {
                if(result = [self getKeyBindingsForIdentifier:newIdentifier])
                    return result;
                helperIdentifier = newIdentifier;
                goto shorter;
            }
            iTM2_LOG(@"Could not find a key binding dictionary at path %@.\nIdentifier %@ ignored (1).", key, identifier);
            result = [NSDictionary dictionary];
        }
        [self setKeyBindings:result forIdentifier:identifier];
        return result;
    }
    else if([identifier hasPrefix:@"~"] || [identifier hasPrefix:@"/"])
    {
        // these are absolute paths (or relative to absolute locations...)
        NSString * key = [identifier stringByStandardizingPath];
        NSString * helperKey = key;
        otherShorter:
        if(result = [self getKeyBindingsForIdentifier:key])
            return result;
        if(!(result = [NSDictionary dictionaryWithContentsOfFile:key]))
        {
            NSString * newKey = [helperKey stringByDeletingPathExtension];
            if([newKey length] < [helperKey length])
            {
                if(result = [self getKeyBindingsForIdentifier:newKey])
                    return result;
                helperKey = newKey;
                goto otherShorter;
            }
            iTM2_LOG(@"Could not find a key binding dictionary at path %@.\nkey %@ ignored (2).", key, identifier);
            result = [NSDictionary dictionary];
        }
        [self setKeyBindings:result forIdentifier:identifier];
        return result;
    }
	if(result = [self getKeyBindingsForIdentifier:identifier])
		return result;
    result = [NSDictionary dictionary];
	[self setKeyBindings:result forIdentifier:identifier];
//iTM2_END;
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  getKeyBindingsForIdentifier:
+ (id)getKeyBindingsForIdentifier:(NSString *)identifier;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	return [_iTM2_KeyBindings_Dictionary objectForKey:identifier];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  getKeyBindings:forIdentifier:
+ (void)setKeyBindings:(id)keyBindings forIdentifier:(NSString *)identifier;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(keyBindings)
		[_iTM2_KeyBindings_Dictionary setObject:keyBindings forKey:identifier];
	else
		[_iTM2_KeyBindings_Dictionary removeObjectForKey:identifier];
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  selectorMapForIdentifier:
+ (id)selectorMapForIdentifier:(NSString *)identifier;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(![identifier length])
        return [NSDictionary dictionary];
    id result;
    if(result = [self getSelectorMapForIdentifier:identifier])
        return result;
//iTM2_END;
    return [NSDictionary dictionary];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  getSelectorMapForIdentifier:
+ (id)getSelectorMapForIdentifier:(NSString *)identifier;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	return [_iTM2_SelectorMap_Dictionary objectForKey:identifier];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  setSelectorMap:forIdentifier:
+ (void)setSelectorMap:(id)selectorMap forIdentifier:(NSString *)identifier;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(selectorMap)
		[_iTM2_SelectorMap_Dictionary setObject:selectorMap forKey:identifier];
	else
		[_iTM2_SelectorMap_Dictionary removeObjectForKey:identifier];
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  initWithIdentifier:handleKeyBindings:handleKeyStrokes:
- (id)initWithIdentifier:(NSString *)identifier handleKeyBindings:(BOOL)handlesKeyBindings handleKeyStrokes:(BOOL)handlesKeyStrokes;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(self = [super init])
    {
        [_SM autorelease];
        _SM = [[isa selectorMapForIdentifier:identifier] retain];
        [_RKB autorelease];
        _RKB = [[isa keyBindingsForIdentifier:identifier] retain];
        [_KBS autorelease];
        _KBS = [[NSMutableArray array] retain];
        [_DEC autorelease];
        _DEC = [[SUD stringForKey:@"iTM2KeyBindingsDeepEscape"] copy];
        [_EC autorelease];
        _EC = [[SUD stringForKey:@"iTM2KeyBindingsEscape"] copy];
		_iTM2IMFlags.handlesKeyStrokes = handlesKeyStrokes? 1: 0;
		_iTM2IMFlags.handlesKeyBindings = handlesKeyBindings? 1: 0;
		if(iTM2DebugEnabled)
		{
			iTM2_LOG(@"Identifier is: %@ (%@)", identifier, _RKB);
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	return [NSString stringWithFormat:@"<%@ %#x, identifier:%@, handlesKeyBindings:%@, handlesKeyStrokes:%@>",
		NSStringFromClass(isa), self, [_iTM2_KeyBindings_Dictionary allKeysForObject:_RKB], (_iTM2IMFlags.handlesKeyBindings? @"Y":@"N"), (_iTM2IMFlags.handlesKeyStrokes? @"Y":@"N")];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  dealloc
- (void)dealloc;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [_SM autorelease];
    _SM = nil;
    [_RKB autorelease];
    _RKB = nil;
    [_KBS autorelease];
    _KBS = nil;
    [_CK autorelease];
    _CK = nil;
    [_DEC autorelease];
    _DEC = nil;
    [_EC autorelease];
    _EC = nil;
    [super dealloc];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  currentKey
- (NSString *)currentKey;
/*"Description forthcoming. Lazy initializer: the root key binding is returned when nothing else is available
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return _CK? _CK: (_CK = [NSString string]);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  selectorMap
- (NSDictionary *)selectorMap;
/*"Description forthcoming. Lazy initializer: the root key binding is returned when nothing else is available
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return _SM;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  setCurrentKey:
- (void)setCurrentKey:(NSString *)argument;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
 //NSLog(@"setCurrentKey: %@ %x", argument, ([argument length]? [argument characterAtIndex:[argument length]-1]:0));
    [_CK autorelease];
    _CK = [argument copy];
	if(iTM2DebugEnabled)
	{
		iTM2_LOG(@"The current key is: %@ (%#x)", _CK, ([_CK length]? [_CK characterAtIndex:0]:0));
	}
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  currentKeyBindings
- (NSDictionary *)currentKeyBindings;
/*"Description forthcoming. Lazy initializer: the root key binding is returned when nothing else is available
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    id result = [_KBS lastObject];
    if(!result)
        return _RKB;
    else
        return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  setCurrentKeyBindings:
- (void)setCurrentKeyBindings:(NSDictionary *)dict;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if([dict count])
    {
        [_KBS addObject:dict];
        {
            id V = [dict objectForKey:@"permanent"];
            _iTM2IMFlags.isPermanent = [V respondsToSelector:@selector(boolValue)] && [V boolValue]? 1:0;
        }
        _iTM2IMFlags.canEscape = 0;
        {
            NSString * toolTip = [dict objectForKey:@"toolTip"];
            [self postNotificationWithStatus:
                    ([toolTip isKindOfClass:[NSString class]]? toolTip:[NSString string])];
    //                if([toolTip isKindOfClass:[NSString class]] && [toolTip length])
    //                    [self postNotificationWithStatus:toolTip];
        }
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  setCurrentClient:
- (void)setCurrentClient:(id)client;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(_CC != client)
    {
        _CC = client;
        [self postNotificationWithStatus:nil];
        [_KBS removeAllObjects];
    }
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  rootKeyBindings
- (NSDictionary *)rootKeyBindings;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return _RKB;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  escapeCurrentKeyBindingsIfAllowed
- (void)escapeCurrentKeyBindingsIfAllowed;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.2: 06/20/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
 //NSLog(@"escapeCurrentKeyBindingsIfAllowed");
    if(_iTM2IMFlags.canEscape)
    {
        while(([_KBS count] > 0) && (!_iTM2IMFlags.isPermanent))
        {
            [_KBS removeLastObject];
            {
                id V = [[_KBS lastObject] objectForKey:@"permanent"];
                _iTM2IMFlags.isPermanent = [V respondsToSelector:@selector(boolValue)] && [V boolValue]? 1:0;
            }
        }
        {
            NSString * toolTip = [[self currentKeyBindings] objectForKey:@"toolTip"];
            [self postNotificationWithStatus:
                    ([toolTip isKindOfClass:[NSString class]]? toolTip:[NSString string])];
//                if([toolTip isKindOfClass:[NSString class]] && [toolTip length])
//                    [self postNotificationWithStatus:toolTip];
        }
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  client:performKeyEquivalent:
- (BOOL)client:(id)C performKeyEquivalent:(NSEvent *)theEvent;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//NSLog(@"C: %#x", C);
    if([theEvent type] == NSKeyDown)
    {
        [self setCurrentClient:C];
//NSLog(@"[theEvent charactersIgnoringModifiers]:%@", [theEvent charactersIgnoringModifiers]);
//NSLog(@"[theEvent characters]:%@", [theEvent characters]);
        NSString * CIM = [theEvent charactersIgnoringModifiers];
        if([CIM length])
        {
            unsigned flags = [theEvent modifierFlags];
            unichar U = [CIM characterAtIndex:0];
            NSString * key = [NSString stringWithFormat:@"%@%@%@%@%@",
                        (flags & NSCommandKeyMask? @"@": @""),
                        (flags & NSControlKeyMask? @"^": @""),
                        (flags & NSAlternateKeyMask? @"~": @""),
                        (flags & NSShiftKeyMask? @"$": @""),
                        [NSString stringWithCharacters:&U length:1]];
            if([key isEqual:_DEC])
            {
                [self toggleDeepEscape:self];
                return YES;
            }
            else if([key isEqual:_EC])
            {
                [self toggleEscape:self];
                return YES;
            }
            U = [[theEvent characters] characterAtIndex:0];
            key = [NSString stringWithFormat:@"%@%@%@",
                        (flags & NSCommandKeyMask? @"@": @""),
                        (flags & NSControlKeyMask? @"^": @""),
                        [NSString stringWithCharacters:&U length:1]];
            if([key isEqual:_DEC])
            {
                [self toggleDeepEscape:self];
                return YES;
            }
            else if([key isEqual:_EC])
            {
                [self toggleEscape:self];
                return YES;
            }
            _iTM2IMFlags.canEscape = -1;
            return [self client:C interpretKeyEvent:theEvent];
        }
    }
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  client:performMnemonic:
- (BOOL)client:(id)C performMnemonic:(NSString *)theString;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//NSLog(@"C: %#x", C);
//iTM2_LOG(@"theString: %@", theString);
    [self setCurrentClient:C];
    NSEvent * theEvent = [([C respondsToSelector:@selector(currentEvent)]? C:
            ([C respondsToSelector:@selector(window)]?[C window]:NSApp)) currentEvent];
    if([theString length])
    {
        unsigned flags = [[NSApp currentEvent] modifierFlags];
        unichar U = [theString characterAtIndex:0];
        NSString * key = [NSString stringWithFormat:@"%@%@%@%@%@",
                    (flags & NSCommandKeyMask? @"@": @""),
                    (flags & NSControlKeyMask? @"^": @""),
                    (flags & NSAlternateKeyMask? @"~": @""),
                    (flags & NSShiftKeyMask? @"$": @""),
                    [NSString stringWithCharacters:&U length:1]];
        if([key isEqual:_DEC])
        {
            [self toggleDeepEscape:self];
            return YES;
        }
        else if([key isEqual:_EC])
        {
            [self toggleEscape:self];
            return YES;
        }
        U = [theString characterAtIndex:0];
        key = [NSString stringWithFormat:@"%@%@%@",
                    (flags & NSCommandKeyMask? @"@": @""),
                    (flags & NSControlKeyMask? @"^": @""),
                    [NSString stringWithCharacters:&U length:1]];
        if([key isEqual:_DEC])
        {
            [self toggleDeepEscape:self];
            return YES;
        }
        else if([key isEqual:_EC])
        {
            [self toggleEscape:self];
            return YES;
        }
        _iTM2IMFlags.canEscape = -1;
        return [self client:C interpretKeyEvent:theEvent];
    }
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_LOG(@"[self currentKeyBindings] are:%@", [self currentKeyBindings]);
    [self setCurrentClient:C];
//iTM2_LOG(@"C is: %@", C);
    NSString * S = [theEvent characters];//[event charactersIgnoringModifiers];
//NSLog(@"S: %@", S);
    if([S length] == 1)
    {
        NSString * CIM = [theEvent charactersIgnoringModifiers];
//iTM2_LOG(@"CIM: %@", CIM);
        if([CIM length])
        {
            unichar U = [CIM characterAtIndex:0];
            if(!_iTM2IMFlags.isDeepEscaped && !_iTM2IMFlags.isEscaped)
            {
				NSString * instruction = nil;
				if(_iTM2IMFlags.handlesKeyBindings)
				{
					unsigned flags = [theEvent modifierFlags];
					if(U == [[theEvent characters] characterAtIndex:0])
					{
						// the character typed might only be sensitive to the shift key
						[self setCurrentKey:[NSString stringWithFormat:@"%@%@%@%@%@",
							(flags & NSCommandKeyMask? @"@": @""),
							(flags & NSControlKeyMask? @"^": @""),
							(flags & NSAlternateKeyMask? @"~": @""),
							(flags & NSShiftKeyMask? @"$": @""),
							[NSString stringWithCharacters:&U length:1]]];
						instruction = [[self currentKeyBindings] objectForKey:[self currentKey]];
//NSLog(@"1 - <%@>", [self currentKey]);
						if(!instruction)
						{
							[self setCurrentKey:[NSString stringWithFormat:@"%@%@%@%@",
								(flags & NSCommandKeyMask? @"@": @""),
								(flags & NSControlKeyMask? @"^": @""),
								(flags & NSAlternateKeyMask? @"~": @""),
								[NSString stringWithCharacters:&U length:1]]];
							instruction = [[self currentKeyBindings] objectForKey:[self currentKey]];
//NSLog(@"2 - <%@>", [self currentKey]);
						}
					}
					else
					{
						[self setCurrentKey:[NSString stringWithFormat:@"%@%@%@",
							(flags & NSCommandKeyMask? @"@": @""),
							(flags & NSControlKeyMask? @"^": @""),
							[S substringWithRange:NSMakeRange(0, 1)]]];
						instruction = [[self currentKeyBindings] objectForKey:[self currentKey]];
//NSLog(@"3 - <%@>", [self currentKey]);
						if(!instruction)
						{
							[self setCurrentKey:[NSString stringWithFormat:@"%@%@%@%@%@",
								(flags & NSCommandKeyMask? @"@": @""),
								(flags & NSControlKeyMask? @"^": @""),
								(flags & NSAlternateKeyMask? @"~": @""),
								(flags & NSShiftKeyMask? @"$": @""),
								[NSString stringWithCharacters:&U length:1]]];
							instruction = [[self currentKeyBindings] objectForKey:[self currentKey]];
//NSLog(@"4 - <%@>", [self currentKey]);
						}
						if(!instruction)
						{
							[self setCurrentKey:[NSString stringWithFormat:@"%@%@%@%@",
								(flags & NSCommandKeyMask? @"@": @""),
								(flags & NSControlKeyMask? @"^": @""),
								(flags & NSAlternateKeyMask? @"~": @""),
								[NSString stringWithCharacters:&U length:1]]];
							instruction = [[self currentKeyBindings] objectForKey:[self currentKey]];
//NSLog(@"5 - <%@>", [self currentKey]);
						}
					}
				}
                _iTM2IMFlags.isEscaped = 0;
                _iTM2IMFlags.canEscape = 1;
                if(instruction)
                    return [self client:C executeInstruction:instruction];
                else
                {
                    id V = [[self currentKeyBindings] objectForKey:@"complete"];
                    if([V respondsToSelector:@selector(boolValue)] && [V boolValue])
                    {
                        #warning IS cleanSelectionCache: NECESSARY???
                        if([C respondsToSelector:@selector(cleanSelectionCache:)])
                            [C cleanSelectionCache:self];
                        return YES;
                    }
                    else if(_iTM2IMFlags.handlesKeyStrokes && [C isKindOfClass:[NSResponder class]])
                    {
                        return [C interpretKeyStroke:[theEvent characters]];
                    }
                    else
                        return NO;
                }
            }
        }
    }
    _iTM2IMFlags.isEscaped = 0;
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  client:executeInstruction:
- (BOOL)client:(id)C executeInstruction:(id)instruction;
/*"Description forthcoming.
If the event is a 1 char key down, it will ask the current key binding for instruction.
The key and its modifiers are 
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_LOG(@"instruction is: %@, client is: %@", instruction, C);
    BOOL result = NO;
    if([instruction isKindOfClass:[NSArray class]])
    {
        NSEnumerator * E = [instruction objectEnumerator];
        while(instruction = [E nextObject])
            result = [self client:C executeInstruction:instruction] || result;
    }
    else if([instruction isKindOfClass:[NSDictionary class]])
    {
        NSString * toolTip = [instruction objectForKey:@"toolTip"];
        NSString * stringSel = [instruction objectForKey:@"selector"];
        if([toolTip length])
            [self postNotificationWithStatus:([toolTip isKindOfClass:[NSString class]]? toolTip:nil)];
        if([stringSel isKindOfClass:[NSString class]])
        {
            SEL selector = NSSelectorFromString(stringSel);
            if([self respondsToSelector:selector])
            {
                [self performSelector:selector withObject:[instruction objectForKey:@"argument"]];
                result = YES;
            }
            else if([C respondsToSelector:selector])
            {
                [C performSelector:selector withObject:[instruction objectForKey:@"argument"]];
                result = YES;
            }
            else
            {
                result = [C isKindOfClass:[NSResponder class]]
                                && [C tryToPerform:selector with:[instruction objectForKey:@"argument"]];
            }
        }
        else if(!stringSel)
        {
            [self setCurrentKeyBindings:instruction];
            if([C respondsToSelector:@selector(cleanSelectionCache:)])
                [C cleanSelectionCache:self];
            return YES;
        }
        else
        {
            NSLog(@"%@ unrecognized object: %@", __PRETTY_FUNCTION__, stringSel);
        }
    }
    else if([instruction isKindOfClass:[NSString class]])
    {
 //NSLog(instruction);
		result = [C executeStringInstruction:instruction];
    }
	#if 0
    else if([instruction isKindOfClass:[iTM2KeyStrokeRecord class]])
    {
 //NSLog(instruction);
		result = [iTM2MacrosServer executeMacroWithKey:[instruction key]
			inCategory: [instruction category]
				ofDomain: [instruction domain]];
    }
	#endif
 //NSLog(@"1");
    [self escapeCurrentKeyBindingsIfAllowed];
    if(result)
        [C cleanSelectionCache:self];
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleEscape:
- (IBAction)toggleEscape:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu May 13 21:02:03 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(_iTM2IMFlags.isDeepEscaped == 0)
    {
        if(_iTM2IMFlags.isEscaped != 0)
        {
            [self postNotificationWithStatus:nil];
            _iTM2IMFlags.isEscaped = 0;
        }
        else if([_KBS count])
        {
            [_KBS removeLastObject];
            [self postNotificationWithStatus:[[_KBS lastObject] objectForKey:@"toolTip"]];
        }
        else
        {
            [self postNotificationWithStatus:
                NSLocalizedStringFromTableInBundle(@"Escaped mode.", TABLE,
                    [NSBundle bundleForClass:[self class]], "status displayed when the escaped key is pressed")];
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(_iTM2IMFlags.isDeepEscaped != 0)
    {
        [self postNotificationWithStatus:nil];
        _iTM2IMFlags.isDeepEscaped = 0;
    }
    else if([_KBS count])
    {
        [self postNotificationWithStatus:nil];
        [_KBS removeAllObjects];
    }
    else
    {
        [self postNotificationWithStatus:
            NSLocalizedStringFromTableInBundle(@"Deep Escaped mode.", TABLE,
                [NSBundle bundleForClass:[self class]], "status displayed when the ctrl + escaped key are pressed")];
        _iTM2IMFlags.isDeepEscaped = -1;
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  loadKeyBindingsAtPath:
- (IBAction)loadKeyBindingsAtPath:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu May 13 21:02:03 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    iTM2_LOG(@"loading: %@", __PRETTY_FUNCTION__, sender);
    if([sender isKindOfClass:[NSString class]])
    {
        id result = [isa keyBindingsForIdentifier:sender];
        if([result count])
        {
            NSString * toolTip = [result objectForKey:@"toolTip"];
            if(![toolTip isKindOfClass:[NSString class]])
                toolTip = [NSString stringWithFormat:@"Loading %@",
                    [[sender lastPathComponent] stringByDeletingPathExtension]];
            [self postNotificationWithStatus:toolTip];
            [self setCurrentKeyBindings:result];
            return;
        }
        [self postNotificationWithStatus:[NSString stringWithFormat:@"Nothing at:%@", sender]];
        iTM2_LOG(@"bad file at: %@ (relative path)", __PRETTY_FUNCTION__, sender);
        NSBeep();
        return;
    }
    [self postNotificationWithStatus:@"Internal error, ignored"];
    iTM2_LOG(@"bad argument: %@", __PRETTY_FUNCTION__, sender);
    NSBeep();
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  flushKeyBindings:
- (void)flushKeyBindings:(id)irrelevant;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [_iTM2_KeyBindings_Dictionary autorelease];
    _iTM2_KeyBindings_Dictionary = [[NSMutableDictionary dictionary] retain];
    [self postNotificationWithStatus:
        [NSString stringWithFormat:NSLocalizedStringFromTableInBundle
            (@"Flushing Key Bindings.", TABLE,
                [NSBundle bundleForClass:[self class]], "status info format, 1%@")]];
    _iTM2IMFlags.canEscape = 0;
    [_DEC autorelease];
    _DEC = [[SUD stringForKey:@"iTM2KeyBindingsDeepEscape"] copy];
    [_EC autorelease];
    _EC = [[SUD stringForKey:@"iTM2KeyBindingsEscape"] copy];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  postNotificationWithStatus:
- (void)postNotificationWithStatus:(NSString *)status;
/*"Description forthcoming.
If the event is a 1 char key down, it will ask the current key binding for instruction.
The key and its modifiers are 
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if([[self superclass] instancesRespondToSelector:_cmd])
        [super postNotificationWithStatus:status];
//iTM2_END;
    return;
}
@end

@implementation NSResponder(iTM2KeyBindingsKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= handlesKeyBindings
- (BOOL)handlesKeyBindings;
/*"YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Dec 15 14:34:51 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  keyBindingsManagerIdentifier
- (NSString *)keyBindingsManagerIdentifier;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return @"";
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  keyBindingsManager
- (id)keyBindingsManager;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu May 13 21:02:03 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [[self nextResponder] keyBindingsManager];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  keyBindingsManagerForClient:
- (id)keyBindingsManagerForClient:(id)client;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu May 13 21:02:03 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [[self nextResponder] keyBindingsManagerForClient:self];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  keyBindingsManagerWithIdentifier:
- (id)keyBindingsManagerWithIdentifier:(NSString *)identifier;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(([self handlesKeyBindings] || [self handlesKeyStrokes])
        && ![self contextBoolForKey:iTM2NoKeyBindingsIdentifier])
    {
		id KBM = metaGETTER;
        if(!KBM)
        {
			KBM = [self lazyKeyBindingsManager];
            metaSETTER(KBM);
			if(iTM2DebugEnabled > 1000)
			{
				iTM2_LOG(@"Available key binding manager: %@", KBM);
			}
        }
        return KBM;
    }
    else
        return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  lazyKeyBindingsManager
- (id)lazyKeyBindingsManager;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * identifier = [self keyBindingsManagerIdentifier];
	if(iTM2DebugEnabled)
	{
		iTM2_LOG(@"The identifier is: %@", identifier);
	}
	[iTM2KeyBindingsManager registerKeyBindingsForIdentifier:identifier];
    return [[[iTM2KeyBindingsManager allocWithZone:[self zone]]
				initWithIdentifier: identifier
					handleKeyBindings: [self handlesKeyBindings]
						handleKeyStrokes: [self handlesKeyStrokes]] autorelease];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  cleanSelectionCache:
- (void)cleanSelectionCache:(id)irrelevant;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu May 13 21:02:03 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  postNotificationWithStatus:
- (void)postNotificationWithStatus:(NSString *)status;
/*"Description forthcoming.
If the event is a 1 char key down, it will ask the current key binding for instruction.
The key and its modifiers are 
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if([[self superclass] instancesRespondToSelector:_cmd])
        [super postNotificationWithStatus:status];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= tryToReallyPerform:with:
- (BOOL)tryToReallyPerform:(SEL)action with:(id)argument;
/*"YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Dec 15 14:34:51 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSMethodSignature * MS = [self methodSignatureForSelector:action];
    NSMethodSignature * myMS = [self methodSignatureForSelector:@selector(__reallyPerformSelectorTemplate:)];
    NSMethodSignature * myOtherMS = [self methodSignatureForSelector:@selector(forwardInvocation:)];
    if([MS isEqual:myMS])
    {
        NSInvocation * I = [NSInvocation invocationWithMethodSignature:MS];
        [I setSelector:action];
        if(argument)
            [I setArgument:&argument atIndex:2];
        [I invokeWithTarget:self];
        BOOL result;
        [I getReturnValue:&result];
        return result;
    }
    if([MS isEqual:myOtherMS])
    {
        NSInvocation * I = [NSInvocation invocationWithMethodSignature:MS];
        [I setSelector:action];
        if(argument)
            [I setArgument:&argument atIndex:2];
        [I invokeWithTarget:self];
        return YES;
    }
	return [[self nextResponder] tryToReallyPerform:action with:argument];
//iTM2_END;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= __reallyPerformSelectorTemplate:
- (BOOL)__reallyPerformSelectorTemplate:(id)argument;
/*"YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Dec 15 14:34:51 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  executeStringInstruction:
- (BOOL)executeStringInstruction:(NSString *)instruction;
/*"Description forthcoming.
If the event is a 1 char key down, it will ask the current key binding for instruction.
The key and its modifiers are 
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return [self tryToExecuteStringInstruction:instruction];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  tryToExecuteStringInstruction:
- (BOOL)tryToExecuteStringInstruction:(NSString *)instruction;
/*"Description forthcoming.
If the event is a 1 char key down, it will ask the current key binding for instruction.
The key and its modifiers are 
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return [self tryToPerform:NSSelectorFromString(instruction) with:nil];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= keyStrokeEvents
- (id)keyStrokeEvents;
/*"YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Dec 15 14:34:51 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    id V = [NSValue valueWithNonretainedObject:self];
    id result = [iTM2_KeyStroke_Events objectForKey:V];
    if(!result)
    {
        result = [NSMutableArray array];
        [iTM2_KeyStroke_Events setObject:result forKey:V];
    }
//iTM2_END;
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= keyStrokes
- (NSString *)keyStrokes;
/*"YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Dec 15 14:34:51 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    id result = [NSMutableString string];
    NSEnumerator * E = [[self keyStrokeEvents] objectEnumerator];
    NSEvent * e;
    while(e = [E nextObject])
        [result appendString:[e characters]];
//iTM2_LOG(@"result is: %@", result);
//iTM2_END;
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= pushKeyStrokeEvent:
- (void)pushKeyStrokeEvent:(NSEvent *)event;
/*"YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Dec 15 14:34:51 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    id V = [NSValue valueWithNonretainedObject:self];
    NSTimer * T = [iTM2_KeyStroke_Timers objectForKey:V];
    [T invalidate];
    [[self keyStrokeEvents] addObject:[[event copy] autorelease]];
    T = [NSTimer scheduledTimerWithTimeInterval:[SUD floatForKey:iTM2KeyStrokeIntervalKey]
        target: self selector: @selector(timedFlushKeyStrokeEvents:)
            userInfo: nil repeats: NO];
    [iTM2_KeyStroke_Timers setObject:T forKey:V];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= timedFlushKeyStrokeEvents:
- (void)timedFlushKeyStrokeEvents:(NSTimer *)timer;
/*"YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Dec 15 14:34:51 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self flushKeyStrokeEvents:self];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= flushKeyStrokeEvents:
- (void)flushKeyStrokeEvents:(id)sender;
/*"YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Dec 15 14:34:51 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(iTM2DebugEnabled)
	{
		iTM2_LOG(@"Nothing left...");
	}
    id V = [NSValue valueWithNonretainedObject:self];
    [iTM2_KeyStroke_Timers removeObjectForKey:V];
    [[self keyStrokeEvents] removeAllObjects];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= flushLastKeyStrokeEvent:
- (void)flushLastKeyStrokeEvent:(id)sender;
/*"YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Dec 15 14:34:51 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [[self keyStrokeEvents] removeLastObject];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= selectorFromKeyStroke:
+ (SEL)selectorFromKeyStroke:(NSString *)key;
/*"YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Dec 15 14:34:51 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_LOG(@"entry key is: %@", key);
    if([key length] == 1)
    {
		id result = [iTM2_KeyStroke_Selectors objectForKey:key];
		if(iTM2DebugEnabled > 999)
		{
			iTM2_LOG(@"result: %@", result);
		}
		if(result)
			return (SEL)[result pointerValue];
		if([iTM2_KeyStroke_Unmapped containsObject:key])
		{
			return NULL;
		}
		if(result)
			return (SEL)[result pointerValue];
        unichar U = [key characterAtIndex:0];
//iTM2_LOG(@"unichar is: %#x(%u)", U, U);
        NSString * base = [iTM2_KeyStroke_Bases objectForKey:[NSString stringWithFormat:@"%x", U]];
//iTM2_LOG(@"base is: %@", base);
        if(!base)
            if([iTM2_KeyStroke_CharacterSet characterIsMember:U])
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
                    case '"':	base = @"Quote";			break;
                    case '#':	base = @"Sharp";			break;
                    case '$':	base = @"Dollar";			break;
                    case '%':	base = @"Percent";			break;
                    case '&':	base = @"Ampersand";		break;
                    case '\'':	base = @"Apostrophe";		break;
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
						if(iTM2DebugEnabled>999)
						{
							iTM2_LOG(@"unmapped key stroke is: %@(%#x)", key, [key characterAtIndex:0]);
						}
						[iTM2_KeyStroke_Unmapped addObject:[[key copy] autorelease]];
						return NULL;
                }
        NSString * selectorName = [NSString stringWithFormat:@"interpretKeyStroke%@:", base];
		if(iTM2DebugEnabled>999)
		{
			iTM2_LOG(@"selectorName is: %@", selectorName);
		}
        SEL action = NSSelectorFromString(selectorName);
		[iTM2_KeyStroke_Selectors setObject:[NSValue valueWithPointer:action] forKey:key];
		return action;
    }
//iTM2_END;
    return NULL;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= interpretKeyStroke:
- (BOOL)interpretKeyStroke:(NSString *)key;
/*"YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Dec 15 14:34:51 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_LOG(@"entry key is: %@", key);
    SEL selector = [isa selectorFromKeyStroke:key];
//iTM2_END;
	if(!selector)
		return NO;
	if([self tryToReallyPerform:selector with:nil])
		return YES;
	selector = (SEL)[[[[self keyBindingsManager] selectorMap] objectForKey:[NSValue valueWithPointer:selector]] pointerValue];
    return selector != NULL && [self tryToReallyPerform:selector with:nil];
}
@end

@implementation NSTextView(iTM2KeyBindingsKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  executeStringInstruction:
- (BOOL)executeStringInstruction:(NSString *)instruction;
/*"Description forthcoming.
If the event is a 1 char key down, it will ask the current key binding for instruction.
The key and its modifiers are 
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return [super executeStringInstruction:instruction] || ([self insertText:instruction], YES);
}
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  iTM2KeyBindingsManager

#import <iTM2Foundation/iTM2BundleKit.h>

@implementation NSWindowController(iTM2KeyBindingsKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= keyBindingsWindowWillLoad
- (void)keyBindingsWindowWillLoad;
/*"YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Dec 15 14:34:51 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([self handlesKeyStrokes] || [self handlesKeyBindings])
	{
		[self keyBindingsManagerWithIdentifier:[self keyBindingsManagerIdentifier]];
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= handlesKeyStrokes
- (BOOL)handlesKeyStrokes;
/*"YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Dec 15 14:34:51 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return [[self document] handlesKeyStrokes]
        || (![[self owner] isEqual:self] && [[self owner] handlesKeyStrokes]);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= interpretKeyStroke:
- (BOOL)interpretKeyStroke:(NSString *)key;
/*"YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Dec 15 14:34:51 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return ([[self document] handlesKeyStrokes] && [[self document] interpretKeyStroke:key])
        || (![[self owner] isEqual:self] && [[self owner] handlesKeyStrokes] && [[self owner] interpretKeyStroke:key])
        || [super interpretKeyStroke:key];
//iTM2_END;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  keyBindingsManager
- (id)keyBindingsManager;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu May 13 21:02:03 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [super keyBindingsManager]?:[self keyBindingsManagerWithIdentifier:[self keyBindingsManagerIdentifier]];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  keyBindingsManagerIdentifier
- (NSString *)keyBindingsManagerIdentifier;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    id KBMI = metaGETTER;
    if(!KBMI)
    {
        metaSETTER([[[isa inspectorType]
                stringByAppendingPathComponent: [isa inspectorMode]]
                    stringByAppendingPathComponent: [isa inspectorVariant]]);
        KBMI = metaGETTER;
    }
    return KBMI;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  lazyKeyBindingsManager
- (id)lazyKeyBindingsManager;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * identifier = [self keyBindingsManagerIdentifier];
	if(iTM2DebugEnabled)
	{
		iTM2_LOG(@"The identifier is: %@", identifier);
	}
	[iTM2KeyBindingsManager registerKeyBindingsForIdentifier:identifier];
    return [[[iTM2KeyBindingsManager allocWithZone:[self zone]]
				initWithIdentifier: identifier
					handleKeyBindings: [self handlesKeyBindings]
						handleKeyStrokes: [self handlesKeyStrokes]] autorelease];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setKeyBindingsManager:
- (void)setKeyBindingsManager:(id)argument;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(metaGETTER != argument)
    {
        if(argument)
        {
            NSParameterAssert([argument respondsToSelector:@selector(client:interpretKeyEvent:)]);
            NSParameterAssert([argument respondsToSelector:@selector(client:performKeyEquivalent:)]);
        }
        metaSETTER(argument);
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  tryToExecuteStringInstruction:
- (BOOL)tryToExecuteStringInstruction:(NSString *)instruction;
/*"Description forthcoming.
If the event is a 1 char key down, it will ask the current key binding for instruction.
The key and its modifiers are 
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return [super tryToExecuteStringInstruction:instruction]
			|| [[self document] executeStringInstruction:instruction]
				|| (([self owner] != self) && [[self owner] executeStringInstruction:instruction]);
}
@end

@implementation NSWindow(iTM2KeyBindingsKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  keyBindingsManagerIdentifier
- (NSString *)keyBindingsManagerIdentifier;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    id KBMI = metaGETTER;
    if(!KBMI)
    {
        metaSETTER(NSStringFromClass(isa));
        KBMI = metaGETTER;
    }
    return KBMI?:@"";
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  keyBindingsManager
- (id)keyBindingsManager;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu May 13 21:02:03 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [super keyBindingsManager]?:([[self windowController] keyBindingsManager]?:[self keyBindingsManagerWithIdentifier:[self keyBindingsManagerIdentifier]]);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  keyBindingsManagerForClient:
- (id)keyBindingsManagerForClient:(id)client;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu May 13 21:02:03 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return [super keyBindingsManagerForClient:self]?:[[self windowController] keyBindingsManagerForClient:self];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= interpretKeyStroke:
- (BOOL)interpretKeyStroke:(NSString *)key;
/*"YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Dec 15 14:34:51 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    SEL selector = [isa selectorFromKeyStroke:key];
    if([self tryToReallyPerform:selector with:nil])
        return YES;
    else if([self handlesKeyStrokes])
    {
		[self pushKeyStroke:key];
    }
//iTM2_END;
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= pushKeyStroke:
- (void)pushKeyStroke:(NSString *)key;
/*"YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Dec 15 14:34:51 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSEvent * e = [self currentEvent];
	if(!e)
		e = [NSApp currentEvent];
	if([e type] == NSKeyDown)
	{
		#if 0
		e = [NSEvent keyEventWithType:[e type]
			location: [e locationInWindow]
				modifierFlags: [e modifierFlags]
					timestamp: [e timestamp]
						windowNumber: [e windowNumber]
							context: [e context]
								characters: key
									charactersIgnoringModifiers: key
										isARepeat: [e isARepeat]
											keyCode: [e keyCode]];
		#endif
		[self pushKeyStrokeEvent:e];
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= handlesKeyStrokes
- (BOOL)handlesKeyStrokes;
/*"YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Dec 15 14:34:51 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return [[self windowController] handlesKeyStrokes];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= tryToReallyPerform:with:
- (BOOL)tryToReallyPerform:(SEL)action with:(id)argument;
/*"YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Dec 15 14:34:51 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(!action)
        return NO;
    NSMethodSignature * MS = [self methodSignatureForSelector:action];
    NSMethodSignature * myMS = [self methodSignatureForSelector:@selector(__reallyPerformSelectorTemplate:)];
    NSMethodSignature * myOtherMS = [self methodSignatureForSelector:@selector(forwardInvocation:)];
    if([MS isEqual:myMS])
    {
        NSInvocation * I = [NSInvocation invocationWithMethodSignature:MS];
        [I setSelector:action];
        if(argument)
            [I setArgument:&argument atIndex:2];
        [I invokeWithTarget:self];
        BOOL result;
        [I getReturnValue:&result];
        return result;
    }
    if([MS isEqual:myOtherMS])
    {
        NSInvocation * I = [NSInvocation invocationWithMethodSignature:MS];
        [I setSelector:action];
        if(argument)
            [I setArgument:&argument atIndex:2];
        [I invokeWithTarget:self];
        return YES;
    }
    if([[self nextResponder] tryToReallyPerform:action with:argument])
        return YES;
    MS = [[self delegate] methodSignatureForSelector:action];
    if([MS isEqual:myMS])
    {
        NSInvocation * I = [NSInvocation invocationWithMethodSignature:MS];
        [I setSelector:action];
        if(argument)
            [I setArgument:&argument atIndex:2];
        [I invokeWithTarget:[self delegate]];
        BOOL result;
        [I getReturnValue:&result];
        return result;
    }
    if([MS isEqual:myOtherMS])
    {
        NSInvocation * I = [NSInvocation invocationWithMethodSignature:MS];
        [I setSelector:action];
        if(argument)
            [I setArgument:&argument atIndex:2];
        [I invokeWithTarget:[self delegate]];
        return YES;
    }
	if(![[self nextResponder] isEqual:[self windowController]] && ![[self delegate] isEqual:[self windowController]])
		return [[self windowController] tryToReallyPerform:action with:argument];
    return NO;
//iTM2_END;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  tryToExecuteStringInstruction:
- (BOOL)tryToExecuteStringInstruction:(NSString *)instruction;
/*"Description forthcoming.
If the event is a 1 char key down, it will ask the current key binding for instruction.
The key and its modifiers are 
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return [super tryToExecuteStringInstruction:instruction]
			|| [[self delegate] executeStringInstruction:instruction]
				|| [[self windowController] tryToExecuteStringInstruction:instruction];
}
@end

@implementation NSWindow_iTM2KeyBindingsKit
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  performMnemonic:
- (BOOL)performMnemonic:(NSString *)theString;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu May 13 21:02:03 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([super performMnemonic:theString])
		return YES;
	NSResponder * FR = [self firstResponder];
	if([[FR keyBindingsManager] client:FR performMnemonic:theString])
		return YES;
    return [[self keyBindingsManager] client:self performMnemonic:theString];
}
@end

@implementation NSView(iTM2KeyBindingsKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  keyBindingsManager:
- (id)keyBindingsManager;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu May 13 21:02:03 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([self handlesKeyStrokes])
	{
		id result;
		if(result = [super keyBindingsManager])
			return result;
		if(result = [[self superview] keyBindingsManager])
			return result;
		return [[self window] keyBindingsManager];
	}
	return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  tryToExecuteStringInstruction:
- (BOOL)tryToExecuteStringInstruction:(NSString *)instruction;
/*"Description forthcoming.
If the event is a 1 char key down, it will ask the current key binding for instruction.
The key and its modifiers are 
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return [super tryToExecuteStringInstruction:instruction]
			|| [[self superview] tryToExecuteStringInstruction:instruction]
				|| [[self window] tryToExecuteStringInstruction:instruction];
}
@end

@implementation NSText_iTM2KeyBindingsKit
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  performKeyEquivalent:
- (BOOL)performKeyEquivalent:(NSEvent *)theEvent;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (11/10/2001).
To do list: problem when more than one key is pressed.
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [[self keyBindingsManager] client:self performKeyEquivalent:theEvent]
                || [super performKeyEquivalent:theEvent];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  interpretKeyEvents:
- (void)interpretKeyEvents:(NSArray *)eventArray;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu May 13 21:02:03 GMT 2004
To Do List: Nothing at first glance.
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	iTM2KeyBindingsManager * KBM = [self keyBindingsManager];
//iTM2_LOG(@"KBM is: %@", KBM);
    NSEnumerator * E = [eventArray objectEnumerator];
    NSEvent * event;
//NSLog(NSStringFromSelector(_cmd));
    while(event = [E nextObject])
    {
//        if(![self hasMarkedText])
//            [self cleanSelectionCache:self];
//NSLog(@"%@, %@", NSStringFromSelector(_cmd), ([self hasMarkedText]? @"Y":@"N"));
        if(![KBM client:self interpretKeyEvent:event])
            [super interpretKeyEvents:[NSArray arrayWithObject:event]];
    }
//if([[self string] length]>0) NSLog(@"My last character code is:%i, %#x", [[self string] characterAtIndex:[[self string] length]-1], [[self string] characterAtIndex:[[self string] length]-1]);
    return;
}
#if 0
#warning DEBUGGGG
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= keyDown:
- (void)keyDown:(NSEvent *)theEvent;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Dec 15 14:34:51 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[super keyDown:(NSEvent *)theEvent];
//iTM2_END;
    return;
}
#endif
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= NSResponder(iTM2KeyStrokeKit)
/*"Description forthcoming."*/
@implementation NSResponder_iTM2KeyStrokeKit
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= performKeyEquivalent:
- (BOOL)performKeyEquivalent:(NSEvent *)theEvent;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Dec 15 14:34:51 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [[self keyBindingsManager] client:self performKeyEquivalent:theEvent]
        || [super performKeyEquivalent:theEvent];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= performMnemonic:
- (BOOL)performMnemonic:(NSString *)theKey;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Dec 15 14:34:51 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [[self keyBindingsManager] client:self performMnemonic:theKey]
        || [super performMnemonic:theKey];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= dealloc
- (void)dealloc;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Dec 15 14:34:51 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
    iTM2_INIT_POOL;
//iTM2_START;
//NSLog(NSStringFromClass(isa));
    id V = [NSValue valueWithNonretainedObject:self];
    NSTimer * T = [iTM2_KeyStroke_Timers objectForKey:V];
    [T invalidate];
    [iTM2_KeyStroke_Timers removeObjectForKey:V];
    [iTM2_KeyStroke_Events removeObjectForKey:V];
//iTM2_END;
	iTM2_RELEASE_POOL;
    [super dealloc];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= interpretKeyEvents:
- (void)interpretKeyEvents:(NSArray *)eventArray;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Dec 15 14:34:51 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[super interpretKeyEvents:eventArray];
    return;
}
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= NSApplication(iTM2KeyStrokeKit)
/*"Description forthcoming."*/
@implementation NSApplication(iTM2KeyStrokeKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= tryToReallyPerform:with:
- (BOOL)tryToReallyPerform:(SEL)action with:(id)argument;
/*"YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Dec 15 14:34:51 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSMethodSignature * MS = [self methodSignatureForSelector:action];
    NSMethodSignature * myMS = [self methodSignatureForSelector:@selector(__reallyPerformSelectorTemplate:)];
    NSMethodSignature * myOtherMS = [self methodSignatureForSelector:@selector(forwardInvocation:)];
    if([MS isEqual:myMS])
    {
        NSInvocation * I = [NSInvocation invocationWithMethodSignature:MS];
        [I setSelector:action];
        if(argument)
            [I setArgument:&argument atIndex:2];
        [I invokeWithTarget:self];
        BOOL result;
        [I getReturnValue:&result];
        return result;
    }
    if([MS isEqual:myOtherMS])
    {
        NSInvocation * I = [NSInvocation invocationWithMethodSignature:MS];
        [I setSelector:action];
        if(argument)
            [I setArgument:&argument atIndex:2];
        [I invokeWithTarget:self];
        return YES;
    }
    if([[self nextResponder] tryToReallyPerform:action with:argument])
        return YES;
    MS = [[self delegate] methodSignatureForSelector:action];
    if([MS isEqual:myMS])
    {
        NSInvocation * I = [NSInvocation invocationWithMethodSignature:MS];
        [I setSelector:action];
        if(argument)
            [I setArgument:&argument atIndex:2];
        [I invokeWithTarget:[self delegate]];
        BOOL result;
        [I getReturnValue:&result];
        return result;
    }
    if([MS isEqual:myMS])
    {
        NSInvocation * I = [NSInvocation invocationWithMethodSignature:MS];
        [I setSelector:action];
        if(argument)
            [I setArgument:&argument atIndex:2];
        [I invokeWithTarget:[self delegate]];
        return YES;
    }
    return NO;
//iTM2_END;
}
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= NSObject(iTM2KeyStrokeKit)
/*"Description forthcoming."*/
@implementation NSObject(iTM2KeyStrokeKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= handlesKeyStrokes
- (BOOL)handlesKeyStrokes;
/*"YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Dec 15 14:34:51 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= interpretKeyStroke:
- (BOOL)interpretKeyStroke:(NSString *)key;
/*"YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Dec 15 14:34:51 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return NO;
//iTM2_END;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= executeMacroWithIdentifier:
- (BOOL)executeMacroWithIdentifier:(NSString *)key;
/*"YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Dec 15 14:34:51 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return NO;
//	+ (BOOL) executeMacroWithKey: (NSString *) key inCategory: (NSString *) category ofDomain: (NSString *) domain;

//iTM2_END;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  executeStringInstruction:
- (BOOL)executeStringInstruction:(NSString *)instruction;
/*"Description forthcoming.
If the event is a 1 char key down, it will ask the current key binding for instruction.
The key and its modifiers are 
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return NO;
}
@end

#import <iTM2Foundation/iTM2ResponderKit.h>

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2Inspector(iTM2KeyBindingsKitSupport)
/*"Description forthcoming."*/
@implementation iTM2KeyBindingsResponder
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  contextManager
- (id)contextManager;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSWindow * W = [NSApp keyWindow];
    return [W firstResponder]? [[W firstResponder] contextManager]:[W contextManager];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  toggleNoKeyBindings:
- (IBAction)toggleNoKeyBindings:(id)irrelevant;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self takeContextBool:![self contextBoolForKey:iTM2NoKeyBindingsIdentifier] forKey:iTM2NoKeyBindingsIdentifier];
    [self flushKeyBindings:nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  validateToggleNoKeyBindings:
- (BOOL)validateToggleNoKeyBindings:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setState:([self contextBoolForKey:iTM2NoKeyBindingsIdentifier]? NSOffState:NSOnState)];
    return YES;
}
@end

#import <iTM2Foundation/iTM2TextDocumentKit.h>

@implementation iTM2TextInspector(iTM2KeyBindingsKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  handlesKeyBindings
- (BOOL)handlesKeyBindings;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return YES;
}
@end

#if 0
@interface MyWindow: NSWindow
@end
@implementation MyWindow: NSWindow
+ (void)load;
{iTM2_DIAGNOSTIC;
	[MyWindow poseAsClass:[NSWindow class]];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= performKeyEquivalent:
- (BOOL)performKeyEquivalent:(NSEvent *)theEvent;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Dec 15 14:34:51 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	BOOL result = [super performKeyEquivalent:(NSEvent *) theEvent];
//iTM2_LOG(@"[self title]; %@, performKeyEquivalent:%@", [self title], (result? @"Y":@"N"));
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= keyDown:
- (void)keyDown:(NSEvent *)theEvent;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Dec 15 14:34:51 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_LOG(@"[self firstResponder]:%@", [self firstResponder]);
//iTM2_LOG(@"[self title]:%@", [self title]);
	[super keyDown:(NSEvent *) theEvent];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= makeFirstResponder:
- (BOOL)makeFirstResponder:(NSResponder *)aResponder;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Dec 15 14:34:51 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	iTM2_LOG(@"[self title]:%@", [self title]);
	if([[self title] isEqual:@"Find"])
	{
		iTM2_LOG(@"aResponder: %@", aResponder);
		BOOL result = [super makeFirstResponder:(NSResponder *)aResponder];
		iTM2_LOG(@"[self firstResponder]:%@", [self firstResponder]);
		return result;
	}
    return [super makeFirstResponder:(NSResponder *)aResponder];
}
@end
#endif
