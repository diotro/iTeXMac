/*
//  iTM2PDFKit.h
//  iTeXMac2
//
//  @version Subversion: $Id$ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Sun Jun 24 2001.
//  Copyright © 2001-2004 Laurens'Tribune. All rights reserved.
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

#import <iTM2Foundation/iTM2PDFDocumentKit.h>

extern NSString * const iTM2PDFKitInspectorMode;
extern NSString * const iTM2PDFKitToolbarIdentifier;
extern NSString * const iTM2PDFKitKeyBindingsIdentifier;

extern NSString * const iTM2MultiplePDFDocumentType;

extern NSString * const iTM2PDFKitViewerDefaultsDidChangeNotification;

typedef enum
{
    kiTM2ScrollToolMode = 0, 
    kiTM2TextToolMode = 1, 
    kiTM2SelectToolMode = 2, 
    kiTM2AnnotateToolMode = 3
} iTM2ToolMode;

typedef enum
{
    iTM2PDFDocumentNoErrorStatus = 0, 
    iTM2PDFDocumentPendingStatus = 1, 
    iTM2PDFDocumentErrorStatus = 2
} iTM2PDFDocumentStatus;

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2PDFKitInspector

extern NSString * const iTM2ToolbarNextPageItemIdentifier;
extern NSString * const iTM2ToolbarPreviousPageItemIdentifier;
extern NSString * const iTM2ToolbarPageItemIdentifier;
extern NSString * const iTM2ToolbarZoomInItemIdentifier;
extern NSString * const iTM2ToolbarZoomOutItemIdentifier;
extern NSString * const iTM2ToolbarScaleItemIdentifier;
extern NSString * const iTM2ToolbarBackForwardItemIdentifier;
extern NSString * const iTM2ToolbarToolModeItemIdentifier;
extern NSString * const iTM2ToolbarRotateLeftItemIdentifier;
extern NSString * const iTM2ToolbarRotateRightItemIdentifier;
extern NSString * const iTM2ToolbarToggleDrawerItemIdentifier;
extern NSString * const iTM2ToolbarActualSizeItemIdentifier;
extern NSString * const iTM2ToolbarDoZoomToSelectionItemIdentifier;
extern NSString * const iTM2ToolbarDoZoomToFitItemIdentifier;

@interface iTM2PDFKitWindow: iTM2Window
@end

@interface iTM2PDFKitInspector: iTM2Inspector
{
@private
// These outlets come from Preview's PVPDFDocument.nib
    IBOutlet PDFView *_pdfView;
    IBOutlet NSDrawer *_drawer;
    IBOutlet NSView *_drawerView;
    IBOutlet NSTabView *_pdfTabView;
    IBOutlet NSSegmentedControl *_tabViewControl;
    IBOutlet NSTableView *_thumbnailTable;
    IBOutlet NSOutlineView *_outlinesView;
    IBOutlet NSTextField *_searchCountText;
    IBOutlet NSSearchField *_searchField;
    IBOutlet NSProgressIndicator *_searchProgress;
    IBOutlet NSTableView *_searchTable;
    IBOutlet NSTextField *_scaleView;
    IBOutlet NSTextField *_pageNumView;
    IBOutlet NSView *_printAppendView;
    IBOutlet NSButton *_printButton;
    IBOutlet NSButton *_softProofButton;
    IBOutlet NSSegmentedControl *_toolbarToolModeView;
    IBOutlet NSSegmentedControl *_toolbarBackForwardView;
    IBOutlet NSPopUpButton *_toolbarDisplayBoxView;
}
- (PDFView *)pdfView;
- (iTM2PDFDocumentStatus)PDFDocumentStatus;
- (void)setPDFDocumentStatus:(iTM2PDFDocumentStatus)status;
@property (retain) PDFView *_pdfView;
@property (retain) NSDrawer *_drawer;
@property (retain) NSView *_drawerView;
@property (retain) NSTabView *_pdfTabView;
@property (retain) NSSegmentedControl *_tabViewControl;
@property (retain) NSTableView *_thumbnailTable;
@property (retain) NSOutlineView *_outlinesView;
@property (retain) NSTextField *_searchCountText;
@property (retain) NSSearchField *_searchField;
@property (retain) NSProgressIndicator *_searchProgress;
@property (retain) NSTableView *_searchTable;
@property (retain) NSTextField *_scaleView;
@property (retain) NSTextField *_pageNumView;
@property (retain) NSView *_printAppendView;
@property (retain) NSButton *_printButton;
@property (retain) NSButton *_softProofButton;
@property (retain) NSSegmentedControl *_toolbarToolModeView;
@property (retain) NSSegmentedControl *_toolbarBackForwardView;
@property (retain) NSPopUpButton *_toolbarDisplayBoxView;
@end

@interface iTM2PDFKitResponder: iTM2AutoInstallResponder
@end

@interface iTM2PDFDocument(Cluster)
@end

@interface iTM2PDFKitDocument: iTM2PDFDocument
- (PDFDocument *)PDFDocument;
- (void)setPDFDocument:(id)PDFDoc;
- (iTM2PDFDocumentStatus)PDFDocumentStatus;
- (void)setPDFDocumentStatus:(iTM2PDFDocumentStatus)satus;
@end

typedef int iTM2PDFAreaOfInterest;
enum
{
    kiTM2PDFZoomInArea = 1<<25, 
    kiTM2PDFZoomOutArea = 1<<26, 
    kiTM2PDFSelectArea = 1<<27, 
    kiTM2PDFSelectLeftArea = 1<<28, 
    kiTM2PDFSelectRightArea = 1<<29, 
    kiTM2PDFSelectTopArea = 1<<30, 
    kiTM2PDFSelectBottomArea = 1<<31
};

@interface iTM2PDFKitView: PDFView
{
@private
	id _Implementation;
	id _SyncDestination;
	id _SyncPointValues;
	id _SyncDestinations;
}
@property (retain) id _Implementation;
@property (retain) id _SyncDestination;
@property (retain) id _SyncPointValues;
@property (retain) id _SyncDestinations;
@end

@interface PDFView(iTM2SYNCKit)
- (void)scrollDestinationToVisible:(PDFDestination *)destination;
- (void)zoomToFit:(id)sender;
- (BOOL)pdfSynchronizeMouseDown:(NSEvent *)theEvent;
- (iTM2ToolMode)toolMode;
- (void)setToolMode:(iTM2ToolMode)argument;
@end

@interface PDFPage(iTM2SYNCKit)

/*!
    @method     characterIndexNearPoint:
    @abstract   The character index near the point
    @discussion Return the character index at poin, or at the edges of the square centered at the point and with side 10 pts.
    @param		point is the point possibly near some character
    @result     The character index as int
*/
- (int)characterIndexNearPoint:(NSPoint)point;

