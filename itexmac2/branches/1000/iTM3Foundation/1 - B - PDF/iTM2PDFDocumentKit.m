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


#import "iTM2ResponderKit.h"
#import "iTM2InstallationKit.h"
#import "iTM2Implementation.h"
#import "iTM2WindowKit.h"
#import "iTM2NotificationKit.h"
#import "iTM2ViewKit.h"
#import "iTM2ButtonKit.h"
#import "iTM2ContextKit.h"
#import "iTM2StringKit.h"
#import "iTM2MacroKit.h"
#import "iTM2KeyBindingsKit.h"
#import "iTM2PDFDocumentKit.h"
#import "iTM2PDFViewKit.h"
#import "iTM2ValidationKit.h"
#import "iTM2PathUtilities.h"
#import "iTM2BundleKit.h"
#import "iTM2FileManagerKit.h"
#import "iTM2Invocation.h"

//#import <unistd.h>
//#import <fcntl.h>

NSString * const iTM2PDFGraphicsInspectorType = @"PDF Graphics";
NSString * const iTM2PDFInspectorMode = @"PDF";
NSString * const iTM2PDFDocumentReadDataRetryIntervalKey = @"iTM2PDFDocumentReadDataRetryInterval";
NSString * const iTM2PDFDocumentReadDataRetryCountKey = @"iTM2PDFDocumentReadDataRetryCount";
NSString * const iTM2PDFNoAutoUpdateKey = @"iTM2PDFNoAutoUpdate";
NSString * const iTM2PDFImageRepresentationDidChangeNotification = @"iTM2PDFRepresentationDidChange";

NSString * const iTM2PDFMagnificationDidChangeNotification = @"iTM2PDFMagnificationDidChange";
NSString * const iTM2PDFLastMagnificationKey = @"iTM2PDFLastMagnification";
NSString * const iTM2PDFFixedMagnificationKey = @"iTM2PDFFixedMagnification";
NSString * const iTM2PDFCurrentMagnificationKey = @"iTM2PDFCurrentMagnification";

NSString * const iTM2PDFAlbumDisplayModeKey = @"iTM2PDFAlbumDisplayMode";
NSString * const iTM2PDFAlbumStickModeKey = @"iTM2PDFAlbumStickMode";
NSString * const iTM2PDFAlbumMarginKey = @"iTM2PDFAlbumMargin";

NSString * const iTM2PDFDisplayModeKey = @"iTM2PDFDisplayMode";
NSString * const iTM2PDFStickModeKey = @"iTM2PDFStickMode";

NSString * const iTM2PDFDisplayNextNextOffsetKey = @"iTM2PDFDisplayNextNextOffset";

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2PDFDocument  =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

@implementation iTM2PDFDocument
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initialize
+ (void)initialize;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 2.0: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
	INIT_POOL4iTM3;
//START4iTM3;
    [super initialize];
    [SUD registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithFloat:2], iTM2PDFDocumentReadDataRetryIntervalKey,
            [NSNumber numberWithInteger:10], iTM2PDFDocumentReadDataRetryCountKey,
            [NSNumber numberWithInteger:5], iTM2PDFDisplayNextNextOffsetKey,
                    nil]];
//END4iTM3;
	RELEASE_POOL4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inspectorType4iTM3
