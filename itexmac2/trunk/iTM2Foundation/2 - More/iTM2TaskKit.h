/*
//
//  @version Subversion: $Id$ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Mon Jun 02 2003.
//  Copyright © 2003 Laurens'Tribune. All rights reserved.
//
//  This program is free software; you can redistribute it and/or modify it under the terms
//  of the GNU General Public License as published by the Free Software Foundation; either
//  version 2 of the License, or any later version.
//  This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
//  without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
//  See the GNU General Public License for more details. You should have received a copy
//  of the GNU General Public License along with this program; if not, write to the Free Software
//  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
//  GPL addendum: Any simple modification of the present code which purpose is to remove bug,
//  improve efficiency in both code execution and code reading or writing should be addressed
//  to the actual developper team.
*/

#import <iTM2Foundation/iTM2InstallationKit.h>
#import <iTM2Foundation/iTM2Implementation.h>
#import <iTM2Foundation/iTM2DocumentKit.h>
#import <iTM2Foundation/iTM2ResponderKit.h>

@class iTM2TaskController;

extern NSString * const iTM2TaskPATHKey;
extern NSString * const iTM2TaskControllerIsDeafKey;
extern NSString * const iTM2TaskControllerIsMuteKey;
extern NSString * const iTM2TaskControllerIsBlindKey;

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2TaskInspector

/*!
@protocol iTM2TaskInspector
    @abstract   Declares the minimal set of method the user interface of a task controller should declare.
    @discussion See the iTM2TaskController documentation for more information.
*/
@protocol iTM2TaskInspector <NSObject>

/*!
    @method     logInput:
    @abstract   Displays the argument as input.
    @discussion When the task controller will send a string to the input pipe, it also send it to its interface.
    @param      The string to display.
*/
- (void)logInput:(NSString *)argument;

/*!
    @method     logOutput:
    @abstract   Displays the result of the standard output pipe.
    @discussion When the task controller receives some data as output, it asks its interface to display it.
    @param      The string to display.
*/
- (void)logOutput:(NSString *)argument;

/*!
    @method     outputDidTerminate
    @abstract   No more output.
    @discussion No task running and no output available.
    @param      None.
    @result     None.
*/
- (void)outputDidTerminate;

/*!
    @method     logError:
    @abstract   Displays the result of the standard error pipe.
    @discussion When the task controller receives some data as error, it asks its interface to display it.
    @param      The string to display.
*/
- (void)logError:(NSString *)argument;

/*!
    @method     errorDidTerminate
    @abstract   No more error.
    @discussion No task running and no error available.
    @param      None.
    @result     None.
*/
- (void)errorDidTerminate;

/*!
    @method     logCustom:
    @abstract   Displays the result of the iTeXMac2 output pipe.
    @discussion When the task controller receives some data as output, it asks its interface to display it.
    @param      The string to display.
*/
- (void)logCustom:(NSString *)argument;

/*!
    @method     customDidTerminate
    @abstract   No more custom output.
    @discussion No task running and no custom output available.
    @param      None.
    @result     None.
*/
- (void)customDidTerminate;

/*!
    @method     cleanLog:
    @abstract   Cleans the log display.
    @discussion Description forthcoming.
    @param      Irrelevant.
    @result     None.
*/
- (void)cleanLog:(id)sender;

/*! 
    @method     taskController
    @abstract   The owning controller, if any.
    @discussion See the iTM2Controller description for details.
    @result     An iTM2Controller instance.
*/
- (id)taskController;

/*! 
    @method     setTaskController:
    @abstract   The lowest level setter of controller.
    @discussion The receiver does not own its controller, neither it is owned by its controller. This method does not care about overall consistency and should not be used
                This is the responsibility of the receiver to clean the connexions when it is about to die.
    @param      An iTM2TaskController instance.
*/
- (void)setTaskController:(iTM2TaskController *)argument;

