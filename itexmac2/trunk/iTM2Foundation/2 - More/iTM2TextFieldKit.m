/*
//
//  @version Subversion: $Id$ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Tue Jul 03 2001.
//  Copyright © 2001-2002 Laurens'Tribune. All rights reserved.
//
//  This program is free software; you can redistribute it and/or modify it under the terms
//  of the GNU General Public License as published by the Free Software Foundation; either
//  version 2 of the License, or any later version.
//  This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
//  without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
//  See the GNU General Public License for more details. You should have received a copy
//  of the GNU General Public License along with this program; if not, write to the Free Software
//  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
//  GPL addendum: Any simple modification of the present code which purpose is to remove bug,
//  improve efficiency in both code execution and code reading or writing should be addressed
//  to the actual developper team.
*/

#import <iTM2Foundation/iTM2NotificationKit.h>
#import <iTM2Foundation/iTM2TextKit.h>
#import <iTM2Foundation/iTM2BundleKit.h>
#import <iTM2Foundation/iTM2ViewKit.h>
#import <iTM2Foundation/iTM2TextFieldKit.h>
#import <iTM2Foundation/iTM2ValidationKit.h>
#import <iTM2Foundation/iTM2InstallationKit.h>
#import <iTM2Foundation/iTM2Implementation.h>
#import <iTM2Foundation/NSTextStorage_iTeXMac2.h>

@interface iTM2LineField(PRIVATE)
- (void)updateFrame;
@end
@interface NSWindowController(iTM2TextFieldKit)
- (id)textView;
@end
@implementation NSWindowController(iTM2TextFieldKit)
- (id)textView;
{iTM2_DIAGNOSTIC;
    return nil;
}
@end
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2LineField
/*"Description forthcoming."*/
@implementation iTM2LineField
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= awakeFromNib
- (void)awakeFromNib;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self setPostsFrameChangedNotifications:YES];
#if 1
    [self setFormatter:[[[iTM2LineFormatter alloc] init] autorelease]];
#endif
    [DNC addObserver:self
		selector: @selector(textViewDidChangeSelectionNotified:)
			name: NSTextViewDidChangeSelectionNotification
				object: nil];
				
    [DNC addObserver:self
		selector: @selector(textDidChangeNotified:)
			name: NSTextDidChangeNotification
				object: nil];

	[self setAction:@selector(lineFieldAction:)];
	[self setTarget:self];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= dealloc
- (void)dealloc;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [DNC removeObserver:self];
    [super dealloc];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= lineFieldAction:
