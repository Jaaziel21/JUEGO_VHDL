-- Librerías
library ieee;
use ieee.std_logic_1164.all;

-- Definición de la entidad
entity mas_uno_10bits is
	
	port ( A		: in 	std_logic_vector (9 downto 0);	-- Entradas
			 Z		: out std_logic_vector (9 downto 0);	-- Salidas
			 Cout	: out std_logic );
	
end entity;

-- Definición de la arquitectura
architecture RTL of mas_uno_10bits is
	
	-- Definición de los componentes
		
			-- Definición del uso de componente HA
			
			component HA1 is
				
				port (A, B : in std_logic;			-- Entradas
						S, Co : out std_logic);	-- Salidas
				
			end component HA1;
			
		-- Cables de interconexión
		
		signal C 	: std_logic_vector (9 downto 1);
		signal Co	: std_logic;
		
		-- Descripción del circuito
		
		begin
		
			HA  : HA1 port map ( A(0), '1', 	Z(0), C(1) );
			HA2  : HA1 port map ( A(1), C(1), Z(1), C(2) );
			HA3  : HA1 port map ( A(2), C(2), Z(2), C(3) );
			HA4  : HA1 port map ( A(3), C(3), Z(3), C(4) );
			HA5  : HA1 port map ( A(4), C(4), Z(4), C(5) );
			HA6  : HA1 port map ( A(5), C(5), Z(5), C(6) );
			HA7  : HA1 port map ( A(6), C(6), Z(6), C(7) );
			HA8  : HA1 port map ( A(7), C(7), Z(7), C(8) );
			HA9  : HA1 port map ( A(8), C(8), Z(8), C(9) );
			HA10 : HA1 port map ( A(9), C(9), Z(9), Co );
			
			Cout <= Co;
	
end architecture;