/*
//
//  @version Subversion: $Id$ 
//
//  Created by jlaurens AT users DOT sourceforge DOT net on Sun Apr 28 2002.
//  Copyright © 2003 Laurens'Tribune. All rights reserved.
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


extern NSString * const iTeXMac2;
extern NSString * const iTM2ApplicationSupport;
extern NSString * const iTM2SupportPluginsComponent;
extern NSString * const iTM2SupportGeneralComponent;//used
extern NSString * const iTM2SupportTextComponent;

extern NSString * const iTeXMac2BundleIdentifier;

extern NSString * const iTM2BundleDidLoadNotification;

extern NSString * const iTM2BundleContentsComponent;

#define foundationBUNDLE ([NSBundle iTM2FoundationBundle])
//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  NSBundle(iTeXMac2)

/*!
    @class	NSBundle(iTeXMac2)
    @abstract	This category adds support for the Application Support folders.
    @discussion We distinguish between different locations for the resources.
				These locations are ordered to allow an overriding design.
				For a given bundle, resources belong to one of the following category
				- support
				- external
				- built in,
				- embedded,
				External resources are the resources related to bundles located in one of
                1- ~/Library/Application\ Support/bundleID
                2- /Library/Application\ Support/bundleID
                3- /Network/Library/Application\ Support/bundleID
				Support resources are located in the same folders but are not external
				Built in resources are located in the bundle Resource folder
				Embedded resources are the resources related to embedded plug ins or frameworks.
				For a given bundle, categories are recursively ordered by
					support > external > embedded support > embedded external > built in > embedded built in
				That way a resource in the support category can override a resource in one of the other categories.
				Inside each category
					user > local > network
				Older discussion: iTeXMac2 and all its satellite applications are expected to look for their resources in different places. Standard places are:
                1- ~/Library/Application\ Support/iTeXMac2
                2- /Library/Application\ Support/iTeXMac2
                3- /Network/Library/Application\ Support/iTeXMac2
                4- Bundle resource/Application\ Support
                The System domain is intentionnaly left blank. If we happen to install some framework in the system domain, the inner resources will be available from the framework bundle with the standard Foundation API.
                The domain number 4 above is called the built in domain. It is in the standard resource domain of the bundle. Its contents should be considered as default values.
                Resources are searched in the order given above. If nothing is found in 1, 2 or 3, then standard API of the NSBundle object are used to access resources inside the bundle.
                In general, 1, 2 and 3 are gathered.
*/

@interface NSBundle(iTeXMac2)

/*!
    @method 	isI386
    @abstract	Abstract forthcoming.
    @discussion	Discussion forthcoming.
    @result		yorn.
*/
+(BOOL)isI386;

/*!
    @method 	iTM2FoundationBundle
    @abstract	The iTeXMac2 foundation framework bundle.
    @discussion	The TeX Kit framework is the one containing the iTM2ContextInfo.
    @result	A bundle with identifier "comp.text.tex.iTeXmac.foundation".
*/
+(NSBundle *)iTM2FoundationBundle;

/*!
    @method 	iTeXMac2Bundle
    @abstract	The iTeXMac2 bundle.
    @discussion	Description Forthcoming.
    @result	A bundle with identifier "comp.text.tex.iTeXMac2".
*/
+(NSBundle *)iTeXMac2Bundle;

/*!
    @method 	searchPathsForSupportInDomains:withName:application's given name.
    @discussion	Returns objects of
                1- ~/Library/Application\ Support/APPLICATION_NAME
                2- /Library/Application\ Support/APPLICATION_NAME
                3- /Network/Library/Application\ Support/APPLICATION_NAME
                The system domain is ignored, not the others (fortunately, no other domain is defined)
    @param	domainMask is concerning one of the user, local or network domains, but NOT the system nor the built in one...
    @result	an array of the paths
*/
+(NSArray *)searchPathsForSupportInDomains:(NSSearchPathDomainMask)domainMask withName:(NSString *)appName;

/*!
    @method 	pathForSupportDirectory:inDomain:withName:create:
    @abstract	The application support subdirectory.
    @discussion	Returns objects of
                1- ~/Library/Application\ Support/APP_NAME/subpath
                2- /Library/Application\ Support/APP_NAME/subpath
                3- /Network/Library/Application\ Support/APP_NAME/subpath
                The system domain is ignored, not the others (fortunately, no other domain is defined)
    @param		subpath is a subpath, yeah.
    @param		domainMask is concerning one of the user, local or network domains, but NOT the system nor the built in one...
                If more than one domain is given, the first ones are ignored and only the last one is taken into consideration.
    @param		appName is an appName, yeah.
    @param		create is a flag, if set to YES, the directory will be created.
    @result		a full path, possibly empty if it does not exist or could not be created while create is YES.
*/
+(NSString *)pathForSupportDirectory:(NSString *)subpath inDomain:(NSSearchPathDomainMask)domainMask withName:(NSString *)appName create:(BOOL)create;

