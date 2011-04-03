/*
//  iTM2ExtensionManager.m
//  iTeXMac2
//
//  Created by jlaurens@users.sourceforge.net on Thu Jun 13 2002.
//  Copyright © 2001-2004 Laurens'Tribune. All rights reserved.
//
//  This program is free software; you can redistribute it and/or modify it under the terms
//  of the GNU General Public License as published by the Free Software Foundation; either
//  version 2 of the License, or any later version, modified by the addendum below.
//  This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
//  without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
//  See the GNU General Public License for more details. You should have received a copy
//  of the GNU General Public License along with this program; if not, write to the Free Software
//  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
//  GPL addendum:Any simple modification of the present code which purpose is to remove bug,
//  improve efficiency in both code execution and code reading or writing should be addressed
//  to the actual developper team.
//
//  Version history:(format "- date:contribution(contributor)") 
//  To Do List:(format "- proposition(percentage actually done)")
*/


#import <iTM2Foundation/iTM2MenuKit.h>
#import <iTM2Foundation/iTM2StringKit.h>
#import <iTM2Foundation/iTM2BundleKit.h>
#import <iTM2Foundation/iTM2ExtensionManager.h>
#import <iTM2Foundation/iTM2AppleScriptKit.h>
#import <iTM2Foundation/iTM2PathUtilities.h>

