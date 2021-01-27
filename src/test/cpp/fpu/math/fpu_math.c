#include <stdio.h>
#include <stdint.h>
#include <stdint.h>
#include <jni.h>
#include <softfloat.h>

extern void miaou();


//#include <fenv.h>
//#pragma STDC FENV_ACCESS ON
//int applyRounding(int rounding){
//    int ret = fegetround( );
//    switch(rounding){
//    case 0: fesetround(FE_TONEAREST); break;
//    case 1: fesetround(FE_TOWARDZERO); break;
//    case 2: fesetround(FE_DOWNWARD); break;
//    case 3: fesetround(FE_UPWARD); break;
//    }
//    return ret;
//}
//    const int originalRounding = applyRounding(rounding);
//    fesetround(originalRounding);

void applyRounding(int rounding){
    switch(rounding){
    case 0: softfloat_roundingMode = 0; break;
    case 1: softfloat_roundingMode = 1; break;
    case 2: softfloat_roundingMode = 2; break;
    case 3: softfloat_roundingMode = 3; break;
    case 4: softfloat_roundingMode = 4; break;
    }
}

#define API __attribute__((visibility("default")))

//float32_t toF32(float v){
//    float32_t x;
//    x.v = ;
//    return x;
//}

#define toF32(v) (*((float32_t*)&v))
#define fromF32(x) (*((float*)&(x.v)))

JNIEXPORT jfloat API JNICALL Java_vexriscv_ip_fpu_FpuMath_addF32(JNIEnv * env, jobject obj, jfloat a, jfloat b, jint rounding){
    applyRounding(rounding);
    float32_t v = f32_add(toF32(a), toF32(b));
    return fromF32(v);
}