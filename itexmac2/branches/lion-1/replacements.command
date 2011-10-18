#!/bin/sh
cd "$(dirname "$0")"
pwd

function find_and_replace {
    echo find_and_replace: ${1}/${2}
    echo "find . \\( -name \"*i*T*M*2*.h\" -or -name \"*i*T*M*2*.m\" \\) -exec egrep -q \"$1\" \"{}\" \; -print -exec perl -i -pe \"$2\" \"{}\" \; -print"
    find . \( -name "*i*T*M*2*.h" -or -name "*i*T*M*2*.m" \) -exec egrep -q "$1" "{}" \; -print -exec perl -i -pe "$2" "{}" \; -print
    echo "AFTER"
    echo "find . \( -name \"*i*T*M*2*.h\" -or -name \"*i*T*M*2*.m\" \) -exec egrep -q \"$1\" \"{}\" \; -print -exec open -a xcode \"{}\" \;"
    find . \( -name "*i*T*M*2*.h" -or -name "*i*T*M*2*.m" \) -exec egrep -q "$1" "{}" \; -print -exec open -a xcode "{}" \;
}

find_and_replace  'defaultOtherProgramsPath' 's/\bdefaultOtherProgramsPath\b/defaultPathToOtherPrograms/g'


exit 0

- (void)contextDidChange;
- (void)contextDidChangeComplete;
- (BOOL)notifyContextChange;
- (BOOL)contextRegistrationNeeded;
- (NSUInteger)contextStateForKey:(NSString *)aKey


