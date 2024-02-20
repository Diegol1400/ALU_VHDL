library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity Alu is
    port(
        clk: in std_logic;
        A, B: in std_logic_vector(3 downto 0);  -- Entradas A y B de 4 bits cada una
        control: in std_logic_vector(4 downto 0);  -- Entrada de control de 5 bits
        display: out std_logic_vector(1 downto 0);  -- Salida para encender displays
        leds: out unsigned(7 downto 0);  -- Salida para LEDs de 8 bits sin signo
        salida: out std_logic_vector(6 downto 0)  -- Salida de los segmentos del display 7 segmentos
    );
end Alu;

architecture behavioral of Alu is
    -- Declaración de señales internas
    signal valor, valor1, a1, b1, cin: unsigned(3 downto 0);  -- Señales internas de 4 bits
    signal cout: unsigned(4 downto 0);  -- Señal interna de acarreo de 5 bits
    signal multi: unsigned(7 downto 0);  -- Señal interna para multiplicación de 8 bits
    signal seleccion: unsigned(1 downto 0):="00";  -- Señal interna de selección de 2 bits inicializada en "00"
    signal mostrar: unsigned(3 downto 0);  -- Señal interna para mostrar de 4 bits
begin
    -- Conversión de las entradas A y B a tipos unsigned
    a1<=unsigned(A);
    b1<=unsigned(B);
    cin<="0000";  -- Inicialización de la señal de acarreo en "0000"


process(a1, b1, Control, cin)
begin 
    case control is
        when "00000" =>  -- Suma
            valor <= a1 + b1;
            cout <= ('0' & a1) + ('0' & b1);  -- Suma con acarreo
            valor1 <= "000" & cout(4);  -- Tomar el bit de acarreo y desplazar
            leds(7 downto 4) <= valor1(3 downto 0);  -- Mostrar el bit de acarreo en LEDs superiores
            leds(3 downto 0) <= valor(3 downto 0);  -- Mostrar el resultado de la suma en LEDs inferiores
 
        when "00001" =>  -- Resta
            if (a > b) then
                valor <= a1 - b1;
                valor1 <= "0000";
                cout <= ('0' & a1) - ('0' & b1);  -- Resta con acarreo
                valor1 <= "000" & cout(4); 
                leds(7 downto 4) <= valor1(3 downto 0);
                leds(3 downto 0) <= valor(3 downto 0);
            else
                valor <= b1 - a1;
                valor1 <= "0000";
                cout <= ('0' & b1) - ('0' & a1);
                valor1 <= "000" & cout(4); 
                leds(7 downto 4) <= valor1(3 downto 0);
                leds(3 downto 0) <= valor(3 downto 0); 
            end if;
 
        when "00010" =>  -- Multiplicación
            multi <= a1 * b1;
            valor <= multi(3 downto 0);
            valor1 <= multi(7 downto 4);
            leds(7 downto 4) <= valor1(3 downto 0);
            leds(3 downto 0) <= valor(3 downto 0);
 
        when "00011" =>  -- División
            valor <= (a1 / b1);
            valor1 <= "0000";
            leds(7 downto 4) <= valor1(3 downto 0);
            leds(3 downto 0) <= valor(3 downto 0);
            if b = "0000" then  -- Manejo de la división por cero
                valor <= "1110";
                valor1 <= "1110";
                leds <= "00000000";
            end if;
 
			when "00100" =>valor<=a1+1;-------------incremento
				valor1 <= "0000";
				leds(7 downto 4)<=valor1(3 downto 0);
				leds(3 downto 0)<=valor(3 downto 0);
				if a="1111" then
					valor <= "0000";
					valor1 <= "0001";
					leds(7 downto 4)<=valor1(3 downto 0);
					leds(3 downto 0)<=valor(3 downto 0);
				end if;
 
			when "00101" =>valor<=a1-1;---------------decremento
				valor1 <= "0000";
				leds(7 downto 4)<=valor1(3 downto 0);
				leds(3 downto 0)<=valor(3 downto 0);
				if a<="0000" then
					leds<="00000000";
					valor<="0000";
					valor1<="0000";
				end if;
