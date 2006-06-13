/*
//  iTM2_Server_main.m 
//
//  @version Subversion: $Id$ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Sat Jan 15 15:36:51 GMT 2005.
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

#import <Cocoa/Cocoa.h>

#include "iTM2ServerKeys.m"

BOOL LaunchiTeXMac2IfNeeded(int argc, const char *argv[]);
void iTeXMac2Usage(int argc, const char *argv[]);

int main(int argc, const char *argv[])
{
    iTM2_INIT_POOL;
    int index = 0;
    while(++index<argc)
    {
#pragma mark =-=-=-=-=-  open
        const char * conversation = "";
        if(!strcmp(argv[index], "open"))
        {
//NSLog(@"***  EDIT");
            const char * projectName = "";
            const char * fileName = "";
            while(++index < argc)
            {
                if(!strcmp(argv[index], "-project"))
                {
                    if(++index<argc)
                        projectName = argv[index];
                    else
                    {
                        NSLog(@"!  iTeXMac2 server error: missing project name");
                        goto bail;
                    }
                }
				else if(!strcmp(argv[index], "-file"))
                {
                    if(++index<argc)
                        fileName = argv[index];
                    else
                    {
                        NSLog(@"!  iTeXMac2 server error: missing file name");
                        goto bail;
                    }
                }
                else
                {
                    NSLog(@"!  iTeXMac2 server warning: next arguments are ignored");
                }
            }
            if(strlen(fileName) && LaunchiTeXMac2IfNeeded(argc, argv))
            {
                NSString * conversationID = [NSString stringWithUTF8String: conversation];
                NSString * PWD = [[[NSProcessInfo processInfo] environment] objectForKey: @"PWD"];
//NSLog(@"PWD: %@", PWD);
                NSString * path = [[NSString stringWithUTF8String: fileName] stringByStandardizingPath];
//NSLog(@"Editing file: %@", path);
                NSMutableDictionary * MD = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                    ([path hasPrefix: @"/"]? path:
                        [[PWD stringByAppendingPathComponent: path] stringByStandardizingPath]), iTM2ServerFileKey,
                    conversationID, iTM2ServerConversationIDKey,
                            nil];
				[MD setObject: [[NSProcessInfo processInfo] environment] forKey: iTM2ProcessInfoEnvironmentKey];
                if(strlen(projectName))
                    [MD setObject: [[NSString stringWithUTF8String: projectName] stringByStandardizingPath] forKey: iTM2ServerProjectKey];
                [[NSDistributedNotificationCenter defaultCenter]
                    postNotificationName: iTM2ServerShouldOpenFileNotification
                        object: nil
                            userInfo: MD
                                deliverImmediately: YES];
            }
            else
            {
                NSLog(@"!  iTeXMac2 server error: void file name.");
                goto bail;
            }
//    printf("iTM2TextEditorShouldOpenTextFile distributed notification posted\nfile: <%s>, line: <%s>", fileName, lineNumber);
            iTM2_RELEASE_POOL;
            return 0;
        }
#pragma mark =-=-=-=-=-  open
        else if(!strcmp(argv[index], "edit"))
        {
//NSLog(@"***  EDIT");
            const char * projectName = "";
            const char * fileName = "";
            const char * lineNumber = "";
            const char * columnNumber = "";
			BOOL dontOrderFront = NO;
            while(++index < argc)
            {
                if(!strcmp(argv[index], "-project"))
                {
                    if(++index<argc)
                        projectName = argv[index];
                    else
                    {
                        NSLog(@"!  iTeXMac2 server error: missing project name");
                        goto bail;
                    }
                }
                else if(!strcmp(argv[index], "-file"))
                {
                    if(++index<argc)
                        fileName = argv[index];
                    else
                    {
                        NSLog(@"!  iTeXMac2 server error: missing file name");
                        goto bail;
                    }
                }
                else if (!strcmp(argv[index], "-line"))
                {
                    if(++index<argc)
                        lineNumber = argv[index];
                    else
                    {
                        NSLog(@"!  iTeXMac2 server error: missing line number");
                        goto bail;
                    }
                }
                else if (!strcmp(argv[index], "-column"))
                {
                    if(++index<argc)
                        columnNumber = argv[index];
                    else
                    {
                        NSLog(@"!  iTeXMac2 server error: missing column number");
                        goto bail;
                    }
                }
                else if (!strcmp(argv[index], "-dontOrderFront"))
                {
                    dontOrderFront = YES;
                }
                else
                {
                    NSLog(@"!  iTeXMac2 server warning: next arguments are ignored");
                }
            }
            if(strlen(fileName) && LaunchiTeXMac2IfNeeded(argc, argv))
            {
                NSString * conversationID = [NSString stringWithUTF8String: conversation];
                NSString * PWD = [[[NSProcessInfo processInfo] environment] objectForKey: @"PWD"];
//NSLog(@"PWD: %@", PWD);
                NSString * path = [[NSString stringWithUTF8String: fileName] stringByStandardizingPath];
//NSLog(@"Editing file: %@", path);
                NSMutableDictionary * MD = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                    ([path hasPrefix: @"/"]? path:
                        [[PWD stringByAppendingPathComponent: path] stringByStandardizingPath]), iTM2ServerFileKey,
                    conversationID, iTM2ServerConversationIDKey,
                    [NSNumber numberWithBool: dontOrderFront], iTM2ServerDontOrderFrontKey,
                            nil];
                if(strlen(projectName))
                    [MD setObject: [[NSString stringWithUTF8String: projectName] stringByStandardizingPath] forKey: iTM2ServerProjectKey];
                if(strlen(lineNumber))
                    [MD setObject: [NSString stringWithUTF8String: lineNumber] forKey: iTM2ServerLineKey];
                if(strlen(columnNumber))
                    [MD setObject: [NSString stringWithUTF8String: columnNumber] forKey: iTM2ServerColumnKey];
            
				[MD setObject: [[NSProcessInfo processInfo] environment] forKey: iTM2ProcessInfoEnvironmentKey];
                [[NSDistributedNotificationCenter defaultCenter]
                    postNotificationName: iTM2ServerShouldEditFileNotification
                        object: nil
                            userInfo: MD
                                deliverImmediately: YES];
            }
            else
            {
                NSLog(@"!  iTeXMac2 server error: void file name.");
                goto bail;
            }
//    printf("iTM2TextEditorShouldOpenTextFile distributed notification posted\nfile: <%s>, line: <%s>", fileName, lineNumber);
            iTM2_RELEASE_POOL;
            return 0;
        }
#pragma mark =-=-=-=-=-  display
        else if(!strcmp(argv[index], "display"))
        {
//NSLog(@"***  DISPLAY");
            const char * fileName = "";
            const char * projectName = "";
            const char * sourceName = "";
            const char * lineNumber = "";
            const char * columnNumber = "";
			BOOL dontOrderFront = NO;
            while(++index < argc)
            {
                if(!strcmp(argv[index], "-project"))
                {
                    if(++index<argc)
                        projectName = argv[index];
                    else
                    {
                        NSLog(@"!  iTeXMac2 server error: missing project name");
                        goto bail;
                    }
                }
                else if(!strcmp(argv[index], "-file"))
                {
                    if(++index<argc)
                        fileName = argv[index];
                    else
                    {
                        NSLog(@"!  iTeXMac2 server error: missing file name");
                        goto bail;
                    }
                }
                else if (!strcmp(argv[index], "-line"))
                {
                    if(++index<argc)
                        lineNumber = argv[index];
                    else
                    {
                        NSLog(@"!  iTeXMac2 server error: missing line number");
                        goto bail;
                    }
                }
                else if (!strcmp(argv[index], "-column"))
                {
                    if(++index<argc)
                        columnNumber = argv[index];
                    else
                    {
                        NSLog(@"!  iTeXMac2 server error: missing column number");
                        goto bail;
                    }
                }
                else if (!strcmp(argv[index], "-source"))
                {
                    if(++index<argc)
                        sourceName = argv[index];
                    else
                    {
                        NSLog(@"!  iTeXMac2 server error: missing source name");
                        goto bail;
                    }
                }
                else if (!strcmp(argv[index], "-dontOrderFront"))
                {
                    dontOrderFront = YES;
                }
                else
                {
                    NSLog(@"!  iTeXMac2 server warning: ignored arguments(%s...).", argv[index]);
                }
            }
            if(strlen(fileName) && LaunchiTeXMac2IfNeeded(argc, argv))
            {
                NSString * conversationID = [NSString stringWithUTF8String: conversation];
                NSString * PWD = [[[NSProcessInfo processInfo] environment] objectForKey: @"PWD"];
                NSString * path = [[NSString stringWithUTF8String: fileName] stringByStandardizingPath];
//NSLog(@"Displaying file: %@", path);
                NSMutableDictionary * MD = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                    ([path hasPrefix: @"/"]? path:
                        [[PWD stringByAppendingPathComponent: path] stringByStandardizingPath]), iTM2ServerFileKey,
                    conversationID, iTM2ServerConversationIDKey,
                    [NSNumber numberWithBool: dontOrderFront], iTM2ServerDontOrderFrontKey,
                            nil];
                if(strlen(sourceName))
                    [MD setObject: [NSString stringWithUTF8String: sourceName] forKey: iTM2ServerSourceKey];
                if(strlen(projectName))
                    [MD setObject: [[NSString stringWithUTF8String: projectName] stringByStandardizingPath] forKey: iTM2ServerProjectKey];
                if(strlen(lineNumber))
                    [MD setObject: [NSString stringWithUTF8String: lineNumber] forKey: iTM2ServerLineKey];
                if(strlen(columnNumber))
                    [MD setObject: [NSString stringWithUTF8String: columnNumber] forKey: iTM2ServerColumnKey];
            
				[MD setObject: [[NSProcessInfo processInfo] environment] forKey: iTM2ProcessInfoEnvironmentKey];
                [[NSDistributedNotificationCenter defaultCenter]
                    postNotificationName: iTM2ServerShouldDisplayFileNotification
                        object: nil
                            userInfo: MD
                                deliverImmediately: YES];
            }
            else
                NSLog(@"Could not display file: <%@>", [NSString stringWithUTF8String: fileName]);
//    printf("iTM2TextEditorShouldOpenTextFile distributed notification posted\nfile: <%s>, line: <%s>", fileName, lineNumber);
            iTM2_RELEASE_POOL;
            return 0;
        }
#pragma mark =-=-=-=-=-  update
        else if(!strcmp(argv[index], "update"))
        {
//NSLog(@"***  UPDATE");
			const char * projectName = "";
            NSString * conversationID = [NSString stringWithUTF8String: conversation];
            NSMutableArray * FNs = [NSMutableArray array];
            NSString * PWD = [[[NSProcessInfo processInfo] environment] objectForKey: @"PWD"];
            BOOL all = NO;
            while(++index < argc)
            {
                if(!strcmp(argv[index], "-project"))
                {
                    if(++index<argc)
                        projectName = argv[index];
                    else
                    {
                        NSLog(@"!  iTeXMac2 server error: missing project name");
                        goto bail;
                    }
                }
                else if(!strcmp(argv[index], "-file"))
                {
//NSLog(@"***  UPDATE-file");
                    if(++index<argc)
                    {
                        const char * fileName = argv[index];
//NSLog(@"argv[index]: %s", fileName);
//NSLog(@"UTF8: %@", [NSString stringWithUTF8String: fileName]);
                        NSString * path = [[NSString stringWithUTF8String: fileName] stringByStandardizingPath];
                        if(![path hasPrefix: @"/"])
                            path = [[PWD stringByAppendingPathComponent: path] stringByStandardizingPath];
                        [FNs addObject: path];
                    }
                    else
                    {
                        NSLog(@"!  iTeXMac2 server error: missing file name");
                        goto bail;
                    }
                }
                else if (!strcmp(argv[index], "-all"))
                {
//NSLog(@"***  UPDATE-all");
                    all = YES;
                }
                else
                {
                    NSLog(@"!  iTeXMac2 server warning: ignored arguments(%s...).", argv[index]);
                }
            }
            if(LaunchiTeXMac2IfNeeded(argc, argv))
            {
//NSLog(@"Updating files");
                NSMutableDictionary * MD = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                    conversationID, iTM2ServerConversationIDKey,
                    FNs, iTM2ServerFilesKey,
                    [NSNumber numberWithBool: all], iTM2ServerAllKey,
                        nil];
                if(strlen(projectName))
                    [MD setObject: [[NSString stringWithUTF8String: projectName] stringByStandardizingPath] forKey: iTM2ServerProjectKey];
				[MD setObject: [[NSProcessInfo processInfo] environment] forKey: iTM2ProcessInfoEnvironmentKey];
                [[NSDistributedNotificationCenter defaultCenter]
                    postNotificationName: iTM2ServerShouldUpdateFilesNotification
                        object: nil
                            userInfo: MD
                                deliverImmediately: YES];
            }
//    printf("iTM2TextEditorShouldOpenTextFile distributed notification posted\nfile: <%s>, line: <%s>", fileName, lineNumber);
            iTM2_RELEASE_POOL;
            return 0;
        }
#pragma mark =-=-=-=-=-  notify
        else if(!strcmp(argv[index], "notify"))
        {
//NSLog(@"***  NOTIFY");
            NSString * conversationID = [NSString stringWithUTF8String: conversation];
            NSMutableArray * comments = [NSMutableArray array];
            NSMutableArray * errors = [NSMutableArray array];
            NSMutableArray * warnings = [NSMutableArray array];
            while(++index < argc)
            {
                if (!strcmp(argv[index], "-comment"))
                {
                    if(++index < argc)
                    {
                        [comments addObject: [NSString stringWithUTF8String: argv[index]]];
                    }
                    else
                    {
                        NSLog(@"!  iTeXMac2 server error: missing comment.");
                        goto bail;
                    }
                }
                else if (!strcmp(argv[index], "-warning"))
                {
                    if(++index < argc)
                    {
                        [warnings addObject: [NSString stringWithUTF8String: argv[index]]];
                    }
                    else
                    {
                        NSLog(@"!  iTeXMac2 server error: missing warning.");
                        goto bail;
                    }
                }
                else if (!strcmp(argv[index], "-error"))
                {
                    if(++index < argc)
                    {
                        [errors addObject: [NSString stringWithUTF8String: argv[index]]];
                    }
                    else
                    {
                        NSLog(@"!  iTeXMac2 server error: missing error.");
                        goto bail;
                    }
                }
                else
                {
                    NSLog(@"!  iTeXMac2 server warning: ignored arguments(%s...).", argv[index]);
                }
            }
            if(LaunchiTeXMac2IfNeeded(argc, argv))
            {
//NSLog(@"Updating files");
                NSMutableDictionary * MD = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                    conversationID, iTM2ServerConversationIDKey,
                    comments, iTM2ServerCommentsKey,
                    warnings, iTM2ServerWarningsKey,
                    errors,   iTM2ServerErrorsKey,
                        nil];
				[MD setObject: [[NSProcessInfo processInfo] environment] forKey: iTM2ProcessInfoEnvironmentKey];
                [[NSDistributedNotificationCenter defaultCenter]
                    postNotificationName: iTM2ServerComwarnerNotification
                        object: nil
                            userInfo: MD
                                deliverImmediately: YES];
            }
//    printf("iTM2TextEditorShouldOpenTextFile distributed notification posted\nfile: <%s>, line: <%s>", fileName, lineNumber);
            iTM2_RELEASE_POOL;
            return 0;
        }
#pragma mark =-=-=-=-=-  applescript
        else if(!strcmp(argv[index], "applescript"))
        {
//NSLog(@"***  APPLESCRIPT");
            if(++index < argc)
            {
                if(LaunchiTeXMac2IfNeeded(argc, argv))
                {
                    NSString * conversationID = [NSString stringWithUTF8String: conversation];
                    NSMutableDictionary * MD = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                        conversationID, iTM2ServerConversationIDKey,
                        [NSString stringWithUTF8String: argv[index]], iTM2ServerSourceKey,
                            nil];
					[MD setObject: [[NSProcessInfo processInfo] environment] forKey: iTM2ProcessInfoEnvironmentKey];
                    [[NSDistributedNotificationCenter defaultCenter]
                        postNotificationName: iTM2ServerComwarnerNotification
                            object: nil
                                userInfo: MD
                                    deliverImmediately: YES];
                }
            }
            else
            {
                NSLog(@"!  iTeXMac2 server error: missing applescript.");
                goto bail;
            }
//    printf("iTM2TextEditorShouldOpenTextFile distributed notification posted\nfile: <%s>, line: <%s>", fileName, lineNumber);
            iTM2_RELEASE_POOL;
            return 0;
        }
#pragma mark =-=-=-=-=-  help
        else if(!strcmp(argv[index], "help"))
        {
//NSLog(@"***  HELP");
            iTeXMac2Usage(argc, argv);
            iTM2_RELEASE_POOL;
            return 0;
        }
        else if(!strcmp(argv[index], "-conversation"))
        {
//NSLog(@"***  HELP");
            if(++index < argc)
            {
                conversation = argv[index];
            }
            else
            {
                goto bail;
            }
        }
        else
        {
            NSLog(@"!  iTeXMac2 server error: missing conversation.");
            goto bail;
        }
    }
    bail:
//NSLog(@"***  BAIL");
    iTeXMac2Usage(argc, argv);
    iTM2_RELEASE_POOL;
    return 1;
}

#warning *** FRAGILE design: iTeXMac2BundleIdentifier
#pragma mark *** FRAGILE design: iTeXMac2BundleIdentifier
NSString * const iTeXMac2BundleIdentifier = @"comp.text.tex.iTeXMac2.preview";

BOOL LaunchiTeXMac2IfNeeded(int argc, const char *argv[])
{
    #if __TEST__
        return YES;
    #endif
    iTM2_INIT_POOL;
	NSString * temporaryDirectory = [[[NSProcessInfo processInfo] environment] objectForKey: @"iTM2_TemporaryDirectory"];
	if([temporaryDirectory length])
	{
		// this program was launched by iTeXMac, either directly or through another script.
        if([[NSWorkspace sharedWorkspace] launchApplication:
				[[temporaryDirectory stringByAppendingPathComponent: @"iTeXMac2.app"] stringByStandardizingPath]])
		{
//NSLog(@".....  Switching to iTeXMac2.");
			return YES;
		}
		else
		{
            NSLog(@"..........  ERROR: I could not open iTeXMac2, it has certainly moved.");
			return NO;
		}
	}
    NSEnumerator * E = [[[NSWorkspace sharedWorkspace] launchedApplications] objectEnumerator];
    NSDictionary * D;
    BOOL isRunning = NO;
    while(D = [E nextObject])
	{
		NSString * applicationPath = [D objectForKey: @"NSApplicationPath"];
		NSBundle * applicationBundle = [NSBundle bundleWithPath: applicationPath];
        if([[applicationBundle bundleIdentifier] isEqualToString: iTeXMac2BundleIdentifier])
        {
            isRunning = YES;
            break;
        }
	}
    if(!isRunning)
    {
        NSLog(@"Trying to launch iTeXMac2...");
        if(isRunning = [[NSWorkspace sharedWorkspace] launchApplication:
            [[[[[NSHomeDirectory() stringByAppendingPathComponent: @"Library"]
                stringByAppendingPathComponent: @"TeX"]
                    stringByAppendingPathComponent: @"bin"]
                        stringByAppendingPathComponent: @"iTeXMac2.app"]
                            stringByStandardizingPath]])
        {
            [NSThread sleepUntilDate: [NSDate dateWithTimeIntervalSinceNow: 2]];
        }
        else
        {
            NSBeep();
            NSLog(@"Sorry, I could not open iTeXMac2");
        }
    }
    iTM2_RELEASE_POOL;
    return isRunning;
}
void iTeXMac2Usage(int argc, const char *argv[])
{
    iTM2_INIT_POOL;
    NSLog(@"Using %s as server", argv[0]);
    NSLog(@"");
    NSLog(@"To let iTeXMac2 edit one particular file:");
    NSLog(@"========================================");
    NSLog(@"  %s -conversation conversationID edit -file fileName [-line lineNumber] [-column columnNumber] [-dontOrderFront]", argv[0]);
    NSLog(@"  When not absolute, path are relative to the current directory.");
    NSLog(@"");
    NSLog(@"To let iTeXMac2 display one particular file:");
    NSLog(@"===========================================");
    NSLog(@"  %s -conversation conversationID display -file fileName [-source sourceName] [-line lineNumber] [-column columnNumber] [-dontOrderFront]", argv[0]);
    NSLog(@"  When not absolute, fileName is relative to the current directory.");
    NSLog(@"  When not absolute, sourceName is relative to the directory of fileName.");
    NSLog(@"");
    NSLog(@"To let iTeXMac2 update one particular file:");
    NSLog(@"==========================================");
    NSLog(@"  %s -conversation conversationID update -file fileName", argv[0]);
    NSLog(@"  When not absolute, fileName is relative to the current directory.");
    NSLog(@"");
    NSLog(@"To let iTeXMac2 update all its files:");
    NSLog(@"====================================");
    NSLog(@"  %s -conversation conversationID update -all", argv[0]);
    NSLog(@"");
    NSLog(@"To notify iTeXMac2 of a comment:");
    NSLog(@"====================================");
    NSLog(@"  %s -conversation conversationID notify -comment \"The comment\"", argv[0]);
    NSLog(@"");
    NSLog(@"To notify iTeXMac2 of a warning:");
    NSLog(@"====================================");
    NSLog(@"  %s -conversation conversationID notify -warning \"The warning message\"", argv[0]);
    NSLog(@"");
    NSLog(@"To notify iTeXMac2 of an error:");
    NSLog(@"====================================");
    NSLog(@"  %s -conversation conversationID notify -error \"The error message\"", argv[0]);
    NSLog(@"");
    NSLog(@"");
    NSLog(@"To ask iTeXMac2 to execute an applescript:");
    NSLog(@"====================================");
    NSLog(@"  %s -conversation conversationID applescript \"The applescript source\"", argv[0]);
    NSLog(@"In all the previous commands, the optional conversationID is given by the $iTM2_Conversation environment variable.");
    NSLog(@"This variable is set up by iTeXMac2 when launching tasks.");
    NSLog(@"This is suitable when more than one (recent) iTeXMac2 is running to know what should be the expected target.");
    NSLog(@"If you don't have a conversation number, simply don't use it.");
    iTM2_RELEASE_POOL;
    return;
}
