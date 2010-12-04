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
#import <iTM2TeXFoundation/iTM2TeXInfoWrapperKit.h>
#import <iTM2TeXFoundation/iTM2TeXProjectFrontendKit.h>
#import <iTM2TeXFoundation/iTM2TeXProjectCommandKit.h>

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

NSString * const iTM2DistributionDomainTeXMFPrograms = @"iTM2DistributionDomainTeXMFBinaries";
NSString * const iTM2DistributionDomainOtherPrograms = @"iTM2DistributionDomainOtherBinaries";
NSString * const iTM2DistributionDomainGhostScriptPrograms = @"iTM2DistributionDomainGhostScriptBinaries";

// those should be deprecated because I can retrieve those paths from the TeXMF tree
NSString * const iTM2DistributionDomainTeXMFDocumentation = @"iTM2DistributionDomainTeXMFDocumentation";
NSString * const iTM2DistributionDomainTeXMFHelp = @"iTM2DistributionDomainTeXMFHelp";
NSString * const iTM2DistributionDomainTeXMFFAQs = @"iTM2DistributionDomainTeXMFFAQs";

NSString * const iTM2DistributionsComponent = @"PATHs";
NSString * const iTM2DistributionSDictionaryKey = @"PATHs dictionary";

@implementation iTM2MainInstaller(iTM2TeXDistributionKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-==  iTM2TeXProjectTaskKitCompleteInstallation4iTM3;
+ (void)iTM2TeXProjectTaskKitCompleteInstallation4iTM3;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To do list:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSString * distribution = [NSBundle isI386_4iTM3]? iTM2DistributionDefaultTeXDistIntel: iTM2DistributionDefaultTeXDist;
    [SUD registerDefaults: [NSDictionary dictionaryWithObjectsAndKeys:
					distribution, iTM2DistributionTeXMFPrograms,
					distribution, iTM2DistributionOtherPrograms,
                                    nil]];
#ifdef __iTM2_BUG_TRACKING__
	#warning *** BUG TRACKING
#else
	id _iTM2PathsDictionary = [NSMutableDictionary dictionary];
	NSString * path;
    for (path in [[[NSBundle mainBundle]
            allURLsForResource4iTM3:iTM2DistributionsComponent withExtension:@"plist"] reverseObjectEnumerator]) {
        NSDictionary * D = [NSDictionary dictionaryWithContentsOfFile:path];
        if(D.count && ![[D objectForKey:@"isa"] pathIsEqual4iTM3:iTM2DistributionSDictionaryKey]) {
            [_iTM2PathsDictionary addEntriesFromDictionary:D];
		} else if(iTM2DebugEnabled) {
			LOG4iTM3(@"Bad file or dictionary at path", path);
		}
    }
	[SUD registerDefaults:_iTM2PathsDictionary];
	DEBUGLOG4iTM3(100,@"_iTM2PathsDictionary is: %@", _iTM2PathsDictionary);
	// then I make some diagnostic... to be sure that the chosen distribution is available
	// this is working at a SUD level
	// we must make some diagnostic at a project level too
	BOOL distributionWasNotCorrect = NO;
	BOOL distributionIsStillNotCorrect = NO;
	path = [iTM2TeXProjectDocument defaultTeXMFProgramsPath];
	if([DFM fileExistsAtPath:path])
		goto testOtherPrograms;// that's OK
	distributionWasNotCorrect = YES;
	if([NSBundle isI386_4iTM3])
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
	if([NSBundle isI386_4iTM3])
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
	MILESTONE4iTM3((@"PATHs and TeX Distributions"),(@"The PATHs.plist is missing"));
#endif
//END4iTM3;
    return;
}
@end

NSString * const iTM2DistributionKey = @"TeXDistribution";

NSString * const iTM2DistributionUseOutputDirectoryKey = @"iTM2DistributionUseTEXMFOUTPUT";
NSString * const iTM2DistributionOutputDirectoryKey = @"iTM2DistributionTEXMFOUTPUT";
NSString * const iTM2DistributionUsePATHLoginShellKey = @"iTM2DistributionUsePATHLoginShell";
NSString * const iTM2DistributionUsePATHPrefixKey = @"iTM2DistributionUsePATHPrefix";
NSString * const iTM2DistributionPATHPrefixKey = @"iTM2DistributionPATHPrefix";
NSString * const iTM2DistributionUsePATHSuffixKey = @"iTM2DistributionUsePATHSuffix";
NSString * const iTM2DistributionPATHSuffixKey = @"iTM2DistributionPATHSuffix";

@implementation iTM2TeXProjectDocument(TeXDistributionKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  commonCommandOutputDirectory
- (NSString *)commonCommandOutputDirectory;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	return [[self metaInfo4iTM3ForKeyPaths:iTM2DistributionKey,iTM2DistributionUseOutputDirectoryKey,nil] boolValue]?
	([self metaInfo4iTM3ForKeyPaths:iTM2DistributionKey,iTM2DistributionOutputDirectoryKey,nil]?:@"")
	:([self.fileURL.path stringByAppendingPathComponent:[[self nameForFileKey:self.masterFileKey] stringByDeletingLastPathComponent]]?: @"");
}
#pragma mark =-=-=-=-=-=-  DISTRIBUTIONS
#define DISTRIBUTION(getter, setter)\
- (NSString *)getter;\
{\
	NSString * result = [self metaInfo4iTM3ForKeyPaths:iTM2DistributionKey,iTM2KeyFromSelector(_cmd),nil];\
	return result.length? result: iTM2DistributionDefault;\
}\
- (void)setter:(NSString *)argument;\
{\
	[self setMetaInfo4iTM3:argument forKeyPaths:iTM2DistributionKey,iTM2KeyFromSelector(_cmd),nil];\
	return;\
}
DISTRIBUTION(TeXMFDistribution, setTeXMFDistribution)
DISTRIBUTION(TeXMFProgramsDistribution, setTeXMFProgramsDistribution)
DISTRIBUTION(OtherProgramsDistribution, setOtherProgramsDistribution)
DISTRIBUTION(GhostScriptProgramsDistribution, setGhostScriptProgramsDistribution)
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSString * distribution = self.TeXMFProgramsDistribution;
	if([distribution isEqualToString:iTM2DistributionDefault])
	{
		return [self.class defaultTeXMFProgramsPath];
	}
	else if([distribution isEqualToString:iTM2DistributionCustom])
	{
		return self.TeXMFProgramsPath;
	}
	else
	{
		NSString * key = [iTM2DistributionDomainTeXMFPrograms stringByAppendingPathExtension:distribution];
		NSString * result = [SUD stringForKey:key];
		return result.length? result:[self.class defaultTeXMFProgramsPath];
	}
//END4iTM3;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  getOtherProgramsPath
- (NSString *)getOtherProgramsPath;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSString * distribution = self.GhostScriptProgramsDistribution;
	if(distribution)
	{
		[self setOtherProgramsDistribution:distribution];
		[self setGhostScriptProgramsDistribution:nil];
	}
	distribution = self.OtherProgramsDistribution;
	if([distribution isEqualToString:iTM2DistributionDefault])
	{
		return [self.class defaultOtherProgramsPath];
	}
	else if([distribution isEqualToString:iTM2DistributionCustom])
	{
		return self.OtherProgramsPath;
	}
	else
	{
	// I have to manage what once was "GhostScript" and became "Other"
		NSString * key = [iTM2DistributionDomainOtherPrograms stringByAppendingPathExtension:distribution];
		NSString * result = [SUD stringForKey:key];
		if(result.length)
		{
			return result;
		}
		NSString * oldKey = [iTM2DistributionDomainGhostScriptPrograms stringByAppendingPathExtension:distribution];
		result = [SUD stringForKey:oldKey];
		if(result.length)
		{
			[SUD setObject:result forKey:key];
			return result;
		}
		return [self.class defaultOtherProgramsPath];
	}
//END4iTM3;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  defaultTeXMFProgramsPath
+ (NSString *)defaultTeXMFProgramsPath;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSString * distribution = [SUD stringForKey:iTM2DistributionTeXMFPrograms];
	if(!distribution.length)
	{
		LOG4iTM3(@"...........  HUGE ERROR: Missing TeXMF binaries distribution reference in preferences, report bug");
		return @"Missing TeXMF Programs ";
	} else {
		DEBUGLOG4iTM3(0,@"distribution:%@",distribution);
	}
	NSString * key = [iTM2DistributionDomainTeXMFPrograms stringByAppendingPathExtension:distribution];
	NSString * result = [SUD stringForKey:key];
	if(!result.length)
	{
		LOG4iTM3(@"...........  HUGE ERROR: Missing TeXMF binaries %@ distribution path in preferences, report bug", distribution);
		return @"Missing TeXMF Programs Distribution Path";
	}
//END4iTM3;
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  defaultOtherProgramsPath
+ (NSString *)defaultOtherProgramsPath;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSString * distribution = [SUD stringForKey:iTM2DistributionOtherPrograms];
	if(!distribution.length)
	{
		distribution = [SUD stringForKey:iTM2DistributionOtherPrograms];
		if(!distribution.length)
		{
			[SUD setObject:distribution forKey:iTM2DistributionOtherPrograms];
			LOG4iTM3(@"...........  HUGE ERROR: Missing Other binaries distribution reference in preferences, report bug");
			return @"Missing Other Programs ";
		}
	} else {
		DEBUGLOG4iTM3(0,@"distribution:%@",distribution);
	}
	NSString * key = [iTM2DistributionDomainOtherPrograms stringByAppendingPathExtension:distribution];
	NSString * result = [SUD stringForKey:key];
	if(!result.length)
	{
		NSString * oldKey = [iTM2DistributionDomainGhostScriptPrograms stringByAppendingPathExtension:distribution];
		result = [SUD stringForKey:oldKey];
		if(result.length)
		{
			[SUD setObject:result forKey:key];
		}
		else
		{
			LOG4iTM3(@"...........  HUGE ERROR: Missing Other binaries %@ distribution path in preferences, report bug", distribution);
			return @"Missing Other Programs Distribution Path";
		}
	}
//END4iTM3;
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  distributionsCompleteDidReadFromFile:ofType:
- (void)distributionsCompleteDidReadFromFile:(NSString *)fileName ofType:(NSString *)type;X
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	// testing the distributions
	// the same code splitted for debugging purpose
	NSString * distribution = self.TeXMFDistribution;
	NSString * path = self.TeXMFProgramsPath;
	if(![distribution isEqualToString:iTM2DistributionCustom] || [DFM fileExistsAtPath:path])
		return;
	distribution = self.OtherProgramsDistribution;
	path = self.OtherProgramsPath;
	if(![distribution isEqualToString:iTM2DistributionCustom] || [DFM fileExistsAtPath:path])
		return;
	[self performSelector:@selector(notifyUncompleteDistributionWarning:) withObject:nil afterDelay:0.01];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  notifyUncompleteDistributionWarning:
