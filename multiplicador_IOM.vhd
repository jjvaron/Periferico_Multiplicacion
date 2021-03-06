-- multiplicador_IOM
-- Autores: Sebastián Parrado
--				Jelitza Varón
-------------------------------------------------------
LIBRARY IEEE;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
--USE ieee.std_logic_arith.all;
-------------------------------------------------------
ENTITY multiplicador_IOM IS
	GENERIC ( N		:	INTEGER	:= 8);
   PORT(   clk_M,IOM_M,cs_M	:	IN		STD_LOGIC;
           A_M,B_M				:	IN		STD_LOGIC_VECTOR(N-1 DOWNTO 0);
           product_out_M	:	OUT	STD_LOGIC_VECTOR((2*N)-1 DOWNTO 0));
END ENTITY multiplicador_IOM;
-------------------------------------------------------
ARCHITECTURE functional OF multiplicador_IOM IS
   SIGNAL  rst_s			: STD_LOGIC;
  	SIGNAL  A_s,B_s	: STD_LOGIC_VECTOR(N-1 DOWNTO 0);
	SIGNAL  product_s	: STD_LOGIC_VECTOR((2*N)-1 DOWNTO 0);
	SIGNAL  overflow_s	: STD_LOGIC;
-------------------------------------------------------
BEGIN
	PROCESS (clk_M,IOM_M,cs_M,A_M,B_M,rst_s,A_s,B_s,product_s)
	BEGIN
		rst_s <= IOM_M;
		IF (rst_s = '1') THEN
			A_s <= A_M;
			B_s <= B_M;
			product_s <= (OTHERS => '0');
		ELSIF (rising_edge(clk_M)) THEN
			A_s <= A_M;
			B_s <= B_M;
			IF (cs_M = '1' AND IOM_M = '0') THEN
-------------------------------------------------------
--------- Bucle de repetición de la operación ---------
				looper: FOR i IN 0 TO N-1 LOOP
					IF (B_s(0) = '1') THEN			-- Si el LSB es 1
						product_s <= STD_LOGIC_VECTOR(unsigned(A_s)+unsigned(product_s)); -- C=A+C
					ElSIF ( (A_s OR B_s) = "00000000") THEN
						product_out_M <= product_s;
					END IF;
				A_s <= A_s(A_s'LEFT-1 DOWNTO 0) & '0';	-- Multilicando A. Desplazamiento 1 bit a la izquierda
				B_s <= '0' & B_s(B_s'LEFT DOWNTO 1);	-- Multiplicador B. Desplzamiento 1 bit a la derecha
				END LOOP looper;
			END IF;
		END IF;
	END PROCESS;   
END ARCHITECTURE;
