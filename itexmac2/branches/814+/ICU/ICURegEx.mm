#import "ICURegEx.h"

#undef U_DISABLE_RENAMING 1
#define U_DISABLE_RENAMING 1

#define __TEST_UNICODE_STRING__ 0

#import "unicode/regex_public.h"
#import "unicode/uchar.h"
#import "unicode/uregex.h"
#import "unicode/ustring.h"
#import "unicode/utypes.h"

#ifndef LOG4iTM3
#   define LOG4iTM3(DESCRIPTION,...)\
    do {\
        NSLog(@"file:%s line:%i", __FILE__, __LINE__);\
        NSLog(@"%s %#x", __PRETTY_FUNCTION__, self);\
        NSLog(DESCRIPTION,##__VA_ARGS__,NULL);\
    } while(NO)
#   define ASSERT_INCONSISTENCY4iTM3(WHAT) NSAssert2(NO,(@"REPORT INCONSISTENCY: OUPS (%s,%lu)"),__FILE__,__LINE__)
#   define RAISE_INCONSISTENCY4iTM3(WHY) NSAssert3(NO,(@"REPORT INCONSISTENCY: %@ (%s,%lu)"),WHY,__FILE__,__LINE__)
#endif

#ifndef iTM3EqualRanges
    NS_INLINE NSRange iTM3MakeRange(NSUInteger loc, NSUInteger len) {
        NSRange r;
        r.location = loc;
        if (len<(r.length = NSUIntegerMax-loc)) r.length = len;
        return r;
    }
    NS_INLINE NSUInteger iTM3MaxRange(NSRange range) {
        return (range.location < NSUIntegerMax - range.length ? range.location + range.length: NSUIntegerMax);
    }
#   define iTM3EqualRanges NSEqualRanges
#endif

#ifndef ZER0
#   define ZER0 ((NSUInteger)0)
#endif

/*
 LF:    Line Feed, U+000A
 CR:    Carriage Return, U+000D
 CR+LF: CR (U+000D) followed by LF (U+000A)
 NEL:   Next Line, U+0085
 VT:    Vertical Tab, U+000B
 FF:    Form Feed, U+000C
 LS:    Line Separator, U+2028
 PS:    Paragraph Separator, U+2029
 */

NSString * const iTM2RegExpEOLKey = @"EOL";
NSString * const iTM2RegExpCommandKey = @"⌘";
NSString * const iTM2RegExpResourceName = @"iTM2RegularExpressions";

@interface NSString(PRIVATE)

+(NSString *)stringWithUnicodeString4ICURE:(UnicodeString)unicodeString;
-(UnicodeString)unicodeString4ICURE;

@end

@interface ICURegExIVars:NSObject
{
@private
	NSString * pattern;// the string pattern
	NSString * string;// the search string
	NSString * replacement;// the replacement pattern
    NSArray * groupNames;
	NSIndexSet * commentGroupIndexes;
    NSError * error;
	NSUInteger stringOffset;// when the search should take place only in a substring
	NSUInteger stringLength;// when the search should take place only in a substring
	RegexPattern * __weak regexPattern;// ICU
	RegexMatcher * __weak regexMatcher;// ICU
	UnicodeString * __weak uString;
	UErrorCode status;
}
@property (assign,readwrite,nonatomic) NSString * pattern;
@property (assign,readwrite,nonatomic) NSString * string;
@property (assign,readwrite,nonatomic) NSString * replacement;
@property (assign,readwrite,nonatomic) NSArray * groupNames;
@property (assign,readwrite,nonatomic) NSIndexSet * commentGroupIndexes;
@property (assign,readwrite,nonatomic) NSError * error;
@property (assign,readwrite,nonatomic) NSUInteger stringOffset;
@property (assign,readwrite,nonatomic) NSUInteger stringLength;
@property (assign,readwrite,nonatomic) RegexPattern * regexPattern;
@property (assign,readwrite,nonatomic) RegexMatcher * regexMatcher;
@property (assign,readwrite,nonatomic) UnicodeString * uString;
@property (assign,readwrite,nonatomic) UErrorCode status;
@end

@implementation ICURegExIVars
- (void)finalize;
{
	delete regexPattern;
	regexPattern = nil;
	delete regexMatcher;
	regexMatcher = nil;
	delete uString;
	uString = nil;
	[super finalize];
	return;
}
@synthesize pattern;
@synthesize string;
@synthesize replacement;
@synthesize groupNames;
@synthesize commentGroupIndexes;
@synthesize error;
@synthesize stringOffset;
@synthesize stringLength;
@synthesize regexPattern;
@synthesize regexMatcher;
@synthesize uString;
@synthesize status;
@end

#define _IVARS ((ICURegExIVars*)_iVars)

@interface ICURegEx(PRIVATE)
- (NSInteger)status;
+ (NSString *)errorDescriptionForStatus:(NSInteger)status;
@end

#define iTM2_INIT_POOL
//id _P_O_O_L_ = [[NSAutoreleasePool alloc] init]
#define iTM2_RELEASE_POOL
//[_P_O_O_L_ drain]

@interface NSMutableString(_ICURegEx)
- (void)prependPathComponent4ICURegEx:(NSString *)aString;
@end

@implementation NSMutableString(_ICURegEx)
- (void)prependPathComponent4ICURegEx:(NSString *)aString;
{
    [self insertString:@"/" atIndex:ZER0];
    [self insertString:aString atIndex:ZER0];
}
@end

@interface ICURegEx()
@property (assign,readwrite) NSArray * groupNames;
@property (assign,readwrite) NSIndexSet * commentGroupIndexes;
@end

@implementation ICURegEx
static NSMutableDictionary * ICURegEx_by_pattern_cache = nil;
static NSMutableDictionary * ICURegEx_by_key_cache = nil;
+ (void)initialize;
{
	NSAutoreleasePool * P = [[NSAutoreleasePool alloc] init];
	//[super initialize];
	if (!ICURegEx_by_pattern_cache) {
		ICURegEx_by_pattern_cache = [[NSMutableDictionary dictionary] retain];
	}
	if (!ICURegEx_by_key_cache) {
		ICURegEx_by_key_cache = [[NSMutableDictionary dictionary] retain];
	}
	[P drain];
	return;
}
+ (id)regExForKey:(NSString *)patternKey error:(NSError **)errorRef;
{
    return [self regExForKey:patternKey inBundle:[NSBundle bundleForClass:self] error:errorRef];
}
+ (id)regExForKey:(NSString *)patternKey inBundle:(NSBundle *)bundle error:(NSError **)errorRef;
{
	ICURegEx * result = [ICURegEx_by_key_cache objectForKey:patternKey];
	if (result) {
		return result;
	}
    //  reentrant management, recursive call will return an object, even if it is not what is expected
    [ICURegEx_by_key_cache setObject:[ICURegEx regExWithSearchPattern:@"." error:errorRef] forKey:patternKey];
    //  get the location where the RE's are stored
    NSURL * url = [bundle URLForResource:iTM2RegExpResourceName withExtension:@"plist"];
    //  get the file contents
    NSDictionary * resource = [NSDictionary dictionaryWithContentsOfURL:url];
    //  get the dictionary for the given pattern key
    NSDictionary * infos = [resource objectForKey:patternKey];
    if (!infos) {
        if (errorRef) {
            //  creation failure, setting the error on return
            *errorRef = [NSError errorWithDomain:@"ICURegEx" code:-5
                userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                    [NSString stringWithFormat:@"Unknown key:"
                    @"%@ in regex patterns resource file at %@"
                    "\nmissing valid pattern or format entry",patternKey,url,nil],
                    NSLocalizedDescriptionKey,
                        nil]];
        }
        return nil;
    }
    //  get the search field
    NSString * search = [infos objectForKey:@"search"];
    NSMutableIndexSet * MIS = nil;
    if (search.length) {
        //  This is a basic RE, with no reference to another RE
        //  get the flags
        NSUInteger flags = [[infos objectForKey:@"flags"] unsignedIntegerValue];
        //  create the RE object
        if ((result = [[self alloc] initWithSearchPattern:search options:flags error:errorRef])) {
            //  creation was a success, record the result
            [ICURegEx_by_key_cache setObject:result forKey:patternKey];
            //  Now, recording the capturing group names
            //  Actually, great care should be taken because named groups are not supported by default
            //  by the ICU regex engine
            NSMutableArray * names = [NSMutableArray array];
            //  The "." name is a convenient shortcut for the patternKey
            //  It is replaced by the actual name here
            for (NSString * name in [infos objectForKey:@"group names"]) {
                [names addObject:([name isEqual:@"."]?patternKey:name)];
            }
            //  record the group names
            result.groupNames = names.copy;
            //  record the replacement pattern
            result.replacementPattern = [infos objectForKey:@"replace"];
            MIS = [NSMutableIndexSet indexSet];
            for (NSNumber * N in [infos objectForKey:@"unescape comments"]) {
                [MIS addIndex:N.unsignedIntegerValue];
            }
            if (MIS.count) {
                result.commentGroupIndexes = MIS.copy;
            }
            return result;
        } else if (errorRef && !*errorRef) {
            //  creation failure, setting the error on return
            *errorRef = [NSError errorWithDomain:@"ICURegEx" code:-4
                userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                    [NSString stringWithFormat:@"Bad format entry for key:"
                    @"%@ in regex patterns resource file at %@"
                    "\nmissing valid pattern or format entry",patternKey,url,nil],
                    NSLocalizedDescriptionKey,
                        nil]];
            return nil;
        } else {
            return nil;
        }
    } else {
        //  This RE may contain references to other REs
        NSArray * argv = [infos objectForKey:@"argv"];
        ICURegEx * placeholderRE = [ICURegEx regExForKey:iTM2RegExpCommandKey error:errorRef];
        if (!placeholderRE) {
            if (errorRef) {
                *errorRef = [NSError errorWithDomain:@"ICURegEx" code:-4
                    userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                        [NSString stringWithFormat:@"Missing iTM2Foundation regex for pattern key:"
                        @"%@",iTM2RegExpCommandKey,nil],
                        NSLocalizedDescriptionKey,
                            nil]];
                return nil;
            } else {
                return nil;
            }
        }
        placeholderRE.inputString = [infos objectForKey:@"format"];
        ASSERT_INCONSISTENCY4iTM3(placeholderRE.inputString.length>ZER0);
        NSRange copyR = iTM3MakeRange(ZER0,ZER0);
        NSRange R = iTM3MakeRange(ZER0,ZER0);
        NSMutableArray * MRA = [NSMutableArray array];
        NSUInteger count = ZER0;// for the count of RE placeholders ('⌘' but not '⌘⌘')
        NSString * S = nil;
        while (placeholderRE.nextMatch) {
            R = placeholderRE.rangeOfMatch;
            copyR.length = R.location - copyR.location;
            S = [placeholderRE.inputString substringWithRange:copyR];
            [MRA addObject:S];
            S = placeholderRE.replacementString;
            [MRA addObject:S];
            //  If this is a RE placeholder, increment the count
            count += S.length?ZER0:1;
            copyR.location = iTM3MaxRange(R);
            copyR.length = ZER0;
        }
        copyR.length = placeholderRE.inputString.length - copyR.location;
        S = [placeholderRE.inputString substringWithRange:copyR];
        [MRA addObject:S];
        //  Now MRA contains an even number of strings
        //  an alternation between normal strings, RE placeholder replacements and placeholders
        if (count == argv.count) {
            NSEnumerator * E = [MRA objectEnumerator];
            NSEnumerator * EE = [argv objectEnumerator];
            MRA = [NSMutableArray array];
            NSMutableArray * GNs = [NSMutableArray array];
            NSMutableArray * longGNs = [NSMutableArray array];
            MIS = [NSMutableIndexSet indexSet];
            NSMutableIndexSet * mis = [NSMutableIndexSet indexSet];
            NSUInteger groupCommentOff7 = ZER0;
            NSString * SS = nil;
            while ((S = E.nextObject)) {
                [MRA addObject:S];
                if ((S = E.nextObject)) {
                    // this is either a RE placeholder or a placeholder replacement
                    if (S.length) {
                        //  This is a placeholder replacement
                        [MRA addObject:S];
                    } else if ((SS = [EE nextObject])) {
                        //  This is a RE placeholder
                        ICURegEx * RE = [self regExForKey:SS inBundle:bundle error:nil];
                        if (RE) {
                            [MRA addObject:RE.searchPattern];
                            if (RE.groupNames) {
                                NSArray * RA = RE.groupNames;
                                [GNs addObjectsFromArray:RA]; 
                                //  Is there a conflict?
                                RA = [RA valueForKeyPath:@"mutableCopy"];// creates an array of mutable copies of group names
                                [RA makeObjectsPerformSelector:@selector(prependPathComponent4ICURegEx:) withObject:SS];
                                [longGNs addObjectsFromArray:RA];                                
                            } else {
                                GNs = longGNs = nil;
                            }
                            mis = RE.commentGroupIndexes.mutableCopy;
                            [mis shiftIndexesStartingAtIndex:mis.firstIndex by:groupCommentOff7];
                            [MIS addIndexes:mis];
                            [RE matchString:@"X"];
                            groupCommentOff7 += RE.numberOfCaptureGroups;
                        } else {
                            [MRA addObject:@"ERROR"];
                        }
                    } else {
                        RAISE_INCONSISTENCY4iTM3(@"The count of RE placeholders is buggy");
                    }
                } else {
                    break;
                }
            }
            search = [MRA componentsJoinedByString:@""];
            if ([ICURegEx isValidPattern:search options:ZER0 error:errorRef]) {
                NSUInteger flags = [[infos objectForKey:@"flags"] unsignedIntegerValue];
                if ((result = [[self alloc] initWithSearchPattern:search options:flags error:errorRef])) {
                    [ICURegEx_by_key_cache setObject:result forKey:patternKey];
                    NSSet * set = [NSSet setWithArray:GNs];
                    result.groupNames = set.count == GNs.count? GNs:longGNs;
                    result.commentGroupIndexes = MIS.copy;
                    return result;
                } else if (errorRef) {
                    *errorRef = [NSError errorWithDomain:@"ICURegEx" code:-5
                        userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                            [NSString stringWithFormat:@"Bad format entry for pattern:%@ in regex patterns resource file at %@.",search,url,nil],
                            NSLocalizedDescriptionKey,
                                nil]];
                    return nil;
                } else {
                    return nil;
                }
            } else if (errorRef && !*errorRef) {
                *errorRef = [NSError errorWithDomain:@"ICURegEx" code:-2
                    userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                        [NSString stringWithFormat:@"Bad format entry for key:%@ in regex patterns resource file at %@.",patternKey,url,nil],
                        NSLocalizedDescriptionKey,
                            nil]];
                return nil;
            } else {
                return nil;
            }
        } else if (errorRef) {
            *errorRef = [NSError errorWithDomain:@"ICURegEx" code:-3
                userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                    [NSString stringWithFormat:@"Bad format entry for key:"
                    @"%@ in regex patterns resource file at %@"
                    "\nargv count must agree with the number of \"\%s\" in the format entry",patternKey,url,nil],
                    NSLocalizedDescriptionKey,
                        nil]];
            return nil;
        } else {
            return nil;
        }
    }
}
+ (id)regExWithSearchPattern:(NSString *)pattern error:(NSError **)errorRef;
{
	return [self regExWithSearchPattern:pattern option:ZER0 error:errorRef];
}
+ (id)regExWithSearchPattern:(NSString *)pattern option:(NSUInteger)flags error:(NSError **)errorRef;
{
    NSParameterAssert(pattern);
    NSNumber * N = [NSNumber numberWithUnsignedInteger:flags];
    NSMutableDictionary * MD = [ICURegEx_by_pattern_cache objectForKey:pattern];
	id result = [MD objectForKey:N];
	if (result) {
		return result;
	}
	if ((result = [[[self alloc] initWithSearchPattern:pattern options:flags error:errorRef] autorelease])) {
        if (!MD) {
            MD = [NSMutableDictionary dictionary];
            [ICURegEx_by_pattern_cache setObject:MD forKey:pattern];
        }
		[MD setObject:result forKey:N];
		return result;
	}
	return nil;
}
+ (BOOL)isValidPattern:(NSString *)pattern options:(NSUInteger)flags error:(NSError **)errorRef;
{
    NSParameterAssert(pattern);
	// create the pattern
	UErrorCode status = U_ZERO_ERROR;
	UChar * buffer = (UChar *)CFStringGetCharactersPtr((CFStringRef)pattern);
	if (!buffer) {
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
	unsigned int theFlags = flags;
	RegexPattern * regexPattern = RegexPattern::compile(patString,theFlags,pe,status);
	delete regexPattern;
	regexPattern = nil;
	if (U_FAILURE(status)) {
		if (errorRef) {
			NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
				[[self class] errorDescriptionForStatus:status],NSLocalizedDescriptionKey,
					nil];
			NSNumber * N;
			if (pe.line>0) {
				N = [NSNumber numberWithInt:pe.line-1];
				[dict setObject:N forKey:@"line"];
			}
			if (pe.offset>=0) {
				N = [NSNumber numberWithInt:pe.offset];
				[dict setObject:N forKey:(pe.line>0?@"column":@"offset")];
			}
			NSString * context;
			UnicodeString unicodeString;
			int length;
			if ((length = u_strlen(pe.preContext))) {
				context = (NSString *)CFStringCreateWithCharacters(kCFAllocatorDefault,pe.preContext,length);
				[dict setObject:context forKey:@"pre context"];
				[context release];
			}
			if ((length = u_strlen(pe.postContext))) {
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
- (id)initWithSearchPattern:(NSString *)pattern options:(NSUInteger)flags error:(NSError **)errorRef;
{
	// allocate iVars
	ICURegExIVars * iVars = [[ICURegExIVars allocWithZone:[self zone]] init];
	if (!iVars) {
		if (errorRef) {
			NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:
				@"Can't allocate memory.",NSLocalizedDescriptionKey,
					nil];
			*errorRef = [NSError errorWithDomain:@"ICURegEx" code:-1 userInfo:dict];
		}
		[self dealloc];
		return nil;
	}
	// then create the pattern
	iVars.status = U_ZERO_ERROR;
    iVars.pattern = [pattern copy];
	UChar * buffer = (UChar *)CFStringGetCharactersPtr((CFStringRef)pattern);
	if (!buffer)
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
	unsigned int theFlags = flags;
    UErrorCode status = U_ZERO_ERROR;
	iVars.regexPattern = RegexPattern::compile(patString,theFlags,pe,status);
    iVars.status = status;
	if (U_FAILURE(status)) {
		if (errorRef) {
			NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
				[[self class] errorDescriptionForStatus:iVars.status],NSLocalizedDescriptionKey,
					nil];
			NSNumber * N;
			if (pe.line>0) {
				N = [NSNumber numberWithInt:pe.line-1];
				[dict setObject:N forKey:@"line"];
			}
			if (pe.offset>=0) {
				N = [NSNumber numberWithInt:pe.offset];
				[dict setObject:N forKey:(pe.line>0?@"column":@"offset")];
			}
			NSString * context;
			UnicodeString unicodeString;
			int length;
			if ((length = u_strlen(pe.preContext))) {
				context = (NSString *)CFStringCreateWithCharacters(kCFAllocatorDefault,pe.preContext,length);
				[dict setObject:context forKey:@"pre context"];
				[context release];
			}
			if ((length = u_strlen(pe.postContext))) {
				context = (NSString *)CFStringCreateWithCharacters(kCFAllocatorDefault,pe.postContext,length);
				[dict setObject:context forKey:@"post context"];
				[context release];
			}
			*errorRef = [NSError errorWithDomain:@"ICURegEx" code:-1 userInfo:dict];
		}
		return nil;
	}
	if (NULL==iVars.regexPattern) {
		if (errorRef) {
			NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:
				@"Can't create regex pattern.",NSLocalizedDescriptionKey,
					nil];
			*errorRef = [NSError errorWithDomain:@"ICURegEx" code:iVars.status userInfo:dict];
		}
		return nil;
	}
	if ((self = [super init])) {
		_iVars = iVars;
	}
	return self;
}
- (id)copyWithZone:(NSZone *)zone;
{
	ICURegEx * result = [[ICURegEx allocWithZone:zone] init];
	if (result) {
		ICURegExIVars * iVars = [[ICURegExIVars allocWithZone:zone] init];
		if (iVars) {
			if (_IVARS.replacement) {
				iVars.replacement = [_IVARS.replacement retain];
			}
			iVars.regexPattern = _IVARS.regexPattern->clone();
		}
		result->_iVars = iVars;
	}
	return result;
}
- (NSError *)error;
{
	return _IVARS.error;
}
+ (NSString *)errorDescriptionForStatus:(NSInteger)status;
{
#if 1
	switch(status) {
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
		return @"An internal error (Break Iterator bug) was detected.";
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
     * The error codes in the range 0x10300-0x103ff are reserved for regular expression related errors
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
- (NSInteger)status;
{
	return _IVARS.status;
}
- (RegexPattern *)regexPattern;
{
	return _IVARS.regexPattern;
}
- (RegexMatcher *)regexMatcher;
{
    if (!_IVARS.regexMatcher) {
        if (_IVARS.uString) {
            UErrorCode status = U_ZERO_ERROR;
            _IVARS.regexMatcher = _IVARS.regexPattern->matcher(*(_IVARS.uString),status);
            _IVARS.status = status;
            if (U_FAILURE(_IVARS.status)) {
                NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:
                        [[self class] errorDescriptionForStatus:_IVARS.status],NSLocalizedDescriptionKey,
                        [NSNumber numberWithInt:_IVARS.status],@"status",
                            nil];
                _IVARS.error = [[NSError errorWithDomain:@"ICURegEx" code:-1 userInfo:dict] retain];
            } else if (!_IVARS.regexMatcher) {
                NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:
                    @"Can't create regex matcher.",NSLocalizedDescriptionKey,
                        nil];
                _IVARS.error = [NSError errorWithDomain:@"ICURegEx" code:_IVARS.status userInfo:dict];
            }
        } else {
            NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:
                @"Can't create regex matcher because no string available.",NSLocalizedDescriptionKey,
                    nil];
            _IVARS.error = [NSError errorWithDomain:@"ICURegEx" code:-6 userInfo:dict];
        }
    }
	return _IVARS.regexMatcher;
}
- (NSString *)inputString;
{
	return _IVARS.string;
}
- (void)setInputString:(NSString *)argument;
{
    if(!argument || [argument isKindOfClass:[NSString class]]) {
        [self setInputString:argument range:iTM3MakeRange(ZER0,argument.length)];
    } else {
        [self setInputString:@"" range:iTM3MakeRange(ZER0,ZER0)];
    }
}
- (BOOL)setInputString:(NSString *)argument range:(NSRange)range;
{
    if(!argument || [argument isKindOfClass:[NSString class]]) {
        _IVARS.status = U_ZERO_ERROR;
        _IVARS.error = nil;
        _IVARS.string = argument;
        delete _IVARS.regexMatcher;
        _IVARS.regexMatcher = nil;
        if (_IVARS.uString) {
            delete _IVARS.uString;
            _IVARS.uString = nil;
        }
        NSUInteger length = [argument length];
        if (range.location < length) {
            if (iTM3MaxRange(range)>length) {
                range.length = length - range.location;
            }
            //  grow the range to take into account surrogate pairs
            range = [argument rangeOfComposedCharacterSequencesForRange:range];
            _IVARS.stringOffset = range.location;
            _IVARS.stringLength = range.length;
            if (_IVARS.string) {
                UChar * buffer = (UChar *)CFStringGetCharactersPtr((CFStringRef)argument);
                if (!buffer) {
                    NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(
#if __BIG_ENDIAN__
                    kCFStringEncodingUTF16BE
#elif __LITTLE_ENDIAN__
                    kCFStringEncodingUTF16LE
#endif
                    );
                    buffer = (UChar *)[argument cStringUsingEncoding:encoding];
                }
                _IVARS.uString = new UnicodeString(FALSE, buffer+range.location, range.length);// the string to search is big
                _IVARS.status = U_ZERO_ERROR;
            }
        } else if (length) {
            NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:
                    @"The given range is out of the bounds of the input string.",NSLocalizedDescriptionKey,
                        nil];
            _IVARS.error = [[NSError errorWithDomain:@"ICURegEx" code:-4 userInfo:dict] retain];
            return NO;
        }
        return YES;
    }
    return NO;
}
- (NSString *)searchPattern;
{
	return _IVARS.pattern;
}
- (NSString *)replacementPattern;
{
	return _IVARS.replacement;
}
- (void)setReplacementPattern:(NSString *)argument;
{
	_IVARS.replacement = argument;
	return;
}

