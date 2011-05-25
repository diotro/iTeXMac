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

//#import <iTM3Foundation/iTM2DocumentKit.h>
#import "iTM2TeXProjectFrontendKit.h"
#import "iTM2TeXProjectDocumentKit.h"

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

#import "iTM2TeXProjectCommandKit.h"

@interface iTM2TeXPCompileInspector: iTM2TeXPCommandInspector <NSTabViewDelegate>
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
+ (void)installBinary;

/*!
    @method     classForMode:
    @abstract   A command inspector class for the given mode
    @discussion If there is no inspector for the given mode, Nil is returned.
				Custom shell script won't have any inspector.
    @param      An action key
    @result     An autoreleased command inspector
*/
+ (id)classForMode:(NSString *)action;

/*!
    @method     engineMode
    @abstract   The engine key of the receiver
    @discussion Discussion forthcoming.
    @param      None
    @result     A selector string
*/
+ (NSString *)engineMode;

/*!
    @method     prettyEngineMode
    @abstract   The pretty engine mode of the receiver
    @discussion A localized string...
    @param      None
    @result     A string
*/
+ (NSString *)prettyEngineMode;

/*!
    @method     engineReferences
    @abstract   All the engine references
    @discussion Inspector classes wrapped as NSNumber's.
    @param      None
    @result     An NSArray
*/
+ (NSPointerArray *)engineReferences;

/*!
    @method     inputFileExtensions
    @abstract   (description)
    @discussion If no extension is given, all the extensions are accepted...
				The default value is a void array.
    @param      None
    @result     An array of the file extensions the input is expected to have.
*/
+ (NSArray *)inputFileExtensions;

@end

@interface NSBundle(iTM2CompileWrapperKit)

/*!
    @method     installBinaryWithName:
    @abstract   (description)
    @discussion Install the named binary.
    @param      The name
    @param      RORef
    @result     YorN.
*/
- (BOOL)installBinaryWithName4iTM3:(NSString *)aName error:(NSError **)RORef;

@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2TeXPCompileWrapperKit
