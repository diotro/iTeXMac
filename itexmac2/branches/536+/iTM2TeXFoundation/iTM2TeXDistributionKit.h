/*
//
//  @version Subversion: $Id$ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Mon Nov 22 07:56:02 GMT 2004.
//  Copyright © 2001-2004 Laurens'Tribune. All rights reserved.
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

typedef enum
{
      iTM2TeXDistributionDefault = 0,
      iTM2TeXDistributionBuiltIn = 1,
      iTM2TeXDistributionGWTeX = 2,
      iTM2TeXDistributionFink = 3,
      iTM2TeXDistributionTeXLive = 4,
      iTM2TeXDistributionTeXLiveDVD = 5,
      iTM2TeXDistributionOther = -1
} iTM2TeXDistributionType;

typedef enum
{
      iTM2TeXMFProgramsDomain = 0,
      iTM2TeXMFDomain = 1,
      iTM2OtherDomain = 2,
      iTM2DocumentationDomain = 3
} iTM2PathDomainType;

@interface iTM2TeXDistributionController: NSObject
+ (NSString *)formatsPath;
+ (NSDictionary *)fmtsAtPath:(NSString *)path;
+ (NSArray *)basesAtPath:(NSString *)path;
+ (NSArray *)memsAtPath:(NSString *)path;
@end

/*!
	@category		NSApplication(iTM2TeXDistributionKit)
	@abstract		TeX distribution support.
	@discussion		See below.
	@availability	iTM2.
	@copyright		2005 jlaurens AT users DOT sourceforge DOT net and others.
*/
@interface NSApplication(iTM2TeXDistributionKit)

/*!
	@method			showTeXDistributionPreferences:
	@abstract		Order front the appropriate preferences panel.
	@discussion		Discussion forthcoming.
	@argument		Irrelevant sender.
	@result			None.
	@availability	iTM2.
	@copyright		2005 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (IBAction)showTeXDistributionPreferences:(id)sender;

@end

#if 0
extern NSString * const iTM2DistributionTeXMFPrograms;
extern NSString * const iTM2DistributionOtherPrograms;

extern NSString * const iTM2DistributionDefault;
extern NSString * const iTM2DistributionBuiltIn;// Not yet used
extern NSString * const iTM2DistributiongwTeX;
extern NSString * const iTM2DistributionOldgwTeX;
extern NSString * const iTM2DistributionFink;
extern NSString * const iTM2DistributionTeXLive;
extern NSString * const iTM2DistributionTeXLiveDVD;
extern NSString * const iTM2DistributionOther;// from the defaults: the custom distribution of the defaults
extern NSString * const iTM2DistributionCustom;// for the project or the defaults

extern NSString * const iTM2DistributionDomainTeXMFPrograms;
extern NSString * const iTM2DistributionDomainOtherPrograms;
extern NSString * const iTM2DistributionDomainChostScriptPrograms;
#endif

typedef enum
{
      iTM2TeXDistributionDefaultTag = 0,
      iTM2TeXDistributionDefaultTeXDistTag = -3,
      iTM2TeXDistributionBuiltInTag = 1,
      iTM2TeXDistributionGWTeXLiveTag = -4,
      iTM2TeXDistributionOldGWTeXTag = 2,
      iTM2TeXDistributionGWTeXTag = 6,
      iTM2TeXDistributionFinkTag = 3,
      iTM2TeXDistributionTeXLiveTag = 4,
      iTM2TeXDistributionTeXLiveDVDTag = 5,
      iTM2TeXDistributionOtherTag = -1,
      iTM2TeXDistributionCustomTag = -2
} iTM2TeXDistributionTag;

#import <iTM2TeXFoundation/iTM2TeXProjectDocumentKit.h>

@interface iTM2TeXProjectDocument(TeXDistributionKit)

/*! 
    @method     commonCommandOutputDirectory
    @abstract   Abstract forthcoming.
    @discussion Discussion forthcoming.
    @param      None.
    @result     result forthcoming
*/
- (NSString *)commonCommandOutputDirectory;

+ (NSString *)defaultTeXMFProgramsPath;
+ (NSString *)defaultOtherProgramsPath;
- (NSString *)TeXMFDistribution;// low level getter
- (void)setTeXMFDistribution:(NSString *)argument;
- (NSString *)TeXMFProgramsDistribution;// low level getter
- (void)setTeXMFProgramsDistribution:(NSString *)argument;
- (NSString *)OtherProgramsDistribution;// low level getter
- (void)setOtherProgramsDistribution:(NSString *)argument;
- (NSString *)getTeXMFProgramsPath;
- (NSString *)TeXMFProgramsPath;
- (void)setTeXMFProgramsPath:(NSString *)argument;
- (NSString *)getOtherProgramsPath;
- (NSString *)OtherProgramsPath;
- (void)setOtherProgramsPath:(NSString *)argument;
- (BOOL)getPATHUsesLoginShell;
- (NSString *)getPATHPrefix;
- (NSString *)getPATHSuffix;
- (NSString *)getCompletePATHPrefix;
- (NSString *)getCompletePATHSuffix;
- (NSString *)getCompleteTEXMFOUTPUT;
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2DistributionServer
