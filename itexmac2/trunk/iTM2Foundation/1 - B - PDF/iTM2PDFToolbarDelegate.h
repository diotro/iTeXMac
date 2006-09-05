/*
//  iTeXMac
//
//  @version Subversion: $Id$ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Sun Jan 06 2002.
//  Copyright © 2001 Laurens'Tribune. All rights reserved.
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

#import <iTM2Foundation/iTM2RepToolbarDelegate.h>

extern NSString * const iTM2ToolbarNavigationFieldItemIdentifier;
extern NSString * const iTM2ToolbarNavigationSetItemIdentifier;
extern NSString * const iTM2ToolbarPreviousSetItemIdentifier;
extern NSString * const iTM2ToolbarNextSetItemIdentifier;
extern NSString * const iTM2ToolbarPreviousMixedSetItemIdentifier;
extern NSString * const iTM2ToolbarNextMixedSetItemIdentifier;
extern NSString * const iTM2ToolbarFirstButtonItemIdentifier;
extern NSString * const iTM2ToolbarPreviousButtonItemIdentifier;
extern NSString * const iTM2ToolbarPreviousPreviousButtonItemIdentifier;
extern NSString * const iTM2ToolbarLastButtonItemIdentifier;
extern NSString * const iTM2ToolbarNextButtonItemIdentifier;
extern NSString * const iTM2ToolbarNextNextButtonItemIdentifier;
extern NSString * const iTM2ToolbarBackButtonItemIdentifier;
extern NSString * const iTM2ToolbarForwardButtonItemIdentifier;
extern NSString * const iTM2ToolbarHistorySetItemIdentifier;

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2PDFToolbarDelegate

@interface iTM2PDFToolbarDelegate: iTM2RepToolbarDelegate
{
@private
    NSString * __LastNavigationITII;
    NSTextField * _NavigationField;
    NSMenu * _BackMenu;
    NSMenu * _ForwardMenu;
}
/*"Class methods"*/
/*"Setters and Getters"*/
- (NSTextField *)navigationFieldForToolbar;
- (NSTextField *)navigationFieldForPalette;
- (NSView *)navigationSetForToolbar;
- (NSView *)navigationSetForPalette;
- (NSView *)previousSet;
- (NSView *)previousMixedSet;
- (NSView *)nextMixedSet;
- (NSView *)nextSet;
- (NSView *)historySet;
- (NSButton *)buttonFirst;
- (NSButton *)buttonPrevious;
- (NSButton *)buttonPreviousPrevious;
- (NSButton *)buttonLast;
- (NSButton *)buttonNext;
- (NSButton *)buttonNextNext;
- (NSButton *)buttonBack;
- (NSButton *)buttonForward;
- (NSTextField *)navigationField;
- (void)setNavigationField:(NSTextField *)aTextField;
- (id)backMenu;
- (void)setBackMenu:(NSMenu *)aMenu;
- (id)forwardMenu;
- (void)setForwardMenu:(NSMenu *)aMenu;
/*"Main methods"*/
- (NSArray *)toolbarDefaultItemIdentifiers:(NSToolbar*)aToolbar;
- (NSArray *)toolbarAllowedItemIdentifiers:(NSToolbar*)aToolbar;
- (NSToolbarItem *)toolbar:(NSToolbar *)aToolbar itemForItemIdentifier:(NSString *)anItemIdentifier willBeInsertedIntoToolbar:(BOOL)aFlag;
/*"Overriden methods"*/
- (id)init;
- (void)dealloc;
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2PDFToolbarDelegate
