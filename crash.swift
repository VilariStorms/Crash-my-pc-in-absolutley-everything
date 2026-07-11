// compile with `swiftc crash.swift -lntdll`
import WinSDK

@_silgen_name("RtlAdjustPrivilege")
func RtlAdjustPrivilege(
    _ Privilege: UInt32,
    _ Enable: WindowsBool,
    _ CurrentThread: WindowsBool,
    _ Enabled: UnsafeMutablePointer<WindowsBool>
) -> UInt32

@_silgen_name("NtRaiseHardError")
func NtRaiseHardError(
    _ ErrorStatus: UInt32,
    _ Useless1: UInt32,
    _ Useless2: UInt32,
    _ Useless3: UnsafeMutablePointer<Int>?,
    _ ValidResponseOption: UInt32,
    _ ResponsePointer: UnsafeMutablePointer<UInt32>
) -> UInt32

var privilegeState = WindowsBool(false)
var errorResponse = UInt32(0)

withUnsafeMutablePointer(to: &privilegeState) { statusPtr in
    withUnsafeMutablePointer(to: &errorResponse) { responsePtr in
        RtlAdjustPrivilege(19, true, false, statusPtr)
        print("Crashing...")
        NtRaiseHardError(
            0xC0000006,
            0,
            0,
            nil,
            6,
            responsePtr
        )
        print("Crash failed!")
    }
}
