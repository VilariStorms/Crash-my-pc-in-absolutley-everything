import ctypes

ntdll = ctypes.WinDLL('ntdll.dll')

RtlAdjustPrivilege = ntdll.RtlAdjustPrivilege
RtlAdjustPrivilege.argtypes = (ctypes.c_ulong, ctypes.c_bool, ctypes.c_bool, ctypes.POINTER(ctypes.c_bool))
RtlAdjustPrivilege.restype = ctypes.c_ulong

NtRaiseHardError = ntdll.NtRaiseHardError
NtRaiseHardError.argtypes = (
    ctypes.c_long, ctypes.c_ulong, ctypes.c_ulong, ctypes.POINTER(ctypes.c_ulonglong),
    ctypes.c_ulong, ctypes.POINTER(ctypes.c_ulong)
)
NtRaiseHardError.restype = ctypes.c_ulong

PrivilegeState = ctypes.c_bool(False)
ErrorResponse = ctypes.c_ulong(0)

RtlAdjustPrivilege(19, True, False, ctypes.byref(PrivilegeState))
print("Crashing...")
NtRaiseHardError(0xC0000006, 0, 0, None, 6, ctypes.byref(ErrorResponse))
print("Crash failed!")
