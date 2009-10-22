/*
//
//  @version Subversion: $Id$ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Tue Sep 11 2001.
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

#import <iTM2TeXFoundation/iTM2TeXProjectDocumentKit.h>
#import <iTM2TeXFoundation/iTM2TeXProjectFrontendKit.h>

/*!
    @class      iTM2TeXPCommandsInspector
    @abstract   User interface for the engines
    @discussion Different points are discussed here.
                TeX Projects Names:
                They are constructed on the scheme base+output[variant].texp
                When no variant is given, it is assumed to be the word "Default"
                When no output is given, it is assumed to be the word "PDF"
                TeX Projects Properties:
                A dictionary of projects is cached. The keys are the lowercase dictionary containing base, ouput and variant.
                The objects are dictionaries containing the name and case sensitive properties.
				This inspector is the entry point to set
				what kind of engines a tex project is using to perform some basic operations on a file.
				In the GUI, there is a tab view with 3 panes
				- basic one to choose one of the built in projects and inherit behaviour from them.
				  From this pane, you choose the format, variant and output
				- Advanced one where you assign concrete actions to the menu item actions
				  A popup menu lets you choose what menu item action you are editing
				  Then you can choose a shell script for that shell script, either built in or customized
				  And for that shell script a set of parameters. We can edit these parameters with a dedicated inspector.
				  
				  NB: instead of using direct parameters for scripts I use environment variables.
				  Then I use a NSDictionary to store the environment variables,
				  and I can provide dedicated forms to edit these environment variables
				- Second advanced one where you can customize the way tex, ps, mp files are processed.
				  This panel is only suitable for compile engine.
                
*/

extern NSString * const TWSShellEnvironmentFrontKey;// only if the master key means "typeset the front document"
extern NSString * const TWSShellEnvironmentProjectKey;

#warning ! THESE should live somewhere else
extern NSString * const iTM2TPFEEnvironmentModeKey;
extern NSString * const iTM2TPFEScriptModeKey;

extern NSString * const iTM2TPFECommandsKey;
extern NSString * const iTM2TPFECommandEnvironmentsKey;
extern NSString * const iTM2TPFECommandScriptsKey;

extern NSString * const iTM2TPFEEnginesKey;// model
extern NSString * const iTM2TPFEEngineEnvironmentsKey;
extern NSString * const iTM2TPFEEngineScriptsKey;

@interface NSArray(iTM2TeXProjectCommandKit)
- (NSArray *)filteredArrayUsingPredicateValue:(NSString *)value forKey:(NSString *)key;
@end

@interface iTM2TeXPCommandsInspector: iTM2Inspector
@end

@interface iTM2TeXPXtdCommandsInspector: iTM2TeXPCommandsInspector
@end


/*! 
    @class      iTM2TeXPCommandsWindow
    @abstract   Abstract forthcoming.
    @discussion Discussion forthcoming.
*/
@interface iTM2TeXPCommandsWindow: iTM2Window
@end

/*! 
    @class      iTM2TeXPCommandInspector
    @abstract   Abstract forthcoming.
    @discussion If you write your own command inspector, you must make it +initialized unless it will not be registered.
				The built in command inspectors are +initialized in the +load method of the iTM2TeXProjectInspector.
				This information might be obsolete. See the source code for more details.
*/
@interface iTM2TeXPCommandInspector : iTM2TeXProjectInspector

/*!
    @method     classForMode:
    @abstract   A command inspector class for the given mode
    @discussion Discussion forthcoming.
    @param      An action key
    @result     An autoreleased command inspector
*/
+ (id)classForMode:(NSString *)action;

/*!
    @method     commandName
    @abstract   The command name of the receiver
    @discussion Class names are expected to match the pattern "iTM2TeXProject(.*)".
				The command name is just \1 (the trailing part after "iTM2TeXProject" string)
    @param      None
    @result     A command name
*/
+ (NSString *)commandName;

@end

extern NSString * const iTM2EnvironmentVariablesKey;
extern NSString * const iTM2FactoryEnvironmentVariablesKey;

@class iTM2TaskWrapper, iTM2TaskController;
/*! 
    @class      iTM2TeXPCommandManager
    @abstract   The central object that manages commands.
    @discussion This object is responsible of the various commands iTeXMac2 knows of.
				This is two folded. The list of commands will appear in the user interface at various places,
				and the user will be able to launch them.
				A command is a subclass of iTM2TeXPCommandPerformer, named iTM2TeXPXXXXXPerformer where XXXXX is the name of the command.
				You can create as many commands as you want.
*/
@interface iTM2TeXPCommandManager: NSObject

/*!
    @method     setupTeXMenu
    @abstract   Fix the TeX menu
    @discussion Discussion forthcoming.
    @param      None
    @result     None
*/
+ (void)setupTeXMenu;

