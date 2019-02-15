#include <stdio.h>
#include <stdlib.h>
#include <arm_neon.h>
#include <unistd.h>
#include <sys/time.h>
#include <locale.h>

#define UNROLL 5
#define EXE_TIME_IN_USEC(tvs,tve) ((tve.tv_sec - tvs.tv_sec) * 1e6 + (tve.tv_usec - tvs.tv_usec))
#define PRINT()                                           \
do{                                                       \
	printf("\t min:%fusec\n", exe_times[0]);              \
	printf("\t med:%fusec\n", exe_times[num_trials / 2]); \
	printf("\tmean:%fusec\n", mean / num_trials);         \
	printf("\t max:%fusec\n", exe_times[num_trials - 1]); \
}while(0)

int compare_dbl(const void* a_,const void* b_){
	const double *a = (const double *)a_;
	const double *b = (const double *)b_;
	if(*a > *b) return  1;
	if(*a < *b) return -1;
	else return 0;
}

static inline float32x4_t div0(float32x4_t a, float32x4_t b){
	return vmulq_f32(a, vrecpeq_f32(b));
}
static inline float32x4_t div2(float32x4_t a, float32x4_t b){
	float32x4_t c = vrecpeq_f32(b);
	float32x4_t d = vrecpsq_f32(b, c);
	float32x4_t e = vmulq_f32(d, c);
	return vmulq_f32(a, e);
}
static inline float32x4_t div3(float32x4_t a, float32x4_t b){
	float32x4_t initE = vrecpeq_f32(b);
	float32x4_t coef = vdupq_n_f32(3.f);
	float32x4_t A = vmulq_f32(initE,b);
	return vmulq_f32( vmulq_f32(a, initE), vaddq_f32(coef, vmulq_f32(A,vsubq_f32(A,coef))));
}
static inline float32x4_t div3_opt(float32x4_t a, float32x4_t b){
	float32x4_t initE = vrecpeq_f32(b);
	float32x4_t coef = vdupq_n_f32(3.f);
	float32x4_t A = vmulq_f32(initE,b);
	return vmulq_f32( vmulq_f32(a, initE), vfmaq_f32(coef, A,vsubq_f32(A,coef)));
}
static inline float32x4_t div4(float32x4_t a, float32x4_t b){
	float32x4_t c;
	c = vrecpeq_f32(b);
	c = vmulq_f32(vrecpsq_f32(b, c), c);
	c = vmulq_f32(vrecpsq_f32(b, c), c);
	return vmulq_f32(a, c);
}
static inline float32x4_t div8(float32x4_t a, float32x4_t b){
	float32x4_t c;
	c = vrecpeq_f32(b);
	c = vmulq_f32(vrecpsq_f32(b, c), c);
	c = vmulq_f32(vrecpsq_f32(b, c), c);
	c = vmulq_f32(vrecpsq_f32(b, c), c);
	return vmulq_f32(a, c);
}

