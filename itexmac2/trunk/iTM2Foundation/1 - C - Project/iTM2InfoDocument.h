/*
//
//  @version Subversion: $Id: iTM2InfoDocumentKit.h 574 2007-10-08 23:21:41Z jlaurens $ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Tue Sep 11 2001.
//  Copyright © 2001-2004 Laurens'Tribune. All rights reserved.
//
//  This program is free software; you can redistribute it and/or modify it under the terms
//  of the GNU General public License as published by the Free Software Foundation; either
//  version 2 of the License, or any later version, modified by the addendum below.
//  This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
//  without even the implied warranty of MERCHANTABILITY or FITNESS FOR A pARTICULAR pURPOSE.
//  See the GNU General public License for more details. You should have received a copy
//  of the GNU General public License along with this program; if not, write to the Free Software
//  Foundation, Inc., 59 Temple place - Suite 330, Boston, MA 02111-1307, USA.
//  GPL addendum: Any simple modification of the present code which purpose is to remove bug,
//  improve efficiency in both code execution and code reading or writing should be addressed
//  to the actual developper team.
//
//  Version history: (format "- date:contribution(contributor)") 
//  To Do List: (format "- proposition(percentage actually done)")
*/

@interface iTM2InfoDocument: iTM2Document

/*!
	@method			defaultTrailer
	@abstract		Default trailer.
	@discussion		More than just a file extension.
	@param			This is useful for projects that contain the info.plist deep inside.
					They need not know where this file will be stored
	@param			None
	@result			None
	@availability	iTM2.
	@copyright		2007 jlaurens AT users DOT sourceforge DOT net and others.
*/
+ (NSString *)defaultTrailer;

/*!
	@method			initWithContentsOfURL:error:
	@abstract		Designated initializer.
	@discussion		This is just a wrapper over a standard property list object.
	@param			absoluteURL is the absolute URL of the forthcoming document.
					If the given URL does not have the expected default trailer and points to a directory,
					the <code>+defaultTrailer</code> is appended.
					If no URL is given, just the model will be created.
	@result			a document or nil in case or error.
	@availability	iTM2.
	@copyright		2007 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (id)initWithContentsOfURL:(NSURL *)absoluteURL error:(NSError **)outError;

/*!
	@method			model
	@abstract		Abstract forthcoming.
	@discussion		Discussion forthcoming.
	@param			None
	@result			a mutable property list dictionary.
	@availability	iTM2.
	@copyright		2007 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (id)model;

/*!
	@method			setModel:
	@abstract		Abstract forthcoming.
	@discussion		Discussion forthcoming.
	@param			None
	@result			a mutable property list dictionary.
	@availability	iTM2.
	@copyright		2007 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (void)setModel:(id)model;

@end
