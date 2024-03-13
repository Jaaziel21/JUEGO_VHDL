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
	--signal movV : std_logic_vector (9 downto 0) := "0100010010";
	
	-- BLOQUE
	
	
    constant BLOQUE_X : std_logic_vector(9 downto 0) := "0111111111";
    constant BLOQUE_Y : std_logic_vector(9 downto 0) := "0001000000";
	 
	-- Pelota
	signal mov_x : std_logic_vector (9 downto 0) := "0111001111";	-- 463 (CENTRO)
   signal mov_y : std_logic_vector (9 downto 0) := "0100000000";
   signal direccion_x : std_logic := '1'; -- '1' para derecha, '0' para izquierda
   signal direccion_y : std_logic := '1'; -- '1' para abajo, '0' para arriba
	signal ladrillo_presente : std_logic := '1'; -- '1' indica que el ladrillo está presente
	
	--signal movXPos : std_logic_vector (9 downto 0) := "0010001111";
	--signal movXNeg : std_logic_vector (9 downto 0) := "1100001111";
	
	--constant ZV800I : std_logic_vector (9 downto 0) := "0010010000";
	--constant ZV800F : std_logic_vector (9 downto 0) := "1100001111";
	--constant ZV525I : std_logic_vector (9 downto 0) := "0000100011";
	--constant ZV525F : std_logic_vector (9 downto 0) := "1000000010";
	
	-- Descripción del circuito
	begin

		-- Proceso para controlar la posición de la raqueta
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
		
		-- Proceso para controlar la posición de la pelota
		PELOTA : process (CLK, mov_x, mov_y, direccion_x, direccion_y)
		begin
			-- Actualizar la posición de la pelota cada 60Hz
			if (CLK'EVENT and CLK = '1') then
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
						direccion_y <= '0';
					end if;
				else
               if (mov_y > limsup) then
						mov_y <= mov_y - 5-;
               else
                  direccion_y <= '1';
               end if;
				end if;
			
				-- Detectar colisión con el ladrillo
            if ladrillo_presente = '1' and
                   mov_x + "0000100000" > BLOQUE_X and mov_x < BLOQUE_X + "0001000000" and
                   mov_y + "0000100000" > BLOQUE_Y and mov_y < BLOQUE_Y + "0000100000" then
                   ladrillo_presente <= '0'; 
                   direccion_y <= not direccion_y; -- Cambiar la dirección de la pelota
            end if;
				
				if (mov_x + "0000010000" > movH and mov_x < movH + "0001000000" and
            mov_y + "0000010000" >= "0111100011" and mov_y < "0111110011") then
            direccion_y <= '0'; -- Hacer que la pelota rebote hacia arriba
				
				end if;
         end if;
			
		end process PELOTA;
		
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
								
						elsif ladrillo_presente = '1' and (CONT800 > BLOQUE_X and CONT800 < BLOQUE_X + "0001000000" AND CONT525 > BLOQUE_Y AND CONT525 < BLOQUE_Y + "0000100000") then
                        R <= "1111";  -- Color para los bloques 
                        G <= "1111";
                        B <= "0000";
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