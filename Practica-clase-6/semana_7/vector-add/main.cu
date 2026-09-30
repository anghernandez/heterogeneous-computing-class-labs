#include <cmath>
#include <cstdio>
#include <cstdlib>

#include <cuda_runtime.h> //proporciona las funciones CUDA Runtime API 


//esto es un macro para detectar errores    
#define CUDA_CHECK(call)                                                       \
    do {                                                                       \
        cudaError_t err = (call);                                              \
        if (err != cudaSuccess) {                                              \
            std::fprintf(stderr, "CUDA error %s:%d: %s\n", __FILE__, __LINE__, \
                         cudaGetErrorString(err));                             \
            std::exit(EXIT_FAILURE);                                           \
        }                                                                      \
    } while (0)



__global__ void vector_add_kernel(const float *a, const float *b, float *c,
    /*__global__ indica que esta función es un kernel CUDA.
    La función se inicia desde la CPU (host), pero se ejecuta en la GPU (device).
    */                              
    int n) {
    int i = blockIdx.x * blockDim.x + threadIdx.x;  
    /*
    CUDA organiza los hilos jerárquicamente.
    blockIdx.x = índice del bloque actual.
    blockDim.x = cantidad de hilos que contiene cada bloque.
    threadIdx.x = posición del hilo dentro de su bloque .

    indice global único para cada hilo:
    i = blockIdx.x * blockDim.x + theradIdx.x

    */


    if (i < n) {
/*
 i < n protege para que los hilos no accedan fuera de los límites de los vectores.
Si N no es múltiplo del tamaño del bloque, se lanza un último bloque parcialmente
útil; los hilos sobrantes son descartados lógicamente mediante i < n.

Ejemplo:
N = 10, usando 4 hilos, no se puede lazanr exactamente 10 hilos usando bloques
completos de 4 
Se necesita : 10/4 = 3 bloques (redondeo hacia arriba), entonces se lanzan 3 x 4 = 12
12 hilos, entonces i = 10, 11 no tienen un elemento válido que procesar


Para este caso:
threads_per_block = 256
blocks = 4096

Dentro de cada bloque,
threadIdx.x va de 0 a 255.
blockIdx.x va de 0 a 4095.
blockDim.x siempre vale 256


Bloque 0    → hilos globales 0       a 255
Bloque 1    → hilos globales 256     a 511
Bloque 2    → hilos globales 512     a 767
...
Bloque 255  → hilos globales 65280   a 65535
...
Bloque 4095 → hilos globales 1048320 a 1048575

*/

        // TODO: Calcule c[i] = a[i] + b[i].


c[i] = a[i] + b[i];

/*
 La primera diferencia contra la CPU es que no aplica hacer la suma mediante un for
 convencional, lo que se busca es que distintos hilos trabajen simultaneamente.        
*/




    }
}

static void fill_vectors(float *a, float *b, int n) {
    for (int i = 0; i < n; ++i) {
        a[i] = 0.5f * static_cast<float>(i);
        b[i] = 2.0f * static_cast<float>(i % 17);
    }
}

static bool verify_result(const float *a, const float *b, const float *c,
                          int n) {
    for (int i = 0; i < n; ++i) {
        float expected = a[i] + b[i];
        if (std::fabs(c[i] - expected) > 1e-5f) {
            std::fprintf(stderr,
                         "Error en indice %d: obtenido %.6f, esperado %.6f\n",
                         i, c[i], expected);
            return false;
        }
    }

    return true;
}

int main(int argc, char **argv) {
    int n = 1 << 20; //cesplazamiento binario n = 1 048 576
    if (argc > 1) {
        n = std::atoi(argv[1]);
    }

    size_t bytes = static_cast<size_t>(n) * sizeof(float);

    float *h_a = static_cast<float *>(std::malloc(bytes)); //espacio de memoria CPU
    float *h_b = static_cast<float *>(std::malloc(bytes));
    float *h_c = static_cast<float *>(std::malloc(bytes));

    if (!h_a || !h_b || !h_c) {
        std::fprintf(stderr, "No se pudo reservar memoria en CPU\n");
        return EXIT_FAILURE;
    }

    fill_vectors(h_a, h_b, n);

    float *d_a = nullptr; //espacio de memoria GPU
    float *d_b = nullptr;
    float *d_c = nullptr;

    CUDA_CHECK(cudaMalloc(&d_a, bytes));
    CUDA_CHECK(cudaMalloc(&d_b, bytes));
    CUDA_CHECK(cudaMalloc(&d_c, bytes));

    CUDA_CHECK(cudaMemcpy(d_a, h_a, bytes, cudaMemcpyHostToDevice));
    CUDA_CHECK(cudaMemcpy(d_b, h_b, bytes, cudaMemcpyHostToDevice));
    CUDA_CHECK(cudaMemset(d_c, 0, bytes));

    int threads_per_block = 256; //cada bloque tiene 256 hilos
    int blocks = (n + threads_per_block - 1) / threads_per_block; // N/256 (redondeo hacia arriba)

    vector_add_kernel<<<blocks, threads_per_block>>>(d_a, d_b, d_c, n);
    CUDA_CHECK(cudaGetLastError());
    CUDA_CHECK(cudaDeviceSynchronize());

    CUDA_CHECK(cudaMemcpy(h_c, d_c, bytes, cudaMemcpyDeviceToHost));

    bool ok = verify_result(h_a, h_b, h_c, n);
    std::printf("vector-add n=%d: %s\n", n, ok ? "OK" : "ERROR");

    CUDA_CHECK(cudaFree(d_a));
    CUDA_CHECK(cudaFree(d_b));
    CUDA_CHECK(cudaFree(d_c));
    std::free(h_a);
    std::free(h_b);
    std::free(h_c);

    return ok ? EXIT_SUCCESS : EXIT_FAILURE;
}
