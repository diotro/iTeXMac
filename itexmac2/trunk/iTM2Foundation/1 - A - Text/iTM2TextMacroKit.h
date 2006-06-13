/*
//
//  @version Subversion: $Id$ 
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

extern NSString * const iTM2MacroNameKey;
extern NSString * const iTM2MacroInsertionKey;
extern NSString * const iTM2MacroToolTipKey;

/*!
	@header			iTM2TextMacroKit
	@abstract		Abstract forthcoming.
	@discussion		Consider this technology as experimental (to be improved and possibly deprecated in a near future), do not use it.
					This is the new architecture of macros.
					First let us define what are Macros.
					Macros are just actions: make something or that.
					They are identified by a unique string key.
					The way the action is performed is stored in a file.
					Now, macros are gathered in a unique database, they are uniquely identified by a string key.
					A macro can be some text to be inserted, or some action to be performed.
					How macros are stored on disk.
					Macros are stored in files in definite locations.
					Each bundle and plug in loaded by iTeXMac 2 can have its own set of macros.
					When a framework or bundle is loaded, the macro server will read the various "Macros" directories
					in the bundle and append the newly read macros to the database.
					Those "Macros" directories are expected to be localizable as a whole when wrapped in a bundle.
					The user defined macros are store'd in a Macros directory located in the user Library:
					~/Library/Application\ Support/iTeXMac2/Macros
					In order to improve scanning the directories where the macros are stored,
					the contents is cached a la "ls-R" known in teTeX in file named .iTM2MacrosHashTable.
					iTeXMac2 contains a tool to parse the contents of Macros folders and provide a hash file of its own.
					This will be used at compile time and will save some time at execution time.
					This is just a hash table associating a macro to a given hash key.
					At run time, iTM2 will parse this file instead of the whole directory.
					Are hash keys absolute or relative.
					There are 2 options.
					Either, the hash file contains an absolute hash key or it contains a relative hash key.
					Using absolute hash keys is very interesting because it allows to override previously stored macros
					and thus define some defaults, patches and so on.
					Using relative hash keys is extermely comfortable because it allows to confine key into different namespaces
					which makes easier the uniqueness management.
					How we implement both.
					(we don't use URI and friends because they are too heavy for that purpose, we'll be able to use automatic translator if needed)
					The hash keys are virtual paths. 
					If the hash key starts with a "/", it is absolute. Otherwise it is relative to the path of the containing hash file.
					Every path is rooted at some Macros folder, in one of the bundles.
					How things work.
					At launch time, iTeXMac2 scans all the built in Macros directories available for their hash databases.
					These file are parsed to feed the central database. The loading order is undefined.
					If two frameworks define a macro with the same identifier, we do not give any rule to determine which one will have the precedence.
					Then external plug-ins and Macros are scanned (in the various Application\ Support folders), and their hash data bas is parsed.
					The Macros will eventually override plug-ins Macros.
					Moreover, they are loaded from network, to local then user domain, each one taking precedence over its predecessor.
					When scanning the external Macros directories located in the various Application Support folder, the hash file are created at run time
					because the user is authorized to edit the contents of these forlders.
					What is the hash file format.
					The most comfortable choice is to use an XML property list containing a dictionary,
					for which values are the paths of the file containing the macro.
					Different keys can have the same value, this will occur if the macros are gathered in one file.
	@availability	iTM2.
	@copyright		2005 jlaurens AT users DOT sourceforge DOT net and others.
	@updated		today
	@version		1
*/

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2TextMacro

@interface iTM2TextMacro : NSObject
{
@private
    NSString * _Before;
    NSString * _Selected;
    NSString * _After;
    NSString * _ToolTip;
}
/*"Class methods"*/
+ (id) macroV1WithBefore: (NSString *) before selected: (NSString *) selected after: (NSString *) after;
+ (id) macroWithBefore: (NSString *) before selected: (NSString *) selected after: (NSString *) after toolTip: (NSString *) toolTip;
/*"Setters and Getters"*/
- (NSString *) macroBefore;
- (void) setMacroBefore: (NSString *) argument;
- (NSString *) macroSelected;
- (void) setMacroSelected: (NSString *) argument;
- (NSString *) macroAfter;
- (void) setMacroAfter: (NSString *) argument;
- (NSString *) toolTip;
- (void) setToolTip: (NSString *) argument;
- (NSString *) macroStringForName: (NSString *) name selection: (NSString *) selection indent: (NSString *) indentPrefix
    selectedRangePointer: (NSRangePointer) aRangePtr;
- (NSString *) string;
- (NSAttributedString *) attributedStringForName: (NSString *) name delimiter: (NSAttributedString *) delimiterAttributedString;
/*"Main methods"*/
- (id) initWithString: (NSString *) argument;
- (id) initWithBefore: (NSString *) before selected: (NSString *) selected after: (NSString *) after toolTip: (NSString *) toolTip;
- (id) initWithAttributedString: (NSAttributedString *) attributedString name: (NSString *) name toolTip: (NSString *) toolTip;
/*"Overriden methods"*/
- (void) dealloc;
@end

@interface iTM2AppleScriptMacro: NSObject
{
@private
    NSString * _Script;
    NSString * _ToolTip;
}
- (id) initWithScript: (NSString *) argument;
- (id) initWithEncodedScript: (NSString *) argument;
- (void) dealloc;
- (NSString *) script;
- (NSString *) encodedScript;
- (void) setScript: (NSString *) argument;
- (NSString *) toolTip;
- (void) setToolTip: (NSString *) argument;
@end

@interface iTM2AppleScriptFileMacro: NSObject
{
@private
    NSString * _Path;
    NSString * _ToolTip;
}
- (id) initWithPath: (NSString *) argument;
- (id) initWithEncodedPath: (NSString *) argument;
- (void) dealloc;
- (NSString *) path;
- (NSString *) encodedPath;
- (void) setPath: (NSString *) argument;
- (NSString *) toolTip;
- (void) setToolTip: (NSString *) argument;
@end

@interface NSTextView (iTM2TextMacro)
- (void) insertMacro: (id) sender;
- (void) insertMacro: (id) argument tabAnchor: (NSString *) tabAnchor;
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  NSTextStorage(iTM2Selection)

@interface NSTextStorage(iTM2TextMacroKit)
- (void) insertMacro: (id) argument inRangeValue: (id) rangeValue;
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2TextMacro

