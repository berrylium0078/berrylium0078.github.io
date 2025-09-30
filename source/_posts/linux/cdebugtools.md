---
title: C 调试工具使用小记
date: 2025-09-26 21:40:53
tags:
categories:
description:
---

从文档里摘抄一些比较有用的

## gdb

```
gdb [options] [executable-file [core-file or process-id]]
gdb [options] --args executable-file [inferior-arguments ...]
```

以下为常用命令的用法：

### break

```
break [LOCATION] [thread THREADNUM] [if CONDITION]

LOCATION may be a linespec, address.

Linespecs are colon-separated lists of location parameters, such as
source filename, function name, label name, and line number.
Example: To specify the start of a label named "the_top" in the
function "fact" in the file "factorial.c", use
"factorial.c:fact:the_top".

Address locations begin with "*" and specify an exact address in the
program.  Example: To specify the fourth byte past the start function
"main", use "*main + 4".
```

### run, r

开始调试，可以跟命令行参数，会通过默认 shell 解析，可以包含通配符或重定向。

默认参数为上次（通过 `set` 或 `run` 命令，或 `gdb --args`）指定的。

### continue, fg, c

用法 `continue [N]`，注意并不等同运行 `continue` $n$ 次，而是使得当前断点接下来 $n - 1$ 次不会触发，但不影响其他断点。

### next, n / ni / step, s / si

Usage: `next [N]`

执行下一条语句/指令，next 和 step 的区别是前者跳过子过程，后者跳进子过程。

### x

```
Examine memory: x/FMT ADDRESS.
ADDRESS is an expression for the memory address to examine.
FMT is a repeat count followed by a format letter and a size letter.
Format letters are o(octal), x(hex), d(decimal), u(unsigned decimal),
  t(binary), f(float), a(address), i(instruction), c(char), s(string)
  and z(hex, zero padded on the left).
Size letters are b(byte), h(halfword), w(word), g(giant, 8 bytes).
The specified number of objects of the specified size are printed
according to the format.  If a negative number is specified, memory is
examined backward from the address.
```

### print, p

打印寄存器用，`print [/FMT] [EXP]`，示例 `p $rax`

此处 `FMT` 只接受 format letter（见 `x` 命令）

## gcc

用法：`gcc [选项] 文件...`

常见选项：

- `-E`  仅作预处理，不进行编译、汇编或链接。
- `-S`  编译到汇编语言，不进行汇编和链接。
- `-c`  编译、汇编到目标代码，不进行链接。
- `-Og` Optimize debugging experience.

## objdump

用法：`objdump <选项> <文件>`
显示来自目标 `<文件>` 的信息。

用到的选项：

- `-d, --disassemble`        Display assembler contents of executable sections
