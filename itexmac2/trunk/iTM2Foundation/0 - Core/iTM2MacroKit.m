/*
//
//  @version Subversion: $Id$ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Thu Feb 21 2002.
//  Copyright © 2006 Laurens'Tribune. All rights reserved.
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

#import <iTM2Foundation/iTM2MacroKit.h>

#import <iTM2Foundation/iTM2BundleKit.h>
#import <iTM2Foundation/iTM2TaskKit.h>
#import <iTM2Foundation/iTM2FileManagerKit.h>
#import <iTM2Foundation/iTM2MenuKit.h>

NSString * const iTM2MacroServerDirectoryName = @"Macros.localized";
NSString * const iTM2MacroServerSummaryComponent = @"Summary";

static NSMutableDictionary * _iTM2_MacroServer_Data;

@interface iTM2MacroServer(PRIVATE)
+ (NSMenuItem *)_macrosMenuItemFromEnumerator:(NSEnumerator *)enumerator error:(NSError **)error;
+ (NSMenu *)_macrosMenuFromEnumerator:(NSEnumerator *)enumerator error:(NSError **)error;
+ (NSMenuItem *)_macrosMenuItemWithXMLElement:(NSXMLElement *)element error:(NSError **)error;
@end

@implementation iTM2MacroServer
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  threadedUpdateUserMacrosHashTable:
+ (void)threadedUpdateUserMacrosHashTable:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 06/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
	iTM2_INIT_POOL;
//iTM2_START;
	[NSThread setThreadPriority:0.2];// why 0.2? why not...
	NSString * path = [[self classBundle] pathForAuxiliaryExecutable:@"bin/iTM2CreateMacrosHashTable.pl"];
    if([path length])
	{
		iTM2TaskWrapper * TW = [[[iTM2TaskWrapper alloc] init] autorelease];
		[TW setLaunchPath:path];
		[TW addArgument:@"--directory"];
		NSString * P = [[NSBundle mainBundle] pathForSupportDirectory:iTM2MacroServerDirectoryName inDomain:NSUserDomainMask create:NO];
		[TW addArgument:P];
		[TW addArgument:@"--callback"];
		iTM2TaskController * TC = [[[iTM2TaskController allocWithZone:[self zone]] init] autorelease];
		[TC addTaskWrapper:TW];
		[TC setMute:NO];
		[TC start];
		[TC waitUntilExit];
	}
//iTM2_END;
	iTM2_RELEASE_POOL;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setSource:forKey:relativeTo:
+ (void)setSource:(NSString *)path forKey:(NSString *)key relativeTo:(NSString *)fullPath;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 06/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  macrosMenuAtPath:error:
+ (NSMenu *)macrosMenuAtPath:(NSString *)file error:(NSError **)outError;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 06/02/2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
	iTM2_INIT_POOL;
//iTM2_START;
    NSURL *furl = [NSURL fileURLWithPath:file];
    if (!furl) {
        NSLog(@"Can't create an URL from file %@.", file);
        return nil;
    }
	NSXMLDocument *xmlDoc = [[[NSXMLDocument alloc] initWithContentsOfURL:furl
            options:NSXMLNodePreserveCDATA
            error:outError] autorelease];
    if (!xmlDoc)  {
		if(outError && !(*outError))
			*outError = [NSError errorWithDomain:@"iTeXMac2.script.macrosMenuAtPath:error:" code:1 userInfo:
				[NSDictionary dictionaryWithObjectsAndKeys:
					@"File not conforming to its definition", NSLocalizedDescriptionKey,// NSString
					@"File is missing a DOMAIN title", NSLocalizedFailureReasonErrorKey,// NSString
					// [NSString stringWithFormat:@"Reinstall or edit file:%@", path], NSLocalizedRecoverySuggestionErrorKey,// NSString
					// [NSArray arrayWithObjects:nil], NSLocalizedRecoveryOptionsErrorKey,// NSArray of NSStrings
					// [NSNull null], NSRecoveryAttempterErrorKey,// Instance of a subclass of NSObject that conforms to the NSErrorRecoveryAttempting informal protocol
						nil]];
		return nil;
	}
	NSMenu * M = [[[self _macrosMenuItemWithXMLElement:[xmlDoc rootElement] error:outError] submenu] retain];
//iTM2_END;
	iTM2_RELEASE_POOL;
	return [M autorelease];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  _macrosMenuItemWithXMLElement:error:
+ (NSMenuItem *)_macrosMenuItemWithXMLElement:(NSXMLElement *)element error:(NSError **)outError;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 06/02/2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([[element name] isEqual:@"M"])
	{
		NSEnumerator * E = [[element children] objectEnumerator];
		NSMenu * M = [[[NSMenu allocWithZone:[NSMenu menuZone]] initWithTitle:@""] autorelease];
		id child;
		NSString * title = @"";
		NSString * domain = @"";
		NSString * category = @"";
		NSString * key = @"";
		if(child = [E nextObject])
		{
			NSString * name = [child name];
			if([name isEqual:@"T"])
			{
				title = [child stringValue];
			}
			else
			{
				if([name isEqual:@"D"])
				{
					domain = [child stringValue];
					child = [E nextObject];
					name = [child name];
				}
				if([name isEqual:@"C"])
				{
					category = [child stringValue];
					child = [E nextObject];
					name = [child name];
				}
				if([name isEqual:@"K"])
				{
					key = [child stringValue];// we must have a key,
				}
				else
				{
					if(outError)
						*outError = [NSError errorWithDomain:@"iTeXMac2.script._macrosMenuItemWithXMLElement:error:" code:1 userInfo:
							[NSDictionary dictionaryWithObjectsAndKeys:
								@"File not conforming to its DTD", NSLocalizedDescriptionKey,// NSString
								@"File is missing a K", NSLocalizedFailureReasonErrorKey,// NSString
								// [NSString stringWithFormat:@"Reinstall or edit file:%@", path], NSLocalizedRecoverySuggestionErrorKey,// NSString
								// [NSArray arrayWithObjects:nil], NSLocalizedRecoveryOptionsErrorKey,// NSArray of NSStrings
								// [NSNull null], NSRecoveryAttempterErrorKey,// Instance of a subclass of NSObject that conforms to the NSErrorRecoveryAttempting informal protocol
									nil]];
					return nil;
				}
			}
			while(child = [E nextObject])
			{
				NSMenuItem * mi = [self _macrosMenuItemWithXMLElement:child error:outError];
				if(mi)
				{
					[M addItem:mi];
				}
			}
		}
		NSMenuItem * MI = [[[NSMenuItem allocWithZone:[NSMenu menuZone]] initWithTitle:title action:NULL keyEquivalent:@""] autorelease];
		[MI setTarget:self];
		[MI setSubmenu:M];
		[MI setRepresentedObject:[NSArray arrayWithObjects:domain, category, key, nil]];
		[MI setSubmenu:M];
		return MI;
	}
	else if([[element name] isEqual:@"I"])
	{
		NSEnumerator * E = [[element children] objectEnumerator];
		id child;
		NSString * domain = @"";
		NSString * category = @"";
		NSString * key = @"";
		if(child = [E nextObject])
		{
			NSString * name = [child name];
			if([name isEqual:@"D"])
			{
				domain = [child stringValue];
				child = [E nextObject];
				name = [child name];
			}
			if([name isEqual:@"C"])
			{
				category = [child stringValue];
				child = [E nextObject];
				name = [child name];
			}
			if([name isEqual:@"K"])
			{
				key = [child stringValue];
			}
		}
		NSMenuItem * MI = [[[NSMenuItem allocWithZone:[NSMenu menuZone]] initWithTitle:
			[NSString stringWithFormat:@"domain:%@, category:%@, key:%@", domain, category, key] action:@selector(macroAction:) keyEquivalent:@""] autorelease];
		[MI setTarget:self];
		[MI setRepresentedObject:[NSArray arrayWithObjects:domain, category, key, nil]];
		return MI;
	}
	else if([[element name] isEqual:@"S"])
		return [NSMenuItem separatorItem];
//iTM2_END;
	return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  macrosMenuAtPath:error:
+ (NSMenu *)___macrosMenuAtPath:(NSString *)path error:(NSError **)outError;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 06/02/2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
	iTM2_INIT_POOL;
//iTM2_START;
	// open the file as a string file
	unsigned int encoding;
	NSString * S = [NSString stringWithContentsOfFile:path usedEncoding:&encoding error:outError];
	if(![S length] || (outError && !(*outError)))
		return nil;
	unsigned end, contentsEnd;
	[S getLineStart:nil end:&end contentsEnd:&contentsEnd forRange:NSMakeRange(0, 0)];
	NSString * recordSeparator = [S substringWithRange:NSMakeRange(0, (contentsEnd? :end))];
	NSEnumerator * E = [[S componentsSeparatedByString:recordSeparator] objectEnumerator];
	NSMenu * M = [[self _macrosMenuFromEnumerator:E error:outError] retain];
//iTM2_END;
	iTM2_RELEASE_POOL;
	return [M autorelease];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  _macrosMenuItemFromEnumerator:error:
+ (NSMenuItem *)_macrosMenuItemFromEnumerator:(NSEnumerator *)enumerator error:(NSError **)outError;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 06/02/2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * title;
	if(title = [enumerator nextObject])
	{
		NSString * record;
		if(record = [enumerator nextObject])
		{
			if([record isEqualToString:@"SUBMENU"])
			{
				NSMenu * M = [self _macrosMenuFromEnumerator:enumerator error:outError];
				if(M)
				{
					NSMenuItem * MI = [[[NSMenuItem allocWithZone:[NSMenu menuZone]] initWithTitle:title action:NULL keyEquivalent:@""] autorelease];
					[MI setSubmenu:M];
					return MI;
				}
			}
			else
			{
				NSString * domain = @"";
				NSString * category = @"";
				NSString * key;
				if([record isEqualToString:@"DOMAIN"])
				{
					domain = [enumerator nextObject];
					if(!domain)
					{
						if(outError)
							*outError = [NSError errorWithDomain:@"iTeXMac2.script._macrosMenuItemFromEnumerator:error:" code:1 userInfo:
								[NSDictionary dictionaryWithObjectsAndKeys:
									@"File not conforming to its definition", NSLocalizedDescriptionKey,// NSString
									@"File is missing a DOMAIN title", NSLocalizedFailureReasonErrorKey,// NSString
									// [NSString stringWithFormat:@"Reinstall or edit file:%@", path], NSLocalizedRecoverySuggestionErrorKey,// NSString
									// [NSArray arrayWithObjects:nil], NSLocalizedRecoveryOptionsErrorKey,// NSArray of NSStrings
									// [NSNull null], NSRecoveryAttempterErrorKey,// Instance of a subclass of NSObject that conforms to the NSErrorRecoveryAttempting informal protocol
										nil]];
						return nil;
					}
					record = [enumerator nextObject];
				}
				if([record isEqualToString:@"CATEGORY"])
				{
					category = [enumerator nextObject];
					if(!category)
					{
						if(outError)
							*outError = [NSError errorWithDomain:@"iTeXMac2.script._macrosMenuItemFromEnumerator:error:" code:1 userInfo:
								[NSDictionary dictionaryWithObjectsAndKeys:
									@"File not conforming to its definition", NSLocalizedDescriptionKey,// NSString
									@"File is missing a CATEGORY title", NSLocalizedFailureReasonErrorKey,// NSString
									// [NSString stringWithFormat:@"Reinstall or edit file:%@", path], NSLocalizedRecoverySuggestionErrorKey,// NSString
									// [NSArray arrayWithObjects:nil], NSLocalizedRecoveryOptionsErrorKey,// NSArray of NSStrings
									// [NSNull null], NSRecoveryAttempterErrorKey,// Instance of a subclass of NSObject that conforms to the NSErrorRecoveryAttempting informal protocol
										nil]];
						return nil;
					}
					record = [enumerator nextObject];
				}
				if([record isEqualToString:@"KEY"])
				{
					if(key = [enumerator nextObject])
					{
						//error
						NSMenuItem * MI = [[[NSMenuItem allocWithZone:[NSMenu menuZone]] initWithTitle:title action:@selector(macroAction:) keyEquivalent:@""] autorelease];
						[MI setRepresentedObject:[NSArray arrayWithObjects:domain, category, key, nil]];
						return MI;
					}
					if(outError)
						*outError = [NSError errorWithDomain:@"iTeXMac2.script._macrosMenuItemFromEnumerator:error:" code:2 userInfo:
							[NSDictionary dictionaryWithObjectsAndKeys:
								@"File not conforming to its definition", NSLocalizedDescriptionKey,// NSString
								@"File is missing a KEY title", NSLocalizedFailureReasonErrorKey,// NSString
								// [NSString stringWithFormat:@"Reinstall or edit file:%@", path], NSLocalizedRecoverySuggestionErrorKey,// NSString
								// [NSArray arrayWithObjects:nil], NSLocalizedRecoveryOptionsErrorKey,// NSArray of NSStrings
								// [NSNull null], NSRecoveryAttempterErrorKey,// Instance of a subclass of NSObject that conforms to the NSErrorRecoveryAttempting informal protocol
									nil]];
					return nil;
				}
				if(outError)
					*outError = [NSError errorWithDomain:@"iTeXMac2.script._macrosMenuItemFromEnumerator:error:" code:3 userInfo:
						[NSDictionary dictionaryWithObjectsAndKeys:
							@"File not conforming to its definition", NSLocalizedDescriptionKey,// NSString
							@"File is missing a KEY record", NSLocalizedFailureReasonErrorKey,// NSString
							// [NSString stringWithFormat:@"Reinstall or edit file:%@", path], NSLocalizedRecoverySuggestionErrorKey,// NSString
							// [NSArray arrayWithObjects:nil], NSLocalizedRecoveryOptionsErrorKey,// NSArray of NSStrings
							// [NSNull null], NSRecoveryAttempterErrorKey,// Instance of a subclass of NSObject that conforms to the NSErrorRecoveryAttempting informal protocol
								nil]];
				return nil;
			}
		}
		else
		{
			if(outError)
				*outError = [NSError errorWithDomain:@"iTeXMac2.script._macrosMenuItemFromEnumerator:error:" code:4 userInfo:
					[NSDictionary dictionaryWithObjectsAndKeys:
						@"File not conforming to its definition", NSLocalizedDescriptionKey,// NSString
						@"File is missing an ITEM content", NSLocalizedFailureReasonErrorKey,// NSString
						// [NSString stringWithFormat:@"Reinstall or edit file:%@", path], NSLocalizedRecoverySuggestionErrorKey,// NSString
						// [NSArray arrayWithObjects:nil], NSLocalizedRecoveryOptionsErrorKey,// NSArray of NSStrings
						// [NSNull null], NSRecoveryAttempterErrorKey,// Instance of a subclass of NSObject that conforms to the NSErrorRecoveryAttempting informal protocol
							nil]];
			return nil;
		}
	}
	else
	{
		if(outError)
			*outError = [NSError errorWithDomain:@"iTeXMac2.script._macrosMenuItemFromEnumerator:error:" code:5 userInfo:
				[NSDictionary dictionaryWithObjectsAndKeys:
					@"File not conforming to its definition", NSLocalizedDescriptionKey,// NSString
					@"File is missing an ITEM title", NSLocalizedFailureReasonErrorKey,// NSString
					// [NSString stringWithFormat:@"Reinstall or edit file:%@", path], NSLocalizedRecoverySuggestionErrorKey,// NSString
					// [NSArray arrayWithObjects:nil], NSLocalizedRecoveryOptionsErrorKey,// NSArray of NSStrings
					// [NSNull null], NSRecoveryAttempterErrorKey,// Instance of a subclass of NSObject that conforms to the NSErrorRecoveryAttempting informal protocol
						nil]];
		return nil;
	}
//iTM2_END;
	return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  _macrosMenuFromEnumerator:error:
+ (NSMenu *)_macrosMenuFromEnumerator:(NSEnumerator *)enumerator error:(NSError **)outError;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 06/02/2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSMenu * M = [[[NSMenu allocWithZone:[NSMenu menuZone]] initWithTitle:@""] autorelease];
	NSString * S = nil;
	if(S = [enumerator nextObject])
	{
		if([S isEqualToString:@"ITEM"])
		{
			NSMenuItem * MI = [self _macrosMenuItemFromEnumerator:enumerator error:outError];
			if(MI)
			{
				[M addItem:MI];
nextITEM:
				if(S = [enumerator nextObject])
				{
					if([S isEqualToString:@"ITEM"])
					{
						if(MI = [self _macrosMenuItemFromEnumerator:enumerator error:outError])
						{
							[M addItem:MI];
						}
						else
						{
							return M;
						}
					}
					else if([S isEqualToString:@"SEPARATOR"])
					{
						[M addItem:[NSMenuItem separatorItem]];
					}
					else if([S isEqualToString:@"UNEMBUS"])
					{
						return M;
					}
					else
					{
						if(outError)
							*outError = [NSError errorWithDomain:@"iTeXMac2.script._macrosMenuFromEnumerator:error:" code:2 userInfo:
								[NSDictionary dictionaryWithObjectsAndKeys:
									@"File not conforming to its definition", NSLocalizedDescriptionKey,// NSString
									@"File is missing an ITEM title", NSLocalizedFailureReasonErrorKey,// NSString
									// [NSString stringWithFormat:@"Reinstall or edit file:%@", path], NSLocalizedRecoverySuggestionErrorKey,// NSString
									// [NSArray arrayWithObjects:nil], NSLocalizedRecoveryOptionsErrorKey,// NSArray of NSStrings
									// [NSNull null], NSRecoveryAttempterErrorKey,// Instance of a subclass of NSObject that conforms to the NSErrorRecoveryAttempting informal protocol
										nil]];
						return nil;
					}
					goto nextITEM;
				}
				else
				{
					if(outError)
						*outError = [NSError errorWithDomain:@"iTeXMac2.script._macrosMenuFromEnumerator:error:" code:3 userInfo:
							[NSDictionary dictionaryWithObjectsAndKeys:
								@"File not conforming to its definition", NSLocalizedDescriptionKey,// NSString
								@"File is missing an ITEM title", NSLocalizedFailureReasonErrorKey,// NSString
								// [NSString stringWithFormat:@"Reinstall or edit file:%@", path], NSLocalizedRecoverySuggestionErrorKey,// NSString
								// [NSArray arrayWithObjects:nil], NSLocalizedRecoveryOptionsErrorKey,// NSArray of NSStrings
								// [NSNull null], NSRecoveryAttempterErrorKey,// Instance of a subclass of NSObject that conforms to the NSErrorRecoveryAttempting informal protocol
									nil]];
					return nil;
				}
			}
			else
			{
				return M;
			}
		}
		else
		{
			if(outError)
				*outError = [NSError errorWithDomain:@"iTeXMac2.script._macrosMenuFromEnumerator:error:" code:2 userInfo:
					[NSDictionary dictionaryWithObjectsAndKeys:
						@"File not conforming to its definition", NSLocalizedDescriptionKey,// NSString
						@"File is missing an ITEM title", NSLocalizedFailureReasonErrorKey,// NSString
						// [NSString stringWithFormat:@"Reinstall or edit file:%@", path], NSLocalizedRecoverySuggestionErrorKey,// NSString
						// [NSArray arrayWithObjects:nil], NSLocalizedRecoveryOptionsErrorKey,// NSArray of NSStrings
						// [NSNull null], NSRecoveryAttempterErrorKey,// Instance of a subclass of NSObject that conforms to the NSErrorRecoveryAttempting informal protocol
							nil]];
			return nil;
		}
	}
	else
	{
		if(outError)
			*outError = [NSError errorWithDomain:@"iTeXMac2.script._macrosMenuFromEnumerator:error:" code:1 userInfo:
				[NSDictionary dictionaryWithObjectsAndKeys:
					@"File not conforming to its definition", NSLocalizedDescriptionKey,// NSString
					@"File is missing an ITEM title", NSLocalizedFailureReasonErrorKey,// NSString
					// [NSString stringWithFormat:@"Reinstall or edit file:%@", path], NSLocalizedRecoverySuggestionErrorKey,// NSString
					// [NSArray arrayWithObjects:nil], NSLocalizedRecoveryOptionsErrorKey,// NSArray of NSStrings
					// [NSNull null], NSRecoveryAttempterErrorKey,// Instance of a subclass of NSObject that conforms to the NSErrorRecoveryAttempting informal protocol
						nil]];
		return nil;
	}
//iTM2_END;
	return nil;
}
@end

#import <iTM2Foundation/iTM2InstallationKit.h>

@implementation iTM2MainInstaller(iTM2MacroKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2MacroKitCompleteInstallation
+ (void)iTM2MacroKitCompleteInstallation;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 06/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * path = [[self classBundle] pathForAuxiliaryExecutable:@"bin/iTM2CreateMacrosHashTable.pl"];
    if([path length])
	{
		iTM2TaskWrapper * TW = [[[iTM2TaskWrapper alloc] init] autorelease];
		[TW setLaunchPath:path];
		[TW addArgument:@"--directory"];
//		NSString * P = [[NSBundle mainBundle] pathForSupportDirectory:iTM2MacroServerDirectoryName inDomain:NSUserDomainMask create:NO];
//		[TW addArgument:P];
		[TW addArgument:@"/Users"];
		iTM2TaskController * TC = [[[iTM2TaskController allocWithZone:[self zone]] init] autorelease];
		[TC addTaskWrapper:TW];
		[TC setMute:YES];
		[TC setDeaf:YES];
		[TC start];
		[TC becomeStandalone];
	}
	else
	{
		iTM2_LOG(@"ERROR: bad configuration, bin/iTM2CreateMacrosHashTable.pl is missing");
	}
//iTM2_END;
	return;
}
@end


@interface NSObject(RIEN)
- (NSMenuItem *)macroMenuItemWithXMLElement:(id)element forContext:(NSString *)context ofCategory:(NSString *)category inDomain:(NSString *)domain error:(NSError **)outError;
- (NSMenu *)macroMenuForContext:(NSString *)context ofCategory:(NSString *)category inDomain:(NSString *)domain error:(NSError **)outError;
- (NSMenu *)macroMenuWithXMLElement:(id)element forContext:(NSString *)context ofCategory:(NSString *)category inDomain:(NSString *)domain error:(NSError **)outError;
@end

@interface iTM2MacrosServer(PRIVATE)

/*!
	@method			storageForContext:ofCategory:inDomain:
	@abstract		Storage for the various information.
	@discussion 	Do not use this method if you have a more general accessor.
	@param			context
	@param			category
	@param			domain
	@result			None.
	@availability	iTM2.
	@copyright		2005 jlaurens@users.sourceforge.net and others.
*/
- (id)storageForContext:(NSString *)context ofCategory:(NSString *)category inDomain:(NSString *)domain;