/*! 
    @method     taskWillLaunch
    @abstract   The controller informs the receiver that it will launch a new task.
    @discussion The receiver should take appropriate actions in such a situation, eg flushing the screen, loging a prompt, maybe.
*/
- (void)taskWillLaunch;

/*! 
    @method     taskDidTerminate
    @abstract   The controller informs the receiver that it will launch a new task.
    @discussion The receiver should take appropriate actions in such a situation, eg loging a prompt, maybe.
*/
- (void)taskDidTerminate;

/*! 
    @method     execute
    @abstract   Execute the argument.
    @discussion Discussion forthcoming.
	@param		a command
	@result		None
*/
- (void)execute:(NSString *)aCommand;

/*! 
    @method     cancel
    @abstract   Cancel the current task.
    @discussion Discussion forthcoming.
	@param		None
	@result		None
*/
- (void)cancel:(NSString *)cancel;

@end

/*!
    @class      iTM2TaskInspector
    @abstract   Concrete minimal implementation of the iTM2TaskInspector protocol. It is a mute and blind object.
    @discussion See the iTM2TaskController documentation for more information.
*/
@interface iTM2TaskInspector: iTM2Inspector <iTM2TaskInspector>

- (id)errorView;
- (void)setErrorView:(NSTextView *)argument;
- (id)outputView;
- (void)setOutputView:(NSTextView *)argument;
- (void)updateOutputAndError:(id)irrelevant;

@end

/*!
    @class      iTM2TaskWindow
    @abstract   Abstract forthcoming.
    @discussion Discussion forthcoming.
*/
@interface iTM2TaskWindow: NSWindow
@end

@class iTM2TaskController;

/*!
	@protocol iTM2TaskWrapper
    @abstract   Wraps the task context.
    @discussion These objects are used to create NSTask's and to manage their contexts. See the iTM2TaskController documentation for more information.
*/
@protocol iTM2TaskWrapper <NSObject>

/*! 
    @method     launchPath
    @abstract   The launch path.
    @discussion Description Forthcoming.
    @result     An NSString.
*/
- (NSString *)launchPath;

/*! 
    @method     arguments
    @abstract   The arguments of the command, if any.
    @discussion Description Forthcoming.
    @result     An iTM2Controller instance.
*/
- (NSArray *)arguments;

/*! 
    @method     environment
    @abstract   The environment for the command.
    @discussion This environment is used to launch the task.
    @result     An NSMutableDictionary instance.
*/
- (NSDictionary *)environment;

/*! 
    @method     currentDirectoryPath
    @abstract   The current directory path.
    @discussion Once the task did terminate, contains the new current directory path. Different task wrappers can share their current directory path such that a change in one of them also affect another one.
    @result     a path.
*/
- (NSString *)currentDirectoryPath;

/*! 
    @method     taskWillLaunch:
    @abstract   The controller informs the receiver that it will launch the task associated to the receiver.
    @discussion The receiver should take any appropriate action in that situation. The default implementation does nothing.
    @param      sender is the task controller who will launch the task.
*/
- (void)taskWillLaunch:(iTM2TaskController *)sender;

/*! 
    @method     taskDidTerminate:
    @abstract   The controller informs the receiver that its task did terminate.
    @discussion The receiver knows about the termination status and the resulting environment dictionary. The default implementation copies relevant informations from the task.
    @param      sender is the task controller who launched the task.
*/
- (void)taskDidTerminate:(iTM2TaskController *)sender;

/*! 
    @method     taskInterruptIfNeeded:
    @abstract   Try to interrupt the task if needed.
    @discussion The delegate is responsible for the task interruption.
				See the setDelegate:... method for details.
				The interrupt callback should test if a stopping condition is fullfilled (for example a keystroke)
				and then should ask the task controller to terminate the task.
    @param      sender is the task controller who launched the task.
*/
- (void)taskInterruptIfNeeded:(iTM2TaskController *)sender;

