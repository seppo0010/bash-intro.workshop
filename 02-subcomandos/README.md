# Subcomandos, entrada, salida

## Pipe

Cuando ejecutamos una sentencia en bash podemos usar la salida de un comando como entrada de
otro.

Por ejemplo podemos invocar `wc`, un comando que cuenta la cantidad de líneas, palabras y y bytes,
con "hello world"

```bash
$ echo hello world |wc
      1       2      12
```

El pipe (`|`) agarra la salida del comando de la izquierda y la usa como entrada del comando de la
derecha. También se puede encadenar

```bash
$ echo hello world |wc |wc
      1       3      24
```

En este caso está mostrando que la salida del primer `wc` tiene 24 bytes en 3 palabras (1, 2 y 12).

## Redirigir salida

Se puede hacer que bash guarde la salida de un programa directamente en un archivo. Con `cat`
podemos leer el contenido de un archivo.

```bash
$ echo "Hello world" > myfile
$ cat myfile
Hello world
```

### _append_

Si ponemos un solo `>` el archivo se vacía al invocarlo, pero si se usa `>>` no sino que agrega al
final.

```bash
$ echo "1" > myfile
$ echo "2" >> myfile
$ echo "3" >> myfile
$ cat myfile
1
2
3
```

### `/dev/null`

Hay un archivo especial en sistemas UNIX que es `/dev/null` que es un archivo que siempre está
vacío y escribir en él no hace nada. Se usa cuando uno quiere descartar la salida del programa.

### `/dev/urandom`

Otro archivo especial es `/dev/urandom` que genera contenido aleatorio constantemente. Si bien es
un archivo, es un archivo que cada vez que se lee genera distintos datos infinitamente.

## stdout, stderr

Cuando hablamos de la salida de un programa en realidad hablabamos del `stdout`, pero el mismo
programa también puede escribir cosas en otra salida llamada `stderr`. Esta última se usa para
notificar de cosas que no son la respuesta en sí. Por ejemplo al ejecutar `ls <path>` esperamos
ver el contenido del archivo o directorio en `<path>`, pero si éste no existe vemos un mensaje
que nos avisa de esto. Si esto fuese interpretado como la salida del programa, podríamos cometer
un error en nuestro código.

Ejemplo:

```bash
$ ls 02-subcomandos/README.md 
02-subcomandos/README.md
$ ls 02-subcomandos/no-existo 
ls: cannot access '02-subcomandos/no-existo': No such file or directory
$ ls 02-subcomandos/README.md > /dev/null 
$ ls 02-subcomandos/no-existo > /dev/null 
ls: cannot access '02-subcomandos/no-existo': No such file or directory
```

Vemos que aún habiendo redirigido la salida de `ls` recibimos el mensaje de error correspondiente.
De la misma forma si pasamos el resultado de este `ls` por `wc` va a decir que estaba vacío.

## stdin

Como tenemos estas dos salidas también tenemos la entrada. Ya escribimos en eso usando pipes antes,
pero también podemos escribir en ella desde un archivo usando `<`

```bash
wc < 02-subcomandos/README.md 
  86  428 2543
```

## Código de salida

Cuando un programa termina de ejecutarse pudo haber concluído con éxito o no. Esto se indica por
un código de salida que podemos acceder usando `$?` inmediatamente después del comando.

```bash
$ ls 02-subcomandos/README.md > /dev/null 
$ echo $?
0
$ ls 02-subcomandos/no-existo > /dev/null
ls: cannot access '02-subcomandos/no-existo': No such file or directory
$ echo $?
2
```

Un código 0 indica éxito. Uno distinto a 0 indica fallo. Cada comando establece el significado de
los distintos valores posibles.

Los condicionales que usamos en el if en realidad usan esto para evaluar.

```bash
$ [ 1 == 1 ]
$ echo $?
0
$ [ 1 == 2 ]
$ echo $?
1
```

Entonces podemos usar cualquier comando para ver si tiene éxito como condición en un `if`. Por
ejemplo si queremos ver si un archivo contiene una cadena:

```bash
$ if grep -q "cadena" README.md; then echo "contiene!"; fi
```

Acá usamos `grep` que devuelve 0 sólo si se encuentra la cadena en el archivo.

# Tarea

## Contar palabras

Contar cuántas palabras hay en el Zen de Python, que se obtiene al ejecutar
`python -m this`. Si queremos ver la cantidad de palabras podemos usar `wc -w`,
para cantidad de líneas `wc -l`; más información en `man wc`.

## Pasar el zen a mayúsculas

Volver a obtener el Zen de Python y pasarlo completamente a mayúsculas.

## Hashear una cadena aleatoria

Leer 60 bytes aleatorios y calcular el sha1. Usar `head` y `sha1sum`.

## Mostrar la hora aleatoriamente

Cada un segundo mostrar la hora actual con un 50% de probabilidad.
`while true; do statements; done` se puede hacer un loop infinito. Con `date` se puede imprimir la
fecha. La variable `RANDOM` tiene un valor diferente cada vez que se lee en el rango de 0 a 32767.
Para que sea sólo una vez por segundo se puede usar la función `sleep`.

[Siguiente](../03-utilitarios)
