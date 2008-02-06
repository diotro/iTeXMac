/*
//
//  @version Subversion: $Id$ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Sun Sep 09 2001.
//  Copyright © 2001-2008 Laurens'Tribune. All rights reserved.
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

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2ValidationKit

@interface NSView(iTM2Validation)
- (BOOL)iTM2_validateUserInterfaceItems;
- (BOOL)iTM2_isValid;
- (BOOL)iTM2_validateWindowContent;
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= NSWindow(iTeXMac2)
@interface NSWindow(iTM2Validation)
- (BOOL)iTM2_validateContent;
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= NSDrawer(iTeXMac2)
@interface NSDrawer(iTM2Validation)
- (BOOL)iTM2_validateContent;
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= NSWindowController(iTeXMac2)
@interface NSWindowController(iTM2Validation)
- (BOOL)iTM2_validateWindowContent;
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= NSWindowController(iTeXMac2)
@interface NSDocument(iTM2Validation)
- (BOOL)iTM2_validateWindowsContents;
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= NSCell(iTeXMac2)

@interface NSCell(iTM2Validation)
- (BOOL)iTM2_isValid;
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= NSControl(iTeXMac2)

@interface NSControl(iTM2Validation)
- (BOOL)iTM2_isValid;
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= NSToolbar(iTM2Validation)

@interface NSToolbar(iTM2Validation)
- (NSWindow *)window;
- (BOOL)iTM2_validateContent;
@end


//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= NSObject(iTM2Validation)

typedef enum _iTM2ValidationStatus
{
    iTM2ValidationStatusNO   =  0,
    iTM2ValidationStatusYES    =  1,    
    iTM2ValidationStatusUnkonwn = 2
} iTM2ValidationStatus;

@interface NSObject(iTM2Validation)
- (BOOL)validateUserInterfaceItem:(id)sender;
+ (iTM2ValidationStatus)iTM2_target:(id)target validateUserInterfaceItem:(id)sender;
- (IBAction)noop:(id)sender;// do nothing: message catcher
- (BOOL)validateNoop:(id)sender;// always return NO such that the sender is not enabled...
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2ValidationKit
