/*
//  iTM2ToolbarKit.h
//  iTeXMac2
//
//  Created by jlaurens@users.sourceforge.net on Mon Jan 24 22:06:09 GMT 2005.
//  Copyright © 2005 Laurens'Tribune. All rights reserved.
//
//  This program is free software; you can redistribute it and/or modify it under the terms
//  of the GNU General Public License as published by the Free Software Foundation; either
//  version 2 of the License, or any later version.
//  This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
//  without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
//  See the GNU General Public License for more details. You should have received a copy
//  of the GNU General Public License along with this program; if not, write to the Free Software
//  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
//  GPL addendum: Any simple modification of the present code which purpose is to remove bug,
//  improve efficiency in both code execution and code reading or writing should be addressed
//  to the actual developper team.
*/


@interface iTM2ToolbarServer: NSObject
@end

@interface NSWindow(iTM2ToolbarKit)

/*! 
    @method 	toolbarIdentifier
    @abstract   The window's toolbar identifier.
    @discussion	The default implementation returns the receiver's window controller's toolbar identifier.
    @param		None
    @result		An identifier
*/
- (NSString *) toolbarIdentifier;

/*! 
    @method 	setToolbarIdentifier:
    @abstract   Set the window's toolbar identifier.
    @discussion	The default implementation forwards the message to the window controller.
    @param		An identifier
    @result		None
*/
- (void) setToolbarIdentifier: (NSString *) argument;

/*! 
    @method 	replaceToolbarIdentifier:
    @abstract   Replaces the window controller's toolbar identifier.
    @discussion	The default implementation sets the toolbar identifier to the new value,
				then changes its toolbar using the toolbar controller.
				This method should be used either directly or indirectly
				if we want the toolbar to be in sync with the desired settings.
    @param		An identifier
    @result		None
*/
- (void) replaceToolbarIdentifier: (NSString *) argument;

/*! 
    @method 	hasCustomToolbar
    @abstract   Whether the receiver has a custom toolbar.
    @discussion	All the windows with the same identifier are expected to share the same toolbar.
				If we want a per project toolbar (not as coarse as a per document toolbar), we add this flag.
				If the receiver has a custom toolbar, its value will be initialized from the context.
				If the receiver has not a custom toolbar, its value will be initialized from
				the standard user defaults data base as usual.
				The default implementation forwards the message to the window controller.
    @param		None
    @result		A flag
*/
- (BOOL) hasCustomToolbar;

/*! 
    @method 	setHasCustomToolbar:
    @abstract   Set the window's custom toolbar status.
    @discussion	The default implementation forwards the message to the window controller.
    @param		A flag
    @result		None
*/
- (void) setHasCustomToolbar: (BOOL) yorn;

@end

@interface NSWindowController(iTM2ToolbarKit)

/*! 
    @method 	toolbarIdentifier
    @abstract   The window controller's toolbar identifier.
    @discussion	The default implementation just returns the receiver's class name.
    @param		None
    @result		An identifier
*/
- (NSString *) toolbarIdentifier;

/*! 
    @method 	setToolbarIdentifier:
    @abstract   Set the window controller's toolbar identifier.
    @discussion	The default implementation does not store the toolbar identifier because
				NSWindowController does provide storage for that.
				Subclassers will override this method if they can provide some storage.
				This is a low level setter, you seldomly use it directly,
				instead, prefer the replaceToolbarIdentifier: method.
    @param		An identifier
    @result		None
*/
- (void) setToolbarIdentifier: (NSString *) argument;

/*! 
    @method 	replaceToolbarIdentifier:
    @abstract   Replaces the window controller's toolbar identifier.
    @discussion	The default implementation just forwards the message to its own window. 
    @param		An identifier
    @result		None
*/
- (void) replaceToolbarIdentifier: (NSString *) argument;

/*! 
    @method 	hasCustomToolbar
    @abstract   Whether the receiver has a custom toolbar.
    @discussion	All the windows with the same identifier are expected to share the same toolbar.
				If we want a per window toolbar, we add this flag.
				If the receiver has a custom toolbar, its value will be initialized from the context.
				If the receiver has not a custom toolbar, its value will be initialized from
				the standard user defaults data base as usual.
				The default implementation returns NO.
    @param		None
    @result		A flag
*/
- (BOOL) hasCustomToolbar;

/*! 
    @method 	setHasCustomToolbar:
    @abstract   Set the receiver's custom toolbar status.
    @discussion	The default implementation returns NO.
    @param		A flag
    @result		None
*/
- (void) setHasCustomToolbar: (BOOL) yorn;

@end

#define STC [iTM2ToolbarController sharedToolbarController]

#import <iTM2Foundation/iTM2InstallationKit.h>
#import <iTM2Foundation/iTM2Implementation.h>

/*! 
    @class	 	iTM2ToolbarController:
    @abstract   The toolbar controller.
    @discussion	The toolbar controller is asked to create and manage the toolbars.
				There is a hook point in the window controller's -windowDidLoad method
				where the toolbar controller is asked to install a toolbar in the window.
				If the toolbar controller finds a non void toolbar identifier, it will try to install the toolbar
*/
@interface iTM2ToolbarController: iTM2Object

/*! 
    @method 	sharedToolbarController:
    @abstract   The shared toolbar controller.
    @discussion	Description forthcoming.
    @param		A flag
    @result		None
*/
+ (void) sharedToolbarController;

/*! 
    @method 	setupToolbarInWindow:
    @abstract   Set the receiver's custom toolbar status.
    @discussion	The default implementation returns NO.
    @param		A flag
    @result		None
*/
- (void) setupToolbarInWindow: (NSWindow *) window;

@end

@interface NSToolbar(iTeXMac2_Window)
- (NSWindow *) window;
@end

