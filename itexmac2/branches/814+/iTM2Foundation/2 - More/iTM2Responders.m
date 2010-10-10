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

#import "iTM2Responders.h"

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2Responders  

#import "iTM2MenuKit.h"
#import "iTM2ContextKit.h"
#import "iTM2BundleKit.h"
#import "iTM2TextDocumentKit.h"
#import "iTM2PDFDocumentKit.h"
#import "iTM2ProjectDocumentKit.h"
#import "iTM2StringFormatKit.h"
#import "iTM2ResponderKit.h"
//#import "iTM2CompatibilityChecker.h"

#import "iTM2PDFViewKit.h"
#import "iTM2TextFieldKit.h"
#import "iTM2PathUtilities.h"
#import "iTM2InstallationKit.h"

@interface iTM2PDFResponder: iTM2AutoInstallResponder
- (iTM2PDFInspector *)PDFInspector;
@end

@implementation iTM2MainInstaller(Responders)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2PDFResponderCompleteDidFinishLaunching4iTM3
- (void)iTM2PDFResponderCompleteDidFinishLaunching4iTM3;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Fri Feb 20 13:19:00 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if ([NSApp targetForAction:@selector(displayPDFAtMagnification:)])
	{
		MILESTONE4iTM3((@"iTM2PDFResponder"),(@"No responder available for displayPDFAtMagnification:"));
	}
//END4iTM3;
	return;
}
@end

@implementation iTM2PDFResponder
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= PDFInspector
- (iTM2PDFInspector *)PDFInspector;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Jan 19 23:19:59 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    iTM2PDFInspector * PDFInspector = [[NSApp keyWindow] windowController];
    return [PDFInspector isKindOfClass:[iTM2PDFInspector class]]? PDFInspector:nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= contextManager