find_and_replace  'defaultTeXMFProgramsPath' 's/\bdefaultTeXMFProgramsPath\b/defaultPathToTeXMFPrograms/g'
find_and_replace  'TeXMFDistribution' 's/\bTeXMFDistribution\b/nameOfTeXMFDistribution/g'
find_and_replace  'TeXMFProgramsDistribution' 's/\bOtherProgramsDistribution\b/nameOfOtherProgramsDistribution/g'
find_and_replace  'GhostScriptProgramsDistribution' 's/\bGhostScriptProgramsDistribution\b/nameOfGhostScriptProgramsDistribution/g'
find_and_replace  'OtherProgramsDistribution' 's/\bOtherProgramsDistribution\b/nameOfOtherProgramsDistribution/g'
find_and_replace  'TeXMFDistribution' 's/\bsetTeXMFDistribution\b/setNameOfTeXMFDistribution/g'
find_and_replace  'TeXMFProgramsDistribution' 's/\bsetOtherProgramsDistribution\b/setNameOfOtherProgramsDistribution/g'
find_and_replace  'GhostScriptProgramsDistribution' 's/\bsetGhostScriptProgramsDistribution\b/setNameOfGhostScriptProgramsDistribution/g'
find_and_replace  'OtherProgramsDistribution' 's/\bsetOtherProgramsDistribution\b/setNameOfOtherProgramsDistribution/g'
find_and_replace  'TeXMFProgramsPath' 's/\bTeXMFProgramsPath\b/pathToTeXMFPrograms/g'
find_and_replace  'OtherProgramsPath' 's/\bOtherProgramsPath\b/pathToOtherPrograms/g'
find_and_replace  'TeXMFProgramsPath' 's/\bsetTeXMFProgramsPath\b/setPathToTeXMFPrograms/g'
find_and_replace  'OtherProgramsPath' 's/\bsetOtherProgramsPath\b/setPathToOtherPrograms/g'
find_and_replace  'clickCount' 's/\[([a-zA-Z0-9_]*) clickCount\]/${1}.clickCount/g'
find_and_replace  'ContextController4iTM3' 's/ContextController4iTM3/Context4iTM3Controller/g'
find_and_replace  'iTM2SpellContext4iTM3' 's/iTM2SpellContext4iTM3/iTM3SpellContext/g'
find_and_replace  '__iTM2_DEVELOPMENT__' 's/__iTM2_DEVELOPMENT__/__iTM3_DEVELOPMENT__/g'
find_and_replace  'isNotConsistent' 's/\[(\w+) (isNotConsistent)\]/\1.\2/g'
find_and_replace  'errorRef' 's/\berrorRef\b/RORef/g'
find_and_replace  'pellContext' 's/(pellContext\b)/${1}4iTM3/g'
find_and_replace  'spellContextController4iTM3' 's/(spellContextController4iTM3)/${1}Error:RORef/g'
find_and_replace  '\{1\}' 's/\{1\}4iTM3/spellContextController4iTM3/g'
find_and_replace  'spellContextController' 's/(spellContextController)/${1}4iTM3/g'
find_and_replace  'I methodSignature' 's/\[I methodSignature\]/I.methodSignature/g'
find_and_replace  'needsToUpdate' 's/(needsToUpdate)/${1}4iTM3/g'
find_and_replace  'contextStateForKey' 's/(context)(StateForKey)/${1}4iTM3${2}/g'
find_and_replace  'contextDidChange' 's/(context)(DidChange)/${1}4iTM3${2}/g'
find_and_replace  'notifyContextChange' 's/(notifyContext)(Change)/${1}4iTM3${2}/g'
find_and_replace  'contextRegistrationNeeded' 's/(context)(RegistrationNeeded)/${1}4iTM3${2}/g'
find_and_replace  'ontextValue' 's/(ontextValue)(?!4)/${1}4iTM3/g'
find_and_replace ' enclosingProjectURL4iTM3]' 's/\[ *([_\w.]*) *(enclosingProjectURL4iTM3) *\]/${1}.${2}/g'
find_and_replace ' URLByStandardizingPath]' 's/\[ *([_\w.]*) *(URLByStandardizingPath) *\]/${1}.${2}/g'
find_and_replace  'mainInfos' 's/mainInfos/mainInfos4iTM3/g'
find_and_replace  'infoForKeyPaths4iTM3' 's/infoForKeyPaths4iTM3/info4iTM3ForKeyPaths/g'
find_and_replace  'nheritedInfo' 's/(nheritedInfo)(?!4)/${1}4iTM3/g'
find_and_replace  'nfoInherited' 's/(nfoInherited)(?!4)/${1}4iTM3/g'
find_and_replace  'infoForKeyPaths' 's/(infoForKeyPaths)(?!4)/${1}4iTM3/g'
find_and_replace  'isInfoEditedForKeyPaths' 's/(isInfo)(?!4)(EditedForKeyPaths)/${1}4iTM3${2}/g'
find_and_replace  'saveChangesForKeyPaths' 's/(saveChanges)(?!4)(ForKeyPaths)/${1}4iTM3${2}/g'
find_and_replace  'revertChangesForKeyPaths' 's/(revertChanges)(?!4)(ForKeyPaths)/${1}4iTM3${2}/g'
find_and_replace  'localInfoForKeyPaths' 's/(localInfo)(?!4)(ForKeyPaths)/${1}4iTM3${2}/g'
find_and_replace  'editInfoForKeyPaths' 's/(editInfo)(?!4)(ForKeyPaths)/${1}4iTM3${2}/g'
find_and_replace  'customInfoForKeyPaths' 's/(customInfo)(?!4)(ForKeyPaths)/${1}4iTM3${2}/g'
find_and_replace  'toggleInfoForKeyPaths' 's/(toggleInfo)(?!4)(ForKeyPaths)/${1}4iTM3${2}/g'
find_and_replace  'backupCustomForKeyPaths' 's/(backupCustom)(?!4)(ForKeyPaths)/${1}Info4iTM3${2}/g'
find_and_replace  'restoreCustomForKeyPaths' 's/(restoreCustom)(?!4)(ForKeyPaths)/${1}Info4iTM3${2}/g'
find_and_replace  'therInfo' 's/(therInfos?)(?!"|4)/${1}4iTM3/g'
find_and_replace  'ustomInfo' 's/(ustomInfos?)(?!"|4)/${1}4iTM3/g'
find_and_replace  'etaInfo' 's/(etaInfos?)(?!"|4)/${1}4iTM3/g'
find_and_replace  '4iTM3URL4iTM3' 's/4iTM3URL4iTM3/URL4iTM3/g'
find_and_replace  'nfosController' 's/(nfosController\b)/${1}4iTM3/g'
find_and_replace  'iTM2InfosController4iTM3' 's/iTM2InfosController4iTM3/iTM2InfosController/g'
find_and_replace  'relativeFileNamesForKeys' 's/(\brelativeFileNamesForKeys\b)/namesForFileKeys/g'
find_and_replace ' masterFileKey]' 's/\[ *([_\w.]*) *(masterFileKey) *\]/${1}.${2}/g'
find_and_replace  'stringFormatter' 's/(\bstringFormatter\b)/${1}4iTM3/g'
find_and_replace  'getHardCodedStringEncoding' 's/(getHardCodedStringEncoding)/${1}4iTM3/g'
find_and_replace  'EOLUsed' 's/(EOLUsed)/${1}4iTM3/g'
find_and_replace  'stringByUsingEOL' 's/(stringByUsingEOL)/${1}4iTM3/g'
find_and_replace  'localizedNameOfEOL' 's/(localizedNameOfEOL)/${1}4iTM3/g'
find_and_replace  'stringEncodingWithName' 's/(stringEncodingWithName)/${1}4iTM3/g'
find_and_replace  'nameOfStringEncoding' 's/(nameOfStringEncoding)/${1}4iTM3/g'
find_and_replace  '(c|localToGlobalC|globalToLocalC)haracterIndex(?:NearPoint)?:' 's/((c|localToGlobalC|globalToLocalC)haracterIndex(?:NearPoint)?):/${1}4iTM3:/g'
find_and_replace  'getIntegerTrailer' 's/(getIntegerTrailer)/${1}4iTM3/g'
find_and_replace  'stringForCommentedKey' 's/(stringForCommentedKey)/${1}4iTM3/g'
find_and_replace  'getRangeForLine' 's/(getRangeForLine)/${1}4iTM3/g'
find_and_replace  'getRangeForLineRange' 's/(getRangeForLineRange)/${1}4iTM3/g'
find_and_replace  'lineIndexForLocation' 's/(lineIndexForLocation)/${1}4iTM3/g'
find_and_replace  'numberOfLines' 's/(numberOfLines)/${1}4iTM3/g'
find_and_replace  'stringByRemovingTrailingWhites' 's/(stringByRemovingTrailingWhites)/${1}4iTM3/g'
find_and_replace  'stringWithSubstring' 's/(stringWithSubstring)/${1}4iTM3/g'
find_and_replace  'rangeBySelectingParagraphIfNeededWithRange' 's/(rangeBySelectingParagraphIfNeededWithRange)/${1}4iTM3/g'
find_and_replace  'compareUsingLastPathComponent' 's/(compareUsingLastPathComponent)/${1}4iTM3/g'
find_and_replace  'rangeOfWordAtIndex' 's/(rangeOfWordAtIndex)/${1}4iTM3/g'
find_and_replace  'wordRangeForRange' 's/(wordRangeForRange)/${1}4iTM3/g'
find_and_replace  'componentsSeparatedByStrings' 's/(componentsSeparatedByStrings)/${1}4iTM3/g'
find_and_replace  'stringByEscapingPerlControlCharacters' 's/(stringByEscapingPerlControlCharacters)/${1}4iTM3/g'
#[[P.fileURL enclosingWrapperURL4iTM3] path]
find_and_replace ' masterFileKey]' 's/\[ *([_\w.]*) *(masterFileKey) *\]/${1}.${2}/g'
find_and_replace ' projectName]' 's/\[ *([_\w.]*) *(projectName) *\]/${1}.${2}/g'

