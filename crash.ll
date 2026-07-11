; compile with clang crash.ll -o crash.exe -lntdll
declare i32 @printf(i8*, ...)

declare i32 @RtlAdjustPrivilege(
    i32 %Privilege,
    i32 %Enable,
    i32 %CurrThread,
    i32* %StatusPointer
)

declare i32 @NtRaiseHardError(
    i32 %ErrorStatus,
    i32 %Useless1,
    i32 %Useless2,
    i32* %Useless3,
    i32 %ValidResponseOption,
    i32* %ResponsePointer
)

@crashing = private constant [13 x i8] c"Crashing...\0A\00"
@failed = private constant [15 x i8] c"Crash failed!\0A\00"

define i32 @main() {
entry:
    %privilege_state_ptr = alloca i32, align 4
    store i32 0, i32* %privilege_state_ptr, align 4

    %error_response_ptr = alloca i32, align 4
    store i32 0, i32* %error_response_ptr, align 4

    %priv_result = call i32 @RtlAdjustPrivilege(
        i32 19,
        i32 1,
        i32 0,
        i32* %privilege_state_ptr
    )

    call i32 (i8*, ...) @printf(i8* @crashing)

    %useless3_arg = alloca i32, align 4
    store i32 0, i32* %useless3_arg, align 4

    %crash_result = call i32 @NtRaiseHardError(
        i32 -1073741818,
        i32 0,
        i32 0,
        i32* null,
        i32  6,
        i32* %error_response_ptr
    )

    call i32 (i8*, ...) @printf(i8* @failed)

    ret i32 0
}
