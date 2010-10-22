/*
//
//  @version Subversion: $Id$ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Tue Sep 11 2001.
//  Copyright © 2001-2006 Laurens'Tribune. All rights reserved.
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
//  Version history: (format "- date:contribution(contributor)") 
//  To Do List:(format "- proposition(percentage actually done)")
*/

#import "iTM2TeXProjectDocumentKit.h"
#import "iTM2TeXProjectFrontendKit.h"
#import "iTM2TeXProjectTaskKit.h"
#import <iTM2TeXFoundation/iTM2TeXInfoWrapperKit.h>
#import <iTM2Foundation/iTM2Foundation.h>
#import <Carbon/Carbon.h>
//#import <objc/objc-runtime.h>

NSString * const iTM2TeXProjectFrontendTable = @"Frontend";

NSString * const iTM2TeXProjectExtendedInspectorVariant = @"Extended";

NSString * const iTM2TPFEOutputFileExtensionKey = @"OutputFileExtension";

NSString * const iTM2TPFEVoidMode = @"None";
NSString * const iTM2TPFECustomMode = @"Custom";
NSString * const iTM2TPFEBaseMode = @"Base";

NSString * const iTM2TPFEPSOutput = @"PS";
NSString * const iTM2TPFEDVIOutput = @"DVI";
NSString * const iTM2TPFEHTMLOutput = @"HTML";
NSString * const iTM2TPFEOtherOutput = @"Other";

NSString * const iTM2TeXProjectSettingsInspectorMode = @"Settings Mode";
NSString * const iTM2TeXProjectNoTerminalBehindKey = @"iTM2TeXProjectNoTerminalBehind";

NSString * const iTM2TeXPCommandPropertiesKey = @"Properties";

#ifndef iTM2WindowsMenuItemIndentationLevel
#define iTM2WindowsMenuItemIndentationLevel [self contextIntegerForKey:@"iTM2WindowsMenuItemIndentationLevel" domain:iTM2ContextAllDomainsMask]
#endif

@implementation NSDocumentController(iTM2TeXProjectFrontend)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  SWZ_iTM2TPFE_displayPageForLine:column:source:withHint:orderFront:force:
- (BOOL)SWZ_iTM2TPFE_displayPageForLine:(NSUInteger)line column:(NSUInteger)column source:(NSURL *)sourceURL withHint:(NSDictionary *)hint orderFront:(BOOL)yorn force:(BOOL)force;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSURL * url = nil;
	NSString * output = nil;
	NSDocument * D = nil;
	iTM2TeXProjectDocument * TPD = [SPC projectForURL:sourceURL];
	if (TPD) {
		for (D in TPD.subdocuments) {
			if ([D displayPageForLine:line column:column source:sourceURL withHint:hint orderFront:yorn force:force]) {
				return YES;
			}
		}
		if(!force) {
			return NO;
        }
		NSURL * masterURL = [TPD URLForFileKey:TPD.masterFileKey];
		if(masterURL) {
			output = [masterURL.path.stringByDeletingPathExtension stringByAppendingPathExtension:[TPD outputFileExtension]];
			url = [NSURL fileURLWithPath:output];
			if(![TPD subdocumentForURL:url] &&
                    (D = [self openDocumentWithContentsOfURL:url display:NO error:nil])) {
				return [D displayPageForLine:line column:column source:sourceURL withHint:hint orderFront:yorn force:force];
			}
			url = [url URLByRemovingFactoryBaseURL4iTM3];
			if(![TPD subdocumentForURL:url] &&
                    (D = [self openDocumentWithContentsOfURL:url display:NO error:nil])) {
				return [D displayPageForLine:line column:column source:sourceURL withHint:hint orderFront:yorn force:force];
			}
		}
    } else if(sourceURL) {
		url = [sourceURL.URLByDeletingPathExtension URLByAppendingPathExtension:@"pdf"];
		if(url.isFileURL && [DFM fileExistsAtPath:sourceURL.path]) {
			if(D = [self openDocumentWithContentsOfURL:url display:NO error:nil]) {
				return [D displayPageForLine:line column:column source:sourceURL withHint:hint orderFront:yorn force:force];// time consuming
            }
		}
	}
//END4iTM3;
	return [self SWZ_iTM2TPFE_displayPageForLine:line column:column source:sourceURL withHint:hint orderFront:yorn force:force];
}
@end

//#import "iTM2TeXPCommandWrapperKit.h"
#import "iTM2TeXProjectCommandKit.h"

NSString * const iTM2TeXProjectDefaultBaseNameKey = @"iTM2TeXProjectBaseName";

