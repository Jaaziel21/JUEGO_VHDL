-- Librerías
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

-- Definición de la entidad
entity FIGURA is
    port (
        CONT800, CONT525 : in std_logic_vector (9 downto 0);    -- Entradas
        CLK : in std_logic;
        HST, VST : in std_logic_vector (1 downto 0);            -- Salidas
        R, G, B : out std_logic_vector (3 downto 0)
    );
end entity;

-- Definición de la arquitectura
architecture RTL of FIGURA is
    constant ZV800I : std_logic_vector (9 downto 0) := "0010001111";
    constant ZV800F : std_logic_vector (9 downto 0) := "1100010000";
    constant ZV525I : std_logic_vector (9 downto 0) := "0000100010";
    constant ZV525F : std_logic_vector (9 downto 0) := "1000000011";
    
    constant izq    : std_logic_vector (9 downto 0) := "0010001111"; -- 143
    constant der    : std_logic_vector (9 downto 0) := "1100001111"; -- 783
    constant ARRIBA : std_logic_vector (9 downto 0) := "0000100010"; -- 66
    constant ABAJO  : std_logic_vector (9 downto 0) := "1000000011"; -- 515
    
    constant BLOQUE_X : std_logic_vector(9 downto 0) := "0111111111";
    constant BLOQUE_Y : std_logic_vector(9 downto 0) := "0001000000";
    
    signal mov_x : std_logic_vector (9 downto 0) := "0010001111";
    signal mov_y : std_logic_vector (9 downto 0) := "0100000000";
	 
    signal direccion_x : std_logic := '1'; -- '1' para derecha, '0' para izquierda
    signal direccion_y : std_logic := '1'; -- '1' para abajo, '0' para arriba
    signal ladrillo_presente : std_logic := '1'; -- '1' indica que el ladrillo está presente

    -- Descripción del circuito
    begin
        -- Proceso para controlar la posición de la pelota
        process (CLK)
        begin
            if rising_edge(CLK) then
                -- Actualizar la posición de la pelota en cada ciclo de reloj
                if direccion_x = '1' then
                    if mov_x < der then
                        mov_x <= mov_x + "0000000001";
                    else
                        direccion_x <= '0';
                    end if;
                else
                    if mov_x > izq then
                        mov_x <= mov_x - "0000000001";
                    else
                        direccion_x <= '1';
                    end if;
                end if;
                
                if direccion_y = '1' then
                    if mov_y < ABAJO then
                        mov_y <= mov_y + "0000000001";
                    else
                        direccion_y <= '0';
                    end if;
                else
                    if mov_y > ARRIBA then
                        mov_y <= mov_y - "0000000001";
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
            end if;
        end process;
        
        -- Colocar un fondo sobre toda la pantalla y la pelota
        FONDO : process (CONT800, CONT525, HST, VST)
        begin
            if (HST = "10" and VST = "10") then
                if ((CONT800 > ZV800I and CONT800 < ZV800F) and (CONT525 > ZV525I AND CONT525 < ZV525F)) then
                    -- Verificar si la posición actual está dentro de la posición de la pelota
                    if ((CONT800 >= mov_x + "0000001000" and CONT800 <= mov_x + "0000011000" and
								 CONT525 >= mov_y + "0000000100" and CONT525 <= mov_y + "0000011100") or
								(CONT800 >= mov_x + "0000000100" and CONT800 <= mov_x + "0000011100" and
								(CONT525 >= mov_y + "0000001000" and CONT525 <= mov_y + "0000011000"))) then
								R <= "1111";  -- Color rojo para la pelota
								G <= "1111";
								B <= "1111";
                    elsif ladrillo_presente = '1' and (CONT800 > BLOQUE_X and CONT800 < BLOQUE_X + "0001000000" AND CONT525 > BLOQUE_Y AND CONT525 < BLOQUE_Y + "0000100000") then
                        R <= "1111";  -- Color para los bloques 
                        G <= "1111";
                        B <= "0000";
                    else
                        R <= "0011";  -- Color blanco para el fondo
                        G <= "0010";
                        B <= "0101";
                    end if;
                else
                    R <= "0000";  -- Color negro para áreas fuera del fondo
                    G <= "0000";
                    B <= "0000";
                end if;
            end if;
        end process FONDO;

end architecture;
