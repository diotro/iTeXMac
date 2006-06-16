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

//#import <iTM2Foundation/iTM2DocumentKit.h>
#import <iTM2TeXFoundation/iTM2TeXProjectFrontendKit.h>
#import <iTM2TeXFoundation/iTM2TeXProjectDocumentKit.h>

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2TeXProjectIndex

extern NSString * const iTM2ContinuousCompile;

/*! 
    @class      iTM2TeXPCommandWrapperKit
    @abstract   A kit of basic commands.
    @discussion This is the compile wrapper kit.
                Here is gathered what concerns the compile command.
                All the other commands are explained in the iTM2TeXPCommandWrapperKit.
                The compile command is set up from the action panel of the advanced tex project panel.
                This inspector has subinspectors for the various compile commands dedicated to a file extension.
*/

@interface iTM2TeXProjectDocument(Compile)
/*! 
    @method     modelForEngineName:
    @abstract   The model for the engine with the given name.
    @discussion Description forthcoming
    @param      command is one of the predefined command names
    @result     None
*/
-(id)modelForEngineName:(NSString *)name;

/*! 
    @method     takeModel:forEngineName:
    @abstract   Abstract forthcoming.
    @discussion Discussion forthcoming.
    @param      None
    @param      None
    @result     None
*/
-(void)takeModel:(id)argument forEngineName:(NSString *)name;

/*! 
    @method     engineEnvironmentForEngineMode:
    @abstract   The environment dictionary for the given engine mode.
    @discussion This is very similar to the action design except that engines live at a different level.
				Engine typically are command wrappers (EnginePDFTeX, EngineTeX, EngineMetaPost...).
				Each engine is designed to work with a well defined set of environment variables.
				Engine modes are just the names of those engines.
				There is no two level definition.
    @param      mode
    @result     a property list
*/
-(NSDictionary *)environmentForEngineMode:(NSString *)mode;

/*! 
    @method     takeEnvironment:forEngineMode:
    @abstract   Abstract forthcoming.
    @discussion Discussion forthcoming
    @param      environment
    @param      mode
    @result     None
*/
-(void)takeEnvironment:(id)environment forEngineMode:(NSString *)mode;

/*! 
    @method     scriptDescriptorForEngineMode:
    @abstract   Abstract forthcoming.
    @discussion An engine script is used by the compile command.
                An engine script descriptor is a dictionary with keys:
                - "", value: 
    @param      key
    @result     a string
*/
-(NSDictionary *)scriptDescriptorForEngineMode:(NSString *)key;

/*! 
    @method     takeScriptDescriptor:forEngineMode:
    @abstract   Abstract forthcoming.
    @discussion Discussion forthcoming
    @param      script
    @param      engineKey
    @result     None
*/
-(void)takeScriptDescriptor:(id)scriptDescriptor forEngineMode:(NSString *)engineKey;

/*! 
    @method     engines
    @abstract   Abstract forthcoming.
    @discussion Discussion forthcoming
    @param      None
    @result     an array of keys
*/
-(NSDictionary *)engines;
-(NSDictionary *)engineScripts;
-(NSDictionary *)engineEnvironments;


/*! 
    @method     engineWrapperForName
    @abstract   Abstract forthcoming.
    @discussion Discussion forthcoming.
    @param      A name
    @result     A command wrapper
*/
-(id)engineWrapperForName:(NSString *)name;

/*! 
    @method     engineWrappers
    @abstract   Abstract forthcoming.
    @discussion Discussion forthcoming.
    @param      None
    @result     An array of command wrappers
*/
-(id)engineWrappers;

/*! 
    @method     lazyEngineWrappers
    @abstract   Abstract forthcoming.
    @discussion Discussion forthcoming.
    @param      None
    @result     An array of command wrappers
*/
-(id)lazyEngineWrappers;

/*! 
    @method     setEngineWrappers:
    @abstract   The properties of the available TeX projects.
    @discussion Used by the inspectors in the basename/variant/output choice.
    @param      An array of command wrappers
    @result     None
*/
-(void)setEngineWrappers:(NSArray *)argument;

@end

#import "iTM2TeXProjectCommandKit.h"

@interface iTM2TeXPEngineWrapper: iTM2CommandWrapper

/*! 
    @method     modelDidChange
    @abstract   The model of the receiver did change.
    @discussion Warning: the environment might change.
    @param      None
    @result     None
*/
-(void)modelDidChange;

@end

@interface iTM2TeXPCompileInspector: iTM2TeXPCommandInspector
@end

extern NSString * const iTM2TeXProjectEngineTable;

/*!
    @class     iTM2TeXPEngineInspector
    @abstract   Engine inspectors
    @discussion If you write your own engine inspector by subclassing iTM2TeXPEngineInspector, you must make it +initialized unless it won't be registered and used.
				Built in engine inspectors are +initialized in the iTM2TeXPEngineInspector +load method.
				For inspectors not in the same framework, you just have to [ class]  them in their +load method.
*/

@interface iTM2TeXPEngineInspector: iTM2TeXProjectInspector

/*!
    @method     installBinary
    @abstract   nstall the binary
    @discussion Discussion forthcoming.
    @param      None
    @result     None
*/
+(void)installBinary;

/*!
    @method     classForMode:
    @abstract   A command inspector class for the given mode
    @discussion If there is no inspector for the given mode, Nil is returned.
				Custom shell script won't have any inspector.
    @param      An action key
    @result     An autoreleased command inspector
*/
+(id)classForMode:(NSString *)action;

/*!
    @method     engineMode
    @abstract   The engine key of the receiver
    @discussion Discussion forthcoming.
    @param      None
    @result     A selector string
*/
+(NSString *)engineMode;

/*!
    @method     prettyEngineMode
    @abstract   The pretty engine mode of the receiver
    @discussion A localized string...
    @param      None
    @result     A string
*/
+(NSString *)prettyEngineMode;

/*!
    @method     engineReferences
    @abstract   All the engine references
    @discussion Inspector classes wrapped as NSNumber's.
    @param      None
    @result     An NSArray
*/
+(NSArray *)engineReferences;

/*!
    @method     inputFileExtensions
    @abstract   (description)
    @discussion If no extension is given, all the extensions are accepted...
				The default value is a void array.
    @param      None
    @result     An array of the file extensions the input is expected to have.
*/
+(NSArray *)inputFileExtensions;

@end

@interface NSBundle(iTM2CompileWrapperKit)

/*!
    @method     installBinaryWithName:
    @abstract   (description)
    @discussion Install the named binary.
    @param      The name
    @result     None.
*/
-(void)installBinaryWithName:(NSString *)aName;

@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2TeXPCompileWrapperKit
