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

## Link simbólicos

En UNIX hay archivos especiales que son links simbólicos. Estos archivos no tienen un contenido
propio sino que redirigen a otro archivo. Se crean con `ln -s <target> <source>`

```bash
$ echo hello > file1 # creo file1
$ ln -s file1 file2 # creo file2 apuntando a file1
$ cat file2 # verifico que file2 apunta a file1
hello
$ ls -l # en ls aparecen vinculados
total 4
-rw-rw-r-- 1 sebastianwaisbrot sebastianwaisbrot 6 jul  4 12:21 file1
lrwxrwxrwx 1 sebastianwaisbrot sebastianwaisbrot 5 jul  4 12:21 file2 -> file1
$ echo helloooo >> file2 # escribir en file2 modifica file1
$ ls -l
total 4
-rw-rw-r-- 1 sebastianwaisbrot sebastianwaisbrot 15 jul  4 12:21 file1
lrwxrwxrwx 1 sebastianwaisbrot sebastianwaisbrot  5 jul  4 12:21 file2 -> file1
$ cat file1 # verifico que se escribió
hello
helloooo
$ rm file1
$ ls -l # aún habiendo borrado file1, file2 sigue existiendo apuntando a un archivo que ya no existe
total 0
lrwxrwxrwx 1 sebastianwaisbrot sebastianwaisbrot 5 jul  4 12:21 file2 -> file1
$ cat file2 # aunque file2 existe, como file1 no existe más, al tratar de leerlo dice que no existe
cat: file2: No such file or directory
```

## Subcomandos

Si queremos dentro de un script ejecutar un comando y guardar su salida se puede hacer usando
`$(subcommand)`. Por ejemplo

```bash
$ chars=$(echo hello|wc -c)
$ echo $chars
6
$ if [ $chars -gt 3 ]; then echo "longer than 3"; fi
longer than 3
```

## Expresiones regulares

Una expresión regular sirve para ver si un texto cumple con un formato determinado.
En esta página se pueden probar distintas opciones: https://regex101.com/r/AlxVE6/2

Se puede verificar si un valor cumple con una expresión regular usando esta forma
`[[ valor =~ regex ]]`.

```bash
$ if [[ hel.lo =~ ^[A-Za-z0-9]+$ ]]; then echo alphanumeric; fi
$ if [[ hello =~ ^[A-Za-z0-9]+$ ]]; then echo alphanumeric; fi
alphanumeric
```

# Tarea

## Cambiar comportamiento por nombre de script

Hacer un script que si se lo invoca como `fizz <num>` escriba "ok" si `num` es múltiplo de 3, si
se lo invoca como `buzz <num>` escriba "ok" si `num` es múltiplo de 5 y si se lo llama
`fizzbuzz <num>` escriba "ok" si es múltiplo de ambos 3 y 5. Tiene que ser un sólo script que cambie
su comportamiento según cómo se invoca.

```bash
$ ls -l
total 4
-rwxrwxr-x 1 sebastianwaisbrot sebastianwaisbrot 517 jul  4 12:57 00_fizzbuzz.sh
lrwxrwxrwx 1 sebastianwaisbrot sebastianwaisbrot  14 jul  4 12:36 buzz -> 00_fizzbuzz.sh
lrwxrwxrwx 1 sebastianwaisbrot sebastianwaisbrot  14 jul  4 12:36 fizz -> 00_fizzbuzz.sh
lrwxrwxrwx 1 sebastianwaisbrot sebastianwaisbrot  14 jul  4 12:37 fizzbuzz -> 00_fizzbuzz.sh
$ ./00_fizzbuzz.sh 1
usage: fizz <num>
usage: buzz <num>
usage: fizzbuzz <num>
$ ./fizz 3
OK
$ ./fizz 5
$ ./buzz 3
$ ./buzz 5
OK
```

## Servir el contenido del directorio actual en un puerto determinado

Se puede usar `python -m SimpleHTTPServer [port]` para servir el contenido del directorio actual
en un servidor web. Hacer un script que reciba un puerto opcionalmente y levante un servidor en
ese puerto. Si el puerto es menor a 1024 necesita `sudo` para correr. Por defecto debe correr en
el puerto 80.
