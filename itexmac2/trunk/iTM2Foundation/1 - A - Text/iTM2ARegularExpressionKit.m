// iTM2ARegularExpression.m
//
//  @version Subversion: $Id$ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Thu Jan 09 2003.
//  From source code of Mike Ferris's MOKit at http://mokit.sourcefoge.net
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

#import <iTM2Foundation/iTM2ARegularExpressionKit.h>
#import <iTM2Foundation/iTM2BundleKit.h>
#import "regcustom.h"

void * iTM2ARETestAndCompileString(NSString *string, BOOL ignoreCase);

@implementation iTM2ARegularExpression

+ (BOOL) validString: (NSString *) argument;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: ...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if (argument && ![argument isKindOfClass:[NSString class]]) 
        [NSException raise:NSInvalidArgumentException format:@"%@ NSString argument expected:got %@.", __PRETTY_FUNCTION__ , argument];
    BOOL isValid = NO;
    void *re;

    if (!argument) {
        isValid = NO;
    } else if (re = iTM2ARETestAndCompileString(argument, NO))
    {
        iTM2FreeRegex(re);
        isValid = YES;
    }
    return isValid;
}

+ (id) regularExpressionWithString: (NSString *) string;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: ...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [[[[self class] allocWithZone:nil] initWithString:string] autorelease];
}

+ (NSString *) keyForErrorStatus: (int) status;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: ...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    switch(status)
    {
        case iTM2ARENoError:			return @"No error";
        case iTM2ARENoMatch: 			return @"No match";
        case iTM2AREInvalidRegularExpression:	return @"Invalid regular expression";
        case iTM2AREInvalidCollatingElement: 	return @"Invalid collating element";
        case iTM2AREInvalidCharacterClass:	return @"Invalid character class";
        case iTM2AREInvalidEscapeSequence: 	return @"Invalid escape sequence";
        case iTM2AREInvalidBackreferenceNumber: 	return @"Invalid back reference number";
        case iTM2AREUnbalancedBracket: 		return @"Unbalanced bracket";
        case iTM2AREUnbalancedParenthese: 	return @"Unbalanced parenthese";
        case iTM2AREUnbalancedBrace: 		return @"Unbalanced brace";
        case iTM2AREInvalidRepetitionCount:	return @"Invalid repetition count(s)";
        case iTM2AREInvalidCharacterRange: 	return @"Invalid character range";
        case iTM2AREMemoryError: 			return @"Out of memory";
        case iTM2AREInvalidQuantifierOperand: 	return @"Invalid quantifier operand";
        case iTM2AREBug: 				return @"Bug";
        case iTM2AREInvalidArgument: 		return @"Invalid argument to regex function";
        case iTM2AREInvalidWidth:			return @"Character widths of regex and string differ";
        case iTM2AREInvalidEmbeddedOption:	return @"Invalid embedded option";
        case iTM2AREExecutionError:		return @"Execution error";
        case iTM2ARENoStatus:			return @"No status";
        default:				return @"Unknown status";
    }
}

