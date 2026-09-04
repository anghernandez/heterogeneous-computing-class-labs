# Práctica Semana 3
<div align="justify">


## Affinity y Naive
### Affinity

En esta prueba se evaluó el comportamiento de la versión con afinidad de CPU,
variando el número de hilos desde 1 hasta 8. Cada hilo fue asignado de manera
explícita a un procesador lógico, con el objetivo de controlar dónde se ejecuta
cada hilo y evitar que el sistema operativo lo migre entre procesadores.

Para evaluar el rendimiento se utilizó el tiempo real de ejecución (`real`)
reportado durante cada prueba.

### Resultados

| Número de hilos | Tiempo de ejecución (s) | Speedup | Eficiencia |
|---:|---:|---:|---:|
| 1 | 6.04 | 1.000 | 100.0 % |
| 2 | 5.30 | 1.140 | 57.0 % |
| 3 | 6.36 | 0.950 | 31.7 % |
| 4 | 6.96 | 0.868 | 21.7 % |
| 5 | 7.81 | 0.773 | 15.5 % |
| 6 | 7.93 | 0.762 | 12.7 % |
| 7 | 10.09 | 0.599 | 8.6 % |
| 8 | 10.52 | 0.574 | 7.2 % |


<p align="center">
  <img src="./semana%203/threading/affinity.png" width="600">
</p>

### Evaluación del rendimiento y escalabilidad

El mejor tiempo de ejecución se obtuvo utilizando 2 hilos, con un tiempo de
5.30 s, frente a los 6.04 s obtenidos con un solo hilo. Esto corresponde a un
speedup de aproximadamente 1.14.

Sin embargo, al utilizar más de 2 hilos el tiempo de ejecución comienza a
aumentar. Con 4 hilos se obtuvieron 6.96 s y con 8 hilos el tiempo alcanzó
10.52 s. Por lo tanto, para esta carga de trabajo la implementación con
afinidad no presenta una escalabilidad positiva al incrementar continuamente
el número de hilos.

Este comportamiento indica que el aumento en la cantidad de hilos introduce
costos que terminan superando el beneficio del paralelismo. Entre estos costos
se encuentran la competencia por recursos compartidos del procesador, el
acceso a memoria y la sobrecarga asociada a la ejecución concurrente de los
hilos.

### Proporción paralela

La proporción paralelizable puede estimarse mediante la Ley de Amdahl a partir
del speedup medido. Para 2 hilos se obtuvo un speedup de aproximadamente 1.14,
lo que produce una estimación de aproximadamente 24.5 % de código
paralelizable bajo el modelo ideal de Amdahl.

Esta estimación debe interpretarse con precaución. A partir de
3 hilos el speedup medido es menor que 1, es decir, la ejecución paralela
resulta más lenta que la ejecución con un solo hilo. En estas condiciones,
utilizar directamente la Ley de Amdahl produciría valores de fracción paralela
sin significado físico. 
### Eficiencia

La eficiencia disminuye conforme aumenta el número de hilos. Con 2 hilos se
obtiene una eficiencia aproximada del 57.0 %, mientras que con 4 hilos cae al
21.7 % y con 8 hilos alcanza solamente un 7.2 %.

Esto muestra que los recursos adicionales no están siendo aprovechados de
manera proporcional. El mejor resultado de esta prueba se encuentra en 2
hilos; después de ese punto, agregar más hilos provoca una degradación del
rendimiento en lugar de una mejora.

### Naive

En esta prueba se evaluó la implementación *Naive*, en la cual los hilos no
son asociados explícitamente a un procesador lógico. Por lo tanto, el
planificador del sistema operativo es el encargado de decidir dónde se ejecuta
cada hilo y puede migrarlos entre los procesadores disponibles.

Se realizaron pruebas variando el número de hilos desde 1 hasta 8 y se utilizó
el tiempo real de ejecución (`real`) como métrica de rendimiento.

### Resultados

| Número de hilos | Tiempo de ejecución (s) | Speedup | Eficiencia |
|---:|---:|---:|---:|
| 1 | 4.615 | 1.000 | 100.0 % |
| 2 | 4.627 | 0.997 | 49.9 % |
| 3 | 4.733 | 0.975 | 32.5 % |
| 4 | 5.247 | 0.880 | 22.0 % |
| 5 | 5.806 | 0.795 | 15.9 % |
| 6 | 7.091 | 0.651 | 10.9 % |
| 7 | 8.726 | 0.529 | 7.6 % |
| 8 | 9.054 | 0.510 | 6.4 % |

<p align="center">
  <img src="./semana%203/threading/naive.png" width="600">