/*!
    @method     localToGlobalCharacterIndex:
    @abstract   Character index conversion
    @discussion Use the character offset of the page maintained by the document.
    @param		globalIndex is a global index
    @result     An index in the local coordinates
*/
- (int)localToGlobalCharacterIndex:(int)globalIndex;

/*!
    @method     globalToLocalCharacterIndex:
    @abstract   Character index conversion
    @discussion Use the character offset of the page maintained by the document.
    @param		localIndex is a local index
    @result     An index in the global coordinates
*/
- (int)globalToLocalCharacterIndex:(int)localIndex;

@end

typedef struct
{
	NSRange range;
	unsigned int pageIndex;
} iTM2Position;

@interface iTM2XtdPDFDocument: PDFDocument
{
@private
	unsigned int * __PageStringOffsets;
	id __CachedPageStrings;
}
/*!
    @method     characterOffsetForPageAtIndex:
    @abstract   (brief description)
    @discussion (comprehensive description)
    @result     (description)
*/
- (unsigned int)characterOffsetForPageAtIndex:(unsigned int)pageIndex;
/*!
    @method     pageIndexForCharacterIndex:
    @abstract   (brief description)
    @discussion (comprehensive description)
    @result     (description)
*/
- (unsigned int)pageIndexForCharacterIndex:(unsigned int)characterIndex;
/*!
    @method     positionOfWord:options:range:
    @abstract   Find the position of the given word
    @discussion The position is given by a page index and a range collected in one iTM2Position record
				The word is defined by the NSString's doubleClick:atIndex: method.
				For example "raclure" et "raclures" are not equal, such that when looking for the first one,
				the second one will be ignored.
	@param		aWord is the word we are looking for
	@param		mask is the mask (similar to the one in NSString's rangeOfString:options:range: method
	@param		range is the range where we should look for the word.
    @result     (description)
*/
- (iTM2Position)positionOfWord:(NSString *)aWord options:(unsigned)mask range:(NSRange)searchRange;
/*!
    @method     positionsOfWordBefore:here:after:index:
    @abstract   See the discussion.
	@discussion	All the positions of the given words ordered in a dictionary for which keys are weights,
				and values are an array of all the positions of the same weight.
				The weight is the length of the matching string.
				Roughly speaking, the matching string matches "before".*"here".*"after", as three words.
				Each time we find an occurrence of the word before followed by an occurrence of the word after,
				with no occurrence of each of them between, we look for each occurrence of the word here between
				and we return the low left point corresponding to bounding box of the hitIndex'th character of word "here".
	@param		before: a word.
	@param		here: a word.
	@param		after: a word.
	@param		hitIndex: 0 if we double click on the first character, 1 one the second, 2 on the third...
	@param		searchRange: the range where we are expected to find the string...
    @result     A dictionary
*/
- (NSDictionary *)positionsOfWordBefore:(NSString *)before here:(NSString *)here after:(NSString *)after index:(unsigned int)hitIndex;
- (NSDictionary *)positionsOfWordBefore:(NSString *)before here:(NSString *)hit after:(NSString *)after index:(unsigned int)hitIndex inRange:(NSRange)searchRange;

