import XCTest
@testable import XcbeautifyLib

final class XcbeautifyLibTests: XCTestCase {
    var parser: Parser!

    override func setUpWithError() throws {
        try super.setUpWithError()
        parser = Parser(colored: false, additionalLines: { nil } )
    }

    private func noColoredFormatted(_ string: String) -> String? {
        return parser.parse(line: string)
    }

    func testAggregateTarget() {
        let formatted = noColoredFormatted("=== BUILD AGGREGATE TARGET Be Aggro OF PROJECT AggregateExample WITH CONFIGURATION Debug ===")
        XCTAssertEqual(formatted, "Aggregate target Be Aggro of project AggregateExample with configuration Debug")
    }

    func testAnalyze() {
        let formatted = noColoredFormatted("AnalyzeShallow /Users/admin/CocoaLumberjack/Classes/DDTTYLogger.m normal x86_64 (in target: CocoaLumberjack-Static)")
        XCTAssertEqual(formatted, "[CocoaLumberjack-Static] Analyzing DDTTYLogger.m")
    }

    func testAnalyzeTarget() {
        let formatted = noColoredFormatted("=== ANALYZE TARGET The Spacer OF PROJECT Pods WITH THE DEFAULT CONFIGURATION Debug ===")
        XCTAssertEqual(formatted, "Analyze target The Spacer of project Pods with configuration Debug")
    }

    func testBuildTarget() {
        let formatted = noColoredFormatted("=== BUILD TARGET The Spacer OF PROJECT Pods WITH THE DEFAULT CONFIGURATION Debug ===")
        XCTAssertEqual(formatted, "Build target The Spacer of project Pods with configuration Debug")
    }

    func testCheckDependenciesErrors() {
    }

    func testCheckDependencies() {
    }

    func testClangError() {
        let formatted = noColoredFormatted("clang: error: linker command failed with exit code 1 (use -v to see invocation)")
        XCTAssertEqual(formatted, "[x] clang: error: linker command failed with exit code 1 (use -v to see invocation)")
    }

    func testCleanRemove() {
        let formatted = noColoredFormatted("Clean.Remove clean /Users/admin/Library/Developer/Xcode/DerivedData/MyLibrary-abcd/Build/Intermediates/MyLibrary.build/Debug-iphonesimulator/MyLibraryTests.build")
        XCTAssertEqual(formatted, "Cleaning MyLibraryTests.build")
    }

    func testCleanTarget() {
        let formatted = noColoredFormatted("=== ANALYZE TARGET The Spacer OF PROJECT Pods WITH THE DEFAULT CONFIGURATION Debug ===")
        XCTAssertEqual(formatted, "Analyze target The Spacer of project Pods with configuration Debug")
    }

    func testCodesignFramework() {
        let formatted = noColoredFormatted("CodeSign build/Release/MyFramework.framework/Versions/A")
        XCTAssertEqual(formatted, "Signing build/Release/MyFramework.framework")
    }

    func testCodesign() {
        let formatted = noColoredFormatted("CodeSign build/Release/MyApp.app")
        XCTAssertEqual(formatted, "Signing MyApp.app")
    }

    func testMultipleCodesigns() {
        let formattedApp = noColoredFormatted("CodeSign build/Release/MyApp.app")
        let formattedFramework = noColoredFormatted("CodeSign build/Release/MyFramework.framework/Versions/A (in target 'X' from project 'Y')")
        XCTAssertEqual(formattedApp, "Signing MyApp.app")
        XCTAssertEqual(formattedFramework, "Signing build/Release/MyFramework.framework")
    }

    func testCompileCommand() {
    }

    func testCompileError() {
        let inputError = "/path/file.swift:64:69: error: cannot find 'input' in scope"
        let outputError = "[x] /path/file.swift:64:69: cannot find 'input' in scope\n\n"
        XCTAssertEqual(noColoredFormatted(inputError), outputError)

        let inputFatal = "/path/file.swift:64:69: fatal error: cannot find 'input' in scope"
        let outputFatal = "[x] /path/file.swift:64:69: cannot find 'input' in scope\n\n"
        XCTAssertEqual(noColoredFormatted(inputFatal), outputFatal)
    }

