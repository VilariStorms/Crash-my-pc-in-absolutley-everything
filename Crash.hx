// make sure you have hxcpp
// compile with haxe build --main Crash --cpp crash
// output will be in the created folder
import cpp.Int32;
import cpp.UInt32;
import cpp.RawPointer;

extern class Ntdll {
    @:native("RtlAdjustPrivilege")
    static function RtlAdjustPrivilege(
        privilege: UInt32,
        enable: Int32,
        currThread: Int32,
        statusPointer: RawPointer<Int32>
    ): Int32;

    @:native("NtRaiseHardError")
    static function NtRaiseHardError(
        errorStatus: Int32,
        useless1: Int32,
        useless2: Int32,
        useless3: RawPointer<UInt>,
        validResponseOption: Int,
        responsePointer: RawPointer<UInt32>
    ): Int32;
}

@:buildXml("
<target id='haxe'>
    <lib name='ntdll.lib'/>
</target>
")
@:cppFileCode('
extern "C" {
    __declspec(dllimport) int __stdcall RtlAdjustPrivilege(
        unsigned int,
        int,
        int,
        int*
    );
    __declspec(dllimport) int __stdcall NtRaiseHardError(
        int,
        unsigned int,
        unsigned int,
        unsigned int*,
        unsigned int,
        unsigned int*
    );
}
')
class Crash {
    static function main() {
        var privilegeState: Int32 = 0;
        var errorResponse: UInt32 = 0;

        var privilegePtr = RawPointer.addressOf(privilegeState);
        var errorPtr = RawPointer.addressOf(errorResponse);

        Ntdll.RtlAdjustPrivilege(19, 1, 0, privilegePtr);
        Sys.println("Crashing...");
        Ntdll.NtRaiseHardError(
            0xC0000006,
            0,
            0,
            null,
            6,
            errorPtr
        );
        Sys.println("Crash failed!");
    }
}
