// 2022/1/13

#pragma once

#include <stdio.h>
#include <stdlib.h>
#include <cuda_runtime.h>

#define START_GPU {\
cudaEventCreate(&start);\
cudaEventCreate(&stop);\
cudaEventRecord(start, 0);

#define STOP_GPU \
cudaEventRecord(stop, 0);\
cudaEventSynchronize(stop);\
cudaEventElapsedTime(&elapsed_time, start, stop);\
cudaEventDestroy(start);\
cudaEventDestroy(stop);}

void vecAdd();
void twokernel();