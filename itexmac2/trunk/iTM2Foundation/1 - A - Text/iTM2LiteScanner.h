/*
//
//  @version Subversion: $Id$ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Wed Dec 05 2001.
//  Copyright ©  2001 Laurens'Tribune. All rights reserved.
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
//  Version history: (format "- date:contribution (contributor) ")  
//  To Do List: (format "- proposition (percentage actually done) ") 
*/


typedef unichar (* iTM2CharacterAtIndexIMP) (id, SEL, unsigned);

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2LiteScanner

@interface iTM2LiteScanner : NSObject
{
@private
    NSString * string;
    NSCharacterSet * charactersToBeSkipped;
    NSCharacterSet * charactersNotToBeSkipped;
    unsigned scanLocation;
    BOOL caseSensitive;
//    iTM2CharacterAtIndexIMP CAI;
}
/*"Class methods"*/
+ (id)scannerWithString:(NSString *)string;
/*"Setters and Getters"*/
- (NSString *)string;
- (void)setString:(NSString *)string;
- (unsigned)scanLocation;
- (void)setScanLocation:(unsigned)pos;
- (NSCharacterSet *)charactersToBeSkipped;
- (void)setCharactersToBeSkipped:(NSCharacterSet *)set;
- (NSCharacterSet *)charactersNotToBeSkipped;
- (void)setCharactersNotToBeSkipped:(NSCharacterSet *)set;
- (BOOL)caseSensitive;
- (void)setCaseSensitive:(BOOL)flag;
- (BOOL)isAtEnd;
/*"Main methods"*/
- (id)initWithString:(NSString *)string;
- (BOOL)scanString:(NSString *)string intoString:(NSString **)value;
- (BOOL)scanCharactersFromSet:(NSCharacterSet *)set intoString:(NSString **)value;
- (BOOL)scanUpToString:(NSString *)string intoString:(NSString **)value;
- (BOOL)scanUpToCharactersFromSet:(NSCharacterSet *)set intoString:(NSString **)value;
- (BOOL)scanUpToEOLIntoString:(NSString **)value;
- (BOOL)scanString:(NSString *)aString intoString:(NSString **)value beforeIndex:(unsigned)stopIndex;
- (BOOL)scanCharactersFromSet:(NSCharacterSet *)set intoString:(NSString **)value beforeIndex:(unsigned)stopIndex;
- (BOOL)scanUpToString:(NSString *)aString intoString:(NSString **)value beforeIndex:(unsigned)stopIndex;
- (BOOL)scanUpToCharactersFromSet:(NSCharacterSet *)stopSet intoString:(NSString **)value beforeIndex:(unsigned)stopIndex;
/*"Overriden methods"*/
- (id)init;
@end

@interface iTM2LiteScanner (iTM2ExtendedScanner) 
- (BOOL)scanInt:(int *)value;
- (BOOL)scanHexInt:(unsigned *)value;		/* Optionally prefixed with "0x" or "0X" */
- (BOOL)scanLongLong:(long long *)value;
- (BOOL)scanFloat:(float *)value;
- (BOOL)scanDouble:(double *)value;
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2LiteScanner
