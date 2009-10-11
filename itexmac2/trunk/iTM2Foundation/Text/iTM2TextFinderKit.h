/*
//  iTM2TextFinder.h
//  iTeXMac2
//
//  Created by jlaurens@users.sourceforge.net on Mon Sep 03 2001.
//  Copyright © 2001-2002 Laurens'Tribune. All rights reserved.
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

// this is highly inspired from TextEdit sources...

#define Forward YES
#define Backward NO

#import <iTM2Foundation/iTM2DocumentKit.h>

@class NSNotification, NSWindow, NSString;

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2TextFinder

@interface iTM2TextFinder: iTM2Inspector
{
@private
    BOOL findStringChangedSinceLastPasteboardUpdate;
	NSTextView * __weak iVarTextView;
	NSTextView * __weak iVarFindWidget;
	NSTextView * __weak iVarReplaceWidget;
}

@property (assign) textView;
@property (assign) findWidget;
@property (assign) replaceWidget;

/* Common way to get a text finder. One instance of TextFinder per app is good enough. But likely...*/
+ (id) sharedTextFinder;

/* Main method for external users; does a find in the first responder. Selects found range or beeps. */
- (BOOL) find: (BOOL) direction;

/* Gets the first responder and returns it if it's an NSTextView */
- (NSTextView *) textViewToSearchIn;

/* Get/set the current find string. Will update UI if UI is loaded */
- (NSString *) findString;
- (void) setFindString: (NSString *) aString;
- (NSString *) replaceString;
- (void) setReplaceString: (NSString *) aString;

/* Misc internal methods */
- (void) applicationWillResignActive: (NSNotification *) aNotification;

- (void) showFindPanel: (id) sender;
- (void) enterSelection: (id) sender;
- (void) enterFindPboardSelection: (id) sender;

/* Methods sent from the find panel UI */
//- (void) findNextAndOrderFindPanelOut: (id) sender;
- (void) findNext: (id) sender;
- (void) findPrevious: (id) sender;
- (void) replace: (id) sender;
- (void) replaceAndFind:(id) sender;
- (void) replaceAll: (id) sender;

- (id) initWithCoder: (NSCoder *) aDecoder;

- (id) initWithTextView: (NSTextView *) TV;

- (BOOL) isFindStringChangedSinceLastPboardUpdate;
- (void) setFindStringChangedSinceLastPboardUpdate: (BOOL) yorn;

- (BOOL) isEntireFile;
- (void) setEntireFile: (BOOL) yorn;
- (BOOL) isCaseSensitive;
- (void) setCaseSensitive: (BOOL) yorn;
- (BOOL) isWrap;
- (void) setWrap: (BOOL) yorn;

- (BOOL) isLastFindSuccessful;

- (unsigned) numberOfOperations;
- (void) setNumberOfOperations: (unsigned) nops;

- (void) setMute: (BOOL) flag;
- (BOOL) isMute;
@end


@interface NSString (iTM2TextFinderKit)
- (NSRange)iTM2_rangeOfString:(NSString *)string selectedRange:(NSRange)selectedRange options:(unsigned)mask wrap:(BOOL)wrapFlag;
@end

// this is to mimic 10.3 behaviour in 10.2
typedef enum {
    iTM2FindPanelActionShowFindPanel = 1,
    iTM2FindPanelActionNext = 2,
    iTM2FindPanelActionPrevious = 3,
    iTM2FindPanelActionReplaceAll = 4,
    iTM2FindPanelActionReplace = 5,
    iTM2FindPanelActionReplaceAndFind = 6,
    iTM2FindPanelActionSetFindString = 7,
    iTM2FindPanelActionReplaceAllInSelection = 8
} iTM2FindPanelAction;

// this is to extand 10.3 behaviour
typedef enum {
    iTM2MoreFindActionTabAnchorNext = 101,
    iTM2MoreFindActionTabAnchorPrevious = 102,
    iTM2MoreFindActionTeXErrorNext = 201,
    iTM2MoreFindActionTeXErrorPrevious = 202,
    iTM2MoreFindActionNext = 301
} iTM2MoreFindAction;

@interface NSTextView(iTM2TextFinder)
- (void) performMoreFindAction: (id) sender;
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2TextFinder

