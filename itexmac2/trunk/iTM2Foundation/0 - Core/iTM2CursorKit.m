/*
//  iTM2CursorKit.m
//  iTeXMac2
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Thu Jan 23 2003.
//  Copyright © 2001-2002 Laurens'Tribune. All rights reserved.
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

#import <iTM2Foundation/iTM2CursorKit.h>
#import <iTM2Foundation/iTM2BundleKit.h>

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  NSCursor(iTeXMac2)
/*"Description forthcoming."*/
@implementation NSCursor(iTeXMac2)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  fingerCursor
+ (NSCursor *) fingerCursor;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: Thu Jan 23 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    static NSCursor * cursor = nil;
    if(!cursor)
    {
        NSString * path = [[NSBundle iTM2FoundationBundle] pathForImageResource:@"iTM2FingerCursor"];
        if(path)
            cursor = [[NSCursor allocWithZone:[self zone]] initWithImage:
                    [[NSImage allocWithZone:[self zone]] initWithContentsOfFile:path]
                        hotSpot: NSMakePoint(6.5, 2)];
        else
        {
            iTM2_LOG(@"Could not create hand cursor...");
            cursor = [[NSCursor arrowCursor] retain];
        }
    }
    return cursor;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  handCursor
+ (NSCursor *) handCursor;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: Thu Jan 23 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    static NSCursor * cursor = nil;
    if(!cursor)
    {
        NSString * path = [[NSBundle iTM2FoundationBundle] pathForImageResource:@"iTM2HandCursor"];
        if(path)
            cursor = [[NSCursor allocWithZone:[self zone]] initWithImage:
                    [[NSImage allocWithZone:[self zone]] initWithContentsOfFile:path]
                        hotSpot: NSMakePoint(7, 7)];
        else
        {
            iTM2_LOG(@"Could not create hand cursor...");
            cursor = [[NSCursor arrowCursor] retain];
        }
    }
    return cursor;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  zoomInCursor
+ (NSCursor *) zoomInCursor;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: Thu Jan 23 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    static NSCursor * cursor = nil;
    if(!cursor)
    {
        NSString * path = [[NSBundle iTM2FoundationBundle] pathForImageResource:@"iTM2ZoomInCursor"];
        if(path)
            cursor = [[NSCursor allocWithZone:[self zone]] initWithImage:
                    [[NSImage allocWithZone:[self zone]] initWithContentsOfFile:path]
                        hotSpot: NSMakePoint(7, 7)];
        else
        {
            iTM2_LOG(@"Could not create zoom in cursor...");
            cursor = [[NSCursor arrowCursor] retain];
        }
    }
    return cursor;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  zoomOutCursor
+ (NSCursor *) zoomOutCursor;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: Thu Jan 23 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    static NSCursor * cursor = nil;
    if(!cursor)
    {
        NSString * path = [[NSBundle iTM2FoundationBundle] pathForImageResource:@"iTM2ZoomOutCursor"];
        if(path)
            cursor = [[NSCursor allocWithZone:[self zone]] initWithImage:
                    [[NSImage allocWithZone:[self zone]] initWithContentsOfFile:path]
                        hotSpot: NSMakePoint(7, 7)];
        else
        {
            iTM2_LOG(@"Could not create zoom in cursor...");
            cursor = [[NSCursor arrowCursor] retain];
        }
    }
    return cursor;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  crossHairCursor
+ (NSCursor *) crossHairCursor;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: Thu Jan 23 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    static NSCursor * cursor = nil;
    if(!cursor)
    {
        NSString * path = [[NSBundle iTM2FoundationBundle] pathForImageResource:@"iTM2CrossHair"];
        if(path)
            cursor = [[NSCursor allocWithZone:[self zone]] initWithImage:
                    [[NSImage allocWithZone:[self zone]] initWithContentsOfFile:path]
                        hotSpot: NSMakePoint(7, 7)];
        else
        {
            iTM2_LOG(@"Could not create hand cursor...");
            cursor = [[NSCursor arrowCursor] retain];
        }
    }
    return cursor;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  horizontalResizeCursor
