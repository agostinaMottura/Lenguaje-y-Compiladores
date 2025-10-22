# ToDo
## Analizador Semantico
Supuestamente, es todo lo que tenga que ver con insertar simbolos a la tabla, tipos de datos, etc.
Eso nosotros lo hicimos desde el Sintactico, al reconocer un NoTerminal
### Dudas
Deberiamos de agregar los tipos de dato de cada identificador?

[] Armar las funciones del Analizador Sintactico

## Generador de Codigo Intermedio
[] Tener un puntero por cada NoTerminal
[] Preparar las dos rutinas que se asocian a cada regla
    - crear_nodo()
    - crear_hoja()

## Correcciones 2da entrega (Fede)
asginaciones:
-------------

* Para 99. guarda 99 y lo reconoce como entero -> debería guardar 99.0 y reconocerlo como flotante
* Para .9999 guarda 9999 y lo reconoce como entero -> debería guardar 0.9999 y reconocerlo como flotante
* Si "a" es float no debería dejar que se le asigne un tipo de dato int [A revisar]

condiciones-lógicas:
--------------------

* En el caso:
	[9]   (a, __, __)
	[10]   (b, __, __)
	[11]   (CMP, [10], [9])
	[12]   (BLE, __, [19])
Está al revés el orden de comparación, el terceto [11] debería ser (CMP, [9], [10]) porque la comparación es a-b no b-a -> se repite en todas las comparaciones
Además, el salto debería estar pegado al comparador en el [12] -> (BLE,[19],_)

* En el caso:
	[25]   (a, __, __)
	[26]   (b, __, __)
	[27]   (CMP, [26], [25])
	[28]   (BLE, [33], [29])
Creo que el [29] en la última parte del terceto [28] está mal (no debería estar) -> Se repite en todas las primeras condiciones cuando hay un OR

Archivos repetidos:
-------------------

Me parece que el archivo if-and-or.txt está repetido con respecto al condiciones-lógicas.txt (validan los mismos casos)
Lo mismo con el archivo if.txt, lo venimos probando en todo el resto de ifs (if-and-or.txt, if-anidados.txt, if-else.txt e if-not.txt)

Mensaje por consola:
--------------------

	[GCI_TERCETOS] Lista de tercetos vacia - no se genera archivo
	[GCI_TERCETOS] Lista de tercetos creada correctamente
Si no me acuerdo mal Facu dijo que cambio las listas por pilas, si es así cambiar el mensaje

Tabla de símbolos:
------------------

Cuando guardamos una variable, se guarda con su longitud en 2 porque la columna "Valor" la completamos con __ -> Está contando los 2 guiones bajos -> No debería tener ningún valor en longitud

isZero:
-------

Me parece que está mal desarrollada porque nosotros guardamos isZero y eso en assembler no tiene traducción, yo lo que haría sería guardar toda la expresión dentro de isZero enm un terceto [1], guardar un 0 en otro terceto [2] y después comparar por si son iguales [3] (CMP, [1], [2]) Y [4] (BNE, Salto, _) -> Lo terminas tratando como un if que compara una expresión con 0

operaciones-aritméticas:
------------------------

Ver el tema de las asignaciones para tipos distintos

triangleAreaMaximum:
-------------------

Me parece que pasa lo mismo que en isZero, escribimos triangleAreaMaximum en el terceto pero no lo resolvemos -> a assembler ya tiene que llegar la lógica de la función resuelta

General:
--------

Por lo que vimos en la clase de hoy me parece que cuando escribe una cte en el terceto, tiene que escribir _cte, no cte directamente [Detalle]