#define TABLE @"TeX"
NSString * const iTM2ExtensionComponent = @"Extensions.localized";
NSString * const iTM2AssistantsComponent = @"Assistants.localized";
NSString * const iTM2ExtensionExtension = @"iTM2";

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  iTM2ExtensionManager
/*"This is a semi abstract class."*/
@implementation iTM2ExtensionManager
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  init
- (id) init;
/*"Description forthcoming.
Version history:jlaurens@users.sourceforge.net
To Do List:
"*/
{
//START4iTM3;
    if(self = [super init]) {
        iVarExtensionDictionary4iTM3 = [NSMutableDictionary dictionary];
        [self setMenu:nil];
    }
    return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  registerExtension:forKey:
- (void) registerExtension:(id) object forKey:(NSString *) aKey;
/*"Description forthcoming.
Version history:jlaurens@users.sourceforge.net
To Do List:
"*/
{
//START4iTM3;
    if(object && aKey) {
        [iVarExtensionDictionary4iTM3 setObject:object forKey:aKey];
        NSLog(@"Assistant registered:%@", aKey);
    }
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  relativePath
- (NSString *) relativePath;
/*"Subclasses will override this.
Version history:jlaurens@users.sourceforge.net
To Do List:
"*/
{
//START4iTM3;
    return iTM2ExtensionComponent;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  setMenu:
- (NSMenu *) menu;
/*"Description forthcoming.
Version history:jlaurens@users.sourceforge.net
To Do List:
"*/
{
//START4iTM3;
    if(!iVarMenu4iTM3) [self loadTheExtensionWithError:NULL];
    return iVarMenu4iTM3;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  setMenu:
- (void) setMenu:(NSMenu *) argument;
/*"Description forthcoming.
Version history:jlaurens@users.sourceforge.net
Latest Revision:Fri Mar 26 20:21:48 UTC 2010
To Do List:
"*/
{
//START4iTM3;
    iVarMenu4iTM3 = argument;
    [iVarMenu4iTM3 deepMakeMenuItemTitlesSmall4iTM3];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  extensionMenuItemAtURL:error:
- (NSMenuItem *) extensionMenuItemAtURL:(NSURL *)url error:(NSError **)RORef;
/*"Description forthcoming.
Version history:jlaurens@users.sourceforge.net
Latest Revision:Fri Mar 26 20:22:45 UTC 2010
To Do List:
"*/
{
//START4iTM3;
    NSBundle * B = [NSBundle bundleWithURL:url];
    NSString * className = [[B infoDictionary] objectForKey:@"NSPrincipalClass"];
    if(NSClassFromString(className)) {
        LOG4iTM3(@"%@ Assistant at path %@ ignored (Duplicate class name)",
            NSStringFromClass(self.class), NSStringFromSelector(_cmd), path);
    } else {
        Class C = [B principalClass];
        id O = [[[C alloc] init] autorelease];
        if ([O respondsToSelector:@selector(menuItem)]) {
            NSMEnuItem * MI = [O menuItem];
            if (MI) {
                MI.representedObject = url;
                [self registerExtension:O forKey:url];
                return MI;
            }
        } else {
            LOG4iTM3(@"%@ Assistant at path %@ ignored (no menu item available)",
                NSStringFromClass(self.class), NSStringFromSelector(_cmd), path);
        }
    }
    return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  extensionMenuAtURL:error:
- (NSMenu *) extensionMenuAtURL:(NSURL *)URL error:(NSError **)RORef;
/*"Description forthcoming.
Version history:jlaurens@users.sourceforge.net
Latest Revision:Fri Mar 26 20:25:35 UTC 2010
To Do List:
"*/
{
//START4iTM3;
    NSMenu * M = [[NSMenu alloc] initWithTitle:URL.absoluteString];
    for (URL in [DFM contentsOfDirectoryAtURL:URL
        includingPropertiesForKeys:[NSArray array]
            options:NSDirectoryEnumerationSkipsSubdirectoryDescendants|NSDirectoryEnumerationSkipsHiddenFiles
                error:RORef]) {
        NSMenuItem * MI = [self extensionMenuItemAtURL:URL error:RORef];
        if(MI) [M addItem:MI];
    }
    return [M autorelease];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  loadTheExtensionWithError:
- (void) loadTheExtensionWithError:(NSError **)RORef;
/*"Description forthcoming.
Version history:jlaurens@users.sourceforge.net
Latest Revision:Fri Mar 26 20:34:02 UTC 2010
To Do List:
"*/
{
//START4iTM3;
    // we begin by loading the assistants defined in the network area.
    NSURL * URL = [[NSBundle mainBundle] URLForSupportDirectory4iTM3:self.relativePath inDomain:NSNetworkDomainMask create:NO];
    NSMenu * networkMenu = [self extensionMenuAtURL:URL error:RORef];
    [networkMenu setTitle:NSLocalizedStringFromTableInBundle (@"Network", TABLE, myBUNDLE, "Menu Item Title")];
    // we continue by loading the assistants defined in the local area.
    URL = [[NSBundle mainBundle] URLForSupportDirectory4iTM3:self.relativePath inDomain:NSLocalDomainMask create:NO];
    NSMenu * localMenu = [self extensionMenuAtURL:URL error:RORef];
    [localMenu setTitle:NSLocalizedStringFromTableInBundle (@"Local", TABLE, myBUNDLE, "Menu Item Title")];
    // we finish by loading the assistants defined in the local area.
    URL = [[NSBundle mainBundle] URLForSupportDirectory4iTM3:self.relativePath inDomain:NSUserDomainMask create:NO];
    NSMenu * userMenu = [self extensionMenuAtURL:URL error:RORef];
    [userMenu setTitle:NSLocalizedStringFromTableInBundle (@"User", TABLE, myBUNDLE, "Menu Item Title")];
    if(userMenu.itemArray.count) {
        if(localMenu.itemArray.count) {
            [userMenu addItemWithTitle:localMenu.title action:NULL keyEquivalent:[NSString string]];
            [userMenu.itemArray.lastObject setSubmenu:localMenu];
        }
        if(networkMenu.itemArray.count) {
            [userMenu addItemWithTitle:networkMenu.title action:NULL keyEquivalent:[NSString string]];
            [userMenu.itemArray.lastObject setSubmenu:networkMenu];
        }
        [self setMenu:userMenu];
    } else if(localMenu.itemArray.count) {
        if(networkMenu.itemArray.count) {
            [localMenu addItemWithTitle:networkMenu.title action:NULL keyEquivalent:[NSString string]];
            [localMenu.itemArray.lastObject setSubmenu:networkMenu];
        }
        [self setMenu:localMenu];
    } else if(networkMenu.itemArray.count) {
        [self setMenu:networkMenu];
    } else {
        NSString * title = NSLocalizedStringFromTableInBundle (@"No Plug In", TABLE, myBUNDLE, "Menu Item Title");
        id M = [[[NSMenu alloc] initWithTitle:title] autorelease];
        [M addItemWithTitle:title action:NULL keyEquivalent:@""];
        [self setMenu:M];
    }
    return;
}
@synthesize menu = iVarMenu4iTM3;
@synthesize extensionDictionary = iVarExtensionDictionary4iTM3;
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  iTM2AssistantManager
/*"Description forthcoming."*/
@implementation iTM2AssistantManager
static iTM2AssistantManager * _iTM2AssistantManager;
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  sharedAssistantManager
+ (id) sharedAssistantManager;
/*"Description forthcoming.
Version history:jlaurens@users.sourceforge.net
To Do List:
"*/
{
//START4iTM3;
    return _iTM2AssistantManager? :(_iTM2AssistantManager = [self.alloc init]);
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  relativePath
- (NSString *) relativePath;
/*"Description forthcoming.
Version history:jlaurens@users.sourceforge.net
To Do List:
"*/
{
//START4iTM3;
    return iTM2AssistantsComponent;
}
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  iTM2AssistantButton
/*"Description forthcoming."*/
@implementation iTM2AssistantButton
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  awakeFromNib
- (void) awakeFromNib;
/*"Description forthcoming.
Version history:jlaurens@users.sourceforge.net
To Do List:
"*/
{
//START4iTM3;
    [super awakeFromNib];
    [self setMenu:[[iTM2AssistantManager sharedAssistantManager] menu]];
    self.target = self;
    self.action = NULL;
    return;
}
@end

#import <iTM2Foundation/iTM2ContextKit.h>

@interface iTM2ScriptExtensionButton()
- (NSInteger) menu:(NSMenu *) M insertItemsAtPath:(NSString *) path atIndex:(NSInteger) index;
@end
#warning THE FOLLOWING IS FOR editor mode only, better design needed
//#import <iTM2Foundation/iTM2MacrosController.h>
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  iTM2ScriptExtensionButton
/*"Description forthcoming."*/
@implementation iTM2ScriptExtensionButton
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= willPopUp
- (BOOL) willPopUp;
/*"Description forthcoming.
Version history:jlaurens@users.sourceforge.net
- < 1.1:03/10/2002
To Do List:
"*/
{
//START4iTM3;
    if([self.menu numberOfItems] && !([[NSApp currentEvent] modifierFlags] & NSAlternateKeyMask))\
        return [super willPopUp];\
    [self setEnabled:YES];
    [self setImagePosition:NSImageOnly];
    NSMenu * M = [[[NSMenu alloc] initWithTitle:@""] autorelease];
    NSBundle * B = [NSBundle mainBundle];
    NSDocument * document = [self.window.windowController document];
    if(!document)
        document = [SDC currentDocument];
#warning ATTENTION, implementation missing
    NSString * mode = [document context4iTM3ValueForKey:@"textEditorMode"];
    NSString * subPath = [@"Editor" stringByAppendingPathComponent:mode];
    NSString * path = [[B pathEnumeratorForSupportName:@"Scripts" ofType:nil inDirectory:subPath domains:NSUserDomainMask] nextObject];
    NSInteger before = MIN(1, [M numberOfItems]);
    NSInteger after = [self menu:M insertItemsAtPath:path atIndex:before];
    if(after==before)
    {
        [M insertItemWithTitle:
            NSLocalizedStringFromTableInBundle(@"No user defined scripts", @"iTM2Scripts", B, "DF")
                action:NULL keyEquivalent:@"" atIndex:after++];
    }
    BOOL separatorNeeded = NO;
    NSInteger here = [M numberOfItems];
    NSMenu * MM = [[[NSMenu alloc] initWithTitle:@""] autorelease];
    path = [[B pathEnumeratorForSupportName:@"Scripts" ofType:nil inDirectory:subPath domains:NSLocalDomainMask] nextObject];
//NSLog(@"path:%@", path);
    if([self menu:MM insertItemsAtPath:path atIndex:ZER0])
    {
        separatorNeeded = YES;
        [[M insertItemWithTitle:
            NSLocalizedStringFromTableInBundle(@"Local", TABLE, B, "DF")
                action:NULL keyEquivalent:@"" atIndex:after++] setSubmenu:MM];
        MM = [[[NSMenu alloc] initWithTitle:@""] autorelease];
    }
    path = [[B pathEnumeratorForSupportName:@"Scripts" ofType:nil inDirectory:subPath domains:NSNetworkDomainMask] nextObject];
//NSLog(@"path:%@", path);
    if([self menu:MM insertItemsAtPath:path atIndex:ZER0])
    {
        separatorNeeded = YES;
        [[M insertItemWithTitle:
            NSLocalizedStringFromTableInBundle(@"Network", TABLE, B, "DF")
                action:NULL keyEquivalent:@"" atIndex:after++] setSubmenu:MM];
        MM = [[[NSMenu alloc] initWithTitle:@""] autorelease];
    }
    path = [myBUNDLE pathForResource:mode ofType:nil inDirectory:subPath];
//NSLog(@"path:%@", path);
    if([self menu:MM insertItemsAtPath:path atIndex:ZER0])
    {
        separatorNeeded = YES;
        [[M insertItemWithTitle:
            NSLocalizedStringFromTableInBundle(@"Built in", TABLE, B, "DF")
                action:NULL keyEquivalent:@"" atIndex:after++] setSubmenu:MM];
        MM = [[[NSMenu alloc] initWithTitle:@""] autorelease];
    }
    if(separatorNeeded)
        [M insertItem:[NSMenuItem separatorItem] atIndex:here];
    [M deepMakeMenuItemTitlesSmall4iTM3];
    [self setMenu:M];
    return [super willPopUp];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  menu:insertItemsAtPath:atIndex:
- (NSInteger) menu:(NSMenu *) M insertItemsAtPath:(NSString *) path atIndex:(NSInteger) index;
/*"Description forthcoming.
Version History:jlaurens@users.sourceforge.net
- 1.3:03/10/2002
To Do List:...
"*/
{
//START4iTM3;
//NSLog(@"path:%@", path);
    NSMenu * templateMenu = [[M copy] autorelease];
    while([templateMenu numberOfItems])
        [templateMenu removeItemAtIndex:ZER0];
//    NSFileManager * DFM = DFM;
    NSMutableArray * dirMenus = [NSMutableArray array];
    for(NSString * subpath in [DFM contentsOfDirectoryAtPath:path error:NULL])
    {
        if(![subpath hasPrefix:@"."] && ![subpath isEqual:@"CVS"])
        {
            BOOL isDirectory = NO;
            NSString * RO = [[path stringByAppendingPathComponent:subpath] stringByResolvingSymlinksAndFinderAliasesInPath4iTM3];
    //NSLog(@"\n\nRO:%@\n\n", RO);
            if([DFM fileExistsAtPath:RO isDirectory:&isDirectory])
            {
                if(isDirectory)
                {
                    NSMenu * menu = [[templateMenu copy] autorelease];
                    menu.title = subpath.stringByDeletingPathExtension;
                    if([self menu:menu insertItemsAtPath:RO atIndex:ZER0])
                        [dirMenus addObject:menu];
                }
                else
                {
                    NSMenuItem * MI = [M insertItemWithTitle:subpath
                        action:@selector(_action:) keyEquivalent:@"" atIndex:index];
                    MI.representedObject = RO;
                    MI.target = self;
                    ++index;
                }
            }
        }
    }
    for(NSMenu * menu in dirMenus)
        [[M insertItemWithTitle:menu.title action:NULL keyEquivalent:@"" atIndex:index++] setSubmenu:menu];
    return index;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  _action:
- (void) _action:(id) sender;
/*"Description forthcoming.
Version History:jlaurens@users.sourceforge.net
- 1.3:03/10/2002
To Do List:...
"*/
{
//START4iTM3;
    [iTM2AppleScriptLauncher
        performSelector:@selector(executeAppleScriptAtPath:)
            withObject:[sender representedString]
                afterDelay:ZER0];
    return;
}
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  iTM2AssistantManager

