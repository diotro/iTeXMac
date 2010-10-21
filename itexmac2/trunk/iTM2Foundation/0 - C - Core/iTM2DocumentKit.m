/*
//
//  @version Subversion: $Id: iTM2DocumentKit.m 799 2009-10-13 16:46:39Z jlaurens $ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Fri Sep 05 2003.
//  Copyright © 2003 Laurens'Tribune. All rights reserved.
//
//  This program is free software; you can redistribute it and/or modify it under the terms
//  of the GNU General Public License as published by the Free Software Foundation; either
//  version 2 of the License, or any later version, modified by the addendum below.
//  This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
//  without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
//  See the GNU General Public License for more details. You should have received a copy
//  of the GNU General Public License along with this program; if not, write to the Free Software
//  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
//  GPL addendum:Any simple modification of the present code which purpose is to remove bug,
//  improve efficiency in both code execution and code reading or writing should be addressed
//  to the actual developper team.
//
//  Version history: (format "- date:contribution(contributor)") 
//  To Do List:(format "- proposition(percentage actually done)")
*/

#import <stdio.h>
#import <objc/objc-class.h>
#import "iTM2PathUtilities.h"
#import "iTM2NotificationKit.h"
#import "iTM2InstallationKit.h"
#import "iTM2Runtime.h"
#import "iTM2Invocation.h"
#import "iTM2Implementation.h"
#import "iTM2ObjectServer.h"
#import "iTM2BundleKit.h"
#import "iTM2FileManagerKit.h"

#import "iTM2ValidationKit.h"
#import "iTM2ImageKit.h"
#import "iTM2WindowKit.h"
#import "iTM2ResponderKit.h"

#import "iTM2UserDefaultsKit.h"
#import "iTM2ContextKit.h"
#import "iTM2DocumentKit.h"

NSString * const iTM2UDKeepBackupFileKey = @"iTM2KeepBackupFile";

NSString * const iTM2VoidInspectorType = @"VOID";
NSString * const iTM2DefaultInspectorType = @"Default Type";
NSString * const iTM2DefaultInspectorMode = @"Default Mode";
NSString * const iTM2DefaultInspectorVariant = @"Default Variant";
NSString * const iTM2ContextOpenInspectors = @"Open Inspectors";
NSString * const iTM2ContextInspectorVariants = @"Inspector Variants";
NSString * const iTM2SUDInspectorVariants = @"iTM2: Inspector Variants";

NSString * const iTM2InspectorTable = @"Inspector";

#define TABLE @"iTM2DocumentKit"
#define BUNDLE [iTM2Document classBundle]

@implementation NSDocument(iTeXMac2)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inspectorType
+ (NSString *)inspectorType;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return iTM2VoidInspectorType;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  prettyInspectorType
+ (NSString *)prettyInspectorType;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return NSLocalizedStringFromTableInBundle([self inspectorType], iTM2InspectorTable, [self classBundle], "pretty inspector type");
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
    return [self fileName];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  smartClose
- (void)smartClose;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//	iTM2_START_TRACKING;
    [self canCloseDocumentWithDelegate:self shouldCloseSelector:@selector(document:shouldSmartClose:a0213:) contextInfo:nil];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  documentWillClose
- (void)documentWillClose;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSMethodSignature * sig0 = [self methodSignatureForSelector:_cmd];
    NSInvocation * I = [NSInvocation invocationWithMethodSignature:sig0];
    [I setTarget:self];
	[I iTM2_invokeWithSelectors:[iTM2Runtime instanceSelectorsOfClass:isa withSuffix:@"CompleteWillClose" signature:sig0 inherited:YES]];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  documentDidClose
- (void)documentDidClose;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSMethodSignature * sig0 = [self methodSignatureForSelector:_cmd];
    NSInvocation * I = [NSInvocation invocationWithMethodSignature:sig0];
    [I setTarget:self];
    [I iTM2_invokeWithSelectors:[iTM2Runtime instanceSelectorsOfClass:isa withSuffix:@"CompleteDidClose" signature:sig0 inherited:YES]];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  document:shouldSmartClose:a0213:
- (void)document:(NSDocument *) doc shouldSmartClose:(BOOL) shouldClose a0213:(void *) irrelevant;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Feb 20 13:19:00 GMT 2004perform
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(shouldClose)
	{
		[self documentWillClose];
		[self close];
		[self documentDidClose];
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  cannotCloseWithNoFileImage
- (BOOL)cannotCloseWithNoFileImage;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return YES;
}
- (void)iTM2_template_selector_document:(NSDocument *)document shouldClose:(BOOL)shouldClose contextInfo:(void *)contextInfo;
{
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  SWZ_iTM2_canCloseDocumentWithDelegate:shouldCloseSelector:contextInfo:
- (void)SWZ_iTM2_canCloseDocumentWithDelegate:(id)delegate shouldCloseSelector:(SEL)shouldCloseSelector contextInfo:(void *)contextInfo;
    // If the document is not dirty, this method will immediately call the callback with YES.  If the document is dirty, an alert will be presented giving the user a chance to save, not save or cancel.  If the user chooses to save, this method will save the document.  If the save completes successfully, this method will call the callback with YES.  If the save is cancelled or otherwise unsuccessful, this method will call the callback with NO.  This method is called by shouldCloseWindowController:sometimes.  It is also called by NSDocumentController's -closeAllDocuments.  You should call it before you call -close if you are closing the document and want to give the user a chance save any edits.
    // shouldCloseSelector should have the following signature:
    // - (void)document:(NSDocument *)doc shouldClose:(BOOL)shouldClose contextInfo:(void *)contextInfo
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([delegate respondsToSelector:shouldCloseSelector]) {
		
	}
	NSMethodSignature * MS = [delegate methodSignatureForSelector:shouldCloseSelector];
	if(MS)
	{
		NSInvocation * I;
		[[NSInvocation iTM2_getInvocation:&I withTarget:self retainArguments:NO]
			 iTM2_template_selector_document:self shouldClose:NO contextInfo:contextInfo];
		if([MS isEqual:[I methodSignature]])
		{
			[I setTarget:delegate];
			[self SWZ_iTM2_canCloseDocumentWithDelegate:self shouldCloseSelector:@selector(iTM2_document:forwardShouldClose:toInvocation:) contextInfo:(void *)I];
		}
		return;
	}
	[self SWZ_iTM2_canCloseDocumentWithDelegate:delegate shouldCloseSelector:shouldCloseSelector contextInfo:contextInfo];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2_document:forwardShouldClose:toInvocation:
- (void)iTM2_document:(NSDocument *) doc forwardShouldClose:(BOOL) shouldClose toInvocation:(id) invocation;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Feb 20 13:19:00 GMT 2004perform
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[invocation autorelease];
	[invocation setArgument:&shouldClose atIndex:3];
	if(shouldClose && ![self cannotCloseWithNoFileImage] && [[self fileName] length] && ![DFM fileExistsAtPath:[self fileName]])
	{
		NSBeginAlertSheet(
			NSLocalizedStringFromTableInBundle(@"Warning", TABLE, BUNDLE, ""),
			NSLocalizedStringFromTableInBundle(@"Save", TABLE, BUNDLE, nil),
			NSLocalizedStringFromTableInBundle(@"Ignore", TABLE, BUNDLE, nil),
			nil,
			[self frontWindow],
			self,
			NULL,
			@selector(_noFileSheetDidDismiss:returnCode:invocation:),
			[invocation retain],
			NSLocalizedStringFromTableInBundle(@"No file at %@", TABLE, BUNDLE,
        "Missing file at the given path?"),
			[self fileName]);
		return;
	}
//iTM2_LOG(@"----    invocation is:%@", invocation);
//iTM2_LOG(@"----    [invocation target] is:%@", [invocation target]);
	[invocation invoke];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  _noFileSheetDidDismiss:returnCode:invocation:
- (void)_noFileSheetDidDismiss:(NSWindow *) unused returnCode:(int) returnCode invocation:(NSInvocation *) invocation;
/*"Private use only. Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1:03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[invocation autorelease];
    if(returnCode == NSOKButton)
    {
        [self writeToURL:[self fileURL] ofType:[self fileType] error:nil];
    }
	[invocation invoke];
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  modelTypeForFileType:
- (NSString *)modelTypeForFileType:(NSString *) fileType;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return fileType;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  modelType
- (NSString *)modelType;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return [self modelTypeForFileType:[self fileType]];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  frontWindow
- (id)frontWindow;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    for(NSWindow * W in [NSApp orderedWindows])
    {
        NSWindowController * WC = [W windowController];
		NSDocument * D = [WC document];
		NSString * WCType = [[WC class] inspectorType];
		NSString * DType = [[D class] inspectorType];
        if((D == self) && [WCType isEqual:DType])
		{
            return W;
		}
    }
    // lazy initializer here?
    return nil;
}
#pragma mark =-=-=-=-=-   UPDATE
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= needsToUpdate
- (BOOL)needsToUpdate;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Jan 18 22:21:11 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSDate * oldMD = [self fileModificationDate];
    NSDate * newMD = [[DFM iTM2_attributesOfItemOrDestinationOfSymbolicLinkAtPath:[self fileName] error:NULL] fileModificationDate];
	BOOL result = [newMD compare:oldMD] == NSOrderedDescending;
	if(result && (iTM2DebugEnabled>999))
	{
		iTM2_LOG(@"oldMD:%@ < newMD:%@", oldMD, newMD);
	}
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2_recordFileModificationDateFromURL:
- (void)iTM2_recordFileModificationDateFromURL:(NSURL *)absoluteURL;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Jan 18 22:21:11 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(![absoluteURL isFileURL])
	{
		return;
	}
	NSString * path = [absoluteURL path];
	NSDictionary * attributes = [DFM iTM2_attributesOfItemOrDestinationOfSymbolicLinkAtPath:path error:NULL];
	NSDate * date = [attributes fileModificationDate];
//iTM2_LOG(@"path is:%@ date:%@",path,date);
	if(date)
	{
		[self setFileModificationDate:date];
		if([self needsToUpdate])
		{
			iTM2_LOG(@"****  ERROR:THERE IS AN INCONSISTENCY... please report light bug");
		}
	}
//iTM2_LOG(@"%@ should be %@ should be %@", [self fileModificationDate], [[DFM iTM2_attributesOfItemOrDestinationOfSymbolicLinkAtPath:fileName error:NULL] fileModificationDate], [[self implementation] metaValueForKey:@"LastFileModificationDate"]);
	return;
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
    return;
}
#pragma mark =-=-=-=-=-   CONTAINER
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  childDocumentForFileName:
- (id)childDocumentForFileName:(NSString *)fileName;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  childDocumentForURL:
- (id)childDocumentForURL:(NSURL *)url;
/*"Subclasses will most certainly override this method.
Default implementation returns nil.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6:03/26/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return nil;
}
#pragma mark =-=-=-=-=-   CONTEXT
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  currentContextManager
- (id)currentContextManager;
/*"Subclasses will most certainly override this method.
Default implementation returns the NSUserDefaults shared instance.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6:03/26/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= contextDictionaryFromURL:
+ (id)contextDictionaryFromURL:(NSURL *) fileURL;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(![fileURL isFileURL])
	{
		return nil;
	}
	NSDictionary * attributes = [DFM iTM2_extendedFileAttributesInSpace:[NSNumber numberWithUnsignedInt:'iTM2'] atPath:[fileURL path] error:nil];
//	if(!D)
//		D = [DFM iTM2_extendedFileAttributesAtPath:fullDocumentPath forNameSpace:@"org_tug_mac_iTM20" error:nil];
	NSMutableDictionary * MD = [NSMutableDictionary dictionary];
	for(NSString * key in [attributes keyEnumerator])
	{
		NS_DURING
		id O = [NSUnarchiver unarchiveObjectWithData:[attributes objectForKey:key]];
		if(O)
			[MD setObject:O forKey:key];
		NS_HANDLER
		[NSApp reportException:localException];
		NS_ENDHANDLER
	}
//iTM2_END;
	return [[MD copy] autorelease];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= printInfoCompleteReadFromURL:ofType:error:
- (BOOL)printInfoCompleteReadFromURL:(NSURL *) fileURL ofType:(NSString *) type error:(NSError**)outErrorPtr;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * fullDocumentPath = [fileURL path];
	NSData * D = [self contextValueForKey:@"NSPrintInfo" domain:iTM2ContextAllDomainsMask];
	if(!D)
		D = [DFM iTM2_extendedFileAttribute:@"NSPrintInfo" inSpace:[NSNumber numberWithUnsignedInt:'TUG0'] atPath:fullDocumentPath error:nil];
//	if(!D)
//		D = [DFM iTM2_extendedFileAttribute:@"NSPrintInfo" atPath:fullDocumentPath forNameSpace:@"org_tug_mac_cocoa" error:nil];
	if(!D)
		return YES;
	NSDictionary * dictionary = [NSUnarchiver unarchiveObjectWithData:D];
	if([dictionary isKindOfClass:[NSDictionary class]])
	{
		BOOL wasUndoing = [[self undoManager] isUndoRegistrationEnabled];
		[[self undoManager] disableUndoRegistration];
		[self setPrintInfo:[[[NSPrintInfo alloc] initWithDictionary:dictionary] autorelease]];
		if(wasUndoing)
			[[self undoManager] enableUndoRegistration];
	}
	else
	{
		iTM2_LOG(@"WARNING:Dictionary expected, got %@", dictionary);
	}
//iTM2_END;
    return YES;// even if the resources could not be saved...
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  preparePrintInfoCompleteWriteToURL:ofType:error:
- (BOOL)preparePrintInfoCompleteWriteToURL:(NSURL *) fileURL ofType:(NSString *) type error:(NSError**)error;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * fileName = [fileURL path];
	NSData * D = [NSArchiver archivedDataWithRootObject:[[self printInfo] dictionary]];
	if(D)
	{
		[self takeContextValue:D forKey:@"Print Info Data" domain:iTM2ContextAllDomainsMask];
		[DFM iTM2_addExtendedFileAttribute:@"NSPrintInfo" value:D inSpace:[NSNumber numberWithUnsignedInt:'TUG0'] atPath:fileName error:nil];
//		[DFM iTM2_addExtendedFileAttribute:@"NSPrintInfo" value:D atPath:fileName forNameSpace:@"org_tug_mac_cocoa" error:nil];
	}
//iTM2_END;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  openInspectorsCompleteSaveContext:
- (void)openInspectorsCompleteSaveContext:(id) irrelevant;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSMutableArray * windows = [NSMutableArray arrayWithArray:[NSApp windows]];
    NSMutableArray * openInspectors = [NSMutableArray array];
    [windows sortUsingSelector:@selector(iTM2_compareUsingLevel:)];
    NSWindow * W;
    for(W in windows)
        if([W isVisible])
        {
            NSWindowController * WC = [W windowController];
            if(self == [WC document])
            {
                Class C = [WC class];
				NSString * mode = [C inspectorMode];
				if(![mode hasPrefix:@"."])
					[openInspectors addObject:[NSDictionary dictionaryWithObjectsAndKeys:[C inspectorType], @"type", mode, @"mode", [WC inspectorVariant], @"variant", nil]];
            }
        }
	if([openInspectors count])
	{
		[self takeContextValue:openInspectors forKey:iTM2ContextOpenInspectors domain:iTM2ContextStandardLocalMask|iTM2ContextExtendedMask];
	}
//iTM2_LOG(@"openInspectors (%@) are:%@ = %@", [self fileName], openInspectors, [self contextValueForKey:iTM2ContextOpenInspectors]);
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  saveContext:
- (void)saveContext:(id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[super saveContext:sender];
	if([self contextManager] == self)
	{
		NSURL * url = [self fileURL];
		NSString * type = [self fileType];
		if([self needsToUpdate])
		{
			[self writeContextToURL:url ofType:type error:nil];
		}
		else
		{
			[self writeContextToURL:url ofType:type error:nil];
			[self iTM2_recordFileModificationDateFromURL:url];
		}
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= readContextFromURL:ofType:error:
- (BOOL)readContextFromURL:(NSURL *)absoluteURL ofType:(NSString *) type error:(NSError **)outErrorPtr;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([self contextManager] == self)
	{
		NSDictionary * attributes = [DFM iTM2_extendedFileAttributesInSpace:[NSNumber numberWithUnsignedInt:'iTM2'] atPath:[absoluteURL path] error:nil];
		NSEnumerator * E = [attributes keyEnumerator];
		NSString * key;
		while(key = [E nextObject])
		{
			NS_DURING
			id O = [NSUnarchiver unarchiveObjectWithData:[attributes objectForKey:key]];
			if(O)
				[[self contextDictionary] setObject:O forKey:key];
			else
				[[self contextDictionary] removeObjectForKey:key];
			NS_HANDLER
			[NSApp reportException:localException];
			NS_ENDHANDLER
		}
//iTM2_LOG(@"[self contextDictionary] is:%@", [self contextDictionary]);
	}
//iTM2_END;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= writeContextToURL:ofType:error:
- (BOOL)writeContextToURL:(NSURL *)absoluteURL ofType:(NSString *)type error:(NSError **)outErrorPtr;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(![absoluteURL isFileURL])
	{
		return NO;
	}
	NSDictionary * contextDictionary = [self contextDictionary];
//iTM2_LOG(@"contextDictionary is:%@", contextDictionary);
	if([contextDictionary count])
	{
		NSMutableDictionary * attributes = [NSMutableDictionary dictionary];
		NSEnumerator * E = [contextDictionary keyEnumerator];
		NSString * key;
		while(key = [E nextObject])
		{
			NS_DURING
			[attributes setObject:[NSArchiver archivedDataWithRootObject:[contextDictionary objectForKey:key]] forKey:key];
			NS_HANDLER
			[NSApp reportException:localException];
			NS_ENDHANDLER
		}
//		BOOL needsToUpdate = [self needsToUpdate];
		[DFM iTM2_changeExtendedFileAttributes:[[attributes copy] autorelease] inSpace:[NSNumber numberWithUnsignedInt:'iTM2'] atPath:[absoluteURL path] error:nil];
//		[DFM iTM2_changeExtendedFileAttributes:[[attributes copy] autorelease] atPath:fullDocumentPath forNameSpace:@"org_tug_mac_iTM2" error:nil];
	}
//iTM2_END;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  showWindowsBelowFront
- (void)showWindowsBelowFront:(id)sender;
/*"Description Forthcoming.
Version History: Originally created by JL.
To do list:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[[self windowControllers] makeObjectsPerformSelector:@selector(showWindowBelowFront:) withObject:sender];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  environmentForExternalHelper
- (NSDictionary *)environmentForExternalHelper;
/*"Description Forthcoming.
Version History: Originally created by JL.
To do list:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return nil;
}
#pragma mark =-=-=-=-=-  URLs
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  absoluteFileURL
- (NSURL *)absoluteFileURL;
/*"Description Forthcoming.
Version History: Originally created by JL.
To do list:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return [[self fileURL] absoluteURL];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  originalFileURL
- (NSURL *)originalFileURL;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [self absoluteFileURL];
}
@end

@interface iTM2Document(PRIVATE)
- (void)document:(id) document didSave:(BOOL) flag inspectorContextInfo:(NSDictionary *) contextInfo;
@end
@interface NSObject(PRIVATE)
- (NSString *)contextDictionaryPath;
@end
@interface iTM2ExternalInspectorServer:iTM2ObjectServer
@end

NSString * const iTM2DFileAttributesKey = @"_FileAttributes";

@implementation iTM2Document
static NSMutableDictionary * _iTM2GetResourceSelectors = nil;
static NSMutableDictionary * _iTM2SetResourceSelectors = nil;
static NSMutableArray * _iTM2LoadExtendedAttributesSelectors = nil;
static NSMutableArray * _iTM2GetExtendedAttributesSelectors = nil;
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initialize
+ (void)initialize;
/*"Description Forthcoming.
Version History: Originally created by JL.
To do list:
"*/
{iTM2_DIAGNOSTIC;
	iTM2_INIT_POOL;
//iTM2_START;
    [super initialize];
    [SUD registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithBool:NO], iTM2UDKeepBackupFileKey,
                nil]];
    if(!_iTM2GetResourceSelectors)
        _iTM2GetResourceSelectors = [[NSMutableDictionary dictionary] retain];
    if(!_iTM2SetResourceSelectors)
        _iTM2SetResourceSelectors = [[NSMutableDictionary dictionary] retain];
    if(!_iTM2LoadExtendedAttributesSelectors)
        _iTM2LoadExtendedAttributesSelectors = [[NSMutableArray array] retain];
    if(!_iTM2GetExtendedAttributesSelectors)
        _iTM2GetExtendedAttributesSelectors = [[NSMutableArray array] retain];
	iTM2_RELEASE_POOL;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  init
