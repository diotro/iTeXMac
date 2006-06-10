/*
//  iTM2AppleScriptSupport.m
//  iTeXMac2
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Tue Jan  4 07:48:24 GMT 2005.
//  Copyright © 2005 Laurens'Tribune. All rights reserved.
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

#import "iTM2AppleScriptSupport.h"

@implementation NSApplication(iTM2AppleScriptSupport)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  projects
- (NSArray *) projects;// get the project documents of application "iTeXMac2"
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (10/04/2001)
- 2.0: Fri Apr 16 11:39:43 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	return [SPC projects];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertInProjects:
- (void) insertInProjects: (id) argument;// make new project document
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (10/04/2001)
- 2.0: Fri Apr 16 11:39:43 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[SDC addDocument: argument];
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  orderedTeXDocuments:
- (id) orderedTeXDocuments;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (02/06/2002)
- 1.1: 06/01/2002
To Do List:
"*/
{
    NSEnumerator * E = [[self orderedDocuments] objectEnumerator];
    NSDocument * D;
    NSMutableArray * MA = [NSMutableArray array];
    while(D = [E nextObject])
    {
        if(([D isKindOfClass: [iTM2TeXDocument class]]) && ([MA indexOfObject: D] == NSNotFound))
            [MA addObject: D];
    }
    return [[MA copy] autorelease];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertInOrderedTeXDocuments:atIndex:
- (void) insertInOrderedTeXDocuments: (NSDocument *) document atIndex: (int) index;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (02/06/2002)
- 1.1: 06/01/2002
To Do List:
"*/
{
    if([document isKindOfClass: [iTM2TeXDocument class]])
    {
        
        if([[self orderedTeXDocuments] indexOfObject: document] == NSNotFound)
            [SDC addDocument: document];
        
        if(index == 0)
        {
            [document makeWindowControllers];
            {
                NSEnumerator * E = [[document windowControllers] objectEnumerator];
                NSWindowController * WC;
                while(WC = [E nextObject])
                {
                    [[WC window] orderFront: self];
                }
            }
        }
    }
    return;
}
@end

@implementation NSDocument(iTM2AppleScriptSupport)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  orderedWindows
- (NSArray *) orderedWindows;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (10/04/2001)
- 2.0: Fri Apr 16 11:39:43 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self makeWindowControllers];
	NSMutableArray * mra = [NSMutableArray array];
	NSEnumerator * E = [[self windowControllers] objectEnumerator];
	NSWindowController * WC;
	NSWindow * W;
	while(WC = [E nextObject])
		if(W = [WC window])
			[mra addObject: W];
//iTM2_END;
	return mra;
}
@end

@implementation iTM2TeXProjectDocument(iTM2AppleScriptSupport)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  TeXDocumentsArray
- (NSArray *) TeXDocumentsArray;// make new project document
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (10/04/2001)
- 2.0: Fri Apr 16 11:39:43 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSMutableArray * mra = [NSMutableArray array];
	NSEnumerator * E = [[self subdocuments] objectEnumerator];
	id document;
	while(document = [E nextObject])
		if([document isKindOfClass: [iTM2TeXDocument class]])
			[mra addObject: document];
//iTM2_END;
	return mra;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  PDFDocumentsArray
- (NSArray *) PDFDocumentsArray;// make new project document
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (10/04/2001)
- 2.0: Fri Apr 16 11:39:43 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSMutableArray * mra = [NSMutableArray array];
	NSEnumerator * E = [[self subdocuments] objectEnumerator];
	id document;
	while(document = [E nextObject])
		if([document isKindOfClass: [iTM2PDFDocument class]])
			[mra addObject: document];
//iTM2_END;
	return mra;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  projectDocumentsArray
- (NSArray *) projectDocumentsArray;// make new project document
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (10/04/2001)
- 2.0: Fri Apr 16 11:39:43 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	return [[self subdocuments] allObjects];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertInSubdocumentsArray:
- (void) insertInSubdocumentsArray: (id) argument;// make new document
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (10/04/2001)
- 2.0: Fri Apr 16 11:39:43 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self addSubdocument: argument];
//iTM2_END;
	return;
}
@end

@interface NSGetCommand_iTM2 : NSGetCommand
@end
@implementation NSGetCommand_iTM2
+ (void) load;
{
	[NSGetCommand_iTM2 poseAsClass: [NSGetCommand class]];
}
- (id) performDefaultImplementation;
{
	return [super performDefaultImplementation];
}
- (id)executeCommand;
{
	return [super executeCommand];
}
@end
//NSReceiverEvaluationScriptError

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTMTeXScriptCommands
/*"Description forthcoming."*/

NSString * const iTM2ApplFileNameKey = @"File";// the name of AppleScript argument
NSString * const iTM2ApplProjectNameKey = @"Project";// the name of AppleScript argument

#define DEF_CMD(CLASS,KEY)\
@interface CLASS: NSScriptCommand\
@end\
@implementation CLASS\
- (id) performDefaultImplementation;\
{\
	NSString * path = [[self directParameter] stringByStandardizingPath];\
	if(![DFM isReadableFileAtPath: path])\
    {\
        path = [[[self evaluatedArguments] objectForKey: iTM2ApplFileNameKey] stringByStandardizingPath];\
        if(![DFM isReadableFileAtPath: path])\
        {\
            NSLog(@"No readable file at path: %@", path);\
            return nil;\
        }\
    }\
    NSString * project = [[self evaluatedArguments] objectForKey: iTM2ApplProjectNameKey];\
	[[iTM2TeXPCommandManager commandPerformerForName: KEY] performCommandForProject: [SPC projectForSource: project]];\
    return nil;\
}\
@end

DEF_CMD(iTM2CompileCommand, @"Compile")
DEF_CMD(iTM2TypesetCommand, @"Typeset")
DEF_CMD(iTM2BibliographyCommand, @"Bibliography")
DEF_CMD(iTM2GlossaryCommand, @"Glossary")
DEF_CMD(iTM2IndexCommand, @"Index")
DEF_CMD(iTM2StopCommand, @"Stop")
DEF_CMD(iTM2SpecialCommand, @"Special")

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTMTeXScriptCommands

