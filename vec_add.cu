// 2022/1/13

#include "test.h"

#define N 100
#define M 10

__global__ void kernel1(int* a, int* b, int* c)
{
	int index = blockIdx.x * blockDim.x + threadIdx.x;

	if (index >= N) return;
	c[index] = a[index] + b[index];
}

void vecAdd()
{
	int a[N];
	int b[N];
	int c[N];

	float elapsed_time = 0;
	cudaEvent_t start, stop;

	for (int i = 0; i < N; ++i)
	{
		a[i] = b[i] = i;
	}

	int* d_a, * d_b, * d_c;

	cudaMalloc((void**)&d_a, sizeof(int) * N);
	cudaMalloc((void**)&d_b, sizeof(int) * N);
	cudaMalloc((void**)&d_c, sizeof(int) * N);

	cudaMemcpy(d_a, a, sizeof(int) * N, cudaMemcpyHostToDevice);
	cudaMemcpy(d_b, b, sizeof(int) * N, cudaMemcpyHostToDevice);

	START_GPU
	kernel1 << <(N + M -1) / M, M >> > (d_a, d_b, d_c);
	cudaError_t err = cudaGetLastError();

	if (err != cudaSuccess)
	{
		fprintf(stderr, "Failed to launch kernel (error code %s)!\n", cudaGetErrorString(err));
		exit(EXIT_FAILURE);
	}
	STOP_GPU

	printf("%fms\n", elapsed_time);

	cudaMemcpy(c, d_c, sizeof(int) * N, cudaMemcpyDeviceToHost);

	cudaFree(d_a);
	cudaFree(d_b);
	cudaFree(d_c);

	for (int i = N-1; i > N - 20; --i)
	{
		printf("%d\n", c[i]);
	}
}

