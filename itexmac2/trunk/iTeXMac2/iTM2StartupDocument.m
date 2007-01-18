//
//  iTM2StartupDocument.m
//  iTeXMac2
//
//  @version Subversion: $Id$ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Tue Sep 11 2001.
//  Copyright © 2005 Laurens'Tribune. All rights reserved.
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
//

#import "iTM2StartupDocument.h"

@implementation iTM2StartupDocument

- (id)init
{iTM2_DIAGNOSTIC;
    self = [super init];
    if (self) {
    
        // Add your subclass-specific initialization here.
        // If an error occurs here, send a [self release] message and return nil.
    
    }
    return self;
}

- (NSString *)windowNibName
{iTM2_DIAGNOSTIC;
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"iTM2StartupDocument";
}

- (void)windowControllerDidLoadNib:(NSWindowController *) aController
{iTM2_DIAGNOSTIC;
    [super windowControllerDidLoadNib:aController];
    // Add any code here that needs to be executed once the windowController has loaded the document's window.
}

- (NSData *)dataRepresentationOfType:(NSString *)aType
{iTM2_DIAGNOSTIC;
    // Insert code here to write your document from the given data.  You can also choose to override -fileWrapperRepresentationOfType: or -writeToFile:ofType: instead.
    return nil;
}

- (BOOL)loadDataRepresentation:(NSData *)data ofType:(NSString *)aType
{iTM2_DIAGNOSTIC;
    // Insert code here to read your document from the given data.  You can also choose to override -loadFileWrapperRepresentation:ofType: or -readFromFile:ofType: instead.
    return YES;
}

@end

#if 0
@interface iTM2Application_FixMenuShortcut: iTM2Application
@end

@implementation iTM2Application_FixMenuShortcut
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  load
+ (void)load;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.4: // :jlaurens:20040514 
To Do List:
"*/
{
//iTM2_START;
    iTM2_INIT_POOL;
	[NSBundle redirectNSLogOutput];
    [iTM2Application_FixMenuShortcut poseAsClass:[iTM2Application class]];
    iTM2_RELEASE_POOL;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  sendEvent:
- (void)sendEvent:(NSEvent *)anEvent;
/*"I am ashamed. This might be done elsewhere, but i do not know where or how...
This patch deals with command+arrow keystroke: different meanings while in text view or in pdf view.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{
//iTM2_START;
//iTM2_LOG(@"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX\nanEvent is: %@ (0x%x)", anEvent, anEvent);
    switch([anEvent type])
    {
        case NSKeyDown:
        {
            int mask = NSAlphaShiftKeyMask|NSShiftKeyMask|NSControlKeyMask|NSAlternateKeyMask|NSCommandKeyMask;
//            NSLog(@"[anEvent modifierFlags]: %u, %u, %u, %u", mask, [anEvent modifierFlags], mask & [anEvent modifierFlags], NSCommandKeyMask | NSAlternateKeyMask);
            if(([anEvent modifierFlags] & mask) == NSCommandKeyMask)
            {
                NSString * CIM = [anEvent charactersIgnoringModifiers];
                if([CIM length])
                {
                    switch([CIM characterAtIndex:0])
                    {
                        case NSUpArrowFunctionKey:
                        {
                            NSResponder * TV = [self targetForAction:@selector(moveToBeginningOfDocument:)];
                            if(TV)
                            {
                                [TV moveToBeginningOfDocument:self];
                                return;
                            }
                        }
                        case NSDownArrowFunctionKey:
                        {
                            NSResponder * TV = [self targetForAction:@selector(moveToEndOfDocument:)];
                            if(TV)
                            {
                                [TV moveToEndOfDocument:self];
                                return;
                            }
                        }
                        case NSLeftArrowFunctionKey:
                        {
                            NSResponder * TV = [self targetForAction:@selector(moveToBeginningOfLine:)];
                            if(TV)
                            {
                                [TV moveToBeginningOfLine:self];
                                return;
                            }
                        }
                        case NSRightArrowFunctionKey:
                        {
                            NSResponder * TV = [self targetForAction:@selector(moveToEndOfLine:)];
                            if(TV)
                            {
                                [TV moveToEndOfLine:self];
                                return;
                            }
                        }
                    }
                }
            }
            else if(([anEvent modifierFlags] & mask) == (NSCommandKeyMask | NSAlternateKeyMask))
            {
                NSString * CIM = [anEvent charactersIgnoringModifiers];
                if([CIM length])
                {
                    switch([CIM characterAtIndex:0])
                    {
                        case NSEndFunctionKey:
                        {
                            SEL A = @selector(displayLastPage:);
                            [[self targetForAction:A] performSelector:A withObject:self];
                            return;
                        }
                        case NSHomeFunctionKey:
                        {
                            SEL A = @selector(displayFirstPage:);
                            [[self targetForAction:A] performSelector:A withObject:self];
                            return;
                        }
                    }
                }
            }
//NSLog(@"[anEvent characters] are: %@", [anEvent characters]);
//NSLog(@"[anEvent charactersIgnoringModifiers] are: %@", [anEvent charactersIgnoringModifiers]);
            break;
        }
        #if 0
        #warning DEBUGGGGGGGGGG
        case NSLeftMouseDown:
        case NSLeftMouseUp:
        {
            NSLog(@"MouseDown");
            NSLog(@"type             %i", [anEvent type]);
            NSLog(@"window           %@", [anEvent window]);
            NSLog(@"windowNumber     %i", [anEvent windowNumber]);
            NSLog(@"locationInWindow %@", NSStringFromPoint([anEvent locationInWindow]));
            NSLog(@"clickCount       %i", [anEvent clickCount]);
            NSLog(@"buttonNumber     %i", [anEvent buttonNumber]);
            NSLog(@"pressure         %f", [anEvent pressure]);
        }
        #endif
        default:
            break;
    }
	#warning DEBUGGGGGGGGGGGGGGGGGGGGG
    [super sendEvent:anEvent];
    return;
}
#if 0
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  orderFrontColorPanel:
- (IBAction)orderFrontColorPanel:(id)sender;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.2: 03/10/2002
To Do List:
"*/
{
//iTM2_START;
    static BOOL firstTime = YES;
    if(![[NSColorPanel sharedColorPanel] accessoryView] && firstTime)
    {
        firstTime = NO;
        NSView * AV = [iTM2ColorPanelAccessoryViewController view];
        [[AV viewWithTag:1] setStringValue:@""];
        [[NSColorPanel sharedColorPanel] setAccessoryView:AV];
    }
    [super orderFrontColorPanel:sender];
    return;
}
#endif
@end
#endif