- (IBAction)lineFieldAction:(id)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSWindow * W = [sender window];
    if(W != [self window])
        return;
	NSWindowController * WC = [W windowController];
    id TV = [WC respondsToSelector:@selector(textView)]? [WC textView]:nil;
	if(TV)
	{
		unsigned int line = [sender intValue];
		line = MAX(2,line)-1;
		[TV highlightAndScrollToVisibleLine:line];
		[W performSelector:@selector(makeFirstResponder:) withObject:TV afterDelay:0];
	}
	else
	{
		iTM2_LOG(@"Unexpected window controller: %@", WC);
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= isValid
- (BOOL)isValid;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self setEnabled:[[[self window] windowController] respondsToSelector:@selector(textView)]];
//iTM2_END;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  updateFrame
- (void)updateFrame;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//NSLog([self stringValue]);
//NSLog(@"%@", [self objectValue]);
	float oldMaxX = NSMaxX([self frame]);
    float newWidth = MAX(([[self stringValue] sizeWithAttributes:
            [NSDictionary dictionaryWithObjectsAndKeys:[self font], NSFontAttributeName, nil]].width
                    + 8), 30);
    float deltaWidth = newWidth - [self frame].size.width;
    if((deltaWidth < -8) || (deltaWidth > 0))
    {
        NSRect oldRect = [self frame];
        NSSize size = oldRect.size;
        size.width = newWidth;
        [self setFrameSize:size];
		if(rightView)
		{
			float delta = NSMaxX([self frame]) - oldMaxX;
			NSRect frame = [rightView frame];
			frame.origin.x -= delta;
			frame.size.width += delta;
			[rightView setFrame:frame];
		}
        [[self superview] setNeedsDisplayInRect:NSUnionRect([self frame], oldRect)];
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  textViewDidChangeSelectionNotified:
- (void)textViewDidChangeSelectionNotified:(NSNotification *)notification;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSTextView * TV = [notification object];
	NSWindow * W = [TV window];
    if(W != [self window])
        return;
	if([TV isDescendantOf:self])
		return;
	id WC = [W windowController];
	if(![WC respondsToSelector:@selector(textView)])
		return;
	if(TV == [WC textView])
	{
		id TS = [TV layoutManager];
		TS = [TS textStorage];
		NSNumberFormatter * F = [self formatter];
		id maximum = [F maximum];
		NSDecimalNumber * NaN = [NSDecimalNumber notANumber];
		unsigned int new = 0;
		if([maximum isEqual:NaN])
		{
			// the maximum has not yet been set
			new = [(NSTextStorage *)TS length];
			if(new)
			{
				new = [TS lineIndexForLocation:new];
				++new;
				maximum = [NSDecimalNumber numberWithInt:new];
				[F setMaximum:maximum];
			}
			else
			{
				return;
			}
			// will it be updated???
		}
		unsigned int old = [self intValue];
		new = [TV selectedRange].location;
		new = [TS lineIndexForLocation:new];
		++new;
		if(old != new)
		{
			[self setIntValue:new];
//iTM2_LOG(@"2  -  [self updateFrame]");
			[self updateFrame];
		}
	}
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  textDidChangeNotified:
- (void)textDidChangeNotified:(NSNotification *)notification;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSTextView * TV = [notification object];
	NSWindow * W = [TV window];
    if(W != [self window])
        return;
	if([TV isDescendantOf:self])
		return;
	id WC = [W windowController];
	if(![WC respondsToSelector:@selector(textView)])
		return;
	if(TV == [WC textView])
    {
        NSNumberFormatter * F = [self formatter];
        int old = [[F maximum] intValue];
        NSTextStorage * TS = [[TV layoutManager] textStorage];
        int new = [TS length];
        new = [TS lineIndexForLocation:new];// REALLY KEEP the TS for performance reasons
		++new;
        if(old != new)
        {
            [F setMaximum:(NSDecimalNumber *)[NSDecimalNumber numberWithInt:new]];
//iTM2_LOG(@"3  -  [self updateFrame]");
            [self updateFrame];
        }
    }
//iTM2_END;
    return;
}
@end

@implementation iTM2LineResponder
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  gotoLineField:
- (IBAction)gotoLineField:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSControl * C = [[[NSApp keyWindow] contentView] controlWithAction:@selector(lineFieldAction:)];
	if([C isValid])
		[[C window] makeFirstResponder:C];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateGotoLineField:
- (BOOL)validateGotoLineField:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	return [[[[NSApp keyWindow] contentView] controlWithAction:@selector(lineFieldAction:)] isValid];
}
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2LineFormatter
/*"Description forthcoming."*/
@implementation iTM2LineFormatter
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= init
- (id)init;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(self = [super init])
    {
        [self setPositiveFormat:@"#0"];
        NSAttributedString * string = [[[NSAttributedString alloc] initWithString:@"..."] autorelease];
        [self setAttributedStringForNotANumber:string];
        [self setAttributedStringForZero:[[[NSAttributedString alloc] initWithString:@"0"] autorelease]];
        [self setAttributedStringForNil:string];
        [self setMinimum:[NSDecimalNumber one]];
        [self setMaximum:[NSDecimalNumber notANumber]];
        [self setAllowsFloats:NO];
        [self setHasThousandSeparators:NO];
    }
    return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= dealloc
- (void)dealloc;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self setNavigationFormat:nil];
    [super dealloc];
    return;
}	 
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= navigationFormat
- (NSString *)navigationFormat;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return _NavigationFormat? [[_NavigationFormat copy] autorelease]:[self lazyNavigationFormat];
}
#define TABLE @"Basic"
#define BUNDLE [NSBundle bundleForClass:[iTM2LineFormatter class]]
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= lazyNavigationFormat
- (NSString *)lazyNavigationFormat;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return NSLocalizedStringFromTableInBundle(@"Line %1$@ of %2$@", TABLE, BUNDLE, "Navigation format");
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= setNavigationFormat:
- (void)setNavigationFormat:(NSString *)aFormat;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(![aFormat isEqualToString:_NavigationFormat])
    {
        [_NavigationFormat release];
        _NavigationFormat = [aFormat copy];
    }
    return;
}
#if 1
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= stringForObjectValue:
- (NSString *)stringForObjectValue:(id)anObject;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
#if 0
	if(!anObject)
	{
		iTM2_LOG(@"How does it happen?");
	}
	id result = [NSString stringWithFormat:[self navigationFormat],
        [super stringForObjectValue:(anObject?:[NSNumber numberWithInt:0])],
        [super stringForObjectValue:[self maximum]]];
	iTM2_LOG(@"result is: %@", result);
