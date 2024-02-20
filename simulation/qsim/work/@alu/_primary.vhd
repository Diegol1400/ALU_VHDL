library verilog;
use verilog.vl_types.all;
entity Alu is
    port(
        A               : in     vl_logic_vector(3 downto 0);
        B               : in     vl_logic_vector(3 downto 0);
        control         : in     vl_logic_vector(4 downto 0);
        leds            : out    vl_logic_vector(7 downto 0);
        salida          : out    vl_logic_vector(6 downto 0);
        salida2         : out    vl_logic_vector(6 downto 0)
    );
end Alu;
