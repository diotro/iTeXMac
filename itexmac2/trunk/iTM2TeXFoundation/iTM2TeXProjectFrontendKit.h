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
#import <iTM2TeXFoundation/iTM2TeXDistributionKit.h>
//#import <iTM2Foundation/iTM2WindowKit.h>

extern NSString * const iTM2TPFEContentKey;

extern NSString * const iTM2TeXProjectSettingsInspectorMode;
extern NSString * const iTM2TeXProjectTerminalInspectorMode;
extern NSString * const iTM2TeXProjectNoTerminalBehindKey;
extern NSString * const iTM2TeXProjectFrontendTable;
extern NSString * const iTM2TeXProjectExtendedInspectorVariant;

extern NSString * const iTM2TPFEFilePropertiesKey;

extern NSString * const iTM2TPFEBaseProjectNameKey;

extern NSString * const iTM2TPFEVoidMode;
extern NSString * const iTM2TPFECustomMode;
extern NSString * const iTM2TPFEBaseMode;

extern NSString * const iTM2TeXProjectDefaultBaseNameKey;

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2TeXProjectFrontendKit

/*! 
	@class		iTM2TeXProjectDocument(Frontend)
    @abstract   Abstract forthcoming.
    @discussion Here are a few notes about actions.
                There are a finite number of preset actions to compile, typeset,
                make the bibliography, the index, the glossary, clean, special.
				There is a finite list of built in actions defined by iTeXMac2,
				they are given by their names in +builtInCommands.
				Default command names are:
				"Compile", "Typeset", "Index", "Bibliography", "Glossary", "Clean", "Special", "Archive"
				The Archive command will be suported after the others (and will appear in the GUI).
				We have the following organisation for each command
				Command -> script		-> contents (shell script)
										-> inspector
						-> environment  -> contents (dictionary)
										-> inspector
				There are indirection tables accessed through "modes".
				Here is a more detailed documetation of the implementation:
				Each command is identified by its name, and -is- implemented as its own name.
				To each command corresponds a script mode as the result of -scriptMode for the command wrapper
				and an environment mode as the result of -environmentMode for the command wrapper.
				Both commands have their setter counterparts.
                Each action is expected to execute the given script either built in or customized in the given environment
                The environment is edited in the editOptions: method, the name is more suitable to IB than editEnvironmentContents:.

				From the init method and from  the read methods.
				The frontend implementation is expected to "be" a mutable dictionary containing
				-   a "Commands" dictionary for which keys are the built in command names.
					It is a Command to Action mapper.
					command names give raise to the selectors of TeX menu item, namely Compile -> projectCompile:,
					Typeset -> projectTypeset: Clean -> projectClean: ...
					Values are "command descriptors", id est dictionaries with key value pairs iTM2TPFEEnvironmentModeKey
					and iTM2TPFEScriptModeKey.
					The first value will tell what kind of environment is expected by the command,
					it is one of the keys of the command environments dictionary below.
					Given a command name, we access the environment mode by sending -environmentModeForCommand: message
					and its setter counterpart -setEnvironmentMode:forCommand: to a project document.
					The second value tells what shell script will be used,
					it is one of the keys of the command actions dictionary below.
					Given a command name, we access the script mode by sending -scriptModeForCommand: message
					and its setter counterpart setScriptMode:forCommand: to a project document.
					The script mode is a string identifier used in indirection tables, one of:
								- a name given by the user to identify one of its own customised shell scripts
								- iTM2TPFEVoidMode to disable the action,
								- iTM2TPFEBaseMode to inherit the action script from the base project (including disabling).
						It means that the concrete action can be user defined or built in,
						defined in the project document itself or inherited from a base project.
						There should be no mean to change the meaning of an action.
						The built in action name is the -required- default value for base projects.
						the iTM2TPFEBaseMode is the default value for other projects.
						Then the default actions are built in iTeXMac2 with a possibility of overriding.
						The Special command is very special such that it should not be defined by base projects.
					The environment modes is a string identifier used in indirection tables, one of:
								- the built in action name
								- one of the built in action names when the script mode is "Special"
								- iTM2TPFEVoidMode for customized scripts only,
								- iTM2TPFEBaseMode to inherit the environment from the base project.
						The built in action name is the -required- default value for base projects.
						the iTM2TPFEBaseMode is the default value for other projects.
				-   a "Command Scripts" dictionary which keys are used by the command dictionary above.
					The keys are script modes and the values are script descriptors.
					A script descriptor is a dictionary containing a label for key @"label" used by iTeXMac2 internally
					and the actual shell script for key @"script".
					This dictionary only contains customized scripts such that in general, it is void.
					Only the base projects and customized ones should have a non void dictionary here.
				-   a "Command Environments" dictionary which keys are used by the "Commands" dictionary above.
					They contain a dictionary which contents will be appended the the shell environment just before the action is performed.
					The contents of these value dictionaries is free.
					Given an environment mode, we access the command environment by sending -commandEnvironmentForCommandMode: message
					and its setter counterpart -setEnvironment:forCommandMode: to a project document.
				-   an "Engines" dictionary for which keys are engine names and values are engine descriptors.
					An engine decriptor is just like an action descriptor:
					a dictionary which keys are iTM2TPFEEnvironmentModeKey and iTM2TPFEScriptModeKey.
					The first value will tell what kind of environment is expected by the command,
					it is one of the keys of the engine environments dictionary below.
					To each command corresponds an engine mode as the result of -scriptMode for the command wrapper
					and an environment mode as the result of -environmentMode for the command wrapper.
					The second value tells what shell script will be used,
					it is one of the keys of the action script dictionary below.
					Given an extension, we access the script mode by sending -scriptModeForEngine: message
					and its setter counterpart setScriptMode:forEngine: to a project document.
					Engine names are typically names for standard TeX program wrappers:
					iTM2_Engine_PDFTeX wrapping pdftex, iTM2_Engine_TeX wrapping tex, iTM2_Engine_MetaPost wrapping metapost...
					But they can be customized shell script too.
					This dictionary is used by the built in compile command to map extensions to engines
					and compile files according to their extension.
				-   a "Engine Scripts" dictionary which keys are used by the action dictionary above and values are script descriptors.
					A script descriptor is a dictionary containing a label for key @"label" used by iTeXMac2 internally
					and the actual shell script for key @"script".
					Given a script mode, we access the engine script by sending -scriptDescriptorForEngineMode: message
					and its setter counterpart -takeScriptDescriptor:forEngineMode: to a project document.
				-   an "Engine Environments" dictionary which keys are used by the action dictionary above.
					They contain a dictionary which content will be appended the the shell ENVIRONMENT just before the action is performed.
					The contents of these value dictionaries is free.

                Now come the important notes on the TeX document architecture.
                Documents are one of:
                - projects
                - flat documents
                Projects are standard or basic (these ones are used by standard projects as delegates),
                flat documents ares standalone or owned by standard projects.
                The shared document controller ownes standard projects and flat documents not owned by standard projects.
                There is a dedicated document controller that ownes the basic project documents.
                Each standard project document has a dedicated document controller to help it managing the documents it owns.
*/

