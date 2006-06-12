/*
//  iTM2PathUtilities.h
//  iTeXMac2
//
//  @version Subversion: $Id$ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Sat Jun 16 2001.
//  Copyright © 2001-2004 Laurens'Tribune. All rights reserved.
//
//  This program is free software; you can redistribute it and/or modify it under the terms
//  of the GNU General Public License as published by the Free Software Foundation; either
//  version 2 of the License, or any later version.
//  This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
//  without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
//  See the GNU General Public License for more details. You should have received a copy
//  of the GNU General Public License along with this program; if not, write to the Free Software
//  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
//  GPL addendum: Any simple modification of the present code which purpose is to remove bug,
//  improve efficiency in both code execution and code reading or writing should be addressed
//  to the actual developper team.
*/


//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= 
/*"Description forthcoming."*/
@interface NSString(iTM2PathUtilities)
- (BOOL) isFinderAliasTraverseLink: (BOOL) aFlag isDirectory: (BOOL *) isDirectory;
- (NSString *) stringByResolvingFinderAliasesInPath;
- (NSString *) stringByResolvingSymlinksAndFinderAliasesInPath;
- (NSString *) stringByAbbreviatingWithDotsRelativeToDirectory: (NSString *) aPath;
- (NSString *) shortestStringByAbbreviatingWithTildeInPath;
- (NSString *) stringByDeletingAllPathExtensions;
- (NSString *) stringByNormalizingPath;// removes void components, references to . and resolves .. as far as can do
@end

/*! 
    @const		iTM2PATHDomainX11BinariesKey
    @abstract   Description Forthcoming.
    @discussion Apple X11 server is supported. naries available in the standard user defaults datyabase.
				Here is the key for the X11 binaries. This is designed for PATH environment variable only
                (a : separated list of paths is returned)
                The default value is
                /usr/X11R6/bin:/usr/bin/X11:/usr/local/bin/X11
                but you can override it with
                defaults write comp.text.tex.iTeXMac2 "iTM2PATHX11Binaries" 'blah:bluh:bloh'
				Use [SUD stringForKey:iTM2PATHDomainX11BinariesKey];
*/
extern NSString * const iTM2PATHDomainX11BinariesKey;

extern NSString * const iTM2PATHPrefixKey;
extern NSString * const iTM2PATHSuffixKey;

@interface iTM2PATHServer: NSObject
@end
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2PathUtilities
