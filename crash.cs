using System;
using System.Runtime.InteropServices;

class Crash {
    [DllImport("ntdll.dll")]
    private static extern int NtRaiseHardError(
        uint ErrorStatus,
        uint NumberOfParameters,
        uint UnicodeStringParameterMask,
        IntPtr Parameters,
        int ValidResponseOption,
        out int Response
    );

    [DllImport("ntdll.dll")]
    private static extern int RtlAdjustPrivilege(
        int Privilege,
        bool Enable,
        bool CurrentThread,
        out bool Enabled
    );

    static void Main() {
        bool PrivilegeState = false;
        int ErrorResponse = 0;
        RtlAdjustPrivilege(19, true, false, out PrivilegeState);
        Console.WriteLine("Crashing...");
        NtRaiseHardError(0xC0000006, 0, 0, IntPtr.Zero, 6, out ErrorResponse);
        Console.WriteLine("Crash failed!");
    }
}
