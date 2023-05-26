using System;

class Crash {
    [DllImport("ntdll.dll"), SetLastError = true]
    private static extern int NtRaiseHardError(
        int ErrorStatus,
        uint NumberOfParameters,
        uint UnicodeStringParameterMask,
        IntPtr Parameters,
        int ValidResponseOption,
        out int Response
    );

    [DllImport("ntdll.dll"), SetLastError = true]
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
        NtRaiseHardError(0xC0000006, 0, 0, null, 6, out ErrorResponse);
        Console.WriteLine("Crash failed!");
    }
}
