/*
//  iTM2ConTeXtPrefsKit.h
//  iTeXMac2
//
//  @version Subversion: $Id$ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net today.
//  Copyright © 2005 Laurens'Tribune. All rights reserved.
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

@interface iTM2ConTeXtPrefsPane: iTM2PreferencePane <NSTableViewDelegate, NSTableViewDataSource>
{
}
@end

@end

@interface NSApplication(iTM2ConTeXtPrefsKit)
/*!
	@method			showConTeXtPrefs:
	@abstract		Abstract forthcoming.
	@discussion		Discussion forthcoming.
	@result			(description)
	@availability	iTM2.
	@copyright		2005 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (IBAction)showConTeXtPrefs:(id)sender;
/*!
	@method			showConTeXtManualsPrefs:
	@abstract		Abstract forthcoming.
	@discussion		Discussion forthcoming.
	@result			(description)
	@availability	iTM2.
	@copyright		2005 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (IBAction)showConTeXtManualsPrefs:(id)sender;
@end

@interface iTM2ConTeXtManualsFormatter: iTM2StringFormatter
@end
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2ConTeXtKit  =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

