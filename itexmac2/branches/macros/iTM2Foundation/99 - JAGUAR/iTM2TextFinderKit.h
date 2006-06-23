/*
//
//  @version Subversion: $Id$ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Mon Sep 03 2001.
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

@class NSNotification, NSWindow, NSString;

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2TextFinder

@interface iTM2TextFinder : NSWindowController
{
@private
    id findTextField;
    id replaceTextField;
    id ignoreCaseButton;
    id replaceAllScopeMatrix;
    NSString * _FindString;
    NSString * _ReplaceString;
    NSTextView * _TextView;
    unsigned _NumberOfOps;
    BOOL findStringChangedSinceLastPasteboardUpdate;
    BOOL _EntireFileFlag;
    BOOL _CaseInsensitiveFlag;
    BOOL _WrapFlag;
    BOOL _Mute;
}

/* Common way to get a text finder. One instance of TextFinder per app is good enough. But likely...*/
+(id)sharedTextFinder;

/* Main method for external users; does a find in the first responder. Selects found range or beeps. */
-(BOOL)find:(BOOL)direction;

/* Gets the first responder and returns it if it's an NSTextView */
-(NSTextView *)textViewToSearchIn;

/* Get/set the current find string. Will update UI if UI is loaded */
-(NSString *)findString;
-(void)setFindString:(NSString *)aString;
-(NSString *)replaceString;
-(void)setReplaceString:(NSString *)aString;

/* Misc internal methods */
-(void)applicationWillResignActive:(NSNotification *)aNotification;

-(void)showFindPanel:(id)sender;
-(void)enterSelection:(id)sender;
-(void)enterFindPboardSelection:(id)sender;

/* Methods sent from the find panel UI */
//- (void) findNextAndOrderFindPanelOut: (id) sender;
-(void)findNext:(id)sender;
-(void)findPrevious:(id)sender;
-(void)replace:(id)sender;
-(void)replaceAndFind:(id) sender;
-(void)replaceAll:(id)sender;

-(BOOL)validateUserInterfaceItems;

-(id)initWithCoder:(NSCoder *)aDecoder;

-(id)initWithTextView:(NSTextView *)TV;

-(BOOL)entireFileFlag;
-(void)setEntireFileFlag:(BOOL)aFlag;
-(BOOL)caseInsensitiveFlag;
-(void)setCaseInsensitiveFlag:(BOOL)aFlag;
-(BOOL)wrapFlag;
-(void)setWrapFlag:(BOOL)aFlag;

-(BOOL)lastFindWasSuccessful;
-(unsigned)numberOfOps;

-(void)setMute:(BOOL)flag;
-(BOOL)isMute;
@end


@interface NSString (iTM2TextFinderKit)
-(NSRange)rangeOfString:(NSString *)string selectedRange:(NSRange)selectedRange options:(unsigned)mask wrap:(BOOL)wrapFlag;
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2TextFinder