    func testCompile() {
#if os(macOS)
        // Xcode 10 and before
        let input1 = "CompileSwift normal x86_64 /Users/admin/dev/Swifttrain/xcbeautify/Sources/xcbeautify/setup.swift (in target: xcbeautify)"
        // Xcode 11+'s output
        let input2 = "CompileSwift normal x86_64 /Users/admin/dev/Swifttrain/xcbeautify/Sources/xcbeautify/setup.swift (in target 'xcbeautify' from project 'xcbeautify')"
        let output = "[xcbeautify] Compiling setup.swift"
        XCTAssertEqual(noColoredFormatted(input1), output)
        XCTAssertEqual(noColoredFormatted(input2), output)
#endif
    }

    func testCompileStoryboard() {
        let formatted = noColoredFormatted("CompileStoryboard /Users/admin/MyApp/MyApp/Main.storyboard (in target: MyApp)")
        XCTAssertEqual(formatted, "[MyApp] Compiling Main.storyboard")
    }

    func testCompileWarning() {
        let input = "/path/file.swift:64:69: warning: 'flatMap' is deprecated: Please use compactMap(_:) for the case where closure returns an optional value"
        let output = "[!]  /path/file.swift:64:69: 'flatMap' is deprecated: Please use compactMap(_:) for the case where closure returns an optional value\n\n"
        XCTAssertEqual(noColoredFormatted(input), output)
    }

    func testCompileXib() {
        let input = "CompileXIB /path/file.xib (in target 'MyApp' from project 'MyProject')"
        let output = "[MyApp] Compiling file.xib"
        XCTAssertEqual(noColoredFormatted(input), output)
    }

    func testCopyHeader() {
        let input = "CpHeader /path/to/destination/file.h /path/file.h (in target 'MyApp' from project 'MyProject')"
        let output = "[MyApp] Copying file.h"
        XCTAssertEqual(noColoredFormatted(input), output)
    }

    func testCopyPlist() {
        let input = "CopyPlistFile /path/to/destination/file.plist /path/file.plist (in target 'MyApp' from project 'MyProject')"
        let output = "[MyApp] Copying file.plist"
        XCTAssertEqual(noColoredFormatted(input), output)
    }

    func testCopyStrings() {
        let input = "CopyStringsFile /path/to/destination/file.strings /path/file.strings (in target 'MyApp' from project 'MyProject')"
        let output = "[MyApp] Copying file.strings"
        XCTAssertEqual(noColoredFormatted(input), output)
    }

    func testCpresource() {
        let input = "CpResource /path/to/destination/file.ttf /path/file.ttf (in target 'MyApp' from project 'MyProject')"
        let output = "[MyApp] Copying file.ttf"
        XCTAssertEqual(noColoredFormatted(input), output)
    }

    func testCursor() {
    }

    func testExecuted() throws {
        let input1 = "Test Suite 'All tests' failed at 2022-01-15 21:31:49.073."
        let input2 = "Executed 3 tests, with 2 failures (1 unexpected) in 0.112 (0.112) seconds"

        let input3 = "Test Suite 'All tests' passed at 2022-01-15 21:33:49.073."
        let input4 = "Executed 1 test, with 1 failure (1 unexpected) in 0.200 (0.200) seconds"

        // First test plan
        XCTAssertNil(parser.summary)
        XCTAssertFalse(parser.needToRecordSummary)
        let formatted1 = noColoredFormatted(input1)
#if os(macOS)
        // FIXME: Failing on Linux
        XCTAssertTrue(parser.needToRecordSummary)
#endif
        let formatted2 = noColoredFormatted(input2)
        XCTAssertFalse(parser.needToRecordSummary)
        XCTAssertNil(formatted1)
        XCTAssertNil(formatted2)

#if os(macOS)
        // FIXME: Failing on Linux
        var summary = try XCTUnwrap(parser.summary)

        XCTAssertEqual(summary.testsCount, 3)
        XCTAssertEqual(summary.failuresCount, 2)
        XCTAssertEqual(summary.unexpectedCount, 1)
        XCTAssertEqual(summary.skippedCount, 0)
        XCTAssertEqual(summary.time, 0.112)

        // Second test plan
        XCTAssertNotNil(parser.summary)
        XCTAssertFalse(parser.needToRecordSummary)
        let formatted3 = noColoredFormatted(input3)
        XCTAssertTrue(parser.needToRecordSummary)
        let formatted4 = noColoredFormatted(input4)
        XCTAssertFalse(parser.needToRecordSummary)
        XCTAssertNil(formatted3)
        XCTAssertNil(formatted4)

        summary = try XCTUnwrap(parser.summary)

        XCTAssertEqual(summary.testsCount, 4)
        XCTAssertEqual(summary.failuresCount, 3)
        XCTAssertEqual(summary.unexpectedCount, 2)
        XCTAssertEqual(summary.skippedCount, 0)
        XCTAssertEqual(summary.time, 0.312)
#endif
    }