/*! 
    @method     canInterruptTask
    @abstract   Whether the receiver can interrupt the tasks it wraps.
    @discussion If the delegate gave an interruptioin callback, yes. No otherwise.
    @param      None.
    @result     yorn.
*/
- (BOOL)canInterruptTask;

@end


/*!
@class iTM2TaskWrapper
    @abstract   Wraps the task context.
    @discussion An example of a concrete implementation. These objects are used to create NSTask's and to manage their contexts. See the iTM2TaskController documentation for more information.
*/
@interface iTM2TaskWrapper: iTM2Object <iTM2TaskWrapper>

/*! 
    @method     launchPath
    @abstract   The launch path.
    @discussion Description Forthcoming.
    @result     An NSString.
*/
- (NSString *)launchPath;

/*! 
    @method     setLaunchPath:
    @abstract   Sets the launch path of the receiver.
    @discussion Description Forthcoming. No consistency check is made.
    @param      a launch path.
*/
- (void)setLaunchPath:(NSString *)path;

/*! 
    @method     arguments
    @abstract   The arguments of the command, if any.
    @discussion Description Forthcoming.
    @result     An iTM2Controller instance.
*/
- (NSMutableArray *)arguments;

/*! 
    @method     setArguments:
    @abstract   Sets the arguments of the command.
    @discussion Description Forthcoming.
    @result     An iTM2Controller instance.
*/
- (void)setArguments:(NSArray *)arguments;

- (void)addArgument:(NSString *)argument;

- (void)addArguments:(NSArray *)argument;

/*! 
    @method     environment
    @abstract   The environment for the command.
    @discussion This environment is used to launch the task.
    @result     An NSMutableDictionary instance.
*/
- (NSMutableDictionary *)environment;

/*! 
    @method     setEnvironment:
    @abstract   Sets the environment of the receiver.
    @discussion This basic setter does not make a clone of the argument.
    @result     An iTM2Controller instance.
*/
- (void)setEnvironment:(NSMutableDictionary *)dict;

/*! 
    @method     replaceEnvironment:
    @abstract   Replaces the environment of the receiver.
    @discussion While the basic setter just replace the container, the replacer replaces the contenant.
    @param      dict is an environment dictionary.
*/
- (void)replaceEnvironment:(NSDictionary *)dict;

/*! 
    @method     mergeEnvironment:
    @abstract   Merge the environment of the receiver with the argument.
    @discussion ...
    @param      dict is an environment dictionary.
*/
- (void)mergeEnvironment:(NSDictionary *)argument;

/*! 
    @method     currentDirectoryPath
    @abstract   The current directory path.
    @discussion Once the task did terminate, contains the new current directory path. Different task wrappers can share their current directory path such that a change in one of them also affect another one.
    @result     a path.
*/
- (NSString *)currentDirectoryPath;

/*! 
    @method     setCurrentDirectoryPath:
    @abstract   Sets the current directory path of the receiver.
    @discussion If not set, the current directory path is inherited from the process context.
    @result     An iTM2Controller instance.
*/
- (void)setCurrentDirectoryPath:(NSString *)path;

/*! 
    @method     terminationStatus
    @abstract   The termination status, if any.
    @discussion This is set by the controller once the task did terminate.
    @result     An iTM2Controller instance.
*/
- (int)terminationStatus;

/*! 
    @method     setTerminationStatus:
    @abstract   Sets the termination status, when the task has terminated.
    @discussion Description Forthcoming. Used by the task controller.
    @param      An integer.
*/
- (void)setTerminationStatus:(int)argument;

/*! 
    @method     taskWillLaunch:
    @abstract   The controller informs the receiver that it will launch the task associated to the receiver.
    @discussion The receiver should take any appropriate action in that situation.
				The default implementation sends its delegate the appropriate message.
    @param      the sender is the task controller.
*/
- (void)taskWillLaunch:(iTM2TaskController *)sender;

/*! 
    @method     taskDidTerminate:
    @abstract   The controller informs the receiver that its task did terminate.
    @discussion The receiver knows about the termination status and the resulting environment dictionary.
				The default implementation copies relevant informations from the task.
    @param      the sender is the task controller.
*/
- (void)taskDidTerminate:(iTM2TaskController *)sender;

