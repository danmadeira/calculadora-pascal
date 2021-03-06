{*************************************}
{*                                   *}
{* Daniel Fernando Madeira RA 951752 *}
{* Turma MC101G                      *}
{* Calculadora vers�o 1.0            *}
{* Efetua express�es matem�ticas     *}
{* Conclu�do em 30/10/95             *}
{*                                   *}
{*************************************}

program calculadora;

uses wincrt,strings;

type strgmaxima=string;

var  p,n:integer; {p -> posi��o do �ltimo caracter lido,n -> tamanho da formula}
     formula:string;{express�o digitada pelo usuario}
     resultado,memoria:real;
     error,divzero,raizneg,nipault:boolean; {indica��es de erro}
     tecla:char; {tecla digitada}

{****************************************************************************}

procedure apresentacao;

begin
  writeln('CALCULADORA para IBM/PC vers�o 1.0 - Windows - 30/10/95');
  writeln('Feita por Daniel F. Madeira RA 951752. Vers�o Shareware!');
  writeln;
  writeln('Entre com a express�o e tecle "=" para resolv�-la.');
  writeln('Pressione <ESC> para sair!');
  writeln;
end;

{****************************************************************************}

procedure leitura; {L� e calcula a express�o}

{***********************************************************************}

{Inicia o calculo}

function calcula_formula(var p:integer; strg:strgmaxima;
                         var error,divzero,raizneg,nipault:boolean):real;

var  r:real;{resultado parcial}
     i,poserro:integer;{poserro -> posi��o do erro}
     ch:char;{�ltimo caracter lido}

{******************************************************************}

{Prepara a express�o para ser calculada e checa se houve algum erro}

procedure avalia(var formula:strgmaxima;
                 var valor:real;{resultado parcial}
                 var poserro:integer);

const numeros:set of char =['0'..'9','.'];

var  p,np:integer;{p -> posi��o do �ltimo caracter lido,np -> n�mero de parentesis}
     ch:char;{�ltimo caracter lido}

{*************************************************************}

procedure proximoch; {L� o pr�ximo caracter na formula indicando sua posi��o}

