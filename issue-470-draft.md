### Random Things
Here are some things I think I've figured out:

* My "magic Kenwood bytes" `EE C2 A1 C8 42 6E 52 51 C3` are really just the Null AMBE data bytes XORed with the first 9 scrambling bytes discovered by @juribeparada: `70 4F 93 40 64 74 6D 30 2B`.
\
MMDVMHost already knows the null AMBE data bytes:
https://github.com/g4klx/MMDVMHost/blob/18398efe976f16fca76de38786a6849ac0197c74/DStarDefines.h#L30

* The last three bytes of @juribeparada's scrambling bytes were almost correct.  The E2 was in fact a 70: `70 4F 93`, which are actually the data frame scrambling bytes:
https://github.com/g4klx/MMDVMHost/blob/18398efe976f16fca76de38786a6849ac0197c74/DStarDefines.h#L56

### JARL D-Star Standard
I've translated Sections 6.1.3, 7.1, 7.2, 7.3, and part of 7.4 of http://www.jarl.com/d-star/STD5_0b.pdf and put them in [this English PDF](https://github.com/timclassic/d-star/blob/master/std5_0b.en.pdf).  The English Word document that Kenwood sent provided some language and the images for sections 7.1 and 7.2.

### Detecting DV Fast Data
I'll use @juribeparada work again to demonstrate how to detect DV Fast Data frames.  His test using `ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789` was very effective.

Here is block E from https://github.com/g4klx/MMDVMHost/issues/470#issuecomment-437725678, corrected to use `0x70` for descrambling instead of `0xE2` as described above:
```
45 46 47 48 02 49 4A 4B 4C 94 41 42     EFGH.IJKL.AB
4D 4E 4F 50 02 51 52 53 54 94 43 44     MNOP.QRST.CD
59 5A 61 62 02 63 64 65 66 94 55 56     YZab.cdef.UV
67 68 69 6A 02 6B 6C 6D 6E 94 57 58     ghij.klmn.WX
73 74 75 76 02 77 78 79 7A 94 6F 70     stuv.wxyz.op
30 31 32 33 02 34 35 36 37 94 71 72     0123.4567.qr
00 00 00 00 02 00 00 00 00 82 38 39     ..........89
00 00 00 00 02 00 00 00 00 82 00 00     ............
```
Here is an annotated version using the information from [the English PDF](https://github.com/timclassic/d-star/blob/master/std5_0b.en.pdf), separated into blocks:
```
                                MH                               MH Meaning
     Block 6                    |                                |
V12: 45 46 47 48 02 49 4A 4B 4C 94 41 42    D12: EFGH.IJKL.AB    Fast Data, 20 bytes
V13: 4D 4E 4F 50 02 51 52 53 54 94 43 44    D13: MNOP.QRST.CD    Fast Data, 20 bytes
                                |                                |
     Block 7                    |                                |
V14: 59 5A 61 62 02 63 64 65 66 94 55 56    D14: YZab.cdef.UV    Fast Data, 20 bytes
V15: 67 68 69 6A 02 6B 6C 6D 6E 94 57 58    D15: ghij.klmn.WX    Fast Data, 20 bytes
                                |                                |
     Block 8                    |                                |
V16: 73 74 75 76 02 77 78 79 7A 94 6F 70    D16: stuv.wxyz.op    Fast Data, 20 bytes
V17: 30 31 32 33 02 34 35 36 37 94 71 72    D17: 0123.4567.qr    Fast Data, 20 bytes
                                |                                |
     Block 9                    |                                |
V18: 00 00 00 00 02 00 00 00 00 82 38 39    D18: ..........89
V19: 00 00 00 00 02 00 00 00 00 82 00 00    D19: ............
```



