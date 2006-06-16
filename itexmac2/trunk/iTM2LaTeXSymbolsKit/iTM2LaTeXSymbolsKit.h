/*
//  iTM2LaTeXSymbolsKit.h
//  iTeXMac2
//
//  @version Subversion: $Id$ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Mon Jun 24 2002.
//  Copyright (c) 2001 Laurens'Tribune. All rights reserved.
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

#import <Cocoa/Cocoa.h>
#import "iTM2DMenuKit.h"

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  iTM2SymbolMenu

@interface iTM2SymbolMenu: iTM2GridMenu
{
@private
    id _Image;
}
/*"Class methods"*/
/*"Setters and Getters"*/
-(NSImage *)image;
/*"Main methods"*/
/*"Overriden methods"*/
@end

#define INTF(arg) @interface arg: iTM2SymbolMenu @end
INTF(iTM2LaTeXArrowsMenu)
INTF(iTM2LaTeXRelationsMenu)
INTF(iTM2LaTeXRelationsNotMenu)
INTF(iTM2LaTeXBinaryMenu)
INTF(iTM2LaTeXMiscMenu)
INTF(iTM2LaTeXCalMenu)
INTF(iTM2LaTeXVariableMenu)
INTF(iTM2LaTeXForeignMenu)
INTF(iTM2LaTeXAccentMenu)
INTF(iTM2LaTeXSymbolMenu)
INTF(iTM2LaTeXGreekMenu)
INTF(iTM2LaTeXGreekCapsMenu)
INTF(iTM2AMSArrowsMenu)
INTF(iTM2AMSBinaryMenu)
INTF(iTM2AMSMiscMenu)
INTF(iTM2AMSOrdinaryMenu)
INTF(iTM2AMSRelationCurlMenu)
INTF(iTM2AMSRelationMenu)
INTF(iTM2AMSRelationSetMenu)
INTF(iTM2AMSRelationSimMenu)
INTF(iTM2AMSRelationTriangleMenu)
INTF(iTM2AMSMathbbMenu)
INTF(iTM2AMSMathfrakMenu)
INTF(iTM2AMSMathfrakCapsMenu)
INTF(iTM2MathbbMenu)
INTF(iTM2MathbbCapsMenu)
INTF(iTM2MathbbNumMenu)
INTF(iTM2MathbbGreekMenu)
INTF(iTM2MathrsfsMenu)
INTF(iTM2MVSArrowsMenu)
INTF(iTM2MVSMiscMenu)
INTF(iTM2MVSDeskMenu)
INTF(iTM2MVSZodiacMenu)
INTF(iTM2MVSNumbersMenu)
INTF(iTM2WSBoxMenu)
INTF(iTM2WSMathMenu)
INTF(iTM2WSMiscMenu)
INTF(iTM2WSMhoMenu)
INTF(iTM2WSZodiacMenu)

@interface iTM2SymbolMenuItemCell: NSMenuItemCell
{
@private
    BOOL _Bug;
}
/*"Class methods"*/
+(void)toggleFixSymbolMenuBug:(id)sender;
/*"Setters and Getters"*/
/*"Main methods"*/
/*"Overriden methods"*/
@end

@interface NSTextView(iTM2SymbolMenu)
-(IBAction)useLaTeXPackage:(id)sender;
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  iTM2SymbolView

@interface iTM2SymbolView : NSView
@end

@interface iTM2LaTeXSymbolsPanelController: iTM2Inspector
@end

@interface iTM2LaTeXSymbolsPanel: NSPanel
/*"Class methods"*/
+(id)sharedPanel;
/*"Setters and Getters"*/
/*"Main methods"*/
/*"Overriden methods"*/
@end

@interface iTM2SharedResponder(iTM2LaTeXSymbolsKit)
-(IBAction)orderFrontLaTeXSymbolsPanel:(id)sender;
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  iTM2SymbolKit