    func testExecutedWithSkipped() {
        let input1 = "Test Suite 'All tests' failed at 2022-01-15 21:31:49.073."
        let input2 = "Executed 56 tests, with 3 test skipped and 2 failures (1 unexpected) in 1.029 (1.029) seconds"

        let input3 = "Test Suite 'All tests' passed at 2022-01-15 21:33:49.073."
        let input4 = "Executed 1 test, with 1 test skipped and 1 failure (1 unexpected) in 3.000 (3.000) seconds"

        // First test plan
        XCTAssertNil(parser.summary)
        XCTAssertFalse(parser.needToRecordSummary)
        let formatted1 = noColoredFormatted(input1)
        XCTAssertTrue(parser.needToRecordSummary)
        let formatted2 = noColoredFormatted(input2)
        XCTAssertFalse(parser.needToRecordSummary)
        XCTAssertNil(formatted1)
        XCTAssertNil(formatted2)
        XCTAssertNotNil(parser.summary)

        XCTAssertEqual(parser.summary?.testsCount, 56)
        XCTAssertEqual(parser.summary?.failuresCount, 2)
        XCTAssertEqual(parser.summary?.unexpectedCount, 1)
        XCTAssertEqual(parser.summary?.skippedCount, 3)
        XCTAssertEqual(parser.summary?.time, 1.029)

        // Second test plan
        XCTAssertNotNil(parser.summary)
        XCTAssertFalse(parser.needToRecordSummary)
        let formatted3 = noColoredFormatted(input3)
        XCTAssertTrue(parser.needToRecordSummary)
        let formatted4 = noColoredFormatted(input4)
        XCTAssertFalse(parser.needToRecordSummary)
        XCTAssertNil(formatted3)
        XCTAssertNil(formatted4)
        XCTAssertNotNil(parser.summary)

        XCTAssertEqual(parser.summary?.testsCount, 57)
        XCTAssertEqual(parser.summary?.failuresCount, 3)
        XCTAssertEqual(parser.summary?.unexpectedCount, 2)
        XCTAssertEqual(parser.summary?.skippedCount, 4)
        XCTAssertEqual(parser.summary?.time, 4.029)
    }

    func testFailingTest() {
    }

    func testFatalError() {
        let input = "fatal error: malformed or corrupted AST file: 'could not find file '/path/file.h' referenced by AST file' note: after modifying system headers, please delete the module cache at '/path/DerivedData/ModuleCache/M5WJ0FYE7N06'"
        let output = "[x] fatal error: malformed or corrupted AST file: 'could not find file '/path/file.h' referenced by AST file' note: after modifying system headers, please delete the module cache at '/path/DerivedData/ModuleCache/M5WJ0FYE7N06'"
        XCTAssertEqual(noColoredFormatted(input), output)
    }

    func testFileMissingError() {
        let input = "<unknown>:0: error: no such file or directory: '/path/file.swift'"
        let output = "[x] /path/file.swift: error: no such file or directory:"
        XCTAssertEqual(noColoredFormatted(input), output)
   }

    func testGenerateCoverageData() {
        let formatted = noColoredFormatted("Generating coverage data...")
        XCTAssertEqual(formatted, "Generating code coverage data...")
    }

    func testGeneratedCoverageReport() {
        let formatted = noColoredFormatted("Generated coverage report: /path/to/code coverage.xccovreport")
        XCTAssertEqual(formatted, "Generated code coverage report: /path/to/code coverage.xccovreport")
    }

    func testGenerateDsym() {
        let input = "GenerateDSYMFile /path/file.dSYM /path/to/file (in target 'MyApp' from project 'MyProject')"
        let output = "[MyApp] Generating file.dSYM"
        XCTAssertEqual(noColoredFormatted(input), output)
    }

    func testGenericWarning() {
        let input = "warning: some warning here 123"
        let output = "[!] some warning here 123"
        XCTAssertEqual(noColoredFormatted(input), output)
    }

