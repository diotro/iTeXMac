/*
//
//  @version Subversion: $Id$ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Fri Sep 05 2003.
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
*/

#import "iTM2TeXDocumentKit.h"
#import "iTM2TeXStringKit.h"
#import "iTM2TeXProjectDocumentKit.h"
#import "iTM2TeXProjectFrontendKit.h"
#import "iTM2TeXProjectTaskKit.h"
#import <iTM2Foundation/iTM2InstallationKit.h>
#import <iTM2Foundation/iTM2Implementation.h>
#import <iTM2Foundation/iTM2ContextKit.h>
#import <iTM2Foundation/iTM2StringFormatKit.h>
#import <iTM2Foundation/iTM2WindowKit.h>
#import <iTM2Foundation/iTM2StringKit.h>
#import <iTM2Foundation/iTM2TextKit.h>
#import <iTM2Foundation/iTM2NotificationKit.h>
#import <iTM2Foundation/iTM2BundleKit.h>
#import <iTM2Foundation/iTM2KeyBindingsKit.h>

#define TABLE @"iTM2TextKit"
#define BUNDLE [iTM2TextDocument classBundle]

NSString * const iTM2TeXDocumentType = @"TeX Document";// beware, this MUST appear in the target file...
NSString * const iTM2TeXInspectorMode = @"TeX Mode";

@implementation iTM2TeXDocument
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initialize
+ (void)initialize;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 2.0: Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [super initialize];
	NSDictionary * D = [SUD dictionaryForKey:iTM2SUDInspectorVariants];
	NSMutableDictionary * MD = [NSMutableDictionary dictionaryWithDictionary:D];
	NSString * type = iTM2TeXDocumentType;
	if(![MD objectForKey:type])
	{
		NSString * mode = [iTM2TeXInspector inspectorMode];
		NSString * variant = [iTM2TeXInspector inspectorVariant];
		D = [NSDictionary dictionaryWithObjectsAndKeys:mode, @"mode", variant, @"variant", nil];
		[MD setObject:D forKey:type];
		[SUD setObject:MD forKey:iTM2SUDInspectorVariants];
	}
	D = [NSDictionary dictionaryWithObjectsAndKeys:@"TeX-Xtd", @"iTM2TextStyle", @"default", @"iTM2TextSyntaxParserVariant", nil];
	[SUD registerDefaults:D];
    return;
}
@end


@implementation iTM2TeXInspector
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inspectorMode
+ (NSString *)inspectorMode;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return iTM2TeXInspectorMode;
}
@end

@implementation iTM2TeXWindow
@end

#import <iTM2TeXFoundation/iTM2TeXStorageKit.h>

