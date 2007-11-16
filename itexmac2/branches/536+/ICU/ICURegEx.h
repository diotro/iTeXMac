#import <Foundation/Foundation.h>

/*!
	@enum		ICURegEx options.
    @const		ICUREForceNormalizationOption
				Forces normalization of pattern and strings.
    @const		ICURECaseSensitiveOption
				Enable case insensitive matching
    @const		ICUREAllowWhiteSpaceAndCommentsOption
				Allow white space and comments within patterns
    @const		ICUREDotMatchesLineTerminatorsOption
    			If set, '.' matches line terminators,  otherwise '.' matching stops at line end
    @const		ICUREMultilineOption
    			Control behavior of "$" and "^"
				If set, recognize line terminators within string,
				otherwise, match only at start and end of input string.
    @const		ICUREUnicodeWordBoundariesOption
    			Unicode word boundaries.
				If set, \b uses the Unicode TR 29 definition of word boundaries.
				Warning: Unicode word boundaries are quite different from
				traditional regular expression word boundaries.  See
				http://unicode.org/reports/tr29/#Word_Boundaries
*/
enum{
    ICUREForceNormalizationOption = 128,
    ICURECaseSensitiveOption = 2,//i
    ICUREAllowWhiteSpaceAndCommentsOption = 4,//x
    ICUREDotMatchesLineTerminatorsOption = 32,//s
    ICUREMultilineOption = 8,//m
    ICUREUnicodeWordBoundariesOption = 256//w
};

@interface NSString(ICURegEx)

/*!
    @method     rangeOfICUREPattern:error:
    @abstract   The range of the given pattern in the receiver
    @discussion Forwards to <code>-rangeOfICUREPattern:options:error:</code> with NULL options.
				If you are to perform many search with the same pattern and the same string,
				you should consider using IUCRegEx object directly.
	@param		aPattern
	@param		errorRef
    @result     a range
*/
- (NSRange)rangeOfICUREPattern:(NSString *)aPattern error:(NSError **)errorRef;

/*!
    @method     rangeOfICUREPattern:options:error:
    @abstract   The range of the given pattern in the receiver
    @discussion This method is very similar to <code>rangeOfICUREPattern:options:</code>,
				except that the options are specific.
				If the returned range is {NSNotFound,0}, the errorRef (if not null) will point to the error.
				In general, the error come from bad syntax in the given pattern.
				See <code>+[ICURegEx isValidPattern:options:error:]</code> for details.
				If you are to perform many search with the same pattern and the same string,
				you should consider using IUCRegEx object directly.
	@param		aPattern
	@param		mask
	@param		errorRef
    @result     a range
*/
- (NSRange)rangeOfICUREPattern:(NSString *)aPattern options:(unsigned)mask error:(NSError **)errorRef;

/*!
    @method     rangeOfICUREPattern:options:range:error:
    @abstract   The range of the given pattern in the receiver
    @discussion A substring is extracted from the receiver for the given search range,
				the <code>-rangeOfICUREPattern:options:error:</code> message is sent to the resulting string.
				If you are to perform many search with the same pattern and the same string,
				you should consider using IUCRegEx object directly.
	@param		aPattern
	@param		mask
	@param		searchRange
	@param		errorRef
    @result     a range
*/
- (NSRange)rangeOfICUREPattern:(NSString *)aPattern options:(unsigned)mask range:(NSRange)searchRange error:(NSError **)errorRef;

/*!
    @method     stringByEscapingICUREControlCharacters
    @abstract   An escaped string
    @discussion Description forthcoming.
	@param		None
    @result     a string
*/
- (NSString *)stringByEscapingICUREControlCharacters;

@end

@interface NSMutableString(ICURegEx)

/*!
    @method     replaceOccurrencesOfICUREPattern:withPattern:options:range:error:
    @abstract   Replace all the ocurrences of the given pattern.
    @discussion Description forthcoming.
 	@param		aPattern
	@param		mask
	@param		searchRange
	@param		errorRef
	@result     the number of replacements
*/
- (unsigned int)replaceOccurrencesOfICUREPattern:(NSString *)target withPattern:(NSString *)replacement options:(unsigned)opts range:(NSRange)searchRange error:(NSError **)errorRef;

@end

/*!
    @class			ICURegEx
    @superclass		NSObject
    @abstract		Regular Expression matcher.
    @discussion		This is a wrapper class over the regular expression facilities of libicucore.
					With ICURegEx objects, you can look for a search pattern in a string.
					<p>First, you create a matcher with the <code>-initWithSearchPattern:options:error:</code> method.
					The error returned will explain why the matcher could not be created, in general,
					this is a syntax problem in the pattern.
					<p>Then, you feed the matcher with an input string where the search/match should occur.
					<p>Finally, you can ask whether (a part of) the string matches the whole pattern,
					or the range of a pattern. If you provide a <code>replacementString</code>,
					you can have the <code>replacementString</code> for a given match.
					The matcher won't perform any modification on the input string or patterns.
					It is up to the client to make such modifications.
*/

