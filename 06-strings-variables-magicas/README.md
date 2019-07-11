# Strings, variables mágicas y archivos especiales

## Strings

Se pueden hacer ciertas modificaciones sencillas de texto.

### Medir longitud

```bash
$ myvar="hello world"
$ echo ${#myvar}
11
$
```

### Obtener una subcadena por índices

```bash
$ echo ${myvar:3:6}
lo wor
$ echo ${myvar:(-5)}
world
$
```

### Sustitución

```bash
$ myvar="hello world"
$ echo ${myvar/o/a}
hella world
$ echo ${myvar//o/a}
hella warld
$
```

### Expresiones regulares

```bash
$ expr "hello world" : '.*\(w.\+l\).*'
worl
$ expr "hello world" : '.*\(.\+o\)'
wo
$ expr "hello world" : '\(.\+o\)'
hello wo
$
```

## Variables mágicas

Ya vimos algunas variables mágicas antes, como `$1` y `$RANDOM`. Hay otras globales importantes
de conocer.

### `$HOME`

El usuario activo tiene que tener un directorio _home_. Esta variable contiene la ruta absoluta.

### `$USER`

Nombre del usuario activo.

### `$PWD`

Ruta en la cual el usuario está al ejecutar este comando. Esto no necesariamente es la ruta
donde está en archivo.

```bash
$ echo 'echo $PWD' > testing
$ chmod a+x testing
$ ./testing
/home/sebastianwaisbrot/Projects/bash-intro.workshop
$ mv testing test/
$ ./test/testing
/home/sebastianwaisbrot/Projects/bash-intro.workshop
$ cd test/
$ ./testing
/home/sebastianwaisbrot/Projects/bash-intro.workshop/test
$
```

### `$PATH`

Lista de directorios separados por `:` donde se buscan los comandos cada vez que queremos ejecutar
algo. O sea, cada vez que ejecutamos algo en bash, éste busca en cada uno de estos directorios
un archivo ejecutable con ese nombre para invocarlo.

```
$ ls
file2  testing
$ echo 'echo lol' > ls
$ chmod a+x ls
$ export PATH="$PWD:$PATH" # agrego el directorio actual a $PATH
$ ls
lol
$ /bin/ls
file2  ls  testing
$
```

## Archivos especiales

### `$HOME/.profile`

Este archivo se ejecuta cuando se inicia un nuevo shell. Suele contener cambios en variables de
entorno, como agregar directorios a `$PATH`.

### `$HOME/.bashrc`

Este archivo se ejecuta cuando se inicia un subshell. Las variables de entorno son heredadas así
que si fueron agregadas en `.profile` no es necesario hacerlo acá. Los aliases no se copian
así que hay que agregarlos en este script.
