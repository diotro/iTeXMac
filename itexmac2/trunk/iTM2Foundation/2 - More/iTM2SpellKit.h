/*
//  iTeXMac2 1.4
//
//  @version Subversion: $Id$ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Tue May  4 19:35:54 GMT 2004.
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

#import <iTM2Foundation/iTM2Implementation.h>

extern NSString * const iTM2UDContinuousSpellCheckingKey;

extern NSString * const TWSSpellLanguageKey;
extern NSString * const TWSSpellIgnoredWordsKey;
extern NSString * const TWSSpellExtension;
extern NSString * const TWSSpellIsaKey;
extern NSString * const TWSSpellIsaValue;
extern NSString * const TWSSpellDefaultContextMode;

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2SpellKit

/*!
    @class 	iTM2SpellKit
    @abstract	Extending cocoa spell checker.
    @discussion	Some technical note on the spell management.
                Cocoa manages languages and ignored words in a per application basis.
                However, there is a spell document tag which allows to separate spell parameters on a per object basis.
                iTeXMac2 assumes that any NSText object can have a dedicated spell context,
                with a dedicated language and dedicated set of ignored words.
                As many different NSText objects might have to share the same spell context,
                there is a notion of spell context mode, which is a unique key identifier.
                The set of known words is managed by cocoa and iTeXMac2 does not change this behaviour.
                However, there is some difficulty in tracking the changes in the language.
                The changes in spell context mode are well tracked because they are initiated by iTM2 itself.
*/

/*!
    @class	iTM2SpellContext
    @abstract	A spelling context.
    @discussion	The spelling context is defined by the language, and the lists of known words.
                Each NSText is supposed to have its own spelling context,
                but many different texts are allowed to share the same spelling context.
                For the moment, no question of different spelling context for different parts of the same text.
                There is a unique default spelling context that is shared by the NSText's when nothing else is available.
                This context is used by the spell checker helper to properly set the spell checker parameters.
                See the iTM2SpellCheckerHelper class for details.
*/

@interface iTM2SpellContext: NSObject
{
@private
    NSArray *	ivarIgnoredWords;
    NSString *	ivarLanguage;
    int			ivarTag;
}

/*!
    @method		loadPropertyListRepresentation:
    @abstract	Loads the given property list.
    @discussion	The given property list must comply the TeX Wrapper Structure specifications version 1.
    @param		The argument is the property list.
    @result		A flag indicating in an obvious manner the success or failure of the operation.
                If the slightest problem is encountered, the result is NO. So don't be too exigent.
*/
- (BOOL)loadPropertyListRepresentation:(id)PL;

/*!
    @method		readFromURL:error:
    @abstract	Abstract forthcoming.
    @discussion	Discussion forthcoming.
    @param		The fileURL.
    @param		outErrorPtr.
    @result		A flag indicating in an obvious manner the success or failure of the operation.
*/
- (BOOL)readFromURL:(NSURL *)fileURL error:(NSError**)outErrorPtr;

/*!
    @method		writeToURL:error:
    @abstract	Abstract forthcoming.
    @discussion	Discussion forthcoming.
    @param		The fileURL.
    @param		outErrorPtr.
    @result		A flag indicating in an obvious manner the success or failure of the operation.
*/
- (BOOL)writeToURL:(NSURL *)fileURL error:(NSError**)outErrorPtr;

/*!
    @method		loadPropertyListRepresentation:
    @abstract	Loads the given property list.
    @discussion	The given property list must comply the TeX Wrapper Structure specifications version 1.
    @param		The argument is the property list.
    @result		A flag indicating in an obvious manner the success or failure of the operation.
                If the slightest problem is encountered, the result is NO. So don't be too exigent.
*/
- (BOOL)loadPropertyListRepresentation:(id)PL;

/*!
    @method		propertyListRepresentation
    @abstract	The property list representation of the receiver.
    @discussion	The given property complies the TeX Wrapper Structure specifications version 1.
    @param		None.
    @result		A dictionary.
*/
- (id)propertyListRepresentation;