/*!
	@method			updateLocalesIndexForContext:ofCategory:inDomain:
	@abstract		Update the locales index.
	@discussion		Discussion forthcoming.
	@param			context
	@param			category
	@param			domain
	@result			a path.
	@availability	iTM2.
	@copyright		2005 jlaurens@users.sourceforge.net and others.
*/
- (void)updateLocalesIndexForContext:(NSString *)context ofCategory:(NSString *)category inDomain:(NSString *)domain;

/*!
	@method			updateActionsIndexForContext:ofCategory:inDomain:
	@abstract		Update the Actions index.
	@discussion		Discussion forthcoming.
	@param			category
	@param			domain
	@result			a path.
	@availability	iTM2.
	@copyright		2005 jlaurens@users.sourceforge.net and others.
*/
- (void)updateActionsIndexForContext:(NSString *)context ofCategory:(NSString *)category inDomain:(NSString *)domain;

/*!
	@method			indexWithContentsOfFile:error:
	@abstract		Return an index from the given location.
	@discussion		It is expected to have a standalone shalow xml file at the given location.
					The root element is a LIST of ITEM's.
					LIST and ITEM's have a key attribute.
					The return object is a dictionary which values are just ITEM's.
					The keys are the key attributes of the ITEM eventually prepended by
					the key attribute of the LIST root element as a common prefix to all the keys.
	@param			path
	@param			outError
	@result			A hash...
	@availability	iTM2.
	@copyright		2005 jlaurens@users.sourceforge.net and others.
*/
- (id)indexWithContentsOfFile:(NSString*)path error:(NSError **)outError;

