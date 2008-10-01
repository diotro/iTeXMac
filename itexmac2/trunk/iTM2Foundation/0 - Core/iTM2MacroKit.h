/*
//
//  @version Subversion: $Id$ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Thu Feb 21 2002.
//  Copyright © 2007 Laurens'Tribune. All rights reserved.
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

#import <iTM2Foundation/iTM2KeyBindingsKit.h>

@interface NSObject(iTM2MacroKit)
- (NSString *)macroDomainKey;
- (NSString *)defaultMacroDomain;
- (NSString *)macroDomain;
- (void)setMacroDomain:(NSString *)argument;
- (NSString *)macroCategoryKey;
- (NSString *)defaultMacroCategory;
- (NSString *)macroCategory;
- (void)setMacroCategory:(NSString *)argument;
- (NSString *)macroContextKey;
- (NSString *)defaultMacroContext;
- (NSString *)macroContext;
- (void)setMacroContext:(NSString *)argument;
- (id)argument;
- (id)macroWithID:(NSString *)ID;
@end

@interface NSObject(iTM2ExecuteMacro)
/*!
    @method		executeMacroWithID:
    @abstract	Execute the given macro.
    @discussion	This is one of the central methods to enhance Mac OS X key binding mechanism.
                Here we can not only send messages as Mac OS X can do, but we can also use methods with parameters.
                Those parameters are property list objects which covers a great range of possibilities.
    @param		A macro.
    @result		A flag indicating whether the receiver has executed the given macro.
*/
- (BOOL)executeMacroWithID:(NSString *)macro;
- (BOOL)executeMacroWithText:(NSString *)text;
@end

@interface NSResponder(iTM2ExecuteMacro)
/*!
    @method		executeMacroWithID:
    @abstract	Execute the given macro.
    @discussion	Overriden to take into account the responder chain -tryToPerform:withObject: through -tryToExecuteMacroWithID:.
    @param		A macro.
    @result		A flag indicating whether the receiver has executed the given macro.
*/
- (BOOL)executeMacroWithID:(NSString *)macro;
- (BOOL)tryToExecuteMacroWithID:(NSString *)macro;//fake

@end

#define SMC [iTM2MacroController sharedMacroController]

#import <iTM2Foundation/iTM2Implementation.h>

/*!
    @class       iTM2MacroController
    @superclass  iTM2Object
    @abstract    The macros manager
    @discussion  (comprehensive description)
*/
@interface iTM2MacroController: iTM2Object

/*!
    @method     sharedMacroController
    @abstract   (brief description)
    @discussion (comprehensive description)
    @result     (description)
*/
+ (id)sharedMacroController;

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

- (void)saveTree:(id)node;
@end


@interface NSString(iTM2MacroKit)

/*!
	@method		stringWithIndentationLevel:atIndex:withNumberOfSpacesPerTab:
	@abstract	Abstract forthcoming.
	@discussion	Discussion forthcoming.
	@param		level.
	@param		index.
	@param		numberOfSpacesPerTab.
    @result     the new string
*/
- (NSString *)stringWithIndentationLevel:(unsigned)indentation atIndex:(unsigned)index withNumberOfSpacesPerTab:(int)numberOfSpacesPerTab;

/*!
	@method		stringByNormalizingIndentationWithNumberOfSpacesPerTab:
	@abstract	Abstract forthcoming.
	@discussion	Discussion forthcoming.
	@param		numberOfSpacesPerTab.
    @result     Normalized NSString instance
*/
- (NSString *)stringByNormalizingIndentationWithNumberOfSpacesPerTab:(int)numberOfSpacesPerTab;

/*!
	@method		indentationLevelAtIndex:withNumberOfSpacesPerTab:
	@abstract	Abstract forthcoming.
	@discussion	Discussion forthcoming.
	@param		index.
	@param		numberOfSpacesPerTab.
    @result     level
*/
- (unsigned)indentationLevelAtIndex:(unsigned)index withNumberOfSpacesPerTab:(unsigned)numberOfSpacesPerTab;

/*!
	@method		rangeOfPlaceholderAtIndex:getType:ignoreComment:
	@abstract	Abstract forthcoming.
	@discussion	???Removes everything inside "@@@(SEL:...)@@@", such that there are only "@@@(...)@@@" remaining. No
	@param		An index.
	@param		A type ref.
	@result		A range.
*/
- (NSRange)rangeOfPlaceholderAtIndex:(unsigned)index getType:(NSString **)typeRef ignoreComment:(BOOL)ignore;

/*!
	@method		stringByRemovingPlaceholderMarks
	@abstract	Abstract forthcoming.
	@discussion	Discussion forthcoming.
	@param		None.
    @result     string
*/
- (NSString *)stringByRemovingPlaceholderMarks;

@end

extern NSString * const iTM2MacroScriptsComponent;
extern NSString * const iTM2MacrosDirectoryName;
extern NSString * const iTM2KeyBindingPathExtension;// to be deprecated...
extern NSString * const iTM2MacroControllerComponent;

@interface NSTextView(iTM2MacroKit)
- (void)insertMacro:(id)argument;
- (NSString *)tabAnchor;
- (NSString *)preparedSelectedStringForMacroInsertion;
- (NSString *)preparedSelectedLineForMacroInsertion;
- (NSString *)concreteReplacementStringForMacro:(NSString *)macro selection:(NSString *)selection line:(NSString *)line;
- (unsigned)numberOfSpacesPerTab;
- (NSString *)replacementStringForMacro:(NSString *)macro selection:(NSString *)selection line:(NSString *)line;
- (NSString *)macroByPreparing:(NSString *)macro forInsertionInRange:(NSRange)affectedCharRange;
- (IBAction)selectFirstPlaceholder:(id)sender;
@end

