#ifdef __iTeXMac2__
#	import <iTM2Foundation/ICURegEx.h>
#else
#	import "ICURegEx.h"
#endif

#undef U_DISABLE_RENAMING 1
#define U_DISABLE_RENAMING 1

#define __TEST_UNICODE_STRING__ 0

#import "unicode/regex_public.h"
#import "unicode/uchar.h"
#import "unicode/uregex.h"
#import "unicode/ustring.h"
#import "unicode/utypes.h"

@interface NSString(PRIVATE)

+(NSString *)stringWithUnicodeString:(UnicodeString)unicodeString;
-(UnicodeString)unicodeString;

@end

typedef struct
{
@defs(ICURegEx)
} ICURegExDef;

@interface ICURegExIVars:NSObject
{
@public
	NSString * string;// the search string
	NSString * replacement;// the replacement pattern
	NSError * error;
	unsigned stringOffset;// when the search should take place only in a substring
	unsigned stringLength;// when the search should take place only in a substring
	RegexPattern * regexPattern;// ICU
	RegexMatcher * regexMatcher;// ICU
	UnicodeString * uString;
	UnicodeString * uReplacement;
	UErrorCode status;
}
@end

@implementation ICURegExIVars
- (void)dealloc;
{
	[error autorelease];
	error = nil;
	[replacement autorelease];
	replacement = nil;
	[string autorelease];
	string = nil;
	delete regexPattern;
	regexPattern = nil;
	delete regexMatcher;
	regexMatcher = nil;
	delete uString;
	uString = nil;
	delete uReplacement;
	uReplacement = nil;
	[super dealloc];
	return;
}
@end

#define _IVARS ((ICURegExIVars*)_iVars)

static UChar U_CALLCONV
InlineBuffer_charAt(int32_t offset, void *context) {
    return (UChar)CFStringGetCharacterFromInlineBuffer((CFStringInlineBuffer*)context, offset);
}

@interface ICURegEx(PRIVATE)
- (int)status;
+ (NSString *)errorDescriptionForStatus:(int)status;
- (void)reset;
- (BOOL)resetAtIndex:(int)index;
@end

