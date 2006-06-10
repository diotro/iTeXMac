/*
//  iTM2MetaPostWrapperKit.m
//  iTeXMac2
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

@interface NSString(__MetaPostOutputFileNames)
- (NSComparisonResult) iTM2_compareAs__MetaPostOutputFileNames: (NSString *) fileName;
@end

@interface iTM2MetaPostDocument(PRIVATE)
- (NSArray *) forwardingTargets;
@end

@interface iTM2MetaPostInspector(PRIVATE)
- (void) updateThumbnailTable;
- (NSMutableArray *) PDFThumbnails;
- (void) renderInBackroundThumbnailAtIndex: (unsigned int) index;
- (void) synchronizePDFViewWithDocument;
- (iTM2ToolMode) toolMode;
- (void) setToolMode: (iTM2ToolMode) argument;
- (id) scaleAndPageTarget;
- (void) setScaleAndPageTarget: (id) argument;
@end

@implementation iTM2MetaPostDocument
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inspectorMode
+ (NSString *) inspectorType;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return iTM2MetaPostInspectorType;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  PDFDocuments
- (NSMutableDictionary *) PDFDocuments;
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
		metaSETTER([NSMutableDictionary dictionary]);
		result = metaGETTER;
	}
//iTM2_END;
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  orderedPDFDocumentFileNames
- (NSArray *) orderedPDFDocumentFileNames;
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
		metaSETTER([NSMutableArray array]);
		result = metaGETTER;
	}
//iTM2_END;
    return metaGETTER;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  addPDFDocumentFileName:
- (void) addPDFDocumentFileName: (NSString *) argument;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSParameterAssert(argument);
	NSMutableArray * MRA = (NSMutableArray *)[self orderedPDFDocumentFileNames];
	if(![MRA containsObject: argument])
	{
		[MRA addObject: argument];
		[MRA sortUsingSelector: @selector(iTM2_compareAs__MetaPostOutputFileNames:)];
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  removePDFDocumentFileName:
- (void) removePDFDocumentFileName: (NSString *) argument;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSParameterAssert(argument);
	NSMutableArray * MRA = (NSMutableArray *)[self orderedPDFDocumentFileNames];
	if([MRA containsObject: argument])
	{
		[MRA removeObject: argument];
	}
	if(argument)
		[[self PDFDocuments] removeObjectForKey: argument];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  PDFKitDocumentForFileName:
- (id) PDFKitDocumentForFileName: (NSString *) argument;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	argument = [argument stringByStandardizingPath];
	id result = [[self PDFDocuments] objectForKey: argument];
	if(!result)
	{
		NSString * typeName = [SDC typeFromFileExtension: @"pdf"];
		Class C = [SDC documentClassForType: typeName];
		result = [[[C allocWithZone: [self zone]] initWithContentsOfURL: [NSURL fileURLWithPath: argument] ofType: typeName error: nil] autorelease];
		if(result)
		{
			[[self PDFDocuments] setObject: result forKey: argument];
		}
		result = [[self PDFDocuments] objectForKey: argument];
	}
//iTM2_END;
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  PDFDocumentsCompleteReadFromFile:ofType:
- (BOOL) PDFDocumentsCompleteReadFromFile: (NSString *) fileName ofType: (NSString *) type;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSMutableArray * __OrderedFileNames = [NSMutableArray array];
	NSString * directoryName = [[fileName stringByDeletingPathExtension] stringByAppendingPathExtension: @"pdfd"];
	NSString * baseName = [NSString stringWithFormat: @"%@-", [[directoryName lastPathComponent] stringByDeletingPathExtension]];
	NSEnumerator * E = [[DFM directoryContentsAtPath: directoryName] objectEnumerator];
	NSString * component;
	while(component = [E nextObject])
	{
		NSString * fullPath = nil;
		if([component hasPrefix: baseName]
				&& (fullPath = [directoryName stringByAppendingPathComponent: component],
					[[SDC documentClassForType: [SDC typeFromFileExtension: [fullPath pathExtension]]] isSubclassOfClass: [iTM2PDFDocument class]]))
		{
			[__OrderedFileNames addObject: fullPath];
		}
		else if(fullPath && (iTM2DebugEnabled>999))
		{
			iTM2_LOG(@"Refused file: %@",fullPath);
			break;
		}
	}
	if(![__OrderedFileNames count])
	{
		// this was not a wrapper where all the files were collected
		directoryName = [directoryName stringByDeletingLastPathComponent];
		E = [[DFM directoryContentsAtPath: directoryName] objectEnumerator];
		while(component = [E nextObject])
		{
			NSString * fullPath = nil;
			if([component hasPrefix: baseName]
				&& (fullPath = [directoryName stringByAppendingPathComponent: component],
					[[SDC documentClassForType: [SDC typeFromFileExtension: [fullPath pathExtension]]] isSubclassOfClass: [iTM2PDFDocument class]]))
			{
				[__OrderedFileNames addObject: fullPath];
			}
			else if(fullPath && (iTM2DebugEnabled>999))
			{
				iTM2_LOG(@"Refused file: %@",fullPath);
			}
		}
	}
	// comparison:
	NSMutableArray * alreadyFileNames = [[[self orderedPDFDocumentFileNames] mutableCopy] autorelease];
	[alreadyFileNames removeObjectsInArray: __OrderedFileNames];
	// alreadyFileNames now contains obsolete file names to be removed
	[__OrderedFileNames removeObjectsInArray: [self orderedPDFDocumentFileNames]];
	// alreadyFileNames now contains only the documents to be added file names to be removed
	E = [alreadyFileNames objectEnumerator];
	while(component = [E nextObject])
	{
		[self removePDFDocumentFileName: component];
	}
	E = [__OrderedFileNames objectEnumerator];
	while(component = [E nextObject])
	{
		[self addPDFDocumentFileName: component];
	}
//iTM2_END;
    return YES;
}
#pragma mark =-=-=-=-=-  UPDATING
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= updateIfNeeded
- (void) updateIfNeeded;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Jan 18 22:21:11 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[(NSMutableArray *)[self orderedPDFDocumentFileNames] setArray: [NSArray array]];
	NSDictionary * oldDocuments = [NSDictionary dictionaryWithDictionary: [self PDFDocuments]];
	[[self PDFDocuments] setDictionary: [NSDictionary dictionary]];
	[super updateIfNeeded];
	if([self PDFDocumentsCompleteReadFromFile: [self fileName] ofType: [self fileType]])
	{
		// retrieving the old PDF documents
		NSEnumerator * E = [[self orderedPDFDocumentFileNames] objectEnumerator];
		NSString * fileName;
		NSDocument * document;
		while(fileName = [E nextObject])
			if(document = [oldDocuments objectForKey: fileName])
				[[self PDFDocuments] setObject: document forKey: fileName];
		E = [[self PDFDocuments] objectEnumerator];
		while(document = [E nextObject])
			[document updateIfNeeded];
		[[self windowControllers] makeObjectsPerformSelector: @selector(synchronizePDFViewWithDocument) withObject: nil];
	}
	else
	{
		iTM2_LOG(@"**** Error while reading the pdf's");
	}
//iTM2_END;
    return;
}
#pragma mark =-=-=-=-=-  FORWARDING
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  forwardingTargets
- (NSArray *) forwardingTargets;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id inspector = [[self windowControllers] lastObject];
	unsigned int index = [[inspector outputFigureNumbers] indexOfObject: [inspector currentOutputFigure]];
	NSArray * ODFNs = [self orderedPDFDocumentFileNames];
	if((index>=0) && (index<[ODFNs count]))
	{
		return [NSArray arrayWithObject: [self PDFKitDocumentForFileName: [ODFNs objectAtIndex: index]]];
	}
//iTM2_END;
    return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  forwardInvocation:
- (void) forwardInvocation: (NSInvocation *) anInvocation;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	SEL selector = [anInvocation selector];
	NSEnumerator * E = [[self forwardingTargets] objectEnumerator];
	id target;
	while(target = [E nextObject])
	{
		if([target respondsToSelector: selector])
		{
			[anInvocation invokeWithTarget: target];
			return;
		}
	}
	[super forwardInvocation: anInvocation];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  methodSignatureForSelector:
- (NSMethodSignature *) methodSignatureForSelector: (SEL) aSelector;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id result = [super methodSignatureForSelector: aSelector];
	if(result)
		return result;
	NSEnumerator * E = [[self forwardingTargets] objectEnumerator];
	id target;
	while(target = [E nextObject])
		if(result = [target methodSignatureForSelector: aSelector])
			return result;
//iTM2_END;
    return nil;
}
@end

@interface iTM2PDFKitDocument(MetaPost)
- (NSNumber *) metaPostViewScaleNumber;
- (void) setMetaPostViewScaleNumber: (NSNumber *) factor;
- (NSPoint) metaPostViewFocus;
- (void) setMetaPostViewFocus: (NSPoint) point;
@end

@implementation iTM2PDFKitDocument(MetaPost)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  metaPostViewScaleNumber
- (NSNumber *) metaPostViewScaleNumber;
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setMetaPostViewScaleNumber:
- (void) setMetaPostViewScaleNumber: (NSNumber *) factor;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	metaSETTER(factor);
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  metaPostViewFocus
- (NSPoint) metaPostViewFocus;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return NSMakePoint(0, 0);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setMetaPostViewFocus:
- (void) setMetaPostViewFocus: (NSPoint) point;
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

@implementation NSString(__MetaPostOutputFileNames)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2_compareAs__MetaPostOutputFileNames:
- (NSComparisonResult) iTM2_compareAs__MetaPostOutputFileNames: (NSString *) fileName;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSComparisonResult result = [[self stringByDeletingLastPathComponent] compare: [fileName stringByDeletingLastPathComponent]];
	if(result == NSOrderedSame)
	{
		unsigned int commonPrefixLength = [[self commonPrefixWithString: fileName options: 0] length];
		NSString * left  = [[self substringWithRange: NSMakeRange(commonPrefixLength, [self length] - commonPrefixLength)] stringByDeletingPathExtension];
		NSString * right = [[fileName substringWithRange: NSMakeRange(commonPrefixLength, [fileName length] - commonPrefixLength)] stringByDeletingPathExtension];
		NSRange leftR  = [left  rangeOfCharacterFromSet: [[NSCharacterSet decimalDigitCharacterSet] invertedSet] options: NSBackwardsSearch];
		if(leftR.location  != NSNotFound)
			return [left compare: right];
		NSRange rightR = [right rangeOfCharacterFromSet: [[NSCharacterSet decimalDigitCharacterSet] invertedSet] options: NSBackwardsSearch];
		if(rightR.location != NSNotFound)
			return [left compare: right];
		int leftInteger  = [left  intValue];
		int rightInteger = [right intValue];
		return leftInteger>rightInteger? NSOrderedDescending:
			(leftInteger<rightInteger? NSOrderedAscending: NSOrderedSame);
	}
	return result;
}
@end

#import <objc/objc-class.h>

@implementation iTM2MetaPostInspector
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inspectorMode
+ (NSString *) inspectorType;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return iTM2MetaPostInspectorType;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inspectorMode
+ (NSString *) inspectorMode;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return iTM2DefaultInspectorMode;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  metaPostCompleteWindowDidLoad
- (void) metaPostCompleteWindowDidLoad;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[DNC addObserver: self selector: @selector(PDFViewScaleChangedNotified:) name: PDFViewScaleChangedNotification object: _pdfView];
	[[self PDFThumbnails] setArray: [NSArray array]];
	[self setCurrentOutputFigure: ([self contextValueForKey: @"CurrentOutputFigure"]?: [[[self outputFigureNumbers] objectEnumerator] nextObject])];
	[_thumbnailTable setTarget: self];
	[_thumbnailTable setAction: @selector(thumbnailTableAction:)];
	[_thumbnailTable setDoubleAction: @selector(thumbnailTableDoubleAction:)];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleDrawer:
- (IBAction) toggleDrawer: (id) sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[_drawer toggle: sender];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  outputFigureNumbers
- (NSArray *) outputFigureNumbers;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSMutableArray * result = metaGETTER;
	if(!result)
	{
		metaSETTER([NSMutableArray array]);
		result = metaGETTER;
	}
	if(![result count])
	{
		NSArray * orderedPDFDocumentFileNames = [[self document] orderedPDFDocumentFileNames];
		NSEnumerator * E = [orderedPDFDocumentFileNames objectEnumerator];
		NSString * fileName;
		while(fileName = [E nextObject])
		{
			fileName = [[fileName lastPathComponent] stringByDeletingPathExtension];
			NSRange R = [fileName rangeOfCharacterFromSet: [[NSCharacterSet decimalDigitCharacterSet] invertedSet]
									options: NSBackwardsSearch
										range: NSMakeRange(0, [fileName length])];
			if(R.length)
			{
				R.location = NSMaxRange(R);
				R.length = [fileName length] - R.location;
				[result addObject: [fileName substringWithRange: R]];
			}
		}
		if([orderedPDFDocumentFileNames count] != [result count])
		{
			iTM2_LOG(@"Unexpected situation, things won't work properly... (bad file names)");
		}
	}
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setOutputFigureNumbers:
- (void) setOutputFigureNumbers: (id) argument;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
// binding catcher
//iTM2_END
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  currentOutputFigure
- (id) currentOutputFigure;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return metaGETTER?: [[[self outputFigureNumbers] objectEnumerator] nextObject];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setCurrentOutputFigure:
- (void) setCurrentOutputFigure: (id) argument;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id doc = [self currentPDFKitDocument];
	if([[self currentOutputFigure] isEqual: argument])
	{
		if(doc)
		{
			[_pdfView setDocument: [doc PDFDocument]];
			return;
		}
	}
	[doc setMetaPostViewScaleNumber: [NSNumber numberWithFloat: [_pdfView scaleFactor]]];
	metaSETTER(argument);
	doc = [self currentPDFKitDocument];
	if(!doc)
	{
		argument = [[[self outputFigureNumbers] objectEnumerator] nextObject];
		metaSETTER(argument);
		doc = [self currentPDFKitDocument];
	}
	[self takeContextValue: metaGETTER forKey: @"CurrentOutputFigure"];
	[_pdfView setDocument: [doc PDFDocument]];
	NSNumber * N = [doc metaPostViewScaleNumber];
	if(N)
		[_pdfView setScaleFactor: ([N floatValue]?:1.0)];
	else
		[_pdfView zoomToFit: self];
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  currentPDFKitDocument
- (id) currentPDFKitDocument;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	unsigned int index = [[self outputFigureNumbers] indexOfObject: [self currentOutputFigure]];
	NSArray * ODFNs = [[self document] orderedPDFDocumentFileNames];
	if((index>=0) && (index<[ODFNs count]))
	{
		NSString * fileName = [ODFNs objectAtIndex: index];
		return [[self document] PDFKitDocumentForFileName: fileName];
	}
//iTM2_END;
    return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  logarithmScaleFactor
- (float) logarithmScaleFactor;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return 2*log2f(MAX(0, [_pdfView scaleFactor]));
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setLogarithmScaleFactor:
- (void) setLogarithmScaleFactor: (float) argument;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	float old = [_pdfView scaleFactor];
	float new = powf(2, argument/2);
	if(fabsf(old - new) > 0.001*new)
		[_pdfView setScaleFactor: new];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  PDFViewScaleChangedNotified:
- (void) PDFViewScaleChangedNotified: (NSNotification *) notification;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self setLogarithmScaleFactor: 2*log2f(MAX(0, [[notification object] scaleFactor]))];
	[[[self window] toolbar] validateVisibleItems];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  synchronizeWithDocument [NSLayoutManager
- (void) synchronizeWithDocument;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [super synchronizeWithDocument];
	[self synchronizePDFViewWithDocument];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  synchronizePDFViewWithDocument
- (void) synchronizePDFViewWithDocument;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[(NSMutableArray *)[self outputFigureNumbers] setArray: [NSArray array]];
	[self setOutputFigureNumbers: [self outputFigureNumbers]];
	[[self PDFThumbnails] setArray: [NSArray array]];
	[self updateThumbnailTable];
	[self setCurrentOutputFigure: [self currentOutputFigure]];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  drawerDidOpen:
- (void) drawerDidOpen: (NSNotification *) notification;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self updateThumbnailTable];
//iTM2_END;
    return;
}
#pragma mark =-=-=-=-=-  SPLITVIEW
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  splitView:canCollapseSubview:
- (BOOL) splitView:(NSSplitView *)sender canCollapseSubview:(NSView *)subview
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  splitView:constrainMinCoordinate:ofSubviewAt:
- (float)splitView:(NSSplitView *)sender constrainMinCoordinate:(float)proposedMin ofSubviewAt:(int)offset
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return proposedMin+50;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  splitView:constrainMaxCoordinate:ofSubviewAt:
- (float)splitView:(NSSplitView *)sender constrainMaxCoordinate:(float)proposedMax ofSubviewAt:(int)offset
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return proposedMax-50;
}
#pragma mark =-=-=-=-=-  TABLE VIEW
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  PDFThumbnails
- (NSMutableArray *) PDFThumbnails;
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
		metaSETTER([NSMutableArray arrayWithCapacity: 10]);
		result = metaGETTER;
	}
//iTM2_END;
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  updateThumbnailTable
- (void) updateThumbnailTable;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(![[self PDFThumbnails] count])
	{
		unsigned index = [[self outputFigureNumbers] count];
		while(index--)
			[[self PDFThumbnails] addObject: [NSImage imageGenericImageDocument]];
	}
	[_thumbnailTable reloadData];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  numberOfRowsInTableView:
- (int) numberOfRowsInTableView: (NSTableView *) aTableView
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return [[self PDFThumbnails] count];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  tableView:objectValueForTableColumn:row:
- (id) tableView: (NSTableView *) aTableView objectValueForTableColumn: (NSTableColumn *) theColumn row: (int) rowIndex;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	if ([[theColumn identifier] isEqualToString: @"thumbnail"])
	{
		NSImage * I = [[self PDFThumbnails] objectAtIndex: rowIndex];
		if([I isEqual: [NSImage imageGenericImageDocument]])
		{
			[self renderInBackroundThumbnailAtIndex: rowIndex];
		}
		return I;
	}
	else if ([[theColumn identifier] isEqualToString: @"page"])
	{
		return [[self outputFigureNumbers] objectAtIndex: rowIndex];
	}
	return nil;
}
static NSMutableDictionary * _iTM2MetaPostRenderInBackgroundThumbnails = nil;
static BOOL _iTM2MetaPostThreadedRenderInBackgroundThumbnails = NO;
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  renderInBackroundThumbnailAtIndex:
- (void) renderInBackroundThumbnailAtIndex: (unsigned int) index;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_LOG(@"index is: %u", index);
	if([SUD boolForKey: @"iTM2PDFDontRenderThumbnailsInBackground"])
		return;
	if(!_iTM2MetaPostRenderInBackgroundThumbnails)
	{
		_iTM2MetaPostRenderInBackgroundThumbnails = [[NSMutableDictionary dictionary] retain];
	}
	NSValue * V = [NSValue valueWithPointer: self];
	NSMutableArray * array = [_iTM2MetaPostRenderInBackgroundThumbnails objectForKey: V];
	if(!array)
	{
		[_iTM2MetaPostRenderInBackgroundThumbnails setObject: [NSMutableArray array] forKey: V];
		array = [_iTM2MetaPostRenderInBackgroundThumbnails objectForKey: V];
	}
	id newObject = [NSNumber numberWithUnsignedInt: index];
	[array removeObject: newObject];
	[array addObject: newObject];
	if(_iTM2MetaPostThreadedRenderInBackgroundThumbnails)
		return;
	if([_iTM2MetaPostRenderInBackgroundThumbnails count])
	{
		iTM2_LOG(@"XXXXXX  detachNewThreadSelector");
		_iTM2MetaPostThreadedRenderInBackgroundThumbnails = YES;
		[NSThread detachNewThreadSelector: @selector(detachedRenderThumbnailsInBackground:) toTarget: [self class] withObject: nil];
	}
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  detachedRenderThumbnailsInBackground:
+ (void) detachedRenderThumbnailsInBackground: (id) irrelevant;
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
	NSMutableDictionary * MD = [[_iTM2MetaPostRenderInBackgroundThumbnails mutableCopy] autorelease];
	[L unlock];
	NSEnumerator * E = [MD keyEnumerator];
	NSValue * V;
	while(V = [E nextObject])
	{
		iTM2MetaPostInspector * inspector = [V pointerValue];
		NSEnumerator * e = [[NSApp orderedWindows] objectEnumerator];
		NSWindow * w;
		while(w = [e nextObject])
		{
			if([inspector isEqual: [w windowController]])
			{
				// this is the real inspector
				[L lock];
				id array = [_iTM2MetaPostRenderInBackgroundThumbnails objectForKey: V];
				if([array count])
				{
					[MD setObject: [[array mutableCopy] autorelease] forKey: V];
					[L unlock];
					e = [[MD objectForKey: V] reverseObjectEnumerator];
					NSNumber * N;
					id _thumbnailTable = nil;
					object_getInstanceVariable(inspector, "_thumbnailTable", (void**)&_thumbnailTable);
					// NSSize size = NSMakeSize([_thumbnailTable rowHeight], [_thumbnailTable rowHeight]);
					while(N = [e nextObject])
					{
						unsigned int pageIndex = [N unsignedIntValue];
//iTM2_LOG(@"pageIndex is: %u", pageIndex);
						id document = [inspector document];
						NSArray * RA = [document orderedPDFDocumentFileNames];
						if((pageIndex < [RA count]) && (pageIndex < [[inspector PDFThumbnails] count]))
						{
							[L lock];
							PDFPage * page = [[[document PDFKitDocumentForFileName: [RA objectAtIndex: pageIndex]] PDFDocument] pageAtIndex: 0];
							NSData * D = [[[page dataRepresentation] copy] autorelease];// there was a crash here (bad access)
							[L unlock];
							NSImage * tmpI = [[[NSImage allocWithZone: [w zone]] initWithData: D] autorelease];// tiff?
							[tmpI setScalesWhenResized: YES];
							#if 0
							NSSize S = [tmpI size];
							float w = size.width  / S.width;
							float h = size.height / S.height;
							if(h>w)
							{
								S.width  *= w;
								S.height *= w;
							}
							else
							{
								S.width  *= h;
								S.height *= h;
							}
							[tmpI setSize: S];
							#elif 0
							NSImage * newI = [[[NSImage allocWithZone: [w zone]] initWithSize: size] autorelease];// tiff?
							NSRect fromRect = NSZeroRect;
							fromRect.size = [tmpI size];
							float w = size.width  / fromRect.size.width;
							float h = size.height / fromRect.size.height;
							NSRect rect;
							if(h>w)
							{
								fromRect.size.width  *= w;
								fromRect.size.height *= w;
								rect = fromRect;
								rect.origin.y += (size.height-rect.size.height)/2;
							}
							else
							{
								fromRect.size.width  *= h;
								fromRect.size.height *= h;
								rect = fromRect;
								rect.origin.x += (size.width-rect.size.width)/2;
							}
							[tmpI setSize: fromRect.size];
							[newI lockFocus];
							[tmpI drawInRect: rect fromRect: fromRect operation: NSCompositeCopy fraction: 1.0];
							[newI unlockFocus];
							#endif
							[L lock];
							[[inspector PDFThumbnails] replaceObjectAtIndex: pageIndex withObject: tmpI];
							[L unlock];
							[inspector performSelectorOnMainThread: @selector(updateThumbnailTable) withObject: nil waitUntilDone: NO];
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
	E = [_iTM2MetaPostRenderInBackgroundThumbnails keyEnumerator];
	while(V = [E nextObject])
	{
		NSMutableArray * array = [_iTM2MetaPostRenderInBackgroundThumbnails objectForKey: V];
		[array removeObjectsInArray: [MD objectForKey: V]];
		if(![array count])
		{
			[_iTM2MetaPostRenderInBackgroundThumbnails removeObjectForKey: V];
		}
	}
	[L unlock];
	[L release];
	L = nil;
	if([_iTM2MetaPostRenderInBackgroundThumbnails count])
		goto loop;
	_iTM2MetaPostThreadedRenderInBackgroundThumbnails = NO;
//iTM2_END;
	iTM2_RELEASE_POOL;
	[NSThread exit];
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  tableViewSelectionDidChange:
- (void) tableViewSelectionDidChange: (NSNotification *) notification;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSTableView * TV = (NSTableView *)[notification object];
	if(TV == _thumbnailTable)
    {
		int rowIndex = [TV selectedRow];
		if (rowIndex >= 0)
		{
			[self setCurrentOutputFigure: [[self outputFigureNumbers] objectAtIndex: rowIndex]];
		}
    }
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  thumbnailTableAction:
- (IBAction) thumbnailTableAction: (id) sender;
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  thumbnailTableDoubleAction:
- (IBAction) thumbnailTableDoubleAction: (id) sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(sender == _thumbnailTable)
    {
		int rowIndex = [_thumbnailTable selectedRow];
		if (rowIndex >= 0)
		{
			[[self textView] highlightAndScrollMetaPostFigureToVisible: [[[self outputFigureNumbers] objectAtIndex: rowIndex] intValue]];
		}
    }
//iTM2_END;
	return;
}
#pragma mark =-=-=-=-=-  FORWARDING
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  forwardingTargets
- (NSArray *) forwardingTargets;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id result = metaGETTER;
	if(!result && _pdfView)
	{
		id inspector = [[[iTM2PDFKitInspector allocWithZone: [self zone]] initWithWindow: nil] autorelease];
		metaSETTER([NSMutableArray arrayWithObject: inspector]);
		object_setInstanceVariable(inspector, "_pdfView", _pdfView);
		result = metaGETTER;
	}
//iTM2_END;
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  respondsToSelector:
- (BOOL) respondsToSelector: (SEL) aSelector;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([super respondsToSelector: (SEL) aSelector])
		return YES;
	NSEnumerator * E = [[self forwardingTargets] objectEnumerator];
	id target;
	while(target = [E nextObject])
		if([target respondsToSelector: aSelector])
			return YES;
//iTM2_END;
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  forwardInvocation:
- (void) forwardInvocation: (NSInvocation *) anInvocation;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	SEL selector = [anInvocation selector];
	NSEnumerator * E = [[self forwardingTargets] objectEnumerator];
	id target;
	while(target = [E nextObject])
	{
		if([target respondsToSelector: selector])
		{
			[anInvocation invokeWithTarget: target];
			return;
		}
	}
	[super forwardInvocation: anInvocation];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  methodSignatureForSelector:
- (NSMethodSignature *) methodSignatureForSelector: (SEL) aSelector;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id result = [super methodSignatureForSelector: aSelector];
	if(result)
		return result;
	NSEnumerator * E = [[self forwardingTargets] objectEnumerator];
	id target;
	while(target = [E nextObject])
		if(result = [target methodSignatureForSelector: aSelector])
			return result;
//iTM2_END;
    return nil;
}
@end

@implementation iTM2MetaPostWindow
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  makeFirstResponder:
- (BOOL) makeFirstResponder: (NSResponder *) aResponder;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: Thu Jul 17 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([super makeFirstResponder: aResponder])
	{
		[[self windowController] setScaleAndPageTarget: aResponder];
		return YES;
	}
//iTM2_END;
    return NO;
}
@end

@implementation iTM2MetaPostEditor
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  zoomIn:
- (IBAction) zoomIn: (id) sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: Thu Jul 17 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self doZoomIn: sender];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  zoomOut:
- (IBAction) zoomOut: (id) sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: Thu Jul 17 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self doZoomOut: sender];
//iTM2_END;
    return;
}
@end

@implementation NSTextView(iTM2MetaPostKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  highlightAndScrollMetaPostFigureToVisible:
- (void) highlightAndScrollMetaPostFigureToVisible: (int) figure;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: Thu Jul 17 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * S = [[self textStorage] string];
	NSRange searchRange = NSMakeRange(0, [S length]);
	NSRange foundRange;
nextFigure:
	foundRange = [S rangeOfString: @"beginfig" options: 0L range: searchRange];
	int figureNumber = 0;
	if(foundRange.length)
	{
		iTM2LiteScanner * scan = [iTM2LiteScanner scannerWithString: S];
		[scan setScanLocation: NSMaxRange(foundRange)];
		if([scan scanString: @"(" intoString: nil]
			&& [scan scanInt: &figureNumber]
				&& [scan scanString: @")" intoString: nil]
					&& (figure == figureNumber))
		{
			unsigned start, end;
			[S getLineStart: &start end: &end contentsEnd: nil forRange: foundRange];
			[self highlightAndScrollToVisibleRange: NSMakeRange(start, end - start)];
			return;
		}
		searchRange.location = NSMaxRange(foundRange);
		if(searchRange.location < [S length])
		{
			searchRange.length = [S length] - searchRange.location;
			goto nextFigure;
		}
	}
//iTM2_END;
    return;
}
@end

@implementation iTM2MetaPostPDFView
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  keyBindingsManagerIdentifier
- (NSString *) keyBindingsManagerIdentifier;
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  handlesKeyBindings
- (BOOL) handlesKeyBindings;
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
- (BOOL) tryToExecuteStringInstruction: (NSString *) instruction;
/*"Description forthcoming.
If the event is a 1 char key down, it will ask the current key binding for instruction.
The key and its modifiers are 
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    BOOL result = [super tryToExecuteStringInstruction: instruction];
    if(result)
        return result;
    if([instruction length])
    {
//iTM2_LOG(@"instruction is: %@", instruction);
		[[self window] pushKeyStroke: [instruction substringWithRange: NSMakeRange(0, 1)]];
		return YES;
    }
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= handlesKeyStrokes
- (BOOL) handlesKeyStrokes;
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
- (void) deleteBackward: (id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Jan  5 17:41:55 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([[[self window] keyStrokes] length])
		[[self window] flushLastKeyStrokeEvent: self];
	else
		NSBeep();
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  actualSize:
- (IBAction) actualSize: (id) sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self setScaleFactor: 1.0];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateActualSize:
- (BOOL) validateActualSize: (id) sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return [self scaleFactor] != 1.0;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= doZoomIn:
- (void) doZoomIn: (id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Jan  5 17:41:55 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    int n = 100 * ([self contextFloatForKey: @"iTM2ZoomFactor"]>0?: 1.259921049895);
    [[[self window] keyStrokes] getIntegerTrailer: &n];
	if(n>0)
		[self setScaleFactor: n / 100.0 * [self scaleFactor]];
    [[self window] flushKeyStrokeEvents: self];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= doZoomOut:
- (void) doZoomOut: (id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Jan  5 17:41:55 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    int n = 100 * ([self contextFloatForKey: @"iTM2ZoomFactor"]>0?: 1.259921049895);
    [[[self window] keyStrokes] getIntegerTrailer: &n];
	if(n>0)
		[self setScaleFactor: 100 * [self scaleFactor] / n];
    [[self window] flushKeyStrokeEvents: self];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= doZoomToFit:
- (void) doZoomToFit: (id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Jan  5 17:41:55 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	// get the current page
	[self zoomToFit: sender];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= doZoomToSelection:
- (void) doZoomToSelection: (id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Jan  5 17:41:55 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	#warning NOT YET IMPLEMENTED
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= doGoToPreviousPage:
- (void) doGoToPreviousPage: (id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Jan  5 17:41:55 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	iTM2MetaPostInspector * inspector = [[self window] windowController];
 	if(![[inspector outputFigureNumbers] count])
		return;
   int n = 1;
    [[[self window] keyStrokes] getIntegerTrailer: &n];
	if(!n)
		return;
	int pageIndex = [[inspector outputFigureNumbers] indexOfObject: [inspector currentOutputFigure]];
	if(pageIndex < 1)
		return;
	if(pageIndex > n)
		 pageIndex -= n;
	else
		pageIndex = 0;
	[inspector setCurrentOutputFigure: [[inspector outputFigureNumbers] objectAtIndex: pageIndex]];
    [[self window] flushKeyStrokeEvents: self];
	[self validateWindowContent];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= goToPreviousPage:
- (void) goToPreviousPage: (id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Jan  5 17:41:55 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	iTM2MetaPostInspector * inspector = [[self window] windowController];
 	if(![[inspector outputFigureNumbers] count])
		return;
	int n = 1;
	int pageIndex = [[inspector outputFigureNumbers] indexOfObject: [inspector currentOutputFigure]];
	if(pageIndex < 1)
		return;
	if(pageIndex > n)
		 pageIndex -= n;
	else
		pageIndex = 0;
	[inspector setCurrentOutputFigure: [[inspector outputFigureNumbers] objectAtIndex: pageIndex]];
	[self validateWindowContent];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= doGoToNextPage:
- (void) doGoToNextPage: (id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Jan  5 17:41:55 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	iTM2MetaPostInspector * inspector = [[self window] windowController];
	if(![[inspector outputFigureNumbers] count])
		return;
    int n = 1;
    [[[self window] keyStrokes] getIntegerTrailer: &n];
	if(!n)
		return;
	int pageIndex = [[inspector outputFigureNumbers] indexOfObject: [inspector currentOutputFigure]];
	pageIndex += n;
	[inspector setCurrentOutputFigure: [[inspector outputFigureNumbers] objectAtIndex: MIN(pageIndex, [[inspector outputFigureNumbers] count] - 1)]];
    [[self window] flushKeyStrokeEvents: self];
	[self validateWindowContent];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= goToNextPage:
- (void) goToNextPage: (id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Jan  5 17:41:55 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	iTM2MetaPostInspector * inspector = [[self window] windowController];
	if(![[inspector outputFigureNumbers] count])
		return;
    int n = 1;
	int pageIndex = [[inspector outputFigureNumbers] indexOfObject: [inspector currentOutputFigure]];
	pageIndex += n;
	[inspector setCurrentOutputFigure: [[inspector outputFigureNumbers] objectAtIndex: MIN(pageIndex, [[inspector outputFigureNumbers] count] - 1)]];
	[self validateWindowContent];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= displayZoom:
- (void) displayZoom: (id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Jan  5 17:41:55 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    int n = 100;
    [[[self window] keyStrokes] getIntegerTrailer: &n];
    [self setScaleFactor: n/100.0];
    [[self window] flushKeyStrokeEvents: self];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= displayPage:
- (void) displayPage: (id) sender;
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
		n = 0;
	else
		--n;
	[[[self window] windowController] setCurrentOutputFigure: [NSString stringWithFormat: @"%i", n]];
    [[self window] flushKeyStrokeEvents: self];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  pdfSynchronizeMouseDown:
- (void) pdfSynchronizeMouseDown: (NSEvent *) theEvent;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: Thu Jul 17 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    iTM2MetaPostInspector * inspector = [[self window] windowController];
	NSTextView * TV = [inspector textView];
	[TV highlightAndScrollMetaPostFigureToVisible: [[inspector currentOutputFigure] intValue]];
//iTM2_END;
    return;
}
@end

#define DEFINE_IMAGE(SELECTOR, NAME)\
+ (NSImage *) SELECTOR;\
{\
	static NSImage * I = nil;\
	if(!I)\
	{\
		I = [[NSImage allocWithZone: [self zone]] initWithContentsOfFile:\
            [[iTM2MetaPostEditor classBundle] pathForImageResource: NAME]];\
		[I setName: [NSString stringWithFormat: @"iTM2:%@", NAME]];\
	}\
    return I;\
}

@implementation NSImage(iTM2MetaPost)
DEFINE_IMAGE(imageLarger, @"iTM2Larger");
DEFINE_IMAGE(imageSmaller, @"iTM2Smaller");
@end

#define TABLE @"iTM2MetaPost"
#define BUNDLE [iTM2MetaPostDocument classBundle]

#pragma mark -
#pragma mark =-=-=-=-=-  FIGURES
@implementation iTM2MetaPostEditor(Figures)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertMetaPostFigure:
- (IBAction) insertMetaPostFigure: (id) sender; 
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * macro = NSLocalizedStringWithDefaultValue(NSStringFromSelector(_cmd),
		TABLE, BUNDLE, @"beginFig(__(Number)__)\nendFig;", "Inserting a  macro");
	unsigned start, end, contentsEnd;
	NSRange selectedRange = [self selectedRange];
	[[[self textStorage] string] getLineStart: &start end: &end contentsEnd: &contentsEnd forRange: selectedRange];
	NSString * prefix = @"";
	NSString * suffix = @"";
	if(NSMaxRange(selectedRange)>contentsEnd)
	{
		selectedRange.length += end - NSMaxRange(selectedRange);
		suffix = @"\n";
		if(start<selectedRange.location)
		{
			prefix = @"\n";
		}
		[self setSelectedRange: selectedRange];
	}
	else if(start<selectedRange.location)
	{
		selectedRange.location = start;
		selectedRange.length = 0;
		suffix = @"\n";
		[self setSelectedRange: selectedRange];
	}
	[self insertMacro: [NSString stringWithFormat: @"%@%@%@", prefix, macro, suffix]];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  pdfSynchronizeMouseDown:
- (void) pdfSynchronizeMouseDown: (NSEvent *) anEvent;
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * S = [self string];
	unsigned charIndex = [[self layoutManager] characterIndexForGlyphAtIndex: [[self layoutManager] glyphIndexForPoint:
		[self convertPoint: [anEvent locationInWindow] fromView: nil]
			inTextContainer: [self textContainer]]];
	NSRange searchRange = NSMakeRange(0, charIndex);
	NSRange foundRange = [S rangeOfString: @"beginfig" options: NSBackwardsSearch range: searchRange];
	if(foundRange.location)
	{
		int figureNumber = 0;
		iTM2LiteScanner * scan = [iTM2LiteScanner scannerWithString: S];
		[scan setScanLocation: NSMaxRange(foundRange)];
		if([scan scanString: @"(" intoString: nil]
			&& [scan scanInt: &figureNumber]
				&& [scan scanString: @")" intoString: nil])
		{
			[[[self window] windowController] setCurrentOutputFigure: [NSString stringWithFormat: @"%i", figureNumber]];
			return;
		}
	}
//iTM2_END;
    return;
}
@end

@interface NSTextStorage(TeX)
- (NSMenu *) MetaPostFigureMenu;
@end

@implementation iTM2MetaPostFigureButton
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= awakeFromNib
- (void) awakeFromNib;
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([[self superclass] instancesRespondToSelector: _cmd])
		[super awakeFromNib];
	[self setAction: @selector(MetaPostFigureButtonAction:)];
	[self performSelector: @selector(initMenu) withObject: nil afterDelay: 0.01];
	[DNC removeObserver: self
		name: NSPopUpButtonWillPopUpNotification
			object: self];
	[DNC addObserver: self
		selector: @selector(popUpButtonWillPopUpNotified:)
			name: NSPopUpButtonWillPopUpNotification
				object: self];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  popUpButtonWillPopUpNotified:
- (void) popUpButtonWillPopUpNotified: (NSNotification *) notification;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSMenu * M = [self menu];
	int insert = [M indexOfItemWithRepresentedObject: @"MetaPost Figure Menu"];
	if(insert != -1)
		[M removeItemAtIndex: insert];
	else
	{
		insert = [M indexOfItemWithAction: @selector(goToMetaPostFigure:)];
		if(insert != -1)
			[M removeItemAtIndex: insert];
		else
			insert = [M numberOfItems];
	}
	NSMenuItem * MI;
	unsigned index = 0;
	while(index < [M numberOfItems])
	{
		MI = (NSMenuItem *)[M itemAtIndex: index];
		if([[MI representedObject] isEqual: @"MetaPost Figure Menu"])
		{
			[M removeItemAtIndex: index];
		}
		else
			++index;
	}
	NSMenu * figureMenu = [[[[self window] windowController] textStorage] MetaPostFigureMenu];
	NSAssert(figureMenu, @"Missing MetaPost figure menu: inconsistency");
	while([figureMenu numberOfItems])
	{
		MI = [[[figureMenu itemAtIndex: 0] retain] autorelease];
		[figureMenu removeItemAtIndex: 0];
		[M insertItem: MI atIndex: insert++];
		[MI setRepresentedObject: @"MetaPost Figure Menu"];
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= initMenu
- (void) initMenu;
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSView * owner = [[[NSView allocWithZone: [self zone]] initWithFrame: NSZeroRect] autorelease];
	NSDictionary * context = [NSDictionary dictionaryWithObject: owner forKey: @"NSOwner"];
	NSString * fileName;
	Class class = [self class];
next:
	fileName = [[NSBundle bundleForClass: class] pathForResource: @"iTM2MetaPostFigureMenu" ofType: @"nib"];
	if([fileName length])
	{
		NSString * title = [self title];
		if([NSBundle loadNibFile: fileName externalNameTable: context withZone: [self zone]])
		{
			NSMenu * M = [owner menu];
			[owner setMenu: nil];
			if([M numberOfItems])
			{
				NSMenuItem * MI;
				NSEnumerator * E = [[M itemArray] objectEnumerator];
				while(MI = [E nextObject])
				{
					SEL action = [MI action];
					if(action)
					{
						if([NSStringFromSelector(action) hasPrefix: @"insert"])
						{
							if(![MI indentationLevel])
								[MI setIndentationLevel: 1];
						}
					}
				}
				[[M itemAtIndex: 0] setTitle: title];
				[self setTitle: title];// will raise if the menu is void
				[self setMenu: M];
			}
			else
			{
				iTM2_LOG(@"..........  ERROR: Inconsistent file (Void menu) at %@", fileName);
			}
		}
		else
		{
			iTM2_LOG(@"..........  ERROR: Corrupted file at %@", fileName);
		}
	}
	else
	{
		Class superclass = [class superclass];
		if((superclass) && (superclass != class))
		{
			class = superclass;
			goto next;
		}
	}
//iTM2_END;
    return;
}
@end

@implementation NSTextStorage(MetaPost)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  MetaPostFigureMenu
- (NSMenu *) MetaPostFigureMenu;
/*"Description forthcoming. No consistency test.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSMutableDictionary * MD = [NSMutableDictionary dictionary];
    NSString * S = [self string];
    iTM2LiteScanner * scan = [iTM2LiteScanner scannerWithString: S];
	NSRange searchRange = NSMakeRange(0, [S length]);
	NSRange foundRange;
nextFigure:
	foundRange = [S rangeOfString: @"beginfig" options: 0L range: searchRange];
	int figureNumber = 0;
	if(foundRange.length)
	{
		[scan setScanLocation: NSMaxRange(foundRange)];
		if([scan scanString: @"(" intoString: nil]
			&& [scan scanInt: &figureNumber]
				&& [scan scanString: @")" intoString: nil])
		{
			NSNumber * key = [NSNumber numberWithUnsignedInt: figureNumber];
			NSMutableArray * value = [MD objectForKey: key];
			if(value)
			{
				[value addObject: [NSNumber numberWithUnsignedInt: [scan scanLocation]]];
			}
			else
			{
				[MD setObject: [NSMutableArray arrayWithObject: [NSNumber numberWithUnsignedInt: [scan scanLocation]]] forKey: key];
			}
		}
		searchRange.location = [scan scanLocation];
		if(searchRange.location < [S length])
		{
			searchRange.length = [S length] - searchRange.location;
			goto nextFigure;
		}
	}
    NSMenu * figureMenu = [[[NSMenu allocWithZone: [NSMenu menuZone]] initWithTitle: @""] autorelease];
    [figureMenu setAutoenablesItems: YES];
	NSArray * keys = [[MD allKeys] sortedArrayUsingSelector: @selector(compare:)];
	unsigned index = 0;
	unsigned top = 20;
	id MI;
	while(top <= [keys count])
	{
		NSMenu * submenu = [[[NSMenu allocWithZone: [NSMenu menuZone]] initWithTitle: @""] autorelease];
		do
		{
			NSNumber * key = [keys objectAtIndex: index];
			NSArray * figures = [[MD objectForKey: key] sortedArrayUsingSelector: @selector(compare:)];
			if([figures count]>1)
			{
				NSMenu * subsubmenu = [[[NSMenu allocWithZone: [NSMenu menuZone]] initWithTitle: @""] autorelease];
				NSEnumerator * E = [figures objectEnumerator];
				NSNumber * figure;
				unsigned idx = 0;
				while(figure = [E nextObject])
				{
					MI = [subsubmenu addItemWithTitle: [NSString stringWithFormat: @"(%i)", ++idx] action: @selector(scrollTaggedToVisible:) keyEquivalent: @""];
					[MI setTag: [figure unsignedIntValue]];
					[MI setRepresentedObject: @"MetaPost Figure Menu"];
				}
				MI = [submenu addItemWithTitle: [NSString stringWithFormat: @"%i", [key intValue]] action: NULL keyEquivalent: @""];
				[MI setRepresentedObject: @"MetaPost Figure Menu"];
				[submenu setSubmenu: subsubmenu forItem: MI];
			}
			else
			{
				MI = [submenu addItemWithTitle: [NSString stringWithFormat: @"%i", [key intValue]] action: @selector(scrollTaggedToVisible:) keyEquivalent: @""];
				[MI setTag: [[figures lastObject] unsignedIntValue]];
				[MI setRepresentedObject: @"MetaPost Figure Menu"];
			}
		}
		while(++index<top);
		top += 20;
		MI = [figureMenu addItemWithTitle: [NSString stringWithFormat: @"%@%@%@", [[submenu itemAtIndex: 0] title], [NSString stringWithUTF8String: "→"], [[submenu itemAtIndex: [submenu numberOfItems] - 1] title]]
			action: NULL keyEquivalent: @""];
		[MI setRepresentedObject: @"MetaPost Figure Menu"];
		[figureMenu setSubmenu: submenu forItem: MI];
	}
	while(index < [keys count])
	{
		NSNumber * key = [keys objectAtIndex: index];
		NSArray * figures = [[MD objectForKey: key] sortedArrayUsingSelector: @selector(compare:)];
		if([figures count]>1)
		{
			NSMenu * subsubmenu = [[[NSMenu allocWithZone: [NSMenu menuZone]] initWithTitle: @""] autorelease];
			NSEnumerator * E = [figures objectEnumerator];
			NSNumber * figure;
			unsigned idx = 0;
			while(figure = [E nextObject])
			{
				MI = [subsubmenu addItemWithTitle: [NSString stringWithFormat: @"(%i)", ++idx] action: @selector(scrollTaggedToVisible:) keyEquivalent: @""];
				[MI setTag: [figure unsignedIntValue]];
				[MI setRepresentedObject: @"MetaPost Figure Menu"];
			}
			MI = [figureMenu addItemWithTitle: [NSString stringWithFormat: @"%i", [key intValue]] action: NULL keyEquivalent: @""];
			[MI setRepresentedObject: @"MetaPost Figure Menu"];
			[figureMenu setSubmenu: subsubmenu forItem: MI];
		}
		else
		{
			MI = [figureMenu addItemWithTitle: [NSString stringWithFormat: @"%i", [key intValue]] action: @selector(scrollTaggedToVisible:) keyEquivalent: @""];
			[MI setTag: [[figures lastObject] unsignedIntValue]];
			[MI setRepresentedObject: @"MetaPost Figure Menu"];
		}
		++index;
	}
    return figureMenu;
}
@end

#if 0
@interface NSLayoutManager_DEBUG: NSLayoutManager
@end
@implementation NSLayoutManager_DEBUG
+(void)load;{[self poseAsClass: [NSLayoutManager class]];}
- (void)invalidateGlyphsForCharacterRange:(NSRange)charRange changeInLength:(int)delta actualCharacterRange:(NSRangePointer)actualCharRange;
    // This removes all glyphs for the old character range, adjusts the character indices of all the subsequent glyphs by the change in length, and invalidates the new character range.  If actualCharRange is non-NULL it will be set to the actual range invalidated after any necessary expansion.
{
	[super invalidateGlyphsForCharacterRange:(NSRange)charRange changeInLength:(int)delta actualCharacterRange:(NSRangePointer)actualCharRange];
}
- (void)invalidateLayoutForCharacterRange:(NSRange)charRange isSoft:(BOOL)flag actualCharacterRange:(NSRangePointer)actualCharRange;
    // This invalidates the layout information (glyph location and rotation) for the given range of characters.  If flag is YES then this range is marked as a hard layout invalidation.  If NO, then the invalidation is soft.  A hard invalid layout range indicates that layout information must be completely recalculated no matter what.  A soft invalid layout range means that there is already old layout info for the range in question, and if the NSLayoutManager is smart enough to figure out how to avoid doing the complete relayout, it may perform any optimization available.  If actualCharRange is non-NULL it will be set to the actual range invalidated after any necessary expansion.
{
	[super invalidateLayoutForCharacterRange:(NSRange)charRange isSoft:(BOOL)flag actualCharacterRange:(NSRangePointer)actualCharRange];
}
- (void)invalidateDisplayForGlyphRange:(NSRange)glyphRange;
{
//iTM2_LOG(@"XXXXX  glyphRange: %@", NSStringFromRange(glyphRange));
	[super invalidateDisplayForGlyphRange:(NSRange)glyphRange];
}
- (void)invalidateDisplayForCharacterRange:(NSRange)charRange;
{
//iTM2_LOG(@"XXXXX  charRange: %@", NSStringFromRange(charRange));
	[super invalidateDisplayForCharacterRange:(NSRange)charRange];
}
@end
#endif