find_and_replace ' setIndentationLevel:' 's/\[ *([_\w.]*) *setIndentationLevel *: *(.*) *\];/${1}.indentationLevel = ${2};/g'
find_and_replace ' setRepresentedObject:' 's/\[ *([_\w.]*) *setRepresentedObject *: *(.*) *\];/${1}.representedObject = ${2};/g'
find_and_replace 'validate(.*)Toggle.*:\(id\)' 's/(validate(.*?)Toggle.*?: *)\(id\)/${1}(NSButton *)/g'
find_and_replace ' setState:' 's/\[ *([_\w.]*) *setState *: *(.*) *\];/${1}.state = ${2};/g'
find_and_replace ' standardizedURL]' 's/\[ *([_\w.]*) *(standardizedURL) *\]/${1}.${2}/g'
find_and_replace ' absoluteString]' 's/\[ *([_\w.]*) *(absoluteString) *\]/${1}.${2}/g'
find_and_replace ' (start|end|contentEnd)Offset]' 's/\[ *([_\w.]*) *((?:start|end|contentEnd)Offset) *\]/${1}.${2}/g'
find_and_replace ' enclosingScrollView]' 's/\[ *([_\w.]*) *(enclosingScrollView) *\]/${1}.${2}/g'
find_and_replace ' contentView]' 's/\[ *([_\w.]*) *(contentView) *\]/${1}.${2}/g'
find_and_replace ' setMinSize:' 's/\[ *([_\w.]*) *setMinSize *: *([-+*\/\w.() ]*) *\]/${1}.minSize = ${2}/g'
find_and_replace ' minSize]' 's/\[ *([_\w.]*) *(minSize) *\]/${1}.${2}/g'
find_and_replace 'computeIndexFromTag' 's/(computeIndexFromTag)(?!4iTM3)/${1}4iTM3/g'
find_and_replace ' items]' 's/\[ *([_\w.]*) *(items) *\]/${1}.${2}/g'
find_and_replace ' count]' 's/\[ *([_\w.]*) *(count) *\]/${1}.${2}/g'
find_and_replace '.b(ordered|ezeled)' 's/\.b(ordered|ezeled)/.isB${1}/g'
find_and_replace ' setB(ordered|ezeled):' 's/\[ *([_\w.]*) *set(Bordered|ezeled) *: *([_:@\w.() ]*) *\]/${1}.is${2} = ${3}/g'
find_and_replace ' setDoubleAction:' 's/\[ *([_\w.]*) *setDoubleAction *: *([_:@\w.() ]*) *\]/${1}.doubleAction = ${2}/g'
find_and_replace ' setDataSource:' 's/\[ *([\w.]*) *setDataSource *: *([-+*\/\w.() ]*) *\]/${1}.dataSource = ${2}/g'
find_and_replace 'id <NSMenuItem>' 's/id <NSMenuItem>/NSMenuItem */g'
find_and_replace ' stringByResolvingSymlinksInPath]' 's/\[ *([\w.]*) *(stringByResolvingSymlinksInPath) *\]/${1}.${2}/g'
find_and_replace ' isFileURL]' 's/\[ *([\w.]*) *(isFileURL) *\]/${1}.${2}/g'
find_and_replace ' setCurrentPage:' 's/\[ *([\w.]*) *setCurrentPage *: *([-+*\/\w.() ]*) *\]/${1}.currentPage = ${2}/g'
find_and_replace ' currentPage]' 's/\[ *([\w.]*) *(currentPage) *\]/${1}.${2}/g'
find_and_replace ' setTarget:' 's/\[ *([\w.]*) *setTarget *: *([\w.]+) *\]/${1}.target = ${2}/g'
find_and_replace ' target]' 's/\[ *([\w.]*) *(target) *\]/${1}.${2}/g'
find_and_replace ' currentEditor]' 's/\[ *([\w.]*) *(currentEditor) *\]/${1}.${2}/g'
find_and_replace ' length]' 's/\[ *([\w.]*) *(length) *\]/${1}.${2}/g'
find_and_replace ' setAction:' 's/\[ *([\w.]*|\(?[\w.]*[?][\w.]*[:][\w.]*\)?) *setAction *: *([-+\w.|&()@"%, ]*[-+\w.|&()@"%,]|[-+\w.|&()@"%, ]*[-+\w.|&()@"%,][?][-+\w.|&()@"%, ]*[-+\w.|&()@"%,]:[-+\w.|&()@"%, ]*[-+\w.|&()@"%,]) *\]/${1}.action = ${2}/g'
find_and_replace ' action]' 's/\[ *([\w.]*|\(?[\w.]*[?][\w.]*[:][\w.]*\)?) *(action) *\]/${1}.${2}/g'
find_and_replace ' firstResponder]' 's/\[ *([\w.]*) *(firstResponder) *\]/${1}.${2}/g'
find_and_replace ' setTag:' 's/\[ *([\w.]*) *setTag *: *([-+\w.|&()@"? ]*[-+\w.|&()@"?]) *\]/${1}.tag = ${2}/g'
find_and_replace ' tag]' 's/\[ *([\w.]*) *(tag) *\]/${1}.${2}/g'
find_and_replace ' itemArray]' 's/\[ *([\w.]*) *(itemArray) *\]/${1}.${2}/g'
find_and_replace ' itemArray] lastObject]' 's/\[ *\[ *([\w.]*) *(itemArray) *\] *(lastObject) *\]/${1}.${2}.${3}/g'
find_and_replace ' itemArray] count]' 's/\[ *\[ *([\w.]*) *(itemArray) *\] *(count) *\]/${1}.${2}.${3}/g'
find_and_replace ' setTitle:' 's/\[ *([\w.]*) *setTitle *: *([\w.|&()@"?]*) *\]/${1}.title = ${2}/g'
find_and_replace ' label]' 's/\[ *([\w.]*) *(label) *\]/${1}.${2}/g'
find_and_replace ' title]' 's/\[ *([\w.]*) *(title) *\]/${1}.${2}/g'
find_and_replace ' image]' 's/\[ *([\w.]*) *(image) *\]/${1}.${2}/g'
find_and_replace ' setImage' 's/\[ *([\w.]*) *setImage *: *([\w.|&()]*) *\]/${1}.image = ${2}/g'
find_and_replace ' setSendsActionOnEndEditing' 's/\[ *([\w.]*) *setSendsActionOnEndEditing *: *([\w.|&()]*) *\]/${1}.sendsActionOnEndEditing = ${2}/g'
find_and_replace ' URLByResolvingSymlinksAndFinderAliasesInURL4iTM3]' 's/\[ *([\w.]*) *(URLByResolvingSymlinksAndFinderAliasesInURL4iTM3) *\]/${1}.${2}/g'
find_and_replace ' path]' 's/\[ *([\w.]*) *(path) *\]/${1}.${2}/g'
find_and_replace ' enclosingWrapperURL4iTM3]' 's/\[ *([\w.]*) *(enclosingWrapperURL4iTM3) *\]/${1}.${2}/g'
find_and_replace ' window]' 's/\[ *([\w.]*) *(window) *\]/${1}.${2}/g'
find_and_replace ' windowController]' 's/\[ *([\w.]*) *(windowController) *\]/${1}.${2}/g'
find_and_replace ' document]' 's/\[ *([\w.]*) *(document) *\]/${1}.${2}/g'
find_and_replace ' fileURL]' 's/\[ *([\w.]*) *(fileURL) *\]/${1}.${2}/g'
BUGGY? find_and_replace ' (iconLabel|iconImage|scaleFactor|displayName|album|cell)]' 's/\\[ *([\\w.0-9_]*) (iconLabel|iconImage|scaleFactor|displayName|album|cell) *\\]/${1}.${2}/g'
find_and_replace ' PDFView]' 's/\\[ *([\\w.0-9_]*) (PDFView) *\\]/${1}.${2}/g'
find_and_replace ' frame]' 's/\\[ *([\\w.0-9_]*) (frame) *\\]/${1}.${2}/g'
find_and_replace '(deselect|remove)ItemsWithAction:' 's/((?:deselect|remove)ItemsWithAction)(?!4iTM3):/${1}4iTM3:/g'
find_and_replace 'removeItemsWithRepresentedObject:' 's/(removeItemsWithRepresentedObject)(?!4iTM3):/${1}4iTM3:/g'
find_and_replace 'deep(Copy|EnableItems)' 's/(deep(?:Copy|EnableItems))(?!4iTM3)/${1}4iTM3/g'
find_and_replace '(deep|_)MakeCellSizeSmall' 's/((?:deep|_)MakeCellSizeSmall)(?!4iTM3)/${1}4iTM3/g'
find_and_replace 'deepSet(Target|AutoenablesItems):' 's/deepSet(Target|AutoenablesItems)(?!4iTM3):/${1}4iTM3:/g'
find_and_replace 'hierarchicalMenuAtPath' 's/(hierarchicalMenuAtPath)(?!4iTM3)/${1}4iTM3/g'
find_and_replace 'cleanSeparators\b' 's/\b(cleanSeparators)(?!4iTM3)/${1}4iTM3/g'
find_and_replace 'deepItemWithTitle\b' 's/\b(deepItemWithTitle)(?!4iTM3)/${1}4iTM3/g'
find_and_replace 'itemWithAction:' 's/(itemWithAction)(?!4iTM3):/${1}4iTM3:/g'
find_and_replace 'indexOfItemWith(Action|Target):' 's/(indexOfItemWith(?:Action|Target))(?!4iTM3):/${1}4iTM3:/g'
find_and_replace 'deepItemWith(Action|RepresentedObject|KeyEquivalent):' 's/(deepItemWith(?:Action|RepresentedObject|KeyEquivalent))(?!4iTM3):/${1}4iTM3:/g'
find_and_replace 'itemWithRepresentedObject:' 's/(itemWithRepresentedObject)(?!4iTM3):/${1}4iTM3:/g'
find_and_replace '(isR|r)ootMenu' 's/((?:isR|r)ootMenu)(?!4iTM3)/${1}4iTM3/g'

