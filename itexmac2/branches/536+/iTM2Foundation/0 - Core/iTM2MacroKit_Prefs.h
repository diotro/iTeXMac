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

#pragma mark =====  NOTHING BELOW THIS POINT
#pragma mark -
#if 0
@interface iTM2MacroController(OTHER)
/*!
    @method     macroTree
    @abstract   The macro running tree
    @discussion Lazy initializer.
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
- (BOOL)executeMacroWithText:(NSString *)text forContext:(NSString *)context ofCategory:(NSString *)category inDomain:(NSString *)domain target:(id)target;
- (BOOL)executeMacroWithID:(NSString *)key forContext:(NSString *)context ofCategory:(NSString *)category inDomain:(NSString *)domain target:(id)target;
- (void)macroNode:(iTM2MacroNode *)node didChangeIDFrom:(NSString *)oldID to:(NSString *)newID;
- (void)keyBindingNode:(iTM2MacroNode *)node didChangeIDFrom:(NSString *)oldID to:(NSString *)newID;
@end
#endif

#if 0

extern NSString * const iTM2MacroPathExtension;
extern NSString * const iTM2DontUseSmartMacrosKey;


extern NSString * const iTM2TextPlaceholderMark;

extern NSString * const iTM2TextNumberOfSpacesPerTabKey;


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

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2MacroServer

/*!
	@class			iTM2MacrosServer
	@superclass		NSObject
	@abstract		Abstract forthcoming.
	@discussion		The macro design is rather complicated due to some indirection and some performance related problems.
					Macros are uniquely identified by their domain, category, context and key.
					Common domains are "Default", "Plain", "LaTeX", "ConTeXt", "MetaPost", "HTML", "XML", and so on.
					Common categories are "Default", "Document", "Text", "Math", "Custom", ...
					Common contexts are "Matrix", "Array", "Picture"...
					For example all macros concerning maths in LaTeX should be gathered in the "Math" category of the "LaTeX" domain.
					The macros are defined in different files in the different resource directories available.
					Domains, categories and contexts come from the subpath where they are stored:
					.../Macros.localized/domain_name/category_name/context_name
					Macros directly stored under
					.../Macros.localized/domain_name/category_name
					have a void context
					Macros directly stored under
					.../Macros.localized/domain_name/
					have a void category and context.
					<P/>
					 All the following is not accurate and should not be relied on.
					<P/>
					In general, those folders are built in bundles or plugins, such that they are perfectly known at ship time.
					As they are expected to contain a great deal of macros, we are relying on some already existing index.
					Those indexes are created at build time.
					What is the information contained in a macro?
					We already talked about the identifier part (domain, category, context, key 4uple),
					we now have to describe what really makes the macro.
					Actually a macro is just an action and an argument.
					The action is a selector name, corresponding to a message sent down the responder chain.
					If necessary, the action will have an argument. In general, this is a string argument...
					The macro should also contain some meta information. Some human readable information might be helpful.
					In order to make localization easier, at least initially, the macro title and description are gathered in an external file.
					This allows to simply duplicate a Macros folder and translate only one file,
					being sure that the macros are consistent between the various languages, (but this is not a requirement).
					
					iTeXMac2 project contains a tool to parse all the macro files with the same category in the same domain,
					and cache a key -> path dictionary in an index to indicate what keys are available
					and the path of the file where they are defined.
					When the server is asked for a macro given its key, context, category and domain,
					it goes to its cache to see if this macro is already available,
					if not, it uses the correct path to execute the macro.
					For example, old design macros are often gathered in one property list or xml file.
					The server will read the file and extract the relevant information,
					then it will use this information to perform the desired action.
					For perl macros, the macro server will just let the perl interpreter take the appropriate information from the same file.
					This means that perl macros won't certainly have to be cached.
					What is the user interface for these macros?
					Different files are involved.
					foo.iTM2MacrosMenu is an xml file containing the description of a menu.
					domain/category/.../foo.iTM2MacroIndex is a shallow standalone xml file that defines the key->path dictionary index.
					domain/category/.../foo.iTM2MacrosNames is a shallow standalone xml file defining a key->localized name dictionary
					domain/category/.../foo.iTM2MacrosTooltips is a shallow standalone xml file defining a key->localized tooltips dictionary
					domain/category/.../foo.iTM2MacrosShorcuts is an xml file defining the key combination -> key/category/domain mapping.
					The key bindings manager will use the foo.iTM2MacrosShorcuts, and if the user requests more information
					the foo.iTM2MacrosNames and foo.iTM2MacrosTooltips.
					The menu controller will primarily use the foo.iTM2MacrosMenu and foo.iTM2MacrosNames,
					and the foo.iTM2MacrosTooltips on request.
					The macro server will use foo.iTM2MacroIndex to perform the apropriate action.
					An editor should be available
					The user defined macros (category "Custom") are less numerous and will be managed on the fly with a slightly different strategy.
					Assuming that they are all user defined, we do not need tooltips nor cached macros index.
	@availability	iTM2.
	@copyright		2005 jlaurens AT users.sourceforge.net and others.
*/

#import <iTM2Foundation/iTM2Implementation.h>

#define SMS [iTM2MacrosServer sharedMacrosServer]

@interface iTM2MacrosServer: iTM2Object

/*!
	@method			sharedMacrosServer
	@abstract		Abstract forthcoming.
	@discussion		Discussion forthcoming.
	@result			None.
	@availability	iTM2.
	@copyright		2005 jlaurens AT users.sourceforge.net and others.
*/
+ (id)sharedMacrosServer;

