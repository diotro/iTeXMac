/*
//
//  @version Subversion: $Id: iTM2MacroKit.m 490 2007-05-04 09:05:15Z jlaurens $ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Thu Feb 21 2002.
//  Copyright © 2006 Laurens'Tribune. All rights reserved.
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

#import "iTM2StringKit.h"
#import "iTM2Invocation.h"
#import "iTM2MacroKit.h"
#import "iTM2MacroKit_Action.h"
#import "iTM2MacroKit_Controller.h"
#import "iTM2MacroKit_String.h"
#import "iTM2StringControllerKit.h"
#import "iTM2LiteScanner.h"
#import "iTM2StringControllerKitPrivate.h"
#import "ICURegEx.h"
#import "iTM2LiteScanner.h"
#import "iTM2PathUtilities.h"

@implementation iTM2MacroNode(PRIVATE_ACTION)
- (SEL)action;
{
	return NSSelectorFromString(self.selector);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= executeMacroWithTarget:selector:substitutions:
- (BOOL)executeMacroWithTarget:(id)target selector:(SEL)action substitutions:(NSDictionary *)theSubstitutions;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (action == @selector(noop:))
	{
		return NO;
	}
	if (!target)
	{
		target = [[NSApp keyWindow] firstResponder];
	}
	BOOL result = NO;
	NSMethodSignature * MS = nil;
	if (action && (MS = [target methodSignatureForSelector:action]))
	{
here:
		[self setSubstitutions:theSubstitutions];
		if ([MS numberOfArguments] == 3)
		{
			NS_DURING
			[target performSelector:action withObject:self];
			result = YES;
			NS_HANDLER
			NS_ENDHANDLER
		}
		else if ([MS numberOfArguments] == 2)
		{
			NS_DURING
			[target performSelector:action];
			result = YES;
			NS_HANDLER
			NS_ENDHANDLER
		}
		else if (MS)
		{
		}
		else if ([[[NSApp keyWindow] firstResponder] tryToPerform:action with:self]
			|| [[[NSApp mainWindow] firstResponder] tryToPerform:action with:self])
		{
			result = YES;
		}
		else
		{
			LOG4iTM3(@"No target for %@ with argument:%@", NSStringFromSelector(action),self);
		}
		[self setSubstitutions:nil];
//END4iTM3;
		return result;
	}
	if ((action = self.action)
			&& (MS = [target methodSignatureForSelector:action]))
	{
		goto here;
	}
	if ((action = NSSelectorFromString(self.macroID))
		&& (MS = [target methodSignatureForSelector:action]))
	{
		goto here;
	}
	if ((action = @selector(insertMacro:))
		&& (MS = [target methodSignatureForSelector:action]))
	{
		goto here;
	}
//END4iTM3;
	return NO;
}
@end

@implementation iTM2MacroController(Action)
#pragma mark =-=-=-=-=-  ACTION
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= ___catch:
- (void)___catch:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= validate___catch:
- (BOOL)validate___catch:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= ___insertMacro:
- (void)___insertMacro:(NSMenuItem *)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSArray * RA = [sender representedObject];
	if ([RA isKindOfClass:[NSArray class]] && RA.count)
	{
		NSString * ID = [RA objectAtIndex:0];
		NSString * context;
		NSString * category;
		NSString * domain;
		if (RA.count > 3)
		{
			context = [RA objectAtIndex:1];
			category = [RA objectAtIndex:2];
			domain = [RA objectAtIndex:3];
		}
		else
		{
			context = @"";
			if (RA.count > 2)
			{
				category = [RA objectAtIndex:1];
				domain = [RA objectAtIndex:2];
			}
			else
			{
				category = @"";
				if (RA.count > 1)
				{
					context = @"";
					domain = [RA objectAtIndex:1];
				}
				else
				{
					domain = @"";
				}
			}
		}
		if (ID.length)
		{
			if ([[self macroWithID:ID] executeMacroWithTarget:nil selector:NULL substitutions:nil])
			{
				NSMenu * recentMenu = [self macroMenuForContext:self.macroContext ofCategory:@"Recent" inDomain:self.macroDomain error:nil];
				NSInteger index = [recentMenu indexOfItemWithTitle:sender.title];
				if (index!=-1)
				{
					[recentMenu removeItemAtIndex:index];
				}
				NSMenuItem * MI = [[[NSMenuItem alloc] initWithTitle:sender.title action:sender.action keyEquivalent:@""] autorelease];
				MI.target = self;// self is expected to live forever
				MI.representedObject = RA;
				[recentMenu insertItem:MI atIndex:1];
				NSMutableDictionary * MD = [NSMutableDictionary dictionary];
				index = 0;
				NSInteger max = [SUD integerForKey:@"iTM2NumberOfRecentMacros"];
				while([recentMenu numberOfItems] > max)
				{
					[recentMenu removeItemAtIndex:[recentMenu numberOfItems]-1];
				}
				while(++index < [recentMenu numberOfItems])
				{ 
					MI = [recentMenu itemAtIndex:index];
					RA = [MI  representedObject];
					if (RA)
					{
						[MD setObject:RA forKey:MI.title];
					}
				}
				[SUD setObject:MD forKey:[NSString pathWithComponents4iTM3:[NSArray arrayWithObjects:@"", @"Recent", domain, nil]]];
			}
		}
	}
	else if (RA)
	{
		LOG4iTM3(@"Unknown design [sender representedObject]:%@", RA);
	}
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= validate___insertMacro:
- (BOOL)validate___insertMacro:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSArray * RA = [sender representedObject];
	if ([RA isKindOfClass:[NSArray class]] && (RA.count > 2))
	{
		NSString * ID = [RA objectAtIndex:0];
		if (ID.length)
			return YES;
	}
	LOG4iTM3(@"sender is:%@",sender);
//END4iTM3;
    return [sender hasSubmenu];
}
@end

@implementation NSObject(iTM2ExecuteMacro)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  executeMacroWithID4iTM3:
- (BOOL)executeMacroWithID4iTM3:(NSString *)ID;
/*"Description forthcoming.
If the event is a 1 char key down, it will ask the current key binding for macro.
The key and its modifiers are 
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
	return [[self macroWithID:ID] executeMacroWithTarget:self selector:NULL substitutions:nil];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= executeMacroWithText4iTM3:
- (BOOL)executeMacroWithText4iTM3:(NSString *)text;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	BOOL result = NO;
    ICURegEx * placeholder = self.stringController4iTM3.placeholderICURegEx;
    placeholder.inputString = text;
    while (placeholder.nextMatch) {
		iTM2MacroNode * leafNode = [self macroWithID:placeholder.macroDefaultString4iTM3];
        NSString * actionName = [NSString stringWithFormat:@"insertMacro4iTM3_%@:",placeholder.macroTypeName4iTM3];
        SEL action = NSSelectorFromString(actionName);
        result = [leafNode executeMacroWithTarget:self selector:action substitutions:nil];
    }
    return result;
//START4iTM3;
}
@end

@implementation NSView(iTM2ExecuteMacro)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  tryToExecuteMacroWithID4iTM3:
- (BOOL)tryToExecuteMacroWithID4iTM3:(NSString *)macro;
/*"Description forthcoming.
If the event is a 1 char key down, it will ask the current key binding for macro.
The key and its modifiers are 
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return [super tryToExecuteMacroWithID4iTM3:macro]
			|| [self.superview tryToExecuteMacroWithID4iTM3:macro]
				|| [self.window tryToExecuteMacroWithID4iTM3:macro];// not good
}
@end

@implementation NSWindow(iTM2ExecuteMacro)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  tryToExecuteMacroWithID4iTM3:
- (BOOL)tryToExecuteMacroWithID4iTM3:(NSString *)macro;
/*"Description forthcoming.
If the event is a 1 char key down, it will ask the current key binding for macro.
The key and its modifiers are 
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return [super tryToExecuteMacroWithID4iTM3:macro]
			|| [(id)self.delegate executeMacroWithID4iTM3:macro]
				|| [self.windowController tryToExecuteMacroWithID4iTM3:macro];
}
@end

@implementation NSWindowController(iTM2ExecuteMacro)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  tryToExecuteMacroWithID4iTM3:
- (BOOL)tryToExecuteMacroWithID4iTM3:(NSString *)macro;
/*"Description forthcoming.
If the event is a 1 char key down, it will ask the current key binding for macro.
The key and its modifiers are 
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return [super tryToExecuteMacroWithID4iTM3:macro]
			|| [self.document executeMacroWithID4iTM3:macro]
				|| ((self.owner != self) && [self.owner executeMacroWithID4iTM3:macro]);
}
@end

@implementation NSResponder(iTM2ExecuteMacro)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  executeStringInstruction:
- (BOOL)executeMacroWithID4iTM3:(NSString *)macro;
/*"Description forthcoming.
If the event is a 1 char key down, it will ask the current key binding for instruction.
The key and its modifiers are 
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return [self tryToExecuteMacroWithID4iTM3:macro] || [super executeMacroWithID4iTM3:macro];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  tryToExecuteMacroWithID4iTM3:
- (BOOL)tryToExecuteMacroWithID4iTM3:(NSString *)macro;
/*"Description forthcoming.
If the event is a 1 char key down, it will ask the current key binding for macro.
The key and its modifiers are 
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSRange R = [macro rangeOfString:@":"];
	if (R.length)
	{
		R.length = R.location + 1;
		R.location = 0;
		NSString * selectorName = [macro substringWithRange:R];
		SEL action = NSSelectorFromString(selectorName);
		if ([self respondsToSelector:action])
		{
			R.location = R.length;
			R.length = macro.length - R.location;
			NSString * argument = [macro substringWithRange:R];
			if ([self tryToPerform:action with:argument])
			{
				return YES;
			}
		}
	}
//END4iTM3;
    return NO;
}
@end

#import "iTM2ContextKit.h"

@implementation iTM2MacroNode(Action)
- (NSString *)concreteArgument;
{
	NSString * result = self.insertion;
	if (!result) {
		result = self.macroID;
	}
	NSDictionary * theSubstitutions = self.substitutions;
	if (theSubstitutions.count) {
		NSMutableString * MS = [NSMutableString stringWithString:result];
		for (NSString * string1 in theSubstitutions.keyEnumerator) {
			NSString * string2 = [theSubstitutions objectForKey:string1];
			NSRange range = iTM3MakeRange(0,result.length);
			[MS replaceOccurrencesOfString:string1 withString:string2 options:0L range:range];
		}
        result = [MS.copy autorelease];
	}
	return result;
}
@end

@interface iTM2StringController(Action)
- (NSMutableArray *)componentsOfMacroForInsertion:(NSString *)macro;
- (NSString *)getCurrentPrefixWithGlobalPrefix:(NSString *)globalS:(NSArray *)globalICsBefore:(NSArray *)globalICsAfter
        macroPrefix:(NSString *)macro:(NSArray *)macro1stICsBefore:(NSArray *)macro1stICsAfter:(NSArray *)macroICsBefore:(NSArray *)macroICsAfter
            selectionPrefix:(NSString *)selection:(NSArray *)selection1stICsBefore:(NSArray *)selection1stICsAfter:(NSArray *)selectionICsBefore:(NSArray *)selectionICsAfter
                keepComment:(BOOL)keepComment;
@end

@implementation iTM2StringController(Action)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  whiteTrailerForComponentString:
- (NSString *)whiteTrailerForComponentString:(NSString *)string;
/*"Some macros will need the currently selected text.
If the selected text spans over some indentation text, the macro will take this into account.
Version history: jlaurens AT users DOT sourceforge DOT net
- 3.0: Dim  8 nov 2009 18:14:10 UTC
To Do List:
"*/
{
    if ([[NSCharacterSet whitespaceCharacterSet] characterIsMember:string.lastCharacter4iTM3]) {
        return @"";
    }
    if (!self.usesTabs || (string.length + 1) % self.numberOfSpacesPerTab) {
        return @" ";
    }
    return @"\t";
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  componentsOfMacroForInsertion:
- (NSMutableArray *)componentsOfMacroForInsertion:(NSString *)macro;
/*"Some macros will need the currently selected text.
If the selected text spans over some indentation text, the macro will take this into account.
Version history: jlaurens AT users DOT sourceforge DOT net
- 3.0: Dim  8 nov 2009 18:14:10 UTC
To Do List:
"*/
{
//START4iTM3;
//  Description of macro components :
//  The macro components is a list of blocks of strings or selection indicators
//  Each block is composed of either list below
//  1 - description of a full line ending with an EOL marker, no SEL placeholder inside, no EOL inside, or nothing
//      what is recorded:
//      a)  the indentation components before the comment
//      b)  the indentation components after the comment
//      c)  the range up to and including an EOL
//  2 - description of a full line eventually ending with an EOL marker, SEL placeholders inside,
//      no EOL inside (except inside SEL placeholders themselves), or nothing
//      what is recorded:
//      a)  the indentation components before the comment
//      b)  the indentation components after the comment
//      c)  the range of a string with no EOL, no SEL
//      an alternate list of
//      d)  index of a SEL placeholder wrapped in a NSNumber
//      e)  the range of the default value of this SEL placeholder
//      or
//      d)  the range of the type name of a general (not SEL) placeholder
//      e)  the range of the default value for this placeholder
//      terminating the list
//      f)  range of a string up to and including an EOL, no SEL, no EOL inside
//  Concerning the indentation, string components of type 1 and 4 are left untouched
//  The indentation level is determined by component strings of type 2
//  and possibly by the location where things are expected to be inserted
//  We do not assume that the selection and the insertion point are connected together
//  The indentation of the lines before and after the insertion range are not modified in any way
//  If there is an indentation from the beginning of the line to the beginning of the selection
//  this indentation should be propagated to the newly inserted lines
//  Indentation assumes that comment sequences may be part of the indentation prefix
//  When a line uses different SEL and the selection spans over different lines
//  the second SEL must take into account what comes from the first SEL
//  
    NSRange R = iTM3MakeRange(0,0);
    NSInteger i = 0;
    NSString * S;
    NSMutableArray * macroComponents = [NSMutableArray array];
    ICURegEx * RE = self.placeholderOrEOLICURegEx;
    [RE setInputString:macro];
    // find the first line that contains a SEL
    NSMutableArray * ICsBefore = nil;
    NSMutableArray * ICsAfter = nil;
    NSUInteger location = 0;
    iTM2LiteScanner * LS = [iTM2LiteScanner scannerWithString:macro charactersToBeSkipped:nil];
    LS.scanLocation = 0;
    LS.scanLimit = LS.scanLocation+macro.length;
    while (YES) {
        [self getIndentationComponents:&ICsBefore:&ICsAfter withScanner:LS];
        [macroComponents addObject:ICsBefore];
        [macroComponents addObject:ICsAfter];
        location += [ICsBefore indentationLength4iTM3];ICsBefore = nil;
        location += [ICsAfter indentationLength4iTM3];ICsAfter = nil;
        while (YES) {
            if ([RE nextMatchAfterIndex:location]) {
                R = [RE rangeOfMatch];
                [macroComponents addObject:[NSValue valueWithRange:R]];
                location = iTM3MaxRange(R);// ready for the next loop
                R = [RE rangeOfCaptureGroupWithName:iTM2RegExpMKEOLName];
                if (R.length) {
                    //  this is a line ending with an EOL, no placeholder
                    break;//    continue on the main loop
                }
                //  a SEL or TYPE placeholder:
                R = [RE rangeOfCaptureGroupWithName:iTM2RegExpMKTypeName];
                if (R.length) {
                    //  this is a general placeholder, not SEL
                    [macroComponents addObject:[NSValue valueWithRange:R]];// range of TYPE value
                    R = [RE rangeOfCaptureGroupWithName:iTM2RegExpMKDefaultName];
                    [macroComponents addObject:[NSValue valueWithRange:R]];// range of default value
                    continue;//    continue on the main loop
                }
                //  this is a SEL placeholder
                i = 0;
                NSScanner * SC = nil;
                S = [RE substringOfCaptureGroupWithName:iTM2RegExpMKIndexName];
                if (S.length) {
                    // count from the beginning
                    SC = [NSScanner scannerWithString:S];
                    [SC scanInteger:&i];
                    S = nil;
                } else {
                    // count from the end
                    S = [RE substringOfCaptureGroupWithName:iTM2RegExpMKIndexFromEndName];
                    if (S.length) {
                        SC = [NSScanner scannerWithString:S];
                        [SC scanInteger:&i];
                    }
                    S = nil;
                    R = [RE rangeOfCaptureGroupWithName:iTM2RegExpMKEndName];
                    if (R.length) {
                        i = - 1 - i;// a 'last' or 'end' was scanned
                    } else if (i>0) {
                        i = - i;
                    }
                }
                [macroComponents addObject:[NSNumber numberWithInteger:i]];
                [macroComponents addObject:[NSValue valueWithRange:[RE rangeOfCaptureGroupWithName:iTM2RegExpMKDefaultName]]];// range of default value
                continue;
            }
            //  The end of the text was reached
            //  The trailing part does not contain any SEL nor EOL
            return macroComponents;
        }
    }
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  getCurrentPrefixWithGlobalPrefix:::macroPrefix:::::selectionPrefix:::::keepComment:
- (NSString *)getCurrentPrefixWithGlobalPrefix:(NSString *)globalS:(NSArray *)globalICsBefore:(NSArray *)globalICsAfter
        macroPrefix:(NSString *)macro:(NSArray *)macro1stICsBefore:(NSArray *)macro1stICsAfter:(NSArray *)macroICsBefore:(NSArray *)macroICsAfter
            selectionPrefix:(NSString *)selection:(NSArray *)selection1stICsBefore:(NSArray *)selection1stICsAfter:(NSArray *)selectionICsBefore:(NSArray *)selectionICsAfter
                keepComment:(BOOL)keepComment;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{DIAGNOSTIC4iTM3;
    NSMutableString * currentPrefix = [NSMutableString string];
    NSString * S = nil;
    NSRange R;
    //  Here is the situation: we have just inserted a substring of macro with a part of the selection which ends with an EOL.
    //  We are now inserting the next line and manage the indentation
    //  What is the relative indentation depth of the current macro substring
    //  The main problem concerns the management of comments
    
#   define indentationDepthBefore4iTM3 count
    const NSUInteger globalDepth = globalICsBefore.indentationDepthBefore4iTM3 + globalICsAfter.indentationDepth4iTM3;
    const NSUInteger macroDepth = macroICsBefore.indentationDepthBefore4iTM3 + macroICsAfter.indentationDepth4iTM3;
    const NSUInteger macro1stDepth = macro1stICsBefore.indentationDepthBefore4iTM3 + macro1stICsAfter.indentationDepth4iTM3;
    const NSUInteger selectionDepth = selectionICsBefore.indentationDepthBefore4iTM3 + selectionICsAfter.indentationDepth4iTM3;
    const NSUInteger selection1stDepth = selection1stICsBefore.indentationDepthBefore4iTM3 + selection1stICsAfter.indentationDepth4iTM3;
    const NSInteger changeInDepth = macroDepth - macro1stDepth + selectionDepth - selection1stDepth;
    const NSInteger expectedDepth = globalDepth + changeInDepth;
    //  Maybe it is < 0
    if (expectedDepth < 0) {
        *(NSInteger *)(&changeInDepth) = 0;
        *(NSInteger *)(&expectedDepth) = 0;
    }
    //  Managing the comment
    iTM2IndentationComponent * globalCommentIC = macroICsAfter.count?[macroICsAfter objectAtIndex:0]:nil;
    iTM2IndentationComponent * macroCommentIC = macroICsAfter.count?[macroICsAfter objectAtIndex:0]:nil;
    iTM2IndentationComponent * selectionCommentIC = selectionICsAfter.count?[selectionICsAfter objectAtIndex:0]:nil;
    //  Switchers:
    //  The discussion is basically organized with 2 switches
    //  0 - the sign of the change in depth
    //  1 - the header starts with a comment or a comment sequence
    NSUInteger globalHeaderCommentLength = globalICsBefore.count || globalCommentIC.contentLength ? 0: globalCommentIC.commentLength;
    NSUInteger macroHeaderCommentLength = macroICsBefore.count || macroCommentIC.contentLength ? 0: macroCommentIC.commentLength;
    NSUInteger selectionHeaderCommentLength = selectionICsBefore.count || selectionCommentIC.contentLength ? 0: selectionCommentIC.commentLength;
    //  which ...HeaderCommentLength is larger correponds to the switcher
    //  First stage:
    //  - set the comment header if necessary
    //  - prepare for further management
    iTM2IndentationComponent * IC = nil;
    NSEnumerator * E = nil;
    NSUInteger depth = 0;
    NSUInteger length = 0;
    iTM2LiteScanner * LS = nil;
#   define isSelectionHeaderComment (macroHeaderCommentLength <= selectionHeaderCommentLength && globalHeaderCommentLength <= macroHeaderCommentLength && selectionHeaderCommentLength > 0)
    if (isSelectionHeaderComment) {
        //  First copy the selection comment sequence as heading of currentPrefix 
        R.location = selectionCommentIC.location;
        R.length = selectionCommentIC.commentLength;//  selectionCommentIC.contentLength == 0
        S = [selection substringWithRange:R];
        [currentPrefix appendString:S];
        //  May be this is all
        depth = R.length / self.numberOfSpacesPerTab;
        if (depth > expectedDepth) {
            S = [self whiteTrailerForComponentString:S];
            [currentPrefix appendString:S];
//          goto terminate_and_return_currentPrefix;
        } else if (depth == expectedDepth) {
            //  terminate here
            //  manage the remainder
            IC = selectionICsAfter.lastObject?:selectionICsBefore.lastObject;
            if (!IC.endsWithTab && (length = IC.length % self.numberOfSpacesPerTab) > (R.length %= self.numberOfSpacesPerTab)) {
                //  length is what we expect
                //  R.length is what we have
                S = [@"" stringByPaddingToLength:length-R.length withString:@" " startingAtIndex:0];
                [currentPrefix appendString:S];
            } else {
                S = [self whiteTrailerForComponentString:S];
                [currentPrefix appendString:S];
            }
//          goto terminate_and_return_currentPrefix;
        } else /* if (depth < expectedDepth) */ {
            //  terminate from here
            //  complete to a full component
            S = [self stringComplementForLength:R.length];
            if (S.length) {
                [currentPrefix appendString:S];
                ++depth; // updated depth of currentPrefix
            }
            //  complete to the expectedDepth
            S = [self indentationStringWithDepth:expectedDepth-depth];
            [currentPrefix appendString:S];
            //  Keep the extra space of the last indentation component
            if (changeInDepth < 0) {
                //  No extra space allowed
                IC = nil;
            } else if (changeInDepth == 0) {
                //  Manage the last component
                //  We take the extra white space from the global indentation to preserve global alignment
                IC = globalICsAfter.lastObject?:globalICsBefore.lastObject;
            } else /* if (changeInDepth > 0) */ {
                //  Manage the last component
                //  Here it comes from selection
                IC = selectionICsAfter.lastObject?:selectionICsBefore.lastObject;
            }
            //  Append either an alignment string computed from IC or a separating space
            if (!IC.endsWithTab && (length = IC.length % self.numberOfSpacesPerTab)) {
                S = [@"" stringByPaddingToLength:length withString:@" " startingAtIndex:0];
            } else {
                S = [self whiteTrailerForComponentString:S];
            }
            [currentPrefix appendString:S];
//          goto terminate_and_return_currentPrefix;
        }
    } else /* if (!isSelectionHeaderComment) and */
#   define isMacroHeaderComment (globalHeaderCommentLength <= macroHeaderCommentLength && macroHeaderCommentLength > 0)
    if (isMacroHeaderComment) {
        //  The comment sequence comes from the macro, quite every other comment sequence is ignored
        //  First copy the macro comment sequence as heading of currentPrefix
        //  The code is very similar to the one in the block above
        R.location = macroCommentIC.location;
        R.length = macroCommentIC.commentLength;
        S = [macro substringWithRange:R];
        [currentPrefix appendString:S];
        //  May be this is all
        depth = R.length / self.numberOfSpacesPerTab;
        if (depth > expectedDepth) {
            S = [self whiteTrailerForComponentString:S];
            [currentPrefix appendString:S];
//          goto terminate_and_return_currentPrefix;
        } else if (depth == expectedDepth) {
            //  terminate here
            //  manage the remainder based on macro's last indentation component
            IC = macroICsAfter.lastObject?:macroICsBefore.lastObject;
            if (!IC.endsWithTab && (length = IC.length % self.numberOfSpacesPerTab) > (R.length %= self.numberOfSpacesPerTab)) {
                //  length is what we expect
                //  R.length is what we have
                S = [@"" stringByPaddingToLength:length-R.length withString:@" " startingAtIndex:0];
                [currentPrefix appendString:S];
            } else {
                S = [self whiteTrailerForComponentString:S];
                [currentPrefix appendString:S];
            }
        } else /* if (depth < expectedDepth) */ {
            //  terminate from here
            //  complete to a full component
            S = [self stringComplementForLength:R.length];
            if (S.length) {
                [currentPrefix appendString:S];
                ++depth; // updated depth of currentPrefix
            }
            //  complete to the expectedDepth
            S = [self indentationStringWithDepth:expectedDepth-depth];
            [currentPrefix appendString:S];
            if (changeInDepth < 0) {
                //  No extra space allowed
                IC = nil;
            } else if (changeInDepth == 0) {
                //  Manage the last component
                //  We take the extra white space from the global indentation to preserve global alignment
                IC = globalICsAfter.lastObject?:globalICsBefore.lastObject;
            } else /* if (changeInDepth > 0) */ {
                //  Manage the last component
                IC = macroICsAfter.lastObject?:macroICsBefore.lastObject;
            }
            if (!IC.endsWithTab && (length = IC.length % self.numberOfSpacesPerTab)) {
                S = [@"" stringByPaddingToLength:length withString:@" " startingAtIndex:0];
            } else {
                S = [self whiteTrailerForComponentString:S];
            }
            [currentPrefix appendString:S];
//          goto terminate_and_return_currentPrefix;
        }
    } else /* if (!isMacroHeaderComment) and */
    if (expectedDepth <= globalICsBefore.indentationDepthBefore4iTM3 && selectionCommentIC) {
        //  The resulting indentation taken form the globalS is uncommented
        //  But the selection is commented
        length = selectionCommentIC.contentLength + selectionCommentIC.commentLength;
        R.location = selectionCommentIC.location;
        R.length = length;
        S = [macro substringWithRange:R];
        [currentPrefix appendString:S];
        if ((depth = length / self.numberOfSpacesPerTab) < expectedDepth) {
            // complete the indentation component
            S = [self stringComplementForLength:length];
            if (S.length) {
                [currentPrefix appendString:S];
                ++depth;
            }
            //  complete to the expected depth
            S = [self indentationStringWithDepth:expectedDepth - depth];
            [currentPrefix appendString:S];
        }
        //  eventually, compmlete with a separating space
        S = [self whiteTrailerForComponentString:S];
        [currentPrefix appendString:S];
//        goto terminate_and_return_currentPrefix;
    } else /* we can ignore comments from the selection */
    if (changeInDepth < 0) {
        //  Keep from globalS only what is necessary
        //  Simplest situation
        //  Things behave differently whether I must keep the comment or not
        //  Maybe I will always use the NO option but here are both implementations
        if (keepComment) {
            if ( globalCommentIC) {
                //  The comment sequence is kept
                //  That makes an uncompressible depth level
                if ((depth = globalCommentIC.commentLength/self.numberOfSpacesPerTab) >= expectedDepth) {
                    //  this uncompressible depth is sufficient
add_the_comment_sequence:
                    S = [globalS substringWithRange:globalCommentIC.commentRange];
                    [currentPrefix appendString:S];
                    //  Add a trailing white character?
add_a_trailing_white_character_and_return:
                    IC = globalICsAfter.lastObject;
                    if ([[NSCharacterSet whitespaceCharacterSet] characterIsMember:[globalS characterAtIndex:IC.nextLocation-1]]) {
                        //  Which kind of character should I use
                        S = [self stringComplementForLength:globalCommentIC.commentLength];
                        if (S.length == 1) {
                            [currentPrefix appendString:S];
                        } else {
                            [currentPrefix appendString:@" "];
                        }
                    }
                    goto terminate_and_return_currentPrefix;
                } else /* globalCommentIC.commentLength/self.numberOfSpacesPerTab < expectedDepth */
                if ((depth = (globalCommentIC.contentLength+globalCommentIC.commentLength)/self.numberOfSpacesPerTab) >= expectedDepth) {
                    //  this depth is sufficient
                    //  In fact, as the globalCommentIC.contentLength < self.numberOfSpacesPerTab we have == not just >=
                    // (globalCommentIC.contentLength+globalCommentIC.commentLength)/self.numberOfSpacesPerTab == expectedDepth
add_the_comment_sequence_and_white_header:
                    R.location = globalCommentIC.location;
                    R.length = globalCommentIC.contentLength;
                    S = [globalS substringWithRange:R];
                    [currentPrefix appendString:S];
                    goto add_the_comment_sequence;
                } else /* ((depth = globalCommentIC.contentLength+globalCommentIC.commentLength)/self.numberOfSpacesPerTab) < expectedDepth */
                if ((depth + globalICsBefore.indentationDepthBefore4iTM3) >= expectedDepth) {
                    //  enough material before
                    //  Before the comment, all the indentation components have depth 1
                    //  The cumulative depth is just the index
                    depth = expectedDepth - depth;
                    IC = [globalICsBefore objectAtIndex:0];
                    R.location = IC.location;
                    IC = [globalICsBefore objectAtIndex:depth-1];
                    R.length = IC.nextLocation - R.location;
                    S = [globalS substringWithRange:R];
                    [currentPrefix appendString:S];
                    goto add_the_comment_sequence_and_white_header;
                } else /* (depth + globalICsBefore.indentationDepthBefore4iTM3) < expectedDepth */ {
                    //  Everything from globalICsBefore is kept
                    if (globalICsBefore.count) {
                        IC = [globalICsBefore objectAtIndex:0];
                        R.location = IC.location;
                    } else {
                        //  there is nothing in globalICsBefore
                        R.location = globalCommentIC.location;
                    }
                    depth = expectedDepth - globalICsBefore.indentationDepthBefore4iTM3;
                    if (globalCommentIC.depth > depth) {
                        //  Where should I break globalCommentIC?
                        //  rescan this indentation component and break as soon as possible
                        LS = [self liteScannerWithString:globalS];
                        //  start scanning after the first comment sequence
                        LS.scanLocation = globalCommentIC.location + globalCommentIC.contentLength + globalCommentIC.commentLength;
break_and_return:
                        //  We will not scan any tab
                        LS.scanLimit = LS.scanLocation + depth * self.numberOfSpacesPerTab;
                        while ([LS scanCommentCharacter] || [LS scanCommentSequence] || [LS scanCharacter:' ']) {
                            continue;
                        }
                        R.length = LS.scanLocation - R.location;
                        S = [globalS substringWithRange:R];
                        [currentPrefix appendString:S];
                        if (length = LS.scanLimit - LS.scanLocation) {
                            //  length is a number of chars to have the proper depth
                            S = [self stringComplementForLength:LS.scanLocation - globalCommentIC.location];
                            [currentPrefix appendString:S];
                            if (S.length < length) {
                                length -= S.length;
                                //  length corresponds to complete indentation components
                                S = [self indentationStringWithDepth:length / self.numberOfSpacesPerTab];
                                [currentPrefix appendString:S];
                            }
                            //  The prefix already ends with a white character
                            goto terminate_and_return_currentPrefix;
                        }
                        goto add_the_comment_sequence_and_white_header;
                    } else /* globalCommentIC.depth <= depth */ {
                        E = globalICsAfter.objectEnumerator;
                        IC = E.nextObject;// skip the first object which is nothing but globalCommentIC
                        while (depth -= IC.depth && (IC = E.nextObject)) {
                            if (IC.depth > depth) {
                                //  too big, break
                                LS = [self liteScannerWithString:globalS];
                                //  start scanning after the first comment sequence
                                LS.scanLocation = IC.location;
                                goto break_and_return;
                            }
                        } 
                        //  end of the while loop when
                        //  either depth == 0 or no more objects available
                        //  as changeInDepth<0, the only possibility is depth = 0
                        R.length = IC.nextLocation - R.location;
                        S = [globalS substringWithRange:R];
                        [currentPrefix appendString:S];
                        goto add_a_trailing_white_character_and_return;
                    }
                    UNREACHABLE_CODE4iTM3;
                }
                UNREACHABLE_CODE4iTM3;
            } else /* no globalCommentIC */
            if ((depth = selectionCommentIC.commentLength / self.numberOfSpacesPerTab) >= expectedDepth) {
                // just copy this comment sequence and terminate;
                S = [macro substringWithRange:selectionCommentIC.commentRange];
                [currentPrefix appendString:S];
                goto add_a_trailing_white_character_and_return;
            } else /* (depth = macroCommentIC.commentLength / self.numberOfSpacesPerTab) < expectedDepth */
            if ((depth = (selectionCommentIC.contentLength + selectionCommentIC.commentLength) / self.numberOfSpacesPerTab) >= expectedDepth) {
                //  In fact we have ==, not only >=
add_macro_comment:            
                R.location = selectionCommentIC.location;
                R.length = selectionCommentIC.contentLength + selectionCommentIC.commentLength;
                S = [macro substringWithRange:selectionCommentIC.commentRange];
                [currentPrefix appendString:S];
                goto add_a_trailing_white_character_and_return;
            } else /* (depth = (selectionCommentIC.contentLength + selectionCommentIC.commentLength) / self.numberOfSpacesPerTab) < expectedDepth */ {
                //  due to the fact that globalICsActer is void
                //  globalICsBefore.indentationDepthBefore4iTM3 >= expectedDepth > depth
                //  as a consequence, globalICsBefore is not void
                IC = [globalICsBefore objectAtIndex:0];
                R.location = IC.location;
                IC = [globalICsBefore objectAtIndex:expectedDepth-depth-1];
                R.length = IC.nextLocation - R.location;
                S = [globalS substringWithRange:R];
                [currentPrefix appendString:S];
                goto add_macro_comment;
            }
            UNREACHABLE_CODE4iTM3;
        } else /* !keepComment */
        if (!expectedDepth) {
            goto terminate_and_return_currentPrefix;
        } else /* !keepComment && expectedDepth */
        if (expectedDepth <= globalICsBefore.indentationDepthBefore4iTM3) {
            IC = [globalICsBefore objectAtIndex:0];
            R.location = IC.location;
            IC = [globalICsBefore objectAtIndex:expectedDepth-1];
            R.length = IC.nextLocation - R.location;
            S = [globalS substringWithRange:R];
            [currentPrefix appendString:S];
            goto terminate_and_return_currentPrefix;
        } else /* expectedDepth > globalICsBefore.indentationDepthBefore4iTM3 */ {
            //  the indentation components before any comment are kept
            IC = globalICsBefore.indentationDepthBefore4iTM3? [globalICsBefore objectAtIndex:0]:globalCommentIC;
            R.location = IC.location;
            //  missing depth:
            depth = expectedDepth - globalICsBefore.indentationDepthBefore4iTM3;
            E = globalICsAfter.objectEnumerator;
            while (IC = E.nextObject) {
                if (IC.depth < depth) {
                    depth -= IC.depth;
                    continue;
                } else if (IC.depth == depth) {
                    //  terminate here simply
                    R.length = IC.nextLocation - R.location;
                    S = [globalS substringWithRange:R];
                    [currentPrefix appendString:S];
                    goto add_a_trailing_white_character_and_return;
                } else {
                    //  break IC
                    LS = [self liteScannerWithString:globalS];
                    LS.scanLocation = IC.location;
                    LS.scanLimit = IC.location + depth * self.numberOfSpacesPerTab;
                    while ([LS scanCommentCharacter] || [LS scanCommentSequence] || [LS scanCharacter:' ']) {
                        continue;
                    }
                    //  LS.scanLimit - LS.scanLocation unscanned character
                    if (LS.scanLimit > LS.scanLocation) {
                        R.length = LS.scanLocation - R.location;
                        S = [globalS substringWithRange:R];
                        [currentPrefix appendString:S];
                        //  We will append a component with depth (LS.scanLimit - LS.scanLocation)/self.numberOfSpacesPerTab
                        //  This will not cover LS.scanLimit - LS.scanLocation in general
                        //  The uncovered part is LS.scanLimit - LS.scanLocation%self.numberOfSpacesPerTab
                        //  This correspond exactly to what is needed to complete the string before
                        S = [self stringComplementForLength:S.length];
                        [currentPrefix appendString:S];
                        S = [self indentationStringWithDepth:(LS.scanLimit - LS.scanLocation)/self.numberOfSpacesPerTab];
                        [currentPrefix appendString:S];
                        //  No need add a trailer character
                        goto terminate_and_return_currentPrefix;
                    } else {
                        goto add_a_trailing_white_character_and_return;
                    }
                }
            }   // end of while loop
            //  the loop must break before the end
            UNREACHABLE_CODE4iTM3;
            goto terminate_and_return_currentPrefix;
        }
    } else /* if (changeInDepth >= 0) */ 
    if (!macroDepth || !changeInDepth) {
        //  nothing to add
        //  Keep the indentation as is
        R = globalICsBefore.indentationRange4iTM3;
        if (R.length) {
            S = [globalS substringWithRange:R];
            [currentPrefix appendString:S];
        }
        //  globalICsAfter is not void
        R = globalICsAfter.indentationRange4iTM3;
        if (R.length) {
            S = [globalS substringWithRange:R];
            [currentPrefix appendString:S];
        }
        goto terminate_and_return_currentPrefix;
    } else /* if (macroDepth && changeInDepth) */ {
        //  How Do I manage the last global indentation component
        //  If this last component is uncomplete, I should skip its last part.
        //  The problem is whether this component has a depth or not
        if (IC = globalICsBefore.count? [globalICsBefore objectAtIndex:0]:globalCommentIC) {
            //  There is a last object
            R.location = IC.location;
            IC = globalICsAfter.lastObject?:globalICsBefore.lastObject;
            if (!IC.depth || IC.endsWithTab) {
                //  all the indentation components are complete
                R.length = IC.location - R.location;
                S = [globalS substringWithRange:R];
                [currentPrefix appendString:S];
            } else if (IC.length % self.numberOfSpacesPerTab) {
                //  This is an uncomplete component
                //  Can I break it? rescan it to know
                LS = [self liteScannerWithString:globalS];
                length = IC.contentLength + IC.commentLength;
                LS.scanLocation = IC.location + length;
                LS.scanLimit = IC.nextLocation - IC.length % self.numberOfSpacesPerTab;
                if (LS.scanLocation >= LS.scanLimit) {
                    //  I can't break before
                    R.length = LS.scanLocation - R.location;
                    S = [globalS substringWithRange:R];
                    [currentPrefix appendString:S];
                    S = [self stringComplementForLength:length];
                    [currentPrefix appendString:S];
                    //  I just have to adjust to the proper depth
                    depth = changeInDepth - 1;
                } else /* if (LS.scanLocation < LS.scanLimit) */ {
                    while ([LS scanCommentCharacter] || [LS scanCommentSequence] || [LS scanCharacter:' ']) {
                        continue;
                    }
                    R.length = LS.scanLocation - R.location;
                    S = [globalS substringWithRange:R];
                    [currentPrefix appendString:S];
                    if (length = LS.scanLimit - LS.scanLocation) {
                        if (depth = length / self.numberOfSpacesPerTab) {
                            S = [self indentationStringWithDepth:depth];
                            [currentPrefix appendString:S];
                        }
                        S = [self stringComplementForLength:self.numberOfSpacesPerTab - length % self.numberOfSpacesPerTab];
                        [currentPrefix appendString:S];
                    }
                    depth = changeInDepth;
                }
            } else {
                depth = changeInDepth;
            }
        } else /* if (!(globalICsBefore.count? [globalICsBefore objectAtIndex:0]:globalCommentIC)) */ {
            //  Nothing in the global indentation
            depth = changeInDepth;
        }
        S = [self indentationStringWithDepth:depth];
        [currentPrefix appendString:S];
        //  Preserve the remainder
        IC = macroICsAfter.lastObject?:macroICsBefore.lastObject;
        if (length = IC.length % self.numberOfSpacesPerTab) {
            S = [@"" stringByPaddingToLength:length withString:@" " startingAtIndex:0];
            [currentPrefix appendString:S];
        }
    }
terminate_and_return_currentPrefix:
    return currentPrefix;
}
@end

@implementation NSTextView(iTM2ExecuteMacro)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  tryToExecuteMacroWithID4iTM3:
- (BOOL)tryToExecuteMacroWithID4iTM3:(NSString *)macro;
/*"Description forthcoming.
If the event is a 1 char key down, it will ask the current key binding for macro.
The key and its modifiers are 
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    ICURegEx * RE = [ICURegEx regExForKey:iTM2RegExpMKSelectorArgumentKey error:NULL];
    if ([RE matchString:macro]) {
        SEL action = NSSelectorFromString([RE substringOfCaptureGroupAtIndex:1]);
		if ([self respondsToSelector:action]) {
			NSString * argument = [RE numberOfCaptureGroups]>1?[RE substringOfCaptureGroupAtIndex:2]:nil;
			if ([self tryToPerform:action with:argument]) {
				return YES;
			}
		}
    }
//END4iTM3;
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  getSelectionComponentsAtIndex4iTM3:inSelections:defaultValue:withScanner:
- (NSArray *)getSelectionComponentsAtIndex4iTM3:(NSInteger)i inSelections:(NSMutableArray *)selections defaultValue:(NSString *)defaultValue:(NSValue *)rangeValue withScanner:(iTM2LiteScanner *)LS;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (1.0.10)
- 1.2: 06/24/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    id O = nil;
    NSRange selectedRange, lineRange;
    NSString * reference = [LS string];
    NSMutableArray * mra;
    iTM2StringController * SC = self.stringController4iTM3;
    if (i+selections.count<0) {
        i = NSNotFound;// default value
    } else if (i>=selections.count) {
        i = NSNotFound;// default value
    } else if (i<0) {
        i = selections.count+i;
    }
    NSMutableArray * ICsBefore = nil;
    NSMutableArray * ICsAfter  = nil;
    if (i<selections.count) {
        // use the selection
        O = [selections objectAtIndex:i];
        if ([O isKindOfClass:[NSValue class]]) {
            selectedRange = [O rangeValue];
            // this is the first time we use this selection
            // we build the selection as an array of components
            // and we replace the range with that array
            mra = [NSMutableArray array];
            [mra addObject:reference];// this is the reference string, sometimes ranges are given instead of substrings, no copy
            //  Is it a word boundary? Does it follow a witespace character?
            if (!selectedRange.location || [[NSCharacterSet whitespaceCharacterSet] characterIsMember:[reference characterAtIndex:selectedRange.location-1]]) {
                [mra addObject:@" "];
            } else {
                [mra addObject:@""];
            }
            lineRange = selectedRange;
            lineRange.length = 0;
            //  get the first indentation components:
            //  start with the full range of the first line
            [reference getLineStart:&lineRange.location end:NULL contentsEnd:NULL forRange:lineRange];
            LS.scanLocation = lineRange.location;
            LS.scanLimit = selectedRange.location;
            //  compute the indentation components
            [SC getIndentationComponents:&ICsBefore:&ICsAfter withScanner:LS];
            //  store them, no need to copy
            [mra addObject:ICsBefore];
            [mra addObject:ICsAfter];
            if (selectedRange.length) {
                // now get the black and white characters from R.location til the end of the line or the selection
                lineRange.location = LS.scanLocation = selectedRange.location;// record and set the current position of the scanner
                //  It is possible for selectedRange.location to be separated from the indentation components by black characters
                while ([LS scanUpToEOLIntoString:nil] && [LS scanEOLIntoString:nil]) {
                    lineRange.length = LS.scanLocation - lineRange.location;
                    [mra addObject:[reference substringWithRange:lineRange]];// black or white content substring
                    //  get the next indentation components
                    [SC getIndentationComponents:&ICsBefore:&ICsAfter withScanner:LS];
                    //  store them, no need to copy
                    [mra addObject:ICsBefore];
                    [mra addObject:ICsAfter];
                    //  record the scanner location
                    lineRange.location = LS.scanLocation;
                    //  scan the rest of the selected line
                }
                //  neither selected string
                //  nor more EOL in the selection
                lineRange.length = iTM3MaxRange(selectedRange) - lineRange.location;
                [mra addObject:[reference substringWithRange:lineRange]];// black or white content substring
            } else {
                //  neither selected string
                //  nor EOL in the selection
                [mra addObject:@""];// black or white content substring
            }
            O = mra;
            [selections replaceObjectAtIndex:i withObject:O];
            mra = nil;
        }
    } else {
        //  use the default value
        //  we duplicate what is done above adapting to the local context
        reference = [defaultValue substringWithRange:[rangeValue rangeValue]];
        if ([reference isKindOfClass:[NSString class]]) {
            selectedRange = iTM3MakeRange(0,reference.length);
            // this is the first time we use this selection
            // we build the selection as an array of components
            // and we replace the range with that array
            mra = [NSMutableArray array];
            [mra addObject:reference];// this is the reference string, sometimes ranges are given instead of substrings, no copy
            //  It is indeed a word boundary
            [mra addObject:@" "];
            //  the leadinf indentation components before the selected range are always void
            [mra addObject:[NSMutableArray array]];
            [mra addObject:[NSMutableArray array]];
            // now get the black and white characters from R.location til the end of the line or the selection
            //  It is possible for selectedRange.location to be separated from the indentation components by black characters
            if (selectedRange.length) {
                lineRange = selectedRange;
                while ([LS scanUpToEOLIntoString:nil] && [LS scanEOLIntoString:nil]) {
                    lineRange.length = LS.scanLocation - lineRange.location;
                    [mra addObject:[reference substringWithRange:lineRange]];// black or white content substring
                    //  get the next indentation components
                    [SC getIndentationComponents:&ICsBefore:&ICsAfter withScanner:LS];
                    //  store them, no need to copy
                    [mra addObject:ICsBefore];
                    [mra addObject:ICsAfter];
                    //  record the scanner location
                    lineRange.location = LS.scanLocation;
                    //  scan the rest of the selected line
                }
                //  neither selected string
                //  nor EOL in the selection
                lineRange.length = iTM3MaxRange(selectedRange) - lineRange.location;
                [mra addObject:[reference substringWithRange:lineRange]];// black or white content substring
            } else {
                //  neither selected string
                //  nor EOL in the selection
                [mra addObject:@""];// black or white content substring
            }
            O = mra;
            mra = nil;
        } else {
            NSAssert(NO,@"Macro Kit Exception. defaultValue must be a string.");
        }
    }
    return O;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  concreteReplacementStringForMacro4iTM3:inRange:
- (NSString *)concreteReplacementStringForMacro4iTM3:(NSString *)macro inRange:(NSRange)affectedCharRange;
/*"The purpose is to translate some keywords into the value they represent.
This is also used with scripts.
The most difficult part comes from the management of indentation and commenting.
Version history: jlaurens AT users DOT sourceforge DOT net (1.0.10)
- 1.2: 06/24/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    iTM2StringController * SC = self.stringController4iTM3;
    //  Check if the placeholders must be ignored (prefs)
    if ([self context4iTM3BoolForKey:iTM2DontUseSmartMacrosKey domain:iTM2ContextPrivateMask|iTM2ContextExtendedMask]) {
        macro = [SC stringByRemovingPlaceholderMarksInString:macro];
    }
    //  Where do I insert the macro? in affectedCharRange or in the pasteboard.
    //  This affects the indentation.
    //  We assume that the given inserted macro corresponds to a 0 indentation level
    //  so we must edit it if the actual indentation level at the insertiong point is > 0
    NSString * globalS = self.string;
    iTM2LiteScanner * LS = [iTM2LiteScanner scannerWithString:globalS charactersToBeSkipped:nil];
    NSRange R = iTM3MakeRange(0,0);
    NSMutableArray * globalICsBefore = nil;
    NSMutableArray * globalICsAfter = nil;
    if (affectedCharRange.location<globalS.length) {// paste in the text
        //  What is the indentation at the beginning of the line where we insert
        //  and before the insertion location.
        //  Get the location of the beginning of the line:
        [globalS getLineStart:&R.location end:nil contentsEnd:nil forRange:affectedCharRange];
        //  Get the indentation components:
        LS.scanLocation = R.location;
        LS.scanLimit = affectedCharRange.location;
        [SC getIndentationComponents:&globalICsBefore:&globalICsAfter withScanner:LS];
        R = iTM3MakeRange(0,0);
    }
    //  How do we insert the macro?
    //  1 - prepare the macro for further management
    //  2 - edit the macro preparation depending on
    //  2 - a - the current selection
    //  2 - b - the indentation depth at the insertion point
    //  3 - Insert the macro at the proper position
    //
    //  1 - prepare the macro for further management
    //  Split the macro string into components, separating lines, placeholders and indentation components.
    NSMutableArray * macroComponents = [SC componentsOfMacroForInsertion:macro];
//  1 - description of a full line ending with an EOL marker, no SEL placeholder inside, no EOL inside, or nothing
//      what is recorded:
//      a)  the indentation components before the comment
//      b)  the indentation components after the comment
//      c)  the range up to and including an EOL
//  2 - description of a full line eventually ending with an EOL marker, SEL placeholders inside,
//      no EOL inside (except inside SEL placeholders themselves), or nothing
//      what is recorded:
//      a)  the indentation components before the comment
//      b)  the indentation components after the comment
//      c)  the range of a string with no EOL, no SEL
//      a list of
//      d)  index of a SEL placeholder wrapped in a NSNumber
//      e)  the range of the default value of this SEL placeholder
//      terminating the list
//      f)  range of a string up to and including an EOL, no SEL, no EOL inside
NSLog(@"macro:<%@>",macro);
NSLog(@"components:<%@>",macroComponents);
    //  Now we can assume that components has more than one object
    //  2 - edit the macro preparation depending on the components
    //  Edit the components array in place and replace the objects concerning SEL with the actual selected text.
    //  Also manage the indentation.
    // For each component of the components array, either we keep it as is, or we replace it with a proper value
    // The main problem concerns indentation changes, see explanation above
    // The selected text might be used in the macro
    // If we really need some selected text, then we replace the range by the selection
    // It saves some time and memory
    //  In this loop, we create an array of strings named MRA
    //  When these strings are merged we obtain exactly what should be inserted
    //  Let us notice a problem of comments:
    //  If the last line of the macro contains a comment
    //  The original text after the insertion range will be commented out
    //  If this text was already commented out, there is no problem
    //  If this text was not commented out, there is a risk that the semantic changes
    //  and the begaviour was not expected
    //  The solution is to avoid trailing comments on macros unless necessary.
    NSMutableArray * MRA = [NSMutableArray array];
    NSMutableArray * selections = macroComponents.count?[[self.selectedRanges mutableCopy] autorelease]:nil;
    NSMutableArray * ICsBefore = nil;
    NSMutableArray * ICsAfter = nil;
    NSEnumerator * E = macroComponents.objectEnumerator;
    NSValue * V = nil;
    if ((ICsBefore = E.nextObject) && (ICsAfter = E.nextObject) && (V = E.nextObject)) {
        //  This is the beginning of macro: copy as is
        NSRange macroRange = [V rangeValue];
        macroRange.length = iTM3MaxRange(macroRange);
        macroRange.location = 0;
        NSString * S = [macro substringWithRange:macroRange];
        [MRA addObject:S];//    S = nil
        NSRange RR = [globalICsBefore indentationRange4iTM3];
        NSString * currentPrefix = [globalS substringWithRange:RR];
        RR = [globalICsAfter indentationRange4iTM3];
        S = [globalS substringWithRange:RR];
        currentPrefix = [currentPrefix stringByAppendingString:S];
        NSArray * macro1stICsBefore = nil;
        NSArray * macro1stICsAfter = nil;
        NSArray * macroICsBefore = nil;
        NSArray * macroICsAfter = nil;
        id component = nil;
        while ((component = E.nextObject)) {
            if ([component isKindOfClass:[NSArray class]]) {
                //  This is the uncommented indentation components
                ICsBefore = component;
                //  I must insert the global indentation
                if ((ICsAfter = E.nextObject) && (V = E.nextObject)) {
                    //  things are equivalent to this
                    //  Suppose that the contents of the current macro line is a line of the main text
                    //  and is the se:selection:selection1stICsBefore:selection1stICsAfter:selectionICsBefore:selectionICsAfterlection
                    //  then the macro "__(SEL)__" is applied
                    //  then the selection prefix is in fact the original macro line prefix
                    //  the new macro prefix is completely void
                    currentPrefix = [SC getCurrentPrefixWithGlobalPrefix:globalS:globalICsBefore:globalICsAfter
                                macroPrefix:nil:nil:nil:nil:nil
                                    selectionPrefix:macro:macro1stICsBefore:macro1stICsAfter:macroICsBefore:macroICsAfter
                                        keepComment:YES];
                    [MRA addObject:currentPrefix];//    S = nil
                    macroRange = [V rangeValue];
                    S = [macro substringWithRange:macroRange];
                    [MRA addObject:S];//    S = nil
                    continue;
                } else {
                    RAISE_INCONSISTENCY4iTM3(@"Bad indentation management");
                    return nil;
                }
            } else if ([component isKindOfClass:[NSNumber class]]) {
                //  This is a selection number
                NSInteger i = [component integerValue];// the index of a SEL
                id defaultRangeValue = E.nextObject;// default value, in case no selection is available, the range of the default text in the macro
                if (defaultRangeValue) {
                    NSArray * selectionComponents = [self getSelectionComponentsAtIndex4iTM3:i inSelections:selections defaultValue:macro:defaultRangeValue withScanner:LS];
                    NSEnumerator * EE = selectionComponents.objectEnumerator;
                    NSString * selection = EE.nextObject;
                    S = EE.nextObject;//  the eventual space for word boundary
                    NSArray * selection1stICsBefore = EE.nextObject;
                    NSArray * selection1stICsAfter = EE.nextObject;
                    if (selection && S && selection1stICsBefore && selection1stICsAfter && (V = EE.nextObject)) {
                        //  should I insert a space character before?
                        if ([[NSCharacterSet whitespaceCharacterSet] characterIsMember:[MRA.lastObject lastCharacter4iTM3]] && S.length) {
                            [MRA addObject:S];
                        }//    S = nil
                        R = [V rangeValue];
                        S = [selection substringWithRange:R];
                        [MRA addObject:S];//    S = nil
                        //  This is the first line of the selection 
                        //  If this line includes an EOL, then there is more stuff after
                        //  aka ICsBefore, ICsAfter and range
                        NSArray * selectionICsBefore;
                        while (selectionICsBefore = EE.nextObject) {
                            NSArray * selectionICsAfter = EE.nextObject;
                            if (selectionICsAfter && (V = EE.nextObject)) {
                                currentPrefix = [SC getCurrentPrefixWithGlobalPrefix:globalS:globalICsBefore:globalICsAfter
                                        macroPrefix:macro:macro1stICsBefore:macro1stICsAfter:macroICsBefore:macroICsAfter
                                            selectionPrefix:selection:selection1stICsBefore:selection1stICsAfter:selectionICsBefore:selectionICsAfter
                                                keepComment:YES];
                                [MRA addObject:currentPrefix];
                                R = [V rangeValue];
                                S = [selection substringWithRange:R];
                                [MRA addObject:S];//    S = nil
                                //  continue
                            } else {
                                RAISE_INCONSISTENCY4iTM3(@"-1");
                                return nil;
                            }
                        }
                    } else {
                        RAISE_INCONSISTENCY4iTM3(@"1");
                        return nil;
                    }
                } else {
                    RAISE_INCONSISTENCY4iTM3(@"2");
                    return nil;
                }
            } else if ([component isKindOfClass:[NSValue class]]) {
                //  This is a general placeholder
                R = [V rangeValue];
                id defaultRangeValue = E.nextObject;// default value, in case no selection is available, the range of the default text in the macro
                if (defaultRangeValue) {
                } else {
                    RAISE_INCONSISTENCY4iTM3(@"3");
                    return nil;
                }
            } else {
                // no next component
            }
        }
    }
    return [MRA componentsJoinedByString:@""];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertMacro4iTM3:inRange:
- (void)insertMacro4iTM3:(id)argument inRange:(NSRange)affectedCharRange;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (1.0.10)
- 1.2: 06/24/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if ([argument respondsToSelector:@selector(representedObject)]) {
        argument = [argument representedObject];
    }
//  this new part concerns the new macro design. 2006
//  New in 2009: management of the indentation and the comments
//  Indentation takes into account the leading comment characters if any
//  the policy is to use spaces in the beginning of a line and to leave tabs in the middle
//  The beginning of a line is the part before the first character which is not a whitespace nor a comment sequence
//  nor part of a comment character sequence
//  Definition: let us call a full indentation prefix a series of white spaces eventually prefixed with a comment character sequence.
//  If the macro is inserted where some indentation is available, we might be forced to adapt the affectedCharRange
//  Another option would be to append the white prefix of the macro to the white prefix before the affectedCharRange
//  and transform this into a full indentation prefix.
//  If the macro starts with a comment and the affectedCharRange is already commented, remove the comment from the macro.
//  As text is managed by lines, we split the macros into lines.
//  For macros, there are 2 situations depending on the number of SEL's needed
//  Here is a short example of the indentation management
//  Suppose you have the following text:
//  ...
//  \t\t\tfoo bar
//  \t\t\t\tNext line
//  ...
//  If you copy from "bah" to "Next", then we consider somehow that
//  bah
//  \tNext
//  was copied: notice that there is only one \t, which is the relative indentation compared to the foo bar line.
//  Consider now the target text:
//  \t\tTarget Text
//  If we paste the content of the clipboard just before the "T",
//  then this is exactly as if the string
//  bah
//  \t\t\tNext
//  was pasted. This is to preserve the relative indentation between the two lines.
    if ([argument isKindOfClass:[NSString class]])
	{
        NSString * replacementString = [self concreteReplacementStringForMacro4iTM3:argument inRange:affectedCharRange];
        if (affectedCharRange.location == NSNotFound) {
            NSPasteboard * PB = [NSPasteboard generalPasteboard];
            NSArray * newTypes = [NSArray arrayWithObject:NSStringPboardType];
            [PB declareTypes:newTypes owner:nil];
            [PB setString:replacementString forType:NSStringPboardType];
        } else if ([self shouldChangeTextInRange:affectedCharRange replacementString:replacementString]) {
            [self replaceCharactersInRange:affectedCharRange withString:replacementString];
            self.didChangeText;
            [self select1stPlaceholder:self];
        }
        return;
	}
	if ([argument isKindOfClass:[NSArray class]])
	{
        NSEnumerator * E = [argument objectEnumerator];
		if ((argument = E.nextObject))
		{
			[self insertMacro4iTM3:argument inRange:affectedCharRange];
		}
		NSAssert(!E.nextObject,@"Inserting an array of more than one macro is not supported, if this concerns a built in macro please report bug.");
		return;
	}
	if ([argument isKindOfClass:[iTM2MacroNode class]])
	{
		argument = [argument concreteArgument];
		[self insertMacro4iTM3:argument inRange:affectedCharRange];
		return;
	}
    NSLog(@"Don't know what to do with this argument: %@", argument);
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertMacro4iTM3_ROUGH:
- (void)insertMacro4iTM3_ROUGH:(id)argument;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (1.0.10)
- 1.2: 06/24/2002
To Do List:
"*/
{
//LOG4iTM3(@"argument:%@",argument);
	NSRange affectedCharRange = self.selectedRange;
	if ([self shouldChangeTextInRange:affectedCharRange replacementString:argument])
	{
		[self replaceCharactersInRange:affectedCharRange withString:argument];
		self.didChangeText;
	}
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertMacro:
- (void)insertMacro:(id)argument;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (1.0.10)
- 1.2: 06/24/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSRange range = self.selectedRange;
    [self insertMacro4iTM3:argument inRange:range];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertMacro4iTM3_APPEND_ALL:
- (void)insertMacro4iTM3_APPEND_ALL:(id)argument;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (1.0.10)
- 1.2: 06/24/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSRange range = iTM3MakeRange(0,0);
	range.location = self.string.length;
    [self insertMacro4iTM3:argument inRange:range];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertMacro4iTM3_REPLACE_ALL:
- (void)insertMacro4iTM3_REPLACE_ALL:(id)argument;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (1.0.10)
- 1.2: 06/24/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSRange range = iTM3MakeRange(0,0);
	range.length = self.string.length;
    [self insertMacro4iTM3:argument inRange:range];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertMacro4iTM3_PREPEND_ALL:
- (void)insertMacro4iTM3_PREPEND_ALL:(id)argument;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (1.0.10)
- 1.2: 06/24/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSRange range = iTM3MakeRange(0,0);
    [self insertMacro4iTM3:argument inRange:range];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertMacro4iTM3_APPEND_SELECTION:
- (void)insertMacro4iTM3_APPEND_SELECTION:(id)argument;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (1.0.10)
- 1.2: 06/24/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSRange range = self.selectedRange;
	range.location = iTM3MaxRange(range);
	range.length = 0;
    [self insertMacro4iTM3:argument inRange:range];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertMacro4iTM3_REPLACE_SELECTION:
- (void)insertMacro4iTM3_REPLACE_SELECTION:(id)argument;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (1.0.10)
- 1.2: 06/24/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [self insertMacro:argument];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertMacro4iTM3_PREPEND_SELECTION:
- (void)insertMacro4iTM3_PREPEND_SELECTION:(id)argument;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (1.0.10)
- 1.2: 06/24/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSRange range = self.selectedRange;
	range.length = 0;
    [self insertMacro4iTM3:argument inRange:range];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertMacro4iTM3_PREPEND_LINE:
- (void)insertMacro4iTM3_PREPEND_LINE:(id)argument;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (1.0.10)
- 1.2: 06/24/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSRange range = self.selectedRange;
	range.length = 0;
	NSTextStorage * TS = self.textStorage;
	[TS getLineStart:&range.location end:nil contentsEnd:nil forRange:range];
    [self insertMacro4iTM3:argument inRange:range];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertMacro4iTM3_REPLACE_LINE:
- (void)insertMacro4iTM3_REPLACE_LINE:(id)argument;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (1.0.10)
- 1.2: 06/24/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSRange range = self.selectedRange;
	range.length = 0;
	NSTextStorage * TS = self.textStorage;
	[TS getLineStart:&range.location end:&range.length contentsEnd:nil forRange:range];
	range.length -= range.location;
    [self insertMacro4iTM3:argument inRange:range];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertMacro4iTM3_APPEND_LINE:
- (void)insertMacro4iTM3_APPEND_LINE:(id)argument;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (1.0.10)
- 1.2: 06/24/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSRange range = self.selectedRange;
	range.length = 0;
	NSTextStorage * TS = self.textStorage;
	[TS getLineStart:nil end:nil contentsEnd:&range.location forRange:range];
    [self insertMacro4iTM3:argument inRange:range];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertMacro4iTM3_COPY:
- (void)insertMacro4iTM3_COPY:(id)argument;
/*"Description forthcoming. .
Version history: jlaurens AT users DOT sourceforge DOT net (1.0.10)
- 1.2: 06/24/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSRange range = iTM3MakeRange(NSNotFound,0);
    [self insertMacro4iTM3:argument inRange:range];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  concreteReplacementStringForMacro4iTM3:selection:line:
- (NSString *)concreteReplacementStringForMacro4iTM3:(NSString *)macro selection:(NSString *)selection line:(NSString *)line;
/*"The purpose is to translate some keywords into the value they represent.
This is also used with scripts.
Version history: jlaurens AT users DOT sourceforge DOT net (1.0.10)
- 1.2: 06/24/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSMutableString * replacementString = [NSMutableString string];
	NSString * all = self.string;
    NSDocument * D = [self.window.windowController document];
	NSString * path = D.fileURL.path;
	BOOL PERL = NO;
	BOOL RUBY = NO;
	NSString * startType = nil;
	NSString * stopType = nil;
	NSString * copyString = nil;
	NSRange startRange = iTM3MakeRange(0,0);
	NSRange stopRange = iTM3MakeRange(0,0);
	NSRange copyRange = iTM3MakeRange(0,0);
	NSString * perlEscapedSelection = nil;
	NSString * perlEscapedLine = nil;
	NSString * perlEscapedAll = nil;
	NSString * perlEscapedPath = nil;
    iTM2StringController * SC = self.stringController4iTM3;
    
nextRange:
	startRange = [SC rangeOfNextPlaceholderMarkAfterIndex:copyRange.location getType:&startType ignoreComment:YES inString:macro];
	if (startRange.length)
	{
		copyRange.location = iTM3MaxRange(stopRange);
		copyRange.length = startRange.location - copyRange.location;
		copyString = [macro substringWithRange:copyRange];
		[replacementString appendString:copyString];
nextStopRange:
		copyRange.location = iTM3MaxRange(startRange);
		stopRange = [SC rangeOfNextPlaceholderMarkAfterIndex:copyRange.location getType:&stopType ignoreComment:YES inString:macro];
		if (stopRange.length)
		{
			if (!startType)
			{
				// the startRange was in fact a stop placeholder mark range, startType==nil is caracteristic
				copyRange = startRange;
				copyRange.length = iTM3MaxRange(stopRange) - copyRange.location;
				copyString = [macro substringWithRange:copyRange];
				[replacementString appendString:copyString];
				// go for a next pair start+stop
				copyRange.location = iTM3MaxRange(stopRange);
				goto nextRange;
			}
			else if (!stopType)
			{
                // We have a start/stop pair
				if ([startType isEqual:@"SELECTION"] || [startType isEqual:@"MATH"])
				{
					if (selection.length)
					{
						[replacementString appendFormat:@"%@%@%@",SC.startPlaceholderMark,selection,SC.stopPlaceholderMark];
					}
					else
					{
						copyRange.location = iTM3MaxRange(startRange);
						copyRange.length = stopRange.location - copyRange.location;
						if (copyRange.length)
						{
							copyString = [macro substringWithRange:copyRange];
							[replacementString appendFormat:@"%@%@%@",SC.startPlaceholderMark,copyString,SC.stopPlaceholderMark];
						}
					}
				}
				else if ([startType isEqual:@"INPUT_SELECTION"])
				{
					if (selection.length)
					{
						[replacementString appendString:selection];
					}
					else
					{
						copyRange.location = iTM3MaxRange(startRange);
						copyRange.length = stopRange.location - copyRange.location;
						if (copyRange.length)
						{
							copyString = [macro substringWithRange:copyRange];
							[replacementString appendString:copyString];
						}
					}
				}
				else if ([startType isEqual:@"PERL_INPUT_SELECTION"])
				{
					PERL = YES;
					[replacementString appendString:@"my $INPUT_SELECTION= <<__END_OF_INPUT__;\n"];
					if (perlEscapedSelection)
					{
						[replacementString appendString:perlEscapedSelection];
					}
					else if (selection.length)
					{
						perlEscapedSelection = [selection stringByEscapingPerlControlCharacters4iTM3];
						[replacementString appendString:perlEscapedSelection];
					}
					else
					{
						copyRange.location = iTM3MaxRange(startRange);
						copyRange.length = stopRange.location - copyRange.location;
						if (copyRange.length)
						{
							copyString = [macro substringWithRange:copyRange];
							copyString = [copyString stringByEscapingPerlControlCharacters4iTM3];
							[replacementString appendString:copyString];
						}
					}
					[replacementString appendString:@"__END_OF_CONTENT__\n__END_OF_INPUT__\n"];
					[replacementString appendString:@"$INPUT_SELECTION =~ m/(.*)__END_OF_CONTENT__.*/s;\n$INPUT_SELECTION=\"$1\";"];
				}
				else if ([startType isEqual:@"PERL_INPUT_LINE"])
				{
					PERL = YES;
					[replacementString appendString:@"my $INPUT_LINE= <<__END_OF_INPUT__;\n"];
					if (perlEscapedLine)
					{
						[replacementString appendString:perlEscapedLine];
					}
					else if (line.length)
					{
						perlEscapedLine = [line stringByEscapingPerlControlCharacters4iTM3];
						[replacementString appendString:perlEscapedLine];
					}
					else
					{
						copyRange.location = iTM3MaxRange(startRange);
						copyRange.length = stopRange.location - copyRange.location;
						if (copyRange.length)
						{
							copyString = [macro substringWithRange:copyRange];
							copyString = [copyString stringByEscapingPerlControlCharacters4iTM3];
							[replacementString appendString:copyString];
						}
					}
					[replacementString appendString:@"__END_OF_CONTENT__\n__END_OF_INPUT__\n"];
					[replacementString appendString:@"$INPUT_LINE =~ m/(.*)__END_OF_CONTENT__.*/s;\n$INPUT_LINE=\"$1\";"];
				}
				else if ([startType isEqual:@"PERL_INPUT_ALL"])
				{
					PERL = YES;
					[replacementString appendString:@"my $INPUT_ALL= <<__END_OF_INPUT__;\n"];
					if (perlEscapedAll)
					{
						[replacementString appendString:perlEscapedAll];
					}
					else if (all.length)
					{
						perlEscapedAll = [all stringByEscapingPerlControlCharacters4iTM3];
						[replacementString appendString:perlEscapedAll];
					}
					else
					{
						copyRange.location = iTM3MaxRange(startRange);
						copyRange.length = stopRange.location - copyRange.location;
						if (copyRange.length)
						{
							copyString = [macro substringWithRange:copyRange];
							copyString = [copyString stringByEscapingPerlControlCharacters4iTM3];
							[replacementString appendString:copyString];
						}
					}
					[replacementString appendString:@"__END_OF_CONTENT__\n__END_OF_INPUT__\n"];
					[replacementString appendString:@"$INPUT_ALL =~ m/(.*)__END_OF_CONTENT__.*/s;\n$INPUT_ALL=\"$1\";"];
				}
				else if ([startType isEqual:@"PERL_INPUT_PATH"])
				{
					PERL = YES;
					[replacementString appendString:@"my $INPUT_PATH= <<__END_OF_INPUT__;\n"];
					if (perlEscapedPath)
					{
						[replacementString appendString:perlEscapedPath];
					}
					else if (path.length)
					{
						perlEscapedPath = [path stringByEscapingPerlControlCharacters4iTM3];
						[replacementString appendString:perlEscapedPath];
					}
					else
					{
						copyRange.location = iTM3MaxRange(startRange);
						copyRange.length = stopRange.location - copyRange.location;
						if (copyRange.length)
						{
							copyString = [macro substringWithRange:copyRange];
							copyString = [copyString stringByEscapingPerlControlCharacters4iTM3];
							[replacementString appendString:copyString];
						}
					}
					[replacementString appendString:@"__END_OF_CONTENT__\n__END_OF_INPUT__\n"];
					[replacementString appendString:@"$INPUT_PATH =~ m/(.*)__END_OF_CONTENT__.*/s;\n$INPUT_PATH=\"$1\";"];
				}
				else if ([startType isEqual:@"RUBY_INPUT_SELECTION"])
				{
					RUBY = YES;
					[replacementString appendString:@"INPUT_SELECTION = <<'__END_OF_INPUT__'\n"];
					if (selection.length)
					{
						[replacementString appendString:selection];
					}
					else
					{
						copyRange.location = iTM3MaxRange(startRange);
						copyRange.length = stopRange.location - copyRange.location;
						if (copyRange.length)
						{
							copyString = [macro substringWithRange:copyRange];
							[replacementString appendString:copyString];
						}
					}
					[replacementString appendString:@"__END_OF_CONTENT__\n__END_OF_INPUT__\n"];
					[replacementString appendString:@"INPUT_SELECTION.gsub!(/(.*)__END_OF_CONTENT__.*/m,'\\1')"];
				}
				else if ([startType isEqual:@"RUBY_INPUT_LINE"])
				{
					RUBY = YES;
					[replacementString appendString:@"INPUT_LINE = <<'__END_OF_INPUT__'\n"];
					if (line.length)
					{
						[replacementString appendString:line];
					}
					else
					{
						copyRange.location = iTM3MaxRange(startRange);
						copyRange.length = stopRange.location - copyRange.location;
						if (copyRange.length)
						{
							copyString = [macro substringWithRange:copyRange];
							[replacementString appendString:copyString];
						}
					}
					[replacementString appendString:@"__END_OF_CONTENT__\n__END_OF_INPUT__\n"];
					[replacementString appendString:@"INPUT_LINE.gsub!(/(.*)__END_OF_CONTENT__.*/m,'\\1')"];
				}
				else if ([startType isEqual:@"RUBY_INPUT_ALL"])
				{
					RUBY = YES;
					[replacementString appendString:@"INPUT_ALL= <<'__END_OF_INPUT__'\n"];
					if (all.length)
					{
						[replacementString appendString:all];
					}
					else
					{
						copyRange.location = iTM3MaxRange(startRange);
						copyRange.length = stopRange.location - copyRange.location;
						if (copyRange.length)
						{
							copyString = [macro substringWithRange:copyRange];
							//copyString = [copyString stringByEscapingPerlControlCharacters4iTM3];
							[replacementString appendString:copyString];
						}
					}
					[replacementString appendString:@"__END_OF_CONTENT__\n__END_OF_INPUT__\n"];
					[replacementString appendString:@"INPUT_ALL.gsub!(/(.*)__END_OF_CONTENT__.*/m,'\\1')"];
				}
				else if ([startType isEqual:@"RUBY_INPUT_PATH"])
				{
					RUBY = YES;
					[replacementString appendString:@"INPUT_PATH= <<'__END_OF_INPUT__'\n"];
					if (path.length)
					{
						[replacementString appendString:path];
					}
					else
					{
						copyRange.location = iTM3MaxRange(startRange);
						copyRange.length = stopRange.location - copyRange.location;
						if (copyRange.length)
						{
							copyString = [macro substringWithRange:copyRange];
							copyString = [copyString stringByEscapingPerlControlCharacters4iTM3];
							[replacementString appendString:copyString];
						}
					}
					[replacementString appendString:@"__END_OF_CONTENT__\n__END_OF_INPUT__\n"];
					[replacementString appendString:@"INPUT_PATH.gsub!(&/(.*)__END_OF_CONTENT__.*/m,'\\1')"];
				}
				else if ([startType isEqual:@"ALL"])
				{
					if (all.length)
					{
						[replacementString appendFormat:@"%@%@%@",SC.startPlaceholderMark,all,SC.stopPlaceholderMark];
					}
					else
					{
						copyRange.location = iTM3MaxRange(startRange);
						copyRange.length = stopRange.location - copyRange.location;
						if (copyRange.length)
						{
							copyString = [macro substringWithRange:copyRange];
							[replacementString appendFormat:@"%@%@%@",SC.startPlaceholderMark,copyString,SC.stopPlaceholderMark];
						}
					}
				}
				else if ([startType isEqual:@"INPUT_ALL"])
				{
					if (all.length)
					{
						[replacementString appendString:all];
					}
					else
					{
						copyRange.location = iTM3MaxRange(startRange);
						copyRange.length = stopRange.location - copyRange.location;
						if (copyRange.length)
						{
							copyString = [macro substringWithRange:copyRange];
							[replacementString appendString:copyString];
						}
					}
				}
				else if ([startType isEqual:@"INPUT_PATH"])
				{
					if (path.length)
					{
						[replacementString appendString:path];
					}
					else
					{
						copyRange.location = iTM3MaxRange(startRange);
						copyRange.length = stopRange.location - copyRange.location;
						if (copyRange.length)
						{
							copyString = [macro substringWithRange:copyRange];
							[replacementString appendString:copyString];
						}
					}
				}
				else if ([startType isEqual:@"PERL_REPLACE_ALL"])
				{
					PERL = YES;
					[replacementString appendFormat:@"print \"%@REPLACE_ALL:$INPUT_ALL%@\";\n",SC.startPlaceholderMark,SC.stopPlaceholderMark];
				}
				else if ([startType isEqual:@"PERL_REPLACE_SELECTION"])
				{
					PERL = YES;
					[replacementString appendFormat:@"print \"%@REPLACE_SELECTION:$INPUT_SELECTION%@\";\n",SC.startPlaceholderMark,SC.stopPlaceholderMark];
				}
				else if ([startType isEqual:@"PERL_REPLACE_LINE"])
				{
					PERL = YES;
					[replacementString appendFormat:@"print \"%@REPLACE_SELECTION:$INPUT_LINE%@\";\n",SC.startPlaceholderMark,SC.stopPlaceholderMark];
				}
				else if ([startType isEqual:@"RUBY_REPLACE_ALL"])
				{
					RUBY = YES;
					[replacementString appendFormat:@"puts \"%@REPLACE_ALL:#{INPUT_ALL}%@\"\n",SC.startPlaceholderMark,SC.stopPlaceholderMark];
				}
				else if ([startType isEqual:@"RUBY_REPLACE_SELECTION"])
				{
					RUBY = YES;
					[replacementString appendFormat:@"puts \"%@REPLACE_SELECTION:#{INPUT_SELECTION}%@\"",SC.startPlaceholderMark,SC.stopPlaceholderMark];
				}
				else if ([startType isEqual:@"RUBY_REPLACE_LINE"])
				{
					RUBY = YES;
					[replacementString appendFormat:@"puts \"%@REPLACE_LINE:#{INPUT_LINE}%@\";\n",SC.startPlaceholderMark,SC.stopPlaceholderMark];
				}
				#if 0
				else if ([startType isEqual:@"COMMAND"])// unused
				{
					if (selection.length)
					{
						[replacementString appendString:SC.startPlaceholderMark];
						[replacementString appendString:selection];
						[replacementString appendString:SC.stopPlaceholderMark];
					}
					else
					{
						copyRange.location = iTM3MaxRange(startRange);
						copyRange.length = stopRange.location - copyRange.location;
						if (copyRange.length)
						{
							[replacementString appendString:SC.startPlaceholderMark];
							copyString = [macro substringWithRange:copyRange];
							[replacementString appendString:copyString];
							[replacementString appendString:SC.stopPlaceholderMark];
						}
					}
				}
				#endif
				else
				{
					// the startRange was not a selection placeholder
					// we should add there other goodies
					copyRange.location = startRange.location;
					copyRange.length = stopRange.location - copyRange.location;
					copyRange.length += stopRange.length;
					copyString = [macro substringWithRange:copyRange];
					[replacementString appendString:copyString];
				}
				copyRange.location = iTM3MaxRange(stopRange);
				goto nextRange;
			}
			else
			{
				// stopType is in fact a start placeholder
				// 
				copyRange = startRange;
				copyRange.length = stopRange.location - startRange.location;
				copyString = [macro substringWithRange:copyRange];
				[replacementString appendString:copyString];
				startType = stopType;
				startRange = stopRange;
				copyRange.location = iTM3MaxRange(stopRange);
				goto nextStopRange;
			}
		}
		else
		{
			copyRange = startRange;
			copyRange.length = macro.length - startRange.location;
			copyString = [macro substringWithRange:copyRange];
			[replacementString appendString:copyString];
		}
	}
	else
	{
		copyRange.length = macro.length - copyRange.location;
		copyString = [macro substringWithRange:copyRange];
		[replacementString appendString:copyString];
	}
	// manage the indentation
	if (PERL)
	{
		if (![replacementString hasPrefix:@"#!/usr/bin/env perl"]
			&& ![replacementString hasPrefix:@"#!/usr/bin/perl"])
		{
			[replacementString insertString:@"#!/usr/bin/env perl -w\n" atIndex:0];
		}
	}
	else if (RUBY)
	{
		if (![replacementString hasPrefix:@"#!/usr/bin/env ruby"]
			&& ![replacementString hasPrefix:@"#!/usr/bin/ruby"])
		{
			[replacementString insertString:@"#!/usr/bin/env ruby\n" atIndex:0];
		}
	}
