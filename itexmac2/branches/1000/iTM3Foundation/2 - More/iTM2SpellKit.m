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
#define __iTM2_BUG_TRACKING__ ZER0
#ifdef __iTM2_BUG_TRACKING__
	#warning DEBUGGGGGGGGGGGGGGGG
#endif
#ifdef __iTM2_NO_XTD_SPELL__
#warning *** NO XTD SPELL
#else
#endif
#if 1
#import "iTM2SpellKit.h"
#import "iTM2BundleKit.h"
#import "iTM2ContextKit.h"
#import "iTM2InstallationKit.h"
#import "iTM2InfoWrapperKit.h"

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

#define TABLE @"Basic"

#define SSC [NSSpellChecker sharedSpellChecker]

@implementation iTM3SpellContext
@synthesize ignoredWords=iVarIgnoredWords;
@synthesize spellLanguage=iVarLanguage;
@synthesize tag=iVarTag;
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  initialize
+ (void)initialize;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
	INIT_POOL4iTM3;
//START4iTM3;
    [super initialize];
	[SUD registerDefaults:[NSDictionary dictionaryWithObject:@"en" forKey:iTM2CurrentSpellLanguageKey]];
//END4iTM3;
	RELEASE_POOL4iTM3;
   return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  init
- (id)init;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if ((self = [super init])) {
        self.spellLanguage = [SUD objectForKey:iTM2CurrentSpellLanguageKey];
        self.ignoredWords = [NSArray array];
        self.tag = [NSSpellChecker uniqueSpellDocumentTag];// last
    }
    return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  loadPropertyListRepresentation:
- (BOOL)loadPropertyListRepresentation:(id)PL;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed 05 mar 03
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    BOOL result = NO;
    NS_DURING
    if ([[PL valueForKey:TWSSpellIsaKey] isEqual:TWSSpellIsaValue]) {
        id O;
        if ((O = [PL valueForKey:TWSSpellLanguageKey]))
            self.spellLanguage = O;
        if ((O = [PL valueForKey:TWSSpellIgnoredWordsKey]))
            [self replaceIgnoredWords:O];
        result = YES;
    } else if (PL) {
		LOG4iTM3(@"BAD or missing value for %@ key: %@ was expected", TWSSpellIsaKey, TWSSpellIsaValue);
	}
    NS_HANDLER
	LOG4iTM3(@"***  EXCEPTION CATCHED: BAD property list, %@", [localException reason]);
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSInteger tag = self.tag;
	NSArray * RA = [SSC ignoredWordsInSpellDocumentWithTag:tag];
	self.ignoredWords = RA;
	if ([[SSC.currentText spellContext4iTM3] isEqual:self])
		self.spellLanguage = [SSC language];
//LOG4iTM3(@"CURRENT LANGUAGE IS: %@, current spell context is: %#x", [SSC language], [[SSC currentText] spellContext4iTM3]);
    return [NSDictionary dictionaryWithObjectsAndKeys:
                TWSSpellIsaValue, TWSSpellIsaKey,
                self.spellLanguage, TWSSpellLanguageKey,
                self.ignoredWords, TWSSpellIgnoredWordsKey,
                    nil];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  finalize
- (void)finalize;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
    [SSC closeSpellDocumentWithTag:iVarTag];
    [super finalize];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  replaceIgnoredWords:
- (void)replaceIgnoredWords:(NSArray *)argument;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    self.ignoredWords = argument;
	[SSC setIgnoredWords:self.ignoredWords inSpellDocumentWithTag:self.tag];
//END4iTM3;
    return;
}
@end

