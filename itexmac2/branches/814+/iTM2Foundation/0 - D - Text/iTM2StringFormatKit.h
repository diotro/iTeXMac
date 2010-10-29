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


//#import "iTM2TextDocumentKit.h"
//#import "iTM2DocumentControllerKit.h"

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
extern NSString * const iTM2StringEncodingIsHardCodedKey;
extern NSString * const iTM2StringEncodingPreferredKey;
extern NSString * const iTM2StringEncodingOpenKey;

extern NSString * const iTM2StringEncodingHeaderKey;

extern NSString * const iTM2CharacterStringEncodingKey;// COCOA STUFF

extern NSString * const iTM2StringEncodingsPListName;

extern NSString * const iTM2StringEncodingListDidChangeNotification;

extern NSString * const TWSStringEncodingFileKey;
extern NSString * const TWSEOLFileKey;

/*!
@class iTM2StringFormatController
@abstract	Helper to archive NSString objects.
@discussion These objects can translate NSString to NSData objects and conversely. They manage the string encoding and the line endings.
*/

#import "iTM2InstallationKit.h"
#import "iTM2Implementation.h"

@interface iTM2StringFormatController: iTM2Object
{
@private
	id __weak iVarDocument4iTM3;;
    NSNumber * iVarEOL4iTM3;
    NSNumber * iVarStringEncoding4iTM3;
    BOOL iVarStringEncodingIsHardCoded4iTM3;
    NSString * iVarHardStringEncodingString4iTM3;
}

/*!
	@property	document
	@abstract	The document of the receiver.
	@discussion Description forthcoming.
	@param		None
	@result		the owner
*/
@property (assign) __weak id document;

/*"Class methods"*/
/*"Public methods"*/
/*"Setters and Getters"*/
//+ (BOOL) validateMenuItem: (NSMenuItem *) sender;
+ (iTM2EOL)EOLForName:(NSString *)name;
+ (NSMenu *)EOLMenuWithAction:(SEL)anAction target:(id)aTarget;// target must be alive
+ (NSMenu *)stringEncodingMenuWithAction:(SEL)anAction target:(id)aTarget;// target must be alive
+ (NSArray *)supportedStringEncodings;
+ (NSString *)terminationStringForEOL:(iTM2EOL)EOL;
+ (CFStringEncoding)coreFoundationStringEncodingWithName:(NSString *)argument;
+ (NSString *)nameOfCoreFoundationStringEncoding:(CFStringEncoding)argument;
+ (NSString *)nameOfEOL:(iTM2EOL)LE;
+ (NSArray *)availableStringEncodings;// NSStringEncodings
/*"Main methods"*/
/*"Overriden methods"*/

/*!
	@method		initWithDocument:
	@abstract	Designated intializer.
	@discussion A reference is stored.
	@param		The new document
	@result		None
*/
- (id)initWithDocument:(id)document;


/*!
	@method		terminationStringForEOL:
	@abstract	Returns the termination string for the given line ending.
	@discussion the string @"\n" is returned as default value.
	@param EOL is the line endings setting.
	@result		An NSString in cr, cr+lf or lf.
*/
+ (NSString *)terminationStringForEOL:(iTM2EOL)EOL;

/*!
	@method		dataWithString:allowLossyConversion:
	@abstract	Returns the data representation of the string argument.
	@discussion The given argument is converted to a data representation according to the string encoding and line endings information of the receiver.
	@param		string is the NSString object to be converted.
	@param		lossy is a flag.
	@result		An NSData instance.
*/
- (NSData *)dataWithString:(NSString *)argument allowLossyConversion:(BOOL)lossy;

/*!
	@method		canConvertString:
	@abstract	Whether the argument can be converted.
	@discussion Returns YES iff the argument can be converted to a NSData object using the receiver's string encoding without loss.
	@param string is the NSString object to be converted.
	@result		yorn.
*/
- (BOOL)canConvertString:(NSString *)argument;

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
- (NSString *)stringWithData:(NSData *)data;

/*!
	@method		stringWithData:
	@abstract	Reads the string representation from the given URL.
	@discussion Use stringWithData: on systems prior to leopard (not included).
	@param data is the NSData object to be converted.
	@result		An NSString instance.
*/
- (BOOL)readFromURL:(NSURL *)absoluteURL error:(NSError **)outErrorPtr;

/*!
	@property	EOL
	@abstract	Returns the line endings used (NONE|UNIX|MAC|WINDOWS).
	@discussion Description forthcoming.
	@param		None
	@result		0 for unspecified, 1 for UNIX (LF), 2 for Macintosh (CR), 3 for windows (CR+LF).
*/
@property (assign, getter = EOL) NSUInteger EOL;

/*!
	@property	stringEncoding
	@abstract	Returns the string encoding used.
	@discussion This can be hard coded in the data model itself.
				It is used to convert the string representation into a data representation.
	@param		None
	@result		A cocoa string encoding, not a core foundation one.
*/
@property (assign) NSStringEncoding stringEncoding;

/*!
	@property	isStringEncodingHardCoded
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
@property (assign, setter = setStringEncodingHardCoded) BOOL isStringEncodingHardCoded;

@property (copy) NSString * hardStringEncodingString;

@end

@interface NSString(iTM2StringFormatController)

/*!
	@method		nameOfStringEncoding4iTM3:
	@abstract	The IANA name of the given given cocoa string encoding...
	@discussion Description forthcoming.
	@param		A cocoa string encoding, not a cor foundation one
	@result		None
*/
+ (NSString *)nameOfStringEncoding4iTM3:(NSStringEncoding)encoding;

/*!
	@method		stringEncodingWithName4iTM3:
	@abstract	The cocoa string encoding given its name
	@discussion Description forthcoming.
	@param		A IANA string encoding name
	@result		a cocoa string encoding not a core foundation one.
*/
+ (NSStringEncoding)stringEncodingWithName4iTM3:(NSString *)name;

/*!
	@method		localizedNameOfEOL4iTM3:
	@abstract	The localized name of the given lene ending...
	@discussion Description forthcoming.
	@param		None
	@result		None
*/
+ (NSString *)localizedNameOfEOL4iTM3:(iTM2EOL)LE;

/*!
	@method		stringByUsingEOL4iTM3:
	@abstract	Converts the receiver to use the given line endings.
	@discussion Description forthcoming.
	@param		None
	@result		None
*/
- (NSString *)stringByUsingEOL4iTM3:(iTM2EOL)EOL;

/*!
	@method		EOLUsed4iTM3
	@abstract	The line endings used.
	@discussion The first line ending found, and iTM2UnchangedLienEnding when there is some problem.
	@param		None
	@result		None
*/
- (iTM2EOL)EOLUsed4iTM3;

/*!
	@method		getHardCodedStringEncoding4iTM3:range:
	@abstract	The string encoding.
	@discussion This value is guessed from the contents of the receiver and the context.
	@param		None
	@result		None
*/
- (void)getHardCodedStringEncoding4iTM3:(NSStringEncoding *)stringEncodingRef range:(NSRangePointer)rangeRef;

@end

@interface NSDocument(iTM2StringFormatController)

- (id)stringFormatter4iTM3;

@end

@interface iTM2StringEncodingDocument: NSDocument
{
@private
    NSMutableArray * _ActualStringEncodings;
    NSTableView * availableTableView;
    NSTableView * actualTableView;
}
@property (retain) NSMutableArray * _ActualStringEncodings;
@property (retain) NSTableView * availableTableView;
@property (retain) NSTableView * actualTableView;
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2StringFormatKit

