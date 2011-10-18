/*
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

#import "iTM2DocumentKit.h"

extern NSString * const iTM2PDFGraphicsInspectorType;
extern NSString * const iTM2PDFNoAutoUpdateKey;
extern NSString * const iTM2PDFImageRepresentationDidChangeNotification;
extern NSString * const iTM2PDFMagnificationDidChangeNotification;

extern NSString * const iTM2PDFNewPageModeKey;

typedef enum
{
    iTM2PDFDisplayModeFixed = 0, // newly created album have allways the same magnification
    iTM2PDFDisplayModeLast = 1, // newly created album have allways the last used magnification
    iTM2PDFDisplayModeStick = 2 // newly created album adapt their magnification to the enclosing view
} iTM2PDFDisplayMode;
extern NSString * const iTM2PDFDisplayModeKey;

// following modes are considered only in iTM2StickMode
typedef enum
{
    iTM2PDFStickToWidthMode = 0,
    iTM2PDFStickToHeightMode = 1,
    iTM2PDFStickToViewMode = 2
} _iTM2PDFDisplayModeStick;
extern NSString * const iTM2PDFStickModeKey;

extern NSString * const iTM2PDFLastMagnificationKey;
extern NSString * const iTM2PDFCurrentMagnificationKey;
extern NSString * const iTM2PDFFixedMagnificationKey;
extern NSString * const iTM2PDFLastMagnificationKey;
extern NSString * const iTM2PDFAlbumDisplayModeKey;
extern NSString * const iTM2PDFAlbumStickModeKey;
extern NSString * const iTM2PDFToolbarIdentifier;

#define iTM2PDFAlbumViewMargin 10

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2PDFAlbumView  =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

#import "iTM2ViewKit.h"

@interface iTM2PDFAlbumView: iTM2CenteringView
{
@private
    BOOL _CanStick;
    BOOL _ParametersHaveChanged;
    NSInteger _CurrentPhysicalPage;
}
/*"Class mathods."*/
/*"Setters and getters."*/
- (NSInteger)currentPhysicalPage;
- (void)setCurrentPhysicalPage:(NSInteger)aCurrentPhysicalPage;
- (NSUInteger)pageLayout;
- (void)setPageLayout:(NSUInteger)PL;
/*"Main mathods."*/
- (CGFloat)magnification;
- (void)setMagnification:(CGFloat)aMagnification;
- (void)setMagnificationWithDisplayMode:(NSInteger)displayMode stickMode:(NSInteger)stickMode;
- (BOOL)parametersHaveChanged;
- (void)setParametersHaveChanged:(BOOL)aFlag;
- (NSInteger)PDFOrientation;
- (void)setPDFOrientation:(NSInteger)argument;
- (id)imageRepresentation;
/*"Overriden methods."*/
- (void)awakeFromNib;
- (CGFloat)ratioContentVersusDocumentWidth;
- (CGFloat)ratioContentVersusDocumentHeight;
- (NSInteger)forwardPhysicalPage;
- (NSInteger)backPhysicalPage;
- (NSInteger)logicalToPhysicalPage:(NSInteger)logicalPage;
- (NSInteger)firstPhysicalPage;
- (NSInteger)lastPhysicalPage;
@property BOOL _CanStick;
@property BOOL _ParametersHaveChanged;
@property NSInteger _CurrentPhysicalPage;
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2PDFDocument  =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

@interface iTM2PDFDocument: iTM2Document
- (id)init; // designated initializer
- (id)imageRepresentation;
- (void)setImageRepresentation:(id)aRepresentation;
- (void)setOriginalFileName:(NSString *)argument;// due to translation dvi, eps -> pdf!!!
/*!
	@method			dataCompleteReadFromURL4iTM3:ofType:error:
	@abstract		Reads the data from the given file.
	@discussion		Just forwards the message to the -readImageRepresentationFromFile:ofType: method.
	@param			fileName
	@param			type
	@param			RORef
	@result			yorn
	@availability	iTM2.
	@copyright		2005 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (BOOL)dataCompleteReadFromURL4iTM3:(NSURL *)fileURL ofType:(NSString *)type error:(NSError**)RORef;
- (BOOL)readImageRepresentationFromURL:(NSURL *)fileURL ofType:(NSString *)type error:(NSError**)RORef;
@end

@interface iTM2PDFWindow: NSWindow
@end

extern NSString * const iTM2PDFInspectorMode;

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2PDFWindowController

@interface iTM2PDFInspector: iTM2Inspector
{
@private
    iTM2PDFAlbumView * _Album4iTM3;
}
/*"Class methods"*/
/*"Setters and Getters"*/
- (NSInteger)firstPhysicalPage;
- (NSInteger)lastPhysicalPage;
- (NSInteger)currentPhysicalPage;
- (void)setCurrentPhysicalPage:(NSInteger)aCurrentPhysicalPage;
- (CGFloat)magnification;
- (void)setMagnification:(CGFloat)magnification;
/*"Main methods"*/
//- (void) synchronizePageWith: (NSNumber *) aCurrentPhysicalPage;
/*"Overriden methods"*/
/*"Overriden methods"*/
@property (retain) iTM2PDFAlbumView * album;
@end

@interface iTM2PDFInspector(KeyStroke)
- (void)doZoomIn:(id)sender;
- (void)doZoomOut:(id)sender;
@end

extern NSString * const iTM2PDFSSetUpPageWhenBadPaperSizeKey;
extern NSString * const iTM2PDFPreferA4PaperKey;

@interface iTM2PDFDocument(Print)
- (void)printShowingPrintPanel:(BOOL)flag;
- (void)printRepresentationShowingPrintPanel:(BOOL)flag;
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2PDFDocumentKit  =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

