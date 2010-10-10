/*
//
//  @version Subversion: $Id$ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Mon Jun 10 2002.
//  Copyright (c) 2001 Laurens'Tribune. All rights reserved.
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

#import "iTM2AppleScriptKit.h"
#import "iTM2KeyBindingsKit.h"
#import "iTM2BundleKit.h"
#import "iTM2Runtime.h"
#import "iTM2PathUtilities.h"

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  iTM2AppleScriptLauncher
/*"Description forthcoming."*/
@implementation iTM2AppleScriptLauncher
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  executeAppleScriptAtPath:
+ (IBAction)executeAppleScriptAtPath:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Sat Jan 30 16:25:24 UTC 2010
To Do List:
"*/
{
//START4iTM3;
//LOG4iTM3(@"trying to launch a script %@", sender);
    if ([sender isKindOfClass:[NSString class]])
    {
        NSURL * url = [[NSURL fileURLWithPath:sender] URLByStandardizingPath];
        if (!url.isFileURL || ![DFM fileExistsAtPath:url.path]) {
            url = [[[NSBundle mainBundle] URLsForSupportResource4iTM3:sender withExtension:@"scpt" subdirectory:@"Scripts" domains:NSAllDomainsMask] lastObject];
        }
		NSDictionary * errorInfo = nil;
		NSAppleScript * AS = [[[NSAppleScript alloc] initWithContentsOfURL:url error:&errorInfo] autorelease];
		if ([AS executeAndReturnError:&errorInfo]) {
			return;
		} else if (AS) {
			LOG4iTM3(@"The script could not execute due to: %@", errorInfo);
		} else {
			LOG4iTM3(@"The script could not be created due to: %@", errorInfo);
		}
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  executeAppleScript:
+ (IBAction)executeAppleScript:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.1: 06/10/2002
To Do List:
"*/
{
//START4iTM3;
#if 1
//NSLog(@"trying to launch a script %@", sender);
    if ([sender isKindOfClass:[NSString class]])
    {
        NSAppleScript * AS = [[[NSAppleScript alloc] initWithSource:sender] autorelease];
		NSDictionary * errorInfo = nil;
		if ([AS executeAndReturnError:&errorInfo])
		{
			return;
		}
		else if (AS)
		{
			LOG4iTM3(@"The script could not execute due to: %@", errorInfo);
		}
		else
		{
			LOG4iTM3(@"The script could not be created due to: %@", errorInfo);
		}
//NSLog(@"THIS IS DONE OK");
		return;
    }
#endif
    LOG4iTM3(@"NSString expected, got %@", sender);
    iTM2Beep();
//LOG4iTM3(@"THIS IS DONE NOT OK");
    return;
}
@end

@implementation iTM2KeyBindingsManager(Scripting)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  executeAppleScriptAtPath:
- (IBAction)executeAppleScriptAtPath:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{
//START4iTM3;
    [iTM2AppleScriptLauncher executeAppleScriptAtPath:sender];
    [self escapeCurrentKeyBindingsIfAllowed];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  executeAppleScript:
- (IBAction)executeAppleScript:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{
//START4iTM3;
    [iTM2AppleScriptLauncher executeAppleScript:sender];
    [self escapeCurrentKeyBindingsIfAllowed];
    return;
}
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  iTM2AppleScriptKit

@interface NSScriptSuiteRegistry(PRIVATE)
- (NSDictionary *)dictionaryForLoadingSuiteWithDictionary:(NSDictionary *)dictionary fromBundle:(NSBundle *)bundle;
@end
@implementation NSScriptSuiteRegistry(iTeXMac2_)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  dictionaryForloadingSuiteWithDictionary:fromBundle:
- (NSDictionary *)dictionaryForLoadingSuiteWithDictionary:(NSDictionary *)dictionary fromBundle:(NSBundle *)bundle;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Jan 11 11:42:37 GMT 2005
To Do List:
"*/
{
//START4iTM3;
    NSString * suiteName = [dictionary objectForKey:@"Name"];
    NSDictionary * Classes = [dictionary objectForKey:@"Classes"];
    NSMutableDictionary * newClasses = [NSMutableDictionary dictionaryWithDictionary:Classes];
    NSEnumerator * E = Classes.keyEnumerator;
    NSString * K;
    while(K = E.nextObject)
    {
        id d = [Classes objectForKey:K];
        NSString * Superclass = [d objectForKey:@"Superclass"];
        if ([Superclass isEqual:@"Category"])
        {
            NSString * classCodeObj = [d objectForKey:@"AppleEventCode"];
            if (classCodeObj.length > 3)
            {
                FourCharCode * classCode = (FourCharCode *) [classCodeObj UTF8String];
                NSScriptClassDescription * SCD = [self classDescriptionWithAppleEventCode:* classCode];
                if (SCD)
                {
                    NSString * classSuiteName = [SCD suiteName];
                    if (![suiteName isEqual:classSuiteName])
                    {
                        NSString * newSuperclass = [NSString stringWithFormat:@"%@.%@", classSuiteName, [SCD className]];
                        NSLog(@"New Superclass %@ for class: %@", newSuperclass, K);
                        d = [[d mutableCopy] autorelease];
                        [d setObject:newSuperclass forKey:@"Superclass"];
                        [newClasses setObject:d forKey:K];
                    }
					else
					{
						LOG4iTM3(@"..........  ERROR: You cannot add an AppleScript category to a class of the same suite %@.", d);
						return [NSDictionary dictionary];
					}
                }
				else
				{
					// LOG4iTM3(@"..........  No class with code %@, unimplemented category %@", classCodeObj, d);
					return nil;
				}
            }
			else
			{
				LOG4iTM3(@"..........  ERROR: bad dictionary %@", d);
				return [NSDictionary dictionary];
			}
        }
    }
    dictionary = [[dictionary mutableCopy] autorelease];
    [(NSMutableDictionary *)dictionary setObject:newClasses forKey:@"Classes"];
    return dictionary;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  SWZ_iTM2MiscKit_loadSuiteWithDictionary:fromBundle:
- (void)SWZ_iTM2MiscKit_loadSuiteWithDictionary:(NSDictionary *)dictionary fromBundle:(NSBundle *)bundle;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Jan 11 11:42:37 GMT 2005
To Do List:
"*/
{
//START4iTM3;
	static NSMutableDictionary * dictionarySuites = nil;
	if (!dictionarySuites)
		dictionarySuites = [[NSMutableDictionary dictionary] retain];
	NSDictionary * D = [self dictionaryForLoadingSuiteWithDictionary:dictionary fromBundle:bundle];
	if (D)
	{
		[self SWZ_iTM2MiscKit_loadSuiteWithDictionary:D fromBundle:bundle];
		// a new dictionary has been loaded, may be it now possible to load another dictionary suite
		NSEnumerator * E = dictionarySuites.keyEnumerator;
		while(D = E.nextObject)
		{
			NSBundle * B = [dictionarySuites objectForKey:D];
			if (D = [self dictionaryForLoadingSuiteWithDictionary:D fromBundle:B])
			{
				[dictionarySuites removeObjectForKey:D];
				[self SWZ_iTM2MiscKit_loadSuiteWithDictionary:D fromBundle:B];
				if (iTM2DebugEnabled)
				{
					LOG4iTM3(@"INFO: Now registering script suite named: %@", [D objectForKey:@"Name"]);
				}
			}
		}
	}
	else
	{
		// it is not possible to load the dictionary suite yet, maybe other dictionaries will be loaded later
		[dictionarySuites setObject:bundle forKey:dictionary];
		LOG4iTM3(@"WARNING: Post poned registration of script suite named: %@", [dictionary objectForKey:@"Name"]);
	}
    return;
}
@end

#import "iTM2StringFormatKit.h"

@implementation iTM2TextDocument(AppleScripting)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  endOfLine
- (NSUInteger)endOfLine;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	switch([self EOL])
	{
		case iTM2UnchangedEOL: return 'UNCH';
		case iTM2UNIXEOL: return 'LF  ';
		case iTM2MacintoshEOL: return 'CR  ';
		case iTM2WindowsEOL: return 'CRLF';
		default: return 'UNKN';
	}
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setEndOfLine:
- (void)setEndOfLine:(NSUInteger)argument;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	switch(argument)
	{
		case 'UNCH': [self setEOL:iTM2UnchangedEOL]; return;
		case 'LF  ': [self setEOL:iTM2UNIXEOL]; return;
		case 'CR  ': [self setEOL:iTM2MacintoshEOL]; return;
		case 'CRLF': [self setEOL:iTM2WindowsEOL]; return;
		default:     [self setEOL:iTM2UnknownEOL]; return;
	}
}
@end

@implementation iTM2MainInstaller(NSScriptSuiteRegistry)

+ (void)prepareNSScriptSuiteRegistryCompleteInstallation;
{
    if ([SUD boolForKey:@"iTM2DontSwizzleScriptSuiteRegistry"]) {
		MILESTONE4iTM3((@"NSScriptSuiteRegistry(iTeXMac2_)"),(@"AppleScripting extension has been disabled, if this was not wanted: issue:\nterminal%% defaults remove comp.text.TeX.iTeXMac2 iTM2DontSwizzleScriptSuiteRegistry"));
    } else if ([NSScriptSuiteRegistry swizzleInstanceMethodSelector4iTM3:@selector(SWZ_iTM2MiscKit_loadSuiteWithDictionary:fromBundle:) error:NULL]) {
		MILESTONE4iTM3((@"NSScriptSuiteRegistry(iTeXMac2_)"),(@"AppleScripting extension available. If this causes any kind of harm, please issue\nterminal%% defaults write comp.text.TeX.iTeXMac2 iTM2DontSwizzleScriptSuiteRegistry '1'"));
	}
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  dictionaryForloadingSuiteWithDictionary:fromBundle:

@end

