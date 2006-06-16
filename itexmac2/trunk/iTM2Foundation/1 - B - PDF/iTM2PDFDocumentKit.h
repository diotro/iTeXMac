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

#import <iTM2Foundation/iTM2DocumentKit.h>

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

@class iTM2NavigationFormatter;
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2PDFDocument  =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

@interface iTM2PDFDocument: iTM2Document
-(id)init; // designated initializer
-(id)imageRepresentation;
-(void)setImageRepresentation:(id)aRepresentation;
-(void)setOriginalFileName:(NSString *)argument;// due to translation dvi, eps -> pdf!!!
/*!
	@method			dataCompleteReadFromURL:ofType:error:
	@abstract		Reads the data from the given file.
	@discussion		Just forwards the message to the -readImageRepresentationFromFile:ofType: method.
	@param			fileName
	@param			type
	@param			outError
	@result			yorn
	@availability	iTM2.
	@copyright		2005 jlaurens AT users DOT sourceforge DOT net and others.
*/
-(BOOL)dataCompleteReadFromURL:(NSURL *)fileURL ofType:(NSString *)type error:(NSError**)outError;
-(BOOL)readImageRepresentationFromURL:(NSURL *)fileURL ofType:(NSString *)type error:(NSError**)outError;
@end

@interface iTM2PDFWindow: NSWindow
@end

extern NSString * const iTM2PDFInspectorMode;

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2PDFWindowController

@interface iTM2PDFInspector: iTM2Inspector
/*"Class methods"*/
/*"Setters and Getters"*/
-(id)album;
-(int)firstPhysicalPage;
-(int)lastPhysicalPage;
-(int)currentPhysicalPage;
-(void)setCurrentPhysicalPage:(int)aCurrentPhysicalPage;
-(float)magnification;
-(void)setMagnification:(float)magnification;
/*"Main methods"*/
//- (void) synchronizePageWith: (NSNumber *) aCurrentPhysicalPage;
/*"Overriden methods"*/
/*"Overriden methods"*/
@end

@interface iTM2PDFInspector(KeyStroke)
-(void)doZoomIn:(id)sender;
-(void)doZoomOut:(id)sender;
@end

extern NSString * const iTM2PDFLastMagnificationKey;
extern NSString * const iTM2PDFCurrentMagnificationKey;
extern NSString * const iTM2PDFFixedMagnificationKey;
extern NSString * const iTM2PDFLastMagnificationKey;
extern NSString * const iTM2PDFAlbumDisplayModeKey;
extern NSString * const iTM2PDFAlbumStickModeKey;
extern NSString * const iTM2PDFToolbarIdentifier;

#define iTM2PDFAlbumViewMargin 10

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2PDFAlbumView  =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

#import <iTM2Foundation/iTM2ViewKit.h>

@interface iTM2PDFAlbumView: iTM2CenteringView
{
@private
    BOOL _CanStick;
    BOOL _ParametersHaveChanged;
    int _CurrentPhysicalPage;
}
/*"Class mathods."*/
/*"Setters and getters."*/
-(int)currentPhysicalPage;
-(void)setCurrentPhysicalPage:(int)aCurrentPhysicalPage;
-(unsigned)pageLayout;
-(void)setPageLayout:(unsigned)PL;
/*"Main mathods."*/
-(float)magnification;
-(void)setMagnification:(float)aMagnification;
-(void)setMagnificationWithDisplayMode:(int)displayMode stickMode:(int)stickMode;
-(BOOL)parametersHaveChanged;
-(void)setParametersHaveChanged:(BOOL)aFlag;
-(int)PDFOrientation;
-(void)setPDFOrientation:(int)argument;
-(id)imageRepresentation;
/*"Overriden methods."*/
-(void)awakeFromNib;
-(float)ratioContentVersusDocumentWidth;
-(float)ratioContentVersusDocumentHeight;
-(int)forwardPhysicalPage;
-(int)backPhysicalPage;
-(int)logicalToPhysicalPage:(int)logicalPage;
@end

extern NSString * const iTM2PDFSSetUpPageWhenBadPaperSizeKey;
extern NSString * const iTM2PDFPreferA4PaperKey;

@interface iTM2PDFDocument(Print)
-(void)printShowingPrintPanel:(BOOL)flag;
-(void)printRepresentationShowingPrintPanel:(BOOL)flag;
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2PDFDocumentKit  =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

