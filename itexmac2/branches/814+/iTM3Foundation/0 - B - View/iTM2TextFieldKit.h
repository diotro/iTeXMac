/*
//
//  @version Subversion: $Id: iTM2TextFieldKit.h 794 2009-10-04 12:33:28Z jlaurens $ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Tue Jul 03 2001.
//  Copyright © 2001-2002 Laurens'Tribune. All rights reserved.
//
//  This program is free software; you can redistribute it and/or modify it under the terms
//  of the GNU General Public License as published by the Free Software Foundation; either
//  version 2 of the License, or any later version.
//  This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
//  without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
//  See the GNU General Public License for more details. You should have received a copy
//  of the GNU General Public License along with this program; if not, write to the Free Software
//  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
//  GPL addendum: Any simple modification of the present code which purpose is to remove bug,
//  improve efficiency in both code execution and code reading or writing should be addressed
//  to the actual developper team.
*/

#import "iTM2ResponderKit.h"

@interface iTM2LineField : NSTextField
{
@private
    NSView * rightView;
}

/*!
    @method		lineFieldAction:
    @abstract	Abstract forthcoming.
    @discussion	The window controller of the receiver is expected to have a textView.
    @param		irrelevant sender
    @result		None
*/
- (IBAction)lineFieldAction:(id)sender;
@property (retain) NSView * rightView;
@end
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2TextFieldKit

@interface iTM2FileNameFormatter : NSFormatter
@end

@interface iTM2LineFormatter : NSNumberFormatter
{
@private
    NSString * _NavigationFormat;
}
- (NSString *)navigationFormat;
- (NSString *)lazyNavigationFormat;
- (void)setNavigationFormat:(NSString *)aFormat;
@property (retain) NSString * _NavigationFormat;
@end

@interface iTM2NavigationFormatter : iTM2LineFormatter <NSTextFieldDelegate>
@end

@interface iTM2MagnificationFormatter : NSNumberFormatter <NSTextFieldDelegate>
@end

@interface NSFormatter(iTM2TextField)
- (NSString *)stringForNilObjectValue;
- (void)setStringForNilObjectValue:(NSString *)aString;
- (NSAttributedString *)attributedStringForNilObjectValueWithDefaultAttributes:(NSDictionary *)attrs;
@end

@interface iTM2StringFormatter : NSFormatter
{
@private
	id _Implementation;
}
@property (retain) id _Implementation;
@end

@interface iTM2LineResponder: iTM2AutoInstallResponder
- (IBAction)gotoLineField:(id)sender;
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2TextFieldKit
