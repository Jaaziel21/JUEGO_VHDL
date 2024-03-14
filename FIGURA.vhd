-- Librerías
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

-- Definición de la entidad
entity FIGURA is
	
	port ( CONT800, CONT525 : in std_logic_vector (9 downto 0);	-- Entradas
			 CLK : in std_logic;
			 IZQ, DER : in std_logic;
			 HST, VST : in std_logic_vector (1 downto 0);			-- Salidas
			 R, G, B : out std_logic_vector ( 3 downto 0) );
	
end entity;

-- Definiicón de la arquitectura
architecture RTL of FIGURA is
	
	-- Horizontal
	constant ZV800I : std_logic_vector (9 downto 0) := "0010001111";		-- 143	(INICIO)
	constant ZV800F : std_logic_vector (9 downto 0) := "1100010000";		-- 784	(FIN)
	
	-- Vertical
	constant ZV525I : std_logic_vector (9 downto 0) := "0000100010";		-- 34		(INICIO)
	constant ZV525F : std_logic_vector (9 downto 0) := "1000000011";		-- 515	(FIN)
	
	-- Horizontal
	constant limizq : std_logic_vector (9 downto 0) := "0010001111"; -- 143
	constant limder : std_logic_vector (9 downto 0) := "1100000000"; -- 784-16
	
	
	-- Vertical
	constant limsup : std_logic_vector (9 downto 0) := "0000100010"; -- 34
	constant liminf : std_logic_vector (9 downto 0) := "0111110011"; -- 515-16
	
	-- Raqueta
	signal movH : std_logic_vector (9 downto 0) := "0111001111";	-- 463 (CENTRO)
	
	
	-- Ladrillos
-- Fila 1
constant LADRILLO1_X : std_logic_vector(9 downto 0) := "0011000000";  -- Bloque 1 (primera columna)
constant LADRILLO1_Y : std_logic_vector(9 downto 0) := "0001000000";  -- Fila 1

constant LADRILLO2_X : std_logic_vector(9 downto 0) := "0100000000";  -- Bloque 2 (segunda columna)
constant LADRILLO2_Y : std_logic_vector(9 downto 0) := "0001000000";  -- Fila 1

constant LADRILLO3_X : std_logic_vector(9 downto 0) := "0101000000";  -- Bloque 3 (tercera columna)
constant LADRILLO3_Y : std_logic_vector(9 downto 0) := "0001000000";  -- Fila 1

constant LADRILLO4_X : std_logic_vector(9 downto 0) := "0110000000";  -- Bloque 4 (cuarta columna)
constant LADRILLO4_Y : std_logic_vector(9 downto 0) := "0001000000";  -- Fila 1

constant LADRILLO5_X : std_logic_vector(9 downto 0) := "0111000000";  -- Bloque 5 (quinta columna)
constant LADRILLO5_Y : std_logic_vector(9 downto 0) := "0001000000";  -- Fila 1

constant LADRILLO6_X : std_logic_vector(9 downto 0) := "1000000000";  -- Bloque 6 (sexta columna)
constant LADRILLO6_Y : std_logic_vector(9 downto 0) := "0001000000";  -- Fila 1

constant LADRILLO7_X : std_logic_vector(9 downto 0) := "1001000000";  -- Bloque 7 (septima columna)
constant LADRILLO7_Y : std_logic_vector(9 downto 0) := "0001000000";  -- Fila 1

constant LADRILLO8_X : std_logic_vector(9 downto 0) := "1010000000";  -- Bloque 8 (octava columna)
constant LADRILLO8_Y : std_logic_vector(9 downto 0) := "0001000000";  -- Fila 1

constant LADRILLO9_X : std_logic_vector(9 downto 0) := "1011000000";  -- Bloque 9 (novena columna)
constant LADRILLO9_Y : std_logic_vector(9 downto 0) := "0001000000";  -- Fila 1


-- Fila 2
constant LADRILLO10_X : std_logic_vector(9 downto 0) := "0011000000";  -- Bloque 10 (primera columna)
constant LADRILLO10_Y : std_logic_vector(9 downto 0) := "0001100000";  -- Fila 2

constant LADRILLO11_X : std_logic_vector(9 downto 0) := "0100000000";  -- Bloque 11 (segunda columna)
constant LADRILLO11_Y : std_logic_vector(9 downto 0) := "0001100000";  -- Fila 2

constant LADRILLO12_X : std_logic_vector(9 downto 0) := "0101000000";  -- Bloque 12 (tercera columna)
constant LADRILLO12_Y : std_logic_vector(9 downto 0) := "0001100000";  -- Fila 2

constant LADRILLO13_X : std_logic_vector(9 downto 0) := "0110000000";  -- Bloque 13 (cuarta columna)
constant LADRILLO13_Y : std_logic_vector(9 downto 0) := "0001100000";  -- Fila 2

