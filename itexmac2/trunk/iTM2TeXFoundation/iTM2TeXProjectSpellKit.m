/*
//  iTeXMac2 1.4
//
//  @version Subversion: $Id$ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Wed Sep 15 21:07:40 GMT 2004.
//  Copyright © 2004 Laurens'Tribune. All rights reserved.
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
//  To Do List: (format "- proposition(percentage actually done)")
*/

#ifdef __iTM2_NO_XTD_SPELL__
#warning *** NO TeX PROJECT XTD SPELL
#else
#endif
#if 1
#import <iTM2TeXFoundation/iTM2TeXProjectDocumentKit.h>
#import <iTM2TeXFoundation/iTM2TeXProjectSpellKit.h>
#import <iTM2Foundation/iTM2BundleKit.h>

NSString * const TWSSpellingFileKey = @"spelling";
NSString * const TWSSpellComponent = @"spell";

@implementation iTM2SpellContextController(TeX)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  load
+ (void)load;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
	iTM2_INIT_POOL;
	iTM2RedirectNSLogOutput();
//iTM2_START;
	[iTM2SpellContextController iTM2_swizzleInstanceMethodSelector:@selector(SWZ_iTM2TeX_spellContextModeForText:)];
//iTM2_END;
	iTM2_RELEASE_POOL;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  SWZ_iTM2TeX_spellContextModeForText:
- (NSString *)SWZ_iTM2TeX_spellContextModeForText:(NSText *) text;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//    NSString * mode = [[self project] spellingModeForFileKey:[[self project] fileKeyForURL:[[[[text window] windowController] document] fileName]]];
	NSString * mode = nil;
    if(![self spellContextForMode:mode])
    {
        mode = [self SWZ_iTM2TeX_spellContextModeForText:text];
    }
//iTM2_END;
    return mode;
}
#if 0
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  setSpellContextMode:forText:
- (void)setSpellContextMode:(NSString *) mode forText:(id) text;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[super setSpellContextMode:mode forText:text];
//    [[self project] setSpellingMode:mode forFileKey:[[self project] fileKeyForSubdocument:[[[text window] windowController] document]]];
//iTM2_END;
    return;
}
#endif
@end

