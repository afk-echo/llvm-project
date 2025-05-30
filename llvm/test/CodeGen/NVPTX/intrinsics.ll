; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py UTC_ARGS: --version 5
; RUN: llc < %s -mtriple=nvptx -mcpu=sm_60 | FileCheck %s --check-prefixes=CHECK,CHECK32
; RUN: llc < %s -mtriple=nvptx64 -mcpu=sm_60 | FileCheck %s --check-prefixes=CHECK,CHECK64
; RUN: %if ptxas && !ptxas-12.0 %{ llc < %s -mtriple=nvptx -mcpu=sm_60 | %ptxas-verify %}
; RUN: %if ptxas %{ llc < %s -mtriple=nvptx64 -mcpu=sm_60 | %ptxas-verify %}

define float @test_fabsf(float %f) {
; CHECK-LABEL: test_fabsf(
; CHECK:       {
; CHECK-NEXT:    .reg .b32 %f<3>;
; CHECK-EMPTY:
; CHECK-NEXT:  // %bb.0:
; CHECK-NEXT:    ld.param.f32 %f1, [test_fabsf_param_0];
; CHECK-NEXT:    abs.f32 %f2, %f1;
; CHECK-NEXT:    st.param.f32 [func_retval0], %f2;
; CHECK-NEXT:    ret;
  %x = call float @llvm.fabs.f32(float %f)
  ret float %x
}

define double @test_fabs(double %d) {
; CHECK-LABEL: test_fabs(
; CHECK:       {
; CHECK-NEXT:    .reg .b64 %fd<3>;
; CHECK-EMPTY:
; CHECK-NEXT:  // %bb.0:
; CHECK-NEXT:    ld.param.f64 %fd1, [test_fabs_param_0];
; CHECK-NEXT:    abs.f64 %fd2, %fd1;
; CHECK-NEXT:    st.param.f64 [func_retval0], %fd2;
; CHECK-NEXT:    ret;
  %x = call double @llvm.fabs.f64(double %d)
  ret double %x
}

define float @test_nvvm_sqrt(float %a) {
; CHECK-LABEL: test_nvvm_sqrt(
; CHECK:       {
; CHECK-NEXT:    .reg .b32 %f<3>;
; CHECK-EMPTY:
; CHECK-NEXT:  // %bb.0:
; CHECK-NEXT:    ld.param.f32 %f1, [test_nvvm_sqrt_param_0];
; CHECK-NEXT:    sqrt.rn.f32 %f2, %f1;
; CHECK-NEXT:    st.param.f32 [func_retval0], %f2;
; CHECK-NEXT:    ret;
  %val = call float @llvm.nvvm.sqrt.f(float %a)
  ret float %val
}

define float @test_llvm_sqrt(float %a) {
; CHECK-LABEL: test_llvm_sqrt(
; CHECK:       {
; CHECK-NEXT:    .reg .b32 %f<3>;
; CHECK-EMPTY:
; CHECK-NEXT:  // %bb.0:
; CHECK-NEXT:    ld.param.f32 %f1, [test_llvm_sqrt_param_0];
; CHECK-NEXT:    sqrt.rn.f32 %f2, %f1;
; CHECK-NEXT:    st.param.f32 [func_retval0], %f2;
; CHECK-NEXT:    ret;
  %val = call float @llvm.sqrt.f32(float %a)
  ret float %val
}

define i32 @test_bitreverse32(i32 %a) {
; CHECK-LABEL: test_bitreverse32(
; CHECK:       {
; CHECK-NEXT:    .reg .b32 %r<3>;
; CHECK-EMPTY:
; CHECK-NEXT:  // %bb.0:
; CHECK-NEXT:    ld.param.u32 %r1, [test_bitreverse32_param_0];
; CHECK-NEXT:    brev.b32 %r2, %r1;
; CHECK-NEXT:    st.param.b32 [func_retval0], %r2;
; CHECK-NEXT:    ret;
  %val = call i32 @llvm.bitreverse.i32(i32 %a)
  ret i32 %val
}

define i64 @test_bitreverse64(i64 %a) {
; CHECK-LABEL: test_bitreverse64(
; CHECK:       {
; CHECK-NEXT:    .reg .b64 %rd<3>;
; CHECK-EMPTY:
; CHECK-NEXT:  // %bb.0:
; CHECK-NEXT:    ld.param.u64 %rd1, [test_bitreverse64_param_0];
; CHECK-NEXT:    brev.b64 %rd2, %rd1;
; CHECK-NEXT:    st.param.b64 [func_retval0], %rd2;
; CHECK-NEXT:    ret;
  %val = call i64 @llvm.bitreverse.i64(i64 %a)
  ret i64 %val
}

define i32 @test_popc32(i32 %a) {
; CHECK-LABEL: test_popc32(
; CHECK:       {
; CHECK-NEXT:    .reg .b32 %r<3>;
; CHECK-EMPTY:
; CHECK-NEXT:  // %bb.0:
; CHECK-NEXT:    ld.param.u32 %r1, [test_popc32_param_0];
; CHECK-NEXT:    popc.b32 %r2, %r1;
; CHECK-NEXT:    st.param.b32 [func_retval0], %r2;
; CHECK-NEXT:    ret;
  %val = call i32 @llvm.ctpop.i32(i32 %a)
  ret i32 %val
}

define i64 @test_popc64(i64 %a) {
; CHECK-LABEL: test_popc64(
; CHECK:       {
; CHECK-NEXT:    .reg .b32 %r<2>;
; CHECK-NEXT:    .reg .b64 %rd<3>;
; CHECK-EMPTY:
; CHECK-NEXT:  // %bb.0:
; CHECK-NEXT:    ld.param.u64 %rd1, [test_popc64_param_0];
; CHECK-NEXT:    popc.b64 %r1, %rd1;
; CHECK-NEXT:    cvt.u64.u32 %rd2, %r1;
; CHECK-NEXT:    st.param.b64 [func_retval0], %rd2;
; CHECK-NEXT:    ret;
  %val = call i64 @llvm.ctpop.i64(i64 %a)
  ret i64 %val
}

; NVPTX popc.b64 returns an i32 even though @llvm.ctpop.i64 returns an i64, so
; if this function returns an i32, there's no need to do any type conversions
; in the ptx.
define i32 @test_popc64_trunc(i64 %a) {
; CHECK-LABEL: test_popc64_trunc(
; CHECK:       {
; CHECK-NEXT:    .reg .b32 %r<2>;
; CHECK-NEXT:    .reg .b64 %rd<2>;
; CHECK-EMPTY:
; CHECK-NEXT:  // %bb.0:
; CHECK-NEXT:    ld.param.u64 %rd1, [test_popc64_trunc_param_0];
; CHECK-NEXT:    popc.b64 %r1, %rd1;
; CHECK-NEXT:    st.param.b32 [func_retval0], %r1;
; CHECK-NEXT:    ret;
  %val = call i64 @llvm.ctpop.i64(i64 %a)
  %trunc = trunc i64 %val to i32
  ret i32 %trunc
}

; llvm.ctpop.i16 is implemenented by converting to i32, running popc.b32, and
; then converting back to i16.
define void @test_popc16(i16 %a, ptr %b) {
; CHECK32-LABEL: test_popc16(
; CHECK32:       {
; CHECK32-NEXT:    .reg .b32 %r<4>;
; CHECK32-EMPTY:
; CHECK32-NEXT:  // %bb.0:
; CHECK32-NEXT:    ld.param.u16 %r1, [test_popc16_param_0];
; CHECK32-NEXT:    popc.b32 %r2, %r1;
; CHECK32-NEXT:    ld.param.u32 %r3, [test_popc16_param_1];
; CHECK32-NEXT:    st.u16 [%r3], %r2;
; CHECK32-NEXT:    ret;
;
; CHECK64-LABEL: test_popc16(
; CHECK64:       {
; CHECK64-NEXT:    .reg .b32 %r<3>;
; CHECK64-NEXT:    .reg .b64 %rd<2>;
; CHECK64-EMPTY:
; CHECK64-NEXT:  // %bb.0:
; CHECK64-NEXT:    ld.param.u16 %r1, [test_popc16_param_0];
; CHECK64-NEXT:    popc.b32 %r2, %r1;
; CHECK64-NEXT:    ld.param.u64 %rd1, [test_popc16_param_1];
; CHECK64-NEXT:    st.u16 [%rd1], %r2;
; CHECK64-NEXT:    ret;
  %val = call i16 @llvm.ctpop.i16(i16 %a)
  store i16 %val, ptr %b
  ret void
}

; If we call llvm.ctpop.i16 and then zext the result to i32, we shouldn't need
; to do any conversions after calling popc.b32, because that returns an i32.
define i32 @test_popc16_to_32(i16 %a) {
; CHECK-LABEL: test_popc16_to_32(
; CHECK:       {
; CHECK-NEXT:    .reg .b32 %r<3>;
; CHECK-EMPTY:
; CHECK-NEXT:  // %bb.0:
; CHECK-NEXT:    ld.param.u16 %r1, [test_popc16_to_32_param_0];
; CHECK-NEXT:    popc.b32 %r2, %r1;
; CHECK-NEXT:    st.param.b32 [func_retval0], %r2;
; CHECK-NEXT:    ret;
  %val = call i16 @llvm.ctpop.i16(i16 %a)
  %zext = zext i16 %val to i32
  ret i32 %zext
}

; Most of nvvm.read.ptx.sreg.* intrinsics always return the same value and may
; be CSE'd.
define i32 @test_tid() {
; CHECK-LABEL: test_tid(
; CHECK:       {
; CHECK-NEXT:    .reg .b32 %r<3>;
; CHECK-EMPTY:
; CHECK-NEXT:  // %bb.0:
; CHECK-NEXT:    mov.u32 %r1, %tid.x;
; CHECK-NEXT:    add.s32 %r2, %r1, %r1;
; CHECK-NEXT:    st.param.b32 [func_retval0], %r2;
; CHECK-NEXT:    ret;
  %a = tail call i32 @llvm.nvvm.read.ptx.sreg.tid.x()
  %b = tail call i32 @llvm.nvvm.read.ptx.sreg.tid.x()
  %ret = add i32 %a, %b
  ret i32 %ret
}

; reading clock() or clock64() should not be CSE'd as each read may return
; different value.
define i32 @test_clock() {
; CHECK-LABEL: test_clock(
; CHECK:       {
; CHECK-NEXT:    .reg .b32 %r<4>;
; CHECK-EMPTY:
; CHECK-NEXT:  // %bb.0:
; CHECK-NEXT:    mov.u32 %r1, %clock;
; CHECK-NEXT:    mov.u32 %r2, %clock;
; CHECK-NEXT:    add.s32 %r3, %r1, %r2;
; CHECK-NEXT:    st.param.b32 [func_retval0], %r3;
; CHECK-NEXT:    ret;
  %a = tail call i32 @llvm.nvvm.read.ptx.sreg.clock()
  %b = tail call i32 @llvm.nvvm.read.ptx.sreg.clock()
  %ret = add i32 %a, %b
  ret i32 %ret
}

define i64 @test_clock64() {
; CHECK-LABEL: test_clock64(
; CHECK:       {
; CHECK-NEXT:    .reg .b64 %rd<4>;
; CHECK-EMPTY:
; CHECK-NEXT:  // %bb.0:
; CHECK-NEXT:    mov.u64 %rd1, %clock64;
; CHECK-NEXT:    mov.u64 %rd2, %clock64;
; CHECK-NEXT:    add.s64 %rd3, %rd1, %rd2;
; CHECK-NEXT:    st.param.b64 [func_retval0], %rd3;
; CHECK-NEXT:    ret;
  %a = tail call i64 @llvm.nvvm.read.ptx.sreg.clock64()
  %b = tail call i64 @llvm.nvvm.read.ptx.sreg.clock64()
  %ret = add i64 %a, %b
  ret i64 %ret
}

define void @test_exit() {
; CHECK-LABEL: test_exit(
; CHECK:       {
; CHECK-EMPTY:
; CHECK-EMPTY:
; CHECK-NEXT:  // %bb.0:
; CHECK-NEXT:    exit;
; CHECK-NEXT:    ret;
  call void @llvm.nvvm.exit()
  ret void
}

define i64 @test_globaltimer() {
; CHECK-LABEL: test_globaltimer(
; CHECK:       {
; CHECK-NEXT:    .reg .b64 %rd<4>;
; CHECK-EMPTY:
; CHECK-NEXT:  // %bb.0:
; CHECK-NEXT:    mov.u64 %rd1, %globaltimer;
; CHECK-NEXT:    mov.u64 %rd2, %globaltimer;
; CHECK-NEXT:    add.s64 %rd3, %rd1, %rd2;
; CHECK-NEXT:    st.param.b64 [func_retval0], %rd3;
; CHECK-NEXT:    ret;
  %a = tail call i64 @llvm.nvvm.read.ptx.sreg.globaltimer()
  %b = tail call i64 @llvm.nvvm.read.ptx.sreg.globaltimer()
  %ret = add i64 %a, %b
  ret i64 %ret
}

define i64 @test_cyclecounter() {
; CHECK-LABEL: test_cyclecounter(
; CHECK:       {
; CHECK-NEXT:    .reg .b64 %rd<4>;
; CHECK-EMPTY:
; CHECK-NEXT:  // %bb.0:
; CHECK-NEXT:    mov.u64 %rd1, %clock64;
; CHECK-NEXT:    mov.u64 %rd2, %clock64;
; CHECK-NEXT:    add.s64 %rd3, %rd1, %rd2;
; CHECK-NEXT:    st.param.b64 [func_retval0], %rd3;
; CHECK-NEXT:    ret;
  %a = tail call i64 @llvm.readcyclecounter()
  %b = tail call i64 @llvm.readcyclecounter()
  %ret = add i64 %a, %b
  ret i64 %ret
}

define i64 @test_steadycounter() {
; CHECK-LABEL: test_steadycounter(
; CHECK:       {
; CHECK-NEXT:    .reg .b64 %rd<4>;
; CHECK-EMPTY:
; CHECK-NEXT:  // %bb.0:
; CHECK-NEXT:    mov.u64 %rd1, %globaltimer;
; CHECK-NEXT:    mov.u64 %rd2, %globaltimer;
; CHECK-NEXT:    add.s64 %rd3, %rd1, %rd2;
; CHECK-NEXT:    st.param.b64 [func_retval0], %rd3;
; CHECK-NEXT:    ret;
  %a = tail call i64 @llvm.readsteadycounter()
  %b = tail call i64 @llvm.readsteadycounter()
  %ret = add i64 %a, %b
  ret i64 %ret
}

declare float @llvm.fabs.f32(float)
declare double @llvm.fabs.f64(double)
declare float @llvm.nvvm.sqrt.f(float)
declare float @llvm.sqrt.f32(float)
declare i32 @llvm.bitreverse.i32(i32)
declare i64 @llvm.bitreverse.i64(i64)
declare i16 @llvm.ctpop.i16(i16)
declare i32 @llvm.ctpop.i32(i32)
declare i64 @llvm.ctpop.i64(i64)

declare i32 @llvm.nvvm.read.ptx.sreg.tid.x()
declare i32 @llvm.nvvm.read.ptx.sreg.clock()
declare i64 @llvm.nvvm.read.ptx.sreg.clock64()
declare void @llvm.nvvm.exit()
declare i64 @llvm.nvvm.read.ptx.sreg.globaltimer()
declare i64 @llvm.readcyclecounter()
declare i64 @llvm.readsteadycounter()