@implementation ICURegEx
static NSMutableDictionary * ICURegEx_cache = nil;
+ (void)initialize;
{
	iTM2_INIT_POOL;
	[super initialize];
	if(!ICURegEx_cache)
	{
		ICURegEx_cache = [[NSMutableDictionary dictionary] retain];
	}
	iTM2_RELEASE_POOL;
	return;
}
+ (id)regExWithSearchPattern:(NSString *)pattern;
{
	id result = [ICURegEx_cache objectForKey:pattern];
	if(result)
	{
		return result;
	}
	NSError * localError = nil;
	if(result = [[[self alloc] initWithSearchPattern:pattern options:0 error:&localError] autorelease])
	{
		[ICURegEx_cache setObject:result forKey:pattern];
		return result;
	}
	if(localError)
	{
		iTM2_LOG(@"***  ERROR creating a regular expression wrapper for pattern:%@,reason:%@",pattern,localError);
	}
	return nil;
}
+ (BOOL)isValidPattern:(NSString *)pattern options:(unsigned int)flags error:(NSError **)errorRef;
{
	// create the pattern
	UErrorCode status = U_ZERO_ERROR;
	UChar * buffer = (UChar *)CFStringGetCharactersPtr((CFStringRef)pattern);
	if(!buffer)
	{
		NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(
#if __BIG_ENDIAN__
		kCFStringEncodingUTF16BE
#elif __LITTLE_ENDIAN__
		kCFStringEncodingUTF16LE
#endif
		);
		buffer = (UChar *)[pattern cStringUsingEncoding:encoding];
	}
	int32_t buffLength = CFStringGetLength((CFStringRef)pattern);
	UnicodeString patString = UnicodeString(FALSE, buffer, buffLength);
	UParseError pe;
	RegexPattern * regexPattern = RegexPattern::compile(patString,flags,pe,status);
	delete regexPattern;
	regexPattern = nil;
	if(U_FAILURE(status))
	{
		if(errorRef)
		{
			NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
				[[self class] errorDescriptionForStatus:status],NSLocalizedDescriptionKey,
					nil];
			NSNumber * N;
			if(pe.line>0)
			{
				N = [NSNumber numberWithInt:pe.line-1];
				[dict setObject:N forKey:@"line"];
			}
			if(pe.offset>=0)
			{
				N = [NSNumber numberWithInt:pe.offset];
				[dict setObject:N forKey:(pe.line>0?@"column":@"offset")];
			}
			NSString * context;
			UnicodeString unicodeString;
			int length;
			if(length = u_strlen(pe.preContext))
			{
				context = (NSString *)CFStringCreateWithCharacters(kCFAllocatorDefault,pe.preContext,length);
				[dict setObject:context forKey:@"pre context"];
				[context release];
			}
			if(length = u_strlen(pe.postContext))
			{
				context = (NSString *)CFStringCreateWithCharacters(kCFAllocatorDefault,pe.postContext,length);
				[dict setObject:context forKey:@"post context"];
				[context release];
			}
			*errorRef = [NSError errorWithDomain:@"ICURegEx" code:-1 userInfo:dict];
		}
		return NO;
	}
	return YES;
}
- (id)initWithSearchPattern:(NSString *)pattern options:(unsigned int)flags error:(NSError **)errorRef;
{
	// allocate iVars
	ICURegExIVars * iVars = [[ICURegExIVars allocWithZone:[self zone]] init];
	if(!iVars)
	{
		if(errorRef)
		{
			NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:
				@"Can't allocate memory.",NSLocalizedDescriptionKey,
					nil];
			*errorRef = [NSError errorWithDomain:@"ICURegEx" code:-1 userInfo:dict];
		}
		[self dealloc];
		return nil;
	}
	// then create the pattern
	iVars->status = U_ZERO_ERROR;
	UChar * buffer = (UChar *)CFStringGetCharactersPtr((CFStringRef)pattern);
	if(!buffer)
	{
		NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(
#if __BIG_ENDIAN__
		kCFStringEncodingUTF16BE
#elif __LITTLE_ENDIAN__
		kCFStringEncodingUTF16LE
#endif
		);
		buffer = (UChar *)[pattern cStringUsingEncoding:encoding];
	}
	int32_t buffLength = CFStringGetLength((CFStringRef)pattern);
	UnicodeString patString = UnicodeString(FALSE, buffer, buffLength);
	UParseError pe;
	iVars->regexPattern = RegexPattern::compile(patString,flags,pe,iVars->status);
	if(U_FAILURE(iVars->status))
	{
		if(errorRef)
		{
			NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
				[[self class] errorDescriptionForStatus:iVars->status],NSLocalizedDescriptionKey,
					nil];
			NSNumber * N;
			if(pe.line>0)
			{
				N = [NSNumber numberWithInt:pe.line-1];
				[dict setObject:N forKey:@"line"];
			}
			if(pe.offset>=0)
			{
				N = [NSNumber numberWithInt:pe.offset];
				[dict setObject:N forKey:(pe.line>0?@"column":@"offset")];
			}
			NSString * context;
			UnicodeString unicodeString;
			int length;
			if(length = u_strlen(pe.preContext))
			{
				context = (NSString *)CFStringCreateWithCharacters(kCFAllocatorDefault,pe.preContext,length);
				[dict setObject:context forKey:@"pre context"];
				[context release];
			}
			if(length = u_strlen(pe.postContext))
			{
				context = (NSString *)CFStringCreateWithCharacters(kCFAllocatorDefault,pe.postContext,length);
				[dict setObject:context forKey:@"post context"];
				[context release];
			}
			*errorRef = [NSError errorWithDomain:@"ICURegEx" code:-1 userInfo:dict];
		}
		[self dealloc];
		return nil;
	}
	if(!iVars->regexPattern)
	{
		if(errorRef)
		{
			NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:
				@"Can't create regex pattern.",NSLocalizedDescriptionKey,
					nil];
			*errorRef = [NSError errorWithDomain:@"ICURegEx" code:iVars->status userInfo:dict];
		}
		[self dealloc];
		return nil;
	}
	if(self = [super init])
	{
		_iVars = iVars;
	}
	else
	{
		[iVars release];
	}
	return self;
}
- (id)copyWithZone:(NSZone *)zone;
{
	id result = [[ICURegEx allocWithZone:zone] init];
	if(result)
	{
		ICURegExIVars * iVars = [[ICURegExIVars allocWithZone:zone] init];
		if(iVars)
		{
			if(_IVARS->replacement)
			{
				iVars->replacement = [_IVARS->replacement retain];
				iVars->uReplacement = new UnicodeString(*_IVARS->uReplacement);
			}
			iVars->regexPattern = _IVARS->regexPattern->clone();
		}
		((ICURegExDef *)result)->_iVars = iVars;
	}
	return result;
}
- (void)dealloc;
{
	if(_IVARS)
	{
		if(_IVARS->uReplacement)
		{
			_IVARS->uReplacement->releaseBuffer(-1);
		}
		[_iVars release];
		_iVars = nil;
	}
	[super dealloc];
	return;
}
- (NSError *)error;
{
	return _IVARS->error;
}
+ (NSString *)errorDescriptionForStatus:(int)status;
{
#if 1
	switch(status)
	{
    case U_USING_FALLBACK_WARNING:
		return @"A resource bundle lookup returned a fallback result (not an error)";

//    case U_ERROR_WARNING_START:
//		return @"Start of information results (semantically successful)";

    case U_USING_DEFAULT_WARNING:
		return @"A resource bundle lookup returned a result from the root locale (not an error)";

    case U_SAFECLONE_ALLOCATED_WARNING:
		return @"A SafeClone operation required allocating memory (informational only)";

    case U_STATE_OLD_WARNING:
		return @"ICU has to use compatibility layer to construct the service. Expect performance/memory usage degradation. Consider upgrading";

    case U_STRING_NOT_TERMINATED_WARNING:
		return @"An output string could not be NUL-terminated because output length==destCapacity.";

    case U_SORT_KEY_TOO_SHORT_WARNING:
		return @"Number of levels requested in getBound is higher than the number of levels in the sort key";

    case U_AMBIGUOUS_ALIAS_WARNING:
		return @"This converter alias can go to different converter implementations";

    case U_DIFFERENT_UCA_VERSION:
		return @"ucol_open encountered a mismatch between UCA version and collator image version, so the collator was constructed from rules. No impact to further function";

    case U_ERROR_WARNING_LIMIT:
		return @"This must always be the last warning value to indicate the limit for UErrorCode warnings (last warning code +1)";


    case U_ZERO_ERROR:
		return @"No error, no warning.";

    case U_ILLEGAL_ARGUMENT_ERROR:
		return @"Start of codes indicating failure";
    case U_MISSING_RESOURCE_ERROR:
		return @"The requested resource cannot be found";
    case U_INVALID_FORMAT_ERROR:
		return @"Data format is not what is expected";
    case U_FILE_ACCESS_ERROR:
		return @"The requested file cannot be found";
    case U_INTERNAL_PROGRAM_ERROR:
		return @"Indicates a bug in the library code";
    case U_MESSAGE_PARSE_ERROR:
		return @"Unable to parse a message (message format)";
    case U_MEMORY_ALLOCATION_ERROR:
		return @"Memory allocation error";
    case U_INDEX_OUTOFBOUNDS_ERROR:
		return @"Trying to access the index that is out of bounds";
    case U_PARSE_ERROR:
		return @"Equivalent to Java ParseException";
    case U_INVALID_CHAR_FOUND:
		return @"Character conversion: Unmappable input sequence. In other APIs: Invalid character.";
    case U_TRUNCATED_CHAR_FOUND:
		return @"Character conversion: Incomplete input sequence.";
    case U_ILLEGAL_CHAR_FOUND:
		return @"Character conversion: Illegal input sequence/combination of input units.";
    case U_INVALID_TABLE_FORMAT:
		return @"Conversion table file found, but corrupted";
    case U_INVALID_TABLE_FILE:
		return @"Conversion table file not found";
    case U_BUFFER_OVERFLOW_ERROR:
		return @"A result would not fit in the supplied buffer";
    case U_UNSUPPORTED_ERROR:
		return @"Requested operation not supported in current context";
    case U_RESOURCE_TYPE_MISMATCH:
		return @"an operation is requested over a resource that does not support it";
    case U_ILLEGAL_ESCAPE_SEQUENCE:
		return @"ISO-2022 illlegal escape sequence";
    case U_UNSUPPORTED_ESCAPE_SEQUENCE:
		return @"ISO-2022 unsupported escape sequence";
    case U_NO_SPACE_AVAILABLE:
		return @"No space available for in-buffer expansion for Arabic shaping";
    case U_CE_NOT_FOUND_ERROR:
		return @"Currently used only while setting variable top, but can be used generally";
    case U_PRIMARY_TOO_LONG_ERROR:
		return @"User tried to set variable top to a primary that is longer than two bytes";
    case U_STATE_TOO_OLD_ERROR:
		return @"ICU cannot construct a service from this state, as it is no longer supported";
//    case U_TOO_MANY_ALIASES_ERRO:
//		return @"There are too many aliases in the path to the requested resource. It is very possible that a circular alias definition has occured";
    case U_ENUM_OUT_OF_SYNC_ERROR:
		return @"UEnumeration out of sync with underlying collection";
    case U_INVARIANT_CONVERSION_ERROR:
		return @" with the invariant converter.";
    case U_INVALID_STATE_ERROR:
		return @"Requested operation can not be completed with ICU in its current state";
    case U_COLLATOR_VERSION_MISMATCH:
		return @"Collator version is not compatible with the base version";
    case U_USELESS_COLLATOR_ERROR:
		return @"Collator is options only and no base is specified";
//    case U_NO_WRITE_PERMISSION:
//		return @"Attempt to modify read-only or constant data.";

    case U_STANDARD_ERROR_LIMIT:
		return @"This must always be the last value to indicate the limit for standard errors";
    /*
     * the error code range 0x10000 0x10100 are reserved for Transliterator
     */
    case U_BAD_VARIABLE_DEFINITION:
		return @"Missing '$' or duplicate variable name";
//    case U_PARSE_ERROR_START:
//		return @"Start of Transliterator errors";
    case U_MALFORMED_RULE:
		return @"Elements of a rule are misplaced";
    case U_MALFORMED_SET:
		return @"A UnicodeSet pattern is invalid";
    case U_MALFORMED_SYMBOL_REFERENCE:
		return @"UNUSED as of ICU 2.4";
    case U_MALFORMED_UNICODE_ESCAPE:
		return @"A Unicode escape pattern is invalid";
    case U_MALFORMED_VARIABLE_DEFINITION:
		return @"A variable definition is invalid";
    case U_MALFORMED_VARIABLE_REFERENCE:
		return @"A variable reference is invalid";
    case U_MISMATCHED_SEGMENT_DELIMITERS:
		return @"UNUSED as of ICU 2.4";
    case U_MISPLACED_ANCHOR_START:
		return @"A start anchor appears at an illegal position";
    case U_MISPLACED_CURSOR_OFFSET:
		return @"A cursor offset occurs at an illegal position";
    case U_MISPLACED_QUANTIFIER:
		return @"A quantifier appears after a segment close delimiter";
    case U_MISSING_OPERATOR:
		return @"A rule contains no operator";
    case U_MISSING_SEGMENT_CLOSE:
		return @"UNUSED as of ICU 2.4";
    case U_MULTIPLE_ANTE_CONTEXTS:
		return @"More than one ante context";
    case U_MULTIPLE_CURSORS:
		return @"More than one cursor";
    case U_MULTIPLE_POST_CONTEXTS:
		return @"More than one post context";
    case U_TRAILING_BACKSLASH:
		return @"A dangling backslash";
    case U_UNDEFINED_SEGMENT_REFERENCE:
		return @"A segment reference does not correspond to a defined segment";
    case U_UNDEFINED_VARIABLE:
		return @"A variable reference does not correspond to a defined variable";
    case U_UNQUOTED_SPECIAL:
		return @"A special character was not quoted or escaped";
    case U_UNTERMINATED_QUOTE:
		return @"A closing single quote is missing";
    case U_RULE_MASK_ERROR:
		return @"A rule is hidden by an earlier more general rule";
    case U_MISPLACED_COMPOUND_FILTER:
		return @"A compound filter is in an invalid location";
    case U_MULTIPLE_COMPOUND_FILTERS:
		return @"More than one compound filter";
    case U_INVALID_RBT_SYNTAX:
		return @"A \"::id\" rule was passed to the RuleBasedTransliterator parser";
    case U_INVALID_PROPERTY_PATTERN:
		return @"UNUSED as of ICU 2.4";
    case U_MALFORMED_PRAGMA:
		return @"A 'use' pragma is invlalid";
    case U_UNCLOSED_SEGMENT:
		return @"A closing ')' is missing";
    case U_ILLEGAL_CHAR_IN_SEGMENT:
		return @"UNUSED as of ICU 2.4";
    case U_VARIABLE_RANGE_EXHAUSTED:
		return @"Too many stand-ins generated for the given variable range";
    case U_VARIABLE_RANGE_OVERLAP:
		return @"The variable range overlaps characters used in rules";
    case U_ILLEGAL_CHARACTER:
		return @"A special character is outside its allowed context";
    case U_INTERNAL_TRANSLITERATOR_ERROR:
		return @"Internal transliterator system error";
    case U_INVALID_ID:
		return @"A \"::id\" rule specifies an unknown transliterator";
    case U_INVALID_FUNCTION:
		return @"A \"&fn()\" rule specifies an unknown transliterator";
    case U_PARSE_ERROR_LIMIT:
		return @"The limit for Transliterator errors";

    /*
     * the error code range 0x10100 0x10200 are reserved for formatting API parsing error
     */
    case U_UNEXPECTED_TOKEN:
		return @"Syntax error in format pattern";
//    case U_FMT_PARSE_ERROR_START:
//		return @"Start of format library errors";
    case U_MULTIPLE_DECIMAL_SEPARATORS:
		return @"More than one decimal separator in number pattern";
//    case U_MULTIPLE_DECIMAL_SEPERATORS:
//		return @"Typo: kept for backward compatibility. Use U_MULTIPLE_DECIMAL_SEPARATORS";
    case U_MULTIPLE_EXPONENTIAL_SYMBOLS:
		return @"More than one exponent symbol in number pattern";
    case U_MALFORMED_EXPONENTIAL_PATTERN:
		return @"Grouping symbol in exponent pattern";
    case U_MULTIPLE_PERCENT_SYMBOLS:
		return @"More than one percent symbol in number pattern";
    case U_MULTIPLE_PERMILL_SYMBOLS:
		return @"More than one permill symbol in number pattern";
    case U_MULTIPLE_PAD_SPECIFIERS:
		return @"More than one pad symbol in number pattern";
    case U_PATTERN_SYNTAX_ERROR:
		return @"Syntax error in format pattern";
    case U_ILLEGAL_PAD_POSITION:
		return @"Pad symbol misplaced in number pattern";
    case U_UNMATCHED_BRACES:
		return @"Braces do not match in message pattern";
    case U_UNSUPPORTED_PROPERTY:
		return @"UNUSED as of ICU 2.4";
    case U_UNSUPPORTED_ATTRIBUTE:
		return @"UNUSED as of ICU 2.4";
    case U_FMT_PARSE_ERROR_LIMIT:
		return @"The limit for format library errors";

    /*
     * the error code range 0x10200 0x102ff are reserved for Break Iterator related error
     */
    case U_BRK_INTERNAL_ERROR:
		return @"An internal error (bug) was detected.";
    case U_BRK_HEX_DIGITS_EXPECTED:
		return @"Hex digits expected as part of a escaped char in a rule.";
    case U_BRK_SEMICOLON_EXPECTED:
		return @"Missing ';' at the end of a RBBI rule.";
    case U_BRK_RULE_SYNTAX:
		return @"Syntax error in RBBI rule.";
    case U_BRK_UNCLOSED_SET:
		return @"UnicodeSet witing an RBBI rule missing a closing ']'.";
    case U_BRK_ASSIGN_ERROR:
		return @"Syntax error in RBBI rule assignment statement.";
    case U_BRK_VARIABLE_REDFINITION:
		return @"RBBI rule $Variable redefined.";
    case U_BRK_MISMATCHED_PAREN:
		return @"Mis-matched parentheses in an RBBI rule.";
    case U_BRK_NEW_LINE_IN_QUOTED_STRING:
		return @"Missing closing quote in an RBBI rule.";
    case U_BRK_UNDEFINED_VARIABLE:
		return @"Use of an undefined $Variable in an RBBI rule.";
    case U_BRK_INIT_ERROR:
		return @"Initialization failure.  Probable missing ICU Data.";
    case U_BRK_RULE_EMPTY_SET:
		return @"Rule contains an empty Unicode Set.";
    case U_BRK_UNRECOGNIZED_OPTION:
		return @"!!option in RBBI rules not recognized.";
    case U_BRK_MALFORMED_RULE_TAG:
		return @"The {nnn} tag on a rule is mal formed";
    case U_BRK_ERROR_LIMIT:
		return @"This must always be the last value to indicate the limit for Break Iterator failures";

    /*
     * The error codes in the range 0x10300-0x103ff are reserved for regular expression related errrs
     */
    case U_REGEX_INTERNAL_ERROR:
		return @"An internal error (bug) was detected.";
    case U_REGEX_RULE_SYNTAX:
		return @"Syntax error in regexp pattern.";
    case U_REGEX_INVALID_STATE:
		return @"RegexMatcher in invalid state for requested operation";
    case U_REGEX_BAD_ESCAPE_SEQUENCE:
		return @"Unrecognized backslash escape sequence in pattern";
    case U_REGEX_PROPERTY_SYNTAX:
		return @"Incorrect Unicode property";
    case U_REGEX_UNIMPLEMENTED:
		return @"Use of regexp feature that is not yet implemented.";
    case U_REGEX_MISMATCHED_PAREN:
		return @"Incorrectly nested parentheses in regexp pattern.";
    case U_REGEX_NUMBER_TOO_BIG:
		return @"Decimal number is too large.";
    case U_REGEX_BAD_INTERVAL:
		return @"Error in {min,max} interval";
    case U_REGEX_MAX_LT_MIN:
		return @"In {min,max}, max is less than min.";
    case U_REGEX_INVALID_BACK_REF:
		return @"Back-reference to a non-existent capture group.";
    case U_REGEX_INVALID_FLAG:
		return @"Invalid value for match mode flags.";
    case U_REGEX_LOOK_BEHIND_LIMIT:
		return @"Look-Behind pattern matches must have a bounded maximum length.";
    case U_REGEX_SET_CONTAINS_STRING:
		return @"Regexps cannot have UnicodeSets containing strings.";
    case U_REGEX_ERROR_LIMIT:
		return @"This must always be the last value to indicate the limit for regexp errors";

    /*
     * The error code in the range 0x10400-0x104ff are reserved for IDNA related error codes
     */
    case U_IDNA_PROHIBITED_ERROR:
		return @"Unknown description: U_IDNA_PROHIBITED_ERROR";
    case U_IDNA_UNASSIGNED_ERROR:
		return @"Unknown description: U_IDNA_UNASSIGNED_ERROR";
    case U_IDNA_CHECK_BIDI_ERROR:
		return @"Unknown description: U_IDNA_CHECK_BIDI_ERROR";
    case U_IDNA_STD3_ASCII_RULES_ERROR:
		return @"Unknown description: U_IDNA_STD3_ASCII_RULES_ERROR";
    case U_IDNA_ACE_PREFIX_ERROR:
		return @"Unknown description: U_IDNA_ACE_PREFIX_ERROR";
    case U_IDNA_VERIFICATION_ERROR:
		return @"Unknown description: U_IDNA_VERIFICATION_ERROR";
    case U_IDNA_LABEL_TOO_LONG_ERROR:
		return @"Unknown description: U_IDNA_LABEL_TOO_LONG_ERROR";
//    case U_IDNA_ZERO_LENGTH_LABEL_ERROR:
//		return @"Unknown description: U_IDNA_ZERO_LENGTH_LABEL_ERROR";
//    case U_IDNA_ERROR_LIMIT:
//		return @"Unknown description: U_IDNA_ERROR_LIMIT";
    /*
     * Aliases for StringPrep
     */
//    case U_STRINGPREP_PROHIBITED_ERROR:
//		return @"Unknown description: U_STRINGPREP_PROHIBITED_ERROR";
//    case U_STRINGPREP_UNASSIGNED_ERROR:
//		return @"Unknown description: U_STRINGPREP_UNASSIGNED_ERROR";
//    case U_STRINGPREP_CHECK_BIDI_ERROR:
//		return @"Unknown description: U_STRINGPREP_CHECK_BIDI_ERROR";


    case U_ERROR_LIMIT:
		return @"This must always be the last value to indicate the limit for UErrorCode (last error code +1)";
	}
#endif
	return @"Nothing available";
}
- (int)status;
{
	return _IVARS->status;
}
- (RegexPattern *)regexPattern;
{
	return _IVARS->regexPattern;
}
- (RegexMatcher *)regexMatcher;
{
	return _IVARS->regexMatcher;
}
- (NSString *)inputString;
{
	return _IVARS->string;
}
- (BOOL)setInputString:(NSString *)argument;
{
	return [self setInputString:argument range:NSMakeRange(0,[argument length])];
}
- (BOOL)setInputString:(NSString *)argument range:(NSRange)range;
{
	_IVARS->status = U_ZERO_ERROR;
	[_IVARS->error autorelease];
	_IVARS->error = nil;
	[_IVARS->string autorelease];
	_IVARS->string = [argument retain];
	delete _IVARS->regexMatcher;
	_IVARS->regexMatcher = nil;
	if(_IVARS->uString)
	{
		delete _IVARS->uString;
		_IVARS->uString = nil;
	}
	unsigned length = [argument length];
	if(range.location < length)
	{
		if(NSMaxRange(range)>length)
		{
			range.length = length - range.location;
		}
		_IVARS->stringOffset = range.location;
		if(_IVARS->string)
		{
			UChar * buffer = (UChar *)CFStringGetCharactersPtr((CFStringRef)argument);
			if(!buffer)
			{
				NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(
#if __BIG_ENDIAN__
				kCFStringEncodingUTF16BE
#elif __LITTLE_ENDIAN__
				kCFStringEncodingUTF16LE
#endif
				);
				buffer = (UChar *)[argument cStringUsingEncoding:encoding];
			}
			_IVARS->uString = new UnicodeString(FALSE, buffer+range.location, range.length);// the string to search is big
			_IVARS->status = U_ZERO_ERROR;
			_IVARS->regexMatcher = _IVARS->regexPattern->matcher(*(_IVARS->uString),_IVARS->status);
			if(U_FAILURE(_IVARS->status))
			{
				NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:
						[[self class] errorDescriptionForStatus:_IVARS->status],NSLocalizedDescriptionKey,
						[NSNumber numberWithInt:_IVARS->status],@"status",
							nil];
				_IVARS->error = [[NSError errorWithDomain:@"ICURegEx" code:-1 userInfo:dict] retain];
			}
			else if(!_IVARS->regexMatcher)
			{
				NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:
					@"Can't create regex matcher.",NSLocalizedDescriptionKey,
						nil];
				_IVARS->error = [NSError errorWithDomain:@"ICURegEx" code:_IVARS->status userInfo:dict];
			}
		}
		else
		{
			delete _IVARS->regexMatcher;
			_IVARS->regexMatcher = nil;
		}
	}
	else
	{
		NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:
				@"The given range is out of the bounds of the input string.",NSLocalizedDescriptionKey,
					nil];
		_IVARS->error = [[NSError errorWithDomain:@"ICURegEx" code:-4 userInfo:dict] retain];
		return NO;
	}
	return YES;
}
- (NSString *)searchPattern;
{
	return [NSString stringWithUnicodeString:[self regexPattern]->pattern()];
}
- (NSString *)replacementPattern;
{
	return _IVARS->replacement;
}
- (void)setReplacementPattern:(NSString *)argument;
{
	[_IVARS->replacement autorelease];
	_IVARS->replacement = [argument retain];
	if(_IVARS->uReplacement)
	{
		delete _IVARS->uReplacement;
		_IVARS->uReplacement = nil;
	}
	if(_IVARS->replacement)
	{
		_IVARS->uReplacement = new UnicodeString([_IVARS->replacement unicodeString]);
	}
	return;
}
- (void)forget;
{
	[self setReplacementPattern:nil];
	[self setInputString:nil];
	return;
}

