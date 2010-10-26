/*
//
//  @version Subversion: $Id: iTM2DocumentControllerKit.m 799 2009-10-13 16:46:39Z jlaurens $ 
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
//  GPL addendum: Any simple modification of the present code which purpose is to remove bug,
//  improve efficiency in both code execution and code reading or writing should be addressed
//  to the actual developper team.
//
//  Version history: (format "- date:contribution(contributor)") 
//  To Do List: (format "- proposition(percentage actually done)")
*/

#import "iTM2Runtime.h"
#import "iTM2InstallationKit.h"
#import "iTM2BundleKit.h"
#import "iTM2NotificationKit.h"
#import "iTM2PathUtilities.h"
#import "iTM2Implementation.h"
#import "iTM2ValidationKit.h"
#import "iTM2ObjectServer.h"
#import "iTM2WindowKit.h"
#import "iTM2UserDefaultsKit.h"
#import "iTM2ContextKit.h"
#import "iTM2AutoKit.h"
#import "iTM2DocumentControllerKit.h"

#define TABLE @"iTM2DocumentKit"
#define BUNDLE [iTM2Document classBundle4iTM3]


//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  NSDocumentController(iTeXMac2)
/*"Description forthcoming."*/

#import "iTM2PDFDocumentKit.h"

@implementation NSDocumentController(iTeXMac2Kit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  displayPageForLine:column:source:withHint:orderFront:force:
- (BOOL)displayPageForLine:(NSUInteger)line column:(NSUInteger)column source:(NSURL *)sourceURL withHint:(NSDictionary *)hint orderFront:(BOOL)yorn force:(BOOL)force;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= forgetRecentDocumentURL:
- (void)forgetRecentDocumentURL:(NSURL *)absoluteURL;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	id urls = self.recentDocumentURLs;
	if ([urls containsObject:absoluteURL])
	{
		[self clearRecentDocuments:nil];
		urls = [NSMutableArray arrayWithArray:urls];
		[urls removeObject:absoluteURL];
		for (absoluteURL in urls) {
			[self noteNewRecentDocumentURL:absoluteURL];
		}
	}
//END4iTM3;
	return;
}
@end

NSString * const iTM2AutosavingDelayKey = @"iTM2AutosavingDelay";

