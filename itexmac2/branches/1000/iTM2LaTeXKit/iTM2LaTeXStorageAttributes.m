/*
//  iTM2LaTeXStorageAttributes.m
//  iTeXMac2
//
//  @version Subversion: $Id: iTM2LaTeXKit.m 542 2007-06-04 12:31:20Z jlaurens $ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Sun Jun 24 2001.
//  Copyright © 2001-2004 Laurens'Tribune. All rights reserved.
//
//  This program is free software; you can redistribute it and/or modify it under the terms
//  of the GNU General Public License as published by the Free Software Foundation; either
//  version 2 of the License, or any later version.
//  This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
//  without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
//  See the GNU General Public License for more details. You should have received a copy
//  of the GNU General Public License along with this program; if not, write to the Free Software
//  Foundation, Inc., 59 Temple Place-Suite 330, Boston, MA 02111-1307, USA.
//  GPL addendum: Any simple modification of the present code which purpose is to remove bug,
//  improve efficiency in both code execution and code reading or writing should be addressed
//  to the actual developper team.
*/

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  attributesAtIndex:effectiveRange:
- (NSDictionary *)attributesAtIndex:(NSUInteger)aLocation effectiveRange:(NSRangePointer)aRangePtr;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSUInteger mode;
	NSUInteger status = [self getSyntaxMode:&mode atIndex:aLocation longestRange:aRangePtr];
	NSUInteger switcher = mode & ~kiTM2TeXFlagsSyntaxMask;
	NSString * syntaxMode;
	id attributes;
    if (switcher==kiTM2TeXCommandStartSyntaxMode) {
		if (aLocation+1 < [self.textStorage length]) {
			NSUInteger nextMode;
			status = [self getSyntaxMode:&nextMode atIndex:aLocation+1 longestRange:aRangePtr];
			NSUInteger nextSwitcher = nextMode & ~kiTM2TeXFlagsSyntaxMask;
			if (nextSwitcher>=kiTM2LaTeXFirstSyntaxMode) {
				nextSwitcher-=kiTM2LaTeXFirstSyntaxMode;
				if (nextSwitcher<_iTM2LaTeXModeForModeArray.count) {
					if (aRangePtr) {
						aRangePtr->location -= 1;
						aRangePtr->length += 1;
					}
					syntaxMode = [_iTM2LaTeXModeForModeArray objectAtIndex:nextSwitcher];
					attributes = [iVarAS4iTM3 attributesForMode:syntaxMode];
					return attributes;
				}
			}
		}
	} else if(switcher>=kiTM2LaTeXFirstSyntaxMode) {
		switcher-=kiTM2LaTeXFirstSyntaxMode;
		if(switcher<_iTM2LaTeXModeForModeArray.count) {
			if(aRangePtr) {
				NSUInteger max = iTM3MaxRange(*aRangePtr);
				aRangePtr->location = aLocation;
				aRangePtr->length = max-aLocation;
			}
			syntaxMode = [_iTM2LaTeXModeForModeArray objectAtIndex:switcher];
			attributes = [iVarAS4iTM3 attributesForMode:syntaxMode];
			return attributes;
		}
	}
	return [super attributesAtIndex:aLocation effectiveRange:aRangePtr];
}