- (id)init;
/*"Designated intializer.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(self = [super init])
    {
        [self setUndoManager:[[[iTM2UndoManager alloc] init] autorelease]];
        [[self undoManager] setLevelsOfUndo:[SUD integerForKey:iTM2UDLevelsOfUndoKey]];
        [INC addObserver:self
            selector:@selector(userDefaultsDidChange:)
                name:iTM2UserDefaultsDidChangeNotification
                    object:SUD];
        [self userDefaultsDidChange:[NSNotification notificationWithName:iTM2UserDefaultsDidChangeNotification
                    object:SUD]];
        [self initImplementation];
        [IMPLEMENTATION updateChildren];
    }
    return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  userDefaultsDidChange:
- (void)userDefaultsDidChange:(NSNotification *) notification;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return;
}
NSString * const iTM2DKDirectoryNameKey = @"directoryName";
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setFileURL:
- (void)setFileURL:(NSURL *) url;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (08/29/2001):
- 1.3:03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[super setFileURL:url];
	if(iTM2DebugEnabled)
	{
		iTM2_LOG(@"The new file url is:%@", url);
	}
	[self updateContextManager];
    for(NSWindowController * WC in [self windowControllers])
        [[WC window] iTM2_validateContent];
    [IMPLEMENTATION takeMetaValue:nil forKey:iTM2DKDirectoryNameKey];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  directoryName
- (NSString *)directoryName;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (08/29/2001):
- 1.3:03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSString * result = [IMPLEMENTATION metaValueForKey:iTM2DKDirectoryNameKey];
    if(!result)
    {
        [IMPLEMENTATION takeMetaValue:[[self fileName] stringByDeletingLastPathComponent] forKey:@"directoryName"];
        result = [IMPLEMENTATION metaValueForKey:iTM2DKDirectoryNameKey];
    }
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= fileAttributes
- (NSDictionary *)fileAttributes;
/*"Description forthcoming."*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [IMPLEMENTATION metaValueForKey:iTM2DFileAttributesKey];
}
#pragma mark =-=-=-=-=-=-=-=  MODEL OBJECT
@synthesize implementation=iVarImplementation;
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  isDocumentEdited
- (BOOL)isDocumentEdited;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed 05 mar 03
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if([super isDocumentEdited])
        return YES;
    NSEnumerator * E = [[self windowControllers] objectEnumerator];
    id WC;
    while(WC = [E nextObject])
        if([WC isInspectorEdited])
            return YES;
    return NO;
}
NSString * const iTM2PrivateContextInfoPrefix = @"_iTM2:";
#pragma mark =-=-=-=-=-=-=-=  USER INTERFACE
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inspectorAddedWithMode:
- (id)inspectorAddedWithMode:(NSString *) mode;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	return [self inspectorAddedWithMode:mode error:nil];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inspectorAddedWithMode:error:
- (id)inspectorAddedWithMode:(NSString *) mode error:(NSError**)outErrorPtr;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(!mode)
    {
        iTM2_LOG(@"No mode given");
        return nil;
    }
    NSEnumerator * e = [[self windowControllers] objectEnumerator];
    NSWindowController * WC;
    while(WC = [e nextObject])
	{
        if([[[WC class] inspectorMode] isEqual:mode])
		{
            return WC;
		}
	}
    NSMutableDictionary * MD = (NSMutableDictionary *)[[[self contextDictionaryForKey:iTM2ContextInspectorVariants domain:iTM2ContextAllDomainsMask] mutableCopy] autorelease];
    if(!MD)
    {
        MD = [NSMutableDictionary dictionary];
        [self takeContextValue:MD forKey:iTM2ContextInspectorVariants domain:iTM2ContextAllDomainsMask];
    }
    NSString * type = [[self class] inspectorType];
    NSArray * variants = [MD objectForKey:mode];
    Class C = Nil;
    if([variants isKindOfClass:[NSArray class]])
    {
        e = [variants objectEnumerator];
        NSString * variant;
        while(variant = [e nextObject])
        {
            if(C = [NSWindowController inspectorClassForType:type mode:mode variant:variant])
            {
                WC = [[[C alloc] initWithWindowNibName:[C windowNibName]] autorelease];
				[WC setInspectorVariant:variant];
                [self addWindowController:WC];
                if([WC window])
				{
                    return WC;
				}
                else
				{
                    [self removeWindowController:WC];
				}
            }
			else
			{
				iTM2_LOG(@"%@",[NSString stringWithFormat:@"Unknown inspector type:\n%@\nfor mode:\n%@\nfor variants:\n%@", type, mode,variants]);
			}
        }
    }
    [MD removeObjectForKey:mode];
    [self takeContextValue:MD forKey:iTM2ContextInspectorVariants domain:iTM2ContextAllDomainsMask];
    if(C = [NSWindowController inspectorClassForType:type mode:mode variant:iTM2DefaultInspectorVariant])
    {
        WC = [[[C alloc] initWithWindowNibName:[C windowNibName]] autorelease];
        [self addWindowController:WC];
		[WC setInspectorVariant:iTM2DefaultInspectorVariant];
        if([WC window])
		{
            return WC;
		}
        else
		{
            [self removeWindowController:WC];
		}
    }
	NSArray * inspectorClasses = [NSWindowController inspectorClassesForType:type mode:mode];
    if([inspectorClasses count] && (C = [inspectorClasses objectAtIndex:0]))
    {
        WC = [[[C alloc] initWithWindowNibName:[C windowNibName]] autorelease];
        [self addWindowController:WC];
		[WC setInspectorVariant:[C inspectorVariant]];
        if([WC window])
		{
            return WC;
		}
        else
		{
            [self removeWindowController:WC];
		}
    }
//iTM2_LOG(@"NO INSPECTOR for type %@ mode:%@", type, mode);
    return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  replaceInspectorMode:variant:
- (void)replaceInspectorMode:(NSString *) mode variant:(NSString *) variant;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Jan  4 09:17:42 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSWindow * W = [self frontWindow];
	NSWindowController * currentWC = [W windowController];
	currentWC = [[currentWC retain] autorelease];
	if(currentWC)
	{
		if([[[currentWC class] inspectorMode] isEqual:mode]
				&& [[currentWC inspectorVariant] isEqual:variant])
		{
			if(iTM2DebugEnabled)
			{
				iTM2_LOG(@"The inspector mode and variant are already in place:%@, %@", mode, variant);
			}
			return;
		}
		if([currentWC isWindowLoaded])
		{
			[[currentWC window] orderOut:self];
		}
		if(iTM2DebugEnabled)
		{
			iTM2_LOG(@"Removing the window controller:%@", currentWC);
		}
		[self removeWindowController:currentWC];
	}
    Class C = Nil;
	NSString * type = [isa inspectorType];
	if([mode isEqual:iTM2ExternalInspectorMode])
	{
		if([iTM2ExternalInspectorServer objectForType:type key:variant])
		{
			C = [iTM2ExternalInspector class];
		}
	}
	else
	{
		C = [NSWindowController inspectorClassForType:type mode:mode variant:variant];
	}
	if(C == [currentWC class])
	{
		// no change
		return;
	}
	else if(C)
	{
		// first add a new window controller to prevent closeIfNeeded to close the project document
#warning BUG, the closeIfNeeded does not seem to close all the windows of the project, more...
// when I first removed the old WC, closeIfNeeded was called and the project document was closed
// Then the window menu was updated and there was still a window for that closed document
// of course, the document of that window was garbage, which caused an exception to be raised
		NSWindowController * WC = [[[C alloc] initWithWindowNibName:NSStringFromClass(C)] autorelease];
		[WC setInspectorVariant:variant];
        [self addWindowController:WC];
		NSWindow * W;
        if(W = [WC window])
        {
            [W makeKeyAndOrderFront:self];// now there is a visible window, the closeIfNeeded (sent when removing a window controller) will not close the project document
			// then remove the old WC
			if(iTM2DebugEnabled)
			{
				iTM2_LOG(@"Removing the window controller:%@", currentWC);
			}
			[self removeWindowController:currentWC];
			// remove the external inspectors... if necessary, WHY?
			NSEnumerator * E = [[self windowControllers] objectEnumerator];
			while(WC = [E nextObject])
			{
				if([WC isKindOfClass:[iTM2ExternalInspector class]])
				{
					[self removeWindowController:WC];
				}
			}
        }
        else
		{
			iTM2_LOG(@"No window for mode %@, and variant %@", mode, variant);
            [self removeWindowController:WC];
		}
    }
	else
	{
		iTM2_LOG(@"No inspector class found for mode %@, and variant %@", mode, variant);
	}
	// just in case, things did not work properly
	if(![[self windowControllers] count] && currentWC)
	{
		[self addWindowController:currentWC];
		[[currentWC window] orderFront:self];
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  addWindowController:
- (void)addWindowController:(NSWindowController *) WC;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(!WC)
        return;
    Class C = [WC class];
	#if 0
	THIS IS BUGGY DESIGN, REALLY
	THE WC IS EXPECTED TO BE RETAINED!!!
    if([C isInstanceUnique])
    {
        NSEnumerator * E = [[self windowControllers] objectEnumerator];
        id wc;
        while(wc = [E nextObject])
            if([wc class] == C)
                return;
    }
	#endif
    {
        NSEnumerator * E = [[self windowControllers] objectEnumerator];
        id wc;
        while(wc = [E nextObject])
            if([wc class] == C)
			{
				iTM2_LOG(@"THERE IS ALREADY A WINDOW CONTROLLER:new %@, old %@", WC, wc);
			}
    }
    [super addWindowController:WC];
	NSString * inspectorVariant = [C inspectorVariant];
	if(![inspectorVariant hasPrefix:@"."])
	{
		NSDictionary * D = [self contextDictionaryForKey:iTM2ContextInspectorVariants domain:iTM2ContextAllDomainsMask];
		if(!D)
			D = [NSDictionary dictionary];
		NSMutableDictionary * MD = [[D mutableCopy] autorelease];
		NSArray * RA = [MD objectForKey:[C inspectorMode]];
		if(!RA)
		{
			RA = [NSArray array];
		}
		NSMutableArray * MRA = [[RA mutableCopy] autorelease];
		[MRA removeObject:inspectorVariant];
		[MRA insertObject:inspectorVariant atIndex:0];
		[MD setObject:MRA forKey:[C inspectorMode]];
		[self takeContextValue:MD forKey:iTM2ContextInspectorVariants domain:iTM2ContextStandardLocalMask|iTM2ContextExtendedMask];
	}
	if(![WC isKindOfClass:[iTM2ExternalInspector class]])
		[self didAddWindowController:WC];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= didAddWindowController:
- (void)didAddWindowController:(id) WC;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[WC synchronizeWithDocument];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  removeWindowController:
- (void)removeWindowController:(NSWindowController *) windowController;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(windowController)
    {
		if([windowController isWindowLoaded])
			[[windowController window] orderOut:self];// don't performCloses:, it leads to an infinite loop...
        if(![windowController isKindOfClass:[iTM2ExternalInspector class]])
			[self willRemoveWindowController:windowController];
        [super removeWindowController:windowController];
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= willRemoveWindowController:
- (void)willRemoveWindowController:(id) WC;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  makeWindowControllers
- (void)makeWindowControllers;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSEnumerator * E = [[self windowControllers] objectEnumerator];
	NSWindowController * WC = nil;
	while(WC = [E nextObject])
	{
		if(![[[WC class] inspectorMode] hasPrefix:@"."])
			return;
	}
    NSArray * modes = [self contextValueForKey:iTM2ContextOpenInspectors domain:iTM2ContextAllDomainsMask];
    if([modes isKindOfClass:[NSArray class]])
    {
        NSDictionary * d;
		NSMutableArray * alreadyOpenModes = [NSMutableArray array];
		NSString * inspectorType = [[self class] inspectorType];
		NSString * fileName = [self fileName];
        for(d in modes)
        {
//iTM2_LOG(@"d is:%@", d);
			if(![alreadyOpenModes containsObject:d])
			{
				NSString * type = [d objectForKey:@"type"];
				NSString * mode = [d objectForKey:@"mode"];
				NSString * variant = [d objectForKey:@"variant"];
				if([type isEqual:inspectorType])
				{
					if([mode hasPrefix:@"."])
					{
						;// do nothing
					}
					else
					{
						Class C = [NSWindowController inspectorClassForType:type mode:mode variant:variant];
						WC = [[[C alloc] initWithWindowNibName:[C windowNibName]] autorelease];
						[WC setInspectorVariant:variant];
						[self addWindowController:WC];// 1ZT
						if(![WC window])// EXC_BAD_ACCESS HERE!!!
							[self removeWindowController:WC];
					}
				}
				else if([mode isEqual:iTM2ExternalInspectorMode]
					&& ([fileName length] > 0)
						&& [iTM2ExternalInspectorServer objectForType:inspectorType key:variant])
						// there is an external inspector for that type/variant pair
				{
					NSEnumerator * EE = [[self windowControllers] objectEnumerator];
					while(WC = [EE nextObject])
						if([WC isKindOfClass:[iTM2ExternalInspector class]])
							[self removeWindowController:WC];
					WC = [[[iTM2ExternalInspector alloc] initWithWindowNibName:@"iTM2ExternalInspector"] autorelease];
					[WC setInspectorVariant:variant];
					[self addWindowController:WC];
					if(![WC window])
						[self removeWindowController:WC];
				}
			}
			[alreadyOpenModes addObject:d];
		}
        if([[self windowControllers] count])
           return;
    }
    [self makeDefaultInspector];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  makeDefaultInspector
- (void)makeDefaultInspector;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(![[self windowControllers] count])
    {
        NSString * documentType = [[[self fileName] pathExtension] lowercaseString];
        NSDictionary * contextVariants = [self contextDictionaryForKey:iTM2ContextInspectorVariants domain:iTM2ContextAllDomainsMask];
        NSDictionary * D = [contextVariants objectForKey:documentType];
		NSString * inspectorMode = [D objectForKey:@"mode"];
		if(!inspectorMode)
		{
			NSDictionary * SUDVariants = [SUD dictionaryForKey:iTM2SUDInspectorVariants];
			D = [SUDVariants objectForKey:documentType];
			inspectorMode = [D objectForKey:@"mode"];
			if(!inspectorMode)
			{
				documentType = [self fileType];
				D = [contextVariants objectForKey:documentType];
				inspectorMode = [D objectForKey:@"mode"];
				if(!inspectorMode)
				{
					D = [SUDVariants objectForKey:documentType];
					inspectorMode = [D objectForKey:@"mode"];
					if(!inspectorMode)
					{
						goto here;
					}
				}
			}
		}
		if([inspectorMode hasPrefix:@"."])
		{
			goto here;
		}
		NSString * inspectorVariant = [D objectForKey:@"variant"];
		NSString * inspectorType = nil;
		if(![inspectorVariant hasPrefix:@"."])
		{
			inspectorType = [isa inspectorType];
			Class C = [NSWindowController inspectorClassForType:inspectorType mode:inspectorMode variant:inspectorVariant];
			if(C)
			{
				NSWindowController * WC = [[[C alloc] initWithWindowNibName:[C windowNibName]] autorelease];
				[self addWindowController:WC];
				NSWindow * W = [WC window];
				if(W)
				{
					return;
				}
				else
				{
					[self removeWindowController:WC];
				}
			}
		}
here:
		inspectorType = [[self class] inspectorType];
		NSEnumerator * E = [[NSWindowController inspectorModesForType:inspectorType] objectEnumerator];
		while(inspectorMode = [E nextObject])
		{
			if(![inspectorMode hasPrefix:@"."])
			{
				NSWindowController * WC = [self inspectorAddedWithMode:inspectorMode];
				if([WC window])
				{
					return;
				}
			}
		}
        iTM2_REPORTERROR(1,@"NO DEFAULT INSPECTOR: I don't know what to do!!!\nPerhaps a missing plug-in?",nil);
    }
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  synchronizeWindowControllers
- (BOOL)synchronizeWindowControllers;
/*"This prevents the inherited methods to automatically load the data.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [[self windowControllers] makeObjectsPerformSelector:@selector(synchronizeWithDocument)];
//iTM2_END;
    return [[self windowControllers] count]>0;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  synchronizeWithWindowControllers
- (void)synchronizeWithWindowControllers;
/*"This prevents the inherited methods to automatically load the data.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [[self windowControllers] makeObjectsPerformSelector:@selector(synchronizeDocument)];
//iTM2_END;
    return;
}
#pragma mark =-=-=-=-=-=-=-=  I/O
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  loadFileWrapperRepresentation:ofType:
- (BOOL)loadFileWrapperRepresentation:(NSFileWrapper *)wrapper ofType:(NSString *)type;
/*"This prevents the inherited methods to automatically load the data.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  readFromURL:ofType:error:
- (BOOL)readFromURL:(NSURL *)absoluteURL ofType:(NSString *)typeName error:(NSError **)outErrorPtr
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(iTM2DebugEnabled>99)
	{
		iTM2_LOG(@"absoluteURL:%@", absoluteURL);
		iTM2_LOG(@"typeName:%@", typeName);
	}
	if(outErrorPtr)
	{
		*outErrorPtr = nil;
	}
	NSError ** localErrorRef = nil;
	[self readContextFromURL:absoluteURL ofType:typeName error:localErrorRef];
	if(localErrorRef)
	{
		[SDC presentError:*localErrorRef];
		localErrorRef = nil;
	}
	[super readFromURL:absoluteURL ofType:typeName error:outErrorPtr];
    NSMethodSignature * sig0 = [self methodSignatureForSelector:_cmd];
    NSInvocation * I = [NSInvocation invocationWithMethodSignature:sig0];
    [I setTarget:self];
    [I setArgument:&absoluteURL atIndex:2];
    [I setArgument:&typeName atIndex:3];
    [I setArgument:&localErrorRef atIndex:4];
    BOOL result = YES;
	// BEWARE, the didReadFromURL:ofType:methods are not called here because they do not have the appropriate signature!
	NSPointerArray * PA = [iTM2Runtime instanceSelectorsOfClass:isa withSuffix:@"CompleteReadFromURL:ofType:error:" signature:sig0 inherited:YES];
	NSUInteger i = [PA count];
	while(i--)
	{
		[I setSelector:(SEL)[PA pointerAtIndex:i]];
        [I invoke];
        BOOL R = NO;
        [I getReturnValue:&R];
        result = result && R;
		if(localErrorRef)
		{
			[SDC presentError:*localErrorRef];
			localErrorRef = nil;
		}
    }
	if(result)
	{
		[self didReadFromURL:absoluteURL ofType:typeName error:localErrorRef];
		if(localErrorRef)
		{
			[SDC presentError:*localErrorRef];
			localErrorRef = nil;
		}
	}
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= dataCompleteReadFromURL:ofType:error:
- (BOOL)dataCompleteReadFromURL:(NSURL *)absoluteURL ofType:(NSString *)typeName error:(NSError **)outErrorPtr;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_LOG(@"fullDocumentPath:%@", fullDocumentPath);
//iTM2_END;
	BOOL isDirectory;
	NSString * fullDocumentPath = [absoluteURL path];
	if([DFM fileExistsAtPath:fullDocumentPath isDirectory:&isDirectory] && isDirectory)
		return YES;
	NSData * D = [NSData dataWithContentsOfURL:absoluteURL options:0 error:outErrorPtr];
    return [self loadDataRepresentation:D ofType:typeName];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= resourcesCompleteReadFromURL:ofType:error:
- (BOOL)resourcesCompleteReadFromURL:(NSURL *)absoluteURL ofType:(NSString *) type error:(NSError**)outErrorPtr;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * fullDocumentPath = [absoluteURL path];
//iTM2_LOG(@"fullDocumentPath:%@", fullDocumentPath);
	BOOL isDirectory;
	if([DFM fileExistsAtPath:fullDocumentPath isDirectory:&isDirectory] && isDirectory)
		return YES;
    NSMapTable * selectors = [_iTM2SetResourceSelectors objectForKey:[isa description]];
    NSMethodSignature * sig0 = [self methodSignatureForSelector:@selector(loadIDResourceTemplate:)];
    if(!selectors)
    {
		NSMapTable * Ss = [NSMapTable mapTableWithKeyOptions:NSPointerFunctionsOpaqueMemory|NSPointerFunctionsOpaquePersonality
												valueOptions:NSPointerFunctionsStrongMemory|NSPointerFunctionsOpaquePersonality];
		NSPointerArray * PA = [iTM2Runtime instanceSelectorsOfClass:[self class] withSuffix:@"IDResource:" signature:sig0 inherited:YES];
		NSUInteger i = [PA count];
		while(i--)
		{
			SEL selector = (SEL)[PA pointerAtIndex:i];
			const char * name = [NSStringFromSelector(selector) UTF8String];
			unsigned int hexa;
            if(sscanf(name, "load%u", &hexa))
            {
				NSInteger key = hexa;
				NSMapInsert(Ss,(void *)key,selector);
            }
        }
        [_iTM2SetResourceSelectors takeValue:Ss forKey:[isa description]];
        selectors = [_iTM2SetResourceSelectors objectForKey:[isa description]];
    }
    if([selectors count])
    {
        FSRef ref;
        if(CFURLGetFSRef((CFURLRef)[NSURL fileURLWithPath:fullDocumentPath], &ref))
        {
			short curResFile = CurResFile();
			OSErr resError;
			BOOL wasCurResFile = (noErr == ResError());
			short refNum = FSOpenResFile(&ref, fsRdPerm);
			if(resError = ResError())
			{
				iTM2_LOG(@"1 - Could not FSOpenResFile, error %i (refNum:%i)", resError, refNum);
				return YES;
			}
			UseResFile(refNum);
			if(resError = ResError())
			{
				iTM2_LOG(@"2 - Could not UseResFile, error %i (refNum:%i)", resError, refNum);
				CloseResFile(refNum);
				return YES;
			}
			OSType resourceType = [[NSBundle mainBundle] bundleHFSCreatorCode];
			SInt16 resourceIndex = Count1Resources(resourceType);
			NSInvocation * I = [NSInvocation invocationWithMethodSignature:sig0];
			[I setTarget:self];
			nextLoop:
			while(resourceIndex)
			{
				Handle H = Get1IndResource(resourceType, resourceIndex);
				if((resError = ResError()) || !H)
				{
					iTM2_LOG(@"3 - Could not Get1Resource, error %i (resourceIndex is %i)", resError, resourceIndex);
					iTM2_OUTERROR(2,([NSString stringWithFormat:@"3 - Could not Get1Resource, error %i (resourceIndex is %i)", resError, resourceIndex]),nil);
					--resourceIndex;
					goto nextLoop;
				}
				if(iTM2DebugEnabled)
				{
					iTM2_LOG(@"4 - Could use Get1Resource, error %i (resourceIndex is %i)", resError, resourceIndex);
				}
				SInt16 resourceID = 0;
				GetResInfo(H, &resourceID, nil, nil);
				if(resError = ResError())
				{
					iTM2_LOG(@"5 - Could not GetResInfo, error %i (resourceIndex is %i)", resError, resourceIndex);
					iTM2_OUTERROR(3,([NSString stringWithFormat:@"5 - Could not GetResInfo, error %i (resourceIndex is %i)", resError, resourceIndex]),nil);
					--resourceIndex;
					goto nextLoop;
				}
				if(iTM2DebugEnabled)
				{
					iTM2_LOG(@"6 - Could use GetResInfo, error %i (resourceIndex is %i)", resError, resourceIndex);
				}
				HLock(H);
				NSData * D = [NSData dataWithBytes:*H length:GetHandleSize(H)];
				HUnlock(H);
				ReleaseResource(H);
				if(resError = ResError())
				{
					iTM2_LOG(@"7 - Could not ReleaseResource, error %i (resourceIndex is %i)", resError, resourceIndex);
					iTM2_OUTERROR(3,([NSString stringWithFormat:@"7 - Could not ReleaseResource, error %i (resourceIndex is %i)", resError, resourceIndex]),nil);
				}
				id resourceContent = [NSUnarchiver unarchiveObjectWithData:D];
				if(resourceContent)
				{
					[I setArgument:&resourceContent atIndex:2];
					void * key = (void *)(NSUInteger)resourceID;
					SEL selector = NSMapGet(selectors,key);
					if(selector)
					{
						[I setSelector:selector];
						[I invoke];
						if(iTM2DebugEnabled>99)
						{
							iTM2_LOG(@"Read resource with ID:%u", resourceID);
						}
					}
					else if(iTM2DebugEnabled>99)
					{
						iTM2_LOG(@"INFO:Dont know how to read resource with ID:%u", resourceID);
					}
				}
				else
				{
					iTM2_LOG(@"ERROR:Could not read resource with ID:%u", resourceID);
					iTM2_OUTERROR(3,([NSString stringWithFormat:@"ERROR:Could not read resource with ID:%u", resourceID]),nil);
				}
				--resourceIndex;
			}
			CloseResFile(refNum);
			if(resError = ResError())
			{
				iTM2_LOG(@"8 - Could not CloseResFile, error %i", resError);
				iTM2_OUTERROR(3,([NSString stringWithFormat:@"8 - Could not CloseResFile, error %i", resError]),nil);
			}
			if(wasCurResFile)
			{
				UseResFile(curResFile);
				if(resError = ResError())
				{
					iTM2_LOG(@"9 - Could not UseResFile, error %i", resError);
					iTM2_OUTERROR(3,([NSString stringWithFormat:@"9 - Could not UseResFile, error %i", resError]),nil);
				}
			}
		}
    }
//iTM2_END;
    return YES;// even if the resources could not be saved...
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= loadIDResourceTemplate:
- (void)loadIDResourceTemplate:(id) resourceContent;
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= didReadFromURL:ofType:error:
- (void)didReadFromURL:(NSURL *)absoluteURL ofType:(NSString *) type error:(NSError**)error;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * fileName = absoluteURL? [absoluteURL path]:[self fileName];
    NSDictionary * fileAttributes = [DFM iTM2_attributesOfItemOrDestinationOfSymbolicLinkAtPath:fileName error:NULL];
    [IMPLEMENTATION takeMetaValue:fileAttributes forKey:iTM2DFileAttributesKey];
    [IMPLEMENTATION updateChildren];
	[self synchronizeWindowControllers];
    [IMPLEMENTATION didRead];
    NSInvocation * I;
	[[NSInvocation iTM2_getInvocation:&I withTarget:self retainArguments:NO] didReadFromURL:absoluteURL ofType:type error:error];
	[I iTM2_invokeWithSelectors:[iTM2Runtime instanceSelectorsOfClass:isa withSuffix:@"CompleteDidReadFromURL:ofType:error:" signature:[I methodSignature] inherited:YES]];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  _0213_DidWriteToURL:ofType:forSaveOperation:originalContentsURL:error:
- (void)_0213_DidWriteToURL:(NSURL *)absoluteURL ofType:(NSString *)typeName forSaveOperation:(NSSaveOperationType) saveOperation originalContentsURL:(NSURL *)absoluteOriginalContentsURL error:(NSError**)error;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return;
}
#if 0
#warning !FAILED DEBUG CODE HERE
- (void)runModalSavePanelForSaveOperation:(NSSaveOperationType)saveOperation delegate:(id)delegate didSaveSelector:(SEL)didSaveSelector contextInfo:(void *)contextInfo;
{
	iTM2_LOG(@"saveOperation:%i",saveOperation);
	iTM2_LOG(@"delegate:%@",delegate);
	iTM2_LOG(@"didSaveSelector:%@",NSStringFromSelector(didSaveSelector));
	iTM2_LOG(@"contextInfo:%@",contextInfo);
	[super runModalSavePanelForSaveOperation:(NSSaveOperationType)saveOperation delegate:(id)delegate didSaveSelector:(SEL)didSaveSelector contextInfo:(void *)contextInfo];
	return;
}
- (BOOL)writeSafelyToURL:(NSURL *)absoluteURL ofType:(NSString *)typeName forSaveOperation:(NSSaveOperationType)saveOperation error:(NSError **)outError;
{
	iTM2_LOG(@"absoluteURL:%@",absoluteURL);
	iTM2_LOG(@"typeName:%@",typeName);
	iTM2_LOG(@"saveOperation:%i",saveOperation);
	return [super writeSafelyToURL:(NSURL *)absoluteURL ofType:(NSString *)typeName forSaveOperation:(NSSaveOperationType)saveOperation error:(NSError **)outError];
}
#endif
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  writeToURL:ofType:forSaveOperation:originalContentsURL:error:
- (BOOL)writeToURL:(NSURL *)absoluteURL ofType:(NSString *)typeName forSaveOperation:(NSSaveOperationType)saveOperation originalContentsURL:(NSURL *)absoluteOriginalContentsURL error:(NSError **)outErrorPtr;
//- (BOOL) writeToFile:(NSString *) fullDocumentPath ofType:(NSString *) typeName originalFile:(NSString *) fullOriginalDocumentPath saveOperation:(NSSaveOperationType) saveOperation;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	// Prepare the background
	// only file URLs are supported
	if(![absoluteURL isFileURL])
	{
		iTM2_OUTERROR(1,([NSString stringWithFormat:@"Only file URLs are supported for writing to."]),nil);
		return NO;
	}
	NSString * fullDocumentPath = [absoluteURL path];
	NSString * fullOriginalDocumentPath = nil;
	if(absoluteOriginalContentsURL && ![absoluteOriginalContentsURL isFileURL])
	{
		iTM2_OUTERROR(1,([NSString stringWithFormat:@"Only file URLs are supported for original contents."]),nil);
		// do not return
	}
	else
	{
		fullOriginalDocumentPath = [absoluteOriginalContentsURL path];
	}
	NSString * dirName;
	NSString * baseName;
	// is there something at the target URL?
	// The problem is that I don't know what to do in such a situation because I don't know for sure whether the cocoa framework
	// tries to override an existing file with the user permission
	// In order to be safe, recycle the target url to the trash, but this can break things!
#if 0
	Be confident in cocoa otherwise things are broken with continuous typesetting
	NSArray * files;
	int tag = 0;
	if([DFM fileExistsAtPath:fullDocumentPath] || [DFM destinationOfSymbolicLinkAtPath:fullDocumentPath error:NULL])
	{
		// try to recycle it
		dirName = [fullDocumentPath stringByDeletingLastPathComponent];
		baseName = [fullDocumentPath lastPathComponent];
		files = [NSArray arrayWithObject:baseName];
		if([SWS performFileOperation:NSWorkspaceRecycleOperation source:dirName destination:@"" files:files tag:&tag])
		{
			iTM2_LOG(@"Recycling\n%@...", fullDocumentPath);
		}
		else
		{
			iTM2_OUTERROR(tag,([NSString stringWithFormat:@"Could not recycle already existing file at save location."]),nil);
			iTM2_LOG(@"**** WARNING: Don't be surprised if things don't work as expected...");
			return NO;
		}
	}
#endif
//iTM2_LOG(@"$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$");
	if(iTM2DebugEnabled>99)
	{
		iTM2_LOG(@"absoluteURL:%@", absoluteURL);
		NSLog(@"typeName:%@", typeName);
		NSLog(@"saveOperation:%i", saveOperation);
		NSLog(@"absoluteOriginalContentsURL:%@", absoluteOriginalContentsURL);
		NSLog(@"error: %#x", outErrorPtr);
		NSLog(@"Directory exists:%@", ([DFM fileExistsAtPath:[[absoluteURL path] stringByDeletingLastPathComponent]]? @"YES":@"NO"));
	}
	[self willSave];
    // just duplicate the orginal content if it is not a file: respect the third parties that will certainly write things inside the folder.
    // question are the resource forks respected?
    BOOL result = YES;
    if(![fullDocumentPath iTM2_pathIsEqual:fullOriginalDocumentPath])
    {
		// only copy original contents if this is a directory and the expected destination is a wrapper package
		NSNumber * myLSTypeIsPackage = [IMPLEMENTATION metaValueForKey:@"LSTypeIsPackage"];
        if(!myLSTypeIsPackage || ![[self fileType] isEqual:typeName])
		{
			// either this is the first time we save or the given type is not the same as the recever's one (it has changed somehow)
			NSEnumerator * E = [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDocumentTypes"] objectEnumerator];
			NSDictionary * dico;
			while(dico = [E nextObject])
			{
				if([[dico objectForKey:@"CFBundleTypeName"] isEqualToString:typeName])
				{
					myLSTypeIsPackage = [dico objectForKey:@"LSTypeIsPackage"];
					[IMPLEMENTATION takeMetaValue:myLSTypeIsPackage forKey:@"LSTypeIsPackage"];
					break;
				}
			}
		}
		if([myLSTypeIsPackage boolValue])
		{
			// I must create a directory at the expected location, either by copying a directory or not...
			fullOriginalDocumentPath = [fullOriginalDocumentPath iTM2_stringByResolvingSymlinksAndFinderAliasesInPath];
			BOOL isOriginalDirectory = NO;
			if([DFM fileExistsAtPath:fullOriginalDocumentPath isDirectory:&isOriginalDirectory])
			{
				// there might be something to copy
				if(isOriginalDirectory)
				{
					// the receiver must be a package and not a flat file
#warning
/*
 #if 0
            1240 NSApplicationMain
              1240 -[NSApplication(iTM2BundleKit) swizzle_iTM2BundleKit_run]
                1240 -[NSApplication run]
                  1240 -[iTM2Application sendEvent:]
                    1240 -[NSApplication sendEvent:]
                      1240 -[NSApplication _handleKeyEquivalent:]
                        1240 -[NSMenu performKeyEquivalent:]
                          1240 -[NSCarbonMenuImpl performActionWithHighlightingForItemAtIndex:]
                            1240 -[NSMenu performActionForItemAtIndex:]
                              1240 -[NSApplication sendAction:to:from:]
                                1240 -[iTM2TeXPCommandPerformer performCommand:]
                                  1240 -[iTM2TeXPCommandPerformer performCommandForProject:]
                                    1240 -[NSDocument saveDocument:]
                                      1240 -[NSDocument saveDocumentWithDelegate:didSaveSelector:contextInfo:]
                                        1240 -[NSDocument _saveDocumentWithDelegate:didSaveSelector:contextInfo:]
                                          1240 -[NSDocument_iTM2ProjectDocumentKit saveToURL:ofType:forSaveOperation:delegate:didSaveSelector:contextInfo:]
                                            1240 -[NSDocument saveToURL:ofType:forSaveOperation:delegate:didSaveSelector:contextInfo:]
                                              1240 -[NSDocument _saveToURL:ofType:forSaveOperation:delegate:didSaveSelector:contextInfo:]
                                                1240 -[NSDocument saveToURL:ofType:forSaveOperation:error:]
                                                  1240 -[NSDocument writeSafelyToURL:ofType:forSaveOperation:error:]
                                                    1240 -[NSDocument _writeSafelyToURL:ofType:forSaveOperation:error:]
                                                      1240 -[iTM2ProjectDocument writeToURL:ofType:forSaveOperation:originalContentsURL:error:]
                                                        1240 -[iTM2Document writeToURL:ofType:forSaveOperation:originalContentsURL:error:]
                                                          1240 -[NSFileManager copyPath:toPath:handler:]
                                                            1240 -[NSFileManager _replicatePath:atPath:operation:fileMap:handler:]
                                                              1240 -[NSFileManager _newReplicatePath:ref:atPath:ref:operation:fileMap:handler:]
                                                                1240 -[iTM2Document fileManager:shouldProceedAfterError:]
                                                                  1240 NSRunCriticalAlertPanel
On 2008-08-11, bug
Don't know what are the exact circonstances
The project content is lost
No info.plist file is written
Trying to replace the old texp file by a backup copy
itexmac2 is broken,
the project exact location is broken
if I try to save the project as...
the save as panel cannot list the directory contents
#endif
*/
					[DFM setDelegate:self];
					if([DFM copyItemAtPath:fullOriginalDocumentPath toPath:fullDocumentPath error:NULL])
					{
						//iTM2_LOG(@"Copied from\n%@\nto\n%@", fullOriginalDocumentPath, fullDocumentPath);
						dirName = [fullDocumentPath stringByAppendingPathComponent:@"DATE"];
						NSString * date = [[NSDate date] description];
						// no matter if it fails
						[date writeToFile:dirName atomically:NO encoding:NSUTF8StringEncoding error:nil];
					}
					else
					{
						iTM2_OUTERROR(3,([NSString stringWithFormat:@"Could not copy from\n%@\nto\n%@", fullOriginalDocumentPath, fullDocumentPath]),nil);
						iTM2_LOG(@"****  FAILURE: Could not copy from\n%@\nto\n%@", fullOriginalDocumentPath, fullDocumentPath);
						result = NO;
					}
					[DFM setDelegate:nil];
				}
				else
				{
					// this is an unexpected situation, notice the user in the log and ignore the original contents
					iTM2_OUTERROR(3,([NSString stringWithFormat:@"CONSISTENCY ERROR: the original URL does not point to a directory whereas the receiver is a package\n\
						absoluteOriginalContentsURL:%@\n[self fileType]:%@",absoluteOriginalContentsURL,[self fileType]]),nil);
					iTM2_LOG(@"**** CONSISTENCY ERROR: the original URL does not point to a directory whereas the receiver is a package\n\
						absoluteOriginalContentsURL:%@\n[self fileType]:%@",absoluteOriginalContentsURL,[self fileType]);
				}
			}
			if((![DFM fileExistsAtPath:fullDocumentPath] || ([DFM destinationOfSymbolicLinkAtPath:fullDocumentPath error:NULL] && [DFM removeItemAtPath:fullDocumentPath error:NULL]))
				&& ![DFM createDirectoryAtPath:fullDocumentPath withIntermediateDirectories:YES attributes:nil error:NULL])
			{
				iTM2_OUTERROR(4,([NSString stringWithFormat:@"Could not create a directory at\n%@", fullDocumentPath]),nil);
				dirName = [fullDocumentPath stringByDeletingLastPathComponent];
				iTM2_LOG(@"FILE OPERATION FAILURE: Could not create a directory at\n%@(can write?%@)", fullDocumentPath,([DFM isWritableFileAtPath:dirName]?@"Y":@"N"));            
				return NO;
			}
		}
		else if([SUD boolForKey:@"iTM2PreserveResourceFork"])
		{
			baseName = [fullOriginalDocumentPath stringByAppendingPathComponent:@"..namedfork/rsrc"];
			NSData * D = [NSData dataWithContentsOfFile:baseName];
			if([D length])
			{
				baseName = [fullDocumentPath stringByAppendingPathComponent:@"..namedfork/rsrc"];
				[D writeToFile:baseName options:NSAtomicWrite error:outErrorPtr];
			}
		}
	}
    NSInvocation * I;
	[[NSInvocation iTM2_getInvocation:&I withTarget:self retainArguments:NO] writeToURL:absoluteURL ofType:typeName forSaveOperation:saveOperation originalContentsURL:absoluteOriginalContentsURL error:outErrorPtr];
	NSPointerArray * PA = [iTM2Runtime instanceSelectorsOfClass:isa withSuffix:@"CompleteWriteToURL:ofType:forSaveOperation:originalContentsURL:error:" signature:[I methodSignature] inherited:YES];
	NSUInteger i = [PA count];
	while(i--)
	{
		[I setSelector:(SEL)[PA pointerAtIndex:i]];
        [I invoke];
        BOOL R = NO;
        [I getReturnValue:&R];
        result = result && R;
    }
	result = result && [self writeToURL:absoluteURL ofType:typeName error:outErrorPtr];
    if(result)
    {
        if(saveOperation == NSSaveOperation || saveOperation == NSSaveAsOperation)
        {
            [IMPLEMENTATION takeMetaValue:[DFM iTM2_attributesOfItemOrDestinationOfSymbolicLinkAtPath:fullDocumentPath error:NULL] forKey:iTM2DFileAttributesKey];
        }
		[[NSInvocation iTM2_getInvocation:&I withTarget:self retainArguments:NO]
			_0213_DidWriteToURL:absoluteURL ofType:typeName forSaveOperation:saveOperation originalContentsURL:absoluteOriginalContentsURL error:outErrorPtr];
		[I iTM2_invokeWithSelectors:[iTM2Runtime instanceSelectorsOfClass:isa withSuffix:@"CompleteDidWriteToURL:ofType:forSaveOperation:originalContentsURL:error:" signature:[I methodSignature] inherited:YES]];
		[self didSave];
    }
