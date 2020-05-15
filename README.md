## Calculadora em linha de entrada de comando

### Descrição:

Uma calculadora que implementa funções aritméticas simples e também as funções SQRT, E^x, M+, M-, MC e MR. Aceita parênteses e números em notação científica. O programa implementa uma calculadora que efetua expressões matemáticas simples.

Este foi um trabalho de conclusão da disciplina MC101 (Laboratório de Introdução à Programação) que abordava desenvolvimento e implementação de programas com a linguagem Pascal.

### Operação do Programa:

O usuário deve fornecer uma expressão matemática, podendo usar os quatro operadores básicos como "+" (soma),"-" (subtração),"*" (multiplicação),e "/" (divisão), poderá usar também os cálculos de raiz quadrada e função exponencial de base "e", usando SQRT x (para raiz quadrada de x) e E^x (para a constante e elevada a potência x). Não é necessário digitar letras maiúsculas, já que o programa interpreta as duas situações possíveis.

É possível usar também os parêntesis, "(" e ")", em até seis níveis de aninhamento. Caso o nível seja ultrapassado, um aviso de erro será apresentado. Também será necessário, antes de abrir um parêntesis ou depois que fechar, colocar um dos quatro operadores básicos.

E no final, para efetuar os cálculos, será necessário digitar "=" (igual), e então a expressão matemática será resolvida, aparecendo o resultado na saída. Caso a expressão tenha algum erro de sintaxe, será retornado um aviso e a posição em que ocorreu o erro. Se não houver nenhuma expressão para ser efetuada será retornado um aviso de erro.

Além das teclas válidas para o cálculo da expressão, poderá ser digitados os seguintes símbolos sobre a linha de entrada de dados da calculadora:

C: este símbolo faz com que sejam ignorados todos os caracteres à esquerda deste ponto.
&lt;: este símbolo faz com que seja ignorado apenas o primeiro caractere à esquerda deste ponto, se não houver nenhum caractere à esquerda será retornado uma mensagem de erro.

A calculadora possui também uma memória, que poderá ser utilizada da seguinte forma:

M+: soma o resultado da expressão à esquerda do símbolo ao conteúdo atual da memória. Caso não haja nenhuma expressão, um aviso de erro será apresentado.
M-: subtrai o resultado da expressão à esquerda do símbolo ao conteúdo atual da memória. Caso não haja nenhuma expressão, um aviso de erro será apresentado.
MR:  mostra na saída o valor atual contido na memória. Caso possua alguma expressão digitada na entrada, o valor contido na memória será colocado junto na expressão, para poder ser utilizado em alguma operação.
MC: apaga  o valor contido na memória, armazenando lá o número zero.

Lembrando novamente que nenhuma letra precisará ser maiúscula.

Os espaços em branco digitados na entrada serão ignorados, como também qualquer caractere que não seja válido. Caso o usuário tecle &lt;enter&gt;, o cursor será posicionado no início da próxima linha, mantendo a leitura dos dados da entrada atual. A calculadora possui também prioridades nas operações, onde "*" e "/" tem prioridade sobre "+" e "-", caso as prioridades sejam iguais , a operação mais à esquerda é efetuada primeiro.

Na divisão e na função exponencial caso o divisor e a potência forem negativos será necessário isolá-los com parêntesis. Se, após a divisão, vier um sinal de menos, será necessário isolar a divisão com parêntesis.

Se acontecer uma divisão por zero ou raiz de número negativo, um aviso de erro será retornado.

Lembre-se, sempre colocar o mesmo número de parêntesis abrindo e fechando, senão um aviso de erro será retornado.

Os números digitados na entrada poderão estar em notação científica (ex: 3E2 = 300 ; 2.1E-1 = 0.21), e a vírgula dos números decimais deverá ser um ponto. Os valores apresentados nas saídas são mostrados na forma de número decimal, com três casas após a vírgula.

E finalmente, para interromper a execução do programa, basta apertar a tecla &lt;ESC&gt;, a qualquer momento.

### Referências:

- Farrer, H. et al. Pascal estruturado. Rio de Janeiro. Guanabara Dois, 1985.

- Gottfried, B.S. Programação em Pascal. Coleção Schaum. São Paulo. McGraw-Hill, 1988.

- Schildt, H. Turbo Pascal Avançado. McGraw-Hill, 1989.
