#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#define NUM_THREADS 8
#define MEMORY_SIZE (256ULL * 1024ULL * 1024ULL)  // 256 MB por thread
#define NUM_ITERATIONS 10

typedef struct {
  int thread_id;
  size_t memory_size;
  size_t elements;
  double *memory;
} thread_arg_t;

/*
 * Kernel sencillo para consumir CPU.
 */
static void cpu_burn(double *memory, size_t elements) {
  volatile double acc = 1.0;

  for (int iter = 0; iter < NUM_ITERATIONS; iter++) {
    for (size_t i = 0; i < elements; i++) {
      double x = memory[i];

      /*
       * Suficiente cálculo para mantener
       * ocupado al core.
       */
      x = x * 1.0000001 + acc;
      x = x * 0.9999999 + 0.000001;
      x = x * 1.0000003 + 0.000002;

      memory[i] = x;

      acc += x * 0.0000000001;
    }
  }
}

static void *worker(void *arg) {
  thread_arg_t *thread_arg = (thread_arg_t *)arg;

  int id = thread_arg->thread_id;
  size_t memory_size = thread_arg->memory_size;
  size_t elements = thread_arg->elements;
  double *memory = thread_arg->memory;

  printf("Thread %d: %.2f MB asignados\n", id,
         memory_size / (1024.0 * 1024.0));

  /*
   * Carga de CPU por un numero fijo de iteraciones.
   */
  cpu_burn(memory, elements);

  printf("Thread %d: finalizado\n", id);

  return NULL;
}

/*
 * Cambio para que main reciba argumentos, para poder
 * pasarle el numero de threads.
 */
int main(int argc, char *argv[]) {

  if (argc != 2) {
    fprintf(stderr, "Uso: %s <numero_de_hilos>\n", argv[0]);
    return EXIT_FAILURE;
  }

  int num_threads = atoi(argv[1]);

  if (num_threads < 1 || num_threads > NUM_THREADS) {
    fprintf(stderr, "El numero de hilos debe estar entre 1 y %d\n",
            NUM_THREADS);
    return EXIT_FAILURE;
  }

  pthread_t threads[NUM_THREADS];
  thread_arg_t args[NUM_THREADS];

  long num_cpus = sysconf(_SC_NPROCESSORS_ONLN);

  printf("CPUs logicos disponibles: %ld\n", num_cpus);
  printf("Hilos utilizados: %d\n", num_threads);

  /*
   * Verifica que no se soliciten mas hilos que
   * CPUs logicos disponibles.
   */
  if (num_cpus < num_threads) {
    fprintf(stderr, "No hay suficientes CPUs logicas\n");
    return EXIT_FAILURE;
  }

  /*
   * Reserva e inicializa la memoria correspondiente
   * a cada thread.
   */
  for (int i = 0; i < num_threads; i++) {
    double *memory = NULL;

    memory = (double *)malloc(MEMORY_SIZE);

    if (memory == NULL) {
      fprintf(stderr, "Thread %d: error reservando memoria\n", i);

      for (int j = 0; j < i; j++) {
        free(args[j].memory);
      }

      return EXIT_FAILURE;
    }

    size_t elements = MEMORY_SIZE / sizeof(double);

    for (size_t j = 0; j < elements; j++) {
      memory[j] = (double)(i + 1);
    }

    args[i].thread_id = i;
    args[i].memory_size = MEMORY_SIZE;
    args[i].elements = elements;
    args[i].memory = memory;
  }

  /*
   * Crea los threads.
   * En esta version no se fija afinidad a ningun CPU.
   * El sistema operativo decide en que CPU ejecutarlos.
   */
  for (int i = 0; i < num_threads; i++) {
    int ret = pthread_create(&threads[i], NULL, worker, &args[i]);

    if (ret != 0) {
      fprintf(stderr, "Error creando thread %d\n", i);
      return EXIT_FAILURE;
    }
  }

  /*
   * Espera a que todos los threads terminen.
   */
  for (int i = 0; i < num_threads; i++) {
    pthread_join(threads[i], NULL);
  }

  /*
   * Libera la memoria reservada.
   */
  for (int i = 0; i < num_threads; i++) {
    free(args[i].memory);
  }

  return EXIT_SUCCESS;
}