/*
//  TBR Tutorial
//
//  @version Subversion: $Id$ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Wed Jun 27 2001.
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



extern NSString * const iTM2PDFSheetBackgroundColorKey;
extern NSString * const iTM2PDFUseSheetBackgroundColorKey;

extern NSString * const iTM2PDFImageRepresentationDidChangeNotification;
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2PDFImageRepView

@interface iTM2PDFImageRepView: NSView
{
@private
    NSInteger iVarTag;
    NSInteger iVarState;
    BOOL iVarDrawsBoundary;
    NSPoint iVarAbsoluteFocusPoint;
    NSColor * iVarBackgroundColor;
    NSPDFImageRep * iVarRepresentation;
    id iVarContextManager;
    NSPoint iVarSynchronizationPoint;
}
@property (readonly) NSSize inset;
@property (readonly) NSSize minFrameSize;
@property (readonly) NSRect drawingBounds;
@property NSInteger tag;
@property NSInteger state;
@property BOOL drawsBoundary;
@property NSPoint focusPoint;
@property NSPoint synchronizationPoint;
@property (retain) NSColor * backgroundColor;
@property (assign) NSPDFImageRep * imageRepresentation;
@property (assign) id contextManager;
@end

extern NSString * const iTM2PDFViewerBackgroundColorKey;
extern NSString * const iTM2PDFUseViewerBackgroundColorKey;

extern NSString * const iTM2PDFNewPageModeKey;
extern NSString * const iTM2PDFPageLayoutModeKey;
extern NSString * const iTM2PDFSlidesLandscapeModeKey;

extern NSString * const iTM2LogicalPageNumberDidChangeNotification;
extern NSString * const iTM2FocusedPageNumberDidChangeNotification;

typedef enum _iTM2PDFNewPageMode
{
    iTM2TopLeft = 0,
    iTM2TopCenter = 1,
    iTM2TopRight = 2,
    iTM2Center = 3,
    iTM2Unchanged = 4,
    iTM2Remember = 5
} iTM2PDFNewPageMode;

typedef enum _iTM2PDFPageLayout
{
    iTM2PDFSinglePageLayout = 0,
    iTM2PDFOneColumnLayout,
    iTM2PDFTwoColumnLeftLayout,
    iTM2PDFTwoColumnRightLayout
} iTM2PDFPageLayout;

@interface iTM2PDFView: NSView
{
@private
    id iVarImageRepresentation;
    id iVarCachedImageRepresentation;
    NSPoint iVarAbsoluteFocus;
    float iVarMagnification;
    NSUInteger iVarPageLayout;
    NSInteger iVarCurrentLogicalPage;
    NSInteger iVarOrientationMode;
    BOOL iVarNewPage;
    BOOL iVarNeedsUpdateGeometry;
}
/*"Class methods"*/
/*"Setters and Getters"*/
- (void)imageRepresentationDidChange;
- (void)magnificationDidChange;
- (void)pageLayoutDidChange;
- (void)currentPageDidChange;
- (void)selectViewWithTag:(NSInteger)tag;
- (id)focusView;
/*"Main methods"*/
- (NSSize)pageFrameSizeWithMagnification:(float)aMagnification;
- (void)recache;
- (void)updateGeometry;
- (void)placeFocusPointInVisibleArea;
- (void)updateFocusInformation;
- (void)updateFocusInformationWithPoint:(NSPoint)P;
- (void)updateGeometry;
/*"Overriden methods"*/
@property (retain) NSPDFImageRep * imageRepresentation;
@property (readonly,retain) NSPDFImageRep * cachedImageRepresentation;
@property (readonly) NSColor * backgroundColor;
@property float magnification;
@property NSUInteger pageLayout;
@property (readonly) NSInteger softCurrentPhysicalPage;
@property (readonly) id selectedView;
@property NSInteger PDFOrientation;
@property NSInteger currentPhysicalPage;
@property NSInteger currentLogicalPage;
@property (readonly) BOOL newPage;
@property BOOL needsUpdateGeometry;
@end

#import "iTM2ViewKit.h"

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2PDFPrintKit
@interface iTM2PDFPrintView: NSView
{
@private
    NSPDFImageRep * iVarImageRepresentation;
    float iVarScale;
    BOOL iVarSlidesLandscape;
}
- (id)initWithRepresentation:(id)aRepresentation slidesLandscape:(BOOL)flag scale:(float)scale;
- (void)drawRect:(NSRect)aRect;
- (BOOL)knowsPageRange:(NSRangePointer)range;
- (NSRect)rectForPage:(NSInteger)pageNumber;
- (BOOL)isVerticallyCentered;
- (BOOL)isHorizontallyCentered;
@property (retain) NSPDFImageRep * imageRepresentation;
@property float scale;
@property BOOL slidesLandscape;
@property (readonly) NSInteger pageCount;
@end


//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2PDFView

