/*
//
//  @version Subversion: $Id$ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Tue Jan 18 22:21:11 GMT 2005.
//  Copyright © 2005 Laurens'Tribune. All rights reserved.
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

#import <iTM2Foundation/iTM2JAGUARSupportKit.h>
#import <iTM2Foundation/iTM2Foundation.h>
int iTM2DebugEnabled_FLAGS = 0;

// this will be loaded only if they are not defined (the user runs OS X < 10.3)
@implementation NSMenuItem(iTM2JAGUARSupportKit)
- (void)setIndentationLevel:(int)level;
{iTM2_DIAGNOSTIC;
	NSString * title = [self title];
	NSRange R = [title rangeOfCharacterFromSet:[[NSCharacterSet whitespaceAndNewlineCharacterSet] invertedSet]];
	if(R.location != NSNotFound)
	{
		level *= 3; // 3 spaces per indentation level.
		level = MIN(level, 12);
		if(R.location > level)
		{
			R.location = level;
			R.length = [title length] - level;
			[self setTitle:[title substringWithRange:R]];
		}
		else if(R.location < level)
		{
			R.length = level - R.location;
			[self setTitle:[NSString stringWithFormat:@"%@%@", [@"            " substringWithRange:R], title]];
		}
	}
	return;
}
- (void)setAttributedTitle:(NSAttributedString*)string;
{iTM2_DIAGNOSTIC;
    [self setTitle:[string string]];
}
- (NSAttributedString*)attributedTitle;
{iTM2_DIAGNOSTIC;
    return nil;
}
@end
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

#import <iTM2Foundation/iTM2TextFinderKit.h>

@implementation NSTextView(iTM2JAGUARSupportKit)
- (void)setUsesFindPanel:(BOOL)yorn;
{iTM2_DIAGNOSTIC;
    return;
}
- (BOOL)usesFindPanel;
{iTM2_DIAGNOSTIC;
    return YES;
}
- (void)performFindPanelAction:(id)sender;	// See enum NSFindPanelAction for possible tags in sender
{iTM2_DIAGNOSTIC;
	switch([sender tag])
	{
		case iTM2FindPanelActionShowFindPanel:
			[[iTM2TextFinder sharedTextFinder] showFindPanel:self];
			break;
		case iTM2FindPanelActionNext:
			[[iTM2TextFinder sharedTextFinder] findNext:self];
			break;
		case iTM2FindPanelActionPrevious:
			[[iTM2TextFinder sharedTextFinder] findPrevious:self];
			break;
		case iTM2FindPanelActionReplaceAll:
			[[iTM2TextFinder sharedTextFinder] replaceAll:self];
			break;
		case iTM2FindPanelActionReplace:
			[[iTM2TextFinder sharedTextFinder] replace:self];
			break;
		case iTM2FindPanelActionReplaceAndFind:
			[[iTM2TextFinder sharedTextFinder] replaceAndFind:self];
			break;
		case iTM2FindPanelActionSetFindString:
			[[iTM2TextFinder sharedTextFinder] enterSelection:self];
			break;
		case iTM2FindPanelActionReplaceAllInSelection:
			NSBeep();
			break;
		default:
			break;
	}
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validatePerformFindPanelAction:
- (BOOL)validatePerformFindPanelAction:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/02/2001)
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	switch([sender tag])
	{
		case iTM2FindPanelActionShowFindPanel:
			return YES;
		case iTM2FindPanelActionNext:
		case iTM2FindPanelActionPrevious:
		case iTM2FindPanelActionReplaceAndFind:
		case iTM2FindPanelActionReplaceAll:
			return ([[[iTM2TextFinder sharedTextFinder] findString] length]>0) &&([[[[iTM2TextFinder sharedTextFinder] textViewToSearchIn] string] length]>0);
		case iTM2FindPanelActionReplace:
		case iTM2FindPanelActionSetFindString:
			return ([[[iTM2TextFinder sharedTextFinder] textViewToSearchIn] selectedRange].length>0);
		case iTM2FindPanelActionReplaceAllInSelection:
			return NO;
		default:
			return NO;
	}
}
@end

@implementation NSDocumentController(iTM2JAGUARSupportKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  openDocumentWithContentsOfURL:display:error:
- (id)openDocumentWithContentsOfURL:(NSURL *)absoluteURL display:(BOOL)displayDocument error:(NSError **)outError;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/02/2001)
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	return [self openDocumentWithContentsOfURL:(NSURL *)absoluteURL display:(BOOL)displayDocument];
}
@end
