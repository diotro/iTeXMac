// iTM2ARegexpHelpers.h
// iTM2Kit
//
// Copyright © 1996-2002, Jerome LAURENS by Mike Ferris.  All rights reserved.
// See bottom of file for license and disclaimer.

// These functions implement a few utilities that the regexp package needs.

typedef unsigned short iTM2Unichar;

unsigned char iTM2UniCharIsAlnum(iTM2Unichar x);
unsigned char iTM2UniCharIsAlpha(iTM2Unichar x);
unsigned char iTM2UniCharIsDigit(iTM2Unichar x);
unsigned char iTM2UniCharIsSpace(iTM2Unichar x);

	iTM2Unichar iTM2UniCharToLower(iTM2Unichar c);
	iTM2Unichar iTM2UniCharToUpper(iTM2Unichar c);
	iTM2Unichar iTM2UniCharToTitle(iTM2Unichar c);


/*
 This file contains Original Code and/or Modifications of Original Code as defined in and that are subject to the Ferris Public Source License Version 1.2 (the 'License'). You may not use this file except in compliance with the License. Please obtain a copy of the License at http://mokit.sourceforge.net/License.html and read it before using this file.

 The Original Code and all software distributed under the License are distributed on an 'AS IS' basis, WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESS OR IMPLIED, AND MIKE FERRIS HEREBY DISCLAIMS ALL SUCH WARRANTIES, INCLUDING WITHOUT LIMITATION, ANY WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, QUIET ENJOYMENT OR NON-INFRINGEMENT. Please see the License for the specific language governing rights and limitations under the License.
 */
