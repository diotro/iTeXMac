/*
//
//  @version Subversion: $Id$ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Tue Sep 11 2001.
//  Copyright © 2001-2004 Laurens'Tribune. All rights reserved.
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

#import <iTM2TeXFoundation/iTM2TeXInfoWrapperKit.h>
#import <iTM2TeXFoundation/iTM2TeXProjectDocumentKit.h>
#import <iTM2TeXFoundation/iTM2TeXProjectTaskKit.h>
#import <iTM2TeXFoundation/iTM2TeXStorageKit.h>
#import <iTM2Foundation/iTM2BundleKit.h>
#import <iTM2Foundation/iTM2ImageKit.h>

NSString * const iTM2TeXProjectTaskTable = @"Task";

NSString * const iTM2TeXPTaskControllerKey = @"TaskController";
NSString * const iTM2TaskTerminalIsHiddenKey = @"TaskTerminalIsHidden";

NSString * const iTM2TeXPTaskInspectorSplitViewFactorsKey = @"iTM2TeXPTaskInspectorSplitViewFactors";

NSString * const iTM2UDLogDrawsTextBackgroundKey = @"iTM2UDLogDrawsTextBackground";

NSString * const iTM2UDLogTextBackgroundColorKey = @"iTM2UDLogTextBackgroundColor";
NSString * const iTM2UDLogSelectedTextBackgroundColorKey = @"iTM2UDLogSelectedTextBackgroundColor";
NSString * const iTM2UDLogSelectedTextColorKey = @"iTM2UDLogSelectedTextColor";
NSString * const iTM2UDLogInsertionPointColorKey = @"iTM2UDLogInsertionPointColor";

NSString * const iTM2UDLogStandardFontKey = @"iTM2UDLogStandardFont";

NSString * const iTM2LogFilesStackAttributeName = @"iTM2: files";
NSString * const iTM2LogPageNumberAttributeName = @"iTM2: page";
NSString * const iTM2LogLineTypeAttributeName = @"iTM2: type";
NSString * const iTM2LogLinkLineAttributeName = @"iTM2: link line";
NSString * const iTM2LogLinkColumnAttributeName = @"iTM2: link column";
NSString * const iTM2LogLinkLengthAttributeName = @"iTM2: link length";
NSString * const iTM2LogLinkPageAttributeName = @"iTM2: link page";
NSString * const iTM2LogLinkFileAttributeName = @"iTM2: link file";

@interface iTM2TeXProjectDocument(PRIVATE2)
- (iTM2TaskController *)_taskController;
@end

@implementation iTM2TeXProjectDocument(_iTM2TeXProjectTaskKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= taskController
- (iTM2TaskController *)taskController;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/11/01)
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    id TC = metaGETTER;
    if(!TC)
    {
        TC = [[iTM2TaskController alloc] init];
        metaSETTER(TC);
        for (iTM2TeXPTaskInspector * TI in self.windowControllers)
            if([TI isKindOfClass:[iTM2TeXPTaskInspector class]])
                [TC addInspector:TI];
#if 0
        if(![self.allInspectors lastObject])
        {
            TI = [[[iTM2TeXPTaskInspector alloc] initWithWindowNibName:@"iTM2TeXPTaskInspector"] autorelease];
            [self addWindowController:TI];// the receiver is the owner!!
            [TI setTaskController:TC];
            [TC addInspector:TI];
        }
#endif
    }
    return TC;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= _taskController
- (iTM2TaskController *)_taskController;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/11/01)
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
	id R = metaGETTER;
//LOG4iTM3(@"R: %@", R);
    return R;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= didAddWindowController:
- (void)didAddWindowController:(id)WC;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[super didAddWindowController:WC];
	if([WC isKindOfClass:[iTM2TeXPTaskInspector class]])
		[self._taskController addInspector:WC];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= willRemoveWindowController:
- (void)willRemoveWindowController:(id)WC;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if([WC isKindOfClass:[iTM2TeXPTaskInspector class]])
		[self._taskController removeInspector:WC];
	[super willRemoveWindowController:WC];
    return;
}
@end

@interface iTM2TeXPTaskInspector(PRIVATE)
- (void)fontOrColorDidChangeNotified:(NSNotification *)aNotification;
@end
NSString * const iTM2TeXProjectTerminalInspectorMode = @"Terminal Mode";
@implementation iTM2TeXPTaskInspector
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initialize
+ (void)initialize;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Apr 16 11:39:43 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[super initialize];
    [SUD registerDefaults: [NSDictionary dictionaryWithObjectsAndKeys:
        @"LaTeX", iTM2TPFELogParserKey,
        @"0:1.0:0.0", iTM2TeXPTaskInspectorSplitViewFactorsKey,
            nil]];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initImplementation:
- (void)initImplementation;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/11/01)
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [super initImplementation];
    [self cleanLog:self];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  smallImageLogo
+ (NSImage *)smallImageLogo;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSString * name = @"showCurrentProjectTerminal(small)";
	NSImage * I = [NSImage cachedImageNamed4iTM3:name];
	if([I isNotNullImage4iTM3])
	{
		return I;
	}
	I = [[NSImage cachedImageNamed4iTM3:@"showCurrentProjectTerminal"] copy];
	[I setSizeSmallIcon4iTM3];
	[I setName:name];
    return I;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inspectorType4iTM3
+ (NSString *)inspectorType4iTM3;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return iTM2TeXProjectInspectorType;
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
    return iTM2TeXProjectTerminalInspectorMode;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  windowDidLoad
- (void)windowDidLoad;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/11/01)
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self fontOrColorDidChangeNotified:nil];
    // Adjusting the size of the split view
    NSEnumerator * E = [[[self contextStringForKey:iTM2TeXPTaskInspectorSplitViewFactorsKey domain:iTM2ContextAllDomainsMask]
                                componentsSeparatedByString: @":"] objectEnumerator];
    float f = [E.nextObject floatValue];
    float f1 = f<0.05? 0: (f>0.95? 1: f);
    f = [E.nextObject floatValue];
    float f2 = f<0.05? 0: (f>0.95? 1: f);
    f = [E.nextObject floatValue];
    float f3 = f<0.05? 0: (f>0.95? 1: f);
//LOG4iTM3(@"f1: %f, f2: %f, f3: %f", f1, f2, f3);
    NSView * V1 = self.smartView.enclosingScrollView;
    NSView * V2 = self.outputView.enclosingScrollView;
    NSView * V3 = self.errorView.enclosingScrollView;
    NSView * V4 = self.customView.enclosingScrollView;
    NSSplitView * SV = (NSSplitView *)[V1 superview];
    if(V4)
    {
//LOG4iTM3(@"V1: %f, V2: %f, V3: %f, V4: %f", V1.frame.size.height, V2.frame.size.height, V3.frame.size.height, V4.frame.size.height);
        NSSize size1 = V1.frame.size;
        NSSize size2 = V2.frame.size;
        NSSize size3 = V3.frame.size;
        NSSize size4 = V4.frame.size;
        size1.height = f1;
        size2.height = (1-f1)*f2;
        size3.height = (1-f1)*(1-f2)*f3;
        size4.height = (1-f1)*(1-f2)*(1-f3);
        [V1 setFrameSize: size1];
        [V2 setFrameSize: size2];
        [V3 setFrameSize: size3];
        [V4 setFrameSize: size4];
//LOG4iTM3(@"V1: %f, V2: %f, V3: %f, V4: %f", V1.frame.size.height, V2.frame.size.height, V3.frame.size.height, V4.frame.size.height);
        [SV adjustSubviews];
//LOG4iTM3(@"V1: %f, V2: %f, V3: %f, V4: %f", V1.frame.size.height, V2.frame.size.height, V3.frame.size.height, V4.frame.size.height);
    }
    else if(V3)
    {
//LOG4iTM3(@"V1: %f, V2: %f, V3: %f", V1.frame.size.height, V2.frame.size.height, V3.frame.size.height);
        NSSize size1 = V1.frame.size;
        NSSize size2 = V2.frame.size;
        NSSize size3 = V3.frame.size;
        size1.height = f1;
        size2.height = (1-f1)*f2;
        size3.height = (1-f1)*(1-f2);
        [V1 setFrameSize: size1];
        [V2 setFrameSize: size2];
        [V3 setFrameSize: size3];
//LOG4iTM3(@"V1: %f, V2: %f, V3: %f", V1.frame.size.height, V2.frame.size.height, V3.frame.size.height);
        [SV adjustSubviews];
//LOG4iTM3(@"V1: %f, V2: %f, V3: %f", V1.frame.size.height, V2.frame.size.height, V3.frame.size.height);
    }
    else if(V2)
    {
//LOG4iTM3(@"V1: %f, V2: %f", V1.frame.size.height, V2.frame.size.height);
        NSSize size1 = V1.frame.size;
        NSSize size2 = V2.frame.size;
        size1.height = f1;
        size2.height = 1-f1;
        [V1 setFrameSize: size1];
        [V2 setFrameSize: size2];
//LOG4iTM3(@"V1: %f, V2: %f", V1.frame.size.height, V2.frame.size.height);
        [SV adjustSubviews];
//LOG4iTM3(@"V1: %f, V2: %f", V1.frame.size.height, V2.frame.size.height);
    }
    [SV setDelegate:self];
    // definitely forgetting the split view
    [super windowDidLoad];
//LOG4iTM3(@"self is:%@",self);// if I remove this line EXC_BAD_ACCESS 07/03/2007
    self.validateWindowContent4iTM3;
    [self.window setDelegate:self];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateWindowContent4iTM3
- (BOOL)validateWindowContent4iTM3;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/11/01)
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSView * V1 = self.smartView.enclosingScrollView;
    NSView * V2 = self.outputView.enclosingScrollView;
    NSView * V3 = self.errorView.enclosingScrollView;
    NSView * V4 = self.customView.enclosingScrollView;
    float h1 = V1? V1.frame.size.height: 0;
    float h2 = V2? V2.frame.size.height: 0;
    float h3 = V3? V3.frame.size.height: 0;
    float h4 = V4? V4.frame.size.height: 0;
    [self takeContextValue: [NSString stringWithFormat: @"%f:%f:%f",
                (h1+h2+h3+h4>0? h1/(h1+h2+h3+h4): 0),
                (h2+h3+h4>0? h2/(h2+h3+h4): 0),
                (h3+h4>0? h3/(h3+h4): 0)]
            forKey: iTM2TeXPTaskInspectorSplitViewFactorsKey domain:iTM2ContextAllDomainsMask];
//LOG4iTM3(@"[self contextValueForKey:iTM2TeXPTaskInspectorSplitViewFactorsKey] is: %@", [self contextValueForKey:iTM2TeXPTaskInspectorSplitViewFactorsKey domain:iTM2ContextAllDomainsMask]);
    return [super validateWindowContent4iTM3];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  windowShouldClose:
- (BOOL)windowShouldClose:(id)sender;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/11/01)
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self.window orderOut:self];
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  windowTitleForDocumentDisplayName:
- (NSString *)windowTitleForDocumentDisplayName:(NSString *)displayName;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if(!displayName.length)
        displayName = [self.document displayName];// retrieve the "untitled"
    return [NSString stringWithFormat: 
        NSLocalizedStringFromTableInBundle(@"%1$@ (%2$@)", iTM2ProjectTable, [iTM2ProjectDocument classBundle4iTM3], "blah (project name)"),
        [self.class prettyInspectorMode],
            displayName];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  windowsMenuItemTitleForDocumentDisplayName4iTM3:
- (NSString *)windowsMenuItemTitleForDocumentDisplayName4iTM3:(NSString *)displayName;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [self.class prettyInspectorMode];
}
#pragma mark =-=-=-=-=-=-  SPLIT VIEW
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  splitViewDidResizeSubviews:
- (void)splitViewDidResizeSubviews:(NSNotification *)notification;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSView * V1 = self.smartView.enclosingScrollView;
    NSView * V2 = self.outputView.enclosingScrollView;
    NSView * V3 = self.errorView.enclosingScrollView;
    NSView * V4 = self.customView.enclosingScrollView;
    NSRect R1 = V1.frame;
    NSRect R2 = V2.frame;
    NSRect R3 = V3.frame;
    NSRect R4 = V4.frame;
    float level = 4;
    if(R1.size.height<level)
    {
        R2.size.height += R1.size.height;
        R1.size.height = 0;
    }
    if(R2.size.height<level)
    {
        R3.size.height += R2.size.height;
        R2.size.height = 0;
    }
    if(R3.size.height<level)
    {
        R4.size.height += R3.size.height;
        R3.size.height = 0;
    }
    if(R4.size.height<level)
    {
        R3.size.height += R4.size.height;
        R4.size.height = 0;
    }
    [[notification object] adjustSubviews];
    self.validateWindowContent4iTM3;
    return;
}
#pragma mark =-=-=-=-=-=-  CUSTOM VIEW
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  customView
- (id)customView;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/11/01)
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSTextView * TV = metaGETTER;
    if(!TV)
    {
        self.window;
        TV = metaGETTER;
    }
    return TV;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setCustomView:
- (void)setCustomView:(NSTextView *)argument;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/11/01)
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if(argument && ![argument isKindOfClass:[NSTextView class]])
        [NSException raise: NSInvalidArgumentException format: @"%@ NSTextView class expected, got: %@.",
            __iTM2_PRETTY_FUNCTION__, argument];
    else
    {
        NSTextView * old = metaGETTER;
        if(old != argument)
        {
            [old setDelegate:nil];
            metaSETTER(argument);
            [argument setDelegate:self];// used for clickedAtIndex:
			[argument setTypingAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
				[NSFont userFixedPitchFontOfSize:[NSFont systemFontSize]], NSFontAttributeName, nil]];
        }
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleTerminalCustom:
- (IBAction)toggleTerminalCustom:(id)sender;
/*"The sender is expected to be a pop up button.
Version History: jlaurens AT users DOT sourceforge DOT net (09/11/01)
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSView * V = self.customView.enclosingScrollView;
    NSSplitView * SV = (NSSplitView *)[V superview];
    if([SV respondsToSelector:@selector(adjustSubviews)])
    {
        if(ABS([V visibleRect].size.height)<SV.frame.size.height*0.05)
        {
            [V setFrameSize: NSMakeSize(V.frame.size.width, SV.frame.size.height/3)];
            [SV adjustSubviews];
        }
        else
        {
            [V setFrameSize: NSMakeSize(V.frame.size.width, 0)];
            [SV adjustSubviews];
        }
        [sender validateWindowContent4iTM3];
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleTerminalCustom:
- (BOOL)validateToggleTerminalCustom:(NSButton *)sender;
/*"The sender is expected to be a pop up button.
Version History: jlaurens AT users DOT sourceforge DOT net (09/11/01)
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSView * V = self.customView.enclosingScrollView;
    NSSplitView * SV = (NSSplitView *)[V superview];
    if([SV respondsToSelector:@selector(adjustSubviews)]
        && ABS([V visibleRect].size.height)<SV.frame.size.height*0.05)
    {
        NSSize s = V.frame.size;
        if(s.height>0)
        {
            NSView * V1 = self.smartView.enclosingScrollView;
            NSView * V2 = self.outputView.enclosingScrollView;
            NSView * V3 = self.errorView.enclosingScrollView;
//            NSView * V4 = self.customView.enclosingScrollView;
            NSSize s1 = V1.frame.size;
            NSSize s2 = V2.frame.size;
            NSSize s3 = V3.frame.size;
            if(s3.height>0)
            {
                s3.height += s.height;
                [V3 setFrameSize: s3];
            }
            else if(s2.height>0)
            {
                s2.height += s.height;
                [V2 setFrameSize: s2];
            }
            else if(s1.height>0)
            {
                s1.height += s.height;
                [V1 setFrameSize: s1];
            }
            [V setFrameSize: NSMakeSize(V.frame.size.width, 0)];
        }
        sender.state = NO;
    }
    else
        sender.state = YES;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  logCustom:
- (void)logCustom:(NSString *)argument;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/11/01)
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSTextView * TV = self.customView;
    NSTextStorage * TS = [TV textStorage];
    [TS beginEditing];
    [TS appendAttributedString:[[[NSAttributedString alloc] initWithString:argument] autorelease]];
    [TS endEditing];
    return;
}
#pragma mark =-=-=-=-=-=-  OUTPUT VIEW
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  outputView
- (NSTextView *)outputView;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/11/01)
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSTextView * TV = metaGETTER;
    if(!TV)
    {
        self.window;
        TV = metaGETTER;
    }
    return TV;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setOutputView:
- (void)setOutputView:(NSTextView *)argument;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/11/01)
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if(argument && ![argument isKindOfClass:[NSTextView class]])
        [NSException raise: NSInvalidArgumentException format: @"%@ NSTextView class expected, got: %@.",
            __iTM2_PRETTY_FUNCTION__, argument];
    else
    {
        NSTextView * old = metaGETTER;
        if(old != argument)
        {
            [old setDelegate:nil];
            metaSETTER(argument);
            [argument setDelegate:self];// used for clickedAtIndex:
			[argument setTypingAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
				[NSFont userFixedPitchFontOfSize:[NSFont systemFontSize]], NSFontAttributeName, nil]];
        }
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  textView:clickedOnLink:atIndex:
- (BOOL)textView:(NSTextView *)textView clickedOnLink:(id)link atIndex:(NSUInteger)charIndex;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/11/01)
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if(![textView.window isKeyWindow])
	{
		return NO;
	}
	NSTextStorage * TS = [[textView layoutManager] textStorage];
	NSString * path = [TS attribute:iTM2LogLinkFileAttributeName atIndex:charIndex effectiveRange:nil];
	if(!path)
	{
		path = [[TS attribute:iTM2LogFilesStackAttributeName atIndex:charIndex effectiveRange:nil] lastObject];
	}
	if(![path hasPrefix:iTM2PathComponentsSeparator])
	{
		iTM2TeXProjectDocument * TPD = (id)self.document;
		NSURL * sourceURL = [SPC URLForFileKey:TWSContentsKey filter:iTM2PCFilterRegular inProjectWithURL:TPD.fileURL];
		NSString * clickedPath = [[NSURL URLWithPath4iTM3:path relativeToURL:sourceURL] path];
		if(![DFM fileExistsAtPath:clickedPath])
		{
			NSURL * factoryURL = [SPC URLForFileKey:TWSFactoryKey filter:iTM2PCFilterRegular inProjectWithURL:TPD.fileURL];
			clickedPath = [[NSURL URLWithPath4iTM3:path relativeToURL:factoryURL] path];
			if(![DFM fileExistsAtPath:clickedPath])
			{
				clickedPath = [[TPD URLForFileKey:[TPD masterFileKey]] path];// won't work if the master file key is Front Document related
				clickedPath = [[clickedPath.stringByDeletingLastPathComponent stringByAppendingPathComponent:path] stringByStandardizingPath];
				if(![DFM fileExistsAtPath:clickedPath])
				{
					// list all the subdocuments of the project and open the one with the same last path component
					NSArray * allKeys = [TPD fileKeys];
					NSString * key = nil;
					for(key in allKeys)
					{
						clickedPath = [[TPD URLForFileKey:key] path];
						if([clickedPath.lastPathComponent pathIsEqual4iTM3:path])
						{
							goto resolved;
						}
					}
					return NO;
				}
			}
		}
resolved:
		path = clickedPath;
	}
	id N = [TS attribute:iTM2LogLinkLineAttributeName atIndex:charIndex effectiveRange:nil];
	if([N unsignedIntegerValue]>0)
	{
		NSUInteger line = [N unsignedIntegerValue]-1;
		N = [TS attribute:iTM2LogLinkColumnAttributeName atIndex:charIndex effectiveRange:nil];
		NSUInteger column = ([N integerValue]>0? [N integerValue]: -1);
		N = [TS attribute:iTM2LogLinkLengthAttributeName atIndex:charIndex effectiveRange:nil];
		NSUInteger length = (N? [N integerValue]: -1);
		[[SDC openDocumentWithContentsOfURL:[NSURL fileURLWithPath:path] display:NO error:nil]
			displayLine:line column:column length:length withHint:nil orderFront:YES];
	}
	else
	{
		NSError * error = nil;
		id D = [SDC openDocumentWithContentsOfURL:[NSURL fileURLWithPath:path] display:YES error: &error];
		if(!D)
		{
			if(error)
			{
				[SDC presentError:error];
			}
			else
			{
				LOG4iTM3(@"Could not open %@", path);
			}
		}
	}
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleTerminalOutput:
- (IBAction)toggleTerminalOutput:(id)sender;
/*"The sender is expected to be a pop up button.
Version History: jlaurens AT users DOT sourceforge DOT net (09/11/01)
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSView * V = self.outputView.enclosingScrollView;
    NSSplitView * SV = (NSSplitView *)[V superview];
    if([SV respondsToSelector:@selector(adjustSubviews)])
    {
        if(ABS([V visibleRect].size.height)<SV.frame.size.height*0.05)
            [V setFrameSize: NSMakeSize(V.frame.size.width, SV.frame.size.height/3)];
        else
            [V setFrameSize: NSMakeSize(V.frame.size.width, 0)];
        [SV adjustSubviews];
    }
    [sender validateWindowContent4iTM3];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleTerminalOutput:
- (BOOL)validateToggleTerminalOutput:(NSButton *)sender;
/*"The sender is expected to be a pop up button.
Version History: jlaurens AT users DOT sourceforge DOT net (09/11/01)
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSView * V = self.outputView.enclosingScrollView;
    NSSplitView * SV = (NSSplitView *)[V superview];
    if([SV respondsToSelector:@selector(adjustSubviews)]
        && ABS([V visibleRect].size.height)<SV.frame.size.height*0.05)
    {
        [V setFrameSize: NSMakeSize(V.frame.size.width, 0)];
        [SV adjustSubviews];
        sender.state = NO;
    }
    else
        sender.state = YES;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  logOutput:
- (void)logOutput:(NSString *)argument;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/11/01)
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSString * buffer = ([[[IMPLEMENTATION metaValueForKey:@"_currentOutputBuffer"] retain] autorelease]?:@"");
    [IMPLEMENTATION takeMetaValue:@"" forKey:@"_currentOutputBuffer"];
    // the output is meant to be parse one line after the other
    // the buffer contains the last line if it does not end with an EOL
    // We parse the argument
    argument = [buffer stringByAppendingString:argument];
    NSMutableArray * lines = [IMPLEMENTATION metaValueForKey:@"_lines"];
    NSRange R = iTM3MakeRange(0, 0);
    while(R.location<argument.length)
    {
        NSUInteger contentsEnd;
        NSRange r = R;
        [argument getLineStart:nil end: &R.location contentsEnd: &contentsEnd forRange:R];
        r.length = R.location - r.location;
        NSString * s = [argument substringWithRange:r];
        if(contentsEnd<R.location)
        {
            [lines addObject:s];
        }
        else
        {
            [IMPLEMENTATION takeMetaValue:s forKey:@"_currentOutputBuffer"];
        }
    }
    [self updateOutputAndError:self];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  outputDidTerminate
- (void)outputDidTerminate;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/11/01)
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSString * buffer = ([[[IMPLEMENTATION metaValueForKey:@"_currentOutputBuffer"] retain] autorelease]?:@"");
    [IMPLEMENTATION takeMetaValue:@"" forKey:@"_currentOutputBuffer"];
    if(buffer.length)
        [[IMPLEMENTATION metaValueForKey:@"_lines"] addObject:buffer];// we are sure the buffer gets flushed
    [self logOutput:@"\niTM2:  task terminated"];
//END4iTM3;
    return;
}
#pragma mark =-=-=-=-=-=-  ERROR VIEW
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  errorView
- (NSTextView *)errorView;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/11/01)
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSTextView * TV = metaGETTER;
    if(!TV)
    {
        self.window;
        TV = metaGETTER;
    }
    return TV;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setErrorView:
- (void)setErrorView:(NSTextView *)argument;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/11/01)
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if(argument && ![argument isKindOfClass:[NSTextView class]])
        [NSException raise: NSInvalidArgumentException format: @"%@ NSTextView class expected, got: %@.",
            __iTM2_PRETTY_FUNCTION__, argument];
    else
    {
        NSTextView * old = metaGETTER;
        if(old != argument)
        {
            metaSETTER(argument);
            [argument setDelegate:self];// used for clickedAtIndex:
			[argument setTypingAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
				[NSFont userFixedPitchFontOfSize:[NSFont systemFontSize]], NSFontAttributeName, nil]];
        }
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleTerminalErrors:
- (IBAction)toggleTerminalErrors:(id)sender;
/*"The sender is expected to be a pop up button.
Version History: jlaurens AT users DOT sourceforge DOT net (09/11/01)
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSView * V = self.errorView.enclosingScrollView;
    NSSplitView * SV = (NSSplitView *)[V superview];
    if([SV respondsToSelector:@selector(adjustSubviews)])
    {
        if(ABS([V visibleRect].size.height)<SV.frame.size.height*0.05)
            [V setFrameSize: NSMakeSize(V.frame.size.width, SV.frame.size.height/3)];
        else
            [V setFrameSize: NSMakeSize(V.frame.size.width, 0)];
        [SV adjustSubviews];
    }
    [sender validateWindowContent4iTM3];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleTerminalErrors:
- (BOOL)validateToggleTerminalErrors:(NSButton *)sender;
/*"The sender is expected to be a pop up button.
Version History: jlaurens AT users DOT sourceforge DOT net (09/11/01)
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSView * V = self.errorView.enclosingScrollView;
    NSSplitView * SV = (NSSplitView *)[V superview];
    if([SV respondsToSelector:@selector(adjustSubviews)]
        && ABS([V visibleRect].size.height)<SV.frame.size.height*0.05)
    {
        [V setFrameSize: NSMakeSize(V.frame.size.width, 0)];
        [SV adjustSubviews];
        sender.state = NO;
    }
    else
        sender.state = YES;
	NSMutableAttributedString * MAS = [[[NSMutableAttributedString alloc] initWithAttributedString:[sender attributedTitle]] autorelease];
	if(MAS.length)
	{
		NSString * key = [self contextStringForKey:iTM2TPFELogParserKey domain:iTM2ContextAllDomainsMask];
		id LP = [iTM2LogParser logParserForKey:key];// get the cached log parser
		[MAS addAttribute: NSForegroundColorAttributeName
			value: ([[self.errorView string] length]>0?
					[LP logColorForType:@"iTeXMac2 Error"]
						:[NSColor controlTextColor])
				range: iTM3MakeRange(0, MAS.length)];
		[sender setAttributedTitle:MAS];

	}
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  logError:
- (void)logError:(NSString *)argument;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/11/01)
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSTextView * TV = self.errorView;
    NSRange R;
    NSTextStorage * TS = [TV textStorage];
    R.location = TS.length;
    [TS beginEditing];
    [[TS mutableString] appendString:argument];
    R.length = TS.length - R.location;
	NSString * key = [self contextStringForKey:iTM2TPFELogParserKey domain:iTM2ContextAllDomainsMask];
	id LP = [iTM2LogParser logParserForKey:key];// get the cached log parser
	NSColor * color = [LP logColorForType:@"iTeXMac2 Error"];
    [TS addAttribute:NSForegroundColorAttributeName value:color range:R];
    [TS endEditing];
    [self updateOutputAndError:self];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  errorDidTerminate
- (void)errorDidTerminate;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/11/01)
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return;
}
#pragma mark =-=-=-=-=-=-  GENERAL
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  fontOrColorDidChangeNotified:
- (void)fontOrColorDidChangeNotified:(NSNotification *)aNotification;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Apr 16 11:39:43 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
#warning DEBUGGG: the settings must be revisited too
    id contextManager = [aNotification object];
    if(!contextManager) contextManager = self;

    NSTextView * TV = self.outputView;
    [TV setFont:[contextManager contextFontForKey:iTM2UDLogStandardFontKey domain:iTM2ContextAllDomainsMask]];
    [TV setDrawsBackground:[contextManager contextBoolForKey:iTM2UDLogDrawsTextBackgroundKey domain:iTM2ContextAllDomainsMask]];
    if([TV drawsBackground])
    {
        [TV setBackgroundColor:[contextManager contextColorForKey:iTM2UDLogTextBackgroundColorKey domain:iTM2ContextAllDomainsMask]];
        [TV setInsertionPointColor:[contextManager contextColorForKey:iTM2UDLogInsertionPointColorKey domain:iTM2ContextAllDomainsMask]];
        [TV setSelectedTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                [contextManager contextColorForKey:iTM2UDLogSelectedTextColorKey domain:iTM2ContextAllDomainsMask], NSForegroundColorAttributeName,
                [contextManager contextColorForKey:iTM2UDLogSelectedTextBackgroundColorKey domain:iTM2ContextAllDomainsMask], NSBackgroundColorAttributeName,
                    nil]];
    }
    else
    {
        [TV setBackgroundColor:[NSColor textBackgroundColor]];
        [TV setInsertionPointColor:[NSColor blackColor]];
        [TV setSelectedTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                [NSColor selectedTextColor], NSForegroundColorAttributeName,
                [NSColor selectedTextBackgroundColor], NSBackgroundColorAttributeName,
                        nil]];
    }

    NSScrollView * SV = TV.enclosingScrollView;
    [SV setDrawsBackground:YES];
    [SV setBackgroundColor: ([TV drawsBackground]? [TV backgroundColor]:[NSColor textBackgroundColor])];
    [SV setNeedsDisplay:YES];

    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  cleanLog:
- (void)cleanLog:(id) sender;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/11/01)
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [IMPLEMENTATION takeMetaValue: [NSMutableArray arrayWithObjects:
            [NSMutableDictionary dictionaryWithObjectsAndKeys:@"1", @"message", @"here1", @"location", nil],
            [NSMutableDictionary dictionaryWithObjectsAndKeys:@"2", @"message", @"here2", @"location", nil],
            [NSMutableDictionary dictionaryWithObjectsAndKeys:@"3", @"message", @"here3", @"location", nil],
                nil] forKey: @"_errors"];
    [IMPLEMENTATION takeMetaValue:[NSMutableArray array] forKey:@"_lines"];
    [IMPLEMENTATION takeMetaValue:[NSMutableArray array] forKey:@"_messages"];
    [IMPLEMENTATION takeMetaValue:@"" forKey:@"_currentOutputBuffer"];
    [IMPLEMENTATION takeMetaValue:[NSNumber numberWithInteger:0] forKey:@"_numberOfLines4iTM3"];
    [self.outputView setString:@""];
    [self.errorView setString:@""];
    [self.customView setString:@""];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  updateOutputAndError:
- (void)updateOutputAndError:(id)irrelevant;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/11/01)
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSMutableArray * lines = [IMPLEMENTATION metaValueForKey:@"_lines"];
    NSMutableArray * messages = [IMPLEMENTATION metaValueForKey:@"_messages"];
    NSInteger oldNORs = [[IMPLEMENTATION metaValueForKey:@"_numberOfLines4iTM3"] integerValue];
	NSString * key = [self contextStringForKey:iTM2TPFELogParserKey domain:iTM2ContextAllDomainsMask];
    id LP = [iTM2LogParser logParserForKey:key];// get the cached log parser
    NSTextView * TV = self.outputView;
	NSRange visibleRange = [TV visibleRange];
    NSTextStorage * TS = [TV textStorage];
//LOG4iTM3(@"WILL SCROLL:%@,%i",NSStringFromRange(visibleRange),TS.length);
    [TS beginEditing];
    NSUInteger begin = 0;
    [[TS mutableString] getLineStart: &begin end:nil contentsEnd:nil forRange:iTM3MakeRange(TS.length, 0)];
    [TS deleteCharactersInRange:iTM3MakeRange(begin, [[TV string] length] - begin)];
    NSAttributedString * AS = messages.lastObject;
    while(oldNORs < lines.count)
    {
		NSString * line = [lines objectAtIndex:oldNORs++];
        if(AS = [LP attributedMessageWithString:line previousMessage:AS])
        {
//NSLog(@"attributed message:");
//NSLog(@"<%@>", AS);
            [messages addObject:AS];
            [TS appendAttributedString:AS];
        }
    }
    if(AS = [LP attributedMessageWithString: ([[[IMPLEMENTATION metaValueForKey:@"_currentOutputBuffer"] retain] autorelease]?:@"") previousMessage:AS])
    {
//NSLog(@"attributed message:");
//NSLog(@"<%@>", AS);
        [TS appendAttributedString:AS];
    }
    [TS endEditing];
    [IMPLEMENTATION takeMetaValue:[NSNumber numberWithInteger:lines.count] forKey:@"_numberOfLines4iTM3"];
    [self.smartView reloadData];
	if(iTM3MaxRange(visibleRange)+1>=begin)
	{
		[TV scrollRangeToVisible:iTM3MakeRange(TS.length, 0)];
		visibleRange = [TV visibleRange];
//LOG4iTM3(@"DID SCROLL:%@,%i,%i",NSStringFromRange(visibleRange),begin,TS.length);
	}
	else
	{
//LOG4iTM3(@"DONT SCROLL:%@,%i,%i",NSStringFromRange(visibleRange),begin,TS.length);
	}
	[TV setEditable:NO];
    self.validateWindowContent4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeStyleFromRepresentedObject:
- (IBAction)takeStyleFromRepresentedObject:(id)sender;
/*"The sender is expected to be a pop up button.
Version History: jlaurens AT users DOT sourceforge DOT net (09/11/01)
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSString * newStyle = [[sender selectedItem] representedObject];
	NSString * oldStyle = [self contextStringForKey:iTM2TPFELogParserKey domain:iTM2ContextAllDomainsMask];
	if(![newStyle isEqualToString:oldStyle])
	{
		[self takeContextValue:newStyle forKey:iTM2TPFELogParserKey domain:iTM2ContextAllDomainsMask];
		[self.document updateChangeCount:NSChangeDone];
	}
    self.validateWindowContent4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateTakeStyleFromRepresentedObject:
- (BOOL)validateTakeStyleFromRepresentedObject:(NSPopUpButton *)sender;
/*"The sender is expected to be a pop up button.
Version History: jlaurens AT users DOT sourceforge DOT net (09/11/01)
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if([sender isKindOfClass:[NSPopUpButton class]])// bad design of the iTM2 validation protocol?
    {
		// populate the button with items
		if(![[sender lastItem] representedObject])
		{
			NSUInteger oldCount = [sender numberOfItems];
			// originally, this button only contains 1 fake item
			// get the list of all the log parsers
			NSPointerArray * PA = [iTM2Runtime subclassReferencesOfClass:[iTM2LogParser class]];
			NSUInteger i = PA.count;
			while(i--)
			{
				Class C = (Class)[PA pointerAtIndex:i];
				NSString * key = [C key];
				[sender addItemWithTitle:key];
				sender.lastItem.representedObject = key;
			}
			while(oldCount--)
			{
				[sender removeItemAtIndex:0];
			}
		}
		NSUInteger compatibility = [self contextIntegerForKey:iTM2TPFELogParserKey domain:iTM2ContextAllDomainsMask];// old implementation
        NSString * style = compatibility == 1?
			@"LaTeX":
			[self contextStringForKey:iTM2TPFELogParserKey domain:iTM2ContextAllDomainsMask];
		NSUInteger idx = [sender indexOfItemWithRepresentedObject:style];
		if(idx == NSNotFound)
		{
			style = [iTM2TeXLogParser key];
			[self takeContextValue:style forKey:iTM2TPFELogParserKey domain:iTM2ContextPrivateMask];
			idx = [sender indexOfItemWithRepresentedObject:style];
		}
        [sender selectItemAtIndex:idx];
    }
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleTerminalSilent:
- (IBAction)toggleTerminalSilent:(id)sender;
/*"The sender is expected to be a pop up button.
Version History: jlaurens AT users DOT sourceforge DOT net (09/11/01)
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	iTM2TaskController * TC = self.taskController;
	[TC setMute: ![TC isMute]];
	[self.document updateChangeCount:NSChangeDone];
    [sender validateWindowContent4iTM3];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleTerminalSilent:
- (BOOL)validateToggleTerminalSilent:(NSButton *)sender;
/*"The sender is expected to be a pop up button.
Version History: jlaurens AT users DOT sourceforge DOT net (09/11/01)
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    sender.state = [self.taskController isMute];
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleTerminalHidden:
- (IBAction)toggleTerminalHidden:(id)sender;
/*"The sender is expected to be a pop up button.
Version History: jlaurens AT users DOT sourceforge DOT net (09/11/01)
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[self setHidden: !self.isHidden];
	[self.document updateChangeCount:NSChangeDone];
    [sender validateWindowContent4iTM3];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleTerminalHidden:
- (BOOL)validateToggleTerminalHidden:(NSButton *)sender;
/*"The sender is expected to be a pop up button.
Version History: jlaurens AT users DOT sourceforge DOT net (09/11/01)
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    sender.state = self.isHidden;
    return ! [self.taskController isMute];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  isHidden
- (BOOL)isHidden;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [self contextBoolForKey:iTM2TaskTerminalIsHiddenKey domain:iTM2ContextAllDomainsMask];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setHidden:
- (void)setHidden:(BOOL)yorn;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self takeContextBool:yorn forKey:iTM2TaskTerminalIsHiddenKey domain:iTM2ContextAllDomainsMask];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= taskDidTerminate
- (void)taskDidTerminate;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/11/01)
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//    [self logCustom:@"\n<iTM2Comment>Task terminated</iTM2Comment>"];// to be changed, some widget should change
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  taskController
- (id)taskController;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	id TC = [super taskController];
	if(!TC)
	{
		[self.document taskController];// expected to connect the receiver as side effect
		TC = [super taskController];
	}
    return TC;
}
#pragma mark =-=-=-=-=-  ACTIONS
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  projectTerminalIgnore:
- (IBAction)projectTerminalIgnore:(id)sender;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/11/01)
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[[self.document taskController] execute:@"i"];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  projectTerminalStop:
- (IBAction)projectTerminalStop:(id)sender;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/11/01)
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[[self.document taskController] execute:@"s"];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  projectTerminalQuiet:
- (IBAction)projectTerminalQuiet:(id)sender;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/11/01)
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[[self.document taskController] execute:@"q"];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  projectTerminalEdit:
- (IBAction)projectTerminalEdit:(id)sender;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/11/01)
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[[self.document taskController] execute:@"e"];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  projectTerminalExit:
- (IBAction)projectTerminalExit:(id)sender;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/11/01)
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[[self.document taskController] execute:@"x"];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  projectExecute:
- (IBAction)projectExecute:(NSControl *)sender;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/11/01)
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[[self.document taskController] execute:[sender stringValue]];
	sender.stringValue = @"";
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  showError:
- (IBAction)showError:(id)sender;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/11/01)
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//NSLog(@"sender is: %@", sender);
    return;
}
#pragma mark =-=-=-=-=-  SMART VIEW
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  smartView
- (NSTableView *)smartView;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/11/01)
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    id TV = metaGETTER;
    if(!TV)
    {
        self.window;
        TV = metaGETTER;
    }
    return TV;
//END4iTM3;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setSmartView:
- (void)setSmartView:(NSTableView *)argument;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/11/01)
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSTableView * old = metaGETTER;
    if(old != argument)
    {
        metaSETTER(argument);
        [argument setDelegate:self];
        argument.dataSource = self;
    }
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  smartView:objectValueForTableColumn:row:
- (id)smartView:(NSTableView *)smartView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSArray * RA = [IMPLEMENTATION metaValueForKey:@"_errors"];
    return (row >= 0 && row < RA.count)? [[RA objectAtIndex:row] valueForKey:[tableColumn identifier]]: nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  numberOfRowsInTableView:
- (NSInteger)numberOfRowsInTableView:(NSTableView *)smartView;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [(NSArray *)[IMPLEMENTATION metaValueForKey:@"_errors"] count];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleSmartErrors:
- (IBAction)toggleSmartErrors:(id)sender;
/*"The sender is expected to be a pop up button.
Version History: jlaurens AT users DOT sourceforge DOT net (09/11/01)
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSView * V = self.smartView.enclosingScrollView;
    NSSplitView * SV = (NSSplitView *)[V superview];
    if([SV respondsToSelector:@selector(adjustSubviews)])
    {
        if(ABS([V visibleRect].size.height)<SV.frame.size.height*0.05)
            [V setFrameSize: NSMakeSize(V.frame.size.width, SV.frame.size.height/3)];
        else
            [V setFrameSize: NSMakeSize(V.frame.size.width, 0)];
        [SV adjustSubviews];
        [sender validateWindowContent4iTM3];
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleSmartErrors:
- (BOOL)validateToggleSmartErrors:(NSButton *)sender;
/*"The sender is expected to be a pop up button.
Version History: jlaurens AT users DOT sourceforge DOT net (09/11/01)
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSView * V = self.smartView.enclosingScrollView;
    NSSplitView * SV = (NSSplitView *)[V superview];
    if([SV respondsToSelector:@selector(adjustSubviews)]
        && ABS([V visibleRect].size.height)<SV.frame.size.height*0.05)
    {
        [V setFrameSize: NSMakeSize(V.frame.size.width, 0)];
        [SV adjustSubviews];
        sender.state = NO;
    }
    else
        sender.state = YES;
    return YES;
}
@end

@interface NSDocument(iTM2TeXProjectTaskKit)
- (id)taskController;
@end
@implementation NSDocument(iTM2TeXProjectTaskKit)
- (id)taskController;{return nil;}
@end
@interface NSObject(RIEN_RIEN)
- (NSInteger)length;
@end

#import <iTM2TeXFoundation/iTM2TeXProjectFrontendKit.h>

@implementation iTM2MainInstaller(TeXProjectTaskKit)
+ (void)prepareTeXProjectTaskKitCompleteInstallation4iTM3;
{
	if([iTM2TaskController swizzleInstanceMethodSelector4iTM3:@selector(SWZ_iTM2TeXProject_contextManager) error:NULL])
	{
		MILESTONE4iTM3((@"iTM2TaskController(TeXProject)"),(@"The context manager of TeX projects is not the good one"));
	}
}
@end

@implementation iTM2TaskController(TeXProject)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  SWZ_iTM2TeXProject_contextManager
- (id)SWZ_iTM2TeXProject_contextManager;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    id inspector, TPD;
    return (inspector = self.allInspectors.lastObject)
                && (TPD = [SPC TeXProjectForSource:inspector])?
                    [TPD contextManager]:[self SWZ_iTM2TeXProject_contextManager];
}
@end

//#import <iTM2Foundation/iTM2ObjectServer.h>

NSString * const iTM2TPFELogParserKey = @"iTM2LogParser";

@implementation iTM2LogParser
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  registerParser
+ (void)registerParser;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Apr 16 11:39:43 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [iTM2ObjectServer registerObject:self forType:iTM2TPFELogParserKey key:self.key retain:NO];
//END4iTM3;
    return;
}
static NSDictionary * _iTM2LogColors = nil;
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initialize
+ (void)initialize;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Apr 16 11:39:43 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [super initialize];
    self.registerParser;
    if(!_iTM2LogColors)
        _iTM2LogColors = [[NSDictionary dictionaryWithObjectsAndKeys:
            [NSColor blackColor], @"Normal",
            [NSColor blackColor], @"Ignore",
            [NSColor blackColor], @"Ignore Next",
            [NSColor colorWithCalibratedRed:1 green:0.0 blue:0.0 alpha:1.0], @"iTeXMac2 Error",
            [NSColor colorWithCalibratedRed:0.5 green:0.0 blue:0.0 alpha:1.0], @"iTeXMac2 Comment",
            [NSColor colorWithCalibratedRed:0.0 green:0.25 blue:0.0 alpha:1.0], @"LaTeX Font Info",
            [NSColor colorWithCalibratedRed:0.0 green:0.25 blue:0.0 alpha:1.0], @"LaTeX Info",
            [NSColor colorWithCalibratedRed:0.0 green:0.25 blue:0.0 alpha:1.0], @"TeX Info",
            [NSColor colorWithCalibratedRed:1.0 green:0.33 blue:0.0 alpha:1.0], @"LaTeX Font Warning",
            [NSColor colorWithCalibratedRed:1.0 green:0.33 blue:0.0 alpha:1.0], @"LaTeX Warning",
            [NSColor colorWithCalibratedRed:0.0 green:0.0 blue:0.5 alpha:1.0], @"Package",
            [NSColor colorWithCalibratedRed:0.0 green:0.0 blue:0.5 alpha:1.0], @"File",
            [NSColor colorWithCalibratedRed:1.0 green:0.33 blue:0.0 alpha:1.0], @"TeX Warning",
            [NSColor colorWithCalibratedRed:0.75 green:0.0 blue:0.0 alpha:1.0], @"TeX Error",
            [NSColor colorWithCalibratedRed:0.75 green:0.0 blue:0.0 alpha:1.0], @"TeX Error line",
            [NSColor colorWithCalibratedRed:0.75 green:0.0 blue:0.0 alpha:1.0], @"TeX Error query",
            [NSColor colorWithCalibratedRed:0.75 green:0.0 blue:0.0 alpha:1.0], @"TeX Error file:line", nil] retain];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  key
+ (NSString *)key;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Apr 16 11:39:43 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return @"";
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  attributedMessageWithString:previousMessage:
+ (id)attributedMessageWithString:(NSString *)argument previousMessage:(NSAttributedString *)message;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/11/01)
- 1.4: Fri Apr 16 11:39:43 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [[[NSAttributedString alloc] initWithString:argument] autorelease];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  logParserForKey:
+ (id)logParserForKey:(NSString *)key;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Apr 16 11:39:43 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [iTM2ObjectServer objectForType:iTM2TPFELogParserKey key: (key?:@"")];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  logColorForType:
+ (NSColor *)logColorForType:(NSString *)type;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Apr 16 11:39:43 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [_iTM2LogColors objectForKey:type]?:[NSColor magentaColor];
}
@end

//#import <iTM2Foundation/iTM2LiteScanner.h>
extern NSString * const iTM2LineAttributeName;
extern NSString * const iTM2LogInputAttributeName;
#define diTM2IAN iTM2LogInputAttributeName
extern NSString * const iTM2WarningInput;
extern NSString * const iTM2ErrorInput;
extern NSString * const iTM2InfoInput;

@implementation iTM2TeXLogParser
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  key
+ (NSString *)key;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Apr 16 11:39:43 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return @"None";
}
@end

/*"This object manages the UI of the task controller."*/