@implementation iTM2DocumentController
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initialize
+ (void)initialize;
/*"Designated intializer.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[super initialize];
	[SUD registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:
		[NSNumber numberWithFloat:120],iTM2AutosavingDelayKey,nil]];
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
        self.initImplementation;
		[self setAutosavingDelay:[SUD floatForKey:iTM2AutosavingDelayKey]];
    }
    return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  implementation
- (id)implementation;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return _Implementation;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setImplementation:
- (void)setImplementation:(id)argument;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (_Implementation != argument)
    {
        [_Implementation autorelease];
        _Implementation = [argument retain];
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  saveAllDocumentsWithDelegate:didSaveSelector:contextInfo:
- (void)saveAllDocumentsWithDelegate:(id)delegate didSaveAllSelector:(SEL)action contextInfo:(void *)contextInfo;
/*"Call back must have the following signature:
- (void)documentController:(id)DC didSaveAll:(BOOL)flag contextInfo:(void *)contextInfo;
Version History: jlaurens AT users DOT sourceforge DOT net (12/07/2001)
- 2.0: 03/10/2002
To Do List: to be improved... to allow different signature
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self saveAllDocuments:self];
    BOOL resultFlag = YES;
    NSMethodSignature * myMS = [self methodSignatureForSelector:
                                    @selector(_fakeDocumentController:didSaveAll:contextInfo:)];
    if ([myMS isEqual:[delegate methodSignatureForSelector:action]])
    {
        NSInvocation * I = [NSInvocation invocationWithMethodSignature:myMS];
        [I setSelector:action];
        I.target = delegate;
        [I setArgument:&self atIndex:2];
        [I setArgument:&resultFlag atIndex:3];
        if (contextInfo)
            [I setArgument:&contextInfo atIndex:4];
        [I invoke];
    }
    else
    {
	//START4iTM3;
        NSLog(@"Bad method signature in saveAllDocumentsWithDelegate...");
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  _fakeDocumentController:didSaveAll:contextInfo:
- (void)_fakeDocumentController:(id)DC didSaveAll:(BOOL)flag contextInfo:(void *)contextInfo;
/*"Call back must have the following signature:
- (void)documentController:(if)DC didSaveAll:(BOOL)flag contextInfo:(void *)contextInfo;
Version History: jlaurens AT users DOT sourceforge DOT net (12/07/2001)
- 2.0: 03/10/2002
To Do List: to be improved...
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= openDocumentWithContentsOfURL:displayPageForLine:column:source:withHint:orderFront:
- (id)openDocumentWithContentsOfURL:(NSURL *)fileURL displayPageForLine:(NSUInteger)line column:(NSUInteger)column source:(NSURL *)sourceURL withHint:(NSDictionary *)hint orderFront:(BOOL)yorn;
/*"This is the answer to the notification sent by the "e_Helper" tool.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 11/06/2003
To Do List: see the warning below
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	id doc = [SDC documentForURL:fileURL];
	if (doc)
	{
		[doc updateIfNeeded];
		[doc displayPageForLine:line column:column source:sourceURL withHint:hint orderFront:yorn force:YES];
		return doc;
	}
	if (yorn)
	{
		doc = [SDC openDocumentWithContentsOfURL:fileURL display:YES error:nil];
		[doc displayPageForLine:line column:column source:sourceURL withHint:hint orderFront:yorn force:YES];
		return doc;
	}
	else
	{
		doc = [SDC openDocumentWithContentsOfURL:fileURL display:NO error:nil];
		[doc makeWindowControllers];
		NSEnumerator * E = [[doc windowControllers] objectEnumerator];
		NSWindowController * WC;
		NSWindow * W;
		while(WC = [E nextObject])
		{
			W = WC.window;
			[W orderBelowFront4iTM3:self];
		}
		[doc displayPageForLine:line column:column source:sourceURL withHint:hint orderFront:yorn force:NO];
		return doc;
	}
}
#pragma mark =-=-=-=-=-  OVERRIDE
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= addDocument:
- (void)addDocument:(NSDocument *)document;
/*"Description Forthcoming. Ghost documents are not added.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [super addDocument:document];
    if (iTM2DebugEnabled>100)
    {
        LOG4iTM3(@"document added: %@, with URL: %@", document, document.fileURL);
    }
    if ([document isKindOfClass:[iTM2GhostDocument class]])
        [self removeDocument:document];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= noteNewRecentDocument:
- (void)noteNewRecentDocument:(NSDocument *)document;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if ([SUD boolForKey:@"iTM2NoMoreRecentDocuments"])
		return;
	NSDocument * newRecentDocument = [document newRecentDocument];
    if (newRecentDocument)
	{
		// the document wants to appear in the recent docs list
		NSURL * URL = newRecentDocument.fileURL;// do not assume that any document has a URL
		if (URL)
		{
			[self noteNewRecentDocumentURL:URL];
			if (iTM2DebugEnabled)
			{
				LOG4iTM3(@"document ADDED IN THE RECENT DOCS LIST: %@", document);
				NSLog(@"document.fileURL:%@", document.fileURL);
				NSLog(@"newRecentDocument.fileURL.path:%@", newRecentDocument.fileURL);
				NSLog(@"self.recentDocumentURLs:%@", self.recentDocumentURLs);
			}
		}
	}
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  closeAllDocumentsWithDelegate:didCloseAllSelector:contextInfo:
- (void)closeAllDocumentsWithDelegate:(id)delegate didCloseAllSelector:(SEL)didAllCloseSelector contextInfo:(void *)contextInfo;
/*"Call back must have the following signature:
- (void)documentController:(id)DC didSaveAll:(BOOL)flag contextInfo:(void *)contextInfo;
Version History: jlaurens AT users DOT sourceforge DOT net (12/07/2001)
- 2.0: 03/10/2002
To Do List: to be improved... to allow different signature
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSEnumerator * E = [self.documents objectEnumerator];
    id doc;
    while(doc = [E nextObject])
		if ([doc respondsToSelector:@selector(projectDocumentWillClose)])
			[doc performSelector:@selector(projectDocumentWillClose) withObject:nil];
    [super closeAllDocumentsWithDelegate:delegate didCloseAllSelector:didAllCloseSelector contextInfo:contextInfo];
//END4iTM3;
    return;
}
#pragma mark =-=-=-=-=-  Plug-Ins support
#if 0
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  documentClassNames
- (NSArray *)documentClassNames;
/*"Description Forthcoming
Version History: jlaurens AT users DOT sourceforge DOT net (today)
- 2.0: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
	NSArray * result = [super documentClassNames];
//LOG4iTM3(@"[super documentClassNames] is:%@", [super documentClassNames]);
//LOG4iTM3(@"[self.documentClassNameForTypeDictionary allValues] is:%@", [self.documentClassNameForTypeDictionary allValues]);
    return [super documentClassNames];//[self.documentClassNameForTypeDictionary allValues];
}
#endif
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  documentClassNameForTypeDictionary;
- (NSDictionary *)documentClassNameForTypeDictionary;
/*"Description Forthcoming
Version History: jlaurens AT users DOT sourceforge DOT net (today)
- 2.0: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSMutableDictionary * D = metaGETTER;
	if (!D) {
		NSBundle * B;
		NSMutableDictionary * fromFrameworks = [NSMutableDictionary dictionary];
		NSString * className;
		NSString * documentType;
		NSDictionary * d;
		NSString * localizedType;
		for (B in [NSBundle allFrameworks]) {
			for (d in [B objectForInfoDictionaryKey:@"CFBundleDocumentTypes"]) {
				documentType = [d objectForKey:@"CFBundleTypeName"];
				className = [d objectForKey:@"NSDocumentClass"];
				if ([documentType isKindOfClass:[NSString class]]
					&& [className isKindOfClass:[NSString class]]
						&& NSClassFromString(className)) {
					[fromFrameworks setObject:className forKey:documentType];
					localizedType = [[B localizedInfoDictionary] objectForKey:documentType];
					if (localizedType.length) {
						[(id)self.localizedDocumentTypesDictionary setObject:localizedType forKey:documentType];
					}
				} else {
					LOG4iTM3(@"ERROR: Bad Info.plist in bundle %@", B);
				}
			}
		}
		B = [NSBundle mainBundle];
		NSMutableDictionary * fromMainBundle = [NSMutableDictionary dictionary];
		// I try to use the inherited methods:
		for (className in [super documentClassNames]) {
			Class C = NSClassFromString(className);
			if ([C isSubclassOfClass:[NSDocument class]]) {
				for (documentType in [C readableTypes]) {
					Class oldC = [fromMainBundle objectForKey:documentType];
					if (!oldC || [C isSubclassOfClass:oldC]) {
						[fromMainBundle setObject:className forKey:documentType];
						localizedType = [[B localizedInfoDictionary] objectForKey:documentType];
						if (localizedType.length) {
							[(NSMutableDictionary *)self.localizedDocumentTypesDictionary setObject:localizedType forKey:documentType];
						}
					}
				}
			}
		}
		NSMutableDictionary * fromPlugIns = [NSMutableDictionary dictionary];
		for (NSURL * url in [[NSBundle mainBundle] availablePlugInURLsWithExtension4iTM3:NSBundle.mainBundle.plugInPathExtension4iTM3]) {
			B = [NSBundle bundleWithURL:url];
			for (d in [B objectForInfoDictionaryKey:@"CFBundleDocumentTypes"]) {
//LOG4iTM3(@"[D objectForKey:\"CFBundleTypeOSTypes\"] is:%@", [D objectForKey:@"CFBundleTypeOSTypes"]);
				documentType = [d objectForKey:@"CFBundleTypeName"];
				className = [d objectForKey:@"NSDocumentClass"];
				if ([documentType isKindOfClass:[NSString class]]
                        && [className isKindOfClass:[NSString class]]) {
					Class documentClass = NSClassFromString(className);
					if (documentClass) {
						NSString * classNameFromMainBundle = [fromMainBundle objectForKey:documentType];
						Class documentClassFromMainBundle = NSClassFromString(classNameFromMainBundle);
						if (documentClassFromMainBundle) {
							if ([documentClass isSubclassOfClass:documentClassFromMainBundle]) {
								[fromPlugIns setObject:className forKey:documentType];
								localizedType = [[B localizedInfoDictionary] objectForKey:documentType];
								if (localizedType.length) {
									[(NSMutableDictionary *)self.localizedDocumentTypesDictionary setObject:localizedType forKey:documentType];
								}
							} else {
								LOG4iTM3(@"ERROR: Bad Info.plist in plug-in %@ (%@ must be a subclass of %@)", B, className, classNameFromMainBundle);
							}
						} else {
							[fromPlugIns setObject:className forKey:documentType];
						}
					} else {
						LOG4iTM3(@"ERROR: Bad Info.plist in bundle %@ (No class for that name %@)", B, className);
					}
				} else {
					LOG4iTM3(@"ERROR: Bad Info.plist in bundle %@ (NSString expected but got %@ and %@)", B, documentType, className);
				}
		//LOG4iTM3(@"NOT THIS ONE =-=-=-=-=-");
			}
		}
		[fromFrameworks addEntriesFromDictionary:fromMainBundle];
		[fromFrameworks addEntriesFromDictionary:fromPlugIns];
		metaSETTER(fromFrameworks);
		D = metaGETTER;
		[iTM2Runtime swizzleClassMethodSelector:@selector(readableTypes)
										   replacement:@selector(swizzle_readableTypes4iTM3) forClass: [NSDocument class] error:nil];
		if (iTM2DebugEnabled) {
			for (documentType in D.keyEnumerator) {
				className = [D objectForKey:documentType];
				Class documentClass = NSClassFromString(className);
				LOG4iTM3(@"%@ -> %@, %@", documentType, className, [NSBundle bundleForClass:documentClass]);
			}
		}
	}
//END4iTM3;
    return D;
}
#if 0
#warning THIS WAS A BUG CATCHER!!! What bug man? Sometimes the document is not opened with the expected class...
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  documentClassForType:
- (Class)documentClassForType:(NSString *)documentTypeName;
/*"On n'est jamais si bien servi qua par soi-meme
Version History: jlaurens AT users DOT sourceforge DOT net (today)
- 2.0: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	id result = NSClassFromString([self.documentClassNameForTypeDictionary objectForKey:documentTypeName]);
	if (result)
		return result;
	result = [super documentClassForType:documentTypeName];// this verbose style is usefull for debugging purpose
//END4iTM3;
	return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  typeFromFileExtensionDictionary
- (NSDictionary *)typeFromFileExtensionDictionary;
/*"On n'est jamais si bien servi que par soi-meme
Version History: jlaurens AT users DOT sourceforge DOT net (today)
- 2.0: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSMutableDictionary * D = metaGETTER;
	if (!D)
	{
		D = [NSMutableDictionary dictionary];
		NSDictionary * DCNFTD = self.documentClassNameForTypeDictionary;
		NSMutableArray * DCNs = [NSMutableArray arrayWithArray:[DCNFTD allKeys]];
		NSEnumerator * E = DCNFTD.keyEnumerator;
		NSString * documentType;
		while(documentType = [E nextObject])
		{
			NSArray * FEs = [super fileExtensionsFromType:documentType];
			NSEnumerator * e = FEs.objectEnumerator;
			NSString * FE;
			if (FE = [e nextObject])
			{
				[DCNs removeObject:documentType];
				do
				{
					[D setObject:documentType forKey:[FE lowercaseString]];
				}
				while(FE = [e nextObject]);
			}
		}
		for(documentType in DCNs)
		{
			NSString * className = [DCNFTD objectForKey:documentType];
			Class C = NSClassFromString(className);
			NSBundle * B = [C classBundle4iTM3];
			if (B)
			{
				NSEnumerator * e = [[B objectForInfoDictionaryKey:@"CFBundleDocumentTypes"] objectEnumerator];
				NSDictionary * d;
				while(d = [e nextObject])
				{
					if ([[d objectForKey:@"CFBundleTypeName"] isEqual:documentType]
						&& [[d objectForKey:@"NSDocumentClass"] isEqual:className])
					{
						NSEnumerator * ee = [[d objectForKey:@"CFBundleTypeExtensions"] objectEnumerator];
						NSString * component;
						while(component = [ee nextObject])
						{
							[D setObject:documentType forKey:[component lowercaseString]];
						}
						ee = [[d objectForKey:@"CFBundleTypeOSTypes"] objectEnumerator];
						while(component = [ee nextObject])
						{
							[D setObject:documentType forKey:component];
						}
					}
				}
			}
			else
			{
				LOG4iTM3(@".....  ERROR: No document class named: %@", className);
			}
		}
		metaSETTER(D);
		D = metaGETTER;
		if (iTM2DebugEnabled)
		{
			E = D.keyEnumerator;
			while(documentType = [E nextObject])
			{
				NSString * className = [D objectForKey:documentType];
				LOG4iTM3(@"%@ -> %@", documentType, className);
			}
		}
	}
//END4iTM3;
    return D;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  typeFromFileExtension:
- (NSString *)typeFromFileExtension:(NSString *)fileNameExtensionOrHFSFileType;
/*"On n'est jamais si bien servi que par soi-meme
Version History: jlaurens AT users DOT sourceforge DOT net (today)
- 2.0: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//LOG4iTM3(@"fileNameExtension is: %@", fileNameExtension);
	return [self.typeFromFileExtensionDictionary objectForKey:[fileNameExtensionOrHFSFileType lowercaseString]]?:
		([self.typeFromFileExtensionDictionary objectForKey:fileNameExtensionOrHFSFileType]?:
			[super typeFromFileExtension:fileNameExtensionOrHFSFileType]);
}
#endif
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  localizedDocumentTypesDictionary
- (NSDictionary *)localizedDocumentTypesDictionary;
/*"On n'est jamais si bien servi que par soi-meme
Version History: jlaurens AT users DOT sourceforge DOT net (today)
- 2.0: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSMutableDictionary * D = metaGETTER;
	if (!D)
	{
		D = [NSMutableDictionary dictionary];
		metaSETTER(D);
		D = metaGETTER;
		if (D)
		{
			self.documentClassNameForTypeDictionary;// initialize as side effect
//LOG4iTM3(@"localizedDocumentTypesDictionary:%@",D);
		}
	}
//END4iTM3;
    return D;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  localizedTypeForContentsOfURL:error4iTM3:
- (NSString *)localizedTypeForContentsOfURL:(NSURL *)inAbsoluteURL error4iTM3:(NSError **)outErrorPtr;
/*"On n'est jamais si bien servi que par soi-meme
Version History: jlaurens AT users DOT sourceforge DOT net (today)
- 2.0: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSString * documentType = [self typeForContentsOfURL:inAbsoluteURL error:outErrorPtr];
    return documentType.length? (NSString *)UTTypeCopyDescription((CFStringRef)documentType):@"";
}
@synthesize _Implementation;
@end

@implementation NSDocument(iTM2DocumentControllerKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  newRecentDocument
- (id)newRecentDocument;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  displayLine:column:length:withHint:orderFront:
- (BOOL)displayLine:(NSUInteger)line column:(NSUInteger)column length:(NSUInteger)length withHint:(NSDictionary *)hint orderFront:(BOOL)yorn;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
	return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  getLine:column:length:forHint:
- (NSUInteger)getLine:(NSUInteger *)lineRef column:(NSUInteger *)columnRef length:(NSUInteger *)lengthRef forHint:(NSDictionary *)hint;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
	return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  displayPageForLine:column:source:withHint:orderFront:force:
- (BOOL)displayPageForLine:(NSUInteger)line column:(NSUInteger)column source:(NSURL *)sourceURL withHint:(NSDictionary *)hint orderFront:(BOOL)yorn force:(BOOL)force;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  swizzle_readableTypes4iTM3
+ (NSArray *)swizzle_readableTypes4iTM3;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return [[SDC documentClassNameForTypeDictionary] allKeysForObject:NSStringFromClass(self)];
}
@end

@interface NSMenu(iTM2OpenQuicklyMenu)
- (NSUInteger)_completeWithCurrentDirectoryContentsForDepth:(NSUInteger)depth limit:(NSUInteger)limit;
@end

NSString * const iTM2OpenQuicklyCountKey = @"iTM2:OpenQuicklyCount";
NSString * const iTM2OpenQuicklyDepthKey = @"iTM2:OpenQuicklyDepth";
NSString * const iTM2OpenQuicklyLimitKey = @"iTM2:OpenQuicklyLimit";
NSString * const iTM2OpenQuicklyCachedKey = @"iTM2:OpenQuicklyCached";

#import "iTM2MenuKit.h"
//#import "../99 - JAGUAR/iTM2JAGUARSupportKit.h"

@interface NSMenu(DocumentController)
- (NSUInteger)_completeWithDirectoryContentsAtPath:(NSString *)cdp forDepth:(NSUInteger)depth limit:(NSUInteger)limit;
@end

@implementation iTM2MainInstaller(OpenQuicklyMenu)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2OpenQuicklyMenuCompleteInstallation4iTM3
+ (void)iTM2OpenQuicklyMenuCompleteInstallation4iTM3;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 11/21/2003
To Do List: retain?
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[iTM2OpenQuicklyMenu class];
//END4iTM3;
	return;
}
@end

@implementation iTM2OpenQuicklyMenu
static NSMenuItem * _iTM2OpenQuicklyTextMenuItem = nil;
static NSMenuItem * _iTM2OpenQuicklyGfxMenuItem = nil;
static NSMenuItem * _iTM2OpenQuicklyOtherMenuItem = nil;
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initialize
+ (void)initialize;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 11/21/2003
To Do List: retain?
"*/
{DIAGNOSTIC4iTM3;
	INIT_POOL4iTM3;
//START4iTM3;
	[super initialize];
	_iTM2OpenQuicklyTextMenuItem = [[[NSApp mainMenu] deepItemWithAction4iTM3:@selector(openDocumentQuicklyText:)] retain];
	_iTM2OpenQuicklyGfxMenuItem = [[[NSApp mainMenu] deepItemWithAction4iTM3:@selector(openDocumentQuicklyGfx:)] retain];
	_iTM2OpenQuicklyOtherMenuItem = [[[NSApp mainMenu] deepItemWithAction4iTM3:@selector(openDocumentQuicklyOther:)] retain];
	NSMenu * m = [[_iTM2OpenQuicklyTextMenuItem.menu retain] autorelease];
	[[m supermenu] setSubmenu:[[[iTM2OpenQuicklyMenu alloc] initWithTitle:@""] autorelease] forItem:[[m supermenu] itemAtIndex:[[m supermenu] indexOfItemWithSubmenu:m]]];
	[_iTM2OpenQuicklyTextMenuItem.menu removeItem:_iTM2OpenQuicklyTextMenuItem];
	[_iTM2OpenQuicklyGfxMenuItem.menu removeItem:_iTM2OpenQuicklyGfxMenuItem];
	[_iTM2OpenQuicklyOtherMenuItem.menu removeItem:_iTM2OpenQuicklyOtherMenuItem];
    [SUD registerDefaults:
        [NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithInteger:20], iTM2OpenQuicklyCountKey,
            [NSNumber numberWithInteger:5], iTM2OpenQuicklyDepthKey,
            [NSNumber numberWithInteger:100], iTM2OpenQuicklyLimitKey,
            [NSNumber numberWithBool:YES], iTM2OpenQuicklyCachedKey,
                nil]];
	if (!_iTM2OpenQuicklyTextMenuItem)
	{
		LOG4iTM3(@"WARNING: Missing locale for an open quickly text menu item");
		_iTM2OpenQuicklyTextMenuItem = [[[NSMenuItem alloc]
			initWithTitle: @"Text Documents" action: NULL keyEquivalent: @""] retain];
	}
	if (!_iTM2OpenQuicklyGfxMenuItem)
	{
		LOG4iTM3(@"WARNING: Missing locale for an open quickly text menu item");
		_iTM2OpenQuicklyGfxMenuItem = [[[NSMenuItem alloc]
			initWithTitle: @"Graphics Documents" action: NULL keyEquivalent: @""] retain];
	}
	if (!_iTM2OpenQuicklyOtherMenuItem)
	{
		LOG4iTM3(@"WARNING: Missing locale for an open quickly text menu item");
		_iTM2OpenQuicklyOtherMenuItem = [[[NSMenuItem alloc]
			initWithTitle: @"Other Documents" action: NULL keyEquivalent: @""] retain];
	}
