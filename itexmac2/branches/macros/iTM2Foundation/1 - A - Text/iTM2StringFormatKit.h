/*
//
//  @version Subversion: $Id$ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Sat Nov 10 2001.
//  Copyright © 2001-2002 Laurens'Tribune. All rights reserved.
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


//#import <iTM2Foundation/iTM2TextDocumentKit.h>
//#import <iTM2Foundation/iTM2DocumentControllerKit.h>

extern NSString * iTM2StringEncodingMissingFormat;
extern NSString * iTM2StringEncodingDefaultFormat;
extern NSString * iTM2EOLDefaultFormat;

@class NSMenu, NSNotification;
@protocol NSMenuItem;

typedef enum
{
    iTM2UnchangedEOL = 0,
    iTM2UNIXEOL = 1,
    iTM2MacintoshEOL = 2,
    iTM2WindowsEOL = 3,
    iTM2UnknownEOL = -1//for a further version...
} iTM2EOL;

extern NSString * const iTM2EOLPreferredKey;
extern NSString * const iTM2StringEncodingIsAutoKey;
extern NSString * const iTM2StringEncodingPreferredKey;
extern NSString * const iTM2StringEncodingOpenKey;

extern NSString * const iTM2StringEncodingHeaderKey;

extern NSString * const iTM2CharacterStringEncodingKey;// COCOA STUFF

extern NSString * const iTM2StringEncodingsPListName;

extern NSString * const iTM2StringEncodingListDidChangeNotification;

/*!
@class iTM2StringFormatController
@abstract	Helper to archive NSString objects.
@discussion These objects can translate NSString to NSData objects and conversely. They manage the string encoding and the line endings.
*/

#import <iTM2Foundation/iTM2InstallationKit.h>
#import <iTM2Foundation/iTM2Implementation.h>

@interface iTM2StringFormatController: iTM2Object

/*"Class methods"*/
/*"Public methods"*/
/*"Setters and Getters"*/
//+ (BOOL) validateMenuItem: (id <NSMenuItem>) sender;
+(iTM2EOL)EOLForName:(NSString *)name;
+(NSMenu *)EOLMenuWithAction:(SEL)anAction target:(id)aTarget;
+(NSMenu *)stringEncodingMenuWithAction:(SEL)anAction target:(id)aTarget;
+(NSArray *)supportedStringEncodings;
+(NSString *)terminationStringForEOL:(iTM2EOL)EOL;
+(iTM2EOL)EOLForTerminationString:(NSString *)terminationString;
+(CFStringEncoding)coreFoundationStringEncodingFromString:(NSString *)argument;
+(NSNumber *)stringEncodingFromString:(NSString *)argument;
+(NSString *)nameOfCoreFoundationStringEncoding:(CFStringEncoding)argument;
+(NSString *)nameOfEOL:(iTM2EOL)LE;
+(NSArray *)availableStringEncodings;// NSStringEncodings
/*"Main methods"*/
/*"Overriden methods"*/

/*!
	@method		initWithDocument:
	@abstract	Designated intializer.
	@discussion A reference is stored.
	@param		The new document
	@result		None
*/
-(id)initWithDocument:(id)document;


/*!
	@method		terminationStringForEOL:
	@abstract	Returns the termination string for the given line ending.
	@discussion the string @"\n" is returned as default value.
	@param EOL is the line endings setting.
	@result		An NSString in cr, cr+lf or lf.
*/
+(NSString *)terminationStringForEOL:(iTM2EOL)EOL;

/*!
	@method		dataWithString:allowLossyConversion:
	@abstract	Returns the data representation of the string argument.
	@discussion The given argument is converted to a data representation according to the string encoding and line endings information of the receiver.
	@param		string is the NSString object to be converted.
	@param		lossy is a flag.
	@result		An NSData instance.
*/
-(NSData *)dataWithString:(NSString *)argument allowLossyConversion:(BOOL)lossy;

/*!
	@method		canConvertString:
	@abstract	Whether the argument can be converted.
	@discussion Returns YES iff the argument can be converted to a NSData object using the receiver's string encoding without loss.
	@param string is the NSString object to be converted.
	@result		yorn.
*/
-(BOOL)canConvertString:(NSString *)argument;

