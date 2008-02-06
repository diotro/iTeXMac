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
#import <iTM2Foundation/iTM2BundleKit.h>
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  load
+ (void)load;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
	iTM2_INIT_POOL;
	iTM2RedirectNSLogOutput();
//iTM2_START;
	[iTM2RuntimeBrowser swizzleInstanceMethodSelector:@selector(displayPageForLine:column:source:withHint:orderFront:force:) replacement:@selector(SWZ_iTM2TPFE_displayPageForLine:column:source:withHint:orderFront:force:) forClass:[iTM2DocumentController class]];
//iTM2_END;
	iTM2_RELEASE_POOL;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  SWZ_iTM2TPFE_displayPageForLine:column:source:withHint:orderFront:force:
- (BOOL)SWZ_iTM2TPFE_displayPageForLine:(unsigned int)line column:(unsigned int)column source:(NSURL *)sourceURL withHint:(NSDictionary *)hint orderFront:(BOOL)yorn force:(BOOL)force;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSURL * url = nil;
	NSString * output = nil;
	NSDocument * D = nil;
	iTM2TeXProjectDocument * TPD = [SPC projectForURL:sourceURL];
	if(TPD)
	{
		NSArray * subdocuments = [TPD subdocuments];
		NSEnumerator * E = [subdocuments objectEnumerator];
		BOOL displayed = NO;
		while(D = [E nextObject])
		{
			if([D displayPageForLine:line column:column source:sourceURL withHint:hint orderFront:yorn force:force])
			{
				displayed = YES;
			}
		}
		if(displayed)
			return YES;
		if(!force)
			return NO;
		NSString * masterKey = [TPD masterFileKey];
		NSURL * masterURL = [TPD URLForFileKey:masterKey];
		if(masterURL)
		{
			output = [[[masterURL path] stringByDeletingPathExtension] stringByAppendingPathExtension:[TPD outputFileExtension]];
			url = [NSURL fileURLWithPath:output];
			if(![TPD subdocumentForURL:url] &&
				(D = [self openDocumentWithContentsOfURL:url display:NO error:nil]))
			{
				return [D displayPageForLine:line column:column source:sourceURL withHint:hint orderFront:yorn force:force];
			}
			url = [url URLByRemovingCachedProjectComponent];
			if(![TPD subdocumentForURL:url] &&
				(D = [self openDocumentWithContentsOfURL:url display:NO error:nil]))
			{
				return [D displayPageForLine:line column:column source:sourceURL withHint:hint orderFront:yorn force:force];
			}
#warning THIS SHOULD BE REVISITED
			if([[TPD fileURL] belongsToCachedProjectsDirectory])
			{
				url = [TPD factoryURLForFileKey:masterKey];
				if(![TPD subdocumentForURL:url] &&
					(D = [self openDocumentWithContentsOfURL:url display:NO error:nil]))
				{
					return [D displayPageForLine:line column:column source:sourceURL withHint:hint orderFront:yorn force:force];
				}
			}
		}
	}
	else if(sourceURL)
	{
		output = [[[sourceURL path] stringByDeletingPathExtension] stringByAppendingPathExtension:@"pdf"];
		if([DFM fileExistsAtPath:output])// save some time
		{
			url = [NSURL fileURLWithPath:output];
			if(D = [self openDocumentWithContentsOfURL:url display:NO error:nil])
				return [D displayPageForLine:line column:column source:sourceURL withHint:hint orderFront:yorn force:force];// time consuming
		}
	}
//iTM2_END;
	return [self SWZ_iTM2TPFE_displayPageForLine:line column:column source:sourceURL withHint:hint orderFront:yorn force:force];
}
@end

//#import "iTM2TeXPCommandWrapperKit.h"
#import "iTM2TeXProjectCommandKit.h"

NSString * const iTM2TeXProjectDefaultBaseNameKey = @"iTM2TeXProjectBaseName";

@implementation iTM2TeXProjectDocument(Frontend)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  load
+ (void)load;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
	iTM2_INIT_POOL;
	iTM2RedirectNSLogOutput();
//iTM2_START;
	[SUD setObject:@"LaTeX" forKey:iTM2TeXProjectDefaultBaseNameKey];
//iTM2_START;
	iTM2_RELEASE_POOL;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  outputFileExtension