//END4iTM3;
	return replacementString;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  XXconcreteReplacementStringForMacro4iTM3:selection:line:
- (NSString *)XXconcreteReplacementStringForMacro4iTM3:(NSString *)macro selection:(NSString *)selection line:(NSString *)line;
/*"The purpose is to translate some keywords into the value they represent.
This is also used with scripts.
Version history: jlaurens AT users DOT sourceforge DOT net (1.0.10)
- 1.2: 06/24/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSMutableString * replacementString = [NSMutableString string];
	NSString * all = self.string;
    NSDocument * D = [self.window.windowController document];
	NSString * path = D.fileURL.path;
	BOOL PERL = NO;
	BOOL RUBY = NO;
	NSString * startType = nil;
	NSString * stopType = nil;
	NSString * copyString = nil;
	NSRange startRange = iTM3MakeRange(0,0);
	NSRange stopRange = iTM3MakeRange(0,0);
	NSRange copyRange = iTM3MakeRange(0,0);
	NSString * perlEscapedSelection = nil;
	NSString * perlEscapedLine = nil;
	NSString * perlEscapedAll = nil;
	NSString * perlEscapedPath = nil;
    iTM2StringController * SC = self.stringController4iTM3;
nextRange:
	startRange = [SC rangeOfNextPlaceholderMarkAfterIndex:copyRange.location getType:&startType ignoreComment:YES inString:macro];
	if (startRange.length)
	{
		copyRange.location = iTM3MaxRange(stopRange);
		copyRange.length = startRange.location - copyRange.location;
		copyString = [macro substringWithRange:copyRange];
		[replacementString appendString:copyString];
nextStopRange:
		copyRange.location = iTM3MaxRange(startRange);
		stopRange = [SC rangeOfNextPlaceholderMarkAfterIndex:copyRange.location getType:&stopType ignoreComment:YES inString:macro];
		if (stopRange.length)
		{
			if (!startType)
			{
				// the startRange was in fact a stop placeholder mark range, startType==nil is caracteristic
				copyRange = startRange;
				copyRange.length = iTM3MaxRange(stopRange) - copyRange.location;
				copyString = [macro substringWithRange:copyRange];
				[replacementString appendString:copyString];
				// go for a next pair start+stop
				copyRange.location = iTM3MaxRange(stopRange);
				goto nextRange;
			}
			else if (!stopType)
			{
                // We have a start/stop pair
				if ([startType isEqual:@"SELECTION"] || [startType isEqual:@"MATH"])
				{
					if (selection.length)
					{
						[replacementString appendFormat:@"%@%@%@",SC.startPlaceholderMark,selection,SC.stopPlaceholderMark];
					}
					else
					{
						copyRange.location = iTM3MaxRange(startRange);
						copyRange.length = stopRange.location - copyRange.location;
						if (copyRange.length)
						{
							copyString = [macro substringWithRange:copyRange];
							[replacementString appendFormat:@"%@%@%@",SC.startPlaceholderMark,copyString,SC.stopPlaceholderMark];
						}
					}
				}
				else if ([startType isEqual:@"INPUT_SELECTION"])
				{
					if (selection.length)
					{
						[replacementString appendString:selection];
					}
					else
					{
						copyRange.location = iTM3MaxRange(startRange);
						copyRange.length = stopRange.location - copyRange.location;
						if (copyRange.length)
						{
							copyString = [macro substringWithRange:copyRange];
							[replacementString appendString:copyString];
						}
					}
				}
				else if ([startType isEqual:@"PERL_INPUT_SELECTION"])
				{
					PERL = YES;
					[replacementString appendString:@"my $INPUT_SELECTION= <<__END_OF_INPUT__;\n"];
					if (perlEscapedSelection)
					{
						[replacementString appendString:perlEscapedSelection];
					}
					else if (selection.length)
					{
						perlEscapedSelection = [selection stringByEscapingPerlControlCharacters4iTM3];
						[replacementString appendString:perlEscapedSelection];
					}
					else
					{
						copyRange.location = iTM3MaxRange(startRange);
						copyRange.length = stopRange.location - copyRange.location;
						if (copyRange.length)
						{
							copyString = [macro substringWithRange:copyRange];
							copyString = [copyString stringByEscapingPerlControlCharacters4iTM3];
							[replacementString appendString:copyString];
						}
					}
					[replacementString appendString:@"__END_OF_CONTENT__\n__END_OF_INPUT__\n"];
					[replacementString appendString:@"$INPUT_SELECTION =~ m/(.*)__END_OF_CONTENT__.*/s;\n$INPUT_SELECTION=\"$1\";"];
				}
				else if ([startType isEqual:@"PERL_INPUT_LINE"])
				{
					PERL = YES;
					[replacementString appendString:@"my $INPUT_LINE= <<__END_OF_INPUT__;\n"];
					if (perlEscapedLine)
					{
						[replacementString appendString:perlEscapedLine];
					}
					else if (line.length)
					{
						perlEscapedLine = [line stringByEscapingPerlControlCharacters4iTM3];
						[replacementString appendString:perlEscapedLine];
					}
					else
					{
						copyRange.location = iTM3MaxRange(startRange);
						copyRange.length = stopRange.location - copyRange.location;
						if (copyRange.length)
						{
							copyString = [macro substringWithRange:copyRange];
							copyString = [copyString stringByEscapingPerlControlCharacters4iTM3];
							[replacementString appendString:copyString];
						}
					}
					[replacementString appendString:@"__END_OF_CONTENT__\n__END_OF_INPUT__\n"];
					[replacementString appendString:@"$INPUT_LINE =~ m/(.*)__END_OF_CONTENT__.*/s;\n$INPUT_LINE=\"$1\";"];
				}
				else if ([startType isEqual:@"PERL_INPUT_ALL"])
				{
					PERL = YES;
					[replacementString appendString:@"my $INPUT_ALL= <<__END_OF_INPUT__;\n"];
					if (perlEscapedAll)
					{
						[replacementString appendString:perlEscapedAll];
					}
					else if (all.length)
					{
						perlEscapedAll = [all stringByEscapingPerlControlCharacters4iTM3];
						[replacementString appendString:perlEscapedAll];
					}
					else
					{
						copyRange.location = iTM3MaxRange(startRange);
						copyRange.length = stopRange.location - copyRange.location;
						if (copyRange.length)
						{
							copyString = [macro substringWithRange:copyRange];
							copyString = [copyString stringByEscapingPerlControlCharacters4iTM3];
							[replacementString appendString:copyString];
						}
					}
					[replacementString appendString:@"__END_OF_CONTENT__\n__END_OF_INPUT__\n"];
					[replacementString appendString:@"$INPUT_ALL =~ m/(.*)__END_OF_CONTENT__.*/s;\n$INPUT_ALL=\"$1\";"];
				}
				else if ([startType isEqual:@"PERL_INPUT_PATH"])
				{
					PERL = YES;
					[replacementString appendString:@"my $INPUT_PATH= <<__END_OF_INPUT__;\n"];
					if (perlEscapedPath)
					{
						[replacementString appendString:perlEscapedPath];
					}
					else if (path.length)
					{
						perlEscapedPath = [path stringByEscapingPerlControlCharacters4iTM3];
						[replacementString appendString:perlEscapedPath];
					}
					else
					{
						copyRange.location = iTM3MaxRange(startRange);
						copyRange.length = stopRange.location - copyRange.location;
						if (copyRange.length)
						{
							copyString = [macro substringWithRange:copyRange];
							copyString = [copyString stringByEscapingPerlControlCharacters4iTM3];
							[replacementString appendString:copyString];
						}
					}
					[replacementString appendString:@"__END_OF_CONTENT__\n__END_OF_INPUT__\n"];
					[replacementString appendString:@"$INPUT_PATH =~ m/(.*)__END_OF_CONTENT__.*/s;\n$INPUT_PATH=\"$1\";"];
				}
				else if ([startType isEqual:@"RUBY_INPUT_SELECTION"])
				{
					RUBY = YES;
					[replacementString appendString:@"INPUT_SELECTION = <<'__END_OF_INPUT__'\n"];
					if (selection.length)
					{
						[replacementString appendString:selection];
					}
					else
					{
						copyRange.location = iTM3MaxRange(startRange);
						copyRange.length = stopRange.location - copyRange.location;
						if (copyRange.length)
						{
							copyString = [macro substringWithRange:copyRange];
							[replacementString appendString:copyString];
						}
					}
					[replacementString appendString:@"__END_OF_CONTENT__\n__END_OF_INPUT__\n"];
					[replacementString appendString:@"INPUT_SELECTION.gsub!(/(.*)__END_OF_CONTENT__.*/m,'\\1')"];
				}
				else if ([startType isEqual:@"RUBY_INPUT_LINE"])
				{
					RUBY = YES;
					[replacementString appendString:@"INPUT_LINE = <<'__END_OF_INPUT__'\n"];
					if (line.length)
					{
						[replacementString appendString:line];
					}
					else
					{
						copyRange.location = iTM3MaxRange(startRange);
						copyRange.length = stopRange.location - copyRange.location;
						if (copyRange.length)
						{
							copyString = [macro substringWithRange:copyRange];
							[replacementString appendString:copyString];
						}
					}
					[replacementString appendString:@"__END_OF_CONTENT__\n__END_OF_INPUT__\n"];
					[replacementString appendString:@"INPUT_LINE.gsub!(/(.*)__END_OF_CONTENT__.*/m,'\\1')"];
				}
				else if ([startType isEqual:@"RUBY_INPUT_ALL"])
				{
					RUBY = YES;
					[replacementString appendString:@"INPUT_ALL= <<'__END_OF_INPUT__'\n"];
					if (all.length)
					{
						[replacementString appendString:all];
					}
					else
					{
						copyRange.location = iTM3MaxRange(startRange);
						copyRange.length = stopRange.location - copyRange.location;
						if (copyRange.length)
						{
							copyString = [macro substringWithRange:copyRange];
							//copyString = [copyString stringByEscapingPerlControlCharacters4iTM3];
							[replacementString appendString:copyString];
						}
					}
					[replacementString appendString:@"__END_OF_CONTENT__\n__END_OF_INPUT__\n"];
					[replacementString appendString:@"INPUT_ALL.gsub!(/(.*)__END_OF_CONTENT__.*/m,'\\1')"];
				}
				else if ([startType isEqual:@"RUBY_INPUT_PATH"])
				{
					RUBY = YES;
					[replacementString appendString:@"INPUT_PATH= <<'__END_OF_INPUT__'\n"];
					if (path.length)
					{
						[replacementString appendString:path];
					}
					else
					{
						copyRange.location = iTM3MaxRange(startRange);
						copyRange.length = stopRange.location - copyRange.location;
						if (copyRange.length)
						{
							copyString = [macro substringWithRange:copyRange];
							copyString = [copyString stringByEscapingPerlControlCharacters4iTM3];
							[replacementString appendString:copyString];
						}
					}
					[replacementString appendString:@"__END_OF_CONTENT__\n__END_OF_INPUT__\n"];
					[replacementString appendString:@"INPUT_PATH.gsub!(&/(.*)__END_OF_CONTENT__.*/m,'\\1')"];
				}
				else if ([startType isEqual:@"ALL"])
				{
					if (all.length)
					{
						[replacementString appendFormat:@"%@%@%@",SC.startPlaceholderMark,all,SC.stopPlaceholderMark];
					}
					else
					{
						copyRange.location = iTM3MaxRange(startRange);
						copyRange.length = stopRange.location - copyRange.location;
						if (copyRange.length)
						{
							copyString = [macro substringWithRange:copyRange];
							[replacementString appendFormat:@"%@%@%@",SC.startPlaceholderMark,copyString,SC.stopPlaceholderMark];
						}
					}
				}
				else if ([startType isEqual:@"INPUT_ALL"])
				{
					if (all.length)
					{
						[replacementString appendString:all];
					}
					else
					{
						copyRange.location = iTM3MaxRange(startRange);
						copyRange.length = stopRange.location - copyRange.location;
						if (copyRange.length)
						{
							copyString = [macro substringWithRange:copyRange];
							[replacementString appendString:copyString];
						}
					}
				}
				else if ([startType isEqual:@"INPUT_PATH"])
				{
					if (path.length)
					{
						[replacementString appendString:path];
					}
					else
					{
						copyRange.location = iTM3MaxRange(startRange);
						copyRange.length = stopRange.location - copyRange.location;
						if (copyRange.length)
						{
							copyString = [macro substringWithRange:copyRange];
							[replacementString appendString:copyString];
						}
					}
				}
				else if ([startType isEqual:@"PERL_REPLACE_ALL"])
				{
					PERL = YES;
					[replacementString appendFormat:@"print \"%@REPLACE_ALL:$INPUT_ALL%@\";\n",SC.startPlaceholderMark,SC.stopPlaceholderMark];
				}
				else if ([startType isEqual:@"PERL_REPLACE_SELECTION"])
				{
					PERL = YES;
					[replacementString appendFormat:@"print \"%@REPLACE_SELECTION:$INPUT_SELECTION%@\";\n",SC.startPlaceholderMark,SC.stopPlaceholderMark];
				}
				else if ([startType isEqual:@"PERL_REPLACE_LINE"])
				{
					PERL = YES;
					[replacementString appendFormat:@"print \"%@REPLACE_SELECTION:$INPUT_LINE%@\";\n",SC.startPlaceholderMark,SC.stopPlaceholderMark];
				}
				else if ([startType isEqual:@"RUBY_REPLACE_ALL"])
				{
					RUBY = YES;
					[replacementString appendFormat:@"puts \"%@REPLACE_ALL:#{INPUT_ALL}%@\"\n",SC.startPlaceholderMark,SC.stopPlaceholderMark];
				}
				else if ([startType isEqual:@"RUBY_REPLACE_SELECTION"])
				{
					RUBY = YES;
					[replacementString appendFormat:@"puts \"%@REPLACE_SELECTION:#{INPUT_SELECTION}%@\"",SC.startPlaceholderMark,SC.stopPlaceholderMark];
				}
				else if ([startType isEqual:@"RUBY_REPLACE_LINE"])
				{
					RUBY = YES;
					[replacementString appendFormat:@"puts \"%@REPLACE_LINE:#{INPUT_LINE}%@\";\n",SC.startPlaceholderMark,SC.stopPlaceholderMark];
				}
				#if 0
				else if ([startType isEqual:@"COMMAND"])// unused
				{
					if (selection.length)
					{
						[replacementString appendString:SC.startPlaceholderMark];
						[replacementString appendString:selection];
						[replacementString appendString:SC.stopPlaceholderMark];
					}
					else
					{
						copyRange.location = iTM3MaxRange(startRange);
						copyRange.length = stopRange.location - copyRange.location;
						if (copyRange.length)
						{
							[replacementString appendString:SC.startPlaceholderMark];
							copyString = [macro substringWithRange:copyRange];
							[replacementString appendString:copyString];
							[replacementString appendString:SC.stopPlaceholderMark];
						}
					}
				}
				#endif
				else
				{
					// the startRange was not a selection placeholder
					// we should add there other goodies
					copyRange.location = startRange.location;
					copyRange.length = stopRange.location - copyRange.location;
					copyRange.length += stopRange.length;
					copyString = [macro substringWithRange:copyRange];
					[replacementString appendString:copyString];
				}
				copyRange.location = iTM3MaxRange(stopRange);
				goto nextRange;
			}
			else
			{
				// stopType is in fact a start placeholder
				// 
				copyRange = startRange;
				copyRange.length = stopRange.location - startRange.location;
				copyString = [macro substringWithRange:copyRange];
				[replacementString appendString:copyString];
				startType = stopType;
				startRange = stopRange;
				copyRange.location = iTM3MaxRange(stopRange);
				goto nextStopRange;
			}
		}
		else
		{
			copyRange = startRange;
			copyRange.length = macro.length - startRange.location;
			copyString = [macro substringWithRange:copyRange];
			[replacementString appendString:copyString];
		}
	}
	else
	{
		copyRange.length = macro.length - copyRange.location;
		copyString = [macro substringWithRange:copyRange];
		[replacementString appendString:copyString];
	}
	// manage the indentation
	if (PERL)
	{
		if (![replacementString hasPrefix:@"#!/usr/bin/env perl"]
			&& ![replacementString hasPrefix:@"#!/usr/bin/perl"])
		{
			[replacementString insertString:@"#!/usr/bin/env perl -w\n" atIndex:0];
		}
	}
	else if (RUBY)
	{
		if (![replacementString hasPrefix:@"#!/usr/bin/env ruby"]
			&& ![replacementString hasPrefix:@"#!/usr/bin/ruby"])
		{
			[replacementString insertString:@"#!/usr/bin/env ruby\n" atIndex:0];
		}
	}