#contextIntegerForKey
#recursiveEnableCheck
#recursiveEnableItems]
exit 0
find_and_replace '(concreteR|r)eplacementStringFor(LaTeX|TeX|)Macro\b' 's/\b((?:concreteR|r)eplacementStringFor(?:LaTeX|TeX|)Macro)(?!4iTM3):/${1}4iTM3:/g'
find_and_replace 'concreteReplacementStringFor(LaTeX|TeX|)Macro\b' 's/\b(concreteReplacementStringFor(?:LaTeX|TeX|)Macro)(?!4iTM3):/${1}4iTM3:/g'
find_and_replace 'getSelectionComponentsAtIndex\b' 's/\b(getSelectionComponentsAtIndex)(?!4iTM3):/${1}4iTM3:/g'
find_and_replace 'executeMacroWithText\b' 's/\b(executeMacroWithText)(?!4iTM3):/${1}4iTM3:/g'
find_and_replace 'stringByExecutingScriptAtURL\b' 's/\b(stringByExecutingScriptAtURL)(?!4iTM3):/${1}4iTM3:/g'
find_and_replace 'executeMacroWithID:' 's/(executeMacroWithID)(?!4iTM3):/${1}4iTM3:/g'
find_and_replace 'tryToExecuteMacroWithID:' 's/(tryToExecuteMacroWithID)(?!4iTM3):/${1}4iTM3:/g'
find_and_replace 'insertMacro_\b' 's/(insertMacro)(?!4iTM3)_/${1}4iTM3_/g'
BUGGY find_and_replace 'self\.SWZ[a-zA-Z_][a-zA-Z_0-9]*' 's/self\.(SWZ[a-zA-Z_][a-zA-Z_0-9]*)/\[self ${1}\]/g'
find_and_replace 'CompleteInstallation\b' 's/(CompleteInstallation)(?!4iTM3)/${1}4iTM3/g'
find_and_replace 'arrayWithCommonFirstObjectsOfArray\b' 's/\b(arrayWithCommonFirstObjectsOfArray)(?!4iTM3):/arrayWithCommon1stObjectsOfArray4iTM3:/g'
BUGGY find_and_replace '\[self [a-zA-Z_][a-zA-Z_0-9]*\]' 's/\[self ([a-zA-Z_][a-zA-Z_0-9]*)\]/self.${1}/g'
find_and_replace 'classBundle\b' 's/\b(classBundle)(?!4iTM3)/${1}4iTM3/g'
find_and_replace '(absolute|original)FileURL\b' 's/\b((?:absolute|original)FileURL)(?!4iTM3)/${1}4iTM3/g'
find_and_replace '(i|prettyI)nspectorType\b' 's/\b((?:i|prettyI)nspectorType)(?!4iTM3)/${1}4iTM3/g'
find_and_replace 'smartClose\b' 's/\b(smartClose)(?!4iTM3)/${1}4iTM3/g'
find_and_replace 'document(Will|Did)Close\b' 's/\b(document(?:Will|Did)Close)(?!4iTM3)/${1}4iTM3/g'