------------------------Compuertas Logicas
			when "00110" =>leds<="0000"&(a1 or b1);-----------or
				valor1<="1100";
				valor<="0000";
  
			when "00111" =>leds<="0000"&(a1 and b1);----------and
				valor1<="1100";
				valor<="0000";
  
			when "01000" =>leds<="0000"& (not a1);-------------not
				valor1<="1100";
				valor<="0000";
  
			when "01001" =>leds<="0000"&(a1 nor b1);----------nor
				valor1<="1100";
				valor<="0000";
  
			when "01010" =>leds<="0000"&(a1 nand b1);----------nand
				valor1<="1100";
				valor<="0000";
  
			when "01011" =>leds<="0000"&a1 xor b1;----------xor
				valor1<="1100";
				valor<="0000";
				 
			when "01100" =>leds<="0000"&(a1 xnor b1);---------xnor
				valor1<="1100";
				valor<="0000";
 ---------------------------------------------------------------- 
			when "01101" =>  -- SLL (Shift Left Logical)
				leds <= "0000" & (a1 sll 1);  -- Desplazar a la izquierda lógicamente
				valor <= "1101";  -- Valor de estado
				valor1 <= "1101";  -- Valor de estado

			when "01110" =>  -- SRL (Shift Right Logical)
				 leds <= "0000" & (a1 srl 1);  -- Desplazar a la derecha lógicamente
				 valor <= "1101";  -- Valor de estado
				 valor1 <= "1101";  -- Valor de estado

			when "01111" =>  -- SLA (Shift Left Arithmetic)
				 leds <= "0000" & (a1(3 downto 1) sll 1) & (a1(0));  -- Desplazamiento aritmético a la izquierda
				 leds(1) <= a1(0);  -- Bit desplazado
				 valor <= "1101";  -- Valor de estado
				 valor1 <= "1101";  -- Valor de estado

			when "10000" =>  -- SRA (Shift Right Arithmetic)
				 leds <= "0000" & (a1(3)) & (a1(2 downto 0) srl 1);  -- Desplazamiento aritmético a la derecha
				 leds(2) <= a1(3);  -- Bit desplazado
				 valor <= "1101";  -- Valor de estado
				 valor1 <= "1101";  -- Valor de estado

			when "10001" =>  -- ROL (Rotate Left)
				 leds <= "0000" & (a1 rol 1);  -- Rotación a la izquierda
				 valor <= "1101";  -- Valor de estado
				 valor1 <= "1101";  -- Valor de estado

			when "10010" =>  -- ROR (Rotate Right)
				 leds <= "0000" & (a1 ror 1);  -- Rotación a la derecha
				 valor <= "1101";  -- Valor de estado
				 valor1 <= "1101";  -- Valor de estado

			when others =>valor<="1111";
	end case;
 end process;
 
 process(clk,seleccion) ----------------Barrido de los display de 7 segmentos

	variable contador: integer range 0 to 50000:=0;

	begin 
		if clk'event and clk='1' then
			if contador=50000 then
				seleccion <= seleccion+1;
				contador:=0;
			else
				contador:= contador+1;

			end if;
		end if;

	case seleccion is
		when"00"=> display<="01"; mostrar <= valor; 
		when"01"=>  display<="10"; mostrar<= valor1;
		when others =>  display<="00"; mostrar <= "0000";
	end case;
end process;

---------------------Seleccion de numero a mostrar en display de 7 segmentos
with mostrar select
salida <="1111111" when "0000",--0
     "1001111" when "0001",--1
	  "0010010" when "0010",--2
     "0000110" when "0011",--3
	  "1001100" when "0100",--4
	  "0100100" when "0101",--5
	  "0100000" when "0110",--6
	  "0001110" when "0111",--7
	  "0000000" when "1000",--8
	  "0001100" when "1001",--9
	  "0001000" when "1010",--A
     "1100000" when "1011",--B
     "0110001" when "1100",--C
     "1000010" when "1101",--D
     "0110000" when "1110",--E
     "0111000" when others;--F		

end behavioral;