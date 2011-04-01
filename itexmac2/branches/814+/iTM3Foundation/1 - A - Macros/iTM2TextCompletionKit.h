/*
//
//  @version Subversion: $Id: iTM2TextCompletionKit.h 794 2009-10-04 12:33:28Z jlaurens $ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Wed Apr 12 20:12:28 GMT 2006.
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

/*!
@header iTM2TextCompletionKit
@discussion Description Forthcoming.
*/

extern NSString * const iTM2CompletionComponent;

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2TextCompletionKit

@interface NSText(iTM2TextCompletionKit)

- (BOOL)getContext:(NSString **)contextPtr category:(NSString **)categoryPtr forPartialWordRange:(NSRange)charRange;

@end

#import "iTM2DocumentKit.h"

@interface iTM2CompletionServer: iTM2Inspector <NSTableViewDataSource,NSTableViewDelegate>
{
// this is subject to changes
@private
	IBOutlet NSTableView * _TableView;
	NSArray * _LongCandidates;
	NSTextView * _TextView;
	NSString * _Tab;
	NSString * _OriginalString;
	NSString * _EditedString;
	NSString * _ShortCompletionString;
	NSString * _LongCompletionString;
	NSArray * _ReplacementLines;
	NSString * _OriginalSelectedString;
	BOOL _ShouldEnableUndoRegistration;
	NSRange _SelectedRange;
	NSRange _RangeForUserCompletion;
	NSRange _EditedRangeForUserCompletion;
	NSMutableDictionary * _PatriciaControllers;
	NSUInteger _IndentationLevel;
}
+ (id)completionServer;
- (NSArray *)completionsForTextView:(NSTextView *)aTextView partialWordRange:(NSRange)charRange indexOfSelectedItem:(NSInteger *)index;
@property (retain) NSTableView * _TableView;
@property (retain) NSArray * _LongCandidates;
@property (retain) NSTextView * _TextView;
@property (retain) NSString * _Tab;
@property (retain) NSString * _OriginalString;
@property (retain) NSString * _EditedString;
@property (retain) NSString * _ShortCompletionString;
@property (retain) NSString * _LongCompletionString;
@property (retain) NSArray * _ReplacementLines;
@property (retain) NSString * _OriginalSelectedString;
@property BOOL _ShouldEnableUndoRegistration;
@property (retain) NSMutableDictionary * _PatriciaControllers;
@property NSUInteger _IndentationLevel;
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2TextCompletionKit