constant LADRILLO14_X : std_logic_vector(9 downto 0) := "0111000000";  -- Bloque 14 (quinta columna)
constant LADRILLO14_Y : std_logic_vector(9 downto 0) := "0001100000";  -- Fila 2

constant LADRILLO15_X : std_logic_vector(9 downto 0) := "1000000000";  -- Bloque 15 (sexta columna)
constant LADRILLO15_Y : std_logic_vector(9 downto 0) := "0001100000";  -- Fila 2

constant LADRILLO16_X : std_logic_vector(9 downto 0) := "1001000000";  -- Bloque 16 (septima columna)
constant LADRILLO16_Y : std_logic_vector(9 downto 0) := "0001100000";  -- Fila 2

constant LADRILLO17_X : std_logic_vector(9 downto 0) := "1010000000";  -- Bloque 17 (octava columna)
constant LADRILLO17_Y : std_logic_vector(9 downto 0) := "0001100000";  -- Fila 2

constant LADRILLO18_X : std_logic_vector(9 downto 0) := "1011000000";  -- Bloque 18 (novena columna)
constant LADRILLO18_Y : std_logic_vector(9 downto 0) := "0001100000";  -- Fila 2

-- Fila 3
--constant LADRILLO11_X : std_logic_vector(9 downto 0) := "0101000000";  -- Bloque 11 (primera columna)
--constant LADRILLO11_Y : std_logic_vector(9 downto 0) := "0010000000";  -- Fila 3

--constant LADRILLO12_X : std_logic_vector(9 downto 0) := "0110000000";  -- Bloque 12 (segunda columna)
--constant LADRILLO12_Y : std_logic_vector(9 downto 0) := "0010000000";  -- Fila 3

--constant LADRILLO13_X : std_logic_vector(9 downto 0) := "0111000000";  -- Bloque 13 (tercera columna)
--constant LADRILLO13_Y : std_logic_vector(9 downto 0) := "0010000000";  -- Fila 3

--constant LADRILLO14_X : std_logic_vector(9 downto 0) := "1000000000";  -- Bloque 14 (cuarta columna)
--constant LADRILLO14_Y : std_logic_vector(9 downto 0) := "0010000000";  -- Fila

--constant LADRILLO15_X : std_logic_vector(9 downto 0) := "1001000000";  -- Bloque 15 (quinta columna)
--constant LADRILLO15_Y : std_logic_vector(9 downto 0) := "0010000000";  -- Fila 3

-- Fila 4
--constant LADRILLO16_X : std_logic_vector(9 downto 0) := "0101000000";  -- Bloque 16 (primera columna)
--constant LADRILLO16_Y : std_logic_vector(9 downto 0) := "0010100000";  -- Fila 4

--constant LADRILLO17_X : std_logic_vector(9 downto 0) := "0110000000";  -- Bloque 17 (segunda columna)
--constant LADRILLO17_Y : std_logic_vector(9 downto 0) := "0010100000";  -- Fila 4

--constant LADRILLO18_X : std_logic_vector(9 downto 0) := "0111000000";  -- Bloque 18 (tercera columna)
--constant LADRILLO18_Y : std_logic_vector(9 downto 0) := "0010100000";  -- Fila 4

constant LADRILLO19_X : std_logic_vector(9 downto 0) := "1000000000";  -- Bloque 19 (cuarta columna)
constant LADRILLO19_Y : std_logic_vector(9 downto 0) := "0010100000";  -- Fila 4

constant LADRILLO20_X : std_logic_vector(9 downto 0) := "1001000000";  -- Bloque 20 (quinta columna)
constant LADRILLO20_Y : std_logic_vector(9 downto 0) := "0010100000";  -- Fila 4

	
	constant LADRILLO_ANCHO : std_logic_vector(9 downto 0) := "0000100000"; -- Ancho del bloque
   constant LADRILLO_ALTO : std_logic_vector(9 downto 0) := "0000010000"; -- Alto del bloque

	-- Pelota y ladrillos
	signal mov_x : std_logic_vector (9 downto 0) := "0111001111";	-- 463 (CENTRO)
   signal mov_y : std_logic_vector (9 downto 0) := "0100000000";
   signal direccion_x : std_logic := '1'; -- '1' para derecha, 0 para izquierda
   signal direccion_y : std_logic := '1'; -- '1' para abajo, 0 para arriba
	
	-- ladrillos
	signal ladrillo_presente : std_logic := '1'; -- '1' indica que el ladrillo está presente
	signal ladrillo1_presente : std_logic := '1';
   signal ladrillo2_presente : std_logic := '1';
   signal ladrillo3_presente : std_logic := '1';
   signal ladrillo4_presente : std_logic := '1';
   signal ladrillo5_presente : std_logic := '1';
	signal ladrillo6_presente : std_logic := '1';
   signal ladrillo7_presente : std_logic := '1';
   signal ladrillo8_presente : std_logic := '1';
   signal ladrillo9_presente : std_logic := '1';
   signal ladrillo10_presente : std_logic := '1';
	signal ladrillo11_presente : std_logic := '1';
   signal ladrillo12_presente : std_logic := '1';
   signal ladrillo13_presente : std_logic := '1';
   signal ladrillo14_presente : std_logic := '1';
   signal ladrillo15_presente : std_logic := '1';
	signal ladrillo16_presente : std_logic := '1';
   signal ladrillo17_presente : std_logic := '1';
   signal ladrillo18_presente : std_logic := '1';
   signal ladrillo19_presente : std_logic := '1';
   signal ladrillo20_presente : std_logic := '1';
	
	signal ha_perdido : std_logic := '1';
	signal pelota_en_espera : std_logic := '1';
	
	
	
	-- Descripción del circuito
	
	begin

