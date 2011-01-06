/*
//  iteXMac
//
//  @version Subversion: $Id$ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Wed Jun 27 2001.
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

#import <iTM2TeXFoundation/synctex_parser.h>

extern NSString * const iTM2PDFSyncParsedNotificationName;
extern NSString * const iTM2PDFNoSynchronizationKey;
extern NSString * const iTM2PDFSyncFollowFocusKey;
extern NSString * const iTM2PDFSyncShowRecordNumberKey;
extern NSString * const iTM2PDFSYNCDidToggleNotification;
extern NSString * const iTM2PDFSYNCDisplayBulletsKey;

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2PDFSynchronizer

@interface iTM2PDFDocument(iTM2PDFSYNCKit)

/*! 
    @method     synchronizeWithLocation:inPageAtIndex:withHint:orderFront:
    @abstract   Displays the source at the right location.
    @discussion The hint is an expected character, a word containing that character, a small phrase before and a small phrase after,
				the point before, the point after.
				Don't expect the method to be excellent... All this piece of information is wrapped in a dictionary with keys
				@"character", @"word", @"previous phrase", @"next phrase", @"previous point", @"next point".
				This default implementation does not use hint. It is intended for iTM2.
    @param      thePoint is a point
    @param      thePage is a 0 based page index
    @param      hint is a dictionary containing hints to help synchronizing
    @param      yorn is a flag
    @result     y or n
*/
- (BOOL)synchronizeWithLocation:(NSPoint)thePoint inPageAtIndex:(NSUInteger)thePage withHint:(NSDictionary *)hint orderFront:(BOOL)yorn;

/*! 
    @method     displayPageForLine:column:source:withHint:orderFront:
    @abstract   Displays the receiver at the right location.
    @discussion Description forthcoming.
    @param      the l is a 1 base line number
    @param      the c is a 0 based column index
    @param      sourceURL is a source URL
    @param      yorn is a flag.
    @result     NO if nothing special is done
*/
- (BOOL)displayPageForLine:(NSUInteger)l column:(NSUInteger)c source:(NSURL *)sourceURL withHint:(NSDictionary *)hint orderFront:(BOOL)yorn force:(BOOL)force;

- (id)synchronizer;
- (void)setSynchronizer:(id)argument;
- (void)replaceSynchronizer:(id)argument;
/*! 
    @method     updateSynchronizer:
    @abstract   Update the receiver.
    @discussion This message should be sent each time the information linking the PDF with its source have changed.
This implementation reads the .PDFSYNC file associated to the receiver. There should be a consistency test to ensure that the PDFSYNC file read is really in synchronization with the PDF file read. The file is parsed in a new thread and some information is cached.
*/
- (void)updateSynchronizer:(id)sender;

/*! 
    @method     updatePdfSyncFileModificationDate
    @abstract   Update the pdfsync file modification date.
    @discussion This message is sent each time the file modification date of the receiver is expected to change.
				More precisely it is sent when the context is saved and when the receiver is saved.
    @param      RORef
    @return     YorN
*/
- (BOOL)updateSynchronizerFileModificationDate4iTM3Error:(NSError **)RORef;

@end

typedef enum
{
    kiTM2PDFSYNCDisplayBuiltInBullets = 1,
    kiTM2PDFSYNCDisplayFocusBullets = 2,
    kiTM2PDFSYNCDisplayUserBullets = 4
} iTM2PDFSYNCDisplayBulletsMode;

typedef struct
{
    CGFloat x;
    CGFloat y;
    BOOL star;
    BOOL plus;
} iTM2SynchronizationLocationRecord;

typedef struct
{
    NSInteger line;
    NSInteger column;
} iTM2SynchronizationLineRecord;
    
@interface iTM2PDFSynchronizer: NSObject
{
@private
    NSString * _FileName;
    NSArray * _Files;
    NSMutableArray * _PageSyncLocations;
    id _Lines;
    NSInteger _Version;
    NSInteger _Semaphore;
    BOOL _IsLocked;
}

/*! 
    @method     destinationsForLine:column:inSource:
    @abstract   Translates a source information into an output information.
    @discussion These are the methods for synchronization.
				Destinations is a dictionary containing 3 dictionaries for keys @"here", @"before" and @"after".
				Each dictionary keys are page indexes wrapped in numbers as NSUIntegers and corresponding
				values are mutable arrays of pdfsync points wrapped in NSValue's. Points are expressed in page coordinates,
				as expected by Mac OS X (bp vs pt, this might be a strange affair because it is not clear what TeX gives...)
    @param      line is a line number.
    @param      column is a column number.
    @param      source is the full path of the file for which we know the above line and column numbers.
    @result     a dictionary which keys are 0 based page indices wrapped as NSUInteger in numbers,
				values are arrays of points wrapped in values.
*/
- (NSDictionary *)destinationsForLine:(NSUInteger)line column:(NSUInteger)column inSource:(NSString *)source;

/*! 
    @method     getLine:column:length:source:forLocation:withHint:inPageAtIndex:
    @abstract   Translates a source information into an output information.
    @discussion These are the methods for synchronization.
    @param      linePtr points to an integer location where the line number will be stored.
    @param      columnPtr points to an integer location where the column number should be stored.
    @param      lengthPtr points to an integer location where the length number should be stored.
    @param      sourcePtr is a pointer where the source full path should be stored.
    @param      page is a page number.
    @param      point is the point of the PDF, the origin is at the top left corner of teh page.
    @result     a flag, NO if no PDFSYNC info where available, YES othewise. A NO return value does not mean that the receiver is using DVI.
*/
- (BOOL)getLine:(NSUInteger *)linePtr column:(NSUInteger *)columnPtr length:(NSUInteger *)lengthPtr source:(NSString **)sourcePtr forLocation:(NSPoint)point withHint:(NSDictionary *)hint inPageAtIndex:(NSUInteger)pageIndex;
- (BOOL)getLine:(NSUInteger *)linePtr column:(NSUInteger *)columnPtr sourceBefore:(NSString **)sourceBeforeRef sourceAfter:(NSString **)sourceAfterRef forLocation:(NSPoint)point withHint:(NSDictionary *)hint inPageAtIndex:(NSUInteger)pageIndex;

