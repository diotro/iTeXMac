//
//  iTM2Test7
//  iTM2Foundation
//
//  Created by Jérôme Laurens on 16/10/09.
//  Copyright 2010 Laurens'Tribune. All rights reserved.
//
#import "iTeXMac2.h"
#import "iTM2BundleKit.h"
#import "iTM2DistributedObjectKit.h"
#import "iTM2FileManagerKit.h"
#import "iTM2Implementation.h"
#import "iTM2InstallationKit.h"
#import "iTM2Invocation.h"
#import "iTM2NotificationKit.h"
#import "iTM2ObjectServer.h"
#import "iTM2PathUtilities.h"
#import "iTM2Runtime.h"
#import "iTM2TreeKit.h"
#import "RegexKitLite.h"
#import "ICURegEx.h"
#import "iTM2StringKit.h"

#import "iTM2ButtonKit.h"
#import "iTM2CursorKit.h"
#import "iTM2EventKit.h"
#import "iTM2ImageKit.h"
#import "iTM2MenuKit.h"
#import "iTM2ResponderKit.h"
#import "iTM2ValidationKit.h"
#import "iTM2ViewKit.h"
#import "iTM2WindowKit.h"

#import "iTM2ContextKit.h"
#import "iTM2AutoKit.h"
#import "iTM2MacroKit.h"
#import "iTM2MacroKit_String.h"
#import "iTM2DocumentKit.h"
#import "iTM2InheritanceKit.h"
#import "iTM2ApplicationDelegate.h"

#import "iTM2ProjectDocumentKit.h"
#import "iTM2ProjectControllerKit.h"
#import "iTM2InfoWrapperKit.h"

#import "iTM2SystemSignalKit.h"
#import "iTM2Responders.h"
#import "iTM2SpellKit.h"
#import "iTM2ProjectSpellKit.h"
#import "iTM2TaskKit.h"
#import "iTM2StartupKit.h"

#import "iTM2TextStyleEditionKit.h"
#import "iTM2TextStorageKit.h"

#import "iTM2LiteScanner.h"
#import "iTM2StringControllerKit.h"
#import "iTM2StringControllerKitPrivate.h"
#import "iTM2TextDocumentKit.h"
#import "iTM2TextKit.h"

#import "iTM2Test7.h"

@implementation iTM2Test7
@synthesize temporaryDirectoryURL = iVarTemporaryDirectoryURL4iTM3;
- (void) setUp
{
    // Create data structures here.
    //  create the temporary folder where we will save
    NSError * ROR = nil;
    NSURL * url = [DFM URLForDirectory:NSCachesDirectory inDomain:NSAllDomainsMask appropriateForURL:nil create:YES error:self.RORef4iTM3];
    STAssertTrue(url&&!ROR,@"MISSED");
    NSBundle * B = [NSBundle mainBundle];
    self.temporaryDirectoryURL = [url URLByAppendingPathComponent:B?B.bundleIdentifier:@"iTM3.tests"];
    STAssertTrue([DFM createDirectoryAtPath:self.temporaryDirectoryURL.path withIntermediateDirectories:YES attributes:[NSDictionary dictionary] error:self.RORef4iTM3]&&!ROR,@"MISSED");
    [iTM2ProjectController setSharedProjectController:[[[iTM2ProjectController alloc] init] autorelease]];
    return;
}