int main(int argc,char *argv[]){
	//floatx4_t vx, vy, vz;
	const int vector_length = 4;
	float32x4_t vx1, vx2, vx3, vx4, vx5, vx6, vx7, vx8;
	float32_t x1[4], x2[4], x3[4], x4[4], x5[4], x6[4], x7[4], x8[4];
	float32_t init[4] = {1.f, 2.f, 3.f, 4.f};
	float32_t add11[4] = {  1.f,  2.f,  3.f,  4.f };
	float32_t add12[4] = {  5.f,  6.f,  7.f,  8.f };
	float32_t add13[4] = {  9.f, 10.f, 11.f, 12.f };
	float32_t add14[4] = { 13.f, 14.f, 15.f, 16.f };
	float32_t add15[4] = { 17.f, 18.f, 19.f, 20.f };
	float32_t add16[4] = { 21.f, 22.f, 23.f, 24.f };
	float32_t add17[4] = { 25.f, 26.f, 27.f, 28.f };
	float32_t add18[4] = { 29.f, 30.f, 31.f, 32.f };
	float32_t add21[4] = { -1.f, -2.f, -3.f, -4.f };
	float32_t add22[4] = { -5.f, -6.f, -7.f, -8.f };
	float32_t add23[4] = { -9.f,-10.f,-11.f,-12.f };
	float32_t add24[4] = {-13.f,-14.f,-15.f,-16.f };
	float32_t add25[4] = {-17.f,-18.f,-19.f,-20.f };
	float32_t add26[4] = {-21.f,-22.f,-23.f,-24.f };
	float32_t add27[4] = {-25.f,-26.f,-27.f,-28.f };
	float32_t add28[4] = {-29.f,-30.f,-31.f,-32.f };
	float32x4_t vadd11, vadd12, vadd13, vadd14, vadd15, vadd16, vadd17, vadd18;
	float32x4_t vadd21, vadd22, vadd23, vadd24, vadd25, vadd26, vadd27, vadd28;
	float32_t mul11[4] = {       2.f,        3.f,        4.f,        5.f};
	float32_t mul12[4] = {       6.f,        7.f,        8.f,        9.f};
	float32_t mul13[4] = {      10.f,       11.f,       12.f,       13.f};
	float32_t mul14[4] = {      14.f,       15.f,       16.f,       17.f};
	float32_t mul15[4] = {      18.f,       19.f,       20.f,       21.f};
	float32_t mul16[4] = {      22.f,       23.f,       24.f,       25.f};
	float32_t mul17[4] = {      26.f,       27.f,       28.f,       29.f};
	float32_t mul18[4] = {      30.f,       31.f,       32.f,       33.f};
	float32_t mul21[4] = {1.f /  2.f, 1.f /  3.f, 1.f /  4.f, 1.f /  5.f};
	float32_t mul22[4] = {1.f /  6.f, 1.f /  7.f, 1.f /  8.f, 1.f /  9.f};
	float32_t mul23[4] = {1.f / 10.f, 1.f / 11.f, 1.f / 12.f, 1.f / 13.f};
	float32_t mul24[4] = {1.f / 14.f, 1.f / 15.f, 1.f / 16.f, 1.f / 17.f};
	float32_t mul25[4] = {1.f / 18.f, 1.f / 19.f, 1.f / 20.f, 1.f / 21.f};
	float32_t mul26[4] = {1.f / 22.f, 1.f / 23.f, 1.f / 24.f, 1.f / 25.f};
	float32_t mul27[4] = {1.f / 26.f, 1.f / 27.f, 1.f / 28.f, 1.f / 29.f};
	float32_t mul28[4] = {1.f / 30.f, 1.f / 31.f, 1.f / 32.f, 1.f / 33.f};
	float32x4_t vmul11, vmul12, vmul13, vmul14, vmul15, vmul16, vmul17, vmul18;
	float32x4_t vmul21, vmul22, vmul23, vmul24, vmul25, vmul26, vmul27, vmul28;
	float32x4_t vone;
	struct timeval tvs,tve;
	double *exe_times;
	double mean;
	int num_iteration = 100800;
	int num_trials = 1000;
	int opt;
	int je;
	while((opt = getopt(argc,argv, "i:t:")) != -1){
		switch(opt){
		case 'i':
			num_iteration = atoi(optarg);
			break;
		case 't':
			num_trials = atoi(optarg);
			break;
		}
	}
	
	setlocale(LC_NUMERIC, "");
        printf("iteration:%'d\n", num_iteration);
	printf("trial:%'d\n", num_trials);

	exe_times = malloc(sizeof(double) * num_trials);
	vadd11 = vld1q_f32(add11); vadd21 = vld1q_f32(add21);
	vadd12 = vld1q_f32(add12); vadd22 = vld1q_f32(add22);
	vadd13 = vld1q_f32(add13); vadd23 = vld1q_f32(add23);
	vadd14 = vld1q_f32(add14); vadd24 = vld1q_f32(add24);
	vadd15 = vld1q_f32(add15); vadd25 = vld1q_f32(add25);
	vadd16 = vld1q_f32(add16); vadd26 = vld1q_f32(add26);
	vadd17 = vld1q_f32(add17); vadd27 = vld1q_f32(add27);
	vadd18 = vld1q_f32(add18); vadd28 = vld1q_f32(add28);
	vmul11 = vld1q_f32(mul11); vmul21 = vld1q_f32(mul21);
	vmul12 = vld1q_f32(mul12); vmul22 = vld1q_f32(mul22);
	vmul13 = vld1q_f32(mul13); vmul23 = vld1q_f32(mul23);
	vmul14 = vld1q_f32(mul14); vmul24 = vld1q_f32(mul24);
	vmul15 = vld1q_f32(mul15); vmul25 = vld1q_f32(mul25);
	vmul16 = vld1q_f32(mul16); vmul26 = vld1q_f32(mul26);
	vmul17 = vld1q_f32(mul17); vmul27 = vld1q_f32(mul27);
	vmul18 = vld1q_f32(mul18); vmul28 = vld1q_f32(mul28);

	je = (num_iteration + 1) / 2;
	
	// add
	vx1 = vld1q_f32(init);
	mean = 0.0;
	for(int i=0 ; i<num_trials ; ++i){
		gettimeofday(&tvs, NULL);
		asm volatile("# start add");
		for(int j=0 ; j<je ; ++j){
			vx1 = vaddq_f32(vx1, vadd11);
			vx1 = vaddq_f32(vx1, vadd21);
		}
		asm volatile("# end add");
		gettimeofday(&tve, NULL);
		exe_times[i] = EXE_TIME_IN_USEC(tvs, tve);
		mean += EXE_TIME_IN_USEC(tvs, tve);
	}
	qsort(exe_times, num_trials, sizeof(double), compare_dbl);
	printf("add\n");
	PRINT();
	vst1q_f32(x1, vx1);
	fprintf(stderr, "\tvx1:{%f, %f, %f, %f}\n", x1[0], x1[1], x1[2], x1[3]);

	// div3
	vx1 = vld1q_f32(mul11);
	vone = vdupq_n_f32(1.f);
	mean = 0.0;
	for(int i=0 ; i<num_trials ; ++i){
		gettimeofday(&tvs, NULL);
		asm volatile("# start div3");
		for(int j=0 ; j<je ; ++j){
			vx1 = div3(vone, vx1);
			vx1 = div3(vone, vx1);
		}
		asm volatile("# end div3");
		gettimeofday(&tve, NULL);
		exe_times[i] = EXE_TIME_IN_USEC(tvs, tve);
		mean += EXE_TIME_IN_USEC(tvs, tve);
	}
	qsort(exe_times, num_trials, sizeof(double), compare_dbl);
	printf("div3\n");
	PRINT();
	vst1q_f32(x1, vx1);
	fprintf(stderr, "\tvx1:{%f, %f, %f, %f}\n", x1[0], x1[1], x1[2], x1[3]);

	// div3_opt
	vx1 = vld1q_f32(mul11);
	vone = vdupq_n_f32(1.f);
	mean = 0.0;
	for(int i=0 ; i<num_trials ; ++i){
		gettimeofday(&tvs, NULL);
		asm volatile("# start div3_opt");
		for(int j=0 ; j<je ; ++j){
			vx1 = div3_opt(vone, vx1);
			vx1 = div3_opt(vone, vx1);
		}
		asm volatile("# end div3_opt");
		gettimeofday(&tve, NULL);
		exe_times[i] = EXE_TIME_IN_USEC(tvs, tve);
		mean += EXE_TIME_IN_USEC(tvs, tve);
	}
	qsort(exe_times, num_trials, sizeof(double), compare_dbl);
	printf("div3_opt\n");
	PRINT();
	vst1q_f32(x1, vx1);
	fprintf(stderr, "\tvx1:{%f, %f, %f, %f}\n", x1[0], x1[1], x1[2], x1[3]);
	
	// for unrolled
	je = (num_iteration + 2 * UNROLL - 1) / ( 2 * UNROLL);

	// add
	vx1 = vld1q_f32(init); vx2 = vld1q_f32(init); vx3 = vld1q_f32(init); vx4 = vld1q_f32(init);
	vx5 = vld1q_f32(init); vx6 = vld1q_f32(init); vx7 = vld1q_f32(init); vx8 = vld1q_f32(init);
	mean = 0.0;
	for(int i=0 ; i<num_trials ; ++i){
		gettimeofday(&tvs, NULL);
		asm volatile("# start add");
		for(int j=0 ; j<je ; ++j){
#if UNROLL > 0
			vx1 = vaddq_f32(vx1, vadd11);
#if UNROLL > 1
			vx2 = vaddq_f32(vx2, vadd12);
#if UNROLL > 2
			vx3 = vaddq_f32(vx3, vadd13);
#if UNROLL > 3
			vx4 = vaddq_f32(vx4, vadd14);
#if UNROLL > 4
			vx5 = vaddq_f32(vx5, vadd15);
#if UNROLL > 5
			vx6 = vaddq_f32(vx6, vadd16);
#if UNROLL > 6
			vx7 = vaddq_f32(vx7, vadd17);
#if UNROLL > 7
			vx8 = vaddq_f32(vx8, vadd18);
#endif
#endif
#endif
#endif
#endif
#endif
#endif
#endif
#if UNROLL > 0
			vx1 = vaddq_f32(vx1, vadd21);
#if UNROLL > 1
			vx2 = vaddq_f32(vx2, vadd22);
#if UNROLL > 2
			vx3 = vaddq_f32(vx3, vadd23);
#if UNROLL > 3
			vx4 = vaddq_f32(vx4, vadd24);
#if UNROLL > 4
			vx5 = vaddq_f32(vx5, vadd25);
#if UNROLL > 5
			vx6 = vaddq_f32(vx6, vadd26);
#if UNROLL > 6
			vx7 = vaddq_f32(vx7, vadd27);
#if UNROLL > 7
			vx8 = vaddq_f32(vx8, vadd28);
#endif
#endif
#endif
#endif
#endif
#endif
#endif
#endif
		}
		asm volatile("# end add");
		gettimeofday(&tve, NULL);
		exe_times[i] = EXE_TIME_IN_USEC(tvs, tve);
		mean += EXE_TIME_IN_USEC(tvs, tve);
	}
	qsort(exe_times, num_trials, sizeof(double), compare_dbl);
	printf("unrolled add\n");
	PRINT();
	vst1q_f32(x1, vx1); vst1q_f32(x2, vx2); vst1q_f32(x3, vx3); vst1q_f32(x4, vx4);
	vst1q_f32(x5, vx5); vst1q_f32(x6, vx6); vst1q_f32(x7, vx7); vst1q_f32(x8, vx8);
#if UNROLL > 0
	fprintf(stderr, "\tvx1:{%f, %f, %f, %f}\n", x1[0], x1[1], x1[2], x1[3]);
#if UNROLL > 1
	fprintf(stderr, "\tvx2:{%f, %f, %f, %f}\n", x2[0], x2[1], x2[2], x2[3]);
#if UNROLL > 2
	fprintf(stderr, "\tvx3:{%f, %f, %f, %f}\n", x3[0], x3[1], x3[2], x3[3]);
#if UNROLL > 3
	fprintf(stderr, "\tvx4:{%f, %f, %f, %f}\n", x4[0], x4[1], x4[2], x4[3]);
#if UNROLL > 4
	fprintf(stderr, "\tvx5:{%f, %f, %f, %f}\n", x5[0], x5[1], x5[2], x5[3]);
#if UNROLL > 5
	fprintf(stderr, "\tvx6:{%f, %f, %f, %f}\n", x6[0], x6[1], x6[2], x6[3]);
#if UNROLL > 6
	fprintf(stderr, "\tvx7:{%f, %f, %f, %f}\n", x7[0], x7[1], x7[2], x7[3]);
#if UNROLL > 7
	fprintf(stderr, "\tvx8:{%f, %f, %f, %f}\n", x8[0], x8[1], x8[2], x8[3]);
#endif
#endif
#endif
#endif
#endif
#endif
#endif
#endif

	// mul
	vx1 = vld1q_f32(init); vx2 = vld1q_f32(init); vx3 = vld1q_f32(init); vx4 = vld1q_f32(init);
	vx5 = vld1q_f32(init); vx6 = vld1q_f32(init); vx7 = vld1q_f32(init); vx8 = vld1q_f32(init);
	mean = 0.0;
	for(int i=0 ; i<num_trials ; ++i){
		gettimeofday(&tvs, NULL);
		asm volatile("# start mul");
		for(int j=0 ; j<je ; ++j){
#if UNROLL > 0
			vx1 = vmulq_f32(vx1, vmul11);
#if UNROLL > 1
			vx2 = vmulq_f32(vx2, vmul12);
#if UNROLL > 2
			vx3 = vmulq_f32(vx3, vmul13);
#if UNROLL > 3
			vx4 = vmulq_f32(vx4, vmul14);
#if UNROLL > 4
			vx5 = vmulq_f32(vx5, vmul15);
#if UNROLL > 5
			vx6 = vmulq_f32(vx6, vmul16);
#if UNROLL > 6
			vx7 = vmulq_f32(vx7, vmul17);
#if UNROLL > 7
			vx8 = vmulq_f32(vx8, vmul18);
#endif
#endif
#endif
#endif
#endif
#endif
#endif
#endif
#if UNROLL > 0
			vx1 = vmulq_f32(vx1, vmul21);
#if UNROLL > 1
			vx2 = vmulq_f32(vx2, vmul22);
#if UNROLL > 2
			vx3 = vmulq_f32(vx3, vmul23);
#if UNROLL > 3
			vx4 = vmulq_f32(vx4, vmul24);
#if UNROLL > 4
			vx5 = vmulq_f32(vx5, vmul25);
#if UNROLL > 5
			vx6 = vmulq_f32(vx6, vmul26);
#if UNROLL > 6
			vx7 = vmulq_f32(vx7, vmul27);
#if UNROLL > 7
			vx8 = vmulq_f32(vx8, vmul28);
#endif
#endif
#endif
#endif
#endif
#endif
#endif
#endif
		}
		asm volatile("# end mul");
		gettimeofday(&tve, NULL);
		exe_times[i] = EXE_TIME_IN_USEC(tvs, tve);
		mean += EXE_TIME_IN_USEC(tvs, tve);
	}
	qsort(exe_times, num_trials, sizeof(double), compare_dbl);
	printf("unrolled mul\n");
	PRINT();
	vst1q_f32(x1, vx1); vst1q_f32(x2, vx2); vst1q_f32(x3, vx3); vst1q_f32(x4, vx4);
	vst1q_f32(x5, vx5); vst1q_f32(x6, vx6); vst1q_f32(x7, vx7); vst1q_f32(x8, vx8);
#if UNROLL > 0
	fprintf(stderr, "\tvx1:{%f, %f, %f, %f}\n", x1[0], x1[1], x1[2], x1[3]);
#if UNROLL > 1
	fprintf(stderr, "\tvx2:{%f, %f, %f, %f}\n", x2[0], x2[1], x2[2], x2[3]);
#if UNROLL > 2
	fprintf(stderr, "\tvx3:{%f, %f, %f, %f}\n", x3[0], x3[1], x3[2], x3[3]);
#if UNROLL > 3
	fprintf(stderr, "\tvx4:{%f, %f, %f, %f}\n", x4[0], x4[1], x4[2], x4[3]);
#if UNROLL > 4
	fprintf(stderr, "\tvx5:{%f, %f, %f, %f}\n", x5[0], x5[1], x5[2], x5[3]);
#if UNROLL > 5
	fprintf(stderr, "\tvx6:{%f, %f, %f, %f}\n", x6[0], x6[1], x6[2], x6[3]);
#if UNROLL > 6
	fprintf(stderr, "\tvx7:{%f, %f, %f, %f}\n", x7[0], x7[1], x7[2], x7[3]);
#if UNROLL > 7
	fprintf(stderr, "\tvx8:{%f, %f, %f, %f}\n", x8[0], x8[1], x8[2], x8[3]);
#endif
#endif
#endif
#endif
#endif
#endif
#endif
#endif

	// div0
	vx1 = vld1q_f32(mul11); vx2 = vld1q_f32(mul12); vx3 = vld1q_f32(mul13); vx4 = vld1q_f32(mul14);
	vx5 = vld1q_f32(mul15); vx6 = vld1q_f32(mul16); vx7 = vld1q_f32(mul17); vx8 = vld1q_f32(mul18);
	vone = vdupq_n_f32(1.f);
	mean = 0.0;
	for(int i=0 ; i<num_trials ; ++i){
		gettimeofday(&tvs, NULL);
		asm volatile("# start div0");
		for(int j=0 ; j<je ; ++j){
#if UNROLL > 0
			vx1 = div0(vone, vx1);
#if UNROLL > 1
			vx2 = div0(vone, vx2);
#if UNROLL > 2
			vx3 = div0(vone, vx3);
#if UNROLL > 3
			vx4 = div0(vone, vx4);
#if UNROLL > 4
			vx5 = div0(vone, vx5);
#if UNROLL > 5
			vx6 = div0(vone, vx6);
#if UNROLL > 6
			vx7 = div0(vone, vx7);
#if UNROLL > 8
			vx8 = div0(vone, vx8);
#endif
#endif
#endif
#endif
#endif
#endif
#endif
#endif
#if UNROLL > 0
			vx1 = div0(vone, vx1);
#if UNROLL > 1
			vx2 = div0(vone, vx2);
#if UNROLL > 2
			vx3 = div0(vone, vx3);
#if UNROLL > 3
			vx4 = div0(vone, vx4);
#if UNROLL > 4
			vx5 = div0(vone, vx5);
#if UNROLL > 5
			vx6 = div0(vone, vx6);
#if UNROLL > 6
			vx7 = div0(vone, vx7);
#if UNROLL > 8
			vx8 = div0(vone, vx8);
#endif
#endif
#endif
#endif
#endif
#endif
#endif
#endif
		}
		asm volatile("# end div0");
		gettimeofday(&tve, NULL);
		exe_times[i] = EXE_TIME_IN_USEC(tvs, tve);
		mean += EXE_TIME_IN_USEC(tvs, tve);
	}
	qsort(exe_times, num_trials, sizeof(double), compare_dbl);
	printf("unrolled div0\n");
	PRINT();
	vst1q_f32(x1, vx1); vst1q_f32(x2, vx2); vst1q_f32(x3, vx3); vst1q_f32(x4, vx4);
	vst1q_f32(x5, vx5); vst1q_f32(x6, vx6); vst1q_f32(x7, vx7); vst1q_f32(x8, vx8);
#if UNROLL > 0
	fprintf(stderr, "\tvx1:{%f, %f, %f, %f}\n", x1[0], x1[1], x1[2], x1[3]);
#if UNROLL > 1
	fprintf(stderr, "\tvx2:{%f, %f, %f, %f}\n", x2[0], x2[1], x2[2], x2[3]);
#if UNROLL > 2
	fprintf(stderr, "\tvx3:{%f, %f, %f, %f}\n", x3[0], x3[1], x3[2], x3[3]);
#if UNROLL > 3
	fprintf(stderr, "\tvx4:{%f, %f, %f, %f}\n", x4[0], x4[1], x4[2], x4[3]);
#if UNROLL > 4
	fprintf(stderr, "\tvx5:{%f, %f, %f, %f}\n", x5[0], x5[1], x5[2], x5[3]);
#if UNROLL > 5
	fprintf(stderr, "\tvx6:{%f, %f, %f, %f}\n", x6[0], x6[1], x6[2], x6[3]);
#if UNROLL > 6
	fprintf(stderr, "\tvx7:{%f, %f, %f, %f}\n", x7[0], x7[1], x7[2], x7[3]);
#if UNROLL > 7
	fprintf(stderr, "\tvx8:{%f, %f, %f, %f}\n", x8[0], x8[1], x8[2], x8[3]);
#endif
#endif
#endif
#endif
#endif
#endif
#endif
#endif

	// div2
	vx1 = vld1q_f32(mul11); vx2 = vld1q_f32(mul12); vx3 = vld1q_f32(mul13); vx4 = vld1q_f32(mul14);
	vx5 = vld1q_f32(mul15); vx6 = vld1q_f32(mul16); vx7 = vld1q_f32(mul17); vx8 = vld1q_f32(mul18);
	vone = vdupq_n_f32(1.f);
	mean = 0.0;
	for(int i=0 ; i<num_trials ; ++i){
		gettimeofday(&tvs, NULL);
		asm volatile("# start unroll div2");
		for(int j=0 ; j<je ; ++j){
#if UNROLL > 0
			vx1 = div2(vone, vx1);
#if UNROLL > 1
			vx2 = div2(vone, vx2);
#if UNROLL > 2
			vx3 = div2(vone, vx3);
#if UNROLL > 3
			vx4 = div2(vone, vx4);
#if UNROLL > 4
			vx5 = div2(vone, vx5);
#if UNROLL > 5
			vx6 = div2(vone, vx6);
#if UNROLL > 6
			vx7 = div2(vone, vx7);
#if UNROLL > 7
			vx8 = div2(vone, vx8);
#endif
#endif
#endif
#endif
#endif
#endif
#endif
#endif
#if UNROLL > 0
			vx1 = div2(vone, vx1);
#if UNROLL > 1
			vx2 = div2(vone, vx2);
#if UNROLL > 2
			vx3 = div2(vone, vx3);
#if UNROLL > 3
			vx4 = div2(vone, vx4);
#if UNROLL > 4
			vx5 = div2(vone, vx5);
#if UNROLL > 5
			vx6 = div2(vone, vx6);
#if UNROLL > 6
			vx7 = div2(vone, vx7);
#if UNROLL > 7
			vx8 = div2(vone, vx8);
#endif
#endif
#endif
#endif
#endif
#endif
#endif
#endif
		}
		asm volatile("# end unroll div2");
		gettimeofday(&tve, NULL);
		exe_times[i] = EXE_TIME_IN_USEC(tvs, tve);
		mean += EXE_TIME_IN_USEC(tvs, tve);
	}
	qsort(exe_times, num_trials, sizeof(double), compare_dbl);
	printf("unrolled div2\n");
	PRINT();
	vst1q_f32(x1, vx1); vst1q_f32(x2, vx2); vst1q_f32(x3, vx3); vst1q_f32(x4, vx4);
	vst1q_f32(x5, vx5); vst1q_f32(x6, vx6); vst1q_f32(x7, vx7); vst1q_f32(x8, vx8);
#if UNROLL > 0
	fprintf(stderr, "\tvx1:{%f, %f, %f, %f}\n", x1[0], x1[1], x1[2], x1[3]);
#if UNROLL > 1
	fprintf(stderr, "\tvx2:{%f, %f, %f, %f}\n", x2[0], x2[1], x2[2], x2[3]);
#if UNROLL > 2
	fprintf(stderr, "\tvx3:{%f, %f, %f, %f}\n", x3[0], x3[1], x3[2], x3[3]);
#if UNROLL > 3
	fprintf(stderr, "\tvx4:{%f, %f, %f, %f}\n", x4[0], x4[1], x4[2], x4[3]);
#if UNROLL > 4
	fprintf(stderr, "\tvx5:{%f, %f, %f, %f}\n", x5[0], x5[1], x5[2], x5[3]);
#if UNROLL > 5
	fprintf(stderr, "\tvx6:{%f, %f, %f, %f}\n", x6[0], x6[1], x6[2], x6[3]);
#if UNROLL > 6
	fprintf(stderr, "\tvx7:{%f, %f, %f, %f}\n", x7[0], x7[1], x7[2], x7[3]);
#if UNROLL > 7
	fprintf(stderr, "\tvx8:{%f, %f, %f, %f}\n", x8[0], x8[1], x8[2], x8[3]);
#endif
#endif
#endif
#endif
#endif
#endif
#endif
#endif

	// div3
	vx1 = vld1q_f32(mul11); vx2 = vld1q_f32(mul12); vx3 = vld1q_f32(mul13); vx4 = vld1q_f32(mul14);
	vx5 = vld1q_f32(mul15); vx6 = vld1q_f32(mul16); vx7 = vld1q_f32(mul17); vx8 = vld1q_f32(mul18);
	vone = vdupq_n_f32(1.f);
	mean = 0.0;
	for(int i=0 ; i<num_trials ; ++i){
		gettimeofday(&tvs, NULL);
		asm volatile("# start unroll div3");
		for(int j=0 ; j<je ; ++j){
#if UNROLL > 0
			vx1 = div3(vone, vx1);
#if UNROLL > 1
			vx2 = div3(vone, vx2);
#if UNROLL > 2
			vx3 = div3(vone, vx3);
#if UNROLL > 3
			vx4 = div3(vone, vx4);
#if UNROLL > 4
			vx5 = div3(vone, vx5);
#if UNROLL > 5
			vx6 = div3(vone, vx6);
#if UNROLL > 6
			vx7 = div3(vone, vx7);
#if UNROLL > 7
			vx8 = div3(vone, vx8);
#endif
#endif
#endif
#endif
#endif
#endif
#endif
#endif
#if UNROLL > 0
			vx1 = div3(vone, vx1);
#if UNROLL > 1
			vx2 = div3(vone, vx2);
#if UNROLL > 2
			vx3 = div3(vone, vx3);
#if UNROLL > 3
			vx4 = div3(vone, vx4);
#if UNROLL > 4
			vx5 = div3(vone, vx5);
#if UNROLL > 5
			vx6 = div3(vone, vx6);
#if UNROLL > 6
			vx7 = div3(vone, vx7);
#if UNROLL > 7
			vx8 = div3(vone, vx8);
#endif
#endif
#endif
#endif
#endif
#endif
#endif
#endif
		}
		asm volatile("# end unroll div3");
		gettimeofday(&tve, NULL);
		exe_times[i] = EXE_TIME_IN_USEC(tvs, tve);
		mean += EXE_TIME_IN_USEC(tvs, tve);
	}
	qsort(exe_times, num_trials, sizeof(double), compare_dbl);
	printf("unrolled div3\n");
	PRINT();
	vst1q_f32(x1, vx1); vst1q_f32(x2, vx2); vst1q_f32(x3, vx3); vst1q_f32(x4, vx4);
	vst1q_f32(x5, vx5); vst1q_f32(x6, vx6); vst1q_f32(x7, vx7); vst1q_f32(x8, vx8);
#if UNROLL > 0
	fprintf(stderr, "\tvx1:{%f, %f, %f, %f}\n", x1[0], x1[1], x1[2], x1[3]);
#if UNROLL > 1
	fprintf(stderr, "\tvx2:{%f, %f, %f, %f}\n", x2[0], x2[1], x2[2], x2[3]);
#if UNROLL > 2
	fprintf(stderr, "\tvx3:{%f, %f, %f, %f}\n", x3[0], x3[1], x3[2], x3[3]);
#if UNROLL > 3
	fprintf(stderr, "\tvx4:{%f, %f, %f, %f}\n", x4[0], x4[1], x4[2], x4[3]);
#if UNROLL > 4
	fprintf(stderr, "\tvx5:{%f, %f, %f, %f}\n", x5[0], x5[1], x5[2], x5[3]);
#if UNROLL > 5
	fprintf(stderr, "\tvx6:{%f, %f, %f, %f}\n", x6[0], x6[1], x6[2], x6[3]);
#if UNROLL > 6
	fprintf(stderr, "\tvx7:{%f, %f, %f, %f}\n", x7[0], x7[1], x7[2], x7[3]);
#if UNROLL > 7
	fprintf(stderr, "\tvx8:{%f, %f, %f, %f}\n", x8[0], x8[1], x8[2], x8[3]);
#endif
#endif
#endif
#endif
#endif
#endif
#endif
#endif

	// div3_opt
	vx1 = vld1q_f32(mul11); vx2 = vld1q_f32(mul12); vx3 = vld1q_f32(mul13); vx4 = vld1q_f32(mul14);
	vx5 = vld1q_f32(mul15); vx6 = vld1q_f32(mul16); vx7 = vld1q_f32(mul17); vx8 = vld1q_f32(mul18);
	vone = vdupq_n_f32(1.f);
	mean = 0.0;
	for(int i=0 ; i<num_trials ; ++i){
		gettimeofday(&tvs, NULL);
		asm volatile("# start unroll div3_opt");
		for(int j=0 ; j<je ; ++j){
#if UNROLL > 0
			vx1 = div3_opt(vone, vx1);
#if UNROLL > 1
			vx2 = div3_opt(vone, vx2);
#if UNROLL > 2
			vx3 = div3_opt(vone, vx3);
#if UNROLL > 3
			vx4 = div3_opt(vone, vx4);
#if UNROLL > 4
			vx5 = div3_opt(vone, vx5);
#if UNROLL > 5
			vx6 = div3_opt(vone, vx6);
#if UNROLL > 6
			vx7 = div3_opt(vone, vx7);
#if UNROLL > 7
			vx8 = div3_opt(vone, vx8);
#endif
#endif
#endif
#endif
#endif
#endif
#endif
#endif
#if UNROLL > 0
			vx1 = div3_opt(vone, vx1);
#if UNROLL > 1
			vx2 = div3_opt(vone, vx2);
#if UNROLL > 2
			vx3 = div3_opt(vone, vx3);
#if UNROLL > 3
			vx4 = div3_opt(vone, vx4);
#if UNROLL > 4
			vx5 = div3_opt(vone, vx5);
#if UNROLL > 5
			vx6 = div3_opt(vone, vx6);
#if UNROLL > 6
			vx7 = div3_opt(vone, vx7);
#if UNROLL > 7
			vx8 = div3_opt(vone, vx8);
#endif
#endif
#endif
#endif
#endif
#endif
#endif
#endif
		}
		asm volatile("# end unroll div3_opt");
		gettimeofday(&tve, NULL);
		exe_times[i] = EXE_TIME_IN_USEC(tvs, tve);
		mean += EXE_TIME_IN_USEC(tvs, tve);
	}
	qsort(exe_times, num_trials, sizeof(double), compare_dbl);
	printf("unrolled div3_opt\n");
	PRINT();
	vst1q_f32(x1, vx1); vst1q_f32(x2, vx2); vst1q_f32(x3, vx3); vst1q_f32(x4, vx4);
	vst1q_f32(x5, vx5); vst1q_f32(x6, vx6); vst1q_f32(x7, vx7); vst1q_f32(x8, vx8);
#if UNROLL > 0
	fprintf(stderr, "\tvx1:{%f, %f, %f, %f}\n", x1[0], x1[1], x1[2], x1[3]);
#if UNROLL > 1
	fprintf(stderr, "\tvx2:{%f, %f, %f, %f}\n", x2[0], x2[1], x2[2], x2[3]);
#if UNROLL > 2
	fprintf(stderr, "\tvx3:{%f, %f, %f, %f}\n", x3[0], x3[1], x3[2], x3[3]);
#if UNROLL > 3
	fprintf(stderr, "\tvx4:{%f, %f, %f, %f}\n", x4[0], x4[1], x4[2], x4[3]);
#if UNROLL > 4
	fprintf(stderr, "\tvx5:{%f, %f, %f, %f}\n", x5[0], x5[1], x5[2], x5[3]);
#if UNROLL > 5
	fprintf(stderr, "\tvx6:{%f, %f, %f, %f}\n", x6[0], x6[1], x6[2], x6[3]);
#if UNROLL > 6
	fprintf(stderr, "\tvx7:{%f, %f, %f, %f}\n", x7[0], x7[1], x7[2], x7[3]);
#if UNROLL > 7
	fprintf(stderr, "\tvx8:{%f, %f, %f, %f}\n", x8[0], x8[1], x8[2], x8[3]);
#endif
#endif
#endif
#endif
#endif
#endif
#endif
#endif

	// div4
	vx1 = vld1q_f32(mul11); vx2 = vld1q_f32(mul12); vx3 = vld1q_f32(mul13); vx4 = vld1q_f32(mul14);
	vx5 = vld1q_f32(mul15); vx6 = vld1q_f32(mul16); vx7 = vld1q_f32(mul17); vx8 = vld1q_f32(mul18);
	vone = vdupq_n_f32(1.f);
	mean = 0.0;
	for(int i=0 ; i<num_trials ; ++i){
		gettimeofday(&tvs, NULL);
		asm volatile("# start unroll div4");
		for(int j=0 ; j<je ; ++j){
#if UNROLL > 0
			vx1 = div4(vone, vx1);
#if UNROLL > 1
			vx2 = div4(vone, vx2);
#if UNROLL > 2
			vx3 = div4(vone, vx3);
#if UNROLL > 3
			vx4 = div4(vone, vx4);
#if UNROLL > 4
			vx5 = div4(vone, vx5);
#if UNROLL > 5
			vx6 = div4(vone, vx6);
#if UNROLL > 6
			vx7 = div4(vone, vx7);
#if UNROLL > 7
			vx8 = div4(vone, vx8);
#endif
#endif
#endif
#endif
#endif
#endif
#endif
#endif
#if UNROLL > 0
			vx1 = div4(vone, vx1);
#if UNROLL > 1
			vx2 = div4(vone, vx2);
#if UNROLL > 2
			vx3 = div4(vone, vx3);
#if UNROLL > 3
			vx4 = div4(vone, vx4);
#if UNROLL > 4
			vx5 = div4(vone, vx5);
#if UNROLL > 5
			vx6 = div4(vone, vx6);
#if UNROLL > 6
			vx7 = div4(vone, vx7);
#if UNROLL > 7
			vx8 = div4(vone, vx8);
#endif
#endif
#endif
#endif
#endif
#endif
#endif
#endif
		}
		asm volatile("# end unroll div4");
		gettimeofday(&tve, NULL);
		exe_times[i] = EXE_TIME_IN_USEC(tvs, tve);
		mean += EXE_TIME_IN_USEC(tvs, tve);
	}
	qsort(exe_times, num_trials, sizeof(double), compare_dbl);
	printf("unroll div4\n");
	PRINT();
	vst1q_f32(x1, vx1); vst1q_f32(x2, vx2); vst1q_f32(x3, vx3); vst1q_f32(x4, vx4);
	vst1q_f32(x5, vx5); vst1q_f32(x6, vx6); vst1q_f32(x7, vx7); vst1q_f32(x8, vx8);
#if UNROLL > 0
	fprintf(stderr, "\tvx1:{%f, %f, %f, %f}\n", x1[0], x1[1], x1[2], x1[3]);
#if UNROLL > 1
	fprintf(stderr, "\tvx2:{%f, %f, %f, %f}\n", x2[0], x2[1], x2[2], x2[3]);
#if UNROLL > 2
	fprintf(stderr, "\tvx3:{%f, %f, %f, %f}\n", x3[0], x3[1], x3[2], x3[3]);
#if UNROLL > 3
	fprintf(stderr, "\tvx4:{%f, %f, %f, %f}\n", x4[0], x4[1], x4[2], x4[3]);
#if UNROLL > 4
	fprintf(stderr, "\tvx5:{%f, %f, %f, %f}\n", x5[0], x5[1], x5[2], x5[3]);
#if UNROLL > 5
	fprintf(stderr, "\tvx6:{%f, %f, %f, %f}\n", x6[0], x6[1], x6[2], x6[3]);
#if UNROLL > 6
	fprintf(stderr, "\tvx7:{%f, %f, %f, %f}\n", x7[0], x7[1], x7[2], x7[3]);
#if UNROLL > 7
	fprintf(stderr, "\tvx8:{%f, %f, %f, %f}\n", x8[0], x8[1], x8[2], x8[3]);
#endif
#endif
#endif
#endif
#endif
#endif
#endif
#endif

	// div8
	vx1 = vld1q_f32(mul11); vx2 = vld1q_f32(mul12); vx3 = vld1q_f32(mul13); vx4 = vld1q_f32(mul14);
	vx5 = vld1q_f32(mul15); vx6 = vld1q_f32(mul16); vx7 = vld1q_f32(mul17); vx8 = vld1q_f32(mul18);
	vone = vdupq_n_f32(1.f);
	mean = 0.0;
	for(int i=0 ; i<num_trials ; ++i){
		gettimeofday(&tvs, NULL);
		asm volatile("# start unroll div8");
		for(int j=0 ; j<je ; ++j){
#if UNROLL > 0
			vx1 = div8(vone, vx1);
#if UNROLL > 1
			vx2 = div8(vone, vx2);
#if UNROLL > 2
			vx3 = div8(vone, vx3);
#if UNROLL > 3
			vx4 = div8(vone, vx4);
#if UNROLL > 4
			vx5 = div8(vone, vx5);
#if UNROLL > 5
			vx6 = div8(vone, vx6);
#if UNROLL > 6
			vx7 = div8(vone, vx7);
#if UNROLL > 7
			vx8 = div8(vone, vx8);
#endif
#endif
#endif
#endif
#endif
#endif
#endif
#endif
#if UNROLL > 0
			vx1 = div8(vone, vx1);
#if UNROLL > 1
			vx2 = div8(vone, vx2);
#if UNROLL > 2
			vx3 = div8(vone, vx3);
#if UNROLL > 3
			vx4 = div8(vone, vx4);
#if UNROLL > 4
			vx5 = div8(vone, vx5);
#if UNROLL > 5
			vx6 = div8(vone, vx6);
#if UNROLL > 6
			vx7 = div8(vone, vx7);
#if UNROLL > 7
			vx8 = div8(vone, vx8);
#endif
#endif
#endif
#endif
#endif
#endif
#endif
#endif
		}
		asm volatile("# end unroll div8");
		gettimeofday(&tve, NULL);
		exe_times[i] = EXE_TIME_IN_USEC(tvs, tve);
		mean += EXE_TIME_IN_USEC(tvs, tve);
	}
	qsort(exe_times, num_trials, sizeof(double), compare_dbl);
	printf("unroll div8\n");
	PRINT();
	vst1q_f32(x1, vx1); vst1q_f32(x2, vx2); vst1q_f32(x3, vx3); vst1q_f32(x4, vx4);
	vst1q_f32(x5, vx5); vst1q_f32(x6, vx6); vst1q_f32(x7, vx7); vst1q_f32(x8, vx8);
#if UNROLL > 0
	fprintf(stderr, "\tvx1:{%f, %f, %f, %f}\n", x1[0], x1[1], x1[2], x1[3]);
#if UNROLL > 1
	fprintf(stderr, "\tvx2:{%f, %f, %f, %f}\n", x2[0], x2[1], x2[2], x2[3]);
#if UNROLL > 2
	fprintf(stderr, "\tvx3:{%f, %f, %f, %f}\n", x3[0], x3[1], x3[2], x3[3]);
#if UNROLL > 3
	fprintf(stderr, "\tvx4:{%f, %f, %f, %f}\n", x4[0], x4[1], x4[2], x4[3]);
#if UNROLL > 4
	fprintf(stderr, "\tvx5:{%f, %f, %f, %f}\n", x5[0], x5[1], x5[2], x5[3]);
#if UNROLL > 5
	fprintf(stderr, "\tvx6:{%f, %f, %f, %f}\n", x6[0], x6[1], x6[2], x6[3]);
#if UNROLL > 6
	fprintf(stderr, "\tvx7:{%f, %f, %f, %f}\n", x7[0], x7[1], x7[2], x7[3]);
#if UNROLL > 7
	fprintf(stderr, "\tvx8:{%f, %f, %f, %f}\n", x8[0], x8[1], x8[2], x8[3]);
#endif
#endif
#endif
#endif
#endif
#endif
#endif
#endif
	
	free(exe_times);
	return 0;
}

