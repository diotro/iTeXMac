/*
//  iTeXMac
//
//  @version Subversion: $Id$ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Mon Mar 04 2002.
//  Copyright (c) 2001 Laurens'Tribune. All rights reserved.
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

#import <Cocoa/Cocoa.h>
#import <PreferencePanes/PreferencePanes.h>
#import <iTM2Foundation/iTM2DocumentKit.h>
#import <iTM2Foundation/iTM2WindowKit.h>

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2PrefsController

@interface iTM2PrefsController: iTM2Inspector
/*"Class methods"*/
+ (id)sharedPrefsController;
- (void)displayPrefsPaneWithIdentifier:(NSString *)identifier;
@end

/*!
	@category		NSPreferencePane(iTeXMac2)
	@abstract		Abstract forthcoming.
	@discussion		When wrapping the preference pane in a .prePane bundle, you either link your pref pane against a framework
					or just use the standard user defaults keys.
					If you just want to use the keys without linking, your code must be well organized.
					It means that the parts of the code where the NSString constants are declared and defined must be available from different targets.
					If not, you will have to duplicate the definitions, which augments the risk of an error.
					One can use a trick to parse source code and header files for certain definitions and declarations,
					collect them in files inside the build directory, then use these files as standard source files for the target.
					This is tied to xcode organization, which is a weakness.
	@availability	iTM2.
	@copyright		2005 jlaurens AT users DOT sourceforge DOT net and others.
*/
@interface NSPreferencePane(iTeXMac2)

/*!
	@method			prefPaneIdentifierForBundle:
	@abstract		The Preference Pane identifier given a .prefPane bundle.
	@discussion		If the given bundle is a .prefPane bundle and is built according to Mac OS X guidelines,
					the preference pane identifier is the part of the bundle identifier following the word "prefPane".
					For example, if the bundle identifier is "comp.text.tex.iTeXMac2.prefPane.text.syntax",
					the preference pane identifier is just "text.syntax".
					These identifiers are used to organize the different pref panes and order their icon in the toolbar.
					A 0 length string is returned if the bundle is not a .prefPane bundle (or nil)
	@param			aBundle (description)
	@result			(description)
	@availability	iTM2.
	@copyright		2005 jlaurens AT users DOT sourceforge DOT net and others.
*/
+ (NSString*)prefPaneIdentifierForBundle:(NSBundle*)aBundle;

/*!
	@method			iconImageForBundle:
	@abstract		The icon for the given pref pane bundle.
	@discussion		If the given pref pane is not a pref pane bundle according to Mac OS X guidelines,
					nil is returned. Otherwise, the info comes from the info.plist file.
	@param			aBundle (description)
	@result			(description)
	@availability	iTM2.
	@copyright		2005 jlaurens AT users DOT sourceforge DOT net and others.
*/
+ (NSImage *)iconImageForBundle:(NSBundle *)aBundle;

/*!
	@method			iconLabelForBundle:
	@abstract		The icon label to appear in the toolbar.
	@discussion		If the given bundle is not a pref pane bundle according to Mac OS X guidelines, a 0 length label is returned.
	@param			aBundle (description)
	@result			(description)
	@availability	iTM2.
	@copyright		2005 jlaurens AT users DOT sourceforge DOT net and others.
*/
+ (NSString *)iconLabelForBundle:(NSBundle *)aBundle;

/*!
	@method			prefPaneIdentifier
	@abstract		The pref pane identifier.
	@discussion		It is expected that there is only one instance of a pref pane with a given pref pane identifier.
					The default implementation assumes that the pref pane has been wrapped into a pref pane bundle,
					and the result comes from the +prefPaneIdentifierForBundle: class method.
					If this is not the case, the pref pane identifier is just the class name,
					which is a poor man implementation that prevents name conflicts only in the application name space.
					Subclassers, are allowed to override this behaviour by returning the true identifier they want,
					this is usefull if the subclass is not wrapped into a pref pane bundle. 
	@param			None
	@result			(description)
	@availability	iTM2.
	@copyright		2005 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (NSString *)prefPaneIdentifier;

/*!
	@method			iconImage
	@abstract		The pref pane icon image to be displayed in the toolbar.
	@discussion		If the receiver was wrapped into a pref pane bundle built according to Mac OS X rules,
					it should contain an image. The default implementation retrieves this image with the class method
					+iconImageForBundle:
					If the preference pane was not shipped in a pref pane bundle,
					we look in the class bundle for an icon sharing the class name.
					A default icon is returned if everything failed.
					Subclassers can override this behaviour and return whatever they want.
	@param			None
	@result			(description)
	@availability	iTM2.
	@copyright		2005 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (NSImage *)iconImage;

/*!
	@method			iconLabel
	@abstract		The label of the toolbar item.
	@discussion		The default implementation forwards to the +iconLabelForBundle: class method.
					Standard label is returned if the receiver's bundle was built according to pref pane bundle rules.
					On the contrary, a localized string for key "NSPrefPaneIconLabel" in the table named as the receiver's class is used.
	@param			None
	@result			(description)
	@availability	iTM2.
	@copyright		2005 jlaurens AT users DOT sourceforge DOT net and others.
*/
- (NSString *)iconLabel;

@end

@interface iTM2PreferencePane: NSPreferencePane
{
@private
    id _Implementation;
}
@end

@interface iTM2PrefsWindow: iTM2Window
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2PrefsController
