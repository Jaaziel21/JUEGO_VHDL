-- Librerías
library ieee;
use ieee.std_logic_1164.all;

-- Definición de la entidad
entity contador800 is
	
	port ( CLK, RST, START : in std_logic;				-- Entradas
			 CNT : out std_logic_vector (9 downto 0);	-- Salidas
			 OVout : out std_logic);
	
end entity;

-- Definición de la arquitectura
architecture RTL of contador800 is
	
	-- Definición de los componentes
		
			-- Definición del uso de componente SUMA_10BITS
			
			component mas_uno_10bits is
				
				port ( A		: in 	std_logic_vector (9 downto 0);	-- Entradas
						 Z		: out std_logic_vector (9 downto 0);	-- Salidas
						 Cout	: out std_logic );
				
			end component mas_uno_10bits;
			
		-- Cables de interconexión
		
		signal D, Q 		: std_logic_vector (9 downto 0);
		signal O	: std_logic;
		
		-- Descripción del circuito
		
		begin
		
			SUMA10 : mas_uno_10bits port map ( Q, D, O );
			
			FFD : process (CLK, RST)
			
				begin
				
					if (RST = '0') then
						Q <= "0000000000";
						OVout <= '0';
					elsif (CLK'EVENT and CLK = '1') then
						if (START = '1') then
							Q <= D;
						end if;
						if (Q = "1100011111") then
							Q <= "0000000000";
							OVout <= '1';
						else
							OVout <= '0';
						end if;
					end if;
					
			end process FFD;	
			
			CNT <= Q;
			
end architecture;