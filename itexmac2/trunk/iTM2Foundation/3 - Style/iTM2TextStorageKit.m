/*
//
//  @version Subversion: $Id$ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Tue Oct 16 2001.
//  Copyright © 2004 Laurens'Tribune. All rights reserved.
//
//  This program is free software; you can redistribute it and/or modify it under the terms
//  of the GNU General Public License as published by the Free Software Foundation; either
//  version 2 of the License, or any later version, modified by the addendum below.
//  This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
//  without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
//  See the GNU General Public License for more details. You should have received a copy
//  of the GNU General Public License along with this program; if not, write to the Free Software
//  Foundation, Inc., 59 Temple Place-Suite 330, Boston, MA 02111-1307, USA.
//  GPL addendum: Any simple modification of the present code which purpose is to remove bug,
//  improve efficiency in both code execution and code reading or writing should be addressed
//  to the actual developper team.
//
//  Version history: (format "- date:contribution(contributor)") 
//  To Do List: (format "- proposition(percentage actually done)")
*/

#import <iTM2Foundation/iTM2TextStorageKit.h>
#import <iTM2Foundation/NSTextStorage_iTeXMac2.h>
#import <iTM2Foundation/iTM2ContextKit.h>
#import <iTM2Foundation/iTM2CursorKit.h>
#import <iTM2Foundation/iTM2BundleKit.h>
#import <iTM2Foundation/iTM2RuntimeBrowser.h>
#import <iTM2Foundation/ICURegEx.h>

#warning DEBUGGGGG
#undef __iTM2DebugEnabled__
//#define __iTM2DebugEnabled__

#undef _iTM2InternalAssert
#define _iTM2InternalAssert(CONDITION, REASON) if(!(CONDITION))[[NSException exceptionWithName:NSInternalInconsistencyException reason:REASON userInfo:nil] raise]

typedef struct
{
@defs(iTM2ModeLine)
} iTM2ModeLineDef;

NSString * const iTM2TextDefaultSyntaxModeName = @"default";// MUST BE LOWERCASE
NSString * const iTM2TextWhitePrefixSyntaxModeName = @"white prefix";// MUST BE LOWERCASE
NSString * const iTM2TextErrorSyntaxModeName = @"error";// MUST BE LOWERCASE TOO
NSString * const iTM2TextSelectionSyntaxModeName = @"selection";// MUST BE LOWERCASE TOO
NSString * const iTM2TextInsertionSyntaxModeName = @"insertion";// MUST BE LOWERCASE TOO
NSString * const iTM2TextBackgroundSyntaxModeName = @"background";// MUST BE LOWERCASE TOO
NSString * const iTM2TextModeAttributeName = @"iTM2Mode";
NSString * const iTM2NoBackgroundAttributeName = @"iTM2NoBackgroundAttribute";
NSString * const iTM2CursorIsWhiteAttributeName = @"iTM2CursorIsWhiteAttribute";
NSString * const iTM2TextDefaultStyle = @"default";// MUST BE LOWERCASE

// meta property key
NSString * const iTM2TextStyleKey = @"iTM2TextStyle";
NSString * const iTM2TextSyntaxParserVariantKey = @"iTM2TextSyntaxParserVariant";

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2TextStorageKit
/*"Class that defines a text storage and fixes attributes with respect to some syntax, more precisely TeX syntax and Log files syntax."*/

#define _TextStorage (iTM2TextStorage *)_TS
#define _TextModel (NSMutableString *)_Model
@interface iTM2ModeLine(diagnostic)
- (BOOL)diagnostic;
@end

#import <iTM2Foundation/iTM2TextDocumentKit.h>
#import <iTM2Foundation/iTM2InstallationKit.h>
#import <iTM2Foundation/iTM2Implementation.h>

NSString * const iTM2SyntaxParserStyleEnabledKey = @"iTM2SyntaxParserStyleEnabled";

@implementation iTM2MainInstaller(TextStorageKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2TextStorageCompleteInstallation
+ (void)iTM2TextStorageCompleteInstallation;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2: Mon Jun  7 21:48:56 GMT 2004
To Do List: Nothing
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[iTM2RuntimeBrowser swizzleInstanceMethodSelector:@selector(lazyTextStorage) replacement:@selector(iTM2_style_swizzled_lazyTextStorage) forClass:[iTM2TextInspector class]];
	[iTM2TextSyntaxParser class];
	[SUD registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:
		[NSNumber numberWithBool:YES], iTM2SyntaxParserStyleEnabledKey, nil]];
//iTM2_END;
    return;
}
@end

@implementation iTM2TextInspector(iTM2TextStorageKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2_style_swizzled_lazyTextStorage
- (id)iTM2_style_swizzled_lazyTextStorage;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_LOG(@"[self contextBoolForKey:iTM2SyntaxParserStyleEnabledKey domain:iTM2ContextAllDomainsMask]:%@", ([self contextBoolForKey:iTM2SyntaxParserStyleEnabledKey domain:iTM2ContextAllDomainsMask domain:iTM2ContextAllDomainsMask]? @"Y":@"N"));
	if([self contextBoolForKey:iTM2SyntaxParserStyleEnabledKey domain:iTM2ContextAllDomainsMask])
	{
		id result = [[[iTM2TextStorage allocWithZone:[self zone]] init] autorelease];
		NSString * style = [[self contextValueForKey:iTM2TextStyleKey domain:iTM2ContextAllDomainsMask] lowercaseString];
		NSString * variant = [[self contextValueForKey:iTM2TextSyntaxParserVariantKey domain:iTM2ContextAllDomainsMask] lowercaseString];
		NSEnumerator * E = [iTM2TextSyntaxParser syntaxParserClassEnumerator];
		Class C;
		while(C = [E nextObject])
		{
			if([[[C syntaxParserStyle] lowercaseString] isEqual:style])
			{
				if([[[iTM2TextSyntaxParser syntaxParserVariantsForStyle:style] allKeys]containsObject:variant])
				{
					[result setSyntaxParserStyle:style variant:variant];
					return result;
				}
				else if(iTM2DebugEnabled)
				{
					iTM2_LOG(@"variant %@ of style %@ is not in %@", variant, style, [iTM2TextSyntaxParser syntaxParserVariantsForStyle:style]);
				}
				
			}
		}
		return result;
	}
	return [self iTM2_style_swizzled_lazyTextStorage];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  textInspectorStyleCompleteSaveContext:
- (void)textInspectorStyleCompleteSaveContext:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id TS = [self textStorage];
	if([TS isKindOfClass:[iTM2TextStorage class]])
	{
		[self takeContextValue:[TS syntaxParserStyle] forKey:iTM2TextStyleKey domain:iTM2ContextAllDomainsMask];
		[self takeContextValue:[TS syntaxParserVariant] forKey:iTM2TextSyntaxParserVariantKey domain:iTM2ContextAllDomainsMask];
	}
//iTM2_END;
    return;
}
@end

@implementation NSAttributedString(iTM2Syntax)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= syntaxParser
- (id)syntaxParser;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (03/08/02)
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return nil;
}
@end

@interface NSTextStorage(PRIVATE)
// never ever call this method by yourself
// this is buggy in leopard and is called by NSTextFinder
- (unsigned)replaceString:(NSString *)old withString:(NSString *)new ranges:(NSArray *)ranges options:(unsigned)options inView:(id)view replacementRange:(NSRange)range;
@end

@implementation iTM2TextStorage
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= init
- (id)init;
/*"Designated initializer.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2: 12/05/2003
To Do List: Nothing
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(self = [super init])
    {
        _Model = (id)CFStringCreateMutableWithExternalCharactersNoCopy(kCFAllocatorDefault,nil,0,0,kCFAllocatorDefault);// force a 16 bits storage
        [self setSyntaxParserStyle:iTM2TextDefaultStyle variant:iTM2TextDefaultVariant];
    }
    return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= initWithString:
- (id)initWithString:(NSString *)aString;
/*"Designated initializer.
When no syntax parser is given, the layout is not invalidated and the attributes are not fixed.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2: 12/05/2003
To Do List: Nothing
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(self = [self init])
    {
        if(aString)
		{
            [self beginEditing];
            [self replaceCharactersInRange:NSMakeRange(0, 0) withString:aString];
            [self endEditing];
		}
    }
    return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= initWithString:attributes:
- (id)initWithString:(NSString *)aString attributes:(NSDictionary *)attrs;
/*"Designated initializer.
When no syntax parser is given, the layout is not invalidated and the attributes are not fixed.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2: 12/05/2003
To Do List: Nothing
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [self initWithString:aString];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= initWithAttributedString:
- (id)initWithAttributedString:(NSAttributedString *)attrStr;
/*"Designated initializer.
When no syntax parser is given, the layout is not invalidated and the attributes are not fixed.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2: 12/05/2003
To Do List: Nothing
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [self initWithString:[attrStr string]];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= dealloc
- (void)dealloc;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2: 12/05/2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [_Model autorelease];
    _Model = nil;
    [self setSyntaxParser:nil];
    [super dealloc];
//iTM2_END;
    return;
}
- (void)edited:(unsigned)editedMask range:(NSRange)range changeInLength:(int)delta;
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [super edited:(unsigned)editedMask range:(NSRange)range changeInLength:(int)delta];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= isEqualToAttributedString:
- (BOOL)isEqualToAttributedString:(NSAttributedString *)other;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2: 12/05/2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [_TextModel isEqualToString:[other string]];
}
- (void)beginEditing;
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [super beginEditing];
    return;
}
- (void)endEditing;
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [super endEditing];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  processEditing
- (void)processEditing;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [_SP textStorageWillProcessEditing];// is it necessary?
    [super processEditing];
    [_SP textStorageDidProcessEditing];// is it necessary?
    return;
}
#if 0
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  lineBreakBeforeIndex:withinRange:
- (unsigned)lineBreakBeforeIndex:(unsigned)location withinRange:(NSRange)aRange;
/*"Don't know if it is a bug of mine or apple's but sometimes the returned location has nothing to do with aRange.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [_TextModel lineBreakBeforeIndex:location withinRange:aRange];
}
#endif
#pragma mark =-=-=-=-=-=-=-=-=-=-  GETTING CHARACTERS
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= string
- (NSString *)string;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2: 12/05/2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return _TextModel;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= mutableString
- (NSMutableString *)mutableString;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2: 12/05/2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return _TextModel;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= attributedSubstringFromRange:
- (NSAttributedString *)attributedSubstringFromRange:(NSRange)range;
/*"Does nothing: no one should change the attributes except the receiver itself.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2: 12/05/2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [[[NSAttributedString allocWithZone:[self zone]] initWithString:[_TextModel substringWithRange:range]] autorelease];
}
#pragma mark =-=-=-=-=-=-=-=-=-=-  SETTING CHARACTERS
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= replaceCharactersInRange:withString:
- (void)replaceCharactersInRange:(NSRange)range withString:(NSString *)string;
/*"Relies on the shared syntax parser. May invalidate some range of characters if it was not easy or rapid to parse
the text for correct syntax coloring.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2: 12/05/2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//NSLog(@"%@", NSStringFromRange(range));
//NSLog(@"<%@>", string);
    if([_SP diagnostic])
    {
        iTM2_LOG(@"-+-+-+-+-+-+-+-+-+-+     BEFORE: BIG PROBLEM WITH <%@>", [self string]);
    }
#if 0
    if(range.length && [string length])
    {
        [self replaceCharactersInRange:range withString:@""];
        range.length = 0;
        [self replaceCharactersInRange:range withString:string];
        return;
    }
#endif
    unsigned originalLength = [_TextModel length];
    [_SP textStorageWillReplaceCharactersInRange:range withString:string];
    if([_SP diagnostic])
    {
        iTM2_LOG(@"-+-+-+-+-+-+-+-+-+-+     1: BIG PROBLEM WITH <%@>", [self string]);
    }
	// the next call will put the text storage in an inconsistent state
    [_TextModel replaceCharactersInRange:range withString:string];
	// now we have to synchronize
    unsigned stringLength = [string length];
	NSRange editedAttributesRange;// will receive the range where the attributes might have changed
    if(range.length && stringLength)
    {
        [_SP textStorageDidReplaceCharactersAtIndex:range.location count:range.length withCount:stringLength editedAttributesRangeIn:&editedAttributesRange];
        if(iTM2DebugEnabled > 999999)
        {
            iTM2_LOG(@"SOME CHARACTERS HAVE BEEN REPLACED");
            if([_SP diagnostic])
            {
                iTM2_LOG(@"-+-+-+-+-+-+-+-+-+-+     8-2-5: BIG PROBLEM");
            }
        }
        [self edited:NSTextStorageEditedCharacters range:range changeInLength:stringLength-range.length];
		[self invalidateAttributesInRange:editedAttributesRange];
        return;
    }
    unsigned newLength = [_TextModel length];
    if(!range.length)
    {
        if(stringLength == 1)
        {
            // the character at idx is the one added, the old ones have been shifted to the right
            [_SP textStorageDidInsertCharacterAtIndex:range.location editedAttributesRangeIn:&editedAttributesRange];
            if(iTM2DebugEnabled > 999999)
            {
                iTM2_LOG(@"ONE CHARACTER INSERTED %@", NSStringFromRange(range));
                if([_SP diagnostic])
                {
                    iTM2_LOG(@"-+-+-+-+-+-+-+-+-+-+     8-3: BIG PROBLEM");
                }
            }
			[self edited:NSTextStorageEditedCharacters range:range changeInLength:1];
			[self invalidateAttributesInRange:editedAttributesRange];
			return;
        }
        else if(stringLength)
        {
            [_SP textStorageDidInsertCharactersAtIndex:range.location count:stringLength editedAttributesRangeIn:&editedAttributesRange];
            if(iTM2DebugEnabled > 999999)
            {
                iTM2_LOG(@"CHARACTERS INSERTED %@", NSStringFromRange(range));
                if([_SP diagnostic])
                {
                    iTM2_LOG(@"-+-+-+-+-+-+-+-+-+-+     8-4: BIG PROBLEM");
                }
            }
        }
        // all other cases are void
    }
    else if(stringLength)
    {
        if(newLength > originalLength)
        {
            unsigned delta = newLength-originalLength;
            [_SP textStorageDidInsertCharactersAtIndex:range.location count:delta editedAttributesRangeIn:&editedAttributesRange];
			if(iTM2DebugEnabled > 999999)
			{
				iTM2_LOG(@"CHARACTERS INSERTED %@", NSStringFromRange(range));
				if([_SP diagnostic])
				{
					iTM2_LOG(@"-+-+-+-+-+-+-+-+-+-+     8-4: BIG PROBLEM");
				}
			}
        }
        else
        {
            unsigned delta = originalLength-newLength;
            if(delta == 1)
            {
                [_SP textStorageDidDeleteCharacterAtIndex:range.location editedAttributesRangeIn:&editedAttributesRange];
                if(iTM2DebugEnabled > 999999)
                {
                    iTM2_LOG(@"ONE CHARACTER DELETED %@", NSStringFromRange(range));
                    if([_SP diagnostic])
                    {
                        iTM2_LOG(@"-+-+-+-+-+-+-+-+-+-+     8-5: BIG PROBLEM");
                    }
                }
            }
            else if(delta)
            {
                [_SP textStorageDidDeleteCharactersAtIndex:range.location count:delta editedAttributesRangeIn:&editedAttributesRange];
                if(iTM2DebugEnabled > 999999)
                {
                    iTM2_LOG(@"CHARACTERS DELETED %@", NSStringFromRange(range));
                    if([_SP diagnostic])
                    {
                        iTM2_LOG(@"-+-+-+-+-+-+-+-+-+-+     8-6: BIG PROBLEM");
                    }
                }
            }
            else
            {
//                NSLog(@"NO CHANGE IN LENGTH, JUST A REPLACEMENT %@", NSStringFromRange(range));
                [_SP invalidateModesForCharacterRange:range editedAttributesRangeIn:&editedAttributesRange];
                if(iTM2DebugEnabled > 999999)
                {
                    iTM2_LOG(@"NO CHANGE IN LENGTH, JUST A REPLACEMENT %@", NSStringFromRange(range));
                    if([_SP diagnostic])
                    {
                        iTM2_LOG(@"-+-+-+-+-+-+-+-+-+-+     8-7: BIG PROBLEM");
                    }
                }
            }
        }
    }
    else if(range.length == 1)
    {
        [_SP textStorageDidDeleteCharacterAtIndex:range.location editedAttributesRangeIn:&editedAttributesRange];
        if(iTM2DebugEnabled > 999999)
        {
            iTM2_LOG(@"A CHARACTER HAS BEEN DELETED");
            if([_SP diagnostic])
            {
                iTM2_LOG(@"-+-+-+-+-+-+-+-+-+-+     8-8: BIG PROBLEM");
            }
        }
    }
    else
    {
        [_SP textStorageDidDeleteCharactersAtIndex:range.location count:range.length editedAttributesRangeIn:&editedAttributesRange];
        if(iTM2DebugEnabled > 999999)
        {
            iTM2_LOG(@"MANY CHARACTERS HAVE BEEN DELETED");
            if([_SP diagnostic])
            {
                iTM2_LOG(@"-+-+-+-+-+-+-+-+-+-+     8-9: BIG PROBLEM");
            }
        }
    }
//NSLog(@"%@", _TextModel);
    if([_SP diagnostic])
    {
        iTM2_LOG(@"-+-+-+-+-+-+-+-+-+-+     9: BIG PROBLEM WITH <%@>", [self string]);
    }
	[self edited:NSTextStorageEditedCharacters range:range changeInLength:newLength-originalLength];
	[self invalidateAttributesInRange:editedAttributesRange];
    if([_SP diagnostic])
    {
        iTM2_LOG(@"-+-+-+-+-+-+-+-+-+-+     AFTER: BIG PROBLEM WITH <%@>", [self string]);
    }
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= replaceCharactersInRange:withAttributedString:
- (void)replaceCharactersInRange:(NSRange)range withAttributedString:(NSAttributedString *)attributedString;
/*"Attribute changes are catched.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2: 12/05/2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * string = [attributedString string];
	[self replaceCharactersInRange:range withString:string];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= replaceString:withString:ranges:options:inView:replacementRange:
- (unsigned)replaceString:(NSString *)old withString:(NSString *)new ranges:(NSArray *)ranges options:(unsigned)options inView:(id)view replacementRange:(NSRange)range;
/*"Attribute changes are catched.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2: 12/05/2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([SUD boolForKey:@"iTM2DontPatchNSTextStorageReplaceString"])
	{
		return [super replaceString:(NSString *)old withString:(NSString *)new ranges:(NSArray *)ranges options:(unsigned)options inView:(id)view replacementRange:(NSRange)range];
	}
	iTM2_INIT_POOL;
	NSMutableDictionary * map = [NSMutableDictionary dictionary];
	unsigned flags = ICUREMultilineOption;
	if(options & 1)
	{
		flags |= ICURECaseSensitiveOption;
	}
	NSMutableString * pattern = [NSMutableString string];
	if(options & 1<<16 || options & 1<<17)
	{
		[pattern appendString:@"\\b"];
	}
	unsigned end, contentsEnd;
	NSRange R = NSMakeRange(0,0);
	if(R.location<[old length])
	{
		[old getLineStart:nil end:&end contentsEnd:&contentsEnd forRange:R];
		R.length = contentsEnd-R.location;
		[pattern appendString:[[old substringWithRange:R] stringByEscapingICUREControlCharacters]];
		R.location = end;
		while(R.location<[old length])
		{
			R.length = 0;
			[old getLineStart:nil end:&end contentsEnd:&contentsEnd forRange:R];
			R.length = contentsEnd-R.location;
			[pattern appendString:@"$.^"];
			[pattern appendString:[[old substringWithRange:R] stringByEscapingICUREControlCharacters]];
			R.location = end;
		}
	}
	if(options & 1<<17)
	{
		[pattern appendString:@"\\b"];
	}
	NSString * myString = [self string];
	NSRange myRange = NSMakeRange(0,[myString length]);
	ICURegEx * RE = [[[ICURegEx alloc] initWithSearchPattern:pattern options:flags error:nil] autorelease];
	NSMutableString * replacementPattern = [NSMutableString stringWithString:new];
	[replacementPattern replaceOccurrencesOfString:@"\\" withString:@"\\\\" options:0 range:NSMakeRange(0,[new length])];
	[replacementPattern replaceOccurrencesOfString:@"$" withString:@"\\$" options:0 range:NSMakeRange(0,[new length])];
	[RE setReplacementPattern:replacementPattern];
	NSEnumerator * E = [ranges objectEnumerator];
	NSValue * V;
	while(V = [E nextObject])
	{
		R = [V rangeValue];// V is free now
		R = NSIntersectionRange(R,myRange);
		if(R.length)
		{
			[RE setInputString:myString range:R];
			while([RE nextMatch])
			{
				[map setObject:[RE replacementString] forKey:[NSValue valueWithRange:[RE rangeOfMatch]]];
			}
		}
	}
	NSArray * affectedRanges = [[map allKeys] sortedArrayUsingSelector:@selector(iTM2_compareRangeLocation:)];
	E = [affectedRanges objectEnumerator];
	NSMutableArray * replacementStrings = [NSMutableArray array];
	while(V = [E nextObject])
	{
		[replacementStrings addObject:[map objectForKey:V]];
	}
	unsigned result = 0;
	if([affectedRanges count] && [view shouldChangeTextInRanges:affectedRanges replacementStrings:replacementStrings])
	{
		[self beginEditing];
		E = [affectedRanges reverseObjectEnumerator];
		NSEnumerator * EE = [replacementStrings reverseObjectEnumerator];
		while(V = [E nextObject])
		{
			[self replaceCharactersInRange:[V rangeValue] withString:[EE nextObject]];
		}
		[self endEditing];
		result = [affectedRanges count];
	}
	iTM2_RELEASE_POOL;
//iTM2_END;
    return result;
}
#pragma mark =-=-=-=-=-=-=-=-=-=-  GETTING ATTRIBUTES
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= attributesAtIndex:effectiveRange:
- (NSDictionary *)attributesAtIndex:(unsigned)aLocation effectiveRange:(NSRangePointer)aRangePtr;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2: 12/05/2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	// there is a bug: iinfinite loop because the appkit askes for an attribute beyond the limit
    if(iTM2DebugEnabled > 1000 && (aLocation >= [_TextModel length]))
    {
		iTM2_LOG(@"idx: %u (%u)", aLocation, [_TextModel length]);
    }
    [self ensureAttributesAreFixedInRange:NSMakeRange(aLocation, MIN(1, [_TextModel length]-aLocation))];
	if(_SP)
		return [_SP attributesAtIndex:aLocation effectiveRange:aRangePtr];
	if(aRangePtr)
		*aRangePtr = NSMakeRange(aLocation, [_TextModel length]-aLocation);
	return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= attributesAtIndex:effectiveRange:inRange:
- (NSDictionary *)attributesAtIndex:(unsigned)aLocation longestEffectiveRange:(NSRangePointer)aRangePtr inRange:(NSRange)aRangeLimit;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2: 12/05/2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	unsigned length = [_TextModel length];
    if(iTM2DebugEnabled > 1000 && (aLocation >= length))
    {
		iTM2_LOG(@"idx: %u (%u)", aLocation, length);
    }
    [self ensureAttributesAreFixedInRange:NSMakeRange(aLocation, MIN(1, length-aLocation))];
	NSRange R;
	if(_SP)
	{
		id attributes = [_SP attributesAtIndex:aLocation longestEffectiveRange:aRangePtr inRange:aRangeLimit];
		if(aRangePtr && aRangePtr->length==0 && aLocation < length)
		{
			R = NSMakeRange(aLocation, length-aLocation);
			*aRangePtr = R;
			R.length = MIN(R.length,30);
			iTM2_LOG(@"***  ERROR: 0 length atribute range at %@",[_TextModel substringWithRange:R]);
		}
		return attributes;
	}
	if(aRangePtr)
	{
		R = NSMakeRange(aLocation, length-aLocation);
		*aRangePtr = R;
	}
	return nil;
}
#pragma mark =-=-=-=-=-=-=-=-=-=-  SETTING ATTRIBUTES
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= setAttributes:range:
- (void)setAttributes:(NSDictionary *)attributes range:(NSRange)aRange;
/*"Does nothing: no one should change the attributes except the receiver itself.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2: 12/05/2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([_ACD methodSignatureForSelector:@selector(textStorage:wouldSetAttributes:range:)])
	{
		[_ACD textStorage:self wouldSetAttributes:attributes range:aRange];
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= addAttribute:value:range:
- (void)addAttribute:(NSString *)name value:(id)value range:(NSRange)range;
/*"Does nothing: no one should change the attributes except the receiver itself.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2: 12/05/2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	if([_ACD methodSignatureForSelector:@selector(textStorage:wouldAddAttribute:value:range:)])
	{
		[_ACD textStorage:self wouldAddAttribute:name value:value range:range];
	}
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= attributesChangeDelegate
- (id)attributesChangeDelegate;
/*"Does nothing: no one should change the attributes except the receiver itself.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2: 12/05/2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return _ACD;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= setAttributesChangeDelegate:
- (void)setAttributesChangeDelegate:(id)delegate;
/*"Does nothing: no one should change the attributes except the receiver itself.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2: 12/05/2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	_ACD = delegate;
//iTM2_END;
    return;
}
#pragma mark =-=-=-=-=-=-=-=-=-=-  SYNTAX COLORING
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= fixesAttributesLazily
- (BOOL)fixesAttributesLazily;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2: 12/05/2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return YES;
}
#if 1
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= ensureAttributesAreFixedInRange:
- (void)ensureAttributesAreFixedInRange:(NSRange)range;
/*"Description forthcoming. Bypass the inherited method.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2: 12/05/2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(range.length)
        [_SP fixSyntaxModesInRange:range];
//iTM2_END;
    return;
}
#endif
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= syntaxParser
- (id)syntaxParser;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (03/08/02)
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return _SP;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= replaceSyntaxParser:
- (void)replaceSyntaxParser:(id)argument;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (11/07/01)
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(_SP != argument)
    {
        if(iTM2DebugEnabled>500)
        {
            iTM2_LOG(@"The new syntax style is: %@ with parser: %@", [[_SP class] syntaxParserStyle], _SP);
        }
        [self setSyntaxParser:argument];
        [argument setTextStorage:self];
        [_SP setUpAllTextViews];
        if(iTM2DebugEnabled>500)
        {
            iTM2_LOG(@"The new syntax style is: %@ with parser: %@", [[_SP class] syntaxParserStyle], _SP);
        }
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  addLayoutManager:
- (void)addLayoutManager:(NSLayoutManager *)obj;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (11/07/01)
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [super addLayoutManager:obj];
    NSEnumerator * E2 = [[obj textContainers] objectEnumerator];
    NSTextContainer * TC2;
    while(TC2 = [E2 nextObject])
        [_SP setUpTextView:[TC2 textView]];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= setSyntaxParser:
- (void)setSyntaxParser:(id)argument;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (11/07/01)
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(argument && ![argument isKindOfClass:[iTM2TextSyntaxParser class]])
        [NSException raise:NSInvalidArgumentException
            format: @"%@ iTM2SyntaxParser argument expected: %@.",
                __iTM2_PRETTY_FUNCTION__, argument];
    else
    {
        [_SP autorelease];
        _SP = [argument retain];
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setSyntaxParserStyle:variant:
- (void)setSyntaxParserStyle:(NSString *)style variant:(NSString *)variant;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self replaceSyntaxParser:[iTM2TextSyntaxParser syntaxParserWithStyle:style variant:variant]];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  replaceSyntaxParserStyle:variant:
- (void)replaceSyntaxParserStyle:(NSString *)style variant:(NSString *)variant;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self setSyntaxParserStyle:style variant:variant];
    [self takeContextValue:style forKey:iTM2TextStyleKey domain:iTM2ContextAllDomainsMask];
    [self takeContextValue:variant forKey:iTM2TextSyntaxParserVariantKey domain:iTM2ContextAllDomainsMask];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= invalidateAttributesInRange:
- (void)invalidateAttributesInRange:(NSRange)range;
/*"Bypass the inherited method.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2: 12/05/2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  fixAttributesInRange:
- (void)fixAttributesInRange:(NSRange)aRange;
/*"Description forthcoming.
Version history: 
- 1.1: 05/22/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//NSLog(NSStringFromRange(aRange));
    [_SP fixSyntaxModesInRange:aRange];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  syntaxParserStyle
- (NSString *)syntaxParserStyle;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [[[self syntaxParser] class] syntaxParserStyle];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  syntaxParserVariant
- (NSString *)syntaxParserVariant;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [[self syntaxParser] syntaxParserVariant];
}
#pragma mark =-=-=-=-=-=-=-=-=-=-  CONTEXT
#warning THERE MUST BE SOMETHING DESIGNED TO CASCADE A CHANGE IN THE CONTEXT
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  contextDidChange
- (void)xcontextDidChange;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Sun Oct  3 07:38:23 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[super contextDidChange];
    [self setSyntaxParserStyle:[self contextValueForKey:iTM2TextStyleKey domain:iTM2ContextAllDomainsMask]
            variant: [self contextValueForKey:iTM2TextSyntaxParserVariantKey domain:iTM2ContextAllDomainsMask]];
	[self contextDidChangeComplete];
//iTM2_END;
    return;
}
#pragma mark =-=-=-=-=-=-=-=-=-=-  INDEXING
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= lineIndexForLocation:
- (unsigned int)lineIndexForLocation:(unsigned)index;
/*"Given a range, it returns the line number of the first char of the range.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: improve the search avoiding the whole scan of the string, refer to the midle of the string or to the first visible character.
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	iTM2TextSyntaxParser * TSP = [self syntaxParser];
	return TSP?[TSP lineIndexForLocation:index]:[super lineIndexForLocation:index];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= getLineStart:end:contentsEnd:forRange:
- (void)getLineStart:(unsigned *)startPtr end:(unsigned *)lineEndPtr contentsEnd:(unsigned *)contentsEndPtr forRange:(NSRange)range;
/*"Given a range, it returns the line number of the first char of the range.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: improve the search avoiding the whole scan of the string, refer to the midle of the string or to the first visible character.
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	iTM2TextSyntaxParser * TSP = [self syntaxParser];
	if(!TSP)
	{
		[super getLineStart:startPtr end:lineEndPtr contentsEnd:contentsEndPtr forRange:range];
		return;
	}
	unsigned start = range.location;
	unsigned stop = NSMaxRange(range);
	unsigned index;
	iTM2ModeLine * ML = nil;
	if(startPtr)
	{
		index = [TSP lineIndexForLocation:start];
		ML = [TSP modeLineAtIndex:index];
		*startPtr = [ML startOffset];
		if(lineEndPtr || contentsEndPtr)
		{
			if(stop<=[ML endOffset])
			{
conclude:
				if(lineEndPtr)
				{
					*lineEndPtr = [ML endOffset];
				}
				if(contentsEndPtr)
				{
					*contentsEndPtr = [ML contentsEndOffset];
				}
				return;
			}
			index = [TSP lineIndexForLocation:stop];
			ML = [TSP modeLineAtIndex:index];
			if(stop==[ML startOffset])
			{
				--index;
				ML = [TSP modeLineAtIndex:index];
			}
			goto conclude;
		}
	}
	if(lineEndPtr || contentsEndPtr)
	{
		index = [TSP lineIndexForLocation:stop];
		ML = [TSP modeLineAtIndex:index];
		if((stop == [ML startOffset])
			&& (start<stop))
		{
			--index;
			ML = [TSP modeLineAtIndex:index];
		}
		goto conclude;
	}
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= getRangeForLine:
- (NSRange)getRangeForLine:(unsigned int)aLine;
/*"Given a 1 based line number, it returns the line range including the ending characters.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	iTM2TextSyntaxParser * TSP = [self syntaxParser];
	if(!TSP)
	{
		return [super getRangeForLine:aLine];
	}
	iTM2ModeLine * ML = [TSP modeLineAtIndex:aLine];
	unsigned start = [ML startOffset];
	unsigned end = [ML endOffset];
	return NSMakeRange(start,end-start);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= getRangeForLineRange:
- (NSRange)getRangeForLineRange:(NSRange)aLineRange;
/*"Given a line range number, it returns the range including the ending characters.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	iTM2TextSyntaxParser * TSP = [self syntaxParser];
	if(!TSP)
	{
		return [super getRangeForLineRange:aLineRange];
	}
	iTM2ModeLine * ML = [TSP modeLineAtIndex:aLineRange.location];
	unsigned start = [ML startOffset];
	if(aLineRange.length>1)
	{
		aLineRange.location += aLineRange.length-1;
		ML = [TSP modeLineAtIndex:aLineRange.location];
	}
	unsigned end = [ML endOffset];
	return NSMakeRange(start,end-start);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= didClickOnLink:atIndex:
- (BOOL)didClickOnLink:(id)link atIndex:(unsigned)charIndex;
/*"Given a line range number, it returns the range including the ending characters.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	return [_SP didClickOnLink:link atIndex:charIndex];
}
@end

NSString * const iTM2TextSyntaxParserType = @"_SPC";

#import <iTM2Foundation/iTM2ObjectServer.h>
#import <iTM2Foundation/iTM2NotificationKit.h>
#import <objc/objc-class.h>

/*
	@class		_iTM2TextObjectServer
	@abstract	Private object server
	@discussion	This object stores the attributes servers.
				Many text storage can share the same attributes server.
				Here is the design
				text storage <-> syntax parser <-> attributes server
				The text storage is associated to one syntax parser defined by its style.
				The syntax parser is associated to one attributes server, with the same style,
				defined by a variant.
				The same attributes server can be shared by different syntax parsers.
				The _iTM2TextObjectServer stores these shared instances.
*/
@interface _iTM2TextObjectServer: iTM2ObjectServer
+ (void)update;
@end
@implementation _iTM2TextObjectServer
static NSMutableDictionary * _iTM2TextObjectServerDictionary = nil;
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initialize
+ (void)initialize;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
    iTM2_INIT_POOL;
