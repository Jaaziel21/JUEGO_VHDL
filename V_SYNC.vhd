-- Librerías
library ieee;
use ieee.std_logic_1164.all;

-- Definición de la entidad
entity V_SYNC is
	
	port ( CLK, RST, START : in std_logic;						-- Entradas
			 CNT525 : in std_logic_vector (9 downto 0);
			 VSYNC : out std_logic;									-- Salidas
			 VSYNCST : out std_logic_vector (1 downto 0));
	
end entity;

-- Definición de la arquitectura
architecture RTL of V_SYNC is
	
	-- Pulso de sicronización vertical, Back Porch, Zona Visible, Front Porch
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
		Transiciones : process (EDO, CNT525, START) is
		
			begin
				
				case EDO is
				
					when IDLE	=>	if (START = '1') then
											EDOF <= PSY;
										else
											EDOF <= IDLE;
										end if;
											
					when PSY 	=> if (CNT525 = "0000000001") then	-- 1
											EDOF <= BP;
										else
											EDOF <= PSY;
										end if;
											
					when BP		=> if (CNT525 = "0000100010") then	-- 1+33=34
											EDOF <= ZV;
										else
											EDOF <= BP;
										end if;
											
					when ZV		=>	if (CNT525 = "1000000010") then	-- 34+480=514
											EDOF <= FP;
										else
											EDOF <= ZV;
										end if;
					
					when FP		=> if (CNT525 = "1000001100") then	-- 524
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
			
				case EDO is
					
					when PSY 	=> VSYNC		<= '0';
										VSYNCST	<= "00";
										
										
					when BP 		=> VSYNC		<= '1';
										VSYNCST	<= "01";
										
					when ZV 		=> VSYNC		<= '1';
										VSYNCST	<= "10";
										
					when FP 		=> VSYNC		<= '1';
										VSYNCST	<= "11";
										
					when others	=>	null;
											
				end case;
				
		end process Salidas;
	
end architecture;