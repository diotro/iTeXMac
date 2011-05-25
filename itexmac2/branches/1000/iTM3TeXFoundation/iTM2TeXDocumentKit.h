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
extern NSString * const iTM2TeX7bitsAccentsKey;

@interface iTM2TeXDocument: iTM2TextDocument
@end

@interface iTM2TeXInspector: iTM2TextInspector <NSToolbarDelegate>
@end

@interface iTM2TeXWindow: iTM2TextWindow
@end

@interface iTM2TeXEditor: iTM2TextEditor
{
@private
    struct __iTMTVFlags
    {
        NSUInteger isDeepEscaped: 1;
        NSUInteger isEscaped: 1;
        NSUInteger smartInsert: 1;
        NSUInteger smartInsertIsLocal: 1;
        NSUInteger autoIndent: 1;
        NSUInteger autoIndentIsLocal: 1;
        NSUInteger shiftDelete: 1;
        NSUInteger shiftDeleteIsLocal: 1;
        NSUInteger shouldAntialias: 1;
        NSUInteger shouldAntialiasIsLocal: 1;
        NSUInteger tempAttrArePending: 1;
        NSUInteger rectAlreadyDrawnOnce: 1;
        NSUInteger wrapTextPosted: 1;
        NSUInteger reserved: 19;
    } _iTMTVFlags;
}
- (void)scrollInputToVisible:(NSMenuItem *)sender;
- (void)delayedScrollInputToVisible:(NSMenuItem *)sender;
@end

@interface iTM2TeXBookmarkButton: NSPopUpButton
@end

@interface iTM2ScriptUserButton: NSPopUpButton
@end

@interface iTM2ScriptRecentButton: NSPopUpButton
@end

@interface iTM2TextStorage(DoubleClick)
- (NSRange)smartDoubleClickAtIndex:(NSUInteger)index;
@end

@interface NSTextView(TeXMacro)
- (NSString *)concreteReplacementStringForTeXMacro4iTM3:(NSString *)macro selection:(NSString *)selectedString line:(NSString *)line;
@end