    func testLdError() {
        let inputLdLibraryError = "ld: library not found for -lPods-Yammer"
        XCTAssertEqual(noColoredFormatted(inputLdLibraryError), "[x] ld: library not found for -lPods-Yammer")

        let inputLdSymbolsError = "ld: symbol(s) not found for architecture x86_64"
        XCTAssertEqual(noColoredFormatted(inputLdSymbolsError), "[x] ld: symbol(s) not found for architecture x86_64")
    }

    func testLdWarning() {
        let input = "ld: warning: embedded dylibs/frameworks only run on iOS 8 or later"
        let output = "[!] ld: embedded dylibs/frameworks only run on iOS 8 or later"
        XCTAssertEqual(noColoredFormatted(input), output)
    }

    func testLibtool() {
    }

    func testLinkerDuplicateSymbolsLocation() {
    }

    func testLinkerDuplicateSymbols() {
    }

    func testLinkerUndefinedSymbolLocation() {
    }

    func testLinkerUndefinedSymbols() {
    }

    func testLinking() {
#if os(macOS)
        let formatted = noColoredFormatted("Ld /Users/admin/Library/Developer/Xcode/DerivedData/xcbeautify-abcd/Build/Products/Debug/xcbeautify normal x86_64 (in target: xcbeautify)")
        XCTAssertEqual(formatted, "[xcbeautify] Linking xcbeautify")

        let formatted2 = noColoredFormatted("Ld /Users/admin/Library/Developer/Xcode/DerivedData/MyApp-abcd/Build/Intermediates.noindex/ArchiveIntermediates/MyApp/IntermediateBuildFilesPath/MyApp.build/Release-iphoneos/MyApp.build/Objects-normal/armv7/My\\ App normal armv7 (in target: MyApp)")
        XCTAssertEqual(formatted2, "[MyApp] Linking My\\ App")
#endif
    }

    func testModuleIncludesError() {
    }

    func testNoCertificate() {
    }

    func testParallelTestCaseFailed() {
        let formatted = noColoredFormatted("Test case 'XcbeautifyLibTests.testBuildTarget()' failed on 'xctest (49438)' (0.131 seconds)")
        XCTAssertEqual(formatted, "    ✖ testBuildTarget on 'xctest (49438)' (0.131 seconds)")
    }

    func testParallelTestCasePassed() {
        let formatted = noColoredFormatted("Test case 'XcbeautifyLibTests.testBuildTarget()' passed on 'xctest (49438)' (0.131 seconds)")
        XCTAssertEqual(formatted, "    ✔ testBuildTarget on 'xctest (49438)' (0.131 seconds)")
    }

    func testConcurrentDestinationTestSuiteStarted() {
        let formatted = noColoredFormatted("Test suite 'XcbeautifyLibTests (iOS).xctest' started on 'iPhone X'")
        XCTAssertEqual(formatted, "Test Suite XcbeautifyLibTests (iOS).xctest started on 'iPhone X'")
    }

    func testConcurrentDestinationTestCaseFailed() {
        let formatted = noColoredFormatted("Test case 'XcbeautifyLibTests.testBuildTarget()' failed on 'iPhone X' (77.158 seconds)")
        XCTAssertEqual(formatted, "    ✖ testBuildTarget on 'iPhone X' (77.158 seconds)")
    }

    func testConcurrentDestinationTestCasePassed() {
        let formatted = noColoredFormatted("Test case 'XcbeautifyLibTests.testBuildTarget()' passed on 'iPhone X' (77.158 seconds)")
        XCTAssertEqual(formatted, "    ✔ testBuildTarget on 'iPhone X' (77.158 seconds)")
    }

    func testParallelTestCaseAppKitPassed() {
        let formatted = noColoredFormatted("Test case '-[XcbeautifyLibTests.XcbeautifyLibTests testBuildTarget]' passed on 'xctest (49438)' (0.131 seconds).")
        XCTAssertEqual(formatted, "    ✔ testBuildTarget (0.131) seconds)")
    }

    func testParallelTestingStarted() {
        let formatted = noColoredFormatted("Testing started on 'iPhone X'")
        XCTAssertEqual(formatted, "Testing started on 'iPhone X'")
    }

    func testParallelTestingPassed() {
        let formatted = noColoredFormatted("Testing passed on 'iPhone X'")
        XCTAssertEqual(formatted, "Testing passed on 'iPhone X'")
    }