//iTM2_END;
	if(iTM2DebugEnabled>99)
	{
		iTM2_LOG(@"FINAL DID WRITE? %@", (result? @"YES":@"NO"));
		iTM2_LOG(@"Result exists:%@", ([DFM fileExistsAtPath:fullDocumentPath]? @"YES":@"NO"));
	}
	if(!result)
	{
		iTM2_LOG(@"FAILURE\nabsoluteURL:%@\ntypeName:%@\nsaveOperation:%i\nabsoluteOriginalContentsURL:%@\nerror: %@",
			absoluteURL, typeName, saveOperation, absoluteOriginalContentsURL, (outErrorPtr?*outErrorPtr:nil));
	}
//iTM2_END;
//iTM2_LOG(@"$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$");
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  fileManager:shouldProceedAfterError:
-(BOOL)fileManager:(NSFileManager *)manager shouldProceedAfterError:(NSDictionary *)errorInfo;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
	if([self contextBoolForKey:@"iTM2NoAlertAfterFileOperationError" domain:iTM2ContextAllDomainsMask]
		&& !iTM2DebugEnabled)
	{
		return NO;
	}
//iTM2_START;
    int result = NSRunCriticalAlertPanel([[NSBundle mainBundle] iTM2_bundleName], @"File operation error:\
            %@ with file: %@", @"Proceed Anyway", @"Cancel",  NULL, 
            [errorInfo objectForKey:@"Error"], 
            [errorInfo objectForKey:@"Path"]);
	iTM2_LOG(@"**** FILE MANAGER OPERATION ERROR: %@", errorInfo);