/*!
    @method		spellLanguage
    @abstract	The language of the spelling context.
    @discussion	The format for the language is Mac OS X specific.
                If the stored format is different, there must be a translator.
    @result		A NSString for the language.
*/
- (NSString *)spellLanguage;

/*!
    @method		setSpellLanguage:
    @abstract	Sets the language of the spelling context.
    @discussion	The format for the language is Mac OS X specific.
                If the stored format is different, there must be a translator.
    @param		A NSString for the language.
    @result		None.
*/
- (void)setSpellLanguage:(NSString *)argument;

/*!
    @method		ignoredWords
    @abstract	The list of ignored words.
    @discussion	Just an array of words, to feed the spell checker.
    @result		An NSArray of NSString's.
*/
- (NSArray *)ignoredWords;

/*!
    @method		setIgnoredWords:
    @abstract	Sets the list of ignored words of the spelling context.
    @discussion	It just replaces the old list.
                There a consistency test that eliminates all objects that are not NSString's.
    @param		An NSArray of NSString's.
    @result		None.
*/
- (void)setIgnoredWords:(NSArray *)argument;

/*!
    @method		replaceIgnoredWords:
    @abstract	Replace the list of ignored words of the spelling context.
    @discussion	It replaces the old list and actualize the shared spell checker.
    @param		An NSArray of NSString's.
    @result		None.
*/
- (void)replaceIgnoredWords:(NSArray *)argument;

/*!
    @method		tag
    @abstract	This tag is meant for the cocoa spell checker.
    @discussion	Discussion forthcoming.
    @param		None.
    @result		An integer.
*/
- (int)tag;

@property (retain) NSArray *	ivarIgnoredWords;
@property (retain) NSString *	ivarLanguage;
@property int			ivarTag;
@end

/*!
    @class	iTM2SpellContextController
    @abstract	A spelling context controller.
    @discussion	The spelling context is defined by the language, and the lists of know words.
                Each logically different context is defined by a unique NSString key named the spell mode.
                Many different texts can share the same spelling context, or in short the same mode,
                and a single text split can be made of different parts
                each one having its own different spelling contexts depending on the part of the text.
                The void string @"" is the spelling context key for the default context.
                The spelling context controller is expected to manage the different spelling modes
                a document might need to use. Each document is expected to have its own spelling context controller.
                Basically, each NSDocument should have its own spelling context controller,
                and each text of any window for that document should ask the spelling window controller
                for the correct spelling context.
                iTeXMac2 situation is more delicate because the document may be split into many different files,
                each one being a document.
                In that case many different NSDocument's can share the same spelling context controller.
                There is a unique shared spelling context controller that knows different spelling modes.
                If a document does not know about a spelling context controller, the shared one is used.
                There is a remanancy of the spelling context: when the main document changes,
                and the new one has no specific requirements, the previous spelling context is used.
                The spelling context controller is just a repository of spelling contexts.
                It can load and save the contexts in given directories.
                But this object can't make the decision of the correct spelling context that must be used.
                It is the responsibility of another object with better knowledge of the environment
                (an NSDocument for example)
*/

@interface iTM2SpellContextController: iTM2Object

/*!
    @method		defaultSpellContextController
    @abstract	Abstract forthcoming.
    @discussion	Discussion forthcoming.
    @param		None.
    @result		A default spell context controller.
*/
+ (id)defaultSpellContextController;

/*!
    @method		addSpellMode:
    @abstract	Creates the new spelling mode.
    @discussion	Description forthcoming.
    @param		mode is a NSString uniquely identifying a set of spelling parameters.
    @result		A flag indicating in an obvious manner the success or failure of the operation.
*/
- (BOOL)addSpellMode:(NSString *)mode;

/*!
    @method		removeSpellMode:
    @abstract	Removes the existing spelling mode.
    @discussion	Description forthcoming.
    @param		mode is a NSString uniquely identifying a set of spelling parameters.
    @result		YES iff something was really added. NO if the mode already exists e.g.
*/
- (BOOL)removeSpellMode:(NSString *)mode;