+ (NSCursor *) horizontalResizeCursor;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: Thu Jan 23 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    static NSCursor * cursor = nil;
    if(!cursor)
    {
        NSImage * I = [[[NSImage alloc] initWithSize:NSMakeSize(16, 16)] autorelease];
        NS_DURING
        [I lockFocus];
        [[NSColor blackColor] set];
        NSBezierPath * BP = [NSBezierPath bezierPath];
        [BP moveToPoint:NSMakePoint(0, 7.5)];
        [BP relativeLineToPoint:NSMakePoint(3.5, -3)];
        [BP relativeLineToPoint:NSMakePoint(0, 6)];
        [BP relativeLineToPoint:NSMakePoint(-3.5, -3)];
        [BP closePath];
        [BP moveToPoint:NSMakePoint(15, 7.5)];
        [BP relativeLineToPoint:NSMakePoint(-3.5, 3)];
        [BP relativeLineToPoint:NSMakePoint(0, -6)];
        [BP relativeLineToPoint:NSMakePoint(3.5, 3)];
        [BP closePath];
        [BP fill];
        [NSBezierPath setDefaultLineWidth:1.5];
        [NSBezierPath strokeLineFromPoint:NSMakePoint(1, 7.5) toPoint:NSMakePoint(5.5, 7.5)];
        [NSBezierPath strokeLineFromPoint:NSMakePoint(14, 7.5) toPoint:NSMakePoint(9.5, 7.5)];
        [NSBezierPath strokeLineFromPoint:NSMakePoint(7.5, 1.5) toPoint:NSMakePoint(7.5, 14.5)];
        [I unlockFocus];
        cursor = [[NSCursor allocWithZone:[self zone]] initWithImage:I
                        hotSpot: NSMakePoint(7.5, 7.5)];
        NS_HANDLER
        cursor = [[NSCursor arrowCursor] retain];
		iTM2_LOG(@"***  EXCEPTION CATCHED: %@", [localException reason]);
        NS_ENDHANDLER
    }
    return cursor;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  verticalResizeCursor
+ (NSCursor *) verticalResizeCursor;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.3: Thu Jan 23 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    static NSCursor * cursor = nil;
    if(!cursor)
    {
        NSImage * I = [[[NSImage alloc] initWithSize:NSMakeSize(16, 16)] autorelease];
        NS_DURING
        [I lockFocus];
        [[NSColor blackColor] set];
        NSBezierPath * BP = [NSBezierPath bezierPath];
        [BP moveToPoint:NSMakePoint(7.5, 0)];
        [BP relativeLineToPoint:NSMakePoint(-3, 3.5)];
        [BP relativeLineToPoint:NSMakePoint(6, 0)];
        [BP relativeLineToPoint:NSMakePoint(-3, -3.5)];
        [BP closePath];
        [BP moveToPoint:NSMakePoint(7.5, 15)];
        [BP relativeLineToPoint:NSMakePoint(3, -3.5)];
        [BP relativeLineToPoint:NSMakePoint(-6, 0)];
        [BP relativeLineToPoint:NSMakePoint(3, 3.5)];
        [BP closePath];
        [BP fill];
        [NSBezierPath setDefaultLineWidth:1.5];
        [NSBezierPath strokeLineFromPoint:NSMakePoint(7.5, 1) toPoint:NSMakePoint(7.5, 5.5)];
        [NSBezierPath strokeLineFromPoint:NSMakePoint(7.5, 14) toPoint:NSMakePoint(7.5, 9.5)];
        [NSBezierPath strokeLineFromPoint:NSMakePoint(1.5, 7.5) toPoint:NSMakePoint(14.5, 7.5)];
        [I unlockFocus];
        cursor = [[NSCursor allocWithZone:[self zone]] initWithImage:I
                        hotSpot: NSMakePoint(7.5, 7.5)];
        NS_HANDLER
        cursor = [[NSCursor arrowCursor] retain];
		iTM2_LOG(@"***  EXCEPTION CATCHED: %@", [localException reason]);
        NS_ENDHANDLER
    }
    return cursor;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  whiteIBeamCursor
+ (NSCursor *) whiteIBeamCursor;
/*"Description forthcoming
- 1.4: Wed Dec 17 09:32:38 GMT 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	static NSCursor * cursor = nil;
	if(!cursor)
	{
		NSString * path = [[NSBundle iTM2FoundationBundle] pathForImageResource:@"iTM2WhiteIBeam"];
        if(path)
            cursor = [[NSCursor allocWithZone:[self zone]] initWithImage:
                    [[NSImage allocWithZone:[self zone]] initWithContentsOfFile:path]
                        hotSpot: [[NSCursor IBeamCursor] hotSpot]];
        else
        {
            iTM2_LOG(@"Could not create white I beam cursor...");
            cursor = [[NSCursor IBeamCursor] retain];
        }
	}
//iTM2_END;
    return cursor;
}
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  NSCursor(iTeXMac2)

