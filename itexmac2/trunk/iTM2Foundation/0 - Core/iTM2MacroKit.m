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

#import <iTM2Foundation/iTM2PathUtilities.h>
#import <iTM2Foundation/iTM2BundleKit.h>
#import <iTM2Foundation/iTM2TaskKit.h>
#import <iTM2Foundation/iTM2FileManagerKit.h>
#import <iTM2Foundation/iTM2MenuKit.h>

NSString * const iTM2TextMarkPlaceholder = @"__";
NSString * const iTM2TextStartPlaceholder = @"__(";
NSString * const iTM2TextStopPlaceholder = @")__";
NSString * const iTM2TextStartARGPlaceholder = @"__(ARG:";
NSString * const iTM2TextStartOPTPlaceholder = @"__(OPT:";
NSString * const iTM2TextStartTEXTPlaceholder = @"__(TEXT:";
NSString * const iTM2TextStartFILEPlaceholder = @"__(FILE:";
NSString * const iTM2TextStartTIPPlaceholder = @"__(TIP:";
NSString * const iTM2TextINSPlaceholder = @"__(INS)__";
NSString * const iTM2TextSELPlaceholder = @"__(SEL)__";// out of use with perl support
NSString * const iTM2TextTABPlaceholder = @"__(TAB)__";

NSString * const iTM2TextTabAnchorStringKey = @"iTM2TextTabAnchorString";

NSString * const iTM2MacroServerComponent = @"Macros.localized";
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
		NSString * P = [[NSBundle mainBundle] pathForSupportDirectory:iTM2MacroServerComponent inDomain:NSUserDomainMask create:NO];
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
+ (NSMenu *)macrosMenuAtPath:(NSString *)file error:(NSError **)outErrorPtr;
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
            error:outErrorPtr] autorelease];
    if (!xmlDoc)  {
		if(outErrorPtr && !(*outErrorPtr))
			*outErrorPtr = [NSError errorWithDomain:@"iTeXMac2.script.macrosMenuAtPath:error:" code:1 userInfo:
				[NSDictionary dictionaryWithObjectsAndKeys:
					@"File not conforming to its definition", NSLocalizedDescriptionKey,// NSString
					@"File is missing a DOMAIN title", NSLocalizedFailureReasonErrorKey,// NSString
					// [NSString stringWithFormat:@"Reinstall or edit file:%@", path], NSLocalizedRecoverySuggestionErrorKey,// NSString
					// [NSArray arrayWithObjects:nil], NSLocalizedRecoveryOptionsErrorKey,// NSArray of NSStrings
					// [NSNull null], NSRecoveryAttempterErrorKey,// Instance of a subclass of NSObject that conforms to the NSErrorRecoveryAttempting informal protocol
						nil]];
		return nil;
	}
	NSMenu * M = [[[self _macrosMenuItemWithXMLElement:[xmlDoc rootElement] error:outErrorPtr] submenu] retain];
//iTM2_END;
	iTM2_RELEASE_POOL;
	return [M autorelease];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  _macrosMenuItemWithXMLElement:error:
+ (NSMenuItem *)_macrosMenuItemWithXMLElement:(NSXMLElement *)element error:(NSError **)outErrorPtr;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 06/02/2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([[element name] isEqualToString:@"M"])
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
			if([name isEqualToString:@"T"])
			{
				title = [child stringValue];
			}
			else
			{
				if([name isEqualToString:@"D"])
				{
					domain = [child stringValue];
					child = [E nextObject];
					name = [child name];
				}
				if([name isEqualToString:@"C"])
				{
					category = [child stringValue];
					child = [E nextObject];
					name = [child name];
				}
				if([name isEqualToString:@"K"])
				{
					key = [child stringValue];// we must have a key,
				}
				else
				{
					if(outErrorPtr)
						*outErrorPtr = [NSError errorWithDomain:@"iTeXMac2.script._macrosMenuItemWithXMLElement:error:" code:1 userInfo:
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
				NSMenuItem * mi = [self _macrosMenuItemWithXMLElement:child error:outErrorPtr];
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
	else if([[element name] isEqualToString:@"I"])
	{
		NSEnumerator * E = [[element children] objectEnumerator];
		id child;
		NSString * domain = @"";
		NSString * category = @"";
		NSString * key = @"";
		if(child = [E nextObject])
		{
			NSString * name = [child name];
			if([name isEqualToString:@"D"])
			{
				domain = [child stringValue];
				child = [E nextObject];
				name = [child name];
			}
			if([name isEqualToString:@"C"])
			{
				category = [child stringValue];
				child = [E nextObject];
				name = [child name];
			}
			if([name isEqualToString:@"K"])
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
	else if([[element name] isEqualToString:@"S"])
		return [NSMenuItem separatorItem];
//iTM2_END;
	return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  macrosMenuAtPath:error:
+ (NSMenu *)___macrosMenuAtPath:(NSString *)path error:(NSError **)outErrorPtr;
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
	NSString * S = [NSString stringWithContentsOfFile:path usedEncoding:&encoding error:outErrorPtr];
	if(![S length] || (outErrorPtr && !(*outErrorPtr)))
		return nil;
	unsigned end, contentsEnd;
	[S getLineStart:nil end:&end contentsEnd:&contentsEnd forRange:NSMakeRange(0, 0)];
	NSString * recordSeparator = [S substringWithRange:NSMakeRange(0, (contentsEnd? :end))];
	NSEnumerator * E = [[S componentsSeparatedByString:recordSeparator] objectEnumerator];
	NSMenu * M = [[self _macrosMenuFromEnumerator:E error:outErrorPtr] retain];
//iTM2_END;
	iTM2_RELEASE_POOL;
	return [M autorelease];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  _macrosMenuItemFromEnumerator:error:
+ (NSMenuItem *)_macrosMenuItemFromEnumerator:(NSEnumerator *)enumerator error:(NSError **)outErrorPtr;
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
				NSMenu * M = [self _macrosMenuFromEnumerator:enumerator error:outErrorPtr];
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
						if(outErrorPtr)
							*outErrorPtr = [NSError errorWithDomain:@"iTeXMac2.script._macrosMenuItemFromEnumerator:error:" code:1 userInfo:
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
						if(outErrorPtr)
							*outErrorPtr = [NSError errorWithDomain:@"iTeXMac2.script._macrosMenuItemFromEnumerator:error:" code:1 userInfo:
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
					if(outErrorPtr)
						*outErrorPtr = [NSError errorWithDomain:@"iTeXMac2.script._macrosMenuItemFromEnumerator:error:" code:2 userInfo:
							[NSDictionary dictionaryWithObjectsAndKeys:
								@"File not conforming to its definition", NSLocalizedDescriptionKey,// NSString
								@"File is missing a KEY title", NSLocalizedFailureReasonErrorKey,// NSString
								// [NSString stringWithFormat:@"Reinstall or edit file:%@", path], NSLocalizedRecoverySuggestionErrorKey,// NSString
								// [NSArray arrayWithObjects:nil], NSLocalizedRecoveryOptionsErrorKey,// NSArray of NSStrings
								// [NSNull null], NSRecoveryAttempterErrorKey,// Instance of a subclass of NSObject that conforms to the NSErrorRecoveryAttempting informal protocol
									nil]];
					return nil;
				}
				if(outErrorPtr)
					*outErrorPtr = [NSError errorWithDomain:@"iTeXMac2.script._macrosMenuItemFromEnumerator:error:" code:3 userInfo:
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
			if(outErrorPtr)
				*outErrorPtr = [NSError errorWithDomain:@"iTeXMac2.script._macrosMenuItemFromEnumerator:error:" code:4 userInfo:
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
		if(outErrorPtr)
			*outErrorPtr = [NSError errorWithDomain:@"iTeXMac2.script._macrosMenuItemFromEnumerator:error:" code:5 userInfo:
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
+ (NSMenu *)_macrosMenuFromEnumerator:(NSEnumerator *)enumerator error:(NSError **)outErrorPtr;
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
			NSMenuItem * MI = [self _macrosMenuItemFromEnumerator:enumerator error:outErrorPtr];
			if(MI)
			{
				[M addItem:MI];
nextITEM:
				if(S = [enumerator nextObject])
				{
					if([S isEqualToString:@"ITEM"])
					{
						if(MI = [self _macrosMenuItemFromEnumerator:enumerator error:outErrorPtr])
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
						if(outErrorPtr)
							*outErrorPtr = [NSError errorWithDomain:@"iTeXMac2.script._macrosMenuFromEnumerator:error:" code:2 userInfo:
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
					if(outErrorPtr)
						*outErrorPtr = [NSError errorWithDomain:@"iTeXMac2.script._macrosMenuFromEnumerator:error:" code:3 userInfo:
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
			if(outErrorPtr)
				*outErrorPtr = [NSError errorWithDomain:@"iTeXMac2.script._macrosMenuFromEnumerator:error:" code:2 userInfo:
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
		if(outErrorPtr)
			*outErrorPtr = [NSError errorWithDomain:@"iTeXMac2.script._macrosMenuFromEnumerator:error:" code:1 userInfo:
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
//		NSString * P = [[NSBundle mainBundle] pathForSupportDirectory:iTM2MacroServerComponent inDomain:NSUserDomainMask create:NO];
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
- (NSMenuItem *)macroMenuItemWithXMLElement:(id)element forContext:(NSString *)context ofCategory:(NSString *)category inDomain:(NSString *)domain error:(NSError **)outErrorPtr;
- (NSMenu *)macroMenuForContext:(NSString *)context ofCategory:(NSString *)category inDomain:(NSString *)domain error:(NSError **)outErrorPtr;
- (NSMenu *)macroMenuWithXMLElement:(id)element forContext:(NSString *)context ofCategory:(NSString *)category inDomain:(NSString *)domain error:(NSError **)outErrorPtr;
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
	@copyright		2005 jlaurens AT users.sourceforge.net and others.
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
	@copyright		2005 jlaurens AT users.sourceforge.net and others.
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
	@copyright		2005 jlaurens AT users.sourceforge.net and others.
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
	@param			outErrorPtr
	@result			A hash...
	@availability	iTM2.
	@copyright		2005 jlaurens AT users.sourceforge.net and others.
*/
- (id)indexWithContentsOfFile:(NSString*)path error:(NSError **)outErrorPtr;

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
	@param			outErrorPtr
	@result			A hash...
	@availability	iTM2.
	@copyright		2005 jlaurens AT users.sourceforge.net and others.
*/
- (id)macrosIndexWithContentsOfFile:(NSString *)path error:(NSError **)outErrorPtr;

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
	iTM2RedirectNSLogOutput();
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
	NSString * path = [[iTM2MacroServerComponent stringByAppendingPathComponent:domain] stringByAppendingPathComponent:category];
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
		NSString * P = [[NSBundle mainBundle] pathForSupportDirectory:iTM2MacroServerComponent inDomain:NSUserDomainMask create:NO];
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
	E = [[[NSBundle mainBundle] pathsForSupportResource:@"iTM2LocalesIndex" ofType:@"xml" inDirectory:iTM2MacroServerComponent] objectEnumerator];
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
	NSEnumerator * E = [[[NSBundle mainBundle] pathsForBuiltInResource:@"Actions" ofType:@"xml" inDirectory:[[iTM2MacroServerComponent stringByAppendingPathComponent:domain] stringByAppendingPathComponent:category]] objectEnumerator];
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
		NSString * P = [[NSBundle mainBundle] pathForSupportDirectory:iTM2MacroServerComponent inDomain:NSUserDomainMask create:NO];
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
	E = [[[NSBundle mainBundle] pathsForSupportResource:nil ofType:iTM2MacroServerComponent inDirectory:@"iTM2ActionsIndex"] objectEnumerator];
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
	int index = [components indexOfObject:iTM2MacroServerComponent];
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
		if([name isEqualToString:@"LIST"])
		{
			if(node = [node nextNode])
			{
				NSString * name = [node name];
				if([name isEqualToString:@"ITEM"])
				{
					NSMutableDictionary * D = [NSMutableDictionary dictionary];
					id keyAttribute = [node attributeForName:@"KEY"];
					NSString * K = [keyAttribute stringValue];
					while(node = [node nextNode])
					{
						NSString * name = [node name];
						if([name isEqualToString:@"NAME"])
						{
							[D setObject:[node stringValue] forKey:@"Name"];
						}
						else if([name isEqualToString:@"DESC"])
						{
							[D setObject:[node stringValue] forKey:@"Description"];
						}
						else if([name isEqualToString:@"TIP"])
						{
							[D setObject:[node stringValue] forKey:@"Tooltip"];
						}
						else if([name isEqualToString:@"ITEM"])
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
- (id)indexWithContentsOfFile:(NSString*)path error:(NSError **)outErrorPtr;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	*outErrorPtr = nil;
	NSXMLDocument * xmlDoc = [[[NSXMLDocument alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] options:0 error:outErrorPtr] autorelease];
	if(*outErrorPtr)
	{
		return nil;
	}
	else
	{
		// parse the doc
		NSXMLElement * element = [xmlDoc rootElement];
		if([[element name] isEqualToString:@"LIST"])
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
- (id)macrosIndexWithContentsOfFile:(NSString *)path error:(NSError **)outErrorPtr;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	* outErrorPtr = nil;
	NSXMLDocument * xmlDoc = [[[NSXMLDocument alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] options:0 error:outErrorPtr] autorelease];
	if(* outErrorPtr)
	{
		return nil;
	}
	else if(xmlDoc)
	{
		NSXMLElement * element = [xmlDoc rootElement];
		if([[element name] isEqualToString:@"LIST"])
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
		else if(outErrorPtr)
		{
			*outErrorPtr = [NSError errorWithDomain:@"iTM2MacrosKit" code:2 userInfo:
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
- (NSMenu *)macroMenuWithXMLElement:(id)element forContext:(NSString *)context ofCategory:(NSString *)category inDomain:(NSString *)domain error:(NSError **)outErrorPtr;
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
				NSMenuItem * MI = [self macroMenuItemWithXMLElement:child forContext:context ofCategory:category inDomain:domain error:outErrorPtr];
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
- (NSMenuItem *)macroMenuItemWithXMLElement:(id)element forContext:(NSString *)context ofCategory:(NSString *)category inDomain:(NSString *)domain error:(NSError **)outErrorPtr;
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
		NSMenu * M = [self macroMenuWithXMLElement:list forContext:context ofCategory:category inDomain:domain error:outErrorPtr];
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
	while(B = [E nextObject]) [self loadMacrosSummariesAtPath:[B pathForResource:iTM2MacroServerComponent ofType:nil]];
	RELOAD(otherFrameworks);
	RELOAD(otherPlugIns);
	[self loadMacrosSummariesAtPath:
		[mainBundle pathForResource:iTM2MacroServerComponent ofType:nil]];
	RELOAD(networkFrameworks);
	RELOAD(networkPlugIns);
	[self loadMacrosSummariesAtPath:
		[mainBundle pathForSupportDirectory:iTM2MacroServerComponent inDomain:NSNetworkDomainMask create:NO]];
	RELOAD(localFrameworks);
	RELOAD(localPlugIns);
	[self loadMacrosSummariesAtPath:
		[mainBundle pathForSupportDirectory:iTM2MacroServerComponent inDomain:NSLocalDomainMask create:NO]];
	RELOAD(userFrameworks);
	RELOAD(userPlugIns);
	[self loadMacrosSummariesAtPath:
		[mainBundle pathForSupportDirectory:iTM2MacroServerComponent inDomain:NSUserDomainMask create:YES]];
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
	int index = [components indexOfObject:iTM2MacroServerComponent];
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
		if([name isEqualToString:@"LIST"])
		{
			while(node = [node nextNode])
			{
				NSString * name = [node name];
				if([name isEqualToString:@"ITEM"])
				{
					id keyAttribute = [node attributeForName:@"KEY"];
					[URLs setObject:URL forKey:[keyAttribute stringValue]];
				}
				else if([name isEqualToString:@"CUTS"])
				{
					while(node = [node nextNode])
					{
						NSString * name = [node name];
						if([name isEqualToString:@"CUT"])
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

@implementation NSTextView(Placeholder)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  selectFirstPlaceholder:
- (IBAction)selectFirstPlaceholder:(id)sender;
/*Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon Jan 10 21:45:41 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	// first I remove the selection, if it was a place holder
	NSRange selectedRange = [self selectedRange];
	NSTextStorage * TS = [self textStorage];
	NSString * S = [TS string];
	NSString * tabAnchor = [self tabAnchor];
	NSRange markRange = [S rangeOfPlaceholderFromIndex:selectedRange.location cycle:YES tabAnchor:tabAnchor];
	if(NSEqualRanges(selectedRange,markRange))
	{
		[self insertText:@""];
		selectedRange.length = 0;
	}
	markRange = [S rangeOfPlaceholderFromIndex:0 cycle:NO tabAnchor:tabAnchor];
	if(markRange.length)
	{
		[self setSelectedRange:markRange];
		[self scrollRangeToVisible:[self selectedRange]];
		return;
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  selectNextPlaceholder:
- (IBAction)selectNextPlaceholder:(id)sender;
/*Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon Jan 10 21:45:41 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	// first I remove the selection, if it was a place holder
	NSRange selectedRange = [self selectedRange];
	NSTextStorage * TS = [self textStorage];
	NSString * S = [TS string];
	NSString * tabAnchor = [self tabAnchor];
	NSRange markRange = [S rangeOfPlaceholderFromIndex:selectedRange.location cycle:YES tabAnchor:tabAnchor];
	if(NSEqualRanges(selectedRange,markRange))
	{
		[self insertText:@""];
		selectedRange.length = 0;
	}
	markRange = [S rangeOfPlaceholderFromIndex:selectedRange.location cycle:YES tabAnchor:tabAnchor];
	if(markRange.length)
	{
		[self setSelectedRange:markRange];
		[self scrollRangeToVisible:[self selectedRange]];
		return;
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  selectPreviousPlaceholder:
- (IBAction)selectPreviousPlaceholder:(id)sender;
/*Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon Jan 10 21:45:41 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	// first I remove the selection, if it was a place holder
	NSRange selectedRange = [self selectedRange];
	NSTextStorage * TS = [self textStorage];
	NSString * S = [TS string];
	NSString * tabAnchor = [self tabAnchor];
	NSRange markRange = [S rangeOfPlaceholderFromIndex:selectedRange.location cycle:YES tabAnchor:tabAnchor];
	if(NSEqualRanges(selectedRange,markRange))
	{
		[self insertText:@""];
		selectedRange.length = 0;
	}
	markRange = [S rangeOfPlaceholderToIndex:selectedRange.location cycle:YES tabAnchor:tabAnchor];
	if(markRange.length)
	{
		[self setSelectedRange:markRange];
		[self scrollRangeToVisible:[self selectedRange]];
		return;
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  tabAnchorKey
+ (NSString *)tabAnchorKey;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return iTM2TextTabAnchorStringKey;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  tabAnchor
- (NSString *)tabAnchor;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [self contextStringForKey:[[self class] tabAnchorKey] domain:iTM2ContextAllDomainsMask];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  numberOfSpacesPerTab
- (unsigned)numberOfSpacesPerTab;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [self contextIntegerForKey:iTM2TextNumberOfSpacesPerTabKey domain:iTM2ContextAllDomainsMask];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  selectNextTabAnchor:
- (void)selectNextTabAnchor:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (1.0.10)
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSString * S = [self string];
    int anchor = NSMaxRange([self selectedRange]);
    NSString * anchorString = [self tabAnchor];
    NSRange foundRange = [S rangeOfString:anchorString options:0 range:NSMakeRange(anchor, [S length]-anchor)];
    if(!foundRange.length)
        foundRange = [S rangeOfString:anchorString options:0
                            range: NSMakeRange(0, MIN([S length], anchor + [anchorString length]-1))];
    if(!foundRange.length)
    {
        foundRange = NSMakeRange(NSMaxRange([self selectedRange]), 0);
        [self postNotificationWithToolTip:
            [NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"No %@ tab anchor found.",
                @"TeX", [NSBundle bundleForClass:[self class]],
                    @"Status displayed when navigating within tab anchors."), anchorString]];
        iTM2Beep();
        [self setSelectedRange:NSMakeRange(anchor, 0)];
    }
    else
        [self setSelectedRange:foundRange];
    [self scrollRangeToVisible:foundRange];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  selectNextTabAnchorAndDelete:
- (void)selectNextTabAnchorAndDelete:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (1.0.10)
- 1.2: 06/21/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self selectNextTabAnchor:sender];
    if([self selectedRange].length) [self deleteBackward:sender];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  selectPreviousTabAnchorAndDelete:
- (void)selectPreviousTabAnchorAndDelete:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (1.0.10)
- 1.2: 06/21/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self selectPreviousTabAnchor:sender];
    if([self selectedRange].length) [self deleteBackward:sender];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  selectPreviousTabAnchor:
- (void)selectPreviousTabAnchor:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (1.0.10)
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSString * S = [self string];
    int anchor = [self selectedRange].location;
    NSString * anchorString = [self tabAnchor];
    NSRange foundRange = [S rangeOfString:anchorString options:NSBackwardsSearch
                                range: NSMakeRange(0, anchor)];
    if(!foundRange.length)
    {
        anchor = (anchor < [iTM2TextTABPlaceholder length])? 0:anchor-[anchorString length] + 1;
        foundRange = [S rangeOfString:anchorString options:NSBackwardsSearch
                            range: NSMakeRange(anchor, [S length]-anchor)];
    }
    if(!foundRange.length)
    {
        foundRange = NSMakeRange([self selectedRange].location, 0);
        [self postNotificationWithToolTip:
            [NSString stringWithFormat:NSLocalizedStringFromTableInBundle(@"No %@ tab anchor found.",
                @"TeX", [NSBundle bundleForClass:[self class]],
                    @"Status displayed when navigating within tab anchors."), anchorString]];
        iTM2Beep();
    }
    [self setSelectedRange:foundRange];
    [self scrollRangeToVisible:foundRange];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  cachedSelection
- (NSString *)cachedSelection;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (1.0.10)
- 1.2: 06/24/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [[self string] substringWithRange:[self selectedRange]];
}
@end

@implementation NSString(iTM2TextPlaceholder)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= stringByRemovingTipPlaceHolders
- (NSString *)stringByRemovingTipPlaceHolders;
/*"Description forthcoming.
Version history: jlaurens AT users.sourceforge.net
- 2.0: 
To Do List: ?
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSRange R = [self rangeOfString:iTM2TextStartTIPPlaceholder];
	if(R.length)
	{
		R = [self rangeOfPlaceholderAtIndex:R.location];
		NSRange r;
		r.location = NSMaxRange(R);
		r.length = [self length] - r.location;
		NSString * avant = [self substringWithRange:r];
		r = NSMakeRange(0,R.location);
		NSString * apres = [self substringWithRange:r];
		avant = [avant length]? ([apres length]?[avant stringByAppendingString:apres]:avant):apres;
		return [avant stringByRemovingTipPlaceHolders];
	}
//iTM2_END;
	return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= stringByRemovingPlaceHolderMarks
- (NSString *)stringByRemovingPlaceHolderMarks;
/*"Description forthcoming.
Version history: jlaurens AT users.sourceforge.net
- 2.0: 
To Do List: ?
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSMutableString * result = [[[self stringByRemovingTipPlaceHolders] mutableCopy] autorelease];
	[result replaceOccurrencesOfString:iTM2TextTABPlaceholder withString:@"" options:0 range:NSMakeRange(0,[result length])];
	[result replaceOccurrencesOfString:iTM2TextINSPlaceholder withString:@"" options:0 range:NSMakeRange(0,[result length])];
	[result replaceOccurrencesOfString:iTM2TextSELPlaceholder withString:@"" options:0 range:NSMakeRange(0,[result length])];
	[result replaceOccurrencesOfString:iTM2TextStartARGPlaceholder withString:@"" options:0 range:NSMakeRange(0,[result length])];
	[result replaceOccurrencesOfString:iTM2TextStartOPTPlaceholder withString:@"" options:0 range:NSMakeRange(0,[result length])];
	[result replaceOccurrencesOfString:iTM2TextStartTEXTPlaceholder withString:@"" options:0 range:NSMakeRange(0,[result length])];
	[result replaceOccurrencesOfString:iTM2TextStartFILEPlaceholder withString:@"" options:0 range:NSMakeRange(0,[result length])];
	[result replaceOccurrencesOfString:iTM2TextStartPlaceholder withString:@"" options:0 range:NSMakeRange(0,[result length])];
	[result replaceOccurrencesOfString:iTM2TextStopPlaceholder withString:@"" options:0 range:NSMakeRange(0,[result length])];
//iTM2_END;
	return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= stringByRemovingPlaceHolderMarksWithSelection:
- (NSString *)stringByRemovingPlaceHolderMarksWithSelection:(NSString *)selection;
/*"Description forthcoming.
Version history: jlaurens AT users.sourceforge.net
- 2.0: 
To Do List: ?
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSMutableString * result = [[[self stringByRemovingTipPlaceHolders] mutableCopy] autorelease];
	[result replaceOccurrencesOfString:iTM2TextTABPlaceholder withString:@"" options:0 range:NSMakeRange(0,[result length])];
	[result replaceOccurrencesOfString:iTM2TextINSPlaceholder withString:@"" options:0 range:NSMakeRange(0,[result length])];
	[result replaceOccurrencesOfString:iTM2TextStartARGPlaceholder withString:@"" options:0 range:NSMakeRange(0,[result length])];
	[result replaceOccurrencesOfString:iTM2TextStartOPTPlaceholder withString:@"" options:0 range:NSMakeRange(0,[result length])];
	[result replaceOccurrencesOfString:iTM2TextStartTEXTPlaceholder withString:@"" options:0 range:NSMakeRange(0,[result length])];
	[result replaceOccurrencesOfString:iTM2TextStartFILEPlaceholder withString:@"" options:0 range:NSMakeRange(0,[result length])];
	[result replaceOccurrencesOfString:iTM2TextSELPlaceholder withString:(selection?selection:@"") options:0 range:NSMakeRange(0,[result length])];
	[result replaceOccurrencesOfString:iTM2TextStartPlaceholder withString:@"" options:0 range:NSMakeRange(0,[result length])];
	[result replaceOccurrencesOfString:iTM2TextStopPlaceholder withString:@"" options:0 range:NSMakeRange(0,[result length])];
//iTM2_END;
	return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= rangeOfPlaceholderAtIndex:
- (NSRange)rangeOfPlaceholderAtIndex:(unsigned)index;
/*"Description forthcoming.
Version history: jlaurens AT users.sourceforge.net
- 2.0: 02/15/2006
To Do List: implement some kind of balance range for range
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	unsigned length = [self length];
	if(index>=length)
	{
		return NSMakeRange(NSNotFound,0);
	}
	NSRange stopR;
	unichar startChar = [iTM2TextStartPlaceholder characterAtIndex:[iTM2TextStartPlaceholder length]-1];
	unichar stopChar  = [iTM2TextStopPlaceholder  characterAtIndex:0];

	unsigned idx;
	unsigned depth = 1;
	unsigned top = UINT_MAX;
	
	NSRange searchRange = NSMakeRange(0,0);
	searchRange.location = MAX(index,1)-1;
	
	NSRange markR;
nextMark:
	searchRange.length = length-searchRange.location;
	markR = [self rangeOfString:iTM2TextMarkPlaceholder options:nil range:searchRange];
	if(markR.length)
	{
		if(markR.location<top)
		{
			top = markR.location;
		}
		// is it a start?
		idx = NSMaxRange(markR);
		if(idx<length)
		{
			if([self characterAtIndex:idx] == startChar)
			{
				// it is a start place holder
				++depth;
				searchRange.location = NSMaxRange(markR);
				goto nextMark;
			}
		}
		if(markR.location)
		{
			if([self characterAtIndex:markR.location-1] == stopChar)
			{
				if(--depth)
				{
					// not yet
					searchRange.location = NSMaxRange(markR);
					goto nextMark;
				}
				else
				{
					searchRange.location = 0;
					searchRange.length = top-searchRange.location;
					stopR = markR;
					depth = 1;
previousMark:
					markR = [self rangeOfString:iTM2TextMarkPlaceholder options:NSBackwardsSearch range:searchRange];
					if(markR.length)
					{
						// is it a start?
						idx = NSMaxRange(markR);
						if((idx<length) && ([self characterAtIndex:idx] == startChar))
						{
							if(--depth)
							{
								// not yet
								searchRange.length = markR.location;
								goto nextMark;
							}
							else
							{
								return NSMakeRange(markR.location,NSMaxRange(stopR)-markR.location);
							}
						}
						if((markR.location) && ([self characterAtIndex:markR.location-1] == stopChar))
						{
							// it is a start place holder
							++depth;
						}
						searchRange.length = markR.location;
						goto previousMark;
					}
				}
			}
		}
		searchRange.location = NSMaxRange(markR);
		goto nextMark;
	}
	else
	{
		return NSMakeRange(NSNotFound, 0);
	}
//iTM2_END;
	return NSMakeRange(NSNotFound, 0);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= rangeOfPlaceholderFromIndex:cycle:tabAnchor:
- (NSRange)rangeOfPlaceholderFromIndex:(unsigned)index cycle:(BOOL)cycle tabAnchor:(NSString *)tabAnchor;
/*"Description forthcoming.
Version history: jlaurens AT users.sourceforge.net
- 2.0: 02/15/2006
To Do List: implement some kind of balance range for range
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	// next stop placeholder
	// preceding start placeholder
	// if the index is in an apropriate range, it's okay
	// start from the beginning if necessary
	NSRange stopR = NSMakeRange(NSNotFound,0);
	unsigned length = [self length];
	if(index>length)
	{
		return stopR;
	}
	NSRange searchRange = NSMakeRange(0,0);
	NSRange markR;
	// a TAB anchor?
	if([tabAnchor length])
	{
		searchRange.location = index;
		searchRange.length = length-searchRange.location;
		markR = [self rangeOfString:tabAnchor options:nil range:searchRange];
		if(markR.length)
		{
			return markR;
		}
	}

	unichar startChar = [iTM2TextStartPlaceholder characterAtIndex:[iTM2TextStartPlaceholder length]-1];
	unichar stopChar  = [iTM2TextStopPlaceholder  characterAtIndex:0];

	unsigned idx;
	unsigned floor = 0;

	searchRange.location = MAX(index,2)-2;	
	searchRange.length = length-searchRange.location;
	stopR = [self rangeOfString:iTM2TextStopPlaceholder options:nil range:searchRange];
	if(stopR.length)
	{
		searchRange.location = floor;
		searchRange.length = stopR.location-searchRange.location;
previousMark:
		markR = [self rangeOfString:iTM2TextMarkPlaceholder options:NSBackwardsSearch range:searchRange];
		if(markR.length)
		{
			// is it a start?
			idx = NSMaxRange(markR);// we do have idx < length!
			if([self characterAtIndex:idx]==startChar)
			{
				// it is a start place holder
				return NSMakeRange(markR.location, NSMaxRange(stopR)-markR.location);
			}
			// the first time, it can be a stop
			if(markR.location && ([self characterAtIndex:markR.location-1]==stopChar))
			{
nextStop:
				floor = NSMaxRange(stopR);
				searchRange.location = floor;
				searchRange.length = length-searchRange.location;
				stopR = [self rangeOfString:iTM2TextStopPlaceholder options:nil range:searchRange];
				if(stopR.length)
				{
					searchRange.location = floor;
					searchRange.length = stopR.location-searchRange.location;
morePreviousMark:
					markR = [self rangeOfString:iTM2TextMarkPlaceholder options:NSBackwardsSearch range:searchRange];
					if(markR.length)
					{
						// is it a start?
						idx = NSMaxRange(markR);// we do have idx < length!
						if([self characterAtIndex:idx]==startChar)
						{
							// it is a start place holder
							return NSMakeRange(markR.location, NSMaxRange(stopR)-markR.location);
						}
						// it is neither a start nor a stop place holder
						// most certainly an error
						searchRange.length = markR.location-searchRange.location;
						goto morePreviousMark;
					}
					goto nextStop;
				}
				goto below;
			}
			searchRange.length = markR.location-searchRange.location;
			goto previousMark;
		}
		floor = NSMaxRange(stopR);
		searchRange.location = floor;
		goto nextStop;
	}
below:
	searchRange.length = length-searchRange.location;
	if(!cycle)
	{
		return NSMakeRange(NSNotFound,0);
	}
	searchRange.location = 0;
	searchRange.length = index-searchRange.location;
	// a TAB anchor?
	if([tabAnchor length])
	{
		markR = [self rangeOfString:tabAnchor options:nil range:searchRange];
		if(markR.length)
		{
			return markR;
		}
	}
	searchRange.length = index-searchRange.location;
	stopR = [self rangeOfString:iTM2TextStopPlaceholder options:nil range:searchRange];
	if(stopR.length)
	{
		searchRange.length = stopR.location-searchRange.location;
previousMarkBefore:
		markR = [self rangeOfString:iTM2TextMarkPlaceholder options:NSBackwardsSearch range:searchRange];
		if(markR.length)
		{
			// is it a start?
			idx = NSMaxRange(markR);
			if([self characterAtIndex:idx]==startChar)
			{
				// it is a start place holder
				return NSMakeRange(markR.location, NSMaxRange(stopR)-markR.location);
			}
			if(markR.location && ([self characterAtIndex:markR.location-1]==stopChar))
			{
nextStopBefore:
				searchRange.length = index-searchRange.location;
				stopR = [self rangeOfString:iTM2TextStopPlaceholder options:nil range:searchRange];
				if(stopR.length)
				{
					searchRange.length = stopR.location-searchRange.location;
morePreviousMarkBefore:
					markR = [self rangeOfString:iTM2TextMarkPlaceholder options:NSBackwardsSearch range:searchRange];
					if(markR.length)
					{
						// is it a start?
						idx = NSMaxRange(markR);
						if([self characterAtIndex:idx]==startChar)
						{
							// it is a start place holder
							return NSMakeRange(markR.location, NSMaxRange(stopR)-markR.location);
						}
						// it is neither a start nor a stop place holder
						// most certainly an error
						searchRange.length = markR.location-searchRange.location;
						goto morePreviousMarkBefore;
					}
					searchRange.location = NSMaxRange(stopR);
					goto nextStopBefore;
				}
				goto final;
			}
			// it is neither a start nor a stop place holder
			// most certainly an error
			searchRange.length = markR.location-searchRange.location;
			goto previousMarkBefore;
		}
		searchRange.location = NSMaxRange(stopR);
		goto nextStopBefore;
	}
final:
	// If I reach this point, it means that I have not found any atomic placeholder
	// select the start and stop markers
	searchRange.location = MIN(length,MAX(index,2)-2);
	searchRange.length = length-searchRange.location;
	stopR = [self rangeOfString:iTM2TextStopPlaceholder options:nil range:searchRange];
	if(stopR.length)
	{
		return stopR;
	}
	NSRange startR = NSMakeRange(NSNotFound,0);
	startR = [self rangeOfString:iTM2TextStartPlaceholder options:nil range:searchRange];
	if(startR.length)
	{
		return startR;
	}
	if(!cycle)
	{
		return NSMakeRange(NSNotFound,0);
	}
	searchRange.location = 0;
	searchRange.length = index-searchRange.location;
	stopR = [self rangeOfString:iTM2TextStopPlaceholder options:nil range:searchRange];
	if(stopR.length)
	{
		return stopR;
	}
	startR = [self rangeOfString:iTM2TextStartPlaceholder options:nil range:searchRange];
	if(startR.length)
	{
		return startR;
	}
	return NSMakeRange(NSNotFound,0);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= rangeOfPlaceholderToIndex:cycle:tabAnchor:
- (NSRange)rangeOfPlaceholderToIndex:(unsigned)index cycle:(BOOL)cycle tabAnchor:(NSString *)tabAnchor;
/*"Description forthcoming.
Version history: jlaurens AT users.sourceforge.net
- 2.0: 02/15/2006
To Do List: implement NSBackwardsSearch
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	// next stop placeholder
	// preceding start placeholder
	// if the index is in an apropriate range, it's okay
	// start from the beginning if necessary
	NSRange startR = NSMakeRange(NSNotFound,0);
	unsigned length = [self length];
	if(index>length)
	{
		index = length;
	}
	NSRange searchRange = NSMakeRange(0,index);
	NSRange markR;
	// a TAB anchor?
	if([tabAnchor length])
	{
		markR = [self rangeOfString:tabAnchor options:NSBackwardsSearch range:searchRange];
		if(markR.length)
		{
			return markR;
		}
	}
	
	unichar stopChar  = [iTM2TextStopPlaceholder characterAtIndex:0];
	unichar startChar = [iTM2TextStopPlaceholder characterAtIndex:[iTM2TextStopPlaceholder length]-1];

	unsigned top = length;

	unsigned idx;
	
	searchRange.location = 0;
	searchRange.length = MIN(index,MAX(length,2)-2)+2;
	
	startR = [self rangeOfString:iTM2TextStartPlaceholder options:NSBackwardsSearch range:searchRange];
	if(startR.length)
	{
		searchRange.location = NSMaxRange(startR);
nextMark:
		searchRange.length = top-searchRange.location;
		markR = [self rangeOfString:iTM2TextMarkPlaceholder options:nil range:searchRange];
		if(markR.length)
		{
			// is it a stop?
			if([self characterAtIndex:markR.location-1]==stopChar)
			{
				// it is a stop place holder
				return NSMakeRange(startR.location, NSMaxRange(markR)-startR.location);
			}
			// is it a start?
			idx = NSMaxRange(markR);
			if((idx < length) && ([self characterAtIndex:markR.location]==startChar))
			{
				searchRange.location = 0;
				top = startR.location;
				searchRange.length = top;
previousStart:
				startR = [self rangeOfString:iTM2TextStartPlaceholder options:NSBackwardsSearch range:searchRange];
				if(startR.length)
				{
					searchRange.location = NSMaxRange(startR);
moreNextMark:
					searchRange.length = top-searchRange.location;
					markR = [self rangeOfString:iTM2TextMarkPlaceholder options:nil range:searchRange];
					if(markR.length)
					{
						// is it a stop?
						if([self characterAtIndex:markR.location-1]==stopChar)
						{
							// it is a stop place holder
							return NSMakeRange(startR.location, NSMaxRange(markR)-startR.location);
						}
						// it is neither a start nor a stop place holder
						// most certainly an error
						searchRange.location = NSMaxRange(markR);
						goto moreNextMark;
					}
					top = startR.location;
					searchRange.location = 0;
					searchRange.length = top;
					goto previousStart;
				}
				goto below;
			}
			// it is neither a start nor a stop place holder
			// most certainly an error
			searchRange.location = NSMaxRange(markR);
			goto nextMark;
		}
		top = startR.location;
		searchRange.location = 0;
		searchRange.length = top;
		goto previousStart;
	}
below:
	if(!cycle)
	{
		return NSMakeRange(NSNotFound,0);
	}
	// a TAB anchor?
	if([tabAnchor length])
	{
		searchRange.location = index;
		searchRange.length = length-index;
		markR = [self rangeOfString:tabAnchor options:NSBackwardsSearch range:searchRange];
		if(markR.length)
		{
			return markR;
		}
	}
	top = length;
	unsigned floor = MAX(index,2)-2;
	searchRange.location = floor;
	searchRange.length = top-searchRange.location;
	startR = [self rangeOfString:iTM2TextStartPlaceholder options:NSBackwardsSearch range:searchRange];
	if(startR.length)
	{
		searchRange.location = NSMaxRange(startR);
nextMarkAfter:
		searchRange.length = top-searchRange.location;// we do not want a stop after a different start
		markR = [self rangeOfString:iTM2TextMarkPlaceholder options:nil range:searchRange];
		if(markR.length)
		{
			// is it a stop?
			if(markR.location && ([self characterAtIndex:markR.location-1]==stopChar))
			{
				// it is a stop place holder
				return NSMakeRange(startR.location, NSMaxRange(markR)-startR.location);
			}
			// is is a start
			idx = NSMaxRange(markR);
			if((idx < length) && ([self characterAtIndex:idx]==startChar))
			{
				searchRange.location = floor;
previousStartAfter:
				searchRange.length = top-searchRange.location;
				startR = [self rangeOfString:iTM2TextStartPlaceholder options:NSBackwardsSearch range:searchRange];
				if(startR.length)
				{
					searchRange.location = NSMaxRange(startR);
moreNextMarkAfter:
					searchRange.length = top-searchRange.location;// we do not want a stop after a different start
					markR = [self rangeOfString:iTM2TextMarkPlaceholder options:nil range:searchRange];
					if(markR.length)
					{
						// is it a stop?
						if([self characterAtIndex:markR.location-1]==stopChar)
						{
							// it is a stop place holder
							return NSMakeRange(startR.location, NSMaxRange(markR)-startR.location);
						}
						// it is neither a start nor a stop place holder
						// most certainly an error
						searchRange.location = NSMaxRange(markR);
						goto moreNextMarkAfter;
					}
					top = startR.location;
					searchRange.location = floor;
					goto previousStartAfter;
				}
				goto final;
			}
			// it is neither a start nor a stop place holder
			// most certainly an error
			searchRange.location = NSMaxRange(markR);
			goto nextMarkAfter;
		}
		top = startR.location;
		searchRange.location = floor;
		goto previousStartAfter;
	}
final:
	// If I reach this point, it means that I have not found any atomic placeholder
	// select the start and stop markers
	searchRange.location = 0;	
	searchRange.length = floor;	
	startR = [self rangeOfString:iTM2TextStartPlaceholder options:NSBackwardsSearch range:searchRange];
	if(startR.length)
	{
		return startR;
	}
	NSRange stopR = NSMakeRange(NSNotFound,0);
	stopR = [self rangeOfString:iTM2TextStopPlaceholder options:NSBackwardsSearch range:searchRange];
	if(stopR.length)
	{
		return stopR;
	}
	if(!cycle)
	{
		return NSMakeRange(NSNotFound,0);
	}
	searchRange.location = floor;
	searchRange.length = length-searchRange.location;
	startR = [self rangeOfString:iTM2TextStartPlaceholder options:NSBackwardsSearch range:searchRange];
	if(startR.length)
	{
		return startR;
	}
	stopR = [self rangeOfString:iTM2TextStopPlaceholder options:NSBackwardsSearch range:searchRange];
	if(stopR.length)
	{
		return stopR;
	}
	return NSMakeRange(NSNotFound,0);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= indentationLevelWithNumberOfSpacesPerTab:
- (unsigned)indentationLevelWithNumberOfSpacesPerTab:(unsigned)numberOfSpacesPerTab;
/*"Description forthcoming.
Version history: jlaurens AT users.sourceforge.net
- 2.0: 02/15/2006
To Do List: implement some kind of balance range for range
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(!numberOfSpacesPerTab)
	{
		numberOfSpacesPerTab = 4;
	}
	unsigned idx = 0;
	unsigned top = [self length];
	unsigned result = 0;
	unsigned currentLength = 0;
	while(idx<top)
	{
		unichar theChar = [self characterAtIndex:idx++];
		if(theChar == ' ')
		{
			++currentLength;
		}
		else if(theChar == '\t')
		{
			++result;
			result += (2*currentLength)/numberOfSpacesPerTab;
			currentLength = 0;
		}
		else
		{
			break;
		}
	}
	result += (2*currentLength)/numberOfSpacesPerTab;
//iTM2_END;
	return result;
}
@end
