## Laboratorio 2 — Aceleración mediante vectorización SIMD con AVX2

### Objetivo

Comparar el rendimiento de una multiplicación de matrices utilizando una implementación escalar y una implementación vectorizada mediante instrucciones SIMD con AVX2.

Se utilizaron matrices de tamaño `1024 × 1024`. La versión escalar procesa los elementos individualmente, mientras que la versión AVX2 utiliza registros de 256 bits para operar sobre grupos de 8 valores `float` de 32 bits.

### Resultados

| Implementación | Tiempo (s) | Rendimiento (GFLOP/s) |
| -------------- | ---------: | --------------------: |
| Escalar        |   1.242651 |              1.728147 |
| AVX2           |   0.320768 |              6.694815 |

Ambas implementaciones produjeron el mismo resultado:

* **Checksum:** `10871481693.000000`
* **C[0][0]:** `13391.250000`
* **C[1023][1023]:** `13403.250000`

El *speedup* obtenido fue:

$$
S = \frac{T_{\text{escalar}}}{T_{\text{AVX2}}}
= \frac{1.242651}{0.320768}
\approx 3.87
$$

Por lo que para esta ejecución la implementación vectorizada fue aproximadamente **3.87 veces más rápida** que la implementación escalar.

### Análisis

AVX2 permite trabajar con registros vectoriales de 256 bits. Debido a que cada valor `float` ocupa 32 bits, un registro puede contener hasta 8 valores:
$$
\frac{256}{32}=8
$$
Esto permite realizar una misma operación sobre varios elementos simultáneamente mediante SIMD (*Single Instruction, Multiple Data*).

Sin embargo, procesar 8 valores mediante una instrucción vectorial **no implica obtener un speedup de 8× en el programa completo**. La multiplicación de matrices también requiere otras operaciones, como carga de datos desde memoria, reducción de los resultados parciales, transposición de la matriz y control de los ciclos. Estas operaciones también consumen tiempo y limitan la aceleración total obtenida.

En la medición realizada se obtuvo un speedup de aproximadamente **3.87×**, mostrando una mejora significativa en el rendimiento mediante el uso de instrucciones SIMD con AVX2.
