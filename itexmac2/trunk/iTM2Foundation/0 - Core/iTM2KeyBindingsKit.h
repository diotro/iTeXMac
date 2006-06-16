/*
//
//  @version Subversion: $Id$ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Mon Oct 6 11 2003.
//  Copyright © 2003-2004-2005 Laurens'Tribune. All rights reserved.
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

#import <iTM2Foundation/iTM2ResponderKit.h>

@class NSDictionay, NSMutableArray, NSEvent, NSTextView;

/*!
    @const		iTM2KeyBindingsComponent
    @abstract	Key bindings component key: @"KeyBindings".
    @discussion	Key bindings are stored at various "Application Support/iTeXMac2/KeyBindings" locations.
				In the built in resources forlder are available only the "KeyBindings" preferably localized.
*/

extern NSString * const iTM2KeyBindingsComponent;

/*!
    @const		iTM2TextKeyBindingsIdentifier
    @abstract	Text Key bindings name key.
    @discussion	The key for an identifier for the text.
*/

extern NSString * const iTM2TextKeyBindingsIdentifier;

/*!
    @const		iTM2PDFKeyBindingsIdentifier
    @abstract	PDF Key bindings name key.
    @discussion	The key for an identifier for the PDF viewer.
*/

extern NSString * const iTM2PDFKeyBindingsIdentifier;

/*!
    @const		iTM2NoKeyBindingsIdentifier
    @abstract	No key bindings key.
    @discussion	Context key for a bool value indicating whether key bindings is available in the current context.
                Remember that contexts in iTeXMac2 are
                - application wide: the user defaults database
                - project wide
                - document wide
                - object wide
                this is also a hierarchy, such that when a value is not found in one context, the next context is asked for.
                See the iTM2ContextKit for more details.
*/

extern NSString * const iTM2NoKeyBindingsIdentifier;

/*!
    @const		iTM2KeyStrokeIntervalKey
    @abstract	Key stroke interval key.
    @discussion	A float value in the user defaults data base that drives the time interval
                to wait before automatically flush the key stroke stack.
                Remember that key strokes are stacked a la Reverse Polish Notation (to allow treatment of mutiple keys),
                except that the stack is flushed every key stroke interval seconds.
*/

extern NSString * const iTM2KeyStrokeIntervalKey;

/*!
    @class		iTM2KeyBindingsManager
    @abstract	Key binding manager.
    @discussion	A key binding manager stores a hierarchy of dictionaries which keys are keystroke.
                A combination of keystrokes corresponds to a string or  amacro to be inserted in some text.
                Key binding dictionaries are stored at different locations, built in or not.
                They are cached such that different client will share the same dictionary.
*/

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  iTM2KeyBindingsManager

@interface iTM2KeyBindingsManager: NSObject
{
@private
    NSDictionary * _SM;
    NSDictionary * _RKB;
    NSMutableArray * _KBS;
    NSString * _CK;
    NSString * _DEC;
    NSString * _EC;
    id _CC;
    struct __iTM2IMFlags
    {
        unsigned int handlesKeyBindings: 1;
        unsigned int handlesKeyStrokes: 1;
        unsigned int isDeepEscaped: 1;
        unsigned int isEscaped: 1;
        unsigned int isPermanent: 1;
        unsigned int canEscape: 1;
        unsigned int reserved: 26;
    } _iTM2IMFlags;
}

/*!
    @method		addKeyStrokeSelectorsFromDictionary:
    @abstract	Add the key stroke selectors.
    @discussion	This is an entry point to let 3rd party add support for more key strokes.
                There is a list of built in hard coded key strokes,
                but this can be used to override and extend the supported key strokes.
    @param		D is a key stroke selectors dictionary.
    @result		None.
*/
+(void)addKeyStrokeSelectorsFromDictionary:(NSDictionary *)D;

