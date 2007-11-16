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
#pragma mark =-=-=-=-=-  TOOLBAR
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toolMode
- (iTM2ToolMode)toolMode;
{
	return [metaGETTER intValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setToolMode:
- (void)setToolMode:(iTM2ToolMode)argument;
{
	metaSETTER([NSNumber numberWithInt: (int)argument]);
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setupToolbarWindowDidLoad
- (void)setupToolbarWindowDidLoad;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue May  3 16:20:26 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSToolbar * toolbar = [[[NSToolbar alloc] initWithIdentifier:iTM2MetaPostToolbarIdentifier] autorelease];
	NSString * key = [NSString stringWithFormat:@"NSToolbar Configuration %@", [toolbar identifier]];
	if([self contextBoolForKey:@"iTM2MetaPostToolbarShareConfiguration" domain:iTM2ContextAllDomainsMask])
	{
		NSDictionary * configDictionary = [SUD dictionaryForKey:key];
		if([configDictionary count])
		{
			[toolbar setConfigurationFromDictionary:configDictionary];
			if(![[toolbar items] count])
			{
				[SUD removeObjectForKey:key];
				toolbar = [[[NSToolbar alloc] initWithIdentifier:iTM2MetaPostToolbarIdentifier] autorelease];
			}
		}
	}
	else
	{
		NSDictionary * configDictionary = [SUD dictionaryForKey:key];
//iTM2_LOG(@"configDictionary: %@", configDictionary);
		configDictionary = [self contextDictionaryForKey:key domain:iTM2ContextAllDomainsMask];
//iTM2_LOG(@"configDictionary: %@", configDictionary);
		if([configDictionary count])
			[toolbar setConfigurationFromDictionary:configDictionary];
		if(![[toolbar items] count])
		{
			configDictionary = [SUD dictionaryForKey:key];
//iTM2_LOG(@"configDictionary: %@", configDictionary);
			[self takeContextValue:nil forKey:key domain:iTM2ContextAllDomainsMask];
			if([configDictionary count])
				[toolbar setConfigurationFromDictionary:configDictionary];
			if(![[toolbar items] count])
			{
				[SUD removeObjectForKey:key];
				toolbar = [[[NSToolbar alloc] initWithIdentifier:iTM2MetaPostToolbarIdentifier] autorelease];
			}
		}
	}
	[toolbar setAutosavesConfiguration:YES];
    [toolbar setAllowsUserCustomization:YES];
//    [toolbar setSizeMode:NSToolbarSizeModeSmall];
    [toolbar setDelegate:self];
    [[self window] setToolbar:toolbar];
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toggleShareToolbarConfiguration:
- (void)toggleShareToolbarConfiguration:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue May  3 16:20:26 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	BOOL old = [self contextBoolForKey:@"iTM2MetaPostToolbarShareConfiguration" domain:iTM2ContextAllDomainsMask];
	[self takeContextBool: !old forKey:@"iTM2MetaPostToolbarShareConfiguration" domain:iTM2ContextAllDomainsMask];
	[self validateWindowContent];
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateToggleShareToolbarConfiguration:
- (BOOL)validateToggleShareToolbarConfiguration:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue May  3 16:20:26 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[sender setState: ([self contextBoolForKey:@"iTM2MetaPostToolbarShareConfiguration" domain:iTM2ContextAllDomainsMask]? NSOnState:NSOffState)];
//iTM2_END;
	return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  prepareToolbarConfigurationCompleteSaveContext:
- (void)prepareToolbarConfigurationCompleteSaveContext:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue May  3 16:20:26 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSToolbar * toolbar = [[self window] toolbar];
	NSString * key = [NSString stringWithFormat:@"NSToolbar Configuration %@", [toolbar identifier]];
	[self takeContextValue:[toolbar configurationDictionary] forKey:key domain:iTM2ContextAllDomainsMask];
//iTM2_START;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toolbar:itemForItemIdentifier:willBeInsertedIntoToolbar:
- (NSToolbarItem *)toolbar:(NSToolbar *)toolbar itemForItemIdentifier:(NSString *)itemIdent willBeInsertedIntoToolbar:(BOOL)willBeInserted;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue May  3 16:20:26 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    // Required delegate method:  Given an item identifier, this method returns an item 
    // The toolbar will use this method to obtain toolbar items that can be displayed in the customization sheet, or in the toolbar itself 
    NSToolbarItem * toolbarItem = nil;
	SEL action = NSSelectorFromString([itemIdent stringByAppendingString:@":"]);
	if(action == @selector(goBackForward:))
	{
		if(willBeInserted && [IMPLEMENTATION metaValueForKey:@"toolbar back forward"])
			return nil;
		NSControl * F = _toolbarBackForwardView;
		toolbarItem = [NSToolbarItem seedToolbarItemWithIdentifier:itemIdent forToolbarIdentifier:[toolbar identifier]];
		[toolbarItem setView:F];
		[toolbarItem setMinSize:[F frame].size];
		[toolbarItem setMaxSize:[F frame].size];
		[F setAction:action];
		if(willBeInserted)
			[IMPLEMENTATION takeMetaValue:F forKey:@"toolbar back forward"];
	}
	else if(action == @selector(takeToolModeFromSegment:))
	{
		if(willBeInserted && [IMPLEMENTATION metaValueForKey:@"toolbar select tool mode"])
			return nil;
		toolbarItem = toolbarItem = [NSToolbarItem seedToolbarItemWithIdentifier:itemIdent forToolbarIdentifier:[toolbar identifier]];
		NSControl * F = _toolbarToolModeView;
		[toolbarItem setView:F];
		[toolbarItem setMinSize:[F frame].size];
		[toolbarItem setMaxSize:[F frame].size];
		[F setAction:action];
		if(willBeInserted)
			[IMPLEMENTATION takeMetaValue:F forKey:@"toolbar select tool mode"];
	}
	else if(action == @selector(takeScaleFrom:))
	{
		if(willBeInserted && [IMPLEMENTATION metaValueForKey:@"toolbar scale field"])
			return nil;
		NSTextField * F = [[[NSTextField alloc] initWithFrame:NSZeroRect] autorelease];
		[F setAction:action];
		[F setTarget:nil];
		iTM2MagnificationFormatter * NF = [[[iTM2MagnificationFormatter allocWithZone:[self zone]] init] autorelease];
		[F setFormatter:NF];
		[F setDelegate:NF];
		[F setFrameOrigin:NSMakePoint(4,6)];
		[[F cell] setSendsActionOnEndEditing:NO];
		if(willBeInserted)
		{
			[F setFloatValue:1];
		}
		else
		{
			[F setFloatValue:[_pdfView scaleFactor]];
		}
		[F setFrameSize:NSMakeSize([[NF stringForObjectValue:[NSNumber numberWithFloat:[F floatValue]]]
						sizeWithAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
								[[F cell] font], NSFontAttributeName, nil]].width+8, 22)];
		[F setTag:421];
		toolbarItem = [NSToolbarItem seedToolbarItemWithIdentifier:itemIdent forToolbarIdentifier:[toolbar identifier]];
		[toolbarItem setView:F];
		[toolbarItem setMinSize:[F frame].size];
		[toolbarItem setMaxSize:[F frame].size];
		[F setAction:action];
		if(willBeInserted)
			[IMPLEMENTATION takeMetaValue:F forKey:@"toolbar scale field"];
	}
	else if(action == @selector(takePageFrom:))
	{
		if(willBeInserted && [IMPLEMENTATION metaValueForKey:@"toolbar page field"])
			return nil;
		NSTextField * F = [[[NSTextField alloc] initWithFrame:NSZeroRect] autorelease];
		[F setAction:action];
		[F setTarget:nil];
		iTM2NavigationFormatter * NF = [[[iTM2NavigationFormatter alloc] init] autorelease];
		[NF setMinimum:[NSDecimalNumber zero]];
		[F setFormatter:NF];
		[F setDelegate:NF];
		[F setFrameOrigin:NSMakePoint(4,6)];
		[[F cell] setSendsActionOnEndEditing:NO];
		int maximum = 1000;
		[F setFrameSize:NSMakeSize([[NF stringForObjectValue:[NSNumber numberWithInt:maximum]]
						sizeWithAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
								[[F cell] font], NSFontAttributeName, nil]].width+8, 22)];
		if(willBeInserted)
		{
			PDFPage * page = [_pdfView currentPage];
			PDFDocument * document = [page document];
			unsigned int pageCount = [document indexForPage:page];
			[F setIntValue:pageCount+1];
			pageCount = [document pageCount];
			[NF setMaximum:[NSNumber numberWithInt:pageCount]];
		}
		else
			[F setStringValue:@"421"];
		[F setTag:421];
		toolbarItem = [NSToolbarItem seedToolbarItemWithIdentifier:itemIdent forToolbarIdentifier:[toolbar identifier]];
		[toolbarItem setView:F];
		[toolbarItem setMinSize:[F frame].size];
		[toolbarItem setMaxSize:[F frame].size];
		[F setAction:action];
		if(willBeInserted)
			[IMPLEMENTATION takeMetaValue:F forKey:@"toolbar page field"];
	}
	else if(action)
	{
		toolbarItem = [NSToolbarItem seedToolbarItemWithIdentifier:itemIdent forToolbarIdentifier:[toolbar identifier]];
		[toolbarItem setAction:action];
		[toolbarItem setTarget:nil];
	}
    #if 0
    if ([itemIdent isEqualToString:SaveDocToolbarItemIdentifier])
	{
		toolbarItem = [[[NSToolbarItem alloc] initWithItemIdentifier:itemIdent] autorelease];
		
			// Set the text label to be displayed in the toolbar and customization palette 
		[toolbarItem setLabel:@"Save"];
		[toolbarItem setPaletteLabel:@"Save"];
		
		// Set up a reasonable tooltip, and image   Note, these aren't localized, but you will likely want to localize many of the item's properties 
		[toolbarItem setToolTip:@"Save Your Document"];
		[toolbarItem setImage:[NSImage iTM2_cachedImageNamed:@"SaveDocumentItemImage"]];
		
		// Tell the item what message to send when it is clicked 
		[toolbarItem setTarget:self];
		[toolbarItem setAction:@selector(saveDocument:)];
    }
	else if([itemIdent isEqualToString:SearchDocToolbarItemIdentifier])
	{
			// NSToolbarItem doens't normally autovalidate items that hold custom views, but we want this guy to be disabled when there is no text to search.
			toolbarItem = [[[ValidatedViewToolbarItem alloc] initWithItemIdentifier:itemIdent] autorelease];

		NSMenu *submenu = nil;
		NSMenuItem *submenuItem = nil, *menuFormRep = nil;
		
		// Set up the standard properties 
		[toolbarItem setLabel:@"Search"];
		[toolbarItem setPaletteLabel:@"Search"];
		[toolbarItem setToolTip:@"Search Your Document"];
		
			searchFieldOutlet = [[NSSearchField alloc] initWithFrame:[searchFieldOutlet frame]];
		// Use a custom view, a text field, for the search item 
		[toolbarItem setView:searchFieldOutlet];
		[toolbarItem setMinSize:NSMakeSize(30, NSHeight([searchFieldOutlet frame]))];
		[toolbarItem setMaxSize:NSMakeSize(400,NSHeight([searchFieldOutlet frame]))];

		// By default, in text only mode, a custom items label will be shown as disabled text, but you can provide a 
		// custom menu of your own by using <item> setMenuFormRepresentation] 
		submenu = [[[NSMenu alloc] init] autorelease];
		submenuItem = [[[NSMenuItem alloc] initWithTitle:@"Search Panel" action:@selector(searchUsingSearchPanel:) keyEquivalent:@""] autorelease];
		menuFormRep = [[[NSMenuItem alloc] init] autorelease];

		[submenu addItem:submenuItem];
		[submenuItem setTarget:self];
		[menuFormRep setSubmenu:submenu];
		[menuFormRep setTitle:[toolbarItem label]];

        // Normally, a menuFormRep with a submenu should just act like a pull down.  However, in 10.4 and later, the menuFormRep can have its own target / action.  If it does, on click and hold (or if the user clicks and drags down), the submenu will appear.  However, on just a click, the menuFormRep will fire its own action.
        [menuFormRep setTarget:self];
        [menuFormRep setAction:@selector(searchMenuFormRepresentationClicked:)];

        // Please note, from a user experience perspective, you wouldn't set up your search field and menuFormRep like we do here.  This is simply an example which shows you all of the features you could use.
		[toolbarItem setMenuFormRepresentation:menuFormRep];
    }
	else
	{
		// itemIdent refered to a toolbar item that is not provide or supported by us or cocoa 
		// Returning nil will inform the toolbar this kind of item is not supported 
		toolbarItem = nil;
    }
	#endif
	if(willBeInserted)
	{
		NSView * v = [toolbarItem view];
		if(v)
		{
			[v setToolbarSizeMode:[toolbar sizeMode]];
			[toolbarItem setMinSize:[v frame].size];
			[toolbarItem setMaxSize:[v frame].size];
		}
	}
//iTM2_END;
    return toolbarItem;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toolbarDefaultItemIdentifiers:
- (NSArray *)toolbarDefaultItemIdentifiers:(NSToolbar *)toolbar;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue May  3 16:20:26 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    // Required delegate method:  Returns the ordered list of items to be shown in the toolbar by default    
    // If during the toolbar's initialization, no overriding values are found in the usermodel, or if the
    // user chooses to revert to the default items this set will be used 
//iTM2_END;
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
- 2.0: Tue May  3 16:20:26 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    // Required delegate method:  Returns the list of all allowed items by identifier.  By default, the toolbar 
    // does not assume any items are allowed, even the separator.  So, every allowed item must be explicitly listed   
    // The set of allowed items is used to construct the customization palette 
//iTM2_END;
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
- 2.0: Tue May  3 16:20:26 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    // Optional delegate method:  Before an new item is added to the toolbar, this notification is posted.
    // This is the best place to notice a new item is going into the toolbar.  For instance, if you need to 
    // cache a reference to the toolbar item or need to set up some initial state, this is the best place 
    // to do it.  The notification object is the toolbar to which the item is being added.  The item being 
    // added is found by referencing the @"item" key in the userInfo 
    NSToolbarItem *addedItem = [[notif userInfo] objectForKey:@"item"];
//iTM2_END;
    return;
}  
#endif
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  toolbarDidRemoveItem:
- (void)toolbarDidRemoveItem:(NSNotification *)notif;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue May  3 16:20:26 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    // Optional delegate method:  Before an new item is added to the toolbar, this notification is posted.
    // This is the best place to notice a new item is going into the toolbar.  For instance, if you need to 
    // cache a reference to the toolbar item or need to set up some initial state, this is the best place 
    // to do it.  The notification object is the toolbar to which the item is being added.  The item being 
    // added is found by referencing the @"item" key in the userInfo 
    NSToolbarItem * removedItem = [[notif userInfo] objectForKey:@"item"];
	if([[removedItem itemIdentifier] isEqualToString:iTM2ToolbarPageItemIdentifier])
	{
		[IMPLEMENTATION takeMetaValue:nil forKey:@"toolbar page field"];
	}
//iTM2_END;
    return;
}  
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  rotateLeft:
- (IBAction)rotateLeft:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue May  3 16:20:26 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	PDFPage * currentPage = [_pdfView currentPage];
	int rotation = [currentPage rotation];
	rotation -= 90;
	[currentPage setRotation:rotation];
	[_pdfView setNeedsDisplay:YES];
	[self validateWindowContent];
//iTM2_END;
    return;
}  
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  rotateRight:
- (IBAction)rotateRight:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue May  3 16:20:26 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	PDFPage * currentPage = [_pdfView currentPage];
	int rotation = [currentPage rotation];
	rotation += 90;
	[currentPage setRotation:rotation];
	[_pdfView setNeedsDisplay:YES];
	[self validateWindowContent];
//iTM2_END;
    return;
}  
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takePageFrom:
- (IBAction)takePageFrom:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue May  3 16:20:26 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	int n = MIN(MAX(1, [sender intValue]), [[self outputFigureNumbers] count]);
	if(n--)
	{
		[self setCurrentOutputFigure:[[self outputFigureNumbers] objectAtIndex:n]];
		[self validateWindowContent];
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateTakePageFrom:
- (BOOL)validateTakePageFrom:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue May  3 16:20:26 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([[sender currentEditor] isEqual:[[sender window] firstResponder]])
		return YES;
	int pageCount = [[self outputFigureNumbers] count];
	NSNumberFormatter * NF = [sender formatter];
	[NF setMaximum:[NSNumber numberWithInt:pageCount]];
	pageCount = [[self outputFigureNumbers] indexOfObject:[self currentOutputFigure]];
	if(pageCount == NSNotFound)
	{
		[sender setIntValue:0];
	}
	else
	{
		[sender setIntValue:pageCount+1];
	}
	NSSize oldSize = [sender frame].size;
	float width = 8 + MAX(
		([[NF stringForObjectValue:[NSNumber numberWithInt:[sender intValue]]]
				sizeWithAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
							[[sender cell] font], NSFontAttributeName, nil]].width),
		([[NF stringForObjectValue:[NSNumber numberWithInt:99]]
				sizeWithAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
							[[sender cell] font], NSFontAttributeName, nil]].width));
	[sender setFrameSize:NSMakeSize(width, oldSize.height)];
	NSEnumerator * E = [[[[sender window] toolbar] items] objectEnumerator];
	NSToolbarItem * TBI;
	while(TBI = [E nextObject])
	{
		if(sender == [TBI view])
		{
			[TBI setMinSize:[sender frame].size];
			[TBI setMaxSize:[sender frame].size];
			break;
		}
	}