#endif
    return [NSString stringWithFormat:[self navigationFormat],
        [super stringForObjectValue:anObject],
        [super stringForObjectValue:[self maximum]]];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= editingStringForObjectValue:
- (NSString *)editingStringForObjectValue:(id) anObject;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_LOG(@"anObject is: %@ (%@)", anObject, [anObject class]);
    return [NSString stringWithFormat:@"%@", anObject];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= isPartialStringValid:proposedSelectedRange:originalString:originalSelectedRange:errorDescription:
- (BOOL)isPartialStringValid:(NSString **)partialStringPtr
proposedSelectedRange: (NSRangePointer) proposedSelRangePtr
originalString: (NSString *) origString
originalSelectedRange: (NSRange) origSelRange
errorDescription: (NSString **) errorStatusPtr;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    id anObject;
    NSString * localError;
    BOOL result;
    if(!errorStatusPtr)
        errorStatusPtr = &localError;
    result = [self getObjectValue:&anObject forString:*partialStringPtr errorDescription:errorStatusPtr];
    if(!result)
    {
        *partialStringPtr = [[origString copy] autorelease];
		*proposedSelRangePtr = origSelRange;
    }
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= getObjectValue:forString:errorDescription:
- (BOOL)getObjectValue:(id *)obj forString:(NSString *)string errorDescription:(NSString **)errorStatusPtr;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	BOOL result = [super getObjectValue:obj forString:string errorDescription:errorStatusPtr];
	if(!result)
	{
		iTM2_LOG(@"Failure");
		return NO;
	}
	else if(obj)
	{
		if(* obj == nil)
		{
//iTM2_LOG(@"string is: <%@>", string);
			if(errorStatusPtr)
			{
				iTM2_LOG(@"error is: <%@>", *errorStatusPtr);
			}
			return NO;
		}
#if 0
#warning DEBUGGGG
		else
		{
			iTM2_LOG(@"Object is: %@(%@)", *obj, [*obj class]);
		}
#endif
	}
//iTM2_END;
	return result;
}
#endif
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2NavigationFormatter
/*"Description forthcoming."*/
@implementation iTM2NavigationFormatter
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= init
- (id)init;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(self = [super init])
    {
        [self setPositiveFormat:@"#0"];
        NSAttributedString * string = [[[NSAttributedString alloc] initWithString:@"..."] autorelease];
        [self setAttributedStringForNotANumber:string];
        [self setAttributedStringForZero:[[[NSAttributedString alloc] initWithString:@"0"] autorelease]];
        [self setAttributedStringForNil:string];
        [self setMinimum:[NSDecimalNumber zero]];
        [self setMaximum:[NSDecimalNumber notANumber]];
        [self setAllowsFloats:NO];
        [self setHasThousandSeparators:NO];
    }
    return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= lazyNavigationFormat
- (NSString *)lazyNavigationFormat;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return NSLocalizedStringFromTableInBundle(@"%1$@/%2$@", @"Basic",
                                                    [self classBundle], "Navigation format");
}
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2NavigationFormatter

#import <iTM2Foundation/iTM2MenuKit.h>

@implementation iTM2MainInstaller(MagnificationFormatter)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  magnificationFormatterCompleteInstallation
+ (void)iTM2MagnificationFormatterCompleteInstallation;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon May 10 22:45:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSMenuItem * menuItem = [[NSApp mainMenu] deepItemWithAction:@selector(displayPDFAtMagnification:)];
	if(!menuItem)
	{
		iTM2_LOG(@"The installation might be not complete, no displayPDFAtMagnification: menu item!");
		return;
	}
    NSEnumerator * menuEnumerator = [[[menuItem menu] itemArray] objectEnumerator];
    iTM2MagnificationFormatter * MF = [[[iTM2MagnificationFormatter alloc] init] autorelease];
    while(menuItem=[menuEnumerator nextObject])
    {
        NSNumber * number;
        if([MF getObjectValue:&number forString:[menuItem title] errorDescription:nil])
            [menuItem setRepresentedObject:number];
    }