/*!
	@method			macrosIndexWithContentsOfFile:error:
	@abstract		Return a macros index from the given location.
	@discussion		It is expected to have a standalone shalow xml file at the given location.
					The root element is a LIST of ITEM's.
					LIST and ITEM's have a key attribute.
					ITEM's string value is the path of the file where the macro.
					If this path starts with ".", it is prepended by the directory part of path.
					The return object is a dictionary which values are those paths.
					The keys are the key attributes of the ITEM eventually prepended by
					the key attribute of the LIST root element as a common prefix to all the keys.
	@param			path
	@param			outError
	@result			A hash...
	@availability	iTM2.
	@copyright		2005 jlaurens@users.sourceforge.net and others.
*/
- (id)macrosIndexWithContentsOfFile:(NSString *)path error:(NSError **)outError;

- (void)loadMacrosSummaries;
- (void)loadMacrosSummaryAtPath:(NSString *)path;
- (void)loadMacrosSummariesAtPath:(NSString *)path;
- (void)loadMacrosLocaleAtURL:(NSURL *)url;
- (id)macrosServerStorage;

@end

@implementation iTM2MacrosServer
static iTM2MacrosServer * _iTM2SharedMacrosServer = nil;
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= load
+ (void)load;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
	iTM2_INIT_POOL;
