/*
//  iTeXMac2 1.4
//
//  @version Subversion: $Id$ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Wed Sep 15 21:07:40 GMT 2004.
//  Copyright © 2004 Laurens'Tribune. All rights reserved.
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
#define __iTM2_BUG_TRACKING__ 1
#ifdef __iTM2_BUG_TRACKING__
	#warning DEBUGGGGGGGGGGGGGGGG
#endif
#ifdef __iTM2_NO_XTD_SPELL__
#warning *** NO XTD SPELL
#else
#endif
#if 1
#import <iTM2Foundation/iTM2SpellKit.h>
#import <iTM2Foundation/iTM2BundleKit.h>
#import <iTM2Foundation/iTM2ContextKit.h>
#import <iTM2Foundation/iTM2InstallationKit.h>

NSString * const iTM2UDContinuousSpellCheckingKey = @"iTM2CheckSpellingAsYouType";

NSString * const iTM2CurrentSpellLanguageKey = @"iTM2CurrentSpellLanguage";
NSString * const iTM2SpellContextsKey = @"iTM2SpellContexts";
NSString * const iTM2SpellContextModesKey = @"iTM2SpellContextModes";

// This are part of the TeX Wrapper Structure specifications version 1, maybe
NSString * const TWSSpellLanguageKey = @"language";
NSString * const TWSSpellIgnoredWordsKey = @"words";
NSString * const TWSSpellExtension = @"plist";
NSString * const TWSSpellIsaKey = @"isa";
NSString * const TWSSpellIsaValue = @"spelling";
NSString * const TWSSpellDefaultContextMode = @"default";

NSString * const iTM2SpellModesIsaValue = @"Spelling Context Modes";
NSString * const iTM2SpellModesKey = @"Modes";
NSString * const iTM2SpellContextModeKey = @"Spell Context Mode";

NSString * const iTM2SpellKitTable = @"Spell";

#define SSC [NSSpellChecker sharedSpellChecker]

@implementation iTM2SpellContext
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  initialize
+ (void)initialize;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
	iTM2_INIT_POOL;
//iTM2_START;
    [super initialize];
	[SUD registerDefaults:[NSDictionary dictionaryWithObject:@"en" forKey:iTM2CurrentSpellLanguageKey]];
//iTM2_END;
	iTM2_RELEASE_POOL;
   return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  init
- (id)init;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(self = [super init])
    {
        [self setSpellLanguage:[SUD objectForKey:iTM2CurrentSpellLanguageKey]];
        [self setIgnoredWords:[NSArray array]];
        ivarTag = [NSSpellChecker uniqueSpellDocumentTag];// last
    }
    return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  readFromURL:error:
- (BOOL)readFromURL:(NSURL *)fileURL error:(NSError**)outErrorPtr;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed 05 mar 03
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSData * D = [NSData dataWithContentsOfURL:fileURL options:0 error:outErrorPtr];
    if([D length])
    {
        NSString * errorString = nil;
        id DM = [NSPropertyListSerialization propertyListFromData:D
            mutabilityOption: NSPropertyListImmutable
                format: nil errorDescription: &errorString];
        if(errorString)
        {
            iTM2Beep();
            NSLog(@"Big problem\nReport BUG ref: iTM2168");
            NSLog(@"error string: '%@'", errorString);
            [errorString autorelease];
            errorString = nil;
        }
//NSLog(@"DM: %@", DM);
        if([self loadPropertyListRepresentation:DM])
            return YES;
        iTM2_LOG(@"Corrupted spelling context at:\n%@", fileURL);
    }
//iTM2_END;
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  loadPropertyListRepresentation:
- (BOOL)loadPropertyListRepresentation:(id)PL;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed 05 mar 03
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    BOOL result = NO;
    NS_DURING
    if([[PL valueForKey:TWSSpellIsaKey] isEqual:TWSSpellIsaValue])
    {
        id O;
        if(O = [PL valueForKey:TWSSpellLanguageKey])
            [self setSpellLanguage:O];
        if(O = [PL valueForKey:TWSSpellIgnoredWordsKey])
            [self replaceIgnoredWords:O];
        result = YES;
    }
	else if(PL)
	{
		iTM2_LOG(@"BAD or missing value for %@ key: %@ was expected", TWSSpellIsaKey, TWSSpellIsaValue);
	}
    NS_HANDLER
	iTM2_LOG(@"***  EXCEPTION CATCHED: BAD property list, %@", [localException reason]);
    NS_ENDHANDLER
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  propertyListRepresentation
- (id)propertyListRepresentation;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed 05 mar 03
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self setIgnoredWords:[SSC ignoredWordsInSpellDocumentWithTag:[self tag]]];
	if([[[SSC currentText] spellContext] isEqual:self])
		[self setSpellLanguage:[SSC language]];
//iTM2_LOG(@"CURRENT LANGUAGE IS: %@, current spell context is: %#x", [SSC language], [[SSC currentText] spellContext]);
    return [NSDictionary dictionaryWithObjectsAndKeys:
                TWSSpellIsaValue, TWSSpellIsaKey,
                [self spellLanguage], TWSSpellLanguageKey,
                [self ignoredWords], TWSSpellIgnoredWordsKey,
                    nil];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  writeToURL:error:
- (BOOL)writeToURL:(NSURL *)fileURL error:(NSError**)outErrorPtr;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed 05 mar 03
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([fileURL isFileURL])
	{
		NSString * path = [fileURL path];
		if(![DFM isWritableFileAtPath:path])
		{
			return YES;
		}
	}
    id PL = [self propertyListRepresentation];
    NSString * errorString = nil;
    id D = [NSPropertyListSerialization dataFromPropertyList:PL
        format: NSPropertyListXMLFormat_v1_0 errorDescription: &errorString];
    if(errorString)
    {
        iTM2Beep();
        iTM2_LOG(@"Big problem\nReport BUG ref: iTM2861, error string: '%@'\nPropery List: %@", errorString, PL);
        [errorString autorelease];
        errorString = nil;
    }
//NSLog(@"data: %@", result);
//iTM2_END;
    return [D writeToURL:fileURL options:NSAtomicWrite error:outErrorPtr];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  dealloc
- (void)dealloc;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
    [self setSpellLanguage:nil];
    [self setIgnoredWords:nil];
    [SSC closeSpellDocumentWithTag:ivarTag];
    [super dealloc];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  tag
- (int)tag;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return ivarTag;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  spellLanguage
- (NSString *)spellLanguage;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return ivarLanguage;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  setSpellLanguage:
- (void)setSpellLanguage:(NSString *)argument;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(argument && ![argument isKindOfClass:[NSString class]])
        [NSException raise:NSInvalidArgumentException format:@"%@ NSString argument expected:got %@.",
            isa, NSStringFromSelector(_cmd), argument];
    else if(![argument isEqualToString:ivarLanguage])
    {

//iTM2_LOG(@"THE LANGUAGE HAS CHANGED FROM %@ to %@", ivarLanguage, argument);
        [ivarLanguage autorelease];
        ivarLanguage = [argument copyWithZone:[self zone]];
    }
//iTM2_END;
   return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  ignoredWords
- (NSArray *)ignoredWords;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return ivarIgnoredWords;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  setIgnoredWords:
- (void)setIgnoredWords:(NSArray *)argument;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(argument && ![argument isKindOfClass:[NSArray class]])
        [NSException raise:NSInvalidArgumentException format:@"%@ NSArray argument expected:got %@.",
            isa, NSStringFromSelector(_cmd), argument];
    else if(argument != ivarIgnoredWords)
    {
        NSMutableArray * MRA = [NSMutableArray array];
        NSEnumerator * E = [argument objectEnumerator];
        id O;
        while(O = [E nextObject])
            if([O isKindOfClass:[NSString class]])
                [MRA addObject:O];
        [ivarIgnoredWords autorelease];
        ivarIgnoredWords = [MRA copyWithZone:[self zone]];
//iTM2_LOG(@"ivarIgnoredWords are: %@", ivarIgnoredWords);
    }
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  replaceIgnoredWords:
- (void)replaceIgnoredWords:(NSArray *)argument;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self setIgnoredWords:argument];
	[SSC setIgnoredWords:[self ignoredWords] inSpellDocumentWithTag:[self tag]];
//iTM2_END;
    return;
}
@end

@implementation NSWindow(iTM2SpellKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  spellContextController
- (id)spellContextController;
/*"Asks a delegate for a non empty #{spellContextController}.
The delegate is the first one that gives a sensitive answer among the receiver's delegate, its window's delegate, the document of its window's controller, the owner of its window's controller. In that specific order.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [[self windowController] spellContextController];
}
@end

@implementation NSWindowController(iTM2SpellKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  spellContextController
- (id)spellContextController;
/*"Asks the document or the owner.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    id D = [self document];
    if(D)
        return [D spellContextController];
    if((D = [self owner]) && (D!=self))
        return [D spellContextController];
    return [super spellContextController];
}
@end

@implementation NSObject(iTM2SpellKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  spellContextController
- (id)spellContextController;
/*"Asks the document or the owner.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [iTM2SpellContextController defaultSpellContextController];
}
@end


@interface NSSpellChecker(iTeXMac2)
- (void)updateGuessesList;
- (NSButton *)guessButton;
@end

@interface NSSpellChecker_iTeXMac2: NSSpellChecker
@end

@interface NSTextView_iTM2SpellKit: NSTextView
@end

#import <iTM2Foundation/iTM2ContextKit.h>

@implementation NSTextView_iTM2SpellKit: NSTextView
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  spellCheckerDocumentTag
- (int)spellCheckerDocumentTag;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [[self spellContext] tag];
}
#if 0
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  setSelectedRange:affinity:stillSelecting:
- (void)setSelectedRange:(NSRange)charRange affinity:(NSSelectionAffinity)affinity stillSelecting:(BOOL)stillSelectingFlag;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [super setSelectedRange:charRange affinity:affinity stillSelecting:stillSelectingFlag];
    if(!stillSelectingFlag && [self window] && ([[self window] level] < [[SSC spellingPanel] level]))// avoid recursion when no window
    {
        NSString * S = [[self string] substringWithRange:[self selectedRange]];
		if([S length])
		{
			[SSC updateSpellingPanelWithMisspelledWord:S];
			[SSC updateGuessesList];
		}
    }
//iTM2_END;
    return;
}
#endif
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setContinuousSpellCheckingEnabled:
- (void)setContinuousSpellCheckingEnabled:(BOOL)flag;
/*"Default implementation does nothing.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    BOOL old = [self isContinuousSpellCheckingEnabled];
    if(old != flag)
	{
        [super setContinuousSpellCheckingEnabled:flag];
		[self takeContextBool:[self isContinuousSpellCheckingEnabled] forKey:iTM2UDContinuousSpellCheckingKey domain:iTM2ContextAllDomainsMask];
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleContinuousSpellChecking:
- (IBAction)toggleContinuousSpellChecking:(id)sender;
/*"Default implementation does nothing.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [super toggleContinuousSpellChecking:sender];
	BOOL yorn = [self isContinuousSpellCheckingEnabled];
	[self takeContextBool:yorn forKey:iTM2UDContinuousSpellCheckingKey domain:iTM2ContextAllDomainsMask];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  contextDidChange
- (void)contextDidChange;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 04/04/2002
To Do List: ...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	BOOL yorn = [self contextBoolForKey:iTM2UDContinuousSpellCheckingKey domain:iTM2ContextAllDomainsMask];
    [self setContinuousSpellCheckingEnabled:yorn];
	[super contextDidChange];
	[self contextDidChangeComplete];
//iTM2_END;
    return;
}
@end

@interface iTM2SpellContextController(iTM2SpellKit)
+ (void)_writeToUserDefaults;
+ (void)completeInitialization;
@end

@interface iTM2SpellCheckerHelper(PRIVATE0)
- (void)_1stResponderMightHaveChanged:(id)irrelevant;
@end

@implementation iTM2MainInstaller(iTM2SpellContextController)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  spellContextControllerCompleteInstallation
+ (void)spellContextControllerCompleteInstallation;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[iTM2SpellContextController completeInitialization];
//iTM2_END;
	return;
}
@end
@implementation iTM2SpellContextController
static id _iTM2SpellContextController = nil;
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  completeInitialization
+ (void)completeInitialization;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(!_iTM2SpellContextController)
    {
        [super initialize];
        iTM2SpellContext * SC = [[[iTM2SpellContext alloc] init] autorelease];
        [SUD registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:
            [NSDictionary dictionaryWithObject:[SC propertyListRepresentation] forKey:TWSSpellDefaultContextMode], iTM2SpellContextsKey,
            [NSDictionary dictionary], iTM2SpellContextModesKey,
                    nil]];
        _iTM2SpellContextController = [[self alloc] init];
        NSDictionary * D = [SUD dictionaryForKey:iTM2SpellContextsKey];
        NSEnumerator * E = [D keyEnumerator];
        NSString * mode;
        while(mode = [E nextObject])
        {
            iTM2SpellContext * SC = [[[iTM2SpellContext allocWithZone:[_iTM2SpellContextController zone]] init] autorelease];
            if(SC)
            {
                [SC loadPropertyListRepresentation:[D objectForKey:mode]];
                [_iTM2SpellContextController setSpellContext:SC forMode:mode];
            }
        }
//iTM2_LOG(@"THE DEFAULT SPELL CONTEXTS HAVE BEEN CREATED");
        [DNC addObserver:self
            selector: @selector(_applicationWillTerminateNotified:)
                name: NSApplicationWillTerminateNotification
                    object: NSApp];
    }
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  _applicationWillTerminateNotified:
+ (void)_applicationWillTerminateNotified:(NSNotification *)notification;
/*"Designated intializer.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [DNC removeObserver:self name:[notification name] object:nil];
    [self _writeToUserDefaults];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  _writeToUserDefaults
+ (void)_writeToUserDefaults;
/*"Designated intializer.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [SCH _1stResponderMightHaveChanged:nil];
    iTM2SpellContextController * controller = [self defaultSpellContextController];
    NSArray * newModes = [[controller spellContextModesEnumerator] allObjects];
    NSMutableDictionary * MD = [[[SUD dictionaryForKey:iTM2SpellContextsKey] mutableCopy] autorelease];
    NSEnumerator * E = [MD keyEnumerator];
    NSString * mode;
    while(mode = [E nextObject])
        if(![newModes containsObject:mode])
            [MD removeObjectForKey:mode];
    E = [newModes objectEnumerator];
    while(mode = [E nextObject])
        [MD setObject:[[controller spellContextForMode:mode] propertyListRepresentation] forKey:mode];
    [SUD setObject:MD forKey:iTM2SpellContextsKey];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  defaultSpellContextController
+ (id)defaultSpellContextController;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return _iTM2SpellContextController;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  init
- (id)init;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(self = [super init])
    {
        [self setSpellContexts:[NSDictionary dictionary]];
        iTM2SpellContext * SC = [[[iTM2SpellContext allocWithZone:
            [[iTM2SpellContextController defaultSpellContextController] zone]]
                init] autorelease];
        [SC loadPropertyListRepresentation:[[SUD objectForKey:iTM2SpellContextsKey] objectForKey:TWSSpellDefaultContextMode]];
        [self setSpellContext:SC forMode:TWSSpellDefaultContextMode];
//iTM2_LOG(@"[self spellContexts] are:\n%@", [self spellContexts]);
//iTM2_LOG(@"MAIN SPELL CONTEXT CREATED...");
    }
//iTM2_END;
    return self;
}
#pragma mark =-=-=-=-=-  Spell modes management
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  addSpellMode:
- (BOOL)addSpellMode:(NSString *)mode;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(![mode isKindOfClass:[NSString class]])
        return NO;
    else if([mode length] && ![self spellContextForMode:mode])
    {
        [self setSpellContext:[[[iTM2SpellContext allocWithZone:[self zone]] init] autorelease] forMode:mode];
//NSLog(@"NEW MODE CREATED: %@\n%@", mode, MD);
        [self updateChangeCount:NSChangeDone];
//iTM2_END;
        return YES;
    }
//iTM2_END;
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  removeSpellMode:
- (BOOL)removeSpellMode:(NSString *)mode;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if([self spellContextForMode:mode])
    {
        [self setSpellContext:nil forMode:mode];
        [self updateChangeCount:NSChangeDone];
//iTM2_END;
        return YES;
    }
//iTM2_END;
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  spellContextModesEnumerator
- (NSEnumerator *)spellContextModesEnumerator;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [[[self spellContexts] allKeys] objectEnumerator];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  spellContextModeForText:
- (NSString *)spellContextModeForText:(NSText *)text;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    NSString * mode = [text contextValueForKey:iTM2SpellContextModeKey domain:iTM2ContextAllDomainsMask];
    if(![self spellContextForMode:mode])
    {
        mode = TWSSpellDefaultContextMode;
        [text takeContextValue:mode forKey:iTM2SpellContextModeKey domain:iTM2ContextAllDomainsMask];
    }
//iTM2_END;
    return mode;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  setSpellContextMode:forText:
- (void)setSpellContextMode:(NSString *)mode forText:(id)text;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [text takeContextValue:mode forKey:iTM2SpellContextModeKey domain:iTM2ContextAllDomainsMask];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  spellPrettyNameForText:
- (NSString *)spellPrettyNameForText:(NSText *)text;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSDocument * D = [[[text window] windowController] document];
    return D? [D displayName]:[[text window] title];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  spellContextForMode:
- (id)spellContextForMode:(NSString *)mode;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    id result = [[self spellContexts] objectForKey:mode];
    if(!result)
    {
		if([mode isEqualToString:TWSSpellDefaultContextMode])
		{
			iTM2SpellContext * SC = [[[iTM2SpellContext allocWithZone:
				[[iTM2SpellContextController defaultSpellContextController] zone]]
					init] autorelease];
			[SC loadPropertyListRepresentation:[[SUD objectForKey:iTM2SpellContextsKey] objectForKey:TWSSpellDefaultContextMode]];
			[self setSpellContext:SC forMode:TWSSpellDefaultContextMode];
			result = SC;
		}
		else if(iTM2DebugEnabled)
		{
			iTM2_LOG(@"SORRY, [self spellContexts] are:\n%@", [self spellContexts]);
		}
    }
//iTM2_END;
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  setSpellContext:forMode:
- (void)setSpellContext:(id)newContext forMode:(NSString *)mode;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(newContext)
        [[self spellContexts] setObject:newContext forKey:mode];
    else
        [[self spellContexts] removeObjectForKey:mode];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  spellContexts
- (id)spellContexts;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return metaGETTER;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  setSpellContexts:
- (void)setSpellContexts:(id)newContexts;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSParameterAssert(!newContexts || [newContexts isKindOfClass:[NSDictionary class]]);
    metaSETTER([[newContexts mutableCopy] autorelease]);// a dictionary is expected
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  propertyListRepresentation
- (id)propertyListRepresentation;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSMutableDictionary * MD = [NSMutableDictionary dictionaryWithObject:iTM2SpellModesIsaValue forKey:TWSSpellIsaKey];
	NSMutableDictionary * md = [NSMutableDictionary dictionary];
	NSEnumerator * E = [[self spellContexts] keyEnumerator];
	id mode;
	while(mode = [E nextObject])
		[md setObject:[[self spellContextForMode:mode] propertyListRepresentation] forKey:mode];
    [MD setObject:md forKey:iTM2SpellModesKey];
//iTM2_END;
    return MD;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  loadPropertyListRepresentation:
- (BOOL)loadPropertyListRepresentation:(id)PL;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed 05 mar 03
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    BOOL result = NO;
    NS_DURING
    if([[PL valueForKey:TWSSpellIsaKey] isEqual:iTM2SpellModesIsaValue])
    {
		[self setSpellContexts:[NSDictionary dictionary]];
        NSDictionary * d = [PL objectForKey:iTM2SpellModesKey];
        if([d isKindOfClass:[NSDictionary class]])
        {
            NSEnumerator * E = [d keyEnumerator];
            NSString * mode;
            while(mode = [E nextObject])
            {
                iTM2SpellContext * SC = [[[iTM2SpellContext alloc] init] autorelease];
                if([SC loadPropertyListRepresentation:[d objectForKey:mode]])
                    [self setSpellContext:SC forMode:mode];
                else
                    result = NO;
            }
        }
//iTM2_LOG(@"SPELL CONTEXTS LOADED...\n%@", [self propertyListRepresentation]);
    }
	else if(PL)
	{
		iTM2_LOG(@"BAD or missing value for %@ key: %@ was expected", TWSSpellIsaKey, iTM2SpellModesIsaValue);
	}
    NS_HANDLER
	iTM2_LOG(@"***  EXCEPTION CATCHED: BAD property list, %@", [localException reason]);
    NS_ENDHANDLER
//iTM2_END;
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  isEdited
- (BOOL)isEdited;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [[[self implementation] metaValueForKey:@"ChangeCount"] intValue] != 0;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  updateChangeCount
- (void)updateChangeCount:(NSDocumentChangeType)change;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	int changeCount = [[[self implementation] metaValueForKey:@"ChangeCount"] intValue];
    if(change == NSChangeDone)
        ++changeCount;
    else if(change == NSChangeUndone)
        --changeCount;
    else
        changeCount = 0;
	[[self implementation] takeMetaValue:[NSNumber numberWithInt:changeCount] forKey:@"ChangeCount"];
//iTM2_END;
    return;
}
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  iTM2SpellCheckerHelper

#import <iTM2Foundation/iTM2WindowKit.h>

@implementation iTM2IgnoredWordsWindow 
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= frameIdentifier
- (NSString *)frameIdentifier;
/*"Subclasses should override this method. The default implementation returns a 0 length string, and deactivates the 'register current frame' process.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri May 21 07:52:07 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return @"iTM2IgnoredWords";
}
#if 1
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  displayIfNeeded
- (void)displayIfNeeded;
/*"Returns the contextManager of its window controller.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[super displayIfNeeded];
//iTM2_END;
    return;
}
#endif
@end

@interface _iTM2IgnoredWordsEditor: NSWindowController
{
@private
    NSValue *		iVarCurrentTextRef;
    NSTableView *	iVarTableView;
    NSTextField *	iVarModeField;
    NSTextField *	iVarProjectField;
    NSMutableArray *	iVarIgnoredWords;
    int			iVarSpellDocumentTag;
}
+ (id)sharedEditor;
- (BOOL)addIgnoredWord:(NSString *)argument;
- (BOOL)smartReplaceIgnoredWord:(NSString *)oldArgument by:(NSString *)newArgument;
- (BOOL)replaceIgnoredWord:(NSString *)oldArgument by:(NSString *)newArgument;
- (NSMutableArray *)ignoredWords;
- (void)setIgnoredWords:(NSArray *)argument;
- (void)setCurrentText:(NSText *)currentText;
@end

#import <iTM2Foundation/iTM2ValidationKit.h>

@interface NSText(iTM2SpellKit0)
- (int)spellCheckerDocumentTag;
@end

@implementation _iTM2IgnoredWordsEditor
static id _iTM2SpellIgnoredWordsEditor = nil;
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  sharedEditor
+ (id)sharedEditor;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(!_iTM2SpellIgnoredWordsEditor)
	{
		_iTM2SpellIgnoredWordsEditor = [[_iTM2IgnoredWordsEditor allocWithZone:[self zone]]
            initWithWindowNibName: @"iTM2IgnoredWordsEditor"];
	}
//iTM2_END;
    return _iTM2SpellIgnoredWordsEditor;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  dealloc
- (void)dealloc;
/*"Creating a new entry in the ignored words list.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
    [iVarTableView setDelegate:nil];
    [iVarCurrentTextRef autorelease];
	iVarCurrentTextRef = nil;
    iVarTableView = nil;
    iVarModeField = nil;
    iVarProjectField = nil;
    [iVarIgnoredWords autorelease];
    iVarIgnoredWords = nil;
    [super dealloc];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  windowDidLoad
- (void)windowDidLoad;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[super windowDidLoad];
    [self validateWindowContent];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  currentText
- (NSText *)currentText;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [iVarCurrentTextRef nonretainedObjectValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  setCurrentText:
- (void)setCurrentText:(NSText *)currentText;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [iVarCurrentTextRef autorelease];
	if(currentText)
	{
		iVarCurrentTextRef = [[NSValue valueWithNonretainedObject:currentText] retain];
		iTM2SpellContextController * currentController = [currentText spellContextController];
		NSString * currentMode = [currentController spellContextModeForText:currentText];
		iTM2SpellContext * currentContext = [currentController spellContextForMode:currentMode];
		[iVarIgnoredWords autorelease];
		iVarIgnoredWords = ([[SSC ignoredWordsInSpellDocumentWithTag:[currentContext tag]] mutableCopy]?
			: [[NSMutableArray array] retain]);
		[iVarIgnoredWords sortUsingSelector:@selector(compare:)];
		[iVarTableView reloadData];
		[self validateWindowContent];
	}
	else
		iVarCurrentTextRef = nil;
//iTM2_END;
    return;
}
#pragma mark =-=-=-=-=-  MESSAGING
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  new:
- (void)new:(id)sender;
/*"Creating a new entry in the ignored words list.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//    [[sender window] makeFirstResponder:nil];
    [iVarTableView abortEditing];
    NSString * newArgument = @"?";
    if([self addIgnoredWord:newArgument])
    {
        [iVarTableView reloadData];
        [iVarTableView display];
        int row = [iVarIgnoredWords indexOfObject:newArgument];
        if(row>=0)
        {
            [iVarTableView deselectAll:self];
            [iVarTableView selectRow:row byExtendingSelection:NO];
//            [iVarTableView scrollRowToVisible:row];
            [iVarTableView editColumn:0 row:[iVarTableView selectedRow] withEvent:nil select:YES];
            return;
        }
    }
    NSLog(@"%@ %#x PROBLEM: could not add %@", __PRETTY_FUNCTION__, self, newArgument);
    iTM2Beep();
//NSLog(@"ignored words: %@", iVarIgnoredWords);
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  ok:
- (void)ok:(id)sender;
/*"Message sent when all is finished.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    while([iVarIgnoredWords containsObject:@"?"])
        [iVarIgnoredWords removeObject:@"?"];
    iTM2SpellContext * currentContext = [[self currentText] spellContext];
    [currentContext replaceIgnoredWords:iVarIgnoredWords];
    [self setCurrentText:nil];// necessary
    [NSApp stopModal];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  cancel:
- (void)cancel:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [NSApp stopModal];
    [self setCurrentText:nil];// necessary
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  check:
- (void)check:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    iTM2Beep();
    return;
}
#pragma mark =-=-=-=-=-  UI Validation
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  projectNameEdited:
- (IBAction)projectNameEdited:(id)sender;
/*"Just a message catcher.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  validateProjectNameEdited:
- (BOOL)validateProjectNameEdited:(id)sender;
/*"Catcher.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSString * name = [[self currentText] spellPrettyProjectName];
    [sender setStringValue:([name length]? name:
        NSLocalizedStringFromTableInBundle(@"None", iTM2SpellKitTable,
            [self classBundle], "No project/text/mode name for the spell check document"))];
//iTM2_END;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  modeNameEdited:
- (IBAction)modeNameEdited:(id)sender;
/*"Just a message catcher.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  validateModeNameEdited:
- (BOOL)validateModeNameEdited:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSString * currentMode = [[self currentText] spellContextMode];
    [sender setStringValue:([currentMode length]? currentMode:
        NSLocalizedStringFromTableInBundle(@"None", iTM2SpellKitTable,
            [self classBundle], "No project/text/mode name for the spell check document"))];
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  numberOfIgnoredWordsEdited:
- (IBAction)numberOfIgnoredWordsEdited:(id)sender;
/*"Just a message catcher.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  validateNumberOfIgnoredWordsEdited:
- (BOOL)validateNumberOfIgnoredWordsEdited:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    int total = [self numberOfRowsInTableView:iVarTableView];
    if([iVarTableView numberOfSelectedRows] == 1)
        [sender setStringValue:[NSString stringWithFormat:@"%i/%i",
                    [iVarTableView selectedRow]+1, total]];
    else
        [sender setStringValue:[NSString stringWithFormat:@"%i", total]];
//iTM2_END;
    return YES;
}
#pragma mark =-=-=-=-=-  TABLE VIEW MANAGEMENT
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  setTableView:
- (void)setTableView:(NSTableView *)tableView;
/*"Description forthcoming. Passive delegate.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    iVarTableView = tableView;
	if(tableView)
	{
		[iVarTableView setDelegate:self];
		[iVarTableView setTarget:self];
		[iVarTableView setDataSource:self];
		[iVarTableView reloadData];
		[iVarTableView setNeedsDisplay:YES];
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  numberOfRowsInTableView:
- (int)numberOfRowsInTableView:(NSTableView *)tableView;
/*"Description forthcoming. Passive delegate.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [iVarIgnoredWords count];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  tableView:objectValueForTableColumn:row:
- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(int)row;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return ((row>-1) && ((row<[iVarIgnoredWords count]))? [iVarIgnoredWords objectAtIndex:row]:@"?");
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  tableView:setObjectValue:forTableColumn:row:
- (void)tableView:(NSTableView *)tableView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn row:(int)row;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSString * oldArgument = ((row>-1) && ((row<[iVarIgnoredWords count]))? [iVarIgnoredWords objectAtIndex:row]:nil);
    if(oldArgument && [self smartReplaceIgnoredWord:oldArgument by:object])
    {
        [tableView reloadData];
        [tableView setNeedsDisplay:YES];
        int row = [iVarIgnoredWords indexOfObject:object];
        [tableView selectRow:row byExtendingSelection:NO];
        [tableView scrollRowToVisible:row];
    }
    else
    {
//iTM2_START;
        NSLog(@"No replacement of %@ by %@", oldArgument, object);
        [tableView reloadData];// bad word given:things should change
        [tableView setNeedsDisplay:YES];
    }
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  removeSelectedRowsInTableView:
- (void)removeSelectedRowsInTableView:(NSTableView *)TV;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSEnumerator * E = [[[[TV selectedRowEnumerator] allObjects]
                                sortedArrayUsingSelector: @selector(compare:)] reverseObjectEnumerator];
    NSNumber * N;
    while(N = [E nextObject])
    {
        int idx = [N intValue];
        if((idx>=0) && (idx<[iVarIgnoredWords count]))
            [iVarIgnoredWords removeObjectAtIndex:idx];
    }
    [TV reloadData];
    [self validateWindowContent];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  tableViewSelectionDidChange:
- (void)tableViewSelectionDidChange:(NSNotification *)notification;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self validateWindowContent];
	[[self window] makeFirstResponder:[notification object]];
//iTM2_END;
    return;
}
#if 0
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  tableView:shouldEditTableColumn:tableColumn row:
- (BOOL)tableView:(NSTableView *)tableView shouldEditTableColumn:(NSTableColumn *)tableColumn row:(int)row;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return YES;
}
// optional

// optional - drag and drop support
- (BOOL)tableView:(NSTableView *)tv writeRows:(NSArray*)rows toPasteboard:(NSPasteboard*)pboard;
    // This method is called after it has been determined that a drag should begin, but before the drag has been started.  To refuse the drag, return NO.  To start a drag, return YES and place the drag data onto the pasteboard (data, owner, etc...).  The drag image and other drag related information will be set up and provided by the table view once this call returns with YES.  The rows array is the list of row numbers that will be participating in the drag.

- (NSDragOperation)tableView:(NSTableView*)tv validateDrop:(id <NSDraggingInfo>)info proposedRow:(int)row proposedDropOperation:(NSTableViewDropOperation)op;
    // This method is used by NSTableView to determine a valid drop target.  Based on the mouse position, the table view will suggest a proposed drop location.  This method must return a value that indicates which dragging operation the data source will perform.  The data source may "re-target" a drop if desired by calling setDropRow:dropOperation: and returning something other than NSDragOperationNone.  One may choose to re-target for various reasons (eg. for better visual feedback when inserting into a sorted position).

- (BOOL)tableView:(NSTableView*)tv acceptDrop:(id <NSDraggingInfo>)info row:(int)row dropOperation:(NSTableViewDropOperation)op;
    // This method is called when the mouse is released over an outline view that previously decided to allow a drop via the validateDrop method.  The data source should incorporate the data from the dragging pasteboard at this time.



- (void)tableView:(NSTableView *)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn row:(int)row;
- (BOOL)selectionShouldChangeInTableView:(NSTableView *)aTableView;
- (BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(int)row;
- (BOOL)tableView:(NSTableView *)tableView shouldSelectTableColumn:(NSTableColumn *)tableColumn;

- (void)tableView:(NSTableView*)tableView mouseDownInHeaderOfTableColumn:(NSTableColumn *)tableColumn;
- (void)tableView:(NSTableView*)tableView didClickTableColumn:(NSTableColumn *)tableColumn;
- (void)tableView:(NSTableView*)tableView didDragTableColumn:(NSTableColumn *)tableColumn;
- (void)tableViewColumnDidMove:(NSNotification *)notification;
- (void)tableViewColumnDidResize:(NSNotification *)notification;
- (void)tableViewSelectionIsChanging:(NSNotification *)notification;
#endif
#pragma mark =-=-=-=-=-  MANAGING WORDS
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  isWellFormedWord:
- (BOOL)isWellFormedWord:(NSString *)argument;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if([argument isKindOfClass:[NSString class]])
    {
        NSRange R = [argument rangeOfCharacterFromSet:[[NSCharacterSet letterCharacterSet] invertedSet]];
        return R.location == NSNotFound;
    }
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  isMisspelledWord:
- (BOOL)isMisspelledWord:(NSString *)argument;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSRange R = [SSC checkSpellingOfString:argument
        startingAt: 0
            language: [SSC language]
                wrap: NO
                    inSpellDocumentWithTag: [[self currentText] spellCheckerDocumentTag]
                        wordCount: nil];
    return R.location != NSNotFound;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  smartAddIgnoredWord:
- (BOOL)smartAddIgnoredWord:(NSString *)argument;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [self isWellFormedWord:argument] && [self isMisspelledWord:argument] && [self addIgnoredWord:argument];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  addIgnoredWord:
- (BOOL)addIgnoredWord:(NSString *)argument;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    // finding where to insert the word:
    int index = 0;
    while(index < [iVarIgnoredWords count])
    {
        NSComparisonResult CR = [argument compare:[iVarIgnoredWords objectAtIndex:index]];
        if(CR == NSOrderedSame)
            return NO;
        else if(CR == NSOrderedDescending)
            break;
        ++index;
    }
    [iVarIgnoredWords insertObject:argument atIndex:index];
//NSLog(@"%@", iVarIgnoredWords);
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  removeIgnoredWord:
- (BOOL)removeIgnoredWord:(NSString *)argument;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    int index = [iVarIgnoredWords indexOfObject:argument];
    if(index != NSNotFound)
    {
        [iVarIgnoredWords removeObject:argument];
        return YES;
    }
    else
        return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  smartReplaceIgnoredWord:by:
- (BOOL)smartReplaceIgnoredWord:(NSString *)oldArgument by:(NSString *)newArgument;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [self isWellFormedWord:newArgument] && [self isMisspelledWord:newArgument]
                                && [self replaceIgnoredWord:oldArgument by:newArgument];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  replaceIgnoredWord:by:
- (BOOL)replaceIgnoredWord:(NSString *)oldArgument by:(NSString *)newArgument;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    int index = [iVarIgnoredWords indexOfObject:oldArgument];
    if((index != -1) && ![oldArgument isEqualToString:newArgument])
    {
        [iVarIgnoredWords replaceObjectAtIndex:index withObject:newArgument];
        [iVarIgnoredWords sortUsingSelector:@selector(compare:)];
//NSLog(@"%@", iVarIgnoredWords);
        return YES;
    }
    else
        return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  ignoredWords
- (NSMutableArray *)ignoredWords;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return iVarIgnoredWords;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  setIgnoredWords:
- (void)setIgnoredWords:(NSArray *)argument;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [iVarIgnoredWords autorelease];
    iVarIgnoredWords = [argument mutableCopy];
    [iVarIgnoredWords sortUsingSelector:@selector(compare:)];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  contextManager:
- (id)contextManager;
/*"Returns the contextManager of its window controller.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START
	id source = [self currentText];
    return [[source window] windowController] != self? [source contextManager]:nil;
}
@end

@interface iTM2SpellCheckerHelper(PRIVATE)
- (id)currentText;
- (void)setCurrentText:(id)argument;
- (void)setCurrentSpellLanguage:(NSString *)language;
- (BOOL)isEditing;
- (void)setEditing:(BOOL)yorn;
- (void)delayedSetCurrentSpellLanguage:(NSString *)language;
@end

@interface NSText_iTM2SpellKit: NSText
@end

static id _iTM2SpellCheckerHelper = nil;

@implementation iTM2MainInstaller(SpellKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  iTM2SpellKitCompleteInstallation
+ (void)load;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
    iTM2_INIT_POOL;
	[NSBundle redirectNSLogOutput];
//iTM2_START;
	// before Tiger, the following poseAsClass: were performed in the iTM2SpellKitCompleteInstallation
	// this broke NSTextView bindings in Tiger
    if(![NSText instancesRespondToSelector:@selector(iTM2SpellKit_NSText_Catcher:)])
	{
		[NSText_iTM2SpellKit poseAsClass:[NSText class]];
		[NSTextView_iTM2SpellKit poseAsClass:[NSTextView class]];
		[NSSpellChecker_iTeXMac2 poseAsClass:[NSSpellChecker class]];
	}
//iTM2_START;
	iTM2_RELEASE_POOL;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  iTM2SpellKitCompleteInstallation
+ (void)iTM2SpellKitCompleteInstallation;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
    iTM2_INIT_POOL;
//iTM2_START;
	if([SUD boolForKey:@"iTM2DisableMoreSpell"])
	{
		iTM2_LOG(@"No MoreSpell available...");
		iTM2_RELEASE_POOL;
		return;
	}
    [SUD registerDefaults:
        [NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithBool:NO], iTM2UDContinuousSpellCheckingKey,
                nil]];
//iTM2_LOG(@"[SUD objectForKey:iTM2DisableMoreSpell] is:%@", [SUD objectForKey:@"iTM2DisableMoreSpell"]);
#if 0
	This is too late here: it breaks binding
    if(![NSText instancesRespondToSelector:@selector(iTM2SpellKit_NSText_Catcher:)])
	{
		[NSText_iTM2SpellKit poseAsClass:[NSText class]];
		[NSTextView_iTM2SpellKit poseAsClass:[NSTextView class]];
		[NSSpellChecker_iTeXMac2 poseAsClass:[NSSpellChecker class]];
	}
#endif
    _iTM2SpellCheckerHelper = [[iTM2SpellCheckerHelper alloc] initWithWindowNibName:@"iTM2SpellCheckerHelper"];
	[[_iTM2SpellCheckerHelper window] setExcludedFromWindowsMenu:YES];// loads the nib as side effect...
    // installing the accessory view in the spell checker panel
    NSView * V1 = [_iTM2SpellCheckerHelper spellCheckerAccessoryView];
    NSView * V2 = [SSC accessoryView];
//NSLog(@"%@", V);
    if(![V2 isEqual:V1])
    {
        NSPanel * P = [SSC spellingPanel];
//NSLog(NSStringFromSize([P minSize]));
//NSLog(NSStringFromRect([P frame]));
        NSSize S1 = [V1 frame].size;
        NSSize oldS = [P minSize];
        NSRect oldF = [P frame];
        NSSize newS = oldS;
        if(V2)
            newS.height -= [V2 frame].size.height;
        NSSize S2 = [[P contentView] frame].size;
        S1.width = S2.width;
        [V1 setFrameSize:S1];
        newS.height += S1.height;
        [SSC setAccessoryView:V1];
        if(NSEqualSizes([P minSize], oldS))
            [P setMinSize:newS];
        if(!NSEqualRects([P frame], oldF))
            [P setFrame:NSMakeRect(oldF.origin.x, oldF.origin.y, oldF.size.width, MAX(oldF.size.height, newS.height))
                display: YES];
//NSLog(NSStringFromSize([P minSize]));
//NSLog(NSStringFromRect([P frame]));
    }
	if(iTM2DebugEnabled)
	{
		iTM2_LOG(@"the accessory view is: %@", [[SSC accessoryView] description]);
		iTM2_LOG(@"the accessory view was: %@", V2);
		iTM2_LOG(@"the accessory view should be: %@", V1);
	}
//	iTM2_START_TRACKING;
	iTM2_RELEASE_POOL;
    return;
}
@end
@implementation iTM2SpellCheckerHelper
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  sharedHelper
+ (id)sharedHelper;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	return _iTM2SpellCheckerHelper;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  initWithWindow:
- (id)initWithWindow:(NSWindow *)window;
/*"One instance can be created.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(_iTM2SpellCheckerHelper)
    {
		if(self != _iTM2SpellCheckerHelper)
			[self dealloc];
        return [_iTM2SpellCheckerHelper retain];
    }
    else if(self = [super initWithWindow:window])
    {
		[self initImplementation];
        [DNC addObserver:self
            selector: @selector(_windowWillCloseOrDidResignKeyNotified:)
                name: NSWindowDidResignKeyNotification
                    object: nil];
        [DNC addObserver:self
            selector: @selector(_windowDidBecomeKeyNotified:)
                name: NSWindowDidBecomeKeyNotification
                    object: nil];
        [DNC addObserver:self
            selector: @selector(_windowWillCloseOrDidResignKeyNotified:)
                name: NSWindowWillCloseNotification
                    object: nil];
		[DNC addObserver:self
			selector: @selector(textDidEndEditingNotified:)
				name: NSTextDidEndEditingNotification
					object: nil];
    }
    return _iTM2SpellCheckerHelper = self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  dealloc
- (void)dealloc;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
    [self deallocImplementation];
    [super dealloc];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  implementation
- (id)implementation;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon May 10 22:45:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return _iVarPrivateImplementation;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setImplementation:
- (void)setImplementation:(id)argument;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon May 10 22:45:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(argument != _iVarPrivateImplementation)
	{
		[_iVarPrivateImplementation autorelease];
		_iVarPrivateImplementation = [argument retain];
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  windowDidLoad
- (void)windowDidLoad;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[super windowDidLoad];
	[[self window] orderOut:self];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  textDidEndEditingNotified:
- (void)textDidEndEditingNotified:(NSNotification *)notification;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_LOG(@"[SSC language] is:%@", [SSC language]);
	NSText * text = [notification object];
	if(text == [self currentText])
	{
		iTM2SpellContext * SC = [text spellContext];
		if(SC)
		{
			[SC setSpellLanguage:[SSC language]];
			[SC setIgnoredWords:[SSC ignoredWordsInSpellDocumentWithTag:[SC tag]]];
//iTM2_LOG(@"INFO: THE SPELL LANGUAGE AND IGNORED WORDS HAVE BEEN RECORDED FOR THE CURRENT TEXT %#x", text);
		}
		else if(text)
		{
//iTM2_LOG(@"*** ERROR: MISSING SPELL CONTEXT FOR TEXT: %#x in window %@", text, [[text window] title]);
		}
		[self setCurrentText:nil];
		[self validateWindowContent];
	}
	else
	{
//iTM2_LOG(@"INFO: TEXT %#x IS NOT THE CURRENT TEXT %#x", text, [self currentText]);
	}
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  _windowWillCloseOrDidResignKeyNotified:
- (void)_windowWillCloseOrDidResignKeyNotified:(NSNotification *)notification;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if([self isEditing])
        return;
//iTM2_START;
//iTM2_LOG(@"[SSC language] is:%@", [SSC language]);
	NSText * text = [self currentText];
    if([notification object] == [text window])
    {
		iTM2SpellContext * SC = [text spellContext];
		if(SC)
		{
			NS_DURING
			[SC setSpellLanguage:[SSC language]];
			[SC setIgnoredWords:[SSC ignoredWordsInSpellDocumentWithTag:[SC tag]]];
//iTM2_LOG(@"INFO: THE SPELL LANGUAGE AND IGNORED WORDS HAVE BEEN RECORDED FOR THE CURRENT TEXT %#x in window %@", text, [[text window] title]);
			NS_HANDLER
			iTM2_LOG(@"***  EXCEPTION CATCHED: %@, spell context not saved...", [localException reason]);
			NS_ENDHANDLER
		}
		else if(text)
		{
//iTM2_LOG(@"*** ERROR: MISSING SPELL CONTEXT FOR TEXT: %#x in window %@", text, [[text window] title]);
		}
        [self setCurrentText:nil];
		[self validateWindowContent];
	}
	else
	{
//iTM2_LOG(@"INFO: TEXT WINDOW %@ IS NOT THE CURRENT TEXT WINDOW %@", [notification object], [text window]);
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  _windowDidBecomeKeyNotified:
- (void)_windowDidBecomeKeyNotified:(NSNotification *)notification;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if([self isEditing])
        return;
    NSWindow * newW = [notification object];
    if([newW level] >= [[SSC spellingPanel] level])
	{
        newW = [NSApp mainWindow];
		if([newW level] >= [[SSC spellingPanel] level])
			return;
	}
//iTM2_START;
//iTM2_LOG(@"[SSC language] is:%@", [SSC language]);
	[SUD setObject:[SSC language] forKey:iTM2CurrentSpellLanguageKey];
    id newText = [newW firstResponder];
	while(newText && ![newText respondsToSelector:@selector(iTM2SpellKit_NSText_Catcher:)])
		newText = [newText nextResponder];
//iTM2_LOG(@"Updating the spell information, [SSC language] is:%@", [SSC language]);
    // updating the actual information to make the current mode and the language in synch
//iTM2_LOG(@"[self currentText] is:%@", [self currentText]);
	[self setCurrentText:newText];
	iTM2SpellContext * SC;
//iTM2_LOG(@"iVarCurrentTextRef is changed, [SSC language] is:%@", [SSC language]);
	if(SC = [newText spellContext])
	{
		NSString * language = [SC spellLanguage];
		if(![SSC setLanguage:language])
		{
			iTM2_LOG(@"THE %@ LANGUAGE IS UNKNOWN by cocoa spell checker, %@ is used instead", language, [SSC language]);
			[SC setSpellLanguage:[SSC language]];
		}
		else
		{
//iTM2_LOG(@"INFO: THE LANGUAGE IS NOW %@", language);
		}
		if(newW)// avoid recursivity
		{
			NSString * S = [[newText string] substringWithRange:[newText selectedRange]];
			if([S length])
			{
				[SSC updateSpellingPanelWithMisspelledWord:S];
				[SSC updateGuessesList];
			}
		}
	}
	else if(newText)
	{
//iTM2_LOG(@"*** ERROR: MISSING SPELL CONTEXT FOR TEXT: %#x in window %@", newText, [[newText window] title]);
[newText spellContext];
	}
	else
	{
//iTM2_LOG(@"INFO: NO TEXT CATCHED FOR SPELL CHECKING");
	}
//iTM2_LOG(@"[SSC language] is:%@", [SSC language]);
	if([[self window] isVisible])
		[self validateWindowContent];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  textDidBecomeFirstResponder:
- (void)textDidBecomeFirstResponder:(id)newText;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_LOG(@"[SSC language] is:%@", [SSC language]);
    if([self isEditing])
        return;
	NSString * language = [SSC language];
	[SUD setObject:language forKey:iTM2CurrentSpellLanguageKey];
    NSWindow * newW = [newText window];
    if([newW level] >= [[SSC spellingPanel] level])
        return;
//iTM2_LOG(@"Updating the spell information, [SSC language] is:%@", [SSC language]);
    // updating the actual information to make the current mode and the language in synch
//iTM2_LOG(@"[self currentText] is:%@", [self currentText]);
	iTM2SpellContext * SC = [[self currentText] spellContext];
    [SC setSpellLanguage:language];
    [SC setIgnoredWords:[SSC ignoredWordsInSpellDocumentWithTag:[SC tag]]];
    if(newText != [self currentText])
    {
		// save the actual settings for the old text:
        [self setCurrentText:newText];
//iTM2_LOG(@"iVarCurrentTextRef is changed, [SSC language] is:%@", [SSC language]);
		if(SC = [newText spellContext])
		{
			NSString * language = [SC spellLanguage];
			if(![SSC setLanguage:language])
			{
				iTM2_LOG(@"INFO: THE %@ LANGUAGE IS UNKNOWN by cocoa spell checker, %@ is used instead", language, [SSC language]);
				[SC setSpellLanguage:[SSC language]];
			}
			if(newW)// avoid recursivity
			{
				NSString * S = [[newText string] substringWithRange:[newText selectedRange]];
				if([S length])
				{
					[SSC updateSpellingPanelWithMisspelledWord:S];
					[SSC updateGuessesList];
				}
			}
		}
	}
//iTM2_LOG(@"[SSC language] is:%@", [SSC language]);
    [self validateWindowContent];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  currentText
- (id)currentText;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	return [metaGETTER nonretainedObjectValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  setCurrentText:
- (void)setCurrentText:(id)argument;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	metaSETTER([NSValue valueWithNonretainedObject:argument]);
	if(!argument && iTM2DebugEnabled)
	{
		NSLog(@"NO TEXT FOR SPELL CHECKING");
		//iTM2_START_TRACKING;
	}
//iTM2_LOG(@"INFO: THE CURRENT TEXT FOR THE SPELL KIT IS NOW %#x in window %@", [self currentText], [[[self currentText] window] title]);
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  isEditing
- (BOOL)isEditing;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	return [metaGETTER boolValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  setEditing:
- (void)setEditing:(BOOL)yorn;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	metaSETTER([NSNumber numberWithBool:yorn]);
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  delayedSetCurrentSpellLanguage:
- (void)delayedSetCurrentSpellLanguage:(NSString *)language;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self setCurrentSpellLanguage:[language autorelease]];// was retained above
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  setCurrentSpellLanguage:
- (void)setCurrentSpellLanguage:(NSString *)language;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[SUD setObject:language forKey:iTM2CurrentSpellLanguageKey];
    NSWindow * newW = [NSApp keyWindow];
    if([newW level] >= [[SSC spellingPanel] level])
	{
        newW = [NSApp mainWindow];
		if([newW level] >= [[SSC spellingPanel] level])
			return;
	}
    id newText = [newW firstResponder];
	while(newText && ![newText respondsToSelector:@selector(iTM2SpellKit_NSText_Catcher:)])
		newText = [newText nextResponder];
//iTM2_LOG(@"Updating the spell information, [SSC language] is:%@", [SSC language]);
    // updating the actual information to make the current mode and the language in synch
//iTM2_LOG(@"[self currentText] is:%@", [self currentText]);
	iTM2SpellContext * SC = [[self currentText] spellContext];
    [SC setSpellLanguage:language];
    [SC setIgnoredWords:[SSC ignoredWordsInSpellDocumentWithTag:[SC tag]]];
    if(newText != [self currentText])
    {
		// save the actual settings for the old text:
        [self setCurrentText:newText];
//iTM2_LOG(@"iVarCurrentTextRef is changed, [SSC language] is:%@", [SSC language]);
		if(SC = [newText spellContext])
		{
			NSString * language = [SC spellLanguage];
			if(![SSC setLanguage:language])
			{
				iTM2_LOG(@"THE %@ LANGUAGE IS UNKNOWN by cocoa spell checker, %@ is used instead", language, [SSC language]);
				[SC setSpellLanguage:[SSC language]];
			}
			if(newW)// avoid recursivity
			{
				NSString * S = [[newText string] substringWithRange:[newText selectedRange]];
				if([S length])
				{
					[SSC updateSpellingPanelWithMisspelledWord:S];
					[SSC updateGuessesList];
				}
			}
		}
	}
//iTM2_LOG(@"[SSC language] is:%@", [SSC language]);
    [self validateWindowContent];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  _1stResponderMightHaveChanged:
- (void)_1stResponderMightHaveChanged:(id)irrelevant;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_LOG(@"[SSC language] is:%@", [SSC language]);
	[self setCurrentSpellLanguage:[SSC language]];// this needs SSC inited unless infinite loop
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  synchronizeWithCurrentText
- (void)synchronizeWithCurrentText;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	// reentrant part
	if([[IMPLEMENTATION metaValueForKey:@"Synchronizing"] boolValue])
		return;
	[IMPLEMENTATION takeMetaValue:[NSNumber numberWithBool:YES] forKey:@"Synchronizing"];
    id text = [self currentText];
	// this is the crucial part that needs reentrant management
	iTM2SpellContext * SC = [text spellContext];
	NSString * language = [SC spellLanguage];
	if(![SSC setLanguage:language])
	{
		iTM2_LOG(@"THE %@ LANGUAGE IS UNKNOWN by cocoa spell checker, %@ is used instead", language, [SSC language]);
		[SC setSpellLanguage:[SSC language]];
	}
	if([text window])// avoid recursivity
	{
		NSString * S = [[text string] substringWithRange:[text selectedRange]];
		if([S length])
		{
			[SSC updateSpellingPanelWithMisspelledWord:S];
			[SSC updateGuessesList];
		}
	}
//iTM2_LOG(@"[SSC language] is:%@", [SSC language]);
	[IMPLEMENTATION takeMetaValue:[NSNumber numberWithBool:NO] forKey:@"Synchronizing"];
    [self validateWindowContent];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  spellCheckerAccessoryView
- (NSView *)spellCheckerAccessoryView;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return metaGETTER;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  setSpellCheckerAccessoryView
- (void)setSpellCheckerAccessoryView:(NSView *)view;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(view != metaGETTER)
	{
		metaSETTER(view);
	}
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  validateWindowContent
- (BOOL)validateWindowContent;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return [super validateWindowContent] && [[self spellCheckerAccessoryView] validateWindowContent];
}
#pragma mark =-=-=-=-=-  GUI Validation
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  projectNameEdited:
- (IBAction)projectNameEdited:(id)sender;
/*"Catcher.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  validateProjectNameEdited:
- (BOOL)validateProjectNameEdited:(id)sender;
/*"Catcher.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSString * name = [[self currentText] spellPrettyProjectName];
    [sender setStringValue:([name length]? name:
        NSLocalizedStringFromTableInBundle(@"None", iTM2SpellKitTable,
            [self classBundle], "No project/text/mode name for the spell check document"))];
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  textNameEdited:
- (IBAction)textNameEdited:(id)sender;
/*"Catcher.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  validateTextNameEdited:
- (BOOL)validateTextNameEdited:(id)sender;
/*"Catcher.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSString * FN = [[self currentText] spellPrettyName];
//NSLog(@"FN: %@", FN);
    if([FN length])
        [sender setStringValue:FN];
    else
    {
        NSAttributedString * AS = [sender attributedStringValue];
        if([AS length])
        {
            NSMutableDictionary * attributes = [[[AS attributesAtIndex:0 effectiveRange:nil] mutableCopy] autorelease];
            NSFont * F = [attributes objectForKey:NSFontAttributeName];
            if(!F)
                F = [NSFont userFontOfSize:[NSFont systemFontSize]];
            [attributes setObject:[[NSFontManager sharedFontManager] convertFont:F toHaveTrait:NSItalicFontMask] forKey:NSFontAttributeName];
            [attributes setObject:[NSColor grayColor] forKey:NSForegroundColorAttributeName];
            [sender setAttributedStringValue:[[[NSAttributedString allocWithZone:[self zone]]
                            initWithString: [[[self currentText] window] title] attributes:attributes] autorelease]];
        }
        else
            [sender setStringValue:NSLocalizedStringFromTableInBundle(@"None", iTM2SpellKitTable,
                [self classBundle], "No project/text/mode name for the spell check document")];
    }
    return YES;
}
#pragma mark =-=-=-=-=-  GUI messages
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  selectMode:
- (IBAction)selectMode:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSString * oldMode = [[self currentText] spellContextMode];
//NSLog(@"new mode: %@", newMode);
//NSLog(@"old mode: %@", oldMode);
    if(![TWSSpellDefaultContextMode isEqualToString:oldMode])
    {
        // synchronisation is critical here because we make an intensive use of side effects.
        // we must also force the cocoa spell checker to change the spell document tag.
        // this is the reason why we change the first responder.
        [[[self currentText] spellContext] setSpellLanguage:[SSC language]];
        [[self currentText] setSpellContextMode:TWSSpellDefaultContextMode];
        NSWindow * W = [[self currentText] window];
        id FR = [W firstResponder];
        [W makeFirstResponder:[W contentView]];
        [W makeFirstResponder:FR];
        [self validateWindowContent];
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  validateSelectMode:
- (BOOL)validateSelectMode:(id)sender;
/*"Message catcher.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if([sender isKindOfClass:[NSPopUpButton class]])
    {
        iTM2SpellContextController * currentController = [[self currentText] spellContextController];
        // updating the popup:
        [sender removeAllItems];
        NSString * title = NSLocalizedStringFromTableInBundle(TWSSpellDefaultContextMode, iTM2SpellKitTable,
                    [self classBundle], "DF");
        [sender addItemWithTitle:title];
        #if 0
        if(currentController == [iTM2SpellContextController defaultSpellContextController]) 
        {
            [sender selectItemAtIndex:0];
            [sender setEnabled:NO];
            return;
        }
        #endif
        [sender setEnabled:YES];
        NSMenu * M = [sender menu];
        [M addItem:[NSMenuItem separatorItem]];
        NSMenuItem * MI;
        NSMenu * SM = [[[NSMenu allocWithZone:[NSMenu menuZone]] initWithTitle:@""] autorelease];
        NSEnumerator * E = [[[[currentController spellContextModesEnumerator] allObjects]
                                        sortedArrayUsingSelector: @selector(compare:)] objectEnumerator];
        NSString * contextMode;
        while(contextMode = [E nextObject])
        {
            if(![contextMode isEqualToString:TWSSpellDefaultContextMode])
            {
        //NSLog(@"title: %@", title);
                MI = (NSMenuItem *)[M addItemWithTitle:contextMode action:@selector(takeSpellingModeFromRepresentedObject:) keyEquivalent:@""];
                [MI setRepresentedObject:contextMode];
                [MI setTarget:self];
                MI = (NSMenuItem *)[SM addItemWithTitle:contextMode action:@selector(removeSpellingModeFromRepresentedObject:) keyEquivalent:@""];
                [MI setRepresentedObject:contextMode];
                [MI setTarget:self];
            }
        }
        NSString * currentMode = [currentController spellContextModeForText:[self currentText]];
        [sender selectItemAtIndex:[M indexOfItemWithRepresentedObject:currentMode]];
        [sender synchronizeTitleAndSelectedItem];
        // filling the spelling modes management items
//        if(currentController != [iTM2SpellContextController defaultSpellContextController])
        {
    //NSLog(@"Not the default spelling model");
            if([SM numberOfItems])
            {
                [M addItem:[NSMenuItem separatorItem]];
                MI = (NSMenuItem *)[M addItemWithTitle:NSLocalizedStringFromTableInBundle(@"Remove mode", iTM2SpellKitTable,
                                [self classBundle], "DF")
                            action: NULL keyEquivalent: @""];
                [MI setSubmenu:SM];
            }
            MI = (NSMenuItem *)[M addItemWithTitle:NSLocalizedStringFromTableInBundle(@"New mode...", iTM2SpellKitTable,
                                            [self classBundle], "DF")
                    action: @selector(newMode:) keyEquivalent: @""];
            [MI setTarget:self];
        }
    }
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  newMode:
- (void)newMode:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//NSLog(@"newMode 1 %@", currentController);
    [self setEditing:YES];
//NSLog(@"YESSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS");
    [NSApp beginSheet:[self window]
        modalForWindow: [SSC spellingPanel]
        modalDelegate: nil
        didEndSelector: NULL
        contextInfo: nil];
//NSLog(@"newMode 2 %@", currentController);
    [NSApp runModalForWindow:[self window]];
    // Sheet is up here.
    [NSApp endSheet:[self window]];
    [[self window] orderOut:self];
    [self validateWindowContent];
    [self setEditing:NO];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  takeSpellingModeFromRepresentedObject:
- (void)takeSpellingModeFromRepresentedObject:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSString * oldMode = [[self currentText] spellContextMode];
    NSString * newMode = [sender representedObject];
//NSLog(@"new mode: %@", newMode);
//NSLog(@"old mode: %@", oldMode);
    if(![newMode isEqualToString:oldMode])
    {
        // synchronisation is critical here because we make an intensive use of side effects.
        // we must also force the cocoa spell checker to change the spell document tag.
        // this is the reason why we change the first responder.
#if 1
        [[[self currentText] spellContext] setSpellLanguage:[SSC language]];
        [[self currentText] setSpellContextMode:newMode];
        NSWindow * W = [[self currentText] window];
        id FR = [W firstResponder];
        [W makeFirstResponder:[W contentView]];
        [W makeFirstResponder:FR];
        [self validateWindowContent];
#else
        NSString * oldLanguage = [SSC language];
        NSWindow * W = [[self currentText] window];
        id FR = [W firstResponder];
        [W makeFirstResponder:[W contentView]];
        [currentController setSpellContextMode:newMode forText:[self currentText]];
        [W makeFirstResponder:FR];
        if([oldLanguage length])
            [[currentController spellContextForMode:oldMode] setSpellLanguage:oldLanguage];
        [self validateWindowContent];
#endif
    }
    return;
}
#if 0
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  validateMenuItem:
- (BOOL)validateMenuItem:(id <NSMenuItem>)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    SEL action = [sender action];
    if(action == @selector(takeSpellingModeFromRepresentedObject:))
    {
        // This message means a change in the spell context.
        // 
        return [[sender representedObject] isEqualToString:TWSSpellDefaultContextMode];
    }
    else
        return YES;
}
#endif
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  removeSpellingModeFromRepresentedObject:
- (void)removeSpellingModeFromRepresentedObject:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [[[self currentText] spellContextController] removeSpellMode:[sender representedObject]];
    [self setEditing:NO];
    [self validateWindowContent];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  editIgnoredWords:
- (void)editIgnoredWords:(id)sender;
/*"Description forthcoming. Passive delegate.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(![self currentText])
    {
        NSLog(@"No text available for spelling, comme c'est bizarre!");
        return;
    }
//iTM2_LOG(@"THE IGNORED WORDS ARE: %@", [[[self currentText] spellContext] ignoredWords]);
    [self setEditing:YES];
//NSLog(@"YESSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS");
    _iTM2IgnoredWordsEditor * IWE = [_iTM2IgnoredWordsEditor sharedEditor];
    [IWE setCurrentText:[self currentText]];
    NSWindow * W = [IWE window];// this loads the window as side effect
    [NSApp beginSheet:W
            modalForWindow: [sender window]
            modalDelegate: nil
            didEndSelector: nil
            contextInfo: nil];
    [NSApp runModalForWindow:W];
    [NSApp endSheet:W];
    [W orderOut:self];
	// I tried to create a new window controller each time it is called but it caused an error 10/11 crash
    [self setEditing:NO];
//iTM2_LOG(@"THE IGNORED WORDS ARE NOW: %@", [[[self currentText] spellContext] ignoredWords]);
//iTM2_END;
    return;
}
#pragma mark =-=-=-=-=-  New mode GUI
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  newModeEdited:
- (void)newModeEdited:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    iTM2SpellContextController * currentController = [[self currentText] spellContextController];
    NSString * newMode = [sender stringValue];
    if([[[currentController spellContextModesEnumerator] allObjects] containsObject:newMode])
    {
        [sender setStringValue:@""];
        return;
    }
    [NSApp stopModal];
    [currentController addSpellMode:newMode];
    [currentController setSpellContextMode:newMode forText:[self currentText]];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  newModeCancelled:
- (void)newModeCancelled:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [NSApp stopModal];
    return;
}
@end

@interface NSObject(iTM2SpellKit_PRIVATE_2)
- (void)removeSelectedRowsInTableView:(NSTableView *)tableView;
@end
@interface iTM2IgnoredWordsTableView: NSTableView
@end
@implementation iTM2IgnoredWordsTableView
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  keyDown:
- (void)keyDown:(NSEvent *)theEvent;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if([[theEvent charactersIgnoringModifiers] characterAtIndex:0] == 0x7F)
    {
        id DS = [self dataSource];
        if([DS respondsToSelector:@selector(removeSelectedRowsInTableView:)])
            [DS removeSelectedRowsInTableView:self];
    }
    else
        [super keyDown:theEvent];
    return;
}
#if 1
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  drawRow:clipRect:
- (void)drawRow:(int)row clipRect:(NSRect)theRect;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [super drawRow:row clipRect:theRect];
    return;
}
#endif
@end

#import <iTM2Foundation/iTM2ProjectDocumentKit.h>

#import <objc/objc-class.h>

@implementation NSSpellChecker(iTeXMac2)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  delayedUpdateGuessesList
- (void)delayedUpdateGuessesList;
/*"Crash if we do not use a delayed design.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSButton * b = [self guessButton];
    [NSApp sendAction:[b action] to:[b target] from:self];
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  updateGuessesList
- (void)updateGuessesList;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([SUD boolForKey:@"iTM2AutoUpdateGuessesList"])
	{
		[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(delayedUpdateGuessesList) object:nil];
		[self performSelector:@selector(delayedUpdateGuessesList) withObject:nil afterDelay:0];
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  guessButton
- (NSButton *)guessButton;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    void * button;
    object_getInstanceVariable(self, "_guessButton", &button);
	if(!button)
	{
		iTM2_LOG(@"*** ERROR: extended spell checking won't work: please upgrade");
	}
    return (NSButton *)button;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  currentText
- (id)currentText;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	return [SCH currentText];
}
@end

@implementation NSSpellChecker_iTeXMac2
#if 0
#warning DEBUG
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  setLanguage:
- (BOOL)setLanguage:(NSString *)language;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_LOG(@"THE SPELL CHECKER IS CHANGING THE LANGUAGE TO: %@", language);
	if([super setLanguage:language])
	{
		[SCH performSelector:@selector(delayedSetCurrentSpellLanguage:) withObject:[language retain] afterDelay:0];// language will be released below
		return YES;
	}
	else
		return NO;
}
#endif
#if 0
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  checkSpellingOfString:startingAt:language:wrap:inSpellDocumentWithTag:wordCount:
- (NSRange)checkSpellingOfString:(NSString *)stringToCheck startingAt:(int)startingOffset language:(NSString *)language wrap:(BOOL)wrapFlag inSpellDocumentWithTag:(int)tag wordCount:(int *)wordCount;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//NSLog(@"1- stringToCheck= %@, startingOffset: %i, language: %@, wrapFlag: %@", stringToCheck, startingOffset, language, (wrapFlag?@"YYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY":@"NNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNNN"));
    NSRange R = [super checkSpellingOfString:stringToCheck
                    startingAt: startingOffset
                        language: language
                            wrap: wrapFlag
                                inSpellDocumentWithTag: tag
                                    wordCount: wordCount];
//NSLog(@"[stringToCheck substringWithRange:%@]:%@", NSStringFromRange(R), (R.length>0? [stringToCheck substringWithRange:R]:@"<rien/>"));
    return R;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  checkSpellingOfString:startingAt:
- (NSRange)checkSpellingOfString:(NSString *)stringToCheck startingAt:(int)startingOffset;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
1.0.3 improved for check spelling as you type.
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//NSLog(@"2- stringToCheck= %@", stringToCheck);
    NSRange R = [super checkSpellingOfString:stringToCheck startingAt:startingOffset];
//NSLog(@"[stringToCheck substringWithRange:%@]:%@", NSStringFromRange(R), (R.length>0? [stringToCheck substringWithRange:R]:@"<rien/>"));
    return R;
}
#endif
@end

@interface NSText(iTM2SpellKit_PRIVATE)
- (int)spellCheckerDocumentTag;
@end

@interface NSObject(iTM2SpellKit_PRIVATE)
- (void)textDidBecomeFirstResponder:(id)sender;
@end

@implementation NSText_iTM2SpellKit: NSText
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  dealloc
- (void)dealloc;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(self == [SCH currentText])
		[SCH setCurrentText:nil];
    [super dealloc];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  becomeFirstResponder
- (BOOL)becomeFirstResponder;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if([super becomeFirstResponder])
    {
        [SCH textDidBecomeFirstResponder:self];
        return YES;
    }
    else
        return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  spellContextController
- (id)spellContextController;
/*"Asks a delegate for a non empty #{spellContextController}.
The delegate is the first one that gives a sensitive answer among the receiver's delegate, its window's delegate, the document of its window's controller, the owner of its window's controller. In that specific order.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [[self window] spellContextController];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  iTM2SpellKit_NSText_Catcher
- (void)iTM2SpellKit_NSText_Catcher:(id)irrelevant;
/*"Asks a delegate for a non empty #{spellContextController}.
The delegate is the first one that gives a sensitive answer among the receiver's delegate, its window's delegate, the document of its window's controller, the owner of its window's controller. In that specific order.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  spellContextMode
- (NSString *)spellContextMode;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return [[self spellContextController] spellContextModeForText:self];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  spellPrettyName
- (NSString *)spellPrettyName;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return [[self spellContextController] spellPrettyNameForText:self];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  spellPrettyProjectName
- (NSString *)spellPrettyProjectName;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [[self spellContextController] spellPrettyProjectNameForText:self];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  spellContext
- (iTM2SpellContext *)spellContext;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return [[self spellContextController] spellContextForMode:[self spellContextMode]];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  setSpellContextMode:
- (void)setSpellContextMode:(NSString *)mode;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [[self spellContextController] setSpellContextMode:mode forText:self];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  spellCheckerDocumentTag
- (int)spellCheckerDocumentTag;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [[self spellContext] tag];
}
@end

#if 1
@interface NSTextView__iTM2SpellKit_PRIVATE: NSTextView
@end
@implementation NSTextView__iTM2SpellKit_PRIVATE
+ (void)load;
{iTM2_DIAGNOSTIC;
	iTM2_INIT_POOL;
	[NSBundle redirectNSLogOutput];
	[self poseAsClass:[NSTextView class]];
	iTM2_RELEASE_POOL;
}
- (void)showGuessPanel:(id)sender;
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[super showGuessPanel:(id)sender];
}
- (void)checkSpelling:(id)sender;
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[super checkSpelling:(id)sender];
}
@end
#endif
#endif
#if __iTM2_DEVELOPMENT__
#warning *** DEVELOPMENT: autorelease catcher
#pragma mark DEVELOPMENT
@interface NSObject_iTM2SpellKit: NSObject
@end
@implementation NSObject_iTM2SpellKit
+ (void)load;
{iTM2_DIAGNOSTIC;
	iTM2_INIT_POOL;
	[NSBundle redirectNSLogOutput];
	[self poseAsClass:[NSObject class]];
	iTM2_RELEASE_POOL;
	return;
}
- (id)autorelease;
{iTM2_DIAGNOSTIC;
	return [super autorelease];
}
@end
#endif
