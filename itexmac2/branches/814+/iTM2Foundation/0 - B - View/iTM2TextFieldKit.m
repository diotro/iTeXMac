/*
//
//  @version Subversion: $Id: iTM2TextFieldKit.m 795 2009-10-11 15:29:16Z jlaurens $ 
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

#import "iTM2NotificationKit.h"
#import "iTM2BundleKit.h"
#import "iTM2ViewKit.h"
#import "iTM2TextFieldKit.h"
#import "iTM2ValidationKit.h"
#import "iTM2InstallationKit.h"
#import "iTM2Implementation.h"
#import "iTM2TextKit.h"
#import "iTM2StringKit.h"

@interface iTM2LineField(PRIVATE)
- (void)updateFrame;
@end
@interface NSWindowController(iTM2TextFieldKit)
- (id)textView;
@end
@implementation NSWindowController(iTM2TextFieldKit)
- (id)textView;
{DIAGNOSTIC4iTM3;
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
    [super awakeFromNib];
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

	self.action = @selector(lineFieldAction:);
	self.target = self;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= lineFieldAction:
- (IBAction)lineFieldAction:(NSTextField *)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSWindow * W = sender.window;
    if (W != self.window) {
        return;
    }
	NSWindowController * WC = W.windowController;
    if ([WC respondsToSelector:@selector(textView)]) {
        NSTextView * TV = [WC textView];
		NSUInteger line = [sender integerValue];
		line = MAX(2,line)-1;
		[TV highlightAndScrollToVisibleLine:line];
		if ([TV acceptsFirstResponder]) {
			[W performSelector:@selector(makeFirstResponder:) withObject:TV afterDelay:0];
		}
	} else {
		LOG4iTM3(@"Unexpected window controller: %@", WC);
	}
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= isValid4iTM3
- (BOOL)isValid4iTM3;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[self setEnabled:[self.window.windowController respondsToSelector:@selector(textView)]];
//END4iTM3;
    return YES;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  updateFrame
- (void)updateFrame;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//NSLog(self.stringValue);
//NSLog(@"%@", self.objectValue);
	CGFloat oldMaxX = NSMaxX(self.frame);
    CGFloat newWidth = MAX(([self.stringValue sizeWithAttributes:
            [NSDictionary dictionaryWithObjectsAndKeys:self.font, NSFontAttributeName, nil]].width
                    + 8), 30);
    CGFloat deltaWidth = newWidth - self.frame.size.width;
    if ((deltaWidth < -8) || (deltaWidth > 0))
    {
        NSRect oldRect = self.frame;
        NSSize size = oldRect.size;
        size.width = newWidth;
        [self setFrameSize: size];
		if (rightView)
		{
			CGFloat delta = NSMaxX(self.frame) - oldMaxX;
			NSRect frame = rightView.frame;
			frame.origin.x -= delta;
			frame.size.width += delta;
			[rightView setFrame:frame];
		}
        [self.superview setNeedsDisplayInRect:NSUnionRect(self.frame, oldRect)];
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSTextView * TV = [notification object];
	NSWindow * W = TV.window;
    if (W != self.window)
        return;
	if ([TV isDescendantOf:self])
		return;
	id WC = W.windowController;
	if (![WC respondsToSelector:@selector(textView)])
		return;
	if (TV == [WC textView])
	{
		id TS = [TV layoutManager];
		TS = [TS textStorage];
		NSNumberFormatter * F = self.formatter;
		id maximum = [F maximum];
		NSDecimalNumber * NaN = [NSDecimalNumber notANumber];
		NSUInteger new = ZER0;
		if ([maximum isEqual:NaN])
		{
			// the maximum has not yet been set
			new = [(NSTextStorage *)TS length];
			if (new)
			{
				new = [TS lineIndexForLocation4iTM3:new];
				++new;
				maximum = [NSDecimalNumber numberWithInteger:new];
				[F setMaximum:maximum];
			}
			else
			{
				return;
			}
			// will it be updated???
		}
		NSUInteger old = self.integerValue;
		new = [TV selectedRange].location;
		new = [TS lineIndexForLocation4iTM3:new];
		++new;
		if (old != new)
		{
			[self setIntegerValue:new];
//LOG4iTM3(@"2  -  self.updateFrame");
			[self updateFrame];
		}
	}
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  textDidChangeNotified:
- (void)textDidChangeNotified:(NSNotification *)notification;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSTextView * TV = [notification object];
	NSWindow * W = TV.window;
    if (W != self.window)
        return;
	if ([TV isDescendantOf:self])
		return;
	id WC = W.windowController;
	if (![WC respondsToSelector:@selector(textView)])
		return;
	if (TV == [WC textView])
    {
        NSNumberFormatter * F = self.formatter;
        NSUInteger old = [[F maximum] unsignedIntegerValue];
        NSTextStorage * TS = [[TV layoutManager] textStorage];
        NSUInteger new = TS.length;
        new = [TS lineIndexForLocation4iTM3:new];// REALLY KEEP the TS for performance reasons
		++new;
        if (old != new) {
            [F setMaximum:[NSNumber numberWithUnsignedInteger:new]];
//LOG4iTM3(@"3  -  self.updateFrame");
            [self updateFrame];
        }
    }
//END4iTM3;
    return;
}
@synthesize rightView;
@end

@implementation iTM2LineResponder
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  gotoLineField:
- (IBAction)gotoLineField:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSControl * C = [[[NSApp keyWindow] contentView] controlWithAction:@selector(lineFieldAction:)];
	if ([C isValid4iTM3] && [C acceptsFirstResponder])
	{
		[C.window makeFirstResponder:C];
	}
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  validateGotoLineField:
- (BOOL)validateGotoLineField:(id)sender;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Tue Feb  3 09:56:38 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	return [[[[NSApp keyWindow] contentView] controlWithAction:@selector(lineFieldAction:)] isValid4iTM3];
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if ((self = [super init]))
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
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= navigationFormat
- (NSString *)navigationFormat;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return _NavigationFormat? [[_NavigationFormat copy] autorelease]:self.lazyNavigationFormat;
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return NSLocalizedStringFromTableInBundle(@"Line %1$@ of %2$@", TABLE, BUNDLE, "Navigation format");
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= setNavigationFormat:
- (void)setNavigationFormat:(NSString *)aFormat;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (![aFormat isEqualToString:_NavigationFormat])
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
#if 0
	if (!anObject)
	{
		LOG4iTM3(@"How does it happen?");
	}
	id result = [NSString stringWithFormat:self.navigationFormat,
        [super stringForObjectValue:(anObject?:[NSNumber numberWithInteger:ZER0])],
        [super stringForObjectValue:self.maximum]];
	LOG4iTM3(@"result is: %@", result);
#endif
    return [NSString stringWithFormat:self.navigationFormat,
        [super stringForObjectValue:anObject],
        [super stringForObjectValue:self.maximum]];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= editingStringForObjectValue:
- (NSString *)editingStringForObjectValue:(id) anObject;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//LOG4iTM3(@"anObject is: %@ (%@)", anObject, [anObject class]);
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
    id anObject;
    NSString * localError;
    BOOL result;
    if (!errorStatusPtr)
        errorStatusPtr = &localError;
    result = [self getObjectValue:&anObject forString:*partialStringPtr errorDescription:errorStatusPtr];
    if (!result)
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
	BOOL result = [super getObjectValue:obj forString:string errorDescription:errorStatusPtr];
	if (!result)
	{
		LOG4iTM3(@"Failure");
		return NO;
	}
	else if (obj)
	{
		if (* obj == nil)
		{
//LOG4iTM3(@"string is: <%@>", string);
			if (errorStatusPtr)
			{
				LOG4iTM3(@"error is: <%@>", *errorStatusPtr);
			}
			return NO;
		}
#if 0
#warning DEBUGGGG
		else
		{
			LOG4iTM3(@"Object is: %@(%@)", *obj, [*obj class]);
		}
#endif
	}
//END4iTM3;
	return result;
}
#endif
@synthesize _NavigationFormat;
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if ((self = [super init]))
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return NSLocalizedStringFromTableInBundle(@"%1$@/%2$@", @"Basic",
                                                    self.classBundle4iTM3, "Navigation format");
}
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iTM2NavigationFormatter

#import "iTM2MenuKit.h"

@implementation iTM2MainInstaller(MagnificationFormatter)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  magnificationFormatterCompleteInstallation4iTM3
+ (void)iTM2MagnificationFormatterCompleteInstallation4iTM3;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Mon May 10 22:45:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSMenuItem * menuItem = [[NSApp mainMenu] deepItemWithAction4iTM3:@selector(displayPDFAtMagnification:)];
	if (!menuItem)
	{
		LOG4iTM3(@"The installation might be not complete, no displayPDFAtMagnification: menu item!");
		return;
	}
    NSEnumerator * menuEnumerator = [menuItem.menu.itemArray objectEnumerator];
    iTM2MagnificationFormatter * MF = [[[iTM2MagnificationFormatter alloc] init] autorelease];
    while((menuItem=[menuEnumerator nextObject]))
    {
        NSNumber * number;
        if ([MF getObjectValue:&number forString:menuItem.title errorDescription:nil])
            menuItem.representedObject = number;
    }
//END4iTM3;
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if ((self = [super init]))
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if ([anObject respondsToSelector:@selector(floatValue)])
    {
        CGFloat f = [anObject floatValue]*100;
        return [NSString stringWithFormat:@"%.0f %%", f];
//        return [super stringForObjectValue:[NSDecimalNumber numberWithFloat:100*anObject.floatValue]];
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if ([anObject respondsToSelector:@selector(floatValue)])
    {
        CGFloat f = [anObject floatValue]*100;
        return [NSString stringWithFormat:@"%.0f", f];
//        return [super stringForObjectValue:[NSDecimalNumber numberWithFloat:100*anObject.floatValue]];
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
    id anObject;
    NSString * localError;
    BOOL result;
    if (!errorPtr)
        errorPtr = &localError;
    result = [self getObjectValue:&anObject forString:*partialStringPtr errorDescription:errorPtr];
    if (!result)
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSScanner * scanner = [NSScanner scannerWithString:string];
    float F;
    if ([scanner scanFloat:&F] && (F>0) &&(F<=6400))
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if ((self = [super init]))
    {
        [self initImplementation];
    }
    return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  implementation
- (id)implementation;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return _Implementation;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setImplementation:
- (void)setImplementation:(id)argument;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (_Implementation != argument)
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [anObject isKindOfClass:[NSString class]]? anObject:@"";
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= getObjectValue:forString:errorDescription:
- (BOOL)getObjectValue:(id *)objectPtr forString:(NSString *)string errorDescription:(NSString **)errorPtr;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (objectPtr)
		*objectPtr = [[string copy] autorelease];
    return YES;
}
@synthesize _Implementation;
@end

@implementation iTM2FileNameFormatter
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= stringForObjectValue:
- (NSString *)stringForObjectValue:(id)anObject;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List: Bug when inherited method is used: 200 % comes instead of 221 % (for example)
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if ([anObject isKindOfClass:[NSString class]])
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSString * path = [[self stringForObjectValue:obj] stringByStandardizingPath];
	if (![path hasPrefix:@"/"] || [DFM fileExistsAtPath:path])
	{
		return [[[NSAttributedString alloc] initWithString:path attributes:attrs] autorelease];
	}
	else if (path.length)
	{
		NSMutableDictionary * MD = [[attrs mutableCopy] autorelease];
		[MD setObject:[NSColor redColor] forKey:NSForegroundColorAttributeName];
		return [[[NSAttributedString alloc] initWithString:path attributes:MD] autorelease];
	}
	else
	{
		NSMutableDictionary * MD = [[attrs mutableCopy] autorelease];
		[MD setObject:[NSColor lightGrayColor] forKey:NSForegroundColorAttributeName];
		return [[[NSAttributedString alloc]
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
{DIAGNOSTIC4iTM3;
//START4iTM3;
    *objectPtr = string;
    return YES;
}
@end

@implementation NSFormatter(iTM2TextField)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= SWZ_iTM2TextField_attributedStringForObjectValue:withDefaultAttributes:
- (NSAttributedString *)SWZ_iTM2TextField_attributedStringForObjectValue:(id)obj withDefaultAttributes:(NSDictionary *)attrs;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 03/26/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (obj)
		return [self SWZ_iTM2TextField_attributedStringForObjectValue:obj withDefaultAttributes:attrs];
	NSAttributedString * AS = [self attributedStringForNilObjectValueWithDefaultAttributes:attrs];
	if (AS.length)
		return AS;
	return [self SWZ_iTM2TextField_attributedStringForObjectValue:obj withDefaultAttributes:attrs];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= attributedStringForNilObjectValueWithDefaultAttributes:
- (NSAttributedString *)attributedStringForNilObjectValueWithDefaultAttributes:(NSDictionary *)attrs;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 03/26/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSString * string = self.stringForNilObjectValue;
	NSMutableDictionary * MD = [[attrs mutableCopy] autorelease];
	[MD setObject:[NSColor disabledControlTextColor] forKey:NSForegroundColorAttributeName];
	return [[[NSAttributedString alloc] initWithString:string attributes:MD] autorelease];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= stringForNilObjectValue
- (NSString *)stringForNilObjectValue;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 03/26/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSString * result = metaGETTER;
	if (result)
		return result;
	NSString * key = [NSString stringWithFormat:@"nil object description (%@)", NSStringFromClass(self.class)];
	return NSLocalizedStringFromTableInBundle(key, TABLE, BUNDLE, "");
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  setStringForNilObjectValue:
- (void)setStringForNilObjectValue:(NSString *)aString;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- 1.4: Thu Nov 18 07:53:25 GMT 2004
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    metaSETTER(aString);
//END4iTM3;
    return;
}
@end

#if 0
#warning FOLLOW FOCUS
        if ([self context4iTM3BoolForKey:iTM2UDSyncFollowFocusKey domain:iTM2ContextAllDomainsMask])
        {
            id P = [self.document project4iTM3];
            id D = [SDC documentForFileName:[P absoluteOutput]];
//NSLog(@"D: %@", D);
            if ((new>=ZER0) && [D respondsToSelector:@selector(showOutputForLine:column:source:)])
            {
                NSString * source = [[self.document fileName]
                                        stringByAbbreviatingWithDotsRelativeToDirectory4iTM3:
                                            [[D fileName] stringByDeletingLastPathComponent]];
                [D showOutputForLine:new column:ZER0 source:source];
            }
        }
#endif

#import "iTM2Runtime.h"

@implementation iTM2MainInstaller(TextFiekdKit)
- (void)completeTextFiekdKitNSFormatterInstallation;
{
	if ([NSFormatter swizzleInstanceMethodSelector4iTM3:@selector(SWZ_iTM2TextField_attributedStringForObjectValue:withDefaultAttributes:) error:NULL])
	{
		MILESTONE4iTM3((@"NSFormatter(iTM2TextField)"),(@"Attributes for nil object value are not handled?"));
	}
    return;
}

@end