</p>

### Evaluación del rendimiento y escalabilidad

El menor tiempo de ejecución se obtuvo con un solo hilo, con 4.615 s.
Al utilizar 2 hilos el tiempo prácticamente no cambió, alcanzando 4.627 s.
A partir de este punto, aumentar el número de hilos produjo un incremento
progresivo del tiempo de ejecución. Con 8 hilos se obtuvo un tiempo de
9.054 s, aproximadamente el doble del tiempo registrado con un solo hilo.

Por lo tanto, esta implementación no presenta escalabilidad positiva para la
carga de trabajo evaluada. El incremento en el número de hilos no consigue
compensar los costos asociados con la ejecución concurrente, como la
administración de los hilos, la competencia por recursos compartidos y los
accesos a memoria.

### Proporción paralela

Debido a que no se obtuvo un speedup mayor que 1 para ninguna configuración
con más de un hilo, los resultados experimentales no permiten obtener una
estimación físicamente válida de la fracción paralelizable mediante el modelo
ideal de la Ley de Amdahl.

Esto no significa que el programa carezca completamente de trabajo ejecutado
en paralelo. Significa que, para esta implementación y carga de trabajo, las
ganancias producidas por el paralelismo son menores que las sobrecargas y la
contención introducidas al utilizar varios hilos.

### Eficiencia

La eficiencia disminuye rápidamente conforme aumenta el número de hilos.
Con 2 hilos se obtiene aproximadamente un 49.9 %, mientras que con 4 hilos
se reduce al 22.0 %. Finalmente, con 8 hilos la eficiencia es de
aproximadamente 6.4 %.

Estos resultados muestran que agregar recursos de procesamiento no produce
una mejora proporcional del rendimiento. Para esta prueba, la configuración
de un solo hilo presentó el menor tiempo de ejecución.

## Matmul y Softmax

En esta sección se evaluó la escalabilidad de las implementaciones paralelas
de multiplicación de matrices (Matmul) y Softmax utilizando OpenMP. En ambos
casos se varió el número de hilos desde 1 hasta 8.

A diferencia de las pruebas Affinity y Naive, para estas pruebas se utilizó
el tiempo de ejecución medido directamente por cada aplicación mediante
`omp_get_wtime()`.

### Matmul

| Número de hilos | Tiempo de ejecución (s) | Speedup | Eficiencia |
|---:|---:|---:|---:|
| 1 | 0.926556 | 1.000 | 100.0 % |
| 2 | 0.535680 | 1.730 | 86.5 % |
| 3 | 0.471824 | 1.964 | 65.5 % |
| 4 | 0.431698 | 2.146 | 53.7 % |
| 5 | 0.486611 | 1.904 | 38.1 % |
| 6 | 0.446599 | 2.075 | 34.6 % |
| 7 | 0.363660 | 2.548 | 36.4 % |
| 8 | 0.534611 | 1.733 | 21.7 % |

<p align="center">
  <img src="./semana%203/scaling/matmul.png" width="600">
</p>

#### Evaluación del rendimiento y escalabilidad

Matmul presenta una mejora clara del rendimiento al utilizar varios hilos.
Con un solo hilo el tiempo de ejecución fue de 0.926556 s, mientras que con
2 hilos disminuyó a 0.535680 s. El menor tiempo de toda la prueba se obtuvo
con 7 hilos, alcanzando 0.363660 s.

Esto representa un speedup máximo aproximado de 2.55 con respecto a la
ejecución con un solo hilo.

Sin embargo, la reducción del tiempo no es uniforme. Por ejemplo, al pasar de
4 a 5 hilos el tiempo aumenta de 0.431698 s a 0.486611 s, y con 8 hilos
aumenta nuevamente hasta 0.534611 s. Por lo tanto, Matmul presenta
escalabilidad positiva, pero no lineal.

El comportamiento indica que existe suficiente trabajo computacional para
beneficiarse del paralelismo, aunque al aumentar el número de hilos aparecen
limitaciones relacionadas con la sobrecarga de OpenMP y la competencia por
recursos compartidos del procesador.

#### Proporción paralela

Utilizando como referencia el mejor resultado experimental, obtenido con
7 hilos y un speedup de aproximadamente 2.55, la Ley de Amdahl permite
estimar una fracción paralelizable cercana al 70.9 %.


#### Eficiencia

Con 2 hilos se obtiene una eficiencia aproximada del 86.5 %, mostrando un buen
aprovechamiento inicial de los recursos disponibles. Con 4 hilos la eficiencia
disminuye al 53.7 % y con 7 hilos, aunque se obtiene el menor tiempo de
ejecución, la eficiencia es de aproximadamente 36.4 %.