//END4iTM3;
	RELEASE_POOL4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  update
- (void)update;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 11/21/2003
To Do List: retain?
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSUInteger old = self.numberOfItems;
    NSString * cdp = [DFM currentDirectoryPath];
    NSString *
	//aFullPath = [[[SDC currentDocument] fileName] stringByDeletingLastPathComponent];
	aFullPath = [[SUD stringForKey:iTM2NavLastRootDirectory] stringByStandardizingPath];
//LOG4iTM3(@"aFullPath is: %@", aFullPath);
//LOG4iTM3(@"self.title is:%@", self.title);
    if ([self.title pathIsEqual4iTM3:aFullPath])
        return;
    if ([cdp pathIsEqual4iTM3:aFullPath] || [DFM changeCurrentDirectoryPath:aFullPath])
    {
        self.title = aFullPath;
        [self _completeWithDirectoryContentsAtPath:aFullPath forDepth:[SUD integerForKey:iTM2OpenQuicklyDepthKey]
                limit: [SUD integerForKey:iTM2OpenQuicklyLimitKey]];
        [DFM changeCurrentDirectoryPath:cdp];
    }
    while(old--)
        [self removeItemAtIndex:0];
	// title menu item
	[self insertItem:[NSMenuItem separatorItem] atIndex:0];
	[self insertItemWithTitle:[@"..." stringByAppendingPathComponent:aFullPath.lastPathComponent]
		action: NULL keyEquivalent: @"" atIndex: 0];
	self.cleanSeparators4iTM3;
    [super update];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= _action:
+ (void)_action:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 11/21/2003
To Do List: retain?
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (![SDC openDocumentWithContentsOfURL:[NSURL fileURLWithPath:[sender representedString]] display:YES error:nil])
        [[NSWorkspace sharedWorkspace] openFile:[sender representedString]];
    return;
}
@end

@implementation NSMenu(DocumentController)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= _completeWithDirectoryContentsAtPath:forDepth:limit:
- (NSUInteger)_completeWithDirectoryContentsAtPath:(NSString *)cdp forDepth:(NSUInteger)depth limit:(NSUInteger)limit;
/*"Description Forthcoming. ".hidden" files compatible.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 03/10/2002
To Do List: retain?
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (depth == 0) return 0;
    if (limit == 0) return 0;
    NSFileManager * dfm = DFM;
    NSMutableArray * hiddenFiles = [NSMutableArray array];
    NSEnumerator * E = [[[NSString stringWithContentsOfFile:@".hidden" usedEncoding:nil error:nil] componentsSeparatedByString:@"\n"] objectEnumerator];
    NSString * O;
    while(O = [E nextObject])
        [hiddenFiles addObjectsFromArray:[O componentsSeparatedByString:@"\r"]];
    E = [[dfm contentsOfDirectoryAtPath:cdp error:NULL] objectEnumerator];
    NSMutableArray * textFiles = [NSMutableArray array];
    NSMutableArray * gfxFiles = [NSMutableArray array];
    NSMutableArray * otherFiles = [NSMutableArray array];
    NSMutableArray * directories = [NSMutableArray array];
oneMoreTime:
    if (O = [E nextObject])
    {
        if ([O hasPrefix:@"."])
            goto oneMoreTime;
        if ([hiddenFiles containsObject:O])
            goto oneMoreTime;
        if ([O.stringByDeletingPathExtension hasSuffix:@"~"])
            goto oneMoreTime;

        NSString * extension = [[O pathExtension] lowercaseString];
        if ([extension isEqualToString:@"tex"] || [extension isEqualToString:@"texp"] || [extension isEqualToString:@"texd"])
        {
            [textFiles addObject:O];
        }
        else if ([extension isEqualToString:@"pdf"] || [extension isEqualToString:@"dvi"])
        {
            [gfxFiles addObject:O];
        }
        else if ([O isEqualToString:@"CVS"])
			goto oneMoreTime;
        else if (O.length)
        {
            NSString * P = [cdp stringByAppendingPathComponent:O];
			BOOL isDirectory;
			if ([SWS isFilePackageAtPath:P])
			{
				[otherFiles addObject:O];
			}
            else if ([dfm fileExistsAtPath:P isDirectory:&isDirectory] && isDirectory)
            {
                [directories addObject:O];
            }
			else
			{
				[otherFiles addObject:O];
			}
        }
        goto oneMoreTime;
    }
	NSUInteger level = 1;
	if (textFiles.count)
	{
		NSMenuItem * MI = [[_iTM2OpenQuicklyTextMenuItem copy] autorelease];
		[self addItem:MI];
		E = textFiles.objectEnumerator;
		if (textFiles.count > [SUD integerForKey:iTM2OpenQuicklyCountKey])
		{
			// too many items, use a submenu
			NSMenu * M = [[[NSMenu alloc] initWithTitle:MI.title] autorelease];
			[self setSubmenu:M forItem:MI];
			while(O = [E nextObject])
			{
				NSMenuItem * MI = [M addItemWithTitle:O action:@selector(_action:) keyEquivalent:@""];
				[MI setTarget:[iTM2OpenQuicklyMenu class]];
				MI.representedObject = [cdp stringByAppendingPathComponent:O];
			}
		}
		else
		{
			while(O = [E nextObject])
			{
				NSMenuItem * MI = [self addItemWithTitle:O action:@selector(_action:) keyEquivalent:@""];
				MI.indentationLevel = level;
				[MI setTarget:[iTM2OpenQuicklyMenu class]];
				MI.representedObject = [cdp stringByAppendingPathComponent:O];
			}
			if (limit < textFiles.count)
				return 0;
			else
				limit -= textFiles.count;
		}
	}
	if (gfxFiles.count)
	{
		NSMenuItem * MI = [[_iTM2OpenQuicklyGfxMenuItem copy] autorelease];
		[self addItem:MI];
		E = gfxFiles.objectEnumerator;
		if (textFiles.count + gfxFiles.count > [SUD integerForKey:iTM2OpenQuicklyCountKey])
		{
			// too many items, use a submenu
			NSMenu * M = [[[NSMenu alloc] initWithTitle:MI.title] autorelease];
			[self setSubmenu:M forItem:MI];
			while(O = [E nextObject])
			{
				NSMenuItem * MI = [M addItemWithTitle:O action:@selector(_action:) keyEquivalent:@""];
				[MI setTarget:[iTM2OpenQuicklyMenu class]];
				MI.representedObject = [cdp stringByAppendingPathComponent:O];
			}
		}
		else
		{
			while(O = [E nextObject])
			{
				NSMenuItem * MI = [self addItemWithTitle:O action:@selector(_action:) keyEquivalent:@""];
				MI.indentationLevel = level;
				[MI setTarget:[iTM2OpenQuicklyMenu class]];
				MI.representedObject = [cdp stringByAppendingPathComponent:O];
			}
			if (limit < gfxFiles.count)
				return 0;
			else
				limit -= gfxFiles.count;
		}
	}
	if (otherFiles.count)
	{
		E = otherFiles.objectEnumerator;
		if (textFiles.count + gfxFiles.count > 0)
		{
			NSMenuItem * MI = [[_iTM2OpenQuicklyOtherMenuItem copy] autorelease];
			[self addItem:MI];
			// use a submenu
			NSMenu * M = [[[NSMenu alloc] initWithTitle:MI.title] autorelease];
			[self setSubmenu:M forItem:MI];
			while(O = [E nextObject])
			{
				NSMenuItem * MI = [M addItemWithTitle:O action:@selector(_action:) keyEquivalent:@""];
				[MI setTarget:[iTM2OpenQuicklyMenu class]];
				MI.representedObject = [cdp stringByAppendingPathComponent:O];
			}
		}
		else
		{
			while(O = [E nextObject])
			{
				NSMenuItem * MI = [self addItemWithTitle:O action:@selector(_action:) keyEquivalent:@""];
				MI.indentationLevel = level;
				[MI setTarget:[iTM2OpenQuicklyMenu class]];
				MI.representedObject = [cdp stringByAppendingPathComponent:O];
			}
		}
	}
    for(O in directories)
    {
		NSMenuItem * MI = [self addItemWithTitle:O action:NULL keyEquivalent:@""];
		NSMenu * M = [[[NSMenu alloc] initWithTitle:@""] autorelease];
		[self setSubmenu:M forItem:MI];
        NSString * P = [cdp stringByAppendingPathComponent:O];
		if (limit > 0)
		{
			limit = [M _completeWithDirectoryContentsAtPath:P forDepth:depth-1 limit:limit];
			if (![M numberOfItems])
				[MI setEnabled:NO];
		}
		else
			[MI setEnabled:NO];
    }
    return limit;
}
@end

#pragma mark =-=-=-=-=-  GHOST DOCUMENT
@implementation iTM2GhostDocument
- (BOOL)displayPageForLine:(NSUInteger)line column:(NSUInteger)column source:(NSURL *)sourceURL withHint:(NSDictionary *)hint orderFront:(BOOL)yorn;
{DIAGNOSTIC4iTM3;
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  newRecentDocument
- (id)newRecentDocument;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return nil;
}
@end

@implementation NSString(iTM2DocumentController)

- (BOOL)isEqualToUTType4iTM3:(NSString *)otherType;
{
    return otherType != nil && UTTypeEqual((CFStringRef)self, (CFStringRef)otherType);
}

- (BOOL)conformsToUTType4iTM3:(NSString *)otherType;
{
    return otherType != nil && UTTypeConformsTo((CFStringRef)self, (CFStringRef)otherType);
}

- (NSDictionary *) UTTypeDeclaration4iTM3;
{
    return (NSDictionary *)UTTypeCopyDeclaration((CFStringRef)self);
}

- (NSURL *) UTTypeDeclaringBundleURL4iTM3;
{
    return (NSURL *)UTTypeCopyDeclaringBundleURL((CFStringRef)self);
}

@end

#if 0

/*! UTI's and pasteboard types... */