//iTM2_START;
    [super initialize];
    if(!_iTM2TextObjectServerDictionary)
	{
		[_iTM2TextObjectServerDictionary autorelease];
		_iTM2TextObjectServerDictionary = [[NSMutableDictionary dictionary] retain];
		[INC addObserver:self selector:@selector(bundleDidLoadNotified:) name:iTM2BundleDidLoadNotification object:nil];
		[self update];
	}
//iTM2_END;
	iTM2_RELEASE_POOL;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  mutableDictionary
+ (NSMutableDictionary *)mutableDictionary;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return _iTM2TextObjectServerDictionary;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  bundleDidLoadNotified:
+ (void)bundleDidLoadNotified:(NSNotification *)notification;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(update) object:nil];
	[self performSelector:@selector(update) withObject:nil afterDelay:0];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  update
+ (void)update;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	Class C = [iTM2TextSyntaxParser class];
	NSString * style = [[C syntaxParserStyle] lowercaseString];
	if([style length])// the type and the modes must have a length!!!
	{
//iTM2_LOG(@"style: %@", style);
		[self registerObject:C forType:iTM2TextSyntaxParserType key:style retain:NO];
	}
    NSArray * references = [iTM2RuntimeBrowser subclassReferencesOfClass:C];
//iTM2_LOG(@"There are currently %i subclasses of iTM2TextSyntaxParser", [references count]);
	NSEnumerator * E = [references objectEnumerator];
	while(C = (Class) [[E nextObject] nonretainedObjectValue])
	{
//iTM2_LOG(@"Registering syntax parser: %@", NSStringFromClass(C));
        style = [[C syntaxParserStyle] lowercaseString];
        if([style length])// the type and the modes must have a length!!!
        {
//iTM2_LOG(@"style: %@", style);
            [self registerObject:C forType:iTM2TextSyntaxParserType key:style retain:NO];
        }
	}
//iTM2_END;
    return;
}
@end

@interface iTM2TextSyntaxParser(PRIVATE)
- (unsigned int)xlineIndexForLocation:(unsigned)location;
@end

@implementation iTM2TextSyntaxParser
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= attributesServerClass
+ (Class)attributesServerClass;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSString * name = [NSStringFromClass(self) stringByAppendingString:@"AttributesServer"];
    Class result = NSClassFromString(name);
    if(result)
        return result;
    else if([[self superclass] respondsToSelector:_cmd])
        return [[self superclass] attributesServerClass];
    iTM2_LOG(@"A class named %@ must be implemented", name);
    return Nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  syntaxParserClassForStyle:
+ (id)syntaxParserClassForStyle:(NSString *)style;
/*"The default implementation does nothing visible, subclassers will append or prepend their own stuff.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    style = [style lowercaseString];
    id result = Nil;
    next:
    if(result = [_iTM2TextObjectServer objectForType:iTM2TextSyntaxParserType key:style])
        return result;
    if([[style pathExtension] length])
    {
        style = [style stringByDeletingPathExtension];
        goto next;
    }
    result = [_iTM2TextObjectServer objectForType:iTM2TextSyntaxParserType key:iTM2TextDefaultStyle];
    if(!result)
    {
        // don't remove the {} group due to the definition of iTM2_LOG
        iTM2_LOG(@"INCONSISTENCY, a \"%@\" style is missing", iTM2TextDefaultStyle);
    }
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  syntaxParserWithStyle:variant:
+ (id)syntaxParserWithStyle:(NSString *)style variant:(NSString *)variant;
/*"The default implementation does nothing visible, subclassers will append or prepend their own stuff.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    style = [style lowercaseString];
    variant = [variant lowercaseString];
    id AS = [self attributesServerWithStyle:style variant:variant];
    Class C = [self syntaxParserClassForStyle:style];
    id result = [[[C alloc] init] autorelease];
    [result replaceAttributesServer:AS];
    return result;

}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  syntaxParserClassEnumerator
+ (NSEnumerator *)syntaxParserClassEnumerator;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [_iTM2TextObjectServer objectEnumeratorForType:iTM2TextSyntaxParserType];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  syntaxParserStyle
+ (NSString *)syntaxParserStyle;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return iTM2TextDefaultStyle;
}
#pragma mark =-=-=-=-=-=-=-=-=-=-  CONSTRUCTOR
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= init
- (id)init;
/*"Designated initializer.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2: 12/05/2003
To Do List: Nothing
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(self = [super init])
    {
        [INC addObserver:self
            selector: @selector(syntaxAttributesDidChangeNotified:)
                name: iTM2TextAttributesDidChangeNotification object: nil];
		_PreviousLineIndex = 0;
		_PreviousLocation = 0;
	}
    return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  dealloc
- (void)dealloc;
/*"The default implementation does nothing visible, subclassers will append or prepend their own stuff.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [INC removeObserver:self];
    _TS = nil;
    _AS = nil;
    [_ModeLines autorelease];
    _ModeLines = nil;
    [super dealloc];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  diagnostic
- (BOOL)diagnostic;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(iTM2DebugEnabled < 9999)
		return NO;
    NSString * S = [_TextStorage string];
    unsigned numberOfModeLines = [self numberOfModeLines];
	BOOL toJail = NO;
	if(numberOfModeLines)
	{
		unsigned end, contentsEnd;
		unsigned modeLineIndex = 0;
		NSRange R = NSMakeRange(0, 0);
		iTM2ModeLine * modeLine = [self modeLineAtIndex:modeLineIndex];
testNextLine:
		[S getLineStart:nil end:&end contentsEnd:&contentsEnd forRange:R];
		if(modeLineIndex < _BadOffsetIndex)
		{
			if([modeLine startOffset] != R.location)
			{
				iTM2_LOG(@"!!!!!!!!!!!!!!  Bad offset at modeLineIndex: %u (got %u instead of %u)",
					modeLineIndex, [modeLine startOffset], R.location);
				toJail = YES;
			}
			if([modeLine contentsEndOffset] != contentsEnd)
			{
				iTM2_LOG(@"!!!!!!!!!!!!!!  Bad contents offset at modeLineIndex: %u (got %u instead of %u)",
					modeLineIndex, [modeLine contentsEndOffset], contentsEnd);
				toJail = YES;
			}
			if([modeLine endOffset] != end)
			{
				iTM2_LOG(@"!!!!!!!!!!!!!!  Bad next offset at modeLineIndex: %u (got %u instead of %u)",
					modeLineIndex, [modeLine endOffset], end);
				toJail = YES;
			}
		}
		if([modeLine contentsLength] != contentsEnd-R.location)
		{
			iTM2_LOG(@"!!!!!!!!!!!!!!  Bad contentsLength at modeLineIndex: %u (got %u instead of %u)",
				modeLineIndex, [modeLine contentsLength], contentsEnd-R.location);
			toJail = YES;
		}
		if([modeLine EOLLength] != end-contentsEnd)
		{
			iTM2_LOG(@"!!!!!!!!!!!!!!  Bad eol length at modeLineIndex: %u (got %u instead of %u)",
				modeLineIndex, [modeLine EOLLength], end-contentsEnd);
			toJail = YES;
		}
		if([modeLine length] != end-R.location)
		{
			iTM2_LOG(@"!!!!!!!!!!!!!!  Bad length at modeLineIndex: %u (got %u instead of %u)",
				modeLineIndex, [modeLine length], end-R.location);
			toJail = YES;
		}
		if([modeLine invalidLocalRange].length
			&& ([modeLine invalidLocalRange].location<[modeLine contentsLength])
				&& (modeLineIndex < _BadModeIndex))
		{
			iTM2_LOG(@"!!!!!!!!!!!!!!  Invalid mode line with valid mode index");
			toJail = YES;
		}
		if([modeLine diagnostic])
		{
			iTM2_LOG(@"!!!!!!!!!!!!!!  BAD MODE LINE AT INDEX: %u", modeLineIndex);
			toJail = YES;
		}
		R.location = end;
		if(contentsEnd < end)
		{
			// we MUST have a new mode line
			if(++modeLineIndex<numberOfModeLines)
			{
				modeLine = [self modeLineAtIndex:modeLineIndex];
				goto testNextLine;
			}
			else
			{
				iTM2_LOG(@"!!!!!!!!!!!!!!  MISSING MODE LINE");
				toJail = YES;
			}
		}
		else
		{
			// this is a non eol string: this must be the last one
			if(++modeLineIndex<numberOfModeLines)
			{
				iTM2_LOG(@"!!!!!!!!!!!!!!  TOO MANY MODE LINES");
				toJail = YES;
			}
		}
	}
	else
	{
		iTM2_LOG(@"!!!!!!!!!!!!!!  THERE MUST BE AT LEAST ONE MODE LINE...");
		toJail = YES;
	}
//iTM2_END;
    if(toJail)
	{
		NSLog(@"There are actually %u lines", numberOfModeLines);
		NSLog(@"BadOffsetIndex %u", _BadOffsetIndex);
		NSLog(@"BadModeIndex %u", _BadModeIndex);
	}
//iTM2_END;
    return toJail;
}
#pragma mark =-=-=-=-=-=-=-=-=-=-  SETTER/GETTER
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  attributesServer
- (id)attributesServer;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return _AS;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  replaceAttributesServer:
- (void)replaceAttributesServer:(iTM2TextSyntaxParserAttributesServer *)argument;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(_AS != argument)
    {
        _AS = argument;// NOT RETAINED
        if(_AS)
            [self setUpAllTextViews];
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  syntaxParserVariant
- (NSString *)syntaxParserVariant;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [_AS syntaxParserVariant];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  textStorage
- (id)textStorage;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return _TS;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setTextStorage:
- (void)setTextStorage:(id)argument;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(_TS != argument)
    {
        _TS = argument;// NOT RETAINED
        [self textStorageDidChange];
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  textStorageDidChange
- (void)textStorageDidChange;
/*"The default implementation does nothing visible, subclassers will append or prepend their own stuff.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSString * S = [_TextStorage string];
    [_ModeLines release];
    _ModeLines = [[NSMutableArray array] retain];
	_PreviousLineIndex = 0;
	_PreviousLocation = 0;
    if(S)
    {
//iTM2_LOG(@"S is: <%@>", S);
        iTM2ModeLine * modeLine;
        unsigned end, contentsEnd;
        NSRange R = NSMakeRange(0, 0);
RoseRouge:
        modeLine = [iTM2ModeLine modeLine];
        [modeLine setStartOffset:R.location];
		[_ModeLines addObject:modeLine];
		if(R.location < [S length])
		{
			[S getLineStart:nil end:&end contentsEnd:&contentsEnd forRange:R];
#ifdef __ELEPHANT_MODELINE__
#warning ELEPHANT MODE: For debugging purpose only... see iTM2TextStorageKit.h
			[modeLine->originalString release];
			modeLine->originalString = [[S substringWithRange:NSMakeRange(R.location, end-R.location)] retain];
			if(iTM2DebugEnabled>9999) iTM2_LOG(modeLine->originalString);
#endif
			if(R.location < contentsEnd)
				[modeLine appendSyntaxMode:kiTM2TextUnknownSyntaxMode length:contentsEnd-R.location];
			if(contentsEnd < end)
			{
				[modeLine setEOLLength:end-contentsEnd];
				R.location = end;
				goto RoseRouge;
			}
		}
    }
    else if(iTM2DebugEnabled > 999999)
    {
        iTM2_LOG(@"The text storage has no string, very weird situation isn't it? maybe causing bugs...");
    }
    [self validateOffsetsUpTo:UINT_MAX];
    [self invalidateModesFrom:0];
	[[_ModeLines objectAtIndex:0] setPreviousMode:kiTM2TextRegularSyntaxMode];// the first line must always have a regular previous mode
//iTM2_LOG(@"The number of lines in this text is: [self numberOfModeLines]:%u", [self numberOfModeLines]);
	if([self diagnostic])
    {
        iTM2_LOG(@"********\n\n\nBIG STARTING PROBLEM WITH <%@>\n\n\n", [[self textStorage] string]);
    }
    else if(iTM2DebugEnabled)
    {
        iTM2_LOG(@"********\n\n\n     STARTING SEEMS ABSOLUTELY PERFECT....");
        [[_ModeLines objectAtIndex:0] describe];
    }
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= setAttributes:range:
- (void)setAttributes:(NSDictionary *)attributes range:(NSRange)range;
/*"Does nothing: no one should change the attributes except the receiver itself.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2: 12/05/2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= addAttribute:value:range:
- (void)addAttribute:(NSString *)name value:(id)value range:(NSRange)range;
/*"Does nothing: no one should change the attributes except the receiver itself.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2: 12/05/2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return;
}
#pragma mark =-=-=-=-=-=-=-=-=-=-  TEXTVIEW
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setUpAllTextViews
- (void)setUpAllTextViews;
/*"The default implementation does nothing visible, subclassers will append or prepend their own stuff.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_LOG(@"TV: %@", TV);
    NSEnumerator * E1 = [[[self textStorage] layoutManagers] objectEnumerator];
    NSLayoutManager * LM1;
    while(LM1 = [E1 nextObject])
    {
        NSEnumerator * E2 = [[LM1 textContainers] objectEnumerator];
        NSTextContainer * TC2;
        while(TC2 = [E2 nextObject])
            [self setUpTextView:[TC2 textView]];
    }
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setUpTextView:
- (void)setUpTextView:(NSTextView *)TV;
/*"The default implementation does nothing visible, subclassers will append or prepend their own stuff.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_LOG(@"TV: %@", TV);
	iTM2TextStorage * TS = (iTM2TextStorage *)[self textStorage];
	id ACD = [TS attributesChangeDelegate];
	[TS setAttributesChangeDelegate:nil];
	//iTM2TextSyntaxParser * SP = [TS syntaxParser];
	NSRange charRange = NSMakeRange(0, [[TV string] length]);
	NSDictionary * attributes = [_AS attributesForMode:iTM2TextDefaultSyntaxModeName];
	NSColor * foreColor = [attributes objectForKey:NSForegroundColorAttributeName];
	attributes = [_AS attributesForMode:iTM2TextSelectionSyntaxModeName];
	NSColor * insertionColor = [[_AS attributesForMode:iTM2TextInsertionSyntaxModeName]
										objectForKey: NSForegroundColorAttributeName];
	NSDictionary * background = [_AS attributesForMode:iTM2TextBackgroundSyntaxModeName];
	BOOL drawsBackground = ![[background objectForKey:iTM2NoBackgroundAttributeName] boolValue];
	BOOL cursorIsWhite = [[background objectForKey:iTM2CursorIsWhiteAttributeName] boolValue];
	if([[TV string] length])// unless infinite loop
		[TV setTextColor:(foreColor?:[NSColor textColor])];
//iTM2_LOG(@"old [TV selectedTextAttributes] are:%@", [TV selectedTextAttributes]);
	NSMutableDictionary * MD = [NSMutableDictionary  dictionaryWithDictionary:[TV selectedTextAttributes]];
	[MD setObject:[NSColor selectedTextColor] forKey:NSForegroundColorAttributeName];
	[MD setObject:[NSColor selectedTextBackgroundColor] forKey:NSBackgroundColorAttributeName];
	if(attributes)
		[MD addEntriesFromDictionary:attributes];
	[TV setSelectedTextAttributes:MD];
//iTM2_LOG(@"[TV selectedTextAttributes] are:%@", [TV selectedTextAttributes]);
	[TV setInsertionPointColor:(insertionColor?:[NSColor textColor])];
	[TV setDrawsBackground:drawsBackground];
//iTM2_LOG(@"[TV drawsBackground] is:%@", ([TV drawsBackground]? @"Y":@"N"));
	NSColor *  backgroundColor = [background objectForKey:NSBackgroundColorAttributeName]?:
		[NSColor textBackgroundColor];
	NSScrollView * SV = [TV enclosingScrollView];
	[SV setDrawsBackground:NO];
	NSColor * enclosingBackgroundColor = [SV drawsBackground]? [SV backgroundColor]:[NSColor windowFrameColor];
	NSColor * blendedColor = [[backgroundColor colorWithAlphaComponent:1]
					blendedColorWithFraction: 1-[backgroundColor alphaComponent]
								ofColor: enclosingBackgroundColor];
	[TV setBackgroundColor:(blendedColor? blendedColor:backgroundColor)];
//iTM2_LOG(@"backgroundColor is: %@, [backgroundColor alphaComponent] is:%f", backgroundColor, [backgroundColor alphaComponent]);
//iTM2_LOG(@"enclosingBackgroundColor is: %@", enclosingBackgroundColor);
//iTM2_LOG(@"blended Color is: %@", [[backgroundColor colorWithAlphaComponent:1] blendedColorWithFraction:1-[backgroundColor alphaComponent] ofColor:enclosingBackgroundColor]);
//iTM2_LOG(@"[TV drawsBackground] is:%@", ([TV drawsBackground]? @"Y":@"N"));
	[TV setNeedsDisplay:YES];
	 NSClipView * CV = (NSClipView *)[SV contentView];
	[CV setDocumentCursor:(cursorIsWhite? [NSCursor whiteIBeamCursor]:[NSCursor IBeamCursor])];
	[CV setBackgroundColor:(blendedColor? blendedColor:backgroundColor)];
	[CV setNeedsDisplay:YES];
	// ending by the layout manager
	NSLayoutManager * LM = [TV layoutManager];
	[LM invalidateDisplayForCharacterRange:charRange];
	#if 1
	NS_DURING
	{// this is a block
		charRange.length = [LM firstUnlaidCharacterIndex];
		[LM invalidateGlyphsForCharacterRange:charRange changeInLength:0 actualCharacterRange:nil];
		[LM invalidateLayoutForCharacterRange:charRange isSoft:NO actualCharacterRange:nil];
	}
	NS_HANDLER
	{
		iTM2DebugEnabled = 10000;
		iTM2TextStorage * TS = (iTM2TextStorage *)[TV textStorage];
		if([TS respondsToSelector:@selector(syntaxParser)])
		{
			id SP = [TS syntaxParser];
			[SP diagnostic];
		}
	}
	NS_ENDHANDLER
	#endif
	[TS setAttributesChangeDelegate:ACD];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  syntaxAttributesDidChangeNotified:
- (void)syntaxAttributesDidChangeNotified:(NSNotification *)aNotification;
/*"The notification object is used to retrieve font and color info. If no object is given, the NSFontColorManager class object is used.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: NYI
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(iTM2DebugEnabled > 999999)
    {
        iTM2_LOG(@"A change of attributes is notified");
    }
    NSDictionary * D = [aNotification userInfo];
	NSString * style = [D objectForKey:@"style"];
	NSString * variant = [D objectForKey:@"variant"];
	NSString * myStyle = [[self class] syntaxParserStyle];
	NSString * myVariant = [self syntaxParserVariant];
    if(([style caseInsensitiveCompare:myStyle] == NSOrderedSame)
        && ([variant caseInsensitiveCompare:myVariant] == NSOrderedSame))
    {
        [[self attributesServer] attributesDidChange];
        // the above message can be sent more than once to the same object
        // to prevent a waste of time and energy, the attribute server keeps track of the file modification date
        [self setUpAllTextViews];
    }
//iTM2_END;
    return;
}
#pragma mark =-=-=-=-=-=-=-=-=-=-  INDEX WITH BAD OFFSET
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  badOffsetIndex
- (unsigned)badOffsetIndex;
/*"The default implementation does nothing visible, subclassers will append or prepend their own stuff.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return _BadOffsetIndex;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateOffsetsUpTo:
- (void)validateOffsetsUpTo:(unsigned)argument;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(++argument)
        _BadOffsetIndex = MAX(argument, _BadOffsetIndex);
    else
        _BadOffsetIndex = UINT_MAX;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  invalidateOffsetsFrom:
- (void)invalidateOffsetsFrom:(unsigned)argument;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    _BadOffsetIndex = MAX(1,MIN(argument,_BadOffsetIndex));// ASSUME: _BadOffsetIndex > 0
    return;
}
#pragma mark =-=-=-=-=-=-=-=-=-=-  INDEX WITH BAD MODE
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  badModeIndex
- (unsigned)badModeIndex;
/*"The default implementation does nothing visible, subclassers will append or prepend their own stuff.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return _BadModeIndex;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateModesUpTo:
- (void)validateModesUpTo:(unsigned)argument;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(++argument)
        _BadModeIndex = MAX(argument, _BadModeIndex);
    else
        _BadModeIndex = UINT_MAX;// the maximum value
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  invalidateModesFrom:
- (void)invalidateModesFrom:(unsigned)argument;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    _BadModeIndex = MIN(argument, _BadModeIndex);
    return;
}
#pragma mark =-=-=-=-=-=-=-=-=-=-  FOLDING
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  isFoldingCompliant
- (BOOL)isFoldingCompliant;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return NO;
}
#pragma mark =-=-=-=-=-=-=-=-=-=-  MODELINES
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  modeLineAtIndex:
- (id)modeLineAtIndex:(unsigned)idx;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [_ModeLines objectAtIndex:idx];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertModeLine:atIndex:
- (void)insertModeLine:(id)modeLine atIndex:(unsigned)idx;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [_ModeLines insertObject:modeLine atIndex:idx];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  replaceModeLineAtIndex:withModeLine:
- (void)replaceModeLineAtIndex:(unsigned)idx withModeLine:(id)modeLine;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [_ModeLines replaceObjectAtIndex:idx withObject:modeLine];
	[[_ModeLines objectAtIndex:0] setPreviousMode:kiTM2TextRegularSyntaxMode];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  replaceModeLinesInRange:withModeLines:
- (void)replaceModeLinesInRange:(NSRange)range withModeLines:(NSArray *)MLs;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [_ModeLines replaceObjectsInRange:range withObjectsFromArray:MLs];
	[[_ModeLines objectAtIndex:0] setPreviousMode:kiTM2TextRegularSyntaxMode];
    [self invalidateOffsetsFrom:range.location];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  numberOfModeLines
- (unsigned)numberOfModeLines;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [_ModeLines count];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  lineIndexForLocation:
- (unsigned int)lineIndexForLocation:(unsigned)location;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Dec 12 22:44:56 GMT 2003
To Do List: 
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//NSLog(@"Computing the line idx for location: %u", location);
    // this is the idx for which the mode line realizes
    // offset[idx] <= location < offset[idx]+end[idx]
    // equivalent definition:
    // the one but first idx such that
    // offset[idx] > location
    // _ModeLines is assumed to have at least one object!!!
    // _InvalidOffset is assumed to be greater than one, assuming that the first offset is necessary 0!!!
//iTM2_LOG(@"..........  [self numberOfModeLines] is:%u", [self numberOfModeLines]);
	unsigned int expected = iTM2DebugEnabled? [self xlineIndexForLocation:location]:0;
    unsigned n = MIN(_BadOffsetIndex, [self numberOfModeLines])-1;
	unsigned min = 0;
	unsigned max = 0;
    // _BadOffsetIndex is assumed to be greater than 1
    // The offset of the first mode line must be 0
//NSLog(@"Index of the last valid mode line with respect to the offset: %u", n);
	iTM2ModeLine * modeLine = nil;
	if(_PreviousLineIndex<n)
	{
		modeLine = [_ModeLines objectAtIndex:_PreviousLineIndex];
		if([modeLine startOffset] <= location)
		{
			if(location < [modeLine endOffset])
			{
				_PreviousLocation = location;
				if(iTM2DebugEnabled)
				{
					NSAssert(_PreviousLineIndex==expected, @"!!!!  BAD thing man, report BUG");
				}
				return _PreviousLineIndex;
			}
			else
			{
				min = _PreviousLineIndex;
			}
		}
		else
		{
			// the result is an idx in [0, _PreviousLineIndex-1]
			max = _PreviousLineIndex;
			goto next;
		}
	}
//		_PreviousLineIndex = 0;
//		_PreviousLocation = 0;

    modeLine = [_ModeLines objectAtIndex:n];
    unsigned offset = [modeLine startOffset];
    if(location < offset)
    {
        // the result is an idx in [0, n-1]
		max = n;
//NSLog(@"The result is an integer between %u and: %u (excluded)", min, max);
next:
        if(n = (max-min) / 2)
        {
            // n<max-min
            n += min;
            // min < n < max
            if([[_ModeLines objectAtIndex:n] startOffset] > location)
                max = n;
            else
                min = n;
            goto next;
            // [[self modeLineAtIndex:min] startOffset] <= location < [[self modeLineAtIndex:max] startOffset]
        }
        else//if(n=0, (max == min))
        {
            if(iTM2DebugEnabled>999999)
            {
                id modeLine = [_ModeLines objectAtIndex:min];
                iTM2_LOG(@"=====  |=:>) -X- The idx found is %u such that %u<=%u<%u (<>) ",
                    min, [modeLine startOffset], location, [modeLine endOffset]);
            }
			_PreviousLocation = location;
			_PreviousLineIndex = min;
            return _PreviousLineIndex;
        }
    }
    else//if(location >= offset)
    {
        // HERE we have
        // offset <= location
        // AND
        // n = _BadOffsetIndex-1
        // unless the receiver is really inconsistent
        // the result is an idx between _BadOffsetIndex-1 and [self numberOfModeLines]-1, both included.
        unsigned top = [_ModeLines count];//=[self numberOfModeLines];
//NSLog(@"The number of mode lines of this text is: %u, the invalid idx is: %u", top, _BadOffsetIndex);
waikiki:
        // O is the mode line at idx n
        offset = [modeLine endOffset];//offset += [modeLine length];
        if(location < offset)
        {
            if(iTM2DebugEnabled>999999)
            {
                id modeLine = [_ModeLines objectAtIndex:n];
                iTM2_LOG(@"=====  |=:>) -Y- The idx found is %u such that %u<=%u<%u (<>) ",
                    n, [modeLine startOffset], location, [modeLine endOffset]);
            }
			_PreviousLocation = location;
			_PreviousLineIndex = n;
            return _PreviousLineIndex;
         }
        else if(++n < top)
        {
//NSLog(@"We are now validating the idx: %u with offset %u", n, offset);
            modeLine = [_ModeLines objectAtIndex:n];
            [modeLine setStartOffset:offset];
            ++ _BadOffsetIndex;
            goto waikiki;
        }
        else
        {
            if(iTM2DebugEnabled>999999)
            {
                id modeLine = [_ModeLines objectAtIndex:n-1];
                iTM2_LOG(@"=====  |=:>) -Z- The idx found is the top (%u) such that %u<=%u",
                    n-1, [modeLine startOffset], location);
            }
			_PreviousLocation = location;
			_PreviousLineIndex = n-1;
            return _PreviousLineIndex;
        }
    }
//NSLog(@"This is a default return");
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  xlineIndexForLocation:
- (unsigned int)xlineIndexForLocation:(unsigned)location;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Dec 12 22:44:56 GMT 2003
To Do List: 
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//NSLog(@"Computing the line idx for location: %u", location);
    // this is the idx for which the mode line realizes
    // offset[idx] <= location < offset[idx]+end[idx]
    // equivalent definition:
    // the one but first idx such that
    // offset[idx] > location
    // _ModeLines is assumed to have at least one object!!!
    // _InvalidOffset is assumed to be greater than one, assuming that the first offset is necessary 0!!!
//iTM2_LOG(@"..........  [self numberOfModeLines] is:%u", [self numberOfModeLines]);
    unsigned n = MIN(_BadOffsetIndex, [self numberOfModeLines])-1;
	unsigned min = 0;
	unsigned max = 0;
    // _BadOffsetIndex is assumed to be greater than 1
    // The offset of the first mode line must be 0
//NSLog(@"Index of the last valid mode line with respect to the offset: %u", n);
	iTM2ModeLine * modeLine = [_ModeLines objectAtIndex:n];
    unsigned offset = [modeLine startOffset];
    if(location < offset)
    {
        // the result is an idx in [0, n-1]
		max = n;
//NSLog(@"The result is an integer between %u and: %u (excluded)", min, max);
next:
        if(n = (max-min) / 2)
        {
            // n<max-min
            n += min;
            // min < n < max
            if([[_ModeLines objectAtIndex:n] startOffset] > location)
                max = n;
            else
                min = n;
            goto next;
            // [[self modeLineAtIndex:min] startOffset] <= location < [[self modeLineAtIndex:max] startOffset]
        }
        else//if(n=0, (max == min))
        {
            if(iTM2DebugEnabled>999999)
            {
                id modeLine = [_ModeLines objectAtIndex:min];
                iTM2_LOG(@"=====  |=:>) -X- The idx found is %u such that %u<=%u<%u (<>) ",
                    min, [modeLine startOffset], location, [modeLine endOffset]);
            }
            return min;
        }
    }
    else//if(location >= offset)
    {
        // HERE we have
        // offset <= location
        // AND
        // n = _BadOffsetIndex-1
        // unless the receiver is really inconsistent
        // the result is an idx between _BadOffsetIndex-1 and [self numberOfModeLines]-1, both included.
        unsigned top = [_ModeLines count];//=[self numberOfModeLines];
//NSLog(@"The number of mode lines of this text is: %u, the invalid idx is: %u", top, _BadOffsetIndex);
waikiki:
        // O is the mode line at idx n
        offset = [modeLine endOffset];//offset += [modeLine length];
        if(location < offset)
        {
            if(iTM2DebugEnabled>999999)
            {
                id modeLine = [_ModeLines objectAtIndex:n];
                iTM2_LOG(@"=====  |=:>) -Y- The idx found is %u such that %u<=%u<%u (<>) ",
                    n, [modeLine startOffset], location, [modeLine endOffset]);
            }
            return n;
         }
        else if(++n < top)
        {
//NSLog(@"We are now validating the idx: %u with offset %u", n, offset);
            modeLine = [_ModeLines objectAtIndex:n];
            [modeLine setStartOffset:offset];
            ++ _BadOffsetIndex;
            goto waikiki;
        }
        else
        {
            if(iTM2DebugEnabled>999999)
            {
                id modeLine = [_ModeLines objectAtIndex:n-1];
                iTM2_LOG(@"=====  |=:>) -Z- The idx found is the top (%u) such that %u<=%u",
                    n-1, [modeLine startOffset], location);
            }
            return n-1;
        }
    }
//NSLog(@"This is a default return");
}
#pragma mark =-=-=-=-=-=-=-=-=-=-  ATTRIBUTES
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  attributesAtIndex:effectiveRange:
- (NSDictionary *)attributesAtIndex:(unsigned)aLocation effectiveRange:(NSRangePointer)aRangePtr;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(aRangePtr)
    {
        aRangePtr -> location = aLocation;
        aRangePtr -> length = [_TextStorage length]-aLocation;
    }
    return [_AS attributesForMode:iTM2TextDefaultSyntaxModeName];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= attributesAtIndex:longestEffectiveRange:inRange:
- (NSDictionary *)attributesAtIndex:(unsigned)aLocation longestEffectiveRange:(NSRangePointer)aRangePtr inRange:(NSRange)aRangeLimit;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSDictionary * D = [self attributesAtIndex:(unsigned)aLocation effectiveRange:(NSRangePointer)aRangePtr];
    if(aRangePtr)
    {
		*aRangePtr = NSIntersectionRange(aRangeLimit, *aRangePtr);
    }
    return D;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  getSyntaxMode:atIndex:longestRange:
- (unsigned)getSyntaxMode:(unsigned *)modeRef atIndex:(unsigned)aLocation longestRange:(NSRangePointer)aRangePtr;
/*"This has been overriden by a subclasser... No need to further subclassing. Default return value is 0 on (inconsistency?)
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//NSLog(@"Location: %u", aLocation);
    unsigned lineIndex = [self lineIndexForLocation:aLocation];
    iTM2ModeLine * modeLine = [self modeLineAtIndex:lineIndex];
    return [modeLine getSyntaxMode:modeRef atGlobalLocation:aLocation longestRange:aRangePtr];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  getSmartSyntaxMode:atIndex:longestRange:
- (unsigned)getSmartSyntaxMode:(unsigned *)modeRef atIndex:(unsigned)aLocation longestRange:(NSRangePointer)aRangePtr;
/*"This has been overriden by a subclasser... No need to further subclassing. Default return value is 0 on (inconsistency?)
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//NSLog(@"Location: %u", aLocation);
    return [self getSyntaxMode:modeRef atIndex:aLocation longestRange:aRangePtr];
}
#pragma mark =-=-=-=-=-=-=-=-=-=-  MODE
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= fixSyntaxModesInRange:
- (void)fixSyntaxModesInRange:(NSRange)range;
/*"Description forthcoming. This is a critical method that gets called every time?
Version history: jlaurens AT users DOT sourceforge DOT net
- 2: 12/05/2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//NSLog(@"range: %@", NSStringFromRange(range));
//NSLog(@"Now _BadModeIndex = %u", _BadModeIndex);
    // Trivial cases.
    if((range.location >= [(NSTextStorage *)_TextStorage length]) || (!range.length))
        return;
    // I don't know if the range is valid.
    range.length = MIN(range.length, [(NSTextStorage *)_TextStorage length]-range.location);
    unsigned last  = [self lineIndexForLocation:range.location+range.length-1];
    // last: offset <= range.location range.length-1 < offset+end
    // It means that all the character indices in range are spread over the lines between first and last,
    // both included.
    if(last < _BadModeIndex)
    // all the line indices strictly before _BadOffsetIndex are all valid: no need to make further computation
        return;
//iTM2_START;
    unsigned first = MIN([self lineIndexForLocation:range.location], _BadModeIndex);
    // first: offset <= range.location < offset+end
	// what is the previous mode?
    unsigned mode = first? [[self modeLineAtIndex:first-1] EOLMode]:[[self modeLineAtIndex:first] previousMode];
//NSLog(@"BIG CALCULUS (first is: %u, last is: %u and _BadModeIndex is: %u, mode is: %u)", first, last, _BadModeIndex, mode);
	if([self diagnostic])
    {
        iTM2_LOG(@"=====  |=:( Comment il a pu me foutre un bordel pareil...............");
    }
    if(mode && (mode != kiTM2TextUnknownSyntaxMode))// no error is reported from the previous line
    {
ValidateNextModeLine:;
        id modeLine = [self modeLineAtIndex:first];
		#ifdef __ELEPHANT_MODELINE__
		#warning ELEPHANT MODE: For debugging purpose only... see iTM2TextStorageKit.h
		unsigned start, end;
		[[_TS string] getLineStart:&start end:&end contentsEnd:nil forRange:NSMakeRange([modeLine startOffset], 0)];
		_iTM2InternalAssert([[modeLine originalString] isEqualToString:[[_TS string] substringWithRange:NSMakeRange(start, end-start)]], ([NSString stringWithFormat:@"original is\n<%@> != expected string is:\n<%@>", [modeLine originalString], [[_TS string] substringWithRange:NSMakeRange(start, end-start)]]));
		#endif
        mode = [self validEOLModeOfModeLine:modeLine forPreviousMode:mode];
		if(mode && ((mode & ~kiTM2TextFlagsSyntaxMask) != kiTM2TextUnknownSyntaxMode))
		{
			[self validateModesUpTo:first];
			int firewall = 543;
			if(++first<last && --firewall)
			{
				goto ValidateNextModeLine;
			}
		}
    }
    _iTM2InternalAssert(![self diagnostic], @"=====  |=:( Qui m'a foutu un bordel pareil...............");
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= invalidateModesForCharacterRange:editedAttributesRangeIn:
- (void)invalidateModesForCharacterRange:(NSRange)range editedAttributesRangeIn:(NSRangePointer)editedAttributesRangePtr;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2: 12/05/2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(!range.length)
        return;
    unsigned top = MIN(NSMaxRange(range), [_TextStorage length]);
    if(!top)
        return;
    unsigned bottom = range.location;
    range.location = 0;
    unsigned lineIndex;
	lineIndex = [self lineIndexForLocation:top-1];
	iTM2ModeLine * modeLine = [self modeLineAtIndex:lineIndex];
	range.location = [modeLine startOffset];
	NSRange editedAttributesRange = NSMakeRange([modeLine startOffset], [modeLine length]);
	if(bottom < range.location)
	{
		range.length = top-range.location;
		[modeLine invalidateGlobalRange:range];
		top = range.location;
here:
		lineIndex = [self lineIndexForLocation:top-1];
		iTM2ModeLine * modeLine = [self modeLineAtIndex:lineIndex];
		editedAttributesRange.location -= [modeLine length];
		editedAttributesRange.length += [modeLine length];
		range.location = [modeLine startOffset];
		if(bottom < range.location)
		{
			range.length = top-range.location;
			[modeLine invalidateGlobalRange:range];
			top = range.location;
			goto here;
		}
		else
		{
			range.location = bottom;
			range.length = top-bottom;
			editedAttributesRange.location -= [modeLine length];
			editedAttributesRange.length += [modeLine length];
			[modeLine invalidateGlobalRange:range];
		}
	}
	else
	{
		range.location = bottom;
		range.length = top-bottom;
		editedAttributesRange.location -= [modeLine length];
		editedAttributesRange.length += [modeLine length];
		[modeLine invalidateGlobalRange:range];
	}
//    [self invalidateModesFrom:lineIndex];
    [self invalidateModesFrom:0];
	if(editedAttributesRangePtr)
	{
		* editedAttributesRangePtr = editedAttributesRange;
	}
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  didUpdateModeLine:forPreviousMode:
- (void)didUpdateModeLine:(id)originalModeLine forPreviousMode:(unsigned)previousMode;
/*"This method will compute all the correct attributes. No need to override..
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Dec 12 22:44:56 GMT 2003
To Do List: 
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  validEOLModeOfModeLine:forPreviousMode:
- (unsigned)validEOLModeOfModeLine:(id)originalModeLine forPreviousMode:(unsigned)previousMode;
/*"This method is an entry point will compute all the correct attributes."*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    #undef _OriginalModeLine
    #define _OriginalModeLine ((iTM2ModeLineDef *)originalModeLine)
    _iTM2InternalAssert(![self diagnostic], @"BIG PROBLEM BEFORE VALIDATING THE MODE");
	// the previous mode is in general the mode of the last EOL character of the previous line
	// The default value is kiTM2TextUnknownSyntaxMode, such that a zero value is an error and bypasses the whole method.
    if(!previousMode || (previousMode == kiTM2TextUnknownSyntaxMode))
		// The previous mode is an error (weak or strong): do nothing and propagate the error.
		// Don't know yet what is the difference between both choices...
        return previousMode & kiTM2TextEndOfLineSyntaxMask;
	// if the mode line is void, which corresponds to a void line, with only an EOL marker if it is not the last line
	// no computation
    if(!_OriginalModeLine->_NumberOfSyntaxWords
		|| !_OriginalModeLine->_ContentsLength)
    {
        [originalModeLine invalidateLocalRange:NSMakeRange(0, UINT_MAX)];		
        return _OriginalModeLine->_EOLMode = [self EOLModeForPreviousMode:previousMode];
    }
	// did the previous mode change since the last time the attributes were computed?
    if([originalModeLine previousMode] != previousMode)
    {
//NSLog(@"New previous mode, invalidating the whole line (old: %u <> new: %u)?", [originalModeLine previousMode], previousMode);
		// the current syntax analyse is no longer valid
        [originalModeLine invalidateLocalRange:NSMakeRange(0, 1)];
        [originalModeLine setPreviousMode:previousMode];
    }
    else if(!(_OriginalModeLine->_InvalidLocalRange).length
            || ((_OriginalModeLine->_InvalidLocalRange).location >= _OriginalModeLine->_ContentsLength))
	// the attributes were already computed, so we just have to return the result previously computed and stored as the EOL mode
        return _OriginalModeLine->_EOLMode = (_OriginalModeLine->_EOLMode | kiTM2TextEndOfLineSyntaxMask);
//iTM2_START;
	// now, we are really going to compute the attributes validating the modes
    _iTM2InternalAssert(![self diagnostic], @"***  0-STARTING:BIG PROBLEM IN VALIDATING THE MODE");
    #undef IR
    #define IR _OriginalModeLine->_InvalidLocalRange
//iTM2_LOG(@"Working hard: local invalid range %@, previousMode: %u", NSStringFromRange(IR), previousMode);
//[originalModeLine describe];
//unsigned N = 0;
    // From now on, IR.location < the length of the mode line there is some mode to fix
    #undef _ML
    iTM2ModeLineDef * _ML = (iTM2ModeLineDef *)[iTM2ModeLine modeLine];
	// we compute a new mode line, then we will swap the contents of the new mode line with the original one
    #undef workingML
    #define workingML ((iTM2ModeLine *)_ML)
	// we are definitely optimistic:
	[workingML validateLocalRange:NSMakeRange(0, UINT_MAX)];
//[workingML describe];
    // We start duplicating the good modes and mode wordLengths
    unsigned syntaxWordIndex = 0;// Here, syntaxWordIndex < _OriginalModeLine->_NumberOfSyntaxWords
    unsigned currentSyntaxWordOff7 = 0;// it is the offset of the syntax word at index syntaxWordIndex
    //currentSyntaxWordOff7 = \sum_{i=0}^{syntaxWordIndex-1} [originalModeLine syntaxLengthAtIndex:i]
    _iTM2InternalAssert(![self diagnostic], @"***  1 :BIG PROBLEM IN VALIDATING THE MODE");
    unsigned testigo = 0;// debugger to ensure that all chars are the same
	// We start by copying the valid original modes
	// a syntax word is considered to be valid when it is before the invalid range and far from it
	// More precisely a valid syntax word contains no invalid character and is followed by a valid character
	// We merge the syntax words when possible
	// if many consecutive syntax words have the same mode, they will be copied as one word
	// previousMode and previousLength serve this purpose
    unsigned previousLength = 0;
    // previousLength stores the length of the current syntax word
	copyValidOriginalMode:;
	unsigned originalMode = _OriginalModeLine->__SyntaxWordModes[syntaxWordIndex];
    unsigned nextSyntaxWordOff7 = _OriginalModeLine->__SyntaxWordEnds[syntaxWordIndex];// it will be the offset of the syntax word at index syntaxWordIndex+1
    //nextSyntaxWordOff7 = \sum_{i=0}^{syntaxWordIndex} [originalModeLine syntaxLengthAtIndex:i]
    //nextSyntaxWordOff7 = currentSyntaxWordOff7+[originalModeLine syntaxLengthAtIndex:syntaxWordIndex]
	if(nextSyntaxWordOff7<IR.location)
	{
		// OK we can copy what is there as a whole.
		if(originalMode==previousMode)
		{
			previousLength += _OriginalModeLine->__SyntaxWordLengths[syntaxWordIndex];
		}
		else
		{
			[workingML appendSyntaxMode:previousMode length:previousLength];
			testigo += previousLength;
			previousMode = originalMode;
			previousLength = _OriginalModeLine->__SyntaxWordLengths[syntaxWordIndex];
		}
		NSAssert(++syntaxWordIndex<_OriginalModeLine->_NumberOfSyntaxWords, @"INCONSISTENCY: this should not occur");
		currentSyntaxWordOff7 = nextSyntaxWordOff7;
		goto copyValidOriginalMode;
	}
	else if(IR.location > currentSyntaxWordOff7)
	{
		// currentSyntaxWordOff7 < IR.location <= nextSyntaxWordOff7
		// the beginning of the syntax word is not accepted
		IR.length += IR.location-currentSyntaxWordOff7;
		IR.location = currentSyntaxWordOff7;
	}
	_iTM2InternalAssert(![self diagnostic], @"2-BIG PROBLEM IN VALIDATING THE MODE");
	// HERE we have
    // currentSyntaxWordOff7 <= IR.location < nextSyntaxWordOff7
    // syntaxWordIndex < _OriginalModeLine->_NumberOfSyntaxWords
    //
    // NOW WE ARE FIXING THE ATTRIBUTES...
    unsigned localLocation = IR.location;// the location we are validating
    // localLocation is the first character index for which the mode is not yet fixed
    unsigned globalLocation = _OriginalModeLine->_StartOff7+localLocation;
    unsigned topGlobalLocation = _OriginalModeLine->_StartOff7+MIN(NSMaxRange(IR), _OriginalModeLine->_ContentsLength);
    //topGlobalLocation <= [originalModeLine startOffset]+[originalModeLine contentsLength];
//NSLog(@"Fixing the modes\r(first unsaved mode syntaxWordIndex: %u, nextSyntaxWordOff7: %u, localLocation: %u, previousLength: %u)", syntaxWordIndex, nextSyntaxWordOff7, localLocation, previousLength);
//[workingML describe];
//NSLog(@"Looking for globalLocation: %u (?%u)", globalLocation, topGlobalLocation);
    NSAssert2(topGlobalLocation <= [(NSTextStorage *)[self textStorage] length],
		@"PROBLEM: text length is: %i >? %i", [(NSTextStorage *)[self textStorage] length], topGlobalLocation);
    unsigned parsedMode = kiTM2TextUnknownSyntaxMode;
    unsigned parsedLength = 0;
    unsigned nextMode = kiTM2TextUnknownSyntaxMode;
	unsigned status;
    // parsedLength is used as a cache
	_iTM2InternalAssert(![self diagnostic], @"3-BIG PROBLEM IN VALIDATING THE MODE");
    if(globalLocation < topGlobalLocation)
    {
fixGlobalLocationMode:
//NSLog(@"WE ARE NOW WORKING ON globalLocation: %u, topGlobalLocation: %u", globalLocation, topGlobalLocation);
        status = [self getSyntaxMode:&parsedMode forLocation:globalLocation previousMode:previousMode effectiveLength:&parsedLength nextModeIn:&nextMode before:topGlobalLocation];
//NSLog(@"next mode is %u, with length: %u previousMode: %u, nextMode: %u", mode, length, previousMode, nextMode);
//N+=length;
#warning INFINITE LOOP DUE TO A RETURNED 0 LENGTH... DUE TO A RANGE EXCEEDED (1)
        if(parsedMode == previousMode)
        {
            previousLength += parsedLength;
        }
        else
        {
            [workingML appendSyntaxMode:previousMode length:previousLength];
            previousLength = parsedLength;
            previousMode = parsedMode;
        }
		if(parsedLength)
		{
			globalLocation += parsedLength;
			localLocation += parsedLength;
			// now both locations correspond to nextMode if relevant
			// currentSyntaxWordOff7 <= localLocation < nextSyntaxWordOff7?
			skipOldSyntaxWords:
			if(localLocation >= nextSyntaxWordOff7)
			// I have parsed a syntax word that was (almost) there before
			// It can happen because either the word has not changed, or has been extended
			{
				if(++syntaxWordIndex < _OriginalModeLine->_NumberOfSyntaxWords)
				{
					currentSyntaxWordOff7 = nextSyntaxWordOff7;
					nextSyntaxWordOff7 = _OriginalModeLine->__SyntaxWordEnds[syntaxWordIndex];
					goto skipOldSyntaxWords;
				}
				else
				{
				// nextSyntaxWordOff7 <= localLocation && syntaxWordIndex == _OriginalModeLine->_NumberOfSyntaxWords
				// in that case, nextSyntaxWordOff7 is the contenstLength of the line and everything is done
				// localLocation is exactly the contentsLength
// [workingML describe];
// NSLog(@"THIS IS THE END, previousMode: %u, previousLength: %u", previousMode, previousLength);
					goto theEnd;
				}
			}
			// Now we have
			// currentSyntaxWordOff7 <= localLocation < nextSyntaxWordOff7
			// syntaxWordIndex < _OriginalModeLine->_NumberOfSyntaxWords
			if(globalLocation < topGlobalLocation)
			{
				if(nextMode && nextMode != kiTM2TextUnknownSyntaxMode)
				{
					// nextMode is the mode at globalLocation
//++N;
					[workingML appendSyntaxMode:previousMode length:previousLength];
					++globalLocation;
					++localLocation;
					previousLength = 1;
					previousMode = nextMode;
					if(globalLocation < topGlobalLocation)
					{
						goto fixGlobalLocationMode;
					}
				}
				else
				{
					[workingML invalidateGlobalRange:NSMakeRange(globalLocation, 1)];
					goto fixGlobalLocationMode;
				}
			}
		}
    }
    // the end of this loop occurs when globalLocation>=topGlobalLocation
    // which means [originalModeLine startOffset]+NSMaxRange(IR) <= globalLocation
//NSLog(@"Modes fixed, syntaxWordIndex: %u, _OriginalModeLine->_NumberOfSyntaxWords: %u", syntaxWordIndex, _OriginalModeLine->_NumberOfSyntaxWords);
//[workingML describe];
    // now, we have
    // currentSyntaxWordOff7 = '[originalModeLine offsetAtIndex:syntaxWordIndex]'
    // nextSyntaxWordOff7 = currentSyntaxWordOff7+[originalModeLine syntaxLengthAtIndex:syntaxWordIndex]
    // currentSyntaxWordOff7 <= localLocation < nextSyntaxWordOff7
	_iTM2InternalAssert(![self diagnostic], @"4-BIG PROBLEM IN VALIDATING THE MODE");
    unsigned oldPreviousMode = (localLocation>currentSyntaxWordOff7)? [originalModeLine syntaxModeAtIndex:syntaxWordIndex]:
        (syntaxWordIndex? [originalModeLine syntaxModeAtIndex:syntaxWordIndex-1]:[originalModeLine previousMode]);
    if(oldPreviousMode == previousMode)
    {
//iTM2_LOG(@"Saving %u words (parsedMode = %u)", _OriginalModeLine->_NumberOfSyntaxWords-syntaxWordIndex, previousMode);
        [workingML appendSyntaxMode:previousMode length:previousLength];
        [workingML appendSyntaxMode:[originalModeLine syntaxModeAtIndex:syntaxWordIndex] length:nextSyntaxWordOff7-localLocation];
        previousLength = 0;
        while(++syntaxWordIndex<_OriginalModeLine->_NumberOfSyntaxWords)
            [workingML appendSyntaxMode:[originalModeLine syntaxModeAtIndex:syntaxWordIndex]
				length: [originalModeLine syntaxLengthAtIndex:syntaxWordIndex]];
    }
    else if(globalLocation < _OriginalModeLine->_ContentsEndOff7)
    {
//NSLog(@"ANOTHER LOOP");
        // the previous mode has changed we must recompute the mode.
        //topGlobalLocation = [originalModeLine startOffset]+nextLocalLocation;
        topGlobalLocation = globalLocation+1;
		goto fixGlobalLocationMode;
    }
    theEnd:
//NSLog(@"END OK: %u", previousLength);
    [workingML appendSyntaxMode:previousMode length:previousLength];
	_iTM2InternalAssert(![workingML diagnostic], @"***  7<<-before swap :BIG PROBLEM IN VALIDATING THE MODE");
	NSAssert2([workingML contentsLength]==[originalModeLine contentsLength],
		@"***  7<-before swap : BIG PROBLEM IN VALIDATING THE MODE %u != %u",
								[workingML contentsLength], [originalModeLine contentsLength]);
    [originalModeLine swapContentsWithModeLine:workingML];
	_iTM2InternalAssert(![self diagnostic], @"***  7-before END :BIG PROBLEM IN VALIDATING THE MODE");
//NSLog(@"Number of modes really computed: %u/%u", N, [originalModeLine length]);
	_iTM2InternalAssert(![self diagnostic], @"***  END1 :BIG PROBLEM IN VALIDATING THE MODE");
    _OriginalModeLine->_EOLMode = [self EOLModeForPreviousMode:previousMode];
//[originalModeLine describe];
//iTM2_LOG(@"Worked hard: local invalid range %@, nextMode: %u", NSStringFromRange([originalModeLine invalidLocalRange]), previousMode);
//iTM2_END;
	_iTM2InternalAssert(![self diagnostic], @"***  END2 :BIG PROBLEM IN VALIDATING THE MODE");
//iTM2_END;
//    [originalModeLine describe];
	[self didUpdateModeLine:originalModeLine forPreviousMode:previousMode];
	return _OriginalModeLine->_EOLMode = (_OriginalModeLine->_EOLMode | kiTM2TextEndOfLineSyntaxMask);
    #undef workingML
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  getSyntaxMode:forCharacter:previousMode:
- (unsigned)getSyntaxMode:(unsigned *)newModeRef forCharacter:(unichar)theChar previousMode:(unsigned)previousMode;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Dec 12 22:44:56 GMT 2003
To Do List: 
"*/
{iTM2_DIAGNOSTIC;
	NSParameterAssert(newModeRef);
//iTM2_START;
	*newModeRef = kiTM2TextUnknownSyntaxMode;
	return kiTM2TextNoErrorSyntaxStatus;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  getSyntaxMode:forLocation:previousMode:effectiveLength:nextModeIn:before:
- (unsigned)getSyntaxMode:(unsigned *)newModeRef forLocation:(unsigned)idx previousMode:(unsigned)previousMode effectiveLength:(unsigned *)lengthRef nextModeIn:(unsigned *)nextModeRef before:(unsigned)beforeIndex;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Dec 12 22:44:56 GMT 2003
To Do List: 
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSParameterAssert(newModeRef);
	*newModeRef = kiTM2TextUnknownSyntaxMode;
    if(lengthRef)
	{
        *lengthRef = beforeIndex-idx;
	}
    if(nextModeRef)
	{
        *nextModeRef = kiTM2TextUnknownSyntaxMode;
	}
    return kiTM2TextNoErrorSyntaxStatus;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  EOLModeForPreviousMode:
- (unsigned)EOLModeForPreviousMode:(unsigned)previousMode;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Dec 12 22:44:56 GMT 2003
To Do List: 
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//NSLog(@"Character: %@", [NSString stringWithCharacters:&argument length:1]);
//NSLog(@"previousMode: %u", previousMode);
//NSLog(@"result: %u", previousMode-1);
    return previousMode | kiTM2TextRegularSyntaxMode | kiTM2TextEndOfLineSyntaxMask;
}
#pragma mark =-=-=-=-=-=-=-=-=-=-  COMMUNICATION
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= textStorageWillReplaceCharactersInRange:withString:
- (void)textStorageWillReplaceCharactersInRange:(NSRange)range withString:(NSString *)string;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2: 12/05/2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
#if 0
	iTM2_LOG(@"[[self textStorage] string] is:%@", [[self textStorage] string]);
	iTM2_LOG(@"string is: %@", string);
	iTM2_LOG(@"range is: %@", NSStringFromRange(range));
	iTM2_LOG(@"[_ModeLines count] is:%u", [_ModeLines count]);
