{*************************************}
{*                                   *}
{* Daniel Fernando Madeira RA 951752 *}
{* Turma MC101G                      *}
{* Calculadora versão 1.0            *}
{* Efetua expressões matemáticas     *}
{* Concluído em 30/10/95             *}
{*                                   *}
{*************************************}

program calculadora;

uses wincrt,strings;

type strgmaxima=string;

var  p,n:integer; {p -> posição do último caracter lido,n -> tamanho da formula}
     formula:string;{expressão digitada pelo usuario}
     resultado,memoria:real;
     error,divzero,raizneg,nipault:boolean; {indicações de erro}
     tecla:char; {tecla digitada}

{****************************************************************************}

procedure apresentacao;

begin
  writeln('CALCULADORA para IBM/PC versão 1.0 - Windows - 30/10/95');
  writeln('Feita por Daniel F. Madeira RA 951752. Versão Shareware!');
  writeln;
  writeln('Entre com a expressão e tecle "=" para resolvê-la.');
  writeln('Pressione <ESC> para sair!');
  writeln;
end;

{****************************************************************************}

procedure leitura; {Lê e calcula a expressão}

{***********************************************************************}

{Inicia o calculo}

function calcula_formula(var p:integer; strg:strgmaxima;
                         var error,divzero,raizneg,nipault:boolean):real;

var  r:real;{resultado parcial}
     i,poserro:integer;{poserro -> posição do erro}
     ch:char;{Último caracter lido}

{******************************************************************}

{Prepara a expressão para ser calculada e checa se houve algum erro}

procedure avalia(var formula:strgmaxima;
                 var valor:real;{resultado parcial}
                 var poserro:integer);

const numeros:set of char =['0'..'9','.'];

var  p,np:integer;{p -> posição do último caracter lido,np -> número de parentesis}
     ch:char;{Último caracter lido}

{*************************************************************}

procedure proximoch; {Lê o próximo caracter na formula indicando sua posição}