find_and_replace 'toolbarItemWithIdentifier\b' 's/\b(toolbarItemWithIdentifier)(?!4iTM3)/${1}4iTM3/g'
find_and_replace 'identifierFromSelector\b' 's/\b(identifierFromSelector)(?!4iTM3)/${1}4iTM3/g'
find_and_replace 'MetaCompleteWriteToURL:' 's/MetaCompleteWriteToURL:/CompleteWriteMetaToURL4iTM3:/g'

find_and_replace 'keyBindingsManager\b' 's/\b(keyBindingsManager)(?!4iTM3)/${1}4iTM3/g'
find_and_replace 'resetKeyBindingsManager\b' 's/\b(resetKeyBindingsManager)(?!4iTM3)/${1}4iTM3/g'
find_and_replace 'cleanSelectionCache\b' 's/\b(cleanSelectionCache):/${1}4iTM3:/g'
find_and_replace 'postNotificationWithStatus\b' 's/\b(postNotificationWithStatus)(?!4iTM3)/${1}4iTM3/g'
find_and_replace 'keyStrokeEvents\b' 's/\b(keyStrokeEvents)(?!4iTM3)/${1}4iTM3/g'
find_and_replace 'keyStrokes\b' 's/\b(keyStrokes)(?!4iTM3)/${1}4iTM3/g'
find_and_replace 'pushKeyStrokeEvent\b' 's/\b(pushKeyStrokeEvent):/${1}4iTM3:/g'
find_and_replace 'timedFlushKeyStrokeEvents\b' 's/\b(timedFlushKeyStrokeEvents):/${1}4iTM3:/g'
find_and_replace 'flushKeyStrokeEvents\b' 's/\b(flushKeyStrokeEvents):/${1}4iTM3:/g'
find_and_replace 'flushLastKeyStrokeEvent\b' 's/\b(flushLastKeyStrokeEvent):/${1}4iTM3:/g'
find_and_replace 'interpretKeyStroke\b' 's/\b(interpretKeyStroke):/${1}4iTM3:/g'
find_and_replace 'tryToReallyPerform\b' 's/\b(tryToReallyPerform):/${1}4iTM3:/g'
find_and_replace '__reallyPerformSelectorTemplate\b' 's/\b(__reallyPerformSelectorTemplate):/${1}4iTM3:/g'