/*!
    @method		spellContextModesEnumerator:
    @abstract	Enumerator of the existing spelling modes.
    @discussion	Description forthcoming.
    @result		A convenience NSEnumaretor.
*/
- (NSEnumerator *)spellContextModesEnumerator;

/*!
    @method		spellContexts
    @abstract	Abstract forthcoming.
    @discussion	Description forthcoming.
    @param		None.
    @result		A convenience NSEnumaretor.
*/
- (id)spellContexts;

/*!
    @method		setSpellContexts:
    @abstract	Abstract forthcoming.
    @discussion	Description forthcoming.
    @param		newContexts.
    @result		None.
*/
- (void)setSpellContexts:(id)newContexts;

/*!
    @method		spellContextForMode:
    @abstract	The spell context for the given mode.
    @discussion	Description Forthcoming.
    @param		An NSString representing a mode, id est a set of parameters defining the spelling:
                the language and the ignored words. The mode must exist prior to this message.
    @result		An iTM2SpellContext.
*/
- (id)spellContextForMode:(NSString *)mode;

/*!
    @method		setSpellContext:forMode:
    @abstract	Sets the spell context for the given mode.
    @discussion	Description Forthcoming.
    @param		A possibly nil spell context.
    @param		An NSString representing a mode, id est a set of parameters defining the spelling:
                the language and the ignored words. The mode must exist prior to this message.
    @result		An iTM2SpellContext.
*/
- (void)setSpellContext:(id)newContext forMode:(NSString *)mode;

/*!
    @method		spellContextModeForText:
    @abstract	The spell context mode for the given text.
    @discussion	This default implementation just asks the meta property server of the given text to do the job.
    @param		text is basically a NSText instance.
    @result		A spell context mode.
*/
- (NSString *)spellContextModeForText:(NSText *)text;

/*!
    @method		setSpellContextMode:forText:
    @abstract	The setter of the previous getter.
    @discussion	This default implementation just asks the meta property server of the given text to do the job.
                Just send a setSpellContextMode: to the given text.
                But subclassers will certainly implement their own method to make adifference between texts.
    @param		mode is basically the new mode.
    @param		text is basically a NSText instance.
    @result		None.
*/
- (void)setSpellContextMode:(NSString *)mode forText:(id)text;

/*!
    @method		spellPrettyNameForText:
    @abstract	The spell name for the given text.
    @discussion	Different texts might appear to pertain to the same window corresponding to the same document.
                There should be a mean to distinguish between different texts.
                The problem comes from the spelling panel that do not tell us what is the text currently being checked.
                The default implementation just returns the display name
                of the document of the winfow controller of the window of the text...
                If no document is available, the window title is used instead.
    @param		text is basically a NSText instance.
    @result		A human readable name.
*/
- (NSString *)spellPrettyNameForText:(NSText *)text;

- (id)propertyListRepresentation;
- (BOOL)loadPropertyListRepresentation:(id)PL;

@end

@interface iTM2SpellContextController(Project)

/*!
    @method		spellPrettyProjectNameForText:
    @abstract	The spell project name for the given text.
    @discussion	Different texts might appear to pertain to the same higher level context.
                This is the purpose of spell projects.
                For example, documents splitted into many different files are such a wider project.
                This default implementation returns the pretty TeX project name if any.
                The defauilt implementation does not know about projects and just returns a localized @"None".
    @param		text is basically a NSText instance.
    @result		A human readable name.
*/
- (NSString *)spellPrettyProjectNameForText:(NSText *)text;

@end

/*! 
    @class	iTM2SpellCheckerController
    @abstract	Object that really manages the spelling. 
    @discussion	There is only one such object in the app.
                This object extends the spell checking model of cocoa.
                In version 10.2.8, as I write this documentation,
                spell checking is left under the responsibility of the developer.
                The default behaviour is an application wide language choice.
                The purpose here is to implement a more general and more apropriate behaviour.
                Each text view is given the possibility to have its own language and spell checking data
                (essentially the list of ignored words) named a "spelling context".
                Each time a text view becomes first responder,
                the spell checker parameters to fit its needs according to its spelling context.
*/