/*!
    @method		keyBindingsForIdentifier:
    @abstract	The eventually cached key binding dictionary for the given identifier.
    @discussion	Here are the rules for the identifier.
                - if the identifier start with a "./":
                we look for a file named dirName/identifier where dirName is
                the name of the project folder containing key bindings, basically
                foo.texp/Frontends/comp.text.tex.iTeXMac2/Key bindings
                - if the identifier starts with "~"~or "/":
                The identifier is meant to be a full path name where a key binding dictionary could be found.
                - in any other situation, we look for the first existing file amongst
                DOMAIN/Library/Application Support/APP_NAME/Key bindings/identifer
                where DOMAIN loops into ~, /, /Network, iTM2Foundation bundle built in resources
                APP_NAME is the name of the main app currently running.
    @param		An NSString identifier.
    @result		A dictionary.
*/
+(id)keyBindingsForIdentifier:(NSString *)identifier;

/*!
    @method		selectorMapForIdentifier:
    @abstract	Abstract forthcoming.
    @discussion	Discussion forthcoming.
    @param		identifier.
    @result		A dictionary.
*/
+(id)selectorMapForIdentifier:(NSString *)identifier;

/*!
    @method		registerKeyBindingsForIdentifier:
    @abstract	Register the key bindings for identifier, starting from the given app bundle,
				scanning all the frameworks, plugins and Library locations.
				See the allPaths:... messages of the iTM2BundleKit to have the search path.
    @discussion	Discussion forthcoming.
    @param		identifier.
    @result		None.
*/
+(void)registerKeyBindingsForIdentifier:(NSString *)identifier;

/*!
    @method		initWithIdentifier:handleKeyBindings:handleKeyStrokes:
    @abstract	Abstract forthcoming.
    @discussion	Discussion forthcoming.
    @param		None.
    @result		A dictionary.
*/
-(id)initWithIdentifier:(NSString *)identifier handleKeyBindings:(BOOL)handlesKeyBindings handleKeyStrokes:(BOOL)handlesKeyStrokes;

/*!
    @method		rootKeyBindings
    @abstract	The root key bindings.
    @discussion	The root of the dictionary hierarchy.
                Contains the first char of any keystroke sequence.
    @param		None.
    @result		A dictionary.
*/
-(NSDictionary *)rootKeyBindings;

/*!
    @method		currentKeyBindings
    @abstract	The current key binding.
    @discussion	Some keystrokes can imply loading another key bindings dictionary.
                The next keystroke will be understood within the context of this dictionary.
    @param		None.
    @result		None.
*/
-(NSDictionary *)currentKeyBindings;

/*!
    @method		client:performKeyEquivalent:
    @abstract	The given client wants the receiver to perform a key equivalent...
    @discussion	If the receiver is not in escape or deep escape mode,
                it tries to interpret the given event if it is a key down one.
    @param		C is the client.
    @param		theEvent is the event.
    @result		NO iff this event could not be interpreted.
*/
-(BOOL)client:(id)C performKeyEquivalent:(NSEvent *)theEvent;

/*!
    @method		client:performMnemonic:
    @abstract	The given client wants the receiver to perform a mnemonic...
    @discussion	If the receiver is not in escape or deep escape mode,
                it tries to interpret the given mnemonic.
                This is sent from the NSWindow preforMnemonic: method, if key bindings are available.
    @param		C is the client.
    @param		theString is the string.
    @result		NO iff this string could not be interpreted as a mnemonic.
*/
-(BOOL)client:(id)C performMnemonic:(NSString *)theString;

/*!
    @method		client:interpretKeyEvent:
    @abstract	The given client wants the receiver to interpret the given key event..
    @discussion	The key event is transformed into a string. The last character is the key pressed and
                the previous ones are the modifiers. In the following order,
                - "@" stands for the command key,
                - "^" stands for the control key,
                - "~" stands for the option key,
                - "$" stands for the shift key,
                - "#" stands for the numeric pad key, not yet supported
                - "?" stands for the help key, not yet supported
                NSAlphaShiftKeyMask, NSFunctionKeyMask, not yet supported.
    @param		C is the client.
    @param		theEvent is the event.
    @result		NO iff this event could not be interpreted..
*/
-(BOOL)client:(id)C interpretKeyEvent:(NSEvent *)theEvent;

