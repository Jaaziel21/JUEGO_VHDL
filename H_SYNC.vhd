-- Máquina de estados para la sincronización horizontal
-- Leyberth Jaaziel Castillo Guerra	A01749505
-- Maximiliano De La Cruz Lima	A01798048
-- TE2002B

-- Librerías
library ieee;
use ieee.std_logic_1164.all;

-- Definición de la entidad
entity H_SYNC is
	
	port ( CLK, RST, START : in std_logic;						-- Entradas
			 CNT800 : in std_logic_vector (9 downto 0);
			 HSYNC : out std_logic;									-- Salidas
			 HSYNCST : out std_logic_vector (1 downto 0) );
	
end entity;

-- Definición de la arquitectura
architecture RTL of H_SYNC is
	
	-- Pulso de sicronización horizontal, Back Porch, Zona Visible, Front Porch
	type EDOS is ( IDLE, PSY, BP, ZV, FP );
	
	signal EDO, EDOF : EDOS;
	
	-- Descripción del circuito
	
	begin
	
		-- Primer proceso: FF tipo D (RST asíncrono)
		FFD : process (CLK, RST) is
			
			begin
				
				if (RST = '0') then
					EDO <= IDLE;
				elsif (CLK'EVENT and CLK = '1') then
					EDO <= EDOF;
				end if;
				
		end process FFD;
		
		-- Segundo proceso: manejo de transiciones
		Transiciones : process (EDO, CNT800, START) is
		
			begin
				
				case EDO is
				
					when IDLE	=>	if (START = '1') then
											EDOF <= PSY;
										else
											EDOF <= IDLE;
										end if;
											
					when PSY 	=> if (CNT800 = "0001011111") then	-- 95
											EDOF <= BP;
										else
											EDOF <= PSY;
										end if;
											
					when BP		=> if (CNT800 = "0010001111") then	-- 95+48=143
											EDOF <= ZV;
										else
											EDOF <= BP;
										end if;
											
					when ZV		=>	if (CNT800 = "1100001111") then	-- 143+640=783
											EDOF <= FP;
										else
											EDOF <= ZV;
										end if;
					
					when FP		=> if (CNT800 = "1100011111") then	-- 799 "1100011111"
											EDOF <= PSY;
										else
											EDOF <= FP;
										end if;	
						
					when others	=>	null;
											
				end case;
				
		end process Transiciones;
		
		-- Tercer proceso: manejo de las salidas dependientes de las transiciones
		Salidas : process (EDO) is
			
			begin	
			
				CASE EDO IS
					
					when PSY 	=> HSYNC		<= '0';
										HSYNCST	<= "00";
										
										
					when BP 		=> HSYNC		<= '1';
										HSYNCST	<= "01";
										
					when ZV 		=> HSYNC		<= '1';
										HSYNCST	<= "10";
										
					when FP 		=> HSYNC		<= '1';
										HSYNCST	<= "11";
										
					when others	=>	null;
	
			end case;
				
		end process Salidas;
	
end architecture;