/*! 
    @method     synchronizationLocationsForPageIndex:
    @abstract   A dictionary of the synchronization objects for the given page.
    @discussion Keys are numbers for record index, values are points wrapped in NSValue's.
    @param      page is a 0 based page number.
    @result     an enumerator, maybe nil.
*/
- (NSDictionary *)synchronizationLocationsForPageIndex:(NSUInteger)page;

/*!
    @method     sourcesForPageAtIndex:
    @abstract   An array of source path for the given output page
    @discussion It is just an hint, in the sense that other sources can definitely contribute
				to the material of this page (consider the header or footer that are fixed only once)
				It is likely that mosty of the material of this page will come from these sources.
    @param		pageIndex is the 0 based page index in the output.
    @result     An array of source paths, relative to the main source/pdf file.
*/
- (NSArray *)sourcesForPageAtIndex:(NSUInteger)pageIndex;

/*! 
    @method     parsePdfsync:
    @abstract   Description forthcoming.
    @discussion These are the methods for synchronization.
    @param      The path of the .pdfsync file.
    @result     None.
*/
- (void)parsePdfsync:(NSString *)pdfsyncPath;

/*! 
    @method     lock
    @abstract   Description forthcoming.
    @discussion These are the methods for synchronization.
    @param      None.
    @result     None.
*/
- (void)lock;
- (void)unlock;
- (synctex_scanner_t)scanner;

/*! 
    @method     isSyncTeX
    @abstract   Description forthcoming.
    @discussion These are the methods for synchronization.
    @param      None.
    @result     None.
*/
- (BOOL)isSyncTeX;

@property (retain) id _FileName;
@property (retain) id _Files;
@property (retain) id _PageSyncLocations;
@property (retain) id _Lines;
@property NSInteger _Version;
@property NSInteger _Semaphore;
@property BOOL _IsLocked;
@end

@interface iTM2PDFSYNCResponder: iTM2AutoInstallResponder

/*! 
    @method     toggleSyncFollowFocus:
    @abstract   Description forthcoming.
    @discussion These are the methods for synchronization.
    @param      page is a 0 based page number.
    @result     an enumerator, maybe nil.
*/
- (void)toggleSyncFollowFocus:(id)sender;

/*! 
    @method     toggleSynchronizationMode:
    @abstract   Description forthcoming.
    @discussion These are the methods for synchronization.
    @param      irrelevant.
    @result     None.
*/
- (void)toggleSynchronizationMode:(id)sender;

/*! 
    @method     toggleSyncNoBullets:
    @abstract   Description forthcoming.
    @discussion These are the methods for synchronization.
    @param      irrelevant.
    @result     None.
*/
- (void)toggleSyncNoBullets:(id)sender;

/*! 
    @method     toggleSyncAllBullets:
    @abstract   Description forthcoming.
    @discussion These are the methods for synchronization.
    @param      irrelevant.
    @result     None.
*/
- (void)toggleSyncAllBullets:(id)sender;

/*! 
    @method     toggleSyncUserBullets:
    @abstract   Description forthcoming.
    @discussion These are the methods for synchronization.
    @param      irrelevant.
    @result     None.
*/
- (void)toggleSyncUserBullets:(id)sender;

/*! 
    @method     toggleSyncFocusBullet:
    @abstract   Description forthcoming.
    @discussion These are the methods for synchronization.
    @param      irrelevant.
    @result     None.
*/
- (void)toggleSyncFocusBullet:(id)sender;

@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2PDFSynchronizer

@interface iTM2PDFAlbumView(iTM2PDFSYNCKit)

- (BOOL)takeCurrentPhysicalPage:(NSInteger)aCurrentPhysicalPage synchronizationPoint:(NSPoint)P withHint:(NSDictionary *)hint;
- (void)scrollSynchronizationPointToVisible:(id)sender;

@end

@interface iTM2PDFImageRepView(iTM2PDFSYNCKit)
- (void)scrollSynchronizationPointToVisible:(id)sender;
- (BOOL)pdfSynchronizeMouseDown:(NSEvent *)theEvent;
@end

@interface iTM2PDFInspector(iTM2PDFSYNCKit)
- (BOOL)canSynchronizeOutput;
- (IBAction)scrollSynchronizationPointToVisible:(id)sender;
- (BOOL)validateScrollSynchronizationPointToVisible:(id)sender;
- (void)displayPhysicalPage:(NSInteger)page synchronizationPoint:(NSPoint)P withHint:(NSDictionary *)hint;
- (BOOL)synchronizeWithDestinations:(NSDictionary *)destinations hint:(NSDictionary *)hint;
- (BOOL)synchronizeWithLine:(NSUInteger)l column:(NSUInteger)c source:(NSString *)SRCE hint:(NSDictionary *)hint;
@end

@interface NSTextView(iTM2PDFSYNCKit)
- (BOOL)pdfSynchronizeMouseDown:(NSEvent *)event;
@end