    func testParallelTestingFailed() {
        let formatted = noColoredFormatted("Testing failed on 'iPhone X'")
        XCTAssertEqual(formatted, "Testing failed on 'iPhone X'")
    }

    func testPbxcp() {
        let formatted = noColoredFormatted("PBXCp /Users/admin/CocoaLumberjack/Classes/Extensions/DDDispatchQueueLogFormatter.h /Users/admin/Library/Developer/Xcode/DerivedData/Lumberjack-abcd/Build/Products/Release/include/CocoaLumberjack/DDDispatchQueueLogFormatter.h (in target: CocoaLumberjack-Static)")
        XCTAssertEqual(formatted, "[CocoaLumberjack-Static] Copying DDDispatchQueueLogFormatter.h")
    }

    func testPhaseScriptExecution() {
        let input1 = "PhaseScriptExecution [CP]\\ Check\\ Pods\\ Manifest.lock /Users/admin/Library/Developer/Xcode/DerivedData/App-abcd/Build/Intermediates.noindex/ArchiveIntermediates/App/IntermediateBuildFilesPath/App.build/Release-iphoneos/App.build/Script-53BECF2B2F2E203E928C31AE.sh (in target: App)"
        let input2 = "PhaseScriptExecution [CP]\\ Check\\ Pods\\ Manifest.lock /Users/admin/Library/Developer/Xcode/DerivedData/App-abcd/Build/Intermediates.noindex/ArchiveIntermediates/App/IntermediateBuildFilesPath/App.build/Release-iphoneos/App.build/Script-53BECF2B2F2E203E928C31AE.sh (in target 'App' from project 'App')"
        XCTAssertEqual(noColoredFormatted(input1), "[App] Running script [CP] Check Pods Manifest.lock")
        XCTAssertEqual(noColoredFormatted(input2), "[App] Running script [CP] Check Pods Manifest.lock")
    }

    func testPhaseSuccess() {
        let formatted = noColoredFormatted("** CLEAN SUCCEEDED ** [0.085 sec]")
        XCTAssertEqual(formatted, "Clean Succeeded")
    }

    func testPodsError() {
        let input = "error: The sandbox is not in sync with the Podfile.lock. Run 'pod install' or update your CocoaPods installation."
        let output = "[x] error: The sandbox is not in sync with the Podfile.lock. Run 'pod install' or update your CocoaPods installation."
        XCTAssertEqual(noColoredFormatted(input), output)
    }

    func testPreprocess() {
    }

    func testProcessInfoPlist() {
        let formatted = noColoredFormatted("ProcessInfoPlistFile /Users/admin/Library/Developer/Xcode/DerivedData/xcbeautify-abcd/Build/Products/Debug/Guaka.framework/Versions/A/Resources/Info.plist /Users/admin/xcbeautify/xcbeautify.xcodeproj/Guaka_Info.plist")
        XCTAssertEqual(formatted, "Processing Guaka_Info.plist")
    }

    func testProcessPchCommand() {
        let formatted = noColoredFormatted("/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang -x c++-header -target x86_64-apple-macos10.13 -c /path/to/my.pch -o /path/to/output/AcVDiff_Prefix.pch.gch")
        XCTAssertEqual(formatted, "Preprocessing /path/to/my.pch")
    }

