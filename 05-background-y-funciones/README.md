# Background y funciones

## Background

Cuando ejecutamos un comando la ejecución se frena hasta que éste haya finalizado.

Por ejemplo

```bash
$ sleep 5
$ echo "tardé 5 segundos"
tardé 5 segundos
```

Cuando el comando corre así se dice que está en _foreground_. En contraste se puede ejecutar en
_background_ agregado un _&_ al final de la línea.

```bash
$ sleep 5 &
[1] 19108
$ echo "tardé 5 segundos"
tardé 5 segundos
```

En este caso el sleep devolvió el control inmediatamente y siguió corriendo sin frenar la
ejecución.

### Reanudar

Si iniciamos un programa en _foreground_ y queremos mandarlo a _background_ se puede hacer con
CTRL+Z. Esto lo va a frenar también. Para reanudarlo se puede ejecutar `bg`. Para devolverlo a
_foreground_, `fg`.

```bash
$ sleep 5
^Z
[1]+  Stopped                 sleep 5
$ bg
[1]+ sleep 5 &
$ fg
sleep 5
$
```

### Listar

Podemos ver la lista de procesos que estamos corriendo en _background_ con `jobs`. Si tenemos más
de uno nos da un índice para referenciarlos en `fg` y `bg`.

```bash
$ sleep 20
^Z
[1]+  Stopped                 sleep 20
$ sleep 30
^Z
[2]+  Stopped                 sleep 30
$ jobs
[1]-  Stopped                 sleep 20
[2]+  Stopped                 sleep 30
$ bg 2
[2]+ sleep 30 &
$ fg 1
sleep 20
$ jobs
[2]+  Running                 sleep 30 &
$ fg
sleep 30
$
```

### Desheredar

Estos procesos están asociados a la terminal que estamos corriendo, así que si la cerramos se
terminan. Con `disown` podemos "desheredar" un trabajo que está en background.

```bash
$ sleep 30 &
[1] 19327
$ disown
$ jobs
$
```

### PID

Si iniciamos un proceso en background podemos ver su PID si en la línea inmediatamente siguiente
leemos la constante `$!`.

```bash
$ sleep 30 &
[1] 19419
$ pid=$!
$ ps axu |grep $pid
sebasti+ 19419  0.0  0.0   9808   704 pts/19   S    12:39   0:00 sleep 30
sebasti+ 19426  0.0  0.0  16744   972 pts/19   S+   12:39   0:00 grep --color=auto 19419
```

## Funciones

Podemos agrupar comandos en funciones.

```bash
#!/bin/bash
set -euo pipefail
function hello_world() {
    echo "Hello world!"
}
hello_world
```

### Local vs global

Para declarar variables locales hay que anteponer la _keyword_ `local`, sino son globales.

```bash
#!/bin/bash
set -euo pipefail
function set_vars() {
    foo=1
    local bar=2
}
echo ${foo:-0} # 0
echo ${bar:-0} # 0
set_vars
echo ${foo:-0} # 1
echo ${bar:-0} # 0
```

### Retorno

El valor de retorno de una función es equivalente al valor de retorno de un programa, o sea que sólo
puede ser un número de 0 a 255 e indica 0 para éxito.

```bash
#!/bin/bash
set -euo pipefail

function returnsomething() {
    return 0
}
function returnsomethingelse() {
    return 1
}
returnsomething
returnsomethingelse
echo "unreachable" # como la línea anterior devolvió un código de error el script terminó
```

### Parámetros

Los parámetros de una función funcionan como los de un script: `$#` para la cantidad, `$0` para el
nombre de la función, `$1` para el primer argumento...

```bash
#!/bin/bash
set -euo pipefail

function print_first() {
    echo ${1:-}
}
print_first first second third
```

# Tarea

## Hacer un service manager simplificado

Un service manager se encarga de iniciar, detener y mostrar el estado de distintos servicios. En
Ubuntu por ejemplo viene uno que podemos ver con comandos como `service networking status`.

Cada ejecutable del directorio `services` es un programa que queremos ofrecer como servicio. La idea
es crear un programa `service` que se encargue de manejar estos servicios. Cada servicio puede
estar corriendo o no en un momento, y desde `service` se debe poder frenar o iniciar
respectivamente.

### `service --help`

Ayuda de cómo usar este programa

```bash
$ ./service --help
usage: ./service <service> [start|stop|status]
usage: ./service list
$
```

### `service list`

Tiene que mostrar una lista de servicios disponibles

```bash
$ ./service list
service: connection-checker
service: home-web-server
service: vpn-checker
$
```

### `service <service> status`

Muestra si un programa está corriendo o no

```bash
$ ./service vpn-checker status
vpn-checker is not running
$
```
o

```bash
$ ./service vpn-checker status
vpn-checker is running
$
```

### `service <service> start`

Inicia el servicio. Guarda el PID en `/tmp/services-$service.pid`. Guarda el standard output del
programa en `/var/log/services/$service.out` y el standard error en
`/var/log/services/$service.err`.

```bash
$ ./service vpn-checker start
vpn-checker started
```

### `service <service> stop`

Frena el servicio. Borra el _pidfile_.

```bash
$ ./service vpn-checker stop
vpn-checker stopped
```

### Casos inesperados

#### Parámetros incorrectos

Si el nombre del servicio o los parámetros no corresponden hay que mostrar un mensaje de error
indicando el problema y salir con un código de error.

#### PID apunta a un proceso que no existe

El PID del PID file puede no existir más (por ejemplo si el proceso se termino). En ese caso el
estado debería ser detenido.

#### Proceso no arranca

Si se inicia el servicio pero el programa sale inmediatamente hay que mostrarlo cuando se quiere
arrancar.

```bash
$ ./service bad-service start
bad-service failed to start
```

#### Proceso no se detiene

Para detener un proceso se manda una señal `TERM` que le indica que salga. El programa puede no
salir, en ese caso se puede mandar una señal `KILL` que fuerza a salir.

```bash
$ time ./service unstoppable stop
unstoppable stopped
./service unstoppable stop  0,11s user 0,25s system 14% cpu 2,571 total
```

No se ve cómo salió pero sí que tardó. Los primeros dos segundos fueron esperando que la señal
`TERM` haga salir al programa, después de un tiempo le mandamos un `KILL`.
