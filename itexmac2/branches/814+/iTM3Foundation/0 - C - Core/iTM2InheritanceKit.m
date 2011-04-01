/*
//
//  @version Subversion: $Id: iTM2InheritanceKit.m 401 2007-02-13 11:27:27Z jlaurens $ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Tue Mar 26 2002.
//  Copyright © 2005 Laurens'Tribune. All rights reserved.
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
//  Version history: (format "- date:contribution (contributor) ") 
//  To Do List: (format "- proposition (percentage actually done) ") 
*/


#import "iTM2InheritanceKit.h"

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2InheritanceKit
/*"Some properties are inherited from the view hierarchy."*/

@implementation NSObject(iTM2InheritanceKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inheritedValueForKey:
- (id)inheritedValueForKey:(NSString *)aKey;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return [self valueForKey:aKey];
}
@end

@implementation NSResponder(iTM2InheritanceKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inheritedValueForKey:
- (id)inheritedValueForKey:(NSString *)aKey;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	id result = [super inheritedValueForKey:aKey];
	if (result)
	{
		return result;
	}
	id helper = self.nextResponder;
	result = [helper inheritedValueForKey:aKey];
//END4iTM3;
    return result;
}
@end

@implementation NSWindowController(iTM2InheritanceKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inheritedValueForKey:
- (id)inheritedValueForKey:(NSString *)aKey;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	id result = [super inheritedValueForKey:aKey];
	if (result)
	{
		return result;
	}
	id helper = self.document;
	result = [helper inheritedValueForKey:aKey];
//END4iTM3;
    return result;
}
@end

@implementation NSWindow(iTM2InheritanceKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inheritedValueForKey:
- (id)inheritedValueForKey:(NSString *)aKey;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	id result = [super inheritedValueForKey:aKey];
	if (result)
	{
		return result;
	}
	id helper = self.delegate;
	result = [helper inheritedValueForKey:aKey];
	if (result)
	{
		return result;
	}
	helper = self.windowController;
	result = [helper inheritedValueForKey:aKey];
//END4iTM3;
    return result;
}
@end

@implementation NSView(iTM2InheritanceKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inheritedValueForKey:
- (id)inheritedValueForKey:(NSString *)aKey;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	id result = [super inheritedValueForKey:aKey];
	if (result)
	{
		return result;
	}
	id helper = self.superview;
	result = [helper inheritedValueForKey:aKey];
	if (result)
	{
		return result;
	}
	helper = self.window;
	result = [helper inheritedValueForKey:aKey];
//END4iTM3;
    return result;
}
@end

@implementation NSTextStorage(iTM2InheritanceKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inheritedValueForKey:
- (id)inheritedValueForKey:(NSString *)aKey;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
    return [super inheritedValueForKey:aKey]?:[self.layoutManagers.lastObject inheritedValueForKey:aKey];
}
@end

@implementation NSLayoutManager(iTM2InheritanceKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inheritedValueForKey:
- (id)inheritedValueForKey:(NSString *)aKey;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return [super inheritedValueForKey:aKey]?:[self.textContainers.lastObject inheritedValueForKey:aKey];
}
@end

@implementation NSTextContainer(iTM2InheritanceKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  inheritedValueForKey:
- (id)inheritedValueForKey:(NSString *)aKey;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
    return [super inheritedValueForKey:aKey]?:[self.textView inheritedValueForKey:aKey];
}
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2InheritanceKit
