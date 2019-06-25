# Intro a bash

Bash es un lenguaje de programación atípico. Sí, es un lenguaje de programación. Su fortaleza está
en invocar distintos programas y hacer que interoperen entre ellos.

Además viene con un conjunto de herramientas para estos casos de uso que son muy convenientes.

Un ejemplo, sacado de [Quora](https://www.quora.com/Is-learning-bash-programming-valuable), ilustra
estos beneficios:

Si queremos buscar las 10 palabras más comunes en un archivo de texto, la solución en Python podría
ser algo así

```python
from collections import defaultdict
from string import punctuation

wordcount = defaultdict(int)

for line in open('hamlet.txt'):
    line = ''.join([char for char in line.lower()
                   if char not in punctuation])
    for word in line.split():
        wordcount[word] += 1

for key in sorted(wordcount, key=wordcount.get, reverse=True)[:10]:
    print(key, wordcount[key])
```

La solución en bash por otro lado

```bash
tr A-Z a-z < hamlet.txt | tr -sc a-z '\n' | sort | uniq -c | sort -rn | head
```

Por supuesto es más legible, aún sin saber Python, la primera respuesta que la segunda pero se ve
que esta última es bastante más concisa.
