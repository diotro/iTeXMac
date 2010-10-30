/*
//  iTM2MetaPostWrapperKit.m
//  iTeXMac2
//
//  @version Subversion: $Id$ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Tue Sep 11 2001.
//  Copyright © 2001-2004 Laurens'Tribune. All rights reserved.
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

#import "iTM2MetaPostDocumentKit.h"
#import "math.h"

NSString * const iTM2MetaPostDocumentType = @"MetaPost Document";// beware, this MUST appear in the target file...
NSString * const iTM2MetaPostInspectorType = @"MetaPost Type";
NSString * const iTM2MetaPostInspectorMode = @"MetaPost Mode";
NSString * const iTM2MetaPostRENumberedNameKey = @"file-#";
NSString * const iTM2MetaPostRENumberedNameGroupName = @"number";
NSString * const iTM2MetaPostREBeginFigKey = @"beginfig";
NSString * const iTM2MetaPostREBeginFigGroupName = @".";// same as iTM2MetaPostREBeginFigKey
NSString * const iTM2MetaPostREBeginFigNumberGroupName = @"number";

@interface NSURL(__MetaPostOutputFileNames)
- (NSComparisonResult)compareAs__MetaPostOutputFileURLs4iTM3:(NSURL *)fileURL;
@end

@interface iTM2MetaPostDocument(PRIVATE)
- (NSArray *)forwardingTargets;
@end

@interface iTM2MetaPostInspector(PRIVATE)
- (void)updateThumbnailTable;
- (NSMutableArray *)PDFThumbnails;
- (void)renderInBackroundThumbnailAtIndex:(NSUInteger)index;
- (void)synchronizePDFViewWithDocument;
@property (assign) iTM2ToolMode toolMode;
@property (assign) id scaleAndPageTarget;
@end

@implementation iTM2MetaPostDocument
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inspectorMode
+ (NSString *)inspectorType4iTM3;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Thu Mar 11 08:39:37 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return iTM2MetaPostInspectorType;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  PDFDocuments
- (NSMutableDictionary *)PDFDocuments;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Thu Mar 11 08:39:42 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	id result = metaGETTER;
	if (!result) {
		metaSETTER([NSMutableDictionary dictionary]);
		result = metaGETTER;
	}
//END4iTM3;
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  orderedPDFDocumentURLs
- (NSArray *)orderedPDFDocumentURLs;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Thu Mar 11 08:40:05 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	id result = metaGETTER;
	if (!result) {
		metaSETTER([NSMutableArray array]);
		result = metaGETTER;
	}
//END4iTM3;
    return metaGETTER;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  addPDFDocumentFileURL:
- (void)addPDFDocumentFileURL:(NSURL *)argument;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSParameterAssert(argument);
	NSMutableArray * MRA = (NSMutableArray *)self.orderedPDFDocumentURLs;
	if (![MRA containsObject:argument]) {
		[MRA addObject:argument];
		[MRA sortUsingSelector:@selector(compareAs__MetaPostOutputURLs4iTM3:)];
	}
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  removePDFDocumentFileURL:
- (void)removePDFDocumentFileURL:(NSURL *)argument;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSParameterAssert(argument);
	NSMutableArray * MRA = (NSMutableArray *)self.orderedPDFDocumentURLs;
	if ([MRA containsObject:argument]) {
		[MRA removeObject:argument];
	}
	if(argument)
		[self.PDFDocuments removeObjectForKey:argument];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  PDFKitDocumentForFileURL:
- (id)PDFKitDocumentForFileURL:(NSURL *)argument;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	argument = argument.URLByStandardizingPath;
	id result = [self.PDFDocuments objectForKey:argument];
	if (!result) {
		NSString * typeName = (NSString *)kUTTypePDF;
		Class C = [SDC documentClassForType:typeName];
		result = [[[C alloc] initWithContentsOfURL:argument ofType:typeName error:nil] autorelease];
		if (result) {
			[self.PDFDocuments setObject:result forKey:argument];
		}
		result = [self.PDFDocuments objectForKey:argument];
	}
//END4iTM3;
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  PDFDocumentsCompleteReadFromURL:ofType:
- (BOOL)PDFDocumentsCompleteReadFromURL:(NSURL *)fileURL ofType:(NSString *)type;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Thu Mar 11 09:21:32 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSMutableArray * __OrderedFileURLs = [NSMutableArray array];
	NSURL * directoryURL = [fileURL.URLByDeletingPathExtension URLByAppendingPathExtension:@"pdfd"];
	NSString * baseName = [NSString stringWithFormat:@"%@-", directoryURL.lastPathComponent.stringByDeletingPathExtension];
	NSString * component;
    NSURL * url = nil;
	for (component in [DFM contentsOfDirectoryAtPath:directoryURL.path error:NULL]) {
		if([component hasPrefix:baseName]) {
            url = [NSURL URLWithPath4iTM3:component relativeToURL:directoryURL];
            if ([[SDC documentClassForType:[SDC typeForContentsOfURL:url error:NULL]] isSubclassOfClass:[iTM2PDFDocument class]]) {
                [__OrderedFileURLs addObject:url];
            }
		}
	}
	if (!__OrderedFileURLs.count) {
		// this was not a wrapper where all the files were collected
		directoryURL = directoryURL.URLByDeletingLastPathComponent;
		for (component in [DFM contentsOfDirectoryAtPath:directoryURL.path error:NULL]) {
			if ([component hasPrefix:baseName]) {
                url = [NSURL URLWithPath4iTM3:component relativeToURL:directoryURL];
                if ([[SDC documentClassForType:[SDC typeForContentsOfURL:url error:NULL]] isSubclassOfClass:[iTM2PDFDocument class]]) {
                    [__OrderedFileURLs addObject:url];
                }
            }
		}
	}
	// comparison:
	NSMutableArray * alreadyFileURLs = [self.orderedPDFDocumentURLs mutableCopy];
	[alreadyFileURLs removeObjectsInArray:__OrderedFileURLs];
	// alreadyFileNames now contains obsolete file names to be removed
	[__OrderedFileURLs removeObjectsInArray:self.orderedPDFDocumentURLs];
	// alreadyFileNames now contains only the documents to be added file names to be removed
	for (url in alreadyFileURLs) {
		[self removePDFDocumentFileURL:url];
	}
	for (url in __OrderedFileURLs) {
		[self addPDFDocumentFileURL:url];
	}
//END4iTM3;
    return YES;
}
#pragma mark =-=-=-=-=-  UPDATING
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= updateIfNeeded
- (void)updateIfNeeded;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Thu Mar 11 09:21:37 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[(NSMutableArray *)self.orderedPDFDocumentURLs setArray:[NSArray array]];
	NSDictionary * oldDocuments = [NSDictionary dictionaryWithDictionary:self.PDFDocuments];
	[self.PDFDocuments setDictionary:[NSDictionary dictionary]];
	[super updateIfNeeded];
	if ([self PDFDocumentsCompleteReadFromURL:self.fileURL ofType:self.fileType]) {
		// retrieving the old PDF documents
		NSDocument * document = nil;
		for (NSURL * url in self.orderedPDFDocumentURLs)
			if(document = [oldDocuments objectForKey:url])
				[self.PDFDocuments setObject:document forKey:url];
		for (document in self.PDFDocuments)
			[document updateIfNeeded];
		[self.windowControllers makeObjectsPerformSelector:@selector(synchronizePDFViewWithDocument) withObject:nil];
	} else {
		LOG4iTM3(@"**** Error while reading the pdf's");
	}
//END4iTM3;
    return;
}
#pragma mark =-=-=-=-=-  FORWARDING
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  forwardingTargets
- (NSArray *)forwardingTargets;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Thu Mar 11 09:23:19 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	iTM2MetaPostInspector * inspector = self.windowControllers.lastObject;
	NSUInteger index = [inspector.outputFigureNumbers indexOfObject:inspector.currentOutputFigure];
	NSArray * ODFNs = self.orderedPDFDocumentURLs;
	if ((index>=0) && (index<ODFNs.count)) {
		return [NSArray arrayWithObject:[self PDFKitDocumentForFileURL:[ODFNs objectAtIndex:index]]];
	}
//END4iTM3;
    return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  forwardInvocation:
- (void)forwardInvocation:(NSInvocation *)anInvocation;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Thu Mar 11 09:25:00 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	SEL selector = [anInvocation selector];
	for (id target in self.forwardingTargets) {
		if([target respondsToSelector:selector]) {
			[anInvocation invokeWithTarget:target];
			return;
		}
	}
	[super forwardInvocation:anInvocation];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  methodSignatureForSelector:
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Thu Mar 11 09:26:17 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	id result = [super methodSignatureForSelector:aSelector];
	if(result)
		return result;
	for (id target in self.forwardingTargets)
		if(result = [target methodSignatureForSelector:aSelector])
			return result;
//END4iTM3;
    return nil;
}
@end

@interface iTM2PDFKitDocument(MetaPost)
- (NSNumber *)metaPostViewScaleNumber;
- (void)setMetaPostViewScaleNumber:(NSNumber *)factor;
- (NSPoint)metaPostViewFocus;
- (void)setMetaPostViewFocus:(NSPoint)point;
@end

@implementation iTM2PDFKitDocument(MetaPost)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  metaPostViewScaleNumber
- (NSNumber *)metaPostViewScaleNumber;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Thu Mar 11 09:26:46 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return metaGETTER;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setMetaPostViewScaleNumber:
- (void)setMetaPostViewScaleNumber:(NSNumber *)factor;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Thu Mar 11 09:26:50 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	metaSETTER(factor);
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  metaPostViewFocus
- (NSPoint)metaPostViewFocus;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Thu Mar 11 09:27:13 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return NSMakePoint(0, 0);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setMetaPostViewFocus:
- (void)setMetaPostViewFocus:(NSPoint)point;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Thu Mar 11 09:27:18 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return;
}
@end

@implementation NSURL(__MetaPostOutputFileNames)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  compareAs__MetaPostOutputFileURLs4iTM3:
- (NSComparisonResult)compareAs__MetaPostOutputFileURLs4iTM3:(NSURL *)fileURL;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Thu Mar 11 08:46:05 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSComparisonResult result = [self.URLByDeletingLastPathComponent.path compare:fileURL.URLByDeletingLastPathComponent.path];
	if (result == NSOrderedSame) {
        NSString * left = self.path;
		NSString * right = fileURL.path;
		NSUInteger commonPrefixLength = [[left commonPrefixWithString:right options:0] length];
		left = [[left substringWithRange:iTM3MakeRange(commonPrefixLength, left.length - commonPrefixLength)] stringByDeletingPathExtension];
		right = [[right substringWithRange:iTM3MakeRange(commonPrefixLength, right.length - commonPrefixLength)] stringByDeletingPathExtension];
        ICURegEx * RE = [ICURegEx regExForKey:iTM2MetaPostRENumberedNameKey inBundle:myBUNDLE error:NULL];
        if (![RE matchString:left]) {
            RE.forget;
			return [left compare:right];
        }
        NSInteger leftInteger = [[RE substringOfCaptureGroupWithName:iTM2MetaPostRENumberedNameGroupName] integerValue];
        if (![RE matchString:right]) {
            RE.forget;
			return [left compare:right];
        }
        NSInteger rightInteger = [[RE substringOfCaptureGroupWithName:iTM2MetaPostRENumberedNameGroupName] integerValue];
        RE.forget;
		return leftInteger>rightInteger? NSOrderedDescending:
			(leftInteger<rightInteger? NSOrderedAscending: NSOrderedSame);
	}
	return result;
}
@end

#import <objc/objc-class.h>

@implementation iTM2MetaPostInspector
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inspectorMode
+ (NSString *)inspectorType4iTM3;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Thu Mar 11 08:50:04 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return iTM2MetaPostInspectorType;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inspectorMode
+ (NSString *)inspectorMode;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Thu Mar 11 08:50:09 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return iTM2DefaultInspectorMode;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  metaPostCompleteWindowDidLoad4iTM3
- (void)metaPostCompleteWindowDidLoad4iTM3;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Thu Mar 11 08:50:25 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[DNC addObserver:self selector:@selector(PDFViewScaleChangedNotified:) name:PDFViewScaleChangedNotification object:self.pdfView];
	[self.PDFThumbnails setArray:[NSArray array]];
	[self setCurrentOutputFigure: ([self contextValueForKey:@"CurrentOutputFigure" domain:iTM2ContextAllDomainsMask]?:[[self.outputFigureNumbers objectEnumerator] nextObject])];
	self.thumbnailTable.target = self;
	self.thumbnailTable.action = @selector(thumbnailTableAction:);
	self.thumbnailTable.doubleAction = @selector(thumbnailTableDoubleAction:);
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleDrawer:
- (IBAction)toggleDrawer:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Thu Mar 11 08:50:39 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[self.drawer toggle:sender];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  outputFigureNumbers
- (NSArray *)outputFigureNumbers;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Thu Mar 11 09:05:26 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSMutableArray * result = metaGETTER;
	if (!result) {
		metaSETTER([NSMutableArray array]);
		result = metaGETTER;
	}
	if (!result.count) {
		NSArray * orderedPDFDocumentURLs = [self.document orderedPDFDocumentURLs];
        ICURegEx * RE = [ICURegEx regExForKey:iTM2MetaPostRENumberedNameKey inBundle:myBUNDLE error:NULL];
		for (NSURL * fileURL in orderedPDFDocumentURLs) {
            if ([RE matchString:fileURL.lastPathComponent.stringByDeletingPathExtension]) {
                [result addObject:[NSNumber numberWithUnsignedInteger:[RE substringOfCaptureGroupWithName:iTM2MetaPostRENumberedNameGroupName].integerValue]];
            }
		}
        RE.forget;
		if (orderedPDFDocumentURLs.count != result.count) {
			LOG4iTM3(@"Unexpected situation, things won't work properly... (bad file names)");
		}
	}
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setOutputFigureNumbers:
- (void)setOutputFigureNumbers:(id)argument;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Thu Mar 11 09:05:32 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
// binding catcher
//END4iTM3
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  currentOutputFigure
- (NSNumber *)currentOutputFigure;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Thu Mar 11 09:36:17 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return metaGETTER?: self.outputFigureNumbers.objectEnumerator.nextObject;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setCurrentOutputFigure:
- (void)setCurrentOutputFigure:(NSNumber *)argument;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Thu Mar 11 09:36:25 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (![argument isKindOfClass:[NSNumber class]]) {
        argument = [NSNumber numberWithUnsignedInteger:argument.unsignedIntegerValue];
    }
	iTM2PDFKitDocument * doc = self.currentPDFKitDocument;
	if ([self.currentOutputFigure isEqual:argument]) {
		if (doc) {
			self.pdfView.document = doc.PDFDocument;
			return;
		}
	}
	[doc setMetaPostViewScaleNumber:[NSNumber numberWithFloat:self.pdfView.scaleFactor]];
	metaSETTER(argument);
	doc = self.currentPDFKitDocument;// there is there a side effect to the line above
	if (!doc) {
		argument = self.outputFigureNumbers.objectEnumerator.nextObject;
		metaSETTER(argument);
		doc = self.currentPDFKitDocument;
	}
	[self takeContextValue:metaGETTER forKey:@"CurrentOutputFigure" domain:iTM2ContextAllDomainsMask];
	self.pdfView.document = doc.PDFDocument;
	NSNumber * N = [doc metaPostViewScaleNumber];
	if(N)
		self.pdfView.scaleFactor = (N.floatValue?:1.0);
	else
		[self.pdfView zoomToFit:self];
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  currentPDFKitDocument
- (id)currentPDFKitDocument;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Thu Mar 11 09:36:38 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSUInteger index = [self.outputFigureNumbers indexOfObject:self.currentOutputFigure];
	NSArray * ODFUs = [self.document orderedPDFDocumentURLs];
	if ((index>=0) && (index<ODFUs.count)) {
		NSURL * url = [ODFUs objectAtIndex:index];
		return [self.document PDFKitDocumentForFileURL:url];
	}
//END4iTM3;
    return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  logarithmScaleFactor
- (CGFloat)logarithmScaleFactor;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Thu Mar 11 09:37:50 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return 2*log2f(MAX(0, self.pdfView.scaleFactor));
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setLogarithmScaleFactor:
- (void)setLogarithmScaleFactor:(CGFloat)argument;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Thu Mar 11 09:37:58 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	CGFloat old = self.pdfView.scaleFactor;
	CGFloat new = powf(2, argument/2);
	if(fabsf(old - new) > 0.001*new)
		self.pdfView.scaleFactor = new;
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  PDFViewScaleChangedNotified:
- (void)PDFViewScaleChangedNotified:(NSNotification *)notification;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Thu Mar 11 09:38:29 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[self setLogarithmScaleFactor:2*log2f(MAX(0, [(PDFView *)[notification object] scaleFactor]))];
	[self.window.toolbar validateVisibleItems];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  synchronizeWithDocument [NSLayoutManager
- (void)synchronizeWithDocument;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Thu Mar 11 09:38:32 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [super synchronizeWithDocument];
	self.synchronizePDFViewWithDocument;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  synchronizePDFViewWithDocument
- (void)synchronizePDFViewWithDocument;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Thu Mar 11 09:38:36 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[(NSMutableArray *)self.outputFigureNumbers setArray:[NSArray array]];
	[self setOutputFigureNumbers:self.outputFigureNumbers];// side effects expected
	[self.PDFThumbnails setArray:[NSArray array]];
	self.updateThumbnailTable;
	[self setCurrentOutputFigure:self.currentOutputFigure];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  drawerDidOpen:
- (void)drawerDidOpen:(NSNotification *)notification;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Thu Mar 11 09:39:57 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	self.updateThumbnailTable;
//END4iTM3;
    return;
}
#pragma mark =-=-=-=-=-  SPLITVIEW
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  splitView:canCollapseSubview:
- (BOOL)splitView:(NSSplitView *)sender canCollapseSubview:(NSView *)subview
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Thu Mar 11 09:40:04 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  splitView:constrainMinCoordinate:ofSubviewAt:
- (CGFloat)splitView:(NSSplitView *)sender constrainMinCoordinate:(CGFloat)proposedMin ofSubviewAt:(NSInteger)offset
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Thu Mar 11 09:40:11 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return proposedMin+50;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  splitView:constrainMaxCoordinate:ofSubviewAt:
- (CGFloat)splitView:(NSSplitView *)sender constrainMaxCoordinate:(CGFloat)proposedMax ofSubviewAt:(NSInteger)offset
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Thu Mar 11 09:40:16 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return proposedMax-50;
}
#pragma mark =-=-=-=-=-  TABLE VIEW
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  PDFThumbnails
- (NSMutableArray *)PDFThumbnails;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Thu Mar 11 09:40:33 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	id result = metaGETTER;
	if (!result) {
		metaSETTER([NSMutableArray arrayWithCapacity:10]);
		result = metaGETTER;
	}
//END4iTM3;
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  updateThumbnailTable
- (void)updateThumbnailTable;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Thu Mar 11 09:41:01 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (!self.PDFThumbnails.count) {
		NSUInteger index = self.outputFigureNumbers.count;
		while(index--)
			[self.PDFThumbnails addObject:[NSImage imageGenericImageDocument4iTM3]];
	}
	[self.thumbnailTable reloadData];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  numberOfRowsInTableView:
- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Thu Mar 11 09:41:05 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return self.PDFThumbnails.count;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  tableView:objectValueForTableColumn:row:
- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)theColumn row:(NSInteger)rowIndex;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
	if ([theColumn.identifier isEqualToString:@"thumbnail"]) {
		NSImage * I = [self.PDFThumbnails objectAtIndex:rowIndex];
		if ([I isEqual:[NSImage imageGenericImageDocument4iTM3]]) {
			[self renderInBackroundThumbnailAtIndex:rowIndex];
		}
		return I;
	} else if ([theColumn.identifier isEqualToString:@"page"]) {
		return [self.outputFigureNumbers objectAtIndex:rowIndex];
	}
	return nil;
}
static NSMutableDictionary * _iTM2MetaPostRenderInBackgroundThumbnails = nil;
static BOOL _iTM2MetaPostThreadedRenderInBackgroundThumbnails = NO;
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  renderInBackroundThumbnailAtIndex:
- (void)renderInBackroundThumbnailAtIndex:(NSUInteger)index;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Thu Mar 11 09:43:06 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//LOG4iTM3(@"index is: %u", index);
	if([SUD boolForKey:@"iTM2PDFDontRenderThumbnailsInBackground"])
		return;
	if (!_iTM2MetaPostRenderInBackgroundThumbnails) {
		_iTM2MetaPostRenderInBackgroundThumbnails = [NSMutableDictionary dictionary];
	}
	NSValue * V = [NSValue valueWithPointer:self];
	NSMutableArray * array = [_iTM2MetaPostRenderInBackgroundThumbnails objectForKey:V];
	if (!array) {
		[_iTM2MetaPostRenderInBackgroundThumbnails setObject:[NSMutableArray array] forKey:V];
		array = [_iTM2MetaPostRenderInBackgroundThumbnails objectForKey:V];
	}
	id newObject = [NSNumber numberWithUnsignedInteger:index];
	[array removeObject:newObject];
	[array addObject:newObject];
	if (_iTM2MetaPostThreadedRenderInBackgroundThumbnails)
		return;
	if (_iTM2MetaPostRenderInBackgroundThumbnails.count) {
		LOG4iTM3(@"XXXXXX  detachNewThreadSelector");
		_iTM2MetaPostThreadedRenderInBackgroundThumbnails = YES;
		[NSThread detachNewThreadSelector:@selector(detachedRenderThumbnailsInBackground:) toTarget:self.class withObject:nil];
	}
//END4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  detachedRenderThumbnailsInBackground:
+ (void)detachedRenderThumbnailsInBackground:(id)irrelevant;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Thu Mar 11 09:43:10 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
	INIT_POOL4iTM3;
//START4iTM3;
	NSLock * L = [[NSLock alloc] init];
loop:
	[L lock];
	NSMutableDictionary * MD = [[_iTM2MetaPostRenderInBackgroundThumbnails mutableCopy] autorelease];
	[L unlock];
	NSValue * V = nil;
	for (V in MD.allKeys) {
		iTM2MetaPostInspector * inspector = [V pointerValue];
		for (NSWindow * w in [NSApp orderedWindows]) {
			if ([inspector isEqual:w.windowController]) {
				// this is the real inspector
				[L lock];
				NSArray * array = [_iTM2MetaPostRenderInBackgroundThumbnails objectForKey:V];
				if (array.count) {
					[MD setObject:[[array mutableCopy] autorelease] forKey:V];
					[L unlock];
					for (NSNumber * N in [[MD objectForKey:V] reverseObjectEnumerator]) {
						NSUInteger pageIndex = N.unsignedIntegerValue;
//LOG4iTM3(@"pageIndex is: %u", pageIndex);
						iTM2MetaPostDocument * document = inspector.document;
						NSArray * RA = document.orderedPDFDocumentURLs;
						if ((pageIndex < RA.count) && (pageIndex < inspector.PDFThumbnails.count)) {
							[L lock];
							PDFPage * page = [[[document PDFKitDocumentForFileURL:[RA objectAtIndex:pageIndex]] PDFDocument] pageAtIndex:0];
							NSData * D = [[page.dataRepresentation copy] autorelease];// there was a crash here (bad access)
							[L unlock];
							NSImage * tmpI = [[[NSImage alloc] initWithData:D] autorelease];// tiff?
							[tmpI setScalesWhenResized:YES];
							#if 0
							NSSize S = [tmpI size];
							CGFloat w = size.width  / S.width;
							CGFloat h = size.height / S.height;
							if (h>w) {
								S.width  *= w;
								S.height *= w;
							} else {
								S.width  *= h;
								S.height *= h;
							}
							[tmpI setSize:S];
							#elif 0
							NSImage * newI = [[[NSImage alloc] initWithSize:size] autorelease];// tiff?
							NSRect fromRect = NSZeroRect;
							fromRect.size = [tmpI size];
							CGFloat w = size.width  / fromRect.size.width;
							CGFloat h = size.height / fromRect.size.height;
							NSRect rect;
							if(h>w) {
								fromRect.size.width  *= w;
								fromRect.size.height *= w;
								rect = fromRect;
								rect.origin.y += (size.height-rect.size.height)/2;
							} else {
								fromRect.size.width  *= h;
								fromRect.size.height *= h;
								rect = fromRect;
								rect.origin.x += (size.width-rect.size.width)/2;
							}
							[tmpI setSize:fromRect.size];
							[newI lockFocus];
							[tmpI drawInRect:rect fromRect:fromRect operation:NSCompositeCopy fraction:1.0];
							[newI unlockFocus];
							#endif
							[L lock];
							[inspector.PDFThumbnails replaceObjectAtIndex:pageIndex withObject:tmpI];
							[L unlock];
							[inspector performSelectorOnMainThread:@selector(updateThumbnailTable) withObject:nil waitUntilDone:NO];
						}
					}
				} else {
					[L unlock];
				}
			}
		}
	}
	// everything is made...
	[L lock];
	for (V in _iTM2MetaPostRenderInBackgroundThumbnails.allKeys) {
		NSMutableArray * array = [_iTM2MetaPostRenderInBackgroundThumbnails objectForKey:V];
		[array removeObjectsInArray:[MD objectForKey:V]];
		if (!array.count) {
			[_iTM2MetaPostRenderInBackgroundThumbnails removeObjectForKey:V];
		}
	}
	[L unlock];
	[L release];
	L = nil;
	if(_iTM2MetaPostRenderInBackgroundThumbnails.count)
		goto loop;
	_iTM2MetaPostThreadedRenderInBackgroundThumbnails = NO;
//END4iTM3;
	RELEASE_POOL4iTM3;
	[NSThread exit];
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  tableViewSelectionDidChange:
- (void)tableViewSelectionDidChange:(NSNotification *)notification;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Thu Mar 11 09:51:36 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSTableView * TV = (NSTableView *)[notification object];
	if (TV == self.thumbnailTable) {
		NSInteger rowIndex = [TV selectedRow];
		if (rowIndex >= 0) {
			[self setCurrentOutputFigure:[self.outputFigureNumbers objectAtIndex:rowIndex]];
		}
    }
//END4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  thumbnailTableAction:
- (IBAction)thumbnailTableAction:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Thu Mar 11 09:51:52 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  thumbnailTableDoubleAction:
- (IBAction)thumbnailTableDoubleAction:(NSTableView *)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Thu Mar 11 08:03:43 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (sender == self.thumbnailTable) {
		NSInteger rowIndex = self.thumbnailTable.selectedRow;
		if (rowIndex >= 0) {
			[self.textView highlightAndScrollMetaPostFigureToVisible4iTM3:[[self.outputFigureNumbers objectAtIndex:rowIndex] integerValue]];
		}
    }
//END4iTM3;
	return;
}
#pragma mark =-=-=-=-=-  FORWARDING
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  forwardingTargets
- (NSArray *)forwardingTargets;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Thu Mar 11 08:06:47 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	id result = metaGETTER;
	if (!result && self.pdfView) {
		iTM2PDFKitInspector * inspector = [[[iTM2PDFKitInspector alloc] initWithWindow:nil] autorelease];
		metaSETTER([NSMutableArray arrayWithObject:inspector]);
        object_setInstanceVariable(inspector, "_pdfView", self.pdfView);// readonly
		result = metaGETTER;
	}
//END4iTM3;
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  respondsToSelector:
- (BOOL)respondsToSelector:(SEL)aSelector;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Thu Mar 11 08:10:13 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if ([self.superclass instancesRespondToSelector: (SEL) aSelector])
		return YES;
	for (id target in self.forwardingTargets)
		if([target respondsToSelector:aSelector])
			return YES;
//END4iTM3;
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  forwardInvocation:
- (void)forwardInvocation:(NSInvocation *)anInvocation;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Thu Mar 11 08:10:08 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	SEL selector = [anInvocation selector];
	for (id target in self.forwardingTargets) {
		if ([target respondsToSelector:selector]) {
			[anInvocation invokeWithTarget:target];
			return;
		}
	}
	[super forwardInvocation:anInvocation];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  methodSignatureForSelector:
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Thu Mar 11 08:10:57 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSMethodSignature * result = [super methodSignatureForSelector:aSelector];
	if(result)
		return result;
	for (id target in self.forwardingTargets)
		if(result = [target methodSignatureForSelector:aSelector])
			return result;
//END4iTM3;
    return nil;
}
@synthesize pdfView = iVarPdfView4iTM3;
@synthesize drawer = iVarDrawer4iTM3;
@synthesize drawerView = iVarDrawerView4iTM3;
@synthesize thumbnailTable = iVarThumbnailTable4iTM3;
@synthesize toolbarToolModeView = iVarToolbarToolModeView4iTM3;
@synthesize toolbarBackForwardView = iVarToolbarBackForwardView4iTM3;
@synthesize toolMode = iVarToolMode4iTM3;
@end

@implementation iTM2MetaPostWindow
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  makeFirstResponder:
- (BOOL)makeFirstResponder:(NSResponder *)aResponder;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Thu Mar 11 10:44:38 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if ([super makeFirstResponder:aResponder]) {
		[self.windowController setScaleAndPageTarget:aResponder];
		return YES;
	}
//END4iTM3;
    return NO;
}
@end

@implementation iTM2MetaPostEditor
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  zoomIn:
- (IBAction)zoomIn:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Thu Mar 11 10:44:46 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[self doZoomIn:sender];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  zoomOut:
- (IBAction)zoomOut:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Thu Mar 11 10:44:51 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[self doZoomOut:sender];
//END4iTM3;
    return;
}
@end

@implementation NSTextView(iTM2MetaPostKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  highlightAndScrollMetaPostFigureToVisible4iTM3:
- (void)highlightAndScrollMetaPostFigureToVisible4iTM3:(NSInteger)figure;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Thu Mar 11 10:44:57 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	ICURegEx * RE = [ICURegEx regExForKey:iTM2MetaPostREBeginFigKey inBundle:myBUNDLE error:NULL];
    RE.inputString = self.textStorage.string;
    if (RE.nextMatch) {
        [self highlightAndScrollToVisibleRange:[RE rangeOfCaptureGroupWithName:iTM2MetaPostREBeginFigNumberGroupName]];
    }
//END4iTM3;
    RE.forget;
    return;
}
@end

@implementation iTM2MetaPostPDFView
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  keyBindingsManagerIdentifier
- (NSString *)keyBindingsManagerIdentifier;
/*"Just to autorelease the window controller of the window.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Thu Mar 11 11:01:01 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return iTM2PDFKitKeyBindingsIdentifier;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  handlesKeyBindings4iTM3
- (BOOL)handlesKeyBindings4iTM3;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Thu Mar 11 11:01:03 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  tryToExecuteMacroWithID4iTM3:
- (BOOL)tryToExecuteMacroWithID4iTM3:(NSString *)instruction;
/*"Description forthcoming.
If the event is a 1 char key down, it will ask the current key binding for instruction.
The key and its modifiers are 
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    BOOL result = [super tryToExecuteMacroWithID4iTM3:instruction];
    if(result)
        return result;
    if (instruction.length) {
//LOG4iTM3(@"instruction is: %@", instruction);
		[self.window pushKeyStroke:[instruction substringWithRange:iTM3MakeRange(0, 1)]];
		return YES;
    }
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= handlesKeyStrokes4iTM3
- (BOOL)handlesKeyStrokes4iTM3;
/*"YES.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Thu Mar 11 11:01:26 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= deleteBackward:
- (void)deleteBackward:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Thu Mar 11 11:01:31 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if(self.window.keyStrokes4iTM3.length)
		[self.window flushLastKeyStrokeEvent4iTM3:self];
	else
		NSBeep();
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  actualSize:
- (IBAction)actualSize:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Thu Mar 11 11:05:09 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	self.scaleFactor = 1.0;
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateActualSize:
- (BOOL)validateActualSize:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Thu Mar 11 11:05:01 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return self.scaleFactor != 1.0;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= doZoomIn:
- (void)doZoomIn:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Thu Mar 11 11:05:04 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSInteger n = 100 * ([self context4iTM3FloatForKey:@"iTM2ZoomFactor" domain:iTM2ContextAllDomainsMask]>0?: 1.259921049895);
    [self.window.keyStrokes4iTM3 getIntegerTrailer4iTM3: &n];
	if(n>0)
		self.scaleFactor *= n / 100.0;
    [self.window flushKeyStrokeEvents4iTM3:self];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= doZoomOut:
- (void)doZoomOut:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Thu Mar 11 12:10:20 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSInteger n = 100 * ([self context4iTM3FloatForKey:@"iTM2ZoomFactor" domain:iTM2ContextAllDomainsMask]>0?: 1.259921049895);
    [[self.window keyStrokes4iTM3] getIntegerTrailer4iTM3: &n];
	if(n>0)
		self.scaleFactor *= 100.0 / n;
    [self.window flushKeyStrokeEvents4iTM3:self];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= doZoomToFit:
- (void)doZoomToFit:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Thu Mar 11 12:10:29 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	// get the current page
	[self zoomToFit:sender];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= doZoomToSelection:
- (void)doZoomToSelection:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Thu Mar 11 12:10:34 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	#warning NOT YET IMPLEMENTED
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= doGoToPreviousPage:
- (void)doGoToPreviousPage:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Thu Mar 11 12:12:32 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	iTM2MetaPostInspector * inspector = self.window.windowController;
 	if(!inspector.outputFigureNumbers.count)
		return;
	NSInteger n = 1;
    [self.window.keyStrokes4iTM3 getIntegerTrailer4iTM3:&n];
	if(!n)
		return;
	NSUInteger pageIndex = [inspector.outputFigureNumbers indexOfObject:inspector.currentOutputFigure];
	if(pageIndex < 1)
		return;
	if(pageIndex > n)
		 pageIndex -= n;
	else
		pageIndex = 0;
	inspector.currentOutputFigure = [inspector.outputFigureNumbers objectAtIndex:pageIndex];
    [self.window flushKeyStrokeEvents4iTM3:self];
	self.validateWindowContent4iTM3;
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= goToPreviousPage:
- (void)goToPreviousPage:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Thu Mar 11 12:19:46 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	iTM2MetaPostInspector * inspector = self.window.windowController;
 	if (!inspector.outputFigureNumbers.count)
		return;
	NSInteger n = 1;
	NSUInteger pageIndex = [inspector.outputFigureNumbers indexOfObject:inspector.currentOutputFigure];
	if(pageIndex < 1)
		return;
	if(pageIndex > n)
		 pageIndex -= n;
	else
		pageIndex = 0;
	inspector.currentOutputFigure = [inspector.outputFigureNumbers objectAtIndex:pageIndex];
	self.validateWindowContent4iTM3;
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= doGoToNextPage:
- (void)doGoToNextPage:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Thu Mar 11 12:19:42 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	iTM2MetaPostInspector * inspector = self.window.windowController;
	if (!inspector.outputFigureNumbers.count)
		return;
    NSInteger n = 1;
    [self.window.keyStrokes4iTM3 getIntegerTrailer4iTM3: &n];
	if(!n)
		return;
	NSUInteger pageIndex = [inspector.outputFigureNumbers indexOfObject:inspector.currentOutputFigure];
	pageIndex += n;
	inspector.currentOutputFigure = [inspector.outputFigureNumbers objectAtIndex:MIN(pageIndex, inspector.outputFigureNumbers.count - 1)];
    [self.window flushKeyStrokeEvents4iTM3:self];
	self.validateWindowContent4iTM3;
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= goToNextPage:
- (void)goToNextPage:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Thu Mar 11 12:19:39 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	iTM2MetaPostInspector * inspector = self.window.windowController;
	if(!inspector.outputFigureNumbers.count)
		return;
    NSInteger n = 1;
	NSUInteger pageIndex = [inspector.outputFigureNumbers indexOfObject:inspector.currentOutputFigure];
	pageIndex += n;
	inspector.currentOutputFigure = [inspector.outputFigureNumbers objectAtIndex:MIN(pageIndex, inspector.outputFigureNumbers.count - 1)];
	self.validateWindowContent4iTM3;
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= displayZoom:
- (void)displayZoom:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Thu Mar 11 12:19:36 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSInteger n = 100;
    [self.window.keyStrokes4iTM3 getIntegerTrailer4iTM3: &n];
    self.scaleFactor = n/100.0;
    [self.window flushKeyStrokeEvents4iTM3:self];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= displayPage:
- (void)displayPage:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Thu Mar 11 12:19:32 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSInteger n = 1;
    if(![self.window.keyStrokes4iTM3 getIntegerTrailer4iTM3: &n])
		return;
	if(n<1)
		n = 0;
	else
		--n;
	[self.window.windowController setCurrentOutputFigure:[NSString stringWithFormat:@"%i", n]];
    [self.window flushKeyStrokeEvents4iTM3:self];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  pdfSynchronizeMouseDown:
- (BOOL)pdfSynchronizeMouseDown:(NSEvent *)theEvent;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Thu Mar 11 12:19:28 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    iTM2MetaPostInspector * inspector = self.window.windowController;
	[inspector.textView highlightAndScrollMetaPostFigureToVisible4iTM3:inspector.currentOutputFigure.integerValue];
//END4iTM3;
    return YES;
}
@end

#define DEFINE_IMAGE(SELECTOR, NAME)\
+ (NSImage *)SELECTOR;\
{\
    return [NSImage cachedImageNamed4iTM3:NAME];\
}

@implementation NSImage(iTM2MetaPost)
DEFINE_IMAGE(imageLarger4iTM3, @"iTM2Larger");
DEFINE_IMAGE(imageSmaller4iTM3, @"iTM2Smaller");
@end

#define TABLE @"iTM2MetaPost"
#define BUNDLE [iTM2MetaPostDocument classBundle4iTM3]

#pragma mark -
#pragma mark =-=-=-=-=-  FIGURES
@implementation iTM2MetaPostEditor(Figures)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertMetaPostFigure:
- (IBAction)insertMetaPostFigure:(id)sender; 
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Thu Mar 11 12:19:57 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSString * macro = NSLocalizedStringWithDefaultValue(NSStringFromSelector(_cmd),
		TABLE, BUNDLE, @"beginfig(__(Number)__)\nendfig;", "Inserting a  macro");
	NSUInteger start, end, contentsEnd;
	NSRange selectedRange = self.selectedRange;
	[[self.textStorage string] getLineStart: &start end: &end contentsEnd: &contentsEnd forRange:selectedRange];
	NSString * prefix = @"";
	NSString * suffix = @"";
	if (iTM3MaxRange(selectedRange)>contentsEnd) {
		selectedRange.length += end - iTM3MaxRange(selectedRange);
		suffix = @"\n";
		if(start<selectedRange.location) {
			prefix = @"\n";
		}
		[self setSelectedRange:selectedRange];
	} else if(start<selectedRange.location) {
		selectedRange.location = start;
		selectedRange.length = 0;
		suffix = @"\n";
		[self setSelectedRange:selectedRange];
	}
	[self insertMacro:[NSString stringWithFormat:@"%@%@%@", prefix, macro, suffix]];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  pdfSynchronizeMouseDown:
- (BOOL)pdfSynchronizeMouseDown:(NSEvent *)anEvent;
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Thu Mar 11 12:25:09 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	ICURegEx * RE = [ICURegEx regExForKey:iTM2MetaPostREBeginFigKey inBundle:myBUNDLE error:NULL];
	NSLayoutManager * LM = self.layoutManager;
	NSPoint P = [self convertPoint:anEvent.locationInWindow fromView:nil];
	NSTextContainer * TC = self.textContainer;
	NSUInteger charIndex = [LM glyphIndexForPoint:P inTextContainer:TC];
	charIndex = [LM characterIndexForGlyphAtIndex:charIndex];
    [RE setInputString:self.string range:iTM3MakeRange(0, charIndex)];
    NSString * S = nil;
    while (RE.nextMatch) {
        S = [RE substringOfCaptureGroupWithName:iTM2MetaPostREBeginFigNumberGroupName];
    }
    RE.forget;
    if (S.length) {
        [self.window.windowController setCurrentOutputFigure:[NSNumber numberWithUnsignedInteger:S.integerValue]];
        return YES;
    }
//END4iTM3;
    return NO;
}
@end

@interface NSTextStorage(TeX)
- (NSMenu *)MetaPostFigureMenu4iTM3;
@end

@implementation iTM2MetaPostFigureButton
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= awakeFromNib
- (void)awakeFromNib;
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Thu Mar 11 12:36:19 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [super awakeFromNib];
	self.action = @selector(MetaPostFigureButtonAction:);
	[self performSelector:@selector(initMenu) withObject:nil afterDelay:0.01];
	[DNC removeObserver: self
		name: NSPopUpButtonWillPopUpNotification
			object: self];
	[DNC addObserver: self
		selector: @selector(popUpButtonWillPopUpNotified:)
			name: NSPopUpButtonWillPopUpNotification
				object: self];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  popUpButtonWillPopUpNotified:
- (void)popUpButtonWillPopUpNotified:(NSNotification *)notification;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Thu Mar 11 12:38:31 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSMenu * M = self.menu;
	NSInteger insert = [M indexOfItemWithRepresentedObject:@"MetaPost Figure Menu"];
	if(insert != -1)
		[M removeItemAtIndex:insert];
	else {
		insert = [M indexOfItemWithAction4iTM3:@selector(goToMetaPostFigure:)];
		if(insert != -1)
			[M removeItemAtIndex:insert];
		else
			insert = [M numberOfItems];
	}
	NSMenuItem * MI = nil;
	NSUInteger index = 0;
	while (index < M.numberOfItems) {
		MI = [M itemAtIndex:index];
		if ([MI.representedObject isEqual:@"MetaPost Figure Menu"]) {
			[M removeItemAtIndex:index];
		}
		else
			++index;
	}
	NSMenu * figureMenu = [[self.window.windowController textStorage] MetaPostFigureMenu4iTM3];
	NSAssert(figureMenu, @"Missing MetaPost figure menu: inconsistency");
	while (figureMenu.numberOfItems) {
		MI = [figureMenu itemAtIndex:0];
		[figureMenu removeItemAtIndex:0];
		[M insertItem:MI atIndex:insert++];
		MI.representedObject = @"MetaPost Figure Menu";
	}
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= initMenu
- (void)initMenu;
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Thu Mar 11 12:45:38 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSView * owner = [[[NSView alloc] initWithFrame:NSZeroRect] autorelease];
	NSDictionary * context = [NSDictionary dictionaryWithObject:owner forKey:@"NSOwner"];
	Class class = self.class;
    while (YES) {
        NSURL * fileURL = [myBUNDLE URLForResource:@"iTM2MetaPostFigureMenu4iTM3" withExtension:@"nib"];
        if (fileURL.isFileURL) {
            NSString * title = self.title;
            if ([NSBundle loadNibFile:fileURL.path externalNameTable:context withZone:self.zone]) {
                NSMenu * M = owner.menu;
                owner.menu = nil;
                if (M.numberOfItems) {
                    for (NSMenuItem * MI in M.itemArray) {
                        SEL action = MI.action;
                        if(action && [NSStringFromSelector(action) hasPrefix:@"insert"] && !MI.indentationLevel)
                            MI.indentationLevel = 1;
                    }
                    [[M itemAtIndex:0] setTitle:title];
                    self.title = title;// will raise if the menu is void
                    [self setMenu:M];
                } else {
                    LOG4iTM3(@"..........  ERROR: Inconsistent file (Void menu) at %@", fileURL);
                }
            } else {
                LOG4iTM3(@"..........  ERROR: Corrupted file at %@", fileURL);
            }
        } else {
            Class superclass = [class superclass];
            if ((superclass) && (superclass != class)) {
                class = superclass;
                continue;
            }
        }
        break;
    }
//END4iTM3;
    return;
}
@end

@implementation NSTextStorage(MetaPost)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  MetaPostFigureMenu4iTM3
- (NSMenu *)MetaPostFigureMenu4iTM3;
/*"Description forthcoming. No consistency test.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	ICURegEx * RE = [ICURegEx regExForKey:iTM2MetaPostREBeginFigKey inBundle:myBUNDLE error:NULL];
    RE.inputString = self.string;
	NSMutableDictionary * MD = [NSMutableDictionary dictionary];
    NSString * K = nil;
    while (RE.nextMatch) {
        K = [RE substringOfCaptureGroupWithName:iTM2MetaPostREBeginFigNumberGroupName];
        NSMutableArray * MRA = [MD objectForKey:K];
        if (MRA) {
            [MRA addObject:[NSValue valueWithRange:RE.rangeOfMatch]];
        } else {
            [MD setObject:[NSMutableArray arrayWithObject:[NSValue valueWithRange:RE.rangeOfMatch]] forKey:K];
        }
    }
    RE.forget;
    NSMenu * figureMenu = [[[NSMenu alloc] initWithTitle:@""] autorelease];
    [figureMenu setAutoenablesItems:YES];
    NSEnumerator * E = [[MD.allKeys sortedArrayUsingSelector:@selector(compare:)] objectEnumerator];
	NSUInteger index = 0;
	NSUInteger top = 20;
    for (K in E) {
		NSMenu * submenu = [[NSMenu alloc] initWithTitle:@""];
        NSArray * figures = [[MD objectForKey:K] sortedArrayUsingSelector:@selector(compare:)];
        NSValue * figure = nil;
        NSMenu * subsubmenu = nil;
        NSUInteger idx = 0;
        NSMenuItem * MI = nil;
        if (figures.count>1) {
            subsubmenu = [[NSMenu alloc] initWithTitle:@""];
            idx = 0;
            for (figure in figures) {
                MI = [subsubmenu addItemWithTitle:[NSString stringWithFormat:@"(%i)", ++idx] action:@selector(scrollTaggedToVisible:) keyEquivalent:@""];
                MI.tag = figure.rangeValue.location;
                MI.representedObject = @"MetaPost Figure Menu";
            }
            MI = [submenu addItemWithTitle:[NSString stringWithFormat:@"%i", K.integerValue] action:NULL keyEquivalent:@""];
            MI.representedObject = @"MetaPost Figure Menu";
            [submenu setSubmenu:subsubmenu forItem:MI];
        } else {
            MI = [submenu addItemWithTitle:[NSString stringWithFormat:@"%i", K.integerValue] action:@selector(scrollTaggedToVisible:) keyEquivalent:@""];
            MI.tag = [figures.lastObject rangeValue].location;
            MI.representedObject = @"MetaPost Figure Menu";
        }
		if (++index<top) {
            continue;
        }
		MI = [figureMenu addItemWithTitle:[NSString stringWithFormat:@"%@→%@", [[submenu itemAtIndex:0] title], [[submenu itemAtIndex:[submenu numberOfItems] - 1] title]]
			action: NULL keyEquivalent: @""];
		MI.representedObject = @"MetaPost Figure Menu";
		[figureMenu setSubmenu:submenu forItem:MI];
        for (K in E.allObjects) {
            figures = [[MD objectForKey:K] sortedArrayUsingSelector:@selector(compare:)];
            if (figures.count>1) {
                subsubmenu = [[NSMenu alloc] initWithTitle:@""];
                idx = 0;
                for (figure in figures) {
                    MI = [subsubmenu addItemWithTitle:[NSString stringWithFormat:@"(%i)", ++idx] action:@selector(scrollTaggedToVisible:) keyEquivalent:@""];
                    MI.tag = figure.rangeValue.location;
                    MI.representedObject = @"MetaPost Figure Menu";
                }
                MI = [figureMenu addItemWithTitle:[NSString stringWithFormat:@"%i", K.integerValue] action:NULL keyEquivalent:@""];
                MI.representedObject = @"MetaPost Figure Menu";
                [figureMenu setSubmenu:subsubmenu forItem:MI];
            } else {
                MI = [figureMenu addItemWithTitle:[NSString stringWithFormat:@"%i", K.integerValue] action:@selector(scrollTaggedToVisible:) keyEquivalent:@""];
                MI.tag = [figures.lastObject rangeValue].location;
                MI.representedObject = @"MetaPost Figure Menu";
            }
            ++index;
        }
        break;
    }
    return figureMenu;
}
@end

#if 0
@implementation iTM2MainInstaller(MetaPostDocumentKit)
-(void)prepareMetaPostDocumentKitCompletInstallation;
{
	[NSLayoutManager swizzleInstanceMethodSelector4iTM3:@selector(SWZ_iTM2DEBUG_invalidateGlyphsForCharacterRange:changeInLength:actualCharacterRange:) error:NULL];
	[NSLayoutManager swizzleInstanceMethodSelector4iTM3:@selector(SWZ_iTM2DEBUG_invalidateLayoutForCharacterRange:isSoft:actualCharacterRange:) error:NULL];
	[NSLayoutManager swizzleInstanceMethodSelector4iTM3:@selector(SWZ_iTM2DEBUG_invalidateDisplayForGlyphRange:) error:NULL];
	[NSLayoutManager swizzleInstanceMethodSelector4iTM3:@selector(SWZ_iTM2DEBUG_invalidateDisplayForCharacterRange:) error:NULL];
}
@end
@implementation NSLayoutManager(iTM2DEBUG)
- (void)SWZ_iTM2DEBUG_invalidateGlyphsForCharacterRange:(NSRange)charRange changeInLength:(NSInteger)delta actualCharacterRange:(NSRangePointer)actualCharRange;
    // This removes all glyphs for the old character range, adjusts the character indices of all the subsequent glyphs by the change in length, and invalidates the new character range.  If actualCharRange is non-NULL it will be set to the actual range invalidated after any necessary expansion.
{
	[self SWZ_iTM2DEBUG_invalidateGlyphsForCharacterRange:(NSRange)charRange changeInLength:(NSInteger)delta actualCharacterRange:(NSRangePointer)actualCharRange];
}
- (void)SWZ_iTM2DEBUG_invalidateLayoutForCharacterRange:(NSRange)charRange isSoft:(BOOL)flag actualCharacterRange:(NSRangePointer)actualCharRange;
    // This invalidates the layout information (glyph location and rotation) for the given range of characters.  If flag is YES then this range is marked as a hard layout invalidation.  If NO, then the invalidation is soft.  A hard invalid layout range indicates that layout information must be completely recalculated no matter what.  A soft invalid layout range means that there is already old layout info for the range in question, and if the NSLayoutManager is smart enough to figure out how to avoid doing the complete relayout, it may perform any optimization available.  If actualCharRange is non-NULL it will be set to the actual range invalidated after any necessary expansion.
{
	[self SWZ_iTM2DEBUG_invalidateLayoutForCharacterRange:(NSRange)charRange isSoft:(BOOL)flag actualCharacterRange:(NSRangePointer)actualCharRange];
}
- (void)SWZ_iTM2DEBUG_invalidateDisplayForGlyphRange:(NSRange)glyphRange;
{
//LOG4iTM3(@"XXXXX  glyphRange: %@", NSStringFromRange(glyphRange));
	[self SWZ_iTM2DEBUG_invalidateDisplayForGlyphRange:(NSRange)glyphRange];
}
- (void)SWZ_iTM2DEBUG_invalidateDisplayForCharacterRange:(NSRange)charRange;
{
//LOG4iTM3(@"XXXXX  charRange: %@", NSStringFromRange(charRange));
	[self SWZ_iTM2DEBUG_invalidateDisplayForCharacterRange:(NSRange)charRange];
}
@end
#endif

#include "../../build/Milestones/iTM2MetaPostKit.m"