/*!
    @method     commandPerformerForName:
    @abstract   The command performer for the given name
    @discussion This method extracts the name of the command from the name of the class.
    @param      None
    @result     A subclass object
*/
+ (id)commandPerformerForName:(NSString *)name;

/*!
    @method     orderedBuiltInCommandNames
    @abstract   The ordered built in command names
    @discussion Description forthcoming
	@param      None
    @result     A name
*/
+ (NSArray *)orderedBuiltInCommandNames;

/*!
    @method     builtInCommandNames
    @abstract   The built in command names
    @discussion Description forthcoming
	@param      None
    @result     A name
*/
+ (NSArray *)builtInCommandNames;

@end

/*! 
    @class      iTM2TeXPCommandPerformer
    @abstract   The central object that performs commands.
    @discussion This object is responsible of one of the commands iTeXMac2 knows of.
				The environment must be correctly set when the commands are launched.
				Basically what is a command?
				This can be thought of a pair consisting of a shell script and an environment.
				When the command manager is asked to launch a command, it prepares the environment,
				then launches the script.
				The script and environment management is rather complicated
				to allow a better customization and user management.
				All the shell scripts dedicated to iTeXMac2 should have their name prefixed with "iTM2_".
				iTeXMac2 is shipped with a list of built in shell scripts such that in general,
				there is no need to deal with shell scripts, only environments.
				The shell scripts are located in various places, and appear in that order in the search list
				- .iTM2/bin(to be changed into $iTM2_dotFolder/bin)
				- ~/Library/Application Support/iTeXMac2/bin
				- ~/Library/TeX/bin
				- /Library/Application Support/iTeXMac2/bin
				- /Library/TeX/bin
				- /Network/Library/Application Support/iTeXMac2/bin
				- /Network/Library/TeX/bin
				- iTeXMac2.app executable path
				iTeXMac2 application support binaries take precedence with respect to the others
				User domain take precedence with respect to the others.
				If a TeX project document defines pivate shell scripts,
				they will be transmitted to the launcher through the environment.
				The launcher scans all the environment variable names for names matching the extended regexp iTM2_ShellScript_(.*)
				then it copies the contents in .iTM2/bin, in shell scripts named iTM2_\1
				(for example echo "${iTM2_ShellScript_Command_0}" > ".iTM2/bin/iTM2_Command_0")
				Then the manager sends the appropriate command to the launcher, for example the command
				[fermat:~] jlaurens% iTM2_Launch Compile
				will let iTM2_Launch perform a $iTM2_Compile whatever the contents of this environemnt variable can be.
				The manager is supposed to fill the iTM2_??? environment variable with the name of a script to be executed.
				Just before the manager launches the command, it collects the environment dictionary from the command performers.
				There are 2 parts to give different entry points to subclassers.
				In fact, many documents are supposed to share the same shell scripts.
				Moreover, the shell scripts are subject to change when new versions of TeX engines are shipped.
				For that reasons, base settings are stored in base projects.
				Base projects are stored at different places. They should be edited only by administrators.
				Each user defined project has a base project where it can find its default settings and actions.
				When actions change, the user do not have to change its own project
				because the base one will automatically take the update into account.
				This is extremely powerful and efficient but somewhat difficult to manage.
				In general, the manager uses the base project to fill all the settings,
				then the manager lets the project override the values it has overriden.
				For example, the base project defines its own Compile process and
				the iTM2_Compile environment variable will be defined accordingly.
				If the project just uses the base settings, it will leave this environment variable untouched.
				If it uses customized settings, it will fill this environment variable with an appropriate value,
				thus overriding the inherited settings. The same holds for the environment.
				However, there is a problem concerning the customized scripts.
				If a project defines customized scripts, there might be a name conflict that could cause unexpected and unwxanted problems.
				First, custom shell scripts, within one project, are identified by a 0 based tag number.
				If both a project and its base project define custom scripts, we end with two different shell scripts with the same identifier.
				Second, the customized shell scripts of the base projects are not meant to be overriden nor inherited.
				The customized shell scripts end with names iTM2_Command_? (or iTM2_BaseCommand_? if they come from the base project)
				where "?" is just the tag identifier of the shell script.
				Today is: Thu Oct 28 10:38:30 GMT 2004
*/
@interface iTM2TeXPCommandPerformer: NSObject<NSCoding>

/*!
    @method     commandName
    @abstract   The command name of the receiver
    @discussion The class object is expected to have a name iTM2???CommandPerformer where ??? is the name of the command.
				This method extracts the name of the command from the name of the class.
    @param      None
    @result     An integer
*/
+ (NSString *)commandName;