/*!
	@method		nextUnconvertibleCharacterIndexOfString:startingAt:
	@abstract	The index of the next uncovertible characeter.
	@discussion Returns the index of the next character that cannot be converted to a NSData object using the receiver's string encoding without any loss. If there is a problem in string encoding, clients will be able to notify the user and show exactly where the problem occurs. If no character is found, NSNotFound is returned.
	@param argument is the NSString object to be converted.
	@param index is the starting point of the testing (included).
	@result		an index.
*/
-(unsigned int)nextUnconvertibleCharacterIndexOfString:(NSString *)argument startingAt:(unsigned int)index;

/*!
	@method		stringWithData:
	@abstract	Returns the string representation of the data argument.
	@discussion The given NSData argument is converted to a NSString object
				according to the string encoding information provided.
				If there is some hard coded string encoding information,
				it will be used instead of the given parameter.
	@param data is the NSData object to be converted.
	@result		An NSString instance.
*/
-(NSString *)stringWithData:(NSData *)data;

/*!
	@method		EOL
	@abstract	Returns the line endings used (NONE|UNIX|MAC|WINDOWS).
	@discussion Description forthcoming.
	@param		None
	@result		0 for unspecified, 1 for UNIX (LF), 2 for Macintosh (CR), 3 for windows (CR+LF).
*/
-(unsigned int)EOL;

/*!
	@method		setEOL:
	@abstract	Sets the line endings of the receiver.
	@discussion Description forthcoming.
	@param		None
	@result		None
*/
-(void)setEOL:(unsigned int)argument;

/*!
	@method		stringEncoding
	@abstract	Returns the string encoding used.
	@discussion This can be hard coded in the data model itself.
				It is used to convert the string representation into a data representation.
	@param		None
	@result		An NSString instance owned by the receiver.
*/
-(NSStringEncoding)stringEncoding;

/*!
	@method		setStringEncoding:
	@abstract	Sets the string encoding of the receiver.
	@discussion Description forthcoming.
	@param		None
	@result		None
*/
-(void)setStringEncoding:(NSStringEncoding)argument;

/*!
	@method		isStringEncodingHardCoded
	@abstract	Returns whether the string encoding can be programatically set.
	@discussion NO iff the string encoding is actually hardly coded in the data model itself.
				This can lead to problems when editing, such that the rules must be clear and precise.
				A string encoding is said to be hardy coded iff the data model contains some key strings such as
				%!iTeXMac2(charset): ...
				\usepackage[...]{inputenc}
				\enableregime{...}
	@param		None
	@result		yorn.
*/
-(BOOL)isStringEncodingHardCoded;
-(void)setStringEncodingHardCoded:(BOOL)yorn;

-(NSString *)hardStringEncodingString;
-(void)setHardStringEncodingString:(NSString *)argument;

/*!
	@method		document
	@abstract	The document of the receiver.
	@discussion Description forthcoming.
	@param		None
	@result		the owner
*/
-(id)document;

/*!
	@method		setDocument:
	@abstract	Set the document of the receiver.
	@discussion A reference is stored.
	@param		The new document
	@result		None
*/
-(void)setDocument:(id)document;

@end

@interface NSString(iTM2StringFormatController)

/*!
	@method		localizedNameOfEOL:
	@abstract	The localized name of the given lene ending...
	@discussion Description forthcoming.
	@param		None
	@result		None
*/
+(NSString *)localizedNameOfEOL:(iTM2EOL)LE;

/*!
	@method		stringByUsingEOL:
	@abstract	Converts the receiver to use the given line endings.
	@discussion Description forthcoming.
	@param		None
	@result		None
*/
-(NSString *)stringByUsingEOL:(iTM2EOL)EOL;

/*!
	@method		EOLUsed
	@abstract	The line endings used.
	@discussion The first line ending found, and iTM2UnchangedLienEnding when there is some problem.
	@param		None
	@result		None
*/
-(iTM2EOL)EOLUsed;

/*!
	@method		getHardCodedStringEncoding:range:
	@abstract	The string encoding.
	@discussion This value is guessed from the contents of the receiver and the context.
	@param		None
	@result		None
*/
-(void)getHardCodedStringEncoding:(NSStringEncoding *)stringEncodingRef range:(NSRangePointer)rangeRef;

@end

@interface NSDocument(iTM2StringFormatController)

-(id)stringFormatter;

@end

@interface iTM2StringEncodingDocument: NSDocument
{
@private
    NSMutableArray * _ActualStringEncodings;
    NSTableView * availableTableView;
    NSTableView * actualTableView;
}
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2StringFormatKit