@interface ICURegEx:NSObject<NSCopying>
{
@private
	id _iVars;
}

/*!
    @method     isValidPattern:options:error:
    @abstract   Convenient pattern validator.
    @discussion Test whether the given pattern is correct.
    @param      pattern is a regular expression pattern, according to <a href="http://icu.sourceforge.net/userguide/regexp.html">ICU rules</a>
    @param      flags is the list of options (see above)
    @param      errorRef is a pointer to an error where problems are explained. In general, it is a syntax problem in the pattern.
				The user dictionary of the error may contain the following information:
				<ul>
				<li>for keys <code>line</code> and <code>column</code>, or <code>offset</code>: the location of the error</li>
				<li>keys <code>pre context</code> and <code>post context</code>: the context of the error</li>
				</ul>
	@result     yorn
*/
+ (BOOL)isValidPattern:(NSString *)pattern options:(unsigned int)flags error:(NSError **)errorRef;

/*!
    @method     initWithSearchPattern:options:error:
    @abstract   Designated initializer.
    @discussion Creates an object suitable for further regular expression operations.
    @param      pattern is a regular expression pattern, according to <a href="http://icu.sourceforge.net/userguide/regexp.html">ICU rules</a>
    @param      flags is the list of options (see above)
    @param      errorRef is a pointer an error where problems are explained. See <code>isValidPattern:options:error:</code> for details.
	@result     nil is returned when an error occurred
*/
- (id)initWithSearchPattern:(NSString *)pattern options:(unsigned int)flags error:(NSError **)errorRef;

/*!
    @method     regExWithSearchPattern:
    @abstract   The cached regular expression wrapper for the given pattern.
    @discussion Discussion forthcoming.
    @param      pattern is a regular expression pattern, according to <a href="http://icu.sourceforge.net/userguide/regexp.html">ICU rules</a>
	@result     nil is returned when an error occurred
*/
+ (id)regExWithSearchPattern:(NSString *)pattern;

/*!
    @method     inputString
    @abstract   The string to search in.
    @discussion Description forthcoming.
    @result     a string
*/
- (NSString *)inputString;

/*!
    @method     setInputString:
    @abstract   Set the string to search in.
    @discussion The argument is retained by the receiver.
				Contrary to the patterns, there should be no internal duplication of the given string.
				In general, the input string is expected to be rather big and this would cost much memory.
				As a consequence, once a match has been performed, it is not advisable to make another match.
				Unfortunately, ICU expects an array of 16 bits characters whereas Mac OS X sometimes uses 8 bits characters (UTF8).
				Then we must have to translate 8bits to 16bits, so there is no benefit here.
				This would be the justification of some <code>setInputSubstringOf:range:</code> to come.
				If the range is out of bounds, an error will be returned by the <code>error</code> method. 
				If you want to change the search range, this is the only method available.
    @param		a string
    @param		a range
	@result		yorn
*/
- (BOOL)setInputString:(NSString *)argument;
- (BOOL)setInputString:(NSString *)argument range:(NSRange)range;

/*!
    @method     searchPattern
    @abstract   The search pattern.
    @discussion Description forthcoming.
    @result		a string
*/
- (NSString *)searchPattern;

/*!
    @method     replacementPattern
    @abstract   The replacement pattern.
    @discussion Description forthcoming.
    @result		a string
*/
- (NSString *)replacementPattern;

/*!
    @method     setReplacementPattern:
    @abstract   Set the replacement pattern.
    @discussion The argument is retained by the receiver.
				Any further modification on the argument will be ignored by the receiver.
    @param     a pattern according to <a href="http://icu.sourceforge.net/userguide/regexp.html">ICU rules</a>
*/
- (void)setReplacementPattern:(NSString *)argument;

/*!
    @method     replacementString
    @abstract   The replacement string for the current match.
    @discussion This is the pattern where all the back references are replaced by the actual value for the actual match.
    @result     If there is no current match, returns nil
*/
- (NSString *)replacementString;

/*!
    @method     matchString:
    @abstract   One shot matcher
    @discussion This is a convenient method, for one shot match. It sets the input string, test.
				When you have termionated to work with the receiver, send the receiver a forget message.
    @param      The input string.
    @result     yorn
*/
- (BOOL)matchString:(NSString *)string;

/*!
    @method     stringByMatchingString:replacementPattern:
    @abstract   Returns the replacement string when match
    @discussion This is a convenient method, for one shot match/replacement. It sets the input string, test, then forget the input string.
				If there is no match, nil is returned.
    @param      The input string.
    @result     yorn
*/
- (NSString *)stringByMatchingString:(NSString *)string replacementPattern:(NSString *)replacement;

/*!
    @method     forget
    @abstract   Let the reciever forget its input string and repalcement pattern
    @discussion When your work with a one shot RE is complete, send this message in order to clean its internals.
    @param      None.
    @result     None
*/
- (void)forget;

