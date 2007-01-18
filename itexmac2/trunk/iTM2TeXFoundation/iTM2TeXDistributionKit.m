/*
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
NSString * const iTM2DistributionTeXMFPrograms = @"iTM2DistributionTeXMFBinaries";
NSString * const iTM2DistributionOtherPrograms = @"iTM2DistributionGhostScriptBinaries";

NSString * const iTM2DistributionDefault = @"default";
NSString * const iTM2DistributionBuiltIn = @"built-in";// Not yet used
NSString * const iTM2DistributionDefaultTeXDist = @"Default TeX Distribution";// from TeXDist design
NSString * const iTM2DistributionOldgwTeX = @"gwTeX";// from iinstaller
NSString * const iTM2DistributiongwTeX = @"gwTeXLive";// from iinstaller
NSString * const iTM2DistributionFink = @"fink";
NSString * const iTM2DistributionTeXLive = @"TeX Live";
NSString * const iTM2DistributionTeXLiveDVD = @"TeX Live DVD";
NSString * const iTM2DistributionDefaultTeXDistIntel = @"Default TeX Distribution(Intel)";// from TeXDist design
NSString * const iTM2DistributionOldgwTeXIntel = @"gwTeX(Intel)";// from iinstaller
NSString * const iTM2DistributiongwTeXIntel = @"gwTeXLive(Intel)";// from iinstaller
NSString * const iTM2DistributionFinkIntel = @"fink(Intel)";
NSString * const iTM2DistributionTeXLiveIntel = @"TeX Live(Intel)";
NSString * const iTM2DistributionTeXLiveDVDIntel = @"TeX Live DVD(Intel)";
NSString * const iTM2DistributionOther = @"other";
NSString * const iTM2DistributionCustom = @"custom";

NSString * const iTM2DistributionDomainTeXMF = @"iTM2DistributionDomainTeXMF";
NSString * const iTM2DistributionDomainTeXMFPrograms = @"iTM2DistributionDomainTeXMFBinaries";
NSString * const iTM2DistributionDomainOtherPrograms = @"iTM2DistributionDomainOtherBinaries";
NSString * const iTM2DistributionDomainChostScriptPrograms = @"iTM2DistributionDomainGhostScriptBinaries";

// those should be deprecated because I can retrieve those paths from the TeXMF tree
NSString * const iTM2DistributionDomainTeXMFDocumentation = @"iTM2DistributionDomainTeXMFDocumentation";
NSString * const iTM2DistributionDomainTeXMFHelp = @"iTM2DistributionDomainTeXMFHelp";
NSString * const iTM2DistributionDomainTeXMFFAQs = @"iTM2DistributionDomainTeXMFFAQs";

NSString * const iTM2DistributionsComponent = @"PATHs";
NSString * const iTM2DistributionSDictionaryKey = @"PATHs dictionary";

@implementation iTM2MainInstaller(iTM2TeXProjectTaskKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-==  load
+ (void)load;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To do list:
"*/
{iTM2_DIAGNOSTIC;
	iTM2_INIT_POOL;
	[NSBundle redirectNSLogOutput];
//iTM2_START;
	[iTM2MileStone registerMileStone:@"The PATHs.plist is missing" forKey:@"PATHs and TeX Distributions"];
//iTM2_END;
	iTM2_RELEASE_POOL;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-==  iTM2TeXProjectTaskKitCompleteInstallation;
+ (void)iTM2TeXProjectTaskKitCompleteInstallation;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To do list:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id distribution = [NSBundle isI386]? iTM2DistributionDefaultTeXDistIntel: iTM2DistributionDefaultTeXDist;
    [SUD registerDefaults: [NSDictionary dictionaryWithObjectsAndKeys:
					distribution, iTM2DistributionTeXMF,
					distribution, iTM2DistributionTeXMFPrograms,
					distribution, iTM2DistributionOtherPrograms,
                                    nil]];
#ifdef __iTM2_BUG_TRACKING__
	#warning *** BUG TRACKING
#else
	id _iTM2PathsDictionary = [NSMutableDictionary dictionary];
	NSEnumerator * E = [[[NSBundle mainBundle]
		allPathsForResource: iTM2DistributionsComponent ofType: @"plist" inDirectory: nil] reverseObjectEnumerator];
    NSString * path;
    while(path = [E nextObject])
    {
        NSDictionary * D = [NSDictionary dictionaryWithContentsOfFile:path];
        if([D count] && ![[D objectForKey:@"isa"] pathIsEqual:iTM2DistributionSDictionaryKey])
            [_iTM2PathsDictionary addEntriesFromDictionary:D];
		else if(iTM2DebugEnabled)
		{
			iTM2_LOG(@"Bad file or dictionary at path", path);
		}
    }
	[SUD registerDefaults:_iTM2PathsDictionary];
	if(iTM2DebugEnabled>100)
	{
		iTM2_LOG(@"_iTM2PathsDictionary is: %@", _iTM2PathsDictionary);
	}
	// then I make some diagnostic... to be sure that the chosen distribution is available
	// this is working at a SUD level
	// we must make some diagnostic at a project level too
	BOOL distributionWasNotCorrect = NO;
	BOOL distributionIsStillNotCorrect = NO;
#if 0
	the TeXMF path has no meaning, the programs can find the path by themselves
	path = [iTM2TeXProjectDocument defaultTeXMFPath];
	if([DFM fileExistsAtPath:path])
		goto testTeXMFPrograms;// that's OK
	distributionWasNotCorrect = YES;
	[SUD setObject:iTM2DistributionBuiltIn forKey:iTM2DistributionTeXMF];
	path = [iTM2TeXProjectDocument defaultTeXMFPath];
	if([DFM fileExistsAtPath:path])
		goto testTeXMFPrograms;// that's OK
	[SUD setObject:iTM2DistributiongwTeX forKey:iTM2DistributionTeXMF];
	path = [iTM2TeXProjectDocument defaultTeXMFPath];
	if([DFM fileExistsAtPath:path])
		goto testTeXMFPrograms;// that's OK
	[SUD setObject:iTM2DistributionOldgwTeX forKey:iTM2DistributionTeXMF];
	path = [iTM2TeXProjectDocument defaultTeXMFPath];
	if([DFM fileExistsAtPath:path])
		goto testTeXMFPrograms;// that's OK
	[SUD setObject:iTM2DistributionFink forKey:iTM2DistributionTeXMF];
	path = [iTM2TeXProjectDocument defaultTeXMFPath];
	if([DFM fileExistsAtPath:path])
		goto testTeXMFPrograms;// that's OK
	[SUD setObject:iTM2DistributionTeXLive forKey:iTM2DistributionTeXMF];
	path = [iTM2TeXProjectDocument defaultTeXMFPath];
	if([DFM fileExistsAtPath:path])
		goto testTeXMFPrograms;// that's OK
	[SUD setObject:iTM2DistributionTeXLiveDVD forKey:iTM2DistributionTeXMF];
	path = [iTM2TeXProjectDocument defaultTeXMFPath];
	if([DFM fileExistsAtPath:path])
		goto testTeXMFPrograms;// that's OK
	[SUD setObject:iTM2DistributionCustom forKey:iTM2DistributionTeXMF];
	path = [iTM2TeXProjectDocument defaultTeXMFPath];
	if([DFM fileExistsAtPath:path])
		goto testTeXMFPrograms;// that's OK
	// I have to inform the user that his configuration is not correct...
	distributionIsStillNotCorrect = YES;
testTeXMFPrograms:
#endif
	path = [iTM2TeXProjectDocument defaultTeXMFProgramsPath];
	if([DFM fileExistsAtPath:path])
		goto testOtherPrograms;// that's OK
	distributionWasNotCorrect = YES;
	if([NSBundle isI386])
	{
		[SUD setObject:iTM2DistributionDefaultTeXDistIntel forKey:iTM2DistributionTeXMFPrograms];
		path = [iTM2TeXProjectDocument defaultTeXMFProgramsPath];
		if([DFM fileExistsAtPath:path])
			goto testOtherPrograms;// that's OK
		[SUD setObject:iTM2DistributiongwTeXIntel forKey:iTM2DistributionTeXMFPrograms];
		path = [iTM2TeXProjectDocument defaultTeXMFProgramsPath];
		if([DFM fileExistsAtPath:path])
			goto testOtherPrograms;// that's OK
		[SUD setObject:iTM2DistributionOldgwTeXIntel forKey:iTM2DistributionTeXMFPrograms];
		path = [iTM2TeXProjectDocument defaultTeXMFProgramsPath];
		if([DFM fileExistsAtPath:path])
			goto testOtherPrograms;// that's OK
		[SUD setObject:iTM2DistributionTeXLiveIntel forKey:iTM2DistributionTeXMFPrograms];
		path = [iTM2TeXProjectDocument defaultTeXMFProgramsPath];
		if([DFM fileExistsAtPath:path])
			goto testOtherPrograms;// that's OK
		[SUD setObject:iTM2DistributionOldgwTeXIntel forKey:iTM2DistributionTeXMFPrograms];
		path = [iTM2TeXProjectDocument defaultTeXMFProgramsPath];
		if([DFM fileExistsAtPath:path])
			goto testOtherPrograms;// that's OK
		[SUD setObject:iTM2DistributionTeXLiveIntel forKey:iTM2DistributionTeXMFPrograms];
		path = [iTM2TeXProjectDocument defaultTeXMFProgramsPath];
		if([DFM fileExistsAtPath:path])
			goto testOtherPrograms;// that's OK
		[SUD setObject:iTM2DistributionTeXLiveDVDIntel forKey:iTM2DistributionTeXMFPrograms];
	}
	[SUD setObject:iTM2DistributionOldgwTeX forKey:iTM2DistributionTeXMFPrograms];
	path = [iTM2TeXProjectDocument defaultTeXMFProgramsPath];
	if([DFM fileExistsAtPath:path])
		goto testOtherPrograms;// that's OK
	[SUD setObject:iTM2DistributionTeXLive forKey:iTM2DistributionTeXMFPrograms];
	path = [iTM2TeXProjectDocument defaultTeXMFProgramsPath];
	if([DFM fileExistsAtPath:path])
		goto testOtherPrograms;// that's OK
	[SUD setObject:iTM2DistributiongwTeX forKey:iTM2DistributionTeXMFPrograms];
	path = [iTM2TeXProjectDocument defaultTeXMFProgramsPath];
	if([DFM fileExistsAtPath:path])
		goto testOtherPrograms;// that's OK
	[SUD setObject:iTM2DistributionOldgwTeX forKey:iTM2DistributionTeXMFPrograms];
	path = [iTM2TeXProjectDocument defaultTeXMFProgramsPath];
	if([DFM fileExistsAtPath:path])
		goto testOtherPrograms;// that's OK
	[SUD setObject:iTM2DistributionFink forKey:iTM2DistributionTeXMFPrograms];
	path = [iTM2TeXProjectDocument defaultTeXMFProgramsPath];
	if([DFM fileExistsAtPath:path])
		goto testOtherPrograms;// that's OK
	[SUD setObject:iTM2DistributionTeXLiveDVD forKey:iTM2DistributionTeXMFPrograms];
	path = [iTM2TeXProjectDocument defaultTeXMFProgramsPath];
	if([DFM fileExistsAtPath:path])
		goto testOtherPrograms;// that's OK
	[SUD setObject:iTM2DistributionCustom forKey:iTM2DistributionTeXMFPrograms];
	path = [iTM2TeXProjectDocument defaultTeXMFProgramsPath];
	if([DFM fileExistsAtPath:path])
		goto testOtherPrograms;// that's OK
	// I have to inform the user that his configuration is not correct...
	distributionIsStillNotCorrect = YES;
testOtherPrograms:
	path = [iTM2TeXProjectDocument defaultOtherProgramsPath];
	if([DFM fileExistsAtPath:path])
		goto conclusion;// that's OK
	distributionWasNotCorrect = YES;
	[SUD setObject:iTM2DistributionBuiltIn forKey:iTM2DistributionOtherPrograms];
	path = [iTM2TeXProjectDocument defaultOtherProgramsPath];
	if([DFM fileExistsAtPath:path])
		goto conclusion;// that's OK
	if([NSBundle isI386])
	{
		[SUD setObject:iTM2DistributiongwTeXIntel forKey:iTM2DistributionOtherPrograms];
		path = [iTM2TeXProjectDocument defaultOtherProgramsPath];
		if([DFM fileExistsAtPath:path])
			goto conclusion;// that's OK
		[SUD setObject:iTM2DistributionOldgwTeXIntel forKey:iTM2DistributionOtherPrograms];
		path = [iTM2TeXProjectDocument defaultOtherProgramsPath];
		if([DFM fileExistsAtPath:path])
			goto conclusion;// that's OK
		[SUD setObject:iTM2DistributionTeXLiveIntel forKey:iTM2DistributionOtherPrograms];
		path = [iTM2TeXProjectDocument defaultOtherProgramsPath];
		if([DFM fileExistsAtPath:path])
			goto conclusion;// that's OK
		[SUD setObject:iTM2DistributionOldgwTeXIntel forKey:iTM2DistributionOtherPrograms];
		path = [iTM2TeXProjectDocument defaultOtherProgramsPath];
		if([DFM fileExistsAtPath:path])
			goto conclusion;// that's OK
		[SUD setObject:iTM2DistributionTeXLiveDVDIntel forKey:iTM2DistributionOtherPrograms];
		path = [iTM2TeXProjectDocument defaultOtherProgramsPath];
		if([DFM fileExistsAtPath:path])
			goto conclusion;// that's OK
	}
	[SUD setObject:iTM2DistributiongwTeXIntel forKey:iTM2DistributionOtherPrograms];
	path = [iTM2TeXProjectDocument defaultOtherProgramsPath];
	if([DFM fileExistsAtPath:path])
		goto conclusion;// that's OK
	[SUD setObject:iTM2DistributionOldgwTeXIntel forKey:iTM2DistributionOtherPrograms];
	path = [iTM2TeXProjectDocument defaultOtherProgramsPath];
	if([DFM fileExistsAtPath:path])
		goto conclusion;// that's OK
	[SUD setObject:iTM2DistributionOldgwTeX forKey:iTM2DistributionOtherPrograms];
	path = [iTM2TeXProjectDocument defaultOtherProgramsPath];
	if([DFM fileExistsAtPath:path])
		goto conclusion;// that's OK
	[SUD setObject:iTM2DistributionFink forKey:iTM2DistributionOtherPrograms];
	path = [iTM2TeXProjectDocument defaultOtherProgramsPath];
	if([DFM fileExistsAtPath:path])
		goto conclusion;// that's OK
	[SUD setObject:iTM2DistributionTeXLive forKey:iTM2DistributionOtherPrograms];
	path = [iTM2TeXProjectDocument defaultOtherProgramsPath];
	if([DFM fileExistsAtPath:path])
		goto conclusion;// that's OK
	[SUD setObject:iTM2DistributionTeXLiveDVD forKey:iTM2DistributionOtherPrograms];
	path = [iTM2TeXProjectDocument defaultOtherProgramsPath];
	if([DFM fileExistsAtPath:path])
		goto conclusion;// that's OK
	[SUD setObject:iTM2DistributionCustom forKey:iTM2DistributionOtherPrograms];
	path = [iTM2TeXProjectDocument defaultOtherProgramsPath];
	if([DFM fileExistsAtPath:path])
		goto conclusion;// that's OK
	// I have to inform the user that his configuration is not correct...
	distributionIsStillNotCorrect = YES;
conclusion:
	if(distributionIsStillNotCorrect)
		[iTM2TeXProjectDocument performSelector:@selector(notifyDefaultDistributionUnfixedError:) withObject:nil afterDelay:0.01];
	else if(distributionWasNotCorrect)
		[iTM2TeXProjectDocument performSelector:@selector(notifyDefaultDistributionFixedWarning:) withObject:nil afterDelay:0.01];
	[iTM2MileStone putMileStoneForKey:@"PATHs and TeX Distributions"];
#endif
//iTM2_END;
    return;
}
@end