//iTM2_START;
	_iTM2SharedMacrosServer = [[self alloc] init];
//iTM2_END;
	iTM2_RELEASE_POOL;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= sharedMacrosServer
+ (id)sharedMacrosServer;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return _iTM2SharedMacrosServer;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= init
- (id)init;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(_iTM2SharedMacrosServer)
	{
		[self dealloc];
		return [_iTM2SharedMacrosServer retain];
	}
//iTM2_END;
	else if(self = [super init])
	{
		[[self implementation] takeMetaValue:[NSMutableDictionary dictionary] forKey:@"MacrosServerStorage"];
	}
    return _iTM2SharedMacrosServer = self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= macrosServerStorage
- (id)macrosServerStorage;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return metaGETTER;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= storageForContext:ofCategory:inDomain:
- (id)storageForContext:(NSString *)context ofCategory:(NSString *)category inDomain:(NSString *)domain;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSMutableDictionary * MD = [[self macrosServerStorage] objectForKey:domain];
	if(!MD)
	{
		MD = [NSMutableDictionary dictionary];
		[[self macrosServerStorage] setObject:MD forKey:domain];
	}
	NSMutableDictionary * result = [MD objectForKey:category];
	if(!result)
	{
		result = [NSMutableDictionary dictionary];
		[MD setObject:result forKey:category];
	}
	MD = result;
	result = [MD objectForKey:context];
	if(!result)
	{
		result = [NSMutableDictionary dictionary];
		[MD setObject:result forKey:context];
	}
//iTM2_END;
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= macroURLForKey:context:ofCategory:inDomain:
- (NSURL *)macroURLForKey:(NSString *)key context:(NSString *)context ofCategory:(NSString *)category inDomain:(NSString *)domain;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id storage = [self storageForContext:context ofCategory:category inDomain:domain];
	id URLs = [storage objectForKey:@"./URLs"];
	id URL = [URLs objectForKey:key];
//iTM2_END;
	return URL;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= macroLocaleOfType:forKey:context:ofCategory:inDomain:
- (NSString *)macroLocaleOfType:(NSString *)type forKey:(NSString *)key context:(NSString *)context ofCategory:(NSString *)category inDomain:(NSString *)domain;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id storage = [self storageForContext:context ofCategory:category inDomain:domain];
	id locales = [storage objectForKey:@"./Locales"];
	NSDictionary * names = [locales objectForKey:type];
	NSString * name = [names objectForKey:key];
	if(name)
	{
		return name;
	}
	if([context length])
	{
		storage = [self storageForContext:@"" ofCategory:category inDomain:domain];
		locales = [storage objectForKey:@"./Locales"];
		names = [locales objectForKey:type];
		if(name = [names objectForKey:key])
		{
			return name;
		}
	}
	if([category length])
	{
		storage = [self storageForContext:@"" ofCategory:@"" inDomain:domain];
		locales = [storage objectForKey:@"./Locales"];
		names = [locales objectForKey:type];
		if(name = [names objectForKey:key])
		{
			return name;
		}
	}
	if([domain length])
	{
		storage = [self storageForContext:@"" ofCategory:@"" inDomain:@""];
		locales = [storage objectForKey:@"./Locales"];
		names = [locales objectForKey:type];
		if(name = [names objectForKey:key])
		{
			return name;
		}
	}
	NSURL * url = [self macroURLForKey:key context:context ofCategory:category inDomain:domain];
	if(url)
	{
		[self loadMacrosLocaleAtURL:url];
		storage = [self storageForContext:context ofCategory:category inDomain:domain];
		locales = [storage objectForKey:@"./Locales"];
		names = [locales objectForKey:type];
		if(name = [names objectForKey:key])
		{
			return name;
		}
	}
	if([context length])
	{
		if(url = [self macroURLForKey:key context:@"" ofCategory:category inDomain:domain])
		{
			[self loadMacrosLocaleAtURL:url];
			storage = [self storageForContext:@"" ofCategory:category inDomain:domain];
			locales = [storage objectForKey:@"./Locales"];
			names = [locales objectForKey:type];
			if(name = [names objectForKey:key])
			{
				return name;
			}
		}
	}
	if([category length])
	{
		if(url = [self macroURLForKey:key context:@"" ofCategory:@"" inDomain:domain])
		{
			[self loadMacrosLocaleAtURL:url];
			storage = [self storageForContext:@"" ofCategory:@"" inDomain:domain];
			locales = [storage objectForKey:@"./Locales"];
			names = [locales objectForKey:type];
			if(name = [names objectForKey:key])
			{
				return name;
			}
		}
	}
	if([domain length])
	{
		if(url = [self macroURLForKey:key context:@"" ofCategory:@"" inDomain:@""])
		{
			[self loadMacrosLocaleAtURL:url];
			storage = [self storageForContext:@"" ofCategory:@"" inDomain:@""];
			locales = [storage objectForKey:@"./Locales"];
			names = [locales objectForKey:type];
			if(name = [names objectForKey:key])
			{
				return name;
			}
		}
	}
//iTM2_END;
	return key;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= macroDescriptionForKey:context:ofCategory:inDomain:
- (NSString *)macroDescriptionForKey:(NSString *)key context:(NSString *)context ofCategory:(NSString *)category inDomain:(NSString *)domain;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id storage = [self storageForContext:context ofCategory:category inDomain:domain];
	id locales = [storage objectForKey:@"./Locales"];
	NSDictionary * names = [locales objectForKey:@"Description"];
	NSString * name = [names objectForKey:key];
	if(name)
	{
		return name;
	}
	if([context length])
	{
		storage = [self storageForContext:@"" ofCategory:category inDomain:domain];
		locales = [storage objectForKey:@"./Locales"];
		names = [locales objectForKey:@"Description"];
		if(name = [names objectForKey:key])
		{
			return name;
		}
	}
	if([category length])
	{
		storage = [self storageForContext:@"" ofCategory:@"" inDomain:domain];
		locales = [storage objectForKey:@"./Locales"];
		names = [locales objectForKey:@"Description"];
		if(name = [names objectForKey:key])
		{
			return name;
		}
	}
	if([domain length])
	{
		storage = [self storageForContext:@"" ofCategory:@"" inDomain:@""];
		locales = [storage objectForKey:@"./Locales"];
		names = [locales objectForKey:@"Description"];
		if(name = [names objectForKey:key])
		{
			return name;
		}
	}
	NSURL * url = [self macroURLForKey:key context:context ofCategory:category inDomain:domain];
	[self loadMacrosLocaleAtURL:url];
	locales = [storage objectForKey:@"./Locales"];
	names = [locales objectForKey:@"Description"];
	if(name = [names objectForKey:key])
	{
		return name;
	}
//iTM2_END;
	return key;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= macroTooltipForKey:context:ofCategory:inDomain:
- (NSString *)macroTooltipForKey:(NSString *)key context:(NSString *)context ofCategory:(NSString *)category inDomain:(NSString *)domain;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id storage = [self storageForContext:context ofCategory:category inDomain:domain];
	id locales = [storage objectForKey:@"./Locales"];
	NSDictionary * names = [locales objectForKey:@"Tooltip"];
	NSString * name = [names objectForKey:key];
	if(name)
	{
		return name;
	}
	if([context length])
	{
		storage = [self storageForContext:@"" ofCategory:category inDomain:domain];
		locales = [storage objectForKey:@"./Locales"];
		names = [locales objectForKey:@"Tooltip"];
		if(name = [names objectForKey:key])
		{
			return name;
		}
	}
	if([category length])
	{
		storage = [self storageForContext:@"" ofCategory:@"" inDomain:domain];
		locales = [storage objectForKey:@"./Locales"];
		names = [locales objectForKey:@"Tooltip"];
		if(name = [names objectForKey:key])
		{
			return name;
		}
	}
	if([domain length])
	{
		storage = [self storageForContext:@"" ofCategory:@"" inDomain:@""];
		locales = [storage objectForKey:@"./Locales"];
		names = [locales objectForKey:@"Tooltip"];
		if(name = [names objectForKey:key])
		{
			return name;
		}
	}
	NSURL * url = [self macroURLForKey:key context:context ofCategory:category inDomain:domain];
	[self loadMacrosLocaleAtURL:url];
	locales = [storage objectForKey:@"./Locales"];
	names = [locales objectForKey:@"Tooltip"];
	if(name = [names objectForKey:key])
	{
		return name;
	}
//iTM2_END;
	return key;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= macroActionForKey:context:ofCategory:inDomain:
- (id)macroActionForKey:(NSString *)key context:(NSString *)context ofCategory:(NSString *)category inDomain:(NSString *)domain;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id storage = [self storageForContext:context ofCategory:category inDomain:domain];
	NSDictionary * D = [storage objectForKey:@"Actions"];
	if(!D)
	{
		[self updateActionsIndexForContext:context ofCategory:category inDomain:domain];
		D = [storage objectForKey:@"Actions"];
	}
//iTM2_END;
	return [D objectForKey:key];
}
#pragma mark -
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= updateLocalesIndexForContext:ofCategory:inDomain:
- (void)updateLocalesIndexForContext:(NSString *)context ofCategory:(NSString *)category inDomain:(NSString *)domain;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSMutableDictionary * macros = [NSMutableDictionary dictionary];
	// first we scan the built in resources, from the deeper embedded bundle to the main one
	NSString * path = [[iTM2MacroServerDirectoryName stringByAppendingPathComponent:domain] stringByAppendingPathComponent:category];
	NSEnumerator * E = [[[NSBundle mainBundle] pathsForBuiltInResource:@"iTM2LocalesIndex" ofType:@"xml" inDirectory:path] objectEnumerator];
	while(path = [E nextObject])
	{
		NSError * error = nil;
		[macros addEntriesFromDictionary:[self indexWithContentsOfFile:path error:&error]];
		if(error)
		{
			iTM2_LOG(@"***  ERROR: %@\nreason: %@\nrecover: %@",
				[error localizedDescription], [error localizedFailureReason], [error localizedRecoverySuggestion]);
		}
	}
	// then we have to rebuild the index for the user support domain
	path = [[iTM2TaskWrapper classBundle] pathForAuxiliaryExecutable:@"bin/iTM2CreateLocalesIndex.pl"];
    if([path length])
	{
		iTM2TaskWrapper * TW = [[[iTM2TaskWrapper alloc] init] autorelease];
		[TW setLaunchPath:path];
		[TW addArgument:@"--directory"];
		NSString * P = [[NSBundle mainBundle] pathForSupportDirectory:iTM2MacroServerDirectoryName inDomain:NSUserDomainMask create:NO];
		[TW addArgument:P];
		iTM2TaskController * TC = [[[iTM2TaskController allocWithZone:[self zone]] init] autorelease];
		[TC addTaskWrapper:TW];
		[TC setMute:YES];
		[TC start];
		[TC waitUntilExit];
	}
	else
	{
		iTM2_LOG(@"*** ERROR: bad configuration, reinstall and report bug if the problem is not solved.");
	}
	E = [[[NSBundle mainBundle] pathsForSupportResource:@"iTM2LocalesIndex" ofType:@"xml" inDirectory:iTM2MacroServerDirectoryName] objectEnumerator];
	while(path = [E nextObject])
	{
		NSError * error = nil;
		[macros addEntriesFromDictionary:[self indexWithContentsOfFile:path error:&error]];
		if(error)
		{
			iTM2_LOG(@"***  ERROR: %@\nreason: %@\nrecover: %@",
				[error localizedDescription], [error localizedFailureReason], [error localizedRecoverySuggestion]);
		}
	}
	[[self storageForContext:context ofCategory:category inDomain:domain] setObject:macros forKey:@"Locales"];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= updateActionsIndexForContext:ofCategory:inDomain:
- (void)updateActionsIndexForContext:(NSString *)context ofCategory:(NSString *)category inDomain:(NSString *)domain;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSMutableDictionary * macros = [NSMutableDictionary dictionary];
	// first we scan the built in resources, from the deeper embedded bundle to the main one
	NSEnumerator * E = [[[NSBundle mainBundle] pathsForBuiltInResource:@"Actions" ofType:@"xml" inDirectory:[[iTM2MacroServerDirectoryName stringByAppendingPathComponent:domain] stringByAppendingPathComponent:category]] objectEnumerator];
	NSString * path;
	while(path = [E nextObject])
	{
		NSError * error = nil;
		[macros addEntriesFromDictionary:[self indexWithContentsOfFile:path error:&error]];
		if(error)
		{
			iTM2_LOG(@"***  ERROR: %@\nreason: %@\nrecover: %@",
				[error localizedDescription], [error localizedFailureReason], [error localizedRecoverySuggestion]);
		}
	}
	// then we have to rebuild the index for the user support domain
	path = [[iTM2TaskWrapper classBundle] pathForAuxiliaryExecutable:@"bin/iTM2CreateActionsIndex.pl"];
    if([path length])
	{
		iTM2TaskWrapper * TW = [[[iTM2TaskWrapper alloc] init] autorelease];
		[TW setLaunchPath:path];
		[TW addArgument:@"--directory"];
		NSString * P = [[NSBundle mainBundle] pathForSupportDirectory:iTM2MacroServerDirectoryName inDomain:NSUserDomainMask create:NO];
		[TW addArgument:P];
		iTM2TaskController * TC = [[[iTM2TaskController allocWithZone:[self zone]] init] autorelease];
		[TC addTaskWrapper:TW];
		[TC setMute:NO];
		[TC start];
		[TC waitUntilExit];
	}
	else
	{
		iTM2_LOG(@"*** ERROR: bad configuration, reinstall and report bug if the problem is not solved.");
	}
	E = [[[NSBundle mainBundle] pathsForSupportResource:nil ofType:iTM2MacroServerDirectoryName inDirectory:@"iTM2ActionsIndex"] objectEnumerator];
	while(path = [E nextObject])
	{
		NSError * error = nil;
		[macros addEntriesFromDictionary:[self indexWithContentsOfFile:path error:&error]];
		if(error)
		{
			iTM2_LOG(@"***  ERROR: %@\nreason: %@\nrecover: %@",
				[error localizedDescription], [error localizedFailureReason], [error localizedRecoverySuggestion]);
		}
	}
	[[self storageForContext:context ofCategory:category inDomain:domain] setObject:macros forKey:@"Actions"];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  loadMacrosLocaleAtURL:
- (void)loadMacrosLocaleAtURL:(NSURL *)url;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 06/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(![url isFileURL])
	{
		return;
	}
	NSString * path = [url path];
	NSArray * components = [path pathComponents];
	path = [path stringByAppendingPathComponent:@"Locales"];
	path = [path stringByAppendingPathExtension:@"xml"];
	int index = [components indexOfObject:iTM2MacroServerDirectoryName];
	if(index==NSNotFound)
	{
		return;
	}
	NSString * domain = @"";
	NSString * category = @"";
	NSString * context = @"";
	if(++index < [components count]-1)
	{
		domain = [components objectAtIndex:index];
	}
	if(++index < [components count]-1)
	{
		category = [components objectAtIndex:index];
	}
	if(++index < [components count]-1)
	{
		context = [components objectAtIndex:index];
	}
	NSMutableDictionary * MD = [self storageForContext:context ofCategory:category inDomain:domain];
	NSMutableDictionary * locales = [MD objectForKey:@"./Locales"];
	if(!locales)
	{
		locales = [NSMutableDictionary dictionary];
		[MD setObject:locales forKey:@"./Locales"];
	}
	NSURL * sourceURL = [NSURL fileURLWithPath:path];
	NSError * localError = nil;
	NSXMLDocument * source = [[[NSXMLDocument alloc] initWithContentsOfURL:sourceURL options:0 error:&localError] autorelease];
	if(localError)
	{
		iTM2_REPORTERROR(1,([NSString stringWithFormat:@"There was an error while creating the document at:\n%@",sourceURL]), localError);
	}
	id node = [source rootElement];
	if(node = [node nextNode])
	{
		NSString * name = [node name];
		if([name isEqual:@"LIST"])
		{
			if(node = [node nextNode])
			{
				NSString * name = [node name];
				if([name isEqual:@"ITEM"])
				{
					NSMutableDictionary * D = [NSMutableDictionary dictionary];
					id keyAttribute = [node attributeForName:@"KEY"];
					NSString * K = [keyAttribute stringValue];
					while(node = [node nextNode])
					{
						NSString * name = [node name];
						if([name isEqual:@"NAME"])
						{
							[D setObject:[node stringValue] forKey:@"Name"];
						}
						else if([name isEqual:@"DESC"])
						{
							[D setObject:[node stringValue] forKey:@"Description"];
						}
						else if([name isEqual:@"TIP"])
						{
							[D setObject:[node stringValue] forKey:@"Tooltip"];
						}
						else if([name isEqual:@"ITEM"])
						{
							[locales setObject:D forKey:K];
							D = [NSMutableDictionary dictionary];
							keyAttribute = [node attributeForName:@"KEY"];
							K = [keyAttribute stringValue];
						}
					}
					[locales setObject:D forKey:K];
				}
			}
		}
	}
//iTM2_END;
	return;
}
#pragma mark -
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= indexWithContentsOfFile:
- (id)indexWithContentsOfFile:(NSString*)path error:(NSError **)outError;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	*outError = nil;
	NSXMLDocument * xmlDoc = [[[NSXMLDocument alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] options:0 error:outError] autorelease];
	if(*outError)
	{
		return nil;
	}
	else
	{
		// parse the doc
		NSXMLElement * element = [xmlDoc rootElement];
		if([[element name] isEqual:@"LIST"])
		{
			NSString * prefixKey = [[element attributeForName:@"KEY"] stringValue]?:@"";
			NSMutableDictionary * result = [NSMutableDictionary dictionary];
			NSEnumerator * E = [[element elementsForName:@"ITEM"] objectEnumerator];
			while(element = [E nextObject])
			{
				[result setObject:element forKey:[NSString stringWithFormat:@"%@%@", prefixKey, [[element attributeForName:@"KEY"] stringValue]]];
			}
			return result;
		}
		else
		{
			iTM2_OUTERROR(1,([NSString stringWithFormat:@"The root element must be a LIST node\n%@",path]),nil);
		}
	}