/*!
    @method     matchesAtIndex:extendToTheEnd:
    @abstract   Returns YES if the input string matches the receiver's pattern
    @discussion If the match succeeds then more information can be obtained via the <code>rangeOfMatch</code>,
				<code>numberOfgroups</code>, and <code>rangeOfGroupAtIndex:</code> methods.
				<p/>
				If the match fails, the <code>error</code> method will return the eventual error.
				If there is no error, we can say that the input string does not match.
    @param      index is the location where the search will start. If a match is found, its location is greater than or equal to index.
    @param      yorn, pass YES if you want the match to extend to the end of the input string.
    @result     yorn
*/
- (BOOL)matchesAtIndex:(int)index extendToTheEnd:(BOOL)yorn;

/*!
    @method     nextMatch
    @abstract   Find the next pattern match in the input string
    @discussion The find begins searching the input at the location following the end of
				the previous match, or at the start of the string if there is no previous match.
				If a match is found, <code>rangeOfMatch</code>, <code>numberOfGroups</code> and <code>rangeOfNextMatchAfterIndex:</code>
				will provide more information regarding the match.
    @param      aTree
    @result     yorn
*/
- (BOOL)nextMatch;

/*!
    @method     nextMatchAfterIndex:
    @abstract   Find the next pattern match in the input string
    @discussion The find begins searching the input at the given location.
				If a match is found, <code>rangeOfMatch</code>, <code>numberOfGroups</code> and <code>rangeOfNextMatchAfterIndex:</code>
				will provide more information regarding the match.
    @param      index, pass 0 to start from the beginning of the input string.
    @result     yorn
*/
- (BOOL)nextMatchAfterIndex:(int)index;

/*!
    @method     rangeOfMatch
    @abstract   The range of the last found match
    @discussion When there is a match, the location of the range is an offset.
				This is the position of the first character of the match,
				relative to the position following the range of the last match found.
				If the match was searched after a given index, the position is relative to this index.
				If there is no last match found, this position is relative to the beginning of the input string.
				This is useful when replacing in the input string.
    @result     a range, {NSNotFound,O} if there is no match found
*/
- (NSRange)rangeOfMatch;

/*!
    @method     substringOfMatch
    @abstract   The substring of the last found match
    @discussion Description forthcoming.
    @result     a string
*/
- (NSString *)substringOfMatch;

/*!
    @method     numberOfCaptureGroups
    @abstract   the number of capture groups
    @discussion the number of capturing groups in this matcher's pattern.
    @result     integer
*/
- (int)numberOfCaptureGroups;

/*!
    @method     rangeOfCaptureGroupAtIndex:
    @abstract   range of the capture group at the given index
    @discussion Returns the range in the input string of the text matched by the
				specified capture group during the previous match operation.  Return {NSNotFound,0} if
				the capture group exists in the pattern, but was not part of the last match,
				or if there were an error.
				<p/>
				Possible errors are  U_REGEX_INVALID_STATE if no match has been
				attempted or the last match failed and U_INDEX_OUTOFBOUNDS_ERROR for a bad capture group number
				At index 0 is the range of the whole match, the capture groups are from 1 to <code>numberOfGroups</code> (both included)
				All the ranges are given relative to the origin of the given string, they are expectrd to lay in the search range.
    @param      aTree
    @result     None
*/
- (NSRange)rangeOfCaptureGroupAtIndex:(int)index;

/*!
    @method     substringOfCaptureGroupAtIndex:
    @abstract   The substring of the capture group at the given index
    @discussion Description forthcoming.
    @param      index
    @result     a string
*/
- (NSString *)substringOfCaptureGroupAtIndex:(int)index;

/*!
    @method     componentsBySplitting
    @abstract   Split the input string into fields.  Somewhat like split() from Perl.
    @discussion The pattern matches identify delimiters that separate the input into fields.
				The input data between the matches becomes the fields themselves,
				with the captured groups.
    @result     An array of strings
*/
- (NSArray *)componentsBySplitting;

/*!
    @method     error
    @abstract   The eventual error during the last operation performed.
    @discussion Be sure that the <code>error</code> message is sent after the operation.
				For example, assuming <code>RE</code> is a regular expression object, in
				<code>NSLog(@"...",([RE nextMatch]?@"Found":@"Not Found"),[RE error])</code>
				the arguments are evaluated from right to left such that the error refers to the state before the find operation is performed.
    @result     An error
*/
- (NSError *)error;

/*!
    @method     reset
    @abstract   Reset the receiver.
    @discussion The pattern matching restarts from 0.
    @result     A flag indicating whether the operation is successful or not
*/
- (BOOL)reset;

/*!
    @method     resetAtIndex:
    @abstract   Reset the receiver.
    @discussion The pattern matching restarts from the given index.
    @result     A flag indicating whether the operation is successful or not
*/
- (BOOL)resetAtIndex:(int)index;

/*!
    @method     copyWithZone:
    @abstract   Make a copy of the receiver.
    @discussion Creates a copy, the underlying pattern object is a clone, the repalce pattern is shared, but the search string is ignored.
	@param		the zone
    @result     The copy
*/
- (id)copyWithZone:(NSZone *)zone;

@end