- (NSString *)outputFileExtension;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [self infoForKeyPaths:iTM2TPFEOutputFileExtensionKey,nil]?:@"pdf";
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setOutputFileExtension:
- (void)setOutputFileExtension:(NSString *) extension;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self takeInfo:extension forKeyPaths:iTM2TPFEOutputFileExtensionKey,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  editCommands:
- (void)editCommands:(id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSEnumerator * E = [[self windowControllers] objectEnumerator];
    NSWindowController * WC;
    while(WC = [E nextObject])
        if([WC isKindOfClass:[iTM2TeXPCommandsInspector class]])
        {
            [[WC window] makeKeyAndOrderFront:self];
            return;
        }
    WC = [[[iTM2TeXPCommandsInspector allocWithZone:[self zone]] initWithWindowNibName:NSStringFromClass([iTM2TeXPCommandsInspector class])] autorelease];
    [self addWindowController:WC];
    [[WC window] makeKeyAndOrderFront:self];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  showSettings:
- (void)showSettings:(id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSEnumerator * E = [[self windowControllers] objectEnumerator];
    NSWindowController * WC;
    while(WC = [E nextObject])
        if([WC isKindOfClass:[iTM2TeXPCommandsInspector class]])
        {
            [[WC window] makeKeyAndOrderFront:self];
            return;
        }
    WC = [[[iTM2TeXPCommandsInspector allocWithZone:[self zone]] initWithWindowNibName:NSStringFromClass([iTM2TeXPCommandsInspector class])] autorelease];
    [self addWindowController:WC];
    [[WC window] makeKeyAndOrderFront:self];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= smartShowTerminal:
- (void)smartShowTerminal:(id) sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (10/04/2001)
- 1.4: Fri Apr 16 11:39:43 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//    [self reallyMakeWindowControllers];
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
//    [self reallyMakeWindowControllers];
#warning DEBUGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG
//iTM2_LOG(@"%@", [self taskController]);
//iTM2_LOG(@"%@", [[self taskController] inspectorsEnumerator]);
//iTM2_LOG(@"%@", [[[self taskController] inspectorsEnumerator] nextObject]);
	NSWindow * W = [[[[self taskController] inspectorsEnumerator] nextObject] window];
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSEnumerator * E = [[self windowControllers] objectEnumerator];
    NSWindowController * WC;
    while(WC = [E nextObject])
        if([WC isKindOfClass:[iTM2TeXSubdocumentsInspector class]])
        {
            [[WC window] makeKeyAndOrderFront:self];
            return;
        }
    WC = [[[iTM2TeXSubdocumentsInspector allocWithZone:[self zone]] initWithWindowNibName:NSStringFromClass([iTM2TeXSubdocumentsInspector class])] autorelease];
    [self addWindowController:WC];
    [[WC window] makeKeyAndOrderFront:self];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= showTerminalInBackGroundIfNeeded
- (void)showTerminalInBackGroundIfNeeded:(id) sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (10/04/2001)
- Thu Oct 28 14:05:13 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//    [self reallyMakeWindowControllers];
	if([[self taskController] isMute])
		return;
	NSWindow * mainWindow = [NSApp mainWindow];
	iTM2TeXPTaskInspector * inspector = [[[self taskController] inspectorsEnumerator] nextObject];
	if([inspector isHidden])
		return;
	NSWindow * window = [inspector window];
	if(!window)
		window = [[self inspectorAddedWithMode:[iTM2TeXPTaskInspector inspectorMode]] window];
	if(mainWindow && ![window isEqual:mainWindow] 
		&& ![self contextBoolForKey:iTM2TeXProjectNoTerminalBehindKey domain:iTM2ContextAllDomainsMask])
	{
		[window iTM2_orderBelowFront:self];
	}
	else
	{
		[window orderFront:self];
	}
    [self iTM2_validateWindowsContents];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  projectName
- (NSString *)projectName;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * projectName = [super projectName];
	if([projectName length])
		return projectName;
	projectName = [[[self nameForFileKey:[self masterFileKey]] lastPathComponent] stringByDeletingPathExtension];
	return projectName;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= keepBackupFile
- (BOOL)keepBackupFile;
/*"Description forthcoming. NO is recommended unless synch problems might occur.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1:03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [self contextBoolForKey:@"iTM2TeXProjectKeepBackup" domain:iTM2ContextAllDomainsMask];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= template_isValidCommandEnvironmentMode:forScriptMode:
- (BOOL)template_isValidCommandEnvironmentMode:(NSString *) environmentMode forScriptMode:(NSString *) scriptMode;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1:03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= isValidEnvironmentMode:forScriptMode:commandName:
- (BOOL)isValidEnvironmentMode:(NSString *) environmentMode forScriptMode:(NSString *) scriptMode commandName:(NSString *) commandName;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1:03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(![commandName length])
		return NO;
	const char * command = [commandName cString];
	size_t size = (37+strlen(command));
	char * selName = malloc(size);
	if(!selName)
	{
		iTM2_LOG(@"*** ERROR:Memory management problem.");
		return NO;
	}
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
	NSString * selectorName = [NSString stringWithCString:selName];
	SEL selector = NSSelectorFromString(selectorName);
	free(selName);
	NSMethodSignature * myMS = [self methodSignatureForSelector:@selector(template_isValidCommandEnvironmentMode:forScriptMode:)];
	NSMethodSignature * MS = [self methodSignatureForSelector:selector];
	if(iTM2DebugEnabled)
	{
		iTM2_LOG(@"Method signature is:%@, for selector:%@", MS, selectorName);
	}
	if([myMS isEqual:MS])
	{
		NSInvocation * I = [NSInvocation invocationWithMethodSignature:MS];
		[I setSelector:selector];
		[I setArgument:&environmentMode atIndex:2];
		[I setArgument:&scriptMode atIndex:3];
		[I invokeWithTarget:self];
		BOOL flag;
		[I getReturnValue:&flag];
	 //iTM2_END;
		return flag;
	}
	// default behaviour scriptMode -> environment mode
	// void -> void
	// base -> base or command name
	// other -> everything
	if([scriptMode isEqualToString:iTM2TPFEVoidMode])
		return [environmentMode isEqualToString:iTM2TPFEVoidMode];
//iTM2_LOG(@"environmentMode is:%@", environmentMode);
//iTM2_LOG(@"commandName is:%@", commandName);
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
@end
@implementation iTM2TeXPShellScriptLabelFormatter
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inspectorType
- (void)setEmptyFormat:(NSString *) format;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[iVarEmptyFormat autorelease];
	iVarEmptyFormat = [format copy];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  dealloc
- (void)dealloc;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self setEmptyFormat:nil];
	[super dealloc];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  getObjectValue:forString:errorDescription:
- (BOOL)getObjectValue:(id *) obj forString:(NSString *) string errorDescription:(NSString **) error
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(obj)
	{
		* obj = string;
//iTM2_END;
		return YES;
	}
	else
	{
		if(error)
			* error = @"ERROR:Don't know where to put the object...";
//iTM2_END;
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
	return obj?:@"";
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  attributedStringForObjectValue:withDefaultAttributes:
- (NSAttributedString *)attributedStringForObjectValue:(id) obj withDefaultAttributes:(NSDictionary *) attrs;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSAttributedString * result;
	NSString * s = [self stringForObjectValue:obj];
	if([s length])
		result = [[[NSAttributedString allocWithZone:[self zone]] initWithString:s attributes:attrs] autorelease];
	else
	{
		NSMutableDictionary * MD = [NSMutableDictionary dictionaryWithDictionary:attrs];
		[MD setObject:[NSColor disabledControlTextColor] forKey:NSForegroundColorAttributeName];
		result = [[[NSAttributedString allocWithZone:[self zone]] initWithString:([iVarEmptyFormat length]?iVarEmptyFormat:@"NO DESCRIPTION AVAILABLE")
			attributes:MD] autorelease];
	}
//iTM2_LOG(@"result is:%@", result);
	return result;
}
@end

@implementation iTM2TeXPShellScriptInspector
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inspectorType
+ (NSString *)inspectorType;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return @"Project Helper";
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inspectorMode
+ (NSString *)inspectorMode;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return @"Shell Script";
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initWithWindow:
- (id)initWithWindow:(NSWindow *) window;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(self = [super initWithWindow:window])
	{
		[self fixImplementation];
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[IMPLEMENTATION takeMetaValue:[NSMutableDictionary dictionary] forKey:@"scriptDescriptor"];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  OK:
- (IBAction)OK:(id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [NSApp endSheet:[sender window] returnCode:NSAlertDefaultReturn];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  cancel:
- (IBAction)cancel:(id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [NSApp endSheet:[sender window] returnCode:NSAlertAlternateReturn];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  textView
- (NSTextView *)textView;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return metaGETTER;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setTextView:
- (void)setTextView:(NSTextView *) TV;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self window];
    [IMPLEMENTATION takeMetaValue:(scriptDescriptor? [[scriptDescriptor copy] autorelease]:[NSMutableDictionary dictionary])
		forKey:@"scriptDescriptor"];
    NSString * shellScript = [scriptDescriptor valueForKey:iTM2TPFEContentKey];
    if(![shellScript length])
        shellScript = @"#!/bin/sh\n";
    unsigned end;
    [shellScript getLineStart:nil end:&end contentsEnd:nil forRange:NSMakeRange(0, 0)];
    [[self textView] setString:[shellScript substringWithRange:NSMakeRange(end, [shellScript length] - end)]];
    [IMPLEMENTATION takeMetaValue:(end>2? [shellScript substringWithRange:NSMakeRange(2, end-3)]:@"") forKey:iTM2TPFEShellKey];
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
    id result = [[[IMPLEMENTATION metaValueForKey:@"scriptDescriptor"] mutableCopy] autorelease];
	if(!result)
		result = [NSMutableDictionary dictionary];
    [result takeValue:[NSString stringWithFormat:@"#!%@\n%@", [IMPLEMENTATION metaValueForKey:iTM2TPFEShellKey], [[self textView] string]] forKey:iTM2TPFEContentKey];
    [result takeValue:[IMPLEMENTATION metaValueForKey:iTM2TPFELabelKey] forKey:iTM2TPFELabelKey];
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  windowDidLoad
- (void)windowDidLoad;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [super windowDidLoad];
    [self iTM2_validateWindowContent];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  editLabel:
- (IBAction)editLabel:(id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [IMPLEMENTATION takeMetaValue:[sender objectValue] forKey:iTM2TPFELabelKey];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateEditLabel:
- (BOOL)validateEditLabel:(id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(![[sender formatter] isKindOfClass:[iTM2TeXPShellScriptLabelFormatter class]])
	{
		iTM2TeXPShellScriptLabelFormatter * F = [[[iTM2TeXPShellScriptLabelFormatter allocWithZone:[sender zone]] init] autorelease];
		[F setEmptyFormat:[sender stringValue]];
		[sender setFormatter:F];
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateInsertSpecialEnvironmentVariable:
- (BOOL)validateInsertSpecialEnvironmentVariable:(id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([sender isKindOfClass:[NSPopUpButton class]])
	{
		[sender removeAllItems];
		[sender addItemWithTitle:NSLocalizedStringFromTableInBundle(@"Insert Special Environment Variable", @"Commands", myBUNDLE, "Description forthcoming")];
			[[sender lastItem] setEnabled:NO];
		[sender addItemWithTitle:NSLocalizedStringFromTableInBundle(TWSShellEnvironmentProjectKey, @"Commands", myBUNDLE, "Description forthcoming")];
			[[sender lastItem] setAction:@selector(_insertSpecialEnvironmentVariable:)];
			[[sender lastItem] setEnabled:YES];
			[[sender lastItem] setTarget:self];// sender belongs to the receiver's window
			[[sender lastItem] setRepresentedObject:TWSShellEnvironmentProjectKey];
		[sender addItemWithTitle:NSLocalizedStringFromTableInBundle(TWSShellEnvironmentFrontKey, @"Commands", myBUNDLE, "Description forthcoming")];
			[[sender lastItem] setAction:@selector(_insertSpecialEnvironmentVariable:)];
			[[sender lastItem] setEnabled:YES];
			[[sender lastItem] setTarget:self];// sender belongs to the receiver's window
			[[sender lastItem] setRepresentedObject:TWSShellEnvironmentFrontKey];
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[[self textView] insertText:[NSString stringWithFormat:@"${%@}", [sender representedObject]]];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  saveDocument:
- (IBAction)saveDocument:(id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Mar 26 08:41:36 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateSaveDocument:
- (BOOL)validateSaveDocument:(id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Mar 26 08:41:36 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return NO;
}
@end

@implementation iTM2TeXSubdocumentsInspector(iTM2FrontendKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2_windowsMenuItemTitleForDocumentDisplayName:
- (NSString *)iTM2_windowsMenuItemTitleForDocumentDisplayName:(NSString *) displayName;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [[self class] prettyInspectorMode];
}
@end

NSString * const iTM2TPFEModeKey = @"iTM2_project_mode";
NSString * const iTM2TPFEVariantKey = @"iTM2_project_variant";
NSString * const iTM2TPFEOutputKey = @"iTM2_project_output";
NSString * const iTM2TPFENameKey = @"name";
NSString * const iTM2TPFEPDFOutput = @"PDF";

//#import <iTM2Foundation/iTM2InstallationKit.h>
//#import <iTM2Foundation/iTM2Implementation.h>

@interface NSString(TeXPFrontend0)
- (BOOL)isValidTeXProjectPath;
@end

@implementation iTM2MainInstaller(TeXPFrontend)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initialize
+ (void)iTM2TeXPFrontendCompleteInstallation;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[SUD registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:
		@"~", @"iTM2BackupSuffix", nil]];
//iTM2_LOG(@"iTM2BackupSuffix -is-:%@", [SUD stringForKey:@"iTM2BackupSuffix"]);
//iTM2_END;
	return;
}
@end

@implementation NSString(TeXPFrontend)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  TeXProjectProperties
- (NSDictionary *)TeXProjectProperties;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSString * mode = @"";
    NSString * output = @"";
    NSString * variant = @"";
    NSString * name = [[self lastPathComponent] stringByDeletingPathExtension];
	NSArray * components = [name componentsSeparatedByString:@"+"];
	if([components count]>1)
	{
		mode = [components objectAtIndex:0];
		components = [[components objectAtIndex:1] componentsSeparatedByString:@"-"];
		if([components count]>1)
		{
			output = [components objectAtIndex:0];
			variant = [components objectAtIndex:1];
		}
		else if([components count])
		{
			output = [components objectAtIndex:0];
		}
		else
		{
			output = iTM2TPFEPDFOutput;
		}
	}
	else if([components count])
	{
		output = iTM2TPFEPDFOutput;
		components = [[components objectAtIndex:0] componentsSeparatedByString:@"-"];
		if([components count])
			mode = [components objectAtIndex:0];
		if([components count]>1)
			variant = [components objectAtIndex:1];
	}
	else
	{
		mode = @"LaTeX";
	}
//iTM2_LOG(@"For name:%@, mode:%@, output:%@, variant:%@", name, mode, output, variant);
    return [NSDictionary dictionaryWithObjectsAndKeys:mode, iTM2TPFEModeKey, output, iTM2TPFEOutputKey, variant, iTM2TPFEVariantKey, nil];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  isValidTeXProjectPath
- (BOOL)isValidTeXProjectPath;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return ![[self stringByDeletingPathExtension] hasSuffix:[SUD stringForKey:@"iTM2BackupSuffix"]];
}
@end

//#import <iTM2Foundation/iTM2PathUtilities.h>
//#import <iTM2Foundation/iTM2BundleKit.h>

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2TeXProjectDocumentKit

NSString * const iTM2TeXProjectDocumentIsMasterFileKey = @"iTM2TeXProjectDocumentIsMaster";

extern NSString * const iTM2TeXWrapperPathExtension;

typedef struct {
        unsigned int        hasEnclosingProject:1;
        unsigned int        hasEnclosingWrapper:1;
        unsigned int        hasEnclosedProjects:1;
        unsigned int        isWritable:1;
        unsigned int        preferWrapper:1;
        unsigned int        standalone:1;
        unsigned int        old:1;
        unsigned int        new:1;
        unsigned int        reserved:24;
    } iTM2NewTeXProjectFlags;

@implementation iTM2NewTeXProjectController
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setUpProject:
- (void)setUpProject:(id)projectDocument;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (08/29/2001):
- 1.3:03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[projectDocument setBaseProjectName:[self baseProjectName]];
//iTM2_END;
	return;
}
#pragma mark =-=-=-=-=-  ACCESSORS
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  fileName
- (NSString *)fileName;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (08/29/2001):
- 1.3:03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	return metaGETTER;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setFileName:
- (void)setFileName:(NSString *)fileName;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (08/29/2001):
- 1.3:03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	metaSETTER(fileName);
	NSString * enclosingWrapper = [fileName enclosingWrapperFileName];
	if([enclosingWrapper length])
	{
		// the file already belongs to a wrapper
		[self setPreferWrapper:YES];
		[self setCreationMode:iTM2ToggleNewProjectMode];
		NSArray * enclosedProjects = [enclosingWrapper availableProjectFileNames];
		NSEnumerator * E = [enclosedProjects objectEnumerator];
		NSString * project = nil;
		while(project = [E nextObject])
		{
			if([fileName belongsToDirectory:[project stringByDeletingLastPathComponent]])
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * result = metaGETTER;
	if(result)
	{
		return result;
	}
	result = [self fileName];
	result = [result lastPathComponent];
	result = [result stringByDeletingPathExtension];
//iTM2_END;
	return result?:@"?";
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setNewProjectName:
- (void)setNewProjectName:(NSString *)argument;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (08/29/2001):
- 1.3:03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	metaSETTER(argument);
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= oldProjectName
- (NSString *)oldProjectName;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * result = metaGETTER;
	if([result length]>0)
	{
		return result;
	}
//iTM2_END;
	return @"";
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= setOldProjectName:
- (void)setOldProjectName:(id)argument;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	return metaGETTER;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setBaseProjectName:
- (void)setBaseProjectName:(NSString *)argument;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (08/29/2001):
- 1.3:03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	metaSETTER(argument);
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  documentIsMaster
- (BOOL)documentIsMaster;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (08/29/2001):
- 1.3:03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	return [metaGETTER boolValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setDocumentIsMaster:
- (void)setDocumentIsMaster:(BOOL)yorn;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (08/29/2001):
- 1.3:03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	metaSETTER([NSNumber numberWithBool:yorn]);
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  exportOutput
- (BOOL)exportOutput;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (08/29/2001):
- 1.3:03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	return [metaGETTER boolValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setExportOutput:
- (void)setExportOutput:(BOOL)yorn;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (08/29/2001):
- 1.3:03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	metaSETTER([NSNumber numberWithBool:yorn]);
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  preferWrapper
- (BOOL)preferWrapper;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (08/29/2001):
- 1.3:03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	return [metaGETTER boolValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setPreferWrapper:
- (void)setPreferWrapper:(BOOL)yorn;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (08/29/2001):
- 1.3:03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	metaSETTER([NSNumber numberWithBool:yorn]);
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateCreationMode
- (void)validateCreationMode;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Nov  8 09:18:47 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	int creationMode = [self creationMode];
	if(creationMode == iTM2ToggleOldProjectMode)
	{
old:
		if([self canInsertInOldProject])
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
		if([self canCreateNewProject])
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
		if(![self canBeStandalone])
		{
			[self setCreationMode:iTM2ToggleForbiddenProjectMode];
		}
		return;
	}
	creationMode = iTM2ToggleOldProjectMode;
	[self setCreationMode:creationMode];
	goto old;
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  canInsertInOldProject
- (BOOL)canInsertInOldProject;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Nov  8 09:18:47 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSDictionary * availableProjects = [self availableProjects];
	int count = [availableProjects count];
	// this peculiar situation occurs when I insert in a wrapper that has no project inside
	if(count == 1)
	{
		NSString * path = [[availableProjects allKeys] lastObject];
		if([SWS isWrapperPackageAtPath:path])
		{
			NSArray * enclosed = [path enclosedProjectFileNames];
			return [enclosed count] > 0;
		}
	}
//iTM2_END;
    return count > 0;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  canCreateNewProject
- (BOOL)canCreateNewProject;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Nov  8 09:18:47 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * fileName = [self fileName];
	NSString * dir = [fileName stringByDeletingLastPathComponent];
	if(![DFM isWritableFileAtPath:dir])
	{
		return NO;
	}
	NSString * enclosing = [fileName enclosingProjectFileName];
	if([enclosing length])
	{
		return NO;
	}
	enclosing = [fileName enclosingWrapperFileName];
	if([enclosing length])
	{
		NSArray * enclosed = [enclosing enclosedProjectFileNames];
		if([enclosed count])
		{
			return NO;
		}
	}
//iTM2_END;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  canBeStandalone
- (BOOL)canBeStandalone;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Nov  8 09:18:47 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * fileName = [self fileName];
	NSString * enclosing = [fileName enclosingProjectFileName];
	if([enclosing length])
	{
		return NO;
	}
	enclosing = [fileName enclosingWrapperFileName];
	if([enclosing length])
	{
		return NO;
	}
	return YES;
//iTM2_END;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  creationMode
- (int)creationMode;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Nov  8 09:18:47 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return [metaGETTER intValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setCreationMode:
- (void)setCreationMode:(int)tag;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Nov  8 09:18:47 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	metaSETTER([NSNumber numberWithInt:tag]);
	[SUD setInteger:tag forKey:iTM2NewProjectCreationModeKey];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  availableProjects
- (id)availableProjects;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Nov  8 09:18:47 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return metaGETTER;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setAvailableProjects:
- (void)setAvailableProjects:(id) argument;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Nov  8 09:18:47 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	metaSETTER(argument);
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  belongsToAWrapper
- (BOOL)belongsToAWrapper;
/*"Description forthcoming. Required method. This is where we return the name for new projects
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSAssert([[self fileName] length],@"You must sepcify a file name before");
//iTM2_END;
    return [[[self fileName] enclosingWrapperFileName] length]>0;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= projectName
- (NSString *)projectName;
/*"Description forthcoming. Required method. This is where we return the name for new projects
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([self creationMode] == iTM2ToggleNewProjectMode)
	{
		NSString * result = [self fileName];
		result = [result stringByDeletingLastPathComponent];
		NSString * newProjectName = [self newProjectName];
		result = [result stringByAppendingPathComponent:newProjectName];
		if([self preferWrapper])
		{
			result = [result stringByAppendingPathExtension:[SDC wrapperPathExtension]];
			result = [result stringByAppendingPathComponent:newProjectName];
		}
		result = [result stringByAppendingPathExtension:[SDC projectPathExtension]];
        return result;
	}
//iTM2_END;
    return [self oldProjectName];
}
#pragma mark =-=-=-=-=-  WINDOW MNGT
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  windowWillLoad
- (void)windowWillLoad;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	//Preparing the projects for the table view
	NSAssert([[self fileName] length],@"You must specify a file name...");
	[super windowWillLoad];
	[self setBaseProjectName:[SUD stringForKey:iTM2TeXProjectDefaultBaseNameKey]];
	[self setDocumentIsMaster:[SUD boolForKey:iTM2TeXProjectDocumentIsMasterFileKey]];
	[self setPreferWrapper:[SUD boolForKey:iTM2NewDocumentEnclosedInWrapperKey]];
	NSString * fileName = [self fileName];
	NSDictionary * availableProjects = [SPC availableProjectsForPath:fileName];
	[self setAvailableProjects:availableProjects];
	int creationMode = [SUD integerForKey:iTM2NewProjectCreationModeKey];
	[self setCreationMode:creationMode];
	[self validateCreationMode];
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  windowDidLoad
- (void)windowDidLoad;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	//Preparing the projects for the table view
	[super windowDidLoad];
    [self iTM2_validateWindowContent];
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2_validateWindowContent
- (BOOL)iTM2_validateWindowContent;
/*"Before calling the inherited method, update the list of available projects.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [IMPLEMENTATION takeMetaValue:[SPC TeXBaseProjectsProperties] forKey:@"_TPPs"];// TeX Projects Properties
	[self validateCreationMode];
//iTM2_LOG(@"MD:%@", MD);
    return [super iTM2_validateWindowContent];
}
#pragma mark =-=-=-=-=-  UI
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  OK:
- (IBAction)OK:(id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	// testing for some consistency if we have to create folders at least:
	[SUD setObject:[self baseProjectName] forKey:iTM2TeXProjectDefaultBaseNameKey];
	if(![self belongsToAWrapper])
	{
		[SUD setBool:[self documentIsMaster] forKey:iTM2TeXProjectDocumentIsMasterFileKey];
		[SUD setBool:[self preferWrapper] forKey:iTM2NewDocumentEnclosedInWrapperKey];
		[SUD setObject:[self oldProjectName] forKey:@"iTM2NewProjectLastChoice"];
	}
	[NSApp stopModalWithCode:[self creationMode]];
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  fileNameEdited:
- (IBAction)fileNameEdited:(id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateFileNameEdited:
- (BOOL)validateFileNameEdited:(id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * fileName = [self fileName];
	[sender setStringValue:([fileName length]? [fileName lastPathComponent]:@"None")];
//iTM2_END;
	return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  newProjectNameEdited:
- (IBAction)newProjectNameEdited:(id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * senderString = [[sender stringValue] stringByDeletingPathExtension];
	if([senderString length])
	{
		[self setNewProjectName:senderString];
	}
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateNewProjectNameEdited:
- (BOOL)validateNewProjectNameEdited:(id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * newProjectName = [self newProjectName];
	if([self belongsToAWrapper])
	{
		[sender setStringValue:newProjectName];
		return NO;
	}
	if(![newProjectName length])
	{
		newProjectName = [self fileName];
		newProjectName = [newProjectName lastPathComponent];
		newProjectName = [newProjectName stringByDeletingPathExtension];
		if([newProjectName length])
		{
			[self setNewProjectName:newProjectName];
		}
		else
		{
			iTM2_LOG(@"Weird? void _FileName");
		}
	}
	[sender setStringValue:newProjectName];
	if([self creationMode] == iTM2ToggleNewProjectMode)
	{
		if(![[[sender window] firstResponder] isEqual:sender])
		{
			[[sender window] makeFirstResponder:sender];
			[sender selectText:self];
		}
        return YES;
	}
	else
	{
		return NO;
	}
//iTM2_END;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleDocumentIsMaster:
- (IBAction)toggleDocumentIsMaster:(id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	BOOL old = [self documentIsMaster];
	[self setDocumentIsMaster:!old];
	[sender iTM2_validateWindowContent];
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleDocumentIsMaster:
- (BOOL)validateToggleDocumentIsMaster:(id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[sender setState:([self documentIsMaster]? NSOnState:NSOffState)];
//iTM2_END;
	return [self creationMode] == iTM2ToggleNewProjectMode;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeProjectFromSelectedItem:
- (IBAction)takeProjectFromSelectedItem:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Nov  8 09:18:47 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self setOldProjectName:[[sender selectedItem] representedObject]];
	[self iTM2_validateWindowContent];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateTakeProjectFromSelectedItem:
- (BOOL)validateTakeProjectFromSelectedItem:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Nov  8 09:18:47 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * oldProjectName = [self oldProjectName];
	NSDictionary * availableProjects = [self availableProjects];
	if([sender isKindOfClass:[NSPopUpButton class]])
	{
		[sender removeAllItems];
		NSString * path;
		NSEnumerator * E = [availableProjects keyEnumerator];
		while(path = [E nextObject])
		{
			NSString * displayName = [availableProjects objectForKey:path];
			[sender addItemWithTitle:displayName];
			[[sender lastItem] setRepresentedObject:path];
		}
		if([sender numberOfItems]>0)
		{
			int index = 0;
			if(![oldProjectName length])
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
			return ([sender numberOfItems]>1) && ([self creationMode] == iTM2ToggleOldProjectMode);
		}
		return NO;
	}
	else if([sender isKindOfClass:[NSMenuItem class]])
	{
		return [availableProjects count]>1;
	}
//iTM2_END;
    return [oldProjectName length]>0;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleWrapper:
- (IBAction)toggleWrapper:(id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	BOOL old = [self preferWrapper];
	[self setPreferWrapper:!old];
	[sender iTM2_validateWindowContent];
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleWrapper:
- (BOOL)validateToggleWrapper:(id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([self belongsToAWrapper])
	{
		[sender setState:YES];
		return NO;
	}
	[sender setState:([self preferWrapper]?NSOnState:NSOffState)];
	return [self creationMode] == iTM2ToggleNewProjectMode;
//iTM2_END;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeCreationModeFromTag:
- (IBAction)takeCreationModeFromTag:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Nov  8 09:18:47 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	// Hum, the sender is the matrix despite each cell is connected separately in interface builder
	[self setCreationMode:[[sender selectedCell] tag]];
	[self iTM2_validateWindowContent];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateTakeCreationModeFromTag:
- (BOOL)validateTakeCreationModeFromTag:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue Nov  8 09:18:47 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	int creationMode = [self creationMode];
	if(creationMode == iTM2ToggleForbiddenProjectMode)
	{
		[sender setState:NSOffState];
		return NO;
	}
	[sender setState: ([sender tag] == creationMode? NSOnState:NSOffState)];
	BOOL result = NO;
	switch([sender tag])
	{
		case iTM2ToggleStandaloneMode:
			result = [self canBeStandalone];
			break;
		case iTM2ToggleOldProjectMode:
			result = [self canInsertInOldProject];
			break;
		case iTM2ToggleNewProjectMode:
			result = [self canCreateNewProject];
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSString * mode = [(id)[sender selectedItem] representedString];
	NSString * baseProjectName = [self baseProjectName];
    if([mode isEqualToString:[[[baseProjectName TeXProjectProperties] iVarMode] lowercaseString]])
        return;
    NSDictionary * TPPs = [IMPLEMENTATION metaValueForKey:@"_TPPs"];// TeX Projects Properties...
    NSEnumerator * E = [TPPs keyEnumerator];
    NSDictionary * keyD;
    NSString * newBPN = @"";
    NSString * shortestName = @"";
    NSString * pdf = [iTM2TPFEPDFOutput lowercaseString];
    while(keyD = [E nextObject])
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
    while(keyD = [E nextObject])
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
            if([N length] < [shortestName length])
			{
                shortestName = N;
			}
        }
	}
    newBPN = shortestName;
tahaa:
    [self setBaseProjectName:newBPN];
    [sender iTM2_validateWindowContent];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateChooseBaseMode:
- (BOOL)validateChooseBaseMode:(id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Mar 26 08:41:36 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_LOG(@"sender is:%@", sender);
    if([sender isKindOfClass:[NSPopUpButton class]])
    {
		static NSString * noModeTitle = nil;
		if(!noModeTitle)
			noModeTitle = [[[sender lastItem] title] copy];
        [sender removeAllItems];
        NSMutableDictionary * MD = [NSMutableDictionary dictionary];
        NSDictionary * TPPs = [IMPLEMENTATION metaValueForKey:@"_TPPs"];
        NSEnumerator * E = [TPPs keyEnumerator];
        NSDictionary * D;
        while(D = [E nextObject])
        {
            [MD takeValue:[[[TPPs objectForKey:D] valueForKey:iTM2TeXPCommandPropertiesKey] iVarMode]
                forKey:[D iVarMode]];
        }
            // the key is lowercase!!! the value need not
        E = [[[MD allKeys] sortedArrayUsingSelector:@selector(compare:)] objectEnumerator];
        NSString * k;
        while(k = [E nextObject])
        {
            [sender addItemWithTitle:[MD valueForKey:k]];
            [[sender lastItem] setRepresentedObject:k];// the lowercase string
        }
        NSDictionary * Ps = [[self baseProjectName] TeXProjectProperties];
        NSString * mode = [Ps iVarMode];
        int idx = [sender indexOfItemWithRepresentedObject:[mode lowercaseString]];
        if(idx == -1)
        {
            NSString * lastTitle = [NSString stringWithFormat:@"%@(Unknown)", mode];
            [[sender menu] addItem:[NSMenuItem separatorItem]];
            [sender addItemWithTitle:lastTitle];
            [sender selectItem:[sender lastItem]];        
            [[sender lastItem] setRepresentedObject:nil];// BEWARE!!!
        }
        else
        {
            [sender selectItemAtIndex:idx];
        }
		if([sender numberOfItems] < 2)
			return NO;
     }
    return [self creationMode] != iTM2ToggleOldProjectMode;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  chooseVariant:
- (IBAction)chooseVariant:(id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Mar 26 08:41:36 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSString * variant = [[(id)[sender selectedItem] representedString] lowercaseString];
//iTM2_LOG(@"variant chosen is:%@", variant);
    if([variant isEqualToString:iTM2ProjectDefaultsKey])
        variant = @"";
    NSDictionary * oldTPPs = [[self baseProjectName] TeXProjectProperties];
    if([variant isEqualToString:[[oldTPPs iVarVariant] lowercaseString]])
        return;
    NSString * mode = [[oldTPPs iVarMode] lowercaseString];
    NSDictionary * TPPs = [IMPLEMENTATION metaValueForKey:@"_TPPs"];
    NSEnumerator * E = [TPPs keyEnumerator];
    NSDictionary * keyD;
    NSString * newBPN = @"";
    NSString * shortestName = @"";
    NSString * pdf = [iTM2TPFEPDFOutput lowercaseString];
    while(keyD = [E nextObject])
    {
//iTM2_LOG(@"keyD is:%@", keyD]);
        if([[keyD iVarMode] isEqualToString:mode]
            && [[keyD iVarVariant] isEqualToString:variant])
        {
            newBPN = [[TPPs objectForKey:keyD] iVarName];
            if([[keyD iVarOutput] isEqualToString:pdf])
                goto tahaa;
            shortestName = newBPN;
            break;
        }
//iTM2_LOG(@"shortestName is:%@ (%@) ----1", shortestName, [[TPPs objectForKey:keyD] iVarName]);
    }
    while(keyD = [E nextObject])
    {
//iTM2_LOG(@"keyD is:%@", keyD]);
        if([[keyD iVarMode] isEqualToString:mode]
            && [[keyD iVarVariant] isEqualToString:variant])
        {
            newBPN = [[TPPs objectForKey:keyD] iVarName];
            if([[keyD iVarOutput] isEqualToString:pdf])
                goto tahaa;
            else if([newBPN length] < [shortestName length])
                shortestName = newBPN;
        }
//iTM2_LOG(@"shortestName is:%@ (%@)", shortestName, [[TPPs objectForKey:keyD] iVarName]);
    }
    newBPN = shortestName;
tahaa:
    [self setBaseProjectName:newBPN];
    [sender iTM2_validateWindowContent];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateChooseVariant:
- (BOOL)validateChooseVariant:(id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Mar 26 08:41:36 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_LOG(@"sender is:%@", sender);
    if([sender isKindOfClass:[NSPopUpButton class]])
    {
		static NSString * noModeTitle = nil;
		if(!noModeTitle)
			noModeTitle = [[[sender lastItem] title] copy];
        [sender removeAllItems];
//iTM2_LOG(@"baseProjectName is:%@", [self baseProjectName]);
        NSDictionary * Ps = [[self baseProjectName] TeXProjectProperties];
        NSString * baseMode = [[Ps iVarMode] lowercaseString];
//iTM2_LOG(@"baseMode is:%@", baseMode);
        NSMutableDictionary * MD = [NSMutableDictionary dictionary];
        NSDictionary * TPPs = [IMPLEMENTATION metaValueForKey:@"_TPPs"];
        NSEnumerator * E = [TPPs keyEnumerator];
        NSDictionary * keyD;
        while(keyD = [E nextObject])
            if([[[keyD iVarMode] lowercaseString] isEqualToString:baseMode])
            {
//iTM2_LOG(@"GOOD keyD is:%@", keyD);
                NSString * variant = [keyD iVarVariant];
                if([variant length])
                    [MD takeValue:[[[TPPs objectForKey:keyD] valueForKey:iTM2TeXPCommandPropertiesKey] iVarVariant]
                        forKey:variant];
                else
#warning DEBUGGGGG LOCALIZATION???
                    [MD takeValue:@"None" forKey:iTM2ProjectDefaultsKey];
            }
            else
            {
//iTM2_LOG(@"BAD  keyD is:%@", keyD);
            }
        E = [[[MD allKeys] sortedArrayUsingSelector:@selector(compare:)] objectEnumerator];
        NSString * k;
        while(k = [E nextObject])
        {
            [sender addItemWithTitle:[MD valueForKey:k]];
            [[sender lastItem] setRepresentedObject:k];// the lowercase string
        }
        NSString * variant = [Ps iVarVariant];
//iTM2_LOG(@"variant for validation is %@", variant);
        int idx = [sender indexOfItemWithRepresentedObject:([variant length]? [variant lowercaseString]:iTM2ProjectDefaultsKey)];
        if(idx == -1)
        {
            NSString * lastTitle = [NSString stringWithFormat:@"%@(Unknown)", variant];
            [[sender menu] addItem:[NSMenuItem separatorItem]];
            [sender addItemWithTitle:lastTitle];
            [sender selectItem:[sender lastItem]];        
            [[sender lastItem] setRepresentedObject:nil];// BEWARE!!!
        }
        else
        {
            [sender selectItemAtIndex:idx];
        }
		if([sender numberOfItems] < 2)
			return NO;
    }
    return [self creationMode] != iTM2ToggleOldProjectMode;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  chooseOutput:
- (IBAction)chooseOutput:(id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Mar 26 08:41:36 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSString * output = [(id)[sender selectedItem] representedString];
    NSDictionary * Ps = [[self baseProjectName] TeXProjectProperties];
    NSString * mode = [[Ps iVarMode] lowercaseString];
    NSString * variant = [[Ps iVarVariant] lowercaseString];
    NSDictionary * TPPs = [IMPLEMENTATION metaValueForKey:@"_TPPs"];
    NSEnumerator * E = [TPPs keyEnumerator];
    NSDictionary * keyD;
    while(keyD = [E nextObject])
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
    [sender iTM2_validateWindowContent];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateChooseOutput:
- (BOOL)validateChooseOutput:(id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Mar 26 08:41:36 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_LOG(@"sender is:%@", sender);
    if([sender isKindOfClass:[NSPopUpButton class]])
    {
		static NSString * noModeTitle = nil;
		if(!noModeTitle)
			noModeTitle = [[[sender lastItem] title] copy];
        [sender removeAllItems];

//iTM2_LOG(@"baseProjectName is:%@", [self baseProjectName]);
        NSDictionary * Ps = [[self baseProjectName] TeXProjectProperties];
//iTM2_LOG(@"Ps is:%@", Ps);
        NSString * mode = [[Ps iVarMode] lowercaseString];
        NSString * variant = [[Ps iVarVariant] lowercaseString];
        NSMutableDictionary * MD = [NSMutableDictionary dictionary];
        NSDictionary * TPPs = [IMPLEMENTATION metaValueForKey:@"_TPPs"];
        NSEnumerator * E = [TPPs keyEnumerator];
        NSDictionary * D;
        while(D = [E nextObject])
            if([[D iVarMode] isEqualToString:mode] && [[D iVarVariant] isEqualToString:variant])
            {
                NSString * output = [D iVarOutput];
                if([output length])
                    [MD takeValue:[[[TPPs objectForKey:D] valueForKey:iTM2TeXPCommandPropertiesKey] iVarOutput]
                        forKey:output];
            }
		[sender addItemWithTitle:iTM2TPFEPDFOutput];
		[[sender lastItem] setRepresentedObject:[iTM2TPFEPDFOutput lowercaseString]];// the lowercase string
        E = [[[MD allKeys] sortedArrayUsingSelector:@selector(compare:)] objectEnumerator];
        NSString * k;
        while(k = [E nextObject])
        {
            [sender addItemWithTitle:[MD valueForKey:k]];
            [[sender lastItem] setRepresentedObject:k];// the lowercase string
        }
        NSString * output = [Ps iVarOutput];
        int idx = [sender indexOfItemWithRepresentedObject:[([output length]? output:iTM2TPFEPDFOutput) lowercaseString]];
        if(idx == -1)
        {
            NSString * lastTitle = [NSString stringWithFormat:@"%@(Unknown)", output];
            [[sender menu] addItem:[NSMenuItem separatorItem]];
            [sender addItemWithTitle:lastTitle];
            [sender selectItem:[sender lastItem]];        
            [[sender lastItem] setRepresentedObject:nil];// BEWARE!!!
        }
        else
        {
            [sender selectItemAtIndex:idx];
        }
		if([sender numberOfItems] < 2)
			return NO;
    }
    return [self creationMode] != iTM2ToggleOldProjectMode;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleExportOutput:
- (IBAction)toggleExportOutput:(id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	BOOL old = [self exportOutput];
	[self setExportOutput:!old];
	[sender iTM2_validateWindowContent];
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleExportOutput:
- (BOOL)validateToggleExportOutput:(id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[sender setState:([self exportOutput]? NSOnState:NSOffState)];
//iTM2_END;
	return [self creationMode] == iTM2ToggleStandaloneMode;
}
@end

@implementation iTM2TeXProjectInspector
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  windowNibName
+ (NSString *)windowNibName;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return NSStringFromClass(self);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  defaultShellEnvironment
+ (NSDictionary *)defaultShellEnvironment;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [NSDictionary dictionary];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  model
- (id)model;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [IMPLEMENTATION modelOfType:iTM2MainType];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeModel:
- (void)takeModel:(NSDictionary *) model;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [IMPLEMENTATION takeModel:(model? [NSMutableDictionary dictionaryWithDictionary:model]:[NSMutableDictionary dictionary]) ofType:iTM2MainType];
    [self iTM2_validateWindowContent];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  modelValueForKey:
- (id)modelValueForKey:(NSString *) key;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [IMPLEMENTATION modelValueForKey:key ofType:iTM2MainType];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeModelValue:forKey:
- (void)takeModelValue:(id) value forKey:(NSString *) key;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id old = [self modelValueForKey:key];
	if(iTM2DebugEnabled>100000)
	{
		iTM2_LOG(@"BEFORE - [self modelValueForKey:%@] is:%@ and should be:%@", key, old, value);
		if(!IMPLEMENTATION)
			NSLog(@"implementation missing");
	}
	if(![old isEqual:value])
	{
		[IMPLEMENTATION takeModelValue:value forKey:key ofType:iTM2MainType];
		[self iTM2_validateWindowContent];
	}
	if(iTM2DebugEnabled>100000)
	{
		iTM2_LOG(@"AFTER - [self modelValueForKey:%@] is:%@", key, [self modelValueForKey:key]);
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [[self defaultShellEnvironment] allKeys];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  shellEnvironment
- (NSDictionary *)shellEnvironment;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSMutableDictionary * MD = [NSMutableDictionary dictionary];
    NSEnumerator * E = [[[self class] allShellEnvironmentVariables] objectEnumerator];
    NSString * variable;
    while(variable = [E nextObject])
        [MD takeValue:[self modelValueForKey:variable] forKey:variable];
	if(iTM2DebugEnabled>100)
	{
		iTM2_LOG(@"shellEnvironment is:%@", MD);
	}
//iTM2_END;
    return MD;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeShellEnvironment:
- (void)takeShellEnvironment:(NSDictionary *) environment;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(iTM2DebugEnabled)
	{
		iTM2_LOG(@"environment is:%@", environment);
	}
    NSEnumerator * E = [[isa allShellEnvironmentVariables] objectEnumerator];
    NSString * variable;
    while(variable = [E nextObject])
	{
        [self takeModelValue:[environment valueForKey:variable] forKey:variable];
		if(iTM2DebugEnabled)
		{
			iTM2_LOG(@"environment variable name is:%@, contents:%@", variable, [self modelValueForKey:variable]);
		}
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initImplementation
- (void)initImplementation;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [super initImplementation];
    [self takeModel:nil];
	[self takeShellEnvironment:[[self class] defaultShellEnvironment]];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setDocument:
- (void)setDocument:(NSDocument *) document;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [super setDocument:document];
    [self iTM2_validateWindowContent];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  windowDidLoad
- (void)windowDidLoad;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [super windowDidLoad];
    [self iTM2_validateWindowContent];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleModelFlagForKey:
- (void)toggleModelFlagForKey:(NSString *) key;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    BOOL old = [[self modelValueForKey:key] boolValue];
    [self takeModelValue:[NSNumber numberWithBool:!old] forKey:key];
    [self iTM2_validateWindowContent];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  modelFlagForKey:
- (BOOL)modelFlagForKey:(NSString *) key;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSNumber * N = [self modelValueForKey:key];
	if([N respondsToSelector:@selector(boolValue)])
		return [N boolValue];
//iTM2_LOG(@"Unexpected model value:a number or so should be there");
    [self takeModelValue:[NSNumber numberWithBool:NO] forKey:key];
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  cancel:
- (IBAction)cancel:(id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [NSApp endSheet:[sender window] returnCode:NSAlertAlternateReturn];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  OK:
- (IBAction)OK:(id) sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [NSApp endSheet:[sender window] returnCode:NSAlertDefaultReturn];
//iTM2_END;
    return;
}
@end

@interface NSString(iTM2TeXProjectFrontendKit)
- (BOOL)iTM2_boolValue;
@end
@implementation NSString(iTM2TeXProjectFrontendKit)
- (BOOL)iTM2_boolValue;
{iTM2_DIAGNOSTIC;
	return [[self lowercaseString] isEqualToString:@"yes"];
}
@end

//#import <iTM2Foundation/iTM2MenuKit.h>

NSString * const iTM2TPFEBaseProjectNameKey = @"BaseProjectName";

@implementation iTM2TeXProjectDocument(BaseProject)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  baseProjectName
- (NSString *)baseProjectName;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [self infoForKeyPaths:iTM2TPFEBaseProjectNameKey,nil];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setBaseProjectName:
- (void)setBaseProjectName:(NSString *) baseProjectName;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self takeInfo:baseProjectName forKeyPaths:iTM2TPFEBaseProjectNameKey,nil];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  baseProject
- (id)baseProject;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * baseProjectName = [self baseProjectName];
	if(![baseProjectName length])
		return nil;
	id result = [SPC baseProjectWithName:baseProjectName];
    return result == self? nil:result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  baseProjectFixImplementation
- (void)baseProjectFixImplementation;
/*"Description forthcoming.
This message is sent at initialization time.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [SUD registerDefaults:
		[NSDictionary dictionaryWithObjectsAndKeys:@"LaTeX", iTM2TPFEBaseProjectNameKey, nil]];
	if(![self baseProjectName])
		[self setBaseProjectName:[SUD objectForKey:iTM2TPFEBaseProjectNameKey]];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  description
- (NSString *)description;
/*"Projects are no close documents!!!
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [NSString stringWithFormat:@"<%@, fileName:%@, baseProjectName:%@>",
		[super description], [self fileName], [self baseProjectName]];
}
@end


#if 0
//iTM2_START;
    NSMutableDictionary * BPs = [NSMutableDictionary dictionary];
    NSMutableDictionary * TPs = [NSMutableDictionary dictionary];
    NSBundle * B = [NSBundle mainBundle];
    Class TeXPDocumentClass = [SDC documentClassForType:[SDC projectDocumentType]];
    NSString * P = [B pathForResource:iTM2TeXPBaseProjectsComponent ofType:nil];
//iTM2_LOG(@"Reading base projects at path:%@", P);
    NSEnumerator * E = [[DFM directoryContentsAtPath:P] objectEnumerator];
    NSString * p;
    while(p = [E nextObject])
    {
        if([[p pathExtension] isEqualToString:[SDC projectPathExtension]])
        {
            NSString * k = [[p stringByDeletingPathExtension] lowercaseString];
            id v = [[[TeXPDocumentClass alloc]
                initWithContentsOfFile:[P stringByAppendingPathComponent:p]
                    ofType:iTM2TeXProjectDocumentType] autorelease];
            [BPs takeValue:v forKey:k];
            [TPs takeValue:v forKey:k];
        }
    }
    E = [[B pathsForSupportInDomain:NSAllDomainsMask] objectEnumerator];
    while(P = [[E nextObject] stringByAppendingPathComponent:iTM2TeXPBaseProjectsComponent])
    {
//iTM2_LOG(@"Reading projects at path:%@", P);
        NSEnumerator * e = [[DFM directoryContentsAtPath:P] objectEnumerator];
        NSString * p;
        while(p = [e nextObject])
        {
            if([[p pathExtension] isEqualToString:[SDC projectPathExtension]])
            {
                NSString * k = [[p stringByDeletingPathExtension] lowercaseString];
                id v = [[[TeXPDocumentClass alloc]
                    initWithContentsOfFile:[P stringByAppendingPathComponent:p]
                        ofType:iTM2TeXProjectDocumentType] autorelease];
                [BPs takeValue:v forKey:k];// already existing base projects must be overriden
                [TPs takeValue:v forKey:k];
            }
        }
    }
    [IMPLEMENTATION takeMetaValue:BPs forKey:iTM2TeXPBaseProjectsKey];
    [IMPLEMENTATION takeMetaValue:TPs forKey:iTM2TeXProjectsKey];
//iTM2_LOG(@"[self TeXProjects] ARE:%@", [self TeXProjects]);
//iTM2_LOG(@"TPs:%@", TPs);
    return;
#endif

#if 1
@implementation NSMenu(TESTING_PRIVATE_FRONTEND)
- (void)recursiveEnableCheck;
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_LOG(@"[self title] is:%@", [self title]);
//iTM2_LOG(@"[self numberOfItems] is:%i", [self numberOfItems]);
    int i;
    for(i=0;i<[self numberOfItems];++i)
    {
        iTM2_LOG(@"[self itemAtIndex:%i] is:%@", i, [self itemAtIndex:i]);
    }
//iTM2_END;
    return;
}
@end
#endif

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2ProjectFrontendKit

@implementation NSObject(iTM2FrontendKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2PD__compareUsingTitle:
- (int)iTM2PD__compareUsingTitle:(NSMenuItem *) MI;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    // assuming that they have windows as targets
    return [MI respondsToSelector:@selector(title)]? NSOrderedAscending:NSOrderedSame;
}
@end
@implementation NSMenuItem(iTM2FontendKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2PD__compareUsingTitle:
- (int)iTM2PD__compareUsingTitle:(NSMenuItem *) MI;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    // assuming that they have windows as targets
    return [MI respondsToSelector:@selector(title)]? [[self title] compare:[MI title]]:NSOrderedDescending;
}
@end

@implementation iTM2ProjectController(iTM2TeXProjectFrontendKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  load
+ (void)load;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
	iTM2_INIT_POOL;
	iTM2RedirectNSLogOutput();
//iTM2_START;
	if(![iTM2RuntimeBrowser swizzleInstanceMethodSelector:@selector(newProjectPanelControllerClass) replacement:@selector(swizzled_newProjectPanelControllerClass) forClass:[iTM2ProjectController class]])
	{
		iTM2_LOG(@"WARNING: No swizzled newProjectPanelControllerClass...");
	}
//iTM2_END;
	iTM2_RELEASE_POOL;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  swizzled_newProjectPanelControllerClass
- (Class)swizzled_newProjectPanelControllerClass;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return [iTM2NewTeXProjectController class];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  newProjectPanelControllerClass
- (Class)newProjectPanelControllerClass;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return [iTM2NewTeXProjectController class];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  requiredTeXProjectForSource:
- (id)requiredTeXProjectForSource:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id result = [self TeXProjectForSource:sender];
	if(result)
	{
		return result;
	}
	if(result = [self projectForSource:sender])
	{
		return nil;
	}
	if([sender isKindOfClass:[NSDocument class]])
	{
		[sender setHasProject:YES];
		if(result = [sender project])
		{
			return result;
		}
	}
	else if(!sender)
	{
		if(sender = [SDC currentDocument])
		{
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id result = [self currentProject];
    return [result isKindOfClass:[iTM2TeXProjectDocument class]]? result:nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  TeXBaseProjectsProperties
- (NSDictionary *)TeXBaseProjectsProperties;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSMutableDictionary * MD = [NSMutableDictionary dictionary];
    NSEnumerator * E = [[self baseProjectNames] objectEnumerator];
    NSString * name;
    while(name = [E nextObject])
    {//projectName
//iTM2_LOG(@"project name:%@", name);
        NSDictionary * D = [name TeXProjectProperties];
		D = [NSDictionary dictionaryWithObjectsAndKeys:
			D, iTM2TeXPCommandPropertiesKey,
			name, iTM2TPFENameKey,
				nil];
		NSDictionary * key = [NSDictionary dictionaryWithObjectsAndKeys:
			[[D iVarMode] lowercaseString], iTM2TPFEModeKey,
			[[D iVarVariant] lowercaseString], iTM2TPFEVariantKey,
			[[D iVarOutput] lowercaseString], iTM2TPFEOutputKey,
				nil];
        [MD setValue:D forKey:(id)key];
    }
//iTM2_START;
	return MD;
}
@end

#if 0
@implementation NSDocument(iTM2TeXProject)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  load
+ (void)load;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
	iTM2_INIT_POOL;
	iTM2RedirectNSLogOutput();
//iTM2_START;
	if(![iTM2RuntimeBrowser swizzleInstanceMethodSelector:@selector(project) replacement:@selector(swizzled_project) forClass:[NSDocument class]])
	{
		iTM2_LOG(@"WARNING: No hook available for project...");
	}
//iTM2_END;
	iTM2_RELEASE_POOL;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  swizzled_project
- (id)swizzled_project;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Mar 30 15:52:06 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id result = [self swizzled_project];
#else
@implementation iTM2Document(iTM2TeXProject)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  project
- (id)project;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Wed Mar 30 15:52:06 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id result = [super project];
#endif
	if(result)
		return result;
	NSURL * url = [self fileURL];
	if([self hasProject] && !url)
	{
		[self saveDocument:self];
		url = [self fileURL];
		if(!url)
		{
			[self setHasProject:NO];
			return nil;
		}
	}
	if([self hasProject])
	{
		if(result = [SPC newProjectForURLRef:&url display:NO error:nil])
		{
			if(![[url path] pathIsEqual:[[self fileURL] path]])
				[self setFileURL:url];// weird code, this is possobly due to a cocoa weird behaviour
		}
		else
		{
			[self setHasProject:NO];
		}
	}
    return result;
}
@end
#if 0
}
@end
#endif

#warning DEBUG:THIS MUST BE IMPLEMENTED 
#if 0
@implementation iTM2PDFDocument(TeXProjectFrontendKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  enableProjectSupporFixImplementation
- (void)enableProjectSupporFixImplementation;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1:03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [[[self album] centeredSubview] updateFocusInformation];
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [[SPC projectForSource:sender] showTerminal:sender];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateProjectShowTerminal:
- (BOOL)validateProjectShowTerminal:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(![sender image])
	{
		NSString * name = @"projectShowTerminal(small)";
		NSImage * I = [NSImage iTM2_cachedImageNamed:name];
		if(![I iTM2_isNotNullImage])
		{
			I = [[NSImage iTM2_cachedImageNamed:@"showCurrentProjectTerminal"] copy];
			[I setName:name];
			[I iTM2_setSizeSmallIcon];
		}
		[sender setImage:I];//size
	}
//iTM2_END;
    return [SPC currentProject] != nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  showCurrentProjectSettings:
- (IBAction)showCurrentProjectSettings:(id) sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue May  3 16:20:26 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[[SPC projectForSource:nil] showSettings:sender];
//iTM2_END;
	return;
}  
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  showCurrentProjectFiles:
- (IBAction)showCurrentProjectFiles:(id) sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue May  3 16:20:26 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[[SPC projectForSource:nil] showFiles:sender];
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  showCurrentProjectFilesWillPopUp:
- (BOOL)showCurrentProjectFilesWillPopUp:(id) sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue May  3 16:20:26 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id PD = [SPC projectForSource:nil];
	NSEnumerator * E = [[PD allKeys] objectEnumerator];
	NSMutableDictionary * MD = [NSMutableDictionary dictionary];
	NSString * S;
	while(S = [E nextObject])
	{
		NSString * FN = [PD nameForFileKey:S];
		if([FN length])
			[MD setObject:S forKey:FN];
	}
	NSArray * sortedKeys = [[MD allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
	if(![NSApp targetForAction:@selector(projectEditDocumentUsingRepresentedObject:)])
	{
		iTM2_LOG(@"..........  ERROR:the project responder is not yet installed!");
	}
	NSMenu * M = [[[NSMenu allocWithZone:[NSMenu menuZone]] initWithTitle:@""] autorelease];
	[M addItemWithTitle:@"" action:NULL keyEquivalent:@""];// first item is used a s title
	// populating the menu with project documents
	if([sortedKeys count])
	{
		E = [sortedKeys objectEnumerator];
		while(S = [E nextObject])
		{
			NSMenuItem * MI = [[[NSMenuItem allocWithZone:[NSMenu menuZone]] initWithTitle:S
							action:@selector(projectEditDocumentUsingRepresentedObject1:) keyEquivalent:@""] autorelease];
			[M addItem:MI];
			[MI setTarget:nil];
			NSString * key = [MD objectForKey:S];
			NSURL * url = [PD URLForFileKey:key];
			NSImage * I = [SWS iconForFile:[url path]];
			[I iTM2_setSizeSmallIcon];
			[MI setImage:I];
			[MI setRepresentedObject:
				[NSDictionary dictionaryWithObjectsAndKeys:
					[NSValue valueWithNonretainedObject:PD], @"project",
					key, @"key",
						nil]];
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[[SPC projectForSource:nil] showTerminal:sender];
//iTM2_END;
	return;
}  
@end

#define DEFINE_TOOLBAR_ITEM(SELECTOR)\
+ (NSToolbarItem *)SELECTOR;{return [self toolbarItemWithIdentifier:[self identifierFromSelector:_cmd] inBundle:[iTM2TeXProjectInspector classBundle]];}

#import <iTM2TeXFoundation/iTM2TeXPCommandWrapperKit.h>

@implementation NSToolbarItem(iTM2TeXProject)
DEFINE_TOOLBAR_ITEM(showCurrentProjectSettingsToolbarItem)
DEFINE_TOOLBAR_ITEM(showCurrentProjectTerminalToolbarItem)
+ (NSToolbarItem *)showCurrentProjectFilesToolbarItem;
{
	NSToolbarItem * toolbarItem = [self toolbarItemWithIdentifier:[self identifierFromSelector:_cmd] inBundle:[iTM2TeXProjectInspector classBundle]];
	NSRect frame = NSMakeRect(0, 0, 32, 32);
	iTM2MixedButton * B = [[[iTM2MixedButton alloc] initWithFrame:frame] autorelease];
	[B setButtonType:NSMomentaryChangeButton];
//	[B setButtonType:NSOnOffButton];
	[B setImage:[toolbarItem image]];
	[B setImagePosition:NSImageOnly];
	[B setAction:@selector(showCurrentProjectFiles:)];
	[B setBezelStyle:NSShadowlessSquareBezelStyle];
//	[[B cell] setHighlightsBy:NSMomentaryChangeButton];
	[B setBordered:NO];
	[toolbarItem setView:B];
	[toolbarItem setMaxSize:frame.size];
	[toolbarItem setMinSize:frame.size];
	[B setTarget:nil];
	[[B cell] setBackgroundColor:[NSColor clearColor]];
	NSMenu * M = [[[NSMenu allocWithZone:[NSMenu menuZone]] initWithTitle:@""] autorelease];
	NSPopUpButton * PB = [[[NSPopUpButton allocWithZone:[self zone]] initWithFrame:NSZeroRect] autorelease];
	[PB setMenu:M];
	[PB setPullsDown:YES];
	[[B cell] setPopUpCell:[PB cell]];
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
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
	iTM2_LOG(@"*** BIG UNEXPECTED PROBLEM");
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= validateProjectEditDocumentUsingRepresentedObject1:
- (BOOL)validateProjectEditDocumentUsingRepresentedObject1:(id) sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (10/04/2001)
- 2.0: Fri Apr 16 11:39:43 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
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
	iTM2_LOG(@"*** BIG UNEXPECTED PROBLEM");
	return NO;
}
@end