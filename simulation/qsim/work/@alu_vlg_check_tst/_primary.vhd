library verilog;
use verilog.vl_types.all;
entity Alu_vlg_check_tst is
    port(
        leds            : in     vl_logic_vector(7 downto 0);
        salida          : in     vl_logic_vector(6 downto 0);
        salida2         : in     vl_logic_vector(6 downto 0);
        sampler_rx      : in     vl_logic
    );
end Alu_vlg_check_tst;
