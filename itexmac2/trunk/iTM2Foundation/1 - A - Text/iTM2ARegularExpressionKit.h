// iTM2ARegularExpression.h
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


/*!
	@class iTM2ARESyntaxFormatter
	@abstract   A formatter that validates input strings to ensure that they are valid regular expressions.
	@discussion A iTM2ARESyntaxFormatter attempts to compile its input strings as regular expressions.  If they compile then they are valid input and the resulting iTM2ARegularExpression is the "value", otherwise the string is not valid input.
*/
	@interface iTM2ARESyntaxFormatter : NSFormatter {}

/*!
	@method		stringForObjectValue:
	@abstract   NSFormatter method for converting values to strings.
	@discussion NSFormatter method for converting values to strings.
				iTM2ARESyntaxFormatter accepts iTM2ARegularExpressions as values and converts them to their expression strings.
	@param		obj The iTM2ARegularExpression object to be converted to a string.
	@result		The expression string of the iTM2ARegularExpression value object.
 */
- (NSString *)stringForObjectValue:(id)obj;

/*!
	@method		getObjectValue:forString:errorDescription:
	@abstract   NSFormatter method for validating input strings and converting them to final values.
	@discussion iTM2ARESyntaxFormatter attempts to create a iTM2ARegularExpression using the input string as the expression string.  If it succeeds, the resulting iTM2ARegularExpression is the value, otherwise, the input is not valid.
	@param		obj A pointer to the output iTM2ARegularExpression.
	@param		string The input string to be validated and converted.
	@param		error A pointer to a pointer to an error string describing why the string was not valid.
	@result		YES if the string can be compiled into a valid regular expression, NO if not.  If YES, then obj will be filled in with a pointer to the resulting iTM2ARegularExpression.  If NO, then error will be filled in with a pointer to an error string.
     */
- (BOOL)getObjectValue:(id *)obj forString:(NSString *)string errorDescription:(NSString **)error;

	@end

typedef enum
{
    iTM2ARENoError 			= 0,
    iTM2ARENoMatch			= 1,
    iTM2AREInvalidRegularExpression	= 2,
    iTM2AREInvalidCollatingElement	= 3,
    iTM2AREInvalidCharacterClass		= 4,
    iTM2AREInvalidEscapeSequence		= 5,
    iTM2AREInvalidBackreferenceNumber	= 6,
    iTM2AREUnbalancedBracket		= 7,
    iTM2AREUnbalancedParenthese		= 8,
    iTM2AREUnbalancedBrace		= 9,
    iTM2AREInvalidRepetitionCount	= 10,
    iTM2AREInvalidCharacterRange		= 11,
    iTM2AREMemoryError			= 12,
    iTM2AREInvalidQuantifierOperand	= 13,
    iTM2AREBug				= 14,
    iTM2AREInvalidArgument		= 15,
    iTM2AREInvalidWidth			= 16,
    iTM2AREInvalidEmbeddedOption		= 17,
    iTM2AREExecutionError		= -2,
    iTM2ARENoStatus			= -1
} iTM2AREErrorStatus;

enum
{
    _iTM2AREExtendedOpt			= 0,
    _iTM2AREAdvancedFeatureOpt		= 1,
    _iTM2AREQuoteOpt			= 2,
    _iTM2ARECaseIndependentOpt		= 3,
    _iTM2AREIgnoreSubexpressionsOpt	= 4,
    _iTM2AREExpandedOpt			= 5,
    _iTM2ARENewlineStopOpt		= 6,
    _iTM2ARENewlineAnchorOpt		= 7,
    _iTM2AREBOSOnlyOpt			= 9
};

enum {
    iTM2AREExtendedMask				= 1 << _iTM2AREExtendedOpt,			//0001
    iTM2AREAdvancedFeatureMask			= 1 << _iTM2AREAdvancedFeatureOpt,		//0002
    iTM2AREAdvancedMask				= iTM2AREExtendedMask | iTM2AREAdvancedFeatureMask,//0003
    iTM2AREQuoteMask				= 1 << _iTM2AREQuoteOpt,				//0004
    iTM2ARECaseIndependentMask			= 1 << _iTM2ARECaseIndependentOpt,		//0010
    iTM2AREIgnoreSubexpressionsMask		= 1 << _iTM2AREIgnoreSubexpressionsOpt,		//0020
    iTM2AREExpandedMask				= 1 << _iTM2AREExpandedOpt,			//0040
    iTM2AREPartialNewlineSensitiveMask		= 1 << _iTM2ARENewlineStopOpt,			//0100
    iTM2AREInversePartialNewlineSensitiveMask	= 1 << _iTM2ARENewlineAnchorOpt,			//0200
    iTM2ARENewlineSensitiveMask			= iTM2AREPartialNewlineSensitiveMask |
                                                    iTM2AREInversePartialNewlineSensitiveMask,	//0300
    iTM2AREBOSOnlyMask				= 1 << _iTM2AREBOSOnlyOpt			//01000
};

