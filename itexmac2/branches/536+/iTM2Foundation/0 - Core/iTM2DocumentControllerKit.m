/*
//
//  @version Subversion: $Id$ 
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

#import <iTM2Foundation/iTM2DocumentControllerKit.h>
#import <iTM2Foundation/iTM2PathUtilities.h>
#import <iTM2Foundation/iTM2NotificationKit.h>
#import <iTM2Foundation/iTM2ContextKit.h>
#import <iTM2Foundation/iTM2InstallationKit.h>
#import <iTM2Foundation/iTM2Implementation.h>
#import <iTM2Foundation/iTM2ValidationKit.h>
#import <iTM2Foundation/iTM2ObjectServer.h>
#import <iTM2Foundation/iTM2UserDefaultsKit.h>
#import <iTM2Foundation/iTM2BundleKit.h>
#import <iTM2Foundation/iTM2AutoKit.h>
#import <iTM2Foundation/iTM2RuntimeBrowser.h>
#import <iTM2Foundation/iTM2WindowKit.h>

#define TABLE @"iTM2DocumentKit"
#define BUNDLE [iTM2Document classBundle]

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  NSDocumentController(iTeXMac2)
/*"Description forthcoming."*/

#import <iTM2Foundation/iTM2PDFDocumentKit.h>