//iTM2_END;
    return (result == NSAlertDefaultReturn);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  writeToURL:ofType:error:
- (BOOL)writeToURL:(NSURL *)absoluteURL ofType:(NSString *) type error:(NSError**)outErrorPtr;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSNumber * myLSTypeIsPackage = [IMPLEMENTATION metaValueForKey:@"LSTypeIsPackage"];
	if(!myLSTypeIsPackage)
	{
		NSEnumerator * E = [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDocumentTypes"] objectEnumerator];
		NSDictionary * dico;
		while(dico = [E nextObject])
			if([[dico objectForKey:@"CFBundleTypeName"] isEqualToString:[self fileType]])
			{
				myLSTypeIsPackage = [dico objectForKey:@"LSTypeIsPackage"];
				[IMPLEMENTATION takeMetaValue:myLSTypeIsPackage forKey:@"LSTypeIsPackage"];
				break;
			}
	}
    BOOL superResult = [myLSTypeIsPackage boolValue] || [super writeToURL:absoluteURL ofType:type error:outErrorPtr];
	BOOL result = YES;
	if(iTM2DebugEnabled>99)
	{
		iTM2_LOG(@"DID WRITE? %@", (result? @"YES":@"NO"));
	}
	NSInvocation * I;
	[[NSInvocation iTM2_getInvocation:&I withTarget:self retainArguments:NO] writeToURL:absoluteURL ofType:type error:outErrorPtr];
	NSPointerArray * PA = [iTM2Runtime instanceSelectorsOfClass:isa withSuffix:@"CompleteWriteToURL:ofType:error:" signature:[I methodSignature] inherited:YES];
	NSUInteger i = [PA count];
	while(i--)
	{
		[I setSelector:(SEL)[PA pointerAtIndex:i]];
        [I invoke];
        BOOL R = NO;
        [I getReturnValue:&R];
        result = result && R;
    }
	[self writeContextToURL:absoluteURL ofType:type error:outErrorPtr];
//iTM2_END;
    return result || superResult;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= dataCompleteWriteToURL:ofType:error:
- (BOOL)dataCompleteWriteToURL:(NSURL *)absoluteURL ofType:(NSString *) typeName error:(NSError **) outErrorPtr;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    NSData * D = [self dataRepresentationOfType:typeName];
	if(iTM2DebugEnabled>99)
	{
		iTM2_LOG(@"is there any data to save? %@", (D? @"Y":@"N"));
		iTM2_LOG(@"Currently saving data with length:%i", [D length]);
	}
    return [(D? D:[NSData data]) writeToURL:absoluteURL options:NSAtomicWrite error:outErrorPtr];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= getIDResourceTemplate:
- (void)getIDResourceTemplate:(id *) resourceContentPtr;
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= resourcesCompleteWriteToURL:ofType:error:
- (BOOL)resourcesCompleteWriteToURL:(NSURL *) absoluteURL ofType:(NSString *) typeName error:(NSError**)outErrorPtr;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * fullDocumentPath = [absoluteURL path];
	if(!fullDocumentPath)
		return NO;
    NSMapTable * selectors = [_iTM2GetResourceSelectors objectForKey:[isa description]];
    NSMethodSignature * sig0 = [self methodSignatureForSelector:@selector(getIDResourceTemplate:)];
    if(!selectors)
    {
		NSMapTable * Ss = [NSMapTable mapTableWithKeyOptions:NSPointerFunctionsOpaqueMemory|NSPointerFunctionsOpaquePersonality
												valueOptions:NSPointerFunctionsOpaqueMemory|NSPointerFunctionsOpaquePersonality];
		NSPointerArray * PA = [iTM2Runtime instanceSelectorsOfClass:[self class] withSuffix:@"IDResource:" signature:sig0 inherited:YES];
		NSUInteger i = [PA count];
		while(i--)
		{
			SEL selector = (SEL)[PA pointerAtIndex:i];
			const char * name = [NSStringFromSelector(selector) UTF8String];
			unsigned int hexa;
            if(sscanf(name, "get%u", &hexa))
            {
				NSUInteger key = hexa;
				NSMapInsert(Ss,(void *)key,selector);
            }
        }
        [_iTM2GetResourceSelectors takeValue:Ss forKey:[isa description]];
        selectors = [_iTM2GetResourceSelectors objectForKey:[isa description]];
    }
    if(![selectors count])
	{
		return YES;
	}
	short curResFile = CurResFile();
	BOOL wasCurResFile = (noErr == ResError());
	FSRef fsRef;
	NSURL * myURL = [NSURL fileURLWithPath:fullDocumentPath];
	if(!CFURLGetFSRef((CFURLRef)myURL, &fsRef))
	{
		if(iTM2DebugEnabled)
		{
			iTM2_LOG(@"CFURLGetFSRef error.");
		}
		return NO;
	}
	HFSUniStr255 resourceForkName;
	OSErr resError = FSGetResourceForkName (&resourceForkName);
	if(resError != noErr) {
		NSLog(@"FSGetResourceForkName error:%i.",resError);
		return -1;
	}
	resError = FSCreateResourceFork(&fsRef,resourceForkName.length,resourceForkName.unicode,0);
	if(resError == errFSForkExists) {
		if(iTM2DebugEnabled)
		{
			iTM2_LOG(@"FSCreateResourceFork error.%i==errFSForkExists(%i)",resError,errFSForkExists);
		}
	} else if(resError != noErr) {
		if(iTM2DebugEnabled)
		{
			iTM2_LOG(@"FSCreateResourceFork error.%i",resError);
		}
		return NO;
	}
	ResFileRefNum fileSystemReferenceNumber;
	resError = FSOpenResourceFile (&fsRef,resourceForkName.length,resourceForkName.unicode,fsRdWrPerm,&fileSystemReferenceNumber);
	if(resError = ResError())
	{
		if(iTM2DebugEnabled)
		{
			iTM2_LOG(@"1 - Could not FSOpenResFile, at %@, error %i, fileSystemReferenceNumber: %i",fullDocumentPath,resError,fileSystemReferenceNumber);
		}
		CloseResFile(fileSystemReferenceNumber);
		iTM2_OUTERROR(kiTM2ExtendedAttributesResourceManagerError,([NSString stringWithFormat:@"1 - Could not FSOpenResFile, at %@, error %i, fileSystemReferenceNumber: %i",fullDocumentPath,resError,fileSystemReferenceNumber]),nil);
		return NO;
	}
	UseResFile(fileSystemReferenceNumber);
	if(resError = ResError())
	{
		if(iTM2DebugEnabled)
		{
			iTM2_LOG(@"2 - Could not UseResFile, at %@, error %i, fileSystemReferenceNumber: %i",fullDocumentPath,resError,fileSystemReferenceNumber);
		}
		iTM2_OUTERROR(kiTM2ExtendedAttributesResourceManagerError,([NSString stringWithFormat:@"2 - Could not UseResFile, at %@, error %i, fileSystemReferenceNumber: %i",fullDocumentPath,resError,fileSystemReferenceNumber]),nil);
		CloseResFile(fileSystemReferenceNumber);
		return NO;
	}
	OSType resourceType = [[NSBundle mainBundle] bundleHFSCreatorCode];
	id resourceContent = nil;
	id * resourceContentPtr = &resourceContent;
	NSInvocation * I;
	[[NSInvocation iTM2_getInvocation:&I withTarget:self retainArguments:NO] getIDResourceTemplate:resourceContentPtr];
	NSMapEnumerator ME = NSEnumerateMapTable(selectors);
	NSUInteger hexa;
	SEL selector;
	while(NSNextMapEnumeratorPair(&ME, (void *)&hexa, (void *)&selector))
	{
		[I setSelector:selector];
		[I invoke];
		ResID resourceID = hexa;
		Handle H = Get1Resource(resourceType, resourceID);
		if(resError = ResError())
		{
			iTM2_LOG(@"3 - Could not Get1Resource, error %i", resError);
			iTM2_OUTERROR(2,([NSString stringWithFormat:@"3 - Could not Get1Resource, error %i", resError]),nil);
			continue;
		}
		if(H)
		{
			RemoveResource(H);
			DisposeHandle(H);
			H = nil;
		}
		NSData * D = [NSArchiver archivedDataWithRootObject:resourceContent];
		if(!D) D = [NSData data];
		if(resError = PtrToHand([D bytes], &H, [D length]))
		{
			iTM2_LOG(@"4 - WARNING:Could not convert a Ptr into a handle");
			iTM2_OUTERROR(2,([NSString stringWithFormat:@"4 - WARNING:Could not convert a Ptr into a handle"]),nil);
		}
		else
		{
			HLock(H);
			AddResource(H, resourceType, resourceID, (ConstStr255Param)"\0");
			HUnlock(H);
			if(resError = ResError())
			{
				iTM2_LOG(@"5 - Could not AddResource, error %i", resError);
				iTM2_OUTERROR(2,([NSString stringWithFormat:@"5 - Could not AddResource, error %i", resError]),nil);
				DisposeHandle(H);// hum the handle is considered the property of the resource manager now?
			}
			else if(iTM2DebugEnabled>99)
			{
				iTM2_LOG(@"6 - Resource added:%u", resourceID);
			}
			// DisposeHandle(H);// hum the handle is considered the property of the resource manager now?
		}
	}
	CloseResFile(fileSystemReferenceNumber);
	if(resError = ResError())
	{
		iTM2_LOG(@"7 - Could not CloseResFile, error %i", resError);
		iTM2_OUTERROR(2,([NSString stringWithFormat:@"7 - Could not CloseResFile, error %i", resError]),nil);
	}
	if(wasCurResFile)
	{
		UseResFile(curResFile);
		if(resError = ResError())
		{
			iTM2_LOG(@"8 - Could not UseResFile, error %i", resError);
			iTM2_OUTERROR(2,([NSString stringWithFormat:@"8 - Could not UseResFile, error %i", resError]),nil);
		}
	}
//iTM2_END;
    return YES;// even if the resources could not be saved...
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= willSave
- (void)willSave;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self synchronizeWithWindowControllers];
    [IMPLEMENTATION willSave];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= didSave
