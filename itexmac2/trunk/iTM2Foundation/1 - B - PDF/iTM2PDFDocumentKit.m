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


#import <iTM2Foundation/iTM2ResponderKit.h>
#import <iTM2Foundation/iTM2InstallationKit.h>
#import <iTM2Foundation/iTM2Implementation.h>
#import <iTM2Foundation/iTM2WindowKit.h>
#import <iTM2Foundation/iTM2NotificationKit.h>
#import <iTM2Foundation/iTM2ViewKit.h>
#import <iTM2Foundation/iTM2ButtonKit.h>
#import <iTM2Foundation/iTM2ContextKit.h>
#import <iTM2Foundation/iTM2StringKit.h>
#import <iTM2Foundation/iTM2MacroKit.h>
#import <iTM2Foundation/iTM2KeyBindingsKit.h>
#import <iTM2Foundation/iTM2PDFDocumentKit.h>
#import <iTM2Foundation/iTM2PDFViewKit.h>
#import <iTM2Foundation/iTM2ValidationKit.h>
#import <iTM2Foundation/iTM2PathUtilities.h>
#import <iTM2Foundation/iTM2BundleKit.h>

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
{iTM2_DIAGNOSTIC;
	iTM2_INIT_POOL;
//iTM2_START;
    [super initialize];
    [SUD registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithFloat:2], iTM2PDFDocumentReadDataRetryIntervalKey,
            [NSNumber numberWithInt:10], iTM2PDFDocumentReadDataRetryCountKey,
            [NSNumber numberWithInt:5], iTM2PDFDisplayNextNextOffsetKey,
                    nil]];