#pragma mark ---- THIS IS FOR THE UI
/*
    @class		the key codes controller
    @abstract	Translate key codes into names and localized names.
    @discussion	Discussion forthcoming.
*/
@interface iTM2KeyCodesController: iTM2Object

/*
    @method     sharedController
    @abstract	The shared key codes controller.
    @discussion	Discussion forthcoming.
    @param	    None
    @result     A controller
*/
+ (id)sharedController;

@end

@interface iTM2KeyCodesController(methods)

/*!
    @method     orderedCodeNames
    @abstract   (brief description)
    @discussion (comprehensive description)
    @param      name (description)
    @result     (description)
*/
- (NSArray *)orderedCodeNames;

/*!
    @method     keyCodeForName:
    @abstract   (brief description)
    @discussion (comprehensive description)
    @param      name (description)
    @result     (description)
*/
- (NSString *)keyCodeForName:(NSString *)name;

/*!
    @method     nameForKeyCode:
    @abstract   (brief description)
    @discussion (comprehensive description)
    @param      code (description)
    @result     (description)
*/
- (NSString *)nameForKeyCode:(NSString *)code;

/*!
    @method     localizedNameForCodeName:
    @abstract   (brief description)
    @discussion (comprehensive description)
    @param      codeName (description)
    @result     (description)
*/
- (NSString *)localizedNameForCodeName:(NSString *)codeName;

/*!
    @method     codeNameForLocalizedName:
    @abstract   (brief description)
    @discussion (comprehensive description)
    @param      codeName (description)
    @result     (description)
*/
- (NSString *)codeNameForLocalizedName:(NSString *)localizedName;

@end

#define KCC [iTM2KeyCodesController sharedController]

@interface iTM2GenericScriptButton: NSPopUpButton
@end

/*!
    @class		iTM2KeyBindingNode
    @abstract	This is the central object for key bindings.
    @discussion	It is a tree node object that contains key stroke information and a macro identifier.
				The parent and children are expected to be of the same kind.
*/
@interface iTM2KeyBindingNode:iTM2KeyStroke
{
@private
	NSString * macroID;// the ID attribute
	iTM2KeyBindingNode * parent;// tree structure
	NSMutableArray * children;// tree structure
}
- (id)initWithParent:(id)aParent;
- (NSString *)macroID;
- (void)setMacroID:(NSString *)newID;
- (NSMutableArray *)children;
- (void)setChildren:(NSMutableArray *)newChildren;
- (iTM2KeyBindingNode *)parent;
- (void)setParent:(iTM2KeyBindingNode *)newParent;
- (unsigned int)countOfChildren;
- (id)objectInChildrenAtIndex:(unsigned int)index;
- (void)insertObject:(id)object inChildrenAtIndex:(unsigned int)index;
- (void)removeObjectFromChildrenAtIndex:(unsigned int)index;
- (void)parseData:(NSData *)data uniqueKey:(BOOL)flag;
- (id)objectInChildrenWithCodeName:(NSString *)theCodeName modifierFlags:(unsigned int)modifierFlags;
- (id)objectInChildrenWithKeyStroke:(iTM2KeyStroke *)keyStroke;
- (id)objectInKeyBindingsWithKeyStroke:(iTM2KeyStroke *)keyStroke;
@end

/*!
    @class		iTM2MacroNode
    @abstract	This is the central object for storing macros.
    @discussion	Macros are recorded as a flat list of objects.
				Each macro node is uniquely identified by a macroID within its own context.
				Each object belongs to a macro domain, a macro category within that domain, and a macro context within that category.
				All 3 are the context of the macro.
				Some macros might be defined for all the macro contexts of a given macro category.
				Some other macros might be defined for all the macro categories (and macro contexts) of a given macro domain.
				Substitutions is a dictionary of key value pairs,
				the keys belong to a known list of keywords,
				the values are the expected substitutions for these keys.
*/
@interface iTM2MacroNode:NSObject
{
@private
	NSString * macroID;// the ID selector
	NSString * selector;// the attribute selector
	NSString * insertion;//
	NSString * name;//
	NSString * macroDescription;//
	NSString * tooltip;// child
	NSDictionary * substitutions;
}
- (NSString *)macroID;
- (void)setMacroID:(NSString *)newID;
- (NSString *)selector;
- (void)setSelector:(NSString *)newSelector;
- (NSString *)name;
- (void)setName:(NSString *)newName;
- (NSString *)macroDescription;
- (void)setMacroDescription:(NSString *)newMacroDescription;
- (NSString *)insertion;
- (void)setInsertion:(NSString *)newInsertion;
- (NSString *)tooltip;
- (void)setTooltip:(NSString *)newTooltip;
- (NSDictionary *)substitutions;
- (void)setSubstitutions:(NSDictionary *)newSubstitutions;
+ (NSMutableDictionary *)macrosWithData:(NSData *)data owner:(id)anOwner;
@end

@interface iTM2MacroNode(Active)
- (SEL)action;
- (BOOL)executeMacroWithTarget:(id)target selector:(SEL)action substitutions:(NSDictionary *)substitutions;
@end