static const UChar BACKSLASH  = 0x5c;
static const UChar DOLLARSIGN = 0x24;
- (NSString *)replacementString;
{
	[_IVARS->error autorelease];
	_IVARS->error = nil;
	_IVARS->status = U_ZERO_ERROR;
	if(!_IVARS->replacement)
	{
		_IVARS->status = U_REGEX_ERROR_START;
		NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:
				[[self class] errorDescriptionForStatus:_IVARS->status],NSLocalizedDescriptionKey,
				[NSNumber numberWithInt:-1],@"status",
					nil];
		_IVARS->error = [[NSError errorWithDomain:@"ICURegEx" code:-1 userInfo:dict] retain];
		return nil;
	}
	UnicodeString replacement = UnicodeString(*_IVARS->uReplacement);// make a copy
	UnicodeString dest = UnicodeString();
	RegexPattern pattern = _IVARS->regexMatcher->pattern();
	#define fPattern _IVARS->regexPattern
	#define status _IVARS->status
	
	// stolen from rematch.cpp
	// "CUT HERE"
	// scan the replacement text, looking for substitutions ($n) and \escapes.
    //  TODO:  optimize this loop by efficiently scanning for '$' or '\',
    //         move entire ranges not containing substitutions.
    int32_t  replLen = replacement.length();
    int32_t  replIdx = 0;
    while (replIdx<replLen) {
        UChar  c = replacement.charAt(replIdx);
        replIdx++;
        if (c == BACKSLASH) {
            // Backslash Escape.  Copy the following char out without further checks.
            //                    Note:  Surrogate pairs don't need any special handling
            //                           The second half wont be a '$' or a '\', and
            //                           will move to the dest normally on the next
            //                           loop iteration.
            if (replIdx >= replLen) {
                break;
            }
            c = replacement.charAt(replIdx);

            if (c==0x55/*U*/ || c==0x75/*u*/) {
                // We have a \udddd or \Udddddddd escape sequence.
                UChar32 escapedChar = replacement.unescapeAt(replIdx);
                if (escapedChar != (UChar32)0xFFFFFFFF) {
                    dest.append(escapedChar);
                    // TODO:  Report errors for mal-formed \u escapes?
                    //        As this is, the original sequence is output, which may be OK.
                    continue;
                }
            }

            // Plain backslash escape.  Just put out the escaped character.
            dest.append(c);
            replIdx++;
            continue;
        }

        if (c != DOLLARSIGN) {
            // Normal char, not a $.  Copy it out without further checks.
            dest.append(c);
            continue;
        }

        // We've got a $.  Pick up a capture group number if one follows.
        // Consume at most the number of digits necessary for the largest capture
        // number that is valid for this pattern.

        int32_t numDigits = 0;
        int32_t groupNum  = 0;
        UChar32 digitC;
        for (;;) {
            if (replIdx >= replLen) {
                break;
            }
            digitC = replacement.char32At(replIdx);
            if (u_isdigit(digitC) == FALSE) {
                break;
            }
            replIdx = replacement.moveIndex32(replIdx, 1);
            groupNum=groupNum*10 + u_charDigitValue(digitC);
            numDigits++;
            if (numDigits >= fPattern->fMaxCaptureDigits) {
                break;
            }
        }


        if (numDigits == 0) {
            // The $ didn't introduce a group number at all.
            // Treat it as just part of the substitution text.
            dest.append(DOLLARSIGN);
            continue;
        }

        // Finally, append the capture group data to the destination.
#if 0
        dest.append(group(groupNum, status));
        if (U_FAILURE(status)) {
            // Can fail if group number is out of range.
            break;
        }
#else
        dest.append(_IVARS->regexMatcher->group(groupNum, status));
        if (U_FAILURE(status)) {
            // Can fail if group number is out of range.
			NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:
					[[self class] errorDescriptionForStatus:status],NSLocalizedDescriptionKey,
					[NSNumber numberWithInt:status],@"status",
						nil];
			_IVARS->error = [[NSError errorWithDomain:@"ICURegEx" code:-1 userInfo:dict] retain];
            return nil;
        }
