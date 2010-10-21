/*
//
//  @version Subversion: $Id$ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Tue Oct 16 2001.
//  Copyright © 2009 Laurens'Tribune. All rights reserved.
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

#import "iTM2TextStorageKit.h"
#import "iTM2ContextKit.h"
#import "iTM2CursorKit.h"
#import "iTM2BundleKit.h"
#import "iTM2Runtime.h"
#import "iTM2StringKit.h"
#import "iTM2StringControllerKit.h"
#import "ICURegEx.h"
#import "iTM2MacroKit_String.h"
#import "iTM2PathUtilities.h"
#import "ICURegEx.h"

#undef _iTM2InternalAssert
#define _iTM2InternalAssert(CONDITION, REASON) if (!(CONDITION))[[NSException exceptionWithName:NSInternalInconsistencyException reason:REASON userInfo:nil] raise]

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

NSString * const iTM2TextModeREPattern = @"iTM2Mode";

// meta property key
NSString * const iTM2TextStyleKey = @"iTM2TextStyle";
NSString * const iTM2TextSyntaxParserVariantKey = @"iTM2TextSyntaxParserVariant";

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2TextStorageKit
/*"Class that defines a text storage and fixes attributes with respect to some syntax, more precisely TeX syntax and Log files syntax."*/

#define _TextStorage ((iTM2TextStorage *)iVarTS4iTM3)
#define _TextModel ((NSMutableString *)iVarModel4iTM3)

#import "iTM2TextDocumentKit.h"
#import "iTM2InstallationKit.h"
#import "iTM2Implementation.h"

NSString * const iTM2SyntaxParserStyleEnabledKey = @"iTM2SyntaxParserStyleEnabled";

@implementation iTM2TextInspector(iTM2TextStorageKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  SWZ_iTM2style_lazyTextStorage
- (id)SWZ_iTM2style_lazyTextStorage;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Mon Apr 12 16:12:14 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//LOG4iTM3(@"[self contextBoolForKey:iTM2SyntaxParserStyleEnabledKey domain:iTM2ContextAllDomainsMask]:%@", ([self contextBoolForKey:iTM2SyntaxParserStyleEnabledKey domain:iTM2ContextAllDomainsMask domain:iTM2ContextAllDomainsMask]? @"Y":@"N"));
	if ([self contextBoolForKey:iTM2SyntaxParserStyleEnabledKey domain:iTM2ContextAllDomainsMask]) {
		id result = [[[iTM2TextStorage alloc] init] autorelease];
        [[iTM2StringController alloc] initWithDelegate:result];
        NSString * style = [[self contextValueForKey:iTM2TextStyleKey domain:iTM2ContextAllDomainsMask] lowercaseString];
		NSString * variant = [[self contextValueForKey:iTM2TextSyntaxParserVariantKey domain:iTM2ContextAllDomainsMask] lowercaseString];
		for (Class C in [iTM2TextSyntaxParser syntaxParserClassEnumerator]) {
			if ([[[C syntaxParserStyle] lowercaseString] isEqual:style]) {
				if ([[[iTM2TextSyntaxParser syntaxParserVariantsForStyle:style] allKeys]containsObject:variant]) {
					[result setSyntaxParserStyle:style variant:variant];
					return result;
				} else {
					DEBUGLOG4iTM3(0,@"variant %@ of style %@ is not in %@", variant, style, [iTM2TextSyntaxParser syntaxParserVariantsForStyle:style]);
				}
			}
		}
		return result;
	}
	return [self SWZ_iTM2style_lazyTextStorage];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  textInspectorStyleCompleteSaveContext4iTM3:
- (void)textInspectorStyleCompleteSaveContext4iTM3:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Mon Apr 12 16:13:17 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	iTM2TextStorage * TS = self.textStorage;
	if ([TS isKindOfClass:[iTM2TextStorage class]]) {
		[self takeContextValue:TS.syntaxParserStyle forKey:iTM2TextStyleKey domain:iTM2ContextAllDomainsMask];
		[self takeContextValue:TS.syntaxParserVariant forKey:iTM2TextSyntaxParserVariantKey domain:iTM2ContextAllDomainsMask];
	}
//END4iTM3;
    return;
}
@end

@implementation NSAttributedString(iTM2Syntax)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= syntaxParser
- (id)syntaxParser;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (03/08/02)
Latest Revision: Mon Apr 12 16:13:36 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return nil;
}
@end

@interface NSTextStorage(PRIVATE)
// never ever call this method by yourself
// this is buggy in leopard and is called by NSTextFinder
- (NSUInteger)replaceString:(NSString *)old withString:(NSString *)new ranges:(NSArray *)ranges options:(NSUInteger)options inView:(id)view replacementRange:(NSRange)range;
@end