@implementation NSWindow(iTM2SpellKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  spellContext4iTM3ControllerError:
- (id)spellContext4iTM3ControllerError:(NSError **)RORef;
/*"Asks a delegate for a non empty #{spellContext4iTM3ControllerError:}.
The delegate is the first one that gives a sensitive answer among the receiver's delegate, its window's delegate, the document of its window's controller, the owner of its window's controller. In that specific order.
Version history: jlaurens AT users DOT sourceforge DOT net
Révisé par itexmac2: 2010-12-27 17:09:47 +0100
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [self.windowController spellContext4iTM3ControllerError:RORef];
}
@end

@implementation NSWindowController(iTM2SpellKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  spellContext4iTM3ControllerError:
- (id)spellContext4iTM3ControllerError:(NSError **)RORef;
/*"Asks the document or the owner.
Version history: jlaurens AT users DOT sourceforge DOT net
Révisé par itexmac2: 2010-12-27 17:10:42 +0100
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    id D = self.document;
    if (D)
        return [D spellContext4iTM3ControllerError:RORef];
    if ((D = self.owner) && (D!=self))
        return [D spellContext4iTM3ControllerError:RORef];
    return [super spellContext4iTM3ControllerError:RORef];
}
@end

@implementation NSObject(iTM2SpellKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  spellContext4iTM3ControllerError:
- (id)spellContext4iTM3ControllerError:(NSError **)RORef;
/*"Asks the document or the owner.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [iTM2SpellContextController defaultSpellContextController];
}
@end


@interface NSSpellChecker(iTeXMac2)
- (void)updateGuessesList;
- (NSButton *)guessButton;
@end

@interface NSObject(iTM2SpellKit_PRIVATE)
- (void)textDidBecomeFirstResponder:(id)sender;
@end


#import "iTM2ContextKit.h"

@implementation NSTextView(iTM2Spell)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  spellCheckerDocumentTag
- (NSInteger)spellCheckerDocumentTag;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return self.spellContext4iTM3.tag;
}
#if 0
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  setSelectedRange:affinity:stillSelecting:
- (void)setSelectedRange:(NSRange)charRange affinity:(NSSelectionAffinity)affinity stillSelecting:(BOOL)stillSelectingFlag;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [super setSelectedRange:charRange affinity:affinity stillSelecting:stillSelectingFlag];
    if (!stillSelectingFlag && self.window && ([self.window level] < [[SSC spellingPanel] level]))// avoid recursion when no window
    {
        NSString * S = self.string;
        NSRange R = iTM3MakeRange(ZER0,S.length);
        R = iTM3ProjectionRange(R,self.selectedRange);// do not assume that the selected range lays between the text limits
        if (R.length)
        {
            S = [S substringWithRange:R];
            [SSC updateSpellingPanelWithMisspelledWord:S];
            [SSC updateGuessesList];
        }
    }
//END4iTM3;
    return;
}
#endif
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  SWZ_iTM2Spell_setContinuousSpellCheckingEnabled:
- (void)SWZ_iTM2Spell_setContinuousSpellCheckingEnabled:(BOOL)flag;
/*"Default implementation does nothing.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    BOOL old = self.isContinuousSpellCheckingEnabled;
    if (old != flag)
	{
        [self SWZ_iTM2Spell_setContinuousSpellCheckingEnabled:flag];
		[self takeContext4iTM3Bool:self.isContinuousSpellCheckingEnabled forKey:iTM2UDContinuousSpellCheckingKey domain:iTM2ContextAllDomainsMask];
	}
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  SWZ_iTM2Spell_toggleContinuousSpellChecking:
- (IBAction)SWZ_iTM2Spell_toggleContinuousSpellChecking:(id)sender;
/*"Default implementation does nothing.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self SWZ_iTM2Spell_toggleContinuousSpellChecking:sender];
	BOOL yorn = self.isContinuousSpellCheckingEnabled;
	[self takeContext4iTM3Bool:yorn forKey:iTM2UDContinuousSpellCheckingKey domain:iTM2ContextAllDomainsMask];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  context4iTM3DidChange
- (void)context4iTM3DidChange;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 04/04/2002
To Do List: ...
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	BOOL yorn = [self context4iTM3BoolForKey:iTM2UDContinuousSpellCheckingKey domain:iTM2ContextAllDomainsMask];
    [self setContinuousSpellCheckingEnabled:yorn];
	[super context4iTM3DidChange];
	[self context4iTM3DidChangeComplete];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  SWZ_iTM2Spell_becomeFirstResponder
- (BOOL)SWZ_iTM2Spell_becomeFirstResponder;
/*"It is necessary to swizzle both NSText and NSTextView's becomeFirstResponder because the latter is not expected to use the former.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Jan 29 13:21:16 UTC 2008
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if ([self SWZ_iTM2Spell_becomeFirstResponder]) {
        [SCH textDidBecomeFirstResponder:self];
        return YES;
    } else {
        return NO;
    }
}
@end

@interface iTM2SpellContextController(iTM2SpellKit)
+ (void)_writeToUserDefaults;
+ (void)completeInitialization;
@end

@interface iTM2SpellCheckerHelper(PRIVATE0)
- (void)_1stResponderMightHaveChanged:(id)irrelevant;
@end

@implementation iTM2MainInstaller(SpellContextController)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  spellContextControllerCompleteInstallation4iTM3
+ (void)spellContextControllerCompleteInstallation4iTM3;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[iTM2SpellContextController completeInitialization];
//END4iTM3;
	return;
}
@end
@interface iTM2SpellContextController()
@property (readwrite) NSInteger changeCount;
@end
@implementation iTM2SpellContextController
@synthesize changeCount = iVarChangeCount;
static iTM2SpellContextController * _iTM2SpellContextController = nil;
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  completeInitialization
+ (void)completeInitialization;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (!_iTM2SpellContextController) {
        [super initialize];
        iTM3SpellContext * SC = [iTM3SpellContext new];
		NSDictionary * D;
#if 1
		D = [SC propertyListRepresentation];
		D = [NSDictionary dictionaryWithObject:D forKey:TWSSpellDefaultContextMode];
		D = [NSDictionary dictionaryWithObjectsAndKeys:
							   D, iTM2SpellContextsKey,
							   [NSDictionary dictionary], iTM2SpellContextModesKey,
				 nil];
        [SUD registerDefaults:D];
#else
        [SUD registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:
            [NSDictionary dictionaryWithObject:[SC propertyListRepresentation] forKey:TWSSpellDefaultContextMode], iTM2SpellContextsKey,
            [NSDictionary dictionary], iTM2SpellContextModesKey,
                    nil]];
#endif
        _iTM2SpellContextController = self.new;
        D = [SUD dictionaryForKey:iTM2SpellContextsKey];
        for(NSString * mode in D.keyEnumerator)
        {
            iTM3SpellContext * SC = [iTM3SpellContext new];
            if (SC)
            {
                [SC loadPropertyListRepresentation:[D objectForKey:mode]];
                [_iTM2SpellContextController setSpellContext4iTM3:SC forMode:mode];
            }
        }
//LOG4iTM3(@"THE DEFAULT SPELL CONTEXTS HAVE BEEN CREATED");
        [DNC addObserver:self
            selector: @selector(_applicationWillTerminateNotified:)
                name: NSApplicationWillTerminateNotification
                    object: NSApp];
    }
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  _applicationWillTerminateNotified:
+ (void)_applicationWillTerminateNotified:(NSNotification *)notification;
/*"Designated intializer.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [DNC removeObserver:self name:notification.name object:nil];
    self._writeToUserDefaults;
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  _writeToUserDefaults
+ (void)_writeToUserDefaults;
/*"Designated intializer.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [SCH _1stResponderMightHaveChanged:nil];
    iTM2SpellContextController * controller = self.defaultSpellContextController;
    NSArray * newModes = [[controller spellContextModesEnumerator] allObjects];
    NSMutableDictionary * MD = [[SUD dictionaryForKey:iTM2SpellContextsKey] mutableCopy];
    NSEnumerator * E = MD.keyEnumerator;
    NSString * mode;
    while((mode = E.nextObject))
        if (![newModes containsObject:mode])
            [MD removeObjectForKey:mode];
    for(mode in newModes)
        [MD setObject:[[controller spellContextForMode:mode] propertyListRepresentation] forKey:mode];
    [SUD setObject:MD forKey:iTM2SpellContextsKey];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  defaultSpellContextController
+ (id)defaultSpellContextController;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return _iTM2SpellContextController;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  init
- (id)init;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if ((self = [super init]))
    {
        [self setSpellContexts:[NSDictionary dictionary]];
        iTM3SpellContext * SC = [[iTM3SpellContext alloc] init];
        [SC loadPropertyListRepresentation:[[SUD objectForKey:iTM2SpellContextsKey] objectForKey:TWSSpellDefaultContextMode]];
        [self setSpellContext4iTM3:SC forMode:TWSSpellDefaultContextMode];
//LOG4iTM3(@"self.spellContexts are:\n%@", self.spellContexts);
//LOG4iTM3(@"MAIN SPELL CONTEXT CREATED...");
    }
//END4iTM3;
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (![mode isKindOfClass:[NSString class]])
        return NO;
    else if (mode.length && ![self spellContextForMode:mode])
    {
        [self setSpellContext4iTM3:[[iTM3SpellContext alloc] init] forMode:mode];
//NSLog(@"NEW MODE CREATED: %@\n%@", mode, MD);
        [self updateChangeCount:NSChangeDone];
//END4iTM3;
        return YES;
    }
//END4iTM3;
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  removeSpellMode:
- (BOOL)removeSpellMode:(NSString *)mode;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if ([self spellContextForMode:mode]) {
        [self setSpellContext4iTM3:nil forMode:mode];
        [self updateChangeCount:NSChangeDone];
//END4iTM3;
        return YES;
    }
//END4iTM3;
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  spellContextModesEnumerator
- (NSEnumerator *)spellContextModesEnumerator;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [[self.spellContexts allKeys] objectEnumerator];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  spellContextModeForText:
- (NSString *)spellContextModeForText:(NSText *)text;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    NSString * mode = [text context4iTM3ValueForKey:iTM2SpellContextModeKey domain:iTM2ContextAllDomainsMask ROR4iTM3];
    if (![self spellContextForMode:mode])
    {
        mode = TWSSpellDefaultContextMode;
        [text takeContext4iTM3Value:mode forKey:iTM2SpellContextModeKey domain:iTM2ContextAllDomainsMask ROR4iTM3];
    }
//END4iTM3;
    return mode;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  setSpellContextMode:forText:
- (void)setSpellContextMode:(NSString *)mode forText:(id)text;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [text takeContext4iTM3Value:mode forKey:iTM2SpellContextModeKey domain:iTM2ContextAllDomainsMask ROR4iTM3];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  spellPrettyNameForText:
- (NSString *)spellPrettyNameForText:(NSText *)text;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSDocument * D = [[text.window windowController] document];
    return D? D.displayName:text.window.title;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  spellContextForMode:
- (id)spellContextForMode:(NSString *)mode;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    id result = [self.spellContexts objectForKey:mode];
    if (!result)
    {
		if ([mode isEqualToString:TWSSpellDefaultContextMode])
		{
			iTM3SpellContext * SC = [[iTM3SpellContext alloc] init];
			[SC loadPropertyListRepresentation:[[SUD objectForKey:iTM2SpellContextsKey] objectForKey:TWSSpellDefaultContextMode]];
			[self setSpellContext4iTM3:SC forMode:TWSSpellDefaultContextMode];
			result = SC;
		} else {
			DEBUGLOG4iTM3(0,@"SORRY, self.spellContexts are:\n%@", self.spellContexts);
		}
    }
//END4iTM3;
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  setSpellContext4iTM3:forMode:
- (void)setSpellContext4iTM3:(id)newContext forMode:(NSString *)mode;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (newContext)
        [self.spellContexts setObject:newContext forKey:mode];
    else
        [self.spellContexts removeObjectForKey:mode];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  spellContexts
- (id)spellContexts;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return metaGETTER;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  setSpellContexts:
- (void)setSpellContexts:(id)newContexts;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSParameterAssert(!newContexts || [newContexts isKindOfClass:[NSDictionary class]]);
    metaSETTER([newContexts mutableCopy]);// a dictionary is expected
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  readFromURL:error:
- (BOOL)readFromURL:(NSURL *)fileURL error:(NSError**)RORef;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed 05 mar 03
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSData * D = [NSData dataWithContentsOfURL:fileURL options:ZER0 error:RORef];
    if (D.length) {
        NSString * errorString = nil;
        id DM = [NSPropertyListSerialization propertyListFromData:D
            mutabilityOption: NSPropertyListImmutable
                format: nil errorDescription: &errorString];
        if (errorString) {
            OUTERROR4iTM3(1,errorString,1);
		}
//NSLog(@"DM: %@", DM);
        if ([self loadPropertyListRepresentation:DM])
            return YES;
        LOG4iTM3(@"Corrupted spelling context at:\n%@", fileURL);
    }
//END4iTM3;
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  writeToURL:error:
- (BOOL)writeToURL:(NSURL *)fileURL error:(NSError**)RORef;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed 05 mar 03
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (fileURL.isFileURL) {
		if (![DFM isWritableFileAtPath:fileURL.path]) {
			return YES;
		}
	}
    id PL = self.propertyListRepresentation;
    NSString * errorString = nil;
    id D = [NSPropertyListSerialization dataFromPropertyList:PL
        format: NSPropertyListXMLFormat_v1_0 errorDescription: &errorString];
    OUTERROR4iTM3(1,errorString,nil);
//NSLog(@"data: %@", result);
//END4iTM3;
    return [D writeToURL:fileURL options:NSAtomicWrite error:RORef];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  propertyListRepresentation
- (id)propertyListRepresentation;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSMutableDictionary * md = [NSMutableDictionary dictionary];
	for (NSString * mode in [self.spellContexts allKeys]) {
		[md setObject:[[self spellContextForMode:mode] propertyListRepresentation] forKey:mode];
    }
	NSMutableDictionary * MD = [NSMutableDictionary dictionaryWithObjectsAndKeys:
        iTM2SpellModesIsaValue,TWSSpellIsaKey,
        md,iTM2SpellModesKey,
            nil];
//END4iTM3;
    return MD;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  loadPropertyListRepresentation:
- (BOOL)loadPropertyListRepresentation:(id)PL;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed 05 mar 03
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    BOOL result = NO;
    NS_DURING
    if ([[PL valueForKey:TWSSpellIsaKey] isEqual:iTM2SpellModesIsaValue])
    {
		[self setSpellContexts:[NSDictionary dictionary]];
        NSDictionary * d = [PL objectForKey:iTM2SpellModesKey];
        if ([d isKindOfClass:[NSDictionary class]])
        {
            NSEnumerator * E = d.keyEnumerator;
            NSString * mode;
            while((mode = E.nextObject))
            {
                iTM3SpellContext * SC = [[iTM3SpellContext alloc] init];
                if ([SC loadPropertyListRepresentation:[d objectForKey:mode]])
                    [self setSpellContext4iTM3:SC forMode:mode];
                else
                    result = NO;
            }
        }
//LOG4iTM3(@"SPELL CONTEXTS LOADED...\n%@", self.propertyListRepresentation);
    }
	else if (PL)
	{
		LOG4iTM3(@"BAD or missing value for %@ key: %@ was expected", TWSSpellIsaKey, iTM2SpellModesIsaValue);
	}
    NS_HANDLER
	LOG4iTM3(@"***  EXCEPTION CATCHED: BAD property list, %@", [localException reason]);
    NS_ENDHANDLER
//END4iTM3;
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  isEdited
- (BOOL)isEdited;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return self.changeCount != ZER0;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  updateChangeCount
- (void)updateChangeCount:(NSDocumentChangeType)change;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (change == NSChangeDone)
        ++self.changeCount;
    else if (change == NSChangeUndone)
        --self.changeCount;
    else
        self.changeCount = ZER0;
//END4iTM3;
    return;
}
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  iTM2SpellCheckerHelper

#import "iTM2WindowKit.h"

@implementation iTM2IgnoredWordsWindow 
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= frameIdentifier4iTM3
- (NSString *)frameIdentifier4iTM3;
/*"Subclasses should override this method. The default implementation returns a ZER0 length string, and deactivates the 'register current frame' process.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri May 21 07:52:07 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return @"iTM2IgnoredWords";
}
@end

@interface _iTM2IgnoredWordsEditor: NSWindowController <NSTableViewDelegate,NSTableViewDataSource>
{
@private
    NSText *		__weak iVarCurrentText;
    NSTableView *	__strong iVarTableView;
    NSTextField *	__strong iVarModeField;
    NSTextField *	__strong iVarProjectField;
    NSMutableArray *	__strong iVarIgnoredWords;
    NSInteger			iVarSpellDocumentTag;
}
+ (id)sharedEditor;
- (BOOL)addIgnoredWord:(NSString *)argument;
- (BOOL)smartReplaceIgnoredWord:(NSString *)oldArgument by:(NSString *)newArgument;
- (BOOL)replaceIgnoredWord:(NSString *)oldArgument by:(NSString *)newArgument;
@property (assign) __weak NSText *	currentText;
@property (assign) NSTableView *	tableView;
@property (assign) NSTextField *	modeField;
@property (assign) NSTextField *	projectField;
@property (copy) NSMutableArray *	ignoredWords;
@property NSInteger	spellDocumentTag;
@end

#import "iTM2ValidationKit.h"

@interface NSText(iTM2SpellKit0)
- (NSInteger)spellCheckerDocumentTag;
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (!_iTM2SpellIgnoredWordsEditor)
	{
		_iTM2SpellIgnoredWordsEditor = [[_iTM2IgnoredWordsEditor alloc]
            initWithWindowNibName: @"iTM2IgnoredWordsEditor"];
	}
//END4iTM3;
    return _iTM2SpellIgnoredWordsEditor;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  windowDidLoad
- (void)windowDidLoad;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[super windowDidLoad];
    if (!self.isWindowContentValid4iTM3) DEBUGLOG4iTM3(100, @"invalid GUI");
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  setCurrentText:
- (void)setCurrentText:(NSText *)currentText;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (currentText) {
		iVarCurrentText = currentText;
		iTM2SpellContextController * currentController = [currentText spellContext4iTM3ControllerError:self.RORef4iTM3];
		NSString * currentMode = [currentController spellContextModeForText:currentText];
		iTM3SpellContext * currentContext = [currentController spellContextForMode:currentMode];
		self.ignoredWords = ([[SSC ignoredWordsInSpellDocumentWithTag:currentContext.tag] mutableCopy]?
			: [NSMutableArray array]);
		[iVarIgnoredWords sortUsingSelector:@selector(compare:)];
		[self.tableView reloadData];
		[self.tableView display];
		if (!self.isWindowContentValid4iTM3) DEBUGLOG4iTM3(100, @"invalid GUI");
	} else {
		iVarCurrentText = nil;
		[self.tableView reloadData];
		[self.tableView display];
	}
//END4iTM3;
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
//    [sender.window makeFirstResponder:nil];
    [self.tableView abortEditing];
    NSString * newArgument = @"?";
    if ([self addIgnoredWord:newArgument])
    {
		[self.tableView reloadData];
		[self.tableView display];
        NSUInteger row = [self.ignoredWords indexOfObject:newArgument];
        if (row>=ZER0) {
            [self.tableView deselectAll:self];
            [self.tableView selectRowIndexes:[NSIndexSet indexSetWithIndex:row] byExtendingSelection:NO];
//            [iVarTableView scrollRowToVisible:row];
            [self.tableView editColumn:ZER0 row:[self.tableView selectedRow] withEvent:nil select:YES];
            return;
        }
    }
    LOG4iTM3(@"PROBLEM: could not add %@", newArgument);
    iTM2Beep();
//NSLog(@"ignored words: %@", self.ignoredWords);
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  ok:
- (void)ok:(NSView *)sender;
/*"Message sent when all is finished.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    while([self.ignoredWords containsObject:@"?"])
        [iVarIgnoredWords removeObject:@"?"];
    iTM3SpellContext * currentContext = [self.currentText spellContext4iTM3];
    [currentContext replaceIgnoredWords:self.ignoredWords];
    self.currentText = nil;// necessary
    [NSApp endSheet:sender.window returnCode:NSAlertDefaultReturn];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  cancel:
- (void)cancel:(NSView *)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    self.currentText = nil;// necessary
    [NSApp endSheet:sender.window returnCode:NSAlertAlternateReturn];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  check:
- (void)check:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  validateProjectNameEdited:
- (BOOL)validateProjectNameEdited:(NSControl *)sender;
/*"Catcher.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSString * name = [self.currentText spellPrettyProjectName];
    sender.stringValue = name.length? name:
        NSLocalizedStringFromTableInBundle(@"None", TABLE,
            self.classBundle4iTM3, "No project/text/mode name for the spell check document");
//END4iTM3;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  modeNameEdited:
- (IBAction)modeNameEdited:(NSControl *)sender;
/*"Just a message catcher.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  validateModeNameEdited:
- (BOOL)validateModeNameEdited:(NSControl *)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSString * currentMode = [self.currentText spellContextMode];
    sender.stringValue = currentMode.length? currentMode:
        NSLocalizedStringFromTableInBundle(@"None", TABLE,
            self.classBundle4iTM3, "No project/text/mode name for the spell check document");
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  numberOfIgnoredWordsEdited:
- (IBAction)numberOfIgnoredWordsEdited:(id)sender;
/*"Just a message catcher.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  validateNumberOfIgnoredWordsEdited:
- (BOOL)validateNumberOfIgnoredWordsEdited:(NSControl *)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSInteger total = [self numberOfRowsInTableView:iVarTableView];
    if ([self.tableView numberOfSelectedRows] == 1) {
        sender.stringValue = [NSString stringWithFormat:@"%i/%i", [self.tableView selectedRow] +1, total];
    } else {
        sender.stringValue = [NSString stringWithFormat:@"%i", total];
    }
//END4iTM3;
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (tableView != iVarTableView) {
		iVarTableView.delegate = iVarTableView.target = iVarTableView.dataSource = nil;
        if ((iVarTableView = tableView)) {
            iVarTableView.delegate = iVarTableView.target = iVarTableView.dataSource = self;
            [iVarTableView reloadData];
            [iVarTableView setNeedsDisplay:YES];
        }
    }
        
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  numberOfRowsInTableView:
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView;
/*"Description forthcoming. Passive delegate.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return self.ignoredWords.count;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  tableView:objectValueForTableColumn:row:
- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return ((row>-1) && ((row<self.ignoredWords.count))? [self.ignoredWords objectAtIndex:row]:@"?");
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  tableView:setObjectValue:forTableColumn:row:
- (void)tableView:(NSTableView *)tableView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSString * oldArgument = ((row>-1) && ((row<self.ignoredWords.count))? [self.ignoredWords objectAtIndex:row]:nil);
    if (oldArgument && [self smartReplaceIgnoredWord:oldArgument by:object]) {
        [tableView reloadData];
        [tableView setNeedsDisplay:YES];
        NSUInteger row = [self.ignoredWords indexOfObject:object];
        [tableView selectRowIndexes:[NSIndexSet indexSetWithIndex:row] byExtendingSelection:NO];
        [tableView scrollRowToVisible:row];
    } else {
//START4iTM3;
        NSLog(@"No replacement of %@ by %@", oldArgument, object);
        [tableView reloadData];// bad word given:things should change
        [tableView setNeedsDisplay:YES];
    }
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  removeSelectedRowsInTableView:
- (void)removeSelectedRowsInTableView:(NSTableView *)TV;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSIndexSet * IS = TV.selectedRowIndexes;
	NSInteger idx = IS.lastIndex;
	while(idx != NSNotFound) {
        if ((idx>=ZER0) && (idx<self.ignoredWords.count))
            [self.ignoredWords removeObjectAtIndex:idx];
		idx = [IS indexLessThanIndex:idx];
	}
    [TV reloadData];
    if (!self.isWindowContentValid4iTM3) DEBUGLOG4iTM3(100, @"invalid GUI");
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  tableViewSelectionDidChange:
- (void)tableViewSelectionDidChange:(NSNotification *)notification;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (!self.isWindowContentValid4iTM3) DEBUGLOG4iTM3(100, @"invalid GUI");
	if ([notification.object acceptsFirstResponder]) {
		[self.window makeFirstResponder:notification.object];
	}
//END4iTM3;
    return;
}
#if 0
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  tableView:shouldEditTableColumn:tableColumn row:
- (BOOL)tableView:(NSTableView *)tableView shouldEditTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return YES;
}
// optional

// optional - drag and drop support
- (BOOL)tableView:(NSTableView *)tv writeRowsWithIndexes:(NSIndexSet *)rowIndexes toPasteboard:(NSPasteboard*)pboard;
    // This method is called after it has been determined that a drag should begin, but before the drag has been started.  To refuse the drag, return NO.  To start a drag, return YES and place the drag data onto the pasteboard (data, owner, etc...).  The drag image and other drag related information will be set up and provided by the table view once this call returns with YES.  The rows array is the list of row numbers that will be participating in the drag.

- (NSDragOperation)tableView:(NSTableView*)tv validateDrop:(id <NSDraggingInfo>)info proposedRow:(NSInteger)row proposedDropOperation:(NSTableViewDropOperation)op;
    // This method is used by NSTableView to determine a valid drop target.  Based on the mouse position, the table view will suggest a proposed drop location.  This method must return a value that indicates which dragging operation the data source will perform.  The data source may "re-target" a drop if desired by calling setDropRow:dropOperation: and returning something other than NSDragOperationNone.  One may choose to re-target for various reasons (eg. for better visual feedback when inserting into a sorted position).

- (BOOL)tableView:(NSTableView*)tv acceptDrop:(id <NSDraggingInfo>)info row:(NSInteger)row dropOperation:(NSTableViewDropOperation)op;
    // This method is called when the mouse is released over an outline view that previously decided to allow a drop via the validateDrop method.  The data source should incorporate the data from the dragging pasteboard at this time.



- (void)tableView:(NSTableView *)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row;
- (BOOL)selectionShouldChangeInTableView:(NSTableView *)aTableView;
- (BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row;
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if ([argument isKindOfClass:[NSString class]]) {
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSRange R = [SSC checkSpellingOfString:argument
        startingAt: ZER0
            language: [SSC language]
                wrap: NO
                    inSpellDocumentWithTag: [self.currentText spellCheckerDocumentTag]
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [self isWellFormedWord:argument] && [self isMisspelledWord:argument] && [self addIgnoredWord:argument];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  addIgnoredWord:
- (BOOL)addIgnoredWord:(NSString *)argument;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    // finding where to insert the word:
    NSUInteger index = ZER0;
    while(index < self.ignoredWords.count) {
        NSComparisonResult CR = [argument compare:[self.ignoredWords objectAtIndex:index]];
        if (CR == NSOrderedSame)
            return NO;
        else if (CR == NSOrderedDescending)
            break;
        ++index;
    }
    [self.ignoredWords insertObject:argument atIndex:index];
//NSLog(@"%@", self.ignoredWords);
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  removeIgnoredWord:
- (BOOL)removeIgnoredWord:(NSString *)argument;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSInteger index = [self.ignoredWords indexOfObject:argument];
    if (index != NSNotFound) {
        [self.ignoredWords removeObject:argument];
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSUInteger index = [self.ignoredWords indexOfObject:oldArgument];
    if ((index != NSNotFound) && ![oldArgument isEqualToString:newArgument]) {
        [self.ignoredWords replaceObjectAtIndex:index withObject:newArgument];
        [self.ignoredWords sortUsingSelector:@selector(compare:)];
//NSLog(@"%@", self.ignoredWords);
        return YES;
    } else {
        return NO;
    }
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  setIgnoredWords:
- (void)setIgnoredWords:(id)argument;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    iVarIgnoredWords = [argument mutableCopy];
    [iVarIgnoredWords sortUsingSelector:@selector(compare:)];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  context4iTM3Manager:
- (id)context4iTM3Manager;
/*"Returns the context4iTM3Manager of its window controller.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3
	NSText * source = self.currentText;
    return source.window.windowController != self? source.context4iTM3Manager:nil;
}
@synthesize currentText=iVarCurrentText;
@synthesize tableView=iVarTableView;
@synthesize modeField=iVarModeField;
@synthesize projectField=iVarProjectField;
@synthesize ignoredWords=iVarIgnoredWords;
@synthesize spellDocumentTag=iVarSpellDocumentTag;
@end

@interface iTM2SpellCheckerHelper(PRIVATE)
- (id)currentText;
- (void)setCurrentText:(id)argument;
- (void)setCurrentSpellLanguage:(NSString *)language;
- (BOOL)isEditing;
- (void)setEditing:(BOOL)yorn;
- (void)delayedSetCurrentSpellLanguage:(NSString *)language;
@end

static iTM2SpellCheckerHelper * _iTM2SpellCheckerHelper = nil;

#import "iTM2Runtime.h"

@implementation iTM2MainInstaller(SpellKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  iTM2SpellKitCompleteInstallation4iTM3
+ (void)iTM2SpellKitCompleteInstallation4iTM3;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (![NSText instancesRespondToSelector:@selector(iTM2SpellKit_NSText_Catcher:)]) {
		[NSText swizzleInstanceMethodSelector4iTM3:@selector(SWZ_iTM2Spell_becomeFirstResponder) error:NULL];
		[NSTextView swizzleInstanceMethodSelector4iTM3:@selector(SWZ_iTM2Spell_becomeFirstResponder) error:NULL];
		[NSTextView swizzleInstanceMethodSelector4iTM3:@selector(SWZ_iTM2Spell_setContinuousSpellCheckingEnabled:) error:NULL];
		[NSTextView swizzleInstanceMethodSelector4iTM3:@selector(SWZ_iTM2Spell_toggleContinuousSpellChecking:) error:NULL];
	}
	if ([SUD boolForKey:@"iTM2DisableMoreSpell"]) {
		LOG4iTM3(@"No MoreSpell available...");
		return;
	}
    [SUD registerDefaults:
        [NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithBool:NO], iTM2UDContinuousSpellCheckingKey,
                nil]];
//LOG4iTM3(@"[SUD objectForKey:iTM2DisableMoreSpell] is:%@", [SUD objectForKey:@"iTM2DisableMoreSpell"]);
    _iTM2SpellCheckerHelper = [[iTM2SpellCheckerHelper alloc] initWithWindowNibName:@"iTM2SpellCheckerHelper"];
	NSWindow * W = _iTM2SpellCheckerHelper.window;
	[W setExcludedFromWindowsMenu:YES];// loads the nib as side effect...
    // installing the accessory view in the spell checker panel
    NSView * V1 = [_iTM2SpellCheckerHelper spellCheckerAccessoryView];
    NSView * V2 = [SSC accessoryView];
//NSLog(@"%@", V);
    if (![V2 isEqual:V1])
    {
        NSPanel * P = [SSC spellingPanel];
//NSLog(NSStringFromSize(P.minSize));
//NSLog(NSStringFromRect(P.frame));
        NSSize S1 = V1.frame.size;
        NSSize oldS = P.minSize;
        NSRect oldF = P.frame;
        NSSize newS = oldS;
        if (V2)
            newS.height -= V2.frame.size.height;
        NSSize S2 = [P.contentView frame].size;
        S1.width = S2.width;
        [V1 setFrameSize: S1];
        newS.height += S1.height;
        [SSC setAccessoryView:V1];
        if (NSEqualSizes(P.minSize, oldS))
            P.minSize = newS;
        if (!NSEqualRects(P.frame, oldF))
            [P setFrame:NSMakeRect(oldF.origin.x, oldF.origin.y, oldF.size.width, MAX(oldF.size.height, newS.height))
                display: YES];
//NSLog(NSStringFromSize(P.minSize));
//NSLog(NSStringFromRect(P.frame));
    }
	DEBUGLOG4iTM3(0,@"the accessory view is: %@", [SSC accessoryView]);
    DEBUGLOG4iTM3(0,@"the accessory view was: %@", V2);
    DEBUGLOG4iTM3(0,@"the accessory view should be: %@", V1);
//	START_TRACKING4iTM3;
    return;
}
@end
@implementation iTM2SpellCheckerHelper
@synthesize implementation=_iVarPrivateImplementation;
@synthesize currentText=_iVarCurrentText;
@synthesize isSynchronizing = _iVarIsSynchronizing;
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  sharedHelper
+ (id)sharedHelper;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	return _iTM2SpellCheckerHelper;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  initWithWindow:
- (id)initWithWindow:(NSWindow *)window;
/*"One instance can be created.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (_iTM2SpellCheckerHelper)
    {
        return _iTM2SpellCheckerHelper;
    }
    else if ((self = [super initWithWindow:window]))
    {
		[self initImplementation];
		_iVarCurrentText = nil;
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  windowDidLoad
- (void)windowDidLoad;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[super windowDidLoad];
	[self.window orderOut:self];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  textDidEndEditingNotified:
- (void)textDidEndEditingNotified:(NSNotification *)notification;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//LOG4iTM3(@"[SSC language] is:%@", [SSC language]);
	NSText * text = [notification object];
	if (text == self.currentText)
	{
		iTM3SpellContext * SC = [text spellContext4iTM3];
		if (SC)
		{
			[SC setSpellLanguage:[SSC language]];
			[SC setIgnoredWords:[SSC ignoredWordsInSpellDocumentWithTag:SC.tag]];
//LOG4iTM3(@"INFO: THE SPELL LANGUAGE AND IGNORED WORDS HAVE BEEN RECORDED FOR THE CURRENT TEXT %#x", text);
		}
		else if (text)
		{
//LOG4iTM3(@"*** ERROR: MISSING SPELL CONTEXT FOR TEXT: %#x in window %@", text, text.window.title);
		}
		self.currentText = nil;
		if (!self.isWindowContentValid4iTM3) DEBUGLOG4iTM3(100, @"invalid GUI");
	}
	else
	{
//LOG4iTM3(@"INFO: TEXT %#x IS NOT THE CURRENT TEXT %#x", text, self.currentText);
	}
//END4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  _windowWillCloseOrDidResignKeyNotified:
- (void)_windowWillCloseOrDidResignKeyNotified:(NSNotification *)notification;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (self.isEditing)
        return;
//START4iTM3;
//LOG4iTM3(@"[SSC language] is:%@", [SSC language]);
	NSText * text = self.currentText;
    if ([notification object] == text.window)
    {
		iTM3SpellContext * SC = [text spellContext4iTM3];
		if (SC)
		{
			NS_DURING
			[SC setSpellLanguage:[SSC language]];
			[SC setIgnoredWords:[SSC ignoredWordsInSpellDocumentWithTag:SC.tag]];
			//NSObjectInaccessibleException -- NSDistantObject access attempted from another thread
//LOG4iTM3(@"INFO: THE SPELL LANGUAGE AND IGNORED WORDS HAVE BEEN RECORDED FOR THE CURRENT TEXT %#x in window %@", text, text.window.title);
			NS_HANDLER
			LOG4iTM3(@"***  EXCEPTION CATCHED: %@, spell context not saved...", [localException reason]);
			NS_ENDHANDLER
		}
		else if (text)
		{
//LOG4iTM3(@"*** ERROR: MISSING SPELL CONTEXT FOR TEXT: %#x in window %@", text, text.window.title);
		}
        self.currentText = nil;
		if (!self.isWindowContentValid4iTM3) DEBUGLOG4iTM3(100, @"invalid GUI");
	}
	else
	{
//LOG4iTM3(@"INFO: TEXT WINDOW %@ IS NOT THE CURRENT TEXT WINDOW %@", [notification object], text.window);
	}
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  _windowDidBecomeKeyNotified:
- (void)_windowDidBecomeKeyNotified:(NSNotification *)notification;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (self.isEditing)
        return;
    NSWindow * newW = [notification object];
    if ([newW level] >= [[SSC spellingPanel] level])
	{
        newW = [NSApp mainWindow];
		if ([newW level] >= [[SSC spellingPanel] level])
			return;
	}
//START4iTM3;
//LOG4iTM3(@"[SSC language] is:%@", [SSC language]);
	[SUD setObject:[SSC language] forKey:iTM2CurrentSpellLanguageKey];
    NSText * newText = (NSText *)(newW.firstResponder);
	while(newText && ![newText respondsToSelector:@selector(iTM2SpellKit_NSText_Catcher:)])
		newText = (NSText *)(newText.nextResponder);
//LOG4iTM3(@"Updating the spell information, [SSC language] is:%@", [SSC language]);
    // updating the actual information to make the current mode and the language in synch
//LOG4iTM3(@"self.currentText is:%@", self.currentText);
	self.currentText = newText;
	iTM3SpellContext * SC;
//LOG4iTM3(@"iVarCurrentTextRef is changed, [SSC language] is:%@", [SSC language]);
	if ((SC = newText.spellContext4iTM3))
	{
		NSString * language = SC.spellLanguage;
		if (![SSC setLanguage:language])
		{
			LOG4iTM3(@"THE %@ LANGUAGE IS UNKNOWN by cocoa spell checker, %@ is used instead(1)", language, [SSC language]);
			[SC setSpellLanguage:[SSC language]];
		}
		else
		{
//LOG4iTM3(@"INFO: THE LANGUAGE IS NOW %@", language);
		}
		if (newW)// avoid recursivity
		{
            NSString * S = newText.string;
            NSRange R = iTM3MakeRange(ZER0,S.length);
            R = iTM3ProjectionRange(R,newText.selectedRange);// do not assume that the selected range lays between the text limits
            if (R.length)
            {
                S = [S substringWithRange:R];
                [SSC updateSpellingPanelWithMisspelledWord:S];
                [SSC updateGuessesList];
            }
        }
	}
	else if (newText)
	{
//LOG4iTM3(@"*** ERROR: MISSING SPELL CONTEXT FOR TEXT: %#x in window %@", newText, newText.window.title);
        [newText spellContext4iTM3];
	}
	else
	{
//LOG4iTM3(@"INFO: NO TEXT CATCHED FOR SPELL CHECKING");
	}
//LOG4iTM3(@"[SSC language] is:%@", [SSC language]);
	if ([self.window isVisible])
		if (!self.isWindowContentValid4iTM3) DEBUGLOG4iTM3(100, @"invalid GUI");
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  textDidBecomeFirstResponder:
- (void)textDidBecomeFirstResponder:(NSText *)newText;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//LOG4iTM3(@"[SSC language] is:%@", [SSC language]);
    if (self.isEditing)
        return;
	NSString * language = [SSC language];
	[SUD setObject:language forKey:iTM2CurrentSpellLanguageKey];
    NSWindow * newW = newText.window;
    if ([newW level] >= [[SSC spellingPanel] level])
        return;
//LOG4iTM3(@"Updating the spell information, [SSC language] is:%@", [SSC language]);
    // updating the actual information to make the current mode and the language in synch
//LOG4iTM3(@"self.currentText is:%@", self.currentText);
	iTM3SpellContext * SC = [self.currentText spellContext4iTM3];
    [SC setSpellLanguage:language];
    [SC setIgnoredWords:[SSC ignoredWordsInSpellDocumentWithTag:SC.tag]];
    if (newText != self.currentText)
    {
		// save the actual settings for the old text:
        self.currentText = newText;
//LOG4iTM3(@"iVarCurrentTextRef is changed, [SSC language] is:%@", [SSC language]);
		if ((SC = newText.spellContext4iTM3))
		{
			NSString * language = SC.spellLanguage;
			if (![SSC setLanguage:language])
			{
				LOG4iTM3(@"INFO: THE %@ LANGUAGE IS UNKNOWN by cocoa spell checker, %@ is used instead(2)", language, [SSC language]);
				SC.spellLanguage = [SSC language];
			}
			if (newW)// avoid recursivity
			{
                NSString * S = newText.string;
				NSRange R = iTM3MakeRange(ZER0,S.length);
                R = iTM3ProjectionRange(R,newText.selectedRange);// do not assume that the selected range lays between the text limits
				if (R.length)
				{
                    S = [S substringWithRange:R];
					[SSC updateSpellingPanelWithMisspelledWord:S];
					[SSC updateGuessesList];
				}
			}
		}
	}
//LOG4iTM3(@"[SSC language] is:%@", [SSC language]);
    if (!self.isWindowContentValid4iTM3) DEBUGLOG4iTM3(100, @"invalid GUI");
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  isEditing
- (BOOL)isEditing;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
	return [metaGETTER boolValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  setEditing:
- (void)setEditing:(BOOL)yorn;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	metaSETTER([NSNumber numberWithBool:yorn]);
//END4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  delayedSetCurrentSpellLanguage:
- (void)delayedSetCurrentSpellLanguage:(NSString *)language;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[self setCurrentSpellLanguage:language];// was retained above
//END4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  setCurrentSpellLanguage:
- (void)setCurrentSpellLanguage:(NSString *)language;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[SUD setObject:language forKey:iTM2CurrentSpellLanguageKey];
    NSWindow * newW = [NSApp keyWindow];
    if ([newW level] >= [[SSC spellingPanel] level])
	{
        newW = [NSApp mainWindow];
		if ([newW level] >= [[SSC spellingPanel] level])
			return;
	}
    NSText * newText = (NSText *)(newW.firstResponder);
	while(newText && ![newText respondsToSelector:@selector(iTM2SpellKit_NSText_Catcher:)])
		newText = (NSText *)(newText.nextResponder);
//LOG4iTM3(@"Updating the spell information, [SSC language] is:%@", [SSC language]);
    // updating the actual information to make the current mode and the language in synch
//LOG4iTM3(@"self.currentText is:%@", self.currentText);
	iTM3SpellContext * SC = self.currentText.spellContext4iTM3;
    SC.spellLanguage = language;
    SC.ignoredWords = [SSC ignoredWordsInSpellDocumentWithTag:SC.tag];
    if (newText != self.currentText)
    {
		// save the actual settings for the old text:
        self.currentText = newText;
//LOG4iTM3(@"iVarCurrentTextRef is changed, [SSC language] is:%@", [SSC language]);
		if ((SC = newText.spellContext4iTM3))
		{
			NSString * language = SC.spellLanguage;
			if (![SSC setLanguage:language])
			{
				LOG4iTM3(@"THE %@ LANGUAGE IS UNKNOWN by cocoa spell checker, %@ is used instead(3)", language, [SSC language]);
				[SC setSpellLanguage:[SSC language]];
			}
			if (newW)// avoid recursivity
			{
                NSString * S = newText.string;
                NSRange R = iTM3MakeRange(ZER0,S.length);
                R = iTM3ProjectionRange(R,newText.selectedRange);// do not assume that the selected range lays between the text limits
                if (R.length)
                {
                    S = [S substringWithRange:R];
                    [SSC updateSpellingPanelWithMisspelledWord:S];
                    [SSC updateGuessesList];
                }
            }
		}
	}
//LOG4iTM3(@"[SSC language] is:%@", [SSC language]);
    if (!self.isWindowContentValid4iTM3) DEBUGLOG4iTM3(100, @"invalid GUI");
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  _1stResponderMightHaveChanged:
- (void)_1stResponderMightHaveChanged:(id)irrelevant;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//LOG4iTM3(@"[SSC language] is:%@", [SSC language]);
	[self setCurrentSpellLanguage:[SSC language]];// this needs SSC inited unless infinite loop
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  synchronizeWithCurrentText
- (void)synchronizeWithCurrentText;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	// reentrant part
	if (self.isSynchronizing) {
		return;
    }
    self.isSynchronizing = YES;
	NSText * text = self.currentText;
	// this is the crucial part that needs reentrant management
	iTM3SpellContext * SC = [text spellContext4iTM3];
	NSString * language = SC.spellLanguage;
	if (![SSC setLanguage:language])
	{
		LOG4iTM3(@"THE %@ LANGUAGE IS UNKNOWN by cocoa spell checker, %@ is used instead(4)", language, [SSC language]);
		[SC setSpellLanguage:[SSC language]];
	}
	if (text.window)// avoid recursivity
	{
        NSString * S = text.string;
        NSRange R = iTM3MakeRange(ZER0,S.length);
        R = iTM3ProjectionRange(R,text.selectedRange);// do not assume that the selected range lays between the text limits
        if (R.length)
        {
            S = [S substringWithRange:R];
            [SSC updateSpellingPanelWithMisspelledWord:S];
            [SSC updateGuessesList];
        }
    }
//LOG4iTM3(@"[SSC language] is:%@", [SSC language]);
	self.isSynchronizing = NO;
    if (!self.isWindowContentValid4iTM3) DEBUGLOG4iTM3(100, @"invalid GUI");
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  spellCheckerAccessoryView
- (NSView *)spellCheckerAccessoryView;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return metaGETTER;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  setSpellCheckerAccessoryView
- (void)setSpellCheckerAccessoryView:(NSView *)view;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (view != metaGETTER)
	{
		metaSETTER(view);
	}
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  isWindowContentValid4iTM3
- (BOOL)isWindowContentValid4iTM3;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
	BOOL result = [super isWindowContentValid4iTM3];
	result = [self.spellCheckerAccessoryView isWindowContentValid4iTM3] && result;
    return result;
}
#pragma mark =-=-=-=-=-  GUI Validation
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  projectNameEdited:
- (IBAction)projectNameEdited:(id)sender;
/*"Catcher.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  validateProjectNameEdited:
- (BOOL)validateProjectNameEdited:(id)sender;
/*"Catcher.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSString * name = [self.currentText spellPrettyProjectName];
    [sender setStringValue:(name.length? name:
        NSLocalizedStringFromTableInBundle(@"None", TABLE,
            self.classBundle4iTM3, "No project/text/mode name for the spell check document"))];
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  textNameEdited:
- (IBAction)textNameEdited:(id)sender;
/*"Catcher.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  validateTextNameEdited:
- (BOOL)validateTextNameEdited:(NSTextField *)sender;
/*"Catcher.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSString * FN = [self.currentText spellPrettyName];
//NSLog(@"FN: %@", FN);
    if (FN.length)
        sender.stringValue = FN;
    else
    {
        NSAttributedString * AS = [sender attributedStringValue];
		NSString * S = self.currentText.window.title;
        if (S.length && AS.length)
        {
            NSMutableDictionary * attributes = [[AS attributesAtIndex:ZER0 effectiveRange:nil] mutableCopy];
            NSFont * F = [attributes objectForKey:NSFontAttributeName];
            if (!F)
                F = [NSFont userFontOfSize:[NSFont systemFontSize]];
            [attributes setObject:[[NSFontManager sharedFontManager] convertFont:F toHaveTrait:NSItalicFontMask] forKey:NSFontAttributeName];
            [attributes setObject:[NSColor grayColor] forKey:NSForegroundColorAttributeName];
            [sender setAttributedStringValue:[[NSAttributedString alloc]
											  initWithString: S attributes:attributes]];
        }
        else
            [sender setStringValue:NSLocalizedStringFromTableInBundle(@"None", TABLE,
                self.classBundle4iTM3, "No project/text/mode name for the spell check document")];
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSString * oldMode = [self.currentText spellContextMode];
//NSLog(@"new mode: %@", newMode);
//NSLog(@"old mode: %@", oldMode);
    if (![TWSSpellDefaultContextMode isEqualToString:oldMode])
    {
        // synchronisation is critical here because we make an intensive use of side effects.
        // we must also force the cocoa spell checker to change the spell document tag.
        // this is the reason why we change the first responder.
        [[self.currentText spellContext4iTM3] setSpellLanguage:[SSC language]];
        [self.currentText setSpellContextMode:TWSSpellDefaultContextMode];
        NSWindow * W = self.currentText.window;
        id FR = W.firstResponder;
        [W makeFirstResponder:nil];
        [W makeFirstResponder:FR];
        if (!self.isWindowContentValid4iTM3) DEBUGLOG4iTM3(100, @"invalid GUI");
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  validateSelectMode:
- (BOOL)validateSelectMode:(NSPopUpButton *)sender;
/*"Message catcher.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if ([sender isKindOfClass:[NSPopUpButton class]]) {
        iTM2SpellContextController * currentController = [self.currentText spellContext4iTM3ControllerError:self.RORef4iTM3];
        // updating the popup:
        [sender removeAllItems];
        NSString * title = NSLocalizedStringFromTableInBundle(TWSSpellDefaultContextMode, TABLE,
                    self.classBundle4iTM3, "DF");
        [sender addItemWithTitle:title];
        #if 0
        if (currentController == [iTM2SpellContextController defaultSpellContextController]) 
        {
            [sender selectItemAtIndex:ZER0];
            [sender setEnabled:NO];
            return;
        }
        #endif
        [sender setEnabled:YES];
        NSMenu * M = sender.menu;
        [M addItem:[NSMenuItem separatorItem]];
        NSMenuItem * MI;
        NSMenu * SM = [[NSMenu alloc] initWithTitle:@""];
        NSEnumerator * E = [[[[currentController spellContextModesEnumerator] allObjects]
                                        sortedArrayUsingSelector: @selector(compare:)] objectEnumerator];
        NSString * contextMode;
        while((contextMode = E.nextObject))
        {
            if (![contextMode isEqualToString:TWSSpellDefaultContextMode])
            {
        //NSLog(@"title: %@", title);
                MI = (NSMenuItem *)[M addItemWithTitle:contextMode action:@selector(takeSpellingModeFromRepresentedObject:) keyEquivalent:@""];
                MI.representedObject = contextMode;
                MI.target = self;
                MI = (NSMenuItem *)[SM addItemWithTitle:contextMode action:@selector(removeSpellingModeFromRepresentedObject:) keyEquivalent:@""];
                MI.representedObject = contextMode;
                MI.target = self;
            }
        }
        NSString * currentMode = [currentController spellContextModeForText:self.currentText];
        [sender selectItemAtIndex:[M indexOfItemWithRepresentedObject:currentMode]];
        [sender synchronizeTitleAndSelectedItem];
        // filling the spelling modes management items
//        if (currentController != [iTM2SpellContextController defaultSpellContextController])
        {
    //NSLog(@"Not the default spelling model");
            if ([SM numberOfItems])
            {
                [M addItem:[NSMenuItem separatorItem]];
                MI = (NSMenuItem *)[M addItemWithTitle:NSLocalizedStringFromTableInBundle(@"Remove mode", TABLE,
                                self.classBundle4iTM3, "DF")
                            action: NULL keyEquivalent: @""];
                [MI setSubmenu:SM];
            }
            MI = (NSMenuItem *)[M addItemWithTitle:NSLocalizedStringFromTableInBundle(@"New mode...", TABLE,
                                            self.classBundle4iTM3, "DF")
                    action: @selector(newMode:) keyEquivalent: @""];
            MI.target = self;
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
//NSLog(@"newMode 1 %@", currentController);
    [self setEditing:YES];
//NSLog(@"YESSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS");
    [NSApp beginSheet:self.window
        modalForWindow: [SSC spellingPanel]
        modalDelegate: nil
        didEndSelector: NULL
        contextInfo: nil];
//NSLog(@"newMode 2 %@", currentController);
    [NSApp runModalForWindow:self.window];
    // Sheet is up here.
    [NSApp endSheet:self.window];
    [self.window orderOut:self];
    if (!self.isWindowContentValid4iTM3) DEBUGLOG4iTM3(100, @"invalid GUI");
    [self setEditing:NO];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  takeSpellingModeFromRepresentedObject:
- (void)takeSpellingModeFromRepresentedObject:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSString * oldMode = [self.currentText spellContextMode];
    NSString * newMode = [sender representedObject];
//NSLog(@"new mode: %@", newMode);
//NSLog(@"old mode: %@", oldMode);
    if (![newMode isEqualToString:oldMode])
    {
        // synchronisation is critical here because we make an intensive use of side effects.
        // we must also force the cocoa spell checker to change the spell document tag.
        // this is the reason why we change the first responder.
#if 1
        [[self.currentText spellContext4iTM3] setSpellLanguage:[SSC language]];
        [self.currentText setSpellContextMode:newMode];
        NSWindow * W = self.currentText.window;
        id FR = W.firstResponder;
        [W makeFirstResponder:W.contentView];
        [W makeFirstResponder:FR];
        if (!self.isWindowContentValid4iTM3) DEBUGLOG4iTM3(100, @"invalid GUI");
#else
        NSString * oldLanguage = [SSC language];
        NSWindow * W = self.currentText.window;
        id FR = W.firstResponder;
        [W makeFirstResponder:W.contentView];
        [currentController setSpellContextMode:newMode forText:self.currentText];
        [W makeFirstResponder:FR];
        if (oldLanguage.length)
            [[currentController spellContextForMode:oldMode] setSpellLanguage:oldLanguage];
        if (!self.isWindowContentValid4iTM3) DEBUGLOG4iTM3(100, @"invalid GUI");
#endif
    }
    return;
}
#if 0
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  validateMenuItem:
- (BOOL)validateMenuItem:(NSMenuItem *)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    SEL action = sender.action;
    if (action == @selector(takeSpellingModeFromRepresentedObject:))
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [[self.currentText spellContext4iTM3ControllerError:self.RORef4iTM3] removeSpellMode:[sender representedObject]];
    [self setEditing:NO];
    if (!self.isWindowContentValid4iTM3) DEBUGLOG4iTM3(100, @"invalid GUI");
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  editIgnoredWords:
- (void)editIgnoredWords:(NSView *)sender;
/*"Description forthcoming. Passive delegate.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (!self.currentText)
    {
        NSLog(@"No text available for spelling, comme c'est bizarre!");
        return;
    }
//LOG4iTM3(@"THE IGNORED WORDS ARE: %@", [[self.currentText spellContext4iTM3] ignoredWords]);
    [self setEditing:YES];
//NSLog(@"YESSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS");
    _iTM2IgnoredWordsEditor * IWE = [_iTM2IgnoredWordsEditor sharedEditor];
    [IWE setCurrentText:self.currentText];
    NSWindow * W = IWE.window;// this loads the window as side effect
    [NSApp beginSheet:W
            modalForWindow: sender.window
            modalDelegate: self
            didEndSelector: @selector(editIgnoredWordsSheetDidEnd:returnCode:irrelevant:)
            contextInfo: nil];
	// I tried to create a new window controller each time it is called but it caused an error 10/11 crash
//LOG4iTM3(@"THE IGNORED WORDS ARE NOW: %@", [[self.currentText spellContext4iTM3] ignoredWords]);
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  validateEditIgnoredWords:
- (BOOL)validateEditIgnoredWords:(id)sender;
/*"Description forthcoming. Passive delegate.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return self.currentText != nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  editIgnoredWordsSheetDidEnd:returnCode:irrelevant:
- (void)editIgnoredWordsSheetDidEnd:(NSWindow *)sheet returnCode:(NSInteger)returnCode irrelevant:(void *)unused;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [sheet orderOut:self];
    NSWindowController * WC = sheet.windowController;
//LOG4iTM3(@"return code: %i", returnCode);
    [WC.document removeWindowController:WC];
    [self setEditing:NO];
    return;
}
#pragma mark =-=-=-=-=-  New mode GUI
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  newModeEdited:
- (void)newModeEdited:(NSTextField *)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    iTM2SpellContextController * currentController = [self.currentText spellContext4iTM3ControllerError:self.RORef4iTM3];
    NSString * newMode = [sender stringValue];
    if ([[[currentController spellContextModesEnumerator] allObjects] containsObject:newMode])
    {
        sender.stringValue = @"";
        return;
    }
    [NSApp stopModal];
    [currentController addSpellMode:newMode];
    [currentController setSpellContextMode:newMode forText:self.currentText];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  newModeCancelled:
- (void)newModeCancelled:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if ([[theEvent charactersIgnoringModifiers] characterAtIndex:ZER0] == 0x7F)
    {
        id DS = self.dataSource;
        if ([DS respondsToSelector:@selector(removeSelectedRowsInTableView:)])
            [DS removeSelectedRowsInTableView:self];
    }
    else
        [super keyDown:theEvent];
    return;
}
#if 1
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  drawRow:clipRect:
- (void)drawRow:(NSInteger)row clipRect:(NSRect)theRect;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [super drawRow:row clipRect:theRect];
    return;
}
#endif
@end

#import "iTM2ProjectDocumentKit.h"

#import <objc/objc-class.h>

@implementation NSSpellChecker(iTeXMac2)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  delayedUpdateGuessesList
- (void)delayedUpdateGuessesList;
/*"Crash if we do not use a delayed design.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSButton * b = self.guessButton;
    [NSApp sendAction:b.action to:b.target from:self];
//END4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  updateGuessesList
- (void)updateGuessesList;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if ([SUD boolForKey:@"iTM2AutoUpdateGuessesList"])
	{
		[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(delayedUpdateGuessesList) object:nil];
		[self performSelector:@selector(delayedUpdateGuessesList) withObject:nil afterDelay:0];
	}
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  guessButton
- (NSButton *)guessButton;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    void * button;
    object_getInstanceVariable(self, "_guessButton", &button);
	if (!button)
	{
		LOG4iTM3(@"*** ERROR: extended spell checking won't work: please upgrade");
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
	return [SCH currentText];
}
@end

@interface NSText(iTM2SpellKit_PRIVATE)
- (NSInteger)spellCheckerDocumentTag4iTM3;
@end

@implementation NSText(iTM2Spell)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  SWZ_iTM2Spell_becomeFirstResponder
- (BOOL)SWZ_iTM2Spell_becomeFirstResponder;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if ([self SWZ_iTM2Spell_becomeFirstResponder]) {
        [SCH textDidBecomeFirstResponder:self];
        return YES;
    } else {
        return NO;
    }
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  spellContext4iTM3ControllerError:
- (id)spellContext4iTM3ControllerError:(NSError **)RORef;
/*"Asks a delegate for a non empty #{spellContext4iTM3ControllerError:RORef}.
The delegate is the first one that gives a sensitive answer among the receiver's delegate, its window's delegate, the document of its window's controller, the owner of its window's controller. In that specific order.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [self.window spellContext4iTM3ControllerError:RORef];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  spellContextMode
- (NSString *)spellContextMode;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return [[self spellContext4iTM3ControllerError:self.RORef4iTM3] spellContextModeForText:self];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  spellPrettyName
- (NSString *)spellPrettyName;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return [[self spellContext4iTM3ControllerError:self.RORef4iTM3] spellPrettyNameForText:self];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  spellPrettyProjectName
- (NSString *)spellPrettyProjectName;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [[self spellContext4iTM3ControllerError:self.RORef4iTM3] spellPrettyProjectNameForText:self ROR4iTM3];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  spellContext4iTM3
- (iTM3SpellContext *)spellContext4iTM3;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return [[self spellContext4iTM3ControllerError:self.RORef4iTM3] spellContextForMode:self.spellContextMode];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  setSpellContextMode:
- (void)setSpellContextMode:(NSString *)mode;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [[self spellContext4iTM3ControllerError:self.RORef4iTM3] setSpellContextMode:mode forText:self];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  spellCheckerDocumentTag
- (NSInteger)spellCheckerDocumentTag;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return self.spellContext4iTM3.tag;
}
@end

#endif
