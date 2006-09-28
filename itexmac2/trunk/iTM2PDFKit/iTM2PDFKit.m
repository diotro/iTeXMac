/*
//  iTM2PDFKit.h
//  iTeXMac2
//
//  @version Subversion: $Id$ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Sun Jun 24 2001.
//  Copyright © 2005 Laurens'Tribune. All rights reserved.
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

#import "iTM2PDFKit.h"
#import <objc/objc-class.h>

NSString * const iTM2PDFKitInspectorMode = @"Tiger";
NSString * const iTM2PDFKitToolbarIdentifier = @"iTM2PDFKit For Tiger";
NSString * const iTM2PDFKitDocumentDidChangeNotification = @"iTM2_PDFDocumentDidChangeNotification";

NSString * const iTM2MultiplePDFDocumentType = @"Multiple PDF Document";// beware, this MUST appear in the target file...

@interface iTM2ShadowedImageCell: NSImageCell
@end

@interface iTM2IconSegmentedControl(PRIVATE_HERE)
- (void)calcControlSize;
@end

@interface iTM2PDFKitInspector(PRIVATE)
- (iTM2ToolMode)toolMode;
- (void)setToolMode:(iTM2ToolMode)argument;
- (NSRect)documentViewVisibleRect;
- (void)setDocumentViewVisibleRect:(NSRect)argument;
- (unsigned int)documentViewVisiblePageNumber;
- (void)setDocumentViewVisiblePageNumber:(unsigned int)argument;
- (NSColor *)backgroundColor;
- (void)setBackgroundColor:(NSColor *)argument;
- (int)displayBox;
- (void)setDisplayBox:(int)argument;
- (PDFDisplayMode)displayMode;
- (void)setDisplayMode:(PDFDisplayMode)argument;
- (float)greekingThreshold;
- (void)setGreekingThreshold:(float)argument;
- (float)scaleFactor;
- (void)setScaleFactor:(float)argument;
- (BOOL)shouldAntiAlias;
- (void)setShouldAntiAlias:(BOOL)argument;
- (BOOL)autoScales;
- (void)setAutoScales:(BOOL)argument;
- (BOOL)displaysAsBook;
- (void)setDisplaysAsBook:(BOOL)argument;
- (BOOL)displaysPageBreaks;
- (void)setDisplaysPageBreaks:(BOOL)argument;
- (NSMutableArray *)PDFSearchResults;
- (void)updatePDFOutlineInformation;
- (NSMutableArray *)PDFThumbnails;
- (iTM2TreeNode *)PDFOutlines;
- (void)setPDFOutlines:(iTM2TreeNode *)argument;
- (void)updateTabView;
- (void)updateThumbnailTable;
- (void)updateOutlineTable;
- (void)updateSearchTable;
- (void)renderInBackroundThumbnailAtIndex:(unsigned int)index;
- (void)setProgressIndicatorIsAnimated:(BOOL)yorn;
@end

@implementation iTM2PDFDocument(Cluster)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  load
+ (void)load;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	iTM2_INIT_POOL;
//iTM2_START;
	if(![iTM2RuntimeBrowser swizzleInstanceMethodSelector:@selector(swizzled_iTM2PDFKit_init) replacement:@selector(init) forClass:[self class]])
	{
		iTM2_LOG(@"WARNING: No hook available to init Tiger aware PDF documents...");
	}
//iTM2_END;
	iTM2_RELEASE_POOL;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  swizzled_iTM2PDFKit_init
- (id)swizzled_iTM2PDFKit_init;
/*"Description Forthcoming. Not sure this design is that strong. It need some firther investigation.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([self isKindOfClass:[iTM2PDFKitDocument class]])
		return [self swizzled_iTM2PDFKit_init];
	id garbage = self;
	self = [[iTM2PDFKitDocument allocWithZone:[self zone]] swizzled_iTM2PDFKit_init];
	[garbage dealloc];
    return self;
}
@end

@implementation iTM2PDFKitDocument
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initialize
+ (void)initialize;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 2.0: Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [super initialize];
	NSDictionary * D = [SUD dictionaryForKey:iTM2SUDInspectorVariants];
	NSMutableDictionary * MD = [NSMutableDictionary dictionaryWithDictionary:D];
	NSString * type = iTM2PDFGraphicsInspectorType;
	if(![MD objectForKey:type])
	{
		NSString * mode = [iTM2PDFKitInspector inspectorMode];
		NSString * variant = [iTM2PDFKitInspector inspectorVariant];
		D = [NSDictionary dictionaryWithObjectsAndKeys:mode, @"mode", variant, @"variant", nil];
		[MD setObject:D forKey:type];
		[SUD setObject:MD forKey:iTM2SUDInspectorVariants];
	}
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inspectorType
+ (NSString *)inspectorType;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return iTM2PDFGraphicsInspectorType;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inspectorMode
+ (NSString *)inspectorMode;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return iTM2PDFInspectorMode;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= PDFDocument
- (PDFDocument *)PDFDocument;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return metaGETTER;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= setPDFDocument:
- (void)setPDFDocument:(id)PDFDoc;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(![PDFDoc isEqual:metaGETTER])
    {
        metaSETTER(PDFDoc);
        [INC postNotificationName:iTM2PDFKitDocumentDidChangeNotification object:self userInfo:nil];
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  dataCompleteReadFromURL:ofType:error:
- (BOOL)dataCompleteReadFromURL:(NSURL *)fileURL ofType:(NSString *)type error:(NSError**)errorPtr;
/*" Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(errorPtr)
		*errorPtr = nil;
	PDFDocument * PDFDoc = nil;
	NSData * PDFData = [NSData dataWithContentsOfURL:fileURL options:0 error:errorPtr];
	PDFDoc = [[iTM2XtdPDFDocument alloc] initWithData:PDFData];
	BOOL result = NO;
	if(PDFDoc)
	{
		[self setPDFDocument:[PDFDoc autorelease]];
		result = YES;
	}
	NSEnumerator * E = [[self windowControllers] objectEnumerator];
	id WC = nil;
	while(WC = [E nextObject])
	{
		if([WC respondsToSelector:@selector(setProgressIndicatorIsAnimated:)])
		{
			[WC setProgressIndicatorIsAnimated:!result];
		}
	}
//iTM2_END;
	return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  dataCompleteWriteToURL:ofType:error:
- (BOOL)dataCompleteWriteToURL:(NSURL *)fileURL ofType:(NSString *)type error:(NSError**)outError;
/*" Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return [[self PDFDocument] writeToURL:fileURL];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  synchronizeWithLocation:inPageAtIndex:withHint:orderFront:
- (void)synchronizeWithLocation:(NSPoint)thePoint inPageAtIndex:(unsigned int)thePage withHint:(NSDictionary *)hint orderFront:(BOOL)yorn;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 2.0: Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSString * sourceBefore = @"";
    NSString * sourceAfter = @"";
    unsigned int line = 0;
    unsigned int column = -1;
	unsigned int length = 1;
	NSURL * url = nil;
	id document = nil;
	id synchronizer = [self synchronizer];
    if([synchronizer getLine: &line column: &column sourceBefore: &sourceBefore sourceAfter: &sourceAfter forLocation:thePoint withHint:hint inPageAtIndex:thePage])
	{
		if([sourceBefore length]
			&& [[SDC documentClassForType:[SDC typeFromFileExtension:[sourceBefore pathExtension]]] isSubclassOfClass:[iTM2TextDocument class]])
		{
			url = [NSURL fileURLWithPath:sourceBefore];
			document = [SDC openDocumentWithContentsOfURL:url display:NO error:nil];
			[document getLine: &line column: &column length:&length forHint:hint];
			if([document displayLine:line column:column length:length withHint:hint orderFront:yorn])
				return;
		}
		if([sourceAfter length]
			&& [[SDC documentClassForType:[SDC typeFromFileExtension:[sourceAfter pathExtension]]] isSubclassOfClass:[iTM2TextDocument class]])
		{
			document = [SDC openDocumentWithContentsOfURL:[NSURL fileURLWithPath:sourceAfter] display:NO error:nil];
			[document getLine: &line column: &column length:&length forHint:hint];
			if([document displayLine:line column:column length:length withHint:hint orderFront:yorn])
				return;
		}
	}
	// all the sources?
	iTM2ProjectDocument * PD = [SPC projectForSource:self];
	NSEnumerator * E = [[PD allKeys] objectEnumerator];
	NSString * key;
	unsigned int matchLevel = UINT_MAX;
	id matchDocument = nil;
	while(key = [E nextObject])
	{
		NSString * source = [PD absoluteFileNameForKey:key];
		document = [PD subdocumentForKey:key];
		if(!document)
		{
			if([source length] && [[SDC documentClassForType:[SDC typeFromFileExtension:[source pathExtension]]]
				isSubclassOfClass: [iTM2TextDocument class]])
			{
				document = [SDC openDocumentWithContentsOfURL:[NSURL fileURLWithPath:source] display:NO error:nil];
			}
		}
		if([document isKindOfClass:[iTM2TextDocument class]])
		{
			unsigned int testLine = 0, testColumn = -1, testLength = 1;// THESE MUST BE INITIALIZED THAT WAY
			unsigned int testMatch = [document getLine:&testLine column:&testColumn length:&testLength forHint:hint];
			if(testMatch<matchLevel)
			{
				matchLevel = testMatch;
				line = testLine;
				column = testColumn;
				length = testLength;
				sourceBefore = source;
				matchDocument = document;
			}
		}
	}
	if([matchDocument displayLine:line column:column length:length withHint:hint orderFront:yorn])
	{
		return;
	}
	NSString * path = [self fileName];
	path = [path stringByDeletingPathExtension];
	path = [path stringByAppendingPathExtension:@"tex"];
	matchDocument = [SDC openDocumentWithContentsOfURL:[NSURL fileURLWithPath:path] display: NO error: nil];
	if([matchDocument isKindOfClass:[iTM2TextDocument class]])
	{
		unsigned int testLine = 0, testColumn = -1, testLength = 1;// THESE MUST BE INITIALIZED THAT WAY
		[matchDocument getLine:&testLine column:&testColumn length:&testLength forHint:hint];
		if([matchDocument displayLine:testLine column:testColumn length:testLength withHint:hint orderFront:yorn])
		{
			return;
		}
	}
	if(iTM2DebugEnabled)
	{
		iTM2_LOG(@"Could not synchronize (weakly) with hint:\n%@", hint);
	}
	return;
}
- (BOOL)validateSaveDocument:(id)sender;
{
	return [self isDocumentEdited];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= updateIfNeeded
- (void)updateIfNeeded;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Jan 18 22:21:11 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([self needsToUpdate])
	{
		[self saveContext:nil];
		[self readFromURL:[self fileURL] ofType:[self fileType] error:nil];
	}
    return;
}
@end

@implementation iTM2MultiplePDFKitDocument
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  dataCompleteReadFromFile:ofType:
- (BOOL)dataCompleteReadFromFile:(NSString *)fileName ofType:(NSString *)type;
/*" Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([type isEqualToString:iTM2MultiplePDFDocumentType])
	{
		iTM2MultiplePDFDocument * doc = [[[iTM2MultiplePDFDocument allocWithZone:[self zone]] initWithURL:[NSURL fileURLWithPath:fileName]] autorelease];
		[self setPDFDocument:doc];
		return doc != nil;
	}
//	[self setImageRepresentation:nil];
//	[self setImageRepresentation:[NSPDFImageRep imageRepWithData:[PDFDoc dataRepresentation]]];
//iTM2_END;
	return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  dataCompleteWriteToFile:ofType:
- (BOOL)dataCompleteWriteToFile:(NSString *)fileName ofType:(NSString *)type;
/*" Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return YES;
}
@end
@implementation iTM2MultiplePDFDocument
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  dealloc
- (void)dealloc;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[__PDFKitDocuments autorelease];
	__PDFKitDocuments = nil;
	[__OrderedFileNames autorelease];
	__OrderedFileNames = nil;
	[__IndexForPageCache autorelease];
	__IndexForPageCache = nil;
	[super dealloc];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initWithURL:
- (id)initWithURL:(NSURL *)URL;
/*" Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * templatePath = [[self classBundle] pathForResource:@"template" ofType:@"pdf"];
	if(self = [super initWithURL:[NSURL fileURLWithPath:templatePath]])
	{
		[__PDFKitDocuments autorelease];
		__PDFKitDocuments = [[NSMutableDictionary dictionary] retain];
		[__OrderedFileNames autorelease];
		__OrderedFileNames = [[NSMutableArray array] retain];
		[__IndexForPageCache autorelease];
		__IndexForPageCache = [[NSMutableDictionary dictionary] retain];
		NSString * directoryName = [URL isFileURL]? [URL path]: @"";
		NSString * baseName = [NSString stringWithFormat:@"%@-", [[directoryName lastPathComponent] stringByDeletingPathExtension]];
		NSEnumerator * E = [[DFM directoryContentsAtPath:directoryName] objectEnumerator];
		NSString * component;
		while(component = [E nextObject])
		{
			NSString * fullPath = [directoryName stringByAppendingPathComponent:component];
			Class C = [SDC documentClassForType:[SDC typeFromFileExtension:[fullPath pathExtension]]];
			if([C isSubclassOfClass:[iTM2PDFDocument class]] && [component hasPrefix:baseName])
			{
				[__OrderedFileNames addObject:component];
			}
			else
			{
				if(iTM2DebugEnabled)
				{
					iTM2_LOG(@"Refused file: %@",fullPath);
					break;
				}
			}
		}
		if(![__OrderedFileNames count])
		{
			// this was not a wrapper where all the files were collected
			directoryName = [directoryName stringByDeletingLastPathComponent];
			E = [[DFM directoryContentsAtPath:directoryName] objectEnumerator];
			while(component = [E nextObject])
			{
				NSString * fullPath = [directoryName stringByAppendingPathComponent:component];
				Class C = [SDC documentClassForType:[SDC typeFromFileExtension:[fullPath pathExtension]]];
				if([C isSubclassOfClass:[iTM2PDFDocument class]] && [component hasPrefix:baseName])
				{
					[__OrderedFileNames addObject:component];
				}
				else
				{
					if(iTM2DebugEnabled)
					{
						iTM2_LOG(@"Refused file: %@",fullPath);
					}
				}
			}
		}	
		[__OrderedFileNames sortUsingSelector:@selector(iTM2_compareAs__OrderedFileNames:)];
		if([__OrderedFileNames count])
		{
			unsigned oldCount = [self pageCount];
			NSMutableArray * MRA = [NSMutableArray array];
			E = [__OrderedFileNames objectEnumerator];
			unsigned index = 0;
			while((component = [E nextObject]) && index++<1)
			{
				NSString * fullPath = [directoryName stringByAppendingPathComponent:component];
//iTM2_LOG(@"fullPath is : %@", fullPath);
				PDFDocument * doc = [[PDFDocument allocWithZone:[self zone]] initWithURL:[NSURL fileURLWithPath:fullPath]];
				if([doc pageCount])
				{
					[MRA addObject:component];
					PDFPage * P = [[doc pageAtIndex:0] retain];
					[doc removePageAtIndex:0];
//iTM2_LOG(@"[P document] is: %@", [P document]);
					[self insertPage:P atIndex:[self pageCount]];
//iTM2_LOG(@"[P document] is: %@", [P document]);
//iTM2_LOG(@"[self pageCount] is now: %i", [self pageCount]);
//iTM2_LOG(@"[self dataRepresentation] is now: %@", [self dataRepresentation]);
				}
				else
				{
					iTM2_LOG(@"Void pdf document at: %@", fullPath);
				}
				[doc release];
				doc = nil;
			}
			[__OrderedFileNames setArray:MRA];
			if(NO && [__OrderedFileNames count])
				while(oldCount--)
					[self removePageAtIndex:0];
		}
	}
//iTM2_END;
	return self;
}
@end

@implementation NSString(__OrderedFileNames)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2_compareAs__OrderedFileNames:
- (NSComparisonResult)iTM2_compareAs__OrderedFileNames:(NSString *)fileName;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSComparisonResult result = [[self stringByDeletingLastPathComponent] compare:[fileName stringByDeletingLastPathComponent]];
	if(result == NSOrderedSame)
	{
		unsigned int commonPrefixLength = [[self commonPrefixWithString:fileName options:0] length];
		NSString * left  = [[self substringWithRange:NSMakeRange(commonPrefixLength, [self length] - commonPrefixLength)] stringByDeletingPathExtension];
		NSString * right = [[fileName substringWithRange:NSMakeRange(commonPrefixLength, [fileName length] - commonPrefixLength)] stringByDeletingPathExtension];
		NSCharacterSet * nonDecimalDigitsCharacterSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
		NSRange leftR  = [left  rangeOfCharacterFromSet:nonDecimalDigitsCharacterSet options:NSBackwardsSearch];
		if(leftR.location  != NSNotFound)
			return [left compare:right];
		NSRange rightR = [right rangeOfCharacterFromSet:nonDecimalDigitsCharacterSet options:NSBackwardsSearch];
		if(rightR.location != NSNotFound)
			return [left compare:right];
		int leftInteger  = [left  intValue];
		int rightInteger = [right intValue];
		return leftInteger>rightInteger? NSOrderedDescending:
			(leftInteger<rightInteger? NSOrderedAscending: NSOrderedSame);
	}
	return result;
}
@end

@interface NSObject(PRIVATE_STUFF)
- (BOOL)takeCurrentPhysicalPage:(int)aCurrentPhysicalPage synchronizationPoint:(NSPoint)point withHint:(NSDictionary *)hint;
- (void)scrollSynchronizationPointToVisible:(id)sender;
@end

#warning MAC OS X BUG? (10.4)
#import <AppKit/NSSegmentedCell.h>

@implementation iTM2PDFKitWindow
@end

@implementation iTM2PDFKitInspector
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inspectorType
+ (NSString *)inspectorType;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return iTM2PDFGraphicsInspectorType;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inspectorMode
+ (NSString *)inspectorMode;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return iTM2PDFKitInspectorMode;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= windowPositionShouldBeObserved
- (BOOL)windowPositionShouldBeObserved;
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri May 21 07:52:07 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  PDFDocumentDidChangeNotified:
- (void)PDFDocumentDidChangeNotified:(NSNotification *)notification;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id document = [self document];
	if([notification object] == document)
	{
		[self setPDFOutlines:nil];
		[[self PDFThumbnails] setArray:[NSArray array]];
		[[self PDFSearchResults] setArray:[NSArray array]];
		PDFDocument * doc = [_pdfView document];
		if(doc)
		{
			// store the geometry:
			[self setScaleFactor:[_pdfView scaleFactor]];
			PDFPage * page = [_pdfView currentPage];
			[self setDocumentViewVisiblePageNumber:[doc indexForPage:page]];
			[doc setDelegate:nil];
			[self setDocumentViewVisibleRect:[[_pdfView documentView] visibleRect]];
		}
		[doc setDelegate:nil];
		doc = [document PDFDocument];
		[_pdfView setDocument:doc];
//		[_pdfView setNeedsDisplay:YES];
iTM2_LOG(@"UPDATE: %@",NSStringFromRect([self documentViewVisibleRect]));
		[doc setDelegate:self];
		if([_drawer state] == NSDrawerOpenState)
			[self updateTabView];
		[self contextDidChange];
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  album
- (id)album;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return _pdfView;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  _pdfCompleteWindowDidLoad:
- (void)_pdfCompleteWindowDidLoad;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSAssert(_pdfTabView, @"Missing _pdfTabView connection...");
	NSAssert(_tabViewControl, @"Missing _tabViewControl connection...");
	[_tabViewControl setSegmentCount:2];
	[_tabViewControl setImage:[NSImage imageThumbnailViewAdorn] forSegment:0];
	[_tabViewControl setImage:[NSImage imageTOCViewAdorn] forSegment:1];
	[_tabViewControl setAction:@selector(_tabViewControlAction:)];
	[_tabViewControl setTarget:self];
	[[_tabViewControl cell] setTrackingMode:NSSegmentSwitchTrackingSelectOne];
	[DNC addObserver:self selector:@selector(PDFViewPageChangedNotified:)  name:PDFViewPageChangedNotification  object:_pdfView];
	[DNC addObserver:self selector:@selector(PDFViewScaleChangedNotified:) name:PDFViewScaleChangedNotification object:_pdfView];
	PDFDocument * doc = [[self document] PDFDocument];
	[_pdfView setDocument:doc];
	[_pdfView setDelegate:self];
	[doc setDelegate:self];
	[self setPDFOutlines:nil];
	[_outlinesView setTarget:self];
	[_outlinesView setAction:@selector(takeDestinationFromSelectedItemRepresentedObject:)];
	[_tabViewControl setEnabled: ([[self PDFOutlines] countOfChildren]>0) forSegment:1];
	[[self PDFThumbnails] setArray:[NSArray array]];
	[INC addObserver: self
		selector: @selector(PDFDocumentDidChangeNotified:)
			name: iTM2PDFKitDocumentDidChangeNotification
				object: nil];
	#if 0
	Could not implement the shadow
	NSTableColumn * column = [_thumbnailTable tableColumnWithIdentifier:@"thumbnail"];
	iTM2ShadowedImageCell * newCell = [[[iTM2ShadowedImageCell allocWithZone:[_thumbnailTable zone]] initImageCell:nil] autorelease];
	NSImageCell * oldCell = [column dataCell];
	[newCell setImageAlignment:[oldCell imageAlignment]];
	[newCell setImageScaling:[oldCell imageScaling]];
	[newCell setImageFrameStyle:[oldCell imageFrameStyle]];
	[column setDataCell:newCell];
	#endif
	[_searchCountText setStringValue:@""];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  PDFViewWillChangeScaleFactor:r toScale:
- (float)PDFViewWillChangeScaleFactor:(PDFView *)sender toScale:(float)scale;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	float limit = MIN(0.1, MAX([SUD floatForKey:@"iTM2PDFMinScaleLimit"], 0));
	if(scale<limit)
		return limit;
	limit = MAX([SUD floatForKey:@"iTM2PDFMinScaleLimit"], 10.0);
	if(scale>limit)
		return limit;
//iTM2_END;
    return scale;
}
#pragma mark =-=-=-=-=-  PROGRESS INDICATOR
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  progressIndicatorIsAnimated
- (BOOL)progressIndicatorIsAnimated;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return [metaGETTER boolValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setProgressIndicatorIsAnimated:
- (void)setProgressIndicatorIsAnimated:(BOOL)yorn;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self willChangeValueForKey:@"progressIndicatorIsAnimated"];
	metaSETTER([NSNumber numberWithBool:yorn]);
	[self didChangeValueForKey:@"progressIndicatorIsAnimated"];
//iTM2_END;
    return;
}
#pragma mark =-=-=-=-=-  DRAWER
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  _tabViewControlAction:
- (IBAction)_tabViewControlAction:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	PDFDocument * doc = [_pdfView document];
    if ([doc isFinding])
		[doc cancelFindString];
	[_pdfTabView selectTabViewItemWithIdentifier: ([sender selectedSegment]? @"2":@"1")];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  tabView:didSelectTabViewItem:
- (void)tabView:(NSTabView *)tabView didSelectTabViewItem:(NSTabViewItem *)tabViewItem;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self updateTabView];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleDrawer:
- (IBAction)toggleDrawer:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[_drawer toggle:sender];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  drawerDidOpen:
- (void)drawerDidOpen:(NSNotification *)notification;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self updateTabView];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  updateTabView
- (void)updateTabView;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * identifier = [[_pdfTabView selectedTabViewItem] identifier];
	if([identifier isEqual:@"1"])
	{
		[self updateThumbnailTable];
		[_tabViewControl setSelected:YES forSegment:0];
	}
	else if([identifier isEqual:@"2"])
	{
		[self updateOutlineTable];
		[_tabViewControl setSelected:YES forSegment:1];
	}
	else
	{
		[_tabViewControl setSelected:NO forSegment:0];
		[_tabViewControl setSelected:NO forSegment:1];
		[self updateSearchTable];
	}
//iTM2_END;
    return;
}
#pragma mark =-=-=-=-=-  THUMBNAILS
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  PDFThumbnails
- (NSMutableArray *)PDFThumbnails;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id result = metaGETTER;
	if(!result)
	{
		metaSETTER([NSMutableArray arrayWithCapacity:10]);
		result = metaGETTER;
	}
//iTM2_END;
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  updateThumbnailTable
- (void)updateThumbnailTable;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(![[self PDFThumbnails] count])
	{
		unsigned index = [[_pdfView document] pageCount];
		while(index--)
			[[self PDFThumbnails] addObject:[NSImage imageGenericImageDocument]];
	}
	[_thumbnailTable reloadData];
//iTM2_END;
    return;
}
static NSMutableDictionary * _iTM2PDFRenderInBackgroundThumbnails = nil;
static BOOL _iTM2PDFThreadedRenderInBackgroundThumbnails = NO;
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  renderInBackroundThumbnailAtIndex:
- (void)renderInBackroundThumbnailAtIndex:(unsigned int)index;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([SUD boolForKey:@"iTM2PDFDontRenderThumbnailsInBackground"])
		return;
	if(!_iTM2PDFRenderInBackgroundThumbnails)
	{
		_iTM2PDFRenderInBackgroundThumbnails = [[NSMutableDictionary dictionary] retain];
	}
	NSValue * V = [NSValue valueWithPointer:self];
	NSMutableSet * set = [_iTM2PDFRenderInBackgroundThumbnails objectForKey:V];
	if(!set)
	{
		[_iTM2PDFRenderInBackgroundThumbnails setObject:[NSMutableSet set] forKey:V];
		set = [_iTM2PDFRenderInBackgroundThumbnails objectForKey:V];
	}
	[set addObject:[NSNumber numberWithUnsignedInt:index]];
	if(_iTM2PDFThreadedRenderInBackgroundThumbnails)
		return;
	if([_iTM2PDFRenderInBackgroundThumbnails count])
	{
		[NSThread detachNewThreadSelector:@selector(detachedRenderThumbnailsInBackground:) toTarget:[self class] withObject:nil];
		_iTM2PDFThreadedRenderInBackgroundThumbnails = YES;
	}
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  detachedRenderThumbnailsInBackground:
+ (void)detachedRenderThumbnailsInBackground:(id)irrelevant;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
	iTM2_INIT_POOL;
//iTM2_START;
	NSLock * L = [[NSLock alloc] init];
loop:
	[L lock];
	NSMutableDictionary * MD = [[_iTM2PDFRenderInBackgroundThumbnails mutableCopy] autorelease];
	[L unlock];
	NSEnumerator * E = [MD keyEnumerator];
	NSValue * V;
	while(V = [E nextObject])
	{
		iTM2PDFKitInspector * inspector = [V pointerValue];
		NSEnumerator * e = [[NSApp orderedWindows] objectEnumerator];
		NSWindow * w;
		while(w = [e nextObject])
		{
			if([inspector isEqual:[w windowController]])
			{
				// this is the real inspector
				[L lock];
				id set = [_iTM2PDFRenderInBackgroundThumbnails objectForKey:V];
				if([set count])
				{
					[MD setObject:[[set mutableCopy] autorelease] forKey:V];
					[L unlock];
					e = [[MD objectForKey:V] objectEnumerator];
					NSNumber * N;
					while(N = [e nextObject])
					{
						unsigned int pageIndex = [N unsignedIntValue];
						PDFView * pdfView = nil;
						object_getInstanceVariable(inspector, "_pdfView", (void **)&pdfView);
						PDFDocument * doc = [pdfView document];
						if(pageIndex < [doc pageCount])
						{
							PDFPage * page = [doc pageAtIndex:pageIndex];
							NSData * D = [page dataRepresentation];
							NSImage * I = [[[NSImage allocWithZone:[w zone]] initWithData:D] autorelease];// tiff?
							[L lock];
							if(pageIndex < [[inspector PDFThumbnails] count])
							{
								[[inspector PDFThumbnails] replaceObjectAtIndex:pageIndex withObject:I];
								[inspector performSelectorOnMainThread:@selector(updateThumbnailTable) withObject:nil waitUntilDone:NO];
							}
							[L unlock];
						}
					}
				}
				else
				{
					[L unlock];
				}
			}
		}
	}
	// everything is made...
	[L lock];
	E = [_iTM2PDFRenderInBackgroundThumbnails keyEnumerator];
	while(V = [E nextObject])
	{
		NSMutableSet * set = [_iTM2PDFRenderInBackgroundThumbnails objectForKey:V];
		[set minusSet:[MD objectForKey:V]];
		if(![set count])
		{
			[_iTM2PDFRenderInBackgroundThumbnails removeObjectForKey:V];
		}
	}
	[L unlock];
	if([_iTM2PDFRenderInBackgroundThumbnails count])
		goto loop;
	[L release];
	L = nil;
	_iTM2PDFThreadedRenderInBackgroundThumbnails = NO;
//iTM2_END;
	iTM2_RELEASE_POOL;
	[NSThread exit];
	return;
}
#pragma mark =-=-=-=-=-  SEARCHING
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  PDFSearchResults
- (NSMutableArray *)PDFSearchResults;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id result = metaGETTER;
	if(!result)
	{
		metaSETTER([NSMutableArray arrayWithCapacity:30]);
		result = metaGETTER;
	}
//iTM2_END;
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  doSearchField:
- (void)doSearchField:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	unsigned int index = [_tabViewControl segmentCount];
	while(index--)
		[_tabViewControl setSelected:NO forSegment:index];
	[_pdfTabView selectTabViewItemWithIdentifier:@""];
	PDFDocument * doc = [_pdfView document];
    if ([doc isFinding])
		[doc cancelFindString];
	[[self PDFSearchResults] setArray:[NSArray array]];
    [_searchTable reloadData];
	[doc setDelegate:self];
    [doc beginFindString:[sender stringValue] withOptions:NSCaseInsensitiveSearch];
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  didMatchString:
- (void)didMatchString:(PDFSelection *)selection
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	selection = [[selection copy] autorelease];
	[[self PDFSearchResults] addObject:selection];
	PDFPage * page = [[selection pages] objectAtIndex:0];
	unsigned int physicalPageIndex = [[page document] indexForPage:page] + 1;
	NSString * label = [page label];
	unsigned int logicalPageIndex = [label intValue];
	if(physicalPageIndex == logicalPageIndex)
	{
		[[self PDFSearchResults] addObject:[[label copy] autorelease]];
	}
	else
	{
		NSMutableAttributedString * MAS = [[[NSMutableAttributedString allocWithZone:[self zone]] initWithString:label] autorelease];
		[MAS appendAttributedString: [[[NSMutableAttributedString allocWithZone:[self zone]] initWithString:[NSString stringWithFormat:@" [%i]", physicalPageIndex] attributes:[NSDictionary dictionaryWithObject:[NSColor disabledControlTextColor] forKey:NSForegroundColorAttributeName]] autorelease]];
		[[self PDFSearchResults] addObject:[[MAS copy] autorelease]];
	}
	PDFOutline * outline = [[page document] outlineItemForSelection:selection];
	if(outline)
	{
		label = [outline label];// cache?
		[[self PDFSearchResults] addObject:[[label copy] autorelease]];
	}
	else
	{
		[[self PDFSearchResults] addObject:[NSNull null]];
	}
	[_searchCountText setStringValue: [NSString stringWithFormat:
		NSLocalizedStringFromTableInBundle(@"Found %i match(es)", @"iTM2PDFKit", [self classBundle], ""),
		[[self PDFSearchResults] count]]];
    [_searchTable reloadData];
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  documentDidBeginDocumentFind:
- (void)documentDidBeginDocumentFind:(NSNotification *)notification;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[_searchCountText setStringValue:@""];
	[_searchProgress startAnimation:self];
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  documentDidEndDocumentFind:
- (void)documentDidEndDocumentFind:(NSNotification *)notification;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[_searchProgress stopAnimation:self];
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  numberOfRowsInTableView:
- (int)numberOfRowsInTableView:(NSTableView *)aTableView
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return aTableView == _searchTable? [[self PDFSearchResults] count]/3:[[self PDFThumbnails] count];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  tableView:objectValueForTableColumn:row:
- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)theColumn row:(int)rowIndex;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	if ([[theColumn identifier] isEqualToString:@"text"])
	{
		id result = [[self PDFSearchResults] objectAtIndex:3*rowIndex+2];
		if(![result isEqual:[NSNull null]])
		{
			return result;
		}
		// there is no chapter
		// I will display characters instead
		// how many characters should I display?
		// What is the width of the table column
		NSCell * C = [theColumn dataCellForRow:rowIndex];
		if([C type] == NSTextCellType)
		{
			// how many characters should I display in this cell?
			NSFont * F = [C font];
			PDFSelection * selection = [[self PDFSearchResults] objectAtIndex:3*rowIndex];
			NSString * selectionString = [selection string];
			NSDictionary * attributes = [NSDictionary dictionaryWithObject:F forKey:NSFontAttributeName];
			F = [SFM convertFont:F toHaveTrait:NSBoldFontMask];// used later to outline the selection
			float w = [selectionString sizeWithAttributes:attributes].width;
			if([theColumn width]>w)
			{
				float W = [theColumn width] - w;
				w = [@"m" sizeWithAttributes:attributes].width;
				unsigned int n = W/w;
				PDFSelection * otherSelection = [[selection copy] autorelease];
				[otherSelection extendSelectionAtEnd:n+1];
				NSString * suffix = [otherSelection string];// as placeholder before being the result
				unsigned int contentsEnd;
				[suffix getLineStart:nil end:nil contentsEnd:&contentsEnd
					forRange:NSMakeRange(0,1)];
				otherSelection = [[selection copy] autorelease];
				[otherSelection extendSelectionAtStart:n+1];
				NSString * prefix = [otherSelection string];
				unsigned int start;
				[prefix getLineStart:&start end:nil contentsEnd:nil
					forRange:NSMakeRange([prefix length] - [selectionString length],1)];
				// the purpose is to find the longest chain with width <= W, and the max number of chars before and after, the most balanced
				// in general, we have n/2 characters before, the searched string and n/2 characters after
				// do we have less than n/2 characters before
				n /= 2;
				++n;
				if([prefix length] - [selectionString length] - start <= n)
				{
					prefix = [prefix substringWithRange:NSMakeRange(start,[prefix length] - [selectionString length] - start)];
					// I want to add X chars to the right such that
					// [prefix length] - [selectionString length] - start + X = 2*n
					// X = 2*n - [prefix length] + [selectionString length] + start
					// There are actually contentsEnd - [selectionString length] characters available from suffix (after the selection)
					if(2*n - [prefix length] + [selectionString length] + start < contentsEnd - [selectionString length])
					{
						suffix = [suffix substringWithRange:NSMakeRange(0,[selectionString length] + 2*n - [prefix length] + start)];
						suffix = [suffix stringByAppendingString:[NSString stringWithUTF8String:"…"]];
					}
					else//if(2*n - [prefix length] + [selectionString length] + start >= contentsEnd - [selectionString length])
					{
						suffix = [suffix substringWithRange:NSMakeRange(0,contentsEnd)];
					}
				}
				else//if([prefix length] - [selectionString length] - start > n)
				{
					// I want to add n
					if(n < contentsEnd - [selectionString length])
					{
						prefix = [prefix substringWithRange:NSMakeRange([prefix length] - [selectionString length] - n,n)];
						prefix = [[NSString stringWithUTF8String:"…"] stringByAppendingString:prefix];
						suffix = [suffix substringWithRange:NSMakeRange(0,[selectionString length]+n)];
						suffix = [suffix stringByAppendingString:[NSString stringWithUTF8String:"…"]];
					}
					else//if(n >= contentsEnd - [selectionString length])
					{
						suffix = [suffix substringWithRange:NSMakeRange(0,contentsEnd)];
						// I can put more characters in the prefix, less than 2*n - contentsEnd + [selectionString length]
						if(2*n - contentsEnd + [selectionString length] < [prefix length] - [selectionString length] - start)
						{
							prefix = [prefix substringWithRange:NSMakeRange(contentsEnd - 2*n,2*n - contentsEnd + [selectionString length])];
							prefix = [[NSString stringWithUTF8String:"…"] stringByAppendingString:prefix];
						}
						else
						{
							prefix = [prefix substringWithRange:NSMakeRange(start,[prefix length] - [selectionString length] - start)];
							prefix = [[NSString stringWithUTF8String:"…"] stringByAppendingString:prefix];
						}
					}
				}
				suffix = [prefix stringByAppendingString:suffix];
				NSMutableAttributedString * MAS = [[[NSMutableAttributedString allocWithZone:[self zone]] initWithString:suffix attributes:attributes] autorelease];
				[MAS addAttribute:NSFontAttributeName value:F range:NSMakeRange([prefix length],[selectionString length])];
				[[self PDFSearchResults] replaceObjectAtIndex:3*rowIndex+2 withObject:[[MAS copy] autorelease]];
				return [[self PDFSearchResults] objectAtIndex:3*rowIndex+2];
			}
			else
			{
				[[self PDFSearchResults] replaceObjectAtIndex:3*rowIndex+2 withObject:@""];
			}
		}
		else
		{
			[[self PDFSearchResults] replaceObjectAtIndex:3*rowIndex+2 withObject:@""];
		}
		return @"";
	}
	else if ([[theColumn identifier] isEqualToString:@"thumbnail"])
	{
		NSImage * I = [[self PDFThumbnails] objectAtIndex:rowIndex];
		if([I isEqual:[NSImage imageGenericImageDocument]])
		{
			[self renderInBackroundThumbnailAtIndex:rowIndex];
		}
		return I;
	}
	else if ([[theColumn identifier] isEqualToString:@"page"])
	{
		if(aTableView == _searchTable)
		{
			return [[self PDFSearchResults] objectAtIndex:3*rowIndex+1];
		}
		else if(aTableView == _thumbnailTable)
		{
			unsigned int physicalPageIndex = rowIndex + 1;
			PDFPage * page = [[_pdfView document] pageAtIndex:rowIndex];
			NSString * label = [page label];
			unsigned int logicalPageIndex = [label intValue];
			if(physicalPageIndex == logicalPageIndex)
			{
				return label;
			}
			NSMutableAttributedString * MAS = [[[NSMutableAttributedString allocWithZone:[self zone]] initWithString:label] autorelease];
			[MAS appendAttributedString: [[[NSMutableAttributedString allocWithZone:[self zone]] initWithString:[NSString stringWithFormat:@" [%i]", physicalPageIndex] attributes:[NSDictionary dictionaryWithObject:[NSColor disabledControlTextColor] forKey:NSForegroundColorAttributeName]] autorelease]];
			return MAS;
		}
		else
			return nil;
	}
	return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  tableViewSelectionDidChange:
- (void)tableViewSelectionDidChange:(NSNotification *)notification;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	NSTableView * TV = (NSTableView *)[notification object];
    int rowIndex = [TV selectedRow];
    if (rowIndex >= 0)
    {
		if(TV == _searchTable)
		{
			[_pdfView setCurrentSelection:[[self PDFSearchResults] objectAtIndex:3*rowIndex]];
			[_pdfView scrollSelectionToVisible:self];
		}
		else if(TV == _thumbnailTable)
		{
			PDFPage * page = [[_pdfView document] pageAtIndex:rowIndex];
			[_pdfView goToPage:page];
		}
    }
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  updateSearchTable
- (void)updateSearchTable;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return;
}
#pragma mark =-=-=-=-=-  OUTLINE
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  PDFOutlines
- (iTM2TreeNode *)PDFOutlines;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return metaGETTER;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setPDFOutlines:
- (void)setPDFOutlines:(iTM2TreeNode *)argument;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	metaSETTER(argument);
//iTM2_END;
    return;
}
///=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  outlineView:numberOfChildrenOfItem:
- (int)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [[(item? :[self PDFOutlines]) representedObject] numberOfChildren];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  outlineView:child:ofItem:
- (id)outlineView:(NSOutlineView *)outlineView child:(int)index ofItem:(id)item;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	iTM2TreeNode * node = item? : [self PDFOutlines];
	PDFOutline * OL = [node value];
	unsigned int noc = [OL numberOfChildren];
	[node setCountOfChildren:noc];
	id result = [node objectInChildrenAtIndex:index];
	if(!result || [result isEqual:[NSNull null]])
	{
		PDFOutline * RO = [OL childAtIndex:index];
		result = [[[iTM2TreeNode allocWithZone:[node zone]] initWithParent:node value:RO] autorelease];
		[result setCountOfChildren:[RO numberOfChildren]];
		[node replaceObjectInChildrenAtIndex:index withObject:result];
	}
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  outlineView:isItemExpandable:
- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [self outlineView: (NSOutlineView *) outlineView numberOfChildrenOfItem: (id) item] > 0;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  outlineView:objectValueForTableColumn:byItem:
- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return [[item representedObject] label];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeDestinationFromSelectedItemRepresentedObject:
- (void)takeDestinationFromSelectedItemRepresentedObject:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [_pdfView goToDestination:[[[sender itemAtRow:[sender selectedRow]] representedObject] destination]];
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  updatePDFOutlineInformation
- (void)updatePDFOutlineInformation;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	PDFDocument * doc = [_pdfView document];
    if (![doc outlineRoot])
        return;
    unsigned int newPageIndex = [doc indexForPage:[_pdfView currentPage]];
	int row = [_outlinesView numberOfRows];
    while (row--)
    {
		PDFOutline * OL = [[_outlinesView itemAtRow:row] representedObject];
        if ([doc indexForPage:[[OL destination] page]] <= newPageIndex)
        {
            [_outlinesView selectRow:row byExtendingSelection:NO];
			[_outlinesView scrollRowToVisible:row];
            return;
        }
    }
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  updateOutlineTable
- (void)updateOutlineTable;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(![self PDFOutlines])
	{
		PDFOutline * OLR = [[_pdfView document] outlineRoot];
		[self setPDFOutlines:[[[iTM2TreeNode allocWithZone:[self zone]] initWithParent:nil value:OLR] autorelease]];
		[[self PDFOutlines] setCountOfChildren:[OLR numberOfChildren]];
		[_tabViewControl setEnabled: ([[self PDFOutlines] countOfChildren]>0) forSegment:1];
	}
	[_outlinesView reloadData];
//iTM2_END;
    return;
}
#pragma mark =-=-=-=-=-  PDFView
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  PDFViewPageChangedNotified:
- (void)PDFViewPageChangedNotified:(NSNotification *)notification;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[[[self window] toolbar] validateVisibleItems];
	PDFPage * page = [_pdfView currentPage];
	[self setDocumentViewVisiblePageNumber:[[page document] indexForPage:page]];
	[self updatePDFOutlineInformation];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  PDFViewScaleChangedNotified:
- (void)PDFViewScaleChangedNotified:(NSNotification *)notification;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self setScaleFactor:[[notification object] scaleFactor]];
	[[[self window] toolbar] validateVisibleItems];
//iTM2_END;
    return;
}
#pragma mark =-=-=-=-=-  PAGE NUMBER
#if 0
    IBOutlet id _pageNumPanel;
    IBOutlet NSTextField *_pageNumPanelText;
- (IBAction)goToPageNumberCanceled:(id)sender;
- (IBAction)goToPageNumberEntered:(id)sender;
- (IBAction)goToPageNumberPanel:(id)sender;
#endif
#pragma mark =-=-=-=-=-  BOOKMARK
#if 0
    IBOutlet NSTextField *_bookmarkLabelField;
    IBOutlet id _bookmarkPanel;
- (IBAction)addBookMarkAdd:(id)sender;
- (IBAction)addBookMarkCancel:(id)sender;
#endif
#pragma mark =-=-=-=-=-  PASSWORD
#if 0
    IBOutlet id _passwordCopyCheck;
    IBOutlet id _passwordPrintCheck;
    IBOutlet NSTextField *_passwordTextField;
    IBOutlet id _passwordViewCheck;
    IBOutlet id _passwordWindow;
- (IBAction)passwordEntered:(id)sender;
- (IBAction)passwordPanelDone:(id)sender;
#endif
#pragma mark =-=-=-=-=-  PRINT
#if 0
- (IBAction)printPreviewCancel:(id)sender;
- (IBAction)printPreviewPrint:(id)sender;
#endif
#pragma mark =-=-=-=-=-  SEARCH
#if 0
- (IBAction)doFind:(id)sender;
- (IBAction)doFindNext:(id)sender;
- (IBAction)doFindPrevious:(id)sender;
- (IBAction)doSearchField:(id)sender;
#endif
#pragma mark =-=-=-=-=-  SCALE
#if 0
    IBOutlet id _scalePanel;
    IBOutlet NSTextField *_scalePanelText;
- (IBAction)scaleFactorCancel:(id)sender;
- (IBAction)scaleFactorEnter:(id)sender;
#endif
#if 0
    IBOutlet NSPanel *_crop1PagePanel;
    IBOutlet NSPanel *_cropManyPagesPanel;
    IBOutlet NSPanel *_unCrop1PagePanel;
    IBOutlet NSPanel *_unCropManyPagesPanel;
    IBOutlet NSTableView *_thumbnailTable;

- (IBAction)cropAllPages:(id)sender;
- (IBAction)cropCancel:(id)sender;
- (IBAction)cropCurrentPage:(id)sender;
- (IBAction)displayCropBox:(id)sender;
- (IBAction)displayMediaBox:(id)sender;

- (IBAction)refreshBackForwardState:(id)sender;
- (IBAction)refreshDisplayBoxState:(id)sender;

- (IBAction)annotateTool:(id)sender;
- (IBAction)scrollTool:(id)sender;
- (IBAction)selectTool:(id)sender;
- (IBAction)textTool:(id)sender;

- (IBAction)setCircleAnnotation:(id)sender;
- (IBAction)setFreeTextAnnotation:(id)sender;
- (IBAction)softProofToggle:(id)sender;
#endif
#pragma mark =-=-=-=-=-  TOOL MODE
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toolMode
- (iTM2ToolMode)toolMode;
{
	return [metaGETTER intValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setToolMode:
- (void)setToolMode:(iTM2ToolMode)argument;
{
	metaSETTER([NSNumber numberWithInt: (int)argument]);
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  canSynchronizeOutput
- (BOOL)canSynchronizeOutput;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= displayPhysicalPage:synchronizationPoint:withHint:
- (void)displayPhysicalPage:(int)page synchronizationPoint:(NSPoint)P withHint:(NSDictionary *)hint;
/*"Description Forthcoming. The first responder must never be the window but at least its content view unless we want to neutralize the iTM2FlagsChangedResponder.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//NSLog
//NSLog(@"dpn");
    [_pdfView takeCurrentPhysicalPage:page synchronizationPoint:P withHint:hint];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= synchronizeWithDestinations:hint:
- (BOOL)synchronizeWithDestinations:(NSDictionary *)destinations hint:(NSDictionary *)hint;
/*"Description Forthcoming. The first responder must never be the window but at least its content view unless we want to neutralize the iTM2FlagsChangedResponder.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//NSLog
//NSLog(@"dpn");
    return [[self album] synchronizeWithDestinations: (NSDictionary *) destinations hint: (NSDictionary *) hint];
}
#define GETTER [[self contextValueForKey:@"iTM2PDFKit"] valueForKey:iTM2KeyFromSelector(_cmd)]
#define SETTER(argument) id __D = [[[self contextDictionaryForKey:@"iTM2PDFKit"] mutableCopy] autorelease];\
if(!__D) __D = [NSMutableDictionary dictionary];\
[__D setValue:argument forKey:iTM2KeyFromSelector(_cmd)];\
[self takeContextValue:__D forKey:@"iTM2PDFKit"];
#pragma mark =-=-=-=-=-  MODEL
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  prepareViewCompleteSaveContext:
- (void)prepareViewCompleteSaveContext:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue May  3 16:20:26 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_LOG(@"[self contextDictionary] is: %@", [self contextDictionary]);
	[self setDocumentViewVisibleRect:[[_pdfView documentView] visibleRect]];
//iTM2_START;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  contextDidChange
- (void)contextDidChange;
/*"This message is sent each time the contextManager have changed.
The receiver will take appropriate actions to synchronize its state with its contextManager.
Subclasses will most certainly override this method because the default implementation does nothing.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 03/26/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	PDFView * V = _pdfView;
	[V setBackgroundColor:[self backgroundColor]];
//iTM2_LOG(@"[V backgroundColor]: %@", [V backgroundColor]);
	[V setDisplayMode:[self displayMode]];
//iTM2_LOG(@"[V backgroundColor]: %@", [V backgroundColor]);
	[V setDisplaysPageBreaks:[self displaysPageBreaks]];
//iTM2_LOG(@"[V displaysPageBreaks]: %@", ([V displaysPageBreaks]? @"Y": @"N"));
	[V setDisplayBox:[self displayBox]];
	[V setDisplaysAsBook:[self displaysAsBook]];
//iTM2_LOG(@"[V displaysAsBook]: %@", ([V displaysAsBook]? @"Y": @"N"));
	[V setShouldAntiAlias:[self shouldAntiAlias]];
//iTM2_LOG(@"[V shouldAntiAlias]: %@", ([V shouldAntiAlias]? @"Y": @"N"));
	[V setGreekingThreshold:[self greekingThreshold]];
	[V setScaleFactor:[self scaleFactor]];
	[V setAutoScales:[self autoScales]];
//iTM2_LOG(@"[V autoScales]: %@", ([V autoScales]? @"Y": @"N"));
	[V setNeedsDisplay:YES];
	if([V documentView])
	{
#if 0
		// I don't remember why it was timed, an EXC_BAD_ACCESS somewhere
		[NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(timedSynchronizeDocumentView:) userInfo:[NSValue valueWithRect:[self documentViewVisibleRect]] repeats:NO];
#else
		unsigned int pageIndex = [self documentViewVisiblePageNumber];
		PDFDocument * doc = [V document];
		if(pageIndex < [doc pageCount])
		{
			[V goToPage:[doc pageAtIndex:pageIndex]];
			[[V documentView] scrollRectToVisible:[self documentViewVisibleRect]];
		}
#endif
	}
	else
	{
		iTM2_LOG(@"NO VIEW...");
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  timedSynchronizeDocumentView:
- (void)timedSynchronizeDocumentView:(NSTimer *)timer;
{
//iTM2_START;
	PDFView * V = _pdfView;
	unsigned int pageIndex = [self documentViewVisiblePageNumber];
	PDFDocument * doc = [V document];
	if(pageIndex < [doc pageCount])
	{
		[V goToPage:[doc pageAtIndex:pageIndex]];
		[[V documentView] scrollRectToVisible:[self documentViewVisibleRect]];
	}
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  documentViewVisibleRect
- (NSRect)documentViewVisibleRect;
{
	return NSRectFromString(GETTER);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setDocumentViewVisibleRect:
- (void)setDocumentViewVisibleRect:(NSRect)argument;
{
	SETTER(NSStringFromRect(argument));
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  documentViewVisiblePageNumber
- (unsigned int)documentViewVisiblePageNumber
{
	return [GETTER unsignedIntValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setDocumentViewVisiblePageNumber:
- (void)setDocumentViewVisiblePageNumber:(unsigned int)argument;
{
	SETTER([NSNumber numberWithUnsignedInt:argument]);
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  backgroundColor
- (NSColor *)backgroundColor;
{
	
	NSData * data = GETTER;
	if(data)
	{
		id result = [NSUnarchiver unarchiveObjectWithData:data];
		if([result isKindOfClass:[NSColor class]])
			return result;
	}
	return [[[[PDFView allocWithZone:[self zone]] initWithFrame:NSZeroRect] autorelease] backgroundColor];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setBackgroundColor:
- (void)setBackgroundColor:(NSColor *)argument;
{
	SETTER(([argument isKindOfClass:[NSColor class]]?[NSArchiver archivedDataWithRootObject:argument]: nil));
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  displayBox
- (int)displayBox;
{
	return [GETTER intValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setDisplayBox:
- (void)setDisplayBox:(int)argument;
{
	SETTER([NSNumber numberWithInt:argument]);
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  displayMode
- (PDFDisplayMode)displayMode;
{
	return [GETTER intValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setDisplayMode:
- (void)setDisplayMode:(PDFDisplayMode)argument;
{
	SETTER([NSNumber numberWithInt: (int)argument]);
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  greekingThreshold
- (float)greekingThreshold;
{
	return [GETTER floatValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setGreekingThreshold:
- (void)setGreekingThreshold:(float)argument;
{
	SETTER([NSNumber numberWithFloat: (float)argument]);
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  scaleFactor
- (float)scaleFactor;
{
	return [GETTER floatValue]?:1.0;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setScaleFactor:
- (void)setScaleFactor:(float)argument;
{
	SETTER([NSNumber numberWithFloat: (float)argument]);
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  shouldAntiAlias
- (BOOL)shouldAntiAlias;
{
	return [GETTER boolValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setShouldAntiAlias:
- (void)setShouldAntiAlias:(BOOL)argument;
{
	SETTER([NSNumber numberWithBool: (int)argument]);
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  autoScales
- (BOOL)autoScales;
{
	return [GETTER boolValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setAutoScales:
- (void)setAutoScales:(BOOL)argument;
{
	SETTER([NSNumber numberWithBool:argument]);
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  displaysAsBook
- (BOOL)displaysAsBook;
{
	return [GETTER boolValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setDisplaysAsBook:
- (void)setDisplaysAsBook:(BOOL)argument;
{
	SETTER([NSNumber numberWithBool:argument]);
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  displaysPageBreaks
- (BOOL)displaysPageBreaks;
{
	return [GETTER boolValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setDisplaysPageBreaks:
- (void)setDisplaysPageBreaks:(BOOL)argument;
{
	SETTER([NSNumber numberWithBool: (int)argument]);
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= autoZoom:
- (IBAction)autoZoom:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Jan  5 17:41:55 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	BOOL old = [self autoScales];
	[self setAutoScales: !old];
	[self contextDidChange];
	[self validateWindowContent];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= validateAutoZoom:
- (BOOL)validateAutoZoom:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Jan  5 17:41:55 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[sender setState: ([self autoScales]? NSOnState:NSOffState)];
//iTM2_END;
    return YES;
}
@end

@implementation iTM2PDFKitInspector(PDFSYNC)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= canSynchronizeOutput
- (BOOL)canSynchronizeOutput;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  scrollSynchronizationPointToVisible:
- (void)scrollSynchronizationPointToVisible:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[_pdfView scrollSynchronizationPointToVisible:sender];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateScrollSynchronizationPointToVisible:
- (BOOL)validateScrollSynchronizationPointToVisible:(NSMenuItem *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return YES;
}
@end

NSString * const iTM2ToolbarNextPageItemIdentifier = @"goToNextPage";
NSString * const iTM2ToolbarPreviousPageItemIdentifier = @"goToPreviousPage";
NSString * const iTM2ToolbarPageItemIdentifier = @"takePageFrom";
NSString * const iTM2ToolbarZoomInItemIdentifier = @"zoomIn";
NSString * const iTM2ToolbarZoomOutItemIdentifier = @"zoomOut";
NSString * const iTM2ToolbarScaleItemIdentifier = @"takeScaleFrom";
NSString * const iTM2ToolbarBackForwardItemIdentifier = @"goBackForward";
NSString * const iTM2ToolbarToolModeItemIdentifier = @"takeToolModeFromSegment";
NSString * const iTM2ToolbarRotateLeftItemIdentifier = @"rotateLeft";
NSString * const iTM2ToolbarRotateRightItemIdentifier = @"rotateRight";
NSString * const iTM2ToolbarActualSizeItemIdentifier = @"actualSize";
NSString * const iTM2ToolbarDoZoomToSelectionItemIdentifier = @"zoomToSelection";
NSString * const iTM2ToolbarDoZoomToFitItemIdentifier = @"zoomToFit";

#if 0
NSString * const iTM2ToolbarItemIdentifier = @"goToFirstPage";
NSString * const iTM2ToolbarItemIdentifier = @"goToLastPage";
NSString * const iTM2ToolbarItemIdentifier = @"takeBackgroundColorFrom";
NSString * const iTM2ToolbarItemIdentifier = @"selectAll";
#endif

@implementation iTM2MainInstaller(PDFKitInspectorToolbar)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  PDFKitInspectorToolbarCompleteInstallation
+ (void)PDFKitInspectorToolbarCompleteInstallation;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue May  3 16:20:26 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[SUD registerDefaults: [NSDictionary dictionaryWithObjectsAndKeys:
		[NSNumber numberWithBool:YES], @"iTM2PDFKitToolbarAutosavesConfiguration",
		[NSNumber numberWithBool:YES], @"iTM2PDFKitToolbarShareConfiguration",
			nil]];
//iTM2_END;
	return;
}
@end

#define DEFINE_TOOLBAR_ITEM(SELECTOR)\
+ (NSToolbarItem *)SELECTOR;{return [self toolbarItemWithIdentifier:[self identifierFromSelector:_cmd] inBundle:[iTM2PDFKitInspector classBundle]];}

@implementation NSToolbarItem(iTM2PDFKit)
DEFINE_TOOLBAR_ITEM(goToNextPageToolbarItem)
DEFINE_TOOLBAR_ITEM(goToPreviousPageToolbarItem)
DEFINE_TOOLBAR_ITEM(takePageFromToolbarItem)
DEFINE_TOOLBAR_ITEM(zoomInToolbarItem)
DEFINE_TOOLBAR_ITEM(zoomOutToolbarItem)
DEFINE_TOOLBAR_ITEM(takeScaleFromToolbarItem)
DEFINE_TOOLBAR_ITEM(goBackForwardToolbarItem)
DEFINE_TOOLBAR_ITEM(takeToolModeFromSegmentToolbarItem)
DEFINE_TOOLBAR_ITEM(rotateLeftToolbarItem)
DEFINE_TOOLBAR_ITEM(rotateRightToolbarItem)
DEFINE_TOOLBAR_ITEM(actualSizeToolbarItem)
DEFINE_TOOLBAR_ITEM(doZoomToSelectionToolbarItem)
DEFINE_TOOLBAR_ITEM(doZoomToFitToolbarItem)
@end

@implementation iTM2PDFKitInspector(Toolbar)
#pragma mark =-=-=-=-=-  TOOLBAR
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setupToolbarWindowDidLoad
- (void)setupToolbarWindowDidLoad;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue May  3 16:20:26 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSAssert(_toolbarBackForwardView, @"Missing _toolbarBackForwardView connection...");
	NSSegmentedCell * segmentedCell = [_toolbarBackForwardView cell];
	[segmentedCell setAction:@selector(goBackForward:)];
	[segmentedCell setTarget:self];
	//
	NSAssert(_toolbarToolModeView, @"Missing _toolbarToolModeView connection...");
	segmentedCell = [_toolbarToolModeView cell];
	[segmentedCell setTrackingMode:NSSegmentSwitchTrackingSelectOne];
	[segmentedCell setSegmentCount:4];
	[segmentedCell setImage:[NSImage imageMoveToolAdorn] forSegment:kiTM2MoveToolMode];
	[segmentedCell setTag:kiTM2MoveToolMode forSegment:kiTM2MoveToolMode];
	[segmentedCell setImage:[NSImage imageTextToolAdorn] forSegment:kiTM2TextToolMode];
	[segmentedCell setTag:kiTM2TextToolMode forSegment:kiTM2TextToolMode];
	[segmentedCell setImage:[NSImage imageSelectToolAdorn] forSegment:kiTM2SelectToolMode];
	[segmentedCell setTag:kiTM2SelectToolMode forSegment:kiTM2SelectToolMode];
	[segmentedCell setImage:[NSImage imageAnnotateTool1AdornDisclosure] forSegment:kiTM2AnnotateToolMode];
	[segmentedCell setTag:kiTM2AnnotateToolMode forSegment:kiTM2AnnotateToolMode];
	[segmentedCell setAction:NULL];
	[segmentedCell setTarget:nil];
	[_toolbarToolModeView setFrameSize:[segmentedCell cellSize]];
	//
    NSToolbar * toolbar = [[[NSToolbar alloc] initWithIdentifier:iTM2PDFKitToolbarIdentifier] autorelease];
	NSString * key = [NSString stringWithFormat:@"NSToolbar Configuration %@", [toolbar identifier]];
	if([self contextBoolForKey:@"iTM2PDFKitToolbarShareConfiguration"])
	{
		NSDictionary * configDictionary = [SUD dictionaryForKey:key];
		if([configDictionary count])
		{
			[toolbar setConfigurationFromDictionary:configDictionary];
			if(![[toolbar items] count])
			{
				[SUD removeObjectForKey:key];
				toolbar = [[[NSToolbar alloc] initWithIdentifier:iTM2PDFKitToolbarIdentifier] autorelease];
			}
		}
	}
	else
	{
		NSDictionary * configDictionary = [SUD dictionaryForKey:key];
//iTM2_LOG(@"configDictionary: %@", configDictionary);
		configDictionary = [self contextDictionaryForKey:key];
//iTM2_LOG(@"configDictionary: %@", configDictionary);
		if([configDictionary count])
			[toolbar setConfigurationFromDictionary:configDictionary];
		if(![[toolbar items] count])
		{
			configDictionary = [SUD dictionaryForKey:key];
//iTM2_LOG(@"configDictionary: %@", configDictionary);
			[self takeContextValue:nil forKey:key];
			if([configDictionary count])
				[toolbar setConfigurationFromDictionary:configDictionary];
			if(![[toolbar items] count])
			{
				[SUD removeObjectForKey:key];
				toolbar = [[[NSToolbar alloc] initWithIdentifier:iTM2PDFKitToolbarIdentifier] autorelease];
			}
		}
	}
	[toolbar setAutosavesConfiguration:YES];
    [toolbar setAllowsUserCustomization:YES];
//    [toolbar setSizeMode:NSToolbarSizeModeSmall];
    [toolbar setDelegate:self];
    [[self window] setToolbar:toolbar];
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleShareToolbarConfiguration:
- (void)toggleShareToolbarConfiguration:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue May  3 16:20:26 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	BOOL old = [self contextBoolForKey:@"iTM2PDFKitToolbarShareConfiguration"];
	[self takeContextBool: !old forKey:@"iTM2PDFKitToolbarShareConfiguration"];
	[self validateWindowContent];
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleShareToolbarConfiguration:
- (BOOL)validateToggleShareToolbarConfiguration:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue May  3 16:20:26 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[sender setState: ([self contextBoolForKey:@"iTM2PDFKitToolbarShareConfiguration"]? NSOnState:NSOffState)];
//iTM2_END;
	return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  prepareToolbarConfigurationCompleteSaveContext:
- (void)prepareToolbarConfigurationCompleteSaveContext:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue May  3 16:20:26 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([self contextBoolForKey:@"iTM2PDFKitToolbarAutosavesConfiguration"])
	{
		NSToolbar * toolbar = [[self window] toolbar];
		NSString * key = [NSString stringWithFormat:@"NSToolbar Configuration %@", [toolbar identifier]];
		[self takeContextValue:[toolbar configurationDictionary] forKey:key];
	}
//iTM2_START;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toolbar:itemForItemIdentifier:willBeInsertedIntoToolbar:
- (NSToolbarItem *)toolbar:(NSToolbar *)toolbar itemForItemIdentifier:(NSString *)itemIdent willBeInsertedIntoToolbar:(BOOL)willBeInserted;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue May  3 16:20:26 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    // Required delegate method:  Given an item identifier, this method returns an item 
    // The toolbar will use this method to obtain toolbar items that can be displayed in the customization sheet, or in the toolbar itself 
    NSToolbarItem * toolbarItem = nil;
	SEL action = NSSelectorFromString([itemIdent stringByAppendingString:@":"]);
	if(action == @selector(goBackForward:))
	{
		if(willBeInserted && [IMPLEMENTATION metaValueForKey:@"toolbar back forward"])
			return nil;
		toolbarItem = [NSToolbarItem seedToolbarItemWithIdentifier:itemIdent forToolbarIdentifier:[toolbar identifier]];
		NSControl * F = _toolbarBackForwardView;
		[toolbarItem setView:F];
		[toolbarItem setMinSize:[F frame].size];
		[toolbarItem setMaxSize:[F frame].size];
		[F setAction:action];
		[F setTarget:nil];
		if(willBeInserted)
			[IMPLEMENTATION takeMetaValue:F forKey:@"toolbar back forward"];
	}
	else if(action == @selector(takeToolModeFromSegment:))
	{
		if(willBeInserted && [IMPLEMENTATION metaValueForKey:@"toolbar select tool mode"])
			return nil;
		toolbarItem = [NSToolbarItem seedToolbarItemWithIdentifier:itemIdent forToolbarIdentifier:[toolbar identifier]];
		NSControl * F = _toolbarToolModeView;
		[toolbarItem setView:F];
		[toolbarItem setMinSize:[F frame].size];
		[toolbarItem setMaxSize:[F frame].size];
		[F setAction:action];
		[F setTarget:nil];
		if(willBeInserted)
			[IMPLEMENTATION takeMetaValue:F forKey:@"toolbar select tool mode"];
	}
	else if(action == @selector(takeScaleFrom:))
	{
		if(willBeInserted && [IMPLEMENTATION metaValueForKey:@"toolbar scale field"])
			return nil;
		NSTextField * F = [[[NSTextField alloc] initWithFrame:NSZeroRect] autorelease];
		[F setAction:action];
		[F setTarget:nil];
		iTM2MagnificationFormatter * NF = [[[iTM2MagnificationFormatter allocWithZone:[self zone]] init] autorelease];
		[F setFormatter:NF];
		[F setDelegate:NF];
		[F setFrameOrigin:NSMakePoint(4,6)];
		[[F cell] setSendsActionOnEndEditing:NO];
		if(willBeInserted)
		{
			[F setFloatValue:1];
		}
		else
		{
			[F setFloatValue:[_pdfView scaleFactor]];
		}
		[F setFrameSize:NSMakeSize([[NF stringForObjectValue:[NSNumber numberWithFloat:[F floatValue]]]
						sizeWithAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
								[[F cell] font], NSFontAttributeName, nil]].width+8, 22)];
		[F setTag:421];
		toolbarItem = [NSToolbarItem seedToolbarItemWithIdentifier:itemIdent forToolbarIdentifier:[toolbar identifier]];
		[toolbarItem setView:F];
		[toolbarItem setMinSize:[F frame].size];
		[toolbarItem setMaxSize:[F frame].size];
		[F setAction:action];
		[F setTarget:nil];
		if(willBeInserted)
			[IMPLEMENTATION takeMetaValue:F forKey:@"toolbar scale field"];
	}
	else if(action == @selector(takePageFrom:))
	{
		if(willBeInserted && [IMPLEMENTATION metaValueForKey:@"toolbar page field"])
			return nil;
		NSTextField * F = [[[NSTextField alloc] initWithFrame:NSZeroRect] autorelease];
		[F setAction:action];
		[F setTarget:nil];
		iTM2NavigationFormatter * NF = [[[iTM2NavigationFormatter alloc] init] autorelease];
		[F setFormatter:NF];
		[F setDelegate:NF];
		[F setFrameOrigin:NSMakePoint(4,6)];
		[[F cell] setSendsActionOnEndEditing:NO];
		int maximum = 1000;
		[F setFrameSize:NSMakeSize([[NF stringForObjectValue:[NSNumber numberWithInt:maximum]]
						sizeWithAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
								[[F cell] font], NSFontAttributeName, nil]].width+8, 22)];
		if(willBeInserted)
		{
			PDFPage * page = [_pdfView currentPage];
			PDFDocument * document = [page document];
			unsigned int pageCount = [document indexForPage:page];
			[F setIntValue:pageCount+1];
			pageCount = [document pageCount];
			[NF setMaximum:[NSNumber numberWithInt:pageCount]];
		}
		else
			[F setStringValue:@"421"];
		[F setTag:421];
		toolbarItem = [NSToolbarItem seedToolbarItemWithIdentifier:itemIdent forToolbarIdentifier:[toolbar identifier]];
		[toolbarItem setView:F];
		[toolbarItem setMinSize:[F frame].size];
		[toolbarItem setMaxSize:[F frame].size];
		[F setAction:action];
		[F setTarget:nil];
		if(willBeInserted)
			[IMPLEMENTATION takeMetaValue:F forKey:@"toolbar page field"];
	}
	else if(action)
	{
//id objc_msgSend(id theReceiver, SEL theSelector, ...);
		toolbarItem = [NSToolbarItem seedToolbarItemWithIdentifier:itemIdent forToolbarIdentifier:[toolbar identifier]];
		[toolbarItem setAction:action];
		[toolbarItem setTarget:nil];
	}
    #if 0
    if ([itemIdent isEqual:SaveDocToolbarItemIdentifier])
	{
		toolbarItem = [[[NSToolbarItem alloc] initWithItemIdentifier:itemIdent] autorelease];
		
			// Set the text label to be displayed in the toolbar and customization palette 
		[toolbarItem setLabel:@"Save"];
		[toolbarItem setPaletteLabel:@"Save"];
		
		// Set up a reasonable tooltip, and image   Note, these aren't localized, but you will likely want to localize many of the item's properties 
		[toolbarItem setToolTip:@"Save Your Document"];
		[toolbarItem setImage:[NSImage imageNamed:@"SaveDocumentItemImage"]];
		
		// Tell the item what message to send when it is clicked 
		[toolbarItem setTarget:self];
		[toolbarItem setAction:@selector(saveDocument:)];
    }
	else if([itemIdent isEqual:SearchDocToolbarItemIdentifier])
	{
			// NSToolbarItem doens't normally autovalidate items that hold custom views, but we want this guy to be disabled when there is no text to search.
			toolbarItem = [[[ValidatedViewToolbarItem alloc] initWithItemIdentifier:itemIdent] autorelease];

		NSMenu *submenu = nil;
		NSMenuItem *submenuItem = nil, *menuFormRep = nil;
		
		// Set up the standard properties 
		[toolbarItem setLabel:@"Search"];
		[toolbarItem setPaletteLabel:@"Search"];
		[toolbarItem setToolTip:@"Search Your Document"];
		
			searchFieldOutlet = [[NSSearchField alloc] initWithFrame:[searchFieldOutlet frame]];
		// Use a custom view, a text field, for the search item 
		[toolbarItem setView:searchFieldOutlet];
		[toolbarItem setMinSize:NSMakeSize(30, NSHeight([searchFieldOutlet frame]))];
		[toolbarItem setMaxSize:NSMakeSize(400,NSHeight([searchFieldOutlet frame]))];

		// By default, in text only mode, a custom items label will be shown as disabled text, but you can provide a 
		// custom menu of your own by using <item> setMenuFormRepresentation] 
		submenu = [[[NSMenu alloc] init] autorelease];
		submenuItem = [[[NSMenuItem alloc] initWithTitle:@"Search Panel" action:@selector(searchUsingSearchPanel:) keyEquivalent:@""] autorelease];
		menuFormRep = [[[NSMenuItem alloc] init] autorelease];

		[submenu addItem:submenuItem];
		[submenuItem setTarget:self];
		[menuFormRep setSubmenu:submenu];
		[menuFormRep setTitle:[toolbarItem label]];

        // Normally, a menuFormRep with a submenu should just act like a pull down.  However, in 10.4 and later, the menuFormRep can have its own target / action.  If it does, on click and hold (or if the user clicks and drags down), the submenu will appear.  However, on just a click, the menuFormRep will fire its own action.
        [menuFormRep setTarget:self];
        [menuFormRep setAction:@selector(searchMenuFormRepresentationClicked:)];

        // Please note, from a user experience perspective, you wouldn't set up your search field and menuFormRep like we do here.  This is simply an example which shows you all of the features you could use.
		[toolbarItem setMenuFormRepresentation:menuFormRep];
    }
	else
	{
		// itemIdent refered to a toolbar item that is not provide or supported by us or cocoa 
		// Returning nil will inform the toolbar this kind of item is not supported 
		toolbarItem = nil;
    }
	#endif
//iTM2_END;
    return toolbarItem;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toolbarDefaultItemIdentifiers:
- (NSArray *)toolbarDefaultItemIdentifiers:(NSToolbar *)toolbar;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue May  3 16:20:26 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    // Required delegate method:  Returns the ordered list of items to be shown in the toolbar by default    
    // If during the toolbar's initialization, no overriding values are found in the usermodel, or if the
    // user chooses to revert to the default items this set will be used 
//iTM2_END;
    return [NSArray arrayWithObjects:
				iTM2ToolbarToggleDrawerItemIdentifier,
				NSToolbarSeparatorItemIdentifier,
				iTM2ToolbarPreviousPageItemIdentifier,
				iTM2ToolbarNextPageItemIdentifier,
				iTM2ToolbarPageItemIdentifier,
				iTM2ToolbarBackForwardItemIdentifier,
				NSToolbarSpaceItemIdentifier,
				iTM2ToolbarZoomInItemIdentifier,
				iTM2ToolbarZoomOutItemIdentifier,
				iTM2ToolbarScaleItemIdentifier,
				NSToolbarFlexibleSpaceItemIdentifier,
				iTM2ToolbarRotateLeftItemIdentifier,
				iTM2ToolbarRotateRightItemIdentifier,
				iTM2ToolbarToolModeItemIdentifier,
					nil];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toolbarAllowedItemIdentifiers:
- (NSArray *)toolbarAllowedItemIdentifiers:(NSToolbar *)toolbar;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue May  3 16:20:26 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    // Required delegate method:  Returns the list of all allowed items by identifier.  By default, the toolbar 
    // does not assume any items are allowed, even the separator.  So, every allowed item must be explicitly listed   
    // The set of allowed items is used to construct the customization palette 
//iTM2_END;
    return [NSArray arrayWithObjects:
					iTM2ToolbarToggleDrawerItemIdentifier,
					iTM2ToolbarBackForwardItemIdentifier,
					iTM2ToolbarPageItemIdentifier,
					iTM2ToolbarPreviousPageItemIdentifier,
					iTM2ToolbarNextPageItemIdentifier,
					iTM2ToolbarScaleItemIdentifier,
					iTM2ToolbarActualSizeItemIdentifier,
					iTM2ToolbarZoomInItemIdentifier,
					iTM2ToolbarZoomOutItemIdentifier,
					iTM2ToolbarDoZoomToSelectionItemIdentifier,
					iTM2ToolbarDoZoomToFitItemIdentifier,
					iTM2ToolbarRotateLeftItemIdentifier,
					iTM2ToolbarRotateRightItemIdentifier,
					iTM2ToolbarToolModeItemIdentifier,
					NSToolbarSeparatorItemIdentifier,
					NSToolbarPrintItemIdentifier, 
					NSToolbarSpaceItemIdentifier,
					NSToolbarFlexibleSpaceItemIdentifier,
					NSToolbarCustomizeToolbarItemIdentifier,
//					NSToolbarShowColorsItemIdentifier,
//					NSToolbarShowFontsItemIdentifier,
							nil];
}
#if 0
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toolbarWillAddItem:
- (void)toolbarWillAddItem:(NSNotification *)notif;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue May  3 16:20:26 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    // Optional delegate method:  Before an new item is added to the toolbar, this notification is posted.
    // This is the best place to notice a new item is going into the toolbar.  For instance, if you need to 
    // cache a reference to the toolbar item or need to set up some initial state, this is the best place 
    // to do it.  The notification object is the toolbar to which the item is being added.  The item being 
    // added is found by referencing the @"item" key in the userInfo 
    NSToolbarItem *addedItem = [[notif userInfo] objectForKey:@"item"];
//iTM2_END;
    return;
}  
#endif
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toolbarDidRemoveItem:
- (void)toolbarDidRemoveItem:(NSNotification *)notif;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue May  3 16:20:26 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    // Optional delegate method:  Before an new item is added to the toolbar, this notification is posted.
    // This is the best place to notice a new item is going into the toolbar.  For instance, if you need to 
    // cache a reference to the toolbar item or need to set up some initial state, this is the best place 
    // to do it.  The notification object is the toolbar to which the item is being added.  The item being 
    // added is found by referencing the @"item" key in the userInfo 
    NSToolbarItem * removedItem = [[notif userInfo] objectForKey:@"item"];
	if([[removedItem itemIdentifier] isEqual:iTM2ToolbarPageItemIdentifier])
	{
		[IMPLEMENTATION takeMetaValue:nil forKey:@"toolbar page field"];
	}
//iTM2_END;
    return;
}  
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  rotateLeft:
- (IBAction)rotateLeft:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue May  3 16:20:26 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	PDFPage * currentPage = [_pdfView currentPage];
	int rotation = [currentPage rotation];
	rotation -= 90;
	[currentPage setRotation:rotation];
	[_pdfView setNeedsDisplay:YES];
	[self validateWindowContent];
//iTM2_END;
    return;
}  
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  rotateRight:
- (IBAction)rotateRight:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue May  3 16:20:26 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	PDFPage * currentPage = [_pdfView currentPage];
	int rotation = [currentPage rotation];
	rotation += 90;
	[currentPage setRotation:rotation];
	[_pdfView setNeedsDisplay:YES];
	[self validateWindowContent];
//iTM2_END;
    return;
}  
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takePageFrom:
- (IBAction)takePageFrom:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue May  3 16:20:26 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    unsigned int n = (unsigned int)[sender intValue];
	if(n<1)
		n = 0;
	else
		--n;
	PDFPage * page = [_pdfView currentPage];
	PDFDocument * document = [page document];
	unsigned int pageCount = [document pageCount];
	if(n<pageCount)
		[_pdfView goToPage:[document pageAtIndex:n]];
//iTM2_END;
	[self validateWindowContent];
    return;
}  
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateTakePageFrom:
- (BOOL)validateTakePageFrom:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue May  3 16:20:26 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([[sender currentEditor] isEqual:[[sender window] firstResponder]])
		return YES;
	if(![[sender window] isEqual:[self window]])
		return YES;
	PDFPage * page = [_pdfView currentPage];
	PDFDocument * document = [page document];
	unsigned int pageCount = [document indexForPage:page];
	[sender setIntValue:pageCount+1];
	pageCount = [document pageCount];
	NSNumberFormatter * NF = [sender formatter];
	[NF setMaximum:[NSNumber numberWithInt:pageCount]];
	NSSize oldSize = [sender frame].size;
	float width = 8 + MAX(
		([[NF stringForObjectValue:[NSNumber numberWithInt:[sender intValue]]]
				sizeWithAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
							[[sender cell] font], NSFontAttributeName, nil]].width),
		([[NF stringForObjectValue:[NSNumber numberWithInt:99]]
				sizeWithAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
							[[sender cell] font], NSFontAttributeName, nil]].width));
	[sender setFrameSize:NSMakeSize(width, oldSize.height)];
	NSEnumerator * E = [[[[sender window] toolbar] items] objectEnumerator];
	NSToolbarItem * TBI;
	while(TBI = [E nextObject])
	{
		if(sender == [TBI view])
		{
			[TBI setMinSize:[sender frame].size];
			[TBI setMaxSize:[sender frame].size];
			break;
		}
	}
//iTM2_END;
    return YES;
}  
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeScaleFrom:
- (IBAction)takeScaleFrom:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue May  3 16:20:26 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	float newScale = [sender floatValue];
	if(newScale <= 0)
		newScale = 1;
    [_pdfView setScaleFactor:newScale];
	[self validateWindowContent];
//iTM2_END;
    return;
}  
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateTakeScaleFrom:
- (BOOL)validateTakeScaleFrom:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue May  3 16:20:26 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([[sender currentEditor] isEqual:[[sender window] firstResponder]])
		return YES;
	if(![[sender window] isEqual:[self window]])
		return YES;
	[sender setFloatValue:[_pdfView scaleFactor]];
	NSNumberFormatter * NF = [sender formatter];
	NSSize oldSize = [sender frame].size;
	float width = 8 + MAX(
			([[NF stringForObjectValue:[NSNumber numberWithFloat:[sender floatValue]]]
				sizeWithAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
							[[sender cell] font], NSFontAttributeName, nil]].width),
			([[NF stringForObjectValue:[NSNumber numberWithFloat:1]]
				sizeWithAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
							[[sender cell] font], NSFontAttributeName, nil]].width));
	[sender setFrameSize:NSMakeSize(width, oldSize.height)];
	NSEnumerator * E = [[[[sender window] toolbar] items] objectEnumerator];
	NSToolbarItem * TBI;
	while(TBI = [E nextObject])
	{
		if(sender == [TBI view])
		{
			[TBI setMinSize:[sender frame].size];
			[TBI setMaxSize:[sender frame].size];
			break;
		}
	}
//iTM2_END;
    return YES;
}  
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  goBackForward:
- (IBAction)goBackForward:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue May  3 16:20:26 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([sender selectedSegment])
	{
		[_pdfView goForward:sender];
	}
	else
	{
		[_pdfView goBack:sender];
	}
	[self validateWindowContent];
//iTM2_END;
    return;
}  
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateGoBackForward:
- (BOOL)validateGoBackForward:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue May  3 16:20:26 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(![[sender window] isEqual:[self window]])
		return YES;
	BOOL isEnabled = NO;
	if([_pdfView canGoBack])
	{
		[sender setEnabled:YES forSegment:0];
		isEnabled = YES;
	}
	else
		[sender setEnabled:NO forSegment:0];
	if([_pdfView canGoForward])
	{
		[sender setEnabled:YES forSegment:1];
		isEnabled = YES;
	}
	else
		[sender setEnabled:NO forSegment:1];
//iTM2_END;
    return isEnabled;
}  
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeToolModeFromSegment:
- (IBAction)takeToolModeFromSegment:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSSegmentedCell * cell = [sender cell];
	iTM2ToolMode toolMode = [cell tagForSegment:[sender selectedSegment]];
	[self setToolMode:toolMode];
	[self validateWindowContent];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateTakeToolModeFromSegment:
- (BOOL)validateTakeToolModeFromSegment:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(![[sender window] isEqual:[self window]])
		return YES;
	iTM2ToolMode toolMode = [self toolMode];
	if(![sender selectSegmentWithTag:toolMode])
	{
		[self setToolMode:kiTM2MoveToolMode];
		[sender selectSegmentWithTag:[self toolMode]];
	}
//iTM2_END;
    return YES;
}
@end

@implementation iTM2PDFKitView
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  dealloc
+ (void)initialize;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[super initialize];
	[SUD registerDefaults: [NSDictionary dictionaryWithObjectsAndKeys:
		[NSNumber numberWithInt:10], @"iTM2PDFKitSyncMaxNumberOfMatches",
		[NSDictionary dictionaryWithObjectsAndKeys:
			[NSNumber numberWithBool:YES], @"EnableSynchronization",
			[NSNumber numberWithBool:YES], @"FollowFocus",
			[NSNumber numberWithUnsignedInt:7], @"DisplayBullets",
							nil], @"iTM2PDFKitSync",
				nil]];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initWithFrame:
- (id)initWithFrame:(NSRect)rect;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(self = [super initWithFrame:rect])
	{
		[self initImplementation];
	}
//iTM2_END;
    return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initWithCoder:
- (id)initWithCoder:(NSCoder *)aDecoder;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(self = [super initWithCoder:aDecoder])
	{
		[self initImplementation];
	}
//iTM2_END;
    return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  dealloc
- (void)dealloc;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self deallocImplementation];
	[super dealloc];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  implementation
- (id)implementation;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon May 10 22:45:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return _Implementation;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setImplementation:
- (void)setImplementation:(id)argument;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon May 10 22:45:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[_Implementation autorelease];
	_Implementation = [argument retain];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setDocument:
- (void)setDocument:(PDFDocument *)document;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id oldDocument = [self document];
	if(document != oldDocument)
	{
		[_SyncDestination autorelease];// this destination points to the document
		_SyncDestination = nil;// it must be updated
		[_SyncPointValues autorelease];// this destination points to the document
		_SyncPointValues = nil;// it must be updated
		[_SyncDestinations autorelease];
		_SyncDestinations = nil;
		[super setDocument:document];// raise if the document has no pages
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  drawPage:
- (void)drawPage:(PDFPage *)page;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[super drawPage:page];
    NSMethodSignature * sig0 = [self methodSignatureForSelector:_cmd];
    NSInvocation * I = [NSInvocation invocationWithMethodSignature:sig0];
    [I setTarget:self];
    [I setArgument: &page atIndex:2];
	NSEnumerator * E = [[iTM2RuntimeBrowser instanceSelectorsOfClass:isa withSuffix:@"CompleteDrawPage:" signature:sig0 inherited:YES] objectEnumerator];
    SEL selector;
    while(selector = (SEL)[[E nextObject] pointerValue])
    {
//iTM2_LOG(NSStringFromSelector(selector));
        [I setSelector:selector];
        [I invoke];
    }
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  synchronizationCompleteDrawPage:
- (void)synchronizationCompleteDrawPage:(PDFPage *)page;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSMutableDictionary * cd = [[[SUD dictionaryForKey:@"iTM2PDFKitSync"] mutableCopy] autorelease];
	[cd addEntriesFromDictionary:[self contextDictionaryForKey:@"iTM2PDFKitSync"]];
	NSNumber * N = [cd objectForKey:@"EnableSynchronization"];
    if([N respondsToSelector:@selector(boolValue)]? [N boolValue]: NO)
    {
  		iTM2PDFKitDocument * D = [[[self window] windowController] document];
		iTM2PDFSynchronizer * syncer = [D synchronizer];
		if(!syncer)
		{
			[D updatePdfsync:self];
			return;
		}
		NSImage * starDimple = [NSImage imageGreenDimple];
		NSImage * builtInDimple = [NSImage imageBlueDimple];
		NSImage * plusDimple = [NSImage imageGreyDimple];
		unsigned int pageIndex = [[page document] indexForPage:page];
        if([SUD boolForKey:iTM2PDFSyncShowRecordNumberKey])
		{
			NSMutableDictionary * SLs = (NSMutableDictionary*)[syncer synchronizationLocationsForPageIndex:pageIndex];
            NSEnumerator * E = [SLs keyEnumerator];
            iTM2SynchronizationLocationRecord locationRecord;
            NSDictionary * D = [NSDictionary dictionaryWithObjectsAndKeys:
                [NSFont systemFontOfSize:8], NSFontAttributeName,
                [NSColor purpleColor], NSForegroundColorAttributeName, nil];
			NSRect fromRect = NSZeroRect;
			fromRect.size = [starDimple size];
//			fromRect = [self convertRect:fromRect fromView:nil];
			NSRect inRect = [self convertRect:fromRect toPage:page];
			if(inRect.size.width>[starDimple size].width)
			{
				inRect.size = [starDimple size];
			}
			inRect.size.width  /= 2;
			inRect.size.height /= 2;
			NSPoint origin = NSMakePoint(-inRect.size.width/2, -inRect.size.height/2);
			id K;
            while(K = [E nextObject])
            {
                NSValue * V = [SLs objectForKey:K];
                [V getValue: &locationRecord];
                NSPoint P = NSMakePoint(locationRecord.x, locationRecord.y);
				inRect.origin.x = P.x + origin.x;
				inRect.origin.y = P.y + origin.y;
				[starDimple drawInRect:inRect fromRect:fromRect operation:NSCompositeSourceOver fraction:0.3];
				[[NSString stringWithFormat:@"%@", K] drawAtPoint:P withAttributes:D];
            }
			N = [cd objectForKey:@"DisplayBullets"];
			unsigned int displayBulletsMode = [N respondsToSelector:@selector(unsignedIntValue)]? [N unsignedIntValue]: 0;
            if((displayBulletsMode & kiTM2PDFSYNCDisplayFocusBullets) && [[_SyncDestination page] isEqual:page])
            {
				NSImage * syncDimple = [NSImage imageRedDimple];
				NSRect fromRect = NSZeroRect;
				fromRect.size = [syncDimple size];
				NSRect inRect = [self convertRect:fromRect fromView:nil];
				inRect = [self convertRect:inRect toPage:page];
				if(inRect.size.width>[syncDimple size].width)
				{
					inRect.size = [syncDimple size];
				}
				NSPoint syncPoint = [_SyncDestination point];
				inRect.origin.x = syncPoint.x - inRect.size.width/2;
				inRect.origin.y = syncPoint.y - inRect.size.height/2;
				[syncDimple drawInRect:inRect fromRect:fromRect operation:NSCompositeSourceOver fraction:1];
				NSRect bounds = [page boundsForBox: kPDFDisplayBoxCropBox];
				inRect.origin.x = NSMinX(bounds)+inRect.size.width/2;
				inRect.origin.y = syncPoint.y - inRect.size.height/2;
				[syncDimple drawInRect:inRect fromRect:fromRect operation:NSCompositeSourceOver fraction:1];
				inRect.origin.x = NSMaxX(bounds)-3*inRect.size.width/2;
				inRect.origin.y = syncPoint.y - inRect.size.height/2;
				[syncDimple drawInRect:inRect fromRect:fromRect operation:NSCompositeSourceOver fraction:1];
				inRect.origin.x = syncPoint.x - inRect.size.width/2;
				inRect.origin.y = NSMinY(bounds)+inRect.size.height/2;
				[syncDimple drawInRect:inRect fromRect:fromRect operation:NSCompositeSourceOver fraction:1];
				inRect.origin.x = syncPoint.x - inRect.size.width/2;
				inRect.origin.y = NSMaxY(bounds)-3*inRect.size.height/2;
				[syncDimple drawInRect:inRect fromRect:fromRect operation:NSCompositeSourceOver fraction:1];
            }
        }
        else
        {
			N = [cd objectForKey:@"DisplayBullets"];
			unsigned int displayBulletsMode = [N respondsToSelector:@selector(unsignedIntValue)]? [N unsignedIntValue]: 0;
			NSMutableDictionary * SLs = (NSMutableDictionary *)[syncer synchronizationLocationsForPageIndex:pageIndex];
            NSEnumerator * E = [SLs objectEnumerator];
            iTM2SynchronizationLocationRecord locationRecord;
            NSValue * V;
//				[starDimple setScalesWhenResized:YES];
			NSRect fromRect = NSZeroRect;
			NSShadow* theShadow = [[[NSShadow alloc] init] autorelease]; 
			fromRect.size = [starDimple size];
//				fromRect = [self convertRect:fromRect fromView:nil];
			NSRect inRect = [self convertRect:fromRect toPage:page];
			if(inRect.size.width>[starDimple size].width)
			{
				inRect.size = [starDimple size];
				// Use a partially transparent color for shapes that overlap.
				[theShadow setShadowColor:[[NSColor blackColor] colorWithAlphaComponent:0.4]];
			}
			else
			{
				// Use a partially transparent color for shapes that overlap.
				[theShadow setShadowColor:[[NSColor blackColor] colorWithAlphaComponent:0.5*inRect.size.width/[starDimple size].width]];
			}
			inRect.size.width  /= 3;
			inRect.size.height /= 3;
			inRect = NSIntegralRect(inRect);
			inRect.size.width = MAX(inRect.size.width,inRect.size.height);
			inRect.size.height = inRect.size.width;
			NSPoint origin = NSMakePoint(-inRect.size.width/2, -inRect.size.height/2);
			BOOL testForCharacter = YES;
			[theShadow setShadowOffset:NSMakeSize(0,-inRect.size.height*0.25)]; 
			[theShadow setShadowBlurRadius:inRect.size.height*0.15]; 
			[NSGraphicsContext saveGraphicsState]; 
			[theShadow set];
			while(V = [E nextObject])
			{
				[V getValue: &locationRecord];
				NSPoint P = NSMakePoint(locationRecord.x, locationRecord.y);
				if(testForCharacter && !locationRecord.plus && ([page characterIndexNearPoint:P]<0))
				{
					// don't draw;
//iTM2_LOG(@"$$$$  This point does not seem to point to a character: %@", NSStringFromPoint(P));
					goto nextWhile;
				}
				if(locationRecord.star && (displayBulletsMode & kiTM2PDFSYNCDisplayUserBullets))
				{
					inRect.origin.x = P.x + origin.x;
					inRect.origin.y = P.y + origin.y;
					[starDimple drawInRect:inRect fromRect:fromRect operation:NSCompositeSourceOver fraction:0.75];
				}
				else if(displayBulletsMode & kiTM2PDFSYNCDisplayBuiltInBullets)
				{
					inRect.origin.x = P.x + origin.x;
					inRect.origin.y = P.y + origin.y;
					[(locationRecord.plus?plusDimple:builtInDimple) drawInRect:inRect fromRect:fromRect operation:NSCompositeSourceOver fraction:0.75];
				}
				nextWhile:;
			}
            if((displayBulletsMode & kiTM2PDFSYNCDisplayBuiltInBullets) && [[_SyncDestination page] isEqual:page])
            {
				NSImage * syncDimple = [NSImage imageRedDimple];
				NSImage * matchDimple = [NSImage imageOrangeDimple];
//				[starDimple setScalesWhenResized:YES];
				NSRect fromRect = NSZeroRect;
				fromRect.size = [syncDimple size];
//				fromRect = [self convertRect:fromRect fromView:nil];
				NSRect inRect = [self convertRect:fromRect toPage:page];
				if(inRect.size.width>[syncDimple size].width)
				{
					inRect.size = [syncDimple size];
				}
				inRect.size.width  *= 0.25;
				inRect.size.height *= 0.25;
				inRect = NSIntegralRect(inRect);
				inRect.size.width = MAX(inRect.size.width,inRect.size.height);
				inRect.size.height = inRect.size.width;
				NSPoint origin;
				origin.x = - inRect.size.width/2;
				origin.y = - inRect.size.height/2;
				NSPoint syncPoint;
				if([_SyncPointValues count] == 1)
				{
					id temp = syncDimple;
					syncDimple = matchDimple;
					matchDimple = temp;
				}
				NSEnumerator * E = [_SyncPointValues objectEnumerator];
				NSValue * V;
				while(V = [E nextObject])
				{
					syncPoint = [V pointValue];
					inRect.origin.x = syncPoint.x + origin.x;
					inRect.origin.y = syncPoint.y + origin.y;
					[matchDimple drawInRect:inRect fromRect:fromRect operation:NSCompositeSourceOver fraction:0.4];
				}
				inRect = [self convertRect:fromRect fromView:nil];
				inRect = [self convertRect:inRect toPage:page];
				if(inRect.size.width>[syncDimple size].width)
				{
					inRect.size = [syncDimple size];
				}
				inRect = NSIntegralRect(inRect);
				inRect.size.width = MAX(inRect.size.width,inRect.size.height);
				inRect.size.height = inRect.size.width;
				origin.x = - inRect.size.width/2;
				origin.y = - inRect.size.height/2;
				syncPoint = [_SyncDestination point];
				inRect.origin.x = syncPoint.x + origin.x;
				inRect.origin.y = syncPoint.y + origin.y;
				[syncDimple drawInRect:inRect fromRect:fromRect operation:NSCompositeSourceOver fraction:1];
				NSRect bounds = [page boundsForBox: kPDFDisplayBoxCropBox];
				inRect.origin.x = NSMinX(bounds)+inRect.size.width/2;
				inRect.origin.y = syncPoint.y - inRect.size.height/2;
				[syncDimple drawInRect:inRect fromRect:fromRect operation:NSCompositeSourceOver fraction:1];
				inRect.origin.x = NSMaxX(bounds)-3*inRect.size.width/2;
				inRect.origin.y = syncPoint.y - inRect.size.height/2;
				[syncDimple drawInRect:inRect fromRect:fromRect operation:NSCompositeSourceOver fraction:1];
				inRect.origin.x = syncPoint.x - inRect.size.width/2;
				inRect.origin.y = NSMinY(bounds)+inRect.size.height/2;
				[syncDimple drawInRect:inRect fromRect:fromRect operation:NSCompositeSourceOver fraction:1];
				inRect.origin.x = syncPoint.x - inRect.size.width/2;
				inRect.origin.y = NSMaxY(bounds)-3*inRect.size.height/2;
				[syncDimple drawInRect:inRect fromRect:fromRect operation:NSCompositeSourceOver fraction:1];
            }
            if(displayBulletsMode & kiTM2PDFSYNCDisplayFocusBullets)
            {
				NSImage * syncDimple = [NSImage imageRedDimple];
//				[starDimple setScalesWhenResized:YES];
				NSRect fromRect = NSZeroRect;
				fromRect.size = [syncDimple size];
//				fromRect = [self convertRect:fromRect fromView:nil];
				NSRect inRect = [self convertRect:fromRect toPage:page];
				if(inRect.size.width>[syncDimple size].width)
				{
					inRect.size = [syncDimple size];
				}
#if 0
				if(inRect.size.width > 1.2*inRect.size.height)
				{
					inRect.size.width = inRect.size.height;
				}
#endif
				inRect.size.width  *= 0.25;
				inRect.size.height *= 0.25;
				inRect = NSIntegralRect(inRect);
				inRect.size.width = MAX(inRect.size.width,inRect.size.height);
				inRect.size.height = inRect.size.width;
				NSPoint origin;
				origin.x = - inRect.size.width/2;
				origin.y = - inRect.size.height/2;
				NSEnumerator * E = [_SyncDestinations objectEnumerator];
				PDFDestination * destination;
				while(destination = [E nextObject])
				{
					if([[destination page] isEqual:page])
					{
//iTM2_LOG(@"----     destination on that page: %@", destination);
						NSPoint syncPoint = [destination point];
						inRect.origin.x = syncPoint.x + origin.x;
						inRect.origin.y = syncPoint.y + origin.y;
						[syncDimple drawInRect:inRect fromRect:fromRect operation:NSCompositeSourceOver fraction:1];
						NSRect bounds = [page boundsForBox: kPDFDisplayBoxCropBox];
						inRect.origin.x = NSMinX(bounds)+inRect.size.width/2;
						inRect.origin.y = syncPoint.y - inRect.size.height/2;
						[syncDimple drawInRect:inRect fromRect:fromRect operation:NSCompositeSourceOver fraction:1];
						inRect.origin.x = NSMaxX(bounds)-3*inRect.size.width/2;
						inRect.origin.y = syncPoint.y - inRect.size.height/2;
						[syncDimple drawInRect:inRect fromRect:fromRect operation:NSCompositeSourceOver fraction:1];
						inRect.origin.x = syncPoint.x - inRect.size.width/2;
						inRect.origin.y = NSMinY(bounds)+inRect.size.height/2;
						[syncDimple drawInRect:inRect fromRect:fromRect operation:NSCompositeSourceOver fraction:1];
						inRect.origin.x = syncPoint.x - inRect.size.width/2;
						inRect.origin.y = NSMaxY(bounds)-3*inRect.size.height/2;
						[syncDimple drawInRect:inRect fromRect:fromRect operation:NSCompositeSourceOver fraction:1];
					}
					else
					{
//iTM2_LOG(@"----     destination NOT on that page: %@", destination);
					}
				}
            }
			[NSGraphicsContext restoreGraphicsState];
		}
    }
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  centeredSubview:
- (id)centeredSubview;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: Thu Jul 17 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  focusView:
- (id)focusView;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: Thu Jul 17 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return self;
}
@end

@implementation iTM2XtdPDFDocument
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= positionOfWord:options:range:
- (void)dealloc;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	free(__PageStringOffsets);
	__PageStringOffsets = nil;
	[self willDealloc];
	[super dealloc];
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= __SetupPageStringOffsets
- (void)__SetupPageStringOffsets;
/*"This must be multi thread safe.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSLock * L = [[[NSLock alloc] init] autorelease];
	[L lock];
	if(__PageStringOffsets)
	{
		[L unlock];
		return;
	}
	unsigned int maxPageIndex = [self pageCount];
	if(__PageStringOffsets = calloc(maxPageIndex + 3, sizeof(unsigned int)))
	{
		unsigned int * validPageOff7Ref = __PageStringOffsets + maxPageIndex + 2;
		* validPageOff7Ref = 0;
		* __PageStringOffsets = maxPageIndex;
		[L unlock];
		unsigned int * off7s = __PageStringOffsets + 1;
		unsigned int pageOff7 = 0;
		
		unsigned int pageIndex = 0;
		theStation:
		[L lock];
		* off7s = pageOff7;
		* validPageOff7Ref = pageIndex;
		[L unlock];
		if(pageIndex<maxPageIndex)
		{
			PDFPage * page = [self pageAtIndex:pageIndex];
			unsigned int NOC = [page numberOfCharacters];
			++off7s;
			if(pageOff7 < UINT_MAX - NOC)
				pageOff7 += NOC;
			else
			{
				pageOff7 = UINT_MAX;
			}
			++pageIndex;
			goto theStation;
		}
		// __PageStringOffsets[0] is the total number of pages, in other words pageCount
		// __PageStringOffsets[i+1] is the total number of characters from pages 0 to i-1
		// __PageStringOffsets[pageCount+1] is the total amount of characters in that document.
		// __PageStringOffsets[pageCount+2] is the last page index for which the offset is valid.
		// it is for safety reasons due to multi threading, this whole method can take time
		// because the PDFKit has to parse the whole pdf file before it known the real offsets
		if(iTM2DebugEnabled)
		{
			pageIndex = 0;
			iTM2_LOG(@"<-><-><->  Number of pages(%u) is: %u", pageIndex, __PageStringOffsets[pageIndex]);
			++maxPageIndex;
			while(++pageIndex<maxPageIndex)
			{
				iTM2_LOG(@"<-><-><->  offset at index: %u is %u (= %u is %u)", pageIndex-1, __PageStringOffsets[pageIndex], [self pageIndexForCharacterIndex:__PageStringOffsets[pageIndex]], [self characterOffsetForPageAtIndex:pageIndex - 1]);
			}
			iTM2_LOG(@"<-><-><->  Total number of characters (%u) is: %u", maxPageIndex, __PageStringOffsets[maxPageIndex]);
		}
		return;
	}
	else
	{
		[L unlock];
#warning THIS IS A BAD MANAGEMENT
		iTM2_LOG(@"Memory management problem: no offest caching available...");
		return;
	}
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= pageIndexForCharacterIndex:
- (unsigned int)pageIndexForCharacterIndex:(unsigned int)characterIndex;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self __SetupPageStringOffsets];
	unsigned int pageCount = __PageStringOffsets[0];
	// what is the max valid offset?
	unsigned int maxValidIndex = __PageStringOffsets[pageCount+2];
	unsigned int maxValidCharacterOffset = __PageStringOffsets[maxValidIndex+1];
	if(characterIndex > maxValidCharacterOffset)
	{
		// the pdf file is not yet parsed
		return NSNotFound;
	}
	unsigned int min = 1;
	unsigned int max = min + maxValidIndex;
	while(YES)
	{
		// here we always have __PageStringOffsets[min] <= characterIndex < __PageStringOffsets[max]
		unsigned int mid = (min + max)/2;
		if(min == mid)
		{
//iTM2_LOG(@"%%%%%%%% character index: %i, page index: %i", characterIndex, min);
			// beware of void pages.
			// the only possibility is to have __PageStringOffsets[min] == characterIndex
			// and then __PageStringOffsets[min] == __PageStringOffsets[min - 1]
			if(__PageStringOffsets[min] == characterIndex)
				while(__PageStringOffsets[min - 1] == characterIndex)
					--min;
				// when exiting this loop, we still have __PageStringOffsets[min] == characterIndex
				// but __PageStringOffsets[min-1] != characterIndex
				// as characterIndex < __PageStringOffsets[min-1], we have min>0
//iTM2_END;
			return --min;
		}
		if(characterIndex < __PageStringOffsets[mid])
			max = mid;
		else
			min = mid;
	}
//	return NSNotFound;// never reached
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= characterOffsetForPageAtIndex:
- (unsigned int)characterOffsetForPageAtIndex:(unsigned int)pageIndex;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self __SetupPageStringOffsets];
	unsigned int pageCount = __PageStringOffsets[0];
	// what is the max valid offset?
	unsigned int maxValidIndex = __PageStringOffsets[pageCount+2];
//iTM2_END;
	return pageIndex <= maxValidIndex? __PageStringOffsets[pageIndex+1]: NSNotFound;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= positionOfWord:options:range:
- (iTM2Position)positionOfWord:(NSString *)aWord options:(unsigned)mask range:(NSRange)searchRange;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(![aWord length])
		NSMakeRange(NSNotFound, 0);
	NSRange localSearchRange, result;
	PDFPage * page;
	NSString * pageString;
	unsigned int pageIndex, characterOffset, numberOfCharacters, temp;
	if(mask&NSBackwardsSearch)
		goto backwards;
	pageIndex = [self pageIndexForCharacterIndex:searchRange.location];
	if(pageIndex == NSNotFound)
	{
		iTM2Position position;
		position.range = NSMakeRange(NSMaxRange(searchRange), 0);
		position.pageIndex = 0;
		return position;
	}
	characterOffset = [self characterOffsetForPageAtIndex:pageIndex];
	if(characterOffset == NSNotFound)
	{
		iTM2Position position;
		position.range = NSMakeRange(NSMaxRange(searchRange), 0);
		position.pageIndex = 0;
		return position;
	}
	searchRange.location -= characterOffset;
	// from now on the searchRange is local to the page indexed
nextPage:
	page = [self pageAtIndex:pageIndex];
	pageString = [page string];
	numberOfCharacters = [pageString length];
	if(numberOfCharacters>0)
	{
		localSearchRange = NSIntersectionRange(searchRange, NSMakeRange(0, numberOfCharacters));
nextOccurrence:
		if(localSearchRange.length>0)
		{
			result = [pageString rangeOfString:aWord options:mask range:localSearchRange];
			if(result.length)
			{
				NSRange wordRange = [pageString rangeOfWordAtIndex:result.location];
				if(NSEqualRanges(result, wordRange))
				{
					result.location += characterOffset;// global coordinates
					iTM2Position position;
					position.range = result;
					if(ABS(pageIndex)>1000)
					{
						iTM2_LOG(@"More than 1000 pages, what a document!");
					}
					position.pageIndex = pageIndex;
					return position;
				}
				temp = NSMaxRange(localSearchRange);
				localSearchRange.location = NSMaxRange(result);// search to the right only
				if(localSearchRange.location < temp)
				{
					localSearchRange.length = temp - localSearchRange.location;
					goto nextOccurrence;
				}
			}
			// there is nothing more in that page, we turn to the next one
			// all characters before characterOffset + NSMaxRange(localSearchRange) are already tested
			temp = NSMaxRange(localSearchRange);
			if(temp < NSMaxRange(searchRange))
			{
				searchRange.location = 0;// we will search from the beginning of the next page
				searchRange.length -= localSearchRange.length;
				characterOffset += numberOfCharacters;
				if(++pageIndex < [self pageCount])
					goto nextPage;
			}
		//iTM2_END;
		}
	}
	else if(++pageIndex < [self pageCount])
		goto nextPage;
	iTM2Position position;
	position.range = NSMakeRange(NSMaxRange(searchRange), 0);
	position.pageIndex = 0;
	return position;
backwards:
	pageIndex = [self pageIndexForCharacterIndex:NSMaxRange(searchRange)];
	if(pageIndex == NSNotFound)
	{
		iTM2Position position;
		position.range = NSMakeRange(searchRange.location, 0);
		position.pageIndex = 0;
		return position;
	}
	page = [self pageAtIndex:pageIndex];
	pageString = [page string];
	numberOfCharacters = [pageString length];
	characterOffset = [self characterOffsetForPageAtIndex:pageIndex];
	if(characterOffset == NSNotFound)
	{
		iTM2Position position;
		position.range = NSMakeRange(searchRange.location, 0);
		position.pageIndex = 0;
		return position;
	}
previousPage:
	if(numberOfCharacters)
	{
		localSearchRange = NSIntersectionRange(searchRange, NSMakeRange(characterOffset, numberOfCharacters));
		localSearchRange.location -= characterOffset;
previousOccurrence:
		if(localSearchRange.length)
		{
			result = [pageString rangeOfString:aWord options:mask range:localSearchRange];
			if(result.length)
			{
				NSRange wordRange = [pageString rangeOfWordAtIndex:result.location];
				if(NSEqualRanges(result, wordRange))
				{
					result.location += characterOffset;// global coordinates
					iTM2Position position;
					position.range = result;
					if(ABS(pageIndex)>1000)
					{
						iTM2_LOG(@"More than 1000 pages, what a document!");
					}
					position.pageIndex = pageIndex;
					return position;
				}
				if(localSearchRange.location < result.location)
				{
					localSearchRange.length = result.location - localSearchRange.location;
					goto previousOccurrence;
				}
			}
			// no more occurrence on that page, go to the previous one if relevant
			if(searchRange.location < characterOffset)
			{
				// the remaining range of chars
				searchRange.length = characterOffset - searchRange.location;
				if(pageIndex--)
				{
					page = [self pageAtIndex:pageIndex];
					pageString = [page string];
					numberOfCharacters = [pageString length];
					if(characterOffset >= numberOfCharacters)
					{
						characterOffset -= numberOfCharacters;
						goto previousPage;
					}
					else
					{
						iTM2_LOG(@"****  WARNING: bug in the character offset computation");
					}
				}
			}
		}
	}
	else if(pageIndex--)
	{
		page = [self pageAtIndex:pageIndex];
		pageString = [page string];
		numberOfCharacters = [pageString length];
		if(characterOffset >= numberOfCharacters)
		{
			characterOffset -= numberOfCharacters;
			goto previousPage;
		}
		else
		{
			iTM2_LOG(@"****  WARNING: bug in the character offset computation");
		}
	}
//iTM2_END;
	position.range = NSMakeRange(searchRange.location, 0);
	position.pageIndex = 0;
	return position;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= positionsOfWordBefore:before:here:after:index:
- (NSDictionary *)positionsOfWordBefore:(NSString *)before here:(NSString *)hit after:(NSString *)after index:(unsigned int)hitIndex;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSParameterAssert([before length]);
	NSParameterAssert([hit length]);
	NSParameterAssert([after length]);
	hitIndex = MIN(hitIndex, [hit length] - 1);
	// we are trying to find the best location fitting the sequence of the 3 words, before, hit and after
	[self __SetupPageStringOffsets];
	unsigned int pageCount = __PageStringOffsets[0];
	unsigned int maxValidIndex = __PageStringOffsets[pageCount+2];
	unsigned int characterLimit = __PageStringOffsets[maxValidIndex+1];
//iTM2_END;
	return characterLimit?
		[self positionsOfWordBefore:before here:hit after:after index:hitIndex inRange:NSMakeRange(0, characterLimit)]: nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= positionsOfWordBefore:before:here:after:index:inRange:
- (NSDictionary *)positionsOfWordBefore:(NSString *)before here:(NSString *)hit after:(NSString *)after index:(unsigned int)hitIndex inRange:(NSRange)searchRange;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSParameterAssert([before length]);
	NSParameterAssert([hit length]);
	NSParameterAssert([after length]);
	hitIndex = MIN(hitIndex, [hit length] - 1);
	// we are trying to find the best location fitting the sequence of the 3 words, before, hit and after
	//	unsigned int characterLimit = [self characterOffsetForPageAtIndex:[self pageCount]];
	//	NSRange searchRange = NSMakeRange(0, characterLimit);
	[self __SetupPageStringOffsets];
	unsigned int pageCount = __PageStringOffsets[0];
	unsigned int maxValidIndex = __PageStringOffsets[pageCount+2];
	unsigned int characterLimit = __PageStringOffsets[maxValidIndex+1];
	searchRange = NSIntersectionRange(searchRange, NSMakeRange(0, characterLimit));
	if(!searchRange.length)
	{
		return nil;
	}
	iTM2Position beforePosition = [self positionOfWord:before options:0L range:searchRange];
	if(beforePosition.range.length)
	{
		searchRange.location = NSMaxRange(beforePosition.range);
		searchRange.length = characterLimit - searchRange.location;
		iTM2Position hitPosition = [self positionOfWord:hit options:0L range:searchRange];
		if(hitPosition.range.length)
		{
			searchRange.location = NSMaxRange(hitPosition.range);
			searchRange.length = characterLimit - searchRange.location;
			iTM2Position afterPosition = [self positionOfWord:after options:0L range:searchRange];
			if(afterPosition.range.length)
			{
				// in the document all 3 words are available
				int weightCorrection = [before length] + [hit length] + 2;
				int weight;
				NSNumber * key;
				// the purpose is to gather the positions according to their weight
				// the min weight is meant to be used
				// the weight is the length of the min match (the RE) before.*hit.*after
				// The weight is used as key, the value is a mutable array of positions with the same weight
				NSMutableDictionary * positions = [NSMutableDictionary dictionary];
				NSMutableArray * currentDestinations;
			nextOccurrence:
				// the best hit preceding after
				searchRange.location = NSMaxRange(hitPosition.range);
				if(searchRange.location < afterPosition.range.location)
				{
					searchRange.length = afterPosition.range.location - searchRange.location;
					iTM2Position position = [self positionOfWord:hit options:NSBackwardsSearch range:searchRange];
					if(position.range.length)
						hitPosition = position;
				}
				// the best before preceding otherHere, but after before, you understand?
				searchRange.location = NSMaxRange(beforePosition.range);
				if(searchRange.location < hitPosition.range.location)
				{
					searchRange.length = hitPosition.range.location - searchRange.location;
					iTM2Position position = [self positionOfWord:before options:NSBackwardsSearch range:searchRange];
					if(position.range.length)
						beforePosition = position;
				}
				weight = afterPosition.range.location - beforePosition.range.location;
				if(weight>weightCorrection)
					weight = (weight - weightCorrection)/3;
				else
					weight = 0;
				key = [NSNumber numberWithInt:weight];
				currentDestinations = [positions objectForKey:key];
				if(!currentDestinations)
				{
					// rien du tout
					currentDestinations = [NSMutableArray array];
					[positions setObject:currentDestinations forKey:key];
				}
				PDFPage * page = [self pageAtIndex:hitPosition.pageIndex];
				unsigned localHereIndex = hitPosition.range.location + hitIndex - [self characterOffsetForPageAtIndex:hitPosition.pageIndex];
				NSPoint point = [page characterBoundsAtIndex:localHereIndex].origin;
				[currentDestinations addObject:
					[[[PDFDestination allocWithZone:[self zone]] initWithPage:page atPoint:point] autorelease]];
//iTM2_LOG(@"#### position: %@ with weight %i", NSStringFromRange(hitPosition.range), weight);
				// We look for all the occurrences of hit between before and hit, the latter excluded.
				searchRange.location = NSMaxRange(beforePosition.range);
			previousHere:
				if(searchRange.location<hitPosition.range.location)
				{
					searchRange.length = hitPosition.range.location - searchRange.location;
					hitPosition = [self positionOfWord:hit options:NSBackwardsSearch range:searchRange];
					if(hitPosition.range.length)
					{
						page = [self pageAtIndex:hitPosition.pageIndex];
						localHereIndex = hitPosition.range.location + hitIndex
							- [self characterOffsetForPageAtIndex:hitPosition.pageIndex];
						point = [page characterBoundsAtIndex:localHereIndex].origin;
						[currentDestinations addObject:
							[[[PDFDestination allocWithZone:[self zone]]
								initWithPage: page atPoint: point] autorelease]];
						goto previousHere;
						
					}
				}
				// no more hit
				// we prepare for the next occurrence:
				searchRange.location = NSMaxRange(afterPosition.range);
				searchRange.length = characterLimit - searchRange.location;
				beforePosition = [self positionOfWord:before options:0L range:searchRange];
				if(beforePosition.range.length)
				{
					searchRange.location = NSMaxRange(beforePosition.range);
					searchRange.length = characterLimit - searchRange.location;
					hitPosition = [self positionOfWord:hit options:0L range:searchRange];
					if(hitPosition.range.length)
					{
						searchRange.location = NSMaxRange(hitPosition.range);
						searchRange.length = characterLimit - searchRange.location;
						afterPosition = [self positionOfWord:after options:0L range:searchRange];
						if(afterPosition.range.length)
							goto nextOccurrence;
					}
				}
				return positions;
			}
			else
			{
				// we do not have in the pdf document the word following the hit word
				// [self _synchronizeWithDestinations:positions before:before here:hit index:hitIndex];
				return nil;
			}
		}
		else
		{
			// no hit within the 100 characters following 
		}
	}
	else//if(!beforeSelection)
	{
		// [self _synchronizeWithDestinations:positions here:hit after:after index:hitIndex];
		return nil;
	}
//iTM2_END;
	return nil;
}
@end

@interface iTM2PDFKitView(SyncHRONIZE)
- (BOOL)_synchronizeWithDestinations:(NSDictionary *)destinations;
- (BOOL)_synchronizeWithDestinations:(NSDictionary *)destinations here:(NSString *)hit index:(unsigned int)hitIndex;
- (BOOL)_synchronizeWithDestinations:(NSDictionary *)destinations before:(NSString *)before here:(NSString *)hit index:(unsigned int)hitIndex;
- (BOOL)_synchronizeWithDestinations:(NSDictionary *)destinations here:(NSString *)hit after:(NSString *)after index:(unsigned int)hitIndex;
- (BOOL)_synchronizeWithDestinations:(NSDictionary *)destinations before:(NSString *)before here:(NSString *)hit after:(NSString *)after index:(unsigned int)hitIndex;
- (void)scrollSynchronizationPointToVisible:(id)sender;
- (BOOL)__synchronizeWithStoredDestinationsAndHints:(id)irrelevant;
@end

@implementation iTM2PDFKitView(SyncHRONIZE)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= _synchronizeWithDestinations:
- (BOOL)_synchronizeWithDestinations:(NSDictionary *)destinations;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSParameterAssert(destinations);
#if 0
	NSMutableSet * pageSet = [NSMutableSet set];
	PDFDocument * document = [self document];
	NSEnumerator * E = [destinations keyEnumerator];
	NSNumber * N;
	while(N = [E nextObject])
	{
		unsigned int pageIndex = [N unsignedIntValue];
		if(pageIndex < [document pageCount])
		{
			PDFPage * page = [document pageAtIndex:pageIndex];
			NSEnumerator * e = [[destinations objectForKey:N] objectEnumerator];
			NSValue * pointValue;
			nextPointValue:
			if(pointValue = [e nextObject])
			{
				NSPoint point = [pointValue pointValue];
				NSPoint checkPoint = point;
				#define OFFSET 4
				checkPoint.x += OFFSET;
				checkPoint.y += OFFSET;
				if([page characterIndexAtPoint:checkPoint] == -1)
				{
					checkPoint.x -= 2 * OFFSET;
					if([page characterIndexAtPoint:checkPoint] == -1)
					{
						checkPoint.y -= 2 * OFFSET;
						if([page characterIndexAtPoint:checkPoint] == -1)
						{
							checkPoint.x += 2 * OFFSET;
							if([page characterIndexAtPoint:checkPoint] == -1)
							{
								// this Sync point does not seem to correspond to a character
//iTM2_LOG(@"Sync POINT IS IGNORED");
								goto nextPointValue;
							}
						}
					}
				}
				[_SyncDestinations addObject:[[[PDFDestination allocWithZone:[self zone]]
					initWithPage: page atPoint: point] autorelease]];
				[pageSet addObject:page];
				goto nextPointValue;
			}
		}
	}
#if 0
	if([pageSet count] != 1)
	{
		// I need to scroll
		return;
	}
#endif
#endif
//iTM2_END;
	return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= _synchronizeWithDestinations:here:index:
- (BOOL)_synchronizeWithDestinations:(NSDictionary *)destinations here:(NSString *)hit index:(unsigned int)hitIndex;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSParameterAssert(hit);
//iTM2_LOG(@"COUCOUCOUCOUCOUCOUCOUCOUCOUCOU destinations: %@", destinations);
//iTM2_END;
	return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= _synchronizeWithDestinations:before:here:index:
- (BOOL)_synchronizeWithDestinations:(NSDictionary *)destinations before:(NSString *)before here:(NSString *)hit index:(unsigned int)hitIndex;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSParameterAssert(before);
	NSParameterAssert(hit);
//iTM2_LOG(@"COUCOUCOUCOUCOUCOUCOUCOUCOUCOU destinations: %@", destinations);
//iTM2_END;
	return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= _synchronizeWithDestinations:here:after:index:
- (BOOL)_synchronizeWithDestinations:(NSDictionary *)destinations here:(NSString *)hit after:(NSString *)after index:(unsigned int)hitIndex;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSParameterAssert(hit);
	NSParameterAssert(after);
//iTM2_LOG(@"COUCOUCOUCOUCOUCOUCOUCOUCOUCOU destinations: %@", destinations);
//iTM2_END;
	return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= _synchronizeWithDestinations:before:here:after:index:
- (BOOL)_synchronizeWithDestinations:(NSDictionary *)destinations before:(NSString *)before here:(NSString *)hit after:(NSString *)after index:(unsigned int)hitIndex;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSParameterAssert([before length]);
	NSParameterAssert([hit length]);
	NSParameterAssert([after length]);
	hitIndex = MIN(hitIndex, [hit length] - 1);
	// if destinations are available, we should use them!!!
	NSDictionary * hereRecords = [destinations objectForKey:@"here"];
	NSDictionary * beforeRecords = [destinations objectForKey:@"before"];
	NSDictionary * afterRecords = [destinations objectForKey:@"after"];
//iTM2_LOG(@"????    $$$$  hereRecords are: %@", hereRecords);
//iTM2_LOG(@"????    $$$$  beforeRecords are: %@", beforeRecords);
//iTM2_LOG(@"????    $$$$  afterRecords are: %@", afterRecords);
	NSDictionary * positions = nil;
	iTM2XtdPDFDocument * document = (iTM2XtdPDFDocument *)[self document];
	if([hereRecords count])
	{
		NSEnumerator * E = [hereRecords keyEnumerator];
		NSNumber * N = [E nextObject];
		unsigned int min = [N unsignedIntValue];
		unsigned int max = min;
		while(N = [E nextObject])
		{
			unsigned int pageNumber = [N unsignedIntValue];
			if(pageNumber<min)
				min = pageNumber;
			else if(pageNumber>max)
				max = pageNumber;
		}
		if(min < [document pageCount])
		{
			if(min)
			{
				min = [document characterOffsetForPageAtIndex:min-1];
				if(min == NSNotFound)
				{
					defaultPositions:
					positions = [document
						positionsOfWordBefore: before here: hit after: after index: hitIndex];
				}
				else
				{
					setUpMax:
					max = (max < [document pageCount] - 1)?
						[document characterOffsetForPageAtIndex:max+1]
						: [document characterOffsetForPageAtIndex:[document pageCount]];
					if(max == NSNotFound)
					{
						goto defaultPositions;
					}
					else
					{
						positions = [document
							positionsOfWordBefore: before here: hit after: after index: hitIndex
								inRange: NSMakeRange(min, max - min)];
					}
				}
			}
			else
			{
				min = 0;
				goto setUpMax;
			}
		}
		else
		{
			positions = [document
				positionsOfWordBefore: before here: hit after: after index: hitIndex];
		}
	}
	else if([beforeRecords count])
	{
		NSEnumerator * E = [beforeRecords keyEnumerator];
		NSNumber * N = nil;
		NSNumber * minN = nil;
		unsigned int min = 0;
		while(N = [E nextObject])
		{
			unsigned int pageNumber = [N unsignedIntValue];
			if(pageNumber>min)
			{
				min = pageNumber;
				minN = N;
			}
		}
		if(min < [document pageCount])
		{
			unsigned int max = min;
			if([afterRecords count])
			{
				E = [afterRecords keyEnumerator];
				while(N = [E nextObject])
				{
					unsigned int pageNumber = [N unsignedIntValue];
					if(pageNumber<max)
						max = pageNumber;
				}
				if(max<min)
					max = min;
			}
			unsigned int lastOff7 = [document characterOffsetForPageAtIndex:[document pageCount]];
			unsigned int maxOff7 = [document characterOffsetForPageAtIndex:min+1];
			unsigned int minOff7 = [document characterOffsetForPageAtIndex:min];
			if(minOff7 == NSNotFound)
				return NO;
			PDFPage * page = [[self document] pageAtIndex:min];
			if(maxOff7 == NSNotFound)
				maxOff7 = minOff7 + [page numberOfCharacters];
			if(lastOff7 == NSNotFound)
				lastOff7 = maxOff7;
			NSArray * points = minN? [beforeRecords objectForKey:minN]: nil;
			if([points count] > 0)
			{
				NSPoint point = [[points objectAtIndex:0] pointValue];
				int charIndex = [page characterIndexNearPoint:point];
				if(charIndex >= 0)
					minOff7 += charIndex;
	//iTM2_LOG(@"????    $$$$????    $$$$????    $$$$????    $$$$  charIndex is: %i", charIndex);
				unsigned int correction = [before length] + [hit length] + [after length] + 2;
				if(minOff7>correction)
					minOff7 -= correction;
				else
					minOff7 = 0;
				if(correction < lastOff7 - maxOff7)
					maxOff7 += correction;
				else
					maxOff7 = lastOff7;
			}
			unsigned int savedMaxOff7 = maxOff7;
			positions = [document
				positionsOfWordBefore: before here: hit after: after index: hitIndex
					inRange: NSMakeRange(minOff7, maxOff7 - minOff7)];
			if([positions count])
			{
				if(maxOff7 < lastOff7)
				{
					maxOff7 = lastOff7;
					positions = [document
						positionsOfWordBefore: before here: hit after: after index: hitIndex
							inRange: NSMakeRange(minOff7, maxOff7 - minOff7)];
					if(![positions count])
					{
						maxOff7 = savedMaxOff7;
quelquepart:
						if(minOff7)
						{
							minOff7 = [document characterOffsetForPageAtIndex:min-1];
							positions = [document
								positionsOfWordBefore: before here: hit after: after index: hitIndex
									inRange: NSMakeRange(minOff7, maxOff7 - minOff7)];
						}
					}
				}
				else
					goto quelquepart;
			}
//iTM2_LOG(@"ssearch range: %u, %u", min, max);
		}
		else
		{
			positions = [document
				positionsOfWordBefore: before here: hit after: after index: hitIndex];
		}
	}
	else
	{
		positions = [document
			positionsOfWordBefore: before here: hit after: after index: hitIndex];
	}
	// we are trying to find the best location fitting the sequence of the 3 words, before, hit and after
	if(positions)
	{
		NSString * key = [[[positions allKeys] sortedArrayUsingSelector:@selector(compare:)] objectAtIndex:0];
		[_SyncDestinations autorelease];
		_SyncDestinations = [[positions objectForKey:key] retain];
//iTM2_LOG(@"****  _SyncDestinations are now: %@", _SyncDestinations);
		// then what shall we do?
		// let us try first to use the given destinations
		// the destinations are 3 dictionaries of page numbers/point arrays pairs.
		if([hereRecords count])
		{
//iTM2_LOG(@"$$$$  [hereRecords count] is: %i", [hereRecords count]);
			// I found a record for a line...
			// first I remove all the points that do not point to a character
			// I convert the information to allow comparison between here records and sync destinations
			// The best thing is to consider character indexes in the whole string of the document.
			// Due to the fact that a page break can occur in the middle of a phrase,
			// we cannot rely on choosing common page numbers for records and destinations.
			// BTW, it might be something interesting in the major part of the real situations.
			// So we convert to 2 dictionaries where keys are global character indexes
			// and objects wrapp the original information.
			// The here records do not really contain more information that the point to be displayed.
			// The only thing we know is that there is a sync anchor on the same line where the mouseDown: occurred.
			// TeX can mess things up such that the anchor point can be completely fool...
			NSMutableArray * globalIndexes = [NSMutableArray array];
			NSEnumerator * E = [hereRecords keyEnumerator];
			NSNumber * N;
			while(N = [E nextObject])
			{
				unsigned int pageIndex = [N unsignedIntValue];
				PDFDocument * doc = [self document];
				if(pageIndex < [doc pageCount])
				{
					PDFPage * page = [doc pageAtIndex:pageIndex];
					NSEnumerator * EE = [[hereRecords objectForKey:N] objectEnumerator];
					NSValue *  V;
					while(V = [EE nextObject])
					{
						int localIndex = [page characterIndexNearPoint:[V pointValue]];
						if(localIndex>=0)
							[globalIndexes addObject:
								[NSNumber numberWithInt:[page localToGlobalCharacterIndex:localIndex]]];
					}
				}
				else
				{
					iTM2_LOG(@"***  Something WEIRD DID HAPPEN: page number %u was expected to not exceed %u", pageIndex, [doc pageCount]);
				}
			}
			// globalIndexes is an array of numbers wrapping global character indexes.
			// then we try to find the sync destination neerest to the record index
			unsigned int minWeight = UINT_MAX;
			NSMutableArray * syncDestinations = [NSMutableArray array];
			E = [globalIndexes objectEnumerator];
			while(N = [E nextObject])
			{
				int globalIndex = [N intValue];
				NSEnumerator * EE = [_SyncDestinations objectEnumerator];
				PDFDestination * destination;
				while(destination = [EE nextObject])
				{
					PDFPage * page = [destination page];
					int globalIdx = [page localToGlobalCharacterIndex:
						[page characterIndexNearPoint:[destination point]]];
					unsigned weight = globalIdx < globalIndex?
						globalIndex - globalIdx: globalIdx - globalIndex;
					weight /= 3;// because some \n characters are sometimes added.
					if(weight<minWeight)
					{
						syncDestinations = [NSMutableArray arrayWithObject:destination];
						minWeight = weight;
					}
					else if (weight==minWeight)
					{
						[syncDestinations addObject:destination];
					}
				}//while
			}
			if([syncDestinations count])
			{
				[_SyncDestinations autorelease];
				_SyncDestinations = [syncDestinations retain];
			}
#if 0
			NSMutableDictionary * commonHereRecords = [NSMutableDictionary dictionary];
			// the keys of the dictionary are page indexes both for hereRecords and _SyncDestinations
			NSEnumerator * E = [[[NSMutableSet setWithArray:[hereRecords allKeys]]
				intersectSet: [NSSet setWithArray:[_SyncDestinations allKeys]]] objectEnumerator];
			NSMutableDictionary * commonSyncDestinations = [NSMutableDictionary dictionary];
			NSMutableDictionary * commonHereRecords = [NSMutableDictionary dictionary];
			NSNumber * N;
			while(N = [E nextObject])
			{
				[commonSyncDestinations setObject:[_SyncDestinations objectForKey:N] forKey:N];
				[commonHereRecords setObject:[hereRecords objectForKey:N] forKey:N];
			}
#endif
		}
		else
		{
			// we try to choose the destinations for which there exist something before and after...
			NSMutableArray * globalBeforeIndexes = [NSMutableArray array];
			// globalBeforeIndexes is an array of numbers wrapping global character indexes.
			if([beforeRecords count])
			{
				NSEnumerator * E = [beforeRecords keyEnumerator];
				NSNumber * N;
				unsigned int pageCount = [[self document] pageCount];
				while(N = [E nextObject])
				{
					
					unsigned int pageIndex = [N unsignedIntValue];
					if(pageIndex < pageCount)
					{
						PDFPage * page = [[self document] pageAtIndex:pageIndex];
						NSEnumerator * EE = [[beforeRecords objectForKey:N] objectEnumerator];
						NSValue *  V;
						while(V = [EE nextObject])
						{
							int localIndex = [page characterIndexNearPoint:[V pointValue]];
							if(localIndex>=0)
								[globalBeforeIndexes addObject:
									[NSNumber numberWithInt:[page localToGlobalCharacterIndex:localIndex]]];
						}
					}
				}
			}
			NSMutableArray * globalAfterIndexes = [NSMutableArray array];
			if([afterRecords count])
			{
				NSEnumerator * E = [afterRecords keyEnumerator];
				NSNumber * N;
				unsigned int pageCount = [[self document] pageCount];
				while(N = [E nextObject])
				{
					unsigned int pageIndex = [N unsignedIntValue];
					if(pageIndex < pageCount)
					{
						PDFPage * page = [[self document] pageAtIndex:pageIndex];
						NSEnumerator * EE = [[afterRecords objectForKey:N] objectEnumerator];
						NSValue *  V;
						while(V = [EE nextObject])
						{
							int localIndex = [page characterIndexNearPoint:[V pointValue]];
							if(localIndex>=0)
								[globalAfterIndexes addObject:
									[NSNumber numberWithInt:[page localToGlobalCharacterIndex:localIndex]]];
						}
					}
				}
				// now beforeRecords or afterRecords are useless
			}
//iTM2_LOG(@"$$$$  globalBeforeIndexes is: %@", globalBeforeIndexes);
//iTM2_LOG(@"$$$$  globalAfterIndexes is: %@", globalAfterIndexes);
			NSMutableArray * oldSyncDestinations = [NSMutableArray arrayWithArray:_SyncDestinations];
			NSMutableArray * newSyncDestinations = [NSMutableArray array];
			NSEnumerator * beforeE = [globalBeforeIndexes objectEnumerator];
			unsigned int beforeIndex = [[beforeE nextObject] unsignedIntValue];
			NSEnumerator * afterE = [globalAfterIndexes objectEnumerator];
			NSNumber * afterNumber;
			unsigned int afterIndex;
			nextAfterIndexLabel:
			afterNumber = [afterE nextObject];
			afterIndex = afterNumber? [afterNumber unsignedIntValue]: UINT_MAX;
			if(beforeIndex < afterIndex)
			{
				// now we augment beforeIndex
				unsigned int nextBeforeIndex = UINT_MAX;
				NSNumber * beforeNumber;
				while(beforeNumber = [beforeE nextObject])
				{
					nextBeforeIndex = [beforeNumber unsignedIntValue];
					if(nextBeforeIndex < afterIndex)
						beforeIndex = nextBeforeIndex;
					else
						break;
				}
				// OK we found a good intervalle
				// then we try to find all the destinations that fit in that intervalle
				NSRange R = NSMakeRange(beforeIndex, afterIndex - beforeIndex);
				NSEnumerator * e = [oldSyncDestinations objectEnumerator];
				PDFDestination * destination;
				while(destination = [e nextObject])
				{
					PDFPage * page = [destination page];
					int globalIdx = [page localToGlobalCharacterIndex:
						[page characterIndexNearPoint:[destination point]]];
					if(globalIdx<0)
					{
						[oldSyncDestinations removeObject:destination];
					}
					else if(NSLocationInRange(globalIdx, R))
					{
						[oldSyncDestinations removeObject:destination];
						[newSyncDestinations addObject:destination];
					}
				}
				// next loop:
				if(beforeNumber)
				{
					beforeIndex = nextBeforeIndex;
					goto nextAfterIndexLabel;
				}
			}
			else
				goto nextAfterIndexLabel;
			if([newSyncDestinations count])
			{
				[_SyncDestinations autorelease];
				PDFDestination * hitDestination = [_SyncDestinations objectAtIndex:0];
				_SyncDestinations = [[NSArray arrayWithObject:hitDestination] retain];
				//[self scrollDestinationToVisible:hitDestination];// no go to, it does not work well...
				[self scrollSynchronizationPointToVisible:self];// no go to, it does not work well...
				return YES;
			}
		}
	}
//iTM2_END;
	return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= __threadedSynchronizeWithStoredDestinationsAndHints:
- (void)__threadedSynchronizeWithStoredDestinationsAndHints:(id)irrelevant;
/*"Description Forthcoming. NOT THREADED (problems)
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
	iTM2_INIT_POOL;
//iTM2_START;
	[self __synchronizeWithStoredDestinationsAndHints: (id) irrelevant];
//iTM2_END;
	iTM2_RELEASE_POOL;
	[NSThread exit];
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= __synchronizeWithStoredDestinationsAndHints:
- (BOOL)__synchronizeWithStoredDestinationsAndHints:(id)irrelevant;
/*"Description Forthcoming. NOT THREADED (problems)
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
	BOOL result = NO;
startAgain:;
	iTM2_INIT_POOL;
//iTM2_START;
	NSLock * L = [[NSLock allocWithZone:[self zone]] init];
	[L lock];
	NSMutableArray * syncStack = [[self implementation] metaValueForKey:@"_SynchronizationStack"];
	if([syncStack count]>1)
	{
		NSDictionary * hint = [[[syncStack lastObject] nonretainedObjectValue] autorelease];
		[syncStack removeLastObject];
		NSDictionary * destinations = [[[syncStack lastObject] nonretainedObjectValue] autorelease];
		[syncStack removeLastObject];
		while([syncStack count])
		{
			[[[syncStack lastObject] nonretainedObjectValue] autorelease];
			[syncStack removeLastObject];
		}
		[L unlock];
		[L release];
		L = nil;
		NSString * S = [hint objectForKey:@"container"];
		if(S)
		{
			// okay guyes, let's go to the party.
			// we just use the hint to find words before and after the hint and switch to the appropriate _synchronize... method
			unsigned int hereIndex = [[hint objectForKey:@"character index"] unsignedIntValue];// The mousedown occurred here.
			if(hereIndex < [S length])
			{
				NSString * beforeWord;
				NSString * hereWord;
				NSString * afterWord;
				unsigned int localHitIndex = [S getWordBefore: &beforeWord here: &hereWord after: &afterWord atIndex:hereIndex];
//iTM2_LOG(@"####  hit sequence: %@ + %@ + %@, (index: %i)", beforeWord, hereWord, afterWord, hereIndex);
				// branching code
				if([beforeWord length])
				{
					if([hereWord length])
					{
						if([afterWord length])
						{
							result = [self _synchronizeWithDestinations:destinations before:beforeWord here:hereWord after:afterWord index:localHitIndex];
						}
						else
						{
							result = [self _synchronizeWithDestinations:destinations before:beforeWord here:hereWord index:localHitIndex];
						}
					}
#if 0
					else
					{
						result = [self _synchronizeWithDestinations:destinations];
					}
#endif
				}
				else if([hereWord length])
				{
					if([afterWord length])
					{
						result = [self _synchronizeWithDestinations:destinations here:hereWord after:afterWord index:localHitIndex];
					}
					else
					{
						result = [self _synchronizeWithDestinations:destinations here:hereWord index:localHitIndex];
					}
				}
				else if(destinations)
				{
					result = [self _synchronizeWithDestinations:destinations];
				}
			}
			else if(destinations)
			{
				// the hint seems inconsistent, this is the standard synchronization process...
				result = [self _synchronizeWithDestinations:destinations];
			}
		}
		else if(destinations)
		{
			// no hint given, this is the standard stuff
			result = [self _synchronizeWithDestinations:destinations];
		}
		if(result)
		{
			[self setNeedsDisplay:YES];
		}
		iTM2_RELEASE_POOL;
		goto startAgain;
	}
theEnd:
	[syncStack setArray:[NSArray array]];
	[L unlock];
	[L release];
	L = nil;
//iTM2_END;
	iTM2_RELEASE_POOL;
	return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= synchronizeWithDestinations:hint:
- (BOOL)synchronizeWithDestinations:(NSDictionary *)destinations hint:(NSDictionary *)hint;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSLock * L = [[[NSLock allocWithZone:[self zone]] init] autorelease];
	[L lock];
	NSMutableArray * syncStack = [[self implementation] metaValueForKey:@"_SynchronizationStack"];
	if(![syncStack isKindOfClass:[NSMutableArray class]])
	{
		syncStack = [NSMutableArray array];
		[[self implementation] takeMetaValue:syncStack forKey:@"_SynchronizationStack"];
	}
	[destinations retain];
	[syncStack addObject:[NSValue valueWithNonretainedObject:destinations]];
	[hint retain];
	[syncStack addObject:[NSValue valueWithNonretainedObject:hint]];
	[L unlock];
	#if 0
	[NSThread detachNewThreadSelector: @selector(__threadedSynchronizeWithStoredDestinationsAndHints:)
		toTarget: self withObject: nil];
	return YES;
	#else
	return [self __synchronizeWithStoredDestinationsAndHints:nil];
	#endif
//iTM2_END;
	return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= takeCurrentPhysicalPage:synchronizationPoint:withHint:
- (BOOL)takeCurrentPhysicalPage:(int)aCurrentPhysicalPage synchronizationPoint:(NSPoint)point withHint:(NSDictionary *)hint;
/*"O based.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[_SyncDestination autorelease];
	_SyncDestination = nil;
	[_SyncDestinations autorelease];
	_SyncDestinations = nil;
	[_SyncPointValues autorelease];
	_SyncPointValues = nil;
	if(aCurrentPhysicalPage<0)
		return NO;// no hint for the page, I do not synchronize yet
	PDFDocument * document = [self document];
	if(aCurrentPhysicalPage < [document pageCount])
	{
		PDFPage * page = [document pageAtIndex:aCurrentPhysicalPage];
		if(NSPointInRect(point, [page boundsForBox:kPDFDisplayBoxMediaBox]))
		{
			_SyncDestination = [[PDFDestination allocWithZone:[self zone]] initWithPage:page atPoint:point];
			[self setNeedsDisplay:YES];
			if(hint)
			{
				// okay guyes, ket's go to the party.
				unsigned int charIndex = [[hint objectForKey:@"character index"] unsignedIntValue];
				NSString * S = [hint objectForKey:@"container"];
				if(charIndex < [S length])
				{
					NSRange wordRange = [S doubleClickAtIndex:charIndex];
					if(wordRange.length)
					{
						NSString * word = [S substringWithRange:wordRange];
						NSRange previousWordRange = NSMakeRange(0, 0);
						int clickIndex = wordRange.location;
						if(clickIndex>2)
						{
							clickIndex -= 2;
							previousWordRange = [S doubleClickAtIndex:clickIndex];
							if(!previousWordRange.length && clickIndex)
							{
								previousWordRange = [S doubleClickAtIndex: --clickIndex];
								if(!previousWordRange.length && clickIndex)
								{
									previousWordRange = [S doubleClickAtIndex: --clickIndex];
								}
							}
						}
						NSString * previousWord = [S substringWithRange:previousWordRange];
//iTM2_LOG(@"previous word: %@", previousWord);
						NSRange nextWordRange = NSMakeRange(0, 0);
						clickIndex = NSMaxRange(wordRange);
						if(clickIndex < [S length] - 2)
						{
							clickIndex += 2;
							nextWordRange = [S doubleClickAtIndex:clickIndex];
							if(!nextWordRange.length && clickIndex)
							{
								nextWordRange = [S doubleClickAtIndex: ++clickIndex];
								if(!nextWordRange.length && clickIndex)
								{
									nextWordRange = [S doubleClickAtIndex: ++clickIndex];
								}
							}
						}
						NSString * targetString = [page string];
//iTM2_LOG(@"targetString: %@", targetString);
						NSRange R = NSMakeRange(0, [targetString length]);
						NSMutableArray * pointValues   = [NSMutableArray array];// matching word
						NSMutableArray * pointValues10 = [NSMutableArray array];// matching previous word too
						more:
						R = [targetString rangeOfString:word options:0L range:R];
						if(R.length)
						{
//iTM2_LOG(@"a string was found: %@ range: %@", [targetString substringWithRange:R], NSStringFromRange(R));
							if(NSEqualRanges([targetString doubleClickAtIndex:R.location], R))
							{
								NSRect characterBounds = [page characterBoundsAtIndex:R.location + MIN(1 + charIndex - wordRange.location, [targetString length]) - 1];
								NSValue * pointValue = [NSValue valueWithPoint:characterBounds.origin];
								[pointValues addObject:pointValue];
								// is the previous word available?
								int clickIndex = R.location;
								NSString * previousW = (clickIndex>2)?
									[targetString substringWithRange:[targetString doubleClickAtIndex:clickIndex-2]]: @"";
								if([previousW isEqualToString:previousWord])
								{
									[pointValues10 addObject:pointValue];
								}
								else if(iTM2DebugEnabled)
								{
									iTM2_LOG(@"previous word match: %@", previousW);
								}
							}
							else if(iTM2DebugEnabled)
							{
								iTM2_LOG(@"No word match: %@", [targetString substringWithRange:[targetString doubleClickAtIndex:R.location]]);
							}
							R.location += R.length;
							R.length = [targetString length] - R.location;
							if(R.length)
								goto more;
							else
							{
								iTM2_LOG(@"End of the string reached");
							}
						}
						if([pointValues10 count])
						{
							_SyncPointValues = [pointValues10 copy];
						}
						else if([pointValues count])
						{
							_SyncPointValues = [pointValues copy];
						}
					}
				}
			}
		}
		else if(hint)
		{
			// okay guyes, ket's go to the party.
			unsigned int charIndex = [[hint objectForKey:@"character index"] unsignedIntValue];
			NSString * S = [hint objectForKey:@"container"];
			if(charIndex < [S length])
			{
				NSRange wordRange = [S doubleClickAtIndex:charIndex];
				if(wordRange.length)
				{
					NSString * word = [S substringWithRange:wordRange];
					NSString * targetString = [page string];
					NSRange R = NSMakeRange(0, [targetString length]);
					NSMutableArray * rangeValues = [NSMutableArray array];
					stillMore:
						R = [targetString rangeOfString:word options:0L range:R];
					if(R.length)
					{
						[rangeValues addObject:[NSValue valueWithRange:R]];
						R.length = [targetString length] - R.location;
						goto stillMore;
					}
				}
			}
		}
	}
	return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  scrollSynchronizationPointToVisible:
- (void)scrollSynchronizationPointToVisible:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([_SyncDestinations count])
	{
		PDFDestination * hitDestination = [_SyncDestinations objectAtIndex:0];
		[self scrollDestinationToVisible:hitDestination];// no go to, it does not work well...
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  mouseDown:
- (void)mouseDown:(NSEvent *)theEvent;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: Thu Jul 17 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(([theEvent clickCount] > 0) && ([theEvent modifierFlags] & NSCommandKeyMask))
    {
		// wait for a second click?
#if 0
		if(theEvent = [[self window] nextEventMatchingMask:NSLeftMouseDownMask untilDate:[NSDate dateWithTimeIntervalSinceNow:100] inMode:NSEventTrackingRunLoopMode dequeue:YES])
		{
		@"com.apple.mouse.doubleClickThreshold";
		}
#endif
		[self pdfSynchronizeMouseDown:theEvent];
//iTM2_END;
		return;
	}
//iTM2_LOG(@"[theEvent clickCount] is: %i", [theEvent clickCount]);
    [super mouseDown:theEvent];
//iTM2_END;
    return;
}
@end

@implementation PDFView(iTM2SynchronizationKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  pdfSynchronizeMouseDown:
- (void)pdfSynchronizeMouseDown:(NSEvent *)theEvent;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: Thu Jul 17 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSPoint point = [self convertPoint:[theEvent locationInWindow] fromView:nil];
	PDFPage * page = [self pageForPoint:point nearest:NO];
	if(page)
	{
		point = [self convertPoint:point toPage:page];
		int charIndex = [page characterIndexAtPoint:point];
		if(charIndex >= 0)
		{
			// there is a bug in
//				PDFSelection * SELECTION = [page selectionForRange:NSMakeRange(charIndex, 1)];
//iTM2_LOG(@"................ character: %@, point: %@, bounds: %@", [[page string] substringWithRange:NSMakeRange(charIndex, 1)], NSStringFromPoint(point), (SELECTION? NSStringFromRect([SELECTION boundsForPage:page]): @"No rect"));
			unsigned int pageIndex = [[page document] indexForPage:page];
			NSMutableDictionary * hint = [NSMutableDictionary dictionaryWithObjectsAndKeys:
				[NSNumber numberWithInt:charIndex], @"character index",
				[page string], @"container",
					nil];
			PDFSelection * selection;
			if(selection = [page selectionForWordAtPoint:point])
				[hint setObject:[NSValue valueWithRect:[selection boundsForPage:page]] forKey:@"word bounds"];
			if(selection = [page selectionForLineAtPoint:point])
			{
				NSRect lineBounds = [selection boundsForPage:page];
				NSPoint P = point;
				P.y += lineBounds.size.height * 1.1;
				if(selection = [page selectionForLineAtPoint:point])
				{
					NSRect bounds = [selection boundsForPage:page];
					bounds.origin.y = lineBounds.origin.y;
					bounds.size.height = lineBounds.size.height;
					lineBounds = NSUnionRect(bounds, lineBounds);
				}
				P.y = point.y - lineBounds.size.height * 1.1;
				if(selection = [page selectionForLineAtPoint:point])
				{
					NSRect bounds = [selection boundsForPage:page];
					bounds.origin.y = lineBounds.origin.y;
					bounds.size.height = lineBounds.size.height;
					lineBounds = NSUnionRect(bounds, lineBounds);
				}
				[hint setObject:[NSValue valueWithRect:lineBounds] forKey:@"line bounds"];
			}
			[[[[self window] windowController] document]
				synchronizeWithLocation: point inPageAtIndex: pageIndex withHint: hint orderFront:([theEvent clickCount] > 1)];
		}
	}
//iTM2_LOG(@"[theEvent clickCount] is: %i", [theEvent clickCount]);
//iTM2_END;
	return;
}
@end

@interface PDFPage_iTM2PDFKit: PDFPage
@end

@implementation PDFPage_iTM2PDFKit
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  load
+ (void)load;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon May 30 13:39:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
	iTM2_INIT_POOL;
//iTM2_START;
	if(![SUD boolForKey:@"iTM2NOPDFPageCharacterIndexAtPointFix"])
		[self poseAsClass:[PDFPage class]];
//iTM2_END;
	iTM2_RELEASE_POOL;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  characterIndexAtPoint:
- (int)characterIndexAtPoint:(NSPoint)point;
/*"It fixes some bug but not all of them.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon May 30 13:39:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	int result = [super characterIndexAtPoint:point];
	if(result < 0)
		return result;
	if([[self string] characterAtIndex:result] == ' ')
	{
		if(result < [[self string] length] - 1)
		{
			int newResult = result + 1;
			PDFSelection * SELECTION = [self selectionForRange:NSMakeRange(newResult, 1)];
			if(SELECTION)
			{
				NSRect bounds = [SELECTION boundsForPage:self];
				if(NSPointInRect(point, bounds))
					return newResult;
			}
		}
	}
#if 0
	else
	{
		if(result)
		{
			PDFSelection * SELECTION = [self selectionForRange:NSMakeRange(result-1, 1)];
			if(SELECTION)
			{
				NSRect bounds = [SELECTION boundsForPage:self];
//iTM2_LOG(@"+++++++++++++ left character is: %@, bounds is: %@", [[self string] substringWithRange:NSMakeRange(result-1, 1)], NSStringFromRect(bounds));
			}
		}
		PDFSelection * SELECTION = [self selectionForRange:NSMakeRange(result, 1)];
		if(SELECTION)
		{
			NSRect bounds = [SELECTION boundsForPage:self];
//iTM2_LOG(@"+++++++++++++ center character is: %@, bounds is: %@", [[self string] substringWithRange:NSMakeRange(result, 1)], NSStringFromRect(bounds));
		}
		if(result < [[self string] length] - 1)
		{
			PDFSelection * SELECTION = [self selectionForRange:NSMakeRange(result+1, 1)];
			if(SELECTION)
			{
				NSRect bounds = [SELECTION boundsForPage:self];
//iTM2_LOG(@"+++++++++++++ right character is: %@, bounds is: %@", [[self string] substringWithRange:NSMakeRange(result+1, 1)], NSStringFromRect(bounds));
			}
		}
	}
#endif
    return result;
}
@end

@implementation PDFPage(iTM2SyncKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  globalToLocalCharacterIndex:
- (int)globalToLocalCharacterIndex:(int)globalIndex;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	unsigned int offset = [(iTM2XtdPDFDocument *)[self document] characterOffsetForPageAtIndex:[[self document] indexForPage:self]];
	if(offset == NSNotFound)
		return -1;
	if(globalIndex < offset)
		return -1;
	globalIndex -= offset;// local
//iTM2_END;
	return globalIndex < [self numberOfCharacters]? globalIndex: -1;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  localToGlobalCharacterIndex:
- (int)localToGlobalCharacterIndex:(int)localIndex;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(localIndex < 0)
		return localIndex;
	unsigned int offset = [(iTM2XtdPDFDocument *)[self document] characterOffsetForPageAtIndex:[[self document] indexForPage:self]];
	if(offset == NSNotFound)
		return -1;
//iTM2_END;
	return localIndex + offset;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  characterIndexNearPoint:
- (int)characterIndexNearPoint:(NSPoint)point;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	int result = [self characterIndexAtPoint:point];
	if(result >= 0) return result;
	point.x += 5;
	point.y += 5;
	result = [self characterIndexAtPoint:point];
	if(result >= 0) return result;
	point.x -= 10;
	result = [self characterIndexAtPoint:point];
	if(result >= 0) return result;
	point.y -= 10;
	result = [self characterIndexAtPoint:point];
	if(result >= 0) return result;
	point.x += 10;
//iTM2_END;
	return [self characterIndexAtPoint:point];
}
@end

@interface PDFView_iTM2PDFKit: PDFView
@end

@implementation PDFView_iTM2PDFKit
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  load
+ (void)load;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon May 30 13:39:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
	iTM2_INIT_POOL;
//iTM2_START;
	[self poseAsClass:[PDFView class]];
//iTM2_END;
	iTM2_RELEASE_POOL;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= keyDown:
- (void)keyDown:(NSEvent *)theEvent
/*"Bypass the inherited Preview behaviour.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: 
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(![[self keyBindingsManager] client:self performKeyEquivalent:theEvent])
	{
		[super keyDown:theEvent];
	}
//iTM2_END;
	return;
}
@end

@implementation PDFView(iTM2SyncKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= zoomToFit:
- (void)zoomToFit:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Jan  5 17:41:55 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	// get the current page
	PDFPage * P = [self currentPage];
	NSRect bounds = [P boundsForBox:kPDFDisplayBoxMediaBox];
	NSRect frame = [self convertRect:bounds fromPage:P];
	float expectedWidth = [self frame].size.width;
	float actualWidth = frame.size.width;
	if(actualWidth == 0)
		return;
	float widthCorrection = expectedWidth/actualWidth;
	float expectedHeight = [self frame].size.height;
	float actualHeight = frame.size.height;
	if(actualHeight == 0)
		return;
	float heightCorrection = expectedHeight/actualHeight;
	[self setScaleFactor:MIN(widthCorrection, heightCorrection) * [self scaleFactor] * 0.85];
	[self goToPage:P];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= takeCurrentPhysicalPage:synchronizationPoint:
- (BOOL)takeCurrentPhysicalPage:(int)aCurrentPhysicalPage synchronizationPoint:(NSPoint)P;
/*"O based.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  scrollDestinationToVisible:
- (void)scrollDestinationToVisible:(PDFDestination *)destination;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
#if 1
	PDFPage * page;
	page = [destination page];
	[self goToPage:page];
	int characterIndex = [page characterIndexNearPoint:[destination point]];
	NSRect characterBounds = NSZeroRect;
	characterBounds.origin = [destination point];
	if(characterIndex>=0)
		characterBounds = [page characterBoundsAtIndex:characterIndex];
	NSView * V = [self documentView];
	characterBounds = [self convertRect:[self convertRect:characterBounds fromPage:page] toView:V];
	NSPoint destinationPoint = [self convertPoint:[self convertPoint:[destination point] fromPage:page] toView:V];
	PDFSelection * selection = [page selectionForRange:NSMakeRange(0, [page numberOfCharacters])];
	NSRect pageBounds = NSZeroRect;
	if(selection)
		pageBounds = [self convertRect:[self convertRect:[selection boundsForPage:page] fromPage:page] toView:V];
	else
		pageBounds = [self convertRect:[self convertRect:[page boundsForBox:kPDFDisplayBoxMediaBox] fromPage:page] toView:V];
	NSRect lineBounds = NSZeroRect;
	if(selection = [page selectionForLineAtPoint:[destination point]])
		lineBounds = [self convertRect:[self convertRect:[selection boundsForPage:page] fromPage:page] toView:V];
	else
	{
		lineBounds.origin = destinationPoint;
		lineBounds = NSInsetRect(lineBounds, - 32, - 32);
	}
	NSRect wordBounds = lineBounds;
	if(selection = [page selectionForWordAtPoint:[destination point]])
		wordBounds = [self convertRect:[self convertRect:[selection boundsForPage:page] fromPage:page] toView:V];
	NSRect visibleDocumentRect = [V visibleRect];
	if(!NSContainsRect(visibleDocumentRect, NSInsetRect(wordBounds, -32, -16)))
	{
		// then cover the maximum range of lineBounds and pageBounds
		if(NSMaxY(pageBounds) < NSMidY(lineBounds) + visibleDocumentRect.size.height/2 + 16)
			visibleDocumentRect.origin.y = NSMaxY(pageBounds) + 16 - visibleDocumentRect.size.height;
		else if(NSMidY(lineBounds) - visibleDocumentRect.size.height/2 - 16 < NSMinY(pageBounds))
			visibleDocumentRect.origin.y = NSMinY(pageBounds) - 16;
		else
			visibleDocumentRect.origin.y = NSMidY(lineBounds) - visibleDocumentRect.size.height/2;
		if(!NSContainsRect(visibleDocumentRect, NSInsetRect(wordBounds, -32, -16)))
		{
			if(visibleDocumentRect.size.width<wordBounds.size.width + 32)
				visibleDocumentRect.origin.x = NSMidX(characterBounds) - visibleDocumentRect.size.width/2;
			else if(NSMaxX(visibleDocumentRect) < NSMaxX(wordBounds) + 16)
				visibleDocumentRect.origin.x = NSMaxX(wordBounds) + 16 - visibleDocumentRect.size.width;
			else
				visibleDocumentRect.origin.x = NSMinX(wordBounds) - 16;
		}
		[V scrollRectToVisible:visibleDocumentRect];
	}
#else
	PDFPage * page = [destination page];
	NSPoint P1 = [destination point];
	int index = [page characterIndexAtPoint:P1];
	if(index < 0)
	{
		P1.x += 5;
		P1.y += 5;
		index = [page characterIndexAtPoint:P1];
		if(index < 0)
		{
			P1.x -= 10;
			index = [page characterIndexAtPoint:P1];
			if(index < 0)
			{
				P1.y -= 10;
				index = [page characterIndexAtPoint:P1];
				if(index < 0)
				{
					P1.x += 10;
					index = [page characterIndexAtPoint:P1];
					if(index < 0)
					{
						return;
					}
				}
			}
		}
	}
	PDFSelection * currentSelection = [self currentSelection];
	PDFSelection * selection = [page selectionForRange:NSMakeRange(index, 1)];
	[self setCurrentSelection:selection];
	[self scrollSelectionToVisible:self];
	if(iTM2DebugEnabled<10)
#if 1
	// this one to avoid cocoa sending some NSException
	[self performSelector:@selector(setCurrentSelection:) withObject:currentSelection afterDelay:0.01];
#else
	[self setCurrentSelection:currentSelection];
#endif
#endif
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  scrollSynchronizationPointToVisible:
- (void)scrollSynchronizationPointToVisible:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return;
}
@end

NSString * const iTM2PDFKitKeyBindingsIdentifier = @"PDF2";

@implementation iTM2PDFKitInspector(iTM2KeyStrokeKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  keyBindingsManagerIdentifier
- (NSString *)keyBindingsManagerIdentifier;
/*"Just to autorelease the window controller of the window.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return iTM2PDFKitKeyBindingsIdentifier;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  keyBindingsManager
- (id)keyBindingsManager;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [[[self window] firstResponder] isKindOfClass:[NSText class]]?
		nil: [super keyBindingsManager];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  handlesKeyBindings
- (BOOL)handlesKeyBindings;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  tryToExecuteStringInstruction:
- (BOOL)tryToExecuteStringInstruction:(NSString *)instruction;
/*"Description forthcoming.
If the event is a 1 char key down, it will ask the current key binding for instruction.
The key and its modifiers are 
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    BOOL result = [super tryToExecuteStringInstruction:instruction];
    if(result)
        return result;
    if([instruction length])
    {
//iTM2_LOG(@"instruction is: %@", instruction);
		[[self window] pushKeyStroke:[instruction substringWithRange:NSMakeRange(0, 1)]];
		return YES;
    }
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= handlesKeyStrokes
- (BOOL)handlesKeyStrokes;
/*"YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Dec 15 14:34:51 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= deleteBackward:
- (void)deleteBackward:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Jan  5 17:41:55 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([[[self window] keyStrokes] length])
		[[self window] flushLastKeyStrokeEvent:self];
	else
		NSBeep();
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  actualSize:
- (IBAction)actualSize:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[_pdfView setScaleFactor:1.0];
	[self validateWindowContent];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateActualSize:
- (BOOL)validateActualSize:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return [_pdfView scaleFactor] != 1.0;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= doZoomIn:
- (void)doZoomIn:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Jan  5 17:41:55 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    int n = 100 * ([self contextFloatForKey:@"iTM2ZoomFactor"]>0?: 1.259921049895);
    [[[self window] keyStrokes] getIntegerTrailer: &n];
	if(n>0)
		[_pdfView setScaleFactor:n / 100.0 * [_pdfView scaleFactor]];
    [[self window] flushKeyStrokeEvents:self];
	[self validateWindowContent];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= doZoomOut:
- (void)doZoomOut:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Jan  5 17:41:55 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    int n = 100 * ([self contextFloatForKey:@"iTM2ZoomFactor"]>0?: 1.259921049895);
    [[[self window] keyStrokes] getIntegerTrailer: &n];
	if(n>0)
		[_pdfView setScaleFactor:100 * [_pdfView scaleFactor] / n];
    [[self window] flushKeyStrokeEvents:self];
	[self validateWindowContent];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= doZoomToFit:
- (void)doZoomToFit:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Jan  5 17:41:55 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	// get the current page
	[_pdfView zoomToFit:sender];
	[self validateWindowContent];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= doZoomToSelection:
- (void)doZoomToSelection:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Jan  5 17:41:55 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	#warning NOT YET IMPLEMENTED
	[self validateWindowContent];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= doGoToPreviousPage:
- (void)doGoToPreviousPage:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Jan  5 17:41:55 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    int n = 1;
    [[[self window] keyStrokes] getIntegerTrailer: &n];
	if(!n)
		return;
	PDFPage * page = [_pdfView currentPage];
	PDFDocument * document = [page document];
	unsigned int index = [document indexForPage:page];
	if(n>index)
		index = 0;
	else
		index -= n;
	[_pdfView goToPage:[document pageAtIndex:index]];
    [[self window] flushKeyStrokeEvents:self];
	[self validateWindowContent];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= doGoToNextPage:
- (void)doGoToNextPage:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Jan  5 17:41:55 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    int n = 1;
    [[[self window] keyStrokes] getIntegerTrailer: &n];
	if(!n)
		return;
	PDFPage * page = [_pdfView currentPage];
	PDFDocument * document = [page document];
	unsigned int index = [document indexForPage:page];
	unsigned int pageCount = [document pageCount];
	unsigned int count = pageCount - index;
	if(n<count)
		index += n;
	else
		index = pageCount - 1;
	[_pdfView goToPage:[document pageAtIndex:index]];
    [[self window] flushKeyStrokeEvents:self];
	[self validateWindowContent];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= doGoForward:
- (void)doGoForward:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Jan  5 17:41:55 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [_pdfView goForward:sender];
	[self validateWindowContent];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= doGoBack:
- (void)doGoBack:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Jan  5 17:41:55 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [_pdfView goBack:sender];
	[self validateWindowContent];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= displayZoom:
- (void)displayZoom:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Jan  5 17:41:55 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    int n = 100;
    [[[self window] keyStrokes] getIntegerTrailer: &n];
    [_pdfView setScaleFactor:n/100.0];
    [[self window] flushKeyStrokeEvents:self];
	[self validateWindowContent];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= displayPage:
- (void)displayPage:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Jan  5 17:41:55 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    int n = 1;
    if(![[[self window] keyStrokes] getIntegerTrailer: &n])
		return;
	if(n<1)
		n = 1;
	PDFPage * page = [_pdfView currentPage];
	PDFDocument * document = [page document];
	unsigned int pageCount = [document pageCount];
	if(--n<pageCount)
		[_pdfView goToPage:[document pageAtIndex:n]];
    [[self window] flushKeyStrokeEvents:self];
	[self validateWindowContent];
//iTM2_END;
    return;
}
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2PDFKitPrintKit  =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

@interface _iTM2SegmentedCell_1: NSSegmentedCell
@end
@implementation iTM2IconSegmentedControl: NSSegmentedControl
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  buttonPrevious
+ (void)initialize;
/*"Public use. Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri May 21 11:07:09 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[super initialize];
	[_iTM2SegmentedCell_1 poseAsClass:[NSSegmentedCell class]];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initWithCoder:
- (id)initWithCoder:(NSCoder *)aDecoder;
/*"Public use. Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri May 21 11:07:09 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(self = [super initWithCoder:aDecoder])
	{
		[self calcControlSize];
	}
	return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  calcControlSize
- (void)calcControlSize;
/*"Public use. Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri May 21 11:07:09 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	float totalSize = 0;
	float totalWidth = 0;
	int segment = 0;
	while(segment < [self segmentCount])
	{
		float imageWidth = [[self imageForSegment:segment] size].width;
		float segmentSize = [self widthForSegment:segment];
		totalSize += MIN(imageWidth, segmentSize);
		totalWidth += segmentSize;
		++segment;
	}
	float meanBlank = (totalWidth - totalSize) / [self segmentCount];
	while(segment--)
	{
		[self setWidth:[[self imageForSegment:segment] size].width + meanBlank forSegment:segment];
	}
	return;
}
@end

@implementation _iTM2SegmentedCell_1
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  init
+ (void)initialize;
/*"Public use. Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri May 21 11:07:09 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[super initialize];
	[SUD registerDefaults: [NSDictionary dictionaryWithObjectsAndKeys:
			[NSNumber numberWithFloat:0.9] ,@"iTM2SmallControlScaleFactor",
			[NSNumber numberWithFloat:0.8], @"iTM2MiniControlScaleFactor",
				nil]];
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  init
- (id)init;
/*"Public use. Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri May 21 11:07:09 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	return [super init];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  drawSegment:inFrame:withView:
- (void)drawSegment:(int)segment inFrame:(NSRect)frame withView:(NSView *)controlView;
/*"Public use. Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri May 21 11:07:09 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([controlView isKindOfClass:[iTM2IconSegmentedControl class]])
	{
		NSImage * oldImage = [self imageForSegment:segment];
		if(oldImage)
		{
			[[oldImage retain] autorelease];
			NSImage * newImage = [[[NSImage allocWithZone:[self zone]] initWithSize:[oldImage size]] autorelease];
			[self setImage:newImage forSegment:segment];
			[super drawSegment:(int)segment inFrame:(NSRect)frame withView:(NSView *)controlView];
			float fraction = [self isEnabledForSegment:segment]? 1: 0.5;
			NSControlSize CS = [self controlSize];
			float factor = (CS == NSRegularControlSize)? 1:
								((CS == NSSmallControlSize)? [SUD floatForKey:@"iTM2SmallControlScaleFactor"]:
									[SUD floatForKey:@"iTM2MiniControlScaleFactor"]);
//NSLog(@"factor is: %f", factor);
			NSSize oldSize = [oldImage size];
			NSPoint point = NSMakePoint(NSMidX(frame), NSMidY(frame));
			point.x -= oldSize.width / 2 * factor;
			point.y += oldSize.height / 2 * factor;
			[oldImage setSize:NSMakeSize(oldSize.width * factor, oldSize.height * factor)];
			[oldImage setScalesWhenResized:YES];
			[oldImage dissolveToPoint:point fraction:fraction];
			[oldImage setSize:oldSize];
			[self setImage:oldImage forSegment:segment];
			return;
		}
	}
	[super drawSegment:(int)segment inFrame:(NSRect)frame withView:(NSView *)controlView];
	return;
}
@end

@interface iTM2PDFKitDefaultsController: iTM2Inspector
- (NSMutableDictionary *)model;
- (void)setModel:(NSDictionary *)argument;
- (NSMutableDictionary *)originalModel;
- (void)setOriginalModel:(NSDictionary *)argument;
- (NSMutableDictionary *)modelSync;
- (void)setModelSync:(NSDictionary *)argument;
- (NSMutableDictionary *)originalModelSync;
- (void)setOriginalModelSync:(NSDictionary *)argument;
- (NSMutableDictionary *)projectModel;
- (void)setProjectModel:(NSDictionary *)argument;
- (NSMutableDictionary *)projectModelSync;
- (void)setProjectModelSync:(NSDictionary *)argument;
- (NSColor *)backgroundColor;
- (void)setBackgroundColor:(NSColor *)argument;
- (int)displayBox;
- (void)setDisplayBox:(int)argument;
- (PDFDisplayMode)displayMode;
- (void)setDisplayMode:(PDFDisplayMode)argument;
- (float)greekingThreshold;
- (void)setGreekingThreshold:(float)argument;
- (BOOL)shouldAntiAlias;
- (void)setShouldAntiAlias:(BOOL)argument;
- (BOOL)autoScales;
- (void)setAutoScales:(BOOL)argument;
- (BOOL)displaysAsBook;
- (void)setDisplaysAsBook:(BOOL)argument;
- (BOOL)isContinuous;
- (void)setContinuous:(BOOL)argument;
- (BOOL)followFocus;
- (void)setFollowFocus:(BOOL)followFocus;
- (BOOL)enableSynchronization;
- (void)setEnableSynchronization:(BOOL)enableSynchronization;
- (unsigned int)displayBullets;
- (void)setDisplayBullets:(unsigned int)displayBullets;
@end

#undef GETTER
#define GETTER [[self model] valueForKey:iTM2KeyFromSelector(_cmd)]
#undef SETTER
#define SETTER(argument) [[self model] setValue:argument forKey:iTM2KeyFromSelector(_cmd)]

NSString * const iTM2PDFKitViewerDefaultsDidChangeNotification = @"iTM2PDFKitViewerDefaultsDidChangeNotification";

@implementation iTM2PDFKitDefaultsController
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inspectorType
+ (NSString *)inspectorType;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return iTM2PDFGraphicsInspectorType;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inspectorMode
+ (NSString *)inspectorMode;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return @".DefaultsModel";// dot prefixed inspector modes do not appear in the inspector menu nor in the makeWindowControllers
}
#pragma mark =-=-=-=-=-  PRINT INFO
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  registerPrintInfoNotificationWindowDidLoad
- (void)registerPrintInfoNotificationWindowDidLoad;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[INC addObserver: self
		selector: @selector(printInfoDidChangeNotified:)
			name: iTM2PrintInfoDidChangeNotification
				object: nil];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  printInfoDidChangeNotified:
- (void)printInfoDidChangeNotified:(NSNotification *)aNotification;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	iTM2_LOG(@"old: %@", [[aNotification object] dictionary]);
	iTM2_LOG(@"new: %@", [aNotification userInfo]);
//iTM2_END;
    return;
}
#pragma mark =-=-=-=-=-  MODELS
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  fixDefaultsModelWindowDidLoad
- (void)fixDefaultsModelWindowDidLoad;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self setModel:[NSMutableDictionary dictionary]];
	PDFView * V = [[[PDFView allocWithZone:[self zone]] initWithFrame:NSZeroRect] autorelease];
	[self setDisplayMode:[V displayMode]];
	[self setBackgroundColor:[V backgroundColor]];
	[self setDisplayBox:[V displayBox]];
	[self setGreekingThreshold:[V greekingThreshold]];
	[self setShouldAntiAlias:[V shouldAntiAlias]];
	[self setAutoScales:[V autoScales]];
	[self setDisplaysAsBook:[V displaysAsBook]];
	// the factory model is the above defined hard coded model
	// there is only one factory model for both projects and application
	NSDictionary * D = [SUD dictionaryForKey:@"iTM2PDFKit"];
	if(D)
		[[self model] addEntriesFromDictionary:D];
	// the defaults model comes from the SUD, it concerns the application
	// it is overriden by the project model
	D = [self contextDictionaryForKey:@"iTM2PDFKit"];
	if(D)
		[[self model] addEntriesFromDictionary:D];
	[self setProjectModel:[self model]];
	// the project model is specific to the project
	// It is meant to override both factory and defaults models
	[self setOriginalModel:[self model]];
	// when editing, the original model is the one we edit
	// the edited model is in model
	// revert to save is just placing into model a mutable copy of the original model
	
	// The same design for sync
	[self setModelSync:[NSMutableDictionary dictionary]];
	D = [SUD dictionaryForKey:@"iTM2PDFKitSync"];
	if(D)
		[[self modelSync] addEntriesFromDictionary:D];
//iTM2_END;
	D = [self contextDictionaryForKey:@"iTM2PDFKitSync"];
	if(D)
		[[self modelSync] addEntriesFromDictionary:D];
	[self setProjectModelSync:[self modelSync]];
	[self setOriginalModelSync:[self modelSync]];
    return;
}
#pragma mark =-=-=-=-=-  MODEL HOLDERS
#define defineMODELHOLDER(getSelector, setSelector)\
- (NSMutableDictionary *)getSelector;{return metaGETTER;}\
- (void)setSelector:(NSDictionary *)argument;{metaSETTER([[argument mutableCopy] autorelease]);return;}
defineMODELHOLDER(model, setModel)
defineMODELHOLDER(projectModel, setProjectModel)
defineMODELHOLDER(originalModel, setOriginalModel)
defineMODELHOLDER(modelSync, setModelSync)
defineMODELHOLDER(projectModelSync, setProjectModelSync)
defineMODELHOLDER(originalModelSync, setOriginalModelSync)
#pragma mark =-=-=-=-=-  UI
#if 0
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  tabView:didSelectTabViewItem:
- (void)tabView:(NSTabView *)tabView didSelectTabViewItem:(NSTabViewItem *)tabViewItem;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self validateWindowContent];
//iTM2_END;
    return;
}
#endif
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  contextDidChange
- (void)contextDidChange;
/*"This message is sent each time the contextManager have changed.
The receiver will take appropriate actions to synchronize its state with its contextManager.
Subclasses will most certainly override this method because the default implementation does nothing.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSEnumerator * E = [[[self document] windowControllers] objectEnumerator];
	NSWindowController * WC;
	while(WC = [E nextObject])
		if(WC != self)
			[WC contextDidChange];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  apply
- (IBAction)apply:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSMutableDictionary * MD = [[[self contextDictionaryForKey:@"iTM2PDFKit"] mutableCopy] autorelease];
	[MD addEntriesFromDictionary:[self model]];
	[self takeContextValue:MD forKey:@"iTM2PDFKit"];
	[self setModel:MD];
	[self setProjectModel:[self model]];
	[self setOriginalModel:[self projectModel]];
	MD = [[[self contextDictionaryForKey:@"iTM2PDFKitSync"] mutableCopy] autorelease];
	[MD addEntriesFromDictionary:[self modelSync]];
	[self takeContextValue:MD forKey:@"iTM2PDFKitSync"];
	[self setProjectModelSync:[self modelSync]];
	[self setOriginalModelSync:[self projectModelSync]];
	NSEnumerator * E = [[[self document] windowControllers] objectEnumerator];
	id WC;
	while(WC = [E nextObject])
	{
		if(WC != self)
			[WC contextDidChange];
	}
	[self validateWindowContent];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  canApply
- (BOOL)canApply;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return ![[self model] isEqual:[self originalModel]] || ![[self modelSync] isEqual:[self originalModelSync]];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateApply
- (BOOL)validateApply:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return [self canApply];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  revert:
- (IBAction)revert:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self setModel:[self originalModel]];
	[self setModelSync:[self originalModelSync]];
	[self validateWindowContent];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateRevert:
- (BOOL)validateRevert:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return [self canApply];
}
#pragma mark =-=-=-=-=-  BACKGROUND COLOR
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  backgroundColor
- (NSColor *)backgroundColor;
{
	
	NSData * data = GETTER;
	if(data)
	{
		id result = [NSUnarchiver unarchiveObjectWithData:data];
		if([result isKindOfClass:[NSColor class]])
			return result;
	}
	return [[[[PDFView allocWithZone:[self zone]] initWithFrame:NSZeroRect] autorelease] backgroundColor];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setBackgroundColor:
- (void)setBackgroundColor:(NSColor *)argument;
{
	SETTER(([argument isKindOfClass:[NSColor class]]?[NSArchiver archivedDataWithRootObject:argument]: nil));
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeBackgroundColorFrom:
- (IBAction)takeBackgroundColorFrom:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSColor * newColor = [sender color];
	if(![newColor isEqual:[self backgroundColor]])
	{
		[self setBackgroundColor:newColor];
		[self validateWindowContent];
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateTakeBackgroundColorFrom:
- (BOOL)validateTakeBackgroundColorFrom:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSColor * newColor = [self backgroundColor];
	if(![newColor isEqual:[sender color]])
		[sender setColor:newColor];
//iTM2_END;
    return YES;
}
#pragma mark =-=-=-=-=-  DISPLAY BOX
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  displayBox
- (int)displayBox;
{
	return [GETTER intValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setDisplayBox:
- (void)setDisplayBox:(int)argument;
{
	SETTER([NSNumber numberWithInt:argument]);
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeDisplayBoxFromSelectedTag:
- (IBAction)takeDisplayBoxFromSelectedTag:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self setDisplayBox:[[sender selectedCell] tag]];
	[self validateWindowContent];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateTakeDisplayBoxFromSelectedTag:
- (BOOL)validateTakeDisplayBoxFromSelectedTag:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[sender deselectAllCells];
	[sender selectCellWithTag:[self displayBox]];
//iTM2_END;
    return YES;
}
#pragma mark =-=-=-=-=-  DISPLAY MODE
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  displayMode
- (PDFDisplayMode)displayMode;
{
	return [GETTER intValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setDisplayMode:
- (void)setDisplayMode:(PDFDisplayMode)argument;
{
	SETTER([NSNumber numberWithInt: (int)argument]);
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeDisplayModeFromSelectedTag:
- (IBAction)takeDisplayModeFromSelectedTag:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self setDisplayMode:2*[[sender selectedCell] tag]+([self isContinuous]?1:0)];
	[self validateWindowContent];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateTakeDisplayModeFromSelectedTag:
- (BOOL)validateTakeDisplayModeFromSelectedTag:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[sender selectCellWithTag:[self displayMode]/2];
//iTM2_END;
    return YES;
}
#pragma mark =-=-=-=-=-  GREEKING THRESHOLD
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  greekingThreshold
- (float)greekingThreshold;
{
	return [GETTER floatValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setGreekingThreshold:
- (void)setGreekingThreshold:(float)argument;
{
	SETTER([NSNumber numberWithFloat: (float)argument]);
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeGreekingThresholdFrom:
- (IBAction)takeGreekingThresholdFrom:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self setGreekingThreshold:[sender floatValue]];
	[self validateWindowContent];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateTakeGreekingThresholdFrom:
- (BOOL)validateTakeGreekingThresholdFrom:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[sender setFloatValue:[self greekingThreshold]];
//iTM2_END;
    return YES;
}
#pragma mark =-=-=-=-=-  ANTI ALIAS
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  shouldAntiAlias
- (BOOL)shouldAntiAlias;
{
	return [GETTER boolValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setShouldAntiAlias:
- (void)setShouldAntiAlias:(BOOL)argument;
{
	SETTER([NSNumber numberWithBool: (int)argument]);
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleShouldAntiAlias:
- (IBAction)toggleShouldAntiAlias:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self setShouldAntiAlias: ![self shouldAntiAlias]];
	[self validateWindowContent];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleShouldAntiAlias:
- (BOOL)validateToggleShouldAntiAlias:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[sender setState: ([self shouldAntiAlias]? NSOnState:NSOffState)];
//iTM2_END;
    return YES;
}
#pragma mark =-=-=-=-=-  AUTO SCALE
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  autoScales
- (BOOL)autoScales;
{
	return [GETTER boolValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setAutoScales:
- (void)setAutoScales:(BOOL)argument;
{
	SETTER([NSNumber numberWithBool: (int)argument]);
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleAutoScales:
- (IBAction)toggleAutoScales:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self setAutoScales: ![self autoScales]];
	[self validateWindowContent];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleAutoScales:
- (BOOL)validateToggleAutoScales:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[sender setState: ([self autoScales]? NSOnState:NSOffState)];
//iTM2_END;
    return YES;
}
#pragma mark =-=-=-=-=-  BOOK MODE
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  displaysAsBook
- (BOOL)displaysAsBook;
{
	return [GETTER boolValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setDisplaysAsBook:
- (void)setDisplaysAsBook:(BOOL)argument;
{
	SETTER([NSNumber numberWithBool:argument]);
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleDisplaysAsBook:
- (IBAction)toggleDisplaysAsBook:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self setDisplaysAsBook: ![self displaysAsBook]];
	[self validateWindowContent];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleDisplaysAsBook:
- (BOOL)validateToggleDisplaysAsBook:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[sender setState: ([self displaysAsBook]? NSOnState:NSOffState)];
//iTM2_END;
    return [self displayMode]>1;
}
#pragma mark =-=-=-=-=-  PAGE BREAKS
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  displaysPageBreaks
- (BOOL)displaysPageBreaks;
{
	return [GETTER boolValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setDisplaysPageBreaks:
- (void)setDisplaysPageBreaks:(BOOL)argument;
{
	SETTER([NSNumber numberWithBool: (int)argument]);
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleDisplaysPageBreaks:
- (IBAction)toggleDisplaysPageBreaks:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self setDisplaysPageBreaks: ![self displaysPageBreaks]];
	[self validateWindowContent];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleDisplaysPageBreaks:
- (BOOL)validateToggleDisplaysPageBreaks:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[sender setState: ([self displaysPageBreaks]? NSOnState:NSOffState)];
//iTM2_END;
    return [self isContinuous];
}
#pragma mark =-=-=-=-=-  CONTINUOUS
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  isContinuous
- (BOOL)isContinuous;
{
	return [self displayMode] % 2;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setContinuous:
- (void)setContinuous:(BOOL)argument;
{
	[self setDisplayMode:2*([self displayMode]/2) + (argument? 1:0)];
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleContinuous:
- (IBAction)toggleContinuous:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self setContinuous: ![self isContinuous]];
	[self validateWindowContent];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleContinuous:
- (BOOL)validateToggleContinuous:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[sender setState: ([self isContinuous]? NSOnState:NSOffState)];
//iTM2_END;
    return YES;
}
#pragma mark =-=-=-=-=-  MODEL
#undef GETTER
#define GETTER [[self modelSync] valueForKey:iTM2KeyFromSelector(_cmd)]
#undef SETTER
#define SETTER(argument) [[self modelSync] setValue:argument forKey:iTM2KeyFromSelector(_cmd)]
#pragma mark =-=-=-=-=-  ENABLE SYNCHRONIZATION
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  enableSynchronization
- (BOOL)enableSynchronization;
{
	return [GETTER boolValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setEnableSynchronization:
- (void)setEnableSynchronization:(BOOL)enableSynchronization;
{
	SETTER([NSNumber numberWithBool:enableSynchronization]);
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleEnableSynchronization:
- (IBAction)toggleEnableSynchronization:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self setEnableSynchronization: ![self enableSynchronization]];
	[self validateWindowContent];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleEnableSynchronization:
- (BOOL)validateToggleEnableSynchronization:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[sender setState: ([self enableSynchronization]? NSOnState:NSOffState)];
//iTM2_END;
    return YES;
}
#pragma mark =-=-=-=-=-  FOLLOW FOCUS
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  followFocus
- (BOOL)followFocus;
{
	return [GETTER boolValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setFollowFocus:
- (void)setFollowFocus:(BOOL)followFocus;
{
	SETTER([NSNumber numberWithBool:followFocus]);
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleFollowFocus:
- (IBAction)toggleFollowFocus:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self setFollowFocus: ![self followFocus]];
	[self validateWindowContent];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleFollowFocus:
- (BOOL)validateToggleFollowFocus:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[sender setState: ([self followFocus]? NSOnState:NSOffState)];
//iTM2_END;
    return [self enableSynchronization];
}
#pragma mark =-=-=-=-=-  DISPLAY BULLETS
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  displayBullets
- (unsigned int)displayBullets;
{
	return [GETTER unsignedIntValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setDisplayBullets:
- (void)setDisplayBullets:(unsigned int)displayBullets;
{
	SETTER([NSNumber numberWithUnsignedInt:displayBullets]);
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleDisplayBulletsFromTag:
- (IBAction)toggleDisplayBulletsFromTag:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self setDisplayBullets:[self displayBullets]^[sender tag]];
	[self validateWindowContent];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleDisplayBulletsFromTag:
- (BOOL)validateToggleDisplayBulletsFromTag:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[sender setState: (([self displayBullets]&[sender tag])? NSOnState:NSOffState)];
//iTM2_END;
    return [self enableSynchronization];
}
@end

@implementation iTM2PDFKitInspector(DEFAULTS)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  showViewerPreferences:
- (IBAction)showViewerPreferences:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSWindowController * WC = [[self document] inspectorAddedWithMode:[iTM2PDFKitDefaultsController inspectorMode]];
	NSWindow * W = [WC window];
	[W makeKeyAndOrderFront:self];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateShowViewerPreferences:
- (BOOL)validateShowViewerPreferences:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return YES;
}
@end

@interface iTM2PDFKitInspector(CATCHER)
- (IBAction)messageCatcher_iTM2PDFKitInspector:(id)sender;
@end

@implementation iTM2PDFKitInspector(CATCHER)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  messageCatcher_iTM2PDFKitInspector:
- (IBAction)messageCatcher_iTM2PDFKitInspector:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return;
}
@end

#undef GETTER
#undef SETTER
#define GETTER(KEY) [[self contextValueForKey:@"iTM2PDFKit"] valueForKey:KEY]
#define SETTER(KEY, argument) id __D = [[[self contextDictionaryForKey:@"iTM2PDFKit"] mutableCopy] autorelease];\
if(!__D) __D = [NSMutableDictionary dictionary];\
[__D setValue:argument forKey:KEY];\
[self takeContextValue:__D forKey:@"iTM2PDFKit"];\
[[self contextManager] contextDidChange];

@implementation NSApplication(iTM2PDFKitResponder)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  load
+ (void)load;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
	iTM2_INIT_POOL;
//iTM2_START;
	[iTM2MileStone registerMileStone:@"No installer available" forKey:@"iTM2PDFKitResponder"];
//iTM2_END;
	iTM2_RELEASE_POOL;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2PDFKitResponderDidFinishLaunching
- (void)iTM2PDFKitResponderDidFinishLaunching;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([self targetForAction:@selector(setSinglePages:)])
		[iTM2MileStone putMileStoneForKey:@"iTM2PDFKitResponder"];
//iTM2_END;
	return;
}
@end

@implementation iTM2PDFKitResponder
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  contextManager
- (id)contextManager;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return [NSApp targetForAction:@selector(messageCatcher_iTM2PDFKitInspector:)]?:[super contextManager];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setSinglePages:
- (IBAction)setSinglePages:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	int newMode = kPDFDisplaySinglePage;
	switch([GETTER(@"DisplayMode") intValue])
	{
		case kPDFDisplaySinglePageContinuous:
		case kPDFDisplayTwoUpContinuous:
			newMode = kPDFDisplaySinglePageContinuous;
	}
	SETTER(@"DisplayMode", [NSNumber numberWithInt:newMode]);
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateSetSinglePages:
- (BOOL)validateSetSinglePages:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	int mode = [GETTER(@"DisplayMode") intValue];
	[sender setState: ((mode == kPDFDisplaySinglePage)|| (mode == kPDFDisplaySinglePageContinuous)? NSOnState:NSOffState)];
//iTM2_END;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setFacingPages:
- (IBAction)setFacingPages:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	int newMode = kPDFDisplayTwoUp;
	switch([GETTER(@"DisplayMode") intValue])
	{
		case kPDFDisplaySinglePageContinuous:
		case kPDFDisplayTwoUpContinuous:
			newMode = kPDFDisplayTwoUpContinuous;
	}
	SETTER(@"DisplayMode", [NSNumber numberWithInt:newMode]);
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateSetFacingPages:
- (BOOL)validateSetFacingPages:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	int mode = [GETTER(@"DisplayMode") intValue];
	[sender setState: ((mode == kPDFDisplayTwoUp)|| (mode == kPDFDisplayTwoUpContinuous)? NSOnState:NSOffState)];
//iTM2_END;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleContinuousPage:
- (IBAction)toggleContinuousPage:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	int newMode = kPDFDisplaySinglePage;
	switch([GETTER(@"DisplayMode") intValue])
	{
		case kPDFDisplaySinglePageContinuous:
			newMode = kPDFDisplaySinglePage;
			break;
		case kPDFDisplaySinglePage:
			newMode = kPDFDisplaySinglePageContinuous;
			break;
		case kPDFDisplayTwoUpContinuous:
			newMode = kPDFDisplayTwoUp;
			break;
		case kPDFDisplayTwoUp:
			newMode = kPDFDisplayTwoUpContinuous;
			break;
	}
	SETTER(@"DisplayMode", [NSNumber numberWithInt:newMode]);
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleContinuousPage:
- (BOOL)validateToggleContinuousPage:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	int mode = [GETTER(@"DisplayMode") intValue];
	[sender setState: ((mode == kPDFDisplaySinglePageContinuous)|| (mode == kPDFDisplayTwoUpContinuous)? NSOnState:NSOffState)];
//iTM2_END;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  bookMode:
- (IBAction)bookMode:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	SETTER(@"DisplaysAsBook", [NSNumber numberWithBool: ![GETTER(@"DisplaysAsBook") boolValue]]);
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateBookMode:
- (BOOL)validateBookMode:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[sender setState: ([GETTER(@"DisplaysAsBook") boolValue]? NSOnState:NSOffState)];
//iTM2_END;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  togglePageBreaks:
- (IBAction)togglePageBreaks:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	SETTER(@"DisplaysPageBreaks", [NSNumber numberWithBool: ![GETTER(@"DisplaysPageBreaks") boolValue]]);
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateTogglePageBreaks:
- (BOOL)validateTogglePageBreaks:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[sender setState: ([GETTER(@"DisplaysPageBreaks") boolValue]? NSOnState:NSOffState)];
//iTM2_END;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  displayMediaBox:
- (IBAction)displayMediaBox:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	SETTER(@"DisplayBox", [NSNumber numberWithInt:kPDFDisplayBoxMediaBox]);
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateDisplayMediaBox:
- (BOOL)validateDisplayMediaBox:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[sender setState: ([GETTER(@"DisplayBox") intValue] == kPDFDisplayBoxMediaBox? NSOnState:NSOffState)];
//iTM2_END;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  displayCropBox:
- (IBAction)displayCropBox:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	SETTER(@"DisplayBox", [NSNumber numberWithInt:kPDFDisplayBoxCropBox]);
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateDisplayCropBox:
- (BOOL)validateDisplayCropBox:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[sender setState: ([GETTER(@"DisplayBox") intValue] == kPDFDisplayBoxCropBox? NSOnState:NSOffState)];
//iTM2_END;
    return YES;
}
@end

@interface iTM2PDFKitPrefPane: iTM2PreferencePane
- (BOOL)isContinuous;
@end

@implementation iTM2PDFKitPrefPane
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  load
+ (void)load;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	iTM2_INIT_POOL;
	id controller = [[[iTM2PDFKitDefaultsController alloc] init] autorelease];
	[controller setModel:[NSMutableDictionary dictionary]];
	PDFView * V = [[[PDFView allocWithZone:[self zone]] initWithFrame:NSZeroRect] autorelease];
	[controller setDisplayMode:[V displayMode]];
	[controller setBackgroundColor:[V backgroundColor]];
	[controller setDisplayBox:[V displayBox]];
	[controller setGreekingThreshold:[V greekingThreshold]];
	[controller setShouldAntiAlias:YES];
	[controller setAutoScales:NO];
	[controller setDisplaysAsBook:[V displaysAsBook]];
	[SUD registerDefaults:[NSDictionary dictionaryWithObject:[controller model] forKey:@"iTM2PDFKit"]];
	iTM2_RELEASE_POOL;
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  prefPaneIdentifier
- (NSString *)prefPaneIdentifier;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	return @"3.PDF.Tiger";
}
#if 0
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  tabView:didSelectTabViewItem:
- (void)tabView:(NSTabView *)tabView didSelectTabViewItem:(NSTabViewItem *)tabViewItem;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[[self mainView] validateWindowContent];
//iTM2_END;
    return;
}
#endif
#undef GETTER
#undef SETTER
#define GETTER [[SUD dictionaryForKey:@"iTM2PDFKit"] valueForKey:iTM2KeyFromSelector(_cmd)]
#define SETTER(argument) id __D = [[[SUD dictionaryForKey:@"iTM2PDFKit"] mutableCopy] autorelease];\
if(!__D) __D = [NSMutableDictionary dictionary];\
[__D setValue:argument forKey:iTM2KeyFromSelector(_cmd)];\
[SUD setObject:__D forKey:@"iTM2PDFKit"];
#pragma mark =-=-=-=-=-  BACKGROUND COLOR
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  backgroundColor
- (NSColor *)backgroundColor;
{
	
	NSData * data = GETTER;
	if(data)
	{
		id result = [NSUnarchiver unarchiveObjectWithData:data];
		if([result isKindOfClass:[NSColor class]])
			return result;
	}
	return [[[[PDFView allocWithZone:[self zone]] initWithFrame:NSZeroRect] autorelease] backgroundColor];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setBackgroundColor:
- (void)setBackgroundColor:(NSColor *)argument;
{
	SETTER(([argument isKindOfClass:[NSColor class]]?[NSArchiver archivedDataWithRootObject:argument]: nil));
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeBackgroundColorFrom:
- (IBAction)takeBackgroundColorFrom:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSColor * newColor = [sender color];
	if(![newColor isEqual:[self backgroundColor]])
	{
		[self setBackgroundColor:newColor];
		[sender validateWindowContent];
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateTakeBackgroundColorFrom:
- (BOOL)validateTakeBackgroundColorFrom:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSColor * newColor = [self backgroundColor];
	if(![newColor isEqual:[sender color]])
		[sender setColor:newColor];
//iTM2_END;
    return YES;
}
#pragma mark =-=-=-=-=-  DISPLAY BOX
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  displayBox
- (int)displayBox;
{
	return [GETTER intValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setDisplayBox:
- (void)setDisplayBox:(int)argument;
{
	SETTER([NSNumber numberWithInt:argument]);
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeDisplayBoxFromSelectedTag:
- (IBAction)takeDisplayBoxFromSelectedTag:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self setDisplayBox:[[sender selectedCell] tag]];
	[sender validateWindowContent];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateTakeDisplayBoxFromSelectedTag:
- (BOOL)validateTakeDisplayBoxFromSelectedTag:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[sender deselectAllCells];
	[sender selectCellWithTag:[self displayBox]];
//iTM2_END;
    return YES;
}
#pragma mark =-=-=-=-=-  DISPLAY MODE
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  displayMode
- (PDFDisplayMode)displayMode;
{
	return [GETTER intValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setDisplayMode:
- (void)setDisplayMode:(PDFDisplayMode)argument;
{
	SETTER([NSNumber numberWithInt: (int)argument]);
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeDisplayModeFromSelectedTag:
- (IBAction)takeDisplayModeFromSelectedTag:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self setDisplayMode:2*[[sender selectedCell] tag]+([self isContinuous]?1:0)];
	[sender validateWindowContent];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateTakeDisplayModeFromSelectedTag:
- (BOOL)validateTakeDisplayModeFromSelectedTag:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[sender selectCellWithTag:[self displayMode]/2];
//iTM2_END;
    return YES;
}
#pragma mark =-=-=-=-=-  GREEKING THRESHOLD
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  greekingThreshold
- (float)greekingThreshold;
{
	return [GETTER floatValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setGreekingThreshold:
- (void)setGreekingThreshold:(float)argument;
{
	SETTER([NSNumber numberWithFloat:argument]);
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeGreekingThresholdFrom:
- (IBAction)takeGreekingThresholdFrom:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self setGreekingThreshold:[sender floatValue]];
	[sender validateWindowContent];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateTakeGreekingThresholdFrom:
- (BOOL)validateTakeGreekingThresholdFrom:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[sender setFloatValue:[self greekingThreshold]];
//iTM2_END;
    return YES;
}
#pragma mark =-=-=-=-=-  ANTI ALIAS
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  shouldAntiAlias
- (BOOL)shouldAntiAlias;
{
	return [GETTER boolValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setShouldAntiAlias:
- (void)setShouldAntiAlias:(BOOL)argument;
{
	SETTER([NSNumber numberWithBool: (int)argument]);
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleShouldAntiAlias:
- (IBAction)toggleShouldAntiAlias:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self setShouldAntiAlias: ![self shouldAntiAlias]];
	[sender validateWindowContent];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleShouldAntiAlias:
- (BOOL)validateToggleShouldAntiAlias:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[sender setState: ([self shouldAntiAlias]? NSOnState:NSOffState)];
//iTM2_END;
    return YES;
}
#pragma mark =-=-=-=-=-  AUTO SCALE
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  autoScales
- (BOOL)autoScales;
{
	return [GETTER boolValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setAutoScales:
- (void)setAutoScales:(BOOL)argument;
{
	SETTER([NSNumber numberWithBool: (int)argument]);
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleAutoScales:
- (IBAction)toggleAutoScales:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self setAutoScales: ![self autoScales]];
	[sender validateWindowContent];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleAutoScales:
- (BOOL)validateToggleAutoScales:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[sender setState: ([self autoScales]? NSOnState:NSOffState)];
//iTM2_END;
    return YES;
}
#pragma mark =-=-=-=-=-  BOOK MODE
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  displaysAsBook
- (BOOL)displaysAsBook;
{
	return [GETTER boolValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setDisplaysAsBook:
- (void)setDisplaysAsBook:(BOOL)argument;
{
	SETTER([NSNumber numberWithBool:argument]);
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleDisplaysAsBook:
- (IBAction)toggleDisplaysAsBook:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self setDisplaysAsBook: ![self displaysAsBook]];
	[sender validateWindowContent];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleDisplaysAsBook:
- (BOOL)validateToggleDisplaysAsBook:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[sender setState: ([self displaysAsBook]? NSOnState:NSOffState)];
//iTM2_END;
    return [self displayMode]>1;
}
#pragma mark =-=-=-=-=-  PAGE BREAKS
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  displaysPageBreaks
- (BOOL)displaysPageBreaks;
{
	return [GETTER boolValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setDisplaysPageBreaks:
- (void)setDisplaysPageBreaks:(BOOL)argument;
{
	SETTER([NSNumber numberWithBool:argument]);
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleDisplaysPageBreaks:
- (IBAction)toggleDisplaysPageBreaks:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self setDisplaysPageBreaks: ![self displaysPageBreaks]];
	[sender validateWindowContent];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleDisplaysPageBreaks:
- (BOOL)validateToggleDisplaysPageBreaks:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[sender setState: ([self displaysPageBreaks]? NSOnState:NSOffState)];
//iTM2_END;
    return [self isContinuous];
}
#pragma mark =-=-=-=-=-  CONTINUOUS
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  isContinuous
- (BOOL)isContinuous;
{
	return [self displayMode] % 2;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setContinuous:
- (void)setContinuous:(BOOL)argument;
{
	[self setDisplayMode:2*([self displayMode]/2) + (argument? 1:0)];
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleContinuous:
- (IBAction)toggleContinuous:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self setContinuous: ![self isContinuous]];
	[sender validateWindowContent];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleContinuous:
- (BOOL)validateToggleContinuous:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[sender setState: ([self isContinuous]? NSOnState:NSOffState)];
//iTM2_END;
    return YES;
}
#pragma mark =-=-=-=-=-  MODEL
#undef GETTER
#undef SETTER
#define GETTER [[SUD dictionaryForKey:@"iTM2PDFKitSync"] valueForKey:iTM2KeyFromSelector(_cmd)]
#define SETTER(argument) id __D = [[[SUD dictionaryForKey:@"iTM2PDFKitSync"] mutableCopy] autorelease];\
if(!__D) __D = [NSMutableDictionary dictionary];\
[__D setValue:argument forKey:iTM2KeyFromSelector(_cmd)];\
[SUD setObject:__D forKey:@"iTM2PDFKitSync"];
#pragma mark =-=-=-=-=-  ENABLE SYNCHRONIZATION
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  enableSynchronization
- (BOOL)enableSynchronization;
{
	return [GETTER boolValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setEnableSynchronization:
- (void)setEnableSynchronization:(BOOL)enableSynchronization;
{
	SETTER([NSNumber numberWithBool:enableSynchronization]);
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleEnableSynchronization:
- (IBAction)toggleEnableSynchronization:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self setEnableSynchronization: ![self enableSynchronization]];
	[sender validateWindowContent];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleEnableSynchronization:
- (BOOL)validateToggleEnableSynchronization:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[sender setState: ([self enableSynchronization]? NSOnState:NSOffState)];
//iTM2_END;
    return YES;
}
#pragma mark =-=-=-=-=-  FOLLOW FOCUS
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  followFocus
- (BOOL)followFocus;
{
	return [GETTER boolValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setFollowFocus:
- (void)setFollowFocus:(BOOL)followFocus;
{
	SETTER([NSNumber numberWithBool:followFocus]);
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleFollowFocus:
- (IBAction)toggleFollowFocus:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self setFollowFocus: ![self followFocus]];
	[sender validateWindowContent];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleFollowFocus:
- (BOOL)validateToggleFollowFocus:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[sender setState: ([self followFocus]? NSOnState:NSOffState)];
//iTM2_END;
    return [self enableSynchronization];
}
#pragma mark =-=-=-=-=-  DISPLAY BULLETS
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  displayBullets
- (unsigned int)displayBullets;
{
	return [GETTER unsignedIntValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setDisplayBullets:
- (void)setDisplayBullets:(unsigned int)displayBullets;
{
	SETTER([NSNumber numberWithUnsignedInt:displayBullets]);
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleDisplayBulletsFromTag:
- (IBAction)toggleDisplayBulletsFromTag:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self setDisplayBullets:[self displayBullets]^[sender tag]];
	[sender validateWindowContent];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleDisplayBulletsFromTag:
- (BOOL)validateToggleDisplayBulletsFromTag:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[sender setState: (([self displayBullets]&[sender tag])? NSOnState:NSOffState)];
//iTM2_END;
    return [self enableSynchronization];
}
@end

@implementation iTM2PDFKitResponder(ViewMenu)
#if 0
doZoomToSelection:
slideshow:

doGoToFirstPage:
doGoToLastPage:
goToPageNumberPanel:
rotateLeft:
rotateRight:
flipHorizontal:
flipVertical:

getInfo:
myRating:
scrollTool:
textTool:
selectTool:
annotateTool:
setFreeTextAnnotation:
setCircleAnnotation:


crop:
matchToProfile:
assigneProfile:
imageCorrection:
#endif
@end

#undef GETTER
#undef SETTER

#define BUNDLE 
#define DEFINE_IMAGE(SELECTOR, NAME)\
+ (NSImage *)SELECTOR;\
{\
	static NSImage * I = nil;\
	if(!I)\
	{\
		I = [[NSImage allocWithZone:[self zone]] initWithContentsOfFile:\
            [[iTM2PDFKitDocument classBundle] pathForImageResource:NAME]];\
		[I setName:[NSString stringWithFormat:@"iTM2:%@", NAME]];\
	}\
    return I;\
}
@implementation NSImage(iTM2PDFKit)
DEFINE_IMAGE(imageCaution, @"caution");
DEFINE_IMAGE(imageDebugScrollToolbarImage, @"DebugScrollToolbarImage");
DEFINE_IMAGE(imageGrabber, @"Grabber");
DEFINE_IMAGE(imageLandscape, @"Landscape");
DEFINE_IMAGE(imagePortrait, @"Portrait");
DEFINE_IMAGE(imageReverseLandscape, @"ReverseLandscape");
DEFINE_IMAGE(imageTBRotateLeft, @"TBRotateLeft");
DEFINE_IMAGE(imageTBRotateRight, @"TBRotateRight");
DEFINE_IMAGE(imageTBSizeToFit, @"TBSizeToFit");
DEFINE_IMAGE(imageTBSnowflake, @"TBSnowflake");
DEFINE_IMAGE(imageTBZoomActualSize, @"TBZoomActualSize");
DEFINE_IMAGE(imageTBZoomIn, @"TBZoomIn");
DEFINE_IMAGE(imageTBZoomOut, @"TBZoomOut");
DEFINE_IMAGE(imageThumbnailViewAdorn, @"ThumbnailViewAdorn");
DEFINE_IMAGE(imageTOCViewAdorn, @"TOCViewAdorn");
DEFINE_IMAGE(imageBackAdorn, @"BackAdorn");
DEFINE_IMAGE(imageForwardAdorn, @"ForwardAdorn");
DEFINE_IMAGE(imageGenericImageDocument, @"Generic");
DEFINE_IMAGE(imageMoveToolAdorn, @"MoveToolAdorn");
DEFINE_IMAGE(imageTextToolAdorn, @"TextToolAdorn");
DEFINE_IMAGE(imageSelectToolAdorn, @"SelectToolAdorn");
DEFINE_IMAGE(imageAnnotateTool1Adorn, @"AnnotateTool1Adorn");
DEFINE_IMAGE(imageAnnotateTool1AdornDisclosure, @"AnnotateTool1AdornDisclosure");
DEFINE_IMAGE(imageAnnotateTool2Adorn, @"AnnotateTool2Adorn");
DEFINE_IMAGE(imageAnnotateTool2AdornDisclosure, @"AnnotateTool2AdornDisclosure");
@end

@implementation iTM2ShadowedImageCell
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  drawInteriorWithFrame:inView:
- (void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSShadow * shadow = [[[NSShadow alloc] init] autorelease];
   	[NSGraphicsContext saveGraphicsState];
	[shadow setShadowOffset:NSMakeSize(0,-4)];
	[shadow setShadowBlurRadius:10];
	[shadow setShadowColor:[NSColor colorWithCalibratedWhite:0 alpha:0.8]];
	[shadow set];
	[[NSColor whiteColor] set];
	[NSBezierPath fillRect:cellFrame];
	[NSGraphicsContext restoreGraphicsState];
  	[super drawWithFrame:cellFrame inView:controlView];
//iTM2_END;
    return;
}
@end
