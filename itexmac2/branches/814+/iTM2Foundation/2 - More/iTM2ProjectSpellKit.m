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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  spellPrettyProjectNameForText:error:
- (NSString *)spellPrettyProjectNameForText:(NSText *) text error:(NSError **)RORef;
/*"Description forthcoming.
Version history:jlaurens AT users DOT sourceforge DOT net
- 1.4:Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [[SPC projectForSource:text error:RORef] displayName]?:@"";
}
@end

@implementation NSDocument(iTM2SpellKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  spellContextController4iTM3Error:
- (id)spellContextController4iTM3Error:(NSError **)RORef;
/*"Asks the document or the owner.
Version history:jlaurens AT users DOT sourceforge DOT net
- 1.4:Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [[self project4iTM3Error:RORef] spellContextController4iTM3Error:RORef]?:[super spellContextController4iTM3Error:RORef];
}
@end

@implementation iTM2ProjectDocument(ProjectSpellKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  spellContextController4iTM3Error:
- (id)spellContextController4iTM3Error:(NSError **)RORef;
/*"Asks the document or the owner.
Version history:jlaurens AT users DOT sourceforge DOT net
- 1.4:Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return metaGETTER;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  setSpellContextController
- (void)setSpellContextController:(id) controller;
/*"Asks the document or the owner.
Version history:jlaurens AT users DOT sourceforge DOT net
- 1.4:Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	metaSETTER(controller);
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  spellKitMetaFixImplementation4iTM3:
- (void)spellKitMetaFixImplementation4iTM3;
/*"Asks the document or the owner.
Version history:jlaurens AT users DOT sourceforge DOT net
- 1.4:Wed Sep 15 21:07:40 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (![self spellContextController4iTM3Error:self.RORef4iTM3]) {
		[self setSpellContextController:iTM2SpellContextController.new];
	}
//LOG4iTM3(@"self.spellContextController4iTM3Error:RORef:%@", self.spellContextController4iTM3Error:RORef);
	id O = [self metaInfo4iTM3ForKeyPaths:@"SpellContextModes",nil];
//LOG4iTM3(@"SPELL KIT MODEL TO BE LOADED:%@", O);
	if ([O isKindOfClass:[NSDictionary class]])
		[[self spellContextController4iTM3Error:self.RORef4iTM3] loadPropertyListRepresentation:O];
	else if (O) {
		LOG4iTM3(@"WARNING:A dictionary was expected instead of %@", O);
	}
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  spellKitCompleteDidReadFromURL4iTM3:ofType:error:
- (BOOL)spellKitCompleteDidReadFromURL4iTM3:(NSURL *) fileURL ofType:(NSString *)type error:(NSError**)RORef;
/*"Asks the document or the owner.
Version history:jlaurens AT users DOT sourceforge DOT net
Révisé par itexmac2: 2010-12-05 22:16:19 +0100
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	id O = [self metaInfo4iTM3ForKeyPaths:@"SpellContextModes",nil];
//LOG4iTM3(@"SPELL KIT MODEL TO BE LOADED:%@", O);
	if ([O isKindOfClass:[NSDictionary class]]) {
		[[self spellContextController4iTM3Error:RORef] loadPropertyListRepresentation:O];
		// actively updates the spell checker panel, including the language
		// delay the message to let the receiver finish its setting
		[SCH synchronizeWithCurrentText];
	} else if (O) {
		LOG4iTM3(@"WARNING:A dictionary was expected instead of %@", O);
	} else {
        return [[self spellContextController4iTM3Error:RORef] readFromURL:fileURL error:RORef];
    }
//END4iTM3;
    return YES;
}
#if 1
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  prepareSpellKitCompleteWriteMetaToURL4iTM3:ofType:error:
- (BOOL)prepareSpellKitCompleteWriteMetaToURL4iTM3:(NSURL *)fileURL ofType:(NSString *) type error:(NSError**)RORef;
/*"Description forthcoming.
Version History:jlaurens AT users DOT sourceforge DOT net
Révisé par itexmac2: 2010-12-05 22:16:27 +0100
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//LOG4iTM3(@"SPELL KIT MODEL TO BE SAVED:%@", [self.spellContextController4iTM3Error:RORef propertyListRepresentation]);
	[self setMetaInfo4iTM3:[[self spellContextController4iTM3Error:RORef] propertyListRepresentation] forKeyPaths:@"SpellContextModes",nil];
    return YES;
}
#endif
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  spellKitCompleteWriteMetaToURL4iTM3:ofType:error:
- (BOOL)spellKitCompleteWriteMetaToURL4iTM3:(NSURL *)fileURL ofType:(NSString *)type error:(NSError**)RORef;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [[self spellContextController4iTM3Error:RORef] writeToURL:fileURL error:RORef];
}
@end
#endif
