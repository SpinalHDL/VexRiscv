package vexriscv.ip.fpu;

import java.io.File;

public class FpuMath {
    public native float addF32(float a, float b, int rounding);
    public native float mulF32(float a, float b, int rounding);
    public native int mulFlagF32(float a, float b, int rounding);
    public native float d2f(double a, int rounding);
    public native int d2fFlag(double a, int rounding);

    static{
        System.load(new File("src/test/cpp/fpu/math/fpu_math.so").getAbsolutePath());
    }
}