- (void) tearDown
{
    // Release data structures here.
    NSError * ROR = nil;
    STAssertTrue([DFM removeItemAtURL:self.temporaryDirectoryURL error:self.RORef4iTM3]&&!ROR,@"MISSED",NULL);
    return;  
}
- (void)testCase_ProjectBasics;
{
    //  There is a problem when creating a bundle from scratch
    //  So we must try to create a project from scratch
    STAssertTrue([iTM2UTTypeProject conformsToUTType4iTM3:(NSString *)kUTTypePackage],@"MISSED",NULL);
    NSDictionary * D = (NSDictionary*)UTTypeCopyDeclaration((CFStringRef)iTM2UTTypeProject);
    NSString * expectedExtension = [[[D objectForKey:@"UTTypeTagSpecification"] objectForKey:@"public.filename-extension"] lastObject];
    iTM2ProjectDocument * PD = [[iTM2ProjectDocument alloc] init];
    NSString * name = [NSString stringWithUUID4iTM3];
    NSString * extension = (NSString *)UTTypeCopyPreferredTagWithClass((CFStringRef)iTM2UTTypeProject,kUTTagClassFilenameExtension);
    STAssertTrue([extension pathIsEqual4iTM3:expectedExtension] || (NSLog(@"extension:%@<!>%@(expected)",extension,expectedExtension),NO),@"MISSED",NULL);
    //  Beware, the extension given by the UTTypeCopyPreferredTagWithClass function is lowercase!
    NSURL * URL_P = [[self.temporaryDirectoryURL URLByAppendingPathComponent:name] URLByAppendingPathExtension:extension];
    PD.fileURL = URL_P;
    URL_P = PD.fileURL;// to ensure that this is a directory url
    STAssertTrue([URL_P isEquivalentToURL4iTM3:URL_P.directoryURL4iTM3],@"MISSED",NULL);    
    PD.fileType = iTM2UTTypeProject;
    LOG4iTM3(@"PD.fileURL:%@",PD.fileURL);
    [PD saveDocument:nil];
//    [PD writeToURL:
//  see mdls tool to list the meta data of a file
    NSURL * URL_F = [[[PD.fileURL URLByDeletingLastPathComponent] URLByAppendingPathComponent:[NSString stringWithUUID4iTM3]] URLByAppendingPathExtension:@"txt"];
    //  project PD does not contain any document
    NSError * ROR = nil;
    NSString * key = [SPC fileKeyForURL:URL_F filter:iTM2PCFilterRegular inProjectWithURL:PD.fileURL error:self.RORef4iTM3];
    STAssertNil(ROR,@"MISSED",NULL);
    STAssertFalse(key.length,@"MISSED",NULL);
    //  Create a text document
    iTM2TextDocument * TD = [[iTM2TextDocument alloc] init];
    TD.fileURL = URL_F;
    TD.fileType = iTM3TextDocumentType;
    NSString * S = @"ëÈ∂ßƒÂêÚß ◊∂∂";
    [[TD.textStorage mutableString] appendString:S];
    TD.stringEncoding = NSUTF8StringEncoding;
    [TD saveDocument:nil];//xattr -p com.apple.TextEncoding *.txt
    [SPC registerProject:PD error:self.RORef4iTM3];
    STAssertNil(ROR,@"MISSED",NULL);
    ROR = nil;
    STAssertTrue([PD addSubdocument:TD error:self.RORef4iTM3],@"MISSED",NULL);
    STAssertNil(ROR,@"MISSED",NULL);
    STAssertTrue([PD ownsSubdocument:TD],@"MISSED",NULL);
    key = [PD fileKeyForURL:TD.fileURL error:self.RORef4iTM3];
    STAssertNil(ROR,@"MISSED",NULL);
    STAssertTrue(key.length,@"MISSED",NULL);
    STAssertTrue([[PD URLForFileKey:key error:self.RORef4iTM3] isEquivalentToURL4iTM3:TD.fileURL],@"MISSED",NULL);
    STAssertNil(ROR,@"MISSED",NULL);
    iTM2ProjectDocument * pd = [SPC projectForDocument:TD error:self.RORef4iTM3];
    STAssertNil(ROR,@"MISSED",NULL);
    STAssertEquals(PD,pd,@"MISSED",NULL);
    [PD saveDocument:nil];
    key = [SPC fileKeyForURL:TD.fileURL filter:iTM2PCFilterRegular inProjectWithURL:PD.fileURL error:self.RORef4iTM3];
    STAssertNil(ROR,@"MISSED",NULL);
    STAssertTrue(key.length,@"MISSED",NULL);
    STAssertTrue([[SPC URLForFileKey:key filter:iTM2PCFilterRegular inProjectWithURL:PD.fileURL error:self.RORef4iTM3] isEquivalentToURL4iTM3:TD.fileURL],@"MISSED",NULL);
    STAssertNil(ROR,@"MISSED",NULL);
    [SPC forgetProject:PD];
    pd = [SPC projectForDocument:TD error:self.RORef4iTM3];
    STAssertNil(ROR,@"MISSED",NULL);
    STAssertNil(pd,@"MISSED",NULL);
    [TD close];
    STAssertTrue([SPC canGetNewProjectForURL:URL_F error:self.RORef4iTM3],@"MISSED",NULL);
    //  When using the initWithContentsOfURL:... method, no project is associated with the document
    TD = [[iTM2TextDocument alloc] initWithContentsOfURL:URL_F ofType:iTM3TextDocumentType error:self.RORef4iTM3];
    STAssertNotNil(TD,@"MISSED",NULL);
    STAssertNil(ROR,@"MISSED",NULL);
    STAssertNotNil(TD.textStorage,@"MISSED",NULL);
    STAssertTrue([S isEqualToString:[TD.textStorage string]],@"MISSED",NULL);
    pd = [SPC projectForDocument:TD error:self.RORef4iTM3];
    STAssertNil(ROR,@"MISSED",NULL);
    STAssertNil(pd,@"MISSED",NULL);
    [TD close];
    STAssertTrue([SPC canGetNewProjectForURL:URL_F error:self.RORef4iTM3],@"MISSED",NULL);
    TD = [SDC makeDocumentWithContentsOfURL:URL_F ofType:iTM3TextDocumentType error:self.RORef4iTM3];
    STAssertNotNil(TD,@"MISSED",NULL);
    STAssertNil(ROR,@"MISSED",NULL);
    STAssertTrue([S isEqualToString:[TD.textStorage string]],@"MISSED",NULL);
    pd = [SPC projectForDocument:TD error:self.RORef4iTM3];
    STAssertNil(ROR,@"MISSED",NULL);
    STAssertNil(pd,@"MISSED",NULL);
    [TD close];
    STAssertTrue([SPC canGetNewProjectForURL:URL_F error:self.RORef4iTM3],@"MISSED",NULL);
    TD = [SDC openDocumentWithContentsOfURL:URL_F display:NO error:self.RORef4iTM3];
    STAssertNotNil(TD,@"MISSED",NULL);
    STAssertNil(ROR,@"MISSED",NULL);
    STAssertTrue([S isEqualToString:[TD.textStorage string]],@"MISSED",NULL);
    pd = [SPC projectForDocument:TD error:self.RORef4iTM3];
    STAssertNil(ROR,@"MISSED",NULL);
    STAssertNil(pd,@"MISSED",NULL);
    [TD close];
     
    return;
}

@end