@interface NSObject(iTM2SpellKit)

/*!
    @method		spellContextController
    @abstract	The spelling context controller.
    @discussion	The spelling context is defined by the language, and the lists of know words.
                Each logically different context is defined by a unique NSString key.
                Many different texts can share the same spelling context,
                and a single text split can be made of different parts
                each one having its own different spelling contexts depending on the part of the text.
                Any object has at least the shared spell context controller.
                A NSText object inherits its spelling context controller from its window.
                A NSWindow object inherits its spelling context controller from its window controller.
                A NSWindowController object inherits its spelling context controller
                from its document if any or from its owner if any.
                All these default behaviours might be overriden by subclassers.
    @parameter	None.
    @result		A spell context controller.
*/
- (id)spellContextController;

@end

/*!
    @category	NSText(iTM2SpellKit)
    @abstract	The spelling support.
    @discussion	The spelling context is retrieved from the document with a private method
                that complies the TeX Wrapper Structure specifications version 1.
*/

@interface NSText(iTM2SpellKit)

/*!
    @method		spellContextController
    @abstract	The spelling context controller.
    @discussion	This is basically the one of its window,
                which is the one of its window controller,
                which is the one of its document or owner,
                which is the default spell context controller unless subclassers have overriden the default behaviour...
    @result		an iTM2SpellContextController instance.
*/
- (id)spellContextController;

/*!
    @method		spellContext
    @abstract	The spell context.
    @discussion	This default implementation just asks the meta property server to do the job.
                Given a mode name, iTeXMac2 can retrieve a language and a list of know words.
    @param		None.
    @result		The new mode.
*/
- (iTM2SpellContext *)spellContext;

/*!
    @method		spellPrettyName
    @abstract	The pretty name.
    @discussion	This default implementation just asks the spell context controller to do the job.
    @param		None.
    @result		The human readable name.
*/
- (NSString *)spellPrettyName;

/*!
    @method		spellPrettyProjectName
    @abstract	The pretty project name.
    @discussion	This default implementation just asks the spell context controller to do the job.
    @param		None.
    @result		The human readable project name.
*/
- (NSString *)spellPrettyProjectName;

/*!
    @method		spellContextController
    @abstract	The spell context mode.
    @discussion	Given a mode name, iTeXMac2 can retrieve a language and a list of know words.
    @param		None.
    @result		The new mode.
*/
- (NSString *)spellContextMode;

/*!
    @method		setSpellContextMode:
    @abstract	Set the spelling context mode.
    @discussion	This default implementation just asks the meta property server to do the job.
    @param		The new mode.
    @result		None.
*/
- (void)setSpellContextMode:(NSString *)mode;

@end

#define SCH [iTM2SpellCheckerHelper sharedHelper]

/*!
    @class		iTM2SpellCheckerHelper
    @abstract	Extending cocoa spell checker.
    @discussion	There is only one spell checker, so there is only one spell checker helper.
                This object will manage the accessory view of the spell checker panel and
                the shared ignored words editor window.
                Some technical note on the spell management.
				Instances of this class have a private iTM2Implementation, such that you can uise metaGETTER and metaSETTER tricks.
*/
@interface iTM2SpellCheckerHelper: NSWindowController
{
@private
    id			_iVarPrivateImplementation;
}
/*!
    @method		sharedHelper
    @abstract	The shared instance.
    @discussion	There is only one spell checker, so there is only one spell checker helper.
    @result		The shared instance....
*/
+ (id)sharedHelper;

/*!
    @method		synchronizeWithCurrentText
    @abstract	Abstract forthcoming.
    @discussion	Description forthcoming. This code is reentrant.
    @param		None.
    @result		None.
*/
- (void)synchronizeWithCurrentText;

/*!
    @method		spellCheckerAccessoryView
    @abstract	Abstract forthcoming.
    @discussion	Description forthcoming.
    @param		None.
    @result		A spell checker accessory view.
*/
- (NSView *)spellCheckerAccessoryView;

