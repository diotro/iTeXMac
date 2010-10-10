/*
//  iTM2TextScriptingKit.m
//  iTeXMac2
//
//  Created by jlaurens@users.sourceforge.net on Thu Jun 06 2002.
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

#import "iTM2TextScriptingKit.h"
#import "iTM2MacroKit.h"


//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  iTM2FindScriptCommand
/*"Description forthcoming."*/
@implementation iTM2FindScriptCommand
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  performDefaultImplementation
- (id) performDefaultImplementation;
/*"Description forthcoming.
Version history: jlaurens@users.sourceforge.net
- 1.1.8: 06/06/2002
To Do List:
"*/
{
    NSTextStorage * target = (NSTextStorage *)self.findTarget;
    NSString * S = self.findString;
    if ([target isKindOfClass: [NSTextStorage class]] && S.length)
    {
		NSTextView * TV = [target mainTextView];
		iTM2TextFinder * TF = [[[iTM2TextFinder alloc] initWithTextView: ] autorelease];
        [TF setMute: YES];
        [TF setFindString: S];
        [TF setCaseInsensitiveFlag: self.caseInsensitiveFlag];
        [TF setWrapFlag: self.cycleFlag];
        if (self.backwardsFlag)
        {
            if (findRangeValue)
                [target setSelectedRange: iTM3MakeRange(iTM3MaxRange([findRangeValue rangeValue]), 0)];
            [TF findPrevious: nil];
        }
        else
        {
            if (findRangeValue)
                [target setSelectedRange: iTM3MakeRange([findRangeValue rangeValue].location, 0)];
            [TF findNext: nil];
        }
        return [NSNumber numberWithBool: [TF lastFindWasSuccessful]];
    }
    else
        return [NSNumber numberWithBool: NO];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  backwardsFlag
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  caseInsensitiveFlag
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  cycleFlag
#define NEWFLAG(sel, key, default)\
- (BOOL) sel;{id O = [self.evaluatedArguments objectForKey: key]; return O? [O boolValue]: default;}
/*"Description forthcoming.
Version history: jlaurens@users.sourceforge.net
- 1.1.8: 06/06/2002
To Do List:
"*/
NEWFLAG(backwardsFlag, @"Backwards", NO);
NEWFLAG(caseInsensitiveFlag, @"CaseInsensitive", NO);
NEWFLAG(cycleFlag, @"Cycle", NO);
#undef NEWFLAG
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  findRangeValue
- (id) findRangeValue;
/*"Lazy initializer. Asks for the receiver's find target (if it is not already fixed) to use its side effect.
Version history: jlaurens@users.sourceforge.net
- 1.1.8: 06/06/2002
To Do List:
"*/
{
    if (findRangeValue)
        return findRangeValue;
    else
    {
        if (!findTarget)
            self.findTarget;
        return findRangeValue;
    }
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  findTarget
- (id) findTarget;
/*"Lazy initializer. This fixes as side effect the range where things are to be inserted.
Version history: jlaurens@users.sourceforge.net
- 1.1.8: 06/06/2002
To Do List:
"*/
{
    if (findTarget)
        return findTarget;
    else
    {
        id O = [self.arguments objectForKey: @"In"];
        if ([O isKindOfClass: [NSRangeSpecifier class]])
        {
            id container = [[O containerSpecifier] objectsByEvaluatingSpecifier];
            if ([container isKindOfClass: [NSTextStorage class]])
            {
                if ([[O key] isEqualToString: @"characters"])
                {
                    [findRangeValue autorelease];
                    findRangeValue = [[NSValue valueWithRange: [O evaluatedRange]] retain];
                    return findTarget = [container retain];
                }
                else
                {
                    [self setScriptErrorNumber: 1];
                    [self setScriptErrorString:
                        [NSString stringWithFormat: @"iTeXMac2 only supports characters, not %@.", [O key]]];
                    return findTarget;
                }
            }
            else
            {
                [self setScriptErrorNumber: 2];
                [self setScriptErrorString: [NSString stringWithFormat: @"Text container expected for range specifier."]];
                return findTarget;
            }
        }        
        else if ([O isKindOfClass: [NSIndexSpecifier class]])
        {
            id container = [[O containerSpecifier] objectsByEvaluatingSpecifier];
            if ([container isKindOfClass: [NSTextStorage class]])
            {
                if ([[O key] isEqualToString: @"characters"])
                {
                    NSUInteger length = [(NSString *)container length];
                    NSUInteger index = MIN([O index], length);
                    NSRange R;
                    if (self.backwardsFlag)
                    {
                        R.location = 0;
                        R.length = index;
                    }
                    else
                    {
                        R.location = index;
                        R.length = length - R.location;
                    }
                    [findRangeValue autorelease];
                    findRangeValue = [[NSValue valueWithRange: R] retain];
                    return findTarget = [container retain];
                }
                else
                {
                    [self setScriptErrorNumber: 1];
                    [self setScriptErrorString:
                        [NSString stringWithFormat: @"iTeXMac2 only supports characters, not %@.", [O key]]];
                    return findTarget;
                }
            }
            else
            {
                [self setScriptErrorNumber: 4];
                [self setScriptErrorString:
                    [NSString stringWithFormat: @"Text reference expected in location argument, got a %@ instance %@.",
                        NSStringFromClass([container class]), container]];
                return findTarget;
            }
        }
        else if ([O isKindOfClass: [NSPositionalSpecifier class]])
        {
            if ([[O insertionKey] isEqualToString: @"characters"])
            {
                id container = [O insertionContainer];
                if ([container isKindOfClass: [NSTextStorage class]])
                {
                    [findRangeValue autorelease];
                    findRangeValue = [[NSValue valueWithRange: iTM3MakeRange([O insertionIndex], 0)] retain];
                    return findTarget = [container retain];
                }
                else
                {
                    [self setScriptErrorNumber: 4];
                    [self setScriptErrorString:
                        [NSString stringWithFormat: @"Text reference expected in location argument, got a %@ instance %@.",
                            NSStringFromClass([container class]), container]];
                    return findTarget;
                }
            }
            else
            {
                [self setScriptErrorNumber: 3];
                [self setScriptErrorString:
                    [NSString stringWithFormat: @"iTeXMac2 only supports characters, not %@.", [O insertionKey]]];
                return findTarget;
            }
        }
        else
        {
            O = [O objectsByEvaluatingSpecifier];
            if ([O isKindOfClass: [NSTextStorage class]])
            {
                if ([self.arguments objectForKey: @"AtLocation"] || [self.arguments objectForKey: @"InRange"])
                {
                    [self setScriptErrorNumber: 4];
                    [self setScriptErrorString: [NSString stringWithFormat: @"No location nor range argument with a text argument."]];
                    return findTarget;
                }
                else
                    return findTarget = [O retain];
            }
            else if (O)
            {
                [self setScriptErrorNumber: 5];
                [self setScriptErrorString:
            [NSString stringWithFormat: @"Text argument must be a reference to a text storage, got a %@ instance %@",
        NSStringFromClass([O class]), O]];
                return findTarget;
            }
            else
            {
                [self setScriptErrorNumber: 5];
                [self setScriptErrorString: [NSString stringWithFormat: @"Text argument missing"]];
                return findTarget;
            }
        }
    }
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  findString
- (id) findString;
/*"Description forthcoming.
Version history: jlaurens@users.sourceforge.net
- 1.1.8: 06/06/2002
To Do List:
"*/
{
    if (findString)
        return findString;
    else
    {
        id O = self.directParameter;
        if ([O isKindOfClass: [NSPositionalSpecifier class]])
        {
            if ([[O insertionKey] isEqualToString: @"characters"])
            {
                id container = [O insertionContainer];
                if ([container isKindOfClass: [NSTextStorage class]])
                {
                    return findString =
                        [[[container string] substringWithRange: iTM3MakeRange([O insertionIndex], 1)] retain];
                }
                else
                {
                    [self setScriptErrorNumber: 4];
                    [self setScriptErrorString:
                        [NSString stringWithFormat: @"Text reference expected in location argument, got a %@ instance %@.",
                            NSStringFromClass([container class]), container]];
                    return findString;
                }
            }
            else
            {
                [self setScriptErrorNumber: 3];
                [self setScriptErrorString:
                    [NSString stringWithFormat: @"iTeXMac2 only supports characters, not %@.", [O insertionKey]]];
                return findString;
            }
        }
        else if ([O isKindOfClass: [NSRangeSpecifier class]])
        {
            if ([[O key] isEqualToString: @"characters"])
            {
                id container = [[O containerSpecifier] objectsByEvaluatingSpecifier];
                if ([container isKindOfClass: [NSTextStorage class]])
                {
                    return findString = [[[container string] substringWithRange: [O evaluatedRange]] retain];
                }
                else
                {
                    [self setScriptErrorNumber: 7];
                    [self setScriptErrorString: [NSString stringWithFormat: @"Reference to a text storage expected"]];
                    return findString;
                }
            }
            else
            {
                [self setScriptErrorNumber: 8];
                [self setScriptErrorString: [NSString stringWithFormat: @"characters expected, found %@", [O key]]];
                return findString;
            }
        }
        else if ([O isKindOfClass: [NSScriptObjectSpecifier class]])
            O = [O objectsByEvaluatingSpecifier];
        if ([O isKindOfClass: [NSString class]])
            return findString = [O retain];
        else if ([O isKindOfClass: [NSAttributedString class]])
            return findString = [[O string] retain];
        else
        {
            [self setScriptErrorNumber: 8];
            [self setScriptErrorString: [NSString stringWithFormat: @"Only text receivers.", [O key]]];
            return findString;
        }
    }
}
/*
- (void)setScriptErrorNumber:(NSInteger)num
- (void)setScriptErrorString:(NSString *)str
*/
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  iTM2InsertScriptCommand
/*"Description forthcoming."*/
@implementation iTM2InsertScriptCommand
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  performDefaultImplementation
- (id) performDefaultImplementation;
/*"Description forthcoming.
Version history: jlaurens@users.sourceforge.net
- 1.1.8: 06/06/2002
To Do List:
"*/
{
//START4iTM3;
    // arguments are tagged optional, but one of them must be provided
    [self.insertionTarget insertText: self.insertionString inRangeValue: self.insertionRangeValue];
    return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  insertionRangeValue
- (id) insertionRangeValue;
/*"Lazy initializer. Asks for the receiver's insertion target (if it is not already fixed) to use its side effect.
Version history: jlaurens@users.sourceforge.net
- 1.1.8: 06/06/2002
To Do List:
"*/
{
//START4iTM3;
    if (!insertionRangeValue && !insertionTarget)
        self.insertionTarget;
    return insertionRangeValue;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  insertionTarget
- (id) insertionTarget;
/*"Lazy initializer. This fixes as side effect the range where things are to be inserted.
Version history: jlaurens@users.sourceforge.net
- 1.1.8: 06/06/2002
To Do List:
"*/
{
//START4iTM3;
    if (insertionTarget)
        return insertionTarget;
    else
    {
        id O = [self.evaluatedArguments objectForKey: @"InText"];
        if ([O isKindOfClass: [NSTextStorage class]])
        {
            if ([self.arguments objectForKey: @"AtLocation"] || [self.arguments objectForKey: @"InRange"])
            {
                [self setScriptErrorNumber: 4];
                [self setScriptErrorString: [NSString stringWithFormat: @"No location nor range argument with a text argument."]];
                return insertionTarget = nil;
            }
            else
                return insertionTarget = [O retain];
        }
        else if (O)
        {
            [self setScriptErrorNumber: 5];
            [self setScriptErrorString: [NSString stringWithFormat: @"Text argument must be a reference to a text storage"]];
            return insertionTarget = nil;
        }
        O = [self.arguments objectForKey: @"AtLocation"];
        if ([O isKindOfClass: [NSPositionalSpecifier class]])
        {
            if ([[O insertionKey] isEqualToString: @"characters"])
            {
                id container = [O insertionContainer];
                if ([container isKindOfClass: [NSTextStorage class]])
                {
                    if ([self.arguments objectForKey: @"InRange"])
                    {
                        [self setScriptErrorNumber: 3];
                        [self setScriptErrorString: [NSString stringWithFormat: @"No text nor range argument with a location argument."]];
                        return insertionTarget = nil;
                    }
                    else
                    {
                        [insertionRangeValue autorelease];
                        insertionRangeValue = [[NSValue valueWithRange: iTM3MakeRange([O insertionIndex], 0)] retain];
                        return insertionTarget = [container retain];
                    }
                }
                else
                {
                    [self setScriptErrorNumber: 4];
                    [self setScriptErrorString: [NSString stringWithFormat: @"Text reference expected in location argument, got %@.", container]];
                    return insertionTarget = nil;
                }
            }
            else
            {
                [self setScriptErrorNumber: 3];
                [self setScriptErrorString: [NSString stringWithFormat: @"Characters attribute expected in location argument, got %@.", [O insertionKey]]];
                return insertionTarget = nil;
            }
        }
        else if (O)
        {
            [self setScriptErrorNumber: 5];
            [self setScriptErrorString: [NSString stringWithFormat: @"Location reference expected for location argument."]];
            return insertionTarget = nil;
        }
        O = [self.arguments objectForKey: @"InRange"];
        if ([O isKindOfClass: [NSRangeSpecifier class]])
        {
            id container = [[O containerSpecifier] objectsByEvaluatingSpecifier];
            if ([container isKindOfClass: [NSTextStorage class]])
            {
                [insertionRangeValue autorelease];
                insertionRangeValue = [[NSValue valueWithRange: [O evaluatedRange]] retain];
                return insertionTarget = [container retain];
            }
            else
            {
                [self setScriptErrorNumber: 5];
                [self setScriptErrorString: [NSString stringWithFormat: @"Text container reference expected in range argument."]];
                return insertionTarget = nil;
            }
        }
        else if (O)
        {
            [self setScriptErrorNumber: 6];
            [self setScriptErrorString: [NSString stringWithFormat: @"Range reference expected for range argument."]];
            return insertionTarget = nil;
        }
        [self setScriptErrorNumber: 6];
        [self setScriptErrorString: [NSString stringWithFormat: @"Text, location ar range argument expected."]];
        return insertionTarget = nil;
    }
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  insertionString
- (id) insertionString;
/*"Description forthcoming.
Version history: jlaurens@users.sourceforge.net
- 1.1.8: 06/06/2002
To Do List:
"*/
{
//START4iTM3;
    id O = self.directParameter;
    if ([O isKindOfClass: [NSRangeSpecifier class]])
    {
        if ([[O key] isEqualToString: @"characters"])
        {
             id container = [[O containerSpecifier] objectsByEvaluatingSpecifier];
            if ([container isKindOfClass: [NSTextStorage class]])
            {
                return [[container string] substringWithRange: [O evaluatedRange]];
            }
            else
            {
                [self setScriptErrorNumber: 7];
                [self setScriptErrorString: [NSString stringWithFormat: @"Reference to a text storage expected"]];
                return nil;
            }
        }
        else
        {
            [self setScriptErrorNumber: 8];
            [self setScriptErrorString: [NSString stringWithFormat: @"characters expected, found %@", [O key]]];
            return nil;
        }
    }
    else if ([O isKindOfClass: [NSScriptObjectSpecifier class]])
        O = [O objectsByEvaluatingSpecifier];
//NSLog(@"insertionString %@, %@", O, NSStringFromClass([O class]));
    if ([O isKindOfClass: [NSString class]])
        return O;
    else if ([O isKindOfClass: [NSAttributedString class]])
        return [O string];
    else
    {
        [self setScriptErrorNumber: 8];
        [self setScriptErrorString: [NSString stringWithFormat: @"Only text receivers.", [O key]]];
        return nil;
    }
}
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  iTM2InsertMacroScriptCommand
/*"Description forthcoming."*/
@implementation iTM2InsertMacroScriptCommand
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  performDefaultImplementation
- (id) performDefaultImplementation;
/*"Description forthcoming.
Version history: jlaurens@users.sourceforge.net
- 1.1.8: 06/06/2002
To Do List:
"*/
{
//START4iTM3;
    // arguments are tagged optional, but one of them must be provided
    NSString * before = self.insertionString;
    NSString * selected = self.insertionSelected;
    NSString * after = self.insertionAfter;

//NSLog(@"before: <%@>", before);
//NSLog(@"selected: <%@>", selected);
//NSLog(@"after: <%@>", after);

    NSMutableDictionary * MD = [NSMutableDictionary dictionary];

//NSLog(@"%@ %#x IS DONE 1", __iTM2_PRETTY_FUNCTION__, self);
    if (before)
        [MD setObject: before forKey: @"before"];
//NSLog(@"%@ %#x IS DONE 2", __iTM2_PRETTY_FUNCTION__, self);
    if (selected)
        [MD setObject: selected forKey: @"selected"];
//NSLog(@"%@ %#x IS DONE 3", __iTM2_PRETTY_FUNCTION__, self);
    if (after)
        [MD setObject: after forKey: @"after"];
//NSLog(@"%@ %#x IS DONE 4", __iTM2_PRETTY_FUNCTION__, self);
    if (MD.count)
        [self.insertionTarget insertMacro4iTM3: MD inRange: [self.insertionRangeValue rangeValue]];
//NSLog(@"%@ %#x IS DONE", __iTM2_PRETTY_FUNCTION__, self);
    return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  insertionSelected
- (id) insertionSelected;
/*"Description forthcoming.
Version history: jlaurens@users.sourceforge.net
- 1.1.8: 06/06/2002
To Do List:
"*/
{
//START4iTM3;
    id O = [self.arguments objectForKey: @"Selected"];
    if ([O isKindOfClass: [NSRangeSpecifier class]])
    {
        if ([[O key] isEqualToString: @"characters"])
        {
             id container = [[O containerSpecifier] objectsByEvaluatingSpecifier];
            if ([container isKindOfClass: [NSTextStorage class]])
            {
                return [[container string] substringWithRange: [O evaluatedRange]];
            }
            else
            {
                [self setScriptErrorNumber: 10];
                [self setScriptErrorString: [NSString stringWithFormat: @"Reference to a text storage expected"]];
                return nil;
            }
        }
        else
        {
            [self setScriptErrorNumber: 11];
            [self setScriptErrorString: [NSString stringWithFormat: @"characters expected, found %@", [O key]]];
            return nil;
        }
    }
    else if ([O isKindOfClass: [NSScriptObjectSpecifier class]])
        O = [O objectsByEvaluatingSpecifier];
//NSLog(@"insertionString %@, %@", O, NSStringFromClass([O class]));
    if ([O isKindOfClass: [NSString class]])
        return O;
    else if ([O isKindOfClass: [NSAttributedString class]])
        return [O string];
    else if (O)
    {
        [self setScriptErrorNumber: 12];
        [self setScriptErrorString: [NSString stringWithFormat: @"Only text please.", [O key]]];
    }
    return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  insertionAfter
- (id) insertionAfter;
/*"Description forthcoming.
Version history: jlaurens@users.sourceforge.net
- 1.1.8: 06/06/2002
To Do List:
"*/
{
//START4iTM3;
    id O = [self.arguments objectForKey: @"After"];
    if ([O isKindOfClass: [NSRangeSpecifier class]])
    {
        if ([[O key] isEqualToString: @"characters"])
        {
             id container = [[O containerSpecifier] objectsByEvaluatingSpecifier];
            if ([container isKindOfClass: [NSTextStorage class]])
            {
                return [[container string] substringWithRange: [O evaluatedRange]];
            }
            else
            {
                [self setScriptErrorNumber: 13];
                [self setScriptErrorString: [NSString stringWithFormat: @"Reference to a text storage expected"]];
                return nil;
            }
        }
        else
        {
            [self setScriptErrorNumber: 14];
            [self setScriptErrorString: [NSString stringWithFormat: @"characters expected, found %@", [O key]]];
            return nil;
        }
    }
    else if ([O isKindOfClass: [NSScriptObjectSpecifier class]])
        O = [O objectsByEvaluatingSpecifier];
//NSLog(@"insertionString %@, %@", O, NSStringFromClass([O class]));
    if ([O isKindOfClass: [NSString class]])
        return O;
    else if ([O isKindOfClass: [NSAttributedString class]])
        return [O string];
    else if (O)
    {
        [self setScriptErrorNumber: 15];
        [self setScriptErrorString: [NSString stringWithFormat: @"Only text please.", [O key]]];
    }
    return nil;
}
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  iTM2ReplaceScriptCommand
/*"Description forthcoming."*/
@implementation iTM2ReplaceScriptCommand
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  performDefaultImplementation
- (id) performDefaultImplementation;
/*"Description forthcoming.
Version history: jlaurens@users.sourceforge.net
version: 1.1 (06/08/2002)
To Do List:
"*/
{
    id target = self.findTarget;
    NSString * S = self.findString;
    if ([target isKindOfClass: [NSTextStorage class]] && S.length)
    {
	iTM2TextFinder * TF = [[[iTM2TextFinder alloc] initWithTextView: [target mainTextView]] autorelease];
        [TF setMute: YES];
        [TF setFindString: S];
        [TF setReplaceString: self.replaceString];
        [TF setCaseInsensitiveFlag: self.caseInsensitiveFlag];
        [TF setWrapFlag: self.cycleFlag];
        [TF setEntireFileFlag: self.entireFileFlag];
        if (self.changeAllFlag)
        {
            if (findRangeValue)
                [target setSelectedRange: iTM3MakeRange(iTM3MaxRange([findRangeValue rangeValue]), 0)];
            [TF replaceAll: nil];
            return [NSNumber numberWithInteger: [TF numberOfOps]];
        }
        else if (self.backwardsFlag)
        {
            if (findRangeValue)
                [target setSelectedRange: iTM3MakeRange(iTM3MaxRange([findRangeValue rangeValue]), 0)];
            [TF findPrevious: nil];
        }
        else
        {
            if (findRangeValue)
                [target setSelectedRange: iTM3MakeRange([findRangeValue rangeValue].location, 0)];
            [TF findNext: nil];
        }
        if ([TF lastFindWasSuccessful])
            [TF replace: nil];
        return [NSNumber numberWithInteger: ([TF lastFindWasSuccessful]? 1: 0)];
    }
    else
        return [NSNumber numberWithInteger: 0];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  backwardsFlag
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  caseInsensitiveFlag
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  cycleFlag
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  changeAllFlag
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  entireFileFlag
#define NEWFLAG(sel, key, default)\
- (BOOL) sel;{id O = [self.evaluatedArguments objectForKey: key]; return O? [O boolValue]: default;}
/*"Description forthcoming.
Version history: jlaurens@users.sourceforge.net
version: 1.1 (06/08/2002)
To Do List:
"*/
NEWFLAG(backwardsFlag, @"Backwards", NO);
NEWFLAG(caseInsensitiveFlag, @"CaseInsensitive", NO);
NEWFLAG(cycleFlag, @"Cycle", NO);
NEWFLAG(changeAllFlag, @"ChangeAll", NO);
NEWFLAG(entireFileFlag, @"EntireFile", YES);
#undef NEWFLAG
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  findRangeValue
- (id) findRangeValue;
/*"Lazy initializer. Asks for the receiver's find target (if it is not already fixed) to use its side effect.
Version history: jlaurens@users.sourceforge.net
version: 1.1 (06/08/2002)
To Do List:
"*/
{
    if (findRangeValue)
        return findRangeValue;
    else
    {
        if (!findTarget)
            self.findTarget;
        return findRangeValue;
    }
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  findTarget
- (id) findTarget;
/*"Lazy initializer. This fixes as side effect the range where things are to be inserted.
Version history: jlaurens@users.sourceforge.net
version: 1.1 (06/08/2002)
To Do List:
"*/
{
    if (findTarget)
        return findTarget;
    else
    {
        id O = [self.arguments objectForKey: @"In"];
        if ([O isKindOfClass: [NSRangeSpecifier class]])
        {
            id container = [[O containerSpecifier] objectsByEvaluatingSpecifier];
            if ([container isKindOfClass: [NSTextStorage class]])
            {
                if ([[O key] isEqualToString: @"characters"])
                {
                    [findRangeValue autorelease];
                    findRangeValue = [[NSValue valueWithRange: [O evaluatedRange]] retain];
                    return findTarget = [container retain];
                }
                else
                {
                    [self setScriptErrorNumber: 1];
                    [self setScriptErrorString:
                        [NSString stringWithFormat: @"iTeXMac2 only supports characters, not %@.", [O key]]];
                    return findTarget;
                }
            }
            else
            {
                [self setScriptErrorNumber: 2];
                [self setScriptErrorString: [NSString stringWithFormat: @"Text container expected for range specifier."]];
                return findTarget;
            }
        }        
        else if ([O isKindOfClass: [NSIndexSpecifier class]])
        {
            id container = [[O containerSpecifier] objectsByEvaluatingSpecifier];
            if ([container isKindOfClass: [NSTextStorage class]])
            {
                if ([[O key] isEqualToString: @"characters"])
                {
                    NSUInteger length = [(NSString *)container length];
                    NSUInteger index = MIN([O index], length);
                    NSRange R;
                    if (self.backwardsFlag)
                    {
                        R.location = 0;
                        R.length = index;
                    }
                    else
                    {
                        R.location = index;
                        R.length = length - R.location;
                    }
                    [findRangeValue autorelease];
                    findRangeValue = [[NSValue valueWithRange: R] retain];
                    return findTarget = [container retain];
                }
                else
                {
                    [self setScriptErrorNumber: 1];
                    [self setScriptErrorString:
                        [NSString stringWithFormat: @"iTeXMac2 only supports characters, not %@.", [O key]]];
                    return findTarget;
                }
            }
            else
            {
                [self setScriptErrorNumber: 4];
                [self setScriptErrorString:
                    [NSString stringWithFormat: @"Text reference expected in location argument, got a %@ instance %@.",
                        NSStringFromClass([container class]), container]];
                return findTarget;
            }
        }
        else if ([O isKindOfClass: [NSPositionalSpecifier class]])
        {
            if ([(NSString *)[O insertionKey] isEqualToString: @"characters"])
            {
                id container = [O insertionContainer];
                if ([container isKindOfClass: [NSTextStorage class]])
                {
                    [findRangeValue autorelease];
                    findRangeValue = [[NSValue valueWithRange: iTM3MakeRange([O insertionIndex], 0)] retain];
                    return findTarget = [container retain];
                }
                else
                {
                    [self setScriptErrorNumber: 4];
                    [self setScriptErrorString:
                        [NSString stringWithFormat: @"Text reference expected in location argument, got a %@ instance %@.",
                            NSStringFromClass([container class]), container]];
                    return findTarget;
                }
            }
            else
            {
                [self setScriptErrorNumber: 3];
                [self setScriptErrorString:
                    [NSString stringWithFormat: @"iTeXMac2 only supports characters, not %@.", [O insertionKey]]];
                return findTarget;
            }
        }
        else
        {
            O = [O objectsByEvaluatingSpecifier];
            if ([O isKindOfClass: [NSTextStorage class]])
            {
                if ([self.arguments objectForKey: @"AtLocation"] || [self.arguments objectForKey: @"InRange"])
                {
                    [self setScriptErrorNumber: 4];
                    [self setScriptErrorString: [NSString stringWithFormat: @"No location nor range argument with a text argument."]];
                    return findTarget;
                }
                else
                    return findTarget = [O retain];
            }
            else if (O)
            {
                [self setScriptErrorNumber: 5];
                [self setScriptErrorString:
            [NSString stringWithFormat: @"Text argument must be a reference to a text storage, got a %@ instance %@",
        NSStringFromClass([O class]), O]];
                return findTarget;
            }
            else
            {
                [self setScriptErrorNumber: 5];
                [self setScriptErrorString: [NSString stringWithFormat: @"Text argument missing"]];
                return findTarget;
            }
        }
    }
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  findString
- (id) findString;
/*"Description forthcoming.
Version history: jlaurens@users.sourceforge.net
version: 1.1 (06/08/2002)
To Do List:
"*/
{
    if (findString)
        return findString;
    else
    {
        id O = self.directParameter;
        if ([O isKindOfClass: [NSPositionalSpecifier class]])
        {
            if ([[O insertionKey] isEqualToString: @"characters"])
            {
                id container = [O insertionContainer];
                if ([container isKindOfClass: [NSTextStorage class]])
                {
                    return findString =
                        [[[container string] substringWithRange: iTM3MakeRange([O insertionIndex], 1)] retain];
                }
                else
                {
                    [self setScriptErrorNumber: 4];
                    [self setScriptErrorString:
                        [NSString stringWithFormat: @"Text reference expected in location argument, got a %@ instance %@.",
                            NSStringFromClass([container class]), container]];
                    return findString;
                }
            }
            else
            {
                [self setScriptErrorNumber: 3];
                [self setScriptErrorString:
                    [NSString stringWithFormat: @"iTeXMac2 only supports characters, not %@.", [O insertionKey]]];
                return findString;
            }
        }
        else if ([O isKindOfClass: [NSRangeSpecifier class]])
        {
            if ([[O key] isEqualToString: @"characters"])
            {
                id container = [[O containerSpecifier] objectsByEvaluatingSpecifier];
                if ([container isKindOfClass: [NSTextStorage class]])
                {
                    return findString = [[[container string] substringWithRange: [O evaluatedRange]] retain];
                }
                else
                {
                    [self setScriptErrorNumber: 7];
                    [self setScriptErrorString: [NSString stringWithFormat: @"Reference to a text storage expected"]];
                    return findString;
                }
            }
            else
            {
                [self setScriptErrorNumber: 8];
                [self setScriptErrorString: [NSString stringWithFormat: @"characters expected, found %@", [O key]]];
                return findString;
            }
        }
        #if 0
        else if ([O isKindOfClass: [NSIndexSpecifier class]])
        {
            id container = [[O containerSpecifier] objectsByEvaluatingSpecifier];
            if ([container isKindOfClass: [NSTextStorage class]])
            {
                if ([[O key] isEqualToString: @"characters"])
                {
                    NSUInteger length = container.length;
                    NSUInteger index = MIN([O index], length);
                    NSRange R;
                    if (self.backwardsFlag)
                    {
                        R.location = 0;
                        R.length = index;
                    }
                    else
                    {
                        R.location = index;
                        R.length = length - R.location;
                    }
                    [findRangeValue autorelease];
                    findRangeValue = [[NSValue valueWithRange: R] retain];
                    return findString = [container retain];
                }
                else
                {
                    [self setScriptErrorNumber: 1];
                    [self setScriptErrorString:
                        [NSString stringWithFormat: @"iTeXMac2 only supports characters, not %@.", [O key]]];
                    return findString;
                }
            }
            else
            {
                [self setScriptErrorNumber: 4];
                [self setScriptErrorString:
                    [NSString stringWithFormat: @"Text reference expected in location argument, got a %@ instance %@.",
                        NSStringFromClass([container class]), container]];
                return findString;
            }
        }
        else if ([O isKindOfClass: [NSPositionalSpecifier class]])
        {
            if ([[O insertionKey] isEqualToString: @"characters"])
            {
                id container = [O insertionContainer];
                if ([container isKindOfClass: [NSTextStorage class]])
                {
                    [findRangeValue autorelease];
                    findRangeValue = [[NSValue valueWithRange: iTM3MakeRange([O insertionIndex], 0)] retain];
                    return findString = [container retain];
                }
                else
                {
                    [self setScriptErrorNumber: 4];
                    [self setScriptErrorString:
                        [NSString stringWithFormat: @"Text reference expected in location argument, got a %@ instance %@.",
                            NSStringFromClass([container class]), container]];
                    return findString;
                }
            }
            else
            {
                [self setScriptErrorNumber: 3];
                [self setScriptErrorString:
                    [NSString stringWithFormat: @"iTeXMac2 only supports characters, not %@.", [O insertionKey]]];
                return findString;
            }
        }
        #endif
        else if ([O isKindOfClass: [NSScriptObjectSpecifier class]])
            O = [O objectsByEvaluatingSpecifier];
        if ([O isKindOfClass: [NSString class]])
            return findString = [O retain];
        else if ([O isKindOfClass: [NSAttributedString class]])
            return findString = [[O string] retain];
        else
        {
            [self setScriptErrorNumber: 8];
            [self setScriptErrorString: [NSString stringWithFormat: @"Only text receivers.", [O key]]];
            return findString;
        }
    }
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  replaceString
- (id) replaceString;
/*"Description forthcoming.
Version history: jlaurens@users.sourceforge.net
version: 1.1 (06/08/2002)
To Do List:
"*/
{
    if (replaceString)
        return replaceString;
    else
    {
        id O = [self.arguments objectForKey: @"Replacement"];
        if ([O isKindOfClass: [NSPositionalSpecifier class]])
        {
            if ([[O insertionKey] isEqualToString: @"characters"])
            {
                id container = [O insertionContainer];
                if ([container isKindOfClass: [NSTextStorage class]])
                {
                    return replaceString =
                        [[[container string] substringWithRange: iTM3MakeRange([O insertionIndex], 1)] retain];
                }
                else
                {
                    [self setScriptErrorNumber: 4];
                    [self setScriptErrorString:
                        [NSString stringWithFormat: @"Text reference expected in location argument, got a %@ instance %@.",
                            NSStringFromClass([container class]), container]];
                    return replaceString;
                }
            }
            else
            {
                [self setScriptErrorNumber: 3];
                [self setScriptErrorString:
                    [NSString stringWithFormat: @"iTeXMac2 only supports characters, not %@.", [O insertionKey]]];
                return replaceString;
            }
        }
        else if ([O isKindOfClass: [NSRangeSpecifier class]])
        {
            if ([[O key] isEqualToString: @"characters"])
            {
                id container = [[O containerSpecifier] objectsByEvaluatingSpecifier];
                if ([container isKindOfClass: [NSTextStorage class]])
                {
                    return replaceString = [[[container string] substringWithRange: [O evaluatedRange]] retain];
                }
                else
                {
                    [self setScriptErrorNumber: 7];
                    [self setScriptErrorString: [NSString stringWithFormat: @"Reference to a text storage expected"]];
                    return replaceString;
                }
            }
            else
            {
                [self setScriptErrorNumber: 8];
                [self setScriptErrorString: [NSString stringWithFormat: @"characters expected, found %@", [O key]]];
                return replaceString;
            }
        }
        #if 0
        else if ([O isKindOfClass: [NSIndexSpecifier class]])
        {
            id container = [[O containerSpecifier] objectsByEvaluatingSpecifier];
            if ([container isKindOfClass: [NSTextStorage class]])
            {
                if ([[O key] isEqualToString: @"characters"])
                {
                    NSUInteger length = container.length;
                    NSUInteger index = MIN([O index], length);
                    NSRange R;
                    if (self.backwardsFlag)
                    {
                        R.location = 0;
                        R.length = index;
                    }
                    else
                    {
                        R.location = index;
                        R.length = length - R.location;
                    }
                    [findRangeValue autorelease];
                    findRangeValue = [[NSValue valueWithRange: R] retain];
                    return replaceString = [container retain];
                }
                else
                {
                    [self setScriptErrorNumber: 1];
                    [self setScriptErrorString:
                        [NSString stringWithFormat: @"iTeXMac2 only supports characters, not %@.", [O key]]];
                    return replaceString;
                }
            }
            else
            {
                [self setScriptErrorNumber: 4];
                [self setScriptErrorString:
                    [NSString stringWithFormat: @"Text reference expected in location argument, got a %@ instance %@.",
                        NSStringFromClass([container class]), container]];
                return replaceString;
            }
        }
        else if ([O isKindOfClass: [NSPositionalSpecifier class]])
        {
            if ([[O insertionKey] isEqualToString: @"characters"])
            {
                id container = [O insertionContainer];
                if ([container isKindOfClass: [NSTextStorage class]])
                {
                    [findRangeValue autorelease];
                    findRangeValue = [[NSValue valueWithRange: iTM3MakeRange([O insertionIndex], 0)] retain];
                    return replaceString = [container retain];
                }
                else
                {
                    [self setScriptErrorNumber: 4];
                    [self setScriptErrorString:
                        [NSString stringWithFormat: @"Text reference expected in location argument, got a %@ instance %@.",
                            NSStringFromClass([container class]), container]];
                    return replaceString;
                }
            }
            else
            {
                [self setScriptErrorNumber: 3];
                [self setScriptErrorString:
                    [NSString stringWithFormat: @"iTeXMac2 only supports characters, not %@.", [O insertionKey]]];
                return replaceString;
            }
        }
        #endif
        else if ([O isKindOfClass: [NSScriptObjectSpecifier class]])
            O = [O objectsByEvaluatingSpecifier];
        if ([O isKindOfClass: [NSString class]])
            return replaceString = [O retain];
        else if ([O isKindOfClass: [NSAttributedString class]])
            return replaceString = [[O string] retain];
        else
        {
            [self setScriptErrorNumber: 8];
            [self setScriptErrorString: [NSString stringWithFormat: @"Only text receivers.", [O key]]];
            return replaceString;
        }
    }
}
/*
- (void)setScriptErrorNumber:(NSInteger)num
- (void)setScriptErrorString:(NSString *)str
*/
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  iTM2SelectScriptCommand
/*"Description forthcoming."*/
@implementation iTM2SelectScriptCommand
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  performDefaultImplementation
- (id) performDefaultImplementation;
/*"Description forthcoming.
Version history: jlaurens@users.sourceforge.net
- 1.1.8: 06/06/2002
To Do List:
"*/
{
    id O = self.receiversSpecifier;
    if ([O isKindOfClass: [NSRangeSpecifier class]])
    {
        id container = [[O containerSpecifier] objectsByEvaluatingSpecifier];
        if ([container respondsToSelector: @selector(setSelectedRangeValue:)])
            [container setSelectedRangeValue: [NSValue valueWithRange: [O evaluatedRange]]];
        else
        {
            [self setScriptErrorNumber: 2];
            [self setScriptErrorString: [NSString stringWithFormat: @"Don't know how to select %@", O]];
        }
    }
    else if ([O isKindOfClass: [NSIndexSpecifier class]])
    {
        id container = [[O containerSpecifier] objectsByEvaluatingSpecifier];
        if ([container respondsToSelector: @selector(setSelectedRangeValue:)])
            [container setSelectedRangeValue: [NSValue valueWithRange: iTM3MakeRange([O evaluatedPosition], 1)]];
        else
        {
            [self setScriptErrorNumber: 2];
            [self setScriptErrorString: [NSString stringWithFormat: @"Don't know how to select %@", O]];
        }
    }
    else if ([O isKindOfClass: [NSPropertySpecifier class]])
    {
        O = [O objectsByEvaluatingSpecifier];
        if ([O respondsToSelector: @selector(setSelectedRangeValue:)] &&
                [O respondsToSelector: @selector(length)])
        {
            id PS = [self.evaluatedArguments objectForKey: @"AtLocation"];
            NSLog(@"NSPropertySpecifier AtLocation %@ %@", O, PS);
            #if 1
            if ([PS isKindOfClass: [NSPositionalSpecifier class]])
            {
                if ([[PS insertionKey] isEqualToString: @"characters"])
                    [O setSelectedRangeValue:
                        [NSValue valueWithRange: iTM3MakeRange(MIN([PS insertionIndex], (NSUInteger)[(NSString *)O length]), 0)]];
                else
                {
                    [self setScriptErrorNumber: 4];
                    [self setScriptErrorString:
                        [NSString stringWithFormat: @"Don't know how to select %@ in text", PS]];        
                }
            }
            else if (PS)
            {
                [self setScriptErrorNumber: 3];
                [self setScriptErrorString:
                    [NSString stringWithFormat: @"Positional Reference expected, got %@", PS]];        
            }
            else if ([O respondsToSelector: @selector(selectAll:)])
                [O selectAll: self];
        }
        else
        {
            [self setScriptErrorNumber: 2];
            [self setScriptErrorString: [NSString stringWithFormat: @"Don't know how to select %@", O]];
        }
        #endif
    }
    else
    {
        [self setScriptErrorNumber: 1];
        [self setScriptErrorString: [NSString stringWithFormat: @"Unexpected receiver: found %@", O]];
    }
    return nil;
}
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  NSObject(iTeXMac2)
/*"Description forthcoming."*/
@interface NSObject(iTM2TextScripting_PRIVATE)
- (NSUInteger)insertionIndex;
- (NSUInteger)index;
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  NSObject(iTeXMac2)
/*"Description forthcoming."*/
@implementation NSObject(iTM2TextScripting)
+ (Class)distantClass;
{
	return self;
}
- (Class)distantClass;
{
	LOG4iTM3(@"Returning %@", self.class);
	return self.class;
}
+ (bool)isDistantClass;
{
	return YES;
}
- (bool)isDistantClass;
{
	return NO;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  evaluatedPosition
- (NSUInteger)evaluatedPosition;
/*"Description forthcoming.
 Version history: jlaurens AT users DOT sourceforge DOT net
 To Do List:
 "*/
{DIAGNOSTIC4iTM3;
	//LOG4iTM3;
    if ([self respondsToSelector:@selector(insertionIndex)])
    {
        return self.insertionIndex;
    }
    else if ([self respondsToSelector:@selector(index)])
    {
        return self.index;
    }
    else if ([self respondsToSelector:@selector(integerValue)])
    {
        return [(NSNumber *)self integerValue];
    }
    else if ([self respondsToSelector:@selector(integerValue)])
    {
        return [(NSNumber *)self integerValue];
    }
    else
        return NSNotFound;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  evaluatedRange
- (NSRange)evaluatedRange;
/*"Description forthcoming.
 Version history: jlaurens AT users DOT sourceforge DOT net
 To Do List:
 "*/
{DIAGNOSTIC4iTM3;
	//LOG4iTM3;
    if ([self isKindOfClass:[NSRangeSpecifier class]])
    {
        NSUInteger start = [[(NSRangeSpecifier *)self startSpecifier] evaluatedPosition];
        NSUInteger end = [[(NSRangeSpecifier *)self endSpecifier] evaluatedPosition];
        return iTM3MakeRange(start, end - start);
    }
    else if ([self respondsToSelector:@selector(rangeValue)])
    {
        return [(NSValue *)self rangeValue];
    }
    else
        return iTM3MakeRange(NSNotFound, 0);
}
@end
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  NSObject(iTeXMac2)

@implementation NSTextStorage(TextScripting)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  firstTextView
- (NSTextView *)firstTextView;
/*"Scans the layout managers and their text containers for the first text view with a window.
 If none is found, returns the first text view if any.
 Version history: jlaurens AT users DOT sourceforge DOT net
 To Do List:
 "*/
{DIAGNOSTIC4iTM3;
	//START4iTM3;
    NSEnumerator * E = [self.layoutManagers objectEnumerator];
    NSLayoutManager * LM;
    NSTextView * cachedTV = nil;
    while(LM = E.nextObject)
    {
        NSEnumerator * EE = [[LM textContainers] objectEnumerator];
        NSTextContainer * TC;
        while(TC = EE.nextObject)
        {
            NSTextView * TV = [TC textView];
            if (TV.window)
                return TV;
            else if (!cachedTV)
                cachedTV = TV;
        }
    }
    return cachedTV;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= document
- (id)document;
/*"Given a line range number, it returns the range including the ending characters.
 Version history: jlaurens AT users DOT sourceforge DOT net
 - < 1.1: 03/10/2002
 To Do List:
 "*/
{DIAGNOSTIC4iTM3;
	//START4iTM3;
	return [[self.firstTextView.window windowController] document];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  mainTextView
- (NSTextView *)mainTextView;
/*"Description forthcoming.
 Version history: jlaurens AT users DOT sourceforge DOT net
 To Do List:
 "*/
{DIAGNOSTIC4iTM3;
	//START4iTM3;
    NSTextView * TV = self.firstTextView;
    NSWindowController * WC = [self.firstTextView.window windowController];
    if ([WC respondsToSelector:@selector(mainTextView)])
        return [(NSTextStorage *)WC mainTextView];
    else
        return TV;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  selection
- (NSTextStorage *)selection;
/*"Description forthcoming.
 Version history: jlaurens AT users DOT sourceforge DOT net
 To Do List:
 "*/
{DIAGNOSTIC4iTM3;
	//START4iTM3;
    return [[[NSTextStorage alloc]
			 initWithString: [self.string substringWithRange:self.selectedRange]] autorelease];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  selectedRange
- (NSRange)selectedRange;
/*"Description forthcoming.
 Version history: jlaurens AT users DOT sourceforge DOT net
 To Do List:
 "*/
{DIAGNOSTIC4iTM3;
	//START4iTM3;
    return [self.mainTextView selectedRange];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  setSelectedRange:
- (void)setSelectedRange:(NSRange)aRange;
/*"Description forthcoming.
 Version history: jlaurens AT users DOT sourceforge DOT net
 To Do List:
 "*/
{DIAGNOSTIC4iTM3;
	//START4iTM3;
    [self.mainTextView setSelectedRange:aRange];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  firstSelectedIndex
- (NSUInteger)firstSelectedIndex;
/*"Description forthcoming. 1 based for AppleScript.
 Version history: jlaurens AT users DOT sourceforge DOT net
 To Do List:
 "*/
{DIAGNOSTIC4iTM3;
	//START4iTM3;
    return self.selectedRange.location + 1;// beware of 0 ves 1 based numeration
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  lastSelectedIndex
- (NSUInteger)lastSelectedIndex;
/*"Description forthcoming. 1 based for AppleScript.
 Version history: jlaurens AT users DOT sourceforge DOT net
 To Do List:
 "*/
{DIAGNOSTIC4iTM3;
	//START4iTM3;
    return iTM3MaxRange(self.selectedRange);// beware of 0 versus 1 based numeration
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  selectedRangeSpecifier
- (NSRangeSpecifier *)selectedRangeSpecifier;
/*"Description forthcoming.
 Version history: jlaurens AT users DOT sourceforge DOT net
 To Do List:
 "*/
{DIAGNOSTIC4iTM3;
	//START4iTM3;
    NSRange R = self.selectedRange;
    return [[[NSRangeSpecifier alloc]
			 initWithContainerClassDescription : nil
			 containerSpecifier: nil
			 key:  @""
			 startSpecifier: [[NSIndexSpecifier alloc] 
							  initWithContainerClassDescription: nil containerSpecifier:  nil key: @"" index: R.location]
			 endSpecifier: [[NSIndexSpecifier alloc]
							initWithContainerClassDescription: nil containerSpecifier:  nil key: @"" index: iTM3MaxRange(R)-1]
			 ] autorelease];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  setSelectedRangeValue:
- (void)setSelectedRangeValue:(id)argument;
/*"Description forthcoming.
 Version history: jlaurens AT users DOT sourceforge DOT net
 To Do List:
 "*/
{DIAGNOSTIC4iTM3;
	//START4iTM3;
    NSRange R = argument? [argument evaluatedRange]:iTM3MakeRange(NSNotFound, 0);
    if (R.location != NSNotFound)
    {
        NSUInteger length = self.length;
        NSTextView * TV = self.mainTextView;
        R.location = MIN(R.location, length);
        R.length = MIN(R.length, length - R.location);
        if (TV)
        {
            [TV setSelectedRange:R];
            [TV.window makeFirstResponder:TV];
        }
    }
    else
	{
        LOG4iTM3(@"Don't know what to do with %@.", argument);
	}
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  selectAll:
- (void)selectAll:(id)irrelevant;
/*"Description forthcoming.
 Version history: jlaurens AT users DOT sourceforge DOT net
 To Do List:
 "*/
{DIAGNOSTIC4iTM3;
	//START4iTM3;
    [self setSelectedRangeValue:[NSValue valueWithRange:iTM3MakeRange(0, self.length)]];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  insertText:inRangeValue:
- (void)insertText:(id)text inRangeValue:(id)rangeValue;
/*"Description forthcoming.
 Version history: jlaurens AT users DOT sourceforge DOT net
 To Do List:
 "*/
{DIAGNOSTIC4iTM3;
	//START4iTM3;
    if ([text isKindOfClass:[NSString class]])
    {
        NSTextView * TV = self.mainTextView;
        if ([rangeValue respondsToSelector:@selector(rangeValue)])
            [TV setSelectedRange:[rangeValue rangeValue]];
        [TV insertText:text];
    }
    else
    {
        LOG4iTM3(@"JL, you should have raised an exception!!! (code 1515)");
    }
    return;
}
@end


//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  iTM2TextScriptingKit

