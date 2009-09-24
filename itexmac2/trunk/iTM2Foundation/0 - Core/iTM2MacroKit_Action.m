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

#import "iTM2MacroKit_Action.h"
#import "iTM2MacroKit_Controller.h"
#import "iTM2MacroKit_String.h"

#import <iTM2Foundation/NSTextStorage_iTeXMac2.h>

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
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(action == @selector(noop:))
	{
		return NO;
	}
	if(!target)
	{
		target = [[NSApp keyWindow] firstResponder];
	}
	BOOL result = NO;
	NSMethodSignature * MS = nil;
	if(action && (MS = [target methodSignatureForSelector:action]))
	{
here:
		[self setSubstitutions:theSubstitutions];
		if([MS numberOfArguments] == 3)
		{
			NS_DURING
			[target performSelector:action withObject:self];
			result = YES;
			NS_HANDLER
			NS_ENDHANDLER
		}
		else if([MS numberOfArguments] == 2)
		{
			NS_DURING
			[target performSelector:action];
			result = YES;
			NS_HANDLER
			NS_ENDHANDLER
		}
		else if(MS)
		{
		}
		else if([[[NSApp keyWindow] firstResponder] tryToPerform:action with:self]
			|| [[[NSApp mainWindow] firstResponder] tryToPerform:action with:self])
		{
			result = YES;
		}
		else
		{
			iTM2_LOG(@"No target for %@ with argument:%@", NSStringFromSelector(action),self);
		}
		[self setSubstitutions:nil];
//iTM2_END;
		return result;
	}
	if((action = [self action])
			&& (MS = [target methodSignatureForSelector:action]))
	{
		goto here;
	}
	if((action = NSSelectorFromString([self macroID]))
		&& (MS = [target methodSignatureForSelector:action]))
	{
		goto here;
	}
	if((action = NSSelectorFromString(@"insertMacro:"))
		&& (MS = [target methodSignatureForSelector:action]))
	{
		goto here;
	}
