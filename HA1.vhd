--Leyberth Jaaziel Castillo Guerra - A01749505
-- Circuito Half Adder --
-- Curso: TE2002B --

-- Sección para la definición de librerías

library ieee;
use ieee.std_logic_1164.all;

--declaramos la entidad

entity HA1 is 

	port(a, b : in std_logic;
			s, co : out std_logic);
			
end entity;


-- delcaramos la arquitectura

architecture RTL of HA1 is
	-- aqui se definen componentes y señales
	begin
			
		s <= a xor b;
		co <= a and b;

	end architecture;
	