static const UChar BACKSLASH  = 0x005c;
static const UChar DOLLARSIGN = 0x0024;
static const UChar BGROUP     = 0x007b;
static const UChar EGROUP     = 0x007d;

U_CDECL_BEGIN
static UChar U_CALLCONV
ICURegEx_charAt(int32_t offset, void *context) {
    return (UChar)CFStringGetCharacterFromInlineBuffer((CFStringInlineBuffer *)context, offset);
}
U_CDECL_END

- (NSString *)replacementString;
{
	[_IVARS.error autorelease];
	_IVARS.error = nil;
	_IVARS.status = U_ZERO_ERROR;
	if (!_IVARS.replacement) {
		_IVARS.status = U_REGEX_ERROR_START;
		NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:
				[[self class] errorDescriptionForStatus:_IVARS.status],NSLocalizedDescriptionKey,
				[NSNumber numberWithInt:-1],@"status",
					nil];
		_IVARS.error = [[NSError errorWithDomain:@"ICURegEx" code:-1 userInfo:dict] retain];
		return nil;
	}
    int32_t  patternLength = [_IVARS.replacement length];
    CFStringInlineBuffer patternBuffer;
    CFStringInitInlineBuffer((CFStringRef)(_IVARS.replacement),&patternBuffer,CFRangeMake(ZER0,patternLength));
	UnicodeString dest = UnicodeString();
	UErrorCode status = U_ZERO_ERROR;
	// stolen from rematch.cpp
	// "CUT HERE"
	// scan the replacement text, looking for substitutions ($n) and \escapes.
    //  TODO:  optimize this loop by efficiently scanning for '$' or '\',
    //         move entire ranges not containing substitutions.
    int32_t  charIdx = ZER0;
    while (charIdx<patternLength) {
        UChar  c = ICURegEx_charAt(charIdx++,&patternBuffer);
        UChar32 c32 = (UChar32)0xFFFFFFFF;
        if (c == BACKSLASH) {
            // Backslash Escape.  Copy the following char out without further checks.
            //                    Note:  Surrogate pairs don't need any special handling
            //                           The second half wont be a '$' or a '\', and
            //                           will move to the dest normally on the next
            //                           loop iteration.
            if (charIdx >= patternLength) {
                break;
            }
            c = ICURegEx_charAt(charIdx++,&patternBuffer);

            if (c==0x55/*U*/ || c==0x75/*u*/) {
                // We have a \udddd or \Udddddddd escape sequence.
                c32 = u_unescapeAt(ICURegEx_charAt, &charIdx, patternLength, (void*)(&patternBuffer));
                if (c32 != (UChar32)0xFFFFFFFF) {
                    dest.append(c32);
                    // TODO:  Report errors for mal-formed \u escapes?
                    //        As this is, the original sequence is output, which may be OK.
                    continue;
                }
            }

            // Plain backslash escape.  Just put out the escaped character.
            dest.append(c);
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


        if (charIdx < patternLength) {
            //  try to catch a capture group number
            //  this is a sequence of digits possibly enclosed between group delimiters
            int32_t idx = charIdx;
            BOOL canBGROUP = YES;
            BOOL mustEGROUP = NO;
            int32_t groupNumber  = ZER0;
            int32_t numberOfDigitsRead = ZER0;
            int32_t max = _IVARS.regexPattern->fMaxCaptureDigits;
            UChar c1 = 0xffff;
            UChar c2 = 0xffff;
            
            do {
                c1=ICURegEx_charAt(idx,&patternBuffer);
                //  reading surrogate pairs
                if (CFStringIsSurrogateHighCharacter(c1)) {
                    if ((idx+1<patternLength) && CFStringIsSurrogateLowCharacter(c2=ICURegEx_charAt(idx+1,&patternBuffer))) {
                        c32=CFStringGetLongCharacterForSurrogatePair(c1, c2);
                        ++idx;
                    } else {
                        numberOfDigitsRead = ZER0;
                        break;
                    }
                } else if (CFStringIsSurrogateLowCharacter(c1)) {
                    numberOfDigitsRead = ZER0;
                    break;
                }
                if (canBGROUP && (c1==BGROUP)) {
                    mustEGROUP = YES;
                } else if (mustEGROUP && (c1==EGROUP)) {
                    //  the group number is possibly found
                    mustEGROUP = NO;
                    ++idx;
                    break;
                } else if (u_isdigit(c1) && max--) {
                    groupNumber = groupNumber*10 + u_charDigitValue(c1);
                    ++numberOfDigitsRead;
                } else if (mustEGROUP) {
                    //  missing EGROUP
                    numberOfDigitsRead = ZER0;
                    break;
                } else {
                    //  We have enough digits
                    break;
                }
                canBGROUP = NO;
            } while (++idx<patternLength);
            
            if (mustEGROUP || (numberOfDigitsRead == ZER0)) {
                // The $ didn't introduce a group number at all.
                // Treat it as just part of the substitution text.
                dest.append(DOLLARSIGN);
                continue;
            }

            // Finally, append the capture group data to the destination.
#if 0
            dest.append(group(groupNumber, status));
            _IVARS.status = status;
            if (U_FAILURE(status)) {
                // Can fail if group number is out of range.
                break;
            }
#else
            dest.append(_IVARS.regexMatcher->group(groupNumber, status));
            _IVARS.status = status;
            if (U_FAILURE(status)) {
                // Can fail if group number is out of range.
                NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:
                        [[self class] errorDescriptionForStatus:status],NSLocalizedDescriptionKey,
                        [NSNumber numberWithInt:status],@"status",
                            nil];
                _IVARS.error = [[NSError errorWithDomain:@"ICURegEx" code:-1 userInfo:dict] retain];
                return nil;
            }
            //  advance the scanner location
            charIdx = idx;
#endif
        } else {
            dest.append(DOLLARSIGN);
            break;
        }
    }
	return [NSString stringWithUnicodeString4ICURE:dest];
}
- (void)forget;
{
	self.inputString = nil;
	return;
}
- (NSArray *)groupNames;
{
	return _IVARS.groupNames;
}
- (void)setGroupNames:(NSArray *)argument;
{
	[_IVARS.groupNames autorelease];
	_IVARS.groupNames = [argument copy];
	return;
}
- (NSIndexSet *)commentGroupIndexes;
{
	return _IVARS.commentGroupIndexes;
}
- (void)setCommentGroupIndexes:(NSIndexSet *)argument;
{
	[_IVARS.commentGroupIndexes autorelease];
	_IVARS.commentGroupIndexes = [argument copy];
	return;
}
- (BOOL)matchString:(NSString *)string;
{
	[self setInputString:string];
	BOOL result = [self nextMatch];
	return result;
}
- (NSString *)stringByMatchingString:(NSString *)string replacementPattern:(NSString *)replacement;
{
	if ([self matchString:string]) {
		self.replacementPattern = replacement;
		NSString * replacement = self.replacementString;
		[self forget];
		return replacement;
	}
	[self forget];
	return nil;
}
- (BOOL)matchesAtIndex:(NSInteger)idx extendToTheEnd:(BOOL)yorn;
{
    int index = idx;
	[_IVARS.error autorelease];
	_IVARS.error = nil;
	_IVARS.status = U_ZERO_ERROR;
    UErrorCode status = U_ZERO_ERROR;
    RegexMatcher * regexMatcher = NULL;
    if ((regexMatcher = self.regexMatcher)) {
        if (yorn && regexMatcher->matches(index,status)
                ||  regexMatcher->lookingAt(index,status)) {
            return YES;
        }
        _IVARS.status = status;
        if (U_FAILURE(_IVARS.status)) {
            NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:
                    [[self class] errorDescriptionForStatus:_IVARS.status],NSLocalizedDescriptionKey,
                    [NSNumber numberWithInt:_IVARS.status],@"status",
                        nil];
            _IVARS.error = [[NSError errorWithDomain:@"ICURegEx" code:-1 userInfo:dict] retain];
        }
    }
	return NO;
}
- (BOOL)nextMatch;
{
    RegexMatcher * regexMatcher = NULL;
	_IVARS.error = nil;
	_IVARS.status = U_ZERO_ERROR;
    return (regexMatcher = self.regexMatcher) && regexMatcher->find() && [self rangeOfCaptureGroupAtIndex:ZER0].length>ZER0;// should the second part be necessary?
}
- (BOOL)nextMatchAfterIndex:(NSInteger)idx;
{
    int index = idx;
    RegexMatcher * regexMatcher = NULL;
	_IVARS.error = nil;
	_IVARS.status = U_ZERO_ERROR;
    UErrorCode status = U_ZERO_ERROR;
    if ((regexMatcher = self.regexMatcher)) {
        if (_IVARS.regexMatcher->find(index,status)) {
            return [self rangeOfCaptureGroupAtIndex:ZER0].length>ZER0;
        }
        _IVARS.status = status;
        if (U_FAILURE(_IVARS.status)) {
            NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:
                    [[self class] errorDescriptionForStatus:_IVARS.status],NSLocalizedDescriptionKey,
                    [NSNumber numberWithInt:_IVARS.status],@"status",
                        nil];
            _IVARS.error = [[NSError errorWithDomain:@"ICURegEx" code:-1 userInfo:dict] retain];
        }
    }
	return NO;
}
- (NSRange)rangeOfMatch;
{
	return [self rangeOfCaptureGroupAtIndex:ZER0];
}
- (NSString *)substringOfMatch;
{
	return [self substringOfCaptureGroupAtIndex:ZER0];
}
- (NSUInteger)numberOfCaptureGroups;
{
	if (!_IVARS.regexMatcher) {
		NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:
				@"No regex matcher: did you give an input string?",NSLocalizedDescriptionKey,
				[NSNumber numberWithInt:_IVARS.status],@"status",
					nil];
		_IVARS.error = [[NSError errorWithDomain:@"ICURegEx" code:-1 userInfo:dict] retain];
		return ZER0;
	}
	return _IVARS.regexMatcher->groupCount();
}
//#include "uvectr32.h"
- (NSRange)rangeOfCaptureGroupAtIndex:(NSUInteger)index;
{
	_IVARS.error = nil;
	_IVARS.status = U_ZERO_ERROR;
    UErrorCode status = U_ZERO_ERROR;
	if (!_IVARS.regexMatcher) {
		NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:
				@"No regex matcher: did you give an input string?",NSLocalizedDescriptionKey,
				[NSNumber numberWithInt:_IVARS.status],@"status",
					nil];
		_IVARS.error = [[NSError errorWithDomain:@"ICURegEx" code:-1 userInfo:dict] retain];
		return iTM3MakeRange(NSNotFound,ZER0);
	}
	int start = _IVARS.regexMatcher->start(index,status);
    _IVARS.status = status;
	if (U_FAILURE(_IVARS.status)) {
		NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:
				[[self class] errorDescriptionForStatus:_IVARS.status],NSLocalizedDescriptionKey,
				[NSNumber numberWithInt:_IVARS.status],@"status",
					nil];
		_IVARS.error = [[NSError errorWithDomain:@"ICURegEx" code:-1 userInfo:dict] retain];
		return iTM3MakeRange(NSNotFound,ZER0);
	}
	int end = _IVARS.regexMatcher->end(index,status);
    _IVARS.status = status;
	if (U_FAILURE(_IVARS.status)) {
		NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:
				[[self class] errorDescriptionForStatus:_IVARS.status],NSLocalizedDescriptionKey,
				[NSNumber numberWithInt:_IVARS.status],@"status",
					nil];
		_IVARS.error = [[NSError errorWithDomain:@"ICURegEx" code:-1 userInfo:dict] retain];
		return iTM3MakeRange(NSNotFound,ZER0);
	}
	return iTM3MakeRange(start + _IVARS.stringOffset, end-start);
}
- (NSString *)substringOfCaptureGroupAtIndex:(NSUInteger)index;
{
	NSRange R = [self rangeOfCaptureGroupAtIndex:index];
    if (R.length) {
        if ([self.commentGroupIndexes containsIndex:index]) {
            ICURegEx * RE = [ICURegEx regExForKey:@"%" error:NULL];
            NSMutableString * MS = [[_IVARS.string substringWithRange:R] mutableCopy];
            [MS replaceOccurrencesOfICURegEx:RE error:NULL];
            return MS.copy;
        }
        return [_IVARS.string substringWithRange:R];
    }
	return @"";
}
- (NSRange)rangeOfCaptureGroupWithName:(NSString *)name;
{
    //  Take into account groups with the same name
    NSUInteger i = self.groupNames.count;
    NSString * groupName = nil;
    while (i--) {
        groupName = [self.groupNames objectAtIndex:i];
        if ([name isEqual:groupName]) {
groupName_found: {
                NSRange R = [self rangeOfCaptureGroupAtIndex:i+1];
                if (R.length) {
                    return R;
                }
            }
            return iTM3MakeRange(NSNotFound,ZER0);
        }
    }
    //  No group was found with the given name, try to relax to the last path component only.
    i = self.groupNames.count;
    while (i--) {
        groupName = [self.groupNames objectAtIndex:i];
        if  ([name isEqual:groupName.lastPathComponent]) {
            goto groupName_found;
        }
    }
    return iTM3MakeRange(NSNotFound,ZER0);
}
- (NSString *)substringOfCaptureGroupWithName:(NSString *)name;
{
    //  Take into account groups with the same name
    NSUInteger i = self.groupNames.count;
    NSString * groupName = nil;
    while (i--) {
        groupName = [self.groupNames objectAtIndex:i];
        if ([name isEqual:groupName]) {
groupName_found: {
                NSRange R = [self rangeOfCaptureGroupAtIndex:i+1];
                if (R.length) {
                    if ([self.commentGroupIndexes containsIndex:i+1]) {
                        ICURegEx * RE = [ICURegEx regExForKey:@"%" error:NULL];
                        NSMutableString * MS = [[_IVARS.string substringWithRange:R] mutableCopy];
                        NSError * ROR = nil;
                        [MS replaceOccurrencesOfICURegEx:RE error:&ROR ];
                        return MS.copy;
                    }
                    return [_IVARS.string substringWithRange:R];
                }
            }
            return @"";
        }
    }
    //  No group was found with the given name, try to relax to the last path component only.
    i = self.groupNames.count;
    while (i--) {
        groupName = [self.groupNames objectAtIndex:i];
        if  ([name isEqual:groupName.lastPathComponent]) {
            goto groupName_found;
        }
    }
    return @"";
}
- (NSArray *)componentsBySplitting;
{
	[self reset];
	NSMutableArray * result = [NSMutableArray array];
#   define input (_IVARS.uString)
#   define maxNumberOfComponents UINT_MAX
	unsigned firstUnrecorded = ZER0;
    if (!input) {
        return nil;
    }
	const UChar * buffer = input->getBuffer();// read only buffer
	CFStringRef component = nil;
    //
    // Loop through the input text, searching for the delimiter pattern
    //
    while (self.nextMatch) {
		// We found another delimiter.  Move everything from where we started looking
		//  up until the start of the delimiter into the next output string.
		// we create a UnicodeString for each component.
		NSRange matchRange = [self rangeOfMatch];
		component = CFStringCreateWithCharacters(kCFAllocatorDefault,buffer+firstUnrecorded,matchRange.location - firstUnrecorded);// create a UTF16 string with the buffer
		[result addObject:(NSString *)component];
		CFRelease(component);
		component = nil;
		firstUnrecorded = iTM3MaxRange(matchRange);
		// If the delimiter pattern has capturing parentheses, the captured
		//  text goes out into the next n destination strings.
		unsigned numberOfGroups = self.numberOfCaptureGroups;
		unsigned groupNumber = ZER0;
		while (groupNumber++ < numberOfGroups) {
			NSRange groupRange = [self rangeOfCaptureGroupAtIndex:groupNumber];
			component = CFStringCreateWithCharacters(kCFAllocatorDefault,buffer+groupRange.location, groupRange.length);
			[result addObject:(NSString *)component];
			CFRelease(component);
			component = nil;
		}
	}
	unsigned remainingLength = input->length()-firstUnrecorded;
	if (remainingLength > ZER0) {
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
	if (!_IVARS.regexMatcher)
	{
		NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:
				@"No regex matcher: did you give an input string?",NSLocalizedDescriptionKey,
				[NSNumber numberWithInt:_IVARS.status],@"status",
					nil];
		_IVARS.error = [[NSError errorWithDomain:@"ICURegEx" code:-1 userInfo:dict] retain];
		return NO;
	}
	_IVARS.regexMatcher->reset(*_IVARS.uString);
	return YES;
}
- (BOOL)resetAtIndex:(NSInteger)index;
{
	if (!_IVARS.regexMatcher) {
		NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:
				@"No regex matcher: did you give an input string?",NSLocalizedDescriptionKey,
				[NSNumber numberWithInt:_IVARS.status],@"status",
					nil];
		_IVARS.error = [[NSError errorWithDomain:@"ICURegEx" code:-1 userInfo:dict] retain];
		return NO;
	}
	NSParameterAssert(((NSUInteger)index<_IVARS.stringOffset));
	[_IVARS.error autorelease];
	_IVARS.error = nil;
	_IVARS.status = U_ZERO_ERROR;
    UErrorCode status = U_ZERO_ERROR;
	_IVARS.regexMatcher->reset(index,status);
    _IVARS.status = status;
	if (U_FAILURE(_IVARS.status)) {
		NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:
				[[self class] errorDescriptionForStatus:_IVARS.status],NSLocalizedDescriptionKey,
				[NSNumber numberWithInt:_IVARS.status],@"status",
					nil];
		_IVARS.error = [[NSError errorWithDomain:@"ICURegEx" code:-1 userInfo:dict] retain];
		return NO;
	}
	return _IVARS.error!=nil;
}
- (void)displayMatchResult;
{
	if (!_IVARS) {
		NSLog(@"Nothing to display");
		return;
	}
	NSLog(@"===> Match result:");
	NSLog(@"search pattern:<%@>",self.searchPattern);
	NSLog(@"input string:<%@>",self.inputString);
	NSLog(@"input range:(%u,%u)",_IVARS.stringOffset,_IVARS.stringLength);
	unsigned i = ZER0;
    NSLog(@"match %i:<%@>(%@)",i,[self substringOfCaptureGroupAtIndex:i],NSStringFromRange([self rangeOfCaptureGroupAtIndex:i]));
    while (++i<=self.numberOfCaptureGroups) {
        if (i <= self.groupNames.count ) {
            NSLog(@"group %i \"%@\" :<%@>",i,[self.groupNames objectAtIndex:i-1],[self substringOfCaptureGroupAtIndex:i]);
        } else {
            NSLog(@"group %i:<%@>",i,[self substringOfCaptureGroupAtIndex:i]);
        }
	}
	NSLog(@"<=== End of Match result");
}
- (NSString *)description;
{
    return [NSString stringWithFormat:@"<%#x\nsearch:%@\nreplace:%@\nreplace:%@,\ngroup names:%@,\ncomment group indexes:%@,\nerror:%@>",
        self,
        self.searchPattern,
        self.replacementPattern, 
        self.replacementString, 
        self.groupNames, 
        self.commentGroupIndexes,
        self.error];
}
@end

