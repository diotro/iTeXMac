/*
//  iTM2PDFKit.m
//  iTeXMac2
//
//  @version Subversion:$Id:iTM2PDFKit.m 314 2006-12-06 13:28:32Z jlaurens $ 
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
//  GPL addendum:Any simple modification of the present code which purpose is to remove bug,
//  improve efficiency in both code execution and code reading or writing should be addressed
//  to the actual developper team.
*/

//RAISE  *** Selector 'document' sent to dealloced instance 0x170e06c0 of class PDFPage.
#import <iTM2PDFKit/iTM2PDFKit.h>
#import <iTM2Foundation/iTM2Foundation.h>
#import <objc/objc-class.h>

NSString * const iTM2PDFKitInspectorMode = @"Tiger";
NSString * const iTM2PDFKitToolbarIdentifier = @"iTM2PDFKit For Tiger";
NSString * const iTM2PDFKitDocumentDidChangeNotification = @"iTM2_PDFDocumentDidChangeNotification";

NSString * const iTM2MultiplePDFDocumentType = @"Multiple PDF Document";// beware, this MUST appear in the target file...

NSString * const iTM2PDFKitKey = @"iTM2PDFKit";
NSString * const iTM2PDFKitZoomFactorKey = @"iTM2PDFKitZoomFactor";

@interface iTM2ShadowedImageCell:NSImageCell
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
- (NSMutableArray *)PDFOutlineStack;
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
- (NSAttributedString *)getContextualStringFromSelection:(PDFSelection *)instance;
- (iTM2PDFDocumentStatus)PDFDocumentStatus;
- (void)setPDFDocumentStatus:(iTM2PDFDocumentStatus)status;
@end

@interface iTM2PDFDocument(PRIVATE)
- (PDFDocument *)lazyPDFDocument;
@end