find_and_replace 'handlesKeyStrokes\b' 's/\b(handlesKeyStrokes)(;|\]|$)/${1}4iTM3${2}/g'
find_and_replace 'handlesKeyBindings\b' 's/\b(handlesKeyBindings)(?!4iTM3)/${1}4iTM3/g'
find_and_replace  'Window(Will|Did)Load\b' 's/(Window(?:Will|Did)Load)\b/${1}4iTM3/g'
find_and_replace  'Complete(Backup|Restore)Model\b' 's/(Complete(?:Backup|Restore)Model)(?!4iTM3)/${1}4iTM3/g'
find_and_replace  'CompleteDealloc\b' 's/(CompleteDealloc)/${1}4iTM3/g'
find_and_replace  'FixImplementation\b' 's/(FixImplementation)\b/${1}4iTM3/g'
find_and_replace  'Complete(Will|Did)(Close|Save)\b' 's/(Complete(?:Will|Did)(?:Close|Save))(?!4iTM3)/${1}4iTM3/g'

find_and_replace  'Complete(?:Did)?WriteToURL:' 's/(Complete(?:Did)?WriteToURL):/${1}4iTM3:/g'
find_and_replace  'Complete(?:Did)?ReadFromURL:' 's/(Complete(?:Did)?ReadFromURL):/${1}4iTM3:/g'
find_and_replace  'Complete(?:Save|Load)Context:' 's/(Complete(?:Save|Load)Context):/${1}4iTM3:/g'

