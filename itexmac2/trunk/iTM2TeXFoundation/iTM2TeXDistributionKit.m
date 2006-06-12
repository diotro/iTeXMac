/*
//  iTM2TeXDistributionKit.m
//  iTeXMac2
//
//  @version Subversion: $Id$ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Fri Sep 23 23:02:08 GMT 2005.
//  Copyright © 2005 Laurens'Tribune. All rights reserved.
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

#import <iTM2TeXFoundation/iTM2TeXDistributionKit.h>
#import <iTM2TeXFoundation/iTM2TeXProjectFrontendKit.h>
#import <iTM2TeXFoundation/iTM2TeXProjectCommandKit.h>

NSString * const iTM2DistributionTeXMF = @"iTM2DistributionTeXMF";
NSString * const iTM2DistributionTeXMFBinaries = @"iTM2DistributionTeXMFBinaries";
NSString * const iTM2DistributionGhostScriptBinaries = @"iTM2DistributionGhostScriptBinaries";

NSString * const iTM2DistributionDefault = @"default";
NSString * const iTM2DistributionBuiltIn = @"built-in";// Not yet used
NSString * const iTM2DistributiongwTeX = @"gwTeX";// from iinstaller
NSString * const iTM2DistributionFink = @"fink";
NSString * const iTM2DistributionTeXLive = @"TeX Live";
NSString * const iTM2DistributionTeXLiveCD = @"TeX Live CD";
NSString * const iTM2DistributiongwTeXIntel = @"gwTeX(Intel)";// from iinstaller
NSString * const iTM2DistributionFinkIntel = @"fink(Intel)";
NSString * const iTM2DistributionTeXLiveIntel = @"TeX Live(Intel)";
NSString * const iTM2DistributionTeXLiveCDIntel = @"TeX Live CD(Intel)";
NSString * const iTM2DistributionOther = @"other";
NSString * const iTM2DistributionCustom = @"custom";

NSString * const iTM2DistributionDomainTeXMF = @"iTM2DistributionDomainTeXMF";
NSString * const iTM2DistributionDomainTeXMFBinaries = @"iTM2DistributionDomainTeXMFBinaries";
NSString * const iTM2DistributionDomainGhostScriptBinaries = @"iTM2DistributionDomainGhostScriptBinaries";

// those should be deprecated because I can retrieve those paths from the TeXMF tree
NSString * const iTM2DistributionDomainTeXMFDocumentation = @"iTM2DistributionDomainTeXMFDocumentation";
NSString * const iTM2DistributionDomainTeXMFHelp = @"iTM2DistributionDomainTeXMFHelp";
NSString * const iTM2DistributionDomainTeXMFFAQs = @"iTM2DistributionDomainTeXMFFAQs";

NSString * const iTM2DistributionsComponent = @"PATHs";
NSString * const iTM2DistributionSDictionaryKey = @"PATHs dictionary";

@implementation iTM2MainInstaller(iTM2TeXProjectTaskKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-==  load;
+ (void) load;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To do list:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[iTM2MileStone registerMileStone: @"The PATHs.plist is missing" forKey: @"PATHs and TeX Distributions"];
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-==  iTM2TeXProjectTaskKitCompleteInstallation;
+ (void) iTM2TeXProjectTaskKitCompleteInstallation;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To do list:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id distribution = [NSBundle isI386]? iTM2DistributiongwTeXIntel: iTM2DistributiongwTeX;
    [SUD registerDefaults: [NSDictionary dictionaryWithObjectsAndKeys:
					distribution, iTM2DistributionTeXMF,
					distribution, iTM2DistributionTeXMFBinaries,
					distribution, iTM2DistributionGhostScriptBinaries,
                                    nil]];
#ifdef __iTM2_BUG_TRACKING__
	#warning *** BUG TRACKING
#else
	id _iTM2PathsDictionary = [NSMutableDictionary dictionary];
	NSEnumerator * E = [[[NSBundle mainBundle]
		allPathsForResource: iTM2DistributionsComponent ofType: @"plist" inDirectory: nil] objectEnumerator];
    NSString * path;
    while(path = [E nextObject])
    {
        NSDictionary * D = [NSDictionary dictionaryWithContentsOfFile: path];
        if([D count] && ![[D objectForKey: @"isa"] isEqual: iTM2DistributionSDictionaryKey])
            [_iTM2PathsDictionary addEntriesFromDictionary: D];
		else if(iTM2DebugEnabled)
		{
			iTM2_LOG(@"Bad file or dictionary at path", path);
		}
    }
	[SUD registerDefaults: _iTM2PathsDictionary];
	if(iTM2DebugEnabled>100)
	{
		iTM2_LOG(@"_iTM2PathsDictionary is: %@", _iTM2PathsDictionary);
	}
	// then I make some diagnostic... to be sure that the chosen distribution is available
	BOOL distributionWasNotCorrect = NO;
	BOOL distributionIsStillNotCorrect = NO;
	path = [iTM2TeXProjectDocument defaultTeXMFPath];
	if([DFM fileExistsAtPath: path])
		goto testTeXMFBinaries;// that's OK
	distributionWasNotCorrect = YES;
	[SUD setObject: iTM2DistributionBuiltIn forKey: iTM2DistributionTeXMF];
	path = [iTM2TeXProjectDocument defaultTeXMFPath];
	if([DFM fileExistsAtPath: path])
		goto testTeXMFBinaries;// that's OK
	[SUD setObject: iTM2DistributiongwTeX forKey: iTM2DistributionTeXMF];
	path = [iTM2TeXProjectDocument defaultTeXMFPath];
	if([DFM fileExistsAtPath: path])
		goto testTeXMFBinaries;// that's OK
	[SUD setObject: iTM2DistributionFink forKey: iTM2DistributionTeXMF];
	path = [iTM2TeXProjectDocument defaultTeXMFPath];
	if([DFM fileExistsAtPath: path])
		goto testTeXMFBinaries;// that's OK
	[SUD setObject: iTM2DistributionTeXLive forKey: iTM2DistributionTeXMF];
	path = [iTM2TeXProjectDocument defaultTeXMFPath];
	if([DFM fileExistsAtPath: path])
		goto testTeXMFBinaries;// that's OK
	[SUD setObject: iTM2DistributionTeXLiveCD forKey: iTM2DistributionTeXMF];
	path = [iTM2TeXProjectDocument defaultTeXMFPath];
	if([DFM fileExistsAtPath: path])
		goto testTeXMFBinaries;// that's OK
	[SUD setObject: iTM2DistributionCustom forKey: iTM2DistributionTeXMF];
	path = [iTM2TeXProjectDocument defaultTeXMFPath];
	if([DFM fileExistsAtPath: path])
		goto testTeXMFBinaries;// that's OK
	// I have to inform the user that his configuration is not correct...
	distributionIsStillNotCorrect = YES;
testTeXMFBinaries:
	path = [iTM2TeXProjectDocument defaultTeXMFBinariesPath];
	if([DFM fileExistsAtPath: path])
		goto testGhostScriptBinaries;// that's OK
	distributionWasNotCorrect = YES;
	[SUD setObject: iTM2DistributionBuiltIn forKey: iTM2DistributionTeXMFBinaries];
	path = [iTM2TeXProjectDocument defaultTeXMFBinariesPath];
	if([DFM fileExistsAtPath: path])
		goto testGhostScriptBinaries;// that's OK
	if([NSBundle isI386])
	{
		[SUD setObject: iTM2DistributiongwTeXIntel forKey: iTM2DistributionTeXMFBinaries];
		path = [iTM2TeXProjectDocument defaultTeXMFBinariesPath];
		if([DFM fileExistsAtPath: path])
			goto testGhostScriptBinaries;// that's OK
		[SUD setObject: iTM2DistributionTeXLiveIntel forKey: iTM2DistributionTeXMFBinaries];
		path = [iTM2TeXProjectDocument defaultTeXMFBinariesPath];
		if([DFM fileExistsAtPath: path])
			goto testGhostScriptBinaries;// that's OK
		[SUD setObject: iTM2DistributionTeXLiveCDIntel forKey: iTM2DistributionTeXMFBinaries];
	}
	[SUD setObject: iTM2DistributiongwTeX forKey: iTM2DistributionTeXMFBinaries];
	path = [iTM2TeXProjectDocument defaultTeXMFBinariesPath];
	if([DFM fileExistsAtPath: path])
		goto testGhostScriptBinaries;// that's OK
	[SUD setObject: iTM2DistributionFink forKey: iTM2DistributionTeXMFBinaries];
	path = [iTM2TeXProjectDocument defaultTeXMFBinariesPath];
	if([DFM fileExistsAtPath: path])
		goto testGhostScriptBinaries;// that's OK
	[SUD setObject: iTM2DistributionTeXLive forKey: iTM2DistributionTeXMFBinaries];
	path = [iTM2TeXProjectDocument defaultTeXMFBinariesPath];
	if([DFM fileExistsAtPath: path])
		goto testGhostScriptBinaries;// that's OK
	[SUD setObject: iTM2DistributionTeXLiveCD forKey: iTM2DistributionTeXMFBinaries];
	path = [iTM2TeXProjectDocument defaultTeXMFBinariesPath];
	if([DFM fileExistsAtPath: path])
		goto testGhostScriptBinaries;// that's OK
	[SUD setObject: iTM2DistributionCustom forKey: iTM2DistributionTeXMFBinaries];
	path = [iTM2TeXProjectDocument defaultTeXMFBinariesPath];
	if([DFM fileExistsAtPath: path])
		goto testGhostScriptBinaries;// that's OK
	// I have to inform the user that his configuration is not correct...
	distributionIsStillNotCorrect = YES;
testGhostScriptBinaries:
	path = [iTM2TeXProjectDocument defaultGhostScriptBinariesPath];
	if([DFM fileExistsAtPath: path])
		goto conclusion;// that's OK
	distributionWasNotCorrect = YES;
	[SUD setObject: iTM2DistributionBuiltIn forKey: iTM2DistributionGhostScriptBinaries];
	path = [iTM2TeXProjectDocument defaultGhostScriptBinariesPath];
	if([DFM fileExistsAtPath: path])
		goto conclusion;// that's OK
	if([NSBundle isI386])
	{
		[SUD setObject: iTM2DistributiongwTeXIntel forKey: iTM2DistributionGhostScriptBinaries];
		path = [iTM2TeXProjectDocument defaultGhostScriptBinariesPath];
		if([DFM fileExistsAtPath: path])
			goto conclusion;// that's OK
		[SUD setObject: iTM2DistributionTeXLiveIntel forKey: iTM2DistributionGhostScriptBinaries];
		path = [iTM2TeXProjectDocument defaultGhostScriptBinariesPath];
		if([DFM fileExistsAtPath: path])
			goto conclusion;// that's OK
		[SUD setObject: iTM2DistributionTeXLiveCDIntel forKey: iTM2DistributionGhostScriptBinaries];
		path = [iTM2TeXProjectDocument defaultGhostScriptBinariesPath];
		if([DFM fileExistsAtPath: path])
			goto conclusion;// that's OK
	}
	[SUD setObject: iTM2DistributiongwTeX forKey: iTM2DistributionGhostScriptBinaries];
	path = [iTM2TeXProjectDocument defaultGhostScriptBinariesPath];
	if([DFM fileExistsAtPath: path])
		goto conclusion;// that's OK
	[SUD setObject: iTM2DistributionFink forKey: iTM2DistributionGhostScriptBinaries];
	path = [iTM2TeXProjectDocument defaultGhostScriptBinariesPath];
	if([DFM fileExistsAtPath: path])
		goto conclusion;// that's OK
	[SUD setObject: iTM2DistributionTeXLive forKey: iTM2DistributionGhostScriptBinaries];
	path = [iTM2TeXProjectDocument defaultGhostScriptBinariesPath];
	if([DFM fileExistsAtPath: path])
		goto conclusion;// that's OK
	[SUD setObject: iTM2DistributionTeXLiveCD forKey: iTM2DistributionGhostScriptBinaries];
	path = [iTM2TeXProjectDocument defaultGhostScriptBinariesPath];
	if([DFM fileExistsAtPath: path])
		goto conclusion;// that's OK
	[SUD setObject: iTM2DistributionCustom forKey: iTM2DistributionGhostScriptBinaries];
	path = [iTM2TeXProjectDocument defaultGhostScriptBinariesPath];
	if([DFM fileExistsAtPath: path])
		goto conclusion;// that's OK
	// I have to inform the user that his configuration is not correct...
	distributionIsStillNotCorrect = YES;
conclusion:
	if(distributionIsStillNotCorrect)
		[iTM2TeXProjectDocument performSelector: @selector(notifyDefaultDistributionUnfixedError:) withObject: nil afterDelay:0.01];
	else if(distributionWasNotCorrect)
		[iTM2TeXProjectDocument performSelector: @selector(notifyDefaultDistributionFixedWarning:) withObject: nil afterDelay:0.01];
	[iTM2MileStone putMileStoneForKey: @"PATHs and TeX Distributions"];
#endif
//iTM2_END;
    return;
}
@end

NSString * const iTM2DistributionEnvironmentKey = @"TeXDistribution";
#define iVarDistributionEnvironment modelValueForKey: iTM2DistributionEnvironmentKey ofType: iTM2ProjectFrontendType

NSString * const iTM2DistributionUseOutputDirectoryKey = @"iTM2DistributionUseTEXMFOUTPUT";
NSString * const iTM2DistributionOutputDirectoryKey = @"iTM2DistributionTEXMFOUTPUT";
NSString * const iTM2DistributionUsePATHPrefixKey = @"iTM2DistributionUsePATHPrefix";
NSString * const iTM2DistributionPATHPrefixKey = @"iTM2DistributionPATHPrefix";
NSString * const iTM2DistributionUsePATHSuffixKey = @"iTM2DistributionUsePATHSuffix";
NSString * const iTM2DistributionPATHSuffixKey = @"iTM2DistributionPATHSuffix";

@implementation iTM2TeXProjectDocument(TeXDistributionKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  TeXDistributionFixImplementation
- (void) TeXDistributionFixImplementation;
/*"Description forthcoming. Automatically called.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_LOG(@"IMPLEMENTATION is: %@", IMPLEMENTATION);
	id O;
	#define CREATE(KEY)\
	O = [IMPLEMENTATION modelValueForKey: KEY ofType: iTM2ProjectFrontendType];\
	if([O isKindOfClass: [NSDictionary class]])\
		[IMPLEMENTATION takeModelValue: [NSMutableDictionary dictionaryWithDictionary: O] forKey: KEY ofType: iTM2ProjectFrontendType];\
	else\
		[IMPLEMENTATION takeModelValue: [NSMutableDictionary dictionary] forKey: KEY ofType: iTM2ProjectFrontendType];
	CREATE(iTM2DistributionEnvironmentKey);
	#undef CREATE
//iTM2_LOG(@"[self implementation] is: %@", [self implementation]);
//iTM2_LOG(@"[[self implementation] iVarDistributionEnvironment] is: %@", [[self implementation] iVarDistributionEnvironment]);
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  TeXDistributionCompleteDidReadFromFile:ofType:
- (void) TeXDistributionCompleteDidReadFromFile: (NSString *) fileName ofType: (NSString *) type;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self TeXDistributionFixImplementation];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  commonCommandOutputDirectory
- (NSString *) commonCommandOutputDirectory;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [[IMPLEMENTATION iVarDistributionEnvironment] objectForKey: iTM2DistributionUseOutputDirectoryKey]? 
	([[IMPLEMENTATION iVarDistributionEnvironment] objectForKey: iTM2DistributionOutputDirectoryKey]?: @""):
		([[self fileName] stringByAppendingPathComponent: [[self relativeFileNameForKey: [self masterFileKey]] stringByDeletingLastPathComponent]]?: @"");
}
#pragma mark =-=-=-=-=-=-  DISTRIBUTIONS
#define DISTRIBUTION(getter, setter)\
- (NSString *) getter;\
{\
	NSString * result = [[[self implementation] iVarDistributionEnvironment] objectForKey: iTM2KeyFromSelector(_cmd)];\
	return [result length]? result: iTM2DistributionDefault;\
}\
- (void) setter: (NSString *) argument;\
{\
	if(argument)\
		[[[self implementation] iVarDistributionEnvironment] setObject: argument forKey: iTM2KeyFromSelector(_cmd)];\
	else\
		[[[self implementation] iVarDistributionEnvironment] removeObjectForKey: iTM2KeyFromSelector(_cmd)];\
	return;\
}
DISTRIBUTION(TeXMFDistribution, setTeXMFDistribution)
DISTRIBUTION(TeXMFBinariesDistribution, setTeXMFBinariesDistribution)
DISTRIBUTION(GhostScriptBinariesDistribution, setGhostScriptBinariesDistribution)
DISTRIBUTION(TeXMFPath, setTeXMFPath)
DISTRIBUTION(TeXMFBinariesPath, setTeXMFBinariesPath)
DISTRIBUTION(GhostScriptBinariesPath, setGhostScriptBinariesPath)
#undef DISTRIBUTION
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  getTeXMFBinariesPath
- (NSString *) getTeXMFBinariesPath;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * distribution = [self TeXMFBinariesDistribution];
	if([distribution isEqual: iTM2DistributionDefault])
	{
		return [[self class] defaultTeXMFBinariesPath];
	}
	else if([distribution isEqual: iTM2DistributionCustom])
	{
		return [self TeXMFBinariesPath];
	}
	else
	{
		NSString * key = [iTM2DistributionDomainTeXMFBinaries stringByAppendingPathExtension: distribution];
		NSString * result = [SUD stringForKey: key];
		return [result length]? result: [[self class] defaultTeXMFBinariesPath];
	}
//iTM2_END;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  getTeXMFPath
- (NSString *) getTeXMFPath;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * distribution = [self TeXMFDistribution];
	if([distribution isEqual: iTM2DistributionDefault])
	{
		return [[self class] defaultTeXMFPath];
	}
	else if([distribution isEqual: iTM2DistributionCustom])
	{
		return [self TeXMFPath];
	}
	else
	{
		NSString * key = [iTM2DistributionDomainTeXMF stringByAppendingPathExtension: distribution];
		NSString * result = [SUD stringForKey: key];
		return [result length]? result: [[self class] defaultTeXMFPath];
	}
//iTM2_END;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  getGhostScriptBinariesPath
- (NSString *) getGhostScriptBinariesPath;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * distribution = [self GhostScriptBinariesDistribution];
	if([distribution isEqual: iTM2DistributionDefault])
	{
		return [[self class] defaultGhostScriptBinariesPath];
	}
	else if([distribution isEqual: iTM2DistributionCustom])
	{
		return [self GhostScriptBinariesPath];
	}
	else
	{
		NSString * key = [iTM2DistributionDomainGhostScriptBinaries stringByAppendingPathExtension: distribution];
		NSString * result = [SUD stringForKey: key];
		return [result length]? result: [[self class] defaultGhostScriptBinariesPath];
	}
//iTM2_END;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  defaultTeXMFPath
+ (NSString *) defaultTeXMFPath;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * distribution = [SUD stringForKey: iTM2DistributionTeXMF];
	if(![distribution length])
	{
		iTM2_LOG(@"...........  HUGE ERROR: Missing TeXMF distribution reference in preferences, report bug");
		return @"Missing TeXMF ";
	}
	NSString * key = [iTM2DistributionDomainTeXMF stringByAppendingPathExtension: distribution];
	NSString * result = [SUD stringForKey: key];
	if(![result length])
	{
		iTM2_LOG(@"...........  HUGE ERROR: Missing TeXMF %@ distribution path in preferences, report bug", distribution);
		return @"Missing TeXMF Distribution Path";
	}
//iTM2_END;
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  defaultTeXMFBinariesPath
+ (NSString *) defaultTeXMFBinariesPath;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * distribution = [SUD stringForKey: iTM2DistributionTeXMFBinaries];
	if(![distribution length])
	{
		iTM2_LOG(@"...........  HUGE ERROR: Missing TeXMF binaries distribution reference in preferences, report bug");
		return @"Missing TeXMF Binaries ";
	}
	NSString * key = [iTM2DistributionDomainTeXMFBinaries stringByAppendingPathExtension: distribution];
	NSString * result = [SUD stringForKey: key];
	if(![result length])
	{
		iTM2_LOG(@"...........  HUGE ERROR: Missing TeXMF binaries %@ distribution path in preferences, report bug", distribution);
		return @"Missing TeXMF Binaries Distribution Path";
	}
//iTM2_END;
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  defaultGhostScriptBinariesPath
+ (NSString *) defaultGhostScriptBinariesPath;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * distribution = [SUD stringForKey: iTM2DistributionGhostScriptBinaries];
	if(![distribution length])
	{
		iTM2_LOG(@"...........  HUGE ERROR: Missing GhostScript binaries distribution reference in preferences, report bug");
		return @"Missing GhostScript Binaries ";
	}
	NSString * key = [iTM2DistributionDomainGhostScriptBinaries stringByAppendingPathExtension: distribution];
	NSString * result = [SUD stringForKey: key];
	if(![result length])
	{
		iTM2_LOG(@"...........  HUGE ERROR: Missing GhostScript binaries %@ distribution path in preferences, report bug", distribution);
		return @"Missing GhostScript Binaries Distribution Path";
	}
//iTM2_END;
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  distributionsCompleteDidReadFromFile:ofType:
- (void) distributionsCompleteDidReadFromFile: (NSString *) fileName ofType: (NSString *) type;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	// testing the distributions
#if 0
	if(([[self TeXMFDistribution] isEqual: iTM2DistributionDefault] || [DFM fileExistsAtPath: [self TeXMFPath]])
		&& ([[self TeXMFBinariesDistribution] isEqual: iTM2DistributionDefault] || [DFM fileExistsAtPath: [self TeXMFBinariesPath]])
		&& ([[self GhostScriptBinariesDistribution] isEqual: iTM2DistributionDefault] || [DFM fileExistsAtPath: [self GhostScriptBinariesPath]]))
	{
		return;
	}
#else
	// the same code splitted for debugging purpose
	NSString * distribution = [self TeXMFDistribution];
	NSString * path = [self TeXMFPath];
	if(![distribution isEqual: iTM2DistributionCustom] || [DFM fileExistsAtPath: path])
		return;
	distribution = [self TeXMFBinariesDistribution];
	path = [self TeXMFBinariesPath];
	if(![distribution isEqual: iTM2DistributionCustom] || [DFM fileExistsAtPath: path])
		return;
	distribution = [self GhostScriptBinariesDistribution];
	path = [self GhostScriptBinariesPath];
	if(![distribution isEqual: iTM2DistributionCustom] || [DFM fileExistsAtPath: path])
		return;
#endif
	[self performSelector: @selector(notifyUncompleteDistributionWarning:) withObject: nil afterDelay:0.01];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  notifyUncompleteDistributionWarning:
- (void) notifyUncompleteDistributionWarning: (id) irrelevant;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	// testing the distributions
	NSRunCriticalAlertPanel(
        NSLocalizedStringFromTableInBundle(@"Problem", iTM2TeXProjectTable, [self classBundle], "notifyUncompleteDistributionWarning, title"),
        NSLocalizedStringFromTableInBundle(@"A project distribution is unknown", iTM2TeXProjectTable, [self classBundle], "notifyUncompleteDistributionWarning, msg"),
		nil, nil, nil);

//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  notifyDefaultDistributionFixedWarning:
+ (void) notifyDefaultDistributionFixedWarning: (id) irrelevant;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	// testing the distributions
	NSRunCriticalAlertPanel(
        NSLocalizedStringFromTableInBundle(@"Warning", iTM2TeXProjectTable, [self classBundle], "notifyDefaultDistributionFixedWarning, title"),
        NSLocalizedStringFromTableInBundle(@"Due to a modification in your local configuration, the default project distribution has been updated. See the preferences.", iTM2TeXProjectTable, [self classBundle], "notifyDefaultDistributionFixedWarning, msg"),
		nil, nil, nil);

//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  notifyDefaultDistributionUnfixedError:
+ (void) notifyDefaultDistributionUnfixedError: (id) irrelevant;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	// testing the distributions
	NSRunCriticalAlertPanel(
        NSLocalizedStringFromTableInBundle(@"Warning", iTM2TeXProjectTable, [self classBundle], "notifyDefaultDistributionUnfixedError, title"),
        NSLocalizedStringFromTableInBundle(@"Due to a modification in your local configuration, iTeXMac2 seems broken and won't compile properly. Please install a TeX distribution.",
			iTM2TeXProjectTable, [self classBundle], "notifyDefaultDistributionUnfixedError, msg"),
		nil, nil, nil);

//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  getPATHPrefix
- (NSString *) getPATHPrefix;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * projectPrefix = @"";
	id environment = [[self implementation] iVarDistributionEnvironment];
	if([[environment objectForKey: iTM2DistributionUsePATHPrefixKey] boolValue])
		projectPrefix = [environment objectForKey: iTM2DistributionPATHPrefixKey]?: @"";
	NSString * SUDPrefix = @"";
	if([SUD boolForKey: iTM2DistributionUsePATHPrefixKey])
		SUDPrefix = [SUD objectForKey: iTM2DistributionPATHPrefixKey]?: @"";
	if([projectPrefix length])
	{
		if([SUDPrefix length])
		{
			return [NSString stringWithFormat: @"%@:%@", projectPrefix, SUDPrefix];
		}
		else
			return projectPrefix;
	}
	else
		return SUDPrefix;
//iTM2_END;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  getPATHSuffix
- (NSString *) getPATHSuffix;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * projectSuffix = @"";
	id environment = [[self implementation] iVarDistributionEnvironment];
	if([[environment objectForKey: iTM2DistributionUsePATHSuffixKey] boolValue])
		projectSuffix = [environment objectForKey: iTM2DistributionPATHSuffixKey]?: @"";
	NSString * SUDSuffix = @"";
	if([SUD boolForKey: iTM2DistributionUsePATHSuffixKey])
		SUDSuffix = [SUD objectForKey: iTM2DistributionPATHSuffixKey]?: @"";
	if([projectSuffix length])
	{
		if([SUDSuffix length])
		{
			return [NSString stringWithFormat: @"%@:%@", projectSuffix, SUDSuffix];
		}
		else
			return projectSuffix;
	}
	else
		return SUDSuffix;
//iTM2_END;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  getTEXMFOUTPUT
- (NSString *) getTEXMFOUTPUT;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id environment = [[self implementation] iVarDistributionEnvironment];
	if([[environment objectForKey: iTM2DistributionUseOutputDirectoryKey] boolValue])
		return [environment objectForKey: iTM2DistributionOutputDirectoryKey]?: @"";
	if([SUD boolForKey: iTM2DistributionUseOutputDirectoryKey])
		return [SUD objectForKey: iTM2DistributionOutputDirectoryKey]?: @"";
	return @"";
//iTM2_END;
}
@end

#pragma mark -

NSString * const iTM2PDFTEXLogHeaderKey = @"iTM2PDFTEXLogHeader";
NSString * const iTM2TEXLogHeaderKey = @"iTM2TEXLogHeader";

@implementation iTM2TeXDistributionController
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initialize
+ (void) initialize;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[super initialize];
	[SUD registerDefaults: [NSDictionary dictionaryWithObjectsAndKeys:
		@"This is pdfeTeX",iTM2PDFTEXLogHeaderKey,
		@"This is TeX", iTM2TEXLogHeaderKey,
			nil]];
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  formatsPath
+ (NSString *) formatsPath;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	static NSString * path = nil;
	if(NO && !path)
	{
		iTM2TaskWrapper * TW = [[[iTM2TaskWrapper alloc] init] autorelease];
		[TW setLaunchPath: @"/bin/sh"];
		[TW addArgument: @"-c"];
		[TW addArgument: @"kpsewhich tex.fmt"];
//		[TW complete];
		iTM2TaskController * TC = [[[iTM2TaskController allocWithZone: [self zone]] init] autorelease];
		[TC addTaskWrapper: TW];
		[TC start];
//		[[TC currentTask] waitUntilExit];
		path = [[[TC output] stringByDeletingLastPathComponent] copy];
	}
//iTM2_END;
	return path?:@"";
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  fmtsAtPath:
+ (NSDictionary *) fmtsAtPath: (NSString *) path;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	BOOL isDirectory;
	if(![DFM fileExistsAtPath: path isDirectory: &isDirectory] || !isDirectory)
		return nil;
	// We list the contents of the given directory
	NSEnumerator * E = [[DFM directoryContentsAtPath: path] objectEnumerator];
	NSString * P;
	NSMutableArray * TeXs = [NSMutableArray array];
	NSMutableArray * PDFTeXs = [NSMutableArray array];
	NSMutableArray * Others = [NSMutableArray array];
	NSString * TeXLogHeader = [SUD objectForKey: iTM2TEXLogHeaderKey];
	NSString * PDFTeXLogHeader = [SUD objectForKey: iTM2PDFTEXLogHeaderKey];
	while(P = [E nextObject])
	{
		if([[P pathExtension] isEqual: @"fmt"])
		{
			NSString * fullPath = [path stringByAppendingPathComponent: P];
			NSString * linkTarget = [DFM pathContentOfSymbolicLinkAtPath: fullPath];
			NSString * coreName = [(linkTarget? linkTarget: fullPath) stringByDeletingPathExtension];
			NSString * logPath = [coreName stringByAppendingPathExtension: @"log"];
			NSString * S = [NSString stringWithContentsOfFile: logPath];
			if([S hasPrefix: TeXLogHeader])
				[TeXs addObject: [P stringByDeletingPathExtension]];
			else if([S hasPrefix: PDFTeXLogHeader])
				[PDFTeXs addObject: [P stringByDeletingPathExtension]];
			else
				[Others addObject: [P stringByDeletingPathExtension]];
		}
	}
	return [NSDictionary dictionaryWithObjectsAndKeys:
		TeXs, @"TeX",
		PDFTeXs, @"PDFTeX",
		Others, @"Other",
			nil];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  basesAtPath:
+ (NSArray *) basesAtPath: (NSString *) path;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	BOOL isDirectory;
	if(![DFM fileExistsAtPath: path isDirectory: &isDirectory] || !isDirectory)
		return nil;
	// We list the contents of the given directory
	NSEnumerator * E = [[DFM directoryContentsAtPath: path] objectEnumerator];
	NSString * P;
	NSMutableArray * bases = [NSMutableArray array];
	while(P = [E nextObject])
		if([[P pathExtension] isEqual: @"base"])
			[bases addObject: [P stringByDeletingPathExtension]];
	return bases;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  memsAtPath:
+ (NSArray *) memsAtPath: (NSString *) path;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	BOOL isDirectory;
	if(![DFM fileExistsAtPath: path isDirectory: &isDirectory] || !isDirectory)
		return nil;
	// We list the contents of the given directory
	NSEnumerator * E = [[DFM directoryContentsAtPath: path] objectEnumerator];
	NSString * P;
	NSMutableArray * mems = [NSMutableArray array];
	while(P = [E nextObject])
		if([[P pathExtension] isEqual: @"mem"])
			[mems addObject: [P stringByDeletingPathExtension]];
	return mems;
}
@end

#pragma mark -
#import "iTM2TeXProjectCommandKit.h"
@interface iTM2TeXPCommandsInspector(TeXDistributionKit_PRIVATE)
- (NSString *) lossyTeXMFBinariesDistribution;
- (BOOL) TeXMFBinariesDistributionIsIntel;
- (void) setTeXMFBinariesDistributionIntel: (BOOL) flag;
- (NSString *) lossyGhostScriptBinariesDistribution;
- (BOOL) GhostScriptBinariesDistributionIsIntel;
- (void) setGhostScriptBinariesDistributionIntel: (BOOL) flag;
@end
@implementation iTM2TeXPCommandsInspector(TeXDistributionKit)
#pragma mark =-=-=-=-=-  INTEL?
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  lossyTeXMFBinariesDistribution
- (NSString *) lossyTeXMFBinariesDistribution;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * distribution = [[self document] TeXMFBinariesDistribution];
	if([distribution isEqual: iTM2DistributiongwTeXIntel])
	{
		return iTM2DistributiongwTeX;
	}
	else if([distribution isEqual: iTM2DistributionFinkIntel])
	{
		return iTM2DistributionFink;
	}
	else if([distribution isEqual: iTM2DistributionTeXLiveIntel])
	{
		return iTM2DistributionTeXLive;
	}
	else if([distribution isEqual: iTM2DistributionTeXLiveCDIntel])
	{
		return iTM2DistributionTeXLiveCD;
	}
	else
		return distribution;
//iTM2_END;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  TeXMFBinariesDistributionIsIntel
- (BOOL) TeXMFBinariesDistributionIsIntel;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * distribution = [[self document] TeXMFBinariesDistribution];
//iTM2_END;
    return [distribution isEqual: iTM2DistributiongwTeXIntel]
		|| [distribution isEqual: iTM2DistributionFinkIntel]
		|| [distribution isEqual: iTM2DistributionTeXLiveIntel]
		|| [distribution isEqual: iTM2DistributionTeXLiveCDIntel];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setTeXMFBinariesDistributionIntel:
- (void) setTeXMFBinariesDistributionIntel: (BOOL) flag;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id doc = [self document];
	NSString * distribution = [doc TeXMFBinariesDistribution];
	if([distribution isEqual: iTM2DistributiongwTeX])
	{
		[doc setTeXMFBinariesDistribution: iTM2DistributiongwTeXIntel];
	}
	else if([distribution isEqual: iTM2DistributionFink])
	{
		[doc setTeXMFBinariesDistribution: iTM2DistributionFinkIntel];
	}
	else if([distribution isEqual: iTM2DistributionTeXLive])
	{
		[doc setTeXMFBinariesDistribution: iTM2DistributionTeXLiveIntel];
	}
	else if([distribution isEqual: iTM2DistributionTeXLiveCD])
	{
		[doc setTeXMFBinariesDistribution: iTM2DistributionTeXLiveCDIntel];
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  lossyGhostScriptBinariesDistribution
- (NSString *) lossyGhostScriptBinariesDistribution;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * distribution = [[self document] GhostScriptBinariesDistribution];
	if([distribution isEqual: iTM2DistributiongwTeXIntel])
	{
		return iTM2DistributiongwTeX;
	}
	else if([distribution isEqual: iTM2DistributionFinkIntel])
	{
		return iTM2DistributionFink;
	}
	else if([distribution isEqual: iTM2DistributionTeXLiveIntel])
	{
		return iTM2DistributionTeXLive;
	}
	else if([distribution isEqual: iTM2DistributionTeXLiveCDIntel])
	{
		return iTM2DistributionTeXLiveCD;
	}
	else
		return distribution;
//iTM2_END;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  GhostScriptBinariesDistributionIsIntel
- (BOOL) GhostScriptBinariesDistributionIsIntel;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * distribution = [[self document] GhostScriptBinariesDistribution];
//iTM2_END;
    return [distribution isEqual: iTM2DistributiongwTeXIntel]
		|| [distribution isEqual: iTM2DistributionFinkIntel]
		|| [distribution isEqual: iTM2DistributionTeXLiveIntel]
		|| [distribution isEqual: iTM2DistributionTeXLiveCDIntel];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setGhostScriptBinariesDistributionIntel:
- (void) setGhostScriptBinariesDistributionIntel: (BOOL) flag;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id doc = [self document];
	NSString * distribution = [doc GhostScriptBinariesDistribution];
	if([distribution isEqual: iTM2DistributiongwTeX])
	{
		[doc setGhostScriptBinariesDistribution: iTM2DistributiongwTeXIntel];
	}
	else if([distribution isEqual: iTM2DistributionFink])
	{
		[doc setGhostScriptBinariesDistribution: iTM2DistributionFinkIntel];
	}
	else if([distribution isEqual: iTM2DistributionTeXLive])
	{
		[doc setGhostScriptBinariesDistribution: iTM2DistributionTeXLiveIntel];
	}
	else if([distribution isEqual: iTM2DistributionTeXLiveCD])
	{
		[doc setGhostScriptBinariesDistribution: iTM2DistributionTeXLiveCDIntel];
	}
//iTM2_END;
    return;
}
#pragma mark =-=-=-=-=-  Output directory
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleOutputDirectory:
- (IBAction) toggleOutputDirectory: (id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id environment = [[(iTM2TeXProjectDocument *)[self document] implementation] iVarDistributionEnvironment];
    BOOL old = [[environment objectForKey: iTM2DistributionUseOutputDirectoryKey] boolValue];
    [environment setObject: [NSNumber numberWithBool: !old] forKey: iTM2DistributionUseOutputDirectoryKey];
	[[self document] updateChangeCount: NSChangeDone];
    [sender validateWindowContent];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleOutputDirectory:
- (BOOL) validateToggleOutputDirectory: (id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id environment = [[(iTM2TeXProjectDocument *)[self document] implementation] iVarDistributionEnvironment];
    [sender setState: ([[environment objectForKey: iTM2DistributionUseOutputDirectoryKey] boolValue]? NSOnState: NSOffState)];
//iTM2_END;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeOutputDirectoryFromStringValue:
- (IBAction) takeOutputDirectoryFromStringValue: (id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id environment = [[(iTM2TeXProjectDocument *)[self document] implementation] iVarDistributionEnvironment];
	NSString * old = [environment objectForKey: iTM2DistributionOutputDirectoryKey];
	NSString * new = [sender stringValue];
	if(![old isEqual: new])
	{
		[environment setObject: new forKey: iTM2DistributionOutputDirectoryKey];
		[[self document] updateChangeCount: NSChangeDone];
		[sender validateWindowContent];
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateTakeOutputDirectoryFromStringValue:
- (BOOL) validateTakeOutputDirectoryFromStringValue: (id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(![sender formatter])
		[sender setFormatter: [[[iTM2FileNameFormatter allocWithZone: [self zone]] init] autorelease]];
	id environment = [[(iTM2TeXProjectDocument *)[self document] implementation] iVarDistributionEnvironment];
    [sender setStringValue: [(iTM2TeXProjectDocument *)[self document] getTEXMFOUTPUT]];
	if([[environment objectForKey: iTM2DistributionUseOutputDirectoryKey] boolValue])
		return YES;
	if(sender == [[sender window] firstResponder])
		[[sender window] makeFirstResponder: nil];
//iTM2_END;
    return NO;
}
#pragma mark =-=-=-=-=-  PATH
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  togglePATHPrefix:
- (IBAction) togglePATHPrefix: (id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id document = [self document];
	id implementation = [document implementation];
	id environment = [implementation iVarDistributionEnvironment];
//	id environment = [[(iTM2TeXProjectDocument *)[self document] implementation] iVarDistributionEnvironment];
    BOOL old = [[environment objectForKey: iTM2DistributionUsePATHPrefixKey] boolValue];
    [environment setObject: [NSNumber numberWithBool: !old] forKey: iTM2DistributionUsePATHPrefixKey];
	[[self document] updateChangeCount: NSChangeDone];
    [sender validateWindowContent];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateTogglePATHPrefix:
- (BOOL) validateTogglePATHPrefix: (id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id environment = [[(iTM2TeXProjectDocument *)[self document] implementation] iVarDistributionEnvironment];
    [sender setState: ([[environment objectForKey: iTM2DistributionUsePATHPrefixKey] boolValue]? NSOnState: NSOffState)];
//iTM2_END;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takePATHPrefixFromStringValue:
- (IBAction) takePATHPrefixFromStringValue: (id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id environment = [[(iTM2TeXProjectDocument *)[self document] implementation] iVarDistributionEnvironment];
	NSString * old = [environment objectForKey: iTM2DistributionPATHPrefixKey];
	NSString * new = [sender stringValue];
	if(![old isEqual: new])
	{
		[environment setObject: new forKey: iTM2DistributionPATHPrefixKey];
		[[self document] updateChangeCount: NSChangeDone];
		[sender validateWindowContent];
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateTakePATHPrefixFromStringValue:
- (BOOL) validateTakePATHPrefixFromStringValue: (id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(![sender formatter])
		[sender setFormatter: [[[iTM2FileNameFormatter allocWithZone: [self zone]] init] autorelease]];
	id environment = [[(iTM2TeXProjectDocument *)[self document] implementation] iVarDistributionEnvironment];
    [sender setStringValue: [(iTM2TeXProjectDocument *)[self document] getPATHPrefix]];
	if([[environment objectForKey: iTM2DistributionUsePATHPrefixKey] boolValue])
		return YES;
	if(sender == [[sender window] firstResponder])
		[[sender window] makeFirstResponder: nil];
//iTM2_END;
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  togglePATHSuffix:
- (IBAction) togglePATHSuffix: (id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id environment = [[(iTM2TeXProjectDocument *)[self document] implementation] iVarDistributionEnvironment];
    BOOL old = [[environment objectForKey: iTM2DistributionUsePATHSuffixKey] boolValue];
    [environment setObject: [NSNumber numberWithBool: !old] forKey: iTM2DistributionUsePATHSuffixKey];
	[[self document] updateChangeCount: NSChangeDone];
    [sender validateWindowContent];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateTogglePATHSuffix:
- (BOOL) validateTogglePATHSuffix: (id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id environment = [[(iTM2TeXProjectDocument *)[self document] implementation] iVarDistributionEnvironment];
    [sender setState: ([[environment objectForKey: iTM2DistributionUsePATHSuffixKey] boolValue]? NSOnState: NSOffState)];
//iTM2_END;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takePATHSuffixFromStringValue:
- (IBAction) takePATHSuffixFromStringValue: (id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id environment = [[(iTM2TeXProjectDocument *)[self document] implementation] iVarDistributionEnvironment];
	NSString * old = [environment objectForKey: iTM2DistributionPATHSuffixKey];
	NSString * new = [sender stringValue];
	if(![old isEqual: new])
	{
		[environment setObject: new forKey: iTM2DistributionPATHSuffixKey];
		[[self document] updateChangeCount: NSChangeDone];
		[sender validateWindowContent];
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateTakePATHSuffixFromStringValue:
- (BOOL) validateTakePATHSuffixFromStringValue: (id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(![sender formatter])
		[sender setFormatter: [[[iTM2FileNameFormatter allocWithZone: [self zone]] init] autorelease]];
	id environment = [[(iTM2TeXProjectDocument *)[self document] implementation] iVarDistributionEnvironment];
    [sender setStringValue: [(iTM2TeXProjectDocument *)[self document] getPATHSuffix]];
	if([[environment objectForKey: iTM2DistributionUsePATHSuffixKey] boolValue])
		return YES;
	if(sender == [[sender window] firstResponder])
		[[sender window] makeFirstResponder: nil];
//iTM2_END;
    return NO;
}
#pragma mark =-=-=-=-=-  DISTRIBUTIONS
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeTeXMFDistributionFromPopUp:
- (IBAction) takeTeXMFDistributionFromPopUp: (id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 06:28:11 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([sender isKindOfClass: [NSPopUpButton class]])
		sender = [sender selectedItem];
	if([sender isKindOfClass: [NSMenuItem class]])
	{
		NSString * new = [sender representedObject];
		NSString * old = [[self document] TeXMFDistribution];
		if(![old isEqual: new])
		{
			[[self document] setTeXMFDistribution: new];
			[[self document] updateChangeCount: NSChangeDone];
			[self validateWindowContent];
		}
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateTakeTeXMFDistributionFromPopUp:
- (BOOL) validateTakeTeXMFDistributionFromPopUp: (id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([sender isKindOfClass: [NSPopUpButton class]])
	{
		NSString * distribution = [[self document] TeXMFDistribution];
		unsigned index = [sender indexOfItemWithRepresentedObject: distribution];
		if(index < [sender numberOfItems])
			[sender selectItemAtIndex: index];
		else if([distribution isEqual: iTM2DistributionDefault])
			[sender selectItemWithTag: iTM2TeXDistributionDefaultTag];
		else if([distribution isEqual: iTM2DistributionBuiltIn])
			[sender selectItemWithTag: iTM2TeXDistributionBuiltInTag];
		else if([distribution isEqual: iTM2DistributiongwTeX])
			[sender selectItemWithTag: iTM2TeXDistributionGWTeXTag];
		else if([distribution isEqual: iTM2DistributionFink])
			[sender selectItemWithTag: iTM2TeXDistributionFinkTag];
		else if([distribution isEqual: iTM2DistributionTeXLive])
			[sender selectItemWithTag: iTM2TeXDistributionTeXLiveTag];
		else if([distribution isEqual: iTM2DistributionTeXLiveCD])
			[sender selectItemWithTag: iTM2TeXDistributionTeXLiveCDTag];
		else if([distribution isEqual: iTM2DistributionCustom])
			[sender selectItemWithTag: iTM2TeXDistributionCustomTag];
		else if([distribution isEqual: iTM2DistributionOther])
			[sender selectItemWithTag: iTM2TeXDistributionOtherTag];
		return YES;
	}
	else if([sender isKindOfClass: [NSMenuItem class]])
	{
		id representedObject;
		switch([sender tag])
		{
			default:
			case iTM2TeXDistributionDefaultTag: representedObject = iTM2DistributionDefault; break;
			case iTM2TeXDistributionBuiltInTag: representedObject = iTM2DistributionBuiltIn; [sender setIndentationLevel: 1]; break;
			case iTM2TeXDistributionGWTeXTag: representedObject = iTM2DistributiongwTeX; [sender setIndentationLevel: 1]; break;
			case iTM2TeXDistributionFinkTag: representedObject = iTM2DistributionFink; [sender setIndentationLevel: 1]; break;
			case iTM2TeXDistributionTeXLiveTag: representedObject = iTM2DistributionTeXLive; [sender setIndentationLevel: 1]; break;
			case iTM2TeXDistributionTeXLiveCDTag: representedObject = iTM2DistributionTeXLiveCD; [sender setIndentationLevel: 1]; break;
			case iTM2TeXDistributionOtherTag: representedObject = iTM2DistributionOther; [sender setIndentationLevel: 1]; break;
			case iTM2TeXDistributionCustomTag: representedObject = iTM2DistributionCustom; break;
		}
		[sender setRepresentedObject: representedObject];
		return YES;
	}
	return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeTeXMFPathFromStringValue:
- (IBAction) takeTeXMFPathFromStringValue: (id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    id TPD = (iTM2TeXProjectDocument *)[self document];
	id new = [sender stringValue];
	if(![[TPD TeXMFPath] isEqual: new])
	{
		[TPD setTeXMFPath: new];
		[TPD updateChangeCount: NSChangeDone];
		[self validateWindowContent];
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateTakeTeXMFPathFromStringValue:
- (BOOL) validateTakeTeXMFPathFromStringValue: (id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(![sender formatter])
		[sender setFormatter: [[[iTM2FileNameFormatter allocWithZone: [self zone]] init] autorelease]];
    id TPD = (iTM2TeXProjectDocument *)[self document];
	[sender setStringValue: [TPD getTeXMFPath]];
//iTM2_END;
	return [[TPD TeXMFDistribution] isEqual: iTM2DistributionCustom];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeTeXMFBinariesDistributionFromPopUp:
- (IBAction) takeTeXMFBinariesDistributionFromPopUp: (id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 06:28:11 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([sender isKindOfClass: [NSPopUpButton class]])
		sender = [sender selectedItem];
	if([sender isKindOfClass: [NSMenuItem class]])
	{
		BOOL isIntel = [self TeXMFBinariesDistributionIsIntel];
		NSString * old = [[self document] TeXMFBinariesDistribution];
		[[self document] setTeXMFBinariesDistribution: [sender representedObject]];
		[self setTeXMFBinariesDistributionIntel: isIntel];
		NSString * new = [[self document] TeXMFBinariesDistribution];
		if(![old isEqual: new])
		{
			[[self document] updateChangeCount: NSChangeDone];
			[self validateWindowContent];
		}
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateTakeTeXMFBinariesDistributionFromPopUp:
- (BOOL) validateTakeTeXMFBinariesDistributionFromPopUp: (id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([sender isKindOfClass: [NSPopUpButton class]])
	{
		NSString * distribution = [self lossyTeXMFBinariesDistribution];
		unsigned index = [sender indexOfItemWithRepresentedObject: distribution];
		if(index < [sender numberOfItems])
			[sender selectItemAtIndex: index];
		else if([distribution isEqual: iTM2DistributionDefault])
			[sender selectItemWithTag: iTM2TeXDistributionDefaultTag];
		else if([distribution isEqual: iTM2DistributionBuiltIn])
			[sender selectItemWithTag: iTM2TeXDistributionBuiltInTag];
		else if([distribution isEqual: iTM2DistributiongwTeX])
			[sender selectItemWithTag: iTM2TeXDistributionGWTeXTag];
		else if([distribution isEqual: iTM2DistributionFink])
			[sender selectItemWithTag: iTM2TeXDistributionFinkTag];
		else if([distribution isEqual: iTM2DistributionTeXLive])
			[sender selectItemWithTag: iTM2TeXDistributionTeXLiveTag];
		else if([distribution isEqual: iTM2DistributionTeXLiveCD])
			[sender selectItemWithTag: iTM2TeXDistributionTeXLiveCDTag];
		else if([distribution isEqual: iTM2DistributionCustom])
			[sender selectItemWithTag: iTM2TeXDistributionCustomTag];
		else if([distribution isEqual: iTM2DistributionOther])
			[sender selectItemWithTag: iTM2TeXDistributionOtherTag];
		return YES;
	}
	else if([sender isKindOfClass: [NSMenuItem class]])
	{
		id representedObject;
		switch([sender tag])
		{
			default:
			case iTM2TeXDistributionDefaultTag: representedObject = iTM2DistributionDefault; break;
			case iTM2TeXDistributionBuiltInTag: representedObject = iTM2DistributionBuiltIn; [sender setIndentationLevel: 1]; break;
			case iTM2TeXDistributionGWTeXTag: representedObject = iTM2DistributiongwTeX; [sender setIndentationLevel: 1]; break;
			case iTM2TeXDistributionFinkTag: representedObject = iTM2DistributionFink; [sender setIndentationLevel: 1]; break;
			case iTM2TeXDistributionTeXLiveTag: representedObject = iTM2DistributionTeXLive; [sender setIndentationLevel: 1]; break;
			case iTM2TeXDistributionTeXLiveCDTag: representedObject = iTM2DistributionTeXLiveCD; [sender setIndentationLevel: 1]; break;
			case iTM2TeXDistributionOtherTag: representedObject = iTM2DistributionOther; [sender setIndentationLevel: 1]; break;
			case iTM2TeXDistributionCustomTag: representedObject = iTM2DistributionCustom; break;
		}
		[sender setRepresentedObject: representedObject];
		return YES;
	}
	return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeTeXMFBinariesPathFromStringValue:
- (IBAction) takeTeXMFBinariesPathFromStringValue: (id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    id TPD = (iTM2TeXProjectDocument *)[self document];
	id new = [sender stringValue];
	if(![[TPD TeXMFBinariesPath] isEqual: new])
	{
		[TPD setTeXMFBinariesPath: new];
		[TPD updateChangeCount: NSChangeDone];
		[self validateWindowContent];
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateTakeTeXMFBinariesPathFromStringValue:
- (BOOL) validateTakeTeXMFBinariesPathFromStringValue: (id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(![sender formatter])
		[sender setFormatter: [[[iTM2FileNameFormatter allocWithZone: [self zone]] init] autorelease]];
    id TPD = (iTM2TeXProjectDocument *)[self document];
	[sender setStringValue: [TPD getTeXMFBinariesPath]];
//iTM2_END;
	return [[TPD TeXMFBinariesDistribution] isEqual: iTM2DistributionCustom];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleTeXMFBinariesCPUType:
- (IBAction) toggleTeXMFBinariesCPUType: (id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self setTeXMFBinariesDistributionIntel: ![self TeXMFBinariesDistributionIsIntel]];
    id TPD = (iTM2TeXProjectDocument *)[self document];
	[TPD updateChangeCount: NSChangeDone];
	[self validateWindowContent];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleTeXMFBinariesCPUType:
- (BOOL) validateToggleTeXMFBinariesCPUType: (id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(![NSBundle isI386])
	{
		[sender setAction: NULL];
		[sender setHidden: YES];
		return YES;
	}
	if([[(id)[self document] TeXMFBinariesDistribution] isEqual: iTM2DistributionCustom])
	{
		[sender setState: NSMixedState];
		return NO;
	}
	[sender setState: ([self TeXMFBinariesDistributionIsIntel]?NSOnState: NSOffState)];
//iTM2_END;
	return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeGhostScriptBinariesDistributionFromPopUp:
- (IBAction) takeGhostScriptBinariesDistributionFromPopUp: (id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 06:28:11 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([sender isKindOfClass: [NSPopUpButton class]])
		sender = [sender selectedItem];
	if([sender isKindOfClass: [NSMenuItem class]])
	{
		BOOL isIntel = [self GhostScriptBinariesDistributionIsIntel];
		NSString * old = [[self document] GhostScriptBinariesDistribution];
		[[self document] setGhostScriptBinariesDistribution: [sender representedObject]];
		[self setGhostScriptBinariesDistributionIntel: isIntel];
		NSString * new = [[self document] GhostScriptBinariesDistribution];
		if(![old isEqual: new])
		{
			[[self document] updateChangeCount: NSChangeDone];
			[self validateWindowContent];
		}
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateTakeGhostScriptBinariesDistributionFromPopUp:
- (BOOL) validateTakeGhostScriptBinariesDistributionFromPopUp: (id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([sender isKindOfClass: [NSPopUpButton class]])
	{
		NSString * distribution = [self lossyGhostScriptBinariesDistribution];
		unsigned index = [sender indexOfItemWithRepresentedObject: distribution];
		if(index < [sender numberOfItems])
			[sender selectItemAtIndex: index];
		else if([distribution isEqual: iTM2DistributionDefault])
			[sender selectItemWithTag: iTM2TeXDistributionDefaultTag];
		else if([distribution isEqual: iTM2DistributionBuiltIn])
			[sender selectItemWithTag: iTM2TeXDistributionBuiltInTag];
		else if([distribution isEqual: iTM2DistributiongwTeX])
			[sender selectItemWithTag: iTM2TeXDistributionGWTeXTag];
		else if([distribution isEqual: iTM2DistributionFink])
			[sender selectItemWithTag: iTM2TeXDistributionFinkTag];
		else if([distribution isEqual: iTM2DistributionTeXLive])
			[sender selectItemWithTag: iTM2TeXDistributionTeXLiveTag];
		else if([distribution isEqual: iTM2DistributionTeXLiveCD])
			[sender selectItemWithTag: iTM2TeXDistributionTeXLiveCDTag];
		else if([distribution isEqual: iTM2DistributionCustom])
			[sender selectItemWithTag: iTM2TeXDistributionCustomTag];
		else if([distribution isEqual: iTM2DistributionOther])
			[sender selectItemWithTag: iTM2TeXDistributionOtherTag];
		return YES;
	}
	else if([sender isKindOfClass: [NSMenuItem class]])
	{
		id representedObject;
		switch([sender tag])
		{
			default:
			case iTM2TeXDistributionDefaultTag: representedObject = iTM2DistributionDefault; break;
			case iTM2TeXDistributionBuiltInTag: representedObject = iTM2DistributionBuiltIn; [sender setIndentationLevel: 1]; break;
			case iTM2TeXDistributionGWTeXTag: representedObject = iTM2DistributiongwTeX; [sender setIndentationLevel: 1]; break;
			case iTM2TeXDistributionFinkTag: representedObject = iTM2DistributionFink; [sender setIndentationLevel: 1]; break;
			case iTM2TeXDistributionTeXLiveTag: representedObject = iTM2DistributionTeXLive; [sender setIndentationLevel: 1]; break;
			case iTM2TeXDistributionTeXLiveCDTag: representedObject = iTM2DistributionTeXLiveCD; [sender setIndentationLevel: 1]; break;
			case iTM2TeXDistributionOtherTag: representedObject = iTM2DistributionOther; [sender setIndentationLevel: 1]; break;
			case iTM2TeXDistributionCustomTag: representedObject = iTM2DistributionCustom; break;
		}
		[sender setRepresentedObject: representedObject];
		return YES;
	}
	return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeGhostScriptBinariesPathFromStringValue:
- (IBAction) takeGhostScriptBinariesPathFromStringValue: (id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    id TPD = (iTM2TeXProjectDocument *)[self document];
	id new = [sender stringValue];
	if(![[TPD GhostScriptBinariesPath] isEqual: new])
	{
		[TPD setGhostScriptBinariesPath: new];
		[TPD updateChangeCount: NSChangeDone];
		[self validateWindowContent];
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateTakeGhostScriptBinariesPathFromStringValue:
- (BOOL) validateTakeGhostScriptBinariesPathFromStringValue: (id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(![sender formatter])
		[sender setFormatter: [[[iTM2FileNameFormatter allocWithZone: [self zone]] init] autorelease]];
    id TPD = (iTM2TeXProjectDocument *)[self document];
	[sender setStringValue: [TPD getGhostScriptBinariesPath]];
//iTM2_END;
	return [[TPD GhostScriptBinariesDistribution] isEqual: iTM2DistributionCustom];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleGhostScriptBinariesCPUType:
- (IBAction) toggleGhostScriptBinariesCPUType: (id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self setGhostScriptBinariesDistributionIntel: ![self GhostScriptBinariesDistributionIsIntel]];
    id TPD = (iTM2TeXProjectDocument *)[self document];
	[TPD updateChangeCount: NSChangeDone];
	[self validateWindowContent];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleGhostScriptBinariesCPUType:
- (BOOL) validateToggleGhostScriptBinariesCPUType: (id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(![NSBundle isI386])
	{
		[sender setAction: NULL];
		[sender setHidden: YES];
		return YES;
	}
	if([[(id)[self document] GhostScriptBinariesDistribution] isEqual: iTM2DistributionCustom])
	{
		[sender setState: NSMixedState];
		return NO;
	}
	[sender setState: ([self GhostScriptBinariesDistributionIsIntel]?NSOnState: NSOffState)];
//iTM2_END;
	return YES;
}
@end
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2DistributionServer

#pragma mark -
@interface iTM2TeXDistributionPrefPane: iTM2PreferencePane
- (IBAction) toggleOutputDirectory: (id) sender;
- (IBAction) takeOutputDirectoryFromStringValue: (id) sender;
- (IBAction) togglePATHPrefix: (id) sender;
- (IBAction) takePATHPrefixFromStringValue: (id) sender;
- (IBAction) togglePATHSuffix: (id) sender;
- (IBAction) takePATHSuffixFromStringValue: (id) sender;
- (IBAction) takeTeXMFDistributionFromPopUp: (id) sender;
- (IBAction) takeTeXMFBinariesDistributionFromPopUp: (id) sender;
- (IBAction) takeGhostScriptBinariesDistributionFromPopUp: (id) sender;
- (id) orderedEnvironmentVariableNames;
- (void) setOrderedEnvironmentVariableNames:(id)argument;
- (id) environmentVariables;
@end

@implementation iTM2TeXDistributionPrefPane
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= initialize
+ (void)initialize;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 09/21/2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[super initialize];
	[iTM2TeXPCommandPerformer class];// initialize Task environment variables as side effect
//iTM2_END;
    return;
}
#if 0
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= tabView:didSelectTabViewItem:
- (void) tabView: (NSTabView *) tabView didSelectTabViewItem: (NSTabViewItem *) tabViewItem;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 09/21/2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[tabView validateWindowContent];
//iTM2_END;
    return;
}
#endif
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= prefPaneIdentifier
- (NSString *) prefPaneIdentifier;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 09/21/2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return @"1.TeX";
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= orderedEnvironmentVariableNames
- (id) orderedEnvironmentVariableNames;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 09/21/2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id result = metaGETTER;
	if(!result)
	{
		result = [[[[[self environmentVariables] allKeys] sortedArrayUsingSelector: @selector(compare:)] mutableCopy] autorelease];
		if(!result)
		{
			result = [NSMutableArray array];
		}
		metaSETTER(result);
		result = metaGETTER;
	}
//iTM2_END;
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= setOrderedEnvironmentVariableNames:
- (void) setOrderedEnvironmentVariableNames:(id)argument;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 09/21/2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	metaSETTER(argument);
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= environmentVariables
- (id) environmentVariables;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 09/21/2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id result = metaGETTER;
	if(!result)
	{
		NSDictionary * seed = [SUD dictionaryForKey: iTM2EnvironmentVariablesKey];
		result = seed? [NSMutableDictionary dictionaryWithDictionary: seed]: [NSMutableDictionary dictionary];
		metaSETTER(result);
		result = metaGETTER;
	}
//iTM2_END;
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= environmentTableView
- (id) environmentTableView;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 09/21/2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return metaGETTER;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= setEnvironmentTableView:
- (void) setEnvironmentTableView: (id) argument;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 09/21/2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	metaSETTER(argument);
	[argument setDelegate: self];
//iTM2_END;
    return;
}
#pragma mark =-=-=-=-=-  Environment variables
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  numberOfRowsInTableView:
- (int) numberOfRowsInTableView: (NSTableView *) tableView;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 09/21/2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(![self environmentTableView])
	{
		[self setEnvironmentTableView: tableView];
	}
//iTM2_END;
    return [[self orderedEnvironmentVariableNames] count];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  tableView:objectValueForTableColumn:row:
- (id) tableView: (NSTableView *) tableView objectValueForTableColumn: (NSTableColumn *) tableColumn row: (int) row;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 09/21/2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSArray * names = [self orderedEnvironmentVariableNames];
	if(row<0)
		return nil;
	if(row>=[names count])
		return nil;
	NSString * key = [names objectAtIndex: row];
	NSString * identifier = [tableColumn identifier];
	if([identifier isEqual: @"used"])
	{
		return [NSNumber numberWithBool: [[key pathExtension] isEqual: @""]];
	}
	else if([identifier isEqual: @"name"])
	{
		return [key stringByDeletingPathExtension];
	}
	else if([identifier isEqual: @"value"])
	{
		return [[self environmentVariables] objectForKey: key];
	}
//iTM2_END
    return key;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  tableView:setObjectValue:forTableColumn:row:
- (void) tableView: (NSTableView *) tableView setObjectValue: (id) object forTableColumn: (NSTableColumn *) tableColumn row: (int) row;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 09/21/2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * key = [[self orderedEnvironmentVariableNames] objectAtIndex: row];
	if([[tableColumn identifier] isEqual: @"used"])
	{
		NSString * newKey = [[key pathExtension] length]?
			[key stringByDeletingPathExtension]: [key stringByAppendingPathExtension: @"unused"];
		[[self orderedEnvironmentVariableNames] replaceObjectAtIndex: row withObject: newKey];
		if(![newKey isEqual: key])
		{
			[[self environmentVariables] setObject: ([[self environmentVariables] objectForKey: key]?:@"") forKey: newKey];
			[[self environmentVariables] removeObjectForKey: key];
		}
	}
	else if([[tableColumn identifier] isEqual: @"name"])
	{
		if([object isEqual: @"PATH"])
			goto abort;
		NSString * pathExtension = [key pathExtension];
		NSString * newKey = [pathExtension length]?
			[object stringByAppendingPathExtension: pathExtension]: object;
		if([[self orderedEnvironmentVariableNames] indexOfObject: object] != NSNotFound)
			goto abort;
		if([object rangeOfCharacterFromSet: [[NSCharacterSet characterSetWithCharactersInString:
				@"azertyuiopqsdfghjklmwxcvbnAZERTYUIOPQSDFGHJKLMWXCVBN1234567890_"] invertedSet]].length)
			goto abort;
		[[self orderedEnvironmentVariableNames] replaceObjectAtIndex: row withObject: newKey];
		[[self environmentVariables] setObject: ([[self environmentVariables] objectForKey: key]?:@"") forKey: newKey];
		[[self environmentVariables] removeObjectForKey: key];
	}
	else if([[tableColumn identifier] isEqual: @"value"])
	{
		[[self environmentVariables] setObject: object forKey: key];
	}
	else
		goto abort;
	[SUD setObject: [self environmentVariables] forKey: iTM2EnvironmentVariablesKey];
abort:
	[[self environmentTableView] reloadData];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  tableViewSelectionDidChange:
- (void) tableViewSelectionDidChange: (NSNotification *) notification;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 09/21/2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[[self mainView] validateWindowContent];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= addEnvironmentVariable:
- (IBAction) addEnvironmentVariable: (id) sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 09/21/2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	int row = [[self orderedEnvironmentVariableNames] indexOfObject: @"VARIABLE"];
	if(row == NSNotFound)
	{
		[[self orderedEnvironmentVariableNames] addObject: @"VARIABLE"];
		row = [[self orderedEnvironmentVariableNames] indexOfObject: @"VARIABLE"];
		if(row == NSNotFound)
		{
			iTM2_LOG(@"ERROR: big problem here, could not add an object to %@", [self orderedEnvironmentVariableNames]);
			return;
		}
		[[self environmentTableView] reloadData];
	}
	[[self environmentTableView] selectRowIndexes: [NSIndexSet indexSetWithIndex: row] byExtendingSelection: NO];
	[[self environmentTableView] editColumn: [[self environmentTableView] columnWithIdentifier: @"name"]
		row: row withEvent: nil select: YES];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= removeEnvironmentVariable:
- (IBAction) removeEnvironmentVariable: (id) sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 09/21/2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSIndexSet * indexSet = [[self environmentTableView] selectedRowIndexes];
	if([indexSet count])
	{
		unsigned currentIndex = [indexSet firstIndex];
		NSMutableString * MS = [[[[[self orderedEnvironmentVariableNames] objectAtIndex: currentIndex] stringByDeletingPathExtension] mutableCopy] autorelease];
		currentIndex = [indexSet indexGreaterThanIndex: currentIndex];
		while (currentIndex != NSNotFound)
		{
			[MS appendFormat: @", %@", [[[self orderedEnvironmentVariableNames] objectAtIndex: currentIndex] stringByDeletingPathExtension]];
			currentIndex = [indexSet indexGreaterThanIndex: currentIndex];
		}
		NSBeginCriticalAlertSheet(
			NSLocalizedStringFromTableInBundle(@"Remove?", iTM2TeXProjectTable, [self classBundle], "Comment forthcoming"),
			nil,
			nil,
			NSLocalizedStringFromTableInBundle(@"Cancel", iTM2TeXProjectTable, [self classBundle], "Comment forthcoming"),
			[sender window],
			self,
			NULL,
			@selector(removeEnvironmentVariableSheetDidDismiss:returnCode:indexSet:),
			[indexSet retain],// will be autorelease in the method below
			NSLocalizedStringFromTableInBundle(@"Remove environment variables\n%@?", iTM2TeXProjectTable, [self classBundle], "Comment forthcoming"),
			MS);
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= removeEnvironmentVariableSheetDidDismiss:returnCode:indexSet:
- (void) removeEnvironmentVariableSheetDidDismiss: (NSWindow *) sheet returnCode: (int) returnCode indexSet: (NSIndexSet *) indexSet;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 09/21/2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[indexSet autorelease];
	if(returnCode == NSAlertDefaultReturn)
	{
		unsigned currentIndex = [indexSet lastIndex];
		while (currentIndex != NSNotFound)
		{
			NSString * key = [[self orderedEnvironmentVariableNames] objectAtIndex: currentIndex];
			[[self orderedEnvironmentVariableNames] removeObjectAtIndex: currentIndex];
			[[self environmentVariables] removeObjectForKey: key];
			currentIndex = [indexSet indexLessThanIndex: currentIndex];
		}
		[SUD setObject: [self environmentVariables] forKey:iTM2EnvironmentVariablesKey];
		[[self environmentTableView] reloadData];
	}
//iTM2_END;
    return;
}

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= validateRemoveEnvironmentVariable:
- (BOOL) validateRemoveEnvironmentVariable: (id) sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 09/21/2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return [[[self environmentTableView] selectedRowIndexes] count];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= revertToDefaultEnvironment:
- (IBAction) revertToDefaultEnvironment: (id) sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 09/21/2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	// we have to switch used/unused
	// revert to the default value
	// we must preserve variables added by the user
	NSMutableDictionary * environmentVariables = [self environmentVariables];
	NSDictionary * factoryEnvironmentVariables = [SUD dictionaryForKey:iTM2FactoryEnvironmentVariablesKey];
	NSArray * factoryKs = [factoryEnvironmentVariables allKeys];
	NSEnumerator * E = [environmentVariables keyEnumerator];
	NSString * K = nil;
	NSString * otherK = nil;
	NSString * factoryObject = nil;
	while(K = [E nextObject])
	{
		if([factoryKs containsObject:K])
		{
			factoryObject = [factoryEnvironmentVariables objectForKey:K];
			[environmentVariables setObject:factoryObject forKey:K];
		}
		else if([K hasSuffix:@"unused"])
		{
			otherK = [K stringByDeletingPathExtension];
			if([factoryKs containsObject:otherK])
			{
				[environmentVariables removeObjectForKey:K];
				factoryObject = [factoryEnvironmentVariables objectForKey:otherK];
				[environmentVariables setObject:factoryObject forKey:otherK];
			}
		}
		else
		{
			otherK = [K stringByAppendingPathExtension:@"unused"];
			if([factoryKs containsObject:otherK])
			{
				[environmentVariables removeObjectForKey:K];
				factoryObject = [factoryEnvironmentVariables objectForKey:otherK];
				[environmentVariables setObject:factoryObject forKey:otherK];
			}
			else
			{
				factoryObject = [[[environmentVariables objectForKey:K] retain] autorelease];
				[environmentVariables removeObjectForKey:K];
				[environmentVariables setObject:factoryObject forKey:otherK];
			}
		}
	}
	[self setOrderedEnvironmentVariableNames:nil];
	[SUD setObject:environmentVariables forKey:iTM2EnvironmentVariablesKey];
	[[self environmentTableView] reloadData];
	[sender validateUserInterfaceItems];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= validateRevertToDefaultEnvironment:
- (BOOL) validateRevertToDefaultEnvironment: (id) sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 09/21/2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return ![[self environmentVariables] isEqual:[SUD dictionaryForKey:iTM2FactoryEnvironmentVariablesKey]];
}
#pragma mark =-=-=-=-=-  Output directory
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleOutputDirectory:
- (IBAction) toggleOutputDirectory: (id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [SUD setBool: ![SUD boolForKey: iTM2DistributionUseOutputDirectoryKey] forKey: iTM2DistributionUseOutputDirectoryKey];
    [[self mainView] validateWindowContent];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleOutputDirectory:
- (BOOL) validateToggleOutputDirectory: (id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setState: ([SUD boolForKey: iTM2DistributionUseOutputDirectoryKey]? NSOnState: NSOffState)];
//iTM2_END;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeOutputDirectoryFromStringValue:
- (IBAction) takeOutputDirectoryFromStringValue: (id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [SUD setObject: [sender stringValue] forKey: iTM2DistributionOutputDirectoryKey];
    [[self mainView] validateWindowContent];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateTakeOutputDirectoryFromStringValue:
- (BOOL) validateTakeOutputDirectoryFromStringValue: (id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(![sender formatter])
		[sender setFormatter: [[[iTM2FileNameFormatter allocWithZone: [self zone]] init] autorelease]];
    [sender setStringValue: ([SUD stringForKey: iTM2DistributionOutputDirectoryKey]?: @"")];
	if([SUD boolForKey: iTM2DistributionUseOutputDirectoryKey])
		return YES;
	if(sender == [[sender window] firstResponder])
		[[sender window] makeFirstResponder: nil];
//iTM2_END;
    return NO;
}
#pragma mark =-=-=-=-=-  PATH
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  togglePATHPrefix:
- (IBAction) togglePATHPrefix: (id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [SUD setBool: ![SUD boolForKey: iTM2DistributionUsePATHPrefixKey] forKey: iTM2DistributionUsePATHPrefixKey];
    [[self mainView] validateWindowContent];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateTogglePATHPrefix:
- (BOOL) validateTogglePATHPrefix: (id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setState: ([SUD boolForKey: iTM2DistributionUsePATHPrefixKey]? NSOnState: NSOffState)];
//iTM2_END;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takePATHPrefixFromStringValue:
- (IBAction) takePATHPrefixFromStringValue: (id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [SUD setObject: [sender stringValue] forKey: iTM2DistributionPATHPrefixKey];
    [[self mainView] validateWindowContent];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateTakePATHPrefixFromStringValue:
- (BOOL) validateTakePATHPrefixFromStringValue: (id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(![sender formatter])
		[sender setFormatter: [[[iTM2FileNameFormatter allocWithZone: [self zone]] init] autorelease]];
    [sender setStringValue: ([SUD stringForKey: iTM2DistributionPATHPrefixKey]?: @"")];
	if([SUD boolForKey: iTM2DistributionUsePATHPrefixKey])
		return YES;
	if(sender == [[sender window] firstResponder])
		[[sender window] makeFirstResponder: nil];
//iTM2_END;
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  togglePATHSuffix:
- (IBAction) togglePATHSuffix: (id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [SUD setBool: ![SUD boolForKey: iTM2DistributionUsePATHSuffixKey] forKey: iTM2DistributionUsePATHSuffixKey];
    [[self mainView] validateWindowContent];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateTogglePATHSuffix:
- (BOOL) validateTogglePATHSuffix: (id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setState: ([SUD boolForKey: iTM2DistributionUsePATHSuffixKey]? NSOnState: NSOffState)];
//iTM2_END;
#warning DEBUGGGG
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takePATHSuffixFromStringValue:
- (IBAction) takePATHSuffixFromStringValue: (id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [SUD setObject: [sender stringValue] forKey: iTM2DistributionPATHSuffixKey];
    [[self mainView] validateWindowContent];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateTakePATHSuffixFromStringValue:
- (BOOL) validateTakePATHSuffixFromStringValue: (id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(![sender formatter])
		[sender setFormatter: [[[iTM2FileNameFormatter allocWithZone: [self zone]] init] autorelease]];
    [sender setStringValue: ([SUD stringForKey: iTM2DistributionPATHSuffixKey]?: @"")];
	if([SUD boolForKey: iTM2DistributionUsePATHSuffixKey])
		return YES;
	if(sender == [[sender window] firstResponder])
		[[sender window] makeFirstResponder: nil];
//iTM2_END;
    return NO;
}
#pragma mark =-=-=-=-=-  INTEL?
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  lossyTeXMFBinariesDistribution
- (NSString *) lossyTeXMFBinariesDistribution;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * distribution = [SUD stringForKey: iTM2DistributionTeXMFBinaries];
	if([distribution isEqual: iTM2DistributiongwTeXIntel])
	{
		return iTM2DistributiongwTeX;
	}
	else if([distribution isEqual: iTM2DistributionFinkIntel])
	{
		return iTM2DistributionFink;
	}
	else if([distribution isEqual: iTM2DistributionTeXLiveIntel])
	{
		return iTM2DistributionTeXLive;
	}
	else if([distribution isEqual: iTM2DistributionTeXLiveCDIntel])
	{
		return iTM2DistributionTeXLiveCD;
	}
	else
		return distribution;
//iTM2_END;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  TeXMFBinariesDistributionIsIntel
- (BOOL) TeXMFBinariesDistributionIsIntel;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * distribution = [SUD stringForKey: iTM2DistributionTeXMFBinaries];
//iTM2_END;
    return [distribution isEqual: iTM2DistributiongwTeXIntel]
		|| [distribution isEqual: iTM2DistributionFinkIntel]
		|| [distribution isEqual: iTM2DistributionTeXLiveIntel]
		|| [distribution isEqual: iTM2DistributionTeXLiveCDIntel];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setTeXMFBinariesDistributionIntel:
- (void) setTeXMFBinariesDistributionIntel: (BOOL) flag;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * distribution = [SUD stringForKey: iTM2DistributionTeXMFBinaries];
	if([distribution isEqual: iTM2DistributiongwTeX])
	{
		[SUD setObject: iTM2DistributiongwTeXIntel forKey: iTM2DistributionTeXMFBinaries];
	}
	else if([distribution isEqual: iTM2DistributionFink])
	{
		[SUD setObject: iTM2DistributionFinkIntel forKey: iTM2DistributionTeXMFBinaries];
	}
	else if([distribution isEqual: iTM2DistributionTeXLive])
	{
		[SUD setObject: iTM2DistributionTeXLiveIntel forKey: iTM2DistributionTeXMFBinaries];
	}
	else if([distribution isEqual: iTM2DistributionTeXLiveCD])
	{
		[SUD setObject: iTM2DistributionTeXLiveCDIntel forKey: iTM2DistributionTeXMFBinaries];
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  lossyGhostScriptBinariesDistribution
- (NSString *) lossyGhostScriptBinariesDistribution;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * distribution = [SUD stringForKey: iTM2DistributionGhostScriptBinaries];
	if([distribution isEqual: iTM2DistributiongwTeXIntel])
	{
		return iTM2DistributiongwTeX;
	}
	else if([distribution isEqual: iTM2DistributionFinkIntel])
	{
		return iTM2DistributionFink;
	}
	else if([distribution isEqual: iTM2DistributionTeXLiveIntel])
	{
		return iTM2DistributionTeXLive;
	}
	else if([distribution isEqual: iTM2DistributionTeXLiveCDIntel])
	{
		return iTM2DistributionTeXLiveCD;
	}
	else
		return distribution;
//iTM2_END;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  GhostScriptBinariesDistributionIsIntel
- (BOOL) GhostScriptBinariesDistributionIsIntel;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * distribution = [SUD stringForKey: iTM2DistributionGhostScriptBinaries];
//iTM2_END;
    return [distribution isEqual: iTM2DistributiongwTeXIntel]
		|| [distribution isEqual: iTM2DistributionFinkIntel]
		|| [distribution isEqual: iTM2DistributionTeXLiveIntel]
		|| [distribution isEqual: iTM2DistributionTeXLiveCDIntel];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setGhostScriptBinariesDistributionIntel:
- (void) setGhostScriptBinariesDistributionIntel: (BOOL) flag;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * distribution = [SUD stringForKey: iTM2DistributionGhostScriptBinaries];
	if([distribution isEqual: iTM2DistributiongwTeX])
	{
		[SUD setObject: iTM2DistributiongwTeXIntel forKey: iTM2DistributionGhostScriptBinaries];
	}
	else if([distribution isEqual: iTM2DistributionFink])
	{
		[SUD setObject: iTM2DistributionFinkIntel forKey: iTM2DistributionGhostScriptBinaries];
	}
	else if([distribution isEqual: iTM2DistributionTeXLive])
	{
		[SUD setObject: iTM2DistributionTeXLiveIntel forKey: iTM2DistributionGhostScriptBinaries];
	}
	else if([distribution isEqual: iTM2DistributionTeXLiveCD])
	{
		[SUD setObject: iTM2DistributionTeXLiveCDIntel forKey: iTM2DistributionGhostScriptBinaries];
	}
//iTM2_END;
    return;
}
#pragma mark =-=-=-=-=-  DISTRIBUTIONS
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeTeXMFDistributionFromPopUp:
- (IBAction) takeTeXMFDistributionFromPopUp: (id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 06:28:11 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([sender isKindOfClass: [NSPopUpButton class]])
		sender = [sender selectedItem];
	if([sender isKindOfClass: [NSMenuItem class]])
	{
		id new = [sender representedObject];
		if(![[SUD stringForKey: iTM2DistributionTeXMF] isEqual: new])
		{
			[SUD setObject: new forKey: iTM2DistributionTeXMF];
			[[self mainView] validateWindowContent];
		}
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateTakeTeXMFDistributionFromPopUp:
- (BOOL) validateTakeTeXMFDistributionFromPopUp: (id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 06:28:11 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([sender isKindOfClass: [NSPopUpButton class]])
	{
		NSString * distribution = [SUD stringForKey: iTM2DistributionTeXMF];
		unsigned index = [sender indexOfItemWithRepresentedObject: distribution];
		if(index < [sender numberOfItems])
			[sender selectItemAtIndex: index];
		else if([distribution isEqual: iTM2DistributionDefault])
			[sender selectItemWithTag: iTM2TeXDistributionDefaultTag];
		else if([distribution isEqual: iTM2DistributionBuiltIn])
			[sender selectItemWithTag: iTM2TeXDistributionBuiltInTag];
		else if([distribution isEqual: iTM2DistributiongwTeX])
			[sender selectItemWithTag: iTM2TeXDistributionGWTeXTag];
		else if([distribution isEqual: iTM2DistributionFink])
			[sender selectItemWithTag: iTM2TeXDistributionFinkTag];
		else if([distribution isEqual: iTM2DistributionTeXLive])
			[sender selectItemWithTag: iTM2TeXDistributionTeXLiveTag];
		else if([distribution isEqual: iTM2DistributionTeXLiveCD])
			[sender selectItemWithTag: iTM2TeXDistributionTeXLiveCDTag];
		else if([distribution isEqual: iTM2DistributionOther])
			[sender selectItemWithTag: iTM2TeXDistributionOtherTag];
		else if([distribution isEqual: iTM2DistributionCustom])
			[sender selectItemWithTag: iTM2TeXDistributionCustomTag];
		return YES;
	}
	else if([sender isKindOfClass: [NSMenuItem class]])
	{
		id representedObject;
		switch([sender tag])
		{
			default:
			case iTM2TeXDistributionDefaultTag: representedObject = iTM2DistributionDefault; break;
			case iTM2TeXDistributionBuiltInTag: representedObject = iTM2DistributionBuiltIn; break;
			case iTM2TeXDistributionGWTeXTag: representedObject = iTM2DistributiongwTeX; break;
			case iTM2TeXDistributionFinkTag: representedObject = iTM2DistributionFink; break;
			case iTM2TeXDistributionTeXLiveTag: representedObject = iTM2DistributionTeXLive; break;
			case iTM2TeXDistributionTeXLiveCDTag: representedObject = iTM2DistributionTeXLiveCD; break;
			case iTM2TeXDistributionOtherTag: representedObject = iTM2DistributionOther; break;
			case iTM2TeXDistributionCustomTag: representedObject = iTM2DistributionCustom; break;
		}
		[sender setRepresentedObject: representedObject];
		return YES;
	}
	return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeTeXMFPathFromStringValue:
- (IBAction) takeTeXMFPathFromStringValue: (id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 06:28:11 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id new = [sender stringValue];
	NSString * key = [iTM2DistributionDomainTeXMF stringByAppendingPathExtension: [SUD stringForKey: iTM2DistributionTeXMF]];
	if(![[SUD stringForKey: key] isEqual: new])
	{
		[SUD setObject: new forKey: key];
		[[self mainView] validateWindowContent];
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateTakeTeXMFPathFromStringValue:
- (BOOL) validateTakeTeXMFPathFromStringValue: (id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 06:28:11 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(![sender formatter])
		[sender setFormatter: [[[iTM2FileNameFormatter allocWithZone: [self zone]] init] autorelease]];
	NSString * distribution = [SUD stringForKey: iTM2DistributionTeXMF];
	NSString * key = [iTM2DistributionDomainTeXMF stringByAppendingPathExtension: distribution];
	NSString * path = [SUD stringForKey: key]?: @"";
	if([DFM fileExistsAtPath: path])
		[sender setStringValue: path];
	else
		[sender setAttributedStringValue: [[[NSAttributedString allocWithZone: [self zone]] initWithString: path
			attributes: [NSDictionary dictionaryWithObject: [NSColor redColor] forKey: NSForegroundColorAttributeName]] autorelease]];
	if([distribution isEqual: iTM2DistributionCustom])
		return YES;
	if(sender == [[sender window] firstResponder])
		[[sender window] makeFirstResponder: nil];
//iTM2_END;
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeTeXMFBinariesDistributionFromPopUp:
- (IBAction) takeTeXMFBinariesDistributionFromPopUp: (id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 06:28:11 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([sender isKindOfClass: [NSPopUpButton class]])
		sender = [sender selectedItem];
	if([sender isKindOfClass: [NSMenuItem class]])
	{
		BOOL isIntel = [self TeXMFBinariesDistributionIsIntel];
		id old = [SUD stringForKey: iTM2DistributionTeXMFBinaries];
		[SUD setObject: [sender representedObject] forKey: iTM2DistributionTeXMFBinaries];
		[self setTeXMFBinariesDistributionIntel: isIntel];
		id new = [SUD stringForKey: iTM2DistributionTeXMFBinaries];
		if(![old isEqual: new])
		{
			[[self mainView] validateWindowContent];
		}
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateTakeTeXMFBinariesDistributionFromPopUp:
- (BOOL) validateTakeTeXMFBinariesDistributionFromPopUp: (id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 06:28:11 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([sender isKindOfClass: [NSPopUpButton class]])
	{
		NSString * distribution = [self lossyTeXMFBinariesDistribution];
		unsigned index = [sender indexOfItemWithRepresentedObject: distribution];
		if(index < [sender numberOfItems])
			[sender selectItemAtIndex: index];
		else if([distribution isEqual: iTM2DistributionDefault])
			[sender selectItemWithTag: iTM2TeXDistributionDefaultTag];
		else if([distribution isEqual: iTM2DistributionBuiltIn])
			[sender selectItemWithTag: iTM2TeXDistributionBuiltInTag];
		else if([distribution isEqual: iTM2DistributiongwTeX])
			[sender selectItemWithTag: iTM2TeXDistributionGWTeXTag];
		else if([distribution isEqual: iTM2DistributionFink])
			[sender selectItemWithTag: iTM2TeXDistributionFinkTag];
		else if([distribution isEqual: iTM2DistributionTeXLive])
			[sender selectItemWithTag: iTM2TeXDistributionTeXLiveTag];
		else if([distribution isEqual: iTM2DistributionTeXLiveCD])
			[sender selectItemWithTag: iTM2TeXDistributionTeXLiveCDTag];
		else if([distribution isEqual: iTM2DistributionOther])
			[sender selectItemWithTag: iTM2TeXDistributionOtherTag];
		else if([distribution isEqual: iTM2DistributionCustom])
			[sender selectItemWithTag: iTM2TeXDistributionCustomTag];
		return YES;
	}
	else if([sender isKindOfClass: [NSMenuItem class]])
	{
		id representedObject;
		switch([sender tag])
		{
			default:
			case iTM2TeXDistributionDefaultTag: representedObject = iTM2DistributionDefault; break;
			case iTM2TeXDistributionBuiltInTag: representedObject = iTM2DistributionBuiltIn; break;
			case iTM2TeXDistributionGWTeXTag: representedObject = iTM2DistributiongwTeX; break;
			case iTM2TeXDistributionFinkTag: representedObject = iTM2DistributionFink; break;
			case iTM2TeXDistributionTeXLiveTag: representedObject = iTM2DistributionTeXLive; break;
			case iTM2TeXDistributionTeXLiveCDTag: representedObject = iTM2DistributionTeXLiveCD; break;
			case iTM2TeXDistributionOtherTag: representedObject = iTM2DistributionOther; break;
			case iTM2TeXDistributionCustomTag: representedObject = iTM2DistributionCustom; break;
		}
		[sender setRepresentedObject: representedObject];
		return YES;
	}
	return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeTeXMFBinariesPathFromStringValue:
- (IBAction) takeTeXMFBinariesPathFromStringValue: (id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 06:28:11 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id new = [sender stringValue];
	NSString * key = [iTM2DistributionDomainTeXMFBinaries stringByAppendingPathExtension: [SUD stringForKey: iTM2DistributionTeXMFBinaries]];
	if(![[SUD stringForKey: key] isEqual: new])
	{
		[SUD setObject: new forKey: key];
		[[self mainView] validateWindowContent];
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateTakeTeXMFBinariesPathFromStringValue:
- (BOOL) validateTakeTeXMFBinariesPathFromStringValue: (id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 06:28:11 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(![sender formatter])
		[sender setFormatter: [[[iTM2FileNameFormatter allocWithZone: [self zone]] init] autorelease]];
	NSString * distribution = [SUD stringForKey: iTM2DistributionTeXMFBinaries];
	NSString * key = [iTM2DistributionDomainTeXMFBinaries stringByAppendingPathExtension: distribution];
	NSString * path = [SUD stringForKey: key]?: @"";
	if([DFM fileExistsAtPath: path])
		[sender setStringValue: path];
	else
		[sender setAttributedStringValue: [[[NSAttributedString allocWithZone: [self zone]] initWithString: path
			attributes: [NSDictionary dictionaryWithObject: [NSColor redColor] forKey: NSForegroundColorAttributeName]] autorelease]];
	if([distribution isEqual: iTM2DistributionCustom])
		return YES;
	if(sender == [[sender window] firstResponder])
		[[sender window] makeFirstResponder: nil];
//iTM2_END;
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeGhostScriptBinariesDistributionFromPopUp:
- (IBAction) takeGhostScriptBinariesDistributionFromPopUp: (id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 06:28:11 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([sender isKindOfClass: [NSPopUpButton class]])
		sender = [sender selectedItem];
	if([sender isKindOfClass: [NSMenuItem class]])
	{
		BOOL isIntel = [self GhostScriptBinariesDistributionIsIntel];
		id old = [SUD stringForKey: iTM2DistributionGhostScriptBinaries];
		[SUD setObject: [sender representedObject] forKey: iTM2DistributionGhostScriptBinaries];
		[self setTeXMFBinariesDistributionIntel: isIntel];
		id new = [SUD stringForKey: iTM2DistributionGhostScriptBinaries];
		if(![old isEqual: new])
		{
			[[self mainView] validateWindowContent];
		}
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateTakeGhostScriptBinariesDistributionFromPopUp:
- (BOOL) validateTakeGhostScriptBinariesDistributionFromPopUp: (id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 06:28:11 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([sender isKindOfClass: [NSPopUpButton class]])
	{
		NSString * distribution = [self lossyGhostScriptBinariesDistribution];
		unsigned index = [sender indexOfItemWithRepresentedObject: distribution];
		if(index < [sender numberOfItems])
			[sender selectItemAtIndex: index];
		else if([distribution isEqual: iTM2DistributionDefault])
			[sender selectItemWithTag: iTM2TeXDistributionDefaultTag];
		else if([distribution isEqual: iTM2DistributionBuiltIn])
			[sender selectItemWithTag: iTM2TeXDistributionBuiltInTag];
		else if([distribution isEqual: iTM2DistributiongwTeX])
			[sender selectItemWithTag: iTM2TeXDistributionGWTeXTag];
		else if([distribution isEqual: iTM2DistributionFink])
			[sender selectItemWithTag: iTM2TeXDistributionFinkTag];
		else if([distribution isEqual: iTM2DistributionTeXLive])
			[sender selectItemWithTag: iTM2TeXDistributionTeXLiveTag];
		else if([distribution isEqual: iTM2DistributionTeXLiveCD])
			[sender selectItemWithTag: iTM2TeXDistributionTeXLiveCDTag];
		else if([distribution isEqual: iTM2DistributionOther])
			[sender selectItemWithTag: iTM2TeXDistributionOtherTag];
		else if([distribution isEqual: iTM2DistributionCustom])
			[sender selectItemWithTag: iTM2TeXDistributionCustomTag];
		return YES;
	}
	else if([sender isKindOfClass: [NSMenuItem class]])
	{
		id representedObject;
		switch([sender tag])
		{
			default:
			case iTM2TeXDistributionDefaultTag: representedObject = iTM2DistributionDefault; break;
			case iTM2TeXDistributionBuiltInTag: representedObject = iTM2DistributionBuiltIn; break;
			case iTM2TeXDistributionGWTeXTag: representedObject = iTM2DistributiongwTeX; break;
			case iTM2TeXDistributionFinkTag: representedObject = iTM2DistributionFink; break;
			case iTM2TeXDistributionTeXLiveTag: representedObject = iTM2DistributionTeXLive; break;
			case iTM2TeXDistributionTeXLiveCDTag: representedObject = iTM2DistributionTeXLiveCD; break;
			case iTM2TeXDistributionOtherTag: representedObject = iTM2DistributionOther; break;
			case iTM2TeXDistributionCustomTag: representedObject = iTM2DistributionCustom; break;
		}
		[sender setRepresentedObject: representedObject];
		return YES;
	}
	return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeGhostScriptBinariesPathFromStringValue:
- (IBAction) takeGhostScriptBinariesPathFromStringValue: (id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 06:28:11 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id new = [sender stringValue];
	NSString * key = [iTM2DistributionDomainGhostScriptBinaries stringByAppendingPathExtension: [SUD stringForKey: iTM2DistributionGhostScriptBinaries]];
	if(![[SUD stringForKey: key] isEqual: new])
	{
		[SUD setObject: new forKey: key];
		[[self mainView] validateWindowContent];
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateTakeGhostScriptBinariesPathFromStringValue:
- (BOOL) validateTakeGhostScriptBinariesPathFromStringValue: (id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 06:28:11 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(![sender formatter])
		[sender setFormatter: [[[iTM2FileNameFormatter allocWithZone: [self zone]] init] autorelease]];
	NSString * distribution = [SUD stringForKey: iTM2DistributionGhostScriptBinaries];
	NSString * key = [iTM2DistributionDomainGhostScriptBinaries stringByAppendingPathExtension: distribution];
	NSString * path = [SUD stringForKey: key]?: @"";
	if([DFM fileExistsAtPath: path])
		[sender setStringValue: path];
	else
		[sender setAttributedStringValue: [[[NSAttributedString allocWithZone: [self zone]] initWithString: path
			attributes: [NSDictionary dictionaryWithObject: [NSColor redColor] forKey: NSForegroundColorAttributeName]] autorelease]];
	if([distribution isEqual: iTM2DistributionCustom])
		return YES;
	if(sender == [[sender window] firstResponder])
		[[sender window] makeFirstResponder: nil];
//iTM2_END;
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleTeXMFBinariesCPUType:
- (IBAction) toggleTeXMFBinariesCPUType: (id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self setTeXMFBinariesDistributionIntel: ![self TeXMFBinariesDistributionIsIntel]];
	[[self mainView] validateWindowContent];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleTeXMFBinariesCPUType:
- (BOOL) validateToggleTeXMFBinariesCPUType: (id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(![NSBundle isI386])
	{
		[sender setAction: NULL];
		[sender setHidden: YES];
		return YES;
	}
	if([[SUD stringForKey: iTM2DistributionTeXMFBinaries] isEqual: iTM2DistributionCustom])
	{
		[sender setState: NSMixedState];
		return NO;
	}
	[sender setState: ([self TeXMFBinariesDistributionIsIntel]?NSOnState: NSOffState)];
//iTM2_END;
	return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleGhostScriptBinariesCPUType:
- (IBAction) toggleGhostScriptBinariesCPUType: (id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self setGhostScriptBinariesDistributionIntel: ![self GhostScriptBinariesDistributionIsIntel]];
	[[self mainView] validateWindowContent];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleGhostScriptBinariesCPUType:
- (BOOL) validateToggleGhostScriptBinariesCPUType: (id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(![NSBundle isI386])
	{
		[sender setAction: NULL];
		[sender setHidden: YES];
		return YES;
	}
	if([[SUD stringForKey: iTM2DistributionGhostScriptBinaries] isEqual: iTM2DistributionCustom])
	{
		[sender setState: NSMixedState];
		return NO;
	}
	[sender setState: ([self GhostScriptBinariesDistributionIsIntel]?NSOnState: NSOffState)];
//iTM2_END;
	return YES;
}
@end

@implementation NSApplication(iTM2TeXDistributionKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  showTeXDistributionPreferences:
- (IBAction) showTeXDistributionPreferences: (id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
#warning NYI: MISSING
//iTM2_END;
	return;
}
@end


#if 0
@interface NSMenuItem_TeXDistributionKit: NSMenuItem
@end
@implementation NSMenuItem_TeXDistributionKit
+(void)xload;
{[self poseAsClass: [NSMenuItem class]];}
-(void) setAction: (SEL) action;
{
	if([self action] == @selector(_popUpItemAction:))
		NSLog(@"BOULOUBOULOU--");
	iTM2_LOG(@"self: %@, old: %@, new: %@", self, NSStringFromSelector([self action]), NSStringFromSelector(action));
	[super setAction: action];
}
@end
#endif
