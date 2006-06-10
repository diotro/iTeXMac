// iTM2AREFinderOptionsInspector.h
//  iTeXMac2
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Thu Jan 09 2003.
//  From source code of Mike Ferris's MOKit at http://mokit.sourcefoge.net
//  Copyright © 2003 Laurens'Tribune. All rights reserved.
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

/*!
@header iTM2AREFinderOptionsInspector_IB
@discussion Defines the API of the iTM2AREFinderOptionsInspector class used in Interface Builder.
*/

#import <iTM2Foundation/iTM2AREFinderOptionsInspector.h>

@interface iTM2AREFinderOptionsInspector(IB)

/*!
@method OK:
@abstract This is the action sent by the OK button.
@discussion This validates the changes.
@param sender is the OK button.
*/
- (IBAction) OK: (id) sender;

/*!
@method cancel:
@abstract This is the action sent by the Cancel button.
@discussion This discards the changes.
@param sender is the Cancel button.
*/
- (IBAction) cancel: (id) sender;

/*!
@method toggleExpanded:
@abstract Description Forthcoming.
@discussion Description Forthcoming.
@param sender is a matrix of radio buttons.
*/
- (IBAction) toggleExpanded: (id) sender;

/*!
@method toggleIgnoreSubexpressions:
@abstract Description Forthcoming.
@discussion Description Forthcoming.
@param sender is a matrix of radio buttons.
*/
- (IBAction) toggleIgnoreSubexpressions: (id) sender;

/*!
@method toggleNewlineAnchor:
@abstract Description Forthcoming.
@discussion Description Forthcoming.
@param sender is a matrix of radio buttons.
*/
- (IBAction) toggleNewlineAnchor: (id) sender;

/*!
@method toggleNewlineSensitive:
@abstract Description Forthcoming.
@discussion Description Forthcoming.
@param sender is a matrix of radio buttons.
*/
- (IBAction) toggleNewlineSensitive: (id) sender;

/*!
@method toggleNewlineStop:
@abstract Description Forthcoming.
@discussion Description Forthcoming.
@param sender is a matrix of radio buttons.
*/
- (IBAction) toggleNewlineStop: (id) sender;

/*!
@method toggleQuote:
@abstract Description Forthcoming.
@discussion Description Forthcoming.
@param sender is a matrix of radio buttons.
*/
- (IBAction) toggleQuote: (id) sender;

/*!
@method toggleType:
@abstract Description Forthcoming.
@discussion Description Forthcoming.
@param sender is a matrix of radio buttons.
*/
- (IBAction) toggleType: (id) sender;

@end
