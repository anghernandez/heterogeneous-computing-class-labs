## Preguntas

### 1. ¿Por qué se calcula primero el máximo de cada fila?

El máximo de cada fila se calcula para mejorar la estabilidad numérica del softmax. Antes de calcular la exponencial, se resta el máximo de la fila:

\[
e^{x_i - x_{\max}}
\]

De esta forma, el mayor exponente será 0 y los demás serán menores o iguales a 0, evitando valores exponenciales excesivamente grandes. Esta operación no cambia el resultado final del softmax.

### 2. ¿Qué partes del algoritmo requieren cooperación entre hilos del mismo bloque?

La cooperación entre hilos se necesita principalmente en dos etapas:

- Para encontrar el máximo de cada fila.
- Para calcular la suma de todas las exponenciales de la fila.

Cada hilo procesa una parte de las columnas y obtiene primero un resultado local (`local_max` o `local_sum`). Luego, estos resultados se almacenan en memoria compartida (`cache`) y se combinan mediante una reducción hasta obtener un único resultado para toda la fila.

Se utiliza `__syncthreads()` para asegurar que todos los hilos del bloque hayan terminado cada etapa antes de continuar con la siguiente.

### 3. ¿Qué limitación tiene usar un solo bloque por fila cuando `cols` crece mucho?

Un bloque tiene una cantidad limitada de hilos. En este caso se utilizan 256 hilos por bloque, por lo que si una fila contiene más de 256 columnas, cada hilo debe procesar varias columnas.

Por ejemplo, para `cols = 1024`, cada hilo procesa aproximadamente 4 elementos. Si `cols` aumenta mucho, cada hilo tendrá que realizar más trabajo de forma secuencial. Esto puede limitar el paralelismo y el rendimiento, ya que una sola fila continúa siendo procesada únicamente por un bloque.


## Anotaciones

- `blockIdx.x` identifica la fila que procesa cada bloque.
- `threadIdx.x` (`tid`) identifica cada hilo dentro del bloque.
- Las columnas se distribuyen entre los hilos mediante:

  ```cpp
  for (int col = tid; col < cols; col += blockDim.x)