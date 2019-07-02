# Script files

Bash se puede usar de forma interactiva con la consola, pero también se usan archivos con los
comandos.

## shebang

Estos archivos _tienen_ que empezar con `#!` seguido por el comando con el cual se puede
interpretar, en general `#!/bin/bash` o `#!/usr/bin/env bash`. Cualquier programa que interprete
programas puede ser usado, entonces si el archivo empieza por ejemplo con `#!/usr/bin/env python`
al ejecutar el archivo se va a invocar python.

## Permisos

Para poder ejecutar un programa el archivo tiene que tener permisos de ejecución. Cada archivo en
sistemas tipo UNIX tiene permisos asociados. Los permisos pueden ser de ejecución, lectura, y
escritura, y pueden ser otorgados al dueño del archivo, al grupo dueño del archivo o a los demás.
Esto se suele resumir en tres números del 0 al 7 inclusive.

Para ver los permisos de un archivo podemos usar `ls -l`

```bash
$ touch file
$ chmod 000 file
$ ls -l file 
---------- 1 sebastianwaisbrot sebastianwaisbrot 0 jun 27 15:18 file
```

Acá le sacamos todos los permisos, por eso los guiones a la izquierda. Y después vemos el dueño,
el grupo duseño, el tamaño, fecha de última modificación y nombre.

Si queremos agregarle un permiso podemos darselo al usuario (_u_), al grupo (_g_) o a los otros
(_o_), y el permiso puede ser de lectura (_r_), escritura (_w_) o ejecución (_x_).


```bash
$ chmod ug+rw file
$ chmod u+x file
$ ls -l file
-rwxrw---- 1 sebastianwaisbrot sebastianwaisbrot 0 jun 27 15:18 file
```

En este caso le dimos permiso de lectura y escritura al usuario y al grupo, y de ejecución sólo al
usuario.

Una vez que el archivo tiene su shebang y permisos, se puede ejecutar con `./myscript`. Por
convención los nombres de archivos bash suelen terminar en `.sh` pero no es necesario.

### `sudo`

Algunos comandos requieren permisos de _superusuario_ para correr. Si corren así pueden hacer
_cualquier cosa_ en el sistema: abrir servidores en puertos privilegiados (como el 80 o 443),
modificar archivos de configuración de otros programas, modificar el sistema operativo, ver y
cambiar archivos de otros usuarios del mismo sistema.

Por ejemplo si quiero empezar un servidor web en el puerto 80 no voy a poder sin sudo

```bash
$ python -m SimpleHTTPServer 80
Traceback (most recent call last):
...
socket.error: [Errno 13] Permission denied
$ sudo python -m SimpleHTTPServer 80
[sudo] password for sebastianwaisbrot:
Serving HTTP on 0.0.0.0 port 80 ...
```

Ahora bien, si cuando recibimos un `Permission denied` agregamos `sudo` puede que el comando se
ejecute con éxito pero si el problema podía ser resuelto sin eso quizás era mejor, porque por
ejemplo el dueño de cualquier archivo creado usando `sudo` va a ser `root` y no nuestro usuario.

Idealmente cuando pase esto hay que entender qué es lo que quiso hacer el programa, por qué
necesitaba permisos especiales y pensar en base a eso cuál es la mejor solución.

## Parámetros

Cuando se invoca al script se le pueden pasar parámetros, por ejemplo `./myscript test`. Estos
aparece en algunas variables mágicas: `$0` es el nombre del archivo ejecutado, `$1` el primer
parámetro, `$2` el segundo, etc. También `$#` es la cantidad de parámetros recibidos y `$*` son
todos los parámetros (equivalente a `$1 $2 $3 $4...`).

```bash
$ echo 'echo "cantidad de argumentos: $#";printf "longitud del primer argumento: "; echo -n $1|wc -c' > myscript
$ chmod a+x myscript
$ ./myscript hello
cantidad de argumentos: 1
longitud del primer argumento: 5
$ ./myscript hello world
cantidad de argumentos: 2
longitud del primer argumento: 5
```

## `set`

El manejo de errores en bash es peculiar. No hay excepciones y depende mucho del _exit status_ de
cada invocación. Por defecto los errores se ignoran y hay que chequearlo cada vez, o cambiar ciertas
opciones para simplificarlo.

### `set -e`

Por defecto un script va a correr hasta el final, independientemente de si algún comando falle. En
general, si algo falla puede hacer que lo que siga no funcione o peor aún funcione incorrectamente.
Por ejemplo, si cambiamos de directorio (`cd`) y después queremos borrar algún directorio de ahí
(`rm -rf <directory>`), si el primer comando falló, por ejemplo si el directorio no existe, el
segundo comando puede borrar un directorio de otro lugar, una acción destructiva no reversible.

Para evitar estos errores se puede configurar al archivo para que falle frente al primer fallo.

```bash
#!/bin/bash
set -e # sin esta linea, `expected-dir` sería borrado en este directorio si cd falló
cd non-existent-directory
rm -rf expected-dir
```

### `set -o pipefail`

Algo parecido pasa con los pipes. Si hacemos `cmd1 |cmd2` y `cmd1` falla el error se pierde.

```bash
$ cat test 
#!/bin/bash
set -e
ls non-existant|cat
echo "todo bien"
$ ./test 
ls: cannot access 'non-existant': No such file or directory
todo bien
```

```bash
$ cat test 
#!/bin/bash
set -e
set -o pipefail
ls non-existant|cat
echo "todo bien"
$ ./test 
ls: cannot access 'non-existant': No such file or directory
```

### `set -u`

Si usamos una variable no definida por defecto va a ser reemplazada por un valor vacío. A veces esto
está bien pero a veces no, especialmente si metimos un typo en el nombre de la variable :).
Entonces se puede hacer que el script falle si se usa una variable no definida.

```bash
$ cat test 
#!/bin/bash
set -eo pipefail
echo $myvar
$ ./test 

$ echo $?
0
```

```bash
$ cat test 
#!/bin/bash
set -euo pipefail
echo $myvar
$ ./test 
./test: line 3: myvar: unbound variable
$ echo $?
1
```

Si queremos usar una variable que puede no estar definida podemos usar `${myvar:-default}`. Por
ejemplo

```bash
$ cat test 
#!/bin/bash
set -euo pipefail
echo ${myvar:-hello world}
$ ./test 
hello world
$ echo $?
0
```

```bash
$ cat test 
#!/bin/bash
set -euo pipefail
myvar="foo"
echo ${myvar:-hello world}
$ ./test 
foo
$ echo $?
0
```

# Tarea

