/*
//
//  @version Subversion: $Id: iTM2MacroKit.h 494 2007-05-11 06:22:21Z jlaurens $ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Thu Feb 21 2002.
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

extern NSString * const iTM2TextPlaceholderMark;

extern NSString * const iTM2TextNumberOfSpacesPerTabKey;

extern NSString * const iTM2MacroControllerComponent;

/*!
	@header			iTM2MacroKit
	@abstract		Abstract forthcoming.
	@discussion		Consider this technology as experimental (to be improved and possibly deprecated in a near future), do not use it.
					This is the new architecture of macros.
					First let us define what are Macros and key bindings.
					Macros are just actions: make something or that.
					A macro can be some text to be inserted, or some action to be performed.
					A key binding is a link between a key or key sequence and macro.
					They are identified by a unique string key.
					Now, macros are gathered in a unique database, they are uniquely identified by a string key.
					How macros are stored on disk.
					The way the action is performed is stored in a file.
					Macros are stored in files in definite locations.
					Each bundle and plug in loaded by iTeXMac 2 can have its own set of macros.
					When a framework or bundle is loaded, the macro server will read the various "Macros" directories
					in the bundle and append the newly read macros to the database.
					Those "Macros" directories are expected to be localizable as a whole when wrapped in a bundle.
					The user defined macros are store'd in a Macros directory located in the user Library:
					~/Library/Application\ Support/iTeXMac2/Macros.localized
					If two frameworks define a macro with the same identifier, we do not give any rule to determine which one will have the precedence.
					The Macros will eventually override plug-ins Macros.
					Moreover, they are loaded from network, to local then user domain, each one taking precedence over its predecessor.
					When scanning the external Macros directories located in the various Application Support folder, the hash file are created at run time
					because the user is authorized to edit the contents of these forlders.
					What is the hash file format.
					The most comfortable choice is to use an XML file list containing a dictionary,
					for which values are the paths of the file containing the macro.
					Different keys can have the same value, this will occur if the macros are gathered in one file.
					
					In memory, we have 1 tree for the macros, 1 tree for all the key bindings, and one tree for each XML document stored.
					
					The macros and key bindings trees have the same architecture:
					- the root represents the Macros directory
					- the first level children represent the various shallow subfolders of the Macros directory, also known as "domains"
					- the second level children represent the various shallow folders of the domains subdirectories, also known as "categories"
					- the second level children represent the various shallow folders of the categories subdirectories, also known as "contexts"
					These trees are no deeper, from that point of view. However, the macros will add one depth level and the key bindings will add even more.
					
					For the macros tree, the leafs will be a list of macros. For the key bindings tree, the leafs will be a tree of key bindings.
					
					The macros and key bindings are stored at various locations as XML documents. Those XML document are also trees, they are managed separately.
					
					The context category hold the list of XML documents where the macros or key bindings are stored.
					
					
	@availability	iTM2.
	@copyright		2007 jlaurens AT users DOT sourceforge DOT net and others.
	@updated		today
	@version		1
*/

#import "iTM2MacroKit.h"

extern NSString * const iTM2MacroPathExtension;
extern NSString * const iTM2DontUseSmartMacrosKey;


/*!
    @class       iTM2MacroController
    @superclass  iTM2Object
    @abstract    The macros manager
    @discussion  (comprehensive description)
	@availability	iTM2.
	@copyright		2007 jlaurens AT users DOT sourceforge DOT net and others.
	@updated		today
	@version		1
*/
@interface iTM2MacroController(CONTENT)

/*!
    @method     macroTree
    @abstract   The macro running tree
    @discussion Lazy initializer. The domain and category nodes are iTM2MacroDomainNode and iTM2MacroCategoryNode instances.
				The context nodes are iTM2MacroContextNodes.
    @result     The macro running tree
*/
- (id)macroTree;

/*!
    @method     setMacroTree:
    @abstract   Set the macro running tree
    @discussion Designated setter.
    @param      aTree
    @result     None
*/
- (void)setMacroTree:(id)aTree;

/*!
    @method     keyBindingTree
    @abstract   The key binding running tree
    @discussion Lazy initializer. The domain and category nodes are iTM2MacroDomainNode and iTM2MacroCategoryNode instances.
				The context nodes are iTM2KeyBindingContextNodes.
    @result     The key binding running tree
*/
- (id)keyBindingTree;

/*!
    @method     setKeyBindingTree:
    @abstract   Set the key binding running tree
    @discussion Designated setter.
    @param      aTree
    @result     None
*/
- (void)setKeyBindingTree:(id)aTree;

/*!
    @method     macroRunningNodeForID:context:ofCategory:inDomain:
    @abstract   Abstract forthcoming
    @discussion Primitive getter. The returned object will be asked for its name, action, ...
    @param      ID
    @param      context
    @param      category
    @param      domain
    @result     a leaf macro tree node
*/
- (id)macroRunningNodeForID:(NSString *)ID context:(NSString *)context ofCategory:(NSString *)category inDomain:(NSString *)domain;


- (id)menuTree;
- (void)setMenuTree:(id)aTree;
- (NSMenu *)macroMenuForContext:(NSString *)context ofCategory:(NSString *)category inDomain:(NSString *)domain error:(NSError **)outErrorPtr;

- (id)treeForContextNodeClass:(Class)aClass;

- (id)keyBindingTree;

@end