#endif
	#undef fPattern
	#undef status

    }
	return [NSString stringWithUnicodeString:dest];
}
- (BOOL)matchString:(NSString *)string;
{
	[self setInputString:string];
	BOOL result = [self nextMatch];
	return result;
}
- (NSString *)stringByMatchingString:(NSString *)string replacementPattern:(NSString *)replacement;
{
	if([self matchString:string])
	{
		[self setReplacementPattern:replacement];
		NSString * replacement = [self replacementString];
		[self setInputString:nil];
		return replacement;
	}
	[self forget];
	return nil;
}
- (BOOL)matchesAtIndex:(int)index extendToTheEnd:(BOOL)yorn;
{
	[_IVARS->error autorelease];
	_IVARS->error = nil;
	_IVARS->status = U_ZERO_ERROR;
	if(yorn)
	{
		if(_IVARS->regexMatcher->matches(index,_IVARS->status))
		{
			return YES;
		}
	}
	else if(_IVARS->regexMatcher->lookingAt(index,_IVARS->status))
	{
		return YES;
	}
	if(U_FAILURE(_IVARS->status))
	{
		NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:
				[[self class] errorDescriptionForStatus:_IVARS->status],NSLocalizedDescriptionKey,
				[NSNumber numberWithInt:_IVARS->status],@"status",
					nil];
		_IVARS->error = [[NSError errorWithDomain:@"ICURegEx" code:-1 userInfo:dict] retain];
	}
	return NO;
}
- (BOOL)nextMatch;
{
	if(!_IVARS->regexMatcher)
	{
		NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:
				@"No regex matcher: did you give an input string?",NSLocalizedDescriptionKey,
				[NSNumber numberWithInt:_IVARS->status],@"status",
					nil];
		_IVARS->error = [[NSError errorWithDomain:@"ICURegEx" code:-1 userInfo:dict] retain];
		return NO;
	}
	return _IVARS->regexMatcher->find() && [self rangeOfCaptureGroupAtIndex:0].length>0;// should the second part be necessary?
}
- (BOOL)nextMatchAfterIndex:(int)index;
{
	if(!_IVARS->regexMatcher)
	{
		NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:
				@"No regex matcher: did you give an input string?",NSLocalizedDescriptionKey,
				[NSNumber numberWithInt:_IVARS->status],@"status",
					nil];
		_IVARS->error = [[NSError errorWithDomain:@"ICURegEx" code:-1 userInfo:dict] retain];
		return NO;
	}
	[_IVARS->error autorelease];
	_IVARS->error = nil;
	_IVARS->status = U_ZERO_ERROR;
	if(_IVARS->regexMatcher->find(index,_IVARS->status))
	{
		return [self rangeOfCaptureGroupAtIndex:0].length>0;
	}
	if(U_FAILURE(_IVARS->status))
	{
		NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:
				[[self class] errorDescriptionForStatus:_IVARS->status],NSLocalizedDescriptionKey,
				[NSNumber numberWithInt:_IVARS->status],@"status",
					nil];
		_IVARS->error = [[NSError errorWithDomain:@"ICURegEx" code:-1 userInfo:dict] retain];
	}
	return NO;
}
- (NSRange)rangeOfMatch;
{
	return [self rangeOfCaptureGroupAtIndex:0];
}
- (NSString *)substringOfMatch;
{
	return [self substringOfCaptureGroupAtIndex:0];
}
- (int)numberOfCaptureGroups;
{
	if(!_IVARS->regexMatcher)
	{
		NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:
				@"No regex matcher: did you give an input string?",NSLocalizedDescriptionKey,
				[NSNumber numberWithInt:_IVARS->status],@"status",
					nil];
		_IVARS->error = [[NSError errorWithDomain:@"ICURegEx" code:-1 userInfo:dict] retain];
		return 0;
	}
	return _IVARS->regexMatcher->groupCount();
}
#include "uvectr32.h"
- (NSRange)rangeOfCaptureGroupAtIndex:(int)index;
{
	[_IVARS->error autorelease];
	_IVARS->error = nil;
	_IVARS->status = U_ZERO_ERROR;
	if(!_IVARS->regexMatcher)
	{
		NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:
				@"No regex matcher: did you give an input string?",NSLocalizedDescriptionKey,
				[NSNumber numberWithInt:_IVARS->status],@"status",
					nil];
		_IVARS->error = [[NSError errorWithDomain:@"ICURegEx" code:-1 userInfo:dict] retain];
		return NSMakeRange(NSNotFound,0);
	}
	int start = _IVARS->regexMatcher->start(index,_IVARS->status);
	if(U_FAILURE(_IVARS->status))
	{
		NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:
				[[self class] errorDescriptionForStatus:_IVARS->status],NSLocalizedDescriptionKey,
				[NSNumber numberWithInt:_IVARS->status],@"status",
					nil];
		_IVARS->error = [[NSError errorWithDomain:@"ICURegEx" code:-1 userInfo:dict] retain];
		return NSMakeRange(NSNotFound,0);
	}
	int end = _IVARS->regexMatcher->end(index,_IVARS->status);
	if(U_FAILURE(_IVARS->status))
	{
		NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:
				[[self class] errorDescriptionForStatus:_IVARS->status],NSLocalizedDescriptionKey,
				[NSNumber numberWithInt:_IVARS->status],@"status",
					nil];
		_IVARS->error = [[NSError errorWithDomain:@"ICURegEx" code:-1 userInfo:dict] retain];
		return NSMakeRange(NSNotFound,0);
	}
	return NSMakeRange(start + _IVARS->stringOffset, end-start);
}
- (NSString *)substringOfCaptureGroupAtIndex:(int)index;
{
	NSRange R = [self rangeOfCaptureGroupAtIndex:index];
	return R.length?[_IVARS->string substringWithRange:R]:@"";
}
- (NSArray *)componentsBySplitting;
{
	[self reset];
	NSMutableArray * result = [NSMutableArray array];
	#define input (_IVARS->uString)
	#define maxNumberOfComponents UINT_MAX
	unsigned firstUnrecorded = 0;
	const UChar * buffer = input->getBuffer();// read only buffer
	CFStringRef component = nil;
    //
    // Loop through the input text, searching for the delimiter pattern
    //
    while([self nextMatch])
	{
		// We found another delimiter.  Move everything from where we started looking
		//  up until the start of the delimiter into the next output string.
		// we create a UnicodeString for each component.
		NSRange matchRange = [self rangeOfMatch];
		component = CFStringCreateWithCharacters(kCFAllocatorDefault,buffer+firstUnrecorded,matchRange.location - firstUnrecorded);// create a UTF16 string with the buffer
		[result addObject:(NSString *)component];
		CFRelease(component);
		component = nil;
		firstUnrecorded = NSMaxRange(matchRange);
		// If the delimiter pattern has capturing parentheses, the captured
		//  text goes out into the next n destination strings.
		unsigned numberOfGroups = [self numberOfCaptureGroups];
		unsigned groupNum = 0;
		while(groupNum++ < numberOfGroups)
		{
			NSRange groupRange = [self rangeOfCaptureGroupAtIndex:groupNum];
			component = CFStringCreateWithCharacters(kCFAllocatorDefault,buffer+groupRange.location, groupRange.length);
			[result addObject:(NSString *)component];
			CFRelease(component);
			component = nil;
		}
	}
	unsigned remainingLength = input->length()-firstUnrecorded;
	if (remainingLength > 0)
	{
		component = CFStringCreateWithCharacters(kCFAllocatorDefault,buffer+firstUnrecorded,remainingLength);
		[result addObject:(NSString *)component];
		CFRelease(component);
		component = nil;
	}
	#undef input
	#undef maxNumberOfComponents
	[self reset];
	return result;
}
- (BOOL)reset;
{
	if(!_IVARS->regexMatcher)
	{
		NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:
				@"No regex matcher: did you give an input string?",NSLocalizedDescriptionKey,
				[NSNumber numberWithInt:_IVARS->status],@"status",
					nil];
		_IVARS->error = [[NSError errorWithDomain:@"ICURegEx" code:-1 userInfo:dict] retain];
		return NO;
	}
	_IVARS->regexMatcher->reset(*_IVARS->uString);
	return YES;
}
- (BOOL)resetAtIndex:(int)index;
{
	if(!_IVARS->regexMatcher)
	{
		NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:
				@"No regex matcher: did you give an input string?",NSLocalizedDescriptionKey,
				[NSNumber numberWithInt:_IVARS->status],@"status",
					nil];
		_IVARS->error = [[NSError errorWithDomain:@"ICURegEx" code:-1 userInfo:dict] retain];
		return NO;
	}
	NSParameterAssert((index<_IVARS->stringOffset));
	[_IVARS->error autorelease];
	_IVARS->error = nil;
	_IVARS->status = U_ZERO_ERROR;
	_IVARS->regexMatcher->reset(index,_IVARS->status);
	if(U_FAILURE(_IVARS->status))
	{
		NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:
				[[self class] errorDescriptionForStatus:_IVARS->status],NSLocalizedDescriptionKey,
				[NSNumber numberWithInt:_IVARS->status],@"status",
					nil];
		_IVARS->error = [[NSError errorWithDomain:@"ICURegEx" code:-1 userInfo:dict] retain];
		return NO;
	}
	return _IVARS->error!=nil;
}
- (void)displayMatchResult;
{
	if(!_IVARS)
	{
		NSLog(@"Nothing to display");
		return;
	}
	NSLog(@"Match result:");
	NSLog(@"search pattern:%@",[self searchPattern]);
	NSLog(@"input string:%@",[self inputString]);
	NSLog(@"input range:(%u,%u)",_IVARS->stringOffset,_IVARS->stringLength);
	unsigned i = 0;
	while(i<=[self numberOfCaptureGroups])
	{
		NSLog(@"%i:%@",i,[self substringOfCaptureGroupAtIndex:i]);
		++i;
	}
	NSLog(@"");
}
@end