#endif
	if([self diagnostic])
	{
		iTM2_LOG(@"****  INTERNAL INCONSISTENCY: The mode line is not in a consistent state before replacing characters");
	}
//iTM2_END;
    return;
}
#if 1
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  textStorageDidInsertCharacterAtIndex:
- (void)textStorageDidInsertCharacterAtIndex:(unsigned)aGlobalLocation editedAttributesRangeIn:(NSRangePointer)editedAttributesRangePtr;
/*"This new version is stronger.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 05/15/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
#if 0
#warning build FAILED, this is for debugging
    [self textStorageDidInsertCharactersAtIndex:aGlobalLocation count:1 editedAttributesRangeIn:editedAttributesRangePtr];
#else
	unsigned lineIndex = [self lineIndexForLocation:aGlobalLocation];
	[self invalidateOffsetsFrom:lineIndex+1];
#undef _ML
	iTM2ModeLineDef * _ML = (iTM2ModeLineDef *)[[[self modeLineAtIndex:lineIndex] retain] autorelease];
#undef workingML
	#define workingML ((iTM2ModeLine *)_ML)
	// If this mode line is already invalid, we will recompute everything
    // The central question is:
    // Did I insert a new line character?
    unsigned newEnd, newContentsEnd;
    NSString * S = [_TextStorage string];
//NSLog(@"[S length] is:%u", [S length]);
    [S getLineStart:nil end:&newEnd contentsEnd:&newContentsEnd forRange:NSMakeRange(aGlobalLocation, 0)];
    //EOLs<newStart<=aGlobalLocation<newEnd
#ifdef __ELEPHANT_MODELINE__
#warning ELEPHANT MODE: For debugging purpose only... see iTM2TextStorageKit.h
	// the mode line was valid, there is some computation to save
    // The central question is:
    // Did I insert a new line character?
	[_ML -> originalString release];
	_ML -> originalString = [[S substringWithRange:NSMakeRange(_ML->_StartOff7, newEnd-_ML->_StartOff7)] retain];
    //EOLs<newStart<=aGlobalLocation<newEnd
#endif
	NSRange R;
	if(aGlobalLocation+1 == newContentsEnd)// we just appended a normal character to the line
	{
		[workingML appendSyntaxMode:kiTM2TextUnknownSyntaxMode length:1];
		[workingML invalidateGlobalRange:NSMakeRange(aGlobalLocation, 1)];
		if(aGlobalLocation>_ML->_StartOff7)
		{
			[self attributesAtIndex:aGlobalLocation-1 effectiveRange:&R];
			[workingML invalidateGlobalRange:R];
			unichar theChar;
placeholderMarks:
			theChar = [S characterAtIndex:aGlobalLocation];
			if((theChar == '@') ||(theChar == '(') ||(theChar == ')'))
			{
				R.location = aGlobalLocation;
				R.length = 1;
				do
				{
					theChar = [S characterAtIndex:--R.location];
					if((theChar != '@')&&(theChar != '(')&&(theChar != ')'))
					{
						[workingML invalidateGlobalRange:R];
						break;
					}
				}// 
				while(_ML->_StartOff7<R.location);
			}
		}
theEnd:
		if([self diagnostic])
		{
			iTM2_LOG(@"***  FAILURE: Could not append a character properly (1-lighter)");
		}
		if(editedAttributesRangePtr)
		{
			*editedAttributesRangePtr = [workingML invalidGlobalRange];
		}
		[self invalidateModesFrom:lineIndex];
		return;
	}
    else
	{
		// the character inserted is not at the end
		if(iTM2DebugEnabled > 999999)
		{
			iTM2_LOG(@"/*/*/*/*/*  <:?) I AM INSERTING ONE CHARACTER AT LOCATION %u OF MODE LINE AT INDEX: %u", aGlobalLocation, lineIndex);
		}
		if([workingML diagnostic])
		{
			iTM2_LOG(@"/*/*/*/*/*  <:?(  STARTING WITH A BAD MODE LINE!!!");
		}
		if(aGlobalLocation < newContentsEnd)
		{
//iTM2_LOG(@"IT IS NOT AN EOL INSERTED");
			// this is not an EOL character inserted
			NSAssert([workingML enlargeSyntaxModeAtGlobalLocation:aGlobalLocation length:1],
				@"INTERNAL INCONSISTENCY: UNEXPECTED SITUATION, CASE 1: NOT ENLARGED");
			[self attributesAtIndex:aGlobalLocation effectiveRange:&R];
			[workingML invalidateGlobalRange:R];
			if(R.location>_ML->_StartOff7)
			{
				[self attributesAtIndex:R.location-1 effectiveRange:&R];
				if(R.length<4)// "@(@"
				{
					[workingML invalidateGlobalRange:R];
					if(R.location>_ML->_StartOff7)
					{
						[self attributesAtIndex:R.location-1 effectiveRange:&R];
						if(R.length<4)// "@(@"
						{
							[workingML invalidateGlobalRange:R];
						}
					}
				}
				goto placeholderMarks;
			}
			goto theEnd;
	//NSLog(@"I am invalidating the range");
		}
		else
		{
			// an EOL character was inserted
			if(iTM2DebugEnabled > 999999)
			{
				iTM2_LOG(@"/*/*/*/*/*  <:/ MANQUE DE BOL, C'EST UN EOL!!!!! AT LOCATION %u", aGlobalLocation);
			}
			[self textStorageDidInsertCharactersAtIndex:aGlobalLocation count:1 editedAttributesRangeIn:editedAttributesRangePtr];
			return;
		}
	}
#endif
	return;
}
#elif
#warning FAILED menu item to toggle smart undo
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  textStorageDidInsertCharacterAtIndex:
- (void)textStorageDidInsertCharacterAtIndex:(unsigned)aGlobalLocation editedAttributesRangeIn:(NSRangePointer)editedAttributesRangePtr;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: 05/15/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
#if 0
    [self textStorageDidInsertCharactersAtIndex:aGlobalLocation count:1 editedAttributesRangeIn:editedAttributesRangePtr];
#else
	unsigned lineIndex = [self lineIndexForLocation:aGlobalLocation];
	[self invalidateOffsetsFrom:lineIndex+1];
#undef _ML
	iTM2ModeLineDef * _ML = (iTM2ModeLineDef *)[self modeLineAtIndex:lineIndex];
#undef workingML
	#define workingML ((iTM2ModeLine *)_ML)
	// If this mode line is already invalid, we will recompute everything
    // The central question is:
    // Did I insert a new line character?
	unsigned status;
	unsigned previousMode,newMode;
    unsigned newEnd, newContentsEnd;
	unichar theChar;
    NSString * S = [_TextStorage string];
//NSLog(@"[S length] is:%u", [S length]);
    [S getLineStart:nil end:&newEnd contentsEnd:&newContentsEnd forRange:NSMakeRange(aGlobalLocation, 0)];
    //EOLs<newStart<=aGlobalLocation<newEnd
#ifdef __ELEPHANT_MODELINE__
#warning ELEPHANT MODE: For debugging purpose only... see iTM2TextStorageKit.h
	// the mode line was valid, there is some computation to save
    // The central question is:
    // Did I insert a new line character?
	[_ML -> originalString release];
	_ML -> originalString = [[S substringWithRange:NSMakeRange(_ML->_StartOff7, newEnd-_ML->_StartOff7)] retain];
    //EOLs<newStart<=aGlobalLocation<newEnd
#endif
	if([self badModeIndex] <= lineIndex)// the attributes need computations
	{
		if(aGlobalLocation+1 == newContentsEnd)// we just appended a normal character to the line
		{
			[workingML appendSyntaxMode:kiTM2TextUnknownSyntaxMode length:1];
			[workingML invalidateGlobalRange:NSMakeRange(aGlobalLocation, 1)];
			if([self diagnostic])
			{
				iTM2_LOG(@"***  FAILURE: Could not append a character properly (1-lighter)");
			}
			if(editedAttributesRangePtr)
			{
				*editedAttributesRangePtr = [workingML invalidGlobalRange];
			}
			[self invalidateModesFrom:lineIndex];
			return;
		}
		else//if(aGlobalLocation+1 == newEnd)// we just appended an EOL character to the line thus creating a void new line
		{
			// we have to insert a line after lineIndex
			[self textStorageDidInsertCharactersAtIndex:aGlobalLocation count:1 editedAttributesRangeIn:editedAttributesRangePtr];
			return;
		}
	}
	// the mode line was valid, there is some computation to save
	// in general, we insert a non EOL character at the end of a line
	if(aGlobalLocation+1 == newContentsEnd)
	{
		// aGlobalLocation is the position of the last character of the line
		// the inserted character is the last one of the line
        if(iTM2DebugEnabled > 999999)
        {
            iTM2_LOG(@"/*/*/*/*/*  <:?) I AM INSERTING ONE CHARACTER AT LOCATION %u OF MODE LINE AT INDEX: %u", aGlobalLocation, lineIndex);
        }
        if([workingML diagnostic])
        {
            iTM2_LOG(@"/*/*/*/*/*  <:?(  STARTING WITH A BAD MODE LINE!!!");
        }
		// things are different whether there were characters or not
		newMode = kiTM2TextUnknownSyntaxMode;
		previousMode = kiTM2TextUnknownSyntaxMode;
		if(aGlobalLocation == _ML->_StartOff7)
		{
			// The newly inserted character is the only one of this line
			previousMode = _ML->_PreviousMode;
			theChar = [S characterAtIndex:aGlobalLocation];
			status = [self getSyntaxMode:&newMode forCharacter:theChar previousMode:previousMode];
			[workingML appendSyntaxMode:newMode length:1];
			if(newMode && (newMode != kiTM2TextUnknownSyntaxMode))
			{
				[workingML validateLocalRange:NSMakeRange(0, UINT_MAX)];
				previousMode = newMode;
				// now we are going jumping to fix the EOL mode: see below
			}
			else
			{
bailWithError:			
				[workingML invalidateLocalRange:NSMakeRange(0, UINT_MAX)];
				// fix the EOL mode lazily
				[workingML setEOLMode:newMode];
				[self invalidateModesFrom:lineIndex];
				if(editedAttributesRangePtr)
				{
					editedAttributesRangePtr->location = [workingML invalidGlobalRange].location;
					editedAttributesRangePtr->length = [_TS length]-editedAttributesRangePtr->location;
				}
//iTM2_END;
				return;
			}
		}
		else
		{
			// the character is appended to the line, and the line was not void
			NSRange previousRange;
			status = [workingML getSyntaxMode:&previousMode atGlobalLocation:aGlobalLocation-1 longestRange:&previousRange];
			if(previousMode == kiTM2TextRegularSyntaxMode)
			{
				// the new character is not expected to modify the previous mode!
				// the previous mode was regular text and should stay so
				theChar = [S characterAtIndex:aGlobalLocation];
				status = [self getSyntaxMode:&newMode forCharacter:theChar previousMode:previousMode];
				[workingML appendSyntaxMode:newMode length:1];
			}
			else if(!previousMode)
			{
				// There was an error
				[workingML appendSyntaxMode:kiTM2TextErrorSyntaxMode length:1];
				if([workingML diagnostic])
				{
					iTM2_LOG(@"***  FAILURE: could not append a character properly while there was a syntax error...");
				}
				goto bailWithError;// just above
			}
			else
			{
				// the newly appended character may change the previous modes too
				[workingML deleteModesInRange:previousRange];
				unsigned globalLocation = previousRange.location;
deletePreviousRange:
				if(globalLocation>_ML->_StartOff7)
				{
					status = [workingML getSyntaxMode:&previousMode atGlobalLocation:globalLocation-1 longestRange:&previousRange];
					if(previousMode != kiTM2TextRegularSyntaxMode)
					{
						[workingML deleteModesInRange:previousRange];
						globalLocation = previousRange.location;
						goto deletePreviousRange;
					}
				}
				else
				{
					previousMode = [workingML previousMode];
				}
				// If the previous syntax mode is not regula
				// we must also recompute all the syntax words that are ending the line and are not regular text
				// actually, previousRange is the range of the preceding syntax word
				// remove this last syntax word
				// everything was valid, but now the invalid range is
				// from globalLocation to the end
				unsigned previousLength = 0;
				// previousLength stores the length of the current syntax word
				//
				// NOW WE ARE FIXING THE ATTRIBUTES...
				// localLocation is the first character index for which the mode is not yet fixed
				unsigned localLocation = globalLocation-_ML->_StartOff7;
//[workingML describe];
//NSLog(@"Looking for globalLocation: %u (?%u)", globalLocation, newContentsEnd);
				unsigned parsedMode = kiTM2TextUnknownSyntaxMode;
				unsigned parsedLength = 0;
				unsigned nextMode = kiTM2TextUnknownSyntaxMode;
				// parsedLength is used as a cache
fixGlobalLocationMode:
//NSLog(@"WE ARE NOW WORKING ON globalLocation: %u, newContentsEnd: %u", globalLocation, newContentsEnd);
				status = [self getSyntaxMode:&parsedMode forLocation:globalLocation previousMode:previousMode effectiveLength:&parsedLength nextModeIn:&nextMode before:newContentsEnd];
//NSLog(@"next mode is %u, with length: %u previousMode: %u, nextMode: %u", mode, length, previousMode, nextMode);
//N+=length;
#warning INFINITE LOOP DUE TO A RETURNED 0 LENGTH... DUE TO A RANGE EXCEEDED (2)
				if(parsedMode == previousMode)
				{
					previousLength += parsedLength;
				}
				else
				{
					[workingML appendSyntaxMode:previousMode length:previousLength];
					previousLength = parsedLength;
					previousMode = parsedMode;
				}
				if(parsedLength)
				{
					globalLocation += parsedLength;
					localLocation += parsedLength;
					// now both locations correspond to nextMode if relevant
					if(globalLocation < newContentsEnd)
					{
						if(nextMode && nextMode != kiTM2TextUnknownSyntaxMode)
						{
							// nextMode is the mode at globalLocation
//++N;
							[workingML appendSyntaxMode:previousMode length:previousLength];
							++globalLocation;
							++localLocation;
							previousLength = 1;
							previousMode = nextMode;
							if(globalLocation < newContentsEnd)
							{
								goto fixGlobalLocationMode;
							}
						}
						else
							goto fixGlobalLocationMode;
					}
				}
				// the end of this loop occurs when globalLocation>=newContentsEnd
//NSLog(@"END OK: %u", previousLength);
				[workingML appendSyntaxMode:previousMode length:previousLength];
				if([self diagnostic])
				{
					iTM2_LOG(@"***  7-before END : BIG PROBLEM IN VALIDATING THE MODE");
					iTM2_LOG(@"***  7-<%@>", [S substringWithRange:NSMakeRange([workingML startOffset], [workingML endOffset]-[workingML startOffset])]);
				}
				else if(iTM2DebugEnabled)
				{
					iTM2_LOG(@"!!!  7-before END : VALID");
				}
				_ML->_InvalidLocalRange = NSMakeRange(UINT_MAX, 0);
				if([self diagnostic])
				{
					iTM2_LOG(@"END1: BIG PROBLEM IN VALIDATING THE MODE");
				}
			}
		}
		// fixing the EOL mode to propagate eventually the change
		newMode = [self EOLModeForPreviousMode:previousMode];
		if([workingML EOLMode] != newMode)
		{
			[workingML setEOLMode:newMode];
			[self invalidateModesFrom:lineIndex+1];
			if(editedAttributesRangePtr)
			{
				editedAttributesRangePtr->location = [workingML invalidGlobalRange].location;
				editedAttributesRangePtr->length = [_TS length]-editedAttributesRangePtr->location;
			}
		}
		else if(editedAttributesRangePtr)
		{
			*editedAttributesRangePtr = [workingML invalidGlobalRange];
		}
		if([self diagnostic])
		{
			iTM2_LOG(@"***  FAILURE: Could not append a character properly");
		}
		return;
	}
    else
	{
		// the character inserted is not at the end
		if(iTM2DebugEnabled > 999999)
		{
			iTM2_LOG(@"/*/*/*/*/*  <:?) I AM INSERTING ONE CHARACTER AT LOCATION %u OF MODE LINE AT INDEX: %u", aGlobalLocation, lineIndex);
		}
		if([workingML diagnostic])
		{
			iTM2_LOG(@"/*/*/*/*/*  <:?(  STARTING WITH A BAD MODE LINE!!!");
		}
		if(aGlobalLocation < newContentsEnd)
		{
//iTM2_LOG(@"IT IS NOT AN EOL INSERTED");
			// this is not an EOL character inserted
			NSAssert([workingML enlargeSyntaxModeAtGlobalLocation:aGlobalLocation length:1],
				@"INTERNAL INCONSISTENCY: UNEXPECTED SITUATION, CASE 1: NOT ENLARGED");
			if([self diagnostic])
			{
				iTM2_LOG(@"/*/*/*/*/*  <:?( BAD ENLARGED MODE LINE!!!");
			}
			NSRange availableRange;
			unsigned availableMode;
			status = [workingML getSyntaxMode:&availableMode atGlobalLocation:aGlobalLocation longestRange:&availableRange];
			if(availableMode != kiTM2TextRegularSyntaxMode)
			{
				// bad news: the character inserted has not the same mode
nextAvailableMode:
				[workingML invalidateGlobalRange:availableRange];
				if(availableRange.location>[workingML startOffset])
				{
					status = [workingML getSyntaxMode:&availableMode atGlobalLocation:availableRange.location-1 longestRange:&availableRange];
					if(availableMode == kiTM2TextRegularSyntaxMode)
					{
						if(editedAttributesRangePtr)
						{
							* editedAttributesRangePtr = NSMakeRange(NSMaxRange(availableRange), [_TS length]-availableRange.location);
						}
					}
					else
					{
						goto nextAvailableMode;
					}
				}
				else
				{
					if(editedAttributesRangePtr)
					{
						* editedAttributesRangePtr = NSMakeRange(availableRange.location, [_TS length]-availableRange.location);
					}
				}
				[self invalidateModesFrom:lineIndex];
			}
			else
			{
				if(aGlobalLocation > [workingML startOffset])
				{
					status = [workingML getSyntaxMode:&previousMode atGlobalLocation:aGlobalLocation-1 longestRange:nil];
				}
				else
				{
					[workingML previousMode];
				}
				theChar = [S characterAtIndex:aGlobalLocation];
				status = [self getSyntaxMode:&newMode forCharacter:theChar previousMode:previousMode];
				if(availableMode != newMode)
				{
					// bad news: the character inserted has not the same mode
					[workingML invalidateGlobalRange:availableRange];
					if(editedAttributesRangePtr)
					{
						* editedAttributesRangePtr = NSMakeRange(availableRange.location, [_TS length]-availableRange.location);
					}
					[self invalidateModesFrom:lineIndex];
				}
				else
				{
					// good news: the character inserted has the same mode
					// I must compute for the next character too because I assume that characters are paired
					// mode at n+1 depends on the character at n+1 and the mode at n
					if(newMode == previousMode)
					{
						// things work well:
						// the next character has not changed nor its previous syntax mode
						// so its syntax mode remains unchanged (and the attributes)
						// the next line should be up to date and ther is no need to fix the attributes
						if(editedAttributesRangePtr)
						{
							* editedAttributesRangePtr = NSMakeRange(aGlobalLocation, 0);
						}
					}
					else
					{
						// we have to compute the syntax mode for the next character
						++aGlobalLocation;
						status = [workingML getSyntaxMode:&availableMode atGlobalLocation:aGlobalLocation longestRange:nil];
						theChar = [S characterAtIndex:aGlobalLocation];
						status = [self getSyntaxMode:&newMode forCharacter:theChar previousMode:newMode];
						if(availableMode == newMode)
						{
							// Fortunately, the next character has the same syntax word despite its previous mode has changed
							// here again, we do not recompute the attributes of the next lines if it not expected by another change
							if(editedAttributesRangePtr)
							{
								* editedAttributesRangePtr = NSMakeRange(aGlobalLocation, 1);
							}
						}
						else
						{
							if(editedAttributesRangePtr)
							{
								* editedAttributesRangePtr = NSMakeRange(aGlobalLocation, [_TS length]-aGlobalLocation);
							}
							[workingML invalidateGlobalRange:NSMakeRange(aGlobalLocation, 1)];
							[self invalidateModesFrom:lineIndex];
						}
					}
				}
			}
			if([self diagnostic])
			{
				iTM2_LOG(@"***  FAILURE: Could not insert a character");
			}
			return;
	//NSLog(@"I am invalidating the range");
		}
		else
		{
			// an EOL character was inserted
			if(iTM2DebugEnabled > 999999)
			{
				iTM2_LOG(@"/*/*/*/*/*  <:/ MANQUE DE BOL, C'EST UN EOL!!!!! AT LOCATION %u", aGlobalLocation);
			}
			[self textStorageDidInsertCharactersAtIndex:aGlobalLocation count:1 editedAttributesRangeIn:editedAttributesRangePtr];
		}
		
		if([self diagnostic])
		{
			iTM2_LOG(@"/*/*/*/*/*  <:( Bordel, pas moyen d'inserer UN caractere...");
		}
		else if(iTM2DebugEnabled)
		{
			iTM2_LOG(@"/*/*/*/*/*  <:) HOURRRRRRRRRRA pour l'insertion");
		}
	}
