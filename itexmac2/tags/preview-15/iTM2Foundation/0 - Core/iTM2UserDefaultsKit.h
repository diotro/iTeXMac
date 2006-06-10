/*
//  iTM2UserDefaultsKit.h
//  iTeXMac2
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Thu Oct 25 2001.
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


extern NSString * const iTM2UserDefaultsDidChangeFontOrColorNotification;
extern NSString * const iTM2UserDefaultsDidChangeNotification;
extern NSString * const iTM2NavLastRootDirectory;

@class NSDictionary;
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= NSUserDefaults(iTeXMac2)

@interface NSUserDefaults(iTeXMac2)
/*"Class methods"*/
/*"Setters and Getters"*/
- (NSFont *) fontForKey: (NSString *) aKey;
- (void) setFont: (NSFont *) aFont forKey: (NSString *) aKey;
- (NSColor *) colorForKey: (NSString *) aKey;
- (void) setColor: (NSColor *) aColor forKey: (NSString *) aKey;
/*"Main methods"*/
- (void) registerFont: (NSFont *) aFont forKey: (NSString *) aKey;
- (void) registerColor: (NSColor *) aColor forKey: (NSString *) aKey;
- (void) notifyChangeNow;
- (void) notifyFontOrColorChangeNow;
/*"Overriden methods"*/
@end

@interface NSFont(iTM2UserDefaults)
/*"Class methods"*/
+ (NSFont *) fontWithNameSizeDictionary: (NSDictionary *) aDictionary;
/*"Setters and Getters"*/
- (NSDictionary *) nameSizeDictionary;
/*"Main methods"*/
/*"Overriden methods"*/
@end

@interface NSColor(iTM2UserDefaults)
/*"Class methods"*/
+ (NSColor *) colorWithRGBADictionary: (NSDictionary *) aDictionary;
/*"Setters and Getters"*/
- (NSDictionary *) RGBADictionary;
/*"Main methods"*/
/*"Overriden methods"*/
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= NSUserDefaults(iTeXMac2)
