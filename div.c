#include <stdio.h>
#include <stdlib.h>
#include <arm_neon.h>
#include <unistd.h>
#include <sys/time.h>
#include <locale.h>

#define EXE_TIME_IN_USEC(tvs,tve) ((tve.tv_sec - tvs.tv_sec) * 1e6 + (tve.tv_usec - tvs.tv_usec))

union f32_u32 {
	float32_t f;
	uint32_t i;
};

int compare_dbl(const void* a_,const void* b_){
	const double *a = (const double *)a_;
	const double *b = (const double *)b_;
	if(*a > *b) return  1;
	if(*a < *b) return -1;
	else return 0;
}

void print_float_bits(float32_t flt){
	union f32_u32 un;
	un.f = flt;
	uint32_t u = un.i;
	uint32_t i,j = 31;
	//printf("u = %u\n", u);
	for(i = (1u << 31) ; i!=0 ; i >>= 1, --j){
		if(i & u){
			printf("1");
		} else {
			printf("0");
		}
		switch(j){
		case 31:
		case 23:
			printf(" ");
			break;
		case 19:
		case 15:
		case 11:
		case 7:
		case 3:
			printf("'");
			break;
		}
	}
	printf("\n");
}

static inline float32x4_t div0(float32x4_t a, float32x4_t b){
	return vmulq_f32(a, vrecpeq_f32(b));
}
#if 1
static inline float32x4_t div2(float32x4_t a, float32x4_t b){
	float32x4_t c = vrecpeq_f32(b);
	float32x4_t d = vrecpsq_f32(b, c);
	float32x4_t e = vmulq_f32(d, c);
	return vmulq_f32(a, e);
}
#else
static inline float32x4_t div2(float32x4_t a, float32x4_t b){
	float32x4_t c = vrecpeq_f32(b);
	float32x4_t two = {2.f, 2.f, 2.f, 2.f};
	float32x4_t A = vmulq_f32(c,b);
	float32x4_t d = vsubq_f32(two, A);
	float32x4_t e = vmulq_f32(d, c);
	return vmulq_f32(a, e);
}
#endif
static inline float32x4_t div3(float32x4_t a, float32x4_t b){
	float32x4_t initE = vrecpeq_f32(b);
	float32x4_t coef = {3.f, 3.f, 3.f, 3.f};
	float32x4_t A = vmulq_f32(initE,b);
	return vmulq_f32(a, vmulq_f32( vaddq_f32(vmulq_f32(A,vsubq_f32(A,coef)), coef), initE));
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
	float32x4_t vx1, vx2, vx3, vx4, vx5;
	float32_t x1[4], x2[4], x3[4], x4[4], x5[4];
	float32_t init[4] = {1.f, 2.f, 3.f, 4.f};
	float32_t one[4] = {1.f, 1.f, 1.f, 1.f};
	float32_t add11[4] = {  1.f,  2.f,  3.f,  4.f };
	float32_t add21[4] = {  5.f,  6.f,  7.f,  8.f };
	float32_t add31[4] = {  9.f, 10.f, 11.f, 12.f };
	float32_t add41[4] = { 13.f, 14.f, 15.f, 16.f };
	float32_t add51[4] = { 17.f, 18.f, 19.f, 20.f };
	float32_t add12[4] = { -1.f, -2.f, -3.f, -4.f };
	float32_t add22[4] = { -5.f, -6.f, -7.f, -8.f };
	float32_t add32[4] = { -9.f,-10.f,-11.f,-12.f };
	float32_t add42[4] = {-13.f,-14.f,-15.f,-16.f };
	float32_t add52[4] = {-17.f,-18.f,-19.f,-20.f };
	float32x4_t vadd11, vadd21, vadd31, vadd41, vadd51;
	float32x4_t vadd12, vadd22, vadd32, vadd42, vadd52;
	float32_t mul11[4] = {       2.f,        3.f,        4.f,        5.f};
	float32_t mul21[4] = {       6.f,        7.f,        8.f,        9.f};
	float32_t mul31[4] = {      10.f,       11.f,       12.f,       13.f};
	float32_t mul41[4] = {      14.f,       15.f,       16.f,       17.f};
	float32_t mul51[4] = {      18.f,       19.f,       20.f,       21.f};
	float32_t mul12[4] = {1.f /  2.f, 1.f /  3.f, 1.f /  4.f, 1.f /  5.f};
	float32_t mul22[4] = {1.f /  6.f, 1.f /  7.f, 1.f /  8.f, 1.f /  9.f};
	float32_t mul32[4] = {1.f / 10.f, 1.f / 11.f, 1.f / 12.f, 1.f / 13.f};
	float32_t mul42[4] = {1.f / 14.f, 1.f / 15.f, 1.f / 16.f, 1.f / 17.f};
	float32_t mul52[4] = {1.f / 18.f, 1.f / 19.f, 1.f / 20.f, 1.f / 21.f};
	float32x4_t vmul11, vmul21, vmul31, vmul41, vmul51;
	float32x4_t vmul12, vmul22, vmul32, vmul42, vmul52;
	float32x4_t vone;
	struct timeval tvs,tve;
	double *exe_times;
	double mean;
	int num_iteration = 100000;
	int num_trials = 10000;
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
	je = (num_iteration + 9) / 10;
	
	setlocale(LC_NUMERIC, "");
        printf("iteration:%'d\n", num_iteration);
	printf("trial:%'d\n", num_trials);

	exe_times = malloc(sizeof(double) * num_trials);
	vadd11 = vld1q_f32(add11); vadd12 = vld1q_f32(add12);
	vadd21 = vld1q_f32(add21); vadd22 = vld1q_f32(add22);
	vadd31 = vld1q_f32(add31); vadd32 = vld1q_f32(add32);
	vadd41 = vld1q_f32(add41); vadd42 = vld1q_f32(add42);
	vadd51 = vld1q_f32(add51); vadd52 = vld1q_f32(add52);
	vmul11 = vld1q_f32(mul11); vmul12 = vld1q_f32(mul12);
	vmul21 = vld1q_f32(mul21); vmul22 = vld1q_f32(mul22);
	vmul31 = vld1q_f32(mul31); vmul32 = vld1q_f32(mul32);
	vmul41 = vld1q_f32(mul41); vmul42 = vld1q_f32(mul42);
	vmul51 = vld1q_f32(mul51); vmul52 = vld1q_f32(mul52);

	// add
	vx1 = vld1q_f32(init); vx2 = vld1q_f32(init);
	vx3 = vld1q_f32(init); vx4 = vld1q_f32(init); vx5 = vld1q_f32(init);
	mean = 0.0;
	for(int i=0 ; i<num_trials ; ++i){
		gettimeofday(&tvs, NULL);
		asm volatile("# start add");
		for(int j=0 ; j<je ; ++j){
			vx1 = vaddq_f32(vx1, vadd11);
			vx2 = vaddq_f32(vx2, vadd21);
			vx3 = vaddq_f32(vx3, vadd31);
			vx4 = vaddq_f32(vx4, vadd41);
			vx5 = vaddq_f32(vx5, vadd51);
			vx1 = vaddq_f32(vx1, vadd12);
			vx2 = vaddq_f32(vx2, vadd22);
			vx3 = vaddq_f32(vx3, vadd32);
			vx4 = vaddq_f32(vx4, vadd42);
			vx5 = vaddq_f32(vx5, vadd52);
		}
		asm volatile("# end add");
		gettimeofday(&tve, NULL);
		exe_times[i] = EXE_TIME_IN_USEC(tvs, tve);
		mean += EXE_TIME_IN_USEC(tvs, tve);
	}
	qsort(exe_times, num_trials, sizeof(double), compare_dbl);
	printf("add\n");
	printf("\t min:%fusec\n", exe_times[0]);
	printf("\t med:%fusec\n", exe_times[num_trials / 2]);
	printf("\tmean:%fusec\n", mean / num_trials);
	printf("\t max:%fusec\n", exe_times[num_trials - 1]);
	vst1q_f32(x1, vx1);
	vst1q_f32(x2, vx2);
	vst1q_f32(x3, vx3);
	vst1q_f32(x4, vx4);
	vst1q_f32(x5, vx5);
	fprintf(stderr, "\tvx1:{%f, %f, %f, %f}\n", x1[0], x1[1], x1[2], x1[3]);
	fprintf(stderr, "\tvx2:{%f, %f, %f, %f}\n", x2[0], x2[1], x2[2], x2[3]);
	fprintf(stderr, "\tvx3:{%f, %f, %f, %f}\n", x3[0], x3[1], x3[2], x3[3]);
	fprintf(stderr, "\tvx4:{%f, %f, %f, %f}\n", x4[0], x4[1], x4[2], x4[3]);
	fprintf(stderr, "\tvx5:{%f, %f, %f, %f}\n", x5[0], x5[1], x5[2], x5[3]);

	// mul
	vx1 = vld1q_f32(init); vx2 = vld1q_f32(init);
	vx3 = vld1q_f32(init); vx4 = vld1q_f32(init); vx5 = vld1q_f32(init);
	mean = 0.0;
	for(int i=0 ; i<num_trials ; ++i){
		gettimeofday(&tvs, NULL);
		asm volatile("# start mul");
		for(int j=0 ; j<je ; ++j){
			vx1 = vmulq_f32(vx1, vmul11);
			vx2 = vmulq_f32(vx2, vmul21);
			vx3 = vmulq_f32(vx3, vmul31);
			vx4 = vmulq_f32(vx4, vmul41);
			vx5 = vmulq_f32(vx5, vmul51);
			vx1 = vmulq_f32(vx1, vmul12);
			vx2 = vmulq_f32(vx2, vmul22);
			vx3 = vmulq_f32(vx3, vmul32);
			vx4 = vmulq_f32(vx4, vmul42);
			vx5 = vmulq_f32(vx5, vmul52);
		}
		asm volatile("# end mul");
		gettimeofday(&tve, NULL);
		exe_times[i] = EXE_TIME_IN_USEC(tvs, tve);
		mean += EXE_TIME_IN_USEC(tvs, tve);
	}
	qsort(exe_times, num_trials, sizeof(double), compare_dbl);
	printf("mul\n");
	printf("\t min:%fusec\n", exe_times[0]);
	printf("\t med:%fusec\n", exe_times[num_trials / 2]);
	printf("\tmean:%fusec\n", mean / num_trials);
	printf("\t max:%fusec\n", exe_times[num_trials - 1]);
	vst1q_f32(x1, vx1);
	vst1q_f32(x2, vx2);
	vst1q_f32(x3, vx3);
	vst1q_f32(x4, vx4);
	vst1q_f32(x5, vx5);
	fprintf(stderr, "\tvx1:{%f, %f, %f, %f}\n", x1[0], x1[1], x1[2], x1[3]);
	fprintf(stderr, "\tvx2:{%f, %f, %f, %f}\n", x2[0], x2[1], x2[2], x2[3]);
	fprintf(stderr, "\tvx3:{%f, %f, %f, %f}\n", x3[0], x3[1], x3[2], x3[3]);
	fprintf(stderr, "\tvx4:{%f, %f, %f, %f}\n", x4[0], x4[1], x4[2], x4[3]);
	fprintf(stderr, "\tvx5:{%f, %f, %f, %f}\n", x5[0], x5[1], x5[2], x5[3]);

	// div0
	vx1 = vld1q_f32(mul11); vx2 = vld1q_f32(mul21);
	vx3 = vld1q_f32(mul31); vx4 = vld1q_f32(mul41); vx5 = vld1q_f32(mul51);
	vone = vld1q_f32(one);
	mean = 0.0;
	for(int i=0 ; i<num_trials ; ++i){
		gettimeofday(&tvs, NULL);
		asm volatile("# start div0");
		for(int j=0 ; j<je ; ++j){
			vx1 = div0(vone, vx1);
			vx2 = div0(vone, vx2);
			vx3 = div0(vone, vx3);
			vx4 = div0(vone, vx4);
			vx5 = div0(vone, vx5);
			vx1 = div0(vone, vx1);
			vx2 = div0(vone, vx2);
			vx3 = div0(vone, vx3);
			vx4 = div0(vone, vx4);
			vx5 = div0(vone, vx5);
		}
		asm volatile("# end div0");
		gettimeofday(&tve, NULL);
		exe_times[i] = EXE_TIME_IN_USEC(tvs, tve);
		mean += EXE_TIME_IN_USEC(tvs, tve);
	}
	qsort(exe_times, num_trials, sizeof(double), compare_dbl);
	printf("div0\n");
	printf("\t min:%fusec\n", exe_times[0]);
	printf("\t med:%fusec\n", exe_times[num_trials / 2]);
	printf("\tmean:%fusec\n", mean / num_trials);
	printf("\t max:%fusec\n", exe_times[num_trials - 1]);
	vst1q_f32(x1, vx1);
	vst1q_f32(x2, vx2);
	vst1q_f32(x3, vx3);
	vst1q_f32(x4, vx4);
	vst1q_f32(x5, vx5);
	fprintf(stderr, "\tvx1:{%f, %f, %f, %f}\n", x1[0], x1[1], x1[2], x1[3]);
	fprintf(stderr, "\tvx2:{%f, %f, %f, %f}\n", x2[0], x2[1], x2[2], x2[3]);
	fprintf(stderr, "\tvx3:{%f, %f, %f, %f}\n", x3[0], x3[1], x3[2], x3[3]);
	fprintf(stderr, "\tvx4:{%f, %f, %f, %f}\n", x4[0], x4[1], x4[2], x4[3]);
	fprintf(stderr, "\tvx5:{%f, %f, %f, %f}\n", x5[0], x5[1], x5[2], x5[3]);

	// div2
	vx1 = vld1q_f32(mul11); vx2 = vld1q_f32(mul21);
	vx3 = vld1q_f32(mul31); vx4 = vld1q_f32(mul41); vx5 = vld1q_f32(mul51);
	vone = vld1q_f32(one);
	mean = 0.0;
	for(int i=0 ; i<num_trials ; ++i){
		gettimeofday(&tvs, NULL);
		asm volatile("# start div2");
		for(int j=0 ; j<je ; ++j){
			vx1 = div2(vone, vx1);
			vx2 = div2(vone, vx2);
			vx3 = div2(vone, vx3);
			vx4 = div2(vone, vx4);
			vx5 = div2(vone, vx5);
			vx1 = div2(vone, vx1);
			vx2 = div2(vone, vx2);
			vx3 = div2(vone, vx3);
			vx4 = div2(vone, vx4);
			vx5 = div2(vone, vx5);
		}
		asm volatile("# end div2");
		gettimeofday(&tve, NULL);
		exe_times[i] = EXE_TIME_IN_USEC(tvs, tve);
		mean += EXE_TIME_IN_USEC(tvs, tve);
	}
	qsort(exe_times, num_trials, sizeof(double), compare_dbl);
	printf("div2\n");
	printf("\t min:%fusec\n", exe_times[0]);
	printf("\t med:%fusec\n", exe_times[num_trials / 2]);
	printf("\tmean:%fusec\n", mean / num_trials);
	printf("\t max:%fusec\n", exe_times[num_trials - 1]);
	vst1q_f32(x1, vx1);
	vst1q_f32(x2, vx2);
	vst1q_f32(x3, vx3);
	vst1q_f32(x4, vx4);
	vst1q_f32(x5, vx5);
	fprintf(stderr, "\tvx1:{%f, %f, %f, %f}\n", x1[0], x1[1], x1[2], x1[3]);
	fprintf(stderr, "\tvx2:{%f, %f, %f, %f}\n", x2[0], x2[1], x2[2], x2[3]);
	fprintf(stderr, "\tvx3:{%f, %f, %f, %f}\n", x3[0], x3[1], x3[2], x3[3]);
	fprintf(stderr, "\tvx4:{%f, %f, %f, %f}\n", x4[0], x4[1], x4[2], x4[3]);
	fprintf(stderr, "\tvx5:{%f, %f, %f, %f}\n", x5[0], x5[1], x5[2], x5[3]);

	// div3
	vx1 = vld1q_f32(mul11); vx2 = vld1q_f32(mul21);
	vx3 = vld1q_f32(mul31); vx4 = vld1q_f32(mul41); vx5 = vld1q_f32(mul51);
	vone = vld1q_f32(one);
	mean = 0.0;
	for(int i=0 ; i<num_trials ; ++i){
		gettimeofday(&tvs, NULL);
		asm volatile("# start div3");
		for(int j=0 ; j<je ; ++j){
			vx1 = div3(vone, vx1);
			vx2 = div3(vone, vx2);
			vx3 = div3(vone, vx3);
			vx4 = div3(vone, vx4);
			vx5 = div3(vone, vx5);
			vx1 = div3(vone, vx1);
			vx2 = div3(vone, vx2);
			vx3 = div3(vone, vx3);
			vx4 = div3(vone, vx4);
			vx5 = div3(vone, vx5);
		}
		asm volatile("# end div3");
		gettimeofday(&tve, NULL);
		exe_times[i] = EXE_TIME_IN_USEC(tvs, tve);
		mean += EXE_TIME_IN_USEC(tvs, tve);
	}
	qsort(exe_times, num_trials, sizeof(double), compare_dbl);
	printf("div3\n");
	printf("\t min:%fusec\n", exe_times[0]);
	printf("\t med:%fusec\n", exe_times[num_trials / 2]);
	printf("\tmean:%fusec\n", mean / num_trials);
	printf("\t max:%fusec\n", exe_times[num_trials - 1]);
	vst1q_f32(x1, vx1);
	vst1q_f32(x2, vx2);
	vst1q_f32(x3, vx3);
	vst1q_f32(x4, vx4);
	vst1q_f32(x5, vx5);
	fprintf(stderr, "\tvx1:{%f, %f, %f, %f}\n", x1[0], x1[1], x1[2], x1[3]);
	fprintf(stderr, "\tvx2:{%f, %f, %f, %f}\n", x2[0], x2[1], x2[2], x2[3]);
	fprintf(stderr, "\tvx3:{%f, %f, %f, %f}\n", x3[0], x3[1], x3[2], x3[3]);
	fprintf(stderr, "\tvx4:{%f, %f, %f, %f}\n", x4[0], x4[1], x4[2], x4[3]);
	fprintf(stderr, "\tvx5:{%f, %f, %f, %f}\n", x5[0], x5[1], x5[2], x5[3]);

	// div4
	vx1 = vld1q_f32(mul11); vx2 = vld1q_f32(mul21);
	vx3 = vld1q_f32(mul31); vx4 = vld1q_f32(mul41); vx5 = vld1q_f32(mul51);
	vone = vld1q_f32(one);
	mean = 0.0;
	for(int i=0 ; i<num_trials ; ++i){
		gettimeofday(&tvs, NULL);
		asm volatile("# start div4");
		for(int j=0 ; j<je ; ++j){
			vx1 = div4(vone, vx1);
			vx2 = div4(vone, vx2);
			vx3 = div4(vone, vx3);
			vx4 = div4(vone, vx4);
			vx5 = div4(vone, vx5);
			vx1 = div4(vone, vx1);
			vx2 = div4(vone, vx2);
			vx3 = div4(vone, vx3);
			vx4 = div4(vone, vx4);
			vx5 = div4(vone, vx5);
		}
		asm volatile("# end div4");
		gettimeofday(&tve, NULL);
		exe_times[i] = EXE_TIME_IN_USEC(tvs, tve);
		mean += EXE_TIME_IN_USEC(tvs, tve);
	}
	qsort(exe_times, num_trials, sizeof(double), compare_dbl);
	printf("div4\n");
	printf("\t min:%fusec\n", exe_times[0]);
	printf("\t med:%fusec\n", exe_times[num_trials / 2]);
	printf("\tmean:%fusec\n", mean / num_trials);
	printf("\t max:%fusec\n", exe_times[num_trials - 1]);
	vst1q_f32(x1, vx1);
	vst1q_f32(x2, vx2);
	vst1q_f32(x3, vx3);
	vst1q_f32(x4, vx4);
	vst1q_f32(x5, vx5);
	fprintf(stderr, "\tvx1:{%f, %f, %f, %f}\n", x1[0], x1[1], x1[2], x1[3]);
	fprintf(stderr, "\tvx2:{%f, %f, %f, %f}\n", x2[0], x2[1], x2[2], x2[3]);
	fprintf(stderr, "\tvx3:{%f, %f, %f, %f}\n", x3[0], x3[1], x3[2], x3[3]);
	fprintf(stderr, "\tvx4:{%f, %f, %f, %f}\n", x4[0], x4[1], x4[2], x4[3]);
	fprintf(stderr, "\tvx5:{%f, %f, %f, %f}\n", x5[0], x5[1], x5[2], x5[3]);

	// div8
	vx1 = vld1q_f32(mul11); vx2 = vld1q_f32(mul21);
	vx3 = vld1q_f32(mul31); vx4 = vld1q_f32(mul41); vx5 = vld1q_f32(mul51);
	vone = vld1q_f32(one);
	mean = 0.0;
	for(int i=0 ; i<num_trials ; ++i){
		gettimeofday(&tvs, NULL);
		asm volatile("# start div8");
		for(int j=0 ; j<je ; ++j){
			vx1 = div8(vone, vx1);
			vx2 = div8(vone, vx2);
			vx3 = div8(vone, vx3);
			vx4 = div8(vone, vx4);
			vx5 = div8(vone, vx5);
			vx1 = div8(vone, vx1);
			vx2 = div8(vone, vx2);
			vx3 = div8(vone, vx3);
			vx4 = div8(vone, vx4);
			vx5 = div8(vone, vx5);
		}
		asm volatile("# end div8");
		gettimeofday(&tve, NULL);
		exe_times[i] = EXE_TIME_IN_USEC(tvs, tve);
		mean += EXE_TIME_IN_USEC(tvs, tve);
	}
	qsort(exe_times, num_trials, sizeof(double), compare_dbl);
	printf("div8\n");
	printf("\t min:%fusec\n", exe_times[0]);
	printf("\t med:%fusec\n", exe_times[num_trials / 2]);
	printf("\tmean:%fusec\n", mean / num_trials);
	printf("\t max:%fusec\n", exe_times[num_trials - 1]);
	vst1q_f32(x1, vx1);
	vst1q_f32(x2, vx2);
	vst1q_f32(x3, vx3);
	vst1q_f32(x4, vx4);
	vst1q_f32(x5, vx5);
	fprintf(stderr, "\tvx1:{%f, %f, %f, %f}\n", x1[0], x1[1], x1[2], x1[3]);
	fprintf(stderr, "\tvx2:{%f, %f, %f, %f}\n", x2[0], x2[1], x2[2], x2[3]);
	fprintf(stderr, "\tvx3:{%f, %f, %f, %f}\n", x3[0], x3[1], x3[2], x3[3]);
	fprintf(stderr, "\tvx4:{%f, %f, %f, %f}\n", x4[0], x4[1], x4[2], x4[3]);
	fprintf(stderr, "\tvx5:{%f, %f, %f, %f}\n", x5[0], x5[1], x5[2], x5[3]);
	
	free(exe_times);
	return 0;
}