/*!
	@class iTM2ARegularExpression
	@abstract   Represents a regular expression which can be matched against candidate strings.
	@discussion iTM2ARegularExpression objects are initialized from a pattern string in something similar to unix-style regular expression syntax (such as used in egrep) and can be used to match other strings against the pattern. In addition to the pattern string you can specify whether the expression should be case-insensitive. They are immutable.
 */
	@interface iTM2ARegularExpression : NSObject <NSCopying, NSCoding>
{
    @private
    NSString *_String;
    void *_Expression;
    unsigned int _Options;
    iTM2AREErrorStatus _CompilationStatus;
    iTM2AREErrorStatus _ExecutionStatus;
}

/*!
	@method		validString:
	@abstract   Syntax checks a regular expression string.
	@discussion Given a candidate regular expression string, this method attempts to compile it into a regular expression to see if it is valid.  In effect it syntax checks regular expression strings.
	@param		string The candidate regular expression string.
	@result		YES if the string is a valid regular expression, NO otherwise.
 */
+ (BOOL)validString:(NSString *)string;

/*!
	@method		regularExpressionWithString:ignoreCase:
	@abstract   Convenience factory for creating a new regular expression instance.
	@discussion Given a regular expression string and a flag indicating whether the expression should be case insensitive, this method returns a newly allocated, autoreleased iTM2ARegularExpression.
	@param		string The regular expression string.
	@param		ignoreCaseFlag Whether the expression object should ignore case differences when matching candidate strings.
	@result		The new autoreleased iTM2ARegularExpression, or nil if string is not a valid regular expression string.
 */
+ (id)regularExpressionWithString:(NSString *)string;

/*!
	@method		keyForErrorStatus:
	@abstract   Translates the error status into a human readable key.
	@discussion Description Forthcoming.
	@param		status is the integer return by the compile() and exec() functions.
	@result		A NSString key to be localized.
 */
+ (NSString *)keyForErrorStatus:(int) status;

/*!
	@method		localizedStringForErrorStatus:
	@abstract   Localize the +keyForErrorStatus:.
	@discussion Description Forthcoming.
	@param		status is the integer return by the compile() and exec() functions.
	@result		A localized NSString instance.
 */
+ (NSString *)localizedStringForErrorStatus:(int) status;

/*!
	@method		initWithString:
	@abstract   Init method. Convenience Initializer.
	@discussion Takes its value from -initWithString:options: with 0 as options.
	@param		string The regular expression string.
	@result		The initialized iTM2ARegularExpression.
 */
- (id)initWithString:(NSString *)string;

/*!
	@method		initWithString:options:
	@abstract   Init method. Designated Initializer.
	@discussion This is the Designated Initializer for the iTM2ARegularExpression class.
	@param		string The regular expression string.
	@param		options.
	@result		The initialized iTM2ARegularExpression, or nil if string is not a valid regular expression string.
 */
- (id)initWithString:(NSString *)string options:(unsigned)flags;

/*!
	@method		stringValue
	@abstract   Returns the regular expression string.
	@discussion Returns the regular expression string that was used to initialize the receiver.
	@result		The regular expression string.
 */
- (NSString *)stringValue;

/*!
	@method		ignoreCase
	@abstract   Returns whether the receiver is case insensitive.
	@discussion Returns whether the receiver is case insensitive.
	@result		YES if the receiver is case insensitive, NO if not.
 */
- (BOOL)ignoreCase;


/*!
	@method		matchesCharacters:inRange:
	@abstract   Check whether a specific range in a candidate character buffer matches the regular expression.
	@discussion Given a candidate character buffer and a range to match in,
				this method will return whether or not it matches the regular expression.
				This is the primitive matching method.  All others call through to this one eventually.
				A void array might be returned. This is the case when no match is found or when an error occurred.
				The status of the regular expression should be tested for that purpose.
	@param		candidateChars The unichar buffer to test against the regular expression.
	@param		searchRange The range of the buffer to use for matching.
	@result		YES if the searchRange of the candidateChars matches the expression, NO if not.
 */
- (NSArray *)matchRangesInCharacters:(const unichar *)candidateChars range:(NSRange)searchRange;

/*!
	@method		compilationStatusString
	@abstract   Localized status of last compilation.
	@discussion Localization dictionary a named: iTM2AREStatusString.strings.
	@result		an NSArray of range values.
 */