/*!
    @method		client:executeInstruction:
    @abstract	The receiver will execute the given instruction for the given client.
    @discussion	If the instruction is an array, each object is executed separately.
                If the instruction is a dictionary, the value for key "selector" is executed
                with the value for key "argument" as argument. If the client cannot execute this instruction,
                the receiver itself will try to. If you want to add support for another kind oif instruction,
                either make your client support this instruction or make the receiver support it.
                If the instruction is simply a string, it is inserted in the text stream.
    @param		C is the client.
    @param		theEvent is the event.
    @result		NO iff this instruction could not be executed..
*/
-(BOOL)client:(id)C executeInstruction:(id)instruction;

/*!
    @method		toggleEscape:
    @abstract	Toggle the escape mode.
    @discussion	In escape mode, no key binding is active and the next keystroke will act as usual.
    @param		irrelevant sender.
    @result		None.
*/
-(IBAction)toggleEscape:(id)sender;

/*!
    @method		toggleDeepEscape:
    @abstract	Toggle the deep escape mode.
    @discussion	In escape mode, no key binding is active and the all the keystroke will act as usual
                until the deep escape mode is toggled once more..
    @param		irrelevant sender.
    @result		None.
*/
-(IBAction)toggleDeepEscape:(id)sender;

/*!
    @method		flushKeyBindings:
    @abstract	Flush the cached key bindings.
    @discussion	Useful when the key binings have been edited externally.
    @param		irrelevant sender.
    @result		None.
*/
-(void)flushKeyBindings:(id)irrelevant;

/*!
    @method		escapeCurrentKeyBindingsIfAllowed
    @abstract	Abstract forthcoming.
    @discussion	Description forthcoming.
    @param		None.
    @result		None.
*/
-(void)escapeCurrentKeyBindingsIfAllowed;

@end

@interface NSResponder(iTM2KeyBindingsKit)

/*!
    @method		executeInstruction:
    @abstract	Execute the given instruction.
    @discussion	This is one of the central methods to enhance Mac OS X key binding mechanism.
                Here we can not only send messages as Mac OS X can do, but we can also use methods with parameters.
                Those parameters are property list objects which covers a great range of possibilities.
    @param		An instruction.
    @result		A flag indicating whether the receiver has executed the given instruction.
*/
-(BOOL)executeStringInstruction:(NSString *)instruction;
-(BOOL)tryToExecuteStringInstruction:(NSString *)instruction;

/*!
    @method		keyBindingsManager
    @abstract	This is the key binding manager.
    @discussion	The default implementation just returns next responder's key bindings manager.
                NSWindow's implementation returns its window controller's key binding manager.
                NSView's implementation returns the first one found amongst
                - its next responder's key bindings manager,
                - its superview's key bindings manager,
                - its window's key binding manager.
                This is a default implementation because each object is expected to have its own key bindings manager.
                In general, you subclass NSWindowController to return a valid key bindings manager.
                You can also create a responder dedicated to key binding management
                and insert it in the responder chain of a window controller or window.
                This latter design is closer to a delegation design and makes code more reusable
                (but possibly more expensive)
    @param		None
    @result		a key binding manager.
*/
-(id)keyBindingsManager;

/*!
    @method		keyBindingsManagerForClient:
    @abstract	This is the key binding manager for the given client.
    @discussion	The default implementation just returns next responder's key bindings manager for the given client.
                NSWindow's implementation returns its window controller's key binding manager for the given client.
                NSView's implementation returns the first one found amongst
                - its next responder's key bindings manager,
                - its superview's key bindings manager,
                - its window's key binding manager
				all for the given client.

    @param		client is a NSResponder...
    @result		a key binding manager.
*/
-(id)keyBindingsManagerForClient:(id)client;

-(id)keyBindingsManagerWithIdentifier:(NSString *)identifier;
-(id)lazyKeyBindingsManager;

@end

@interface NSText(iTM2KeyBindingsKit)

/*!
    @method		executeInstruction:
    @abstract	Execute the given instruction.
    @discussion	If the inherited method does not work, and if the given instruction is a string,
                it just insert this string using insertText: and returns YES.
    @param		An instruction.
    @result		A flag indicating whether the receiver has executed the given instruction.
*/
-(BOOL)executeStringInstruction:(NSString *)instruction;