- (id)contextManager;
/*"TogglePDFs the display mode between iTM2StickMode and iTM2LastMode.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Jan 19 23:19:59 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [self.PDFInspector contextManager]?:(id)SUD;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= album
- (iTM2PDFAlbumView *)album;
/*"TogglePDFs the display mode between iTM2StickMode and iTM2LastMode.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Jan 19 23:19:59 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return self.PDFInspector.album;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  displayPDFAtMagnification:
- (void)displayPDFAtMagnification:(float)magnification;
/*"Description forthcoming. From the menu items
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Jan 19 23:19:59 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    self.PDFInspector.magnification = magnification;
    [self takeContextFloat:magnification forKey:iTM2PDFCurrentMagnificationKey domain:iTM2ContextAllDomainsMask];
    [self takeContextInteger:iTM2PDFDisplayModeLast forKey:iTM2PDFDisplayModeKey domain:iTM2ContextAllDomainsMask];
//END4iTM3;
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self takeContextInteger:iTM2PDFDisplayModeLast forKey:iTM2PDFDisplayModeKey domain:iTM2ContextAllDomainsMask];
	[self.album setMagnificationWithDisplayMode:iTM2PDFDisplayModeFixed stickMode:0];// unused stick mode
    [self takeContextFloat:self.album.magnification forKey:iTM2PDFCurrentMagnificationKey domain:iTM2ContextAllDomainsMask];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateDisplayPDFAtFixedSize:
- (BOOL)validateDisplayPDFAtFixedSize:(NSMenuItem *)anItem;
/*" This concerns only the magnification menu items of the PDF Display menu and the
corresponding ones in the popUp Fit button. Only takes into account the upper limit
of the magnification."*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	static NSString * atFixedSizeFormat = nil;
	if (!atFixedSizeFormat) {
		atFixedSizeFormat = anItem.title.copy;
	}
    float f = [self contextFloatForKey:iTM2PDFFixedMagnificationKey domain:iTM2ContextAllDomainsMask] * 100;
    anItem.title = [NSString stringWithFormat:atFixedSizeFormat, f];
    return (f > 0);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  displayPDFFitFromTag:...
- (IBAction)displayPDFFitFromTag:(NSMenuItem *)sender
/*"See #{displayFitToWidth}.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Jan 19 23:19:59 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self takeContextInteger:iTM2PDFDisplayModeLast forKey:iTM2PDFDisplayModeKey domain:iTM2ContextAllDomainsMask];
	[self.album setMagnificationWithDisplayMode:iTM2PDFDisplayModeStick stickMode:sender.tag];
    [self takeContextFloat:self.album.magnification forKey:iTM2PDFCurrentMagnificationKey domain:iTM2ContextAllDomainsMask];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  displayPDFAtMagnificationFromRepresentedObject:
- (IBAction)displayPDFAtMagnificationFromRepresentedObject:(NSMenuItem *)sender;
/*"Description forthcoming. From the menu items
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Jan 19 23:19:59 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (sender.representedObject) {
        [self takeContextInteger:iTM2PDFDisplayModeLast forKey:iTM2PDFDisplayModeKey domain:iTM2ContextAllDomainsMask];
        self.album.magnification = [sender.representedObject floatValue];
    } else {
        iTM2MagnificationFormatter * MF = [[[iTM2MagnificationFormatter alloc] init] autorelease];
        NSDecimalNumber * number;
        if ([MF getObjectValue:&number forString:sender.title errorDescription:nil]) {
            [self takeContextInteger:iTM2PDFDisplayModeLast forKey:iTM2PDFDisplayModeKey domain:iTM2ContextAllDomainsMask];
            self.album.magnification = number.floatValue;
        } else {
            sender.action = NULL;
            NSLog(@"Unexpected sender(action): %@", sender);
        }
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  displayPDFAtMagnificationFromStepper:
- (IBAction)displayPDFAtMagnificationFromStepper:(NSControl *)sender;
/*"Zoom In or Zoom Out.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Jan 19 23:19:59 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (sender.integerValue > 0) {
        [self.PDFInspector doZoomIn:sender];
    } else {
        [self.PDFInspector doZoomOut:sender];
    }
    sender.integerValue = 0;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  displayPDFAtMagnificationFromField:
- (IBAction)displayPDFAtMagnificationFromField:(NSTextField *)sender;
/*"Display mode is set to iTM2LastMode.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Jan 19 23:19:59 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    self.PDFInspector.magnification = [sender.objectValue floatValue];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateMenuItem:
- (BOOL)validateMenuItem:(id)anItem;
/*" This concerns only the magnification menu items of the PDF Display menu and the
corresponding ones in the popUp Fit button. Only takes into account the upper limit
of the magnification."*/
{DIAGNOSTIC4iTM3;
    return [super validateMenuItem:(id) anItem] && (self.album.imageRepresentation != nil);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= displayPDFPhysicalPageNumber:
- (void)displayPDFPhysicalPageNumber:(NSInteger)pageNumber;
/*"Description Forthcoming. The first responder must never be the window but at least its content view unless we want to neutralize the iTM2FlagsChangedResponder.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Jan 19 23:19:59 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//NSLog(@"dpn");
    self.album.currentPhysicalPage = pageNumber;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= displayPDFPageFromTag:
- (IBAction)displayPDFPageFromTag:(NSMenuItem *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Jan 19 23:19:59 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    self.album.currentPhysicalPage = [self.album logicalToPhysicalPage:sender.tag];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= validateDisplayPDFPageFromTag:
- (BOOL)validateDisplayPDFPageFromTag:(NSMenuItem *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Jan 19 23:19:59 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	return self.album.imageRepresentation && self.album.currentPhysicalPage < self.album.lastPhysicalPage;//add a page number check
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= displayPDFPageFromRepresentedObject:
- (IBAction)displayPDFPageFromRepresentedObject:(NSMenuItem *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Jan 19 23:19:59 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    self.album.currentPhysicalPage = [self.album logicalToPhysicalPage:[sender.representedObject integerValue]];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= validateDisplayPDFPageFromRepresentedObject:
- (BOOL)validateDisplayPDFPageFromRepresentedObject:(NSMenuItem *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Jan 19 23:19:59 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return self.album != nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= displayPDFPageFromField:
- (IBAction)displayPDFPageFromField:(NSTextField *)sender;
/*"Description Forthcoming. The first responder must never be the window but at least its content view unless we want to neutralize the iTM2FlagsChangedResponder.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Jan 19 23:19:59 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    self.album.currentPhysicalPage = [self.album logicalToPhysicalPage:sender.integerValue];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= validateDisplayPDFPageFromField:
- (BOOL)validateDisplayPDFPageFromField:(NSTextField *)sender;
/*"Description Forthcoming. The first responder must never be the window but at least its content view unless we want to neutralize the iTM2FlagsChangedResponder.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Jan 19 23:19:59 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	return([[sender.formatter maximum] integerValue] > 1);//?
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= takePDFNewPageModeFromTag:
- (IBAction)takePDFNewPageModeFromTag:(NSMenuItem *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Jan 19 23:19:59 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self takeContextInteger:sender.tag forKey:iTM2PDFNewPageModeKey domain:iTM2ContextAllDomainsMask];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= validateTakePDFNewPageModeFromTag:
- (BOOL)validateTakePDFNewPageModeFromTag:(NSMenuItem *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Jan 19 23:19:59 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    sender.state = [self contextIntegerForKey:iTM2PDFNewPageModeKey domain:iTM2ContextAllDomainsMask] == sender.tag? NSOnState:NSOffState;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= takePDFPageLayoutModeFromTag:
- (IBAction)takePDFPageLayoutModeFromTag:(NSMenuItem *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Jan 19 23:19:59 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self takeContextInteger:sender.tag forKey:iTM2PDFPageLayoutModeKey domain:iTM2ContextAllDomainsMask];
    self.album.pageLayout = sender.tag;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= validateTakePDFPageLayoutModeFromTag:
- (BOOL)validateTakePDFPageLayoutModeFromTag:(NSMenuItem *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Jan 19 23:19:59 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    sender.state = [self contextIntegerForKey:iTM2PDFPageLayoutModeKey domain:iTM2ContextAllDomainsMask] == sender.tag? NSOnState:NSOffState;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= togglePDFDisplayModeStick:
- (void)togglePDFDisplayModeStick:(id)sender;
/*"TogglePDFs the display mode between iTM2StickMode and iTM2LastMode.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Jan 19 23:19:59 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    switch([self contextIntegerForKey:iTM2PDFDisplayModeKey domain:iTM2ContextAllDomainsMask])
    {
        case iTM2PDFDisplayModeStick:
            [self takeContextInteger:iTM2PDFDisplayModeLast forKey:iTM2PDFDisplayModeKey domain:iTM2ContextAllDomainsMask];
            break;
        default:
            [self takeContextInteger:iTM2PDFDisplayModeStick forKey:iTM2PDFStickModeKey domain:iTM2ContextAllDomainsMask];
            [self.album setMagnificationWithDisplayMode:[self contextIntegerForKey:iTM2PDFDisplayModeKey domain:iTM2ContextAllDomainsMask]
                stickMode: [self contextIntegerForKey:iTM2PDFStickModeKey domain:iTM2ContextAllDomainsMask]]; 
            break;
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateTogglePDFDisplayModeStick:
- (BOOL)validateTogglePDFDisplayModeStick:(NSMenuItem *)anItem;
/*" Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Jan 19 23:19:59 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    anItem.state = [self contextIntegerForKey:iTM2PDFDisplayModeKey domain:iTM2ContextAllDomainsMask] == iTM2PDFDisplayModeStick?
            NSOnState: NSOffState;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=  takePDFStickModeFromTag:...
- (IBAction)takePDFStickModeFromTag:(NSMenuItem *)sender
/*"Radio width|height|view. Sets the display mode to iTM2StickMode, sets the stick mode to iTM2StickToWidthMode,
then #{fixMagnification} of the album. The display is a side effect.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Jan 19 23:19:59 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self takeContextInteger:iTM2PDFDisplayModeStick forKey:iTM2PDFDisplayModeKey domain:iTM2ContextAllDomainsMask];
    [self takeContextInteger:sender.tag forKey:iTM2PDFStickModeKey domain:iTM2ContextAllDomainsMask];
    [self.album setMagnificationWithDisplayMode:[self contextIntegerForKey:iTM2PDFDisplayModeKey domain:iTM2ContextAllDomainsMask]
            stickMode: [self contextIntegerForKey:iTM2PDFStickModeKey domain:iTM2ContextAllDomainsMask]];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateTakePDFStickModeFromTag:
- (BOOL)validateTakePDFStickModeFromTag:(NSMenuItem *)sender;
/*" Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Jan 19 23:19:59 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    sender.state = [self contextIntegerForKey:iTM2PDFStickModeKey domain:iTM2ContextAllDomainsMask] == sender.tag? NSOnState: NSOffState;
    return [self contextIntegerForKey:iTM2PDFDisplayModeKey domain:iTM2ContextAllDomainsMask] == iTM2PDFDisplayModeStick;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=  takePDFDisplayOrientationFromTag:
- (IBAction)takePDFDisplayOrientationFromTag:(NSMenuItem *)sender
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Jan 19 23:19:59 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (self.album) {
		self.album.PDFOrientation = sender.tag;
	} else {
		NSInteger argument = sender.tag % 3;
		if (argument == 3) argument = -1;
		NSInteger _OrientationMode = [self contextIntegerForKey:@"PDFOrientation" domain:iTM2ContextAllDomainsMask];
		if (argument != _OrientationMode) {
			[self takeContextInteger:argument forKey:@"PDFOrientation" domain:iTM2ContextAllDomainsMask];
		}
	}
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateTakePDFDisplayOrientationFromTag:
- (BOOL)validateTakePDFDisplayOrientationFromTag:(NSMenuItem *)anItem;
/*" Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Wed Jan 19 23:19:59 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    anItem.state = anItem.tag == [self.album PDFOrientation]? NSOnState:NSOffState;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  togglePDFSlidesLandscapeMode:
- (void)togglePDFSlidesLandscapeMode:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon Jan 10 21:45:41 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    BOOL old = [self contextBoolForKey:iTM2PDFSlidesLandscapeModeKey domain:iTM2ContextAllDomainsMask];
    [self takeContextBool:!old forKey:iTM2PDFSlidesLandscapeModeKey domain:iTM2ContextAllDomainsMask];
    self.album.parametersHaveChanged = YES;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateTogglePDFSlidesLandscapeMode:
- (BOOL)validateTogglePDFSlidesLandscapeMode:(NSMenuItem *)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon Jan 10 21:45:41 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    sender.state = [self contextBoolForKey:iTM2PDFSlidesLandscapeModeKey domain:iTM2ContextAllDomainsMask]? NSOnState:NSOffState;
	return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  autoZoom:
- (IBAction)autoZoom:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    BOOL old = [self contextBoolForKey:@"AutoScales" domain:iTM2ContextAllDomainsMask];
    [self takeContextBool:!old forKey:@"AutoScales" domain:iTM2ContextAllDomainsMask];
    self.album.parametersHaveChanged = YES;
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateAutoZoom:
- (BOOL)validateAutoZoom:(NSMenuItem *)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	sender.state = [self contextBoolForKey:@"AutoScales" domain:iTM2ContextAllDomainsMask]? NSOnState:NSOffState;
//END4iTM3;
    return YES;
}
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2Responders  
