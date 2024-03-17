-- Top Level con la integración de todos los componentes
-- Leyberth Jaaziel Castillo Guerra	A01749505
-- Maximiliano De La Cruz Lima	A01798048
-- TE2002B

-- Librerías
library ieee;
use ieee.std_logic_1164.all;

-- Definición de la entidad
entity PANTALLA_VGA is
	
	port ( CLK, RST, START : in std_logic;
			 IZQ, DER, RESET : in std_logic;
			 VSYNC, HSYNC : out std_logic;
			 R, G, B : out std_logic_vector ( 3 downto 0) );
	
end entity;

-- Definiicón de la arquitectura
architecture RTL of PANTALLA_VGA is
	
	-- Definición de los componentes
		
			-- Definición del uso de componente DIV_FREC
			
			component divisor_frecuencia is
	
				port ( CLK_in, RST : in std_logic;	-- Entradas
						 CLK_out : out std_logic);		-- Salidas
				
			end component divisor_frecuencia;
			
			-- Definición del uso de componente CONT800
			
			component contador800 is
	
				port ( CLK, RST, START : in std_logic;				-- Entradas
						 CNT : out std_logic_vector (9 downto 0);	-- Salidas
						 OVout : out std_logic);
				
			end component contador800;
			
			-- Definición del uso de componente CONT525
			
			component contador500 is
	
				port ( CLK, RST, START : in std_logic;				-- Entradas
						 CNT : out std_logic_vector (9 downto 0);	-- Salidas
						 OVout : out std_logic);
				
			end component contador500;
			
			-- Definición del uso de componente V_SYNC
			
			component V_SYNC is
	
				port ( CLK, RST, START : in std_logic;						-- Entradas
						 CNT525 : in std_logic_vector (9 downto 0);
						 VSYNC : out std_logic;									-- Salidas
						 VSYNCST : out std_logic_vector (1 downto 0));
				
			end component V_SYNC;
			
			-- Definición del uso de componente V_SYNC
			
			component H_SYNC is
	
				port ( CLK, RST, START : in std_logic;						-- Entradas
						 CNT800 : in std_logic_vector (9 downto 0);
						 HSYNC : out std_logic;									-- Salidas
						 HSYNCST : out std_logic_vector (1 downto 0));
				
			end component H_SYNC;
			
			-- Definición del uso de componente FIGURA
			
			component FIGURA is
	
				port ( CONT800, CONT525 : in std_logic_vector (9 downto 0);	-- Entradas
						 CLK : in std_logic;
						 IZQ, DER, RESET : in std_logic;
						 HST, VST : in std_logic_vector (1 downto 0);			-- Salidas
						 R, G, B : out std_logic_vector ( 3 downto 0) );
						 
			end component FIGURA;
			
	-- Cables de interconexión
	
	signal CLK_DIV	: std_logic;
	signal CUENTA800, CUENTA525 : std_logic_vector (9 downto 0);
	signal OV : std_logic;
	signal VSYNCST, HSYNCST : std_logic_vector (1 downto 0);
	signal HZ : std_logic;
	--signal VSYNC, HSYNC : std_logic;
	
	-- Descripción del circuito
	
	begin
	
		DIV	: divisor_frecuencia port map ( CLK, RST, CLK_DIV );
		C800	: contador800 	port map	( CLK_DIV, RST, START, CUENTA800, OV );
		C525	: contador500	port map ( OV, RST, START, CUENTA525, HZ );
		VERT	: V_SYNC		port map ( CLK_DIV, RST, START, CUENTA525, VSYNC, VSYNCST);
		HOR	: H_SYNC		port map ( CLK_DIV, RST, START, CUENTA800, HSYNC, HSYNCST);
		DIB	: FIGURA		port map	( CUENTA800, CUENTA525, HZ, IZQ, DER, RESET, HSYNCST, VSYNCST, R, G, B );
	
end architecture;