//iTM2_END;
	iTM2_RELEASE_POOL;
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  init
- (id)init;
/*"Convenience void method to be swizzled. DON'T REMOVE THAT PLEASE!!!
However, you can expand it according to your needs.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	return [super init];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  dealloc
- (void)dealloc;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [INC removeObserver:self];
    [super dealloc];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initWithContentsOfURL:ofType:error:
- (id)initWithContentsOfURL:(NSURL *)absoluteURL ofType:(NSString *)typeName error:(NSError **)outErrorPtr;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([typeName isEqual:NSPostScriptPboardType])
	{
		if([absoluteURL isFileURL])
		{
			NSString * path = [absoluteURL path];
			NSString * pdfPath = [path stringByDeletingPathExtension];
			pdfPath = [pdfPath stringByAppendingPathExtension:@"pdf"];
			NSAssert(![pdfPath pathIsEqual:path],@"Bad type name for a postscript file.");
#warning REVISITED?
			if([DFM fileExistsAtPath:pdfPath])
			{
				NSDictionary * attributes = [DFM fileAttributesAtPath:path traverseLink:YES];
				NSDate * date = [attributes fileModificationDate];
				attributes = [DFM fileAttributesAtPath:pdfPath traverseLink:YES];
				NSDate * pdfDate = [attributes fileModificationDate];
				if([pdfDate compare:date] == NSOrderedDescending)
				{
					absoluteURL = [NSURL fileURLWithPath:pdfPath];
					if(typeName = [SDC typeForContentsOfURL:absoluteURL error:outErrorPtr])
					{
						return [self initWithContentsOfURL:absoluteURL ofType:typeName error:outErrorPtr];
					}
					else
					{
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
//iTM2_END;
	return [super initWithContentsOfURL:absoluteURL ofType:typeName error:outErrorPtr];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= imageRepresentation
- (id)imageRepresentation;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id result = metaGETTER;
	if(result)
		return result;
	[self readImageRepresentationFromURL:[self fileURL] ofType:[self fileType] error:nil];
    return metaGETTER;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= setImageRepresentation:
- (void)setImageRepresentation:(id)aRepresentation;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(![aRepresentation isEqual:metaGETTER])
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSString * original = [self originalFileName];
    return [original isEqual:[self fileName]]? [super displayName]:
        [NSString stringWithFormat:@"%@ (%@ %@)", [super displayName], [NSString stringWithUTF8String:"⇠"], [original lastPathComponent]];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  readFromURL:ofType:error:
- (BOOL)readFromURL:(NSURL *)absoluteURL ofType:(NSString *)typeName error:(NSError **)outErrorPtr;
/*"Erase the cached core file name, root file name and identifier.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSTimer * _TIM = [IMPLEMENTATION metaValueForKey:@" _TIM"];
    if(_TIM)
    {
        //iTM2_START;
        [_TIM invalidate];// EXC_BAD_ACCESS? 
        [IMPLEMENTATION takeMetaValue:nil forKey:@" _TIM"];
        int _FW = [[IMPLEMENTATION metaValueForKey:@" _FW"] intValue];
        iTM2_LOG(@"Trying to read %@ (%i/10)", absoluteURL, ++_FW);
        [IMPLEMENTATION takeMetaValue:[NSNumber numberWithInt:_FW] forKey:@" _FW"];
    }

    if([absoluteURL isFileURL] && ![[absoluteURL path] length])
        return NO;
    BOOL result = NO;
    NS_DURING
    result = [super readFromURL:absoluteURL ofType:typeName error:outErrorPtr];
    NS_HANDLER
    iTM2_LOG(@"*** ERROR in file reading, catched exception %@", [localException reason]);
    result = NO;
    NS_ENDHANDLER
//NSLog(@"%@", [SDC documents]);
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  dataCompleteReadFromURL:ofType:error:
- (BOOL)dataCompleteReadFromURL:(NSURL *)fileURL ofType:(NSString *)type error:(NSError**)outErrorPtr;
/*" Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_LOG(@"--------------------------- IT IS EXPECTED SOMETHING ELSE");
	return [self readImageRepresentationFromURL:fileURL ofType:type error:outErrorPtr];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  newTryToReadImageRepresentationFromURL:ofType:error:
+ (BOOL)newTryToReadImageRepresentationFromURL:(NSURL *)fileURL ofType:(NSString *)type error:(NSError**)outErrorPtr;
/*" Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_STOP;
    return [[SDC documentForURL:fileURL] readImageRepresentationFromURL:fileURL ofType:type error:outErrorPtr]; 
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  readImageRepresentationFromURL:ofType:error:
- (BOOL)readImageRepresentationFromURL:(NSURL *)fileURL ofType:(NSString *)type error:(NSError**)outErrorPtr;
/*" Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSData * data = [NSData dataWithContentsOfURL:fileURL options:0 error:outErrorPtr];
    [self setDataRepresentation:data];
    Class C = [NSImageRep imageRepClassForData:data];
    if(C)
    {
        const char * s = (const char *)[data bytes];
        int length = [data length];
        if(length<8)
            goto bail;
        else if(!strncmp(s, "%PDF-1.", 6))
        {
            if(*(s+7) > 2)
            {
                // %PDF-1.3?
                // s points to the char after the last one
                s+=length;
                hawai:
                if(length>0)
                {
                    --s;
                    if((*s=='\r') || (*s=='\n'))
                    {
                        --length;
                        goto hawai;
                    }
                    else if((length<5) || strncmp(s-4, "%%EOF", 5))
                        goto bail;
                }
                else
                    goto bail;
            }
        }
        id newImageRepresentation = [[[C alloc] initWithData:data] autorelease];
        if(newImageRepresentation)
            [self setImageRepresentation:newImageRepresentation];
        else
        {
            iTM2_LOG(@"***  Due to an error, the old image representation is not updated...");
        }
        [IMPLEMENTATION takeMetaValue:[NSNumber numberWithInt:0] forKey:@" _FW"];//
        return [self imageRepresentation] != nil;
    }
    else
    {
        iTM2_LOG(@"NO CLASS for data");
        return NO;
    }
    bail:
    {
        iTM2_LOG(@"Problem with PDF file format...");
        int _FW = MAX(0, [[IMPLEMENTATION metaValueForKey:@" _FW"] intValue]);
        int retryCount = MAX([SUD integerForKey:iTM2PDFDocumentReadDataRetryCountKey], 0);
        float retryInterval = [SUD floatForKey:iTM2PDFDocumentReadDataRetryIntervalKey] > 0?:1;
        if(_FW<retryCount)
        {
            NSTimer * _TIM = [IMPLEMENTATION metaValueForKey:@" _TIM"];
            [_TIM invalidate];
            SEL selector = @selector(newTryToReadImageRepresentationFromURL:ofType:error:);
			NSMethodSignature * MS = [(id)isa methodSignatureForSelector:selector];
			NSAssert1(MS, @"..........  ERROR: unimplemented selector: %@", NSStringFromSelector(selector));
            NSInvocation * I = [NSInvocation invocationWithMethodSignature:MS];
            [I retainArguments];
            [I setSelector:selector];
            [I setTarget:[self class]];
            [I setArgument:&fileURL atIndex:2];
            [I setArgument:&type atIndex:3];
            [I setArgument:&outErrorPtr atIndex:4];
            _TIM = [NSTimer scheduledTimerWithTimeInterval:retryInterval invocation:I repeats:NO];
            [IMPLEMENTATION takeMetaValue:_TIM forKey:@" _TIM"];
            iTM2_LOG(@"Problem in reading the PDF data (try %i), Next try in %f seconds", _FW, retryCount, retryInterval);
        }
        else if(_FW == retryCount)
        {
            iTM2_LOG(@"Problem in reading the PDF data, no more try");
            ++_FW;
            [IMPLEMENTATION takeMetaValue:[NSNumber numberWithInt:_FW] forKey:@" _FW"];//
        }
        return YES;
    }
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  originalFileName
- (NSString *)originalFileName;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return metaGETTER?: [super originalFileName];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setOriginalFileName:
- (void)setOriginalFileName:(NSString *)argument;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return nil;
}
@end

#import <iTM2Foundation/iTM2BundleKit.h>

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
    return iTM2DefaultInspectorMode;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  dealloc
- (void)dealloc;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [INC removeObserver:self];
    [super dealloc];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= windowFrameIdentifier
- (NSString *)windowFrameIdentifier;
/*"Related to the observation of the window position, see the NSWindow category Position.
Added by jlaurens AT users DOT sourceforge DOT net (07/12/2001)"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return @"PDF Window";// return a hard string to allow subclassing
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= canAutoUpdate
- (BOOL)canAutoUpdate;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Jan 18 22:21:11 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return ![self contextBoolForKey:iTM2PDFNoAutoUpdateKey domain:iTM2ContextAllDomainsMask];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= windowPositionShouldBeObserved
- (BOOL)windowPositionShouldBeObserved;
/*"YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= firstPhysicalPage
- (int)firstPhysicalPage;
/*"Description forthcoming."*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return 0;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= lastPhysicalPage
- (int)lastPhysicalPage;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [[[self document] imageRepresentation] pageCount]-1;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= currentPhysicalPage
- (int)currentPhysicalPage;
/*"The album is the chief.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [[self album] currentPhysicalPage];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= setCurrentPhysicalPage:
- (void)setCurrentPhysicalPage:(int)aCurrentPhysicalPage;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [[self album] setCurrentPhysicalPage:aCurrentPhysicalPage];
    [self takeContextInteger:[self currentPhysicalPage] forKey:@"iTM2PDFCurrentPhysicalPage" domain:iTM2ContextAllDomainsMask];
    [[self window] flushKeyStrokeEvents:self];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  album
- (id)album;
/*"Returns the album."*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return metaGETTER;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setAlbum:
- (void)setAlbum:(NSView *)aView;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon Jan 10 21:45:41 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSView * _Album = metaGETTER;
    if(![aView isEqual:_Album])
    {
        if(_Album)
            [INC removeObserver:self
                    name: iTM2PDFMagnificationDidChangeNotification
                            object: _Album];
    	metaSETTER(aView);
        if(aView)
            [INC addObserver:self
                    selector: @selector(magnificationDidChangeNotified:)
                        name: iTM2PDFMagnificationDidChangeNotification
                            object: aView];
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= magnification
- (float)magnification;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon Jan 10 21:45:41 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [[self album] magnification];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= setMagnification:
- (void)setMagnification:(float)magnification;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon Jan 10 21:45:41 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(magnification <= 0)
		magnification = 1;
    [[self album] setMagnification:magnification];
    [self takeContextFloat:[[self album] magnification] forKey:iTM2PDFCurrentMagnificationKey domain:iTM2ContextAllDomainsMask];
    [self takeContextInteger:iTM2PDFDisplayModeLast forKey:iTM2PDFDisplayModeKey domain:iTM2ContextAllDomainsMask];
    [[self window] flushKeyStrokeEvents:self];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  magnificationDidChangeNotified:
- (void)magnificationDidChangeNotified:(NSNotification *)aNotification;
/*"Answer to a Notification post. The userInfo is meant to be a dictionary with the new magnification for key "iTM2Magnification". 
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon Jan 10 21:45:41 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
#warning **** NYI no magnification did change
#if 0
    NSDictionary * D = (NSDictionary *)[aNotification userInfo];
    if([D isKindOfClass:[NSDictionary class]])
    {
        NSNumber * N = [D objectForKey:@"magnification"];
        [[[self toolbarDelegate] magnificationField] setObjectValue:N];
        return;
    }
    iTM2_LOG(@"WARNING: Missing a  expected dictionary as userInfo or a number for key @\"magnification\"");
#endif
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  PDFInspectorCompleteLoadContext:
- (void)PDFInspectorCompleteLoadContext:(id)irrelevant;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[[self album] loadContext:irrelevant];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  PDFDocumentCompleteSaveContext:
- (void)PDFInspectorCompleteSaveContext:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self takeContextBool:[[self window] isKeyWindow] forKey:@"iTM2PDFKeyWindow" domain:iTM2ContextAllDomainsMask];// buggy
	[[self album] saveContext:sender];
//iTM2_END;
    return;
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSRect VR = [[self album] visibleRect];
	VR.origin.y += 0.66666 * VR.size.height;
	[[self album] scrollRectToVisible:VR];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  scrollPageDown:
- (void)scrollPageDown:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Feb  8 12:09:15 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSRect VR = [[self album] visibleRect];
	VR.origin.y -= 0.66666 * VR.size.height;
	[[self album] scrollRectToVisible:VR];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  scrollLineUp:
- (void)scrollLineUp:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Feb  8 12:09:15 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSRect VR = [[self album] visibleRect];
	VR.origin.y -= 0.05 * VR.size.height;
	[[self album] scrollRectToVisible:VR];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  scrollLineDown:
- (void)scrollLineDown:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Feb  8 12:09:15 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSRect VR = [[self album] visibleRect];
	VR.origin.y += 0.05 * VR.size.height;
	[[self album] scrollRectToVisible:VR];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  moveForward:
- (void)moveForward:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Feb  8 12:09:15 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  moveRight:
- (void)moveRight:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Feb  8 12:09:15 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSRect VR = [[self album] visibleRect];
	VR.origin.x += 0.05 * VR.size.width;
	[[self album] scrollRectToVisible:VR];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  moveBackward:
- (void)moveBackward:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Feb  8 12:09:15 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  moveLeft:
- (void)moveLeft:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Feb  8 12:09:15 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSRect VR = [[self album] visibleRect];
	VR.origin.x -= 0.05 * VR.size.width;
	[[self album] scrollRectToVisible:VR];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  moveUp:
- (void)moveUp:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Feb  8 12:09:15 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSRect frame = [[self album] frame];
	[[self album] scrollPoint:NSMakePoint(NSMaxX(frame), NSMinY(frame))];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  moveToTheBeginning:
- (void)moveToTheBeginning:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Feb  8 12:09:15 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSRect frame = [[self album] frame];
	[[self album] scrollPoint:NSMakePoint(NSMinX(frame), NSMaxY(frame))];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  moveHome:
- (void)moveHome:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Feb  8 12:09:15 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self moveToTheBeginning:sender];
    return;
}
@end

@implementation iTM2PDFInspector(UINavigation)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= takeMagnificationFromField:
- (IBAction)takeMagnificationFromField:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Jan 19 23:19:59 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self setMagnification:[sender floatValue]];
	[sender validateWindowContent];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= validateTakeMagnificationFromField:
- (BOOL)validateTakeMagnificationFromField:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Jan 19 23:19:59 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[sender setFloatValue:[self magnification]];
//iTM2_END;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= takeMagnificationFromStepper:
- (IBAction)takeMagnificationFromStepper:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Jan 19 23:19:59 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([sender intValue]<0)
		[self doZoomOut:nil];
	else
		[self doZoomIn:nil];
//NSLog(@"dfp");
    [sender setIntValue:0];
	[self validateWindowContent];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= validateTakeMagnificationFromStepper:
- (BOOL)validateTakeMagnificationFromStepper:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Jan 19 23:19:59 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setIntValue:0];
//iTM2_END;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= takeLogicalPageFromField:
- (IBAction)takeLogicalPageFromField:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Jan 19 23:19:59 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self setCurrentPhysicalPage:[sender intValue] - 1];
	[sender validateWindowContent];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= validateTakeLogicalPageFromField:
- (BOOL)validateTakeLogicalPageFromField:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Jan 19 23:19:59 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	int CFP = [self currentPhysicalPage];
    [sender setIntValue:CFP + 1];
	[[sender formatter] setMaximum:(NSDecimalNumber *)[NSDecimalNumber numberWithInt:[self lastPhysicalPage] + 1]];
//iTM2_END;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= doGoToFirstPage:
- (IBAction)doGoToFirstPage:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Jan 19 23:19:59 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//NSLog(@"dfp");
    [self setCurrentPhysicalPage:0];
	[self validateWindowContent];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= validateDoGoToFirstPage:
- (BOOL)validateDoGoToFirstPage:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Jan 19 23:19:59 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	return ([[self album] imageRepresentation] != nil) && ([[self album] currentPhysicalPage] >[[self album] firstPhysicalPage]);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= doGoToLastPage:
- (IBAction)doGoToLastPage:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Jan 19 23:19:59 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [[self album] setCurrentPhysicalPage:INT_MAX];
	[self validateWindowContent];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= validateDoGoToLastPage:
- (BOOL)validateDoGoToLastPage:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Jan 19 23:19:59 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	return [[self album] imageRepresentation]!=nil && [[self album] currentPhysicalPage]<[[self album] lastPhysicalPage];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= doGoForward:
- (IBAction)doGoForward:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Jan 19 23:19:59 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [[self album] setCurrentPhysicalPage:[[self album] forwardPhysicalPage]];
	[self validateWindowContent];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= validateDoGoForward:
- (BOOL)validateDoGoForward:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Jan 19 23:19:59 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	return [[self album] forwardPhysicalPage] != -1;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= doGoBack:
- (IBAction)doGoBack:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Jan 19 23:19:59 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [[self album] setCurrentPhysicalPage:[[self album] backPhysicalPage]];
	[self validateWindowContent];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= validateDoGoBack:
- (BOOL)validateDoGoBack:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Jan 19 23:19:59 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	return [[self album] backPhysicalPage] != -1;
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
	[self setMagnification:1.0];
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
    return [self magnification] != 1.0;
}
@end

@interface NSString(iTM2PDFInspector)
- (BOOL)getIntegerTrailer:(int *)intPtr;
@end
@implementation iTM2PDFInspector(iTM2KeyStrokeKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  macroCategory
- (NSString *)macroCategory;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return iTM2PDFKeyBindingsIdentifier;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  keyBindingsManager
- (id)keyBindingsManager;
/*"The text and pdf objects won't shared the same key bindings manager.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [[[self window] firstResponder] isKindOfClass:[NSText class]]?
		nil:
		[super keyBindingsManager];
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  tryToExecuteMacro:
- (BOOL)tryToExecuteMacro:(NSString *)instruction;
/*"Description forthcoming.
If the event is a 1 char key down, it will ask the current key binding for instruction.
The key and its modifiers are 
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    BOOL result = [super tryToExecuteMacro:instruction];
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
    [[[self window] keyStrokes] getIntegerTrailer:&n];
    [self setMagnification:n/100.0];
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
    if([[[self window] keyStrokes] getIntegerTrailer:&n])
        [self setCurrentPhysicalPage:n-1];
//iTM2_END;
    return;
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
    int n = 100 * ([self contextFloatForKey:@"iTM2ZoomFactor" domain:iTM2ContextAllDomainsMask]>0?:1.259921049895);
    [[[self window] keyStrokes] getIntegerTrailer:&n];
	if(n>0)
		[self setMagnification:n / 100.0 * [self magnification]];
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
    int n = 100 * ([self contextFloatForKey:@"iTM2ZoomFactor" domain:iTM2ContextAllDomainsMask]>0?:1.259921049895);
    [[[self window] keyStrokes] getIntegerTrailer:&n];
	if(n>0)
		[self setMagnification:100.0 * [self magnification] / n];
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
    [[[self window] keyStrokes] getIntegerTrailer:&n];
    [self setCurrentPhysicalPage:[self currentPhysicalPage] - n];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= validateDoGoToPreviousPage:
- (BOOL)validateDoGoToPreviousPage:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Jan 19 23:19:59 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	return ([[self album] imageRepresentation] != nil) && ([self currentPhysicalPage] >[self firstPhysicalPage]);
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
//iTM2_LOG(@"n=%i", n);
    [[[self window] keyStrokes] getIntegerTrailer:&n];
//iTM2_LOG(@"n=%i", n);
//    int old = [self currentPhysicalPage];
//    int new = [self currentPhysicalPage] + n;
    [self setCurrentPhysicalPage:[self currentPhysicalPage] + n];
//iTM2_LOG(@"old: %i, new: %i, real new: %i", old, new, [self currentPhysicalPage]);
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= validateDoGoToNextPage:
- (BOOL)validateDoGoToNextPage:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Jan 19 23:19:59 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	return [[self album] imageRepresentation]!=nil && [self currentPhysicalPage]<[self lastPhysicalPage];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= doGoToPreviousPreviousPage:
- (void)doGoToPreviousPreviousPage:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Jan  5 17:41:55 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    int n = 5;
    [[[self window] keyStrokes] getIntegerTrailer:&n];
    [self setCurrentPhysicalPage:[self currentPhysicalPage] - n];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= validateDoGoToPreviousPreviousPage:
- (BOOL)validateDoGoToPreviousPreviousPage:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Jan 19 23:19:59 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	return ([[self album] imageRepresentation] != nil) && ([self currentPhysicalPage] > [self firstPhysicalPage]);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= doGoToNextNextPage:
- (void)doGoToNextNextPage:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Jan  5 17:41:55 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    int n = 5;
//iTM2_LOG(@"n=%i", n);
    [[[self window] keyStrokes] getIntegerTrailer:&n];
//iTM2_LOG(@"n=%i", n);
//    int old = [self currentPhysicalPage];
//    int new = [self currentPhysicalPage] + n;
    [self setCurrentPhysicalPage:[self currentPhysicalPage] + n];
//iTM2_LOG(@"old: %i, new: %i, real new: %i", old, new, [self currentPhysicalPage]);
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= validateDoGoToNextNextPage:
- (BOOL)validateDoGoToNextNextPage:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Jan 19 23:19:59 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	return [[self album] imageRepresentation]!=nil && [self currentPhysicalPage]<[self lastPhysicalPage];
}
@end

#import <iTM2Foundation/iTM2ViewKit.h>
#import <iTM2Foundation/iTM2CursorKit.h>
#import <iTM2Foundation/iTM2ButtonKit.h>

@interface iTM2PDFAlbumView(PRIVATE_123)
- (void)zoomInMouseDown:(NSEvent *)theEvent;
- (void)zoomOutMouseDown:(NSEvent *)theEvent;
- (void)_SetMagnification:(float)newMagnification;
- (int)firstPhysicalPage;
- (int)lastPhysicalPage;
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
{iTM2_DIAGNOSTIC;
	iTM2_INIT_POOL;
//iTM2_START;
	[super initialize];
    [SUD registerDefaults:
        [NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithFloat:4.0], iTM2PDFZoomInMagnificationScaleKey,
            [NSDecimalNumber one], iTM2PDFFixedMagnificationKey,
            [NSDecimalNumber one], iTM2PDFLastMagnificationKey,
            [NSNumber numberWithInt:iTM2PDFDisplayModeFixed], iTM2PDFDisplayModeKey,
            [NSNumber numberWithInt:iTM2PDFStickToWidthMode], iTM2PDFStickModeKey,
                nil]];
//iTM2_END;
	iTM2_RELEASE_POOL;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= currentPhysicalPage
- (id)initWithFrame:(NSRect)frame;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon Jan 10 21:45:41 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(self = [super initWithFrame:frame])
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(self = [super initWithCoder:(NSCoder *) decoder])
    {
        [self setCenteredSubview:[[[iTM2PDFView alloc] initWithFrame:NSZeroRect] autorelease]];
    }
    return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  awakeFromNib
- (void)awakeFromNib;
/*"Registers for NSViewFrameDidChangeNotification sent by the enclosing scroll view."*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if([[self superclass] instancesRespondToSelector:_cmd])
        [super awakeFromNib];
    [self setMagnificationWithDisplayMode:[self contextIntegerForKey:iTM2PDFDisplayModeKey domain:iTM2ContextAllDomainsMask]
            stickMode: [self contextIntegerForKey:iTM2PDFStickModeKey domain:iTM2ContextAllDomainsMask]];
    [self setNeedsDisplay:YES];
    self->_CanStick = YES;
    [self setParametersHaveChanged:YES];
    [self setPDFOrientation:0];
    [[[self enclosingScrollView] contentView] setPostsFrameChangedNotifications:YES];
    [DNC removeObserver:self name:NSViewFrameDidChangeNotification object:nil];
    [DNC addObserver:self
		selector: @selector(enclosingScrollViewContentFrameDidChangeNotified:)
			name: NSViewFrameDidChangeNotification
				object: [[self enclosingScrollView] contentView]];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  imageRepresentation
- (id)imageRepresentation;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon Jan 10 21:45:41 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [[[[self window] windowController] document] imageRepresentation];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  togglePDFSlidesLandscapeMode:
- (void)togglePDFSlidesLandscapeMode:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    BOOL old = [self contextBoolForKey:iTM2PDFSlidesLandscapeModeKey domain:iTM2ContextAllDomainsMask];
    [self takeContextValue:[NSNumber numberWithBool:!old] forKey:iTM2PDFSlidesLandscapeModeKey domain:iTM2ContextAllDomainsMask];
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
    SEL action = [sender action];
    if(action == @selector(togglePDFSlidesLandscapeMode:))
    {
        [sender setState:([self contextBoolForKey:iTM2PDFSlidesLandscapeModeKey domain:iTM2ContextAllDomainsMask]? NSOnState:NSOffState)];
        return YES;
    }
    return YES;
}
#pragma mark =-=-=-=-=-  PAGE MANAGEMENT
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= currentPhysicalPage
- (int)currentPhysicalPage;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon Jan 10 21:45:41 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//    return _CurrentPhysicalPage;
    return [[self centeredSubview] currentPhysicalPage];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= setCurrentPhysicalPage:
- (void)setCurrentPhysicalPage:(int)aCurrentPhysicalPage;
/*"O based.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon Jan 10 21:45:41 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    aCurrentPhysicalPage = MAX(0, MIN(aCurrentPhysicalPage, [[self imageRepresentation] pageCount] - 1));
    if(aCurrentPhysicalPage != [self currentPhysicalPage])
    {
        [[self centeredSubview] setCurrentPhysicalPage:aCurrentPhysicalPage];
        [self setParametersHaveChanged:YES];
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  logicalToPhysicalPage:
- (int)logicalToPhysicalPage:(int)logicalPage;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon Jan 10 21:45:41 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return logicalPage - 1;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  physicalToLogicalPage:
- (int)physicalToLogicalPage:(int)physicalPage;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon Jan 10 21:45:41 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return physicalPage + 1;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  firstPhysicalPage
- (int)firstPhysicalPage;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon Jan 10 21:45:41 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return 0;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  lastPhysicalPage
- (int)lastPhysicalPage;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon Jan 10 21:45:41 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [[self imageRepresentation] pageCount];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  forwardPhysicalPage
- (int)forwardPhysicalPage;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon Jan 10 21:45:41 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return 0;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  backPhysicalPage
- (int)backPhysicalPage;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon Jan 10 21:45:41 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [[self imageRepresentation] pageCount];
}
#pragma mark =-=-=-=-=-  PAGE LAYOUT MANAGEMENT
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  pageLayout
- (unsigned)pageLayout;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon Jan 10 21:45:41 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [self contextIntegerForKey:@"iTM2PDFLayoutMode" domain:iTM2ContextAllDomainsMask];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  setPageLayout:
- (void)setPageLayout:(unsigned)PL;
/*"Initializer. MUST be called at initialization time.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon Jan 10 21:45:41 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if([self contextIntegerForKey:@"iTM2PDFLayoutMode" domain:iTM2ContextAllDomainsMask] != PL)
    {
        [self takeContextInteger:PL forKey:@"iTM2PDFLayoutMode" domain:iTM2ContextAllDomainsMask];
        [self setParametersHaveChanged:YES];
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= PDFOrientation
- (int)PDFOrientation;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon Jan 10 21:45:41 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [self contextIntegerForKey:@"iTM2PDFOrientation" domain:iTM2ContextAllDomainsMask];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setPDFOrientation:
- (void)setPDFOrientation:(int)argument;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon Jan 10 21:45:41 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    argument %= 3;
    if(argument == 3) argument = -1;
    int _OrientationMode = [self contextIntegerForKey:@"iTM2PDFOrientation" domain:iTM2ContextAllDomainsMask];
    if(argument != _OrientationMode)
    {
        [self takeContextInteger:argument forKey:@"iTM2PDFOrientation" domain:iTM2ContextAllDomainsMask];
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [self contextIntegerForKey:@"iTM2PDFOrientation" domain:iTM2ContextAllDomainsMask];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setSlidesLandscape:
- (void)setSlidesLandscape:(BOOL)argument;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon Jan 10 21:45:41 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    argument %= 3;
    if(argument == 3) argument = -1;
    int _OrientationMode = [self contextIntegerForKey:@"iTM2PDFOrientation" domain:iTM2ContextAllDomainsMask];
    if(argument != _OrientationMode)
    {
        [self takeContextInteger:argument forKey:@"iTM2PDFOrientation" domain:iTM2ContextAllDomainsMask];
        [self setParametersHaveChanged:YES];
        [[self centeredSubview] setNeedsUpdateGeometry:YES];
    }
    return;
}
#pragma mark =-=-=-=-=-  MAGNIFICATION MANAGEMENT
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  magnification
- (float)magnification;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon Jan 10 21:45:41 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [self contextFloatForKey:iTM2PDFLastMagnificationKey domain:iTM2ContextAllDomainsMask];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setMagnification:
- (void)setMagnification:(float)aMagnification;
/*A wrapper of _SetMagnification: _CanStick added.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon Jan 10 21:45:41 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    _CanStick = NO;// critical: before truely setting the magnification
    [self _SetMagnification:aMagnification];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  _SetMagnification:
- (void)_SetMagnification:(float)newMagnification;
/*"If there is something to set, this will be registered in the user default domain under key iTM2PDFRepCurrentMagnificationKey,
and a iTM2MagnificationDidChangeNotification is posted with the receiver as object and as userInfo the new magnification
under key iTM2MagnificationKey in a dictionary.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon Jan 10 21:45:41 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	// testing the newMagnification consistency
	if(newMagnification<0.01)
		newMagnification = 0.01;
	else if(newMagnification>100)
		newMagnification = 100;
    float old = [self magnification];
    if(old != newMagnification)
    {
        [self takeContextFloat:newMagnification forKey:iTM2PDFLastMagnificationKey domain:iTM2ContextAllDomainsMask];
        [INC postNotificationName:iTM2PDFMagnificationDidChangeNotification
                object: self
                    userInfo: [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:newMagnification], iTM2PDFLastMagnificationKey, nil]];
        [self setParametersHaveChanged:YES];
        [self setNeedsDisplay:YES];
    }
    [[self window] makeFirstResponder:self];// Critical:see the responder added after the contentView (a bit tricky!!!)
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setMagnificationWithDisplayMode:stickMode:
- (void)setMagnificationWithDisplayMode:(int)displayMode stickMode:(int)stickMode;
/*"If the display mode is iTM2StickMode, fix the magnification according to the stick mode.
Nothing else.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon Jan 10 21:45:41 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    switch(displayMode)
    {
        case iTM2PDFDisplayModeFixed:
            [self setMagnification:[self contextFloatForKey:iTM2PDFFixedMagnificationKey domain:iTM2ContextAllDomainsMask]];
            _CanStick = NO;
            break;
        case iTM2PDFDisplayModeLast:
            [self setMagnification:[self contextFloatForKey:iTM2PDFLastMagnificationKey domain:iTM2ContextAllDomainsMask]];
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
- (float)innerMagnification;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon Jan 10 21:45:41 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return MIN([self magnification] * sqrt(2), 6400);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  outerMagnification
- (float)outerMagnification;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon Jan 10 21:45:41 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return MAX([self magnification]/sqrt(2), 0.1);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=  ratioContentVersusDocumentWidth
- (float)ratioContentVersusDocumentWidth;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon Jan 10 21:45:41 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    switch([self pageLayout])
    {
        case iTM2PDFSinglePageLayout:
        case iTM2PDFOneColumnLayout:
        {
            NSSize S = [[self imageRepresentation] size];
            BOOL rotated = [self PDFOrientation] != 0;
            BOOL slideMode = [self contextBoolForKey:iTM2PDFSlidesLandscapeModeKey domain:iTM2ContextAllDomainsMask];
            float width = slideMode? (rotated? S.width: S.height): (rotated? S.height: S.width);
            if(width>0)
            {
                NSView * contentView=[[self enclosingScrollView] contentView];
                if(contentView != nil)
                    return ([contentView frame].size.width -2*[self contextFloatForKey:iTM2PDFAlbumMarginKey domain:iTM2ContextAllDomainsMask])/width;
            }
            return 1;
        }
        break;
        //case iTM2PDFTwoColumnLeftLayout:
        //case iTM2PDFTwoColumnRightLayout:
        default:
        {
            NSSize S = [[self imageRepresentation] size];
            BOOL rotated = [self PDFOrientation] != 0;
            BOOL slideMode = [self contextBoolForKey:iTM2PDFSlidesLandscapeModeKey domain:iTM2ContextAllDomainsMask];
            float width = slideMode? (rotated? S.width: S.height): (rotated? S.height: S.width);
            if(width>0)
            {
                NSView * contentView=[[self enclosingScrollView] contentView];
                if(contentView != nil)
                    return ([contentView frame].size.width
                    -2*[self contextFloatForKey:iTM2PDFAlbumMarginKey domain:iTM2ContextAllDomainsMask]-2*iTM2PDFAlbumViewMargin)/2/width;
            }
            return 1;
        }
    }
}
//=-=-=-=-=-=-=-=-=-=-=-=  ratioContentVersusDocumentHeight
- (float)ratioContentVersusDocumentHeight;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon Jan 10 21:45:41 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSSize S = [[self imageRepresentation] size];
    BOOL rotated = [self PDFOrientation] != 0;
    BOOL slideMode = [self contextBoolForKey:iTM2PDFSlidesLandscapeModeKey domain:iTM2ContextAllDomainsMask];
    float height = slideMode? (rotated? S.height: S.width): (rotated? S.width: S.height);
    if(height>0)
    {
        NSView * contentView = [[self enclosingScrollView] contentView];
        if(contentView != nil)
            return ([contentView frame].size.height -2*[self contextFloatForKey:iTM2PDFAlbumMarginKey domain:iTM2ContextAllDomainsMask])/height;
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [super flagsChanged:theEvent];
    [[self window] invalidateCursorRectsForView:self];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  mouseDown:
- (void)mouseDown:(NSEvent *)theEvent;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon Jan 10 21:45:41 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    int flags = [theEvent modifierFlags];
    if(flags & [[self class] zoomInKeyMask])
        [self zoomInMouseDown:theEvent];
    else if(flags & [[self class] zoomOutKeyMask])
        [self zoomOutMouseDown:theEvent];
    else if(!(flags & (NSAlphaShiftKeyMask | NSShiftKeyMask | NSControlKeyMask | NSAlternateKeyMask | NSCommandKeyMask | NSNumericPadKeyMask | NSHelpKeyMask | NSFunctionKeyMask)))
    {
		// The selected rect becomes the full one
        NSSize magnification = [self convertSize:NSMakeSize(1, 1) fromView:nil];
        if([self isFlipped])
            magnification.height *= -1;
        manihi:
        theEvent = [[self window] nextEventMatchingMask:NSLeftMouseUpMask|NSLeftMouseDraggedMask];
        switch([theEvent type])
        {
            case NSLeftMouseDragged:
            {
                NSPoint offset;
                offset.x = [theEvent deltaX];
                offset.y = [theEvent deltaY];
                if((offset.x != 0.0) || (offset.y != 0.0))
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
//NSLog(@"%f", [self contextFloatForKey:iTM2PDFMixedButtonDelayKey domain:iTM2ContextAllDomainsMask]);
//    [self tryToPerform:@selector(doZoomIn:) with:self];
//    return;
    if([NSApp nextEventMatchingMask:NSLeftMouseUpMask
        untilDate: [NSDate dateWithTimeIntervalSinceNow:[self contextFloatForKey:iTM2UDMixedButtonDelayKey domain:iTM2ContextAllDomainsMask]]
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
    
    float zoomFactor = 1.0/([self contextFloatForKey:iTM2PDFZoomInMagnificationScaleKey domain:iTM2ContextAllDomainsMask]?:1);

    NSPoint locationInWindow, locationInView;
    NSRect nextRect;

    theMarket:

    // get Mouse location and check if it is with the view's rect
    locationInWindow = [[self window] mouseLocationOutsideOfEventStream];
    locationInView = [self convertPoint:locationInWindow fromView:nil];
    // check if the mouse is in the rect
    if([self mouse:locationInView inRect:[self visibleRect]])
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
        float minY, maxY;
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
    locationInWindow = [[self window] mouseLocationOutsideOfEventStream];
    locationInView = [self convertPoint:locationInWindow fromView:nil];

    if([self isFlipped])
    {
        if(locationInView.y>=NSMaxY([self visibleRect])-5)
        {
            [self tryToPerform:@selector(scrollLineDown:) with:self];
            if(noPeriodicEvents)
            {
//NSLog(@"starting periodic");
                [NSEvent startPeriodicEventsAfterDelay:0.1 withPeriod:0.1];
                noPeriodicEvents = NO;
            }
        }
        else if(locationInView.y<=NSMinY([self visibleRect])+5)
        {
            [self tryToPerform:@selector(scrollLineUp:) with:self];
            if(noPeriodicEvents)
            {
//NSLog(@"starting periodic");
                [NSEvent startPeriodicEventsAfterDelay:0.1 withPeriod:0.1];
                noPeriodicEvents = NO;
            }
        }
    }
    else
    {
        if(locationInView.y>=NSMaxY([self visibleRect])-5)
        {
//NSLog(@"starting periodic");
            [self tryToPerform:@selector(scrollLineUp:) with:self];
            if(noPeriodicEvents)
            {
                [NSEvent startPeriodicEventsAfterDelay:0.1 withPeriod:0.1];
                noPeriodicEvents = NO;
            }
        }
        else if(locationInView.y<=NSMinY([self visibleRect])+5)
        {
            [self tryToPerform:@selector(scrollLineDown:) with:self];
            if(noPeriodicEvents)
            {
//NSLog(@"starting periodic");
                [NSEvent startPeriodicEventsAfterDelay:0.1 withPeriod:0.1];
                noPeriodicEvents = NO;
            }
        }
    }

//NSLog(@"noPeriodicEvents: %@", (noPeriodicEvents? @"Y": @"N"));

    theEvent = [[self window] nextEventMatchingMask:NSPeriodicMask|NSLeftMouseUpMask|NSLeftMouseDraggedMask];
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
    int flags = [[NSApp currentEvent] modifierFlags];
    if(flags & [[self class] zoomInKeyMask])
        [self addCursorRect:[self visibleRect] cursor:[NSCursor zoomInCursor]];
    else if(flags & [[self class] zoomOutKeyMask])
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setNeedsDisplay:
- (void)setNeedsDisplay:(BOOL)aFlag;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon Jan 10 21:45:41 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(aFlag)
    {
        if(_CanStick)
            [self setMagnificationWithDisplayMode:[self contextIntegerForKey:iTM2PDFDisplayModeKey domain:iTM2ContextAllDomainsMask]
                stickMode: [self contextIntegerForKey:iTM2PDFStickModeKey domain:iTM2ContextAllDomainsMask]];
//iTM2_LOG(@"[self magnification] is:%f", [self magnification]);
        if([self parametersHaveChanged])
        {
            [self setParametersHaveChanged:NO];
            // the center of the visible rect points to some view
            // what is this center?
            if([self imageRepresentation]!=nil)
            {
                iTM2PDFView * CSV = [self centeredSubview];
//NSLog(@"focus: %@", NSStringFromPoint(focus));
                // essentially updates the geometry of the subview and the receiver
                [CSV setPageLayout:[self pageLayout]];
                [CSV setImageRepresentation:[self imageRepresentation]];// critical, before
                [CSV setMagnification:[self magnification]];// critical, before
                [CSV setBoundsRotation:90 * [self PDFOrientation]];
                [CSV updateGeometry];
                NSRect rect = NSIntegralRect(NSInsetRect([CSV frame], -iTM2PDFAlbumViewMargin, -iTM2PDFAlbumViewMargin));
                NSRect bounds = NSIntegralRect([[[self enclosingScrollView] contentView] bounds]);
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
//NSLog(@"%@ %#x(Rep)", NSStringFromClass([self class]), NSStringFromSelector(_cmd), self);
//NSLog(NSStringFromRect([self frame]));
//iTM2_LOG(NSStringFromRect([[self centeredSubview] frame]));
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return ([self contextIntegerForKey:iTM2PDFDisplayModeKey domain:iTM2ContextAllDomainsMask] == iTM2PDFDisplayModeStick);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  parametersHaveChanged
- (BOOL)parametersHaveChanged;
/*"Parameters are attributes that may change the aspect of the view: magnification, orientation...
When parameters have changed, the view is inited.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon Jan 10 21:45:41 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return _ParametersHaveChanged;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setParametersHaveChanged:
- (void)setParametersHaveChanged:(BOOL)aFlag;
/*"This message MUST be sent each time a display parameter has changed.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon Jan 10 21:45:41 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(_ParametersHaveChanged != aFlag)
    {
        _ParametersHaveChanged = aFlag;
        if(_ParametersHaveChanged)
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
#warning NYI this is needed for live sizing
//iTM2_END;
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
{iTM2_DIAGNOSTIC;
//NSLog(@"%@ %#x (Rep)", NSStringFromClass([self class]), NSStringFromSelector(_cmd), self);
//NSLog(@"[self parametersHaveChanged]:%@", ([self parametersHaveChanged]? @"Y":@"N"));
    [self prepareToUpdate];
    if([self parametersHaveChanged])
    {
        NSPoint absoluteFocus = NSZeroPoint;
        [self setParametersHaveChanged:NO];
        if([self imageRepresentation]!=nil)
        {
            iTM2PDFView * subview = [self subview];
            absoluteFocus = [subview absoluteFocus];// remembers the last focused point before any change
//NSLog(@"absoluteFocus: %@", NSStringFromPoint(absoluteFocus));
            [self updateSubview:subview];
            {
                NSRect rect = NSInsetRect([subview frame], -10, -10);
                NSRect bounds = [[[self enclosingScrollView] contentView] bounds];//the contentView is tied to the window
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
            if(![self window] || ![[self window] makeFirstResponder:subview])
                NSLog(@"[[self window] makeFirstResponder:subview]:Refused");
//            else
//NSLog(@"%@ = %@", [[self window] firstResponder], subview);
        }
        else
            while([[self subviews] count]>0)
                [[[self subviews] objectAtIndex:0] removeFromSuperviewWithoutNeedingDisplay];
    }
    return;
}
#endif
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  albumViewCompleteSaveContext:
- (void)albumViewCompleteSaveContext:(id)irrelevant;
/*"YES."*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[[self centeredSubview] saveContext:irrelevant];
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  albumViewCompleteLoadContext:
- (void)albumViewCompleteLoadContext:(id)irrelevant;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self setMagnificationWithDisplayMode:[self contextIntegerForKey:iTM2PDFDisplayModeKey domain:iTM2ContextAllDomainsMask]
            stickMode: [self contextIntegerForKey:iTM2PDFStickModeKey domain:iTM2ContextAllDomainsMask]];
//    self->_CanStick = YES;
    [self setCurrentPhysicalPage:[self contextIntegerForKey:@"iTM2PDFCurrentPhysicalPage" domain:iTM2ContextAllDomainsMask]];
	[[self centeredSubview] loadContext:irrelevant];
    [self setParametersHaveChanged:YES];// of course!!!
	[self setNeedsDisplay:YES];// Bug side effect too.	
//iTM2_RETURN;
    return;
}
@end
#if 0
@implementation iTM2PDFDocument(MOO)
- (void)updateChangeCount:(NSDocumentChangeType)change;
{iTM2_DIAGNOSTIC;
	if(change == NSChangeDone)
	{
		iTM2_LOG(@"CHANGING");
	}
	else if(change == NSChangeUndone)
	{
		iTM2_LOG(@"UNCHANGING");
	}
	[super updateChangeCount:(NSDocumentChangeType)change];
}
@end
#endif
NSString * const iTM2PDFSetUpPageWhenBadPaperSizeKey = @"iTM2PDFSetUpPageWhenBadPaperSize";
NSString * const iTM2PDFPreferA4PaperKey = @"iTM2PDFPreferA4Paper";

@implementation iTM2PDFDocument(Print)
#if 0
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  load
+ (void)load;
/*"Description forthcoming."*/
{iTM2_DIAGNOSTIC;
	iTM2_INIT_POOL;
	iTM2RedirectNSLogOutput();
//iTM2_START;
    [SUD registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:
        [NSNumber numberWithBool:NO], iTM2PDFPreferA4PaperKey,
        [NSNumber numberWithBool:NO], iTM2PDFSetUpPageWhenBadPaperSizeKey,
            nil]];
