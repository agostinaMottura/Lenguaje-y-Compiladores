# Mejoras
[] Tabla de Simbolos
    [] Crear un define con el nombre de la tabla de simbolos
    [] Crear una funcion privada para que escriba la fila de una tabla
[] El Sintactico no debe acceder a la Tabla de Simbolos, lo debe hacer el Lexico y el GCI
[] Separar el `main.c` del archivo `Sintactico.y`
    -> Dejar solo en el `Sintactico.y` las reglas gramaticales (elementos no terminales)

> Estas mejoras son secundarias, no hacen tanta falta.

[] Parametrizar todos los elementos terminales y no terminales
    -> Tener un archivo con los macros de cada terminal y no terminal
    
[] Hacer un script que funcione para hacer CI/CD y que se pueda validar de forma facil si no
estamos obteniendo algun resultado esperado en los tests.