+ (NSString *) localizedStringForErrorStatus: (int) status;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: ...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return NSLocalizedStringFromTableInBundle([self keyForErrorStatus:status],
        @"iTM2AREStatusString", [self classBundle], "pretty human readable error status");
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  compilationStatusString
- (NSString *) compilationStatusString;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: ...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [[self class] localizedStringForErrorStatus:[self compilationStatus]];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  compilationStatus;
- (iTM2AREErrorStatus) compilationStatus;
/*"Lazy intializer.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: ...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self expressionValue];
    return _CompilationStatus;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  executionStatus;
- (iTM2AREErrorStatus) executionStatus;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: ...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return _ExecutionStatus;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initWithString:
- (id) initWithString: (NSString *) string;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: ...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [self initWithString:string options:iTM2AREAdvancedMask];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initWithString:options:
- (id) initWithString: (NSString *) string options: (unsigned) flags;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: ...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if ([string isKindOfClass:[NSString class]])
    {
        if (self = [super init])
        {
            _Options = flags;
            _CompilationStatus = _ExecutionStatus = iTM2ARENoStatus;
            _String = [string copyWithZone:[self zone]];
        }
    }
    else if(string)
    {
        [self dealloc];
        self = nil;
        [NSException raise:NSInvalidArgumentException format:@"%@ NSString argument expected:got %@.",
            __PRETTY_FUNCTION__ , string];
    }
    return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  expressionValue
- (void *) expressionValue;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: ...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(!_Expression)
    {
        _Expression = (regex_t *) malloc(sizeof(regex_t));

        const unichar * buffer = CFStringGetCharactersPtr((CFStringRef)_String);
        unsigned length = [_String length];
//NSLog(@"_Options: %x (%x)", _Options, iTM2AREAdvancedMask);
        if(buffer)
        {
            _CompilationStatus = iTM2AReComp(_Expression, buffer, length, _Options);        
        }
        else
        {
            unichar * buffer = malloc(length * sizeof(unichar));
            if(!buffer)
            {
                NSLog(@"Why?");
                _CompilationStatus = REG_ESPACE;// NO MORE MEMORY
                return nil;
            }
            [_String getCharacters:buffer];
//NSLog(@"I am currently compiling... %#x", _Options);
//NSLog(@"iTM2AREExtendedMask: %@", (_Options & iTM2AREExtendedMask? @"Y": @"N"));
//NSLog(@"iTM2AREAdvancedFeatureMask: %@", (_Options & iTM2AREAdvancedFeatureMask? @"Y": @"N"));
//NSLog(@"iTM2AREQuoteMask: %@", (_Options & iTM2AREQuoteMask? @"Y": @"N"));
//NSLog(@"iTM2ARECaseIndependentMask: %@", (_Options & iTM2ARECaseIndependentMask? @"Y": @"N"));
//NSLog(@"iTM2AREIgnoreSubexpressionsMask: %@", (_Options & iTM2AREIgnoreSubexpressionsMask? @"Y": @"N"));
//NSLog(@"iTM2AREExpandedMask: %@", (_Options & iTM2AREExpandedMask? @"Y": @"N"));
//NSLog(@"iTM2AREPartialNewlineSensitiveMask: %@", (_Options & iTM2AREPartialNewlineSensitiveMask? @"Y": @"N"));
//NSLog(@"iTM2AREInversePartialNewlineSensitiveMask: %@", (_Options & iTM2AREInversePartialNewlineSensitiveMask? @"Y": @"N"));
            _CompilationStatus = iTM2AReComp(_Expression, buffer, length, _Options);        
            free(buffer);
        }
    }
    return _Expression;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  
- (id) copyWithZone: (NSZone *) zone;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: ...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if (zone == [self zone]) {
        return [self retain];
    } else {
        return [[[self class] allocWithZone:zone] initWithString:_String];
    }
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  dealloc
- (void) dealloc;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: ...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if (_Expression)
    {
        iTM2FreeRegex(_Expression);
        _Expression = nil;
    }
    [_String release];
    _String = nil;
    [super dealloc];
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  isEqual:
- (BOOL) isEqual: (id) rhs
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [super isEqual:rhs] ||
        ([rhs isKindOfClass:[iTM2ARegularExpression class]] && [[self stringValue] isEqualToString:[rhs stringValue]]);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  hash
- (unsigned) hash;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: ...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [_String hash];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  stringValue
- (NSString *) stringValue;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: ...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return _String;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  ignoreCase
- (BOOL) ignoreCase;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: ...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return _Options & iTM2ARECaseIndependentMask;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setIgnoreCase:
- (void) setIgnoreCase: (BOOL) flag;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: ...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(flag)
        _Options |= iTM2ARECaseIndependentMask;
    else
        _Options &= ~iTM2ARECaseIndependentMask;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setOptions:
- (void) setOptions: (int) flags;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: ...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//NSLog(@"old: %x", _Options);
//NSLog(@"new: %x", flags);
    if(_Options != flags)
    {
        _Options = flags;
        if (_Expression)
        {
            iTM2FreeRegex(_Expression);
            _Expression = nil;
        }
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  matchRangesInCharacters: (const unichar *) candidateChars range;
- (NSArray *) matchRangesInCharacters: (const unichar *) unichars range: (NSRange) searchRange;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: ...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    regex_t * re = [self expressionValue];
    size_t nmatch = 20;//1+MIN(20, re->re_nsub);
    regmatch_t * pmatch = malloc(nmatch*sizeof(regmatch_t));
    NSMutableArray * result = [NSMutableArray array];
    int eFlags = 0L;
    #if 0
    if(searchRange.location>0)
    {
        unsigned location = MAX(0, searchRange.location-2);
        unsigned length = searchRange.location - location;
        NSString * S = [NSString stringWithCharacters:&(unichars[location]) length:length];
        unsigned start;
        [S getLineStart:&start end:nil contentsEnd:nil forRange:NSMakeRange([S length], 0)];
        if(start<[S length])
        {
            eFlags = iTM2AREBOSOnlyMask;
        }
    }
    #endif
    NS_DURING
    _ExecutionStatus = iTM2AReExec( re, &(unichars[searchRange.location]), 0, searchRange.length, NULL, nmatch, pmatch, eFlags);
    if(_ExecutionStatus == iTM2ARENoError)
    {
        unsigned i = 0;
//NSLog(@"nmatch: %i", nmatch);
        if(i<nmatch)
        {
            if((pmatch->rm_so >= 0) && (pmatch->rm_eo >= pmatch->rm_so))
            {
                [result addObject:[NSValue valueWithRange:
//                    NSMakeRange(pmatch->rm_so, pmatch->rm_eo - pmatch->rm_so)]];
                    NSMakeRange(searchRange.location + pmatch->rm_so, pmatch->rm_eo - pmatch->rm_so)]];
                regmatch_t * ppmatch = pmatch;
                theParty:
                ++i;
                if(i<nmatch)
                {
                    ++ppmatch;
                    if((ppmatch->rm_so>=pmatch->rm_so) &&
                        (ppmatch->rm_eo>=ppmatch->rm_so) &&
                            (pmatch->rm_eo>=ppmatch->rm_eo))
                    {
                        [result addObject:[NSValue valueWithRange:
                            NSMakeRange(ppmatch->rm_so - pmatch->rm_so, ppmatch->rm_eo - ppmatch->rm_so)]];// Offsets!!!
                        goto theParty;
                        // all the other results are simply ignored.
                    }
                    #if 0
                    else
                        [NSException raise:NSInternalInconsistencyException format:
                            @"%@ valid range value expected here too (%i, %i, %i, %i)",
                                __PRETTY_FUNCTION__,
                                    pmatch->rm_so, ppmatch->rm_so, ppmatch->rm_eo, pmatch->rm_eo];
                    #endif
                }
            }
            else
                [NSException raise:NSInternalInconsistencyException format:
                        @"%@ valid range value expected (%i, %i).", __PRETTY_FUNCTION__,
                                    pmatch->rm_so, pmatch->rm_eo];
        }
    }
    else if (_ExecutionStatus != iTM2ARENoMatch)
        NSLog(@"Problem: %i", _ExecutionStatus);
    NS_HANDLER
    NSLog(@"*** CATCHED EXCEPTION: %@", [localException reason]);
    _ExecutionStatus = iTM2AREExecutionError;
    result = [NSArray array];
    NS_ENDHANDLER
    free(pmatch);
//NSLog(@"native, result; %@", result);
    return result;
}
#define EXPRESSION_STRING_KEY @"iTM2String"
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  
- (void) encodeWithCoder: (NSCoder *) coder;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: ...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    // Do not call super.  NSObject does not conform to NSCoding.
    [coder encodeObject:_String forKey:EXPRESSION_STRING_KEY];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  
- (id) initWithCoder: (NSCoder *) coder
{iTM2_DIAGNOSTIC;
//iTM2_START;
    // Do not call super.  NSObject does not conform to NSCoding.
    if(self = [super init])
    {
        _String = [[coder decodeObjectForKey:EXPRESSION_STRING_KEY] copyWithZone:[self zone]];
    }
    return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  rangesOfRegularExpression:options:range:
- (NSString *) description
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: ...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSString * S = [NSString stringWithFormat:@"<%@:%#x:%@>", [self class], (unsigned)self, [self stringValue]];
    return S;
}

@end

void * iTM2ARETestAndCompileString(NSString *string, BOOL ignoreCase)
{
//NSLog(@"iTM2ARETestAndCompileString");
    // Caller frees return value if non-null.
    regex_t *re = NULL;
    int err;
    int flags;
    unsigned len;
    unichar *chrs;
    
    re = malloc(sizeof(regex_t));
    if (ignoreCase) {
        flags = (REG_ADVANCED | REG_ICASE);
    } else {
        flags = (REG_ADVANCED);
    }
    // !!!:mferris:20021028 Avoid malloc for small strings?
    len = [string length];
    chrs = malloc(sizeof(unichar) * len);
    [string getCharacters:chrs];
    err = iTM2AReComp(re, chrs, len, flags);
    free(chrs);
    if (err != REG_OKAY) {
        iTM2AReFree(re), re = NULL;
//NSLog(@"There is a compilation problem: %i", err);
    }
    return re;
}

void iTM2FreeRegex(void *re) {    
    regfree((regex_t *) re);
    free(re);
}

@implementation NSString(iTM2ARegularExpression)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  TeX2REConvertedString
- (NSString *) TeX2REConvertedString;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: ...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSMutableString * S = [[self mutableCopy] autorelease];
    #define REPLACE(T, R)\
    [S replaceOccurrencesOfString:T withString:R options:0L range:NSMakeRange(0, [S length])]
//    NSLog(@"%@->%@: %i", T, R, [S replaceOccurrencesOfString:T withString:R options:0L range:NSMakeRange(0, [S length])])
    REPLACE(@"\\", @"\\\\");
    REPLACE(@"*", @"\\*");
    REPLACE(@"+", @"\\+");
    REPLACE(@"?", @"\\?");
    REPLACE(@".", @"\\.");
    REPLACE(@":", @"\\:");
    REPLACE(@"^", @"\\^");
    REPLACE(@"$", @"\\$");
    REPLACE(@"#", @"\\#");
    REPLACE(@"{", @"\\{");
    REPLACE(@"}", @"\\}");
    REPLACE(@"[", @"\\[");
    REPLACE(@"]", @"\\]");
    REPLACE(@"(", @"\\(");
    REPLACE(@")", @"\\)");
    REPLACE(@"<", @"\\<");
    REPLACE(@">", @"\\>");
    REPLACE(@"_", @"\\_");
    #undef REPLACE
    return S;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  RE2TeXConvertedString
- (NSString *) RE2TeXConvertedString;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: ...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSMutableString * S = [[self mutableCopy] autorelease];
    #define REPLACE(R, T)\
        [S replaceOccurrencesOfString:T withString:R options:0L range:NSMakeRange(0, [S length])]
//    NSLog(@"%@->%@: %i", T, R, [S replaceOccurrencesOfString:T withString:R options:0L range:NSMakeRange(0, [S length])])
//    NSLog(@"%i",)
    REPLACE(@"", @"()");
    REPLACE(@"*", @"\\*");
    REPLACE(@"+", @"\\+");
    REPLACE(@"?", @"\\?");
    REPLACE(@".", @"\\.");
    REPLACE(@":", @"\\:");
    REPLACE(@"^", @"\\^");
    REPLACE(@"$", @"\\$");
    REPLACE(@"#", @"\\#");
    REPLACE(@"{", @"\\{");
    REPLACE(@"}", @"\\}");
    REPLACE(@"[", @"\\[");
    REPLACE(@"]", @"\\]");
    REPLACE(@"(", @"\\(");
    REPLACE(@")", @"\\)");
    REPLACE(@"<", @"\\<");
    REPLACE(@">", @"\\>");
    REPLACE(@"_", @"\\_");
    REPLACE(@"-", @"\\-");
    REPLACE(@"\\", @"\\\\");
    #undef REPLACE
    return S;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  rangesOfRegularExpression:
- (NSArray *) rangesOfRegularExpression: (iTM2ARegularExpression *) RE;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: ...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [self rangesOfRegularExpression:RE options:0L];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  rangesOfRegularExpression:options:
- (NSArray *) rangesOfRegularExpression: (iTM2ARegularExpression *) RE options: (unsigned) mask;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: ...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [self rangesOfRegularExpression:RE options:mask range:NSMakeRange(0, [self length])];
}
#if 1
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  rangesOfRegularExpression:options:range:
- (NSArray *) rangesOfRegularExpression: (iTM2ARegularExpression *) RE options: (unsigned) mask range: (NSRange) searchRange;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: ...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(NSMaxRange(searchRange)>[self length])
        [NSException raise:NSRangeException format:@"%@ bad range:%@ (good %@).",
            __PRETTY_FUNCTION__,
                NSStringFromRange(searchRange), NSStringFromRange(NSMakeRange(0, [self length]))];
    void * buffer = (void *)CFStringGetCharactersPtr((CFStringRef)self);
    void * buffer1 = nil;
    if(!buffer)
    {
        buffer1 = malloc([self length] * sizeof(unichar));
        if(!buffer1)
        {
//            [RE setCompileStatus:iTM2AREMemoryError];
            return [NSArray array];
        }
        else
        {
            buffer = buffer1;
            [self getCharacters:buffer1];
        }
    }
    [RE setOptions:mask];
    NSArray * result = [RE matchRangesInCharacters:(unichar *)buffer range:searchRange];
    free(buffer1);
    return result;
}

#else
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  rangesOfRegularExpression:options:range:
- (NSArray *) rangesOfRegularExpression: (iTM2ARegularExpression *) RE options: (unsigned) mask range: (NSRange) searchRange;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: ...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(NSMaxRange(searchRange)>[self length])
        [NSException raise:NSRangeException format:@"%@ bad range:%@ (good %@).",
            __PRETTY_FUNCTION__,
                NSStringFromRange(searchRange), NSStringFromRange(NSMakeRange(0, [self length]))];
//NSLog(@"RE: %@", RE);
//NSLog(@"searchRange: %@", NSStringFromRange(searchRange));
    if(![[RE stringValue] length])
        return [NSArray array];
    [RE setOptions:mask];
    void * buffer = (void *)CFStringGetCharactersPtr((CFStringRef)self);
    if(buffer)
        return [RE matchRangesInCharacters:(unichar *)buffer range:searchRange];

    buffer = malloc(searchRange.length * sizeof(unichar));
    if(!buffer)
    {
//        [RE setCompileStatus:iTM2AREMemoryError];
        return [NSArray array];
    }
    
    [self getCharacters:buffer range:searchRange];
    NSArray * result = [RE matchRangesInCharacters:(unichar *)buffer range:NSMakeRange(0, searchRange.length)];
    free(buffer);
    if(searchRange.location)
    {
        NSMutableArray * MRA = [NSMutableArray array];
        NSEnumerator * E = [result objectEnumerator];
        NSValue * V;
        while(V = [E nextObject])
        {
            NSRange R = [V rangeValue];
            R.location += searchRange.location;
            [MRA addObject:[NSValue valueWithRange:R]];
        }
        result = MRA;
    }
//NSLog(@"pas native, result: %@", result);
    return result;
}
#endif
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  allRangesOfRegularExpression:
- (NSArray *) allRangesOfRegularExpression: (iTM2ARegularExpression *) RE;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: ...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [self allRangesOfRegularExpression:(iTM2ARegularExpression *) RE options:iTM2AREAdvancedMask];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  allRangesOfRegularExpression:options:
- (NSArray *) allRangesOfRegularExpression: (iTM2ARegularExpression *) RE options: (unsigned) mask;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: ...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [self allRangesOfRegularExpression:RE options:mask range:NSMakeRange(0, [self length])];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  allRangesOfRegularExpression:options:range:
- (NSArray *) allRangesOfRegularExpression: (iTM2ARegularExpression *) RE options: (unsigned) mask range: (NSRange) searchRange;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: ...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSMutableArray * MRA = [NSMutableArray array];
    float L0 = MAX(1.0, searchRange.length);
    unsigned top = NSMaxRange(searchRange);
    theBeach:
    [[NSNotificationCenter defaultCenter]
        postNotificationName: @"iTM2ProgressInfoNotification"
            object: self
                userInfo: [NSDictionary dictionaryWithObject:
                    [NSNumber numberWithFloat:MAX(0, 1-searchRange.length/L0)] forKey:@"Done"]];
    NSArray * RA = [self rangesOfRegularExpression:RE options:mask range:searchRange];
//NSLog(@"RA: %@", RA);
    if([RA count])
    {
        NSValue * V = [RA objectAtIndex:0];
        if(![V isKindOfClass:[NSValue class]])
            [NSException raise:NSRangeException format:@"%@ NSValue expected:got %@.",
                __PRETTY_FUNCTION__, V];
        else
        {
            NSRange R = [V rangeValue];
//NSLog(@"V: %@", V);
            if(R.length)
            {
                [MRA addObject:RA];
            }
            int newStart = NSMaxRange(R);
//NSLog(@"new start: %i", newStart);
            if(newStart>searchRange.location)
            {
                searchRange.location = newStart;
                searchRange.length = searchRange.location<top? top - searchRange.location: 0;
//NSLog(NSStringFromRange(searchRange));
                goto theBeach;
            }
        }
    }
    return MRA;
}
@end

@implementation iTM2ARESyntaxFormatter

- (NSString *)stringForObjectValue:(id)obj
{iTM2_DIAGNOSTIC;
    return ([obj isKindOfClass:[iTM2ARegularExpression class]] ? [obj stringValue] :@"");
}

- (BOOL)getObjectValue:(id *)obj forString:(NSString *)string errorDescription:(NSString **)error
{iTM2_DIAGNOSTIC;
    if (string && ![string isKindOfClass:[NSArray class]]) 
        [NSException raise:NSInvalidArgumentException format:@"%@ NSString argument expected:got %@.",
            __PRETTY_FUNCTION__ , string];
    if (string && ![string isEqualToString:@""]) {
        iTM2ARegularExpression *expression = [[iTM2ARegularExpression allocWithZone:[self zone]] initWithString:string];
        if (expression) {
            if (obj) {
                *obj = expression;
            }
            return YES;
        } else {
            if (error) {
                *error = NSLocalizedStringFromTableInBundle(@"Regular expression string is not valid.", @"iTM2Kit", [self classBundle], @"Displayable error message for mal-formed regular expressions.");
            }
            return NO;
        }
    } else {
        // nil or empty string
        if (obj) {
            *obj = nil;
        }
        return YES;
    }
}

@end