@implementation NSDocumentController(iTeXMac2Kit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  displayPageForLine:column:source:withHint:orderFront:force:
- (BOOL)displayPageForLine:(unsigned int)line column:(unsigned int)column source:(NSString *)source withHint:(NSDictionary *)hint orderFront:(BOOL)yorn force:(BOOL)force;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= forgetRecentDocumentURL:
- (void)forgetRecentDocumentURL:(NSURL *)absoluteURL;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id urls = [self recentDocumentURLs];
	if([urls containsObject:absoluteURL])
	{
		[self clearRecentDocuments:nil];
		urls = [NSMutableArray arrayWithArray:urls];
		[urls removeObject:absoluteURL];
		NSEnumerator * E = [urls objectEnumerator];
		while(absoluteURL = [E nextObject])
		{
			[self noteNewRecentDocumentURL:absoluteURL];
		}
	}
//iTM2_END;
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(self = [super init])
    {
        [self initImplementation];
		[self setAutosavingDelay:[SUD floatForKey:iTM2AutosavingDelayKey]];
    }
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
	[self willDealloc];
    [DNC removeObserver:self];
    [self deallocImplementation];
    [super dealloc];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  implementation
- (id)implementation;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
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
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(_Implementation != argument)
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self saveAllDocuments:self];
    BOOL resultFlag = YES;
    NSMethodSignature * myMS = [self methodSignatureForSelector:
                                    @selector(_fakeDocumentController:didSaveAll:contextInfo:)];
    if([myMS isEqual:[delegate methodSignatureForSelector:action]])
    {
        NSInvocation * I = [NSInvocation invocationWithMethodSignature:myMS];
        [I setSelector:action];
        [I setTarget:delegate];
        [I setArgument:&self atIndex:2];
        [I setArgument:&resultFlag atIndex:3];
        if(contextInfo)
            [I setArgument:&contextInfo atIndex:4];
        [I invoke];
    }
    else
    {
	//iTM2_START;
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= openDocumentWithContentsOfFile:displayPageForLine:column:source:withHint:orderFront:
- (id)openDocumentWithContentsOfFile:(NSString *)fileName displayPageForLine:(unsigned int)line column:(unsigned int)column source:(NSString *)source withHint:(NSDictionary *)hint orderFront:(BOOL)yorn;
/*"This is the answer to the notification sent by the "e_Helper" tool.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 11/06/2003
To Do List: see the warning below
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id doc = [SDC documentForFileName:fileName];
	if(doc)
	{
		[doc updateIfNeeded];
		[doc displayPageForLine:line column:column source:source withHint:hint orderFront:yorn force:YES];
		return doc;
	}
	NSURL * url = nil;
	if(yorn)
	{
		url = [NSURL fileURLWithPath:fileName];
		doc = [SDC openDocumentWithContentsOfURL:url display:YES error:nil];
		[doc displayPageForLine:line column:column source:source withHint:hint orderFront:yorn force:YES];
		return doc;
	}
	else
	{
		url = [NSURL fileURLWithPath:fileName];
		doc = [SDC openDocumentWithContentsOfURL:url display:NO error:nil];
		[doc makeWindowControllers];
		NSEnumerator * E = [[doc windowControllers] objectEnumerator];
		NSWindowController * WC;
		NSWindow * W;
		while(WC = [E nextObject])
		{
			W = [WC window];
			[W orderBelowFront:self];
		}
		[doc displayPageForLine:line column:column source:source withHint:hint orderFront:yorn force:NO];
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [super addDocument:document];
    if(iTM2DebugEnabled>100)
    {
        iTM2_LOG(@"document added: %@, with name: %@", document, [document fileName]);
		iTM2_LOG(@"[self typeFromFileExtension:\"PDF \"]:%@", [self typeFromFileExtension:@"PDF "]);
		iTM2_LOG(@"[self typeFromFileExtension:\"pdf\"]:%@", [self typeFromFileExtension:@"pdf"]);
		iTM2_LOG(@"class: %@", [self documentClassForType:[self typeFromFileExtension:@"pdf"]]);
    }
    if([document isKindOfClass:[iTM2GhostDocument class]])
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([SUD boolForKey:@"iTM2NoMoreRecentDocuments"])
		return;
	id newRecentDocument = [document newRecentDocument];
    if(newRecentDocument)
	{
		// the document wants to appear in the recent docs list
		NSURL * URL = [newRecentDocument fileURL];// do not assume that any document has a URL
		if(URL)
		{
			[self noteNewRecentDocumentURL:URL];
			if(iTM2DebugEnabled)
			{
				iTM2_LOG(@"document ADDED IN THE RECENT DOCS LIST: %@", document);
				NSLog(@"[document fileName]:%@", [document fileName]);
				NSLog(@"[newRecentDocument fileName]:%@", [newRecentDocument fileName]);
				NSLog(@"[self recentDocumentURLs]:%@", [self recentDocumentURLs]);
			}
		}
	}
//iTM2_END;
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSEnumerator * E = [[self documents] objectEnumerator];
    id doc;
    while(doc = [E nextObject])
		if([doc respondsToSelector:@selector(projectDocumentWillClose)])
			[doc performSelector:@selector(projectDocumentWillClose) withObject:nil];
    [super closeAllDocumentsWithDelegate:delegate didCloseAllSelector:didAllCloseSelector contextInfo:contextInfo];
//iTM2_END;
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	NSArray * result = [super documentClassNames];
//iTM2_LOG(@"[super documentClassNames] is:%@", [super documentClassNames]);
//iTM2_LOG(@"[[self documentClassNameForTypeDictionary] allValues] is:%@", [[self documentClassNameForTypeDictionary] allValues]);
    return [super documentClassNames];//[[self documentClassNameForTypeDictionary] allValues];
}
#endif
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  documentClassNameForTypeDictionary;
- (NSDictionary *)documentClassNameForTypeDictionary;
/*"Description Forthcoming
Version History: jlaurens AT users DOT sourceforge DOT net (today)
- 2.0: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSMutableDictionary * D = metaGETTER;
	if(!D)
	{
		NSBundle * B;
		NSMutableDictionary * fromFrameworks = [NSMutableDictionary dictionary];
		NSString * className;
		NSString * documentType;
		NSDictionary * d;
		NSString * localizedType;
		NSEnumerator * E = [[NSBundle allFrameworks] objectEnumerator];
		while(B = [E nextObject])
		{
			NSEnumerator * e = [[B objectForInfoDictionaryKey:@"CFBundleDocumentTypes"] objectEnumerator];
			while(d = [e nextObject])
			{
				documentType = [d objectForKey:@"CFBundleTypeName"];
				className = [d objectForKey:@"NSDocumentClass"];
				if([documentType isKindOfClass:[NSString class]]
					&& [className isKindOfClass:[NSString class]]
						&& NSClassFromString(className))
				{
					[fromFrameworks setObject:className forKey:documentType];
					localizedType = [[B localizedInfoDictionary] objectForKey:documentType];
					if([localizedType length])
					{
						[(id)[self localizedDocumentTypesDictionary] setObject:localizedType forKey:documentType];
					}
				}
				else
				{
					iTM2_LOG(@"ERROR: Bad Info.plist in bundle %@", B);
				}
			}
		}
		B = [NSBundle mainBundle];
		NSMutableDictionary * fromMainBundle = [NSMutableDictionary dictionary];
		#if 0
		E = [[B objectForInfoDictionaryKey:@"CFBundleDocumentTypes"] objectEnumerator];
		while(d = [E nextObject])
		{
			documentType = [d objectForKey:@"CFBundleTypeName"];
			className = [d objectForKey:@"NSDocumentClass"];
			if([documentType isKindOfClass:[NSString class]]
				&& [className isKindOfClass:[NSString class]]
					&& NSClassFromString(className))
			{
				[fromMainBundle setObject:className forKey:documentType];
				localizedType = [[B localizedInfoDictionary] objectForKey:documentType];
				if([localizedType length])
				{
					[[self localizedDocumentTypesDictionary] setObject:localizedType forKey:documentType];
				}
			}
			else
			{
				iTM2_LOG(@"ERROR: Bad Info.plist in bundle %@", B);
			}
		}
		#else
		// I try to use the inherited methods:
		E = [[super documentClassNames] objectEnumerator];
		while(className = [E nextObject])
		{
			Class C = NSClassFromString(className);
			if([C isSubclassOfClass:[NSDocument class]])
			{
				NSEnumerator * e = [[C readableTypes] objectEnumerator];
				while(documentType = [e nextObject])
				{
					Class oldC = [fromMainBundle objectForKey:documentType];
					if(!oldC || [C isSubclassOfClass:oldC])
					{
						[fromMainBundle setObject:className forKey:documentType];
						localizedType = [[B localizedInfoDictionary] objectForKey:documentType];
						if([localizedType length])
						{
							[(NSMutableDictionary *)[self localizedDocumentTypesDictionary] setObject:localizedType forKey:documentType];
						}
					}
				}
			}
		}
		#endif
		NSMutableDictionary * fromPlugIns = [NSMutableDictionary dictionary];
		E = [[NSBundle availablePlugInPathsOfType:[NSBundle plugInPathExtension]] objectEnumerator];
		NSString * path;
		while(path = [E nextObject])
		{
			B = [NSBundle bundleWithPath:path];
			NSEnumerator * e = [[B objectForInfoDictionaryKey:@"CFBundleDocumentTypes"] objectEnumerator];
			while(d = [e nextObject])
			{
//iTM2_LOG(@"[D objectForKey:\"CFBundleTypeOSTypes\"] is:%@", [D objectForKey:@"CFBundleTypeOSTypes"]);
				documentType = [d objectForKey:@"CFBundleTypeName"];
				className = [d objectForKey:@"NSDocumentClass"];
				if([documentType isKindOfClass:[NSString class]]
					&& [className isKindOfClass:[NSString class]])
				{
					Class documentClass = NSClassFromString(className);
					if(documentClass)
					{
						NSString * classNameFromMainBundle = [fromMainBundle objectForKey:documentType];
						Class documentClassFromMainBundle = NSClassFromString(classNameFromMainBundle);
						if(documentClassFromMainBundle)
						{
							if([documentClass isSubclassOfClass:documentClassFromMainBundle])
							{
								[fromPlugIns setObject:className forKey:documentType];
								localizedType = [[B localizedInfoDictionary] objectForKey:documentType];
								if([localizedType length])
								{
									[(NSMutableDictionary *)[self localizedDocumentTypesDictionary] setObject:localizedType forKey:documentType];
								}
							}
							else
							{
								iTM2_LOG(@"ERROR: Bad Info.plist in plug-in %@ (%@ must be a subclass of %@)", B, className, classNameFromMainBundle);
							}
						}
						else
						{
							[fromPlugIns setObject:className forKey:documentType];
						}
					}
					else
					{
						iTM2_LOG(@"ERROR: Bad Info.plist in bundle %@ (No class for that name %@)", B, className);
					}
				}
				else
				{
					iTM2_LOG(@"ERROR: Bad Info.plist in bundle %@ (NSString expected but got %@ and %@)", B, documentType, className);
				}
		//iTM2_LOG(@"NOT THIS ONE =-=-=-=-=-");
			}
		}
		[fromFrameworks addEntriesFromDictionary:fromMainBundle];
		[fromFrameworks addEntriesFromDictionary:fromPlugIns];
		metaSETTER(fromFrameworks);
		D = metaGETTER;
		[iTM2RuntimeBrowser swizzleClassMethodSelector:@selector(readableTypes)
			replacement:@selector(iTM2_swizzle_readableTypes) forClass: [NSDocument class]];
		if(iTM2DebugEnabled)
		{
			E = [D keyEnumerator];
			while(documentType = [E nextObject])
			{
				className = [D objectForKey:documentType];
				Class documentClass = NSClassFromString(className);
				iTM2_LOG(@"%@ -> %@, %@", documentType, className, [NSBundle bundleForClass:documentClass]);
			}
		}
	}
//iTM2_END;
    return D;
}
#if 1
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  documentClassForType:
- (Class)documentClassForType:(NSString *)documentTypeName;
/*"On n'est jamais si bien servi qua par soi-meme
Version History: jlaurens AT users DOT sourceforge DOT net (today)
- 2.0: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id result = NSClassFromString([[self documentClassNameForTypeDictionary] objectForKey:documentTypeName]);
	if(result)
		return result;
	result = [super documentClassForType:documentTypeName];// this verbose style is usefull for debugging purpose
//iTM2_END;
	return result;
}
#warning THIS IS A BUG CATCHER!!! What bug man? Sometimes the document is not opened with the expected class...
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  typeFromFileExtensionDictionary
- (NSDictionary *)typeFromFileExtensionDictionary;
/*"On n'est jamais si bien servi que par soi-meme
Version History: jlaurens AT users DOT sourceforge DOT net (today)
- 2.0: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSMutableDictionary * D = metaGETTER;
	if(!D)
	{
		D = [NSMutableDictionary dictionary];
		NSDictionary * DCNFTD = [self documentClassNameForTypeDictionary];
		NSMutableArray * DCNs = [NSMutableArray arrayWithArray:[DCNFTD allKeys]];
		NSEnumerator * E = [DCNFTD keyEnumerator];
		NSString * documentType;
		while(documentType = [E nextObject])
		{
			NSArray * FEs = [super fileExtensionsFromType:documentType];
			NSEnumerator * e = [FEs objectEnumerator];
			NSString * FE;
			if(FE = [e nextObject])
			{
				[DCNs removeObject:documentType];
				do
				{
					[D setObject:documentType forKey:[FE lowercaseString]];
				}
				while(FE = [e nextObject]);
			}
		}
		E = [DCNs objectEnumerator];
		while(documentType = [E nextObject])
		{
			NSString * className = [DCNFTD objectForKey:documentType];
			Class C = NSClassFromString(className);
			NSBundle * B = [C classBundle];
			if(B)
			{
				NSEnumerator * e = [[B objectForInfoDictionaryKey:@"CFBundleDocumentTypes"] objectEnumerator];
				NSDictionary * d;
				while(d = [e nextObject])
				{
					if([[d objectForKey:@"CFBundleTypeName"] isEqual:documentType]
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
				iTM2_LOG(@".....  ERROR: No document class named: %@", className);
			}
		}
		metaSETTER(D);
		D = metaGETTER;
		if(iTM2DebugEnabled)
		{
			E = [D keyEnumerator];
			while(documentType = [E nextObject])
			{
				NSString * className = [D objectForKey:documentType];
				iTM2_LOG(@"%@ -> %@", documentType, className);
			}
		}
	}
//iTM2_END;
    return D;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  typeFromFileExtension:
- (NSString *)typeFromFileExtension:(NSString *)fileNameExtensionOrHFSFileType;
/*"On n'est jamais si bien servi que par soi-meme
Version History: jlaurens AT users DOT sourceforge DOT net (today)
- 2.0: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_LOG(@"fileNameExtension is: %@", fileNameExtension);
	return [[self typeFromFileExtensionDictionary] objectForKey:[fileNameExtensionOrHFSFileType lowercaseString]]?:
		([[self typeFromFileExtensionDictionary] objectForKey:fileNameExtensionOrHFSFileType]?:
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSMutableDictionary * D = metaGETTER;
	if(!D)
	{
		D = [NSMutableDictionary dictionary];
		metaSETTER(D);
		D = metaGETTER;
		if(D)
		{
			[self documentClassNameForTypeDictionary];// initialize as side effect
//iTM2_LOG(@"localizedDocumentTypesDictionary:%@",D);
		}
	}
//iTM2_END;
    return D;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  localizedTypeForContentsOfURL:error:
- (NSString *)localizedTypeForContentsOfURL:(NSURL *)inAbsoluteURL error:(NSError **)outErrorPtr;
/*"On n'est jamais si bien servi que par soi-meme
Version History: jlaurens AT users DOT sourceforge DOT net (today)
- 2.0: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_LOG(@"fileNameExtension is: %@", fileNameExtension);
	if([inAbsoluteURL isFileURL])
	{
		id localizedDocumentTypesDictionary = [self localizedDocumentTypesDictionary];
		NSString * documentType = [SDC typeForContentsOfURL:inAbsoluteURL error:outErrorPtr];
		if([documentType length])
		{
			NSString * localizedType = [localizedDocumentTypesDictionary objectForKey:documentType];
			if([localizedType length])
			{
				return localizedType;
			}
		}
		// the application relies on others to provide a localized string
		NSString * fullPath = [inAbsoluteURL path];
		NSString * applicationName = nil;
		NSString * type = nil;
		NSString * infoPath = nil;
		NSMutableArray * allApplications = nil;
		NSURL * url;
		if([SWS getInfoForFile:fullPath application:&applicationName type:&type])
		{
nextApplication:
			infoPath = [applicationName stringByAppendingPathComponent:@"Contents"];
			infoPath = [infoPath stringByAppendingPathComponent:@"Info.plist"];
			url = [NSURL fileURLWithPath:infoPath];
			NSXMLDocument * doc = [[[NSXMLDocument allocWithZone:[self zone]]
						initWithContentsOfURL:url options:0 error:outErrorPtr] autorelease];
			if(doc)
			{
				// this is a cocoa app or bundle, very cool
				NSString * extension = [fullPath pathExtension];
				extension = [extension lowercaseString];
				NSXMLElement * rootElement = [doc rootElement];
//				/*
//					...
//					<plist version="1.0">							//plist
//					<dict>											//dict
//						<key>CFBundleDevelopmentRegion</key>
//						<string>English</string>
//						<key>CFBundleDocumentTypes</key>			//key[text()=\"CFBundleDocumentTypes\"
//						<array>										//following-sibling::*[1]
//							<dict>									//dict
//								<key>CFBundleTypeExtensions</key>	//key[text()=\"CFBundleTypeExtensions\"
//								<array>								//following-sibling::*[1]
//									<string>EXTENSION</string>		//string[text()="EXTENSION"]<--node
//								</array>
//								<key>CFBundleTypeMIMETypes</key>
//								<array>
//									<string>text/plain</string>
//								</array>
//								<key>CFBundleTypeName</key>
//								<string>Wildcard Document</string>
//								...
//							</dict>
//						</array>
//					</dict>
//					</plist>
//				*/
				NSString * xpath = [NSString stringWithFormat:@"following-sibling::*[1]/string[text()=\"%@\"]",extension];
				xpath = [@"following-sibling::*[1]/dict/key[text()=\"CFBundleTypeExtensions\"]" stringByAppendingPathComponent:xpath];
				xpath = [@"/plist/dict/key[text()=\"CFBundleDocumentTypes\"]" stringByAppendingPathComponent:xpath];
				NSArray * nodes = [rootElement nodesForXPath:xpath error:nil];
				if([nodes count])
				{
					NSXMLNode * node = [nodes objectAtIndex:0];
					// get the document type as declared in the plist file
					//
					xpath = @"../../key[text()=\"CFBundleTypeName\"]/following-sibling::*[1]";
					nodes = [node nodesForXPath:xpath error:nil];
					if([nodes count])
					{
						node = [nodes objectAtIndex:0];
						type = [node stringValue];
						NSBundle * B = [NSBundle bundleWithPath:applicationName];
						NSDictionary * dico = [B localizedInfoDictionary];
						NSString * localizedType = [dico objectForKey:type];
						if([localizedType length])
						{
							[localizedDocumentTypesDictionary setObject:localizedType forKey:documentType];
							return localizedType;
						}
					}
				}
			}
		}
		if(!allApplications)
		{
			NSArray * allCandidates = (NSMutableArray *)LSCopyApplicationURLsForURL((CFURLRef)inAbsoluteURL,kLSRolesAll);
			[allCandidates autorelease];
			NSString * userApplicationsPrefix = [NSHomeDirectory() stringByAppendingPathComponent:@"Applications"];
			userApplicationsPrefix = [userApplicationsPrefix lowercaseString];
			NSMutableArray * forbiddenApplications = [NSMutableArray arrayWithCapacity:2];
			if([applicationName length])//applicationName was returned by SWS, it is sometimes nil
			{
				applicationName = [applicationName lastPathComponent];
				applicationName = [applicationName lowercaseString];
				[forbiddenApplications addObject:applicationName];
			}
			NSBundle * B = [NSBundle mainBundle];
			applicationName = [B bundlePath];
			applicationName = [applicationName lastPathComponent];
			applicationName = [applicationName lowercaseString];
			[forbiddenApplications addObject:applicationName];
			unsigned int count = [allCandidates count];
			allApplications = [NSMutableArray arrayWithCapacity:count];
			NSMutableArray * localApplications = [NSMutableArray arrayWithCapacity:count];
			NSMutableArray * networkApplications = [NSMutableArray arrayWithCapacity:count];
			NSMutableArray * userApplications = [NSMutableArray arrayWithCapacity:count];
			NSMutableArray * otherApplications = [NSMutableArray arrayWithCapacity:count];
			NSMutableArray * volumeApplications = [NSMutableArray arrayWithCapacity:count];
			NSMutableArray * localApplicationsApple = [NSMutableArray arrayWithCapacity:count];
			NSMutableArray * networkApplicationsApple = [NSMutableArray arrayWithCapacity:count];
			NSMutableArray * userApplicationsApple = [NSMutableArray arrayWithCapacity:count];
			NSMutableArray * otherApplicationsApple = [NSMutableArray arrayWithCapacity:count];
			NSMutableArray * volumeApplicationsApple = [NSMutableArray arrayWithCapacity:count];
			NSEnumerator * E = [allCandidates objectEnumerator];
			while(url = [E nextObject])
			{
				if([url isFileURL])
				{
					applicationName = [url path];
					applicationName = [applicationName lowercaseString];
					if([forbiddenApplications containsObject:[applicationName lastPathComponent]])
					{
					}
					else
					{
						NSMutableArray * applications;
						B = [NSBundle bundleWithPath:applicationName];
						NSString * identifier = [B bundleIdentifier];
						if([applicationName hasPrefix:@"/network"])
						{
							applications = [identifier hasPrefix:@"com.apple."]?networkApplicationsApple:networkApplications;
						}
						else if([applicationName hasPrefix:@"/applications"])
						{
							applications = [identifier hasPrefix:@"com.apple."]?localApplicationsApple:localApplications;
						}
						else if([applicationName hasPrefix:@"/volumes"])
						{
							applications = [identifier hasPrefix:@"com.apple."]?volumeApplicationsApple:volumeApplications;
						}
						else if([applicationName hasPrefix:userApplicationsPrefix])
						{
							applications = [identifier hasPrefix:@"com.apple."]?userApplicationsApple:userApplications;
						}
						else
						{
							applications = [identifier hasPrefix:@"com.apple."]?otherApplicationsApple:otherApplications;
						}
						[applications addObject:applicationName];
					}
				}
			}
			[allApplications addObjectsFromArray:localApplicationsApple];
			[allApplications addObjectsFromArray:networkApplicationsApple];
			[allApplications addObjectsFromArray:userApplicationsApple];
			[allApplications addObjectsFromArray:otherApplicationsApple];
			[allApplications addObjectsFromArray:volumeApplicationsApple];
			[allApplications addObjectsFromArray:localApplications];
			[allApplications addObjectsFromArray:networkApplications];
			[allApplications addObjectsFromArray:userApplications];
			[allApplications addObjectsFromArray:otherApplications];
			[allApplications addObjectsFromArray:volumeApplications];
//iTM2_LOG(@"allApplications are:%@",allApplications);
		}
		if([allApplications count])
		{
			applicationName = [allApplications objectAtIndex:0];
			[allApplications removeObjectAtIndex:0];
			goto nextApplication;
		}
		[localizedDocumentTypesDictionary setObject:documentType forKey:documentType];
		return documentType;
	}
	iTM2_OUTERROR(1,(@"Only file url's are supported."),nil);
	return nil;
}
@end

