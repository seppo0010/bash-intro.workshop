# Utilitarios

Las comandos built-in y los programas comunes de UNIX son una parte fundamental para poder usar
bash. Algunas ya aparecieron: `cat`, `grep`, `wc`, `ls`, `head`, `tr`.

## `man` y `--help`

Se acostumbra que los comandos traigan ayuda al agregarle el parámetro `--help`, por ejemplo
`grep --help`. Para más información se puede acceder al manual con `man grep`.

## Archivos

### `find`

Sirve para encontrar archivos o directorios, en general por nombre. Por ejemplo
`find . -name 0\* -type f` va a encontrar todos los archivos que estén en este directorio o sus
subdirectorios y empiecen por 0.

### `df`

Muestra las distintas particiones montadas, cuánto espacio libre y ocupado tienen. Con `-h` usa
unidades "leíbles por humanos" como kilo, mega,
giga

### `du`

Lista todos los archivos y directorios en este directorio recursivamente y cuánto ocupan. Con `-s`
da sólo el resumen del directorio. A diferencia de `df` esto puede tardar porque hace la suma
archivo por archivo.


## Texto

### `tail`

Así como `head`, `tail` lee las últimas líneas o bytes de un archivo. Usando `tail -f` el archivo
permanece abierto y si se le agrega información va a ir apareciendo.

```bash
$ for i in {1..10}; do echo $i >> file; done
$ tail -n 3 file
8
9
10
$
```

```bash
$ tail -n 3 -f file
8
9
10
```

En este caso el proceso no concluye. Si en otra terminal ejecutamos `echo 11 >> file` vamos a ver
cómo se agrega la nueva línea.

### `sort`

Ordena las líneas recibida alfabéticamente.

```bash
$ rm -f file; for i in {1..20}; do echo $i >> file; done
$ sort file
1
10
11
12
13
14
15
16
17
18
19
2
20
3
4
5
6
7
8
9
```

También se puede hacer comparaciones numéricas

```bash
$ sort -n file
1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
16
17
18
19
20
```

### `uniq`

Sirve para deduplicar líneas consecutivas.

```bash
$ rm -f file; for i in {1..3}; do echo $i >> file; echo $i >> file; done
$ cat file
1
1
2
2
3
3
$ uniq file
1
2
3
```

También se puede usar `uniq -c` para contar la cantidad de repeticiones.

```bash
$ rm -f file; for i in {1..3}; do echo $i >> file; echo $i >> file; done
$ uniq -c file
      2 1
      2 2
      2 3
```

### `awk`

Gawk es un lenguaje de programación pero en general en Bash se lo usa para extraer una columna de
un csv.

Por ejemplo

```bash
$ printf "1 2 3 4\n5 6 7 8\n9 10 11 12\n" |awk '{ print $3 }'
3
7
11
```

## Procesos

### `top`

`top` muestra los procesos activos que más recursos están consumiendo y el estado de los recursos
en general. Permite reconocer qué está pasando a simple vista si algo no anda bien.

### `ps`

Permite ver la lista de procesos corriendo de forma no interactiva. En general se usa con varios
parámetros como `ps aux`. Cada proceso tiene un PID que es un identificador único en el sistema
operativo

### `kill`

`kill` le manda una señal a un proceso identificador por PID. Por defecto la señal es de que salga
pero se pueden mandar otras.

# Tarea

## Contar ocurrencias de palabras

Buscar cuáles son las cinco palabras que aparecen más veces en el Zen de Python.

## Contar la cantidad de archivos en un directorio

Mostrar cuántos archivos salen de un directorio incluyendo subdirectorios.
Por ejemplo

```bash
$ mkdir a
$ mkdir a/b
$ echo "" > a/b/c
$ echo "" > a/b/d
$ mkdir e
$ echo "" > e/f
$ echo "" > e/g
$ echo "" > e/h
```

En este caso debería mostrar 2 para `a` y 3 para `e`.
