/*
//  iTM2PDFView.h
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
    int _Tag;
    int _State;
    BOOL _DrawsBoundary;
    NSPoint _AbsoluteFocusPoint;
    NSColor * _BackgroundColor;
    NSPDFImageRep * _Representation;
    id _ContextManager;
    NSPoint _SynchronizationPoint;
}
/*"Class methods"*/
/*"Setters and Getters"*/
- (NSPDFImageRep *) imageRepresentation;
- (void) setImageRepresentation: (NSPDFImageRep *) value;
- (NSSize) inset;
- (NSSize) minFrameSize;
- (int) tag;
- (void) setTag: (int) anInt;
- (int) state;
- (void) setState: (int) value;
- (NSPoint) focusPoint;
- (void) setFocusPoint: (NSPoint) value;
- (NSRect) drawingBounds;
- (BOOL) drawsBoundary;
- (void) setDrawsBoundary: (BOOL) flag;
- (NSPoint) synchronizationPoint;
- (void) setSynchronizationPoint: (NSPoint) P;
/*"Main methods"*/
/*"Overriden methods"*/
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
    id _ImageRepresentation;
    id _CachedImageRepresentation;
    NSPoint _AbsoluteFocus;
    float _Magnification;
    unsigned _PageLayout;
    int _CurrentLogicalPage;
    int _OrientationMode;
    BOOL _NewPage;
    BOOL _NeedsUpdateGeometry;
}
/*"Class methods"*/
/*"Setters and Getters"*/
- (id) imageRepresentation;
- (void) setImageRepresentation: (id) aImageRepresentation;
- (void) imageRepresentationDidChange;
- (float) magnification;
- (void) setMagnification: (float) aMagnification;
- (void) magnificationDidChange;
- (id) cachedImageRepresentation;
- (BOOL) needsToUpdateGeometry;
- (void) setNeedsUpdateGeometry: (BOOL) flag;
- (NSColor *) backgroundColor;
- (unsigned) pageLayout;
- (void) setPageLayout: (unsigned) PL;
- (void) pageLayoutDidChange;
- (int) softCurrentPhysicalPage;
- (int) currentPhysicalPage;
- (void) setCurrentPhysicalPage: (int) aCurrentPhysicalPage;
- (int) currentLogicalPage;
- (void) setCurrentLogicalPage: (int) aCurrentLogicalPage;
- (void) currentPageDidChange;
- (int) PDFOrientation;
- (void) setPDFOrientation: (int) argument;
- (id) selectedView;
- (void) selectViewWithTag: (int) tag;
- (id) focusView;
/*"Main methods"*/
- (NSSize) pageFrameSizeWithMagnification: (float) aMagnification;
- (void) recache;
- (void) updateGeometry;
- (void) placeFocusPointInVisibleArea;
- (void) updateFocusInformation;
- (void) updateFocusInformationWithPoint: (NSPoint) P;
- (void) updateGeometry;
/*"Overriden methods"*/
@end

#import <iTM2Foundation/iTM2ViewKit.h>

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2PDFPrintKit
@interface iTM2PDFPrintView: iTM2View 
/*"Setters and getters"*/
- (id) imageRepresentation;
- (void) setImageRepresentation: (id) anImageRep;
- (float) scale;
- (void) setScale: (float) scale;
- (BOOL) slidesLandscape;
- (void) setSlidesLandscape: (BOOL) yorn;
/*"Main methods"*/
- (id) initWithRepresentation: (id) aRepresentation slidesLandscape: (BOOL) flag scale: (float) scale;
- (int) pageCount;
/*"Overriden methods"*/
- (void) drawRect: (NSRect) aRect;
- (BOOL) knowsPageRange: (NSRangePointer) range;
- (BOOL) isVerticallyCentered;
- (BOOL) isHorizontallyCentered;
- (NSRect) rectForPage: (int) pageNumber;
@end


//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2PDFView

