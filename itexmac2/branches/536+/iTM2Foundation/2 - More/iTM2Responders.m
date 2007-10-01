/*
//
//  @version Subversion: $Id$ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Tue Nov 27 2001.
//  Copyright © 2001-2002 Laurens'Tribune. All rights reserved.
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

#import <iTM2Foundation/iTM2Responders.h>

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2Responders  

#import <iTM2Foundation/iTM2MenuKit.h>
#import <iTM2Foundation/iTM2ContextKit.h>
#import <iTM2Foundation/iTM2BundleKit.h>
#import <iTM2Foundation/iTM2TextDocumentKit.h>
#import <iTM2Foundation/iTM2PDFDocumentKit.h>
#import <iTM2Foundation/iTM2ProjectDocumentKit.h>
#import <iTM2Foundation/iTM2StringFormatKit.h>
#import <iTM2Foundation/iTM2ResponderKit.h>
//#import <iTM2Foundation/iTM2CompatibilityChecker.h>

#import <iTM2Foundation/iTM2PDFViewKit.h>
#import <iTM2Foundation/iTM2TextFieldKit.h>
#import <iTM2Foundation/iTM2PathUtilities.h>

@interface iTM2PDFResponder: iTM2AutoInstallResponder
- (id)PDFInspector;
@end

@implementation NSApplication(iTM2PDFResponder)
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
	[iTM2MileStone registerMileStone:@"No installer available" forKey:@"iTM2PDFResponder"];
//iTM2_END;
	iTM2_RELEASE_POOL;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2PDFResponderDidFinishLaunching
- (void)iTM2PDFResponderDidFinishLaunching;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([NSApp targetForAction:@selector(displayPDFAtMagnification:)])
		[iTM2MileStone putMileStoneForKey:@"iTM2PDFResponder"];
//iTM2_END;
	return;
}
@end

@implementation iTM2PDFResponder
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= PDFInspector
- (id)PDFInspector;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Jan 19 23:19:59 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    id PDFInspector = [[NSApp keyWindow] windowController];
    return [PDFInspector isKindOfClass:[iTM2PDFInspector class]]? PDFInspector:nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= contextManager
- (id)contextManager;
/*"TogglePDFs the display mode between iTM2StickMode and iTM2LastMode.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Jan 19 23:19:59 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [[self PDFInspector] contextManager]?:(id)SUD;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= album
- (id)album;
/*"TogglePDFs the display mode between iTM2StickMode and iTM2LastMode.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Jan 19 23:19:59 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [[self PDFInspector] album];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  displayPDFAtMagnification:
- (void)displayPDFAtMagnification:(float)magnification;
/*"Description forthcoming. From the menu items
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Jan 19 23:19:59 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [[self PDFInspector] setMagnification:magnification];
    [self takeContextFloat:magnification forKey:iTM2PDFCurrentMagnificationKey domain:iTM2ContextAllDomainsMask];
    [self takeContextInteger:iTM2PDFDisplayModeLast forKey:iTM2PDFDisplayModeKey domain:iTM2ContextAllDomainsMask];
//iTM2_END;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=  displayPDFAtFixedSize:...
- (IBAction)displayPDFAtFixedSize:(id)sender
/*"It is the message sent by a menu item of the display menu in the View menu.
It sets the display mode to iTM2FixedMode then sends a #{fixMagnification} message to the album.
As a side effect, it updates the album display if the magnification has changed.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.1a6 : 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self takeContextInteger:iTM2PDFDisplayModeLast forKey:iTM2PDFDisplayModeKey domain:iTM2ContextAllDomainsMask];
	id album = [[self PDFInspector] album];
    [album setMagnificationWithDisplayMode:iTM2PDFDisplayModeFixed stickMode:0];// unused stick mode
    [self takeContextFloat:[album magnification] forKey:iTM2PDFCurrentMagnificationKey domain:iTM2ContextAllDomainsMask];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateDisplayPDFAtFixedSize:
- (BOOL)validateDisplayPDFAtFixedSize:(id)anItem;
/*" This concerns only the magnification menu items of the PDF Display menu and the
corresponding ones in the popUp Fit button. Only takes into account the upper limit
of the magnification."*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	static NSString * atFixedSizeFormat = nil;
	if(!atFixedSizeFormat)
	{
		atFixedSizeFormat = [[anItem title] copy];
	}
    float f = [self contextFloatForKey:iTM2PDFFixedMagnificationKey domain:iTM2ContextAllDomainsMask] * 100;
    [anItem setTitle:[NSString stringWithFormat:atFixedSizeFormat, f]];
    return (f > 0);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  displayPDFFitFromTag:...
- (IBAction)displayPDFFitFromTag:(id)sender
/*"See #{displayFitToWidth}.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Jan 19 23:19:59 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self takeContextInteger:iTM2PDFDisplayModeLast forKey:iTM2PDFDisplayModeKey domain:iTM2ContextAllDomainsMask];
	id album = [[self PDFInspector] album];
    [album setMagnificationWithDisplayMode:iTM2PDFDisplayModeStick stickMode:[sender tag]];
    [self takeContextFloat:[album magnification] forKey:iTM2PDFCurrentMagnificationKey domain:iTM2ContextAllDomainsMask];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  displayPDFAtMagnificationFromRepresentedObject:
- (IBAction)displayPDFAtMagnificationFromRepresentedObject:(id)sender;
/*"Description forthcoming. From the menu items
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Jan 19 23:19:59 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if([sender representedObject])
    {
        [self takeContextInteger:iTM2PDFDisplayModeLast forKey:iTM2PDFDisplayModeKey domain:iTM2ContextAllDomainsMask];
        [[[self PDFInspector] album] setMagnification:[[sender representedObject] floatValue]];
    }
    else
    {
        iTM2MagnificationFormatter * MF = [[[iTM2MagnificationFormatter alloc] init] autorelease];
        NSDecimalNumber * number;
        if([MF getObjectValue:&number forString:[sender title] errorDescription:nil])
        {
            [self takeContextInteger:iTM2PDFDisplayModeLast forKey:iTM2PDFDisplayModeKey domain:iTM2ContextAllDomainsMask];
            [[[self PDFInspector] album] setMagnification:[number floatValue]];
        }
        else
        {
            [sender setAction:NULL];
            NSLog(@"Unexpected sender(action): %@", sender);
        }
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  displayPDFAtMagnificationFromStepper:
- (IBAction)displayPDFAtMagnificationFromStepper:(id)sender;
/*"Zoom In or Zoom Out.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Jan 19 23:19:59 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if([sender intValue]>0)
        [[self PDFInspector] doZoomIn:sender];
    else
        [[self PDFInspector] doZoomOut:sender];
    [sender setIntValue:0];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  displayPDFAtMagnificationFromField:
- (IBAction)displayPDFAtMagnificationFromField:(id)sender;
/*"Display mode is set to iTM2LastMode.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Jan 19 23:19:59 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [[self PDFInspector] setMagnification:[(id)[sender objectValue] floatValue]];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateMenuItem:
- (BOOL)validateMenuItem:(id)anItem;
/*" This concerns only the magnification menu items of the PDF Display menu and the
corresponding ones in the popUp Fit button. Only takes into account the upper limit
of the magnification."*/
{iTM2_DIAGNOSTIC;
    return [super validateMenuItem:(id) anItem] && ([[[self PDFInspector] album] imageRepresentation] != nil);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= displayPDFPhysicalPageNumber:
- (void)displayPDFPhysicalPageNumber:(int)pageNumber;
/*"Description Forthcoming. The first responder must never be the window but at least its content view unless we want to neutralize the iTM2FlagsChangedResponder.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Jan 19 23:19:59 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//NSLog(@"dpn");
    [[[self PDFInspector] album] setCurrentPhysicalPage:pageNumber];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= displayPDFPageFromTag:
- (IBAction)displayPDFPageFromTag:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Jan 19 23:19:59 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [[[self PDFInspector] album] setCurrentPhysicalPage:[[[self PDFInspector] album] logicalToPhysicalPage:[sender tag]]];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= validateDisplayPDFPageFromTag:
- (BOOL)validateDisplayPDFPageFromTag:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Jan 19 23:19:59 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	return [[[self PDFInspector] album] imageRepresentation]!=nil && [[[self PDFInspector] album] currentPhysicalPage]<[[[self PDFInspector] album] lastPhysicalPage];//add a page number check
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= displayPDFPageFromRepresentedObject:
- (IBAction)displayPDFPageFromRepresentedObject:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Jan 19 23:19:59 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [[[self PDFInspector] album] setCurrentPhysicalPage:
        [[[self PDFInspector] album] logicalToPhysicalPage:[[sender representedObject] intValue]]];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= validateDisplayPDFPageFromRepresentedObject:
- (BOOL)validateDisplayPDFPageFromRepresentedObject:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Jan 19 23:19:59 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [[self PDFInspector] album] != nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= displayPDFPageFromField:
- (IBAction)displayPDFPageFromField:(id)sender;
/*"Description Forthcoming. The first responder must never be the window but at least its content view unless we want to neutralize the iTM2FlagsChangedResponder.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Jan 19 23:19:59 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [[[self PDFInspector] album] setCurrentPhysicalPage:[[[self PDFInspector] album] logicalToPhysicalPage:[sender intValue]]];
//    [[self window] makeFirstResponder:[[self PDFInspector] album]];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= validateDisplayPDFPageFromField:
- (BOOL)validateDisplayPDFPageFromField:(id)sender;
/*"Description Forthcoming. The first responder must never be the window but at least its content view unless we want to neutralize the iTM2FlagsChangedResponder.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Jan 19 23:19:59 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	return([[[sender formatter] maximum] intValue] > 1);//?
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= takePDFNewPageModeFromTag:
- (IBAction)takePDFNewPageModeFromTag:(id <NSMenuItem>)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Jan 19 23:19:59 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self takeContextInteger:[sender tag] forKey:iTM2PDFNewPageModeKey domain:iTM2ContextAllDomainsMask];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= validateTakePDFNewPageModeFromTag:
- (BOOL)validateTakePDFNewPageModeFromTag:(id <NSMenuItem>)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Jan 19 23:19:59 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setState:([self contextIntegerForKey:iTM2PDFNewPageModeKey domain:iTM2ContextAllDomainsMask] == [sender tag]? NSOnState:NSOffState)];
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= takePDFPageLayoutModeFromTag:
- (IBAction)takePDFPageLayoutModeFromTag:(id <NSMenuItem>)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Jan 19 23:19:59 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self takeContextInteger:[sender tag] forKey:iTM2PDFPageLayoutModeKey domain:iTM2ContextAllDomainsMask];
    [[[self PDFInspector] album] setPageLayout:[sender tag]];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= validateTakePDFPageLayoutModeFromTag:
- (BOOL)validateTakePDFPageLayoutModeFromTag:(id <NSMenuItem>)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Jan 19 23:19:59 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setState:(([self contextIntegerForKey:iTM2PDFPageLayoutModeKey domain:iTM2ContextAllDomainsMask] == [sender tag])? NSOnState:NSOffState)];
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= togglePDFDisplayModeStick:
- (void)togglePDFDisplayModeStick:(id)sender;
/*"TogglePDFs the display mode between iTM2StickMode and iTM2LastMode.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Jan 19 23:19:59 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    switch([self contextIntegerForKey:iTM2PDFDisplayModeKey domain:iTM2ContextAllDomainsMask])
    {
        case iTM2PDFDisplayModeStick:
            [self takeContextInteger:iTM2PDFDisplayModeLast forKey:iTM2PDFDisplayModeKey domain:iTM2ContextAllDomainsMask];
            break;
        default:
            [self takeContextInteger:iTM2PDFDisplayModeStick forKey:iTM2PDFStickModeKey domain:iTM2ContextAllDomainsMask];
            [[[self PDFInspector] album] setMagnificationWithDisplayMode:[self contextIntegerForKey:iTM2PDFDisplayModeKey domain:iTM2ContextAllDomainsMask]
            stickMode: [self contextIntegerForKey:iTM2PDFStickModeKey domain:iTM2ContextAllDomainsMask]]; 
            break;
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateTogglePDFDisplayModeStick:
- (BOOL)validateTogglePDFDisplayModeStick:(id)anItem;
/*" Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Jan 19 23:19:59 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [anItem setState:([self contextIntegerForKey:iTM2PDFDisplayModeKey domain:iTM2ContextAllDomainsMask] == iTM2PDFDisplayModeStick?
            NSOnState: NSOffState)];
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=  takePDFStickModeFromTag:...
- (IBAction)takePDFStickModeFromTag:(id)sender
/*"Radio width|height|view. Sets the display mode to iTM2StickMode, sets the stick mode to iTM2StickToWidthMode,
then #{fixMagnification} of the album. The display is a side effect.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Jan 19 23:19:59 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self takeContextInteger:iTM2PDFDisplayModeStick forKey:iTM2PDFDisplayModeKey domain:iTM2ContextAllDomainsMask];
    [self takeContextInteger:[sender tag] forKey:iTM2PDFStickModeKey domain:iTM2ContextAllDomainsMask];
    [[[self PDFInspector] album] setMagnificationWithDisplayMode:[self contextIntegerForKey:iTM2PDFDisplayModeKey domain:iTM2ContextAllDomainsMask]
            stickMode: [self contextIntegerForKey:iTM2PDFStickModeKey domain:iTM2ContextAllDomainsMask]];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateTakePDFStickModeFromTag:
- (BOOL)validateTakePDFStickModeFromTag:(id)sender;
/*" Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Jan 19 23:19:59 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setState:(([self contextIntegerForKey:iTM2PDFStickModeKey domain:iTM2ContextAllDomainsMask] == [sender tag])?
                    NSOnState: NSOffState)];
    return [self contextIntegerForKey:iTM2PDFDisplayModeKey domain:iTM2ContextAllDomainsMask] == iTM2PDFDisplayModeStick;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=  takePDFDisplayOrientationFromTag:
- (IBAction)takePDFDisplayOrientationFromTag:(id)sender
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Jan 19 23:19:59 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	id album = [[self PDFInspector] album];
	if(album)
		[album setPDFOrientation:[sender tag]];
	else
	{
		int argument = [sender tag] % 3;
		if(argument == 3) argument = -1;
		int _OrientationMode = [self contextIntegerForKey:@"PDFOrientation" domain:iTM2ContextAllDomainsMask];
		if(argument != _OrientationMode)
		{
			[self takeContextInteger:argument forKey:@"PDFOrientation" domain:iTM2ContextAllDomainsMask];
		}
	}
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateTakePDFDisplayOrientationFromTag:
- (BOOL)validateTakePDFDisplayOrientationFromTag:(id)anItem;
/*" Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Jan 19 23:19:59 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [anItem setState:(([anItem tag] == [[[self PDFInspector] album] PDFOrientation])? NSOnState:NSOffState)];
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  togglePDFSlidesLandscapeMode:
- (void)togglePDFSlidesLandscapeMode:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon Jan 10 21:45:41 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    BOOL old = [self contextBoolForKey:iTM2PDFSlidesLandscapeModeKey domain:iTM2ContextAllDomainsMask];
    [self takeContextBool:!old forKey:iTM2PDFSlidesLandscapeModeKey domain:iTM2ContextAllDomainsMask];
    [[[self PDFInspector] album] setParametersHaveChanged:YES];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateTogglePDFSlidesLandscapeMode:
- (BOOL)validateTogglePDFSlidesLandscapeMode:(id <NSMenuItem>)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon Jan 10 21:45:41 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [sender setState:([self contextBoolForKey:iTM2PDFSlidesLandscapeModeKey domain:iTM2ContextAllDomainsMask]? NSOnState:NSOffState)];
	return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  autoZoom:
- (IBAction)autoZoom:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    BOOL old = [self contextBoolForKey:@"AutoScales" domain:iTM2ContextAllDomainsMask];
    [self takeContextBool:!old forKey:@"AutoScales" domain:iTM2ContextAllDomainsMask];
    [[[self PDFInspector] album] setParametersHaveChanged:YES];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateAutoZoom:
- (BOOL)validateAutoZoom:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[sender setState:([self contextBoolForKey:@"AutoScales" domain:iTM2ContextAllDomainsMask]? NSOnState:NSOffState)];
//iTM2_END;
    return YES;
}
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2Responders  