@implementation NSString (NSStringICUREAdditions)

+(NSString *)stringWithUnicodeString:(UnicodeString)unicodeString;
{
	NSString * result = nil;
	NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(
#if __BIG_ENDIAN__
	kCFStringEncodingUTF16BE
#elif __LITTLE_ENDIAN__
	kCFStringEncodingUTF16LE
#endif
	);
	const UChar * buffer = unicodeString.getBuffer();
	if(buffer)
	{
		int length = unicodeString.length();
		result = [[[NSString alloc] initWithBytes:buffer length:length*sizeof(UChar) encoding:encoding] autorelease];
	}
	return result;
}

-(UnicodeString)unicodeString;
{
	
	UChar * buffer = (UChar *)CFStringGetCharactersPtr((CFStringRef)self);
	if(!buffer)
	{
		NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(
#if __BIG_ENDIAN__
		kCFStringEncodingUTF16BE
#elif __LITTLE_ENDIAN__
		kCFStringEncodingUTF16LE
#endif
		);
		buffer = (UChar *)[self cStringUsingEncoding:encoding];
	}
	int32_t buffLength = CFStringGetLength((CFStringRef)self);
	int32_t buffCapacity = buffLength;
	UnicodeString unicodeString = UnicodeString(buffer, buffLength, buffCapacity);
	#if __TEST_UNICODE_STRING__
	NSString * copy = [NSString stringWithUnicodeString:unicodeString];
	NSLog(@"Conversion test:%@<->%@, %@",self,copy, ([self isEqual:copy]?@"SUCCESS":@"FAILURE"));
	#endif
	return unicodeString;	
}