begin
  repeat
   p:=p+1;                                      {Caso já tenha chegado no}
   if p <= length(formula) then ch:=formula[p]  {final da string é assumido}
                                                {o caracter #13}
                           else ch:=#13;        
  until (ch<>' ');                              
end;                                            
                                                
{*************************************************************}

function efetua:real;{Inicia os cálculos}

var  e:real;{resultado de calculos não prioritarios}
     operador:char;{recebe o operador do cálculo atual}

{********************************************************}

function prioridade:real; {Efetua as prioridades}

var  s:real;{resultado das prioridades}
     operador:char;

{***************************************************}

function defsinal:real; {Define o sinal da prioridade}

{**********************************************}

function checach:real; {Checa se o último caracter lido é um número, um
                        parentesis que indica nova expressão, ou uma letra
                        que indica função padrão}

var  start:integer;{posição do primeiro caracter de um número dentro da string}
     f:real;{recebe o número, ou o resultado da nova expressão ou função padrão}

{*****************************************}

procedure processa_numero; {Lê o número dentro da string}

var code:integer;{posição do erro caso a substring não possa ser convertida
                  em número}
begin
  start:=p;
  repeat                             {Lê os próximos caracteres até que}
   proximoch;                        {não seja um número ou um dos dois}
  until not (ch in numeros);         {caracteres aceitos em número}
  if ch='.' then
      repeat                         {E finalmente converte a substring}
       proximoch;                    {do número encontrado para uma variável}
      until not (ch in numeros);     {do tipo real}
  if ch='E' then
      begin
        proximoch;
        repeat
         proximoch;
        until not (ch in numeros);
      end;
  val(copy(formula,start,p-start),f,code);
end;

{*****************************************}

procedure processa_nova_expressao;{Inicia novamente os cálculos para a nova
                                   expressão}

begin
  proximoch;                  {Lê o próximo caracter e efetua a nova }
  f:=efetua;                  {expressão, se o próximo caracter depois}
  if ch=')' then proximoch    {da nova expressão não for ')' é marcado}
            else poserro:=p;  {a posição do erro}
end;

{*****************************************}

procedure processa_funcao_padrao;{Calcula o valor das funções padrão}

{******************}

function EelevX(x:real):real;{Calcula a função de E elevado a X}

var t,st :real;{t -> valor do termo atual, st -> soma dos termos}
    k:integer;{contador dos termos}

begin
  if x < 0 then EelevX:=1/EelevX(abs(x)) {resolve uma fração se o expoente}
  else                                   {for negativo}
     begin
       t:=1; st:=t; k:=0;         {Atribui no termo zero o valor 1}

       while t > 1E-12 do         {Durante a repetição é calculado, a partir}
             begin                {do termo 1, o valor do termo, somando-se o}
               k := k + 1;        {valor do termo atual com a soma dos termos}
               t := t * x/k;      {já calculados}
               st := st + t;      {A repetição prossegue até que o termo k}
             end;                 {seja menor que 10^-12, o que nos da maior}
       EelevX := st;              {precisão no resultado}
     end;
end;

{******************}

begin
  if copy(formula,p,4)='SQRT' then          {Checa se a partir da letra }
      begin                                 {encontrada é formado o conjunto}
        p:=p+3;{pula o conjunto de letras}  {"SQRT" resolvendo então a raiz}
        proximoch;{Lê o próximo caracter}   {quadrada do número ou expressão}
        if ch='-' then raizneg:=true        {que vira após as letras}
        else                                {Se o próximo caracter for "-" ou}
           begin                            {o resultado da expressão for}
             f:=checach;                    {negativo sera retornado o erro}
             if f<0 then raizneg:=true      {de raiz negativa}
             else
                begin
                  f:=sqrt(f);
                end;
           end;
      end
  else if copy(formula,p,2)='E^' then       {Checa se a partir da letra}
      begin                                 {encontrada é formado o conjunto}
        p:=p+1;{pula o conjunto de letras}  {"E^" resolvendo então a função}
        proximoch;{Lê o próximo caracter}   {exponencial}
        f:=checach;
        f:=EelevX(f);
      end
  else
      begin
        poserro:=p; {Se a partir de uma letra não for encontrado um dos}
      end;          {conjuntos acima e marcada a posição do erro}
end;

{*****************************************}
                                           {Se o caracter for válido para}
Begin                                      {número, o novo número será}
  if (ch in numeros) then processa_numero  {capturado, se for parentesis}
  else if (ch='(') then                    {é iniciado o cálculo de uma nova}
          begin                            {expressão}

            np:=np+1;{Controla quantos parentesis foram encontrados}

            if np>6 then {Caso o limite de parentesis seja ultrapassado,}
               begin     {é retornado erro}
                 nipault:=true;
                 processa_nova_expressao;{Inicia o cálculo da nova expressão}
               end                       {para não interromper as operações}
            else
               begin
                 processa_nova_expressao;{Inicia o cálculo da nova expressão}
               end;
          end
  else processa_funcao_padrao; {Se o caracter for uma letra é iniciado o}
  checach:=f;                  {cálculo da função padrão}
end;

{**********************************************}

begin
  if ch='-' then  {Se o caracter for "-" a próxima expressão será negativa}
     begin
       proximoch; {Lê o proximo caracter}
       defsinal:=-checach;
     end
  else defsinal:=checach;
end;

{***************************************************}

begin
  s:=defsinal;
  while ch in ['*','/'] do
        begin
          operador:=ch; {Lê o operador}
          proximoch;  {Lê o proximo caracter}
          case operador of {Checa o operador e resolve a respectiva operação}
           '*': s:=s*defsinal;
           '/': begin
                  if defsinal=0 then divzero:=true {Se houver divisão por}
                  else                             {zero retorna erro}
                     begin
                       s:=s/defsinal;
                     end;
                end;
          end;
        end;
  prioridade:=s;
end;

{********************************************************}

begin
  e:=prioridade;  {Inicia prioridades}
  while ch in ['+','-'] do
        begin
          operador:=ch; {Lê o operador}
          proximoch;  {Lê o proximo caracter}
          case operador of {Checa o operador e resolve a respectiva operação}
           '+': e:=e+prioridade;
           '-': e:=e-prioridade;
          end;
        end;
  efetua:=e;
end;

{*************************************************************}
                                               {Caso a expressão inicie com}
begin                                          {ponto, é adicionado um zero}
  if formula[1]='.' then formula:='0'+formula; {antes. Se for sinal de mais}
  if formula[1]='+' then delete(formula,1,1);  {ele é apagado}
  p:=0; np:=0;                                 
  proximoch;  {Lê o proximo caracter}
  valor:=efetua;  {Efetua as contas}
  if ch=#13 then error:=false     {Caso o caracter não seja <ENTER>,que}
  else error:=true;               {indica que a expressão foi resolvida até}
  {recebe a posição do erro}      {o final, retorna erro}
  poserro:=p;                     
end;

{******************************************************************}

begin
  avalia(strg,r,p);     {Inicia a avaliação da expressão}
  calcula_formula:=r;
end;

{***********************************************************************}

{Os quatro procedimentos a seguir imprimem o aviso de erro na saída}

procedure erro_na_expressao;

var i:integer;

begin
  writeln;
  writeln('Erro! Expressão inválida!');
  writeln (formula);                    {Mostra a expressão e coloca o }
  for i:=1 to p-1 do write(' ');        {caracter "^" na posição p, que }
  writeln('^');                         {possui erro}
  writeln;
  write('ENTRADA>> ');
end;

{***********************************************************************}

procedure erro_no_parentesis;

begin
  writeln;
  writeln('Erro! Nível de parentesis ultrapassado!');
  writeln;
  write('ENTRADA>> ');
  nipault:=false;
end;

{***********************************************************************}

procedure erro_na_divisao;

begin
  writeln;
  writeln('Erro! Divisão por zero!');
  writeln;
  write('ENTRADA>> ');
  divzero:=false;
end;

{***********************************************************************}

procedure erro_na_raiz;

begin
  writeln;
  writeln('Erro! Raiz de número negativo!');
  writeln;
  write('ENTRADA>> ');
  raizneg:=false;
end;

{***********************************************************************}

procedure memorizacao; {Gerencia o uso da memória}

var memo:string;{valor contido na memória que vai ser inserido na formula}

{**************************************}

procedure operacao_na_memoria;{Efetua as operações na memória}

begin
  if formula<>'' then {Se alguma expressão foi digitada, inicia as operações}
     begin
       {Inicia o calculo da expressão}
       resultado:=calcula_formula(p,formula,error,divzero,raizneg,nipault);

       {Checa se houve algum erro}
       if error then erro_na_expressao
       else if nipault then erro_no_parentesis
            else if divzero then erro_na_divisao
                 else if raizneg then erro_na_raiz
                      else
                         begin {Se não houve nenhum erro, efetua as operações}
                           if tecla='+' then {Checa qual operador foi digitado}
                              begin
                                memoria:=memoria+resultado;
                                writeln;
			        writeln('SAIDA>> ',resultado:0:3,' adicionado na memória.');
                                writeln;
				write('ENTRADA>> ');
                              end
                           else
                              begin
                                memoria:=memoria-resultado;
                                writeln;
				writeln('SAIDA>> ',resultado:0:3,' subtraido da memória.');
                                writeln;
				write('ENTRADA>> ');
                              end;
                         end;
       resultado:=0;  {Limpa as variáveis}
       formula:='';
     end
  else {Se não houver nada para adicionar ou subtrair da memória,retorna erro}
     begin
       if tecla='+' then {Checa qual operador foi digitado}
          begin
            writeln;
            writeln('Erro! Não tem nada para adicionar na memória!');
            writeln;
	    write('ENTRADA>> ');
          end
       else
          begin
            writeln;
            writeln('Erro! Não tem nada para subtrair da memória!');
            writeln;
	    write('ENTRADA>> ');
          end;
     end;
end;

{**************************************}

begin
  tecla:=readkey;               {Após o usuário ter digitado <M> o programa}
  tecla:=upcase(tecla);         {lê mais uma tecla efetuando a operação }
  write(tecla);                 {correspondente}
  case tecla of
       '+','-' : operacao_na_memoria;{Adiciona ou subtrai um valor na memória}

       'C' : begin  {Limpa a memória}
               memoria:=0;  
               writeln;
               writeln('Memória limpa!');
               writeln;
	       write('ENTRADA>> ');
             end;
       'R' : begin  {Lê a memória}
               if formula='' then     {Se não tiver nada na formula}
                  begin               {a memória é impressa no video}
                    writeln;
		    writeln('SAIDA>> ',memoria:0:3);
                    writeln;
                    write('ENTRADA>> ');
                  end
               else                         {Caso já tenha digitado algum}
                  begin                     {caracter para a formula, é}
                    str(memoria,memo);      {adicionado o valor contido na}
                    formula:=formula+memo;  {memória à formula}
                  end;
             end;
  end;
end;

{***********************************************************************}

procedure igual;{Inicia os cálculos após o usuário ter digitado '=',
                 e imprime o resultado ou algum erro}

begin
  if formula <>'' then {Se tiver algum caracter na formula inicia o cálculo}
     begin
       {Inicia o cálculo da expressão}
       resultado:=calcula_formula(p,formula,error,divzero,raizneg,nipault);

       {Checa se houve algum erro ,tanto de digitação como de lógica}
       if error then erro_na_expressao
          else if nipault then erro_no_parentesis
               else if divzero then erro_na_divisao
                    else if raizneg then erro_na_raiz
                         else
                            begin {Se não houve erro, o resultado é mostrado}
                              writeln;
                              writeln('SAIDA>> ',resultado:0:3);
                              writeln;
			      write('ENTRADA>> ');
                            end;
       resultado:=0;  {Limpa as variáveis}
       formula:='';
     end
  else     {Se a formula estiver vazia retorna erro}
     begin
       writeln;
       writeln('Erro! Não tem nada para ser calculado!');
       writeln;
       write('ENTRADA>> ');
     end;
end;

{***********************************************************************}

{Leitura das teclas digitadas}

begin
  write('ENTRADA>> ');
  while tecla<>#27 do   {Enquanto não for pressionado <ESC> o programa vai}
        begin           {lendo as teclas digitadas}
          tecla:=readkey;
          tecla:=upcase(tecla);  {Transforma todas as letras em maiúsculas}
          write(tecla);
          case tecla of
               {letras válidas para a expressão}
               '0'..'9','.','+','-','*','/','(',')','S','Q','R','T','E',
               '^' : formula:=formula+tecla;

               'C' : formula:=''; {Apaga a formula}

               '<' : begin
                       n:=length(formula); {Lê o tamanho da formula}
                       if n=0 then         {Se não tiver nada retorna erro}
                          begin
                            writeln;
                            writeln('Erro! Não tem nada para apagar!');
                            writeln;
                            write('ENTRADA>> ');
                          end
                       else
                          delete(formula,n,1); {apaga o ultimo caracter}
                     end;

               'M' : memorizacao;

               '=' : igual;
          end;
        end;
end;

{****************************************************************************}

begin
  strcopy(windowtitle,'Calculadora'); {Altera o título da janela}
  apresentacao;
  leitura;
  donewincrt; {Fecha janela no Windows}
end.