@implementation iTM2TextStorage
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= init
- (id)init;
/*"Designated initializer.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Mon Apr 12 12:27:38 UTC 2010
To Do List: Nothing
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if ((self = [super init])) {
        iVarModel4iTM3 = (id)CFStringCreateMutableWithExternalCharactersNoCopy(kCFAllocatorDefault,nil,0,0,kCFAllocatorDefault);// force a 16 bits storage
        [self setSyntaxParserStyle:iTM2TextDefaultStyle variant:iTM2TextDefaultVariant];
        [[iTM2StringController alloc] initWithDelegate:self];
    }
    return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= initWithString:
- (id)initWithString:(NSString *)aString;
/*"Designated initializer.
When no syntax parser is given, the layout is not invalidated and the attributes are not fixed.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Mon Apr 12 16:14:47 UTC 2010
To Do List: Nothing
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if ((self = self.init)) {
        if (aString) {
            self.beginEditing;
            [self replaceCharactersInRange:iTM3MakeRange(0, 0) withString:aString];
            self.endEditing;
		}
    }
    return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= initWithString:attributes:
- (id)initWithString:(NSString *)aString attributes:(NSDictionary *)attrs;
/*"Designated initializer.
When no syntax parser is given, the layout is not invalidated and the attributes are not fixed.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Mon Apr 12 12:27:13 UTC 2010
To Do List: Nothing
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [self initWithString:aString];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= initWithAttributedString:
- (id)initWithAttributedString:(NSAttributedString *)attrStr;
/*"Designated initializer.
When no syntax parser is given, the layout is not invalidated and the attributes are not fixed.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Mon Apr 12 12:27:17 UTC 2010
To Do List: Nothing
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [self initWithString:[attrStr string]];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= isEqualToAttributedString:
- (BOOL)isEqualToAttributedString:(NSAttributedString *)other;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Mon Apr 12 12:27:20 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [_TextModel isEqualToString:[other string]];
}
#if 0
- (void)edited:(NSUInteger)editedMask range:(NSRange)range changeInLength:(NSInteger)delta;
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [super edited:(NSUInteger)editedMask range:(NSRange)range changeInLength:(NSInteger)delta];
//END4iTM3;
    return;
}
- (void)beginEditing;
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [super beginEditing];
    return;
}
- (void)endEditing;
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [super endEditing];
    return;
}
#endif
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  processEditing
- (void)processEditing;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Mon Apr 12 12:26:32 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self.syntaxParser textStorageWillProcessEditing];// is it necessary?
    [super processEditing];
    [self.syntaxParser textStorageDidProcessEditing];// is it necessary?
    return;
}
#if 0
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  lineBreakBeforeIndex:withinRange:
- (NSUInteger)lineBreakBeforeIndex:(NSUInteger)location withinRange:(NSRange)aRange;
/*"Don't know if it is a bug of mine or apple's but sometimes the returned location has nothing to do with aRange.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [_TextModel lineBreakBeforeIndex:location withinRange:aRange];
}
#endif
#pragma mark =-=-=-=-=-=-=-=-=-=-  GETTING CHARACTERS
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= string
- (NSString *)string;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Mon Apr 12 16:15:29 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return iVarModel4iTM3;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= mutableString
- (NSMutableString *)mutableString;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Mon Apr 12 16:15:36 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return iVarModel4iTM3;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= attributedSubstringFromRange:
- (NSAttributedString *)attributedSubstringFromRange:(NSRange)range;
/*"Does nothing: no one should change the attributes except the receiver itself.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2: 12/05/2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [[NSAttributedString alloc] initWithString:[_TextModel substringWithRange:range]];
}
#pragma mark =-=-=-=-=-=-=-=-=-=-  SETTING CHARACTERS
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= replaceCharactersInRange:withString:
- (void)replaceCharactersInRange:(NSRange)range withString:(NSString *)string;
/*"Relies on the shared syntax parser. May invalidate some range of characters if it was not easy or rapid to parse
the text for correct syntax coloring.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Mon Apr 12 16:15:59 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//NSLog(@"%@", NSStringFromRange(range));
//NSLog(@"<%@>", string);
    NSUInteger oldLength = _TextModel.length;
    NSError * ROR = nil;
    if ([self.syntaxParser textStorageShouldReplaceCharactersInRange:range withString:string error:&ROR]) {
        // the next call will put the text storage in an inconsistent state
        [_TextModel replaceCharactersInRange:range withString:string];
        // now we have to synchronize the text storage and the syntax parser
        NSUInteger newLength = _TextModel.length;
        NSInteger delta = newLength - oldLength;
        //  As newLength = oldLength - range.length + string.length
        //  delta == string.length - range.length
        NSUInteger stringLength = string.length;
        NSRange editedAttributesRange;// will receive the range where the attributes might have changed
        if ((range.length && stringLength && [self.syntaxParser textStorageDidReplaceCharactersAtIndex:range.location count:range.length withCount:stringLength editedAttributesRangeIn:&editedAttributesRange error:&ROR])
            || (!ROR && delta == 1 && [self.syntaxParser textStorageDidInsertCharacterAtIndex:range.location editedAttributesRangeIn:&editedAttributesRange error:&ROR])
                || (!ROR && delta == -1 && [self.syntaxParser textStorageDidDeleteCharacterAtIndex:range.location editedAttributesRangeIn:&editedAttributesRange error:&ROR])
                    || (!ROR && delta > 0 && [self.syntaxParser textStorageDidInsertCharactersAtIndex:range.location count:delta editedAttributesRangeIn:&editedAttributesRange error:&ROR])
                        || (!ROR && delta < 0 && [self.syntaxParser textStorageDidDeleteCharactersAtIndex:range.location count:-delta editedAttributesRangeIn:&editedAttributesRange error:&ROR])) {
            [self edited:NSTextStorageEditedCharacters range:range changeInLength:delta];
            [self invalidateAttributesInRange:editedAttributesRange];
            return;
        }
    }
    if (ROR) {
        LOG4iTM3(@"**** ERROR: %@",ROR);
        [NSApp performSelectorOnMainThread:@selector(presentError:) withObject:ROR waitUntilDone:NO];
    }
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= replaceCharactersInRange:withAttributedString:
- (void)replaceCharactersInRange:(NSRange)range withAttributedString:(NSAttributedString *)attributedString;
/*"Attribute changes are catched.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2: 12/05/2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSString * string = [attributedString string];
	[self replaceCharactersInRange:range withString:string];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= replaceString:withString:ranges:options:inView:replacementRange:
- (NSUInteger)replaceString:(NSString *)old withString:(NSString *)new ranges:(NSArray *)ranges options:(NSUInteger)options inView:(id)view replacementRange:(NSRange)range;
/*"Overriding a private cocoa method
Version history: jlaurens AT users DOT sourceforge DOT net
- 2: 12/05/2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;NSFindAndReplace
	if ([SUD boolForKey:@"iTM2DontPatchNSTextStorageReplaceString"]) {
		return [super replaceString:(NSString *)old withString:(NSString *)new ranges:(NSArray *)ranges options:(NSUInteger)options inView:(id)view replacementRange:(NSRange)range];
	}
	NSMutableDictionary * map = [NSMutableDictionary dictionary];
	NSUInteger flags = ICUREMultilineOption;
	if (options & 1) {
		flags |= ICURECaseSensitiveOption;
	}
	NSMutableString * pattern = [NSMutableString string];
	if (options & 1<<16 || options & 1<<17) {
		[pattern appendString:@"\\b"];
	}
	NSUInteger end, contentsEnd;
	NSRange R = iTM3MakeRange(0,0);
	if (R.location<old.length) {
		[old getLineStart:nil end:&end contentsEnd:&contentsEnd forRange:R];
		R.length = contentsEnd-R.location;
		[pattern appendString:@"\\Q"];
		[pattern appendString:[old substringWithRange:R]];
		[pattern appendString:@"\\E"];
		R.location = end;
		while(R.location<old.length)
		{
			R.length = 0;
			[old getLineStart:nil end:&end contentsEnd:&contentsEnd forRange:R];
			R.length = contentsEnd-R.location;
			[pattern appendString:@"$.^"];
			[pattern appendString:@"\\Q"];
            [pattern appendString:[old substringWithRange:R]];
            [pattern appendString:@"\\E"];
            R.location = end;
		}
	}
	if (options & 1<<17)
	{
		[pattern appendString:@"\\b"];
	}
	NSString * myString = self.string;
	NSRange myRange = iTM3MakeRange(0,myString.length);
	ICURegEx * RE = [[[ICURegEx alloc] initWithSearchPattern:pattern options:flags error:nil] autorelease];
	NSMutableString * replacementPattern = [NSMutableString stringWithString:new];
	[replacementPattern replaceOccurrencesOfString:@"\\" withString:@"\\\\" options:0 range:iTM3MakeRange(0,new.length)];
	[replacementPattern replaceOccurrencesOfString:@"$" withString:@"\\$" options:0 range:iTM3MakeRange(0,new.length)];
	[RE setReplacementPattern:replacementPattern];
	NSValue * V;
	for (V in ranges) {
		R = iTM3ProjectionRange(myRange,V.rangeValue);
        V = nil;
		if (R.length) {
			[RE setInputString:myString range:R];
			while ([RE nextMatch]) {
				[map setObject:[RE replacementString] forKey:[NSValue valueWithRange:[RE rangeOfMatch]]];
			}
		}
	}
    RE.forget;
	NSArray * affectedRanges = [[map allKeys] sortedArrayUsingSelector:@selector(compareRangeLocation4iTM3:)];
	NSMutableArray * replacementStrings = [NSMutableArray array];
	for (V in affectedRanges) {
		[replacementStrings addObject:[map objectForKey:V]];
	}
	NSUInteger result = 0;
	if (affectedRanges.count && [view shouldChangeTextInRanges:affectedRanges replacementStrings:replacementStrings]) {
		self.beginEditing;
        NSEnumerator * E = replacementStrings.reverseObjectEnumerator;
		for (V in affectedRanges.reverseObjectEnumerator) {
			[self replaceCharactersInRange:V.rangeValue withString:E.nextObject];
		}
		self.endEditing;
		result = affectedRanges.count;
	}
//END4iTM3;
    return result;
}
#pragma mark =-=-=-=-=-=-=-=-=-=-  GETTING ATTRIBUTES
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= attributesAtIndex:effectiveRange:
- (NSDictionary *)attributesAtIndex:(NSUInteger)aLocation effectiveRange:(NSRangePointer)aRangePtr;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2: 12/05/2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	// there is a bug: infinite loop because the appkit askes for an attribute beyond the limit
    if (iTM2DebugEnabled > 1000 && (aLocation >= _TextModel.length)) {
		LOG4iTM3(@"idx: %u (%u)", aLocation, _TextModel.length);
    }
    [self ensureAttributesAreFixedInRange:iTM3MakeRange(aLocation, MIN(1, _TextModel.length-aLocation))];
	if (self.syntaxParser)
		return [self.syntaxParser attributesAtIndex:aLocation effectiveRange:aRangePtr];
	if (aRangePtr)
		*aRangePtr = iTM3MakeRange(aLocation, _TextModel.length-aLocation);
	return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= attributesAtIndex:effectiveRange:inRange:
- (NSDictionary *)attributesAtIndex:(NSUInteger)aLocation longestEffectiveRange:(NSRangePointer)aRangePtr inRange:(NSRange)aRangeLimit;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2: 12/05/2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSUInteger length = _TextModel.length;
    if (iTM2DebugEnabled > 1000 && (aLocation >= length))
    {
		LOG4iTM3(@"idx: %u (%u)", aLocation, length);
    }
    [self ensureAttributesAreFixedInRange:iTM3MakeRange(aLocation, MIN(1, length-aLocation))];
	NSRange R;
	if (self.syntaxParser)
	{
		id attributes = [self.syntaxParser attributesAtIndex:aLocation longestEffectiveRange:aRangePtr inRange:aRangeLimit];
		if (aRangePtr && aRangePtr->length==0 && aLocation < length)
		{
			R = iTM3MakeRange(aLocation, length-aLocation);
			*aRangePtr = R;
			R.length = MIN(R.length,30);
			LOG4iTM3(@"***  ERROR: 0 length atribute range at %@",[_TextModel substringWithRange:R]);
		}
		return attributes;
	}
	if (aRangePtr)
	{
		R = iTM3MakeRange(aLocation, length-aLocation);
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[self.attributesChangeDelegate textStorage:self wouldSetAttributes:attributes range:aRange];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= addAttribute:value:range:
- (void)addAttribute:(NSString *)name value:(id)value range:(NSRange)range;
/*"Does nothing: no one should change the attributes except the receiver itself.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2: 12/05/2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
	[self.attributesChangeDelegate textStorage:self wouldAddAttribute:name value:value range:range];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= setAttributesChangeDelegate:
- (void)setAttributesChangeDelegate:(id)argument;
/*"Does nothing: no one should change the attributes except the receiver itself.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2: 12/05/2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    NSParameterAssert(!argument || (
        [argument methodSignatureForSelector:@selector(textStorage:wouldSetAttributes:range:)]
        && [argument methodSignatureForSelector:@selector(textStorage:wouldAddAttribute:value:range:)]));
	iVarACD4iTM3 = argument;
    return;
}
@synthesize attributesChangeDelegate = iVarACD4iTM3;
#pragma mark =-=-=-=-=-=-=-=-=-=-  SYNTAX COLORING
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= fixesAttributesLazily
- (BOOL)fixesAttributesLazily;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Mon Apr 12 12:29:33 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return YES;
}
#if 1
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= ensureAttributesAreFixedInRange:
- (void)ensureAttributesAreFixedInRange:(NSRange)range;
/*"Description forthcoming. Bypass the inherited method.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Mon Apr 12 12:29:22 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (range.length) {
        [self.syntaxParser fixSyntaxModesInRange:range];
    }
//END4iTM3;
    return;
}
#endif
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= setSyntaxParser:
- (void)setSyntaxParser:(id)argument;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (11/07/01)
Latest Revision: Mon Apr 12 12:29:04 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (iVarSP4iTM3 != argument) {
        DEBUGLOG4iTM3(500,@"The new syntax style is: %@ with parser: %@", [[iVarSP4iTM3 class] syntaxParserStyle], iVarSP4iTM3);
        iVarSP4iTM3 = argument;
        [argument setTextStorage:self];
        [iVarSP4iTM3 setUpAllTextViews];
        DEBUGLOG4iTM3(500,@"The new syntax style is: %@ with parser: %@", [[iVarSP4iTM3 class] syntaxParserStyle], iVarSP4iTM3);
    }
    return;
}
@synthesize syntaxParser = iVarSP4iTM3;
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  addLayoutManager:
- (void)addLayoutManager:(NSLayoutManager *)obj;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (11/07/01)
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [super addLayoutManager:obj];
    for (NSTextContainer * TC2 in [obj textContainers]) {
        [self.syntaxParser setUpTextView:[TC2 textView]];
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
    self.syntaxParser = [iTM2TextSyntaxParser syntaxParserWithStyle:style variant:variant];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  replaceSyntaxParserStyle:variant:
- (void)replaceSyntaxParserStyle:(NSString *)style variant:(NSString *)variant;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  fixAttributesInRange:
- (void)fixAttributesInRange:(NSRange)aRange;
/*"Description forthcoming.
Version history: 
- 1.1: 05/22/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//NSLog(NSStringFromRange(aRange));
    [self.syntaxParser fixSyntaxModesInRange:aRange];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  syntaxParserStyle
- (NSString *)syntaxParserStyle;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [[self.syntaxParser class] syntaxParserStyle];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  syntaxParserVariant
- (NSString *)syntaxParserVariant;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [self.syntaxParser syntaxParserVariant];
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[super contextDidChange];
    [self setSyntaxParserStyle:[self contextValueForKey:iTM2TextStyleKey domain:iTM2ContextAllDomainsMask]
            variant: [self contextValueForKey:iTM2TextSyntaxParserVariantKey domain:iTM2ContextAllDomainsMask]];
	self.contextDidChangeComplete;
//END4iTM3;
    return;
}
#pragma mark =-=-=-=-=-=-=-=-=-=-  INDEXING
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= lineIndexForLocation4iTM3:
- (NSUInteger)lineIndexForLocation4iTM3:(NSUInteger)index;
/*"Given a range, it returns the line number of the first char of the range.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Mon Apr 12 16:02:30 UTC 2010
To Do List: improve the search avoiding the whole scan of the string, refer to the midle of the string or to the first visible character.
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	iTM2TextSyntaxParser * TSP = self.syntaxParser;
	return TSP?[TSP lineIndexForLocation4iTM3:index]:[super lineIndexForLocation4iTM3:index];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= getLineStart:end:contentsEnd:forRange:
- (void)getLineStart:(NSUInteger *)startPtr end:(NSUInteger *)lineEndPtr contentsEnd:(NSUInteger *)contentsEndPtr forRange:(NSRange)range;
/*"Given a range, it returns the line number of the first char of the range.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: improve the search avoiding the whole scan of the string, refer to the midle of the string or to the first visible character.
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	iTM2TextSyntaxParser * TSP = self.syntaxParser;
	if (!TSP) {
		[super getLineStart:startPtr end:lineEndPtr contentsEnd:contentsEndPtr forRange:range];
		return;
	}
	NSUInteger start = range.location;
	NSUInteger stop = iTM3MaxRange(range);
	NSUInteger index;
	iTM2ModeLine * ML = nil;
	if (startPtr) {
		index = [TSP lineIndexForLocation4iTM3:start];
		ML = [TSP modeLineAtIndex:index];
		*startPtr = ML.startOff7;
		if (lineEndPtr || contentsEndPtr) {
			if (stop<=ML.endOff7) {
conclude:
				if (lineEndPtr) {
					*lineEndPtr = ML.endOff7;
				}
				if (contentsEndPtr) {
					*contentsEndPtr = ML.contentsEndOff7;
				}
				return;
			}
			index = [TSP lineIndexForLocation4iTM3:stop];
			ML = [TSP modeLineAtIndex:index];
			if (stop==ML.startOff7) {
				--index;
				ML = [TSP modeLineAtIndex:index];
			}
			goto conclude;
		}
	}
	if (lineEndPtr || contentsEndPtr) {
		index = [TSP lineIndexForLocation4iTM3:stop];
		ML = [TSP modeLineAtIndex:index];
		if ((stop == ML.startOff7) && (start<stop)) {
			--index;
			ML = [TSP modeLineAtIndex:index];
		}
		goto conclude;
	}
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= getRangeForLine4iTM3:
- (NSRange)getRangeForLine4iTM3:(NSUInteger)aLine;
/*"Given a 1 based line number, it returns the line range including the ending characters.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Mon Apr 12 16:03:54 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	iTM2TextSyntaxParser * TSP = self.syntaxParser;
	if (!TSP) {
		return [super getRangeForLine4iTM3:aLine];
	}
	iTM2ModeLine * ML = [TSP modeLineAtIndex:aLine];
	NSUInteger start = ML.startOff7;
	NSUInteger end = ML.endOff7;
	return iTM3MakeRange(start,end-start);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= getRangeForLine4iTM3Range:
- (NSRange)getRangeForLine4iTM3Range:(NSRange)aLineRange;
/*"Given a line range number, it returns the range including the ending characters.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Mon Apr 12 16:04:07 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	iTM2TextSyntaxParser * TSP = self.syntaxParser;
	if (!TSP) {
		return [super getRangeForLine4iTM3Range:aLineRange];
	}
	iTM2ModeLine * ML = [TSP modeLineAtIndex:aLineRange.location];
	NSUInteger start = ML.startOff7;
	if (aLineRange.length>1) {
		aLineRange.location += aLineRange.length-1;
		ML = [TSP modeLineAtIndex:aLineRange.location];
	}
	NSUInteger end = ML.endOff7;
	return iTM3MakeRange(start,end-start);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= didClickOnLink4iTM3:atIndex:
- (BOOL)didClickOnLink4iTM3:(id)link atIndex:(NSUInteger)charIndex;
/*"Given a line range number, it returns the range including the ending characters.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	return [self.syntaxParser didClickOnLink4iTM3:link atIndex:charIndex];
}
- (void)setStringController4iTM3:(id)aStringController
{
    if (iVarSC4iTM3 != aStringController) {
        iVarSC4iTM3 = aStringController;
        [aStringController setDelegate:self];
    }
}
@synthesize stringController4iTM3 = iVarSC4iTM3;
@end

NSString * const iTM2TextSyntaxParserType = @"_SPC";

#import "iTM2ObjectServer.h"
#import "iTM2NotificationKit.h"
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
Latest Revision: Mon Apr 12 16:07:37 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (!_iTM2TextObjectServerDictionary) {
		_iTM2TextObjectServerDictionary = [NSMutableDictionary dictionary];
		[INC addObserver:self selector:@selector(bundleDidLoadNotified:) name:iTM2BundleDidLoadNotification object:nil];
		self.update;
	}
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  mutableDictionary
+ (NSMutableDictionary *)mutableDictionary;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Mon Apr 12 16:08:06 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return _iTM2TextObjectServerDictionary;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  bundleDidLoadNotified:
+ (void)bundleDidLoadNotified:(NSNotification *)notification;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Mon Apr 12 16:08:11 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
	Class C = [iTM2TextSyntaxParser class];
	NSString * style = [[C syntaxParserStyle] lowercaseString];
	if (style.length)// the type and the modes must have a length!!!
	{
//LOG4iTM3(@"style: %@", style);
		[self registerObject:C forType:iTM2TextSyntaxParserType key:style retain:NO];
	}
//LOG4iTM3(@"There are currently %i subclasses of iTM2TextSyntaxParser", references.count);
	NSPointerArray * PA = [iTM2Runtime subclassReferencesOfClass:C];
	NSUInteger i = PA.count;
	while(i--) {
//LOG4iTM3(@"Registering syntax parser: %@", NSStringFromClass(C));
		Class C = (Class)[PA pointerAtIndex:i];
        style = [[C syntaxParserStyle] lowercaseString];
        if (style.length)// the type and the modes must have a length!!!
        {
//LOG4iTM3(@"style: %@", style);
            [self registerObject:C forType:iTM2TextSyntaxParserType key:style retain:NO];
        }
	}
//END4iTM3;
    return;
}
@end

@interface iTM2TextSyntaxParser(PRIVATE)
- (NSUInteger)xlineIndexForLocation4iTM3:(NSUInteger)location;
@end

@interface iTM2ModeLine()
@property (assign, nonatomic) NSUInteger uncommentedLength;
@property (assign, nonatomic) NSUInteger commentedLength;
@property (assign, nonatomic) NSUInteger EOLLength;
@property (assign, nonatomic) NSRange invalidLocalRange;
@property (readonly, nonatomic) NSRangePointer invalidLocalRangePointer;
@property (assign, nonatomic) NSUInteger numberOfSyntaxWords;
@property (assign, nonatomic) NSUInteger maxNumberOfSyntaxWords;
@property (assign, nonatomic) NSUInteger * syntaxWordOff7s;
@property (assign, nonatomic) NSUInteger * syntaxWordLengths;
@property (assign, nonatomic) NSUInteger * syntaxWordEnds;
@property (assign, nonatomic) NSUInteger * syntaxWordModes;
@end

@interface iTM2TextSyntaxParser()
@property (nonatomic,assign) NSMutableArray * modeLines;
@property (nonatomic,assign) NSUInteger	previousLineIndex;
@property (nonatomic,assign) NSUInteger	previousLocation;
@property (nonatomic,assign) NSUInteger	badOff7Index;
@property (nonatomic,assign) NSUInteger badModeIndex;
@end

@implementation iTM2TextSyntaxParser
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= attributesServerClass
+ (Class)attributesServerClass;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Mon Apr 12 18:48:09 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSString * name = [NSStringFromClass(self) stringByAppendingString:@"AttributesServer"];
    Class result = NSClassFromString(name);
    if (result) {
        return result;
    } else if ([self.superclass respondsToSelector:_cmd]) {
        return [self.superclass attributesServerClass];
    }
    LOG4iTM3(@"A class named %@ must be implemented", name);
    return Nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  syntaxParserClassForStyle:
+ (id)syntaxParserClassForStyle:(NSString *)style;
/*"The default implementation does nothing visible, subclassers will append or prepend their own stuff.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    style = style.lowercaseString;
    Class result = Nil;
    while (YES) {
        if (result = [_iTM2TextObjectServer objectForType:iTM2TextSyntaxParserType key:style]) {
            return result;
        }
        if (style.pathExtension.length) {
            style = style.stringByDeletingPathExtension;
            continue;
        }
        break;
    }
    if (!(result = [_iTM2TextObjectServer objectForType:iTM2TextSyntaxParserType key:iTM2TextDefaultStyle])) {
        // don't remove the {} group due to the definition of LOG4iTM3
        LOG4iTM3(@"INCONSISTENCY, a \"%@\" style is missing", iTM2TextDefaultStyle);
    }
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  syntaxParserWithStyle:variant:
+ (id)syntaxParserWithStyle:(NSString *)style variant:(NSString *)variant;
/*"The default implementation does nothing visible, subclassers will append or prepend their own stuff.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Mon Apr 12 16:20:06 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    style = style.lowercaseString;
    variant = variant.lowercaseString;
    id AS = [self attributesServerWithStyle:style variant:variant];
    Class C = [self syntaxParserClassForStyle:style];
    id result = [[C alloc] init];
    [result setAttributesServer:AS];
    return result;

}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  syntaxParserClassEnumerator
+ (NSEnumerator *)syntaxParserClassEnumerator;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Mon Apr 12 16:20:20 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [_iTM2TextObjectServer objectEnumeratorForType:iTM2TextSyntaxParserType];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  syntaxParserStyle
+ (NSString *)syntaxParserStyle;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Mon Apr 12 16:20:22 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return iTM2TextDefaultStyle;
}
#pragma mark =-=-=-=-=-=-=-=-=-=-  CONSTRUCTOR
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= init
- (id)init;
/*"Designated initializer.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Mon Apr 12 16:20:37 UTC 2010
To Do List: Nothing
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if ((self = [super init])) {
        [INC addObserver:self
            selector: @selector(syntaxAttributesDidChangeNotified:)
                name: iTM2TextAttributesDidChangeNotification object: nil];
		self.previousLineIndex = self.previousLocation = 0;
	}
    return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  diagnostic
- (BOOL)diagnostic;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Thu Apr 22 21:13:55 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (iTM2DebugEnabled < 9999) {
		return NO;
    }
    NSString * S = [self.textStorage string];
	if (!S.length) {
		return NO;
    }
    NSUInteger countOfModeLines = self.numberOfModeLines;
	BOOL toJail = NO;
	if (countOfModeLines) {
		NSUInteger end, contentsEnd;
		NSUInteger modeLineIndex = 0;
		NSRange R = iTM3MakeRange(0, 0);
		iTM2ModeLine * modeLine = [self modeLineAtIndex:modeLineIndex];
testNextLine:
		[S getLineStart:nil end:&end contentsEnd:&contentsEnd forRange:R];
		if (modeLineIndex < self.badOff7Index) {
			if (modeLine.startOff7 != R.location) {
				LOG4iTM3(@"!!!!!!!!!!!!!!  Bad offset at modeLineIndex: %lu (got %lu instead of %lu)",
					modeLineIndex, modeLine.startOff7, R.location);
				toJail = YES;
			}
			if (modeLine.contentsEndOff7 != contentsEnd) {
				LOG4iTM3(@"!!!!!!!!!!!!!!  Bad contents offset at modeLineIndex: %lu (got %lu instead of %lu)",
					modeLineIndex, modeLine.contentsEndOff7, contentsEnd);
				toJail = YES;
			}
			if (modeLine.endOff7 != end) {
				LOG4iTM3(@"!!!!!!!!!!!!!!  Bad next offset at modeLineIndex: %lu (got %lu instead of %lu)",
					modeLineIndex, modeLine.endOff7, end);
				toJail = YES;
			}
		}
		if (modeLine.contentsLength != contentsEnd-R.location) {
			LOG4iTM3(@"!!!!!!!!!!!!!!  Bad contentsLength at modeLineIndex: %lu (got %lu instead of %lu)",
				modeLineIndex, [modeLine contentsLength], contentsEnd-R.location);
			toJail = YES;
		}
		if (modeLine.EOLLength != end-contentsEnd) {
			LOG4iTM3(@"!!!!!!!!!!!!!!  Bad eol length at modeLineIndex: %lu (got %lu instead of %lu)",
				modeLineIndex, modeLine.EOLLength, end-contentsEnd);
			toJail = YES;
		}
		if (modeLine.length != end-R.location) {
			LOG4iTM3(@"!!!!!!!!!!!!!!  Bad length at modeLineIndex: %lu (got %lu instead of %lu)",
				modeLineIndex, modeLine.length, end-R.location);
			toJail = YES;
		}
		if ([modeLine invalidLocalRange].length
			&& ([modeLine invalidLocalRange].location<[modeLine contentsLength])
				&& (modeLineIndex < self.badModeIndex)) {
			LOG4iTM3(@"!!!!!!!!!!!!!!  Invalid mode line with valid mode index");
			toJail = YES;
		}
		if ([modeLine diagnostic]) {
			LOG4iTM3(@"!!!!!!!!!!!!!!  BAD MODE LINE AT INDEX: %lu", modeLineIndex);
			toJail = YES;
		}
		R.location = end;
		if (contentsEnd < end) {
			// we MUST have a new mode line
			if (++modeLineIndex<countOfModeLines) {
				modeLine = [self modeLineAtIndex:modeLineIndex];
				goto testNextLine;
			} else {
				LOG4iTM3(@"!!!!!!!!!!!!!!  MISSING MODE LINE");
				toJail = YES;
			}
		} else {
			// this is a non eol string: this must be the last one
			if (++modeLineIndex<countOfModeLines) {
				LOG4iTM3(@"!!!!!!!!!!!!!!  TOO MANY MODE LINES");
				toJail = YES;
			}
		}
	} else {
		LOG4iTM3(@"!!!!!!!!!!!!!!  THERE MUST BE AT LEAST ONE MODE LINE..");
		toJail = YES;
	}
//END4iTM3;
    if (toJail) {
		LOG4iTM3(@"There are actually %lu lines", countOfModeLines);
		NSLog(@"BadOff7Index %lu", self.badOff7Index);
		NSLog(@"BadModeIndex %lu", self.badModeIndex);
	}
//END4iTM3;
    return toJail;
}
#pragma mark =-=-=-=-=-=-=-=-=-=-  SETTER/GETTER
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  stringController4iTM3
- (iTM2StringController *)stringController4iTM3;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Mon Apr 12 16:22:57 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [self.textStorage stringController4iTM3];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  syntaxParserVariant
- (NSString *)syntaxParserVariant;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Mon Apr 12 16:22:57 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [self.attributesServer syntaxParserVariant];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setTextStorage:
- (void)setTextStorage:(id)argument;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Mon Apr 12 16:22:51 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (iVarTS4iTM3 != argument) {
        iVarTS4iTM3 = argument;// NOT RETAINED
        self.textStorageDidChange;
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  textStorageDidChange
- (void)textStorageDidChange;
/*"The default implementation does nothing visible, subclassers will append or prepend their own stuff.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Mon Apr 12 16:22:45 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    self.modeLines = [NSMutableArray array];
	self.previousLineIndex = self.previousLocation = 0;
    NSString * S = [self.textStorage string];
    if (S) {
//LOG4iTM3(@"S is: <%@>", S);
        iTM2ModeLine * modeLine;
        NSUInteger contentsEnd;
        NSRange R = iTM3MakeRange(0, 0);
RoseRouge:
        modeLine = [iTM2ModeLine modeLine];
        modeLine.startOff7 = R.location;
		[self insertModeLine:modeLine atIndex:self.numberOfModeLines];
		if (R.location < S.length) {
			[S getLineStart:nil end:&R.location contentsEnd:&contentsEnd forRange:R];
#ifdef __ELEPHANT_MODELINE__
#warning ELEPHANT MODE: For debugging purpose only.. see iTM2TextStorageKit.h
			modeLine->originalString = [S substringWithRange:iTM3MakeRange(modeLine.startOff7, R.location-modeLine.startOff7)];
#endif
			if (modeLine.startOff7 < contentsEnd) {
                NSError * ROR = nil;
				if (![modeLine appendSyntaxMode:kiTM2TextUnknownSyntaxMode length:contentsEnd-modeLine.startOff7 error:&ROR] && ROR) {
                    REPORTERRORINMAINTHREAD4iTM3(123,@"MISSED the text storage change",ROR);
                    return;
                }
            }
			if (contentsEnd < R.location) {
				[modeLine setEOLLength:R.location-contentsEnd];
				goto RoseRouge;
			}
		}
    } else {
        DEBUGLOG4iTM3(999999,@"The text storage has no string, very weird situation isn't it? maybe causing bugs..");
		[self insertModeLine:[iTM2ModeLine modeLine] atIndex:self.numberOfModeLines];
    }
    [self validateOff7sUpToIndex:NSUIntegerMax];
    [self invalidateModesFromIndex:0];
	[[self modeLineAtIndex:0] setPreviousMode:kiTM2TextRegularSyntaxMode];// the first line must always have a regular previous mode
//LOG4iTM3(@"The number of lines in this text is: self.numberOfModeLines:%u", self.numberOfModeLines);
	if (self.diagnostic) {
        REPORTERRORINMAINTHREAD4iTM3(123,@"********\n\n\nBIG STARTING PROBLEM.", NULL);
    }
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= setAttributes:range:
- (void)setAttributes:(NSDictionary *)attributes range:(NSRange)range;
/*"Does nothing: no one should change the attributes except the receiver itself.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Mon Apr 12 16:22:33 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= addAttribute:value:range:
- (void)addAttribute:(NSString *)name value:(id)value range:(NSRange)range;
/*"Does nothing: no one should change the attributes except the receiver itself.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Mon Apr 12 16:22:36 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return;
}
#pragma mark =-=-=-=-=-=-=-=-=-=-  TEXTVIEW
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setUpAllTextViews
- (void)setUpAllTextViews;
/*"The default implementation does nothing visible, subclassers will append or prepend their own stuff.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Mon Apr 12 16:24:45 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//LOG4iTM3(@"TV: %@", TV);
    for (NSLayoutManager * LM1 in [self.textStorage layoutManagers]) {
        for (NSTextContainer * TC2 in LM1.textContainers) {
            [self setUpTextView:TC2.textView];
        }
    }
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setUpTextView:
- (void)setUpTextView:(NSTextView *)TV;
/*"The default implementation does nothing visible, subclassers will append or prepend their own stuff.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Mon Apr 12 18:53:33 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//LOG4iTM3(@"TV: %@", TV);
	iTM2TextStorage * TS = (iTM2TextStorage *)self.textStorage;
	id ACD = [TS attributesChangeDelegate];
	[TS setAttributesChangeDelegate:nil];
	//iTM2TextSyntaxParser * SP = [TS syntaxParser];
	NSRange charRange = iTM3MakeRange(0, TV.string.length);
	NSDictionary * attributes = [self.attributesServer attributesForMode:iTM2TextDefaultSyntaxModeName];
	NSColor * foreColor = [attributes objectForKey:NSForegroundColorAttributeName];
	attributes = [self.attributesServer attributesForMode:iTM2TextSelectionSyntaxModeName];
	NSColor * insertionColor = [[self.attributesServer attributesForMode:iTM2TextInsertionSyntaxModeName]
										objectForKey:NSForegroundColorAttributeName];
	NSDictionary * background = [self.attributesServer attributesForMode:iTM2TextBackgroundSyntaxModeName];
	BOOL drawsBackground = ![[background objectForKey:iTM2NoBackgroundAttributeName] boolValue];
	BOOL cursorIsWhite = [[background objectForKey:iTM2CursorIsWhiteAttributeName] boolValue];
	if (TV.string.length)// unless infinite loop
		[TV setTextColor:(foreColor?:[NSColor textColor])];
//LOG4iTM3(@"old [TV selectedTextAttributes] are:%@", [TV selectedTextAttributes]);
	NSMutableDictionary * MD = [NSMutableDictionary dictionaryWithDictionary:TV.selectedTextAttributes];
	[MD setObject:[NSColor selectedTextColor] forKey:NSForegroundColorAttributeName];
	[MD setObject:[NSColor selectedTextBackgroundColor] forKey:NSBackgroundColorAttributeName];
	if (attributes) {
		[MD addEntriesFromDictionary:attributes];
    }
	[TV setSelectedTextAttributes:MD];
//LOG4iTM3(@"[TV selectedTextAttributes] are:%@", [TV selectedTextAttributes]);
	[TV setInsertionPointColor:(insertionColor?:[NSColor textColor])];
	[TV setDrawsBackground:drawsBackground];
//LOG4iTM3(@"[TV drawsBackground] is:%@", ([TV drawsBackground]? @"Y":@"N"));
	NSColor *  backgroundColor = [background objectForKey:NSBackgroundColorAttributeName]?:
		[NSColor textBackgroundColor];
	NSScrollView * SV = TV.enclosingScrollView;
	[SV setDrawsBackground:NO];
	NSColor * enclosingBackgroundColor = [SV drawsBackground]? [SV backgroundColor]:[NSColor windowFrameColor];
	NSColor * blendedColor = [[backgroundColor colorWithAlphaComponent:1]
					blendedColorWithFraction: 1-[backgroundColor alphaComponent]
								ofColor: enclosingBackgroundColor];
	[TV setBackgroundColor:(blendedColor? blendedColor:backgroundColor)];
//LOG4iTM3(@"backgroundColor is: %@, [backgroundColor alphaComponent] is:%f", backgroundColor, [backgroundColor alphaComponent]);
//LOG4iTM3(@"enclosingBackgroundColor is: %@", enclosingBackgroundColor);
//LOG4iTM3(@"blended Color is: %@", [[backgroundColor colorWithAlphaComponent:1] blendedColorWithFraction:1-[backgroundColor alphaComponent] ofColor:enclosingBackgroundColor]);
//LOG4iTM3(@"[TV drawsBackground] is:%@", ([TV drawsBackground]? @"Y":@"N"));
	[TV setNeedsDisplay:YES];
    NSClipView * CV = (NSClipView *)SV.contentView;
	[CV setDocumentCursor:(cursorIsWhite? [NSCursor whiteIBeamCursor]:[NSCursor IBeamCursor])];
	[CV setBackgroundColor:(blendedColor? blendedColor:backgroundColor)];
	[CV setNeedsDisplay:YES];
	// ending by the layout manager
	NSLayoutManager * LM = TV.layoutManager;
	[LM invalidateDisplayForCharacterRange:charRange];
	#if 1
	NS_DURING
	{// this is a block
		charRange.length = LM.firstUnlaidCharacterIndex;
		[LM invalidateGlyphsForCharacterRange:charRange changeInLength:0 actualCharacterRange:nil];
		[LM invalidateLayoutForCharacterRange:charRange isSoft:NO actualCharacterRange:nil];
	}
	NS_HANDLER
	{
		iTM2DebugEnabled = 10000;
		iTM2TextStorage * TS = (iTM2TextStorage *)TV.textStorage;
		if ([TS respondsToSelector:@selector(syntaxParser)]) {
			iTM2TextSyntaxParser * SP = TS.syntaxParser;
			[SP diagnostic];
		}
	}
	NS_ENDHANDLER
	#endif
	[TS setAttributesChangeDelegate:ACD];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  syntaxAttributesDidChangeNotified:
- (void)syntaxAttributesDidChangeNotified:(NSNotification *)aNotification;
/*"The notification object is used to retrieve font and color info. If no object is given, the NSFontColorManager class object is used.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: NYI
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    DEBUGLOG4iTM3(999999,@"A change of attributes is notified");
    NSDictionary * D = [aNotification userInfo];
	NSString * style = [D objectForKey:@"style"];
	NSString * variant = [D objectForKey:@"variant"];
	NSString * myStyle = [self.class syntaxParserStyle];
	NSString * myVariant = self.syntaxParserVariant;
    if (([style caseInsensitiveCompare:myStyle] == NSOrderedSame)
            && ([variant caseInsensitiveCompare:myVariant] == NSOrderedSame)) {
        [self.attributesServer attributesDidChange];
        // the above message can be sent more than once to the same object
        // to prevent a waste of time and energy, the attribute server keeps track of the file modification date
        self.setUpAllTextViews;
    }
//END4iTM3;
    return;
}
#pragma mark =-=-=-=-=-=-=-=-=-=-  MODE LINES
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  numberOfModeLines
- (NSUInteger)numberOfModeLines;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Mon Apr 12 16:39:20 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return self.modeLines.count;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  modeLineAtIndex:
- (id)modeLineAtIndex:(NSUInteger)idx;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Mon Apr 12 16:39:20 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [self.modeLines objectAtIndex:idx];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertModeLine:atIndex:
- (void)insertModeLine:(id)modeLine atIndex:(NSUInteger)idx;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Mon Apr 12 16:42:38 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self.modeLines insertObject:modeLine atIndex:idx];
    [self invalidateOff7sFromIndex:idx];
    [self invalidateModesFromIndex:idx];
    return;
}
- (void)removeModeLineAtIndex:(NSUInteger)idx
{
    if (idx < self.numberOfModeLines) {
        [self.modeLines removeObjectAtIndex:idx];
        if (self.numberOfModeLines) {
            [[self modeLineAtIndex:0] setPreviousMode:kiTM2TextRegularSyntaxMode];
        }
        [self invalidateOff7sFromIndex:idx];
        [self invalidateModesFromIndex:idx];
    }
}
- (void)replaceModeLineAtIndex:(NSUInteger)idx withModeLine:(id)ML;
{
    [self.modeLines replaceObjectAtIndex:idx withObject:ML];
    [[self modeLineAtIndex:0] setPreviousMode:kiTM2TextRegularSyntaxMode];
    [self invalidateOff7sFromIndex:idx];
    [self invalidateModesFromIndex:idx];
}
- (void)replaceModeLinesInRange:(NSRange)range withModeLines:(NSArray *)MLs;
{
    [self.modeLines replaceObjectsInRange:range withObjectsFromArray:MLs];
    [[self modeLineAtIndex:0] setPreviousMode:kiTM2TextRegularSyntaxMode];
    [self invalidateOff7sFromIndex:range.location];
    [self invalidateModesFromIndex:range.location];
}
#pragma mark =-=-=-=-=-=-=-=-=-=-  INDEX WITH BAD OFFSET
@synthesize badOff7Index = iVarBadOff7Idx4iTM3;
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateOff7sUpTo:
- (void)validateOff7sUpToIndex:(NSUInteger)argument;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Mon Apr 12 18:56:44 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    self.badOff7Index = ++argument? MAX(argument, self.badOff7Index):NSUIntegerMax;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  invalidateOff7sFromIndex:
- (void)invalidateOff7sFromIndex:(NSUInteger)argument;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Mon Apr 12 18:56:51 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    self.badOff7Index = MAX(1,MIN(argument,self.badOff7Index));// ASSUME: self.badOff7Index > 0
    return;
}
#pragma mark =-=-=-=-=-=-=-=-=-=-  INDEX WITH BAD MODE
@synthesize badModeIndex = iVarBadModeIdx4iTM3;
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateModesUpToIndex:
- (void)validateModesUpToIndex:(NSUInteger)argument;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Mon Apr 12 18:56:59 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    self.badModeIndex = ++argument? MAX(argument, self.badModeIndex):NSUIntegerMax;// the maximum value
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  invalidateModesFromIndex:
- (void)invalidateModesFromIndex:(NSUInteger)argument;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Mon Apr 12 18:57:07 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    self.badModeIndex = MIN(argument, self.badModeIndex);
    return;
}
#pragma mark =-=-=-=-=-=-=-=-=-=-  FOLDING
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  isFoldingCompliant
- (BOOL)isFoldingCompliant;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Mon Apr 12 18:57:14 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  lineIndexForLocation4iTM3:
- (NSUInteger)lineIndexForLocation4iTM3:(NSUInteger)location;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Apr 21 12:40:19 UTC 2010
To Do List: 
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//NSLog(@"Computing the line idx for location: %u", location);
    //  this is the idx for which the mode line realizes
    //  startOff7[idx] <= location < endOff7[idx]
    //  except for big locations for which the answer is the last index
    //  this is because the first lcoation after the last character is used in practice by cocoa text system.
    //  equivalent definition:
    //  the one but first idx such that
    //  off7[idx] > location
    //  self.modeLines is assumed to have at least one object!!!
    //  _InvalidOff7 is assumed to be greater than one, assuming that the first offset is necessary 0!!!
//LOG4iTM3(@".....  self.numberOfModeLines is:%u", self.numberOfModeLines);
	NSUInteger n = MIN(self.badOff7Index, self.numberOfModeLines);
	NSUInteger min = 0;
	NSUInteger max = 0;
    // self.badOff7Index is assumed to be greater than 1
    // The offset of the first mode line must be 0
	iTM2ModeLine * modeLine = nil;
    //  use the result of the last search
	if (self.previousLineIndex<n) {
        //  the pervious search is still in the valid range
		modeLine = [self modeLineAtIndex:self.previousLineIndex];
		if (modeLine.startOff7 <= location) {
			if (location < modeLine.endOff7) {
                //  we are still in the same line
				self.previousLocation = location;
				return self.previousLineIndex;
			}
            //  the answer is in [self.previousLineIndex, ...]
            min = self.previousLineIndex;
		} else {
            // the answer is in [0 self.previousLineIndex[
			max = self.previousLineIndex;
next:
			// the result is an idx in [min, max-1]
            while ((n = (max-min) / 2)) {
                // n<max-min
                n += min;
                // min < n < max
                if ([[self modeLineAtIndex:n] startOff7] > location) {
                    max = n; // min < max
                } else {
                    min = n; // min < max
                }
            }
            //  end of the while loop when 0 == (max-min) / 2
            //  ie max-min = 0 or 1
            self.previousLocation = location;
            return self.previousLineIndex = min;
		}
	} else if (!n) {
        self.previousLocation = location;
        return self.previousLineIndex = NSUIntegerMax;
    }
    --n;
    modeLine = [self modeLineAtIndex:n];
    if (location < modeLine.startOff7) {
        // the result is an idx in [0, n-1]
		max = n;
        goto next;
    }
    //  HERE we have
    //  modeLine.startOff7 <= location
    //  AND
    //  n = self.badOff7Index-1
    //  unless the receiver is really inconsistent
    //  the result is an idx between self.badOff7Index-1 and self.numberOfModeLines-1, both included.
    NSUInteger top = self.numberOfModeLines;
    while (YES) {
        //  modeLine is the mode line at idx n
        //  this is the last modeLine with valid off7
        NSUInteger off7 = modeLine.endOff7;
        if (location < off7) {
            self.previousLocation = location;
            return self.previousLineIndex = n;
        } else if (++n < top) {
            modeLine = [self modeLineAtIndex:n];
            modeLine.startOff7 = off7;
            ++ self.badOff7Index;
            continue;
        } else {
            self.previousLocation = location;
            return self.previousLineIndex = --n;// there was a ++n before
        }
    }
    UNREACHABLE_CODE4iTM3;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  xlineIndexForLocation4iTM3:
- (NSUInteger)xlineIndexForLocation4iTM3:(NSUInteger)location;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Dec 12 22:44:56 GMT 2003
To Do List: 
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//NSLog(@"Computing the line idx for location: %u", location);
    // this is the idx for which the mode line realizes
    // offset[idx] <= location < offset[idx]+end[idx]
    // equivalent definition:
    // the one but first idx such that
    // offset[idx] > location
    // self.modeLines is assumed to have at least one object!!!
    // _InvalidOff7 is assumed to be greater than one, assuming that the first offset is necessary 0!!!
//LOG4iTM3(@".....  self.numberOfModeLines is:%u", self.numberOfModeLines);
    NSUInteger n = MIN(self.badOff7Index, self.numberOfModeLines)-1;
	NSUInteger min = 0;
	NSUInteger max = 0;
    // self.badOff7Index is assumed to be greater than 1
    // The offset of the first mode line must be 0
//NSLog(@"Index of the last valid mode line with respect to the offset: %u", n);
	iTM2ModeLine * modeLine = [self modeLineAtIndex:n];
    NSUInteger offset = modeLine.startOff7;
    if (location < offset) {
        // the result is an idx in [0, n-1]
		max = n;
//NSLog(@"The result is an integer between %u and: %u (excluded)", min, max);
next:
        if (n = (max-min) / 2) {
            // n<max-min
            n += min;
            // min < n < max
            if ([[self modeLineAtIndex:n] startOff7] > location) {
                max = n;
            } else {
                min = n;
            }
            goto next;
            // [[self modeLineAtIndex:min] startOff7] <= location < [[self modeLineAtIndex:max] startOff7]
        } else /*if (n=0, (max == min))*/ {
            if (iTM2DebugEnabled>999999) {
                iTM2ModeLine * modeLine = [self modeLineAtIndex:min];
                LOG4iTM3(@"=====  |=:>) -X- The idx found is %u such that %u<=%u<%u (<>) ",
                    min, modeLine.startOff7, location, modeLine.endOff7);
            }
            return min;
        }
    } else/*if (location >= offset)*/{
        // HERE we have
        // offset <= location
        // AND
        // n = self.badOff7Index-1
        // unless the receiver is really inconsistent
        // the result is an idx between self.badOff7Index-1 and self.numberOfModeLines-1, both included.
        NSUInteger top = self.numberOfModeLines;//=self.numberOfModeLines;
//NSLog(@"The number of mode lines of this text is: %u, the invalid idx is: %u", top, self.badOff7Index);
        while (YES) {
            // O is the mode line at idx n
            offset = modeLine.endOff7;//offset += modeLine.length;
            if (location < offset) {
                if (iTM2DebugEnabled>999999) {
                    iTM2ModeLine * modeLine = [self modeLineAtIndex:n];
                    LOG4iTM3(@"=====  |=:>) -Y- The idx found is %u such that %u<=%u<%u (<>) ",
                        n, modeLine.startOff7, location, modeLine.endOff7);
                }
                return n;
            } else if (++n < top) {
    //NSLog(@"We are now validating the idx: %u with offset %u", n, offset);
                modeLine = [self modeLineAtIndex:n];
                modeLine.startOff7 = offset;
                ++ self.badOff7Index;
                continue;
            } else {
                if (iTM2DebugEnabled>999999) {
                    iTM2ModeLine * modeLine = [self modeLineAtIndex:n-1];
                    LOG4iTM3(@"=====  |=:>) -Z- The idx found is the top (%u) such that %u<=%u",
                        n-1, modeLine.startOff7, location);
                }
                return n-1;
            }
        }
    }
//NSLog(@"This is a default return");
}
#pragma mark =-=-=-=-=-=-=-=-=-=-  ATTRIBUTES
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  attributesAtIndex:effectiveRange:
- (NSDictionary *)attributesAtIndex:(NSUInteger)aLocation effectiveRange:(NSRangePointer)aRangePtr;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (aRangePtr) {
        aRangePtr -> location = aLocation;
        aRangePtr -> length = _TextStorage.length-aLocation;
    }
    return [self.attributesServer attributesForMode:iTM2TextDefaultSyntaxModeName];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= attributesAtIndex:longestEffectiveRange:inRange:
- (NSDictionary *)attributesAtIndex:(NSUInteger)aLocation longestEffectiveRange:(NSRangePointer)aRangePtr inRange:(NSRange)aRangeLimit;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSDictionary * D = [self attributesAtIndex:(NSUInteger)aLocation effectiveRange:(NSRangePointer)aRangePtr];
    if (aRangePtr) {
		*aRangePtr = iTM3ProjectionRange(aRangeLimit, *aRangePtr);
    }
    return D;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  getSyntaxMode:atIndex:longestRange:
- (NSUInteger)getSyntaxMode:(NSUInteger *)modeRef atIndex:(NSUInteger)aLocation longestRange:(NSRangePointer)aRangePtr;
/*"This has been overriden by a subclasser.. No need to further subclassing. Default return value is 0 on (inconsistency?)
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//NSLog(@"Location: %u", aLocation);
    NSUInteger lineIndex = [self lineIndexForLocation4iTM3:aLocation];
    iTM2ModeLine * modeLine = [self modeLineAtIndex:lineIndex];
    return [modeLine getSyntaxMode:modeRef atGlobalLocation:aLocation longestRange:aRangePtr];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  getSmartSyntaxMode:atIndex:longestRange:
- (NSUInteger)getSmartSyntaxMode:(NSUInteger *)modeRef atIndex:(NSUInteger)aLocation longestRange:(NSRangePointer)aRangePtr;
/*"This has been overriden by a subclasser.. No need to further subclassing. Default return value is 0 on (inconsistency?)
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
//NSLog(@"range: %@", NSStringFromRange(range));
//NSLog(@"Now self.badModeIndex = %u", self.badModeIndex);
    // Trivial cases.
    if ((range.location >= [(NSTextStorage *)_TextStorage length]) || (!range.length))
        return;
    // I don't know if the range is valid.
    range.length = MIN(range.length, [(NSTextStorage *)_TextStorage length]-range.location);
    NSUInteger last  = [self lineIndexForLocation4iTM3:range.location+range.length-1];
    // last: offset <= range.location range.length-1 < offset+end
    // It means that all the character indices in range are spread over the lines between first and last,
    // both included.
    if (last < self.badModeIndex)
    // all the line indices strictly before self.badOff7Index are all valid: no need to make further computation
        return;
//START4iTM3;
    NSUInteger first = MIN([self lineIndexForLocation4iTM3:range.location], self.badModeIndex);
    // first: offset <= range.location < offset+end
	// what is the previous mode?
    NSUInteger mode = first? [[self modeLineAtIndex:first-1] EOLMode]:[[self modeLineAtIndex:first] previousMode];
//NSLog(@"BIG CALCULUS (first is: %u, last is: %u and self.badModeIndex is: %u, mode is: %u)", first, last, self.badModeIndex, mode);
	if (self.diagnostic)
    {
        LOG4iTM3(@"=====  |=:( Comment il a pu me foutre un bordel pareil........");
    }
    if (mode && (mode != kiTM2TextUnknownSyntaxMode))// no error is reported from the previous line
    {
ValidateNextModeLine:;
        iTM2ModeLine * modeLine = [self modeLineAtIndex:first];
		#ifdef __ELEPHANT_MODELINE__
		NSUInteger start, end;
		[[self.textStorage string] getLineStart:&start end:&end contentsEnd:nil forRange:iTM3MakeRange(modeLine.startOff7, 0)];
		_iTM2InternalAssert([[modeLine originalString] isEqualToString:[[self.textStorage string] substringWithRange:iTM3MakeRange(start, end-start)]], ([NSString stringWithFormat:@"original is\n<%@> != expected string is:\n<%@>", [modeLine originalString], [[self.textStorage string] substringWithRange:iTM3MakeRange(start, end-start)]]));
		#endif
        mode = [self validEOLModeOfModeLine:modeLine forPreviousMode:mode];
		if (mode && ((mode & ~kiTM2TextFlagsSyntaxMask) != kiTM2TextUnknownSyntaxMode))
		{
			[self validateModesUpToIndex:first];
			NSUInteger firewall = 543;
			if (++first<last && firewall--)
			{
				goto ValidateNextModeLine;
			}
		}
    }
    _iTM2InternalAssert(!self.diagnostic, @"=====  |=:( Qui m'a foutu un bordel pareil........");
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= invalidateModesForCharacterRangeIndex:editedAttributesRangeIn:
- (void)invalidateModesForCharacterRangeIndex:(NSRange)range editedAttributesRangeIn:(NSRangePointer)editedAttributesRangePtr;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2: 12/05/2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (!range.length)
        return;
    NSUInteger top = MIN(iTM3MaxRange(range), _TextStorage.length);
    if (!top)
        return;
    NSUInteger bottom = range.location;
    range.location = 0;
    NSUInteger lineIndex;
	lineIndex = [self lineIndexForLocation4iTM3:top-1];
	iTM2ModeLine * modeLine = [self modeLineAtIndex:lineIndex];
	range.location = modeLine.startOff7;
	NSRange editedAttributesRange = iTM3MakeRange(modeLine.startOff7, modeLine.length);
	if (bottom < range.location)
	{
		range.length = top-range.location;
		[modeLine invalidateGlobalRange:range];
		top = range.location;
here:
		lineIndex = [self lineIndexForLocation4iTM3:top-1];
		iTM2ModeLine * modeLine = [self modeLineAtIndex:lineIndex];
		editedAttributesRange.location -= modeLine.length;
		editedAttributesRange.length += modeLine.length;
		range.location = modeLine.startOff7;
		if (bottom < range.location)
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
			editedAttributesRange.location -= modeLine.length;
			editedAttributesRange.length += modeLine.length;
			[modeLine invalidateGlobalRange:range];
		}
	}
	else
	{
		range.location = bottom;
		range.length = top-bottom;
		editedAttributesRange.location -= modeLine.length;
		editedAttributesRange.length += modeLine.length;
		[modeLine invalidateGlobalRange:range];
	}
//    [self invalidateModesFromIndex:lineIndex];
    [self invalidateModesFromIndex:0];
	if (editedAttributesRangePtr)
	{
		* editedAttributesRangePtr = editedAttributesRange;
	}
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  didUpdateModeLine:forPreviousMode:
- (void)didUpdateModeLine:(id)originalModeLine forPreviousMode:(NSUInteger)previousMode;
/*"This method will compute all the correct attributes. No need to override.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Dec 12 22:44:56 GMT 2003
To Do List: 
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  validEOLModeOfModeLine:forPreviousMode:
- (NSUInteger)validEOLModeOfModeLine:(iTM2ModeLine *)originalModeLine forPreviousMode:(NSUInteger)previousMode;
/*"This method is an entry point will compute all the correct attributes."*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    _iTM2InternalAssert(!self.diagnostic, @"BIG PROBLEM BEFORE VALIDATING THE MODE");
	// the previous mode is in general the mode of the last EOL character of the previous line
	// The default value is kiTM2TextUnknownSyntaxMode, such that a zero value is an error and bypasses the whole method.
    if (!previousMode || (previousMode == kiTM2TextUnknownSyntaxMode))
		// The previous mode is an error (weak or strong): do nothing and propagate the error.
		// Don't know yet what is the difference between both choices..
        return previousMode & kiTM2TextEndOfLineSyntaxMask;
	// if the mode line is void, which corresponds to a void line, with only an EOL marker if it is not the last line
	// no computation
    if (!originalModeLine.numberOfSyntaxWords || !originalModeLine.contentsLength) {
        [originalModeLine invalidateLocalRange:iTM3MakeRange(0, NSUIntegerMax)];		
        return originalModeLine.EOLMode = [self EOLModeForPreviousMode:previousMode];
    }
	// did the previous mode change since the last time the attributes were computed?
    if ([originalModeLine previousMode] != previousMode) {
//NSLog(@"New previous mode, invalidating the whole line (old: %u <> new: %u)?", [originalModeLine previousMode], previousMode);
		// the current syntax analyse is no longer valid
        [originalModeLine invalidateLocalRange:iTM3MakeRange(0, 1)];
        [originalModeLine setPreviousMode:previousMode];
    } else if (!originalModeLine.invalidLocalRange.length
            || (originalModeLine.invalidLocalRange.location >= originalModeLine.contentsLength))
	// the attributes were already computed, so we just have to return the result previously computed and stored as the EOL mode
        return originalModeLine.EOLMode = (originalModeLine.EOLMode | kiTM2TextEndOfLineSyntaxMask);
//START4iTM3;
	// now, we are really going to compute the attributes validating the modes
    _iTM2InternalAssert(!self.diagnostic, @"***  0-STARTING:BIG PROBLEM IN VALIDATING THE MODE");
    #undef IR
    #define IR originalModeLine.invalidLocalRange
//LOG4iTM3(@"Working hard: local invalid range %@, previousMode: %u", NSStringFromRange(IR), previousMode);
//[originalModeLine describe];
//NSUInteger N = 0;
    // From now on, IR.location < the length of the mode line there is some mode to fix
    iTM2ModeLine * workingML = [iTM2ModeLine modeLine];
	// we compute a new mode line, then we will swap the contents of the new mode line with the original one
    // we are definitely optimistic:
	[workingML validateLocalRange:iTM3MakeRange(0, NSUIntegerMax)];
//[workingML describe];
    // We start duplicating the good modes and mode wordLengths
    NSUInteger syntaxWordIndex = 0;// Here, syntaxWordIndex < originalModeLine.numberOfSyntaxWords
    NSUInteger currentSyntaxWordOff7 = 0;// it is the offset of the syntax word at index syntaxWordIndex
    //currentSyntaxWordOff7 = \sum_{i=0}^{syntaxWordIndex-1} [originalModeLine syntaxLengthAtIndex:i]
    _iTM2InternalAssert(!self.diagnostic, @"***  1 :BIG PROBLEM IN VALIDATING THE MODE");
    NSUInteger testigo = 0;// debugger to ensure that all chars are the same
	// We start by copying the valid original modes
	// a syntax word is considered to be valid when it is before the invalid range and far from it
	// More precisely a valid syntax word contains no invalid character and is followed by a valid character
	// We merge the syntax words when possible
	// if many consecutive syntax words have the same mode, they will be copied as one word
	// previousMode and previousLength serve this purpose
    NSUInteger previousLength = 0;
    // previousLength stores the length of the current syntax word
    NSError * ROR = nil;
copyValidOriginalMode:;
	NSUInteger originalMode = originalModeLine.syntaxWordModes[syntaxWordIndex];
    NSUInteger nextSyntaxWordOff7 = originalModeLine.syntaxWordEnds[syntaxWordIndex];// it will be the offset of the syntax word at index syntaxWordIndex+1
    //nextSyntaxWordOff7 = \sum_{i=0}^{syntaxWordIndex} [originalModeLine syntaxLengthAtIndex:i]
    //nextSyntaxWordOff7 = currentSyntaxWordOff7+[originalModeLine syntaxLengthAtIndex:syntaxWordIndex]
	if (nextSyntaxWordOff7<IR.location) {
		// OK we can copy what is there as a whole.
		if (originalMode==previousMode) {
			previousLength += originalModeLine.syntaxWordLengths[syntaxWordIndex];
		} else {
			if (![workingML appendSyntaxMode:previousMode length:previousLength error:&ROR] && ROR) {
                REPORTERRORINMAINTHREAD4iTM3(123,@"MISSED the text storage change",ROR);
                return kiTM2TextErrorSyntaxMode;
            }
			testigo += previousLength;
			previousMode = originalMode;
			previousLength = originalModeLine.syntaxWordLengths[syntaxWordIndex];
		}
		NSAssert(++syntaxWordIndex<originalModeLine.numberOfSyntaxWords, @"INCONSISTENCY: this should not occur");
		currentSyntaxWordOff7 = nextSyntaxWordOff7;
		goto copyValidOriginalMode;
	} else if (IR.location > currentSyntaxWordOff7) {
		// currentSyntaxWordOff7 < IR.location <= nextSyntaxWordOff7
		// the beginning of the syntax word is not accepted
        IR = iTM3MakeRange(currentSyntaxWordOff7,IR.length+IR.location-currentSyntaxWordOff7);
	}
	_iTM2InternalAssert(!self.diagnostic, @"2-BIG PROBLEM IN VALIDATING THE MODE");
	// HERE we have
    // currentSyntaxWordOff7 <= IR.location < nextSyntaxWordOff7
    // syntaxWordIndex < originalModeLine.numberOfSyntaxWords
    //
    // NOW WE ARE FIXING THE ATTRIBUTES..
    NSUInteger localLocation = IR.location;// the location we are validating
    // localLocation is the first character index for which the mode is not yet fixed
    NSUInteger globalLocation = originalModeLine.startOff7+localLocation;
    NSUInteger topGlobalLocation = originalModeLine.startOff7+MIN(iTM3MaxRange(IR), originalModeLine.contentsLength);
    //topGlobalLocation <= originalModeLine.startOff7+[originalModeLine contentsLength];
//NSLog(@"Fixing the modes\r(first unsaved mode syntaxWordIndex: %u, nextSyntaxWordOff7: %u, localLocation: %u, previousLength: %u)", syntaxWordIndex, nextSyntaxWordOff7, localLocation, previousLength);
//[workingML describe];
//NSLog(@"Looking for globalLocation: %u (?%u)", globalLocation, topGlobalLocation);
    NSAssert2(topGlobalLocation <= [(NSTextStorage *)self.textStorage length],
		@"PROBLEM: text length is: %i >? %i", [(NSTextStorage *)self.textStorage length], topGlobalLocation);
    NSUInteger parsedMode = kiTM2TextUnknownSyntaxMode;
    NSUInteger parsedLength = 0;
    NSUInteger nextMode = kiTM2TextUnknownSyntaxMode;
	// parsedLength is used as a cache
	_iTM2InternalAssert(!self.diagnostic, @"3-BIG PROBLEM IN VALIDATING THE MODE");
    if (globalLocation < topGlobalLocation) {
fixGlobalLocationMode:
//NSLog(@"WE ARE NOW WORKING ON globalLocation: %u, topGlobalLocation: %u", globalLocation, topGlobalLocation);
        [self getSyntaxMode:&parsedMode forLocation:globalLocation previousMode:previousMode effectiveLength:&parsedLength nextModeIn:&nextMode before:topGlobalLocation];
//NSLog(@"next mode is %u, with length: %u previousMode: %u, nextMode: %u", mode, length, previousMode, nextMode);
//N+=length;
#warning INFINITE LOOP DUE TO A RETURNED 0 LENGTH.. DUE TO A RANGE EXCEEDED (1)
        if (parsedMode == previousMode) {
            previousLength += parsedLength;
        } else {
            if (![workingML appendSyntaxMode:previousMode length:previousLength error:&ROR] && ROR) {
                REPORTERRORINMAINTHREAD4iTM3(123,@"MISSED the text storage change",ROR);
                return kiTM2TextErrorSyntaxMode;
            }
            previousLength = parsedLength;
            previousMode = parsedMode;
        }
		if (parsedLength) {
			globalLocation += parsedLength;
			localLocation += parsedLength;
			// now both locations correspond to nextMode if relevant
			// currentSyntaxWordOff7 <= localLocation < nextSyntaxWordOff7?
skipOldSyntaxWords:
			if (localLocation >= nextSyntaxWordOff7)
			// I have parsed a syntax word that was (almost) there before
			// It can happen because either the word has not changed, or has been extended
			{
				if (++syntaxWordIndex < originalModeLine.numberOfSyntaxWords) {
					currentSyntaxWordOff7 = nextSyntaxWordOff7;
					nextSyntaxWordOff7 = originalModeLine.syntaxWordEnds[syntaxWordIndex];
					goto skipOldSyntaxWords;
				} else {
				// nextSyntaxWordOff7 <= localLocation && syntaxWordIndex == originalModeLine.numberOfSyntaxWords
				// in that case, nextSyntaxWordOff7 is the contenstLength of the line and everything is done
				// localLocation is exactly the contentsLength
// [workingML describe];
// NSLog(@"THIS IS THE END, previousMode: %u, previousLength: %u", previousMode, previousLength);
					goto theEnd;
				}
			}
			// Now we have
			// currentSyntaxWordOff7 <= localLocation < nextSyntaxWordOff7
			// syntaxWordIndex < originalModeLine.numberOfSyntaxWords
			if (globalLocation < topGlobalLocation) {
				if (nextMode && nextMode != kiTM2TextUnknownSyntaxMode) {
					// nextMode is the mode at globalLocation
//++N;
                    if (![workingML appendSyntaxMode:previousMode length:previousLength error:&ROR] && ROR) {
                        REPORTERRORINMAINTHREAD4iTM3(123,@"MISSED the text storage change",ROR);
                        return kiTM2TextErrorSyntaxMode;
                    }
					++globalLocation;
					++localLocation;
					previousLength = 1;
					previousMode = nextMode;
					if (globalLocation < topGlobalLocation) {
						goto fixGlobalLocationMode;
					}
				} else {
					[workingML invalidateGlobalRange:iTM3MakeRange(globalLocation, 1)];
					goto fixGlobalLocationMode;
				}
			}
		}
    }
    // the end of this loop occurs when globalLocation>=topGlobalLocation
    // which means originalModeLine.startOff7+iTM3MaxRange(IR) <= globalLocation
//NSLog(@"Modes fixed, syntaxWordIndex: %u, originalModeLine.numberOfSyntaxWords: %u", syntaxWordIndex, originalModeLine.numberOfSyntaxWords);
//[workingML describe];
    // now, we have
    // currentSyntaxWordOff7 = '[originalModeLine offsetAtIndex:syntaxWordIndex]'
    // nextSyntaxWordOff7 = currentSyntaxWordOff7+[originalModeLine syntaxLengthAtIndex:syntaxWordIndex]
    // currentSyntaxWordOff7 <= localLocation < nextSyntaxWordOff7
	_iTM2InternalAssert(!self.diagnostic, @"4-BIG PROBLEM IN VALIDATING THE MODE");
    NSUInteger oldPreviousMode = (localLocation>currentSyntaxWordOff7)? [originalModeLine syntaxModeAtIndex:syntaxWordIndex]:
        (syntaxWordIndex? [originalModeLine syntaxModeAtIndex:syntaxWordIndex-1]:[originalModeLine previousMode]);
    if (oldPreviousMode == previousMode) {
//LOG4iTM3(@"Saving %u words (parsedMode = %u)", originalModeLine.numberOfSyntaxWords-syntaxWordIndex, previousMode);
        if (![workingML appendSyntaxMode:previousMode length:previousLength error:&ROR]
            && ROR
                || ![workingML appendSyntaxMode:[originalModeLine syntaxModeAtIndex:syntaxWordIndex] length:nextSyntaxWordOff7-localLocation error:&ROR]
                    && ROR) {
            REPORTERRORINMAINTHREAD4iTM3(123,@"MISSED the text storage change",ROR);
            return kiTM2TextErrorSyntaxMode;
        }
        previousLength = 0;
        while(++syntaxWordIndex<originalModeLine.numberOfSyntaxWords)
            if (![workingML appendSyntaxMode:[originalModeLine syntaxModeAtIndex:syntaxWordIndex]
                    length:[originalModeLine syntaxLengthAtIndex:syntaxWordIndex] error:&ROR] && ROR) {
                REPORTERRORINMAINTHREAD4iTM3(123,@"MISSED the text storage change",ROR);
                return kiTM2TextErrorSyntaxMode;
            }
    } else if (globalLocation < originalModeLine.contentsEndOff7) {
//NSLog(@"ANOTHER LOOP");
        // the previous mode has changed we must recompute the mode.
        //topGlobalLocation = originalModeLine.startOff7+nextLocalLocation;
        topGlobalLocation = globalLocation+1;
		goto fixGlobalLocationMode;
    }
theEnd:
//NSLog(@"END OK: %u", previousLength);
    if (![workingML appendSyntaxMode:previousMode length:previousLength error:&ROR]
        && ROR
            || [workingML appendSyntaxMode:previousMode length:previousLength error:&ROR]
                && ROR) {
        REPORTERRORINMAINTHREAD4iTM3(123,@"MISSED the text storage change",ROR);
        return kiTM2TextErrorSyntaxMode;
    }
	_iTM2InternalAssert(!workingML.diagnostic, @"***  7<<-before swap :BIG PROBLEM IN VALIDATING THE MODE");
	NSAssert2(workingML.contentsLength == originalModeLine.contentsLength,
		@"***  7<-before swap : BIG PROBLEM IN VALIDATING THE MODE %u != %u",
								workingML.contentsLength, originalModeLine.contentsLength);
    [originalModeLine swapContentsWithModeLine:workingML];
	_iTM2InternalAssert(!self.diagnostic, @"***  7-before END :BIG PROBLEM IN VALIDATING THE MODE");
//NSLog(@"Number of modes really computed: %u/%u", N, originalModeLine.length);
	_iTM2InternalAssert(!self.diagnostic, @"***  END1 :BIG PROBLEM IN VALIDATING THE MODE");
    originalModeLine.EOLMode = [self EOLModeForPreviousMode:previousMode];
//[originalModeLine describe];
//LOG4iTM3(@"Worked hard: local invalid range %@, nextMode: %u", NSStringFromRange([originalModeLine invalidLocalRange]), previousMode);
//END4iTM3;
	_iTM2InternalAssert(!self.diagnostic, @"***  END2 :BIG PROBLEM IN VALIDATING THE MODE");
//END4iTM3;
//    [originalModeLine describe];
	[self didUpdateModeLine:originalModeLine forPreviousMode:previousMode];
	return originalModeLine.EOLMode = (originalModeLine.EOLMode | kiTM2TextEndOfLineSyntaxMask);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  getSyntaxMode:forCharacter:previousMode:
- (NSUInteger)getSyntaxMode:(NSUInteger *)newModeRef forCharacter:(unichar)theChar previousMode:(NSUInteger)previousMode;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Dec 12 22:44:56 GMT 2003
To Do List: 
"*/
{DIAGNOSTIC4iTM3;
	NSParameterAssert(newModeRef);
//START4iTM3;
	*newModeRef = kiTM2TextUnknownSyntaxMode;
	return kiTM2TextNoErrorSyntaxStatus;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  getSyntaxMode:forLocation:previousMode:effectiveLength:nextModeIn:before:
- (NSUInteger)getSyntaxMode:(NSUInteger *)newModeRef forLocation:(NSUInteger)idx previousMode:(NSUInteger)previousMode effectiveLength:(NSUInteger *)lengthRef nextModeIn:(NSUInteger *)nextModeRef before:(NSUInteger)beforeIndex;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Mon Apr 12 17:09:43 UTC 2010
To Do List: 
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSParameterAssert(newModeRef);
	*newModeRef = kiTM2TextUnknownSyntaxMode;
    if (lengthRef) {
        *lengthRef = beforeIndex-idx;
	}
    if (nextModeRef) {
        *nextModeRef = kiTM2TextUnknownSyntaxMode;
	}
    return kiTM2TextNoErrorSyntaxStatus;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  EOLModeForPreviousMode:
- (NSUInteger)EOLModeForPreviousMode:(NSUInteger)previousMode;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Mon Apr 12 17:10:01 UTC 2010
To Do List: 
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//NSLog(@"Character: %@", [NSString stringWithCharacters:&argument length:1]);
//NSLog(@"previousMode: %u", previousMode);
//NSLog(@"result: %u", previousMode-1);
    return previousMode | kiTM2TextRegularSyntaxMode | kiTM2TextEndOfLineSyntaxMask;
}
#pragma mark =-=-=-=-=-=-=-=-=-=-  COMMUNICATION
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= textStorageShouldReplaceCharactersInRange:withString:error:
- (BOOL)textStorageShouldReplaceCharactersInRange:(NSRange)range withString:(NSString *)string error:(NSError **)errorRef;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Mon Apr 19 20:49:30 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (self.diagnostic) {
        if (errorRef) {
            *errorRef = [NSError errorWithDomain:__iTM2_ERROR_DOMAIN__ code:__LINE__
                userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                    @"The mode lines are not in a consistent state before character replacement.",
                    NSLocalizedDescriptionKey,
                        nil]];
        } else {
            LOG4iTM3(@"****  INTERNAL INCONSISTENCY: The mode line is not in a consistent state before replacing characters");
        }
        return NO;
	}