NSString *SKGetDVIDocumentType(void) {
	- return floor(NSAppKitVersionNumber) <= NSAppKitVersionNumber10_5 ? 
	SKDVIDocumentType : SKDVIDocumentUTI;
	
	
	NSColorPboardType
	NSPasteboardTypeColor
	com.apple.cocoa.pasteboard.color
	NSSoundPboardType
	NSPasteboardTypeSound
	com.apple.cocoa.pasteboard.sound
	NSFontPboardType
	NSPasteboardTypeFont
	com.apple.cocoa.pasteboard.character-formatting
	NSRulerPboardType
	NSPasteboardTypeRuler
	com.apple.cocoa.pasteboard.paragraph-formatting
	NSTabularTextPboardType
	NSPasteboardTypeTabularText
	com.apple.cocoa.pasteboard.tabular-text
	NSMultipleTextSelectionPboardType
	NSPasteboardTypeMultipleTextSelection
	com.apple.cocoa.pasteboard.multiple-text-selection
	NSFindPanelSearchOptionsPboardType
	NSPasteboardTypeFindPanelSearchOptions
	com.apple.cocoa.pasteboard.find-panel-search-options
	Constants for Common Pasteboard Types with Existing UTIs
		The following table shows pasteboard types for which there are existing UTIs. The table shows the Mac OS X v10.5 and earlier constant (where there is one), the Mac OS X v10.6 constant, and the UTI string.
			
			Old Constant
			New Constant
			UTI String
			NSStringPboardType
			NSPasteboardTypeString
			public.utf8-plain-text
			NSPDFPboardType
			NSPasteboardTypePDF
			com.adobe.pdf
			NSRTFPboardType
			NSPasteboardTypeRTF
			public.rtf
			NSRTFDPboardType
			NSPasteboardTypeRTFD
			com.apple.flat-rtfd
			NSTIFFPboardType
			NSPasteboardTypeTIFF
			public.tiff
			NSPasteboardTypePNG
			public.png
			NSHTMLPboardType
			NSPasteboardTypeHTML
			public.html
			Pasteboard Types Without Direct Replacement
			Some Mac OS X v10.5 constants do not have corresponding constant definitions on Mac OS X v10.6. The following table shows either their deprecation status or what you should use instead.
				
				Constant
				Replacement/Comments
				NSPICTPboardType
				Deprecated in Mac OS X v10.6
				NSFilesPromisePboardType
				Use (NSString *)kPasteboardTypeFileURLPromise instead.
				NSVCardPboardType
				Use (NSString *)kUTTypeVCard instead.
				NSPostScriptPboardType
				Use @"com.adobe.encapsulated-postscript" instead.
				NSInkTextPboardType
				Use (NSString *)kUTTypeInkText instead.
#endif
