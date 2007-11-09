/*
//
//  @version Subversion: $Id$ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Fri Sep 05 2003.
//  Copyright © 2006 Laurens'Tribune. All rights reserved.
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

extern NSString * const iTM2TeXDocumentType;
extern NSString * const iTM2TeXInspectorMode;
extern NSString * const iTM2TeXSmartSelectionKey;

@interface iTM2TeXDocument: iTM2TextDocument
@end

@interface iTM2TeXInspector: iTM2TextInspector
@end

@interface iTM2TeXWindow: iTM2TextWindow
@end

@interface iTM2TeXEditor: iTM2TextEditor
{
@private
    struct __iTMTVFlags
    {
        unsigned int isDeepEscaped: 1;
        unsigned int isEscaped: 1;
        unsigned int smartInsert: 1;
        unsigned int smartInsertIsLocal: 1;
        unsigned int autoIndent: 1;
        unsigned int autoIndentIsLocal: 1;
        unsigned int shiftDelete: 1;
        unsigned int shiftDeleteIsLocal: 1;
        unsigned int shouldAntialias: 1;
        unsigned int shouldAntialiasIsLocal: 1;
        unsigned int tempAttrArePending: 1;
        unsigned int rectAlreadyDrawnOnce: 1;
        unsigned int wrapTextPosted: 1;
        unsigned int reserved: 19;
    } _iTMTVFlags;
}
- (void)scrollInputToVisible:(id <NSMenuItem>)sender;
- (void)delayedScrollInputToVisible:(id <NSMenuItem>)sender;
@end

@interface iTM2TeXBookmarkButton: NSPopUpButton
@end

@interface iTM2ScriptUserButton: NSPopUpButton
@end

@interface iTM2ScriptRecentButton: NSPopUpButton
@end

@interface iTM2TextStorage(DoubleClick)
- (NSRange)smartDoubleClickAtIndex:(unsigned)index;
@end

@interface NSTextView(TeXMacro)
- (NSString *)concreteReplacementStringForTeXMacro:(NSString *)macro selection:(NSString *)selectedString line:(NSString *)line;
@end