//END4iTM3;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  textStorageDidInsertCarriageReturnAtIndex:editedAttributesRangeIn:error:
- (BOOL)textStorageDidInsertCarriageReturnAtIndex:(NSUInteger)aGlobalLocation editedAttributesRangeIn:(NSRangePointer)editedAttributesRangePtr error:(NSError **)errorRef;
/*"This new version is stronger.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Sun Apr 25 18:08:31 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
    //  There might be a problem wih a \r\n sequence
    //  Was there a \n at aGlobalLocation or is there a \n at aGlobalLocation+1?
	NSUInteger lineIndex = [self lineIndexForLocation4iTM3:aGlobalLocation];
	iTM2ModeLine * ML = [self modeLineAtIndex:lineIndex];
    if (ML.diagnostic) {
        if (errorRef) {
            *errorRef = [NSError errorWithDomain:__iTM2_ERROR_DOMAIN__ code:__LINE__
                userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                    @"STARTING WITH A BAD MODE LINE!!!",
                    NSLocalizedDescriptionKey,
                        nil]];
        } else {
            LOG4iTM3(@"****  INTERNAL INCONSISTENCY: STARTING WITH A BAD MODE LINE!!!");
        }
        return NO;
    }
    //  actually
    //  ML.startOff7 <= aGlobalLocation < ML.endOff7
    //  Most common situation: \r inserted before 1 non EOL
    iTM2ModeLine * ml = nil;
    NSRange R,r;
    if (aGlobalLocation < ML.contentsEndOff7) {
        //  the line is splitted at index aGlobalLocation+1
        //  what is at aGlobalLocation and after will go to the next line
        if ((ml = [ML modeLineBySplittingFromGlobalLocation:aGlobalLocation error:errorRef])) {
            [ml invalidateLocalRange:iTM3MakeRange(0,1)];
            //  Now set up the EOL for ML
            ML.EOLLength = 1;
            ML.EOLMode = kiTM2TextUnknownSyntaxMode;
            [self insertModeLine:ml atIndex:lineIndex+1];
            ml.startOff7 = ML.endOff7;
#ifdef __ELEPHANT_MODELINE__
            NSString * S = [self.textStorage string];
            ML -> originalString = [S substringWithRange:ML.completeRange];
            ml -> originalString = [S substringWithRange:ml.completeRange];
#endif
            [ML getSyntaxMode:NULL atGlobalLocation:aGlobalLocation longestRange:&R];
            //  to fix the edited range:
            //  get a syntax mode range including location and the index before if it is in the same line
            if (aGlobalLocation > ML.startOff7 && aGlobalLocation == R.location) {
                [ML getSyntaxMode:NULL atGlobalLocation:aGlobalLocation-1 longestRange:&r];
                r.length += R.length;
                R = r;
            }
            if (R.location > ML.startOff7 && R.length <= 1) {
                [ML getSyntaxMode:NULL atGlobalLocation:R.location-1 longestRange:&r];
                r.length += R.length;
                R = r;
            }
            [ML invalidateGlobalRange:R];
            if (editedAttributesRangePtr) {
                *editedAttributesRangePtr = ML.invalidGlobalRange;
            }
            [self invalidateModesFromIndex:lineIndex];
            [self invalidateOff7sFromIndex:lineIndex+1];
diagnostic_and_return:
            if (self.diagnostic) {
                if (errorRef) {
                    *errorRef = [NSError errorWithDomain:__iTM2_ERROR_DOMAIN__ code:__LINE__
                        userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                            @"Could not insert character properly, please report bug.",
                            NSLocalizedDescriptionKey,
                                nil]];
                } else {
                    LOG4iTM3(@"****  INTERNAL INCONSISTENCY: Could not insert character properly, please report bug.");
                }
                return NO;
            }
            return YES;
        }
        if (errorRef) {
            *errorRef = [NSError errorWithDomain:__iTM2_ERROR_DOMAIN__ code:__LINE__
                userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                    @"d:( Could not insert character properly.",
                    NSLocalizedDescriptionKey,
                        nil]];
        } else {
            LOG4iTM3(@"****  INTERNAL INCONSISTENCY: Could not insert character properly.");
        }
        return NO;
    }
    //  aGlobalLocation >= ML.contentsEndOff7
    //  4 possibilities
    //  - insert a \r before a \n but after a \r
    //  - insert a \r before a \n
    //  - insert a \r before another kind of EOL
    //  - insert a \r after an EOL
    NSString * S = [self.textStorage string];
    if (aGlobalLocation+1 < S.length && [S characterAtIndex:aGlobalLocation+1] == '\n') {
        //  the newly inserted \r creates an \r\n EOL sequence
        //  maybe there was already a \r\n sequence such that there is now a \r\r\n sequence!
        if (ML.contentsEndOff7 == aGlobalLocation) {
            //  NO \r originally before the \n
            ML.EOLLength = 2;
#ifdef __ELEPHANT_MODELINE__
            ML -> originalString = [S substringWithRange:ML.completeRange];
#endif
            R = ML.EOLRange;
            [ML invalidateGlobalRange:R];
            if (editedAttributesRangePtr) {
                *editedAttributesRangePtr = ML.invalidGlobalRange;
            }
            [self invalidateModesFromIndex:lineIndex];
            [self invalidateOff7sFromIndex:lineIndex+1];
            goto diagnostic_and_return;
        }
        //  ML.contentsEndOff7 != aGlobalLocation
        //  and aGlobalLocation >= ML.contentsEndOff7
        //  give aGlobalLocation > ML.contentsEndOff7
        //  "\r\n" -> "\r\r\n"
        ML.EOLLength = 1;
        ml = [iTM2ModeLine modeLine];
        ml.EOLMode = ML.EOLMode;
        ml.EOLLength = 2;
        ml.startOff7 = ML.endOff7;
#ifdef __ELEPHANT_MODELINE__
        ML -> originalString = [S substringWithRange:ML.completeRange];
        ml -> originalString = [S substringWithRange:ml.completeRange];
#endif
        [self insertModeLine:ml atIndex:lineIndex+1];
        [self invalidateOff7sFromIndex:lineIndex+2];
        if (editedAttributesRangePtr) {
            *editedAttributesRangePtr = ML.EOLRange;
            editedAttributesRangePtr->length += ml.EOLLength;
        }
        goto diagnostic_and_return;
    }
    //  '\r' is before an EOL?
    if (ML.EOLLength) {
        // YES
        ml = [iTM2ModeLine modeLine];
        ml.EOLMode = ML.EOLMode;
        ml.EOLLength = ML.EOLLength;
        ML.EOLLength = 1;
        ml.startOff7 = ML.endOff7;
#ifdef __ELEPHANT_MODELINE__
        ML -> originalString = [S substringWithRange:ML.completeRange];
        ml -> originalString = [S substringWithRange:ml.completeRange];
#endif
        [self insertModeLine:ml atIndex:lineIndex+1];
        [self invalidateOff7sFromIndex:lineIndex+2];
        if (editedAttributesRangePtr) {
            *editedAttributesRangePtr = ML.EOLRange;
            editedAttributesRangePtr->length += ml.EOLLength;
        }
        goto diagnostic_and_return;
    }
    //  \r was appended to a line with 
    ML.EOLLength = 1;
    ML.EOLMode = kiTM2TextUnknownSyntaxMode;
#ifdef __ELEPHANT_MODELINE__
    ML -> originalString = [S substringWithRange:ML.completeRange];
#endif
    if (editedAttributesRangePtr) {
        *editedAttributesRangePtr = ML.EOLRange;
    }
    //  insert a new void mode line
    ml = [iTM2ModeLine modeLine];
    ml.startOff7 = ML.endOff7;
    [self insertModeLine:ml atIndex:lineIndex+1];
    [self invalidateOff7sFromIndex:lineIndex+2];
    goto diagnostic_and_return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  textStorageDidInsertLineFeedAtIndex:editedAttributesRangeIn:error:
- (BOOL)textStorageDidInsertLineFeedAtIndex:(NSUInteger)aGlobalLocation editedAttributesRangeIn:(NSRangePointer)editedAttributesRangePtr error:(NSError **)errorRef;
/*"This new version is stronger.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Sat May  1 09:34:51 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
    //  There might be a problem wih a \r\n sequence
    //  Is there a \r at aGlobalLocation - 1
	NSUInteger lineIndex = [self lineIndexForLocation4iTM3:aGlobalLocation];
	iTM2ModeLine * ML = [self modeLineAtIndex:lineIndex];
    if (ML.diagnostic) {
        if (errorRef) {
            *errorRef = [NSError errorWithDomain:__iTM2_ERROR_DOMAIN__ code:__LINE__
                userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                    @"STARTING WITH A BAD MODE LINE!!!",
                    NSLocalizedDescriptionKey,
                        nil]];
        } else {
            LOG4iTM3(@"****  INTERNAL INCONSISTENCY: STARTING WITH A BAD MODE LINE!!!");
        }
        return NO;
    }
    //  actually
    //  ML.startOff7 <= aGlobalLocation < ML.endOff7
    //  Most common situation: \n inserted after 1 non EOL
    iTM2ModeLine * ml = nil;
    NSRange R,r;
    NSString * S = nil;
    if (aGlobalLocation > ML.startOff7) {
        if (aGlobalLocation < ML.contentsEndOff7) {
            //  the line is splitted at index aGlobalLocation + 1
            //  so the mode line is splitted at index aGlobalLocation (no change made yet)
            //  what is at aGlobalLocation and after will go to the next line
            if ((ml = [ML modeLineBySplittingFromGlobalLocation:aGlobalLocation error:errorRef])) {
                [ml invalidateLocalRange:iTM3MakeRange(0,1)];
                //  Now set up the EOL for ML
                ML.EOLLength = 1;
                ML.EOLMode = kiTM2TextUnknownSyntaxMode;
                [self insertModeLine:ml atIndex:lineIndex+1];
                ml.startOff7 = ML.endOff7;
#ifdef __ELEPHANT_MODELINE__
                NSString * S = [self.textStorage string];
                ML -> originalString = [S substringWithRange:ML.completeRange];
                ml -> originalString = [S substringWithRange:ml.completeRange];
#endif
                [ML getSyntaxMode:NULL atGlobalLocation:aGlobalLocation longestRange:&R];
                //  to fix the edited range:
                //  get a syntax mode range including location and the index before if it is in the same line
                if (aGlobalLocation > ML.startOff7 && aGlobalLocation == R.location) {
                    [ML getSyntaxMode:NULL atGlobalLocation:aGlobalLocation-1 longestRange:&r];
                    r.length += R.length;
                    R = r;
                }
                if (R.location > ML.startOff7 && R.length <= 1) {
                    [ML getSyntaxMode:NULL atGlobalLocation:R.location-1 longestRange:&r];
                    r.length += R.length;
                    R = r;
                }
                [ML invalidateGlobalRange:R];
                if (editedAttributesRangePtr) {
                    *editedAttributesRangePtr = ML.invalidGlobalRange;
                }
                [self invalidateModesFromIndex:lineIndex];
                [self invalidateOff7sFromIndex:lineIndex+1];
diagnostic_and_return:
                if (self.diagnostic) {
                    if (errorRef) {
                        *errorRef = [NSError errorWithDomain:__iTM2_ERROR_DOMAIN__ code:__LINE__
                            userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                                @"Could not insert character properly, please report bug.",
                                NSLocalizedDescriptionKey,
                                    nil]];
                    } else {
                        LOG4iTM3(@"****  INTERNAL INCONSISTENCY: Could not insert character properly, please report bug.");
                    }
                    return NO;
                }
                return YES;
            }
            if (errorRef) {
                *errorRef = [NSError errorWithDomain:__iTM2_ERROR_DOMAIN__ code:__LINE__
                    userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                        @"d:( Could not insert character properly.",
                        NSLocalizedDescriptionKey,
                            nil]];
            } else {
                LOG4iTM3(@"****  INTERNAL INCONSISTENCY: Could not insert character properly.");
            }
            return NO;
        }
        //  aGlobalLocation >= ML.contentsEndOff7
        //  there is a potential problem with ML's EOL
        //  3 possibilities
        //  - insert a \n after a \r
        //  - insert a \n after another kind of EOL
        //  - insert a \n before an EOL
        if (aGlobalLocation == ML.contentsEndOff7) {
            //  most common situation ?
            ml = [iTM2ModeLine modeLine];
            ml.EOLMode = ML.EOLMode;
            ml.EOLLength = ML.EOLLength;
            ML.EOLLength = 1;
            ml.startOff7 = ML.endOff7;
#ifdef __ELEPHANT_MODELINE__
            ML -> originalString = [S substringWithRange:ML.completeRange];
            ml -> originalString = [S substringWithRange:ml.completeRange];
#endif
            [self insertModeLine:ml atIndex:lineIndex+1];
            [self invalidateOff7sFromIndex:lineIndex+2];
            if (editedAttributesRangePtr) {
                *editedAttributesRangePtr = ML.EOLRange;
                editedAttributesRangePtr->length += ml.EOLLength;
            }
            goto diagnostic_and_return;
        }
        //  ML.endOff7 >= aGlobalLocation > ML.contentsEndOff7
        S = [self.textStorage string];
        if ([S characterAtIndex:aGlobalLocation-1] == '\r') {
            //  the newly inserted \n creates an \r\n EOL sequence
            //  either it breaks an existing EOL sequence in two or it just extands an '\r' sequence
            if (ML.EOLLength == 1) {
                //  just augment the EOL length
                ML.EOLLength = 2;
#ifdef __ELEPHANT_MODELINE__
                ML -> originalString = [S substringWithRange:ML.completeRange];
#endif
                R = ML.EOLRange;
                [ML invalidateGlobalRange:R];
                if (editedAttributesRangePtr) {
                    *editedAttributesRangePtr = ML.invalidGlobalRange;
                }
                [self invalidateModesFromIndex:lineIndex];
                [self invalidateOff7sFromIndex:lineIndex+1];
                goto diagnostic_and_return;
            }
            //  ML.EOLLength > 1
            //  The newly inserted \n splits an existing \r\n into \r\n+\n
            ml = [iTM2ModeLine modeLine];
            ml.EOLMode = ML.EOLMode;
            ml.EOLLength = ML.EOLLength-1;
            ML.EOLLength = 2;
            ml.startOff7 = ML.endOff7;
#ifdef __ELEPHANT_MODELINE__
            ML -> originalString = [S substringWithRange:ML.completeRange];
            ml -> originalString = [S substringWithRange:ml.completeRange];
#endif
            [self insertModeLine:ml atIndex:lineIndex+1];
            [self invalidateOff7sFromIndex:lineIndex+2];
            if (editedAttributesRangePtr) {
                *editedAttributesRangePtr = ML.EOLRange;
                editedAttributesRangePtr->length += ml.EOLLength;
            }
            goto diagnostic_and_return;
        }
        //  No \r before, just append a new mode line
        ml = [iTM2ModeLine modeLine];
        ml.EOLMode = ML.EOLMode;
        ml.EOLLength = 1;
        ml.startOff7 = ML.endOff7;
#ifdef __ELEPHANT_MODELINE__
        ml -> originalString = [S substringWithRange:ml.completeRange];
#endif
        [self insertModeLine:ml atIndex:lineIndex+1];
        [self invalidateOff7sFromIndex:lineIndex+2];
        if (editedAttributesRangePtr) {
            *editedAttributesRangePtr = ml.EOLRange;
        }
        goto diagnostic_and_return;
    }
    //  there is a potential \r\n problem with the previous EOL
    if (aGlobalLocation) {
        S = [self.textStorage string];
        if ([S characterAtIndex:aGlobalLocation-1] == '\r') {
            ml = [self modeLineAtIndex:aGlobalLocation-1];
            ml.EOLLength += 1;
            ML.startOff7 += 1;
#ifdef __ELEPHANT_MODELINE__
            ML -> originalString = [S substringWithRange:ML.completeRange];
            ml -> originalString = [S substringWithRange:ml.completeRange];
#endif
            [self invalidateOff7sFromIndex:lineIndex+1];
            if (editedAttributesRangePtr) {
                *editedAttributesRangePtr = ml.EOLRange;
            }
            goto diagnostic_and_return;
        }
        //  no \r before
    }
    //  nothing before
    ml = [iTM2ModeLine modeLine];
    ml.EOLMode = kiTM2TextUnknownSyntaxMode;
    ml.EOLLength = 1;
    ml.startOff7 = aGlobalLocation;
#ifdef __ELEPHANT_MODELINE__
    ml -> originalString = [S substringWithRange:ml.completeRange];
#endif
    [self insertModeLine:ml atIndex:lineIndex];
    R = ml.EOLRange;
    [ml invalidateGlobalRange:R];
    if (editedAttributesRangePtr) {
        *editedAttributesRangePtr = ml.invalidGlobalRange;
    }
    [self invalidateModesFromIndex:lineIndex];
    [self invalidateOff7sFromIndex:lineIndex+1];
    goto diagnostic_and_return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  textStorageDidInsertSingleEOLAtIndex:editedAttributesRangeIn:error:
- (BOOL)textStorageDidInsertSingleEOLAtIndex:(NSUInteger)aGlobalLocation editedAttributesRangeIn:(NSRangePointer)editedAttributesRangePtr error:(NSError **)errorRef;
/*"This new version is stronger.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Sat May  1 09:34:51 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
	NSUInteger lineIndex = [self lineIndexForLocation4iTM3:aGlobalLocation];
	iTM2ModeLine * ML = [self modeLineAtIndex:lineIndex];
    if (ML.diagnostic) {
        if (errorRef) {
            *errorRef = [NSError errorWithDomain:__iTM2_ERROR_DOMAIN__ code:__LINE__
                userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                    @"STARTING WITH A BAD MODE LINE!!!",
                    NSLocalizedDescriptionKey,
                        nil]];
        } else {
            LOG4iTM3(@"****  INTERNAL INCONSISTENCY: STARTING WITH A BAD MODE LINE!!!");
        }
        return NO;
    }
    //  actually
    //  ML.startOff7 <= aGlobalLocation < ML.endOff7
    //  Most common situation: single EOL inserted before 1 non EOL
    //  There might be a problem wih a \r\n sequence
    //  Was there a \n at aGlobalLocation or is there a \n at aGlobalLocation+1?
    iTM2ModeLine * ml = nil;
    NSRange R,r;
    if (aGlobalLocation < ML.contentsEndOff7) {
        //  the line is splitted at index aGlobalLocation+1
        //  the mode line is splitted at index aGlobalLocation (they are not yet sync'ed)
        //  what is at aGlobalLocation and after will go to the next line
        if ((ml = [ML modeLineBySplittingFromGlobalLocation:aGlobalLocation error:errorRef])) {
            [ml invalidateLocalRange:iTM3MakeRange(0,1)];
            //  Now set up the EOL for ML
            ML.EOLLength = 1;
            ML.EOLMode = kiTM2TextUnknownSyntaxMode;
            [self insertModeLine:ml atIndex:lineIndex+1];
            ml.startOff7 = ML.endOff7;
#ifdef __ELEPHANT_MODELINE__
            NSString * S = [self.textStorage string];
            ML -> originalString = [S substringWithRange:ML.completeRange];
            ml -> originalString = [S substringWithRange:ml.completeRange];
#endif
            [ML getSyntaxMode:NULL atGlobalLocation:aGlobalLocation longestRange:&R];
            //  to fix the edited range:
            //  get a syntax mode range including location and the index before if it is in the same line
            if (aGlobalLocation > ML.startOff7 && aGlobalLocation == R.location) {
                [ML getSyntaxMode:NULL atGlobalLocation:aGlobalLocation-1 longestRange:&r];
                r.length += R.length;
                R = r;
            }
            if (R.location > ML.startOff7 && R.length <= 1) {
                [ML getSyntaxMode:NULL atGlobalLocation:R.location-1 longestRange:&r];
                r.length += R.length;
                R = r;
            }
            [ML invalidateGlobalRange:R];
            if (editedAttributesRangePtr) {
                *editedAttributesRangePtr = ML.invalidGlobalRange;
            }
            [self invalidateModesFromIndex:lineIndex];
            [self invalidateOff7sFromIndex:lineIndex+1];
diagnostic_and_return:
            if (self.diagnostic) {
                if (errorRef) {
                    *errorRef = [NSError errorWithDomain:__iTM2_ERROR_DOMAIN__ code:__LINE__
                        userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                            @"Could not insert character properly, please report bug.",
                            NSLocalizedDescriptionKey,
                                nil]];
                } else {
                    LOG4iTM3(@"****  INTERNAL INCONSISTENCY: Could not insert character properly, please report bug.");
                }
                return NO;
            }
            return YES;
        }
        if (errorRef) {
            *errorRef = [NSError errorWithDomain:__iTM2_ERROR_DOMAIN__ code:__LINE__
                userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                    @"d:( Could not insert character properly.",
                    NSLocalizedDescriptionKey,
                        nil]];
        } else {
            LOG4iTM3(@"****  INTERNAL INCONSISTENCY: Could not insert character properly.");
        }
        return NO;
    }
    //  aGlobalLocation >= ML.contentsEndOff7
    //  2 possibilities
    //  - break a \r\n
    //  - insert before the EOL
    if (ML.EOLLength == 0) {
        ML.EOLLength = 1;
        ML.EOLMode = kiTM2TextUnknownSyntaxMode;
        ml = [iTM2ModeLine modeLine];
        ml.startOff7 = ML.endOff7;
#ifdef __ELEPHANT_MODELINE__
        ML -> originalString = [[self.textStorage string] substringWithRange:ML.completeRange];
#endif
        R = ML.EOLRange;
        [ML invalidateGlobalRange:R];
        if (editedAttributesRangePtr) {
            *editedAttributesRangePtr = ML.invalidGlobalRange;
        }
        [self insertModeLine:ml atIndex:lineIndex+1];
        [self invalidateModesFromIndex:lineIndex];
        [self invalidateOff7sFromIndex:lineIndex+1];
        goto diagnostic_and_return;
    }
    if (ML.EOLLength == 2) {
        if (aGlobalLocation > ML.contentsEndOff7) {
            //  \r\n is broken, 2 EOLs added?
            ML.EOLLength = 1;
            ml = [iTM2ModeLine modeLine];
            ml.EOLMode = ML.EOLMode;
            ml.EOLLength = 1;
            ml.startOff7 = ML.endOff7;
#ifdef __ELEPHANT_MODELINE__
            ML -> originalString = [[self.textStorage string] substringWithRange:ML.completeRange];
            ml -> originalString = [[self.textStorage string] substringWithRange:ml.completeRange];
#endif
            R = ML.EOLRange;
            [ML invalidateGlobalRange:R];
            if (editedAttributesRangePtr) {
                *editedAttributesRangePtr = R;
                editedAttributesRangePtr -> length = 3;
            }
            [self insertModeLine:ml atIndex:lineIndex+1];
            ml = [iTM2ModeLine modeLine];
            ml.EOLMode = ML.EOLMode;
            ml.EOLLength = 1;
            ml.startOff7 = ML.endOff7;
#ifdef __ELEPHANT_MODELINE__
            ml -> originalString = [[self.textStorage string] substringWithRange:ml.completeRange];
#endif
            [self insertModeLine:ml atIndex:lineIndex+2];
            [self invalidateModesFromIndex:lineIndex];
            [self invalidateOff7sFromIndex:lineIndex+3];
            goto diagnostic_and_return;
        }
        //  The single EOL was inserted just before the \r\n
    }
    ml = [iTM2ModeLine modeLine];
    ml.EOLMode = ML.EOLMode;
    ml.EOLLength = ML.EOLLength;
    ML.EOLLength = 1;
    ml.startOff7 = ML.endOff7;
#ifdef __ELEPHANT_MODELINE__
    ML -> originalString = [[self.textStorage string] substringWithRange:ML.completeRange];
    ml -> originalString = [[self.textStorage string] substringWithRange:ml.completeRange];
#endif
    R = ML.EOLRange;
    [ML invalidateGlobalRange:R];
    if (editedAttributesRangePtr) {
        *editedAttributesRangePtr = ML.invalidGlobalRange;
    }
    [self insertModeLine:ml atIndex:lineIndex+1];
    [self invalidateModesFromIndex:lineIndex];
    [self invalidateOff7sFromIndex:lineIndex+2];
    goto diagnostic_and_return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  textStorageDidInsertNonEOLCharacterAtIndex:editedAttributesRangeIn:error:
- (BOOL)textStorageDidInsertNonEOLCharacterAtIndex:(NSUInteger)aGlobalLocation editedAttributesRangeIn:(NSRangePointer)editedAttributesRangePtr error:(NSError **)errorRef;
/*"This new version is stronger.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Sat May  1 09:34:51 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
	NSUInteger lineIndex = [self lineIndexForLocation4iTM3:aGlobalLocation];
	iTM2ModeLine * ML = [self modeLineAtIndex:lineIndex];
    if (ML.diagnostic) {
        if (errorRef) {
            *errorRef = [NSError errorWithDomain:__iTM2_ERROR_DOMAIN__ code:__LINE__
                userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                    @"STARTING WITH A BAD MODE LINE!!!",
                    NSLocalizedDescriptionKey,
                        nil]];
        } else {
            LOG4iTM3(@"****  INTERNAL INCONSISTENCY: STARTING WITH A BAD MODE LINE!!!");
        }
        return NO;
    }
    //  actually
    //  ML.startOff7 <= aGlobalLocation < ML.endOff7
    //  Most common situation: single EOL inserted before 1 non EOL
    //  There might be a problem wih a \r\n sequence
    NSRange R,r;
    if (aGlobalLocation <= ML.contentsEndOff7) {
        if ([ML enlargeSyntaxModeAtGlobalLocation:aGlobalLocation length:1 error:errorRef]) {
#ifdef __ELEPHANT_MODELINE__
            NSString * S = [self.textStorage string];
            ML -> originalString = [S substringWithRange:ML.completeRange];
#endif
            [ML getSyntaxMode:NULL atGlobalLocation:aGlobalLocation longestRange:&R];
            //  to fix the edited range:
            //  get a syntax mode range including location and the index before if it is in the same line
            if (aGlobalLocation > ML.startOff7 && aGlobalLocation == R.location) {
                [ML getSyntaxMode:NULL atGlobalLocation:aGlobalLocation-1 longestRange:&r];
                r.length += R.length;
                R = r;
            }
            if (R.location > ML.startOff7 && R.length <= 1) {
                [ML getSyntaxMode:NULL atGlobalLocation:R.location-1 longestRange:&r];
                r.length += R.length;
                R = r;
            }
            [ML invalidateGlobalRange:R];
            if (editedAttributesRangePtr) {
                *editedAttributesRangePtr = ML.invalidGlobalRange;
            }
            [self invalidateModesFromIndex:lineIndex];
            [self invalidateOff7sFromIndex:lineIndex+1];
//diagnostic_and_return:
            if (self.diagnostic) {
                if (errorRef) {
                    *errorRef = [NSError errorWithDomain:__iTM2_ERROR_DOMAIN__ code:__LINE__
                        userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                            @"Could not insert character properly, please report bug.",
                            NSLocalizedDescriptionKey,
                                nil]];
                } else {
                    LOG4iTM3(@"****  INTERNAL INCONSISTENCY: Could not insert character properly, please report bug.");
                }
                return NO;
            }
            return YES;        
        }
        return NO;
    }
    //  ML.endOff7 > aGlobalLocation > ML.contentsEndOff7
    //  We inserted a character just between the \r\n EOL sequence
    //  replace by insertioin of 2 characters, the latter being the \n
    ML.EOLLength = 1;
    [self invalidateOff7sFromIndex:lineIndex+1];
    return [self textStorageDidInsertCharactersAtIndex:aGlobalLocation count:2 editedAttributesRangeIn:editedAttributesRangePtr error:errorRef];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  textStorageDidInsertCharacterAtIndex:error:
- (BOOL)textStorageDidInsertCharacterAtIndex:(NSUInteger)aGlobalLocation editedAttributesRangeIn:(NSRangePointer)editedAttributesRangePtr error:(NSError **)errorRef;
/*"This new version is stronger.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Mon Apr 12 19:14:24 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    switch ([[self.textStorage string] characterAtIndex:aGlobalLocation]) {
        case '\n':
            return [self textStorageDidInsertLineFeedAtIndex:aGlobalLocation editedAttributesRangeIn:editedAttributesRangePtr error:errorRef];
        case '\r':
            return [self textStorageDidInsertCarriageReturnAtIndex:aGlobalLocation editedAttributesRangeIn:editedAttributesRangePtr error:errorRef];
        case 0x0085:
        case 0x2028:
        case 0x2029:
            return [self textStorageDidInsertSingleEOLAtIndex:aGlobalLocation editedAttributesRangeIn:editedAttributesRangePtr error:errorRef];
        default:
            return [self textStorageDidInsertNonEOLCharacterAtIndex:aGlobalLocation editedAttributesRangeIn:editedAttributesRangePtr error:errorRef];
    }
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  textStorageDidReplaceCharactersAtIndex:count:withCount:editedAttributesRangeIn:error:
- (BOOL)textStorageDidReplaceCharactersAtIndex:(NSUInteger)location count:(NSUInteger)oldCount withCount:(NSUInteger)newCount editedAttributesRangeIn:(NSRangePointer)editedAttributesRangePtr error:(NSError **)errorRef;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Apr 21 17:34:00 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSParameterAssert(newCount>0);
    NSParameterAssert(oldCount>0);
    //  very simple method
    //  First get the range of full lines that span over the original characters range
    NSUInteger first = [self lineIndexForLocation4iTM3:location];
    NSUInteger last  = [self lineIndexForLocation4iTM3:location+oldCount];
    //  This is the range of mode lines that we are going to change
    //  The corresponding character range is
    iTM2ModeLine * ML = [self modeLineAtIndex:first];
    NSUInteger firstChar = ML.startOff7;
    ML = [self modeLineAtIndex:last];
    NSUInteger lastChar = ML.endOff7;
    //  After the change, this last char index becomes
    lastChar += newCount - oldCount;
    //  We now parse the string to create new mode lines
    NSString * S = [self.textStorage string];
    NSUInteger contentsEnd;
    NSRange R = iTM3MakeRange(firstChar, 0);
    NSMutableArray * newModes = [NSMutableArray array];
    // we create a new line
    ML = [iTM2ModeLine modeLine];
    ML.startOff7 = R.location;
    [S getLineStart:nil end:&R.location contentsEnd:&contentsEnd forRange:R];
    if (contentsEnd < firstChar) {
        //  this can occur in only one situation:
        //  the previous line ends with a '\r' EOL
        //  the inserted char starts with a '\n'
        //  the insertion location is exactly after the '\r'
        //  As a consequence, we have first > 0
        //  Before the change, we had
        //  ML.startOff7 <= ML.contentsEndOff7 <= ML.endOff7
        //  now contentsEnd < ML.startOff7 <= R.location
        //  this means that ML.startOff7 is now inside the EOL sequence
        //  if we inserted something else than a \n..., the contentsEnd should be >= ML.startOff7
        //  if we insert something like \n... and no \r before, the contentsEnd should be == ML.startOff7
        //  if we insert something like \n... and a \r before, the contentsEnd should be == ML.startOff7 - 1
        //  WHAT we do is manage the leading \n, then the remaining inserted chars
        if (!first) {
            if (errorRef) {
                *errorRef = [NSError errorWithDomain:__iTM2_ERROR_DOMAIN__ code:__LINE__
                    userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                        @"Internal inconsistency, first is 0.",
                        NSLocalizedDescriptionKey,
                            nil]];
            } else {
                LOG4iTM3(@"****  INTERNAL INCONSISTENCY: first is 0");
            }
            return NO;
        }
        ML = [self modeLineAtIndex:first - 1];
        ML.EOLLength = R.location - contentsEnd;
        [self invalidateOff7sFromIndex:first];
        //  R.location - location is the number of inserted characters
        //  that go to the EOL sequence
        if (oldCount -= R.location - location) {
            if (newCount -= R.location - location) {
                return [self textStorageDidReplaceCharactersAtIndex:location+1 count:oldCount withCount:newCount editedAttributesRangeIn:editedAttributesRangePtr error:errorRef];
            } else {
                return [self textStorageDidDeleteCharacterAtIndex:location+1 editedAttributesRangeIn:editedAttributesRangePtr error:errorRef];
            }
        } else if (newCount -= R.location - location) {
            return [self textStorageDidInsertCharactersAtIndex:location+1 count:newCount editedAttributesRangeIn:editedAttributesRangePtr error:errorRef];
        } else {
            //  R.location - location characters have been added to the EOL sequence
            //  They must be removed from the mode line at index first
            ML = [self modeLineAtIndex:first];
            if ([ML deleteModesInGlobalMakeRange:ML.startOff7:1 error:errorRef]) {
                if (editedAttributesRangePtr) {
                    // we ignore the leading inserted '\n'
                    * editedAttributesRangePtr = iTM3MakeRange(firstChar+1, lastChar-firstChar-1);
                }
                return YES;
            }
            return NO;
        }
    }
    while (YES) {
        ML.EOLLength = R.location-contentsEnd;
        if (contentsEnd>ML.startOff7 && ![ML appendSyntaxMode:kiTM2TextUnknownSyntaxMode length:contentsEnd-ML.startOff7 error:errorRef]) {
            return NO;
        }
#ifdef __ELEPHANT_MODELINE__
        ML->originalString = [S substringWithRange:ML.completeRange];
#endif
        [newModes addObject:ML];
        if (R.location < lastChar) {
            ML = [iTM2ModeLine modeLine];
            ML.startOff7 = R.location;
            [S getLineStart:nil end:&R.location contentsEnd:&contentsEnd forRange:R];
            continue;
        }
        [self invalidateOff7sFromIndex:last+1];
        [self invalidateModesFromIndex:first];
        //  Do I have to insert a void mode line ?
        if (ML.EOLLength && last == self.numberOfModeLines - 1) {
            ML = [iTM2ModeLine modeLine];
            ML.startOff7 = R.location;
            [newModes addObject:ML];
        }
        [self replaceModeLinesInRange:iTM3MakeRange(first, last-first+1) withModeLines:newModes];
        if (self.diagnostic) {
            if (errorRef) {
                *errorRef = [NSError errorWithDomain:__iTM2_ERROR_DOMAIN__ code:__LINE__
                    userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                        @"Could not replace characters properly, please report bug.",
                        NSLocalizedDescriptionKey,
                            nil]];
            } else {
                LOG4iTM3(@"****  INTERNAL INCONSISTENCY: Could not replace characters properly, please report bug.");
            }
            return NO;
        }
        //  Record the change in attributes
        if (editedAttributesRangePtr) {
            * editedAttributesRangePtr = iTM3MakeRange(firstChar, lastChar-firstChar);
        }
        return YES;
    }
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  textStorageDidInsertCharactersAtIndex:count:editedAttributesRangeIn:error:
- (BOOL)textStorageDidInsertCharactersAtIndex:(NSUInteger)location count:(NSUInteger)count editedAttributesRangeIn:(NSRangePointer)editedAttributesRangePtr error:(NSError **)errorRef;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Apr 21 17:06:07 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    //  There are different situations
    //  - depending on location
    //  - depending on the inserted characters
    //  Consider firstML the modeLine of location
    //  We have always
    //      firstML.startOff7 <= location <= firstML.endOff7
    //  and
    //      location < firstML.endOff7
    //      OR
    //      firstML.endOff7 == location AND firstML is the last mode line
    //
    //  There are 3 different kinds of region where we insert things
    //  - the contents
    //  - the EOL
    //  - the end
    //  The inserted characters may contain EOLs
    NSParameterAssert(count>0);
    //  very simple method
    //  First get the range of full lines that span over the original characters range
    NSUInteger first = [self lineIndexForLocation4iTM3:location];
    //  This is the range of mode lines that we are going to change
    //  The corresponding character range is
    iTM2ModeLine * firstML = [self modeLineAtIndex:first];
    NSUInteger firstChar = firstML.startOff7;
    NSUInteger lastChar = firstML.endOff7;
    //  After the change, this last char index becomes
    lastChar += count;
    //  We now parse the string to create new mode lines
    NSString * S = [self.textStorage string];
    NSUInteger contentsEnd;
    NSRange R = iTM3MakeRange(firstChar, 0);
    // we create a new line
    iTM2ModeLine * ML = [iTM2ModeLine modeLine];
    ML.startOff7 = R.location;// store R.location
    [S getLineStart:nil end:&R.location contentsEnd:&contentsEnd forRange:R];
    if (contentsEnd < firstChar) {
        //  this can occur in only one situation:
        //  the previous line ends with a '\r' EOL
        //  the inserted char starts with a '\n'
        //  the insertion location is exactly after the '\r'
        //  As a consequence, we have first > 0
        //  Before the change, we had
        //  ML.startOff7 <= ML.contentsEndOff7 <= ML.endOff7
        //  now contentsEnd < ML.startOff7 <= R.location
        //  this means that ML.startOff7 is now inside the EOL sequence
        //  if we inserted something else than a \n..., the contentsEnd should be >= ML.startOff7
        //  if we insert something like \n... and no \r before, the contentsEnd should be == ML.startOff7
        //  if we insert something like \n... and a \r before, the contentsEnd should be == ML.startOff7 - 1
        //  WHAT we do is manage the leading \n, then the remaining inserted chars
        if (!first) {
            if (errorRef) {
                *errorRef = [NSError errorWithDomain:__iTM2_ERROR_DOMAIN__ code:__LINE__
                    userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                        @"Internal inconsistency, first is 0.",
                        NSLocalizedDescriptionKey,
                            nil]];
            } else {
                LOG4iTM3(@"****  INTERNAL INCONSISTENCY: first is 0");
            }
            return NO;
        }
        ML = [self modeLineAtIndex:first - 1];
        ML.EOLLength = R.location - contentsEnd;
        firstML.startOff7 = ML.endOff7;
        [self invalidateOff7sFromIndex:first+1];
        count -= R.location - location;
        return count > 1?
            [self textStorageDidInsertCharactersAtIndex:location+1 count:count editedAttributesRangeIn:editedAttributesRangePtr error:errorRef]:
            [self textStorageDidInsertCharacterAtIndex:location+1 editedAttributesRangeIn:editedAttributesRangePtr error:errorRef];
    }
    NSRange r = iTM3MakeRange(0,0);
    if (R.location == lastChar) {
        //  We will return from this block
        //  the inserted chars did not contain an EOL or the original string did not contain an EOL
        //  only one line is modified, we do not have to change everything
        if (R.location > contentsEnd) {
#           define newEOLLength contentsEnd
            newEOLLength = R.location - contentsEnd;
            if (firstML.EOLLength < newEOLLength) {
                //  We return from this block
                //  The new EOL is bigger than the original one
                //  The # of inserted characters that constitute the new EOL sequence is
                //  newEOLLength - firstML.EOLLength
                //  remove those chars from the count of inserted characters
                count -= newEOLLength - firstML.EOLLength;
                //  we have inserted exactly count characters without the terminating EOL
                if (!firstML.EOLLength) {
                    //  firstML was the last mode line, insert one supplemental mode line after
                    [self insertModeLine:ML atIndex:first+1];
                    firstML.EOLLength = newEOLLength;
                    [firstML invalidateGlobalRange:firstML.EOLRange];
                    firstML.EOLMode = kiTM2TextUnknownSyntaxMode;
                    ML.startOff7 = firstML.endOff7;
                    ML = nil;
                } else {
                    firstML.EOLLength = newEOLLength;
                    [firstML invalidateGlobalRange:firstML.EOLRange];
                }
                return count>1?
                    [self textStorageDidInsertCharactersAtIndex:location count:count editedAttributesRangeIn:editedAttributesRangePtr error:errorRef]:
                    [self textStorageDidInsertCharacterAtIndex:location editedAttributesRangeIn:editedAttributesRangePtr error:errorRef];
            }
#           undef newEOLLength
            //  the inserted characters did not contain an EOL
        }
        if ([firstML enlargeSyntaxModeAtGlobalLocation:location length:count error:errorRef]) {
            [firstML getSyntaxMode:NULL atGlobalLocation:location longestRange:&R];
            //  to fix the edited range:
            //  get a syntax mode range including location and the index before if it is in the same line
            if (location > firstML.startOff7 && location == R.location) {
                [firstML getSyntaxMode:NULL atGlobalLocation:location-1 longestRange:&r];
                r.length += R.length;
                R = r;
            }
            if (R.location > firstML.startOff7 && R.length <= 1) {
                [firstML getSyntaxMode:NULL atGlobalLocation:R.location-1 longestRange:&r];
                r.length += R.length;
                R = r;
            }
            [firstML invalidateGlobalRange:R];
            if (editedAttributesRangePtr) {
                *editedAttributesRangePtr = firstML.invalidGlobalRange;
            }
			[self invalidateModesFromIndex:first];
			[self invalidateOff7sFromIndex:first+1];
diagnostic_and_return:
            if (self.diagnostic) {
                if (errorRef) {
                    *errorRef = [NSError errorWithDomain:__iTM2_ERROR_DOMAIN__ code:__LINE__
                        userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                            @"Could not replace characters properly, please report bug.",
                            NSLocalizedDescriptionKey,
                                nil]];
                } else {
                    LOG4iTM3(@"****  INTERNAL INCONSISTENCY: Could not replace characters properly, please report bug.");
                }
                return NO;
            }
            return YES;
        }
        return NO;
    }
    //  R.location < firstML.endOff7 + count
    //  An EOL was inserted or \r\n was broken
    if (location > firstML.contentsEndOff7) {
        if (location < firstML.endOff7) {
            //  firstML.contendsOff7 < location < firstML.endsOff7;
            //  we broke a \r\n sequence
            //  did we insert something starting with a \n ?
            if ([S characterAtIndex:location] == '\n') {
                //  we replaced the already existing '\n' with another one
                //  In fact we do not break the \r\n sequence
                //  let us consider that we do not insert the whole string but only the part after the EOL
                //  completed with a final '\n'
                return [self textStorageDidInsertCharactersAtIndex:location+1 count:count editedAttributesRangeIn:editedAttributesRangePtr error:errorRef];
            }
            //  We did not insert something starting with a '\n'
            //  separate the \r and the \n
            //  we consider that the \n was inserted
            firstML.EOLLength = R.location - contentsEnd;
            [self invalidateOff7sFromIndex:first+1];
#ifdef __ELEPHANT_MODELINE__
            firstML->originalString = [S substringWithRange:firstML.completeRange];
#endif
            return [self textStorageDidInsertCharactersAtIndex:location count:count+1 editedAttributesRangeIn:editedAttributesRangePtr error:errorRef];
        }
    }
    NSMutableArray * newModes = [NSMutableArray array];
    while (YES) {
        ML.EOLLength = R.location-contentsEnd;
        if (contentsEnd>ML.startOff7 && ![ML appendSyntaxMode:kiTM2TextUnknownSyntaxMode length:contentsEnd-ML.startOff7 error:errorRef]) {
            return NO;
        }
#ifdef __ELEPHANT_MODELINE__
        ML->originalString = [S substringWithRange:ML.completeRange];
#endif
        [newModes addObject:ML];
        if (R.location < lastChar) {
            ML = [iTM2ModeLine modeLine];
            ML.startOff7 = R.location;
            [S getLineStart:nil end:&R.location contentsEnd:&contentsEnd forRange:R];
            continue;
        }
        if (ML.EOLLength && first == self.numberOfModeLines-1) {
            ML = [iTM2ModeLine modeLine];
            ML.startOff7 = R.location;
            [newModes addObject:ML];
        }
        if (newModes.count > 1) {
            [self replaceModeLinesInRange:iTM3MakeRange(first,1) withModeLines:newModes];
            [self invalidateModesFromIndex:first];
            //  Record the change in attributes
            if (editedAttributesRangePtr) {
                * editedAttributesRangePtr = iTM3MakeRange(firstChar, lastChar-firstChar);
            }
            goto diagnostic_and_return;
        }
        firstML = newModes.lastObject;
        [self replaceModeLineAtIndex:first withModeLine:firstML];
        [firstML getSyntaxMode:NULL atGlobalLocation:location longestRange:&R];
        //  to fix the edited range:
        //  get a syntax mode range including location and the index before if it is in the same line
        if (location > firstML.startOff7 && location == R.location) {
            [firstML getSyntaxMode:NULL atGlobalLocation:location-1 longestRange:&r];
            r.length += R.length;
            R = r;
        }
        if (R.location > firstML.startOff7 && R.length <= 1) {
            [firstML getSyntaxMode:NULL atGlobalLocation:R.location-1 longestRange:&r];
            r.length += R.length;
            R = r;
        }
        [firstML invalidateGlobalRange:R];
        R.location += firstChar - firstML.startOff7;
        if (editedAttributesRangePtr) {
            *editedAttributesRangePtr = R;
        }
        [self invalidateModesFromIndex:first];
        goto diagnostic_and_return;
    }
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  textStorageDidDeleteCharacterAtIndex:editedAttributesRangeIn:error:
- (BOOL)textStorageDidDeleteCharacterAtIndex:(NSUInteger)location editedAttributesRangeIn:(NSRangePointer)editedAttributesRangePtr error:(NSError **)errorRef;
/*"Desription Forthcoming.sss
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Fri Apr 23 20:58:35 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (location > NSUIntegerMax - 1) {
        if (errorRef) {
            *errorRef = [NSError errorWithDomain:__iTM2_ERROR_DOMAIN__ code:__LINE__
                userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                    @"Could not delete characters, bounds exceeded.",
                    NSLocalizedDescriptionKey,
                        nil]];
        } else {
            LOG4iTM3(@"****  INTERNAL INCONSISTENCY: Could not delete characters, bounds exceeded");
        }
        return NO;
    }
    NSUInteger lineIndex = [self lineIndexForLocation4iTM3:location];
    iTM2ModeLine * workingML = [self modeLineAtIndex:lineIndex];
    if (location < workingML.contentsEndOff7) {
		if ([workingML deleteModesInGlobalMakeRange:location:1 error:errorRef]) {
            if (0 == workingML.length) {
                //  The line is simply removed
                if (self.numberOfModeLines > 1) {
                    [self removeModeLineAtIndex:lineIndex];
                }
                if (editedAttributesRangePtr) {
                    editedAttributesRangePtr->location = location;
                    editedAttributesRangePtr->length = 0;
                }
return_YES:
                if (errorRef) {
                    *errorRef = nil;
                }
                return YES;
            }
            NSRange R;
invalidate_and_return_YES:
            [workingML getSyntaxMode:NULL atGlobalLocation:location longestRange:&R];
            //  to fix the edited range:
            //  get a syntax mode range including location and the index before if it is in the same line
            NSRange r;
            if (location > workingML.startOff7 && location == R.location) {
                [workingML getSyntaxMode:NULL atGlobalLocation:location-1 longestRange:&r];
                r.length += R.length;
                R = r;
            }
            if (R.location > workingML.startOff7 && R.length <= 1) {
                [workingML getSyntaxMode:NULL atGlobalLocation:R.location-1 longestRange:&r];
                r.length += R.length;
                R = r;
            }
            [workingML invalidateGlobalRange:R];
            if (editedAttributesRangePtr) {
                *editedAttributesRangePtr = workingML.invalidGlobalRange;
            }
			[self invalidateModesFromIndex:lineIndex];
			[self invalidateOff7sFromIndex:lineIndex+1];
diagnostic_and_return:
            if (self.diagnostic) {
                if (errorRef) {
                    *errorRef = [NSError errorWithDomain:__iTM2_ERROR_DOMAIN__ code:__LINE__
                        userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                            @"Could not delete one character properly.",
                            NSLocalizedDescriptionKey,
                                nil]];
                } else {
                    LOG4iTM3(@"****  INTERNAL INCONSISTENCY: Could not delete one character properly.");
                }
                return NO;
            }
            goto return_YES;
		}
        return NO;
    }
    if (location >= workingML.endOff7) {
        if (errorRef) {
            *errorRef = [NSError errorWithDomain:__iTM2_ERROR_DOMAIN__ code:__LINE__
                userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                    @"Can't one char out of bounds.",
                    NSLocalizedDescriptionKey,
                        nil]];
        } else {
            LOG4iTM3(@"****  INTERNAL INCONSISTENCY: Can't one char out of bounds.");
        }
        return NO;
    }
    //  workingML.contentsEndOff7 <= location < workingML.endOff7
    //  We are removing an EOL, or part of an EOL
    //  We are removing the whole EOL
    if (workingML.EOLLength) {
        [self invalidateOff7sFromIndex:lineIndex+1];// no need to change the mode
        --workingML.EOLLength;
        if (editedAttributesRangePtr) {
            *editedAttributesRangePtr = workingML.EOLRange;
        }
        if (workingML.EOLLength == 0) {
            //  Maybe we should merge with the following mode line if any:
            if (lineIndex+1<self.numberOfModeLines) {
                iTM2ModeLine * nextML = [self modeLineAtIndex:++lineIndex];
                if ([workingML appendSyntaxModesFromModeLine:nextML error:errorRef]) {
                    [self removeModeLineAtIndex:lineIndex];
                    goto invalidate_and_return_YES;
                }
                return NO;
            }
        }
        goto diagnostic_and_return;
    }
    if (errorRef) {
        *errorRef = [NSError errorWithDomain:__iTM2_ERROR_DOMAIN__ code:__LINE__
            userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                @"Nothing to delete.",
                NSLocalizedDescriptionKey,
                    nil]];
    } else {
        LOG4iTM3(@"****  INTERNAL INCONSISTENCY: Nothing to delete");
    }
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  textStorageDidDeleteCharactersAtIndex:count:editedAttributesRangeIn:error:
- (BOOL)textStorageDidDeleteCharactersAtIndex:(NSUInteger)location count:(NSUInteger)count editedAttributesRangeIn:(NSRangePointer)editedAttributesRangePtr error:(NSError **)errorRef;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Fri Apr 23 20:58:40 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSParameterAssert(count>0);
    NSUInteger oldFirstIndex = [self lineIndexForLocation4iTM3:location];
    //  get the line of the first undeleted character
    if (location > NSUIntegerMax - count) {
        if (errorRef) {
            *errorRef = [NSError errorWithDomain:__iTM2_ERROR_DOMAIN__ code:__LINE__
                userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                    @"Could not delete characters, bounds exceeded.",
                    NSLocalizedDescriptionKey,
                        nil]];
        } else {
            LOG4iTM3(@"****  INTERNAL INCONSISTENCY: Could not delete characters, bounds exceeded");
        }
        return NO;
    }
	NSUInteger oldLastIndex = [self lineIndexForLocation4iTM3:location+count];
    //  We remove all intermediate lines
    iTM2ModeLine * oldLast = nil;
    if (oldLastIndex) {
        while (oldLastIndex - 1 > oldFirstIndex) {
            //  remove the mode line before oldLastIndex
            oldLast = [self modeLineAtIndex:--oldLastIndex];
            count -= oldLast.length;
            [self removeModeLineAtIndex:oldLastIndex];
            [self invalidateOff7sFromIndex:oldLastIndex];
        }
    }
    //  oldLastIndex <= oldFirstIndex + 1
    iTM2ModeLine * oldFirst = [self modeLineAtIndex:oldFirstIndex];
	if (editedAttributesRangePtr) {
		NSUInteger location = oldFirst.startOff7;
		* editedAttributesRangePtr = iTM3MakeRange(location,[self.textStorage length]-location);
	}
    NSRange R = iTM3MakeRange(0,0);
    NSRange r = iTM3MakeRange(0,0);
    NSString * S = nil;
    NSUInteger contentsEnd = 0;
    if (oldLastIndex == oldFirstIndex) {
        //  the characters deleted all come from the same line
        if([oldFirst deleteModesInGlobalMakeRange:location:count error:errorRef]) {
            //  No problem in editing the mode line
            if (0 == oldFirst.length) {
                //  The line is simply removed
                if (self.numberOfModeLines>1) {
                    [self removeModeLineAtIndex:oldFirstIndex];
                }
                if (editedAttributesRangePtr) {
                    editedAttributesRangePtr->location = location;
                    editedAttributesRangePtr->length = 0;
                }
return_YES:
                if (errorRef) {
                    *errorRef = nil;
                }
                return YES;
            }
            // should I merge with the previous ?
            if (oldFirstIndex && (oldFirst.EOLLength == 1) && !oldFirst.contentsLength) {
                //  oldFirst is a pure 1 length EOL and is not the 1st one
                S = [self.textStorage string];
                if (S.length) {
                    [S getLineStart:NULL end:NULL contentsEnd:&contentsEnd forRange:NSMakeRange(oldFirst.startOff7,0)];
                    if (contentsEnd < oldFirst.startOff7) {
                        oldLast = [self modeLineAtIndex:oldFirstIndex-1];
                        ++oldLast.EOLLength;
                        [self removeModeLineAtIndex:oldFirstIndex];
                        oldFirst = oldLast;
                        if (editedAttributesRangePtr) {
                            *editedAttributesRangePtr = oldFirst.EOLRange;
                        }
                        [self invalidateOff7sFromIndex:oldFirstIndex--];
                        [self invalidateModesFromIndex:oldFirstIndex];
diagnostic_and_return:
                        if (self.diagnostic) {
                            if (errorRef) {
                                *errorRef = [NSError errorWithDomain:__iTM2_ERROR_DOMAIN__ code:__LINE__
                                    userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                                        @"Could not delete characters.",
                                        NSLocalizedDescriptionKey,
                                            nil]];
                            } else {
                                LOG4iTM3(@"****  INTERNAL INCONSISTENCY: Could not delete characters.");
                            }
                            return NO;
                        }
                        goto return_YES;
                    }
                }
            }
invalidate_first_and_return_YES:
            [oldFirst getSyntaxMode:NULL atGlobalLocation:location longestRange:&R];
            //  to fix the edited range:
            //  get a syntax mode range including location and the index before if it is in the same line
            if (location > oldFirst.startOff7 && location == R.location) {
                [oldFirst getSyntaxMode:NULL atGlobalLocation:location-1 longestRange:&r];
                r.length += R.length;
                R = r;
            }
            if (R.location > oldFirst.startOff7 && R.length <= 1) {
                [oldFirst getSyntaxMode:NULL atGlobalLocation:R.location-1 longestRange:&r];
                r.length += R.length;
                R = r;
            }
            [oldFirst invalidateGlobalRange:R];
            if (editedAttributesRangePtr) {
                *editedAttributesRangePtr = oldFirst.invalidGlobalRange;
            }
            [self invalidateOff7sFromIndex:oldFirstIndex+1];
            [self invalidateModesFromIndex:oldFirstIndex];
            goto diagnostic_and_return;
        }
        return NO;
    }
    //  maybe the last character deleted was just the EOL, such that I should merge with the next line, if any
    oldLast = [self modeLineAtIndex:oldLastIndex];
    if (oldLast.startOff7 == location+count) {
        //  We remove nothing from oldLast
        //  Did I remove the whole EOL or just one part?
        if (location > oldFirst.contentsEndOff7) {
            //  just one part
            oldFirst.EOLLength = location - oldFirst.contentsEndOff7;//  do not invalidate the EOL mode
            if (editedAttributesRangePtr) {
                //  fix the edited range
                //  returns a syntax mode range including location and the index before if it is in the same line
                *editedAttributesRangePtr = oldFirst.EOLRange;
            }
            [self invalidateOff7sFromIndex:oldLastIndex];
            goto diagnostic_and_return;
        }
        //  I removed the whole EOL and maybe more
        if (location == oldFirst.startOff7) {
            //  the whole firstLine line is removed, no more, no less
            [self removeModeLineAtIndex:oldLastIndex];
            oldFirst = oldLast;
            oldFirst.startOff7 = location;
            goto invalidate_first_and_return_YES;
        }
        //  merge modes from oldLast then remove oldLast
        if ([oldFirst deleteModesInGlobalMakeRange:location:count error:errorRef]
                && [oldFirst appendSyntaxModesFromModeLine:oldLast error:errorRef]) {
            [self removeModeLineAtIndex:oldLastIndex];
            goto invalidate_first_and_return_YES;
        }
        return NO;
    }
    //  we have
    //  oldLast.startOff7 < location + count < oldLast.endOff7
    if ([oldLast deleteModesInGlobalMakeRange:oldLast.startOff7:location+count-oldLast.startOff7 error:errorRef]) {
        //  oldFirst.startOff7 <= location < oldFirst.endOff7
        //  oldLast.location < location + count < oldLast.endOff7
        if (location == oldFirst.startOff7) {
            //  the whole firstLine line is removed
            [self removeModeLineAtIndex:oldFirstIndex];
            oldFirst = oldLast;
            oldFirst.startOff7 = location;
            goto invalidate_first_and_return_YES;
        }
        //  location > oldFirst.startOff7
        //  Do we remove only part of EOLs from oldFirst
        if (location > oldFirst.contentsEndOff7) {
            oldFirst.EOLLength = location - oldFirst.contentsEndOff7;
            //  Maybe we have to merge with the following mode line
            if (oldLast.contentsLength) {
                //  NO
                goto invalidate_first_and_return_YES;
            }
            //  We may have to merge
            if (oldLast.EOLLength == 1) {
                S = [self.textStorage string];
                if (S.length) {
                    [S getLineStart:NULL end:NULL contentsEnd:&contentsEnd forRange:NSMakeRange(oldFirst.endOff7,0)];
                    if (contentsEnd < oldFirst.endOff7) {
                        ++oldFirst.EOLLength;
                        [self removeModeLineAtIndex:oldLastIndex];
                    }
                }
            }
            goto invalidate_first_and_return_YES;
        }
        //  We remove the whole EOL of oldFirst
        if ([oldFirst deleteModesInGlobalMakeRange:location:oldFirst.endOff7-location error:errorRef]
            && [oldFirst appendSyntaxModesFromModeLine:oldLast error:errorRef]) {
            [self removeModeLineAtIndex:oldLastIndex];
            goto invalidate_first_and_return_YES;
        }
    }
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  textStorageWillProcessEditing
- (void)textStorageWillProcessEditing;
/*"Default implementation does nothing. Subclassers will append their job. Delegate can change the characters or attributes
Version history: 
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  textStorageDidProcessEditing
- (void)textStorageDidProcessEditing;
/*"Default implementation does nothing. Subclassers will append their job. Delegate can change the attributes.
Version history: 
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= didClickOnLink4iTM3:atIndex:
- (BOOL)didClickOnLink4iTM3:(id)link atIndex:(NSUInteger)charIndex;
/*"Given a line range number, it returns the range including the ending characters.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	return NO;
}
@synthesize previousLineIndex = iVarPLI4iTM3;
@synthesize previousLocation = iVarPL4iTM3;
@synthesize textStorage = iVarTS4iTM3;
@synthesize modeLines = iVarMLs4iTM3;
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setAttributesServer:
- (void)setAttributesServer:(iTM2TextSyntaxParserAttributesServer *)argument;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Mon Apr 12 09:48:07 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if ((iVarAS4iTM3 != argument) && (iVarAS4iTM3 = argument)) {
        self.setUpAllTextViews;
    }
    return;
}
@synthesize attributesServer = iVarAS4iTM3;
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  iTM2ModeLine
/*"This is the model object to store the attributes of a single line.
Stores the contentsEnd and end as given by NSString's #{getLineStart:end:contentsEnd:forRange:},
relative to the start idx. Two mutable data of integers, at each idx we have the length on one hand
and the attribute value on the other.
Rmk: The length data should be -1 terminated,
such that the description will remain valid even if chars are inserted or deleted."*/