@implementation NSDocument(iTM2DocumentControllerKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  newRecentDocument
- (id)newRecentDocument;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  displayLine:column:length:withHint:orderFront:
- (BOOL)displayLine:(unsigned int)line column:(unsigned int)column length:(unsigned int)length withHint:(NSDictionary *)hint orderFront:(BOOL)yorn;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  displayPageForLine:column:source:withHint:orderFront:force:
- (BOOL)displayPageForLine:(unsigned int)line column:(unsigned int)column source:(NSString *)source withHint:(NSDictionary *)hint orderFront:(BOOL)yorn force:(BOOL)force;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2_swizzle_readableTypes
+ (NSArray *)iTM2_swizzle_readableTypes;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return [[SDC documentClassNameForTypeDictionary] allKeysForObject:NSStringFromClass(self)];
}
@end

@interface NSMenu(iTM2OpenQuicklyMenu)
- (unsigned int)_completeWithCurrentDirectoryContentsForDepth:(unsigned int)depth limit:(unsigned int)limit;
@end

NSString * const iTM2OpenQuicklyCountKey = @"iTM2:OpenQuicklyCount";
NSString * const iTM2OpenQuicklyDepthKey = @"iTM2:OpenQuicklyDepth";
NSString * const iTM2OpenQuicklyLimitKey = @"iTM2:OpenQuicklyLimit";
NSString * const iTM2OpenQuicklyCachedKey = @"iTM2:OpenQuicklyCached";