@implementation NSString (NSStringICUREAdditions)

+(NSString *)stringWithUnicodeString4ICURE:(UnicodeString)unicodeString;
{
	NSString * result = nil;
	const UChar * buffer = unicodeString.getBuffer();
	if (buffer) {
		int32_t length = unicodeString.length();
        NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(
#if __BIG_ENDIAN__
        kCFStringEncodingUTF16BE
#elif __LITTLE_ENDIAN__
        kCFStringEncodingUTF16LE
#endif
        );
		result = [[[NSString alloc] initWithBytes:buffer length:length*sizeof(UChar) encoding:encoding] autorelease];
	}
	return result;
}

-(UnicodeString)unicodeString4ICURE;
{
	UChar * buffer = (UChar *)CFStringGetCharactersPtr((CFStringRef)self);
	if (!buffer) {
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
	NSString * copy = [NSString stringWithUnicodeString4ICURE:unicodeString];
	NSLog(@"Conversion test:%@<->%@, %@",self,copy, ([self isEqual:copy]?@"SUCCESS":@"FAILURE"));
	#endif
	return unicodeString;	
}

- (NSString *)stringByEscapingICUREControlCharacters;
{
	// see http://www.icu-project.org/userguide/regexp.html
	// "Characters that must be quoted to be treated as literals are * ? + [ ( ) { } ^ $ | \ . /"
	NSMutableString * MS = [NSMutableString stringWithString:self];
	[MS replaceOccurrencesOfString:@"\\" withString:@"\\\\" options:NULL range:iTM3MakeRange(ZER0,[MS length])];
	[MS replaceOccurrencesOfString:@"*" withString:@"\\*" options:NULL range:iTM3MakeRange(ZER0,[MS length])];
	[MS replaceOccurrencesOfString:@"?" withString:@"\\?" options:NULL range:iTM3MakeRange(ZER0,[MS length])];
	[MS replaceOccurrencesOfString:@"+" withString:@"\\+" options:NULL range:iTM3MakeRange(ZER0,[MS length])];
	[MS replaceOccurrencesOfString:@"[" withString:@"\\[" options:NULL range:iTM3MakeRange(ZER0,[MS length])];
	[MS replaceOccurrencesOfString:@"(" withString:@"\\(" options:NULL range:iTM3MakeRange(ZER0,[MS length])];
	[MS replaceOccurrencesOfString:@")" withString:@"\\)" options:NULL range:iTM3MakeRange(ZER0,[MS length])];
	[MS replaceOccurrencesOfString:@"{" withString:@"\\{" options:NULL range:iTM3MakeRange(ZER0,[MS length])];
	[MS replaceOccurrencesOfString:@"}" withString:@"\\}" options:NULL range:iTM3MakeRange(ZER0,[MS length])];
	[MS replaceOccurrencesOfString:@"^" withString:@"\\^" options:NULL range:iTM3MakeRange(ZER0,[MS length])];
	[MS replaceOccurrencesOfString:@"$" withString:@"\\$" options:NULL range:iTM3MakeRange(ZER0,[MS length])];
	[MS replaceOccurrencesOfString:@"|" withString:@"\\|" options:NULL range:iTM3MakeRange(ZER0,[MS length])];
	[MS replaceOccurrencesOfString:@"." withString:@"\\." options:NULL range:iTM3MakeRange(ZER0,[MS length])];
	[MS replaceOccurrencesOfString:@"/" withString:@"\\/" options:NULL range:iTM3MakeRange(ZER0,[MS length])];
	return MS;
}

- (NSRange)rangeOfICUREPattern:(NSString *)aPattern error:(NSError **)errorRef;
{
	return [self rangeOfICUREPattern:aPattern options:ZER0 error:errorRef];
}

- (NSRange)rangeOfICUREPattern:(NSString *)aPattern options:(NSUInteger)mask error:(NSError **)errorRef;
{
	NSUInteger theMask = mask;
	ICURegEx * RE = [[[ICURegEx alloc] initWithSearchPattern:aPattern options:theMask error:errorRef] autorelease];
	if (!RE) {
		return iTM3MakeRange(NSNotFound,ZER0);
	}
	[RE setInputString:self];
	[RE nextMatch];
	if (errorRef) {
		*errorRef = [RE error];
	}
	return [RE rangeOfMatch];
}

- (NSRange)rangeOfICUREPattern:(NSString *)aPattern options:(NSUInteger)mask range:(NSRange)searchRange error:(NSError **)errorRef;
{
	NSUInteger theMask = mask;
	if (searchRange.length<[self length]) {
		NSString * substring = [self substringWithRange:searchRange];
		return [substring rangeOfICUREPattern:aPattern options:theMask error:errorRef];
	}
	NSRange result = [self rangeOfICUREPattern:aPattern options:theMask error:errorRef];
	if (result.length) {
		result.location+=searchRange.location;
	}
	return result;
}

@end

@implementation NSObject(ICURegEx)
- (ICURegEx *)ICURegExForKey4iTM3:(NSString *)patternKey error:(NSError **)errorRef;
{
    return [ICURegEx regExForKey:patternKey inBundle:[NSBundle bundleForClass:[self class]] error:errorRef];
}
@end

@implementation NSMutableString(ICURegEx)

- (NSUInteger)replaceOccurrencesOfICUREPattern:(NSString *)aPattern withPattern:(NSString *)replacement options:(NSUInteger)opts range:(NSRange)searchRange error:(NSError **)errorRef;
{
	NSUInteger theOpts = opts;
	ICURegEx * RE = [[[ICURegEx alloc] initWithSearchPattern:aPattern options:theOpts error:errorRef] autorelease];
    if (RE) {
        RE.replacementPattern = replacement.length?replacement:@"";
        return [self replaceOccurrencesOfICURegEx:RE error:errorRef];
    }
	return ZER0;
}

- (NSUInteger)replaceOccurrencesOfICURegEx:(ICURegEx *)RE error:(NSError **)errorRef;
{
    NSParameterAssert(RE);
    RE.inputString = self;
    NSMutableArray * rangesAndReplacements = [NSMutableArray array];
	NSString * replacement = nil;
	NSValue * value;
	
	while(RE.nextMatch) {
		if ((replacement = [RE replacementString])) {
            value = [NSValue valueWithRange:RE.rangeOfMatch];
			[rangesAndReplacements addObject:value];
			[rangesAndReplacements addObject:replacement];
		} else {
			if (errorRef) {
				*errorRef = RE.error;
			}
            [RE forget];
			return ZER0;
		}
	}
	if (RE.error) {
		if (errorRef) {
			*errorRef = RE.error;
		}
        [RE forget];
		return ZER0;
	}
	NSEnumerator * E = [rangesAndReplacements reverseObjectEnumerator];
	while((replacement = [E nextObject]) && (value = [E nextObject])) {
		[self replaceCharactersInRange:value.rangeValue withString:replacement];
	}
    [RE forget];
	return rangesAndReplacements.count/2;
}

@end

@implementation NSMutableArray(ICURegEx)

- (void)removeObjectsNotMatchingICURegEx4iTM3:(ICURegEx *)RE;
{
    NSUInteger i = self.count;
    while(i) {
        id O = [self objectAtIndex:i];
        if ([O isKindOfClass:[NSString class]]) {
            RE.inputString = O;
        } else if ([O isKindOfClass:[NSURL class]]) {
            if ([O isFileURL]) {
                RE.inputString = [[O absoluteURL] path];
            } else {
                RE.inputString = [O absoluteString];
            }
        } else if ([O respondsToSelector:@selector(string)]) {
            RE.inputString = [O string];
        } else {
            RE.inputString = [O description];
        }
        if (RE.nextMatch) {
            [self removeObjectAtIndex:i];
        }
        --i;
    }
}
- (void)removeObjectsMatchingICURegEx4iTM3:(ICURegEx *)RE;
{
    NSUInteger i = self.count;
    while(i) {
        id O = [self objectAtIndex:i];
        if ([O isKindOfClass:[NSString class]]) {
            RE.inputString = O;
        } else if ([O isKindOfClass:[NSURL class]]) {
            if ([O isFileURL]) {
                RE.inputString = [[O absoluteURL] path];
            } else {
                RE.inputString = [O absoluteString];
            }
        } else if ([O respondsToSelector:@selector(string)]) {
            RE.inputString = [O string];
        } else {
            RE.inputString = [O description];
        }
        if (RE.nextMatch) {
            [self removeObjectAtIndex:i];
        }
        --i;
    }
}

@end

@implementation NSArray(ICURegEx)

- (id)filteredArrayUsingICURegEx4iTM3:(ICURegEx *)RE;
{
    NSMutableArray * MRA = self.mutableCopy;
    [MRA removeObjectsNotMatchingICURegEx4iTM3:RE];
    return MRA.copy;
}

@end