- (void)taskInterruptIfNeeded:(iTM2TaskController *)sender;
- (BOOL)canInterruptTask;

/*! 
    @method     delegate
    @abstract   The delegate.
    @discussion Will be called if it responds to the appropriate selectors.
    @result     An id.
*/
- (id)delegate;

/*! 
    @method     userInfo
    @abstract   The user info.
    @discussion Used by the delegate.
    @result     Something.
*/
- (id)userInfo;

/*! 
    @method     setDelegate:launchCallBack:terminateCallBack:interruptCallBack:userInfo:
    @abstract   The lowest level setter of the delegate.
    @discussion Ensures overall consistency.
                The call backs should have both the following signature:
                ± (void) taskWrapper: (iTM2TaskWrapper *) arg1 taskControllerProcess: (iTM2TaskController *) taskController userInfo: (id) userInfo
                The delagate is not owned by the receiver, so the client must ensure that the delegate lifetime is superior to the receiver's one.
    @param      argument should respond to the selectors if any.
    @param      LCB is a selector.
    @param      TCB is another selector.
    @param      ICB is another selector.
    @param      userInfo is a user info to be used by the delegate. It is considered a priori to be an object. Great care should be taken to manage the retain count.
    @result     None.
*/
- (void)setDelegate:(id)argument launchCallback:(SEL)LCB terminateCallback:(SEL)TCB interruptCallback:(SEL)ICB userInfo:(id)userInfo;

/*! 
    @method     modalStatusOfScript:output:error:
    @abstract   Launches the /bin/ls task, executes the script and returns the termination status, output and error, waits until exit.
    @discussion The current process is blocked until the task has exited. The returned string are autoreleased objects.
    @param      the sh script to be executed.
    @param      a pointer to a string output.
    @param      a pointer to an error string.
    @result     the termination status of the task.
*/
+ (int)modalStatusOfScript:(NSString *)script output:(NSString **)outputPtr error:(NSError **)outErrorPtr;

/*! 
    @method     modalStatusAndOutput:error:
    @abstract   Launches the task and returns the termination status, output and error, waits until exit.
    @discussion The current process is blocked until the task has exited. The returned string are autoreleased objects.
Not strongly tested. Be coutious when using it.
    @param      a pointer to a string output.
    @param      a pointer to an error string.
    @result     the termination status of the task.
*/
- (int)modalStatusAndOutput:(NSString **)outputPtr error:(NSError **)outErrorPtr;

/*! 
    @method     setEnvironmentString:forKey:
    @abstract   Convenient method to set the environment variables.
    @discussion Description Forthcoming.
    @param      argument is the value of the environment variable.
    @param      key is the name of the environment variable (appearing in $key).
    @result     None.
*/
- (void)setEnvironmentString:(NSString *)argument forKey:(NSString *)key;

/*! 
    @method     appendPATHComponent:
    @abstract   Convenient to add a location at the end of the search path.
    @discussion Description Forthcoming. Removes any other occurence of the argument.
    @param      path is the component, for example /usr/local/bin.
    @result     None.
*/
- (void)appendPATHComponent:(NSString *)path;

/*! 
    @method     prependPATHComponent:
    @abstract   Convenient to add a location at the beginning of the search path.
    @discussion Description Forthcoming. Removes any other occurence of the argument.
    @param      path is the component, for example /usr/local/bin.
    @result     None.
*/
- (void)prependPATHComponent:(NSString *)path;

@end