begin
  repeat
   p:=p+1;                                      {Caso j� tenha chegado no}
   if p <= length(formula) then ch:=formula[p]  {final da string � assumido}
                                                {o caracter #13}
                           else ch:=#13;        
  until (ch<>' ');                              
end;                                            
                                                
{*************************************************************}

function efetua:real;{Inicia os c�lculos}

var  e:real;{resultado de calculos n�o prioritarios}
     operador:char;{recebe o operador do c�lculo atual}

{********************************************************}

function prioridade:real; {Efetua as prioridades}

var  s:real;{resultado das prioridades}
     operador:char;

{***************************************************}

function defsinal:real; {Define o sinal da prioridade}

{**********************************************}

function checach:real; {Checa se o �ltimo caracter lido � um n�mero, um
                        parentesis que indica nova express�o, ou uma letra
                        que indica fun��o padr�o}

var  start:integer;{posi��o do primeiro caracter de um n�mero dentro da string}
     f:real;{recebe o n�mero, ou o resultado da nova express�o ou fun��o padr�o}

{*****************************************}

procedure processa_numero; {L� o n�mero dentro da string}

var code:integer;{posi��o do erro caso a substring n�o possa ser convertida
                  em n�mero}
begin
  start:=p;
  repeat                             {L� os pr�ximos caracteres at� que}
   proximoch;                        {n�o seja um n�mero ou um dos dois}
  until not (ch in numeros);         {caracteres aceitos em n�mero}
  if ch='.' then
      repeat                         {E finalmente converte a substring}
       proximoch;                    {do n�mero encontrado para uma vari�vel}
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

procedure processa_nova_expressao;{Inicia novamente os c�lculos para a nova
                                   express�o}

begin
  proximoch;                  {L� o pr�ximo caracter e efetua a nova }
  f:=efetua;                  {express�o, se o pr�ximo caracter depois}
  if ch=')' then proximoch    {da nova express�o n�o for ')' � marcado}
            else poserro:=p;  {a posi��o do erro}
end;

{*****************************************}

procedure processa_funcao_padrao;{Calcula o valor das fun��es padr�o}

{******************}

function EelevX(x:real):real;{Calcula a fun��o de E elevado a X}

var t,st :real;{t -> valor do termo atual, st -> soma dos termos}
    k:integer;{contador dos termos}

begin
  if x < 0 then EelevX:=1/EelevX(abs(x)) {resolve uma fra��o se o expoente}
  else                                   {for negativo}
     begin
       t:=1; st:=t; k:=0;         {Atribui no termo zero o valor 1}

       while t > 1E-12 do         {Durante a repeti��o � calculado, a partir}
             begin                {do termo 1, o valor do termo, somando-se o}
               k := k + 1;        {valor do termo atual com a soma dos termos}
               t := t * x/k;      {j� calculados}
               st := st + t;      {A repeti��o prossegue at� que o termo k}
             end;                 {seja menor que 10^-12, o que nos da maior}
       EelevX := st;              {precis�o no resultado}
     end;
end;

{******************}

begin
  if copy(formula,p,4)='SQRT' then          {Checa se a partir da letra }
      begin                                 {encontrada � formado o conjunto}
        p:=p+3;{pula o conjunto de letras}  {"SQRT" resolvendo ent�o a raiz}
        proximoch;{L� o pr�ximo caracter}   {quadrada do n�mero ou express�o}
        if ch='-' then raizneg:=true        {que vira ap�s as letras}
        else                                {Se o pr�ximo caracter for "-" ou}
           begin                            {o resultado da express�o for}
             f:=checach;                    {negativo sera retornado o erro}
             if f<0 then raizneg:=true      {de raiz negativa}
             else
                begin
                  f:=sqrt(f);
                end;
           end;
      end
  else if copy(formula,p,2)='E^' then       {Checa se a partir da letra}
      begin                                 {encontrada � formado o conjunto}
        p:=p+1;{pula o conjunto de letras}  {"E^" resolvendo ent�o a fun��o}
        proximoch;{L� o pr�ximo caracter}   {exponencial}
        f:=checach;
        f:=EelevX(f);
      end
  else
      begin
        poserro:=p; {Se a partir de uma letra n�o for encontrado um dos}
      end;          {conjuntos acima e marcada a posi��o do erro}
end;

{*****************************************}
                                           {Se o caracter for v�lido para}
Begin                                      {n�mero, o novo n�mero ser�}
  if (ch in numeros) then processa_numero  {capturado, se for parentesis}
  else if (ch='(') then                    {� iniciado o c�lculo de uma nova}
          begin                            {express�o}

            np:=np+1;{Controla quantos parentesis foram encontrados}

            if np>6 then {Caso o limite de parentesis seja ultrapassado,}
               begin     {� retornado erro}
                 nipault:=true;
                 processa_nova_expressao;{Inicia o c�lculo da nova express�o}
               end                       {para n�o interromper as opera��es}
            else
               begin
                 processa_nova_expressao;{Inicia o c�lculo da nova express�o}
               end;
          end
  else processa_funcao_padrao; {Se o caracter for uma letra � iniciado o}
  checach:=f;                  {c�lculo da fun��o padr�o}
end;

{**********************************************}

begin
  if ch='-' then  {Se o caracter for "-" a pr�xima express�o ser� negativa}
     begin
       proximoch; {L� o proximo caracter}
       defsinal:=-checach;
     end
  else defsinal:=checach;
end;

{***************************************************}

begin
  s:=defsinal;
  while ch in ['*','/'] do
        begin
          operador:=ch; {L� o operador}
          proximoch;  {L� o proximo caracter}
          case operador of {Checa o operador e resolve a respectiva opera��o}
           '*': s:=s*defsinal;
           '/': begin
                  if defsinal=0 then divzero:=true {Se houver divis�o por}
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
          operador:=ch; {L� o operador}
          proximoch;  {L� o proximo caracter}
          case operador of {Checa o operador e resolve a respectiva opera��o}
           '+': e:=e+prioridade;
           '-': e:=e-prioridade;
          end;
        end;
  efetua:=e;
end;

{*************************************************************}
                                               {Caso a express�o inicie com}
begin                                          {ponto, � adicionado um zero}
  if formula[1]='.' then formula:='0'+formula; {antes. Se for sinal de mais}
  if formula[1]='+' then delete(formula,1,1);  {ele � apagado}
  p:=0; np:=0;                                 
  proximoch;  {L� o proximo caracter}
  valor:=efetua;  {Efetua as contas}
  if ch=#13 then error:=false     {Caso o caracter n�o seja <ENTER>,que}
  else error:=true;               {indica que a express�o foi resolvida at�}
  {recebe a posi��o do erro}      {o final, retorna erro}
  poserro:=p;                     
end;

{******************************************************************}

begin
  avalia(strg,r,p);     {Inicia a avalia��o da express�o}
  calcula_formula:=r;
end;

{***********************************************************************}

{Os quatro procedimentos a seguir imprimem o aviso de erro na sa�da}

procedure erro_na_expressao;

var i:integer;

begin
  writeln;
  writeln('Erro! Express�o inv�lida!');
  writeln (formula);                    {Mostra a express�o e coloca o }
  for i:=1 to p-1 do write(' ');        {caracter "^" na posi��o p, que }
  writeln('^');                         {possui erro}
  writeln;
  write('ENTRADA>> ');
end;

{***********************************************************************}

procedure erro_no_parentesis;

begin
  writeln;
  writeln('Erro! N�vel de parentesis ultrapassado!');
  writeln;
  write('ENTRADA>> ');
  nipault:=false;
end;

{***********************************************************************}

procedure erro_na_divisao;

begin
  writeln;
  writeln('Erro! Divis�o por zero!');
  writeln;
  write('ENTRADA>> ');
  divzero:=false;
end;

{***********************************************************************}

procedure erro_na_raiz;

begin
  writeln;
  writeln('Erro! Raiz de n�mero negativo!');
  writeln;
  write('ENTRADA>> ');
  raizneg:=false;
end;

{***********************************************************************}

procedure memorizacao; {Gerencia o uso da mem�ria}

var memo:string;{valor contido na mem�ria que vai ser inserido na formula}

{**************************************}

procedure operacao_na_memoria;{Efetua as opera��es na mem�ria}

begin
  if formula<>'' then {Se alguma express�o foi digitada, inicia as opera��es}
     begin
       {Inicia o calculo da express�o}
       resultado:=calcula_formula(p,formula,error,divzero,raizneg,nipault);

       {Checa se houve algum erro}
       if error then erro_na_expressao
       else if nipault then erro_no_parentesis
            else if divzero then erro_na_divisao
                 else if raizneg then erro_na_raiz
                      else
                         begin {Se n�o houve nenhum erro, efetua as opera��es}
                           if tecla='+' then {Checa qual operador foi digitado}
                              begin
                                memoria:=memoria+resultado;
                                writeln;
			        writeln('SAIDA>> ',resultado:0:3,' adicionado na mem�ria.');
                                writeln;
				write('ENTRADA>> ');
                              end
                           else
                              begin
                                memoria:=memoria-resultado;
                                writeln;
				writeln('SAIDA>> ',resultado:0:3,' subtraido da mem�ria.');
                                writeln;
				write('ENTRADA>> ');
                              end;
                         end;
       resultado:=0;  {Limpa as vari�veis}
       formula:='';
     end
  else {Se n�o houver nada para adicionar ou subtrair da mem�ria,retorna erro}
     begin
       if tecla='+' then {Checa qual operador foi digitado}
          begin
            writeln;
            writeln('Erro! N�o tem nada para adicionar na mem�ria!');
            writeln;
	    write('ENTRADA>> ');
          end
       else
          begin
            writeln;
            writeln('Erro! N�o tem nada para subtrair da mem�ria!');
            writeln;
	    write('ENTRADA>> ');
          end;
     end;
end;

{**************************************}

begin
  tecla:=readkey;               {Ap�s o usu�rio ter digitado <M> o programa}
  tecla:=upcase(tecla);         {l� mais uma tecla efetuando a opera��o }
  write(tecla);                 {correspondente}
  case tecla of
       '+','-' : operacao_na_memoria;{Adiciona ou subtrai um valor na mem�ria}

       'C' : begin  {Limpa a mem�ria}
               memoria:=0;  
               writeln;
               writeln('Mem�ria limpa!');
               writeln;
	       write('ENTRADA>> ');
             end;
       'R' : begin  {L� a mem�ria}
               if formula='' then     {Se n�o tiver nada na formula}
                  begin               {a mem�ria � impressa no video}
                    writeln;
		    writeln('SAIDA>> ',memoria:0:3);
                    writeln;
                    write('ENTRADA>> ');
                  end
               else                         {Caso j� tenha digitado algum}
                  begin                     {caracter para a formula, �}
                    str(memoria,memo);      {adicionado o valor contido na}
                    formula:=formula+memo;  {mem�ria � formula}
                  end;
             end;
  end;
end;

{***********************************************************************}

procedure igual;{Inicia os c�lculos ap�s o usu�rio ter digitado '=',
                 e imprime o resultado ou algum erro}

begin
  if formula <>'' then {Se tiver algum caracter na formula inicia o c�lculo}
     begin
       {Inicia o c�lculo da express�o}
       resultado:=calcula_formula(p,formula,error,divzero,raizneg,nipault);

       {Checa se houve algum erro ,tanto de digita��o como de l�gica}
       if error then erro_na_expressao
          else if nipault then erro_no_parentesis
               else if divzero then erro_na_divisao
                    else if raizneg then erro_na_raiz
                         else
                            begin {Se n�o houve erro, o resultado � mostrado}
                              writeln;
                              writeln('SAIDA>> ',resultado:0:3);
                              writeln;
			      write('ENTRADA>> ');
                            end;
       resultado:=0;  {Limpa as vari�veis}
       formula:='';
     end
  else     {Se a formula estiver vazia retorna erro}
     begin
       writeln;
       writeln('Erro! N�o tem nada para ser calculado!');
       writeln;
       write('ENTRADA>> ');
     end;
end;

{***********************************************************************}

{Leitura das teclas digitadas}

begin
  write('ENTRADA>> ');
  while tecla<>#27 do   {Enquanto n�o for pressionado <ESC> o programa vai}
        begin           {lendo as teclas digitadas}
          tecla:=readkey;
          tecla:=upcase(tecla);  {Transforma todas as letras em mai�sculas}
          write(tecla);
          case tecla of
               {letras v�lidas para a express�o}
               '0'..'9','.','+','-','*','/','(',')','S','Q','R','T','E',
               '^' : formula:=formula+tecla;

               'C' : formula:=''; {Apaga a formula}

               '<' : begin
                       n:=length(formula); {L� o tamanho da formula}
                       if n=0 then         {Se n�o tiver nada retorna erro}
                          begin
                            writeln;
                            writeln('Erro! N�o tem nada para apagar!');
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
  strcopy(windowtitle,'Calculadora'); {Altera o t�tulo da janela}
  apresentacao;
  leitura;
  donewincrt; {Fecha janela no Windows}
end.