/*!
    @method 	pathForSupportDirectory:inDomain:withName:create:
    @abstract	The application support subdirectory.
    @discussion	Returns objects of
                1- ~/Library/Application\ Support/APP_NAME/subpath
                2- /Library/Application\ Support/APP_NAME/subpath
                3- /Network/Library/Application\ Support/APP_NAME/subpath
                The system domain is ignored, not the others (fortunately, no other domain is defined)
    @param		subpath is a subpath.
    @param		domainMask is concerning one of the user, local or network domains, but NOT the system nor the built in one...
                If more than one domain is given, the first one are ignored and only the last one is taken into consideration.
    @param		create is a flag.
    @result		a full path or @"" if the requested path does not exist or could not be created while create is YES.
*/
-(NSString *)pathForSupportDirectory:(NSString *)subpath inDomain:(NSSearchPathDomainMask)domainMask create:(BOOL)create;

/*!
    @method 	plugInPathExtension
    @abstract	The plug-ins path extension
    @discussion	iTM2.
	@param		None
	@result		a String
*/
+(NSString *)plugInPathExtension;

/*!
    @method 	loadPlugIns
    @abstract	Load the plug-ins.
    @discussion	The plug-in architecture implemented in iTeXMac2 is a very basic one.
				But it is extremely powerful.
				The plugins are expected to be located in the various PlugIns folders from:
				/Library/Application Support/AppName
				in the various domains, or shipped with the app and the frameworks.
				The bundles are expected to have a iTM2 extension.
				They only have to declare a NSPrincipalClass, that will be loaded at startup.
				The bundles are loaded when the application did finish launching.
	@param		None
	@result		None.orderFront
*/
+(void)loadPlugIns;

/*!
    @method 	availablePlugInPathsOfType:
    @abstract	The loadable plug-ins paths of the given type
    @discussion	In the various 'Application Support' folders. From User domain to localhost domain to network domain.
				Each framework is authorized to contain plugins.
				This method lists all the frameworks bundles and returns their -availablePlugInPathsOfType:
				The main bundle is listed first because it is prepending all the others.
	@param		type is file extension
	@result		an array of fulle paths
*/
+(NSArray *)availablePlugInPathsOfType:(NSString *)aType;

/*!
    @method 	availablePlugInPathsOfType:
    @abstract	The loadable plug-ins paths of the given type
    @discussion	In the various 'Application Support' folders. From User domain to localhost domain to network domain.
				Use a revers object enumerator if you want the User domain override all the others when loading.
	@param		type is file extension
	@result		an array of fulle paths
*/
-(NSArray *)availablePlugInPathsOfType:(NSString *)aType;

/*!
    @method 	availablePlugInPathsAtPath:ofType:
    @abstract	The loadable plug-ins path of the given type
    @discussion	Discussion forthcoming.
	@param		path is the full path name of a directory
	@result		an array of full paths
*/
+(NSArray *)availablePlugInPathsAtPath:(NSString *)path ofType:(NSString *)aType;

/*!
    @method 	bundleName
    @abstract	The name of the application.
    @discussion	Description forthcoming.
    @result	The main bundle name from the info dictionary.
*/
-(NSString *)bundleName;

/*!
    @method 	defaultWritableFolderPath
    @abstract	The default writable folder path.
    @discussion	Description forthcoming.
    @result	A default writable folder path.
*/
+(NSString *)defaultWritableFolderPath;

/*!
	@method			uniqueApplicationIdentifier
	@abstract		A unique application identifier.
	@discussion		This string will be used to avoid collisions between 2 applications being run at the same time.
	@result			a NSString
	@availability	iTM2.
	@copyright		2005 jlaurens AT users DOT sourceforge DOT net and others.
*/
+(NSString *)uniqueApplicationIdentifier;

/*!
    @method 	bundleIsWrapper
    @abstract	Whether the bundle is a wrapper.
    @discussion	A wrapper bundle should be explored deeply for included bundles.
				The default is NO. Add an entry "iTM2BundleIsWrapper" with value "YES" in the info plist dictionary.
				Convenience method to distribute and install a lot of plugins all at once.
    @result		YorN.
*/
-(BOOL)bundleIsWrapper;

