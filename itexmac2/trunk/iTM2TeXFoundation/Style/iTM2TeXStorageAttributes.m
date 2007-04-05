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
#if 0
@implementation iTM2TeXParser
#endif
#pragma mark =-=-=-=-=-  iTM2TeXParser:
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
	NSCharacterSet * set = [NSCharacterSet TeXLetterCharacterSet];
	unsigned status = kiTM2TeXNoErrorSyntaxStatus;
	NSString * modeString = @"";
	unsigned newMode;
#if 0
CASE(kiTM2TeXWhitePrefixSyntaxMode,				previousModeWithoutModifiers,	previousModifier);
CASE(kiTM2TeXRegularSyntaxMode,					previousModeWithoutModifiers,	previousModifier);
CASE(kiTM2TeXCommandStartSyntaxMode,			previousModeWithoutModifiers,	previousModifier);
CASE(kiTM2TeXCommandEscapedCharacterSyntaxMode,	previousModeWithoutModifiers,	previousModifier);
CASE(kiTM2TeXCommandContinueSyntaxMode,			previousModeWithoutModifiers,	previousModifier);
CASE(kiTM2TeXCommandInputSyntaxMode,			previousModeWithoutModifiers,	previousModifier);
CASE(kiTM2TeXGroupOpenSyntaxMode,				previousModeWithoutModifiers,	previousModifier);
CASE(kiTM2TeXGroupCloseSyntaxMode,				previousModeWithoutModifiers,	previousModifier);
CASE(kiTM2TeXParenOpenSyntaxMode,				previousModeWithoutModifiers,	previousModifier);
CASE(kiTM2TeXParenCloseSyntaxMode,				previousModeWithoutModifiers,	previousModifier);
CASE(kiTM2TeXBracketOpenSyntaxMode,				previousModeWithoutModifiers,	previousModifier);
CASE(kiTM2TeXBracketCloseSyntaxMode,			previousModeWithoutModifiers,	previousModifier);
CASE(kiTM2TeXCommentStartSyntaxMode,			previousModeWithoutModifiers,	previousModifier);
CASE(kiTM2TeXCommentContinueSyntaxMode,			previousModeWithoutModifiers,	previousModifier);
CASE(kiTM2TeXMarkSyntaxMode,					previousModeWithoutModifiers,	previousModifier);
CASE(kiTM2TeXMarkContinueSyntaxMode,			previousModeWithoutModifiers,	previousModifier);
CASE(kiTM2TeXMathSwitchSyntaxMode,				previousModeWithoutModifiers,	previousModifier);
CASE(kiTM2TeXMathSwithContinueSyntaxMode,		previousModeWithoutModifiers,	previousModifier);
CASE(kiTM2TeXMathInlineBeginSyntaxMode,			previousModeWithoutModifiers,	previousModifier);
CASE(kiTM2TeXMathInlineEndSyntaxMode,			previousModeWithoutModifiers,	previousModifier);
CASE(kiTM2TeXMathDisplayBeginSyntaxMode,		previousModeWithoutModifiers,	previousModifier);
CASE(kiTM2TeXMathDisplayEndSyntaxMode,			previousModeWithoutModifiers,	previousModifier);
CASE(kiTM2TeXSubStartSyntaxMode,				previousModeWithoutModifiers,	previousModifier);
CASE(kiTM2TeXSubShortSyntaxMode,				previousModeWithoutModifiers,	previousModifier);
CASE(kiTM2TeXSubscriptSyntaxMode,				previousModeWithoutModifiers,	previousModifier);
CASE(kiTM2TeXSuperStartSyntaxMode,				previousModeWithoutModifiers,	previousModifier);
CASE(kiTM2TeXSuperContinueSyntaxMode,			previousModeWithoutModifiers,	previousModifier);
CASE(kiTM2TeXSuperShortSyntaxMode,				previousModeWithoutModifiers,	previousModifier);
CASE(kiTM2TeXSuperscriptSyntaxMode,				previousModeWithoutModifiers,	previousModifier);
CASE(kiTM2TeXCellSeparatorSyntaxMode,			previousModeWithoutModifiers,	previousModifier);
CASE(kiTM2TeXUnknownSyntaxMode,					previousModeWithoutModifiers,	previousModifier);
CASE(kiTM2TeXErrorSyntaxMode,					previousModeWithoutModifiers,	previousModifier);
			default:
				newMode = previousModeWithoutModifiers;
				newModifier = previousModifier;
				break;