- (NSString *)compilationStatusString;

/*!
	@method		compilationStatus
	@abstract   status of last compilation.
	@discussion An error code
	@result		an error code.
 */
- (iTM2AREErrorStatus)compilationStatus;

/*!
	@method		executionStatus
	@abstract   status of last execution.
	@discussion An error code
	@result		an error code.
 */
- (iTM2AREErrorStatus)executionStatus;

/*!
	@method		expressionValue
	@abstract   The real regular expression.
	@discussion Description F.
	@result		an NSArray of range values.
 */
- (void *)expressionValue;

/*!
	@method		setOptions:
	@abstract   Sets the options of the receiver.
	@discussion Description Forthcoming.
	@param		flags is an integer gathering all the bit flags.
 */
- (void)setOptions:(int)flags;

	@end

/*!
	@function   iTM2TestAndCompileString
	@abstract   Description Forthcoming.
	@discussion Description Forthcoming.
	@param		string Description Forthcoming.
	@param		ignoreCase Description Forthcoming.
	@result		Description Forthcoming.
 */
extern void *iTM2TestAndCompileString(NSString *string, BOOL ignoreCase);

void iTM2FreeRegex(void *re);

/*!
	@class		NSString(iTM2ARegularExpression)
	@abstract   Description Forthcoming.
	@discussion Description Forthcoming.
*/
	@interface NSString(iTM2ARegularExpression)

/*!
	@method		TeX2REConvertedString:
	@abstract   Converts the string adding backslash escaped sequences.
	@discussion Description Forthcoming.
	@result		an NSString with more backslashes.
 */
- (NSString *)TeX2REConvertedString;

/*!
	@method		RE2TeXConvertedString:
	@abstract   Converts the string removing backslash escaped sequences.
	@discussion Description Forthcoming.
	@result		an NSString with less backslashes.
 */
- (NSString *)RE2TeXConvertedString;

/*!
	@method		rangesOfRegularExpression:
	@abstract   Returns the ranges of the first occurrence of the regular expression.
	@discussion Uses the -rangesOfRegularExpression:options: with default options.
	@param		iTM2ARegularExpression * RE is the regular expression tested against.
	@result		an NSArray of range values.
 */
- (NSArray *)rangesOfRegularExpression:(iTM2ARegularExpression *)RE;

/*!
	@method		rangesOfRegularExpression:options:
	@abstract   Returns the ranges of the first occurrence of the regular expression.
	@discussion Uses the -rangesOfRegularExpression:options:range: with default options and the full receiver's range.
	@param		iTM2ARegularExpression * RE is the regular expression tested against.
	@param		unsigned mask gathers all the options.
	@result		an NSArray of range values.
 */
- (NSArray *)rangesOfRegularExpression:(iTM2ARegularExpression *)RE options:(unsigned)mask;

/*!
	@method		rangesOfRegularExpression:options:
	@abstract   Returns the ranges of the first occurrence of the regular expression.
	@discussion See the note in iTeXMac2 CVS distribution.
	@param		unsigned mask gathers all the options.
	@param		NSRange searchRange is where the regular expression is searched.
	@result		an NSArray of range values.
 */
- (NSArray *)rangesOfRegularExpression:(iTM2ARegularExpression *)RE options:(unsigned)mask range:(NSRange)searchRange;

/*!
	@method		allRangesOfRegularExpression:
	@abstract   Returns the ranges of all the occurrences of the regular expression.
	@discussion Calls -allRangesOfRegularExpression:options: with default options.
	@param		the regular expression.
	@result		an NSArray of arrays of range values.
 */
- (NSArray *)allRangesOfRegularExpression:(iTM2ARegularExpression *)RE;

/*!
	@method		allRangesOfRegularExpression:options:
	@abstract   Returns the ranges of all the occurrences of the regular expression.
	@discussion See the note in iTeXMac2 CVS distribution.
	@param		the regular expression.
	@param		The options applied to the regular expression (unimplemented yet).
	@result		an NSArray of arrays of range values.
 */
- (NSArray *)allRangesOfRegularExpression:(iTM2ARegularExpression *)RE options:(unsigned)mask;

/*!
	@method		allRangesOfRegularExpression:options:range:
	@abstract   Returns the ranges of all the occurrences of the regular expression.
	@discussion See the note in iTeXMac2 CVS distribution.
	@param		RE is the regular expression.
	@param		mask gathers the options applied to the regular expression.
	@param		searchRange is the ctrang range where the search should occur.
	@result		an NSArray of arrays of range values.
 */
- (NSArray *)allRangesOfRegularExpression:(iTM2ARegularExpression *)RE options:(unsigned)mask range:(NSRange)searchRange;

	@end