@implementation iTM2PDFDocument(Cluster)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  load
+ (void)load;
/*"Description Forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- 2.0:Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	iTM2_INIT_POOL;
	iTM2RedirectNSLogOutput();
//iTM2_START;
	if(![iTM2RuntimeBrowser swizzleInstanceMethodSelector:@selector(swizzled_iTM2PDFKit_init) replacement:@selector(init) forClass:[self class]])
	{
		iTM2_LOG(@"WARNING:No hook available to init Tiger aware PDF documents...");
	}
//iTM2_END;
	iTM2_RELEASE_POOL;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  swizzled_iTM2PDFKit_init
- (id)swizzled_iTM2PDFKit_init;
/*"Description Forthcoming. Not sure this design is that strong. It need some firther investigation.
Version history:jlaurens AT users DOT sourceforge DOT net
- 2.0:Fri Sep 05 2003
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
Version history:jlaurens AT users DOT sourceforge DOT net
- for 2.0:Mon Jun 02 2003
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
Version history:jlaurens AT users DOT sourceforge DOT net
- 2.0:Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return iTM2PDFGraphicsInspectorType;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inspectorMode
+ (NSString *)inspectorMode;
/*"Description Forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- 2.0:Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return iTM2PDFInspectorMode;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= PDFDocument
- (PDFDocument *)PDFDocument;
/*"Description forthcoming.
Version History:jlaurens AT users DOT sourceforge DOT net
- < 1.1:03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id result = nil;
	if([self PDFDocumentStatus] == iTM2PDFDocumentNoErrorStatus)
	{
		if(result = metaGETTER)
		{
			return result;
		}
	}
	NSString * type = [self fileType];
	NSData * PDFData = [self dataRepresentationOfType:type];
	if(result = [[[iTM2XtdPDFDocument alloc] initWithData:PDFData] autorelease])
	{
		[self setPDFDocument:result];
		[self setPDFDocumentStatus:iTM2PDFDocumentNoErrorStatus];
		[self loadDataRepresentation:nil ofType:type];
	}
	else
	{
		[self setPDFDocumentStatus:iTM2PDFDocumentErrorStatus];
	}
    return metaGETTER;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= setPDFDocument:
- (void)setPDFDocument:(id)PDFDoc;
/*"Description forthcoming.
Version History:jlaurens AT users DOT sourceforge DOT net
- < 1.1:03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(![PDFDoc isEqual:metaGETTER])
    {
        metaSETTER(PDFDoc);
		if(PDFDoc)
		{
			NSEnumerator * E = [[self windowControllers] objectEnumerator];
			id WC = nil;
			while(WC = [E nextObject])
			{
				if([WC respondsToSelector:@selector(setProgressIndicatorIsAnimated:)])
				{
					[WC setProgressIndicatorIsAnimated:NO];
				}
			}
		}
		[self replaceSynchronizer:nil];
		[INC postNotificationName:iTM2PDFKitDocumentDidChangeNotification object:self userInfo:nil];
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  PDFDocumentStatus
- (iTM2PDFDocumentStatus)PDFDocumentStatus;
/*" Description forthcoming.
Version History:jlaurens AT users DOT sourceforge DOT net
- < 1.1:03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSNumber * N = metaGETTER;
//iTM2_END;
	return [N intValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setPDFDocumentStatus:
- (void)setPDFDocumentStatus:(iTM2PDFDocumentStatus)status;
/*" Description forthcoming.
Version History:jlaurens AT users DOT sourceforge DOT net
- < 1.1:03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSNumber * N = [NSNumber numberWithInt:status];
	metaSETTER(N);
	NSEnumerator * E = [[self windowControllers] objectEnumerator];
	id WC = nil;
	while(WC = [E nextObject])
	{
		if([WC respondsToSelector:@selector(setPDFDocumentStatus:)])
		{
			[WC setPDFDocumentStatus:status];
		}
	}
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  dataCompleteReadFromURL:ofType:error:
- (BOOL)dataCompleteReadFromURL:(NSURL *)fileURL ofType:(NSString *)type error:(NSError**)outErrorPtr;
/*" Description forthcoming.
Version History:jlaurens AT users DOT sourceforge DOT net
- < 1.1:03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(outErrorPtr)
		*outErrorPtr = nil;
	NSData * D = [NSData dataWithContentsOfURL:fileURL options:0 error:outErrorPtr];
//iTM2_END;
	if([self loadDataRepresentation:D ofType:type])
	{
		[self setPDFDocumentStatus:iTM2PDFDocumentPendingStatus];
		[self PDFDocument];
		int status = [self PDFDocumentStatus];
		return status != iTM2PDFDocumentErrorStatus && status != iTM2PDFDocumentPendingStatus;
	}
	return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  dataCompleteWriteToURL:ofType:error:
- (BOOL)dataCompleteWriteToURL:(NSURL *)fileURL ofType:(NSString *)type error:(NSError**)outErrorPtr;
/*" Description forthcoming.
Version History:jlaurens AT users DOT sourceforge DOT net
- < 1.1:03/10/2002
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
Version history:jlaurens AT users DOT sourceforge DOT net
- for 2.0:Mon Jun 02 2003
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
	NSDictionary * d = nil;
	id document = nil;
	id synchronizer = [self synchronizer];
	if([synchronizer isSyncTeX])
	{
		hint = [[hint mutableCopy] autorelease];
		[(id)hint setObject:[NSNumber numberWithBool:YES] forKey:@"SyncTeX"];
	}
    if([synchronizer getLine:&line column:&column sourceBefore:&sourceBefore sourceAfter:&sourceAfter forLocation:thePoint withHint:hint inPageAtIndex:thePage])
	{
		if([sourceBefore length]
			&& [[SDC documentClassForType:[SDC typeFromFileExtension:[sourceBefore pathExtension]]] isSubclassOfClass:[iTM2TextDocument class]])
		{
			url = [NSURL fileURLWithPath:sourceBefore];
			document = [SDC openDocumentWithContentsOfURL:url display:NO error:nil];
			[document getLine:&line column:&column length:&length forHint:hint];
			d = [NSDictionary dictionaryWithObjectsAndKeys:
				url,@"current source URL",
				[NSNumber numberWithInt:line],@"line",
				[NSNumber numberWithInt:column],@"column",
				[NSNumber numberWithInt:length],@"length",
					nil];
			[[self implementation] takeMetaValue:d forKey:@"current source synchronization location"];
			if([document displayLine:line column:column length:length withHint:hint orderFront:yorn])
				return;
			[[self implementation] takeMetaValue:nil forKey:@"current source synchronization location"];
		}
		if([sourceAfter length]
			&& [[SDC documentClassForType:[SDC typeFromFileExtension:[sourceAfter pathExtension]]] isSubclassOfClass:[iTM2TextDocument class]])
		{
			document = [SDC openDocumentWithContentsOfURL:[NSURL fileURLWithPath:sourceAfter] display:NO error:nil];
			[document getLine:&line column:&column length:&length forHint:hint];
			d = [NSDictionary dictionaryWithObjectsAndKeys:
				url,@"current source URL",
				[NSNumber numberWithInt:line],@"line",
				[NSNumber numberWithInt:column],@"column",
				[NSNumber numberWithInt:length],@"length",
					nil];
			[[self implementation] takeMetaValue:d forKey:@"current source synchronization location"];
			if([document displayLine:line column:column length:length withHint:hint orderFront:yorn])
				return;
			[[self implementation] takeMetaValue:nil forKey:@"current source synchronization location"];
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
				isSubclassOfClass:[iTM2TextDocument class]])
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
	url = [NSURL fileURLWithPath:path];
	matchDocument = [SDC openDocumentWithContentsOfURL:url display:NO error:nil];
	if([matchDocument isKindOfClass:[iTM2TextDocument class]])
	{
		unsigned int testLine = 0, testColumn = -1, testLength = 1;// THESE MUST BE INITIALIZED THAT WAY
		[matchDocument getLine:&testLine column:&testColumn length:&testLength forHint:hint];
		d = [NSDictionary dictionaryWithObjectsAndKeys:
			url,@"current source URL",
			[NSNumber numberWithInt:line],@"line",
			[NSNumber numberWithInt:column],@"column",
			[NSNumber numberWithInt:length],@"length",
				nil];
		[[self implementation] takeMetaValue:d forKey:@"current source synchronization location"];
		if([matchDocument displayLine:line column:column length:length withHint:hint orderFront:yorn])
			return;
		[[self implementation] takeMetaValue:nil forKey:@"current source synchronization location"];
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= autosavingFileType
- (NSString *)autosavingFileType;
/*"No autosave.
Version history:jlaurens AT users DOT sourceforge DOT net
- 2.0:Tue Jan 18 22:21:11 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return nil;
}
@end

@implementation iTM2MultiplePDFKitDocument
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  dataCompleteReadFromFile:ofType:
- (BOOL)dataCompleteReadFromFile:(NSString *)fileName ofType:(NSString *)type;
/*" Description forthcoming.
Version History:jlaurens AT users DOT sourceforge DOT net
- < 1.1:03/10/2002
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
Version History:jlaurens AT users DOT sourceforge DOT net
- < 1.1:03/10/2002
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
Version history:jlaurens AT users DOT sourceforge DOT net
- 2.0:Fri Sep 05 2003
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
Version History:jlaurens AT users DOT sourceforge DOT net
- < 1.1:03/10/2002
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
		NSString * directoryName = [URL isFileURL]? [URL path]:@"";
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
					iTM2_LOG(@"Refused file:%@",fullPath);
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
						iTM2_LOG(@"Refused file:%@",fullPath);
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
//iTM2_LOG(@"fullPath is :%@", fullPath);
				PDFDocument * doc = [[PDFDocument allocWithZone:[self zone]] initWithURL:[NSURL fileURLWithPath:fullPath]];
				if([doc pageCount])
				{
					[MRA addObject:component];
					PDFPage * P = [[doc pageAtIndex:0] retain];
					[doc removePageAtIndex:0];
//iTM2_LOG(@"[P document] is:%@", [P document]);
					[self insertPage:P atIndex:[self pageCount]];
					[P release];
//iTM2_LOG(@"[P document] is:%@", [P document]);
//iTM2_LOG(@"[self pageCount] is now:%i", [self pageCount]);
//iTM2_LOG(@"[self dataRepresentation] is now:%@", [self dataRepresentation]);
				}
				else
				{
					iTM2_LOG(@"Void pdf document at:%@", fullPath);
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
Version history:jlaurens AT users DOT sourceforge DOT net
- 2.0:Fri Sep 05 2003
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
			(leftInteger<rightInteger? NSOrderedAscending:NSOrderedSame);
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
- (void)flagsChanged:(NSEvent *)theEvent;
{
	[self resetCursorRects];
	[super flagsChanged:theEvent];
	return;
}
- (void)resetCursorRects;
{
	[super resetCursorRects];
	NSArray * subviews = [[self contentView] subviewsWhichClassInheritsFromClass:[PDFView class]];
	NSEnumerator * E = [subviews objectEnumerator];
	PDFView * subview;
	id FR = [self firstResponder];
	FR = [FR isKindOfClass:[NSView class]]?FR:nil;
	while(subview = [E nextObject])
	{
		if([FR isDescendantOf:subview])
		{
			[subview resetCursorRects];
		}
	}
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= defaultMacroDomain
- (NSString *)defaultMacroDomain;
{
    return @"View";
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= defaultMacroCategory
- (NSString *)defaultMacroCategory;
{
    return @"PDF";
}
@end

@implementation iTM2PDFKitInspector
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inspectorType
+ (NSString *)inspectorType;
/*"Description Forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- 2.0:Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return iTM2PDFGraphicsInspectorType;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inspectorMode
+ (NSString *)inspectorMode;
/*"Description Forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- 2.0:Fri Sep 05 2003
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
Version history:jlaurens AT users DOT sourceforge DOT net
- 2.0:Fri May 21 07:52:07 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  PDFDocumentDidChangeNotified:
- (void)PDFDocumentDidChangeNotified:(NSNotification *)notification;
/*"Description Forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- 2.0:Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	// reentrant code management
	NSString * name = [notification name];
	[INC removeObserver:self name:name object:nil];
	id document = [self document];
	if([notification object] == document)
	{
		[self setPDFOutlines:nil];
		[[self PDFThumbnails] setArray:[NSArray array]];
		[[self PDFSearchResults] setArray:[NSArray array]];
		[_thumbnailTable reloadData];
		[_outlinesView reloadData];
		[_searchTable reloadData];
		PDFView * pdfView = [self pdfView];
		PDFDocument * doc = [pdfView document];
		if(doc)
		{
			// store the geometry:
			[self setScaleFactor:[pdfView scaleFactor]];
			PDFPage * page = [pdfView currentPage];
			[self setDocumentViewVisiblePageNumber:[doc indexForPage:page]];
			[doc setDelegate:nil];
			NSView * documentView = [pdfView documentView];
			NSRect visibleRect = [documentView visibleRect];
			visibleRect = [documentView absoluteRectWithRect:visibleRect];
			[self setDocumentViewVisibleRect:visibleRect];
		}
		[doc setDelegate:nil];
		doc = [document PDFDocument];
		[pdfView setDocument:doc];
//		[[self pdfView] setNeedsDisplay:YES];
//iTM2_LOG(@"UPDATE:%@",NSStringFromRect([self documentViewVisibleRect]));
		[doc setDelegate:self];
		if([_drawer state] == NSDrawerOpenState)
			[self updateTabView];
		[self contextDidChange];
	}
	[INC addObserver:self selector:_cmd name:name object:nil];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  album
- (id)album;
/*"Description Forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- 2.0:Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [self pdfView];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  pdfView
- (PDFView *)pdfView;
/*"Description Forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- 2.0:Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return _pdfView;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  _pdfCompleteWindowDidLoad:
- (void)_pdfCompleteWindowDidLoad;
/*"Description Forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- 2.0:Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_LOG(@"Setting up the pdf inspector:0");
	NSAssert(_pdfTabView, @"Missing _pdfTabView connection...");
	NSAssert(_tabViewControl, @"Missing _tabViewControl connection...");
	[DNC addObserver:self selector:@selector(PDFViewPageChangedNotified:)  name:PDFViewPageChangedNotification  object:[self pdfView]];
	[DNC addObserver:self selector:@selector(PDFViewScaleChangedNotified:) name:PDFViewScaleChangedNotification object:[self pdfView]];
//iTM2_LOG(@"Setting up the pdf inspector:1");
	// outlines
	[self setPDFOutlines:nil];
	[_outlinesView setTarget:self];
	[_outlinesView setAction:@selector(takeDestinationFromSelectedItemRepresentedObject:)];
	[_tabViewControl setEnabled:([[self PDFOutlines] countOfChildren]>0) forSegment:1];
//iTM2_LOG(@"Setting up the pdf inspector:2");
	// thumbnails
	[[self PDFThumbnails] setArray:[NSArray array]];
	// search
	[_searchCountText setStringValue:@""];
	// doc
	[[self pdfView] setDelegate:self];
	PDFDocument * doc = [[self document] PDFDocument];
	[doc setDelegate:self];
	[[self pdfView] setDocument:doc];// last thing to do
//iTM2_LOG(@"The document has been properly connected to the view:\n%@ <-> %@",doc,[self pdfView]);
	[INC addObserver:self
		selector:@selector(PDFDocumentDidChangeNotified:)
			name:iTM2PDFKitDocumentDidChangeNotification
				object:nil];
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
	[self contextDidChange];
//iTM2_LOG(@"Setting up the pdf inspector:DONE");
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  PDFDocumentStatus
- (iTM2PDFDocumentStatus)PDFDocumentStatus;
/*" Description forthcoming.
Version History:jlaurens AT users DOT sourceforge DOT net
- < 1.1:03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSNumber * N = metaGETTER;
//iTM2_END;
	return [N intValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setPDFDocumentStatus:
- (void)setPDFDocumentStatus:(iTM2PDFDocumentStatus)status;
/*" Description forthcoming.
Version History:jlaurens AT users DOT sourceforge DOT net
- < 1.1:03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSNumber * N = [NSNumber numberWithInt:status];
	metaSETTER(N);
	switch(status)
	{
		case iTM2PDFDocumentNoErrorStatus:
		case iTM2PDFDocumentErrorStatus:
			[self setProgressIndicatorIsAnimated:NO];
			break;
		case iTM2PDFDocumentPendingStatus:
			[self setProgressIndicatorIsAnimated:YES];
			break;
	}
//iTM2_END;
	return;
}
#pragma mark =-=-=-=-=-  PROGRESS INDICATOR
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  progressIndicatorIsAnimated
- (BOOL)progressIndicatorIsAnimated;
/*"Description Forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- 2.0:Fri Sep 05 2003
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
Version history:jlaurens AT users DOT sourceforge DOT net
- 2.0:Fri Sep 05 2003
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
Version history:jlaurens AT users DOT sourceforge DOT net
- 2.0:Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	PDFDocument * doc = [[self pdfView] document];
    if ([doc isFinding])
		[doc cancelFindString];
	[_pdfTabView selectTabViewItemWithIdentifier:([sender selectedSegment]? @"2":@"1")];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  tabView:didSelectTabViewItem:
- (void)tabView:(NSTabView *)tabView didSelectTabViewItem:(NSTabViewItem *)tabViewItem;
/*"Description Forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- 2.0:Fri Sep 05 2003
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
Version history:jlaurens AT users DOT sourceforge DOT net
- 2.0:Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[_drawer toggle:sender];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  drawerWillResizeContents:toSize:
- (NSSize)drawerWillResizeContents:(NSDrawer *)sender toSize:(NSSize)contentSize;
/*"Description forthcoming.
Version History:jlaurens AT users DOT sourceforge DOT net
- 1.4:Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * string = NSStringFromSize(contentSize);
	NSDictionary * D = [self contextValueForKey:iTM2PDFKitKey domain:iTM2ContextAllDomainsMask];
	if([D isKindOfClass:[NSDictionary class]])
	{
		D = [[D mutableCopy] autorelease];
	}
	else
	{
		D = [NSMutableDictionary dictionary];
	}
	string = NSStringFromSize(contentSize);
	[(NSMutableDictionary *)D takeValue:string forKey:@"Drawer Size"];
	[self takeContextValue:D forKey:iTM2PDFKitKey domain:iTM2ContextAllDomainsMask];
//iTM2_END;
	return contentSize;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  drawerWillOpen:
- (void)drawerWillOpen:(NSNotification *) notification;
/*"Description forthcoming.
Version History:jlaurens AT users DOT sourceforge DOT net
- 1.4:Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSDrawer * drawer = [notification object];
    [drawer validateContent];
	NSSize contentSize = [drawer contentSize];
	NSDictionary * D = [self contextValueForKey:iTM2PDFKitKey domain:iTM2ContextAllDomainsMask];
	NSString * string;
	if([D isKindOfClass:[NSDictionary class]])
	{
		string = [[self contextValueForKey:iTM2PDFKitKey domain:iTM2ContextAllDomainsMask] valueForKey:@"Drawer Size"];
		if([string isKindOfClass:[NSString class]])
		{
			NSRectEdge edge = [drawer preferredEdge];
			NSSize maxContentSize = [drawer maxContentSize];
			NSSize minContentSize = [drawer minContentSize];
			NSSize defaultsSize = NSSizeFromString(string);
			if((edge == NSMinXEdge) || (edge == NSMaxXEdge))
			{
				contentSize.width = MAX(minContentSize.width,defaultsSize.width);
				contentSize.width = MIN(maxContentSize.width,contentSize.width);
			}
			else
			{
				contentSize.height = MAX(minContentSize.height,defaultsSize.height);
				contentSize.height = MIN(maxContentSize.height,contentSize.height);
			}
			[drawer setContentSize:contentSize];
		}
		D = [[D mutableCopy] autorelease];
	}
	else
	{
		D = [NSMutableDictionary dictionary];
	}
	string = NSStringFromSize(contentSize);
	[(NSMutableDictionary *)D takeValue:string forKey:@"Drawer Size"];
	[self takeContextValue:D forKey:iTM2PDFKitKey domain:iTM2ContextAllDomainsMask];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  drawerDidOpen:
- (void)drawerDidOpen:(NSNotification *)notification;
/*"Description Forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- 2.0:Fri Sep 05 2003
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
Version history:jlaurens AT users DOT sourceforge DOT net
- 2.0:Fri Sep 05 2003
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
Version history:jlaurens AT users DOT sourceforge DOT net
- 2.0:Fri Sep 05 2003
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
Version history:jlaurens AT users DOT sourceforge DOT net
- 2.0:Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(![[self PDFThumbnails] count])
	{
		unsigned index = [[[self pdfView] document] pageCount];
		while(index--)
			[[self PDFThumbnails] addObject:[NSImage iTM2_imageGenericImageDocument]];
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
Version history:jlaurens AT users DOT sourceforge DOT net
- 2.0:Fri Sep 05 2003
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
Version history:jlaurens AT users DOT sourceforge DOT net
- 2.0:Fri Sep 05 2003
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
					NSNumber * N = nil;
					while(N = [e nextObject])
					{
						unsigned int pageIndex = [N unsignedIntValue];
						PDFView * pdfView = nil;
						object_getInstanceVariable(inspector, "[self pdfView]", (void **)&pdfView);
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  PDFOutlineStack
- (NSMutableArray *)PDFOutlineStack;
/*"Description Forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- 2.0:Fri Sep 05 2003
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  PDFSearchResults
- (NSMutableArray *)PDFSearchResults;
/*"Description Forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- 2.0:Fri Sep 05 2003
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
Version history:jlaurens AT users DOT sourceforge DOT net
- 2.0:Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	unsigned int index = [_tabViewControl segmentCount];
	while(index--)
		[_tabViewControl setSelected:NO forSegment:index];
	[_pdfTabView selectTabViewItemWithIdentifier:@""];
	PDFDocument * doc = [[self pdfView] document];
    if ([doc isFinding])
		[doc cancelFindString];
	[[self PDFOutlineStack] setArray:[NSArray array]];
	[[self PDFSearchResults] setArray:[NSArray array]];
	[[self implementation] takeMetaValue:[NSDate dateWithTimeIntervalSinceNow:0.0] forKey:@"_searchTime"];
    [_searchTable reloadData];
	[doc setDelegate:self];
    [doc beginFindString:[sender stringValue] withOptions:NSCaseInsensitiveSearch];
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  didMatchString:
- (void)didMatchString:(PDFSelection *)selection
/*"Description Forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- 2.0:Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	selection = [[selection copy] autorelease];
	[[self PDFSearchResults] addObject:selection];
	NSArray * selectionPages = [selection pages];
	if(![selectionPages count])
	{
		return;
	}
	PDFPage * page = [selectionPages objectAtIndex:0];
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
		[MAS appendAttributedString:[[[NSMutableAttributedString allocWithZone:[self zone]] initWithString:[NSString stringWithFormat:@" [%i]", physicalPageIndex] attributes:[NSDictionary dictionaryWithObject:[NSColor disabledControlTextColor] forKey:NSForegroundColorAttributeName]] autorelease]];
		[[self PDFSearchResults] addObject:[[MAS copy] autorelease]];
	}
	PDFOutline * outline = [[page document] outlineItemForSelection:selection];
	if(outline)
	{
		label = [outline label];// cache?
		if([label isEqual:[[self PDFOutlineStack] lastObject]])
		{
			[[self PDFSearchResults] addObject:[self getContextualStringFromSelection:selection]];
		}
		else
		{
			[[self PDFOutlineStack] addObject:[[label copy] autorelease]];
			[[self PDFSearchResults] addObject:[[self PDFOutlineStack] lastObject]];
		}
	}
	else
	{
		[[self PDFSearchResults] addObject:[self getContextualStringFromSelection:selection]];
	}
	unsigned int count = [[self PDFSearchResults] count]/3;
	[_searchCountText setStringValue:[NSString stringWithFormat:
		NSLocalizedStringFromTableInBundle(@"Found %i match(es)", iTM2PDFKitKey, [self classBundle], ""),count]];
	NSDate * _searchTime = [[self implementation] metaValueForKey:@"_searchTime"];
	NSDate * newTime = [NSDate date];
	if (([newTime timeIntervalSinceDate:_searchTime] > 1.0) || (count == 1))
	{
		// Force a reload.
		[_searchTable reloadData];
		
		[[self implementation] takeMetaValue:newTime forKey:@"_searchTime"];
		
		// Handle found first search result.
		if (count == 1)
		{
			// Select first item (search result) in table view.
			[_searchTable selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
		}
	}
//iTM2_END;
	return;
}
// ------------------------------------------------------------------------------------------------------------ startFind

- (void) documentDidBeginDocumentFind:(NSNotification *) notification;
{
	// Empty arrays.
	[[self PDFSearchResults] removeAllObjects];
	
	// Clear search results table.
	[_searchTable reloadData];
	
	// Note start time.
	[[self implementation] takeMetaValue:[NSDate dateWithTimeIntervalSinceNow:0.0] forKey:@"_searchTime"];
	[_searchCountText setStringValue:@""];
	[_searchProgress startAnimation:self];
}

// copyright PDFKitLinker2
- (void) documentDidEndDocumentFind:(NSNotification *) notification;
{
	// Force a reload.
	[_searchProgress stopAnimation:self];
	[[self implementation] takeMetaValue:nil forKey:@"_searchTime"];
	[[self PDFOutlineStack] setArray:[NSArray array]];
	[_searchTable reloadData];
	return;
}
// ------------------------------------------------------------------------------------- getContextualStringFromSelection
- (NSAttributedString *) getContextualStringFromSelection:(PDFSelection *) instance
{
	NSMutableAttributedString	*attributedSample;
	NSString					*searchString;
	NSMutableString				*sample;
	NSString					*rawSample;
	unsigned int				count;
	unsigned int				i;
	unichar						ellipse = 0x2026;
	NSRange						searchRange;
	NSRange						foundRange;
	NSMutableParagraphStyle		*paragraphStyle = NULL;
	
	// Get search string.
	searchString = [instance string];
	#define PREFIX_LENGTH 16
	#define POSTFIX_LENGTH 64
	// Extend selection.
	[instance extendSelectionAtStart:PREFIX_LENGTH];
	[instance extendSelectionAtEnd:POSTFIX_LENGTH];
	
	// Get string from sample.
	rawSample = [instance string];
	count = [rawSample length];
	
	// String to hold non-<CR> characters from rawSample.
	sample = [NSMutableString stringWithCapacity:count + PREFIX_LENGTH + POSTFIX_LENGTH];
	[sample setString:[NSString stringWithCharacters:&ellipse length:1]];
	
	// Keep all characters except <LF>.
	for (i = 0; i < count; i++)
	{
		unichar		oneChar;
		
		oneChar = [rawSample characterAtIndex:i];
		if (oneChar == 0x000A)
			[sample appendString:@" "];
		else
			[sample appendString:[NSString stringWithCharacters:&oneChar length:1]];
	}
	
	// Follow with elipses.
	[sample appendString:[NSString stringWithCharacters:&ellipse length:1]];
	
	// Finally, create attributed string.
 	attributedSample = [[NSMutableAttributedString alloc] initWithString:sample];
	
	// Find instances of search string and "bold" them.
	searchRange.location = 0;
	searchRange.length = [sample length];
	do
	{
		// Search for the string.
		foundRange = [sample rangeOfString:searchString options:NSCaseInsensitiveSearch range:searchRange];
		
		// Did we find it?
		if (foundRange.location != NSNotFound)
		{
			// Bold the text range where the search term was found.
			[attributedSample setAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[NSFont boldSystemFontOfSize:
					[NSFont systemFontSize]], NSFontAttributeName, NULL] range:foundRange];
			
			// Advance the search range.
			searchRange.location = foundRange.location + foundRange.length;
			searchRange.length = [sample length] - searchRange.location;
		}
	}
	while (foundRange.location != NSNotFound);
	
	// Create paragraph style that indicates truncation style.
	paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
	[paragraphStyle setLineBreakMode:NSLineBreakByTruncatingTail];
	
	// Add paragraph style.
    [attributedSample addAttributes:[[NSMutableDictionary alloc] initWithObjectsAndKeys:
			paragraphStyle, NSParagraphStyleAttributeName, NULL] range:NSMakeRange(0, [attributedSample length])];
	
	// Clean.
	[paragraphStyle release];
	
	return attributedSample;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  numberOfRowsInTableView:
- (int)numberOfRowsInTableView:(NSTableView *)aTableView
/*"Description Forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- 2.0:Fri Sep 05 2003
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
Version history:jlaurens AT users DOT sourceforge DOT net
- 2.0:Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	if ([[theColumn identifier] isEqualToString:@"text"])
	{
		return [[self PDFSearchResults] objectAtIndex:3*rowIndex+2];
	}
	else if ([[theColumn identifier] isEqualToString:@"thumbnail"])
	{
		NSImage * I = [[self PDFThumbnails] objectAtIndex:rowIndex];
		if([I isEqual:[NSImage iTM2_imageGenericImageDocument]])
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
			PDFDocument * doc = [[self pdfView] document];
			if(rowIndex>=[doc pageCount])
			{
				return nil;
			}
			PDFPage * page = [doc pageAtIndex:rowIndex];
			NSString * label = [page label];
			unsigned int logicalPageIndex = [label intValue];
			if(physicalPageIndex == logicalPageIndex)
			{
				return label;
			}
			NSMutableAttributedString * MAS = [[[NSMutableAttributedString allocWithZone:[self zone]] initWithString:label] autorelease];
			[MAS appendAttributedString:[[[NSMutableAttributedString allocWithZone:[self zone]] initWithString:[NSString stringWithFormat:@" [%i]", physicalPageIndex] attributes:[NSDictionary dictionaryWithObject:[NSColor disabledControlTextColor] forKey:NSForegroundColorAttributeName]] autorelease]];
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
Version history:jlaurens AT users DOT sourceforge DOT net
- 2.0:Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	NSTableView * TV = (NSTableView *)[notification object];
    int rowIndex = [TV selectedRow];
    if (rowIndex >= 0)
    {
		PDFView * V = [self pdfView];
		if(TV == _searchTable)
		{
			NSArray * results = [self PDFSearchResults];
			rowIndex *= 3;
			if(rowIndex < [results count])
			{
				PDFSelection * S = [results objectAtIndex:3*rowIndex];
				[V setCurrentSelection:S];
				[V scrollSelectionToVisible:self];
			}
		}
		else if(TV == _thumbnailTable)
		{
			PDFDocument * D = [V document];
			PDFPage * page = [D pageAtIndex:rowIndex];
			[V goToPage:page];
		}
    }
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  updateSearchTable
- (void)updateSearchTable;
/*"Description Forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- 2.0:Fri Sep 05 2003
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
Version history:jlaurens AT users DOT sourceforge DOT net
- 2.0:Fri Sep 05 2003
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
Version history:jlaurens AT users DOT sourceforge DOT net
- 2.0:Fri Sep 05 2003
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
Version history:jlaurens AT users DOT sourceforge DOT net
- 2.0:Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [[(item? :[self PDFOutlines]) representedObject] numberOfChildren];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  outlineView:child:ofItem:
- (id)outlineView:(NSOutlineView *)outlineView child:(int)index ofItem:(id)item;
/*"Description Forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- 2.0:Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	iTM2TreeNode * node = item? :[self PDFOutlines];
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
Version history:jlaurens AT users DOT sourceforge DOT net
- 2.0:Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [self outlineView:(NSOutlineView *) outlineView numberOfChildrenOfItem:(id) item] > 0;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  outlineView:objectValueForTableColumn:byItem:
- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item;
/*"Description Forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- 2.0:Fri Sep 05 2003
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
Version history:jlaurens AT users DOT sourceforge DOT net
- 2.0:Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [[self pdfView] goToDestination:[[[sender itemAtRow:[sender selectedRow]] representedObject] destination]];
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  updatePDFOutlineInformation
- (void)updatePDFOutlineInformation;
/*"Description Forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- 2.0:Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	PDFView * V = [self pdfView];
	PDFDocument * doc = [V document];
    if (![doc outlineRoot])
        return;
	PDFPage * P = [V currentPage];
    unsigned int newPageIndex = [doc indexForPage:P];
	int row = [_outlinesView numberOfRows];
    while (row--)
    {
		id O = [_outlinesView itemAtRow:row];
		PDFOutline * OL = [O representedObject];
		PDFDestination * Dest = [OL destination];
		P = [Dest page];
        if ([doc indexForPage:P] <= newPageIndex)
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
Version history:jlaurens AT users DOT sourceforge DOT net
- 2.0:Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(![self PDFOutlines])
	{
		PDFOutline * OLR = [[[self pdfView] document] outlineRoot];
		[self setPDFOutlines:[[[iTM2TreeNode allocWithZone:[self zone]] initWithParent:nil value:OLR] autorelease]];
		[[self PDFOutlines] setCountOfChildren:[OLR numberOfChildren]];
		[_tabViewControl setEnabled:([[self PDFOutlines] countOfChildren]>0) forSegment:1];
	}
	[_outlinesView reloadData];
//iTM2_END;
    return;
}
#pragma mark =-=-=-=-=-  PDFView
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  PDFViewPageChangedNotified:
- (void)PDFViewPageChangedNotified:(NSNotification *)notification;
/*"Description Forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- 2.0:Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[[[self window] toolbar] validateVisibleItems];
	PDFView * pdfView = [self pdfView];
	PDFPage * page = [pdfView currentPage];
	unsigned int oldPageIndex = [self documentViewVisiblePageNumber];
	unsigned int newPageIndex = [[page document] indexForPage:page];
//iTM2_LOG(@"oldPageIndex:%u,newPageIndex:%u",oldPageIndex,newPageIndex);
	if(oldPageIndex!=newPageIndex)
	{
		[self setDocumentViewVisiblePageNumber:newPageIndex];
		NSView * documentView = [pdfView documentView];
		NSRect oldRect = [self documentViewVisibleRect];
		NSRect newRect = [documentView visibleRect];
		newRect = [documentView absoluteRectWithRect:newRect];
		if(NSEqualRects(oldRect,newRect))
		{
			newRect = NSMakeRect(0,0,1,1);// the whole view, this is necessary because the notification is posted before the new page is shown
		}
		[self setDocumentViewVisibleRect:newRect];
		[self updatePDFOutlineInformation];
		[self contextDidChangeComplete];
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  PDFViewScaleChangedNotified:
- (void)PDFViewScaleChangedNotified:(NSNotification *)notification;
/*"Description Forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- 2.0:Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	PDFView * V = [notification object];
	[self setScaleFactor:[V scaleFactor]];
	[self setAutoScales:[V autoScales]];
	[[[self window] toolbar] validateVisibleItems];
	[self validateWindowContent];
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

- (IBAction)setCircleAnnotation:(id)sender;
- (IBAction)setFreeTextAnnotation:(id)sender;
- (IBAction)softProofToggle:(id)sender;
#endif
#pragma mark =-=-=-=-=-  TOOL MODE
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toolMode
- (iTM2ToolMode)toolMode;
{
	return [[self pdfView] toolMode];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setToolMode:
- (void)setToolMode:(iTM2ToolMode)argument;
{
	[[self pdfView] setToolMode:argument];
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  scrollTool:
- (IBAction)scrollTool:(id)sender;
{
	[[self pdfView] setToolMode:kiTM2ScrollToolMode];
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  textTool:
- (IBAction)textTool:(id)sender;
{
	[[self pdfView] setToolMode:kiTM2TextToolMode];
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  selectTool:
- (IBAction)selectTool:(id)sender;
{
	[[self pdfView] setToolMode:kiTM2SelectToolMode];
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  annotateTool:
- (IBAction)annotateTool:(id)sender;
{
	[[self pdfView] setToolMode:kiTM2AnnotateToolMode];
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateScrollTool:
- (BOOL)validateScrollTool:(id)sender;
{
	[sender setState:([self toolMode] == kiTM2ScrollToolMode)];
	return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateTextTool:
- (BOOL)validateTextTool:(id)sender;
{
	[sender setState:([self toolMode] == kiTM2TextToolMode)];
	return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateSelectTool:
- (BOOL)validateSelectTool:(id)sender;
{
	[sender setState:([self toolMode] == kiTM2SelectToolMode)];
	return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateAnnotateTool:
- (BOOL)validateAnnotateTool:(id)sender;
{
	[sender setState:([self toolMode] == kiTM2AnnotateToolMode)];
	return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  canSynchronizeOutput
- (BOOL)canSynchronizeOutput;
/*"Description Forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- 2.0:Fri Sep 05 2003
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
Version History:jlaurens AT users DOT sourceforge DOT net
- < 1.1:03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//NSLog
//NSLog(@"dpn");
    [[self pdfView] takeCurrentPhysicalPage:page synchronizationPoint:P withHint:hint];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= synchronizeWithDestinations:hint:
- (BOOL)synchronizeWithDestinations:(NSDictionary *)destinations hint:(NSDictionary *)hint;
/*"Description Forthcoming. The first responder must never be the window but at least its content view unless we want to neutralize the iTM2FlagsChangedResponder.
Version History:jlaurens AT users DOT sourceforge DOT net
- < 1.1:03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//NSLog
//NSLog(@"dpn");
    return [[self album] synchronizeWithDestinations:destinations hint:hint];
}
#pragma mark =-=-=-=-=-  MODEL
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  prepareViewCompleteSaveContext:
- (void)prepareViewCompleteSaveContext:(id)sender;
/*"Description Forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- 2.0:Tue May  3 16:20:26 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_LOG(@"[self contextDictionary] is:%@", [self contextDictionary]);
	NSView * documentView = [[self pdfView] documentView];
	NSRect visibleRect = [documentView visibleRect];
	visibleRect = [documentView absoluteRectWithRect:visibleRect];
	[self setDocumentViewVisibleRect:visibleRect];
	[self setBackgroundColor:[[self pdfView] backgroundColor]];
//iTM2_START;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  contextDidChange
- (void)contextDidChange;
/*"This message is sent each time the contextManager have changed.
The receiver will take appropriate actions to synchronize its state with its contextManager.
Subclasses will most certainly override this method because the default implementation does nothing.
Version history:jlaurens AT users DOT sourceforge DOT net
- 2.0:03/26/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[super contextDidChange];
	PDFView * V = [self pdfView];
	[V setBackgroundColor:[self backgroundColor]];
#if 0
//iTM2_LOG(@"[V backgroundColor]:%@", [V backgroundColor]);
	[V setDisplayMode:[self displayMode]];
//iTM2_LOG(@"[V backgroundColor]:%@", [V backgroundColor]);
	[V setDisplaysPageBreaks:[self displaysPageBreaks]];
//iTM2_LOG(@"[V displaysPageBreaks]:%@", ([V displaysPageBreaks]? @"Y":@"N"));
	[V setDisplayBox:[self displayBox]];
	[V setDisplaysAsBook:[self displaysAsBook]];
//iTM2_LOG(@"[V displaysAsBook]:%@", ([V displaysAsBook]? @"Y":@"N"));
	[V setShouldAntiAlias:[self shouldAntiAlias]];
//iTM2_LOG(@"[V shouldAntiAlias]:%@", ([V shouldAntiAlias]? @"Y":@"N"));
	[V setGreekingThreshold:[self greekingThreshold]];
	[V setScaleFactor:[self scaleFactor]];
	[V setAutoScales:[self autoScales]];// after the scale factor is set
//iTM2_LOG(@"[V autoScales]:%@", ([V autoScales]? @"Y":@"N"));
#endif
	[V setNeedsDisplay:YES];
	NSView * docView = [V documentView];
	if(docView)
	{
		unsigned int pageIndex = [self documentViewVisiblePageNumber];
		PDFDocument * doc = [V document];
		if(pageIndex < [doc pageCount])
		{
			[V goToPage:[doc pageAtIndex:pageIndex]];
			[[self window] disableFlushWindow];
			NSRect visibleRect = [self documentViewVisibleRect];
			visibleRect = [docView rectWithAbsoluteRect:visibleRect];
//iTM2_LOG(@"pageIndex:%u,visibleRect:%@",pageIndex,NSStringFromRect(visibleRect));
			[docView scrollRectToVisible:visibleRect];
			[V display];
			[[self window] enableFlushWindow];
			[NSTimer scheduledTimerWithTimeInterval:0 target:self selector:@selector(timedSynchronizeDocumentView:) userInfo:[NSValue valueWithRect:visibleRect] repeats:NO];
		}
	}
	else
	{
		iTM2_LOG(@"NO VIEW...");
	}
	[self contextDidChangeComplete];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  timedSynchronizeDocumentView:
- (void)timedSynchronizeDocumentView:(NSTimer *)timer;
{
//iTM2_START;
	NSValue * value = [timer userInfo];
	if(!value)
	{
		return;
	}
	PDFView * V = [self pdfView];
	NSWindow * window = [self window];
	[window disableFlushWindow];
	NSRect R = [value rectValue];
	[[V documentView] scrollRectToVisible:R];
	[V display];
	[window enableFlushWindow];
//iTM2_END;
	return;
}
#pragma mark =-=-=-=-=-  DISABLED SYNCTEX
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  disabledSyncTeX
- (BOOL)disabledSyncTeX;
/*" Description forthcoming.
Version History:jlaurens AT users DOT sourceforge DOT net
- 2.1: Wed Jun 18 19:54:25 UTC 2008
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
 	iTM2TeXProjectDocument * TPD = (iTM2TeXProjectDocument *)[SPC projectForSource:self];
	NSDictionary * D = [[[TPD environmentForEngineMode:iTM2ProjectDefaultsKey] mutableCopy] autorelease];
	id value = [D objectForKey:@"SyncTeXDisabled"];
	if(value)
	{
		return [value boolValue];
	}
	// from the SUD
	D = [self contextDictionaryForKey:@"iTM2PDFKitSync" domain:iTM2ContextAllDomainsMask];
	value = [D objectForKey:@"SyncTeXDisabled"];
    return [value boolValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setDisabledSyncTeX:
- (void)setDisabledSyncTeX:(BOOL)yorn;
/*" Description forthcoming.
Version History:jlaurens AT users DOT sourceforge DOT net
- 2.1: Wed Jun 18 19:54:25 UTC 2008
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
 	iTM2TeXProjectDocument * TPD = (iTM2TeXProjectDocument *)[SPC projectForSource:self];
	NSMutableDictionary * D = [[[TPD environmentForEngineMode:iTM2ProjectDefaultsKey] mutableCopy] autorelease];
	if(!D)
	{
		D = [NSMutableDictionary dictionary];
	}
	if(yorn)
	{
		[D setObject:[NSNumber numberWithBool:yorn] forKey:@"SyncTeXDisabled"];
	}
	else
	{
		[D removeObjectForKey:@"SyncTeXDisabled"];
	}
	[TPD takeEnvironment:D forEngineMode:iTM2ProjectDefaultsKey];
//iTM2_END;
	return;
}
#pragma mark =-=-=-=-=-  UNCOMPRESSED SYNCTEX
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  uncompressedSyncTeX
- (BOOL)uncompressedSyncTeX;
{iTM2_DIAGNOSTIC;
//iTM2_START;
 	iTM2TeXProjectDocument * TPD = (iTM2TeXProjectDocument *)[SPC projectForSource:self];
	NSDictionary * D = [[[TPD environmentForEngineMode:iTM2ProjectDefaultsKey] mutableCopy] autorelease];
	id value = [D objectForKey:@"SyncTeXUncompressed"];
	if(value)
	{
		return [value boolValue];
	}
	// from the SUD
	D = [self contextDictionaryForKey:@"iTM2PDFKitSync" domain:iTM2ContextAllDomainsMask];
	value = [D objectForKey:@"SyncTeXUncompressed"];
    return [value boolValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setUncompressedSyncTeX:
- (void)setUncompressedSyncTeX:(BOOL)yorn;
{iTM2_DIAGNOSTIC;
//iTM2_START;
 	iTM2TeXProjectDocument * TPD = (iTM2TeXProjectDocument *)[SPC projectForSource:self];
	NSMutableDictionary * D = [[[TPD environmentForEngineMode:iTM2ProjectDefaultsKey] mutableCopy] autorelease];
	if(!D)
	{
		D = [NSMutableDictionary dictionary];
	}
	if(yorn)
	{
		[D setObject:[NSNumber numberWithBool:yorn] forKey:@"SyncTeXUncompressed"];
	}
	else
	{
		[D removeObjectForKey:@"SyncTeXUncompressed"];
	}
	[TPD takeEnvironment:D forEngineMode:iTM2ProjectDefaultsKey];
//iTM2_END;
	return;
}
#define GETTER [[self contextValueForKey:iTM2PDFKitKey domain:iTM2ContextAllDomainsMask] valueForKey:iTM2KeyFromSelector(_cmd)]
#define SETTER(argument) id __D = [[[self contextDictionaryForKey:iTM2PDFKitKey domain:iTM2ContextAllDomainsMask] mutableCopy] autorelease];\
if(!__D) __D = [NSMutableDictionary dictionary];\
[__D setValue:argument forKey:iTM2KeyFromSelector(_cmd)];\
[self takeContextValue:__D forKey:iTM2PDFKitKey domain:iTM2ContextAllDomainsMask];
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  strongerSynchronization
- (BOOL)strongerSynchronization;
{
	return [GETTER boolValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setStrongerSynchronization:
- (void)setStrongerSynchronization:(BOOL)argument;
{
	SETTER([NSNumber numberWithBool:argument]);
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
	SETTER(([argument isKindOfClass:[NSColor class]]?[NSArchiver archivedDataWithRootObject:argument]:nil));
	[[self pdfView] setNeedsDisplay:YES];
	return;
}
#pragma mark =-=-=-=-=-  PDFView  BINDINGS
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
	SETTER([NSNumber numberWithInt:argument]);
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
	SETTER([NSNumber numberWithFloat:argument]);
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  scaleFactor
- (float)scaleFactor;
{
	float result = [GETTER floatValue];
	return result>0?result:1.0;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setScaleFactor:
- (void)setScaleFactor:(float)argument;
{
	SETTER([NSNumber numberWithFloat:argument]);
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
	SETTER([NSNumber numberWithBool:argument]);
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
	SETTER([NSNumber numberWithBool:argument]);
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= autoZoom:
- (IBAction)autoZoom:(id)sender;
/*"Description forthcoming.
Version History:jlaurens AT users DOT sourceforge DOT net
- 2.0:Wed Jan  5 17:41:55 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	BOOL old = [self autoScales];
	[self setAutoScales:!old];
	[self contextDidChange];
	[self validateWindowContent];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= validateAutoZoom:
- (BOOL)validateAutoZoom:(id)sender;
/*"Description forthcoming.
Version History:jlaurens AT users DOT sourceforge DOT net
- 2.0:Wed Jan  5 17:41:55 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[sender setState:([self autoScales]? NSOnState:NSOffState)];
//iTM2_END;
    return YES;
}
#undef GETTER
#undef SETTER
#define GETTER [[self contextValueForKey:@"iTM2PDFKitSync" domain:iTM2ContextAllDomainsMask] valueForKey:iTM2KeyFromSelector(_cmd)]
#define SETTER(argument) id __D = [[[self contextDictionaryForKey:@"iTM2PDFKitSync" domain:iTM2ContextAllDomainsMask] mutableCopy] autorelease];\
if(!__D) __D = [NSMutableDictionary dictionary];\
[__D setValue:argument forKey:iTM2KeyFromSelector(_cmd)];\
[self takeContextValue:__D forKey:@"iTM2PDFKitSync" domain:iTM2ContextAllDomainsMask];
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  displayBullets
- (unsigned int)displayBullets;
{
	return [GETTER unsignedIntValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setDisplayBullets:
- (void)setDisplayBullets:(unsigned int)displayBullets;
{
	SETTER([NSNumber numberWithUnsignedInt:displayBullets]);
	[[self pdfView] setNeedsDisplay:YES];
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  displayFocus
- (BOOL)displayFocus;
{
	return ([self displayBullets]&kiTM2PDFSYNCDisplayFocusBullets)>0;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setDisplayFocus:
- (void)setDisplayFocus:(BOOL)yorn;
{	
	[self willChangeValueForKey:@"displayBullets"];
	[self setDisplayBullets:
		(yorn?([self displayBullets]|kiTM2PDFSYNCDisplayFocusBullets):
			([self displayBullets]&~kiTM2PDFSYNCDisplayFocusBullets))];
	[self didChangeValueForKey:@"displayBullets"];
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  displayUserBullets
- (BOOL)displayUserBullets;
{
	return ([self displayBullets]&kiTM2PDFSYNCDisplayUserBullets)>0;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setDisplayUserBullets:
- (void)setDisplayUserBullets:(BOOL)yorn;
{
	[self willChangeValueForKey:@"displayBullets"];
	[self setDisplayBullets:
		(yorn?([self displayBullets]|kiTM2PDFSYNCDisplayUserBullets):
			([self displayBullets]&~kiTM2PDFSYNCDisplayUserBullets))];
	[self didChangeValueForKey:@"displayBullets"];
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  displayBuiltInBullets
- (BOOL)displayBuiltInBullets;
{
	return ([self displayBullets]&kiTM2PDFSYNCDisplayBuiltInBullets)>0;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setDisplayBuiltInBullets:
- (void)setDisplayBuiltInBullets:(BOOL)yorn;
{
	[self willChangeValueForKey:@"displayBullets"];
	[self setDisplayBullets:
		(yorn?([self displayBullets]|kiTM2PDFSYNCDisplayBuiltInBullets):
			([self displayBullets]&~kiTM2PDFSYNCDisplayBuiltInBullets))];
	[self didChangeValueForKey:@"displayBullets"];
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= synchronizeWithLine:column:source:hint:
- (BOOL)synchronizeWithLine:(unsigned int)l column:(unsigned int)c source:(NSString *)SRCE hint:(NSDictionary *)hint
/*"Description Forthcoming. The first responder must never be the window but at least its content view unless we want to neutralize the iTM2FlagsChangedResponder.
Version History:jlaurens AT users DOT sourceforge DOT net
- < 1.1:03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return [[[self document] synchronizer] isSyncTeX]
		&& [[self album] synchronizeWithLine:(unsigned int)l column:(unsigned int)c source:(NSString *)SRCE hint:(NSDictionary *) hint];
}
@end

@implementation iTM2PDFKitInspector(PDFSYNC)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= canSynchronizeOutput
- (BOOL)canSynchronizeOutput;
/*"Description Forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- 2.0:Fri Sep 05 2003
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
Version History:jlaurens AT users DOT sourceforge DOT net
- 1.3:03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[[self pdfView] scrollSynchronizationPointToVisible:sender];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateScrollSynchronizationPointToVisible:
- (BOOL)validateScrollSynchronizationPointToVisible:(NSMenuItem *)sender;
/*"Description forthcoming.
Version History:jlaurens AT users DOT sourceforge DOT net
- 1.3:03/10/2002
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
Version history:jlaurens AT users DOT sourceforge DOT net
- 2.0:Tue May  3 16:20:26 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[SUD registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:
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
Version history:jlaurens AT users DOT sourceforge DOT net
- 2.0:Tue May  3 16:20:26 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_LOG(@"Setting up the toolbar:0");
	NSAssert(_toolbarBackForwardView, @"Missing _toolbarBackForwardView connection...");
	NSSegmentedCell * segmentedCell = [_toolbarBackForwardView cell];
	[segmentedCell setAction:@selector(goBackForward:)];
	[segmentedCell setTarget:self];
	//
	NSAssert(_toolbarToolModeView, @"Missing _toolbarToolModeView connection...");
	segmentedCell = [_toolbarToolModeView cell];
	[segmentedCell setTrackingMode:NSSegmentSwitchTrackingSelectOne];
	[segmentedCell setSegmentCount:4];
	[segmentedCell setImage:[NSImage iTM2_imageMoveToolAdorn] forSegment:kiTM2ScrollToolMode];
	[segmentedCell setTag:kiTM2ScrollToolMode forSegment:kiTM2ScrollToolMode];
	[segmentedCell setImage:[NSImage iTM2_imageTextToolAdorn] forSegment:kiTM2TextToolMode];
	[segmentedCell setTag:kiTM2TextToolMode forSegment:kiTM2TextToolMode];
	[segmentedCell setImage:[NSImage iTM2_imageSelectToolAdorn] forSegment:kiTM2SelectToolMode];
	[segmentedCell setTag:kiTM2SelectToolMode forSegment:kiTM2SelectToolMode];
	[segmentedCell setImage:[NSImage iTM2_imageAnnotateTool1AdornDisclosure] forSegment:kiTM2AnnotateToolMode];
	[segmentedCell setTag:kiTM2AnnotateToolMode forSegment:kiTM2AnnotateToolMode];
	[segmentedCell setAction:NULL];
	[segmentedCell setTarget:nil];
	[_toolbarToolModeView setFrameSize:[segmentedCell cellSize]];
	//
//iTM2_LOG(@"Setting up the toolbar:1");
    NSToolbar * toolbar = [[[NSToolbar alloc] initWithIdentifier:iTM2PDFKitToolbarIdentifier] autorelease];
	NSString * key = [NSString stringWithFormat:@"NSToolbar Configuration %@", [toolbar identifier]];
	if([self contextBoolForKey:@"iTM2PDFKitToolbarShareConfiguration" domain:iTM2ContextAllDomainsMask])
	{
//iTM2_LOG(@"Setting up the toolbar:1-a");
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
//iTM2_LOG(@"Setting up the toolbar:1-b");
		NSDictionary * configDictionary = [SUD dictionaryForKey:key];
//iTM2_LOG(@"configDictionary:%@", configDictionary);
		configDictionary = [self contextDictionaryForKey:key domain:iTM2ContextAllDomainsMask];
//iTM2_LOG(@"configDictionary:%@", configDictionary);
		if([configDictionary count])
			[toolbar setConfigurationFromDictionary:configDictionary];
		if(![[toolbar items] count])
		{
			configDictionary = [SUD dictionaryForKey:key];
//iTM2_LOG(@"configDictionary:%@", configDictionary);
			[self takeContextValue:nil forKey:key domain:iTM2ContextAllDomainsMask];
			if([configDictionary count])
				[toolbar setConfigurationFromDictionary:configDictionary];
			if(![[toolbar items] count])
			{
				[SUD removeObjectForKey:key];
				toolbar = [[[NSToolbar alloc] initWithIdentifier:iTM2PDFKitToolbarIdentifier] autorelease];
			}
		}
	}
//iTM2_LOG(@"Setting up the toolbar:2");
	[toolbar setAutosavesConfiguration:YES];
    [toolbar setAllowsUserCustomization:YES];
//    [toolbar setSizeMode:NSToolbarSizeModeSmall];
    [toolbar setDelegate:self];
    [[self window] setToolbar:toolbar];
//iTM2_LOG(@"The toolbar has properly been setup");
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleShareToolbarConfiguration:
- (void)toggleShareToolbarConfiguration:(id)sender;
/*"Description Forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- 2.0:Tue May  3 16:20:26 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	BOOL old = [self contextBoolForKey:@"iTM2PDFKitToolbarShareConfiguration" domain:iTM2ContextAllDomainsMask];
	[self takeContextBool:!old forKey:@"iTM2PDFKitToolbarShareConfiguration" domain:iTM2ContextAllDomainsMask];
	[self validateWindowContent];
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleShareToolbarConfiguration:
- (BOOL)validateToggleShareToolbarConfiguration:(id)sender;
/*"Description Forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- 2.0:Tue May  3 16:20:26 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[sender setState:([self contextBoolForKey:@"iTM2PDFKitToolbarShareConfiguration" domain:iTM2ContextAllDomainsMask]? NSOnState:NSOffState)];
//iTM2_END;
	return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  prepareToolbarConfigurationCompleteSaveContext:
- (void)prepareToolbarConfigurationCompleteSaveContext:(id)sender;
/*"Description Forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- 2.0:Tue May  3 16:20:26 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([self contextBoolForKey:@"iTM2PDFKitToolbarAutosavesConfiguration" domain:iTM2ContextAllDomainsMask])
	{
		NSToolbar * toolbar = [[self window] toolbar];
		NSString * key = [NSString stringWithFormat:@"NSToolbar Configuration %@", [toolbar identifier]];
		[self takeContextValue:[toolbar configurationDictionary] forKey:key domain:iTM2ContextAllDomainsMask];
	}
//iTM2_START;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toolbar:itemForItemIdentifier:willBeInsertedIntoToolbar:
- (NSToolbarItem *)toolbar:(NSToolbar *)toolbar itemForItemIdentifier:(NSString *)itemIdent willBeInsertedIntoToolbar:(BOOL)willBeInserted;
/*"Description Forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- 2.0:Tue May  3 16:20:26 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    // Required delegate method:Given an item identifier, this method returns an item 
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
			[F setFloatValue:[[self pdfView] scaleFactor]];
		}
		[F setFrameSize:NSMakeSize([[NF stringForObjectValue:[NSNumber numberWithFloat:[F floatValue]]]
						sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
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
						sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
								[[F cell] font], NSFontAttributeName, nil]].width+8, 22)];
		if(willBeInserted)
		{
			PDFPage * page = [[self pdfView] currentPage];
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
		[toolbarItem setImage:[NSImage iTM2_cachedImageNamed:@"SaveDocumentItemImage"]];
		
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
Version history:jlaurens AT users DOT sourceforge DOT net
- 2.0:Tue May  3 16:20:26 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    // Required delegate method:Returns the ordered list of items to be shown in the toolbar by default    
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
Version history:jlaurens AT users DOT sourceforge DOT net
- 2.0:Tue May  3 16:20:26 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    // Required delegate method:Returns the list of all allowed items by identifier.  By default, the toolbar 
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
Version history:jlaurens AT users DOT sourceforge DOT net
- 2.0:Tue May  3 16:20:26 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    // Optional delegate method:Before an new item is added to the toolbar, this notification is posted.
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
Version history:jlaurens AT users DOT sourceforge DOT net
- 2.0:Tue May  3 16:20:26 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    // Optional delegate method:Before an new item is added to the toolbar, this notification is posted.
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
Version history:jlaurens AT users DOT sourceforge DOT net
- 2.0:Tue May  3 16:20:26 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	PDFPage * currentPage = [[self pdfView] currentPage];
	int rotation = [currentPage rotation];
	rotation -= 90;
	[currentPage setRotation:rotation];
	[[self pdfView] setNeedsDisplay:YES];
	[self validateWindowContent];
//iTM2_END;
    return;
}  
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  rotateRight:
- (IBAction)rotateRight:(id)sender;
/*"Description Forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- 2.0:Tue May  3 16:20:26 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	PDFPage * currentPage = [[self pdfView] currentPage];
	int rotation = [currentPage rotation];
	rotation += 90;
	[currentPage setRotation:rotation];
	[[self pdfView] setNeedsDisplay:YES];
	[self validateWindowContent];
//iTM2_END;
    return;
}  
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takePageFrom:
- (IBAction)takePageFrom:(id)sender;
/*"Description Forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- 2.0:Tue May  3 16:20:26 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    unsigned int n = (unsigned int)[sender intValue];
	if(n<1)
		n = 0;
	else
		--n;
	PDFPage * page = [[self pdfView] currentPage];
	PDFDocument * document = [page document];
	unsigned int pageCount = [document pageCount];
	if(n<pageCount)
		[[self pdfView] goToPage:[document pageAtIndex:n]];
//iTM2_END;
	[self validateWindowContent];
    return;
}  
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateTakePageFrom:
- (BOOL)validateTakePageFrom:(id)sender;
/*"Description Forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- 2.0:Tue May  3 16:20:26 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([[sender currentEditor] isEqual:[[sender window] firstResponder]])
		return YES;
	if(![[sender window] isEqual:[self window]])
		return YES;
	PDFPage * page = [[self pdfView] currentPage];
	PDFDocument * document = [page document];
	unsigned int pageCount = [document indexForPage:page];
	[sender setIntValue:pageCount+1];
	pageCount = [document pageCount];
	NSNumberFormatter * NF = [sender formatter];
	[NF setMaximum:[NSNumber numberWithInt:pageCount]];
	NSSize oldSize = [sender frame].size;
	float width = 8 + MAX(
		([[NF stringForObjectValue:[NSNumber numberWithInt:[sender intValue]]]
				sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
							[[sender cell] font], NSFontAttributeName, nil]].width),
		([[NF stringForObjectValue:[NSNumber numberWithInt:99]]
				sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
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
Version history:jlaurens AT users DOT sourceforge DOT net
- 2.0:Tue May  3 16:20:26 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	float newScale = [sender floatValue];
	if(newScale <= 0)
		newScale = 1;
    [[self pdfView] setScaleFactor:newScale];
	[self validateWindowContent];
//iTM2_END;
    return;
}  
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateTakeScaleFrom:
- (BOOL)validateTakeScaleFrom:(id)sender;
/*"Description Forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- 2.0:Tue May  3 16:20:26 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([[sender currentEditor] isEqual:[[sender window] firstResponder]])
		return YES;
	if(![[sender window] isEqual:[self window]])
		return YES;
	[sender setFloatValue:[[self pdfView] scaleFactor]];
	NSNumberFormatter * NF = [sender formatter];
	NSSize oldSize = [sender frame].size;
	float width = 8 + MAX(
			([[NF stringForObjectValue:[NSNumber numberWithFloat:[sender floatValue]]]
				sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
							[[sender cell] font], NSFontAttributeName, nil]].width),
			([[NF stringForObjectValue:[NSNumber numberWithFloat:1]]
				sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
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
Version history:jlaurens AT users DOT sourceforge DOT net
- 2.0:Tue May  3 16:20:26 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([sender selectedSegment])
	{
		[[self pdfView] goForward:sender];
	}
	else
	{
		[[self pdfView] goBack:sender];
	}
	[self validateWindowContent];
//iTM2_END;
    return;
}  
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateGoBackForward:
- (BOOL)validateGoBackForward:(id)sender;
/*"Description Forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- 2.0:Tue May  3 16:20:26 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(![[sender window] isEqual:[self window]])
		return YES;
	BOOL isEnabled = NO;
	if([[self pdfView] canGoBack])
	{
		[sender setEnabled:YES forSegment:0];
		isEnabled = YES;
	}
	else
		[sender setEnabled:NO forSegment:0];
	if([[self pdfView] canGoForward])
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
Version history:jlaurens AT users DOT sourceforge DOT net
- 2.0:Fri Sep 05 2003
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
Version history:jlaurens AT users DOT sourceforge DOT net
- 2.0:Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(![[sender window] isEqual:[self window]])
		return YES;
	iTM2ToolMode toolMode = [self toolMode];
	if(![sender selectSegmentWithTag:toolMode])
	{
		[self setToolMode:kiTM2ScrollToolMode];
		[sender selectSegmentWithTag:[self toolMode]];
	}
//iTM2_END;
    return YES;
}
@end

@interface iTM2PDFKitView(PRIVATE)
- (BOOL)trackZoom:(NSEvent *)theEvent;
- (BOOL)trackMove:(NSEvent *)theEvent;
- (void)setupView;
@end

@interface __iTM2PDFZoominView:NSView
@end

@interface __iTM2PDFKitSelectView:NSView
{
@private
	BOOL _active;
	BOOL _tracking;
	NSView * _subview;// retained as subviews array member
	NSImage * _cachedShadow;
}
- (id)initWithFrame:(NSRect)frameRect;
- (NSRect)selectionRect;
- (void)setSelectionRect:(NSRect)aRect;
- (void)_expandSelectionRectToContainWholeGlyphsInPage:(PDFPage *)page;
- (void)trackSelectionModify:(NSEvent *)theEvent boundary:(unsigned int)mask inRect:(NSRect)bounds;
- (void)trackSelectionCreate:(NSEvent *)theEvent inRect:(NSRect)bounds;
- (void)trackSelectionDrag:(NSEvent *)theEvent inRect:(NSRect)bounds;
- (PDFAreaOfInterest)areaOfInterestForMouse:(NSEvent *) theEvent;
- (void)scrollSelectionToVisible:(id)sender;
- (BOOL)changeCursorForAreaOfInterest:(PDFAreaOfInterest)area;
@end

@interface __iTM2PDFKitSynchronizationView:NSView
@end

@implementation __iTM2PDFKitSynchronizationView
- (id)initWithFrame:(NSRect)bounds;
{
	if(self = [super initWithFrame:bounds])
	{
		[self setAutoresizingMask:NSViewWidthSizable|NSViewHeightSizable];
	}
	return self;
}
- (NSView *)hitTest:(NSPoint)aPoint;
{
	return nil;
}
- (BOOL)acceptsFirstResponder;
{
	return NO;
}
- (void)drawRect:(NSRect)aRect;
{
	NSMutableDictionary * cd = [[[SUD dictionaryForKey:@"iTM2PDFKitSync"] mutableCopy] autorelease];
	[cd addEntriesFromDictionary:[self contextDictionaryForKey:@"iTM2PDFKitSync" domain:iTM2ContextAllDomainsMask]];
	NSNumber * N = [cd objectForKey:@"EnableSynchronization"];
	if(![N respondsToSelector:@selector(boolValue)] || ![N boolValue])
	{
		return;
	}
	N = [cd objectForKey:@"DisplayBullets"];
	unsigned int displayBulletsMode = [N respondsToSelector:@selector(unsignedIntValue)]? [N unsignedIntValue]:0;
	if((displayBulletsMode & kiTM2PDFSYNCDisplayFocusBullets))
	{
		NSRect inRect = NSZeroRect;
		NSImage * syncDimple = [NSImage iTM2_imageNERedArrow];
		inRect.size = [syncDimple size];
//				fromRect = [self convertRect:fromRect fromView:nil];
		inRect = [self convertRect:inRect fromView:nil];
		if(inRect.size.width>[syncDimple size].width)
		{
			inRect.size = [syncDimple size];
		}
		NSPoint origin;
		origin.x = - inRect.size.width;
		origin.y = - inRect.size.height;
		id superview = [self superview];
		while(![superview isKindOfClass:[PDFView class]])
		{
			if(!(superview = [superview superview]))
			{
				return;
			}
		}
		id _SyncDestinations = [superview valueForKey:@"_SyncDestinations"];
		NSEnumerator * E = [_SyncDestinations objectEnumerator];
		PDFDestination * destination;
		while(destination = [E nextObject])
		{
			NSPoint syncPoint = [destination point]; // point is in page space
			syncPoint = [superview convertPoint:syncPoint fromPage:[destination page]]; // now in superview coordinates
			syncPoint = [self convertPoint:syncPoint fromView:superview]; // now in the receiver's coordinates.
			inRect.origin.x = syncPoint.x + origin.x;
			inRect.origin.y = syncPoint.y + origin.y;
			[syncDimple drawInRect:inRect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1];
		}
	}
	return;
}
@end

@interface __iTM2PDFPrintView:NSView
{
@public
	NSPDFImageRep * representation;
}
@end

@interface _PDFFilePromiseController:NSObject
{
@private
	NSString * _name;
	NSData * _data;
	NSString * _label;
}
- (id)initWithName:(NSString *)name data:(NSData *)data label:(NSString *)label;
@end

@implementation iTM2PDFKitView
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initialize
+ (void)initialize;
/*"Description Forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- 2.0:Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[super initialize];
	[SUD registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:
		[NSNumber numberWithInt:10], @"iTM2PDFKitSyncMaxNumberOfMatches",
		[NSNumber numberWithFloat:0.2], @"com.apple.mouse.doubleClickThreshold",
		[NSDictionary dictionaryWithObjectsAndKeys:
			[NSNumber numberWithBool:YES], @"EnableSynchronization",
			[NSNumber numberWithBool:YES], @"FollowFocus",
			[NSNumber numberWithUnsignedInt:7], @"DisplayBullets",
							nil], @"iTM2PDFKitSync",
				nil]];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setupView
- (void)setupView;
/*"Description Forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- 2.1: Thu Jun 19 06:28:52 UTC 2008
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self initImplementation];
	id V = [[[__iTM2PDFKitSynchronizationView alloc] initWithFrame:[[self documentView] bounds]] autorelease];
	[[self documentView] addSubview:V];
	V = [[[__iTM2PDFKitSelectView alloc] initWithFrame:[[self documentView] bounds]] autorelease];
	[[self documentView] addSubview:V];
	[V setHidden:[self toolMode]==kiTM2SelectToolMode];
	[self setAllowsDragging:NO];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initWithFrame:
- (id)initWithFrame:(NSRect)rect;
/*"Description Forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- 2.0:Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(self = [super initWithFrame:rect])
	{
		[self setupView];
	}
//iTM2_END;
    return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initWithCoder:
- (id)initWithCoder:(NSCoder *)aDecoder;
/*"Description Forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- 2.0:Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(self = [super initWithCoder:aDecoder])
	{
		[self setupView];
	}
//iTM2_END;
    return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  dealloc
- (void)dealloc;
/*"Description Forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- 2.0:Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self deallocImplementation];
	[super dealloc];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  zoomIn:
- (void)zoomIn:(id)sender;
/*"Description Forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- 2.0:Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self setAutoScales:NO];
	[super zoomIn:sender];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  zoomOut:
- (void)zoomOut:(id)sender;
/*"Description Forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- 2.0:Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self setAutoScales:NO];
	[super zoomOut:sender];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  awakeFromNib
- (void)awakeFromNib;
/*"Description Forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- 2.0:Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([[self superclass] instancesRespondToSelector:_cmd])
	{
		[super awakeFromNib];
	}
	[self setToolMode:[self contextIntegerForKey:@"iTM2PDFKitToolMode" domain:iTM2ContextAllDomainsMask]];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  implementation
- (id)implementation;
/*"Description Forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- 2.0:Mon May 10 22:45:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return _Implementation;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setImplementation:
- (void)setImplementation:(id)argument;
/*"Description Forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- 2.0:Mon May 10 22:45:25 GMT 2004
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
Version history:jlaurens AT users DOT sourceforge DOT net
- 2.0:Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id oldDocument = [self document];
	if(document != oldDocument)
	{
		[_SyncDestination autorelease];
		_SyncDestination = nil;
		[_SyncDestinations autorelease];
		_SyncDestinations = nil;
		[_SyncPointValues autorelease];
		_SyncPointValues = nil;
		[super setDocument:document];// raise if the document has no pages
#if 0
#warning Trick to workaround a bug:the PDFView document view is not properly set up
//iTM2_LOG(@"[[self documentView] bounds] are:%@",NSStringFromRect([[self documentView] bounds]));
		NSRect frame = [self frame];
		NSRect smallerFrame = NSInsetRect(frame,5,5);
		[self setFrame:smallerFrame];
//iTM2_LOG(@"[[self documentView] bounds] are:%@",NSStringFromRect([[self documentView] bounds]));
		[self setFrame:frame];
//iTM2_LOG(@"[[self documentView] bounds] are:%@",NSStringFromRect([[self documentView] bounds]));
		NSWindow * W = [self window];
		frame = [W frame];
		smallerFrame = NSInsetRect(frame,-1,-1);
		[W setFrame:smallerFrame display:NO animate:NO];
		[W setFrame:frame display:YES animate:NO];
#endif
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  drawPage:
- (void)drawPage:(PDFPage *)page;
/*"Description forthcoming.
Version History:jlaurens AT users DOT sourceforge DOT net
- 1.3:03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[super drawPage:page];
    NSMethodSignature * sig0 = [self methodSignatureForSelector:_cmd];
    NSInvocation * I = [NSInvocation invocationWithMethodSignature:sig0];
    [I setTarget:self];
    [I setArgument:&page atIndex:2];
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
Version History:jlaurens AT users DOT sourceforge DOT net
- 1.3:03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSValue * V;
	NSEnumerator * E;
	NSMutableDictionary * SLs;
	iTM2SynchronizationLocationRecord locationRecord;
	unsigned int displayBulletsMode;
	NSMutableDictionary * cd = [[[SUD dictionaryForKey:@"iTM2PDFKitSync"] mutableCopy] autorelease];
	[cd addEntriesFromDictionary:[self contextDictionaryForKey:@"iTM2PDFKitSync" domain:iTM2ContextAllDomainsMask]];
	NSNumber * N = [cd objectForKey:@"EnableSynchronization"];
    if([N respondsToSelector:@selector(boolValue)]? [N boolValue]:NO)
    {
  		iTM2PDFKitDocument * D = [[[self window] windowController] document];
		iTM2PDFSynchronizer * syncer = [D synchronizer];
		if(!syncer)
		{
			[D updateSynchronizer:self];
			return;
		}
		NSImage * starDimple = [NSImage iTM2_imageGreenDimple];
		NSImage * builtInDimple = [NSImage iTM2_imageBlueDimple];
		NSImage * plusDimple = [NSImage iTM2_imageGreyDimple];
		unsigned int pageIndex = [[page document] indexForPage:page];
        if([SUD boolForKey:iTM2PDFSyncShowRecordNumberKey])
		{
			SLs = (NSMutableDictionary*)[syncer synchronizationLocationsForPageIndex:pageIndex];
            E = [SLs keyEnumerator];
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
                V = [SLs objectForKey:K];
                [V getValue:&locationRecord];
                NSPoint P = NSMakePoint(locationRecord.x, locationRecord.y);
				inRect.origin.x = P.x + origin.x;
				inRect.origin.y = P.y + origin.y;
				[starDimple drawInRect:inRect fromRect:fromRect operation:NSCompositeSourceOver fraction:0.3];
				[[NSString stringWithFormat:@"%@", K] drawAtPoint:P withAttributes:D];
            }
        }
        else
        {
			NSShadow * theShadow = [[[NSShadow alloc] init] autorelease]; 
			NSRect fromRect = NSZeroRect;
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
			N = [cd objectForKey:@"DisplayBullets"];
			displayBulletsMode = [N respondsToSelector:@selector(unsignedIntValue)]? [N unsignedIntValue]:0;
			SLs = (NSMutableDictionary *)[syncer synchronizationLocationsForPageIndex:pageIndex];
            E = [SLs objectEnumerator];
//				[starDimple setScalesWhenResized:YES];
			while(V = [E nextObject])
			{
				[V getValue:&locationRecord];
				NSPoint P = NSMakePoint(locationRecord.x, locationRecord.y);
				if(testForCharacter && !locationRecord.plus && ([page characterIndexNearPoint:P]<0))
				{
					// don't draw;
//iTM2_LOG(@"$$$$  This point does not seem to point to a character:%@", NSStringFromPoint(P));
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
			[NSGraphicsContext restoreGraphicsState];
		}
    }
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  centeredSubview:
- (id)centeredSubview;
/*"Description forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- 1.3:Thu Jul 17 2003
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
Version history:jlaurens AT users DOT sourceforge DOT net
- 1.3:Thu Jul 17 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  resetCursorRects
- (void)resetCursorRects
/*"Description forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- 2.1: Sat Jun 21 20:44:27 UTC 2008
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSTrackingRectTag tag = [[IMPLEMENTATION metaValueForKey:@"NSTrackingCursorRectTag"] intValue];
	if(tag)
	{
		[self removeTrackingRect:tag];
	}
	tag = [self addTrackingRect:[self visibleRect] owner:self userData:nil assumeInside:YES];
	[IMPLEMENTATION takeMetaValue:[NSNumber numberWithInt:tag] forKey:@"NSTrackingCursorRectTag"];
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  mouseEntered:
- (void)mouseEntered:(NSEvent *)theEvent;
/*"Description forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- 2.1: Sat Jun 21 20:44:27 UTC 2008
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([theEvent trackingNumber] == [[IMPLEMENTATION metaValueForKey:@"NSTrackingCursorRectTag"] intValue])
	{
		[self setCursorForAreaOfInterest:[self areaOfInterestForMouse:theEvent]];
		return;
	}
//iTM2_END;
	[super mouseEntered:(NSEvent *)theEvent];
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  mouseExited:
- (void)mouseExited:(NSEvent *)theEvent;
/*"Description forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- 2.1: Sat Jun 21 20:44:27 UTC 2008
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([theEvent trackingNumber] == [[IMPLEMENTATION metaValueForKey:@"NSTrackingCursorRectTag"] intValue])
	{
		[self setCursorForAreaOfInterest:[self areaOfInterestForMouse:theEvent]];
		return;
	}
//iTM2_END;
	[super mouseExited:(NSEvent *)theEvent];
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setCursorForAreaOfInterest:
- (void)setCursorForAreaOfInterest:(PDFAreaOfInterest)area
/*"This is where the cursor is set.
We first ask the __iTM2PDFKitSelectView subview,
if this subview does not change the cirsor, then we manage it here.
Version history:jlaurens AT users DOT sourceforge DOT net
- 2.0:
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSArray * subviews = [self subviewsWhichClassInheritsFromClass:[__iTM2PDFKitSelectView class]];
	if([subviews count])
	{
		__iTM2PDFKitSelectView * subview = [subviews lastObject];
		if(![subview isHiddenOrHasHiddenAncestor] && [subview changeCursorForAreaOfInterest:area])
		{
//iTM2_END;
			return;
		}
	}
	if(area&kiTM2PDFZoomInArea)
	{
		[[NSCursor zoomInCursor] set];
//iTM2_END;
		return;
	}
	if(area&kiTM2PDFZoomOutArea)
	{
		[[NSCursor zoomOutCursor] set];
//iTM2_END;
		return;
	}
	if(area&kiTM2PDFSelectArea)
	{
		[[NSCursor openHandCursor] set];
//iTM2_END;
		return;
	}
	if(area&kPDFPageArea)
	{
		switch([self toolMode])
		{
			case kiTM2ScrollToolMode:
				[[NSCursor openHandCursor] set];
				return;
			case kiTM2TextToolMode:
				[[NSCursor IBeamCursor] set];
				return;
			case kiTM2SelectToolMode:
				[[NSCursor crosshairCursor] set];
				return;
			case kiTM2AnnotateToolMode:
				[[NSCursor arrowCursor] set];
				return;
		}
	}
//iTM2_END;
	return [super setCursorForAreaOfInterest:area];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  areaOfInterestForMouse:
- (PDFAreaOfInterest)areaOfInterestForMouse:(NSEvent *)theEvent;
/*"Description forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- 2.0:
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	unsigned int modifierFlags = [theEvent modifierFlags] & NSDeviceIndependentModifierFlagsMask;
	if(modifierFlags&NSCommandKeyMask)
	{
		if(modifierFlags&NSAlternateKeyMask)
		{
			if(modifierFlags&NSShiftKeyMask)
			{
				return [super areaOfInterestForMouse:theEvent] | kiTM2PDFZoomOutArea;
			}
			return [super areaOfInterestForMouse:theEvent] | kiTM2PDFZoomInArea;
		}
	}
	NSPoint mouseLocation = [self convertPoint:[[self window] mouseLocationOutsideOfEventStream] fromView:nil];
	if(NSPointInRect(mouseLocation,[self visibleRect])&&[self pageForPoint:mouseLocation nearest:NO])
	{
		NSArray * subviews = [self subviewsWhichClassInheritsFromClass:[__iTM2PDFKitSelectView class]];
		if([subviews count])
		{
			__iTM2PDFKitSelectView * subview = [subviews lastObject];
			if(![subview isHiddenOrHasHiddenAncestor])
			{
				PDFAreaOfInterest AOI = [subview areaOfInterestForMouse:theEvent];
				if(AOI != kPDFNoArea)
				{
					return kPDFPageArea | AOI;
				}
			}
		}
		return kPDFPageArea;
	}
//iTM2_END;
	return kPDFNoArea;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  trackZoom:
- (BOOL)trackZoom:(NSEvent *)theEvent;
/*"Description forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- 2.0:
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	unsigned int modifierFlags = [theEvent modifierFlags] & NSDeviceIndependentModifierFlagsMask;
	NSView * documentView = [self documentView];
	if(NSIsEmptyRect([documentView bounds]) || ([theEvent clickCount] != 1) || (modifierFlags & (NSShiftKeyMask|NSAlternateKeyMask) == 0))
	{
		return NO;
	}
	[NSEvent startPeriodicEventsAfterDelay:0 withPeriod:0.1];/* Force a refresh */
	NSView * rootView = [[[NSView allocWithZone:[self zone]] initWithFrame:[self frame]] autorelease];
	[[self superview] replaceSubview:self with:rootView];
	[rootView addSubview:self];
	NSView * zoomView = [[[__iTM2PDFZoominView allocWithZone:[self zone]] initWithFrame:NSZeroRect] autorelease];
	NSView * clipView = [[[NSView allocWithZone:[self zone]] initWithFrame:NSZeroRect] autorelease];
	[rootView addSubview:zoomView];
	[zoomView addSubview:clipView];
	PDFView * pdfViewZoomed = [[[PDFView allocWithZone:[self zone]] initWithFrame:NSMakeRect(0,0,1000,1000)] autorelease];
	[pdfViewZoomed setDocument:[self document]];
	[pdfViewZoomed setScaleFactor:[self scaleFactor]];
	[pdfViewZoomed setDisplayMode:[self displayMode]];
	[pdfViewZoomed setDisplaysPageBreaks:[self displaysPageBreaks]];
	[pdfViewZoomed setDisplayBox:[self displayBox]];
	[pdfViewZoomed setDisplaysAsBook:[self displaysAsBook]];
	[pdfViewZoomed setShouldAntiAlias:[self shouldAntiAlias]];
	[pdfViewZoomed setGreekingThreshold:[self greekingThreshold]];
	[pdfViewZoomed setBackgroundColor:[self backgroundColor]];
	[clipView addSubview:pdfViewZoomed];
	NSView * documentViewZoomed = [pdfViewZoomed documentView];
	NSPoint windowFocus, clipFocus, focus, focusZoomed;
	NSRect boundsInWindow, R1,R2, R3;
	NSSize size;
	float scale, scaleFactor;
	NSWindow * window = [self window];
	//