@implementation iTM2TeXProjectDocument(Frontend)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  outputFileExtension
- (NSString *)outputFileExtension;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [self infoForKeyPaths:iTM2TPFEOutputFileExtensionKey,nil]?:@"pdf";
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setOutputFileExtension:
- (void)setOutputFileExtension:(NSString *) extension;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[self setInfo:extension forKeyPaths:iTM2TPFEOutputFileExtensionKey,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  editCommands:
- (void)editCommands:(id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    iTM2TeXPCommandsInspector * WC = nil;
    for (WC in self.windowControllers) {
        if([WC isKindOfClass:[iTM2TeXPCommandsInspector class]]) {
            [WC.window makeKeyAndOrderFront:self];
            return;
        }
    }
    WC = [[[iTM2TeXPCommandsInspector alloc] initWithWindowNibName:NSStringFromClass([iTM2TeXPCommandsInspector class])] autorelease];
    [self addWindowController:WC];
    [WC.window makeKeyAndOrderFront:self];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  showSettings:
- (void)showSettings:(id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    iTM2TeXPCommandsInspector * WC;
    for (WC in self.windowControllers) {
        if([WC isKindOfClass:[iTM2TeXPCommandsInspector class]])
        {
            [WC.window makeKeyAndOrderFront:self];
            return;
        }
    }
    WC = [[[iTM2TeXPCommandsInspector alloc] initWithWindowNibName:NSStringFromClass([iTM2TeXPCommandsInspector class])] autorelease];
    [self addWindowController:WC];
    [WC.window makeKeyAndOrderFront:self];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= smartShowTerminal:
- (void)smartShowTerminal:(id) sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (10/04/2001)
- 1.4: Fri Apr 16 11:39:43 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//    self.reallyMakeWindowControllers;
#warning DEBUGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= showTerminal:
- (IBAction)showTerminal:(id) sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (10/04/2001)
- 1.4: Fri Apr 16 11:39:43 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSWindow * W = [self.taskController.allInspectors.lastObject window];
	if(W) [W makeKeyAndOrderFront:sender];
	[[[self inspectorAddedWithMode:[iTM2TeXPTaskInspector inspectorMode]] window] makeKeyAndOrderFront:self];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= showFiles:
- (IBAction)showFiles:(id) sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (10/04/2001)
- 1.4: Fri Apr 16 11:39:43 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    iTM2TeXSubdocumentsInspector * WC;
    for (WC in self.windowControllers) {
        if([WC isKindOfClass:[iTM2TeXSubdocumentsInspector class]]) {
            [WC.window makeKeyAndOrderFront:self];
            return;
        }
    }
    WC = [[[iTM2TeXSubdocumentsInspector alloc] initWithWindowNibName:NSStringFromClass([iTM2TeXSubdocumentsInspector class])] autorelease];
    [self addWindowController:WC];
    [WC.window makeKeyAndOrderFront:self];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= showTerminalInBackGroundIfNeeded
- (void)showTerminalInBackGroundIfNeeded:(id) sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (10/04/2001)
- Thu Oct 28 14:05:13 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//    self.reallyMakeWindowControllers;
	if([self.taskController isMute]) {
		return;
    }
	NSWindow * mainWindow = [NSApp mainWindow];
	iTM2TeXPTaskInspector * inspector = self.taskController.allInspectors.lastObject;
	if([inspector isHidden]) {
		return;
    }
	NSWindow * window = inspector.window;
	if(!window) {
		window = [[self inspectorAddedWithMode:[iTM2TeXPTaskInspector inspectorMode]] window];
    }
	if(mainWindow && ![window isEqual:mainWindow] 
		&& ![self contextBoolForKey:iTM2TeXProjectNoTerminalBehindKey domain:iTM2ContextAllDomainsMask]) {
		[window orderBelowFront4iTM3:self];
	} else {
		[window orderFront:self];
	}
    self.validateWindowsContents4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  projectName
- (NSString *)projectName;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSString * projectName = [super projectName];
	if(projectName.length) {
		return projectName;
    }
	return [self nameForFileKey:self.masterFileKey].lastPathComponent.stringByDeletingPathExtension;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= keepBackupFile
- (BOOL)keepBackupFile;
/*"Description forthcoming. NO is recommended unless synch problems might occur.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1:03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [self contextBoolForKey:@"iTM2TeXProjectKeepBackup" domain:iTM2ContextAllDomainsMask];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= template_isValidCommandEnvironmentMode:forScriptMode:
- (BOOL)template_isValidCommandEnvironmentMode:(NSString *) environmentMode forScriptMode:(NSString *) scriptMode;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1:03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= isValidEnvironmentMode:forScriptMode:commandName:
- (BOOL)isValidEnvironmentMode:(NSString *) environmentMode forScriptMode:(NSString *) scriptMode commandName:(NSString *) commandName;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1:03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if(!commandName.length)
		return NO;
	const char * command = [commandName cStringUsingEncoding:NSUTF8StringEncoding];
	size_t size = (37+strlen(command));
	char * selName = NSAllocateCollectable(size,0);
	if(!selName)
	{
		LOG4iTM3(@"*** ERROR:Memory management problem.");
		return NO;
	}
    NSInvocation * I = nil;
    [[NSInvocation getInvocation4iTM3:&I withTarget:self] template_isValidCommandEnvironmentMode:environmentMode forScriptMode:scriptMode];// GC version
	char * dest = selName;
	const char * source = "isValid";
	size = strlen(source);
	strncpy(dest, source, size);
	dest += size;
	size = strlen(command);
	strncpy(dest, command, size);
	static const char * CAPITALS = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    if((dest[0]>='a') && (dest[0]<='z'))
        dest[0] = CAPITALS[dest[0]-'a'];
	dest += size;
	source="EnvironmentMode:forScriptMode:";
	size = strlen(source);
	strncpy(dest, source, size);
	dest += size;
	dest[0] = '\0';// terminate the string
#warning OBJC_EXPORT SEL sel_getUid(const char *str);
	SEL selector = sel_getUid(selName);
    if([I.methodSignature isEqual:[self methodSignatureForSelector:selector]]) {
		I.selector = selector;
		I.invoke;
		BOOL flag;
		[I getReturnValue:&flag];
	 //END4iTM3;
		return flag;
	}
	// default behaviour scriptMode -> environment mode
	// void -> void
	// base -> base or command name
	// other -> everything
	if([scriptMode isEqualToString:iTM2TPFEVoidMode])
		return [environmentMode isEqualToString:iTM2TPFEVoidMode];
//LOG4iTM3(@"environmentMode is:%@", environmentMode);
//LOG4iTM3(@"commandName is:%@", commandName);
	if([scriptMode isEqualToString:iTM2TPFEBaseMode])
		return [environmentMode isEqualToString:iTM2TPFEBaseMode] || [environmentMode isEqualToString:commandName];
	return YES;
}
@end


//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2TeXProjectFrontendKit
/*"Description forthcoming."*/

//#import <iTM2Foundation/iTM2MenuKit.h>
//#import <iTM2Foundation/iTM2WindowKit.h>

NSString * const iTM2TPFEContentKey = @"content";
NSString * const iTM2TPFEShellKey = @"shell";
NSString * const iTM2TPFELabelKey = @"label";

@interface iTM2TeXPShellScriptLabelFormatter:NSFormatter
{
@private
	NSString * iVarEmptyFormat;
}
- (void)setEmptyFormat:(NSString *) format;
@property (retain) NSString * iVarEmptyFormat;
@end
@implementation iTM2TeXPShellScriptLabelFormatter
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inspectorType4iTM3
- (void)setEmptyFormat:(NSString *) format;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[iVarEmptyFormat autorelease];
	iVarEmptyFormat = [format copy];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  getObjectValue:forString:errorDescription:
- (BOOL)getObjectValue:(id *) obj forString:(NSString *) string errorDescription:(NSString **) error
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if(obj)
	{
		* obj = string;
//END4iTM3;
		return YES;
	}
	else
	{
		if(error)
			* error = @"ERROR:Don't know where to put the object...";
//END4iTM3;
		return NO;
	}
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  stringForObjectValue:
- (NSString *)stringForObjectValue:(id) obj;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	return obj?:@"";
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  attributedStringForObjectValue:withDefaultAttributes:
- (NSAttributedString *)attributedStringForObjectValue:(id) obj withDefaultAttributes:(NSDictionary *) attrs;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSAttributedString * result;
	NSString * s = [self stringForObjectValue:obj];
	if(s.length)
		result = [[[NSAttributedString alloc] initWithString:s attributes:attrs] autorelease];
	else
	{
		NSMutableDictionary * MD = [NSMutableDictionary dictionaryWithDictionary:attrs];
		[MD setObject:[NSColor disabledControlTextColor] forKey:NSForegroundColorAttributeName];
		result = [[[NSAttributedString alloc] initWithString:(iVarEmptyFormat.length?iVarEmptyFormat:@"NO DESCRIPTION AVAILABLE")
			attributes:MD] autorelease];
	}
//LOG4iTM3(@"result is:%@", result);
	return result;
}
@synthesize iVarEmptyFormat;
@end

@implementation iTM2TeXPShellScriptInspector
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inspectorType4iTM3
+ (NSString *)inspectorType4iTM3;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return @"Project Helper";
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inspectorMode
+ (NSString *)inspectorMode;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return @"Shell Script";
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initWithWindow:
- (id)initWithWindow:(NSWindow *) window;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if(self = [super initWithWindow:window])
	{
		self.fixImplementation;
	}
    return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  fixImplementation
- (void)fixImplementation;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[IMPLEMENTATION takeMetaValue:[NSMutableDictionary dictionary] forKey:@"scriptDescriptor"];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  OK:
- (IBAction)OK:(NSControl *) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [NSApp endSheet:sender.window returnCode:NSAlertDefaultReturn];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  cancel:
- (IBAction)cancel:(NSControl *) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [NSApp endSheet:sender.window returnCode:NSAlertAlternateReturn];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  textView
- (NSTextView *)textView;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return metaGETTER;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setTextView:
- (void)setTextView:(NSTextView *) TV;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    metaSETTER(TV);
	if(TV)
	{
		[TV setTypingAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
			[NSFont userFixedPitchFontOfSize:[NSFont systemFontSize]], NSFontAttributeName, nil]];
	}
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setScriptDescriptor:
- (void)setScriptDescriptor:(id) scriptDescriptor;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    self.window;
    [IMPLEMENTATION takeMetaValue:(scriptDescriptor? [[scriptDescriptor copy] autorelease]:[NSMutableDictionary dictionary])
		forKey:@"scriptDescriptor"];
    NSString * shellScript = [scriptDescriptor valueForKey:iTM2TPFEContentKey];
    if(!shellScript.length)
        shellScript = @"#!/bin/sh\n";
    NSUInteger end;
    [shellScript getLineStart:nil end:&end contentsEnd:nil forRange:iTM3MakeRange(0, 0)];
    [self.textView setString:[shellScript substringWithRange:iTM3MakeRange(end, shellScript.length - end)]];
    [IMPLEMENTATION takeMetaValue:(end>2? [shellScript substringWithRange:iTM3MakeRange(2, end-3)]:@"") forKey:iTM2TPFEShellKey];
    [IMPLEMENTATION takeMetaValue:[scriptDescriptor iVarLabel] forKey:iTM2TPFELabelKey];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  scriptDescriptor
- (id)scriptDescriptor;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    id result = [[[IMPLEMENTATION metaValueForKey:@"scriptDescriptor"] mutableCopy] autorelease];
	if(!result)
		result = [NSMutableDictionary dictionary];
    [result setValue:[NSString stringWithFormat:@"#!%@\n%@", [IMPLEMENTATION metaValueForKey:iTM2TPFEShellKey], [self.textView string]] forKey:iTM2TPFEContentKey];
    [result setValue:[IMPLEMENTATION metaValueForKey:iTM2TPFELabelKey] forKey:iTM2TPFELabelKey];
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  windowDidLoad
- (void)windowDidLoad;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [super windowDidLoad];
    self.validateWindowContent4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  editLabel:
- (IBAction)editLabel:(id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [IMPLEMENTATION takeMetaValue:[sender objectValue] forKey:iTM2TPFELabelKey];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateEditLabel:
- (BOOL)validateEditLabel:(NSTextField *) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if(![[sender formatter] isKindOfClass:[iTM2TeXPShellScriptLabelFormatter class]])
	{
		iTM2TeXPShellScriptLabelFormatter * F = [[[iTM2TeXPShellScriptLabelFormatter alloc] init] autorelease];
		[F setEmptyFormat:[sender stringValue]];
		sender.formatter = F;
	}
	[sender setObjectValue:[IMPLEMENTATION metaValueForKey:iTM2TPFELabelKey]];
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  editShell:
- (IBAction)editShell:(id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [IMPLEMENTATION takeMetaValue:[sender objectValue] forKey:iTM2TPFEShellKey];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateEdited:
- (BOOL)validateEditShell:(id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [sender setObjectValue:([IMPLEMENTATION metaValueForKey:iTM2TPFEShellKey]?:nil)];
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertSpecialEnvironmentVariable:
- (IBAction)insertSpecialEnvironmentVariable:(id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateInsertSpecialEnvironmentVariable:
- (BOOL)validateInsertSpecialEnvironmentVariable:(NSPopUpButton *) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if([sender isKindOfClass:[NSPopUpButton class]])
	{
		[sender removeAllItems];
		[sender addItemWithTitle:NSLocalizedStringFromTableInBundle(@"Insert Special Environment Variable", @"Commands", myBUNDLE, "Description forthcoming")];
			[sender.lastItem setEnabled:NO];
		[sender addItemWithTitle:NSLocalizedStringFromTableInBundle(TWSShellEnvironmentProjectKey, @"Commands", myBUNDLE, "Description forthcoming")];
			[sender.lastItem setAction:@selector(_insertSpecialEnvironmentVariable:)];
			[sender.lastItem setEnabled:YES];
			[sender.lastItem setTarget:self];// sender belongs to the receiver's window
			sender.lastItem.representedObject = TWSShellEnvironmentProjectKey;
		[sender addItemWithTitle:NSLocalizedStringFromTableInBundle(TWSShellEnvironmentFrontKey, @"Commands", myBUNDLE, "Description forthcoming")];
			[sender.lastItem setAction:@selector(_insertSpecialEnvironmentVariable:)];
			[sender.lastItem setEnabled:YES];
			[sender.lastItem setTarget:self];// sender belongs to the receiver's window
			sender.lastItem.representedObject = TWSShellEnvironmentFrontKey;
	}
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  _insertSpecialEnvironmentVariable:
- (IBAction)_insertSpecialEnvironmentVariable:(id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[self.textView insertText:[NSString stringWithFormat:@"${%@}", [sender representedObject]]];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  saveDocument:
- (IBAction)saveDocument:(id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Mar 26 08:41:36 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateSaveDocument:
- (BOOL)validateSaveDocument:(id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Mar 26 08:41:36 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return NO;
}
@end

@implementation iTM2TeXSubdocumentsInspector(iTM2FrontendKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  windowsMenuItemTitleForDocumentDisplayName4iTM3:
- (NSString *)windowsMenuItemTitleForDocumentDisplayName4iTM3:(NSString *) displayName;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [self.class prettyInspectorMode];
}
@end

NSString * const iTM2TPFEPDFOutput = @"PDF";

//#import <iTM2Foundation/iTM2InstallationKit.h>
//#import <iTM2Foundation/iTM2Implementation.h>

@interface NSString(TeXPFrontend0)
- (BOOL)isValidTeXProjectPath;
@end

@implementation NSString(TeXPFrontend)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  TeXProjectProperties4iTM3
- (NSDictionary *)TeXProjectProperties4iTM3;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSString * mode = @"";
    NSString * output = @"";
    NSString * variant = @"";
    NSString * name = self.lastPathComponent.stringByDeletingPathExtension;
	NSArray * components = [name componentsSeparatedByString:@"+"];
	if(components.count>1)
	{
		mode = [components objectAtIndex:0];
		components = [[components objectAtIndex:1] componentsSeparatedByString:@"-"];
		if(components.count>1)
		{
			output = [components objectAtIndex:0];
			variant = [components objectAtIndex:1];
		}
		else if(components.count)
		{
			output = [components objectAtIndex:0];
		}
		else
		{
			output = iTM2TPFEPDFOutput;
		}
	}
	else if(components.count)
	{
		output = iTM2TPFEPDFOutput;
		components = [[components objectAtIndex:0] componentsSeparatedByString:@"-"];
		if(components.count)
			mode = [components objectAtIndex:0];
		if(components.count>1)
			variant = [components objectAtIndex:1];
	}
	else
	{
		mode = @"LaTeX";
	}
//LOG4iTM3(@"For name:%@, mode:%@, output:%@, variant:%@", name, mode, output, variant);
    return [NSDictionary dictionaryWithObjectsAndKeys:mode, iTM2TPDKModeKey, output, iTM2TPDKOutputKey, variant, iTM2TPDKVariantKey, nil];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  isValidTeXProjectPath
- (BOOL)isValidTeXProjectPath;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return ![self.stringByDeletingPathExtension hasSuffix:[SUD stringForKey:@"iTM2BackupSuffix"]];
}
@end

//#import <iTM2Foundation/iTM2PathUtilities.h>
//#import <iTM2Foundation/iTM2BundleKit.h>

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2TeXProjectDocumentKit

NSString * const iTM2TeXProjectDocumentIsMasterFileKey = @"iTM2TeXProjectDocumentIsMaster";

extern NSString * const iTM2TeXWrapperPathExtension;

typedef struct {
        NSUInteger        hasEnclosingProject:1;
        NSUInteger        hasEnclosingWrapper:1;
        NSUInteger        hasEnclosedProjects:1;
        NSUInteger        isWritable:1;
        NSUInteger        preferWrapper:1;
        NSUInteger        standalone:1;
        NSUInteger        old:1;
        NSUInteger        new:1;
        NSUInteger        reserved:24;
    } iTM2NewTeXProjectFlags;

@implementation iTM2NewTeXProjectController
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setUpProject:
- (void)setUpProject:(id)projectDocument;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (08/29/2001):
- 1.3:03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[projectDocument setBaseProjectName:self.baseProjectName];
//END4iTM3;
	return;
}
#pragma mark =-=-=-=-=-  ACCESSORS
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  fileURL
- (NSURL *)fileURL;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (08/29/2001):
- 1.3:03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
	return metaGETTER;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setFileURL:
- (void)setFileURL:(NSURL *)fileURL;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (08/29/2001):
- 1.3:03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	metaSETTER(fileURL);
	NSURL * enclosing = fileURL.enclosingWrapperURL4iTM3;
	if(enclosing)
	{
		// the file already belongs to a wrapper
		[self setPreferWrapper:YES];
		[self setCreationMode:iTM2ToggleNewProjectMode];
		NSArray * enclosed = [enclosing enclosedProjectURLs4iTM3];
		NSURL * project = nil;
		for(project in enclosed)
		{
	NSString * fileName = fileURL.path;
			if([fileName belongsToDirectory4iTM3:[[project parentDirectoryURL4iTM3] path]])
			{
				[self setCreationMode:iTM2ToggleOldProjectMode];
				break;
			}
		}
	}
	else
	{
		[self setPreferWrapper:NO];
	}
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  newProjectName
- (NSString *)newProjectName;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (08/29/2001):
- 1.3:03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSString * result = metaGETTER;
	if(result)
	{
		return result;
	}
	result = self.fileURL.path;
	result = result.lastPathComponent;
	result = result.stringByDeletingPathExtension;
//END4iTM3;
	return result?:@"?";
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setNewProjectName:
- (void)setNewProjectName:(NSString *)argument;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (08/29/2001):
- 1.3:03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	metaSETTER(argument);
//END4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= oldProjectName
- (NSString *)oldProjectName;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSString * result = metaGETTER;
	if(result.length>0)
	{
		return result;
	}
//END4iTM3;
	return @"";
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= setOldProjectName:
- (void)setOldProjectName:(id)argument;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	metaSETTER(argument);
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  baseProjectName
- (NSString *)baseProjectName;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (08/29/2001):
- 1.3:03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
	return metaGETTER;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setBaseProjectName:
- (void)setBaseProjectName:(NSString *)argument;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (08/29/2001):
- 1.3:03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	metaSETTER(argument);
//END4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  documentIsMaster
- (BOOL)documentIsMaster;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (08/29/2001):
- 1.3:03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
	return [metaGETTER boolValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setDocumentIsMaster:
- (void)setDocumentIsMaster:(BOOL)yorn;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (08/29/2001):
- 1.3:03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	metaSETTER([NSNumber numberWithBool:yorn]);
//END4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  exportOutput
- (BOOL)exportOutput;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (08/29/2001):
- 1.3:03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
	return [metaGETTER boolValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setExportOutput:
- (void)setExportOutput:(BOOL)yorn;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (08/29/2001):
- 1.3:03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	metaSETTER([NSNumber numberWithBool:yorn]);
//END4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  preferWrapper
- (BOOL)preferWrapper;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (08/29/2001):
- 1.3:03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
	return [metaGETTER boolValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setPreferWrapper:
- (void)setPreferWrapper:(BOOL)yorn;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (08/29/2001):
- 1.3:03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	metaSETTER([NSNumber numberWithBool:yorn]);
//END4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateCreationMode
- (void)validateCreationMode;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Nov  8 09:18:47 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSInteger creationMode = self.creationMode;
	if(creationMode == iTM2ToggleOldProjectMode)
	{
old:
		if(self.canInsertInOldProject)
		{
			return;
		}
		creationMode = iTM2ToggleNewProjectMode;
		[self setCreationMode:creationMode];
		goto new;
	}
	if(creationMode == iTM2ToggleNewProjectMode)
	{
new:
		if(self.canCreateNewProject)
		{
			return;
		}
		creationMode = iTM2ToggleStandaloneMode;
		[self setCreationMode:creationMode];
		goto standalone;
	}
	if(creationMode == iTM2ToggleStandaloneMode)
	{
standalone:
		if(!self.canBeStandalone)
		{
			[self setCreationMode:iTM2ToggleForbiddenProjectMode];
		}
		return;
	}
	creationMode = iTM2ToggleOldProjectMode;
	[self setCreationMode:creationMode];
	goto old;
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  canInsertInOldProject
- (BOOL)canInsertInOldProject;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Nov  8 09:18:47 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSDictionary * availableProjects = self.availableProjects;
	NSInteger count = availableProjects.count;
	// this peculiar situation occurs when I insert in a wrapper that has no project inside
	if(count == 1)
	{
		NSString * path = [[availableProjects allKeys] lastObject];
		NSURL * url = [NSURL fileURLWithPath:path];
		if([SWS isWrapperPackageAtURL4iTM3:url])
		{
			NSArray * enclosed = [url enclosedProjectURLs4iTM3];
			return enclosed.count > 0;
		}
	}
//END4iTM3;
    return count > 0;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  canCreateNewProject
- (BOOL)canCreateNewProject;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Nov  8 09:18:47 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSURL * fileURL = self.fileURL;
	NSString * fileName = fileURL.path;
	NSString * dir = fileName.stringByDeletingLastPathComponent;
	if(![DFM isWritableFileAtPath:dir])
	{
		return NO;
	}
	NSURL * enclosing = [fileURL enclosingProjectURL4iTM3];
	if(enclosing)
	{
		return NO;
	}
	if(enclosing = fileURL.enclosingWrapperURL4iTM3)
	{
		NSArray * enclosed = [enclosing enclosedProjectURLs4iTM3];
		if(enclosed.count)
		{
			return NO;
		}
	}
//END4iTM3;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  canBeStandalone
- (BOOL)canBeStandalone;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Nov  8 09:18:47 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSURL * fileURL = self.fileURL;
	NSURL * enclosing = [fileURL enclosingProjectURL4iTM3];
	if(enclosing)
	{
		return NO;
	}
	if(enclosing = fileURL.enclosingWrapperURL4iTM3)
	{
		return NO;
	}
	return YES;
//END4iTM3;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  creationMode
- (NSInteger)creationMode;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Nov  8 09:18:47 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return [metaGETTER integerValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setCreationMode:
- (void)setCreationMode:(NSInteger)tag;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Nov  8 09:18:47 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	metaSETTER([NSNumber numberWithInteger:tag]);
	[SUD setInteger:tag forKey:iTM2NewProjectCreationModeKey];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  availableProjects
- (id)availableProjects;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Nov  8 09:18:47 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return metaGETTER;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setAvailableProjects:
- (void)setAvailableProjects:(id) argument;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Nov  8 09:18:47 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	metaSETTER(argument);
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  belongsToAWrapper
- (BOOL)belongsToAWrapper;
/*"Description forthcoming. Required method. This is where we return the name for new projects
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return self.fileURL.enclosingWrapperURL4iTM3 != nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= projectURL
- (NSURL *)projectURL;
/*"Description forthcoming. Required method. This is where we return the name for new projects
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Fri Mar 19 19:23:41 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (self.creationMode == iTM2ToggleNewProjectMode) {
        NSString * newProjectName = self.newProjectName;
		if (self.preferWrapper) {
			newProjectName = [newProjectName stringByAppendingPathExtension:[SDC wrapperPathExtension4iTM3]];
			newProjectName = [newProjectName stringByAppendingPathComponent:self.newProjectName];
		}
		newProjectName = [newProjectName stringByAppendingPathExtension:[SDC projectPathExtension4iTM3]];
        return [self.fileURL.parentDirectoryURL4iTM3 URLByAppendingPathComponent:newProjectName];
	}
//END4iTM3;
    return [NSURL fileURLWithPath4iTM3:self.oldProjectName];
}
#pragma mark =-=-=-=-=-  WINDOW MNGT
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  windowWillLoad
- (void)windowWillLoad;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	//Preparing the projects for the table view
	NSAssert(self.fileURL.path.length,@"You must specify a file name...");
	[super windowWillLoad];
	[self setBaseProjectName:[SUD stringForKey:iTM2TeXProjectDefaultBaseNameKey]];
	[self setDocumentIsMaster:[SUD boolForKey:iTM2TeXProjectDocumentIsMasterFileKey]];
	[self setPreferWrapper:[SUD boolForKey:iTM2NewDocumentEnclosedInWrapperKey]];
	NSDictionary * availableProjects = [SPC availableProjectsForURL:self.fileURL];
	[self setAvailableProjects:availableProjects];
	NSInteger creationMode = [SUD integerForKey:iTM2NewProjectCreationModeKey];
	[self setCreationMode:creationMode];
	self.validateCreationMode;
//END4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  windowDidLoad
- (void)windowDidLoad;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	//Preparing the projects for the table view
	[super windowDidLoad];
    self.validateWindowContent4iTM3;
//END4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateWindowContent4iTM3
- (BOOL)validateWindowContent4iTM3;
/*"Before calling the inherited method, update the list of available projects.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [IMPLEMENTATION takeMetaValue:[SPC TeXBaseProjectsProperties] forKey:@"_TPPs"];// TeX Projects Properties
	self.validateCreationMode;
//LOG4iTM3(@"MD:%@", MD);
    return [super validateWindowContent4iTM3];
}
#pragma mark =-=-=-=-=-  UI
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  OK:
- (IBAction)OK:(id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	// testing for some consistency if we have to create folders at least:
	[SUD setObject:self.baseProjectName forKey:iTM2TeXProjectDefaultBaseNameKey];
	if(!self.belongsToAWrapper)
	{
		[SUD setBool:self.documentIsMaster forKey:iTM2TeXProjectDocumentIsMasterFileKey];
		[SUD setBool:self.preferWrapper forKey:iTM2NewDocumentEnclosedInWrapperKey];
		[SUD setObject:self.oldProjectName forKey:@"iTM2NewProjectLastChoice"];
	}
	[NSApp stopModalWithCode:self.creationMode];
//END4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  fileNameEdited:
- (IBAction)fileNameEdited:(id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateFileNameEdited:
- (BOOL)validateFileNameEdited:(NSTextField *) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSString * fileName = self.fileURL.path;
	sender.stringValue = (fileName.length? fileName.lastPathComponent:@"None");
//END4iTM3;
	return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  newProjectNameEdited:
- (IBAction)newProjectNameEdited:(NSTextField *) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSString * senderString = sender.stringValue.stringByDeletingPathExtension;
	if(senderString.length)
	{
		[self setNewProjectName:senderString];
	}
//END4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateNewProjectNameEdited:
- (BOOL)validateNewProjectNameEdited:(NSTextField *) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSString * newProjectName = self.newProjectName;
	if(self.belongsToAWrapper)
	{
		sender.stringValue = newProjectName;
		return NO;
	}
	if(!newProjectName.length)
	{
		newProjectName = self.fileURL.path;
		newProjectName = newProjectName.lastPathComponent;
		newProjectName = newProjectName.stringByDeletingPathExtension;
		if(newProjectName.length)
		{
			[self setNewProjectName:newProjectName];
		}
		else
		{
			LOG4iTM3(@"Weird? void _FileName");
		}
	}
	sender.stringValue = newProjectName;
	if(self.creationMode == iTM2ToggleNewProjectMode)
	{
		if(![sender.window.firstResponder isEqual:sender] && [sender acceptsFirstResponder])
		{
			[sender.window makeFirstResponder:sender];
			[sender selectText:self];
		}
        return YES;
	}
	else
	{
		return NO;
	}
//END4iTM3;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleDocumentIsMaster:
- (IBAction)toggleDocumentIsMaster:(id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	BOOL old = self.documentIsMaster;
	[self setDocumentIsMaster:!old];
	[sender validateWindowContent4iTM3];
//END4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleDocumentIsMaster:
- (BOOL)validateToggleDocumentIsMaster:(NSButton *) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	sender.state = (self.documentIsMaster? NSOnState:NSOffState);
//END4iTM3;
	return self.creationMode == iTM2ToggleNewProjectMode;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeProjectFromSelectedItem:
- (IBAction)takeProjectFromSelectedItem:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Nov  8 09:18:47 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[self setOldProjectName:[[sender selectedItem] representedObject]];
	self.validateWindowContent4iTM3;
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateTakeProjectFromSelectedItem:
- (BOOL)validateTakeProjectFromSelectedItem:(NSPopUpButton *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Nov  8 09:18:47 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSString * oldProjectName = self.oldProjectName;
	NSDictionary * availableProjects = self.availableProjects;
	if([sender isKindOfClass:[NSPopUpButton class]])
	{
		[sender removeAllItems];
		NSString * path;
		NSEnumerator * E = availableProjects.keyEnumerator;
		while(path = E.nextObject)
		{
			NSString * displayName = [availableProjects objectForKey:path];
			[sender addItemWithTitle:displayName];
			sender.lastItem.representedObject = path;
		}
		if([sender numberOfItems]>0)
		{
			NSInteger index = 0;
			if(!oldProjectName.length)
			{
				oldProjectName = [[sender itemAtIndex:index] representedObject];
				[self setOldProjectName:oldProjectName];
			}
			else
			{
				index = [sender indexOfItemWithRepresentedObject:oldProjectName];
				if(index<0)
				{
					// the preferred project oldProjectName, if any, is not listed in the available projects
					index = 0;// a better choice?
					oldProjectName = [[sender itemAtIndex:index] representedObject];
					[self setOldProjectName:oldProjectName];
				}
			}
			[sender selectItemAtIndex:index];
			return ([sender numberOfItems]>1) && (self.creationMode == iTM2ToggleOldProjectMode);
		}
		return NO;
	}
	else if([sender isKindOfClass:[NSMenuItem class]])
	{
		return availableProjects.count>1;
	}
//END4iTM3;
    return oldProjectName.length>0;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleWrapper:
- (IBAction)toggleWrapper:(id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	BOOL old = self.preferWrapper;
	[self setPreferWrapper:!old];
	[sender validateWindowContent4iTM3];
//END4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleWrapper:
- (BOOL)validateToggleWrapper:(NSButton *) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if(self.belongsToAWrapper)
	{
		sender.state = YES;
		return NO;
	}
	sender.state = (self.preferWrapper?NSOnState:NSOffState);
	return self.creationMode == iTM2ToggleNewProjectMode;
//END4iTM3;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeCreationModeFromTag:
- (IBAction)takeCreationModeFromTag:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Nov  8 09:18:47 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	// Hum, the sender is the matrix despite each cell is connected separately in interface builder
	[self setCreationMode:[[sender selectedCell] tag]];
	self.validateWindowContent4iTM3;
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateTakeCreationModeFromTag:
- (BOOL)validateTakeCreationModeFromTag:(NSButton *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Nov  8 09:18:47 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSInteger creationMode = self.creationMode;
	if(creationMode == iTM2ToggleForbiddenProjectMode)
	{
		sender.state = NSOffState;
		return NO;
	}
	sender.state = (sender.tag == creationMode? NSOnState:NSOffState);
	BOOL result = NO;
	switch(sender.tag)
	{
		case iTM2ToggleStandaloneMode:
			result = self.canBeStandalone;
			break;
		case iTM2ToggleOldProjectMode:
			result = self.canInsertInOldProject;
			break;
		case iTM2ToggleNewProjectMode:
			result = self.canCreateNewProject;
			break;
		default://iTM2ToggleForbiddenProjectMode
			result = NO;
			break;
	}
	return result;
}
#pragma mark =-=-=-=-=-  BASE PROJECT
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  chooseBaseMode:
- (IBAction)chooseBaseMode:(id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Mar 26 08:41:36 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSString * mode = [(id)[sender selectedItem] representedString];
	NSString * baseProjectName = self.baseProjectName;
    if([mode isEqualToString:[[[baseProjectName TeXProjectProperties4iTM3] iVarMode] lowercaseString]])
        return;
    NSDictionary * TPPs = [IMPLEMENTATION metaValueForKey:@"_TPPs"];// TeX Projects Properties...
    NSEnumerator * E = TPPs.keyEnumerator;
    NSDictionary * keyD;
    NSString * newBPN = @"";
    NSString * shortestName = @"";
    NSString * pdf = [iTM2TPFEPDFOutput lowercaseString];
    while(keyD = E.nextObject)
        if([[keyD iVarMode] isEqualToString:mode])
        {
            if([[keyD iVarVariant] isEqualToString:@""]
                && [[keyD iVarOutput] isEqualToString:pdf])
            {
                newBPN = [[TPPs objectForKey:keyD] iVarName];
                goto tahaa;
            }
            shortestName = [[TPPs objectForKey:keyD] iVarName];
            break;
        }
    while(keyD = E.nextObject)
	{
        if([[keyD iVarMode] isEqualToString:mode])
        {
            if([[keyD iVarVariant] isEqualToString:@""]
                && [[keyD iVarOutput] isEqualToString:pdf])
            {
                newBPN = [[TPPs objectForKey:keyD] iVarName];
                goto tahaa;
            }
            NSString * N = [[TPPs objectForKey:keyD] iVarName];
            if(N.length < shortestName.length)
			{
                shortestName = N;
			}
        }
	}
    newBPN = shortestName;
tahaa:
    [self setBaseProjectName:newBPN];
    [sender validateWindowContent4iTM3];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateChooseBaseMode:
- (BOOL)validateChooseBaseMode:(NSPopUpButton *) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Mar 26 08:41:36 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//LOG4iTM3(@"sender is:%@", sender);
    if([sender isKindOfClass:[NSPopUpButton class]])
    {
		static NSString * noModeTitle = nil;
		if(!noModeTitle)
			noModeTitle = [[sender.lastItem title] copy];
        [sender removeAllItems];
        NSMutableDictionary * MD = [NSMutableDictionary dictionary];
        NSDictionary * TPPs = [IMPLEMENTATION metaValueForKey:@"_TPPs"];
        NSEnumerator * E = TPPs.keyEnumerator;
        NSDictionary * D;
        while(D = E.nextObject)
        {
LOG4iTM3(@"D:%@",D);
LOG4iTM3(@"[D iVarMode]:%@",[D iVarMode]);
            [MD setValue:[[[TPPs objectForKey:D] valueForKey:iTM2TeXPCommandPropertiesKey] iVarMode]
                forKey:[D iVarMode]];
        }
            // the key is lowercase!!! the value need not
        E = [[[MD allKeys] sortedArrayUsingSelector:@selector(compare:)] objectEnumerator];
        NSString * k;
        while(k = E.nextObject)
        {
            [sender addItemWithTitle:[MD valueForKey:k]];
            sender.lastItem.representedObject = k;// the lowercase string
        }
        NSDictionary * Ps = [self.baseProjectName TeXProjectProperties4iTM3];
        NSString * mode = [Ps iVarMode];
        NSInteger idx = [sender indexOfItemWithRepresentedObject:[mode lowercaseString]];
        if(idx == -1 || idx == NSNotFound)
        {
            NSString * lastTitle = [NSString stringWithFormat:@"%@(Unknown)", mode];
            [sender.menu addItem:[NSMenuItem separatorItem]];
            [sender addItemWithTitle:lastTitle];
            [sender selectItem:sender.lastItem];        
            sender.lastItem.representedObject = nil;// BEWARE!!!
        }
        else
        {
            [sender selectItemAtIndex:idx];
        }
		if([sender numberOfItems] < 2)
			return NO;
     }
    return self.creationMode != iTM2ToggleOldProjectMode;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  chooseVariant:
- (IBAction)chooseVariant:(id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Mar 26 08:41:36 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSString * variant = [[(id)[sender selectedItem] representedString] lowercaseString];
//LOG4iTM3(@"variant chosen is:%@", variant);
    if([variant isEqualToString:iTM2ProjectDefaultsKey])
        variant = @"";
    NSDictionary * oldTPPs = [self.baseProjectName TeXProjectProperties4iTM3];
    if([variant isEqualToString:[[oldTPPs iVarVariant] lowercaseString]])
        return;
    NSString * mode = [[oldTPPs iVarMode] lowercaseString];
    NSDictionary * TPPs = [IMPLEMENTATION metaValueForKey:@"_TPPs"];
    NSEnumerator * E = TPPs.keyEnumerator;
    NSDictionary * keyD;
    NSString * newBPN = @"";
    NSString * shortestName = @"";
    NSString * pdf = [iTM2TPFEPDFOutput lowercaseString];
    while(keyD = E.nextObject)
    {
//LOG4iTM3(@"keyD is:%@", keyD]);
        if([[keyD iVarMode] isEqualToString:mode]
            && [[keyD iVarVariant] isEqualToString:variant])
        {
            newBPN = [[TPPs objectForKey:keyD] iVarName];
            if([[keyD iVarOutput] isEqualToString:pdf])
                goto tahaa;
            shortestName = newBPN;
            break;
        }
//LOG4iTM3(@"shortestName is:%@ (%@) ----1", shortestName, [[TPPs objectForKey:keyD] iVarName]);
    }
    while(keyD = E.nextObject)
    {
//LOG4iTM3(@"keyD is:%@", keyD]);
        if([[keyD iVarMode] isEqualToString:mode]
            && [[keyD iVarVariant] isEqualToString:variant])
        {
            newBPN = [[TPPs objectForKey:keyD] iVarName];
            if([[keyD iVarOutput] isEqualToString:pdf])
                goto tahaa;
            else if(newBPN.length < shortestName.length)
                shortestName = newBPN;
        }
//LOG4iTM3(@"shortestName is:%@ (%@)", shortestName, [[TPPs objectForKey:keyD] iVarName]);
    }
    newBPN = shortestName;
tahaa:
    [self setBaseProjectName:newBPN];
    [sender validateWindowContent4iTM3];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateChooseVariant:
- (BOOL)validateChooseVariant:(NSPopUpButton *) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Mar 26 08:41:36 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//LOG4iTM3(@"sender is:%@", sender);
    if([sender isKindOfClass:[NSPopUpButton class]])
    {
		static NSString * noModeTitle = nil;
		if(!noModeTitle)
			noModeTitle = [[sender.lastItem title] copy];
        [sender removeAllItems];
//LOG4iTM3(@"baseProjectName is:%@", self.baseProjectName);
        NSDictionary * Ps = [self.baseProjectName TeXProjectProperties4iTM3];
        NSString * baseMode = [[Ps iVarMode] lowercaseString];
//LOG4iTM3(@"baseMode is:%@", baseMode);
        NSMutableDictionary * MD = [NSMutableDictionary dictionary];
        NSDictionary * TPPs = [IMPLEMENTATION metaValueForKey:@"_TPPs"];
        NSEnumerator * E = TPPs.keyEnumerator;
        NSDictionary * keyD;
        while(keyD = E.nextObject)
            if([[[keyD iVarMode] lowercaseString] isEqualToString:baseMode])
            {
//LOG4iTM3(@"GOOD keyD is:%@", keyD);
                NSString * variant = [keyD iVarVariant];
                if(variant.length)
                    [MD setValue:[[[TPPs objectForKey:keyD] valueForKey:iTM2TeXPCommandPropertiesKey] iVarVariant]
                        forKey:variant];
                else
#warning DEBUGGGGG LOCALIZATION???
                    [MD setValue:@"None" forKey:iTM2ProjectDefaultsKey];
            }
            else
            {
//LOG4iTM3(@"BAD  keyD is:%@", keyD);
            }
        E = [[[MD allKeys] sortedArrayUsingSelector:@selector(compare:)] objectEnumerator];
        NSString * k;
        while(k = E.nextObject)
        {
            [sender addItemWithTitle:[MD valueForKey:k]];
            sender.lastItem.representedObject = k;// the lowercase string
        }
        NSString * variant = [Ps iVarVariant];
//LOG4iTM3(@"variant for validation is %@", variant);
        NSInteger idx = [sender indexOfItemWithRepresentedObject:(variant.length? [variant lowercaseString]:iTM2ProjectDefaultsKey)];
        if(idx == -1 || idx == NSNotFound)
        {
            NSString * lastTitle = [NSString stringWithFormat:@"%@(Unknown)", variant];
            [sender.menu addItem:[NSMenuItem separatorItem]];
            [sender addItemWithTitle:lastTitle];
            [sender selectItem:sender.lastItem];        
            sender.lastItem.representedObject = nil;// BEWARE!!!
        }
        else
        {
            [sender selectItemAtIndex:idx];
        }
		if([sender numberOfItems] < 2)
			return NO;
    }
    return self.creationMode != iTM2ToggleOldProjectMode;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  chooseOutput:
- (IBAction)chooseOutput:(id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Mar 26 08:41:36 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSString * output = [(id)[sender selectedItem] representedString];
    NSDictionary * Ps = [self.baseProjectName TeXProjectProperties4iTM3];
    NSString * mode = [[Ps iVarMode] lowercaseString];
    NSString * variant = [[Ps iVarVariant] lowercaseString];
    NSDictionary * TPPs = [IMPLEMENTATION metaValueForKey:@"_TPPs"];
    NSEnumerator * E = TPPs.keyEnumerator;
    NSDictionary * keyD;
    while(keyD = E.nextObject)
    {
        if([[keyD iVarMode] isEqualToString:mode]
            && [[[keyD iVarVariant] lowercaseString] isEqualToString:variant]
                && [[[keyD iVarOutput] lowercaseString] isEqualToString:output])
        {
            NSString * new = [[TPPs objectForKey:keyD] iVarName];
            [self setBaseProjectName:new];
            break;
        }
    }
    [sender validateWindowContent4iTM3];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateChooseOutput:
- (BOOL)validateChooseOutput:(NSPopUpButton *) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Mar 26 08:41:36 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//LOG4iTM3(@"sender is:%@", sender);
    if([sender isKindOfClass:[NSPopUpButton class]])
    {
		static NSString * noModeTitle = nil;
		if(!noModeTitle)
			noModeTitle = [[sender.lastItem title] copy];
        [sender removeAllItems];

//LOG4iTM3(@"baseProjectName is:%@", self.baseProjectName);
        NSDictionary * Ps = [self.baseProjectName TeXProjectProperties4iTM3];
//LOG4iTM3(@"Ps is:%@", Ps);
        NSString * mode = [[Ps iVarMode] lowercaseString];
        NSString * variant = [[Ps iVarVariant] lowercaseString];
        NSMutableDictionary * MD = [NSMutableDictionary dictionary];
        NSDictionary * TPPs = [IMPLEMENTATION metaValueForKey:@"_TPPs"];
        NSEnumerator * E = TPPs.keyEnumerator;
        NSDictionary * D;
        while(D = E.nextObject)
            if([[D iVarMode] isEqualToString:mode] && [[D iVarVariant] isEqualToString:variant])
            {
                NSString * output = [D iVarOutput];
                if(output.length)
                    [MD setValue:[[[TPPs objectForKey:D] valueForKey:iTM2TeXPCommandPropertiesKey] iVarOutput]
                        forKey:output];
            }
		[sender addItemWithTitle:iTM2TPFEPDFOutput];
		sender.lastItem.representedObject = [iTM2TPFEPDFOutput lowercaseString];// the lowercase string
        E = [[[MD allKeys] sortedArrayUsingSelector:@selector(compare:)] objectEnumerator];
        NSString * k;
        while(k = E.nextObject)
        {
            [sender addItemWithTitle:[MD valueForKey:k]];
            sender.lastItem.representedObject = k;// the lowercase string
        }
        NSString * output = [Ps iVarOutput];
        NSInteger idx = [sender indexOfItemWithRepresentedObject:[(output.length? output:iTM2TPFEPDFOutput) lowercaseString]];
        if(idx == -1 || idx == NSNotFound)
        {
            NSString * lastTitle = [NSString stringWithFormat:@"%@(Unknown)", output];
            [sender.menu addItem:[NSMenuItem separatorItem]];
            [sender addItemWithTitle:lastTitle];
            [sender selectItem:sender.lastItem];        
            sender.lastItem.representedObject = nil;// BEWARE!!!
        }
        else
        {
            [sender selectItemAtIndex:idx];
        }
		if([sender numberOfItems] < 2)
			return NO;
    }
    return self.creationMode != iTM2ToggleOldProjectMode;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleExportOutput:
- (IBAction)toggleExportOutput:(id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	BOOL old = self.exportOutput;
	[self setExportOutput:!old];
	[sender validateWindowContent4iTM3];
//END4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleExportOutput:
- (BOOL)validateToggleExportOutput:(NSButton *) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	sender.state = (self.exportOutput? NSOnState:NSOffState);
//END4iTM3;
	return self.creationMode == iTM2ToggleStandaloneMode;
}
@synthesize flags;
@end

@implementation iTM2TeXProjectInspector
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  windowNibName
+ (NSString *)windowNibName;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return NSStringFromClass(self);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  defaultShellEnvironment
+ (NSDictionary *)defaultShellEnvironment;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [NSDictionary dictionary];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  model
- (id)model;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [IMPLEMENTATION modelOfType:iTM2MainType];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeModel:
- (void)takeModel:(NSDictionary *) model;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [IMPLEMENTATION takeModel:(model? [NSMutableDictionary dictionaryWithDictionary:model]:[NSMutableDictionary dictionary]) ofType:iTM2MainType];
    self.validateWindowContent4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  modelValueForKey:
- (id)modelValueForKey:(NSString *) key;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [IMPLEMENTATION modelValueForKey:key ofType:iTM2MainType];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeModelValue:forKey:
- (void)takeModelValue:(id) value forKey:(NSString *) key;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	id old = [self modelValueForKey:key];
	if(iTM2DebugEnabled>100000)
	{
		LOG4iTM3(@"BEFORE - [self modelValueForKey:%@] is:%@ and should be:%@", key, old, value);
		if(!IMPLEMENTATION)
			NSLog(@"implementation missing");
	}
	if(![old isEqual:value])
	{
		[IMPLEMENTATION takeModelValue:value forKey:key ofType:iTM2MainType];
		self.validateWindowContent4iTM3;
	}
	if(iTM2DebugEnabled>100000)
	{
		LOG4iTM3(@"AFTER - [self modelValueForKey:%@] is:%@", key, [self modelValueForKey:key]);
	}
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  allShellEnvironmentVariables
+ (NSArray *)allShellEnvironmentVariables;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [self.defaultShellEnvironment allKeys];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  shellEnvironment
- (NSDictionary *)shellEnvironment;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSMutableDictionary * MD = [NSMutableDictionary dictionary];
    NSEnumerator * E = [[self.class allShellEnvironmentVariables] objectEnumerator];
    NSString * variable;
    while(variable = E.nextObject)
        [MD setValue:[self modelValueForKey:variable] forKey:variable];
	if(iTM2DebugEnabled>100)
	{
		LOG4iTM3(@"shellEnvironment is:%@", MD);
	}
//END4iTM3;
    return MD;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeShellEnvironment:
- (void)takeShellEnvironment:(NSDictionary *) environment;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if(iTM2DebugEnabled) {
		LOG4iTM3(@"environment is:%@", environment);
	}
    for (NSString * variable in [self.class allShellEnvironmentVariables]) {
        [self takeModelValue:[environment valueForKey:variable] forKey:variable];
		if(iTM2DebugEnabled) {
			LOG4iTM3(@"environment variable name is:%@, contents:%@", variable, [self modelValueForKey:variable]);
		}
	}
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initImplementation
- (void)initImplementation;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [super initImplementation];
    [self takeModel:nil];
	[self takeShellEnvironment:[self.class defaultShellEnvironment]];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setDocument:
- (void)setDocument:(NSDocument *) document;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [super setDocument:document];
    self.validateWindowContent4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  windowDidLoad
- (void)windowDidLoad;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [super windowDidLoad];
    self.validateWindowContent4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleModelFlagForKey:
- (void)toggleModelFlagForKey:(NSString *) key;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    BOOL old = [[self modelValueForKey:key] boolValue];
    [self takeModelValue:[NSNumber numberWithBool:!old] forKey:key];
    self.validateWindowContent4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  modelFlagForKey:
- (BOOL)modelFlagForKey:(NSString *) key;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSNumber * N = [self modelValueForKey:key];
	if([N respondsToSelector:@selector(boolValue)])
		return [N boolValue];
//LOG4iTM3(@"Unexpected model value:a number or so should be there");
    [self takeModelValue:[NSNumber numberWithBool:NO] forKey:key];
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  cancel:
- (IBAction)cancel:(NSControl *) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [NSApp endSheet:sender.window returnCode:NSAlertAlternateReturn];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  OK:
- (IBAction)OK:(NSControl *) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [NSApp endSheet:sender.window returnCode:NSAlertDefaultReturn];
//END4iTM3;
    return;
}
@end

@interface NSString(iTM2TeXProjectFrontendKit)
- (BOOL)boolValue4iTM3;
@end
@implementation NSString(iTM2TeXProjectFrontendKit)
- (BOOL)boolValue4iTM3;
{DIAGNOSTIC4iTM3;
	return [self.lowercaseString isEqualToString:@"yes"];
}
@end

//#import <iTM2Foundation/iTM2MenuKit.h>

NSString * const iTM2TPFEBaseProjectNameKey = @"BaseProjectName";

@implementation iTM2TeXProjectDocument(BaseProject)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  baseProjectName
- (NSString *)baseProjectName;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 31 07:10:06 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    //  This must not be inherited because of reentrant management
    return [self infoInherited:NO forKeyPaths:iTM2TPFEBaseProjectNameKey,nil];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setBaseProjectName:
- (void)setBaseProjectName:(NSString *) baseProjectName;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Wed Mar 31 07:10:10 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self setInfo:baseProjectName forKeyPaths:iTM2TPFEBaseProjectNameKey,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  baseProject
- (id)baseProject;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSString * baseProjectName = self.baseProjectName;
	if(!baseProjectName.length)
		return nil;
	id result = [SPC baseProjectWithName:baseProjectName];
    return result == self? nil:result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  baseProjectFixImplementation4iTM3
- (void)baseProjectFixImplementation4iTM3;
/*"Description forthcoming.
This message is sent at initialization time.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [SUD registerDefaults:
		[NSDictionary dictionaryWithObjectsAndKeys:@"LaTeX", iTM2TPFEBaseProjectNameKey, nil]];
	if(!self.baseProjectName)
		[self setBaseProjectName:[SUD objectForKey:iTM2TPFEBaseProjectNameKey]];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  description
- (NSString *)description;
/*"Projects are no close documents!!!
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [NSString stringWithFormat:@"<%@, fileName:%@, baseProjectName:%@>",
		[super description], self.fileURL.path, self.baseProjectName];
}
@end


#if 1
@implementation NSMenu(TESTING_PRIVATE_FRONTEND)
- (void)recursiveEnableCheck;
{DIAGNOSTIC4iTM3;
//START4iTM3;
//LOG4iTM3(@"self.title is:%@", self.title);
//LOG4iTM3(@"self.numberOfItems is:%i", self.numberOfItems);
    NSInteger i;
    for(i=0;i<self.numberOfItems;++i)
    {
        LOG4iTM3(@"[self itemAtIndex:%i] is:%@", i, [self itemAtIndex:i]);
    }
//END4iTM3;
    return;
}
@end
#endif

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2ProjectFrontendKit

@implementation NSObject(iTM2FrontendKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2PD__compareUsingTitle:
- (NSInteger)iTM2PD__compareUsingTitle:(NSMenuItem *) MI;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    // assuming that they have windows as targets
    return [MI respondsToSelector:@selector(title)]? NSOrderedAscending:NSOrderedSame;
}
@end
@implementation NSMenuItem(iTM2FontendKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2PD__compareUsingTitle:
- (NSInteger)iTM2PD__compareUsingTitle:(NSMenuItem *) MI;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    // assuming that they have windows as targets
    return [MI respondsToSelector:@selector(title)]? [self.title compare:MI.title]:NSOrderedDescending;
}
@end

@implementation iTM2ProjectController(TeXProjectFrontendKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  SWZ_iTM2_newProjectPanelControllerClass
- (Class)SWZ_iTM2_newProjectPanelControllerClass;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return [iTM2NewTeXProjectController class];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  newProjectPanelControllerClass
- (Class)newProjectPanelControllerClass;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return [iTM2NewTeXProjectController class];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  requiredTeXProjectForSource:
- (id)requiredTeXProjectForSource:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Fri Mar 26 22:18:29 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	id result = [self TeXProjectForSource:sender];
	if (result) {
		return result;
	}
	if (result = [self projectForSource:sender]) {
		return nil;
	}
	if ([sender isKindOfClass:[NSDocument class]]) {
		[sender setHasProject4iTM3:YES];
		if (result = [sender project4iTM3]) {
			return result;
		}
	} else if(!sender) {
		if ((sender = [SDC currentDocument])) {
			return [self requiredTeXProjectForSource:sender];
		}
	}
    return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  TeXProjectForSource:
- (id)TeXProjectForSource:(id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	id result = [self projectForSource:(id) sender];
    return [result isKindOfClass:[iTM2TeXProjectDocument class]]? result:nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  currentTeXProject
- (id)currentTeXProject;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	id result = self.currentProject;
    return [result isKindOfClass:[iTM2TeXProjectDocument class]]? result:nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  TeXBaseProjectsProperties
- (NSDictionary *)TeXBaseProjectsProperties;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSMutableDictionary * MD = [NSMutableDictionary dictionary];
    NSEnumerator * E = [self.baseProjectNames objectEnumerator];
    NSString * name;
    while(name = E.nextObject)
    {//projectName
//LOG4iTM3(@"project name:%@", name);
        NSDictionary * D = [name TeXProjectProperties4iTM3];
		NSDictionary * key = [NSDictionary dictionaryWithObjectsAndKeys:
			[[D iVarMode] lowercaseString], iTM2TPDKModeKey,
			[[D iVarVariant] lowercaseString], iTM2TPDKVariantKey,
			[[D iVarOutput] lowercaseString], iTM2TPDKOutputKey,
				nil];
		D = [NSDictionary dictionaryWithObjectsAndKeys:
			D, iTM2TeXPCommandPropertiesKey,
			name, iTM2TPDKNameKey,
				nil];
        [MD setValue:D forKey:(id)key];
    }
//START4iTM3;
	return MD;
}
@end

@implementation iTM2Document(iTM2TeXProject)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  project
- (id)project;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Mar 30 15:52:06 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	id result = [super project4iTM3];
	if(result)
		return result;
	NSURL * url = self.fileURL;
	if (self.hasProject4iTM3 && !url) {
		[self saveDocument:self];
		url = self.fileURL;
		if (!url) {
			[self setHasProject4iTM3:NO];
			return nil;
		}
	}
	if (self.hasProject4iTM3) {
		if (result = [SPC freshProjectForURLRef:&url display:NO error:nil]) {
			if(![url.path pathIsEqual4iTM3:self.fileURL.path])
				[self setFileURL:url];// weird code, this is possobly due to a cocoa weird behaviour
		} else {
			[self setHasProject4iTM3:NO];
		}
	}
    return result;
}
@end

#warning DEBUG:THIS MUST BE IMPLEMENTED 
#if 0
@implementation iTM2PDFDocument(TeXProjectFrontendKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  enableProjectSupporFixImplementation4iTM3
- (void)enableProjectSupporFixImplementation4iTM3;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1:03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [INC addObserver:self
        selector:@selector(projectWillProcessNotified:)
            name:iTM2TeXProjectWillTypesetNotification
                object:nil];
    [INC addObserver:self
        selector:@selector(projectWillProcessNotified:)
            name:iTM2TeXProjectWillCompileNotification
                object:nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  projectWillProcessNotified:
- (void)projectWillProcessNotified:(NSNotification *) notification;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1:03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [[self.album centeredSubview] updateFocusInformation];
    return;
}
@end
#endif

NSString * const iTM2ToolbarProjectSettingsItemIdentifier = @"showCurrentProjectSettings";
NSString * const iTM2ToolbarProjectFilesItemIdentifier = @"showCurrentProjectFiles";
NSString * const iTM2ToolbarProjectTerminalItemIdentifier = @"showCurrentProjectTerminal";

@implementation iTM2ProjectDocumentResponder(TeXProject)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  projectShowTerminal:
- (IBAction)projectShowTerminal:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [[SPC projectForSource:sender] showTerminal:sender];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateProjectShowTerminal:
- (BOOL)validateProjectShowTerminal:(NSMenuItem *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if(!sender.image)
	{
		NSString * name = @"projectShowTerminal(small)";
		NSImage * I = [NSImage cachedImageNamed4iTM3:name];
		if(![I isNotNullImage4iTM3])
		{
			I = [[NSImage cachedImageNamed4iTM3:@"showCurrentProjectTerminal"] copy];
			[I setName:name];
			[I setSizeSmallIcon4iTM3];
		}
		sender.image = I;//size
	}
//END4iTM3;
    return [SPC currentProject] != nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  showCurrentProjectSettings:
- (IBAction)showCurrentProjectSettings:(id) sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue May  3 16:20:26 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[[SPC projectForSource:nil] showSettings:sender];
//END4iTM3;
	return;
}  
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  showCurrentProjectFiles:
- (IBAction)showCurrentProjectFiles:(id) sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue May  3 16:20:26 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[[SPC projectForSource:nil] showFiles:sender];
//END4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  showCurrentProjectFilesWillPopUp:
- (BOOL)showCurrentProjectFilesWillPopUp:(id) sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue May  3 16:20:26 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	id PD = [SPC projectForSource:nil];
	NSEnumerator * E = [[PD allKeys] objectEnumerator];
	NSMutableDictionary * MD = [NSMutableDictionary dictionary];
	NSString * S;
	while(S = E.nextObject)
	{
		NSString * FN = [PD nameForFileKey:S];
		if(FN.length)
			[MD setObject:S forKey:FN];
	}
	NSArray * sortedKeys = [[MD allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
	if(![NSApp targetForAction:@selector(projectEditDocumentUsingRepresentedObject:)])
	{
		LOG4iTM3(@"..........  ERROR:the project responder is not yet installed!");
	}
	NSMenu * M = [[[NSMenu alloc] initWithTitle:@""] autorelease];
	[M addItemWithTitle:@"" action:NULL keyEquivalent:@""];// first item is used a s title
	// populating the menu with project documents
	if(sortedKeys.count)
	{
		for(S in sortedKeys)
		{
			NSMenuItem * MI = [[[NSMenuItem alloc] initWithTitle:S
							action:@selector(projectEditDocumentUsingRepresentedObject1:) keyEquivalent:@""] autorelease];
			[M addItem:MI];
			MI.target = nil;
			NSString * key = [MD objectForKey:S];
			NSURL * url = [PD URLForFileKey:key];
			NSImage * I = [SWS iconForFile:url.path];
			[I setSizeSmallIcon4iTM3];
			MI.image = I;
			MI.representedObject = [NSDictionary dictionaryWithObjectsAndKeys:
					[NSValue valueWithNonretainedObject:PD], @"project",
					key, @"key",
						nil];
		}
	}
	[[sender popUpCell] setMenu:M];
	[M update];
	return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  showCurrentProjectTerminal:
- (IBAction)showCurrentProjectTerminal:(id) sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue May  3 16:20:26 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[[SPC projectForSource:nil] showTerminal:sender];
//END4iTM3;
	return;
}  
@end

#define DEFINE_TOOLBAR_ITEM(SELECTOR)\
+ (NSToolbarItem *)SELECTOR;{return [self toolbarItemWithIdentifier4iTM3:[self identifierFromSelector4iTM3:_cmd] inBundle:[iTM2TeXProjectInspector classBundle4iTM3]];}

#import <iTM2TeXFoundation/iTM2TeXPCommandWrapperKit.h>

@implementation NSToolbarItem(iTM2TeXProject)
DEFINE_TOOLBAR_ITEM(showCurrentProjectSettingsToolbarItem)
DEFINE_TOOLBAR_ITEM(showCurrentProjectTerminalToolbarItem)
+ (NSToolbarItem *)showCurrentProjectFilesToolbarItem;
{
	NSToolbarItem * toolbarItem = [self toolbarItemWithIdentifier4iTM3:[self identifierFromSelector4iTM3:_cmd] inBundle:[iTM2TeXProjectInspector classBundle4iTM3]];
	NSRect frame = NSMakeRect(0, 0, 32, 32);
	iTM2MixedButton * B = [[[iTM2MixedButton alloc] initWithFrame:frame] autorelease];
	[B setButtonType:NSMomentaryChangeButton];
//	[B setButtonType:NSOnOffButton];
	B.image = toolbarItem.image;
	[B setImagePosition:NSImageOnly];
	B.action = @selector(showCurrentProjectFiles:);
	[B setBezelStyle:NSShadowlessSquareBezelStyle];
//	[B.cell setHighlightsBy:NSMomentaryChangeButton];
	[B setBordered:NO];
	toolbarItem.view = B;
	toolbarItem.maxSize = toolbarItem.minSize = frame.size;
	B.target = nil;
	[B.cell setBackgroundColor:[NSColor clearColor]];
	NSMenu * M = [[[NSMenu alloc] initWithTitle:@""] autorelease];
	NSPopUpButton * PB = [[[NSPopUpButton alloc] initWithFrame:NSZeroRect] autorelease];
	[PB setMenu:M];
	[PB setPullsDown:YES];
	[B.cell setPopUpCell:PB.cell];
	return toolbarItem;
}
@end

@implementation iTM2ProjectDocumentResponder(FrontendKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= projectEditDocumentUsingRepresentedObject1:
- (void)projectEditDocumentUsingRepresentedObject1:(id) sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (10/04/2001)
- 2.0: Fri Apr 16 11:39:43 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSDictionary * D = [sender representedObject];
	NSValue * V = [D objectForKey:@"project"];
	if([V isKindOfClass:[NSValue class]])
	{
		id PD = [V nonretainedObjectValue];
		if([SPC isProject:PD] || [SPC isBaseProject:PD])
		{
			NSString * key = [D objectForKey:@"key"];
			if([key isKindOfClass:[NSString class]])
			{
				NSURL * url = [PD URLForFileKey:key];
                [SDC openDocumentWithContentsOfURL:url display:YES error:nil];
			}
			return;
		}
	}
	LOG4iTM3(@"*** BIG UNEXPECTED PROBLEM");
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= validateProjectEditDocumentUsingRepresentedObject1:
- (BOOL)validateProjectEditDocumentUsingRepresentedObject1:(id) sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (10/04/2001)
- 2.0: Fri Apr 16 11:39:43 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSDictionary * D = [sender representedObject];
	NSValue * V = [D objectForKey:@"project"];
	if([V isKindOfClass:[NSValue class]])
	{
		id PD = [V nonretainedObjectValue];
		if([SPC isProject:PD] || [SPC isBaseProject:PD])
		{
			NSString * key = [D objectForKey:@"key"];
			if([key isKindOfClass:[NSString class]])
			{
				NSString * path = [[PD URLForFileKey:key] path];
                return [DFM fileExistsAtPath:path];
			}
		}
	}
	LOG4iTM3(@"*** BIG UNEXPECTED PROBLEM");
	return NO;
}
@end

@implementation iTM2MainInstaller(TeXProjectFrontendKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  load
+ (void)prepareTeXProjectFrontendKitCompleteInstallation4iTM3;
/*"Description forthcoming.
 Version History: jlaurens AT users DOT sourceforge DOT net
 - 1.4: Fri Feb 20 13:19:00 GMT 2004
 To Do List:
 "*/
{
	if([iTM2ProjectController swizzleInstanceMethodSelector4iTM3:@selector(SWZ_iTM2_newProjectPanelControllerClass) error:NULL])
	{
		MILESTONE4iTM3((@"iTM2ProjectController(TeXProjectFrontendKit)"),(@"WARNING: No swizzled newProjectPanelControllerClass..."));
	}
	if([NSDocumentController swizzleInstanceMethodSelector4iTM3:@selector(SWZ_iTM2TPFE_displayPageForLine:column:source:withHint:orderFront:force:) error:NULL])
	{
		MILESTONE4iTM3((@"NSDocumentController(iTM2TeXProjectFrontend)"),(@"WARNING: displayPageForLine:column:source:withHint:orderFront:force: is not the expected one."));
	}
	[SUD setObject:@"LaTeX" forKey:iTM2TeXProjectDefaultBaseNameKey];
	[SUD registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:
						   @"LaTeX", iTM2TeXProjectDefaultBaseNameKey,
						   @"~", @"iTM2BackupSuffix",
								nil]];
}
@end