#if 0
@interface NSWindowController(iTM2Toolbar)
+ (NSString *) windowToolbarIdentifier;
- (void) installWindowToolbar;
- (BOOL) allowsUserWindowToolbarCustomization;
- (NSToolbarDisplayMode) windowToolbarDisplayMode;
- (BOOL) autosavesWindowToolbarConfiguration;

+ (NSToolbarItem *)toolbar:(NSToolbar *)toolbar itemForItemIdentifier:(NSString *)itemIdentifier willBeInsertedIntoToolbar:(BOOL)flag;
    /* Required method.  Given an item identifier, this method returns an item.  Note that, it is expected that each toolbar receives its own distinct copies.   If the item has a custom view, that view should be in place when the item is returned.  Finally, do not assume the returned item is going to be added as an active item in the toolbar.  In fact, the toolbar may ask for items here in order to construct the customization palette (it makes copies of the returned items).  if willBeInsertedIntoToolbar is YES, the returned item will be inserted, and you can expect toolbarWillAddItem: is about to be posted.  */
    
+ (NSArray *)toolbarDefaultItemIdentifiers:(NSToolbar*)toolbar;
    /* Required method.  Returns the ordered list of items to be shown in the toolbar by default.   If during initialization, no overriding values are found in the user defaults, or if the user chooses to revert to the default items this set will be used. */

+ (NSArray *)toolbarAllowedItemIdentifiers:(NSToolbar*)toolbar;
    /* Required method.  Returns the list of all allowed items by identifier.  By default, the toolbar does not assume any items are allowed, even the separator.  So, every allowed item must be explicitly listed.  The set of allowed items is used to construct the customization palette.  The order of items does not necessarily guarantee the order of appearance in the palette.  At minimum, you should return the default item list.*/
#if MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_3
+ (NSArray *)toolbarSelectableItemIdentifiers:(NSToolbar *)toolbar;
    /* Optional method. Those wishing to indicate item selection in a toolbar should implement this method to return a non-empty array of selectable item identifiers.  If implemented, the toolbar will remember and display the selected item with a special highlight.  A selected item is one whose item identifier matches the current selected item identifier.  Clicking on an item whose identifier is selectable will automatically update the toolbars selected item identifier when possible. (see setSelectedItemIdentifier: for more details) */
#endif
+ (void)toolbarWillAddItem: (NSNotification *)notification;
    /* Before an new item is added to the toolbar, this notification is posted.  This is the best place to notice a new item is going into the toolbar.  For instance, if you need to cache a reference to the toolbar item or need to set up some initial state, this is the best place to do it.   The notification object is the toolbar to which the item is being added.  The item being added is found by referencing the @"item" key in the userInfo.  */

+ (void)toolbarDidRemoveItem: (NSNotification *)notification;
    /* After an item is removed from a toolbar the notification is sent.  This allows the chance to tear down information related to the item that may have been cached.  The notification object is the toolbar to which the item is being added.  The item being added is found by referencing the @"item" key in the userInfo.  */
- (NSToolbarItem *)toolbar:(NSToolbar *)toolbar itemForItemIdentifier:(NSString *)itemIdentifier willBeInsertedIntoToolbar:(BOOL)flag;
    /* Required method.  Given an item identifier, this method returns an item.  Note that, it is expected that each toolbar receives its own distinct copies.   If the item has a custom view, that view should be in place when the item is returned.  Finally, do not assume the returned item is going to be added as an active item in the toolbar.  In fact, the toolbar may ask for items here in order to construct the customization palette (it makes copies of the returned items).  if willBeInsertedIntoToolbar is YES, the returned item will be inserted, and you can expect toolbarWillAddItem: is about to be posted.  */
    
- (NSArray *)toolbarDefaultItemIdentifiers:(NSToolbar*)toolbar;
    /* Required method.  Returns the ordered list of items to be shown in the toolbar by default.   If during initialization, no overriding values are found in the user defaults, or if the user chooses to revert to the default items this set will be used. */

- (NSArray *)toolbarAllowedItemIdentifiers:(NSToolbar*)toolbar;
    /* Required method.  Returns the list of all allowed items by identifier.  By default, the toolbar does not assume any items are allowed, even the separator.  So, every allowed item must be explicitly listed.  The set of allowed items is used to construct the customization palette.  The order of items does not necessarily guarantee the order of appearance in the palette.  At minimum, you should return the default item list.*/
#if MAC_OS_X_VERSION_MAX_ALLOWED >= MAC_OS_X_VERSION_10_3
- (NSArray *)toolbarSelectableItemIdentifiers:(NSToolbar *)toolbar;
    /* Optional method. Those wishing to indicate item selection in a toolbar should implement this method to return a non-empty array of selectable item identifiers.  If implemented, the toolbar will remember and display the selected item with a special highlight.  A selected item is one whose item identifier matches the current selected item identifier.  Clicking on an item whose identifier is selectable will automatically update the toolbars selected item identifier when possible. (see setSelectedItemIdentifier: for more details) */
#endif
- (void)toolbarWillAddItem: (NSNotification *)notification;
    /* Before an new item is added to the toolbar, this notification is posted.  This is the best place to notice a new item is going into the toolbar.  For instance, if you need to cache a reference to the toolbar item or need to set up some initial state, this is the best place to do it.   The notification object is the toolbar to which the item is being added.  The item being added is found by referencing the @"item" key in the userInfo.  */

- (void)toolbarDidRemoveItem: (NSNotification *)notification;
    /* After an item is removed from a toolbar the notification is sent.  This allows the chance to tear down information related to the item that may have been cached.  The notification object is the toolbar to which the item is being added.  The item being added is found by referencing the @"item" key in the userInfo.  */
@end

#endif
