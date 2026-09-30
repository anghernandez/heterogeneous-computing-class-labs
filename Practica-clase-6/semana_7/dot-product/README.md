## Preguntas

### ¿Por qué este ejercicio no puede resolverse solamente escribiendo un valor independiente por hilo?

Porque el producto punto requiere obtener un único resultado a partir de la suma de todos los productos `A[i] * B[i]`. Aunque cada hilo puede calcular su producto de forma independiente, estos resultados deben combinarse posteriormente mediante una reducción. En este caso, los hilos de cada bloque acumulan sus resultados en memoria compartida hasta obtener una suma parcial por bloque.

### ¿Cuántos valores parciales se copian de GPU a CPU?

Se copia un valor parcial por cada bloque ejecutado. La cantidad de valores parciales está dada por:

`blocks = (N + threads_per_block - 1) / threads_per_block`

Con 256 hilos por bloque:

- Para `N = 1048576` se generan y copian `4096` valores parciales.
- Para `N = 4194304` se generan y copian `16384` valores parciales.

Posteriormente, la CPU suma estos valores parciales para obtener el resultado final del producto punto.

### ¿Qué pasaría si se elimina alguna sincronización dentro de la reducción?

Podría producirse una condición de carrera, ya que algunos hilos podrían comenzar una nueva etapa de la reducción antes de que otros hayan terminado de actualizar los valores de la etapa anterior. Como cada etapa depende de los resultados obtenidos en la anterior, esto podría provocar lecturas de valores que todavía no han sido actualizados y generar un resultado incorrecto.

### ¿Cuál es el papel de `__syncthreads()`?

`__syncthreads()` actúa como una barrera de sincronización para los hilos de un mismo bloque. Cada hilo debe llegar a esta barrera antes de que cualquiera de ellos pueda continuar. En este ejercicio se utiliza para garantizar que los valores de la memoria compartida `cache` estén listos antes de comenzar la reducción y que cada etapa de la reducción haya finalizado antes de iniciar la siguiente.