next:
	/* The bounds where the focus should live in window coordinates */
	boundsInWindow = [documentView visibleRect];
	boundsInWindow = [documentView convertRect:boundsInWindow toView:nil];
	/* The windowFocus, constrained to boundsInWindow */
	windowFocus = [window mouseLocationOutsideOfEventStream];
	if(windowFocus.x<=NSMinX(boundsInWindow))
	{
		windowFocus.x = NSMinX(boundsInWindow)+0.05;
	}
	else if(windowFocus.x>=NSMaxX(boundsInWindow))
	{
		windowFocus.x = NSMaxX(boundsInWindow)-0.05;
	}
	if(windowFocus.y<=NSMinY(boundsInWindow))
	{
		windowFocus.y = NSMinY(boundsInWindow)+0.05;
	}
	else if(windowFocus.y>=NSMaxY(boundsInWindow))
	{
		windowFocus.y = NSMaxY(boundsInWindow)-0.05;
	}
	/* Placing the zoomView */
	R1 = NSZeroRect;
	R1.origin = windowFocus;
	if(theEvent) modifierFlags = [theEvent modifierFlags] & NSDeviceIndependentModifierFlagsMask;
	scale = 2;
	if(modifierFlags & NSShiftKeyMask)scale*=2;
	if(modifierFlags & NSAlternateKeyMask)scale*=2;
	scaleFactor = scale * [self scaleFactor];
	if([pdfViewZoomed scaleFactor] != scaleFactor) [pdfViewZoomed setScaleFactor:scaleFactor];
	size = modifierFlags & NSCommandKeyMask? NSMakeSize(176,99):NSMakeSize(100,75);
	R1 = NSInsetRect(R1,-size.width,-size.height);
	if(NSMaxX(R1)>NSMaxX(boundsInWindow))
	{
		R1.origin.x-=NSMaxX(R1)-NSMaxX(boundsInWindow);
	}
	if(NSMinX(R1)<NSMinX(boundsInWindow))
	{
		R1.origin.x=NSMinX(boundsInWindow);
		R1.size.width += MIN(0,NSWidth(boundsInWindow)-NSWidth(R1));
	}
	if(NSMaxY(R1)>NSMaxY(boundsInWindow))
	{
		R1.origin.y-=NSMaxY(R1)-NSMaxY(boundsInWindow);
	}
	if(NSMinY(R1)<NSMinY(boundsInWindow))
	{
		R1.origin.y=NSMinY(boundsInWindow);
		R1.size.height += MIN(0,NSHeight(boundsInWindow)-NSHeight(R1));
	}
	R1 = [rootView convertRect:R1 fromView:nil];
	R2 = NSInsetRect(R1,-10,-10);
	[zoomView setFrame:R2];
	R1 = [zoomView convertRect:R1 fromView:rootView];
	[clipView setFrame:R1];
	/* The focus */
	focus = [documentView convertPoint:windowFocus fromView:nil];
	/* The focusZoomed:if documentView and documentViewZoomed are proportional, this works */
	focusZoomed.x = NSMidX([documentViewZoomed bounds])
			+(focus.x-NSMidX([documentView bounds]))*[documentViewZoomed bounds].size.width/[documentView bounds].size.width;
	focusZoomed.y = NSMidY([documentViewZoomed bounds])
			+(focus.y-NSMidY([documentView bounds]))*[documentViewZoomed bounds].size.height/[documentView bounds].size.height;
	/* The windowFocus in clip coordinates*/
	clipFocus = [clipView convertPoint:windowFocus fromView:nil];
	/* clipFocus and focus are the same point in different coordinate systems, focusZoomed will also be later */
	/* Now place the pdfViewZoomed and its document view at the proper location in the clipView */
	R1 = [clipView bounds];
	NSAssert((NSPointInRect(clipFocus,R1)),@"ERROR");
	R2.origin = R1.origin;
	R2.size = NSMakeSize(clipFocus.x-R1.origin.x,clipFocus.y-R1.origin.y);
	R2 = [clipView convertRect:R2 toView:documentViewZoomed];
	R2 = NSOffsetRect(R2,focusZoomed.x-NSMaxX(R2),focusZoomed.y-NSMaxY(R2));
	R3.origin = clipFocus;
	R3.size = NSMakeSize(NSMaxX(R1)-clipFocus.x,NSMaxY(R1)-clipFocus.y);
	R3 = [clipView convertRect:R3 toView:documentViewZoomed];
	R3 = NSOffsetRect(R3,focusZoomed.x-NSMinX(R3),focusZoomed.y-NSMinY(R3));
	R2 = NSUnionRect(R2,R3);
	[documentViewZoomed scrollRectToVisible:R2];
	R2 = [clipView convertRect:R2 fromView:documentViewZoomed];
	R3 = [pdfViewZoomed frame];
	R3 = NSOffsetRect(R3,R1.origin.x-R2.origin.x,R1.origin.y-R2.origin.y);
	[pdfViewZoomed setFrame:R3];
	[rootView display];
	if(theEvent = [window nextEventMatchingMask:NSLeftMouseUpMask untilDate:nil inMode:NSEventTrackingRunLoopMode dequeue:YES])
	{
		[NSEvent stopPeriodicEvents];/* No longer need to refresh */
		[[rootView superview] replaceSubview:rootView with:self];
		[window makeFirstResponder:nil];
		[[self superview] setNeedsDisplay:YES];
		[window resetCursorRects];
		id WC = [window windowController];
		if([WC respondsToSelector:@selector(setDocumentViewVisibleRect:)])
		{
			NSRect visibleRect = [documentView visibleRect];
			visibleRect = [documentView absoluteRectWithRect:visibleRect];
			[WC setDocumentViewVisibleRect:visibleRect];
		}
//iTM2_END;
		return YES;
	}
	theEvent = [window nextEventMatchingMask:NSLeftMouseDraggedMask|NSFlagsChangedMask|NSScrollWheelMask|NSPeriodicMask];
	NSSize scrollSize = NSZeroSize;
	R1 = [documentView bounds];
	R2 = [documentView visibleRect];
#define SCROLL_STEP 16
	if(windowFocus.x<NSMinX(boundsInWindow)+10)
	{
		scrollSize.width = MAX(-SCROLL_STEP,NSMinX(R1)-NSMinX(R2));
	}
	else if(windowFocus.x>NSMaxX(boundsInWindow)-10)
	{
		scrollSize.width = MIN(SCROLL_STEP,NSMaxX(R1)-NSMaxX(R2));
	}
	if(windowFocus.y<NSMinY(boundsInWindow)+10)
	{
		scrollSize.height = MAX(-SCROLL_STEP,NSMinY(R1)-NSMinY(R2));
	}
	else if(windowFocus.y>NSMaxY(boundsInWindow)-10)
	{
		scrollSize.height = MIN(SCROLL_STEP,NSMaxY(R1)-NSMaxY(R2));
	}
	if(!NSEqualSizes(scrollSize,NSZeroSize))
	{
		R2 = NSOffsetRect(R2,scrollSize.width/scale,scrollSize.height/scale);
		[documentView scrollRectToVisible:R2];
	}
	goto next;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toolMode