@implementation iTM2TeXEditor
#if 0
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertMacro:tabAnchor:substitutions:
- (void)insertMacro:(id)argument tabAnchor:(NSString *)tabAnchor substitutions:(NSDictionary *)substitutions;
/*"Description forthcoming.
- 2.0: 01/30/2007
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(![argument isKindOfClass:[NSString class]])
	{
		[super insertMacro:argument tabAnchor:tabAnchor substitutions:(NSDictionary *)substitutions];
	}
	NSRange R = [argument rangeOfNextPlaceholderAfterIndex:0 cycle:NO tabAnchor:tabAnchor];
	if(R.length)
	{
		[super insertMacro:argument tabAnchor:tabAnchor substitutions:(NSDictionary *)substitutions];
	}
	if([argument hasSuffix:@":"])
	{
		[super insertMacro:argument tabAnchor:tabAnchor substitutions:(NSDictionary *)substitutions];
	}
	if([argument hasSuffix:@"..."])
	{
		[super insertMacro:argument tabAnchor:tabAnchor substitutions:(NSDictionary *)substitutions];
	}
	
	[super insertMacro:argument tabAnchor:tabAnchor substitutions:(NSDictionary *)substitutions];
//iTM2_END;
    return;
}
#endif
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= clickedOnLink:atIndex:
- (void)clickedOnLink:(id)link atIndex:(unsigned)charIndex;
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri May 21 07:52:07 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * S = [[self textStorage] string];
	NSRange R = [NSString TeXAwareDoubleClick:S atIndex:charIndex];
	if(R.length<2)
		return;
	++R.location;
	--R.length;
	NSString * command = [S substringWithRange:R];
	if([command isEqualToString:@"input"])
	{
		unsigned start = NSMaxRange(R);
		if(start < [S length])
		{
			unsigned contentsEnd, TeXComment;
			[S getLineStart:nil end:nil contentsEnd: &contentsEnd TeXComment: &TeXComment forIndex:start];
			NSString * string = [S substringWithRange:
				NSMakeRange(start, (TeXComment == NSNotFound? contentsEnd: TeXComment) - start)];
			NSScanner * scanner = [NSScanner scannerWithString:string];
			[scanner scanString:@"{" intoString:nil];
			NSString * fileName;
			if([scanner scanCharactersFromSet:[NSCharacterSet TeXFileNameLetterCharacterSet] intoString: &fileName])
			{
				if(![fileName hasPrefix:@"/"])
				{
					fileName = [[[[[[self window] windowController] document] fileName] stringByDeletingLastPathComponent] stringByAppendingPathComponent:fileName];
				}
				if(![SDC openDocumentWithContentsOfURL:[NSURL fileURLWithPath:fileName] display:YES error:nil])
				{
					NSString * newFileName = [fileName stringByAppendingPathExtension:@"tex"];
					if(![SDC openDocumentWithContentsOfURL:[NSURL fileURLWithPath:newFileName] display:YES error:nil]
						&& ![SWS openFile:fileName]
							&& ![SWS openFile:newFileName])
					{
						iTM2_LOG(@"INFO: could not open file <%@>", newFileName);
					}				
				}
			}
			else
			{
				iTM2_LOG(@"..........  TeX SYNTAX ERROR: nothing to input");
			}
		}
		return;
	}
	[super clickedOnLink:link atIndex:charIndex];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  scrollInputToVisible:
- (void)scrollInputToVisible:(id <NSMenuItem>)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self performSelector:@selector(delayedScrollInputToVisible:) withObject:sender afterDelay:0.1];
	#if 0
    [NSInvocation delayInvocationWithTarget: self
        action: @selector(_ScrollInputToVisible:)
            sender: sender
                untilNotificationWithName: @"iTM2TDPerformScrollIn[clude|put]ToVisible"
                    isPostedFromObject: self];
	#endif
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  delayedScrollInputToVisible:
- (void)delayedScrollInputToVisible:(id <NSMenuItem>)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.: 03/10/2002
To Do List: include the tetex path...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSString * path = [[[[[sender menu] title]  stringByAppendingPathComponent:
                                [sender representedObject]] stringByResolvingSymlinksInPath] stringByStandardizingPath];
    if([DFM isReadableFileAtPath:path])
        [SDC openDocumentWithContentsOfURL:[NSURL fileURLWithPath:path] display:YES error:nil];
    else
    {
        NSString * P = [path stringByAppendingPathExtension:@"tex"];
        if([[NSFileManager defaultManager] isReadableFileAtPath:P])
            [SDC openDocumentWithContentsOfURL:[NSURL fileURLWithPath:P] display:YES error:nil];
        else
        {
            [sender setEnabled:NO];
            NSBeep();
            [self postNotificationWithStatus:
                [NSString stringWithFormat:  NSLocalizedStringFromTableInBundle(@"No file at path: %@", @"TeX",
                            [NSBundle bundleForClass:[self class]], "Could not complete the \\input action... 1 line only"), path]]; 
        }
    }
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  mouseDown:
- (void)mouseDown:(NSEvent * )event
/*"Description Forthcoming
Version history: jlaurens AT users.sourceforge.net
- < 1.1: 03/10/2002
To Do List:
"*/
{
//iTM2_START;
    if([event clickCount]>2)
    {
//NSLog(@"[event clickCount]: %i", [event clickCount]);
        NSString * S = [self string];
        NSRange SR = [self selectedRange];
//        NSRange GR = [S groupRangeForRange:SR];
		// comparer SR, GR, PR
//NSLog(NSStringFromRange(GR));
        unsigned start, end;
        [S getLineStart: &start end: &end contentsEnd:nil forRange:SR];
        end -= start;
        NSRange PR = (end>SR.length)? NSMakeRange(start, end): NSMakeRange(0, [S length]);
        [self setSelectedRange:PR];
		return;
    }
    else
        [super mouseDown:event];
    return;
}
#if 0
- (void)moveWordForwardAndModifySelection:(id)sender;
- (void)moveWordBackwardAndModifySelection:(id)sender;
- (void)moveWordRightAndModifySelection:(id)sender;
- (void)moveWordLeftAndModifySelection:(id)sender;
- (void)moveUpAndModifySelection:(id)sender;
#endif
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  subscript:
- (void)subscript:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users.sourceforge.net
To Do List:
"*/
{
//iTM2_START;
	NSString * macroDomain = [self macroDomain];
	NSString * macroCategory = [self macroCategory];
	NSString * macroContext = [self macroContext];
	NSRange selectedRange = [self selectedRange];
	if(selectedRange.length)
	{
		NSString * selectedText = [self string];
		selectedText = [selectedText substringWithRange:selectedRange];
		NSDictionary * substitutions = [NSDictionary dictionaryWithObject:selectedText forKey:@"argument#1"];
		[SMC executeMacroWithID:@"_{}" forContext:macroContext ofCategory:macroCategory inDomain:macroDomain substitutions:substitutions target:self];
	}
	else
	{
		[SMC executeMacroWithID:@"_{}" forContext:macroContext ofCategory:macroCategory inDomain:macroDomain substitutions:nil target:self];
	}
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  superscript:
- (void)superscript:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users.sourceforge.net
To Do List:
"*/
{
//iTM2_START;
	NSString * macroDomain = [self macroDomain];
	NSString * macroCategory = [self macroCategory];
	NSString * macroContext = [self macroContext];
	NSRange selectedRange = [self selectedRange];
	if(selectedRange.length)
	{
		NSString * selectedText = [self string];
		selectedText = [selectedText substringWithRange:selectedRange];
		NSDictionary * substitutions = [NSDictionary dictionaryWithObject:selectedText forKey:@"argument#1"];
		[SMC executeMacroWithID:@"^{}" forContext:macroContext ofCategory:macroCategory inDomain:macroDomain substitutions:substitutions target:self];
	}
	else
	{
		[SMC executeMacroWithID:@"^{}" forContext:macroContext ofCategory:macroCategory inDomain:macroDomain substitutions:nil target:self];
	}
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertUnderscore:
- (void)insertUnderscore:(id)sender;
/*"Tabs are inserted only at the beginning of the line.
Version history: jlaurens AT users.sourceforge.net
- < 1.1: 03/10/2002
To Do List: Nothing at first glance.
"*/
{
//iTM2_START;
    if(!_iTMTVFlags.smartInsert || _iTMTVFlags.isEscaped || _iTMTVFlags.isDeepEscaped)
    {
        [self insertText:@"_"];
    }
    else
    {
        BOOL escaped;
        NSRange R = [self selectedRange];
        if(!R.location || ![[self string] isControlAtIndex:R.location-1 escaped: &escaped] || escaped)
            [self subscript:self];
        else
            [self insertText:@"_"];
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertHat:
- (void)insertHat:(id)sender;
/*"Inserting a smart hat. Problem with dead keys.
Version history: jlaurens AT users.sourceforge.net
- < 1.1: 03/10/2002
To Do List: Nothing at first glance.
"*/
{
//iTM2_START;
//NSLog(NSStringFromRange([self selectedRange]));
//NSLog(NSStringFromRange([self markedRange]));
    if(!_iTMTVFlags.smartInsert || _iTMTVFlags.isEscaped || _iTMTVFlags.isDeepEscaped)
    {
        [self insertText:@"^"];
    }
    else
    {
        BOOL escaped;
        int index = [self hasMarkedText]? [self markedRange].location:[self selectedRange].location;
        if(!index || ![[self string] isControlAtIndex:index-1 escaped: &escaped] || !escaped)
        {
            index = [self selectedRange].location;
            if(!index || ([[self string] characterAtIndex:index-1] != '^'))
				[self superscript:self];
            else
			{
				NSString * macroDomain = [self macroDomain];
				NSString * macroCategory = [self macroCategory];
				NSString * macroContext = [self macroContext];
                [SMC executeMacroWithID:@"{}" forContext:macroContext ofCategory:macroCategory inDomain:macroDomain substitutions:nil target:self];
			}
        }
        else
        {
            [self insertText:@"^"];
        }
    }
#warning WARNING----------------------------------------
//    [self completeInsertion];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertControl:
- (void)insertControl:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users.sourceforge.net
- < 1.1: 03/10/2002
To Do List: Nothing at first glance.
"*/
{
//iTM2_START;
    BOOL escaped;
    NSString * S = [self string];
    NSRange R = [self selectedRange];
    if(!R.location || ![S isControlAtIndex:R.location-1 escaped: &escaped] || escaped)
    {
        [self insertText:[NSString backslashString]];
    }
    else
    {
        [[self undoManager] beginUndoGrouping];
        [self insertText:[NSString backslashString]];
        [self insertNewline:self];
        [[self undoManager] endUndoGrouping];
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertDollar:
- (void)insertDollar:(id)sender;
/*"Tabs are inserted only at the beginning of the line.
Version history: jlaurens AT users.sourceforge.net
- < 1.1: 03/10/2002
To Do List: Nothing at first glance.
"*/
{
//iTM2_START;
    BOOL escaped;
    NSRange R = [self selectedRange];
    if(!R.location || ![[self string] isControlAtIndex:R.location-1 escaped: &escaped] || escaped)
        [self insertMacro:@"$@(@SEL@)@$"];
    else
        [self insertText:@"$"];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertOpenBrace:
- (void)insertOpenBrace:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users.sourceforge.net
- < 1.1: 03/10/2002
To Do List: Nothing at first glance.
"*/
{
//iTM2_START;
    BOOL escaped;
    NSString * S = [self string];
    NSRange R = [self selectedRange];
	
    if(!R.location || ![S isControlAtIndex:R.location-1 escaped: &escaped] || escaped)
    {
		NSString * macroDomain = [self macroDomain];
		NSString * macroCategory = [self macroCategory];
		NSString * macroContext = [self macroContext];
        [SMC executeMacroWithID:@"{}" forContext:macroContext ofCategory:macroCategory inDomain:macroDomain substitutions:nil target:self];
    }
    else
        [self insertText:@"{"];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertOpenParenthesis:
- (void)insertOpenParenthesis:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users.sourceforge.net
- < 1.1: 03/10/2002
To Do List: Nothing at first glance.
"*/
{
//iTM2_START;
    BOOL escaped;
    NSString * S = [self string];
    NSRange R = [self selectedRange];
    NSString * macro = (!R.location || ![S isControlAtIndex:R.location-1 escaped: &escaped] || escaped)?
		@"(@@{@@.)": @"(@@{@@.\\)";
    [self insertMacro:macro];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertOpenBracket:
- (void)insertOpenBracket:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users.sourceforge.net
- < 1.1: 03/10/2002
To Do List: Nothing at first glance.
"*/
{
//iTM2_START;
    BOOL escaped;
    NSString * S = [self string];
    NSRange R = [self selectedRange];
	unsigned start, contentsEnd;
	BOOL BOL, EOL;
	NSString * macro;
	if(!R.location || ![S isControlAtIndex:R.location-1 escaped:&escaped])
    {
		macro = @"[@@{@@.]";
		[self insertMacro:macro];
    }
    else if(escaped)// this is a dimension after a "\\"
    {
		[S getLineStart:nil end:nil contentsEnd:&contentsEnd forRange:NSMakeRange(R.location, 0)];
		macro = R.location == contentsEnd? @"[@@{@@.]":@"[@@{@@.]\n";
		[self insertMacro:macro];
    }
    else// this follows an unescaped \: insert "[...\]", manage line indentation
    {
        [[self undoManager] beginUndoGrouping];
//NSLog(@"GLS");
		[S getLineStart:&start end:nil contentsEnd:&contentsEnd
			forRange: NSMakeRange(R.location-1, 0)];
		EOL = (R.location == contentsEnd);
		BOL = (start == R.location-1);
		if(!BOL)
		{
			[self setSelectedRange:NSMakeRange(R.location-1, 1)];
			[self insertNewline:self];
		}
		macro = [NSString stringWithFormat:@"%@[@@[@@.\\]%@", (BOL? @"":@"\\"),(EOL? @"":@"\n")];
		[self insertMacro:macro];
        [[self undoManager] endUndoGrouping];
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertTabAnchor:
- (void)insertTabAnchor:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users.sourceforge.net
- < 1.1: 03/10/2002
To Do List: Nothing at first glance.
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self insertText:[self tabAnchor]];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  commentSelection:
- (void)commentSelection:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users.sourceforge.net
- < 1.1: 03/10/2002
To Do List: Nothing at first glance.
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * commentString = [NSString commentString];
	NSMutableArray * affectedRanges = [NSMutableArray array];
	NSMutableArray * replacementStrings = [NSMutableArray array];
	NSString * S = [self string];
	NSArray * selectedRanges = [self selectedRanges];
	NSEnumerator * E = [selectedRanges objectEnumerator];
	NSValue * V;
	NSRange R;
	while(V = [E nextObject])
	{
		NSRange R = [V rangeValue];
		unsigned int nextStart,top;
		top = NSMaxRange(R);
		R.length = 0;
		[S getLineStart:&R.location end:&nextStart contentsEnd:nil forRange:R];
		V = [NSValue valueWithRange:R];
		if(![affectedRanges containsObject:V])
		{
			[affectedRanges addObject:V];
			[replacementStrings addObject:commentString];
		}
		while (nextStart<top)
		{
			R.location = nextStart;
			V = [NSValue valueWithRange:R];
			if(![affectedRanges containsObject:V])
			{
				[affectedRanges addObject:V];
				[replacementStrings addObject:commentString];
			}
			[S getLineStart:nil end:&nextStart contentsEnd:nil forRange:R];
		}
	}
	[self willChangeSelectedRanges];
	if([self shouldChangeTextInRanges:affectedRanges replacementStrings:replacementStrings])
	{
		unsigned int shift = 0;
		NSEnumerator * E = [affectedRanges objectEnumerator];// no reverse enumerator to properly manage the selection
		affectedRanges = [NSMutableArray array];
		// no need to enumerate the replacementStrings
		while(V = [E nextObject])
		{
			R = [V rangeValue];
			R.location += shift;
			[self replaceCharactersInRange:R withString:commentString];
			[S getLineStart:nil end:&R.length contentsEnd:nil forRange:R];
			R.length -= R.location;
			V = [NSValue valueWithRange:R];
			[affectedRanges addObject:V];
			++shift;
		}
		[self didChangeText];
		[self setSelectedRanges:affectedRanges];
	}
	[self didChangeSelectedRanges];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  uncommentSelection:
- (void)uncommentSelection:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users.sourceforge.net
- < 1.1: 03/10/2002
To Do List: Nothing at first glance.
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	//Find all the lines that begin with %
	// 1 - list all the lines
	NSRange affectedRange;
	NSMutableArray * affectedRanges = [NSMutableArray array];
	NSMutableArray * replacementStrings = [NSMutableArray array];
	NSString * S = [self string];
	NSRange selectedRange;
	NSArray * selectedRanges = [self selectedRanges];
	NSEnumerator * E = [selectedRanges objectEnumerator];
	NSValue * V;
	unsigned comment;
	affectedRange.length = 1;// all the affected ranges have a 1 length
	while(V = [E nextObject])
	{
		selectedRange = [V rangeValue];
		unsigned int top = NSMaxRange(selectedRange);
		unsigned int nextStart;
		[S getLineStart:&affectedRange.location end:&nextStart contentsEnd:nil TeXComment:&comment forIndex:selectedRange.location];
		if(comment == affectedRange.location)
		{
			// this line starts with a comment character
			// we record the range we will remove
			V = [NSValue valueWithRange:affectedRange];
			if(![affectedRanges containsObject:V])
			{
				[affectedRanges addObject:V];
				[replacementStrings addObject:@""];
			}
		}
		while(nextStart<top)
		{
			affectedRange.location = nextStart;
			[S getLineStart:nil end:&nextStart contentsEnd:nil TeXComment:&comment forIndex:nextStart];
			if(comment == affectedRange.location)
			{
				// this line starts with a comment character
				// we record the range we will remove
				V = [NSValue valueWithRange:affectedRange];
				if(![affectedRanges containsObject:V])
				{
					[affectedRanges addObject:V];
					[replacementStrings addObject:@""];
				}
			}
		}
	}
	// Intermediate - is there something to change?
	if(![affectedRanges count])
	{
		return;
	}
	// 2 - do not assume any order on affectedRanges
	NSSortDescriptor * SD = [[[NSSortDescriptor alloc] initWithKey:@"locationValueOfRangeValue" ascending:YES] autorelease];
	NSArray * sortDescriptors = [NSArray arrayWithObject:SD];
	[affectedRanges sortUsingDescriptors:sortDescriptors];
	// 3 - now we prepare the modified selected ranges
	// it is a bit heavy, but it is extremely strong
	NSMutableArray * newSelectedRanges = [NSMutableArray arrayWithArray:selectedRanges];
	E = [affectedRanges reverseObjectEnumerator];
	while(V = [E nextObject])
	{
		affectedRange = [V rangeValue];
		NSEnumerator * e = [newSelectedRanges objectEnumerator];
		newSelectedRanges = [NSMutableArray array];
		while(V = [e nextObject])
		{
			selectedRange = [V rangeValue];
			if(selectedRange.location>affectedRange.location)
			{
				--selectedRange.location;
				V = [NSValue valueWithRange:selectedRange];
			}
			else if(NSMaxRange(selectedRange)>affectedRange.location)
			{
				--selectedRange.length;
				V = [NSValue valueWithRange:selectedRange];
			}
			[newSelectedRanges addObject:V];
		}
	}
	// 4 - Process to the change
	[self willChangeSelectedRanges];
	if([self shouldChangeTextInRanges:affectedRanges replacementStrings:replacementStrings])
	{
		NSEnumerator * E = [affectedRanges reverseObjectEnumerator];
		while(V = [E nextObject])
		{
			affectedRange = [V rangeValue];
			[self replaceCharactersInRange:affectedRange withString:@""];
		}
		[self didChangeText];
		[self setSelectedRanges:newSelectedRanges];
	}
	[self didChangeSelectedRanges];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  shouldChangeTextInRanges:replacementStrings:
- (BOOL)shouldChangeTextInRanges:(NSArray *)affectedRanges replacementStrings:(NSArray *)replacementStrings;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(![super shouldChangeTextInRanges:affectedRanges replacementStrings:replacementStrings])
	{
		return NO;
	}
	// this is a patch to manage the special glyph generation used by iTM2
	// some TeX commands are displayed just with one glyp
	// when the style is extended latex for example, the \alpha command is replaced by the alpha greek letter
	// There is a problem for text editing:
	// if you have in your text the "alpha" word as is, no the name of a TeX command
	// and if you want to insert \foo just before "alpha"
	// you place the cursor before the first a, the insert \, f, o, o, ' '
	// What you want is "\foo alpha"
	// but what you end up with is "foo \alpha"
	// The fact is when you insert the first '\', alpha becomes \alpha and is interpreted as one glyph
	// the NSTextView won't let you insert text inside the \alpha string,
	// any new text material will be inserted before the glyph
	// the purpose of this patch is to break the glyph when just one '\' character is inserted and
	// there is a one glyph shortcut
	// Here is the first part of the patch, the last one is in the didChangeText below.
	NSValue * V = [[self implementation] metaValueForKey:@"__expected selected range"];
	if(V)
	{
		// reentrant code management
		V = nil;
	}
	else if(([affectedRanges count] == 1) && ([replacementStrings count] > 0))
	{
		NSString * replacementString = [replacementStrings objectAtIndex:0];
		if([replacementString hasSuffix:[NSString backslashString]])
		{
			V = [affectedRanges lastObject];
			NSRange R = [V rangeValue];
			R.length = [replacementString length];
			R.location = NSMaxRange(R);
			R.length = 0;
			V = [NSValue valueWithRange:R];
		}
	}
	[[self implementation] takeMetaValue:V forKey:@"__expected selected range"];
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  didChangeText
- (void)didChangeText;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[super didChangeText];
	// see the shouldChangeTextInRanges:replacementStrings: implementation for an explanation of this patch
	NSValue * V = [[self implementation] metaValueForKey:@"__expected selected range"];
	if(V)
	{
		NSRange expectedSelectedRange = [V rangeValue];
		NSRange selectedRange = [self selectedRange];
		if(!NSEqualRanges(expectedSelectedRange,selectedRange))
		{
			// there is a one glyph problem,
			// in the string "x{", insert "\" then "u" after the "x"
			// if "\{" is laid out as one glyph,
			// you end up with "x\{u" instead of "x\u{"
			// what is the glyph and its command name counterpart
			NSLayoutManager * LM = [self layoutManager];
			NSRange charRange = expectedSelectedRange;
			charRange.length = 1;
			NSString * string = [self string];
			if(NSMaxRange(charRange)<=[string length])
			{
				NSRange actualCharRange;
				[LM glyphRangeForCharacterRange:charRange actualCharacterRange:&actualCharRange];// unused glyph range
				if(actualCharRange.length > charRange.length)
				{
					// this should always occur?
					NSMutableString * replacementString = [[[string substringWithRange:actualCharRange] mutableCopy] autorelease];
					NSUndoManager * UM = [self undoManager];
					if(![UM isUndoing] && ![UM isRedoing])
					{
						[replacementString insertString:@" " atIndex:1];
					}
					if([self shouldChangeTextInRange:actualCharRange replacementString:replacementString])
					{
						[self replaceCharactersInRange:actualCharRange withString:replacementString];
						[[self implementation] takeMetaValue:nil forKey:@"__expected selected range"];
						[self didChangeText];
						[self setSelectedRange:expectedSelectedRange];
					}
				}
			}
		}
	}
    return;
}
#pragma mark =-=-=-=-=-  COMPLETION
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  rangeForUserCompletion
- (NSRange)rangeForUserCompletion;
/*"Desription Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: 02/03/2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSRange range = [super rangeForUserCompletion];
	NSString * string = [self string];
	if(range.location>0)
	{
		BOOL escaped = NO;
		if([string isControlAtIndex:range.location-1 escaped:&escaped] && !escaped)
		{
			--range.location;
			++range.length;
		}
	}
//iTM2_END;
	return range;
}
@end

#pragma mark -
#pragma mark =-=-=-=-=-  BOOKMARKS
@implementation iTM2TeXEditor(Bookmarks)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= gotoTeXBookmark
- (IBAction)gotoTeXBookmark:(id)sender; 
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	int tag = [sender tag];
	NSString * S = [[self textStorage] string];
	if(tag>=0 && tag<[S length])
	{
		unsigned begin, end;
		[S getLineStart: &begin end: &end contentsEnd:nil forRange:NSMakeRange(tag, 0)];
		[self highlightAndScrollToVisibleRange:NSMakeRange(begin, end-begin)];
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateGotoTeXBookmark:
- (BOOL)validateGotoTeXBookmark:(id)sender; 
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertTeXBookmark:
- (IBAction)insertTeXBookmark:(id)sender; 
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * macro = NSLocalizedStringWithDefaultValue(NSStringFromSelector(_cmd),
		TABLE, BUNDLE, @"%! TEX bookmark: @(@identifier@)@", "Inserting a  macro");
	unsigned start, end, contentsEnd;
	NSRange selectedRange = [self selectedRange];
	[[[self textStorage] string] getLineStart: &start end: &end contentsEnd: &contentsEnd forRange:selectedRange];
	NSString * prefix = @"";
	NSString * suffix = @"";
	if(NSMaxRange(selectedRange)>contentsEnd)
	{
		selectedRange.length += end - NSMaxRange(selectedRange);
		suffix = @"\n";
		if(start<selectedRange.location)
		{
			prefix = @"\n";
		}
		[self setSelectedRange:selectedRange];
	}
	else if(start<selectedRange.location)
	{
		selectedRange.location = start;
		selectedRange.length = 0;
		suffix = @"\n";
		[self setSelectedRange:selectedRange];
	}
	[self insertMacro:[NSString stringWithFormat:@"%@%@%@", prefix, macro, suffix]];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateInsertTeXBookmark:
- (BOOL)validateInsertTeXBookmark:(id)sender; 
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return YES;
}
@end

@interface NSTextStorage(TeX)
- (NSMenu *)TeXBookmarkMenu;
@end

@implementation iTM2TeXBookmarkButton
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= awakeFromNib
- (void)awakeFromNib;
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([[self superclass] instancesRespondToSelector:_cmd])
		[super awakeFromNib];
	[self setAction:@selector(TeXBookmarkButtonAction:)];
	[self performSelector:@selector(initMenu) withObject:nil afterDelay:0.01];
	[DNC removeObserver: self
		name: NSPopUpButtonWillPopUpNotification
			object: self];
	[DNC addObserver: self
		selector: @selector(popUpButtonWillPopUpNotified:)
			name: NSPopUpButtonWillPopUpNotification
				object: self];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  popUpButtonWillPopUpNotified:
- (void)popUpButtonWillPopUpNotified:(NSNotification *)notification;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSMenu * M = [[[[self window] windowController] textStorage] TeXBookmarkMenu];
	NSAssert(M, @"Missing TeX bookmark menu: inconsistency");
	NSMenuItem * MI = [[self menu] deepItemWithRepresentedObject:@"TeX Bookmarks Menu"];
	if(MI)
	{
		[[MI menu] setSubmenu: ([M numberOfItems]? M:nil) forItem:MI];
	}
	else if(MI = [[self menu] deepItemWithAction:@selector(gotoTeXBookmark:)])
	{
		[MI setAction:NULL];
		[MI setRepresentedObject:@"TeX Bookmarks Menu"];
		[[MI menu] setSubmenu: ([M numberOfItems]? M:nil) forItem:MI];
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= initMenu
- (void)initMenu;
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSView * owner = [[[NSView allocWithZone:[self zone]] initWithFrame:NSZeroRect] autorelease];
	NSDictionary * context = [NSDictionary dictionaryWithObject:owner forKey:@"NSOwner"];
	NSString * fileName;
	Class class = [self class];
next:
	fileName = [[NSBundle bundleForClass:class] pathForResource:@"iTM2TeXBookmarkMenu" ofType:@"nib"];
	if([fileName length])
	{
		NSString * title = [self title];
		if([NSBundle loadNibFile:fileName externalNameTable:context withZone:[self zone]])
		{
			NSMenu * M = [[[owner menu] retain] autorelease];
			[owner setMenu:nil];
			if([M numberOfItems])
			{
				NSMenuItem * MI;
				NSEnumerator * E = [[M itemArray] objectEnumerator];
				while(MI = [E nextObject])
				{
					SEL action = [MI action];
					if(action)
					{
						if([NSStringFromSelector(action) hasPrefix:@"insert"])
						{
							if(![MI indentationLevel])
								[MI setIndentationLevel:1];
						}
					}
				}
				[[M itemAtIndex:0] setTitle:title];
				[self setTitle:title];// will raise if the menu is void
				[self setMenu:M];
			}
			else
			{
				iTM2_LOG(@"..........  ERROR: Inconsistent file (Void menu) at %@", fileName);
			}
		}
		else
		{
			iTM2_LOG(@"..........  ERROR: Corrupted file at %@", fileName);
		}
	}
	else
	{
		Class superclass = [class superclass];
		if((superclass) && (superclass != class))
		{
			class = superclass;
			goto next;
		}
	}
//iTM2_END;
    return;
}
@end

@implementation iTM2ScriptUserButton
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= awakeFromNib
- (void)awakeFromNib;
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([[self superclass] instancesRespondToSelector:_cmd])
		[super awakeFromNib];
	[self setAction:@selector(ScriptUserButtonAction:)];
	[self performSelector:@selector(initMenu) withObject:nil afterDelay:0.01];
	[DNC removeObserver: self
		name: NSPopUpButtonWillPopUpNotification
			object: self];
	[DNC addObserver: self
		selector: @selector(popUpButtonWillPopUpNotified:)
			name: NSPopUpButtonWillPopUpNotification
				object: self];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  popUpButtonWillPopUpNotified:
- (void)popUpButtonWillPopUpNotified:(NSNotification *)notification;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSMenu * M = [[[[self window] windowController] textStorage] TeXBookmarkMenu];
	NSAssert(M, @"Missing TeX bookmark menu: inconsistency");
	NSMenuItem * MI = [[self menu] deepItemWithRepresentedObject:@"TeX Bookmarks Menu"];
	if(MI)
	{
		[[MI menu] setSubmenu: ([M numberOfItems]? M:nil) forItem:MI];
	}
	else if(MI = [[self menu] deepItemWithAction:@selector(gotoTeXBookmark:)])
	{
		[MI setAction:NULL];
		[MI setRepresentedObject:@"TeX Bookmarks Menu"];
		[[MI menu] setSubmenu: ([M numberOfItems]? M:nil) forItem:MI];
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= initMenu
- (void)initMenu;
/*"Subclasses will return YES.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSView * owner = [[[NSView allocWithZone:[self zone]] initWithFrame:NSZeroRect] autorelease];
	NSDictionary * context = [NSDictionary dictionaryWithObject:owner forKey:@"NSOwner"];
	NSString * fileName;
	Class class = [self class];
next:
	fileName = [[NSBundle bundleForClass:class] pathForResource:@"iTM2TeXBookmarkMenu" ofType:@"nib"];
	if([fileName length])
	{
		NSString * title = [self title];
		if([NSBundle loadNibFile:fileName externalNameTable:context withZone:[self zone]])
		{
			NSMenu * M = [[[owner menu] retain] autorelease];
			[owner setMenu:nil];
			if([M numberOfItems])
			{
				NSMenuItem * MI;
				NSEnumerator * E = [[M itemArray] objectEnumerator];
				while(MI = [E nextObject])
				{
					SEL action = [MI action];
					if(action)
					{
						if([NSStringFromSelector(action) hasPrefix:@"insert"])
						{
							if(![MI indentationLevel])
								[MI setIndentationLevel:1];
						}
					}
				}
				[[M itemAtIndex:0] setTitle:title];
				[self setTitle:title];// will raise if the menu is void
				[self setMenu:M];
			}
			else
			{
				iTM2_LOG(@"..........  ERROR: Inconsistent file (Void menu) at %@", fileName);
			}
		}
		else
		{
			iTM2_LOG(@"..........  ERROR: Corrupted file at %@", fileName);
		}
	}
	else
	{
		Class superclass = [class superclass];
		if((superclass) && (superclass != class))
		{
			class = superclass;
			goto next;
		}
	}
//iTM2_END;
    return;
}
@end

@implementation NSTextStorage(TeX)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  TeXBookmarkMenu
- (NSMenu *)TeXBookmarkMenu;
/*"Description forthcoming. No consistency test.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSMenu * markMenu = [[[NSMenu allocWithZone:[NSMenu menuZone]] initWithTitle:@""] autorelease];
    [markMenu setAutoenablesItems:YES];
	
    NSString * S = [self string];
    iTM2LiteScanner * scan = [iTM2LiteScanner scannerWithString:S];
    unsigned scanLocation = 0, end = [S length];
    unichar theChar;
    while(scanLocation < end)
    {
        theChar = [S characterAtIndex:scanLocation];
        switch(theChar)
        {
            case '\\':
            {
                if((++scanLocation < end) &&
                    ([S characterAtIndex:scanLocation] == 'i') &&
                        (++scanLocation < end) &&
                            ([S characterAtIndex:scanLocation] == 'n') &&
                                (++scanLocation < end))
                {
                    NSRange R1 = NSMakeRange(scanLocation, end-scanLocation);
                    NSRange R2 = [S rangeOfString:@"put" options:NSAnchoredSearch range:R1];
                    if(R2.length)
                    {
                        SEL selector = @selector(scrollInputToVisible:);
                        NSString * prefix = @"Input";
                        [S getLineStart:nil end:nil contentsEnd: &scanLocation forRange:R2];
                        [scan setScanLocation:NSMaxRange(R2)];
                        [scan scanString:@"{" intoString:nil];
                        NSString * object;
                        if([scan scanUpToString:@"}" intoString: &object beforeIndex:scanLocation] ||
                            [scan scanCharactersFromSet:[[NSCharacterSet whitespaceAndNewlineCharacterSet] invertedSet]
                                intoString: &object beforeIndex: scanLocation])
                        {
                            object = [object stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];                            
                            NSString * title = [NSString stringWithFormat:@"%@: %@", prefix, object];
                            title = ([title length] > 48)?
                                            [NSString stringWithFormat:@"%@[...]",
                                                    [title substringWithRange:NSMakeRange(0,43)]]: title;
                            if([title length])
                            {
                                NSMenuItem * MI = [markMenu addItemWithTitle:title action:selector keyEquivalent:[NSString string]];
                                [MI setRepresentedObject:object];
								[MI setTag:scanLocation];
                                [MI setEnabled: ([[markMenu title] length] > 0)];
                            }
                        }
                    }
                    else if(R2 = [S rangeOfString:@"clude" options:NSAnchoredSearch range:R1], R2.length)
                    {
                        SEL selector = @selector(scrollIncludeToVisible:);
                        NSString * prefix = @"Include";
                        unsigned int contentsEnd;
                        [S getLineStart:nil end:nil contentsEnd: &contentsEnd forRange:R1];
                        [scan setScanLocation:NSMaxRange(R2)];
                        if([scan scanString:@"[" intoString:nil beforeIndex:contentsEnd])
                        {
                            [scan scanUpToString:@"]" intoString:nil];
                            [scan scanString:@"]" intoString:nil];
                        }
                        if([scan scanString:@"{" intoString:nil beforeIndex:contentsEnd])
                        {
                            NSString * object;
                            if([scan scanUpToString:@"}" intoString: &object beforeIndex:contentsEnd])
                            {
                                object = [object stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                                NSString * title = [NSString stringWithFormat:@"%@: %@", prefix, object];
                                title = ([title length] > 48)?
                                                [NSString stringWithFormat:@"%@[...]",
                                                        [title substringWithRange:NSMakeRange(0,43)]]: title;
                                if([title length])
                                {
                                    NSMenuItem * MI = [markMenu addItemWithTitle:title action:selector keyEquivalent:[NSString string]];
                                    [MI setRepresentedObject:object];
                                    [MI setTag:scanLocation];
                                }
                            }
                        }
                        else
                            NSLog(@"No file to include");
                    }
                    else
                        break;
                }
                else
                {
                    ++scanLocation;
                }
            }
            break;
            case '%':
            {
                [scan setScanLocation: ++scanLocation];
                [scan setCaseSensitive:NO];
                NSString * object = nil;
                if([scan scanString:@"!" intoString:nil] &&
					(
                    [scan scanString:@"itexmac" intoString:nil] &&
                    [scan scanString:@"(" intoString:nil] &&
                    [scan scanString:@"mark" intoString:nil] &&
                    [scan scanString:@")" intoString:nil]
					|| [scan scanString:@"tex" intoString:nil] &&
                    [scan scanString:@"bookmark" intoString:nil]) &&
                    [scan scanString:@":" intoString:nil] &&
                    [scan scanUpToCharactersFromSet:
                        [NSCharacterSet characterSetWithCharactersInString:@"\r\n"]
                            intoString: &object])
                {
                    object = [object stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                    NSString * title = ([object length] > 48)?
                                            [NSString stringWithFormat:@"%@[...]",
                                                [object substringWithRange:NSMakeRange(0,43)]]: object;
                    if([title length])
                    {
                        NSMenuItem * MI = [markMenu addItemWithTitle: title
                                                action: @selector(gotoTeXBookmark:)
                                                    keyEquivalent: [NSString string]];
                        [MI setTag:scanLocation];
                        [MI setRepresentedObject:object];
                    }
                }
                [scan setCaseSensitive:YES];
                scanLocation = [scan scanLocation];
            }
            default:
                ++scanLocation;
        }
    }
    return markMenu;
}
@end

NSString * const iTM2TeXSmartSelectionKey = @"iTM2-Text: Smart Selection";

@implementation iTM2TextStorage(DoubleClick)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= initialize
+ (void)initialize;
/*"Description forthcoming.
Version history: jlaurens AT users.sourceforge.net
- < 1.1: 03/10/2002
To Do List: implement some kind of balance range for range
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[SUD registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], iTM2TeXSmartSelectionKey, nil]];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= doubleClickAtIndex:
- (NSRange)doubleClickAtIndex:(unsigned)index;
/*"Description forthcoming.
Version history: jlaurens AT users.sourceforge.net
- < 1.1: 03/10/2002
To Do List: implement some kind of balance range for range
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSRange R = [self contextBoolForKey:iTM2TeXSmartSelectionKey domain:iTM2ContextAllDomainsMask] && ![iTM2EventObserver isAlternateKeyDown]?
        [self smartDoubleClickAtIndex:index]:[super doubleClickAtIndex:index];
//iTM2_END;
    return R;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  smartDoubleClickAtIndex:
- (NSRange)smartDoubleClickAtIndex:(unsigned)index;
/*"Description forthcoming.
Version history: jlaurens AT users.sourceforge.net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSString * string = [self string];
    if(NSLocationInRange(index, NSMakeRange(0, [string length])))
    {
		NSRange PHR = [string rangeOfPlaceholderAtIndex:index];
		if(PHR.length)
			return PHR;
        BOOL escaped = YES;
        if([string isControlAtIndex:index escaped: &escaped])
        {
            if(!escaped && index+1<[string length])
            {
                return [super doubleClickAtIndex:index+1];
            }
            return NSMakeRange(index, 1);
        }
        //else
        switch([string characterAtIndex:index])
        {
            NSRange R;
            case '{':
            case '}':
                if(R = [string groupRangeAtIndex:index beginDelimiter: '{' endDelimiter: '}'], R.length>0)
                    return R;
                break;
            case '(':
            case ')':
                if (R = [string groupRangeAtIndex:index beginDelimiter: '(' endDelimiter: ')'], R.length>0)
                    return R;
                break;
            case '[':
            case ']':
                if (R = [string groupRangeAtIndex:index beginDelimiter: '[' endDelimiter: ']'], R.length>0)
                    return R;
                break;
            case '%':
            {
                BOOL escaped;
                if((index>0) && [string isControlAtIndex:index-1 escaped: &escaped] && !escaped)
                    return NSMakeRange(index-1, 2);
                else
                {
                    unsigned int start;
                    unsigned int end;
                    unsigned int contentsEnd;
//NSLog(@"GLS");
                    [string getLineStart: &start end: &end contentsEnd: &contentsEnd forRange:NSMakeRange(index, 0)];
//NSLog(@"GLS");
                    return (start<index)? NSMakeRange(index, contentsEnd - index): NSMakeRange(start, end - start);
                }
            }
            case '^':
            case '_':
            {
                BOOL escaped;
                if((index+1<[string length]) && (![string isControlAtIndex:index-1 escaped: &escaped] || escaped))
                {
                    NSRange R = [string groupRangeAtIndex:index+1];
                    if(R.length)
                    {
                        --R.location;
                        ++R.length;
                        return R;
                    }
                    else
                        return NSMakeRange(index, 1);
                }
            }
            case '.':
            {
                int rightBlackChars = 0;
                int leftBlackChars = 0;
                int top = [[self string] length];
                int n = index;
                while((++n<top) && ![[NSCharacterSet whitespaceAndNewlineCharacterSet] characterIsMember:[string characterAtIndex:n]])
                    ++rightBlackChars;
                while((n--<0) && ![[NSCharacterSet whitespaceAndNewlineCharacterSet] characterIsMember:[string characterAtIndex:n]])
                    ++leftBlackChars;
                if(rightBlackChars && leftBlackChars)
                    return NSMakeRange(index - leftBlackChars, leftBlackChars + rightBlackChars + 1);
            //NSLog(@"[S substringWithRange: %@]: %@", NSStringFromRange(R), [S substringWithRange:R]);
            }
        }
//iTM2_END;
        return [super doubleClickAtIndex:index];
    }
//iTM2_END;
    return NSMakeRange(NSNotFound, 0);
}
@end