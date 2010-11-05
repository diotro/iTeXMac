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
#ifndef WITH_SYMBOLS4iTM3
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  getSyntaxMode:forCharacter:previousMode:
- (NSUInteger)getSyntaxMode:(NSUInteger *)newModeRef forCharacter:(unichar)theChar previousMode:(NSUInteger)previousMode;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Dec 12 22:44:56 GMT 2003
To Do List: 
"*/
{DIAGNOSTIC4iTM3;
	NSParameterAssert(newModeRef);
//START4iTM3;
//    if(previousMode != ( previousMode & ~kiTM2TeXFlagsSyntaxMask))
//        NSLog(@"previousMode: 0X%x, mask: 0X%x, previousMode & ~mask: 0X%x",  previousMode, kiTM2TeXErrorSyntaxModeMask,  previousMode & ~kiTM2TeXFlagsSyntaxMask);
//LOG4iTM3(@"C'est %.1S qui s'y colle", &theChar);
	NSUInteger previousError = previousMode & kiTM2TeXErrorSyntaxMask;
	NSUInteger previousModifier = previousMode & kiTM2TeXModifiersSyntaxMask;
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
	NSUInteger previousModeWithoutModifiers = previousMode & ~kiTM2TeXFlagsSyntaxMask;
	NSUInteger newModifier = previousModifier;
	newModifier = previousModifier  & ~kiTM2TeXPlaceholderSyntaxMask;
	newModifier = newModifier  & ~kiTM2TeXCommandSyntaxMask;
	NSUInteger status = kiTM2TeXNoErrorSyntaxStatus;
	NSString * modeString = @"";
	NSUInteger newMode = previousModeWithoutModifiers;
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

	NSCharacterSet * set = [NSCharacterSet TeXLetterCharacterSet4iTM3];
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
		if([iVarAS4iTM3 character:theChar isMemberOfCoveredCharacterSetForMode:modeString])
		{
			* newModeRef = newMode | previousError | newModifier;
			return kiTM2TeXNoErrorSyntaxStatus;
		}
//LOG4iTM3(@"AN ERROR OCCURRED");
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
newMode = [self context4iTM3BoolForKey:@"iTM2MakeAtLetter" domain:iTM2ContextExtendedProjectMask|iTM2ContextPrivateMask]?
	kiTM2TeXCommandContinueSyntaxMode:kiTM2TeXCommandEscapedCharacterSyntaxMode;
newModifier = newModifier | kiTM2TeXCommandSyntaxMask;
status = kiTM2TeXNoErrorSyntaxStatus;
break;
//CAS(kiTM2TeXCommandStartSyntaxMode,			kiTM2TeXCommandEscapedCharacterSyntaxMode,	previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CAS0(kiTM2TeXCommandEscapedCharacterSyntaxMode,	kiTM2TeXRegularSyntaxMode);
case kiTM2TeXCommandContinueSyntaxMode:
if([self context4iTM3BoolForKey:@"iTM2MakeAtLetter" domain:iTM2ContextExtendedProjectMask|iTM2ContextPrivateMask])
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
			if([iVarAS4iTM3 character:theChar isMemberOfCoveredCharacterSetForMode:modeString])
			{
				* newModeRef = newMode | previousError | newModifier;
				return kiTM2TeXNoErrorSyntaxStatus;
			}
			else
			{
//LOG4iTM3(@"AN ERROR OCCURRED");
				* newModeRef = newMode | kiTM2TeXErrorSyntaxMask | previousError | previousModifier;// REVISIT, this has no meaning
				return kiTM2TeXNoErrorSyntaxStatus;
			}
		}
	}
}
#if 1
#include <iTM2Foundation/iTM2Foundation.h>
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  getSyntaxMode:forLocation:previousMode:effectiveLength:nextModeIn:before:
- (NSUInteger)getSyntaxMode:(NSUInteger *)newModeRef forLocation:(NSUInteger)location previousMode:(NSUInteger)previousMode effectiveLength:(NSUInteger *)lengthRef nextModeIn:(NSUInteger *)nextModeRef before:(NSUInteger)beforeIndex;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Dec 12 22:44:56 GMT 2003
To Do List: 
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSParameterAssert(newModeRef);
    NSString * S = [_TextStorage string];
	NSUInteger length = S.length;
    NSParameterAssert(location<length);
	NSString * substring;
	NSRange r;
	NSUInteger status;