//iTM2_END;
	iTM2_RELEASE_POOL;
    return;
}
#endif
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  printShowingPrintPanel:
- (void)printShowingPrintPanel:(BOOL)flag;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(flag)
    {
        if([self contextBoolForKey:iTM2PDFSetUpPageWhenBadPaperSizeKey domain:iTM2ContextAllDomainsMask])
        {
            BOOL setupPage = NO;
            NSPrintInfo * PI = [self printInfo];
            NSSize paperSize = [PI paperSize];
//iTM2_LOG(@"paperSize: %@", NSStringFromSize(paperSize));
            if((paperSize.width>0) && (paperSize.height>0))
            {
                NSSize repSize = [[self imageRepresentation] size];
                float dH = paperSize.height - repSize.height;
                float dW = paperSize.width - repSize.width;
                float dWH = dH*dH+dW*dW;
                float WH = paperSize.height*paperSize.height + paperSize.width*paperSize.width;
                NSLog(@"repSize: %@", NSStringFromSize(repSize));
                if(dWH>0.0001*WH)
                {
                    NSLog(@"bad paper size");
                    setupPage = YES;
                }
            }
            else
                setupPage = YES;
            if(setupPage)
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSPrintInfo * PI = [self printInfo];
    iTM2PDFPrintView * V = [[[iTM2PDFPrintView allocWithZone:[self zone]] initWithRepresentation:[self imageRepresentation]
        slidesLandscape: [self contextBoolForKey:iTM2PDFSlidesLandscapeModeKey domain:iTM2ContextAllDomainsMask]
            scale: [[[PI dictionary] objectForKey:NSPrintScalingFactor] floatValue]] autorelease];
    NSPrintOperation * PO = [NSPrintOperation printOperationWithView:V printInfo:PI];
    [PO setShowPanels:flag];
    [PO setCanSpawnSeparateThread:YES];
    [PO runOperation];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= pageLayoutDidEnd:returnCode:contextInfo:
- (void)_PageLayoutDidEnd:(NSPageLayout *)pageLayout returnCode:(int)returnCode contextInfo:(void *)contextInfo;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_LOG(@"_PageLayoutDidEnd, %u", returnCode);
    if(returnCode == NSOKButton)
        [self printRepresentationShowingPrintPanel:YES];
    return;
}
@end
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2PDFPrintKit  =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

NSString * const iTM2PDFToolbarIdentifier = @"iTM2 PDF Toolbar: Default";
#import <iTM2Foundation/iTM2PDFToolbarDelegate.h>

@implementation iTM2MainInstaller(PDFDocumentKitInspectorToolbar)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  PDFKitInspectorToolbarCompleteInstallation
- (void)PDFDocumentKitInspectorToolbarCompleteInstallation;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue May  3 16:20:26 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[SUD registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:
		[NSNumber numberWithBool:YES], @"iTM2PDFToolbarAutosavesConfiguration",
		[NSNumber numberWithBool:YES], @"iTM2PDFToolbarShareConfiguration",
			nil]];
