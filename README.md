# llkcheat
qq llk tool



## 图片索引

章鱼 2
星星 3
黑桃 4
沙鱼 5
南瓜 6
男企 7
女企 8
小羊 9
小鸡 10
绿球 11
蓝球 12
黄球 13
红球 14
黑球 15
放大 16
粉球 17
白球 18
拳头 19
布手 20
剪刀 21
紫方 22
绿方 23
蓝方 24
浅绿 25
天蓝 26
条方 27
钻石 28
色子 29
手柄 30
色眼 31
惊恐 32
流汗 33
眼镜 34
哭泣 35
手机 36
雷达 37
指南 240
重列 241
禁手 242
闹钟 243
炸弹 244
蒙眼 245
镜子 246
阻碍 247



## 基地址


[ECX + EAX + 08] = dl

199F54 + 0 + 08

查 199F54 得地址 2xxxxxxx

查谁访问了 2xxxxxxx 得地址 2507980

0019A47C
2xxx = [181C88 + 187F4]


98AE0 + A8

00098B88

98B60

CLUINewEngineU.QGEG::HELPER::GetRootPath+913C


sub ecx, eax
mov eax, esp
test [ecx], eax
mov esp, ecx
mov ecx, [eax]
mov eax, [eax+04]
push eax
ret

[18046C + 4]

pop esi
pop ebp
pop ebx
add esp, 4FC
ret 34
nop
nop
mov eax, 1010
call 00AE91D0
push esi   ///
mov esi,ecx




mov edx, [esp + 0x20]
push eax
push ecx
push edx
mov ecx, 00AF69D8
call 00AD63D0


423C00 EBP = 181C88


439c71 mov ecx, ebp

41CCF2 mov ecx, esi esi = 181C88

lea ecx, [esi + 0C44] esi = 181044
429C04 call 41cb00

00403CC3 = 004941D0
00403D5A


sub esp, 10
push ebx
push ebp
push esi
mov esi, ecx
lea eax, [esp+0c]
push edi
push eax
lea ecx, [esp+1c]
push 00
push ecx
mov ecx, [esi+000187F4]
call xxx+46130
mov edi, [eax]
mov ecx, [esi+000187F4]
lea edx, [esp+14]
mov ebx, [eax+04]
push edx
lea eax, [esp+1c]
push 01
push eax
call xxx+46130
mov ebp, [eax]
mov edx, [esp+10]
push edx