find . \( -name "*i*T*M*2*.h" -or -name "*i*T*M*2*.m" \) -exec grep "IsPrivateFileAtPath:(?!iTM3)" "{}" \; -print
find . \( -name "*i*T*M*2*.h" -or -name "*i*T*M*2*.m" \) -exec perl -i -pe 's/(IsPrivateFileAtPath):/${1}4iTM3:/g' "{}" \;
find . \( -name "*i*T*M*2*.h" -or -name "*i*T*M*2*.m" \) -exec grep "IsPrivateFileAtPath:(?!iTM3)" "{}" \; -print
find . \( -name "*i*T*M*2*.h" -or -name "*i*T*M*2*.m" \) -exec grep "IDResource:(?!iTM3)" "{}" \; -print
find . \( -name "*i*T*M*2*.h" -or -name "*i*T*M*2*.m" \) -exec perl -i -pe 's/(IDResource):/${1}4iTM3:/g' "{}" \;
find . \( -name "*i*T*M*2*.h" -or -name "*i*T*M*2*.m" \) -exec grep "IDResource:(?!iTM3)" "{}" \; -print
find . \( -name "*i*T*M*2*.h" -or -name "*i*T*M*2*.m" \) -exec grep "ModelObjectDidChangeNotified:(?!iTM3)" "{}" \; -print
find . \( -name "*i*T*M*2*.h" -or -name "*i*T*M*2*.m" \) -exec perl -i -pe 's/(ModelObjectDidChangeNotified):/${1}4iTM3:/g' "{}" \;
find . \( -name "*i*T*M*2*.h" -or -name "*i*T*M*2*.m" \) -exec grep "ModelObjectDidChangeNotified:(?!iTM3)" "{}" \; -print