//iTM2_END;
    return;
}
@end

@implementation iTM2MagnificationFormatter
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= init
- (id)init;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(self = [super init])
    {
        [self setPositiveFormat:@"#0 %"];
        NSAttributedString * string = [[[NSAttributedString alloc] initWithString:@"..."] autorelease];
        [self setAttributedStringForNotANumber:string];
        [self setAttributedStringForZero:string];
        [self setAttributedStringForNil:string];
        [self setMinimum:[NSDecimalNumber zero]];
        [self setMaximum:[NSDecimalNumber notANumber]];
        [self setAllowsFloats:YES];
        [self setHasThousandSeparators:NO];
    }
    return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= stringForObjectValue:
- (NSString *)stringForObjectValue:(id)anObject;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List: Bug when inherited method is used: 200 % comes instead of 221 % (for example)
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if([anObject respondsToSelector:@selector(floatValue)])
    {
        float f = [anObject floatValue]*100;
        return [NSString stringWithFormat:@"%.0f %%", f];
//        return [super stringForObjectValue:[NSDecimalNumber numberWithFloat:100*[anObject floatValue]]];
    }
    else
        return @"?";
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= editingStringForObjectValue:
- (NSString *)editingStringForObjectValue:(id)anObject;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if([anObject respondsToSelector:@selector(floatValue)])
    {
        float f = [anObject floatValue]*100;
        return [NSString stringWithFormat:@"%.0f", f];
//        return [super stringForObjectValue:[NSDecimalNumber numberWithFloat:100*[anObject floatValue]]];
    }
    else
        return @"?";
}
#if 1
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= isPartialStringValid:newEditingString:errorDescription:
- (BOOL)isPartialStringValid:(NSString **)partialStringPtr
proposedSelectedRange: (NSRangePointer) proposedSelRangePtr
originalString: (NSString *) origString
originalSelectedRange: (NSRange) origSelRange
errorDescription: (NSString **) errorPtr;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List: I don't know if it is really needed, test...
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
#warning TEST (JL)
    id anObject;
    NSString * localError;
    BOOL result;
    if(!errorPtr)
        errorPtr = &localError;
    result = [self getObjectValue:&anObject forString:*partialStringPtr errorDescription:errorPtr];
    if(!result)
    {
        *partialStringPtr = [[origString copy] autorelease];
		*proposedSelRangePtr = origSelRange;
    }
    return result;
}
#endif
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= getObjectValue:forString:errorDescription:
- (BOOL)getObjectValue:(id *)objectPtr forString:(NSString *)string errorDescription:(NSString **)errorPtr;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSScanner * scanner = [NSScanner scannerWithString:string];
    float F;
    if([scanner scanFloat:&F] && (F>0) &&(F<=6400))
        *objectPtr = [NSDecimalNumber numberWithFloat:F/100];
    else
        *objectPtr = nil;
    return (*objectPtr != nil);
}
@end

@implementation iTM2StringFormatter
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  init
- (id)init;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(self = [super init])
    {
        [self initImplementation];
    }
    return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  dealloc
- (void)dealloc;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- for 1.3: Mon Jun 02 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    [self willDealloc];
	[DNC removeObserver:self];
    [IMPNC removeObserver:self];
    [self deallocImplementation];
    [super dealloc];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  implementation
- (id)implementation;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return _Implementation;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setImplementation:
- (void)setImplementation:(id)argument;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(_Implementation != argument)
    {
        [_Implementation autorelease];
        _Implementation = [argument retain];
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= stringForObjectValue:
- (NSString *)stringForObjectValue:(id)anObject;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List: Bug when inherited method is used: 200 % comes instead of 221 % (for example)
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return [anObject isKindOfClass:[NSString class]]? anObject:@"";
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= getObjectValue:forString:errorDescription:
- (BOOL)getObjectValue:(id *)objectPtr forString:(NSString *)string errorDescription:(NSString **)errorPtr;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(objectPtr)
		*objectPtr = [[string copy] autorelease];
    return YES;
}
@end

