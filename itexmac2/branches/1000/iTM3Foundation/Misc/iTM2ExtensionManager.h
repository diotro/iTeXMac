/*
//  iTM2ExtensionManager.h
//  iTeXMac2
//
//  Created by jlaurens@users.sourceforge.net on Thu Jun 13 2002.
//  Copyright © 2001-2010 Laurens'Tribune. All rights reserved.
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


#import <iTM2Foundation/iTM2ButtonKit.h>


//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  iTM2ExtensionManager

@interface iTM2ExtensionManager : NSObject
{
@private
    NSMutableDictionary * iVarExtensionDictionary4iTM3;
    NSMenu * iVarMenu4iTM3;
}
@property (assign) NSMenu * menu;
@property (assign) NSDictionary * extensionDictionary;
/*"Class methods"*/
/*"Setters and Getters"*/
- (NSMenuItem *) extensionMenuItemAtURL:(NSURL *)url error:(NSError **)RORef;
- (NSMenu *) extensionMenuAtLibraryURL:(NSURL *)libraryURL error:(NSError **)RORef;
/*"Main methods"*/
- (void) loadTheExtensionWithError:(NSError **)RORef;
- (void) registerExtension: (id) object forKey: (NSString *) aKey;
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  iTM2AssistantManager

@interface iTM2AssistantManager : iTM2ExtensionManager
/*"Class methods"*/
+ (id) sharedAssistantManager;
/*"Setters and Getters"*/
/*"Main methods"*/
/*"Overriden methods"*/
- (NSString *) relativePath;
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  iTM2AssistantButton

@interface iTM2AssistantButton : iTM2ButtonMixed
/*"Class methods"*/
/*"Setters and Getters"*/
/*"Main methods"*/
/*"Overriden methods"*/
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  iTM2AssistantManager

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  iTM2ScriptExtensionButton
/*! 
    @class	iTM2ScriptExtensionButton
    @abstract	A pull down button with all the script extensions.
    @discussion	Lists the contents of the various script folders:
                DOMAIN/Library/Application\ Support/iTeXMac2/Editor/MODE/Scripts
                The DOMAIN is one of the standard domains or built in ones.
                The MODE is the textEditorMode of the receiver's window document.
                If there is no such document, the currentDocument is used instead.
                The built in domain comes from the bundle where the button is defined,
                not the main one.
                Frameworks and bundles can provide default Scripts by subclassing iTM2ScriptExtensionButton,
                and shiop the subclass with appropriate data in
                Contents/Resources/LANGUAGE.lproj/Editor/MODE/Scripts
*/

@interface iTM2ScriptExtensionButton : iTM2ButtonMixed
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  iTM2ExtensionManager