#import <iTM2Foundation/iTM2MenuKit.h>
//#import "../99 - JAGUAR/iTM2JAGUARSupportKit.h"

@interface NSMenu(DocumentController)
- (unsigned int)_completeWithDirectoryContentsAtPath:(NSString *)cdp forDepth:(unsigned int)depth limit:(unsigned int)limit;
@end

@implementation iTM2MainInstaller(OpenQuicklyMenu)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2OpenQuicklyMenuCompleteInstallation
+ (void)iTM2OpenQuicklyMenuCompleteInstallation;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 11/21/2003
To Do List: retain?
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[iTM2OpenQuicklyMenu class];
//iTM2_END;
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
{iTM2_DIAGNOSTIC;
	iTM2_INIT_POOL;
//iTM2_START;
	[super initialize];
	_iTM2OpenQuicklyTextMenuItem = [[[NSApp mainMenu] deepItemWithAction:@selector(openDocumentQuicklyText:)] retain];
	_iTM2OpenQuicklyGfxMenuItem = [[[NSApp mainMenu] deepItemWithAction:@selector(openDocumentQuicklyGfx:)] retain];
	_iTM2OpenQuicklyOtherMenuItem = [[[NSApp mainMenu] deepItemWithAction:@selector(openDocumentQuicklyOther:)] retain];
	NSMenu * m = [[[_iTM2OpenQuicklyTextMenuItem menu] retain] autorelease];
	[[m supermenu] setSubmenu:[[[iTM2OpenQuicklyMenu allocWithZone:[NSMenu menuZone]] initWithTitle:@""] autorelease] forItem:[[m supermenu] itemAtIndex:[[m supermenu] indexOfItemWithSubmenu:m]]];
	[[_iTM2OpenQuicklyTextMenuItem menu] removeItem:_iTM2OpenQuicklyTextMenuItem];
	[[_iTM2OpenQuicklyGfxMenuItem menu] removeItem:_iTM2OpenQuicklyGfxMenuItem];
	[[_iTM2OpenQuicklyOtherMenuItem menu] removeItem:_iTM2OpenQuicklyOtherMenuItem];
    [SUD registerDefaults:
        [NSDictionary dictionaryWithObjectsAndKeys:
            [NSNumber numberWithInt:20], iTM2OpenQuicklyCountKey,
            [NSNumber numberWithInt:5], iTM2OpenQuicklyDepthKey,
            [NSNumber numberWithInt:100], iTM2OpenQuicklyLimitKey,
            [NSNumber numberWithBool:YES], iTM2OpenQuicklyCachedKey,
                nil]];
	if(!_iTM2OpenQuicklyTextMenuItem)
	{
		iTM2_LOG(@"WARNING: Missing locale for an open quickly text menu item");
		_iTM2OpenQuicklyTextMenuItem = [[[NSMenuItem allocWithZone:[NSMenu menuZone]]
			initWithTitle: @"Text Documents" action: NULL keyEquivalent: @""] retain];
	}
	if(!_iTM2OpenQuicklyGfxMenuItem)
	{
		iTM2_LOG(@"WARNING: Missing locale for an open quickly text menu item");
		_iTM2OpenQuicklyGfxMenuItem = [[[NSMenuItem allocWithZone:[NSMenu menuZone]]
			initWithTitle: @"Graphics Documents" action: NULL keyEquivalent: @""] retain];
	}
	if(!_iTM2OpenQuicklyOtherMenuItem)
	{
		iTM2_LOG(@"WARNING: Missing locale for an open quickly text menu item");
		_iTM2OpenQuicklyOtherMenuItem = [[[NSMenuItem allocWithZone:[NSMenu menuZone]]
			initWithTitle: @"Other Documents" action: NULL keyEquivalent: @""] retain];
	}
//iTM2_END;
	iTM2_RELEASE_POOL;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  update
- (void)update;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 11/21/2003
To Do List: retain?
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    int old = [self numberOfItems];
    NSString * cdp = [DFM currentDirectoryPath];
    NSString *
	//aFullPath = [[[SDC currentDocument] fileName] stringByDeletingLastPathComponent];
	aFullPath = [[SUD stringForKey:iTM2NavLastRootDirectory] stringByStandardizingPath];
//iTM2_LOG(@"aFullPath is: %@", aFullPath);
//iTM2_LOG(@"[self title] is:%@", [self title]);
    if([[self title] pathIsEqual:aFullPath])
        return;
    if([cdp pathIsEqual:aFullPath] || [DFM changeCurrentDirectoryPath:aFullPath])
    {
        [self setTitle:aFullPath];
        [self _completeWithDirectoryContentsAtPath:aFullPath forDepth:[SUD integerForKey:iTM2OpenQuicklyDepthKey]
                limit: [SUD integerForKey:iTM2OpenQuicklyLimitKey]];
        [DFM changeCurrentDirectoryPath:cdp];
    }
    while(old--)
        [self removeItemAtIndex:0];
	// title menu item
	[self insertItem:[NSMenuItem separatorItem] atIndex:0];
	[self insertItemWithTitle:[@"..." stringByAppendingPathComponent:[aFullPath lastPathComponent]]
		action: NULL keyEquivalent: @"" atIndex: 0];
	[self cleanSeparators];
    [super update];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= _action:
+ (void)_action:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 11/21/2003
To Do List: retain?
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(![SDC openDocumentWithContentsOfURL:[NSURL fileURLWithPath:[sender representedString]] display:YES error:nil])
        [[NSWorkspace sharedWorkspace] openFile:[sender representedString]];
    return;
}
@end