- (void)didSave;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [IMPLEMENTATION takeMetaValue:[DFM iTM2_attributesOfItemOrDestinationOfSymbolicLinkAtPath:[self fileName] error:NULL] forKey:iTM2DFileAttributesKey];
   for(id WC in [self windowControllers])
        [WC setDocumentEdited:NO];
    [IMPLEMENTATION didSave];
	NSInvocation * I;
	[[NSInvocation iTM2_getInvocation:&I withTarget:self retainArguments:NO] didSave];
	[I iTM2_invokeWithSelectors:[iTM2Runtime instanceSelectorsOfClass:isa withSuffix:@"CompleteDidSave" signature:[I methodSignature] inherited:YES]];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  dataOfType:error:
- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed 05 mar 03
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//NSLog(@"data: %@", result);
	if(outError)
	{
		* outError = nil;
	}
    return [self dataRepresentationOfType:typeName];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  dataRepresentationOfType:
- (NSData *)dataRepresentationOfType:(NSString *) type;
/*"Returns YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1:05/04/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [IMPLEMENTATION dataRepresentationOfType:type];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  loadDataRepresentation:ofType:
- (BOOL)loadDataRepresentation:(NSData *) data ofType:(NSString *) type;
/*"Returns YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1:05/04/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//NSLog(@"type:%@", type);
    return [IMPLEMENTATION loadDataRepresentation:data ofType:type];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  readFromData:ofType:error:
- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed 05 mar 03
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(outError)
	{
		* outError = nil;
	}
    return [self loadDataRepresentation:data ofType:typeName];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= dataRepresentation
- (NSData *)dataRepresentation;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1:03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [self dataRepresentationOfType:[self modelType]];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= setDataRepresentation:
- (void)setDataRepresentation:(NSData *) data;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1:03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self loadDataRepresentation:data ofType:[self fileType]];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  fileAttributesToWriteToURL:ofType:forSaveOperation:originalContentsURL:error:
- (NSDictionary *)fileAttributesToWriteToURL:(NSURL *)absoluteURL ofType:(NSString *)typeName forSaveOperation:(NSSaveOperationType)saveOperation originalContentsURL:(NSURL *)absoluteOriginalContentsURL error:(NSError **)outErrorPtr;
/*"From Developer/Documentation/Cocoa/TasksAndConcepts/ProgrammingTopics/Documents/Tasks/SavingHFSTypeCodes.html.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3:09/11/2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSMutableDictionary * newAttributes = [NSMutableDictionary dictionaryWithDictionary:
        [super fileAttributesToWriteToURL:absoluteURL ofType:typeName forSaveOperation:saveOperation originalContentsURL:absoluteOriginalContentsURL error:outErrorPtr]];
    NSDictionary *infoPlist = [[NSBundle mainBundle] infoDictionary];
    // First, set creatorCode to the HFS creator code for the application,
    // if it exists.
    NSString * creatorCodeString = [infoPlist objectForKey:@"CFBundleSignature"];
    if(creatorCodeString)
        [newAttributes setObject:[NSNumber numberWithUnsignedLong:
                        NSHFSTypeCodeFromFileType([NSString stringWithFormat:@"'%@'", creatorCodeString])]
            forKey:NSFileHFSCreatorCode];
    // Then, find the matching Info.plist dictionary entry for this type.
    // Use the first associated HFS type code, if any exist.
    NSEnumerator * E = [[infoPlist objectForKey:@"CFBundleDocumentTypes"] objectEnumerator];
    NSDictionary * D;
    while(D = [E nextObject])
    {
        NSString * type = [D objectForKey:@"CFBundleTypeName"];
        if([type isEqualToString:typeName])
        {
            NSString * firstTypeCodeString = [[[D objectForKey:@"CFBundleTypeOSTypes"] objectEnumerator] nextObject];
            if (firstTypeCodeString)
                [newAttributes setObject:[NSNumber numberWithUnsignedLong:
                                NSHFSTypeCodeFromFileType([NSString stringWithFormat:@"'%@'", firstTypeCodeString])]
                    forKey:NSFileHFSTypeCode];
            break;
        }
    }
    return newAttributes;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= keepBackupFile
- (BOOL)keepBackupFile;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1:03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [self contextBoolForKey:@"iTM2KeepBackup" domain:iTM2ContextAllDomainsMask];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  writeToDirectoryWrapper:error:
- (BOOL)writeToDirectoryWrapper:(NSFileWrapper *) DW error:(NSString **) errorStringRef;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed 05 mar 03
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(![[self fileName] length])
        return NO;
    [self willSave];
    BOOL result = [IMPLEMENTATION writeToDirectoryWrapper:DW error:errorStringRef];
    [self didSave];
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  readFromDirectoryWrapper:error:
- (BOOL)readFromDirectoryWrapper:(NSFileWrapper *) DW error:(NSString **) errorStringRef;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed 05 mar 03
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(![[self fileName] length])
        return NO;
    if([IMPLEMENTATION readFromDirectoryWrapper:DW error:errorStringRef])
    {
        [self didReadFromURL:nil ofType:nil error:nil];
        return YES;
    }
    else
        return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= hasBeenModifiedExternally
- (BOOL)hasBeenModifiedExternally;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    id FAs = [self fileAttributes];
    if(FAs)
    {
        NSDate * oldMD = [FAs fileModificationDate];
        NSDate * newMD = [[DFM iTM2_attributesOfItemOrDestinationOfSymbolicLinkAtPath:[self fileName] error:NULL] fileModificationDate];
        return [newMD compare:oldMD] == NSOrderedDescending;
    }
    else
        return NO;
}
#pragma mark =-=-=-=-=-   CONTEXT
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  contextDictionary
- (id)contextDictionary;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    id CD = metaGETTER;
    if(!CD)
    {
        CD = [NSMutableDictionary dictionary];
        metaSETTER(CD);
    }
    return CD;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setContextDictionary:
- (void)setContextDictionary:(id) dictionary;
/*"Subclasses will most certainly override this method.
Default implementation returns the NSUserDefaults shared instance.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6:03/26/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	metaSETTER([[dictionary mutableCopy] autorelease]);
    return;
}
#pragma mark =-=-=-=-=-   UPDATE
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

#import "iTM2ObjectServer.h"
#import "iTM2BundleKit.h"
#import "iTM2NotificationKit.h"
#import <objc/objc-class.h>

@interface iTM2WindowControllerServer:iTM2ObjectServer
+ (void)WCCompleteInstallation;
+ (BOOL)registerPlugInAtPath:(NSString *) path;
@end
@implementation iTM2WindowControllerServer
static NSMutableDictionary * _iTM2WindowControllerServerDictionary = nil;
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initialize
+ (void)initialize;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
	iTM2_INIT_POOL;
//iTM2_START;
	[super initialize];
    if(!_iTM2WindowControllerServerDictionary)
	{
		_iTM2WindowControllerServerDictionary = [[NSMutableDictionary dictionary] retain];
		[INC addObserver:[iTM2WindowControllerServer class] selector:@selector(bundleDidLoadNotified:) name:iTM2BundleDidLoadNotification object:nil];
		[self WCCompleteInstallation];
	}
//iTM2_END;
	iTM2_RELEASE_POOL;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  mutableDictionary
+ (NSMutableDictionary *)mutableDictionary;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return _iTM2WindowControllerServerDictionary;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  bundleDidLoadNotified:
+ (void)bundleDidLoadNotified:(NSNotification *) notification;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(WCCompleteInstallation) object:nil];
	[self performSelector:@selector(WCCompleteInstallation) withObject:nil afterDelay:0];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  WCCompleteInstallation
+ (void)WCCompleteInstallation;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSPointerArray * PA = [iTM2Runtime subclassReferencesOfClass:[NSWindowController class]];
	NSUInteger i = [PA count];
	while(i--)
	{
		Class C = (Class)[PA pointerAtIndex:i];
        NSString * type = [C inspectorType];
        if([type length])// the type and the modes must have a length!!!
        {
//iTM2_LOG(@"Inspector type:%@", type);
            NSString * mode = [C inspectorMode];
            if([mode length])
            {
//iTM2_LOG(@"Inspector mode:%@", mode);
                NSMutableArray * MRA = [self objectForType:type key:mode];
                if(!MRA)
                {
                    MRA = [NSMutableArray array];
                    [self registerObject:MRA forType:type key:mode retain:YES];
                }
                if(![MRA containsObject:C])
                {
                    [MRA addObject:C];
//Class c = [NSWindowController inspectorClassForType:type mode:mode variant:[C inspectorVariant]];
//iTM2_LOG(@"Registered inspector:%@, type:%@, mode:%@, variant:%@", NSStringFromClass(c), [c inspectorType], [c inspectorMode], [c inspectorVariant]);
                }
				else if(iTM2DebugEnabled)
				{
					iTM2_LOG(@"Already registered class %@", NSStringFromClass(C));
				}
            }
        }
        else if(iTM2DebugEnabled)
        {
			iTM2_LOG(@"No type for inspector:%@", NSStringFromClass(C));
        }
	}
	// then I load the various plugins for external inspectors mainly.
	[[iTM2ExternalInspectorServer mutableDictionary] setDictionary:[NSDictionary dictionary]];
	NSString * basePath;
	NSString * plugInPath;
    NSDirectoryEnumerator * DE;
	NSBundle * MB = [NSBundle mainBundle];
    basePath = [MB builtInPlugInsPath];
    DE = [DFM enumeratorAtPath:basePath];
	NSString * path;
	while(plugInPath = [DE nextObject])
	{
		path = [basePath stringByAppendingPathComponent:plugInPath];
		if([self registerPlugInAtPath:path])
		{
            [DE skipDescendents];
		}
	}
	NSString * mainBundlename = [MB iTM2_bundleName];
    basePath = [NSBundle iTM2_pathForSupportDirectory:iTM2SupportPluginsComponent inDomain:NSNetworkDomainMask withName:mainBundlename create:NO];
    DE = [DFM enumeratorAtPath:basePath];
	while(plugInPath = [DE nextObject])
	{
		path = [basePath stringByAppendingPathComponent:plugInPath];
		if([self registerPlugInAtPath:path])
		{
            [DE skipDescendents];
		}
	}
    basePath = [NSBundle iTM2_pathForSupportDirectory:iTM2SupportPluginsComponent inDomain:NSLocalDomainMask withName:mainBundlename create:NO ];
    DE = [DFM enumeratorAtPath:basePath];
	while(plugInPath = [DE nextObject])
	{
		path = [basePath stringByAppendingPathComponent:plugInPath];
		if([self registerPlugInAtPath:path])
		{
            [DE skipDescendents];
		}
	}
    basePath = [NSBundle iTM2_pathForSupportDirectory:iTM2SupportPluginsComponent inDomain:NSUserDomainMask withName:mainBundlename create:YES];
    DE = [DFM enumeratorAtPath:basePath];
	while(plugInPath = [DE nextObject])
	{
		path = [basePath stringByAppendingPathComponent:plugInPath];
		if([self registerPlugInAtPath:path])
		{
            [DE skipDescendents];
		}
	}
	if(iTM2DebugEnabled)
	{
		iTM2_LOG(@"Here are the registered inspectors: %@", [iTM2ExternalInspectorServer mutableDictionary]);
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  registerPlugInAtPath:
+ (BOOL)registerPlugInAtPath:(NSString *) path;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_LOG(@"path is:%@", path);
	// is it an expected path?
	if(![[path pathExtension] iTM2_pathIsEqual:[NSBundle plugInPathExtension]])
		return NO;
	NSBundle * B = [NSBundle bundleWithPath:path];
	NSString * externalDocumentClassName = [[B infoDictionary] objectForKey:@"iTM2ExternalDocumentClass"];
//	externalDocumentClassName = [B objectForInfoDictionaryKey:@"iTM2ExternalDocumentClass"];
	// is it an expected bundle?
	if(![externalDocumentClassName length])
	{
//iTM2_LOG(@"No iTM2ExternalDocumentClass...\n%@", [B infoDictionary]);
		return ! [B bundleIsWrapper];
	}
	Class documentClass = NSClassFromString(externalDocumentClassName);
	if(![documentClass isSubclassOfClass:[NSDocument class]])
	{
		iTM2_LOG(@"Bad entry for key iTM2ExternalDocumentClass in the Info.plist of %@ (NSDocument subclass name expected)", B);
        return YES;
	}
	NSString * variant = [[B infoDictionary] objectForKey:@"iTM2ExternalInspectorVariant"];
	if(![variant length])
	{
		iTM2_LOG(@"Bad entry for key iTM2ExternalInspectorVariant in the Info.plist of %@ (non void variant expected)", B);
        return YES;
	}
    // Now, we now that the bundle contains an external inspector bridge,
    // we now the variant and the document class it should apply to
	NSString * xPath = [[[B sharedFrameworksPath] stringByDeletingLastPathComponent]
							stringByAppendingPathComponent:@"MacOS"];// don't rely on the executablePath!! it might be void...
    NSString * xComponent = [[B infoDictionary] objectForKey:@"iTM2ExternalInspectorCommand"];
    if([xComponent length])
    {
        NSString * P = [xPath stringByAppendingPathComponent:xComponent];
        if([DFM isExecutableFileAtPath:P])
        {
            [iTM2ExternalInspectorServer registerObject:P forType:[documentClass inspectorType] key:variant retain:YES];
        }
		else
		{
			iTM2_LOG(@"iTM2 executable file at path %@", P);
		}
    }
//iTM2_END;
    return YES;
}
@end

@implementation NSWindowController(iTM2DocumenKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  smallImageLogo
+ (NSImage *)smallImageLogo;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  windowControllerServer
+ (id)windowControllerServer;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return [iTM2WindowControllerServer class];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  isInstanceUnique
+ (BOOL)isInstanceUnique;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  windowNibName
+ (NSString *)windowNibName;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return NSStringFromClass(self);
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
    return @"";
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  prettyInspectorType
+ (NSString *)prettyInspectorType;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * key = [self inspectorType];
//iTM2_START;
    return [NSBundle bundleForClass:self localizedStringForKey:key value:key table:iTM2InspectorTable];
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  prettyInspectorMode
+ (NSString *)prettyInspectorMode;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * key = [self inspectorMode];
	if([key isEqual:@"Terminal"])
		NSLog(@"BON");
//iTM2_START;
    return [NSBundle bundleForClass:self localizedStringForKey:key value:key table:iTM2InspectorTable];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inspectorVariant
+ (NSString *)inspectorVariant;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return iTM2DefaultInspectorVariant;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  prettyInspectorVariant
+ (NSString *)prettyInspectorVariant;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * key = [self inspectorVariant];
//iTM2_START;
    return [NSBundle bundleForClass:self localizedStringForKey:key value:key table:iTM2InspectorTable];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  allInspectorVariantsForType:
+ (NSArray *)allInspectorVariantsForType:(NSString *) type;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [type isEqual:[self inspectorType]]? [NSArray arrayWithObject:[self inspectorVariant]]:[NSArray array];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inspectorClassForType:mode:variant:
+ (Class)inspectorClassForType:(NSString *) type mode:(NSString *) mode variant:(NSString *) variant;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSArray * inspectorClasses = [self inspectorClassesForType:type mode:mode];
    NSEnumerator * E = [inspectorClasses objectEnumerator];
    Class C;
    while(C = [E nextObject])
	{
//iTM2_LOG(NSStringFromClass(C));
        if([[C allInspectorVariantsForType:type] containsObject:variant])
            return C;
	}
    return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inspectorModesForType:
+ (NSArray *)inspectorModesForType:(NSString *) type;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_LOG(@"REQUESTED TYPE IS:%@", type);
//iTM2_END;
    return [[[self windowControllerServer] keyEnumeratorForType:type] allObjects];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inspectorClassesForType:mode:
+ (NSArray *)inspectorClassesForType:(NSString *) type mode:(NSString *) mode;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [[self windowControllerServer] objectForType:type key:mode];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  allInspectorsDescription
+ (NSString *)allInspectorsDescription;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return [[[self windowControllerServer] mutableDictionary] description];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inspectorVariant
- (NSString *)inspectorVariant;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return iTM2DefaultInspectorVariant;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setInspectorVariant:
- (void)setInspectorVariant:(NSString *) argument;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  prettyInspectorVariant
- (NSString *)prettyInspectorVariant;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return NSLocalizedStringFromTableInBundle([self inspectorVariant], iTM2InspectorTable, [self classBundle], "pretty inspector variant");
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  synchronizeDocument
- (void)synchronizeDocument;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self setDocumentEdited:NO];
	[self saveContext:self];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  synchronizeWithDocument
- (void)synchronizeWithDocument;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self loadContext:self];
    [self updateChangeCount:NSChangeCleared];
    [self iTM2_validateWindowContent];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  isInspectorEdited
- (BOOL)isInspectorEdited;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [[IMPLEMENTATION metaValueForKey:@"isInspectorEdited"] boolValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setInspectorEdited:
- (void)setInspectorEdited:(BOOL) flag;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [IMPLEMENTATION takeMetaValue:[NSNumber numberWithBool:flag] forKey:@"isInspectorEdited"];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  updateChangeCount:
- (void)updateChangeCount:(NSDocumentChangeType) change;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    int old = [[IMPLEMENTATION metaValueForKey:@"changeCount"] intValue];
    switch(change)
    {
        case NSChangeCleared:
            old = 0;
            break;
        case NSChangeDone:
            ++old;
            break;
        case NSChangeUndone:
            --old;
            break;
		default:
            old = 0;
            break;
    }
    [IMPLEMENTATION takeMetaValue:[NSNumber numberWithInt:old] forKey:@"changeCount"];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  SWZ_iTM2_windowWillLoad
- (void)SWZ_iTM2_windowWillLoad;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self SWZ_iTM2_windowWillLoad];
	[self setShouldCascadeWindows:[self contextBoolForKey:@"iTM2ShouldCascadeWindows" domain:iTM2ContextAllDomainsMask]];
//iTM2_LOG(@"should cascade:%@", ([self shouldCascadeWindows]? @"Y":@"N"));
    NSInvocation * I;
	[[NSInvocation iTM2_getInvocation:&I withTarget:self retainArguments:NO] windowWillLoad];
	[I iTM2_invokeWithSelectors:[iTM2Runtime instanceSelectorsOfClass:isa withSuffix:@"WindowWillLoad" signature:[I methodSignature] inherited:YES]];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  SWZ_iTM2_windowDidLoad
- (void)SWZ_iTM2_windowDidLoad;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_LOG(@"1 - should cascade:%@", ([self shouldCascadeWindows]? @"Y":@"N"));
	[self SWZ_iTM2_windowDidLoad];
//iTM2_LOG(@"2 - should cascade:%@", ([self shouldCascadeWindows]? @"Y":@"N"));
    NSInvocation * I;
	[[NSInvocation iTM2_getInvocation:&I withTarget:self retainArguments:NO] windowWillLoad];
	[I iTM2_invokeWithSelectors:[iTM2Runtime instanceSelectorsOfClass:isa withSuffix:@"WindowDidLoad" signature:[I methodSignature] inherited:YES]];
	//iTM2_LOG(@"3 - should cascade:%@", ([self shouldCascadeWindows]? @"Y":@"N"));
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2_windowFrameIdentifier
- (NSString *)iTM2_windowFrameIdentifier;
/*"YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1:03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [NSString stringWithFormat:@"%@.%@.%@", [isa inspectorType], [isa inspectorMode], [self inspectorVariant]];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  showWindowBelowFront:
- (void)showWindowBelowFront:(id)sender;
/*"Description Forthcoming.
Version History: Originally created by JL.
To do list:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSWindow * W = [self window];
	[W iTM2_orderBelowFront:self];
//iTM2_END;
    return;
}
@end

@interface iTM2VoidInspector:NSWindowController
@end
@implementation iTM2VoidInspector
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inspectorType
+ (NSString *)inspectorType;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return iTM2VoidInspectorType;
}
@end

@implementation iTM2Inspector
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initWithWindow:
- (id)initWithWindow:(NSWindow *) window;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_LOG(@"name:%@", name);
    if(self = [super initWithWindow:window])
    {
        [self initImplementation];
    }
    return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initWithCoder:
- (id)initWithCoder:(NSCoder *) aDecoder;
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
    return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initImplementation
- (void)initImplementation;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [super initImplementation];
    [IMPLEMENTATION updateChildren];
	[IMPLEMENTATION takeMetaValue:[NSMutableDictionary dictionary] forKey:@"_modelBackups_"];
    return;
}
@synthesize implementation = iVarImplementation;
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  windowNibPath;
- (NSString *)windowNibPath;  
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * path = [super windowNibPath];
	if([DFM fileExistsAtPath:path])
		return path;
	NSString * aNibName = [self windowNibName];
	if(![aNibName length])
		return path;
	Class class = [self class];
	Class superclass;
	while((superclass = [class superclass]) && (superclass != class))
	{
		NSBundle * B = [NSBundle bundleForClass:superclass];
		NSString * fileName = [B pathForResource:aNibName ofType:@"nib"];
		if([fileName length])
			return fileName;
		class = superclass;
	}
//iTM2_END;
    return path;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  windowDidLoad
- (void)windowDidLoad;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
#if 0
	NSWindow * window = [self window];
	NSRect frame = [window frame];
	NSEnumerator * E = [[NSApp windows] objectEnumerator];
	NSWindow * W;
	while(W = [E nextObject])
	{
		if((window != W) && NSEqualRects(frame, [W frame]))
		{
			[window setFrameTopLeftPoint:[window cascadeTopLeftFromPoint:NSMakePoint(NSMinX(frame), NSMaxY(frame))]];
			frame = [window frame];
			E = [[NSApp windows] objectEnumerator];
		}
	}
#endif
    [super windowDidLoad];
//    [self synchronizeWithDocument]; the inspector has already been synchronized when added to the document
    [self setDocumentEdited:NO];// validate the user interface as side effect
	[self backupModel];
    [self loadContext:self];
//	[self iTM2_validateWindowContent]; too early?
//iTM2_LOG(@"should cascade:%@", ([self shouldCascadeWindows]? @"Y":@"N"));
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inspectorVariant
- (NSString *)inspectorVariant;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return metaGETTER?:[super inspectorVariant];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setInspectorVariant:
- (void)setInspectorVariant:(NSString *) argument;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	metaSETTER([[argument copy] autorelease]);
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2_validateWindowContent:
- (BOOL)iTM2_validateWindowContent:(id) sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self setDocumentEdited:([[IMPLEMENTATION metaValueForKey:@"changeCount"] intValue] != 0)];
    return [super iTM2_validateWindowContent];
}
#pragma mark =-=-=-=-=-=-=-=-=-=-  CANCEL management
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  backupModel
- (void)backupModel;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSInvocation * I;
	[[NSInvocation iTM2_getInvocation:&I withTarget:self retainArguments:NO] windowWillLoad];
	[I iTM2_invokeWithSelectors:[iTM2Runtime instanceSelectorsOfClass:isa withSuffix:@"CompleteBackupModel" signature:[I methodSignature] inherited:YES]];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  restoreModel
- (void)restoreModel;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSInvocation * I;
	[[NSInvocation iTM2_getInvocation:&I withTarget:self retainArguments:NO] windowWillLoad];
	[I iTM2_invokeWithSelectors:[iTM2Runtime instanceSelectorsOfClass:isa withSuffix:@"CompleteRestoreModel" signature:[I methodSignature] inherited:YES]];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeModelBackup:(id) backup forKey:
- (void)takeModelBackup:(id) backup forKey:(NSString *) key;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(key)
		[[IMPLEMENTATION metaValueForKey:@"_modelBackups_"] takeValue:backup forKey:key];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  modelBackupForKey:
- (id)modelBackupForKey:(NSString *) key;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return key? [[IMPLEMENTATION metaValueForKey:@"_modelBackups_"] valueForKey:key]:nil;
}
@end

@interface iTM2InspectorResponder:iTM2AutoInstallResponder
@end
@implementation iTM2InspectorResponder
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleInspector:
- (IBAction)toggleInspector:(id) sender;
/*"Description forthcoming. validationt catcher
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSAssert(NO, @"ERROR:this is not the natural flow");
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleInspector:
- (BOOL)validateToggleInspector:(id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSWindowController * WC = [[NSApp mainWindow] windowController];
    NSDocument * D = [WC document];
    NSString * newTitle = [[D class] prettyInspectorType];
    if([newTitle length])
    {
		[sender setAction:NULL];
		NSMenu * submenu = [[[iTM2InspectorMenu alloc] initWithTitle:@""] autorelease];
        [[sender menu] setSubmenu:submenu forItem:sender];
        [submenu update];
//iTM2_LOG(@"UPDATING THE SUBMENU (%@)", NSStringFromSelector([sender action]));
//iTM2_LOG(@"UPDATING THE SUBMENU (%@)", [sender submenu]);
//iTM2_END;
        return [submenu numberOfItems]>0;
    }
    else
    {
        [[sender menu] setSubmenu:nil forItem:sender];
		[sender setEnabled:NO];
//iTM2_LOG(@"REMOVING THE SUBMENU (%@- %@, %@)", NSStringFromSelector([sender action]), D, WC);
//iTM2_END;
        return NO;
    }
}
@end

#import "iTM2ResponderKit.h"

@implementation iTM2InspectorMenu
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initWithTitle:
- (id)initWithTitle:(NSString *) title;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(self = [super initWithTitle:title])
	{
		// I thought update was automatic for menus, but it seems that it is not the case,
		// at least for the inspector menu, so I must update them the hard way
		[DNC addObserver:self selector:@selector(windowDidChangeMainStatusNotified:) name:NSWindowDidResignMainNotification object:nil];
	}
//iTM2_END;
	return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  windowDidChangeMainStatusNotified:
- (void)windowDidChangeMainStatusNotified:(NSNotification *) notification;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self update];
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  update
- (void)update;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSWindow * mainWindow = [NSApp mainWindow];
    NSWindowController * WC = [mainWindow windowController];
    NSDocument * D = [WC document];
    NSString * newTitle = [[D class] prettyInspectorType];
    if(![newTitle length] || [mainWindow isKindOfClass:NSClassFromString(@"iTM2ProjectGhostWindow")])
    {
        [self setTitle:@""];
        NSMenu * M = [self supermenu];
        int index = [M indexOfItemWithSubmenu:self];
        if(index >= 0)
        {
            NSMenuItem * MI = [M itemAtIndex:index];
//iTM2_LOG(@"REMOVING THE SUBMENU HERE TOO");
			[[self retain] autorelease];
            [M setSubmenu:nil forItem:MI];// self is released HERE
            [MI setTarget:nil];
            [MI setAction:@selector(toggleInspector:)];
			[MI setEnabled:NO];
        }
//iTM2_END;
        return;
    }
//    if(![[self title] isEqualToString:newTitle])
	[self setTitle:newTitle];
	BOOL old = [self menuChangedMessagesEnabled];
	[self setMenuChangedMessagesEnabled:NO];
	while([self numberOfItems])
		[self removeItemAtIndex:0];
	NSString * type = [[D class] inspectorType];
	NSEnumerator * E = [[NSWindowController inspectorModesForType:type] objectEnumerator];
	NSString * inspectorMode;
	while(inspectorMode = [E nextObject])
	{
		if(![inspectorMode hasPrefix:@"."])
		{
			NSArray * inspectorClasses = [NSWindowController inspectorClassesForType:type mode:inspectorMode];
			Class C = Nil;
			NSString * title = @"";
			if([inspectorClasses count])
			{
				C = [inspectorClasses objectAtIndex:0];
				title = [C prettyInspectorMode];
			}
			NSMenuItem * MI = [self addItemWithTitle:([title length]? title:NSLocalizedStringFromTableInBundle(iTM2DefaultInspectorMode, iTM2InspectorTable, BUNDLE, "DF"))
					action:NULL keyEquivalent:@""];
			[MI setRepresentedObject:inspectorMode];
			NSMenu * M = [[[NSMenu alloc] initWithTitle:title] autorelease];
			NSEnumerator * e = [inspectorClasses objectEnumerator];
			while(C = [e nextObject])
			{
				NSArray * variants = [C allInspectorVariantsForType:type];
				if([variants count] > 1)
				{
					// some code is added to track george tourlakis bug
NSSet * set = [NSSet setWithArray:variants];
if([set count]<[variants count])
{
	iTM2_LOG(@"[NSWindowController allInspectorsDescription]:%@",[NSWindowController allInspectorsDescription]);
	if([SUD boolForKey:@"GeorgeTourlakisBug"])
	{
		// do nothing
	}
	else
	{
		iTM2_REPORTERROR(1,(@"Problem with inspectors: please send the console.app last lines (~100) to jlaurens@users.sourceforge.net"),nil);
		[SUD registerDefaults:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:@"GeorgeTourlakisBug"]];
	}
}
					NSEnumerator * ee = [variants objectEnumerator];
					NSString * inspectorVariant;
					while(inspectorVariant = [ee nextObject])
					{
						NSMenuItem * mi = [M addItemWithTitle:inspectorVariant
												action:@selector(toggleInspector:) keyEquivalent:@""];
						[mi setRepresentedObject:[NSDictionary dictionaryWithObjectsAndKeys:
							type, @"type", inspectorMode, @"mode", inspectorVariant, @"variant", nil]];
						[mi setTarget:self];// mi belongs to self
					}
				}
				else
				{
					NSString * prettyInspectorVariant = [C prettyInspectorVariant];
					NSMenuItem * mi = [M addItemWithTitle:([prettyInspectorVariant length]? prettyInspectorVariant:
								NSLocalizedStringFromTableInBundle(iTM2DefaultInspectorVariant, iTM2InspectorTable, BUNDLE, "DF"))
							action:@selector(toggleInspector:) keyEquivalent:@""];
					[mi setRepresentedObject:[NSDictionary dictionaryWithObjectsAndKeys:
						type, @"type", inspectorMode, @"mode", [C inspectorVariant], @"variant", nil]];
					[mi setTarget:self];// mi belongs to self
				}
			}
			if([M numberOfItems] > 1)
			{
				[self setSubmenu:M forItem:MI];
			}
			else if([M numberOfItems] > 0)
			{
				[self removeItem:MI];
				MI = [[[M itemAtIndex:0] retain] autorelease];
				[M removeItem:MI];
				[self addItem:MI];
				[MI setTitle:title];
			}
			else
			{
				iTM2_LOG(@"There is some weird thing happening with the inspectors(type:%@, mode:%@)...", type, inspectorMode);
			}
		}
	}
	int NOI = [self numberOfItems];
	// adding now the external inspectors, if any
	E = [[[[iTM2ExternalInspectorServer keyEnumeratorForType:type] allObjects] sortedArrayUsingSelector:@selector(compare:)] objectEnumerator];
	NSString * inspectorVariant;
	while(inspectorVariant = [E nextObject])
	{
		NSMenuItem * mi = [self addItemWithTitle:inspectorVariant
				action:@selector(toggleExternalInspector:) keyEquivalent:@""];
		[mi setRepresentedObject:[iTM2ExternalInspectorServer objectForType:type key:inspectorVariant]];
		[mi setTarget:self];// mi belongs to self
	}
	if([self numberOfItems]>NOI)
	{
		[self insertItem:[NSMenuItem separatorItem] atIndex:NOI];
	}
	[self setMenuChangedMessagesEnabled:old];
    [super update];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleInspector:
- (IBAction)toggleInspector:(NSMenuItem *) sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id doc = [[[NSApp mainWindow] windowController] document];
	if([doc isDocumentEdited])
		return;
	NSDictionary * D = [sender representedObject];
	NSString * mode = [D valueForKey:@"mode"];
	NSString * variant = [D valueForKey:@"variant"];
	if([doc isKindOfClass:[iTM2Document class]])
	{
		[doc replaceInspectorMode:mode variant:variant];
	}
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleInspector:
- (BOOL)validateToggleInspector:(id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_LOG(@"[sender representedObject] is:%@", [sender representedObject]);
    NSWindowController * WC = [[NSApp mainWindow] windowController];
    NSDocument * D = [WC document];
    [sender setState:([[sender representedObject] isEqual:
        [NSDictionary dictionaryWithObjectsAndKeys:[[D class] inspectorType], @"type", [[WC class] inspectorMode], @"mode", [WC inspectorVariant], @"variant", nil]]?
            NSOnState:NSOffState)];
//iTM2_END;
    return ![D isDocumentEdited];// beware:the undo stack is not managed if you change the inspector while the document is edited
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleExternalInspector:
- (IBAction)toggleExternalInspector:(NSMenuItem *) sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id doc = [[[NSApp mainWindow] windowController] document];
	if([doc isKindOfClass:[iTM2Document class]])
	{
		[doc saveContext:self];
		[doc replaceInspectorMode:iTM2ExternalInspectorMode variant:[sender title]];
	}
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleExternalInspector:
- (BOOL)validateToggleExternalInspector:(id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSWindowController * WC = [[NSApp mainWindow] windowController];
    [sender setState:([WC isKindOfClass:[iTM2ExternalInspector class]] && [[WC inspectorVariant] isEqual:[sender title]]?
            NSOnState:NSOffState)];
//iTM2_LOG(@"filename is:%@", [[WC document] fileName]);
	if(![sender image])
	{
		NSString * appName = [sender title];
		NSString * name = [NSString stringWithFormat:@"%@(small)",appName];
		NSImage * I = [NSImage iTM2_cachedImageNamed:name];
		if(![I iTM2_isNotNullImage])
		{
			I = [[SWS iconForFile:[SWS fullPathForApplication:appName]] copy];// copy!!!
			[I setName:name];
			[I iTM2_setSizeSmallIcon];
		}
		[sender setImage:I];
	}
	NSDocument * D = [WC document];
//iTM2_END;
    return [[D fileName] length] > 0 && ![D isDocumentEdited];
}
@end

NSString * const iTM2UDSmartUndoKey = @"iTM2SmartUndo";
NSString * const iTM2UDLevelsOfUndoKey = @"iTM2LevelsOfUndo";

@interface iTM2UndoManager(PRIVATE)
- (void)undoPastSaveSheetDidEnd:(NSWindow *) unused returnCode:(int) returnCode irrelevantInfo:(void *) irrelevant;
@end

@implementation NSResponder(iTM2UndoManager)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleSmartUndo:
- (IBAction)toggleSmartUndo:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	BOOL old = [self contextBoolForKey:iTM2UDSmartUndoKey domain:iTM2ContextAllDomainsMask];
	[self takeContextBool:!old forKey:iTM2UDSmartUndoKey domain:iTM2ContextAllDomainsMask];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleSmartUndo:
- (BOOL)validateToggleSmartUndo:(id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[sender setState:([self hasSmartUndo]?NSOnState:NSOffState)];
//iTM2_END;
    return [self canToggleSmartUndo];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  canToggleSmartUndo
- (BOOL)canToggleSmartUndo;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (12/18/2001).
To do list:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  hasSmartUndo
- (BOOL)hasSmartUndo;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (12/18/2001).
To do list:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return [self contextBoolForKey:iTM2UDSmartUndoKey domain:iTM2ContextAllDomainsMask];
}
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2UndoManager
/*"Description forthcoming."*/
@implementation iTM2UndoManager
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initialize
+ (void)initialize;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (12/18/2001).
To do list:
"*/
{iTM2_DIAGNOSTIC;
	iTM2_INIT_POOL;
//iTM2_START;
    [super initialize];
    [SUD registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithUnsignedInt:0], iTM2UDLevelsOfUndoKey,// nothing else!
            [NSNumber numberWithBool:YES], iTM2UDSmartUndoKey,
                nil]];