@interface iTM2TeXProjectDocument(Frontend)

/*! 
    @method     outputFileExtension
    @abstract   Abstract forthcoming.
    @discussion Discussion forthcoming.
    @param      None
	@result		extension
*/
- (NSString *)outputFileExtension;

/*! 
    @method     setOutputFileExtension:
    @abstract   Abstract forthcoming.
    @discussion Discussion forthcoming.
    @param      extension
	@result		None
*/
- (void)setOutputFileExtension:(NSString *)extension;

/*! 
    @method     editCommands:
    @abstract   Abstract forthcoming.
    @discussion Discussion forthcoming
    @param      None
    @result     None
*/
- (void)editCommands:(id)sender;

- (void)showSettings:(id)sender;
- (void)showFiles:(id)sender;

/*! 
    @method     smartShowTerminal:
    @abstract   Abstract forthcoming.
    @discussion Discussion forthcoming
    @param      Irrelevant
    @result     None
*/
- (void)smartShowTerminal:(id)sender;

/*! 
    @method     showTerminal:
    @abstract   Abstract forthcoming.
    @discussion Discussion forthcoming
    @param      Irrelevant
    @result     None
*/
- (void)showTerminal:(id)sender;

/*! 
    @method     showTerminalInBackGroundIfNeeded:
    @abstract   Abstract forthcoming.
    @discussion Discussion forthcoming
    @param      Irrelevant
    @result     None
*/
- (void)showTerminalInBackGroundIfNeeded:(id)sender;

- (BOOL)isValidEnvironmentMode:(NSString *)environmentMode forScriptMode:(NSString *)scriptMode commandName:(NSString *)commandName;

@end

@interface iTM2TeXPShellScriptInspector: iTM2Inspector

/*! 
    @method     textView
    @abstract   Abstract forthcoming.
    @discussion Discussion forthcoming
    @param      None
    @result     a text view
*/
- (NSTextView *)textView;

@end

extern NSString * const iTM2TPFEContentKey;
extern NSString * const iTM2TPFEShellKey;

extern NSString * const iTM2TPFEPDFOutput;

/*! 
    @class      iTM2TeXProjectInspector
    @abstract   Abstract forthcoming.
    @discussion The TeX menu commands in iTeXMac2 are associate to real actions.
				They are Compile/Typeset/Bibliography/Index/Glossary/Clean/Special
				There is a corresponding action which is a built in script.
				Each built in script relies on some behaviour and there is a dedicated GUI tedit parameters.
				The compile command can use engines to help (see the Engine kit...)
*/

