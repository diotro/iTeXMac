/*
//
//  @version Subversion: $Id$ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Tue Sep 11 2001.
//  Copyright © 2001-2004 Laurens'Tribune. All rights reserved.
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

#import <iTM2TeXFoundation/iTM2TeXProjectCommandKit.h>
#import <iTM2TeXFoundation/iTM2TeXProjectFrontendKit.h>

extern NSString * const iTM2ToolbarTypesetItemIdentifier;

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2TeXProjectIndex

/*! 
    @class      iTM2TeXPCommandWrapperKit
    @abstract   A kit of basic commands.
    @discussion When a project is not base, or has custom settings, these inspectors are used to fix them.
                The advanced project inspector is used to edit the settings.
                When the user switches to the action pane, he can switch with a popup to the command he wants to customize.
                Then he can used base settings or use customized ones.
                When he presses the edit button, the appropriate inspector is displayed, one of the following,
                except for the compile switcher which lives in the iTM2TeXPCompileWrapperKit.
*/

@interface iTM2TeXPIndexInspector: iTM2TeXPCommandInspector
@end

@interface iTM2TeXPGlossaryInspector: iTM2TeXPIndexInspector
@end

@interface iTM2TeXPBibliographyInspector: iTM2TeXPCommandInspector
@end

@interface iTM2TeXPTypesetInspector: iTM2TeXPCommandInspector
@end

@interface iTM2TeXPRenderInspector: iTM2TeXPCommandInspector
@end

@interface iTM2TeXPCleanInspector: iTM2TeXPCommandInspector
@end

@interface iTM2TeXPSpecialInspector: iTM2TeXPCommandInspector
@end

@interface NSToolbarItem(iTM2TeXProjectCommandKit)
+ (NSToolbarItem *)typesetCurrentProjectToolbarItem;
+ (NSToolbarItem *)stopTypesetCurrentProjectToolbarItem;
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2TeXPCommandWrapperKit