/*!
    @method 	bundleHFSTypeCode
    @abstract	The HFS type of the receiver.
    @discussion	Description forthcoming.
    @result		an OSType unsigned integer.
*/
-(OSType)bundleHFSTypeCode;

/*!
    @method 	bundleHFSCreatorCode
    @abstract	The HFS creator code of the receiver.
    @discussion	Description forthcoming.
    @result		an OSType unsigned integer.
*/
-(OSType)bundleHFSCreatorCode;

/*!
	@method			temporaryDirectory
	@abstract		The temporary directory of the receiver.
	@discussion		It is a unique temporary directory, per running application and time.
					More unique than NSTemporaryDirectory() because it appends a globally unique component...
	@result			a path (possibly nil)
	@availability	iTM2.
	@copyright		2005 jlaurens AT users DOT sourceforge DOT net and others.
*/
+(NSString *)temporaryDirectory;

/*!
	@method			temporaryBinaryDirectory
	@abstract		The temporary binary directory of the receiver.
	@discussion		It is the bin folder in the receiver's temporary directory...
	@result			a path (possibly nil)
	@availability	iTM2.
	@copyright		2005 jlaurens AT users DOT sourceforge DOT net and others.
*/
+(NSString *)temporaryBinaryDirectory;
+(BOOL)createSymbolicLinkWithExecutableContent:(NSString *)executable error:(NSError **)errorRef;

/*!
	@method			temporaryUniqueDirectory
	@abstract		A temporary unique directory of the receiver.
	@discussion		Some folder beyond the temporary directory
	@result			a path
	@availability	iTM2.
	@copyright		2005 jlaurens AT users DOT sourceforge DOT net and others.
*/
+(NSString *)temporaryUniqueDirectory;

/*!
    @method 	bundleForResourceAtPath:
    @abstract	The bundle that corresponds to the given path.
    @discussion	It does not mean that this resource path points to something!
    @param		component is the component of the resource.
    @param		type is the type of the resource.
    @result		An array.
*/
+(NSBundle *)bundleForResourceAtPath:(NSString *)aPath;

/*!
    @method 	allPathsForResource:ofType:
    @abstract	All the paths for the given resource, whatever location it is.
    @discussion	THE USE OF THIS METHOD SHOULD BE PREFERRED TO THE PREVIOUS ONES.
				Paths are listed in the following order:
				0 - The support directory with the given component in the user domain.
				1 - For each plug-in in the user domain, its allPathsForResource:ofType: result
				2 - The support directory with the given component in the local domain,
				3 - For each plug-in in the local domain, its allPathsForResource:ofType: result,
				4 - The support directory with the given component in the network domain,
				5 - For each plug-in in the network domain, its allPathsForResource:ofType: result,
				6 - For each embedded bundle, its allPathsForResource:ofType: result,
				7 - The receiver's resource,
				Inside each category, no order is defined.
				In general, clients will list the paths in the reverse order if the next overrides the previous,
				in order to let the user have the final choice.
				It mimics pathForResource:ofType:
    @param		component is the component of the resource.
    @param		type is the type of the resource.
    @result		An array.
*/
-(NSArray *)allPathsForResource:(NSString *)component ofType:(NSString *)type;
-(NSArray *)allPathsForResource:(NSString *)component ofType:(NSString *)type inDirectory:(NSString *)subpath;

/*!
	@method			pathsForResource:ofType:inDirectory:domains:
	@abstract		The paths for the given resource.
	@discussion		These resources are located in all the plug-ins registered at various locations, except in the main bundle.
	@param			name is the name of the resource.
	@param			type is the file extension of the resource.
	@param			subpath is the subdirectory path where the resource is searched, not recursive.
	@param			domainMask is a domain mask, from network to user.
	@result			An array of paths.
	@availability	iTM2.
	@copyright		2005 jlaurens AT users DOT sourceforge DOT net and others.
*/
-(NSArray *)pathsForResource:(NSString *)name ofType:(NSString *)type inDirectory:(NSString *)subpath domains:(NSSearchPathDomainMask)domainMask;