- (NSString *)stringByEscapingICUREControlCharacters;
{
	// see http://www.icu-project.org/userguide/regexp.html
	// "Characters that must be quoted to be treated as literals are * ? + [ ( ) { } ^ $ | \ . /"
	NSMutableString * MS = [NSMutableString stringWithString:self];
	[MS replaceOccurrencesOfString:@"\\" withString:@"\\\\" options:NULL range:NSMakeRange(0,[MS length])];
	[MS replaceOccurrencesOfString:@"*" withString:@"\\*" options:NULL range:NSMakeRange(0,[MS length])];
	[MS replaceOccurrencesOfString:@"?" withString:@"\\?" options:NULL range:NSMakeRange(0,[MS length])];
	[MS replaceOccurrencesOfString:@"+" withString:@"\\+" options:NULL range:NSMakeRange(0,[MS length])];
	[MS replaceOccurrencesOfString:@"[" withString:@"\\[" options:NULL range:NSMakeRange(0,[MS length])];
	[MS replaceOccurrencesOfString:@"(" withString:@"\\(" options:NULL range:NSMakeRange(0,[MS length])];
	[MS replaceOccurrencesOfString:@")" withString:@"\\)" options:NULL range:NSMakeRange(0,[MS length])];
	[MS replaceOccurrencesOfString:@"{" withString:@"\\{" options:NULL range:NSMakeRange(0,[MS length])];
	[MS replaceOccurrencesOfString:@"}" withString:@"\\}" options:NULL range:NSMakeRange(0,[MS length])];
	[MS replaceOccurrencesOfString:@"^" withString:@"\\^" options:NULL range:NSMakeRange(0,[MS length])];
	[MS replaceOccurrencesOfString:@"$" withString:@"\\$" options:NULL range:NSMakeRange(0,[MS length])];
	[MS replaceOccurrencesOfString:@"|" withString:@"\\|" options:NULL range:NSMakeRange(0,[MS length])];
	[MS replaceOccurrencesOfString:@"." withString:@"\\." options:NULL range:NSMakeRange(0,[MS length])];
	[MS replaceOccurrencesOfString:@"/" withString:@"\\/" options:NULL range:NSMakeRange(0,[MS length])];
	return MS;
}