@implementation iTM2ModeLine
#pragma mark =-=-=-=-=-=-=-=-=-=-  CONSTRUCTOR/DESTRUCTOR
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  modeLine
+ (id)modeLine;
/*"This is and "end of text". The contentsEnd and end are fixed to -1.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [[self.alloc initWithString:@"" atCursor:nil] autorelease];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  initWithString:atCursor:
- (id)initWithString:(NSString *)aString atCursor:(NSUInteger *)cursorPtr;
/*"Designated initializer. The cursor is meant to point to the beginning of the line (typically given by a #{getLineStart:..} or 0)
on return, it will point to the beginning of the next line. If the cursor is nil, it is assumed to point to 0.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Tue Apr  6 14:00:05 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//NSLog(@"DEBUG initWithString: <%@> cursor: %#x, %u", aString, cursor, (cursor? *cursor: 0));
    if ((self = [super init])) {
        self.startOff7 = 0;
        _NumberOfSyntaxWords = 0;
        _MaxNumberOfSyntaxWords = _iTM2_MODE_BLOC_;
        size_t size = _MaxNumberOfSyntaxWords * sizeof(NSInteger);
		__SyntaxWordModes = NSAllocateCollectable(size,NSScannedOption);
        __SyntaxWordLengths = NSAllocateCollectable(size,NSScannedOption);
        size += sizeof(NSInteger);
        __SyntaxWordOff7s = NSAllocateCollectable(size,NSScannedOption);
        if (!__SyntaxWordOff7s || !__SyntaxWordLengths || !__SyntaxWordModes) {
            LOG4iTM3(@"NOTHING!!!");
            _MaxNumberOfSyntaxWords = 0;
			__SyntaxWordOff7s = NULL;
			__SyntaxWordLengths = NULL;
			__SyntaxWordModes = NULL;
            __SyntaxWordEnds = NULL;
        } else {
            __SyntaxWordEnds = __SyntaxWordOff7s+1;
            __SyntaxWordLengths[0] = __SyntaxWordModes[0] = __SyntaxWordOff7s[0] = __SyntaxWordOff7s[1] = 0;
        }
        if (aString.length) {
            NSUInteger contents = 0;
            NSUInteger length = 0;
            if (cursorPtr) {
                self.startOff7 = *cursorPtr;
                NSUInteger start = MIN(* cursorPtr, aString.length);
//NSLog(@"GLS 1");
                [aString getLineStart:nil end:cursorPtr contentsEnd:&contents forRange:iTM3MakeRange(start, 0)];
                length = *cursorPtr-start;
                contents -= start;
#ifdef __ELEPHANT_MODELINE__
				originalString = [aString substringWithRange:iTM3MakeRange(start, *cursorPtr-start)];
#endif
//LOG4iTM3(@"self.length is: %u, contents is: %u, *cursorPtr is: %u", self.length, contents, *cursorPtr);
            } else {
//NSLog(@"GLS 2");
                self.startOff7 = 0;
                [aString getLineStart:nil end:&length contentsEnd:&contents forRange:iTM3MakeRange(0, 0)];
#ifdef __ELEPHANT_MODELINE__
				originalString = [aString substringWithRange:iTM3MakeRange(0, length)];
#endif
            }
            self.EOLLength = length-contents;
            NSError * ROR = nil;
            if (![self appendNormalSyntaxMode:kiTM2TextUnknownSyntaxMode length:contents error:&ROR] && ROR) {
                REPORTERRORINMAINTHREAD4iTM3(123,@"MISSED the text storage change",ROR);
                return self;
            }
        } else {
#ifdef __ELEPHANT_MODELINE__
			originalString = @"";
#endif
            self.startOff7 = self.EOLLength = 0;
        }
		self.invalidLocalRange = iTM3MakeRange(0, NSUIntegerMax);
        self.previousMode = kiTM2TextUnknownSyntaxMode;
        self.EOLMode = kiTM2TextUnknownSyntaxMode;
		_Status = 0;
		_Depth = 0;
    }
    //NSLog(@"DEBUG initWithString: END");
//self.describe;
    return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  modeLineBySplittingFromGlobalLocation:error:
- (iTM2ModeLine *) modeLineBySplittingFromGlobalLocation:(NSUInteger)location error:(NSError **)errorRef;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Sat Apr 24 17:25:17 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
    iTM2ModeLine * ML = [iTM2ModeLine modeLine];
    if (location >= self.endOff7) {
        return ML;
    }
    if (location <= self.startOff7) {
        [ML swapContentsWithModeLine:self];
        ML.EOLMode = self.EOLMode;
        ML.EOLLength = self.EOLLength;
        self.EOLLength = 0;
        return ML;
    }
    if (location >= self.contentsEndOff7) {
        ML.EOLLength = self.endOff7 - location;
        ML.EOLMode = self.EOLMode;
    } else {
        NSUInteger i = 0;
        NSUInteger local = location - self.startOff7;
        while (i < self.numberOfSyntaxWords) {
            NSUInteger l = [self syntaxLengthAtIndex:i];
            if (l > local) {
                if (![ML appendSyntaxMode:[self syntaxModeAtIndex:i] length:l-local error:errorRef]) {
                    return nil;
                }
                while (++i < self.numberOfSyntaxWords) {
                    if (![ML appendSyntaxMode:[self syntaxModeAtIndex:i] length:[self syntaxLengthAtIndex:i] error:errorRef]) {
                        return nil;
                    }
                }
                ML.EOLMode = self.EOLMode;
                ML.EOLLength = self.EOLLength;
                break;
            }
            // local >= l
            local -= l;
            ++i;
        }
    }
    return [self deleteModesInGlobalRange:iTM3MakeRange(location,self.endOff7 - location) error:errorRef]?ML:nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  isEqualToModeLine:
- (BOOL)isEqualToModeLine:(iTM2ModeLine *)lhs;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Mon Apr  5 16:51:25 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
    if ( !self.diagnostic && !lhs.diagnostic
            && self.startOff7 == lhs.startOff7
            && self.commentOff7 == lhs.commentOff7
            && self.contentsEndOff7 == lhs.contentsEndOff7
            && self.endOff7 == lhs.endOff7
            && self.uncommentedLength == lhs.uncommentedLength
            && self.commentedLength == lhs.commentedLength
            && self.contentsLength == lhs.contentsLength
            && self.length == lhs.length
            && self.EOLLength == lhs.EOLLength
            && self.previousMode == lhs.previousMode
            && self.EOLMode == lhs.EOLMode
            && self.status == lhs.status
            && self.depth == lhs.depth
            && self->_NumberOfSyntaxWords == lhs->_NumberOfSyntaxWords) {
        NSUInteger idx = 0;
        while (idx < self->_NumberOfSyntaxWords) {
            if (self->__SyntaxWordOff7s[idx] != lhs->__SyntaxWordOff7s[idx]) {
                return NO;
            }
            if (self->__SyntaxWordModes[idx] != lhs->__SyntaxWordModes[idx]) {
                return NO;
            }
            ++idx;
        }
        return YES;
    }
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  swapContentsWithModeLine:
- (void)swapContentsWithModeLine:(iTM2ModeLine *)swapModeLine;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Sat Dec 13 10:35:39 GMT 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (iTM2DebugEnabled > 999999) {
        if (self.diagnostic) {
            LOG4iTM3(@"BAD RECEIVER!!!!");
        }
        if ([swapModeLine diagnostic]) {
            LOG4iTM3(@"BAD ARGUMENT!!!!");
        }
        if (self.contentsLength != swapModeLine.contentsLength) {
            LOG4iTM3(@"!?!?!?!?!?! \n\n\n\nIT IS NOT A GOOD IDEA TO SWAP MODE LINES WITH DIFFERENT CONTENTS LENGTHS!!!!(mine: %u, his: %u)", self.contentsLength, swapModeLine.contentsLength);
        }
		//  It is possible to swap mode lines with different EOL lengths:
        //  the EOL length is not swapped.
    }
    NSUInteger temp;
    #define _iTM2_SWAP(C, A, B) C=A;A=B;B=C;
//    _iTM2_SWAP(temp, self.startOff7, swapModeLine.startOff7); do not swap the startOff7
    _iTM2_SWAP(temp, self.uncommentedLength, swapModeLine.uncommentedLength);
    _iTM2_SWAP(temp, self.commentedLength, swapModeLine.commentedLength);
//    _iTM2_SWAP(temp, self.previousMode, swapModeLine.previousMode); do not swap the previousMode
//    _iTM2_SWAP(temp, self.EOLMode, swapModeLine.EOLMode); do not swap the EOLMode
    _iTM2_SWAP(temp, _NumberOfSyntaxWords, swapModeLine->_NumberOfSyntaxWords);
    _iTM2_SWAP(temp, _MaxNumberOfSyntaxWords, swapModeLine->_MaxNumberOfSyntaxWords);
    void * tempPtr;
    _iTM2_SWAP(tempPtr, __SyntaxWordOff7s, swapModeLine->__SyntaxWordOff7s);
    _iTM2_SWAP(tempPtr, __SyntaxWordLengths, swapModeLine->__SyntaxWordLengths);
    _iTM2_SWAP(tempPtr, __SyntaxWordModes, swapModeLine->__SyntaxWordModes);
    _iTM2_SWAP(tempPtr, __SyntaxWordEnds, swapModeLine->__SyntaxWordEnds);
    NSRange  tempRange;
    _iTM2_SWAP(tempRange, self.invalidLocalRange, swapModeLine.invalidLocalRange);
    // consistency:
	if (self.diagnostic) {
        LOG4iTM3(@"BAD SWAPPING METHOD!!!!");
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  describe
- (void)describe;
/*"Description forthcoming. Raises exception when things are not consistent.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Tue Apr  6 22:10:54 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
    START4iTM3;
    NSLog(@"self.startOff7: %lu", self.startOff7);
    NSLog(@"self.commentOff7: %lu", self.commentOff7);
    NSLog(@"self.contentsEndOff7: %lu", self.contentsEndOff7);
    NSLog(@"self.endOff7: %lu", self.endOff7);
    // local coordinates
    NSLog(@"self.uncommentedLength: %lu", self.uncommentedLength);
    NSLog(@"self.commentedLength: %lu", self.commentedLength);
    NSLog(@"self.contentsLength: %lu", self.contentsLength);
    NSLog(@"self.length: %lu", self.length);
    NSLog(@"self.EOLLength: %lu", self.EOLLength);
    NSLog(@"self.invalidLocalRange: %@", NSStringFromRange(self.invalidLocalRange));
    NSLog(@"self.invalidGlobalRange: %@", NSStringFromRange(self.invalidGlobalRange));
    // modes
    NSLog(@"self.previousMode: %lu", self.previousMode);
    NSLog(@"self.EOLMode: %lu", self.EOLMode);
    NSLog(@"_NumberOfSyntaxWords: %lu", _NumberOfSyntaxWords);
    NSLog(@"_MaxNumberOfSyntaxWords: %lu", _MaxNumberOfSyntaxWords);
    NSLog(@"__SyntaxWordOff7s:  %#x",__SyntaxWordOff7s);
    NSLog(@"__SyntaxWordEnds:   %#x",__SyntaxWordEnds);
    NSLog(@"__SyntaxWordLengths:%#x",__SyntaxWordLengths);
    NSLog(@"__SyntaxWordModes:  %#x",__SyntaxWordModes);
    NSUInteger idx = 0;
    while (idx<_NumberOfSyntaxWords) {
        NSLog(@"idx: %4lu, offset:%4lu, end:%4lu(= %4lu), length:%4lu, mode:%4lu",
            idx, __SyntaxWordOff7s[idx], __SyntaxWordEnds[idx], __SyntaxWordOff7s[idx+1], __SyntaxWordLengths[idx], __SyntaxWordModes[idx]);
        ++idx;
    }
    NSLog(@"__SyntaxWordOff7s[_NumberOfSyntaxWords]=%lu=%lu",__SyntaxWordOff7s[_NumberOfSyntaxWords],self.contentsLength);
#ifdef __ELEPHANT_MODELINE__
	NSLog(@"originalString is: <%@>", originalString);
#endif
    END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  diagnostic
- (BOOL)diagnostic;
/*"Description forthcoming. Returns YES when things are not consistent.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Mon Apr  5 17:57:02 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (iTM2DebugEnabled < 10000) {
		return NO;
    }
    if (__SyntaxWordOff7s && (__SyntaxWordOff7s+1 != __SyntaxWordEnds)) {
        LOG4iTM3(@"**** __SyntaxWordOff7s+1 (%lu) != __SyntaxWordEnds (%lu)", __SyntaxWordOff7s+1, __SyntaxWordEnds);
        goto bail;
    }
    if (self.contentsEndOff7 != self.startOff7+self.contentsLength) {
        LOG4iTM3(@"**** self.contentsEndOff7(%lu) != self.startOff7(%lu)+self.contentsLength(%lu)", self.contentsEndOff7, self.startOff7, self.contentsLength);
        goto bail;
    }
    if (self.endOff7 != self.startOff7+self.length) {
        LOG4iTM3(@"**** self.endOff7(%lu) != self.startOff7(%lu)+self.length(%lu)", self.endOff7, self.startOff7, self.length);
        goto bail;
    }
    if (self.length != self.contentsLength+self.EOLLength) {
        LOG4iTM3(@"**** self.length(%lu) != self.contentsLength(%lu)+self.EOLLength(%lu)", self.length, self.contentsLength, self.EOLLength);
        goto bail;
    }
    if (_NumberOfSyntaxWords) {
        if (!__SyntaxWordOff7s) {
            LOG4iTM3(@"**** NO __SyntaxWordOff7s!!!!!");
            goto bail;
        }
        if (__SyntaxWordOff7s[0] != 0) {
            LOG4iTM3(@"**** __SyntaxWordOff7s[0] != 0 !!!!!");
            goto bail;
        }

        NSUInteger idx = 0;
        while(idx<_NumberOfSyntaxWords) {
            if (__SyntaxWordEnds[idx] != __SyntaxWordOff7s[idx]+__SyntaxWordLengths[idx]) {
                LOG4iTM3(@"idx: %lu, __SyntaxWordEnds[idx](%lu) != __SyntaxWordOff7s[idx](%lu)+__SyntaxWordLengths[idx](%lu)", idx, __SyntaxWordEnds[idx], __SyntaxWordOff7s[idx], __SyntaxWordLengths[idx]);
                goto bail;
            } else {
                ++idx;
            }
        }
		if ( self.invalidLocalRange.location > self.length) {
			if (self.contentsLength != __SyntaxWordEnds[_NumberOfSyntaxWords-1]) {
				LOG4iTM3(@"**** self.contentsLength(%lu) != __SyntaxWordEnds[_NumberOfSyntaxWords-1](%lu)", self.contentsLength, __SyntaxWordEnds[_NumberOfSyntaxWords-1]);
				goto bail;
			}
			if (self.contentsLength != __SyntaxWordOff7s[_NumberOfSyntaxWords]) {
				LOG4iTM3(@"**** self.contentsLength(%lu) != __SyntaxWordOff7s[%lu](%lu=%lu)", self.contentsLength, _NumberOfSyntaxWords, __SyntaxWordOff7s[_NumberOfSyntaxWords], __SyntaxWordEnds[_NumberOfSyntaxWords-1]);
				NSUInteger idx = 0;
				while(idx <= _NumberOfSyntaxWords) {
					NSLog(@"idx: %lu, __SyntaxWordOff7s[idx]:%lu", idx, __SyntaxWordOff7s[idx]),++idx;
                }
				idx = 0;
				while(idx < _NumberOfSyntaxWords) {
					NSLog(@"idx: %lu, __SyntaxWordEnds[idx]:%lu", idx, __SyntaxWordEnds[idx]), ++idx;
                }
				goto bail;
			}
        }
    }
    return NO;
    bail:
    self.describe;
    return YES;
}
#pragma mark =-=-=-=-=-=-=-=-=-=-  SETTER/GETTER
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  setStartOff7:
- (void)setStartOff7:(NSUInteger)argument;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Mon Apr  5 17:59:05 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    _EndOff7 = (_ContentsEndOff7 = (_CommentOff7 = (_StartOff7 = argument) + _UncommentedLength) + _CommentedLength) + _EOLLength;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  setUncommentedLength:
- (void)setUncommentedLength:(NSUInteger)argument;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Mon Apr  5 17:01:35 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    _Length = (_EndOff7 = (_ContentsEndOff7 = (_CommentOff7 = _StartOff7 + (_UncommentedLength = argument)) + _CommentedLength) + _EOLLength) - _StartOff7;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  setCommentedLength:
- (void)setCommentedLength:(NSUInteger)argument;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Mon Apr  5 17:01:35 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    _Length = (_EndOff7 = (_ContentsEndOff7 = _CommentOff7 + (_CommentedLength = argument)) + _EOLLength) - _StartOff7;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  setEOLLength:
- (void)setEOLLength:(NSUInteger)argument;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Mon Apr  5 17:01:35 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    _EndOff7 = _StartOff7 + (_Length = _UncommentedLength + _CommentedLength + (_EOLLength = argument));
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  contentsLength
- (NSUInteger)contentsLength;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Mon Apr  5 17:01:35 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return _UncommentedLength + _CommentedLength;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  invalidLocalRange
- (NSRange)invalidLocalRange;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Thu May  6 10:27:34 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return iTM3MakeRange(_InvalidLocalRange.location,MIN(_InvalidLocalRange.length,(self.length>_InvalidLocalRange.location?self.length-_InvalidLocalRange.location:0)));
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  invalidLocalRangePointer
- (NSRangePointer)invalidLocalRangePointer;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Apr  7 17:37:29 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return &_InvalidLocalRange;
}
@synthesize invalidLocalRange = _InvalidLocalRange;
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  invalidGlobalRange
- (NSRange)invalidGlobalRange;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Apr  7 17:37:32 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return iTM3MakeRange(self.invalidLocalRange.location+self.startOff7, self.invalidLocalRange.length);// In GLOBAL coordinates
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  validateLocalRange:
- (void)validateLocalRange:(NSRange)argument;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Thu May  6 10:43:53 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    //  the invalidLocalRange will diminish from one end only
    //  If the argument is not connected to invalidLocalRange
    //  nothing is done.
    if (!argument.length) {
        return;
    }
    NSUInteger maxInvalidRange = iTM3MaxRange(self.invalidLocalRange);
    NSUInteger maxArgument = iTM3MaxRange(argument);
    
    if (maxArgument <= self.invalidLocalRange.location) {
        // argument is already valid
        return;
    } else if (argument.location >= maxInvalidRange) {
        // argument is already valid
        return;
    } else if (argument.location <= self.invalidLocalRange.location) {
        // argument starts at the left of the actual self.invalidLocalRange
        if (maxArgument >= maxInvalidRange) {
            // argument covers the whole invalid range
            self.invalidLocalRange = iTM3VoidRange;
            self.EOLMode = kiTM2TextRegularSyntaxMode;
        } else /* if (maxArgument < maxInvalidRange) */ {
            // validate the left part
            self.invalidLocalRange = iTM3MakeRange(maxArgument,maxInvalidRange-maxArgument);
        }
    } else {
        // argument starts in the interior of the actual self.invalidLocalRange
        // validation can occur only if argument ends after the right
        if (maxArgument >= maxInvalidRange) {
            // argument ends in the exterior of the actual self.invalidLocalRange
            self.invalidLocalRange = iTM3MakeRange(self.invalidLocalRange.location,argument.location-self.invalidLocalRange.location);
        }
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  validateGlobalRange:
- (void)validateGlobalRange:(NSRange)argument;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Tue Apr  6 23:19:29 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    argument = iTM3ProjectionRange(iTM3MakeRange(self.startOff7, self.length),argument);
    argument.location -= self.startOff7;
    [self validateLocalRange:argument];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  invalidateGlobalRange:
- (void)invalidateGlobalRange:(NSRange)argument;
/*"Description forthcoming. argument is global.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Tue Apr  6 23:19:24 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    argument = iTM3IntersectionRange(iTM3MakeRange(self.startOff7, self.length),argument);
    argument.location -= self.startOff7;
    [self invalidateLocalRange:argument];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  invalidateLocalRange:
- (void)invalidateLocalRange:(NSRange)argument;
/*"Description forthcoming. argument is global.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    argument = iTM3ProjectionRange(iTM3MakeRange(0, self.length),argument);
    if (!argument.length) {
        return;
    }
	if (argument.location>1) {
		argument.location-=2;
		argument.length+=2;
	} else if (argument.location>0) {
		argument.location-=1;
		argument.length+=1;
	}
    self.invalidLocalRange = self.invalidLocalRange.length? iTM3UnionRange(self.invalidLocalRange, argument): argument;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  previousMode
- (NSUInteger)previousMode;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return _PreviousMode | kiTM2TextEndOfLineSyntaxMask;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  setPreviousMode:
- (void)setPreviousMode:(NSUInteger)argument;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    _PreviousMode = argument | kiTM2TextEndOfLineSyntaxMask;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  EOLMode
- (NSUInteger)EOLMode;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return _EOLMode | kiTM2TextEndOfLineSyntaxMask;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  setEOLMode:
- (void)setEOLMode:(NSUInteger)argument;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return self.length > self.EOLLength;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  numberOfSyntaxWords
- (NSUInteger)numberOfSyntaxWords;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return _NumberOfSyntaxWords;
}
#ifdef __ELEPHANT_MODELINE__
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  originalString
- (NSString *)originalString;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return originalString;
}
#endif
#pragma mark =-=-=-=-=-=-=-=-=-=-  MODES/LENGTHS
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  syntaxLengthAtIndex
- (NSUInteger)syntaxLengthAtIndex:(NSUInteger)idx;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return (idx < _NumberOfSyntaxWords)? __SyntaxWordLengths[idx]:(idx? 0:self.contentsLength);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  syntaxModeAtIndex
- (NSUInteger)syntaxModeAtIndex:(NSUInteger)idx;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return (idx < _NumberOfSyntaxWords)? __SyntaxWordModes[idx]:self.EOLMode;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  moreStorage
- (BOOL)moreStorage;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    _MaxNumberOfSyntaxWords += _iTM2_MODE_BLOC_;
    size_t size = _MaxNumberOfSyntaxWords * sizeof(NSInteger);
	__SyntaxWordLengths = __SyntaxWordLengths? NSReallocateCollectable(__SyntaxWordLengths, size,NSScannedOption): NSAllocateCollectable(size,NSScannedOption);
    __SyntaxWordModes = __SyntaxWordModes? NSReallocateCollectable(__SyntaxWordModes, size,NSScannedOption): NSAllocateCollectable(size,NSScannedOption);
    size += sizeof(NSInteger);
    __SyntaxWordOff7s = __SyntaxWordOff7s? NSReallocateCollectable(__SyntaxWordOff7s, size,NSScannedOption): NSAllocateCollectable(size,NSScannedOption);
    if (!__SyntaxWordOff7s || !__SyntaxWordLengths || !__SyntaxWordModes) {
        if (iTM2DebugEnabled > 999999) {
            LOG4iTM3(@"ALLOCATION FAILURE NOTHING!!!");
        }
       _MaxNumberOfSyntaxWords = 0;
        _NumberOfSyntaxWords = 0;
		__SyntaxWordOff7s = nil;
        __SyntaxWordLengths = nil;
        __SyntaxWordModes = nil;
        __SyntaxWordEnds = nil;
        return NO;
    } else {
        __SyntaxWordEnds = __SyntaxWordOff7s+1;
    }
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  appendSyntaxModesAndLengths:
- (void)appendSyntaxModesAndLengths:(NSUInteger)firstMode,...;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Tue Apr  6 09:59:21 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
    va_list list;
    va_start(list,firstMode);
    NSUInteger length = 0;
    NSUInteger fireWall = 256;
    while((length = va_arg (list, NSUInteger)) && fireWall--) {
        if(![self appendSyntaxMode:firstMode length:length error:NULL]) return;
        firstMode = va_arg (list, NSUInteger);
    }
    va_end(list);
    
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  appendSyntaxModesFromModeLine:error:
- (BOOL)appendSyntaxModesFromModeLine:(iTM2ModeLine *)aModeLine error:(NSError **)errorRef;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Tue Apr  6 09:59:21 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
    if (aModeLine.length && self.EOLLength) {
        if (errorRef) {
            *errorRef = [NSError errorWithDomain:__iTM2_ERROR_DOMAIN__ code:__LINE__
                userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                    @"d:( append syntax modes from mode line failed, report error!!!!",
                    NSLocalizedDescriptionKey,
                        nil]];
        } else {
            LOG4iTM3(@"%%-%%-%%-%%-%%  d:( append syntax modes from mode line failed, report error!!!!!");
        }
        return NO;
    }
    NSUInteger i = 0;
    while (i < aModeLine.numberOfSyntaxWords) {
        if (![self appendSyntaxMode:[aModeLine syntaxModeAtIndex:i] length:[aModeLine syntaxLengthAtIndex:i] error:errorRef]) {
            return NO;
        }
        ++i;
    }
    self.EOLLength = aModeLine.EOLLength;
    self.EOLMode = aModeLine.EOLMode;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  appendSyntaxMode:length:error:
- (BOOL)appendSyntaxMode:(NSUInteger)mode length:(NSUInteger)length error:(NSError **)errorRef;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Tue Apr  6 09:59:21 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
    return mode & kiTM2TextCommentSyntaxMask?
        [self appendCommentedSyntaxMode:mode length:length error:errorRef]:
        [self appendNormalSyntaxMode:mode length:length error:errorRef];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  appendCommentedSyntaxMode:length:error:
- (BOOL)appendCommentedSyntaxMode:(NSUInteger)mode length:(NSUInteger)length error:(NSError **)errorRef;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Tue Apr  6 09:59:21 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//Start4iTM3;
//LOG4iTM3(@"length: %u", length);
//self.describe;
//NSLog(@"self.wordLengths:%@ (%u)", self.wordLengths, wordLengths.length);
//NSLog(@"self.modes:%@ (%u)", self.modes, modes.length);
    if (!length) {
        if (errorRef) {
            * errorRef = nil;
        }
        return NO;
    }
    if (self.diagnostic) {
        if (errorRef) {
            *errorRef = [NSError errorWithDomain:__iTM2_ERROR_DOMAIN__ code:__LINE__
                userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                    @"d:( Will not append a commented mode!!!!!",
                    NSLocalizedDescriptionKey,
                        nil]];
        } else {
            LOG4iTM3(@"%%-%%-%%-%%-%%  d:( Will not append a commented mode!!!!!");
        }
        return NO;
    }
    //  Manage the invalid range
    if (self.invalidLocalRange.location >= self.contentsLength) {
        self.invalidLocalRange = iTM3ShiftRange(self.invalidLocalRange,length);
    } else if (iTM3MaxRange(self.invalidLocalRange)>=self.contentsLength) {
        self.invalidLocalRange = iTM3ScaleRange(self.invalidLocalRange,length);
    }
    if (_NumberOfSyntaxWords == _MaxNumberOfSyntaxWords) {
        _MaxNumberOfSyntaxWords += _iTM2_MODE_BLOC_;
        size_t size = _MaxNumberOfSyntaxWords * sizeof(NSInteger);
		__SyntaxWordLengths = __SyntaxWordLengths? NSReallocateCollectable(__SyntaxWordLengths, size,NSScannedOption): NSAllocateCollectable(size,NSScannedOption);
        __SyntaxWordModes = __SyntaxWordModes? NSReallocateCollectable(__SyntaxWordModes, size,NSScannedOption): NSAllocateCollectable(size,NSScannedOption);
        size += sizeof(NSInteger);
        __SyntaxWordOff7s = __SyntaxWordOff7s? NSReallocateCollectable(__SyntaxWordOff7s, size,NSScannedOption): NSAllocateCollectable(size,NSScannedOption);
        if (!__SyntaxWordOff7s || !__SyntaxWordLengths || !__SyntaxWordModes) {
            _MaxNumberOfSyntaxWords = 0;
            _NumberOfSyntaxWords = 0;
            __SyntaxWordOff7s = nil;
            __SyntaxWordLengths = nil;
            __SyntaxWordModes = nil;
            __SyntaxWordEnds = nil;
        } else {
            __SyntaxWordEnds = __SyntaxWordOff7s+1;
        }
    }
	if (_NumberOfSyntaxWords && (__SyntaxWordModes[_NumberOfSyntaxWords-1] == mode)) {
		__SyntaxWordLengths[_NumberOfSyntaxWords-1] += length;
		__SyntaxWordOff7s[_NumberOfSyntaxWords] += length;
	} else if (__SyntaxWordLengths) {
		__SyntaxWordLengths[_NumberOfSyntaxWords] = length;
		__SyntaxWordModes[_NumberOfSyntaxWords] = mode;
		__SyntaxWordOff7s[_NumberOfSyntaxWords] = _NumberOfSyntaxWords? __SyntaxWordLengths[_NumberOfSyntaxWords-1]+__SyntaxWordOff7s[_NumberOfSyntaxWords-1]:0;
		// fixing the last offset
		__SyntaxWordEnds[_NumberOfSyntaxWords] = __SyntaxWordLengths[_NumberOfSyntaxWords]+__SyntaxWordOff7s[_NumberOfSyntaxWords];
		++_NumberOfSyntaxWords;
    }
    self.commentedLength += length;
    if (self.diagnostic) {
        if (errorRef) {
            *errorRef = [NSError errorWithDomain:__iTM2_ERROR_DOMAIN__ code:__LINE__
                userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                    @"d:( Could not append a commented mode!!!!!",
                    NSLocalizedDescriptionKey,
                        nil]];
        } else {
            LOG4iTM3(@"%%-%%-%%-%%-%%  d:( Could not append a commented mode!!!!!");
        }
        return NO;
    }
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  appendNormalSyntaxMode:length:error:
- (BOOL)appendNormalSyntaxMode:(NSUInteger)mode length:(NSUInteger)length error:(NSError **)errorRef;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Tue Apr  6 09:59:16 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//Start4iTM3;
//LOG4iTM3(@"length: %u", length);
//self.describe;
//NSLog(@"self.wordLengths:%@ (%u)", self.wordLengths, wordLengths.length);
//NSLog(@"self.modes:%@ (%u)", self.modes, modes.length);
    if (!length) {
        if (errorRef) {
            * errorRef = nil;
        }
        return NO;
    }
    if (self.commentedLength) {
        return [self appendCommentedSyntaxMode:mode length:length error:errorRef];
    }
    if (self.diagnostic) {
        if (errorRef) {
            *errorRef = [NSError errorWithDomain:__iTM2_ERROR_DOMAIN__ code:__LINE__
                userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                    @"d:( Will not append a normal mode!!!!!",
                    NSLocalizedDescriptionKey,
                        nil]];
        } else {
            LOG4iTM3(@"%%-%%-%%-%%-%%  d:( Will not append a normal mode!!!!!");
        }
        return NO;
    }
    //  Manage the invalid range
    if (self.invalidLocalRange.location >= self.contentsLength) {
        self.invalidLocalRange = iTM3ShiftRange(self.invalidLocalRange,length);
    } else if (iTM3MaxRange(self.invalidLocalRange)>=self.contentsLength) {
        self.invalidLocalRange = iTM3ScaleRange(self.invalidLocalRange,length);
    }
    if (_NumberOfSyntaxWords == _MaxNumberOfSyntaxWords) {
        _MaxNumberOfSyntaxWords += _iTM2_MODE_BLOC_;
        size_t size = _MaxNumberOfSyntaxWords * sizeof(NSInteger);
		__SyntaxWordLengths = __SyntaxWordLengths? NSReallocateCollectable(__SyntaxWordLengths, size,NSScannedOption): NSAllocateCollectable(size,NSScannedOption);
        __SyntaxWordModes = __SyntaxWordModes? NSReallocateCollectable(__SyntaxWordModes, size,NSScannedOption): NSAllocateCollectable(size,NSScannedOption);
        size += sizeof(NSInteger);
        __SyntaxWordOff7s = __SyntaxWordOff7s? NSReallocateCollectable(__SyntaxWordOff7s, size,NSScannedOption): NSAllocateCollectable(size,NSScannedOption);
        if (!__SyntaxWordOff7s || !__SyntaxWordLengths || !__SyntaxWordModes) {
            LOG4iTM3(@"NOTHING!!!");
            _MaxNumberOfSyntaxWords = 0;
            _NumberOfSyntaxWords = 0;
            __SyntaxWordOff7s = nil;
            __SyntaxWordLengths = nil;
            __SyntaxWordModes = nil;
            __SyntaxWordEnds = nil;
        } else {
            __SyntaxWordEnds = __SyntaxWordOff7s+1;
        }
    }
	if (_NumberOfSyntaxWords && (__SyntaxWordModes[_NumberOfSyntaxWords-1] == mode)) {
		__SyntaxWordLengths[_NumberOfSyntaxWords-1] += length;
		__SyntaxWordOff7s[_NumberOfSyntaxWords] += length;
	} else if (__SyntaxWordLengths) {
		__SyntaxWordLengths[_NumberOfSyntaxWords] = length;
		__SyntaxWordModes[_NumberOfSyntaxWords] = mode;
		__SyntaxWordOff7s[_NumberOfSyntaxWords] = _NumberOfSyntaxWords? __SyntaxWordLengths[_NumberOfSyntaxWords-1]+__SyntaxWordOff7s[_NumberOfSyntaxWords-1]:0;
		// fixing the last offset
		__SyntaxWordEnds[_NumberOfSyntaxWords] = __SyntaxWordLengths[_NumberOfSyntaxWords]+__SyntaxWordOff7s[_NumberOfSyntaxWords];
		++_NumberOfSyntaxWords;
    }
    self.uncommentedLength += length;
    if (self.diagnostic) {
        if (errorRef) {
            *errorRef = [NSError errorWithDomain:__iTM2_ERROR_DOMAIN__ code:__LINE__
                userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                    @"d:( Could not append a normal mode!!!!!",
                    NSLocalizedDescriptionKey,
                        nil]];
        } else {
            LOG4iTM3(@"%%-%%-%%-%%-%%  d:( Could not append a normal mode!!!!!");
        }
        return NO;
    }
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  removeLastMode
- (BOOL)removeLastMode;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//Start4iTM3;
	if (_NumberOfSyntaxWords) {
        if (self.diagnostic) {
            LOG4iTM3(@"****  INTERNAL INCONSISTENCY: Deleting last mode on a bad mode line");
        }
		NSAssert(__SyntaxWordLengths, @"****  INTERNAL INCONSISTENCY: unexpected lack of storage for modes");
		NSUInteger lastLength = __SyntaxWordLengths[--_NumberOfSyntaxWords];
        if (self.commentedLength >= lastLength) {
            self.commentedLength -= lastLength;
        } else {
            NSAssert(!self.commentedLength, @"****  INTERNAL INCONSISTENCY: the comment does not span over a full syntax word.");
            // 0 == self.commentedLength
            NSAssert(self.uncommentedLength >= lastLength, @"****  INTERNAL INCONSISTENCY: the uncommented header does not span over a full syntax word.");
            self.uncommentedLength -= lastLength;
        }
        if (self.diagnostic) {
            LOG4iTM3(@"****  INTERNAL INCONSISTENCY: Deleting last mode results in a bad mode line");
        }
		return YES;
    }
//END4iTM3;
//self.describe;
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  enlargeSyntaxModeAtGlobalLocation:length:error:
- (BOOL)enlargeSyntaxModeAtGlobalLocation:(NSUInteger)aGlobalLocation length:(NSUInteger)lengthOff7 error:(NSError **)errorRef;
/*Adds length to the length at global location aGlobalLocation.
It is relative to the beginning of the line. Other locations mean new line char insertions.
The attribute value at aGlobalLocation won't change once the message is sent!!! It simply finds the "word" containing
MAX(1, aGlobalLocation)-1, then adds the correct value to its length. The previous attribute is continued except for the first one (at location 0).
Although this is a data model method, the wordLengths are updated.
No range is invalidated.
This choice is motivated by the observation that in general, you append something to the previous syntax mode.
Version History: jlaurens AT users DOT sourceforge DOT net (11/07/01)
Latest Revision: Fri Apr  9 12:10:11 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//LOG4iTM3(@"aGlobalLocation: %u, lengthOff7: %u", aGlobalLocation, lengthOff7);
//self.describe;
    if (!lengthOff7) {
        if (errorRef) {
            *errorRef = nil;
        }
        return NO;
    } else if (aGlobalLocation<self.startOff7) {
        self.startOff7 += lengthOff7;
        return YES;
    } else if (aGlobalLocation < self.contentsEndOff7) {
        if (self.diagnostic) {
            if (errorRef) {
                *errorRef = [NSError errorWithDomain:__iTM2_ERROR_DOMAIN__ code:__LINE__
                    userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                        @"d:( Evidemment avec un mode line m**dique, APPEND c'est la foire!!!!!",
                        NSLocalizedDescriptionKey,
                            nil]];
            } else {
                LOG4iTM3(@"%%-%%-%%-%%-%%  d:( Evidemment avec un mode line m**dique, APPEND c'est la foire!!!!!");
            }
            return NO;
        }
        NSUInteger localLocation = aGlobalLocation-self.startOff7;
        //  Manage the invalid range
        if (localLocation < self.invalidLocalRange.location) {
            self.invalidLocalRange = iTM3ShiftRange(self.invalidLocalRange,lengthOff7);
        } else if (localLocation < iTM3MaxRange(self.invalidLocalRange)) {
            self.invalidLocalRange = iTM3ScaleRange(self.invalidLocalRange,lengthOff7);
        }
        NSUInteger idx = 0;
        if (localLocation) {
            //  we look for an idx such that
            //  __SyntaxWordsOff7s[idx] <= localLocation < __SyntaxWordEnds[idx]
            --localLocation;
            NSUInteger left = 0;
            NSUInteger right = _NumberOfSyntaxWords;
            NSUInteger delta;
            // we have
            // __SyntaxWordOff7s[left] <= localLocation < __SyntaxWordOff7s[_NumberOfSyntaxWords] = self.contentsLength
            while(delta = (right-left)/2) {
                idx = left+delta;
                if (__SyntaxWordOff7s[idx] > localLocation) {
                    right = idx;
                } else {
                    left = idx;
                }
            }
            // the stopping condition <=> right == left+1
            // at each iteration left < right
            // as self.startOff7 <= aGlobalLocation < self.contentsEndOff7
            // we have 0 < _NumberOfSyntaxWords and at starting time left < right _NumberOfSyntaxWords = 1
            // The loop is not run when right = left+1, which means that there is only one word
            // HERE WE HAVE:
            // self.startOff7+__SyntaxWordOff7s[left] <= aGlobalLocation < self.startOff7+__SyntaxWordOff7s[right]
            // what about the comment management?
            // we consider that modifications in syntax words represent appending
            // It would not cause any problem if we assume that the comments self.uncommentedLength is the character index of a syntax word bound
            //  This must be done before the enlargement applies
            if (self.uncommentedLength >= __SyntaxWordOff7s[right]) {
                self.uncommentedLength += lengthOff7;
            } else {
                self.commentedLength += lengthOff7;
            }
            idx = left;
        } else {
            if (self.uncommentedLength) {
                self.uncommentedLength += lengthOff7;
            } else if (self.uncommentedLength) {
                self.commentedLength += lengthOff7;
            } else {
                self.uncommentedLength += lengthOff7;
            }
        }
        __SyntaxWordLengths[idx] += lengthOff7;
        // then propagate the change
//LOG4iTM3(@"AFTER -------  %u(idx = %u)", __SyntaxWordLengths[idx], idx);
        do {
            __SyntaxWordEnds[idx] += lengthOff7;
        } while(++idx<_NumberOfSyntaxWords);
        if (self.diagnostic) {
            if (errorRef) {
                *errorRef = [NSError errorWithDomain:__iTM2_ERROR_DOMAIN__ code:__LINE__
                    userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                        @"d:( BAD THINGS HAPPENING: pas enlarge mode!!!",
                        NSLocalizedDescriptionKey,
                            nil]];
            } else {
                LOG4iTM3(@"%%-%%-%%-%%-%%  d:( BAD THINGS HAPPENING: pas enlarge mode!!!");
            }
            return NO;
        }
        return YES;
    } else if (aGlobalLocation == self.contentsEndOff7) {
        if (self.diagnostic) {
            if (errorRef) {
                *errorRef = [NSError errorWithDomain:__iTM2_ERROR_DOMAIN__ code:__LINE__
                    userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                        @"d:( Evidemment avec un mode line m**dique, APPEND c'est la foire!!!!!",
                        NSLocalizedDescriptionKey,
                            nil]];
            } else {
                LOG4iTM3(@"%%-%%-%%-%%-%%  d:( Evidemment avec un mode line m**dique, APPEND c'est la foire!!!!!");
            }
            return NO;
        }
        if (_NumberOfSyntaxWords) {
            NSUInteger idx = _NumberOfSyntaxWords-1;
            __SyntaxWordLengths[idx] += lengthOff7;
            __SyntaxWordEnds[idx] += lengthOff7;
            //  Manage the invalid range in the ancient coordinates
            if (self.invalidLocalRange.location >= self.contentsLength) {
                self.invalidLocalRange = iTM3ShiftRange(self.invalidLocalRange,lengthOff7);
            } else if (iTM3MaxRange(self.invalidLocalRange)>=self.contentsLength) {
                self.invalidLocalRange = iTM3ScaleRange(self.invalidLocalRange,lengthOff7);
            }
			if (self.commentedLength) {
				self.commentedLength += lengthOff7;
            } else {
				self.uncommentedLength += lengthOff7;
            }
            return YES;
        } else {
            return [self appendNormalSyntaxMode:kiTM2TextUnknownSyntaxMode length:lengthOff7 error:errorRef];
        }
    } else {
        if (errorRef) {
            *errorRef = [NSError errorWithDomain:__iTM2_ERROR_DOMAIN__ code:__LINE__
                userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                    @"d:) REFUSED TO ENLARGE AN EOL!!!!",
                    NSLocalizedDescriptionKey,
                        nil]];
        } else {
            LOG4iTM3(@"%%-%%-%%-%%-%%  d:) REFUSED TO ENLARGE AN EOL!!!!!");
        }
        return NO;
    }
//END4iTM3;
//self.describe;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  longestRangeAtGlobalLocation:mask:
- (NSRange)longestRangeAtGlobalLocation:(NSUInteger)aGlobalLocation mask:(NSUInteger)mask;
/*"Description forthcoming. aGlobalLocation is global.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Thu Apr  1 20:30:29 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSUInteger mode;
	NSRange range;
	NSRange result = iTM3MakeRange(NSNotFound,0);
	if ([self getSyntaxMode:&mode atGlobalLocation:aGlobalLocation longestRange:&range]) {
		return result;
	}
	if ((mode&mask)==0) {
		return result;
	}
    result = range;
	while(result.location>self.startOff7) {
		[self getSyntaxMode:&mode atGlobalLocation:result.location-1 longestRange:&range];
		if ((mode&mask)) {
			result.length+=range.length;
			result.location=range.location;
		} else {
			break;
		}
	}
	NSUInteger top = iTM3MaxRange(result);
	while(top<self.endOff7) {
		[self getSyntaxMode:&mode atGlobalLocation:top longestRange:&range];
		if ((mode&mask)) {
			result.length+=range.length;
			top = iTM3MaxRange(result);
		} else {
			break;
		}
	}
//END4iTM3;
	return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  getSyntaxMode:atGlobalLocation:longestRange:
- (NSUInteger)getSyntaxMode:(NSUInteger *)modeRef atGlobalLocation:(NSUInteger)aGlobalLocation longestRange:(NSRangePointer)aRangePtr;
/*"Description forthcoming. aGlobalLocation is global.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (aGlobalLocation<self.startOff7) {
        if (aRangePtr) {
            * aRangePtr = iTM3MakeRange(aGlobalLocation, self.startOff7-aGlobalLocation);
		}
		LOG4iTM3(@"**** UNEXPECTED LOCATION OUT OF BOUNDS: unsatisfied %u <= aGlobalLocation(%u)", self.startOff7, aGlobalLocation);
		if (modeRef) {
			*modeRef = self.previousMode;
		}
		return kiTM2TextOutOfRangeSyntaxStatus;
    } else if (aGlobalLocation < self.contentsEndOff7) {
        // self.startOff7 <= aGlobalLocation < self.endOff7
        if (_NumberOfSyntaxWords) {
			NSUInteger localLocation = aGlobalLocation-self.startOff7;
            NSUInteger left = 0;
            NSUInteger right = _NumberOfSyntaxWords;
            NSUInteger idx = 0;
            NSUInteger delta;
            // we start with: 
            // > left < right (if not insconsistent)
            // > __SyntaxWordOff7s[left = 0] <= localLocation < __SyntaxWordOff7s[right = _NumberOfSyntaxWords] = self.contentsEndOff7
			if (delta = (right-left)/2) {
                while (YES) {
                    idx = left+delta;
                    // left <= idx < right
                    // left < idx < left+2 * delta ≤ right
                    if (__SyntaxWordOff7s[idx]>localLocation) {
                        right = idx;
                        // here we have
                        // left < right = idx
                        // __SyntaxWordOff7s[left] <= localLocation < __SyntaxWordOff7s[right = idx]
                        if (delta = (right-left)/2) {
                            while (YES) {
                                idx = left+delta;
                                // left <= idx < right
                                // left < idx < left+2 * delta ≤ right
                                if (__SyntaxWordOff7s[idx]>localLocation) {
                                    right = idx;
                                    // here we have
                                    // left < right = idx
                                    // __SyntaxWordOff7s[left] <= localLocation < __SyntaxWordOff7s[right = idx]
                                } else {
                                    left = idx;
                                    // here we have
                                    // left = idx < right
                                    // __SyntaxWordOff7s[left = idx] <= localLocation < __SyntaxWordOff7s[right]
                                }
                                if (delta = (right-left)/2) {
                                    continue;
                                }
                                break;
                            }
                            // No EOL
                        }
                        if (aRangePtr) {
                             * aRangePtr = iTM3MakeRange(self.startOff7+__SyntaxWordOff7s[left], __SyntaxWordLengths[left]);
                        }
                        if (modeRef) {
                            *modeRef = __SyntaxWordModes[left];
                        }
                        return kiTM2TextNoErrorSyntaxStatus;
                    } else {
                        left = idx;
                        // here we have
                        // left = idx < right
                        // __SyntaxWordOff7s[left = idx] <= localLocation < __SyntaxWordOff7s[right]
                        if (delta = (right-left)/2) {
                            continue;
                        }
                        // stop with
                        // left == idx == right-1;
                        // because right has never been changed
                        // __SyntaxWordOff7s[idx] <= localLocation < __SyntaxWordOff7s[idx+1]
                    }
                    break;
                }
            }
			NSUInteger result = __SyntaxWordModes[left];
			if (aRangePtr) {
				* aRangePtr = iTM3MakeRange(self.startOff7+__SyntaxWordOff7s[left], __SyntaxWordLengths[left]);
			}
			if (modeRef) {
				*modeRef = result;
			}
			return kiTM2TextNoErrorSyntaxStatus;
        } else {
            if (aRangePtr) {
                * aRangePtr = iTM3MakeRange(self.startOff7, self.length);
            }
			if (modeRef) {
				*modeRef = self.previousMode;
			}
			return kiTM2TextNoErrorSyntaxStatus;
        }
    } else if (aGlobalLocation < self.endOff7) {
        if (aRangePtr) {
            * aRangePtr = iTM3MakeRange(self.contentsEndOff7, self.EOLLength);
		}
		if (modeRef) {
			*modeRef = self.EOLMode;
		}
		return kiTM2TextNoErrorSyntaxStatus;
    } else {
        if (aRangePtr) {
            * aRangePtr = iTM3MakeRange(aGlobalLocation, 0);
		}
		if (aGlobalLocation > self.endOff7) {
			LOG4iTM3(@"**** UNEXPECTED LOCATION OUT OF BOUNDS: unsatisfied aGlobalLocation (%u) <= endOff7 (%u)", aGlobalLocation, self.endOff7);
		}
		if (modeRef) {
			*modeRef = self.EOLMode;
		}
		return kiTM2TextRangeExceededSyntaxStatus;
    }
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  deleteModesInGlobalMakeRange::error:
- (BOOL)deleteModesInGlobalMakeRange:(NSUInteger)location:(NSUInteger)length error:(NSError **)errorRef;
/*"Description forthcoming. deleteRange is in global coordinates.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Tue Apr  6 10:21:55 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
    return [self deleteModesInGlobalRange:iTM3MakeRange(location, length) error:errorRef];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  deleteModesInGlobalRange:error:
- (BOOL)deleteModesInGlobalRange:(NSRange)deleteRange error:(NSError **)errorRef;
/*"Description forthcoming. deleteRange is in global coordinates.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Thu May  6 13:48:23 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (errorRef) {
        *errorRef = nil;
    }
    //  preparation for simple cases
    if (!deleteRange.length) {
        //  nothing to remove
        return NO;
    }
    // We do not touch deleteRange
    NSUInteger leftLocation = deleteRange.location;
    NSUInteger idx = self.endOff7;
    if (idx <= leftLocation) {
        // everything is removed from the right part
        return NO;
    }
    NSUInteger xdi = self.contentsEndOff7;
    NSUInteger rightLocation = iTM3MaxRange(deleteRange);
    if (xdi <= leftLocation) {
        // everything is removed from the EOL part
        if (idx <= rightLocation) {
            if (!(self.EOLLength = leftLocation - xdi)) {
                self.EOLMode = kiTM2TextUnknownSyntaxMode;
            }
        } else {
            if (!(self.EOLLength -= rightLocation - leftLocation)) {
                self.EOLMode = kiTM2TextUnknownSyntaxMode;
            }
        }
        //  manage the invalid range
        if (self.invalidLocalRange.location >= self.length) {
            self.invalidLocalRange = iTM3VoidRange;
        }
        return YES;
    }
    //  leftLocation < self.contentsEndOff7 alias xdi
	//  rightLocation is the index of the first character kept after the deleted range
    //  leftLocation < rightLocation
    if (rightLocation <= self.startOff7 ) {
        //  only the offset is affected
		self.startOff7 -= deleteRange.length;
        return NO;
    } else if (idx <= rightLocation) {
        self.EOLLength = 0;
        self.EOLMode = kiTM2TextUnknownSyntaxMode;
        rightLocation = xdi;
    } else if(xdi <= rightLocation) {
        self.EOLLength = idx - rightLocation;
        rightLocation = xdi;
    } 
    //  self.startOff7 < rightLocation
    //  and convert rightLocation to local coordinates
    //  Cut off leftLocation to fit into the receiver's range
    //  and convert leftLocation to local coordinates
    if (leftLocation <= self.startOff7) {
        self.startOff7 = leftLocation; // remove what is at the left
        leftLocation = 0;
        if (rightLocation == xdi) {
            //  Everything is removed
            _NumberOfSyntaxWords = 0;
            self.uncommentedLength = self.commentedLength = 0;
            self.invalidLocalRange = iTM3VoidRange;
            return YES;
        }
    } else {
        leftLocation -= self.startOff7;
    }
    if (leftLocation == rightLocation) {
        //  nothing to remove
        return YES;
    }
    rightLocation -= self.startOff7;
    //  From now on, we compare leftLocation and rightLocation to the various lengths of the receiver.
    //  Now change the various lengths of the receiver
    idx = leftLocation;
    xdi = rightLocation;
    //  Manage the invalid range
    if (xdi < self.invalidLocalRange.location) {
        self.invalidLocalRange = iTM3ShiftRange(self.invalidLocalRange,idx-xdi);
    } else if (xdi < iTM3MaxRange(self.invalidLocalRange)) {
        if (idx < self.invalidLocalRange.location) {
            self.invalidLocalRangePointer->length = iTM3MaxRange(self.invalidLocalRange) - (self.invalidLocalRangePointer->location = xdi);
        } else {
            self.invalidLocalRange = iTM3ScaleRange(self.invalidLocalRange,idx-xdi);
        }
    } else /* if (xdi >= iTM3MaxRange(self.invalidLocalRange) */ {
        if (idx <= self.invalidLocalRange.location) {
            self.invalidLocalRangePointer->length = 0;
        } else {
            self.invalidLocalRangePointer->length = idx - self.invalidLocalRange.location;
        }
    }
    if (xdi <= self.uncommentedLength) {
        self.uncommentedLength -= xdi - idx;
    } else {
        //  self.uncommentedLength < xdi
        xdi -= self.uncommentedLength;
        if (idx < self.uncommentedLength) {
            self.uncommentedLength = idx;
        }
        idx -= self.uncommentedLength;
        //  0 <= idx <= xdi
        if (xdi <= self.commentedLength) {
            self.commentedLength -= xdi - idx;
        } else {
            //  self.commentedLength < xdi
            xdi -= self.commentedLength;
            if (idx < self.commentedLength) {
                self.commentedLength = idx;
            }
            idx -= self.commentedLength;
            //  0 <= idx <= xdi
            if (!(self.EOLLength -= xdi - idx)) {
                self.EOLMode = kiTM2TextUnknownSyntaxMode;
            }
        }
    }
    //  We remove the last uncomplete syntax word
    //  Then we remove the complete syntax word
    //  Finally we remove the first uncomplete syntax words
    //  So, let us remove the last uncomplete syntax word
    //  find the biggest idx <= _NumberOfSyntaxWords such that
    //      __SyntaxWordOff7s[idx] <= rightLocation < __SyntaxWordOff7s[idx+1] ( if relevant)
    //  What will be removed is
    //      rightLocation - __SyntaxWordOff7s[idx]
    //  What will remain is
    //      __SyntaxWordOff7s[idx+1] - rightLocation, if it makes sense
    //  We already know that
    //  rightLocation <= __SyntaxWordOff7s[_NumberOfSyntaxWords] == self.contentsLength
    //  such that the expected idx is at most _NumberOfSyntaxWords
    idx = _NumberOfSyntaxWords;
    if (__SyntaxWordOff7s[idx] > rightLocation) {
        // the last syntax word is partly removed
        do {
            --idx;
        } while (__SyntaxWordOff7s[idx] > rightLocation);
        //  idx < _NumberOfSyntaxWords
        //  The loop stops because rightLocation > 0 == __SyntaxWordOff7s[0]
        //  We have now
        //      __SyntaxWordOff7s[idx] <= rightLocation < __SyntaxWordEnds[idx]
        //  idx is the index of the syntax word that is partly removed
        if (__SyntaxWordOff7s[idx] <= leftLocation) {
            //  We only remove some part of a syntax word
            //  _NumberOfSyntaxWords does not change
            __SyntaxWordLengths[idx] -= rightLocation - leftLocation; // > 0
            do {
                __SyntaxWordEnds[idx] = __SyntaxWordOff7s[idx] + __SyntaxWordLengths[idx];
            } while (++idx<_NumberOfSyntaxWords);
            return YES;
        }
        //  leftLocation < __SyntaxWordOff7s[idx] <= rightLocation < __SyntaxWordEnds[idx]
        __SyntaxWordLengths[idx] = __SyntaxWordEnds[idx] - rightLocation; // > 0
        rightLocation = __SyntaxWordOff7s[idx];
        //  leftLocation < __SyntaxWordOff7s[idx] == rightLocation
        xdi = idx;//    <= _NumberOfSyntaxWords
        //  xdi is the biggest index for which the syntax word length has been modified
        while (YES) {
            //  We have __SyntaxWordOff7s[idx] == rightLocation > leftLocation >= 0, so idx > 0
            --idx; // idx < xdi
            if (leftLocation <= __SyntaxWordOff7s[idx]) {
                //  A complete syntax word must be removed
                rightLocation = __SyntaxWordOff7s[idx];
                __SyntaxWordLengths[idx] = 0;
                if (leftLocation < rightLocation) {
                    continue;
                }
                //  leftLocation == rightLocation
                //  It is possible that we have removed full syntax words between two syntax words with the same mode
                //  We must reconnect the two following syntax words with the same mode
                //  The idea is to tranfer the length of the left word to the rightmost one
                if (idx && (__SyntaxWordModes[idx-1] == __SyntaxWordModes[xdi])) {
                    --idx;
                    __SyntaxWordLengths[xdi] += __SyntaxWordLengths[idx];
                    __SyntaxWordLengths[idx] = 0;
                }
            } else {
                // leftLocation > __SyntaxWordOff7s[idx]
                //  This is a partially deleted syntax word
                if (__SyntaxWordModes[idx] == __SyntaxWordModes[xdi]) {
                    __SyntaxWordLengths[xdi] += leftLocation - __SyntaxWordOff7s[idx];
                    __SyntaxWordLengths[idx] = 0;
                } else {
                    __SyntaxWordLengths[idx] = leftLocation - __SyntaxWordOff7s[idx];
                    //  Fix consistency for this syntax word
                    __SyntaxWordEnds[idx] = __SyntaxWordOff7s[idx] + __SyntaxWordLengths[idx];
                    ++idx; // idx <= xdi
                }
            }
            break;
        }
        //  Now all the lengths have been set

        //  Fix the consistency of the other syntax words
        while (xdi < _NumberOfSyntaxWords) {
            __SyntaxWordEnds[idx] = __SyntaxWordOff7s[idx] + (__SyntaxWordLengths[idx] = __SyntaxWordLengths[xdi]);
            __SyntaxWordModes[idx] = __SyntaxWordModes[xdi];
            ++idx;
            ++xdi;
        }
        _NumberOfSyntaxWords = idx;
        return YES;
    }
    //  __SyntaxWordOff7s[_NumberOfSyntaxWords] <= rightLocation
    //  Which means
    //  __SyntaxWordOff7s[_NumberOfSyntaxWords] == rightLocation
    //  As rightLocation > 0, __SyntaxWordOff7s[_NumberOfSyntaxWords] > 0 and idx == _NumberOfSyntaxWords > 0
    while (idx && leftLocation <= __SyntaxWordOff7s[--idx]) {
        //  This syntax word is totally removed
        continue;
    }
    //  The loop ends because leftLocation > 0 == __SyntaxWordOff7s[0]
    //  We already have eliminated the case where
    //  leftLocation == 0 and __SyntaxWordOff7s[_NumberOfSyntaxWords] == rightLocation
    __SyntaxWordLengths[idx] = (__SyntaxWordEnds[idx] = leftLocation) - __SyntaxWordOff7s[idx]; // > 0
    _NumberOfSyntaxWords = idx +1;
    if (self.diagnostic) {
        if (errorRef) {
            *errorRef = [NSError errorWithDomain:__iTM2_ERROR_DOMAIN__ code:__LINE__
                userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                    @"d:( delete modes failed, report error!!!!",
                    NSLocalizedDescriptionKey,
                        nil]];
        } else {
            LOG4iTM3(@"%%-%%-%%-%%-%%  d:( delete modes failed, report error!!!!!");
        }
        return NO;
    }
