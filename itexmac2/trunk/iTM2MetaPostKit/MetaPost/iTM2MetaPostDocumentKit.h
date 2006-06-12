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
- (id) PDFKitDocumentForFileName: (NSString *) argument;
- (void) addPDFDocumentFileName: (NSString *) argument;
- (void) removePDFDocumentFileName: (NSString *) argument;
@end

@interface iTM2MetaPostInspector: iTM2TextInspector
{
@private
    IBOutlet PDFView *_pdfView;
    IBOutlet NSDrawer *_drawer;
    IBOutlet NSView *_drawerView;
//    IBOutlet NSTabView *_pdfTabView;
//    IBOutlet NSSegmentedControl *_tabViewControl;
    IBOutlet NSTableView *_thumbnailTable;
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
    IBOutlet NSSegmentedControl *_toolbarToolModeView;
    IBOutlet NSSegmentedControl *_toolbarBackForwardView;
//    IBOutlet NSPopUpButton *_toolbarDisplayBoxView;
}
- (id) currentOutputFigure;
- (NSArray *) outputFigureNumbers;
- (void) setOutputFigureNumbers: (id) argument;
- (void) setCurrentOutputFigure: (id) argument;
- (id) currentPDFKitDocument;
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
- (void) highlightAndScrollMetaPostFigureToVisible: (int) figure;
@end
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2MetaPostWrapperKit