@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  iTM2KeyBindingsManager

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= NSResponder(iTM2KeyStrokeKit)

/*
    @class		NSResponder(iTM2KeyStrokeKit)
    @abstract	See the PDF window implementation to see an example of key stroke use.
                Basically, on a non text view or window, you enter for example "123\n"
                and the page 123 is display, if you enter "123%" the current page is displayed at 123%
                You can see that we have to record the numerics until we enconter a control character (here \n or %)
                to take the appropriate action. Here we define this stacking process.
                Basically, the key binding will define a key->interpretKeyStroke: event
    @discussion	Discussion forthcoming
*/
@interface NSResponder(iTM2KeyStrokeKit)

/*
    @method		keyStrokeEvents
    @abstract	Abstract forthcoming
    @discussion	Discussion forthcoming
    @param		None
    @result		None
*/
-(id)keyStrokeEvents;

/*
    @method		keyStrokes
    @abstract	The key strokes
    @discussion	Discussion forthcoming
    @param		None
    @result		None
*/
-(NSString *)keyStrokes;

/*
    @method		pushKeyStrokeEvent:
    @abstract	Pushes the givent event on the stack
    @discussion	Discussion forthcoming
    @param		event
    @result		None
*/
-(void)pushKeyStrokeEvent:(NSEvent *)event;

/*
    @method		pushKeyStroke:
    @abstract	Pushes the given key on the stack
    @discussion	Discussion forthcoming
    @param		key
    @result		None
*/
-(void)pushKeyStroke:(NSString *)key;

/*
    @method		flushKeyStrokeEvents:
    @abstract	Flush the key stroke event stack.
    @discussion	This message is sent 5 second after the last time a key stroke event was pushed.
                The time interval is driven by the user defaults float: iTM2KeyStrokeInterval in seconds?
    @param		an irrelevant sender
    @result		None
*/
-(void)flushKeyStrokeEvents:(id)sender;

/*
    @method		flushLastKeyStrokeEvent:
    @abstract	Flush the last key stroke event.
    @discussion	Discussion forthcoming
    @param		an irrelevant sender
    @result		None
*/
-(void)flushLastKeyStrokeEvent:(id)sender;

/*
    @method		selectorFromKeyStroke:
    @abstract	The selector corresponding to the given key stroke.
    @discussion	Things will be clear on an example:
                If the receiver has to interpret the @"q" key stroke,
                it will look for an interpretKeyStrokeq: selector to which it passes the control if it exists.
                For non letter key strokes, selectors are named differently,
                for example @"=" correponds to interpretKeyStrokeEquals:,
                see the source for the mapping.
    @param	    The key stroke is expected to be a 1 length string
    @result     a selector
*/
+(SEL)selectorFromKeyStroke:(NSString *)key;

/*
    @method		interpretKeyStroke:
    @abstract	Interpret the given key stroke
    @discussion	Turns the key stroke into a selector using the -selectorFromKeyStroke: method
				and let the receiver -tryToReallyPerform:with:.
				If this does not return YES, the selector is mapped into a translated selector through the receiver's selector map.
				Then -tryToReallyPerform:with: is tried once again.
    @param      The key stroke is expected to be a 1 length string.
    @result     yorn
*/
-(BOOL)interpretKeyStroke:(NSString *)key;

/*
    @method		tryToReallyPerform:with:
    @abstract	Try to really perform the given selector with the given argument
    @discussion	There is a subtle difference between the standard tryToPerform:with: method and the one defined here.
                The selector is expected to have the following signature:
                - (BOOL) selector: (id) sender;
                A responder will really perform the selector if it responds to it AND return YES.
                This is some kind of conditional tryToPerform:with:
                As usual, the window and application objects also ask their delegates.
                The window ends up asking its window controller.
                The document is not asked for because it is a model controller, not a view controller.
    @param		action is a selector
    @param		argument is an object argument
    @result		yorn
*/
-(BOOL)tryToReallyPerform:(SEL)action with:(id)argument;

@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= NSResponder(iTM2KeyStrokeKit)

