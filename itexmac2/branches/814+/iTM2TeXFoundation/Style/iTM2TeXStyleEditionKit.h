/*
//
//  @version Subversion: $Id$ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Tue Oct 16 2001.
//  Copyright © 2004 Laurens'Tribune. All rights reserved.
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

#import <iTM2Foundation/iTM2TextStyleEditionKit.h>

extern NSString * const iTM2StyleSymbolsPboardType;

/*!
	@class			iTM2TeXParserAttributesDocument
	@superclass		iTM2TextSyntaxParserAttributesDocument
	@abstract		Abstract forthcoming.
	@discussion		Corresponds to iTM2TeXParser.
	@availability	iTM2.
	@copyright		2005 jlaurens AT users DOT sourceforge DOT net and others.
*/
@interface iTM2TeXParserAttributesDocument: iTM2TextSyntaxParserAttributesDocument
@end

/*!
	@class			iTM2TeXParserAttributesInspector
	@superclass		iTM2TextSyntaxParserAttributesInspector
	@abstract		Abstract forthcoming.
	@discussion		Corresponds to iTM2TeXParser.
	@availability	iTM2.
	@copyright		2005 jlaurens AT users DOT sourceforge DOT net and others.
*/
@interface iTM2TeXParserAttributesInspector: iTM2TextSyntaxParserAttributesInspector
@end

/*!
	@class			iTM2XtdTeXParserAttributesDocument
	@superclass		iTM2TeXParserAttributesDocument
	@abstract		Abstract forthcoming.
	@discussion		Discussion forthcoming.
	@availability	iTM2.
	@copyright		2005 jlaurens AT users DOT sourceforge DOT net and others.
*/
@interface iTM2XtdTeXParserAttributesDocument: iTM2TeXParserAttributesDocument
@end

/*!
	@class			iTM2XtdTeXParserAttributesInspector
	@superclass		iTM2TeXParserAttributesInspector
	@abstract		Abstract forthcoming.
	@discussion		Discussion forthcoming.
	@availability	iTM2.
	@copyright		2005 jlaurens AT users DOT sourceforge DOT net and others.
*/
@interface iTM2XtdTeXParserAttributesInspector: iTM2TeXParserAttributesInspector
@end

/*!
	@class			iTM2XtdTeXParserSymbolsInspector
	@superclass		iTM2TSPAInspector
	@abstract		Abstract forthcoming.
	@discussion		Discussion forthcoming.
	@availability	iTM2.
	@copyright		2005 jlaurens AT users DOT sourceforge DOT net and others.
*/
@interface iTM2XtdTeXParserSymbolsInspector: iTM2Inspector <NSTableViewDelegate, NSTableViewDataSource, NSWindowDelegate>
{
@private
    IBOutlet NSTableView * __weak tableView;
    IBOutlet NSPanel * __weak addSetPanel;

    NSMutableDictionary * _BuiltInSymbolsSets;// the keys are the paths where it must be saved, the values are mutable dictionaries with symbols, edited symbols, edited keys, as many things as needed.
    NSMutableDictionary * _NetworkSymbolsSets;
    NSMutableDictionary * _LocalSymbolsSets;
    NSMutableDictionary * _CustomSymbolsSets;
    NSMutableDictionary * _CustomObjectsSets;
    NSMutableDictionary * _CustomKeysSets;
    NSMutableDictionary * _EditedObjectsSets;
    NSMutableDictionary * _RecycleSymbolsSets;
    NSMutableDictionary * _AllSymbolsSets;// a medley of all the symbols

    NSMenuItem * __weak _CurrentSetItem;// NSMenuItem not retained!!!
    
    BOOL _Background;
}
- (id)symbolAtRow:(NSInteger)row;
- (BOOL)tableView:(NSTableView*)tv paste:(NSPasteboard *)pboard;
- (void)addSymbolInTableView:(NSTableView *)tv;
- (NSMutableDictionary *)currentSets;
- (NSString *)currentSetKey;
@property (assign) NSTableView * __weak tableView;
@property (assign) NSPanel * __weak addSetPanel;
@property (retain) NSMutableDictionary * _BuiltInSymbolsSets;
@property (retain) NSMutableDictionary * _NetworkSymbolsSets;
@property (retain) NSMutableDictionary * _LocalSymbolsSets;
@property (retain) NSMutableDictionary * _CustomSymbolsSets;
@property (retain) NSMutableDictionary * _CustomObjectsSets;
@property (retain) NSMutableDictionary * _CustomKeysSets;
@property (retain) NSMutableDictionary * _EditedObjectsSets;
@property (retain) NSMutableDictionary * _RecycleSymbolsSets;
@property (retain) NSMutableDictionary * _AllSymbolsSets;
@property (assign) id __weak _CurrentSetItem;
@property BOOL _Background;
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2TeXStyleEditionKit