#endif
	return;
}
#endif
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  textStorageDidReplaceCharactersAtIndex:count:withCount:editedAttributesRangeIn:
- (void)textStorageDidReplaceCharactersAtIndex:(unsigned)location count:(unsigned)oldCount withCount:(unsigned)newCount editedAttributesRangeIn:(NSRangePointer)editedAttributesRangePtr;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: 05/15/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSAssert(newCount>0, @" PLEASE newCount > 0");
    NSAssert(oldCount>0, @" PLEASE oldCount > 0");
    if(iTM2DebugEnabled > 999999)
    {
        iTM2_LOG(@"%%%%%%\n%%%%%%\n%%%%%%\n%%%%%%\n%%%%%%  REPLACING %u characters at location: %u WITH %u CHARACTERS...\n%%%%%%", oldCount, location, newCount);
    }
    // please no diagnostic here: we really know that the mode lines are inconsistent
    // the purpose of this method is to make things consistent.
	unsigned lastLocation = location+oldCount-1;// it is the index of the last changed character, if relevant
    NSString * S = [_TextStorage string];
    unsigned last = [self lineIndexForLocation:lastLocation];
	// we act as if the whole line was modified:
	// location+oldCount-1 is the index of the last character removed
    // In general 
    // [[self modeLineAtIndex:last] startOffset] <= location+oldCount-1 < [[self modeLineAtIndex:last] endOffset]
    // except when location+oldCount-1 == [the_text_storage length], and the mode line is the last one
    // [[self modeLineAtIndex:last] startOffset] <= location+oldCount-1 <= [[self modeLineAtIndex:last] endOffset]
    // we have different situations
    // Do we insert at the beginning of a line,
    // do we insert in the middle of the line
    // do we insert at the end of a line
    // do we insert at the end of the text
    // do we insert EOLs?
    // The principle is simple,
    // we just compute new mode lines and we replace the old mode line by the new ones.
    // The range of all the lines affected by this change once done is
    // begin = [[self modeLineAtIndex:last] startOffset]
    // end = [[self modeLineAtIndex:last] endOffset]+count
    #undef _ML
//    #define _ML ((iTM2ModeLine *)workingML)
    iTM2ModeLineDef * lastModeLine = (iTM2ModeLineDef *)[_ModeLines objectAtIndex:last];
	unsigned complement = lastModeLine->_EndOff7-lastLocation-1;// is the EOL 1 or 2 chars long?
	newCount += complement;
	oldCount += complement;
	lastLocation += complement;
	// Now we are sure that the EOL at line last is completely replaced!
	// there could have been a problem if the EOL was 2 chars long and we replaced only one of the chars...
    iTM2ModeLineDef * _ML = lastModeLine;
    unsigned nextLineOff7 = _ML->_EndOff7+newCount-oldCount;
    #undef workingML
    #define workingML ((iTM2ModeLine *)_ML)
    if(nextLineOff7>[S length])
    {
        iTM2_LOG(@"..........  ERROR: THIS IS NOT A TOP MODEL %u !<= %u):", nextLineOff7, [S length]);
		nextLineOff7 = [S length];
        [workingML describe];
    }
    unsigned first = [self lineIndexForLocation:location];
	_ML = (iTM2ModeLineDef *)[_ModeLines objectAtIndex:first];
    // [[self modeLineAtIndex:first] startOffset] <= location < [[self modeLineAtIndex:first] endOffset]
    // except when location == [the_text_storage length], and the mode line is the last one
    // [[self modeLineAtIndex:first] startOffset] <= location <= [[self modeLineAtIndex:first] endOffset]
    unsigned begin, contentsEnd, end;
    NSRange R = NSMakeRange(location, 0);
    NSMutableArray * newModes = [NSMutableArray array];
    begin = _ML->_StartOff7;
	if(editedAttributesRangePtr)
	{
		* editedAttributesRangePtr = NSMakeRange(begin, [_TS length]-begin);
	}
BesameMucho:
    [S getLineStart:nil end:&end contentsEnd:&contentsEnd forRange:R];
    _ML = (iTM2ModeLineDef *)[iTM2ModeLine modeLine];
    // we create a new line
    [workingML setEOLLength:end-contentsEnd];
    // set the EOL length
    [workingML setStartOffset:begin];
    // set the offset
    [workingML appendSyntaxMode:kiTM2TextUnknownSyntaxMode length:contentsEnd-begin];
#ifdef __ELEPHANT_MODELINE__
#warning ELEPHANT MODE: For debugging purpose only... see iTM2TextStorageKit.h
	[_ML->originalString release];
	_ML->originalString = [[S substringWithRange:NSMakeRange(_ML->_StartOff7, _ML->_EndOff7-_ML->_StartOff7)] retain];
#endif
    // fill it with some contents
	[newModes addObject:workingML];
	// add it to the list
    if(iTM2DebugEnabled>999999)
    {
        iTM2_LOG(@"%%%%%%%%  <:) A NEW MODE LINE ADDED ([newModes count] = %u):", [newModes count]);
        [workingML describe];
    }
    if(end < nextLineOff7)
    {
        begin = end;
        R.location = end;
		goto BesameMucho;
    }
	else if(end > nextLineOff7)
	{
		// the EOL is removed and the next line is counted
		if(last+1 < [_ModeLines count])
			++last;
		else
		{
			iTM2_LOG(@"!!!   ERROR: THIS IS AN UNEXPECTED SITUATION\nindex:%i, old count:%i, new count:%i\nplease report bug or investigated further",location,oldCount,newCount);
		}
	}
	if(_ML->_EOLLength)
	{
		if(last+1 == [_ModeLines count])
		{
			// this is new line added: we must have a void mode line at the end
			_ML = (iTM2ModeLineDef *)[iTM2ModeLine modeLine];
			[newModes addObject:workingML];
			if(iTM2DebugEnabled>999999)
			{
				iTM2_LOG(@"%%%%%%%%  <:) A -LAST- NEW LINE ADDED ([newModes count] = %u):", [newModes count]);
				[workingML describe];
			}
		}
	}
	else
	{
		// this mode line must be the last one
		last = [_ModeLines count]-1;
	}
	if(newCount != oldCount)
		[self invalidateOffsetsFrom:last+1];
	[self replaceModeLinesInRange:NSMakeRange(first, last-first+1) withModeLines:newModes];
	[self invalidateModesFrom:first];
	if([self diagnostic])
	{
		iTM2_LOG(@"%%%%%%%%  <:( Bordel, pas moyen d'inserer deux caracteres...");
	}
    return;
    #undef workingML
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  textStorageDidInsertCharactersAtIndex:count:editedAttributesRangeIn:
- (void)textStorageDidInsertCharactersAtIndex:(unsigned)location count:(unsigned)count editedAttributesRangeIn:(NSRangePointer)editedAttributesRangePtr;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: 05/15/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSParameterAssert(count);
    // please no diagnostic here: we really know that the mode lines are inconsistent
    // the purpose of this method is to make things consistent.
	// we just find the line where the characters have been inserted,
	// then we replace this mode line with new ones
	// these new mode lines come from the whole lines in the new string
	// that contain new characters
	// regarding the line before the characters are inserted:
	// the previous EOL marker is still there
	// If the characters are inserted in the last line, they can be appended
	// if not, they are inserted before the last character,
	// such that in that case there is always an EOL marker remaining
	// and there is already a last void mode line
    unsigned lineIndex = [self lineIndexForLocation:location];
	// there is a possibility of bad mess up
	// suppose the previous EOL is \r
	// suppose we add a new line at the beginning of a line
	// if this new line is a \n, then the previous EOL marker will become \r\n and we did modify the previous line!!!
	// we have to test if we inserted an EOL
    NSString * S = [_TextStorage string];
	unsigned end, contentsEnd;
	iTM2ModeLine * oldModeLine;
    NSRange R;
	if(lineIndex)
	{
		oldModeLine = [self modeLineAtIndex:lineIndex-1];
		R = NSMakeRange([oldModeLine startOffset], 0);
		[S getLineStart:nil end:&end contentsEnd:&contentsEnd forRange:R];
		unsigned newEOLLength = end-contentsEnd;
		if(newEOLLength != [oldModeLine EOLLength])
		{
			[oldModeLine setEOLLength:newEOLLength];
			[oldModeLine invalidateLocalRange:NSMakeRange([oldModeLine contentsLength], newEOLLength)];
		}
	}
	oldModeLine = [self modeLineAtIndex:lineIndex];
//NSLog(@"[S length]:%u, %u characters inserted.", [S length], count);
    unsigned top = [oldModeLine endOffset]+count;
	// top is the index of the last character of the affected line
	// it is either the index of an EOL marker
	// or the length of the text storage
    _iTM2InternalAssert(top <= [S length], @"There is a consistency problem, please report bug Eclipse");
    NSMutableArray * newLineModes = [NSMutableArray array];
    R = NSMakeRange([oldModeLine startOffset], 0);
//NSLog(@"R.location: %u, top: %u", R.location, top);
// the actual characters from R.location to top will have mode lines replacing the mode line at old index
	if(editedAttributesRangePtr)
	{
		* editedAttributesRangePtr = NSMakeRange(R.location, [_TS length]-R.location);
	}
	iTM2ModeLine * modeLine = [iTM2ModeLine modeLine];
RoseRouge:
	[newLineModes addObject:modeLine];
	[S getLineStart:nil end:&end contentsEnd:&contentsEnd forRange:R];
#ifdef __ELEPHANT_MODELINE__
#warning ELEPHANT MODE: For debugging purpose only... see iTM2TextStorageKit.h
	[modeLine->originalString release];
	modeLine->originalString = [[S substringWithRange:NSMakeRange(R.location, end-R.location)] retain];
	if(iTM2DebugEnabled>9999) iTM2_LOG(modeLine->originalString);
#endif
	if(R.location < contentsEnd)
	{
		// This line is not void and contains some characters
		[modeLine appendSyntaxMode:kiTM2TextUnknownSyntaxMode length:contentsEnd-R.location];
		[modeLine invalidateLocalRange:NSMakeRange(R.location, UINT_MAX)];
	}
	if(contentsEnd < end)
	{
		// this is possibly not the end of the string
		[modeLine setEOLLength:end-contentsEnd];
		R.location = end;
		modeLine = [iTM2ModeLine modeLine];
		if(R.location < top)
		{
			goto RoseRouge;
		}
		else if((top>=[S length]) && ![oldModeLine EOLLength])
		{
			// I have reached the end and there was no EOL before the change
			// there is no last void mode line: I must add one
			[newLineModes addObject:modeLine];
		}
	}
    [self replaceModeLinesInRange:NSMakeRange(lineIndex, 1) withModeLines:newLineModes];
	[self invalidateOffsetsFrom:lineIndex];
    [self invalidateModesFrom:lineIndex];
//NSLog(@"A complex character has been inserted.");
	_iTM2InternalAssert(![self diagnostic], ([NSString stringWithFormat:@"++++  <:( Bordel, pas moyen d'inserer %i caracteres...", count]));
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  textStorageDidDeleteCharacterAtIndex:editedAttributesRangeIn:
- (void)textStorageDidDeleteCharacterAtIndex:(unsigned)location editedAttributesRangeIn:(NSRangePointer)editedAttributesRangePtr;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: 05/15/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//NSLog(@"=-<>-=-<>-=-<>-=-<>-=-<>-=-<>-=-<>-=-<>-=-<>-=-<>-=-<>-=");
//NSLog(@"THE NUMBER OF LINES WAS: %u", [self numberOfModeLines]);
    unsigned lineIndex = [self lineIndexForLocation:location];
//NSLog(@"The line idx for location %u is %u", location, lineIndex);
    iTM2ModeLine * workingML = [self modeLineAtIndex:lineIndex];
//[workingML diagnostic];
    if(location < [workingML contentsEndOffset])
    {
		NSRange affectedRange;
		unsigned mode;
		[workingML getSyntaxMode:&mode atGlobalLocation:location longestRange:&affectedRange];
		if(![workingML deleteModesInRange:NSMakeRange(location, 1)])
		{
			// the mode line is no longer consistent
			// replace with a safer one and abort
			// [[self modeLineAtIndex:first] startOffset] <= location < [[self modeLineAtIndex:first] endOffset]
			// except when location == [the_text_storage length], and the mode line is the last one
			// [[self modeLineAtIndex:first] startOffset] <= location <= [[self modeLineAtIndex:first] endOffset]
			unsigned begin, contentsEnd, end;
			NSRange R = NSMakeRange(location, 0);
			NSString * S = [[self textStorage] string];
			[S getLineStart:&begin end:&end contentsEnd:&contentsEnd forRange:R];
			workingML = [iTM2ModeLine modeLine];
			// we create a new line
			[workingML setEOLLength:end-contentsEnd];
			// set the EOL length
			[workingML setStartOffset:begin];
			// set the offset
			[workingML appendSyntaxMode:kiTM2TextUnknownSyntaxMode length:contentsEnd-begin];
		#ifdef __ELEPHANT_MODELINE__
		#warning ELEPHANT MODE: For debugging purpose only... see iTM2TextStorageKit.h
			[_ML->originalString release];
			_ML->originalString = [[S substringWithRange:NSMakeRange(_ML->_StartOff7, _ML->_EndOff7-_ML->_StartOff7)] retain];
		#endif
			// fill it with some contents
			[self replaceModeLineAtIndex:lineIndex withModeLine:workingML];
			if(editedAttributesRangePtr)
			{
				unsigned offset = [workingML startOffset];
				* editedAttributesRangePtr = NSMakeRange(offset, [_TS length]-offset);
			}
			R = NSMakeRange(0,UINT_MAX);
			[workingML invalidateLocalRange:R];
			[self invalidateModesFrom:lineIndex];
			[self invalidateOffsetsFrom:lineIndex+1];
			return;
		}
        [workingML invalidateGlobalRange:affectedRange];
		iTM2ModeLineDef * _ML = (iTM2ModeLineDef *)workingML;
		if((mode != kiTM2TextRegularSyntaxMode) || (affectedRange.length < 2))
		{
			// either a single regular character or a non regular one was deleted
			// what is before and after is likely to change
			while(affectedRange.location>_ML->_StartOff7)
			{
				[workingML getSyntaxMode:&mode atGlobalLocation:affectedRange.location-1 longestRange:&affectedRange];
				if(mode == kiTM2TextRegularSyntaxMode)
				{
					break;
				}
				else
				{
					[workingML invalidateGlobalRange:affectedRange];
				}
			}
		}
		else
		{
			affectedRange.location = MAX(_ML->_StartOff7+4,affectedRange.location)-4;
			[workingML invalidateGlobalRange:affectedRange];
		}
        [self invalidateModesFrom:lineIndex];
        [self invalidateOffsetsFrom:lineIndex+1];
		if(editedAttributesRangePtr)
		{
			unsigned offset = [workingML startOffset];
			* editedAttributesRangePtr = NSMakeRange(offset, [_TS length]-offset);
		}
#ifdef __ELEPHANT_MODELINE__
#warning ELEPHANT MODE: For debugging purpose only... see iTM2TextStorageKit.h
		[workingML->originalString release];
		workingML->originalString = [[[_TS string] substringWithRange:NSMakeRange([workingML startOffset], [workingML length])] retain];
		if(iTM2DebugEnabled>9999) iTM2_LOG(workingML->originalString);
#endif
    }
    else
    {
//iTM2_LOG(@"an EOL character was deleted: a line was removed");
        if(iTM2DebugEnabled > 999999)
        {
            iTM2_LOG(@"*=*=*=*=*  <:/ MAYBE an EOL character was deleted: a line was removed");
        }
        [self textStorageDidDeleteCharactersAtIndex:location count:1 editedAttributesRangeIn:editedAttributesRangePtr];
    }
//iTM2_END;
//NSLog(@"NOW THE NUMBER OF LINES IS: %u", [self numberOfModeLines]);
	if([self diagnostic])
	{
		iTM2_LOG(@"*=*=*=*=*  <:( Bordel, pas moyen d'enlever UN caracteres...");
	}
	else if(iTM2DebugEnabled > 999999)
	{
		iTM2_LOG(@"*=*=*=*=*  <:( HOURRRRRRRRRRA pour la deletion");
	}
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  textStorageDidDeleteCharactersAtIndex:count:editedAttributesRangeIn:
- (void)textStorageDidDeleteCharactersAtIndex:(unsigned)location count:(unsigned)count editedAttributesRangeIn:(NSRangePointer)editedAttributesRangePtr;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: 05/15/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//NSLog(@"=-<>-=-<>-=-<>-=-<>-=-<>-=-<>-=-<>-=-<>-=-<>-=-<>-=-<>-=");
//[self diagnostic];
//NSLog(@"THE NUMBER OF LINES WAS: %u", [self numberOfModeLines]);
    unsigned oldFirstIndex = [self lineIndexForLocation:location];
//NSLog(@"The line idx for location %u is %u", location, oldFirstIndex);
    iTM2ModeLine * oldFirst = [self modeLineAtIndex:oldFirstIndex];
	if(editedAttributesRangePtr)
	{
		unsigned location = [oldFirst startOffset];
		* editedAttributesRangePtr = NSMakeRange(location, [_TS length]-location);
	}
	unsigned oldLastIndex = [self lineIndexForLocation:location+count];
//NSLog(@"The line idx for location %u is %u", location+count, oldLastIndex);
    iTM2ModeLine * oldLast = [self modeLineAtIndex:oldLastIndex];
	// unsigned nextOffset = [oldLast endOffset];
//NSLog(@"The number of affected line is: %u (= %u-%u+1)", oldLastIndex-oldFirstIndex+1, oldLastIndex, oldFirstIndex);
    NSRange R;
    R.location = [oldFirst startOffset];
    R.length = 0;
    NSString * S = [_TextStorage string];
//NSLog(@"[S length]:%u", [S length]);
    unsigned topLocation = [oldLast endOffset];
//NSLog(@"The affected range is: %u <= ? < %u", [oldFirst startOffset], topLocation);
    topLocation -= count;
    if(topLocation > [S length])
    {
        iTM2_LOG(@"There is a consistency problem, the characters deleted were not as numerous as declared, please report bug");
        topLocation = [S length];
    }
    unsigned contentsEnd = 0;
    NSMutableArray * newModes = [NSMutableArray array];
//NSLog(@"R.location: %u, topLocation: %u", R.location, topLocation);
    iTM2ModeLine * new;
maui:
    new = [iTM2ModeLine modeLine];
    unsigned offset = R.location;
    [new setStartOffset:offset];
//NSLog(@"XVXVXVXVXVXVXVXXVXVXVXXVX");
//NSLog(@"Starting offset: %u", R.location);
	unsigned end;
    [S getLineStart:nil end:&end contentsEnd:&contentsEnd forRange:R];
#ifdef __ELEPHANT_MODELINE__
#warning ELEPHANT MODE: For debugging purpose only... see iTM2TextStorageKit.h
    #undef workingML
    #define workingML ((iTM2ModeLine *)new)
	[workingML->originalString release];
	workingML->originalString = [[[_TS string] substringWithRange:NSMakeRange(R.location, end-R.location)] retain];
	if(iTM2DebugEnabled>9999) iTM2_LOG(workingML->originalString);
#endif
	R.location = end;
    [new setEOLLength:R.location-contentsEnd];
    [new appendSyntaxMode:kiTM2TextUnknownSyntaxMode length:contentsEnd-offset];
    [newModes addObject:new];
//[new describe];
    if(R.location < topLocation)
        goto maui;
    else if((contentsEnd < topLocation) && ![oldLast EOLLength])
    {
        new = [iTM2ModeLine modeLine];
        [new setStartOffset:R.location];
        [new invalidateLocalRange:NSMakeRange(0, UINT_MAX)];
//NSLog(@"XVXVXVXVXVXVXVXXVXVXVXXVX");
//NSLog(@"NEWLINE");
//NSLog(@"Starting offset: %u", R.location);
        [newModes addObject:new];
		// new = nil;
    }
//NSLog(@"Replacing mode lines in range: %u, %u", oldFirstIndex, oldLastIndex-oldFirstIndex+1);
//NSLog(@"With %u mode lines", [newModes count]);
    [self invalidateOffsetsFrom:oldLastIndex+1];
    [self replaceModeLinesInRange:NSMakeRange(oldFirstIndex, oldLastIndex-oldFirstIndex+1) withModeLines:newModes];
    [self invalidateModesFrom:oldFirstIndex];
    [self invalidateOffsetsFrom:oldFirstIndex];
//NSLog(@"END%%%%");
//iTM2_START;
//NSLog(@"NOW THE NUMBER OF LINES IS: %u", [self numberOfModeLines]);
//[self diagnostic];
	if([self diagnostic])
	{
		iTM2_LOG(@"*=*=*=*=*  <:( Bordel, pas moyen d'enlever DES caracteres...");
	}
	else if(iTM2DebugEnabled > 999999)
	{
		iTM2_LOG(@"*=*=*=*=*  <:( HOURRRRRRRRRRA pour les deletions");
	}
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  textStorageWillProcessEditing
- (void)textStorageWillProcessEditing;
/*"Default implementation does nothing. Subclassers will append their job. Delegate can change the characters or attributes
Version history: 
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  textStorageDidProcessEditing
- (void)textStorageDidProcessEditing;
/*"Default implementation does nothing. Subclassers will append their job. Delegate can change the attributes.
Version history: 
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= didClickOnLink:atIndex:
- (BOOL)didClickOnLink:(id)link atIndex:(unsigned)charIndex;
/*"Given a line range number, it returns the range including the ending characters.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	return NO;
}
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  iTM2ModeLine
/*"This is the model object to store the attributes of a single line.
Stores the contentsEnd and end as given by NSString's #{getLineStart:end:contentsEnd:forRange:},
relative to the start idx. Two mutable data of integers, at each idx we have the length on one hand
and the attribute value on the other.
Rmk: The length data should be -1 terminated,
such that the description will remain valid even if chars are inserted or deleted."*/

#define _iTM2_MODE_BLOC_ 16

