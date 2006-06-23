// iTM2AREFinderInspector.h
//
//  @version Subversion: $Id$ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Thu Jan 09 2003.
//  From source code of Mike Ferris's MOKit at http://mokit.sourcefoge.net
//  Copyright ¨© 2003 Laurens'Tribune. All rights reserved.
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
@header iTM2AREFinderInspector
@discussion Defines the iTM2AREFinderInspector class.
*/

extern NSString * const iTM2UDARESaveFolderKey;
extern NSString * const iTM2AREFolderName;

typedef enum
{
    iTM2AREFindNextMode		= 0,
    iTM2AREFindAllMode		= 1
} iTM2AREFindMode;

typedef enum
{
    iTM2ARERangeAllMode		= 0,
    iTM2ARERangeSelectionMode	= 1
} iTM2ARERangeMode;

typedef enum
{
    iTM2AREReplaceCurrentMode	= 0,
    iTM2AREReplaceAndNextMode	= 1,
    iTM2AREReplaceMarkedMode	= 2,
    iTM2AREReplaceAllMode	= 3
} iTM2AREReplaceMode;

#import <Foundation/Foundation.h>

@class NSWindowController, NSTextField, NSArray, NSProgressIndicator, iTM2ARegularExpression;

/*!
@class 	iTM2AREFinderInspector
@abstract Description Forthcoming.
@discussion Description Forthcoming.
*/
@interface iTM2AREFinderInspector : NSObject
{
@private
    id findTextView;
    id replaceTextView;
    NSTextField * statusField;
    NSProgressIndicator * spinningWheel;
    
    id _MainTextView;
//    BOOL _CaseSensitive;
    int _Options;
    int _FindMode;
    int _FindRange;
    int _ReplaceMode;
    int _HighLightIndex;
    BOOL _DontUpdateTemplates;
    NSMenu * _TemplatesMenu;
    
    NSWindowController * _WC;
    NSArray * _AllRanges;
    NSArray * _MarkIndexes;
    iTM2ARegularExpression * _RE;
}
/*!
@method sharedInspector
@abstract One shot designated intializer.
@discussion Description Forthcoming.
@result The shared instance.
*/
+(id)sharedInspector;

/*!
@method allRanges
@abstract The array of all ranges of the regular expression found.
@discussion Lazy intializer, the nib name is the class name.
@result A standard NSArray.
*/
-(NSArray *)allRanges;

/*!
@method setAllRanges:
@abstract Setter.
@discussion Description Forthcoming.
@param No consistency chack except for the class.
*/
-(void)setAllRanges:(NSArray *)argument;

/*!
@method tagAllRanges:
@abstract The file text view is colored with temporary attributes to show all the ranges found.
@discussion For each array of ranges, the -tagRanges:highlight: is used unhighlighted.
@param An array of array of range values, corresponding to all the occurrences of a regexp.
*/
-(void)tagAllRanges:(NSArray *)ranges;

/*!
@method find:
@abstract Any replacement must begin by calling this message, the mode is important.
@discussion Description Forthcoming.
@param irrelevant sender.
*/
-(void)find:(id)sender;

@end

/*!
@category iTM2FindResponder
@abstract Advanced regular expressions support.
@discussion Description Forthcoming.
*/

@interface NSWindow(iTM2_ARE)

/*!
@method showAREFindPanel:
@abstract Display the ARE find panel.
@discussion Description Forthcoming.
@param irrelevant sender.
*/
-(void)showAREFindPanel:(id)sender;

@end

@class NSWindow;

/*!
@class 	iTM2AREFinderOptionsInspector
@abstract Description Forthcoming.
@discussion Description Forthcoming.
*/
@interface iTM2AREFinderOptionsInspector: NSWindowController
{
@private
    int _OldOptions;
    int _NewOptions;
}
/*!
@method initWithOptions:
@abstract Dasignated intializer.
@discussion Description Forthcoming.
@param flags is the options of an actual iTM2AREFinderInspector instance.
@result An initialized instance.
*/
-(id)initWithOptions:(int)flags;

/*!
@method optionsByRunningModalConfigurationSheetForWindow:
@abstract The array of all ranges of the regular expression found.
@discussion Begins a modal session.
@param window is the window from which the sheet will appear.
@result New options can be unchanged...
*/
-(int)optionsByRunningModalConfigurationSheetForWindow:(NSWindow *)window;

@end

/*!
@class 	iTM2AREPullDownButton
@abstract Description Forthcoming.
@discussion Description Forthcoming.
 */
@interface iTM2AREPullDownButton : NSPopUpButton

/*!
@method setUpMenu
@abstract Description Forthcoming.
@discussion Description Forthcoming.
 */
-(void)setUpMenu;

/*!
@method :
@abstract Description Forthcoming.
@discussion Description Forthcoming.
 */
-(NSString *)resourceName;

/*!
@method setAction:
@abstract By passes the inherited method.
@discussion The receiver will not accept any change. The receiver will never send its action, it is the job of its menu items. The target of the receiver will be intensively used by those menu items.
The item must be connected to the right target in Interface Builder, even through a meaningless selector.
The actual selector is replaced by -noop: for user interface validation, the target will implement the -noop: and -validateNoop: messages, see iTM2ValidationKit.h
//NSLog for details.
@param an irrelevant selector.
 */
-(void)setAction:(SEL)aSelector;

@end

@interface iTM2AREAtomPullDownButton : iTM2AREPullDownButton
@end
@interface iTM2AREQuantifierPullDownButton : iTM2AREPullDownButton
@end
@interface iTM2AREConstraintPullDownButton : iTM2AREPullDownButton
@end
@interface iTM2AREReferencePullDownButton : iTM2AREPullDownButton
@end

/*!
@class 	iTM2AREFilePopUpButton
@abstract Description Forthcoming.
@discussion Description Forthcoming.
 */
@interface iTM2AREFilePopUpButton : NSPopUpButton
@end
