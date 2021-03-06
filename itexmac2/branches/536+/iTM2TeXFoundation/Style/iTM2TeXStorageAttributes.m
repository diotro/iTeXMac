/*
//
//  @version Subversion: $Id: iTM2TeXStorageKit.m 367 2007-01-20 03:06:40Z jlaurens $ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Tue Oct 16 2001.
//  Copyright © 2004 Laurens'Tribune. All rights reserved.
//
//  This program is free software; you can redistribute it and/or modify it under the terms
//  of the GNU General Public License as published by the Free Software Foundation; either
//  version 2 of the License, or any later version, modified by the addendum below.
//  This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
//  without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
//  See the GNU General Public License for more details. You should have received a copy
//  of the GNU General Public License along with this program; if not, write to the Free Software
//  Foundation, Inc., 59 Temple Place-Suite 330, Boston, MA 02111-1307, USA.
//  GPL addendum: Any simple modification of the present code which purpose is to remove bug,
//  improve efficiency in both code execution and code reading or writing should be addressed
//  to the actual developper team.
//
//  Version history: (format "- date:contribution(contributor)") 
//  To Do List: (format "- proposition(percentage actually done)")
*/
#include <iTM2Foundation/ICURegEx.h>

#if 0
@implementation iTM2TeXParser
#endif
#pragma mark =-=-=-=-=-  iTM2TeXParser:
#pragma mark -
#pragma mark =-=-=-=-=-  NO SYMBOLS:
#ifndef iTM2_WITH_SYMBOLS
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  getSyntaxMode:forCharacter:previousMode:
- (unsigned)getSyntaxMode:(unsigned *)newModeRef forCharacter:(unichar)theChar previousMode:(unsigned)previousMode;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Dec 12 22:44:56 GMT 2003
To Do List: 
"*/
{iTM2_DIAGNOSTIC;
	NSParameterAssert(newModeRef);
//iTM2_START;
//    if(previousMode != ( previousMode & ~kiTM2TeXFlagsSyntaxMask))
//        NSLog(@"previousMode: 0X%x, mask: 0X%x, previousMode & ~mask: 0X%x",  previousMode, kiTM2TeXErrorSyntaxModeMask,  previousMode & ~kiTM2TeXFlagsSyntaxMask);
//iTM2_LOG(@"C'est %.1S qui s'y colle", &theChar);
	unsigned previousError = previousMode & kiTM2TeXErrorSyntaxMask;
	unsigned previousModifier = previousMode & kiTM2TeXModifiersSyntaxMask;
	if(previousModifier & kiTM2TeXEndOfLineSyntaxMask)
	{
		// this is the first character of the line
		if(theChar == ' ')
		{
			* newModeRef = kiTM2TeXWhitePrefixSyntaxMode | previousError | previousModifier;
			return kiTM2TeXNoErrorSyntaxStatus;
		}
		previousModifier &= ~kiTM2TeXEndOfLineSyntaxMask;
	}
	unsigned previousModeWithoutModifiers = previousMode & ~kiTM2TeXFlagsSyntaxMask;
	unsigned newModifier = previousModifier;
	newModifier = previousModifier  & ~kiTM2TeXAtSyntaxMask;
	newModifier = newModifier  & ~kiTM2TeXCommandSyntaxMask;
	unsigned status = kiTM2TeXNoErrorSyntaxStatus;
	NSString * modeString = @"";
	unsigned newMode = previousModeWithoutModifiers;
#if 0
CAS0(kiTM2TeXWhitePrefixSyntaxMode,				previousModeWithoutModifiers,	previousModifier);
CAS0(kiTM2TeXRegularSyntaxMode,					previousModeWithoutModifiers,	previousModifier);
CAS1(kiTM2TeXCommandStartSyntaxMode,			previousModeWithoutModifiers,	previousModifier);
CAS0(kiTM2TeXCommandEscapedCharacterSyntaxMode,	previousModeWithoutModifiers,	previousModifier);
CAS0(kiTM2TeXCommandContinueSyntaxMode,			previousModeWithoutModifiers,	previousModifier);
CAS0(kiTM2TeXCommandInputSyntaxMode,			previousModeWithoutModifiers,	previousModifier);
CAS0(kiTM2TeXGroupOpenSyntaxMode,				previousModeWithoutModifiers,	previousModifier);
CAS0(kiTM2TeXGroupCloseSyntaxMode,				previousModeWithoutModifiers,	previousModifier);
CAS0(kiTM2TeXParenOpenSyntaxMode,				previousModeWithoutModifiers,	previousModifier);
CAS0(kiTM2TeXParenCloseSyntaxMode,				previousModeWithoutModifiers,	previousModifier);
CAS0(kiTM2TeXBracketOpenSyntaxMode,				previousModeWithoutModifiers,	previousModifier);
CAS0(kiTM2TeXBracketCloseSyntaxMode,			previousModeWithoutModifiers,	previousModifier);
CAS0(kiTM2TeXCommentStartSyntaxMode,			previousModeWithoutModifiers,	previousModifier);
CAS0(kiTM2TeXCommentContinueSyntaxMode,			previousModeWithoutModifiers,	previousModifier);
CAS0(kiTM2TeXMarkSyntaxMode,					previousModeWithoutModifiers,	previousModifier);
CAS0(kiTM2TeXMarkContinueSyntaxMode,			previousModeWithoutModifiers,	previousModifier);
CAS0(kiTM2TeXMathSwitchSyntaxMode,				previousModeWithoutModifiers,	previousModifier);
CAS0(kiTM2TeXMathSwithContinueSyntaxMode,		previousModeWithoutModifiers,	previousModifier);
CAS0(kiTM2TeXMathInlineBeginSyntaxMode,			previousModeWithoutModifiers,	previousModifier);
CAS0(kiTM2TeXMathInlineEndSyntaxMode,			previousModeWithoutModifiers,	previousModifier);
CAS0(kiTM2TeXMathDisplayBeginSyntaxMode,		previousModeWithoutModifiers,	previousModifier);
CAS0(kiTM2TeXMathDisplayEndSyntaxMode,			previousModeWithoutModifiers,	previousModifier);
CAS0(kiTM2TeXSubStartSyntaxMode,				previousModeWithoutModifiers,	previousModifier);
CAS0(kiTM2TeXSubShortSyntaxMode,				previousModeWithoutModifiers,	previousModifier);
CAS0(kiTM2TeXSubscriptSyntaxMode,				previousModeWithoutModifiers,	previousModifier);
CAS0(kiTM2TeXSuperStartSyntaxMode,				previousModeWithoutModifiers,	previousModifier);
CAS0(kiTM2TeXSuperContinueSyntaxMode,			previousModeWithoutModifiers,	previousModifier);
CAS0(kiTM2TeXSuperShortSyntaxMode,				previousModeWithoutModifiers,	previousModifier);
CAS0(kiTM2TeXSuperscriptSyntaxMode,				previousModeWithoutModifiers,	previousModifier);
CAS0(kiTM2TeXCellSeparatorSyntaxMode,			previousModeWithoutModifiers,	previousModifier);
CAS0(kiTM2TeXAccentSyntaxMode,					previousModeWithoutModifiers,	previousModifier);
CAS1(kiTM2TeXUnknownSyntaxMode,					previousModeWithoutModifiers,	previousModifier);
CAS1(kiTM2TeXErrorSyntaxMode,					previousModeWithoutModifiers,	previousModifier);
#endif
#undef CAS0
#pragma mark -
#define CAS0(OLDMODE,NEWMODE)\
case OLDMODE: newMode = NEWMODE; break
#undef CAS1
#define CAS1(OLDMODE,NEWMODE,NEWMODIFIER,STATUS)\
case OLDMODE: newMode = NEWMODE; newModifier = NEWMODIFIER;	status = STATUS; break

	NSCharacterSet * set = [NSCharacterSet TeXLetterCharacterSet];
    if([set characterIsMember:theChar])
    {
		newMode = kiTM2TeXRegularSyntaxMode;
        switch(previousModeWithoutModifiers)
        {
//CAS0(kiTM2TeXWhitePrefixSyntaxMode,				kiTM2TeXRegularSyntaxMode);
CAS1(kiTM2TeXRegularSyntaxMode,					previousModeWithoutModifiers,		previousModifier,	kiTM2TeXNoErrorSyntaxStatus);
CAS1(kiTM2TeXCommandStartSyntaxMode,			kiTM2TeXCommandContinueSyntaxMode,	newModifier|kiTM2TeXCommandSyntaxMask&~kiTM2TeXSimpleGroupSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
//CAS0(kiTM2TeXCommandEscapedCharacterSyntaxMode,kiTM2TeXRegularSyntaxMode);
CAS1(kiTM2TeXCommandContinueSyntaxMode,			previousModeWithoutModifiers,	newModifier | kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CAS0(kiTM2TeXCommandInputSyntaxMode,			previousModeWithoutModifiers);
CAS1(kiTM2TeXGroupOpenSyntaxMode,				kiTM2TeXRegularSyntaxMode,	newModifier | kiTM2TeXSimpleGroupSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
//CAS0(kiTM2TeXGroupCloseSyntaxMode,				kiTM2TeXRegularSyntaxMode);
//CAS0(kiTM2TeXParenOpenSyntaxMode,				kiTM2TeXRegularSyntaxMode);
//CAS0(kiTM2TeXParenCloseSyntaxMode,				kiTM2TeXRegularSyntaxMode);
//CAS0(kiTM2TeXBracketOpenSyntaxMode,				kiTM2TeXRegularSyntaxMode);
//CAS0(kiTM2TeXBracketCloseSyntaxMode,			kiTM2TeXRegularSyntaxMode);
CAS0(kiTM2TeXCommentStartSyntaxMode,			kiTM2TeXCommentContinueSyntaxMode);
CAS0(kiTM2TeXCommentContinueSyntaxMode,			previousModeWithoutModifiers);
CAS0(kiTM2TeXMarkSyntaxMode,					kiTM2TeXMarkContinueSyntaxMode);
CAS0(kiTM2TeXMarkContinueSyntaxMode,			previousModeWithoutModifiers);
//CAS0(kiTM2TeXMathSwitchSyntaxMode,				kiTM2TeXRegularSyntaxMode);
//CAS0(kiTM2TeXMathSwithContinueSyntaxMode,		kiTM2TeXRegularSyntaxMode);
//CAS0(kiTM2TeXMathInlineBeginSyntaxMode,			kiTM2TeXRegularSyntaxMode);
//CAS0(kiTM2TeXMathInlineEndSyntaxMode,			kiTM2TeXRegularSyntaxMode);
//CAS0(kiTM2TeXMathDisplayBeginSyntaxMode,		kiTM2TeXRegularSyntaxMode);
//CAS0(kiTM2TeXMathDisplayEndSyntaxMode,			kiTM2TeXRegularSyntaxMode);
CAS0(kiTM2TeXSubStartSyntaxMode,				kiTM2TeXSubShortSyntaxMode);
//CAS0(kiTM2TeXSubShortSyntaxMode,				kiTM2TeXRegularSyntaxMode);
//CAS0(kiTM2TeXSubscriptSyntaxMode,				kiTM2TeXRegularSyntaxMode);
CAS0(kiTM2TeXSuperStartSyntaxMode,				kiTM2TeXSuperShortSyntaxMode);
CAS0(kiTM2TeXSuperContinueSyntaxMode,			kiTM2TeXSuperShortSyntaxMode);
//CAS0(kiTM2TeXSuperShortSyntaxMode,				kiTM2TeXRegularSyntaxMode);
//CAS0(kiTM2TeXSuperscriptSyntaxMode,				kiTM2TeXRegularSyntaxMode);
//CAS0(kiTM2TeXCellSeparatorSyntaxMode,			kiTM2TeXRegularSyntaxMode);
//CAS0(kiTM2TeXAccentSyntaxMode,					kiTM2TeXRegularSyntaxMode);
CAS1(kiTM2TeXUnknownSyntaxMode,					previousModeWithoutModifiers,				previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CAS1(kiTM2TeXErrorSyntaxMode,					previousModeWithoutModifiers,				previousModifier, kiTM2TeXWaitingSyntaxStatus);
        }
		modeString = [_iTM2TeXModeForModeArray objectAtIndex:newMode];
		if([_AS character:theChar isMemberOfCoveredCharacterSetForMode:modeString])
		{
			* newModeRef = newMode | previousError | newModifier;
			return kiTM2TeXNoErrorSyntaxStatus;
		}
//iTM2_LOG(@"AN ERROR OCCURRED");
		* newModeRef = newMode | kiTM2TeXErrorFontSyntaxMask | previousError;
		return kiTM2TeXNoErrorSyntaxStatus;
    }

	switch(theChar)
	{
#pragma mark =-=-=-=-=- " "
		case ' ':
			newMode = kiTM2TeXRegularSyntaxMode;
			switch(previousModeWithoutModifiers)
			{
CAS0(kiTM2TeXWhitePrefixSyntaxMode,				previousModeWithoutModifiers);
CAS0(kiTM2TeXRegularSyntaxMode,					previousModeWithoutModifiers);
CAS1(kiTM2TeXCommandStartSyntaxMode,			kiTM2TeXCommandEscapedCharacterSyntaxMode,	newModifier|kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
//CAS0(kiTM2TeXCommandEscapedCharacterSyntaxMode,	kiTM2TeXRegularSyntaxMode);
//CAS0(kiTM2TeXCommandContinueSyntaxMode,			kiTM2TeXRegularSyntaxMode);
//CAS0(kiTM2TeXCommandInputSyntaxMode,			kiTM2TeXRegularSyntaxMode);
//CAS0(kiTM2TeXGroupOpenSyntaxMode,				kiTM2TeXRegularSyntaxMode);
//CAS0(kiTM2TeXGroupCloseSyntaxMode,				kiTM2TeXRegularSyntaxMode);
//CAS0(kiTM2TeXParenOpenSyntaxMode,				kiTM2TeXRegularSyntaxMode);
//CAS0(kiTM2TeXParenCloseSyntaxMode,				kiTM2TeXRegularSyntaxMode);
//CAS0(kiTM2TeXBracketOpenSyntaxMode,				kiTM2TeXRegularSyntaxMode);
//CAS0(kiTM2TeXBracketCloseSyntaxMode,			kiTM2TeXRegularSyntaxMode);
CAS0(kiTM2TeXCommentStartSyntaxMode,			kiTM2TeXCommentContinueSyntaxMode);
CAS0(kiTM2TeXCommentContinueSyntaxMode,			previousModeWithoutModifiers);
CAS0(kiTM2TeXMarkSyntaxMode,					kiTM2TeXMarkContinueSyntaxMode);
CAS0(kiTM2TeXMarkContinueSyntaxMode,			previousModeWithoutModifiers);
//CAS0(kiTM2TeXMathSwitchSyntaxMode,				kiTM2TeXRegularSyntaxMode);
//CAS0(kiTM2TeXMathSwithContinueSyntaxMode,		kiTM2TeXRegularSyntaxMode);
//CAS0(kiTM2TeXMathInlineBeginSyntaxMode,			kiTM2TeXRegularSyntaxMode);
//CAS0(kiTM2TeXMathInlineEndSyntaxMode,			kiTM2TeXRegularSyntaxMode);
//CAS0(kiTM2TeXMathDisplayBeginSyntaxMode,		kiTM2TeXRegularSyntaxMode);
//CAS0(kiTM2TeXMathDisplayEndSyntaxMode,			kiTM2TeXRegularSyntaxMode);
//CAS0(kiTM2TeXSubStartSyntaxMode,				kiTM2TeXRegularSyntaxMode);
//CAS0(kiTM2TeXSubShortSyntaxMode,				kiTM2TeXRegularSyntaxMode);
//CAS0(kiTM2TeXSubscriptSyntaxMode,				kiTM2TeXRegularSyntaxMode);
//CAS0(kiTM2TeXSuperStartSyntaxMode,				kiTM2TeXRegularSyntaxMode);
//CAS0(kiTM2TeXSuperContinueSyntaxMode,			kiTM2TeXRegularSyntaxMode);
//CAS0(kiTM2TeXSuperShortSyntaxMode,				kiTM2TeXRegularSyntaxMode);
//CAS0(kiTM2TeXSuperscriptSyntaxMode,				kiTM2TeXRegularSyntaxMode);
//CAS0(kiTM2TeXCellSeparatorSyntaxMode,			kiTM2TeXRegularSyntaxMode);
//CAS0(kiTM2TeXAccentSyntaxMode,					kiTM2TeXRegularSyntaxMode);
CAS1(kiTM2TeXUnknownSyntaxMode,					previousModeWithoutModifiers,				previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CAS1(kiTM2TeXErrorSyntaxMode,					previousModeWithoutModifiers,				previousModifier, kiTM2TeXWaitingSyntaxStatus);
			}
			* newModeRef = newMode | previousError | newModifier;
			return kiTM2TeXNoErrorSyntaxStatus;

#pragma mark =-=-=-=-=- "\\"
		case '\\':
			newMode = kiTM2TeXCommandStartSyntaxMode;
			newModifier |= kiTM2TeXCommandSyntaxMask;
			newModifier &=~kiTM2TeXSimpleGroupSyntaxMask;
			status = kiTM2TeXWaitingSyntaxStatus;
			switch(previousModeWithoutModifiers)
			{
//CAS0(kiTM2TeXWhitePrefixSyntaxMode,				kiTM2TeXCommandStartSyntaxMode);
//CAS0(kiTM2TeXRegularSyntaxMode,					kiTM2TeXCommandStartSyntaxMode);
CAS1(kiTM2TeXCommandStartSyntaxMode,			kiTM2TeXCommandEscapedCharacterSyntaxMode,	newModifier|kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
//CAS0(kiTM2TeXCommandEscapedCharacterSyntaxMode,	kiTM2TeXCommandStartSyntaxMode);
//CAS0(kiTM2TeXCommandContinueSyntaxMode,			kiTM2TeXCommandStartSyntaxMode);
//CAS0(kiTM2TeXCommandInputSyntaxMode,			kiTM2TeXCommandStartSyntaxMode);
//CAS0(kiTM2TeXGroupOpenSyntaxMode,				kiTM2TeXCommandStartSyntaxMode);
//CAS0(kiTM2TeXGroupCloseSyntaxMode,				kiTM2TeXCommandStartSyntaxMode);
//CAS0(kiTM2TeXParenOpenSyntaxMode,				kiTM2TeXCommandStartSyntaxMode);
//CAS0(kiTM2TeXParenCloseSyntaxMode,				kiTM2TeXCommandStartSyntaxMode);
//CAS0(kiTM2TeXBracketOpenSyntaxMode,				kiTM2TeXCommandStartSyntaxMode);
//CAS0(kiTM2TeXBracketCloseSyntaxMode,			kiTM2TeXCommandStartSyntaxMode);
CAS0(kiTM2TeXCommentStartSyntaxMode,			kiTM2TeXCommentContinueSyntaxMode);
CAS0(kiTM2TeXCommentContinueSyntaxMode,			previousModeWithoutModifiers);
CAS0(kiTM2TeXMarkSyntaxMode,					kiTM2TeXMarkContinueSyntaxMode);
CAS0(kiTM2TeXMarkContinueSyntaxMode,			previousModeWithoutModifiers);
//CAS0(kiTM2TeXMathSwitchSyntaxMode,				kiTM2TeXCommandStartSyntaxMode);
//CAS0(kiTM2TeXMathSwithContinueSyntaxMode,		kiTM2TeXCommandStartSyntaxMode);
//CAS0(kiTM2TeXMathInlineBeginSyntaxMode,			kiTM2TeXCommandStartSyntaxMode);
//CAS0(kiTM2TeXMathInlineEndSyntaxMode,			kiTM2TeXCommandStartSyntaxMode);
//CAS0(kiTM2TeXMathDisplayBeginSyntaxMode,		kiTM2TeXCommandStartSyntaxMode);
//CAS0(kiTM2TeXMathDisplayEndSyntaxMode,			kiTM2TeXCommandStartSyntaxMode);
//CAS0(kiTM2TeXSubStartSyntaxMode,				kiTM2TeXCommandStartSyntaxMode);
//CAS0(kiTM2TeXSubShortSyntaxMode,				kiTM2TeXCommandStartSyntaxMode);
//CAS0(kiTM2TeXSubscriptSyntaxMode,				kiTM2TeXCommandStartSyntaxMode);
//CAS0(kiTM2TeXSuperStartSyntaxMode,				kiTM2TeXCommandStartSyntaxMode);
//CAS0(kiTM2TeXSuperContinueSyntaxMode,			kiTM2TeXCommandStartSyntaxMode);
//CAS0(kiTM2TeXSuperShortSyntaxMode,				kiTM2TeXCommandStartSyntaxMode);
//CAS0(kiTM2TeXSuperscriptSyntaxMode,				kiTM2TeXCommandStartSyntaxMode);
//CAS0(kiTM2TeXCellSeparatorSyntaxMode,			kiTM2TeXCommandStartSyntaxMode);
//CAS0(kiTM2TeXAccentSyntaxMode,					kiTM2TeXCommandStartSyntaxMode);
CAS1(kiTM2TeXUnknownSyntaxMode,					previousModeWithoutModifiers,				previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CAS1(kiTM2TeXErrorSyntaxMode,					previousModeWithoutModifiers,				previousModifier, kiTM2TeXWaitingSyntaxStatus);
			 }
			* newModeRef = newMode | previousError | newModifier;
			return status ;

#pragma mark =-=-=-=-=- {}
		case '{':
			newMode = kiTM2TeXGroupOpenSyntaxMode;
			status = kiTM2TeXWaitingSyntaxStatus;
			newModifier &=~kiTM2TeXSimpleGroupSyntaxMask;
			switch(previousModeWithoutModifiers)
			{
//CAS(kiTM2TeXWhitePrefixSyntaxMode,				kiTM2TeXGroupOpenSyntaxMode,			newModifier, kiTM2TeXWaitingSyntaxStatus);
//CAS(kiTM2TeXRegularSyntaxMode,					kiTM2TeXGroupOpenSyntaxMode,			newModifier, kiTM2TeXWaitingSyntaxStatus);
CAS1(kiTM2TeXCommandStartSyntaxMode,			kiTM2TeXCommandEscapedCharacterSyntaxMode,	newModifier|kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
//CAS(kiTM2TeXCommandEscapedCharacterSyntaxMode,	kiTM2TeXGroupOpenSyntaxMode,			previousModifier & kiTM2TeXCommandSyntaxMask, kiTM2TeXWaitingSyntaxStatus);
//CAS(kiTM2TeXCommandContinueSyntaxMode,			kiTM2TeXGroupOpenSyntaxMode,			previousModifier & kiTM2TeXCommandSyntaxMask, kiTM2TeXWaitingSyntaxStatus);
//CAS(kiTM2TeXCommandInputSyntaxMode,			kiTM2TeXGroupOpenSyntaxMode,			newModifier, kiTM2TeXWaitingSyntaxStatus);
//CAS(kiTM2TeXGroupOpenSyntaxMode,				kiTM2TeXGroupOpenSyntaxMode,			newModifier, kiTM2TeXWaitingSyntaxStatus);
//CAS(kiTM2TeXGroupCloseSyntaxMode,				kiTM2TeXGroupOpenSyntaxMode,			newModifier, kiTM2TeXWaitingSyntaxStatus);
//CAS(kiTM2TeXParenOpenSyntaxMode,				kiTM2TeXGroupOpenSyntaxMode,			newModifier, kiTM2TeXWaitingSyntaxStatus);
//CAS(kiTM2TeXParenCloseSyntaxMode,				kiTM2TeXGroupOpenSyntaxMode,			newModifier, kiTM2TeXWaitingSyntaxStatus);
//CAS(kiTM2TeXBracketOpenSyntaxMode,				kiTM2TeXGroupOpenSyntaxMode,			newModifier, kiTM2TeXWaitingSyntaxStatus);
//CAS(kiTM2TeXBracketCloseSyntaxMode,			kiTM2TeXGroupOpenSyntaxMode,			newModifier, kiTM2TeXWaitingSyntaxStatus);
CAS0(kiTM2TeXCommentStartSyntaxMode,			kiTM2TeXCommentContinueSyntaxMode);
CAS0(kiTM2TeXCommentContinueSyntaxMode,			previousModeWithoutModifiers);
CAS0(kiTM2TeXMarkSyntaxMode,					kiTM2TeXMarkContinueSyntaxMode);
CAS0(kiTM2TeXMarkContinueSyntaxMode,			previousModeWithoutModifiers);
//CAS(kiTM2TeXMathSwitchSyntaxMode,				kiTM2TeXGroupOpenSyntaxMode,			newModifier, kiTM2TeXWaitingSyntaxStatus);
//CAS(kiTM2TeXMathSwithContinueSyntaxMode,		kiTM2TeXGroupOpenSyntaxMode,			newModifier, kiTM2TeXWaitingSyntaxStatus);
//CAS(kiTM2TeXMathInlineBeginSyntaxMode,			kiTM2TeXGroupOpenSyntaxMode,			newModifier, kiTM2TeXWaitingSyntaxStatus);
//CAS(kiTM2TeXMathInlineEndSyntaxMode,			kiTM2TeXGroupOpenSyntaxMode,			newModifier, kiTM2TeXWaitingSyntaxStatus);
//CAS(kiTM2TeXMathDisplayBeginSyntaxMode,		kiTM2TeXGroupOpenSyntaxMode,			newModifier, kiTM2TeXWaitingSyntaxStatus);
//CAS(kiTM2TeXMathDisplayEndSyntaxMode,			kiTM2TeXGroupOpenSyntaxMode,			newModifier, kiTM2TeXWaitingSyntaxStatus);
//CAS(kiTM2TeXSubStartSyntaxMode,				kiTM2TeXGroupOpenSyntaxMode,			newModifier, kiTM2TeXWaitingSyntaxStatus);
//CAS(kiTM2TeXSubShortSyntaxMode,				kiTM2TeXGroupOpenSyntaxMode,			newModifier, kiTM2TeXWaitingSyntaxStatus);
//CAS(kiTM2TeXSubscriptSyntaxMode,				kiTM2TeXGroupOpenSyntaxMode,			newModifier, kiTM2TeXWaitingSyntaxStatus);
//CAS(kiTM2TeXSuperStartSyntaxMode,				kiTM2TeXGroupOpenSyntaxMode,			newModifier, kiTM2TeXWaitingSyntaxStatus);
//CAS(kiTM2TeXSuperContinueSyntaxMode,			kiTM2TeXGroupOpenSyntaxMode,			newModifier, kiTM2TeXWaitingSyntaxStatus);
//CAS(kiTM2TeXSuperShortSyntaxMode,				kiTM2TeXGroupOpenSyntaxMode,			newModifier, kiTM2TeXWaitingSyntaxStatus);
//CAS(kiTM2TeXSuperscriptSyntaxMode,				kiTM2TeXGroupOpenSyntaxMode,			newModifier, kiTM2TeXWaitingSyntaxStatus);
//CAS(kiTM2TeXCellSeparatorSyntaxMode,			kiTM2TeXGroupOpenSyntaxMode,			newModifier, kiTM2TeXWaitingSyntaxStatus);
//CAS(kiTM2TeXAccentSyntaxMode,			kiTM2TeXGroupOpenSyntaxMode,			newModifier, kiTM2TeXWaitingSyntaxStatus);
CAS1(kiTM2TeXUnknownSyntaxMode,					previousModeWithoutModifiers,previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CAS1(kiTM2TeXErrorSyntaxMode,					previousModeWithoutModifiers,previousModifier, kiTM2TeXWaitingSyntaxStatus);
			}
			* newModeRef = newMode | previousError | newModifier;
			return status ;

		case '}':
			newMode = kiTM2TeXGroupCloseSyntaxMode;
			newModifier &=~kiTM2TeXSimpleGroupSyntaxMask;
			switch(previousModeWithoutModifiers)
			{
//CAS(kiTM2TeXWhitePrefixSyntaxMode,				kiTM2TeXGroupCloseSyntaxMode);
//CAS(kiTM2TeXRegularSyntaxMode,					kiTM2TeXGroupCloseSyntaxMode);
CAS1(kiTM2TeXCommandStartSyntaxMode,			kiTM2TeXCommandEscapedCharacterSyntaxMode,	newModifier|kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
//CAS(kiTM2TeXCommandEscapedCharacterSyntaxMode,	kiTM2TeXGroupCloseSyntaxMode);
//CAS(kiTM2TeXCommandContinueSyntaxMode,			kiTM2TeXGroupCloseSyntaxMode);
//CAS(kiTM2TeXCommandInputSyntaxMode,			kiTM2TeXGroupCloseSyntaxMode);
//CAS(kiTM2TeXGroupOpenSyntaxMode,				kiTM2TeXGroupCloseSyntaxMode);
//CAS(kiTM2TeXGroupCloseSyntaxMode,				kiTM2TeXGroupCloseSyntaxMode);
//CAS(kiTM2TeXParenOpenSyntaxMode,				kiTM2TeXGroupCloseSyntaxMode);
//CAS(kiTM2TeXParenCloseSyntaxMode,				kiTM2TeXGroupCloseSyntaxMode);
//CAS(kiTM2TeXBracketOpenSyntaxMode,				kiTM2TeXGroupCloseSyntaxMode);
//CAS(kiTM2TeXBracketCloseSyntaxMode,			kiTM2TeXGroupCloseSyntaxMode);
CAS0(kiTM2TeXCommentStartSyntaxMode,			kiTM2TeXCommentContinueSyntaxMode);
CAS0(kiTM2TeXCommentContinueSyntaxMode,			previousModeWithoutModifiers);
CAS0(kiTM2TeXMarkSyntaxMode,					kiTM2TeXMarkContinueSyntaxMode);
CAS0(kiTM2TeXMarkContinueSyntaxMode,			previousModeWithoutModifiers);
//CAS(kiTM2TeXMathSwitchSyntaxMode,				kiTM2TeXGroupCloseSyntaxMode);
//CAS(kiTM2TeXMathSwithContinueSyntaxMode,		kiTM2TeXGroupCloseSyntaxMode);
//CAS(kiTM2TeXMathInlineBeginSyntaxMode,			kiTM2TeXGroupCloseSyntaxMode);
//CAS(kiTM2TeXMathInlineEndSyntaxMode,			kiTM2TeXGroupCloseSyntaxMode);
//CAS(kiTM2TeXMathDisplayBeginSyntaxMode,		kiTM2TeXGroupCloseSyntaxMode);
//CAS(kiTM2TeXMathDisplayEndSyntaxMode,			kiTM2TeXGroupCloseSyntaxMode);
//CAS(kiTM2TeXSubStartSyntaxMode,				kiTM2TeXGroupCloseSyntaxMode);
//CAS(kiTM2TeXSubShortSyntaxMode,				kiTM2TeXGroupCloseSyntaxMode);
//CAS(kiTM2TeXSubscriptSyntaxMode,				kiTM2TeXGroupCloseSyntaxMode);
CAS0(kiTM2TeXSuperStartSyntaxMode,				kiTM2TeXErrorSyntaxMode);
//CAS(kiTM2TeXSuperContinueSyntaxMode,			kiTM2TeXGroupCloseSyntaxMode);
//CAS(kiTM2TeXSuperShortSyntaxMode,				kiTM2TeXGroupCloseSyntaxMode);
//CAS(kiTM2TeXSuperscriptSyntaxMode,				kiTM2TeXGroupCloseSyntaxMode);
//CAS(kiTM2TeXCellSeparatorSyntaxMode,			kiTM2TeXGroupCloseSyntaxMode);
//CAS(kiTM2TeXAccentSyntaxMode,					kiTM2TeXGroupCloseSyntaxMode);
CAS1(kiTM2TeXUnknownSyntaxMode,					previousModeWithoutModifiers,			previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CAS1(kiTM2TeXErrorSyntaxMode,					previousModeWithoutModifiers,			previousModifier, kiTM2TeXWaitingSyntaxStatus);
			}
			* newModeRef = newMode | previousError | newModifier;
			return status ;

#pragma mark =-=-=-=-=- ()
		case '(':
			newMode = kiTM2TeXParenOpenSyntaxMode;
			switch(previousModeWithoutModifiers)
			{
//CAS(kiTM2TeXWhitePrefixSyntaxMode,				kiTM2TeXParenOpenSyntaxMode);
//CAS(kiTM2TeXRegularSyntaxMode,					kiTM2TeXParenOpenSyntaxMode);
CAS1(kiTM2TeXCommandStartSyntaxMode,			kiTM2TeXMathInlineBeginSyntaxMode,		newModifier|kiTM2TeXCommandSyntaxMask, kiTM2TeXWaitingSyntaxStatus);
//CAS(kiTM2TeXCommandEscapedCharacterSyntaxMode,	kiTM2TeXParenOpenSyntaxMode);
//CAS(kiTM2TeXCommandContinueSyntaxMode,			kiTM2TeXParenOpenSyntaxMode);
//CAS(kiTM2TeXCommandInputSyntaxMode,			kiTM2TeXParenOpenSyntaxMode);
//CAS(kiTM2TeXGroupOpenSyntaxMode,				kiTM2TeXParenOpenSyntaxMode);
//CAS(kiTM2TeXGroupCloseSyntaxMode,				kiTM2TeXParenOpenSyntaxMode);
//CAS(kiTM2TeXParenOpenSyntaxMode,				kiTM2TeXParenOpenSyntaxMode);
//CAS(kiTM2TeXParenCloseSyntaxMode,				kiTM2TeXParenOpenSyntaxMode);
//CAS(kiTM2TeXBracketOpenSyntaxMode,				kiTM2TeXParenOpenSyntaxMode);
//CAS(kiTM2TeXBracketCloseSyntaxMode,			kiTM2TeXParenOpenSyntaxMode);
CAS0(kiTM2TeXCommentStartSyntaxMode,			kiTM2TeXCommentContinueSyntaxMode);
CAS0(kiTM2TeXCommentContinueSyntaxMode,			previousModeWithoutModifiers);
CAS0(kiTM2TeXMarkSyntaxMode,					kiTM2TeXMarkContinueSyntaxMode);
CAS0(kiTM2TeXMarkContinueSyntaxMode,			previousModeWithoutModifiers);
//CAS(kiTM2TeXMathSwitchSyntaxMode,				kiTM2TeXParenOpenSyntaxMode);
//CAS(kiTM2TeXMathSwithContinueSyntaxMode,		kiTM2TeXParenOpenSyntaxMode);
//CAS(kiTM2TeXMathInlineBeginSyntaxMode,			kiTM2TeXParenOpenSyntaxMode);
//CAS(kiTM2TeXMathInlineEndSyntaxMode,			kiTM2TeXParenOpenSyntaxMode);
//CAS(kiTM2TeXMathDisplayBeginSyntaxMode,		kiTM2TeXParenOpenSyntaxMode);
//CAS(kiTM2TeXMathDisplayEndSyntaxMode,			kiTM2TeXParenOpenSyntaxMode);
CAS0(kiTM2TeXSubStartSyntaxMode,				kiTM2TeXSubShortSyntaxMode);
//CAS(kiTM2TeXSubShortSyntaxMode,				kiTM2TeXParenOpenSyntaxMode);
//CAS(kiTM2TeXSubscriptSyntaxMode,				kiTM2TeXParenOpenSyntaxMode);
CAS0(kiTM2TeXSuperStartSyntaxMode,				kiTM2TeXSuperShortSyntaxMode);
//CAS(kiTM2TeXSuperContinueSyntaxMode,			kiTM2TeXParenOpenSyntaxMode);
//CAS(kiTM2TeXSuperShortSyntaxMode,				kiTM2TeXParenOpenSyntaxMode);
//CAS(kiTM2TeXSuperscriptSyntaxMode,				kiTM2TeXParenOpenSyntaxMode);
//CAS(kiTM2TeXCellSeparatorSyntaxMode,			kiTM2TeXParenOpenSyntaxMode);
//CAS(kiTM2TeXAccentSyntaxMode,					kiTM2TeXParenOpenSyntaxMode);
CAS1(kiTM2TeXUnknownSyntaxMode,					previousModeWithoutModifiers,			previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CAS1(kiTM2TeXErrorSyntaxMode,					previousModeWithoutModifiers,			previousModifier, kiTM2TeXWaitingSyntaxStatus);
			}
			* newModeRef = newMode | previousError | newModifier;
			return status ;

		case ')':
			newMode = kiTM2TeXParenCloseSyntaxMode;
			switch(previousModeWithoutModifiers)
			{
//CAS0(kiTM2TeXWhitePrefixSyntaxMode,				kiTM2TeXParenCloseSyntaxMode);
//CAS0(kiTM2TeXRegularSyntaxMode,					kiTM2TeXParenCloseSyntaxMode);
CAS1(kiTM2TeXCommandStartSyntaxMode,			kiTM2TeXMathInlineEndSyntaxMode,			newModifier|kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
//CAS0(kiTM2TeXCommandEscapedCharacterSyntaxMode,	kiTM2TeXParenCloseSyntaxMode);
//CAS0(kiTM2TeXCommandContinueSyntaxMode,			kiTM2TeXParenCloseSyntaxMode);
CAS0(kiTM2TeXCommandInputSyntaxMode,			kiTM2TeXErrorSyntaxMode);
//CAS0(kiTM2TeXGroupOpenSyntaxMode,				kiTM2TeXParenCloseSyntaxMode);
//CAS0(kiTM2TeXGroupCloseSyntaxMode,				kiTM2TeXParenCloseSyntaxMode);
//CAS0(kiTM2TeXParenOpenSyntaxMode,				kiTM2TeXParenCloseSyntaxMode);
//CAS0(kiTM2TeXParenCloseSyntaxMode,				kiTM2TeXParenCloseSyntaxMode);
//CAS0(kiTM2TeXBracketOpenSyntaxMode,				kiTM2TeXParenCloseSyntaxMode);
//CAS0(kiTM2TeXBracketCloseSyntaxMode,			kiTM2TeXParenCloseSyntaxMode);
CAS0(kiTM2TeXCommentStartSyntaxMode,			kiTM2TeXCommentContinueSyntaxMode);
CAS0(kiTM2TeXCommentContinueSyntaxMode,			previousModeWithoutModifiers);
CAS0(kiTM2TeXMarkSyntaxMode,					kiTM2TeXMarkContinueSyntaxMode);
CAS0(kiTM2TeXMarkContinueSyntaxMode,			previousModeWithoutModifiers);
//CAS0(kiTM2TeXMathSwitchSyntaxMode,				kiTM2TeXParenCloseSyntaxMode);
//CAS0(kiTM2TeXMathSwithContinueSyntaxMode,		kiTM2TeXParenCloseSyntaxMode);
//CAS0(kiTM2TeXMathInlineBeginSyntaxMode,			kiTM2TeXParenCloseSyntaxMode);
//CAS0(kiTM2TeXMathInlineEndSyntaxMode,			kiTM2TeXParenCloseSyntaxMode);
//CAS0(kiTM2TeXMathDisplayBeginSyntaxMode,		kiTM2TeXParenCloseSyntaxMode);
//CAS0(kiTM2TeXMathDisplayEndSyntaxMode,			kiTM2TeXParenCloseSyntaxMode);
CAS0(kiTM2TeXSubStartSyntaxMode,				kiTM2TeXSubShortSyntaxMode);
//CAS0(kiTM2TeXSubShortSyntaxMode,				kiTM2TeXParenCloseSyntaxMode);
//CAS0(kiTM2TeXSubscriptSyntaxMode,				kiTM2TeXParenCloseSyntaxMode);
CAS0(kiTM2TeXSuperStartSyntaxMode,				kiTM2TeXSuperShortSyntaxMode);
CAS0(kiTM2TeXSuperContinueSyntaxMode,			kiTM2TeXSuperShortSyntaxMode);
//CAS0(kiTM2TeXSuperShortSyntaxMode,				kiTM2TeXParenCloseSyntaxMode);
//CAS0(kiTM2TeXSuperscriptSyntaxMode,				kiTM2TeXParenCloseSyntaxMode);
//CAS0(kiTM2TeXCellSeparatorSyntaxMode,			kiTM2TeXParenCloseSyntaxMode);
//CAS0(kiTM2TeXAccentSyntaxMode,				kiTM2TeXParenCloseSyntaxMode);
CAS1(kiTM2TeXUnknownSyntaxMode,					previousModeWithoutModifiers,			previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CAS1(kiTM2TeXErrorSyntaxMode,					previousModeWithoutModifiers,			previousModifier, kiTM2TeXWaitingSyntaxStatus);
			}
			* newModeRef = newMode | previousError | newModifier;
			return status ;
#pragma mark =-=-=-=-=- []
		case '[':
			newMode = kiTM2TeXBracketOpenSyntaxMode;
			switch(previousModeWithoutModifiers)
			{
//CAS(kiTM2TeXWhitePrefixSyntaxMode,				kiTM2TeXBracketOpenSyntaxMode);
//CAS(kiTM2TeXRegularSyntaxMode,					kiTM2TeXBracketOpenSyntaxMode);
CAS1(kiTM2TeXCommandStartSyntaxMode,			kiTM2TeXMathDisplayBeginSyntaxMode,		newModifier|kiTM2TeXCommandSyntaxMask, kiTM2TeXWaitingSyntaxStatus);
//CAS(kiTM2TeXCommandEscapedCharacterSyntaxMode,	kiTM2TeXBracketOpenSyntaxMode);
//CAS(kiTM2TeXCommandContinueSyntaxMode,			kiTM2TeXBracketOpenSyntaxMode);
//CAS0(kiTM2TeXCommandInputSyntaxMode,			kiTM2TeXBracketOpenSyntaxMode);
//CAS(kiTM2TeXGroupOpenSyntaxMode,				kiTM2TeXBracketOpenSyntaxMode);
//CAS(kiTM2TeXGroupCloseSyntaxMode,				kiTM2TeXBracketOpenSyntaxMode);
//CAS(kiTM2TeXParenOpenSyntaxMode,				kiTM2TeXBracketOpenSyntaxMode);
//CAS(kiTM2TeXParenCloseSyntaxMode,				kiTM2TeXBracketOpenSyntaxMode);
//CAS(kiTM2TeXBracketOpenSyntaxMode,				kiTM2TeXBracketOpenSyntaxMode);
//CAS(kiTM2TeXBracketCloseSyntaxMode,			kiTM2TeXBracketOpenSyntaxMode);
CAS0(kiTM2TeXCommentStartSyntaxMode,			kiTM2TeXCommentContinueSyntaxMode);
CAS0(kiTM2TeXCommentContinueSyntaxMode,			previousModeWithoutModifiers);
CAS0(kiTM2TeXMarkSyntaxMode,					kiTM2TeXMarkContinueSyntaxMode);
CAS0(kiTM2TeXMarkContinueSyntaxMode,			previousModeWithoutModifiers);
//CAS(kiTM2TeXMathSwitchSyntaxMode,				kiTM2TeXBracketOpenSyntaxMode);
//CAS(kiTM2TeXMathSwithContinueSyntaxMode,		kiTM2TeXBracketOpenSyntaxMode);
//CAS(kiTM2TeXMathInlineBeginSyntaxMode,			kiTM2TeXBracketOpenSyntaxMode);
//CAS(kiTM2TeXMathInlineEndSyntaxMode,			kiTM2TeXBracketOpenSyntaxMode);
//CAS(kiTM2TeXMathDisplayBeginSyntaxMode,		kiTM2TeXBracketOpenSyntaxMode);
//CAS(kiTM2TeXMathDisplayEndSyntaxMode,			kiTM2TeXBracketOpenSyntaxMode);
CAS0(kiTM2TeXSubStartSyntaxMode,				kiTM2TeXSubShortSyntaxMode);
//CAS(kiTM2TeXSubShortSyntaxMode,				kiTM2TeXBracketOpenSyntaxMode);
//CAS(kiTM2TeXSubscriptSyntaxMode,				kiTM2TeXBracketOpenSyntaxMode);
CAS0(kiTM2TeXSuperStartSyntaxMode,				kiTM2TeXSuperShortSyntaxMode);
CAS0(kiTM2TeXSuperContinueSyntaxMode,			kiTM2TeXSuperShortSyntaxMode);
//CAS(kiTM2TeXSuperShortSyntaxMode,				kiTM2TeXBracketOpenSyntaxMode);
//CAS(kiTM2TeXSuperscriptSyntaxMode,				kiTM2TeXBracketOpenSyntaxMode);
//CAS(kiTM2TeXCellSeparatorSyntaxMode,			kiTM2TeXBracketOpenSyntaxMode);
//CAS(kiTM2TeXAccentSyntaxMode,					kiTM2TeXBracketOpenSyntaxMode);
CAS1(kiTM2TeXUnknownSyntaxMode,					previousModeWithoutModifiers,			previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CAS1(kiTM2TeXErrorSyntaxMode,					previousModeWithoutModifiers,			previousModifier, kiTM2TeXWaitingSyntaxStatus);
			}
			* newModeRef = newMode | previousError | newModifier;
			return status ;

		case ']':
			newMode = kiTM2TeXBracketCloseSyntaxMode;
			switch(previousModeWithoutModifiers)
			{
//CAS(kiTM2TeXWhitePrefixSyntaxMode,				kiTM2TeXBracketCloseSyntaxMode);
//CAS(kiTM2TeXRegularSyntaxMode,					kiTM2TeXBracketCloseSyntaxMode);
CAS1(kiTM2TeXCommandStartSyntaxMode,			kiTM2TeXMathDisplayEndSyntaxMode,		newModifier|kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
//CAS(kiTM2TeXCommandEscapedCharacterSyntaxMode,	kiTM2TeXBracketCloseSyntaxMode);
//CAS(kiTM2TeXCommandContinueSyntaxMode,			kiTM2TeXBracketCloseSyntaxMode);
CAS0(kiTM2TeXCommandInputSyntaxMode,			kiTM2TeXErrorSyntaxMode);
//CAS(kiTM2TeXGroupOpenSyntaxMode,				kiTM2TeXBracketCloseSyntaxMode);
//CAS(kiTM2TeXGroupCloseSyntaxMode,				kiTM2TeXBracketCloseSyntaxMode);
//CAS(kiTM2TeXParenOpenSyntaxMode,				kiTM2TeXBracketCloseSyntaxMode);
//CAS(kiTM2TeXParenCloseSyntaxMode,				kiTM2TeXBracketCloseSyntaxMode);
//CAS(kiTM2TeXBracketOpenSyntaxMode,				kiTM2TeXBracketCloseSyntaxMode);
//CAS(kiTM2TeXBracketCloseSyntaxMode,			kiTM2TeXBracketCloseSyntaxMode);
CAS0(kiTM2TeXCommentStartSyntaxMode,			kiTM2TeXCommentContinueSyntaxMode);
CAS0(kiTM2TeXCommentContinueSyntaxMode,			previousModeWithoutModifiers);
CAS0(kiTM2TeXMarkSyntaxMode,					kiTM2TeXMarkContinueSyntaxMode);
CAS0(kiTM2TeXMarkContinueSyntaxMode,			previousModeWithoutModifiers);
//CAS(kiTM2TeXMathSwitchSyntaxMode,				kiTM2TeXBracketCloseSyntaxMode);
//CAS(kiTM2TeXMathSwithContinueSyntaxMode,		kiTM2TeXBracketCloseSyntaxMode);
//CAS(kiTM2TeXMathInlineBeginSyntaxMode,			kiTM2TeXBracketCloseSyntaxMode);
//CAS(kiTM2TeXMathInlineEndSyntaxMode,			kiTM2TeXBracketCloseSyntaxMode);
//CAS(kiTM2TeXMathDisplayBeginSyntaxMode,		kiTM2TeXBracketCloseSyntaxMode);
//CAS(kiTM2TeXMathDisplayEndSyntaxMode,			kiTM2TeXBracketCloseSyntaxMode);
CAS0(kiTM2TeXSubStartSyntaxMode,				kiTM2TeXSubShortSyntaxMode);
//CAS(kiTM2TeXSubShortSyntaxMode,				kiTM2TeXBracketCloseSyntaxMode);
//CAS(kiTM2TeXSubscriptSyntaxMode,				kiTM2TeXBracketCloseSyntaxMode);
CAS0(kiTM2TeXSuperStartSyntaxMode,				kiTM2TeXSuperShortSyntaxMode);
//CAS(kiTM2TeXSuperContinueSyntaxMode,			kiTM2TeXBracketCloseSyntaxMode);
//CAS(kiTM2TeXSuperShortSyntaxMode,				kiTM2TeXBracketCloseSyntaxMode);
//CAS(kiTM2TeXSuperscriptSyntaxMode,				kiTM2TeXBracketCloseSyntaxMode);
//CAS(kiTM2TeXCellSeparatorSyntaxMode,			kiTM2TeXBracketCloseSyntaxMode);
//CAS(kiTM2TeXAccentSyntaxMode,					kiTM2TeXBracketCloseSyntaxMode);
CAS1(kiTM2TeXUnknownSyntaxMode,					previousModeWithoutModifiers,			previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CAS1(kiTM2TeXErrorSyntaxMode,					previousModeWithoutModifiers,			previousModifier, kiTM2TeXWaitingSyntaxStatus);
			}
			* newModeRef = newMode | previousError | newModifier;
			return status ;

#pragma mark =-=-=-=-=- $
		case '$':
			newMode = kiTM2TeXMathSwitchSyntaxMode;
			newModifier &=~kiTM2TeXSimpleGroupSyntaxMask;
			switch(previousModeWithoutModifiers)
			{
//CAS(kiTM2TeXWhitePrefixSyntaxMode,				kiTM2TeXMathSwitchSyntaxMode);
//CAS(kiTM2TeXRegularSyntaxMode,					kiTM2TeXMathSwitchSyntaxMode);
CAS1(kiTM2TeXCommandStartSyntaxMode,			kiTM2TeXCommandEscapedCharacterSyntaxMode,	newModifier|kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
//CAS(kiTM2TeXCommandEscapedCharacterSyntaxMode,	kiTM2TeXMathSwitchSyntaxMode);
//CAS(kiTM2TeXCommandContinueSyntaxMode,			kiTM2TeXMathSwitchSyntaxMode);
CAS0(kiTM2TeXCommandInputSyntaxMode,			kiTM2TeXErrorSyntaxMode);
//CAS(kiTM2TeXGroupOpenSyntaxMode,				kiTM2TeXMathSwitchSyntaxMode);
//CAS(kiTM2TeXGroupCloseSyntaxMode,				kiTM2TeXMathSwitchSyntaxMode);
//CAS(kiTM2TeXParenOpenSyntaxMode,				kiTM2TeXMathSwitchSyntaxMode);
//CAS(kiTM2TeXParenCloseSyntaxMode,				kiTM2TeXMathSwitchSyntaxMode);
//CAS(kiTM2TeXBracketOpenSyntaxMode,				kiTM2TeXMathSwitchSyntaxMode);
//CAS(kiTM2TeXBracketCloseSyntaxMode,			kiTM2TeXMathSwitchSyntaxMode);
CAS0(kiTM2TeXCommentStartSyntaxMode,			kiTM2TeXCommentContinueSyntaxMode);
CAS0(kiTM2TeXCommentContinueSyntaxMode,			previousModeWithoutModifiers);
CAS0(kiTM2TeXMarkSyntaxMode,					kiTM2TeXMarkContinueSyntaxMode);
CAS0(kiTM2TeXMarkContinueSyntaxMode,			previousModeWithoutModifiers);
CAS0(kiTM2TeXMathSwitchSyntaxMode,				kiTM2TeXMathSwithContinueSyntaxMode);
//CAS(kiTM2TeXMathSwithContinueSyntaxMode,		kiTM2TeXMathSwitchSyntaxMode);
//CAS(kiTM2TeXMathInlineBeginSyntaxMode,			kiTM2TeXMathSwitchSyntaxMode);
//CAS(kiTM2TeXMathInlineEndSyntaxMode,			kiTM2TeXMathSwitchSyntaxMode);
//CAS(kiTM2TeXMathDisplayBeginSyntaxMode,		kiTM2TeXMathSwitchSyntaxMode);
//CAS(kiTM2TeXMathDisplayEndSyntaxMode,			kiTM2TeXMathSwitchSyntaxMode);
CAS0(kiTM2TeXSubStartSyntaxMode,				kiTM2TeXErrorSyntaxMode);
//CAS(kiTM2TeXSubShortSyntaxMode,				kiTM2TeXMathSwitchSyntaxMode);
//CAS(kiTM2TeXSubscriptSyntaxMode,				kiTM2TeXMathSwitchSyntaxMode);
CAS0(kiTM2TeXSuperStartSyntaxMode,				kiTM2TeXErrorSyntaxMode);
//CAS(kiTM2TeXSuperContinueSyntaxMode,			kiTM2TeXMathSwitchSyntaxMode);
//CAS(kiTM2TeXSuperShortSyntaxMode,				kiTM2TeXMathSwitchSyntaxMode);
//CAS(kiTM2TeXSuperscriptSyntaxMode,				kiTM2TeXMathSwitchSyntaxMode);
//CAS(kiTM2TeXCellSeparatorSyntaxMode,			kiTM2TeXMathSwitchSyntaxMode);
//CAS(kiTM2TeXAccentSyntaxMode,					kiTM2TeXMathSwitchSyntaxMode);
CAS1(kiTM2TeXUnknownSyntaxMode,					previousModeWithoutModifiers,			previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CAS1(kiTM2TeXErrorSyntaxMode,					previousModeWithoutModifiers,			previousModifier, kiTM2TeXWaitingSyntaxStatus);
			}
			* newModeRef = newMode | previousError | newModifier;
			return status ;

#pragma mark =-=-=-=-=- %
		case '%':
			newMode = kiTM2TeXCommentStartSyntaxMode;
			newModifier &=~kiTM2TeXSimpleGroupSyntaxMask;
			switch(previousModeWithoutModifiers)
			{
//CAS(kiTM2TeXWhitePrefixSyntaxMode,				kiTM2TeXCommentStartSyntaxMode);
//CAS(kiTM2TeXRegularSyntaxMode,					kiTM2TeXCommentStartSyntaxMode);
CAS1(kiTM2TeXCommandStartSyntaxMode,			kiTM2TeXCommandEscapedCharacterSyntaxMode,	newModifier|kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
//CAS(kiTM2TeXCommandEscapedCharacterSyntaxMode,	kiTM2TeXCommentStartSyntaxMode);
//CAS(kiTM2TeXCommandContinueSyntaxMode,			kiTM2TeXCommentStartSyntaxMode);
CAS0(kiTM2TeXCommandInputSyntaxMode,			kiTM2TeXErrorSyntaxMode);
//CAS(kiTM2TeXGroupOpenSyntaxMode,				kiTM2TeXCommentStartSyntaxMode);
//CAS(kiTM2TeXGroupCloseSyntaxMode,				kiTM2TeXCommentStartSyntaxMode);
//CAS(kiTM2TeXParenOpenSyntaxMode,				kiTM2TeXCommentStartSyntaxMode);
//CAS(kiTM2TeXParenCloseSyntaxMode,				kiTM2TeXCommentStartSyntaxMode);
//CAS(kiTM2TeXBracketOpenSyntaxMode,				kiTM2TeXCommentStartSyntaxMode);
//CAS(kiTM2TeXBracketCloseSyntaxMode,			kiTM2TeXCommentStartSyntaxMode);
CAS0(kiTM2TeXCommentStartSyntaxMode,			kiTM2TeXCommentContinueSyntaxMode);
CAS0(kiTM2TeXCommentContinueSyntaxMode,			previousModeWithoutModifiers);
CAS0(kiTM2TeXMarkSyntaxMode,					kiTM2TeXMarkContinueSyntaxMode);
CAS0(kiTM2TeXMarkContinueSyntaxMode,			previousModeWithoutModifiers);
//CAS(kiTM2TeXMathSwitchSyntaxMode,				kiTM2TeXCommentStartSyntaxMode);
//CAS(kiTM2TeXMathSwithContinueSyntaxMode,		kiTM2TeXCommentStartSyntaxMode);
//CAS(kiTM2TeXMathInlineBeginSyntaxMode,			kiTM2TeXCommentStartSyntaxMode);
//CAS(kiTM2TeXMathInlineEndSyntaxMode,			kiTM2TeXCommentStartSyntaxMode);
//CAS(kiTM2TeXMathDisplayBeginSyntaxMode,		kiTM2TeXCommentStartSyntaxMode);
//CAS(kiTM2TeXMathDisplayEndSyntaxMode,			kiTM2TeXCommentStartSyntaxMode);
//CAS(kiTM2TeXSubStartSyntaxMode,				kiTM2TeXCommentStartSyntaxMode);
//CAS(kiTM2TeXSubShortSyntaxMode,				kiTM2TeXCommentStartSyntaxMode);
//CAS(kiTM2TeXSubscriptSyntaxMode,				kiTM2TeXCommentStartSyntaxMode);
//CAS(kiTM2TeXSuperStartSyntaxMode,				kiTM2TeXCommentStartSyntaxMode);
//CAS(kiTM2TeXSuperContinueSyntaxMode,			kiTM2TeXCommentStartSyntaxMode);
//CAS(kiTM2TeXSuperShortSyntaxMode,				kiTM2TeXCommentStartSyntaxMode);
//CAS(kiTM2TeXSuperscriptSyntaxMode,				kiTM2TeXCommentStartSyntaxMode);
//CAS(kiTM2TeXCellSeparatorSyntaxMode,			kiTM2TeXCommentStartSyntaxMode);
//CAS(kiTM2TeXAccentSyntaxMode,					kiTM2TeXCommentStartSyntaxMode);
CAS1(kiTM2TeXUnknownSyntaxMode,					previousModeWithoutModifiers,			previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CAS1(kiTM2TeXErrorSyntaxMode,					previousModeWithoutModifiers,			previousModifier, kiTM2TeXWaitingSyntaxStatus);
			}
			* newModeRef = newMode | previousError | newModifier;
			return status ;
		
#pragma mark =-=-=-=-=- &
		case '&':
			newMode = kiTM2TeXCellSeparatorSyntaxMode;
			newModifier &=~kiTM2TeXSimpleGroupSyntaxMask;
			switch(previousModeWithoutModifiers)
			{
//CAS(kiTM2TeXWhitePrefixSyntaxMode,				kiTM2TeXCellSeparatorSyntaxMode);
//CAS(kiTM2TeXRegularSyntaxMode,					kiTM2TeXCellSeparatorSyntaxMode);
CAS1(kiTM2TeXCommandStartSyntaxMode,			kiTM2TeXCommandEscapedCharacterSyntaxMode,	newModifier|kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
//CAS(kiTM2TeXCommandEscapedCharacterSyntaxMode,	kiTM2TeXCellSeparatorSyntaxMode);
//CAS(kiTM2TeXCommandContinueSyntaxMode,			kiTM2TeXCellSeparatorSyntaxMode);
CAS0(kiTM2TeXCommandInputSyntaxMode,			kiTM2TeXErrorSyntaxMode);
//CAS(kiTM2TeXGroupOpenSyntaxMode,				kiTM2TeXCellSeparatorSyntaxMode);
//CAS(kiTM2TeXGroupCloseSyntaxMode,				kiTM2TeXCellSeparatorSyntaxMode);
//CAS(kiTM2TeXParenOpenSyntaxMode,				kiTM2TeXCellSeparatorSyntaxMode);
//CAS(kiTM2TeXParenCloseSyntaxMode,				kiTM2TeXCellSeparatorSyntaxMode);
//CAS(kiTM2TeXBracketOpenSyntaxMode,				kiTM2TeXCellSeparatorSyntaxMode);
//CAS(kiTM2TeXBracketCloseSyntaxMode,			kiTM2TeXCellSeparatorSyntaxMode);
CAS0(kiTM2TeXCommentStartSyntaxMode,			kiTM2TeXCommentContinueSyntaxMode);
CAS0(kiTM2TeXCommentContinueSyntaxMode,			previousModeWithoutModifiers);
CAS0(kiTM2TeXMarkSyntaxMode,					kiTM2TeXMarkContinueSyntaxMode);
CAS0(kiTM2TeXMarkContinueSyntaxMode,			previousModeWithoutModifiers);
//CAS(kiTM2TeXMathSwitchSyntaxMode,				kiTM2TeXCellSeparatorSyntaxMode,		previousModifier, kiTM2TeXNoErrorSyntaxStatus);
//CAS(kiTM2TeXMathSwithContinueSyntaxMode,		kiTM2TeXCellSeparatorSyntaxMode);
CAS0(kiTM2TeXMathInlineBeginSyntaxMode,			kiTM2TeXErrorSyntaxMode);
//CAS(kiTM2TeXMathInlineEndSyntaxMode,			kiTM2TeXCellSeparatorSyntaxMode);
CAS0(kiTM2TeXMathDisplayBeginSyntaxMode,		kiTM2TeXErrorSyntaxMode);
CAS0(kiTM2TeXMathDisplayEndSyntaxMode,			kiTM2TeXErrorSyntaxMode);
CAS0(kiTM2TeXSubStartSyntaxMode,				kiTM2TeXErrorSyntaxMode);
//CAS(kiTM2TeXSubShortSyntaxMode,				kiTM2TeXCellSeparatorSyntaxMode);
//CAS(kiTM2TeXSubscriptSyntaxMode,				kiTM2TeXCellSeparatorSyntaxMode);
CAS0(kiTM2TeXSuperStartSyntaxMode,				kiTM2TeXErrorSyntaxMode);
//CAS(kiTM2TeXSuperContinueSyntaxMode,			kiTM2TeXCellSeparatorSyntaxMode);
//CAS(kiTM2TeXSuperShortSyntaxMode,				kiTM2TeXCellSeparatorSyntaxMode);
//CAS(kiTM2TeXSuperscriptSyntaxMode,				kiTM2TeXCellSeparatorSyntaxMode);
//CAS(kiTM2TeXCellSeparatorSyntaxMode,			kiTM2TeXCellSeparatorSyntaxMode);
//CAS(kiTM2TeXAccentSyntaxMode,					kiTM2TeXCellSeparatorSyntaxMode);
CAS1(kiTM2TeXUnknownSyntaxMode,					previousModeWithoutModifiers,				previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CAS1(kiTM2TeXErrorSyntaxMode,					previousModeWithoutModifiers,				previousModifier, kiTM2TeXWaitingSyntaxStatus);
			}
			* newModeRef = newMode | previousError | newModifier;
			return status ;
		
#pragma mark =-=-=-=-=- !
		case '!':// only active after thet first '%'
			newMode = kiTM2TeXRegularSyntaxMode;
			switch(previousModeWithoutModifiers)
			{
//CAS(kiTM2TeXWhitePrefixSyntaxMode,				kiTM2TeXRegularSyntaxMode);
//CAS(kiTM2TeXRegularSyntaxMode,					kiTM2TeXRegularSyntaxMode);
CAS1(kiTM2TeXCommandStartSyntaxMode,			kiTM2TeXCommandEscapedCharacterSyntaxMode,	newModifier|kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
//CAS(kiTM2TeXCommandEscapedCharacterSyntaxMode,	kiTM2TeXRegularSyntaxMode);
//CAS(kiTM2TeXCommandContinueSyntaxMode,			kiTM2TeXRegularSyntaxMode);
CAS0(kiTM2TeXCommandInputSyntaxMode,			kiTM2TeXErrorSyntaxMode);
//CAS(kiTM2TeXGroupOpenSyntaxMode,				kiTM2TeXRegularSyntaxMode);
//CAS(kiTM2TeXGroupCloseSyntaxMode,				kiTM2TeXRegularSyntaxMode);
//CAS(kiTM2TeXParenOpenSyntaxMode,				kiTM2TeXRegularSyntaxMode);
//CAS(kiTM2TeXParenCloseSyntaxMode,				kiTM2TeXRegularSyntaxMode);
//CAS(kiTM2TeXBracketOpenSyntaxMode,				kiTM2TeXRegularSyntaxMode);
//CAS(kiTM2TeXBracketCloseSyntaxMode,			kiTM2TeXRegularSyntaxMode);
//CAS(kiTM2TeXCommentStartSyntaxMode,			kiTM2TeXMarkSyntaxMode);
//CAS(kiTM2TeXCommentContinueSyntaxMode,			previousModeWithoutModifiers);
//CAS(kiTM2TeXMarkSyntaxMode,					kiTM2TeXMarkContinueSyntaxMode);
//CAS(kiTM2TeXMarkContinueSyntaxMode,			previousModeWithoutModifiers);
//CAS(kiTM2TeXMathSwitchSyntaxMode,				kiTM2TeXRegularSyntaxMode);
//CAS(kiTM2TeXMathSwithContinueSyntaxMode,		kiTM2TeXRegularSyntaxMode);
//CAS(kiTM2TeXMathInlineBeginSyntaxMode,			kiTM2TeXRegularSyntaxMode);
//CAS(kiTM2TeXMathInlineEndSyntaxMode,			kiTM2TeXRegularSyntaxMode);
//CAS(kiTM2TeXMathDisplayBeginSyntaxMode,		kiTM2TeXRegularSyntaxMode);
//CAS(kiTM2TeXMathDisplayEndSyntaxMode,			kiTM2TeXRegularSyntaxMode);
CAS0(kiTM2TeXSubStartSyntaxMode,				kiTM2TeXSubShortSyntaxMode);
//CAS(kiTM2TeXSubShortSyntaxMode,				kiTM2TeXRegularSyntaxMode);
//CAS(kiTM2TeXSubscriptSyntaxMode,				kiTM2TeXRegularSyntaxMode);
CAS0(kiTM2TeXSuperStartSyntaxMode,				kiTM2TeXSuperShortSyntaxMode);
//CAS(kiTM2TeXSuperContinueSyntaxMode,			kiTM2TeXSuperShortSyntaxMode);
//CAS(kiTM2TeXSuperShortSyntaxMode,				kiTM2TeXRegularSyntaxMode);
//CAS(kiTM2TeXSuperscriptSyntaxMode,				kiTM2TeXRegularSyntaxMode);
//CAS(kiTM2TeXCellSeparatorSyntaxMode,			kiTM2TeXRegularSyntaxMode);
//CAS(kiTM2TeXAccentSyntaxMode,					kiTM2TeXRegularSyntaxMode);
CAS1(kiTM2TeXUnknownSyntaxMode,					previousModeWithoutModifiers,		previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CAS1(kiTM2TeXErrorSyntaxMode,					previousModeWithoutModifiers,		previousModifier, kiTM2TeXWaitingSyntaxStatus);
			}
			* newModeRef = newMode | previousError | newModifier;
			return status ;

#pragma mark =-=-=-=-=- ^
		case '^':
			newMode = kiTM2TeXSuperStartSyntaxMode;
			newModifier &=~kiTM2TeXSimpleGroupSyntaxMask;
			switch(previousModeWithoutModifiers)
			{
//CAS(kiTM2TeXWhitePrefixSyntaxMode,				kiTM2TeXSuperStartSyntaxMode);
//CAS(kiTM2TeXRegularSyntaxMode,					kiTM2TeXSuperStartSyntaxMode);
CAS1(kiTM2TeXCommandStartSyntaxMode,		kiTM2TeXCommandEscapedCharacterSyntaxMode,	newModifier|kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
//CAS(kiTM2TeXCommandEscapedCharacterSyntaxMode,	kiTM2TeXSuperStartSyntaxMode);
//CAS(kiTM2TeXCommandContinueSyntaxMode,			kiTM2TeXSuperStartSyntaxMode);
CAS0(kiTM2TeXCommandInputSyntaxMode,			kiTM2TeXErrorSyntaxMode);
//CAS(kiTM2TeXGroupOpenSyntaxMode,				kiTM2TeXSuperStartSyntaxMode);
//CAS(kiTM2TeXGroupCloseSyntaxMode,				kiTM2TeXSuperStartSyntaxMode);
//CAS(kiTM2TeXParenOpenSyntaxMode,				kiTM2TeXSuperStartSyntaxMode);
//CAS(kiTM2TeXParenCloseSyntaxMode,				kiTM2TeXSuperStartSyntaxMode);
//CAS(kiTM2TeXBracketOpenSyntaxMode,				kiTM2TeXSuperStartSyntaxMode);
//CAS(kiTM2TeXBracketCloseSyntaxMode,			kiTM2TeXSuperStartSyntaxMode);
CAS0(kiTM2TeXCommentStartSyntaxMode,			kiTM2TeXCommentContinueSyntaxMode);
CAS0(kiTM2TeXCommentContinueSyntaxMode,			previousModeWithoutModifiers);
CAS0(kiTM2TeXMarkSyntaxMode,					kiTM2TeXMarkContinueSyntaxMode);
CAS0(kiTM2TeXMarkContinueSyntaxMode,			previousModeWithoutModifiers);
//CAS(kiTM2TeXMathSwitchSyntaxMode,				kiTM2TeXSuperStartSyntaxMode);
//CAS(kiTM2TeXMathSwithContinueSyntaxMode,		kiTM2TeXSuperStartSyntaxMode);
//CAS(kiTM2TeXMathInlineBeginSyntaxMode,			kiTM2TeXSuperStartSyntaxMode);
CAS0(kiTM2TeXMathInlineEndSyntaxMode,			kiTM2TeXErrorSyntaxMode);
//CAS(kiTM2TeXMathDisplayBeginSyntaxMode,		kiTM2TeXSuperStartSyntaxMode);
CAS0(kiTM2TeXMathDisplayEndSyntaxMode,			kiTM2TeXErrorSyntaxMode);
CAS0(kiTM2TeXSubStartSyntaxMode,				kiTM2TeXErrorSyntaxMode);
//CAS(kiTM2TeXSubShortSyntaxMode,				kiTM2TeXSuperStartSyntaxMode);
//CAS(kiTM2TeXSubscriptSyntaxMode,				kiTM2TeXSuperStartSyntaxMode);
CAS0(kiTM2TeXSuperStartSyntaxMode,				kiTM2TeXSuperContinueSyntaxMode);
//CAS(kiTM2TeXSuperContinueSyntaxMode,			kiTM2TeXSuperShortSyntaxMode);
//CAS(kiTM2TeXSuperShortSyntaxMode,				kiTM2TeXSuperStartSyntaxMode);
CAS0(kiTM2TeXSuperscriptSyntaxMode,				kiTM2TeXErrorSyntaxMode);
CAS0(kiTM2TeXCellSeparatorSyntaxMode,			kiTM2TeXSuperStartSyntaxMode);
//CAS(kiTM2TeXAccentSyntaxMode,					kiTM2TeXSuperStartSyntaxMode);
CAS1(kiTM2TeXUnknownSyntaxMode,					previousModeWithoutModifiers,			previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CAS1(kiTM2TeXErrorSyntaxMode,					previousModeWithoutModifiers,			previousModifier, kiTM2TeXWaitingSyntaxStatus);
			}
			* newModeRef = newMode | previousError | newModifier;
			return status ;

#pragma mark =-=-=-=-=- _
		case '_':
			newMode = kiTM2TeXSubStartSyntaxMode;
			newModifier &=~kiTM2TeXSimpleGroupSyntaxMask;
			switch(previousModeWithoutModifiers)
			{
//CAS(kiTM2TeXWhitePrefixSyntaxMode,				kiTM2TeXSubStartSyntaxMode);
//CAS(kiTM2TeXRegularSyntaxMode,					kiTM2TeXSubStartSyntaxMode);
CAS1(kiTM2TeXCommandStartSyntaxMode,			kiTM2TeXCommandEscapedCharacterSyntaxMode,	newModifier|kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
//CAS(kiTM2TeXCommandEscapedCharacterSyntaxMode,	kiTM2TeXSubStartSyntaxMode);
//CAS(kiTM2TeXCommandContinueSyntaxMode,			kiTM2TeXSubStartSyntaxMode);
CAS0(kiTM2TeXCommandInputSyntaxMode,			kiTM2TeXErrorSyntaxMode);
//CAS(kiTM2TeXGroupOpenSyntaxMode,				kiTM2TeXSubStartSyntaxMode);
//CAS(kiTM2TeXGroupCloseSyntaxMode,				kiTM2TeXSubStartSyntaxMode);
//CAS(kiTM2TeXParenOpenSyntaxMode,				kiTM2TeXSubStartSyntaxMode);
//CAS(kiTM2TeXParenCloseSyntaxMode,				kiTM2TeXSubStartSyntaxMode);
//CAS(kiTM2TeXBracketOpenSyntaxMode,				kiTM2TeXSubStartSyntaxMode);
//CAS(kiTM2TeXBracketCloseSyntaxMode,			kiTM2TeXSubStartSyntaxMode);
CAS0(kiTM2TeXCommentStartSyntaxMode,			kiTM2TeXCommentContinueSyntaxMode);
CAS0(kiTM2TeXCommentContinueSyntaxMode,			previousModeWithoutModifiers);
CAS0(kiTM2TeXMarkSyntaxMode,					kiTM2TeXMarkContinueSyntaxMode);
CAS0(kiTM2TeXMarkContinueSyntaxMode,			previousModeWithoutModifiers);
//CAS(kiTM2TeXMathSwitchSyntaxMode,				kiTM2TeXSubStartSyntaxMode);
//CAS(kiTM2TeXMathSwithContinueSyntaxMode,		kiTM2TeXSubStartSyntaxMode);
//CAS(kiTM2TeXMathInlineBeginSyntaxMode,			kiTM2TeXSubStartSyntaxMode);
CAS0(kiTM2TeXMathInlineEndSyntaxMode,			kiTM2TeXErrorSyntaxMode);
//CAS(kiTM2TeXMathDisplayBeginSyntaxMode,		kiTM2TeXSubStartSyntaxMode);
CAS0(kiTM2TeXMathDisplayEndSyntaxMode,			kiTM2TeXErrorSyntaxMode);
CAS0(kiTM2TeXSubStartSyntaxMode,				kiTM2TeXErrorSyntaxMode);
//CAS(kiTM2TeXSubShortSyntaxMode,				kiTM2TeXSubStartSyntaxMode);
CAS0(kiTM2TeXSubscriptSyntaxMode,				kiTM2TeXErrorSyntaxMode);
CAS0(kiTM2TeXSuperStartSyntaxMode,				kiTM2TeXErrorSyntaxMode);
//CAS(kiTM2TeXSuperContinueSyntaxMode,			kiTM2TeXSubStartSyntaxMode);
//CAS(kiTM2TeXSuperShortSyntaxMode,				kiTM2TeXSubStartSyntaxMode);
//CAS(kiTM2TeXSuperscriptSyntaxMode,				kiTM2TeXSubStartSyntaxMode);
CAS0(kiTM2TeXCellSeparatorSyntaxMode,			kiTM2TeXErrorSyntaxMode);
//CAS(kiTM2TeXAccentSyntaxMode,					kiTM2TeXSubStartSyntaxMode);
CAS1(kiTM2TeXUnknownSyntaxMode,					previousModeWithoutModifiers,		previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CAS1(kiTM2TeXErrorSyntaxMode,					previousModeWithoutModifiers,		previousModifier, kiTM2TeXWaitingSyntaxStatus);
			}
			* newModeRef = newMode | previousError | newModifier;
			return status ;
		
#pragma mark =-=-=-=-=- @
		case '@':
			newMode = kiTM2TeXRegularSyntaxMode;
			switch(previousModeWithoutModifiers)
			{
CAS0(kiTM2TeXWhitePrefixSyntaxMode,				kiTM2TeXRegularSyntaxMode);
CAS0(kiTM2TeXRegularSyntaxMode,					kiTM2TeXRegularSyntaxMode);
case kiTM2TeXCommandStartSyntaxMode:
newMode = [self contextBoolForKey:@"iTM2MakeAtLetter" domain:iTM2ContextExtendedProjectMask|iTM2ContextPrivateMask]?
	kiTM2TeXCommandContinueSyntaxMode:kiTM2TeXCommandEscapedCharacterSyntaxMode;
newModifier = newModifier | kiTM2TeXCommandSyntaxMask;
status = kiTM2TeXNoErrorSyntaxStatus;
break;
//CAS(kiTM2TeXCommandStartSyntaxMode,			kiTM2TeXCommandEscapedCharacterSyntaxMode,	previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CAS0(kiTM2TeXCommandEscapedCharacterSyntaxMode,	kiTM2TeXRegularSyntaxMode);
case kiTM2TeXCommandContinueSyntaxMode:
if([self contextBoolForKey:@"iTM2MakeAtLetter" domain:iTM2ContextExtendedProjectMask|iTM2ContextPrivateMask])
{
	newMode = kiTM2TeXCommandContinueSyntaxMode;
	newModifier = previousModifier;
}
else
{
	newMode = kiTM2TeXRegularSyntaxMode;
	newModifier = previousModifier &~ kiTM2TeXCommandSyntaxMask;
}
status = kiTM2TeXNoErrorSyntaxStatus;
break;
//CAS(kiTM2TeXCommandContinueSyntaxMode,			kiTM2TeXRegularSyntaxMode,			previousModifier, kiTM2TeXNoErrorSyntaxStatus);
//CAS0(kiTM2TeXCommandInputSyntaxMode,			kiTM2TeXRegularSyntaxMode);
//CAS0(kiTM2TeXGroupOpenSyntaxMode,				kiTM2TeXRegularSyntaxMode);
//CAS0(kiTM2TeXGroupCloseSyntaxMode,				kiTM2TeXRegularSyntaxMode);
//CAS0(kiTM2TeXParenOpenSyntaxMode,				kiTM2TeXRegularSyntaxMode);
//CAS0(kiTM2TeXParenCloseSyntaxMode,				kiTM2TeXRegularSyntaxMode);
//CAS0(kiTM2TeXBracketOpenSyntaxMode,				kiTM2TeXRegularSyntaxMode);
//CAS0(kiTM2TeXBracketCloseSyntaxMode,			kiTM2TeXRegularSyntaxMode);
CAS0(kiTM2TeXCommentStartSyntaxMode,			kiTM2TeXCommentContinueSyntaxMode);
CAS0(kiTM2TeXCommentContinueSyntaxMode,			previousModeWithoutModifiers);
CAS0(kiTM2TeXMarkSyntaxMode,					kiTM2TeXMarkContinueSyntaxMode);
CAS0(kiTM2TeXMarkContinueSyntaxMode,			previousModeWithoutModifiers);
//CAS0(kiTM2TeXMathSwitchSyntaxMode,				kiTM2TeXRegularSyntaxMode);
//CAS0(kiTM2TeXMathSwithContinueSyntaxMode,		kiTM2TeXRegularSyntaxMode);
//CAS0(kiTM2TeXMathInlineBeginSyntaxMode,			kiTM2TeXRegularSyntaxMode);
//CAS0(kiTM2TeXMathInlineEndSyntaxMode,			kiTM2TeXRegularSyntaxMode);
//CAS0(kiTM2TeXMathDisplayBeginSyntaxMode,		kiTM2TeXRegularSyntaxMode);
//CAS0(kiTM2TeXMathDisplayEndSyntaxMode,			kiTM2TeXRegularSyntaxMode);
//CAS0(kiTM2TeXSubStartSyntaxMode,				kiTM2TeXRegularSyntaxMode);
//CAS0(kiTM2TeXSubShortSyntaxMode,				kiTM2TeXRegularSyntaxMode);
//CAS0(kiTM2TeXSubscriptSyntaxMode,				kiTM2TeXRegularSyntaxMode);
//CAS0(kiTM2TeXSuperStartSyntaxMode,				kiTM2TeXRegularSyntaxMode);
//CAS0(kiTM2TeXSuperContinueSyntaxMode,			kiTM2TeXRegularSyntaxMode);
//CAS0(kiTM2TeXSuperShortSyntaxMode,				kiTM2TeXRegularSyntaxMode);
//CAS0(kiTM2TeXSuperscriptSyntaxMode,				kiTM2TeXRegularSyntaxMode);
//CAS0(kiTM2TeXCellSeparatorSyntaxMode,			kiTM2TeXRegularSyntaxMode);
//CAS0(kiTM2TeXAccentSyntaxMode,				kiTM2TeXRegularSyntaxMode);
CAS1(kiTM2TeXUnknownSyntaxMode,					previousModeWithoutModifiers,		previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CAS1(kiTM2TeXErrorSyntaxMode,					previousModeWithoutModifiers,		previousModifier, kiTM2TeXWaitingSyntaxStatus);
			}
			* newModeRef = newMode | previousError | newModifier;
			return status ;

#pragma mark =-=-=-=-=- default
		default:
		{
//NSLog(@"Non letter character: %@", [NSString stringWithCharacters: &theChar length:1]);
			newMode = kiTM2TeXRegularSyntaxMode;
			switch(previousModeWithoutModifiers)
			{
//CAS(kiTM2TeXWhitePrefixSyntaxMode,				kiTM2TeXRegularSyntaxMode);
//CAS(kiTM2TeXRegularSyntaxMode,					kiTM2TeXRegularSyntaxMode);
CAS1(kiTM2TeXCommandStartSyntaxMode,			kiTM2TeXCommandEscapedCharacterSyntaxMode,	newModifier | kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
//CAS(kiTM2TeXCommandEscapedCharacterSyntaxMode,	kiTM2TeXRegularSyntaxMode);
//CAS(kiTM2TeXCommandContinueSyntaxMode,			kiTM2TeXRegularSyntaxMode);
//CAS(kiTM2TeXCommandInputSyntaxMode,			kiTM2TeXRegularSyntaxMode);
//CAS(kiTM2TeXGroupOpenSyntaxMode,				kiTM2TeXRegularSyntaxMode);
//CAS(kiTM2TeXGroupCloseSyntaxMode,				kiTM2TeXRegularSyntaxMode);
//CAS(kiTM2TeXParenOpenSyntaxMode,				kiTM2TeXRegularSyntaxMode);
//CAS(kiTM2TeXParenCloseSyntaxMode,				kiTM2TeXRegularSyntaxMode);
//CAS(kiTM2TeXBracketOpenSyntaxMode,				kiTM2TeXRegularSyntaxMode);
//CAS(kiTM2TeXBracketCloseSyntaxMode,			kiTM2TeXRegularSyntaxMode);
CAS0(kiTM2TeXCommentStartSyntaxMode,			kiTM2TeXCommentContinueSyntaxMode);
CAS0(kiTM2TeXCommentContinueSyntaxMode,			previousModeWithoutModifiers);
CAS0(kiTM2TeXMarkSyntaxMode,					kiTM2TeXMarkContinueSyntaxMode);
CAS0(kiTM2TeXMarkContinueSyntaxMode,			previousModeWithoutModifiers);
//CAS(kiTM2TeXMathSwitchSyntaxMode,				kiTM2TeXRegularSyntaxMode);
//CAS(kiTM2TeXMathSwithContinueSyntaxMode,		kiTM2TeXRegularSyntaxMode);
//CAS(kiTM2TeXMathInlineBeginSyntaxMode,			kiTM2TeXRegularSyntaxMode);
//CAS(kiTM2TeXMathInlineEndSyntaxMode,			kiTM2TeXRegularSyntaxMode);
//CAS(kiTM2TeXMathDisplayBeginSyntaxMode,		kiTM2TeXRegularSyntaxMode);
//CAS(kiTM2TeXMathDisplayEndSyntaxMode,			kiTM2TeXRegularSyntaxMode);
CAS0(kiTM2TeXSubStartSyntaxMode,				kiTM2TeXSubShortSyntaxMode);
//CAS(kiTM2TeXSubShortSyntaxMode,				kiTM2TeXRegularSyntaxMode);
//CAS(kiTM2TeXSubscriptSyntaxMode,				kiTM2TeXRegularSyntaxMode);
CAS0(kiTM2TeXSuperStartSyntaxMode,				kiTM2TeXSuperShortSyntaxMode);
//CAS(kiTM2TeXSuperContinueSyntaxMode,			kiTM2TeXSuperShortSyntaxMode);
//CAS(kiTM2TeXSuperShortSyntaxMode,				kiTM2TeXRegularSyntaxMode);
//CAS(kiTM2TeXSuperscriptSyntaxMode,				kiTM2TeXRegularSyntaxMode);
//CAS(kiTM2TeXCellSeparatorSyntaxMode,			kiTM2TeXRegularSyntaxMode);
//CAS(kiTM2TeXAccentSyntaxMode,					kiTM2TeXRegularSyntaxMode);
CAS1(kiTM2TeXUnknownSyntaxMode,					previousModeWithoutModifiers,				previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CAS1(kiTM2TeXErrorSyntaxMode,					previousModeWithoutModifiers,				previousModifier, kiTM2TeXWaitingSyntaxStatus);
			}
//NSLog(@"mode returned: %u", newMode);
			modeString = [_iTM2TeXModeForModeArray objectAtIndex:newMode];
			if([_AS character:theChar isMemberOfCoveredCharacterSetForMode:modeString])
			{
				* newModeRef = newMode | previousError | newModifier;
				return kiTM2TeXNoErrorSyntaxStatus;
			}
			else
			{
//iTM2_LOG(@"AN ERROR OCCURRED");
				* newModeRef = newMode | kiTM2TeXErrorSyntaxMask | previousError | previousModifier;// REVISIT, this has no meaning
				return kiTM2TeXNoErrorSyntaxStatus;
			}
		}
	}
}
#if 1
#include <iTM2Foundation/iTM2Foundation.h>
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  getSyntaxMode:forLocation:previousMode:effectiveLength:nextModeIn:before:
- (unsigned)getSyntaxMode:(unsigned *)newModeRef forLocation:(unsigned)location previousMode:(unsigned)previousMode effectiveLength:(unsigned *)lengthRef nextModeIn:(unsigned *)nextModeRef before:(unsigned)beforeIndex;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Dec 12 22:44:56 GMT 2003
To Do List: 
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSParameterAssert(newModeRef);
    NSString * S = [_TextStorage string];
	unsigned length = [S length];
    NSParameterAssert(location<length);
	NSString * substring;
	NSRange r;
	unsigned status;
//	unsigned previousError = previousMode & kiTM2TeXErrorSyntaxMask;
//	unsigned previousModifier = previousMode & kiTM2TeXModifiersSyntaxMask;
	unsigned previousModeWithoutModifiers = previousMode & ~kiTM2TeXFlagsSyntaxMask;
	unichar theChar = [S characterAtIndex:location];
	unsigned start, end;
	static ICURegEx * RE = nil;
	if(kiTM2TeXCommandStartSyntaxMode == previousModeWithoutModifiers)
	{
		if((theChar == '`')||(theChar == '\'')||(theChar == '^')||(theChar == '"')||(theChar == '~')
			||(theChar == '=')||(theChar == '.'))
		{
			r.location = location+1;
			r.length = MIN(length-r.location,4);
			RE = [ICURegEx regExWithSearchPattern:@"^\\{(?:.*?\\})?"];
			[RE setInputString:S range:r];
			if([RE nextMatch])
			{
				r = [RE rangeOfMatch];
				end = location+r.length+1;
				start = location;
				if(lengthRef)
				{
					* lengthRef = end-start;
				}
			}
			else
			{
				end = location+1;
				start = location;
				if(lengthRef)
				{
					* lengthRef = end-start;
				}
			}
			* newModeRef = kiTM2TeXAccentSyntaxMode;
			if(nextModeRef && (end<length))
			{
				theChar = [S characterAtIndex:end];
				status = [self getSyntaxMode:nextModeRef forCharacter:theChar previousMode:*newModeRef];
			}
			return kiTM2TeXNoErrorSyntaxStatus;
		}
		if((theChar == 'u')||(theChar == 'v')||(theChar == 'H')
				||(theChar == 't')||(theChar == 'c')||(theChar == 'd')||(theChar == 'b'))
		{
			r.location = location+1;
			r.length = MIN(length-r.location,4);
			[RE setInputString:S range:r];
			if([RE nextMatch])
			{
				r = [RE rangeOfMatch];
				end = location+r.length+1;
				start = location;
				if(lengthRef)
				{
					* lengthRef = end-start;
				}
				* newModeRef = kiTM2TeXAccentSyntaxMode;
				if(nextModeRef && (end<length))
				{
					theChar = [S characterAtIndex:end];
					status = [self getSyntaxMode:nextModeRef forCharacter:theChar previousMode:*newModeRef];
				}
				return kiTM2TeXNoErrorSyntaxStatus;
			}
		}
		NSCharacterSet * set = [NSCharacterSet TeXLetterCharacterSet];
		if([set characterIsMember:theChar])
		{
			// is it a \input
			// scanning from location for the control sequence name
			start = location-1;
			end = location+1;
			while(end<length && ((theChar = [S characterAtIndex:end]),[set characterIsMember:theChar]))
				++end;
			if(end == start+6)
			{
				r = NSMakeRange(start, end-start);
				substring = [S substringWithRange:r];
				if([iTM2TeXCommandInputSyntaxModeName isEqualToString:substring])
				{
					if(lengthRef)
					{
						* lengthRef = end-start-1;
					}
					* newModeRef = kiTM2TeXCommandInputSyntaxMode;
					if(nextModeRef && (end<length))
					{
						theChar = [S characterAtIndex:end];
						status = [self getSyntaxMode:nextModeRef forCharacter:theChar previousMode:*newModeRef];
					}
					// now we invalidate the cursor rects in order to have the links properly displayed
					//the delay is due to the reentrant problem
					[_TextStorage performSelector:@selector(invalidateCursorRects) withObject:nil afterDelay:0.01];
					return kiTM2TeXNoErrorSyntaxStatus;
				}
			}
			if(lengthRef)
			{
				* lengthRef = end-start-1;
			}
			* newModeRef = kiTM2TeXCommandContinueSyntaxMode;
			if(nextModeRef && (end<length))
			{
				theChar = [S characterAtIndex:end];
				status = [self getSyntaxMode:nextModeRef forCharacter:theChar previousMode:*newModeRef];
			}
			return kiTM2TeXNoErrorSyntaxStatus;
		}
	}
// placeholder marks management
	BOOL escaped = NO;
	if(theChar == '@')
	{
		if(location)
		{
			if([S isControlAtIndex:location-1 escaped:&escaped]&&!escaped)
			{
				if(lengthRef)
				{
					* lengthRef = 1;
				}
				if(nextModeRef)
				{
					* nextModeRef = kiTM2TeXUnknownSyntaxMode;
				}
				* newModeRef = kiTM2TeXCommandEscapedCharacterSyntaxMode;
				return kiTM2TeXNoErrorSyntaxStatus;
			}
		}
placeholder:
		// get the range of all the @'s
		r.location = location;
		r.length = 1;
		unichar anotherChar;
		while(r.location)
		{
			unichar anotherChar = [S characterAtIndex:r.location-1];
			if((anotherChar == '@')||(anotherChar == '(')||(anotherChar == ')'))
			{
				--r.location;
				++r.length;
			}
			else
			{
				break;
			}
		}
		end = NSMaxRange(r);
		while(end<length)
		{
			anotherChar = [S characterAtIndex:end];
			if((anotherChar == '@')||(anotherChar == '(')||(anotherChar == ')'))
			{
				++r.length;
				++end;
			}
			else
			{
				break;
			}
		}
		if(r.location)
		{
			BOOL escaped;
			if([S isControlAtIndex:r.location-1 escaped:&escaped]&&!escaped)
			{
				++r.location;
				--r.length;
			}
		}
		start = r.location;
		substring = [S substringWithRange:r];
		RE = [ICURegEx regExWithSearchPattern:@"@@@\\(|\\)@@@"];
		[RE setInputString:substring];
		while([RE nextMatch])
		{
			r = [RE rangeOfMatch];
			r.location += start;
			if(NSLocationInRange(location,r))
			{
				if(lengthRef)
				{
					* lengthRef = NSMaxRange(r)-location;
				}
				if(nextModeRef)
				{
					* nextModeRef = kiTM2TeXUnknownSyntaxMode;
				}
				* newModeRef = kiTM2TeXPlaceholderDelimiterMode;
				return kiTM2TeXNoErrorSyntaxStatus;
			}
			start = NSMaxRange(r);
		}
	}
	else if(((theChar == '(') && (location>2))
			||((theChar == ')') && (location+3<[S length])))
	{
		if(!location
			|| ![S isControlAtIndex:location-1 escaped:&escaped]
				|| escaped)
		{
			goto placeholder;
		}
	}
	status = [self getSyntaxMode:newModeRef forCharacter:theChar previousMode:previousMode];
	if(lengthRef) // && (previousMode != kiTM2TeXCommandStartSyntaxMode) || ![set characterIsMember:theChar]
	{
		* lengthRef = 1;
		if(kiTM2TeXCommandStartSyntaxMode != (*newModeRef & ~kiTM2TeXFlagsSyntaxMask))
		{
//NSLog(@"0: character: %@", [NSString stringWithCharacters: &C length:1]);
//NSLog(@"1: nextMode: %u, previousMode: %u", nextMode, previousMode);
			beforeIndex = MIN(beforeIndex, [S length]);
			while(++location < beforeIndex)
			{
				theChar = [S characterAtIndex:location];
				if((theChar == '@')||(theChar == '(')||(theChar == ')'))
				{
					if(nextModeRef)
						* nextModeRef = kiTM2TeXUnknownSyntaxMode;
					return kiTM2TeXNoErrorSyntaxStatus;
				}
				previousMode = *newModeRef;
				status = [self getSyntaxMode:newModeRef forCharacter:theChar previousMode:previousMode];
//NSLog(@"2: nextMode: %u, previousMode: %u", nextMode, previousMode);
				if(*newModeRef == previousMode)
					* lengthRef += 1;
				else
				{
					if(nextModeRef)
						* nextModeRef = *newModeRef;
					* newModeRef = previousMode;
					return kiTM2TeXNoErrorSyntaxStatus;
				}
			}
		}
		if(nextModeRef)
			* nextModeRef = kiTM2TextUnknownSyntaxMode;
		return kiTM2TeXNoErrorSyntaxStatus;
	}
	// if(!lengthRef) && (previousMode != kiTM2TeXCommandStartSyntaxMode)
	if(nextModeRef)
		* nextModeRef = kiTM2TextUnknownSyntaxMode;
//NSLog(@"nextMode: %u, previousMode: %u", nextMode, previousMode);
	return status;
}
#else
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  getSyntaxMode:forLocation:previousMode:effectiveLength:nextModeIn:before:
- (unsigned)getSyntaxMode:(unsigned *)nextModeRef forLocation:(unsigned)location previousMode:(unsigned)previousMode effectiveLength:(unsigned *)lengthRef nextModeIn:(unsigned *)nextModeRef before:(unsigned)beforeIndex;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Dec 12 22:44:56 GMT 2003
To Do List: 
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSParameterAssert(nextModeRef);
    NSString * S = [_TextStorage string];
	unichar theChar;
    if(location<[S length])
    {
        if(lengthRef)
        {
            * lengthRef = 1;
			theChar = [S characterAtIndex:location];
            unsigned nextMode = [self getSyntaxMode:&newMode forCharacter:theChar previousMode:previousMode];
//NSLog(@"0: character: %@", [NSString stringWithCharacters: &C length:1]);
//NSLog(@"1: nextMode: %u, previousMode: %u", nextMode, previousMode);
            beforeIndex = MIN(beforeIndex, [S length]);
            while(++location < beforeIndex)
            {
                previousMode = nextMode;
				theChar = [S characterAtIndex:location];
                nextMode = [self getSyntaxMode:&newMode forCharacter:theChar previousMode:previousMode];
//NSLog(@"2: nextMode: %u, previousMode: %u", nextMode, previousMode);
                if(nextMode == previousMode)
                    * lengthRef += 1;
                else
                {
                    if(nextModeRef)
                        * nextModeRef = nextMode;
                    return previousMode;
                }
            }
            if(nextModeRef)
                * nextModeRef = 0;
            return nextMode;
        }
        else
        {
            if(nextModeRef)
                * nextModeRef = 0;
			theChar = [S characterAtIndex:location];
            unsigned nextMode = [self getSyntaxMode:&newMode forCharacter:theChar previousMode:previousMode];
//NSLog(@"nextMode: %u, previousMode: %u", nextMode, previousMode);
            return nextMode;
        }
    }
    else
    {
//iTM2_LOG(@"location: %i <=  [S length] %i", location, [S length]);
        if(lengthRef)
            * lengthRef = 0;
        return [self EOLModeForPreviousMode:previousMode];
    }
}
#endif
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  EOLModeForPreviousMode:
- (unsigned)EOLModeForPreviousMode:(unsigned)previousMode;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Dec 12 22:44:56 GMT 2003
To Do List: 
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//NSLog(@"Character: %@", [NSString stringWithCharacters: &argument length:1]);
//NSLog(@"previousMode: %u", previousMode);
//NSLog(@"result: %u", previousMode-1);
#if 0
	kiTM2TeXErrorSyntaxMask = kiTM2TextErrorSyntaxMask,
	kiTM2TeXModifiersSyntaxMask = kiTM2TextModifiersSyntaxMask,
	kiTM2TeXFlagsSyntaxMask = kiTM2TeXFlagsSyntaxMask,
	kiTM2TeXEndOfLineSyntaxMask = kiTM2TextEndOfLineSyntaxMask,
	kiTM2TeXCommandSyntaxMask = kiTM2TextEndOfLineSyntaxMask << 1,
	kiTM2TeXMathDisplaySyntaxMask = kiTM2TeXCommandSyntaxMask << 1,
	kiTM2TeXMathInlineSyntaxMask = kiTM2TeXMathDisplaySyntaxMask << 1,
	kiTM2TeXSubscriptSyntaxMask = kiTM2TeXMathInlineSyntaxMask << 1,
	kiTM2TeXSuperscriptSyntaxMask = kiTM2TeXSubscriptSyntaxMask << 1,
	kiTM2TeXErrorFontSyntaxMask = 1 << 24,// 24, up to 31
	kiTM2TeXErrorSyntaxSyntaxMask = kiTM2TeXErrorFontSyntaxMask << 1
#endif

	if(previousMode&kiTM2TeXEndOfLineSyntaxMask)
	{
		// very strong cleaning for void lines...
		previousMode = kiTM2TeXRegularSyntaxMode | kiTM2TeXEndOfLineSyntaxMask;
		return previousMode;
	}
	unsigned previousFlags = previousMode & kiTM2TeXFlagsSyntaxMask;
	
    previousFlags &= ~kiTM2TeXCommandSyntaxMask;
    previousFlags &= ~kiTM2TeXErrorFontSyntaxMask;
    previousFlags &= ~kiTM2TeXErrorSyntaxSyntaxMask;
	previousFlags |= kiTM2TeXEndOfLineSyntaxMask;// beware, you must use the kiTM2TextEndOfLineSyntaxMask
    return kiTM2TeXRegularSyntaxMode | previousFlags;
}
#endif
#pragma mark -
#pragma mark =-=-=-=-=-  iTM2TeXParser and Xtd:
// this file should be included
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  attributesAtIndex:effectiveRange:
- (NSDictionary *)attributesAtIndex:(unsigned)aLocation effectiveRange:(NSRangePointer)aRangePtr;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	// we manage at the same time the attributes with or without symbols
	// the symbol variant adds more tests
	unsigned fullMode;
    unsigned lineIndex = [self lineIndexForLocation:aLocation];
    iTM2ModeLine * modeLine = [self modeLineAtIndex:lineIndex];
	NSRange range;
 	[modeLine getSyntaxMode:&fullMode atGlobalLocation:aLocation longestRange:&range];
    if(aRangePtr)
	{
		*aRangePtr = range;
	}
	unsigned int modeWithoutModifiers = fullMode & ~kiTM2TeXFlagsSyntaxMask;
	
	NSString * S = [_TextStorage string];

	// when the attributes are properly set, go to returnOutAttributes
	// it will take care of the return for you
	unsigned outRangeStart = range.location;
	unsigned outRangeStop = NSMaxRange(range);
	unsigned outMode = modeWithoutModifiers;
	NSString * outModeName;

	// auxiliary
	unsigned otherMode;
	unsigned otherFullMode;
	
	NSDictionary * attributes;
	
	// this is used in the iTM2_ATTRIBUTE_ASSERT macro
	NSString * ERROR = @"UNKNOWN ERROR";
	
#ifdef iTM2_WITH_SYMBOLS
	NSString * symbolName;// the real string corresponding to the symbol
	unsigned symbolRangeStart = outRangeStart;// not yet complete
	unsigned symbolRangeStop = outRangeStop;// not yet complete
	unsigned symbolMode = modeWithoutModifiers;

	// if I am in a simple group or near a simple group things might be more difficult
	// simple groups are delimited by { and }
	// this is the case for \command{}, ^{} and _{}
	// Am I IN a simple group?
	if(fullMode&kiTM2TeXSimpleGroupSyntaxMask)
	{
		range = [modeLine longestRangeAtGlobalLocation:aLocation mask:kiTM2TeXSimpleGroupSyntaxMask];
		// other range might be bigger than the original range.
		// this is the starting point for attributed text
		// now extend the group to the left and to the right
		symbolRangeStart = range.location;// not yet complete
		symbolRangeStop = NSMaxRange(range);// not yet complete
		// range is free now
testStartSimpleGroup:
		if(symbolRangeStart>[modeLine startOffset]+1)
		{
			// there are 2 characters before, enough for '^{' for example
			// testing for '{'
			[modeLine getSyntaxMode:&otherFullMode atGlobalLocation:--symbolRangeStart longestRange:&range];
			otherMode = otherFullMode & ~kiTM2TeXFlagsSyntaxMask;
			iTM2_ATTRIBUTE_ASSERT(otherMode == kiTM2TeXGroupOpenSyntaxMode,@"Missing '{' before simple group");
			if(range.length==1)// otherwise we have more han one '{', this is not a useable simple group and we skip it
			{
beforeSimpleGroup:
				[modeLine getSyntaxMode:&otherFullMode atGlobalLocation:--symbolRangeStart longestRange:&range];
				symbolMode = otherFullMode & ~kiTM2TeXFlagsSyntaxMask;
				// keep symbolMode around because it will be used later to switch
				if((symbolMode == kiTM2TeXCommandEscapedCharacterSyntaxMode)
					|| (otherMode == kiTM2TeXAccentSyntaxMode)
					|| (otherMode == kiTM2TeXCommandContinueSyntaxMode)
					|| (otherMode == kiTM2TeXCommandInputSyntaxMode))
				{
					symbolRangeStart = range.location;// not yet complete
					iTM2_ATTRIBUTE_ASSERT(symbolRangeStart>[modeLine startOffset],@"No room for a \\ before a command name (no char given)");
					[modeLine getSyntaxMode:&otherFullMode atGlobalLocation:--symbolRangeStart longestRange:&range];
					otherMode = otherFullMode & ~kiTM2TeXFlagsSyntaxMask;
					iTM2_ATTRIBUTE_ASSERT(otherMode == kiTM2TeXCommandStartSyntaxMode,@"Missing \\ before a command name(missing char)");
					// symbolRangeStart is now complete
closingSimpleGroup:
					// may be the input string is not complete and the closing '}' was not yet entered
					if(symbolRangeStop<[modeLine contentsEndOffset])
					{
						[modeLine getSyntaxMode:&otherFullMode atGlobalLocation:symbolRangeStop longestRange:nil];// range not needed
						otherMode = otherFullMode & ~kiTM2TeXFlagsSyntaxMask;
						if(otherMode == kiTM2TeXGroupCloseSyntaxMode)
						{
							++symbolRangeStop;
							// symbolRangeStop is now complete
tryToConclude:
							range.location = symbolRangeStart;
							range.length = symbolRangeStop - range.location;
							symbolName = [S substringWithRange:range];
							outModeName = [_iTM2TeXModeForModeArray objectAtIndex:symbolMode];
							if(attributes = [_AS attributesForSymbol:symbolName mode:outModeName])
							{
								if(aRangePtr)
								{
									*aRangePtr=range;
								}
								if(iTM2DebugEnabled>9999)
								{
									iTM2_LOG(@"aLocation:%i, range:%@, symbolName:%@",aLocation,NSStringFromRange(range),symbolName);
								}
								return attributes;
							}
							// we could not conclude here
							// the standard attribute policy applies now, go below
						}
					}
				}
				else if((symbolMode == kiTM2TeXSubStartSyntaxMode)||(symbolMode == kiTM2TeXSuperStartSyntaxMode))
				{
					symbolRangeStart = range.location;// now symbolRangeStart is complete
					goto closingSimpleGroup;
				}
			}
		}
	}
	else if(modeWithoutModifiers == kiTM2TeXGroupOpenSyntaxMode)
	{
		// opening a group
		if(symbolRangeStop<[modeLine contentsEndOffset])
		{
			range = [modeLine longestRangeAtGlobalLocation:symbolRangeStop mask:kiTM2TeXSimpleGroupSyntaxMask];
			if(range.length)
			{
				symbolRangeStop = NSMaxRange(range);
				if(symbolRangeStart>[modeLine startOffset])
				{
					goto beforeSimpleGroup;
				}
			}
		}
	}
	else if(modeWithoutModifiers == kiTM2TeXGroupCloseSyntaxMode)
	{
		// this is a '}', just extend upstream
		if(symbolRangeStart == aLocation)// we only consider the first '}' of a series
		{
			outRangeStop = outRangeStart + 1;// only the first '}' of a sequence
			symbolRangeStop = symbolRangeStart + 1;// only the first '}' of a sequence
			if(symbolRangeStart>[modeLine startOffset]+1)
			{
				range = [modeLine longestRangeAtGlobalLocation:aLocation mask:kiTM2TeXSimpleGroupSyntaxMask];
				if(range.length)
				{
					symbolRangeStart = range.location;
					goto testStartSimpleGroup;
				}
			}
		}
		else
		{
			++outRangeStart;// exclude the first, it was already managed above
			goto returnOutAttributes;
		}
	}
	else if((modeWithoutModifiers == kiTM2TeXSubStartSyntaxMode)||(modeWithoutModifiers == kiTM2TeXSuperStartSyntaxMode))
	{
		if(symbolRangeStop+2<[modeLine contentsEndOffset])//room for 3 chars: '{.}'
		{
			range = [modeLine longestRangeAtGlobalLocation:symbolRangeStop+1 mask:kiTM2TeXSimpleGroupSyntaxMask];
			if(range.length)
			{
				symbolRangeStop = NSMaxRange(range);
				goto closingSimpleGroup;
			}
		}
	}
	else if(modeWithoutModifiers == kiTM2TeXAccentSyntaxMode)
	{
		iTM2_ATTRIBUTE_ASSERT(symbolRangeStart>[modeLine startOffset],@"No room for a '\\' when expected...");
		--symbolRangeStart;
		symbolMode = kiTM2TeXAccentSyntaxMode;
		goto tryToConclude;
	}
	else if((modeWithoutModifiers == kiTM2TeXCommandEscapedCharacterSyntaxMode)
				|| (modeWithoutModifiers == kiTM2TeXCommandContinueSyntaxMode)
				|| (modeWithoutModifiers == kiTM2TeXCommandInputSyntaxMode) )
	{
		iTM2_ATTRIBUTE_ASSERT(symbolRangeStart>[modeLine startOffset],@"No room for a '\\' when expected...");
		--symbolRangeStart;
		if(symbolRangeStop+2<[modeLine contentsEndOffset])//room for 3 chars '{.}'
		{
			range = [modeLine longestRangeAtGlobalLocation:symbolRangeStop+1 mask:kiTM2TeXSimpleGroupSyntaxMask];
			if(range.length)
			{
				symbolRangeStop = NSMaxRange(range);
				goto closingSimpleGroup;
			}
		}
	}
	else if(modeWithoutModifiers == kiTM2TeXCommandStartSyntaxMode)
	{
		iTM2_ATTRIBUTE_ASSERT(symbolRangeStart>[modeLine startOffset],@"No room for a '\\' when expected...");
		if(symbolRangeStop+3<[modeLine contentsEndOffset])//room for 4 chars '.{.}'
		{
			[modeLine getSyntaxMode:&otherFullMode atGlobalLocation:symbolRangeStop longestRange:&range];
			symbolMode = otherFullMode & ~kiTM2TeXFlagsSyntaxMask;
			if((symbolMode == kiTM2TeXCommandEscapedCharacterSyntaxMode)
				|| (symbolMode == kiTM2TeXCommandContinueSyntaxMode)
				|| (symbolMode == kiTM2TeXCommandInputSyntaxMode) )
			{
				symbolRangeStop = NSMaxRange(range);
				if(symbolRangeStop+2<[modeLine contentsEndOffset])//room for 3 chars '{.}'
				{
					range = [modeLine longestRangeAtGlobalLocation:symbolRangeStop+1 mask:kiTM2TeXSimpleGroupSyntaxMask];
					if(range.length)
					{
						symbolRangeStop = NSMaxRange(range);
						goto closingSimpleGroup;
					}
				}
			}
			else if(symbolMode == kiTM2TeXAccentSyntaxMode)
			{
				symbolRangeStop = NSMaxRange(range);
				goto tryToConclude;
			}
		}
	}
#endif
	
	switch(modeWithoutModifiers)
    {
		case kiTM2TeXParenOpenSyntaxMode:
		case kiTM2TeXBracketOpenSyntaxMode:
		case kiTM2TeXParenCloseSyntaxMode:
		case kiTM2TeXBracketCloseSyntaxMode:
		case kiTM2TeXCommentContinueSyntaxMode:
		case kiTM2TeXMarkSyntaxMode:
		case kiTM2TeXMarkContinueSyntaxMode:
		case kiTM2TeXMathInlineBeginSyntaxMode:
		case kiTM2TeXMathInlineEndSyntaxMode:
		case kiTM2TeXMathDisplayBeginSyntaxMode:
		case kiTM2TeXMathDisplayEndSyntaxMode:
		case kiTM2TeXSubscriptSyntaxMode:
		case kiTM2TeXSuperscriptSyntaxMode:
		case kiTM2TeXCellSeparatorSyntaxMode:
		case kiTM2TeXCommandInputSyntaxMode:
        case kiTM2TeXWhitePrefixSyntaxMode:
        case kiTM2TeXPlaceholderDelimiterMode:
        case kiTM2TeXErrorSyntaxMode:
			goto returnOutAttributes;

        case kiTM2TeXUnknownSyntaxMode:
			outMode = kiTM2TeXErrorSyntaxMode;
			goto returnOutAttributes;

#pragma mark =-=-=-=-=-  SUPER
		case kiTM2TeXSuperStartSyntaxMode:
			iTM2_ATTRIBUTE_ASSERT(range.length == 1,@"too much starting ^");
			if(outRangeStop<[modeLine contentsEndOffset])
			{
				[self getSyntaxMode:&otherFullMode atIndex:outRangeStop longestRange:&range];
				otherMode = otherFullMode & ~kiTM2TeXFlagsSyntaxMask;
				if(otherMode == kiTM2TeXSuperShortSyntaxMode)
				{
					iTM2_ATTRIBUTE_ASSERT(range.length == 1,@"too much short ^ after start");
					outRangeStop = NSMaxRange(range);
					outMode = otherMode;
				}
				else if(otherMode == kiTM2TeXSuperContinueSyntaxMode)
				{
					outRangeStop = NSMaxRange(range);
					outMode = otherMode;
					if(outRangeStop<[modeLine contentsEndOffset])
					{
						[self getSyntaxMode:&otherFullMode atIndex:outRangeStop longestRange:&range];
						otherMode = otherFullMode & ~kiTM2TeXFlagsSyntaxMask;
						if(otherMode == kiTM2TeXSuperShortSyntaxMode)
						{
							iTM2_ATTRIBUTE_ASSERT(range.length == 1,@"too much short ^ after continue after start");
							outRangeStop = NSMaxRange(range);
							// NO: outMode = otherMode;
						}
					}
				}
			}
			goto returnOutAttributes;

		case kiTM2TeXSuperShortSyntaxMode:
			iTM2_ATTRIBUTE_ASSERT(range.length == 1,@"too much short ^ (second)");
			iTM2_ATTRIBUTE_ASSERT(outRangeStart>[modeLine startOffset],@"missing start ^ before short");
			[self getSyntaxMode:&otherFullMode atIndex:outRangeStart-1 longestRange:&range];
			otherMode = otherFullMode & ~kiTM2TeXFlagsSyntaxMask;
			if(otherMode == kiTM2TeXSuperStartSyntaxMode)
			{
				iTM2_ATTRIBUTE_ASSERT(range.length == 1,@"too much starting ^ before short");
			}
			else if(otherMode == kiTM2TeXSuperContinueSyntaxMode)
			{
				iTM2_ATTRIBUTE_ASSERT(range.length == 1,@"too much continue ^ before short");
				outRangeStart = range.location;
				iTM2_ATTRIBUTE_ASSERT(outRangeStart>[modeLine startOffset],@"missing start ^ before continuous before short");
				outMode = otherMode;
			}
			else
			{
				iTM2_ATTRIBUTE_ASSERT(NO,@"expected ^ missing before short");
			}
			outRangeStart = range.location;
			goto returnOutAttributes;

		case kiTM2TeXSuperContinueSyntaxMode:
			iTM2_ATTRIBUTE_ASSERT(range.length == 1,@"too much short ^ continue");
			iTM2_ATTRIBUTE_ASSERT(outRangeStart>[modeLine startOffset],@"missing start ^ before short");
			[self getSyntaxMode:&otherFullMode atIndex:outRangeStart-1 longestRange:&range];
			otherMode = otherFullMode & ~kiTM2TeXFlagsSyntaxMask;
			iTM2_ATTRIBUTE_ASSERT(otherMode == kiTM2TeXSuperStartSyntaxMode,@"expected ^ missing before short");
			iTM2_ATTRIBUTE_ASSERT(range.length == 1,@"too much starting ^ (second)");
			outRangeStart = range.location;
			if(outRangeStop==[modeLine contentsEndOffset])
			{
				[self getSyntaxMode:&otherFullMode atIndex:outRangeStart-1 longestRange:&range];
				otherMode = otherFullMode & ~kiTM2TeXFlagsSyntaxMask;
				if(otherMode == kiTM2TeXSuperShortSyntaxMode)
				{
					iTM2_ATTRIBUTE_ASSERT(range.length == 1,@"too much short ^ after continue");
					outRangeStop == NSMaxRange(range);
				}
			}
			goto returnOutAttributes;

#pragma mark =-=-=-=-=-  SUB
        case kiTM2TeXSubStartSyntaxMode:
			iTM2_ATTRIBUTE_ASSERT(range.length == 1,@"too much start _");
			if(outRangeStop<[modeLine contentsEndOffset])
			{
				[self getSyntaxMode:&otherFullMode atIndex:outRangeStop longestRange:&range];
				otherMode = otherFullMode & ~kiTM2TeXFlagsSyntaxMask;
				if(otherMode == kiTM2TeXSubShortSyntaxMode)
				{
					iTM2_ATTRIBUTE_ASSERT(range.length == 1,@"too much short _ after start");
					outRangeStop = NSMaxRange(range);
					outMode = otherMode;
				}
			}
			goto returnOutAttributes;

		case kiTM2TeXSubShortSyntaxMode:
			iTM2_ATTRIBUTE_ASSERT(range.length == 1,@"too much short _");
			iTM2_ATTRIBUTE_ASSERT(outRangeStart>[modeLine startOffset],@"missing start _ before short");
			[self getSyntaxMode:&otherFullMode atIndex:outRangeStart-1 longestRange:&range];
			otherMode = otherFullMode & ~kiTM2TeXFlagsSyntaxMask;
			iTM2_ATTRIBUTE_ASSERT(otherMode == kiTM2TeXSubStartSyntaxMode,@"expected _ missing before short");
			outRangeStart = range.location;
			goto returnOutAttributes;

#pragma mark =-=-=-=-=- COMMAND
        case kiTM2TeXCommandStartSyntaxMode:
			iTM2_ATTRIBUTE_ASSERT(range.length==1,@"start command too big");
			if(outRangeStop==[modeLine contentsEndOffset])
			{
				goto returnOutAttributes;
			}
			[modeLine getSyntaxMode:&otherFullMode atGlobalLocation:outRangeStop longestRange:&range];
			otherMode = otherFullMode & ~kiTM2TeXFlagsSyntaxMask;
			if(otherMode == kiTM2TeXSuperStartSyntaxMode)
			{
				goto returnOutAttributes;
			}
			if(otherMode == kiTM2TeXSuperShortSyntaxMode)
			{
				outRangeStop = NSMaxRange(range);
				outMode = kiTM2TeXSuperShortSyntaxMode;
			}
			else if((otherMode == kiTM2TeXCommandEscapedCharacterSyntaxMode)
				|| (otherMode == kiTM2TeXCommandContinueSyntaxMode)
				|| (otherMode == kiTM2TeXAccentSyntaxMode))
			{
				outMode = otherMode;
				outRangeStop = NSMaxRange(range);
#ifdef iTM2_WITH_SYMBOLS
fullCommand:
				// something like '\foo{blah}'
				if(outRangeStop+2>=[modeLine contentsEndOffset])
				{
					goto returnOutAttributes;
				}
				[modeLine getSyntaxMode:&otherFullMode atGlobalLocation:outRangeStop longestRange:&range];
				otherMode = otherFullMode & ~kiTM2TeXFlagsSyntaxMask;
				if((otherMode != kiTM2TeXGroupOpenSyntaxMode) || (range.length>1))
				{
					goto returnOutAttributes;
				}
				range.location = NSMaxRange(range);
				if(range.location>=[modeLine contentsEndOffset])
				{
					goto returnOutAttributes;
				}
				[modeLine getSyntaxMode:&otherFullMode atGlobalLocation:range.location longestRange:&range];
				otherMode = otherFullMode & ~kiTM2TeXFlagsSyntaxMask;
				if(otherMode != kiTM2TeXRegularSyntaxMode)
				{
					goto returnOutAttributes;
				}
#warning FAILED
//				iTM2_ATTRIBUTE_ASSERT(otherFullMode&kiTM2TeXCommandSyntaxMask,@"This should be command tagged after {");
				range.location = NSMaxRange(range);
				if(range.location>=[modeLine contentsEndOffset])
				{
					goto returnOutAttributes;
				}
				[modeLine getSyntaxMode:&otherFullMode atGlobalLocation:range.location longestRange:&range];
				otherMode = otherFullMode & ~kiTM2TeXFlagsSyntaxMask;
				if(otherMode != kiTM2TeXGroupCloseSyntaxMode)
				{
					goto returnOutAttributes;
				}
				range.length = range.location+1;// only one '}'
				range.location = outRangeStart;
				range.length = range.length-range.location;
				if(aRangePtr)
				{
					if(aLocation>=NSMaxRange(range))
					{
						range.length = aLocation - range.location;
					}
					*aRangePtr = range;
				}
				symbolName = [S substringWithRange:range];
				if(attributes = [_AS attributesForSymbol:symbolName mode:nil])
				{
//iTM2_LOG(@"aLocation:%i, range:%@, symbolName:%@",aLocation,NSStringFromRange(range),symbolName);
					return attributes;
				}
#endif
			}
			else if((otherMode == kiTM2TeXMathInlineBeginSyntaxMode)
				|| (otherMode == kiTM2TeXMathInlineEndSyntaxMode)
				|| (otherMode == kiTM2TeXMathDisplayBeginSyntaxMode)
				|| (otherMode == kiTM2TeXMathDisplayEndSyntaxMode))
			{
				outRangeStop = NSMaxRange(range);
				outMode = otherMode;
			}
			goto returnOutAttributes;

        case kiTM2TeXCommandEscapedCharacterSyntaxMode:
			iTM2_ATTRIBUTE_ASSERT(range.length==1,@"short command too long");
        case kiTM2TeXCommandContinueSyntaxMode:
			iTM2_ATTRIBUTE_ASSERT(outRangeStart>[modeLine startOffset],@"missing \\ before command");
			[modeLine getSyntaxMode:&otherFullMode atGlobalLocation:outRangeStart-1 longestRange:&range];
			otherMode = otherFullMode & ~kiTM2TeXFlagsSyntaxMask;
			iTM2_ATTRIBUTE_ASSERT(otherMode==kiTM2TeXCommandStartSyntaxMode,@"start \\ missing before short or continue");
			iTM2_ATTRIBUTE_ASSERT(range.length==1,@"start command too long before short or continu");
			outRangeStart = range.location;
#ifdef iTM2_WITH_SYMBOLS
			goto fullCommand;
#else
			goto returnOutAttributes;
#endif

        case kiTM2TeXGroupOpenSyntaxMode:
			if((range.length==1) && fullMode&kiTM2TeXCommandSyntaxMask)
			{
				iTM2_ATTRIBUTE_ASSERT(outRangeStart>[modeLine startOffset],@"unexpected command mode at the beginning of the line");
				attributes = [self attributesAtIndex:outRangeStart-1 effectiveRange:&range];
				if(aLocation<NSMaxRange(range))
				{
					if(aRangePtr)
					{
						*aRangePtr = range;
					}
					return attributes;
				}
			}
			goto returnOutAttributes;

        case kiTM2TeXRegularSyntaxMode:
			if(fullMode&kiTM2TeXCommandSyntaxMask)
			{
				iTM2_ATTRIBUTE_ASSERT(outRangeStart>[modeLine startOffset],@"unexpected command mode at the beginning of the line");
				[modeLine getSyntaxMode:&fullMode atGlobalLocation:outRangeStart-1 longestRange:&range];
				otherMode = fullMode & ~kiTM2TeXFlagsSyntaxMask;
				if((otherMode == kiTM2TeXGroupOpenSyntaxMode) && (range.length==1))
				{
					attributes = [self attributesAtIndex:outRangeStart-1 effectiveRange:&range];
					if(aLocation<NSMaxRange(range))
					{
						if(aRangePtr)
						{
							*aRangePtr = range;
						}
						return attributes;
					}
				}
			}
			goto returnOutAttributes;

        case kiTM2TeXGroupCloseSyntaxMode:
			if(outRangeStart>[modeLine startOffset])
			{
				[modeLine getSyntaxMode:&fullMode atGlobalLocation:outRangeStart-1 longestRange:&range];
				otherMode = fullMode & ~kiTM2TeXFlagsSyntaxMask;
				if((otherMode == kiTM2TeXRegularSyntaxMode) && fullMode&kiTM2TeXCommandSyntaxMask)
				{
					attributes = [self attributesAtIndex:outRangeStart-1 effectiveRange:&range];
					if(aLocation<NSMaxRange(range))
					{
						if(aRangePtr)
						{
							*aRangePtr = range;
						}
						return attributes;
					}
					outRangeStart = NSMaxRange(range);
				}
			}
			goto returnOutAttributes;

#pragma mark =-=-=-=-=- MATH
		case kiTM2TeXMathSwitchSyntaxMode:
			iTM2_ATTRIBUTE_ASSERT(range.length==1,@"math switch too long");
			if(outRangeStop<[modeLine contentsEndOffset])// the next stuff decides
			{
				[modeLine getSyntaxMode:&otherFullMode atGlobalLocation:outRangeStop longestRange:&range];
				otherMode = otherFullMode & ~kiTM2TeXFlagsSyntaxMask;
				if(otherMode == kiTM2TeXMathSwithContinueSyntaxMode)
				{
					iTM2_ATTRIBUTE_ASSERT(range.length==1,@"math continue too long after switch");
					outRangeStop = NSMaxRange(range);
					outMode = otherMode;
				}
			}
			goto returnOutAttributes;

		case kiTM2TeXMathSwithContinueSyntaxMode:
			iTM2_ATTRIBUTE_ASSERT(range.length==1,@"math switch continue too long");
			iTM2_ATTRIBUTE_ASSERT(outRangeStart>[modeLine startOffset],@"math switch missing before switch");
			[modeLine getSyntaxMode:&otherFullMode atGlobalLocation:outRangeStart-1 longestRange:&range];
			otherMode = otherFullMode & ~kiTM2TeXFlagsSyntaxMask;
			iTM2_ATTRIBUTE_ASSERT(otherMode == kiTM2TeXMathSwitchSyntaxMode,@"math switch expected before switch");
			iTM2_ATTRIBUTE_ASSERT(range.length==1,@"math continue too long after switch");
			outRangeStart = range.location;
			goto returnOutAttributes;

#pragma mark =-=-=-=-=- COMMENTS
        case kiTM2TeXCommentStartSyntaxMode:
            if(aRangePtr)
                * aRangePtr = NSMakeRange(aLocation, [modeLine endOffset]-aLocation);
            if(++aLocation < [modeLine contentsEndOffset])
			{
                return [self attributesAtIndex:aLocation effectiveRange:nil];// this is where the mark attributes are catched
			}
            else
			{
				outModeName = [_iTM2TeXModeForModeArray objectAtIndex:kiTM2TeXCommentContinueSyntaxMode];
                return [_AS attributesForMode:outModeName];
			}

#pragma mark =-=-=-=-=- ACCENTS
        case kiTM2TeXAccentSyntaxMode:
			iTM2_ATTRIBUTE_ASSERT(outRangeStart>[modeLine startOffset],@"missing \\ before command");
			[modeLine getSyntaxMode:&otherFullMode atGlobalLocation:outRangeStart-1 longestRange:&range];
			modeWithoutModifiers = otherFullMode & ~kiTM2TeXFlagsSyntaxMask;
			iTM2_ATTRIBUTE_ASSERT(modeWithoutModifiers==kiTM2TeXCommandStartSyntaxMode,@"start \\ missing before accent");
			iTM2_ATTRIBUTE_ASSERT(range.length==1,@"start command too long before accent");
			outRangeStart = range.location;
			goto returnOutAttributes;

        default:
            iTM2_LOG(@"Someone is asking for mode: %u = %#x (%u = %#x)", fullMode, fullMode, modeWithoutModifiers, modeWithoutModifiers);
//status = [self getSyntaxMode:&mode atIndex:aLocation longestRange:&range];
            goto returnERROR;
    }
returnOutAttributes:
	range.location = outRangeStart;
	range.length = outRangeStop-outRangeStart;
	if(aRangePtr)
	{
		if(aLocation>=NSMaxRange(range))
		{
			range.length = aLocation - range.location;
		}
		*aRangePtr = range;
	}
	outModeName = [_iTM2TeXModeForModeArray objectAtIndex:outMode];
#ifdef iTM2_WITH_SYMBOLS
	if(outMode == kiTM2TeXCommandEscapedCharacterSyntaxMode
		|| outMode == kiTM2TeXCommandContinueSyntaxMode
		|| outMode == kiTM2TeXSubShortSyntaxMode
		|| outMode == kiTM2TeXSuperShortSyntaxMode)
	{
		symbolName = [S substringWithRange:range];// out of range in the extended latex mode
		if(attributes = [_AS attributesForSymbol:symbolName mode:outModeName])
		{
			if(iTM2DebugEnabled>9999)
			{
				iTM2_LOG(@"aLocation:%i, range:%@, symbolName:%@",aLocation,NSStringFromRange(range),symbolName);
			}
			return attributes;
		}
	}
#endif
	if(iTM2DebugEnabled>9999)
	{
		iTM2_LOG(@"aLocation:%i, range:%@, outModeName:%@",aLocation,NSStringFromRange(range),outModeName);
	}
	return [_AS attributesForMode:outModeName];
	
returnERROR:
	// problem
	range.location = [modeLine startOffset];
	range.length = [modeLine contentsEndOffset]-range.location;
	iTM2_LOG(@"***  ERROR: %@ at offset %i in <%@>",
		ERROR,aLocation-range.location,[S substringWithRange:range]);
	range.location = outRangeStart;
	range.length = outRangeStop-outRangeStart;
	if(aRangePtr)
	{
		if(aLocation>=NSMaxRange(range))
		{
			range.length = aLocation - range.location;
		}
		*aRangePtr = range;
	}
	outModeName = [_iTM2TeXModeForModeArray objectAtIndex:kiTM2TeXErrorSyntaxMode];
	return [_AS attributesForMode:outModeName];
}
#if 0
@end
#endif
#undef iTM2_WITH_SYMBOLS