    func testProcessPchCommandArbitraryExtension() {
        let formatted = noColoredFormatted(#"/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang -x c++-header -target x86_64-apple-macos12.3 -c /path/with\ space/cmake_pch.hxx -o /path/with\ space/build/SharedPrecompiledHeaders/SharedPrecompiledHeaders/2304651503107189736/cmake_pch.hxx.gch --serialize-diagnostics /path/with\ space/build/SharedPrecompiledHeaders/SharedPrecompiledHeaders/2304651503107189736/cmake_pch.hxx.dia"#)
        XCTAssertEqual(formatted, #"Preprocessing /path/with\ space/cmake_pch.hxx"#)
    }

    func testProcessPch() {
        let formatted = noColoredFormatted("ProcessPCH /Users/admin/Library/Developer/Xcode/DerivedData/Lumberjack-abcd/Build/Intermediates.noindex/PrecompiledHeaders/SharedPrecompiledHeaders/5872309797734264511/CocoaLumberjack-Prefix.pch.gch /Users/admin/CocoaLumberjack/Framework/Lumberjack/CocoaLumberjack-Prefix.pch normal x86_64 objective-c com.apple.compilers.llvm.clang.1_0.analyzer (in target: CocoaLumberjack)")
        XCTAssertEqual(formatted, "[CocoaLumberjack] Processing CocoaLumberjack-Prefix.pch")
    }

    func testProcessPchArbitraryExtension() {
        let formatted = noColoredFormatted(#"ProcessPCH++ /Users/admin/src/Test\ Folder/_builds/SharedPrecompiledHeaders/SharedPrecompiledHeaders/2304651503107189736/cmake_pch.hxx.gch /Users/admin/src/Test\ Folder/_builds/CMakeFiles/foo.dir/Debug/cmake_pch.hxx normal x86_64 c++ com.apple.compilers.llvm.clang.1_0.compiler (in target 'foo' from project 'foo')"#)
        XCTAssertEqual(formatted, "[foo] Processing cmake_pch.hxx")
    }

    func testProcessPchPlusPlus() {
        let formatted = noColoredFormatted("ProcessPCH++ /Users/admin/Library/Developer/Xcode/DerivedData/Lumberjack-abcd/Build/Intermediates.noindex/PrecompiledHeaders/SharedPrecompiledHeaders/5872309797734264511/CocoaLumberjack-Prefix.pch.gch /Users/admin/CocoaLumberjack/Framework/Lumberjack/CocoaLumberjack-Prefix.pch normal x86_64 objective-c com.apple.compilers.llvm.clang.1_0.analyzer (in target: CocoaLumberjack)")
        XCTAssertEqual(formatted, "[CocoaLumberjack] Processing CocoaLumberjack-Prefix.pch")
    }

    func testProvisioningProfileRequired() {
        let input = #"MyProject requires a provisioning profile. Select a provisioning profile for the "Debug" build configuration in the project editor."#
        let output = #"[x] MyProject requires a provisioning profile. Select a provisioning profile for the "Debug" build configuration in the project editor."#
        XCTAssertEqual(noColoredFormatted(input), output)
    }

    func testRestartingTests() {
        let formatted = noColoredFormatted( "Restarting after unexpected exit, crash, or test timeout in HomePresenterTest.testIsCellPresented(); summary will include totals from previous launches.")
        XCTAssertEqual(formatted, "    ✖ Restarting after unexpected exit, crash, or test timeout in HomePresenterTest.testIsCellPresented(); summary will include totals from previous launches.")
    }

    func testShellCommand() {
        let formatted = noColoredFormatted("    cd /foo/bar/baz")
        XCTAssertNil(formatted)
        XCTAssertEqual(parser.outputType, .task)
    }

    func testSymbolReferencedFrom() {
        let formatted = noColoredFormatted( "  \"NetworkBusiness.ImageDownloadManager.saveImage(image: __C.UIImage, needWatermark: Swift.Bool, params: [Swift.String : Any], downloadHandler: (Swift.Bool) -> ()?) -> ()\", referenced from:")
        XCTAssertEqual(formatted, "[x]   \"NetworkBusiness.ImageDownloadManager.saveImage(image: __C.UIImage, needWatermark: Swift.Bool, params: [Swift.String : Any], downloadHandler: (Swift.Bool) -> ()?) -> ()\", referenced from:")
        XCTAssertEqual(parser.outputType, .warning)
    }

    func testUndefinedSymbolLocation() {
        let formatted = noColoredFormatted( "      MediaBrowser.ChatGalleryViewController.downloadImage() -> () in MediaBrowser(ChatGalleryViewController.o)")
        XCTAssertEqual(formatted, "[!]       MediaBrowser.ChatGalleryViewController.downloadImage() -> () in MediaBrowser(ChatGalleryViewController.o)")
        XCTAssertEqual(parser.outputType, .warning)
    }

    func testTestCaseMeasured() {
#if os(macOS)
        let formatted = noColoredFormatted(#"/Users/cyberbeni/Desktop/framework/TypedNotificationCenter/<compiler-generated>:54: Test Case '-[TypedNotificationCenterPerformanceTests.BridgedNotificationTests test_subscribing_2senders_notificationName]' measured [High Water Mark For Heap Allocations, KB] average: 5407.634, relative standard deviation: 45.772%, values: [9341.718750, 3779.468750, 3779.468750, 9630.344727, 3779.468750, 3779.468750, 3895.093750, 3779.468750, 8532.372070, 3779.468750], performanceMetricID:com.apple.XCTPerformanceMetric_HighWaterMarkForHeapAllocations, baselineName: "", baselineAverage: , polarity: prefers smaller, maxPercentRegression: 10.000%, maxPercentRelativeStandardDeviation: 10.000%, maxRegression: 1.000, maxStandardDeviation: 1.000"#)
        XCTAssertEqual(formatted, #"    ◷ test_subscribing_2senders_notificationName measured (5407.634 KB ±45.772% -- High Water Mark For Heap Allocations)"#)
#endif
    }

    func testTestCasePassed() {
#if os(macOS)
        let formatted = noColoredFormatted("Test Case '-[XcbeautifyLibTests.XcbeautifyLibTests testBuildTarget]' passed (0.131 seconds).")
        XCTAssertEqual(formatted, "    ✔ testBuildTarget (0.131 seconds)")
#endif
    }

    func testTestCasePending() {
    }

    func testTestCaseStarted() {
    }

    func testTestSuiteStart() {
    }

    func testTestSuiteStarted() {
    }

    func testTestSuiteAllTestsPassed() {
        let input = "Test Suite 'All tests' passed at 2022-01-15 21:31:49.073."

        XCTAssertFalse(parser.needToRecordSummary)
        let formatted = noColoredFormatted(input)
        XCTAssertNil(formatted)
        XCTAssertTrue(parser.needToRecordSummary)
    }

    func testTestSuiteAllTestsFailed() {
        let input = "Test Suite 'All tests' failed at 2022-01-15 21:31:49.073."

        XCTAssertFalse(parser.needToRecordSummary)
        let formatted = noColoredFormatted(input)
        XCTAssertNil(formatted)
        XCTAssertTrue(parser.needToRecordSummary)
    }

    func testTestsRunCompletion() {
    }

    func testTiffutil() {
        let input = "TiffUtil file.tiff"
        XCTAssertNil(noColoredFormatted(input))
        XCTAssertEqual(parser.outputType, .task)
    }

    func testTouch() {
        let formatted = noColoredFormatted("Touch /Users/admin/Library/Developer/Xcode/DerivedData/xcbeautify-dgnqmpfertotpceazwfhtfwtuuwt/Build/Products/Debug/XcbeautifyLib.framework (in target: XcbeautifyLib)")
        XCTAssertEqual(formatted, "[XcbeautifyLib] Touching XcbeautifyLib.framework")
    }

    func testUiFailingTest() {
        let formatted = noColoredFormatted("    t =    10.13s Assertion Failure: <unknown>:0: App crashed in <external symbol>")
        XCTAssertEqual(formatted, "    ✖ <unknown>:0, App crashed in <external symbol>")
    }

    func testWillNotBeCodeSigned() {
        let input = "FrameworkName will not be code signed because its settings don't specify a development team."
        let output = "[!] FrameworkName will not be code signed because its settings don't specify a development team."
        XCTAssertEqual(noColoredFormatted(input), output)
    }

    func testWriteAuxiliaryFiles() {
    }

    func testWriteFile() {
        let input = "write-file /path/file.SwiftFileList"
        XCTAssertNil(noColoredFormatted(input))
        XCTAssertEqual(parser.outputType, .task)
    }

    func testPackageGraphResolved() {

        // Start
        let start = noColoredFormatted("Resolve Package Graph")
        XCTAssertEqual(start, "Resolve Package Graph")

        // Ended
        let ended = noColoredFormatted("Resolved source packages:")
        XCTAssertEqual(ended, "Resolved source packages")

        // Package
        let package = noColoredFormatted("  StrasbourgParkAPI: https://github.com/yageek/StrasbourgParkAPI.git @ 3.0.2")
        XCTAssertEqual(package, "StrasbourgParkAPI - https://github.com/yageek/StrasbourgParkAPI.git @ 3.0.2")
    }
    
    func testXcodebuildError() {
        let formatted = noColoredFormatted("xcodebuild: error: Existing file at -resultBundlePath \"/output/file.xcresult\"")
        XCTAssertEqual(formatted, "[x] xcodebuild: error: Existing file at -resultBundlePath \"/output/file.xcresult\"")
    }
}
