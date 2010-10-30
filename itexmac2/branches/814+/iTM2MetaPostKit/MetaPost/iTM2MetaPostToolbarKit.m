/*
//  iTM2MetaPostToolbarKit.m
//  iTeXMac2
//
//  @version Subversion: $Id$ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Tue Sep 11 2005.
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

#import "iTM2MetaPostToolbarKit.h"
#import "iTM2MetaPostDocumentKit.h"
#import <objc/objc-runtime.h>

NSString * const iTM2MetaPostToolbarIdentifier = @"iTM2: MetaPost";


@interface iTM2MetaPostInspector(PRIVATE)
- (id)scaleAndPageTarget;
@end

@implementation iTM2MetaPostInspector(Toolbar)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setupToolbarWindowDidLoad4iTM3
- (void)setupToolbarWindowDidLoad4iTM3;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Thu Mar 11 07:26:41 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSToolbar * toolbar = [[NSToolbar alloc] initWithIdentifier:iTM2MetaPostToolbarIdentifier];
	NSString * key = [NSString stringWithFormat:@"NSToolbar Configuration %@", toolbar.identifier];
    NSDictionary * configDictionary = nil;
	if (![self context4iTM3BoolForKey:@"iTM2MetaPostToolbarShareConfiguration" domain:iTM2ContextAllDomainsMask]) {
		configDictionary = [self context4iTM3DictionaryForKey:key domain:iTM2ContextAllDomainsMask];
        [toolbar setConfigurationFromDictionary:configDictionary];
    }
    if (!toolbar.items.count) {
        configDictionary = [SUD dictionaryForKey:key];
        [toolbar setConfigurationFromDictionary:configDictionary];
        if (!toolbar.items.count) {
            [SUD removeObjectForKey:key];
            toolbar = [[[NSToolbar alloc] initWithIdentifier:iTM2MetaPostToolbarIdentifier] autorelease];
        }
    }
	[toolbar setAutosavesConfiguration:YES];
    [toolbar setAllowsUserCustomization:YES];
//    [toolbar setSizeMode:NSToolbarSizeModeSmall];
    toolbar.delegate = self;
    self.window.toolbar = toolbar;
//END4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleShareToolbarConfiguration:
- (void)toggleShareToolbarConfiguration:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Thu Mar 11 07:34:56 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	BOOL old = [self context4iTM3BoolForKey:@"iTM2MetaPostToolbarShareConfiguration" domain:iTM2ContextAllDomainsMask];
	[self takeContext4iTM3Bool: !old forKey:@"iTM2MetaPostToolbarShareConfiguration" domain:iTM2ContextAllDomainsMask];
	self.validateWindowContent4iTM3;
//END4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleShareToolbarConfiguration:
- (BOOL)validateToggleShareToolbarConfiguration:(NSButton *)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Thu Mar 11 07:38:10 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	sender.state = ([self context4iTM3BoolForKey:@"iTM2MetaPostToolbarShareConfiguration" domain:iTM2ContextAllDomainsMask]? NSOnState:NSOffState);
//END4iTM3;
	return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  prepareToolbarConfigurationCompleteSaveContext4iTM3:
- (void)prepareToolbarConfigurationCompleteSaveContext4iTM3:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Thu Mar 11 07:38:19 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSToolbar * toolbar = self.window.toolbar;
	NSString * key = [NSString stringWithFormat:@"NSToolbar Configuration %@", toolbar.identifier];
	[self takeContextValue:toolbar.configurationDictionary forKey:key domain:iTM2ContextAllDomainsMask];
//START4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toolbar:itemForItemIdentifier:willBeInsertedIntoToolbar:
- (NSToolbarItem *)toolbar:(NSToolbar *)toolbar itemForItemIdentifier:(NSString *)itemIdent willBeInsertedIntoToolbar:(BOOL)willBeInserted;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Thu Mar 11 07:39:14 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    // Required delegate method:  Given an item identifier, this method returns an item 
    // The toolbar will use this method to obtain toolbar items that can be displayed in the customization sheet, or in the toolbar itself 
    NSToolbarItem * TBI = nil;
	SEL action = NSSelectorFromString([itemIdent stringByAppendingString:@":"]);
	if(action == @selector(goBackForward:)) {
		if(willBeInserted && [IMPLEMENTATION metaValueForKey:@"toolbar back forward"])
			return nil;
		TBI = [NSToolbarItem seedToolbarItemWithIdentifier4iTM3:itemIdent forToolbarIdentifier:toolbar.identifier];
		TBI.view = self.toolbarBackForwardView;
		TBI.maxSize = TBI.minSize = self.toolbarBackForwardView.frame.size;
		self.toolbarBackForwardView.action = action;
		if(willBeInserted)
			[IMPLEMENTATION takeMetaValue:self.toolbarBackForwardView forKey:@"toolbar back forward"];
	} else if(action == @selector(takeToolModeFromSegment:)) {
		if(willBeInserted && [IMPLEMENTATION metaValueForKey:@"toolbar select tool mode"])
			return nil;
		TBI = [NSToolbarItem seedToolbarItemWithIdentifier4iTM3:itemIdent forToolbarIdentifier:toolbar.identifier];
		TBI.view = self.toolbarToolModeView;
		TBI.maxSize = TBI.minSize = self.toolbarToolModeView.frame.size;
		self.toolbarToolModeView.action = action;
		if(willBeInserted)
			[IMPLEMENTATION takeMetaValue:self.toolbarToolModeView forKey:@"toolbar select tool mode"];
	} else if(action == @selector(takeScaleFrom:)) {
		if(willBeInserted && [IMPLEMENTATION metaValueForKey:@"toolbar scale field"])
			return nil;
		NSTextField * F = [[[NSTextField alloc] initWithFrame:NSZeroRect] autorelease];
		F.action = action;
		F.target = nil;
		iTM2MagnificationFormatter * NF = [[[iTM2MagnificationFormatter alloc] init] autorelease];
		F.formatter = NF;
		F.delegate = NF;
		[F setFrameOrigin: NSMakePoint(4,6)];
		[F.cell setSendsActionOnEndEditing:NO];
		F.floatValue = willBeInserted?1:self.pdfView.scaleFactor;
		[F setFrameSize:NSMakeSize([[NF stringForObjectValue:[NSNumber numberWithFloat:F.floatValue]]
						sizeWithAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
								[F.cell font], NSFontAttributeName, nil]].width+8, 22)];
		F.tag = 421;
		TBI = [NSToolbarItem seedToolbarItemWithIdentifier4iTM3:itemIdent forToolbarIdentifier:toolbar.identifier];
		TBI.view = F;
		TBI.maxSize = TBI.minSize = F.frame.size;
		F.action = action;
		if(willBeInserted)
			[IMPLEMENTATION takeMetaValue:F forKey:@"toolbar scale field"];
	} else if(action == @selector(takePageFrom:)) {
		if(willBeInserted && [IMPLEMENTATION metaValueForKey:@"toolbar page field"])
			return nil;
		NSTextField * F = [[[NSTextField alloc] initWithFrame:NSZeroRect] autorelease];
		F.action = action;
		F.target = nil;
		iTM2NavigationFormatter * NF = [[[iTM2NavigationFormatter alloc] init] autorelease];
		[NF setMinimum:[NSDecimalNumber zero]];
		F.formatter = NF;
		F.delegate = NF;
		[F setFrameOrigin: NSMakePoint(4,6)];
		[F.cell setSendsActionOnEndEditing:NO];
		NSInteger maximum = 1000;
		[F setFrameSize:NSMakeSize([[NF stringForObjectValue:[NSNumber numberWithInteger:maximum]]
						sizeWithAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
								[F.cell font], NSFontAttributeName, nil]].width+8, 22)];
		if (willBeInserted) {
			PDFPage * page = self.pdfView.currentPage;
			PDFDocument * document = page.document;
			NSUInteger pageCount = [document indexForPage:page];
			F.integerValue = pageCount+1;
			pageCount = [document pageCount];
			[NF setMaximum:[NSNumber numberWithInteger:pageCount]];
		} else
			F.stringValue = @"421";
		F.tag = 421;
		TBI = [NSToolbarItem seedToolbarItemWithIdentifier4iTM3:itemIdent forToolbarIdentifier:toolbar.identifier];
		TBI.view = F;
		TBI.maxSize = TBI.minSize = F.frame.size;
		F.action = action;
		if(willBeInserted)
			[IMPLEMENTATION takeMetaValue:F forKey:@"toolbar page field"];
	} else if(action) {
		TBI = [NSToolbarItem seedToolbarItemWithIdentifier4iTM3:itemIdent forToolbarIdentifier:toolbar.identifier];
		TBI.action = action;
		TBI.target = nil;
	}
    #if 0
    if ([itemIdent isEqualToString:SaveDocToolbarItemIdentifier]) {
		TBI = [[[NSToolbarItem alloc] initWithItemIdentifier:itemIdent] autorelease];
		
			// Set the text label to be displayed in the toolbar and customization palette 
		TBI.label = @"Save";
		TBI.paletteLabel = @"Save";
		
		// Set up a reasonable tooltip, and image   Note, these aren't localized, but you will likely want to localize many of the item's properties 
		TBI.toolTip = @"Save Your Document";
		TBI.image = [NSImage cachedImageNamed4iTM3:@"SaveDocumentItemImage"];
		
		// Tell the item what message to send when it is clicked 
		TBI.target = self;
		TBI.action = @selector(saveDocument:);
    } else if([itemIdent isEqualToString:SearchDocToolbarItemIdentifier]) {
			// NSToolbarItem doens't normally autovalidate items that hold custom views, but we want this guy to be disabled when there is no text to search.
			TBI = [[[ValidatedViewToolbarItem alloc] initWithItemIdentifier:itemIdent] autorelease];

		NSMenu *submenu = nil;
		NSMenuItem *submenuItem = nil, *menuFormRep = nil;
		
		// Set up the standard properties 
		TBI.label = @"Search";
		TBI.paletteLabel = @"Search";
		TBI.toolTip = @"Search Your Document";
		
			searchFieldOutlet = [[NSSearchField alloc] initWithFrame:searchFieldOutlet.frame];
		// Use a custom view, a text field, for the search item 
		TBI.view = searchFieldOutlet;
		TBI.minSize = NSMakeSize(30, NSHeight(searchFieldOutlet.frame));
		TBI.maxSize = NSMakeSize(400,NSHeight(searchFieldOutlet.frame));

		// By default, in text only mode, a custom items label will be shown as disabled text, but you can provide a 
		// custom menu of your own by using <item> setMenuFormRepresentation] 
		submenu = [[[NSMenu alloc] init] autorelease];
		submenuItem = [[[NSMenuItem alloc] initWithTitle:@"Search Panel" action:@selector(searchUsingSearchPanel:) keyEquivalent:@""] autorelease];
		menuFormRep = [[[NSMenuItem alloc] init] autorelease];

		[submenu addItem:submenuItem];
		submenuItem.target = self;
		[menuFormRep setSubmenu:submenu];
		menuFormRep.title = TBI.label;

        // Normally, a menuFormRep with a submenu should just act like a pull down.  However, in 10.4 and later, the menuFormRep can have its own target / action.  If it does, on click and hold (or if the user clicks and drags down), the submenu will appear.  However, on just a click, the menuFormRep will fire its own action.
        menuFormRep.target = self;
        menuFormRep.action = @selector(searchMenuFormRepresentationClicked:);

        // Please note, from a user experience perspective, you wouldn't set up your search field and menuFormRep like we do here.  This is simply an example which shows you all of the features you could use.
		[TBI setMenuFormRepresentation:menuFormRep];
    } else {
		// itemIdent refered to a toolbar item that is not provide or supported by us or cocoa 
		// Returning nil will inform the toolbar this kind of item is not supported 
		TBI = nil;
    }
	#endif
	if (willBeInserted) {
		NSView * v = TBI.view;
		if (v) {
			[v setToolbarSizeMode4iTM3:toolbar.sizeMode];
			TBI.maxSize = TBI.minSize = v.frame.size;
		}
	}
//END4iTM3;
    return TBI;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toolbarDefaultItemIdentifiers:
- (NSArray *)toolbarDefaultItemIdentifiers:(NSToolbar *)toolbar;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Thu Mar 11 08:15:15 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    // Required delegate method:  Returns the ordered list of items to be shown in the toolbar by default    
    // If during the toolbar's initialization, no overriding values are found in the usermodel, or if the
    // user chooses to revert to the default items this set will be used 
//END4iTM3;
    return [NSArray arrayWithObjects:
				iTM2ToolbarToggleDrawerItemIdentifier,
				iTM2ToolbarTypesetItemIdentifier,
				iTM2ToolbarProjectTerminalItemIdentifier,
				iTM2ToolbarProjectSettingsItemIdentifier,
				iTM2ToolbarProjectFilesItemIdentifier,
				NSToolbarSeparatorItemIdentifier,
				iTM2ToolbarPreviousPageItemIdentifier,
				iTM2ToolbarNextPageItemIdentifier,
				iTM2ToolbarPageItemIdentifier,
//				iTM2ToolbarBackForwardItemIdentifier,
				NSToolbarSpaceItemIdentifier,
				iTM2ToolbarZoomInItemIdentifier,
				iTM2ToolbarZoomOutItemIdentifier,
				iTM2ToolbarScaleItemIdentifier,
				NSToolbarFlexibleSpaceItemIdentifier,
				iTM2ToolbarRotateLeftItemIdentifier,
				iTM2ToolbarRotateRightItemIdentifier,
//				iTM2ToolbarToolModeItemIdentifier,
					nil];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toolbarAllowedItemIdentifiers:
- (NSArray *)toolbarAllowedItemIdentifiers:(NSToolbar *)toolbar;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Thu Mar 11 08:15:20 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    // Required delegate method:  Returns the list of all allowed items by identifier.  By default, the toolbar 
    // does not assume any items are allowed, even the separator.  So, every allowed item must be explicitly listed   
    // The set of allowed items is used to construct the customization palette 
//END4iTM3;
    return [NSArray arrayWithObjects:
					iTM2ToolbarToggleDrawerItemIdentifier,
					iTM2ToolbarTypesetItemIdentifier,
					iTM2ToolbarProjectTerminalItemIdentifier,
					iTM2ToolbarProjectSettingsItemIdentifier,
					iTM2ToolbarProjectFilesItemIdentifier,
//					iTM2ToolbarBackForwardItemIdentifier,
					iTM2ToolbarPageItemIdentifier,
					iTM2ToolbarPreviousPageItemIdentifier,
					iTM2ToolbarNextPageItemIdentifier,
					iTM2ToolbarScaleItemIdentifier,
					iTM2ToolbarActualSizeItemIdentifier,
					iTM2ToolbarZoomInItemIdentifier,
					iTM2ToolbarZoomOutItemIdentifier,
					iTM2ToolbarDoZoomToSelectionItemIdentifier,
					iTM2ToolbarDoZoomToFitItemIdentifier,
					iTM2ToolbarRotateLeftItemIdentifier,
					iTM2ToolbarRotateRightItemIdentifier,
//					iTM2ToolbarToolModeItemIdentifier,
					NSToolbarSeparatorItemIdentifier,
					NSToolbarPrintItemIdentifier, 
					NSToolbarSpaceItemIdentifier,
					NSToolbarFlexibleSpaceItemIdentifier,
					NSToolbarCustomizeToolbarItemIdentifier,
//					NSToolbarShowColorsItemIdentifier,
//					NSToolbarShowFontsItemIdentifier,
							nil];
}
#if 0
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toolbarWillAddItem:
- (void)toolbarWillAddItem:(NSNotification *)notif;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Thu Mar 11 08:15:28 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    // Optional delegate method:  Before an new item is added to the toolbar, this notification is posted.
    // This is the best place to notice a new item is going into the toolbar.  For instance, if you need to 
    // cache a reference to the toolbar item or need to set up some initial state, this is the best place 
    // to do it.  The notification object is the toolbar to which the item is being added.  The item being 
    // added is found by referencing the @"item" key in the userInfo 
    NSToolbarItem *addedItem = [[notif userInfo] objectForKey:@"item"];
//END4iTM3;
    return;
}  
#endif
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toolbarDidRemoveItem:
- (void)toolbarDidRemoveItem:(NSNotification *)notif;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Thu Mar 11 08:15:33 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    // Optional delegate method:  Before an new item is added to the toolbar, this notification is posted.
    // This is the best place to notice a new item is going into the toolbar.  For instance, if you need to 
    // cache a reference to the toolbar item or need to set up some initial state, this is the best place 
    // to do it.  The notification object is the toolbar to which the item is being added.  The item being 
    // added is found by referencing the @"item" key in the userInfo 
    NSToolbarItem * removedItem = [[notif userInfo] objectForKey:@"item"];
	if ([[removedItem itemIdentifier] isEqualToString:iTM2ToolbarPageItemIdentifier]) {
		[IMPLEMENTATION takeMetaValue:nil forKey:@"toolbar page field"];
	}
//END4iTM3;
    return;
}  
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  rotateLeft:
- (IBAction)rotateLeft:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Thu Mar 11 08:15:50 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	self.pdfView.currentPage.rotation -= 90;
	[self.pdfView setNeedsDisplay:YES];
	self.validateWindowContent4iTM3;
//END4iTM3;
    return;
}  
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  rotateRight:
- (IBAction)rotateRight:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Thu Mar 11 08:20:04 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	self.pdfView.currentPage.rotation += 90;
	[self.pdfView setNeedsDisplay:YES];
	self.validateWindowContent4iTM3;
//END4iTM3;
    return;
}  
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takePageFrom:
- (IBAction)takePageFrom:(NSControl *)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Thu Mar 11 08:23:35 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSInteger n = MIN(MAX(1, sender.integerValue), self.outputFigureNumbers.count);
	if (n--) {
		self.currentOutputFigure = [self.outputFigureNumbers objectAtIndex:n];
		self.validateWindowContent4iTM3;
	}
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateTakePageFrom:
- (BOOL)validateTakePageFrom:(NSControl *)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Thu Mar 11 08:23:38 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if([sender.currentEditor isEqual:sender.window.firstResponder])
		return YES;
	NSInteger pageCount = self.outputFigureNumbers.count;
	NSNumberFormatter * NF = sender.formatter;
	NF.maximum = [NSNumber numberWithInteger:pageCount];
	pageCount = [self.outputFigureNumbers indexOfObject:self.currentOutputFigure];
	sender.integerValue = pageCount == NSNotFound?0:pageCount+1;
	NSSize oldSize = sender.frame.size;
	CGFloat width = 8 + MAX(
		([[NF stringForObjectValue:[NSNumber numberWithInteger:sender.integerValue]]
				sizeWithAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
							[sender.cell font], NSFontAttributeName, nil]].width),
		([[NF stringForObjectValue:[NSNumber numberWithInteger:99]]
				sizeWithAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
							[sender.cell font], NSFontAttributeName, nil]].width));
	[sender setFrameSize: NSMakeSize(width, oldSize.height)];
	for (NSToolbarItem * TBI in sender.window.toolbar.items) {
		if (sender == TBI.view) {
			TBI.maxSize = TBI.minSize = sender.frame.size;
			break;
		}
	}
//END4iTM3;
    return sender.integerValue > 0;
}  
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeScaleFrom:
- (IBAction)takeScaleFrom:(NSControl *)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Thu Mar 11 08:30:59 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	CGFloat newScale = sender.floatValue;
	if (newScale <= 0) newScale = 1;
    [(PDFView *)(self.scaleAndPageTarget?:self.pdfView) setScaleFactor:newScale];
	self.validateWindowContent4iTM3;
//END4iTM3;
    return;
}  
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateTakeScaleFrom:
- (BOOL)validateTakeScaleFrom:(NSControl *)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Thu Mar 11 08:32:45 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if([sender.currentEditor isEqual:sender.window.firstResponder])
		return YES;
	sender.floatValue = self.pdfView.scaleFactor;
	NSNumberFormatter * NF = sender.formatter;
	NSSize oldSize = sender.frame.size;
	CGFloat width = 8 + MAX(
			([[NF stringForObjectValue:[NSNumber numberWithFloat:sender.floatValue]]
				sizeWithAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
							[sender.cell font], NSFontAttributeName, nil]].width),
			([[NF stringForObjectValue:[NSNumber numberWithFloat:1]]
				sizeWithAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
							[sender.cell font], NSFontAttributeName, nil]].width));
	[sender setFrameSize: NSMakeSize(width, oldSize.height)];
	for (NSToolbarItem * TBI in sender.window.toolbar.items) {
		if (sender == TBI.view) {
			TBI.maxSize = TBI.minSize = sender.frame.size;
			break;
		}
	}
//END4iTM3;
    return YES;
}  
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeToolModeFromSegment:
- (IBAction)takeToolModeFromSegment:(NSSegmentedControl *)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Thu Mar 11 08:32:53 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	self.toolMode = [sender.cell tagForSegment:sender.selectedSegment];
	self.validateWindowContent4iTM3;
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateTakeToolModeFromSegment:
- (BOOL)validateTakeToolModeFromSegment:(NSSegmentedControl *)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Thu Mar 11 08:33:04 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (![sender selectSegmentWithTag:self.toolMode]) {
		[sender selectSegmentWithTag:self.toolMode = kiTM2ScrollToolMode];
	}
	NSInteger segment = sender.segmentCount;
	while (segment--) {
		[sender setEnabled: ([sender.cell tagForSegment:segment] != kiTM2AnnotateToolMode) forSegment:segment];
	}
	[sender setEnabled:YES];
//END4iTM3;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  scaleAndPageTarget
- (id)scaleAndPageTarget;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Thu Mar 11 08:39:14 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return [metaGETTER pointerValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setScaleAndPageTarget:
- (void)setScaleAndPageTarget:(id)argument;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
Latest Revision: Thu Mar 11 08:39:10 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if ([argument isEqual:self.pdfView] || [argument isEqual:self.textView])
		metaSETTER([NSValue valueWithPointer:argument]);
	return;
}
@end