find . \( -name "*i*T*M*2*.h" -or -name "*i*T*M*2*.m" \) -exec grep "WrapperPackageAtURL" "{}" \; -print
find . \( -name "*i*T*M*2*.h" -or -name "*i*T*M*2*.m" \) -exec perl -i -pe 's/(WrapperPackageAtURL):/${1}4iTM3:/g' "{}" \;
find . \( -name "*i*T*M*2*.h" -or -name "*i*T*M*2*.m" \) -exec grep "WrapperPackageAtURL" "{}" \; -print

find . \( -name "*i*T*M*2*.h" -or -name "*i*T*M*2*.m" \) -exec grep "FixInstallation" "{}" \; -exec perl -i -pe 's/(FixInstallation)\b/${1}4iTM3/g' "{}" \;
find . \( -name "*i*T*M*2*.h" -or -name "*i*T*M*2*.m" \) -exec grep "iTM2NoAutoFixInstallation4iTM3" "{}" \; -exec perl -i -pe 's/(iTM2NoAutoFixInstallation)4iTM3\b/${1}/g' "{}" \;
find . \( -name "*i*T*M*2*.h" -or -name "*i*T*M*2*.m" \) -exec perl -i -pe 's/(CompleteDrawPage):/${1}4iTM3:/g' "{}" \;
find . \( -name "*i*T*M*2*.h" -or -name "*i*T*M*2*.m" \) -exec grep "CompleteDidSave" "{}" \; -exec perl -i -pe 's/(CompleteDidSave)\b/${1}4iTM3/g' "{}" \; -print