/*!
	@class		iTM2TaskController
    @abstract   Concrete minimal implementation of the iTM2TaskController protocol. It is a mute and blind object.
    @discussion See the iTM2TaskController documentation for more information. Beware,
				there are certainly some caveats concerning the design of the delegate, more precisely when the task controller is made standalone.
*/
@interface iTM2TaskController: iTM2Object
{
@private
    NSMutableArray * _Inspectors;
    id <iTM2TaskWrapper> _CurrentWrapper;
    NSTask * _CurrentTask;
    NSFileHandle * _CustomReadFileHandle;
    NSMutableString * _Output;
    NSMutableString * _Custom;
    NSMutableString * _Error;
    NSMutableArray * _FHGC;
    NSMutableArray * _NGC;
	BOOL _Standalone;
//iTM2;
}

/*! 
    @method     isDeaf
    @abstract   Whether the receiver can hear or not.
    @discussion A deaf task controller doen't have a standard input, so you cannot successfully talk to him.
    @param      None.
    @result     yorn.
*/
- (BOOL)isDeaf;

/*! 
    @method     setDeaf:
    @abstract   set the receiver deaf status.
    @discussion A deaf task controller doen't have a standard input, so you cannot successfully talk to him.
    @param      yorn.
    @result     None.
*/
- (void)setDeaf:(BOOL)yorn;

/*! 
    @method     isMute
    @abstract   Whether the receiver can speak or not.
    @discussion A mute task controller doen't have a standard output, so you cannot successfully listen to him.
                However, there is always a custom FIFO channel and standard error open.
    @param      None.
    @result     yorn.
*/
- (BOOL)isMute;

/*! 
    @method     setMute:
    @abstract   set the receiver mute status.
    @discussion A mute task controller doen't have a standard output, so you cannot successfully listen to him.
                However, there is always a custom FIFO channel and standard error open.
    @param      yorn.
    @result     None.
*/
- (void)setMute:(BOOL)yorn;

/*! 
    @method     currentTask
    @abstract   The current task.
    @discussion This is a convenient accessor, don't launch this task.
    @result     An NSTask instance.
*/
- (NSTask *)currentTask;

/*! 
    @method     becomeStandalone
    @abstract   Detach the current task.
    @discussion When the task controller is released, it stops its current task unless it is standalone.
				Only mute and deaf tasks can be standalone.
				These task controllers are owned by themselves and will be released when their last task terminates.
    @result     An NSTask instance.
*/
- (void)becomeStandalone;

/*! 
    @method     addInspector:
    @abstract   Adds an inspector to the receiver.
    @discussion Description Forthcoming.
                BEWARE: the receiver does not own its inspectors,
                the inspectors are meant to be (part of) window controllers owned by documents.
    @param      An inspector.
    @result     None.
*/
- (void)addInspector:(id <iTM2TaskInspector>)argument;

/*! 
    @method     removeInspector:
    @abstract   Removes an inspector from the receiver.
    @discussion Description Forthcoming.
    @param      An inspector.
    @result     None.
*/
- (void)removeInspector:(id <iTM2TaskInspector>)argument;

/*! 
    @method     inspectorsEnumerator
    @abstract   An inspectors enumerator.
    @discussion Description Forthcoming.
    @param      None.
    @result     An NSEnumerator.
*/
- (NSEnumerator *)inspectorsEnumerator;

/*! 
    @method     allInspectors
    @abstract   The list of all the task inspectors of the receiver.
    @discussion Description Forthcoming.
    @param      None.
    @result     An array of inspectors.
*/
- (NSArray *)allInspectors;

/*! 
    @method     addTaskWrapper:
    @abstract   Add a new task wrapper to the stack.
    @discussion If there is no task currently running, the first available task is launched.
    @param      An iTM2TaskWrapper instance.
    @result     None.
*/
- (void)addTaskWrapper:(id <iTM2TaskWrapper>)argument;

/*! 
    @method     restartWithTaskWrapper:
    @abstract   Restart with the given taskk wrapper.
    @discussion Description Forthcoming.
    @param      An iTM2TaskWrapper instance.
    @result     None.
*/
- (void)restartWithTaskWrapper:(iTM2TaskWrapper *)argument;