/*!
	@method			executeMacroWithKey:forContext:inCategory:ofDomain:
	@abstract		Execute the macro identified by the given arguments.
	@discussion		Discussion forthcoming.
	@param			key
	@param			category
	@param			domain
	@result			a flag.
	@availability	iTM2.
	@copyright		2005 jlaurens AT users.sourceforge.net and others.
*/
//- (BOOL)executeMacroWithKey:(NSString *)key forContext:(NSString *)context ofCategory:(NSString *)category inDomain:(NSString *)domain;

/*!
	@method			macroLocaleOfType:forKey:forContext:inCategory:ofDomain:
	@abstract		The localized name of the macro action is stored.
	@discussion		Discussion forthcoming. If the information is not cached because it was requested before,
					scans the file hierarchy to retrieve and parse the name files in the correct locations.
					Type is one of @"Name", @"Description", @"Tooltip".
	@param			type
	@param			key
	@param			category
	@param			domain
	@result			a name.
	@availability	iTM2.
	@copyright		2005 jlaurens AT users.sourceforge.net and others.
*/
- (NSString *)macroLocaleOfType:(NSString *)type forKey:(NSString *)key context:(NSString *)context ofCategory:(NSString *)category inDomain:(NSString *)domain;

/*!
	@method			macroActionForKey:context:inCategory:ofDomain:
	@abstract		The localized dscription of the macro action is stored.
	@discussion		The information is initially available in 2 kinds of locations.
					1 - directly in the index files named iTM2MacrosIndex in the various
					.../Macros/domain/category
					folders available in the built in bundles.
					These files are standalone xml document containing a key -> path map to indicate where the macro are defined.
					If the path begins with a "./", it is relative to the containing .../Macros/domain/category folder.
					If the path begins with a "/" it is absolute.
					This design makes it possible to use other schemes (URLs).
					Other schemes are not yet supported and will be ignored by iTM2.
					Using a relative name authorizes to change the category name in a simple way.
					Whenn these files will be parsed, the full path will eventually be reconstructed and used.
					2 - indirectly in the various
					.../Application\ Support/iTeXMac2/Macros/domain/category
					folders available in the various domain either local, network or user defined.
					This information will be extracted at run time such that only full path will be available.
					The order in which these files are parsed is very important because it defines the overriding rules.
					For bundles, embedded frameworks then plugins then the resource folder are scanned.
					For system domains, the main bundle then the network then local then user domain are scanned.
					For each system domain, the plugins are scanned before the Application\ Support subfolder.
					Finer grain order is left undefined which means that
					if 2 iTeXMac2 plugins in the same folder define a macro with exactly the same domain, category and key triple,
					which one is chosen is not defined and may change after an upgrade.
					Each category/domain pair defines a unique name space.
					The information is initialized lazily.
					When the receiver is requested for the file name, it looks in its cached information for the answer.
					If the answer is not available, it updateContainerFileNamesForContext:ofCategory:inDomain:.
	@param			key
	@param			category
	@param			domain
	@result			a path.
	@availability	iTM2.
	@copyright		2005 jlaurens AT users.sourceforge.net and others.
*/
- (id)macroActionForKey:(NSString *)key context:(NSString *)context ofCategory:(NSString *)category inDomain:(NSString *)domain;

@end

@interface NSTextView(iTM2MacroKit_)
+ (NSString *)tabAnchorKey;
- (NSString *)tabAnchor;
//- (NSString *)removePlaceholderMarksWhenSelecting;
- (IBAction)selectNextPlaceholder:(id)sender;
- (IBAction)selectPreviousPlaceholder:(id)sender;
- (void)insertMacro:(id)sender;
- (void)insertMacro:(id)argument inRange:(NSRange)affectedCharRange;
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  NSTextStorage(iTM2Selection_MACRO)
/*"Description forthcoming."*/
@interface NSTextStorage(iTM2Selection_MACRO)

- (void)insertMacro:(id)argument inRangeValue:(id)rangeValue;

@end

@interface NSText(iTM2KeyBindingsKit)

/*!
    @method		executeMacro:
    @abstract	Execute the given macro.
    @discussion	If the inherited method does not work, and if the given macro is a string,
                it just insert this string using insertText: and returns YES.
    @param		An macro.
    @result		A flag indicating whether the receiver has executed the given macro.
*/
- (BOOL)executeMacro:(NSString *)macro;

@end

@interface iTM2GenericScriptButton: NSPopUpButton
@end

#import <iTM2Foundation/iTM2TreeKit.h>

@interface iTM2MacroNode: iTM2TreeNode
- (NSString *)concreteArgument;
- (NSString *)argument;
- (NSString *)ID;
- (void)setID:(NSString *)newID;
- (BOOL)isVisible;
- (NSXMLElement *)XMLElement;
- (NSMutableArray *)XMLElements;
- (NSMutableArray *)mutableXMLElements;
- (void)addXMLElement:(NSXMLElement *)element;
- (void)removeLastXMLElement;
- (void)removeLastMutableXMLElement;
- (NSString *)description;
- (NSString *)mode;
@end

@interface iTM2KeyBindingContextNode:iTM2MacroNode
- (NSArray *)_X_availableKeyBindings;
- (unsigned int)countOfAvailableKeyBindings;
- (NSArray *)availableKeys;
@end

#endif