@implementation iTM2SpellContextController(TeXProjectSpellKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  project
- (id)project;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return [metaGETTER nonretainedObjectValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  setProject:
- (void)setProject:(id) project;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	metaSETTER((project? [NSValue valueWithNonretainedObject:project]:nil));
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  writeToDirectory:
- (BOOL)writeToDirectory:(NSString *) directoryName;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    // Save the spelling contexts
    // create the "Spell" directory first
    directoryName = [directoryName stringByAppendingPathComponent:TWSSpellComponent];
    BOOL isDirectory;
    if(![DFM fileExistsAtPath:directoryName isDirectory:&isDirectory])
    {
        if(![DFM createDirectoryAtPath:directoryName attributes:nil])
        {
            iTM2_LOG(@"Could create a directory at path:\n%@\nDon't know where to save the spelling contexts", directoryName);
//iTM2_END;
            return NO;
        }
     }
    else if(!isDirectory)
    {
        // links are not supported
        if(![DFM removeFileAtPath:directoryName handler:nil])
        {
            iTM2_LOG(@"Could remove whatever exists at path:\n%@\nDon't know where to save the spelling contexts", directoryName);
//iTM2_END;
            return NO;
        }
        if(![DFM createDirectoryAtPath:directoryName attributes:nil])
        {
            iTM2_LOG(@"Could create a directory at path:\n%@\nDon't know where to save the spelling contexts", directoryName);
//iTM2_END;
            return NO;
        }
    }
    NSEnumerator * E = [[self spellContexts] keyEnumerator];
    NSString * mode;
    BOOL result = YES;
    while(mode = [E nextObject])
    {
		NSString * component = [mode stringByAppendingPathExtension:TWSSpellExtension];
		NSString * path = [directoryName stringByAppendingPathComponent:component];
		NSURL * url = [NSURL fileURLWithPath:path];
		NSError * error = nil;
        if(![[self spellContextForMode:mode] writeToURL:url error:&error])
		{
			if(iTM2DebugEnabled && (error!=nil))
				[SDC presentError:error];
            result = NO;
		}
    }
    // then removes the spelling context files that are not in the actual list
    E = [[DFM directoryContentsAtPath:directoryName] objectEnumerator];
    while (mode = [E nextObject])
        if([[mode pathExtension] iTM2_pathIsEqual:TWSSpellExtension]
            && ![[[self spellContexts] allKeys] containsObject:[mode stringByDeletingPathExtension]])
		[DFM removeFileAtPath:[directoryName stringByAppendingPathComponent:mode] handler:nil];
//iTM2_END;
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  readFromDirectory:
- (BOOL)readFromDirectory:(NSString *) directoryName;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    directoryName = [directoryName stringByAppendingPathComponent:TWSSpellComponent];
    NSMutableDictionary * MD = [NSMutableDictionary dictionaryWithDictionary:[self spellContexts]];
    NSString * file;
    NSEnumerator * E = [[DFM directoryContentsAtPath:directoryName] objectEnumerator];
    BOOL result = YES;
    while (file = [E nextObject])
    {
		NSString * extension = [file pathExtension];
        if([extension iTM2_pathIsEqual:TWSSpellExtension])
        {
            iTM2SpellContext * SC = [[[iTM2SpellContext alloc] init] autorelease];
			NSString * path = [directoryName stringByAppendingPathComponent:file];
			NSURL * url = [NSURL fileURLWithPath:path];
			NSError * error = nil;
            if([SC readFromURL:url error:&error])
			{
				file = [file stringByDeletingPathExtension];
                [MD setObject:SC forKey:file];
			}
            else
			{
				if(iTM2DebugEnabled && (error!=nil))
					[SDC presentError:error];
                result = NO;
			}
        }
    }
    if(result)
    {
        [self setSpellContexts:MD];
    }
//iTM2_END;
    return result;
}
@end

@interface iTM2ProjectDocument(PRIVATE_TeXProjectSpellKit)
- (void)spellKitCompleteDidReadFromFile:(NSString *) fileName ofType:(NSString *) type;
@end

@implementation iTM2TeXProjectDocument(ProjectSpellKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  setSpellContextController
- (void)setSpellContextController:(id) controller;
/*"Asks the document or the owner.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[metaGETTER setProject:nil];
	metaSETTER(controller);
	[metaGETTER setProject:self];
    return;
}
#pragma mark =-=-=-=-=-  TWS Ignored Words
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  spellingModeForFileKey:
- (NSString *)spellingModeForFileKey:(NSString *) fileKey;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [self propertyValueForKey:TWSSpellingFileKey fileKey:fileKey contextDomain:iTM2ContextAllDomainsMask];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setSpellingMode:forFileKey:
- (void)setSpellingMode:(NSString *) spellingMode forFileKey:(NSString *) fileKey;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self setPropertyValue:spellingMode forKey:TWSSpellingFileKey fileKey:fileKey contextDomain:iTM2ContextAllDomainsMask&~iTM2ContextProjectMask];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  spellKitCompleteDidReadFromFile:ofType:
- (void)spellKitCompleteDidReadFromFile:(NSString *) fileName ofType:(NSString *) type;
/*"Asks the document or the owner.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[super spellKitCompleteDidReadFromFile:fileName ofType:type];
	[[self spellContextController] readFromDirectory:fileName];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  spellKitMetaCompleteWriteToURL:ofType:error:
- (BOOL)spellKitMetaCompleteWriteToURL:(NSURL *)fileURL ofType:(NSString *)type error:(NSError**)outErrorPtr;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [[self spellContextController] writeToDirectory:[fileURL path]];
}
@end
#endif
