/*
//  iTeXMac2 1.4
//
//  @version Subversion: $Id$ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Wed Sep 15 21:07:40 GMT 2004.
//  Copyright © 2004 Laurens'Tribune. All rights reserved.
//
//  This program is free software; you can redistribute it and/or modify it under the terms
//  of the GNU General Public License as published by the Free Software Foundation; either
//  version 2 of the License, or any later version, modified by the addendum below.
//  This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
//  without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
//  See the GNU General Public License for more details. You should have received a copy
//  of the GNU General Public License along with this program; if not, write to the Free Software
//  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
//  GPL addendum:Any simple modification of the present code which purpose is to remove bug,
//  improve efficiency in both code execution and code reading or writing should be addressed
//  to the actual developper team.
//
//  Version history:(format "- date:contribution(contributor)") 
//  To Do List:(format "- proposition(percentage actually done)")
*/

#ifdef __iTM2_NO_XTD_SPELL__
#warning *** NO PROJECT XTD SPELL
#else
#endif
#if 1
#import "iTM2SpellKit.h"
#import "iTM2ProjectDocumentKit.h"
#import "iTM2InfoWrapperKit.h"

@implementation iTM2SpellContextController(Project)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  spellPrettyProjectNameForText:
- (NSString *)spellPrettyProjectNameForText:(NSText *) text;
/*"Description forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- 1.4:Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [[SPC projectForSource:text] displayName]?:@"";
}
@end

@implementation NSDocument(iTM2SpellKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  spellContextController
- (id)spellContextController;
/*"Asks the document or the owner.
Version history:jlaurens AT users DOT sourceforge DOT net
- 1.4:Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [[self project] spellContextController]?:[super spellContextController];
}
@end

@implementation iTM2ProjectDocument(ProjectSpellKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  spellContextController
- (id)spellContextController;
/*"Asks the document or the owner.
Version history:jlaurens AT users DOT sourceforge DOT net
- 1.4:Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return metaGETTER;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  setSpellContextController
- (void)setSpellContextController:(id) controller;
/*"Asks the document or the owner.
Version history:jlaurens AT users DOT sourceforge DOT net
- 1.4:Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	metaSETTER(controller);
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  spellKitMetaFixImplementation:
- (void)spellKitMetaFixImplementation;
/*"Asks the document or the owner.
Version history:jlaurens AT users DOT sourceforge DOT net
- 1.4:Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(![self spellContextController])
	{
		[self setSpellContextController:[[[iTM2SpellContextController alloc] init] autorelease]];
	}
//iTM2_LOG(@"[self spellContextController]:%@", [self spellContextController]);
	id O = [self metaInfoForKeyPaths:@"SpellContextModes",nil];
//iTM2_LOG(@"SPELL KIT MODEL TO BE LOADED:%@", O);
	if([O isKindOfClass:[NSDictionary class]])
		[[self spellContextController] loadPropertyListRepresentation:O];
	else if(O)
	{
		iTM2_LOG(@"WARNING:A dictionary was expected instead of %@", O);
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  spellKitCompleteDidReadFromURL:ofType:error:
- (void)spellKitCompleteDidReadFromURL:(NSURL *) fileURL ofType:(NSString *) type error:(NSError**)outErrorPtr;
/*"Asks the document or the owner.
Version history:jlaurens AT users DOT sourceforge DOT net
- 1.4:Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id O = [self metaInfoForKeyPaths:@"SpellContextModes",nil];
//iTM2_LOG(@"SPELL KIT MODEL TO BE LOADED:%@", O);
	if([O isKindOfClass:[NSDictionary class]])
	{
		[[self spellContextController] loadPropertyListRepresentation:O];
		// actively updates the spell checker panel, including the language
		// delay the message to let the receiver finish its setting
		[SCH synchronizeWithCurrentText];
	}
	else if(O)
	{
		iTM2_LOG(@"WARNING:A dictionary was expected instead of %@", O);
	}
//iTM2_END;
    return;
}
#if 1
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  prepareSpellKitMetaCompleteWriteToURL:ofType:error:
- (BOOL)prepareSpellKitMetaCompleteWriteToURL:(NSURL *)fileURL ofType:(NSString *) type error:(NSError**)outErrorPtr;
/*"Description forthcoming.
Version History:jlaurens AT users DOT sourceforge DOT net
- 1.4:Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_LOG(@"SPELL KIT MODEL TO BE SAVED:%@", [[self spellContextController] propertyListRepresentation]);
	[self setMetaInfo:[[self spellContextController] propertyListRepresentation] forKeyPaths:@"SpellContextModes",nil];
    return YES;
}
#endif
@end
#endif