@implementation iTM2ModeLine
#pragma mark =-=-=-=-=-=-=-=-=-=-  CONSTRUCTOR/DESTRUCTOR
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  modeLine
+ (id)modeLine;
/*"This is and "end of text". The contentsEnd and end are fixed to -1.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [[[self alloc] initWithString:@"" atCursor:nil] autorelease];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  initWithString:atCursor:
- (id)initWithString:(NSString *)aString atCursor:(unsigned *)cursorPtr;
/*"Designated initializer. The cursor is meant to point to the beginning of the line (typically given by a #{getLineStart:...} or 0)
on return, it will point to the beginning of the next line. If the cursor is nil, it is assumed to point to 0.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//NSLog(@"DEBUG initWithString: <%@> cursor: %#x, %u", aString, cursor, (cursor? *cursor: 0));
    if(self = [super init])
    {
        _StartOff7 = 0;
        _NumberOfSyntaxWords = 0;
        _MaxNumberOfSyntaxWords = _iTM2_MODE_BLOC_;
        size_t size = _MaxNumberOfSyntaxWords * sizeof(int);
		NSZone * myZone = [self zone];
        __SyntaxWordModes = NSZoneMalloc(myZone,size);
        size += sizeof(int);
        __SyntaxWordLengths = NSZoneMalloc(myZone,size);
        __SyntaxWordOff7s = NSZoneMalloc(myZone,size);
        if(!__SyntaxWordOff7s || !__SyntaxWordLengths || !__SyntaxWordModes)
        {
            iTM2_LOG(@"NOTHING!!!");
            _MaxNumberOfSyntaxWords = 0;
            NSZoneFree(myZone,__SyntaxWordOff7s);
            NSZoneFree(myZone,__SyntaxWordLengths);
            NSZoneFree(myZone,__SyntaxWordModes);
            __SyntaxWordOff7s = nil;
            __SyntaxWordLengths = nil;
            __SyntaxWordModes = nil;
            __SyntaxWordEnds = nil;
        }
        else
        {
            __SyntaxWordEnds = __SyntaxWordOff7s+1;
            __SyntaxWordLengths[0] = 0;
            __SyntaxWordLengths[1] = 0;
            __SyntaxWordModes[0] = 0;
            __SyntaxWordOff7s[0] = 0;
            __SyntaxWordOff7s[1] = 0;
        }
        if([aString length])
        {
            unsigned contents = 0;
            unsigned length = 0;
            if(cursorPtr)
            {
                _StartOff7 = *cursorPtr;
                unsigned start = MIN(* cursorPtr, [aString length]);
//NSLog(@"GLS 1");
                [aString getLineStart:nil end:cursorPtr contentsEnd:&contents forRange:NSMakeRange(start, 0)];
                length = *cursorPtr-start;
                contents -= start;
#ifdef __ELEPHANT_MODELINE__
#warning ELEPHANT MODE: For debugging purpose only... see iTM2TextStorageKit.h
				[originalString release];
				originalString = [[aString substringWithRange:NSMakeRange(start, *cursorPtr-start)] retain];
#endif
//iTM2_LOG(@"_Length is: %u, contents is: %u, *cursorPtr is: %u", _Length, contents, *cursorPtr);
            }
            else
            {
//NSLog(@"GLS 2");
                [aString getLineStart:nil end:&length contentsEnd:&contents forRange:NSMakeRange(0, 0)];
#ifdef __ELEPHANT_MODELINE__
#warning ELEPHANT MODE: For debugging purpose only... see iTM2TextStorageKit.h
				[originalString release];
				originalString = [[aString substringWithRange:NSMakeRange(0, length)] retain];
#endif
            }
            [self setStartOffset:0];
            [self setEOLLength:length-contents];
            [self appendSyntaxMode:kiTM2TextUnknownSyntaxMode length:contents];
        }
        else
        {
#ifdef __ELEPHANT_MODELINE__
#warning ELEPHANT MODE: For debugging purpose only...
			[originalString release];
			originalString = @"";
#endif
            [self setStartOffset:0];
            [self setEOLLength:0];
        }
		_UncommentedLength = _ContentsLength;
        _InvalidLocalRange = NSMakeRange(0, UINT_MAX);
        _PreviousMode = kiTM2TextUnknownSyntaxMode;
        _EOLMode = kiTM2TextUnknownSyntaxMode;
		_Status = 0;
		_Depth = 0;
    }
    //NSLog(@"DEBUG initWithString: END");
//[self describe];
    return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  dealloc
- (void)dealloc;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    free(__SyntaxWordOff7s);
    free(__SyntaxWordLengths);
    free(__SyntaxWordModes);
    __SyntaxWordOff7s = nil;
    __SyntaxWordLengths = nil;
    __SyntaxWordModes = nil;
    __SyntaxWordEnds = nil;
    _NumberOfSyntaxWords = 0;
#ifdef __ELEPHANT_MODELINE__
	[originalString release];
	originalString = nil;
#endif
    [super dealloc];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  swapContentsWithModeLine:
- (void)swapContentsWithModeLine:(iTM2ModeLine *)swapModeLine;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Sat Dec 13 10:35:39 GMT 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(iTM2DebugEnabled > 999999)
    {
        if([self diagnostic])
        {
            iTM2_LOG(@"BAD RECEIVER!!!!");
        }
        if([swapModeLine diagnostic])
        {
            iTM2_LOG(@"BAD ARGUMENT!!!!");
        }
        if(_ContentsLength != swapModeLine->_ContentsLength)
        {
            iTM2_LOG(@"!?!?!?!?!?! \n\n\n\nIT IS NOT A GOOD IDEA TO SWAP MODE LINES WITH DIFFERENT CONTENTS LENGTHS!!!!(mine: %u, his: %u)", _ContentsLength, swapModeLine->_ContentsLength);
        }
		// it is possible to swap mode lines with different EOL lengths
    }
    unsigned temp;
    #define _iTM2_SWAP(C, A, B) C=A;A=B;B=C;
//    _iTM2_SWAP(temp, _StartOff7, swapModeLine->_StartOff7);
//    _iTM2_SWAP(temp, _ContentsEndOff7, swapModeLine->_ContentsEndOff7);
//    _iTM2_SWAP(temp, _EndOff7, swapModeLine->_EndOff7);
//    _iTM2_SWAP(temp, _EOLLength, swapModeLine->_EOLLength);
//    _iTM2_SWAP(temp, _Length, swapModeLine->_Length);
    _iTM2_SWAP(temp, _ContentsLength, swapModeLine->_ContentsLength);
    _iTM2_SWAP(temp, _UncommentedLength, swapModeLine->_UncommentedLength);
//    _iTM2_SWAP(temp, _PreviousMode, swapModeLine->_PreviousMode);
//    _iTM2_SWAP(temp, _EOLMode, swapModeLine->_EOLMode);
    _iTM2_SWAP(temp, _NumberOfSyntaxWords, swapModeLine->_NumberOfSyntaxWords);
    _iTM2_SWAP(temp, _MaxNumberOfSyntaxWords, swapModeLine->_MaxNumberOfSyntaxWords);
    void * tempPtr;
    _iTM2_SWAP(tempPtr, __SyntaxWordOff7s, swapModeLine->__SyntaxWordOff7s);
    _iTM2_SWAP(tempPtr, __SyntaxWordLengths, swapModeLine->__SyntaxWordLengths);
    _iTM2_SWAP(tempPtr, __SyntaxWordModes, swapModeLine->__SyntaxWordModes);
    _iTM2_SWAP(tempPtr, __SyntaxWordEnds, swapModeLine->__SyntaxWordEnds);
    NSRange  tempRange;
    _iTM2_SWAP(tempRange, _InvalidLocalRange, swapModeLine->_InvalidLocalRange);
    // consistency:
    _Length = _ContentsLength+_EOLLength;
    _ContentsEndOff7 = _StartOff7+_ContentsLength;
    _EndOff7 = _StartOff7+_Length;
	if([self diagnostic])
    {
        iTM2_LOG(@"BAD SWAPPING METHOD!!!!");
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  describe
- (void)describe;
/*"Description forthcoming. Raises exception when things are not consistent.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
    iTM2_START;
    NSLog(@"_StartOff7: %u", _StartOff7);
    NSLog(@"_CommentOff7: %u", _CommentOff7);
    NSLog(@"_ContentsEndOff7: %u", _ContentsEndOff7);
    NSLog(@"_EndOff7: %u", _EndOff7);
    // local coordinates
    NSLog(@"_UncommentedLength: %u", _UncommentedLength);
    NSLog(@"_ContentsLength: %u", _ContentsLength);
    NSLog(@"_Length: %u", _Length);
    NSLog(@"_EOLLength: %u", _EOLLength);
    NSLog(@"_InvalidLocalRange: %@", NSStringFromRange(_InvalidLocalRange));
    // modes
    NSLog(@"_PreviousMode: %u", _PreviousMode);
    NSLog(@"_EOLMode: %u", _EOLMode);
    NSLog(@"_NumberOfSyntaxWords: %u", _NumberOfSyntaxWords);
    NSLog(@"_MaxNumberOfSyntaxWords: %u", _MaxNumberOfSyntaxWords);
    unsigned idx = 0;
    while(idx<_NumberOfSyntaxWords)
    {
        NSLog(@"idx: %4u, offset: %4u, end: %4u(= %4u), length: %4u, mode: %4i",
            idx, __SyntaxWordOff7s[idx], __SyntaxWordEnds[idx], __SyntaxWordOff7s[idx+1], __SyntaxWordLengths[idx], __SyntaxWordModes[idx]);
        ++idx;
    }
#ifdef __ELEPHANT_MODELINE__
	NSLog(@"originalString is: <%@>", originalString);
#endif
    iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  diagnostic
- (BOOL)diagnostic;
/*"Description forthcoming. Returns YES when things are not consistent.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(iTM2DebugEnabled < 10000)
		return NO;
    if(__SyntaxWordOff7s && (__SyntaxWordOff7s+1 != __SyntaxWordEnds))
    {
        iTM2_LOG(@"__SyntaxWordOff7s+1 (%u) != __SyntaxWordEnds (%u)", __SyntaxWordOff7s+1, __SyntaxWordEnds);
        goto bail;
    }
    if(_ContentsEndOff7 != _StartOff7+_ContentsLength)
    {
        iTM2_LOG(@"_ContentsEndOff7(%u) != _StartOff7(%u)+_ContentsLength(%u)", _ContentsEndOff7, _StartOff7, _ContentsLength);
        goto bail;
    }
    if(_EndOff7 != _StartOff7+_Length)
    {
        iTM2_LOG(@"_EndOff7(%u) != _StartOff7(%u)+_Length(%u)", _EndOff7, _StartOff7, _Length);
        goto bail;
    }
    if(_Length != _ContentsLength+_EOLLength)
    {
        iTM2_LOG(@"_Length(%u) != _ContentsLength(%u)+_EOLLength(%u)", _Length, _ContentsLength, _EOLLength);
        goto bail;
    }
    if(_NumberOfSyntaxWords)
    {
        if(!__SyntaxWordOff7s)
        {
            iTM2_LOG(@"NO __SyntaxWordOff7s!!!!!");
            goto bail;
        }

        unsigned idx = 0;
        while(idx<_NumberOfSyntaxWords)
            if(__SyntaxWordEnds[idx] != __SyntaxWordOff7s[idx]+__SyntaxWordLengths[idx])
            {
                iTM2_LOG(@"idx: %u, __SyntaxWordEnds[idx](%u) != __SyntaxWordOff7s[idx](%u)+__SyntaxWordLengths[idx](%u)", idx, __SyntaxWordEnds[idx], __SyntaxWordOff7s[idx], __SyntaxWordLengths[idx]);
                goto bail;
            }
            else
                ++idx;
		if( _InvalidLocalRange.location > _Length)
		{
			if(_ContentsLength != __SyntaxWordEnds[_NumberOfSyntaxWords-1])
			{
				iTM2_LOG(@"_ContentsLength(%u) != __SyntaxWordEnds[_NumberOfSyntaxWords-1](%u)", _ContentsLength, __SyntaxWordEnds[_NumberOfSyntaxWords-1]);
				goto bail;
			}
			if(_ContentsLength != __SyntaxWordOff7s[_NumberOfSyntaxWords])
			{
				iTM2_LOG(@"_ContentsLength(%u) != __SyntaxWordOff7s[%u](%u=%u)", _ContentsLength, _NumberOfSyntaxWords, __SyntaxWordOff7s[_NumberOfSyntaxWords], __SyntaxWordEnds[_NumberOfSyntaxWords-1]);
				unsigned idx = 0;
				while(idx <= _NumberOfSyntaxWords)
					NSLog(@"idx: %u, __SyntaxWordOff7s[idx]:%u", idx, __SyntaxWordOff7s[idx]),++idx;
				idx = 0;
				while(idx < _NumberOfSyntaxWords)
					NSLog(@"idx: %u, __SyntaxWordEnds[idx]:%u", idx, __SyntaxWordEnds[idx]), ++idx;
				goto bail;
			}
        }
    }
    return NO;
    bail:
    [self describe];
    return YES;
}
#pragma mark =-=-=-=-=-=-=-=-=-=-  SETTER/GETTER
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  startOffset
- (unsigned)startOffset;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return _StartOff7;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  setStartOffset:
- (void)setStartOffset:(unsigned)argument;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    _StartOff7 = argument;
    _ContentsEndOff7 = _StartOff7+_ContentsLength;
    _EndOff7 = _StartOff7+_Length;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  commentOffset
- (unsigned)commentOffset;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return _CommentOff7;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  uncommentedLength
- (unsigned)uncommentedLength;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return _UncommentedLength;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  setCommentStart:
- (void)setUncommentedLength:(unsigned)argument;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_END;
//iTM2_START;
    _UncommentedLength = argument;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  contentsEndOffset
- (unsigned)contentsEndOffset;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return _ContentsEndOff7;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  endOffset
- (unsigned)endOffset;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return _EndOff7;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  EOLLength
- (unsigned)EOLLength;
/*"Description forthcoming. The sum of all the wordLengths are assumed to be the EOLLength.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return _EOLLength;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  setEOLLength:
- (void)setEOLLength:(unsigned)argument;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    _EOLLength = argument;
    _Length = _ContentsLength+_EOLLength;
    _EndOff7 = _StartOff7+_Length;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  contentsLength
- (unsigned)contentsLength;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return _ContentsLength;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  length
- (unsigned)length;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return _Length;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  invalidLocalRange
- (NSRange)invalidLocalRange;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return _InvalidLocalRange;// In LOCAL coordinates
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  invalidGlobalRange
- (NSRange)invalidGlobalRange;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return NSMakeRange(_InvalidLocalRange.location+_StartOff7, _InvalidLocalRange.length);// In GLOBAL coordinates
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  validateLocalRange:
- (void)validateLocalRange:(NSRange)argument;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    unsigned maxInvalidRange = NSMaxRange(_InvalidLocalRange);
    if(argument.location <= _InvalidLocalRange.location)
    {
        // argument starts at the left of the actual _InvalidLocalRange
        unsigned maxArgument = NSMaxRange(argument);
        if(maxArgument < maxInvalidRange)
        {
            // argument ends in the interior of the actual _InvalidLocalRange
            _InvalidLocalRange.location = maxArgument;
            _InvalidLocalRange.length = maxInvalidRange-_InvalidLocalRange.location;
        }
        else
        {
            // argument ends at the right of the actual _InvalidLocalRange
            // everything is valid now
            _InvalidLocalRange.location = UINT_MAX;
            _InvalidLocalRange.length = 0;
        }
    }
    else if(argument.location < maxInvalidRange)
    {
        // argument starts in the interior of the actual _InvalidLocalRange
        // validation can occur only if argument ends at the right
        unsigned maxArgument = argument.location+argument.length;
        if(maxArgument >= maxInvalidRange)
        {
            // argument ends in the interior of the actual _InvalidLocalRange
            _InvalidLocalRange.length = argument.location-_InvalidLocalRange.location;
        }
    }
    if(!_InvalidLocalRange.length)
    {
        if(_InvalidLocalRange.location < _Length)
            _InvalidLocalRange.length = 1;
        else
            _EOLMode = 1;
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  validateGlobalRange:
- (void)validateGlobalRange:(NSRange)argument;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    argument = NSIntersectionRange(argument, NSMakeRange(_StartOff7, _Length));
    argument.location -= _StartOff7;
    [self validateLocalRange:argument];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  invalidateGlobalRange:
- (void)invalidateGlobalRange:(NSRange)argument;
/*"Description forthcoming. argument is global.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(argument.location>1)
	{
		argument.location-=2;
		argument.length+=2;
	}
	else if(argument.location>0)
	{
		argument.location-=1;
		argument.length+=1;
	}
    argument = NSIntersectionRange(argument, NSMakeRange(_StartOff7, _Length));
    if(!argument.length)
        return;
    argument.location -= _StartOff7;
    _InvalidLocalRange = _InvalidLocalRange.length? NSUnionRange(_InvalidLocalRange, argument): argument;
	if(_InvalidLocalRange.location<=_UncommentedLength)
		_UncommentedLength = _ContentsLength;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  invalidateLocalRange:
- (void)invalidateLocalRange:(NSRange)argument;
/*"Description forthcoming. argument is global.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(argument.location>1)
	{
		argument.location-=2;
		argument.length+=2;
	}
	else if(argument.location>0)
	{
		argument.location-=1;
		argument.length+=1;
	}
    argument = NSIntersectionRange(argument, NSMakeRange(0, _Length));
    if(!argument.length)
        return;
    _InvalidLocalRange = _InvalidLocalRange.length? NSUnionRange(_InvalidLocalRange, argument): argument;
	if(_InvalidLocalRange.location<=_UncommentedLength)
		_UncommentedLength = _ContentsLength;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  previousMode
- (unsigned)previousMode;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return _PreviousMode | kiTM2TextEndOfLineSyntaxMask;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  setPreviousMode:
- (void)setPreviousMode:(unsigned)argument;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    _PreviousMode = argument | kiTM2TextEndOfLineSyntaxMask;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  EOLMode
- (unsigned)EOLMode;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return _EOLMode | kiTM2TextEndOfLineSyntaxMask;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  setEOLMode:
- (void)setEOLMode:(unsigned)argument;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    _EOLMode = argument | kiTM2TextEndOfLineSyntaxMask;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  hasNewLine
- (BOOL)hasNewLine;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return _Length > _EOLLength;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  numberOfSyntaxWords
- (unsigned)numberOfSyntaxWords;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return _NumberOfSyntaxWords;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  status
- (unsigned int)status;
/*"Description forthcoming.jlaurens AT users DOT sourceforge DOT net"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return _Status;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  setStatus:
- (void)setStatus:(unsigned int)argument;
/*"Description forthcoming.jlaurens AT users DOT sourceforge DOT net"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    _Status = argument;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  depth
- (int)depth;
/*"Description forthcoming.jlaurens AT users DOT sourceforge DOT net"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return _Depth;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  setDepth:
- (void)setDepth:(int)argument;
/*"Description forthcoming.jlaurens AT users DOT sourceforge DOT net"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    _Depth = argument;
    return;
}
#ifdef __ELEPHANT_MODELINE__
#warning ELEPHANT MODE: For debugging purpose only... see iTM2TextStorageKit.h
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  originalString
- (NSString *)originalString;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return originalString;
}
#endif
#pragma mark =-=-=-=-=-=-=-=-=-=-  MODES/LENGTHS
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  syntaxLengthAtIndex
- (unsigned)syntaxLengthAtIndex:(unsigned)idx;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return (idx < _NumberOfSyntaxWords)? __SyntaxWordLengths[idx]:(idx? 0:[self contentsLength]);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  syntaxModeAtIndex
- (unsigned)syntaxModeAtIndex:(unsigned)idx;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return (idx < _NumberOfSyntaxWords)? __SyntaxWordModes[idx]:_EOLMode;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  moreStorage
- (BOOL)moreStorage;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    _MaxNumberOfSyntaxWords += _iTM2_MODE_BLOC_;
    size_t size = _MaxNumberOfSyntaxWords * sizeof(int);
	NSZone * myZone = [self zone];
    __SyntaxWordLengths = __SyntaxWordLengths? NSZoneRealloc(myZone,__SyntaxWordLengths, size): NSZoneMalloc(myZone,size);
    __SyntaxWordModes = __SyntaxWordModes? NSZoneRealloc(myZone,__SyntaxWordModes, size): NSZoneMalloc(myZone,size);
    size += sizeof(int);
    __SyntaxWordOff7s = __SyntaxWordOff7s? NSZoneRealloc(myZone,__SyntaxWordOff7s, size): NSZoneMalloc(myZone,size);
    if(!__SyntaxWordOff7s || !__SyntaxWordLengths || !__SyntaxWordModes)
    {
        if(iTM2DebugEnabled > 999999)
        {
            iTM2_LOG(@"ALLOCATION FAILURE NOTHING!!!");
        }
       _MaxNumberOfSyntaxWords = 0;
        _NumberOfSyntaxWords = 0;
        free(__SyntaxWordOff7s);
        free(__SyntaxWordLengths);
        free(__SyntaxWordModes);
        __SyntaxWordOff7s = nil;
        __SyntaxWordLengths = nil;
        __SyntaxWordModes = nil;
        __SyntaxWordEnds = nil;
        return NO;
    }
    else
        __SyntaxWordEnds = __SyntaxWordOff7s+1;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  appendSyntaxMode:length:
- (void)appendSyntaxMode:(unsigned)mode length:(unsigned)length;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_Start;
//iTM2_LOG(@"length: %u", length);
//[self describe];
//NSLog(@"[self wordLengths]:%@ (%u)", [self wordLengths], [[self wordLengths] length]);
//NSLog(@"[self modes]:%@ (%u)", [self modes], [[self modes] length]);
    if(!length)
        return;
	_iTM2InternalAssert(![self diagnostic], @"****  Will not append a mode");
    if(_NumberOfSyntaxWords == _MaxNumberOfSyntaxWords)
    {
        _MaxNumberOfSyntaxWords += _iTM2_MODE_BLOC_;
        size_t size = _MaxNumberOfSyntaxWords * sizeof(int);
		NSZone * myZone = [self zone];
        __SyntaxWordLengths = __SyntaxWordLengths? NSZoneRealloc(myZone,__SyntaxWordLengths, size): NSZoneMalloc(myZone,size);
        __SyntaxWordModes = __SyntaxWordModes? NSZoneRealloc(myZone,__SyntaxWordModes, size): NSZoneMalloc(myZone,size);
        size += sizeof(int);
        __SyntaxWordOff7s = __SyntaxWordOff7s? NSZoneRealloc(myZone,__SyntaxWordOff7s, size): NSZoneMalloc(myZone,size);
        if(!__SyntaxWordOff7s || !__SyntaxWordLengths || !__SyntaxWordModes)
        {
            iTM2_LOG(@"NOTHING!!!");
            _MaxNumberOfSyntaxWords = 0;
            _NumberOfSyntaxWords = 0;
            free(__SyntaxWordOff7s);
            free(__SyntaxWordLengths);
            free(__SyntaxWordModes);
            __SyntaxWordOff7s = nil;
            __SyntaxWordLengths = nil;
            __SyntaxWordModes = nil;
            __SyntaxWordEnds = nil;
        }
        else
            __SyntaxWordEnds = __SyntaxWordOff7s+1;
    }
	if(_NumberOfSyntaxWords && (__SyntaxWordModes[_NumberOfSyntaxWords-1] == mode))
	{
		__SyntaxWordLengths[_NumberOfSyntaxWords-1] += length;
		if(_UncommentedLength >= __SyntaxWordOff7s[_NumberOfSyntaxWords])
			_UncommentedLength += length;
		__SyntaxWordOff7s[_NumberOfSyntaxWords] += length;
	}
    else if(__SyntaxWordLengths)
    {
		if(_UncommentedLength >= _ContentsLength)
			_UncommentedLength += length;
		__SyntaxWordLengths[_NumberOfSyntaxWords] = length;
		__SyntaxWordModes[_NumberOfSyntaxWords] = mode;
		__SyntaxWordOff7s[_NumberOfSyntaxWords] = _NumberOfSyntaxWords? __SyntaxWordLengths[_NumberOfSyntaxWords-1]+__SyntaxWordOff7s[_NumberOfSyntaxWords-1]:0;
		++_NumberOfSyntaxWords;
		// fixing the last offset
		__SyntaxWordOff7s[_NumberOfSyntaxWords] = __SyntaxWordLengths[_NumberOfSyntaxWords-1]+__SyntaxWordOff7s[_NumberOfSyntaxWords-1];
    }
	_ContentsLength += length;
	_Length = _ContentsLength+_EOLLength;
	_EndOff7 = _StartOff7+_Length;
	_ContentsEndOff7 = _StartOff7+_ContentsLength;
//iTM2_END;
//[self describe];
	_iTM2InternalAssert(![self diagnostic], @"****  Could not append a mode");
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  removeLastMode
- (BOOL)removeLastMode;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_Start;
	if(_NumberOfSyntaxWords)
	{
        if([self diagnostic])
        {
            iTM2_LOG(@"****  INTERNAL INCONSISTENCY: Deleting last mode on a bad mode line");
        }
		NSAssert(__SyntaxWordLengths, @"****  INTERNAL INCONSISTENCY: unexpected lack of storage for modes");
		unsigned lastLength = __SyntaxWordLengths[--_NumberOfSyntaxWords];
		NSAssert(_ContentsLength >= lastLength, @"****  INTERNAL INCONSISTENCY: unexpected lack of storage for modes");
		_ContentsLength -= lastLength;
		if(_UncommentedLength >= _ContentsLength)
			_UncommentedLength = _ContentsLength;
		_Length = _ContentsLength+_EOLLength;
		_EndOff7 = _StartOff7+_Length;
		_ContentsEndOff7 = _StartOff7+_ContentsLength;
        if([self diagnostic])
        {
            iTM2_LOG(@"****  INTERNAL INCONSISTENCY: Deleting last mode results in a bad mode line");
        }
		return YES;
    }
//iTM2_END;
//[self describe];
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  enlargeSyntaxModeAtGlobalLocation:length:
- (BOOL)enlargeSyntaxModeAtGlobalLocation:(unsigned)aGlobalLocation length:(unsigned)lengthOffset;
/*Adds length to the length at global location aGlobalLocation.
It is relative to the beginning of the line. Other locations mean new line char insertions.
The attribute value at aGlobalLocation won't change once the message is sent!!! It simply finds the "word" containing
MAX(1, aGlobalLocation)-1, then adds the correct value to its length. The previous attribute is continued except for the first one (at location 0).
Although this is a data model method, the wordLengths are updated.
No range is invalidated.
This choice is motivated by the observation that in general, you append something to the previous syntax mode.
Version History: jlaurens AT users DOT sourceforge DOT net (11/07/01)
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_LOG(@"aGlobalLocation: %u, lengthOffset: %u", aGlobalLocation, lengthOffset);
//[self describe];
    if(!lengthOffset)
    {
        iTM2_LOG(@"%%-%%-%%-%%-%%  d:) NOTHING TO ENLARGE");
        return NO;
    }
    else if(aGlobalLocation<_StartOff7)
    {
        iTM2_LOG(@"%%-%%-%%-%%-%%  d:) I AM NOT CONCERNED: aGlobalLocation is: %u and my off7 is: %u", aGlobalLocation, _StartOff7);
        return NO;
    }
    else if(aGlobalLocation < _ContentsEndOff7)
    {
        if([self diagnostic])
        {
            iTM2_LOG(@"%%-%%-%%-%%-%%  d:( Evidemment avec un mode line merdique, c'est la foire!!!!!");
        }
        // we look for an idx such that
        // _StartOff7+__SyntaxWordsOff7s[idx] <= aGlobalLocation < _StartOff7+__SyntaxWordEnds[idx]
        unsigned localLocation = aGlobalLocation-_StartOff7;
        unsigned left = 0;
        unsigned right = _NumberOfSyntaxWords;
        unsigned delta;
        unsigned idx;
        // we have
        // _StartOff7+__SyntaxWordOff7s[left] <= aGlobalLocation < _StartOff7+__SyntaxWordOff7s[_NumberOfSyntaxWords] = _ContentsEndOff7
        while(delta = (right-left)/2)
        {
            idx = left+delta;
            if (__SyntaxWordOff7s[idx] > localLocation)
                right = idx;
            else
                left = idx;
        }
        // the stopping condition <=> right == left+1
        // at each iteration left < right
        // as _StartOff7 <= aGlobalLocation < _ContentsEndOff7
        // we have 0 < _NumberOfSyntaxWords and at starting time left < right _NumberOfSyntaxWords = 1
        // The loop is not run when right = left+1, which means that there is only one word
        // HERE WE HAVE:
        // _StartOff7+__SyntaxWordOff7s[left] <= aGlobalLocation < _StartOff7+__SyntaxWordOff7s[right]
//[self describe];
		// what about the comment management?
		// we consider that modifications in syntax words represent appending
		// It would not cause any problem if we assume that the comments _UncommentedLength is the character index of a syntax word bound
		if(_UncommentedLength >= __SyntaxWordOff7s[right])
			_UncommentedLength += lengthOffset;
        idx = left;
        __SyntaxWordLengths[idx] += lengthOffset;
		// then propagate the change
//iTM2_LOG(@"AFTER -------  %u(idx = %u)", __SyntaxWordLengths[idx], idx);
        do
        {
            __SyntaxWordEnds[idx] += lengthOffset;
        }
        while(++idx<_NumberOfSyntaxWords);
        _ContentsLength += lengthOffset;
        _Length = _ContentsLength+_EOLLength;
        _EndOff7 = _StartOff7+_Length;
        _ContentsEndOff7 = _StartOff7+_ContentsLength;
        if([self diagnostic])
        {
            iTM2_LOG(@"%%-%%-%%-%%-%%  d:( BAD THING HAPPENING: pas enlarge mode!!!");
        }
        return YES;
    }
    else if(aGlobalLocation == _ContentsEndOff7)
    {
        if([self diagnostic])
        {
            iTM2_LOG(@"%%-%%-%%-%%-%%  d:( Evidemment avec un mode line merdique, APPEND c'est la foire!!!!!");
        }
        if(_NumberOfSyntaxWords)
        {
            unsigned idx = _NumberOfSyntaxWords-1;
            __SyntaxWordLengths[idx] += lengthOffset;
			if(_UncommentedLength >= __SyntaxWordEnds[idx])
				_UncommentedLength += lengthOffset;
            __SyntaxWordEnds[idx] += lengthOffset;
            _ContentsLength += lengthOffset;
            _Length = _ContentsLength+_EOLLength;
            _EndOff7 = _StartOff7+_Length;
            _ContentsEndOff7 = _StartOff7+_ContentsLength;
        }
        else
        {
            [self appendSyntaxMode:kiTM2TextUnknownSyntaxMode length:lengthOffset];
            if([self diagnostic])
            {
                iTM2_LOG(@"%%-%%-%%-%%-%%  d:( PAS FOUTU d'APPENDER!!!");
            }
        }
        return YES;
    }
    else
    {
        iTM2_LOG(@"%%-%%-%%-%%-%%  d:) REFUSED TO ENLARGE AN EOL");
        return NO;
    }
//iTM2_END;
//[self describe];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  longestRangeAtGlobalLocation:mask:
- (NSRange)longestRangeAtGlobalLocation:(unsigned)aGlobalLocation mask:(unsigned int)mask;
/*"Description forthcoming. aGlobalLocation is global.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	unsigned mode;
	NSRange range;
	NSRange result = NSMakeRange(NSNotFound,0);
	if([self getSyntaxMode:&mode atGlobalLocation:aGlobalLocation longestRange:&range])
	{
		return result;
	}
	if(mode&mask==0)
	{
		return result;
	}
	result = range;
	while(result.location>_StartOff7)
	{
		[self getSyntaxMode:&mode atGlobalLocation:result.location-1 longestRange:&range];
		if(mode&mask)
		{
			result.length+=range.location;
			result.location=range.location;
		}
		else
		{
			break;
		}
	}
	unsigned top = NSMaxRange(result);
	while(top<_EndOff7)
	{
		[self getSyntaxMode:&mode atGlobalLocation:top longestRange:&range];
		if(mode&mask)
		{
			result.length+=range.location;
			top = NSMaxRange(result);
		}
		else
		{
			break;
		}
	}
	
//iTM2_END;
	return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  getSyntaxMode:atGlobalLocation:longestRange:
- (unsigned)getSyntaxMode:(unsigned *)modeRef atGlobalLocation:(unsigned)aGlobalLocation longestRange:(NSRangePointer)aRangePtr;
/*"Description forthcoming. aGlobalLocation is global.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(aGlobalLocation<_StartOff7)
    {
        if(aRangePtr)
		{
            * aRangePtr = NSMakeRange(aGlobalLocation, _StartOff7-aGlobalLocation);
		}
		iTM2_LOG(@"**** UNEXPECTED LOCATION OUT OF BOUNDS: unsatisfied %u <= aGlobalLocation(%u)", _StartOff7, aGlobalLocation);
		if(modeRef)
		{
			*modeRef = _PreviousMode;
		}
		return kiTM2TextOutOfRangeSyntaxStatus;
    }
    else if(aGlobalLocation < _ContentsEndOff7)
    {
        // _StartOff7 <= aGlobalLocation < _EndOff7
        if(_NumberOfSyntaxWords)
        {
			unsigned localLocation = aGlobalLocation-_StartOff7;
            unsigned left = 0;
            unsigned right = _NumberOfSyntaxWords;
            unsigned idx = left;
            unsigned delta;
            // we start with: 
            // > left < right (if not insconsistent)
            // > __SyntaxWordOff7s[left = 0] <= localLocation < __SyntaxWordOff7s[right = _NumberOfSyntaxWords] = _ContentsEndOff7
			if(delta = (right-left)/2)
			{
pano1:
				idx = left+delta;
				// left <= idx < right
				// left < idx < left+2 * delta ≤ right
				if(__SyntaxWordOff7s[idx]>localLocation)
				{
					right = idx;
					// here we have
					// left < right = idx
					// __SyntaxWordOff7s[left] <= localLocation < __SyntaxWordOff7s[right = idx]
					if(delta = (right-left)/2)
					{
pano2:
						idx = left+delta;
						// left <= idx < right
						// left < idx < left+2 * delta ≤ right
						if(__SyntaxWordOff7s[idx]>localLocation)
						{
							right = idx;
							// here we have
							// left < right = idx
							// __SyntaxWordOff7s[left] <= localLocation < __SyntaxWordOff7s[right = idx]
						}
						else
						{
							left = idx;
							// here we have
							// left = idx < right
							// __SyntaxWordOff7s[left = idx] <= localLocation < __SyntaxWordOff7s[right]
						}
						if(delta = (right-left)/2)
							goto pano2;
						// No EOL
					}
					if(aRangePtr)
						 * aRangePtr = NSMakeRange(_StartOff7+__SyntaxWordOff7s[left], __SyntaxWordLengths[left]);
					if(modeRef)
					{
						*modeRef = __SyntaxWordModes[left];
					}
					return kiTM2TextNoErrorSyntaxStatus;
				}
				else
				{
					left = idx;
					// here we have
					// left = idx < right
					// __SyntaxWordOff7s[left = idx] <= localLocation < __SyntaxWordOff7s[right]
					if(delta = (right-left)/2)
						goto pano1;
					// stop with
					// left == idx == right-1;
					// because right has never been changed
					// __SyntaxWordOff7s[idx] <= localLocation < __SyntaxWordOff7s[idx+1]
				}
			}
			unsigned result = __SyntaxWordModes[left];
			if(aRangePtr)
			{
				* aRangePtr = NSMakeRange(_StartOff7+__SyntaxWordOff7s[left], __SyntaxWordLengths[left]);
			}
			if(modeRef)
			{
				*modeRef = result;
			}
			return kiTM2TextNoErrorSyntaxStatus;
        }
        else
        {
            if(aRangePtr)
            {
                * aRangePtr = NSMakeRange(_StartOff7, _Length);
            }
			if(modeRef)
			{
				*modeRef = _PreviousMode;
			}
			return kiTM2TextNoErrorSyntaxStatus;
        }
    }
    else if(aGlobalLocation < _EndOff7)
    {
        if(aRangePtr)
		{
            * aRangePtr = NSMakeRange(_ContentsEndOff7, _EOLLength);
		}
		if(modeRef)
		{
			*modeRef = _EOLMode;
		}
		return kiTM2TextNoErrorSyntaxStatus;
    }
    else
    {
        if(aRangePtr)
		{
            * aRangePtr = NSMakeRange(aGlobalLocation, 0);
		}
		if(aGlobalLocation > _EndOff7)
		{
			iTM2_LOG(@"**** UNEXPECTED LOCATION OUT OF BOUNDS: unsatisfied aGlobalLocation (%u) <= endOffset (%u)", aGlobalLocation, _EndOff7);
		}
		if(modeRef)
		{
			*modeRef = _EOLMode;
		}
		return kiTM2TextRangeExceededSyntaxStatus;
    }
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  getPreviousSyntaxMode:notEqualTo:atGlobalLocation:longestRange:
- (unsigned)getPreviousSyntaxMode:(unsigned *)modeRef notEqualTo:(unsigned)excludeMode atGlobalLocation:(unsigned)aGlobalLocation longestRange:(NSRangePointer)aRangePtr;
/*"Description forthcoming. aGlobalLocation is global.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSRange r;
	unsigned mode;
	unsigned status = [self getSyntaxMode:&mode atGlobalLocation:aGlobalLocation longestRange:&r];
	if(status == kiTM2TextMissingModeSyntaxStatus)
	{
		if(aRangePtr)
		{
			* aRangePtr = NSMakeRange(NSNotFound,0);
		}
		return status;
	}
	if(mode == excludeMode)
	{
		return kiTM2TextMissingModeSyntaxStatus;
	}
	if(aRangePtr)
	{
   		aRangePtr->length = NSMaxRange(r);// just record the last index: aRangePtr is not yet a real range pointer
next:
		aRangePtr->location = r.location;
		if(aRangePtr->location > _StartOff7)
		{
			status = [self getSyntaxMode:&mode atGlobalLocation:aRangePtr->location-1 longestRange:&r];
			if((status == kiTM2TextMissingModeSyntaxStatus) || (mode == excludeMode))
			{
				aRangePtr->length -= aRangePtr->location;// now this is a real range
				return kiTM2TextNoErrorSyntaxStatus;
			}
			if(modeRef)
			{
				*modeRef = mode;
			}
			goto next;
		}
		aRangePtr->length -= aRangePtr->location;// now this is a real range
	}
	return status;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  deleteModesInRange:
- (BOOL)deleteModesInRange:(NSRange)deleteRange;
/*"Description forthcoming. deleteRange is in global coordinates.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
#warning THIS IS ACTUALLY BUGGY, really? it seems to work well...
    // preparation for simple cases
    if(!deleteRange.length)
    // nothing to remove
        return NO;
    else if(_EndOff7 <= deleteRange.location)
    // everything is removed from the right part
        return NO;
    // deleteRange.location < _EndOff7
    unsigned maxDeleteRange = NSMaxRange(deleteRange);
	// maxDeleteRange is the index of the first character kept after the deleted range
    if(maxDeleteRange <= _StartOff7 )
    {
        // only offset is affected
		// we do not need to change any other cached information
        [self setStartOffset:_EndOff7-deleteRange.length];
        return NO;
    }
    // _StartOff7 < maxDeleteRange
    // we remove any kind of EOL
    else if(_EndOff7 <= deleteRange.location )
    {
		// everything is deleted after the receiver such that it is not affected
        return NO;
    }
    else if(_ContentsEndOff7 <= deleteRange.location )
    {
        // only EOL is affected
        unsigned removed = MIN(maxDeleteRange, _EndOff7)-deleteRange.location;
        [self setEOLLength:_EOLLength-removed];
        return YES;// We always have removed>0 due to the previous test;
    }
    // Now we have
	// deleteRange.location < _ContentsEndOff7
	// and there is something to be removed
    else if(_ContentsEndOff7 < maxDeleteRange)
    {
        // EOL is affected but it is not completely removed
        unsigned removed = MIN(maxDeleteRange, _EndOff7)-_ContentsEndOff7;
        [self setEOLLength:_EOLLength-removed];
		if(_ContentsEndOff7 > deleteRange.location)
		{
			// we modify the deleteRange to remove the EOL part
			deleteRange.length = _ContentsEndOff7-deleteRange.location;
			maxDeleteRange = _ContentsEndOff7;
		}
		else
			// there is nothing left to be removed
			return YES;
    }
    // Now we have
    // _StartOff7 < maxDeleteRange <= _ContentsEndOff7
	NSAssert(_NumberOfSyntaxWords>0, @"Inconsistency");
    // and
	// deleteRange.location < _ContentsEndOff7
	if(_StartOff7>deleteRange.location)
	{
		// we are deleting from the left
		// we remove the part that does not concern the receiver
		deleteRange.location=_StartOff7;
		deleteRange.length=maxDeleteRange-deleteRange.location;
	}
    // Now we have
    // _StartOff7 ≤ deleteRange.location < maxDeleteRange <= _ContentsEndOff7
	// make the deleteRange in local coordinates
	deleteRange.location -= _StartOff7;
	// we are scanning the syntax words 3 times
	// twice for deleting, first to delete the modes and second to delete void syntax words
	// Finally once for fixing the consistency
	unsigned idx = 0;
	NSRange R;
fautea:
	//
	R = NSMakeRange(__SyntaxWordOff7s[idx], __SyntaxWordLengths[idx]);
	R = NSIntersectionRange(deleteRange, R);
	if(R.length)
	{
		__SyntaxWordLengths[idx]-=R.length;
canella:
		if(++idx<_NumberOfSyntaxWords)
		{
			R = NSMakeRange(__SyntaxWordOff7s[idx], __SyntaxWordLengths[idx]);
			R = NSIntersectionRange(deleteRange, R);
			if(R.length)
			{
				__SyntaxWordLengths[idx]-=R.length;
				goto canella;
			}
			// no more syntax word will be modified
		}
	}
	else if(++idx<_NumberOfSyntaxWords)
		goto fautea;
	// Now deleting the 0 length syntax words
	idx = 0;
	unsigned target=0;
capiciola:
	if(!__SyntaxWordLengths[idx])
	{
		target=idx;
tarco:
		if(++idx<_NumberOfSyntaxWords)
		{
			if(__SyntaxWordLengths[idx])
			{
propriano:
				__SyntaxWordLengths[target]=__SyntaxWordLengths[idx];
				__SyntaxWordModes[target]=__SyntaxWordModes[idx];
				++target;
				if(++idx<_NumberOfSyntaxWords)
					goto propriano;
			}
			else
				goto tarco;
		}
		_NumberOfSyntaxWords=target;
	}
	else if(++idx<_NumberOfSyntaxWords)
		goto capiciola;
	// now fixing the consistency
	idx = 0;
	__SyntaxWordEnds[idx]=__SyntaxWordOff7s[idx]+__SyntaxWordLengths[idx];
	while(++idx<_NumberOfSyntaxWords)
	{
		__SyntaxWordEnds[idx]=__SyntaxWordOff7s[idx]+__SyntaxWordLengths[idx];
	}
    _ContentsLength -= deleteRange.length;
    _UncommentedLength = _ContentsLength;// no management here
    _Length = _ContentsLength+_EOLLength;
    // _EOLLength = _EOLLength;
    _ContentsEndOff7 = _StartOff7+_ContentsLength;
    _EndOff7 = _StartOff7+_Length;
	if([self diagnostic])
    {
        iTM2_LOG(@">>>>>    Z|;-> -1- BAD MODE LINE!!!!");
    }
//	[self description];
    return YES;
}
@end
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2TextStorageKit

NSString * const iTM2TextStyleComponent = @"Styles.localized";

NSString * const iTM2TextStyleExtension = @"iTM2-Style";
NSString * const iTM2TextVariantExtension = @"iTM2-Variant";

NSString * const iTM2TextAttributesPathExtension = @"rtf";
NSString * const iTM2TextAttributesModesComponent = @"modes";

NSString * const iTM2TextAttributesDidChangeNotification = @"iTM2TextAttributesDidChange";

NSString * const iTM2TextDefaultVariant = @"default";

NSString * const iTM2TextAttributesServerType = @"_AS";

#import <iTM2Foundation/iTM2FileManagerKit.h>

@implementation iTM2TextSyntaxParser(Attributes)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  defaultModesAttributes
+ (NSDictionary *)defaultModesAttributes;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSDictionary * regular = [NSDictionary dictionaryWithObjectsAndKeys:
        [NSFont systemFontOfSize:[NSFont systemFontSize]], NSFontAttributeName,
        [NSColor blackColor], NSForegroundColorAttributeName,
        iTM2TextDefaultSyntaxModeName, iTM2TextModeAttributeName,
            nil];
    NSDictionary * error = [NSDictionary dictionaryWithObjectsAndKeys:
        [NSFont systemFontOfSize:[NSFont systemFontSize]], NSFontAttributeName,
        [NSColor redColor], NSForegroundColorAttributeName,
        iTM2TextErrorSyntaxModeName, iTM2TextModeAttributeName,
            nil];
    NSDictionary * _selection = [NSDictionary dictionaryWithObjectsAndKeys:
        iTM2TextSelectionSyntaxModeName, iTM2TextModeAttributeName,
            nil];
    NSDictionary * _whitePrefix = [NSDictionary dictionaryWithObjectsAndKeys:
        [NSFont userFixedPitchFontOfSize:[NSFont systemFontSize]], NSFontAttributeName,
        iTM2TextWhitePrefixSyntaxModeName, iTM2TextModeAttributeName,
            nil];
    NSDictionary * _background = [NSDictionary dictionaryWithObjectsAndKeys:
        iTM2TextBackgroundSyntaxModeName, iTM2TextModeAttributeName,
            nil];
    NSDictionary * _insertion = [NSDictionary dictionaryWithObjectsAndKeys:
        iTM2TextInsertionSyntaxModeName, iTM2TextModeAttributeName,
            nil];
    return [NSDictionary dictionaryWithObjectsAndKeys:
            regular, [regular objectForKey:iTM2TextModeAttributeName],
            error,	[error   objectForKey:iTM2TextModeAttributeName], 
            _whitePrefix,   [_whitePrefix   objectForKey:iTM2TextModeAttributeName], 
            _selection,   [_selection   objectForKey:iTM2TextModeAttributeName], 
            _insertion,   [_insertion   objectForKey:iTM2TextModeAttributeName], 
            _background,   [_background   objectForKey:iTM2TextModeAttributeName], nil];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= attributesServerWithStyle:variant:
+ (id)attributesServerWithStyle:(NSString  *)style variant:(NSString *)variant;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    style = [style length]? [style lowercaseString]:[iTM2TextDefaultStyle lowercaseString];
    variant = [variant length]? [variant lowercaseString]:[iTM2TextDefaultVariant lowercaseString];
    if(![[_iTM2TextObjectServer keyEnumeratorForType:style] nextObject])
    {
//iTM2_LOG(@"INITIALIZING ATTRIBUTES SERVERS FOR STYLE: %@", style);
        Class C = [[self syntaxParserClassForStyle:style] attributesServerClass];
//iTM2_LOG(@"C: %@", C);
        NSEnumerator * E = [[self syntaxParserVariantsForStyle:style] objectEnumerator];
        NSString * variant1;
        while(variant1 = [E nextObject])
		{
//iTM2_LOG(@"variant1: %@", variant1);
            [_iTM2TextObjectServer registerObject:[[[C alloc] initWithVariant:variant1] autorelease]
                forType: style key: [variant1 lowercaseString] retain:YES];
		}
    }
    id result = [_iTM2TextObjectServer objectForType:style key:variant];
    if(![result isKindOfClass:[iTM2TextSyntaxParserAttributesServer class]])
        result = [_iTM2TextObjectServer objectForType:style key:iTM2TextDefaultVariant];
    if(!result)
    {
        NSString * newStyle = [style stringByDeletingPathExtension];
        if([newStyle length] < [style length])
            return [_iTM2TextObjectServer objectForType:newStyle key:variant];
        else if(![style isEqualToString:iTM2TextDefaultStyle])
            return [_iTM2TextObjectServer objectForType:iTM2TextDefaultStyle key:variant];
        iTM2_LOG(@"AN INCONSISTENCY WAS FOUND: missing variant %@ for style %@", variant, style);
    }
//iTM2_END;
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= createAttributesServerWithStyle:variant:
+ (void)createAttributesServerWithStyle:(NSString  *)style variant:(NSString *)variant;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    style = [[self syntaxParserClassForStyle:style] syntaxParserStyle];// trick to retrieve the case sensitive style
	NSString * directory = [[iTM2TextStyleComponent stringByAppendingPathComponent:style]
								stringByAppendingPathExtension: iTM2TextStyleExtension];
	NSString * support = [[NSBundle mainBundle] pathForSupportDirectory:directory inDomain:NSUserDomainMask create:YES];
    NSString * stylePath = [support stringByAppendingPathComponent:variant];
    stylePath = [stylePath stringByAppendingPathExtension:iTM2TextVariantExtension];
	NSError * localError = nil;
    if([DFM createDeepDirectoryAtPath:stylePath attributes:nil error:&localError])
    {
        Class C = [[self syntaxParserClassForStyle:style] attributesServerClass];
        id O = [[[C alloc] initWithVariant:variant] autorelease];
        [_iTM2TextObjectServer registerObject:O forType:[style lowercaseString] key:[variant lowercaseString] retain:YES];
        [INC postNotificationName:iTM2TextAttributesDidChangeNotification object:nil userInfo:
            [NSDictionary dictionaryWithObjectsAndKeys:style, @"style", variant, @"variant", nil]];
    }
    else if(localError)
    {
        iTM2_LOG(@"Could not create variant: %@ due to %@", variant, [localError localizedFailureReason]);
    }
    else
    {
        iTM2_LOG(@"Could not create variant: %@", variant);
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= removeAttributesServerWithStyle:variant:
+ (void)removeAttributesServerWithStyle:(NSString  *)style variant:(NSString *)variant;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_LOG(@"style: %@, variant: %@", style, variant);
    [_iTM2TextObjectServer unregisterObjectForType:[style lowercaseString] key:[variant lowercaseString]];
    style = [[self syntaxParserClassForStyle:style] syntaxParserStyle];// trick to retrieve the case sensitive style
    NSString * stylePath = [[[NSBundle mainBundle] pathsForSupportResource:variant ofType:iTM2TextVariantExtension
	inDirectory: [[iTM2TextStyleComponent stringByAppendingPathComponent:style] stringByAppendingPathExtension:iTM2TextStyleExtension]
		domains: NSUserDomainMask] lastObject];
    if(![DFM removeFileAtPath:stylePath handler:DFM])
    {
        iTM2_LOG(@"Could not remove file at path: %@\nPlease, do it for me... TIA", stylePath);
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= syntaxParserVariantsForStyle:
+ (NSDictionary *)syntaxParserVariantsForStyle:(NSString  *)style;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    style = [style lowercaseString];
    NSMutableDictionary * MD = [NSMutableDictionary dictionary];
    NSEnumerator * E = [_iTM2TextObjectServer objectEnumeratorForType:style];
    id TAS;// for Text Attributes Server
    while(TAS = [E nextObject])
	{
		NSString * variant = [TAS syntaxParserVariant];
        [MD setObject:variant forKey:[variant lowercaseString]];
	}
    if(![MD count])
    {
        [MD setObject:iTM2TextDefaultVariant forKey:[iTM2TextDefaultVariant lowercaseString]];
        id C = [self syntaxParserClassForStyle:style];
        NSString * styleComponent = [style stringByAppendingPathExtension:iTM2TextStyleExtension];
		
		
        NSString * stylePath = [[[C classBundle] pathForResource:iTM2TextStyleComponent ofType:nil]
            stringByAppendingPathComponent:styleComponent];
        NSEnumerator * E;
        NSString * variantComponent;
		DFM;
		NSArray * directoryContents = [DFM directoryContentsAtPath:stylePath];
        E = [directoryContents objectEnumerator];
        while(variantComponent = [E nextObject])
            if(![variantComponent hasPrefix:@"."]
                && [[variantComponent pathExtension] isEqual:iTM2TextVariantExtension])
            {
                NSString * path = [stylePath stringByAppendingPathComponent:variantComponent];
                BOOL isDirectory = NO;
                if([DFM fileExistsAtPath:path isDirectory:&isDirectory] && isDirectory)
				{
					NSString * variant = [variantComponent stringByDeletingPathExtension];
                    [MD setObject:variant forKey:[variant lowercaseString]];
				}
            }
		NSEnumerator * EE = [[[NSBundle mainBundle] pathsForSupportResource:style
			ofType: iTM2TextStyleExtension inDirectory: iTM2TextStyleComponent
				domains: NSNetworkDomainMask|NSLocalDomainMask|NSUserDomainMask] objectEnumerator];
        while(stylePath = [EE nextObject])
		{
iTM2_LOG(@"stylePath:%@",stylePath);
			NSArray * directoryContent = [DFM directoryContentsAtPath:stylePath];
			E = [directoryContent objectEnumerator];
			while(variantComponent = [E nextObject])
			{
				if(![variantComponent hasPrefix:@"."])
				{
					NSString * path = [stylePath stringByAppendingPathComponent:variantComponent];
					BOOL isDirectory = NO;
					if([DFM fileExistsAtPath:path isDirectory:&isDirectory] && isDirectory)
					{
						NSString * variant = [variantComponent stringByDeletingPathExtension];
						[MD setObject:variant forKey:[variant lowercaseString]];
					}
				}
			}
		}
    }
    return [NSDictionary dictionaryWithDictionary:MD];
}
@end

@interface iTM2TextModeAttributesDictionary: NSDictionary
{
@private
    unsigned _Count;
    id _Keys;
    id _Font;
    id _ForegroundColor;
    id _BackgroundColor;
    id _CursorIsWhite;
    id _NoBackground;
    id _TextMode;
}
@end

#import <iTM2Foundation/iTM2PathUtilities.h>

@implementation iTM2TextSyntaxParserAttributesServer
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= syntaxParserClass
+ (Class)syntaxParserClass;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSString * name = NSStringFromClass(self);
    NSAssert1([name hasSuffix:@"AttributesServer"],
        @"Attributes server class %@ is not suffixed with \"AttributesServer\"", name);
    name = [name substringWithRange:NSMakeRange(0, [name length]-16)];
    Class result = NSClassFromString(name);
    NSAssert1(result, @"Missing syntax parser class named %@", name);
    return result;
}
#pragma mark =-=-=-=-=-  ATTRIBUTES SERVERS MANAGEMENT
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= initWithVariant:
- (id)initWithVariant:(NSString *)variant;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    variant = [variant lowercaseString];
//iTM2_LOG(@"INITIALIZING WITH VARIANT: %@", variant);
    if(self = [super init])
    {
        _Variant = [variant copy];
        [self attributesDidChange];
    }
//iTM2_LOG(@"_ModesAttributes are: %@", _ModesAttributes);
//iTM2_END;
    return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= dealloc
- (void)dealloc;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [INC removeObserver:self];
    [_Variant autorelease];
    _Variant = nil;
    [_ModesAttributes autorelease];
    _ModesAttributes = nil;
    [super dealloc];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= syntaxParserVariant
- (NSString *)syntaxParserVariant;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return _Variant;
}
#pragma mark =-=-=-=-=-  ATTRIBUTES
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  modesAttributes
- (NSDictionary *)modesAttributes;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return _ModesAttributes;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  attributesDidChange
- (void)attributesDidChange;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [_ModesAttributes autorelease];
    _ModesAttributes = [[[[self class] syntaxParserClass] defaultModesAttributes] mutableCopy];
//    [self loadOtherModesAttributesWithVariant:[self syntaxParserVariant]];
	NSError  * localError = nil;
	[_ModesAttributes addEntriesFromDictionary:
		[[self class] modesAttributesWithVariant:[self syntaxParserVariant] error:&localError]];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  shouldUpdateAttributes
- (void)shouldUpdateAttributes;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(!_UpToDate)
    {
        _UpToDate = YES;
        [self attributesDidChange];
        [self performSelector:@selector(__canUpdateNow) withObject:nil afterDelay:0.01];
    }
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  __canUpdateNow
- (void)__canUpdateNow;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    _UpToDate = NO;
//iTM2_END;
    return;
}
#pragma mark =-=-=-=-=-  MODES ATTRIBUTES
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  attributesFforMode:
- (NSDictionary *)attributesForMode:(NSString *)mode;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [_ModesAttributes objectForKey:mode];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setAttributes:forMode:
- (void)setAttributes:(NSDictionary *)dictionary forMode:(NSString *)mode;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(dictionary)
		[_ModesAttributes setObject:dictionary forKey:mode];
	else
		[_ModesAttributes removeObjectForKey:mode];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= modesAttributesWithVariant:error:
+ (NSDictionary *)modesAttributesWithVariant:(NSString *)variant error:(NSError **)outErrorPtr;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_LOG(@"variant is: %@", variant);
	NSMutableDictionary * modesAttributes = [NSMutableDictionary dictionary];
	NSString * variantComponent = [iTM2TextDefaultVariant stringByAppendingPathExtension:iTM2TextVariantExtension];
	NSString * stylePath;
	NSBundle * MB = [NSBundle mainBundle];
	NSString * style = [[self syntaxParserClass] syntaxParserStyle];
	NSArray * paths = [MB pathsForBuiltInResource:style ofType:iTM2TextStyleExtension inDirectory:iTM2TextStyleComponent];
iTM2_LOG(@"builtIn:%@",paths);
	NSEnumerator * E = [paths objectEnumerator];
	while(stylePath = [E nextObject])
	{
		stylePath = [stylePath stringByAppendingPathComponent:variantComponent];
		stylePath = [stylePath stringByResolvingSymlinksAndFinderAliasesInPath];
		BOOL isDir = NO;
		if([DFM fileExistsAtPath:stylePath isDirectory:&isDir] && isDir)
		{
			stylePath = [[stylePath stringByAppendingPathComponent:iTM2TextAttributesModesComponent]
				stringByAppendingPathExtension:iTM2TextAttributesPathExtension];
			[modesAttributes addEntriesFromDictionary:[[self class] modesAttributesWithContentsOfFile:stylePath error:outErrorPtr]];
		}
	}
    variant = [variant lowercaseString];
	variantComponent = [variant stringByAppendingPathExtension:iTM2TextVariantExtension];
    if(![iTM2TextDefaultVariant isEqualToString:variant])
	{
		E = [[self builtInStylePaths] objectEnumerator];
		while(stylePath = [E nextObject])
		{
			stylePath = [stylePath stringByAppendingPathComponent:variantComponent];
			stylePath = [stylePath stringByResolvingSymlinksAndFinderAliasesInPath];
			BOOL isDir = NO;
			if([DFM fileExistsAtPath:stylePath isDirectory:&isDir] && isDir)
			{
				stylePath = [[stylePath stringByAppendingPathComponent:iTM2TextAttributesModesComponent]
					stringByAppendingPathExtension:iTM2TextAttributesPathExtension];
				NSDictionary * D = [[self class] modesAttributesWithContentsOfFile:stylePath error:outErrorPtr];
				[modesAttributes addEntriesFromDictionary:D];
			}
		}
	}
	paths = [MB pathsForSupportResource:style ofType:iTM2TextStyleExtension inDirectory:iTM2TextStyleComponent];
iTM2_LOG(@"support:%@",paths);
	E = [paths objectEnumerator];
	while(stylePath = [E nextObject])
	{
		stylePath = [stylePath stringByAppendingPathComponent:variantComponent];
		stylePath = [stylePath stringByResolvingSymlinksAndFinderAliasesInPath];
		BOOL isDir = NO;
		if([DFM fileExistsAtPath:stylePath isDirectory:&isDir] && isDir)
		{
			stylePath= [[stylePath stringByAppendingPathComponent:iTM2TextAttributesModesComponent]
				stringByAppendingPathExtension:iTM2TextAttributesPathExtension];
			NSDictionary * D = [[self class] modesAttributesWithContentsOfFile:stylePath error:outErrorPtr];
			[modesAttributes addEntriesFromDictionary:D];
		}
	}
//iTM2_END;
    return modesAttributes;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= builtInStylePaths
+ (NSArray *)builtInStylePaths;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSMutableArray * builtInStylePaths = [NSMutableArray array];
	NSMutableArray * bundles = [[[NSBundle allFrameworks] mutableCopy] autorelease];
    id C = [self syntaxParserClass];
	[bundles removeObject:[C classBundle]];
	[bundles insertObject:[C classBundle] atIndex:0];
	[bundles addObject:[NSBundle mainBundle]];
	NSString * style = [[self syntaxParserClass] syntaxParserStyle];
	NSEnumerator * E = [bundles objectEnumerator];
	NSBundle * B;
	while(B = [E nextObject])
	{
		NSString * stylePath = [B pathForResource:style ofType:iTM2TextStyleExtension inDirectory:iTM2TextStyleComponent];
		BOOL isDir = NO;
		if([DFM fileExistsAtPath:stylePath isDirectory:&isDir] && isDir)
		{
			[builtInStylePaths addObject:stylePath];
		}
		else if(iTM2DebugEnabled)
		{
			iTM2_LOG(@"No style/variant modes at built in bundle %@, default attributes might be used (2)", B);
		}
	}
//iTM2_END;
    return [NSArray arrayWithArray:builtInStylePaths];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= otherStylePaths
+ (NSArray *)otherStylePaths;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_LOG(@"the variant is: %@", variant);
	NSMutableArray * otherStylePaths = [NSMutableArray array];
	NSEnumerator * E = [[[NSBundle mainBundle] allPathsForResource:[[self syntaxParserClass] syntaxParserStyle]
								ofType: iTM2TextStyleExtension inDirectory: iTM2TextStyleComponent] reverseObjectEnumerator];
	NSString * stylePath;
    BOOL isDir = NO;
	while(stylePath = [E nextObject])
		if([DFM fileExistsAtPath:stylePath isDirectory:&isDir] && isDir)
			[otherStylePaths addObject:stylePath];
//iTM2_END;
    return [NSArray arrayWithArray:otherStylePaths];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  modesAttributesWithContentsOfFile:error:
+ (NSDictionary *)modesAttributesWithContentsOfFile:(NSString *)fileName error:(NSError **)outErrorPtr;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
iTM2_LOG(@"fileName:%@",fileName);
    NSData * D = [NSData dataWithContentsOfFile:fileName options:0 error:outErrorPtr];
	NSMutableDictionary * MD = nil;
	if(!D)// either a missing file or a real error
	{
		fileName = [fileName stringByDeletingPathExtension];
		D = [NSData dataWithContentsOfFile:fileName options:0 error:outErrorPtr];
		if(!D)
		{
			if(outErrorPtr && !*outErrorPtr)
			{
				iTM2_REPORTERROR(1,@"Missing file?",nil);
			}
			return nil;
		}
		if([D length])
		{
			MD = [NSMutableDictionary dictionary];
			NSKeyedUnarchiver * KU = [[[NSKeyedUnarchiver alloc] initForReadingWithData:D] autorelease];
//			[KU setClass:[iTM2TextModeAttributesDictionary class] forClassName:@"NSDictionary"];
			NSEnumerator * E = [[KU decodeObjectForKey:@"iTM2:root"] objectEnumerator];
			id O;
			while(O = [E nextObject])
			{
				id K = [O objectForKey:iTM2TextModeAttributeName];
				if(K)
				{
					if(O)
						[MD setObject:O forKey:K];
					else
						[MD removeObjectForKey:K];
				}
			}
			return MD;
		}
		return [NSDictionary dictionary];
	}
	NSAttributedString * AS = [[[NSAttributedString alloc] initWithData:D options:nil documentAttributes:nil error:outErrorPtr] autorelease];
	NSString * S = [AS string];
	if(!AS)
	{
		return [NSDictionary dictionary];
	}
	// parse by lines
	NSMutableArray * linesRA = [NSMutableArray array];
	NSMutableArray * attributesRA = [NSMutableArray array];
	id attributes = nil;
	NSString * line;
	NSRange R = NSMakeRange(0,0);
	unsigned nextStart = 0, contentsEnd = 0;
	do
	{
		R.location = nextStart;
		R.length = 0;
		[S getLineStart:nil end:&nextStart contentsEnd:&contentsEnd forRange:R];
		R.length = nextStart - R.location;
		if(contentsEnd>R.location)
		{
			line = [S substringWithRange:R];
			[linesRA addObject:line];
			attributes = [AS attributesAtIndex:R.location effectiveRange:nil];
			[attributesRA addObject:attributes];
		}
	}
	while(nextStart<[S length]);
	// remove the comments
	NSEnumerator * E = [linesRA objectEnumerator];
	linesRA = [NSMutableArray array];
	NSEnumerator * EE = [attributesRA objectEnumerator];
	attributesRA = [NSMutableArray array];
	NSScanner * scanner = nil;
	while(line = [E nextObject])
	{
		attributes = [EE nextObject];
		scanner = [NSScanner scannerWithString:line];
		[scanner setCaseSensitive:NO];
		if([scanner scanString:@"###" intoString:nil])
		{
			// ignore line
		}
		else
		{
			[linesRA addObject:line];
			[attributesRA addObject:attributes];
		}
	}
	// scan the modes
	MD = [NSMutableDictionary dictionary];
	NSString * mode = nil;
	E = [linesRA objectEnumerator];
	EE = [attributesRA objectEnumerator];
	BOOL noBackgroundColor = NO;
	BOOL cursorIsWhite = NO;
	while(line = [E nextObject])
	{
		attributes = [EE nextObject];
		scanner = [NSScanner scannerWithString:line];
		[scanner setCaseSensitive:NO];
		if([scanner scanString:@"mode" intoString:nil] && [scanner scanString:@":" intoString:nil])
		{
			mode = nil;
		}
		else if([scanner scanString:iTM2NoBackgroundAttributeName intoString:nil])
		{
			noBackgroundColor = YES;
		}
		else if([scanner scanString:iTM2CursorIsWhiteAttributeName intoString:nil])
		{
			cursorIsWhite = YES;
		}
		else// if(![scanner scanString:@"%" intoString:nil])
		{
			if(!mode)
			{
				mode = [line stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
			}
			attributes = [[attributes mutableCopy] autorelease];
			[attributes setObject:mode forKey:iTM2TextModeAttributeName];
			[MD setObject:attributes forKey:mode];
		}
	}
	if(noBackgroundColor || cursorIsWhite)
	{
		mode = iTM2TextBackgroundSyntaxModeName;
		attributes = [MD objectForKey:mode];
		if(attributes = [MD objectForKey:mode])
		{
			attributes = [[attributes mutableCopy] autorelease];
		}
		else
		{
			attributes = [NSMutableDictionary dictionary];
		}
		NSNumber * N = [NSNumber numberWithBool:YES];
		if(noBackgroundColor)
		{
			[attributes setObject:N forKey:iTM2NoBackgroundAttributeName];
		}
		else
		{
			[attributes removeObjectForKey:iTM2NoBackgroundAttributeName];
		}
		if(cursorIsWhite)
		{
			[attributes setObject:N forKey:iTM2CursorIsWhiteAttributeName];
		}
		else
		{
			[attributes removeObjectForKey:iTM2CursorIsWhiteAttributeName];
		}
		[MD setObject:attributes forKey:mode];
	}
	return MD;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  writeModesAttributes:toFile:error:
+ (BOOL)writeModesAttributes:(NSDictionary *)dictionary toFile:(NSString *)fileName error:(NSError **)outErrorPtr;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSMutableAttributedString * MAS = [[[NSMutableAttributedString alloc] initWithString:@"### This is a style for iTeXMac2 syntax coloring\n"] autorelease];
	NSAttributedString * buffer = nil;
	NSEnumerator * E = [dictionary keyEnumerator];
	NSString * mode;
	id attributes;
	while(mode = [E nextObject])
	{
		if([mode isEqual:@"_selection"]||[mode isEqual:@"_insertion"]||[mode isEqual:@"_white_prefix"])
		{
			// old designed
			continue;
		}
		buffer = [[[NSMutableAttributedString alloc] initWithString:@"mode:\n"] autorelease];
		[MAS appendAttributedString:buffer];
		attributes = [dictionary objectForKey:mode];
		buffer = [[[NSMutableAttributedString alloc] initWithString:mode attributes:attributes] autorelease];
		[MAS appendAttributedString:buffer];
		buffer = [[[NSMutableAttributedString alloc] initWithString:@"\n"] autorelease];
		[MAS appendAttributedString:buffer];
	}
	mode = iTM2TextBackgroundSyntaxModeName;
	attributes = [dictionary objectForKey:mode];
	NSNumber * N = [attributes objectForKey:iTM2CursorIsWhiteAttributeName];
	if([N boolValue])
	{
		buffer = [[[NSMutableAttributedString alloc] initWithString:iTM2CursorIsWhiteAttributeName] autorelease];
		[MAS appendAttributedString:buffer];
		buffer = [[[NSMutableAttributedString alloc] initWithString:@"\n"] autorelease];
		[MAS appendAttributedString:buffer];
	}
	N = [attributes objectForKey:iTM2NoBackgroundAttributeName];
	if([N boolValue])
	{
		buffer = [[[NSMutableAttributedString alloc] initWithString:iTM2NoBackgroundAttributeName] autorelease];
		[MAS appendAttributedString:buffer];
		buffer = [[[NSMutableAttributedString alloc] initWithString:@"\n"] autorelease];
		[MAS appendAttributedString:buffer];
	}
	NSRange range = NSMakeRange(0,[MAS length]);
	NSData * D = [MAS RTFFromRange:range documentAttributes:nil];
iTM2_LOG(@"fileName:%@",fileName);
//iTM2_END;
    return [D writeToFile:fileName options:NSAtomicWrite error:outErrorPtr];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  character:isMemberOfCoveredCharacterSetForMode:
- (BOOL)character:(unichar)theChar isMemberOfCoveredCharacterSetForMode:(NSString *)mode;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [[[[self attributesForMode:mode] objectForKey:NSFontAttributeName] coveredCharacterSet] characterIsMember:theChar];
}
@end

@implementation iTM2TextModeAttributesDictionary

static unsigned iTM2FontAttributeNameHash = 0;
static unsigned iTM2ForegroundColorAttributeNameHash = 0;
static unsigned iTM2BackgroundColorAttributeNameHash = 0;
static unsigned iTM2TextModeAttributeNameHash = 0;
static unsigned iTM2CursorIsWhiteAttributeNameHash = 0;
static unsigned iTM2NoBackgroundAttributeNameHash = 0;
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  load
+ (void)load;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Oct  6 12:57:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
    iTM2_INIT_POOL;
	iTM2RedirectNSLogOutput();
//iTM2_START;
    iTM2FontAttributeNameHash = [NSFontAttributeName hash];
    iTM2ForegroundColorAttributeNameHash = [NSForegroundColorAttributeName hash];
    iTM2BackgroundColorAttributeNameHash = [NSBackgroundColorAttributeName hash];
    iTM2TextModeAttributeNameHash = [iTM2TextModeAttributeName hash];
    iTM2CursorIsWhiteAttributeNameHash = [iTM2CursorIsWhiteAttributeName hash];
    iTM2NoBackgroundAttributeNameHash = [iTM2NoBackgroundAttributeName hash];
//iTM2_LOG(@"iTM2FontAttributeNameHash is: %i", iTM2FontAttributeNameHash);
//iTM2_LOG(@"iTM2ForegroundColorAttributeNameHash is: %i", iTM2ForegroundColorAttributeNameHash);
//iTM2_LOG(@"iTM2BackgroundColorAttributeNameHash is: %i", iTM2BackgroundColorAttributeNameHash);
//iTM2_LOG(@"iTM2TextModeAttributeNameHash is: %i", iTM2TextModeAttributeNameHash);
//iTM2_LOG(@"iTM2CursorIsWhiteAttributeNameHash is: %i", iTM2CursorIsWhiteAttributeNameHash);
//iTM2_LOG(@"iTM2NoBackgroundAttributeNameHash is: %i", iTM2NoBackgroundAttributeNameHash);
//iTM2_END;
#warning ! FAILED this has no meaning
	iTM2_RELEASE_POOL;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  init
- (id)init;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Oct  6 12:57:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return self = [super init];
}
#define REGISTER(entry, attributeName)\
    if(O = [D objectForKey:attributeName])\
    {\
        [mra addObject:attributeName];\
        if(entry!=O)\
        {\
            [entry release];\
            entry = [O retain];\
            ++_Count;\
        }\
    }
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initWithContentsOfFile:
- (id)initWithContentsOfFile:(NSString *)path;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Oct  6 12:57:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(self = [super init])
    {
	_Count = 0;
        NSDictionary * D = [[[NSDictionary alloc] initWithContentsOfFile:path] autorelease];
        NSMutableArray * mra = [NSMutableArray array];
        id O;
        REGISTER(_Font, NSFontAttributeName);
        REGISTER(_ForegroundColor, NSForegroundColorAttributeName);
        REGISTER(_BackgroundColor, NSBackgroundColorAttributeName);
        REGISTER(_TextMode, iTM2TextModeAttributeName);
        REGISTER(_CursorIsWhite, iTM2CursorIsWhiteAttributeName);
        REGISTER(_NoBackground, iTM2NoBackgroundAttributeName);
        _Keys = [mra copy];
    }
    return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initWithContentsOfURL:
- (id)initWithContentsOfURL:(NSURL *)url;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Oct  6 12:57:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(self = [self init])
    {
	_Count = 0;
        NSDictionary * D = [[[NSDictionary alloc] initWithContentsOfURL:(NSURL *)url] autorelease];
        NSMutableArray * mra = [NSMutableArray array];
        id O;
        REGISTER(_Font, NSFontAttributeName);
        REGISTER(_ForegroundColor, NSForegroundColorAttributeName);
        REGISTER(_BackgroundColor, NSBackgroundColorAttributeName);
        REGISTER(_TextMode, iTM2TextModeAttributeName);
        REGISTER(_CursorIsWhite, iTM2CursorIsWhiteAttributeName);
        REGISTER(_NoBackground, iTM2NoBackgroundAttributeName);
        _Keys = [mra copy];
    }
    return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initWithObjects:forKeys:
- (id)initWithObjects:(NSArray *)objects forKeys:(NSArray *)keys;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Oct  6 12:57:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(self = [self init])
    {
	_Count = 0;
        NSDictionary * D = [[[NSDictionary alloc] initWithObjects:(NSArray *)objects forKeys:(NSArray *)keys] autorelease];
        NSMutableArray * mra = [NSMutableArray array];
        id O;
        REGISTER(_Font, NSFontAttributeName);
        REGISTER(_ForegroundColor, NSForegroundColorAttributeName);
        REGISTER(_BackgroundColor, NSBackgroundColorAttributeName);
        REGISTER(_TextMode, iTM2TextModeAttributeName);
        REGISTER(_CursorIsWhite, iTM2CursorIsWhiteAttributeName);
        REGISTER(_NoBackground, iTM2NoBackgroundAttributeName);
        _Keys = [mra copy];
    }
    return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initWithObjects:forKeys:count:
- (id)initWithObjects:(id *)objects forKeys:(id *)keys count:(unsigned)count;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Oct  6 12:57:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(self = [self init])
    {
	_Count = 0;
        NSDictionary * D = [[[NSDictionary alloc] initWithObjects:(id *)objects forKeys:(id *)keys count:(unsigned)count] autorelease];
        NSMutableArray * mra = [NSMutableArray array];
        id O;
        REGISTER(_Font, NSFontAttributeName);
        REGISTER(_ForegroundColor, NSForegroundColorAttributeName);
        REGISTER(_BackgroundColor, NSBackgroundColorAttributeName);
        REGISTER(_TextMode, iTM2TextModeAttributeName);
        REGISTER(_CursorIsWhite, iTM2CursorIsWhiteAttributeName);
        REGISTER(_NoBackground, iTM2NoBackgroundAttributeName);
        _Keys = [mra copy];
    }
    return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initWithDictionary:
- (id)initWithDictionary:(NSDictionary *)otherDictionary;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Oct  6 12:57:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(self = [self init])
    {
	_Count = 0;
        NSDictionary * D = [[[NSDictionary alloc] initWithDictionary:(NSDictionary *)otherDictionary] autorelease];
        NSMutableArray * mra = [NSMutableArray array];
        id O;
        REGISTER(_Font, NSFontAttributeName);
        REGISTER(_ForegroundColor, NSForegroundColorAttributeName);
        REGISTER(_BackgroundColor, NSBackgroundColorAttributeName);
        REGISTER(_TextMode, iTM2TextModeAttributeName);
        REGISTER(_CursorIsWhite, iTM2CursorIsWhiteAttributeName);
        REGISTER(_NoBackground, iTM2NoBackgroundAttributeName);
        _Keys = [mra copy];
    }
    return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initWithDictionary:copyItems:
- (id)initWithDictionary:(NSDictionary *)otherDictionary copyItems:(BOOL)aBool;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Oct  6 12:57:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(self = [self init])
    {
	_Count = 0;
        NSDictionary * D = [[[NSDictionary alloc] initWithDictionary:(NSDictionary *)otherDictionary copyItems:(BOOL)aBool] autorelease];
        NSMutableArray * mra = [NSMutableArray array];
        id O;
        REGISTER(_Font, NSFontAttributeName);
        REGISTER(_ForegroundColor, NSForegroundColorAttributeName);
        REGISTER(_BackgroundColor, NSBackgroundColorAttributeName);
        REGISTER(_TextMode, iTM2TextModeAttributeName);
        REGISTER(_CursorIsWhite, iTM2CursorIsWhiteAttributeName);
        REGISTER(_NoBackground, iTM2NoBackgroundAttributeName);
        _Keys = [mra copy];
    }
    return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  dealloc
- (void)dealloc;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Oct  6 12:57:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
    if(iTM2DebugEnabled>1)
    {
        iTM2_START;
    }
    [_Keys autorelease];
    [_Font autorelease];
    [_ForegroundColor autorelease];
    [_BackgroundColor autorelease];
    [_TextMode autorelease];
    [_CursorIsWhite autorelease];
    [_NoBackground autorelease];
    if(iTM2DebugEnabled>1)
    {
        iTM2_END;
    }
    [super dealloc];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  count
- (unsigned)count;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Oct  6 12:57:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
    return _Count;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  keyEnumerator
- (NSEnumerator *)keyEnumerator;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Oct  6 12:57:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
    return [_Keys objectEnumerator];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  objectForKey:
- (id)objectForKey:(id)aKey;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Oct  6 12:57:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
    unsigned hash = [aKey hash];
    if(hash == iTM2FontAttributeNameHash)
        return _Font;
    else if(hash == iTM2ForegroundColorAttributeNameHash)
        return _ForegroundColor;
    else if(hash == iTM2BackgroundColorAttributeNameHash)
        return _BackgroundColor;
    else if(hash == iTM2TextModeAttributeNameHash)
        return _TextMode;
    else if(hash == iTM2CursorIsWhiteAttributeNameHash)
        return _CursorIsWhite;
    else if(hash == iTM2NoBackgroundAttributeNameHash)
        return _NoBackground;
    else
        return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  isEqual
- (BOOL)isEqual:(id)object;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Oct  6 12:57:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
    return self == object;
}
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2TextAttributesKit
