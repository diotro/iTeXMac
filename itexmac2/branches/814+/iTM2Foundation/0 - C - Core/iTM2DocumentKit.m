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
#import "iTM2DocumentControllerKit.h"
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
#define BUNDLE [iTM2Document classBundle4iTM3]

@implementation NSDocument(iTeXMac2)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inspectorType4iTM3
+ (NSString *)inspectorType4iTM3;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return iTM2VoidInspectorType;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  prettyInspectorType4iTM3
+ (NSString *)prettyInspectorType4iTM3;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return NSLocalizedStringFromTableInBundle(self.inspectorType4iTM3, iTM2InspectorTable, self.classBundle4iTM3, "pretty inspector type");
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  smartClose4iTM3
- (void)smartClose4iTM3;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//	START_TRACKING4iTM3;
    [self canCloseDocumentWithDelegate:self shouldCloseSelector:@selector(document4iTM3:shouldSmartClose:ignored0213:) contextInfo:nil];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  documentWillClose4iTM3
- (void)documentWillClose4iTM3;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSMethodSignature * sig0 = [self methodSignatureForSelector:_cmd];
    NSInvocation * I = [NSInvocation invocationWithMethodSignature:sig0];
    I.target = self;
	[I invokeWithSelectors4iTM3:[iTM2Runtime instanceSelectorsOfClass:self.class withSuffix:@"CompleteWillClose4iTM3" signature:sig0 inherited:YES]];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  documentDidClose4iTM3
- (void)documentDidClose4iTM3;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSMethodSignature * sig0 = [self methodSignatureForSelector:_cmd];
    NSInvocation * I = [NSInvocation invocationWithMethodSignature:sig0];
    I.target = self;
    [I invokeWithSelectors4iTM3:[iTM2Runtime instanceSelectorsOfClass:self.class withSuffix:@"CompleteDidClose4iTM3" signature:sig0 inherited:YES]];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  document4iTM3:shouldSmartClose:ignore0213:
- (void)document4iTM3:(NSDocument *) doc shouldSmartClose:(BOOL) shouldClose ignore0213:(void *) irrelevant;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Feb 20 13:19:00 GMT 2004perform
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (shouldClose) {
		self.documentWillClose4iTM3;
		self.close;
		self.documentDidClose4iTM3;
	}
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  cannotCloseWithNoFileImage
- (BOOL)cannotCloseWithNoFileImage;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return YES;
}
- (void)template_selector_document4iTM3:(NSDocument *)document shouldClose:(BOOL)shouldClose contextInfo:(void *)contextInfo;
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSMethodSignature * MS = [delegate methodSignatureForSelector:shouldCloseSelector];
	if (MS) {
		NSInvocation * I;
		[[NSInvocation getInvocation4iTM3:&I withTarget:self retainArguments:NO]
			 template_selector_document4iTM3:self shouldClose:NO contextInfo:contextInfo];
		if ([MS isEqual:[I methodSignature]]) {
            I.selector = shouldCloseSelector;
			I.target = delegate;
			[self SWZ_iTM2_canCloseDocumentWithDelegate:self shouldCloseSelector:@selector(document4iTM3:forwardShouldClose:toInvocation:) contextInfo:(void *)I];
		}
		return;
	}
	[self SWZ_iTM2_canCloseDocumentWithDelegate:delegate shouldCloseSelector:shouldCloseSelector contextInfo:contextInfo];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  document4iTM3:forwardShouldClose:toInvocation:
- (void)document4iTM3:(NSDocument *) doc forwardShouldClose:(BOOL) shouldClose toInvocation:(id) invocation;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Feb 20 13:19:00 GMT 2004perform
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[invocation autorelease];
	[invocation setArgument:&shouldClose atIndex:3];//EXC_BAD_ACCESS
	if (shouldClose && !self.cannotCloseWithNoFileImage && self.fileURL.isFileURL && ![DFM fileExistsAtPath:self.fileURL.path]) {
		NSBeginAlertSheet(
			NSLocalizedStringFromTableInBundle(@"Warning", TABLE, BUNDLE, ""),
			NSLocalizedStringFromTableInBundle(@"Save", TABLE, BUNDLE, nil),
			NSLocalizedStringFromTableInBundle(@"Ignore", TABLE, BUNDLE, nil),
			nil,
			self.frontWindow,
			self,
			NULL,
			@selector(_noFileSheetDidDismiss:returnCode:invocation:),
			[invocation retain],
			NSLocalizedStringFromTableInBundle(@"No file at %@", TABLE, BUNDLE,
        "Missing file at the given URL?"),
			self.fileURL);
		return;
	}
//LOG4iTM3(@"----    invocation is:%@", invocation);
//LOG4iTM3(@"----    invocation.target is:%@", invocation.target);
	[invocation invoke];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  _noFileSheetDidDismiss:returnCode:invocation:
- (void)_noFileSheetDidDismiss:(NSWindow *) unused returnCode:(NSInteger) returnCode invocation:(NSInvocation *) invocation;
/*"Private use only. Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1:03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[invocation autorelease];
    if (returnCode == NSOKButton)
    {
        [self writeToURL:self.fileURL ofType:self.fileType error:nil];
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return fileType;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  modelType
- (NSString *)modelType;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return [self modelTypeForFileType:self.fileType];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  frontWindow
- (id)frontWindow;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    for(NSWindow * W in [NSApp orderedWindows])
    {
        NSWindowController * WC = W.windowController;
		NSDocument * D = WC.document;
		NSString * WCType = [[WC class] inspectorType4iTM3];
		NSString * DType = [[D class] inspectorType4iTM3];
        if ((D == self) && [WCType isEqual:DType])
		{
            return W;
		}
    }
    // lazy initializer here?
    return nil;
}
#pragma mark =-=-=-=-=-   UPDATE
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= needsToUpdate4iTM3
- (BOOL)needsToUpdate4iTM3;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Jan 18 22:21:11 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSDate * oldMD = self.fileModificationDate;
    NSDate * newMD = [[DFM attributesOfItemOrDestinationOfSymbolicLinkAtURL4iTM3:self.fileURL error:NULL] fileModificationDate];
	BOOL result = [newMD compare:oldMD] == NSOrderedDescending;
	if (result && (iTM2DebugEnabled>999))
	{
		LOG4iTM3(@"oldMD:%@ < newMD:%@", oldMD, newMD);
	}
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= recordFileModificationDateFromURL4iTM3:
- (void)recordFileModificationDateFromURL4iTM3:(NSURL *)absoluteURL;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Jan 18 22:21:11 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (!absoluteURL.isFileURL) {
		return;
	}
	NSDictionary * attributes = [DFM attributesOfItemOrDestinationOfSymbolicLinkAtURL4iTM3:absoluteURL error:NULL];
	NSDate * date = attributes.fileModificationDate;
//LOG4iTM3(@"path is:%@ date:%@",path,date);
	if (date) {
		[self setFileModificationDate:date];
		if (self.needsToUpdate4iTM3) {
			LOG4iTM3(@"****  ERROR:THERE IS AN INCONSISTENCY... please report light bug");
		}
	}
//LOG4iTM3(@"%@ should be %@ should be %@", self.fileModificationDate, [[DFM attributesOfItemOrDestinationOfSymbolicLinkAtPath4iTM3:fileName error:NULL] fileModificationDate], [self.implementation metaValueForKey:@"LastFileModificationDate"]);
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= updateIfNeeded4iTM3Error:
- (BOOL)updateIfNeeded4iTM3Error:(NSError **)outErrorPtr;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Jan 18 22:21:11 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return YES;
}
#pragma mark =-=-=-=-=-   CONTAINER
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  childDocumentForFileName:
- (id)childDocumentForFileName:(NSString *)fileName;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return nil;
}
#pragma mark =-=-=-=-=-   CONTEXT
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  currentContext4iTM3Manager
- (id)currentContext4iTM3Manager;
/*"Subclasses will most certainly override this method.
Default implementation returns the NSUserDefaults shared instance.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6:03/26/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= context4iTM3DictionaryFromURL:
+ (id)context4iTM3DictionaryFromURL:(NSURL *) fileURL;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (!fileURL.isFileURL)
	{
		return nil;
	}
	NSDictionary * attributes = [DFM extendedFileAttributesInSpace4iTM3:[NSNumber numberWithUnsignedInteger:'iTM2'] atPath:fileURL.path error:nil];
//	if (!D)
//		D = [DFM extendedFileAttributesAtPath4iTM3:fullDocumentPath forNameSpace:@"org_tug_mac_iTM20" error:nil];
	NSMutableDictionary * MD = [NSMutableDictionary dictionary];
	for(NSString * key in attributes.keyEnumerator)
	{
		NS_DURING
		id O = [NSUnarchiver unarchiveObjectWithData:[attributes objectForKey:key]];
		if (O)
			[MD setObject:O forKey:key];
		NS_HANDLER
		[NSApp reportException:localException];
		NS_ENDHANDLER
	}
//END4iTM3;
	return [MD.copy autorelease];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= printInfoCompleteReadFromURL4iTM3:ofType:error:
- (BOOL)printInfoCompleteReadFromURL4iTM3:(NSURL *) fileURL ofType:(NSString *) type error:(NSError**)outErrorPtr;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSString * fullDocumentPath = fileURL.path;
	NSData * D = [self context4iTM3ValueForKey:@"NSPrintInfo" domain:iTM2ContextAllDomainsMask];
	if (!D)
		D = [DFM extendedFileAttribute4iTM3:@"NSPrintInfo" inSpace:[NSNumber numberWithUnsignedInteger:'TUG0'] atPath:fullDocumentPath error:nil];
//	if (!D)
//		D = [DFM extendedFileAttribute4iTM3:@"NSPrintInfo" atPath:fullDocumentPath forNameSpace:@"org_tug_mac_cocoa" error:nil];
	if (!D)
		return YES;
	NSDictionary * dictionary = [NSUnarchiver unarchiveObjectWithData:D];
	if ([dictionary isKindOfClass:[NSDictionary class]])
	{
		BOOL wasUndoing = self.undoManager.isUndoRegistrationEnabled;
		self.undoManager.disableUndoRegistration;
		[self setPrintInfo:[[[NSPrintInfo alloc] initWithDictionary:dictionary] autorelease]];
		if (wasUndoing)
			self.undoManager.enableUndoRegistration;
	}
	else
	{
		LOG4iTM3(@"WARNING:Dictionary expected, got %@", dictionary);
	}
//END4iTM3;
    return YES;// even if the resources could not be saved...
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  preparePrintInfoCompleteWriteToURL4iTM3:ofType:error:
- (BOOL)preparePrintInfoCompleteWriteToURL4iTM3:(NSURL *) fileURL ofType:(NSString *) type error:(NSError**)error;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSString * fileName = fileURL.path;
	NSData * D = [NSArchiver archivedDataWithRootObject:self.printInfo.dictionary];
	if (D)
	{
		[self takeContext4iTM3Value:D forKey:@"Print Info Data" domain:iTM2ContextAllDomainsMask];
		[DFM addExtendedFileAttribute4iTM3:@"NSPrintInfo" value:D inSpace:[NSNumber numberWithUnsignedInteger:'TUG0'] atPath:fileName error:nil];
//		[DFM addExtendedFileAttribute4iTM3:@"NSPrintInfo" value:D atPath:fileName forNameSpace:@"org_tug_mac_cocoa" error:nil];
	}
//END4iTM3;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  openInspectorsCompleteSaveContext4iTM3Error:
- (BOOL)openInspectorsCompleteSaveContext4iTM3Error:(NSError **)outErrorPtr;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Révisé par itexmac2: 2010-11-30 21:53:11 +0100
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSMutableArray * openInspectors = NSMutableArray.array;
    for (NSWindow * W in [[NSApp windows] sortedArrayUsingSelector:@selector(compareUsingLevel4iTM3:)])
        if (W.isVisible) {
            NSWindowController * WC = W.windowController;
            if (self == WC.document) {
                Class C = WC.class;
				NSString * mode = [C inspectorMode];
				if (![mode hasPrefix:@"."])
					[openInspectors addObject:[NSDictionary dictionaryWithObjectsAndKeys:[C inspectorType4iTM3], @"type", mode, @"mode", WC.inspectorVariant, @"variant", nil]];
            }
        }
	if (openInspectors.count) {
		[self takeContext4iTM3Value:openInspectors forKey:iTM2ContextOpenInspectors domain:iTM2ContextStandardLocalMask|iTM2ContextExtendedMask];
	}
//LOG4iTM3(@"openInspectors (%@) are:%@ = %@", self.fileURL.path, openInspectors, [self context4iTM3ValueForKey:iTM2ContextOpenInspectors]);
//END4iTM3;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  saveContext4iTM3Error:
- (BOOL)saveContext4iTM3Error:(NSError **)outErrorPtr;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	BOOL result = [super saveContext4iTM3Error:outErrorPtr];
	if (self.context4iTM3Manager == self) {
		NSURL * url = self.fileURL;
		NSString * type = self.fileType;
		if (self.needsToUpdate4iTM3) {
			result = [self writeContextToURL:url ofType:type error:outErrorPtr] && result;
		} else {
			result = [self writeContextToURL:url ofType:type error:outErrorPtr] && result;
			[self recordFileModificationDateFromURL4iTM3:url];
		}
	}
//END4iTM3;
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= readContextFromURL:ofType:error:
- (BOOL)readContextFromURL:(NSURL *)absoluteURL ofType:(NSString *) type error:(NSError **)outErrorPtr;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (self.context4iTM3Manager == self)
	{
		NSDictionary * attributes = [DFM extendedFileAttributesInSpace4iTM3:[NSNumber numberWithUnsignedInteger:'iTM2'] atPath:absoluteURL.path error:nil];
		NSEnumerator * E = attributes.keyEnumerator;
		NSString * key;
		while(key = E.nextObject)
		{
			NS_DURING
			id O = [NSUnarchiver unarchiveObjectWithData:[attributes objectForKey:key]];
			if (O)
				[self.context4iTM3Dictionary setObject:O forKey:key];
			else
				[self.context4iTM3Dictionary removeObjectForKey:key];
			NS_HANDLER
			[NSApp reportException:localException];
			NS_ENDHANDLER
		}
//LOG4iTM3(@"self.context4iTM3Dictionary is:%@", self.context4iTM3Dictionary);
	}
//END4iTM3;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= writeContextToURL:ofType:error:
- (BOOL)writeContextToURL:(NSURL *)absoluteURL ofType:(NSString *)type error:(NSError **)outErrorPtr;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (!absoluteURL.isFileURL)
	{
		return NO;
	}
	NSDictionary * context4iTM3Dictionary = self.context4iTM3Dictionary;
//LOG4iTM3(@"context4iTM3Dictionary is:%@", context4iTM3Dictionary);
	if (context4iTM3Dictionary.count)
	{
		NSMutableDictionary * attributes = [NSMutableDictionary dictionary];
		NSEnumerator * E = context4iTM3Dictionary.keyEnumerator;
		NSString * key;
		while(key = E.nextObject)
		{
			NS_DURING
			[attributes setObject:[NSArchiver archivedDataWithRootObject:[context4iTM3Dictionary objectForKey:key]] forKey:key];
			NS_HANDLER
			[NSApp reportException:localException];
			NS_ENDHANDLER
		}
//		BOOL needsToUpdate4iTM3 = self.needsToUpdate4iTM3;
		[DFM changeExtendedFileAttributes4iTM3:[attributes.copy autorelease] inSpace:[NSNumber numberWithUnsignedInteger:'iTM2'] atPath:absoluteURL.path error:nil];
//		[DFM changeExtendedFileAttributes4iTM3:[attributes.copy autorelease] atPath:fullDocumentPath forNameSpace:@"org_tug_mac_iTM2" error:nil];
	}
//END4iTM3;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  showWindowsBelowFront
- (void)showWindowsBelowFront:(id)sender;
/*"Description Forthcoming.
Version History: Originally created by JL.
To do list:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[self.windowControllers makeObjectsPerformSelector:@selector(showWindowBelowFront:) withObject:sender];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  environmentForExternalHelper
- (NSDictionary *)environmentForExternalHelper;
/*"Description Forthcoming.
Version History: Originally created by JL.
To do list:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return nil;
}
#pragma mark =-=-=-=-=-  URLs
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  absoluteFileURL4iTM3
- (NSURL *)absoluteFileURL4iTM3;
/*"Description Forthcoming.
Version History: Originally created by JL.
To do list:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return self.fileURL.absoluteURL;
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
    return self.absoluteFileURL4iTM3;
}
@end

@interface iTM2Document()
@property (readwrite,assign) id implementation;
@end
@interface NSObject(PRIVATE)
- (NSString *)context4iTM3DictionaryPath;
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
{DIAGNOSTIC4iTM3;
	INIT_POOL4iTM3;
//START4iTM3;
    [super initialize];
    [SUD registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithBool:NO], iTM2UDKeepBackupFileKey,
                nil]];
    if (!_iTM2GetResourceSelectors)
        _iTM2GetResourceSelectors = [[NSMutableDictionary dictionary] retain];
    if (!_iTM2SetResourceSelectors)
        _iTM2SetResourceSelectors = [[NSMutableDictionary dictionary] retain];
    if (!_iTM2LoadExtendedAttributesSelectors)
        _iTM2LoadExtendedAttributesSelectors = [[NSMutableArray array] retain];
    if (!_iTM2GetExtendedAttributesSelectors)
        _iTM2GetExtendedAttributesSelectors = [[NSMutableArray array] retain];
	RELEASE_POOL4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  init
- (id)init;
/*"Designated intializer.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if ((self = [super init])) {
        [self setUndoManager:[[[iTM2UndoManager alloc] init] autorelease]];
        [self.undoManager setLevelsOfUndo:[SUD integerForKey:iTM2UDLevelsOfUndoKey]];
        [INC addObserver:self
            selector:@selector(userDefaultsDidChange:)
                name:iTM2UserDefaultsDidChangeNotification
                    object:SUD];
        [self userDefaultsDidChange:[NSNotification notificationWithName:iTM2UserDefaultsDidChangeNotification
                    object:SUD]];
        self.initImplementation;
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return;
}
NSString * const iTM2DKDirectoryURLKey = @"directoryURL";
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setFileURL:
- (void)setFileURL:(NSURL *) url;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (08/29/2001):
Latest Revision: Wed Mar 31 06:48:21 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[super setFileURL:url];
	DEBUGLOG4iTM3(0,@"The new file url is:%@", url);
	self.updateContext4iTM3Manager;
    for (NSWindowController * WC in self.windowControllers) {
        WC.window.validateContent4iTM3;
    }
    [IMPLEMENTATION takeMetaValue:nil forKey:iTM2DKDirectoryURLKey];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  directoryURL
- (NSURL *)directoryURL;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (08/29/2001):
- 1.3:03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSURL * result = [IMPLEMENTATION metaValueForKey:iTM2DKDirectoryURLKey];
    if (!result) {
        [IMPLEMENTATION takeMetaValue:[self.fileURL URLByDeletingLastPathComponent] forKey:iTM2DKDirectoryURLKey];
        result = [IMPLEMENTATION metaValueForKey:iTM2DKDirectoryURLKey];
    }
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= fileAttributes
- (NSDictionary *)fileAttributes;
/*"Description forthcoming."*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [IMPLEMENTATION metaValueForKey:iTM2DFileAttributesKey];
}
#pragma mark =-=-=-=-=-=-=-=  MODEL OBJECT
@synthesize implementation=implementation4iTM3;
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  isDocumentEdited
- (BOOL)isDocumentEdited;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed 05 mar 03
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (super.isDocumentEdited) {
        return YES;
    }
    for (NSWindowController * WC in self.windowControllers) {
        if (WC.isInspectorEdited) {
            return YES;
        }
    }
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
	return [self inspectorAddedWithMode:mode error:nil];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inspectorAddedWithMode:error:
- (id)inspectorAddedWithMode:(NSString *) mode error:(NSError**)outErrorPtr;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (!mode)
    {
        LOG4iTM3(@"No mode given");
        return nil;
    }
    NSEnumerator * e = self.windowControllers.objectEnumerator;
    NSWindowController * WC;
    while(WC = e.nextObject)
	{
        if ([[WC.class inspectorMode] isEqual:mode])
		{
            return WC;
		}
	}
    NSMutableDictionary * MD = (NSMutableDictionary *)[[[self context4iTM3DictionaryForKey:iTM2ContextInspectorVariants domain:iTM2ContextAllDomainsMask] mutableCopy] autorelease];
    if (!MD)
    {
        MD = [NSMutableDictionary dictionary];
        [self takeContext4iTM3Value:MD forKey:iTM2ContextInspectorVariants domain:iTM2ContextAllDomainsMask];
    }
    NSString * type = [self.class inspectorType4iTM3];
    NSArray * variants = [MD objectForKey:mode];
    Class C = Nil;
    if ([variants isKindOfClass:[NSArray class]])
    {
        e = variants.objectEnumerator;
        NSString * variant;
        while(variant = e.nextObject)
        {
            if (C = [NSWindowController inspectorClassForType:type mode:mode variant:variant])
            {
                WC = [[[C alloc] initWithWindowNibName:[C windowNibName]] autorelease];
				[WC setInspectorVariant:variant];
                [self addWindowController:WC];
                if (WC.window)
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
				LOG4iTM3(@"%@",[NSString stringWithFormat:@"Unknown inspector type:\n%@\nfor mode:\n%@\nfor variants:\n%@", type, mode,variants]);
			}
        }
    }
    [MD removeObjectForKey:mode];
    [self takeContext4iTM3Value:MD forKey:iTM2ContextInspectorVariants domain:iTM2ContextAllDomainsMask];
    if (C = [NSWindowController inspectorClassForType:type mode:mode variant:iTM2DefaultInspectorVariant])
    {
        WC = [[[C alloc] initWithWindowNibName:[C windowNibName]] autorelease];
        [self addWindowController:WC];
		[WC setInspectorVariant:iTM2DefaultInspectorVariant];
        if (WC.window)
		{
            return WC;
		}
        else
		{
            [self removeWindowController:WC];
		}
    }
	NSArray * inspectorClasses = [NSWindowController inspectorClassesForType:type mode:mode];
    if (inspectorClasses.count && (C = [inspectorClasses objectAtIndex:ZER0]))
    {
        WC = [[[C alloc] initWithWindowNibName:[C windowNibName]] autorelease];
        [self addWindowController:WC];
		[WC setInspectorVariant:[C inspectorVariant]];
        if (WC.window)
		{
            return WC;
		}
        else
		{
            [self removeWindowController:WC];
		}
    }
//LOG4iTM3(@"NO INSPECTOR for type %@ mode:%@", type, mode);
    return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  replaceInspectorMode:variant:
- (void)replaceInspectorMode:(NSString *) mode variant:(NSString *) variant;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Jan  4 09:17:42 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSWindow * W = self.frontWindow;
	NSWindowController * currentWC = W.windowController;
	currentWC = [[currentWC retain] autorelease];
	if (currentWC)
	{
		if ([[currentWC.class inspectorMode] isEqual:mode]
				&& [currentWC.inspectorVariant isEqual:variant])
		{
			if (iTM2DebugEnabled)
			{
				LOG4iTM3(@"The inspector mode and variant are already in place:%@, %@", mode, variant);
			}
			return;
		}
		if (currentWC.isWindowLoaded)
		{
			[currentWC.window orderOut:self];
		}
		if (iTM2DebugEnabled)
		{
			LOG4iTM3(@"Removing the window controller:%@", currentWC);
		}
		[self removeWindowController:currentWC];
	}
    Class C = Nil;
	NSString * type = [self.class inspectorType4iTM3];
	if ([mode isEqual:iTM2ExternalInspectorMode])
	{
		if ([iTM2ExternalInspectorServer objectForType:type key:variant])
		{
			C = iTM2ExternalInspector.class;
		}
	}
	else
	{
		C = [NSWindowController inspectorClassForType:type mode:mode variant:variant];
	}
	if (C == [currentWC class])
	{
		// no change
		return;
	} else if (C) {
		//  first add a new window controller to prevent closeIfNeeded to close the project document
#warning BUG, the closeIfNeeded does not seem to close all the windows of the project, more...
        //  when I first removed the old WC, closeIfNeeded was called and the project document was closed
        //  Then the window menu was updated and there was still a window for that closed document
        //  of course, the document of that window was garbage, which caused an exception to be raised
		NSWindowController * WC = [[[C alloc] initWithWindowNibName:NSStringFromClass(C)] autorelease];
		[WC setInspectorVariant:variant];
        [self addWindowController:WC];
		NSWindow * W;
        if ((W = WC.window)) {
            [W makeKeyAndOrderFront:self];
            //  now there is a visible window,
            //  the closeIfNeeded (sent when removing a window controller) will not close the project document
			//  then remove the old WC
			DEBUGLOG4iTM3(0,@"Removing the window controller:%@", currentWC);
			[self removeWindowController:currentWC];
			// remove the external inspectors... if necessary, WHY?
			for (WC in self.windowControllers) {
				if ([WC isKindOfClass:[iTM2ExternalInspector class]]) {
					[self removeWindowController:WC];
				}
			}
        } else {
			LOG4iTM3(@"No window for mode %@, and variant %@", mode, variant);
            [self removeWindowController:WC];
		}
    } else {
		LOG4iTM3(@"No inspector class found for mode %@, and variant %@", mode, variant);
	}
	// just in case, things did not work properly
	if (!self.windowControllers.count && currentWC) {
		[self addWindowController:currentWC];
		[currentWC.window orderFront:self];
	}
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  addWindowController:
- (void)addWindowController:(NSWindowController *) WC;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (!WC)
        return;
    Class C = WC.class;
	#if 0
	THIS IS BUGGY DESIGN, REALLY
	THE WC IS EXPECTED TO BE RETAINED!!!
    if ([C isInstanceUnique])
    {
        NSEnumerator * E = self.windowControllers.objectEnumerator;
        id wc;
        while(wc = E.nextObject)
            if (wc.class == C)
                return;
    }
	#endif
    for (NSWindowController * wc in self.windowControllers) {
        if ([wc class] == C) {
            LOG4iTM3(@"THERE IS ALREADY A WINDOW CONTROLLER:new %@, old %@", WC, wc);
        }
    }
    [super addWindowController:WC];
	NSString * inspectorVariant = [C inspectorVariant];
	if (![inspectorVariant hasPrefix:@"."]) {
		NSDictionary * D = [self context4iTM3DictionaryForKey:iTM2ContextInspectorVariants domain:iTM2ContextAllDomainsMask];
		if (!D)
			D = [NSDictionary dictionary];
		NSMutableDictionary * MD = [[D mutableCopy] autorelease];
		NSArray * RA = [MD objectForKey:[C inspectorMode]];
		if (!RA) {
			RA = [NSArray array];
		}
		NSMutableArray * MRA = [[RA mutableCopy] autorelease];
		[MRA removeObject:inspectorVariant];
		[MRA insertObject:inspectorVariant atIndex:ZER0];
		[MD setObject:MRA forKey:[C inspectorMode]];
		[self takeContext4iTM3Value:MD forKey:iTM2ContextInspectorVariants domain:iTM2ContextStandardLocalMask|iTM2ContextExtendedMask];
	}
	if (![WC isKindOfClass:[iTM2ExternalInspector class]])
		[self didAddWindowController:WC];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= didAddWindowController:
- (void)didAddWindowController:(NSWindowController *) WC;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	WC.synchronizeWithDocument;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  removeWindowController:
- (void)removeWindowController:(NSWindowController *) windowController;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (windowController) {
		if (windowController.isWindowLoaded)
			[windowController.window orderOut:self];// don't performCloses:, it leads to an infinite loop...
        if (![windowController isKindOfClass:[iTM2ExternalInspector class]]) {
			[self willRemoveWindowController:windowController];
        }
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  makeWindowControllers
- (void)makeWindowControllers;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSWindowController * WC = nil;
	for (WC in self.windowControllers) {
		if (![[[WC class] inspectorMode] hasPrefix:@"."])
			return;
	}

    NSArray * modes = [self context4iTM3ValueForKey:iTM2ContextOpenInspectors domain:iTM2ContextAllDomainsMask];
    if ([modes isKindOfClass:[NSArray class]]) {
        NSMutableArray * alreadyOpenModes = [NSMutableArray array];
		NSString * inspectorType4iTM3 = [self.class inspectorType4iTM3];
		NSURL * fileURL = self.fileURL;
        for (NSDictionary * d in modes) {
//LOG4iTM3(@"d is:%@", d);
			if (![alreadyOpenModes containsObject:d]) {
				NSString * type = [d objectForKey:@"type"];
				NSString * mode = [d objectForKey:@"mode"];
				NSString * variant = [d objectForKey:@"variant"];
				if ([type isEqual:inspectorType4iTM3]) {
					if ([mode hasPrefix:@"."]) {
						;// do nothing
					} else {
						Class C = [NSWindowController inspectorClassForType:type mode:mode variant:variant];
						WC = [[[C alloc] initWithWindowNibName:[C windowNibName]] autorelease];
						[WC setInspectorVariant:variant];
						[self addWindowController:WC];// 1ZT
						if (!WC.window)// EXC_BAD_ACCESS HERE!!!
							[self removeWindowController:WC];
					}
				} else if ([mode isEqual:iTM2ExternalInspectorMode]
					&& fileURL.isFileURL
						&& [iTM2ExternalInspectorServer objectForType:inspectorType4iTM3 key:variant])
						// there is an external inspector for that type/variant pair
				{
					for (WC in self.windowControllers) {
						if ([WC isKindOfClass:[iTM2ExternalInspector class]]) {
							[self removeWindowController:WC];
                        }
                    }
					WC = [[[iTM2ExternalInspector alloc] initWithWindowNibName:@"iTM2ExternalInspector"] autorelease];
					[WC setInspectorVariant:variant];
					[self addWindowController:WC];
					if (!WC.window) {
						[self removeWindowController:WC];
                    }
				}
			}
			[alreadyOpenModes addObject:d];
		}
        if (self.windowControllers.count) {
           return;
        }
    }
    self.makeDefaultInspector;
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  makeDefaultInspector
- (void)makeDefaultInspector;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (!self.windowControllers.count)
    {
        NSString * documentType = self.fileURL.pathExtension.lowercaseString;
        NSDictionary * contextVariants = [self context4iTM3DictionaryForKey:iTM2ContextInspectorVariants domain:iTM2ContextAllDomainsMask];
        NSDictionary * D = [contextVariants objectForKey:documentType];
		NSString * inspectorMode = [D objectForKey:@"mode"];
		if (!inspectorMode)
		{
			NSDictionary * SUDVariants = [SUD dictionaryForKey:iTM2SUDInspectorVariants];
			D = [SUDVariants objectForKey:documentType];
			inspectorMode = [D objectForKey:@"mode"];
			if (!inspectorMode)
			{
				documentType = self.fileType;
				D = [contextVariants objectForKey:documentType];
				inspectorMode = [D objectForKey:@"mode"];
				if (!inspectorMode)
				{
					D = [SUDVariants objectForKey:documentType];
					inspectorMode = [D objectForKey:@"mode"];
					if (!inspectorMode)
					{
						goto here;
					}
				}
			}
		}
		if ([inspectorMode hasPrefix:@"."])
		{
			goto here;
		}
		NSString * inspectorVariant = [D objectForKey:@"variant"];
		NSString * inspectorType4iTM3 = nil;
		if (![inspectorVariant hasPrefix:@"."])
		{
			inspectorType4iTM3 = [self.class inspectorType4iTM3];
			Class C = [NSWindowController inspectorClassForType:inspectorType4iTM3 mode:inspectorMode variant:inspectorVariant];
			if (C)
			{
				NSWindowController * WC = [[[C alloc] initWithWindowNibName:[C windowNibName]] autorelease];
				[self addWindowController:WC];
				NSWindow * W = WC.window;
				if (W)
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
		inspectorType4iTM3 = [self.class inspectorType4iTM3];
		NSEnumerator * E = [[NSWindowController inspectorModesForType:inspectorType4iTM3] objectEnumerator];
		while(inspectorMode = E.nextObject)
		{
			if (![inspectorMode hasPrefix:@"."])
			{
				NSWindowController * WC = [self inspectorAddedWithMode:inspectorMode];
				if (WC.window)
				{
					return;
				}
			}
		}
        REPORTERROR4iTM3(1,@"NO DEFAULT INSPECTOR: I don't know what to do!!!\nPerhaps a missing plug-in?",nil);
    }
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  synchronizeWindowControllers
- (BOOL)synchronizeWindowControllers;
/*"This prevents the inherited methods to automatically load the data.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self.windowControllers makeObjectsPerformSelector:@selector(synchronizeWithDocument)];
//END4iTM3;
    return self.windowControllers.count>ZER0;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  synchronizeWithWindowControllers
- (void)synchronizeWithWindowControllers;
/*"This prevents the inherited methods to automatically load the data.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self.windowControllers makeObjectsPerformSelector:@selector(synchronizeDocument)];
//END4iTM3;
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
	return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  readFromURL:ofType:error:
- (BOOL)readFromURL:(NSURL *)absoluteURL ofType:(NSString *)typeName error:(NSError **)outErrorPtr
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (iTM2DebugEnabled>99)
	{
		LOG4iTM3(@"absoluteURL:%@", absoluteURL);
		LOG4iTM3(@"typeName:%@", typeName);
	}
	if (outErrorPtr)
	{
		*outErrorPtr = nil;
	}
	NSError ** localErrorRef = nil;
	[self readContextFromURL:absoluteURL ofType:typeName error:localErrorRef];
	if (localErrorRef)
	{
		[SDC presentError:*localErrorRef];
		localErrorRef = nil;
	}
	[super readFromURL:absoluteURL ofType:typeName error:outErrorPtr];
    NSMethodSignature * sig0 = [self methodSignatureForSelector:_cmd];
    NSInvocation * I = [NSInvocation invocationWithMethodSignature:sig0];
    I.target = self;
    [I setArgument:&absoluteURL atIndex:2];
    [I setArgument:&typeName atIndex:3];
    [I setArgument:&localErrorRef atIndex:4];
    BOOL result = YES;
	// BEWARE, the didReadFromURL:ofType:methods are not called here because they do not have the appropriate signature!
	NSPointerArray * PA = [iTM2Runtime instanceSelectorsOfClass:self.class withSuffix:@"CompleteReadFromURL4iTM3:ofType:error:" signature:sig0 inherited:YES];
	NSUInteger i = PA.count;
	while(i--)
	{
		[I setSelector:(SEL)[PA pointerAtIndex:i]];
        I.invoke;
        BOOL R = NO;
        [I getReturnValue:&R];
        result = result && R;
		if (localErrorRef)
		{
			[SDC presentError:*localErrorRef];
			localErrorRef = nil;
		}
    }
	if (result)
	{
		[self didReadFromURL:absoluteURL ofType:typeName error:localErrorRef];
		if (localErrorRef)
		{
			[SDC presentError:*localErrorRef];
			localErrorRef = nil;
		}
	}
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= dataCompleteReadFromURL4iTM3:ofType:error:
- (BOOL)dataCompleteReadFromURL4iTM3:(NSURL *)absoluteURL ofType:(NSString *)typeName error:(NSError **)outErrorPtr;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//LOG4iTM3(@"fullDocumentPath:%@", fullDocumentPath);
//END4iTM3;
	BOOL isDirectory;
	NSString * fullDocumentPath = absoluteURL.path;
	if ([DFM fileExistsAtPath:fullDocumentPath isDirectory:&isDirectory] && isDirectory)
		return YES;
	NSData * D = [NSData dataWithContentsOfURL:absoluteURL options:ZER0 error:outErrorPtr];
    return [self loadDataRepresentation:D ofType:typeName];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= resourcesCompleteReadFromURL4iTM3:ofType:error:
- (BOOL)resourcesCompleteReadFromURL4iTM3:(NSURL *)absoluteURL ofType:(NSString *) type error:(NSError**)outErrorPtr;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSString * fullDocumentPath = absoluteURL.path;
//LOG4iTM3(@"fullDocumentPath:%@", fullDocumentPath);
	BOOL isDirectory;
	if ([DFM fileExistsAtPath:fullDocumentPath isDirectory:&isDirectory] && isDirectory)
		return YES;
    NSMapTable * selectors = [_iTM2SetResourceSelectors objectForKey:[self.class description]];
    NSMethodSignature * sig0 = [self methodSignatureForSelector:@selector(loadIDResourceTemplate:)];
    if (!selectors)
    {
		NSMapTable * Ss = [NSMapTable mapTableWithKeyOptions:NSPointerFunctionsOpaqueMemory|NSPointerFunctionsOpaquePersonality
												valueOptions:NSPointerFunctionsStrongMemory|NSPointerFunctionsOpaquePersonality];
		NSPointerArray * PA = [iTM2Runtime instanceSelectorsOfClass:self.class withSuffix:@"IDResource4iTM3:" signature:sig0 inherited:YES];
		NSUInteger i = PA.count;
		while(i--)
		{
			SEL selector = (SEL)[PA pointerAtIndex:i];
			const char * name = [NSStringFromSelector(selector) UTF8String];
			unsigned int hexa;
            if (sscanf(name, "load%u", &hexa))
            {
				NSInteger key = hexa;
				NSMapInsert(Ss,(void *)key,selector);
            }
        }
        [_iTM2SetResourceSelectors setValue:Ss forKey:[self.class description]];
        selectors = [_iTM2SetResourceSelectors objectForKey:[self.class description]];
    }
    if (selectors.count)
    {
        FSRef ref;
        if (CFURLGetFSRef((CFURLRef)[NSURL fileURLWithPath:fullDocumentPath], &ref))
        {
			short curResFile = CurResFile();
			OSErr resError;
			BOOL wasCurResFile = (noErr == ResError());
			short refNum = FSOpenResFile(&ref, fsRdPerm);
			if (resError = ResError())
			{
				LOG4iTM3(@"1 - Could not FSOpenResFile, error %i (refNum:%i)", resError, refNum);
				return YES;
			}
			UseResFile(refNum);
			if (resError = ResError())
			{
				LOG4iTM3(@"2 - Could not UseResFile, error %i (refNum:%i)", resError, refNum);
				CloseResFile(refNum);
				return YES;
			}
			OSType resourceType = [[NSBundle mainBundle] bundleHFSCreatorCode4iTM3];
			SInt16 resourceIndex = Count1Resources(resourceType);
			NSInvocation * I = [NSInvocation invocationWithMethodSignature:sig0];
			I.target = self;
			nextLoop:
			while(resourceIndex)
			{
				Handle H = Get1IndResource(resourceType, resourceIndex);
				if ((resError = ResError()) || !H)
				{
					LOG4iTM3(@"3 - Could not Get1Resource, error %i (resourceIndex is %i)", resError, resourceIndex);
					OUTERROR4iTM3(2,([NSString stringWithFormat:@"3 - Could not Get1Resource, error %i (resourceIndex is %i)", resError, resourceIndex]),nil);
					--resourceIndex;
					goto nextLoop;
				}
				if (iTM2DebugEnabled)
				{
					LOG4iTM3(@"4 - Could use Get1Resource, error %i (resourceIndex is %i)", resError, resourceIndex);
				}
				SInt16 resourceID = 0;
				GetResInfo(H, &resourceID, nil, nil);
				if (resError = ResError())
				{
					LOG4iTM3(@"5 - Could not GetResInfo, error %i (resourceIndex is %i)", resError, resourceIndex);
					OUTERROR4iTM3(3,([NSString stringWithFormat:@"5 - Could not GetResInfo, error %i (resourceIndex is %i)", resError, resourceIndex]),nil);
					--resourceIndex;
					goto nextLoop;
				}
				if (iTM2DebugEnabled)
				{
					LOG4iTM3(@"6 - Could use GetResInfo, error %i (resourceIndex is %i)", resError, resourceIndex);
				}
				HLock(H);
				NSData * D = [NSData dataWithBytes:*H length:GetHandleSize(H)];
				HUnlock(H);
				ReleaseResource(H);
				if (resError = ResError())
				{
					LOG4iTM3(@"7 - Could not ReleaseResource, error %i (resourceIndex is %i)", resError, resourceIndex);
					OUTERROR4iTM3(3,([NSString stringWithFormat:@"7 - Could not ReleaseResource, error %i (resourceIndex is %i)", resError, resourceIndex]),nil);
				}
				id resourceContent = [NSUnarchiver unarchiveObjectWithData:D];
				if (resourceContent)
				{
					[I setArgument:&resourceContent atIndex:2];
					void * key = (void *)(NSUInteger)resourceID;
					SEL selector = NSMapGet(selectors,key);
					if (selector)
					{
						[I setSelector:selector];
						I.invoke;
						if (iTM2DebugEnabled>99)
						{
							LOG4iTM3(@"Read resource with ID:%u", resourceID);
						}
					}
					else if (iTM2DebugEnabled>99)
					{
						LOG4iTM3(@"INFO:Dont know how to read resource with ID:%u", resourceID);
					}
				}
				else
				{
					LOG4iTM3(@"ERROR:Could not read resource with ID:%u", resourceID);
					OUTERROR4iTM3(3,([NSString stringWithFormat:@"ERROR:Could not read resource with ID:%u", resourceID]),nil);
				}
				--resourceIndex;
			}
			CloseResFile(refNum);
			if (resError = ResError())
			{
				LOG4iTM3(@"8 - Could not CloseResFile, error %i", resError);
				OUTERROR4iTM3(3,([NSString stringWithFormat:@"8 - Could not CloseResFile, error %i", resError]),nil);
			}
			if (wasCurResFile)
			{
				UseResFile(curResFile);
				if (resError = ResError())
				{
					LOG4iTM3(@"9 - Could not UseResFile, error %i", resError);
					OUTERROR4iTM3(3,([NSString stringWithFormat:@"9 - Could not UseResFile, error %i", resError]),nil);
				}
			}
		}
    }
//END4iTM3;
    return YES;// even if the resources could not be saved...
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= loadIDResourceTemplate:
- (void)loadIDResourceTemplate:(id) resourceContent;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= didReadFromURL:ofType:error:
- (void)didReadFromURL:(NSURL *)absoluteURL ofType:(NSString *) type error:(NSError**)error;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSDictionary * fileAttributes = [DFM attributesOfItemOrDestinationOfSymbolicLinkAtURL4iTM3:(absoluteURL?:self.fileURL) error:NULL];
    [IMPLEMENTATION takeMetaValue:fileAttributes forKey:iTM2DFileAttributesKey];
    [IMPLEMENTATION updateChildren];
	self.synchronizeWindowControllers;
    [IMPLEMENTATION didRead];
    NSInvocation * I;
	[[NSInvocation getInvocation4iTM3:&I withTarget:self retainArguments:NO] didReadFromURL:absoluteURL ofType:type error:error];
	[I invokeWithSelectors4iTM3:[iTM2Runtime instanceSelectorsOfClass:self.class withSuffix:@"CompleteDidReadFromURL4iTM3:ofType:error:" signature:[I methodSignature] inherited:YES]];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  _0213_DidWriteToURL:ofType:forSaveOperation:originalContentsURL:error:
- (void)_0213_DidWriteToURL:(NSURL *)absoluteURL ofType:(NSString *)typeName forSaveOperation:(NSSaveOperationType) saveOperation originalContentsURL:(NSURL *)absoluteOriginalContentsURL error:(NSError**)error;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return;
}
#if 0
#warning !FAILED DEBUG CODE HERE
- (void)runModalSavePanelForSaveOperation:(NSSaveOperationType)saveOperation delegate:(id)delegate didSaveSelector:(SEL)didSaveSelector contextInfo:(void *)contextInfo;
{
	LOG4iTM3(@"saveOperation:%i",saveOperation);
	LOG4iTM3(@"delegate:%@",delegate);
	LOG4iTM3(@"didSaveSelector:%@",NSStringFromSelector(didSaveSelector));
	LOG4iTM3(@"contextInfo:%@",contextInfo);
	[super runModalSavePanelForSaveOperation:(NSSaveOperationType)saveOperation delegate:(id)delegate didSaveSelector:(SEL)didSaveSelector contextInfo:(void *)contextInfo];
	return;
}
- (BOOL)writeSafelyToURL:(NSURL *)absoluteURL ofType:(NSString *)typeName forSaveOperation:(NSSaveOperationType)saveOperation error:(NSError **)outError;
{
	LOG4iTM3(@"absoluteURL:%@",absoluteURL);
	LOG4iTM3(@"typeName:%@",typeName);
	LOG4iTM3(@"saveOperation:%i",saveOperation);
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
	// Prepare the background
	// only file URLs are supported
	if (!absoluteURL.isFileURL)
	{
		OUTERROR4iTM3(1,([NSString stringWithFormat:@"Only file URLs are supported for writing to."]),nil);
		return NO;
	}
	NSString * fullDocumentPath = absoluteURL.path;
	NSString * fullOriginalDocumentPath = nil;
	if (absoluteOriginalContentsURL && !absoluteOriginalContentsURL.isFileURL)
	{
		OUTERROR4iTM3(1,([NSString stringWithFormat:@"Only file URLs are supported for original contents."]),nil);
		// do not return
	}
	else
	{
		fullOriginalDocumentPath = absoluteOriginalContentsURL.path;
	}
	// is there something at the target URL?
	// The problem is that I don't know what to do in such a situation because I don't know for sure whether the cocoa framework
	// tries to override an existing file with the user permission
	// In order to be safe, recycle the target url to the trash, but this can break things!
#if 0
	Be confident in cocoa otherwise things are broken with continuous typesetting
	NSArray * files;
	NSInteger tag = ZER0;
	if ([DFM fileExistsAtPath:fullDocumentPath] || [DFM destinationOfSymbolicLinkAtPath:fullDocumentPath error:NULL])
	{
		// try to recycle it
		dirName = fullDocumentPath.stringByDeletingLastPathComponent;
		baseName = fullDocumentPath.lastPathComponent;
		files = [NSArray arrayWithObject:baseName];
		if ([SWS performFileOperation:NSWorkspaceRecycleOperation source:dirName destination:@"" files:files tag:&tag])
		{
			LOG4iTM3(@"Recycling\n%@...", fullDocumentPath);
		}
		else
		{
			OUTERROR4iTM3(tag,([NSString stringWithFormat:@"Could not recycle already existing file at save location."]),nil);
			LOG4iTM3(@"**** WARNING: Don't be surprised if things don't work as expected...");
			return NO;
		}
	}
#endif
//LOG4iTM3(@"$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$");
	if (iTM2DebugEnabled>99)
	{
		LOG4iTM3(@"absoluteURL:%@", absoluteURL);
		NSLog(@"typeName:%@", typeName);
		NSLog(@"saveOperation:%i", saveOperation);
		NSLog(@"absoluteOriginalContentsURL:%@", absoluteOriginalContentsURL);
		NSLog(@"error: %#x", outErrorPtr);
		NSLog(@"Directory exists:%@", ([DFM fileExistsAtPath:absoluteURL.path.stringByDeletingLastPathComponent]? @"YES":@"NO"));
	}
	self.willSave;
    // just duplicate the original content if it is not a file: respect the third parties that will certainly write things inside the folder.
    // question are the resource forks respected?
    BOOL result = YES;
    if (![fullDocumentPath pathIsEqual4iTM3:fullOriginalDocumentPath])
    {
		// only copy original contents if this is a directory and the expected destination is a wrapper package
		if ([typeName conformsToUTType4iTM3:(NSString *)kUTTypePackage])
		{
			// I must create a directory at the expected location, either by copying a directory or not...
			fullOriginalDocumentPath = [fullOriginalDocumentPath stringByResolvingSymlinksAndFinderAliasesInPath4iTM3];
            absoluteOriginalContentsURL = absoluteOriginalContentsURL.URLByResolvingSymlinksAndFinderAliasesInPath4iTM3;
			if ([absoluteOriginalContentsURL isDirectoryOrError4iTM3:outErrorPtr])
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
                DFM.delegate = self;
                if ([DFM copyItemAtURL:absoluteOriginalContentsURL toURL:absoluteURL error:NULL])
                {
                    //LOG4iTM3(@"Copied from\n%@\nto\n%@", fullOriginalDocumentPath, fullDocumentPath);
                    NSString * date = [[NSDate date] description];
                    // no matter if it fails
                    [date writeToURL:[absoluteURL URLByAppendingPathComponent:@"DATE"] atomically:NO encoding:NSUTF8StringEncoding error:NULL];
                }
                else
                {
                    OUTERROR4iTM3(3,([NSString stringWithFormat:@"Could not copy from\n%@\nto\n%@", fullOriginalDocumentPath, fullDocumentPath]),nil);
                    LOG4iTM3(@"****  FAILURE: Could not copy from\n%@\nto\n%@", fullOriginalDocumentPath, fullDocumentPath);
                    result = NO;
                }
                DFM.delegate = nil;
            }
            else if ([absoluteOriginalContentsURL linkCountOrError4iTM3:outErrorPtr])
            {
                // this is an unexpected situation, notice the user in the log and ignore the original contents
                OUTERROR4iTM3(3,([NSString stringWithFormat:@"CONSISTENCY ERROR: the original URL does not point to a directory whereas the receiver is a package\n\
                    absoluteOriginalContentsURL:%@\nself.fileType:%@",absoluteOriginalContentsURL,self.fileType]),nil);
                LOG4iTM3(@"**** CONSISTENCY ERROR: the original URL does not point to a directory whereas the receiver is a package\n\
                    absoluteOriginalContentsURL:%@\nself.fileType:%@",absoluteOriginalContentsURL,self.fileType);
            }
			if ((![absoluteURL linkCountOrError4iTM3:outErrorPtr]
                    || ([absoluteURL isSymbolicLinkOrError4iTM3:outErrorPtr] && [DFM removeItemAtURL:absoluteURL error:outErrorPtr]))
				&& ![DFM createDirectoryAtPath:absoluteURL.path withIntermediateDirectories:YES attributes:nil error:NULL])
			{
				OUTERROR4iTM3(4,([NSString stringWithFormat:@"Could not create a directory at\n%@", absoluteURL]),nil);
				LOG4iTM3(@"FILE OPERATION FAILURE: Could not create a directory at\n%@(can write?%@)", absoluteURL,([DFM isWritableFileAtPath:absoluteURL.URLByDeletingLastPathComponent.path]?@"Y":@"N"));            
				return NO;
			}
		}
		else if ([SUD boolForKey:@"iTM2PreserveResourceFork"])
		{
			NSURL * url = [absoluteOriginalContentsURL URLByAppendingPathComponent:@"..namedfork/rsrc"];
			NSData * D = [NSData dataWithContentsOfURL:url];
			if (D.length)
			{
				url = [absoluteURL URLByAppendingPathComponent:@"..namedfork/rsrc"];
				[D writeToURL:url options:NSAtomicWrite error:outErrorPtr];
			}
		}
	}
    NSInvocation * I;
	[[NSInvocation getInvocation4iTM3:&I withTarget:self retainArguments:NO] writeToURL:absoluteURL ofType:typeName forSaveOperation:saveOperation originalContentsURL:absoluteOriginalContentsURL error:outErrorPtr];
	NSPointerArray * PA = [iTM2Runtime instanceSelectorsOfClass:self.class withSuffix:@"CompleteWriteToURL4iTM3:ofType:forSaveOperation:originalContentsURL:error:" signature:I.methodSignature inherited:YES];
	NSUInteger i = PA.count;
	while(i--) {
		[I setSelector:(SEL)[PA pointerAtIndex:i]];
        I.invoke;
        BOOL R = NO;
        [I getReturnValue:&R];
        result = result && R;
    }
	if ((result = [self writeToURL:absoluteURL ofType:typeName error:outErrorPtr] && result))
    {
        if (saveOperation == NSSaveOperation || saveOperation == NSSaveAsOperation)
        {
            [IMPLEMENTATION takeMetaValue:[DFM attributesOfItemOrDestinationOfSymbolicLinkAtURL4iTM3:absoluteURL error:NULL] forKey:iTM2DFileAttributesKey];
        }
		[[NSInvocation getInvocation4iTM3:&I withTarget:self retainArguments:NO]
			_0213_DidWriteToURL:absoluteURL ofType:typeName forSaveOperation:saveOperation originalContentsURL:absoluteOriginalContentsURL error:outErrorPtr];
		[I invokeWithSelectors4iTM3:[iTM2Runtime instanceSelectorsOfClass:self.class withSuffix:@"CompleteDidWriteToURL4iTM3:ofType:forSaveOperation:originalContentsURL:error:" signature:[I methodSignature] inherited:YES]];
		self.didSave;
    }
//END4iTM3;
	if (iTM2DebugEnabled>99)
	{
		LOG4iTM3(@"FINAL DID WRITE? %@", (result? @"YES":@"NO"));
		LOG4iTM3(@"Result exists:%@", ([DFM fileExistsAtPath:fullDocumentPath]? @"YES":@"NO"));
	}
	if (!result)
	{
		LOG4iTM3(@"FAILURE\nabsoluteURL:%@\ntypeName:%@\nsaveOperation:%i\nabsoluteOriginalContentsURL:%@\nerror: %@",
			absoluteURL, typeName, saveOperation, absoluteOriginalContentsURL, (outErrorPtr?*outErrorPtr:nil));
	}
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  fileManager:shouldProceedAfterError:
-(BOOL)fileManager:(NSFileManager *)manager shouldProceedAfterError:(NSDictionary *)errorInfo;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
	if ([self context4iTM3BoolForKey:@"iTM2NoAlertAfterFileOperationError" domain:iTM2ContextAllDomainsMask]
		&& !iTM2DebugEnabled)
	{
		return NO;
	}
//START4iTM3;
    NSInteger result = NSRunCriticalAlertPanel([[NSBundle mainBundle] bundleName4iTM3], @"File operation error:\
            %@ with file: %@", @"Proceed Anyway", @"Cancel",  NULL, 
            [errorInfo objectForKey:@"Error"], 
            [errorInfo objectForKey:@"Path"]);
	LOG4iTM3(@"**** FILE MANAGER OPERATION ERROR: %@", errorInfo);
//END4iTM3;
    return (result == NSAlertDefaultReturn);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  writeToURL:ofType:error:
- (BOOL)writeToURL:(NSURL *)absoluteURL ofType:(NSString *) type error:(NSError**)outErrorPtr;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	BOOL superResult = [type conformsToUTType4iTM3:(NSString *)kUTTypePackage] || [super writeToURL:absoluteURL ofType:type error:outErrorPtr];
	BOOL result = YES;
	DEBUGLOG4iTM3(99,@"DID WRITE? %@", (result? @"YES":@"NO"));
	NSInvocation * I = nil;
	[[NSInvocation getInvocation4iTM3:&I withTarget:self retainArguments:NO] writeToURL:absoluteURL ofType:type error:outErrorPtr];
	NSPointerArray * PA = [iTM2Runtime instanceSelectorsOfClass:self.class withSuffix:@"CompleteWriteToURL4iTM3:ofType:error:" signature:I.methodSignature inherited:YES];
	NSUInteger i = 0;
	while (i < PA.count) {
		I.selector=(SEL)[PA pointerAtIndex:i++];
NSLog(@"%@",NSStringFromSelector(I.selector));
        I.invoke;//(gdb) po NSStringFromSelector((SEL)[I selector])
        BOOL R = NO;
        [I getReturnValue:&R];
        result = result && R;
        if (!R) {
            LOG4iTM3(@"FALSE:%@",NSStringFromSelector(I.selector));
        }
    }
	[self writeContextToURL:absoluteURL ofType:type error:outErrorPtr];
//END4iTM3;
    return result || superResult;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= dataCompleteWriteToURL4iTM3:ofType:error:
- (BOOL)dataCompleteWriteToURL4iTM3:(NSURL *)absoluteURL ofType:(NSString *) typeName error:(NSError **) outErrorPtr;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    if (outErrorPtr) *outErrorPtr = nil;
    if ([typeName conformsToUTType4iTM3:(NSString *)kUTTypeData]) {
        NSError * ROR = nil;
        NSData * D = [self dataOfType:typeName error:&ROR];
        DEBUGLOG4iTM3(99,@"is there any data to save? %@\nCurrently saving data with length:%i", (D? @"Y":@"N"),D.length);
        if (!D && ROR) {
            if (outErrorPtr) *outErrorPtr = ROR;
            return NO;
        } 
        return [(D? D:[NSData data]) writeToURL:absoluteURL options:NSAtomicWrite error:outErrorPtr];
    }
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= getIDResourceTemplate:
- (void)getIDResourceTemplate:(id *) resourceContentPtr;
/*"Description Forthcoming.
 Version history: jlaurens AT users DOT sourceforge DOT net
 - 2.0: Fri Sep 05 2003
 To Do List:
 "*/
{DIAGNOSTIC4iTM3;
	//START4iTM3;
	//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= resourcesCompleteWriteToURL4iTM3:ofType:error:
- (BOOL)resourcesCompleteWriteToURL4iTM3:(NSURL *) absoluteURL ofType:(NSString *) typeName error:(NSError**)outErrorPtr;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSString * fullDocumentPath = absoluteURL.path;
	if (!fullDocumentPath)
		return NO;
    NSMapTable * selectors = [_iTM2GetResourceSelectors objectForKey:[self.class description]];
    NSMethodSignature * sig0 = [self methodSignatureForSelector:@selector(getIDResourceTemplate:)];
    if (!selectors)
    {
		NSMapTable * Ss = [NSMapTable mapTableWithKeyOptions:NSPointerFunctionsOpaqueMemory|NSPointerFunctionsOpaquePersonality
												valueOptions:NSPointerFunctionsOpaqueMemory|NSPointerFunctionsOpaquePersonality];
		NSPointerArray * PA = [iTM2Runtime instanceSelectorsOfClass:self.class withSuffix:@"IDResource4iTM3:" signature:sig0 inherited:YES];
		NSUInteger i = PA.count;
		while(i--)
		{
			SEL selector = (SEL)[PA pointerAtIndex:i];
			const char * name = [NSStringFromSelector(selector) UTF8String];
			unsigned int hexa;
            if (sscanf(name, "get%u", &hexa))
            {
				NSUInteger key = hexa;
				NSMapInsert(Ss,(void *)key,selector);
            }
        }
        [_iTM2GetResourceSelectors setValue:Ss forKey:[self.class description]];
        selectors = [_iTM2GetResourceSelectors objectForKey:[self.class description]];
    }
    if (!selectors.count)
	{
		return YES;
	}
	short curResFile = CurResFile();
	BOOL wasCurResFile = (noErr == ResError());
	FSRef fsRef;
	NSURL * myURL = [NSURL fileURLWithPath:fullDocumentPath];
	if (!CFURLGetFSRef((CFURLRef)myURL, &fsRef))
	{
		if (iTM2DebugEnabled)
		{
			LOG4iTM3(@"CFURLGetFSRef error.");
		}
		return NO;
	}
	HFSUniStr255 resourceForkName;
	OSErr resError = FSGetResourceForkName (&resourceForkName);
	if (resError != noErr) {
		NSLog(@"FSGetResourceForkName error:%i.",resError);
		return -1;
	}
	resError = FSCreateResourceFork(&fsRef,resourceForkName.length,resourceForkName.unicode,0);
	if (resError == errFSForkExists) {
		if (iTM2DebugEnabled)
		{
			LOG4iTM3(@"FSCreateResourceFork error.%i==errFSForkExists(%i)",resError,errFSForkExists);
		}
	} else if (resError != noErr) {
		if (iTM2DebugEnabled)
		{
			LOG4iTM3(@"FSCreateResourceFork error.%i",resError);
		}
		return NO;
	}
	ResFileRefNum fileSystemReferenceNumber;
	if (resError = FSOpenResourceFile (&fsRef,resourceForkName.length,resourceForkName.unicode,fsRdWrPerm,&fileSystemReferenceNumber))
	{
		if (iTM2DebugEnabled)
		{
			LOG4iTM3(@"1 - Could not FSOpenResFile, at %@, error %i, fileSystemReferenceNumber: %i",fullDocumentPath,resError,fileSystemReferenceNumber);
		}
		CloseResFile(fileSystemReferenceNumber);
		OUTERROR4iTM3(kiTM2ExtendedAttributesResourceManagerError,([NSString stringWithFormat:@"1 - Could not FSOpenResFile, at %@, error %i, fileSystemReferenceNumber: %i",fullDocumentPath,resError,fileSystemReferenceNumber]),nil);
		return NO;
	}
	UseResFile(fileSystemReferenceNumber);
	if (resError = ResError())
	{
		if (iTM2DebugEnabled)
		{
			LOG4iTM3(@"2 - Could not UseResFile, at %@, error %i, fileSystemReferenceNumber: %i",fullDocumentPath,resError,fileSystemReferenceNumber);
		}
		OUTERROR4iTM3(kiTM2ExtendedAttributesResourceManagerError,([NSString stringWithFormat:@"2 - Could not UseResFile, at %@, error %i, fileSystemReferenceNumber: %i",fullDocumentPath,resError,fileSystemReferenceNumber]),nil);
		CloseResFile(fileSystemReferenceNumber);
		return NO;
	}
	OSType resourceType = [[NSBundle mainBundle] bundleHFSCreatorCode4iTM3];
	id resourceContent = nil;
	id * resourceContentPtr = &resourceContent;
	NSInvocation * I;
	[[NSInvocation getInvocation4iTM3:&I withTarget:self retainArguments:NO] getIDResourceTemplate:resourceContentPtr];
	NSMapEnumerator ME = NSEnumerateMapTable(selectors);
	NSUInteger hexa;
	SEL selector;
	while(NSNextMapEnumeratorPair(&ME, (void *)&hexa, (void *)&selector))
	{
		[I setSelector:selector];
		I.invoke;
		ResID resourceID = hexa;
		Handle H = Get1Resource(resourceType, resourceID);
		if (resError = ResError())
		{
			LOG4iTM3(@"3 - Could not Get1Resource, error %i", resError);
			OUTERROR4iTM3(2,([NSString stringWithFormat:@"3 - Could not Get1Resource, error %i", resError]),nil);
			continue;
		}
		if (H)
		{
			RemoveResource(H);
			DisposeHandle(H);
			H = nil;
		}
		NSData * D = [NSArchiver archivedDataWithRootObject:resourceContent];
		if (!D) D = [NSData data];
		if (resError = PtrToHand([D bytes], &H, D.length))
		{
			LOG4iTM3(@"4 - WARNING:Could not convert a Ptr into a handle, error %i", resError);
			OUTERROR4iTM3(2,([NSString stringWithFormat:@"4 - WARNING:Could not convert a Ptr into a handle"]),nil);
		}
		else
		{
			HLock(H);
			AddResource(H, resourceType, resourceID, (ConstStr255Param)"\0");
			HUnlock(H);
			if (resError = ResError())
			{
				LOG4iTM3(@"5 - Could not AddResource, error %i", resError);
				OUTERROR4iTM3(2,([NSString stringWithFormat:@"5 - Could not AddResource, error %i", resError]),nil);
				DisposeHandle(H);// hum the handle is considered the property of the resource manager now?
			}
			else if (iTM2DebugEnabled>99)
			{
				LOG4iTM3(@"6 - Resource added:%u", resourceID);
			}
			// DisposeHandle(H);// hum the handle is considered the property of the resource manager now?
		}
	}
	CloseResFile(fileSystemReferenceNumber);
	if (resError = ResError())
	{
		LOG4iTM3(@"7 - Could not CloseResFile, error %i", resError);
		OUTERROR4iTM3(2,([NSString stringWithFormat:@"7 - Could not CloseResFile, error %i", resError]),nil);
	}
	if (wasCurResFile)
	{
		UseResFile(curResFile);
		if (resError = ResError())
		{
			LOG4iTM3(@"8 - Could not UseResFile, error %i", resError);
			OUTERROR4iTM3(2,([NSString stringWithFormat:@"8 - Could not UseResFile, error %i", resError]),nil);
		}
	}
//END4iTM3;
    return YES;// even if the resources could not be saved...
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= willSave
- (void)willSave;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    self.synchronizeWithWindowControllers;
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [IMPLEMENTATION takeMetaValue:[DFM attributesOfItemOrDestinationOfSymbolicLinkAtURL4iTM3:self.fileURL error:NULL] forKey:iTM2DFileAttributesKey];
   for(id WC in self.windowControllers)
        [WC setDocumentEdited:NO];
    [IMPLEMENTATION didSave];
	NSInvocation * I;
	[[NSInvocation getInvocation4iTM3:&I withTarget:self retainArguments:NO] didSave];
	[I invokeWithSelectors4iTM3:[iTM2Runtime instanceSelectorsOfClass:self.class withSuffix:@"CompleteDidSave4iTM3" signature:[I methodSignature] inherited:YES]];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  dataOfType:error:
- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed 05 mar 03
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//NSLog(@"data: %@", result);
	if (outError) {
		* outError = nil;
	}
    return [IMPLEMENTATION dataOfType:typeName error:outError];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  loadDataRepresentation:ofType:
- (BOOL)loadDataRepresentation:(NSData *) data ofType:(NSString *) type;
/*"Returns YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1:05/04/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (outError) * outError = nil;
    return [self loadDataRepresentation:data ofType:typeName];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= dataRepresentation
- (NSData *)dataRepresentation;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1:03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [self dataOfType:self.modelType error:NULL];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= setDataRepresentation:
- (void)setDataRepresentation:(NSData *) data;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1:03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self loadDataRepresentation:data ofType:self.fileType];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  fileAttributesToWriteToURL:ofType:forSaveOperation:originalContentsURL:error:
- (NSDictionary *)fileAttributesToWriteToURL:(NSURL *)absoluteURL ofType:(NSString *)typeName forSaveOperation:(NSSaveOperationType)saveOperation originalContentsURL:(NSURL *)absoluteOriginalContentsURL error:(NSError **)outErrorPtr;
/*"From Developer/Documentation/Cocoa/TasksAndConcepts/ProgrammingTopics/Documents/Tasks/SavingHFSTypeCodes.html.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3:09/11/2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSMutableDictionary * newAttributes = [NSMutableDictionary dictionaryWithDictionary:
        [super fileAttributesToWriteToURL:absoluteURL ofType:typeName forSaveOperation:saveOperation originalContentsURL:absoluteOriginalContentsURL error:outErrorPtr]];
    NSDictionary *infoPlist = [[NSBundle mainBundle] infoDictionary];
    // First, set creatorCode to the HFS creator code for the application,
    // if it exists.
    NSString * creatorCodeString = [infoPlist objectForKey:@"CFBundleSignature"];
    if (creatorCodeString)
        [newAttributes setObject:[NSNumber numberWithUnsignedLong:
                        NSHFSTypeCodeFromFileType([NSString stringWithFormat:@"'%@'", creatorCodeString])]
            forKey:NSFileHFSCreatorCode];
    // Then, find the matching Info.plist dictionary entry for this type.
    // Use the first associated HFS type code, if any exist.
    NSEnumerator * E = [[infoPlist objectForKey:@"CFBundleDocumentTypes"] objectEnumerator];
    NSDictionary * D;
    while(D = E.nextObject)
    {
        NSString * type = [D objectForKey:@"CFBundleTypeName"];
        if ([type isEqualToString:typeName])
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [self context4iTM3BoolForKey:@"iTM2KeepBackup" domain:iTM2ContextAllDomainsMask];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  writeToDirectoryWrapper:error:
- (BOOL)writeToDirectoryWrapper:(NSFileWrapper *) DW error:(NSString **) errorStringRef;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed 05 mar 03
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (!self.fileURL.isFileURL) {
        return NO;
    }
    self.willSave;
    BOOL result = [IMPLEMENTATION writeToDirectoryWrapper:DW error:errorStringRef];
    self.didSave;
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  readFromDirectoryWrapper:error:
- (BOOL)readFromDirectoryWrapper:(NSFileWrapper *) DW error:(NSString **) errorStringRef;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed 05 mar 03
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (!self.fileURL.isFileURL) {
        return NO;
    }
    if ([IMPLEMENTATION readFromDirectoryWrapper:DW error:errorStringRef])
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSDictionary * FAs = self.fileAttributes;
    if (FAs)
    {
        NSDate * oldMD = FAs.fileModificationDate;
        NSDate * newMD = [DFM attributesOfItemOrDestinationOfSymbolicLinkAtURL4iTM3:self.fileURL error:NULL].fileModificationDate;
        return [newMD compare:oldMD] == NSOrderedDescending;
    }
    else
        return NO;
}
#pragma mark =-=-=-=-=-   CONTEXT
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  context4iTM3Dictionary
- (id)context4iTM3Dictionary;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    id CD = metaGETTER;
    if (!CD)
    {
        CD = [NSMutableDictionary dictionary];
        metaSETTER(CD);
    }
    return CD;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setContext4iTM3Dictionary:
- (void)setContext4iTM3Dictionary:(NSDictionary *) dictionary;
/*"Subclasses will most certainly override this method.
Default implementation returns the NSUserDefaults shared instance.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6:03/26/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	metaSETTER([dictionary.mutableCopy autorelease]);
    return;
}
#pragma mark =-=-=-=-=-   UPDATE
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= updateIfNeeded4iTM3Error:
- (BOOL)updateIfNeeded4iTM3Error:(NSError **)outErrorPtr;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Révisé par itexmac2: 2010-11-30 21:12:42 +0100
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return self.needsToUpdate4iTM3
        && [self saveContext4iTM3Error:outErrorPtr]
            && ([self readFromURL:self.fileURL ofType:self.fileType error:outErrorPtr],YES);
}
@end

#import "iTM2ObjectServer.h"
#import "iTM2BundleKit.h"
#import "iTM2NotificationKit.h"
#import <objc/objc-class.h>

@interface iTM2WindowControllerServer:iTM2ObjectServer
+ (void)WCCompleteInstallation4iTM3;
+ (BOOL)registerPlugInAtURL:(NSURL *) url;
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
{DIAGNOSTIC4iTM3;
	INIT_POOL4iTM3;
//START4iTM3;
	[super initialize];
    if (!_iTM2WindowControllerServerDictionary)
	{
		_iTM2WindowControllerServerDictionary = [[NSMutableDictionary dictionary] retain];
		[INC addObserver:[iTM2WindowControllerServer class] selector:@selector(bundleDidLoadNotified:) name:iTM2BundleDidLoadNotification object:nil];
		self.WCCompleteInstallation4iTM3;
	}
//END4iTM3;
	RELEASE_POOL4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  mutableDictionary
+ (NSMutableDictionary *)mutableDictionary;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return _iTM2WindowControllerServerDictionary;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  bundleDidLoadNotified:
+ (void)bundleDidLoadNotified:(NSNotification *) notification;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(WCCompleteInstallation4iTM3) object:nil];
	[self performSelector:@selector(WCCompleteInstallation4iTM3) withObject:nil afterDelay:0];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  WCCompleteInstallation4iTM3
+ (void)WCCompleteInstallation4iTM3;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSPointerArray * PA = [iTM2Runtime subclassReferencesOfClass:[NSWindowController class]];
	NSUInteger i = PA.count;
	while (i--) {
		Class C = (Class)[PA pointerAtIndex:i];
        NSString * type = [C inspectorType4iTM3];
        if (type.length) {
            //  the type and the modes must have a length!!!
//LOG4iTM3(@"Inspector type:%@", type);
            NSString * mode = [C inspectorMode];
            if (mode.length) {
//LOG4iTM3(@"Inspector mode:%@", mode);
                NSMutableArray * MRA = [self objectForType:type key:mode];
                if (!MRA) {
                    MRA = [NSMutableArray array];
                    [self registerObject:MRA forType:type key:mode retain:YES];
                }
                if (![MRA containsObject:C]) {
                    [MRA addObject:C];
//Class c = [NSWindowController inspectorClassForType:type mode:mode variant:[C inspectorVariant]];
//LOG4iTM3(@"Registered inspector:%@, type:%@, mode:%@, variant:%@", NSStringFromClass(c), [c inspectorType4iTM3], [c inspectorMode], [c inspectorVariant]);
                } else if (iTM2DebugEnabled) {
					LOG4iTM3(@"Already registered class %@", NSStringFromClass(C));
				}
            }
        } else if (iTM2DebugEnabled) {
			LOG4iTM3(@"No type for inspector:%@", NSStringFromClass(C));
        }
	}
	// then I load the various plugins for external inspectors mainly.
	[[iTM2ExternalInspectorServer mutableDictionary] setDictionary:[NSDictionary dictionary]];
	NSDirectoryEnumerator * DE = nil;
	NSBundle * MB = [NSBundle mainBundle];
    NSURL * baseURL = nil;
    NSURL * url = nil;
    if ((baseURL = [MB builtInPlugInsURL])) {
        DE = [DFM enumeratorAtURL:baseURL includingPropertiesForKeys:[NSArray array] options:NSDirectoryEnumerationSkipsHiddenFiles errorHandler:nil];
        for (url in DE) {
            if ([self registerPlugInAtURL:url]) {
                [DE skipDescendants];
            }
        }
    }
	NSString * mainBundlename = MB.bundleName4iTM3;
    if ((baseURL = [NSBundle URLForSupportDirectory4iTM3:iTM2SupportPluginsComponent inDomain:NSNetworkDomainMask withName:mainBundlename create:NO])) {
        DE = [DFM enumeratorAtURL:baseURL includingPropertiesForKeys:[NSArray array] options:NSDirectoryEnumerationSkipsHiddenFiles errorHandler:nil];
        for (url in DE) {
            if ([self registerPlugInAtURL:url]) {
                [DE skipDescendants];
            }
        }
	}
    if ((baseURL = [NSBundle URLForSupportDirectory4iTM3:iTM2SupportPluginsComponent inDomain:NSLocalDomainMask withName:mainBundlename create:NO])) {
        DE = [DFM enumeratorAtURL:baseURL includingPropertiesForKeys:[NSArray array] options:NSDirectoryEnumerationSkipsHiddenFiles errorHandler:nil];
        for (url in DE) {
            if ([self registerPlugInAtURL:url]) {
                [DE skipDescendants];
            }
        }
	}
    if ((baseURL = [NSBundle URLForSupportDirectory4iTM3:iTM2SupportPluginsComponent inDomain:NSUserDomainMask withName:mainBundlename create:YES])) {
        DE = [DFM enumeratorAtURL:baseURL includingPropertiesForKeys:[NSArray array] options:NSDirectoryEnumerationSkipsHiddenFiles errorHandler:nil];
        for (url in DE) {
            if ([self registerPlugInAtURL:url]) {
                [DE skipDescendants];
            }
        }
	} else {
        //  this is not critical if baseURL could not be created
    }
	if (iTM2DebugEnabled) {
		LOG4iTM3(@"Here are the registered inspectors: %@", [iTM2ExternalInspectorServer mutableDictionary]);
	}
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  registerPlugInAtURL:
+ (BOOL)registerPlugInAtURL:(NSURL *) url;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 31 08:02:22 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//LOG4iTM3(@"url is:%@", url);
	// is it an expected url?
	if (![url.pathExtension pathIsEqual4iTM3:NSBundle.mainBundle.plugInPathExtension4iTM3]) {
		return NO;
    }
	NSBundle * B = [NSBundle bundleWithURL:url];
	NSString * externalDocumentClassName = [B.infoDictionary objectForKey:@"iTM2ExternalDocumentClass"];
//	externalDocumentClassName = [B objectForInfoDictionaryKey:@"iTM2ExternalDocumentClass"];
	// is it an expected bundle?
	if (!externalDocumentClassName.length) {
//LOG4iTM3(@"No iTM2ExternalDocumentClass...\n%@", B.infoDictionary);
		return ! [B bundleIsWrapper4iTM3];
	}
	Class documentClass = NSClassFromString(externalDocumentClassName);
	if (![documentClass isSubclassOfClass:[NSDocument class]]) {
		LOG4iTM3(@"Bad entry for key iTM2ExternalDocumentClass in the Info.plist of %@ (NSDocument subclass name expected)", B);
        return YES;
	}
	NSString * variant = [B.infoDictionary objectForKey:@"iTM2ExternalInspectorVariant"];
	if (!variant.length) {
		LOG4iTM3(@"Bad entry for key iTM2ExternalInspectorVariant in the Info.plist of %@ (non void variant expected)", B);
        return YES;
	}
    // Now, we know that the bundle contains an external inspector bridge,
    // we know the variant and the document class it should apply to
    NSString * xComponent = [B.infoDictionary objectForKey:@"iTM2ExternalInspectorCommand"];
    if (xComponent.length) {
        NSURL * xURL = [B.sharedFrameworksURL.URLByDeletingLastPathComponent
                                URLByAppendingPathComponent:@"MacOS"];// don't rely on the executablePath!! it might be void...
        xURL = [xURL URLByAppendingPathComponent:xComponent];
        if (xURL.isFileURL && [DFM isExecutableFileAtPath:xURL.path]) {
            [iTM2ExternalInspectorServer registerObject:xURL forType:[documentClass inspectorType4iTM3] key:variant retain:YES];
        } else {
			LOG4iTM3(@"iTM2 executable file at url %@", xURL);
		}
    }
//END4iTM3;
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  windowControllerServer
+ (id)windowControllerServer;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return [iTM2WindowControllerServer class];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  isInstanceUnique
+ (BOOL)isInstanceUnique;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  windowNibName
+ (NSString *)windowNibName;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return NSStringFromClass(self);
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
    return @"";
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  prettyInspectorType4iTM3
+ (NSString *)prettyInspectorType4iTM3;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSString * key = self.inspectorType4iTM3;
//START4iTM3;
    return [NSBundle bundleForClass4iTM3:self localizedStringForKey:key value:key table:iTM2InspectorTable];
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  prettyInspectorMode
+ (NSString *)prettyInspectorMode;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSString * key = self.inspectorMode;
	if ([key isEqual:@"Terminal"])
		NSLog(@"BON");
//START4iTM3;
    return [NSBundle bundleForClass4iTM3:self localizedStringForKey:key value:key table:iTM2InspectorTable];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inspectorVariant
+ (NSString *)inspectorVariant;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return iTM2DefaultInspectorVariant;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  prettyInspectorVariant
+ (NSString *)prettyInspectorVariant;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSString * key = self.inspectorVariant;
//START4iTM3;
    return [NSBundle bundleForClass4iTM3:self localizedStringForKey:key value:key table:iTM2InspectorTable];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  allInspectorVariantsForType:
+ (NSArray *)allInspectorVariantsForType:(NSString *) type;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [type isEqual:self.inspectorType4iTM3]? [NSArray arrayWithObject:self.inspectorVariant]:[NSArray array];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inspectorClassForType:mode:variant:
+ (Class)inspectorClassForType:(NSString *) type mode:(NSString *) mode variant:(NSString *) variant;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSArray * inspectorClasses = [self inspectorClassesForType:type mode:mode];
    NSEnumerator * E = inspectorClasses.objectEnumerator;
    Class C;
    while(C = E.nextObject)
	{
//LOG4iTM3(NSStringFromClass(C));
        if ([[C allInspectorVariantsForType:type] containsObject:variant])
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
//LOG4iTM3(@"REQUESTED TYPE IS:%@", type);
//END4iTM3;
    return [[self.windowControllerServer keyEnumeratorForType:type] allObjects];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inspectorClassesForType:mode:
+ (NSArray *)inspectorClassesForType:(NSString *) type mode:(NSString *) mode;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [self.windowControllerServer objectForType:type key:mode];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  allInspectorsDescription
+ (NSString *)allInspectorsDescription;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return [[self.windowControllerServer mutableDictionary] description];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inspectorVariant
- (NSString *)inspectorVariant;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return iTM2DefaultInspectorVariant;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setInspectorVariant:
- (void)setInspectorVariant:(NSString *) argument;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  prettyInspectorVariant
- (NSString *)prettyInspectorVariant;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return NSLocalizedStringFromTableInBundle(self.inspectorVariant, iTM2InspectorTable, self.classBundle4iTM3, "pretty inspector variant");
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  synchronizeDocument4iTM3Error:
- (BOOL)synchronizeDocument4iTM3Error:(NSError **)outErrorPtr;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self setDocumentEdited:NO];
	return [self saveContext4iTM3Error:outErrorPtr];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  synchronizeWithDocument4iTM3Error:
- (BOOL)synchronizeWithDocument4iTM3Error:(NSError **)outErrorPtr;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	BOOL yorn = [self loadContext4iTM3Error:outErrorPtr];
    [self updateChangeCount:NSChangeCleared];
    self.validateWindowContent4iTM3;
    return yorn;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  isInspectorEdited
- (BOOL)isInspectorEdited;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [[IMPLEMENTATION metaValueForKey:@"isInspectorEdited"] boolValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setInspectorEdited:
- (void)setInspectorEdited:(BOOL) flag;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSInteger old = [[IMPLEMENTATION metaValueForKey:@"changeCount"] integerValue];
    switch(change) {
        case NSChangeCleared:
		default:
            old = ZER0;
            break;
        case NSChangeDone:
            ++old;
            break;
        case NSChangeUndone:
            --old;
            break;
    }
    [IMPLEMENTATION takeMetaValue:[NSNumber numberWithInteger:old] forKey:@"changeCount"];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  SWZ_iTM2_windowWillLoad
- (void)SWZ_iTM2_windowWillLoad;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[self SWZ_iTM2_windowWillLoad];
	[self setShouldCascadeWindows:[self context4iTM3BoolForKey:@"iTM2ShouldCascadeWindows" domain:iTM2ContextAllDomainsMask]];
//LOG4iTM3(@"should cascade:%@", (self.shouldCascadeWindows? @"Y":@"N"));
    NSInvocation * I;
	[[NSInvocation getInvocation4iTM3:&I withTarget:self retainArguments:NO] windowWillLoad];
	[I invokeWithSelectors4iTM3:[iTM2Runtime instanceSelectorsOfClass:self.class withSuffix:@"WindowWillLoad4iTM3" signature:[I methodSignature] inherited:YES]];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  SWZ_iTM2_windowDidLoad
- (void)SWZ_iTM2_windowDidLoad;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//LOG4iTM3(@"1 - should cascade:%@", (self.shouldCascadeWindows? @"Y":@"N"));
	[self SWZ_iTM2_windowDidLoad];
//LOG4iTM3(@"2 - should cascade:%@", (self.shouldCascadeWindows? @"Y":@"N"));
    NSInvocation * I;
	[[NSInvocation getInvocation4iTM3:&I withTarget:self retainArguments:NO] windowWillLoad];
	[I invokeWithSelectors4iTM3:[iTM2Runtime instanceSelectorsOfClass:self.class withSuffix:@"WindowDidLoad4iTM3" signature:[I methodSignature] inherited:YES]];
	//LOG4iTM3(@"3 - should cascade:%@", (self.shouldCascadeWindows? @"Y":@"N"));
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  windowFrameIdentifier4iTM3
- (NSString *)windowFrameIdentifier4iTM3;
/*"YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1:03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [NSString stringWithFormat:@"%@.%@.%@", [self.class inspectorType4iTM3], [self.class inspectorMode], self.inspectorVariant];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  showWindowBelowFront:
- (void)showWindowBelowFront:(id)sender;
/*"Description Forthcoming.
Version History: Originally created by JL.
To do list:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSWindow * W = self.window;
	[W orderBelowFront4iTM3:self];
//END4iTM3;
    return;
}
@end

@interface iTM2VoidInspector:NSWindowController
@end
@implementation iTM2VoidInspector
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inspectorType4iTM3
+ (NSString *)inspectorType4iTM3;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return iTM2VoidInspectorType;
}
@end

@interface iTM2Inspector()
@property (readwrite,assign) id implementation;
@end
@implementation iTM2Inspector
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initWithWindow:
- (id)initWithWindow:(NSWindow *) window;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Sat Mar 20 20:58:15 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//LOG4iTM3(@"name:%@", name);
    if (self = [super initWithWindow:window]) {
        self.initImplementation;
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (self = [super initWithCoder:aDecoder])
    {
        self.initImplementation;
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [super initImplementation];
    [IMPLEMENTATION updateChildren];
	[IMPLEMENTATION takeMetaValue:[NSMutableDictionary dictionary] forKey:@"_modelBackups_"];
    return;
}
@synthesize implementation = implementation4iTM3;
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  windowNibPath;
- (NSString *)windowNibPath;  
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSString * path = [super windowNibPath];
	if ([DFM fileExistsAtPath:path])
		return path;
	NSString * aNibName = self.windowNibName;
	if (!aNibName.length)
		return path;
	Class class = self.class;
	Class superclass;
	while ((superclass = [class superclass]) && (superclass != class)) {
		NSBundle * B = [NSBundle bundleForClass:superclass];
		NSString * fileName = [B pathForResource:aNibName ofType:@"nib"];
		if (fileName.length)
			return fileName;
		class = superclass;
	}
//END4iTM3;
    return path;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  windowDidLoad
- (void)windowDidLoad;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
#if 0
	NSWindow * window = self.window;
	NSRect frame = window.frame;
	NSEnumerator * E = [NSApp.windows objectEnumerator];
	NSWindow * W;
	while(W = E.nextObject)
	{
		if ((window != W) && NSEqualRects(frame, W.frame))
		{
			[window setFrameTopLeftPoint:[window cascadeTopLeftFromPoint:NSMakePoint(NSMinX(frame), NSMaxY(frame))]];
			frame = window.frame;
			E = [NSApp.windows objectEnumerator];
		}
	}
#endif
    [super windowDidLoad];
//    self.synchronizeWithDocument; the inspector has already been synchronized when added to the document
    [self setDocumentEdited:NO];// validate the user interface as side effect
	self.backupModel;
    NSError * ROR = nil;
    [self loadContext4iTM3Error:&ROR];
    REPORTERROR4iTM3(1,@"",ROR);
//	self.validateWindowContent4iTM3; too early?
//LOG4iTM3(@"should cascade:%@", (self.shouldCascadeWindows? @"Y":@"N"));
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inspectorVariant
- (NSString *)inspectorVariant;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return metaGETTER?:[super inspectorVariant];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setInspectorVariant:
- (void)setInspectorVariant:(NSString *) argument;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	metaSETTER([[argument copy] autorelease]);
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateWindowContent4iTM3:
- (BOOL)validateWindowContent4iTM3:(id) sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self setDocumentEdited:([[IMPLEMENTATION metaValueForKey:@"changeCount"] integerValue] != ZER0)];
    return [super validateWindowContent4iTM3];
}
#pragma mark =-=-=-=-=-=-=-=-=-=-  CANCEL management
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  backupModel
- (void)backupModel;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSInvocation * I;
	[[NSInvocation getInvocation4iTM3:&I withTarget:self retainArguments:NO] windowWillLoad];
	[I invokeWithSelectors4iTM3:[iTM2Runtime instanceSelectorsOfClass:self.class withSuffix:@"CompleteBackupModel4iTM3" signature:[I methodSignature] inherited:YES]];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  restoreModel
- (void)restoreModel;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSInvocation * I;
	[[NSInvocation getInvocation4iTM3:&I withTarget:self retainArguments:NO] windowWillLoad];
	[I invokeWithSelectors4iTM3:[iTM2Runtime instanceSelectorsOfClass:self.class withSuffix:@"CompleteRestoreModel4iTM3" signature:[I methodSignature] inherited:YES]];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeModelBackup:(id) backup forKey:
- (void)takeModelBackup:(id) backup forKey:(NSString *) key;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (key)
		[[IMPLEMENTATION metaValueForKey:@"_modelBackups_"] setValue:backup forKey:key];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  modelBackupForKey:
- (id)modelBackupForKey:(NSString *) key;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSAssert(NO, @"ERROR:this is not the natural flow");
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleInspector:
- (BOOL)validateToggleInspector:(NSMenuItem *) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSWindowController * WC = [NSApp mainWindow].windowController;
    NSDocument * D = WC.document;
    NSString * newTitle = [[D class] prettyInspectorType4iTM3];
    if (newTitle.length)
    {
		sender.action = NULL;
		NSMenu * submenu = [[[iTM2InspectorMenu alloc] initWithTitle:@""] autorelease];
        [sender.menu setSubmenu:submenu forItem:sender];
        [submenu update];
//LOG4iTM3(@"UPDATING THE SUBMENU (%@)", NSStringFromSelector(sender.action));
//LOG4iTM3(@"UPDATING THE SUBMENU (%@)", sender.submenu);
//END4iTM3;
        return submenu.numberOfItems>ZER0;
    }
    else
    {
        [sender.menu setSubmenu:nil forItem:sender];
		[sender setEnabled:NO];
//LOG4iTM3(@"REMOVING THE SUBMENU (%@- %@, %@)", NSStringFromSelector(sender.action), D, WC);
//END4iTM3;
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (self = [super initWithTitle:title])
	{
		// I thought update was automatic for menus, but it seems that it is not the case,
		// at least for the inspector menu, so I must update them the hard way
		[DNC addObserver:self selector:@selector(windowDidChangeMainStatusNotified:) name:NSWindowDidResignMainNotification object:nil];
	}
//END4iTM3;
	return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  windowDidChangeMainStatusNotified:
- (void)windowDidChangeMainStatusNotified:(NSNotification *) notification;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	self.update;
//END4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  update
- (void)update;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Mon Oct  4 19:30:58 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSWindow * mainWindow = [NSApp mainWindow];
    NSWindowController * WC = mainWindow.windowController;
    NSDocument * D = WC.document;
    NSString * newTitle = [[D class] prettyInspectorType4iTM3];
    if (!newTitle.length || [mainWindow isKindOfClass:NSClassFromString(@"iTM2ProjectGhostWindow")]) {
        self.title = @"";
        NSMenu * M = self.supermenu;
        NSInteger index = [M indexOfItemWithSubmenu:self];
        if (index >= ZER0) {
            NSMenuItem * MI = [M itemAtIndex:index];
//LOG4iTM3(@"REMOVING THE SUBMENU HERE TOO");
			[self.retain autorelease];
            [M setSubmenu:nil forItem:MI];// self is released HERE
            MI.target = nil;
            MI.action = @selector(toggleInspector:);
			[MI setEnabled:NO];
        }
//END4iTM3;
        return;
    }
//    if (![self.title isEqualToString:newTitle])
	self.title = newTitle;
	BOOL old = self.menuChangedMessagesEnabled;
	[self setMenuChangedMessagesEnabled:NO];
	while(self.numberOfItems) {
		[self removeItemAtIndex:ZER0];
    }
	NSString * type = [D.class inspectorType4iTM3];
	for (NSString * inspectorMode in [NSWindowController inspectorModesForType:type]) {
		if (![inspectorMode hasPrefix:@"."]) {
			NSArray * inspectorClasses = [NSWindowController inspectorClassesForType:type mode:inspectorMode];
			Class C = Nil;
			NSString * title = @"";
			if (inspectorClasses.count) {
				C = [inspectorClasses objectAtIndex:ZER0];
				title = [C prettyInspectorMode];
			}
			NSMenuItem * MI = [self addItemWithTitle:(title.length? title:NSLocalizedStringFromTableInBundle(iTM2DefaultInspectorMode, iTM2InspectorTable, BUNDLE, "DF"))
					action:NULL keyEquivalent:@""];
			MI.representedObject = inspectorMode;
			NSMenu * M = [[[NSMenu alloc] initWithTitle:title] autorelease];
			for(C in inspectorClasses) {
				NSArray * variants = [C allInspectorVariantsForType:type];
				if (variants.count > 1)
				{
					// some code is added to track george tourlakis bug
NSSet * set = [NSSet setWithArray:variants];
if (set.count<variants.count)
{
	LOG4iTM3(@"[NSWindowController allInspectorsDescription]:%@",[NSWindowController allInspectorsDescription]);
	if ([SUD boolForKey:@"GeorgeTourlakisBug"])
	{
		// do nothing
	}
	else
	{
		REPORTERROR4iTM3(1,(@"Problem with inspectors: please send the console.app last lines (~100) to jlaurens@users.sourceforge.net"),nil);
		[SUD registerDefaults:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:@"GeorgeTourlakisBug"]];
	}
}
					for (NSString * inspectorVariant in variants) {
						NSMenuItem * mi = [M addItemWithTitle:inspectorVariant
												action:@selector(toggleInspector:) keyEquivalent:@""];
						mi.representedObject = [NSDictionary dictionaryWithObjectsAndKeys:
							type, @"type", inspectorMode, @"mode", inspectorVariant, @"variant", nil];
						mi.target = self;// mi belongs to self
					}
				} else {
					NSString * prettyInspectorVariant = [C prettyInspectorVariant];
					NSMenuItem * mi = [M addItemWithTitle:(prettyInspectorVariant.length? prettyInspectorVariant:
								NSLocalizedStringFromTableInBundle(iTM2DefaultInspectorVariant, iTM2InspectorTable, BUNDLE, "DF"))
							action:@selector(toggleInspector:) keyEquivalent:@""];
					mi.representedObject = [NSDictionary dictionaryWithObjectsAndKeys:
						type, @"type", inspectorMode, @"mode", [C inspectorVariant], @"variant", nil];
					mi.target = self;// mi belongs to self
				}
			}
			if (M.numberOfItems > 1) {
				[self setSubmenu:M forItem:MI];
			} else if (M.numberOfItems > ZER0) {
				[self removeItem:MI];
				MI = [[[M itemAtIndex:ZER0] retain] autorelease];
				[M removeItem:MI];
				[self addItem:MI];
				MI.title = title;
			} else {
				LOG4iTM3(@"There is some weird thing happening with the inspectors(type:%@, mode:%@)...", type, inspectorMode);
			}
		}
	}
	NSInteger NOI = self.numberOfItems;
	// adding now the external inspectors, if any
	for (NSString * inspectorVariant in [[[iTM2ExternalInspectorServer keyEnumeratorForType:type] allObjects] sortedArrayUsingSelector:@selector(compare:)]) {
        if ([SWS fullPathForApplication:inspectorVariant]) {
            // do not create an external inspector if there is no application fo that
            NSMenuItem * mi = [self addItemWithTitle:inspectorVariant
                    action:@selector(toggleExternalInspector:) keyEquivalent:@""];
            mi.representedObject = [iTM2ExternalInspectorServer objectForType:type key:inspectorVariant];
            mi.target = self;// mi belongs to self
        }
	}
	if (self.numberOfItems>NOI) {
		[self insertItem:NSMenuItem.separatorItem atIndex:NOI];
	}
	[self setMenuChangedMessagesEnabled:old];
    [super update];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleInspector:
- (IBAction)toggleInspector:(NSMenuItem *) sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	iTM2Document * doc = [[NSApp mainWindow].windowController document];
	if (doc.isDocumentEdited) {
		return;
    }
	NSDictionary * D = sender.representedObject;
	NSString * mode = [D valueForKey:@"mode"];
	NSString * variant = [D valueForKey:@"variant"];
	if ([doc isKindOfClass:iTM2Document.class]) {
		[doc replaceInspectorMode:mode variant:variant];
	}
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleInspector:
- (BOOL)validateToggleInspector:(NSMenuItem *) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//LOG4iTM3(@"sender.representedObject is:%@", sender.representedObject);
    NSWindowController * WC = [NSApp mainWindow].windowController;
    NSDocument * D = WC.document;
    sender.state = [sender.representedObject isEqual:
        [NSDictionary dictionaryWithObjectsAndKeys:[D.class inspectorType4iTM3], @"type", [WC.class inspectorMode], @"mode", WC.inspectorVariant, @"variant", nil]]?
            NSOnState:NSOffState;
//END4iTM3;
    return !D.isDocumentEdited;// beware:the undo stack is not managed if you change the inspector while the document is edited
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleExternalInspector:
- (IBAction)toggleExternalInspector:(NSMenuItem *) sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	id doc = [[[NSApp mainWindow] windowController] document];
	if ([doc isKindOfClass:[iTM2Document class]])
	{
		[doc saveContext4iTM3:self];
		[doc replaceInspectorMode:iTM2ExternalInspectorMode variant:sender.title];
	}
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleExternalInspector:
- (BOOL)validateToggleExternalInspector:(NSMenuItem *) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSWindowController * WC = [[NSApp mainWindow] windowController];
    [sender setState:([WC isKindOfClass:[iTM2ExternalInspector class]] && [[WC inspectorVariant] isEqual:sender.title]?
            NSOnState:NSOffState)];
//LOG4iTM3(@"filename is:%@", WC.document.fileName);
	if (!sender.image) {
		NSString * appName = sender.title;
		NSString * name = [NSString stringWithFormat:@"%@(small)",appName];
		NSImage * I = [NSImage cachedImageNamed4iTM3:name];
		if (!I.isNotNullImage4iTM3) {
			I = [[[SWS iconForFile:[SWS fullPathForApplication:appName]] copy] autorelease];// copy!!!
            [I performSelector:@selector(retain)];// trick for the logic analyzer
			[I setName:name];
			I.setSizeSmallIcon4iTM3;
		}
		sender.image = I;
	}
	NSDocument * D = WC.document;
//END4iTM3;
    return D.fileURL.isFileURL && !D.isDocumentEdited;
}
@end

NSString * const iTM2UDSmartUndoKey = @"iTM2SmartUndo";
NSString * const iTM2UDLevelsOfUndoKey = @"iTM2LevelsOfUndo";

@interface iTM2UndoManager(PRIVATE)
- (void)undoPastSaveSheetDidEnd:(NSWindow *) unused returnCode:(NSInteger) returnCode irrelevantInfo:(void *) irrelevant;
@end

@implementation NSResponder(iTM2UndoManager)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleSmartUndo:
- (IBAction)toggleSmartUndo:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	BOOL old = [self context4iTM3BoolForKey:iTM2UDSmartUndoKey domain:iTM2ContextAllDomainsMask];
	[self takeContext4iTM3Bool:!old forKey:iTM2UDSmartUndoKey domain:iTM2ContextAllDomainsMask];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleSmartUndo:
- (BOOL)validateToggleSmartUndo:(NSButton *) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	sender.state = self.hasSmartUndo?NSOnState:NSOffState;
//END4iTM3;
    return self.canToggleSmartUndo;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  canToggleSmartUndo
- (BOOL)canToggleSmartUndo;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (12/18/2001).
To do list:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  hasSmartUndo
- (BOOL)hasSmartUndo;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (12/18/2001).
To do list:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return [self context4iTM3BoolForKey:iTM2UDSmartUndoKey domain:iTM2ContextAllDomainsMask];
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
{DIAGNOSTIC4iTM3;
	INIT_POOL4iTM3;
//START4iTM3;
    [super initialize];
    [SUD registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithUnsignedInteger:ZER0], iTM2UDLevelsOfUndoKey,// nothing else!
            [NSNumber numberWithBool:YES], iTM2UDSmartUndoKey,
                nil]];
//END4iTM3;
	RELEASE_POOL4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  undo
- (void)undo;
/*"Private use only. Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1:03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSWindow * keyWindow = [NSApp keyWindow];
    if (keyWindow.hasSmartUndo && !keyWindow.isDocumentEdited) {
		NSString * undoMenuItemTitle = self.undoMenuItemTitle;
		NSString * titre;
		if ([self.undoMenuItemTitle hasPrefix:@"&"]) {
			titre = [undoMenuItemTitle substringWithRange:iTM3MakeRange(1, undoMenuItemTitle.length-1)];
		} else {
			titre = undoMenuItemTitle;
        }
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
- (void)_undoPastSaveSheetDidDismiss:(NSWindow *) unused returnCode:(NSInteger) returnCode irrelevantInfo:(void *) irrelevant;
/*"Private use only. Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1:03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if ((returnCode == NSOKButton) && (self.canUndo))
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
	return iTM2ExternalInspectorMode;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  allInspectorVariantsForType:
+ (NSArray *)allInspectorVariantsForType:(NSString *) type;
/*"Private use only. Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1:03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSEnumerator * E = [iTM2ExternalInspectorServer keyEnumeratorForType:type];
//END4iTM3;
	return E? [E allObjects]:[NSArray array];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  switchToExternalHelperWithEnvironment:
- (BOOL)switchToExternalHelperWithEnvironment:(NSDictionary *) environment;
/*"Private use only. Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1:03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
        NSTask * task = [self.implementation metaValueForKey:@"task"];
        [DNC removeObserver:self name:NSTaskDidTerminateNotification object:task];
        task = [[[NSTask alloc] init] autorelease];
		NSString * type = [[self.document class] inspectorType4iTM3];
		NSString * variant = self.inspectorVariant;
		NSURL * launchURL = [iTM2ExternalInspectorServer objectForType:type key:variant];
		NSAssert(launchURL.isFileURL && launchURL.path.length, @"Inconsistency on launchURL, PLEASE report bug...");
        [task setLaunchPath:launchURL.path];
		NSURL * fileURL = [self.document fileURL];
		NSAssert(fileURL.isFileURL && fileURL.path.length, @"Inconsistency on fileURL, PLEASE report bug...");
        [task setCurrentDirectoryPath:fileURL.URLByDeletingLastPathComponent.path];
        NSMutableDictionary * processEnvironment = [[[[NSProcessInfo processInfo] environment] mutableCopy] autorelease];
		[processEnvironment addEntriesFromDictionary:[self.document environmentForExternalHelper]];
		[processEnvironment addEntriesFromDictionary:environment];
		[processEnvironment setObject:[NSString stringWithFormat:@":%@:%@",
                        [self context4iTM3ValueForKey:iTM2PATHPrefixKey domain:iTM2ContextAllDomainsMask],
							[processEnvironment objectForKey:@"PATH"]]  forKey:@"PATH"];
		[processEnvironment setObject:[self.document fileName].lastPathComponent forKey:@"file"];
        [task setEnvironment:processEnvironment];
        [task setStandardInput:[NSFileHandle fileHandleWithNullDevice]];
        [task setStandardOutput:[NSFileHandle fileHandleWithNullDevice]];
        [task setStandardError:[NSFileHandle fileHandleWithNullDevice]];
		[self.implementation takeMetaValue:task forKey:@"task"];
        [DNC addObserver:self
            selector:@selector(_taskDidTerminate:) name:NSTaskDidTerminateNotification object:task];
        [task launch];
//END4iTM3;
	return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  _taskDidTerminate:
- (void)_taskDidTerminate:(NSNotification *) notification;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3:Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [DNC removeObserver:self name:nil object:notification.object];
	[self.implementation takeMetaValue:nil forKey:@"task"];
//START4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  windowTitleForDocumentDisplayName:
- (NSString *)windowTitleForDocumentDisplayName:(NSString *) displayName;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [[super windowTitleForDocumentDisplayName:displayName] stringByAppendingFormat:@" (%@)", self.inspectorVariant];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inspectorVariant
- (NSString *)inspectorVariant;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return metaGETTER;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setInspectorVariant:
- (void)setInspectorVariant:(NSString *) argument;
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
@end

@implementation iTM2ExternalWindow
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  makeMainWindow
- (void)makeMainWindow;
/*"Private use only. Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1:03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[super makeMainWindow];
	[self.windowController switchToExternalHelperWithEnvironment:[NSDictionary dictionaryWithObjectsAndKeys:
					[[self.windowController document] fileName], @"file", nil]];
//END4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  makeKeyWindow
- (void)makeKeyWindow;
/*"Private use only. Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1:03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[super makeKeyWindow];
	[self.windowController switchToExternalHelperWithEnvironment:[NSDictionary dictionaryWithObjectsAndKeys:
					[[self.windowController document] fileName], @"file", nil]];
//END4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  makeKeyAndOrderFront:
- (void)makeKeyAndOrderFront:(id) sender;
/*"Private use only. Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1:03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[super makeKeyAndOrderFront:(id) sender];
	[self.windowController switchToExternalHelperWithEnvironment:[NSDictionary dictionaryWithObjectsAndKeys:
					[[self.windowController document] fileName], @"file", nil]];
//END4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  orderFront:
- (void)orderFront:(id) sender;
/*"Private use only. Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1:03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[super orderFront:sender];
	[self.windowController switchToExternalHelperWithEnvironment:[NSDictionary dictionaryWithObjectsAndKeys:
					[[self.windowController document] fileName], @"file", nil]];
//END4iTM3;
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
{DIAGNOSTIC4iTM3;
    INIT_POOL4iTM3;
//START4iTM3;
    [super initialize];
    if (!_iTM2ExternalInspectorServerDictionary)
	{
		_iTM2ExternalInspectorServerDictionary = [NSMutableDictionary dictionary];
	}
//END4iTM3;
	RELEASE_POOL4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  mutableDictionary
+ (NSMutableDictionary *)mutableDictionary;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return _iTM2ExternalInspectorServerDictionary;
}
@end

@implementation iTM2WildcardDocument
@end

@implementation iTM2MainInstaller(DocumentKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  windowLoadingCompleteInstallation4iTM3
+ (void)windowLoadingCompleteInstallation4iTM3;
/*"Description Forthcoming.
 Version history: jlaurens AT users DOT sourceforge DOT net
 - 2.0: Fri Sep 05 2003
 To Do List:
 "*/
{DIAGNOSTIC4iTM3;
	//START4iTM3;
	[SUD registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:
						   [NSNumber numberWithBool:YES], @"iTM2ShouldCascadeWindows",
						   nil]];
}
+ (void)prepareDocumentKitCompleteInstallation4iTM3;
{DIAGNOSTIC4iTM3;
	//START4iTM3;
	if ([NSWindowController swizzleInstanceMethodSelector4iTM3:@selector(SWZ_iTM2_windowWillLoad) error:NULL]
			 && [NSWindowController swizzleInstanceMethodSelector4iTM3:@selector(SWZ_iTM2_windowDidLoad) error:NULL])
	{
		MILESTONE4iTM3((@"NSDocument(iTM2Loading)"),(@"***  Huge problem in method swizzling NSWindowController, things will not work as expected."));
	}
	if ([NSDocument swizzleInstanceMethodSelector4iTM3:@selector(SWZ_iTM2_canCloseDocumentWithDelegate:shouldCloseSelector:contextInfo:) error:NULL])
	{
		MILESTONE4iTM3((@"NSDocument(iTeXMac2)"),(@"WARNING:No hook available before closing documents..., things can become dangerous"));
	}
    return;
}
@end