- (iTM2ToolMode)toolMode;
{
	return [metaGETTER intValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setToolMode:
- (void)setToolMode:(iTM2ToolMode)argument;
{
	NSNumber * oldContainer = metaGETTER;
	iTM2ToolMode old = [oldContainer intValue];
	if(old==argument && oldContainer)
	{
//iTM2_STOP;
		return;
	}
	[self takeContextInteger:argument forKey:@"iTM2PDFKitToolMode" domain:iTM2ContextAllDomainsMask];
	NSArray * selectViews = [self subviewsWhichClassInheritsFromClass:[__iTM2PDFKitSelectView class]];
	NSEnumerator * E = [selectViews objectEnumerator];
	NSView * subview;
	if(kiTM2SelectToolMode == argument)
	{
		while(subview = [E nextObject])
		{
			[subview setHidden:NO];
		}
	}
	else
	{
		while(subview = [E nextObject])
		{
			[subview setHidden:YES];
		}
	}
	metaSETTER([NSNumber numberWithInt:argument]);
//iTM2_STOP;
	return;
}
- (IBAction)goToNextPage:(id)sender
{
	PDFPage * page = [self currentPage];
//	PDFDocument * doc = [page document];
//iTM2_LOG(@"BEFORE %i",[doc indexForPage:page]);
	[super goToNextPage:sender];
	page = [self currentPage];
//iTM2_LOG(@"AFTER %i",[doc indexForPage:page]);
	return;
}
@end

@implementation iTM2XtdPDFDocument
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= dealloc
- (void)dealloc;
/*"Description Forthcoming.
Version History:jlaurens AT users DOT sourceforge DOT net
- < 1.1:03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	free(__PageStringOffsets);
	__PageStringOffsets = nil;
	[__CachedPageStrings release];
	__CachedPageStrings = nil;
	[self willDealloc];
	[super dealloc];
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= stringForPage:
- (NSString *)stringForPage:(PDFPage *)page;
/*"Description Forthcoming.
Version History:jlaurens AT users DOT sourceforge DOT net
- < 1.1:03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(!__CachedPageStrings)
	{
		__CachedPageStrings = [[NSMutableDictionary dictionary] retain];
	}
	if(page)
	{
		NSValue * V = [NSValue valueWithNonretainedObject:page];
		id result = [__CachedPageStrings objectForKey:V];
		if(!result)
		{
			result = [page string];
			[__CachedPageStrings setObject:result forKey:V];
		}
		return result;
	}
//iTM2_END;
	return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= __SetupPageStringOffsets
- (void)__SetupPageStringOffsets;
/*"This must be multi thread safe.
Version History:jlaurens AT users DOT sourceforge DOT net
- < 1.1:03/10/2002
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
			iTM2_LOG(@"<-><-><->  Number of pages(%u) is:%u", pageIndex, __PageStringOffsets[pageIndex]);
			++maxPageIndex;
			while(++pageIndex<maxPageIndex)
			{
				iTM2_LOG(@"<-><-><->  offset at index:%u is %u (= %u is %u)", pageIndex-1, __PageStringOffsets[pageIndex], [self pageIndexForCharacterIndex:__PageStringOffsets[pageIndex]], [self characterOffsetForPageAtIndex:pageIndex - 1]);
			}
			iTM2_LOG(@"<-><-><->  Total number of characters (%u) is:%u", maxPageIndex, __PageStringOffsets[maxPageIndex]);
		}
		return;
	}
	else
	{
		[L unlock];
#warning THIS IS A BAD MANAGEMENT
		iTM2_LOG(@"Memory management problem:no offest caching available...");
		return;
	}
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= pageIndexForCharacterIndex:
- (unsigned int)pageIndexForCharacterIndex:(unsigned int)characterIndex;
/*"Description Forthcoming.
Version History:jlaurens AT users DOT sourceforge DOT net
- < 1.1:03/10/2002
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
//iTM2_LOG(@"%%%%%%%% character index:%i, page index:%i", characterIndex, min);
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
Version History:jlaurens AT users DOT sourceforge DOT net
- < 1.1:03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self __SetupPageStringOffsets];
	unsigned int pageCount = __PageStringOffsets[0];
	// what is the max valid offset?
	unsigned int maxValidIndex = __PageStringOffsets[pageCount+2];
//iTM2_END;
	return pageIndex <= maxValidIndex? __PageStringOffsets[pageIndex+1]:NSNotFound;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= positionOfWord:options:range:
- (iTM2Position)positionOfWord:(NSString *)aWord options:(unsigned)mask range:(NSRange)searchRange;
/*"Description Forthcoming.
Version History:jlaurens AT users DOT sourceforge DOT net
- < 1.1:03/10/2002
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
	pageString = [self stringForPage:page];
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
	pageString = [self stringForPage:page];
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
					pageString = [self stringForPage:page];
					numberOfCharacters = [pageString length];
					if(characterOffset >= numberOfCharacters)
					{
						characterOffset -= numberOfCharacters;
						goto previousPage;
					}
					else
					{
						iTM2_LOG(@"****  WARNING:bug in the character offset computation");
					}
				}
			}
		}
	}
	else if(pageIndex--)
	{
		page = [self pageAtIndex:pageIndex];
		pageString = [self stringForPage:page];
		numberOfCharacters = [pageString length];
		if(characterOffset >= numberOfCharacters)
		{
			characterOffset -= numberOfCharacters;
			goto previousPage;
		}
		else
		{
			iTM2_LOG(@"****  WARNING:bug in the character offset computation");
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
Version History:jlaurens AT users DOT sourceforge DOT net
- < 1.1:03/10/2002
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
		[self positionsOfWordBefore:before here:hit after:after index:hitIndex inRange:NSMakeRange(0, characterLimit)]:nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= positionsOfWordBefore:before:here:after:index:inRange:
- (NSDictionary *)positionsOfWordBefore:(NSString *)before here:(NSString *)hit after:(NSString *)after index:(unsigned int)hitIndex inRange:(NSRange)searchRange;
/*"Description Forthcoming.
Version History:jlaurens AT users DOT sourceforge DOT net
- < 1.1:03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	// WARNING the given words might not be found due to the spaces added by TeX
	// If a word is too big, it might be cut by TeX.
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
//iTM2_LOG(@"#### position:%@ with weight %i", NSStringFromRange(hitPosition.range), weight);
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
								initWithPage:page atPoint:point] autorelease]];
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

#define SCROLL_LAYER 20
#define SCROLL_DIMEN 20
#define SCROLL_COEFF 1.2

@interface iTM2PDFKitView(SyncHRONIZE)
- (BOOL)_synchronizeWithDestinations:(NSDictionary *)destinations;
- (BOOL)_synchronizeWithDestinations:(NSDictionary *)destinations here:(NSString *)hit index:(unsigned int)hitIndex oldDestination:(PDFDestination *)oldDestination;
- (BOOL)_synchronizeWithDestinations:(NSDictionary *)destinations before:(NSString *)before here:(NSString *)hit index:(unsigned int)hitIndex oldDestination:(PDFDestination *)oldDestination;
- (BOOL)_synchronizeWithDestinations:(NSDictionary *)destinations here:(NSString *)hit after:(NSString *)after index:(unsigned int)hitIndex oldDestination:(PDFDestination *)oldDestination;
- (BOOL)_synchronizeWithDestinations:(NSDictionary *)destinations before:(NSString *)before here:(NSString *)hit after:(NSString *)after index:(unsigned int)hitIndex oldDestination:(PDFDestination *)oldDestination;
- (BOOL)_synchronizeWithDestinations:(NSDictionary *)destinations before:(NSString *)before here:(NSString *)hit after:(NSString *)after index:(unsigned int)hitIndex;
- (void)scrollSynchronizationPointToVisible:(id)sender;
- (BOOL)__synchronizeWithStoredDestinationsAndHints:(id)irrelevant;
@end

@implementation iTM2PDFKitView(SyncHRONIZE)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= _synchronizeWithDestinations:
- (BOOL)_synchronizeWithDestinations:(NSDictionary *)destinations;
/*"Description Forthcoming.
Version History:jlaurens AT users DOT sourceforge DOT net
- < 1.1:03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSParameterAssert(destinations);
	[_SyncDestinations autorelease];
	_SyncDestinations = [[NSMutableArray array] retain];
#if 1
	NSMutableSet * pageSet = [NSMutableSet set];
	PDFDocument * document = [self document];
	NSArray * keys = [NSArray arrayWithObjects:@"here",@"after",@"before",nil];
	NSEnumerator * EE = [keys objectEnumerator];
	NSString * key = nil;
	while(key = [EE nextObject])
	{
		NSDictionary * D = [destinations objectForKey:key];
		NSEnumerator * E = [D keyEnumerator];
		NSNumber * N;
		while(N = [E nextObject])
		{
			unsigned int pageIndex = [N unsignedIntValue];
			if(pageIndex < [document pageCount])
			{
				PDFPage * page = [document pageAtIndex:pageIndex];
				NSEnumerator * e = [[D objectForKey:N] objectEnumerator];
				NSValue * pointValue;
nextPointValue:
				if(pointValue = [e nextObject])
				{
					NSPoint point = [pointValue pointValue];
					if([page characterIndexNearPoint:point] != -1)
					{
						[_SyncDestinations addObject:[[[PDFDestination allocWithZone:[self zone]]
							initWithPage:page atPoint:point] autorelease]];
						[pageSet addObject:page];
						return YES;
					}
					goto nextPointValue;
				}
			}
		}
#if 0
		if([pageSet count] != 1)
		{
			// I need to scroll
			return YES;
		}
#endif
	}
#endif
//iTM2_END;
	return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= _synchronizeWithDestinations:here:index:
- (BOOL)_synchronizeWithDestinations:(NSDictionary *)destinations here:(NSString *)hit index:(unsigned int)hitIndex oldDestination:(PDFDestination *)oldDestination;
/*"Description Forthcoming.
Version History:jlaurens AT users DOT sourceforge DOT net
- < 1.1:03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSParameterAssert(hit);
//iTM2_LOG(@"COUCOUCOUCOUCOUCOUCOUCOUCOUCOU destinations:%@", destinations);
//iTM2_END;
	return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= _synchronizeWithDestinations:before:here:index:
- (BOOL)_synchronizeWithDestinations:(NSDictionary *)destinations before:(NSString *)before here:(NSString *)hit index:(unsigned int)hitIndex oldDestination:(PDFDestination *)oldDestination;
/*"Description Forthcoming.
Version History:jlaurens AT users DOT sourceforge DOT net
- < 1.1:03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSParameterAssert(before);
	NSParameterAssert(hit);
//iTM2_LOG(@"COUCOUCOUCOUCOUCOUCOUCOUCOUCOU destinations:%@", destinations);
//iTM2_END;
	return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= _synchronizeWithDestinations:here:after:index:
- (BOOL)_synchronizeWithDestinations:(NSDictionary *)destinations here:(NSString *)hit after:(NSString *)after index:(unsigned int)hitIndex oldDestination:(PDFDestination *)oldDestination;
/*"Description Forthcoming.
Version History:jlaurens AT users DOT sourceforge DOT net
- < 1.1:03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSParameterAssert(hit);
	NSParameterAssert(after);
//iTM2_LOG(@"COUCOUCOUCOUCOUCOUCOUCOUCOUCOU destinations:%@", destinations);
//iTM2_END;
	return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= _synchronizeWithDestinations:before:here:after:index:oldDestination:
- (BOOL)_synchronizeWithDestinations:(NSDictionary *)destinations before:(NSString *)before here:(NSString *)hit after:(NSString *)after index:(unsigned int)hitIndex oldDestination:(PDFDestination *)oldDestination;
/*"Description Forthcoming.
Version History:jlaurens AT users DOT sourceforge DOT net
- < 1.1:03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(!oldDestination)
	{
		return [self _synchronizeWithDestinations:destinations before:before here:hit after:after index:hitIndex];
	}
	NSParameterAssert([before length]);
	NSParameterAssert([hit length]);
	NSParameterAssert([after length]);
	hitIndex = MIN(hitIndex, [hit length] - 1);
	// if destinations are available, we should use them!!!
	NSDictionary * hereRecords = [destinations objectForKey:@"here"];
	NSDictionary * beforeRecords = [destinations objectForKey:@"before"];
	NSDictionary * afterRecords = [destinations objectForKey:@"after"];
//iTM2_LOG(@"????    $$$$  hereRecords are:%@", hereRecords);
//iTM2_LOG(@"????    $$$$  beforeRecords are:%@", beforeRecords);
//iTM2_LOG(@"????    $$$$  afterRecords are:%@", afterRecords);
	NSDictionary * positions = nil;
	iTM2XtdPDFDocument * document = (iTM2XtdPDFDocument *)[self document];
	unsigned int min,max,pageIndex;
	NSEnumerator * E = nil;
	NSNumber * N = nil;
	NSNumber * minN = nil;
	if([NSApp nextEventMatchingMask:NSLeftMouseDownMask|NSRightMouseDownMask|NSKeyDownMask|NSFlagsChangedMask untilDate:nil inMode:NSEventTrackingRunLoopMode dequeue:NO])
	{
		return YES;
	}
#pragma mark 1 - Positions
	if([hereRecords count])
	{
		E = [hereRecords keyEnumerator];
		N = [E nextObject];
		max = min = [N unsignedIntValue];
		while(N = [E nextObject])
		{
			pageIndex = [N unsignedIntValue];
			if(pageIndex<min)
				min = pageIndex;
			else if(pageIndex>max)
				max = pageIndex;
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
						positionsOfWordBefore:before here:hit after:after index:hitIndex];
				}
				else
				{
setUpMax:
					max = (max < [document pageCount] - 1)?
						[document characterOffsetForPageAtIndex:max+1]
						:[document characterOffsetForPageAtIndex:[document pageCount]];
					if(max == NSNotFound)
					{
						goto defaultPositions;
					}
					else
					{
						positions = [document
							positionsOfWordBefore:before here:hit after:after index:hitIndex
								inRange:NSMakeRange(min, max - min)];
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
				positionsOfWordBefore:before here:hit after:after index:hitIndex];
		}
	}
	else if([beforeRecords count])
	{
		E = [beforeRecords keyEnumerator];
		min = 0;
		while(N = [E nextObject])
		{
			pageIndex = [N unsignedIntValue];
			if(pageIndex>min)
			{
				min = pageIndex;
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
					pageIndex = [N unsignedIntValue];
					if(pageIndex<max)
						max = pageIndex;
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
			NSArray * points = minN? [beforeRecords objectForKey:minN]:nil;
			if([points count] > 0)
			{
				NSPoint point = [[points objectAtIndex:0] pointValue];
				int charIndex = [page characterIndexNearPoint:point];
				if(charIndex >= 0)
					minOff7 += charIndex;
	//iTM2_LOG(@"????    $$$$????    $$$$????    $$$$????    $$$$  charIndex is:%i", charIndex);
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
				positionsOfWordBefore:before here:hit after:after index:hitIndex
					inRange:NSMakeRange(minOff7, maxOff7 - minOff7)];
			if([positions count])
			{
				if(maxOff7 < lastOff7)
				{
					maxOff7 = lastOff7;
					positions = [document
						positionsOfWordBefore:before here:hit after:after index:hitIndex
							inRange:NSMakeRange(minOff7, maxOff7 - minOff7)];
					if(![positions count])
					{
						maxOff7 = savedMaxOff7;
quelquepart:
						if(minOff7)
						{
							minOff7 = [document characterOffsetForPageAtIndex:min-1];
							positions = [document
								positionsOfWordBefore:before here:hit after:after index:hitIndex
									inRange:NSMakeRange(minOff7, maxOff7 - minOff7)];
						}
					}
				}
				else
					goto quelquepart;
			}
//iTM2_LOG(@"ssearch range:%u, %u", min, max);
		}
		else
		{
			positions = [document
				positionsOfWordBefore:before here:hit after:after index:hitIndex];
		}
	}
	else
	{
		positions = [document
			positionsOfWordBefore:before here:hit after:after index:hitIndex];
	}
	if([NSApp nextEventMatchingMask:NSLeftMouseDownMask|NSRightMouseDownMask|NSKeyDownMask|NSFlagsChangedMask untilDate:nil inMode:NSEventTrackingRunLoopMode dequeue:NO])
	{
		return YES;
	}
	// we are trying to find the best location fitting the sequence of the 3 words, before, hit and after
	if(positions)
	{
		NSString * key = [[[positions allKeys] sortedArrayUsingSelector:@selector(compare:)] objectAtIndex:0];
		[_SyncDestinations autorelease];
		_SyncDestinations = [[positions objectForKey:key] retain];
//iTM2_LOG(@"****  _SyncDestinations are now:%@", _SyncDestinations);
		// then what shall we do?
		// let us try first to use the given destinations
		// the destinations are 3 dictionaries of page numbers/point arrays pairs.
		unsigned int pageCount;
		PDFDestination * destination;
		if([hereRecords count])
		{
#pragma mark 2 - "Here" records
//iTM2_LOG(@"$$$$  [hereRecords count] is:%i", [hereRecords count]);
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
			// The only thing we know is that there is a sync anchor on the same line where the mouseDown:occurred.
			// TeX can mess things up such that the anchor point can be completely fool...
#pragma mark 2 - a ) Convert to global
			NSMutableArray * globalIndexes = [NSMutableArray array];
			E = [hereRecords keyEnumerator];
			while(N = [E nextObject])
			{
				if([NSApp nextEventMatchingMask:NSLeftMouseDownMask|NSRightMouseDownMask|NSKeyDownMask|NSFlagsChangedMask untilDate:nil inMode:NSEventTrackingRunLoopMode dequeue:NO])
				{
					return YES;
				}
				pageIndex = [N unsignedIntValue];
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
					iTM2_LOG(@"***  Something WEIRD DID HAPPEN:page number %u was expected to not exceed %u", pageIndex, [doc pageCount]);
				}
			}
			// globalIndexes is an array of numbers wrapping global character indexes.
			// then we try to find the sync destination neerest to the record index
#pragma mark 2 - b ) Find best match
			unsigned int minWeight = UINT_MAX;
			NSMutableArray * syncDestinations = [NSMutableArray array];
			E = [globalIndexes objectEnumerator];
			while(N = [E nextObject])
			{
				int globalIndex = [N intValue];
				NSEnumerator * EE = [_SyncDestinations objectEnumerator];// _SyncDestinations contains the positions
				while(destination = [EE nextObject])
				{
					PDFPage * page = [destination page];
					int globalIdx = [page localToGlobalCharacterIndex:
						[page characterIndexNearPoint:[destination point]]];
					unsigned weight = globalIdx < globalIndex?
						globalIndex - globalIdx:globalIdx - globalIndex;
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
		}
		else
		{
#pragma mark 3 - No "Here" records
			// we try to choose the destinations for which there exist something before and after...
			NSMutableArray * globalBeforeIndexes = [NSMutableArray array];
			// globalBeforeIndexes is an array of numbers wrapping global character indexes.
			if([beforeRecords count])
			{
				E = [beforeRecords keyEnumerator];
				pageCount = [[self document] pageCount];
				while(N = [E nextObject])
				{
					
					pageIndex = [N unsignedIntValue];
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
			if([NSApp nextEventMatchingMask:NSLeftMouseDownMask|NSRightMouseDownMask|NSKeyDownMask|NSFlagsChangedMask untilDate:nil inMode:NSEventTrackingRunLoopMode dequeue:NO])
			{
				return YES;
			}
			NSMutableArray * globalAfterIndexes = [NSMutableArray array];
			if([afterRecords count])
			{
				E = [afterRecords keyEnumerator];
				pageCount = [[self document] pageCount];
				while(N = [E nextObject])
				{
					pageIndex = [N unsignedIntValue];
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
//iTM2_LOG(@"$$$$  globalBeforeIndexes is:%@", globalBeforeIndexes);
//iTM2_LOG(@"$$$$  globalAfterIndexes is:%@", globalAfterIndexes);
			if([NSApp nextEventMatchingMask:NSLeftMouseDownMask|NSRightMouseDownMask|NSKeyDownMask|NSFlagsChangedMask untilDate:nil inMode:NSEventTrackingRunLoopMode dequeue:NO])
			{
				return YES;
			}
			NSMutableArray * oldSyncDestinations = [NSMutableArray arrayWithArray:_SyncDestinations];
			NSMutableArray * newSyncDestinations = [NSMutableArray array];
			NSEnumerator * beforeE = [globalBeforeIndexes objectEnumerator];
			unsigned int beforeIndex = [[beforeE nextObject] unsignedIntValue];
			NSEnumerator * afterE = [globalAfterIndexes objectEnumerator];
			NSNumber * afterNumber;
			unsigned int afterIndex;
			nextAfterIndexLabel:
			afterNumber = [afterE nextObject];
			afterIndex = afterNumber? [afterNumber unsignedIntValue]:UINT_MAX;
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
				_SyncDestinations = [[NSMutableArray arrayWithObject:hitDestination] retain];
				//[self scrollDestinationToVisible:hitDestination];// no go to, it does not work well...
				if([NSApp nextEventMatchingMask:NSLeftMouseDownMask|NSRightMouseDownMask|NSKeyDownMask|NSFlagsChangedMask untilDate:nil inMode:NSEventTrackingRunLoopMode dequeue:NO])
				{
					return YES;
				}
			}
		}
	}
	else
	{
		// for one reason or another, we could not find the positions.
		// then rely on SyncTeX if available
		if([[destinations objectForKey:@"SyncTeX"] boolValue])
		{
			E = [hereRecords keyEnumerator];
			N = [E nextObject];
			pageIndex = [N unsignedIntValue];
			PDFPage * page = [[self document] pageAtIndex:pageIndex];
			NSPoint P = [[[hereRecords objectForKey:N] lastObject] pointValue];
			NSRect bounds = [page boundsForBox:kPDFDisplayBoxMediaBox];
			P.y = NSMaxY(bounds)-P.y;
			PDFDestination * destination = [[[PDFDestination allocWithZone:[self zone]] initWithPage:page atPoint:P] autorelease];
			[_SyncDestinations removeAllObjects];
			[_SyncDestinations addObject:destination];
		}
	}
//iTM2_END;
	[self scrollSynchronizationPointToVisible:self];// no go to, it does not work well...
	return [_SyncDestinations count]!=0;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= _synchronizeWithDestinations:before:here:after:index:
- (BOOL)_synchronizeWithDestinations:(NSDictionary *)destinations before:(NSString *)before here:(NSString *)hit after:(NSString *)after index:(unsigned int)hitIndex;
/*"Description Forthcoming.
Version History:jlaurens AT users DOT sourceforge DOT net
- < 1.1:03/10/2002
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
//iTM2_LOG(@"????    $$$$  hereRecords are:%@", hereRecords);
//iTM2_LOG(@"????    $$$$  beforeRecords are:%@", beforeRecords);
//iTM2_LOG(@"????    $$$$  afterRecords are:%@", afterRecords);
	NSDictionary * positions = nil;
	iTM2XtdPDFDocument * document = (iTM2XtdPDFDocument *)[self document];
	unsigned int min,max,pageIndex;
	NSEnumerator * E = nil;
	NSNumber * N = nil;
	NSNumber * minN = nil;
#pragma mark 1 - Positions
	if([hereRecords count])
	{
		E = [hereRecords keyEnumerator];
		N = [E nextObject];
		max = min = [N unsignedIntValue];
		while(N = [E nextObject])
		{
			pageIndex = [N unsignedIntValue];
			if(pageIndex<min)
				min = pageIndex;
			else if(pageIndex>max)
				max = pageIndex;
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
						positionsOfWordBefore:before here:hit after:after index:hitIndex];
				}
				else
				{
setUpMax:
					max = (max < [document pageCount] - 1)?
						[document characterOffsetForPageAtIndex:max+1]
						:[document characterOffsetForPageAtIndex:[document pageCount]];
					if(max == NSNotFound)
					{
						goto defaultPositions;
					}
					else
					{
						positions = [document
							positionsOfWordBefore:before here:hit after:after index:hitIndex
								inRange:NSMakeRange(min, max - min)];
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
				positionsOfWordBefore:before here:hit after:after index:hitIndex];
		}
	}
	else if([beforeRecords count])
	{
		E = [beforeRecords keyEnumerator];
		min = 0;
		while(N = [E nextObject])
		{
			pageIndex = [N unsignedIntValue];
			if(pageIndex>min)
			{
				min = pageIndex;
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
					pageIndex = [N unsignedIntValue];
					if(pageIndex<max)
						max = pageIndex;
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
			NSArray * points = minN? [beforeRecords objectForKey:minN]:nil;
			if([points count] > 0)
			{
				NSPoint point = [[points objectAtIndex:0] pointValue];
				int charIndex = [page characterIndexNearPoint:point];
				if(charIndex >= 0)
					minOff7 += charIndex;
	//iTM2_LOG(@"????    $$$$????    $$$$????    $$$$????    $$$$  charIndex is:%i", charIndex);
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
				positionsOfWordBefore:before here:hit after:after index:hitIndex
					inRange:NSMakeRange(minOff7, maxOff7 - minOff7)];
			if([positions count])
			{
				if(maxOff7 < lastOff7)
				{
					maxOff7 = lastOff7;
					positions = [document
						positionsOfWordBefore:before here:hit after:after index:hitIndex
							inRange:NSMakeRange(minOff7, maxOff7 - minOff7)];
					if(![positions count])
					{
						maxOff7 = savedMaxOff7;
quelquepart:
						if(minOff7)
						{
							minOff7 = [document characterOffsetForPageAtIndex:min-1];
							positions = [document
								positionsOfWordBefore:before here:hit after:after index:hitIndex
									inRange:NSMakeRange(minOff7, maxOff7 - minOff7)];
						}
					}
				}
				else
					goto quelquepart;
			}
//iTM2_LOG(@"ssearch range:%u, %u", min, max);
		}
		else
		{
			positions = [document
				positionsOfWordBefore:before here:hit after:after index:hitIndex];
		}
	}
	else
	{
		positions = [document
			positionsOfWordBefore:before here:hit after:after index:hitIndex];
	}
	// we are trying to find the best location fitting the sequence of the 3 words, before, hit and after
	if(positions)
	{
		NSString * key = [[[positions allKeys] sortedArrayUsingSelector:@selector(compare:)] objectAtIndex:0];
		[_SyncDestinations autorelease];
		_SyncDestinations = [[positions objectForKey:key] retain];
//iTM2_LOG(@"****  _SyncDestinations are now:%@", _SyncDestinations);
		// then what shall we do?
		// let us try first to use the given destinations
		// the destinations are 3 dictionaries of page numbers/point arrays pairs.
		unsigned int pageCount;
		PDFDestination * destination;
		if([hereRecords count])
		{
#pragma mark 2 - "Here" records
//iTM2_LOG(@"$$$$  [hereRecords count] is:%i", [hereRecords count]);
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
			// The only thing we know is that there is a sync anchor on the same line where the mouseDown:occurred.
			// TeX can mess things up such that the anchor point can be completely fool...
#pragma mark 2 - a ) Convert to global
			NSMutableArray * globalIndexes = [NSMutableArray array];
			E = [hereRecords keyEnumerator];
			while(N = [E nextObject])
			{
				pageIndex = [N unsignedIntValue];
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
					iTM2_LOG(@"***  Something WEIRD DID HAPPEN:page number %u was expected to not exceed %u", pageIndex, [doc pageCount]);
				}
			}
			// globalIndexes is an array of numbers wrapping global character indexes.
			// then we try to find the sync destination neerest to the record index
#pragma mark 2 - b ) Find best match
			unsigned int minWeight = UINT_MAX;
			NSMutableArray * syncDestinations = [NSMutableArray array];
			E = [globalIndexes objectEnumerator];
			while(N = [E nextObject])
			{
				int globalIndex = [N intValue];
				NSEnumerator * EE = [_SyncDestinations objectEnumerator];// _SyncDestinations contains the positions
				while(destination = [EE nextObject])
				{
					PDFPage * page = [destination page];
					int globalIdx = [page localToGlobalCharacterIndex:
						[page characterIndexNearPoint:[destination point]]];
					unsigned weight = globalIdx < globalIndex?
						globalIndex - globalIdx:globalIdx - globalIndex;
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
		}
		else
		{
#pragma mark 3 - No "Here" records
			// we try to choose the destinations for which there exist something before and after...
			NSMutableArray * globalBeforeIndexes = [NSMutableArray array];
			// globalBeforeIndexes is an array of numbers wrapping global character indexes.
			if([beforeRecords count])
			{
				E = [beforeRecords keyEnumerator];
				pageCount = [[self document] pageCount];
				while(N = [E nextObject])
				{
					
					pageIndex = [N unsignedIntValue];
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
				E = [afterRecords keyEnumerator];
				pageCount = [[self document] pageCount];
				while(N = [E nextObject])
				{
					pageIndex = [N unsignedIntValue];
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
//iTM2_LOG(@"$$$$  globalBeforeIndexes is:%@", globalBeforeIndexes);
//iTM2_LOG(@"$$$$  globalAfterIndexes is:%@", globalAfterIndexes);
			NSMutableArray * oldSyncDestinations = [NSMutableArray arrayWithArray:_SyncDestinations];
			NSMutableArray * newSyncDestinations = [NSMutableArray array];
			NSEnumerator * beforeE = [globalBeforeIndexes objectEnumerator];
			unsigned int beforeIndex = [[beforeE nextObject] unsignedIntValue];
			NSEnumerator * afterE = [globalAfterIndexes objectEnumerator];
			NSNumber * afterNumber;
			unsigned int afterIndex;
			nextAfterIndexLabel:
			afterNumber = [afterE nextObject];
			afterIndex = afterNumber? [afterNumber unsignedIntValue]:UINT_MAX;
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
				_SyncDestinations = [[NSMutableArray arrayWithObject:hitDestination] retain];
			}
		}
	}
	else
	{
		// for one reason or another, we could not find the positions.
		// then rely on SyncTeX if available
		if([[destinations objectForKey:@"SyncTeX"] boolValue])
		{
			E = [hereRecords keyEnumerator];
			N = [E nextObject];
			pageIndex = [N unsignedIntValue];
			PDFPage * page = [[self document] pageAtIndex:pageIndex];
			NSPoint P = [[[hereRecords objectForKey:N] lastObject] pointValue];
			NSRect bounds = [page boundsForBox:kPDFDisplayBoxMediaBox];
			P.y = NSMaxY(bounds)-P.y;
			PDFDestination * destination = [[[PDFDestination allocWithZone:[self zone]] initWithPage:page atPoint:P] autorelease];
			[_SyncDestinations removeAllObjects];
			[_SyncDestinations addObject:destination];
		}
	}
//iTM2_END;
	[self scrollSynchronizationPointToVisible:self];// no go to, it does not work well...
	return [_SyncDestinations count]!=0;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= __threadedSynchronizeWithStoredDestinationsAndHints:
- (void)__threadedSynchronizeWithStoredDestinationsAndHints:(id)irrelevant;
/*"Description Forthcoming. NOT THREADED (problems)
Version History:jlaurens AT users DOT sourceforge DOT net
- < 1.1:03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
	iTM2_INIT_POOL;
//iTM2_START;
	[self __synchronizeWithStoredDestinationsAndHints:(id)irrelevant];
//iTM2_END;
	iTM2_RELEASE_POOL;
	[NSThread exit];
	return;
}
#import <iTM2TeXFoundation/synctex_parser.h>
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= synchronizeWithLine:column:source:hint:
- (BOOL)synchronizeWithLine:(unsigned int)l column:(unsigned int)c source:(NSString *)source hint:(NSDictionary *)hint
/*"Description Forthcoming. The first responder must never be the window but at least its content view unless we want to neutralize the iTM2FlagsChangedResponder.
Version History:jlaurens AT users DOT sourceforge DOT net
- < 1.1:03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id synchronizer = [[[[self window] windowController] document] synchronizer];
	if(![synchronizer isSyncTeX])
	{
		return NO;
	}
	synctex_scanner_t scanner = [synchronizer scanner];
	if(synctex_display_query(scanner,[source fileSystemRepresentation],l+1,c)>0)
	{
		synctex_node_t first_node = NULL;
		synctex_node_t node = NULL;
		unsigned int pageIndex = UINT_MAX;
		PDFPage * page = nil;
		PDFDocument * document = [self document];
		// get the hint ?
		NSString * container = [hint objectForKey:@"container"];
		NSNumber * N = [hint objectForKey:@"character index"];
		if(!N)
		{
			return NO;
		}
		unsigned int hereIndex = [N unsignedIntValue];// The mousedown occurred here.
		if(hereIndex >= [container length])
		{
			return NO;
		}
		NSRange hereR;
nextHereRight:
		hereR = [container doubleClickAtIndex:hereIndex];
		if(!hereR.length)
		{
			if(hereIndex<[container length])
			{
				++hereIndex;
				goto nextHereRight;
			}
			else
			{
				hereIndex = [N unsignedIntValue];
nextHereLeft:
				if(hereIndex--)
				{
					hereR = [container doubleClickAtIndex:hereIndex];
					if(!hereR.length)
					{
						goto nextHereLeft;
					}
				}
				else
				{
					return NO;
				}
			}
		}
		// the 3 words in the source around the hit index
		NSString * before = nil;
		NSString * here = [container substringWithRange:hereR];
		NSString * after = nil;
		unsigned int hereOffset = [container getWordBefore:&before here:&here after:&after atIndex:[N unsignedIntValue] mode:YES];
		if(!_SyncDestinations)
		{
			_SyncDestinations = [[NSMutableArray array] retain];
		}
#if 0
		first_node = synctex_next_result(scanner);
#elif 1
		//  first we collect all the nodes by page,
		NSMutableDictionary * nodesPerPages = [NSMutableDictionary dictionary];
		//  do something only if there is a match
		if((first_node = synctex_next_result(scanner)))
		{
			node = first_node;
			NSNumber * pageIndexKey = nil;
			NSMutableArray * nodesMRA = nil;
			NSValue * V = nil;
			do
			{
				int pageIndex = synctex_node_page(node)-1;
				if(pageIndex<0 || pageIndex>=[document pageCount])
				{
					continue;
				}
				pageIndexKey = [NSNumber numberWithInt:pageIndex];
				nodesMRA = [nodesPerPages objectForKey:pageIndexKey];
				if(!nodesMRA)
				{
					nodesMRA = [NSMutableArray array];
					[nodesPerPages setObject:nodesMRA forKey:pageIndexKey];
				}
				V = [NSValue valueWithPointer:node];
				[nodesMRA addObject:V];
				// get the synchronized line range and string
				
			} while((node = synctex_next_result(scanner)));
			// then for each page, work with the synchronized stuff
			NSEnumerator * pageIndexE = [nodesPerPages keyEnumerator];
			NSEnumerator * nodesE = nil;
			NSRange lineRange;
			NSString * pageString = nil;
			while(pageIndexKey = [pageIndexE nextObject])
			{
				PDFPage * page = [document pageAtIndex:[pageIndexKey intValue]];
				pageString = [page string];
				nodesMRA = [nodesPerPages objectForKey:pageIndexKey];
				nodesE = [[[nodesMRA mutableCopy] autorelease] objectEnumerator];
				[nodesMRA removeAllObjects];
				while(V = [nodesE nextObject])
				{
					node = [V pointerValue];
					// get the full line text of the click
					float tmp = synctex_node_box_visible_width(node);
					float top;
					NSPoint PP;
next_attempt:
					tmp = synctex_node_box_visible_width(node);
					if(tmp<0)
					{
						top = synctex_node_box_visible_h(node);
						PP.x = top+tmp;
					}
					else
					{
						PP.x = synctex_node_box_visible_h(node);
						top = PP.x+tmp;
					}
					PP.y = synctex_node_box_visible_v(node)+(synctex_node_box_visible_depth(node)-synctex_node_box_visible_height(node))/2;
					PP.y = NSMaxY([page boundsForBox:kPDFDisplayBoxMediaBox]) - PP.y;
					NSPoint Q = PP;
					Q.y+=1;
					PDFSelection * destination = nil;
					while(nil == (destination = [page selectionForWordAtPoint:Q]))
					{
						if((Q.x+=5)>top)
						{
							// second attempt
							Q = PP;
							while(nil == (destination = [page selectionForLineAtPoint:Q]))
							{
								if((Q.x+=5)>top)
								{
									if((node = synctex_node_parent(node)))
									{
										goto next_attempt;
									}
									goto next_chance;
								}
							}
						}
					}
					//  there was a selection for that point
					NSRect bounds = [destination boundsForPage:page];
					bounds.origin.y += 1;
					lineRange.location = [page characterIndexAtPoint:bounds.origin];
					lineRange.length = 0;
					[pageString getLineStart:(unsigned *)&(lineRange.location) end:nil contentsEnd:(unsigned *)&(lineRange.length) forRange:lineRange];
					lineRange.length -= lineRange.location;
					V = [NSValue valueWithRange:lineRange];
					if(![nodesMRA containsObject:V])
					{
						[nodesMRA addObject:V];
					}
next_chance:;					
				}
				if([nodesMRA count])
				{
					[nodesMRA insertObject:page atIndex:0];
					[nodesMRA insertObject:pageString atIndex:1];
				}
				else
				{
					[nodesPerPages removeObjectForKey:pageIndexKey];
				}
			}
			//  now nodesPerPages keys are page index numbers
			//  the values are mutable arrays containing
			//  the page object
			//  its string content
			//  the list of all the line ranges concerned by synchronization
			//  Now we are going to change the line ranges to character ranges
			//  there are 2 ways of doing things, depending on a word was clicked or not
			//  if the users clicked on a word, we try to find this word out in the output
			//  if the users clicked on a character that does not fit inside a full word,
			//  then we do nothing.
			//  The switch between thsoe two situations should be made earlier,
			//  because there is no definite rule to decide what should me made by the user interface,
			//  after the current method returns
			pageIndexE = [nodesPerPages keyEnumerator];
			while((pageIndexKey = [pageIndexE nextObject]))
			{
				nodesMRA = [nodesPerPages objectForKey:pageIndexKey];
				nodesE = [nodesMRA objectEnumerator];
				if((page = [nodesE nextObject]) && (pageString = [nodesE nextObject]))
				{
					//  turn all the line ranges into a common list of word ranges
					//  with at least 2 characters
					//  this is available within the whole loop
					NSMutableArray * wordRanges = [NSMutableArray array];
					//  now find the words that fits best with the "here" word under the hit point
					//  create a dictionary for which keys are the edit distance and the values are mutable arrays of word ranges
					//  for that edit distance
					NSMutableDictionary * keyedEditDistances = [NSMutableDictionary dictionary];
					unsigned int wordRangeIndex = 0;
					while((V = [nodesE nextObject]))
					{
						lineRange = [V rangeValue];//  V is unused now
						NSRange wordRange;
						unsigned int charIndex;
						charIndex = lineRange.location;
next_word_in_line:
						wordRange = [pageString doubleClickAtIndex:charIndex];
						if(wordRange.length>0)
						{
							if(wordRange.length>1)
							{
								V = [NSValue valueWithRange:wordRange];
								if(![wordRanges containsObject:V])
								{
									[wordRanges addObject:V];
									NSString * word = [pageString substringWithRange:wordRange];
									//  compare this word with the "here" word at the hit point
									unsigned editDistance = [word iTM2_editDistanceToString:here];
									NSNumber * editDistanceN = [NSNumber numberWithUnsignedInt:editDistance];
									NSMutableArray * mra = [keyedEditDistances objectForKey:editDistanceN];
									if(!mra)
									{
										mra = [NSMutableArray array];
										[keyedEditDistances setObject:mra forKey:editDistanceN];
									}
									V = [NSNumber numberWithUnsignedInt:wordRangeIndex];
									++ wordRangeIndex; // increment the index
									[mra addObject:V];
								}
							}
							charIndex = NSMaxRange(wordRange);
							if(charIndex < NSMaxRange(lineRange))
							{
								goto next_word_in_line;
							}
						}
					}
					//  what is the smaller distance?
					if([keyedEditDistances count])
					{
						NSNumber * bestEditDistanceN = [[[keyedEditDistances allKeys]
							sortedArrayUsingSelector:@selector(compare:)]
								objectAtIndex:0];
						// if the smallest distance is small enough, it will be retained for synchronization
						if([bestEditDistanceN unsignedIntValue] <= [here length]/3)
						{
							[_SyncDestinations removeAllObjects];
							NSMutableArray * mra = [keyedEditDistances objectForKey:bestEditDistanceN];
							if([mra count]>1)
							{
								//  can't we filter out some of the candidates?
								//  we can do that by comparing the words before and after the candidate with what is expected
								//  
								if([before length])
								{
									//  In a first stage, we just compare the word before the synchronization candidate
									//  and the expected one, we have to store the distances
									//  This makes sense only if there is a word before for each 
									NSMutableDictionary * md = [NSMutableDictionary dictionary];
									//  the keys are the edit distances
									//  the values are mutable arrays containing the candidates for that edit distance
									NSEnumerator * E = [[[mra copy] autorelease] objectEnumerator];
									unsigned int rangeIndex;
									while((V = [E nextObject]))
									{
										rangeIndex = [(NSNumber *)V unsignedIntValue];
										if(rangeIndex>0)
										{
											V = [wordRanges objectAtIndex:rangeIndex-1];
											NSRange R = [V rangeValue];
											NSString * beforeCandidate = [pageString substringWithRange:R];
											unsigned int editDistance = [before iTM2_editDistanceToString:beforeCandidate];
											NSNumber * N = [NSNumber numberWithUnsignedInt:editDistance];
											NSMutableArray * mra1 = [md objectForKey:N];
											if(!mra1)
											{
												mra1 = [NSMutableArray array];
												[md setObject:mra1 forKey:N];
											}
											[mra1 addObject:V];

										}
										else
										{
											[md setDictionary:[NSDictionary dictionary]];// nil?
											break;
										}
									}
									NSNumber * smallestDistanceN = [[[md allKeys] sortedArrayUsingSelector:@selector(compare:)] objectAtIndex:0];
									if(smallestDistanceN)
									{
										[mra setArray:[md objectForKey:smallestDistanceN]];
									}
								}
							}
							if([mra count]>1)
							{
								//  can't we filter out some of the candidates?
								//  we can do that by comparing the words before and after the candidate with what is expected
								//  
								if([after length])
								{
									//  In a first stage, we just compare the word before the synchronization candidate
									//  and the expected one, we have to store the distances
									//  This makes sense only if there is a word before for each 
									NSMutableDictionary * md = [NSMutableDictionary dictionary];
									//  the keys are the edit distances
									//  the values are mutable arrays containing the candidates for that edit distance
									NSEnumerator * E = [[[mra copy] autorelease] objectEnumerator];
									unsigned int rangeIndex;
									while((V = [E nextObject]))
									{
										rangeIndex = [(NSNumber *)V unsignedIntValue];
										if(rangeIndex+1<[wordRanges count])
										{
											V = [wordRanges objectAtIndex:rangeIndex+1];
											NSRange R = [V rangeValue];
											NSString * beforeCandidate = [pageString substringWithRange:R];
											unsigned int editDistance = [before iTM2_editDistanceToString:beforeCandidate];
											NSNumber * N = [NSNumber numberWithUnsignedInt:editDistance];
											NSMutableArray * mra1 = [md objectForKey:N];
											if(!mra1)
											{
												mra1 = [NSMutableArray array];
												[md setObject:mra1 forKey:N];
											}
											[mra1 addObject:V];

										}
										else
										{
											[md setDictionary:[NSDictionary dictionary]];// nil?
											break;
										}
									}
									NSNumber * smallestDistanceN = [[[md allKeys] sortedArrayUsingSelector:@selector(compare:)] objectAtIndex:0];
									if(smallestDistanceN)
									{
										[mra setArray:[md objectForKey:smallestDistanceN]];
									}
								}
							}
							NSEnumerator * E = [mra objectEnumerator];
							while((V = [E nextObject]))
							{
								unsigned int rangeIndex = [(NSNumber *)V unsignedIntValue];
								// retrive the range value now
								V = [wordRanges objectAtIndex:rangeIndex];
								NSRange R = [V rangeValue];
								NSRect bounds = [page characterBoundsAtIndex:R.location];
								PDFDestination * destination = [[[PDFDestination allocWithZone:[self zone]] initWithPage:page atPoint:bounds.origin] autorelease];
								[_SyncDestinations addObject:destination];
							}
							[self setNeedsDisplay:YES];
							[self scrollSynchronizationPointToVisible:self];
							return YES;
						}
					}
				}
			}
		}
#elif 1
		//  the idea is to find all the matches of the character hitted in the text view
		//  then filter out the most probable occurrences until only one is left if possible
		//  The filter is done by some kind of penalty
		//  We test each character that is next to the hit character and see if we can find it
		//  in the output near the match.
		//  If we can find one, we add a small penalty, bigger if the character is not at the correct position
		//  We first try to filter out only characters to the right of the hit point
		//  then to the left
		NSMutableDictionary * MD = [NSMutableDictionary dictionary];
		//  In this dictionary, keys are the PDF page indexes
		NSNumber * K = nil;
		//  values are arrays
		NSMutableArray * MRA = nil;
		//  the first object is the page object
		//  the other object are wrappers over nodes for that page
		
		//  values are mutable dictionaries with the pdf page object and the penalties
		//  First fill out everything
		if((first_node = synctex_next_result(scanner)))
		{
			NSValue * V;
			node = first_node;
			do
			{
				pageIndex = synctex_node_page(node)-1;
				if(pageIndex>=[document pageCount])
				{
					continue;
				}
				page = [document pageAtIndex:pageIndex];
				V = [NSValue valueWithNonretainedObject:page];
				MRA = [MD objectForKey:V];
				if(!MRA)
				{
					MRA = [NSMutableArray array];
					[MRA addObject:page];
					[MD setObject:MRA forKey:V];
				}
				[MRA addObject:[NSValue valueWithPointer:node]];
			} while((node = synctex_next_result(scanner)));
			NSEnumerator * pE = [MD keyEnumerator];
			NSMutableDictionary * matchRanges = [NSMutableDictionary dictionary];
			NSEnumerator * E = nil;
			NSRange lineRange;
			while(K = [pE nextObject])
			{
				MRA = [MD objectForKey:K];
				E = [[[MRA copy] autorelease] objectEnumerator];
				[MRA removeAllObjects];
				page = [E nextObject];
				NSString * pageString = [page string];
				while((node = [[E nextObject] pointerValue]))
				{
					// get the full line text of the click
					float tmp = synctex_node_box_visible_width(node);
					float top;
					NSPoint PP;
next_attempt:
					tmp = synctex_node_box_visible_width(node);
					if(tmp<0)
					{
						top = synctex_node_box_visible_h(node);
						PP.x = top+tmp;
					}
					else
					{
						PP.x = synctex_node_box_visible_h(node);
						top = PP.x+tmp;
					}
					PP.y = synctex_node_box_visible_v(node)+(synctex_node_box_visible_depth(node)-synctex_node_box_visible_height(node))/2;
					PP.y = NSMaxY([page boundsForBox:kPDFDisplayBoxMediaBox]) - PP.y;
					NSPoint Q = PP;
					Q.y+=1;
					PDFSelection * destination = nil;
					while(nil == (destination = [page selectionForWordAtPoint:Q]))
					{
						if((Q.x+=5)>top)
						{
							// second attempt
							Q = PP;
							while(nil == (destination = [page selectionForLineAtPoint:Q]))
							{
								if((Q.x+=5)>top)
								{
									if((node = synctex_node_parent(node)))
									{
										goto next_attempt;
									}
									goto next_chance;
								}
							}
						}
					}
					NSRect bounds = [destination boundsForPage:page];
					bounds.origin.y += 1;
					lineRange.location = [page characterIndexAtPoint:bounds.origin];
					lineRange.length = 0;
					[pageString getLineStart:(unsigned *)&(lineRange.location) end:nil contentsEnd:(unsigned *)&(lineRange.length) forRange:lineRange];
					lineRange.length -= lineRange.location;
					V = [NSValue valueWithRange:lineRange];
					if(![MRA containsObject:V])
					{
						[MRA addObject:V];
					}
next_chance:;
				}
				E = [[[MRA copy] autorelease] objectEnumerator];
				[MRA removeAllObjects];
				while((V = [E nextObject]))
				{
					lineRange = [V rangeValue];
					NSString * lineString = [pageString substringWithRange:lineRange];
					// Is the hit character in this line?
					unsigned charIndex = 0;
					while(charIndex<[lineString length])
					{
						if([lineString characterAtIndex:charIndex]==[container characterAtIndex:hereIndex])
						{
							[MRA addObject:[NSValue valueWithRange:NSMakeRange(charIndex+lineRange.location,1)]];
						}
						++charIndex;
					}
				}
				if([MRA count]==1)
				{
					[matchRanges setObject:MRA forKey:K];
				}
				else
				{
					if([MRA count]>1)
					{
						NSMutableDictionary * MD = [NSMutableDictionary dictionary];
						E = [[[MRA copy] autorelease] objectEnumerator];
						while((V = [E nextObject]))
						{
							lineRange = [V rangeValue];
							lineRange = [pageString doubleClickAtIndex:lineRange.location];
							NSString * w = [pageString substringWithRange:lineRange];
							NSNumber * N = [NSNumber numberWithUnsignedInt:[here iTM2_editDistanceToString:w]];
							NSMutableArray * mra = [MD objectForKey:N];
							if(!mra)
							{
								mra = [NSMutableArray array];
								[MD setObject:mra forKey:N];
							}
							[mra addObject:V];
						}
						E = [[[MD allKeys] sortedArrayUsingSelector:@selector(compare:)] objectEnumerator];
						if((V = [E nextObject]))
						{
							[matchRanges setObject:[MD objectForKey:V] forKey:K];
						}
						else
						{
							goto last_chance;
						}
					}
				}
			}
			[_SyncDestinations removeAllObjects];
			E = [matchRanges keyEnumerator];
			if(V = [E nextObject])
			{
				do
				{
					page = [V nonretainedObjectValue];
					NSEnumerator * e = [[matchRanges objectForKey:V] objectEnumerator];
					while(V = [e nextObject])
					{
						lineRange = [V rangeValue];
						NSRect bounds = [page characterBoundsAtIndex:lineRange.location];
						PDFDestination * destination = [[[PDFDestination allocWithZone:[self zone]] initWithPage:page atPoint:bounds.origin] autorelease];
						[_SyncDestinations addObject:destination];
					}
				}
				while(V = [E nextObject]);
				[self setNeedsDisplay:YES];
				[self scrollSynchronizationPointToVisible:self];
				return YES;
			}
		}
#else
		while((node = synctex_next_result(scanner)))
		{
			if(!first_node)
			{
				first_node = node;
			}
			pageIndex = synctex_node_page(node)-1;
			if(pageIndex>=[document pageCount])
			{
				continue;
			}
			page = [document pageAtIndex:pageIndex];
			// get the full line text of the click
			float tmp = synctex_node_box_visible_width(node);
			float top;
			NSPoint PP;
			if(tmp<0)
			{
				top = synctex_node_box_visible_h(node);
				PP.x = top+tmp;
			}
			else
			{
				PP.x = synctex_node_box_visible_h(node);
				top = PP.x+tmp;
			}
			PP.y = synctex_node_box_visible_v(node)+(synctex_node_box_visible_depth(node)-synctex_node_box_visible_height(node))/2;
			PP.y = NSMaxY([page boundsForBox:kPDFDisplayBoxMediaBox]) - PP.y;
			NSPoint Q = PP;
			PDFSelection * destination = nil;
			while(nil == (destination = [page selectionForLineAtPoint:Q]))
			{
				if((Q.x+=5)>top)
				{
					destination = [[[PDFDestination allocWithZone:[self zone]] initWithPage:page atPoint:PP] autorelease];
					[_SyncDestinations removeAllObjects];
					[_SyncDestinations addObject:destination];
					[self setNeedsDisplay:YES];
					[self scrollSynchronizationPointToVisible:self];
					return YES;
				}
			}
			NSRect bounds = [destination boundsForPage:page];
			bounds.origin.y += 1;
			NSRange lineRange;
			lineRange.location = [page characterIndexAtPoint:bounds.origin];
			lineRange.length = 0;
			NSString * SS = [page string];
			[SS getLineStart:(unsigned *)&(lineRange.location) end:nil contentsEnd:(unsigned *)&(lineRange.length) forRange:lineRange];
			lineRange.length -= lineRange.location;
			NSString * lineString = [SS substringWithRange:lineRange];
			// Is the here word in this line?
			NSMutableArray * matchRanges = [NSMutableArray array];
			NSRange searchRange,findRange;
			findRange = NSMakeRange(0,0);
nextMatch:
			searchRange.location = NSMaxRange(findRange);
			searchRange.length = [lineString length] - searchRange.location;
			findRange = [lineString rangeOfString:here options:0L range:searchRange];
			if(findRange.length)
			{
				[matchRanges addObject:[NSValue valueWithRange:findRange]];
				goto nextMatch;
			}
			NSEnumerator * E = [matchRanges objectEnumerator];
			NSValue * V;
			if(V = [E nextObject])
			{
				hereOffset += lineRange.location;
				[_SyncDestinations removeAllObjects];
				do
				{
					findRange = [V rangeValue];
					NSRect bounds = [page characterBoundsAtIndex:hereOffset+findRange.location];
					destination = [[[PDFDestination allocWithZone:[self zone]] initWithPage:page atPoint:bounds.origin] autorelease];
					[_SyncDestinations addObject:destination];
				}
				while(V = [E nextObject]);
				[self setNeedsDisplay:YES];
				[self scrollSynchronizationPointToVisible:self];
				return YES;
			}
		}
#endif
last_chance:
		if(first_node)
		{
			pageIndex = synctex_node_page(first_node)-1;
			if(pageIndex>=[document pageCount])
			{
				return NO;
			}
			page = [document pageAtIndex:pageIndex];
			[_SyncDestinations removeAllObjects];
			NSPoint P = NSMakePoint(synctex_node_box_visible_h(first_node),synctex_node_box_visible_v(first_node));
			P.y = NSMaxY([page boundsForBox:kPDFDisplayBoxMediaBox]) - P.y;
			if(!_SyncDestinations)
			{
				_SyncDestinations = [[NSMutableArray array] retain];
			}
			[_SyncDestinations addObject:[[[PDFDestination allocWithZone:[self zone]] initWithPage:page atPoint:P] autorelease]];
			[self setNeedsDisplay:YES];
			[self scrollSynchronizationPointToVisible:self];
			return YES;
		}
	}
//iTM2_END;
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= __synchronizeWithStoredDestinationsAndHints:
- (BOOL)__synchronizeWithStoredDestinationsAndHints:(id)irrelevant;
/*"Description Forthcoming. NOT THREADED (problems)
Version History:jlaurens AT users DOT sourceforge DOT net
- < 1.1:03/10/2002
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
		PDFDestination * oldDestination = [_SyncDestinations count]?[_SyncDestinations objectAtIndex:0]:nil;
		[L unlock];
		[L release];
		L = nil;
		NSString * S = [hint objectForKey:@"container"];
		if(S)
		{
			// okay guyes, let's go to the party.
			// if we are working on SyncTeX, things are a bit more comfortable,
			// the switch occurred some time ago
			// use the selected ranges to narrow the search
			NSValue * V = [hint objectForKey:@"old selected range"];
			if(V)
			{
				NSRange oldRange = [V rangeValue];
				if(V = [hint objectForKey:@"new selected range"])
				{
					NSRange newRange = [V rangeValue];
					newRange = NSUnionRange(oldRange,newRange);
					if(newRange.length>1000)
					{
						oldDestination = nil;
					}
				}
			}
			// we just use the hint to find words before and after the hint and switch to the appropriate _synchronize... method
			unsigned int hereIndex = [[hint objectForKey:@"character index"] unsignedIntValue];// The mousedown occurred here.
			if(hereIndex < [S length])
			{
				NSString * beforeWord;
				NSString * hereWord;
				NSString * afterWord;
				unsigned int localHitIndex = [S getWordBefore:&beforeWord here:&hereWord after:&afterWord atIndex:hereIndex
					mode:[[[[[self window] windowController] document] synchronizer] isSyncTeX]];
				if(iTM2DebugEnabled)
				{
					iTM2_LOG(@"####  hit sequence:%@ + %@ + %@, (index:%i)", beforeWord, hereWord, afterWord, hereIndex);
				}
				// using the hint to narrow the search
				//
				// branching code
				if(localHitIndex == NSNotFound)
				{
					// It is a control
				}
				else if([beforeWord length])
				{
					if([hereWord length])
					{
						if([afterWord length])
						{
							result = [self _synchronizeWithDestinations:destinations before:beforeWord here:hereWord after:afterWord index:localHitIndex oldDestination:oldDestination];
						}
						else
						{
							result = [self _synchronizeWithDestinations:destinations before:beforeWord here:hereWord index:localHitIndex oldDestination:oldDestination];
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
						result = [self _synchronizeWithDestinations:destinations here:hereWord after:afterWord index:localHitIndex oldDestination:oldDestination];
					}
					else
					{
						result = [self _synchronizeWithDestinations:destinations here:hereWord index:localHitIndex oldDestination:oldDestination];
					}
				}
			}
		}
		if(result || (destinations && (result = [self _synchronizeWithDestinations:destinations])))
		{
			[self setNeedsDisplay:YES];
		}
		iTM2_RELEASE_POOL;
		goto startAgain;
	}
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
Version History:jlaurens AT users DOT sourceforge DOT net
- < 1.1:03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(iTM2DebugEnabled>200)
	{
		iTM2_LOG(@"destinations:%@",destinations);
		iTM2_LOG(@"hint:%@",hint);
	}
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
	[NSThread detachNewThreadSelector:@selector(__threadedSynchronizeWithStoredDestinationsAndHints:)
		toTarget:self withObject:nil];
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
Version History:jlaurens AT users DOT sourceforge DOT net
- < 1.1:03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[_SyncDestination autorelease];
	_SyncDestination = nil;
	[_SyncPointValues autorelease];
	_SyncPointValues = nil;
	if(aCurrentPhysicalPage<0)
		return NO;// no hint for the page, I do not synchronize yet
	iTM2XtdPDFDocument * document = (iTM2XtdPDFDocument *)[self document];
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
					NSString * word = [S substringToIndex:charIndex];
					word = [word precomposedStringWithCompatibilityMapping];
					NSString * afterWord = [S substringFromIndex:charIndex];
					afterWord = [afterWord precomposedStringWithCompatibilityMapping];
					charIndex = [word length];
					S = [word stringByAppendingString:afterWord];
					NSRange wordRange = [S doubleClickAtIndex:charIndex];
					if(wordRange.length)
					{
						word = [S substringWithRange:wordRange];
						NSRange previousWordRange = NSMakeRange(0, 0);
						int clickIndex = wordRange.location;
						if(clickIndex>2)
						{
							clickIndex -= 2;
							previousWordRange = [S doubleClickAtIndex:clickIndex];
							if(!previousWordRange.length && clickIndex)
							{
								previousWordRange = [S doubleClickAtIndex:--clickIndex];
								if(!previousWordRange.length && clickIndex)
								{
									previousWordRange = [S doubleClickAtIndex:--clickIndex];
								}
							}
						}
						NSString * previousWord = [S substringWithRange:previousWordRange];
//iTM2_LOG(@"previous word:%@", previousWord);
						NSRange nextWordRange = NSMakeRange(0, 0);
						clickIndex = NSMaxRange(wordRange);
						if(clickIndex < [S length] - 2)
						{
							clickIndex += 2;
							nextWordRange = [S doubleClickAtIndex:clickIndex];
							if(!nextWordRange.length && clickIndex)
							{
								nextWordRange = [S doubleClickAtIndex:++clickIndex];
								if(!nextWordRange.length && clickIndex)
								{
									nextWordRange = [S doubleClickAtIndex:++clickIndex];
								}
							}
						}
						NSString * targetString = [document stringForPage:page];
//iTM2_LOG(@"targetString:%@", targetString);
						NSRange R = NSMakeRange(0, [targetString length]);
						NSMutableArray * pointValues   = [NSMutableArray array];// matching word
						NSMutableArray * pointValues10 = [NSMutableArray array];// matching previous word too
						more:
						R = [targetString rangeOfString:word options:0L range:R];
						if(R.length)
						{
//iTM2_LOG(@"a string was found:%@ range:%@", [targetString substringWithRange:R], NSStringFromRange(R));
							if(NSEqualRanges([targetString doubleClickAtIndex:R.location], R))
							{
								NSRect characterBounds = [page characterBoundsAtIndex:R.location + MIN(1 + charIndex - wordRange.location, [targetString length]) - 1];
								NSValue * pointValue = [NSValue valueWithPoint:characterBounds.origin];
								[pointValues addObject:pointValue];
								// is the previous word available?
								int clickIndex = R.location;
								NSString * previousW = (clickIndex>2)?
									[targetString substringWithRange:[targetString doubleClickAtIndex:clickIndex-2]]:@"";
								if([previousW isEqualToString:previousWord])
								{
									[pointValues10 addObject:pointValue];
								}
								else if(iTM2DebugEnabled)
								{
									iTM2_LOG(@"previous word match:%@", previousW);
								}
							}
							else if(iTM2DebugEnabled)
							{
								iTM2_LOG(@"No word match:%@", [targetString substringWithRange:[targetString doubleClickAtIndex:R.location]]);
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
					NSString * targetString = [document stringForPage:page];
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
Version History:jlaurens AT users DOT sourceforge DOT net
- 1.3:03/10/2002
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  trackMove:
- (BOOL)trackMove:(NSEvent *)theEvent;
/*"Description forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- 1.3:Thu Jul 17 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSWindow * window = [self window];
	NSView * documentView = [self documentView];
	NSRect bounds = [documentView bounds];
	NSRect mainScreenFrame = [[NSScreen mainScreen] visibleFrame];
	NSScrollView * scrollView = [documentView enclosingScrollView];
	NSClipView * clipView = [scrollView contentView];
	NSPoint oldHit = [window mouseLocationOutsideOfEventStream];
	BOOL scroll = NO;
	[[NSCursor closedHandCursor] set];
mainLoop:
	theEvent = [window nextEventMatchingMask:NSLeftMouseUpMask | NSLeftMouseDraggedMask | NSScrollWheelMask | NSApplicationDefinedMask];
	if([theEvent type] == NSLeftMouseUp)
	{
#if 1
		id WC = [window windowController];
		if([WC respondsToSelector:@selector(setDocumentViewVisibleRect:)])
		{
			NSRect visibleRect = [documentView visibleRect];
			visibleRect = [documentView absoluteRectWithRect:visibleRect];
			[WC setDocumentViewVisibleRect:visibleRect];
		}
#endif
		[self setCursorForAreaOfInterest:[self areaOfInterestForMouse:theEvent]];
		return YES;
	}
	[window discardEventsMatchingMask:NSLeftMouseDraggedMask | NSScrollWheelMask | NSApplicationDefinedMask beforeEvent:nil];
	NSPoint newHit = [window mouseLocationOutsideOfEventStream];
	NSRect visibleRect = [clipView visibleRect];
	// removing the scroll views
	visibleRect = [scrollView convertRect:visibleRect fromView:clipView];
	visibleRect.size.width -= [[scrollView verticalScroller] frame].size.width;
	visibleRect.size.height -= [[scrollView horizontalScroller] frame].size.height;
	visibleRect = [documentView convertRect:visibleRect fromView:scrollView];
	NSRect  dontScrollRect = NSInsetRect(visibleRect,SCROLL_LAYER,SCROLL_LAYER);
	NSPoint scrollOffset = NSZeroPoint;
	NSPoint location = [documentView convertPoint:newHit fromView:nil];
	NSPoint point = NSZeroPoint;
	float f,g;
	if((0<(g=location.x-NSMaxX(dontScrollRect))) && (0<(f=NSMaxX(bounds)-NSMaxX(visibleRect))))
	{
		point = NSMakePoint(NSMaxX(mainScreenFrame),NSMidY(mainScreenFrame));
		point = [window convertScreenToBase:point];
		point = [documentView convertPoint:point fromView:nil];
		point.x -= NSMaxX(dontScrollRect);
		g/=point.x;
		scrollOffset.x=MIN(f+10,SCROLL_DIMEN*powf(g,SCROLL_COEFF));
		scroll = newHit.x>oldHit.x || (scroll && newHit.x==oldHit.x);
	}
	else if((0<(g=NSMinX(dontScrollRect)-location.x)) && (0<(f=NSMinX(visibleRect)-NSMinX(bounds))))
	{
		point = NSMakePoint(NSMinX(mainScreenFrame),NSMidY(mainScreenFrame));
		point = [window convertScreenToBase:point];
		point = [documentView convertPoint:point fromView:nil];
		point.x -= NSMinX(dontScrollRect);
		g/=-point.x;
		scrollOffset.x=-MIN(f+10,SCROLL_DIMEN*powf(g,SCROLL_COEFF));
		scroll = newHit.x<oldHit.x || (scroll && newHit.x==oldHit.x);
	}
	if((0<(g=location.y-NSMaxY(dontScrollRect))) && (0<(f=NSMaxY(bounds)-NSMaxY(visibleRect))))
	{
		point = NSMakePoint(NSMidX(mainScreenFrame),NSMaxY(mainScreenFrame));
		point = [window convertScreenToBase:point];
		point = [documentView convertPoint:point fromView:nil];
		point.y -= NSMaxY(dontScrollRect);
		g/=point.y;
		scrollOffset.y=MIN(f+10,SCROLL_DIMEN*powf(g,SCROLL_COEFF));
		scroll = newHit.y>oldHit.y || (scroll && newHit.y==oldHit.y);
	}
	else if((0<(g=NSMinY(dontScrollRect)-location.y)) && (0<(f=NSMinY(visibleRect)-NSMinY(bounds))))
	{
		point = NSMakePoint(NSMidX(mainScreenFrame),NSMinY(mainScreenFrame));
		point = [window convertScreenToBase:point];
		point = [documentView convertPoint:point fromView:nil];
		point.y -= NSMinY(dontScrollRect);
		g/=-point.y;
		scrollOffset.y=-MIN(f+10,SCROLL_DIMEN*powf(g,SCROLL_COEFF));
		scroll = newHit.y<oldHit.y || (scroll && newHit.y==oldHit.y);
	}
//	anchor = MLOES;
//	handle = [documentView convertPoint:MLOES fromView:nil];
	if(scroll)
	{
		oldHit.x-=scrollOffset.x;
		oldHit.y-=scrollOffset.y;
		theEvent = [NSEvent otherEventWithType:NSApplicationDefined
						location:newHit
							modifierFlags:0
								timestamp:0
									windowNumber:[window windowNumber]
										context:nil
											subtype:0
												data1:0
													data2:0];
		[window postEvent:theEvent atStart:NO];
	}
//
	location = [clipView bounds].origin;
	location = [clipView convertPoint:location toView:nil];
	location.x -= newHit.x - oldHit.x;
	location.y -= newHit.y - oldHit.y;
	location = [clipView convertPoint:location fromView:nil];
	[clipView scrollPoint:location];
	oldHit = newHit;
	goto mainLoop;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  mouseDown:
- (void)mouseDown:(NSEvent *)theEvent;
/*"Description forthcoming.
The time line, the when...
It is important to known when event occurs and when tasks should be performed.
The time line is extremely important for that.
Here is a model:
event time line
event1---event2---event3...
tasks time line
task1---task2---task3...
If we don't know exactly when tasks should be performed, we have at least informations
about a partial order.
We must think of a tree/graph more seriously.
If a node is splitted into more branches, the ones with slope>=0 are ordered from slope 0 to slope +∞
and the ones with slope < 0 are not ordered.
Version history:jlaurens AT users DOT sourceforge DOT net
- 1.3:Thu Jul 17 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if([theEvent clickCount] > 0)
	{
		unsigned int modifierFlags = [theEvent modifierFlags];
		if(modifierFlags & NSCommandKeyMask)
		{
			if(modifierFlags & (NSShiftKeyMask|NSAlternateKeyMask))
			{
				NSWindow * window = [self window];
				float timeInterval = [SUD floatForKey:@"com.apple.mouse.doubleClickThreshold"];
				NSEvent * otherEvent;
				if((otherEvent = [window nextEventMatchingMask:NSLeftMouseUpMask untilDate:[NSDate dateWithTimeIntervalSinceNow:timeInterval] inMode:NSEventTrackingRunLoopMode dequeue:YES]))
				{
					int n = 100 * ([self contextFloatForKey:iTM2PDFKitZoomFactorKey domain:iTM2ContextAllDomainsMask]>0?:1.259921049895);
					if(n>0)
					{
						float zoom = (modifierFlags & NSShiftKeyMask)?n/100.0:100.0/n;
						NSView * docView = [self documentView];
						NSPoint oldHit = [theEvent locationInWindow];
						oldHit = [docView convertPoint:oldHit fromView:nil];
						NSRect oldBounds = [docView bounds];
						NSRect oldVisible = [docView visibleRect];
						[self setScaleFactor:zoom*[self scaleFactor]];
						NSRect newBounds = [docView bounds];
						NSRect newVisible = [docView visibleRect];
						NSPoint newHit;
						newHit.x = NSMidX(newBounds)+(oldHit.x-NSMidX(oldBounds))*newBounds.size.width/oldBounds.size.width;
						newHit.y = NSMidY(newBounds)+(oldHit.y-NSMidY(oldBounds))*newBounds.size.height/oldBounds.size.height;
						NSPoint expectedHit;
						expectedHit.x = NSMidX(newVisible)+(oldHit.x-NSMidX(oldVisible))*newVisible.size.width/oldVisible.size.width;
						expectedHit.y = NSMidY(newVisible)+(oldHit.y-NSMidY(oldVisible))*newVisible.size.height/oldVisible.size.height;
						newVisible.origin.x-=expectedHit.x-newHit.x;
						newVisible.origin.y-=expectedHit.y-newHit.y;
						[docView scrollRectToVisible:newVisible];
						[self validateWindowContent];
						id WC = [window windowController];
						if([WC respondsToSelector:@selector(setDocumentViewVisibleRect:)])
						{
							NSRect visibleRect = [docView visibleRect];
							visibleRect = [docView absoluteRectWithRect:visibleRect];
							[WC setDocumentViewVisibleRect:visibleRect];
						}
					}
				}
				else if(![self trackZoom:theEvent])
				{
					[super mouseDown:theEvent];
				}
			}
			else
			{
				[self pdfSynchronizeMouseDown:theEvent];
			}
//iTM2_END;
			return;
		}
		switch([self toolMode])
		{
			case kiTM2SelectToolMode:
			{
				iTM2_LOG(@"ERROR(minor):The iTM2PDFKitView is not expected to receive a mouseDown:message in kiTM2SelectToolMode...");
				return;
			}
			case kiTM2ScrollToolMode:
				if([self trackMove:theEvent])
				{
					return;
				}
			default:
				break;
			/*
			case kiTM2TextToolMode:
			case kiTM2AnnotateToolMode:
				[super mouseDown:theEvent];
			*/
		}
	}