//	NSUInteger previousError = previousMode & kiTM2TeXErrorSyntaxMask;
//	NSUInteger previousModifier = previousMode & kiTM2TeXModifiersSyntaxMask;
	NSUInteger previousModeWithoutModifiers = previousMode & ~kiTM2TeXFlagsSyntaxMask;
	unichar theChar = [S characterAtIndex:location];
	NSUInteger start, end;
	ICURegEx * RE = nil;
	if(kiTM2TeXCommandStartSyntaxMode == previousModeWithoutModifiers)
	{
		if((theChar == '`')||(theChar == '\'')||(theChar == '^')||(theChar == '"')||(theChar == '~')
			||(theChar == '=')||(theChar == '.'))
		{
			r.location = location+1;
			r.length = MIN(length-r.location,4);
			RE = [ICURegEx regExWithSearchPattern:@"^\\{(?:.*?\\})?" error:NULL];
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
		NSCharacterSet * set = [NSCharacterSet TeXLetterCharacterSet4iTM3];
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
				r = iTM3MakeRange(start, end-start);
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
		end = iTM3MaxRange(r);
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
		RE = [ICURegEx regExWithSearchPattern:@"@@@\\(|\\)__" error:NULL];
		[RE setInputString:substring];
		while([RE nextMatch])
		{
			r = [RE rangeOfMatch];
			r.location += start;
			if(iTM3LocationInRange(location,r))
			{
				if(lengthRef)
				{
					* lengthRef = iTM3MaxRange(r)-location;
				}
				if(nextModeRef)
				{
					* nextModeRef = kiTM2TeXUnknownSyntaxMode;
				}
				* newModeRef = kiTM2TeXPlaceholderDelimiterMode;
				return kiTM2TeXNoErrorSyntaxStatus;
			}
			start = iTM3MaxRange(r);
		}
	}
	else if(((theChar == '(') && (location>2))
			||((theChar == ')') && (location+3<S.length)))
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
			beforeIndex = MIN(beforeIndex, S.length);
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
- (NSUInteger)getSyntaxMode:(NSUInteger *)nextModeRef forLocation:(NSUInteger)location previousMode:(NSUInteger)previousMode effectiveLength:(NSUInteger *)lengthRef nextModeIn:(NSUInteger *)nextModeRef before:(NSUInteger)beforeIndex;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Dec 12 22:44:56 GMT 2003
To Do List: 
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSParameterAssert(nextModeRef);
    NSString * S = [_TextStorage string];
	unichar theChar;
    if(location<S.length)
    {
        if(lengthRef)
        {
            * lengthRef = 1;
			theChar = [S characterAtIndex:location];
            NSUInteger nextMode = [self getSyntaxMode:&newMode forCharacter:theChar previousMode:previousMode];
//NSLog(@"0: character: %@", [NSString stringWithCharacters: &C length:1]);
//NSLog(@"1: nextMode: %u, previousMode: %u", nextMode, previousMode);
            beforeIndex = MIN(beforeIndex, S.length);
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
                * nextModeRef = ZER0;
            return nextMode;
        }
        else
        {
            if(nextModeRef)
                * nextModeRef = ZER0;
			theChar = [S characterAtIndex:location];
            NSUInteger nextMode = [self getSyntaxMode:&newMode forCharacter:theChar previousMode:previousMode];
//NSLog(@"nextMode: %u, previousMode: %u", nextMode, previousMode);
            return nextMode;
        }
    }
    else
    {
//LOG4iTM3(@"location: %i <=  S.length %i", location, S.length);
        if(lengthRef)
            * lengthRef = ZER0;
        return [self EOLModeForPreviousMode:previousMode];
    }
}
#endif
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  EOLModeForPreviousMode:
- (NSUInteger)EOLModeForPreviousMode:(NSUInteger)previousMode;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Dec 12 22:44:56 GMT 2003
To Do List: 
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
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
	NSUInteger previousFlags = previousMode & kiTM2TeXFlagsSyntaxMask;
	
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
- (NSDictionary *)attributesAtIndex:(NSUInteger)aLocation effectiveRange:(NSRangePointer)aRangePtr;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	// we manage at the same time the attributes with or without symbols
	// the symbol variant adds more tests
	NSUInteger fullMode;
    NSUInteger lineIndex = [self lineIndexForLocation4iTM3:aLocation];
    iTM2ModeLine * modeLine = [self modeLineAtIndex:lineIndex];
	NSRange range;
 	[modeLine getSyntaxMode:&fullMode atGlobalLocation:aLocation longestRange:&range];
    if(aRangePtr)
	{
		*aRangePtr = range;
	}
	NSUInteger modeWithoutModifiers = fullMode & ~kiTM2TeXFlagsSyntaxMask;
	
	NSString * S = [_TextStorage string];

	// when the attributes are properly set, go to returnOutAttributes
	// it will take care of the return for you
	NSUInteger outRangeStart = range.location;
	NSUInteger outRangeStop = iTM3MaxRange(range);
	NSUInteger outMode = modeWithoutModifiers;
	NSString * outModeName;

	// auxiliary
	NSUInteger otherMode = kiTM2TeXUnknownSyntaxMode;
	NSUInteger otherFullMode = kiTM2TeXUnknownSyntaxMode;
	
	NSDictionary * attributes;
	
	// this is used in the ATTRIBUTE_ASSERT4iTM3 macro
	NSString * ERROR = @"UNKNOWN ERROR";
	