//iTM2_END;
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= validate___catch:
- (BOOL)validate___catch:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= ___insertMacro:
- (void)___insertMacro:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSArray * RA = [sender representedObject];
	if([RA isKindOfClass:[NSArray class]] && [RA count])
	{
		NSString * ID = [RA objectAtIndex:0];
		NSString * context;
		NSString * category;
		NSString * domain;
		if([RA count] > 3)
		{
			context = [RA objectAtIndex:1];
			category = [RA objectAtIndex:2];
			domain = [RA objectAtIndex:3];
		}
		else
		{
			context = @"";
			if([RA count] > 2)
			{
				category = [RA objectAtIndex:1];
				domain = [RA objectAtIndex:2];
			}
			else
			{
				category = @"";
				if([RA count] > 1)
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
		if([ID length])
		{
			if([[self macroWithID:ID] executeMacroWithTarget:nil selector:NULL substitutions:nil])
			{
				NSMenu * recentMenu = [self macroMenuForContext:[self macroContext] ofCategory:@"Recent" inDomain:[self macroDomain] error:nil];
				int index = [recentMenu indexOfItemWithTitle:[sender title]];
				if(index!=-1)
				{
					[recentMenu removeItemAtIndex:index];
				}
				NSMenuItem * MI = [[[NSMenuItem alloc] initWithTitle:[sender title] action:[sender action] keyEquivalent:@""] autorelease];
				[MI setTarget:self];// self is expected to live forever
				[MI setRepresentedObject:RA];
				[recentMenu insertItem:MI atIndex:1];
				NSMutableDictionary * MD = [NSMutableDictionary dictionary];
				index = 0;
				int max = [SUD integerForKey:@"iTM2NumberOfRecentMacros"];
				while([recentMenu numberOfItems] > max)
				{
					[recentMenu removeItemAtIndex:[recentMenu numberOfItems]-1];
				}
				while(++index < [recentMenu numberOfItems])
				{ 
					MI = [recentMenu itemAtIndex:index];
					RA = [MI  representedObject];
					if(RA)
					{
						[MD setObject:RA forKey:[MI title]];
					}
				}
				[SUD setObject:MD forKey:[NSString pathWithComponents:[NSArray arrayWithObjects:@"", @"Recent", domain, nil]]];
			}
		}
	}
	else if(RA)
	{
		iTM2_LOG(@"Unknown design [sender representedObject]:%@", RA);
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= validate___insertMacro:
- (BOOL)validate___insertMacro:(id)sender;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSArray * RA = [sender representedObject];
	if([RA isKindOfClass:[NSArray class]] && ([RA count] > 2))
	{
		NSString * ID = [RA objectAtIndex:0];
		if([ID length])
			return YES;
	}
	iTM2_LOG(@"sender is:%@",sender);
//iTM2_END;
    return [sender hasSubmenu];
}
@end

@implementation NSObject(iTM2ExecuteMacro)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  executeMacroWithID:
- (BOOL)executeMacroWithID:(NSString *)ID;
/*"Description forthcoming.
If the event is a 1 char key down, it will ask the current key binding for macro.
The key and its modifiers are 
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	return [[self macroWithID:ID] executeMacroWithTarget:self selector:NULL substitutions:nil];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= executeMacroWithText:
- (BOOL)executeMacroWithText:(NSString *)text;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Thu Jul 21 16:05:20 GMT 2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	unsigned idx = 0;
	BOOL result = NO;
	while(idx<[text length])
	{
		NSString * type = nil;
		NSRange range = [text rangeOfNextPlaceholderMarkAfterIndex:idx getType:&type ignoreComment:YES];
		if(!range.length)
		{
			return NO;
		}
		else if(type)
		{
			NSRange fullRange = [text rangeOfPlaceholderAtIndex:range.location getType:nil ignoreComment:YES];
			if(fullRange.location == range.location && fullRange.length > range.length)
			{
				fullRange.length = NSMaxRange(fullRange);
				fullRange.location = NSMaxRange(range);
				if(fullRange.length>fullRange.location)
				{
					fullRange.length-=fullRange.location;
					if(fullRange.length>4)
					{
						fullRange.length-=4;
						text = [text substringWithRange:fullRange];
						iTM2MacroNode * leafNode = [self macroWithID:text];
						SEL action = NULL;
						NSString * actionName = [NSString stringWithFormat:@"insertMacro_%@:",type];
						action = NSSelectorFromString(actionName);
						result = result || [leafNode executeMacroWithTarget:self selector:action substitutions:nil];
					}
				}
			}
		}
		idx = NSMaxRange(range);
	}

//iTM2_START;
	return NO;
}
@end

@implementation NSView(iTM2ExecuteMacro)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  tryToExecuteMacroWithID:
- (BOOL)tryToExecuteMacroWithID:(NSString *)macro;
/*"Description forthcoming.
If the event is a 1 char key down, it will ask the current key binding for macro.
The key and its modifiers are 
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return [super tryToExecuteMacroWithID:macro]
			|| [[self superview] tryToExecuteMacroWithID:macro]
				|| [[self window] tryToExecuteMacroWithID:macro];// not good
}
@end

@implementation NSWindow(iTM2ExecuteMacro)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  tryToExecuteMacroWithID:
- (BOOL)tryToExecuteMacroWithID:(NSString *)macro;
/*"Description forthcoming.
If the event is a 1 char key down, it will ask the current key binding for macro.
The key and its modifiers are 
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return [super tryToExecuteMacroWithID:macro]
			|| [[self delegate] executeMacroWithID:macro]
				|| [[self windowController] tryToExecuteMacroWithID:macro];
}
@end

@implementation NSWindowController(iTM2ExecuteMacro)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  tryToExecuteMacroWithID:
- (BOOL)tryToExecuteMacroWithID:(NSString *)macro;
/*"Description forthcoming.
If the event is a 1 char key down, it will ask the current key binding for macro.
The key and its modifiers are 
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return [super tryToExecuteMacroWithID:macro]
			|| [[self document] executeMacroWithID:macro]
				|| (([self owner] != self) && [[self owner] executeMacroWithID:macro]);
}
@end

@implementation NSResponder(iTM2ExecuteMacro)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  executeStringInstruction:
- (BOOL)executeMacroWithID:(NSString *)macro;
/*"Description forthcoming.
If the event is a 1 char key down, it will ask the current key binding for instruction.
The key and its modifiers are 
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return [self tryToExecuteMacroWithID:macro] || [super executeMacroWithID:macro];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  tryToExecuteMacroWithID:
- (BOOL)tryToExecuteMacroWithID:(NSString *)macro;
/*"Description forthcoming.
If the event is a 1 char key down, it will ask the current key binding for macro.
The key and its modifiers are 
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSRange R = [macro rangeOfString:@":"];
	if(R.length)
	{
		R.length = R.location + 1;
		R.location = 0;
		NSString * selectorName = [macro substringWithRange:R];
		SEL action = NSSelectorFromString(selectorName);
		if([self respondsToSelector:action])
		{
			R.location = R.length;
			R.length = [macro length] - R.location;
			NSString * argument = [macro substringWithRange:R];
			if([self tryToPerform:action with:argument])
			{
				return YES;
			}
		}
	}
//iTM2_END;
    return NO;
}
@end

#import <iTM2Foundation/iTM2ContextKit.h>

@implementation iTM2MacroNode(Action)
- (NSString *)concreteArgument;
{
	id result = [self insertion];
	if(!result)
	{
		result = [self macroID];
	}
	id theSubstitutions = [self substitutions];
	if([theSubstitutions count])
	{
		NSString * string1, * string2;
		NSMutableString * result = [NSMutableString stringWithString:result];
		NSEnumerator * E = [theSubstitutions keyEnumerator];
		NSRange range;
		while(string1 = [E nextObject])
		{
			string2 = [theSubstitutions objectForKey:string1];
			range = NSMakeRange(0,[result length]);
			[result replaceOccurrencesOfString:string1 withString:string2 options:0L range:range];
		}
	}
	return result;
}
@end

@implementation NSTextView(iTM2ExecuteMacro)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  tryToExecuteMacroWithID:
- (BOOL)tryToExecuteMacroWithID:(NSString *)macro;
/*"Description forthcoming.
If the event is a 1 char key down, it will ask the current key binding for macro.
The key and its modifiers are 
Version history: jlaurens AT users DOT sourceforge DOT net
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSRange R = [macro rangeOfString:@":"];
	if(R.length)
	{
		R.length = R.location + 1;
		R.location = 0;
		NSString * selectorName = [macro substringWithRange:R];
		SEL action = NSSelectorFromString(selectorName);
		if([self respondsToSelector:action])
		{
			R.location = R.length;
			R.length = [macro length] - R.location;
			NSString * argument = [macro substringWithRange:R];
			if([self tryToPerform:action with:argument])
			{
				return YES;
			}
		}
	}
//iTM2_END;
    return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertMacro:inRange:
- (void)insertMacro:(id)argument inRange:(NSRange)affectedCharRange;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (1.0.10)
- 1.2: 06/24/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if([argument conformsToProtocol:@protocol(NSMenuItem)])
        argument = [argument representedObject];
// this new part concerns the new macro design. 2006
    if([argument isKindOfClass:[NSString class]])
	{
//iTM2_LOG(@"argument:%@",argument);
		NSString * selection = [self preparedSelectedStringForMacroInsertion];
		NSString * line = [self preparedSelectedLineForMacroInsertion];
		NSString * replacementString = [self replacementStringForMacro:argument selection:selection line:line];		
		if([self contextBoolForKey:iTM2DontUseSmartMacrosKey domain:iTM2ContextPrivateMask|iTM2ContextExtendedMask])
		{
			replacementString = [replacementString stringByRemovingPlaceholderMarks];
		}
		if(affectedCharRange.location == NSNotFound)
		{
			NSPasteboard * PB = [NSPasteboard generalPasteboard];
			NSArray * newTypes = [NSArray arrayWithObject:NSStringPboardType];
			[PB declareTypes:newTypes owner:nil];
			[PB setString:replacementString forType:NSStringPboardType];
		}
		else
		{
			replacementString = [self macroByPreparing:replacementString forInsertionInRange:affectedCharRange];
			if([self shouldChangeTextInRange:affectedCharRange replacementString:replacementString])
			{
				[self replaceCharactersInRange:affectedCharRange withString:replacementString];
				[self didChangeText];
				[self selectFirstPlaceholder:self];
			}
		}
		return;
	}
	if([argument isKindOfClass:[NSArray class]])
	{
		NSEnumerator * E = [argument objectEnumerator];
		while(argument = [E nextObject])
		{
			[self insertMacro:argument inRange:affectedCharRange];
		}
		return;
	}
	if([argument isKindOfClass:[iTM2MacroNode class]])
	{
		argument = [argument concreteArgument];
		[self insertMacro:argument inRange:affectedCharRange];
		return;
	}
    NSLog(@"Don't know what to do with this argument: %@", argument);
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertMacro_ROUGH:
- (void)insertMacro_ROUGH:(id)argument;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (1.0.10)
- 1.2: 06/24/2002
To Do List:
"*/
{
//iTM2_LOG(@"argument:%@",argument);
	NSRange affectedCharRange = [self selectedRange];
	if([self shouldChangeTextInRange:affectedCharRange replacementString:argument])
	{
		[self replaceCharactersInRange:affectedCharRange withString:argument];
		[self didChangeText];
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSRange range = [self selectedRange];
    [self insertMacro:argument inRange:range];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertMacro_APPEND_ALL:
- (void)insertMacro_APPEND_ALL:(id)argument;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (1.0.10)
- 1.2: 06/24/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSRange range = NSMakeRange(0,0);
	range.location = [[self string] length];
    [self insertMacro:argument inRange:range];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertMacro_REPLACE_ALL:
- (void)insertMacro_REPLACE_ALL:(id)argument;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (1.0.10)
- 1.2: 06/24/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSRange range = NSMakeRange(0,0);
	range.length = [[self string] length];
    [self insertMacro:argument inRange:range];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertMacro_PREPEND_ALL:
- (void)insertMacro_PREPEND_ALL:(id)argument;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (1.0.10)
- 1.2: 06/24/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSRange range = NSMakeRange(0,0);
    [self insertMacro:argument inRange:range];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertMacro_APPEND_SELECTION:
- (void)insertMacro_APPEND_SELECTION:(id)argument;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (1.0.10)
- 1.2: 06/24/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSRange range = [self selectedRange];
	range.location = NSMaxRange(range);
	range.length = 0;
    [self insertMacro:argument inRange:range];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertMacro_REPLACE_SELECTION:
- (void)insertMacro_REPLACE_SELECTION:(id)argument;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (1.0.10)
- 1.2: 06/24/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self insertMacro:argument];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertMacro_PREPEND_SELECTION:
- (void)insertMacro_PREPEND_SELECTION:(id)argument;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (1.0.10)
- 1.2: 06/24/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSRange range = [self selectedRange];
	range.length = 0;
    [self insertMacro:argument inRange:range];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertMacro_PREPEND_LINE:
- (void)insertMacro_PREPEND_LINE:(id)argument;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (1.0.10)
- 1.2: 06/24/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSRange range = [self selectedRange];
	range.length = 0;
	NSTextStorage * TS = [self textStorage];
	[TS getLineStart:&range.location end:nil contentsEnd:nil forRange:range];
    [self insertMacro:argument inRange:range];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertMacro_REPLACE_LINE:
- (void)insertMacro_REPLACE_LINE:(id)argument;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (1.0.10)
- 1.2: 06/24/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSRange range = [self selectedRange];
	range.length = 0;
	NSTextStorage * TS = [self textStorage];
	[TS getLineStart:&range.location end:&range.length contentsEnd:nil forRange:range];
	range.length -= range.location;
    [self insertMacro:argument inRange:range];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertMacro_APPEND_LINE:
- (void)insertMacro_APPEND_LINE:(id)argument;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (1.0.10)
- 1.2: 06/24/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSRange range = [self selectedRange];
	range.length = 0;
	NSTextStorage * TS = [self textStorage];
	[TS getLineStart:nil end:nil contentsEnd:&range.location forRange:range];
    [self insertMacro:argument inRange:range];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  insertMacro_COPY:
- (void)insertMacro_COPY:(id)argument;
/*"Description forthcoming. .
Version history: jlaurens AT users DOT sourceforge DOT net (1.0.10)
- 1.2: 06/24/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSRange range = NSMakeRange(NSNotFound,0);
    [self insertMacro:argument inRange:range];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  macroByPreparing:forInsertionInRange:
- (NSString *)macroByPreparing:(NSString *)macro forInsertionInRange:(NSRange)affectedCharRange;
/*"The purpose is to return a macro with the proper indentation.
This is also used with scripts.
Version history: jlaurens AT users DOT sourceforge DOT net (1.0.10)
- 1.2: 06/24/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSMutableArray * MRA = [NSMutableArray array];
	NSArray * components = [macro lineComponents];
	NSEnumerator * E = [components objectEnumerator];
	NSString * S = [self string];
	unsigned numberOfSpacesPerTab = [self numberOfSpacesPerTab];
	unsigned indentationLevel = [S indentationLevelAtIndex:affectedCharRange.location withNumberOfSpacesPerTab:numberOfSpacesPerTab];
	unsigned currentIndentationLevel = 0, localIndentationLevel = 0;
	NSRange range;
	range.location = 27;
	NSString * line;
	if(line = [E nextObject])
	{
		[MRA addObject:line];//no indentation on the first line
		while(line = [E nextObject])
		{
			if([line hasPrefix:@"__iTM2_INDENTATION_PREFIX__"])
			{
				range.length = [line length]-range.location;
				line = [line substringWithRange:range];
				if(currentIndentationLevel)
				{
					localIndentationLevel = currentIndentationLevel + [line indentationLevelAtIndex:0 withNumberOfSpacesPerTab:numberOfSpacesPerTab];
					line = [line stringWithIndentationLevel:localIndentationLevel atIndex:0 withNumberOfSpacesPerTab:numberOfSpacesPerTab];
				}
			}
			else
			{
				currentIndentationLevel = indentationLevel + [line indentationLevelAtIndex:0 withNumberOfSpacesPerTab:numberOfSpacesPerTab];
				line = [line stringWithIndentationLevel:currentIndentationLevel atIndex:0 withNumberOfSpacesPerTab:numberOfSpacesPerTab];
			}
			[MRA addObject:line];
		}
		macro = [MRA componentsJoinedByString:@""];
	}
	NSMutableString * replacement = [NSMutableString stringWithString:macro];
	unsigned index;
	if(index = [replacement length])
	{
		NSString * tabAnchor = [self tabAnchor];
		range = [replacement rangeOfPreviousPlaceholderBeforeIndex:index cycle:NO tabAnchor:tabAnchor ignoreComment:YES];
		if(range.length)
		{
			if(NSMaxRange(range)+1<index)// if there is just one char to the end, don't add a placeholder mark
			{
				[replacement appendString:@"@@@()@@@"];
			}
		}
	}
//iTM2_END;
    return replacement;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  preparedSelectedLineForMacroInsertion
- (NSString *)preparedSelectedLineForMacroInsertion;
/*"The purpose is to return a prepared selected string: indentation is managed here.
This is also used with scripts.
Version history: jlaurens AT users DOT sourceforge DOT net (1.0.10)
- 1.2: 06/24/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSRange selectedRange = [self selectedRange];
	NSString * S = [self string];
	[S getLineStart:&selectedRange.location end:&selectedRange.length contentsEnd:nil forRange:selectedRange];
	selectedRange.length -= selectedRange.location;
	NSString * selectedString = [S substringWithRange:selectedRange];
//iTM2_END;
    return selectedString;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  preparedSelectedStringForMacroInsertion
- (NSString *)preparedSelectedStringForMacroInsertion;
/*"The purpose is to return a prepared selected string: indentation is managed here.
This is also used with scripts.
Version history: jlaurens AT users DOT sourceforge DOT net (1.0.10)
- 1.2: 06/24/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSRange selectedRange = [self selectedRange];
	NSString * S = [self string];
	NSString * selectedString = [S substringWithRange:selectedRange];
	unsigned numberOfSpacesPerTab = [self numberOfSpacesPerTab];
	selectedString = [selectedString stringByNormalizingIndentationWithNumberOfSpacesPerTab:numberOfSpacesPerTab];
	NSArray * components = [selectedString lineComponents];
	NSMutableArray * MRA = [NSMutableArray array];
	NSEnumerator * E = [components objectEnumerator];
	unsigned lineIndentation = 0;
	// selected range used!
	unsigned indentation = [S indentationLevelAtIndex:selectedRange.location withNumberOfSpacesPerTab:numberOfSpacesPerTab];
	NSString * line;
	while(line = [E nextObject])
	{
		lineIndentation = [line indentationLevelAtIndex:0 withNumberOfSpacesPerTab:numberOfSpacesPerTab];
		if(lineIndentation>indentation)
		{
			lineIndentation-=indentation;
			line = [line stringWithIndentationLevel:lineIndentation atIndex:0 withNumberOfSpacesPerTab:numberOfSpacesPerTab];
		}
		[MRA addObject:line];
	}
	selectedString = [MRA componentsJoinedByString:@"__iTM2_INDENTATION_PREFIX__"];
//iTM2_END;
    return selectedString;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  concreteReplacementStringForMacro:selection:line:
- (NSString *)concreteReplacementStringForMacro:(NSString *)macro selection:(NSString *)selection line:(NSString *)line;
/*"The purpose is to translate some keywords into the value they represent.
This is also used with scripts.
Version history: jlaurens AT users DOT sourceforge DOT net (1.0.10)
- 1.2: 06/24/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSMutableString * replacementString = [NSMutableString string];
	NSString * all = [self string];
	NSString * path = [[[[self window]windowController]document]fileName];
	BOOL PERL = NO;
	BOOL RUBY = NO;
	NSString * startType = nil;
	NSString * stopType = nil;
	NSString * copyString = nil;
	NSRange startRange = NSMakeRange(0,0);
	NSRange stopRange = NSMakeRange(0,0);
	NSRange copyRange = NSMakeRange(0,0);
	NSString * perlEscapedSelection = nil;
	NSString * perlEscapedLine = nil;
	NSString * perlEscapedAll = nil;
	NSString * perlEscapedPath = nil;
nextRange:
	startRange = [macro rangeOfNextPlaceholderMarkAfterIndex:copyRange.location getType:&startType ignoreComment:YES];
	if(startRange.length)
	{
		copyRange.location = NSMaxRange(stopRange);
		copyRange.length = startRange.location - copyRange.location;
		copyString = [macro substringWithRange:copyRange];
		[replacementString appendString:copyString];
nextStopRange:
		copyRange.location = NSMaxRange(startRange);
		stopRange = [macro rangeOfNextPlaceholderMarkAfterIndex:copyRange.location getType:&stopType ignoreComment:YES];
		if(stopRange.length)
		{
			if(!startType)
			{
				// the startRange was in fact a stop placeholder mark range
				copyRange = startRange;
				copyRange.length = NSMaxRange(stopRange) - copyRange.location;
				copyString = [macro substringWithRange:copyRange];
				[replacementString appendString:copyString];
				// go for a next pair start+stop
				copyRange.location = NSMaxRange(stopRange);
				goto nextRange;
			}
			else if(!stopType)
			{
				if([startType isEqual:@"SELECTION"] || [startType isEqual:@"MATH"])
				{
					if([selection length])
					{
						[replacementString appendString:@"@@@("];
						[replacementString appendString:selection];
						[replacementString appendString:@")@@@"];
					}
					else
					{
						copyRange.location = NSMaxRange(startRange);
						copyRange.length = stopRange.location - copyRange.location;
						if(copyRange.length)
						{
							[replacementString appendString:@"@@@("];
							copyString = [macro substringWithRange:copyRange];
							[replacementString appendString:copyString];
							[replacementString appendString:@")@@@"];
						}
					}
				}
				else if([startType isEqual:@"INPUT_SELECTION"])
				{
					if([selection length])
					{
						[replacementString appendString:selection];
					}
					else
					{
						copyRange.location = NSMaxRange(startRange);
						copyRange.length = stopRange.location - copyRange.location;
						if(copyRange.length)
						{
							copyString = [macro substringWithRange:copyRange];
							[replacementString appendString:copyString];
						}
					}
				}
				else if([startType isEqual:@"PERL_INPUT_SELECTION"])
				{
					PERL = YES;
					[replacementString appendString:@"my $INPUT_SELECTION= <<__END_OF_INPUT__;\n"];
					if(perlEscapedSelection)
					{
						[replacementString appendString:perlEscapedSelection];
					}
					else if([selection length])
					{
						perlEscapedSelection = [selection stringByEscapingPerlControlCharacters];
						[replacementString appendString:perlEscapedSelection];
					}
					else
					{
						copyRange.location = NSMaxRange(startRange);
						copyRange.length = stopRange.location - copyRange.location;
						if(copyRange.length)
						{
							copyString = [macro substringWithRange:copyRange];
							copyString = [copyString stringByEscapingPerlControlCharacters];
							[replacementString appendString:copyString];
						}
					}
					[replacementString appendString:@"__END_OF_CONTENT__\n__END_OF_INPUT__\n"];
					[replacementString appendString:@"$INPUT_SELECTION =~ m/(.*)__END_OF_CONTENT__.*/s;\n$INPUT_SELECTION=\"$1\";"];
				}
				else if([startType isEqual:@"PERL_INPUT_LINE"])
				{
					PERL = YES;
					[replacementString appendString:@"my $INPUT_LINE= <<__END_OF_INPUT__;\n"];
					if(perlEscapedLine)
					{
						[replacementString appendString:perlEscapedLine];
					}
					else if([line length])
					{
						perlEscapedLine = [line stringByEscapingPerlControlCharacters];
						[replacementString appendString:perlEscapedLine];
					}
					else
					{
						copyRange.location = NSMaxRange(startRange);
						copyRange.length = stopRange.location - copyRange.location;
						if(copyRange.length)
						{
							copyString = [macro substringWithRange:copyRange];
							copyString = [copyString stringByEscapingPerlControlCharacters];
							[replacementString appendString:copyString];
						}
					}
					[replacementString appendString:@"__END_OF_CONTENT__\n__END_OF_INPUT__\n"];
					[replacementString appendString:@"$INPUT_LINE =~ m/(.*)__END_OF_CONTENT__.*/s;\n$INPUT_LINE=\"$1\";"];
				}
				else if([startType isEqual:@"PERL_INPUT_ALL"])
				{
					PERL = YES;
					[replacementString appendString:@"my $INPUT_ALL= <<__END_OF_INPUT__;\n"];
					if(perlEscapedAll)
					{
						[replacementString appendString:perlEscapedAll];
					}
					else if([all length])
					{
						perlEscapedAll = [all stringByEscapingPerlControlCharacters];
						[replacementString appendString:perlEscapedAll];
					}
					else
					{
						copyRange.location = NSMaxRange(startRange);
						copyRange.length = stopRange.location - copyRange.location;
						if(copyRange.length)
						{
							copyString = [macro substringWithRange:copyRange];
							copyString = [copyString stringByEscapingPerlControlCharacters];
							[replacementString appendString:copyString];
						}
					}
					[replacementString appendString:@"__END_OF_CONTENT__\n__END_OF_INPUT__\n"];
					[replacementString appendString:@"$INPUT_ALL =~ m/(.*)__END_OF_CONTENT__.*/s;\n$INPUT_ALL=\"$1\";"];
				}
				else if([startType isEqual:@"PERL_INPUT_PATH"])
				{
					PERL = YES;
					[replacementString appendString:@"my $INPUT_PATH= <<__END_OF_INPUT__;\n"];
					if(perlEscapedPath)
					{
						[replacementString appendString:perlEscapedPath];
					}
					else if([path length])
					{
						perlEscapedPath = [path stringByEscapingPerlControlCharacters];
						[replacementString appendString:perlEscapedPath];
					}
					else
					{
						copyRange.location = NSMaxRange(startRange);
						copyRange.length = stopRange.location - copyRange.location;
						if(copyRange.length)
						{
							copyString = [macro substringWithRange:copyRange];
							copyString = [copyString stringByEscapingPerlControlCharacters];
							[replacementString appendString:copyString];
						}
					}
					[replacementString appendString:@"__END_OF_CONTENT__\n__END_OF_INPUT__\n"];
					[replacementString appendString:@"$INPUT_PATH =~ m/(.*)__END_OF_CONTENT__.*/s;\n$INPUT_PATH=\"$1\";"];
				}
				else if([startType isEqual:@"RUBY_INPUT_SELECTION"])
				{
					RUBY = YES;
					[replacementString appendString:@"INPUT_SELECTION = <<'__END_OF_INPUT__'\n"];
					if([selection length])
					{
						[replacementString appendString:selection];
					}
					else
					{
						copyRange.location = NSMaxRange(startRange);
						copyRange.length = stopRange.location - copyRange.location;
						if(copyRange.length)
						{
							copyString = [macro substringWithRange:copyRange];
							[replacementString appendString:copyString];
						}
					}
					[replacementString appendString:@"__END_OF_CONTENT__\n__END_OF_INPUT__\n"];
					[replacementString appendString:@"INPUT_SELECTION.gsub!(/(.*)__END_OF_CONTENT__.*/m,'\\1')"];
				}
				else if([startType isEqual:@"RUBY_INPUT_LINE"])
				{
					RUBY = YES;
					[replacementString appendString:@"INPUT_LINE = <<'__END_OF_INPUT__'\n"];
					if([line length])
					{
						[replacementString appendString:line];
					}
					else
					{
						copyRange.location = NSMaxRange(startRange);
						copyRange.length = stopRange.location - copyRange.location;
						if(copyRange.length)
						{
							copyString = [macro substringWithRange:copyRange];
							[replacementString appendString:copyString];
						}
					}
					[replacementString appendString:@"__END_OF_CONTENT__\n__END_OF_INPUT__\n"];
					[replacementString appendString:@"INPUT_LINE.gsub!(/(.*)__END_OF_CONTENT__.*/m,'\\1')"];
				}
				else if([startType isEqual:@"RUBY_INPUT_ALL"])
				{
					RUBY = YES;
					[replacementString appendString:@"INPUT_ALL= <<'__END_OF_INPUT__'\n"];
					if([all length])
					{
						[replacementString appendString:all];
					}
					else
					{
						copyRange.location = NSMaxRange(startRange);
						copyRange.length = stopRange.location - copyRange.location;
						if(copyRange.length)
						{
							copyString = [macro substringWithRange:copyRange];
							//copyString = [copyString stringByEscapingPerlControlCharacters];
							[replacementString appendString:copyString];
						}
					}
					[replacementString appendString:@"__END_OF_CONTENT__\n__END_OF_INPUT__\n"];
					[replacementString appendString:@"INPUT_ALL.gsub!(/(.*)__END_OF_CONTENT__.*/m,'\\1')"];
				}
				else if([startType isEqual:@"RUBY_INPUT_PATH"])
				{
					RUBY = YES;
					[replacementString appendString:@"INPUT_PATH= <<'__END_OF_INPUT__'\n"];
					if([path length])
					{
						[replacementString appendString:path];
					}
					else
					{
						copyRange.location = NSMaxRange(startRange);
						copyRange.length = stopRange.location - copyRange.location;
						if(copyRange.length)
						{
							copyString = [macro substringWithRange:copyRange];
							copyString = [copyString stringByEscapingPerlControlCharacters];
							[replacementString appendString:copyString];
						}
					}
					[replacementString appendString:@"__END_OF_CONTENT__\n__END_OF_INPUT__\n"];
					[replacementString appendString:@"INPUT_PATH.gsub!(&/(.*)__END_OF_CONTENT__.*/m,'\\1')"];
				}
				else if([startType isEqual:@"ALL"])
				{
					if([all length])
					{
						[replacementString appendString:@"@@@("];
						[replacementString appendString:all];
						[replacementString appendString:@")@@@"];
					}
					else
					{
						copyRange.location = NSMaxRange(startRange);
						copyRange.length = stopRange.location - copyRange.location;
						if(copyRange.length)
						{
							[replacementString appendString:@"@@@("];
							copyString = [macro substringWithRange:copyRange];
							[replacementString appendString:copyString];
							[replacementString appendString:@")@@@"];
						}
					}
				}
				else if([startType isEqual:@"INPUT_ALL"])
				{
					if([all length])
					{
						[replacementString appendString:all];
					}
					else
					{
						copyRange.location = NSMaxRange(startRange);
						copyRange.length = stopRange.location - copyRange.location;
						if(copyRange.length)
						{
							copyString = [macro substringWithRange:copyRange];
							[replacementString appendString:copyString];
						}
					}
				}
				else if([startType isEqual:@"INPUT_PATH"])
				{
					if([path length])
					{
						[replacementString appendString:path];
					}
					else
					{
						copyRange.location = NSMaxRange(startRange);
						copyRange.length = stopRange.location - copyRange.location;
						if(copyRange.length)
						{
							copyString = [macro substringWithRange:copyRange];
							[replacementString appendString:copyString];
						}
					}
				}
				else if([startType isEqual:@"PERL_REPLACE_ALL"])
				{
					PERL = YES;
					[replacementString appendString:@"print \"@@@(REPLACE_ALL:$INPUT_ALL)@@@\";\n"];
				}
				else if([startType isEqual:@"PERL_REPLACE_SELECTION"])
				{
					PERL = YES;
					[replacementString appendString:@"print \"@@@(REPLACE_SELECTION:$INPUT_SELECTION)@@@\";\n"];
				}
				else if([startType isEqual:@"PERL_REPLACE_LINE"])
				{
					PERL = YES;
					[replacementString appendString:@"print \"@@@(REPLACE_SELECTION:$INPUT_LINE)@@@\";\n"];
				}
				else if([startType isEqual:@"RUBY_REPLACE_ALL"])
				{
					RUBY = YES;
					[replacementString appendString:@"puts \"@@@(REPLACE_ALL:#{INPUT_ALL})@@@\"\n"];
				}
				else if([startType isEqual:@"RUBY_REPLACE_SELECTION"])
				{
					RUBY = YES;
					[replacementString appendString:@"puts \"@@@(REPLACE_SELECTION:#{INPUT_SELECTION})@@@\""];
				}
				else if([startType isEqual:@"RUBY_REPLACE_LINE"])
				{
					RUBY = YES;
					[replacementString appendString:@"puts \"@@@(REPLACE_LINE:#{INPUT_LINE})@@@\";\n"];
				}
				#if 0
				else if([startType isEqual:@"COMMAND"])// unused
				{
					if([selection length])
					{
						[replacementString appendString:@"@@@("];
						[replacementString appendString:selection];
						[replacementString appendString:@")@@@"];
					}
					else
					{
						copyRange.location = NSMaxRange(startRange);
						copyRange.length = stopRange.location - copyRange.location;
						if(copyRange.length)
						{
							[replacementString appendString:@"@@@("];
							copyString = [macro substringWithRange:copyRange];
							[replacementString appendString:copyString];
							[replacementString appendString:@")@@@"];
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
				copyRange.location = NSMaxRange(stopRange);
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
				copyRange.location = NSMaxRange(stopRange);
				goto nextStopRange;
			}
		}
		else
		{
			copyRange = startRange;
			copyRange.length = [macro length] - startRange.location;
			copyString = [macro substringWithRange:copyRange];
			[replacementString appendString:copyString];
		}
	}
	else
	{
		copyRange.length = [macro length] - copyRange.location;
		copyString = [macro substringWithRange:copyRange];
		[replacementString appendString:copyString];
	}
	// manage the indentation
	if(PERL)
	{
		if(![replacementString hasPrefix:@"#!/usr/bin/env perl"]
			&& ![replacementString hasPrefix:@"#!/usr/bin/perl"])
		{
			[replacementString insertString:@"#!/usr/bin/env perl -w\n" atIndex:0];
		}
	}
	else if(RUBY)
	{
		if(![replacementString hasPrefix:@"#!/usr/bin/env ruby"]
			&& ![replacementString hasPrefix:@"#!/usr/bin/ruby"])
		{
			[replacementString insertString:@"#!/usr/bin/env ruby\n" atIndex:0];
		}
	}
//iTM2_END;
	return replacementString;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  replacementStringForMacro:selection:line:
- (NSString *)replacementStringForMacro:(NSString *)macro selection:(NSString *)selection line:(NSString *)line;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net (1.0.10)
- 1.2: 06/24/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * replacementString = nil;
	NSString * category = [self macroCategory];
	if([category length])
	{
		NSString * action = [NSString stringWithFormat:@"concreteReplacementStringFor%@Macro:selection:line:",category];
		SEL selector = NSSelectorFromString(action);
		NSMethodSignature * MS = [self methodSignatureForSelector:selector];
		SEL mySelector = @selector(concreteReplacementStringForMacro:selection:line:);
		NSMethodSignature * myMS = [self methodSignatureForSelector:mySelector];
		if(![MS isEqual:myMS])
		{
			MS = myMS;
			selector = mySelector;
		}
		NSInvocation * I = [NSInvocation invocationWithMethodSignature:MS];
		[I setTarget:self];
		[I setArgument:&macro atIndex:2];
		[I setArgument:&selection atIndex:3];
		[I setArgument:&line atIndex:4];
		[I setSelector:selector];
		NS_DURING
		[I invoke];
		[I getReturnValue:&replacementString];
		NS_HANDLER
		iTM2_LOG(@"EXCEPTION Catched: %@", localException);
		replacementString = @"";
		NS_ENDHANDLER
	}
	else
	{
		replacementString = [self concreteReplacementStringForMacro:macro selection:selection line:line];
	}
//iTM2_END;
    return replacementString;
}
@end