//iTM2_LOG(@"[theEvent clickCount] is:%i", [theEvent clickCount]);
    [super mouseDown:theEvent];
//iTM2_END;
    return;
}
@end

@interface NSDocument(iTM2Private)
- (void)orderFrontCurrentSource;
@end

@implementation PDFView(iTM2SynchronizationKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toolMode
- (iTM2ToolMode)toolMode;
{
	return kiTM2SelectToolMode;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setToolMode:
- (void)setToolMode:(iTM2ToolMode)argument;
{
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= zoomToFit:
- (void)zoomToFit:(id)sender;
/*"Description forthcoming.
Version History:jlaurens AT users DOT sourceforge DOT net
- 2.0:Wed Jan  5 17:41:55 GMT 2005
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
Version History:jlaurens AT users DOT sourceforge DOT net
- < 1.1:03/10/2002
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
Version History:jlaurens AT users DOT sourceforge DOT net
- 1.3:03/10/2002
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
Version History:jlaurens AT users DOT sourceforge DOT net
- 1.3:03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  pdfSynchronizeMouseDown:
- (void)pdfSynchronizeMouseDown:(NSEvent *)theEvent;
/*"Description forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- 1.3:Thu Jul 17 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([theEvent clickCount] > 1)
	{
		// just switch to current source
		NSDocument * D = [[[self window] windowController] document];
		if([D respondsToSelector:@selector(orderFrontCurrentSource)])
		{
			[D orderFrontCurrentSource];
			return;
		}
	}
	NSPoint point = [self convertPoint:[theEvent locationInWindow] fromView:nil];
	iTM2XtdPDFDocument * document = (iTM2XtdPDFDocument *)[self document];
	PDFPage * page = [self pageForPoint:point nearest:NO];
	if(page)
	{
		point = [self convertPoint:point toPage:page];
		int charIndex = [page characterIndexNearPoint:point];
// there is a bug in
//				PDFSelection * SELECTION = [page selectionForRange:NSMakeRange(charIndex, 1)];
//iTM2_LOG(@"................ character:%@, point:%@, bounds:%@", [[page string] substringWithRange:NSMakeRange(charIndex, 1)], NSStringFromPoint(point), (SELECTION? NSStringFromRect([SELECTION boundsForPage:page]):@"No rect"));
		NSString * container = [document stringForPage:page];
		NSMutableDictionary * hint = [NSMutableDictionary dictionaryWithObjectsAndKeys:
				[NSValue valueWithPoint:point], @"hit point",
				container, @"container",
				page, @"page",
				[NSValue valueWithRect:[page boundsForBox:kPDFDisplayBoxMediaBox]],@"page bounds",
				[NSNumber numberWithBool:[[[self window] windowController] strongerSynchronization]],@"StrongerSynchronization",
					nil];
		if(charIndex >= 0)
		{
			[hint setObject:[NSNumber numberWithInt:charIndex] forKey:@"character index"];
		}
		unsigned int pageIndex = [[page document] indexForPage:page];
		PDFSelection * selection;
		NSRect bounds;
		NSValue * V;
		if(selection = [page selectionForWordAtPoint:point])
		{
			bounds = [selection boundsForPage:page];
			V = [NSValue valueWithRect:bounds];
			[hint setObject:V forKey:@"word bounds"];
		}
		if(selection = [page selectionForLineAtPoint:point])
		{
			NSRect lineBounds = [selection boundsForPage:page];
			NSPoint P = point;
			P.y += lineBounds.size.height * 1.1;
			if(selection = [page selectionForLineAtPoint:point])
			{
				bounds = [selection boundsForPage:page];
				bounds.origin.y = lineBounds.origin.y;
				bounds.size.height = lineBounds.size.height;
				lineBounds = NSUnionRect(bounds, lineBounds);
			}
			P.y = point.y - lineBounds.size.height * 1.1;
			if(selection = [page selectionForLineAtPoint:point])
			{
				bounds = [selection boundsForPage:page];
				bounds.origin.y = lineBounds.origin.y;
				bounds.size.height = lineBounds.size.height;
				lineBounds = NSUnionRect(bounds, lineBounds);
			}
			V = [NSValue valueWithRect:lineBounds];
			[hint setObject:V forKey:@"line bounds"];
		}
		[[[[self window] windowController] document]
			synchronizeWithLocation:point inPageAtIndex:pageIndex withHint:hint orderFront:NO];
	}
//iTM2_LOG(@"[theEvent clickCount] is:%i", [theEvent clickCount]);
//iTM2_END;
	return;
}
@end

@implementation __iTM2PDFZoominView
- (void)drawRect:(NSRect)aRect;
{
	[NSGraphicsContext saveGraphicsState];
	NSRect rect = [self bounds];
	rect = NSIntersectionRect(rect,aRect);
	rect = NSInsetRect(rect,10.005,10.005);
	NSBezierPath * path = [NSBezierPath bezierPathWithRect:aRect];
	[path appendBezierPathWithRect:rect];
	[path setWindingRule:NSEvenOddWindingRule];
	[path addClip];
	[[NSColor blueColor] set];
	NSShadow* theShadow = [[NSShadow alloc] init];
	[theShadow setShadowOffset:NSMakeSize(0,([self isFlipped]?2:-2))]; 
	[theShadow setShadowBlurRadius:8.0]; 
	[theShadow setShadowColor:[[NSColor blackColor] colorWithAlphaComponent:1]]; 
	[theShadow set];
	path = [NSBezierPath bezierPathWithRect:rect];
	[path fill];
	[NSGraphicsContext restoreGraphicsState];
	return;
}
@end

@implementation __iTM2PDFKitSelectView
// these three are for cursor rects
- (id)initWithFrame:(NSRect)frameRect;
{
	if(self = [super initWithFrame:frameRect])
	{
		[self setAutoresizingMask:NSViewWidthSizable|NSViewHeightSizable];
		_active = NO;
		_tracking = NO;
		// _subview tracks the selection rect
		[_subview removeFromSuperviewWithoutNeedingDisplay];
		_subview = [[[NSView allocWithZone:[self zone]] initWithFrame:NSMakeRect(0,0,1,1)] autorelease];// faraway rect
		[_subview setAutoresizingMask:NSViewMinXMargin|NSViewWidthSizable|NSViewMaxXMargin|NSViewMinYMargin|NSViewHeightSizable|NSViewMaxYMargin];
		[self addSubview:_subview];
		[_subview setHidden:YES];
	}
	return self;
}
- (void)dealloc;
{
	[_cachedShadow release];
	_cachedShadow = nil;
	[super dealloc];
	return;
}
- (NSRect)selectionRect;
{
	return [_subview frame];
}
- (void)setBoundsOrigin:(NSPoint)newOrigin;
{
	[super setBoundsOrigin:newOrigin];
	[_cachedShadow release];
	_cachedShadow = nil;
	return;
}
- (void)setBoundsSize:(NSSize)newSize;
{
	[super setBoundsSize:newSize];
	[_cachedShadow release];
	_cachedShadow = nil;
	return;
}
- (void)setBoundsRotation:(float)angle;
{
	[super setBoundsRotation:angle];
	[_cachedShadow release];
	_cachedShadow = nil;
	return;
}
- (void)setSelectionRect:(NSRect)aRect;
{
	// selection rect post processing
	if(aRect.size.width<1.11 || aRect.size.height<1.11)
	{
		_active = NO;
	}
	else
	{
		_active = YES;
		[_subview setFrame:aRect];
		[_cachedShadow release];
		_cachedShadow = nil;
	}
	[self setNeedsDisplay:YES];
	return;
}
- (BOOL)acceptsFirstResponder
{
	return [[self superview] acceptsFirstResponder];
}
- (BOOL)becomeFirstResponder;
{
	return [[self superview] becomeFirstResponder];
}
- (BOOL)resignFirstResponder;
{
	return [[self superview] resignFirstResponder];
}
- (void)drawRect:(NSRect)aRect;
{
	[NSGraphicsContext saveGraphicsState];
	if(_active)
	{
		//[[NSGraphicsContext currentContext] setCompositingOperation:(NSCompositingOperation)operation;
		NSBezierPath * path = [NSBezierPath bezierPathWithRect:aRect];
		[path setLineWidth:1.0];
		//float lineDash[] = {2.0,3.0};
		//[path setLineDash:lineDash count:2 phase:0.0];
		NSRect selectionRect = [self selectionRect];
		selectionRect = NSInsetRect(selectionRect,0.005,0.005);// necessary to have a good clipping region
		selectionRect = NSIntersectionRect(selectionRect,aRect);
		[path appendBezierPathWithRect:selectionRect];
		[path setWindingRule:NSEvenOddWindingRule];
		[path addClip];
		selectionRect = [self selectionRect];
		aRect = NSUnionRect(aRect,selectionRect);
		aRect = NSInsetRect(aRect,-10,-10);
		path = [NSBezierPath bezierPathWithRect:aRect];
		NSColor * C = [NSColor colorWithCalibratedRed:0.71 green:0.84 blue:1.0 alpha:0.3];
		[C set];
		[path fill];
		path = [NSBezierPath bezierPathWithRect:selectionRect];
		NSShadow* theShadow = [[NSShadow alloc] init]; 
		[theShadow setShadowOffset:NSMakeSize(0, ([self isFlipped]?2:-2))]; 
		[theShadow setShadowBlurRadius:8.0]; 
		[theShadow setShadowColor:[[NSColor blackColor] colorWithAlphaComponent:1]]; 
		[theShadow set];
		[path fill];
#if 0
		if(!_cachedShadow)
		{
			_cachedShadow = [[NSImage allocWithZone:[self zone]] initWithSize:[self bounds].size];
			[_cachedShadow lockFocus];
			path = [NSBezierPath bezierPathWithRect:selectionRect];
			[path fill];
			[_cachedShadow unlockFocus];
		}
		_cachedShadow
		NSShadow* theShadow = [[NSShadow alloc] init]; 
		[theShadow setShadowOffset:NSMakeSize(0, ([self isFlipped]?2:-2))]; 
		[theShadow setShadowBlurRadius:8.0]; 
		[theShadow setShadowColor:[[NSColor blackColor] colorWithAlphaComponent:1]]; 
		[theShadow set];
#endif
	//	[path stroke];
	//	[NSBezierPath strokeRect:selectionRect];
	}
	else if(_tracking)
	{
		//[[NSGraphicsContext currentContext] setCompositingOperation:(NSCompositingOperation)operation;
		NSBezierPath * path = [NSBezierPath bezierPathWithRect:aRect];
		NSColor * C = [NSColor colorWithCalibratedRed:0.71 green:0.84 blue:1.0 alpha:0.3];
		[C set];
		[path fill];
	//	[path stroke];
	//	[NSBezierPath strokeRect:selectionRect];
	}
	else if([SUD boolForKey:@"ShowPDFCharacterBounds"])
	{
		NSPoint center = NSMakePoint(NSMidX(aRect),NSMidY(aRect));
		PDFView * pdfView = (PDFView *)[self superviewMemberOfClass:[PDFView class]];
		PDFPage * page = [pdfView pageForPoint:[pdfView convertPoint:center fromView:self] nearest:NO];
		[[NSColor blueColor] set];
		NSRect R;
		if(page)
		{
			unsigned int index	= [page numberOfCharacters];
			while(index--)
			{
				R = [page characterBoundsAtIndex:index];
				R = [pdfView convertRect:R fromPage:page];
				R = [self convertRect:R fromView:pdfView];
				R = NSIntersectionRect(R,aRect);
				if(!NSIsEmptyRect(R)) [NSBezierPath strokeRect:R];
			}
		}
	}
	[NSGraphicsContext restoreGraphicsState];
	return;
}
- (NSView *)hitTest:(NSPoint)aPoint
{
	// accept only one type of events, this allows to keep the pdfView contextual menu while selecting
	NSEvent * theEvent = [[self window] currentEvent];
	unsigned int theModifiers = [theEvent modifierFlags] & NSDeviceIndependentModifierFlagsMask;
	return (theModifiers & NSControlKeyMask) || (theModifiers & NSCommandKeyMask) || ([theEvent type] != NSLeftMouseDown)?nil:[super hitTest:aPoint];
}
- (BOOL)dragSelection:(NSEvent *)theEvent;
{
	unsigned int modifierFlags = ([theEvent modifierFlags] ^ NSCommandKeyMask) & NSDeviceIndependentModifierFlagsMask;
	if(modifierFlags & NSAlternateKeyMask)
	{
		NSRect selectionRect = [self selectionRect];
		if(NSIsEmptyRect(selectionRect))
		{
			return NO;
		}
		NSPoint dragPosition = [theEvent locationInWindow];
		dragPosition = [self convertPoint:dragPosition fromView:nil];
		if(NSPointInRect(dragPosition,selectionRect))
		{
			dragPosition=selectionRect.origin;
			NSPasteboard *pasteboard = [NSPasteboard pasteboardWithName:NSDragPboard];
			[pasteboard declareTypes:[NSArray arrayWithObject:NSPDFPboardType]
					owner:nil];
			PDFView * pdfView = (PDFView *)[self superviewMemberOfClass:[PDFView class]];
			selectionRect = [self convertRect:selectionRect toView:pdfView];
			NSImage * dragImage = nil;
			NSPoint point = NSMakePoint(NSMidX(selectionRect),NSMidY(selectionRect));
			PDFPage * page = [pdfView pageForPoint:point nearest:NO];
			if(page)
			{
				selectionRect = [pdfView convertRect:selectionRect toPage:page];
				NSString * path = [[[[self window] windowController] document] fileName];
				NSData * data = [[[NSData allocWithZone:[self zone]] initWithContentsOfFile:path] autorelease];
				NSPDFImageRep * imageRep = [[[NSPDFImageRep allocWithZone:[self zone]] initWithData:data] autorelease];
				PDFDocument * document = [page document];
				int currentPage = [document indexForPage:page];
				[imageRep setCurrentPage:currentPage];
				NSRect pageBounds = [page boundsForBox:kPDFDisplayBoxMediaBox];
				NSRect repBounds = [imageRep bounds];
				if(NSIsEmptyRect(repBounds))
				{
					return NO;
				}
				// convert the selectionRect to the __iTM2PDFPrintView coordinates
				// the new selectionRect should be to the repBounds like the old one was to the page bounds
				selectionRect.origin.x = repBounds.origin.x + (selectionRect.origin.x - pageBounds.origin.x) * pageBounds.size.width/repBounds.size.width;
				selectionRect.origin.y = repBounds.origin.y + (selectionRect.origin.y - pageBounds.origin.y) * pageBounds.size.height/repBounds.size.height;
				selectionRect.size.width *= pageBounds.size.width/repBounds.size.width;
				selectionRect.size.height *= pageBounds.size.height/repBounds.size.height;
				__iTM2PDFPrintView * view = [[[__iTM2PDFPrintView allocWithZone:[self zone]] initWithFrame:repBounds] autorelease];
				view->representation = imageRep;
				NSData * pdfData = [view dataWithPDFInsideRect:selectionRect];
				//NSData * pdfData = [view dataWithPDFInsideRect:repBounds];
				view->representation = nil;
				if(modifierFlags & NSShiftKeyMask)
				{
					dragPosition = [theEvent locationInWindow];
					dragPosition = [self convertPoint:dragPosition fromView:nil];
					dragPosition.x -= 16;
					dragPosition.y -= 16;
					selectionRect.origin = dragPosition;
					selectionRect.size = NSMakeSize(32,32);
					NSString * name = [[[[self window] windowController] document] fileName];
					NSString * label = [page label];
					id FPC = [[[_PDFFilePromiseController allocWithZone:[self zone]] initWithName:name data:pdfData label:label] autorelease];
					return [self dragPromisedFilesOfTypes:[NSArray arrayWithObject:@"pdf"] fromRect:selectionRect source:FPC slideBack:YES event:theEvent];
				}
				else
				{
					[pasteboard setData:pdfData forType:NSPDFPboardType];
					NSImage * I = [[[NSImage allocWithZone:[self zone]] initWithData:pdfData] autorelease];
					selectionRect = [self selectionRect];
					[I setSize:selectionRect.size];
					[I setScalesWhenResized:YES];
					dragImage = [[[NSImage allocWithZone:[self zone]] initWithSize:selectionRect.size] autorelease];
					[dragImage lockFocus];
					[I compositeToPoint:NSZeroPoint operation:NSCompositeCopy fraction:0.5];
					[dragImage unlockFocus];
					[self dragImage:dragImage 
							at:dragPosition
							offset:NSZeroSize
							event:theEvent
							pasteboard:pasteboard
							source:self
							slideBack:YES];
					return YES;
				}
			}
		}
	}
	return NO;
}
#define TOP 1
#define BOTTOM 2
#define LEFT 4
#define RIGHT 8
- (void)mouseDown:(NSEvent *)theEvent;
{
	if([[[self window] firstResponder] isEqual:self])
	{
		if([self dragSelection:theEvent])
		{
			return;
		}
		// is it a drag operation to an external destination
		PDFView * pdfView = (PDFView *)[self superviewMemberOfClass:[PDFView class]];
		NSPoint mouseLoc = [theEvent locationInWindow];
		mouseLoc = [pdfView convertPoint:mouseLoc fromView:nil];
		PDFPage * page = [pdfView pageForPoint:mouseLoc nearest:NO];
		if(!page)
		{
			return;
		}
		_tracking = YES;// while tracking the drawRect:does not behave the same
		NSRect bounds = [page boundsForBox:kPDFDisplayBoxMediaBox];
		bounds = [pdfView convertRect:bounds fromPage:page];
		bounds = [self convertRect:bounds fromView:pdfView];
		// where did the hit occur?
		PDFAreaOfInterest area = [self areaOfInterestForMouse:theEvent];// extended
		if(area & kiTM2PDFSelectTopArea)
		{
			if(area & kiTM2PDFSelectLeftArea)
			{
				[self trackSelectionModify:theEvent boundary:TOP|LEFT inRect:bounds];
			}
			else if(area & kiTM2PDFSelectRightArea)
			{
				[self trackSelectionModify:theEvent boundary:TOP|RIGHT inRect:bounds];
			}
			else 
			{
				[self trackSelectionModify:theEvent boundary:TOP inRect:bounds];
			}
		}
		else if(area & kiTM2PDFSelectBottomArea)
		{
			if(area & kiTM2PDFSelectLeftArea)
			{
				[self trackSelectionModify:theEvent boundary:BOTTOM|LEFT inRect:bounds];
			}
			else if(area & kiTM2PDFSelectRightArea)
			{
				[self trackSelectionModify:theEvent boundary:BOTTOM|RIGHT inRect:bounds];
			}
			else 
			{
				[self trackSelectionModify:theEvent boundary:BOTTOM inRect:bounds];
			}
		}
		else
		{
			if(area & kiTM2PDFSelectLeftArea)
			{
				[self trackSelectionModify:theEvent boundary:LEFT inRect:bounds];
			}
			else if(area & kiTM2PDFSelectRightArea)
			{
				[self trackSelectionModify:theEvent boundary:RIGHT inRect:bounds];
			}
			else
			{
				if(area & kiTM2PDFSelectArea)
				{
					[self trackSelectionDrag:theEvent inRect:bounds];
				}
				else
				{
					[self trackSelectionCreate:theEvent inRect:bounds];
					[self _expandSelectionRectToContainWholeGlyphsInPage:page];
				}
			}
		}
		[[self window] resetCursorRects];
		_tracking = NO;// while tracking the drawRect:does not behave the same
	}
	else
	{
		[super mouseDown:theEvent];
	}
	return;
}
- (void)_expandSelectionRectToContainWholeGlyphsInPage:(PDFPage *)page;
{
	if(!page)
	{
		return;
	}
	PDFView * pdfView = (PDFView *)[self superviewMemberOfClass:[PDFView class]];
	NSRect bounds = [page boundsForBox:kPDFDisplayBoxMediaBox];
	NSRect selectionRect = [self selectionRect];
	selectionRect = [self convertRect:selectionRect toView:pdfView];
	selectionRect = [pdfView convertRect:selectionRect toPage:page];
	NSRect xtdSelectionRect = selectionRect;
	NSRect characterBounds;
	int characterIndex;
	NSPoint currentPoint = selectionRect.origin;
leftSide:
	characterIndex = [page characterIndexAtPoint:currentPoint];
	if(characterIndex>=0)
	{
		characterBounds = [page characterBoundsAtIndex:characterIndex];
		characterBounds = NSIntersectionRect(characterBounds,bounds);
		if(NSMaxY(characterBounds)<NSMaxY(selectionRect))
		{
			xtdSelectionRect = NSUnionRect(characterBounds,xtdSelectionRect);
			currentPoint.y = MIN(NSMaxY(characterBounds)+1,NSMaxY(selectionRect));
			goto leftSide;
		}
		xtdSelectionRect = NSUnionRect(characterBounds,xtdSelectionRect);
		currentPoint.y = NSMaxY(selectionRect);
		goto topSide;
	}
	currentPoint.y += 5;
	if(currentPoint.y<=NSMaxY(selectionRect))
	{
		goto leftSide;
	}
	currentPoint.y = NSMaxY(selectionRect);
topSide:
	characterIndex = [page characterIndexAtPoint:currentPoint];
	if(characterIndex>=0)
	{
		characterBounds = [page characterBoundsAtIndex:characterIndex];
		characterBounds = NSIntersectionRect(characterBounds,bounds);
		if(NSMaxX(characterBounds)<NSMaxX(selectionRect))
		{
			xtdSelectionRect = NSUnionRect(characterBounds,xtdSelectionRect);
			currentPoint.x = MIN(NSMaxX(characterBounds)+1,NSMaxX(selectionRect));
			goto topSide;
		}
		xtdSelectionRect = NSUnionRect(characterBounds,xtdSelectionRect);
		currentPoint.x = NSMaxX(selectionRect);
		goto rightSide;
	}
	currentPoint.x += 5;
	if(currentPoint.x<NSMaxX(selectionRect))
	{
		goto topSide;
	}
	currentPoint.x = NSMaxX(selectionRect);
rightSide:
	characterIndex = [page characterIndexAtPoint:currentPoint];
	if(characterIndex>=0)
	{
		characterBounds = [page characterBoundsAtIndex:characterIndex];
		characterBounds = NSIntersectionRect(characterBounds,bounds);
		if(NSMinY(characterBounds)>NSMinY(selectionRect))
		{
			xtdSelectionRect = NSUnionRect(characterBounds,xtdSelectionRect);
			currentPoint.y = MAX(NSMinY(characterBounds)-1,NSMinY(selectionRect));
			goto rightSide;
		}
		xtdSelectionRect = NSUnionRect(characterBounds,xtdSelectionRect);
		currentPoint.y = NSMinY(selectionRect);
		goto bottomSide;
	}
	currentPoint.y -= 5;
	if(currentPoint.y>NSMinY(selectionRect))
	{
		goto rightSide;
	}
	currentPoint.y = NSMinY(selectionRect);
bottomSide:
	characterIndex = [page characterIndexAtPoint:currentPoint];
	if(characterIndex>=0)
	{
		characterBounds = [page characterBoundsAtIndex:characterIndex];
		characterBounds = NSIntersectionRect(characterBounds,bounds);
		if(NSMinX(characterBounds)>NSMinX(selectionRect))
		{
			xtdSelectionRect = NSUnionRect(characterBounds,xtdSelectionRect);
			currentPoint.x = MAX(NSMinX(characterBounds)-1,NSMinX(selectionRect));
			goto bottomSide;
		}
		xtdSelectionRect = NSUnionRect(characterBounds,xtdSelectionRect);
		goto theEnd;
	}
	currentPoint.x -= 5;
	if(currentPoint.x>NSMinX(selectionRect))
	{
		goto bottomSide;
	}
theEnd:
	xtdSelectionRect = [pdfView convertRect:xtdSelectionRect fromPage:page];
	xtdSelectionRect = [self convertRect:xtdSelectionRect fromView:pdfView];
	[self setSelectionRect:xtdSelectionRect];
	return;
}
#if 0
- (void)_expandSelectionRectToContainWholeGlyphsInPage:(PDFPage *)page;
{
	return;
	if(!page)
	{
		return;
	}
	PDFView * pdfView = (PDFView *)[self superviewMemberOfClass:[PDFView class]];
	NSRect bounds = [page boundsForBox:kPDFDisplayBoxMediaBox];
	NSRect selectionRect = [self selectionRect];
	selectionRect = [self convertRect:selectionRect toView:pdfView];
	selectionRect = [pdfView convertRect:selectionRect toPage:page];
	NSRect characterBounds;
	int characterIndex;
	NSPoint currentPoint = selectionRect.origin;
leftSide:
	characterIndex = [page characterIndexAtPoint:currentPoint];
	if(characterIndex>=0)
	{
		characterBounds = [page characterBoundsAtIndex:characterIndex];
		characterBounds = NSIntersectionRect(characterBounds,bounds);
		if(NSMinX(characterBounds)<NSMinX(selectionRect))
		{
			selectionRect = NSUnionRect(characterBounds,selectionRect);
			currentPoint = selectionRect.origin;
			goto leftSide;
		}
		if(NSMaxY(characterBounds)<NSMaxY(selectionRect))
		{
			selectionRect = NSUnionRect(characterBounds,selectionRect);
			currentPoint.y = MIN(NSMaxY(characterBounds)+1,NSMaxY(selectionRect));
			goto leftSide;
		}
		selectionRect = NSUnionRect(characterBounds,selectionRect);
		currentPoint.y = NSMaxY(selectionRect);
		goto topSide;
	}
	currentPoint.y += 5;
	if(currentPoint.y<=NSMaxY(selectionRect))
	{
		goto leftSide;
	}
	currentPoint.y = NSMaxY(selectionRect)-0.1;
topSide:
	characterIndex = [page characterIndexAtPoint:currentPoint];
	if(characterIndex>=0)
	{
		characterBounds = [page characterBoundsAtIndex:characterIndex];
		characterBounds = NSIntersectionRect(characterBounds,bounds);
		if((NSMinX(characterBounds)<NSMinX(selectionRect))
			|| (NSMaxY(characterBounds)>NSMaxY(selectionRect)))
		{
			selectionRect = NSUnionRect(characterBounds,selectionRect);
			currentPoint = selectionRect.origin;
			goto leftSide;
		}
		if(NSMaxX(characterBounds)<NSMaxX(selectionRect))
		{
			selectionRect = NSUnionRect(characterBounds,selectionRect);
			currentPoint.x = MIN(NSMaxX(characterBounds)+1,NSMaxX(selectionRect));
			goto topSide;
		}
		selectionRect = NSUnionRect(characterBounds,selectionRect);
		currentPoint.x = NSMaxX(selectionRect);
		goto rightSide;
	}
	currentPoint.x += 5;
	if(currentPoint.x<NSMaxX(selectionRect))
	{
		goto topSide;
	}
	currentPoint.x = NSMaxX(selectionRect);
rightSide:
	characterIndex = [page characterIndexAtPoint:currentPoint];
	if(characterIndex>=0)
	{
		characterBounds = [page characterBoundsAtIndex:characterIndex];
		characterBounds = NSIntersectionRect(characterBounds,bounds);
		if((NSMinX(characterBounds)<NSMinX(selectionRect))
			|| (NSMaxY(characterBounds)>NSMaxY(selectionRect))
				|| (NSMaxX(characterBounds)>NSMaxX(selectionRect)))
		{
			selectionRect = NSUnionRect(characterBounds,selectionRect);
			currentPoint = selectionRect.origin;
			goto leftSide;
		}
		if(NSMinY(characterBounds)>NSMinY(selectionRect))
		{
			selectionRect = NSUnionRect(characterBounds,selectionRect);
			currentPoint.y = MAX(NSMinY(characterBounds)-1,NSMinY(selectionRect));
			goto rightSide;
		}
		selectionRect = NSUnionRect(characterBounds,selectionRect);
		currentPoint.y = NSMinY(selectionRect);
		goto bottomSide;
	}
	currentPoint.y -= 5;
	if(currentPoint.y>NSMinY(selectionRect))
	{
		goto rightSide;
	}
	currentPoint.y = NSMinY(selectionRect);
bottomSide:
	characterIndex = [page characterIndexAtPoint:currentPoint];
	if(characterIndex>=0)
	{
		characterBounds = [page characterBoundsAtIndex:characterIndex];
		characterBounds = NSIntersectionRect(characterBounds,bounds);
		if((NSMinX(characterBounds)<NSMinX(selectionRect))
			|| (NSMaxY(characterBounds)>NSMaxY(selectionRect))
				|| (NSMaxX(characterBounds)>NSMaxX(selectionRect))
					|| (NSMinY(characterBounds)<NSMinY(selectionRect)))
		{
			selectionRect = NSUnionRect(characterBounds,selectionRect);
			currentPoint = selectionRect.origin;
			goto leftSide;
		}
		if(NSMinX(characterBounds)>NSMinX(selectionRect))
		{
			selectionRect = NSUnionRect(characterBounds,selectionRect);
			currentPoint.x = MAX(NSMinX(characterBounds)-1,NSMinX(selectionRect));
			goto bottomSide;
		}
		selectionRect = NSUnionRect(characterBounds,selectionRect);
		goto theEnd;
	}
	currentPoint.x -= 5;
	if(currentPoint.x>NSMinX(selectionRect))
	{
		goto bottomSide;
	}
theEnd:
	selectionRect = [pdfView convertRect:selectionRect fromPage:page];
	selectionRect = [self convertRect:selectionRect fromView:pdfView];
	[self setSelectionRect:selectionRect];
	return;
}
#endif
- (void)trackSelectionModify:(NSEvent *)theEvent boundary:(unsigned int)mask inRect:(NSRect)bounds;
{
	if(!mask)
	{
		return;
	}
	NSRect selectionRect = [self selectionRect];
	NSPoint selectionAnchor;
	NSRect pointBounds = bounds;
	if(mask & LEFT)
	{
		pointBounds.origin.x = NSMinX(bounds);
		pointBounds.size.width = MAX(0,NSMaxX(selectionRect) - NSMinX(pointBounds));
		selectionAnchor.x = NSMinX(selectionRect);// left point
	}
	else if(mask & RIGHT)
	{
		pointBounds.origin.x = NSMinX(selectionRect);
		pointBounds.size.width = MAX(0,NSMaxX(bounds) - NSMinX(pointBounds));
		selectionAnchor.x = NSMaxX(selectionRect);// right point
	}
	else
	{
		pointBounds.origin.x = NSMinX(selectionRect);
		pointBounds.size.width = NSWidth(selectionRect);
		selectionAnchor.x = NSMidX(selectionRect);// unused
	}
	if(mask & BOTTOM)
	{
		pointBounds.origin.y = NSMinY(bounds);
		pointBounds.size.height = MAX(0,NSMaxY(selectionRect) - NSMinY(pointBounds));
		selectionAnchor.y = NSMinY(selectionRect);// bottom point
	}
	else if(mask & TOP)
	{
		pointBounds.origin.y = NSMinY(selectionRect);
		pointBounds.size.height = MAX(0,NSMaxY(bounds) - NSMinY(pointBounds));
		selectionAnchor.y = NSMaxY(selectionRect);// top point
	}
	else
	{
		pointBounds.origin.y = NSMinY(selectionRect);
		pointBounds.size.height = NSHeight(selectionRect);
		selectionAnchor.y = NSMidX(selectionRect);// unused
	}
	if(NSIsEmptyRect(pointBounds))
	{
		return;
	}
	NSWindow * window = [self window];
	NSRect visibleRect, dontScrollRect;
	NSPoint scrollOffset = NSMakePoint(10,10);
	NSPoint anchor = [theEvent locationInWindow];/* immutable */
	NSPoint locationAnchor = [self convertPoint:anchor fromView:nil];
	NSPoint newPoint, location;
	BOOL scroll = NO;
	float f,g;
	NSRect mainScreenFrame = [[NSScreen mainScreen] visibleFrame];
	[[NSCursor closedHandCursor] push];
mainLoop:
	visibleRect = [self visibleRect];
	location = [window mouseLocationOutsideOfEventStream];
	location = [self convertPoint:location fromView:nil];
	// if the location is near the boundary of the visible rect, scroll
	dontScrollRect = NSInsetRect(visibleRect,SCROLL_LAYER,SCROLL_LAYER);
	scroll = NO;
	scrollOffset = NSZeroPoint;
	if(selectionRect.size.width>0)
	{
		if((0<(g=location.x-NSMaxX(dontScrollRect))) && (0<(f=NSMaxX(bounds)-NSMaxX(visibleRect))))
		{
			newPoint = NSMakePoint(NSMaxX(mainScreenFrame),NSMidY(mainScreenFrame));
			newPoint = [window convertScreenToBase:newPoint];
			newPoint = [self convertPoint:newPoint fromView:nil];
			newPoint.x -= NSMaxX(dontScrollRect);
			g/=newPoint.x;
			scrollOffset.x=MIN(f+10,SCROLL_DIMEN*powf(g,SCROLL_COEFF));
			scroll = YES;
		}
		else if((0<(g=NSMinX(dontScrollRect)-location.x)) && (0<(f=NSMinX(visibleRect)-NSMinX(bounds))))
		{
			newPoint = NSMakePoint(NSMinX(mainScreenFrame),NSMidY(mainScreenFrame));
			newPoint = [window convertScreenToBase:newPoint];
			newPoint = [self convertPoint:newPoint fromView:nil];
			newPoint.x -= NSMinX(dontScrollRect);
			g/=-newPoint.x;
			scrollOffset.x=-MIN(f+10,SCROLL_DIMEN*powf(g,SCROLL_COEFF));
			scroll = YES;
		}
	}
	if(selectionRect.size.height>0)
	{
		if((0<(g=location.y-NSMaxY(dontScrollRect))) && (0<(f=NSMaxY(bounds)-NSMaxY(visibleRect))))
		{
			newPoint = NSMakePoint(NSMidX(mainScreenFrame),NSMaxY(mainScreenFrame));
			newPoint = [window convertScreenToBase:newPoint];
			newPoint = [self convertPoint:newPoint fromView:nil];
			newPoint.y -= NSMaxY(dontScrollRect);
			g/=newPoint.y;
			scrollOffset.y=MIN(f+10,SCROLL_DIMEN*powf(g,SCROLL_COEFF));
			scroll = YES;
		}
		else if((0<(g=NSMinY(dontScrollRect)-location.y)) && (0<(f=NSMinY(visibleRect)-NSMinY(bounds))))
		{
			newPoint = NSMakePoint(NSMidX(mainScreenFrame),NSMinY(mainScreenFrame));
			newPoint = [window convertScreenToBase:newPoint];
			newPoint = [self convertPoint:newPoint fromView:nil];
			newPoint.y -= NSMinY(dontScrollRect);
			g/=-newPoint.y;
			scrollOffset.y=-MIN(f+10,SCROLL_DIMEN*powf(g,SCROLL_COEFF));
			scroll = YES;
		}
	}
	visibleRect = NSOffsetRect(visibleRect,scrollOffset.x,scrollOffset.y);
	[self scrollRectToVisible:visibleRect];
	// project the location in the visible rectangle
	newPoint.x = selectionAnchor.x + location.x - locationAnchor.x;
	newPoint.y = selectionAnchor.y + location.y - locationAnchor.y;
	if(newPoint.x < (f=NSMinX(visibleRect)))
	{
		newPoint.x = f;
	}
	else if(newPoint.x > (f=NSMaxX(visibleRect)))
	{
		newPoint.x = f;
	}
	if(newPoint.y < (f=NSMinY(visibleRect)))
	{
		newPoint.y = f;
	}
	else if(newPoint.y > (f=NSMaxY(visibleRect)))
	{
		newPoint.y = f;
	}
	if(newPoint.x < (f=NSMinX(pointBounds)))
	{
		newPoint.x = f;
	}
	else if(newPoint.x > (f=NSMaxX(pointBounds)))
	{
		newPoint.x = f;
	}
	if(newPoint.y < (f=NSMinY(pointBounds)))
	{
		newPoint.y = f;
	}
	else if(newPoint.y > (f=NSMaxY(pointBounds)))
	{
		newPoint.y = f;
	}
	if(mask & LEFT)
	{
		selectionRect.size.width = MAX(0,NSMaxX(selectionRect) - newPoint.x);
		selectionRect.origin.x = newPoint.x;
	}
	else if(mask & RIGHT)
	{
		selectionRect.size.width = MAX(0,newPoint.x - NSMinX(selectionRect));
	}
	if(mask & BOTTOM)
	{
		selectionRect.size.height = MAX(0,NSMaxY(selectionRect) - newPoint.y);
		selectionRect.origin.y = newPoint.y;
	}
	else if(mask & TOP)
	{
		selectionRect.size.height = MAX(0,newPoint.y - NSMinY(selectionRect));
	}
	[self setSelectionRect:selectionRect];
	if(scroll)
	{
		location = [window mouseLocationOutsideOfEventStream];
		theEvent = [NSEvent otherEventWithType:NSApplicationDefined
						location:location
							modifierFlags:0
								timestamp:0
									windowNumber:[window windowNumber]
										context:nil
											subtype:0
												data1:0
													data2:0];
		[window postEvent:theEvent atStart:NO];
	}
	theEvent = [window nextEventMatchingMask:NSLeftMouseUpMask | NSLeftMouseDraggedMask | NSScrollWheelMask | NSApplicationDefinedMask];
	if([theEvent type] == NSLeftMouseUp)
	{
		[NSCursor pop];
		return;
	}
	goto mainLoop;
}
- (void)trackSelectionCreate:(NSEvent *)theEvent inRect:(NSRect)bounds;
{
	if(NSIsEmptyRect(bounds))
	{
		return;
	}
	NSRect selectionRect = [self selectionRect];
	NSWindow * window = [self window];
	NSRect visibleRect, dontScrollRect;
	NSPoint scrollOffset = NSMakePoint(10,10);
	NSPoint anchor = [theEvent locationInWindow];/* immutable */
	NSRect locationAnchorRect = NSZeroRect;
	locationAnchorRect.origin = [self convertPoint:anchor fromView:nil];
	locationAnchorRect = NSInsetRect(locationAnchorRect,-1,-1);
	NSPoint newPoint, location;
	BOOL scroll = NO;
	float f,g;
	NSRect mainScreenFrame = [[NSScreen mainScreen] visibleFrame];
mainLoop:
	[[NSCursor crosshairCursor] set];
	visibleRect = [self visibleRect];
	location = [window mouseLocationOutsideOfEventStream];
	location = [self convertPoint:location fromView:nil];
	// if the location is near the boundary of the visible rect, scroll
	dontScrollRect = NSInsetRect(visibleRect,SCROLL_LAYER,SCROLL_LAYER);
	scroll = NO;
	scrollOffset = NSZeroPoint;
	if(selectionRect.size.width>0)
	{
		if((0<(g=location.x-NSMaxX(dontScrollRect))) && (0<(f=NSMaxX(bounds)-NSMaxX(visibleRect))))
		{
			newPoint = NSMakePoint(NSMaxX(mainScreenFrame),NSMidY(mainScreenFrame));
			newPoint = [window convertScreenToBase:newPoint];
			newPoint = [self convertPoint:newPoint fromView:nil];
			newPoint.x -= NSMaxX(dontScrollRect);
			g/=newPoint.x;
			scrollOffset.x=MIN(f+10,SCROLL_DIMEN*powf(g,SCROLL_COEFF));
			scroll = YES;
		}
		else if((0<(g=NSMinX(dontScrollRect)-location.x)) && (0<(f=NSMinX(visibleRect)-NSMinX(bounds))))
		{
			newPoint = NSMakePoint(NSMinX(mainScreenFrame),NSMidY(mainScreenFrame));
			newPoint = [window convertScreenToBase:newPoint];
			newPoint = [self convertPoint:newPoint fromView:nil];
			newPoint.x -= NSMinX(dontScrollRect);
			g/=-newPoint.x;
			scrollOffset.x=-MIN(f+10,SCROLL_DIMEN*powf(g,SCROLL_COEFF));
			scroll = YES;
		}
	}
	if(selectionRect.size.height>0)
	{
		if((0<(g=location.y-NSMaxY(dontScrollRect))) && (0<(f=NSMaxY(bounds)-NSMaxY(visibleRect))))
		{
			newPoint = NSMakePoint(NSMidX(mainScreenFrame),NSMaxY(mainScreenFrame));
			newPoint = [window convertScreenToBase:newPoint];
			newPoint = [self convertPoint:newPoint fromView:nil];
			newPoint.y -= NSMaxY(dontScrollRect);
			g/=newPoint.y;
			scrollOffset.y=MIN(f+10,SCROLL_DIMEN*powf(g,SCROLL_COEFF));
			scroll = YES;
		}
		else if((0<(g=NSMinY(dontScrollRect)-location.y)) && (0<(f=NSMinY(visibleRect)-NSMinY(bounds))))
		{
			newPoint = NSMakePoint(NSMidX(mainScreenFrame),NSMinY(mainScreenFrame));
			newPoint = [window convertScreenToBase:newPoint];
			newPoint = [self convertPoint:newPoint fromView:nil];
			newPoint.y -= NSMinY(dontScrollRect);
			g/=-newPoint.y;
			scrollOffset.y=-MIN(f+10,SCROLL_DIMEN*powf(g,SCROLL_COEFF));
			scroll = YES;
		}
	}
	visibleRect = NSOffsetRect(visibleRect,scrollOffset.x,scrollOffset.y);
	[self scrollRectToVisible:visibleRect];
	// project the location in the visible rectangle
	newPoint = location;
	if(newPoint.x < (f=NSMinX(visibleRect)))
	{
		newPoint.x = f;
	}
	else if(newPoint.x > (f=NSMaxX(visibleRect)))
	{
		newPoint.x = f;
	}
	if(newPoint.y < (f=NSMinY(visibleRect)))
	{
		newPoint.y = f;
	}
	else if(newPoint.y > (f=NSMaxY(visibleRect)))
	{
		newPoint.y = f;
	}
	if(newPoint.x < (f=NSMinX(bounds)))
	{
		newPoint.x = f;
	}
	else if(newPoint.x > (f=NSMaxX(bounds)))
	{
		newPoint.x = f;
	}
	if(newPoint.y < (f=NSMinY(bounds)))
	{
		newPoint.y = f;
	}
	else if(newPoint.y > (f=NSMaxY(bounds)))
	{
		newPoint.y = f;
	}
	selectionRect = NSZeroRect;
	selectionRect.origin = newPoint;
	selectionRect = NSInsetRect(selectionRect,-1,-1);
	selectionRect = NSUnionRect(locationAnchorRect,selectionRect);
	selectionRect = NSInsetRect(selectionRect,1,1);
	[self setSelectionRect:selectionRect];
	if(scroll)
	{
		location = [window mouseLocationOutsideOfEventStream];
		theEvent = [NSEvent otherEventWithType:NSApplicationDefined
						location:location
							modifierFlags:0
								timestamp:0
									windowNumber:[window windowNumber]
										context:nil
											subtype:0
												data1:0
													data2:0];
		[window postEvent:theEvent atStart:NO];
	}
	theEvent = [window nextEventMatchingMask:NSLeftMouseUpMask | NSLeftMouseDraggedMask | NSScrollWheelMask | NSApplicationDefinedMask];
	if([theEvent type] == NSLeftMouseUp)
	{
		return;
	}
	goto mainLoop;
}
- (void)trackSelectionDrag:(NSEvent *)theEvent inRect:(NSRect)bounds;
{
	NSRect selectionRect = [self selectionRect];
	NSPoint selectionAnchor = selectionRect.origin;
	NSRect pointBounds = bounds;
	pointBounds.size.width = MAX(0,NSWidth(bounds) - NSWidth(selectionRect));
	pointBounds.size.height = MAX(0,NSHeight(bounds) - NSHeight(selectionRect));
	NSWindow * window = [self window];
	NSRect visibleRect, dontScrollRect;
	NSPoint scrollOffset = NSMakePoint(10,10);
	NSPoint anchor = [theEvent locationInWindow];/* immutable */
	NSPoint locationAnchor = [self convertPoint:anchor fromView:nil];
	NSPoint newPoint, location;
	BOOL scroll = NO;
	float f,g;
	NSRect mainScreenFrame = [[NSScreen mainScreen] visibleFrame];
	[[NSCursor closedHandCursor] push];
mainLoop:
	visibleRect = [self visibleRect];
	location = [window mouseLocationOutsideOfEventStream];
	location = [self convertPoint:location fromView:nil];
	// if the location is near the boundary of the visible rect, scroll
	dontScrollRect = NSInsetRect(visibleRect,SCROLL_LAYER,SCROLL_LAYER);
	scroll = NO;
	scrollOffset = NSZeroPoint;
	if(selectionRect.size.width>0)
	{
		if((0<(g=location.x-NSMaxX(dontScrollRect))) && (0<(f=NSMaxX(bounds)-NSMaxX(visibleRect))))
		{
			newPoint = NSMakePoint(NSMaxX(mainScreenFrame),NSMidY(mainScreenFrame));
			newPoint = [window convertScreenToBase:newPoint];
			newPoint = [self convertPoint:newPoint fromView:nil];
			newPoint.x -= NSMaxX(dontScrollRect);
			g/=newPoint.x;
			scrollOffset.x=MIN(f+10,SCROLL_DIMEN*powf(g,SCROLL_COEFF));
			scroll = YES;
		}
		else if((0<(g=NSMinX(dontScrollRect)-location.x)) && (0<(f=NSMinX(visibleRect)-NSMinX(bounds))))
		{
			newPoint = NSMakePoint(NSMinX(mainScreenFrame),NSMidY(mainScreenFrame));
			newPoint = [window convertScreenToBase:newPoint];
			newPoint = [self convertPoint:newPoint fromView:nil];
			newPoint.x -= NSMinX(dontScrollRect);
			g/=-newPoint.x;
			scrollOffset.x=-MIN(f+10,SCROLL_DIMEN*powf(g,SCROLL_COEFF));
			scroll = YES;
		}
	}
	if(selectionRect.size.height>0)
	{
		if((0<(g=location.y-NSMaxY(dontScrollRect))) && (0<(f=NSMaxY(bounds)-NSMaxY(visibleRect))))
		{
			newPoint = NSMakePoint(NSMidX(mainScreenFrame),NSMaxY(mainScreenFrame));
			newPoint = [window convertScreenToBase:newPoint];
			newPoint = [self convertPoint:newPoint fromView:nil];
			newPoint.y -= NSMaxY(dontScrollRect);
			g/=newPoint.y;
			scrollOffset.y=MIN(f+10,SCROLL_DIMEN*powf(g,SCROLL_COEFF));
			scroll = YES;
		}
		else if((0<(g=NSMinY(dontScrollRect)-location.y)) && (0<(f=NSMinY(visibleRect)-NSMinY(bounds))))
		{
			newPoint = NSMakePoint(NSMidX(mainScreenFrame),NSMinY(mainScreenFrame));
			newPoint = [window convertScreenToBase:newPoint];
			newPoint = [self convertPoint:newPoint fromView:nil];
			newPoint.y -= NSMinY(dontScrollRect);
			g/=-newPoint.y;
			scrollOffset.y=-MIN(f+10,SCROLL_DIMEN*powf(g,SCROLL_COEFF));
			scroll = YES;
		}
	}
	visibleRect = NSOffsetRect(visibleRect,scrollOffset.x,scrollOffset.y);
	[self scrollRectToVisible:visibleRect];
	// project the location in the visible rectangle
	newPoint.x = selectionAnchor.x + location.x - locationAnchor.x;
	newPoint.y = selectionAnchor.y + location.y - locationAnchor.y;
	if(newPoint.x < (f=NSMinX(visibleRect)))
	{
		newPoint.x = f;
	}
	else if(newPoint.x > (f=NSMaxX(visibleRect)-NSWidth(selectionRect)))
	{
		newPoint.x = f;
	}
	if(newPoint.y < (f=NSMinY(visibleRect)))
	{
		newPoint.y = f;
	}
	else if(newPoint.y > (f=NSMaxY(visibleRect)-NSHeight(selectionRect)))
	{
		newPoint.y = f;
	}
	if(newPoint.x < (f=NSMinX(pointBounds)))
	{
		newPoint.x = f;
	}
	else if(newPoint.x > (f=NSMaxX(pointBounds)))
	{
		newPoint.x = f;
	}
	if(newPoint.y < (f=NSMinY(pointBounds)))
	{
		newPoint.y = f;
	}
	else if(newPoint.y > (f=NSMaxY(pointBounds)))
	{
		newPoint.y = f;
	}
	selectionRect.origin = newPoint;
	[self setSelectionRect:selectionRect];
	if(scroll)
	{
		location = [window mouseLocationOutsideOfEventStream];
		theEvent = [NSEvent otherEventWithType:NSApplicationDefined
						location:location
							modifierFlags:0
								timestamp:0
									windowNumber:[window windowNumber]
										context:nil
											subtype:0
												data1:0
													data2:0];
		[window postEvent:theEvent atStart:NO];
	}
	theEvent = [window nextEventMatchingMask:NSLeftMouseUpMask | NSLeftMouseDraggedMask | NSScrollWheelMask | NSApplicationDefinedMask];
	if([theEvent type] == NSLeftMouseUp)
	{
		[NSCursor pop];
		return;
	}
	goto mainLoop;
}
- (BOOL)changeCursorForAreaOfInterest:(PDFAreaOfInterest)area
{
	if(!_active)
	{
		return NO;
	}
	if([self isHiddenOrHasHiddenAncestor])
	{
		return NO;
	}
	if(area&kPDFPageArea)
	{
		if(area&kiTM2PDFSelectArea)
		{
			[[NSCursor openHandCursor] set];
		}
		else if(area&kiTM2PDFSelectLeftArea)
		{
			if(area&kiTM2PDFSelectTopArea)
			{
				[[NSCursor resizeTopLeftCursor] set];
			}
			else if(area&kiTM2PDFSelectBottomArea)
			{
				[[NSCursor resizeBottomLeftCursor] set];
			}
			else
			{
				[[NSCursor resizeLeftRightCursor] set];
			}
		}
		else if(area&kiTM2PDFSelectRightArea)
		{
			if(area&kiTM2PDFSelectTopArea)
			{
				[[NSCursor resizeTopRightCursor] set];
			}
			else if(area&kiTM2PDFSelectBottomArea)
			{
				[[NSCursor resizeBottomRightCursor] set];
			}
			else
			{
				[[NSCursor resizeLeftRightCursor] set];
			}
		}
		else if(area&kiTM2PDFSelectTopArea || area&kiTM2PDFSelectBottomArea)
		{
			[[NSCursor resizeUpDownCursor] set];
		}
		else
		{
			[[NSCursor crosshairCursor] set];
		}
	}
	else
	{
		[[NSCursor arrowCursor] set];
	}
	return YES;
}
- (PDFAreaOfInterest)areaOfInterestForMouse:(NSEvent *) theEvent;
{
	if(!_active)
	{
		return kPDFNoArea;
	}
	NSPoint viewMouse = [[self window] mouseLocationOutsideOfEventStream];
	viewMouse = [self convertPoint:viewMouse fromView:nil];
	NSRect selectionRect = [self selectionRect];
	NSRect rect = selectionRect;
	if([self mouse:viewMouse inRect:rect])
	{
		return kiTM2PDFSelectArea;
	}
	#define AREA_LAYER 10
	rect.size.width = AREA_LAYER;
	rect.origin.x -= AREA_LAYER;
	if([self mouse:viewMouse inRect:rect])
	{
		return kiTM2PDFSelectLeftArea;
	}
	rect = selectionRect;
	rect.size.width = AREA_LAYER;
	rect.origin.x = NSMaxX(selectionRect);
	if([self mouse:viewMouse inRect:rect])
	{
		return kiTM2PDFSelectRightArea;
	}
	rect = selectionRect;
	rect.size.height = AREA_LAYER;
	rect.origin.y -= AREA_LAYER;
	if([self mouse:viewMouse inRect:rect])
	{
		return [self isFlipped]?kiTM2PDFSelectTopArea:kiTM2PDFSelectBottomArea;
	}
	rect = selectionRect;
	rect.size.height = AREA_LAYER;
	rect.origin.y = NSMaxY(selectionRect);
	if([self mouse:viewMouse inRect:rect])
	{
		return [self isFlipped]?kiTM2PDFSelectBottomArea:kiTM2PDFSelectTopArea;
	}
	rect = selectionRect;
	rect.size.width = AREA_LAYER;
	rect.size.height = AREA_LAYER;
	rect.origin.x = NSMaxX(selectionRect);
	rect.origin.y = NSMaxY(selectionRect);
	if([self mouse:viewMouse inRect:rect])
	{
		return kiTM2PDFSelectRightArea|([self isFlipped]?kiTM2PDFSelectBottomArea:kiTM2PDFSelectTopArea);
	}
	rect = selectionRect;
	rect.size.width = AREA_LAYER;
	rect.size.height = AREA_LAYER;
	rect.origin.x -= AREA_LAYER;
	rect.origin.y = NSMaxY(selectionRect);
	if([self mouse:viewMouse inRect:rect])
	{
		return kiTM2PDFSelectLeftArea|([self isFlipped]?kiTM2PDFSelectBottomArea:kiTM2PDFSelectTopArea);
	}
	rect = selectionRect;
	rect.size.width = AREA_LAYER;
	rect.size.height = AREA_LAYER;
	rect.origin.x = NSMaxX(selectionRect);
	rect.origin.y -= AREA_LAYER;
	if([self mouse:viewMouse inRect:rect])
	{
		return kiTM2PDFSelectRightArea|([self isFlipped]?kiTM2PDFSelectTopArea:kiTM2PDFSelectBottomArea);
	}
	rect = selectionRect;
	rect.size.width = AREA_LAYER;
	rect.size.height = AREA_LAYER;
	rect.origin.x -= AREA_LAYER;
	rect.origin.y -= AREA_LAYER;
	if([self mouse:viewMouse inRect:rect])
	{
		return kiTM2PDFSelectLeftArea|([self isFlipped]?kiTM2PDFSelectTopArea:kiTM2PDFSelectBottomArea);
	}
	#undef AREA_LAYER
	return kPDFNoArea;
}
- (void)copy:(id)sender;
{
	NSRect selectionRect = [self selectionRect];
	if(NSIsEmptyRect(selectionRect))
	{
		return;
	}
	NSPasteboard *pb = [NSPasteboard generalPasteboard];
	NSArray *types = [NSArray arrayWithObjects:NSPDFPboardType, nil];
	[pb declareTypes:types owner:self];
	PDFView * pdfView = (PDFView *)[self superviewMemberOfClass:[PDFView class]];
	selectionRect = [self convertRect:selectionRect toView:pdfView];
	NSData * pdfData;
	if([[NSApp currentEvent] modifierFlags] & NSAlternateKeyMask)
	{
		pdfData = [pdfView dataWithPDFInsideRect:selectionRect];// with blank background
	}
	else
	{
		PDFView * pdfView = (PDFView *)[self superviewMemberOfClass:[PDFView class]];
		NSRect selectionRect = [self selectionRect];
		selectionRect = [self convertRect:selectionRect toView:pdfView];
		NSPoint point = NSMakePoint(NSMidX(selectionRect),NSMidY(selectionRect));
		PDFPage * page = [pdfView pageForPoint:point nearest:NO];
		if(page)
		{
			selectionRect = [pdfView convertRect:selectionRect toPage:page];
			NSString * path = [[[[self window] windowController] document] fileName];
			NSData * data = [[[NSData allocWithZone:[self zone]] initWithContentsOfFile:path] autorelease];
			NSPDFImageRep * imageRep = [[[NSPDFImageRep allocWithZone:[self zone]] initWithData:data] autorelease];
			PDFDocument * document = [page document];
			int currentPage = [document indexForPage:page];
			[imageRep setCurrentPage:currentPage];
			NSRect pageBounds = [page boundsForBox:kPDFDisplayBoxMediaBox];
			NSRect repBounds = [imageRep bounds];
			if(NSIsEmptyRect(repBounds))
			{
				return;
			}
			// convert the selectionRect to the __iTM2PDFPrintView coordinates
			// the new selectionRect should be to the repBounds like the old one was to the page bounds
			selectionRect.origin.x = repBounds.origin.x + (selectionRect.origin.x - pageBounds.origin.x) * pageBounds.size.width/repBounds.size.width;
			selectionRect.origin.y = repBounds.origin.y + (selectionRect.origin.y - pageBounds.origin.y) * pageBounds.size.height/repBounds.size.height;
			selectionRect.size.width *= pageBounds.size.width/repBounds.size.width;
			selectionRect.size.height *= pageBounds.size.height/repBounds.size.height;
			__iTM2PDFPrintView * view = [[[__iTM2PDFPrintView allocWithZone:[self zone]] initWithFrame:repBounds] autorelease];
			view->representation = imageRep;
			pdfData = [view dataWithPDFInsideRect:selectionRect];
		}
	}
	[pb setData:pdfData forType:NSPDFPboardType];
	return;
}
- (void)centerSelectionInVisibleArea:(id)sender;
{
	[self scrollSelectionToVisible:sender];
	return;
}
- (void)scrollSelectionToVisible:(id)sender;
{
	[self scrollRectToVisible:[self selectionRect]];
	return;
}
@end

@implementation __iTM2PDFPrintView
- (void)drawRect:(NSRect)aRect;
{
	[representation drawAtPoint:NSZeroPoint];
	return;
}
@end

@implementation _PDFFilePromiseController
- (id)initWithName:(NSString *)name data:(NSData *)data label:(NSString *)label;
{
	if(self = [super init])
	{
		[_name autorelease];
		_name = [name copy];
		[_data autorelease];
		_data = [data retain];
		[_label autorelease];
		_label = [label copy];
	}
	return self;
}
- (void)dealloc;
{
	[_name autorelease];
	_name = nil;
	[_data autorelease];
	_data = nil;
	[_label autorelease];
	_label = nil;
	[super dealloc];
	return;
}
- (NSArray *)namesOfPromisedFilesDroppedAtDestination:(NSURL *)dropDestination;
{
	if(![dropDestination isFileURL])
	{
		return [NSArray array];
	}
	NSString * destination = [dropDestination path];
	NSString * coreName = _name;
	coreName = [coreName lastPathComponent];
	coreName = [coreName stringByDeletingPathExtension];
	// this is he core name
	unsigned int index = 0;
	while(YES)
	{
		NSString * name = [coreName stringByAppendingFormat:@"[%@-%i].pdf",_label,++index];
		NSString * path = [destination stringByAppendingPathComponent:name];
		if(![[NSFileManager defaultManager] fileExistsAtPath:path])
		{
			return [_data writeToFile:path options:NSAtomicWrite error:nil]?
				[NSArray arrayWithObject:name]:[NSArray array];
		}
	}
}
@end

@interface PDFPage_iTM2PDFKit:PDFPage
@end

@implementation PDFPage_iTM2PDFKit
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  load
+ (void)load;
/*"Description forthcoming.
Version History:jlaurens AT users DOT sourceforge DOT net
- 2.0:Mon May 30 13:39:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
	iTM2_INIT_POOL;
	iTM2RedirectNSLogOutput();
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
Version History:jlaurens AT users DOT sourceforge DOT net
- 2.0:Mon May 30 13:39:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	int result = [super characterIndexAtPoint:point];
	if(result < 0)
		return result;
	iTM2XtdPDFDocument * document = (iTM2XtdPDFDocument *)[self document];
	NSString * string = [document stringForPage:self];
	if([string characterAtIndex:result] == ' ')
	{
		if(result < [string length] - 1)
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
//iTM2_LOG(@"+++++++++++++ left character is:%@, bounds is:%@", [string substringWithRange:NSMakeRange(result-1, 1)], NSStringFromRect(bounds));
			}
		}
		PDFSelection * SELECTION = [self selectionForRange:NSMakeRange(result, 1)];
		if(SELECTION)
		{
			NSRect bounds = [SELECTION boundsForPage:self];
//iTM2_LOG(@"+++++++++++++ center character is:%@, bounds is:%@", [string substringWithRange:NSMakeRange(result, 1)], NSStringFromRect(bounds));
		}
		if(result < [string length] - 1)
		{
			PDFSelection * SELECTION = [self selectionForRange:NSMakeRange(result+1, 1)];
			if(SELECTION)
			{
				NSRect bounds = [SELECTION boundsForPage:self];
//iTM2_LOG(@"+++++++++++++ right character is:%@, bounds is:%@", [string substringWithRange:NSMakeRange(result+1, 1)], NSStringFromRect(bounds));
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
Version History:jlaurens AT users DOT sourceforge DOT net
- 1.3:03/10/2002
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
	return globalIndex < [self numberOfCharacters]? globalIndex:-1;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  localToGlobalCharacterIndex:
- (int)localToGlobalCharacterIndex:(int)localIndex;
/*"Description forthcoming.
Version History:jlaurens AT users DOT sourceforge DOT net
- 1.3:03/10/2002
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
Version History:jlaurens AT users DOT sourceforge DOT net
- 1.3:03/10/2002
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

@interface PDFView_iTM2PDFKit:PDFView
@end

@implementation PDFView_iTM2PDFKit
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  load
+ (void)load;
/*"Description forthcoming.
Version History:jlaurens AT users DOT sourceforge DOT net
- 2.0:Mon May 30 13:39:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
	iTM2_INIT_POOL;
	iTM2RedirectNSLogOutput();
//iTM2_START;
	[self poseAsClass:[PDFView class]];
//iTM2_END;
	iTM2_RELEASE_POOL;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= handlesKeyBindings
- (BOOL)handlesKeyBindings;
/*"YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Dec 15 14:34:51 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= keyDown:
- (void)keyDown:(NSEvent *)theEvent
/*"Bypass the inherited Preview behaviour.
Version History:jlaurens AT users DOT sourceforge DOT net
- 2.0:
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id KBM = [self keyBindingsManager];
	if(![KBM client:self performKeyEquivalent:theEvent]
		&&![KBM client:[self window] performKeyEquivalent:theEvent]
			&&![KBM client:[[self window] windowController] performKeyEquivalent:theEvent])
	{
		[super keyDown:theEvent];
	}
//iTM2_END;
	return;
}
@end

NSString * const iTM2PDFKitKeyBindingsIdentifier = @"PDF2";

@implementation iTM2PDFKitInspector(iTM2KeyStrokeKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  keyBindingsManagerIdentifier
- (NSString *)keyBindingsManagerIdentifier;
/*"Just to autorelease the window controller of the window.
Version history:jlaurens AT users DOT sourceforge DOT net
- 2.0:Fri Sep 05 2003
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
Version history:jlaurens AT users DOT sourceforge DOT net
- 2.0:Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [[[self window] firstResponder] isKindOfClass:[NSText class]]?
		nil:[super keyBindingsManager];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  handlesKeyBindings
- (BOOL)handlesKeyBindings;
/*"Description Forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- 2.0:Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  tryToExecuteMacroWithID:
- (BOOL)tryToExecuteMacroWithID:(NSString *)instruction;
/*"Description forthcoming.
If the event is a 1 char key down, it will ask the current key binding for instruction.
The key and its modifiers are 
Version history:jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    BOOL result = [super tryToExecuteMacroWithID:instruction];
    if(result)
        return result;
    if([instruction length])
    {
//iTM2_LOG(@"instruction is:%@", instruction);
		[[self window] pushKeyStroke:[instruction substringWithRange:NSMakeRange(0, 1)]];
		return YES;
    }
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= handlesKeyStrokes
- (BOOL)handlesKeyStrokes;
/*"YES.
Version history:jlaurens AT users DOT sourceforge DOT net
- 2.0:Wed Dec 15 14:34:51 GMT 2004
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
Version History:jlaurens AT users DOT sourceforge DOT net
- 2.0:Wed Jan  5 17:41:55 GMT 2005
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
Version history:jlaurens AT users DOT sourceforge DOT net
- 2.0:Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[[self pdfView] setScaleFactor:1.0];
	[self validateWindowContent];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateActualSize:
- (BOOL)validateActualSize:(id)sender;
/*"Description Forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- 2.0:Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return [[self pdfView] scaleFactor] != 1.0;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= doZoomIn:
- (void)doZoomIn:(id)sender;
/*"Description forthcoming.
Version History:jlaurens AT users DOT sourceforge DOT net
- 2.0:Wed Jan  5 17:41:55 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self setAutoScales:NO];
    int n = 100 * ([self contextFloatForKey:iTM2PDFKitZoomFactorKey domain:iTM2ContextAllDomainsMask]>0?:1.259921049895);
    [[[self window] keyStrokes] getIntegerTrailer:&n];
	if(n>0)
		[[self pdfView] setScaleFactor:n / 100.0 * [[self pdfView] scaleFactor]];
    [[self window] flushKeyStrokeEvents:self];
	[self validateWindowContent];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= doZoomOut:
- (void)doZoomOut:(id)sender;
/*"Description forthcoming.
Version History:jlaurens AT users DOT sourceforge DOT net
- 2.0:Wed Jan  5 17:41:55 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self setAutoScales:NO];
    int n = 100 * ([self contextFloatForKey:iTM2PDFKitZoomFactorKey domain:iTM2ContextAllDomainsMask]>0?:1.259921049895);
    [[[self window] keyStrokes] getIntegerTrailer:&n];
	if(n>0)
		[[self pdfView] setScaleFactor:100 * [[self pdfView] scaleFactor] / n];
    [[self window] flushKeyStrokeEvents:self];
	[self validateWindowContent];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= doZoomToFit:
- (void)doZoomToFit:(id)sender;
/*"Description forthcoming.
Version History:jlaurens AT users DOT sourceforge DOT net
- 2.0:Wed Jan  5 17:41:55 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	// get the current page
	[[self pdfView] zoomToFit:sender];
	[self validateWindowContent];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= doZoomToSelection:
- (void)doZoomToSelection:(id)sender;
/*"Description forthcoming.
Version History:jlaurens AT users DOT sourceforge DOT net
- 2.0:Wed Jan  5 17:41:55 GMT 2005
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
Version History:jlaurens AT users DOT sourceforge DOT net
- 2.0:Wed Jan  5 17:41:55 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    int n = 1;
    [[[self window] keyStrokes] getIntegerTrailer:&n];
	if(!n)
		return;
	PDFPage * page = [[self pdfView] currentPage];
	PDFDocument * document = [page document];
	unsigned int index = [document indexForPage:page];
	if(n>index)
		index = 0;
	else
		index -= n;
	[[self pdfView] goToPage:[document pageAtIndex:index]];
    [[self window] flushKeyStrokeEvents:self];
	[self validateWindowContent];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= doGoToNextPage:
- (void)doGoToNextPage:(id)sender;
/*"Description forthcoming.
Version History:jlaurens AT users DOT sourceforge DOT net
- 2.0:Wed Jan  5 17:41:55 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    int n = 1;
    [[[self window] keyStrokes] getIntegerTrailer:&n];
	if(!n)
		return;
	PDFPage * page = [[self pdfView] currentPage];
	PDFDocument * document = [page document];
	unsigned int index = [document indexForPage:page];
	unsigned int pageCount = [document pageCount];
	unsigned int count = pageCount - index;
	if(n<count)
		index += n;
	else
		index = pageCount - 1;
	[[self pdfView] goToPage:[document pageAtIndex:index]];
    [[self window] flushKeyStrokeEvents:self];
	[self validateWindowContent];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= doGoForward:
- (void)doGoForward:(id)sender;
/*"Description forthcoming.
Version History:jlaurens AT users DOT sourceforge DOT net
- 2.0:Wed Jan  5 17:41:55 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [[self pdfView] goForward:sender];
	[self validateWindowContent];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= doGoBack:
- (void)doGoBack:(id)sender;
/*"Description forthcoming.
Version History:jlaurens AT users DOT sourceforge DOT net
- 2.0:Wed Jan  5 17:41:55 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [[self pdfView] goBack:sender];
	[self validateWindowContent];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= displayZoom:
- (void)displayZoom:(id)sender;
/*"Description forthcoming.
Version History:jlaurens AT users DOT sourceforge DOT net
- 2.0:Wed Jan  5 17:41:55 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    int n = 100;
    [[[self window] keyStrokes] getIntegerTrailer:&n];
    [[self pdfView] setScaleFactor:n/100.0];
    [[self window] flushKeyStrokeEvents:self];
	[self validateWindowContent];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= displayPage:
- (void)displayPage:(id)sender;
/*"Description forthcoming.
Version History:jlaurens AT users DOT sourceforge DOT net
- 2.0:Wed Jan  5 17:41:55 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    int n = 1;
    if(![[[self window] keyStrokes] getIntegerTrailer:&n])
		return;
	if(n<1)
		n = 1;
	PDFPage * page = [[self pdfView] currentPage];
	PDFDocument * document = [page document];
	unsigned int pageCount = [document pageCount];
	if(--n<pageCount)
		[[self pdfView] goToPage:[document pageAtIndex:n]];
    [[self window] flushKeyStrokeEvents:self];
	[self validateWindowContent];
//iTM2_END;
    return;
}
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2PDFKitPrintKit  =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

@interface _iTM2SegmentedCell_1:NSSegmentedCell
@end
@implementation iTM2IconSegmentedControl:NSSegmentedControl
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  buttonPrevious
+ (void)initialize;
/*"Public use. Description Forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- 2.0:Fri May 21 11:07:09 GMT 2004
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
Version history:jlaurens AT users DOT sourceforge DOT net
- 2.0:Fri May 21 11:07:09 GMT 2004
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
Version history:jlaurens AT users DOT sourceforge DOT net
- 2.0:Fri May 21 11:07:09 GMT 2004
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
Version history:jlaurens AT users DOT sourceforge DOT net
- 2.0:Fri May 21 11:07:09 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[super initialize];
	[SUD registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:
			[NSNumber numberWithFloat:0.9] ,@"iTM2SmallControlScaleFactor",
			[NSNumber numberWithFloat:0.8], @"iTM2MiniControlScaleFactor",
				nil]];
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  init
- (id)init;
/*"Public use. Description Forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- 2.0:Fri May 21 11:07:09 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	return [super init];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  drawSegment:inFrame:withView:
- (void)drawSegment:(int)segment inFrame:(NSRect)frame withView:(NSView *)controlView;
/*"Public use. Description Forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- 2.0:Fri May 21 11:07:09 GMT 2004
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
			float fraction = [self isEnabledForSegment:segment]? 1:0.5;
			NSControlSize CS = [self controlSize];
			float factor = (CS == NSRegularControlSize)? 1:
								((CS == NSSmallControlSize)? [SUD floatForKey:@"iTM2SmallControlScaleFactor"]:
									[SUD floatForKey:@"iTM2MiniControlScaleFactor"]);
//NSLog(@"factor is:%f", factor);
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

@interface iTM2PDFKitDefaultsController:iTM2Inspector
@end

#undef GETTER
#define GETTER [[self model] valueForKey:iTM2KeyFromSelector(_cmd)]
#undef SETTER
#define SETTER(argument) [[self model] setValue:argument forKey:iTM2KeyFromSelector(_cmd)]

NSString * const iTM2PDFKitViewerDefaultsDidChangeNotification = @"iTM2PDFKitViewerDefaultsDidChangeNotification";

@interface iTM2PDFKitPrefPane:iTM2PreferencePane
@end

static id iTM2PDFKitDefaultsController_sharedInstance = nil;
@implementation iTM2PDFKitDefaultsController
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  sharedInstance
+ (id)sharedInstance;
/*"Description Forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- 2.1: Tue Jun 17 11:12:01 UTC 2008
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return iTM2PDFKitDefaultsController_sharedInstance?
		iTM2PDFKitDefaultsController_sharedInstance:
			(iTM2PDFKitDefaultsController_sharedInstance =
				[[iTM2PDFKitDefaultsController alloc] initWithWindowNibName:@"iTM2PDFKitPrefPane"]);
}
- (id)initWithWindow:(NSWindow *)window;
{
	if((self = [super initWithWindow:window]))
	{
		[DNC addObserver:self
			selector:@selector(windowDidBecomeMainNotified:)
				name:NSWindowDidBecomeMainNotification
					object:nil];
		[DNC addObserver:self
			selector:@selector(windowDidResignMainNotified:)
				name:NSWindowDidResignMainNotification
					object:nil];
		[window retain];// extra retain because of a crash otherwise
		[window setDelegate:self];// extra retain because of a crash otherwise
	}
	return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  defaultsController
- (id)defaultsController;
/*"It is used in bindings. This is the pdfView of the window controller of the main window.
Version history:jlaurens AT users DOT sourceforge DOT net
- 2.1: Tue Jun 17 11:12:01 UTC 2008
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return metaGETTER;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setDefaultsController:
- (void)setDefaultsController:(id)controller;
/*"Description Forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- 2.1: Tue Jun 17 11:12:01 UTC 2008
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	metaSETTER(controller);
//iTM2_END;
    return;
}
- (void)windowWillClose:(id)sender;
{
	[self setDefaultsController:nil];
	[self autorelease];
	iTM2PDFKitDefaultsController_sharedInstance = nil;
	return;
}
- (void)dealloc;
{
	[self setDefaultsController:nil];
	[DNC removeObserver:self];
	[super dealloc];
	return;
}
- (void)windowDidBecomeMainNotified:(NSNotification *)notification;
{
	id WC = [[notification object] windowController];
	if([WC isKindOfClass:[iTM2PDFKitInspector class]])
	{
		[self setValue:WC forKey:@"defaultsController"];
	}
	else
	{
		[self setValue:nil forKey:@"defaultsController"];
	}
	return;
}
- (void)windowDidResignMainNotified:(NSNotification *)notification;
{
	[self setValue:nil forKey:@"defaultsController"];
	return;
}
- (void)windowDidLoad;
{
	[super windowDidLoad];
	id WC = [[[NSApplication sharedApplication] mainWindow] windowController];
	if([WC isKindOfClass:[iTM2PDFKitInspector class]])
	{
		[self setValue:WC forKey:@"defaultsController"];
	}
	else
	{
		[self setValue:nil forKey:@"defaultsController"];
	}
	return;
}	
#pragma mark =-=-=-=-=-  PRINT INFO
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  registerPrintInfoNotificationWindowDidLoad
- (void)registerPrintInfoNotificationWindowDidLoad;
/*"Description Forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- 2.0:Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[INC addObserver:self
		selector:@selector(printInfoDidChangeNotified:)
			name:iTM2PrintInfoDidChangeNotification
				object:nil];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  printInfoDidChangeNotified:
- (void)printInfoDidChangeNotified:(NSNotification *)aNotification;
/*"Description Forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- 2.0:Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	iTM2_LOG(@"old:%@", [[aNotification object] dictionary]);
	iTM2_LOG(@"new:%@", [aNotification userInfo]);
//iTM2_END;
    return;
}
@end

@implementation iTM2PDFKitInspector(DEFAULTS)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  showViewerPreferences:
- (IBAction)showViewerPreferences:(id)sender;
/*"Description Forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- 2.0:Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[[[iTM2PDFKitDefaultsController sharedInstance] window] makeKeyAndOrderFront:self];
//iTM2_END;
    return;
}
@end

@interface iTM2PDFKitInspector(CATCHER)
- (IBAction)messageCatcher_iTM2PDFKitInspector:(id)sender;
@end

@implementation iTM2PDFKitInspector(CATCHER)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  messageCatcher_iTM2PDFKitInspector:
- (IBAction)messageCatcher_iTM2PDFKitInspector:(id)sender;
/*"Description Forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- 2.0:Fri Sep 05 2003
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
#define GETTER(KEY) [[self contextValueForKey:iTM2PDFKitKey domain:iTM2ContextAllDomainsMask] valueForKey:KEY]
#define SETTER(KEY, argument) id __D = [[[self contextDictionaryForKey:iTM2PDFKitKey domain:iTM2ContextAllDomainsMask] mutableCopy] autorelease];\
if(!__D) __D = [NSMutableDictionary dictionary];\
[__D setValue:argument forKey:KEY];\
[self takeContextValue:__D forKey:iTM2PDFKitKey domain:iTM2ContextAllDomainsMask];\
[[self contextManager] notifyContextChange];

@implementation NSApplication(iTM2PDFKitResponder)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  load
+ (void)load;
/*"Description forthcoming.
Version History:jlaurens AT users DOT sourceforge DOT net
- 1.3:03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
	iTM2_INIT_POOL;
	iTM2RedirectNSLogOutput();
//iTM2_START;
	[iTM2MileStone registerMileStone:@"No installer available" forKey:@"iTM2PDFKitResponder"];
//iTM2_END;
	iTM2_RELEASE_POOL;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2PDFKitResponderDidFinishLaunching
- (void)iTM2PDFKitResponderDidFinishLaunching;
/*"Description forthcoming.
Version History:jlaurens AT users DOT sourceforge DOT net
- 1.4:Fri Feb 20 13:19:00 GMT 2004
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
Version history:jlaurens AT users DOT sourceforge DOT net
- 2.0:Fri Sep 05 2003
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
Version history:jlaurens AT users DOT sourceforge DOT net
- 2.0:Fri Sep 05 2003
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
Version history:jlaurens AT users DOT sourceforge DOT net
- 2.0:Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	int mode = [GETTER(@"DisplayMode") intValue];
	[sender setState:((mode == kPDFDisplaySinglePage)|| (mode == kPDFDisplaySinglePageContinuous)? NSOnState:NSOffState)];
//iTM2_END;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setFacingPages:
- (IBAction)setFacingPages:(id)sender;
/*"Description Forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- 2.0:Fri Sep 05 2003
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
Version history:jlaurens AT users DOT sourceforge DOT net
- 2.0:Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	int mode = [GETTER(@"DisplayMode") intValue];
	[sender setState:((mode == kPDFDisplayTwoUp)|| (mode == kPDFDisplayTwoUpContinuous)? NSOnState:NSOffState)];
//iTM2_END;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleContinuousPage:
- (IBAction)toggleContinuousPage:(id)sender;
/*"Description Forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- 2.0:Fri Sep 05 2003
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
Version history:jlaurens AT users DOT sourceforge DOT net
- 2.0:Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	int mode = [GETTER(@"DisplayMode") intValue];
	[sender setState:((mode == kPDFDisplaySinglePageContinuous)|| (mode == kPDFDisplayTwoUpContinuous)? NSOnState:NSOffState)];
//iTM2_END;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  bookMode:
- (IBAction)bookMode:(id)sender;
/*"Description Forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- 2.0:Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	SETTER(@"DisplaysAsBook", [NSNumber numberWithBool:![GETTER(@"DisplaysAsBook") boolValue]]);
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateBookMode:
- (BOOL)validateBookMode:(id)sender;
/*"Description Forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- 2.0:Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[sender setState:([GETTER(@"DisplaysAsBook") boolValue]? NSOnState:NSOffState)];
//iTM2_END;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  togglePageBreaks:
- (IBAction)togglePageBreaks:(id)sender;
/*"Description Forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- 2.0:Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	SETTER(@"DisplaysPageBreaks", [NSNumber numberWithBool:![GETTER(@"DisplaysPageBreaks") boolValue]]);
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateTogglePageBreaks:
- (BOOL)validateTogglePageBreaks:(id)sender;
/*"Description Forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- 2.0:Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[sender setState:([GETTER(@"DisplaysPageBreaks") boolValue]? NSOnState:NSOffState)];
//iTM2_END;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  displayMediaBox:
- (IBAction)displayMediaBox:(id)sender;
/*"Description Forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- 2.0:Fri Sep 05 2003
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
Version history:jlaurens AT users DOT sourceforge DOT net
- 2.0:Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[sender setState:([GETTER(@"DisplayBox") intValue] == kPDFDisplayBoxMediaBox? NSOnState:NSOffState)];
//iTM2_END;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  displayCropBox:
- (IBAction)displayCropBox:(id)sender;
/*"Description Forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- 2.0:Fri Sep 05 2003
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
Version history:jlaurens AT users DOT sourceforge DOT net
- 2.0:Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[sender setState:([GETTER(@"DisplayBox") intValue] == kPDFDisplayBoxCropBox? NSOnState:NSOffState)];
//iTM2_END;
    return YES;
}
@end

@implementation iTM2PDFKitPrefPane
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  load
+ (void)initialize;
/*"Description Forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- 2.0:Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	iTM2_INIT_POOL;
	NSMutableDictionary * MD = [NSMutableDictionary dictionary];
	PDFView * V = [[[PDFView allocWithZone:[self zone]] initWithFrame:NSZeroRect] autorelease];
	[MD setObject:[NSNumber numberWithInt:[V displayMode]] forKey:@"DisplayMode"];
	[MD setObject:[NSNumber numberWithInt:[V displayBox]] forKey:@"DisplayBox"];
//	[MD setObject:[V backgroundColor] forKey:@"BackgroundColor"];
	[MD setObject:[NSNumber numberWithBool:[V displaysAsBook]] forKey:@"DisplaysAsBook"];
	[MD setObject:[NSNumber numberWithBool:[V displaysPageBreaks]] forKey:@"DisplaysPageBreaks"];
	[MD setObject:[NSNumber numberWithFloat:[V greekingThreshold]] forKey:@"GreekingThreshold"];
	[MD setObject:[NSNumber numberWithBool:YES] forKey:@"ShouldAntiAlias"];
	[MD setObject:[NSNumber numberWithBool:YES] forKey:@"AutoScales"];
	[SUD registerDefaults:[NSDictionary dictionaryWithObject:MD forKey:iTM2PDFKitKey]];
	iTM2_RELEASE_POOL;
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  prefPaneIdentifier
- (NSString *)prefPaneIdentifier;
/*"Description forthcoming.
Version History:jlaurens AT users DOT sourceforge DOT net
- 1.4:Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	return @"3.PDF.Tiger";
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  defaultsController
- (id)defaultsController;
/*"It is used in bindings. This is the pdfView of the window controller of the main window.
Version history:jlaurens AT users DOT sourceforge DOT net
- 2.1: Tue Jun 17 11:12:01 UTC 2008
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return self;
}
#if 0
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  tabView:didSelectTabViewItem:
- (void)tabView:(NSTabView *)tabView didSelectTabViewItem:(NSTabViewItem *)tabViewItem;
/*"Description Forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- 2.0:Fri Sep 05 2003
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
#define GETTER [[self contextDictionaryForKey:iTM2PDFKitKey domain:iTM2ContextAllDomainsMask] valueForKey:iTM2KeyFromSelector(_cmd)]
#define SETTER(argument) id __D = [[[SUD dictionaryForKey:iTM2PDFKitKey] mutableCopy] autorelease];\
if(!__D) __D = [NSMutableDictionary dictionary];\
[__D setValue:argument forKey:iTM2KeyFromSelector(_cmd)];\
[self setContextValue:__D forKey:iTM2PDFKitKey domain:iTM2ContextAllDomainsMask];
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
	SETTER(([argument isKindOfClass:[NSColor class]]?[NSArchiver archivedDataWithRootObject:argument]:nil));
	return;
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
#pragma mark =-=-=-=-=-  DISPLAY MODE
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  displayMode
- (PDFDisplayMode)displayMode;
{
	return [GETTER intValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setDisplayMode:
- (void)setDisplayMode:(PDFDisplayMode)argument;
{
	SETTER([NSNumber numberWithInt:(int)argument]);
	return;
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
#pragma mark =-=-=-=-=-  ANTI ALIAS
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  shouldAntiAlias
- (BOOL)shouldAntiAlias;
{
	return [GETTER boolValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setShouldAntiAlias:
- (void)setShouldAntiAlias:(BOOL)argument;
{
	SETTER([NSNumber numberWithBool:(int)argument]);
	return;
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
	SETTER([NSNumber numberWithBool:(int)argument]);
	return;
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
#pragma mark =-=-=-=-=-  DISABLED SYNCTEX
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  disabledSyncTeX
- (BOOL)disabledSyncTeX;
{
	return [GETTER boolValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setDisabledSyncTeX:
- (void)setDisabledSyncTeX:(BOOL)disableSyncTeX;
{
	SETTER([NSNumber numberWithBool:disableSyncTeX]);
	return;
}
#pragma mark =-=-=-=-=-  UNCOMPRESSED SYNCTEX
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  uncompressedSyncTeX
- (BOOL)uncompressedSyncTeX;
{
	return [GETTER boolValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setUncompressedSyncTeX:
- (void)setUncompressedSyncTeX:(BOOL)uncompressedSyncTeX;
{
	SETTER([NSNumber numberWithBool:uncompressedSyncTeX]);
	return;
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  displayFocus
- (BOOL)displayFocus;
{
	return ([self displayBullets]&kiTM2PDFSYNCDisplayFocusBullets)>0;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setDisplayFocus:
- (void)setDisplayFocus:(BOOL)yorn;
{	
	[self willChangeValueForKey:@"displayBullets"];
	[self setDisplayBullets:
		(yorn?([self displayBullets]|kiTM2PDFSYNCDisplayFocusBullets):
			([self displayBullets]&~kiTM2PDFSYNCDisplayFocusBullets))];
	[self didChangeValueForKey:@"displayBullets"];
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  displayUserBullets
- (BOOL)displayUserBullets;
{
	return ([self displayBullets]&kiTM2PDFSYNCDisplayUserBullets)>0;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setDisplayUserBullets:
- (void)setDisplayUserBullets:(BOOL)yorn;
{
	[self willChangeValueForKey:@"displayBullets"];
	[self setDisplayBullets:
		(yorn?([self displayBullets]|kiTM2PDFSYNCDisplayUserBullets):
			([self displayBullets]&~kiTM2PDFSYNCDisplayUserBullets))];
	[self didChangeValueForKey:@"displayBullets"];
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  displayBuiltInBullets
- (BOOL)displayBuiltInBullets;
{
	return ([self displayBullets]&kiTM2PDFSYNCDisplayBuiltInBullets)>0;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setDisplayBuiltInBullets:
- (void)setDisplayBuiltInBullets:(BOOL)yorn;
{
	[self willChangeValueForKey:@"displayBullets"];
	[self setDisplayBullets:
		(yorn?([self displayBullets]|kiTM2PDFSYNCDisplayBuiltInBullets):
			([self displayBullets]&~kiTM2PDFSYNCDisplayBuiltInBullets))];
	[self didChangeValueForKey:@"displayBullets"];
	return;
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
    return [NSImage iTM2_cachedImageNamed:NAME];\
}
@implementation NSImage(iTM2PDFKit)
DEFINE_IMAGE(iTM2_imageCaution, @"caution");
DEFINE_IMAGE(iTM2_imageDebugScrollToolbarImage, @"DebugScrollToolbarImage");
DEFINE_IMAGE(iTM2_imageGrabber, @"Grabber");
DEFINE_IMAGE(iTM2_imageLandscape, @"Landscape");
DEFINE_IMAGE(iTM2_imagePortrait, @"Portrait");
DEFINE_IMAGE(iTM2_imageReverseLandscape, @"ReverseLandscape");
DEFINE_IMAGE(iTM2_imageTBRotateLeft, @"TBRotateLeft");
DEFINE_IMAGE(iTM2_imageTBRotateRight, @"TBRotateRight");
DEFINE_IMAGE(iTM2_imageTBSizeToFit, @"TBSizeToFit");
DEFINE_IMAGE(iTM2_imageTBSnowflake, @"TBSnowflake");
DEFINE_IMAGE(iTM2_imageTBZoomActualSize, @"TBZoomActualSize");
DEFINE_IMAGE(iTM2_imageTBZoomIn, @"TBZoomIn");
DEFINE_IMAGE(iTM2_imageTBZoomOut, @"TBZoomOut");
DEFINE_IMAGE(iTM2_imageThumbnailViewAdorn, @"ThumbnailViewAdorn");
DEFINE_IMAGE(iTM2_imageTOCViewAdorn, @"TOCViewAdorn");
DEFINE_IMAGE(iTM2_imageBackAdorn, @"BackAdorn");
DEFINE_IMAGE(iTM2_imageForwardAdorn, @"ForwardAdorn");
DEFINE_IMAGE(iTM2_imageGenericImageDocument, @"Generic");
DEFINE_IMAGE(iTM2_imageMoveToolAdorn, @"MoveToolAdorn");
DEFINE_IMAGE(iTM2_imageTextToolAdorn, @"TextToolAdorn");
DEFINE_IMAGE(iTM2_imageSelectToolAdorn, @"SelectToolAdorn");
DEFINE_IMAGE(iTM2_imageAnnotateTool1Adorn, @"AnnotateTool1Adorn");
DEFINE_IMAGE(iTM2_imageAnnotateTool1AdornDisclosure, @"AnnotateTool1AdornDisclosure");
DEFINE_IMAGE(iTM2_imageAnnotateTool2Adorn, @"AnnotateTool2Adorn");
DEFINE_IMAGE(iTM2_imageAnnotateTool2AdornDisclosure, @"AnnotateTool2AdornDisclosure");
@end

@implementation iTM2ShadowedImageCell
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  drawInteriorWithFrame:inView:
- (void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView;
/*"Description Forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- 2.0:Fri Sep 05 2003
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

#warning THIS IS DEBUG CODE
@interface PDFPage_iTeXMac2:PDFPage
@end
static id PDFPage_iTeXMac2_Storage = nil;
@implementation PDFPage_iTeXMac2
+ (void)load;
{
	iTM2_INIT_POOL;
	iTM2RedirectNSLogOutput();
	[self poseAsClass:[PDFPage class]];
	iTM2_RELEASE_POOL;
	return;
}
+ (void)initialize;
{
	[super initialize];
	PDFPage_iTeXMac2_Storage = [[NSMutableDictionary dictionary] retain];
	return;
}
- (id)init;
{
	if(self = [super init])
	{
		NSValue * V = [NSValue valueWithNonretainedObject:self];
		NSNumber * N = [NSNumber numberWithInt:1];
		[PDFPage_iTeXMac2_Storage setObject:N forKey:V];
	}
	return self;
}
- (id)retain;
{
	NSValue * V = [NSValue valueWithNonretainedObject:self];
	NSNumber * N = [PDFPage_iTeXMac2_Storage objectForKey:V];
	if(N)
	{
		int retainCount = [N intValue];
		if(retainCount)
		{
			N = [NSNumber numberWithInt:++retainCount];
		}
	}
	else
	{
		N = [NSNumber numberWithInt:2];
	}
	[PDFPage_iTeXMac2_Storage setObject:N forKey:V];
	return [super retain];
}
- (void)release;
{
	NSValue * V = [NSValue valueWithNonretainedObject:self];
	NSNumber * N = [PDFPage_iTeXMac2_Storage objectForKey:V];
	if(N)
	{
		int retainCount = [N intValue];
		if(retainCount>1)
		{
			N = [NSNumber numberWithInt:--retainCount];
		}
		else if(retainCount)
		{
			iTM2_LOG(@"WILL DEALLOC");
			N = [NSNumber numberWithInt:--retainCount];// 0 is reached dealloc soon
		}
		[PDFPage_iTeXMac2_Storage setObject:N forKey:V];
	}
	[super release];
	return;
}
- (void)dealloc;
{
	iTM2_LOG(@"DEALLOC %#x", self);
	NSValue * V = [NSValue valueWithNonretainedObject:self];
	[PDFPage_iTeXMac2_Storage removeObjectForKey:V];
	if(iTM2DebugEnabled)
	{
		Class zombie = NSClassFromString(@"NSZombie")?:[NSObject class];
		self->isa = zombie;
	}
	else
	{
		[super dealloc];
	}
	return;
}
@end