Con 8 hilos la eficiencia cae hasta aproximadamente 21.7 %. Esto demuestra
que aumentar el número de hilos continúa teniendo un costo y que el punto de
menor tiempo de ejecución no necesariamente coincide con el punto de mayor
eficiencia.


### Softmax

| Número de hilos | Tiempo de ejecución (s) | Speedup | Eficiencia |
|---:|---:|---:|---:|
| 1 | 1.140511 | 1.000 | 100.0 % |
| 2 | 0.839102 | 1.359 | 68.0 % |
| 3 | 0.797587 | 1.430 | 47.7 % |
| 4 | 0.838317 | 1.360 | 34.0 % |
| 5 | 0.882432 | 1.292 | 25.8 % |
| 6 | 0.975839 | 1.169 | 19.5 % |
| 7 | 1.093668 | 1.043 | 14.9 % |
| 8 | 2.731647 | 0.418 | 5.2 % |

<p align="center">
  <img src="./semana%203/scaling/softmax.png" width="600">
</p>

#### Evaluación del rendimiento y escalabilidad

Softmax presenta una mejora de rendimiento únicamente con una cantidad
pequeña de hilos. El tiempo disminuye de 1.140511 s con un hilo a
0.839102 s con 2 hilos y alcanza su mínimo de 0.797587 s utilizando
3 hilos.

Con 3 hilos se obtiene el mayor speedup, aproximadamente 1.43. Sin embargo,
a partir de este punto el tiempo comienza a aumentar progresivamente. Con
7 hilos el tiempo es similar al obtenido con un solo hilo y con 8 hilos
aumenta considerablemente hasta 2.731647 s.

Por lo tanto, Softmax presenta una escalabilidad limitada. Existe un beneficio
inicial al paralelizar la operación, pero agregar más hilos después del punto
óptimo produce una degradación del rendimiento.

Una posible explicación se encuentra en el tamaño del trabajo realizado y en
la estructura de la implementación. La operación Softmax utiliza varias
regiones paralelas y sincronizaciones de OpenMP. Cuando el trabajo disponible
por hilo es relativamente pequeño, la creación y coordinación de los hilos,
las reducciones y las sincronizaciones pueden representar una parte importante
del tiempo total.

#### Proporción paralela

Tomando el mejor resultado, correspondiente a 3 hilos y un speedup aproximado
de 1.43, mediante la Ley de Amdahl se obtiene una estimación de aproximadamente
45.1 % de fracción paralelizable.


#### Eficiencia

Softmax alcanza una eficiencia aproximada del 68.0 % con 2 hilos y del
47.7 % con 3 hilos. Después de este punto la eficiencia disminuye rápidamente:
con 4 hilos es aproximadamente 34.0 %, con 7 hilos 14.9 % y con 8 hilos
solamente 5.2 %.

Los resultados muestran que para esta carga de trabajo utilizar todos los
procesadores lógicos disponibles no representa la configuración más eficiente.
El mejor tiempo se obtuvo con 3 hilos.

# Práctica Semana 4

## Biblioteca estática y biblioteca dinámica

En esta práctica se evaluó el comportamiento de una biblioteca estática y una
biblioteca dinámica utilizando las mismas operaciones sobre vectores. Para
ambas implementaciones se utilizaron 1 000 000 de elementos y 1000 iteraciones,
con el objetivo de comparar los tiempos de ejecución obtenidos y el tamaño de
los archivos de biblioteca generados.

La biblioteca estática generada fue `libvectorops.a`, mientras que la
biblioteca dinámica generada fue `libvectorops.so`.

### Resultados

| Métrica | Biblioteca estática | Biblioteca dinámica |
|---|---:|---:|
| Fill A total | 876307.138 µs | 2414084.880 µs |
| Fill A por iteración | 876.307 µs | 2414.085 µs |
| Fill B total | 953689.656 µs | 2289122.683 µs |
| Fill B por iteración | 953.690 µs | 2289.123 µs |
| Add total | 1837713.999 µs | 2275456.567 µs |
| Add por iteración | 1837.714 µs | 2275.457 µs |
| Tiempo total | 3667711.786 µs (3.668 s) | 6978664.774 µs (6.979 s) |
| Tamaño de la biblioteca | 1.8 KB | 16 KB |

### Comparación de resultados

En las mediciones realizadas, la biblioteca estática presentó un menor tiempo
de ejecución que la biblioteca dinámica. El tiempo total registrado para la
versión estática fue de aproximadamente 3.668 s, mientras que la versión
dinámica necesitó aproximadamente 6.979 s para realizar la misma carga de
trabajo.