------------------------ Proceso para controlar la posición de la raqueta --------------------------------------------------------------
		
		RAQUETA : process (CLK, DER, IZQ, movH)
		begin
			-- Actualizar la posición de la raqueta cada 60Hz
			if (CLK'EVENT and CLK = '1') then
				if (DER = '0') and (movH <= "1011010000") then
					movH <= movH + 5;
				elsif (IZQ = '0') and (movH >= limizq) then
					movH <= movH - 5;
				end if;
			end if;
		end process RAQUETA;
		
----------------------- Proceso para controlar la posición de la pelota ---------------------------------------------------------------
		
		PELOTA : process (CLK, mov_x, mov_y, direccion_x, direccion_y)
		begin
			-- Actualizar la posición de la pelota cada 60Hz
			if (CLK'EVENT and CLK = '1') then
			
			 if pelota_en_espera = '1' and (IZQ = '0' or DER = '0') then
					pelota_en_espera <= '0'; -- La pelota ya no está en espera
					direccion_y <= '0';
          end if;
			 
				if pelota_en_espera = '0' then
				
				-- Movimiento sobre el plano horizontal
					if (direccion_x = '1') then
						if (mov_x < limder) then
							mov_x <= mov_x + 4;
						else
							direccion_x <= '0';
					end if;
					
					else
						if (mov_x > limizq) then
							mov_x <= mov_x - 4;
						else
							direccion_x <= '1';
						end if;
					end if;
				
				-- Movimiento sobre el plano vertical
				
					if (direccion_y = '1') then
						if (mov_y < liminf) then
							mov_y <= mov_y + 4;
						else
							ha_perdido <= '1'; -- Indicar que el jugador ha perdido
							mov_x <= movH + "0000100000"; 
							mov_y <= "0111001111"; 
							direccion_y <= '0';
							pelota_en_espera <= '1';
						end if;
						
					else
						if (mov_y > limsup) then
							mov_y <= mov_y - 5;
						else
							direccion_y <= '1';
						end if;
						
					end if;
				
			
----------------------- Detectar colisión con el ladrillo ------------------------------------------------------------------------------------
           
						 
					if ladrillo1_presente = '1' and
			  
                   (mov_x + "0000010000" > LADRILLO1_X and mov_x < LADRILLO1_X + LADRILLO_ANCHO and
                   mov_y + "0000010000" > LADRILLO1_Y and mov_y < LADRILLO1_Y + LADRILLO_ALTO) then
						 
                   ladrillo1_presente <= '0'; 
                   direccion_y <= not direccion_y;
						 
						 if mov_x + "0000001000" < LADRILLO1_X + "0000011000" then
						 
								direccion_x <= '0';  -- Rebote hacia la izquierda
								
						 elsif mov_x + "0000001000" > LADRILLO1_X + "0000101000" then
						 
								direccion_x <= '1';  -- Rebote hacia la derech
							
						 end if;
						 
					elsif ladrillo2_presente = '1' and
			  
                   (mov_x + "0000010000" > LADRILLO2_X and mov_x < LADRILLO2_X + LADRILLO_ANCHO and
                   mov_y + "0000010000" > LADRILLO2_Y and mov_y < LADRILLO2_Y + LADRILLO_ALTO) then
						 
                   ladrillo2_presente <= '0'; 
                   direccion_y <= not direccion_y;
						 
						 if mov_x + "0000001000" < LADRILLO2_X + "0000011000" then
						 
								direccion_x <= '0';  -- Rebote hacia la izquierda
								
						 elsif mov_x + "0000001000" > LADRILLO2_X + "0000101000" then
						 
								direccion_x <= '1';  -- Rebote hacia la derecha
								
						 end if;
						 
					elsif ladrillo3_presente = '1' and
			  
                   (mov_x + "0000010000" > LADRILLO3_X and mov_x < LADRILLO3_X + LADRILLO_ANCHO and
                   mov_y + "0000010000" > LADRILLO3_Y and mov_y < LADRILLO3_Y + LADRILLO_ALTO) then
						 
                   ladrillo3_presente <= '0'; 
                   direccion_y <= not direccion_y;
						 
						 if mov_x + "0000001000" < LADRILLO3_X + "0000011000" then
						 
								direccion_x <= '0';  -- Rebote hacia la izquierda
								
						 elsif mov_x + "0000001000" > LADRILLO3_X + "0000101000" then
						 
								direccion_x <= '1';  -- Rebote hacia la derecha
								
						 end if;
						 
					elsif ladrillo4_presente = '1' and
			  
                   (mov_x + "0000010000" > LADRILLO4_X and mov_x < LADRILLO4_X + LADRILLO_ANCHO and
                   mov_y + "0000010000" > LADRILLO4_Y and mov_y < LADRILLO4_Y + LADRILLO_ALTO) then
						 
                   ladrillo4_presente <= '0'; 
                   direccion_y <= not direccion_y;
						 
						 if mov_x + "0000001000" < LADRILLO4_X + "0000011000" then
						 
								direccion_x <= '0';  -- Rebote hacia la izquierda
								
						 elsif mov_x + "0000001000" > LADRILLO4_X + "0000101000" then
						 
								direccion_x <= '1';  -- Rebote hacia la derecha
								
						 end if;
						 
					elsif ladrillo5_presente = '1' and
			  
                   (mov_x + "0000010000" > LADRILLO5_X and mov_x < LADRILLO5_X + LADRILLO_ANCHO and
                   mov_y + "0000010000" > LADRILLO5_Y and mov_y < LADRILLO5_Y + LADRILLO_ALTO) then
						 
                   ladrillo5_presente <= '0'; 
                   direccion_y <= not direccion_y;
						 
						 if mov_x + "0000001000" < LADRILLO5_X + "0000011000" then
						 
								direccion_x <= '0';  -- Rebote hacia la izquierda
								
						 elsif mov_x + "0000001000" > LADRILLO5_X + "0000101000" then
						 
								direccion_x <= '1';  -- Rebote hacia la derecha
								
						 end if;
						 
					elsif ladrillo6_presente = '1' and
			  
                   (mov_x + "0000010000" > LADRILLO6_X and mov_x < LADRILLO6_X + LADRILLO_ANCHO and
                   mov_y + "0000010000" > LADRILLO6_Y and mov_y < LADRILLO6_Y + LADRILLO_ALTO) then
						 
                   ladrillo6_presente <= '0'; 
                   direccion_y <= not direccion_y;
						 
						 if mov_x + "0000001000" < LADRILLO6_X + "0000011000" then
						 
								direccion_x <= '0';  -- Rebote hacia la izquierda
								
						 elsif mov_x + "0000001000" > LADRILLO6_X + "0000101000" then
						 
								direccion_x <= '1';  -- Rebote hacia la derecha
								
						 end if;
						 
					elsif ladrillo7_presente = '1' and
			  
                   (mov_x + "0000010000" > LADRILLO7_X and mov_x < LADRILLO7_X + LADRILLO_ANCHO and
                   mov_y + "0000010000" > LADRILLO7_Y and mov_y < LADRILLO7_Y + LADRILLO_ALTO) then
						 
                   ladrillo7_presente <= '0'; 
                   direccion_y <= not direccion_y;
						 
						 if mov_x + "0000001000" < LADRILLO7_X + "0000011000" then
						 
								direccion_x <= '0';  -- Rebote hacia la izquierda
								
						 elsif mov_x + "0000001000" > LADRILLO7_X + "0000101000" then
						 
								direccion_x <= '1';  -- Rebote hacia la derecha
								
						 end if;
						 
					elsif ladrillo8_presente = '1' and
			  
                   (mov_x + "0000010000" > LADRILLO8_X and mov_x < LADRILLO8_X + LADRILLO_ANCHO and
                   mov_y + "0000010000" > LADRILLO8_Y and mov_y < LADRILLO8_Y + LADRILLO_ALTO) then
						 
                   ladrillo8_presente <= '0'; 
                   direccion_y <= not direccion_y;
						 
						 if mov_x + "0000001000" < LADRILLO8_X + "0000011000" then
						 
								direccion_x <= '0';  -- Rebote hacia la izquierda
								
						 elsif mov_x + "0000001000" > LADRILLO8_X + "0000101000" then
						 
								direccion_x <= '1';  -- Rebote hacia la derecha
								
						 end if;
						 
					elsif ladrillo9_presente = '1' and
			  
                   (mov_x + "0000010000" > LADRILLO9_X and mov_x < LADRILLO9_X + LADRILLO_ANCHO and
                   mov_y + "0000010000" > LADRILLO9_Y and mov_y < LADRILLO9_Y + LADRILLO_ALTO) then
						 
                   ladrillo9_presente <= '0'; 
                   direccion_y <= not direccion_y;
						 
						 if mov_x + "0000001000" < LADRILLO9_X + "0000011000" then
						 
								direccion_x <= '0';  -- Rebote hacia la izquierda
								
						 elsif mov_x + "0000001000" > LADRILLO9_X + "0000101000" then
						 
								direccion_x <= '1';  -- Rebote hacia la derecha
								
						 end if;
						 
					elsif ladrillo10_presente = '1' and
			  
                   (mov_x + "0000010000" > LADRILLO10_X and mov_x < LADRILLO10_X + LADRILLO_ANCHO and
                   mov_y + "0000010000" > LADRILLO10_Y and mov_y < LADRILLO10_Y + LADRILLO_ALTO) then
						 
                   ladrillo10_presente <= '0'; 
                   direccion_y <= not direccion_y;
						 
						 if mov_x + "0000001000" < LADRILLO10_X + "0000011000" then
						 
								direccion_x <= '0';  -- Rebote hacia la izquierda
								
						 elsif mov_x + "0000001000" > LADRILLO10_X + "0000101000" then
						 
								direccion_x <= '1';  -- Rebote hacia la derecha
								
						 end if;
						 
					elsif ladrillo11_presente = '1' and
			  
                   (mov_x + "0000010000" > LADRILLO11_X and mov_x < LADRILLO11_X + LADRILLO_ANCHO and
                   mov_y + "0000010000" > LADRILLO11_Y and mov_y < LADRILLO11_Y + LADRILLO_ALTO) then
						 
                   ladrillo11_presente <= '0'; 
                   direccion_y <= not direccion_y;
						 
						 if mov_x + "0000001000" < LADRILLO11_X + "0000011000" then
						 
								direccion_x <= '0';  -- Rebote hacia la izquierda
								
						 elsif mov_x + "0000001000" > LADRILLO11_X + "0000101000" then
						 
								direccion_x <= '1';  -- Rebote hacia la derecha
								
						 end if;
						 
					elsif ladrillo12_presente = '1' and
			  
                   (mov_x + "0000010000" > LADRILLO12_X and mov_x < LADRILLO12_X + LADRILLO_ANCHO and
                   mov_y + "0000010000" > LADRILLO12_Y and mov_y < LADRILLO12_Y + LADRILLO_ALTO) then
						 
                   ladrillo12_presente <= '0'; 
                   direccion_y <= not direccion_y;
						 
						 if mov_x + "0000001000" < LADRILLO12_X + "0000011000" then
						 
								direccion_x <= '0';  -- Rebote hacia la izquierda
								
						 elsif mov_x + "0000001000" > LADRILLO12_X + "0000101000" then
						 
								direccion_x <= '1';  -- Rebote hacia la derecha
								
						 end if;
						 
					elsif ladrillo13_presente = '1' and
			  
                   (mov_x + "0000010000" > LADRILLO13_X and mov_x < LADRILLO13_X + LADRILLO_ANCHO and
                   mov_y + "0000010000" > LADRILLO13_Y and mov_y < LADRILLO13_Y + LADRILLO_ALTO) then
						 
                   ladrillo13_presente <= '0'; 
                   direccion_y <= not direccion_y;
						 
						 if mov_x + "0000001000" < LADRILLO13_X + "0000011000" then
						 
								direccion_x <= '0';  -- Rebote hacia la izquierda
								
						 elsif mov_x + "0000001000" > LADRILLO13_X + "0000101000" then
						 
								direccion_x <= '1';  -- Rebote hacia la derecha
								
						 end if;
					
					elsif ladrillo14_presente = '1' and
			  
                   (mov_x + "0000010000" > LADRILLO14_X and mov_x < LADRILLO14_X + LADRILLO_ANCHO and
                   mov_y + "0000010000" > LADRILLO14_Y and mov_y < LADRILLO14_Y + LADRILLO_ALTO) then
						 
                   ladrillo14_presente <= '0'; 
                   direccion_y <= not direccion_y;
						 
						 if mov_x + "0000001000" < LADRILLO14_X + "0000011000" then
						 
								direccion_x <= '0';  -- Rebote hacia la izquierda
								
						 elsif mov_x + "0000001000" > LADRILLO14_X + "0000101000" then
						 
								direccion_x <= '1';  -- Rebote hacia la derecha
								
						 end if;
						 
					elsif ladrillo15_presente = '1' and
			  
                   (mov_x + "0000010000" > LADRILLO15_X and mov_x < LADRILLO15_X + LADRILLO_ANCHO and
                   mov_y + "0000010000" > LADRILLO15_Y and mov_y < LADRILLO15_Y + LADRILLO_ALTO) then
						 
                   ladrillo15_presente <= '0'; 
                   direccion_y <= not direccion_y;
						 
						 if mov_x + "0000001000" < LADRILLO15_X + "0000011000" then
						 
								direccion_x <= '0';  -- Rebote hacia la izquierda
								
						 elsif mov_x + "0000001000" > LADRILLO15_X + "0000101000" then
						 
								direccion_x <= '1';  -- Rebote hacia la derecha
								
						 end if;
						 
					elsif ladrillo16_presente = '1' and
			  
                   (mov_x + "0000010000" > LADRILLO16_X and mov_x < LADRILLO16_X + LADRILLO_ANCHO and
                   mov_y + "0000010000" > LADRILLO16_Y and mov_y < LADRILLO16_Y + LADRILLO_ALTO) then
						 
                   ladrillo16_presente <= '0'; 
                   direccion_y <= not direccion_y;
						 
						 if mov_x + "0000001000" < LADRILLO16_X + "0000011000" then
						 
								direccion_x <= '0';  -- Rebote hacia la izquierda
								
						 elsif mov_x + "0000001000" > LADRILLO16_X + "0000101000" then
						 
								direccion_x <= '1';  -- Rebote hacia la derecha
								
						 end if;
						 
					elsif ladrillo17_presente = '1' and
			  
                   (mov_x + "0000010000" > LADRILLO17_X and mov_x < LADRILLO17_X + LADRILLO_ANCHO and
                   mov_y + "0000010000" > LADRILLO17_Y and mov_y < LADRILLO17_Y + LADRILLO_ALTO) then
						 
                   ladrillo17_presente <= '0'; 
                   direccion_y <= not direccion_y;
						 
						 if mov_x + "0000001000" < LADRILLO17_X + "0000011000" then
						 
								direccion_x <= '0';  -- Rebote hacia la izquierda
								
						 elsif mov_x + "0000001000" > LADRILLO17_X + "0000101000" then
						 
								direccion_x <= '1';  -- Rebote hacia la derecha
								
						 end if;
						 
					elsif ladrillo18_presente = '1' and
			  
                   (mov_x + "0000010000" > LADRILLO18_X and mov_x < LADRILLO18_X + LADRILLO_ANCHO and
                   mov_y + "0000010000" > LADRILLO18_Y and mov_y < LADRILLO18_Y + LADRILLO_ALTO) then
						 
                   ladrillo18_presente <= '0'; 
                   direccion_y <= not direccion_y;
						 
						 if mov_x + "0000001000" < LADRILLO18_X + "0000011000" then
						 
								direccion_x <= '0';  -- Rebote hacia la izquierda
								
						 elsif mov_x + "0000001000" > LADRILLO18_X + "0000101000" then
						 
								direccion_x <= '1';  -- Rebote hacia la derecha
								
						 end if;
						 
					elsif ladrillo19_presente = '1' and
			  
                   (mov_x + "0000010000" > LADRILLO19_X and mov_x < LADRILLO19_X + LADRILLO_ANCHO and
                   mov_y + "0000010000" > LADRILLO19_Y and mov_y < LADRILLO19_Y + LADRILLO_ALTO) then
						 
                   ladrillo19_presente <= '0'; 
                   direccion_y <= not direccion_y;
						 
						 if mov_x + "0000001000" < LADRILLO19_X + "0000011000" then
						 
								direccion_x <= '0';  -- Rebote hacia la izquierda
								
						 elsif mov_x + "0000001000" > LADRILLO19_X + "0000101000" then
						 
								direccion_x <= '1';  -- Rebote hacia la derecha
								
						 end if;
						 
					elsif ladrillo20_presente = '1' and
			  
                   (mov_x + "0000010000" > LADRILLO20_X and mov_x < LADRILLO20_X + LADRILLO_ANCHO and
                   mov_y + "0000010000" > LADRILLO20_Y and mov_y < LADRILLO20_Y + LADRILLO_ALTO) then
						 
                   ladrillo20_presente <= '0'; 
                   direccion_y <= not direccion_y;	 
						 
						 if mov_x + "0000001000" < LADRILLO20_X + "0000011000" then
						 
								direccion_x <= '0';  -- Rebote hacia la izquierda
								
						 elsif mov_x + "0000001000" > LADRILLO20_X + "0000101000" then
						 
								direccion_x <= '1';  -- Rebote hacia la derecha
								
						 end if;
						 
					end if;
				
----------------------  Rebote de la pelota con la Raqueta -----------------------------------------------------------------------------------	
				
					-- Detectar colisión con la raqueta
					if (mov_x + "0000010000" > movH and mov_x < movH + "0001000000" and
						mov_y + "0000010000" >= "0111100011" and mov_y < "0111110011") then
        
						direccion_y <= '0'; -- Hacer que la pelota rebote hacia arriba

        -- Ajustar la dirección y velocidad de la pelota según la zona de la raqueta
		  
					if mov_x + "0000001000" < movH + "0000010000" then
							direccion_x <= '0'; 
							mov_x <= mov_x - 10; 
					elsif mov_x + "0000001000" < movH + "0000100000" then
							direccion_x <= '0'; 
							mov_x <= mov_x - 8; 
					elsif mov_x + "0000001000" > movH + "0001100000" then
							direccion_x <= '1'; 
							mov_x <= mov_x + 10;
					elsif mov_x + "0000001000" > movH + "0001010000" then
							direccion_x <= '1'; 
							mov_x <= mov_x + 8; 
					else
							
							if direccion_x = '1' then
								mov_x <= mov_x + 1; 
							else
								mov_x <= mov_x - 1; 
							end if;
            
					end if;
    end if;
				end if;
			end if;
			end process PELOTA;

		
----------------------  Pintado de los objetos en la pantalla ---------------------------------------------------------------------------
		
		-- Colocar un fondo sobre toda la pantalla y la pelota
		PANTALLA : process (CONT800, CONT525, HST, VST)
		begin
			 if (HST = "10" and VST = "10") then
				  if ((CONT800 > ZV800I and CONT800 < ZV800F) and (CONT525 > ZV525I AND CONT525 < ZV525F)) then
						-- Verificar si la posición actual de la raqueta está dentro del plano horizontal
						if ((CONT800 > movH and CONT800 < movH + "0001000000") and (CONT525 > "0111100011" and CONT525 < "0111110011")) then
							 R <= "0000";  -- Color de la raqueta
							 G <= "1111";
							 B <= "1111";
							 
						elsif (CONT800 > mov_x and CONT800 < mov_x + "0000010000" and CONT525 > mov_y and CONT525 < mov_y + "0000010000") then
                        R <= "1111";  -- Color para la pelota
                        G <= "0000";
                        B <= "0101";
								
								
						elsif ladrillo1_presente = '1' and (CONT800 > LADRILLO1_X and CONT800 < LADRILLO1_X + LADRILLO_ANCHO and CONT525 > LADRILLO1_Y and CONT525 < LADRILLO1_Y + LADRILLO_ALTO) then
								R <= "1111";
								G <= "0000";
								B <= "0000";
								
						elsif ladrillo2_presente = '1' and (CONT800 > LADRILLO2_X and CONT800 < LADRILLO2_X + LADRILLO_ANCHO and CONT525 > LADRILLO2_Y and CONT525 < LADRILLO2_Y + LADRILLO_ALTO) then
								R <= "0000";
								G <= "1111";
								B <= "0000";
								
						elsif ladrillo3_presente = '1' and (CONT800 > LADRILLO3_X and CONT800 < LADRILLO3_X + LADRILLO_ANCHO and CONT525 > LADRILLO3_Y and CONT525 < LADRILLO3_Y + LADRILLO_ALTO) then
								R <= "0000";
								G <= "0000";
								B <= "1111";
								
						elsif ladrillo4_presente = '1' and (CONT800 > LADRILLO4_X and CONT800 < LADRILLO4_X + LADRILLO_ANCHO and CONT525 > LADRILLO4_Y and CONT525 < LADRILLO4_Y + LADRILLO_ALTO) then
								R <= "1111";
								G <= "0000";
								B <= "1111";
								
						elsif ladrillo5_presente = '1' and (CONT800 > LADRILLO5_X and CONT800 < LADRILLO5_X + LADRILLO_ANCHO and CONT525 > LADRILLO5_Y and CONT525 < LADRILLO5_Y + LADRILLO_ALTO) then
								R <= "0000";
								G <= "1111";
								B <= "1111";	
						
						elsif ladrillo6_presente = '1' and (CONT800 > LADRILLO6_X and CONT800 < LADRILLO6_X + LADRILLO_ANCHO and CONT525 > LADRILLO6_Y and CONT525 < LADRILLO6_Y + LADRILLO_ALTO) then
								R <= "1111";
								G <= "1111";
								B <= "1111";	
								
						elsif ladrillo7_presente = '1' and (CONT800 > LADRILLO7_X and CONT800 < LADRILLO7_X + LADRILLO_ANCHO and CONT525 > LADRILLO7_Y and CONT525 < LADRILLO7_Y + LADRILLO_ALTO) then
								R <= "1100";
								G <= "0011";
								B <= "1100";	
								
						elsif ladrillo8_presente = '1' and (CONT800 > LADRILLO8_X and CONT800 < LADRILLO8_X + LADRILLO_ANCHO and CONT525 > LADRILLO8_Y and CONT525 < LADRILLO8_Y + LADRILLO_ALTO) then
								R <= "1010";
								G <= "1010";
								B <= "1001";	
						
						elsif ladrillo9_presente = '1' and (CONT800 > LADRILLO9_X and CONT800 < LADRILLO9_X + LADRILLO_ANCHO and CONT525 > LADRILLO9_Y and CONT525 < LADRILLO9_Y + LADRILLO_ALTO) then
								R <= "0110";
								G <= "1001";
								B <= "1111";	
								
						elsif ladrillo10_presente = '1' and (CONT800 > LADRILLO10_X and CONT800 < LADRILLO10_X + LADRILLO_ANCHO and CONT525 > LADRILLO10_Y and CONT525 < LADRILLO10_Y + LADRILLO_ALTO) then
								R <= "1010";
								G <= "0101";
								B <= "1011";	
								
						elsif ladrillo11_presente = '1' and (CONT800 > LADRILLO11_X and CONT800 < LADRILLO11_X + LADRILLO_ANCHO and CONT525 > LADRILLO11_Y and CONT525 < LADRILLO11_Y + LADRILLO_ALTO) then
								R <= "0110";
								G <= "0110";
								B <= "0110";	
								
						elsif ladrillo12_presente = '1' and (CONT800 > LADRILLO12_X and CONT800 < LADRILLO12_X + LADRILLO_ANCHO and CONT525 > LADRILLO12_Y and CONT525 < LADRILLO12_Y + LADRILLO_ALTO) then
								R <= "1001";
								G <= "1001";
								B <= "1001";	
								
						elsif ladrillo13_presente = '1' and (CONT800 > LADRILLO13_X and CONT800 < LADRILLO13_X + LADRILLO_ANCHO and CONT525 > LADRILLO13_Y and CONT525 < LADRILLO13_Y + LADRILLO_ALTO) then
								R <= "1111";
								G <= "1111";
								B <= "1111";	
								
						elsif ladrillo14_presente = '1' and (CONT800 > LADRILLO14_X and CONT800 < LADRILLO14_X + LADRILLO_ANCHO and CONT525 > LADRILLO14_Y and CONT525 < LADRILLO14_Y + LADRILLO_ALTO) then
								R <= "0110";
								G <= "0110";
								B <= "1001";	
								
						elsif ladrillo15_presente = '1' and (CONT800 > LADRILLO15_X and CONT800 < LADRILLO15_X + LADRILLO_ANCHO and CONT525 > LADRILLO15_Y and CONT525 < LADRILLO15_Y + LADRILLO_ALTO) then
								R <= "1010";
								G <= "0101";
								B <= "1011";	
								
						elsif ladrillo16_presente = '1' and (CONT800 > LADRILLO16_X and CONT800 < LADRILLO16_X + LADRILLO_ANCHO and CONT525 > LADRILLO16_Y and CONT525 < LADRILLO16_Y + LADRILLO_ALTO) then
								R <= "0110";
								G <= "0110";
								B <= "1111";	
								
						elsif ladrillo17_presente = '1' and (CONT800 > LADRILLO17_X and CONT800 < LADRILLO17_X + LADRILLO_ANCHO and CONT525 > LADRILLO17_Y and CONT525 < LADRILLO17_Y + LADRILLO_ALTO) then
								R <= "0110";
								G <= "1111";
								B <= "0110";	
								
						elsif ladrillo18_presente = '1' and (CONT800 > LADRILLO18_X and CONT800 < LADRILLO18_X + LADRILLO_ANCHO and CONT525 > LADRILLO18_Y and CONT525 < LADRILLO18_Y + LADRILLO_ALTO) then
								R <= "1100";
								G <= "0011";
								B <= "1111";	
								
						elsif ladrillo19_presente = '1' and (CONT800 > LADRILLO19_X and CONT800 < LADRILLO19_X + LADRILLO_ANCHO and CONT525 > LADRILLO19_Y and CONT525 < LADRILLO19_Y + LADRILLO_ALTO) then
								R <= "1001";
								G <= "1101";
								B <= "1011";	
								
						elsif ladrillo20_presente = '1' and (CONT800 > LADRILLO20_X and CONT800 < LADRILLO20_X + LADRILLO_ANCHO and CONT525 > LADRILLO20_Y and CONT525 < LADRILLO20_Y + LADRILLO_ALTO) then
								R <= "1010";
								G <= "0101";
								B <= "1111";	
						else
							 R <= "0000";  -- Color negro para el fondo
							 G <= "0000";
							 B <= "0000";
						end if;
				  else
						R <= "0000";  -- Color negro para áreas fuera del fondo
						G <= "0000";
						B <= "0000";
				  end if; 
			 end if;
		end process PANTALLA;

end architecture;