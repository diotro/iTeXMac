/*
//
//  @version Subversion: $Id$ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Mon Sep 24 2001.
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

#import <iTM2Foundation/iTM2HelpKit.h>
#import <iTM2Foundation/iTM2StringKit.h>
#import <iTM2Foundation/iTM2BundleKit.h>
#import <Carbon/Carbon.h>

NSString * const iTM2ToolbarShowHelpItemIdentifier = @"showHelp:";
NSString * const iTeXMac2HelpBookName = @"iTeXMac2 Help";

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2HelpKit
/*"Description forthcoming."*/
@implementation iTM2HelpManager
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= buttonHelp
+(iTM2ButtonHelp *)buttonHelp;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/02/2001)
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    iTM2ButtonHelp * buttonHelp = [[[iTM2ButtonHelp alloc] initWithFrame:NSZeroRect] autorelease];
    [buttonHelp setAction:@selector(showHelp:)];
    [buttonHelp setTarget:self];
    return buttonHelp;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= helpToolbarItem
+(id)helpToolbarItem;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/02/2001)
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSToolbarItem * result = [[[NSToolbarItem alloc] initWithItemIdentifier:iTM2ToolbarShowHelpItemIdentifier] autorelease];
    [result setView:[self buttonHelp]];
    [result setMinSize:[[result view] frame].size];
    [result setMaxSize:[[result view] frame].size];
    [result setToolTip:NSLocalizedStringFromTableInBundle(iTM2ToolbarShowHelpItemIdentifier, @"Basic",
        [self classBundle], nil)];
    [result setPaletteLabel:NSLocalizedStringFromTableInBundle(iTM2ToolbarShowHelpItemIdentifier, @"Basic",
        [self classBundle], nil)];
    [result setLabel:NSLocalizedStringFromTableInBundle(iTM2ToolbarShowHelpItemIdentifier, @"Basic",
        [self classBundle], nil)];
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= showHelp:
+(void)showHelp:(id)sender;
/*"When the receiver is in a palette, it should always be valid. Its target should be itself. Forwards the message to NSApp.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: implement a sender specific Help
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [NSApp showHelp:self];
    return;
}
#if 1
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= showHelp:anchor:
+(void)showHelp:(id)object anchor:(NSString *)anchor;
/*"Public method: you give a key and the help controller manages all the stuff in order to show the help
related to the key. It manages localization...
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    OSStatus status = AHGotoPage(
        (CFStringRef)[iTeXMac2HelpBookName stringWithSubstring:@" " replacedByString:@"%20"],
        (CFStringRef)[object stringWithSubstring:@" " replacedByString:@"%20"],
        (CFStringRef)[anchor stringWithSubstring:@" " replacedByString:@"%20"]);
    if(status)
        NSLog(@"There was an error: %u", status);
    return;
}
#endif
@end

#import <iTM2Foundation/iTM2ResponderKit.h>
#import <iTM2Foundation/iTM2InstallationKit.h>
#import <iTM2Foundation/iTM2Implementation.h>

NSString * const iTM2ReportBugURLKey = @"iTM2:ReportBugURL";
NSString * const iTM2MailForHelpURLKey = @"iTM2:MailForHelpURL";
NSString * const iTM2RequestFeatureURLKey = @"iTM2:RequestFeatureURL";

@implementation iTM2HelpResponder
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initialize
+(void)initialize;
/*"initialize.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: implement a sender specific Help
"*/
{iTM2_DIAGNOSTIC;
	iTM2_INIT_POOL;
//iTM2_START;
	[super initialize];
	[SUD registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:
				@"https://sourceforge.net/tracker/?group_id=58056&atid=486369", iTM2ReportBugURLKey,
				@"mailto:itexmac-help@lists.sourceforge.net?subject=iTeXMac2", iTM2MailForHelpURLKey,
				@"https://sourceforge.net/tracker/?atid=486372&group_id=58056&func=browse", iTM2RequestFeatureURLKey,
							nil]];
//iTM2_END;
	iTM2_RELEASE_POOL;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  showLaTeXHelp:
-(IBAction)showLaTeXHelp:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [[NSWorkspace sharedWorkspace] openURL:[[[NSURL alloc] initWithString:
        [NSString stringWithFormat:@"help:openbook=%@",
            NSLocalizedStringFromTableInBundle(@"iTM2LaTeXHelpBook", @"HelpBooks",
                [self classBundle], "Name")]] autorelease]];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  showTeXCatalogueOnLine:
-(IBAction)showTeXCatalogueOnLine:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [[NSWorkspace sharedWorkspace] openURL:[[[NSURL alloc] initWithString:
        [NSString stringWithFormat:@"help:openbook=%@",
            NSLocalizedStringFromTableInBundle(@"iTM2TeXCatalogueOnLineBook", @"HelpBooks",
                [self classBundle], "Name")]] autorelease]];
    return;
}
#if 1
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  showLocaleHelp:
-(IBAction)showLocaleHelp:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.2: 09/03/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [NSApp showHelp:self];
    return;
}
#endif
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  mailForHelp:
-(IBAction)mailForHelp:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:
        [[NSUserDefaults standardUserDefaults] stringForKey:iTM2MailForHelpURLKey]]];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  reportBug:
-(IBAction)reportBug:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:
        [[NSUserDefaults standardUserDefaults] stringForKey:iTM2ReportBugURLKey]]];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  requestFeature:
-(IBAction)requestFeature:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:
        [[NSUserDefaults standardUserDefaults] stringForKey:iTM2RequestFeatureURLKey]]];
    return;
}
@end

#import <iTM2Foundation/iTM2ButtonKit.h>

#define dIsLargeButtonSize NO

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2ButtonHelp
/*"Description forthcoming."*/
@implementation iTM2ButtonHelp
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  initWithFrame:
-(id)initWithFrame:(NSRect)irrelevant;
/*"No target set here.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(self = [super initWithFrame:NSMakeRect(0,0,32,32)])
    {
        [[self cell] setBezelStyle:NSCircularBezelStyle];
        #if 0
        if(dIsLargeButtonSize)
            [[self cell] setControlSize:NSRegularControlSize];
        else
        #endif
            [[self cell] setControlSize:NSSmallControlSize];
        [[self cell] setHighlightsBy:NSChangeGrayCellMask];//[NSContentsCellMask];
        [self setAction:@selector(showHelp:)];
        [self setTarget:self];
        [self fixImage];
        [self setBordered:YES];
    }
    return self;
}
#if 0
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  initWithCoder:
-(id)initWithCoder:(NSCoder *)aDecoder;
/*"No target set here.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(self = [super initWithCoder:aDecoder])
    {
        NSLog(NSStringFromRect([self frame]));
        NSLog(@"isTransparent: %@", ([self isTransparent]? @"Y":@"N"));
        NSLog(@"isBordered: %@", ([self isBordered]? @"Y":@"N"));
        NSLog(@"allowsMixedState: %@", ([self allowsMixedState]? @"Y":@"N"));
        NSLog(@"bezelStyle: %i", [self bezelStyle]);
        NSLog(@"imagePosition: %i", [self imagePosition]);
        NSLog(@"highlightsBy: %i", [[self cell] highlightsBy]);
        NSLog(@"showsStateBy: %i", [[self cell] showsStateBy]);
    }
    return self;
}
#endif
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  awakeFromNib
-(void)awakeFromNib;
/*"No target set here.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.3: 13/12/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if([[self superclass] instancesRespondToSelector:_cmd])
        [super awakeFromNib];
    [self fixImage];
//NSLog(@"%@ 0x%x DONE", __PRETTY_FUNCTION__, self);
    return;
}
#if 0
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= drawRect:
-(void)drawRect:(NSRect)aRect;
/*"Draws a button (inherited method), then draws a question mark.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    float alpha = [self isEnabled]? 0.66:0.4;
    float fontSize = dIsLargeButtonSize? 20:14;
    NSString * QM = @"?";
    NSSize size;
    NSFont * font = [NSFont fontWithName:@"Times-Bold" size:18];
    if(!font) font = [NSFont boldSystemFontOfSize:fontSize];
    NSDictionary * attributes = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName,
                    [[NSColor blackColor] colorWithAlphaComponent:alpha], NSForegroundColorAttributeName, nil];
    size = [QM sizeWithAttributes:attributes];
    [super drawRect:aRect];
    [QM drawAtPoint:NSMakePoint(NSMidX([self bounds])-size.width/2, NSMidY([self bounds])-size.height/2-2)
        withAttributes: attributes];
    return;
}
#endif
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= showHelp:
-(void)showHelp:(id)sender;
/*"When the receiver is in a palette, it should always be valid. Its target should be itself. Does nothing.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: IS IT RELEVANT?
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= description
-(NSString *)description;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [NSString stringWithFormat:@"<%@ %@>", [super description], NSStringFromSelector([self action])];
}
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2HelpKit