/*!
    @method		setSpellCheckerAccessoryView:
    @abstract	Abstract forthcoming.
    @discussion	Description forthcoming.
    @param		view is the new view.
    @result		None.
*/
- (void)setSpellCheckerAccessoryView:(NSView *)view;

/*!
    @method		editIgnoredWords:
    @abstract	Message sent to edit the list of ignored words.
    @discussion	Description forthcoming.
    @param		An irrelevant sender....
*/
- (void)editIgnoredWords:(id)sender;

/*!
    @method		selectMode:
    @abstract	Message sent when a new mode has been chosen.
    @discussion	Description Forthcoming.
    @param		An irrelevant sender...
*/
- (void)selectMode:(id)sender;

/*!
    @method		newMode:
    @abstract	Message sent when a new mode has been added.
    @discussion	Description Forthcoming.
    @param		An irrelevant sender...
*/
- (void)newMode:(id)sender;

/*!
    @method		newModeEdited:
    @abstract	Message sent when a new mode has been edited.
    @discussion	Description Forthcoming.
    @param		An irrelevant sender...
*/
- (void)newModeEdited:(id)sender;

/*!
    @method		removeSpellingModeFromRepresentedObject:
    @abstract	Message sent when a mode should be removed.
    @discussion	Description Forthcoming.
    @param		An irrelevant sender...
*/
- (void)removeSpellingModeFromRepresentedObject:(id)sender;

@property (retain) id			_iVarPrivateImplementation;
@end

@interface NSObject(CUDUORT)
/*!
    @method		spellModeForFileKey:
    @abstract	The spelling mode for the given key.
    @discussion	Defines the one to many mapping: mode -> key.
    @param		key is a unique identifier for a file. There is an indirection layer to allow an efficient management of the change in path. It is the job of the file controller of the owner to maintain the on to one correspondance between the file names and the keys. The spelling model does not know anything about those file names.
    @result		A spelling mode.
*/
- (NSString *)spellModeForFileKey:(NSString *)key;

/*!
    @method		addFileKey:toSpellMode:
    @abstract	Adds the given key to the given spelling mode.
    @discussion	The key represents a file, this means that this file is given a new spelling mode.
    @param		key is a unique identifier for a file.
    @param		mode is a NSString uniquely identifying a set of spelling parameters. The mode must exist prior to this message.
    @result		A flag indicating in an obvious manner the success or failure of the operation.
*/
- (BOOL)addFileKey:(NSString *)key toSpellMode:(NSString *)mode;

/*!
    @method		removeFileKey:fromSpellMode:
    @abstract	Removes the given key from the given spelling mode.
    @discussion	The key represents a file, this means that this file will no longer have the spelling parameters identified by mode. Instead they will have the default mode, unless the previous method is used.
    @param		key is a unique identifier for a file.
    @param		mode is a NSString uniquely identifying a set of spelling parameters. The mode must exist prior to this message.
    @result		A flag indicating in an obvious manner the success or failure of the operation.
*/
- (BOOL)removeFileKey:(NSString *)key fromSpellMode:(NSString *)mode;

/*!
    @method		isEdited
    @abstract	Indicates whether the receiver has been edited.
    @discussion	Mimics NSDocument.
    @result		A flag indicating in an obvious manner if the receiver has been edited.
*/
- (BOOL)isEdited;

/*!
    @method		updateChangeCount:
    @abstract	Updates the change count of the receiver.
    @discussion	This method should be called in exactly the same situation than for the eponym method of the NSDocument class.
    @param		The same argument as the one for the eponym NSDocument message.
*/
- (void)updateChangeCount:(NSDocumentChangeType)change;

/*!
    @method		project
    @abstract	The project associate to the receiver.
    @discussion	The project of the owner if any, nil otherwise.
    @result		A project document is expected to have a filesController.
*/
- (id)project;

@end

@interface iTM2IgnoredWordsWindow: NSWindow
@end

@interface NSSpellChecker(iTM2SpellKit)

/*!
    @method		currentText
    @abstract	The current text being spelled.
    @discussion	Discussiopn forthcoming.
    @param		None.
    @result		A NSText instance, not retained.
*/
- (id)currentText;

@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2SpellContext