@interface iTM2TeXProjectInspector: iTM2Inspector

/*!
    @method     windowNibName
    @abstract   The window nib name of the receiver
    @discussion Discussion forthcoming.
    @param      None
    @result     A name
*/
+ (NSString *)windowNibName;

- (IBAction)cancel:(id)sender;
- (IBAction)OK:(id)sender;

@end

@interface iTM2TeXProjectDocument(BaseProject)

/*! 
    @method     baseProjectName
    @abstract   The base project name.
    @discussion Discussion forthcoming.
    @param      None
    @result     the name of a project document
*/
- (NSString *)baseProjectName;

/*! 
    @method     setBaseProjectName:
    @abstract   Abstract forthcoming.
    @discussion The given file name points to an already existing folder.
    @param      fileName
    @result     None
*/
- (void)setBaseProjectName:(NSString *)baseProjectName;

@end

@interface iTM2ProjectController(iTM2FontendKit)

/*! 
    @method     requiredTeXProjectForSource:
    @abstract   The required TeX project for the given source.
    @discussion A project should be returned.
    @param      sender is either a document, a view, even nothing...
    @result     A TeX project document
*/
- (id)requiredTeXProjectForSource:(id)sender;

/*! 
    @method     TeXProjectForSource:
    @abstract   The TeX project for the given source.
    @discussion We do not assumer that the project of the document is a TeX project.
				Not all projects are TeX projects...
				This implementation returns the projectForSource: if it is an iTM2TeXProjectDocument instance,
				otherwise it resturns nil.
    @param      sender is either a document, a view, even nothing...
    @result     A TeX project document
*/
- (id)TeXProjectForSource:(id)sender;

/*! 
    @method     currentTeXProject
    @abstract   The current TeX project for the given source.
    @discussion The current project if it is a TeX project, nil otherwise.
    @param      None
    @result     A TeX project document
*/
- (id)currentTeXProject;

- (NSDictionary *)TeXBaseProjectsProperties;

@end

extern NSString * const iTM2TPFEContentKey;
extern NSString * const iTM2TPFEShellKey;
extern NSString * const iTM2TPFELabelKey;
#define iVarLabel valueForKey: iTM2TPFELabelKey

extern NSString * const iTM2TeXPCommandPropertiesKey;

extern NSString * const iTM2ToolbarProjectSettingsItemIdentifier;
extern NSString * const iTM2ToolbarProjectFilesItemIdentifier;
extern NSString * const iTM2ToolbarProjectTerminalItemIdentifier;

@interface iTM2SharedResponder(TeXProject)
- (IBAction)showCurrentProjectSettings:(id)sender;
- (IBAction)showCurrentProjectFiles:(id)sender;
- (IBAction)showCurrentProjectTerminal:(id)sender;
@end

@interface iTM2NewTeXProjectController:iTM2Inspector
{
@private
	unsigned int flags;
}
- (NSURL *)fileURL;
- (void)setFileURL:(NSURL *)fileURL;
- (NSString *)newProjectName;
- (void)setNewProjectName:(NSString *)argument;
- (NSString *)oldProjectName;
- (void)setOldProjectName:(id)argument;
- (NSString *)baseProjectName;
- (void)setBaseProjectName:(NSString *)argument;
- (BOOL)documentIsMaster;
- (void)setDocumentIsMaster:(BOOL)yorn;
- (BOOL)exportOutput;
- (void)setExportOutput:(BOOL)yorn;
- (BOOL)preferWrapper;
- (void)setPreferWrapper:(BOOL)yorn;
- (BOOL)documentIsMaster;
- (BOOL)preferWrapper;
- (id)availableProjects;
- (void)setUpProject:(id)projectDocument;
- (void)setAvailableProjects:(id) argument;
/*!
    @method     validateCreationMode
    @abstract   validate the creation mode
    @discussion Given a file name, the purpose is to create an associate project.
				The creation mode is one of 4 modes
				1 - standalone: the project is created in the external location
				2 - old project: the file name is inserted in an already existing project
				3 - new project: a new project is created
				4 - forbidden: no project is authorized
				What are the possibilities for the file we are asked to create a project for?
				- is it external?
				- is it a wrapper?
				- is it a project?
				- is it included in a project?
				- is it included in a wrapper?
				- does the wrapper contain projects?
				- are there projects the file could be added to?
*/
- (void)validateCreationMode;
- (int)creationMode;
- (void)setCreationMode:(int)tag;
- (BOOL)belongsToAWrapper;
- (NSString *)projectName;
- (BOOL)canInsertInOldProject;
- (BOOL)canCreateNewProject;
- (BOOL)canBeStandalone;
@end
