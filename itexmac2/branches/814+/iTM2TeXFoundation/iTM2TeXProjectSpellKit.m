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

@implementation iTM2MainInstaller(TeXProjectSpellKit)
- (void)prepareSpellContextControllerCompleteInstallation4iTM3;
{
	if([iTM2SpellContextController swizzleInstanceMethodSelector4iTM3:@selector(SWZ_iTM2TeX_spellContextModeForText:) error:NULL])
	{
		MILESTONE4iTM3((@"iTM2SpellContextController(TeX)"),(@"The spell context does not take tex projects into account."));
	}
}

@end

@implementation iTM2SpellContextController(TeX)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  SWZ_iTM2TeX_spellContextModeForText:
- (NSString *)SWZ_iTM2TeX_spellContextModeForText:(NSText *) text;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//    NSString * mode = [self.project spellingModeForFileKey:[self.project fileKeyForURL:[[[text.window windowController] document] fileName]]];
	NSString * mode = nil;
    if(![self spellContextForMode:mode])
    {
        mode = [self SWZ_iTM2TeX_spellContextModeForText:text];
    }
//END4iTM3;
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[super setSpellContextMode:mode forText:text];
//    [self.project setSpellingMode:mode forFileKey:[self.project fileKeyForSubdocument:[[text.window windowController] document]]];
//END4iTM3;
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
#warning MIGRATION: nonretainedObjectValue
    return [metaGETTER nonretainedObjectValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  setProject:
- (void)setProject:(id) project;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	metaSETTER((project? [NSValue valueWithNonretainedObject:project]:nil));
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  writeToDirectory:
- (BOOL)writeToDirectory:(NSString *) directoryName;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    // Save the spelling contexts
    // create the "Spell" directory first
    directoryName = [directoryName stringByAppendingPathComponent:TWSSpellComponent];
    BOOL isDirectory;
    if(![DFM fileExistsAtPath:directoryName isDirectory:&isDirectory])
    {
        if(![DFM createDirectoryAtPath:directoryName withIntermediateDirectories:YES attributes:nil error:NULL])
        {
            LOG4iTM3(@"Could create a directory at path:\n%@\nDon't know where to save the spelling contexts", directoryName);
//END4iTM3;
            return NO;
        }
     }
    else if(!isDirectory)
    {
        // links are not supported
        if(![DFM removeItemAtPath:directoryName error:NULL])
        {
            LOG4iTM3(@"Could remove whatever exists at path:\n%@\nDon't know where to save the spelling contexts", directoryName);
//END4iTM3;
            return NO;
        }
        if(![DFM createDirectoryAtPath:directoryName withIntermediateDirectories:YES attributes:nil error:NULL])
        {
            LOG4iTM3(@"Could create a directory at path:\n%@\nDon't know where to save the spelling contexts", directoryName);
//END4iTM3;
            return NO;
        }
    }
    NSString * mode;
    BOOL result = YES;
    for(mode in [self.spellContexts keyEnumerator])
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
    for (mode in [DFM contentsOfDirectoryAtPath:directoryName error:NULL])
        if([[mode pathExtension] pathIsEqual4iTM3:TWSSpellExtension]
            && ![[self.spellContexts allKeys] containsObject:mode.stringByDeletingPathExtension])
		[DFM removeItemAtPath:[directoryName stringByAppendingPathComponent:mode] error:NULL];
//END4iTM3;
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  readFromDirectory:
- (BOOL)readFromDirectory:(NSString *) directoryName;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    directoryName = [directoryName stringByAppendingPathComponent:TWSSpellComponent];
    NSMutableDictionary * MD = [NSMutableDictionary dictionaryWithDictionary:self.spellContexts];
    BOOL result = YES;
    for(NSString * file in [DFM contentsOfDirectoryAtPath:directoryName error:NULL])
    {
		NSString * extension = [file pathExtension];
        if([extension pathIsEqual4iTM3:TWSSpellExtension])
        {
            iTM2SpellContext * SC = [[[iTM2SpellContext alloc] init] autorelease];
			NSString * path = [directoryName stringByAppendingPathComponent:file];
			NSURL * url = [NSURL fileURLWithPath:path];
			NSError * error = nil;
            if([SC readFromURL:url error:&error])
			{
				file = file.stringByDeletingPathExtension;
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
//END4iTM3;
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [self propertyValueForKey:TWSSpellingFileKey fileKey:fileKey contextDomain:iTM2ContextAllDomainsMask];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setSpellingMode:forFileKey:
- (void)setSpellingMode:(NSString *) spellingMode forFileKey:(NSString *) fileKey;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[super spellKitCompleteDidReadFromFile:fileName ofType:type];
	[self.spellContextController readFromDirectory:fileName];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  spellKitCompleteWriteMetaToURL4iTM3:ofType:error:
- (BOOL)spellKitCompleteWriteMetaToURL4iTM3:(NSURL *)fileURL ofType:(NSString *)type error:(NSError**)RORef;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [self.spellContextController writeToDirectory:fileURL.path];
}
@end
#endif
