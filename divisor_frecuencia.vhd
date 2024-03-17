-- Divisor de frecuencia a la mitad de una señal de reloj por medio de un FF-D

-- Maximiliano De La Cruz Lima	A01798048

-- Leyberth Jaaziel Castillo Guerra	A01749505

-- TE2002B
-- Librerías
library ieee;
use ieee.std_logic_1164.all;

-- Definición de la entidad
entity divisor_frecuencia is
	
	port ( CLK_in, RST : in std_logic;	-- Entradas
			 CLK_out : out std_logic);		-- Salidas
	
end entity;

-- Definición de la arquitectura
architecture RTL of divisor_frecuencia is
	
	-- Cables de interconexión:
	
	signal Q : std_logic;
	
	-- Descripción del circuito:
	
	begin
	
		FF : process (CLK_in, RST)
		
			begin
		
				if (RST = '0') then
					Q <= '0';
				elsif (CLK_in'EVENT and CLK_in = '1') then
					Q <= not(Q);
				end if;
				
		end process FF;
		
		CLK_out <= Q;
	
end architecture;