En esta ejecución, el tiempo total de la versión dinámica fue aproximadamente
1.90 veces el obtenido con la versión estática. La diferencia más notable se
observa en las operaciones de llenado de los vectores. `Fill A` pasó de
aproximadamente 876.307 µs por iteración en la versión estática a 2414.085 µs
en la dinámica, mientras que `Fill B` pasó de 953.690 µs a 2289.123 µs por
iteración.

La operación de suma también presentó un incremento, aunque menos pronunciado.
La biblioteca estática necesitó aproximadamente 1837.714 µs por iteración,
mientras que la dinámica registró 2275.457 µs.

Una diferencia importante entre ambas implementaciones se encuentra en el
mecanismo de enlazado. En la biblioteca estática, el código necesario de la
biblioteca se incorpora al ejecutable durante el proceso de enlazado. En
cambio, la versión dinámica mantiene una dependencia con la biblioteca
compartida (`.so`), la cual debe ser cargada y mapeada en memoria, y sus
referencias deben resolverse mediante los mecanismos de enlazado dinámico.

Esto puede introducir costos adicionales en comparación con el enlazado
estático. Sin embargo, una vez cargada la biblioteca dinámica, su código se
encuentra mapeado en la memoria virtual del proceso. Por lo tanto, no significa
que cada operación requiera acceder nuevamente al archivo `.so` en el
almacenamiento.


## Conceptos de estudio 🤓

**Core físico, procesador lógico e hilo:** No son lo mismo. Un core es un
núcleo físico del procesador; un procesador lógico es una unidad de ejecución
que el sistema operativo reconoce como CPU disponible; y un hilo es una
secuencia de ejecución creada por software que será ejecutada sobre uno de
esos procesadores lógicos.


#### Más hilos ≠ automáticamente más rendimiento

Los hilos compiten por recursos como caché, ancho de banda de memoria y
unidades de ejecución. Además, crear, coordinar y sincronizar hilos tiene un
costo. Por esta razón, aumentar el número de hilos puede mejorar el
rendimiento hasta cierto punto y después dejar de ayudar o incluso empeorarlo.

**Tiempo de ejecución (Execution Time):** Indica cuánto tarda realmente la
carga de trabajo. Un tiempo menor significa una ejecución más rápida, pero esta
métrica por sí sola no indica qué tan bien estamos aprovechando los recursos.
Por eso son necesarias métricas como speedup y eficiencia.

**Speedup (Aceleración):** Indica cuántas veces más rápido se ejecuta un
programa después de aplicar una mejora, tomando como referencia la ejecución
con un solo hilo.

$
S(p) = \frac{T_1}{T_p}
$

- Speedup > 1: existe una mejora.
- Speedup = 1: no existe mejora.
- Speedup < 1: la ejecución empeoró.
- Idealmente, con `p` hilos se busca un speedup cercano a `p`.

**Escalabilidad (Scalability):** Indica qué sucede con el rendimiento cuando
se agregan más recursos. En esta práctica, el recurso que aumentamos es el
número de hilos. Un programa escala bien si al agregar hilos el tiempo de
ejecución continúa disminuyendo de manera significativa.

**Eficiencia (Efficiency):** Mientras que el speedup responde
"¿cuánto más rápido fui?", la eficiencia responde "¿qué tan bien aproveché
los hilos que utilicé?".

$
E(p) = \frac{S(p)}{p} \times 100\%
$

Una eficiencia cercana al 100 % indica un aprovechamiento cercano al ideal de
los recursos utilizados. Normalmente la eficiencia disminuye al agregar más
hilos debido a la sobrecarga y la competencia por recursos.

**Parte serial y parte paralela:** No todo el código de un programa
necesariamente puede ejecutarse en paralelo. La parte paralela puede
distribuirse entre varios hilos, mientras que la parte serial debe continuar
ejecutándose secuencialmente. La parte serial limita el speedup máximo que
puede alcanzar un programa.

**Ley de Amdahl:** Describe cómo la parte serial de un programa limita la
aceleración que puede obtenerse mediante paralelismo. Aunque se agreguen muchos
hilos, si una parte importante del programa es serial, llegará un punto donde
agregar más recursos producirá muy poca mejora.


**Overhead (Sobrecarga):** Es el trabajo adicional necesario para utilizar el
paralelismo. Incluye costos como crear y administrar hilos, sincronizarlos,
realizar barreras y reducciones, y distribuir el trabajo. Si el trabajo que
realiza cada hilo es pequeño, el overhead puede ser mayor que el beneficio de
paralelizar.




</div>