- (NSRange)rangeOfICUREPattern:(NSString *)aPattern error:(NSError **)errorRef;
{
	return [self rangeOfICUREPattern:aPattern options:0 error:errorRef];
}

- (NSRange)rangeOfICUREPattern:(NSString *)aPattern options:(unsigned)mask error:(NSError **)errorRef;
{
	ICURegEx * RE = [[[ICURegEx alloc] initWithSearchPattern:aPattern options:mask error:errorRef] autorelease];
	if(!RE)
	{
		return NSMakeRange(NSNotFound,0);
	}
	[RE setInputString:self];
	[RE nextMatch];
	if(errorRef)
	{
		*errorRef = [RE error];
	}
	return [RE rangeOfMatch];
}

- (NSRange)rangeOfICUREPattern:(NSString *)aPattern options:(unsigned)mask range:(NSRange)searchRange error:(NSError **)errorRef;
{
	if(searchRange.length<[self length])
	{
		NSString * substring = [self substringWithRange:searchRange];
		return [substring rangeOfICUREPattern:aPattern options:mask error:errorRef];
	}
	NSRange result = [self rangeOfICUREPattern:aPattern options:mask error:errorRef];
	if(result.length)
	{
		result.location+=searchRange.location;
	}
	return result;
}

@end

@implementation NSMutableString(ICURegEx)

