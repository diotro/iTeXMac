/*
//  iTM2ButtonKit.h
//  iTeXMac2
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Fri Dec 13 2002.
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


extern NSString * const iTM2UDMixedButtonDelayKey;

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2ButtonKit

@interface iTM2ButtonMixed: NSButton
{
@private
    NSTimer * _Timer;
    SEL _MixedAction;
    BOOL _CenteredArrow;
    BOOL _MixedEnabled;
}
/*"Class methods."*/
/*"Setters and getters."*/
- (NSTimer *) timer;
- (void) setTimer: (NSTimer *) aTimer;
- (BOOL) isCenteredArrow;
- (void) setCenteredArrow: (BOOL) aFlag;
- (BOOL) isMixedEnabled;
- (void) setMixedEnabled: (BOOL) aFlag;
- (SEL) mixedAction;
- (void) setMixedAction: (SEL) anAction;
/*"Main methods."*/
- (void) popUpContextMenuWithEvent: (NSEvent *) theEvent;
- (BOOL) willPopUp;
/*"Overriden methods."*/
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2ButtonMixed

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2HistoryButton


extern NSString * const iTM2ToggleEditableNotification;
extern NSString * const iTM2ToggleEditableKey;

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2HistoryButton

@interface NSButton(iTeXMac2)
+ (NSButton *) buttonFirst;
+ (NSButton *) buttonLast;
+ (NSButton *) buttonPrevious;
+ (NSButton *) buttonNext;
+ (NSButton *) buttonPreviousPrevious;
+ (NSButton *) buttonNextNext;
+ (NSButton *) buttonForward;
+ (NSButton *) buttonBack;
- (void) fixImageNamed: (NSString *) name inBundle: (NSBundle *) B;
- (void) fixImageNamed: (NSString *) argument;
- (void) fixImage;
@end

@interface iTM2ButtonRWStatus: NSButton
@end;

@interface iTM2ButtonForward: iTM2ButtonMixed
@end

@interface iTM2ButtonBack: iTM2ButtonMixed
@end

@interface iTM2ButtonNavigation: NSButton
@end

@interface iTM2ButtonFirst: iTM2ButtonNavigation
@end

@interface iTM2ButtonLast: iTM2ButtonNavigation
@end

@interface iTM2ButtonPrevious: iTM2ButtonNavigation
@end

@interface iTM2ButtonNext: iTM2ButtonNavigation
@end

@interface iTM2ButtonPreviousPrevious: iTM2ButtonNavigation
@end

@interface iTM2ButtonNextNext: iTM2ButtonNavigation
@end

@interface iTM2ButtonPlus: NSButton
@end

@interface iTM2ButtonMinus: NSButton
@end

@interface iTM2MixedButton: NSButton
{
@private
	id popUp;
}
-(void) setup;
- (id) popUp;
- (void) setPopUp: (id) cell;
- (SEL)doubleAction;
- (void)setDoubleAction:(SEL)aSelector;
@end
@interface iTM2MixedButtonCell: NSButtonCell
{
@private
	SEL doubleAction;
	id popUpCell;
}
- (BOOL) willPopUp;
- (id) popUpCell;
- (void) setPopUpCell: (id) cell;
- (SEL)doubleAction;
- (void)setDoubleAction:(SEL)aSelector;
- (BOOL) isDoubleValid;
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2ButtonKit

