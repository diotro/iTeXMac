/*
//  iTeXMac
//
//  @version Subversion: $Id: iTM2PreferencesKit.m 798 2009-10-12 19:32:06Z jlaurens $ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Mon Mar 04 2002.
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
//  Version history: (format "- date:contribution(contributor)") 
//  To Do List: (format "- proposition(percentage actually done)")
*/

#import "iTM2Implementation.h"
#import "iTM2BundleKit.h"
#import "iTM2Runtime.h"
#import "iTM2ValidationKit.h"
#import "iTM2PathUtilities.h"
#import "iTM2InstallationKit.h"

#import "iTM2ViewKit.h"

#import "iTM2PreferencesKit.h"

NSString * const iTM2LastPreferencePaneIdentifier = @"iTM2LastPreferencePaneIdentifier";

@interface iTM2PrefsController(PRIVATE)
- (id)prefPanes;
- (void)setPrefPanes:(id)argument;
- (NSString *)selectedPrefPaneIdentifier;
- (void)setSelectedPrefPaneIdentifier:(id)argument;// no side effect!
- (IBAction)takeSelectedPrefPaneFromIdentifier:(NSToolbarItem *)sender;
- (void)displayPrefsPaneWithIdentifier:(NSString *)identifier;
@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2PrefsController
/*"Description forthcoming."*/
@implementation iTM2PrefsController
static id _iTMSharedPrefsController = nil;
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= sharedPrefsController
+ (id)sharedPrefsController;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return _iTMSharedPrefsController? _iTMSharedPrefsController: //_iTMSharedPrefsController =
        [self.alloc initWithWindowNibName:NSStringFromClass(self)];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= initWithWindow:
- (id)initWithWindow:(NSWindow *)window;
/*"The first object inited is the shared one.
Designated initializer.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (_iTMSharedPrefsController)
    {
        if (![self isEqual:_iTMSharedPrefsController])
            self.release;
        return [_iTMSharedPrefsController retain];
    }
    else if (self = [super initWithWindow:window])
    {
        [self setWindowFrameAutosaveName:NSStringFromClass(self.class)];
		[self setPrefPanes:[NSDictionary dictionary]];
		[DNC addObserver:self
			selector: @selector(applicationWillTerminateNotified:)
				name: NSApplicationWillTerminateNotification
					object: nil];
    }
    return _iTMSharedPrefsController = self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= prefPanes
- (id)prefPanes;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: today
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    return metaGETTER;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= setPrefPanes:
- (void)setPrefPanes:(id)argument;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: today
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    metaSETTER([[argument mutableCopy] autorelease]);
//END4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= selectedPrefPaneIdentifier
- (NSString *)selectedPrefPaneIdentifier;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: today
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSString * result = metaGETTER;
//END4iTM3;
    return result.length? result:@"";
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= setSelectedPrefPaneIdentifier:
- (void)setSelectedPrefPaneIdentifier:(id)argument;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: today
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    metaSETTER([[argument mutableCopy] autorelease]);
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= loadPrefPanes
- (void)loadPrefPanes;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 03/10/2002
Latest Revision: Fri Jan 29 11:22:06 UTC 2010
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//LOG4iTM3(@"INFO: Loading the pref panes...START");
	NSBundle * MB = [NSBundle mainBundle];
	NSMutableArray * URLs = [NSMutableArray array];
	[URLs addObjectsFromArray:[MB availablePlugInURLsAtURL4iTM3:
		[MB URLForSupportDirectory4iTM3:iTM2SupportPluginsComponent inDomain:NSUserDomainMask create:YES]
				withExtension: @"prefPane"]];
	[URLs addObjectsFromArray:[MB availablePlugInURLsAtURL4iTM3:
		[MB URLForSupportDirectory4iTM3:iTM2SupportPluginsComponent inDomain:NSLocalDomainMask create:NO]
				withExtension: @"prefPane"]];
	[URLs addObjectsFromArray:[MB availablePlugInURLsAtURL4iTM3:
		[MB URLForSupportDirectory4iTM3:iTM2SupportPluginsComponent inDomain:NSNetworkDomainMask create:NO]
				withExtension: @"prefPane"]];
	[URLs addObjectsFromArray:[MB availablePlugInURLsAtURL4iTM3:
        [NSURL fileURLWithPath:MB.builtInPlugInsPath] withExtension:@"prefPane"]];
	while (YES) {
		for (NSURL * url in URLs.copy) {
//LOG4iTM3(@"Starting to load plug-in at path: %@", path);
			NSBundle * B = [NSBundle bundleWithPath:url.path];
			if (B && !B.isLoaded) {
				NSString * principalClassName = [[B infoDictionary] objectForKey:@"NSPrincipalClass"];
//LOG4iTM3(@"NSPrincipalClass is: %@", principalClassName);
				if (principalClassName.length) {
					if (NSClassFromString(principalClassName)) {
						LOG4iTM3(@"Pref pane plug-in ignored at path:\n%@\nPrincipal class conflict (%@)\nThis can be expected behaviour...", url.path, principalClassName);
						[URLs removeObject:url];
                        continue;
					} else {
						NSString * K = [NSString stringWithFormat:@"iTM2IgnorePlugin_%@", url.lastPathComponent.stringByDeletingPathExtension];
						if ([SUD boolForKey:K]) {
							LOG4iTM3(@"Pref pane plug-in at path\n%@ temporarily disabled, you can activate is from the terminal\nterminal% defaults delete comp.text.TeX.iTeXMac2 '%@'", url, K);
						} else {
                            //  Does this plugin need extra classes
                            //  NO by default:
							BOOL canLoad = YES;
							NSArray * requiredClasses = [[B infoDictionary] objectForKey:@"iTM2RequiredClasses"];
                            if ([requiredClasses isKindOfClass:[NSArray class]]) {
                                for (NSString * requiredClassName in requiredClasses) {
                                    if (!NSClassFromString(requiredClassName)) {
                                        canLoad = NO;
                                        LOG4iTM3(@"Pref pane plug-in: unable to load %@\nRequired class missing: %@ (bundle: %@)", B, requiredClassName, [NSBundle allBundles]);
                                        break;
                                    }
                                }
                            }
							if (canLoad) {
								if (B.load) {
									LOG4iTM3(@"Pref pane plug-in: loaded %@\nPrincipal class: %@\nIf this pref pane plug-in causes any kind of problem you can disable it from the terminal\nterminal\%% defaults write comp.text.TeX.iTeXMac2 '%@' '1'", B, principalClassName, K);
									Class C = [B principalClass];
									if ([C isSubclassOfClass:[NSPreferencePane class]])// + load message sent...
									{
										id prefPane = [[C alloc] initWithBundle:B];
										if (prefPane) {
											[self.prefPanes setObject:prefPane forKey:[prefPane prefPaneIdentifier]];
                                        }
									}
								} else {
									LOG4iTM3(@"Pref pane plug-in: unable to load %@\nPrincipal class: %@ ", B, principalClassName);
								}
								[URLs removeObject:url];
                                continue;
							} else {
								NS_DURING
								if (B.load) {
									LOG4iTM3(@"Pref pane plug-in: loaded %@\nPrincipal class: %@\nIf this plug-in causes any kind of problem you can disable it from the terminal\nterminal\%% defaults write comp.text.TeX.iTeXMac2 '%@' '1'", B, principalClassName, K);
									[B.principalClass class];
								} else {
									LOG4iTM3(@"Pref pane plug-in: unable to load %@\nPrincipal class: %@ ", B, principalClassName);
								}
								NS_HANDLER
								LOG4iTM3(@"Pref pane plug-in: unable to load %@\nPrincipal class: %@ ", B, principalClassName);
								NS_ENDHANDLER
								[URLs removeObject:url];
                                continue;
							}
						}
					}
				} else if (iTM2DebugEnabled) {
					LOG4iTM3(@"No principal class in bundle: %@", B);
					[URLs removeObject:url];
                    continue;
				}
			} else {
				[URLs removeObject:url];
                continue;
            }
		}
        break;
	}
//LOG4iTM3(@"INFO: Pref pane plug-ins loaded.");
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= preparePrefPanesWindowDidLoad4iTM3
- (void)preparePrefPanesWindowDidLoad4iTM3;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: today
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSMutableDictionary * MD = [NSMutableDictionary dictionary];
	// Start by recovering all the NSPreferencePane subclasses
	NSPointerArray * PA = [iTM2Runtime subclassReferencesOfClass:[NSPreferencePane class]];
	NSUInteger i = PA.count;
	while (i--) {
		Class C = (Class)[PA pointerAtIndex:i];
		id pane = [[C alloc] initWithBundle:nil];
		if (pane) {
			NSString * identifier = [pane prefPaneIdentifier];
			if (identifier.length) {
				[MD setObject:pane forKey:identifier];
			} else {
				DEBUGLOG4iTM3(0,@"No identifier available for pane: %@", pane);
			}
		} else {
			LOG4iTM3(@"No pane available for class: %@", NSStringFromClass(C));
		}
	}
	[self setPrefPanes:MD];// a copy is stored by the receiver
	// then recover all the .prefPanes in the standard locations
	self.loadPrefPanes;
//END4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= prefsControllerWindowDidLoad4iTM3
- (void)prefsControllerWindowDidLoad4iTM3;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: today
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[self.window makeKeyAndOrderFront:self];
//END4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= applicationWillTerminateNotified:
- (void)applicationWillTerminateNotified:(NSNotification *)aNotification;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: today
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[self takeSelectedPrefPaneFromIdentifier:nil];
//END4iTM3;
	return;
}
#pragma mark =-=-=-=-=-  TOOLBAR
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= setUpToolbarWindowDidLoad4iTM3
- (void)setUpToolbarWindowDidLoad4iTM3;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: today
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    NSToolbar * toolbar = [[[NSToolbar alloc] initWithIdentifier:NSStringFromClass(self.class)] autorelease];
	[toolbar setAutosavesConfiguration:NO];
    [toolbar setAllowsUserCustomization:NO];
    [toolbar setVisible:YES];
	[toolbar setDisplayMode:NSToolbarDisplayModeIconAndLabel];
    toolbar.delegate = self;
    [self.window setToolbar:toolbar];
	[self.window setShowsToolbarButton:NO];
	NSString * lastIdentifier = [SUD stringForKey:iTM2LastPreferencePaneIdentifier];
	if (lastIdentifier.length && [self.prefPanes objectForKey:lastIdentifier])
	{
		NSEnumerator * E = [toolbar.items objectEnumerator];
		NSToolbarItem * TI;
		while(TI = [E nextObject])
		{
			if ([[TI itemIdentifier] isEqual:lastIdentifier])
			{
				[toolbar setSelectedItemIdentifier:lastIdentifier];
				[self takeSelectedPrefPaneFromIdentifier:TI]; 
				return;
			}
		}
	}
	NSToolbarItem * TI = [[toolbar.items objectEnumerator] nextObject];
	if (TI)
	{
		[self takeSelectedPrefPaneFromIdentifier:TI]; 
	}
//END4iTM3;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= toolbarDefaultItemIdentifiers:
- (NSArray *)toolbarDefaultItemIdentifiers:(NSToolbar*)aToolbar;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSArray * result = [[self.prefPanes allKeys] sortedArrayUsingSelector:@selector(compare:)];
//END4iTM3;
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= toolbarAllowedItemIdentifiers:
- (NSArray *)toolbarAllowedItemIdentifiers:(NSToolbar*)aToolbar;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return [self toolbarDefaultItemIdentifiers:aToolbar];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= toolbarSelectableItemIdentifiers:
- (NSArray *)toolbarSelectableItemIdentifiers:(NSToolbar *) aToolbar
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return [self toolbarDefaultItemIdentifiers:aToolbar];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= toolbar:itemForItemIdentifier:willBeInsertedIntoToolbar:
- (NSToolbarItem *)toolbar:(NSToolbar *)aToolbar itemForItemIdentifier:(NSString *)anItemIdentifier willBeInsertedIntoToolbar:(BOOL)aFlag;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSPreferencePane * prefPane = [self.prefPanes objectForKey:anItemIdentifier];
	if (!prefPane)
		return nil;
    NSToolbarItem * result = [[[NSToolbarItem alloc] initWithItemIdentifier:anItemIdentifier] autorelease];
	result.label = prefPane.iconLabel;
	result.image = prefPane.iconImage;
	result.target = self;
	result.action = @selector(takeSelectedPrefPaneFromIdentifier:);
//END4iTM3;
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= takeSelectedPrefPaneFromIdentifier:
- (IBAction)takeSelectedPrefPaneFromIdentifier:(NSToolbarItem *)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSPreferencePane * old = [self.prefPanes objectForKey:self.selectedPrefPaneIdentifier];
	if (old)
	{
		switch([old shouldUnselect])
		{
			case NSUnselectNow:
				goto unselectNow;
			case NSUnselectLater:
				[self setSelectedPrefPaneIdentifier:[sender itemIdentifier]];// will be used to switch to the proper pane
				[DNC removeObserver:self name:NSPreferencePaneDoUnselectNotification object:nil];
				[DNC addObserver:self selector:@selector(preferencePaneDoUnselectNotified:) name:NSPreferencePaneDoUnselectNotification object:old];
				[DNC removeObserver:self name:NSPreferencePaneCancelUnselectNotification object:nil];
				[DNC addObserver:self selector:@selector(preferencePaneCancelUnselectNotified:) name:NSPreferencePaneCancelUnselectNotification object:old];
			default:case NSUnselectCancel:
				return;
		}
	}
unselectNow:;
	NSString * newIdentifier = [sender itemIdentifier];
	[self displayPrefsPaneWithIdentifier:(newIdentifier.length? newIdentifier:@"")];
//END4iTM3;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= displayPrefsPaneWithIdentifier:
- (void)displayPrefsPaneWithIdentifier:(NSString *)identifier;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/10/2002
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSWindow * W = self.window;
	[W orderFront:self];
	NSPreferencePane * old = [self.prefPanes objectForKey:self.selectedPrefPaneIdentifier];
	[old willUnselect];
	NSPreferencePane * new = [self.prefPanes objectForKey:(identifier.length? identifier:@"")];
	[new willSelect];
	
	NSView * V = [old mainView];
	NSView * container = [V superview];
	if (container)
	{
		[V removeFromSuperviewWithoutNeedingDisplay];
	}
	else
	{
		container = self.window.contentView;
	}
	// inserting the new view
	if ((V = [new mainView]) || (V = [new loadMainView]))
	{
		// The idea is to resize the window such that the new view will fit
		
		NSRect containerRect = [container bounds];
		containerRect = [container convertRect:containerRect toView:nil];
		NSRect VRect = V.frame;
		VRect = [container convertRect:VRect toView:nil];
		
		CGFloat deltaHeight = VRect.size.height - containerRect.size.height;
		CGFloat deltaWidth = VRect.size.width - containerRect.size.width;
		if (deltaWidth<0)
			deltaWidth = 0;
		NSRect newWindowFrame = self.window.frame;
		newWindowFrame.size.height += deltaHeight;
		newWindowFrame.origin.y -= deltaHeight;
		newWindowFrame.size.width += deltaWidth;
		[W setFrame:newWindowFrame display:YES animate:YES];
		NSSize size = [W.contentView frame].size;
		size.width = V.frame.size.width;
		[W setContentMinSize:size];
		size.width *= 100;
		[W setContentMaxSize:size];
		[container addSubview:V];
		[container setAutoresizesSubviews:YES];
		[V setAutoresizingMask:NSViewMinXMargin|NSViewMaxXMargin|NSViewMinYMargin|NSViewMaxYMargin];
		[V centerInSuperview];
		if ([[new initialKeyView] acceptsFirstResponder])
		{
			[W makeFirstResponder:[new initialKeyView]];
		}
		[V validateWindowContent4iTM3];
	}
	[old didUnselect];
	[new didSelect];
	[self setSelectedPrefPaneIdentifier:[new prefPaneIdentifier]];
	[[W toolbar] setSelectedItemIdentifier:self.selectedPrefPaneIdentifier];
//START4iTM3;
    return;
}
@end

#pragma mark -
#import "iTM2ResponderKit.h"

@implementation iTM2SharedResponder(PreferencesKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= showPreferences:
- (IBAction)showPreferences:(id)irrelevant;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 09/21/2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[[[iTM2PrefsController sharedPrefsController] window] orderFront:irrelevant];
//END4iTM3;
    return;
}
@end

#pragma mark -
#import "iTM2BundleKit.h"

@implementation NSPreferencePane(iTeXMac2)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= prefPaneIdentifierForBundle:
+ (NSString *)prefPaneIdentifierForBundle:(NSBundle *)aBundle;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 09/21/2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSArray * components = [[aBundle bundleIdentifier] componentsSeparatedByString:@"prefPane."];
//END4iTM3;
    return components.count>1? components.lastObject:@"";
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iconImageForBundle:
+ (NSImage *)iconImageForBundle:(NSBundle *)aBundle;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 09/21/2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (!aBundle)
		return nil;
	NSString * iconName = [[aBundle infoDictionary] objectForKey:@"NSPrefPaneIconFile"];
	if (iconName.length)
	{
		NSString * iconPath = [aBundle pathForImageResource:iconName];
		if (iconPath.length)
		{
			NSImage * result = [[[NSImage alloc] initWithContentsOfFile:iconPath] autorelease];
			if (result)
			{
				return result;
			}
			else
			{
				LOG4iTM3(@"Bad icon file in the pref pane bundle: %@", aBundle);
			}
		}
		else
		{
			LOG4iTM3(@"Bad icon name in the pref pane bundle: %@", aBundle);
		}
	}
	else
	{
		LOG4iTM3(@"Missing icon name in the pref pane bundle: %@", aBundle);
	}
//END4iTM3;
    return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iconLabelForBundle:
+ (NSString *)iconLabelForBundle:(NSBundle *)aBundle;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 09/21/2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (!aBundle)
		return @"";
	else
		return [aBundle objectForInfoDictionaryKey:@"NSPrefPaneIconLabel"];
//END4iTM3;
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
    return [self.class prefPaneIdentifierForBundle:self.bundle];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iconImage
- (NSImage *)iconImage;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 09/21/2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	NSImage * result = [self.class iconImageForBundle:self.bundle];
	if (result)
		return result;
	NSBundle * B = self.classBundle4iTM3;
	NSString * iconPath = [B pathForImageResource:NSStringFromClass(self.class)];
	if (iconPath.length)
	{
		NSImage * result = [[[NSImage alloc] initWithContentsOfFile:iconPath] autorelease];
		if (result)
		{
			return result;
		}
		else
		{
			LOG4iTM3(@"Bad icon file in the pref pane bundle: %@", B);
		}
	}
	else
	{
		LOG4iTM3(@"Bad icon name in the pref pane bundle: %@", B);
	}
	B = [iTM2PrefsController classBundle4iTM3];
	iconPath = [B pathForImageResource:@"iTM2GenericPrefPane"];
	if (iconPath.length)
	{
		NSImage * result = [[[NSImage alloc] initWithContentsOfFile:iconPath] autorelease];
		if (result)
		{
			return result;
		}
		else
		{
			LOG4iTM3(@"Bad pref pane generic icon file in bundle: %@", B);
		}
	}
	else
	{
		LOG4iTM3(@"Missing pref pane generic icon file in bundle: %@", B);
	}
//END4iTM3;
    return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iconLabel
- (NSString *)iconLabel;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 09/21/2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
	NSString * result = [self.class iconLabelForBundle:self.bundle];
	if (result.length)
		return result;
	return NSLocalizedStringFromTableInBundle(@"NSPrefPaneIconLabel", NSStringFromClass(self.class), self.classBundle4iTM3, "Comment forthcoming");
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= SWZ_iTM2PreferenceKit_loadMainView
- (NSView *)SWZ_iTM2PreferenceKit_loadMainView;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 09/21/2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	if (self.bundle) {
		return [self SWZ_iTM2PreferenceKit_loadMainView];
    }
	if ([NSBundle loadNibNamed:NSStringFromClass(self.class) owner:self]) {
//END4iTM3;
		self.assignMainView;
		return self.mainView;
	} else {
		LOG4iTM3(@"..........  ERROR: Missing a nib for this preference pane (%@)...",NSStringFromClass(self.class));
//END4iTM3;
		return nil;
	}
}
@end

@implementation iTM2PreferencePane
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  initWithBundle:
- (id)initWithBundle:(NSBundle *)aBundle;
/*"Designated intializer.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
    if (self = [super initWithBundle:aBundle])
    {
        self.initImplementation;
    }
    return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  willUnselect
- (void)willUnselect;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
	[super willUnselect];
	[SUD synchronize];
    return;
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
@synthesize _Implementation;
@end

#if 0
#pragma mark -
#pragma mark THIS IS FOR TEST PURPOSE ONLY
@interface iTM2PreferencePane0: NSPreferencePane
@end
@implementation iTM2PreferencePane0
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
    return @"prefPane.0text";
}
@end
@interface iTM2PreferencePane1: NSPreferencePane
@end
@implementation iTM2PreferencePane1
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
    return @"prefPane.pdf";
}
@end
@interface iTM2PreferencePane2: NSPreferencePane
@end
@implementation iTM2PreferencePane2
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
    return @"prefPane.2text";
}
@end
#endif
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2PrefsController

@implementation iTM2PrefsWindow
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= handlesKeyBindings4iTM3
- (BOOL)handlesKeyBindings4iTM3;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 09/21/2005
To Do List:
"*/
{DIAGNOSTIC4iTM3;
//START4iTM3;
//END4iTM3;
    return YES;
}
@end

@implementation iTM2MainInstaller(PreferencesKit)
+ (void)preparePreferencesKitCompleteInstallation4iTM3;
{
	if ([NSPreferencePane swizzleInstanceMethodSelector4iTM3:@selector(SWZ_iTM2PreferenceKit_loadMainView) error:NULL])
	{
		MILESTONE4iTM3((@"NSPreferencePane(iTeXMac2)@"),(@"..........  ERROR: Bad configuration, things won't work as expected..."));
	}
}
@end