//iTM2_END;
	return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= macrosIndexWithContentsOfFile:error:
- (id)macrosIndexWithContentsOfFile:(NSString *)path error:(NSError **)outError;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	* outError = nil;
	NSXMLDocument * xmlDoc = [[[NSXMLDocument alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] options:0 error:outError] autorelease];
	if(* outError)
	{
		return nil;
	}
	else if(xmlDoc)
	{
		NSXMLElement * element = [xmlDoc rootElement];
		if([[element name] isEqual:@"LIST"])
		{
			NSString * base = [path stringByDeletingPathExtension];
			NSMutableDictionary * result = [NSMutableDictionary dictionary];
			NSString * prefixKey = [[element attributeForName:@"KEY"] stringValue]?:@"";
			NSEnumerator * E = [[element elementsForName:@"ITEM"] objectEnumerator];
			while(element = [E nextObject])
			{
				NSString * P = [element stringValue];
				if([P hasPrefix:@"."])
				{
					P = [base stringByAppendingPathComponent:P];
				}
				[result setObject:P forKey:[NSString stringWithFormat:@"%@%@", prefixKey, [[element attributeForName:@"KEY"] stringValue]]];
			}
			return result;
		}
		else if(outError)
		{
			*outError = [NSError errorWithDomain:@"iTM2MacrosKit" code:2 userInfo:
				[NSDictionary dictionaryWithObjectsAndKeys:
					@"Bad file format", NSLocalizedDescriptionKey,
					@"The root element must be a LIST node", NSLocalizedFailureReasonErrorKey,
					@"Reinstall and report bug if this does not solve thee problem", NSLocalizedRecoverySuggestionErrorKey,
					[NSArray arrayWithObjects:nil], NSLocalizedRecoveryOptionsErrorKey,
					path, NSFilePathErrorKey,
						nil]];
		}
	}
//iTM2_END;
	return nil;
}
#pragma mark -
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  macroMenuWithXMLElement:forContext:ofCategory:inDomain:error:
- (NSMenu *)macroMenuWithXMLElement:(id)element forContext:(NSString *)context ofCategory:(NSString *)category inDomain:(NSString *)domain error:(NSError **)outError;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * name = [element name];
	if([name isEqualToString:@"LIST"])
	{
		NSString * prefix = [[element attributeForName:@"KEY"] stringValue];
		if(!prefix)
			prefix = @"";
		if([element childCount])
		{
			NSMenu * M = [[[NSMenu allocWithZone:[NSMenu menuZone]] initWithTitle:@""] autorelease];
			id child = [element childAtIndex:0];
			do
			{
				NSMenuItem * MI = [self macroMenuItemWithXMLElement:child forContext:context ofCategory:category inDomain:domain error:outError];
				if(MI)
					[M addItem:MI];
			}
			while(child = [child nextSibling]);
			return M;
		}
	}
	else if(element)
	{
		iTM2_LOG(@"ERROR: unknown name %@.", name);
	}
//iTM2_END;
    return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  macroMenuItemWithXMLElement:forContext:ofCategory:inDomain:error:
- (NSMenuItem *)macroMenuItemWithXMLElement:(id)element forContext:(NSString *)context ofCategory:(NSString *)category inDomain:(NSString *)domain error:(NSError **)outError;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * name = [element name];
	if([name isEqualToString:@"SEP"])
	{
		return [NSMenuItem separatorItem];
	}
	else if([name isEqualToString:@"ITEM"])
	{
		NSString * key = [[element attributeForName:@"KEY"] stringValue];
		context = [[element attributeForName:@"CONT"] stringValue]?:context;
		category = [[element attributeForName:@"CAT"] stringValue]?:category;
		domain = [[element attributeForName:@"DOM"] stringValue]?:domain;
		NSString * toolTip = [[[element elementsForName:@"TIP"] lastObject] stringValue];
		NSString * name = [[[element elementsForName:@"NAME"] lastObject] stringValue];
		if(![name length])
		{
			name = [self macroLocaleOfType:@"Name" forKey:key context:context ofCategory:category inDomain:domain];
		}
		NSMenuItem * MI = [[[NSMenuItem allocWithZone:[NSMenu menuZone]]
			initWithTitle: name action: NULL keyEquivalent: @""] autorelease];
		if([key length])
		{
			[MI setRepresentedObject:[NSArray arrayWithObjects:key, context, category, domain, nil]];
			[MI setTarget:self];
			[MI setAction:@selector(___insertMacro:)];
		}
		[MI setToolTip:toolTip];
		id list = [[element elementsForName:@"LIST"] lastObject];
		NSMenu * M = [self macroMenuWithXMLElement:list forContext:context ofCategory:category inDomain:domain error:outError];
		[MI setSubmenu:M];
		return MI;
	}
	else
	{
		iTM2_LOG(@"ERROR: unknown name %@.", name);
	}
//iTM2_END;
    return nil;
}
#pragma mark -
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  loadMacrosSummaries
- (void)loadMacrosSummaries;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 06/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
	iTM2_INIT_POOL;
//iTM2_START;
	if(!_iTM2_MacroServer_Data)
		_iTM2_MacroServer_Data = [[NSMutableDictionary dictionary] retain];
	// read the built in stuff
	// inside frameworks then bundles.
	NSArray * frameworks = [NSBundle allFrameworks];
	NSMutableArray * plugins = [NSMutableArray arrayWithArray:[NSBundle allBundles]];
	[plugins removeObjectsInArray:frameworks];// plugins are bundles
	NSBundle * mainBundle = [NSBundle mainBundle];
	[plugins removeObject:mainBundle];// plugins are bundles, except the main one
	// sorting the frameworks and plugins
	// separating them according to their domain
	NSString * networkPrefix = [mainBundle pathForSupportDirectory:@"" inDomain:NSNetworkDomainMask create:NO];
	networkPrefix = [networkPrefix stringByAppendingString:iTM2PathComponentsSeparator];
	NSString * localPrefix = [mainBundle pathForSupportDirectory:@"" inDomain:NSLocalDomainMask create:NO];
	localPrefix = [localPrefix stringByAppendingString:iTM2PathComponentsSeparator];
	NSString * userPrefix = [mainBundle pathForSupportDirectory:@"" inDomain:NSUserDomainMask create:NO];
	userPrefix = [userPrefix stringByAppendingString:iTM2PathComponentsSeparator];
	
	NSMutableArray * networkFrameworks = [NSMutableArray array];
	NSMutableArray * localFrameworks = [NSMutableArray array];
	NSMutableArray * userFrameworks = [NSMutableArray array];
	NSMutableArray * otherFrameworks = [NSMutableArray array];
	NSEnumerator * E = [frameworks objectEnumerator];
	NSBundle * B = nil;
	while(B = [E nextObject])
	{
		NSString * P = [B bundlePath];
		if([P hasPrefix:userPrefix])
			[userFrameworks addObject:B];
		else if([P hasPrefix:localPrefix])
			[localFrameworks addObject:B];
		else if([P hasPrefix:networkPrefix])
			[networkFrameworks addObject:B];
		else
			[otherFrameworks addObject:B];
	}
	NSMutableArray * networkPlugIns = [NSMutableArray array];
	NSMutableArray * localPlugIns = [NSMutableArray array];
	NSMutableArray * userPlugIns = [NSMutableArray array];
	NSMutableArray * otherPlugIns = [NSMutableArray array];
	E = [plugins objectEnumerator];
	while(B = [E nextObject])
	{
		NSString * P = [B bundlePath];
		if([P hasPrefix:userPrefix])
			[userPlugIns addObject:B];
		else if([P hasPrefix:localPrefix])
			[localPlugIns addObject:B];
		else if([P hasPrefix:networkPrefix])
			[networkPlugIns addObject:B];
		else
			[otherPlugIns addObject:B];
	}
	// load
	#define RELOAD(ARRAY)\
	E = [ARRAY objectEnumerator];\
	while(B = [E nextObject]) [self loadMacrosSummariesAtPath:[B pathForResource:iTM2MacroServerDirectoryName ofType:nil]];
	RELOAD(otherFrameworks);
	RELOAD(otherPlugIns);
	[self loadMacrosSummariesAtPath:
		[mainBundle pathForResource:iTM2MacroServerDirectoryName ofType:nil]];
	RELOAD(networkFrameworks);
	RELOAD(networkPlugIns);
	[self loadMacrosSummariesAtPath:
		[mainBundle pathForSupportDirectory:iTM2MacroServerDirectoryName inDomain:NSNetworkDomainMask create:NO]];
	RELOAD(localFrameworks);
	RELOAD(localPlugIns);
	[self loadMacrosSummariesAtPath:
		[mainBundle pathForSupportDirectory:iTM2MacroServerDirectoryName inDomain:NSLocalDomainMask create:NO]];
	RELOAD(userFrameworks);
	RELOAD(userPlugIns);
	[self loadMacrosSummariesAtPath:
		[mainBundle pathForSupportDirectory:iTM2MacroServerDirectoryName inDomain:NSUserDomainMask create:YES]];
	#undef RELOAD
