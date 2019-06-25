# Flujo de control, variables y matemática

Antes de empezar vamos a poner como convención la nomeclatura

```bash
$ echo Hello world
Hello world
$
```

Como convención las líneas que empiezan con `$` son comandos que se introducen (siendo `$` el
"prompt" del usuario) y las que le siguen la salida del comando. También si en algún momento se usa
`#` en vez de `$` estamos hablando de un prompt de `root`, el super usuario de la computadora.

`echo` es un comando de Bash para recibir argumentos (que aparecen en la misma línea, en el ejemplo
"Hello world") y escribir en la salida del programa los mismos argumentos.

## Variables

Para definir una variable hay que poner `variable=valor` sin espacios. Después si queremos ver el
valor de esa variable usamos `$variable`.

```bash
$ salute=Hello
$ echo $salute world
Hello world
```

Las variables siempre son strings (excepto los arrays, que son usados raramente) entonces
`var=Hello` y `var="Hello"` son equivalentes.

Si queremos que el valor tenga espacios necesitamos obligatoriamente usar comillas, sino son
opcionales.

Por defecto cualquier variable que querramos usar que no tenga ningún valor va a contener un valor
vacío.

### `export`

Algunas veces vamos a ver que antes de asignar un valor a una variable se antepone la palabra
`export`. Esto permite que la variable se propague hacia los subprocesos. El concepto de subproceso
lo vamos a ver más en detalle luego.

```bash
$ salute_noexport=hello
$ bash -c 'echo $salute_noexport'

$ export salute_export=hello
$ bash -c 'echo $salute_export'
hello
```

## `if`

Para ejecutar sentencias en ciertas condiciones se usa `if cond; then statments; fi`. El `;` marca
el final de una sentencia al igual que un salto de línea.

Por ejemplo.

```bash
$ value=3
$ if [ $value == 3 ]; then echo "el valor es tres"; fi
```

```bash
$ value=3
$ if [ $value == 3 ]; then echo "el valor es tres"; else echo "el valor no es tres"; fi
el valor es tres
$ value=4
$ if [ $value == 3 ]; then echo "el valor es tres"; else echo "el valor no es tres"; fi
el valor no es tres
```

También podemos ver si un valor es mayor que otro pero hay que tener cuidado porque como los
valores siempre son strings se lo compara alfabéticamente

```bash
$ if [ 20 -gt 3 ]; then echo "20 > 3"; fi
20 > 3
```

También se puede comparar inequidad (`!=`), mayor o igual (`-ge`), menor (`-lt`), menor o igual
(`-le`). Muchas más opciones están disponibles, se pueden ver ejecutando `man [`.

### Múltiples condiciones

Se puede usar `and` y `or` para evaluar múltiples condiciones. En ese caso, cada una tiene que
estar entre corchetes.

```bash
$ if [ 20 -gt 3 ] && [ 4 == 4 ] || [ 5 == 4 ]; then echo "20 > 3 && 4 == 4 || 5 == 5"; fi
20 > 3 && 4 == 4
```

Para agrupar términos se pueden usar paréntesis.

```bash
$ if [ 4 == 4 ] && ( [ 3 == 3 ] || [ 5 == 4 ] ); then echo OK; fi
OK
$ if [ 4 == 4 ] && ( [ 3 == 2 ] || [ 5 == 4 ] ); then echo OK; fi
```