//END4iTM3;
	return replacementString;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  replacementStringForMacro4iTM3:selection:line:
- (NSString *)replacementStringForMacro4iTM3:(NSString *)macro selection:(NSString *)selection line:(NSString *)line;
/*"Description forthcoming.
selection is the current contents of the selection whereas line is the current line
Version history: jlaurens AT users DOT sourceforge DOT net (1.0.10)
- 1.2: 06/24/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSString * category = self.macroCategory;
	if (category.length) {
        NSString * replacementString = @"";
		NSInvocation * I;
        [[NSInvocation getInvocation4iTM3:&I withTarget:self retainArguments:YES]
                concreteReplacementStringForMacro4iTM3:macro selection:selection line:line];
        category = category.lowercaseString.capitalizedString;
		NSString * action = [NSString stringWithFormat:@"concreteReplacementStringFor%@Macro4iTM3:selection:line:",category];
		SEL selector = NSSelectorFromString(action);
		if ([[self methodSignatureForSelector:selector] isEqual:I.methodSignature]) {
            [I setSelector:selector];
            NS_DURING
            [I invoke];
            [I getReturnValue:&replacementString];
            NS_HANDLER
            LOG4iTM3(@"EXCEPTION Catched: %@", localException);
            replacementString = @"";
            NS_ENDHANDLER
            return replacementString;
		}
	}
//END4iTM3;
    return [self concreteReplacementStringForMacro4iTM3:macro selection:selection line:line];
}
@end
