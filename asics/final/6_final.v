module round_robin_arbiter (clk,
    rst,
    grant,
    request);
 input clk;
 input rst;
 output [3:0] grant;
 input [3:0] request;

 wire _000_;
 wire _001_;
 wire _002_;
 wire _003_;
 wire _004_;
 wire _005_;
 wire _006_;
 wire _007_;
 wire _008_;
 wire _009_;
 wire _010_;
 wire _011_;
 wire _012_;
 wire _013_;
 wire _014_;
 wire _015_;
 wire _016_;
 wire _017_;
 wire _019_;
 wire _020_;
 wire _021_;
 wire _022_;
 wire _023_;
 wire _024_;
 wire _025_;
 wire _026_;
 wire _027_;
 wire _028_;
 wire _029_;
 wire _030_;
 wire _031_;
 wire _032_;
 wire _033_;
 wire _034_;
 wire _035_;
 wire _036_;
 wire _037_;
 wire _038_;
 wire _039_;
 wire _040_;
 wire _041_;
 wire _042_;
 wire _043_;
 wire _044_;
 wire _045_;
 wire _046_;
 wire _047_;
 wire _048_;
 wire _049_;
 wire _050_;
 wire _051_;
 wire _052_;
 wire _053_;
 wire _054_;
 wire _055_;
 wire _056_;
 wire _057_;
 wire _058_;
 wire _059_;
 wire _060_;
 wire _061_;
 wire _062_;
 wire _063_;
 wire _064_;
 wire _065_;
 wire _066_;
 wire _067_;
 wire _068_;
 wire _069_;
 wire _070_;
 wire _071_;
 wire _072_;
 wire _073_;
 wire _074_;
 wire _075_;
 wire _076_;
 wire _077_;
 wire _078_;
 wire _079_;
 wire _080_;
 wire _081_;
 wire _082_;
 wire _083_;
 wire _084_;
 wire _085_;
 wire _086_;
 wire _087_;
 wire _088_;
 wire _089_;
 wire _090_;
 wire _091_;
 wire _092_;
 wire _093_;
 wire _094_;
 wire _095_;
 wire \actual_requester[0] ;
 wire net6;
 wire net7;
 wire net8;
 wire net9;
 wire \pointer[0] ;
 wire \pointer[1] ;
 wire net1;
 wire net2;
 wire net3;
 wire net4;
 wire net5;
 wire clknet_0_clk;
 wire clknet_1_0__leaf_clk;
 wire clknet_1_1__leaf_clk;

 INV_X4 _097_ (.A(\pointer[0] ),
    .ZN(_019_));
 NAND2_X2 _098_ (.A1(_027_),
    .A2(\pointer[1] ),
    .ZN(_028_));
 NAND2_X4 _099_ (.A1(_024_),
    .A2(_028_),
    .ZN(_029_));
 NAND2_X2 _100_ (.A1(_019_),
    .A2(net4),
    .ZN(_030_));
 NAND2_X1 _101_ (.A1(\pointer[0] ),
    .A2(net3),
    .ZN(_031_));
 NAND2_X2 _102_ (.A1(_030_),
    .A2(_031_),
    .ZN(_032_));
 INV_X2 _103_ (.A(_032_),
    .ZN(_033_));
 NAND2_X2 _104_ (.A1(_033_),
    .A2(_004_),
    .ZN(_034_));
 NAND2_X1 _105_ (.A1(_019_),
    .A2(net2),
    .ZN(_035_));
 NAND2_X1 _106_ (.A1(\pointer[0] ),
    .A2(net1),
    .ZN(_036_));
 INV_X1 _107_ (.A(_004_),
    .ZN(_037_));
 NAND2_X4 _108_ (.A1(_019_),
    .A2(net1),
    .ZN(_020_));
 NAND3_X2 _109_ (.A1(_035_),
    .A2(_036_),
    .A3(_037_),
    .ZN(_038_));
 AOI21_X4 _110_ (.A(_029_),
    .B1(_034_),
    .B2(_038_),
    .ZN(_039_));
 NAND3_X1 _111_ (.A1(_025_),
    .A2(_026_),
    .A3(_023_),
    .ZN(_040_));
 NAND3_X1 _112_ (.A1(_020_),
    .A2(_021_),
    .A3(\pointer[1] ),
    .ZN(_041_));
 NAND2_X1 _113_ (.A1(_040_),
    .A2(_041_),
    .ZN(_042_));
 INV_X1 _114_ (.A(_003_),
    .ZN(_043_));
 NAND2_X1 _115_ (.A1(_033_),
    .A2(_043_),
    .ZN(_044_));
 NAND3_X2 _116_ (.A1(_039_),
    .A2(_042_),
    .A3(_044_),
    .ZN(_045_));
 INV_X2 _117_ (.A(_045_),
    .ZN(_046_));
 NAND2_X1 _118_ (.A1(_035_),
    .A2(_036_),
    .ZN(_047_));
 NAND2_X1 _119_ (.A1(\pointer[0] ),
    .A2(net2),
    .ZN(_021_));
 OAI21_X4 _120_ (.A(_046_),
    .B1(_043_),
    .B2(_047_),
    .ZN(_048_));
 INV_X1 _121_ (.A(_048_),
    .ZN(_049_));
 INV_X1 _122_ (.A(_001_),
    .ZN(_050_));
 OAI21_X1 _123_ (.A(_049_),
    .B1(_050_),
    .B2(_002_),
    .ZN(_051_));
 INV_X1 _124_ (.A(_042_),
    .ZN(_052_));
 NAND2_X2 _125_ (.A1(_039_),
    .A2(_052_),
    .ZN(_053_));
 INV_X1 _126_ (.A(_053_),
    .ZN(_054_));
 NAND2_X1 _127_ (.A1(_054_),
    .A2(_037_),
    .ZN(_055_));
 INV_X1 _128_ (.A(_034_),
    .ZN(_056_));
 NOR2_X2 _129_ (.A1(_029_),
    .A2(_056_),
    .ZN(_057_));
 NAND2_X1 _130_ (.A1(_020_),
    .A2(_021_),
    .ZN(_022_));
 NAND2_X1 _131_ (.A1(_057_),
    .A2(_038_),
    .ZN(_058_));
 INV_X1 _132_ (.A(_006_),
    .ZN(_059_));
 OAI22_X1 _133_ (.A1(_058_),
    .A2(_059_),
    .B1(_057_),
    .B2(_037_),
    .ZN(_060_));
 INV_X1 _134_ (.A(_039_),
    .ZN(_061_));
 NAND2_X1 _135_ (.A1(_060_),
    .A2(_061_),
    .ZN(_062_));
 NAND3_X1 _136_ (.A1(_048_),
    .A2(_055_),
    .A3(_062_),
    .ZN(_063_));
 NAND2_X1 _137_ (.A1(_051_),
    .A2(_063_),
    .ZN(_064_));
 NOR2_X1 _138_ (.A1(_061_),
    .A2(_052_),
    .ZN(_065_));
 NAND3_X1 _139_ (.A1(_048_),
    .A2(\pointer[1] ),
    .A3(_065_),
    .ZN(_066_));
 AOI21_X1 _140_ (.A(net5),
    .B1(_064_),
    .B2(_066_),
    .ZN(_010_));
 INV_X1 _141_ (.A(\pointer[1] ),
    .ZN(_023_));
 NAND4_X1 _142_ (.A1(_039_),
    .A2(_043_),
    .A3(_032_),
    .A4(_042_),
    .ZN(_067_));
 NAND4_X1 _143_ (.A1(_039_),
    .A2(_047_),
    .A3(_042_),
    .A4(_044_),
    .ZN(_068_));
 OR2_X1 _144_ (.A1(_058_),
    .A2(_005_),
    .ZN(_069_));
 NAND3_X1 _145_ (.A1(_067_),
    .A2(_068_),
    .A3(_069_),
    .ZN(_070_));
 NAND2_X1 _146_ (.A1(_046_),
    .A2(_002_),
    .ZN(_071_));
 NAND2_X1 _147_ (.A1(_070_),
    .A2(_071_),
    .ZN(_072_));
 NAND2_X2 _148_ (.A1(_048_),
    .A2(_065_),
    .ZN(_073_));
 NAND3_X1 _149_ (.A1(_039_),
    .A2(_007_),
    .A3(_052_),
    .ZN(_074_));
 INV_X1 _150_ (.A(\actual_requester[0] ),
    .ZN(_075_));
 AOI21_X1 _151_ (.A(_075_),
    .B1(_057_),
    .B2(_038_),
    .ZN(_076_));
 NAND2_X2 _152_ (.A1(_022_),
    .A2(_023_),
    .ZN(_024_));
 NAND2_X1 _153_ (.A1(_074_),
    .A2(_076_),
    .ZN(_077_));
 AND2_X1 _154_ (.A1(_053_),
    .A2(_008_),
    .ZN(_078_));
 NOR2_X1 _155_ (.A1(_077_),
    .A2(_078_),
    .ZN(_079_));
 NAND2_X1 _156_ (.A1(_048_),
    .A2(_079_),
    .ZN(_080_));
 NAND3_X1 _157_ (.A1(_072_),
    .A2(_073_),
    .A3(_080_),
    .ZN(_081_));
 INV_X1 _158_ (.A(net5),
    .ZN(_082_));
 NAND2_X1 _159_ (.A1(_081_),
    .A2(_082_),
    .ZN(_083_));
 AOI21_X1 _160_ (.A(\pointer[0] ),
    .B1(_072_),
    .B2(_073_),
    .ZN(_084_));
 NOR2_X2 _161_ (.A1(_083_),
    .A2(_084_),
    .ZN(_009_));
 NOR2_X1 _162_ (.A1(_029_),
    .A2(_019_),
    .ZN(_085_));
 NAND2_X4 _163_ (.A1(_019_),
    .A2(net3),
    .ZN(_025_));
 AOI21_X2 _164_ (.A(_076_),
    .B1(_053_),
    .B2(_085_),
    .ZN(_086_));
 NAND2_X4 _165_ (.A1(_048_),
    .A2(_086_),
    .ZN(_087_));
 OAI21_X4 _166_ (.A(_087_),
    .B1(_075_),
    .B2(_048_),
    .ZN(_088_));
 INV_X4 _167_ (.A(_088_),
    .ZN(_089_));
 NAND2_X2 _168_ (.A1(_089_),
    .A2(_073_),
    .ZN(_090_));
 INV_X1 _169_ (.A(_067_),
    .ZN(_091_));
 NAND2_X1 _170_ (.A1(_054_),
    .A2(_000_),
    .ZN(_011_));
 INV_X1 _171_ (.A(_011_),
    .ZN(_012_));
 OAI21_X1 _172_ (.A(_028_),
    .B1(_058_),
    .B2(_037_),
    .ZN(_013_));
 NOR3_X2 _173_ (.A1(_091_),
    .A2(_012_),
    .A3(_013_),
    .ZN(_014_));
 NAND2_X1 _174_ (.A1(\pointer[0] ),
    .A2(net4),
    .ZN(_026_));
 NOR2_X2 _175_ (.A1(_090_),
    .A2(_014_),
    .ZN(net8));
 NAND3_X1 _176_ (.A1(_088_),
    .A2(_073_),
    .A3(_014_),
    .ZN(_015_));
 INV_X1 _177_ (.A(_015_),
    .ZN(net7));
 INV_X1 _178_ (.A(_014_),
    .ZN(_016_));
 NOR2_X2 _179_ (.A1(_090_),
    .A2(_016_),
    .ZN(net6));
 NAND3_X1 _180_ (.A1(_088_),
    .A2(_073_),
    .A3(_016_),
    .ZN(_017_));
 INV_X1 _181_ (.A(_017_),
    .ZN(net9));
 NAND2_X2 _182_ (.A1(_025_),
    .A2(_026_),
    .ZN(_027_));
 FA_X1 _183_ (.A(\pointer[0] ),
    .B(\pointer[1] ),
    .CI(\actual_requester[0] ),
    .CO(_001_),
    .S(_092_));
 HA_X1 _184_ (.A(\actual_requester[0] ),
    .B(_000_),
    .CO(_002_),
    .S(_003_));
 HA_X1 _185_ (.A(\actual_requester[0] ),
    .B(_004_),
    .CO(_005_),
    .S(_006_));
 HA_X1 _186_ (.A(\actual_requester[0] ),
    .B(_000_),
    .CO(_093_),
    .S(_004_));
 HA_X1 _187_ (.A(\pointer[0] ),
    .B(_000_),
    .CO(_007_),
    .S(_094_));
 HA_X1 _188_ (.A(\pointer[0] ),
    .B(\pointer[1] ),
    .CO(_008_),
    .S(_095_));
 CLKBUF_X2 clkbuf_0_clk (.A(clk),
    .Z(clknet_0_clk));
 CLKBUF_X2 clkbuf_1_0__f_clk (.A(clknet_0_clk),
    .Z(clknet_1_0__leaf_clk));
 CLKBUF_X2 clkbuf_1_1__f_clk (.A(clknet_0_clk),
    .Z(clknet_1_1__leaf_clk));
 BUF_X1 input1 (.A(request[0]),
    .Z(net1));
 BUF_X1 input2 (.A(request[1]),
    .Z(net2));
 BUF_X1 input3 (.A(request[2]),
    .Z(net3));
 BUF_X1 input4 (.A(request[3]),
    .Z(net4));
 BUF_X1 input5 (.A(rst),
    .Z(net5));
 BUF_X1 output6 (.A(net6),
    .Z(grant[0]));
 BUF_X1 output7 (.A(net7),
    .Z(grant[1]));
 BUF_X1 output8 (.A(net8),
    .Z(grant[2]));
 BUF_X1 output9 (.A(net9),
    .Z(grant[3]));
 DFF_X1 \pointer[0]$_SDFFE_PP0P_  (.D(_009_),
    .CK(clknet_1_0__leaf_clk),
    .Q(\pointer[0] ),
    .QN(\actual_requester[0] ));
 DFF_X1 \pointer[1]$_SDFFE_PP0P_  (.D(_010_),
    .CK(clknet_1_1__leaf_clk),
    .Q(\pointer[1] ),
    .QN(_000_));
endmodule