//iTM2_END;
	iTM2_RELEASE_POOL;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  loadMacrosSummaryAtPath:
- (void)loadMacrosSummaryAtPath:(NSString *)path;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 06/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;NSNotFound
	NSArray * components = [path pathComponents];
	int index = [components indexOfObject:iTM2MacroServerDirectoryName];
	if(index==NSNotFound)
	{
		return;
	}
	NSString * domain = @"";
	NSString * category = @"";
	NSString * context = @"";
	if(++index < [components count]-1)
	{
		domain = [components objectAtIndex:index];
	}
	if(++index < [components count]-1)
	{
		category = [components objectAtIndex:index];
	}
	if(++index < [components count]-1)
	{
		context = [components objectAtIndex:index];
	}
	NSMutableDictionary * MD = [self storageForContext:context ofCategory:category inDomain:domain];
	NSMutableDictionary * URLs = [MD objectForKey:@"./URLs"];
	if(!URLs)
	{
		URLs = [NSMutableDictionary dictionary];
		[MD setObject:URLs forKey:@"./URLs"];
	}
	NSMutableDictionary * CUTs = [MD objectForKey:@"./CUTs"];
	if(!CUTs)
	{
		CUTs = [NSMutableDictionary dictionary];
		[MD setObject:URLs forKey:@"./CUTs"];
	}
	NSURL * sourceURL = [NSURL fileURLWithPath:path];
	path = [path stringByDeletingLastPathComponent];
	NSURL * URL = [NSURL fileURLWithPath:path];
	NSError * localError = nil;
	NSXMLDocument * source = [[[NSXMLDocument alloc] initWithContentsOfURL:sourceURL options:0 error:&localError] autorelease];
	if(localError)
	{
		iTM2_REPORTERROR(1,(@"There was an error while creating the document"), localError);
	}
	id node = [source rootElement];
	if(node = [node nextNode])
	{
		NSString * name = [node name];
		if([name isEqual:@"LIST"])
		{
			while(node = [node nextNode])
			{
				NSString * name = [node name];
				if([name isEqual:@"ITEM"])
				{
					id keyAttribute = [node attributeForName:@"KEY"];
					[URLs setObject:URL forKey:[keyAttribute stringValue]];
				}
				else if([name isEqual:@"CUTS"])
				{
					while(node = [node nextNode])
					{
						NSString * name = [node name];
						if([name isEqual:@"CUT"])
						{
							id keyAttribute = [node attributeForName:@"KEY"];
							id cutAttribute = [node attributeForName:@"CUT"];
							[URLs setObject:[keyAttribute stringValue] forKey:[cutAttribute stringValue]];
						}
					}
				}
			}
		}
	}
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  loadMacrosSummariesAtPath:
- (void)loadMacrosSummariesAtPath:(NSString *)path;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 06/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
	if(![path length])
		return;
	if(!_iTM2_MacroServer_Data)
		_iTM2_MacroServer_Data = [[NSMutableDictionary dictionary] retain];
	iTM2_INIT_POOL;
//iTM2_START;
	// We find all the Summary.xml files inside
	// then read them and append the result to the server data base.
	NSString * summary = [path stringByAppendingPathComponent:iTM2MacroServerSummaryComponent];
	summary = [summary stringByAppendingPathExtension:@"xml"];
	if([DFM fileExistsAtPath:summary])
	{
		[self loadMacrosSummaryAtPath:summary];
	}
	NSEnumerator * domainE = [[DFM directoryContentsAtPath:path] objectEnumerator];
	NSString * domain;
	while(domain = [domainE nextObject])
	{
		domain = [path stringByAppendingPathComponent:domain];
		// is it a directory?
		BOOL isDirectory = NO;
		if([DFM fileExistsAtPath:domain isDirectory:&isDirectory] && isDirectory)
		{
			summary = [domain stringByAppendingPathComponent:iTM2MacroServerSummaryComponent];
			summary = [summary stringByAppendingPathExtension:@"xml"];
			if([DFM fileExistsAtPath:summary])
			{
				[self loadMacrosSummaryAtPath:summary];
			}
			NSEnumerator * categoryE = [[DFM directoryContentsAtPath:domain] objectEnumerator];
			NSString * category;
			while(category = [categoryE nextObject])
			{
				category = [domain stringByAppendingPathComponent:category];
				// is it a directory?
				BOOL isDirectory = NO;
				if([DFM fileExistsAtPath:category isDirectory:&isDirectory] && isDirectory)
				{
					summary = [category stringByAppendingPathComponent:iTM2MacroServerSummaryComponent];
					summary = [summary stringByAppendingPathExtension:@"xml"];
					if([DFM fileExistsAtPath:summary])
					{
						[self loadMacrosSummaryAtPath:summary];
					}
					NSEnumerator * contextE = [[DFM directoryContentsAtPath:category] objectEnumerator];
					NSString * context;
					while(context = [contextE nextObject])
					{
						context = [category stringByAppendingPathComponent:context];
						// is it a directory?
						BOOL isDirectory = NO;
						if([DFM fileExistsAtPath:context isDirectory:&isDirectory] && isDirectory)
						{
							summary = [category stringByAppendingPathComponent:iTM2MacroServerSummaryComponent];
							summary = [summary stringByAppendingPathExtension:@"xml"];
							if([DFM fileExistsAtPath:summary])
							{
								[self loadMacrosSummaryAtPath:summary];
							}
						}
					}
				}
			}
		}
	}
//iTM2_END;
	iTM2_RELEASE_POOL;
	return;
}
@end