#endif
#undef CASE
#define CASE(OLDMODE,NEWMODE,NEWMODIFIER)\
case OLDMODE: newMode = NEWMODE; newModifier = NEWMODIFIER;	break

    if([set characterIsMember:theChar])
    {
        switch(previousModeWithoutModifiers)
        {
CASE(kiTM2TeXWhitePrefixSyntaxMode,				kiTM2TeXRegularSyntaxMode,			previousModifier);
CASE(kiTM2TeXRegularSyntaxMode,					previousModeWithoutModifiers,		previousModifier);
CASE(kiTM2TeXCommandStartSyntaxMode,			kiTM2TeXCommandContinueSyntaxMode,	previousModifier | kiTM2TeXCommandSyntaxMask);
CASE(kiTM2TeXCommandEscapedCharacterSyntaxMode,	kiTM2TeXRegularSyntaxMode,			previousModifier);
CASE(kiTM2TeXCommandContinueSyntaxMode,			previousModeWithoutModifiers,		previousModifier);
CASE(kiTM2TeXCommandInputSyntaxMode,			previousModeWithoutModifiers,		previousModifier & ~kiTM2TeXCommandSyntaxMask);
CASE(kiTM2TeXGroupOpenSyntaxMode,				kiTM2TeXRegularSyntaxMode,			previousModifier);
CASE(kiTM2TeXGroupCloseSyntaxMode,				kiTM2TeXRegularSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask);
CASE(kiTM2TeXParenOpenSyntaxMode,				kiTM2TeXRegularSyntaxMode,			previousModifier);
CASE(kiTM2TeXParenCloseSyntaxMode,				kiTM2TeXRegularSyntaxMode,			previousModifier);
CASE(kiTM2TeXBracketOpenSyntaxMode,				kiTM2TeXRegularSyntaxMode,			previousModifier);
CASE(kiTM2TeXBracketCloseSyntaxMode,			kiTM2TeXRegularSyntaxMode,			previousModifier);
CASE(kiTM2TeXCommentStartSyntaxMode,			kiTM2TeXCommentContinueSyntaxMode,	previousModifier);
CASE(kiTM2TeXCommentContinueSyntaxMode,			previousModeWithoutModifiers,		previousModifier);
CASE(kiTM2TeXMarkSyntaxMode,					kiTM2TeXMarkContinueSyntaxMode,		previousModifier);
CASE(kiTM2TeXMarkContinueSyntaxMode,			previousModeWithoutModifiers,		previousModifier);
CASE(kiTM2TeXMathSwitchSyntaxMode,				kiTM2TeXRegularSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask);
CASE(kiTM2TeXMathSwithContinueSyntaxMode,		kiTM2TeXRegularSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask);
CASE(kiTM2TeXMathInlineBeginSyntaxMode,			kiTM2TeXRegularSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask);
CASE(kiTM2TeXMathInlineEndSyntaxMode,			kiTM2TeXRegularSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask);
CASE(kiTM2TeXMathDisplayBeginSyntaxMode,		kiTM2TeXRegularSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask);
CASE(kiTM2TeXMathDisplayEndSyntaxMode,			kiTM2TeXRegularSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask);
CASE(kiTM2TeXSubStartSyntaxMode,				kiTM2TeXSubShortSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask);
CASE(kiTM2TeXSubShortSyntaxMode,				kiTM2TeXRegularSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask);
CASE(kiTM2TeXSubscriptSyntaxMode,				kiTM2TeXRegularSyntaxMode,			previousModifier);
CASE(kiTM2TeXSuperStartSyntaxMode,				kiTM2TeXSuperShortSyntaxMode,		previousModifier);
CASE(kiTM2TeXSuperContinueSyntaxMode,			kiTM2TeXSuperShortSyntaxMode,		previousModifier);
CASE(kiTM2TeXSuperShortSyntaxMode,				kiTM2TeXRegularSyntaxMode,			previousModifier);
CASE(kiTM2TeXSuperscriptSyntaxMode,				kiTM2TeXRegularSyntaxMode,			previousModifier);
CASE(kiTM2TeXCellSeparatorSyntaxMode,			kiTM2TeXRegularSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask);
CASE(kiTM2TeXUnknownSyntaxMode,					previousModeWithoutModifiers,		previousModifier);
CASE(kiTM2TeXErrorSyntaxMode,					previousModeWithoutModifiers,		previousModifier);
			default:
				newMode = previousModeWithoutModifiers;
				newModifier = previousModifier;
				break;
        }
		modeString = [_iTM2TeXModeForModeArray objectAtIndex:newMode];
		if([_AS character:theChar isMemberOfCoveredCharacterSetForMode:modeString])
		{
			* newModeRef = newMode | previousError | newModifier;
			return kiTM2TeXNoErrorSyntaxStatus;
		}
		else
		{
//iTM2_LOG(@"AN ERROR OCCURRED");
			* newModeRef = newMode | kiTM2TeXErrorFontSyntaxMask | previousError;
			return kiTM2TeXNoErrorSyntaxStatus;
		}
    }
    else
    {
        switch(theChar)
        {
            case ' ':
                switch(previousModeWithoutModifiers)
                {
CASE(kiTM2TeXWhitePrefixSyntaxMode,				previousModeWithoutModifiers,				previousModifier & ~kiTM2TeXCommandSyntaxMask);
CASE(kiTM2TeXRegularSyntaxMode,					previousModeWithoutModifiers,				previousModifier & ~kiTM2TeXCommandSyntaxMask);
CASE(kiTM2TeXCommandStartSyntaxMode,			kiTM2TeXCommandEscapedCharacterSyntaxMode,	previousModifier & ~kiTM2TeXCommandSyntaxMask);
CASE(kiTM2TeXCommandEscapedCharacterSyntaxMode,	kiTM2TeXRegularSyntaxMode,					previousModifier & ~kiTM2TeXCommandSyntaxMask);
CASE(kiTM2TeXCommandContinueSyntaxMode,			kiTM2TeXRegularSyntaxMode,					previousModifier & ~kiTM2TeXCommandSyntaxMask);
CASE(kiTM2TeXCommandInputSyntaxMode,			kiTM2TeXRegularSyntaxMode,					previousModifier & ~kiTM2TeXCommandSyntaxMask);
CASE(kiTM2TeXGroupOpenSyntaxMode,				kiTM2TeXRegularSyntaxMode,					previousModifier & ~kiTM2TeXCommandSyntaxMask);
CASE(kiTM2TeXGroupCloseSyntaxMode,				kiTM2TeXRegularSyntaxMode,					previousModifier & ~kiTM2TeXCommandSyntaxMask);
CASE(kiTM2TeXParenOpenSyntaxMode,				kiTM2TeXRegularSyntaxMode,					previousModifier & ~kiTM2TeXCommandSyntaxMask);
CASE(kiTM2TeXParenCloseSyntaxMode,				kiTM2TeXRegularSyntaxMode,					previousModifier & ~kiTM2TeXCommandSyntaxMask);
CASE(kiTM2TeXBracketOpenSyntaxMode,				kiTM2TeXRegularSyntaxMode,					previousModifier & ~kiTM2TeXCommandSyntaxMask);
CASE(kiTM2TeXBracketCloseSyntaxMode,			kiTM2TeXRegularSyntaxMode,					previousModifier & ~kiTM2TeXCommandSyntaxMask);
CASE(kiTM2TeXCommentStartSyntaxMode,			kiTM2TeXCommentContinueSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask);
CASE(kiTM2TeXCommentContinueSyntaxMode,			previousModeWithoutModifiers,				previousModifier & ~kiTM2TeXCommandSyntaxMask);
CASE(kiTM2TeXMarkSyntaxMode,					kiTM2TeXMarkContinueSyntaxMode,				previousModifier & ~kiTM2TeXCommandSyntaxMask);
CASE(kiTM2TeXMarkContinueSyntaxMode,			previousModeWithoutModifiers,				previousModifier & ~kiTM2TeXCommandSyntaxMask);
CASE(kiTM2TeXMathSwitchSyntaxMode,				kiTM2TeXRegularSyntaxMode,					previousModifier & ~kiTM2TeXCommandSyntaxMask);
CASE(kiTM2TeXMathSwithContinueSyntaxMode,		kiTM2TeXRegularSyntaxMode,					previousModifier & ~kiTM2TeXCommandSyntaxMask);
CASE(kiTM2TeXMathInlineBeginSyntaxMode,			kiTM2TeXRegularSyntaxMode,					previousModifier & ~kiTM2TeXCommandSyntaxMask);
CASE(kiTM2TeXMathInlineEndSyntaxMode,			kiTM2TeXRegularSyntaxMode,					previousModifier & ~kiTM2TeXCommandSyntaxMask);
CASE(kiTM2TeXMathDisplayBeginSyntaxMode,		kiTM2TeXRegularSyntaxMode,					previousModifier & ~kiTM2TeXCommandSyntaxMask);
CASE(kiTM2TeXMathDisplayEndSyntaxMode,			kiTM2TeXRegularSyntaxMode,					previousModifier & ~kiTM2TeXCommandSyntaxMask);
CASE(kiTM2TeXSubStartSyntaxMode,				kiTM2TeXRegularSyntaxMode,					previousModifier & ~kiTM2TeXCommandSyntaxMask);
CASE(kiTM2TeXSubShortSyntaxMode,				kiTM2TeXRegularSyntaxMode,					previousModifier & ~kiTM2TeXCommandSyntaxMask);
CASE(kiTM2TeXSubscriptSyntaxMode,				kiTM2TeXRegularSyntaxMode,					previousModifier & ~kiTM2TeXCommandSyntaxMask);
CASE(kiTM2TeXSuperStartSyntaxMode,				kiTM2TeXRegularSyntaxMode,					previousModifier & ~kiTM2TeXCommandSyntaxMask);
CASE(kiTM2TeXSuperContinueSyntaxMode,			kiTM2TeXRegularSyntaxMode,					previousModifier & ~kiTM2TeXCommandSyntaxMask);
CASE(kiTM2TeXSuperShortSyntaxMode,				kiTM2TeXRegularSyntaxMode,					previousModifier & ~kiTM2TeXCommandSyntaxMask);
CASE(kiTM2TeXSuperscriptSyntaxMode,				kiTM2TeXRegularSyntaxMode,					previousModifier & ~kiTM2TeXCommandSyntaxMask);
CASE(kiTM2TeXCellSeparatorSyntaxMode,			kiTM2TeXRegularSyntaxMode,					previousModifier & ~kiTM2TeXCommandSyntaxMask);
CASE(kiTM2TeXUnknownSyntaxMode,					previousModeWithoutModifiers,				previousModifier);
CASE(kiTM2TeXErrorSyntaxMode,					previousModeWithoutModifiers,				previousModifier);
					default:
						newMode = previousModeWithoutModifiers;
						newModifier = previousModifier & ~kiTM2TeXCommandSyntaxMask;
						break;
                }
				* newModeRef = newMode | previousError | newModifier;
				return kiTM2TeXNoErrorSyntaxStatus;
    
#undef CASE
#define CASE(OLDMODE,NEWMODE,NEWMODIFIER,STATUS)\
case OLDMODE: newMode = NEWMODE; newModifier = NEWMODIFIER;	status = STATUS; break

#pragma mark =-=-=-=-=- "\\"
            case '\\':
                switch(previousModeWithoutModifiers)
                {
CASE(kiTM2TeXWhitePrefixSyntaxMode,				kiTM2TeXCommandStartSyntaxMode,				previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXWaitingSyntaxStatus);
CASE(kiTM2TeXRegularSyntaxMode,					kiTM2TeXCommandStartSyntaxMode,				previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXWaitingSyntaxStatus);
CASE(kiTM2TeXCommandStartSyntaxMode,			kiTM2TeXCommandEscapedCharacterSyntaxMode,	previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXCommandEscapedCharacterSyntaxMode,	kiTM2TeXCommandStartSyntaxMode,				previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXWaitingSyntaxStatus);
CASE(kiTM2TeXCommandContinueSyntaxMode,			kiTM2TeXCommandStartSyntaxMode,				previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXWaitingSyntaxStatus);
CASE(kiTM2TeXCommandInputSyntaxMode,			kiTM2TeXCommandStartSyntaxMode,				previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXWaitingSyntaxStatus);
CASE(kiTM2TeXGroupOpenSyntaxMode,				kiTM2TeXCommandStartSyntaxMode,				previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXWaitingSyntaxStatus);
CASE(kiTM2TeXGroupCloseSyntaxMode,				kiTM2TeXCommandStartSyntaxMode,				previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXWaitingSyntaxStatus);
CASE(kiTM2TeXParenOpenSyntaxMode,				kiTM2TeXCommandStartSyntaxMode,				previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXWaitingSyntaxStatus);
CASE(kiTM2TeXParenCloseSyntaxMode,				kiTM2TeXCommandStartSyntaxMode,				previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXWaitingSyntaxStatus);
CASE(kiTM2TeXBracketOpenSyntaxMode,				kiTM2TeXCommandStartSyntaxMode,				previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXWaitingSyntaxStatus);
CASE(kiTM2TeXBracketCloseSyntaxMode,			kiTM2TeXCommandStartSyntaxMode,				previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXWaitingSyntaxStatus);
CASE(kiTM2TeXCommentStartSyntaxMode,			kiTM2TeXCommentContinueSyntaxMode,			previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXCommentContinueSyntaxMode,			previousModeWithoutModifiers,				previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXMarkSyntaxMode,					kiTM2TeXMarkContinueSyntaxMode,				previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXMarkContinueSyntaxMode,			previousModeWithoutModifiers,				previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXMathSwitchSyntaxMode,				kiTM2TeXCommandStartSyntaxMode,				previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXWaitingSyntaxStatus);
CASE(kiTM2TeXMathSwithContinueSyntaxMode,		kiTM2TeXCommandStartSyntaxMode,				previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXWaitingSyntaxStatus);
CASE(kiTM2TeXMathInlineBeginSyntaxMode,			kiTM2TeXCommandStartSyntaxMode,				previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXWaitingSyntaxStatus);
CASE(kiTM2TeXMathInlineEndSyntaxMode,			kiTM2TeXCommandStartSyntaxMode,				previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXWaitingSyntaxStatus);
CASE(kiTM2TeXMathDisplayBeginSyntaxMode,		kiTM2TeXCommandStartSyntaxMode,				previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXWaitingSyntaxStatus);
CASE(kiTM2TeXMathDisplayEndSyntaxMode,			kiTM2TeXCommandStartSyntaxMode,				previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXWaitingSyntaxStatus);
CASE(kiTM2TeXSubStartSyntaxMode,				kiTM2TeXCommandStartSyntaxMode,				previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXWaitingSyntaxStatus);
CASE(kiTM2TeXSubShortSyntaxMode,				kiTM2TeXCommandStartSyntaxMode,				previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXWaitingSyntaxStatus);
CASE(kiTM2TeXSubscriptSyntaxMode,				kiTM2TeXCommandStartSyntaxMode,				previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXWaitingSyntaxStatus);
CASE(kiTM2TeXSuperStartSyntaxMode,				kiTM2TeXCommandStartSyntaxMode,				previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXWaitingSyntaxStatus);
CASE(kiTM2TeXSuperContinueSyntaxMode,			kiTM2TeXCommandStartSyntaxMode,				previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXWaitingSyntaxStatus);
CASE(kiTM2TeXSuperShortSyntaxMode,				kiTM2TeXCommandStartSyntaxMode,				previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXWaitingSyntaxStatus);
CASE(kiTM2TeXSuperscriptSyntaxMode,				kiTM2TeXCommandStartSyntaxMode,				previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXWaitingSyntaxStatus);
CASE(kiTM2TeXCellSeparatorSyntaxMode,			kiTM2TeXCommandStartSyntaxMode,				previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXWaitingSyntaxStatus);
CASE(kiTM2TeXUnknownSyntaxMode,					previousModeWithoutModifiers,				previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXErrorSyntaxMode,					previousModeWithoutModifiers,				previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
					default:
						newMode = kiTM2TeXCommandStartSyntaxMode;
						newModifier = previousModifier;
						status = kiTM2TeXNoErrorSyntaxStatus;
						break;
                 }
				* newModeRef = newMode | previousError | newModifier;
				return status ;
    
#pragma mark =-=-=-=-=- {}
            case '{':
                switch(previousModeWithoutModifiers)
                {
CASE(kiTM2TeXWhitePrefixSyntaxMode,				kiTM2TeXGroupOpenSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXWaitingSyntaxStatus);
CASE(kiTM2TeXRegularSyntaxMode,					kiTM2TeXGroupOpenSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXWaitingSyntaxStatus);
CASE(kiTM2TeXCommandStartSyntaxMode,			kiTM2TeXCommandEscapedCharacterSyntaxMode,	previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXCommandEscapedCharacterSyntaxMode,	kiTM2TeXGroupOpenSyntaxMode,			previousModifier & kiTM2TeXCommandSyntaxMask, kiTM2TeXWaitingSyntaxStatus);
CASE(kiTM2TeXCommandContinueSyntaxMode,			kiTM2TeXGroupOpenSyntaxMode,			previousModifier & kiTM2TeXCommandSyntaxMask, kiTM2TeXWaitingSyntaxStatus);
CASE(kiTM2TeXCommandInputSyntaxMode,			kiTM2TeXGroupOpenSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXWaitingSyntaxStatus);
CASE(kiTM2TeXGroupOpenSyntaxMode,				kiTM2TeXGroupOpenSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXWaitingSyntaxStatus);
CASE(kiTM2TeXGroupCloseSyntaxMode,				kiTM2TeXGroupOpenSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXWaitingSyntaxStatus);
CASE(kiTM2TeXParenOpenSyntaxMode,				kiTM2TeXGroupOpenSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXWaitingSyntaxStatus);
CASE(kiTM2TeXParenCloseSyntaxMode,				kiTM2TeXGroupOpenSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXWaitingSyntaxStatus);
CASE(kiTM2TeXBracketOpenSyntaxMode,				kiTM2TeXGroupOpenSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXWaitingSyntaxStatus);
CASE(kiTM2TeXBracketCloseSyntaxMode,			kiTM2TeXGroupOpenSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXWaitingSyntaxStatus);
CASE(kiTM2TeXCommentStartSyntaxMode,			kiTM2TeXCommentContinueSyntaxMode,		previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXCommentContinueSyntaxMode,			previousModeWithoutModifiers,			previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXMarkSyntaxMode,					kiTM2TeXMarkContinueSyntaxMode,			previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXMarkContinueSyntaxMode,			previousModeWithoutModifiers,			previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXMathSwitchSyntaxMode,				kiTM2TeXGroupOpenSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXWaitingSyntaxStatus);
CASE(kiTM2TeXMathSwithContinueSyntaxMode,		kiTM2TeXGroupOpenSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXWaitingSyntaxStatus);
CASE(kiTM2TeXMathInlineBeginSyntaxMode,			kiTM2TeXGroupOpenSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXWaitingSyntaxStatus);
CASE(kiTM2TeXMathInlineEndSyntaxMode,			kiTM2TeXGroupOpenSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXWaitingSyntaxStatus);
CASE(kiTM2TeXMathDisplayBeginSyntaxMode,		kiTM2TeXGroupOpenSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXWaitingSyntaxStatus);
CASE(kiTM2TeXMathDisplayEndSyntaxMode,			kiTM2TeXGroupOpenSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXWaitingSyntaxStatus);
CASE(kiTM2TeXSubStartSyntaxMode,				kiTM2TeXGroupOpenSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXWaitingSyntaxStatus);
CASE(kiTM2TeXSubShortSyntaxMode,				kiTM2TeXGroupOpenSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXWaitingSyntaxStatus);
CASE(kiTM2TeXSubscriptSyntaxMode,				kiTM2TeXGroupOpenSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXWaitingSyntaxStatus);
CASE(kiTM2TeXSuperStartSyntaxMode,				kiTM2TeXGroupOpenSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXWaitingSyntaxStatus);
CASE(kiTM2TeXSuperContinueSyntaxMode,			kiTM2TeXGroupOpenSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXWaitingSyntaxStatus);
CASE(kiTM2TeXSuperShortSyntaxMode,				kiTM2TeXGroupOpenSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXWaitingSyntaxStatus);
CASE(kiTM2TeXSuperscriptSyntaxMode,				kiTM2TeXGroupOpenSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXWaitingSyntaxStatus);
CASE(kiTM2TeXCellSeparatorSyntaxMode,			kiTM2TeXGroupOpenSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXWaitingSyntaxStatus);
CASE(kiTM2TeXUnknownSyntaxMode,					previousModeWithoutModifiers,			previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXErrorSyntaxMode,					previousModeWithoutModifiers,			previousModifier, kiTM2TeXNoErrorSyntaxStatus);
					default:
						newMode = kiTM2TeXGroupOpenSyntaxMode;
						newModifier = previousModifier & ~kiTM2TeXCommandSyntaxMask;
						status = kiTM2TeXWaitingSyntaxStatus;
						break;
                }
				* newModeRef = newMode | previousError | newModifier;
				return status ;

            case '}':
                switch(previousModeWithoutModifiers)
                {
CASE(kiTM2TeXWhitePrefixSyntaxMode,				kiTM2TeXGroupCloseSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXRegularSyntaxMode,					kiTM2TeXGroupCloseSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXCommandStartSyntaxMode,			kiTM2TeXCommandEscapedCharacterSyntaxMode,	previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXCommandEscapedCharacterSyntaxMode,	kiTM2TeXGroupCloseSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXCommandContinueSyntaxMode,			kiTM2TeXGroupCloseSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXCommandInputSyntaxMode,			kiTM2TeXGroupCloseSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXGroupOpenSyntaxMode,				kiTM2TeXGroupCloseSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXGroupCloseSyntaxMode,				kiTM2TeXGroupCloseSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXParenOpenSyntaxMode,				kiTM2TeXGroupCloseSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXParenCloseSyntaxMode,				kiTM2TeXGroupCloseSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXBracketOpenSyntaxMode,				kiTM2TeXGroupCloseSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXBracketCloseSyntaxMode,			kiTM2TeXGroupCloseSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXCommentStartSyntaxMode,			kiTM2TeXCommentContinueSyntaxMode,		previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXCommentContinueSyntaxMode,			previousModeWithoutModifiers,			previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXMarkSyntaxMode,					kiTM2TeXMarkContinueSyntaxMode,			previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXMarkContinueSyntaxMode,			previousModeWithoutModifiers,			previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXMathSwitchSyntaxMode,				kiTM2TeXGroupCloseSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXMathSwithContinueSyntaxMode,		kiTM2TeXGroupCloseSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXMathInlineBeginSyntaxMode,			kiTM2TeXGroupCloseSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXMathInlineEndSyntaxMode,			kiTM2TeXGroupCloseSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXMathDisplayBeginSyntaxMode,		kiTM2TeXGroupCloseSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXMathDisplayEndSyntaxMode,			kiTM2TeXGroupCloseSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXSubStartSyntaxMode,				kiTM2TeXGroupCloseSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXSubShortSyntaxMode,				kiTM2TeXGroupCloseSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXSubscriptSyntaxMode,				kiTM2TeXGroupCloseSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXSuperStartSyntaxMode,				kiTM2TeXErrorSyntaxMode,				previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXSuperContinueSyntaxMode,			kiTM2TeXGroupCloseSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXSuperShortSyntaxMode,				kiTM2TeXGroupCloseSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXSuperscriptSyntaxMode,				kiTM2TeXGroupCloseSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXCellSeparatorSyntaxMode,			kiTM2TeXGroupCloseSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXUnknownSyntaxMode,					previousModeWithoutModifiers,			previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXErrorSyntaxMode,					previousModeWithoutModifiers,			previousModifier, kiTM2TeXNoErrorSyntaxStatus);
					default:
						newMode = kiTM2TeXGroupOpenSyntaxMode;
						newModifier = previousModifier & ~kiTM2TeXCommandSyntaxMask;
						status = kiTM2TeXNoErrorSyntaxStatus;
						break;
                }
				* newModeRef = newMode | previousError | newModifier;
				return status ;

#pragma mark =-=-=-=-=- ()
            case '(':
                switch(previousModeWithoutModifiers)
                {
CASE(kiTM2TeXWhitePrefixSyntaxMode,				kiTM2TeXParenOpenSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXRegularSyntaxMode,					kiTM2TeXParenOpenSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXCommandStartSyntaxMode,			kiTM2TeXMathInlineBeginSyntaxMode,		previousModifier, kiTM2TeXWaitingSyntaxStatus);
CASE(kiTM2TeXCommandEscapedCharacterSyntaxMode,	kiTM2TeXParenOpenSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXCommandContinueSyntaxMode,			kiTM2TeXParenOpenSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXCommandInputSyntaxMode,			kiTM2TeXParenOpenSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXGroupOpenSyntaxMode,				kiTM2TeXParenOpenSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXGroupCloseSyntaxMode,				kiTM2TeXParenOpenSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXParenOpenSyntaxMode,				kiTM2TeXParenOpenSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXParenCloseSyntaxMode,				kiTM2TeXParenOpenSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXBracketOpenSyntaxMode,				kiTM2TeXParenOpenSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXBracketCloseSyntaxMode,			kiTM2TeXParenOpenSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXCommentStartSyntaxMode,			kiTM2TeXCommentContinueSyntaxMode,		previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXCommentContinueSyntaxMode,			previousModeWithoutModifiers,			previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXMarkSyntaxMode,					kiTM2TeXMarkContinueSyntaxMode,			previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXMarkContinueSyntaxMode,			previousModeWithoutModifiers,			previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXMathSwitchSyntaxMode,				kiTM2TeXParenOpenSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXMathSwithContinueSyntaxMode,		kiTM2TeXParenOpenSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXMathInlineBeginSyntaxMode,			kiTM2TeXParenOpenSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXMathInlineEndSyntaxMode,			kiTM2TeXParenOpenSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXMathDisplayBeginSyntaxMode,		kiTM2TeXParenOpenSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXMathDisplayEndSyntaxMode,			kiTM2TeXParenOpenSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXSubStartSyntaxMode,				kiTM2TeXSubShortSyntaxMode,				previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXSubShortSyntaxMode,				kiTM2TeXParenOpenSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXSubscriptSyntaxMode,				kiTM2TeXParenOpenSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXSuperStartSyntaxMode,				kiTM2TeXSuperShortSyntaxMode,			previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXSuperContinueSyntaxMode,			kiTM2TeXParenOpenSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXSuperShortSyntaxMode,				kiTM2TeXParenOpenSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXSuperscriptSyntaxMode,				kiTM2TeXParenOpenSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXCellSeparatorSyntaxMode,			kiTM2TeXParenOpenSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXUnknownSyntaxMode,					previousModeWithoutModifiers,			previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXErrorSyntaxMode,					previousModeWithoutModifiers,			previousModifier, kiTM2TeXNoErrorSyntaxStatus);
					default:
						newMode = kiTM2TeXParenOpenSyntaxMode;
						newModifier = previousModifier & ~kiTM2TeXCommandSyntaxMask;
						status = kiTM2TeXNoErrorSyntaxStatus;
						break;
				}
				* newModeRef = newMode | previousError | newModifier;
				return status ;

            case ')':
                switch(previousModeWithoutModifiers)
                {
CASE(kiTM2TeXWhitePrefixSyntaxMode,				kiTM2TeXParenCloseSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXRegularSyntaxMode,					kiTM2TeXParenCloseSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXCommandStartSyntaxMode,			kiTM2TeXMathInlineEndSyntaxMode,		previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXCommandEscapedCharacterSyntaxMode,	kiTM2TeXParenCloseSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXCommandContinueSyntaxMode,			kiTM2TeXParenCloseSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXCommandInputSyntaxMode,			kiTM2TeXErrorSyntaxMode,				previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXGroupOpenSyntaxMode,				kiTM2TeXParenCloseSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXGroupCloseSyntaxMode,				kiTM2TeXParenCloseSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXParenOpenSyntaxMode,				kiTM2TeXParenCloseSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXParenCloseSyntaxMode,				kiTM2TeXParenCloseSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXBracketOpenSyntaxMode,				kiTM2TeXParenCloseSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXBracketCloseSyntaxMode,			kiTM2TeXParenCloseSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXCommentStartSyntaxMode,			kiTM2TeXCommentContinueSyntaxMode,		previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXCommentContinueSyntaxMode,			previousModeWithoutModifiers,			previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXMarkSyntaxMode,					kiTM2TeXMarkContinueSyntaxMode,			previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXMarkContinueSyntaxMode,			previousModeWithoutModifiers,			previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXMathSwitchSyntaxMode,				kiTM2TeXParenCloseSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXMathSwithContinueSyntaxMode,		kiTM2TeXParenCloseSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXMathInlineBeginSyntaxMode,			kiTM2TeXParenCloseSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXMathInlineEndSyntaxMode,			kiTM2TeXParenCloseSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXMathDisplayBeginSyntaxMode,		kiTM2TeXParenCloseSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXMathDisplayEndSyntaxMode,			kiTM2TeXParenCloseSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXSubStartSyntaxMode,				kiTM2TeXSubShortSyntaxMode,				previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXSubShortSyntaxMode,				kiTM2TeXParenCloseSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXSubscriptSyntaxMode,				kiTM2TeXParenCloseSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXSuperStartSyntaxMode,				kiTM2TeXSuperShortSyntaxMode,			previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXSuperContinueSyntaxMode,			kiTM2TeXSuperShortSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXSuperShortSyntaxMode,				kiTM2TeXParenCloseSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXSuperscriptSyntaxMode,				kiTM2TeXParenCloseSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXCellSeparatorSyntaxMode,			kiTM2TeXParenCloseSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXUnknownSyntaxMode,					previousModeWithoutModifiers,			previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXErrorSyntaxMode,					previousModeWithoutModifiers,			previousModifier, kiTM2TeXNoErrorSyntaxStatus);
					default:
						newMode = kiTM2TeXParenCloseSyntaxMode;
						newModifier = previousModifier & ~kiTM2TeXCommandSyntaxMask;
						status = kiTM2TeXNoErrorSyntaxStatus;
						break;
				}
				* newModeRef = newMode | previousError | newModifier;
				return status ;
#pragma mark =-=-=-=-=- []
            case '[':
                switch(previousModeWithoutModifiers)
                {
CASE(kiTM2TeXWhitePrefixSyntaxMode,				kiTM2TeXBracketOpenSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXRegularSyntaxMode,					kiTM2TeXBracketOpenSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXCommandStartSyntaxMode,			kiTM2TeXMathDisplayBeginSyntaxMode,		previousModifier, kiTM2TeXWaitingSyntaxStatus);
CASE(kiTM2TeXCommandEscapedCharacterSyntaxMode,	kiTM2TeXBracketOpenSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXCommandContinueSyntaxMode,			kiTM2TeXBracketOpenSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXCommandInputSyntaxMode,			kiTM2TeXErrorSyntaxMode,				previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXGroupOpenSyntaxMode,				kiTM2TeXBracketOpenSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXGroupCloseSyntaxMode,				kiTM2TeXBracketOpenSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXParenOpenSyntaxMode,				kiTM2TeXBracketOpenSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXParenCloseSyntaxMode,				kiTM2TeXBracketOpenSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXBracketOpenSyntaxMode,				kiTM2TeXBracketOpenSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXBracketCloseSyntaxMode,			kiTM2TeXBracketOpenSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXCommentStartSyntaxMode,			kiTM2TeXCommentContinueSyntaxMode,		previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXCommentContinueSyntaxMode,			previousModeWithoutModifiers,			previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXMarkSyntaxMode,					kiTM2TeXMarkContinueSyntaxMode,			previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXMarkContinueSyntaxMode,			previousModeWithoutModifiers,			previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXMathSwitchSyntaxMode,				kiTM2TeXBracketOpenSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXMathSwithContinueSyntaxMode,		kiTM2TeXBracketOpenSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXMathInlineBeginSyntaxMode,			kiTM2TeXBracketOpenSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXMathInlineEndSyntaxMode,			kiTM2TeXBracketOpenSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXMathDisplayBeginSyntaxMode,		kiTM2TeXBracketOpenSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXMathDisplayEndSyntaxMode,			kiTM2TeXBracketOpenSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXSubStartSyntaxMode,				kiTM2TeXSubShortSyntaxMode,				previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXSubShortSyntaxMode,				kiTM2TeXBracketOpenSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXSubscriptSyntaxMode,				kiTM2TeXBracketOpenSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXSuperStartSyntaxMode,				kiTM2TeXSuperShortSyntaxMode,			previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXSuperContinueSyntaxMode,			kiTM2TeXSuperShortSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXSuperShortSyntaxMode,				kiTM2TeXBracketOpenSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXSuperscriptSyntaxMode,				kiTM2TeXBracketOpenSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXCellSeparatorSyntaxMode,			kiTM2TeXBracketOpenSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXUnknownSyntaxMode,					previousModeWithoutModifiers,			previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXErrorSyntaxMode,					previousModeWithoutModifiers,			previousModifier, kiTM2TeXNoErrorSyntaxStatus);
					default:
						newMode = kiTM2TeXBracketOpenSyntaxMode;
						newModifier = previousModifier & ~kiTM2TeXCommandSyntaxMask;
						status = kiTM2TeXNoErrorSyntaxStatus;
						break;
				}
				* newModeRef = newMode | previousError | newModifier;
				return status ;

            case ']':
                switch(previousModeWithoutModifiers)
                {
CASE(kiTM2TeXWhitePrefixSyntaxMode,				kiTM2TeXBracketCloseSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXRegularSyntaxMode,					kiTM2TeXBracketCloseSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXCommandStartSyntaxMode,			kiTM2TeXMathDisplayEndSyntaxMode,		previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXCommandEscapedCharacterSyntaxMode,	kiTM2TeXBracketCloseSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXCommandContinueSyntaxMode,			kiTM2TeXBracketCloseSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXCommandInputSyntaxMode,			kiTM2TeXErrorSyntaxMode,				previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXGroupOpenSyntaxMode,				kiTM2TeXBracketCloseSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXGroupCloseSyntaxMode,				kiTM2TeXBracketCloseSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXParenOpenSyntaxMode,				kiTM2TeXBracketCloseSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXParenCloseSyntaxMode,				kiTM2TeXBracketCloseSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXBracketOpenSyntaxMode,				kiTM2TeXBracketCloseSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXBracketCloseSyntaxMode,			kiTM2TeXBracketCloseSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXCommentStartSyntaxMode,			kiTM2TeXCommentContinueSyntaxMode,		previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXCommentContinueSyntaxMode,			previousModeWithoutModifiers,			previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXMarkSyntaxMode,					kiTM2TeXMarkContinueSyntaxMode,			previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXMarkContinueSyntaxMode,			previousModeWithoutModifiers,			previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXMathSwitchSyntaxMode,				kiTM2TeXBracketCloseSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXMathSwithContinueSyntaxMode,		kiTM2TeXBracketCloseSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXMathInlineBeginSyntaxMode,			kiTM2TeXBracketCloseSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXMathInlineEndSyntaxMode,			kiTM2TeXBracketCloseSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXMathDisplayBeginSyntaxMode,		kiTM2TeXBracketCloseSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXMathDisplayEndSyntaxMode,			kiTM2TeXBracketCloseSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXSubStartSyntaxMode,				kiTM2TeXSubShortSyntaxMode,				previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXSubShortSyntaxMode,				kiTM2TeXBracketCloseSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXSubscriptSyntaxMode,				kiTM2TeXBracketCloseSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXSuperStartSyntaxMode,				kiTM2TeXSuperShortSyntaxMode,			previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXSuperContinueSyntaxMode,			kiTM2TeXBracketCloseSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXSuperShortSyntaxMode,				kiTM2TeXBracketCloseSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXSuperscriptSyntaxMode,				kiTM2TeXBracketCloseSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXCellSeparatorSyntaxMode,			kiTM2TeXBracketCloseSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXUnknownSyntaxMode,					previousModeWithoutModifiers,			previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXErrorSyntaxMode,					previousModeWithoutModifiers,			previousModifier, kiTM2TeXNoErrorSyntaxStatus);
					default:
						newMode = kiTM2TeXBracketCloseSyntaxMode;
						newModifier = previousModifier & ~kiTM2TeXCommandSyntaxMask;
						status = kiTM2TeXNoErrorSyntaxStatus;
						break;
				}
				* newModeRef = newMode | previousError | newModifier;
				return status ;

#pragma mark =-=-=-=-=- $
            case '$':
                switch(previousModeWithoutModifiers)
				{
CASE(kiTM2TeXWhitePrefixSyntaxMode,				kiTM2TeXMathSwitchSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXRegularSyntaxMode,					kiTM2TeXMathSwitchSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXCommandStartSyntaxMode,			kiTM2TeXCommandEscapedCharacterSyntaxMode,	previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXCommandEscapedCharacterSyntaxMode,	kiTM2TeXMathSwitchSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXCommandContinueSyntaxMode,			kiTM2TeXMathSwitchSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXCommandInputSyntaxMode,			kiTM2TeXErrorSyntaxMode,				previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXGroupOpenSyntaxMode,				kiTM2TeXMathSwitchSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXGroupCloseSyntaxMode,				kiTM2TeXMathSwitchSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXParenOpenSyntaxMode,				kiTM2TeXMathSwitchSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXParenCloseSyntaxMode,				kiTM2TeXMathSwitchSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXBracketOpenSyntaxMode,				kiTM2TeXMathSwitchSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXBracketCloseSyntaxMode,			kiTM2TeXMathSwitchSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXCommentStartSyntaxMode,			kiTM2TeXCommentContinueSyntaxMode,		previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXCommentContinueSyntaxMode,			previousModeWithoutModifiers,			previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXMarkSyntaxMode,					kiTM2TeXMarkContinueSyntaxMode,			previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXMarkContinueSyntaxMode,			previousModeWithoutModifiers,			previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXMathSwitchSyntaxMode,				kiTM2TeXMathSwithContinueSyntaxMode,	previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXMathSwithContinueSyntaxMode,		kiTM2TeXMathSwitchSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXMathInlineBeginSyntaxMode,			kiTM2TeXMathSwitchSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXMathInlineEndSyntaxMode,			kiTM2TeXMathSwitchSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXMathDisplayBeginSyntaxMode,		kiTM2TeXMathSwitchSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXMathDisplayEndSyntaxMode,			kiTM2TeXMathSwitchSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXSubStartSyntaxMode,				kiTM2TeXErrorSyntaxMode,				previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXSubShortSyntaxMode,				kiTM2TeXMathSwitchSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXSubscriptSyntaxMode,				kiTM2TeXMathSwitchSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXSuperStartSyntaxMode,				kiTM2TeXErrorSyntaxMode,				previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXSuperContinueSyntaxMode,			kiTM2TeXMathSwitchSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXSuperShortSyntaxMode,				kiTM2TeXMathSwitchSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXSuperscriptSyntaxMode,				kiTM2TeXMathSwitchSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXCellSeparatorSyntaxMode,			kiTM2TeXMathSwitchSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXUnknownSyntaxMode,					previousModeWithoutModifiers,			previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXErrorSyntaxMode,					previousModeWithoutModifiers,			previousModifier, kiTM2TeXNoErrorSyntaxStatus);
					default:
						newMode = kiTM2TeXMathSwitchSyntaxMode;
						newModifier = previousModifier & ~kiTM2TeXCommandSyntaxMask;
						status = kiTM2TeXNoErrorSyntaxStatus;
						break;
				}
				* newModeRef = newMode | previousError | newModifier;
				return status ;
    
#pragma mark =-=-=-=-=- %
            case '%':
                switch(previousModeWithoutModifiers)
                {
CASE(kiTM2TeXWhitePrefixSyntaxMode,				kiTM2TeXCommentStartSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXRegularSyntaxMode,					kiTM2TeXCommentStartSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXCommandStartSyntaxMode,			kiTM2TeXCommandEscapedCharacterSyntaxMode,	previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXCommandEscapedCharacterSyntaxMode,	kiTM2TeXCommentStartSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXCommandContinueSyntaxMode,			kiTM2TeXCommentStartSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXCommandInputSyntaxMode,			kiTM2TeXErrorSyntaxMode,				previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXGroupOpenSyntaxMode,				kiTM2TeXCommentStartSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXGroupCloseSyntaxMode,				kiTM2TeXCommentStartSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXParenOpenSyntaxMode,				kiTM2TeXCommentStartSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXParenCloseSyntaxMode,				kiTM2TeXCommentStartSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXBracketOpenSyntaxMode,				kiTM2TeXCommentStartSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXBracketCloseSyntaxMode,			kiTM2TeXCommentStartSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXCommentStartSyntaxMode,			kiTM2TeXCommentContinueSyntaxMode,		previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXCommentContinueSyntaxMode,			previousModeWithoutModifiers,			previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXMarkSyntaxMode,					kiTM2TeXMarkContinueSyntaxMode,			previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXMarkContinueSyntaxMode,			previousModeWithoutModifiers,			previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXMathSwitchSyntaxMode,				kiTM2TeXMathSwithContinueSyntaxMode,	previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXMathSwithContinueSyntaxMode,		kiTM2TeXCommentStartSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXMathInlineBeginSyntaxMode,			kiTM2TeXCommentStartSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXMathInlineEndSyntaxMode,			kiTM2TeXCommentStartSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXMathDisplayBeginSyntaxMode,		kiTM2TeXCommentStartSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXMathDisplayEndSyntaxMode,			kiTM2TeXCommentStartSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXSubStartSyntaxMode,				kiTM2TeXCommentStartSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXSubShortSyntaxMode,				kiTM2TeXCommentStartSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXSubscriptSyntaxMode,				kiTM2TeXCommentStartSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXSuperStartSyntaxMode,				kiTM2TeXCommentStartSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXSuperContinueSyntaxMode,			kiTM2TeXCommentStartSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXSuperShortSyntaxMode,				kiTM2TeXCommentStartSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXSuperscriptSyntaxMode,				kiTM2TeXCommentStartSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXCellSeparatorSyntaxMode,			kiTM2TeXCommentStartSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXUnknownSyntaxMode,					previousModeWithoutModifiers,			previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXErrorSyntaxMode,					previousModeWithoutModifiers,			previousModifier, kiTM2TeXNoErrorSyntaxStatus);
					default:
						newMode = kiTM2TeXCommentStartSyntaxMode;
						newModifier = previousModifier & ~kiTM2TeXCommandSyntaxMask;
						status = kiTM2TeXNoErrorSyntaxStatus;
						break;
				}
				* newModeRef = newMode | previousError | newModifier;
				return status ;
            
#pragma mark =-=-=-=-=- &
            case '&':
                switch(previousModeWithoutModifiers)
                {
CASE(kiTM2TeXWhitePrefixSyntaxMode,				kiTM2TeXCellSeparatorSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXRegularSyntaxMode,					kiTM2TeXCellSeparatorSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXCommandStartSyntaxMode,			kiTM2TeXCommandEscapedCharacterSyntaxMode,	previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXCommandEscapedCharacterSyntaxMode,	kiTM2TeXCellSeparatorSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXCommandContinueSyntaxMode,			kiTM2TeXCellSeparatorSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXCommandInputSyntaxMode,			kiTM2TeXErrorSyntaxMode,					previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXGroupOpenSyntaxMode,				kiTM2TeXCellSeparatorSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXGroupCloseSyntaxMode,				kiTM2TeXCellSeparatorSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXParenOpenSyntaxMode,				kiTM2TeXCellSeparatorSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXParenCloseSyntaxMode,				kiTM2TeXCellSeparatorSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXBracketOpenSyntaxMode,				kiTM2TeXCellSeparatorSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXBracketCloseSyntaxMode,			kiTM2TeXCellSeparatorSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXCommentStartSyntaxMode,			kiTM2TeXCommentContinueSyntaxMode,			previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXCommentContinueSyntaxMode,			previousModeWithoutModifiers,				previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXMarkSyntaxMode,					kiTM2TeXMarkContinueSyntaxMode,				previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXMarkContinueSyntaxMode,			previousModeWithoutModifiers,				previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXMathSwitchSyntaxMode,				kiTM2TeXMathSwithContinueSyntaxMode,		previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXMathSwithContinueSyntaxMode,		kiTM2TeXCellSeparatorSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXMathInlineBeginSyntaxMode,			kiTM2TeXErrorSyntaxMode,					previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXMathInlineEndSyntaxMode,			kiTM2TeXCellSeparatorSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXMathDisplayBeginSyntaxMode,		kiTM2TeXErrorSyntaxMode,					previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXMathDisplayEndSyntaxMode,			kiTM2TeXErrorSyntaxMode,					previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXSubStartSyntaxMode,				kiTM2TeXErrorSyntaxMode,					previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXSubShortSyntaxMode,				kiTM2TeXCellSeparatorSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXSubscriptSyntaxMode,				kiTM2TeXCellSeparatorSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXSuperStartSyntaxMode,				kiTM2TeXErrorSyntaxMode,					previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXSuperContinueSyntaxMode,			kiTM2TeXCellSeparatorSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXSuperShortSyntaxMode,				kiTM2TeXCellSeparatorSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXSuperscriptSyntaxMode,				kiTM2TeXCellSeparatorSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXCellSeparatorSyntaxMode,			kiTM2TeXCellSeparatorSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXUnknownSyntaxMode,					previousModeWithoutModifiers,				previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXErrorSyntaxMode,					previousModeWithoutModifiers,				previousModifier, kiTM2TeXNoErrorSyntaxStatus);
					default:
						newMode = kiTM2TeXCellSeparatorSyntaxMode;
						newModifier = previousModifier & ~kiTM2TeXCommandSyntaxMask;
						status = kiTM2TeXNoErrorSyntaxStatus;
						break;
				}
				* newModeRef = newMode | previousError | newModifier;
				return status ;
            
#pragma mark =-=-=-=-=- !
            case '!':// only active after thet first '%'
                switch(previousModeWithoutModifiers)
                {
CASE(kiTM2TeXWhitePrefixSyntaxMode,				kiTM2TeXRegularSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXRegularSyntaxMode,					kiTM2TeXRegularSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXCommandStartSyntaxMode,			kiTM2TeXCommandEscapedCharacterSyntaxMode,	previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXCommandEscapedCharacterSyntaxMode,	kiTM2TeXRegularSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXCommandContinueSyntaxMode,			kiTM2TeXRegularSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXCommandInputSyntaxMode,			kiTM2TeXErrorSyntaxMode,			previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXGroupOpenSyntaxMode,				kiTM2TeXRegularSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXGroupCloseSyntaxMode,				kiTM2TeXRegularSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXParenOpenSyntaxMode,				kiTM2TeXRegularSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXParenCloseSyntaxMode,				kiTM2TeXRegularSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXBracketOpenSyntaxMode,				kiTM2TeXRegularSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXBracketCloseSyntaxMode,			kiTM2TeXRegularSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXCommentStartSyntaxMode,			kiTM2TeXMarkSyntaxMode,				previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXCommentContinueSyntaxMode,			previousModeWithoutModifiers,		previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXMarkSyntaxMode,					kiTM2TeXMarkContinueSyntaxMode,		previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXMarkContinueSyntaxMode,			previousModeWithoutModifiers,		previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXMathSwitchSyntaxMode,				kiTM2TeXRegularSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXMathSwithContinueSyntaxMode,		kiTM2TeXRegularSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXMathInlineBeginSyntaxMode,			kiTM2TeXRegularSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXMathInlineEndSyntaxMode,			kiTM2TeXRegularSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXMathDisplayBeginSyntaxMode,		kiTM2TeXRegularSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXMathDisplayEndSyntaxMode,			kiTM2TeXRegularSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXSubStartSyntaxMode,				kiTM2TeXRegularSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXSubShortSyntaxMode,				kiTM2TeXRegularSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXSubscriptSyntaxMode,				kiTM2TeXRegularSyntaxMode,			previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXSuperStartSyntaxMode,				kiTM2TeXSuperShortSyntaxMode,		previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXSuperContinueSyntaxMode,			kiTM2TeXSuperShortSyntaxMode,		previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXSuperShortSyntaxMode,				kiTM2TeXRegularSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXSuperscriptSyntaxMode,				kiTM2TeXRegularSyntaxMode,			previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXCellSeparatorSyntaxMode,			kiTM2TeXRegularSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXUnknownSyntaxMode,					previousModeWithoutModifiers,		previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXErrorSyntaxMode,					previousModeWithoutModifiers,		previousModifier, kiTM2TeXNoErrorSyntaxStatus);
					default:
						newMode = kiTM2TeXRegularSyntaxMode;
						newModifier = previousModifier & ~kiTM2TeXCommandSyntaxMask;
						status = kiTM2TeXNoErrorSyntaxStatus;
						break;
				}
				* newModeRef = newMode | previousError | newModifier;
				return status ;

#pragma mark =-=-=-=-=- ^
            case '^':
                switch(previousModeWithoutModifiers)
                {
CASE(kiTM2TeXWhitePrefixSyntaxMode,				kiTM2TeXSuperStartSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXRegularSyntaxMode,					kiTM2TeXSuperStartSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
				CASE(kiTM2TeXCommandStartSyntaxMode,			kiTM2TeXSuperStartSyntaxMode,			previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXCommandEscapedCharacterSyntaxMode,	kiTM2TeXSuperStartSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXCommandContinueSyntaxMode,			kiTM2TeXSuperStartSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXCommandInputSyntaxMode,			kiTM2TeXErrorSyntaxMode,				previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXGroupOpenSyntaxMode,				kiTM2TeXSuperStartSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXGroupCloseSyntaxMode,				kiTM2TeXSuperStartSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXParenOpenSyntaxMode,				kiTM2TeXSuperStartSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXParenCloseSyntaxMode,				kiTM2TeXSuperStartSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXBracketOpenSyntaxMode,				kiTM2TeXSuperStartSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXBracketCloseSyntaxMode,			kiTM2TeXSuperStartSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXCommentStartSyntaxMode,			kiTM2TeXCommentContinueSyntaxMode,		previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXCommentContinueSyntaxMode,			previousModeWithoutModifiers,			previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXMarkSyntaxMode,					kiTM2TeXMarkContinueSyntaxMode,			previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXMarkContinueSyntaxMode,			previousModeWithoutModifiers,			previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXMathSwitchSyntaxMode,				kiTM2TeXSuperStartSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXMathSwithContinueSyntaxMode,		kiTM2TeXSuperStartSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXMathInlineBeginSyntaxMode,			kiTM2TeXSuperStartSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXMathInlineEndSyntaxMode,			kiTM2TeXErrorSyntaxMode,				previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXMathDisplayBeginSyntaxMode,		kiTM2TeXSuperStartSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXMathDisplayEndSyntaxMode,			kiTM2TeXErrorSyntaxMode,				previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXSubStartSyntaxMode,				kiTM2TeXErrorSyntaxMode,				previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXSubShortSyntaxMode,				kiTM2TeXSuperStartSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXSubscriptSyntaxMode,				kiTM2TeXSuperStartSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXSuperStartSyntaxMode,				kiTM2TeXSuperContinueSyntaxMode,		previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXSuperContinueSyntaxMode,			kiTM2TeXSuperShortSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXSuperShortSyntaxMode,				kiTM2TeXSuperStartSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXSuperscriptSyntaxMode,				kiTM2TeXErrorSyntaxMode,				previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXCellSeparatorSyntaxMode,			kiTM2TeXSuperStartSyntaxMode,			previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXUnknownSyntaxMode,					previousModeWithoutModifiers,			previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXErrorSyntaxMode,					previousModeWithoutModifiers,			previousModifier, kiTM2TeXNoErrorSyntaxStatus);
					default:
						newMode = kiTM2TeXSuperStartSyntaxMode;
						newModifier = previousModifier & ~kiTM2TeXCommandSyntaxMask;
						status = kiTM2TeXNoErrorSyntaxStatus;
						break;
				}
				* newModeRef = newMode | previousError | newModifier;
				return status ;

#pragma mark =-=-=-=-=- _
            case '_':
                switch(previousModeWithoutModifiers)
                {
CASE(kiTM2TeXWhitePrefixSyntaxMode,				kiTM2TeXSubStartSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXRegularSyntaxMode,					kiTM2TeXSubStartSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXCommandStartSyntaxMode,			kiTM2TeXCommandEscapedCharacterSyntaxMode,	previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXCommandEscapedCharacterSyntaxMode,	kiTM2TeXSubStartSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXCommandContinueSyntaxMode,			kiTM2TeXSubStartSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXCommandInputSyntaxMode,			kiTM2TeXErrorSyntaxMode,			previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXGroupOpenSyntaxMode,				kiTM2TeXSubStartSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXGroupCloseSyntaxMode,				kiTM2TeXSubStartSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXParenOpenSyntaxMode,				kiTM2TeXSubStartSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXParenCloseSyntaxMode,				kiTM2TeXSubStartSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXBracketOpenSyntaxMode,				kiTM2TeXSubStartSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXBracketCloseSyntaxMode,			kiTM2TeXSubStartSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXCommentStartSyntaxMode,			kiTM2TeXCommentContinueSyntaxMode,	previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXCommentContinueSyntaxMode,			previousModeWithoutModifiers,		previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXMarkSyntaxMode,					kiTM2TeXMarkContinueSyntaxMode,		previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXMarkContinueSyntaxMode,			previousModeWithoutModifiers,		previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXMathSwitchSyntaxMode,				kiTM2TeXSubStartSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXMathSwithContinueSyntaxMode,		kiTM2TeXSubStartSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXMathInlineBeginSyntaxMode,			kiTM2TeXSubStartSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXMathInlineEndSyntaxMode,			kiTM2TeXErrorSyntaxMode,			previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXMathDisplayBeginSyntaxMode,		kiTM2TeXSubStartSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXMathDisplayEndSyntaxMode,			kiTM2TeXErrorSyntaxMode,			previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXSubStartSyntaxMode,				kiTM2TeXErrorSyntaxMode,			previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXSubShortSyntaxMode,				kiTM2TeXSubStartSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXSubscriptSyntaxMode,				kiTM2TeXErrorSyntaxMode,			previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXSuperStartSyntaxMode,				kiTM2TeXErrorSyntaxMode,			previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXSuperContinueSyntaxMode,			kiTM2TeXSubStartSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXSuperShortSyntaxMode,				kiTM2TeXSubStartSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXSuperscriptSyntaxMode,				kiTM2TeXSubStartSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXCellSeparatorSyntaxMode,			kiTM2TeXErrorSyntaxMode,			previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXUnknownSyntaxMode,					previousModeWithoutModifiers,		previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXErrorSyntaxMode,					previousModeWithoutModifiers,		previousModifier, kiTM2TeXNoErrorSyntaxStatus);
					default:
						newMode = kiTM2TeXSubStartSyntaxMode;
						newModifier = previousModifier & ~kiTM2TeXCommandSyntaxMask;
						status = kiTM2TeXNoErrorSyntaxStatus;
						break;
				}
				* newModeRef = newMode | previousError | newModifier;
				return status ;
            
#pragma mark =-=-=-=-=- @
            case '@':
                switch(previousModeWithoutModifiers)
                {
CASE(kiTM2TeXWhitePrefixSyntaxMode,				kiTM2TeXRegularSyntaxMode,			previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXRegularSyntaxMode,					kiTM2TeXRegularSyntaxMode,			previousModifier, kiTM2TeXNoErrorSyntaxStatus);
case kiTM2TeXCommandStartSyntaxMode:
	newMode = [self contextBoolForKey:@"iTM2MakeAtLetter" domain:iTM2ContextExtendedProjectMask|iTM2ContextPrivateMask]?
		kiTM2TeXCommandContinueSyntaxMode:kiTM2TeXCommandEscapedCharacterSyntaxMode;
	newModifier = previousModifier | kiTM2TeXCommandSyntaxMask;
	status = kiTM2TeXNoErrorSyntaxStatus;
	break;
//CASE(kiTM2TeXCommandStartSyntaxMode,			kiTM2TeXCommandEscapedCharacterSyntaxMode,	previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXCommandEscapedCharacterSyntaxMode,	kiTM2TeXRegularSyntaxMode,			previousModifier, kiTM2TeXNoErrorSyntaxStatus);
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
//CASE(kiTM2TeXCommandContinueSyntaxMode,			kiTM2TeXRegularSyntaxMode,			previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXCommandInputSyntaxMode,			kiTM2TeXRegularSyntaxMode,			previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXGroupOpenSyntaxMode,				kiTM2TeXRegularSyntaxMode,			previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXGroupCloseSyntaxMode,				kiTM2TeXRegularSyntaxMode,			previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXParenOpenSyntaxMode,				kiTM2TeXRegularSyntaxMode,			previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXParenCloseSyntaxMode,				kiTM2TeXRegularSyntaxMode,			previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXBracketOpenSyntaxMode,				kiTM2TeXRegularSyntaxMode,			previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXBracketCloseSyntaxMode,			kiTM2TeXRegularSyntaxMode,			previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXCommentStartSyntaxMode,			kiTM2TeXCommentContinueSyntaxMode,	previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXCommentContinueSyntaxMode,			previousModeWithoutModifiers,		previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXMarkSyntaxMode,					kiTM2TeXMarkContinueSyntaxMode,		previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXMarkContinueSyntaxMode,			previousModeWithoutModifiers,		previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXMathSwitchSyntaxMode,				kiTM2TeXRegularSyntaxMode,			previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXMathSwithContinueSyntaxMode,		kiTM2TeXRegularSyntaxMode,			previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXMathInlineBeginSyntaxMode,			kiTM2TeXRegularSyntaxMode,			previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXMathInlineEndSyntaxMode,			kiTM2TeXRegularSyntaxMode,			previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXMathDisplayBeginSyntaxMode,		kiTM2TeXRegularSyntaxMode,			previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXMathDisplayEndSyntaxMode,			kiTM2TeXRegularSyntaxMode,			previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXSubStartSyntaxMode,				kiTM2TeXRegularSyntaxMode,			previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXSubShortSyntaxMode,				kiTM2TeXRegularSyntaxMode,			previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXSubscriptSyntaxMode,				kiTM2TeXRegularSyntaxMode,			previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXSuperStartSyntaxMode,				kiTM2TeXRegularSyntaxMode,			previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXSuperContinueSyntaxMode,			kiTM2TeXRegularSyntaxMode,			previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXSuperShortSyntaxMode,				kiTM2TeXRegularSyntaxMode,			previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXSuperscriptSyntaxMode,				kiTM2TeXRegularSyntaxMode,			previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXCellSeparatorSyntaxMode,			kiTM2TeXRegularSyntaxMode,			previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXUnknownSyntaxMode,					kiTM2TeXRegularSyntaxMode,			previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXErrorSyntaxMode,					kiTM2TeXRegularSyntaxMode,			previousModifier, kiTM2TeXNoErrorSyntaxStatus);
					default:
						newMode = kiTM2TeXRegularSyntaxMode;
						newModifier = previousModifier;
						status = kiTM2TeXNoErrorSyntaxStatus;
						break;
				}
				* newModeRef = newMode | previousError | newModifier;
				return status ;
            
#pragma mark =-=-=-=-=- '".
            case '\'':
            case '"':
            case '.':
                switch(previousModeWithoutModifiers)
                {
CASE(kiTM2TeXWhitePrefixSyntaxMode,				kiTM2TeXRegularSyntaxMode,			previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXRegularSyntaxMode,					kiTM2TeXRegularSyntaxMode,			previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXCommandStartSyntaxMode,			kiTM2TeXCommandEscapedCharacterSyntaxMode,	previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXCommandEscapedCharacterSyntaxMode,	kiTM2TeXRegularSyntaxMode,			previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXCommandContinueSyntaxMode,			kiTM2TeXRegularSyntaxMode,			previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXCommandInputSyntaxMode,			kiTM2TeXErrorSyntaxMode,			previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXGroupOpenSyntaxMode,				kiTM2TeXRegularSyntaxMode,			previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXGroupCloseSyntaxMode,				kiTM2TeXRegularSyntaxMode,			previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXParenOpenSyntaxMode,				kiTM2TeXRegularSyntaxMode,			previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXParenCloseSyntaxMode,				kiTM2TeXRegularSyntaxMode,			previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXBracketOpenSyntaxMode,				kiTM2TeXRegularSyntaxMode,			previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXBracketCloseSyntaxMode,			kiTM2TeXRegularSyntaxMode,			previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXCommentStartSyntaxMode,			kiTM2TeXCommentContinueSyntaxMode,	previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXCommentContinueSyntaxMode,			previousModeWithoutModifiers,		previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXMarkSyntaxMode,					kiTM2TeXMarkContinueSyntaxMode,		previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXMarkContinueSyntaxMode,			previousModeWithoutModifiers,		previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXMathSwitchSyntaxMode,				kiTM2TeXRegularSyntaxMode,			previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXMathSwithContinueSyntaxMode,		kiTM2TeXRegularSyntaxMode,			previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXMathInlineBeginSyntaxMode,			kiTM2TeXRegularSyntaxMode,			previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXMathInlineEndSyntaxMode,			kiTM2TeXRegularSyntaxMode,			previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXMathDisplayBeginSyntaxMode,		kiTM2TeXRegularSyntaxMode,			previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXMathDisplayEndSyntaxMode,			kiTM2TeXRegularSyntaxMode,			previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXSubStartSyntaxMode,				kiTM2TeXRegularSyntaxMode,			previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXSubShortSyntaxMode,				kiTM2TeXRegularSyntaxMode,			previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXSubscriptSyntaxMode,				kiTM2TeXRegularSyntaxMode,			previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXSuperStartSyntaxMode,				kiTM2TeXSuperShortSyntaxMode,		previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXSuperContinueSyntaxMode,			kiTM2TeXSuperShortSyntaxMode,		previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXSuperShortSyntaxMode,				kiTM2TeXRegularSyntaxMode,			previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXSuperscriptSyntaxMode,				kiTM2TeXRegularSyntaxMode,			previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXCellSeparatorSyntaxMode,			kiTM2TeXRegularSyntaxMode,			previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXUnknownSyntaxMode,					previousModeWithoutModifiers,		previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXErrorSyntaxMode,					previousModeWithoutModifiers,		previousModifier, kiTM2TeXNoErrorSyntaxStatus);
					default:
						newMode = kiTM2TeXRegularSyntaxMode;
						newModifier = previousModifier & ~kiTM2TeXCommandSyntaxMask;
						status = kiTM2TeXNoErrorSyntaxStatus;
						break;
				}
				* newModeRef = newMode | previousError | newModifier;
				return status ;
            
#pragma mark =-=-=-=-=- default
            default:
            {
//NSLog(@"Non letter character: %@", [NSString stringWithCharacters: &theChar length:1]);
                switch(previousModeWithoutModifiers)
                {
CASE(kiTM2TeXWhitePrefixSyntaxMode,				kiTM2TeXRegularSyntaxMode,					previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXRegularSyntaxMode,					kiTM2TeXRegularSyntaxMode,					previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXCommandStartSyntaxMode,			kiTM2TeXCommandEscapedCharacterSyntaxMode,	previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXCommandEscapedCharacterSyntaxMode,	kiTM2TeXRegularSyntaxMode,					previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXCommandContinueSyntaxMode,			kiTM2TeXRegularSyntaxMode,					previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXCommandInputSyntaxMode,			kiTM2TeXRegularSyntaxMode,					previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXGroupOpenSyntaxMode,				kiTM2TeXRegularSyntaxMode,					previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXGroupCloseSyntaxMode,				kiTM2TeXRegularSyntaxMode,					previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXParenOpenSyntaxMode,				kiTM2TeXRegularSyntaxMode,					previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXParenCloseSyntaxMode,				kiTM2TeXRegularSyntaxMode,					previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXBracketOpenSyntaxMode,				kiTM2TeXRegularSyntaxMode,					previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXBracketCloseSyntaxMode,			kiTM2TeXRegularSyntaxMode,					previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXCommentStartSyntaxMode,			kiTM2TeXCommentContinueSyntaxMode,			previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXCommentContinueSyntaxMode,			previousModeWithoutModifiers,				previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXMarkSyntaxMode,					kiTM2TeXMarkContinueSyntaxMode,				previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXMarkContinueSyntaxMode,			previousModeWithoutModifiers,				previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXMathSwitchSyntaxMode,				kiTM2TeXRegularSyntaxMode,					previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXMathSwithContinueSyntaxMode,		kiTM2TeXRegularSyntaxMode,					previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXMathInlineBeginSyntaxMode,			kiTM2TeXRegularSyntaxMode,					previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXMathInlineEndSyntaxMode,			kiTM2TeXRegularSyntaxMode,					previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXMathDisplayBeginSyntaxMode,		kiTM2TeXRegularSyntaxMode,					previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXMathDisplayEndSyntaxMode,			kiTM2TeXRegularSyntaxMode,					previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXSubStartSyntaxMode,				kiTM2TeXSubShortSyntaxMode,					previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXSubShortSyntaxMode,				kiTM2TeXRegularSyntaxMode,					previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXSubscriptSyntaxMode,				kiTM2TeXRegularSyntaxMode,					previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXSuperStartSyntaxMode,				kiTM2TeXSuperShortSyntaxMode,				previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXSuperContinueSyntaxMode,			kiTM2TeXSuperShortSyntaxMode,				previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXSuperShortSyntaxMode,				kiTM2TeXRegularSyntaxMode,					previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXSuperscriptSyntaxMode,				kiTM2TeXRegularSyntaxMode,					previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXCellSeparatorSyntaxMode,			kiTM2TeXRegularSyntaxMode,					previousModifier & ~kiTM2TeXCommandSyntaxMask, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXUnknownSyntaxMode,					previousModeWithoutModifiers,				previousModifier, kiTM2TeXNoErrorSyntaxStatus);
CASE(kiTM2TeXErrorSyntaxMode,					previousModeWithoutModifiers,				previousModifier, kiTM2TeXNoErrorSyntaxStatus);
					default:
						newMode = previousModeWithoutModifiers;
						newModifier = previousModifier & ~kiTM2TeXCommandSyntaxMask;
						break;
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
}
#if 1
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
    NSParameterAssert(location<[S length]);
	NSString * substring;
	NSRange r;
	unsigned status;
//	unsigned previousError = previousMode & kiTM2TeXErrorSyntaxMask;
//	unsigned previousModifier = previousMode & kiTM2TeXModifiersSyntaxMask;
	unsigned previousModeWithoutModifiers = previousMode & ~kiTM2TeXFlagsSyntaxMask;
	unichar theChar = [S characterAtIndex:location];
	if(kiTM2TeXCommandStartSyntaxMode == previousModeWithoutModifiers)
	{
		NSCharacterSet * set = [NSCharacterSet TeXLetterCharacterSet];
		if([set characterIsMember:theChar])
		{
			// is it a \input
			// scanning from location for the control sequence name
			unsigned start = location;
			unsigned end = start+1;
			while(end<[S length] && ((theChar = [S characterAtIndex:end]),[set characterIsMember:theChar]))
				++end;
			if(end == start+5)
			{
				r = NSMakeRange(start, end-start);
				substring = [S substringWithRange:r];
				if([@"input" isEqualToString:substring])
				{
					if(lengthRef)
					{
						* lengthRef = end-start;
					}
					if(nextModeRef && (end<[S length]))
					{
						theChar = [S characterAtIndex:end];
						status = [self getSyntaxMode:nextModeRef forCharacter:theChar previousMode:kiTM2TeXCommandInputSyntaxMode];
					}
					// now we invalidate the cursor rects in order to have the links properly displayed
					//the delay is due to the reentrant problem
					[_TextStorage performSelector:@selector(invalidateCursorRects) withObject:nil afterDelay:0.01];
					* newModeRef = kiTM2TeXCommandInputSyntaxMode;
					return kiTM2TeXNoErrorSyntaxStatus;
				}
			}
			if(lengthRef)
			{
				* lengthRef = end-start;
			}
			if(nextModeRef)
			{
				* nextModeRef = kiTM2TeXUnknownSyntaxMode;
			}
			* newModeRef = kiTM2TeXCommandContinueSyntaxMode | kiTM2TeXCommandSyntaxMask;
			return kiTM2TeXNoErrorSyntaxStatus;
		}
	}
	if(theChar == '@')
	{
		// get the range of characters
		
	}
	else if(theChar == '(')
	{
		
	}
	else if(theChar == ')')
	{
		
	}
	status = [self getSyntaxMode:newModeRef forCharacter:theChar previousMode:previousMode];
	if(lengthRef) // && (previousMode != kiTM2TeXCommandStartSyntaxMode) || ![set characterIsMember:theChar]
	{
		* lengthRef = 1;
		if(kiTM2TeXCommandStartSyntaxMode != *newModeRef)
		{
//NSLog(@"0: character: %@", [NSString stringWithCharacters: &C length:1]);
//NSLog(@"1: nextMode: %u, previousMode: %u", nextMode, previousMode);
			beforeIndex = MIN(beforeIndex, [S length]);
			while(++location < beforeIndex)
			{
				previousMode = *newModeRef;
				theChar = [S characterAtIndex:location];
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
	unsigned fullMode;
    unsigned lineIndex = [self lineIndexForLocation:aLocation];
    iTM2ModeLine * modeLine = [self modeLineAtIndex:lineIndex];
	NSRange range;
    //unsigned status = 
	[modeLine getSyntaxMode:&fullMode atGlobalLocation:aLocation longestRange:&range];
    if(aRangePtr)
	{
		*aRangePtr = range;
	}
	unsigned int modeWithoutModifiers = fullMode & ~kiTM2TeXFlagsSyntaxMask;
	unsigned outRangeStart = range.location;
	unsigned outRangeStop = NSMaxRange(range);
	unsigned outMode = modeWithoutModifiers;

	NSString * S = [_TextStorage string];
#ifdef iTM2_WITH_SYMBOLS
	NSString * substring;
#endif
	unsigned otherMode;
	unsigned otherFullMode;
	NSString * modeName;
	NSDictionary * attributes;
	unsigned index;
	
	NSString * ERROR;
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
			else if((otherMode == kiTM2TeXCommandEscapedCharacterSyntaxMode) || (otherMode == kiTM2TeXCommandContinueSyntaxMode))
			{
				outMode = otherMode;
				outRangeStop = NSMaxRange(range);
#ifdef iTM2_WITH_SYMBOLS
fullCommand:
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
				iTM2_ATTRIBUTE_ASSERT(otherFullMode&kiTM2TeXCommandSyntaxMask,@"This should be a command tagged {");
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
				substring = [S substringWithRange:range];
				if(attributes = [_AS attributesForSymbol:substring])
				{
//iTM2_LOG(@"aLocation:%i, range:%@, substring:%@",aLocation,NSStringFromRange(range),substring);
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
            index = [modeLine endOffset];
            if(aRangePtr)
                * aRangePtr = NSMakeRange(aLocation, index-aLocation);
            index = [modeLine contentsEndOffset];
            if(++aLocation < index)
			{
                return [self attributesAtIndex:aLocation effectiveRange:nil];// this is where the mark attributes are catched
			}
            else
			{
				modeName = [_iTM2TeXModeForModeArray objectAtIndex:kiTM2TeXCommentContinueSyntaxMode];
                return [_AS attributesForMode:modeName];
			}

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
#ifdef iTM2_WITH_SYMBOLS
	substring = [S substringWithRange:range];// out of range in the extended latex mode
	if(attributes = [_AS attributesForSymbol:substring])
	{
		if(iTM2DebugEnabled>9999)
		{
			iTM2_LOG(@"aLocation:%i, range:%@, substring:%@",aLocation,NSStringFromRange(range),substring);
		}
		return attributes;
	}
#endif
	modeName = [_iTM2TeXModeForModeArray objectAtIndex:outMode];
	if(iTM2DebugEnabled>9999)
	{
		iTM2_LOG(@"aLocation:%i, range:%@, modeName:%@",aLocation,NSStringFromRange(range),modeName);
	}
	return [_AS attributesForMode:modeName];
	
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
	modeName = [_iTM2TeXModeForModeArray objectAtIndex:kiTM2TeXErrorSyntaxMode];
	return [_AS attributesForMode:modeName];
}
#if 0
@end
#endif
#undef iTM2_WITH_SYMBOLS