//iTM2_END;
    return [sender intValue] > 0;
}  
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeScaleFrom:
- (IBAction)takeScaleFrom:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue May  3 16:20:26 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	float newScale = [sender floatValue];
	if(newScale <= 0)
		newScale = 1;
    [([self scaleAndPageTarget]?:_pdfView) setScaleFactor:newScale];
	[self validateWindowContent];
//iTM2_END;
    return;
}  
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateTakeScaleFrom:
- (BOOL)validateTakeScaleFrom:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Tue May  3 16:20:26 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([[sender currentEditor] isEqual:[[sender window] firstResponder]])
		return YES;
	[sender setFloatValue:[_pdfView scaleFactor]];
	NSNumberFormatter * NF = [sender formatter];
	NSSize oldSize = [sender frame].size;
	float width = 8 + MAX(
			([[NF stringForObjectValue:[NSNumber numberWithFloat:[sender floatValue]]]
				sizeWithAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
							[[sender cell] font], NSFontAttributeName, nil]].width),
			([[NF stringForObjectValue:[NSNumber numberWithFloat:1]]
				sizeWithAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
							[[sender cell] font], NSFontAttributeName, nil]].width));
	[sender setFrameSize:NSMakeSize(width, oldSize.height)];
	NSEnumerator * E = [[[[sender window] toolbar] items] objectEnumerator];
	NSToolbarItem * TBI;
	while(TBI = [E nextObject])
	{
		if(sender == [TBI view])
		{
			[TBI setMinSize:[sender frame].size];
			[TBI setMaxSize:[sender frame].size];
			break;
		}
	}
//iTM2_END;
    return YES;
}  
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  takeToolModeFromSegment:
- (IBAction)takeToolModeFromSegment:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self setToolMode:[[sender cell] tagForSegment:[sender selectedSegment]]];
	[self validateWindowContent];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateTakeToolModeFromSegment:
- (BOOL)validateTakeToolModeFromSegment:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(![sender selectSegmentWithTag:[self toolMode]])
	{
		[self setToolMode:kiTM2ScrollToolMode];
		[sender selectSegmentWithTag:[self toolMode]];
	}
	int segment = [sender segmentCount];
	while(segment--)
	{
		[sender setEnabled: ([[sender cell] tagForSegment:segment] != kiTM2AnnotateToolMode) forSegment:segment];
	}
	[sender setEnabled:YES];
//iTM2_END;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  scaleAndPageTarget
- (id)scaleAndPageTarget;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return [metaGETTER pointerValue];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setScaleAndPageTarget:
- (void)setScaleAndPageTarget:(id)argument;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([argument isEqual:_pdfView] || [argument isEqual:[self textView]])
		metaSETTER([NSValue valueWithPointer:argument]);
	return;
}
@end
