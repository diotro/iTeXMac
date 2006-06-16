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
      iTM2TeXDistributionTeXLiveCD = 5,
      iTM2TeXDistributionOther = -1
} iTM2TeXDistributionType;

typedef enum
{
      iTM2TeXMFBinariesDomain = 0,
      iTM2TeXMFDomain = 1,
      iTM2GhostScriptDomain = 2,
      iTM2DocumentationDomain = 3
} iTM2PathDomainType;

@interface iTM2TeXDistributionController: NSObject
+(NSString *)formatsPath;
+(NSDictionary *)fmtsAtPath:(NSString *)path;
+(NSArray *)basesAtPath:(NSString *)path;
+(NSArray *)memsAtPath:(NSString *)path;
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
-(IBAction)showTeXDistributionPreferences:(id)sender;

@end

extern NSString * const iTM2DistributionTeXMF;
extern NSString * const iTM2DistributionTeXMFBinaries;
extern NSString * const iTM2DistributionGhostScriptBinaries;

extern NSString * const iTM2DistributionDefault;
extern NSString * const iTM2DistributionBuiltIn;// Not yet used
extern NSString * const iTM2DistributiongwTeX;
extern NSString * const iTM2DistributionFink;
extern NSString * const iTM2DistributionTeXLive;
extern NSString * const iTM2DistributionTeXLiveCD;
extern NSString * const iTM2DistributionOther;// from the defaults: the custom distribution of the defaults
extern NSString * const iTM2DistributionCustom;// for the project or the defaults

extern NSString * const iTM2DistributionDomainTeXMF;
extern NSString * const iTM2DistributionDomainTeXMFBinaries;
extern NSString * const iTM2DistributionDomainGhostScriptBinaries;

typedef enum
{
      iTM2TeXDistributionDefaultTag = 0,
      iTM2TeXDistributionBuiltInTag = 1,
      iTM2TeXDistributionGWTeXTag = 2,
      iTM2TeXDistributionFinkTag = 3,
      iTM2TeXDistributionTeXLiveTag = 4,
      iTM2TeXDistributionTeXLiveCDTag = 5,
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
-(NSString *)commonCommandOutputDirectory;

+(NSString *)defaultTeXMFPath;
+(NSString *)defaultTeXMFBinariesPath;
+(NSString *)defaultGhostScriptBinariesPath;
-(NSString *)TeXMFDistribution;// low level getter
-(void)setTeXMFDistribution:(NSString *)argument;
-(NSString *)TeXMFBinariesDistribution;// low level getter
-(void)setTeXMFBinariesDistribution:(NSString *)argument;
-(NSString *)GhostScriptBinariesDistribution;// low level getter
-(void)setGhostScriptBinariesDistribution:(NSString *)argument;
-(NSString *)getTeXMFPath;
-(NSString *)TeXMFPath;
-(void)setTeXMFPath:(NSString *)argument;
-(NSString *)getTeXMFBinariesPath;
-(NSString *)TeXMFBinariesPath;
-(void)setTeXMFBinariesPath:(NSString *)argument;
-(NSString *)getGhostScriptBinariesPath;
-(NSString *)GhostScriptBinariesPath;
-(void)setGhostScriptBinariesPath:(NSString *)argument;
-(NSString *)getPATHPrefix;
-(NSString *)getPATHSuffix;
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2DistributionServer