- (unsigned int)replaceOccurrencesOfICUREPattern:(NSString *)aPattern withPattern:(NSString *)replacement options:(unsigned)opts range:(NSRange)searchRange error:(NSError **)errorRef;
{
	ICURegEx * RE = [[[ICURegEx alloc] initWithSearchPattern:aPattern options:opts error:errorRef] autorelease];
	if(!RE)
	{
		return 0;
	}
	[RE setInputString:self range:searchRange];
	[RE setReplacementPattern:replacement];
	NSMutableArray * rangesAndReplacements = [NSMutableArray array];
	NSRange range;
	NSValue * value;
	
	while([RE nextMatch])
	{
		range = [RE rangeOfMatch];
		value = [NSValue valueWithRange:range];
		if(replacement = [RE replacementString])
		{
			[rangesAndReplacements addObject:value];
			[rangesAndReplacements addObject:replacement];
		}
		else
		{
			if(errorRef)
			{
				*errorRef = [RE error];
			}
			return 0;
		}
	}
	NSError * error = [RE error];
	if(error)
	{
		if(errorRef)
		{
			*errorRef = error;
		}
		return 0;
	}
	NSEnumerator * E = [rangesAndReplacements objectEnumerator];
	unsigned correction = 0;
	while((value = [E nextObject]) && (replacement = [E nextObject]))
	{
		range = [value rangeValue];
		[self replaceCharactersInRange:range withString:replacement];
		correction += [replacement length] - range.length;
	}
	return [rangesAndReplacements count]/2;
}

@end