/*!
    @method     stringForPage:
    @abstract   Cached string of the given page
    @discussion (comprehensive description)
    @result     (description)
*/
- (NSString *)stringForPage:(PDFPage *)page;

@property unsigned int * __PageStringOffsets;
@property (retain) id __CachedPageStrings;
@end

@interface iTM2IconSegmentedControl: NSSegmentedControl
@end

@interface iTM2MultiplePDFKitDocument: iTM2PDFKitDocument
@end

@interface iTM2MultiplePDFDocument: PDFDocument
{
@private
	NSMutableDictionary * __PDFKitDocuments;
	NSMutableArray * __OrderedFileNames;
	NSMutableDictionary * __IndexForPageCache;
}
@property (retain) NSMutableDictionary * __PDFKitDocuments;
@property (retain) NSMutableArray * __OrderedFileNames;
@property (retain) NSMutableDictionary * __IndexForPageCache;
@end

@interface NSImage(iTM2PDFKit)
+ (NSImage *)iTM2_imageCaution;
+ (NSImage *)iTM2_imageDebugScrollToolbarImage;
+ (NSImage *)iTM2_imageGrabber;
+ (NSImage *)iTM2_imageLandscape;
+ (NSImage *)iTM2_imagePortrait;
+ (NSImage *)iTM2_imageReverseLandscape;
+ (NSImage *)iTM2_imageTBRotateLeft;
+ (NSImage *)iTM2_imageTBRotateRight;
+ (NSImage *)iTM2_imageTBSizeToFit;
+ (NSImage *)iTM2_imageTBSnowflake;
+ (NSImage *)iTM2_imageTBZoomActualSize;
+ (NSImage *)iTM2_imageTBZoomIn;
+ (NSImage *)iTM2_imageTBZoomOut;
+ (NSImage *)iTM2_imageThumbnailViewAdorn;
+ (NSImage *)iTM2_imageTOCViewAdorn;
+ (NSImage *)iTM2_imageBackAdorn;
+ (NSImage *)iTM2_imageForwardAdorn;
+ (NSImage *)iTM2_imageGenericImageDocument;
+ (NSImage *)iTM2_imageMoveToolAdorn;
+ (NSImage *)iTM2_imageTextToolAdorn;
+ (NSImage *)iTM2_imageSelectToolAdorn;
+ (NSImage *)iTM2_imageAnnotateTool1Adorn;
+ (NSImage *)iTM2_imageAnnotateTool1AdornDisclosure;
+ (NSImage *)iTM2_imageAnnotateTool2Adorn;
+ (NSImage *)iTM2_imageAnnotateTool2AdornDisclosure;
@end

@interface NSToolbarItem(iTM2PDFKit)
+ (NSToolbarItem *)goToNextPageToolbarItem;
+ (NSToolbarItem *)goToPreviousPageToolbarItem;
+ (NSToolbarItem *)takePageFromToolbarItem;
+ (NSToolbarItem *)zoomInToolbarItem;
+ (NSToolbarItem *)zoomOutToolbarItem;
+ (NSToolbarItem *)takeScaleFromToolbarItem;
+ (NSToolbarItem *)goBackForwardToolbarItem;
+ (NSToolbarItem *)takeToolModeFromSegmentToolbarItem;
+ (NSToolbarItem *)rotateLeftToolbarItem;
+ (NSToolbarItem *)rotateRightToolbarItem;
+ (NSToolbarItem *)actualSizeToolbarItem;
+ (NSToolbarItem *)doZoomToSelectionToolbarItem;
+ (NSToolbarItem *)doZoomToFitToolbarItem;
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= PDFKit  =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