//	self.description;
    return YES;
}
- (NSRange)completeRange;
{
    return iTM3MakeRange(self.startOff7,self.uncommentedLength+self.commentedLength+self.EOLLength);
}
- (NSRange)contentsRange;
{
    return iTM3MakeRange(self.startOff7,self.uncommentedLength+self.commentedLength);
}
- (NSRange)EOLRange;
{
    return iTM3MakeRange(self.contentsEndOff7,self.EOLLength);
}
@synthesize startOff7=_StartOff7;
@synthesize commentOff7=_CommentOff7;
@synthesize contentsEndOff7=_ContentsEndOff7;
@synthesize endOff7=_EndOff7;
@synthesize uncommentedLength=_UncommentedLength;
@synthesize commentedLength=_CommentedLength;
@synthesize length=_Length;
@synthesize EOLLength=_EOLLength;
@synthesize previousMode=_PreviousMode;
@synthesize EOLMode=_EOLMode;
@synthesize numberOfSyntaxWords=_NumberOfSyntaxWords;
@synthesize maxNumberOfSyntaxWords=_MaxNumberOfSyntaxWords;
@synthesize syntaxWordOff7s=__SyntaxWordOff7s;
@synthesize syntaxWordLengths=__SyntaxWordLengths;
@synthesize syntaxWordEnds=__SyntaxWordEnds;
@synthesize syntaxWordModes=__SyntaxWordModes;
@synthesize status=_Status;
@synthesize depth=_Depth;
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

