/*
//
//  @version Subversion: $Id$ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Mon May 17 13:54:52 GMT 2004.
//  Copyright © 2003 Laurens'Tribune. All rights reserved.
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

extern NSString * const iTM2FontPanelWillOrderFrontNotification;
extern NSString * const iTM2PrintInfoDidChangeNotification;

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2ResponderKit

@interface iTeXMac2Responder: NSResponder

- (IBAction)checkForUpdate:(id)sender;

@end

@interface NSSavePanel(iTM2MiscKit)

- (void)pushNavLastRootDirectory;
- (void)popNavLastRootDirectory;

@end

@interface NSImage(iTM2MiscKit)

+ (NSImage *)findImageNamed:(NSString *)name;

@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2ResponderKit

extern NSString * const iTM2ToolbarToggleDrawerItemIdentifier;

/*!
    @defined	iTM2_DEFINE_TOOLBAR_ITEM(SELECTOR, BUNDLE)
    @abstract   (description)
    @discussion Use this #define'd fonction in your custom NSToolbarItem category
*/
#define iTM2_DEFINE_TOOLBAR_ITEM(SELECTOR, BUNDLE)\
+ (NSToolbarItem *)SELECTOR;{return [self toolbarItemWithIdentifier:[self identifierFromSelector:_cmd] inBundle:BUNDLE];}

@interface NSToolbarItem(iTM2MiscKit)

/*!
	@method			seedToolbarItemWithIdentifier:
	@abstract		Abstract forthcoming.
	@discussion		You are expected to use this constructor when a toolbar asks you for an item.
					A unique copy is returned.
	@result			an item.
	@availability	iTM2.
	@copyright		2005 jlaurens AT users DOT sourceforge DOT net and others.
*/
+ (NSToolbarItem *)seedToolbarItemWithIdentifier:(NSString *)anIdentifier forToolbarIdentifier:(NSString *)anotherIdentifier;

+ (NSString *)identifierFromSelector:(SEL)aSelector;
+ (SEL)selectorFromIdentifier:(NSString *)anIdentifier;
+ (NSToolbarItem *)toolbarItemWithIdentifier:(NSString *)anIdentifier inBundle:(NSBundle *)bundle;

+ (NSToolbarItem *)toggleDrawerToolbarItem;

- (void)setToolbarSizeMode:(NSToolbarSizeMode)sizeMode;

@end

@interface NSView(iTM2MiscKit)
- (void)setToolbarSizeMode:(NSToolbarSizeMode)sizeMode;
@end

/*!
	@class			iTM2ValueTransformer
	@abstract		Abstract forthcoming.
	@discussion		Automagically regisytered.
	@availability	iTM2.
	@copyright		2005 jlaurens AT users DOT sourceforge DOT net and others.
*/
@interface iTM2ValueTransformer: NSValueTransformer
+ (NSString *)transformerName;
@end

