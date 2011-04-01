/*
//
//  @version Subversion: $Id$ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Mon Sep 03 2001.
//  Copyright © 2001-2005 Laurens'Tribune. All rights reserved.
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

#import "iTM2TextFinderKit.h"
#import "iTM2Foundation.h"

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2TextFinder
/*"It is very very very closely based on the text finder sample provided by apple™. 
Fortunately, improvements have been made. However, I removed what concerns the attributes...
and added a validation process."*/
@implementation iTM2TextFinder
static id _iTM2TextFinder = nil;
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  sharedTextFinder
+ (id)sharedTextFinder;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/02/2001)
- 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if(!_iTM2TextFinder)
	{
		_iTM2TextFinder = [self.alloc initWithWindowNibName:NSStringFromClass(self)];
		[_iTM2TextFinder enterFindPboardSelection:self];
	}
    return _iTM2TextFinder;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initWithWindow:
- (id)initWithWindow:(NSWindow *)window;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/02/2001)
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if(_iTM2TextFinder)
    {
        return _iTM2TextFinder;
    }
    else
    {
        if(self = [super initWithWindow:window])
        {
            [self setWrapFlag:YES];
        }
        return _iTM2TextFinder = self;
    }
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initWithCoder
- (id)initWithCoder:(NSCoder *)aDecoder;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/02/2001)
- < 1.1: 03/10/2002
To Do List: TEST
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if(_iTM2TextFinder)
    {
        return _iTM2TextFinder;
    }
    else
    {
        return _iTM2TextFinder = [super initWithCoder:aDecoder];
    }
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initWithTextView:
- (id)initWithTextView:(NSTextView *)TV;
/*"The only way to create an unshared instance. With no UI.
Version History: jlaurens AT users DOT sourceforge DOT net (09/02/2001)
- < 1.1: 03/10/2002
To Do List: TEST
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if(self = [super init])
    {
        [_TextView autorelease];
        _TextView = [TV retain];
    }
    return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  windowDidLoad
- (void)windowDidLoad;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/02/2001)
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    #warning use the defaults here
    NS_DURING
    [super windowDidLoad];
    findStringChangedSinceLastPasteboardUpdate = YES;
    [self.window setFrameAutosaveName:[self.class description]];
	error
    self.validateUserInterfaceItems4iTM3;
    [self.window setDelegate:self];
    NS_HANDLER
    [NSApp reportException:localException];
    NS_ENDHANDLER
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateUserInterfaceItems4iTM3
- (BOOL)validateUserInterfaceItems4iTM3;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/02/2001)
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [findTextField validateWindowContent4iTM3];
    #warning VERY BAD DESIGN
    [replaceAllScopeMatrix setEnabled:(self.textViewToSearchIn != nil)];
    [ignoreCaseButton setEnabled:(self.textViewToSearchIn != nil)];
//END4iTM3;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  applicationWillResignActive:
- (void)applicationWillResignActive:(NSNotification *)aNotification;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/02/2001)
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSString * findString = self.findString;
    if(findString.length>ZER0)
    {
        NSPasteboard *pasteboard = [NSPasteboard pasteboardWithName:NSFindPboard];
        [pasteboard declareTypes:[NSArray arrayWithObject:NSStringPboardType] owner:nil];
        [pasteboard setString:self.findString forType:NSStringPboardType];
    }
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  enterFindPboardSelection:
- (void)enterFindPboardSelection:(id)irrelevant;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/02/2001)
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSPasteboard *pasteboard = [NSPasteboard pasteboardWithName:NSFindPboard];
    if ([[pasteboard types] containsObject:NSStringPboardType])
    {
        NSString *string = [pasteboard stringForType:NSStringPboardType];
        if (string.length)
        {
            [self setFindString:string];
        }
    }
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  findString
- (NSString *)findString;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/02/2001)
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return _FindString? _FindString: [NSString string];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setFindString:
- (void)setFindString:(NSString *)aString;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/02/2001)
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if(![aString isEqualToString:_FindString])
    {
        findStringChangedSinceLastPasteboardUpdate = YES;
        [_FindString autorelease];
        _FindString = [aString copy];
        _NumberOfOps = ZER0;
    }
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  replaceString
- (NSString *)replaceString;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/02/2001)
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return _ReplaceString? _ReplaceString: [NSString string];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setReplaceString:
- (void)setReplaceString:(NSString *)aString;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/02/2001)
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [_ReplaceString autorelease];
    _ReplaceString = [aString copy];
    _NumberOfOps = ZER0;
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setMute:
- (void)setMute:(BOOL)flag;
/*"Description Forthcoming. Selection vs entire
Version History: jlaurens AT users DOT sourceforge DOT net (09/02/2001)
- 1.2: 07/18/2002
To Do List: Collect the flags in a struct...
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    _Mute = flag;
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  isMute
- (BOOL)isMute;
/*"Description Forthcoming. Selection vs entire
Version History: jlaurens AT users DOT sourceforge DOT net (09/02/2001)
- 1.2: 07/18/2002
To Do List: Collect the flags in a struct...
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return _Mute;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  entireFileFlag
- (BOOL)entireFileFlag;
/*"Description Forthcoming. Selection vs entire
Version History: jlaurens AT users DOT sourceforge DOT net (09/02/2001)
- < 1.1: 03/10/2002
To Do List: Collect the flags in a struct...
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return _EntireFileFlag;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setEntireFileFlag:
- (void)setEntireFileFlag:(BOOL)aFlag;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/02/2001)
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    _EntireFileFlag = aFlag;
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  caseInsensitiveFlag
- (BOOL)caseInsensitiveFlag;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/02/2001)
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return _CaseInsensitiveFlag;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setCaseInsensitiveFlag:
- (void)setCaseInsensitiveFlag:(BOOL)aFlag;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/02/2001)
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    _CaseInsensitiveFlag = aFlag;
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  wrapFlag
- (BOOL)wrapFlag;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/02/2001)
- 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return _WrapFlag;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setWrapFlag:
- (void)setWrapFlag:(BOOL)aFlag;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/02/2001)
- 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    _WrapFlag = aFlag;
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  textViewToSearchIn:
- (NSTextView *)textViewToSearchIn;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/02/2001)
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if(_TextView)
        return _TextView;
    else
    {
        id textViewToSearchIn = [[NSApp mainWindow] firstResponder];
        id result = ([textViewToSearchIn isKindOfClass:[NSTextView class]]) ? textViewToSearchIn:nil;
//NSLog(@"%@, %@", textViewToSearchIn, result);
        return result;    
    }
}
#pragma mark =-=-=-=-=-=-=-=-=-=-  TEXT FIELDS EDITED
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  findStringEdited:
- (void)findStringEdited:(id)sender;
/*"Description Forthcoming. USEFULL ???
Version History: jlaurens AT users DOT sourceforge DOT net (09/02/2001)
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self findNext:sender];
    if (self.lastFindWasSuccessful)
        [self.window orderOut:sender];
    else
	[findTextField selectText:nil];
    self.validateUserInterfaceItems4iTM3;
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateFindStringEdited:
- (BOOL)validateFindStringEdited:(id)sender;
/*"Description Forthcoming. USEFULL ???
Version History: jlaurens AT users DOT sourceforge DOT net (09/02/2001)
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    sender.stringValue = self.findString;
//END4iTM3;
    return (self.textViewToSearchIn != nil);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  replaceStringEdited:
- (void)replaceStringEdited:(id)sender;
/*"Description Forthcoming. USEFULL ???
Version History: jlaurens AT users DOT sourceforge DOT net (09/02/2001)
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self findNext:sender];
    [self replace:sender];
    if (self.lastFindWasSuccessful)
        [self.window orderOut:sender];
    else
	[findTextField selectText:nil];
    self.validateUserInterfaceItems4iTM3;
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateReplaceStringEdited:
- (BOOL)validateReplaceStringEdited:(id)sender;
/*"Description Forthcoming. USEFULL ???
Version History: jlaurens AT users DOT sourceforge DOT net (09/02/2001)
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    sender.stringValue = self.replaceString;
//END4iTM3;
    return (self.textViewToSearchIn != nil);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  synchronizeFromUserInterface
- (void)synchronizeFromUserInterface;
/*"Description Forthcoming. Tag = position in the matrix
Version History: jlaurens AT users DOT sourceforge DOT net (09/02/2001)
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if(findTextField) [self setFindString:[findTextField stringValue]];
    if(replaceTextField) [self setReplaceString:[replaceTextField stringValue]];
    [findTextField selectText:nil];
    [replaceTextField selectText:nil];
    if(ignoreCaseButton) [self setCaseInsensitiveFlag:([ignoreCaseButton state] != NSOffState)];
    if(replaceAllScopeMatrix) [self setEntireFileFlag:([replaceAllScopeMatrix selectedTag] == ZER0)];
//END4iTM3;
    return;
}
#pragma mark =-=-=-=-=-=-=-=-=-=-  FIND ACTIONS
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  find:
- (BOOL)find:(BOOL)direction;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/02/2001)
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSTextView * textView = self.textViewToSearchIn;
    NSString * textString = [textView string];
    NSString * findString = self.findString;
    _NumberOfOps = ZER0;
    if (textString.length > ZER0)
    {
        if (findString.length > ZER0)
        {
            NSRange range;
            NSUInteger options = ZER0;
            if (direction == Backward)
                options |= NSBackwardsSearch;
            if (_CaseInsensitiveFlag)
                options |= NSCaseInsensitiveSearch;
            range = [textString rangeOfString4iTM3:findString
                            selectedRange: [textView selectedRange] options:options wrap:self.wrapFlag];
            if (range.length)
            {
                [textView setSelectedRange:range];
                [textView scrollRangeToVisible:range];
                _NumberOfOps = 1;
            }
        }
        else
        {
            if(!self.isMute) NSBeep();
            [self postNotificationWithStatus4iTM3:
                NSLocalizedStringFromTableInBundle(@"No textView found.", [self.class description],
                    self.classBundle4iTM3, nil)];
        }
    }
    else
    {
        if(!self.isMute) NSBeep();
        [self postNotificationWithStatus4iTM3:
            NSLocalizedStringFromTableInBundle(@"No textView to search in.", [self.class description],
                self.classBundle4iTM3, nil)];
    }
    if (!self.lastFindWasSuccessful)
    {
        if(!self.isMute) NSBeep();
        [self postNotificationWithStatus4iTM3:
                NSLocalizedStringFromTableInBundle(@"Not found", [self.class description],
                    self.classBundle4iTM3,
                        @"Status displayed in find panel when the find string is not found.")];
    }
    else
    {
        [self postNotificationWithStatus4iTM3:@"OK"];
    }
    return self.lastFindWasSuccessful;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  centerSelectionInVisibleArea:
- (void)centerSelectionInVisibleArea:(id)sender;
/*"Action forwarded the self's textFinder.
Version History: jlaurens AT users DOT sourceforge DOT net (09/02/2001)
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSTextView * textView = self.textViewToSearchIn;
    [textView scrollRangeToVisible:[textView selectedRange]];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  findNext:
- (void)findNext:(id)sender;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/02/2001)
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    self.synchronizeFromUserInterface;
    [self find:Forward];
    self.validateUserInterfaceItems4iTM3;
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateFindNext:
- (BOOL)validateFindNext:(id)sender;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/02/2001)
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return (self.textViewToSearchIn != nil);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  findPrevious:
- (void)findPrevious:(id)sender;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/02/2001)
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    self.synchronizeFromUserInterface;
    [self find:Backward];
    self.validateUserInterfaceItems4iTM3;
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateFindPrevious:
- (BOOL)validateFindPrevious:(id)sender;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/02/2001)
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return (self.textViewToSearchIn != nil);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  replace:
- (void)replace:(id)sender;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/02/2001)
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    self.synchronizeFromUserInterface;
    [self.textViewToSearchIn insertText:self.replaceString];
    self.validateUserInterfaceItems4iTM3;
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateReplace:
- (BOOL)validateReplace:(id)sender;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/02/2001)
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return (self.lastFindWasSuccessful && self.textViewToSearchIn);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  replaceAndFind:
- (void)replaceAndFind:(id)sender;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/02/2001)
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    self.synchronizeFromUserInterface;
    [self replace:sender];
    [self findNext:sender];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateReplaceAndFind:
- (BOOL)validateReplaceAndFind:(id)sender;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/02/2001)
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return (self.lastFindWasSuccessful && self.textViewToSearchIn);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  replaceAll:
- (void)replaceAll:(id)sender;
/*" The replaceAll: code is somewhat complex, and more complex than it used to be in DR1.  The main reason for this is to support undo. To play along with the undo mechanism in the textView object, this method goes through the shouldChangeTextInRange:replacementString: mechanism. In order to do that, it precomputes the section of the string that is being updated. An alternative would be for this guy to handle the undo for the replaceAll: operation itself, and register the appropriate changes. However, this is simpler...

Turns out this approach of building the new string and inserting it at the appropriate place in the actual textView storage also has an added benefit performance; it avoids copying the contents of the string around on every replace, which is significant in large files with many replacements. Of course there is the added cost of the temporary replacement string, but we try to compute that as tightly as possible beforehand to reduce the memory requirements.
Version History: Apple
- < 1.1: 03/10/2002
To Do List: rewrite this to replace all in range...
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSTextView * textView = self.textViewToSearchIn;
    _NumberOfOps = ZER0;
    if (!textView)
    {
        if (!self.isMute) NSBeep();
        NSLog(@"No text view to search in found.");
//END4iTM3;
        return;
    }
    self.synchronizeFromUserInterface;
    NSString *findString = self.findString;
    if(findString.length)
    {
        NSTextStorage *textStorage = [textView textStorage];
        NSString *textString = [textView string];
        NSRange replaceRange = self.entireFileFlag ? iTM3MakeRange(ZER0, textStorage.length) :[textView selectedRange];
        NSUInteger searchOption = (self.caseInsensitiveFlag ? NSCaseInsensitiveSearch :ZER0);
        NSRange firstOccurence;
        
        // Find the first occurence of the string being replaced; if not found, we're done!
        firstOccurence = [textString rangeOfString:findString options:searchOption range:replaceRange];
        if (firstOccurence.length > ZER0)
        {
	    NSAutoreleasePool *pool;
	    NSString *targetString = findString;
	    NSString *replaceString = self.replaceString;
            NSMutableAttributedString *temp;	/* This is the temporary work string in which we will do the replacements... */
            NSRange rangeInOriginalString;	/* Range in the original string where we do the searches */

	    // Find the last occurence of the string and union it with the first occurence to compute the tightest range...
            rangeInOriginalString = replaceRange = iTM3UnionRange(firstOccurence, [textString rangeOfString:targetString options:NSBackwardsSearch|searchOption range:replaceRange]);

            temp = [[NSMutableAttributedString alloc] init];

            [temp beginEditing];

	    // The following loop can execute an unlimited number of times, and it could have autorelease activity.
	    // To keep things under control, we use a pool, but to be a bit efficient, instead of emptying everytime through
	    // the loop, we do it every so often. We can only do this as long as autoreleased items are not supposed to
	    // survive between the invocations of the pool!

    	    pool = [[NSAutoreleasePool alloc] init];

            while (rangeInOriginalString.length > ZER0) {
                NSRange foundRange = [textString rangeOfString:targetString options:searchOption range:rangeInOriginalString];
		// Because we computed the tightest range above, foundRange should always be valid.
		NSRange rangeToCopy = iTM3MakeRange(rangeInOriginalString.location, foundRange.location - rangeInOriginalString.location + 1);	// Copy upto the start of the found range plus one char (to maintain attributes with the overlap)...
                [temp appendAttributedString:[textStorage attributedSubstringFromRange:rangeToCopy]];
                [temp replaceCharactersInRange:iTM3MakeRange(temp.length - 1, 1) withString:replaceString];
                rangeInOriginalString.length -= iTM3MaxRange(foundRange) - rangeInOriginalString.location;
                rangeInOriginalString.location = iTM3MaxRange(foundRange);
                _NumberOfOps++;
	  	if (_NumberOfOps % 100 == ZER0) {	// Refresh the pool... See warning above!
		    [pool drain];
		    pool = [[NSAutoreleasePool alloc] init];
		}
            }

	    [pool drain];

            [temp endEditing];

	    // Now modify the original string
            if ([textView shouldChangeTextInRange:replaceRange replacementString:[temp string]]) {
                [textStorage replaceCharactersInRange:replaceRange withAttributedString:temp];
                [textView didChangeText];
//                [textView replaceCharactersInRange:replaceRange withAttributedString:temp];
            } else {	// For some reason the string didn't want to be modified. Bizarre...
                _NumberOfOps = ZER0;
            }

            [temp autorelease];
        }
        if (self.lastFindWasSuccessful)
        {
            [self postNotificationWithStatus4iTM3:
                [NSString localizedStringWithFormat:NSLocalizedStringFromTableInBundle(@"%d replaced",
                    [self.class description], self.classBundle4iTM3,
                        @"Status displayed in find panel when indicated number of matches are replaced."),
                            _NumberOfOps]];
        }
        else
        {
            if(!self.isMute) NSBeep();
            [self postNotificationWithStatus4iTM3:
                NSLocalizedStringFromTableInBundle(@"Not found",
                    [self.class description], self.classBundle4iTM3,
                        @"Status displayed in find panel when the find string is not found.")];
        }
    }
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateReplaceAll:
- (BOOL)validateReplaceAll:(id)sender;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/02/2001)
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return (self.textViewToSearchIn != nil);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  enterSelection:
- (void)enterSelection:(id)sender;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/02/2001)
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSTextView * textView = [NSApp targetForAction:@selector(selectedRange)];
    NSRange selectedRange = [textView selectedRange];
    if((selectedRange.length > ZER0) && [textView respondsToSelector:@selector(string)])
    {
        NSString * S = [[textView string] substringWithRange:[textView selectedRange]];
        [self setFindString:S];
        findTextField.stringValue = S;
    }
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  lastFindWasSuccessful
- (BOOL)lastFindWasSuccessful;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/02/2001)
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return _NumberOfOps > ZER0;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  numberOfOps
- (NSUInteger)numberOfOps;
/*"Description Forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net (09/02/2001)
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return _NumberOfOps;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  windowDidBecomeKey:
- (void)windowDidBecomeKey:(NSNotification *)notification;
/*"Example. the object is not in the responder chain.
Version history: jlaurens AT users DOT sourceforge DOT net
first version Richard Koch
Version History: jlaurens AT users DOT sourceforge DOT net (09/02/2001)
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if([findTextField acceptsFirstResponder])
	{
		[[notification object] makeFirstResponder:findTextField];
	}
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  showFindPanel:
- (void)showFindPanel:(id)irrelevant;
/*"Description Forthcoming and avalidates the user interface.
Version History: jlaurens AT users DOT sourceforge DOT net (09/02/2001)
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSWindow * W = self.window;// load the window
    self.validateUserInterfaceItems4iTM3;// validates the UI
    [self postNotificationWithStatus4iTM3:@""];
    [W makeKeyAndOrderFront:nil];// show the window
//END4iTM3;
    return;
}
@end


@implementation NSString (iTM2TextFinderKit)

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  rangeOfString4iTM3:selectedRange:options:wrap:
- (NSRange)rangeOfString4iTM3:(NSString *)aString selectedRange:(NSRange)aSelectedRange options:(NSUInteger)options wrap:(BOOL)wrap;
/*"Description Forthcoming.
Version History: Apple, jlaurens AT users DOT sourceforge DOT net (09/02/2001)
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//NSLog(@"self: <%@>", self);
//NSLog(@"rangeOfString: <%@>", aString);
//NSLog(@"selectedRange: %@", NSStringFromRange(aSelectedRange));
//NSLog(@"options: %i", options);
//NSLog(@"wrap: %@", (wrap? @"Y": @"N"));
    BOOL forwards = (options & NSBackwardsSearch) == ZER0;
    NSUInteger length = self.length;
    NSRange searchRange, range;
    if (forwards)
    {
	searchRange.location = iTM3MaxRange(aSelectedRange);
	searchRange.length = length - searchRange.location;
	range = [self rangeOfString:aString options:options range:searchRange];
        if ((range.length == ZER0) && wrap)
        {	/* If not found look at the first part of the string */
	    searchRange.location = ZER0;
            searchRange.length = aSelectedRange.location;
            range = [self rangeOfString:aString options:options range:searchRange];
        }
    }
    else
    {
	searchRange.location = ZER0;
	searchRange.length = aSelectedRange.location;
        range = [self rangeOfString:aString options:options range:searchRange];
//NSLog(NSStringFromRange(searchRange));
//NSLog(NSStringFromRange(range));
        if ((range.length == ZER0) && wrap)
        {
            searchRange.location = iTM3MaxRange(aSelectedRange);
            searchRange.length = length - searchRange.location;
            range = [self rangeOfString:aString options:options range:searchRange];
        }
//NSLog(@"DOUBLE");
//NSLog(NSStringFromRange(range));
    }
    return range;
}        
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2TextFinderKit
