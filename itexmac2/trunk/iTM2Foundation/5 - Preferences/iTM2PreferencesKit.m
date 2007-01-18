/*
//  iTeXMac
//
//  @version Subversion: $Id$ 
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

#import <iTM2Foundation/iTM2PreferencesKit.h>
#import <iTM2Foundation/iTM2Implementation.h>
#import <iTM2Foundation/iTM2BundleKit.h>
#import <iTM2Foundation/iTM2RuntimeBrowser.h>
#import <iTM2Foundation/iTM2ViewKit.h>
#import <iTM2Foundation/iTM2ValidationKit.h>

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
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return _iTMSharedPrefsController? _iTMSharedPrefsController: //_iTMSharedPrefsController =
        [[self allocWithZone:[NSApp zone]] initWithWindowNibName:NSStringFromClass(self)];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= initWithWindow:
- (id)initWithWindow:(NSWindow *)window;
/*"The first object inited is the shared one.
Designated initializer.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/26/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(_iTMSharedPrefsController)
    {
        if(![self isEqual:_iTMSharedPrefsController])
            [self release];
        return [_iTMSharedPrefsController retain];
    }
    else if(self = [super initWithWindow:window])
    {
        [self setWindowFrameAutosaveName:NSStringFromClass([self class])];
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
    return metaGETTER;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= setPrefPanes:
- (void)setPrefPanes:(id)argument;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: today
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    metaSETTER([[argument mutableCopy] autorelease]);
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= selectedPrefPaneIdentifier
- (NSString *)selectedPrefPaneIdentifier;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: today
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSString * result = metaGETTER;
//iTM2_END;
    return [result length]? result:@"";
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= setSelectedPrefPaneIdentifier:
- (void)setSelectedPrefPaneIdentifier:(id)argument;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: today
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    metaSETTER([[argument mutableCopy] autorelease]);
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= loadPrefPanes
- (void)loadPrefPanes;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_LOG(@"INFO: Loading the pref panes...START");
	NSBundle * mainBundle = [NSBundle mainBundle];
	NSMutableArray * paths = [NSMutableArray array];
	[paths addObjectsFromArray:[[mainBundle class] availablePlugInPathsAtPath:
		[[mainBundle class] pathForSupportDirectory:iTM2SupportPluginsComponent inDomain:NSUserDomainMask
			withName: [mainBundle bundleName] create:YES]
				ofType: @"prefPane"]];
	[paths addObjectsFromArray:[[mainBundle class] availablePlugInPathsAtPath:
		[[mainBundle class] pathForSupportDirectory:iTM2SupportPluginsComponent inDomain:NSLocalDomainMask
			withName: [mainBundle bundleName] create:NO]
				ofType: @"prefPane"]];
	[paths addObjectsFromArray:[[mainBundle class] availablePlugInPathsAtPath:
		[[mainBundle class] pathForSupportDirectory:iTM2SupportPluginsComponent inDomain:NSNetworkDomainMask
			withName: [mainBundle bundleName] create:NO]
				ofType: @"prefPane"]];
	[paths addObjectsFromArray:[[mainBundle class] availablePlugInPathsAtPath:[mainBundle builtInPlugInsPath] ofType:@"prefPane"]];
	int newCount = [paths count];
	int oldCount;
	do
	{
		oldCount = newCount;
		NSEnumerator * E = [[[paths copy] autorelease] objectEnumerator];
		NSString * path;
		while(path = [E nextObject])
		{
//iTM2_LOG(@"Starting to load plug-in at path: %@", path);
			NSBundle * B = [NSBundle bundleWithPath:path];
			if(B && ![B isLoaded])
			{
				NSString * principalClassName = [[[[B infoDictionary] objectForKey:@"NSPrincipalClass"] retain] autorelease];
//iTM2_LOG(@"NSPrincipalClass is: %@", principalClassName);
				if([principalClassName length])
				{
					if(NSClassFromString(principalClassName))
					{
						iTM2_LOG(@"Pref pane plug-in ignored at path:\n%@\nPrincipal class conflict (%@)\nThis can be expected behaviour...", path, principalClassName);
						[paths removeObject:path];
					}
					else
					{
						NSString * K = [NSString stringWithFormat:@"iTM2IgnorePlugin_%@", [[path lastPathComponent] stringByDeletingPathExtension]];
						if([SUD boolForKey:K])
						{
							iTM2_LOG(@"Pref pane plug-in at path\n%@ temporarily disabled, you can activate is from the terminal\nterminal% defaults delete comp.text.TeX.iTeXMac2 '%@'", path, K);
						}
						else
						{
							NSArray * requiredClasses = [[B infoDictionary] objectForKey:@"iTM2RequiredClasses"];
							NSEnumerator * ee = [requiredClasses isKindOfClass:[NSArray class]]?
													[requiredClasses objectEnumerator]:nil;
							NSString * requiredClassName;
							BOOL canLoad = YES;
							while(requiredClassName = [ee nextObject])
								if(!NSClassFromString(requiredClassName))
								{
									canLoad = NO;
									iTM2_LOG(@"Pref pane plug-in: unable to load %@\nRequired class missing: %@ (bundle: %@)", B, requiredClassName, [NSBundle allBundles]);
									break;
								}
							if(canLoad)
							{
								if([B load])
								{
									iTM2_LOG(@"Pref pane plug-in: loaded %@\nPrincipal class: %@\nIf this pref pane plug-in causes any kind of problem you can disable it from the terminal\nterminal\%% defaults write comp.text.TeX.iTeXMac2 '%@' '1'", B, principalClassName, K);
									Class prefPaneClass = [B principalClass];
									if([prefPaneClass isSubclassOfClass:[NSPreferencePane class]])// + load message sent...
									{
										id prefPane = [[[prefPaneClass allocWithZone:[self zone]] initWithBundle:B] autorelease];
										if(prefPane)
											[[self prefPanes] setObject:prefPane forKey:[prefPane prefPaneIdentifier]];
									}
								}
								else
								{
									iTM2_LOG(@"Pref pane plug-in: unable to load %@\nPrincipal class: %@ ", B, principalClassName);
								}
								[paths removeObject:path];
							}
							else
							{
								NS_DURING
								if([B load])
								{
									iTM2_LOG(@"Pref pane plug-in: loaded %@\nPrincipal class: %@\nIf this plug-in causes any kind of problem you can disable it from the terminal\nterminal\%% defaults write comp.text.TeX.iTeXMac2 '%@' '1'", B, principalClassName, K);
									[[B principalClass] class];
								}
								else
								{
									iTM2_LOG(@"Pref pane plug-in: unable to load %@\nPrincipal class: %@ ", B, principalClassName);
								}
								NS_HANDLER
								iTM2_LOG(@"Pref pane plug-in: unable to load %@\nPrincipal class: %@ ", B, principalClassName);
								NS_ENDHANDLER
								[paths removeObject:path];
							}
						}
					}
				}
				else if(iTM2DebugEnabled)
				{
					iTM2_LOG(@"No principal class in bundle: %@", B);
					[paths removeObject:path];
				}
			}
			else
				[paths removeObject:path];
		}
		newCount = [paths count];
	}
	while(newCount < oldCount);
//iTM2_LOG(@"INFO: Pref pane plug-ins loaded.");
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= preparePrefPanesWindowDidLoad
- (void)preparePrefPanesWindowDidLoad;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: today
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSMutableDictionary * MD = [NSMutableDictionary dictionary];
	// Start by recovering all the NSPreferencePane subclasses
	NSEnumerator * E = [[iTM2RuntimeBrowser subclassReferencesOfClass:[NSPreferencePane class]] objectEnumerator];
	Class prefPaneClass;
	while(prefPaneClass = (Class)[[E nextObject] nonretainedObjectValue])
	{
		id pane = [[[prefPaneClass allocWithZone:[self zone]] initWithBundle:nil] autorelease];
		if(pane)
		{
			NSString * identifier = [pane prefPaneIdentifier];
			if([identifier length])
			{
				[MD setObject:pane forKey:identifier];
			}
			else
			{
				iTM2_LOG(@"No identifier available for pane: %@", pane);
			}
		}
		else
		{
			iTM2_LOG(@"No pane available for class: %@", NSStringFromClass(prefPaneClass));
		}
	}
	[self setPrefPanes:MD];// a copy is stored by the receiver
	// then recover all the .prefPanes in the standard locations
	[self loadPrefPanes];
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= prefsControllerWindowDidLoad
- (void)prefsControllerWindowDidLoad;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: today
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[[self window] makeKeyAndOrderFront:self];
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= applicationWillTerminateNotified:
- (void)applicationWillTerminateNotified:(NSNotification *)aNotification;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: today
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self takeSelectedPrefPaneFromIdentifier:nil];
//iTM2_END;
	return;
}
#pragma mark =-=-=-=-=-  TOOLBAR
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= setUpToolbarWindowDidLoad
- (void)setUpToolbarWindowDidLoad;
/*"Description forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: today
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
    NSToolbar * toolbar = [[[NSToolbar alloc] initWithIdentifier:NSStringFromClass([self class])] autorelease];
	[toolbar setAutosavesConfiguration:NO];
    [toolbar setAllowsUserCustomization:NO];
    [toolbar setVisible:YES];
	[toolbar setDisplayMode:NSToolbarDisplayModeIconAndLabel];
    [toolbar setDelegate:self];
    [[self window] setToolbar:toolbar];
	[[self window] setShowsToolbarButton:NO];
	NSString * lastIdentifier = [SUD stringForKey:iTM2LastPreferencePaneIdentifier];
	if([lastIdentifier length] && [[self prefPanes] objectForKey:lastIdentifier])
	{
		NSEnumerator * E = [[toolbar items] objectEnumerator];
		NSToolbarItem * TI;
		while(TI = [E nextObject])
		{
			if([[TI itemIdentifier] isEqual:lastIdentifier])
			{
				[toolbar setSelectedItemIdentifier:lastIdentifier];
				[self takeSelectedPrefPaneFromIdentifier:TI]; 
				return;
			}
		}
	}
	NSToolbarItem * TI = [[[toolbar items] objectEnumerator] nextObject];
	if(TI)
	{
		[self takeSelectedPrefPaneFromIdentifier:TI]; 
	}
//iTM2_END;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= toolbarDefaultItemIdentifiers:
- (NSArray *)toolbarDefaultItemIdentifiers:(NSToolbar*)aToolbar;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSArray * result = [[[self prefPanes] allKeys] sortedArrayUsingSelector:@selector(compare:)];
//iTM2_END;
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= toolbarAllowedItemIdentifiers:
- (NSArray *)toolbarAllowedItemIdentifiers:(NSToolbar*)aToolbar;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return [self toolbarDefaultItemIdentifiers:aToolbar];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= toolbarSelectableItemIdentifiers:
- (NSArray *)toolbarSelectableItemIdentifiers:(NSToolbar *) aToolbar
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return [self toolbarDefaultItemIdentifiers:aToolbar];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= toolbar:itemForItemIdentifier:willBeInsertedIntoToolbar:
- (NSToolbarItem *)toolbar:(NSToolbar *)aToolbar itemForItemIdentifier:(NSString *)anItemIdentifier willBeInsertedIntoToolbar:(BOOL)aFlag;
/*"Description forthcoming.
Version History: jlaurens AT users DOT sourceforge DOT net
- < 1.1: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSPreferencePane * prefPane = [[self prefPanes] objectForKey:anItemIdentifier];
	if(!prefPane)
		return nil;
    NSToolbarItem * result = [[[NSToolbarItem alloc] initWithItemIdentifier:anItemIdentifier] autorelease];
	[result setLabel:[prefPane iconLabel]];
	[result setImage:[prefPane iconImage]];
	[result setTarget:self];
	[result setAction:@selector(takeSelectedPrefPaneFromIdentifier:)];
//iTM2_END;
    return result;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= takeSelectedPrefPaneFromIdentifier:
- (IBAction)takeSelectedPrefPaneFromIdentifier:(NSToolbarItem *)sender;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSPreferencePane * old = [[self prefPanes] objectForKey:[self selectedPrefPaneIdentifier]];
	if(old)
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
	[self displayPrefsPaneWithIdentifier:([newIdentifier length]? newIdentifier:@"")];
//iTM2_END;
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= displayPrefsPaneWithIdentifier:
- (void)displayPrefsPaneWithIdentifier:(NSString *)identifier;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 1.1.a6: 03/10/2002
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[[self window] orderFront:self];
	NSPreferencePane * old = [[self prefPanes] objectForKey:[self selectedPrefPaneIdentifier]];
	[old willUnselect];
	NSPreferencePane * new = [[self prefPanes] objectForKey:([identifier length]? identifier:@"")];
	[new willSelect];
	
	NSView * V = [old mainView];
	NSView * container = [V superview];
	if(container)
	{
		[V removeFromSuperviewWithoutNeedingDisplay];
	}
	else
	{
		container = [[self window] contentView];
	}
	// inserting the new view
	if((V = [new mainView]) || (V = [new loadMainView]))
	{
		float deltaHeight = [V frame].size.height - [container frame].size.height;
		float deltaWidth = [V frame].size.width - [container frame].size.width;
		if(deltaWidth<0)
			deltaWidth = 0;
		NSRect newWindowFrame = [[self window] frame];
		newWindowFrame.size.height += deltaHeight;
		newWindowFrame.origin.y -= deltaHeight;
		newWindowFrame.size.width += deltaWidth;
		[[self window] setFrame:newWindowFrame display:YES animate:YES];
		NSSize size = [[[self window] contentView] frame].size;
		size.width = [V frame].size.width;
		[[self window] setContentMinSize:size];
		size.width *= 100;
		[[self window] setContentMaxSize:size];
		[container addSubview:V];
		[container setAutoresizesSubviews:YES];
		[V centerInSuperview];
		[V setAutoresizingMask:NSViewMinXMargin|NSViewMaxXMargin|NSViewMinYMargin|NSViewMaxYMargin];
		[[V window] makeFirstResponder:[new initialKeyView]];
		[V validateWindowContent];
	}
	[old didUnselect];
	[new didSelect];
	[self setSelectedPrefPaneIdentifier:[new prefPaneIdentifier]];
	[[[self window] toolbar] setSelectedItemIdentifier:[self selectedPrefPaneIdentifier]];
//iTM2_START;
    return;
}
@end

#pragma mark -
#import <iTM2Foundation/iTM2ResponderKit.h>

@implementation iTM2SharedResponder(PreferencesKit)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= showPreferences:
- (IBAction)showPreferences:(id)irrelevant;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 09/21/2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[[[iTM2PrefsController sharedPrefsController] window] orderFront:irrelevant];
//iTM2_END;
    return;
}
@end

#pragma mark -
#import <iTM2Foundation/iTM2BundleKit.h>

@implementation NSPreferencePane(iTeXMac2)
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= load
+ (void)load;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 09/21/2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
	iTM2_INIT_POOL;
	[NSBundle redirectNSLogOutput];
//iTM2_START;
	static BOOL already = NO;// there is a bug, this load method is called twice!
	if(already)
		return;
	already = YES;
	if(![iTM2RuntimeBrowser swizzleInstanceMethodSelector:@selector(loadMainView) replacement:@selector(swizzle_iTM2PreferenceKit_loadMainView) forClass:[NSPreferencePane class]])
	{
		iTM2_LOG(@"..........  ERROR: Bad configuration, things won't work as expected...");
	}
//iTM2_END;
	iTM2_RELEASE_POOL;
	return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= prefPaneIdentifierForBundle:
+ (NSString *)prefPaneIdentifierForBundle:(NSBundle *)aBundle;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 09/21/2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSArray * components = [[aBundle bundleIdentifier] componentsSeparatedByString:@"prefPane."];
//iTM2_END;
    return [components count]>1? [components lastObject]:@"";
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iconImageForBundle:
+ (NSImage *)iconImageForBundle:(NSBundle *)aBundle;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 09/21/2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(!aBundle)
		return nil;
	NSString * iconName = [[aBundle infoDictionary] objectForKey:@"NSPrefPaneIconFile"];
	if([iconName length])
	{
		NSString * iconPath = [aBundle pathForImageResource:iconName];
		if([iconPath length])
		{
			NSImage * result = [[[NSImage allocWithZone:[self zone]] initWithContentsOfFile:iconPath] autorelease];
			if(result)
			{
				return result;
			}
			else
			{
				iTM2_LOG(@"Bad icon file in the pref pane bundle: %@", aBundle);
			}
		}
		else
		{
			iTM2_LOG(@"Bad icon name in the pref pane bundle: %@", aBundle);
		}
	}
	else
	{
		iTM2_LOG(@"Missing icon name in the pref pane bundle: %@", aBundle);
	}
//iTM2_END;
    return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iconLabelForBundle:
+ (NSString *)iconLabelForBundle:(NSBundle *)aBundle;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 09/21/2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if(!aBundle)
		return @"";
	else
		return [aBundle objectForInfoDictionaryKey:@"NSPrefPaneIconLabel"];
//iTM2_END;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= prefPaneIdentifier
- (NSString *)prefPaneIdentifier;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 09/21/2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return [[self class] prefPaneIdentifierForBundle:[self bundle]];
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iconImage
- (NSImage *)iconImage;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 09/21/2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	NSImage * result = [[self class] iconImageForBundle:[self bundle]];
	if(result)
		return result;
	NSBundle * B = [self classBundle];
	NSString * iconPath = [B pathForImageResource:NSStringFromClass([self class])];
	if([iconPath length])
	{
		NSImage * result = [[[NSImage allocWithZone:[self zone]] initWithContentsOfFile:iconPath] autorelease];
		if(result)
		{
			return result;
		}
		else
		{
			iTM2_LOG(@"Bad icon file in the pref pane bundle: %@", B);
		}
	}
	else
	{
		iTM2_LOG(@"Bad icon name in the pref pane bundle: %@", B);
	}
	B = [iTM2PrefsController classBundle];
	iconPath = [B pathForImageResource:@"iTM2GenericPrefPane"];
	if([iconPath length])
	{
		NSImage * result = [[[NSImage allocWithZone:[self zone]] initWithContentsOfFile:iconPath] autorelease];
		if(result)
		{
			return result;
		}
		else
		{
			iTM2_LOG(@"Bad pref pane generic icon file in bundle: %@", B);
		}
	}
	else
	{
		iTM2_LOG(@"Missing pref pane generic icon file in bundle: %@", B);
	}
//iTM2_END;
    return nil;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= iconLabel
- (NSString *)iconLabel;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 09/21/2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
	NSString * result = [[self class] iconLabelForBundle:[self bundle]];
	if([result length])
		return result;
	return NSLocalizedStringFromTableInBundle(@"NSPrefPaneIconLabel", NSStringFromClass([self class]), [self classBundle], "Comment forthcoming");
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= swizzle_iTM2PreferenceKit_loadMainView
- (NSView *)swizzle_iTM2PreferenceKit_loadMainView;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 09/21/2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	if([self bundle])
		return [self swizzle_iTM2PreferenceKit_loadMainView];
	if([NSBundle loadNibNamed:NSStringFromClass([self class]) owner:self])
	{
//iTM2_END;
		[self assignMainView];
		return [self mainView];
	}
	else
	{
		iTM2_LOG(@"..........  ERROR: Missing a nib for this preference pane...");
//iTM2_END;
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
    if(self = [super initWithBundle:aBundle])
    {
        [self initImplementation];
    }
    return self;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  dealloc
- (void)dealloc;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
	[self willDealloc];
    [self deallocImplementation];
    [super dealloc];
    return;
}
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  willUnselect
- (void)willUnselect;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: Fri Sep 05 2003
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
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
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return @"prefPane.2text";
}
@end
#endif
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=  iTM2PrefsController

@implementation iTM2PrefsWindow
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= handlesKeyBindings
- (BOOL)handlesKeyBindings;
/*"Description Forthcoming.
Version history: jlaurens AT users DOT sourceforge DOT net
- 2.0: 09/21/2005
To Do List:
"*/
{iTM2_DIAGNOSTIC;
//iTM2_START;
//iTM2_END;
    return YES;
}
@end