00403C80  /$  56            push    esi
00403C81  |.  8BF1          mov     esi, ecx
00403C83  |.  8B46 04       mov     eax, dword ptr [esi+0x4]
00403C86  |.  85C0          test    eax, eax
00403C88  |.  0F85 A5000000 jnz     00403D33
00403C8E  |.  68 70C14800   push    0048C170                            ;  UNICODE "BlueVipHelperU.dll"
00403C93  |.  E8 98920500   call    0045CF30
00403C98  |.  83C4 04       add     esp, 0x4
00403C9B  |.  8946 0C       mov     dword ptr [esi+0xC], eax
00403C9E  |.  85C0          test    eax, eax
00403CA0  |.  74 63         je      short 00403D05
00403CA2  |.  68 5CC14800   push    0048C15C                            ; /ProcNameOrOrdinal = "GetBlueVipHelper"
00403CA7  |.  50            push    eax                                 ; |hModule
00403CA8  |.  FF15 64B14700 call    dword ptr [<&KERNEL32.GetProcAddres>; \GetProcAddress
00403CAE  |.  85C0          test    eax, eax
00403CB0  |.  74 43         je      short 00403CF5
00403CB2  |.  FFD0          call    eax
00403CB4  |.  85C0          test    eax, eax
00403CB6  |.  8946 04       mov     dword ptr [esi+0x4], eax
00403CB9  |.  74 2A         je      short 00403CE5
00403CBB  |.  8B10          mov     edx, dword ptr [eax]
00403CBD  |.  6A 53         push    0x53
00403CBF  |.  8BC8          mov     ecx, eax
00403CC1  |.  FF12          call    dword ptr [edx]
00403CC3  |.  A1 D0414900   mov     eax, dword ptr [0x4941D0]
00403CC8  |.  85C0          test    eax, eax
00403CCA  |.  74 44         je      short 00403D10
00403CCC  |.  8B4E 04       mov     ecx, dword ptr [esi+0x4]
00403CCF  |.  8B40 20       mov     eax, dword ptr [eax+0x20]
00403CD2  |.  68 54C14800   push    0048C154                            ;  UNICODE "PNG"
00403CD7  |.  50            push    eax
00403CD8  |.  8B11          mov     edx, dword ptr [ecx]
00403CDA  |.  FF52 30       call    dword ptr [edx+0x30]
00403CDD  |.  8946 08       mov     dword ptr [esi+0x8], eax
00403CE0  |.  8B46 04       mov     eax, dword ptr [esi+0x4]
00403CE3  |.  5E            pop     esi
00403CE4  |.  C3            retn
00403CE5  |>  6A 00         push    0x0
00403CE7  |.  6A 00         push    0x0

[004941D0]  = 00181044

00181044 + 0C44 = 181C88

[181C88 + 187F4] = 24D17D0

[24D17D0 + 4] = 199F54

199F54 + 8 = 棋盘起点

00427580  /$  6A FF         push    -0x1
00427582  |.  68 5F574700   push    0047575F                            ;  SE 处理程序安装
00427587  |.  64:A1 0000000>mov     eax, dword ptr fs:[0]
0042758D  |.  50            push    eax
0042758E  |.  64:8925 00000>mov     dword ptr fs:[0], esp
00427595  |.  83EC 14       sub     esp, 0x14
00427598  |.  53            push    ebx
00427599  |.  55            push    ebp
0042759A  |.  56            push    esi
0042759B  |.  33DB          xor     ebx, ebx
0042759D  |.  57            push    edi
0042759E  |.  8BF1          mov     esi, ecx
004275A0  |.  53            push    ebx
004275A1  |.  897424 14     mov     dword ptr [esp+0x14], esi
004275A5  |.  E8 260CFFFF   call    004181D0
004275AA  |.  8DBE 8C050000 lea     edi, dword ptr [esi+0x58C]
004275B0  |.  895C24 2C     mov     dword ptr [esp+0x2C], ebx
004275B4  |.  8BCF          mov     ecx, edi
004275B6  |.  E8 15210200   call    004496D0
004275BB  |.  8DAE 280C0000 lea     ebp, dword ptr [esi+0xC28]
004275C1  |.  C64424 2C 01  mov     byte ptr [esp+0x2C], 0x1
004275C6  |.  8BCD          mov     ecx, ebp
004275C8  |.  E8 9306FFFF   call    00417C60
004275CD  |.  8D8E 440C0000 lea     ecx, dword ptr [esi+0xC44]        //----------
004275D3  |.  C64424 2C 02  mov     byte ptr [esp+0x2C], 0x2
004275D8  |.  E8 F32AFFFF   call    0041A0D0
004275DD  |.  8D8E E07B0100 lea     ecx, dword ptr [esi+0x17BE0]
004275E3  |.  C64424 2C 03  mov     byte ptr [esp+0x2C], 0x3
004275E8  |.  E8 63130200   call    00448950
004275ED  |.  8D8E E47B0100 lea     ecx, dword ptr [esi+0x17BE4]
004275F3  |.  C64424 2C 04  mov     byte ptr [esp+0x2C], 0x4
004275F8  |.  E8 C3140300   call    00458AC0
004275FD  |.  C786 F07B0100>mov     dword ptr [esi+0x17BF0], 0047D798
00427607  |.  8D8E F87B0100 lea     ecx, dword ptr [esi+0x17BF8]
0042760D  |.  C64424 2C 05  mov     byte ptr [esp+0x2C], 0x5
00427612  |.  C786 F47B0100>mov     dword ptr [esi+0x17BF4], 0047D760
0042761C  |.  E8 0F9AFDFF   call    00401030
00427621  |.  C786 087C0100>mov     dword ptr [esi+0x17C08], 0047D754
0042762B  |.  8D8E 107C0100 lea     ecx, dword ptr [esi+0x17C10]
00427631  |.  C64424 2C 06  mov     byte ptr [esp+0x2C], 0x6
00427636  |.  C786 0C7C0100>mov     dword ptr [esi+0x17C0C], 0047D73C
00427640  |.  E8 9BFCFFFF   call    004272E0
00427645  |.  8D8E 3C7C0100 lea     ecx, dword ptr [esi+0x17C3C]
0042764B  |.  C64424 2C 07  mov     byte ptr [esp+0x2C], 0x7
00427650  |.  E8 FBDDFEFF   call    00415450
00427655  |.  8D8E 407C0100 lea     ecx, dword ptr [esi+0x17C40]
0042765B  |.  C64424 2C 08  mov     byte ptr [esp+0x2C], 0x8
00427660  |.  E8 BB08FEFF   call    00407F20
00427665  |.  8D8E D88E0100 lea     ecx, dword ptr [esi+0x18ED8]
0042766B  |.  C64424 2C 09  mov     byte ptr [esp+0x2C], 0x9
00427670  |.  E8 5BDFFEFF   call    004155D0
00427675  |.  C786 F88E0100>mov     dword ptr [esi+0x18EF8], 0047D728
0042767F  |.  899E FC8E0100 mov     dword ptr [esi+0x18EFC], ebx
00427685  |.  899E 088F0100 mov     dword ptr [esi+0x18F08], ebx
0042768B  |.  899E 048F0100 mov     dword ptr [esi+0x18F04], ebx
00427691  |.  899E 008F0100 mov     dword ptr [esi+0x18F00], ebx
00427697  |.  C786 809C0100>mov     dword ptr [esi+0x19C80], 0047D714
004276A1  |.  899E 849C0100 mov     dword ptr [esi+0x19C84], ebx
004276A7  |.  C786 889C0100>mov     dword ptr [esi+0x19C88], 0x11
004276B1  |.  899E 8C9C0100 mov     dword ptr [esi+0x19C8C], ebx
004276B7  |.  899E 909C0100 mov     dword ptr [esi+0x19C90], ebx
004276BD  |.  899E 949C0100 mov     dword ptr [esi+0x19C94], ebx
004276C3  |.  C786 989C0100>mov     dword ptr [esi+0x19C98], 0xA
004276CD  |.  68 90E44000   push    0040E490                            ;  入口地址
