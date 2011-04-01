/*
//
//  @version Subversion: $Id:$ 
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

#import "iTM2DocumentPrefPane.h"
#import "iTeXMac2.h"

NSString * const iTM2AutosaveThresholdTransformerName = @"iTM2AutosaveThreshold";
NSString * const iTM2LevelsOfUndoThresholdTransformerName = @"iTM2LevelsOfUndoThreshold";

@interface iTM2AutosaveThresholdTransformer: NSValueTransformer
@end

@interface iTM2LevelsOfUndoThresholdTransformer: NSValueTransformer
@end

@implementation iTM2DocumentPrefPane
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= initialize
+ (void)initialize;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 09/21/2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[super initialize];
    id transformer = [[[iTM2AutosaveThresholdTransformer alloc] init] autorelease];
    [NSValueTransformer setValueTransformer:transformer forName:iTM2AutosaveThresholdTransformerName];
    transformer = [[[iTM2LevelsOfUndoThresholdTransformer alloc] init] autorelease];
    [NSValueTransformer setValueTransformer:transformer forName:iTM2LevelsOfUndoThresholdTransformerName];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= prefPaneIdentifier
- (NSString *)prefPaneIdentifier;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 09/21/2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return @"3.Document";
}
@end

#import "math.h"

@implementation iTM2AutosaveThresholdTransformer
+ (Class)transformedValueClass;{ return [NSNumber class]; }
+ (BOOL)allowsReverseTransformation;{ return YES; }
- (id)transformedValue:(id)value;
{
	if ([value isKindOfClass:[NSNumber class]]) {
		CGFloat f = [value floatValue];
		// 60=1*60->0
		// 120=2*60 -> 1
		// 240=4*60 -> 2
		// 480=8*60 -> 3
		// 960=16*60 -> 4
		// 1860=31*60 -> infty
		if ((f<=0) || (f>=1900)) {
			f = 5;
		} else if (f<=60) {
			f = 0;
		} else {
			f = log2f(f/60);
		}
		return [NSNumber numberWithFloat:f];
	}
    return nil;
}
- (id)reverseTransformedValue:(id)value;
{
	if ([value isKindOfClass:[NSNumber class]]) {
		CGFloat f = [value floatValue];
		if (f>=4.9) {
			f = 0;
		} else {
			f = 60 * powf(2,f);
		}
		return [NSNumber numberWithFloat:f];
	}
    return nil;
}
@end

@implementation iTM2LevelsOfUndoThresholdTransformer
+ (Class)transformedValueClass;{ return [NSNumber class]; }
+ (BOOL)allowsReverseTransformation;{ return YES; }
- (id)transformedValue:(id)value;
{
	if ([value isKindOfClass:[NSNumber class]]) {
		CGFloat f = [value floatValue];
		// 1->0
		// 10=1*10 -> 1
		// 20=2*10 -> 2
		// 40=4*10 -> 3
		// 80=8*10 -> 4
		// infty=15*10 -> infty
		if ((f<1) || (f>=150)) {
			f = 5;
		} else if (f<=10) {
			f = (f-1)/9;
		} else {
			f = log2f(f/5);
		}
		return [NSNumber numberWithFloat:f];
	}
    return nil;
}
- (id)reverseTransformedValue:(id)value;
{
	if ([value isKindOfClass:[NSNumber class]]) {
		CGFloat f = [value floatValue];
		if (f>=4.9) {
			f = 0;
		} else if (f<=1) {
			f = 1+9*f;
		} else {
			f = 5 * powf(2,f);
		}
		NSUInteger i = f;
		return [NSNumber numberWithUnsignedInteger:i];
	}
    return nil;
}
@end