//iTM2_END;
	iTM2_RELEASE_POOL;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  undo
- (void)undo;
/*"Private use only. Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1:03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSWindow * keyWindow = [NSApp keyWindow];
    if([keyWindow hasSmartUndo] && ![keyWindow isDocumentEdited])
	{
		NSString * undoMenuItemTitle = [self undoMenuItemTitle];
		NSString * titre;
		if([[self undoMenuItemTitle] hasPrefix:@"&"])
			titre = [undoMenuItemTitle substringWithRange:NSMakeRange(1, [undoMenuItemTitle length]-1)];
		else
			titre = undoMenuItemTitle;
		NSBeginAlertSheet(
			NSLocalizedStringFromTableInBundle(@"Warning", TABLE, BUNDLE, ""),
			titre,
			[NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"Don't %@", TABLE, BUNDLE, nil), titre],
			nil,
			keyWindow,
			self,
			NULL,
			@selector(_undoPastSaveSheetDidDismiss:returnCode:irrelevantInfo:),
			nil,
			NSLocalizedStringFromTableInBundle(@"Undo past saved?", TABLE, BUNDLE,
	"You are about to undo past the last point this file was saved. Do you want to do this?"));
		return;
    }
    [super undo];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  _undoPastSaveSheetDidDismiss:returnCode:irrelevantInfo:
- (void)_undoPastSaveSheetDidDismiss:(NSWindow *) unused returnCode:(int) returnCode irrelevantInfo:(void *) irrelevant;
/*"Private use only. Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1:03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if ((returnCode == NSOKButton) && ([self canUndo]))
    {
        [super undo];
    }
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  orderHelperFront
- (void)orderHelperFront;
/*"Private use only. Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1:03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	return;
}
@end

#import "iTM2PathUtilities.h"

NSString * const iTM2ExternalInspectorMode = @"iTM2ExternalInspector";

@implementation iTM2ExternalInspector
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inspectorMode
+ (NSString *)inspectorMode;
/*"Private use only. Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1:03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	return iTM2ExternalInspectorMode;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  allInspectorVariantsForType:
+ (NSArray *)allInspectorVariantsForType:(NSString *) type;
/*"Private use only. Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1:03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSEnumerator * E = [iTM2ExternalInspectorServer keyEnumeratorForType:type];
//iTM2_END;
	return E? [E allObjects]:[NSArray array];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  switchToExternalHelperWithEnvironment:
- (BOOL)switchToExternalHelperWithEnvironment:(NSDictionary *) environment;
/*"Private use only. Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1:03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
        NSTask * task = [[self implementation] metaValueForKey:@"task"];
        [DNC removeObserver:self name:NSTaskDidTerminateNotification object:task];
        task = [[[NSTask alloc] init] autorelease];
		NSString * type = [[[self document] class] inspectorType];
		NSString * variant = [self inspectorVariant];
		NSString * launchPath = [iTM2ExternalInspectorServer objectForType:type key:variant];
		NSAssert([launchPath length], @"Inconsistency on launchPath, PLEASE report bug...");
        [task setLaunchPath:launchPath];
		NSString * fileName = [[self document] fileName];
		NSAssert([fileName length], @"Inconsistency on fileName, PLEASE report bug...");
        [task setCurrentDirectoryPath:[fileName stringByDeletingLastPathComponent]];
        NSMutableDictionary * processEnvironment = [[[[NSProcessInfo processInfo] environment] mutableCopy] autorelease];
		[processEnvironment addEntriesFromDictionary:[[self document] environmentForExternalHelper]];
		[processEnvironment addEntriesFromDictionary:environment];
		[processEnvironment setObject:[NSString stringWithFormat:@":%@:%@",
                        [self contextValueForKey:iTM2PATHPrefixKey domain:iTM2ContextAllDomainsMask],
							[processEnvironment objectForKey:@"PATH"]]  forKey:@"PATH"];
		[processEnvironment setObject:[[[self document] fileName] lastPathComponent]  forKey:@"file"];
        [task setEnvironment:processEnvironment];
        [task setStandardInput:[NSFileHandle fileHandleWithNullDevice]];
        [task setStandardOutput:[NSFileHandle fileHandleWithNullDevice]];
        [task setStandardError:[NSFileHandle fileHandleWithNullDevice]];
		[[self implementation] takeMetaValue:task forKey:@"task"];
        [DNC addObserver:self
            selector:@selector(_taskDidTerminate:) name:NSTaskDidTerminateNotification object:task];
        [task launch];
//iTM2_END;
	return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  _taskDidTerminate:
- (void)_taskDidTerminate:(NSNotification *) notification;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3:Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [DNC removeObserver:self name:nil object:[notification object]];
	[[self implementation] takeMetaValue:nil forKey:@"task"];
//iTM2_START;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  windowTitleForDocumentDisplayName:
- (NSString *)windowTitleForDocumentDisplayName:(NSString *) displayName;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [[super windowTitleForDocumentDisplayName:displayName] stringByAppendingFormat:@" (%@)", [self inspectorVariant]];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inspectorVariant
- (NSString *)inspectorVariant;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return metaGETTER;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setInspectorVariant:
- (void)setInspectorVariant:(NSString *) argument;
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
@end

@implementation iTM2ExternalWindow
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  makeMainWindow
- (void)makeMainWindow;
/*"Private use only. Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1:03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[super makeMainWindow];
	[[self windowController] switchToExternalHelperWithEnvironment:[NSDictionary dictionaryWithObjectsAndKeys:
					[[[self windowController] document] fileName], @"file", nil]];
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  makeKeyWindow
- (void)makeKeyWindow;
/*"Private use only. Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1:03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[super makeKeyWindow];
	[[self windowController] switchToExternalHelperWithEnvironment:[NSDictionary dictionaryWithObjectsAndKeys:
					[[[self windowController] document] fileName], @"file", nil]];
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  makeKeyAndOrderFront:
- (void)makeKeyAndOrderFront:(id) sender;
/*"Private use only. Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1:03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[super makeKeyAndOrderFront:(id) sender];
	[[self windowController] switchToExternalHelperWithEnvironment:[NSDictionary dictionaryWithObjectsAndKeys:
					[[[self windowController] document] fileName], @"file", nil]];
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  orderFront:
- (void)orderFront:(id) sender;
/*"Private use only. Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1:03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[super orderFront:sender];
	[[self windowController] switchToExternalHelperWithEnvironment:[NSDictionary dictionaryWithObjectsAndKeys:
					[[[self windowController] document] fileName], @"file", nil]];
//iTM2_END;
	return;
}
@end

@implementation iTM2ExternalInspectorServer
static NSMutableDictionary * _iTM2ExternalInspectorServerDictionary = nil;
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initialize
+ (void)initialize;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
    iTM2_INIT_POOL;
//iTM2_START;
    [super initialize];
    if(!_iTM2ExternalInspectorServerDictionary)
	{
		_iTM2ExternalInspectorServerDictionary = [NSMutableDictionary dictionary];
	}
//iTM2_END;
	iTM2_RELEASE_POOL;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  mutableDictionary
+ (NSMutableDictionary *)mutableDictionary;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return _iTM2ExternalInspectorServerDictionary;
}
@end

@implementation iTM2WildcardDocument
@end

@implementation iTM2MainInstaller(DocumentKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  windowLoadingCompleteInstallation
+ (void)windowLoadingCompleteInstallation;
/*"Description Forthcoming.
 Version history: jlaurens AT users DOT sourceforge DOT net
 - 2.0: Fri Sep 05 2003
 To Do List:
 "*/
{iTM2_DIAGNOSTIC;
	//iTM2_START;
	[SUD registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:
						   [NSNumber numberWithBool:YES], @"iTM2ShouldCascadeWindows",
						   nil]];
}
+ (void)prepareDocumentKitCompleteInstallation;
{iTM2_DIAGNOSTIC;
	//iTM2_START;
	if([NSWindowController iTM2_swizzleInstanceMethodSelector:@selector(SWZ_iTM2_windowWillLoad)]
			 && [NSWindowController iTM2_swizzleInstanceMethodSelector:@selector(SWZ_iTM2_windowDidLoad)])
	{
		iTM2_MILESTONE((@"NSDocument(iTM2Loading)"),(@"***  Huge problem in method swizzling NSWindowController, things will not work as expected."));
	}
	if([NSDocument iTM2_swizzleInstanceMethodSelector:@selector(SWZ_iTM2_canCloseDocumentWithDelegate:shouldCloseSelector:contextInfo:)])
	{
		iTM2_MILESTONE((@"NSDocument(iTeXMac2)"),(@"WARNING:No hook available before closing documents..., things can become dangerous"));
	}
    return;
}
@end