@implementation iTM2FileNameFormatter
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= stringForObjectValue:
- (NSString *)stringForObjectValue:(id)anObject;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List: Bug when inherited method is used: 200 % comes instead of 221 % (for example)
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if([anObject isKindOfClass:[NSString class]])
    {
		return anObject;
    }
    else
        return @"";
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= attributedStringForObjectValue:withDefaultAttributes:
- (NSAttributedString *)attributedStringForObjectValue:(id)obj withDefaultAttributes:(NSDictionary *)attrs;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 03/26/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * path = [[self stringForObjectValue:obj] stringByStandardizingPath];
	if(![path hasPrefix:@"/"] || [DFM fileExistsAtPath:path])
	{
		return [[[NSAttributedString allocWithZone:[self zone]] initWithString:path attributes:attrs] autorelease];
	}
	else if([path length])
	{
		NSMutableDictionary * MD = [[attrs mutableCopy] autorelease];
		[MD setObject:[NSColor redColor] forKey:NSForegroundColorAttributeName];
		return [[[NSAttributedString allocWithZone:[self zone]] initWithString:path attributes:MD] autorelease];
	}
	else
	{
		NSMutableDictionary * MD = [[attrs mutableCopy] autorelease];
		[MD setObject:[NSColor lightGrayColor] forKey:NSForegroundColorAttributeName];
		return [[[NSAttributedString allocWithZone:[self zone]]
			initWithString: NSLocalizedStringFromTableInBundle(@"Enter a file name", TABLE, BUNDLE, "")
				attributes: MD] autorelease];
	}
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= getObjectValue:forString:errorDescription:
- (BOOL)getObjectValue:(id *)objectPtr forString:(NSString *)string errorDescription:(NSString **)errorPtr;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    *objectPtr = string;
    return YES;
}
@end

@interface NSFormatter_iTeXMac2: NSFormatter
@end

@implementation NSFormatter_iTeXMac2
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= load
+ (void)load;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: today?
To Do List:
"*/
{iTM2_DIAGNOSTIC;
    iTM2_INIT_POOL;
	iTM2RedirectNSLogOutput();
//iTM2_START;
    [NSFormatter_iTeXMac2 poseAsClass:[NSFormatter class]];
//iTM2_END;
	iTM2_RELEASE_POOL;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= attributedStringForObjectValue:withDefaultAttributes:
- (NSAttributedString *)attributedStringForObjectValue:(id)obj withDefaultAttributes:(NSDictionary *)attrs;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 03/26/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(obj)
		return [super attributedStringForObjectValue:obj withDefaultAttributes:attrs];
	NSAttributedString * AS = [self attributedStringForNilObjectValueWithDefaultAttributes:attrs];
	if([AS length])
		return AS;
	return [super attributedStringForObjectValue:obj withDefaultAttributes:attrs];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= attributedStringForNilObjectValueWithDefaultAttributes:
- (NSAttributedString *)attributedStringForNilObjectValueWithDefaultAttributes:(NSDictionary *)attrs;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 03/26/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * string = [self stringForNilObjectValue];
	NSMutableDictionary * MD = [[attrs mutableCopy] autorelease];
	[MD setObject:[NSColor disabledControlTextColor] forKey:NSForegroundColorAttributeName];
	return [[[NSAttributedString allocWithZone:[self zone]] initWithString:string attributes:MD] autorelease];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= stringForNilObjectValue
- (NSString *)stringForNilObjectValue;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 03/26/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * result = metaGETTER;
	if(result)
		return result;
	NSString * key = [NSString stringWithFormat:@"nil object description (%@)", NSStringFromClass([self class])];
	return NSLocalizedStringFromTableInBundle(key, TABLE, BUNDLE, "");
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setStringForNilObjectValue:
- (void)setStringForNilObjectValue:(NSString *)aString;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    metaSETTER(aString);
//iTM2_END;
    return;
}
@end

#if 0
#warning FOLLOW FOCUS
        if([self contextBoolForKey:iTM2UDSyncFollowFocusKey domain:iTM2ContextAllDomainsMask])
        {
            id P = [[self document] project];
            id D = [SDC documentForFileName:[P absoluteOutput]];
//NSLog(@"D: %@", D);
            if((new>=0) && [D respondsToSelector:@selector(showOutputForLine:column:source:)])
            {
                NSString * source = [[[self document] fileName]
                                        stringByAbbreviatingWithDotsRelativeToDirectory:
                                            [[D fileName] stringByDeletingLastPathComponent]];
                [D showOutputForLine:new column:0 source:source];
            }
        }
#endif