#import "iTM2FileManagerKit.h"

@implementation iTM2TextSyntaxParser(Attributes)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  defaultModesAttributes
+ (NSDictionary *)defaultModesAttributes;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
    style = style.length? [style lowercaseString]:[iTM2TextDefaultStyle lowercaseString];
    variant = variant.length? [variant lowercaseString]:[iTM2TextDefaultVariant lowercaseString];
    if (![[_iTM2TextObjectServer keyEnumeratorForType:style] nextObject])
    {
//LOG4iTM3(@"INITIALIZING ATTRIBUTES SERVERS FOR STYLE: %@", style);
        Class C = [[self syntaxParserClassForStyle:style] attributesServerClass];
//LOG4iTM3(@"C: %@", C);
        NSEnumerator * E = [[self syntaxParserVariantsForStyle:style] objectEnumerator];
        NSString * variant1;
        while(variant1 = E.nextObject)
		{
//LOG4iTM3(@"variant1: %@", variant1);
            [_iTM2TextObjectServer registerObject:[[[C alloc] initWithVariant:variant1] autorelease]
                forType: style key: [variant1 lowercaseString] retain:YES];
		}
    }
    id result = [_iTM2TextObjectServer objectForType:style key:variant];
    if (![result isKindOfClass:[iTM2TextSyntaxParserAttributesServer class]])
        result = [_iTM2TextObjectServer objectForType:style key:iTM2TextDefaultVariant];
    if (!result)
    {
        NSString * newStyle = style.stringByDeletingPathExtension;
        if (newStyle.length < style.length)
            return [_iTM2TextObjectServer objectForType:newStyle key:variant];
        else if (![style isEqualToString:iTM2TextDefaultStyle])
            return [_iTM2TextObjectServer objectForType:iTM2TextDefaultStyle key:variant];
        LOG4iTM3(@"AN INCONSISTENCY WAS FOUND: missing variant %@ for style %@", variant, style);
    }