/*!
	@method			pathsForBuiltInResource:ofType:inDirectory:
	@abstract		The built in paths for the given resource.
	@discussion		THE USE OF THIS METHOD SHOULD BE PREFERRED TO THE PREVIOUS ONES.
					These resources are located in the ordered embedded receiver's bundles, then in the receiver itself. 
					These locations are searched in that order, from the deepest level to the outer container.
					For each bundle, the -pathsForBuiltInResource:ofType:inDirectory: is used.
	@param			name is the name of the resource.
	@param			type is the file extension of the resource.
	@param			subpath is the subdirectory path where the resource is searched, not recursive.
	@result			An array of paths.
	@availability	iTM2.
	@copyright		2005 jlaurens AT users DOT sourceforge DOT net and others.
*/
-(NSArray *)pathsForBuiltInResource:(NSString *)name ofType:(NSString *)type inDirectory:(NSString *)subpath;

/*!
	@method			supportPathsForResource:ofType:inDirectory:domain:
	@abstract		The paths for the given resource in the given domain.
	@discussion		THE USE OF THIS METHOD SHOULD BE PREFERRED TO THE PREVIOUS ONES.
					These resources are located in the available plug-ins in the given domain,
					then in the Application Support subfolder. 
					These locations are searched in that order.
					For each bundle found, the -supportPathsForResource:ofType:inDirectory: is used.
	@param			name is the name of the resource.
	@param			type is the file extension of the resource.
	@param			subpath is the subdirectory path where the resource is searched, not recursive.
	@result			An array of paths.
	@availability	iTM2.
	@copyright		2005 jlaurens AT users DOT sourceforge DOT net and others.
*/
-(NSArray *)pathsForSupportResource:(NSString *)name ofType:(NSString *)type inDirectory:(NSString *)subpath domains:(NSSearchPathDomainMask)domainMask;
-(NSArray *)pathsForSupportResource:(NSString *)name ofType:(NSString *)type inDirectory:(NSString *)subpath;

/*!
    @method 	allBundlesAtPath:
    @abstract	All the bundles at the given path.
    @discussion	A bundle must have a non void infoDictionary.
    @result		An array.
*/
+(NSArray *)allBundlesAtPath:(NSString *)path;

/*!
    @method 	supportBundlesInDomain:
    @abstract	All the bundles at the given support level.
    @discussion	A bundle must have a non void infoDictionary.
    @result		An array.
*/
-(NSArray *)supportBundlesInDomain:(NSSearchPathDomainMask) domainMask;

/*!
    @method 	embeddedBundles
    @abstract	The list of embedded frameworks.
    @discussion	Only frameworks bundled in wrappers are returned.
				Frameworks inside embedded plug-ins or frameworks are not concerned by this.
				No distinction was made between private and public frameworks.
	@param		None
	@result		None
*/
-(NSArray *)embeddedBundles;

/*!
    @method 	bundleForClass:localizedStringForKey:value:table:
    @abstract	An extension of localizedStringForKey:value:table:.
    @discussion	The localization is searched in the bundle of the given class object.
				If no localization is found there, we look for a localization in the bundle of the superclass.
				We do this until we reach the root object.
	@param		aClass is the class we want the bundle
	@param		key is the key
	@param		value is the default value when the key is not found
	@param		table is the table name
	@result		A localized string
*/
+(NSString *)bundleForClass:(Class)aClass localizedStringForKey:(NSString *)key value:(NSString *)value table:(NSString *)tableName;

@end

@interface NSObject(iTM2BundleKit)

/*!
    @method 	classBundle
    @abstract	The class bundle of the receiver.
    @discussion	This API layer solves a poseAsClass: problem.
				If the original developper designes a class that needs to access its own bundle for resources,
				it will certainly want to use NSBundle's +bundleForClass: method. But if a plugin overrides the class,
				using a +poseAsClass: message for example, it will also as side effect change the bundle
				and the resources will no longer be available.
				The default implementation just returns the result of a +bundleForClass: message.
				Objects that do need to access resources inside the original bundle will override this classBundle method,
				to return a static object that is initialized very early, before any plugin can override the class behaviour.
				TO DO: change the way myBUNDLE is used...
    @result		a bundle.
*/
+(NSBundle *)classBundle;
-(NSBundle *)classBundle;

@end

@interface NSBundle(iTeXMac2Xtd)

/*!
	@method			loadNibNamed:owner:
	@abstract		Load the named nib.
	@discussion		It appends a deepest search to the standard app kit method.
					If the standard search does not succeed, it looks into the bundle of the superclass and so on...
					This is interesting for subclassers and class posers...
	@result			yorn
	@availability	iTM2.
	@copyright		2005 jlaurens AT users DOT sourceforge DOT net and others.
*/
+(BOOL)loadNibNamed:(NSString *)aNibName owner:(id)owner;

@end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  NSBundle(iTeXMac2)