#ifdef WITH_SYMBOLS4iTM3
	NSString * symbolName;// the real string corresponding to the symbol
	NSUInteger symbolRangeStart = outRangeStart;// not yet complete
	NSUInteger symbolRangeStop = outRangeStop;// not yet complete
	NSUInteger symbolMode = modeWithoutModifiers;

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
		symbolRangeStop = iTM3MaxRange(range);// not yet complete
		// range is free now
testStartSimpleGroup:
		if(symbolRangeStart>modeLine.startOff7+1)
		{
			// there are 2 characters before, enough for '^{' for example
			// testing for '{'
			[modeLine getSyntaxMode:&otherFullMode atGlobalLocation:--symbolRangeStart longestRange:&range];
			otherMode = otherFullMode & ~kiTM2TeXFlagsSyntaxMask;
			ATTRIBUTE_ASSERT4iTM3(otherMode == kiTM2TeXGroupOpenSyntaxMode,@"Missing '{' before simple group");
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
					ATTRIBUTE_ASSERT4iTM3(symbolRangeStart>modeLine.startOff7,@"No room for a \\ before a command name (no char given)");
					[modeLine getSyntaxMode:&otherFullMode atGlobalLocation:--symbolRangeStart longestRange:&range];
					otherMode = otherFullMode & ~kiTM2TeXFlagsSyntaxMask;
					ATTRIBUTE_ASSERT4iTM3(otherMode == kiTM2TeXCommandStartSyntaxMode,@"Missing \\ before a command name(missing char)");
					// symbolRangeStart is now complete
closingSimpleGroup:
					// may be the input string is not complete and the closing '}' was not yet entered
					if(symbolRangeStop<[modeLine contentsEndOff7])
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
							if(attributes = [iVarAS4iTM3 attributesForSymbol:symbolName mode:outModeName])
							{
								if(aRangePtr)
								{
									*aRangePtr=range;
								}
								DEBUGLOG4iTM3(9999,@"aLocation:%i, range:%@, symbolName:%@",aLocation,NSStringFromRange(range),symbolName);
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
		if(symbolRangeStop<[modeLine contentsEndOff7])
		{
			range = [modeLine longestRangeAtGlobalLocation:symbolRangeStop mask:kiTM2TeXSimpleGroupSyntaxMask];
			if(range.length)
			{
				symbolRangeStop = iTM3MaxRange(range);
				if(symbolRangeStart>modeLine.startOff7)
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
			if(symbolRangeStart>modeLine.startOff7+1)
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
		if(symbolRangeStop+2<[modeLine contentsEndOff7])//room for 3 chars: '{.}'
		{
			range = [modeLine longestRangeAtGlobalLocation:symbolRangeStop+1 mask:kiTM2TeXSimpleGroupSyntaxMask];
			if(range.length)
			{
				symbolRangeStop = iTM3MaxRange(range);
				goto closingSimpleGroup;
			}
		}
	}
	else if(modeWithoutModifiers == kiTM2TeXAccentSyntaxMode)
	{
		ATTRIBUTE_ASSERT4iTM3(symbolRangeStart>modeLine.startOff7,@"No room for a '\\' when expected...");
		--symbolRangeStart;
		symbolMode = kiTM2TeXAccentSyntaxMode;
		goto tryToConclude;
	}
	else if((modeWithoutModifiers == kiTM2TeXCommandEscapedCharacterSyntaxMode)
				|| (modeWithoutModifiers == kiTM2TeXCommandContinueSyntaxMode)
				|| (modeWithoutModifiers == kiTM2TeXCommandInputSyntaxMode) )
	{
		ATTRIBUTE_ASSERT4iTM3(symbolRangeStart>modeLine.startOff7,@"No room for a '\\' when expected...");
		--symbolRangeStart;
		if(symbolRangeStop+2<[modeLine contentsEndOff7])//room for 3 chars '{.}'
		{
			range = [modeLine longestRangeAtGlobalLocation:symbolRangeStop+1 mask:kiTM2TeXSimpleGroupSyntaxMask];
			if(range.length)
			{
				symbolRangeStop = iTM3MaxRange(range);
				goto closingSimpleGroup;
			}
		}
	}
	else if(modeWithoutModifiers == kiTM2TeXCommandStartSyntaxMode)
	{
		ATTRIBUTE_ASSERT4iTM3(symbolRangeStart>modeLine.startOff7,@"No room for a '\\' when expected...");
		if(symbolRangeStop+3<[modeLine contentsEndOff7])//room for 4 chars '.{.}'
		{
			[modeLine getSyntaxMode:&otherFullMode atGlobalLocation:symbolRangeStop longestRange:&range];
			symbolMode = otherFullMode & ~kiTM2TeXFlagsSyntaxMask;
			if((symbolMode == kiTM2TeXCommandEscapedCharacterSyntaxMode)
				|| (symbolMode == kiTM2TeXCommandContinueSyntaxMode)
				|| (symbolMode == kiTM2TeXCommandInputSyntaxMode) )
			{
				symbolRangeStop = iTM3MaxRange(range);
				if(symbolRangeStop+2<[modeLine contentsEndOff7])//room for 3 chars '{.}'
				{
					range = [modeLine longestRangeAtGlobalLocation:symbolRangeStop+1 mask:kiTM2TeXSimpleGroupSyntaxMask];
					if(range.length)
					{
						symbolRangeStop = iTM3MaxRange(range);
						goto closingSimpleGroup;
					}
				}
			}
			else if(symbolMode == kiTM2TeXAccentSyntaxMode)
			{
				symbolRangeStop = iTM3MaxRange(range);
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
			ATTRIBUTE_ASSERT4iTM3(range.length == 1,@"too much starting ^");
			if(outRangeStop<[modeLine contentsEndOff7])
			{
				[self getSyntaxMode:&otherFullMode atIndex:outRangeStop longestRange:&range];
				otherMode = otherFullMode & ~kiTM2TeXFlagsSyntaxMask;
				if(otherMode == kiTM2TeXSuperShortSyntaxMode)
				{
					ATTRIBUTE_ASSERT4iTM3(range.length == 1,@"too much short ^ after start");
					outRangeStop = iTM3MaxRange(range);
					outMode = otherMode;
				}
				else if(otherMode == kiTM2TeXSuperContinueSyntaxMode)
				{
					outRangeStop = iTM3MaxRange(range);
					outMode = otherMode;
					if(outRangeStop<[modeLine contentsEndOff7])
					{
						[self getSyntaxMode:&otherFullMode atIndex:outRangeStop longestRange:&range];
						otherMode = otherFullMode & ~kiTM2TeXFlagsSyntaxMask;
						if(otherMode == kiTM2TeXSuperShortSyntaxMode)
						{
							ATTRIBUTE_ASSERT4iTM3(range.length == 1,@"too much short ^ after continue after start");
							outRangeStop = iTM3MaxRange(range);
							// NO: outMode = otherMode;
						}
					}
				}
			}
			goto returnOutAttributes;

		case kiTM2TeXSuperShortSyntaxMode:
			ATTRIBUTE_ASSERT4iTM3(range.length == 1,@"too much short ^ (second)");
			ATTRIBUTE_ASSERT4iTM3(outRangeStart>modeLine.startOff7,@"missing start ^ before short");
			[self getSyntaxMode:&otherFullMode atIndex:outRangeStart-1 longestRange:&range];
			otherMode = otherFullMode & ~kiTM2TeXFlagsSyntaxMask;
			if(otherMode == kiTM2TeXSuperStartSyntaxMode)
			{
				ATTRIBUTE_ASSERT4iTM3(range.length == 1,@"too much starting ^ before short");
			}
			else if(otherMode == kiTM2TeXSuperContinueSyntaxMode)
			{
				ATTRIBUTE_ASSERT4iTM3(range.length == 1,@"too much continue ^ before short");
				outRangeStart = range.location;
				ATTRIBUTE_ASSERT4iTM3(outRangeStart>modeLine.startOff7,@"missing start ^ before continuous before short");
				outMode = otherMode;
			}
			else
			{
				ATTRIBUTE_ASSERT4iTM3(NO,@"expected ^ missing before short");
			}
			outRangeStart = range.location;
			goto returnOutAttributes;

		case kiTM2TeXSuperContinueSyntaxMode:
			ATTRIBUTE_ASSERT4iTM3(range.length == 1,@"too much short ^ continue");
			ATTRIBUTE_ASSERT4iTM3(outRangeStart>modeLine.startOff7,@"missing start ^ before short");
			[self getSyntaxMode:&otherFullMode atIndex:outRangeStart-1 longestRange:&range];
			otherMode = otherFullMode & ~kiTM2TeXFlagsSyntaxMask;
			ATTRIBUTE_ASSERT4iTM3(otherMode == kiTM2TeXSuperStartSyntaxMode,@"expected ^ missing before short");
			ATTRIBUTE_ASSERT4iTM3(range.length == 1,@"too much starting ^ (second)");
			outRangeStart = range.location;
			if(outRangeStop==[modeLine contentsEndOff7])
			{
				[self getSyntaxMode:&otherFullMode atIndex:outRangeStart-1 longestRange:&range];
				otherMode = otherFullMode & ~kiTM2TeXFlagsSyntaxMask;
				if(otherMode == kiTM2TeXSuperShortSyntaxMode)
				{
					ATTRIBUTE_ASSERT4iTM3(range.length == 1,@"too much short ^ after continue");
					outRangeStop == iTM3MaxRange(range);
				}
			}
			goto returnOutAttributes;

#pragma mark =-=-=-=-=-  SUB
        case kiTM2TeXSubStartSyntaxMode:
			ATTRIBUTE_ASSERT4iTM3(range.length == 1,@"too much start _");
			if(outRangeStop<[modeLine contentsEndOff7])
			{
				[self getSyntaxMode:&otherFullMode atIndex:outRangeStop longestRange:&range];
				otherMode = otherFullMode & ~kiTM2TeXFlagsSyntaxMask;
				if(otherMode == kiTM2TeXSubShortSyntaxMode)
				{
					ATTRIBUTE_ASSERT4iTM3(range.length == 1,@"too much short _ after start");
					outRangeStop = iTM3MaxRange(range);
					outMode = otherMode;
				}
			}
			goto returnOutAttributes;

		case kiTM2TeXSubShortSyntaxMode:
			ATTRIBUTE_ASSERT4iTM3(range.length == 1,@"too much short _");
			ATTRIBUTE_ASSERT4iTM3(outRangeStart>modeLine.startOff7,@"missing start _ before short");
			[self getSyntaxMode:&otherFullMode atIndex:outRangeStart-1 longestRange:&range];
			otherMode = otherFullMode & ~kiTM2TeXFlagsSyntaxMask;
			ATTRIBUTE_ASSERT4iTM3(otherMode == kiTM2TeXSubStartSyntaxMode,@"expected _ missing before short");
			outRangeStart = range.location;
			goto returnOutAttributes;

#pragma mark =-=-=-=-=- COMMAND
        case kiTM2TeXCommandStartSyntaxMode:
			ATTRIBUTE_ASSERT4iTM3(range.length==1,@"start command too big");
			if(outRangeStop==[modeLine contentsEndOff7])
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
				outRangeStop = iTM3MaxRange(range);
				outMode = kiTM2TeXSuperShortSyntaxMode;
			}
			else if((otherMode == kiTM2TeXCommandEscapedCharacterSyntaxMode)
				|| (otherMode == kiTM2TeXCommandContinueSyntaxMode)
				|| (otherMode == kiTM2TeXAccentSyntaxMode))
			{
				outMode = otherMode;
				outRangeStop = iTM3MaxRange(range);
#ifdef WITH_SYMBOLS4iTM3
fullCommand:
				// something like '\foo{blah}'
				if(outRangeStop+2>=[modeLine contentsEndOff7])
				{
					goto returnOutAttributes;
				}
				[modeLine getSyntaxMode:&otherFullMode atGlobalLocation:outRangeStop longestRange:&range];
				otherMode = otherFullMode & ~kiTM2TeXFlagsSyntaxMask;
				if((otherMode != kiTM2TeXGroupOpenSyntaxMode) || (range.length>1))
				{
					goto returnOutAttributes;
				}
				range.location = iTM3MaxRange(range);
				if(range.location>=[modeLine contentsEndOff7])
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
//				ATTRIBUTE_ASSERT4iTM3(otherFullMode&kiTM2TeXCommandSyntaxMask,@"This should be command tagged after {");
				range.location = iTM3MaxRange(range);
				if(range.location>=[modeLine contentsEndOff7])
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
					if(aLocation>=iTM3MaxRange(range))
					{
						range.length = aLocation - range.location;
					}
					*aRangePtr = range;
				}
				symbolName = [S substringWithRange:range];
				if(attributes = [iVarAS4iTM3 attributesForSymbol:symbolName mode:nil])
				{
//LOG4iTM3(@"aLocation:%i, range:%@, symbolName:%@",aLocation,NSStringFromRange(range),symbolName);
					return attributes;
				}
#endif
			}
			else if((otherMode == kiTM2TeXMathInlineBeginSyntaxMode)
				|| (otherMode == kiTM2TeXMathInlineEndSyntaxMode)
				|| (otherMode == kiTM2TeXMathDisplayBeginSyntaxMode)
				|| (otherMode == kiTM2TeXMathDisplayEndSyntaxMode))
			{
				outRangeStop = iTM3MaxRange(range);
				outMode = otherMode;
			}
			goto returnOutAttributes;

        case kiTM2TeXCommandEscapedCharacterSyntaxMode:
			ATTRIBUTE_ASSERT4iTM3(range.length==1,@"short command too long");
        case kiTM2TeXCommandContinueSyntaxMode:
			ATTRIBUTE_ASSERT4iTM3(outRangeStart>modeLine.startOff7,@"missing \\ before command");
			[modeLine getSyntaxMode:&otherFullMode atGlobalLocation:outRangeStart-1 longestRange:&range];
			otherMode = otherFullMode & ~kiTM2TeXFlagsSyntaxMask;
			ATTRIBUTE_ASSERT4iTM3(otherMode==kiTM2TeXCommandStartSyntaxMode,@"start \\ missing before short or continue");
			ATTRIBUTE_ASSERT4iTM3(range.length==1,@"start command too long before short or continu");
			outRangeStart = range.location;
#ifdef WITH_SYMBOLS4iTM3
			goto fullCommand;
#else
			goto returnOutAttributes;
#endif

        case kiTM2TeXGroupOpenSyntaxMode:
			if((range.length==1) && fullMode&kiTM2TeXCommandSyntaxMask)
			{
				ATTRIBUTE_ASSERT4iTM3(outRangeStart>modeLine.startOff7,@"unexpected command mode at the beginning of the line");
				attributes = [self attributesAtIndex:outRangeStart-1 effectiveRange:&range];
				if(aLocation<iTM3MaxRange(range))
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
				ATTRIBUTE_ASSERT4iTM3(outRangeStart>modeLine.startOff7,@"unexpected command mode at the beginning of the line");
				[modeLine getSyntaxMode:&fullMode atGlobalLocation:outRangeStart-1 longestRange:&range];
				otherMode = fullMode & ~kiTM2TeXFlagsSyntaxMask;
				if((otherMode == kiTM2TeXGroupOpenSyntaxMode) && (range.length==1))
				{
					attributes = [self attributesAtIndex:outRangeStart-1 effectiveRange:&range];
					if(aLocation<iTM3MaxRange(range))
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
			if(outRangeStart>modeLine.startOff7)
			{
				[modeLine getSyntaxMode:&fullMode atGlobalLocation:outRangeStart-1 longestRange:&range];
				otherMode = fullMode & ~kiTM2TeXFlagsSyntaxMask;
				if((otherMode == kiTM2TeXRegularSyntaxMode) && fullMode&kiTM2TeXCommandSyntaxMask)
				{
					attributes = [self attributesAtIndex:outRangeStart-1 effectiveRange:&range];
					if(aLocation<iTM3MaxRange(range))
					{
						if(aRangePtr)
						{
							*aRangePtr = range;
						}
						return attributes;
					}
					outRangeStart = iTM3MaxRange(range);
				}
			}
			goto returnOutAttributes;

#pragma mark =-=-=-=-=- MATH
		case kiTM2TeXMathSwitchSyntaxMode:
			ATTRIBUTE_ASSERT4iTM3(range.length==1,@"math switch too long");
			if(outRangeStop<[modeLine contentsEndOff7])// the next stuff decides
			{
				[modeLine getSyntaxMode:&otherFullMode atGlobalLocation:outRangeStop longestRange:&range];
				otherMode = otherFullMode & ~kiTM2TeXFlagsSyntaxMask;
				if(otherMode == kiTM2TeXMathSwithContinueSyntaxMode)
				{
					ATTRIBUTE_ASSERT4iTM3(range.length==1,@"math continue too long after switch");
					outRangeStop = iTM3MaxRange(range);
					outMode = otherMode;
				}
			}
			goto returnOutAttributes;

		case kiTM2TeXMathSwithContinueSyntaxMode:
			ATTRIBUTE_ASSERT4iTM3(range.length==1,@"math switch continue too long");
			ATTRIBUTE_ASSERT4iTM3(outRangeStart>modeLine.startOff7,@"math switch missing before switch");
			[modeLine getSyntaxMode:&otherFullMode atGlobalLocation:outRangeStart-1 longestRange:&range];
			otherMode = otherFullMode & ~kiTM2TeXFlagsSyntaxMask;
			ATTRIBUTE_ASSERT4iTM3(otherMode == kiTM2TeXMathSwitchSyntaxMode,@"math switch expected before switch");
			ATTRIBUTE_ASSERT4iTM3(range.length==1,@"math continue too long after switch");
			outRangeStart = range.location;
			goto returnOutAttributes;

#pragma mark =-=-=-=-=- COMMENTS
        case kiTM2TeXCommentStartSyntaxMode:
            if(aRangePtr)
                * aRangePtr = iTM3MakeRange(aLocation, modeLine.endOff7-aLocation);
            if(++aLocation < [modeLine contentsEndOff7])
			{
                return [self attributesAtIndex:aLocation effectiveRange:nil];// this is where the mark attributes are catched
			}
            else
			{
				outModeName = [_iTM2TeXModeForModeArray objectAtIndex:kiTM2TeXCommentContinueSyntaxMode];
                return [iVarAS4iTM3 attributesForMode:outModeName];
			}

#pragma mark =-=-=-=-=- ACCENTS
        case kiTM2TeXAccentSyntaxMode:
			ATTRIBUTE_ASSERT4iTM3(outRangeStart>modeLine.startOff7,@"missing \\ before command");
			[modeLine getSyntaxMode:&otherFullMode atGlobalLocation:outRangeStart-1 longestRange:&range];
			modeWithoutModifiers = otherFullMode & ~kiTM2TeXFlagsSyntaxMask;
			ATTRIBUTE_ASSERT4iTM3(modeWithoutModifiers==kiTM2TeXCommandStartSyntaxMode,@"start \\ missing before accent");
			ATTRIBUTE_ASSERT4iTM3(range.length==1,@"start command too long before accent");
			outRangeStart = range.location;
			goto returnOutAttributes;

        default:
            LOG4iTM3(@"Someone is asking for mode: %u = %#x (%u = %#x)", fullMode, fullMode, modeWithoutModifiers, modeWithoutModifiers);
//status = [self getSyntaxMode:&mode atIndex:aLocation longestRange:&range];
            goto returnERROR;
    }
returnOutAttributes:
	range.location = outRangeStart;
	range.length = outRangeStop-outRangeStart;
	if(aRangePtr)
	{
		if(aLocation>=iTM3MaxRange(range))
		{
			range.length = aLocation - range.location;
		}
		*aRangePtr = range;
	}
	outModeName = [_iTM2TeXModeForModeArray objectAtIndex:outMode];
#ifdef WITH_SYMBOLS4iTM3
	if(outMode == kiTM2TeXCommandEscapedCharacterSyntaxMode
		|| outMode == kiTM2TeXCommandContinueSyntaxMode
		|| outMode == kiTM2TeXSubShortSyntaxMode
		|| outMode == kiTM2TeXSuperShortSyntaxMode)
	{
		symbolName = [S substringWithRange:range];// out of range in the extended latex mode
		if ((attributes = [iVarAS4iTM3 attributesForSymbol:symbolName mode:outModeName])) {
			DEBUGLOG4iTM3(9999,@"aLocation:%i, range:%@, symbolName:%@",aLocation,NSStringFromRange(range),symbolName);
			return attributes;
		}
	}
#endif
	DEBUGLOG4iTM3(9999,@"aLocation:%i, range:%@, outModeName:%@",aLocation,NSStringFromRange(range),outModeName);
	return [iVarAS4iTM3 attributesForMode:outModeName];
	
returnERROR:
	// problem
	range.location = modeLine.startOff7;
	range.length = [modeLine contentsEndOff7]-range.location;
	LOG4iTM3(@"***  ERROR: %@ at offset %i in <%@>",
		ERROR,aLocation-range.location,[S substringWithRange:range]);
	range.location = outRangeStart;
	range.length = outRangeStop-outRangeStart;
	if(aRangePtr)
	{
		if(aLocation>=iTM3MaxRange(range))
		{
			range.length = aLocation - range.location;
		}
		*aRangePtr = range;
	}
	outModeName = [_iTM2TeXModeForModeArray objectAtIndex:kiTM2TeXErrorSyntaxMode];
	return [iVarAS4iTM3 attributesForMode:outModeName];
}
#if 0
@end
#endif
#undef WITH_SYMBOLS4iTM3