@implementation NSMenu(DocumentController)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= _completeWithDirectoryContentsAtPath:forDepth:limit:
- (unsigned int)_completeWithDirectoryContentsAtPath:(NSString *)cdp forDepth:(unsigned int)depth limit:(unsigned int)limit;
/*"Description Forthcoming. ".hidden" files compatible.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 03/10/2002
To Do List: retain?
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(depth == 0) return 0;
    if(limit == 0) return 0;
    NSFileManager * dfm = DFM;
    NSMutableArray * hiddenFiles = [NSMutableArray array];
    NSEnumerator * E = [[[NSString stringWithContentsOfFile:@".hidden"] componentsSeparatedByString:@"\n"] objectEnumerator];
    NSString * O;
    while(O = [E nextObject])
        [hiddenFiles addObjectsFromArray:[O componentsSeparatedByString:@"\r"]];
    E = [[dfm directoryContentsAtPath:cdp] objectEnumerator];
    NSMutableArray * textFiles = [NSMutableArray array];
    NSMutableArray * gfxFiles = [NSMutableArray array];
    NSMutableArray * otherFiles = [NSMutableArray array];
    NSMutableArray * directories = [NSMutableArray array];
    oneMoreTime:
    if(O = [E nextObject])
    {
        if([O hasPrefix:@"."])
            goto oneMoreTime;
        if([hiddenFiles containsObject:O])
            goto oneMoreTime;
        if([[O stringByDeletingPathExtension] hasSuffix:@"~"])
            goto oneMoreTime;

        NSString * extension = [[O pathExtension] lowercaseString];
        if([extension isEqualToString:@"tex"] || [extension isEqualToString:@"texp"] || [extension isEqualToString:@"texd"])
        {
            [textFiles addObject:O];
        }
        else if([extension isEqualToString:@"pdf"] || [extension isEqualToString:@"dvi"])
        {
            [gfxFiles addObject:O];
        }
        else if([O isEqualToString:@"CVS"])
			goto oneMoreTime;
        else if([O length])
        {
            NSString * P = [cdp stringByAppendingPathComponent:O];
			BOOL isDirectory;
			if([SWS isFilePackageAtPath:P])
			{
				[otherFiles addObject:O];
			}
            else if([dfm fileExistsAtPath:P isDirectory:&isDirectory] && isDirectory)
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
	unsigned int level = 1;
	if([textFiles count])
	{
		NSMenuItem * MI = [[_iTM2OpenQuicklyTextMenuItem copy] autorelease];
		[self addItem:MI];
		E = [textFiles objectEnumerator];
		if([textFiles count] > [SUD integerForKey:iTM2OpenQuicklyCountKey])
		{
			// too many items, use a submenu
			NSMenu * M = [[[NSMenu allocWithZone:[NSMenu menuZone]] initWithTitle:[MI title]] autorelease];
			[self setSubmenu:M forItem:MI];
			while(O = [E nextObject])
			{
				NSMenuItem * MI = [M addItemWithTitle:O action:@selector(_action:) keyEquivalent:@""];
				[MI setTarget:[iTM2OpenQuicklyMenu class]];
				[MI setRepresentedObject:[cdp stringByAppendingPathComponent:O]];
			}
		}
		else
		{
			while(O = [E nextObject])
			{
				NSMenuItem * MI = [self addItemWithTitle:O action:@selector(_action:) keyEquivalent:@""];
				[MI setIndentationLevel:level];
				[MI setTarget:[iTM2OpenQuicklyMenu class]];
				[MI setRepresentedObject:[cdp stringByAppendingPathComponent:O]];
			}
			if(limit < [textFiles count])
				return 0;
			else
				limit -= [textFiles count];
		}
	}
	if([gfxFiles count])
	{
		NSMenuItem * MI = [[_iTM2OpenQuicklyGfxMenuItem copy] autorelease];
		[self addItem:MI];
		E = [gfxFiles objectEnumerator];
		if([textFiles count] + [gfxFiles count] > [SUD integerForKey:iTM2OpenQuicklyCountKey])
		{
			// too many items, use a submenu
			NSMenu * M = [[[NSMenu allocWithZone:[NSMenu menuZone]] initWithTitle:[MI title]] autorelease];
			[self setSubmenu:M forItem:MI];
			while(O = [E nextObject])
			{
				NSMenuItem * MI = [M addItemWithTitle:O action:@selector(_action:) keyEquivalent:@""];
				[MI setTarget:[iTM2OpenQuicklyMenu class]];
				[MI setRepresentedObject:[cdp stringByAppendingPathComponent:O]];
			}
		}
		else
		{
			while(O = [E nextObject])
			{
				NSMenuItem * MI = [self addItemWithTitle:O action:@selector(_action:) keyEquivalent:@""];
				[MI setIndentationLevel:level];
				[MI setTarget:[iTM2OpenQuicklyMenu class]];
				[MI setRepresentedObject:[cdp stringByAppendingPathComponent:O]];
			}
			if(limit < [gfxFiles count])
				return 0;
			else
				limit -= [gfxFiles count];
		}
	}
	if([otherFiles count])
	{
		E = [otherFiles objectEnumerator];
		if([textFiles count] + [gfxFiles count] > 0)
		{
			NSMenuItem * MI = [[_iTM2OpenQuicklyOtherMenuItem copy] autorelease];
			[self addItem:MI];
			// use a submenu
			NSMenu * M = [[[NSMenu allocWithZone:[NSMenu menuZone]] initWithTitle:[MI title]] autorelease];
			[self setSubmenu:M forItem:MI];
			while(O = [E nextObject])
			{
				NSMenuItem * MI = [M addItemWithTitle:O action:@selector(_action:) keyEquivalent:@""];
				[MI setTarget:[iTM2OpenQuicklyMenu class]];
				[MI setRepresentedObject:[cdp stringByAppendingPathComponent:O]];
			}
		}
		else
		{
			while(O = [E nextObject])
			{
				NSMenuItem * MI = [self addItemWithTitle:O action:@selector(_action:) keyEquivalent:@""];
				[MI setIndentationLevel:level];
				[MI setTarget:[iTM2OpenQuicklyMenu class]];
				[MI setRepresentedObject:[cdp stringByAppendingPathComponent:O]];
			}
		}
	}
    E = [directories objectEnumerator];
    while(O = [E nextObject])
    {
		NSMenuItem * MI = [self addItemWithTitle:O action:NULL keyEquivalent:@""];
		NSMenu * M = [[[NSMenu allocWithZone:[NSMenu menuZone]] initWithTitle:@""] autorelease];
		[self setSubmenu:M forItem:MI];
        NSString * P = [cdp stringByAppendingPathComponent:O];
		if(limit > 0)
		{
			limit = [M _completeWithDirectoryContentsAtPath:P forDepth:depth-1 limit:limit];
			if(![M numberOfItems])
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
- (BOOL)displayPageForLine:(unsigned int)line column:(unsigned int)column source:(NSString *)source withHint:(NSDictionary *)hint orderFront:(BOOL)yorn;
{iTM2_DIAGNOSTIC;
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  newRecentDocument
- (id)newRecentDocument;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return nil;
}
@end