- (void)notifyUncompleteDistributionWarning:(id)irrelevant;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	// testing the distributions
	NSRunCriticalAlertPanel(
        NSLocalizedStringFromTableInBundle(@"Problem", iTM2TeXProjectTable, self.classBundle4iTM3, "notifyUncompleteDistributionWarning, title"),
        NSLocalizedStringFromTableInBundle(@"A project distribution is unknown", iTM2TeXProjectTable, self.classBundle4iTM3, "notifyUncompleteDistributionWarning, msg"),
		nil, nil, nil);

//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  notifyDefaultDistributionFixedWarning:
+ (void)notifyDefaultDistributionFixedWarning:(id)irrelevant;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	// testing the distributions
	NSRunCriticalAlertPanel(
        NSLocalizedStringFromTableInBundle(@"Warning", iTM2TeXProjectTable, self.classBundle4iTM3, "notifyDefaultDistributionFixedWarning, title"),
        NSLocalizedStringFromTableInBundle(@"Due to a modification in your local configuration, the default project distribution has been updated. See the preferences.", iTM2TeXProjectTable, self.classBundle4iTM3, "notifyDefaultDistributionFixedWarning, msg"),
		nil, nil, nil);

//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  notifyDefaultDistributionUnfixedError:
+ (void)notifyDefaultDistributionUnfixedError:(id)irrelevant;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	// testing the distributions
	NSRunCriticalAlertPanel(
        NSLocalizedStringFromTableInBundle(@"Warning", iTM2TeXProjectTable, self.classBundle4iTM3, "notifyDefaultDistributionUnfixedError, title"),
        NSLocalizedStringFromTableInBundle(@"Due to a modification in your local configuration, iTeXMac2 seems broken and won't compile properly. Please install a TeX distribution.",
			iTM2TeXProjectTable, self.classBundle4iTM3, "notifyDefaultDistributionUnfixedError, msg"),
		nil, nil, nil);

//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  getPATHUsesLoginShell
- (BOOL)getPATHUsesLoginShell;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSNumber * N = [self metaInfo4iTM3ForKeyPaths:iTM2DistributionKey,iTM2DistributionUsePATHLoginShellKey,nil];
	return N? [N boolValue]:[SUD boolForKey:iTM2DistributionUsePATHLoginShellKey];
