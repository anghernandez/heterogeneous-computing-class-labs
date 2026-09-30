## Preguntas

### ¿Cuántos bloques se lanzan cuando N = 1048576 y cada bloque tiene 256 hilos?

Se lanzan 4096 bloques, ya que: \\
1048576 / 256 = 4096
Cada bloque contiene 256 hilos y cada hilo se encarga de realizar la suma correspondiente a un elemento de los vectores.

### ¿Qué ocurre si N no es múltiplo del tamaño del bloque?

Se lanza un último bloque aunque no todos sus hilos sean necesarios. Los hilos sobrantes obtienen índices que se encuentran fuera del tamaño del vector, por lo que la condición `i < n` evita que accedan a esas posiciones.

### ¿Qué transferencias de memoria ocurren entre CPU y GPU?

Primero se reservan e inicializan los vectores A y B en la CPU. Estos dos vectores se transfieren de la CPU a la GPU para realizar la suma. El resultado se almacena en el vector C en la GPU y posteriormente C se transfiere de regreso a la CPU para verificar el resultado.

Por lo tanto, se realizan dos transferencias CPU → GPU, correspondientes a A y B, y una transferencia GPU → CPU, correspondiente a C.