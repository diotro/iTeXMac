/*
//  iTeXMac2 1.4
//
//  @version Subversion: $Id$ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Tue May  4 19:35:54 GMT 2004.
//  Copyright © 2003 Laurens'Tribune. All rights reserved.
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

#import <Cocoa/Cocoa.h>
#import "iTM2SpellKit.h"

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2ProjectSpellKit

@interface NSDocument(iTM2SpellKit)

/*!
    @method		spellContextController
    @abstract	The spelling context controller.
    @discussion	The spelling context is defined by the language, and the lists of know words.
                Each logically different context is defined by a unique NSString key.
                Many different texts can share the same spelling context,
                and a single text split can be made of different parts
                each one having its own different spelling contexts depending on the part of the text.
                Any object has at least the shared spell context controller.
                A NSText object inherits its spelling context controller from its window.
                A NSWindow object inherits its spelling context controller from its window controller.
                A NSWindowController object inherits its spelling context controller
                from its document if any or from its owner if any.
                All these default behaviours might be overriden by subclassers.
    @parameter	None.
    @result		A spell context controller.
*/
- (iTM2SpellContextController *)spellContextController;

@end

@interface iTM2ProjectDocument(ProjectSpellKit)

/*!
    @method		spellKitCompleteDidReadFromURL4iTM3:ofType:error:
    @abstract	Hook point.
    @discussion	The default implementation initiates the spell context controller.
				Subclassers will take appropriate actions here.
    @parameter	Usual fileName.
    @parameter	Usual document type.
    @parameter	error.
    @result		None.
*/
- (void)spellKitCompleteDidReadFromURL4iTM3:(NSURL *) fileURL ofType:(NSString *) type error:(NSError**)RORef;

@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2ProjectSpellKit