//END4iTM3;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  usesPATHPrefix:
- (BOOL)usesPATHPrefix;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return [[self metaInfo4iTM3ForKeyPaths:iTM2DistributionKey,iTM2DistributionUsePATHPrefixKey,nil] boolValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setUsesPATHPrefix:
- (void)setUsesPATHPrefix:(BOOL)new;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    BOOL old = [[self metaInfo4iTM3ForKeyPaths:iTM2DistributionUsePATHPrefixKey,nil] boolValue];
	if(old != new)
	{
		[self willChangeValueForKey:@"usesPATHPrefix"];
		if([self setMetaInfo4iTM3:[NSNumber numberWithBool: new] forKeyPaths:iTM2DistributionUsePATHPrefixKey,nil])
		{
			[self updateChangeCount:NSChangeDone];
		}
		[self didChangeValueForKey:@"usesPATHPrefix"];
	}
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  getPATHPrefix
- (NSString *)getPATHPrefix;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
	return [self metaInfo4iTM3ForKeyPaths:iTM2DistributionPATHPrefixKey,nil];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setPATHPrefix:
- (void)setPATHPrefix:(NSString *)new;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSString * old = [self metaInfo4iTM3ForKeyPaths:iTM2DistributionPATHPrefixKey,nil];
	if(![old pathIsEqual4iTM3:new])
	{
		[self willChangeValueForKey:@"PATHPrefix"];
		if([self setMetaInfo4iTM3:new forKeyPaths:iTM2DistributionPATHPrefixKey,nil])
		{
			[self updateChangeCount:NSChangeDone];
		}
		[self didChangeValueForKey:@"PATHPrefix"];
		self.validateWindowsContents4iTM3;
	}
//END4iTM3;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  getCompletePATHPrefix
- (NSString *)getCompletePATHPrefix;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSString * SUDPrefix = @"";
	NSString * projectPrefix = @"";
	if(self.usesPATHPrefix)
	{
		projectPrefix = self.getPATHPrefix;
	}
	if([SUD boolForKey:iTM2DistributionUsePATHPrefixKey])
	{
		SUDPrefix = [SUD objectForKey:iTM2DistributionPATHPrefixKey]?: @"";
	}
	if(projectPrefix.length)
	{
		if(SUDPrefix.length)
		{
			return [NSString stringWithFormat:@"%@:%@", projectPrefix, SUDPrefix];
		}
		else
		{
			return projectPrefix;
		}
	}
	else
	{
		return SUDPrefix;
	}
//END4iTM3;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  usesPATHSuffix
- (BOOL)usesPATHSuffix;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return [[self metaInfo4iTM3ForKeyPaths:iTM2DistributionUsePATHSuffixKey,nil] boolValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setUsesPATHSuffix:
- (void)setUsesPATHSuffix:(BOOL)new;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    BOOL old = [[self metaInfo4iTM3ForKeyPaths:iTM2DistributionUsePATHSuffixKey,nil] boolValue];
	if(old != new)
	{
		[self willChangeValueForKey:@"usesPATHSuffix"];
		if([self setMetaInfo4iTM3:[NSNumber numberWithBool: new] forKeyPaths:iTM2DistributionUsePATHSuffixKey,nil])
		{
			[self updateChangeCount:NSChangeDone];
		}
		[self didChangeValueForKey:@"usesPATHSuffix"];
	}
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  getPATHSuffix
- (NSString *)getPATHSuffix;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	return [self metaInfo4iTM3ForKeyPaths:iTM2DistributionPATHSuffixKey,nil];
//END4iTM3;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setPATHSuffix:
- (void)setPATHSuffix:(NSString *)new;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSString * old = [self metaInfo4iTM3ForKeyPaths:iTM2DistributionPATHSuffixKey,nil];
	if(![old pathIsEqual4iTM3:new])
	{
		[self willChangeValueForKey:@"PATHSuffix"];
		if([self setMetaInfo4iTM3:new forKeyPaths:iTM2DistributionPATHSuffixKey,nil])
		{
			[self updateChangeCount:NSChangeDone];
		}
		[self didChangeValueForKey:@"PATHSuffix"];
		self.validateWindowsContents4iTM3;
	}
//END4iTM3;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  getCompletePATHSuffix
- (NSString *)getCompletePATHSuffix;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSString * SUDSuffix = @"";
	NSString * projectSuffix = @"";
	if(self.usesPATHSuffix)
	{
		projectSuffix = self.getPATHSuffix;
	}
	if([SUD boolForKey:iTM2DistributionUsePATHSuffixKey])
	{
		SUDSuffix = [SUD objectForKey:iTM2DistributionPATHSuffixKey]?: @"";
	}
	if(projectSuffix.length)
	{
		if(SUDSuffix.length)
		{
			return [NSString stringWithFormat:@"%@:%@", projectSuffix, SUDSuffix];
		}
		else
		{
			return projectSuffix;
		}
	}
	else
	{
		return SUDSuffix;
	}
//END4iTM3;
}
#pragma mark =-=-=-=-=-  Output directory
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  usesTEXMFOUTPUT
- (BOOL)usesTEXMFOUTPUT;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return [[self metaInfo4iTM3ForKeyPaths:iTM2DistributionUseOutputDirectoryKey,nil] boolValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setUsesTEXMFOUTPUT:
- (void)setUsesTEXMFOUTPUT:(BOOL)new;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    BOOL old = [[self metaInfo4iTM3ForKeyPaths:iTM2DistributionUseOutputDirectoryKey,nil] boolValue];
	if(old != new)
	{
		[self willChangeValueForKey:@"usesTEXMFOUTPUT"];
		if([self setMetaInfo4iTM3:[NSNumber numberWithBool: new] forKeyPaths:iTM2DistributionUseOutputDirectoryKey,nil])
		{
			[self updateChangeCount:NSChangeDone];
		}
		[self didChangeValueForKey:@"usesTEXMFOUTPUT"];
	}
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  getTEXMFOUTPUT
- (NSString *)getTEXMFOUTPUT;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return [self metaInfo4iTM3ForKeyPaths:iTM2DistributionOutputDirectoryKey,nil];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setTEXMFOUTPUT:
- (void)setTEXMFOUTPUT:(id)new;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSString * old = [self metaInfo4iTM3ForKeyPaths:iTM2DistributionOutputDirectoryKey,nil];
	if(![old pathIsEqual4iTM3:new])
	{
		[self willChangeValueForKey:@"TEXMFOUTPUT"];
		if([self setMetaInfo4iTM3:new forKeyPaths:iTM2DistributionOutputDirectoryKey,nil])
		{
			[self updateChangeCount:NSChangeDone];
		}
		[self didChangeValueForKey:@"TEXMFOUTPUT"];
	}
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  getCompleteTEXMFOUTPUT
- (NSString *)getCompleteTEXMFOUTPUT;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if([[self metaInfo4iTM3ForKeyPaths:iTM2DistributionUseOutputDirectoryKey,nil] boolValue])
		return [self metaInfo4iTM3ForKeyPaths:iTM2DistributionOutputDirectoryKey,nil]?: @"";
	if([SUD boolForKey:iTM2DistributionUseOutputDirectoryKey])
		return [SUD objectForKey:iTM2DistributionOutputDirectoryKey]?: @"";
	return @"";
//END4iTM3;
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[super initialize];
	[SUD registerDefaults: [NSDictionary dictionaryWithObjectsAndKeys:
		@"This is pdfeTeX",iTM2PDFTEXLogHeaderKey,
		@"This is TeX", iTM2TEXLogHeaderKey,
			nil]];
//END4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  formatsPath
+ (NSString *)formatsPath;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	static NSString * path = nil;
	if(NO && !path)
	{
		iTM2TaskWrapper * TW = [[[iTM2TaskWrapper alloc] init] autorelease];
		[TW setLaunchURL:[NSURL fileURLWithPath:@"/bin/sh"]];
		[TW addArgument:@"-c"];
		[TW addArgument:@"kpsewhich tex.fmt"];
//		[TW complete];
		iTM2TaskController * TC = [[[iTM2TaskController alloc] init] autorelease];
		[TC addTaskWrapper:TW];
		[TC start];
//		[[TC currentTask] waitUntilExit];
		path = [[[TC output] stringByDeletingLastPathComponent] copy];
	}
//END4iTM3;
	return path?:@"";
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  fmtsAtPath:
+ (NSDictionary *)fmtsAtPath:(NSString *)path;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	BOOL isDirectory;
	if(![DFM fileExistsAtPath:path isDirectory: &isDirectory] || !isDirectory)
		return nil;
	// We list the contents of the given directory
	NSMutableArray * TeXs = [NSMutableArray array];
	NSMutableArray * PDFTeXs = [NSMutableArray array];
	NSMutableArray * Others = [NSMutableArray array];
	NSString * TeXLogHeader = [SUD objectForKey:iTM2TEXLogHeaderKey];
	NSString * PDFTeXLogHeader = [SUD objectForKey:iTM2PDFTEXLogHeaderKey];
	for(NSString * P in [DFM contentsOfDirectoryAtPath:path error:NULL])
	{
		if([[P pathExtension] pathIsEqual4iTM3:@"fmt"])
		{
			NSString * fullPath = [path stringByAppendingPathComponent:P];
			NSString * linkTarget = [DFM destinationOfSymbolicLinkAtPath:fullPath error:NULL];
			NSString * coreName = [(linkTarget? linkTarget:fullPath) stringByDeletingPathExtension];
			NSString * logPath = [coreName stringByAppendingPathExtension:@"log"];
			NSString * S = [NSString stringWithContentsOfFile:logPath encoding:NSUTF8StringEncoding error:NULL];
			if([S hasPrefix:TeXLogHeader])
				[TeXs addObject:P.stringByDeletingPathExtension];
			else if([S hasPrefix:PDFTeXLogHeader])
				[PDFTeXs addObject:P.stringByDeletingPathExtension];
			else
				[Others addObject:P.stringByDeletingPathExtension];
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
	BOOL isDirectory;
	if(![DFM fileExistsAtPath:path isDirectory: &isDirectory] || !isDirectory)
		return nil;
	// We list the contents of the given directory
	NSMutableArray * bases = [NSMutableArray array];
	for(NSString * P in [DFM contentsOfDirectoryAtPath:path error:NULL])
		if([[P pathExtension] pathIsEqual4iTM3:@"base"])
			[bases addObject:P.stringByDeletingPathExtension];
	return bases;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  memsAtPath:
+ (NSArray *)memsAtPath:(NSString *)path;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	BOOL isDirectory;
	if(![DFM fileExistsAtPath:path isDirectory: &isDirectory] || !isDirectory)
		return nil;
	// We list the contents of the given directory
	NSMutableArray * mems = [NSMutableArray array];
	for(NSString * P in [DFM contentsOfDirectoryAtPath:path error:NULL])
		if([[P pathExtension] pathIsEqual4iTM3:@"mem"])
			[mems addObject:P.stringByDeletingPathExtension];
	return mems;
}
@end

#pragma mark -
#import "iTM2TeXProjectCommandKit.h"
@interface iTM2TeXPCommandsInspector(TeXDistributionKit_PRIVATE)
- (NSString *)lossyTeXMFProgramsDistribution;
- (BOOL)TeXMFProgramsDistributionIsIntel;
- (void)setTeXMFProgramsDistributionIsIntel:(BOOL)flag;
- (NSString *)lossyOtherProgramsDistribution;
- (BOOL)OtherProgramsDistributionIsIntel;
- (void)setOtherProgramsDistributionIsIntel:(BOOL)flag;
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSString * distribution = [self.document TeXMFProgramsDistribution];
	if([distribution pathIsEqual4iTM3:iTM2DistributionDefaultTeXDistIntel])
	{
		return iTM2DistributionDefaultTeXDist;
	}
	else if([distribution pathIsEqual4iTM3:iTM2DistributiongwTeXIntel])
	{
		return iTM2DistributiongwTeX;
	}
	else if([distribution pathIsEqual4iTM3:iTM2DistributionOldgwTeXIntel])
	{
		return iTM2DistributionOldgwTeX;
	}
	else if([distribution pathIsEqual4iTM3:iTM2DistributionFinkIntel])
	{
		return iTM2DistributionFink;
	}
	else if([distribution pathIsEqual4iTM3:iTM2DistributionTeXLiveIntel])
	{
		return iTM2DistributionTeXLive;
	}
	else if([distribution pathIsEqual4iTM3:iTM2DistributionTeXLiveDVDIntel])
	{
		return iTM2DistributionTeXLiveDVD;
	}
	else
		return distribution;
//END4iTM3;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  TeXMFProgramsDistributionIsIntel
- (BOOL)TeXMFProgramsDistributionIsIntel;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSString * distribution = [self.document TeXMFProgramsDistribution];
//END4iTM3;
    return [distribution pathIsEqual4iTM3:iTM2DistributionDefaultTeXDistIntel]
		|| [distribution pathIsEqual4iTM3:iTM2DistributiongwTeXIntel]
		|| [distribution pathIsEqual4iTM3:iTM2DistributionOldgwTeXIntel]
		|| [distribution pathIsEqual4iTM3:iTM2DistributionFinkIntel]
		|| [distribution pathIsEqual4iTM3:iTM2DistributionTeXLiveIntel]
		|| [distribution pathIsEqual4iTM3:iTM2DistributionTeXLiveDVDIntel];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setTeXMFProgramsDistributionIsIntel:
- (void)setTeXMFProgramsDistributionIsIntel:(BOOL)flag;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	id doc = self.document;
	NSString * distribution = [doc TeXMFProgramsDistribution];
	if([distribution pathIsEqual4iTM3:iTM2DistributionDefaultTeXDist])
	{
		[doc setTeXMFProgramsDistribution:iTM2DistributionDefaultTeXDistIntel];
	}
	else if([distribution pathIsEqual4iTM3:iTM2DistributiongwTeX])
	{
		[doc setTeXMFProgramsDistribution:iTM2DistributiongwTeXIntel];
	}
	else if([distribution pathIsEqual4iTM3:iTM2DistributionOldgwTeX])
	{
		[doc setTeXMFProgramsDistribution:iTM2DistributionOldgwTeXIntel];
	}
	else if([distribution pathIsEqual4iTM3:iTM2DistributionFink])
	{
		[doc setTeXMFProgramsDistribution:iTM2DistributionFinkIntel];
	}
	else if([distribution pathIsEqual4iTM3:iTM2DistributionTeXLive])
	{
		[doc setTeXMFProgramsDistribution:iTM2DistributionTeXLiveIntel];
	}
	else if([distribution pathIsEqual4iTM3:iTM2DistributionTeXLiveDVD])
	{
		[doc setTeXMFProgramsDistribution:iTM2DistributionTeXLiveDVDIntel];
	}
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  lossyOtherProgramsDistribution
- (NSString *)lossyOtherProgramsDistribution;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSString * distribution = [self.document OtherProgramsDistribution];
	if([distribution pathIsEqual4iTM3:iTM2DistributionDefaultTeXDistIntel])
	{
		return iTM2DistributionDefaultTeXDist;
	}
	else if([distribution pathIsEqual4iTM3:iTM2DistributiongwTeXIntel])
	{
		return iTM2DistributiongwTeX;
	}
	else if([distribution pathIsEqual4iTM3:iTM2DistributionOldgwTeXIntel])
	{
		return iTM2DistributionOldgwTeX;
	}
	else if([distribution pathIsEqual4iTM3:iTM2DistributionFinkIntel])
	{
		return iTM2DistributionFink;
	}
	else if([distribution pathIsEqual4iTM3:iTM2DistributionTeXLiveIntel])
	{
		return iTM2DistributionTeXLive;
	}
	else if([distribution pathIsEqual4iTM3:iTM2DistributionTeXLiveDVDIntel])
	{
		return iTM2DistributionTeXLiveDVD;
	}
	else
		return distribution;
//END4iTM3;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  OtherProgramsDistributionIsIntel
- (BOOL)OtherProgramsDistributionIsIntel;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSString * distribution = [self.document OtherProgramsDistribution];
//END4iTM3;
    return [distribution pathIsEqual4iTM3:iTM2DistributionDefaultTeXDistIntel]
		|| [distribution pathIsEqual4iTM3:iTM2DistributiongwTeXIntel]
		|| [distribution pathIsEqual4iTM3:iTM2DistributionOldgwTeXIntel]
		|| [distribution pathIsEqual4iTM3:iTM2DistributionFinkIntel]
		|| [distribution pathIsEqual4iTM3:iTM2DistributionTeXLiveIntel]
		|| [distribution pathIsEqual4iTM3:iTM2DistributionTeXLiveDVDIntel];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setOtherProgramsDistributionIsIntel:
- (void)setOtherProgramsDistributionIsIntel:(BOOL)flag;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	id doc = self.document;
	NSString * distribution = [doc OtherProgramsDistribution];
	if([distribution pathIsEqual4iTM3:iTM2DistributionDefaultTeXDist])
	{
		[doc setOtherProgramsDistribution:iTM2DistributionDefaultTeXDistIntel];
	}
	else if([distribution pathIsEqual4iTM3:iTM2DistributiongwTeX])
	{
		[doc setOtherProgramsDistribution:iTM2DistributiongwTeXIntel];
	}
	else if([distribution pathIsEqual4iTM3:iTM2DistributionOldgwTeX])
	{
		[doc setOtherProgramsDistribution:iTM2DistributionOldgwTeXIntel];
	}
	else if([distribution pathIsEqual4iTM3:iTM2DistributionFink])
	{
		[doc setOtherProgramsDistribution:iTM2DistributionFinkIntel];
	}
	else if([distribution pathIsEqual4iTM3:iTM2DistributionTeXLive])
	{
		[doc setOtherProgramsDistribution:iTM2DistributionTeXLiveIntel];
	}
	else if([distribution pathIsEqual4iTM3:iTM2DistributionTeXLiveDVD])
	{
		[doc setOtherProgramsDistribution:iTM2DistributionTeXLiveDVDIntel];
	}
//END4iTM3;
    return;
}
#pragma mark =-=-=-=-=-  PATH
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  togglePATHLoginShell:
- (IBAction)togglePATHLoginShell:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    BOOL old = [[self metaInfo4iTM3ForKeyPaths:iTM2DistributionUsePATHLoginShellKey,nil] boolValue];
    [self setMetaInfo4iTM3:[NSNumber numberWithBool:!old] forKeyPaths:iTM2DistributionUsePATHLoginShellKey,nil];
	[self.document updateChangeCount:NSChangeDone];
    [sender validateWindowContent4iTM3];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateTogglePATHLoginShell:
- (BOOL)validateTogglePATHLoginShell:(NSButton *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    sender.state = ([[self metaInfo4iTM3ForKeyPaths:iTM2DistributionUsePATHLoginShellKey,nil] boolValue]? NSOnState:NSOffState);
//END4iTM3;
    return YES;
}
#pragma mark =-=-=-=-=-  DISTRIBUTIONS
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeTeXMFDistributionFromPopUp:
- (IBAction)takeTeXMFDistributionFromPopUp:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 06:28:11 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if([sender isKindOfClass:[NSPopUpButton class]])
		sender = [sender selectedItem];
	if([sender isKindOfClass:[NSMenuItem class]])
	{
		NSString * new = [sender representedObject];
		NSString * old = [self.document TeXMFDistribution];
		if(![old pathIsEqual4iTM3:new])
		{
			[self.document setTeXMFDistribution:new];
			[self.document updateChangeCount:NSChangeDone];
			self.validateWindowContent4iTM3;
		}
	}
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateTakeTeXMFDistributionFromPopUp:
- (BOOL)validateTakeTeXMFDistributionFromPopUp:(id)theSender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if([theSender isKindOfClass:[NSPopUpButton class]])
	{
        #define sender ((NSPopUpButton *)theSender)
		NSString * distribution = [self.document TeXMFDistribution];
		NSUInteger index = [sender indexOfItemWithRepresentedObject:distribution];
		if(index < [sender numberOfItems])
			[sender selectItemAtIndex:index];
		else if([distribution pathIsEqual4iTM3:iTM2DistributionDefault])
			[sender selectItemWithTag:iTM2TeXDistributionDefaultTag];
		else if([distribution pathIsEqual4iTM3:iTM2DistributionBuiltIn])
			[sender selectItemWithTag:iTM2TeXDistributionBuiltInTag];
		else if([distribution pathIsEqual4iTM3:iTM2DistributionDefaultTeXDist])
			[sender selectItemWithTag:iTM2TeXDistributionDefaultTeXDistTag];
		else if([distribution pathIsEqual4iTM3:iTM2DistributiongwTeX])
			[sender selectItemWithTag:iTM2TeXDistributionGWTeXTag];
		else if([distribution pathIsEqual4iTM3:iTM2DistributionOldgwTeX])
			[sender selectItemWithTag:iTM2TeXDistributionOldGWTeXTag];
		else if([distribution pathIsEqual4iTM3:iTM2DistributiongwTeX])
			[sender selectItemWithTag:iTM2TeXDistributionGWTeXTag];
		else if([distribution pathIsEqual4iTM3:iTM2DistributionFink])
			[sender selectItemWithTag:iTM2TeXDistributionFinkTag];
		else if([distribution pathIsEqual4iTM3:iTM2DistributionTeXLive])
			[sender selectItemWithTag:iTM2TeXDistributionTeXLiveTag];
		else if([distribution pathIsEqual4iTM3:iTM2DistributionTeXLiveDVD])
			[sender selectItemWithTag:iTM2TeXDistributionTeXLiveDVDTag];
		else if([distribution pathIsEqual4iTM3:iTM2DistributionCustom])
			[sender selectItemWithTag:iTM2TeXDistributionCustomTag];
		else if([distribution pathIsEqual4iTM3:iTM2DistributionOther])
			[sender selectItemWithTag:iTM2TeXDistributionOtherTag];
		return YES;
        #undef sender
	}
	else if([theSender isKindOfClass:[NSMenuItem class]])
	{
		#define sender ((NSMenuItem *)theSender)
		id representedObject;
		switch(sender.tag) {
			default:
			case iTM2TeXDistributionDefaultTag: representedObject = iTM2DistributionDefault; break;
			case iTM2TeXDistributionBuiltInTag: representedObject = iTM2DistributionBuiltIn; sender.indentationLevel = 1; break;
			case iTM2TeXDistributionDefaultTeXDistTag: representedObject = iTM2DistributionDefaultTeXDist; sender.indentationLevel = 1; break;
			case iTM2TeXDistributionGWTeXTag: representedObject = iTM2DistributiongwTeX; sender.indentationLevel = 1; break;
			case iTM2TeXDistributionOldGWTeXTag: representedObject = iTM2DistributionOldgwTeX; sender.indentationLevel = 1; break;
			case iTM2TeXDistributionFinkTag: representedObject = iTM2DistributionFink; sender.indentationLevel = 1; break;
			case iTM2TeXDistributionTeXLiveTag: representedObject = iTM2DistributionTeXLive; sender.indentationLevel = 1; break;
			case iTM2TeXDistributionTeXLiveDVDTag: representedObject = iTM2DistributionTeXLiveDVD; sender.indentationLevel = 1; break;
			case iTM2TeXDistributionOtherTag: representedObject = iTM2DistributionOther; sender.indentationLevel = 1; break;
			case iTM2TeXDistributionCustomTag: representedObject = iTM2DistributionCustom; break;
		}
		sender.representedObject = representedObject;
        #undef sender
		return YES;
	}
	return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeTeXMFProgramsDistributionFromPopUp:
- (IBAction)takeTeXMFProgramsDistributionFromPopUp:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 06:28:11 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if([sender isKindOfClass:[NSPopUpButton class]])
		sender = [sender selectedItem];
	if([sender isKindOfClass:[NSMenuItem class]])
	{
		BOOL isIntel = self.TeXMFProgramsDistributionIsIntel;
		NSString * old = [self.document TeXMFProgramsDistribution];
		[self.document setTeXMFProgramsDistribution:[sender representedObject]];
		[self setTeXMFProgramsDistributionIsIntel:isIntel];
		NSString * new = [self.document TeXMFProgramsDistribution];
		if(![old pathIsEqual4iTM3:new])
		{
			[self.document updateChangeCount:NSChangeDone];
			self.validateWindowContent4iTM3;
		}
	}
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateTakeTeXMFProgramsDistributionFromPopUp:
- (BOOL)validateTakeTeXMFProgramsDistributionFromPopUp:(id)theSender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if([theSender isKindOfClass:[NSPopUpButton class]])
	{
        #define sender ((NSPopUpButton *)theSender)
		NSString * distribution = self.lossyTeXMFProgramsDistribution;
		NSUInteger index = [sender indexOfItemWithRepresentedObject:distribution];
		if(index < [sender numberOfItems])
			[sender selectItemAtIndex:index];
		else if([distribution pathIsEqual4iTM3:iTM2DistributionDefault])
			[sender selectItemWithTag:iTM2TeXDistributionDefaultTag];
		else if([distribution pathIsEqual4iTM3:iTM2DistributionBuiltIn])
			[sender selectItemWithTag:iTM2TeXDistributionBuiltInTag];
		else if([distribution pathIsEqual4iTM3:iTM2DistributiongwTeX])
			[sender selectItemWithTag:iTM2TeXDistributionGWTeXTag];
		else if([distribution pathIsEqual4iTM3:iTM2DistributionOldgwTeX])
			[sender selectItemWithTag:iTM2TeXDistributionOldGWTeXTag];
		else if([distribution pathIsEqual4iTM3:iTM2DistributionFink])
			[sender selectItemWithTag:iTM2TeXDistributionFinkTag];
		else if([distribution pathIsEqual4iTM3:iTM2DistributionTeXLive])
			[sender selectItemWithTag:iTM2TeXDistributionTeXLiveTag];
		else if([distribution pathIsEqual4iTM3:iTM2DistributionTeXLiveDVD])
			[sender selectItemWithTag:iTM2TeXDistributionTeXLiveDVDTag];
		else if([distribution pathIsEqual4iTM3:iTM2DistributionCustom])
			[sender selectItemWithTag:iTM2TeXDistributionCustomTag];
		else if([distribution pathIsEqual4iTM3:iTM2DistributionOther])
			[sender selectItemWithTag:iTM2TeXDistributionOtherTag];
        #undef sender
		return YES;
	}
	else if([theSender isKindOfClass:[NSMenuItem class]])
	{
        #define sender ((NSMenuItem *)theSender)
		id representedObject;
		switch(sender.tag)
		{
			default:
			case iTM2TeXDistributionDefaultTag: representedObject = iTM2DistributionDefault; break;
			case iTM2TeXDistributionBuiltInTag: representedObject = iTM2DistributionBuiltIn; sender.indentationLevel = 1; break;
			case iTM2TeXDistributionGWTeXTag: representedObject = iTM2DistributiongwTeX; sender.indentationLevel = 1; break;
			case iTM2TeXDistributionOldGWTeXTag: representedObject = iTM2DistributionOldgwTeX; sender.indentationLevel = 1; break;
			case iTM2TeXDistributionFinkTag: representedObject = iTM2DistributionFink; sender.indentationLevel = 1; break;
			case iTM2TeXDistributionTeXLiveTag: representedObject = iTM2DistributionTeXLive; sender.indentationLevel = 1; break;
			case iTM2TeXDistributionTeXLiveDVDTag: representedObject = iTM2DistributionTeXLiveDVD; sender.indentationLevel = 1; break;
			case iTM2TeXDistributionOtherTag: representedObject = iTM2DistributionOther; sender.indentationLevel = 1; break;
			case iTM2TeXDistributionCustomTag: representedObject = iTM2DistributionCustom; break;
		}
		sender.representedObject = representedObject;
        #undef sender
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
    id TPD = (iTM2TeXProjectDocument *)self.document;
	id new = [sender stringValue];
	if(![[TPD TeXMFProgramsPath] pathIsEqual4iTM3:new])
	{
		[TPD setTeXMFProgramsPath:new];
		[TPD updateChangeCount:NSChangeDone];
		self.validateWindowContent4iTM3;
	}
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateTakeTeXMFProgramsPathFromStringValue:
- (BOOL)validateTakeTeXMFProgramsPathFromStringValue:(NSControl *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if(![sender formatter])
		[sender setFormatter:[[[iTM2FileNameFormatter alloc] init] autorelease]];
    id TPD = (iTM2TeXProjectDocument *)self.document;
	[sender setStringValue:[TPD getTeXMFProgramsPath]];
//END4iTM3;
	return [[TPD TeXMFProgramsDistribution] pathIsEqual4iTM3:iTM2DistributionCustom];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleTeXMFProgramsCPUType:
- (IBAction)toggleTeXMFProgramsCPUType:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[self setTeXMFProgramsDistributionIsIntel:!self.TeXMFProgramsDistributionIsIntel];
    id TPD = (iTM2TeXProjectDocument *)self.document;
	[TPD updateChangeCount:NSChangeDone];
	self.validateWindowContent4iTM3;
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleTeXMFProgramsCPUType:
- (BOOL)validateToggleTeXMFProgramsCPUType:(NSButton *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if(![NSBundle isI386_4iTM3])
	{
		sender.action = NULL;
		[sender setHidden:YES];
		return YES;
	}
	if([[(id)self.document TeXMFProgramsDistribution] pathIsEqual4iTM3:iTM2DistributionCustom])
	{
		sender.state = NSMixedState;
		return NO;
	}
	sender.state = (self.TeXMFProgramsDistributionIsIntel?NSOnState:NSOffState);
//END4iTM3;
	return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeOtherProgramsDistributionFromPopUp:
- (IBAction)takeOtherProgramsDistributionFromPopUp:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 06:28:11 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if([sender isKindOfClass:[NSPopUpButton class]])
		sender = [sender selectedItem];
	if([sender isKindOfClass:[NSMenuItem class]])
	{
		BOOL isIntel = self.OtherProgramsDistributionIsIntel;
		NSString * old = [self.document OtherProgramsDistribution];
		[self.document setOtherProgramsDistribution:[sender representedObject]];
		[self setOtherProgramsDistributionIsIntel:isIntel];
		NSString * new = [self.document OtherProgramsDistribution];
		if(![old pathIsEqual4iTM3:new])
		{
			[self.document updateChangeCount:NSChangeDone];
			self.validateWindowContent4iTM3;
		}
	}
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateTakeOtherProgramsDistributionFromPopUp:
- (BOOL)validateTakeOtherProgramsDistributionFromPopUp:(id)theSender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if([theSender isKindOfClass:[NSPopUpButton class]])
	{
        #define sender ((NSPopUpButton *)theSender)
		NSString * distribution = self.lossyOtherProgramsDistribution;
		NSUInteger index = [sender indexOfItemWithRepresentedObject:distribution];
		if(index < [sender numberOfItems])
			[sender selectItemAtIndex:index];
		else if([distribution pathIsEqual4iTM3:iTM2DistributionDefault])
			[sender selectItemWithTag:iTM2TeXDistributionDefaultTag];
		else if([distribution pathIsEqual4iTM3:iTM2DistributionBuiltIn])
			[sender selectItemWithTag:iTM2TeXDistributionBuiltInTag];
		else if([distribution pathIsEqual4iTM3:iTM2DistributiongwTeX])
			[sender selectItemWithTag:iTM2TeXDistributionGWTeXTag];
		else if([distribution pathIsEqual4iTM3:iTM2DistributionOldgwTeX])
			[sender selectItemWithTag:iTM2TeXDistributionOldGWTeXTag];
		else if([distribution pathIsEqual4iTM3:iTM2DistributionFink])
			[sender selectItemWithTag:iTM2TeXDistributionFinkTag];
		else if([distribution pathIsEqual4iTM3:iTM2DistributionTeXLive])
			[sender selectItemWithTag:iTM2TeXDistributionTeXLiveTag];
		else if([distribution pathIsEqual4iTM3:iTM2DistributionTeXLiveDVD])
			[sender selectItemWithTag:iTM2TeXDistributionTeXLiveDVDTag];
		else if([distribution pathIsEqual4iTM3:iTM2DistributionCustom])
			[sender selectItemWithTag:iTM2TeXDistributionCustomTag];
		else if([distribution pathIsEqual4iTM3:iTM2DistributionOther])
			[sender selectItemWithTag:iTM2TeXDistributionOtherTag];
		return YES;
        #undef sender
	}
	else if([theSender isKindOfClass:[NSMenuItem class]])
	{
        #define sender ((NSMenuItem *)theSender)
		id representedObject;
		switch(sender.tag)
		{
			default:
			case iTM2TeXDistributionDefaultTag: representedObject = iTM2DistributionDefault; break;
			case iTM2TeXDistributionBuiltInTag: representedObject = iTM2DistributionBuiltIn; sender.indentationLevel = 1; break;
			case iTM2TeXDistributionGWTeXTag: representedObject = iTM2DistributiongwTeX; sender.indentationLevel = 1; break;
			case iTM2TeXDistributionOldGWTeXTag: representedObject = iTM2DistributionOldgwTeX; sender.indentationLevel = 1; break;
			case iTM2TeXDistributionFinkTag: representedObject = iTM2DistributionFink; sender.indentationLevel = 1; break;
			case iTM2TeXDistributionTeXLiveTag: representedObject = iTM2DistributionTeXLive; sender.indentationLevel = 1; break;
			case iTM2TeXDistributionTeXLiveDVDTag: representedObject = iTM2DistributionTeXLiveDVD; sender.indentationLevel = 1; break;
			case iTM2TeXDistributionOtherTag: representedObject = iTM2DistributionOther; sender.indentationLevel = 1; break;
			case iTM2TeXDistributionCustomTag: representedObject = iTM2DistributionCustom; break;
		}
		sender.representedObject = representedObject;
		return YES;
        #undef sender
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
    id TPD = (iTM2TeXProjectDocument *)self.document;
	id new = [sender stringValue];
	if(![[TPD OtherProgramsPath] pathIsEqual4iTM3:new])
	{
		[TPD setOtherProgramsPath:new];
		[TPD updateChangeCount:NSChangeDone];
		self.validateWindowContent4iTM3;
	}
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateTakeOtherProgramsPathFromStringValue:
- (BOOL)validateTakeOtherProgramsPathFromStringValue:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if(![sender formatter])
		[sender setFormatter:[[[iTM2FileNameFormatter alloc] init] autorelease]];
    id TPD = (iTM2TeXProjectDocument *)self.document;
	[sender setStringValue:[TPD getOtherProgramsPath]];
//END4iTM3;
	return [[TPD OtherProgramsDistribution] pathIsEqual4iTM3:iTM2DistributionCustom];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleOtherProgramsCPUType:
- (IBAction)toggleOtherProgramsCPUType:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[self setOtherProgramsDistributionIsIntel: !self.OtherProgramsDistributionIsIntel];
    id TPD = (iTM2TeXProjectDocument *)self.document;
	[TPD updateChangeCount:NSChangeDone];
	self.validateWindowContent4iTM3;
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleOtherProgramsCPUType:
- (BOOL)validateToggleOtherProgramsCPUType:(NSButton *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if(![NSBundle isI386_4iTM3])
	{
		sender.action = NULL;
		[sender setHidden:YES];
		return YES;
	}
	if([[(id)self.document OtherProgramsDistribution] pathIsEqual4iTM3:iTM2DistributionCustom])
	{
		sender.state = NSMixedState;
		return NO;
	}
	sender.state = (self.OtherProgramsDistributionIsIntel?NSOnState:NSOffState);
//END4iTM3;
	return YES;
}
@end
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2DistributionServer

#pragma mark -
@interface iTM2TeXDistributionPrefPane: iTM2PreferencePane <NSTabViewDelegate, NSTableViewDelegate, NSOpenSavePanelDelegate>
- (IBAction)toggleOutputDirectory:(id)sender;
- (IBAction)takeOutputDirectoryFromStringValue:(id)sender;
- (IBAction)togglePATHPrefix:(id)sender;
- (IBAction)takePATHPrefixFromStringValue:(id)sender;
- (IBAction)togglePATHSuffix:(id)sender;
- (IBAction)takePATHSuffixFromStringValue:(id)sender;
- (IBAction)takeTeXMFProgramsDistributionFromPopUp:(id)sender;
- (IBAction)takeOtherProgramsDistributionFromPopUp:(id)sender;
- (NSMutableArray *)orderedEnvironmentVariableNames;
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[super initialize];
	[iTM2TeXPCommandPerformer class];// initialize Task environment variables as side effect
//END4iTM3;
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[tabView validateWindowContent4iTM3];
//END4iTM3;
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return @"1.TeX";
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= orderedEnvironmentVariableNames
- (NSMutableArray *)orderedEnvironmentVariableNames;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 09/21/2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	id result = metaGETTER;
	if(!result)
	{
		result = [[[[self.environmentVariables allKeys] sortedArrayUsingSelector:@selector(compare:)] mutableCopy] autorelease];
		if(!result)
		{
			result = [NSMutableArray array];
		}
		metaSETTER(result);
		result = metaGETTER;
	}
//END4iTM3;
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= setOrderedEnvironmentVariableNames:
- (void)setOrderedEnvironmentVariableNames:(id)argument;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 09/21/2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	metaSETTER(argument);
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= environmentVariables
- (id)environmentVariables;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 09/21/2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	id result = metaGETTER;
	if(!result)
	{
		NSDictionary * seed = [SUD dictionaryForKey:iTM2EnvironmentVariablesKey];
		result = seed? [NSMutableDictionary dictionaryWithDictionary:seed]:[NSMutableDictionary dictionary];
		metaSETTER(result);
		result = metaGETTER;
	}
//END4iTM3;
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= environmentTableView
- (NSTableView *)environmentTableView;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 09/21/2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return metaGETTER;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= setEnvironmentTableView:
- (void)setEnvironmentTableView:(NSTableView *)argument;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 09/21/2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	metaSETTER(argument);
	argument.delegate = self;
//END4iTM3;
    return;
}
#pragma mark =-=-=-=-=-  Environment variables
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  numberOfRowsInTableView:
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 09/21/2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if(!self.environmentTableView)
	{
		[self setEnvironmentTableView:tableView];
	}
//END4iTM3;
    return self.orderedEnvironmentVariableNames.count;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  tableView:objectValueForTableColumn:row:
- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 09/21/2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSArray * names = self.orderedEnvironmentVariableNames;
	if(row<0)
		return nil;
	if(row>=names.count)
		return nil;
	NSString * key = [names objectAtIndex:row];
	NSString * identifier = [tableColumn identifier];
	if([identifier isEqualToString:@"used"])
	{
		return [NSNumber numberWithBool:[[key pathExtension] isEqualToString:@""]];
	}
	else if([identifier isEqualToString:@"name"])
	{
		return key.stringByDeletingPathExtension;
	}
	else if([identifier isEqualToString:@"value"])
	{
		return [self.environmentVariables objectForKey:key];
	}
//END4iTM3
    return key;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  tableView:setObjectValue:forTableColumn:row:
- (void)tableView:(NSTableView *)tableView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 09/21/2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSString * key = [self.orderedEnvironmentVariableNames objectAtIndex:row];
	if([[tableColumn identifier] isEqualToString:@"used"])
	{
		NSString * newKey = [[key pathExtension] length]?
			key.stringByDeletingPathExtension:[key stringByAppendingPathExtension:@"unused"];
		[self.orderedEnvironmentVariableNames replaceObjectAtIndex:row withObject:newKey];
		if(![newKey isEqualToString:key])
		{
			[self.environmentVariables setObject: ([self.environmentVariables objectForKey:key]?:@"") forKey:newKey];
			[self.environmentVariables removeObjectForKey:key];
		}
	}
	else if([[tableColumn identifier] isEqualToString:@"name"])
	{
		if([object isEqualToString:@"PATH"])
			goto abort;
		NSString * pathExtension = [key pathExtension];
		NSString * newKey = pathExtension.length?
			[object stringByAppendingPathExtension:pathExtension]: object;
		if([self.orderedEnvironmentVariableNames indexOfObject:object] != NSNotFound)
			goto abort;
		if([object rangeOfCharacterFromSet: [[NSCharacterSet characterSetWithCharactersInString:
				@"azertyuiopqsdfghjklmwxcvbnAZERTYUIOPQSDFGHJKLMWXCVBN1234567890_"] invertedSet]].length)
			goto abort;
		[self.orderedEnvironmentVariableNames replaceObjectAtIndex:row withObject:newKey];
		[self.environmentVariables setObject: ([self.environmentVariables objectForKey:key]?:@"") forKey:newKey];
		[self.environmentVariables removeObjectForKey:key];
	}
	else if([[tableColumn identifier] isEqualToString:@"value"])
	{
		[self.environmentVariables setObject:object forKey:key];
	}
	else
		goto abort;
	[SUD setObject:self.environmentVariables forKey:iTM2EnvironmentVariablesKey];
abort:
	[self.environmentTableView reloadData];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  tableViewSelectionDidChange:
- (void)tableViewSelectionDidChange:(NSNotification *)notification;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 09/21/2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[self.mainView validateWindowContent4iTM3];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= addEnvironmentVariable:
- (IBAction)addEnvironmentVariable:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 09/21/2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSUInteger row = [self.orderedEnvironmentVariableNames indexOfObject:@"VARIABLE"];
	if(row == NSNotFound)
	{
		[self.orderedEnvironmentVariableNames addObject:@"VARIABLE"];
		row = [self.orderedEnvironmentVariableNames indexOfObject:@"VARIABLE"];
		if(row == NSNotFound)
		{
			LOG4iTM3(@"ERROR: big problem here, could not add an object to %@", self.orderedEnvironmentVariableNames);
			return;
		}
		[self.environmentTableView reloadData];
	}
	[self.environmentTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:row] byExtendingSelection:NO];
	[self.environmentTableView editColumn:[self.environmentTableView columnWithIdentifier:@"name"]
		row: row withEvent: nil select: YES];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= removeEnvironmentVariable:
- (IBAction)removeEnvironmentVariable:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 09/21/2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSIndexSet * indexSet = [self.environmentTableView selectedRowIndexes];
	if(indexSet.count)
	{
		NSUInteger currentIndex = [indexSet firstIndex];
		NSMutableString * MS = [[[[self.orderedEnvironmentVariableNames objectAtIndex:currentIndex] stringByDeletingPathExtension] mutableCopy] autorelease];
		currentIndex = [indexSet indexGreaterThanIndex:currentIndex];
		while (currentIndex != NSNotFound)
		{
			[MS appendFormat:@", %@", [[self.orderedEnvironmentVariableNames objectAtIndex:currentIndex] stringByDeletingPathExtension]];
			currentIndex = [indexSet indexGreaterThanIndex:currentIndex];
		}
		NSBeginCriticalAlertSheet(
			NSLocalizedStringFromTableInBundle(@"Remove?", iTM2TeXProjectTable, self.classBundle4iTM3, "Comment forthcoming"),
			nil,
			nil,
			NSLocalizedStringFromTableInBundle(@"Cancel", iTM2TeXProjectTable, self.classBundle4iTM3, "Comment forthcoming"),
			self.environmentTableView.window,
			self,
			NULL,
			@selector(removeEnvironmentVariableSheetDidDismiss:returnCode:indexSet:),
			[indexSet retain],// will be autorelease in the method below
			NSLocalizedStringFromTableInBundle(@"Remove environment variables\n%@?", iTM2TeXProjectTable, self.classBundle4iTM3, "Comment forthcoming"),
			MS);
	}
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= removeEnvironmentVariableSheetDidDismiss:returnCode:indexSet:
- (void)removeEnvironmentVariableSheetDidDismiss:(NSWindow *)sheet returnCode:(NSInteger)returnCode indexSet:(NSIndexSet *)indexSet;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 09/21/2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[indexSet autorelease];
	if(returnCode == NSAlertDefaultReturn)
	{
		NSUInteger currentIndex = [indexSet lastIndex];
		while (currentIndex != NSNotFound)
		{
			NSString * key = [self.orderedEnvironmentVariableNames objectAtIndex:currentIndex];
			[self.orderedEnvironmentVariableNames removeObjectAtIndex:currentIndex];
			[self.environmentVariables removeObjectForKey:key];
			currentIndex = [indexSet indexLessThanIndex:currentIndex];
		}
		[SUD setObject:self.environmentVariables forKey:iTM2EnvironmentVariablesKey];
		[self.environmentTableView reloadData];
	}
//END4iTM3;
    return;
}

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= validateRemoveEnvironmentVariable:
- (BOOL)validateRemoveEnvironmentVariable:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 09/21/2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return [[self.environmentTableView selectedRowIndexes] count];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= revertToDefaultEnvironment:
- (IBAction)revertToDefaultEnvironment:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 09/21/2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	// we have to switch used/unused
	// revert to the default value
	// we must preserve variables added by the user
	NSMutableDictionary * environmentVariables = self.environmentVariables;
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
			otherK = K.stringByDeletingPathExtension;
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
	[self.environmentTableView reloadData];
	[sender validateUserInterfaceItems4iTM3];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= validateRevertToDefaultEnvironment:
- (BOOL)validateRevertToDefaultEnvironment:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 09/21/2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return ![self.environmentVariables isEqual:[SUD dictionaryForKey:iTM2FactoryEnvironmentVariablesKey]];
}
#pragma mark =-=-=-=-=-  Output directory
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleOutputDirectory:
- (IBAction)toggleOutputDirectory:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [SUD setBool: ![SUD boolForKey:iTM2DistributionUseOutputDirectoryKey] forKey:iTM2DistributionUseOutputDirectoryKey];
    [self.mainView validateWindowContent4iTM3];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleOutputDirectory:
- (BOOL)validateToggleOutputDirectory:(NSButton *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    sender.state = ([SUD boolForKey:iTM2DistributionUseOutputDirectoryKey]? NSOnState:NSOffState);
//END4iTM3;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeOutputDirectoryFromStringValue:
- (IBAction)takeOutputDirectoryFromStringValue:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [SUD setObject:[sender stringValue] forKey:iTM2DistributionOutputDirectoryKey];
    [self.mainView validateWindowContent4iTM3];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateTakeOutputDirectoryFromStringValue:
- (BOOL)validateTakeOutputDirectoryFromStringValue:(NSTextField *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if(![sender formatter])
		[sender setFormatter:[[[iTM2FileNameFormatter alloc] init] autorelease]];
    [sender setStringValue: ([SUD stringForKey:iTM2DistributionOutputDirectoryKey]?:@"")];
	if([SUD boolForKey:iTM2DistributionUseOutputDirectoryKey])
		return YES;
	if(sender == sender.window.firstResponder)
		[sender.window makeFirstResponder:nil];
//END4iTM3;
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [SUD setBool: ![SUD boolForKey:iTM2DistributionUsePATHLoginShellKey] forKey:iTM2DistributionUsePATHLoginShellKey];
    [self.mainView validateWindowContent4iTM3];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateTogglePATHLoginShell:
- (BOOL)validateTogglePATHLoginShell:(NSButton *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    sender.state = ([SUD boolForKey:iTM2DistributionUsePATHLoginShellKey]? NSOnState:NSOffState);
//END4iTM3;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  togglePATHPrefix:
- (IBAction)togglePATHPrefix:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [SUD setBool: ![SUD boolForKey:iTM2DistributionUsePATHPrefixKey] forKey:iTM2DistributionUsePATHPrefixKey];
    [self.mainView validateWindowContent4iTM3];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateTogglePATHPrefix:
- (BOOL)validateTogglePATHPrefix:(NSButton *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    sender.state = ([SUD boolForKey:iTM2DistributionUsePATHPrefixKey]? NSOnState:NSOffState);
//END4iTM3;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takePATHPrefixFromStringValue:
- (IBAction)takePATHPrefixFromStringValue:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [SUD setObject:[sender stringValue] forKey:iTM2DistributionPATHPrefixKey];
    [self.mainView validateWindowContent4iTM3];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateTakePATHPrefixFromStringValue:
- (BOOL)validateTakePATHPrefixFromStringValue:(NSTextField *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if(![sender formatter])
		[sender setFormatter:[[[iTM2FileNameFormatter alloc] init] autorelease]];
    [sender setStringValue: ([SUD stringForKey:iTM2DistributionPATHPrefixKey]?:@"")];
	if([SUD boolForKey:iTM2DistributionUsePATHPrefixKey])
		return YES;
	if(sender == sender.window.firstResponder)
		[sender.window makeFirstResponder:nil];
//END4iTM3;
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  togglePATHSuffix:
- (IBAction)togglePATHSuffix:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [SUD setBool:![SUD boolForKey:iTM2DistributionUsePATHSuffixKey] forKey:iTM2DistributionUsePATHSuffixKey];
    [self.mainView validateWindowContent4iTM3];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateTogglePATHSuffix:
- (BOOL)validateTogglePATHSuffix:(NSButton *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    sender.state = ([SUD boolForKey:iTM2DistributionUsePATHSuffixKey]? NSOnState:NSOffState);
//END4iTM3;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takePATHSuffixFromStringValue:
- (IBAction)takePATHSuffixFromStringValue:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [SUD setObject:[sender stringValue] forKey:iTM2DistributionPATHSuffixKey];
    [self.mainView validateWindowContent4iTM3];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateTakePATHSuffixFromStringValue:
- (BOOL)validateTakePATHSuffixFromStringValue:(NSTextField *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if(![sender formatter])
		[sender setFormatter:[[[iTM2FileNameFormatter alloc] init] autorelease]];
    [sender setStringValue: ([SUD stringForKey:iTM2DistributionPATHSuffixKey]?:@"")];
	if([SUD boolForKey:iTM2DistributionUsePATHSuffixKey])
		return YES;
	if(sender == sender.window.firstResponder)
		[sender.window makeFirstResponder:nil];
//END4iTM3;
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSString * distribution = [SUD stringForKey:iTM2DistributionTeXMFPrograms];
	if([distribution pathIsEqual4iTM3:iTM2DistributionOldgwTeXIntel])
	{
		return iTM2DistributionOldgwTeX;
	}
	else if([distribution pathIsEqual4iTM3:iTM2DistributionFinkIntel])
	{
		return iTM2DistributionFink;
	}
	else if([distribution pathIsEqual4iTM3:iTM2DistributionTeXLiveIntel])
	{
		return iTM2DistributionTeXLive;
	}
	else if([distribution pathIsEqual4iTM3:iTM2DistributionTeXLiveDVDIntel])
	{
		return iTM2DistributionTeXLiveDVD;
	}
	else
		return distribution;
//END4iTM3;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  TeXMFProgramsDistributionIsIntel
- (BOOL)TeXMFProgramsDistributionIsIntel;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSString * distribution = [SUD stringForKey:iTM2DistributionTeXMFPrograms];
//END4iTM3;
    return [distribution pathIsEqual4iTM3:iTM2DistributionDefaultTeXDistIntel]
		|| [distribution pathIsEqual4iTM3:iTM2DistributiongwTeXIntel]
		|| [distribution pathIsEqual4iTM3:iTM2DistributionOldgwTeXIntel]
		|| [distribution pathIsEqual4iTM3:iTM2DistributionFinkIntel]
		|| [distribution pathIsEqual4iTM3:iTM2DistributionTeXLiveIntel]
		|| [distribution pathIsEqual4iTM3:iTM2DistributionTeXLiveDVDIntel];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setTeXMFProgramsDistributionIsIntel:
- (void)setTeXMFProgramsDistributionIsIntel:(BOOL)flag;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSString * distribution = [SUD stringForKey:iTM2DistributionTeXMFPrograms];
	if(flag)
	{
		if([distribution pathIsEqual4iTM3:iTM2DistributionDefaultTeXDist])
		{
			[SUD setObject:iTM2DistributionDefaultTeXDistIntel forKey:iTM2DistributionTeXMFPrograms];
		}
		else if([distribution pathIsEqual4iTM3:iTM2DistributiongwTeX])
		{
			[SUD setObject:iTM2DistributiongwTeXIntel forKey:iTM2DistributionTeXMFPrograms];
		}
		else if([distribution pathIsEqual4iTM3:iTM2DistributionOldgwTeX])
		{
			[SUD setObject:iTM2DistributionOldgwTeXIntel forKey:iTM2DistributionTeXMFPrograms];
		}
		else if([distribution pathIsEqual4iTM3:iTM2DistributionFink])
		{
			[SUD setObject:iTM2DistributionFinkIntel forKey:iTM2DistributionTeXMFPrograms];
		}
		else if([distribution pathIsEqual4iTM3:iTM2DistributionTeXLive])
		{
			[SUD setObject:iTM2DistributionTeXLiveIntel forKey:iTM2DistributionTeXMFPrograms];
		}
		else if([distribution pathIsEqual4iTM3:iTM2DistributionTeXLiveDVD])
		{
			[SUD setObject:iTM2DistributionTeXLiveDVDIntel forKey:iTM2DistributionTeXMFPrograms];
		}
	}
	else
	{
		if([distribution pathIsEqual4iTM3:iTM2DistributionDefaultTeXDistIntel])
		{
			[SUD setObject:iTM2DistributionDefaultTeXDist forKey:iTM2DistributionTeXMFPrograms];
		}
		else if([distribution pathIsEqual4iTM3:iTM2DistributiongwTeXIntel])
		{
			[SUD setObject:iTM2DistributiongwTeX forKey:iTM2DistributionTeXMFPrograms];
		}
		else if([distribution pathIsEqual4iTM3:iTM2DistributionOldgwTeXIntel])
		{
			[SUD setObject:iTM2DistributionOldgwTeX forKey:iTM2DistributionTeXMFPrograms];
		}
		else if([distribution pathIsEqual4iTM3:iTM2DistributionFinkIntel])
		{
			[SUD setObject:iTM2DistributionFink forKey:iTM2DistributionTeXMFPrograms];
		}
		else if([distribution pathIsEqual4iTM3:iTM2DistributionTeXLiveIntel])
		{
			[SUD setObject:iTM2DistributionTeXLive forKey:iTM2DistributionTeXMFPrograms];
		}
		else if([distribution pathIsEqual4iTM3:iTM2DistributionTeXLiveDVDIntel])
		{
			[SUD setObject:iTM2DistributionTeXLiveDVD forKey:iTM2DistributionTeXMFPrograms];
		}
	}
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  lossyOtherProgramsDistribution
- (NSString *)lossyOtherProgramsDistribution;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSString * distribution = [SUD stringForKey:iTM2DistributionOtherPrograms];
	if([distribution pathIsEqual4iTM3:iTM2DistributionDefaultTeXDistIntel])
	{
		return iTM2DistributionDefaultTeXDist;
	}
	else if([distribution pathIsEqual4iTM3:iTM2DistributiongwTeXIntel])
	{
		return iTM2DistributiongwTeX;
	}
	else if([distribution pathIsEqual4iTM3:iTM2DistributionOldgwTeXIntel])
	{
		return iTM2DistributionOldgwTeX;
	}
	else if([distribution pathIsEqual4iTM3:iTM2DistributionFinkIntel])
	{
		return iTM2DistributionFink;
	}
	else if([distribution pathIsEqual4iTM3:iTM2DistributionTeXLiveIntel])
	{
		return iTM2DistributionTeXLive;
	}
	else if([distribution pathIsEqual4iTM3:iTM2DistributionTeXLiveDVDIntel])
	{
		return iTM2DistributionTeXLiveDVD;
	}
	else
		return distribution;
//END4iTM3;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  OtherProgramsDistributionIsIntel
- (BOOL)OtherProgramsDistributionIsIntel;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSString * distribution = [SUD stringForKey:iTM2DistributionOtherPrograms];
//END4iTM3;
    return [distribution pathIsEqual4iTM3:iTM2DistributionDefaultTeXDistIntel]
		|| [distribution pathIsEqual4iTM3:iTM2DistributiongwTeXIntel]
		|| [distribution pathIsEqual4iTM3:iTM2DistributionOldgwTeXIntel]
		|| [distribution pathIsEqual4iTM3:iTM2DistributionFinkIntel]
		|| [distribution pathIsEqual4iTM3:iTM2DistributionTeXLiveIntel]
		|| [distribution pathIsEqual4iTM3:iTM2DistributionTeXLiveDVDIntel];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setOtherProgramsDistributionIsIntel:
- (void)setOtherProgramsDistributionIsIntel:(BOOL)flag;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSString * distribution = [SUD stringForKey:iTM2DistributionOtherPrograms];
	if(flag)
	{
		if([distribution pathIsEqual4iTM3:iTM2DistributionDefaultTeXDist])
		{
			[SUD setObject:iTM2DistributionDefaultTeXDistIntel forKey:iTM2DistributionOtherPrograms];
		}
		else if([distribution pathIsEqual4iTM3:iTM2DistributiongwTeX])
		{
			[SUD setObject:iTM2DistributiongwTeXIntel forKey:iTM2DistributionOtherPrograms];
		}
		else if([distribution pathIsEqual4iTM3:iTM2DistributionOldgwTeX])
		{
			[SUD setObject:iTM2DistributionOldgwTeXIntel forKey:iTM2DistributionOtherPrograms];
		}
		else if([distribution pathIsEqual4iTM3:iTM2DistributionFink])
		{
			[SUD setObject:iTM2DistributionFinkIntel forKey:iTM2DistributionOtherPrograms];
		}
		else if([distribution pathIsEqual4iTM3:iTM2DistributionTeXLive])
		{
			[SUD setObject:iTM2DistributionTeXLiveIntel forKey:iTM2DistributionOtherPrograms];
		}
		else if([distribution pathIsEqual4iTM3:iTM2DistributionTeXLiveDVD])
		{
			[SUD setObject:iTM2DistributionTeXLiveDVDIntel forKey:iTM2DistributionOtherPrograms];
		}
	}
	else
	{
		if([distribution pathIsEqual4iTM3:iTM2DistributionDefaultTeXDistIntel])
		{
			[SUD setObject:iTM2DistributionDefaultTeXDist forKey:iTM2DistributionOtherPrograms];
		}
		else if([distribution pathIsEqual4iTM3:iTM2DistributiongwTeXIntel])
		{
			[SUD setObject:iTM2DistributiongwTeX forKey:iTM2DistributionOtherPrograms];
		}
		else if([distribution pathIsEqual4iTM3:iTM2DistributionOldgwTeXIntel])
		{
			[SUD setObject:iTM2DistributionOldgwTeX forKey:iTM2DistributionOtherPrograms];
		}
		else if([distribution pathIsEqual4iTM3:iTM2DistributionFinkIntel])
		{
			[SUD setObject:iTM2DistributionFink forKey:iTM2DistributionOtherPrograms];
		}
		else if([distribution pathIsEqual4iTM3:iTM2DistributionTeXLiveIntel])
		{
			[SUD setObject:iTM2DistributionTeXLive forKey:iTM2DistributionOtherPrograms];
		}
		else if([distribution pathIsEqual4iTM3:iTM2DistributionTeXLiveDVDIntel])
		{
			[SUD setObject:iTM2DistributionTeXLiveDVD forKey:iTM2DistributionOtherPrograms];
		}
	}
//END4iTM3;
    return;
}
#pragma mark =-=-=-=-=-  DISTRIBUTIONS
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeTeXMFProgramsDistributionFromPopUp:
- (IBAction)takeTeXMFProgramsDistributionFromPopUp:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 06:28:11 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if([sender isKindOfClass:[NSPopUpButton class]])
		sender = [sender selectedItem];
	if([sender isKindOfClass:[NSMenuItem class]])
	{
		BOOL isIntel = self.TeXMFProgramsDistributionIsIntel;
		id old = [SUD stringForKey:iTM2DistributionTeXMFPrograms];
		[SUD setObject:[sender representedObject] forKey:iTM2DistributionTeXMFPrograms];
		[self setTeXMFProgramsDistributionIsIntel:isIntel];
		id new = [SUD stringForKey:iTM2DistributionTeXMFPrograms];
		if(![old pathIsEqual4iTM3:new])
		{
			[self.mainView validateWindowContent4iTM3];
		}
	}
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateTakeTeXMFProgramsDistributionFromPopUp:
- (BOOL)validateTakeTeXMFProgramsDistributionFromPopUp:(id)theSender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 06:28:11 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if([theSender isKindOfClass:[NSPopUpButton class]])
	{
        #define sender ((NSPopUpButton *)theSender)
		NSString * distribution = self.lossyTeXMFProgramsDistribution;
		NSUInteger index = [sender indexOfItemWithRepresentedObject:distribution];
		if(index < [sender numberOfItems])
			[sender selectItemAtIndex:index];
		else if([distribution pathIsEqual4iTM3:iTM2DistributionDefault])
			[sender selectItemWithTag:iTM2TeXDistributionDefaultTag];
		else if([distribution pathIsEqual4iTM3:iTM2DistributionBuiltIn])
			[sender selectItemWithTag:iTM2TeXDistributionBuiltInTag];
		else if([distribution pathIsEqual4iTM3:iTM2DistributionDefaultTeXDist])
			[sender selectItemWithTag:iTM2TeXDistributionDefaultTeXDistTag];
		else if([distribution pathIsEqual4iTM3:iTM2DistributiongwTeX])
			[sender selectItemWithTag:iTM2TeXDistributionGWTeXTag];
		else if([distribution pathIsEqual4iTM3:iTM2DistributionOldgwTeX])
			[sender selectItemWithTag:iTM2TeXDistributionOldGWTeXTag];
		else if([distribution pathIsEqual4iTM3:iTM2DistributionFink])
			[sender selectItemWithTag:iTM2TeXDistributionFinkTag];
		else if([distribution pathIsEqual4iTM3:iTM2DistributionTeXLive])
			[sender selectItemWithTag:iTM2TeXDistributionTeXLiveTag];
		else if([distribution pathIsEqual4iTM3:iTM2DistributionTeXLiveDVD])
			[sender selectItemWithTag:iTM2TeXDistributionTeXLiveDVDTag];
		else if([distribution pathIsEqual4iTM3:iTM2DistributionOther])
			[sender selectItemWithTag:iTM2TeXDistributionOtherTag];
		else if([distribution pathIsEqual4iTM3:iTM2DistributionCustom])
			[sender selectItemWithTag:iTM2TeXDistributionCustomTag];
		return YES;
        #undef sender
	}
	else if([theSender isKindOfClass:[NSMenuItem class]])
	{
		#define sender ((NSMenuItem *)theSender)
		id representedObject;
		switch(sender.tag)
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
		sender.representedObject = representedObject;
		return YES;
        #undef sender
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
	id new = [sender stringValue];
	NSString * key = [iTM2DistributionDomainTeXMFPrograms stringByAppendingPathExtension:[SUD stringForKey:iTM2DistributionTeXMFPrograms]];
	if(![[SUD stringForKey:key] pathIsEqual4iTM3:new])
	{
		[SUD setObject:new forKey:key];
		[self.mainView validateWindowContent4iTM3];
	}
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateTakeTeXMFProgramsPathFromStringValue:
- (BOOL)validateTakeTeXMFProgramsPathFromStringValue:(NSControl *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 06:28:11 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if(![sender formatter])
		[sender setFormatter:[[[iTM2FileNameFormatter alloc] init] autorelease]];
	NSString * distribution = [SUD stringForKey:iTM2DistributionTeXMFPrograms];
	NSString * key = [iTM2DistributionDomainTeXMFPrograms stringByAppendingPathExtension:distribution];
	NSString * path = [SUD stringForKey:key]?: @"";
	if([DFM fileExistsAtPath:path])
		sender.stringValue = path;
	else
		[sender setAttributedStringValue:[[[NSAttributedString alloc] initWithString: path
			attributes: [NSDictionary dictionaryWithObject:[NSColor redColor] forKey:NSForegroundColorAttributeName]] autorelease]];
	if([distribution pathIsEqual4iTM3:iTM2DistributionCustom])
		return YES;
	if(sender == sender.window.firstResponder)
		[sender.window makeFirstResponder:nil];
//END4iTM3;
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeOtherProgramsDistributionFromPopUp:
- (IBAction)takeOtherProgramsDistributionFromPopUp:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 06:28:11 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if([sender isKindOfClass:[NSPopUpButton class]])
		sender = [sender selectedItem];
	if([sender isKindOfClass:[NSMenuItem class]])
	{
		BOOL isIntel = self.OtherProgramsDistributionIsIntel;
		id old = [SUD stringForKey:iTM2DistributionOtherPrograms];
		[SUD setObject:[sender representedObject] forKey:iTM2DistributionOtherPrograms];
		[self setOtherProgramsDistributionIsIntel:isIntel];
		id new = [SUD stringForKey:iTM2DistributionOtherPrograms];
		if(![old pathIsEqual4iTM3:new])
		{
			[self.mainView validateWindowContent4iTM3];
		}
	}
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateTakeOtherProgramsDistributionFromPopUp:
- (BOOL)validateTakeOtherProgramsDistributionFromPopUp:(id)theSender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 06:28:11 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if([theSender isKindOfClass:[NSPopUpButton class]])
	{
        #define sender ((NSPopUpButton *)theSender)
		NSString * distribution = self.lossyOtherProgramsDistribution;
		NSUInteger index = [sender indexOfItemWithRepresentedObject:distribution];
		if(index < [sender numberOfItems])
			[sender selectItemAtIndex:index];
		else if([distribution pathIsEqual4iTM3:iTM2DistributionDefault])
			[sender selectItemWithTag:iTM2TeXDistributionDefaultTag];
		else if([distribution pathIsEqual4iTM3:iTM2DistributionBuiltIn])
			[sender selectItemWithTag:iTM2TeXDistributionBuiltInTag];
		else if([distribution pathIsEqual4iTM3:iTM2DistributionDefaultTeXDist])
			[sender selectItemWithTag:iTM2TeXDistributionDefaultTeXDistTag];
		else if([distribution pathIsEqual4iTM3:iTM2DistributiongwTeX])
			[sender selectItemWithTag:iTM2TeXDistributionGWTeXTag];
		else if([distribution pathIsEqual4iTM3:iTM2DistributionOldgwTeX])
			[sender selectItemWithTag:iTM2TeXDistributionOldGWTeXTag];
		else if([distribution pathIsEqual4iTM3:iTM2DistributionFink])
			[sender selectItemWithTag:iTM2TeXDistributionFinkTag];
		else if([distribution pathIsEqual4iTM3:iTM2DistributionTeXLive])
			[sender selectItemWithTag:iTM2TeXDistributionTeXLiveTag];
		else if([distribution pathIsEqual4iTM3:iTM2DistributionTeXLiveDVD])
			[sender selectItemWithTag:iTM2TeXDistributionTeXLiveDVDTag];
		else if([distribution pathIsEqual4iTM3:iTM2DistributionOther])
			[sender selectItemWithTag:iTM2TeXDistributionOtherTag];
		else if([distribution pathIsEqual4iTM3:iTM2DistributionCustom])
			[sender selectItemWithTag:iTM2TeXDistributionCustomTag];
		return YES;
        #undef sender
	}
	else if([theSender isKindOfClass:[NSMenuItem class]])
	{
		#define sender ((NSMenuItem *)theSender)
		id representedObject;
		switch(sender.tag)
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
		sender.representedObject = representedObject;
		return YES;
        #undef sender
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
	id new = [sender stringValue];
	NSString * key = [iTM2DistributionDomainOtherPrograms stringByAppendingPathExtension:[SUD stringForKey:iTM2DistributionOtherPrograms]];
	if(![[SUD stringForKey:key] pathIsEqual4iTM3:new])
	{
		[SUD setObject:new forKey:key];
		[self.mainView validateWindowContent4iTM3];
	}
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateTakeOtherProgramsPathFromStringValue:
- (BOOL)validateTakeOtherProgramsPathFromStringValue:(NSTextField *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 06:28:11 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if(![sender formatter])
		[sender setFormatter:[[[iTM2FileNameFormatter alloc] init] autorelease]];
	NSString * distribution = [SUD stringForKey:iTM2DistributionOtherPrograms];
	NSString * key = [iTM2DistributionDomainOtherPrograms stringByAppendingPathExtension:distribution];
	NSString * path = [SUD stringForKey:key]?: @"";
	if([DFM fileExistsAtPath:path])
		sender.stringValue = path;
	else
		[sender setAttributedStringValue:[[[NSAttributedString alloc] initWithString: path
			attributes: [NSDictionary dictionaryWithObject:[NSColor redColor] forKey:NSForegroundColorAttributeName]] autorelease]];
	if([distribution pathIsEqual4iTM3:iTM2DistributionCustom])
		return YES;
	if(sender == sender.window.firstResponder)
		[sender.window makeFirstResponder:nil];
//END4iTM3;
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleTeXMFProgramsCPUType:
- (IBAction)toggleTeXMFProgramsCPUType:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[self setTeXMFProgramsDistributionIsIntel: !self.TeXMFProgramsDistributionIsIntel];
	[self.mainView validateWindowContent4iTM3];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleTeXMFProgramsCPUType:
- (BOOL)validateToggleTeXMFProgramsCPUType:(NSButton *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if(![NSBundle isI386_4iTM3])
	{
		sender.action = NULL;
		[sender setHidden:YES];
		return YES;
	}
	if([[SUD stringForKey:iTM2DistributionTeXMFPrograms] pathIsEqual4iTM3:iTM2DistributionCustom])
	{
		sender.state = NSMixedState;
		return NO;
	}
	sender.state = (self.TeXMFProgramsDistributionIsIntel?NSOnState:NSOffState);
//END4iTM3;
	return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleOtherProgramsCPUType:
- (IBAction)toggleOtherProgramsCPUType:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[self setOtherProgramsDistributionIsIntel: !self.OtherProgramsDistributionIsIntel];
	[self.mainView validateWindowContent4iTM3];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleOtherProgramsCPUType:
- (BOOL)validateToggleOtherProgramsCPUType:(NSButton *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 23 23:02:08 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if(![NSBundle isI386_4iTM3])
	{
		sender.action = NULL;
		[sender setHidden:YES];
		return YES;
	}
	if([[SUD stringForKey:iTM2DistributionOtherPrograms] pathIsEqual4iTM3:iTM2DistributionCustom])
	{
		sender.state = NSMixedState;
		return NO;
	}
	sender.state = (self.OtherProgramsDistributionIsIntel?NSOnState:NSOffState);
//END4iTM3;
	return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  chooseTeXMFProgramsFromPanel:
- (IBAction)chooseTeXMFProgramsFromPanel:(NSButton *) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSOpenPanel * OP = [NSOpenPanel openPanel];
    [OP setCanChooseFiles:NO];
    [OP setCanChooseDirectories:YES];
    [OP setTreatsFilePackagesAsDirectories:YES];
    [OP setAllowsMultipleSelection:NO];
    OP.delegate = self;
    [OP setResolvesAliases:YES];
	[OP setPrompt:sender.title];
    [OP beginSheetForDirectory:NSHomeDirectory()
        file:nil types:nil modalForWindow:sender.window
            modalDelegate:self didEndSelector:@selector(chooseTeXMFProgramsFromPanel:returnCode:contextInfo:)
				contextInfo:nil];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  chooseTeXMFProgramsFromPanel:returnCode:contextInfo:
- (void)chooseTeXMFProgramsFromPanel:(NSOpenPanel *)panel returnCode:(NSInteger)returnCode contextInfo:(void  *)irrelevant;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Nov 18 07:53:25 GMT 2006
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if(returnCode == NSOKButton)
	{
		NSString * new = [panel filename];
		NSString * key = [SUD stringForKey:iTM2DistributionTeXMFPrograms];
		key = [iTM2DistributionDomainTeXMFPrograms stringByAppendingPathExtension:key];
		if(![[SUD stringForKey:key] pathIsEqual4iTM3:new])
		{
			[SUD setObject:new forKey:key];
			[self.mainView validateWindowContent4iTM3];
		}
	}
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateChooseTeXMFProgramsFromPanel:
- (BOOL)validateChooseTeXMFProgramsFromPanel:(id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSString * distribution = [SUD stringForKey:iTM2DistributionTeXMFPrograms];
	if([distribution pathIsEqual4iTM3:iTM2DistributionCustom])
	{
		[sender setHidden:NO];
//END4iTM3;
		return YES;
	}
	else
	{
		[sender setHidden:YES];
//END4iTM3;
		return NO;
	}
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  chooseOtherProgramsFromPanel:
- (IBAction)chooseOtherProgramsFromPanel:(NSButton *) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSOpenPanel * OP = [NSOpenPanel openPanel];
    [OP setCanChooseFiles:NO];
    [OP setCanChooseDirectories:YES];
    [OP setTreatsFilePackagesAsDirectories:YES];
    [OP setAllowsMultipleSelection:NO];
    OP.delegate = self;
    [OP setResolvesAliases:YES];
	[OP setPrompt:sender.title];
    [OP beginSheetForDirectory:NSHomeDirectory()
        file:nil types:nil modalForWindow:sender.window
            modalDelegate:self didEndSelector:@selector(chooseOtherProgramsFromPanel:returnCode:contextInfo:)
				contextInfo:nil];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  chooseOtherProgramsFromPanel:returnCode:contextInfo:
- (void)chooseOtherProgramsFromPanel:(NSOpenPanel *)panel returnCode:(NSInteger)returnCode contextInfo:(void  *)irrelevant;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Nov 18 07:53:25 GMT 2006
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if(returnCode == NSOKButton)
	{
		NSString * new = [panel filename];
		NSString * key = [SUD stringForKey:iTM2DistributionTeXMFPrograms];
		key = [iTM2DistributionDomainOtherPrograms stringByAppendingPathExtension:key];
		if(![[SUD stringForKey:key] pathIsEqual4iTM3:new])
		{
			[SUD setObject:new forKey:key];
			[self.mainView validateWindowContent4iTM3];
		}
	}
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateChooseOtherProgramsFromPanel:
- (BOOL)validateChooseOtherProgramsFromPanel:(id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSString * distribution = [SUD stringForKey:iTM2DistributionOtherPrograms];
	if([distribution pathIsEqual4iTM3:iTM2DistributionCustom])
	{
		[sender setHidden:NO];
//END4iTM3;
		return YES;
	}
	else
	{
		[sender setHidden:YES];
//END4iTM3;
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
#warning NYI: MISSING
//END4iTM3;
	return;
}
@end