+ (NSString *)inspectorType4iTM3;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return iTM2PDFGraphicsInspectorType;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inspectorMode
+ (NSString *)inspectorMode;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return iTM2PDFInspectorMode;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  init
- (id)init;
/*"Convenience void method to be swizzled. DON'T REMOVE THAT PLEASE!!!
 However, you can expand it according to your needs.
 Version history: jlaurens AT users DOT sourceforge DOT net
 - 2.0: Fri Sep 05 2003
 To Do List:
 "*/
{DIAGNOSTIC4iTM3;
	//START4iTM3;
	return [super init];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initWithContentsOfURL:ofType:error:
- (id)initWithContentsOfURL:(NSURL *)absoluteURL ofType:(NSString *)typeName error:(NSError **)RORef;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if ([typeName isEqual:NSPostScriptPboardType])
	{
		if (absoluteURL.isFileURL)
		{
            NSURL * pdfURL = [[absoluteURL URLByDeletingPathExtension] URLByAppendingPathExtension:@"pdf"];
			if ([DFM fileExistsAtPath:pdfURL.path]) {
				NSDictionary * attributes = [DFM attributesOfItemOrDestinationOfSymbolicLinkAtURL4iTM3:absoluteURL error:NULL];
				NSDate * date = [attributes fileModificationDate];
				attributes = [DFM attributesOfItemOrDestinationOfSymbolicLinkAtURL4iTM3:pdfURL error:NULL];
				NSDate * pdfDate = [attributes fileModificationDate];
				if ([pdfDate compare:date] == NSOrderedDescending) {
					if ((typeName = [SDC typeForContentsOfURL:pdfURL error:RORef])) {
						return [self initWithContentsOfURL:pdfURL ofType:typeName error:RORef];
					} else {
						return nil;
					}					
				}
			}
			// I should recreate a PDF file from scratch
			// do I use epstopdf or the tool inside apple?
			
		}
		[self autorelease];
		return nil;
	}
//END4iTM3;
	return [super initWithContentsOfURL:absoluteURL ofType:typeName error:RORef];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= imageRepresentation
- (id)imageRepresentation;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	id result = metaGETTER;
	if (result)
		return result;
	[self readImageRepresentationFromURL:self.fileURL ofType:[self fileType] error:nil];
    return metaGETTER;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= setImageRepresentation:
- (void)setImageRepresentation:(id)aRepresentation;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (![aRepresentation isEqual:metaGETTER])
    {
        metaSETTER(aRepresentation);
        [INC postNotificationName:iTM2PDFImageRepresentationDidChangeNotification
            object: self
                userInfo: nil];
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  displayName
- (NSString *)displayName;
/*"Erase the cached core file name, root file name and identifier.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSURL * original = [self originalFileURL4iTM3];
    return [original isEqual:self.fileURL]? super.displayName:
        [NSString stringWithFormat:@"%@ (\xE2\x87\xA0 %@)", super.displayName, [[original relativePath] lastPathComponent]];//UTF8 char: '⇠'
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  readFromURL:ofType:error:
- (BOOL)readFromURL:(NSURL *)absoluteURL ofType:(NSString *)typeName error:(NSError **)RORef;
/*"Erase the cached core file name, root file name and identifier.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSTimer * _TIM = [IMPLEMENTATION metaValueForKey:@" _TIM"];
    if (_TIM)
    {
        //START4iTM3;
        [_TIM invalidate];// EXC_BAD_ACCESS? 
        [IMPLEMENTATION takeMetaValue:nil forKey:@" _TIM"];
        NSInteger _FW = [[IMPLEMENTATION metaValueForKey:@" _FW"] integerValue];
        LOG4iTM3(@"Trying to read %@ (%i/10)", absoluteURL, ++_FW);
        [IMPLEMENTATION takeMetaValue:[NSNumber numberWithInteger:_FW] forKey:@" _FW"];
    }

    if (absoluteURL.isFileURL && !absoluteURL.path.length)
        return NO;
    BOOL result = NO;
    NS_DURING
    result = [super readFromURL:absoluteURL ofType:typeName error:RORef];
    NS_HANDLER
    LOG4iTM3(@"*** ERROR in file reading, catched exception %@", [localException reason]);
    result = NO;
    NS_ENDHANDLER
//NSLog(@"%@", [SDC documents]);
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  dataCompleteReadFromURL4iTM3:ofType:error:
- (BOOL)dataCompleteReadFromURL4iTM3:(NSURL *)fileURL ofType:(NSString *)type error:(NSError**)RORef;
/*" Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//LOG4iTM3(@"--------------------------- IT IS EXPECTED SOMETHING ELSE");
	[self setImageRepresentation:nil];
	return YES;
//	return [self readImageRepresentationFromURL:fileURL ofType:type error:RORef];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  newTryToReadImageRepresentationFromURL:ofType:error:
+ (BOOL)newTryToReadImageRepresentationFromURL:(NSURL *)fileURL ofType:(NSString *)type error:(NSError**)RORef;
/*" Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//STOP4iTM3;
    return [[SDC documentForURL:fileURL] readImageRepresentationFromURL:fileURL ofType:type error:RORef]; 
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  readImageRepresentationFromURL:ofType:error:
- (BOOL)readImageRepresentationFromURL:(NSURL *)fileURL ofType:(NSString *)type error:(NSError**)RORef;
/*" Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSData * data = [NSData dataWithContentsOfURL:fileURL options:ZER0 error:RORef];
    [self setDataRepresentation:data];
    Class C = [NSImageRep imageRepClassForData:data];
    if (C)
    {
        const char * s = (const char *)[data bytes];
        NSUInteger length = data.length;
        if (length<8)
            goto bail;
        else if (!strncmp(s, "%PDF-1.", 6))
        {
            if (*(s+7) > 2)
            {
                // %PDF-1.3?
                // s points to the char after the last one
                s+=length;
                hawai:
                if (length>ZER0)
                {
                    --s;
                    if ((*s=='\r') || (*s=='\n'))
                    {
                        --length;
                        goto hawai;
                    }
                    else if ((length<5) || strncmp(s-4, "%%EOF", 5))
                        goto bail;
                }
                else
                    goto bail;
            }
        }
        id newImageRepresentation = [[[C alloc] initWithData:data] autorelease];
        if (newImageRepresentation)
            [self setImageRepresentation:newImageRepresentation];
        else
        {
            LOG4iTM3(@"***  Due to an error, the old image representation is not updated...");
        }
        [IMPLEMENTATION takeMetaValue:[NSNumber numberWithInteger:ZER0] forKey:@" _FW"];//
        return [self imageRepresentation] != nil;
    }
    else
    {
        LOG4iTM3(@"NO CLASS for data");
        return NO;
    }
    bail:
    {
        LOG4iTM3(@"Problem with PDF file format...");
        NSInteger _FW = MAX(ZER0, [[IMPLEMENTATION metaValueForKey:@" _FW"] integerValue]);
        NSInteger retryCount = MAX([SUD integerForKey:iTM2PDFDocumentReadDataRetryCountKey], ZER0);
        CGFloat retryInterval = [SUD floatForKey:iTM2PDFDocumentReadDataRetryIntervalKey] > 0?:1;
        if (_FW<retryCount)
        {
            NSTimer * _TIM = [IMPLEMENTATION metaValueForKey:@" _TIM"];
            [_TIM invalidate];
            NSInvocation * I;
            [[NSInvocation getInvocation4iTM3:&I withTarget:self.class]
                newTryToReadImageRepresentationFromURL:fileURL ofType:type error:RORef];
            _TIM = [NSTimer scheduledTimerWithTimeInterval:retryInterval invocation:I repeats:NO];
            [IMPLEMENTATION takeMetaValue:_TIM forKey:@" _TIM"];
            LOG4iTM3(@"Problem in reading the PDF data (try %i), Next try in %f seconds", _FW, retryCount, retryInterval);
        }
        else if (_FW == retryCount)
        {
            LOG4iTM3(@"Problem in reading the PDF data, no more try");
            ++_FW;
            [IMPLEMENTATION takeMetaValue:[NSNumber numberWithInteger:_FW] forKey:@" _FW"];//
        }
        return YES;
    }
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  originalFileURL4iTM3
- (NSURL *)originalFileURL4iTM3;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return metaGETTER?: [super originalFileURL4iTM3];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setOriginalFileName:
- (void)setOriginalFileName:(NSString *)argument;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    metaSETTER(argument);
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  autosavingFileType
- (NSString *)autosavingFileType;
/*"Autosave is disabled for these documents.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return nil;
}
@end

#import "iTM2BundleKit.h"

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2PDFWindow
/*"Description forthcoming."*/
@implementation iTM2PDFWindow
@end

@interface NSDocument(iTM2PDFInspector)
- (NSPDFImageRep *)imageRepresentation;
@end

@interface iTM2PDFInspector(iTM2Private)
- (Class)_ToolbarDelegateClass;
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2PDFInspector
/*"Description forthcoming."*/
@implementation iTM2PDFInspector
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inspectorType4iTM3
+ (NSString *)inspectorType4iTM3;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return iTM2PDFGraphicsInspectorType;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inspectorMode
+ (NSString *)inspectorMode;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return iTM2DefaultInspectorMode;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= windowFrameIdentifier4iTM3
- (NSString *)windowFrameIdentifier4iTM3;
/*"Related to the observation of the window position, see the NSWindow category Position.
Added by jlaurens AT users DOT sourceforge DOT net (07/12/2001)"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return @"PDF Window";// return a hard string to allow subclassing
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= canAutoUpdate
- (BOOL)canAutoUpdate;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Jan 18 22:21:11 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return ![self context4iTM3BoolForKey:iTM2PDFNoAutoUpdateKey domain:iTM2ContextAllDomainsMask];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= windowPositionShouldBeObserved4iTM3
- (BOOL)windowPositionShouldBeObserved4iTM3;
/*"YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= firstPhysicalPage
- (NSInteger)firstPhysicalPage;
/*"Description forthcoming."*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return ZER0;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= lastPhysicalPage
- (NSInteger)lastPhysicalPage;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [[self.document imageRepresentation] pageCount]-1;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= currentPhysicalPage
- (NSInteger)currentPhysicalPage;
/*"The album is the chief.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [self.album currentPhysicalPage];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= setCurrentPhysicalPage:
- (void)setCurrentPhysicalPage:(NSInteger)aCurrentPhysicalPage;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self.album setCurrentPhysicalPage:aCurrentPhysicalPage];
    [self takeContext4iTM3Integer:[self currentPhysicalPage] forKey:@"iTM2PDFCurrentPhysicalPage" domain:iTM2ContextAllDomainsMask];
    [self.window flushKeyStrokeEvents4iTM3:self];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setAlbum:
- (void)setAlbum:(iTM2PDFAlbumView *)aView;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon Jan 10 21:45:41 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (![aView isEqual:_Album4iTM3]) {
        if (_Album4iTM3) {
            [INC removeObserver:self
                    name: iTM2PDFMagnificationDidChangeNotification
                            object: _Album4iTM3];
        }
    	if ((_Album4iTM3 = [aView retain]))
            [INC addObserver:self
                    selector: @selector(magnificationDidChangeNotified:)
                        name: iTM2PDFMagnificationDidChangeNotification
                            object: _Album4iTM3];
    }
    return;
}
@synthesize album = _Album4iTM3;
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= magnification
- (CGFloat)magnification;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon Jan 10 21:45:41 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [self.album magnification];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= setMagnification:
- (void)setMagnification:(CGFloat)magnification;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon Jan 10 21:45:41 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (magnification <= ZER0)
		magnification = 1;
    [self.album setMagnification:magnification];
    [self takeContext4iTM3Float:[self.album magnification] forKey:iTM2PDFCurrentMagnificationKey domain:iTM2ContextAllDomainsMask];
    [self takeContext4iTM3Integer:iTM2PDFDisplayModeLast forKey:iTM2PDFDisplayModeKey domain:iTM2ContextAllDomainsMask];
    [self.window flushKeyStrokeEvents4iTM3:self];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  magnificationDidChangeNotified:
- (void)magnificationDidChangeNotified:(NSNotification *)aNotification;
/*"Answer to a Notification post. The userInfo is meant to be a dictionary with the new magnification for key "iTM2Magnification". 
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon Jan 10 21:45:41 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
#warning **** NYI no magnification did change
#if 0
    NSDictionary * D = (NSDictionary *)[aNotification userInfo];
    if ([D isKindOfClass:[NSDictionary class]])
    {
        NSNumber * N = [D objectForKey:@"magnification"];
        [[[self toolbarDelegate] magnificationField] setObjectValue:N];
        return;
    }
    LOG4iTM3(@"WARNING: Missing a  expected dictionary as userInfo or a number for key @\"magnification\"");
#endif
//END4iTM3;/Users/itexmac2/dev/1000/iTM3Foundation/1 - B - PDF/iTM2PDFDocumentKit.m:2181:0 #warning NYI this is needed for live sizing


    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  PDFInspectorCompleteLoadContext4iTM3Error:
- (BOOL)PDFInspectorCompleteLoadContext4iTM3Error:(NSError **)RORef;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Révisé par itexmac2: 2010-11-30 21:53:56 +0100
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [self.album loadContext4iTM3Error:RORef];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  PDFInspectorCompleteSaveContext4iTM3Error:
- (BOOL)PDFInspectorCompleteSaveContext4iTM3Error:(NSError **)RORef;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self takeContext4iTM3Bool:[self.window isKeyWindow] forKey:@"iTM2PDFKeyWindow" domain:iTM2ContextAllDomainsMask];// buggy
	return [self.album saveContext4iTM3Error:RORef];
}
@end

@implementation iTM2PDFInspector(ScrollingAndMoving)
#if 0
- (void)scrollPageDown:(id)sender;
- (void)scrollLineUp:(id)sender;
- (void)scrollLineDown:(id)sender;
- (void)pageDown:(id)sender;
- (void)pageUp:(id)sender;
- (void)moveForward:(id)sender;
- (void)moveRight:(id)sender;
- (void)moveBackward:(id)sender;
- (void)moveLeft:(id)sender;
- (void)moveUp:(id)sender;
- (void)moveDown:(id)sender;
- (void)moveToEndOfDocument:(id)sender;
- (void)moveToBeginningOfDocument:(id)sender;
- (void)centerSelectionInVisibleArea:(id)sender;// only with focus
- (void)moveWordForward:(id)sender;
- (void)moveWordBackward:(id)sender;
- (void)moveToBeginningOfLine:(id)sender;
- (void)moveToEOL:(id)sender;
- (void)moveToBeginningOfParagraph:(id)sender;
- (void)moveToEndOfParagraph:(id)sender;
#endif
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  scrollPageUp:
- (void)scrollPageUp:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Feb  8 12:09:15 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSRect VR = [self.album visibleRect];
	VR.origin.y += 0.66666 * VR.size.height;
	[self.album scrollRectToVisible:VR];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  scrollPageDown:
- (void)scrollPageDown:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Feb  8 12:09:15 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSRect VR = [self.album visibleRect];
	VR.origin.y -= 0.66666 * VR.size.height;
	[self.album scrollRectToVisible:VR];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  scrollLineUp:
- (void)scrollLineUp:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Feb  8 12:09:15 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSRect VR = [self.album visibleRect];
	VR.origin.y -= 0.05 * VR.size.height;
	[self.album scrollRectToVisible:VR];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  scrollLineDown:
- (void)scrollLineDown:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Feb  8 12:09:15 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSRect VR = [self.album visibleRect];
	VR.origin.y += 0.05 * VR.size.height;
	[self.album scrollRectToVisible:VR];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  moveForward:
- (void)moveForward:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Feb  8 12:09:15 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  moveRight:
- (void)moveRight:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Feb  8 12:09:15 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSRect VR = [self.album visibleRect];
	VR.origin.x += 0.05 * VR.size.width;
	[self.album scrollRectToVisible:VR];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  moveBackward:
- (void)moveBackward:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Feb  8 12:09:15 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  moveLeft:
- (void)moveLeft:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Feb  8 12:09:15 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSRect VR = [self.album visibleRect];
	VR.origin.x -= 0.05 * VR.size.width;
	[self.album scrollRectToVisible:VR];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  moveUp:
- (void)moveUp:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Feb  8 12:09:15 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[self scrollLineDown:sender];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  moveDown:
- (void)moveDown:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Feb  8 12:09:15 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[self scrollLineUp:sender];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  moveToTheEnd:
- (void)moveToTheEnd:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Feb  8 12:09:15 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSRect frame = [self.album frame];
	[self.album scrollPoint:NSMakePoint(NSMaxX(frame), NSMinY(frame))];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  moveToTheBeginning:
- (void)moveToTheBeginning:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Feb  8 12:09:15 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSRect frame = [self.album frame];
	[self.album scrollPoint:NSMakePoint(NSMinX(frame), NSMaxY(frame))];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  moveHome:
- (void)moveHome:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Feb  8 12:09:15 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[self moveToTheBeginning:sender];
    return;
}
@end

@implementation iTM2PDFInspector(UINavigation)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= takeMagnificationFromField:
- (IBAction)takeMagnificationFromField:(NSTextField *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Jan 19 23:19:59 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[self setMagnification:sender.floatValue];
	[sender isWindowContentValid4iTM3];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= validateTakeMagnificationFromField:
- (BOOL)validateTakeMagnificationFromField:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Jan 19 23:19:59 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[sender setFloatValue:[self magnification]];
//END4iTM3;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= takeMagnificationFromStepper:
- (IBAction)takeMagnificationFromStepper:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Jan 19 23:19:59 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if ([sender integerValue]<ZER0)
		[self doZoomOut:nil];
	else
		[self doZoomIn:nil];
//NSLog(@"dfp");
    [sender setIntegerValue:ZER0];
	[self isWindowContentValid4iTM3];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= validateTakeMagnificationFromStepper:
- (BOOL)validateTakeMagnificationFromStepper:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Jan 19 23:19:59 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [sender setIntegerValue:ZER0];
//END4iTM3;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= takeLogicalPageFromField:
- (IBAction)takeLogicalPageFromField:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Jan 19 23:19:59 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[self setCurrentPhysicalPage:[sender integerValue] - 1];
	[sender isWindowContentValid4iTM3];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= validateTakeLogicalPageFromField:
- (BOOL)validateTakeLogicalPageFromField:(NSControl *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Jan 19 23:19:59 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSInteger CFP = self.currentPhysicalPage;
    sender.integerValue = CFP + 1;
	[sender.formatter setMaximum:[NSNumber numberWithInteger:self.lastPhysicalPage + 1]];
//END4iTM3;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= doGoToFirstPage:
- (IBAction)doGoToFirstPage:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Jan 19 23:19:59 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//NSLog(@"dfp");
    [self setCurrentPhysicalPage:ZER0];
	[self isWindowContentValid4iTM3];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= validateDoGoToFirstPage:
- (BOOL)validateDoGoToFirstPage:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Jan 19 23:19:59 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	return ([self.album imageRepresentation] != nil) && ([self.album currentPhysicalPage] >[self.album firstPhysicalPage]);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= doGoToLastPage:
- (IBAction)doGoToLastPage:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Jan 19 23:19:59 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self.album setCurrentPhysicalPage:INT_MAX];
	[self isWindowContentValid4iTM3];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= validateDoGoToLastPage:
- (BOOL)validateDoGoToLastPage:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Jan 19 23:19:59 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	return [self.album imageRepresentation]!=nil && [self.album currentPhysicalPage]<[self.album lastPhysicalPage];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= doGoForward:
- (IBAction)doGoForward:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Jan 19 23:19:59 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self.album setCurrentPhysicalPage:[self.album forwardPhysicalPage]];
	[self isWindowContentValid4iTM3];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= validateDoGoForward:
- (BOOL)validateDoGoForward:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Jan 19 23:19:59 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	return [self.album forwardPhysicalPage] != -1;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= doGoBack:
- (IBAction)doGoBack:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Jan 19 23:19:59 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self.album setCurrentPhysicalPage:[self.album backPhysicalPage]];
	[self isWindowContentValid4iTM3];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= validateDoGoBack:
- (BOOL)validateDoGoBack:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Jan 19 23:19:59 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	return [self.album backPhysicalPage] != -1;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  actualSize:
- (IBAction)actualSize:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[self setMagnification:1.0];
	[self isWindowContentValid4iTM3];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateActualSize:
- (BOOL)validateActualSize:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return [self magnification] != 1.0;
}
@end

@interface NSString(iTM2PDFInspector)
- (BOOL)getIntegerTrailer4iTM3:(NSInteger *)intPtr;
@end
@implementation iTM2PDFInspector(iTM2KeyStrokeKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  macroCategory
- (NSString *)macroCategory;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return iTM2PDFKeyBindingsIdentifier;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  keyBindingsManager4iTM3
- (id)keyBindingsManager4iTM3;
/*"The text and pdf objects won't shared the same key bindings manager.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [self.window.firstResponder isKindOfClass:[NSText class]]?
		nil:
		[super keyBindingsManager4iTM3];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  handlesKeyBindings4iTM3
- (BOOL)handlesKeyBindings4iTM3;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= handlesKeyStrokes4iTM3
- (BOOL)handlesKeyStrokes4iTM3;
/*"YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Dec 15 14:34:51 GMT 2004
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
- 2.0: Wed Jan  5 17:41:55 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if ([[self.window keyStrokes4iTM3] length])
		[self.window flushLastKeyStrokeEvent4iTM3:self];
	else
		NSBeep();
//END4iTM3;
    return;
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
    if (result)
        return result;
    if (instruction.length)
    {
//LOG4iTM3(@"instruction is: %@", instruction);
		[self.window pushKeyStroke:[instruction substringWithRange:iTM3MakeRange(ZER0, 1)]];
		return YES;
    }
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= displayZoom:
- (void)displayZoom:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Jan  5 17:41:55 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSInteger n = 100;
    [[self.window keyStrokes4iTM3] getIntegerTrailer4iTM3:&n];
    [self setMagnification:n/100.0];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= displayPage:
- (void)displayPage:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Jan  5 17:41:55 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSInteger n = 1;
    if ([[self.window keyStrokes4iTM3] getIntegerTrailer4iTM3:&n])
        [self setCurrentPhysicalPage:n-1];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= doZoomIn:
- (void)doZoomIn:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Jan  5 17:41:55 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSInteger n = 100 * ([self context4iTM3FloatForKey:@"iTM2ZoomFactor" domain:iTM2ContextAllDomainsMask]>0?:1.259921049895);
    [[self.window keyStrokes4iTM3] getIntegerTrailer4iTM3:&n];
	if (n>ZER0)
		[self setMagnification:n / 100.0 * [self magnification]];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= doZoomOut:
- (void)doZoomOut:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Jan  5 17:41:55 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSInteger n = 100 * ([self context4iTM3FloatForKey:@"iTM2ZoomFactor" domain:iTM2ContextAllDomainsMask]>0?:1.259921049895);
    [[self.window keyStrokes4iTM3] getIntegerTrailer4iTM3:&n];
	if (n>ZER0)
		[self setMagnification:100.0 * [self magnification] / n];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= doGoToPreviousPage:
- (void)doGoToPreviousPage:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Jan  5 17:41:55 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSInteger n = 1;
    [[self.window keyStrokes4iTM3] getIntegerTrailer4iTM3:&n];
    [self setCurrentPhysicalPage:[self currentPhysicalPage] - n];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= validateDoGoToPreviousPage:
- (BOOL)validateDoGoToPreviousPage:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Jan 19 23:19:59 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	return ([self.album imageRepresentation] != nil) && ([self currentPhysicalPage] >[self firstPhysicalPage]);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= doGoToNextPage:
- (void)doGoToNextPage:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Jan  5 17:41:55 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSInteger n = 1;
//LOG4iTM3(@"n=%i", n);
    [[self.window keyStrokes4iTM3] getIntegerTrailer4iTM3:&n];
    self.currentPhysicalPage += n;
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= validateDoGoToNextPage:
- (BOOL)validateDoGoToNextPage:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Jan 19 23:19:59 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	return [self.album imageRepresentation]!=nil && [self currentPhysicalPage]<[self lastPhysicalPage];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= doGoToPreviousPreviousPage:
- (void)doGoToPreviousPreviousPage:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Jan  5 17:41:55 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSInteger n = 5;
    [[self.window keyStrokes4iTM3] getIntegerTrailer4iTM3:&n];
    [self setCurrentPhysicalPage:[self currentPhysicalPage] - n];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= validateDoGoToPreviousPreviousPage:
- (BOOL)validateDoGoToPreviousPreviousPage:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Jan 19 23:19:59 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	return ([self.album imageRepresentation] != nil) && ([self currentPhysicalPage] > [self firstPhysicalPage]);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= doGoToNextNextPage:
- (void)doGoToNextNextPage:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Jan  5 17:41:55 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSInteger n = 5;
//LOG4iTM3(@"n=%i", n);
    [[self.window keyStrokes4iTM3] getIntegerTrailer4iTM3:&n];
    self.currentPhysicalPage += n;
//LOG4iTM3(@"old: %i, new: %i, real new: %i", old, new, [self currentPhysicalPage]);
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= validateDoGoToNextNextPage:
- (BOOL)validateDoGoToNextNextPage:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Jan 19 23:19:59 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	return [self.album imageRepresentation]!=nil && [self currentPhysicalPage]<[self lastPhysicalPage];
}
@end

#import "iTM2ViewKit.h"
#import "iTM2CursorKit.h"
#import "iTM2ButtonKit.h"

@interface iTM2PDFAlbumView(PRIVATE_123)
- (void)zoomInMouseDown:(NSEvent *)theEvent;
- (void)zoomOutMouseDown:(NSEvent *)theEvent;
- (void)_SetMagnification:(CGFloat)newMagnification;
@end

NSString * const iTM2PDFZoomInMagnificationScaleKey = @"iTM2PDFZoomInMagnificationScale";

@implementation iTM2PDFAlbumView
/*"Description forthcoming."*/
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initialize
+ (void)initialize;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon Jan 10 21:45:41 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
	INIT_POOL4iTM3;
//START4iTM3;
	[super initialize];
    [SUD registerDefaults:
        [NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithFloat:4.0], iTM2PDFZoomInMagnificationScaleKey,
            [NSDecimalNumber one], iTM2PDFFixedMagnificationKey,
            [NSDecimalNumber one], iTM2PDFLastMagnificationKey,
            [NSNumber numberWithInteger:iTM2PDFDisplayModeFixed], iTM2PDFDisplayModeKey,
            [NSNumber numberWithInteger:iTM2PDFStickToWidthMode], iTM2PDFStickModeKey,
                nil]];
//END4iTM3;
	RELEASE_POOL4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= currentPhysicalPage
- (id)initWithFrame:(NSRect)frame;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon Jan 10 21:45:41 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if ((self = [super initWithFrame:frame]))
    {
        [self setCenteredSubview:[[[iTM2PDFView alloc] initWithFrame:NSZeroRect] autorelease]];
    }
    return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= initWithCoder
- (id)initWithCoder:(NSCoder *)decoder;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon Jan 10 21:45:41 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if ((self = [super initWithCoder:(NSCoder *) decoder]))
    {
        [self setCenteredSubview:[[[iTM2PDFView alloc] initWithFrame:NSZeroRect] autorelease]];
    }
    return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  awakeFromNib
- (void)awakeFromNib;
/*"Registers for NSViewFrameDidChangeNotification sent by the enclosing scroll view."*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [super awakeFromNib];
    [self setMagnificationWithDisplayMode:[self context4iTM3IntegerForKey:iTM2PDFDisplayModeKey domain:iTM2ContextAllDomainsMask]
            stickMode: [self context4iTM3IntegerForKey:iTM2PDFStickModeKey domain:iTM2ContextAllDomainsMask]];
    [self setNeedsDisplay:YES];
    self->_CanStick = YES;
    [self setParametersHaveChanged:YES];
    [self setPDFOrientation:0];
    [self.enclosingScrollView.contentView setPostsFrameChangedNotifications:YES];
    [DNC removeObserver:self name:NSViewFrameDidChangeNotification object:nil];
    [DNC addObserver:self
		selector: @selector(enclosingScrollViewContentFrameDidChangeNotified:)
			name: NSViewFrameDidChangeNotification
				object: self.enclosingScrollView.contentView];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  imageRepresentation
- (id)imageRepresentation;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon Jan 10 21:45:41 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [[[self.window windowController] document] imageRepresentation];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  togglePDFSlidesLandscapeMode:
- (void)togglePDFSlidesLandscapeMode:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    BOOL old = [self context4iTM3BoolForKey:iTM2PDFSlidesLandscapeModeKey domain:iTM2ContextAllDomainsMask];
    [self takeContext4iTM3Value:[NSNumber numberWithBool:!old] forKey:iTM2PDFSlidesLandscapeModeKey domain:iTM2ContextAllDomainsMask ROR4iTM3];
    [self setParametersHaveChanged:YES];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateMenuItem:
- (BOOL)validateMenuItem:(NSMenuItem *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    SEL action = sender.action;
    if (action == @selector(togglePDFSlidesLandscapeMode:))
    {
        sender.state = ([self context4iTM3BoolForKey:iTM2PDFSlidesLandscapeModeKey domain:iTM2ContextAllDomainsMask]? NSOnState:NSOffState);
        return YES;
    }
    return YES;
}
#pragma mark =-=-=-=-=-  PAGE MANAGEMENT
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= currentPhysicalPage
- (NSInteger)currentPhysicalPage;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon Jan 10 21:45:41 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//    return _CurrentPhysicalPage;
    return [[self centeredSubview] currentPhysicalPage];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= setCurrentPhysicalPage:
- (void)setCurrentPhysicalPage:(NSInteger)aCurrentPhysicalPage;
/*"O based.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon Jan 10 21:45:41 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    aCurrentPhysicalPage = MAX(0, MIN(aCurrentPhysicalPage, [[self imageRepresentation] pageCount] - 1));
    if (aCurrentPhysicalPage != [self currentPhysicalPage])
    {
        [[self centeredSubview] setCurrentPhysicalPage:aCurrentPhysicalPage];
        [self setParametersHaveChanged:YES];
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  logicalToPhysicalPage:
- (NSInteger)logicalToPhysicalPage:(NSInteger)logicalPage;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon Jan 10 21:45:41 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return logicalPage - 1;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  physicalToLogicalPage:
- (NSInteger)physicalToLogicalPage:(NSInteger)physicalPage;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon Jan 10 21:45:41 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return physicalPage + 1;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  firstPhysicalPage
- (NSInteger)firstPhysicalPage;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon Jan 10 21:45:41 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return ZER0;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  lastPhysicalPage
- (NSInteger)lastPhysicalPage;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon Jan 10 21:45:41 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [[self imageRepresentation] pageCount];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  forwardPhysicalPage
- (NSInteger)forwardPhysicalPage;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon Jan 10 21:45:41 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return ZER0;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  backPhysicalPage
- (NSInteger)backPhysicalPage;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon Jan 10 21:45:41 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [[self imageRepresentation] pageCount];
}
#pragma mark =-=-=-=-=-  PAGE LAYOUT MANAGEMENT
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  pageLayout
- (NSUInteger)pageLayout;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon Jan 10 21:45:41 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [self context4iTM3IntegerForKey:@"iTM2PDFLayoutMode" domain:iTM2ContextAllDomainsMask];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  setPageLayout:
- (void)setPageLayout:(NSUInteger)PL;
/*"Initializer. MUST be called at initialization time.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon Jan 10 21:45:41 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if ([self context4iTM3IntegerForKey:@"iTM2PDFLayoutMode" domain:iTM2ContextAllDomainsMask] != PL)
    {
        [self takeContext4iTM3Integer:PL forKey:@"iTM2PDFLayoutMode" domain:iTM2ContextAllDomainsMask];
        [self setParametersHaveChanged:YES];
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= PDFOrientation
- (NSInteger)PDFOrientation;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon Jan 10 21:45:41 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [self context4iTM3IntegerForKey:@"iTM2PDFOrientation" domain:iTM2ContextAllDomainsMask];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setPDFOrientation:
- (void)setPDFOrientation:(NSInteger)argument;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon Jan 10 21:45:41 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    argument %= 3;
    if (argument == 3) argument = -1;
    NSInteger _OrientationMode = [self context4iTM3IntegerForKey:@"iTM2PDFOrientation" domain:iTM2ContextAllDomainsMask];
    if (argument != _OrientationMode)
    {
        [self takeContext4iTM3Integer:argument forKey:@"iTM2PDFOrientation" domain:iTM2ContextAllDomainsMask];
        [self setParametersHaveChanged:YES];
        [[self centeredSubview] setNeedsUpdateGeometry:YES];
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= isSlidesLandscape
- (BOOL)isSlidesLandscape;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon Jan 10 21:45:41 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [self context4iTM3IntegerForKey:@"iTM2PDFOrientation" domain:iTM2ContextAllDomainsMask];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setSlidesLandscape:
- (void)setSlidesLandscape:(BOOL)argument;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon Jan 10 21:45:41 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    argument %= 3;
    if (argument == 3) argument = -1;
    NSInteger _OrientationMode = [self context4iTM3IntegerForKey:@"iTM2PDFOrientation" domain:iTM2ContextAllDomainsMask];
    if (argument != _OrientationMode)
    {
        [self takeContext4iTM3Integer:argument forKey:@"iTM2PDFOrientation" domain:iTM2ContextAllDomainsMask];
        [self setParametersHaveChanged:YES];
        [[self centeredSubview] setNeedsUpdateGeometry:YES];
    }
    return;
}
#pragma mark =-=-=-=-=-  MAGNIFICATION MANAGEMENT
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  magnification
- (CGFloat)magnification;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon Jan 10 21:45:41 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [self context4iTM3FloatForKey:iTM2PDFLastMagnificationKey domain:iTM2ContextAllDomainsMask];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setMagnification:
- (void)setMagnification:(CGFloat)aMagnification;
/*A wrapper of _SetMagnification: _CanStick added.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon Jan 10 21:45:41 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    _CanStick = NO;// critical: before truely setting the magnification
    [self _SetMagnification:aMagnification];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  _SetMagnification:
- (void)_SetMagnification:(CGFloat)newMagnification;
/*"If there is something to set, this will be registered in the user default domain under key iTM2PDFRepCurrentMagnificationKey,
and a iTM2MagnificationDidChangeNotification is posted with the receiver as object and as userInfo the new magnification
under key iTM2MagnificationKey in a dictionary.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon Jan 10 21:45:41 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	// testing the newMagnification consistency
	if (newMagnification<0.01)
		newMagnification = 0.01;
	else if (newMagnification>100)
		newMagnification = 100;
    CGFloat old = [self magnification];
    if (old != newMagnification)
    {
        [self takeContext4iTM3Float:newMagnification forKey:iTM2PDFLastMagnificationKey domain:iTM2ContextAllDomainsMask];
        [INC postNotificationName:iTM2PDFMagnificationDidChangeNotification
                object: self
                    userInfo: [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:newMagnification], iTM2PDFLastMagnificationKey, nil]];
        [self setParametersHaveChanged:YES];
        [self setNeedsDisplay:YES];
    }
	if ([self acceptsFirstResponder])
	{
		[self.window makeFirstResponder:self];// Critical:see the responder added after the contentView (a bit tricky!!!)
	}
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setMagnificationWithDisplayMode:stickMode:
- (void)setMagnificationWithDisplayMode:(NSInteger)displayMode stickMode:(NSInteger)stickMode;
/*"If the display mode is iTM2StickMode, fix the magnification according to the stick mode.
Nothing else.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon Jan 10 21:45:41 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    switch(displayMode)
    {
        case iTM2PDFDisplayModeFixed:
            [self setMagnification:[self context4iTM3FloatForKey:iTM2PDFFixedMagnificationKey domain:iTM2ContextAllDomainsMask]];
            _CanStick = NO;
            break;
        case iTM2PDFDisplayModeLast:
            [self setMagnification:[self context4iTM3FloatForKey:iTM2PDFLastMagnificationKey domain:iTM2ContextAllDomainsMask]];
            _CanStick = NO;
            break;
        case iTM2PDFDisplayModeStick:
        default:
            switch(stickMode)
            {
                case iTM2PDFStickToWidthMode:
                    [self setMagnification:[self ratioContentVersusDocumentWidth]];
                    _CanStick = YES;
                    break;
                case iTM2PDFStickToHeightMode:
                    [self setMagnification:[self ratioContentVersusDocumentHeight]];
                    _CanStick = YES;
                    break;
                case iTM2PDFStickToViewMode:
                default:
                    [self _SetMagnification:
                        MIN([self ratioContentVersusDocumentWidth], [self ratioContentVersusDocumentHeight])];
                    _CanStick = YES;
                    break;
            }
            break;
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  innerMagnification
- (CGFloat)innerMagnification;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon Jan 10 21:45:41 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return MIN([self magnification] * sqrt(2), 6400);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  outerMagnification
- (CGFloat)outerMagnification;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon Jan 10 21:45:41 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return MAX([self magnification]/sqrt(2), 0.1);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=  ratioContentVersusDocumentWidth
- (CGFloat)ratioContentVersusDocumentWidth;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon Jan 10 21:45:41 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    switch([self pageLayout])
    {
        case iTM2PDFSinglePageLayout:
        case iTM2PDFOneColumnLayout:
        {
            NSSize S = [[self imageRepresentation] size];
            BOOL rotated = [self PDFOrientation] != ZER0;
            BOOL slideMode = [self context4iTM3BoolForKey:iTM2PDFSlidesLandscapeModeKey domain:iTM2ContextAllDomainsMask];
            CGFloat width = slideMode? (rotated? S.width: S.height): (rotated? S.height: S.width);
            if (width>0)
            {
                NSView * contentView=self.enclosingScrollView.contentView;
                if (contentView != nil)
                    return (contentView.frame.size.width -2*[self context4iTM3FloatForKey:iTM2PDFAlbumMarginKey domain:iTM2ContextAllDomainsMask])/width;
            }
            return 1;
        }
        break;
        //case iTM2PDFTwoColumnLeftLayout:
        //case iTM2PDFTwoColumnRightLayout:
        default:
        {
            NSSize S = [[self imageRepresentation] size];
            BOOL rotated = [self PDFOrientation] != ZER0;
            BOOL slideMode = [self context4iTM3BoolForKey:iTM2PDFSlidesLandscapeModeKey domain:iTM2ContextAllDomainsMask];
            CGFloat width = slideMode? (rotated? S.width: S.height): (rotated? S.height: S.width);
            if (width>0)
            {
                NSView * contentView=self.enclosingScrollView.contentView;
                if (contentView != nil)
                    return (contentView.frame.size.width
                    -2*[self context4iTM3FloatForKey:iTM2PDFAlbumMarginKey domain:iTM2ContextAllDomainsMask]-2*iTM2PDFAlbumViewMargin)/2/width;
            }
            return 1;
        }
    }
}
//=-=-=-=-=-=-=-=-=-=-=-=  ratioContentVersusDocumentHeight
- (CGFloat)ratioContentVersusDocumentHeight;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon Jan 10 21:45:41 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSSize S = [[self imageRepresentation] size];
    BOOL rotated = [self PDFOrientation] != ZER0;
    BOOL slideMode = [self context4iTM3BoolForKey:iTM2PDFSlidesLandscapeModeKey domain:iTM2ContextAllDomainsMask];
    CGFloat height = slideMode? (rotated? S.height: S.width): (rotated? S.width: S.height);
    if (height>0)
    {
        NSView * contentView = self.enclosingScrollView.contentView;
        if (contentView != nil)
            return (contentView.frame.size.height -2*[self context4iTM3FloatForKey:iTM2PDFAlbumMarginKey domain:iTM2ContextAllDomainsMask])/height;
    }
    return 1;
}
#pragma mark =-=-=-=-=-  MOUSE MANAGEMENT
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  flagsChanged
- (void)flagsChanged:(NSEvent *)theEvent;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon Jan 10 21:45:41 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [super flagsChanged:theEvent];
    [self.window invalidateCursorRectsForView:self];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  mouseDown:
- (void)mouseDown:(NSEvent *)theEvent;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon Jan 10 21:45:41 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSUInteger flags = [theEvent modifierFlags];
    if (flags & [[self class] zoomInKeyMask])
        [self zoomInMouseDown:theEvent];
    else if (flags & [[self class] zoomOutKeyMask])
        [self zoomOutMouseDown:theEvent];
    else if (!(flags & (NSAlphaShiftKeyMask | NSShiftKeyMask | NSControlKeyMask | NSAlternateKeyMask | NSCommandKeyMask | NSNumericPadKeyMask | NSHelpKeyMask | NSFunctionKeyMask)))
    {
		// The selected rect becomes the full one
        NSSize magnification = [self convertSize:NSMakeSize(1, 1) fromView:nil];
        if ([self isFlipped])
            magnification.height *= -1;
        manihi:
        theEvent = [self.window nextEventMatchingMask:NSLeftMouseUpMask|NSLeftMouseDraggedMask];
        switch([theEvent type])
        {
            case NSLeftMouseDragged:
            {
                NSPoint offset;
                offset.x = [theEvent deltaX];
                offset.y = [theEvent deltaY];
                if ((offset.x != 0.0) || (offset.y != 0.0))
                {
                    offset.x*=magnification.width;    
                    offset.y*=magnification.height;
                    [self scrollRectToVisible:NSOffsetRect([self visibleRect], -offset.x, ([self isFlipped]? -offset.y:offset.y))];
                }
            }
            default:
                goto manihi;
            case NSLeftMouseUp:
            break;
        }
    }
    else
        [super mouseDown:theEvent];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  zoomInMouseDown:
- (void)zoomInMouseDown:(NSEvent *)theEvent;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon Jan 10 21:45:41 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//NSLog(@"%f", [self context4iTM3FloatForKey:iTM2PDFMixedButtonDelayKey domain:iTM2ContextAllDomainsMask]);
//    [self tryToPerform:@selector(doZoomIn:) with:self];
//    return;
    if ([NSApp nextEventMatchingMask:NSLeftMouseUpMask
        untilDate: [NSDate dateWithTimeIntervalSinceNow:[self context4iTM3FloatForKey:iTM2UDMixedButtonDelayKey domain:iTM2ContextAllDomainsMask]]
            inMode: NSEventTrackingRunLoopMode dequeue: NO])
    {
        [self tryToPerform:@selector(doZoomIn:) with:self];
        return;
    }

    BOOL noPeriodicEvents = YES;
    BOOL cursorIsVisible = YES;
    
    BOOL postNote = [self postsBoundsChangedNotifications];
    [self setPostsBoundsChangedNotifications:NO];	// block the view from sending notification
    
    NSRect oldBounds = [self bounds];
    NSRect previousRect= NSZeroRect;
    previousRect.origin = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    cursorIsVisible = YES;
    
    NSSize magSize = NSMakeSize(240, 180);
    
    CGFloat zoomFactor = 1.0/([self context4iTM3FloatForKey:iTM2PDFZoomInMagnificationScaleKey domain:iTM2ContextAllDomainsMask]?:1);

    NSPoint locationInWindow, locationInView;
    NSRect nextRect;

    theMarket:

    // get Mouse location and check if it is with the view's rect
    locationInWindow = [self.window mouseLocationOutsideOfEventStream];
    locationInView = [self convertPoint:locationInWindow fromView:nil];
    // check if the mouse is in the rect
    if ([self mouse:locationInView inRect:[self visibleRect]])
    {
        if (cursorIsVisible)
        {
                [NSCursor hide];
                cursorIsVisible = NO;
        }
        
        // define rect for magnification in window coordinate
        NSRect globalRect = NSZeroRect;
        globalRect.origin = locationInWindow;
        globalRect = NSInsetRect(globalRect, -magSize.width, -magSize.height);
        // resize bounds around locationInView
        NSAffineTransform * AT = [NSAffineTransform transform];
        [AT  translateXBy:locationInView.x-oldBounds.origin.x yBy:locationInView.y-oldBounds.origin.y];
        [AT scaleBy:zoomFactor];
        [AT  translateXBy:oldBounds.origin.x-locationInView.x yBy:oldBounds.origin.y-locationInView.y];
        NSRect newBounds = NSZeroRect;
        newBounds.origin = [AT transformPoint:oldBounds.origin];
        newBounds.size = [AT transformSize:oldBounds.size];

        nextRect = [self convertRect:globalRect fromView:nil];
        
        // clean up the trace
        NSRect diffRect = NSZeroRect;
        CGFloat minY, maxY;
        diffRect.origin.x = previousRect.origin.x;
        diffRect.size.width = previousRect.size.width;
        if ((diffRect.size.height = nextRect.origin.y-previousRect.origin.y) > 0)
        {	// erase bottom
                diffRect.origin.y = previousRect.origin.y;
                [self displayRect:NSInsetRect(diffRect, -1, -1)]; //NSIntegralRect()?
                minY = nextRect.origin.y;
        }
        else
                minY = previousRect.origin.y;
        if ((diffRect.size.height = previousRect.origin.y+previousRect.size.height
                                                -nextRect.origin.y-nextRect.size.height) > 0)
        {	// erase top
                diffRect.origin.y = nextRect.origin.y+nextRect.size.height;
                [self displayRect:NSInsetRect(diffRect, -1, -1)]; //NSIntegralRect()?
                maxY = nextRect.origin.y+nextRect.size.height;
        }
        else
                maxY = previousRect.origin.y+previousRect.size.height;
        diffRect.origin.y = minY;
        diffRect.size.height = maxY-minY;
        if ((diffRect.size.width = nextRect.origin.x-previousRect.origin.x) > 0)
        {	// erase left
                diffRect.origin.x = previousRect.origin.x;
                [self displayRect:NSInsetRect(diffRect, -1, -1)]; //NSIntegralRect()?
        }
        if ((diffRect.size.width = previousRect.origin.x+previousRect.size.width
                                                                -nextRect.origin.x-nextRect.size.width) > 0)
        {	// erase right
                diffRect.origin.x = nextRect.origin.x+nextRect.size.width;
                [self displayRect:NSInsetRect(diffRect, -1, -1)]; //NSIntegralRect()?
        }
        // remember the current rect
        [self setBounds:newBounds];
        // draw it in the rect
        NSRect r = [self convertRect:globalRect fromView:nil];
        [self displayRect:r];
        // reset bounds
        [self setBounds:oldBounds];
        previousRect = nextRect;
    }
    else
    {
        // mouse is not in the rect, show cursor and reset old rect
        if (!cursorIsVisible)
        {
                [NSCursor unhide];
                cursorIsVisible = YES;
        }
        
        [self displayRect:previousRect];
        previousRect.size = NSZeroSize;
    }

    theBeach:

//NSLog(@"noPeriodicEvents: %@", (noPeriodicEvents? @"Y": @"N"));
    locationInWindow = [self.window mouseLocationOutsideOfEventStream];
    locationInView = [self convertPoint:locationInWindow fromView:nil];

    if ([self isFlipped])
    {
        if (locationInView.y>=NSMaxY([self visibleRect])-5)
        {
            [self tryToPerform:@selector(scrollLineDown:) with:self];
            if (noPeriodicEvents)
            {
//NSLog(@"starting periodic");
                [NSEvent startPeriodicEventsAfterDelay:0.1 withPeriod:0.1];
                noPeriodicEvents = NO;
            }
        }
        else if (locationInView.y<=NSMinY([self visibleRect])+5)
        {
            [self tryToPerform:@selector(scrollLineUp:) with:self];
            if (noPeriodicEvents)
            {
//NSLog(@"starting periodic");
                [NSEvent startPeriodicEventsAfterDelay:0.1 withPeriod:0.1];
                noPeriodicEvents = NO;
            }
        }
    }
    else
    {
        if (locationInView.y>=NSMaxY([self visibleRect])-5)
        {
//NSLog(@"starting periodic");
            [self tryToPerform:@selector(scrollLineUp:) with:self];
            if (noPeriodicEvents)
            {
                [NSEvent startPeriodicEventsAfterDelay:0.1 withPeriod:0.1];
                noPeriodicEvents = NO;
            }
        }
        else if (locationInView.y<=NSMinY([self visibleRect])+5)
        {
            [self tryToPerform:@selector(scrollLineDown:) with:self];
            if (noPeriodicEvents)
            {
//NSLog(@"starting periodic");
                [NSEvent startPeriodicEventsAfterDelay:0.1 withPeriod:0.1];
                noPeriodicEvents = NO;
            }
        }
    }

//NSLog(@"noPeriodicEvents: %@", (noPeriodicEvents? @"Y": @"N"));

    theEvent = [self.window nextEventMatchingMask:NSPeriodicMask|NSLeftMouseUpMask|NSLeftMouseDraggedMask];
//    theEvent = [NSApp nextEventMatchingMask:NSPeriodicMask|NSLeftMouseUpMask|NSLeftMouseDraggedMask untilDate:[NSDate distantFuture] inMode:NSEventTrackingRunLoopMode dequeue:YES];
//NSLog(@"theEvent: %@", theEvent);
    switch([theEvent type])
    {
        case NSLeftMouseDragged:
            goto theMarket;
        default:
//        case NSPeriodicMask:
            goto theBeach;
        case NSLeftMouseUp:
            break;
    }
    [NSEvent stopPeriodicEvents];// just in case
    [NSCursor unhide];// just in case
    [self setPostsBoundsChangedNotifications:postNote];
    [self setNeedsDisplayInRect:previousRect];
//NSLog(@"I am out");
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  zoomOutMouseDown:
- (void)zoomOutMouseDown:(NSEvent *)theEvent;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon Jan 10 21:45:41 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self tryToPerform:@selector(doZoomOut:) with:self];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  resetCursorRects
- (void)resetCursorRects;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon Jan 10 21:45:41 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSUInteger flags = [[NSApp currentEvent] modifierFlags];
    if (flags & [[self class] zoomInKeyMask])
        [self addCursorRect:[self visibleRect] cursor:[NSCursor zoomInCursor]];
    else if (flags & [[self class] zoomOutKeyMask])
        [self addCursorRect:[self visibleRect] cursor:[NSCursor zoomOutCursor]];
    else
        [self addCursorRect:[self visibleRect] cursor:[NSCursor openHandCursor]];
    return;
}
#pragma mark =-=-=-=-=-  CTHER
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  isFlipped
- (BOOL)isFlipped
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon Jan 10 21:45:41 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setNeedsDisplay:
- (void)setNeedsDisplay:(BOOL)aFlag;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon Jan 10 21:45:41 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (aFlag)
    {
        if (_CanStick)
            [self setMagnificationWithDisplayMode:[self context4iTM3IntegerForKey:iTM2PDFDisplayModeKey domain:iTM2ContextAllDomainsMask]
                stickMode: [self context4iTM3IntegerForKey:iTM2PDFStickModeKey domain:iTM2ContextAllDomainsMask]];
//LOG4iTM3(@"[self magnification] is:%f", [self magnification]);
        if ([self parametersHaveChanged])
        {
            [self setParametersHaveChanged:NO];
            // the center of the visible rect points to some view
            // what is this center?
            if ([self imageRepresentation]!=nil)
            {
                iTM2PDFView * CSV = [self centeredSubview];
//NSLog(@"focus: %@", NSStringFromPoint(focus));
                // essentially updates the geometry of the subview and the receiver
                [CSV setPageLayout:[self pageLayout]];
                [CSV setImageRepresentation:[self imageRepresentation]];// critical, before
                [CSV setMagnification:[self magnification]];// critical, before
                [CSV setBoundsRotation:90 * [self PDFOrientation]];
                [CSV updateGeometry];
                NSRect rect = NSIntegralRect(NSInsetRect(CSV.frame, -iTM2PDFAlbumViewMargin, -iTM2PDFAlbumViewMargin));
                NSRect bounds = NSIntegralRect([self.enclosingScrollView.contentView bounds]);
                        //the contentView is tied to the window
                // NSIntegralRect
                [self setFrame:NSIntegralRect(NSUnionRect(NSOffsetRect(rect, -rect.origin.x, -rect.origin.y),
                            NSOffsetRect(bounds, -bounds.origin.x, -bounds.origin.y)))];
                [self centerSubview];
                [CSV placeFocusPointInVisibleArea];
            }
        }
    }
    [super setNeedsDisplay:aFlag];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  drawRect:
- (void)drawRect:(NSRect)aRect;
/*"Straightforward implementation: a loop on all the subviews, for each one we draw a series of rects
with different gray colors. No alpha implemented. No change in the graphics context.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon Jan 10 21:45:41 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//NSLog(@"%@ %#x(Rep)", NSStringFromClass([self class]), NSStringFromSelector(_cmd), self);
//NSLog(NSStringFromRect(self.frame));
//LOG4iTM3(NSStringFromRect([[self centeredSubview] frame]));
    [[[self centeredSubview] backgroundColor] set];
    [NSBezierPath fillRect:aRect];
    [super drawRect:aRect];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  canStickToWindow
- (BOOL)canStickToWindow;
/*"Yes for the fit to width|height|view modes, no otherwise.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon Jan 10 21:45:41 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return ([self context4iTM3IntegerForKey:iTM2PDFDisplayModeKey domain:iTM2ContextAllDomainsMask] == iTM2PDFDisplayModeStick);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  parametersHaveChanged
- (BOOL)parametersHaveChanged;
/*"Parameters are attributes that may change the aspect of the view: magnification, orientation...
When parameters have changed, the view is inited.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon Jan 10 21:45:41 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return _ParametersHaveChanged;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setParametersHaveChanged:
- (void)setParametersHaveChanged:(BOOL)aFlag;
/*"This message MUST be sent each time a display parameter has changed.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon Jan 10 21:45:41 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (_ParametersHaveChanged != aFlag)
    {
        _ParametersHaveChanged = aFlag;
        if (_ParametersHaveChanged)
        {
//NSLog(NSStringFromSelector(_cmd));
            [self setNeedsDisplay:YES];
        }
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  enclosingScrollViewContentFrameDidChangeNotified:
- (void)enclosingScrollViewContentFrameDidChangeNotified:(NSNotification *)notification;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
#warning NYI this is needed for live sizing
//END4iTM3;
	return;
}
#if 0
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  update
- (void)update;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//NSLog(@"%@ %#x (Rep)", NSStringFromClass([self class]), NSStringFromSelector(_cmd), self);
//NSLog(@"[self parametersHaveChanged]:%@", ([self parametersHaveChanged]? @"Y":@"N"));
    [self prepareToUpdate];
    if ([self parametersHaveChanged])
    {
        NSPoint absoluteFocus = NSZeroPoint;
        [self setParametersHaveChanged:NO];
        if ([self imageRepresentation]!=nil)
        {
            iTM2PDFView * subview = [self subview];
            absoluteFocus = [subview absoluteFocus];// remembers the last focused point before any change
//NSLog(@"absoluteFocus: %@", NSStringFromPoint(absoluteFocus));
            [self updateSubview:subview];
            {
                NSRect rect = NSInsetRect(subview.frame, -10, -10);
                NSRect bounds = [self.enclosingScrollView.contentView bounds];//the contentView is tied to the window
                [self setFrame:NSUnionRect(NSOffsetRect(rect, -rect.origin.x, -rect.origin.y),
                            NSOffsetRect(bounds, -bounds.origin.x, -bounds.origin.y))];
            }
            [subview setFrameCenter:[self boundsCenter]];
            {
                NSSize size = [subview bounds].size;
                NSPoint origin = [subview bounds].origin;
                absoluteFocus.x*=size.width;
                absoluteFocus.y*=size.height;
                absoluteFocus.x+=origin.x;
                absoluteFocus.y+=origin.y;
            }
            {
                NSSize visibleSize = [self visibleRect].size;
                NSPoint visibleFocus = [self convertPoint:absoluteFocus fromView:subview];
//NSLog(@"scrollRectToVisible - 1");
                [self scrollRectToVisible:NSOffsetRect(NSMakeRect(visibleFocus.x, visibleFocus.y,
                        visibleSize.width, visibleSize.height),
                                -visibleSize.width/2, -visibleSize.height/2)];
            }
            if (!self.window || ![subview acceptsFirstResponder] || ![self.window makeFirstResponder:subview])
			{
                NSLog(@"[self.window makeFirstResponder:subview]:Refused");
			}
//            else
//NSLog(@"%@ = %@", self.window.firstResponder, subview);
        }
        else
            while([[self subviews] count]>ZER0)
                [[[self subviews] objectAtIndex:ZER0] removeFromSuperviewWithoutNeedingDisplay];
    }
    return;
}
#endif
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  albumViewCompleteSaveContext4iTM3Error:
- (BOOL)albumViewCompleteSaveContext4iTM3:(NSError **)RORef;
/*"YES."*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	return [[self centeredSubview] saveContext4iTM3Error:RORef];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  albumViewCompleteLoadContext4iTM3Error:
- (BOOL)albumViewCompleteLoadContext4iTM3Error:(NSError **)RORef;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self setMagnificationWithDisplayMode:[self context4iTM3IntegerForKey:iTM2PDFDisplayModeKey domain:iTM2ContextAllDomainsMask]
            stickMode: [self context4iTM3IntegerForKey:iTM2PDFStickModeKey domain:iTM2ContextAllDomainsMask]];
//    self->_CanStick = YES;
    [self setCurrentPhysicalPage:[self context4iTM3IntegerForKey:@"iTM2PDFCurrentPhysicalPage" domain:iTM2ContextAllDomainsMask]];
	BOOL result = [[self centeredSubview] loadContext4iTM3Error:RORef];
    [self setParametersHaveChanged:YES];// of course!!!
	[self setNeedsDisplay:YES];// Bug side effect too.	
//RETURN4iTM3;
    return result;
}
@synthesize _CanStick;
@synthesize _ParametersHaveChanged;
@synthesize _CurrentPhysicalPage;
@end
#if 0
@implementation iTM2PDFDocument(MOO)
- (void)updateChangeCount:(NSDocumentChangeType)change;
{DIAGNOSTIC4iTM3;
	if (change == NSChangeDone)
	{
		LOG4iTM3(@"CHANGING");
	}
	else if (change == NSChangeUndone)
	{
		LOG4iTM3(@"UNCHANGING");
	}
	[super updateChangeCount:(NSDocumentChangeType)change];
}
@end
#endif
NSString * const iTM2PDFSetUpPageWhenBadPaperSizeKey = @"iTM2PDFSetUpPageWhenBadPaperSize";
NSString * const iTM2PDFPreferA4PaperKey = @"iTM2PDFPreferA4Paper";

@implementation iTM2PDFDocument(Print)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  printShowingPrintPanel:
- (void)printShowingPrintPanel:(BOOL)flag;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (flag)
    {
        if ([self context4iTM3BoolForKey:iTM2PDFSetUpPageWhenBadPaperSizeKey domain:iTM2ContextAllDomainsMask])
        {
            BOOL setupPage = NO;
            NSPrintInfo * PI = [self printInfo];
            NSSize paperSize = [PI paperSize];
//LOG4iTM3(@"paperSize: %@", NSStringFromSize(paperSize));
            if ((paperSize.width>0) && (paperSize.height>0))
            {
                NSSize repSize = [[self imageRepresentation] size];
                CGFloat dH = paperSize.height - repSize.height;
                CGFloat dW = paperSize.width - repSize.width;
                CGFloat dWH = dH*dH+dW*dW;
                CGFloat WH = paperSize.height*paperSize.height + paperSize.width*paperSize.width;
                NSLog(@"repSize: %@", NSStringFromSize(repSize));
                if (dWH>0.0001*WH)
                {
                    NSLog(@"bad paper size");
                    setupPage = YES;
                }
            }
            else
                setupPage = YES;
            if (setupPage)
            {
                NSPageLayout * PL = [NSPageLayout pageLayout];
                [PL beginSheetWithPrintInfo:PI modalForWindow:[self frontWindow]
                    delegate: self
                        didEndSelector: @selector(_PageLayoutDidEnd:returnCode:contextInfo:)
                            contextInfo: nil];
                return;
            }
        }
    }
    [self printRepresentationShowingPrintPanel:flag];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  printRepresentationShowingPrintPanel:
- (void)printRepresentationShowingPrintPanel:(BOOL)flag;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSPrintInfo * PI = [self printInfo];
    iTM2PDFPrintView * V = [[[iTM2PDFPrintView alloc] initWithRepresentation:[self imageRepresentation]
        slidesLandscape: [self context4iTM3BoolForKey:iTM2PDFSlidesLandscapeModeKey domain:iTM2ContextAllDomainsMask]
            scale: [[[PI dictionary] objectForKey:NSPrintScalingFactor] floatValue]] autorelease];
    NSPrintOperation * PO = [NSPrintOperation printOperationWithView:V printInfo:PI];
    [PO setShowsPrintPanel:flag];
    [PO setShowsProgressPanel:flag];
    [PO setCanSpawnSeparateThread:YES];
    [PO runOperation];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= pageLayoutDidEnd:returnCode:contextInfo:
- (void)_PageLayoutDidEnd:(NSPageLayout *)pageLayout returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//LOG4iTM3(@"_PageLayoutDidEnd, %u", returnCode);
    if (returnCode == NSOKButton)
        [self printRepresentationShowingPrintPanel:YES];
    return;
}
@end
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2PDFPrintKit  =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

NSString * const iTM2PDFToolbarIdentifier = @"iTM2 PDF Toolbar: Default";
#import "iTM2PDFToolbarDelegate.h"

@implementation iTM2MainInstaller(PDFDocumentKitInspectorToolbar)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  PDFKitInspectorToolbarCompleteInstallation
+ (void)PDFDocumentKitInspectorToolbarCompleteInstallation;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue May  3 16:20:26 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[SUD registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:
		[NSNumber numberWithBool:YES], @"iTM2PDFToolbarAutosavesConfiguration",
		[NSNumber numberWithBool:YES], @"iTM2PDFToolbarShareConfiguration",
			nil]];
//END4iTM3;
	return;
}
@end

@implementation iTM2PDFInspector(Toolbar)
#pragma mark =-=-=-=-=-  TOOLBAR
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setupToolbarWindowDidLoad4iTM3
- (void)setupToolbarWindowDidLoad4iTM3;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue May  3 16:20:26 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSToolbar * toolbar = [[[NSToolbar alloc] initWithIdentifier:iTM2PDFToolbarIdentifier] autorelease];
	NSString * key = [NSString stringWithFormat:@"NSToolbar Configuration %@", [toolbar identifier]];
	if ([self context4iTM3BoolForKey:@"iTM2PDFKitToolbarShareConfiguration" domain:iTM2ContextAllDomainsMask])
	{
		NSDictionary * configDictionary = [SUD dictionaryForKey:key];
		if (configDictionary.count)
		{
			[toolbar setConfigurationFromDictionary:configDictionary];
			if (!toolbar.items.count)
			{
				[SUD removeObjectForKey:key];
				toolbar = [[[NSToolbar alloc] initWithIdentifier:iTM2PDFToolbarIdentifier] autorelease];
			}
		}
	}
	else
	{
		NSDictionary * configDictionary = [SUD dictionaryForKey:key];
//LOG4iTM3(@"configDictionary: %@", configDictionary);
		configDictionary = [self context4iTM3DictionaryForKey:key domain:iTM2ContextAllDomainsMask];
//LOG4iTM3(@"configDictionary: %@", configDictionary);
		if (configDictionary.count)
			[toolbar setConfigurationFromDictionary:configDictionary];
		if (!toolbar.items.count)
		{
			configDictionary = [SUD dictionaryForKey:key];
//LOG4iTM3(@"configDictionary: %@", configDictionary);
			[self takeContext4iTM3Value:nil forKey:key domain:iTM2ContextAllDomainsMask ROR4iTM3];
			if (configDictionary.count)
				[toolbar setConfigurationFromDictionary:configDictionary];
			if (!toolbar.items.count)
			{
				[SUD removeObjectForKey:key];
				toolbar = [[[NSToolbar alloc] initWithIdentifier:iTM2PDFToolbarIdentifier] autorelease];
			}
		}
	}
	[toolbar setAutosavesConfiguration:YES];
    [toolbar setAllowsUserCustomization:YES];
//    [toolbar setSizeMode:NSToolbarSizeModeSmall];
	id toolbarDelegate = [[[iTM2PDFToolbarDelegate alloc] init] autorelease];
	[[self implementation] takeMetaValue:toolbarDelegate forKey:@"_toolbarDelegate"];// retain the object
    toolbar.delegate = toolbarDelegate;
    [self.window setToolbar:toolbar];
//END4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleShareToolbarConfiguration:
- (void)toggleShareToolbarConfiguration:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue May  3 16:20:26 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	BOOL old = [self context4iTM3BoolForKey:@"iTM2PDFToolbarShareConfiguration" domain:iTM2ContextAllDomainsMask];
	[self takeContext4iTM3Bool:!old forKey:@"iTM2PDFToolbarShareConfiguration" domain:iTM2ContextAllDomainsMask];
//END4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleShareToolbarConfiguration:
- (BOOL)validateToggleShareToolbarConfiguration:(NSButton *)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue May  3 16:20:26 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	sender.state = [self context4iTM3BoolForKey:@"iTM2PDFToolbarShareConfiguration" domain:iTM2ContextAllDomainsMask]? NSOnState:NSOffState;
//END4iTM3;
	return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  prepareToolbarConfigurationCompleteSaveContext4iTM3:
- (void)prepareToolbarConfigurationCompleteSaveContext4iTM3:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue May  3 16:20:26 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSToolbar * toolbar = [self.window toolbar];
	NSString * key = [NSString stringWithFormat:@"NSToolbar Configuration %@", [toolbar identifier]];
	[self takeContext4iTM3Value:[toolbar configurationDictionary] forKey:key domain:iTM2ContextAllDomainsMask ROR4iTM3];
//START4iTM3;
	return;
}
#if 0
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toolbar:itemForItemIdentifier:willBeInsertedIntoToolbar:
- (NSToolbarItem *)toolbar:(NSToolbar *)toolbar itemForItemIdentifier:(NSString *)itemIdent willBeInsertedIntoToolbar:(BOOL)willBeInserted;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue May  3 16:20:26 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    // Required delegate method:  Given an item identifier, this method returns an item 
    // The toolbar will use this method to obtain toolbar items that can be displayed in the customization sheet, or in the toolbar itself 
    NSToolbarItem * toolbarItem = nil;
	SEL action = NSSelectorFromString([itemIdent stringByAppendingString:@":"]);
	if (action == @selector(goBackForward:)) {
		if (willBeInserted && [IMPLEMENTATION metaValueForKey:@"toolbar back forward"]) {
			return nil;
        }
		toolbarItem = [[[NSToolbarItem alloc] initWithItemIdentifier:itemIdent] autorelease];
		toolbarItem.label = NSLocalizedStringFromTableInBundle([itemIdent stringByAppendingString:@"Label"], @"Toolbar", myBUNDLE, "")];
		toolbarItem.paletteLabel = NSLocalizedStringFromTableInBundle([itemIdent stringByAppendingString:@"PaletteLabel"], @"Toolbar", myBUNDLE, "")];
		toolbarItem.toolTip = NSLocalizedStringFromTableInBundle([itemIdent stringByAppendingString:@"ToolTip"], @"Toolbar", myBUNDLE, "");
		NSControl * F = [self backForwardControl];
		toolbarItem.view = F;
		toolbarItem.minSize = toolbarItem.maxSize = F.frame.size;
		F.action = action;
		F.target = [self respondsToSelector:action]?self:
            [self.PDFView respondsToSelector:action]?self.PDFView:nil;
        if (willBeInserted) {
			[IMPLEMENTATION takeMetaValue:F forKey:@"toolbar back forward"];
        }
	} else if (action == @selector(takeToolModeFromSegment:)) {
		if (willBeInserted && [IMPLEMENTATION metaValueForKey:@"toolbar select tool mode"]) {
			return nil;
        }
		toolbarItem = [[[NSToolbarItem alloc] initWithItemIdentifier:itemIdent] autorelease];
		toolbarItem.label = NSLocalizedStringFromTableInBundle([itemIdent stringByAppendingString:@"Label"], @"Toolbar", myBUNDLE, "");
		toolbarItem.paletteLabel = NSLocalizedStringFromTableInBundle([itemIdent stringByAppendingString:@"PaletteLabel"], @"Toolbar", myBUNDLE, "");
		toolbarItem.toolTip = NSLocalizedStringFromTableInBundle([itemIdent stringByAppendingString:@"ToolTip"], @"Toolbar", myBUNDLE, "");
		NSControl * F = [self toolModeControl];
		toolbarItem.view = F;
		toolbarItem.minSize = toolbarItem.maxSize = F.frame.size;
		F.action = action;
        F.target = [self respondsToSelector:action]?self:
            ([self.PDFView respondsToSelector:action]?self.PDFView:nil);
		if (willBeInserted) {
			[IMPLEMENTATION takeMetaValue:F forKey:@"toolbar select tool mode"];
        }
	} else if (action == @selector(takeScaleFrom:)) {
		if (willBeInserted && [IMPLEMENTATION metaValueForKey:@"toolbar scale field"]) {
			return nil;
        }
		NSTextField * F = [[[NSTextField alloc] initWithFrame:NSZeroRect] autorelease];
		F.action = action;
		F.target = nil;
		iTM2MagnificationFormatter * NF = [[[iTM2MagnificationFormatter alloc] init] autorelease];
		F.formatter = NF;
		F.delegate = NF;
		[F setFrameOrigin: NSMakePoint(4,6)];
		[F.cell setSendsActionOnEndEditing:NO];
        F.floatValue = willBeInserted? 1: self.PDFView.scaleFactor;
		[F setFrameSize = NSMakeSize([[NF stringForObjectValue:[NSNumber numberWithFloat:F.floatValue]]
						sizeWithAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
								[F.cell font], NSFontAttributeName, nil]].width+8, 22)];
		F.tag = 421;
		toolbarItem = [[[NSToolbarItem alloc] initWithItemIdentifier:itemIdent] autorelease];
		toolbarItem.label = NSLocalizedStringFromTableInBundle([itemIdent stringByAppendingString:@"Label"], @"Toolbar", myBUNDLE, "");
		toolbarItem.paletteLabel = NSLocalizedStringFromTableInBundle([itemIdent stringByAppendingString:@"PaletteLabel"], @"Toolbar", myBUNDLE, "");
		toolbarItem.toolTip = NSLocalizedStringFromTableInBundle([itemIdent stringByAppendingString:@"ToolTip"], @"Toolbar", myBUNDLE, "");
		toolbarItem.view = F;
		toolbarItem.minSize = toolbarItem.maxSize = F.frame.size;
		F.action = action;
		F.target = [self respondsToSelector:action]?self:
            [self.PDFView respondsToSelector:action]? self.PDFView:nil;
		if (willBeInserted) {
			[IMPLEMENTATION takeMetaValue:F forKey:@"toolbar scale field"];
        }
	} else if (action == @selector(takePageFrom:)) {
		if (willBeInserted && [IMPLEMENTATION metaValueForKey:@"toolbar page field"]) {
			return nil;
        }
		NSTextField * F = [[[NSTextField alloc] initWithFrame:NSZeroRect] autorelease];
		F.action = action;
		F.target = nil;
		iTM2NavigationFormatter * NF = [[[iTM2NavigationFormatter alloc] init] autorelease];
		F.formatter = NF;
		F.delegate = NF;
		[F setFrameOrigin: NSMakePoint(4,6)];
		F.cell.sendsActionOnEndEditing = NO;
		NSInteger maximum = 1000;
		[F setFrameSize:NSMakeSize([[NF stringForObjectValue:[NSNumber numberWithInteger:maximum]]
						sizeWithAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
								[F.cell font], NSFontAttributeName, nil]].width+8, 22)];
		if (willBeInserted) {
			PDFPage * page = self.PDFView.currentPage;
			PDFDocument * document = page.document;
			NSUInteger pageCount = [document indexForPage:page];
			[F setIntegerValue:pageCount+1];
			pageCount = [document pageCount];
			[NF setMaximum:[NSNumber numberWithInteger:pageCount]];
		} else {
            F.stringValue = @"421";
        }
		F.tag = 421;
		toolbarItem = [[[NSToolbarItem alloc] initWithItemIdentifier:itemIdent] autorelease];
		toolbarItem.label = NSLocalizedStringFromTableInBundle([itemIdent stringByAppendingString:@"Label"], @"Toolbar", myBUNDLE, "");
		toolbarItem.paletteLabel = NSLocalizedStringFromTableInBundle([itemIdent stringByAppendingString:@"PaletteLabel"], @"Toolbar", myBUNDLE, "");
		toolbarItem.toolTip = NSLocalizedStringFromTableInBundle([itemIdent stringByAppendingString:@"ToolTip"], @"Toolbar", myBUNDLE, "");
		toolbarItem.view = F;
        toolbarItem.minSize = toolbarItem.maxSize = F.frame.size;
		F.action = action;
		F.target = [self respondsToSelector:action]?self:
            [self.PDFView respondsToSelector:action]?self.PDFView:nil;
		if (willBeInserted) {
			[IMPLEMENTATION takeMetaValue:F forKey:@"toolbar page field"];
        }
	} else if (action) {
		toolbarItem = [[[NSToolbarItem alloc] initWithItemIdentifier:itemIdent] autorelease];
#warning ARE OU SURE THAT BUNDLE POINTS TO THE CORRECT LOCATION?
		toolbarItem.label = NSLocalizedStringFromTableInBundle([itemIdent stringByAppendingString:@"Label"], @"Toolbar", myBUNDLE, "");
		toolbarItem.paletteLabel = NSLocalizedStringFromTableInBundle([itemIdent stringByAppendingString:@"PaletteLabel"], @"Toolbar", myBUNDLE, "");
		toolbarItem.toolTip = NSLocalizedStringFromTableInBundle([itemIdent stringByAppendingString:@"ToolTip"], @"Toolbar", myBUNDLE, "");
		NSString * imageName = [itemIdent stringByAppendingString:@"ToolbarImage"];
		NSString * imagePath = [myBUNDLE pathForImageResource:itemIdent];
		NSImage * I = [NSImage cachedImageNamed4iTM3:itemIdent];
		toolbarItem.image = I;
		toolbarItem.action = action;
		toolbarItem.target = [self respondsToSelector:action]?self:
            [self.PDFView respondsToSelector:action]?self.PDFView:nil;
	}
    #if 0
    if ([itemIdent isEqual:SaveDocToolbarItemIdentifier]) {
		toolbarItem = [[[NSToolbarItem alloc] initWithItemIdentifier:itemIdent] autorelease];
		
			// Set the text label to be displayed in the toolbar and customization palette 
		toolbarItem.label = @"Save"];
		toolbarItem.paletteLabel = @"Save"];
		
		// Set up a reasonable tooltip, and image   Note, these aren't localized, but you will likely want to localize many of the item's properties 
		toolbarItem.toolTip = @"Save Your Document";
		toolbarItem.image = [NSImage cachedImageNamed4iTM3:@"SaveDocumentItemImage"];
		
		// Tell the item what message to send when it is clicked 
		toolbarItem.target = self;
		toolbarItem.action = @selector(saveDocument:);
    } else if ([itemIdent isEqual:SearchDocToolbarItemIdentifier]) {
        // NSToolbarItem doens't normally autovalidate items that hold custom views, but we want this guy to be disabled when there is no text to search.
        toolbarItem = [[[ValidatedViewToolbarItem alloc] initWithItemIdentifier:itemIdent] autorelease];

		NSMenu *submenu = nil;
		NSMenuItem *submenuItem = nil, *menuFormRep = nil;
		
		// Set up the standard properties 
		toolbarItem.label = @"Search"];
		toolbarItem.paletteLabel = @"Search"];
		toolbarItem.toolTip = @"Search Your Document";
		
        searchFieldOutlet = [[NSSearchField alloc] initWithFrame:searchFieldOutlet.frame];
		// Use a custom view, a text field, for the search item 
		toolbarItem.view = searchFieldOutlet;
		toolbarItem.minSize = NSMakeSize(30, NSHeight(searchFieldOutlet.frame));
		toolbarItem.maxSize = NSMakeSize(400,NSHeight(searchFieldOutlet.frame));

		// By default, in text only mode, a custom items label will be shown as disabled text, but you can provide a 
		// custom menu of your own by using <item> setMenuFormRepresentation] 
		submenu = [[[NSMenu alloc] init] autorelease];
		submenuItem = [[[NSMenuItem alloc] initWithTitle:@"Search Panel" action:@selector(searchUsingSearchPanel:) keyEquivalent:@""] autorelease];
		menuFormRep = [[[NSMenuItem alloc] init] autorelease];

		[submenu addItem:submenuItem];
		submenuItem.target = self;
		[menuFormRep setSubmenu:submenu];
		menuFormRep.title = toolbarItem.label;

        // Normally, a menuFormRep with a submenu should just act like a pull down.  However, in 10.4 and later, the menuFormRep can have its own target / action.  If it does, on click and hold (or if the user clicks and drags down), the submenu will appear.  However, on just a click, the menuFormRep will fire its own action.
        menuFormRep.target = self;
        menuFormRep.action = @selector(searchMenuFormRepresentationClicked:);

        // Please note, from a user experience perspective, you wouldn't set up your search field and menuFormRep like we do here.  This is simply an example which shows you all of the features you could use.
		[toolbarItem setMenuFormRepresentation:menuFormRep];
    } else {
		// itemIdent refered to a toolbar item that is not provide or supported by us or cocoa 
		// Returning nil will inform the toolbar this kind of item is not supported 
		toolbarItem = nil;
    }
	#endif
//END4iTM3;
    return toolbarItem;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toolbarDefaultItemIdentifiers:
- (NSArray *)toolbarDefaultItemIdentifiers:(NSToolbar *)toolbar;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue May  3 16:20:26 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    // Required delegate method:  Returns the ordered list of items to be shown in the toolbar by default    
    // If during the toolbar's initialization, no overriding values are found in the user defaultsModel, or if the
    // user chooses to revert to the default items this set will be used 
//END4iTM3;
    return [NSArray arrayWithObjects:
				NSToolbarPrintItemIdentifier,
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
    // Required delegate method:  Returns the list of all allowed items by identifier.  By default, the toolbar 
    // does not assume any items are allowed, even the separator.  So, every allowed item must be explicitly listed   
    // The set of allowed items is used to construct the customization palette 
//END4iTM3;
    return [NSArray arrayWithObjects:
					iTM2ToolbarNextPageItemIdentifier,
					iTM2ToolbarPreviousPageItemIdentifier,
					iTM2ToolbarPageItemIdentifier,
					iTM2ToolbarZoomInItemIdentifier,
					iTM2ToolbarZoomOutItemIdentifier,
					iTM2ToolbarScaleItemIdentifier,
					iTM2ToolbarBackForwardItemIdentifier,
					iTM2ToolbarRotateLeftItemIdentifier,
					iTM2ToolbarRotateRightItemIdentifier,
					iTM2ToolbarToolModeItemIdentifier,
					NSToolbarPrintItemIdentifier, 
//					NSToolbarShowColorsItemIdentifier,
//					NSToolbarShowFontsItemIdentifier,
					NSToolbarCustomizeToolbarItemIdentifier,
					NSToolbarFlexibleSpaceItemIdentifier,
					NSToolbarSpaceItemIdentifier,
					NSToolbarSeparatorItemIdentifier,
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
    // Optional delegate method:  Before an new item is added to the toolbar, this notification is posted.
    // This is the best place to notice a new item is going into the toolbar.  For instance, if you need to 
    // cache a reference to the toolbar item or need to set up some initial state, this is the best place 
    // to do it.  The notification object is the toolbar to which the item is being added.  The item being 
    // added is found by referencing the @"item" key in the userInfo 
    NSToolbarItem *addedItem = [[notif userInfo] objectForKey:@"item"];
//END4iTM3;
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
    // Optional delegate method:  Before an new item is added to the toolbar, this notification is posted.
    // This is the best place to notice a new item is going into the toolbar.  For instance, if you need to 
    // cache a reference to the toolbar item or need to set up some initial state, this is the best place 
    // to do it.  The notification object is the toolbar to which the item is being added.  The item being 
    // added is found by referencing the @"item" key in the userInfo 
    NSToolbarItem * removedItem = [[notif userInfo] objectForKey:@"item"];
	if ([[removedItem itemIdentifier] isEqual:iTM2ToolbarPageItemIdentifier])
	{
		[IMPLEMENTATION takeMetaValue:nil forKey:@"toolbar page field"];
	}
//END4iTM3;
    return;
}  
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  rotateLeft:
- (IBAction)rotateLeft:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue May  3 16:20:26 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	self.PDFView.currentPage.rotation -= 90;
	[self.PDFView setNeedsDisplay:YES];
	[self isWindowContentValid4iTM3];
//END4iTM3;
    return;
}  
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  rotateRight:
- (IBAction)rotateRight:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue May  3 16:20:26 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	self.PDFView.currentPage.rotation += 90;
	[self.PDFView setNeedsDisplay:YES];
	[self isWindowContentValid4iTM3];
//END4iTM3;
    return;
}  
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takePageFrom:
- (IBAction)takePageFrom:(NSControl *)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue May  3 16:20:26 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSUInteger n = sender.integerValue;
	if (n<1)
		n = ZER0;
	else
		--n;
	PDFDocument * document = self.PDFView.currentPage.document;
	NSUInteger pageCount = document.pageCount;
	if (n<pageCount)
		[self.PDFView goToPage:[document pageAtIndex:n]];
//END4iTM3;
	[self isWindowContentValid4iTM3];
    return;
}  
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateTakePageFrom:
- (BOOL)validateTakePageFrom:(NSMenuItem *)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue May  3 16:20:26 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if ([sender.currentEditor isEqual:sender.window.firstResponder])
		return YES;
	PDFPage * page = self.PDFView.currentPage;
	PDFDocument * document = page.document;
	NSUInteger pageCount = [document indexForPage:page];
	[sender setIntegerValue:pageCount+1];
	pageCount = [document pageCount];
	NSNumberFormatter * NF = [sender formatter];
	[NF setMaximum:[NSNumber numberWithInteger:pageCount]];
	NSSize oldSize = sender.frame.size;
	CGFloat width = 8 + MAX(
		([[NF stringForObjectValue:[NSNumber numberWithInteger:[sender integerValue]]]
				sizeWithAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
							[self.cell font], NSFontAttributeName, nil]].width),
		([[NF stringForObjectValue:[NSNumber numberWithInteger:99]]
				sizeWithAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
							[self.cell font], NSFontAttributeName, nil]].width));
	[sender setFrameSize: NSMakeSize(width, oldSize.height)];
	while(NSToolbarItem * TBI in sender.window.toolbar.items) {
		if (sender == [TBI view]) {
			TBI.minSize = TBI.maxSize = sender.frame.size;
			break;
		}
	}
//END4iTM3;
    return YES;
}  
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeScaleFrom:
- (IBAction)takeScaleFrom:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue May  3 16:20:26 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	CGFloat newScale = sender.floatValue;
	if (newScale <= 0) {
		newScale = 1;
    }
    [self.PDFView setScaleFactor:newScale];
	[self isWindowContentValid4iTM3];
//END4iTM3;
    return;
}  
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateTakeScaleFrom:
- (BOOL)validateTakeScaleFrom:(NSControl *)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue May  3 16:20:26 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if ([sender.currentEditor isEqual:sender.window.firstResponder])
		return YES;
	[sender setFloatValue:self.PDFView.scaleFactor];
	NSNumberFormatter * NF = [sender formatter];
	NSSize oldSize = sender.frame.size;
	CGFloat width = 8 + MAX(
			([[NF stringForObjectValue:[NSNumber numberWithFloat:sender.floatValue]]
				sizeWithAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
							[sender.cell font], NSFontAttributeName, nil]].width),
			([[NF stringForObjectValue:[NSNumber numberWithFloat:1]]
				sizeWithAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
							[sender.cell font], NSFontAttributeName, nil]].width));
	[sender setFrameSize: NSMakeSize(width, oldSize.height)];
	for (NSToolbarItem * TBI in sender.window.toolbar.items) {
		if (sender == TBI.view) {
			TBI.minSize = TBI.maxSize = sender.frame.size;
			break;
		}
	}
//END4iTM3;
    return YES;
}  
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  goBackForward:
- (IBAction)goBackForward:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue May  3 16:20:26 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if ([sender selectedSegment]) {
		[self.PDFView goForward:sender];
	} else {
		[self.PDFView goBack:sender];
	}
	[self isWindowContentValid4iTM3];
//END4iTM3;
    return;
}  
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateGoBackForward:
- (BOOL)validateGoBackForward:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue May  3 16:20:26 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	BOOL isEnabled = NO;
	if ([self.PDFView canGoBack]) {
		[sender setEnabled:YES forSegment:ZER0];
		isEnabled = YES;
	} else
		[sender setEnabled:NO forSegment:ZER0];
	if ([self.PDFView canGoForward]) {
		[sender setEnabled:YES forSegment:1];
		isEnabled = YES;
	} else
		[sender setEnabled:NO forSegment:1];
//END4iTM3;
    return isEnabled;
}  
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeToolModeFromSegment:
- (IBAction)takeToolModeFromSegment:(NSSegmentedControl *)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[self setToolMode:[sender.cell tagForSegment:sender.selectedSegment]];
	[self isWindowContentValid4iTM3];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateTakeToolModeFromSegment:
- (BOOL)validateTakeToolModeFromSegment:(NSSegmentedControl *)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (![sender selectSegmentWithTag:[self toolMode]]) {
		[self setToolMode:kiTM2ScrollToolMode];
		[sender selectSegmentWithTag:[self toolMode]];
	}
	NSInteger segment = [sender segmentCount];
	while(segment--) {
		[sender setEnabled:([sender.cell tagForSegment:segment] != kiTM2AnnotateToolMode) forSegment:segment];
	}
	[sender setEnabled:YES];
//END4iTM3;
    return YES;
}
#endif
@end

@implementation NSTextView(iTM2PDFDocumentKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= doGoToPreviousPage:
- (void)doGoToPreviousPage:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Jan  5 17:41:55 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[self moveToBeginningOfLine:sender];// this is because the Preview menu already has ‚åò‚Üê shortcut
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= validateDoGoToPreviousPage:
- (BOOL)validateDoGoToPreviousPage:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Jan 19 23:19:59 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= doGoToNextPage:
- (void)doGoToNextPage:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Jan  5 17:41:55 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[self moveToEndOfLine:sender];// this is because the Preview menu already has ‚åò‚Üí shortcut
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= validateDoGoToNextPage:
- (BOOL)validateDoGoToNextPage:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Jan 19 23:19:59 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	return YES;
}
@end

#warning the iTM2RenderCenter is changed too...
#warning missing implementation of the tex project document revertToSaved: and saveDocumentAs:, saveDocumentTo:
#warning the ghost window for the project should not accept 1st responder status...
