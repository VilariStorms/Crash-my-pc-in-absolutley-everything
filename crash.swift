// compile with `swiftc crash.swift -lntdll`
import WinSDK

@_silgen_name("RtlAdjustPrivilege")
func RtlAdjustPrivilege(
    _ Privilege: UInt32,
    _ Enable: Bool,
    _ CurrentThread: Bool,
    _ Enabled: UnsafeMutablePointer<Bool>
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

var privilegeState = false
var errorResponse = UInt32(0)

withUnsafeMutablePointer(to: &privilegeState) { statusPtr in
    withUnsafeMutablePointer(to: &errorResponse) { responsePtr in
        let _ = RtlAdjustPrivilege(19, true, false, statusPtr)
        print("Crashing...")
        let _ = NtRaiseHardError(
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
