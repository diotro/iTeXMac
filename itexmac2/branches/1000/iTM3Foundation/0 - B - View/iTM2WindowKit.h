/*
//
//  @version Subversion: $Id: iTM2WindowKit.h 794 2009-10-04 12:33:28Z jlaurens $ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Thu Jul 12 2001.
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


typedef enum _iTM2WindowFrameAutosaveMode 
{
    iTM2WindowFrameCurrentMode = 0, //default mode
    iTM2WindowFrameSavedMode = 1,
	iTM2WindowFrameFixedMode = 2
} iTM2WindowFrameAutosaveMode;

extern NSString * const iTM2FrameSavedWindowKey;
extern NSString * const iTM2FrameFixedWindowKey;
extern NSString * const iTM2FrameCurrentWindowKey;

extern NSString * const iTM2DocumentEditedStatusNotification;

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= NSWindow(iTM2WindowKit)

@interface NSWindow(iTM2WindowKit)
/*"Class methods"*/
- (NSString *)frameIdentifier4iTM3;
//+ (NSRect) frame;
/*"Setters and Getters"*/
- (NSString *)frameAutosaveIdentifierForMode4iTM3:(iTM2WindowFrameAutosaveMode)aMode; // private
- (NSString *)frameAutosaveModeKey4iTM3; // private
- (BOOL)positionShouldBeObserved4iTM3; // YES to record the window position from one session to the other
- (NSString *)windowsMenuItemTitle4iTM3;
- (NSComparisonResult)compareUsingLevel4iTM3:(id)rhs;
- (void)orderBelowFront4iTM3:(id)sender;
@end

@interface NSObject(iTM2WindowKitDelegation)

- (NSString *)frameIdentifierForWindow4iTM3:(NSWindow *)window;// the window delegate supplies the answer to the window's -positionShouldBeObserved4iTM3
- (BOOL)windowPositionShouldBeObserved4iTM3:(NSWindow *)window;// the window delegate supplies the answer to the window's -positionShouldBeObserved4iTM3

@end
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= NSWindow(iTeXMac2)

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= NSWindowController(iTeXMac2)

@interface NSWindowController(iTM2WindowKit)
/*"Class methods"*/
/*"Setters and Getters"*/
/*"Main methods"*/
- (NSString *)windowFrameIdentifier4iTM3;
- (NSString *)windowsMenuItemTitleForDocumentDisplayName4iTM3:(NSString *)displayName;
- (BOOL)windowPositionShouldBeObserved4iTM3;
/*"Overriden methods"*/
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2WindowsObserver

@interface iTM2Window: NSWindow
{
@private
    id _Implementation;
}
@property (retain) id _Implementation;
@end
