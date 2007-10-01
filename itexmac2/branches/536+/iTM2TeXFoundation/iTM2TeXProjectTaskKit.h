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

extern NSString * const iTM2LogFilesStackAttributeName;
extern NSString * const iTM2LogPageNumberAttributeName;
extern NSString * const iTM2LogLineTypeAttributeName;
extern NSString * const iTM2LogLinkLineAttributeName;
extern NSString * const iTM2LogLinkColumnAttributeName;
extern NSString * const iTM2LogLinkLengthAttributeName;
extern NSString * const iTM2LogLinkPageAttributeName;
extern NSString * const iTM2LogLinkFileAttributeName;

@interface iTM2TeXProjectDocument(iTM2TeXProjectTaskKit)

/*! 
    @method     taskController
    @abstract   the task controller of the receiver
    @discussion This is a lazy initializer. If there is no task controller yet,
				it creates a new instance and adds the task inspectors akready open by the receiver.
				Each new window controller added to the receiver will also be added to the task controller if relevant.
    @param      None.
    @result     None.
*/
- (iTM2TaskController *)taskController;

/*! 
    @method     didAddWindowController:
    @abstract   Abstract forthcoming.
    @discussion If the argument is a task inspector,
				it is added to the inspector list of the task controller of the receiver.
    @param      WC.
    @result     None.
*/
- (void)didAddWindowController:(id)WC;

/*! 
    @method     willRemoveWindowController:
    @abstract   Abstract forthcoming.
    @discussion If the argument is a task inspector,
				it is removed from the inspector list of the task controller of the receiver.
    @param      WC.
    @result     None.
*/
- (void)willRemoveWindowController:(id)WC;

@end

extern NSString * const iTM2TPFELogParserKey;
extern NSString * const iTM2UDLogDrawsTextBackgroundKey;

extern NSString * const iTM2UDLogTextBackgroundColorKey;
extern NSString * const iTM2UDLogSelectedTextBackgroundColorKey;
extern NSString * const iTM2UDLogSelectedTextColorKey;
extern NSString * const iTM2UDLogInsertionPointColorKey;
extern NSString * const iTM2TeXProjectTerminalInspectorMode;

@interface iTM2TeXPTaskInspector: iTM2TaskInspector

/*! 
    @method     updateOutputAndError:
    @abstract   Abstract forthcoming.
    @discussion Discussion forthcoming
    @param      irrelevant
    @result     None
*/
- (void)updateOutputAndError:(id)irrelevant;

/*! 
    @method     outputView
    @abstract   Abstract forthcoming.
    @discussion Discussion forthcoming
    @param      None
    @result     NSTextView
*/
- (id)outputView;

/*! 
    @method     customView
    @abstract   Abstract forthcoming.
    @discussion Discussion forthcoming
    @param      None
    @result     NSTextView
*/
- (id)customView;

/*! 
    @method     errorView
    @abstract   Abstract forthcoming.
    @discussion Discussion forthcoming
    @param      None
    @result     NSTextView
*/
- (id)errorView;

/*! 
    @method     smartView
    @abstract   Abstract forthcoming.
    @discussion Discussion forthcoming
    @param      None
    @result     NSView
*/
- (id)smartView;

/*! 
    @method     isHidden
    @abstract   Abstract forthcoming
    @discussion Discussion forthcoming
    @param      None
    @result     yorn
*/
- (BOOL)isHidden;

/*! 
    @method     setHidden:
    @abstract   Abstract forthcoming
    @discussion Discussion forthcoming
    @param      yorn
    @result     None
*/
- (void)setHidden:(BOOL)yorn;

@end

extern NSString * const iTM2UDLogStandardFontKey;
extern NSString * const iTM2UDLogStandardColorKey;

@interface iTM2LogParser: NSObject

/*! 
    @method     registerParser
    @abstract   Abstract forthcoming
    @discussion Discussion forthcoming
    @param      None
    @result     A key
*/
+ (void)registerParser;

/*! 
    @method     key
    @abstract   Abstract forthcoming
    @discussion Discussion forthcoming
    @param      None
    @result     A key
*/
+ (NSString *)key;

/*! 
    @method     attributedMessageWithString:previousMessage:
    @abstract   Parse the argument for errors, warnings...
    @discussion The argument is expected to be a one line string, containing eol's only at the end
                The return value is an attributed string.
                The attribute @"iTM2MessageTypeAttributeName" says what kind of line it is,
                one of @"error", @"warning", @"iTM2 error", @"iTM2 warning", @"iTM2 shell error"
                When no such attribute is given, this is a normal line.
    @param      argument is a string
    @param      previousMessage is the possibly nil previous message
    @result     A dictionary
*/
+ (id)attributedMessageWithString:(NSString *)argument previousMessage:(NSAttributedString *)previousMessage;

/*! 
    @method     logParserForKey:
    @abstract   The log parser for the given key...
    @discussion Discussion forthcoming
    @param      a string
    @result     A dictionary
*/
+ (id)logParserForKey:(NSString *)key;

/*! 
    @method     logColorForType:
    @abstract   The log color for the given type...
    @discussion Discussion forthcoming
    @param      a string
    @result     A dictionary
*/
+ (NSColor *)logColorForType:(NSString *)type;

@end

@interface iTM2TeXLogParser: iTM2LogParser
@end