//iTM2_END;
	return;
}
@end

@implementation iTM2PDFInspector(Toolbar)
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
    NSToolbar * toolbar = [[[NSToolbar alloc] initWithIdentifier:iTM2PDFToolbarIdentifier] autorelease];
	NSString * key = [NSString stringWithFormat:@"NSToolbar Configuration %@", [toolbar identifier]];
	if([self contextBoolForKey:@"iTM2PDFKitToolbarShareConfiguration" domain:iTM2ContextAllDomainsMask])
	{
		NSDictionary * configDictionary = [SUD dictionaryForKey:key];
		if([configDictionary count])
		{
			[toolbar setConfigurationFromDictionary:configDictionary];
			if(![[toolbar items] count])
			{
				[SUD removeObjectForKey:key];
				toolbar = [[[NSToolbar alloc] initWithIdentifier:iTM2PDFToolbarIdentifier] autorelease];
			}
		}
	}
	else
	{
		NSDictionary * configDictionary = [SUD dictionaryForKey:key];
//iTM2_LOG(@"configDictionary: %@", configDictionary);
		configDictionary = [self contextDictionaryForKey:key domain:iTM2ContextAllDomainsMask];
//iTM2_LOG(@"configDictionary: %@", configDictionary);
		if([configDictionary count])
			[toolbar setConfigurationFromDictionary:configDictionary];
		if(![[toolbar items] count])
		{
			configDictionary = [SUD dictionaryForKey:key];
//iTM2_LOG(@"configDictionary: %@", configDictionary);
			[self takeContextValue:nil forKey:key domain:iTM2ContextAllDomainsMask];
			if([configDictionary count])
				[toolbar setConfigurationFromDictionary:configDictionary];
			if(![[toolbar items] count])
			{
				[SUD removeObjectForKey:key];
				toolbar = [[[NSToolbar alloc] initWithIdentifier:iTM2PDFToolbarIdentifier] autorelease];
			}
		}
	}
	[toolbar setAutosavesConfiguration:YES];
    [toolbar setAllowsUserCustomization:YES];