//END4iTM3;
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= createAttributesServerWithStyle:variant:
+ (void)createAttributesServerWithStyle:(NSString  *)style variant:(NSString *)variant;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Sat Jan 30 15:59:28 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    style = [[self syntaxParserClassForStyle:style] syntaxParserStyle];// trick to retrieve the case sensitive style
	NSString * directory = [[iTM2TextStyleComponent stringByAppendingPathComponent:style]
								stringByAppendingPathExtension: iTM2TextStyleExtension];
	NSURL * supportURL = [[NSBundle mainBundle] URLForSupportDirectory4iTM3:directory inDomain:NSUserDomainMask create:YES];
    NSURL * styleURL = [supportURL URLByAppendingPathComponent:variant];
    styleURL = [styleURL URLByAppendingPathExtension:iTM2TextVariantExtension];
	NSError * localError = nil;
    if ([DFM createDirectoryAtPath:styleURL.path withIntermediateDirectories:YES attributes:nil error:&localError]) {
        Class C = [[self syntaxParserClassForStyle:style] attributesServerClass];
        id O = [[[C alloc] initWithVariant:variant] autorelease];
        [_iTM2TextObjectServer registerObject:O forType:[style lowercaseString] key:[variant lowercaseString] retain:YES];
        [INC postNotificationName:iTM2TextAttributesDidChangeNotification object:nil userInfo:
            [NSDictionary dictionaryWithObjectsAndKeys:style, @"style", variant, @"variant", nil]];
    } else if (localError) {
        LOG4iTM3(@"Could not create variant: %@ due to %@", variant, [localError localizedFailureReason]);
    } else {
        LOG4iTM3(@"Could not create variant: %@", variant);
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
//LOG4iTM3(@"style: %@, variant: %@", style, variant);
    [_iTM2TextObjectServer unregisterObjectForType:[style lowercaseString] key:[variant lowercaseString]];
    style = [[self syntaxParserClassForStyle:style] syntaxParserStyle];// trick to retrieve the case sensitive style
    NSURL * styleURL = [[[NSBundle mainBundle] URLsForSupportResource4iTM3:variant withExtension:iTM2TextVariantExtension
	subdirectory: [[iTM2TextStyleComponent stringByAppendingPathComponent:style] stringByAppendingPathExtension:iTM2TextStyleExtension]
		domains: NSUserDomainMask] lastObject];
    if (![DFM removeItemAtPath:styleURL.path error:NULL]) {
        LOG4iTM3(@"Could not remove file at url: %@\nPlease, do it for me.. TIA", styleURL);
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
    style = [style lowercaseString];
    NSMutableDictionary * MD = [NSMutableDictionary dictionary];
    NSString * variant = nil;
    for (id TAS in [_iTM2TextObjectServer objectEnumeratorForType:style]) {
		//  TAS for Text Attributes Server
        variant = [TAS syntaxParserVariant];
        [MD setObject:variant forKey:[variant lowercaseString]];
	}
    if (!MD.count) {
        [MD setObject:iTM2TextDefaultVariant forKey:[iTM2TextDefaultVariant lowercaseString]];
        NSString * styleComponent = [style stringByAppendingPathExtension:iTM2TextStyleExtension];
		id C = [self syntaxParserClassForStyle:style];
        NSURL * styleURL = [[[C classBundle4iTM3] URLForResource:iTM2TextStyleComponent withExtension:nil]
                                URLByAppendingPathComponent:styleComponent];
        NSURL *variantURL = nil;
        BOOL isDirectory = NO;
        for(variantURL in [DFM contentsOfDirectoryAtURL:styleURL includingPropertiesForKeys:[NSArray array] options:NSDirectoryEnumerationSkipsHiddenFiles error:NULL]) {
            if ([variantURL.pathExtension isEqual:iTM2TextVariantExtension]) {
                if (variantURL.isFileURL && [DFM fileExistsAtPath:variantURL.path isDirectory:&isDirectory] && isDirectory) {
					variant = variantURL.lastPathComponent.stringByDeletingPathExtension;
                    [MD setObject:variant forKey:[variant lowercaseString]];
				}
            }
        }
		for (styleURL in [[NSBundle mainBundle] URLsForSupportResource4iTM3:style
								withExtension:iTM2TextStyleExtension subdirectory: iTM2TextStyleComponent
										domains:NSNetworkDomainMask|NSLocalDomainMask|NSUserDomainMask]) {
			for (variantURL in [DFM contentsOfDirectoryAtURL:styleURL includingPropertiesForKeys:[NSArray array] options:NSDirectoryEnumerationSkipsHiddenFiles error:NULL]) {
                if (variantURL.isFileURL && [DFM fileExistsAtPath:variantURL.path isDirectory:&isDirectory] && isDirectory) {
                    variant = variantURL.lastPathComponent.stringByDeletingPathExtension;
                    [MD setObject:variant forKey:variant.lowercaseString];
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
    NSUInteger _Count;
    id _Keys;
    id _Font;
    id _ForegroundColor;
    id _BackgroundColor;
    id _CursorIsWhite;
    id _NoBackground;
    id _TextMode;
}
@property NSUInteger _Count;
@property (retain) id _Keys;
@property (retain) id _Font;
@property (retain) id _ForegroundColor;
@property (retain) id _BackgroundColor;
@property (retain) id _CursorIsWhite;
@property (retain) id _NoBackground;
@property (retain) id _TextMode;
@end

#import "iTM2PathUtilities.h"

@implementation iTM2TextSyntaxParserAttributesServer
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= syntaxParserClass
+ (Class)syntaxParserClass;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSString * name = NSStringFromClass(self);
    NSAssert1([name hasSuffix:@"AttributesServer"],
        @"Attributes server class %@ is not suffixed with \"AttributesServer\"", name);
    name = [name substringWithRange:iTM3MakeRange(0, name.length-16)];
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
    variant = [variant lowercaseString];
//LOG4iTM3(@"INITIALIZING WITH VARIANT: %@", variant);
    if (self = [super init])
    {
        _Variant = [variant copy];
        self.attributesDidChange;
    }
//LOG4iTM3(@"_ModesAttributes are: %@", _ModesAttributes);
//END4iTM3;
    return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= syntaxParserVariant
- (NSString *)syntaxParserVariant;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return _ModesAttributes;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  attributesDidChange
- (void)attributesDidChange;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [_ModesAttributes autorelease];
    _ModesAttributes = [[[self.class syntaxParserClass] defaultModesAttributes] mutableCopy];
//    [self loadOtherModesAttributesWithVariant:self.syntaxParserVariant];
	NSError  * localError = nil;
	[_ModesAttributes addEntriesFromDictionary:
		[self.class modesAttributesWithVariant:self.syntaxParserVariant error:&localError]];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  shouldUpdateAttributes
- (void)shouldUpdateAttributes;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (!_UpToDate)
    {
        _UpToDate = YES;
        self.attributesDidChange;
        [self performSelector:@selector(__canUpdateNow) withObject:nil afterDelay:0.01];
    }
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  __canUpdateNow
- (void)__canUpdateNow;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    _UpToDate = NO;
//END4iTM3;
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [_ModesAttributes objectForKey:mode];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setAttributes:forMode:
- (void)setAttributes:(NSDictionary *)dictionary forMode:(NSString *)mode;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (dictionary)
		[_ModesAttributes setObject:dictionary forKey:mode];
	else
		[_ModesAttributes removeObjectForKey:mode];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= modesAttributesWithVariant:error:
+ (NSDictionary *)modesAttributesWithVariant:(NSString *)variant error:(NSError **)outErrorPtr;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Sat Jan 30 16:19:04 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//LOG4iTM3(@"variant is: %@", variant);
	NSMutableDictionary * modesAttributes = [NSMutableDictionary dictionary];
	NSString * variantURL = [iTM2TextDefaultVariant stringByAppendingPathExtension:iTM2TextVariantExtension];
	NSURL * styleURL = nil;
	NSBundle * MB = [NSBundle mainBundle];
	NSString * style = [self.syntaxParserClass syntaxParserStyle];
	for (styleURL in [MB URLsForBuiltInResource4iTM3:style withExtension:iTM2TextStyleExtension subdirectory:iTM2TextStyleComponent]) {
		styleURL = [styleURL URLByAppendingPathComponent:variantURL];
		styleURL = styleURL.URLByResolvingSymlinksAndFinderAliasesInPath4iTM3;
		BOOL isDir = NO;
		if (styleURL.isFileURL && [DFM fileExistsAtPath:styleURL.path isDirectory:&isDir] && isDir) {
			styleURL = [[styleURL URLByAppendingPathComponent:iTM2TextAttributesModesComponent]
				URLByAppendingPathExtension:iTM2TextAttributesPathExtension];
			[modesAttributes addEntriesFromDictionary:[self.class modesAttributesWithContentsOfURL:styleURL error:outErrorPtr]];
		}
	}
    variant = [variant lowercaseString];
	variantURL = [variant stringByAppendingPathExtension:iTM2TextVariantExtension];
    if (![iTM2TextDefaultVariant isEqualToString:variant]) {
        for (styleURL in self.builtInStyleURLs) {
			styleURL = [styleURL URLByAppendingPathComponent:variantURL];
			styleURL = styleURL.URLByResolvingSymlinksAndFinderAliasesInPath4iTM3;
			BOOL isDir = NO;
			if (styleURL.isFileURL && [DFM fileExistsAtPath:styleURL.path isDirectory:&isDir] && isDir) {
				styleURL = [[styleURL URLByAppendingPathComponent:iTM2TextAttributesModesComponent]
					URLByAppendingPathExtension:iTM2TextAttributesPathExtension];
				NSDictionary * D = [self.class modesAttributesWithContentsOfURL:styleURL error:outErrorPtr];
				[modesAttributes addEntriesFromDictionary:D];
			}
		}
	}
	for (styleURL in [MB URLsForSupportResource4iTM3:style withExtension:iTM2TextStyleExtension subdirectory:iTM2TextStyleComponent]) {
		styleURL = [styleURL URLByAppendingPathComponent:variantURL];
		styleURL = styleURL.URLByResolvingSymlinksAndFinderAliasesInPath4iTM3;
		BOOL isDir = NO;
		if (styleURL.isFileURL && [DFM fileExistsAtPath:styleURL.path isDirectory:&isDir] && isDir) {
			styleURL= [[styleURL URLByAppendingPathComponent:iTM2TextAttributesModesComponent]
				URLByAppendingPathExtension:iTM2TextAttributesPathExtension];
			NSDictionary * D = [self.class modesAttributesWithContentsOfURL:styleURL error:outErrorPtr];
			[modesAttributes addEntriesFromDictionary:D];
		}
	}
//END4iTM3;
    return modesAttributes;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= builtInStyleURLs
+ (NSArray *)builtInStyleURLs;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSMutableArray * builtInStyleURLs = [NSMutableArray array];
	NSMutableArray * bundles = [[[NSBundle allFrameworks] mutableCopy] autorelease];
    id C = self.syntaxParserClass;
	[bundles removeObject:[C classBundle4iTM3]];
	[bundles insertObject:[C classBundle4iTM3] atIndex:0];
	[bundles addObject:[NSBundle mainBundle]];
	NSString * style = [self.syntaxParserClass syntaxParserStyle];
	NSBundle * B;
	for(B in bundles)
	{
		NSURL * url = [B URLForResource:style withExtension:iTM2TextStyleExtension subdirectory:iTM2TextStyleComponent];
		BOOL isDir = NO;
		if (url.isFileURL && [DFM fileExistsAtPath:url.path isDirectory:&isDir] && isDir) {
			[builtInStyleURLs addObject:url];
		}
		else if (iTM2DebugEnabled)
		{
			LOG4iTM3(@"No style/variant modes at built in bundle %@, default attributes might be used (2)", B);
		}
	}
//END4iTM3;
    return [NSArray arrayWithArray:builtInStyleURLs];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= otherStyleURLs
+ (NSArray *)otherStyleURLs;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Sat Jan 30 16:20:57 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//LOG4iTM3(@"the variant is: %@", variant);
	NSMutableArray * otherStyleURLs = [NSMutableArray array];
	for (NSURL * url in [[[NSBundle mainBundle] allURLsForResource4iTM3:[self.syntaxParserClass syntaxParserStyle]
								withExtension:iTM2TextStyleExtension subdirectory:iTM2TextStyleComponent] reverseObjectEnumerator]) {
        BOOL isDir = NO;
		if (url.isFileURL && [DFM fileExistsAtPath:url.path isDirectory:&isDir] && isDir) {
			[otherStyleURLs addObject:url];
        }
    }
//END4iTM3;
    return [NSArray arrayWithArray:otherStyleURLs];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  modesAttributesWithContentsOfURL:error:
+ (NSDictionary *)modesAttributesWithContentsOfURL:(NSURL *)fileURL error:(NSError **)outErrorPtr;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//LOG4iTM3(@"fileURL:%@",fileURL);
    NSData * D = [NSData dataWithContentsOfURL:fileURL options:0 error:outErrorPtr];
	NSMutableDictionary * MD = nil;
	if (!D)// either a missing file or a real error
	{
		fileURL = [fileURL URLByDeletingPathExtension];
		D = [NSData dataWithContentsOfURL:fileURL options:0 error:outErrorPtr];
		if (!D) {
			if (outErrorPtr && !*outErrorPtr) {
				REPORTERROR4iTM3(1,@"Missing file?",nil);
			}
			return nil;
		}
		if (D.length) {
			MD = [NSMutableDictionary dictionary];
			NSKeyedUnarchiver * KU = [[[NSKeyedUnarchiver alloc] initForReadingWithData:D] autorelease];
//			[KU setClass:[iTM2TextModeAttributesDictionary class] forClassName:@"NSDictionary"];
			for (id O in [KU decodeObjectForKey:@"iTM2:root"]) {
				id K = [O objectForKey:iTM2TextModeAttributeName];
				if (K) {
					if (O) {
						[MD setObject:O forKey:K];
                    } else {
						[MD removeObjectForKey:K];
                    }
				}
			}
			return MD;
		}
		return [NSDictionary dictionary];
	}
	NSAttributedString * AS = [[[NSAttributedString alloc] initWithData:D options:nil documentAttributes:nil error:outErrorPtr] autorelease];
	if (!AS) {
		return [NSDictionary dictionary];
	}
	// parse by lines with a regular expression
    ICURegEx * RE = [ICURegEx regExForKey:iTM2TextModeREPattern error:outErrorPtr];
    RE.inputString = AS.string;
	BOOL noBackgroundColor = NO;
	BOOL cursorIsWhite = NO;
    NSRange R = iTM3MakeRange(0,0);
    NSString * mode = nil;
    id attributes = nil;
	while (RE.nextMatch) {
        if ([RE rangeOfCaptureGroupWithName:@"mode"].length) {
            mode = nil;
        } else if ([RE rangeOfCaptureGroupWithName:@"background"].length) {
            noBackgroundColor = YES;
        } else if ([RE rangeOfCaptureGroupWithName:@"cursor"].length) {
            cursorIsWhite = YES;
        } else if ((R = [RE rangeOfCaptureGroupWithName:@"other"]),R.length) {
            if (!mode) {
                mode = [RE.inputString substringWithRange:R];
            }
            attributes = [NSMutableDictionary
                dictionaryWithDictionary:[AS attributesAtIndex:R.location effectiveRange:nil]];
			[attributes setObject:mode forKey:iTM2TextModeAttributeName];
			[MD setObject:attributes forKey:mode];
        }
    }
	if (noBackgroundColor || cursorIsWhite)
	{
		mode = iTM2TextBackgroundSyntaxModeName;
		if (attributes = [MD objectForKey:mode]) {
			attributes = [[attributes mutableCopy] autorelease];
		} else {
			attributes = [NSMutableDictionary dictionary];
		}
		NSNumber * N = [NSNumber numberWithBool:YES];
        [attributes setValue:(noBackgroundColor?N:nil) forKey:iTM2NoBackgroundAttributeName];
        [attributes setValue:(cursorIsWhite?N:nil) forKey:iTM2CursorIsWhiteAttributeName];
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSMutableAttributedString * MAS = [[[NSMutableAttributedString alloc] initWithString:@"### This is a style for iTeXMac2 syntax coloring\n"] autorelease];
	NSAttributedString * buffer = nil;
	NSEnumerator * E = dictionary.keyEnumerator;
	NSString * mode;
	id attributes;
	while(mode = E.nextObject)
	{
		if ([mode isEqual:@"_selection"]||[mode isEqual:@"_insertion"]||[mode isEqual:@"_white_prefix"])
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
	if ([N boolValue])
	{
		buffer = [[[NSMutableAttributedString alloc] initWithString:iTM2CursorIsWhiteAttributeName] autorelease];
		[MAS appendAttributedString:buffer];
		buffer = [[[NSMutableAttributedString alloc] initWithString:@"\n"] autorelease];
		[MAS appendAttributedString:buffer];
	}
	N = [attributes objectForKey:iTM2NoBackgroundAttributeName];
	if ([N boolValue])
	{
		buffer = [[[NSMutableAttributedString alloc] initWithString:iTM2NoBackgroundAttributeName] autorelease];
		[MAS appendAttributedString:buffer];
		buffer = [[[NSMutableAttributedString alloc] initWithString:@"\n"] autorelease];
		[MAS appendAttributedString:buffer];
	}
	NSRange range = iTM3MakeRange(0,MAS.length);
	NSData * D = [MAS RTFFromRange:range documentAttributes:nil];
//LOG4iTM3(@"fileName:%@",fileName);
//END4iTM3;
    return [D writeToFile:fileName options:NSAtomicWrite error:outErrorPtr];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  character:isMemberOfCoveredCharacterSetForMode:
- (BOOL)character:(unichar)theChar isMemberOfCoveredCharacterSetForMode:(NSString *)mode;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [[[[self attributesForMode:mode] objectForKey:NSFontAttributeName] coveredCharacterSet] characterIsMember:theChar];
}
@synthesize _Variant;
@synthesize _UpToDate;
@synthesize _ModesAttributes;
@end

@implementation iTM2TextModeAttributesDictionary

static NSUInteger iTM2FontAttributeNameHash = 0;
static NSUInteger iTM2ForegroundColorAttributeNameHash = 0;
static NSUInteger iTM2BackgroundColorAttributeNameHash = 0;
static NSUInteger iTM2TextModeAttributeNameHash = 0;
static NSUInteger iTM2CursorIsWhiteAttributeNameHash = 0;
static NSUInteger iTM2NoBackgroundAttributeNameHash = 0;
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initialize
+ (void)initialize;
{
    iTM2FontAttributeNameHash = [NSFontAttributeName hash];
    iTM2ForegroundColorAttributeNameHash = [NSForegroundColorAttributeName hash];
    iTM2BackgroundColorAttributeNameHash = [NSBackgroundColorAttributeName hash];
    iTM2TextModeAttributeNameHash = [iTM2TextModeAttributeName hash];
    iTM2CursorIsWhiteAttributeNameHash = [iTM2CursorIsWhiteAttributeName hash];
    iTM2NoBackgroundAttributeNameHash = [iTM2NoBackgroundAttributeName hash];
//LOG4iTM3(@"iTM2FontAttributeNameHash is: %i", iTM2FontAttributeNameHash);
//LOG4iTM3(@"iTM2ForegroundColorAttributeNameHash is: %i", iTM2ForegroundColorAttributeNameHash);
//LOG4iTM3(@"iTM2BackgroundColorAttributeNameHash is: %i", iTM2BackgroundColorAttributeNameHash);
//LOG4iTM3(@"iTM2TextModeAttributeNameHash is: %i", iTM2TextModeAttributeNameHash);
//LOG4iTM3(@"iTM2CursorIsWhiteAttributeNameHash is: %i", iTM2CursorIsWhiteAttributeNameHash);
//LOG4iTM3(@"iTM2NoBackgroundAttributeNameHash is: %i", iTM2NoBackgroundAttributeNameHash);
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  init
- (id)init;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Oct  6 12:57:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return [super init];
}
#define REGISTER(entry, attributeName)\
    if (O = [D objectForKey:attributeName])\
    {\
        [mra addObject:attributeName];\
        if (entry!=O)\
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if ((self = [super init])) {
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (self = self.init)
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (self = self.init)
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
- (id)initWithObjects:(id *)objects forKeys:(id *)keys count:(NSUInteger)count;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Oct  6 12:57:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (self = self.init)
    {
	_Count = 0;
        NSDictionary * D = [[[NSDictionary alloc] initWithObjects:(id *)objects forKeys:(id *)keys count:(NSUInteger)count] autorelease];
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (self = self.init)
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (self = self.init)
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  count
- (NSUInteger)count;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Oct  6 12:57:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
    return _Count;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  keyEnumerator
- (NSEnumerator *)keyEnumerator;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Oct  6 12:57:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
    return [_Keys objectEnumerator];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  objectForKey:
- (id)objectForKey:(id)aKey;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Oct  6 12:57:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
    NSUInteger hash = [aKey hash];
    if (hash == iTM2FontAttributeNameHash)
        return _Font;
    else if (hash == iTM2ForegroundColorAttributeNameHash)
        return _ForegroundColor;
    else if (hash == iTM2BackgroundColorAttributeNameHash)
        return _BackgroundColor;
    else if (hash == iTM2TextModeAttributeNameHash)
        return _TextMode;
    else if (hash == iTM2CursorIsWhiteAttributeNameHash)
        return _CursorIsWhite;
    else if (hash == iTM2NoBackgroundAttributeNameHash)
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
{DIAGNOSTIC4iTM3;
    return self == object;
}
@synthesize _Count;
@synthesize _Keys;
@synthesize _Font;
@synthesize _ForegroundColor;
@synthesize _BackgroundColor;
@synthesize _CursorIsWhite;
@synthesize _NoBackground;
@synthesize _TextMode;
@end

@implementation iTM2MainInstaller(TextStorageKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2TextStorageCompleteInstallation4iTM3
+ (void)iTM2TextStorageCompleteInstallation4iTM3;
/*"Description forthcoming.
 Version history: jlaurens AT users DOT sourceforge DOT net
 - 2: Mon Jun  7 21:48:56 GMT 2004
 To Do List: Nothing
 "*/
{DIAGNOSTIC4iTM3;
	//START4iTM3;
	[iTM2TextInspector swizzleInstanceMethodSelector4iTM3:@selector(SWZ_iTM2style_lazyTextStorage) error:NULL];
	[iTM2TextSyntaxParser class];
	[SUD registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:
						   [NSNumber numberWithBool:YES], iTM2SyntaxParserStyleEnabledKey, nil]];
	//END4iTM3;
    return;
}
@end


//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2TextAttributesKit