/*
    @class		NSObject(iTM2KeyStrokeKit)
    @abstract	The interpretKeyStroke: is overriden
    @discussion	Discussion forthcoming
*/
@interface NSObject(iTM2KeyStrokeKit)

/*
    @method     handlesKeyStrokes
    @abstract	Whether the receiver interprets key strokes.
    @discussion	The default implementation returns NO,
                subclassers responding YES will benefit the key stroke implementation.
                The default implementation returns NO for window controllers owners and documents.
                For windows, it asks the window controller.
    @param	    None
    @result     yorn
*/
-(BOOL)handlesKeyStrokes;

/*
    @method     interpretKeyStroke:
    @abstract	Interpret the givent key stroke
    @discussion	If the inherited method returns NO, the key event is pushed on the stack for further use
                and YES is returned.
                The default implementation returns NO.
                Window controllers will forward the message to their document or their owner.
                The first one answering YES is used.
                The window will forward the message to the window controller.
				If the window controller does not handle the key stroke,
				the key stroke is pusehd on the window key stroke stack.
    @param	    The key stroke is expected to be a 1 length string
    @result     yorn
*/
-(BOOL)interpretKeyStroke:(NSString *)key;

/*
    @method     executeMacroWithIdentifier:
    @abstract	Execute the macro with the given identifier
    @discussion	Discussion forthcoming.
				The default implementation does nothing more than returning NO.
    @result     yorn
*/
-(BOOL)executeMacroWithIdentifier:(NSString *)key;

@end

/*
    @class      NSResponder(iTM2KeyBindingsKitSupport)
    @abstract	The methods needed to support key binding
    @discussion	Discussion forthcoming
*/

@interface NSResponder(iTM2KeyBindingsKitSupport)

/*
    @method		keyBindingsManagerIdentifier
    @abstract	Abstract frothcoming
    @discussion	Discussion forthcoming.
    @param		None
    @result		void string
*/
-(NSString *)keyBindingsManagerIdentifier;

/*
    @method		handlesKeyBindings
    @abstract	Whether the receiver can use key bindings
    @discussion	The default implementation returns NO. Should be subclassed.
                If subclassers are using the iTM2Implementation design, it is sufficient.
                The lazy intializer will use the identifier to create a new manager.
                If not, they will have to provide standard setter and getter.
    @param		None
    @result		yorn
*/
-(BOOL)handlesKeyBindings;

/*
    @method		keyBindingsManager
    @abstract	The key bindings manager
    @discussion	This is the required method to support key bindings and key stroke.
                The default implementation returns nil and should not to support key bindings.
                The window key binding manager is just the one of its window controller.
                It is not expected for a document to have a key binding manager.
                The window controller is expected to have a real key binding manager
                if it handles key strokes or uses a key binding manager.
    @param		None
    @result		a key binding manager.
*/
-(id)keyBindingsManager;

/*
    @method		flushKeyBindings:
    @abstract	Flust the key bindings
    @discussion	Optional method.
    @param		Irrelevant sender
    @result		None
*/
-(IBAction)flushKeyBindings:(id)irrelevant;

@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= NSWindow(iTM2KeyStrokeKit)

@interface NSWindowController(iTM2KeyBindingsKit)

-(NSString *)keyBindingsManagerIdentifier;
-(void)setKeyBindingsManager:(id)argument;

/*
    @method     handlesKeyStrokes
    @abstract	Whether the receiver interprets key strokes.
    @discussion	The default implementation returns NO,
                subclassers responding YES will benefit the key stroke implementation.
                The default implementation returns NO for window controllers owners and documents.
                For windows, it asks the window controller.
    @param	    None
    @result     yorn
*/
-(BOOL)handlesKeyStrokes;

@end

/*
    @class		the key bindings responder
    @abstract	Implements the -toggleNoKeyBindings: message
    @discussion	This responder is automatically installed unless
                the user defaults value for key @"iTM2NoKeyBindingsResponder" is YES.
*/

@interface iTM2KeyBindingsResponder: iTM2AutoInstallResponder
-(IBAction)toggleNoKeyBindings:(id)irrelevant;
@end