/*!
    @method     commandGroup
    @abstract   The command group priority of the receiver
    @discussion It is used to sort the commands in the various menus where they appear.
				A 0 priority means ignore the command, this is the default implementation
				Each commands with the same command group in a menu are gathered,
				each group being separated by a separator item.
				The bundle of the receiver is expected to contain a commands.strings property list.
				The integer value for key "commandName.group" is checked.
				NB: developpers should use the _commandGroup and override the commandGroup
    @param      None
    @result     An integer
*/
+ (NSInteger)commandGroup;

/*!
    @method     commandLevel
    @abstract   The command priority of the receiver
    @discussion It is used to sort the commands in the various menus where they appear.
				Inside each group, commands are ordered according to their levels.
				The bundle of the receiver is expected to contain a commands.strings property list.
				The integer value for key "commandName.level" is checked.
				Each group is separated by a separator item.
				NB: developpers should use the _commandLevel and override the commandLevel
    @param      None
    @result     An integer
*/
+ (NSInteger)commandLevel;

/*!
    @method     localizedNameForName:
    @abstract   The localized name
    @discussion The bundle of the receiver is expected to contain a commands.strings property list
				with the localized title for the receiver's command name as key.
    @param      None
    @result     A NSString
*/
+ (NSString *)localizedNameForName:(NSString *)name;

/*!
    @method     menuItemTitleForProject:
    @abstract   The menu item title
	@discussion Discussion forthcoming.
    @param      project
    @result     A NSString
*/
+ (NSString *)menuItemTitleForProject:(id)project;

/*!
    @method     keyEquivalentForName:
    @abstract   The key equivalent
    @discussion The bundle of the receiver is expected to contain a commands.strings property list.
				The value for key "commandName.keyEquivalent" is the result.
				@"" is the default.
    @param      Name
    @result     A NSString
*/
+ (NSString *)keyEquivalentForName:(NSString *)commandName;

/*!
    @method     keyEquivalentModifierMaskForName:
    @abstract   The key equivalent modifier mask
    @discussion The bundle of the receiver is expected to contain a commands.strings property list.
				The bool value for key "commandName.is???" is checked.
				Accepted keys are
				- "commandName.isAlternate", accepted values are @"YES" and @"NO", default is @"NO"
				- "commandName.isControl", accepted values are @"YES" and @"NO", default is @"NO"
				- "commandName.isShift", accepted values are @"YES" and @"NO", default is @"NO"
				- "commandName.isCommand", accepted values are @"YES" and @"NO", default is @"YES"
    @param      Name
    @result     flags
*/
+ (NSUInteger)keyEquivalentModifierMaskForName:(NSString *)commandName;

/*!
    @method     launchAction:withEngine:forMaster:ofProject:
    @abstract   Abstract forthcoming
    @discussion Public API not yet implemented
    @param      Irrelevant sender
    @result     None
*/
+ (void)launchAction:(NSString *)action withEngine:(NSString *)engine forMaster:(NSString *)master ofProject:(NSString *)project;

/*!
    @method     performCommand:
    @abstract   Abstract forthcoming
    @discussion Private API
    @param      Irrelevant sender
    @result     None
*/
+ (void)performCommand:(id)sender;

/*!
    @method     validatePerformCommand:
    @abstract   Abstract forthcoming
    @discussion Private API
    @param      sender
    @result     None
*/
+ (BOOL)validatePerformCommand:(id <NSMenuItem>)sender;

/*!
    @method     performCommandForProject:
    @abstract   Abstract forthcoming
    @discussion Private API
    @param      project sender
    @result     None
*/
+ (void)performCommandForProject:(iTM2TeXProjectDocument *)project;

/*!
    @method     canPerformCommandForProject:
    @abstract   Abstract forthcoming
    @discussion Private API
    @param      project sender
    @result     None
*/
+ (BOOL)canPerformCommandForProject:(iTM2TeXProjectDocument *)project;

/*!
    @method     doPerformCommandForProject:
    @abstract   Abstract forthcoming
    @discussion Private API
    @param      project sender
    @result     None
*/
+ (void)doPerformCommandForProject:(iTM2TeXProjectDocument *)project;

/*!
    @method     taskWrapperDidPerformCommand:taskController:userInfo:
    @abstract   Abstract forthcoming
    @discussion Private API
    @param      Irrelevant sender
    @result     None
*/
+ (void)taskWrapperDidPerformCommand:(iTM2TaskWrapper *)TW taskController:(iTM2TaskController *)TC userInfo:(id)userInfo;


/*!
    @method     mustSaveProjectDocumentsBefore
    @abstract   Abstract forthcoming
    @discussion Discussion forthcoming. No for the STOP command, YES for the compile one...
    @param      None
    @result     yorn.
*/
+ (BOOL)mustSaveProjectDocumentsBefore;

@end