NSString * const iTM2DistributionEnvironmentKey = @"TeXDistribution";
#define iVarDistributionEnvironment modelValueForKey: iTM2DistributionEnvironmentKey ofType: iTM2ProjectFrontendType

NSString * const iTM2DistributionUseOutputDirectoryKey = @"iTM2DistributionUseTEXMFOUTPUT";
NSString * const iTM2DistributionOutputDirectoryKey = @"iTM2DistributionTEXMFOUTPUT";
NSString * const iTM2DistributionUsePATHLoginShellKey = @"iTM2DistributionUsePATHLoginShell";
NSString * const iTM2DistributionUsePATHPrefixKey = @"iTM2DistributionUsePATHPrefix";
NSString * const iTM2DistributionPATHPrefixKey = @"iTM2DistributionPATHPrefix";
NSString * const iTM2DistributionUsePATHSuffixKey = @"iTM2DistributionUsePATHSuffix";
NSString * const iTM2DistributionPATHSuffixKey = @"iTM2DistributionPATHSuffix";

@implementation iTM2TeXProjectDocument(TeXDistributionKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  TeXDistributionFixImplementation
- (void)TeXDistributionFixImplementation;
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
	O = [IMPLEMENTATION modelValueForKey:KEY ofType:iTM2ProjectFrontendType];\
	if([O isKindOfClass:[NSDictionary class]])\
		[IMPLEMENTATION takeModelValue:[NSMutableDictionary dictionaryWithDictionary:O] forKey:KEY ofType:iTM2ProjectFrontendType];\
	else\
		[IMPLEMENTATION takeModelValue:[NSMutableDictionary dictionary] forKey:KEY ofType:iTM2ProjectFrontendType];
	CREATE(iTM2DistributionEnvironmentKey);
	#undef CREATE
//iTM2_LOG(@"[self implementation] is: %@", [self implementation]);
//iTM2_LOG(@"[[self implementation] iVarDistributionEnvironment] is: %@", [[self implementation] iVarDistributionEnvironment]);
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  TeXDistributionCompleteDidReadFromFile:ofType:
- (void)TeXDistributionCompleteDidReadFromFile:(NSString *)fileName ofType:(NSString *)type;
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
- (NSString *)commonCommandOutputDirectory;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [[IMPLEMENTATION iVarDistributionEnvironment] objectForKey:iTM2DistributionUseOutputDirectoryKey]? 
	([[IMPLEMENTATION iVarDistributionEnvironment] objectForKey:iTM2DistributionOutputDirectoryKey]?: @""):
		([[self fileName] stringByAppendingPathComponent:[[self relativeFileNameForKey:[self masterFileKey]] stringByDeletingLastPathComponent]]?: @"");
}
#pragma mark =-=-=-=-=-=-  DISTRIBUTIONS
#define DISTRIBUTION(getter, setter)\
- (NSString *)getter;\
{\
	NSString * result = [[[self implementation] iVarDistributionEnvironment] objectForKey:iTM2KeyFromSelector(_cmd)];\
	return [result length]? result: iTM2DistributionDefault;\
}\
- (void)setter:(NSString *)argument;\
{\
	if(argument)\
		[[[self implementation] iVarDistributionEnvironment] setObject:argument forKey:iTM2KeyFromSelector(_cmd)];\
	else\
		[[[self implementation] iVarDistributionEnvironment] removeObjectForKey:iTM2KeyFromSelector(_cmd)];\
	return;\
}
DISTRIBUTION(TeXMFDistribution, setTeXMFDistribution)
DISTRIBUTION(TeXMFProgramsDistribution, setTeXMFProgramsDistribution)
DISTRIBUTION(OtherProgramsDistribution, setOtherProgramsDistribution)
DISTRIBUTION(GhostScriptProgramsDistribution, setGhostScriptProgramsDistribution)
DISTRIBUTION(TeXMFPath, setTeXMFPath)
DISTRIBUTION(TeXMFProgramsPath, setTeXMFProgramsPath)
DISTRIBUTION(OtherProgramsPath, setOtherProgramsPath)
#undef DISTRIBUTION
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  getTeXMFProgramsPath
- (NSString *)getTeXMFProgramsPath;
/*"Higher level getter.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * distribution = [self TeXMFProgramsDistribution];
	if([distribution isEqualToString:iTM2DistributionDefault])
	{
		return [[self class] defaultTeXMFProgramsPath];
	}
	else if([distribution isEqualToString:iTM2DistributionCustom])
	{
		return [self TeXMFProgramsPath];
	}
	else
	{
		NSString * key = [iTM2DistributionDomainTeXMFPrograms stringByAppendingPathExtension:distribution];
		NSString * result = [SUD stringForKey:key];
		return [result length]? result:[[self class] defaultTeXMFProgramsPath];
	}
//iTM2_END;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  getTeXMFPath
- (NSString *)getTeXMFPath;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * distribution = [self TeXMFDistribution];
	if([distribution isEqualToString:iTM2DistributionDefault])
	{
		return [[self class] defaultTeXMFPath];
	}
	else if([distribution isEqualToString:iTM2DistributionCustom])
	{
		return [self TeXMFPath];
	}
	else
	{
		NSString * key = [iTM2DistributionDomainTeXMF stringByAppendingPathExtension:distribution];
		NSString * result = [SUD stringForKey:key];
		return [result length]? result:[[self class] defaultTeXMFPath];
	}
//iTM2_END;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  getOtherProgramsPath
- (NSString *)getOtherProgramsPath;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * distribution = [self GhostScriptProgramsDistribution];
	if(distribution)
	{
		[self setOtherProgramsDistribution:distribution];
		[self setGhostScriptProgramsDistribution:nil];
	}
	distribution = [self OtherProgramsDistribution];
	if([distribution isEqualToString:iTM2DistributionDefault])
	{
		return [[self class] defaultOtherProgramsPath];
	}
	else if([distribution isEqualToString:iTM2DistributionCustom])
	{
		return [self OtherProgramsPath];
	}
	else
	{
	// I have to manage what once was "GhostScript" and became "Other"
		NSString * key = [iTM2DistributionDomainOtherPrograms stringByAppendingPathExtension:distribution];
		NSString * result = [SUD stringForKey:key];
		if([result length])
		{
			return result;
		}
		NSString * oldKey = [iTM2DistributionDomainOtherPrograms stringByAppendingPathExtension:distribution];
		result = [SUD stringForKey:oldKey];
		if([result length])
		{
			[SUD setObject:result forKey:key];
			return result;
		}
		return [[self class] defaultOtherProgramsPath];
	}
//iTM2_END;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  defaultTeXMFPath
+ (NSString *)defaultTeXMFPath;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * distribution = [SUD stringForKey:iTM2DistributionTeXMF];
	if(![distribution length])
	{
		iTM2_LOG(@"...........  HUGE ERROR: Missing TeXMF distribution reference in preferences, report bug");
		return @"Missing TeXMF ";
	}
	else if(iTM2DebugEnabled)
	{
		iTM2_LOG(@"distribution:%@",distribution);
	}
	NSString * key = [iTM2DistributionDomainTeXMF stringByAppendingPathExtension:distribution];
	NSString * result = [SUD stringForKey:key];
	if(![result length])
	{
		iTM2_LOG(@"...........  HUGE ERROR: Missing TeXMF %@ distribution path in preferences, report bug", distribution);
		return @"Missing TeXMF Distribution Path";
	}
//iTM2_END;
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  defaultTeXMFProgramsPath
+ (NSString *)defaultTeXMFProgramsPath;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * distribution = [SUD stringForKey:iTM2DistributionTeXMFPrograms];
	if(![distribution length])
	{
		iTM2_LOG(@"...........  HUGE ERROR: Missing TeXMF binaries distribution reference in preferences, report bug");
		return @"Missing TeXMF Programs ";
	}
	else if(iTM2DebugEnabled)
	{
		iTM2_LOG(@"distribution:%@",distribution);
	}
	NSString * key = [iTM2DistributionDomainTeXMFPrograms stringByAppendingPathExtension:distribution];
	NSString * result = [SUD stringForKey:key];
	if(![result length])
	{
		iTM2_LOG(@"...........  HUGE ERROR: Missing TeXMF binaries %@ distribution path in preferences, report bug", distribution);
		return @"Missing TeXMF Programs Distribution Path";
	}
//iTM2_END;
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  defaultOtherProgramsPath
+ (NSString *)defaultOtherProgramsPath;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * distribution = [SUD stringForKey:iTM2DistributionOtherPrograms];
	if(![distribution length])
	{
		distribution = [SUD stringForKey:iTM2DistributionOtherPrograms];
		if(![distribution length])
		{
			[SUD setObject:distribution forKey:iTM2DistributionOtherPrograms];
			iTM2_LOG(@"...........  HUGE ERROR: Missing Other binaries distribution reference in preferences, report bug");
			return @"Missing Other Programs ";
		}
	}
	else if(iTM2DebugEnabled)
	{
		iTM2_LOG(@"distribution:%@",distribution);
	}
	NSString * key = [iTM2DistributionDomainOtherPrograms stringByAppendingPathExtension:distribution];
	NSString * result = [SUD stringForKey:key];
	if(![result length])
	{
		NSString * oldKey = [iTM2DistributionDomainOtherPrograms stringByAppendingPathExtension:distribution];
		result = [SUD stringForKey:oldKey];
		if([result length])
		{
			[SUD setObject:result forKey:key];
		}
		else
		{
			iTM2_LOG(@"...........  HUGE ERROR: Missing Other binaries %@ distribution path in preferences, report bug", distribution);
			return @"Missing Other Programs Distribution Path";
		}
	}
//iTM2_END;
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  distributionsCompleteDidReadFromFile:ofType:
- (void)distributionsCompleteDidReadFromFile:(NSString *)fileName ofType:(NSString *)type;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	// testing the distributions
#if 0
	if(([[self TeXMFDistribution] isEqualToString:iTM2DistributionDefault] || [DFM fileExistsAtPath:[self TeXMFPath]])
		&& ([[self TeXMFProgramsDistribution] isEqualToString:iTM2DistributionDefault] || [DFM fileExistsAtPath:[self TeXMFProgramsPath]])
		&& ([[self OtherProgramsDistribution] isEqualToString:iTM2DistributionDefault] || [DFM fileExistsAtPath:[self OtherProgramsPath]]))
	{
		return;
	}
#else
	// the same code splitted for debugging purpose
	NSString * distribution = [self TeXMFDistribution];
	NSString * path = [self TeXMFPath];
	if(![distribution isEqualToString:iTM2DistributionCustom] || [DFM fileExistsAtPath:path])
		return;
	distribution = [self TeXMFProgramsDistribution];
	path = [self TeXMFProgramsPath];
	if(![distribution isEqualToString:iTM2DistributionCustom] || [DFM fileExistsAtPath:path])
		return;
	distribution = [self OtherProgramsDistribution];
	path = [self OtherProgramsPath];
	if(![distribution isEqualToString:iTM2DistributionCustom] || [DFM fileExistsAtPath:path])
		return;
#endif
	[self performSelector:@selector(notifyUncompleteDistributionWarning:) withObject:nil afterDelay:0.01];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  notifyUncompleteDistributionWarning:
- (void)notifyUncompleteDistributionWarning:(id)irrelevant;
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
+ (void)notifyDefaultDistributionFixedWarning:(id)irrelevant;
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
+ (void)notifyDefaultDistributionUnfixedError:(id)irrelevant;
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  getPATHUsesLoginShell
- (BOOL)getPATHUsesLoginShell;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id environment = [[self implementation] iVarDistributionEnvironment];
	NSNumber * N = [environment objectForKey:iTM2DistributionUsePATHLoginShellKey];
	return N? [N boolValue]:[SUD boolForKey:iTM2DistributionUsePATHLoginShellKey];
//iTM2_END;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  getPATHPrefix
- (NSString *)getPATHPrefix;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * projectPrefix = @"";
	id environment = [[self implementation] iVarDistributionEnvironment];
	NSNumber * N = [environment objectForKey:iTM2DistributionUsePATHPrefixKey];
	BOOL flag = N?[N boolValue]:[SUD boolForKey:iTM2DistributionUsePATHPrefixKey];
	if(flag)
	{
		projectPrefix = [environment objectForKey:iTM2DistributionPATHPrefixKey]?: @"";
		NSString * SUDPrefix = [SUD objectForKey:iTM2DistributionPATHPrefixKey]?: @"";
		if([projectPrefix length])
		{
			if([SUDPrefix length])
			{
				return [NSString stringWithFormat:@"%@:%@", projectPrefix, SUDPrefix];
			}
			else
				return projectPrefix;
		}
		else
			return SUDPrefix;
	}
	else
		return projectPrefix;
//iTM2_END;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  getPATHSuffix
- (NSString *)getPATHSuffix;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * projectSuffix = @"";
	id environment = [[self implementation] iVarDistributionEnvironment];
	NSNumber * N = [environment objectForKey:iTM2DistributionUsePATHSuffixKey];
	BOOL flag = N?[N boolValue]:[SUD boolForKey:iTM2DistributionUsePATHSuffixKey];
	if(flag)
	{
		projectSuffix = [environment objectForKey:iTM2DistributionPATHSuffixKey]?: @"";
		NSString * SUDSuffix = [SUD objectForKey:iTM2DistributionPATHSuffixKey]?: @"";
		if([projectSuffix length])
		{
			if([SUDSuffix length])
			{
				return [NSString stringWithFormat:@"%@:%@", projectSuffix, SUDSuffix];
			}
			else
				return projectSuffix;
		}
		else
			return SUDSuffix;
	}
	else
		return projectSuffix;
//iTM2_END;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  getTEXMFOUTPUT
- (NSString *)getTEXMFOUTPUT;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id environment = [[self implementation] iVarDistributionEnvironment];
	if([[environment objectForKey:iTM2DistributionUseOutputDirectoryKey] boolValue])
		return [environment objectForKey:iTM2DistributionOutputDirectoryKey]?: @"";
	if([SUD boolForKey:iTM2DistributionUseOutputDirectoryKey])
		return [SUD objectForKey:iTM2DistributionOutputDirectoryKey]?: @"";
	return @"";
//iTM2_END;
}
@end

#pragma mark -

NSString * const iTM2PDFTEXLogHeaderKey = @"iTM2PDFTEXLogHeader";
NSString * const iTM2TEXLogHeaderKey = @"iTM2TEXLogHeader";

@implementation iTM2TeXDistributionController
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initialize
+ (void)initialize;
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
+ (NSString *)formatsPath;
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
		[TW setLaunchPath:@"/bin/sh"];
		[TW addArgument:@"-c"];
		[TW addArgument:@"kpsewhich tex.fmt"];
//		[TW complete];
		iTM2TaskController * TC = [[[iTM2TaskController allocWithZone:[self zone]] init] autorelease];
		[TC addTaskWrapper:TW];
		[TC start];
//		[[TC currentTask] waitUntilExit];
		path = [[[TC output] stringByDeletingLastPathComponent] copy];
	}
//iTM2_END;
	return path?:@"";
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  fmtsAtPath:
+ (NSDictionary *)fmtsAtPath:(NSString *)path;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	BOOL isDirectory;
	if(![DFM fileExistsAtPath:path isDirectory: &isDirectory] || !isDirectory)
		return nil;
	// We list the contents of the given directory
	NSEnumerator * E = [[DFM directoryContentsAtPath:path] objectEnumerator];
	NSString * P;
	NSMutableArray * TeXs = [NSMutableArray array];
	NSMutableArray * PDFTeXs = [NSMutableArray array];
	NSMutableArray * Others = [NSMutableArray array];
	NSString * TeXLogHeader = [SUD objectForKey:iTM2TEXLogHeaderKey];
	NSString * PDFTeXLogHeader = [SUD objectForKey:iTM2PDFTEXLogHeaderKey];
	while(P = [E nextObject])
	{
		if([[P pathExtension] pathIsEqual:@"fmt"])
		{
			NSString * fullPath = [path stringByAppendingPathComponent:P];
			NSString * linkTarget = [DFM pathContentOfSymbolicLinkAtPath:fullPath];
			NSString * coreName = [(linkTarget? linkTarget:fullPath) stringByDeletingPathExtension];
			NSString * logPath = [coreName stringByAppendingPathExtension:@"log"];
			NSString * S = [NSString stringWithContentsOfFile:logPath];
			if([S hasPrefix:TeXLogHeader])
				[TeXs addObject:[P stringByDeletingPathExtension]];
			else if([S hasPrefix:PDFTeXLogHeader])
				[PDFTeXs addObject:[P stringByDeletingPathExtension]];
			else
				[Others addObject:[P stringByDeletingPathExtension]];
		}
	}
	return [NSDictionary dictionaryWithObjectsAndKeys:
		TeXs, @"TeX",
		PDFTeXs, @"PDFTeX",
		Others, @"Other",
			nil];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  basesAtPath:
+ (NSArray *)basesAtPath:(NSString *)path;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	BOOL isDirectory;
	if(![DFM fileExistsAtPath:path isDirectory: &isDirectory] || !isDirectory)
		return nil;
	// We list the contents of the given directory
	NSEnumerator * E = [[DFM directoryContentsAtPath:path] objectEnumerator];
	NSString * P;
	NSMutableArray * bases = [NSMutableArray array];
	while(P = [E nextObject])
		if([[P pathExtension] pathIsEqual:@"base"])
			[bases addObject:[P stringByDeletingPathExtension]];
	return bases;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  memsAtPath:
+ (NSArray *)memsAtPath:(NSString *)path;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	BOOL isDirectory;
	if(![DFM fileExistsAtPath:path isDirectory: &isDirectory] || !isDirectory)
		return nil;
	// We list the contents of the given directory
	NSEnumerator * E = [[DFM directoryContentsAtPath:path] objectEnumerator];
	NSString * P;
	NSMutableArray * mems = [NSMutableArray array];
	while(P = [E nextObject])
		if([[P pathExtension] pathIsEqual:@"mem"])
			[mems addObject:[P stringByDeletingPathExtension]];
	return mems;
}
@end

#pragma mark -
#import "iTM2TeXProjectCommandKit.h"
@interface iTM2TeXPCommandsInspector(TeXDistributionKit_PRIVATE)
- (NSString *)lossyTeXMFProgramsDistribution;
- (BOOL)TeXMFProgramsDistributionIsIntel;
- (void)setTeXMFProgramsDistributionIntel:(BOOL)flag;
- (NSString *)lossyOtherProgramsDistribution;
- (BOOL)OtherProgramsDistributionIsIntel;
- (void)setOtherProgramsDistributionIntel:(BOOL)flag;
@end
@implementation iTM2TeXPCommandsInspector(TeXDistributionKit)
#pragma mark =-=-=-=-=-  INTEL?
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  lossyTeXMFProgramsDistribution
- (NSString *)lossyTeXMFProgramsDistribution;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * distribution = [[self document] TeXMFProgramsDistribution];
	if([distribution pathIsEqual:iTM2DistributionDefaultTeXDistIntel])
	{
		return iTM2DistributionDefaultTeXDist;
	}
	else if([distribution pathIsEqual:iTM2DistributiongwTeXIntel])
	{
		return iTM2DistributiongwTeX;
	}
	else if([distribution pathIsEqual:iTM2DistributionOldgwTeXIntel])
	{
		return iTM2DistributionOldgwTeX;
	}
	else if([distribution pathIsEqual:iTM2DistributionFinkIntel])
	{
		return iTM2DistributionFink;
	}
	else if([distribution pathIsEqual:iTM2DistributionTeXLiveIntel])
	{
		return iTM2DistributionTeXLive;
	}
	else if([distribution pathIsEqual:iTM2DistributionTeXLiveDVDIntel])
	{
		return iTM2DistributionTeXLiveDVD;
	}
	else
		return distribution;
//iTM2_END;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  TeXMFProgramsDistributionIsIntel
- (BOOL)TeXMFProgramsDistributionIsIntel;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * distribution = [[self document] TeXMFProgramsDistribution];
//iTM2_END;
    return [distribution pathIsEqual:iTM2DistributionDefaultTeXDistIntel]
		|| [distribution pathIsEqual:iTM2DistributiongwTeXIntel]
		|| [distribution pathIsEqual:iTM2DistributionOldgwTeXIntel]
		|| [distribution pathIsEqual:iTM2DistributionFinkIntel]
		|| [distribution pathIsEqual:iTM2DistributionTeXLiveIntel]
		|| [distribution pathIsEqual:iTM2DistributionTeXLiveDVDIntel];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setTeXMFProgramsDistributionIntel:
- (void)setTeXMFProgramsDistributionIntel:(BOOL)flag;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id doc = [self document];
	NSString * distribution = [doc TeXMFProgramsDistribution];
	if([distribution pathIsEqual:iTM2DistributionDefaultTeXDist])
	{
		[doc setTeXMFProgramsDistribution:iTM2DistributionDefaultTeXDistIntel];
	}
	else if([distribution pathIsEqual:iTM2DistributiongwTeX])
	{
		[doc setTeXMFProgramsDistribution:iTM2DistributiongwTeXIntel];
	}
	else if([distribution pathIsEqual:iTM2DistributionOldgwTeX])
	{
		[doc setTeXMFProgramsDistribution:iTM2DistributionOldgwTeXIntel];
	}
	else if([distribution pathIsEqual:iTM2DistributionFink])
	{
		[doc setTeXMFProgramsDistribution:iTM2DistributionFinkIntel];
	}
	else if([distribution pathIsEqual:iTM2DistributionTeXLive])
	{
		[doc setTeXMFProgramsDistribution:iTM2DistributionTeXLiveIntel];
	}
	else if([distribution pathIsEqual:iTM2DistributionTeXLiveDVD])
	{
		[doc setTeXMFProgramsDistribution:iTM2DistributionTeXLiveDVDIntel];
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  lossyOtherProgramsDistribution
- (NSString *)lossyOtherProgramsDistribution;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * distribution = [[self document] OtherProgramsDistribution];
	if([distribution pathIsEqual:iTM2DistributionDefaultTeXDistIntel])
	{
		return iTM2DistributionDefaultTeXDist;
	}
	else if([distribution pathIsEqual:iTM2DistributiongwTeXIntel])
	{
		return iTM2DistributiongwTeX;
	}
	else if([distribution pathIsEqual:iTM2DistributionOldgwTeXIntel])
	{
		return iTM2DistributionOldgwTeX;
	}
	else if([distribution pathIsEqual:iTM2DistributionFinkIntel])
	{
		return iTM2DistributionFink;
	}
	else if([distribution pathIsEqual:iTM2DistributionTeXLiveIntel])
	{
		return iTM2DistributionTeXLive;
	}
	else if([distribution pathIsEqual:iTM2DistributionTeXLiveDVDIntel])
	{
		return iTM2DistributionTeXLiveDVD;
	}
	else
		return distribution;
//iTM2_END;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  OtherProgramsDistributionIsIntel
- (BOOL)OtherProgramsDistributionIsIntel;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * distribution = [[self document] OtherProgramsDistribution];
//iTM2_END;
    return [distribution pathIsEqual:iTM2DistributionDefaultTeXDistIntel]
		|| [distribution pathIsEqual:iTM2DistributiongwTeXIntel]
		|| [distribution pathIsEqual:iTM2DistributionOldgwTeXIntel]
		|| [distribution pathIsEqual:iTM2DistributionFinkIntel]
		|| [distribution pathIsEqual:iTM2DistributionTeXLiveIntel]
		|| [distribution pathIsEqual:iTM2DistributionTeXLiveDVDIntel];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setOtherProgramsDistributionIntel:
- (void)setOtherProgramsDistributionIntel:(BOOL)flag;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id doc = [self document];
	NSString * distribution = [doc OtherProgramsDistribution];
	if([distribution pathIsEqual:iTM2DistributionDefaultTeXDist])
	{
		[doc setOtherProgramsDistribution:iTM2DistributionDefaultTeXDistIntel];
	}
	else if([distribution pathIsEqual:iTM2DistributiongwTeX])
	{
		[doc setOtherProgramsDistribution:iTM2DistributiongwTeXIntel];
	}
	else if([distribution pathIsEqual:iTM2DistributionOldgwTeX])
	{
		[doc setOtherProgramsDistribution:iTM2DistributionOldgwTeXIntel];
	}
	else if([distribution pathIsEqual:iTM2DistributionFink])
	{
		[doc setOtherProgramsDistribution:iTM2DistributionFinkIntel];
	}
	else if([distribution pathIsEqual:iTM2DistributionTeXLive])
	{
		[doc setOtherProgramsDistribution:iTM2DistributionTeXLiveIntel];
	}
	else if([distribution pathIsEqual:iTM2DistributionTeXLiveDVD])
	{
		[doc setOtherProgramsDistribution:iTM2DistributionTeXLiveDVDIntel];
	}
//iTM2_END;
    return;
}
#pragma mark =-=-=-=-=-  Output directory
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleOutputDirectory:
- (IBAction)toggleOutputDirectory:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id environment = [[(iTM2TeXProjectDocument *)[self document] implementation] iVarDistributionEnvironment];
    BOOL old = [[environment objectForKey:iTM2DistributionUseOutputDirectoryKey] boolValue];
    [environment setObject:[NSNumber numberWithBool: !old] forKey:iTM2DistributionUseOutputDirectoryKey];
	[[self document] updateChangeCount:NSChangeDone];
    [sender validateWindowContent];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleOutputDirectory:
- (BOOL)validateToggleOutputDirectory:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id environment = [[(iTM2TeXProjectDocument *)[self document] implementation] iVarDistributionEnvironment];
    [sender setState: ([[environment objectForKey:iTM2DistributionUseOutputDirectoryKey] boolValue]? NSOnState:NSOffState)];
//iTM2_END;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeOutputDirectoryFromStringValue:
- (IBAction)takeOutputDirectoryFromStringValue:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id environment = [[(iTM2TeXProjectDocument *)[self document] implementation] iVarDistributionEnvironment];
	NSString * old = [environment objectForKey:iTM2DistributionOutputDirectoryKey];
	NSString * new = [sender stringValue];
	if(![old pathIsEqual:new])
	{
		[environment setObject:new forKey:iTM2DistributionOutputDirectoryKey];
		[[self document] updateChangeCount:NSChangeDone];
		[sender validateWindowContent];
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateTakeOutputDirectoryFromStringValue:
- (BOOL)validateTakeOutputDirectoryFromStringValue:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(![sender formatter])
		[sender setFormatter:[[[iTM2FileNameFormatter allocWithZone:[self zone]] init] autorelease]];
	id environment = [[(iTM2TeXProjectDocument *)[self document] implementation] iVarDistributionEnvironment];
    [sender setStringValue:[(iTM2TeXProjectDocument *)[self document] getTEXMFOUTPUT]];
	if([[environment objectForKey:iTM2DistributionUseOutputDirectoryKey] boolValue])
		return YES;
	if(sender == [[sender window] firstResponder])
		[[sender window] makeFirstResponder:nil];
//iTM2_END;
    return NO;
}
#pragma mark =-=-=-=-=-  PATH
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  togglePATHLoginShell:
- (IBAction)togglePATHLoginShell:(id)sender;
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
    BOOL old = [[environment objectForKey:iTM2DistributionUsePATHLoginShellKey] boolValue];
    [environment setObject:[NSNumber numberWithBool:!old] forKey:iTM2DistributionUsePATHLoginShellKey];
	[[self document] updateChangeCount:NSChangeDone];
    [sender validateWindowContent];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateTogglePATHLoginShell:
- (BOOL)validateTogglePATHLoginShell:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id environment = [[(iTM2TeXProjectDocument *)[self document] implementation] iVarDistributionEnvironment];
    [sender setState: ([[environment objectForKey:iTM2DistributionUsePATHLoginShellKey] boolValue]? NSOnState:NSOffState)];
//iTM2_END;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  togglePATHPrefix:
- (IBAction)togglePATHPrefix:(id)sender;
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
    BOOL old = [[environment objectForKey:iTM2DistributionUsePATHPrefixKey] boolValue];
    [environment setObject:[NSNumber numberWithBool: !old] forKey:iTM2DistributionUsePATHPrefixKey];
	[[self document] updateChangeCount:NSChangeDone];
    [sender validateWindowContent];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateTogglePATHPrefix:
- (BOOL)validateTogglePATHPrefix:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id environment = [[(iTM2TeXProjectDocument *)[self document] implementation] iVarDistributionEnvironment];
    [sender setState: ([[environment objectForKey:iTM2DistributionUsePATHPrefixKey] boolValue]? NSOnState:NSOffState)];
//iTM2_END;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takePATHPrefixFromStringValue:
- (IBAction)takePATHPrefixFromStringValue:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id environment = [[(iTM2TeXProjectDocument *)[self document] implementation] iVarDistributionEnvironment];
	NSString * old = [environment objectForKey:iTM2DistributionPATHPrefixKey];
	NSString * new = [sender stringValue];
	if(![old pathIsEqual:new])
	{
		[environment setObject:new forKey:iTM2DistributionPATHPrefixKey];
		[[self document] updateChangeCount:NSChangeDone];
		[sender validateWindowContent];
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateTakePATHPrefixFromStringValue:
- (BOOL)validateTakePATHPrefixFromStringValue:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(![sender formatter])
		[sender setFormatter:[[[iTM2FileNameFormatter allocWithZone:[self zone]] init] autorelease]];
	id environment = [[(iTM2TeXProjectDocument *)[self document] implementation] iVarDistributionEnvironment];
    [sender setStringValue:[(iTM2TeXProjectDocument *)[self document] getPATHPrefix]];
	if([[environment objectForKey:iTM2DistributionUsePATHPrefixKey] boolValue])
		return YES;
	if(sender == [[sender window] firstResponder])
		[[sender window] makeFirstResponder:nil];
//iTM2_END;
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  togglePATHSuffix:
- (IBAction)togglePATHSuffix:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id environment = [[(iTM2TeXProjectDocument *)[self document] implementation] iVarDistributionEnvironment];
    BOOL old = [[environment objectForKey:iTM2DistributionUsePATHSuffixKey] boolValue];
    [environment setObject:[NSNumber numberWithBool: !old] forKey:iTM2DistributionUsePATHSuffixKey];
	[[self document] updateChangeCount:NSChangeDone];
    [sender validateWindowContent];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateTogglePATHSuffix:
- (BOOL)validateTogglePATHSuffix:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id environment = [[(iTM2TeXProjectDocument *)[self document] implementation] iVarDistributionEnvironment];
    [sender setState: ([[environment objectForKey:iTM2DistributionUsePATHSuffixKey] boolValue]? NSOnState:NSOffState)];
//iTM2_END;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takePATHSuffixFromStringValue:
- (IBAction)takePATHSuffixFromStringValue:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id environment = [[(iTM2TeXProjectDocument *)[self document] implementation] iVarDistributionEnvironment];
	NSString * old = [environment objectForKey:iTM2DistributionPATHSuffixKey];
	NSString * new = [sender stringValue];
	if(![old pathIsEqual:new])
	{
		[environment setObject:new forKey:iTM2DistributionPATHSuffixKey];
		[[self document] updateChangeCount:NSChangeDone];
		[sender validateWindowContent];
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateTakePATHSuffixFromStringValue:
- (BOOL)validateTakePATHSuffixFromStringValue:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(![sender formatter])
		[sender setFormatter:[[[iTM2FileNameFormatter allocWithZone:[self zone]] init] autorelease]];
	id environment = [[(iTM2TeXProjectDocument *)[self document] implementation] iVarDistributionEnvironment];
    [sender setStringValue:[(iTM2TeXProjectDocument *)[self document] getPATHSuffix]];
	if([[environment objectForKey:iTM2DistributionUsePATHSuffixKey] boolValue])
		return YES;
	if(sender == [[sender window] firstResponder])
		[[sender window] makeFirstResponder:nil];
//iTM2_END;
    return NO;
}
#pragma mark =-=-=-=-=-  DISTRIBUTIONS
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeTeXMFDistributionFromPopUp:
- (IBAction)takeTeXMFDistributionFromPopUp:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 06:28:11 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([sender isKindOfClass:[NSPopUpButton class]])
		sender = [sender selectedItem];
	if([sender isKindOfClass:[NSMenuItem class]])
	{
		NSString * new = [sender representedObject];
		NSString * old = [[self document] TeXMFDistribution];
		if(![old pathIsEqual:new])
		{
			[[self document] setTeXMFDistribution:new];
			[[self document] updateChangeCount:NSChangeDone];
			[self validateWindowContent];
		}
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateTakeTeXMFDistributionFromPopUp:
- (BOOL)validateTakeTeXMFDistributionFromPopUp:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([sender isKindOfClass:[NSPopUpButton class]])
	{
		NSString * distribution = [[self document] TeXMFDistribution];
		unsigned index = [sender indexOfItemWithRepresentedObject:distribution];
		if(index < [sender numberOfItems])
			[sender selectItemAtIndex:index];
		else if([distribution pathIsEqual:iTM2DistributionDefault])
			[sender selectItemWithTag:iTM2TeXDistributionDefaultTag];
		else if([distribution pathIsEqual:iTM2DistributionBuiltIn])
			[sender selectItemWithTag:iTM2TeXDistributionBuiltInTag];
		else if([distribution pathIsEqual:iTM2DistributionDefaultTeXDist])
			[sender selectItemWithTag:iTM2TeXDistributionDefaultTeXDistTag];
		else if([distribution pathIsEqual:iTM2DistributiongwTeX])
			[sender selectItemWithTag:iTM2TeXDistributionGWTeXTag];
		else if([distribution pathIsEqual:iTM2DistributionOldgwTeX])
			[sender selectItemWithTag:iTM2TeXDistributionOldGWTeXTag];
		else if([distribution pathIsEqual:iTM2DistributiongwTeX])
			[sender selectItemWithTag:iTM2TeXDistributionGWTeXTag];
		else if([distribution pathIsEqual:iTM2DistributionFink])
			[sender selectItemWithTag:iTM2TeXDistributionFinkTag];
		else if([distribution pathIsEqual:iTM2DistributionTeXLive])
			[sender selectItemWithTag:iTM2TeXDistributionTeXLiveTag];
		else if([distribution pathIsEqual:iTM2DistributionTeXLiveDVD])
			[sender selectItemWithTag:iTM2TeXDistributionTeXLiveDVDTag];
		else if([distribution pathIsEqual:iTM2DistributionCustom])
			[sender selectItemWithTag:iTM2TeXDistributionCustomTag];
		else if([distribution pathIsEqual:iTM2DistributionOther])
			[sender selectItemWithTag:iTM2TeXDistributionOtherTag];
		return YES;
	}
	else if([sender isKindOfClass:[NSMenuItem class]])
	{
		id representedObject;
		switch([sender tag])
		{
			default:
			case iTM2TeXDistributionDefaultTag: representedObject = iTM2DistributionDefault; break;
			case iTM2TeXDistributionBuiltInTag: representedObject = iTM2DistributionBuiltIn; [sender setIndentationLevel:1]; break;
			case iTM2TeXDistributionDefaultTeXDistTag: representedObject = iTM2DistributionDefaultTeXDist; [sender setIndentationLevel:1]; break;
			case iTM2TeXDistributionGWTeXTag: representedObject = iTM2DistributiongwTeX; [sender setIndentationLevel:1]; break;
			case iTM2TeXDistributionOldGWTeXTag: representedObject = iTM2DistributionOldgwTeX; [sender setIndentationLevel:1]; break;
			case iTM2TeXDistributionFinkTag: representedObject = iTM2DistributionFink; [sender setIndentationLevel:1]; break;
			case iTM2TeXDistributionTeXLiveTag: representedObject = iTM2DistributionTeXLive; [sender setIndentationLevel:1]; break;
			case iTM2TeXDistributionTeXLiveDVDTag: representedObject = iTM2DistributionTeXLiveDVD; [sender setIndentationLevel:1]; break;
			case iTM2TeXDistributionOtherTag: representedObject = iTM2DistributionOther; [sender setIndentationLevel:1]; break;
			case iTM2TeXDistributionCustomTag: representedObject = iTM2DistributionCustom; break;
		}
		[sender setRepresentedObject:representedObject];
		return YES;
	}
	return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeTeXMFPathFromStringValue:
- (IBAction)takeTeXMFPathFromStringValue:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    id TPD = (iTM2TeXProjectDocument *)[self document];
	id new = [sender stringValue];
	if(![[TPD TeXMFPath] pathIsEqual:new])
	{
		[TPD setTeXMFPath:new];
		[TPD updateChangeCount:NSChangeDone];
		[self validateWindowContent];
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateTakeTeXMFPathFromStringValue:
- (BOOL)validateTakeTeXMFPathFromStringValue:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(![sender formatter])
		[sender setFormatter:[[[iTM2FileNameFormatter allocWithZone:[self zone]] init] autorelease]];
    id TPD = (iTM2TeXProjectDocument *)[self document];
	[sender setStringValue:[TPD getTeXMFPath]];
//iTM2_END;
	return [[TPD TeXMFDistribution] pathIsEqual:iTM2DistributionCustom];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeTeXMFProgramsDistributionFromPopUp:
- (IBAction)takeTeXMFProgramsDistributionFromPopUp:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 06:28:11 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([sender isKindOfClass:[NSPopUpButton class]])
		sender = [sender selectedItem];
	if([sender isKindOfClass:[NSMenuItem class]])
	{
		BOOL isIntel = [self TeXMFProgramsDistributionIsIntel];
		NSString * old = [[self document] TeXMFProgramsDistribution];
		[[self document] setTeXMFProgramsDistribution:[sender representedObject]];
		[self setTeXMFProgramsDistributionIntel:isIntel];
		NSString * new = [[self document] TeXMFProgramsDistribution];
		if(![old pathIsEqual:new])
		{
			[[self document] updateChangeCount:NSChangeDone];
			[self validateWindowContent];
		}
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateTakeTeXMFProgramsDistributionFromPopUp:
- (BOOL)validateTakeTeXMFProgramsDistributionFromPopUp:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([sender isKindOfClass:[NSPopUpButton class]])
	{
		NSString * distribution = [self lossyTeXMFProgramsDistribution];
		unsigned index = [sender indexOfItemWithRepresentedObject:distribution];
		if(index < [sender numberOfItems])
			[sender selectItemAtIndex:index];
		else if([distribution pathIsEqual:iTM2DistributionDefault])
			[sender selectItemWithTag:iTM2TeXDistributionDefaultTag];
		else if([distribution pathIsEqual:iTM2DistributionBuiltIn])
			[sender selectItemWithTag:iTM2TeXDistributionBuiltInTag];
		else if([distribution pathIsEqual:iTM2DistributiongwTeX])
			[sender selectItemWithTag:iTM2TeXDistributionGWTeXTag];
		else if([distribution pathIsEqual:iTM2DistributionOldgwTeX])
			[sender selectItemWithTag:iTM2TeXDistributionOldGWTeXTag];
		else if([distribution pathIsEqual:iTM2DistributionFink])
			[sender selectItemWithTag:iTM2TeXDistributionFinkTag];
		else if([distribution pathIsEqual:iTM2DistributionTeXLive])
			[sender selectItemWithTag:iTM2TeXDistributionTeXLiveTag];
		else if([distribution pathIsEqual:iTM2DistributionTeXLiveDVD])
			[sender selectItemWithTag:iTM2TeXDistributionTeXLiveDVDTag];
		else if([distribution pathIsEqual:iTM2DistributionCustom])
			[sender selectItemWithTag:iTM2TeXDistributionCustomTag];
		else if([distribution pathIsEqual:iTM2DistributionOther])
			[sender selectItemWithTag:iTM2TeXDistributionOtherTag];
		return YES;
	}
	else if([sender isKindOfClass:[NSMenuItem class]])
	{
		id representedObject;
		switch([sender tag])
		{
			default:
			case iTM2TeXDistributionDefaultTag: representedObject = iTM2DistributionDefault; break;
			case iTM2TeXDistributionBuiltInTag: representedObject = iTM2DistributionBuiltIn; [sender setIndentationLevel:1]; break;
			case iTM2TeXDistributionGWTeXTag: representedObject = iTM2DistributiongwTeX; [sender setIndentationLevel:1]; break;
			case iTM2TeXDistributionOldGWTeXTag: representedObject = iTM2DistributionOldgwTeX; [sender setIndentationLevel:1]; break;
			case iTM2TeXDistributionFinkTag: representedObject = iTM2DistributionFink; [sender setIndentationLevel:1]; break;
			case iTM2TeXDistributionTeXLiveTag: representedObject = iTM2DistributionTeXLive; [sender setIndentationLevel:1]; break;
			case iTM2TeXDistributionTeXLiveDVDTag: representedObject = iTM2DistributionTeXLiveDVD; [sender setIndentationLevel:1]; break;
			case iTM2TeXDistributionOtherTag: representedObject = iTM2DistributionOther; [sender setIndentationLevel:1]; break;
			case iTM2TeXDistributionCustomTag: representedObject = iTM2DistributionCustom; break;
		}
		[sender setRepresentedObject:representedObject];
		return YES;
	}
	return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeTeXMFProgramsPathFromStringValue:
- (IBAction)takeTeXMFProgramsPathFromStringValue:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    id TPD = (iTM2TeXProjectDocument *)[self document];
	id new = [sender stringValue];
	if(![[TPD TeXMFProgramsPath] pathIsEqual:new])
	{
		[TPD setTeXMFProgramsPath:new];
		[TPD updateChangeCount:NSChangeDone];
		[self validateWindowContent];
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateTakeTeXMFProgramsPathFromStringValue:
- (BOOL)validateTakeTeXMFProgramsPathFromStringValue:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(![sender formatter])
		[sender setFormatter:[[[iTM2FileNameFormatter allocWithZone:[self zone]] init] autorelease]];
    id TPD = (iTM2TeXProjectDocument *)[self document];
	[sender setStringValue:[TPD getTeXMFProgramsPath]];
//iTM2_END;
	return [[TPD TeXMFProgramsDistribution] pathIsEqual:iTM2DistributionCustom];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleTeXMFProgramsCPUType:
- (IBAction)toggleTeXMFProgramsCPUType:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self setTeXMFProgramsDistributionIntel:![self TeXMFProgramsDistributionIsIntel]];
    id TPD = (iTM2TeXProjectDocument *)[self document];
	[TPD updateChangeCount:NSChangeDone];
	[self validateWindowContent];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleTeXMFProgramsCPUType:
- (BOOL)validateToggleTeXMFProgramsCPUType:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(![NSBundle isI386])
	{
		[sender setAction:NULL];
		[sender setHidden:YES];
		return YES;
	}
	if([[(id)[self document] TeXMFProgramsDistribution] pathIsEqual:iTM2DistributionCustom])
	{
		[sender setState:NSMixedState];
		return NO;
	}
	[sender setState:([self TeXMFProgramsDistributionIsIntel]?NSOnState:NSOffState)];
//iTM2_END;
	return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeOtherProgramsDistributionFromPopUp:
- (IBAction)takeOtherProgramsDistributionFromPopUp:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 06:28:11 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([sender isKindOfClass:[NSPopUpButton class]])
		sender = [sender selectedItem];
	if([sender isKindOfClass:[NSMenuItem class]])
	{
		BOOL isIntel = [self OtherProgramsDistributionIsIntel];
		NSString * old = [[self document] OtherProgramsDistribution];
		[[self document] setOtherProgramsDistribution:[sender representedObject]];
		[self setOtherProgramsDistributionIntel:isIntel];
		NSString * new = [[self document] OtherProgramsDistribution];
		if(![old pathIsEqual:new])
		{
			[[self document] updateChangeCount:NSChangeDone];
			[self validateWindowContent];
		}
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateTakeOtherProgramsDistributionFromPopUp:
- (BOOL)validateTakeOtherProgramsDistributionFromPopUp:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([sender isKindOfClass:[NSPopUpButton class]])
	{
		NSString * distribution = [self lossyOtherProgramsDistribution];
		unsigned index = [sender indexOfItemWithRepresentedObject:distribution];
		if(index < [sender numberOfItems])
			[sender selectItemAtIndex:index];
		else if([distribution pathIsEqual:iTM2DistributionDefault])
			[sender selectItemWithTag:iTM2TeXDistributionDefaultTag];
		else if([distribution pathIsEqual:iTM2DistributionBuiltIn])
			[sender selectItemWithTag:iTM2TeXDistributionBuiltInTag];
		else if([distribution pathIsEqual:iTM2DistributiongwTeX])
			[sender selectItemWithTag:iTM2TeXDistributionGWTeXTag];
		else if([distribution pathIsEqual:iTM2DistributionOldgwTeX])
			[sender selectItemWithTag:iTM2TeXDistributionOldGWTeXTag];
		else if([distribution pathIsEqual:iTM2DistributionFink])
			[sender selectItemWithTag:iTM2TeXDistributionFinkTag];
		else if([distribution pathIsEqual:iTM2DistributionTeXLive])
			[sender selectItemWithTag:iTM2TeXDistributionTeXLiveTag];
		else if([distribution pathIsEqual:iTM2DistributionTeXLiveDVD])
			[sender selectItemWithTag:iTM2TeXDistributionTeXLiveDVDTag];
		else if([distribution pathIsEqual:iTM2DistributionCustom])
			[sender selectItemWithTag:iTM2TeXDistributionCustomTag];
		else if([distribution pathIsEqual:iTM2DistributionOther])
			[sender selectItemWithTag:iTM2TeXDistributionOtherTag];
		return YES;
	}
	else if([sender isKindOfClass:[NSMenuItem class]])
	{
		id representedObject;
		switch([sender tag])
		{
			default:
			case iTM2TeXDistributionDefaultTag: representedObject = iTM2DistributionDefault; break;
			case iTM2TeXDistributionBuiltInTag: representedObject = iTM2DistributionBuiltIn; [sender setIndentationLevel:1]; break;
			case iTM2TeXDistributionGWTeXTag: representedObject = iTM2DistributiongwTeX; [sender setIndentationLevel:1]; break;
			case iTM2TeXDistributionOldGWTeXTag: representedObject = iTM2DistributionOldgwTeX; [sender setIndentationLevel:1]; break;
			case iTM2TeXDistributionFinkTag: representedObject = iTM2DistributionFink; [sender setIndentationLevel:1]; break;
			case iTM2TeXDistributionTeXLiveTag: representedObject = iTM2DistributionTeXLive; [sender setIndentationLevel:1]; break;
			case iTM2TeXDistributionTeXLiveDVDTag: representedObject = iTM2DistributionTeXLiveDVD; [sender setIndentationLevel:1]; break;
			case iTM2TeXDistributionOtherTag: representedObject = iTM2DistributionOther; [sender setIndentationLevel:1]; break;
			case iTM2TeXDistributionCustomTag: representedObject = iTM2DistributionCustom; break;
		}
		[sender setRepresentedObject:representedObject];
		return YES;
	}
	return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeOtherProgramsPathFromStringValue:
- (IBAction)takeOtherProgramsPathFromStringValue:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    id TPD = (iTM2TeXProjectDocument *)[self document];
	id new = [sender stringValue];
	if(![[TPD OtherProgramsPath] pathIsEqual:new])
	{
		[TPD setOtherProgramsPath:new];
		[TPD updateChangeCount:NSChangeDone];
		[self validateWindowContent];
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateTakeOtherProgramsPathFromStringValue:
- (BOOL)validateTakeOtherProgramsPathFromStringValue:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(![sender formatter])
		[sender setFormatter:[[[iTM2FileNameFormatter allocWithZone:[self zone]] init] autorelease]];
    id TPD = (iTM2TeXProjectDocument *)[self document];
	[sender setStringValue:[TPD getOtherProgramsPath]];
//iTM2_END;
	return [[TPD OtherProgramsDistribution] pathIsEqual:iTM2DistributionCustom];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleOtherProgramsCPUType:
- (IBAction)toggleOtherProgramsCPUType:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self setOtherProgramsDistributionIntel: ![self OtherProgramsDistributionIsIntel]];
    id TPD = (iTM2TeXProjectDocument *)[self document];
	[TPD updateChangeCount:NSChangeDone];
	[self validateWindowContent];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleOtherProgramsCPUType:
- (BOOL)validateToggleOtherProgramsCPUType:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(![NSBundle isI386])
	{
		[sender setAction:NULL];
		[sender setHidden:YES];
		return YES;
	}
	if([[(id)[self document] OtherProgramsDistribution] pathIsEqual:iTM2DistributionCustom])
	{
		[sender setState:NSMixedState];
		return NO;
	}
	[sender setState: ([self OtherProgramsDistributionIsIntel]?NSOnState:NSOffState)];
//iTM2_END;
	return YES;
}
@end
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2DistributionServer

#pragma mark -
@interface iTM2TeXDistributionPrefPane: iTM2PreferencePane
- (IBAction)toggleOutputDirectory:(id)sender;
- (IBAction)takeOutputDirectoryFromStringValue:(id)sender;
- (IBAction)togglePATHPrefix:(id)sender;
- (IBAction)takePATHPrefixFromStringValue:(id)sender;
- (IBAction)togglePATHSuffix:(id)sender;
- (IBAction)takePATHSuffixFromStringValue:(id)sender;
- (IBAction)takeTeXMFDistributionFromPopUp:(id)sender;
- (IBAction)takeTeXMFProgramsDistributionFromPopUp:(id)sender;
- (IBAction)takeOtherProgramsDistributionFromPopUp:(id)sender;
- (id)orderedEnvironmentVariableNames;
- (void)setOrderedEnvironmentVariableNames:(id)argument;
- (id)environmentVariables;
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
- (void)tabView:(NSTabView *)tabView didSelectTabViewItem:(NSTabViewItem *)tabViewItem;
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
- (NSString *)prefPaneIdentifier;
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
- (id)orderedEnvironmentVariableNames;
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
		result = [[[[[self environmentVariables] allKeys] sortedArrayUsingSelector:@selector(compare:)] mutableCopy] autorelease];
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
- (void)setOrderedEnvironmentVariableNames:(id)argument;
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
- (id)environmentVariables;
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
		NSDictionary * seed = [SUD dictionaryForKey:iTM2EnvironmentVariablesKey];
		result = seed? [NSMutableDictionary dictionaryWithDictionary:seed]:[NSMutableDictionary dictionary];
		metaSETTER(result);
		result = metaGETTER;
	}
//iTM2_END;
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= environmentTableView
- (id)environmentTableView;
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
- (void)setEnvironmentTableView:(id)argument;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 09/21/2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	metaSETTER(argument);
	[argument setDelegate:self];
//iTM2_END;
    return;
}
#pragma mark =-=-=-=-=-  Environment variables
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  numberOfRowsInTableView:
- (int)numberOfRowsInTableView:(NSTableView *)tableView;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 09/21/2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(![self environmentTableView])
	{
		[self setEnvironmentTableView:tableView];
	}
//iTM2_END;
    return [[self orderedEnvironmentVariableNames] count];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  tableView:objectValueForTableColumn:row:
- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(int)row;
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
	NSString * key = [names objectAtIndex:row];
	NSString * identifier = [tableColumn identifier];
	if([identifier isEqualToString:@"used"])
	{
		return [NSNumber numberWithBool:[[key pathExtension] isEqualToString:@""]];
	}
	else if([identifier isEqualToString:@"name"])
	{
		return [key stringByDeletingPathExtension];
	}
	else if([identifier isEqualToString:@"value"])
	{
		return [[self environmentVariables] objectForKey:key];
	}
//iTM2_END
    return key;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  tableView:setObjectValue:forTableColumn:row:
- (void)tableView:(NSTableView *)tableView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn row:(int)row;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 09/21/2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * key = [[self orderedEnvironmentVariableNames] objectAtIndex:row];
	if([[tableColumn identifier] isEqualToString:@"used"])
	{
		NSString * newKey = [[key pathExtension] length]?
			[key stringByDeletingPathExtension]:[key stringByAppendingPathExtension:@"unused"];
		[[self orderedEnvironmentVariableNames] replaceObjectAtIndex:row withObject:newKey];
		if(![newKey isEqualToString:key])
		{
			[[self environmentVariables] setObject: ([[self environmentVariables] objectForKey:key]?:@"") forKey:newKey];
			[[self environmentVariables] removeObjectForKey:key];
		}
	}
	else if([[tableColumn identifier] isEqualToString:@"name"])
	{
		if([object isEqualToString:@"PATH"])
			goto abort;
		NSString * pathExtension = [key pathExtension];
		NSString * newKey = [pathExtension length]?
			[object stringByAppendingPathExtension:pathExtension]: object;
		if([[self orderedEnvironmentVariableNames] indexOfObject:object] != NSNotFound)
			goto abort;
		if([object rangeOfCharacterFromSet: [[NSCharacterSet characterSetWithCharactersInString:
				@"azertyuiopqsdfghjklmwxcvbnAZERTYUIOPQSDFGHJKLMWXCVBN1234567890_"] invertedSet]].length)
			goto abort;
		[[self orderedEnvironmentVariableNames] replaceObjectAtIndex:row withObject:newKey];
		[[self environmentVariables] setObject: ([[self environmentVariables] objectForKey:key]?:@"") forKey:newKey];
		[[self environmentVariables] removeObjectForKey:key];
	}
	else if([[tableColumn identifier] isEqualToString:@"value"])
	{
		[[self environmentVariables] setObject:object forKey:key];
	}
	else
		goto abort;
	[SUD setObject:[self environmentVariables] forKey:iTM2EnvironmentVariablesKey];
abort:
	[[self environmentTableView] reloadData];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  tableViewSelectionDidChange:
- (void)tableViewSelectionDidChange:(NSNotification *)notification;
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
- (IBAction)addEnvironmentVariable:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 09/21/2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	int row = [[self orderedEnvironmentVariableNames] indexOfObject:@"VARIABLE"];
	if(row == NSNotFound)
	{
		[[self orderedEnvironmentVariableNames] addObject:@"VARIABLE"];
		row = [[self orderedEnvironmentVariableNames] indexOfObject:@"VARIABLE"];
		if(row == NSNotFound)
		{
			iTM2_LOG(@"ERROR: big problem here, could not add an object to %@", [self orderedEnvironmentVariableNames]);
			return;
		}
		[[self environmentTableView] reloadData];
	}
	[[self environmentTableView] selectRowIndexes:[NSIndexSet indexSetWithIndex:row] byExtendingSelection:NO];
	[[self environmentTableView] editColumn:[[self environmentTableView] columnWithIdentifier:@"name"]
		row: row withEvent: nil select: YES];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= removeEnvironmentVariable:
- (IBAction)removeEnvironmentVariable:(id)sender;
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
		NSMutableString * MS = [[[[[self orderedEnvironmentVariableNames] objectAtIndex:currentIndex] stringByDeletingPathExtension] mutableCopy] autorelease];
		currentIndex = [indexSet indexGreaterThanIndex:currentIndex];
		while (currentIndex != NSNotFound)
		{
			[MS appendFormat:@", %@", [[[self orderedEnvironmentVariableNames] objectAtIndex:currentIndex] stringByDeletingPathExtension]];
			currentIndex = [indexSet indexGreaterThanIndex:currentIndex];
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
- (void)removeEnvironmentVariableSheetDidDismiss:(NSWindow *)sheet returnCode:(int)returnCode indexSet:(NSIndexSet *)indexSet;
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
			NSString * key = [[self orderedEnvironmentVariableNames] objectAtIndex:currentIndex];
			[[self orderedEnvironmentVariableNames] removeObjectAtIndex:currentIndex];
			[[self environmentVariables] removeObjectForKey:key];
			currentIndex = [indexSet indexLessThanIndex:currentIndex];
		}
		[SUD setObject:[self environmentVariables] forKey:iTM2EnvironmentVariablesKey];
		[[self environmentTableView] reloadData];
	}
//iTM2_END;
    return;
}

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= validateRemoveEnvironmentVariable:
- (BOOL)validateRemoveEnvironmentVariable:(id)sender;
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
- (IBAction)revertToDefaultEnvironment:(id)sender;
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
- (BOOL)validateRevertToDefaultEnvironment:(id)sender;
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
- (IBAction)toggleOutputDirectory:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [SUD setBool: ![SUD boolForKey:iTM2DistributionUseOutputDirectoryKey] forKey:iTM2DistributionUseOutputDirectoryKey];
    [[self mainView] validateWindowContent];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleOutputDirectory:
- (BOOL)validateToggleOutputDirectory:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setState: ([SUD boolForKey:iTM2DistributionUseOutputDirectoryKey]? NSOnState:NSOffState)];
//iTM2_END;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeOutputDirectoryFromStringValue:
- (IBAction)takeOutputDirectoryFromStringValue:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [SUD setObject:[sender stringValue] forKey:iTM2DistributionOutputDirectoryKey];
    [[self mainView] validateWindowContent];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateTakeOutputDirectoryFromStringValue:
- (BOOL)validateTakeOutputDirectoryFromStringValue:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(![sender formatter])
		[sender setFormatter:[[[iTM2FileNameFormatter allocWithZone:[self zone]] init] autorelease]];
    [sender setStringValue: ([SUD stringForKey:iTM2DistributionOutputDirectoryKey]?:@"")];
	if([SUD boolForKey:iTM2DistributionUseOutputDirectoryKey])
		return YES;
	if(sender == [[sender window] firstResponder])
		[[sender window] makeFirstResponder:nil];
//iTM2_END;
    return NO;
}
#pragma mark =-=-=-=-=-  PATH
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  togglePATHLoginShell:
- (IBAction)togglePATHLoginShell:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [SUD setBool: ![SUD boolForKey:iTM2DistributionUsePATHLoginShellKey] forKey:iTM2DistributionUsePATHLoginShellKey];
    [[self mainView] validateWindowContent];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateTogglePATHLoginShell:
- (BOOL)validateTogglePATHLoginShell:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setState: ([SUD boolForKey:iTM2DistributionUsePATHLoginShellKey]? NSOnState:NSOffState)];
//iTM2_END;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  togglePATHPrefix:
- (IBAction)togglePATHPrefix:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [SUD setBool: ![SUD boolForKey:iTM2DistributionUsePATHPrefixKey] forKey:iTM2DistributionUsePATHPrefixKey];
    [[self mainView] validateWindowContent];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateTogglePATHPrefix:
- (BOOL)validateTogglePATHPrefix:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setState: ([SUD boolForKey:iTM2DistributionUsePATHPrefixKey]? NSOnState:NSOffState)];
//iTM2_END;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takePATHPrefixFromStringValue:
- (IBAction)takePATHPrefixFromStringValue:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [SUD setObject:[sender stringValue] forKey:iTM2DistributionPATHPrefixKey];
    [[self mainView] validateWindowContent];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateTakePATHPrefixFromStringValue:
- (BOOL)validateTakePATHPrefixFromStringValue:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(![sender formatter])
		[sender setFormatter:[[[iTM2FileNameFormatter allocWithZone:[self zone]] init] autorelease]];
    [sender setStringValue: ([SUD stringForKey:iTM2DistributionPATHPrefixKey]?:@"")];
	if([SUD boolForKey:iTM2DistributionUsePATHPrefixKey])
		return YES;
	if(sender == [[sender window] firstResponder])
		[[sender window] makeFirstResponder:nil];
//iTM2_END;
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  togglePATHSuffix:
- (IBAction)togglePATHSuffix:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [SUD setBool: ![SUD boolForKey:iTM2DistributionUsePATHSuffixKey] forKey:iTM2DistributionUsePATHSuffixKey];
    [[self mainView] validateWindowContent];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateTogglePATHSuffix:
- (BOOL)validateTogglePATHSuffix:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setState: ([SUD boolForKey:iTM2DistributionUsePATHSuffixKey]? NSOnState:NSOffState)];
//iTM2_END;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takePATHSuffixFromStringValue:
- (IBAction)takePATHSuffixFromStringValue:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [SUD setObject:[sender stringValue] forKey:iTM2DistributionPATHSuffixKey];
    [[self mainView] validateWindowContent];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateTakePATHSuffixFromStringValue:
- (BOOL)validateTakePATHSuffixFromStringValue:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(![sender formatter])
		[sender setFormatter:[[[iTM2FileNameFormatter allocWithZone:[self zone]] init] autorelease]];
    [sender setStringValue: ([SUD stringForKey:iTM2DistributionPATHSuffixKey]?:@"")];
	if([SUD boolForKey:iTM2DistributionUsePATHSuffixKey])
		return YES;
	if(sender == [[sender window] firstResponder])
		[[sender window] makeFirstResponder:nil];
//iTM2_END;
    return NO;
}
#pragma mark =-=-=-=-=-  INTEL?
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  lossyTeXMFProgramsDistribution
- (NSString *)lossyTeXMFProgramsDistribution;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * distribution = [SUD stringForKey:iTM2DistributionTeXMFPrograms];
	if([distribution pathIsEqual:iTM2DistributionOldgwTeXIntel])
	{
		return iTM2DistributionOldgwTeX;
	}
	else if([distribution pathIsEqual:iTM2DistributionFinkIntel])
	{
		return iTM2DistributionFink;
	}
	else if([distribution pathIsEqual:iTM2DistributionTeXLiveIntel])
	{
		return iTM2DistributionTeXLive;
	}
	else if([distribution pathIsEqual:iTM2DistributionTeXLiveDVDIntel])
	{
		return iTM2DistributionTeXLiveDVD;
	}
	else
		return distribution;
//iTM2_END;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  TeXMFProgramsDistributionIsIntel
- (BOOL)TeXMFProgramsDistributionIsIntel;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * distribution = [SUD stringForKey:iTM2DistributionTeXMFPrograms];
//iTM2_END;
    return [distribution pathIsEqual:iTM2DistributionDefaultTeXDistIntel]
		|| [distribution pathIsEqual:iTM2DistributiongwTeXIntel]
		|| [distribution pathIsEqual:iTM2DistributionOldgwTeXIntel]
		|| [distribution pathIsEqual:iTM2DistributionFinkIntel]
		|| [distribution pathIsEqual:iTM2DistributionTeXLiveIntel]
		|| [distribution pathIsEqual:iTM2DistributionTeXLiveDVDIntel];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setTeXMFProgramsDistributionIntel:
- (void)setTeXMFProgramsDistributionIntel:(BOOL)flag;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * distribution = [SUD stringForKey:iTM2DistributionTeXMFPrograms];
	if(flag)
	{
		if([distribution pathIsEqual:iTM2DistributionDefaultTeXDist])
		{
			[SUD setObject:iTM2DistributionDefaultTeXDistIntel forKey:iTM2DistributionTeXMFPrograms];
		}
		else if([distribution pathIsEqual:iTM2DistributiongwTeX])
		{
			[SUD setObject:iTM2DistributiongwTeXIntel forKey:iTM2DistributionTeXMFPrograms];
		}
		else if([distribution pathIsEqual:iTM2DistributionOldgwTeX])
		{
			[SUD setObject:iTM2DistributionOldgwTeXIntel forKey:iTM2DistributionTeXMFPrograms];
		}
		else if([distribution pathIsEqual:iTM2DistributionFink])
		{
			[SUD setObject:iTM2DistributionFinkIntel forKey:iTM2DistributionTeXMFPrograms];
		}
		else if([distribution pathIsEqual:iTM2DistributionTeXLive])
		{
			[SUD setObject:iTM2DistributionTeXLiveIntel forKey:iTM2DistributionTeXMFPrograms];
		}
		else if([distribution pathIsEqual:iTM2DistributionTeXLiveDVD])
		{
			[SUD setObject:iTM2DistributionTeXLiveDVDIntel forKey:iTM2DistributionTeXMFPrograms];
		}
	}
	else
	{
		if([distribution pathIsEqual:iTM2DistributionDefaultTeXDistIntel])
		{
			[SUD setObject:iTM2DistributionDefaultTeXDist forKey:iTM2DistributionTeXMFPrograms];
		}
		else if([distribution pathIsEqual:iTM2DistributiongwTeXIntel])
		{
			[SUD setObject:iTM2DistributiongwTeX forKey:iTM2DistributionTeXMFPrograms];
		}
		else if([distribution pathIsEqual:iTM2DistributionOldgwTeXIntel])
		{
			[SUD setObject:iTM2DistributionOldgwTeX forKey:iTM2DistributionTeXMFPrograms];
		}
		else if([distribution pathIsEqual:iTM2DistributionFinkIntel])
		{
			[SUD setObject:iTM2DistributionFink forKey:iTM2DistributionTeXMFPrograms];
		}
		else if([distribution pathIsEqual:iTM2DistributionTeXLiveIntel])
		{
			[SUD setObject:iTM2DistributionTeXLive forKey:iTM2DistributionTeXMFPrograms];
		}
		else if([distribution pathIsEqual:iTM2DistributionTeXLiveDVDIntel])
		{
			[SUD setObject:iTM2DistributionTeXLiveDVD forKey:iTM2DistributionTeXMFPrograms];
		}
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  lossyOtherProgramsDistribution
- (NSString *)lossyOtherProgramsDistribution;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * distribution = [SUD stringForKey:iTM2DistributionOtherPrograms];
	if([distribution pathIsEqual:iTM2DistributionDefaultTeXDistIntel])
	{
		return iTM2DistributionDefaultTeXDist;
	}
	else if([distribution pathIsEqual:iTM2DistributiongwTeXIntel])
	{
		return iTM2DistributiongwTeX;
	}
	else if([distribution pathIsEqual:iTM2DistributionOldgwTeXIntel])
	{
		return iTM2DistributionOldgwTeX;
	}
	else if([distribution pathIsEqual:iTM2DistributionFinkIntel])
	{
		return iTM2DistributionFink;
	}
	else if([distribution pathIsEqual:iTM2DistributionTeXLiveIntel])
	{
		return iTM2DistributionTeXLive;
	}
	else if([distribution pathIsEqual:iTM2DistributionTeXLiveDVDIntel])
	{
		return iTM2DistributionTeXLiveDVD;
	}
	else
		return distribution;
//iTM2_END;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  OtherProgramsDistributionIsIntel
- (BOOL)OtherProgramsDistributionIsIntel;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * distribution = [SUD stringForKey:iTM2DistributionOtherPrograms];
//iTM2_END;
    return [distribution pathIsEqual:iTM2DistributionDefaultTeXDistIntel]
		|| [distribution pathIsEqual:iTM2DistributiongwTeXIntel]
		|| [distribution pathIsEqual:iTM2DistributionOldgwTeXIntel]
		|| [distribution pathIsEqual:iTM2DistributionFinkIntel]
		|| [distribution pathIsEqual:iTM2DistributionTeXLiveIntel]
		|| [distribution pathIsEqual:iTM2DistributionTeXLiveDVDIntel];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setOtherProgramsDistributionIntel:
- (void)setOtherProgramsDistributionIntel:(BOOL)flag;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * distribution = [SUD stringForKey:iTM2DistributionOtherPrograms];
	if(flag)
	{
		if([distribution pathIsEqual:iTM2DistributionDefaultTeXDist])
		{
			[SUD setObject:iTM2DistributionDefaultTeXDistIntel forKey:iTM2DistributionOtherPrograms];
		}
		else if([distribution pathIsEqual:iTM2DistributiongwTeX])
		{
			[SUD setObject:iTM2DistributiongwTeXIntel forKey:iTM2DistributionOtherPrograms];
		}
		else if([distribution pathIsEqual:iTM2DistributionOldgwTeX])
		{
			[SUD setObject:iTM2DistributionOldgwTeXIntel forKey:iTM2DistributionOtherPrograms];
		}
		else if([distribution pathIsEqual:iTM2DistributionFink])
		{
			[SUD setObject:iTM2DistributionFinkIntel forKey:iTM2DistributionOtherPrograms];
		}
		else if([distribution pathIsEqual:iTM2DistributionTeXLive])
		{
			[SUD setObject:iTM2DistributionTeXLiveIntel forKey:iTM2DistributionOtherPrograms];
		}
		else if([distribution pathIsEqual:iTM2DistributionTeXLiveDVD])
		{
			[SUD setObject:iTM2DistributionTeXLiveDVDIntel forKey:iTM2DistributionOtherPrograms];
		}
	}
	else
	{
		if([distribution pathIsEqual:iTM2DistributionDefaultTeXDistIntel])
		{
			[SUD setObject:iTM2DistributionDefaultTeXDist forKey:iTM2DistributionOtherPrograms];
		}
		else if([distribution pathIsEqual:iTM2DistributiongwTeXIntel])
		{
			[SUD setObject:iTM2DistributiongwTeX forKey:iTM2DistributionOtherPrograms];
		}
		else if([distribution pathIsEqual:iTM2DistributionOldgwTeXIntel])
		{
			[SUD setObject:iTM2DistributionOldgwTeX forKey:iTM2DistributionOtherPrograms];
		}
		else if([distribution pathIsEqual:iTM2DistributionFinkIntel])
		{
			[SUD setObject:iTM2DistributionFink forKey:iTM2DistributionOtherPrograms];
		}
		else if([distribution pathIsEqual:iTM2DistributionTeXLiveIntel])
		{
			[SUD setObject:iTM2DistributionTeXLive forKey:iTM2DistributionOtherPrograms];
		}
		else if([distribution pathIsEqual:iTM2DistributionTeXLiveDVDIntel])
		{
			[SUD setObject:iTM2DistributionTeXLiveDVD forKey:iTM2DistributionOtherPrograms];
		}
	}
//iTM2_END;
    return;
}
#pragma mark =-=-=-=-=-  DISTRIBUTIONS
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeTeXMFDistributionFromPopUp:
- (IBAction)takeTeXMFDistributionFromPopUp:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 06:28:11 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([sender isKindOfClass:[NSPopUpButton class]])
		sender = [sender selectedItem];
	if([sender isKindOfClass:[NSMenuItem class]])
	{
		id new = [sender representedObject];
		if(![[SUD stringForKey:iTM2DistributionTeXMF] pathIsEqual:new])
		{
			[SUD setObject:new forKey:iTM2DistributionTeXMF];
			[[self mainView] validateWindowContent];
		}
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateTakeTeXMFDistributionFromPopUp:
- (BOOL)validateTakeTeXMFDistributionFromPopUp:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 06:28:11 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([sender isKindOfClass:[NSPopUpButton class]])
	{
		NSString * distribution = [SUD stringForKey:iTM2DistributionTeXMF];
		unsigned index = [sender indexOfItemWithRepresentedObject:distribution];
		if(index < [sender numberOfItems])
			[sender selectItemAtIndex:index];
		else if([distribution pathIsEqual:iTM2DistributionDefault])
			[sender selectItemWithTag:iTM2TeXDistributionDefaultTag];
		else if([distribution pathIsEqual:iTM2DistributionBuiltIn])
			[sender selectItemWithTag:iTM2TeXDistributionBuiltInTag];
		else if([distribution pathIsEqual:iTM2DistributionDefaultTeXDist])
			[sender selectItemWithTag:iTM2TeXDistributionDefaultTeXDistTag];
		else if([distribution pathIsEqual:iTM2DistributiongwTeX])
			[sender selectItemWithTag:iTM2TeXDistributionGWTeXTag];
		else if([distribution pathIsEqual:iTM2DistributionOldgwTeX])
			[sender selectItemWithTag:iTM2TeXDistributionOldGWTeXTag];
		else if([distribution pathIsEqual:iTM2DistributionFink])
			[sender selectItemWithTag:iTM2TeXDistributionFinkTag];
		else if([distribution pathIsEqual:iTM2DistributionTeXLive])
			[sender selectItemWithTag:iTM2TeXDistributionTeXLiveTag];
		else if([distribution pathIsEqual:iTM2DistributionTeXLiveDVD])
			[sender selectItemWithTag:iTM2TeXDistributionTeXLiveDVDTag];
		else if([distribution pathIsEqual:iTM2DistributionOther])
			[sender selectItemWithTag:iTM2TeXDistributionOtherTag];
		else if([distribution pathIsEqual:iTM2DistributionCustom])
			[sender selectItemWithTag:iTM2TeXDistributionCustomTag];
		return YES;
	}
	else if([sender isKindOfClass:[NSMenuItem class]])
	{
		id representedObject;
		switch([sender tag])
		{
			default:
			case iTM2TeXDistributionDefaultTag: representedObject = iTM2DistributionDefault; break;
			case iTM2TeXDistributionBuiltInTag: representedObject = iTM2DistributionBuiltIn; break;
			case iTM2TeXDistributionDefaultTeXDistTag: representedObject = iTM2DistributionDefaultTeXDist; break;
			case iTM2TeXDistributionGWTeXTag: representedObject = iTM2DistributiongwTeX; break;
			case iTM2TeXDistributionOldGWTeXTag: representedObject = iTM2DistributionOldgwTeX; break;
			case iTM2TeXDistributionFinkTag: representedObject = iTM2DistributionFink; break;
			case iTM2TeXDistributionTeXLiveTag: representedObject = iTM2DistributionTeXLive; break;
			case iTM2TeXDistributionTeXLiveDVDTag: representedObject = iTM2DistributionTeXLiveDVD; break;
			case iTM2TeXDistributionOtherTag: representedObject = iTM2DistributionOther; break;
			case iTM2TeXDistributionCustomTag: representedObject = iTM2DistributionCustom; break;
		}
		[sender setRepresentedObject:representedObject];
		return YES;
	}
	return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeTeXMFPathFromStringValue:
- (IBAction)takeTeXMFPathFromStringValue:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 06:28:11 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id new = [sender stringValue];
	NSString * key = [iTM2DistributionDomainTeXMF stringByAppendingPathExtension:[SUD stringForKey:iTM2DistributionTeXMF]];
	if(![[SUD stringForKey:key] pathIsEqual:new])
	{
		[SUD setObject:new forKey:key];
		[[self mainView] validateWindowContent];
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateTakeTeXMFPathFromStringValue:
- (BOOL)validateTakeTeXMFPathFromStringValue:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 06:28:11 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(![sender formatter])
		[sender setFormatter:[[[iTM2FileNameFormatter allocWithZone:[self zone]] init] autorelease]];
	NSString * distribution = [SUD stringForKey:iTM2DistributionTeXMF];
	NSString * key = [iTM2DistributionDomainTeXMF stringByAppendingPathExtension:distribution];
	NSString * path = [SUD stringForKey:key]?: @"";
	if([DFM fileExistsAtPath:path])
		[sender setStringValue:path];
	else
		[sender setAttributedStringValue:[[[NSAttributedString allocWithZone:[self zone]] initWithString: path
			attributes: [NSDictionary dictionaryWithObject:[NSColor redColor] forKey:NSForegroundColorAttributeName]] autorelease]];
	if([distribution pathIsEqual:iTM2DistributionCustom])
		return YES;
	if(sender == [[sender window] firstResponder])
		[[sender window] makeFirstResponder:nil];
//iTM2_END;
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeTeXMFProgramsDistributionFromPopUp:
- (IBAction)takeTeXMFProgramsDistributionFromPopUp:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 06:28:11 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([sender isKindOfClass:[NSPopUpButton class]])
		sender = [sender selectedItem];
	if([sender isKindOfClass:[NSMenuItem class]])
	{
		BOOL isIntel = [self TeXMFProgramsDistributionIsIntel];
		id old = [SUD stringForKey:iTM2DistributionTeXMFPrograms];
		[SUD setObject:[sender representedObject] forKey:iTM2DistributionTeXMFPrograms];
		[self setTeXMFProgramsDistributionIntel:isIntel];
		id new = [SUD stringForKey:iTM2DistributionTeXMFPrograms];
		if(![old pathIsEqual:new])
		{
			[[self mainView] validateWindowContent];
		}
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateTakeTeXMFProgramsDistributionFromPopUp:
- (BOOL)validateTakeTeXMFProgramsDistributionFromPopUp:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 06:28:11 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([sender isKindOfClass:[NSPopUpButton class]])
	{
		NSString * distribution = [self lossyTeXMFProgramsDistribution];
		unsigned index = [sender indexOfItemWithRepresentedObject:distribution];
		if(index < [sender numberOfItems])
			[sender selectItemAtIndex:index];
		else if([distribution pathIsEqual:iTM2DistributionDefault])
			[sender selectItemWithTag:iTM2TeXDistributionDefaultTag];
		else if([distribution pathIsEqual:iTM2DistributionBuiltIn])
			[sender selectItemWithTag:iTM2TeXDistributionBuiltInTag];
		else if([distribution pathIsEqual:iTM2DistributionDefaultTeXDist])
			[sender selectItemWithTag:iTM2TeXDistributionDefaultTeXDistTag];
		else if([distribution pathIsEqual:iTM2DistributiongwTeX])
			[sender selectItemWithTag:iTM2TeXDistributionGWTeXTag];
		else if([distribution pathIsEqual:iTM2DistributionOldgwTeX])
			[sender selectItemWithTag:iTM2TeXDistributionOldGWTeXTag];
		else if([distribution pathIsEqual:iTM2DistributionFink])
			[sender selectItemWithTag:iTM2TeXDistributionFinkTag];
		else if([distribution pathIsEqual:iTM2DistributionTeXLive])
			[sender selectItemWithTag:iTM2TeXDistributionTeXLiveTag];
		else if([distribution pathIsEqual:iTM2DistributionTeXLiveDVD])
			[sender selectItemWithTag:iTM2TeXDistributionTeXLiveDVDTag];
		else if([distribution pathIsEqual:iTM2DistributionOther])
			[sender selectItemWithTag:iTM2TeXDistributionOtherTag];
		else if([distribution pathIsEqual:iTM2DistributionCustom])
			[sender selectItemWithTag:iTM2TeXDistributionCustomTag];
		return YES;
	}
	else if([sender isKindOfClass:[NSMenuItem class]])
	{
		id representedObject;
		switch([sender tag])
		{
			default:
			case iTM2TeXDistributionDefaultTag: representedObject = iTM2DistributionDefault; break;
			case iTM2TeXDistributionBuiltInTag: representedObject = iTM2DistributionBuiltIn; break;
			case iTM2TeXDistributionDefaultTeXDistTag: representedObject = iTM2DistributionDefaultTeXDist; break;
			case iTM2TeXDistributionGWTeXTag: representedObject = iTM2DistributiongwTeX; break;
			case iTM2TeXDistributionOldGWTeXTag: representedObject = iTM2DistributionOldgwTeX; break;
			case iTM2TeXDistributionFinkTag: representedObject = iTM2DistributionFink; break;
			case iTM2TeXDistributionTeXLiveTag: representedObject = iTM2DistributionTeXLive; break;
			case iTM2TeXDistributionTeXLiveDVDTag: representedObject = iTM2DistributionTeXLiveDVD; break;
			case iTM2TeXDistributionOtherTag: representedObject = iTM2DistributionOther; break;
			case iTM2TeXDistributionCustomTag: representedObject = iTM2DistributionCustom; break;
		}
		[sender setRepresentedObject:representedObject];
		return YES;
	}
	return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeTeXMFProgramsPathFromStringValue:
- (IBAction)takeTeXMFProgramsPathFromStringValue:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 06:28:11 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id new = [sender stringValue];
	NSString * key = [iTM2DistributionDomainTeXMFPrograms stringByAppendingPathExtension:[SUD stringForKey:iTM2DistributionTeXMFPrograms]];
	if(![[SUD stringForKey:key] pathIsEqual:new])
	{
		[SUD setObject:new forKey:key];
		[[self mainView] validateWindowContent];
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateTakeTeXMFProgramsPathFromStringValue:
- (BOOL)validateTakeTeXMFProgramsPathFromStringValue:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 06:28:11 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(![sender formatter])
		[sender setFormatter:[[[iTM2FileNameFormatter allocWithZone:[self zone]] init] autorelease]];
	NSString * distribution = [SUD stringForKey:iTM2DistributionTeXMFPrograms];
	NSString * key = [iTM2DistributionDomainTeXMFPrograms stringByAppendingPathExtension:distribution];
	NSString * path = [SUD stringForKey:key]?: @"";
	if([DFM fileExistsAtPath:path])
		[sender setStringValue:path];
	else
		[sender setAttributedStringValue:[[[NSAttributedString allocWithZone:[self zone]] initWithString: path
			attributes: [NSDictionary dictionaryWithObject:[NSColor redColor] forKey:NSForegroundColorAttributeName]] autorelease]];
	if([distribution pathIsEqual:iTM2DistributionCustom])
		return YES;
	if(sender == [[sender window] firstResponder])
		[[sender window] makeFirstResponder:nil];
//iTM2_END;
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeOtherProgramsDistributionFromPopUp:
- (IBAction)takeOtherProgramsDistributionFromPopUp:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 06:28:11 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([sender isKindOfClass:[NSPopUpButton class]])
		sender = [sender selectedItem];
	if([sender isKindOfClass:[NSMenuItem class]])
	{
		BOOL isIntel = [self OtherProgramsDistributionIsIntel];
		id old = [SUD stringForKey:iTM2DistributionOtherPrograms];
		[SUD setObject:[sender representedObject] forKey:iTM2DistributionOtherPrograms];
		[self setOtherProgramsDistributionIntel:isIntel];
		id new = [SUD stringForKey:iTM2DistributionOtherPrograms];
		if(![old pathIsEqual:new])
		{
			[[self mainView] validateWindowContent];
		}
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateTakeOtherProgramsDistributionFromPopUp:
- (BOOL)validateTakeOtherProgramsDistributionFromPopUp:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 06:28:11 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([sender isKindOfClass:[NSPopUpButton class]])
	{
		NSString * distribution = [self lossyOtherProgramsDistribution];
		unsigned index = [sender indexOfItemWithRepresentedObject:distribution];
		if(index < [sender numberOfItems])
			[sender selectItemAtIndex:index];
		else if([distribution pathIsEqual:iTM2DistributionDefault])
			[sender selectItemWithTag:iTM2TeXDistributionDefaultTag];
		else if([distribution pathIsEqual:iTM2DistributionBuiltIn])
			[sender selectItemWithTag:iTM2TeXDistributionBuiltInTag];
		else if([distribution pathIsEqual:iTM2DistributionDefaultTeXDist])
			[sender selectItemWithTag:iTM2TeXDistributionDefaultTeXDistTag];
		else if([distribution pathIsEqual:iTM2DistributiongwTeX])
			[sender selectItemWithTag:iTM2TeXDistributionGWTeXTag];
		else if([distribution pathIsEqual:iTM2DistributionOldgwTeX])
			[sender selectItemWithTag:iTM2TeXDistributionOldGWTeXTag];
		else if([distribution pathIsEqual:iTM2DistributionFink])
			[sender selectItemWithTag:iTM2TeXDistributionFinkTag];
		else if([distribution pathIsEqual:iTM2DistributionTeXLive])
			[sender selectItemWithTag:iTM2TeXDistributionTeXLiveTag];
		else if([distribution pathIsEqual:iTM2DistributionTeXLiveDVD])
			[sender selectItemWithTag:iTM2TeXDistributionTeXLiveDVDTag];
		else if([distribution pathIsEqual:iTM2DistributionOther])
			[sender selectItemWithTag:iTM2TeXDistributionOtherTag];
		else if([distribution pathIsEqual:iTM2DistributionCustom])
			[sender selectItemWithTag:iTM2TeXDistributionCustomTag];
		return YES;
	}
	else if([sender isKindOfClass:[NSMenuItem class]])
	{
		id representedObject;
		switch([sender tag])
		{
			default:
			case iTM2TeXDistributionDefaultTag: representedObject = iTM2DistributionDefault; break;
			case iTM2TeXDistributionBuiltInTag: representedObject = iTM2DistributionBuiltIn; break;
			case iTM2TeXDistributionDefaultTeXDistTag: representedObject = iTM2DistributionDefaultTeXDist; break;
			case iTM2TeXDistributionGWTeXTag: representedObject = iTM2DistributiongwTeX; break;
			case iTM2TeXDistributionOldGWTeXTag: representedObject = iTM2DistributionOldgwTeX; break;
			case iTM2TeXDistributionFinkTag: representedObject = iTM2DistributionFink; break;
			case iTM2TeXDistributionTeXLiveTag: representedObject = iTM2DistributionTeXLive; break;
			case iTM2TeXDistributionTeXLiveDVDTag: representedObject = iTM2DistributionTeXLiveDVD; break;
			case iTM2TeXDistributionOtherTag: representedObject = iTM2DistributionOther; break;
			case iTM2TeXDistributionCustomTag: representedObject = iTM2DistributionCustom; break;
		}
		[sender setRepresentedObject:representedObject];
		return YES;
	}
	return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeOtherProgramsPathFromStringValue:
- (IBAction)takeOtherProgramsPathFromStringValue:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 06:28:11 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id new = [sender stringValue];
	NSString * key = [iTM2DistributionDomainOtherPrograms stringByAppendingPathExtension:[SUD stringForKey:iTM2DistributionOtherPrograms]];
	if(![[SUD stringForKey:key] pathIsEqual:new])
	{
		[SUD setObject:new forKey:key];
		[[self mainView] validateWindowContent];
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateTakeOtherProgramsPathFromStringValue:
- (BOOL)validateTakeOtherProgramsPathFromStringValue:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 06:28:11 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(![sender formatter])
		[sender setFormatter:[[[iTM2FileNameFormatter allocWithZone:[self zone]] init] autorelease]];
	NSString * distribution = [SUD stringForKey:iTM2DistributionOtherPrograms];
	NSString * key = [iTM2DistributionDomainOtherPrograms stringByAppendingPathExtension:distribution];
	NSString * path = [SUD stringForKey:key]?: @"";
	if([DFM fileExistsAtPath:path])
		[sender setStringValue:path];
	else
		[sender setAttributedStringValue:[[[NSAttributedString allocWithZone:[self zone]] initWithString: path
			attributes: [NSDictionary dictionaryWithObject:[NSColor redColor] forKey:NSForegroundColorAttributeName]] autorelease]];
	if([distribution pathIsEqual:iTM2DistributionCustom])
		return YES;
	if(sender == [[sender window] firstResponder])
		[[sender window] makeFirstResponder:nil];
//iTM2_END;
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleTeXMFProgramsCPUType:
- (IBAction)toggleTeXMFProgramsCPUType:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self setTeXMFProgramsDistributionIntel: ![self TeXMFProgramsDistributionIsIntel]];
	[[self mainView] validateWindowContent];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleTeXMFProgramsCPUType:
- (BOOL)validateToggleTeXMFProgramsCPUType:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(![NSBundle isI386])
	{
		[sender setAction:NULL];
		[sender setHidden:YES];
		return YES;
	}
	if([[SUD stringForKey:iTM2DistributionTeXMFPrograms] pathIsEqual:iTM2DistributionCustom])
	{
		[sender setState:NSMixedState];
		return NO;
	}
	[sender setState: ([self TeXMFProgramsDistributionIsIntel]?NSOnState:NSOffState)];
//iTM2_END;
	return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleOtherProgramsCPUType:
- (IBAction)toggleOtherProgramsCPUType:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self setOtherProgramsDistributionIntel: ![self OtherProgramsDistributionIsIntel]];
	[[self mainView] validateWindowContent];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleOtherProgramsCPUType:
- (BOOL)validateToggleOtherProgramsCPUType:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(![NSBundle isI386])
	{
		[sender setAction:NULL];
		[sender setHidden:YES];
		return YES;
	}
	if([[SUD stringForKey:iTM2DistributionOtherPrograms] pathIsEqual:iTM2DistributionCustom])
	{
		[sender setState:NSMixedState];
		return NO;
	}
	[sender setState: ([self OtherProgramsDistributionIsIntel]?NSOnState:NSOffState)];
//iTM2_END;
	return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  chooseTeXMFProgramsFromPanel:
- (IBAction)chooseTeXMFProgramsFromPanel:(id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSOpenPanel * OP = [NSOpenPanel openPanel];
    [OP setCanChooseFiles:NO];
    [OP setCanChooseDirectories:YES];
    [OP setTreatsFilePackagesAsDirectories:YES];
    [OP setAllowsMultipleSelection:NO];
    [OP setDelegate:self];
    [OP setResolvesAliases:YES];
	[OP setPrompt:[sender title]];
    [OP beginSheetForDirectory:NSHomeDirectory()
        file:nil types:nil modalForWindow:[sender window]
            modalDelegate:self didEndSelector:@selector(chooseTeXMFProgramsFromPanel:returnCode:contextInfo:)
				contextInfo:nil];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  chooseTeXMFProgramsFromPanel:returnCode:contextInfo:
- (void)chooseTeXMFProgramsFromPanel:(NSOpenPanel *)panel returnCode:(int)returnCode contextInfo:(void  *)irrelevant;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Nov 18 07:53:25 GMT 2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(returnCode == NSOKButton)
	{
		NSString * new = [panel filename];
		NSString * key = [SUD stringForKey:iTM2DistributionTeXMFPrograms];
		key = [iTM2DistributionDomainTeXMFPrograms stringByAppendingPathExtension:key];
		if(![[SUD stringForKey:key] pathIsEqual:new])
		{
			[SUD setObject:new forKey:key];
			[[self mainView] validateWindowContent];
		}
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateChooseTeXMFProgramsFromPanel:
- (BOOL)validateChooseTeXMFProgramsFromPanel:(id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * distribution = [SUD stringForKey:iTM2DistributionTeXMFPrograms];
	if([distribution pathIsEqual:iTM2DistributionCustom])
	{
		[sender setHidden:NO];
//iTM2_END;
		return YES;
	}
	else
	{
		[sender setHidden:YES];
//iTM2_END;
		return NO;
	}
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  chooseTeXMFPathFromPanel:
- (IBAction)chooseTeXMFPathFromPanel:(id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSOpenPanel * OP = [NSOpenPanel openPanel];
    [OP setCanChooseFiles:NO];
    [OP setCanChooseDirectories:YES];
    [OP setTreatsFilePackagesAsDirectories:YES];
    [OP setAllowsMultipleSelection:NO];
    [OP setDelegate:self];
    [OP setResolvesAliases:YES];
	[OP setPrompt:[sender title]];
    [OP beginSheetForDirectory:NSHomeDirectory()
        file:nil types:nil modalForWindow:[sender window]
            modalDelegate:self didEndSelector:@selector(chooseTeXMFPathFromPanel:returnCode:contextInfo:)
				contextInfo:nil];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  chooseTeXMFPathFromPanel:returnCode:contextInfo:
- (void)chooseTeXMFPathFromPanel:(NSOpenPanel *)panel returnCode:(int)returnCode contextInfo:(void  *)irrelevant;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Nov 18 07:53:25 GMT 2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(returnCode == NSOKButton)
	{
		NSString * new = [panel filename];
		NSString * key = [SUD stringForKey:iTM2DistributionTeXMF];
		key = [iTM2DistributionDomainTeXMF stringByAppendingPathExtension:key];
		if(![[SUD stringForKey:key] pathIsEqual:new])
		{
			[SUD setObject:new forKey:key];
			[[self mainView] validateWindowContent];
		}
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateChooseTeXMFPathFromPanel:
- (BOOL)validateChooseTeXMFPathFromPanel:(id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * distribution = [SUD stringForKey:iTM2DistributionTeXMF];
	if([distribution pathIsEqual:iTM2DistributionCustom])
	{
		[sender setHidden:NO];
//iTM2_END;
		return YES;
	}
	else
	{
		[sender setHidden:YES];
//iTM2_END;
		return NO;
	}
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  chooseOtherProgramsFromPanel:
- (IBAction)chooseOtherProgramsFromPanel:(id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSOpenPanel * OP = [NSOpenPanel openPanel];
    [OP setCanChooseFiles:NO];
    [OP setCanChooseDirectories:YES];
    [OP setTreatsFilePackagesAsDirectories:YES];
    [OP setAllowsMultipleSelection:NO];
    [OP setDelegate:self];
    [OP setResolvesAliases:YES];
	[OP setPrompt:[sender title]];
    [OP beginSheetForDirectory:NSHomeDirectory()
        file:nil types:nil modalForWindow:[sender window]
            modalDelegate:self didEndSelector:@selector(chooseOtherProgramsFromPanel:returnCode:contextInfo:)
				contextInfo:nil];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  chooseOtherProgramsFromPanel:returnCode:contextInfo:
- (void)chooseOtherProgramsFromPanel:(NSOpenPanel *)panel returnCode:(int)returnCode contextInfo:(void  *)irrelevant;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Nov 18 07:53:25 GMT 2006
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(returnCode == NSOKButton)
	{
		NSString * new = [panel filename];
		NSString * key = [SUD stringForKey:iTM2DistributionTeXMFPrograms];
		key = [iTM2DistributionDomainOtherPrograms stringByAppendingPathExtension:key];
		if(![[SUD stringForKey:key] pathIsEqual:new])
		{
			[SUD setObject:new forKey:key];
			[[self mainView] validateWindowContent];
		}
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateChooseOtherProgramsFromPanel:
- (BOOL)validateChooseOtherProgramsFromPanel:(id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * distribution = [SUD stringForKey:iTM2DistributionOtherPrograms];
	if([distribution pathIsEqual:iTM2DistributionCustom])
	{
		[sender setHidden:NO];
//iTM2_END;
		return YES;
	}
	else
	{
		[sender setHidden:YES];
//iTM2_END;
		return NO;
	}
}
@end

@implementation NSApplication(iTM2TeXDistributionKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  showTeXDistributionPreferences:
- (IBAction)showTeXDistributionPreferences:(id)sender;
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
+ (void)xload;
{[self poseAsClass:[NSMenuItem class]];}
- (void)setAction:(SEL)action;
{
	if([self action] == @selector(_popUpItemAction:))
		NSLog(@"BOULOUBOULOU--");
	iTM2_LOG(@"self: %@, old: %@, new: %@", self, NSStringFromSelector([self action]), NSStringFromSelector(action));
	[super setAction:action];
}
@end
#endif