/*! 
    @method     removeTaskWrapper:
    @abstract   Remove a task wrapper from the stack.
    @discussion Description Forthcoming.
    @param      An iTM2TaskWrapper instance.
    @result     None.
*/
- (void)removeTaskWrapper:(id <iTM2TaskWrapper>)argument;

/*! 
    @method     start
    @abstract   Start.
    @discussion Description Forthcoming.
    @param      None.
    @result     None.
*/
- (void)start;

/*! 
    @method     stop
    @abstract   Start.
    @discussion Description Forthcoming.
    @param      None.
    @result     None.
*/
- (void)stop;

/*! 
    @method     flush
    @abstract   Start.
    @discussion Description Forthcoming.
    @param      None.
    @result     None.
*/
- (void)flush;

/*! 
    @method     output
    @abstract   The output.
    @discussion Description Forthcoming. Can be flushed with a clean message. Lazy initializer.
    @param      None.
    @result     the output
*/
- (NSString *)output;

/*! 
    @method     custom
    @abstract   The custom.
    @discussion Description Forthcoming. Can be flushed with a clean message. Lazy initializer.
                This is a cryptic output designed for iTeXMac2 private use only.
    @param      None.
    @result     the tuptuo
*/
- (NSString *)custom;

/*! 
    @method     errorStatus
    @abstract   The error.
    @discussion Description Forthcoming. Can be flushed with a clean message. Lazy initializer.
    @param      None.
    @result     the output
*/
- (NSString *)errorStatus;

/*! 
    @method     clean
    @abstract   Start.
    @discussion Description Forthcoming.
    @param      None.
    @result     None
*/
- (void)clean;

/*!
    @method     logOutput:
    @abstract   Displays the result of the standard output pipe.
    @discussion When the task controller receives some data as output, it asks its inspectors to display it.
    @param      The string to display.
*/
- (void)logOutput:(NSString *)argument;

/*!
    @method     outputDidTerminate
    @abstract   No more output.
    @discussion No task running and no output available.
    @param      None.
    @result     None.
*/
- (void)outputDidTerminate;

/*!
    @method     logError:
    @abstract   Displays the result of the standard error pipe.
    @discussion When the task controller receives some data as error, it asks its inspectors to display it.
    @param      The string to display.
*/
- (void)logError:(NSString *)argument;

/*!
    @method     errorDidTerminate
    @abstract   No more error.
    @discussion No task running and no error available.
    @param      None.
    @result     None.
*/
- (void)errorDidTerminate;

/*!
    @method     logCustom:
    @abstract   Displays the result of the iTeXMac2 fifo pipe or else.
    @discussion When the task controller receives some data as output, it asks its inspectors to display it.
    @param      The string to display.
*/
- (void)logCustom:(NSString *)argument;

/*! 
    @method     waitUntilExit
    @abstract   Wait until the current task exits.
    @discussion Description Forthcoming.
    @param      None.
    @result     None
*/
- (void)waitUntilExit;

/*! 
    @method     execute:
    @abstract   Input some string.
    @discussion Description Forthcoming.
    @param      the input.
    @result     None
*/
- (void)execute:(NSString *)aCommand;

/*! 
    @method     executeAppleScript:
    @abstract   Execute the given apple script.
    @discussion This allows control from the task currently working.
                The shell command iTM2_AppleScript is useable from any shell script.
                If the script is launched from a text controller,
                the environment is properly set to have a fifo communication channel from the script to the controller.
                For example, the command
                iTM2_AppleScript --execute "tell application \"Finder\"\nbeep\nend tell"
                results in the controller executing synchronously the script
                tell application "Finder"
                beep
                end tell
                In particular, the script can do whatever it wants with the UI.
    @param      the source script.
    @result     None
*/
- (void)executeAppleScript:(NSString *)source;

@end

@interface iTM2TaskControllerResponder: iTM2AutoInstallResponder

- (IBAction)toggleTaskControllerDeaf:(id)sender;

- (IBAction)toggleTaskControllerMute:(id)sender;

@end
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2TaskKit