//    [toolbar setSizeMode:NSToolbarSizeModeSmall];
	id toolbarDelegate = [[[iTM2PDFToolbarDelegate allocWithZone:[self zone]] init] autorelease];
	[[self implementation] takeMetaValue:toolbarDelegate forKey:@"_toolbarDelegate"];// retain the object
    [toolbar setDelegate:toolbarDelegate];
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
	BOOL old = [self contextBoolForKey:@"iTM2PDFToolbarShareConfiguration" domain:iTM2ContextAllDomainsMask];
	[self takeContextBool:!old forKey:@"iTM2PDFToolbarShareConfiguration" domain:iTM2ContextAllDomainsMask];
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
	[sender setState:([self contextBoolForKey:@"iTM2PDFToolbarShareConfiguration" domain:iTM2ContextAllDomainsMask]? NSOnState:NSOffState)];
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
    NSToolbar * toolbar = [[self window] toolbar];
	NSString * key = [NSString stringWithFormat:@"NSToolbar Configuration %@", [toolbar identifier]];
	[self takeContextValue:[toolbar configurationDictionary] forKey:key domain:iTM2ContextAllDomainsMask];
//iTM2_START;
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
		toolbarItem = [[[NSToolbarItem alloc] initWithItemIdentifier:itemIdent] autorelease];
		[toolbarItem setLabel:
            NSLocalizedStringFromTableInBundle([itemIdent stringByAppendingString:@"Label"], @"Toolbar", myBUNDLE, "")];
		[toolbarItem setPaletteLabel:
            NSLocalizedStringFromTableInBundle([itemIdent stringByAppendingString:@"PaletteLabel"], @"Toolbar", myBUNDLE, "")];
		[toolbarItem setToolTip:
            NSLocalizedStringFromTableInBundle([itemIdent stringByAppendingString:@"ToolTip"], @"Toolbar", myBUNDLE, "")];
		NSControl * F = [self backForwardControl];
		[toolbarItem setView:F];
		[toolbarItem setMinSize:[F frame].size];
		[toolbarItem setMaxSize:[F frame].size];
		[F setAction:action];
		if([self respondsToSelector:action])
			[F setTarget:self];
		else if([[self PDFView] respondsToSelector:action])
			[F setTarget:[self PDFView]];
		else
			[F setTarget:nil];
		if(willBeInserted)
			[IMPLEMENTATION takeMetaValue:F forKey:@"toolbar back forward"];
	}
	else if(action == @selector(takeToolModeFromSegment:))
	{
		if(willBeInserted && [IMPLEMENTATION metaValueForKey:@"toolbar select tool mode"])
			return nil;
		toolbarItem = [[[NSToolbarItem alloc] initWithItemIdentifier:itemIdent] autorelease];
		[toolbarItem setLabel:
            NSLocalizedStringFromTableInBundle([itemIdent stringByAppendingString:@"Label"], @"Toolbar", myBUNDLE, "")];
		[toolbarItem setPaletteLabel:
            NSLocalizedStringFromTableInBundle([itemIdent stringByAppendingString:@"PaletteLabel"], @"Toolbar", myBUNDLE, "")];
		[toolbarItem setToolTip:
            NSLocalizedStringFromTableInBundle([itemIdent stringByAppendingString:@"ToolTip"], @"Toolbar", myBUNDLE, "")];
		NSControl * F = [self toolModeControl];
		[toolbarItem setView:F];
		[toolbarItem setMinSize:[F frame].size];
		[toolbarItem setMaxSize:[F frame].size];
		[F setAction:action];
		if([self respondsToSelector:action])
			[F setTarget:self];
		else if([[self PDFView] respondsToSelector:action])
			[F setTarget:[self PDFView]];
		else
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
			[F setFloatValue:[[self PDFView] scaleFactor]];
		}
		[F setFrameSize:NSMakeSize([[NF stringForObjectValue:[NSNumber numberWithFloat:[F floatValue]]]
						sizeWithAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
								[[F cell] font], NSFontAttributeName, nil]].width+8, 22)];
		[F setTag:421];
		toolbarItem = [[[NSToolbarItem alloc] initWithItemIdentifier:itemIdent] autorelease];
		[toolbarItem setLabel:
            NSLocalizedStringFromTableInBundle([itemIdent stringByAppendingString:@"Label"], @"Toolbar", myBUNDLE, "")];
		[toolbarItem setPaletteLabel:
            NSLocalizedStringFromTableInBundle([itemIdent stringByAppendingString:@"PaletteLabel"], @"Toolbar", myBUNDLE, "")];
		[toolbarItem setToolTip:
            NSLocalizedStringFromTableInBundle([itemIdent stringByAppendingString:@"ToolTip"], @"Toolbar", myBUNDLE, "")];
		[toolbarItem setView:F];
		[toolbarItem setMinSize:[F frame].size];
		[toolbarItem setMaxSize:[F frame].size];
		[F setAction:action];
		if([self respondsToSelector:action])
			[F setTarget:self];
		else if([[self PDFView] respondsToSelector:action])
			[F setTarget:[self PDFView]];
		else
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
			PDFPage * page = [[self PDFView] currentPage];
			PDFDocument * document = [page document];
			unsigned int pageCount = [document indexForPage:page];
			[F setIntValue:pageCount+1];
			pageCount = [document pageCount];
			[NF setMaximum:[NSNumber numberWithInt:pageCount]];
		}
		else
			[F setStringValue:@"421"];
		[F setTag:421];
		toolbarItem = [[[NSToolbarItem alloc] initWithItemIdentifier:itemIdent] autorelease];
		[toolbarItem setLabel:
            NSLocalizedStringFromTableInBundle([itemIdent stringByAppendingString:@"Label"], @"Toolbar", myBUNDLE, "")];
		[toolbarItem setPaletteLabel:
            NSLocalizedStringFromTableInBundle([itemIdent stringByAppendingString:@"PaletteLabel"], @"Toolbar", myBUNDLE, "")];
		[toolbarItem setToolTip:
            NSLocalizedStringFromTableInBundle([itemIdent stringByAppendingString:@"ToolTip"], @"Toolbar", myBUNDLE, "")];
		[toolbarItem setView:F];
		[toolbarItem setMinSize:[F frame].size];
		[toolbarItem setMaxSize:[F frame].size];
		[F setAction:action];
		if([self respondsToSelector:action])
			[F setTarget:self];
		else if([[self PDFView] respondsToSelector:action])
			[F setTarget:[self PDFView]];
		else
			[F setTarget:nil];
		if(willBeInserted)
			[IMPLEMENTATION takeMetaValue:F forKey:@"toolbar page field"];
	}
	else if(action)
	{
		toolbarItem = [[[NSToolbarItem alloc] initWithItemIdentifier:itemIdent] autorelease];
		[toolbarItem setLabel:
            NSLocalizedStringFromTableInBundle([itemIdent stringByAppendingString:@"Label"], @"Toolbar", myBUNDLE, "")];
		[toolbarItem setPaletteLabel:
            NSLocalizedStringFromTableInBundle([itemIdent stringByAppendingString:@"PaletteLabel"], @"Toolbar", myBUNDLE, "")];
		[toolbarItem setToolTip:
            NSLocalizedStringFromTableInBundle([itemIdent stringByAppendingString:@"ToolTip"], @"Toolbar", myBUNDLE, "")];
		NSString * imageName = [itemIdent stringByAppendingString:@"ToolbarImage"];
		NSString * imagePath = [myBUNDLE pathForImageResource:imageName];
		NSString * name = [NSString stringWithFormat:@"iTM2:%@",itemIdent]
		NSImage * I = [NSImage imageNamed:name];
		if(!I)
		{
			I = [[NSImage allocWithZone:[self zone]] initWithContentsOfFile:itemIdent];
			[I setName:name];
		}
		[toolbarItem setImage:I];
		[toolbarItem setAction:action];
		if([self respondsToSelector:action])
			[toolbarItem setTarget:self];
		else if([[self PDFView] respondsToSelector:action])
			[toolbarItem setTarget:[self PDFView]];
		else
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
    // If during the toolbar's initialization, no overriding values are found in the user defaultsModel, or if the
    // user chooses to revert to the default items this set will be used 
//iTM2_END;
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
    // Required delegate method:  Returns the list of all allowed items by identifier.  By default, the toolbar 
    // does not assume any items are allowed, even the separator.  So, every allowed item must be explicitly listed   
    // The set of allowed items is used to construct the customization palette 
//iTM2_END;
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
	PDFPage * currentPage = [[self PDFView] currentPage];
	int rotation = [currentPage rotation];
	rotation -= 90;
	[currentPage setRotation:rotation];
	[[self PDFView] setNeedsDisplay:YES];
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
	PDFPage * currentPage = [[self PDFView] currentPage];
	int rotation = [currentPage rotation];
	rotation += 90;
	[currentPage setRotation:rotation];
	[[self PDFView] setNeedsDisplay:YES];
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
	PDFPage * page = [[self PDFView] currentPage];
	PDFDocument * document = [page document];
	unsigned int pageCount = [document pageCount];
	if(n<pageCount)
		[[self PDFView] goToPage:[document pageAtIndex:n]];
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
	PDFPage * page = [[self PDFView] currentPage];
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
    [[self PDFView] setScaleFactor:newScale];
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
	[sender setFloatValue:[[self PDFView] scaleFactor]];
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
		[[self PDFView] goForward:sender];
	}
	else
	{
		[[self PDFView] goBack:sender];
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
	BOOL isEnabled = NO;
	if([[self PDFView] canGoBack])
	{
		[sender setEnabled:YES forSegment:0];
		isEnabled = YES;
	}
	else
		[sender setEnabled:NO forSegment:0];
	if([[self PDFView] canGoForward])
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
	[self setToolMode:[[sender cell] tagForSegment:[sender selectedSegment]]];
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
	if(![sender selectSegmentWithTag:[self toolMode]])
	{
		[self setToolMode:kiTM2ScrollToolMode];
		[sender selectSegmentWithTag:[self toolMode]];
	}
	int segment = [sender segmentCount];
	while(segment--)
	{
		[sender setEnabled:([[sender cell] tagForSegment:segment] != kiTM2AnnotateToolMode) forSegment:segment];
	}
	[sender setEnabled:YES];
//iTM2_END;
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self moveToBeginningOfLine:sender];// this is because the Preview menu already has ⌘← shortcut
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= validateDoGoToPreviousPage:
- (BOOL)validateDoGoToPreviousPage:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Jan 19 23:19:59 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	return YES;
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
	[self moveToEndOfLine:sender];// this is because the Preview menu already has ⌘→ shortcut
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= validateDoGoToNextPage:
- (BOOL)validateDoGoToNextPage:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Jan 19 23:19:59 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	return YES;
}
@end

#warning the iTM2RenderCenter is changed too...
#warning missing implementation of the tex project document revertToSaved: and saveDocumentAs:, saveDocumentTo:
#warning the ghost window for the project should not accept 1st responder status...
