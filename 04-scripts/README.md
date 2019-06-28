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
