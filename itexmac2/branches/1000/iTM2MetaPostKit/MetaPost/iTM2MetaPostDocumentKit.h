/*
//  iTM2MetaPostWrapperKit.h
//  iTeXMac2
//
//  @version Subversion: $Id$ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net today.
//  Copyright © 2005 Laurens'Tribune. All rights reserved.
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

extern NSString * const iTM2MetaPostDocumentType;
extern NSString * const iTM2MetaPostInspectorType;
extern NSString * const iTM2MetaPostInspectorMode;

@interface iTM2MetaPostDocument: iTM2TextDocument
- (id)PDFKitDocumentForFileURL:(NSURL *)argument;
- (void)addPDFDocumentFileURL:(NSURL *)argument;
- (void)removePDFDocumentFileURL:(NSURL *)argument;
@end

@interface iTM2MetaPostInspector: iTM2TextInspector <NSToolbarDelegate>
{
@private
    IBOutlet PDFView * iVarPdfView4iTM3;
    IBOutlet NSDrawer * iVarDrawer4iTM3;
    IBOutlet NSView * iVarDrawerView4iTM3;
//    IBOutlet NSTabView *_pdfTabView;
//    IBOutlet NSSegmentedControl *_tabViewControl;
    IBOutlet NSTableView * iVarThumbnailTable4iTM3;
//    IBOutlet NSOutlineView *_outlinesView;
//    IBOutlet NSTextField *_searchCountText;
//    IBOutlet NSSearchField *_searchField;
//    IBOutlet NSProgressIndicator *_searchProgress;
//    IBOutlet NSTableView *_searchTable;
//    IBOutlet NSTextField *_scaleView;
//    IBOutlet NSTextField *_pageNumView;
//    IBOutlet NSView *_printAppendView;
//    IBOutlet NSButton *_printButton;
//    IBOutlet NSButton *_softProofButton;
    IBOutlet NSSegmentedControl * iVarToolbarToolModeView4iTM3;
    IBOutlet NSSegmentedControl * iVarToolbarBackForwardView4iTM3;
//    IBOutlet NSPopUpButton *_toolbarDisplayBoxView;
    iTM2ToolMode iVarToolMode4iTM3;
}
- (NSArray *)outputFigureNumbers;
- (void)setOutputFigureNumbers:(id)argument;
- (id)currentPDFKitDocument;
@property (retain) PDFView * pdfView;
@property (retain) NSDrawer * drawer;
@property (retain) NSView * drawerView;
@property (retain) NSTableView * thumbnailTable;
@property (retain) NSSegmentedControl * toolbarToolModeView;
@property (retain) NSSegmentedControl * toolbarBackForwardView;
@property (assign) iTM2ToolMode toolMode;
@property (assign,readwrite) NSNumber * currentOutputFigure;
@end

@interface iTM2MetaPostWindow: iTM2TextWindow
@end

@interface iTM2MetaPostEditor: iTM2TextEditor
@end

@interface iTM2MetaPostPDFView: iTM2PDFKitView
@end

@interface iTM2MetaPostFigureButton: NSPopUpButton
@end

@interface NSTextView(iTM2MetaPostKit)
- (void)highlightAndScrollMetaPostFigureToVisible4iTM3:(NSInteger)figure;
@end
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2MetaPostWrapperKit
