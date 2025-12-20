// TECLADO COMEÇA NA LINHA 38 E TERMINA NA LINHA 444
// SETUP COMEÇA NA LINHA 446 E TERMINA NA LINHA 815
// OPERACIONAL COMEÇA NA LINHA 817 E TERMINA NA LINHA 1170
// DISPLAY COMEÇA NA LINHA 1173 E TERMINA NA LINHA 1256
// RESET HOLD COMEÇA NA LINHA 1260 E TERMINA LINHA 1283
// FECHADURA TOP COMEÇA NA LINHA 1287 E TERMINA NA LINHA 1371







typedef struct packed {
	logic [19:0] [3:0] digits;
} senhaPac_t;

typedef struct packed {
	logic [3:0] BCD0;
	logic [3:0] BCD1;
	logic [3:0] BCD2;
	logic [3:0] BCD3;
	logic [3:0] BCD4;
	logic [3:0] BCD5;
} bcdPac_t;

typedef struct packed {
	logic bip_status;
	logic [5:0] bip_time;
	logic [5:0]  tranca_aut_time;
	senhaPac_t senha_master;
 	senhaPac_t senha_1;
	senhaPac_t senha_2;
	senhaPac_t senha_3;
	senhaPac_t senha_4;
} setupPac_t;


// ===================================== TECLADO =========================================

module driver_teclado (
input 		logic		clk,
input		logic		rst,
input 		logic [3:0] 	col_matriz,
output 		logic [3:0] 	lin_matriz,
output 		logic [3:0]	tecla_value,
output		logic 		tecla_valid
);


localparam T_DEBOUCE = 100;
localparam logic [3:0] map_out [0:3] = '{
    4'b1110,
    4'b1101,
    4'b1011,
    4'b0111
};

typedef enum logic [2:0] {
    VARREDURA,
    DEBOUNCE,
    DECODIFICAR,
    ENVIAR_DIGITO_VALID,
    ESPERAR_LIBERACAO
} estados_t;

typedef enum logic [1:0] {
    PROX_LINHA,
    VERIFICAR,
    LIMPO
} sub_machine_t;

estados_t estado;
sub_machine_t sub_maquina;
int deb_counter;
logic [1:0] lin_atual; //define qual é a linha atual
logic [3:0] tecla_decodificada, coluna_pressionada;

logic [1:0] linha_limpa;


logic tecla_pressionada; //define se tem uma tecla pressionada
logic ultrapassou_debounce; // define se o contador ultrapassou o tempo de debounce

// assign de variaveis de branch.
//informa se há alguma tecla sendo pressionada
assign tecla_pressionada = col_matriz != 4'b1111;
assign ultrapassou_debounce = deb_counter >= T_DEBOUCE;

always_ff @( posedge clk or posedge rst ) begin
    if(rst)begin
        estado <= VARREDURA;
        lin_atual <= 0;
        deb_counter <= 1;
        tecla_decodificada <= 4'hF;
        sub_maquina <= PROX_LINHA;
        linha_limpa <= 0;
        coluna_pressionada <= 0;
    end
    else
        case (estado)
            VARREDURA:begin
                if(tecla_pressionada)begin
                    estado <= DEBOUNCE;
                    deb_counter <= 1;
                    coluna_pressionada <= col_matriz;
                end
                else begin
                    lin_matriz <= map_out[lin_atual];
                    lin_atual <= lin_atual + 1;
                end
            end
            DEBOUNCE:begin
                if(ultrapassou_debounce) begin
                    estado <= DECODIFICAR;
                    deb_counter <= 1;
                end
                else if(!tecla_pressionada)begin
                    estado <= VARREDURA;
                    deb_counter <= 1;
                end
                else begin
                    deb_counter <= deb_counter +1;
                end
            end
            DECODIFICAR:begin
                case ({lin_matriz, coluna_pressionada})
                    8'b0111_0111:begin
                        tecla_decodificada <= 'h1; //1
                        estado <= ENVIAR_DIGITO_VALID;
                    end
                    8'b0111_1011:begin
                        tecla_decodificada <= 'h2; //2
                        estado <= ENVIAR_DIGITO_VALID;
                    end
                    8'b0111_1101:begin
                        tecla_decodificada <= 'h3; //3
                        estado <= ENVIAR_DIGITO_VALID;
                    end
                    8'b0111_1110:begin
                        tecla_decodificada <= 'hA; //A
                        estado <= ENVIAR_DIGITO_VALID;
                    end
                    8'b1011_0111:begin
                        tecla_decodificada <= 'h4; //4
                        estado <= ENVIAR_DIGITO_VALID;
                    end
                    8'b1011_1011:begin
                        tecla_decodificada <= 'h5; //5
                        estado <= ENVIAR_DIGITO_VALID;
                    end
                    8'b1011_1101:begin
                        tecla_decodificada <= 'h6; //6
                        estado <= ENVIAR_DIGITO_VALID;
                        end
                    8'b1011_1110:begin
                        tecla_decodificada <= 'hB; //b
                        estado <= ENVIAR_DIGITO_VALID;
                    end
                    8'b1101_0111:begin
                        tecla_decodificada <= 'h7; //7
                        estado <= ENVIAR_DIGITO_VALID;
                    end
                    8'b1101_1011:begin
                        tecla_decodificada <= 'h8; //8
                        estado <= ENVIAR_DIGITO_VALID;
                    end
                    8'b1101_1101:begin
                        tecla_decodificada <= 'h9; //9
                        estado <= ENVIAR_DIGITO_VALID;
                    end
                    8'b1101_1110:begin
                        tecla_decodificada <= 'hC; //c
                        estado <= ENVIAR_DIGITO_VALID;
                    end
                    8'b1110_0111:begin
                        tecla_decodificada <= 'hF; //*
                        estado <= ENVIAR_DIGITO_VALID;
                    end
                    8'b1110_1011:begin
                        tecla_decodificada <= 'h0; //0
                        estado <= ENVIAR_DIGITO_VALID;
                    end
                    8'b1110_1101:begin
                        tecla_decodificada <= 'hE; //#
                        estado <= ENVIAR_DIGITO_VALID;
                    end
                    8'b1110_1110:begin
                        tecla_decodificada <= 'hD; // D
                        estado <= ENVIAR_DIGITO_VALID;
                        end
                    default:begin
                        estado <= VARREDURA;
                    end
                endcase
            end

            ENVIAR_DIGITO_VALID:begin
                estado <= ESPERAR_LIBERACAO;
                sub_maquina <= PROX_LINHA;
                linha_limpa <= 0;
            end
            ESPERAR_LIBERACAO:begin
                case (sub_maquina)
                    PROX_LINHA:begin
                        lin_matriz <= map_out[linha_limpa];
                        sub_maquina <= VERIFICAR;
                    end
                    VERIFICAR:begin
                        if(!tecla_pressionada)begin
                            if(linha_limpa == 3)begin
                                sub_maquina <= LIMPO;
                            end
                            else begin
                                linha_limpa <= linha_limpa + 1;
                                sub_maquina <= PROX_LINHA;
                            end
                        end
                        else
                            sub_maquina <= PROX_LINHA;
                    end
                    LIMPO:begin
                        estado <= VARREDURA;
                        linha_limpa <= 0;
                        sub_maquina <= PROX_LINHA;
                    end
                    default:
                        sub_maquina <= PROX_LINHA;
                endcase
            end

            default:
                estado <= VARREDURA;
        endcase

end


always_comb begin
    if(rst)begin
        tecla_value = 4'hF;
        tecla_valid = 0;
    end
    else
        case (estado)
            {VARREDURA, DEBOUNCE, ESPERAR_LIBERACAO}:begin
                tecla_value = 4'hF;
                tecla_valid = 0;
            end
            DECODIFICAR:begin
                tecla_value = tecla_decodificada;
                tecla_valid = 0;
            end
            ENVIAR_DIGITO_VALID:begin
                tecla_value = tecla_decodificada;
                tecla_valid = 1;
            end
            default:begin
                tecla_valid = 0;
                tecla_value = 4'hF;
            end
        endcase
end


endmodule


module complemento_teclado (
    input logic clk,
    input logic rst,
    input logic enable,
    input logic[3:0] tecla_value,
    input logic tecla_valid,
    output logic digitos_valid,
    output senhaPac_t digitos_value
    );

    function senhaPac_t shiftar_barramento (
        input senhaPac_t in_pac,
        input logic [3:0] new_digit
        );
        return {(in_pac.digits[18:0]), new_digit};
    endfunction

    function senhaPac_t preencher_barramento (
        input logic [3:0] value
        );
        return {20{value}};
    endfunction


    localparam TIME_OUT = 5000;

    typedef enum logic [2:0] {
        ESPERAR,
        DECIDIR,
        SHIFT,
        CLEAR,
        ENVIAR_DIGITO_VALID,
        HASHTAG,
        TIME_OUT_S
    } estados_t;

    estados_t estado;

    logic [3:0] codigo_recebido;
    senhaPac_t temporario;
    int contador_timeout;

    logic controle_contador;
    logic contador_ultrapassou;
    logic alerta_contador;
    assign contador_ultrapassou = contador_timeout >= TIME_OUT;

    assign digitos_valid = estado == ENVIAR_DIGITO_VALID;
    assign digitos_value = temporario;

    always_ff @(posedge clk or posedge rst or negedge enable) begin
        if(rst || ! enable) begin
            estado <= ESPERAR;
            codigo_recebido <= 4'hF;
            controle_contador <= 0;
            temporario <= {20{4'hF}};
        end
        else if (alerta_contador)begin
            controle_contador <= 0;
            estado <= TIME_OUT_S;
        end
        else begin
            case (estado)
                ESPERAR:begin
                    if(tecla_valid)begin
                        codigo_recebido <= tecla_value;
                        estado <= DECIDIR;
                        controle_contador <= 0;
                    end
                end
                DECIDIR:begin
                    controle_contador <= 1;
                    case (codigo_recebido)
                        {4'hC, 4'hA, 4'hB, 4'hD}:begin //teclas que não importam.
                            estado <=  ESPERAR;
                        end
                        4'hF:begin //asterisco
                            estado <= ENVIAR_DIGITO_VALID;
                        end
                        4'hE: begin //HASHTAG
                            estado <= HASHTAG;
                        end
                        default: begin
                            estado <= SHIFT;
                        end
                    endcase
                end
                SHIFT: begin
                    temporario <= shiftar_barramento(digitos_value, codigo_recebido);
                    estado <= ESPERAR;
                end
                CLEAR:begin
                    estado <= ESPERAR;
                end
                HASHTAG:begin
                    temporario <= preencher_barramento(4'hB);
                    estado <= ENVIAR_DIGITO_VALID;
                end
                ENVIAR_DIGITO_VALID: begin
                    estado <= CLEAR;
                    controle_contador <= 0;
						 temporario <= preencher_barramento(4'hF);
                end
                TIME_OUT_S: begin
                    temporario <= preencher_barramento(4'hE);
                    estado <= ENVIAR_DIGITO_VALID;
                end
                default:begin
                    estado <= ESPERAR;
                end
            endcase
        end
    end


    //contador de 5 sec
    always_ff @(posedge clk or posedge rst) begin
        if(rst)begin
            contador_timeout <= 0;
            alerta_contador <= 0;
        end
        else begin
            if (!controle_contador)begin
                contador_timeout <= 0;
                alerta_contador <= 0;
            end
            else if(contador_ultrapassou)begin
                alerta_contador <= 1;
            end
            else begin
                contador_timeout <= contador_timeout + 1;
            end
        end
    end


endmodule


module decodificador_de_teclado (
    input 	logic clk,
    input	logic rst,
    input	logic enable,
    input 	logic [3:0] col_matriz,
    output	logic [3:0] lin_matriz,
    output 	senhaPac_t digitos_value,
    output	logic digitos_valid
);

    wire [3:0] tecla_value;
    wire tecla_valid;

    driver_teclado driver(
        .clk(clk),
        .rst(rst),
        .col_matriz(col_matriz),
        .lin_matriz(lin_matriz),
        .tecla_value(tecla_value),
        .tecla_valid(tecla_valid)
    );

    complemento_teclado complemento (
        .clk(clk),
        .rst(rst),
        .enable(enable),
        .tecla_value(tecla_value),
        .tecla_valid(tecla_valid),
        .digitos_valid(digitos_valid),
        .digitos_value(digitos_value)
    );



endmodule


//===================================== FIM TECLADO ===========================================

//==================================== SETUP ====================================================

module setup (
	input		logic		clk,
	input		logic		rst,
	input		logic		setup_on,
	input		senhaPac_t	digitos_value,
	input		logic		digitos_valid,
	output		logic		display_en,
	output		bcdPac_t	bcd_pac,
	output		setupPac_t 	data_setup_new,
	output		logic		data_setup_ok
	);


    typedef enum logic [3:0] {
        IDLE,
        ATIVAR_BIP,
        TEMPO_BIP,
        TEMPO_FECHAMENTO,
        SENHA_MASTER,
        SENHA_1,
        SENHA_2,
        SENHA_3,
        SENHA_4,
        ATUALIZAR_BARRAMENTO,
        ENVIAR_DADOS,
        ESPERAR_SETUP_ON_DOWN
    } estados_t;


    estados_t estado;
    setupPac_t pac_temp;
    logic [3:0] digito_unidade_btime, digito_dezena_btime, digito_bip_status, digito_dezena_ttime, digito_unidade_ttime;
    int soma_btime, soma_ttime;
		logic flag, flag2;
    logic confirmou, teclado_tempo_estourou, pressionou_hastag;

    assign confirmou = digitos_valid;
    assign teclado_tempo_estourou = digitos_value.digits[0] == 4'hE;
    assign pressionou_hastag = digitos_value.digits[0] == 4'hB;
    assign soma_btime = (digito_dezena_btime * 10) + digito_unidade_btime;
    assign soma_ttime = (digito_dezena_ttime * 10) + digito_unidade_ttime;

    always_ff @( posedge clk or posedge rst ) begin
        if(rst)begin
            estado <= IDLE;

            pac_temp.bip_status <= 1;
            pac_temp.bip_time <= 6'd5;
            pac_temp.tranca_aut_time <= 6'd5;
            pac_temp.senha_master <= {{16{4'hF}}, 4'h1, 4'h2, 4'h3, 4'h4};
            pac_temp.senha_1 <= {20{4'hF}};
            pac_temp.senha_2 <= {20{4'hF}};
            pac_temp.senha_3 <= {20{4'hF}};
            pac_temp.senha_4 <= {20{4'hF}};

            data_setup_new.bip_status <= 1;
            data_setup_new.bip_time <= 6'd5;
            data_setup_new.tranca_aut_time <= 6'd5;
            data_setup_new.senha_master <= {{16{4'hF}},4'h1,4'h2,4'h3,4'h4 };
            data_setup_new.senha_1 <= {20{4'hF}};
            data_setup_new.senha_2 <= {20{4'hF}};
            data_setup_new.senha_3 <= {20{4'hF}};
            data_setup_new.senha_4 <= {20{4'hF}};

            digito_dezena_btime <= 4'h0;
            digito_unidade_btime <= 4'h5;
            digito_dezena_ttime <= 4'h0;
            digito_unidade_ttime <= 4'h5;
            digito_bip_status <= 4'h1;
				flag <= 0;
				flag2 <= 1;
        end

        else begin
            case (estado)
                IDLE:begin
                    data_setup_ok <= 0;
                    pac_temp <= data_setup_new;
                    if(setup_on)begin
                        estado <= ATIVAR_BIP;
                        digito_bip_status <= data_setup_new.bip_status;
								flag <= 0;
								flag2 <= 1;
                    end
                end
                ATIVAR_BIP:begin
                    if(confirmou)begin
                        if(pressionou_hastag)begin
                            estado <= ATUALIZAR_BARRAMENTO;
                        end
                        else if(!teclado_tempo_estourou)begin
                            pac_temp.bip_status <= digito_bip_status;
                            estado <= TEMPO_BIP;
                            digito_unidade_btime <= pac_temp.bip_time % 10;
                            digito_dezena_btime <= pac_temp.bip_time / 10;
                        end
                    end
                    else begin
                        if(digitos_value.digits[0] == 4'h1 || digitos_value.digits[0] == 4'h0)begin
                            digito_bip_status <= digitos_value.digits[0];
                        end
                    end
                end
                TEMPO_BIP:begin
                    if(confirmou)begin
                        if(pressionou_hastag)begin
                          estado <= ATUALIZAR_BARRAMENTO;
                        end
                        else if(!teclado_tempo_estourou)begin
                            if(soma_btime <= 60 && soma_btime >= 5 )begin
                                pac_temp.bip_time <= soma_btime ;
                            end
                            else begin
                                pac_temp.bip_time <= soma_btime > 60 ? 60 : 5;
                            end
                            estado <= TEMPO_FECHAMENTO;
                            digito_unidade_ttime <= pac_temp.tranca_aut_time % 10;
                            digito_dezena_ttime <= pac_temp.tranca_aut_time / 10;
                        end
								flag <= 0;
								flag2 <= 1;
                    end
                    else begin
                        if(digitos_value.digits[0] == 4'hF || flag == 0)begin
                            digito_dezena_btime <= digito_dezena_btime;
                            digito_unidade_btime <= digito_unidade_btime;
									 flag <= 1;
                        end
                        else if(digitos_value.digits[1] == 4'hF && flag2 == 1) begin
                            digito_dezena_btime <= digito_unidade_btime;
                            digito_unidade_btime <= digitos_value.digits[0];
									 flag2 <= 0;

                        end
                        else if (digitos_value.digits[1] != 4'hF && digitos_value.digits[0] != 4'hF  )begin
                            digito_dezena_btime <= digitos_value.digits[1];
                            digito_unidade_btime <= digitos_value.digits[0];
                        end
                    end
                end
                TEMPO_FECHAMENTO:begin
                    if(confirmou)begin
								flag <= 0;
								flag2 <= 1;
                        if(pressionou_hastag)begin
                          estado <= ATUALIZAR_BARRAMENTO;
                        end
                        else if(!teclado_tempo_estourou)begin
                            if(soma_ttime <= 60 && soma_ttime >= 5 )begin
                                pac_temp.tranca_aut_time <= soma_ttime ;
                            end
                            else begin
                                pac_temp.tranca_aut_time <= soma_ttime > 60 ? 60 : 5;
                            end
                            estado <= SENHA_MASTER;
                        end
                    end
                    else begin
                        if(digitos_value.digits[0] == 4'hF || flag == 0)begin
                            digito_dezena_ttime <= digito_dezena_ttime;
                            digito_unidade_ttime <= digito_unidade_ttime;
									 flag <= 1;
                        end
                        else if(digitos_value.digits[1] == 4'hF && flag2) begin
                            digito_dezena_ttime <= digito_unidade_ttime;
                            digito_unidade_ttime <= digitos_value.digits[0];
									 flag2 <= 0;
                        end
                        else if (digitos_value.digits[1] != 4'hF && digitos_value.digits[0] != 4'hF)begin
                            digito_dezena_ttime <= digitos_value.digits[1];
                            digito_unidade_ttime <= digitos_value.digits[0];
                        end
                    end
                end
                SENHA_MASTER:begin
                    if(confirmou && !teclado_tempo_estourou)begin
                        if(pressionou_hastag)begin
                          estado <= ATUALIZAR_BARRAMENTO;
                        end
                        else begin
                            if(digitos_value.digits[3] != 4'hF )begin
                                estado <= SENHA_1;
                                pac_temp.senha_master <= {{8{4'hF}}, digitos_value.digits[11:0]};
                            end
                            else if(digitos_value.digits[0] == 4'hF ) estado <= SENHA_1;
                        end
                    end
                end
                SENHA_1:begin
                    if(confirmou && !teclado_tempo_estourou)begin
                        if(pressionou_hastag)begin
                          estado <= ATUALIZAR_BARRAMENTO;
                        end
                        else begin
                            if(digitos_value.digits[3] != 4'hF && digitos_value.digits[12] == 4'hF)begin
                                estado <= SENHA_2;
                                pac_temp.senha_1 <= {{8{4'hF}}, digitos_value.digits[11:0]};
                            end
                            else if(digitos_value.digits[0] == 4'hF ) estado <= SENHA_2;
                        end
                    end
                end
                SENHA_2:begin
                    if(confirmou && !teclado_tempo_estourou)begin
                        if(pressionou_hastag)begin
                          estado <= ATUALIZAR_BARRAMENTO;
                        end
                        else begin
                            if(digitos_value.digits[3] != 4'hF && digitos_value.digits[12] == 4'hF)begin
                                estado <= SENHA_3;
                                pac_temp.senha_2 <= {{8{4'hF}}, digitos_value.digits[11:0]};
                            end
                            else if(digitos_value.digits[0] == 4'hF ) estado <= SENHA_3;
                        end
                    end
                end
                SENHA_3:begin
                    if(confirmou && !teclado_tempo_estourou)begin
                        if(pressionou_hastag)begin
                          estado <= ATUALIZAR_BARRAMENTO;
                        end
                        else begin
                            if(digitos_value.digits[3] != 4'hF && digitos_value.digits[12] == 4'hF)begin
                                estado <= SENHA_4;
                                pac_temp.senha_3 <= {{8{4'hF}}, digitos_value.digits[11:0]};
                            end
                            else if(digitos_value.digits[0] == 4'hF ) estado <= SENHA_4;
                        end
                    end
                end
                SENHA_4:begin
                    if(confirmou && !teclado_tempo_estourou)begin
                        if(pressionou_hastag)begin
                          estado <= ATUALIZAR_BARRAMENTO;
                        end
                        else begin
                            if(digitos_value.digits[3] != 4'hF && digitos_value.digits[12] == 4'hF)begin
                              estado <= ATUALIZAR_BARRAMENTO;
                                pac_temp.senha_4 <= {{8{4'hF}}, digitos_value.digits[11:0]};
                            end
                            else if(digitos_value.digits[0] == 4'hF ) estado <= ATUALIZAR_BARRAMENTO;
                        end
                    end
                end
                ATUALIZAR_BARRAMENTO:begin
                    data_setup_new <= pac_temp;
                    estado <= ENVIAR_DADOS;
                end
                ENVIAR_DADOS:begin
                    estado <= ESPERAR_SETUP_ON_DOWN;
                    data_setup_ok <= 1;
                end
                ESPERAR_SETUP_ON_DOWN: begin
                  if(!setup_on)begin
                    estado <= IDLE;
                    data_setup_ok <= 0;
                  end
                end
                default:begin
                    estado <= IDLE;
                    pac_temp.bip_status <= 1;
                    pac_temp.bip_time <= 5;
                    pac_temp.tranca_aut_time <= 5;
                    pac_temp.senha_master <= {{16{4'hF}},4'h1,4'h2,4'h3,4'h4 };
                    pac_temp.senha_1 <= {20{4'hF}};
                    pac_temp.senha_2 <= {20{4'hF}};
                    pac_temp.senha_3 <= {20{4'hF}};
                    pac_temp.senha_4 <= {20{4'hF}};
                    digito_dezena_btime <= 4'h0;
                    digito_unidade_btime <= 4'h5;
                    digito_dezena_ttime <= 4'h0;
                    digito_unidade_ttime <= 4'h5;
                    digito_bip_status <= 4'h1;

                end
            endcase
        end
    end

    always_comb begin
        if (rst) begin
            display_en = 0;
            bcd_pac = {6{4'hB}};
        end
        else begin
            case (estado)
                IDLE, ATUALIZAR_BARRAMENTO, ENVIAR_DADOS:begin
                    display_en = 0;
                    bcd_pac.BCD0 = 4'hB;
                    bcd_pac.BCD1 = 4'hB;
                    bcd_pac.BCD2 = 4'hB;
                    bcd_pac.BCD3 = 4'hB;
                    bcd_pac.BCD4 = 4'hB;
                    bcd_pac.BCD5 = 4'hB;
                end
                ATIVAR_BIP:begin
                    display_en = 1;
                    bcd_pac.BCD0 = digito_bip_status;
                    bcd_pac.BCD1 = 4'hB;
                    bcd_pac.BCD2 = 4'hB;
                    bcd_pac.BCD3 = 4'hB;
                    bcd_pac.BCD4 = 4'hB;
                    bcd_pac.BCD5 = 4'h1;
                end
                TEMPO_BIP:begin
                    display_en = 1;
                    bcd_pac.BCD0 = digito_unidade_btime;
                    bcd_pac.BCD1 = digito_dezena_btime;
                    bcd_pac.BCD2 = 4'hB;
                    bcd_pac.BCD3 = 4'hB;
                    bcd_pac.BCD4 = 4'hB;
                    bcd_pac.BCD5 = 4'h2;
                end
                TEMPO_FECHAMENTO:begin
                    display_en = 1;
                    bcd_pac.BCD0 = digito_unidade_ttime;
                    bcd_pac.BCD1 = digito_dezena_ttime;
                    bcd_pac.BCD2 = 4'hB;
                    bcd_pac.BCD3 = 4'hB;
                    bcd_pac.BCD4 = 4'hB;
                    bcd_pac.BCD5 = 4'h3;
                end
                SENHA_MASTER:begin
                    display_en = 1;
                    bcd_pac.BCD0 = 4'hB;
                    bcd_pac.BCD1 = 4'hB;
                    bcd_pac.BCD2 = 4'hB;
                    bcd_pac.BCD3 = 4'hB;
                    bcd_pac.BCD4 = 4'hB;
                    bcd_pac.BCD5 = 4'h4;
                end
                SENHA_1:begin
                    display_en = 1;
                    bcd_pac.BCD0 = 4'hB;
                    bcd_pac.BCD1 = 4'hB;
                    bcd_pac.BCD2 = 4'hB;
                    bcd_pac.BCD3 = 4'hB;
                    bcd_pac.BCD4 = 4'hB;
                    bcd_pac.BCD5 = 4'h5;
                end
                SENHA_2:begin
                    display_en = 1;
                    bcd_pac.BCD0 = 4'hB;
                    bcd_pac.BCD1 = 4'hB;
                    bcd_pac.BCD2 = 4'hB;
                    bcd_pac.BCD3 = 4'hB;
                    bcd_pac.BCD4 = 4'hB;
                    bcd_pac.BCD5 = 4'h6;
                end
                SENHA_3:begin
                    display_en = 1;
                    bcd_pac.BCD0 = 4'hB;
                    bcd_pac.BCD1 = 4'hB;
                    bcd_pac.BCD2 = 4'hB;
                    bcd_pac.BCD3 = 4'hB;
                    bcd_pac.BCD4 = 4'hB;
                    bcd_pac.BCD5 = 4'h7;
                end
                SENHA_4:begin
                    display_en = 1;
                    bcd_pac.BCD0 = 4'hB;
                    bcd_pac.BCD1 = 4'hB;
                    bcd_pac.BCD2 = 4'hB;
                    bcd_pac.BCD3 = 4'hB;
                    bcd_pac.BCD4 = 4'hB;
                    bcd_pac.BCD5 = 4'h8;
                end
                default: begin
                    display_en = 0;
                    bcd_pac.BCD0 = 4'hB;
                    bcd_pac.BCD1 = 4'hB;
                    bcd_pac.BCD2 = 4'hB;
                    bcd_pac.BCD3 = 4'hB;
                    bcd_pac.BCD4 = 4'hB;
                    bcd_pac.BCD5 = 4'hB;
                end
            endcase
        end
    end

endmodule

// ========================================FIM DO SETUP =====================================

// ======================================= OPERACIONAL ======================================

module operacional(
	input		logic		clk,
	input		logic		rst,
	input		logic		sensor_contato,
	input		logic		botao_interno,
	input		logic		botao_bloqueio,
	input		logic		botao_config,
	input		setupPac_t 	data_setup_new,
	input		logic		data_setup_ok,
	input		senhaPac_t	digitos_value,
	input		logic		digitos_valid,
	output		bcdPac_t	bcd_pac,
	output 		logic 		teclado_en,
	output		logic		display_en,
	output		logic		setup_on,
	output		logic		tranca,
	output		logic		bip
);

	typedef enum logic [4:0] {
    RESET_STATE,
		IDLE,
		NO_PERTUBE,
		VERIFICAR_SENHA,
		TIMEOUT_SENHA_ERRADA,
		DESTRANCAR_PORTA,
		TEMPO_BIP,
		TEMPO_TRANCAMENTO,
		TRANCAR_PORTA,
		CONFIG,
		VALIDA_SENHA_MASTER,
		ESPERAR_CONFIG,
		ATUALIZAR_CONFIG
	} estados_t;


	localparam T_N_PERTUBE = 3000;

	function automatic logic verificar_senha(input senhaPac_t senha_verificar, input senhaPac_t senha_interna);
		senhaPac_t mask;

		if      (senha_interna.digits[3] == 'hF)  mask = 80'hFFFFFFFFFFFFFFFFFFFF;
		else if (senha_interna.digits[4] == 'hF)  mask = 80'hFFFFFFFFFFFFFFFF0000;
		else if (senha_interna.digits[5] == 'hF)  mask = 80'hFFFFFFFFFFFFFFF00000;
		else if (senha_interna.digits[6] == 'hF)  mask = 80'hFFFFFFFFFFFFFF000000;
		else if (senha_interna.digits[7] == 'hF)  mask = 80'hFFFFFFFFFFFFF0000000;
		else if (senha_interna.digits[8] == 'hF)  mask = 80'hFFFFFFFFFFFF00000000;
		else if (senha_interna.digits[9] == 'hF)  mask = 80'hFFFFFFFFFFF000000000;
		else if (senha_interna.digits[10] == 'hF)  mask = 80'hFFFFFFFFFF0000000000;
		else if (senha_interna.digits[11] == 'hF)  mask = 80'hFFFFFFFFF00000000000;
		else if (senha_interna.digits[12] == 'hF)  mask = 80'hFFFFFFFF000000000000;
		else mask = 80'hFFFFFFFFFFFFFFFFFFFF;

		if( ((((senha_verificar >>> (0*4)) | mask) == senha_interna) |
		(((senha_verificar >>> (1*4)) | mask) == senha_interna) |
		(((senha_verificar >>> (2*4)) | mask) == senha_interna) |
		(((senha_verificar >>> (3*4)) | mask) == senha_interna) |
		(((senha_verificar >>> (4*4)) | mask) == senha_interna) |
		(((senha_verificar >>> (5*4)) | mask) == senha_interna) |
		(((senha_verificar >>> (6*4)) | mask) == senha_interna) |
		(((senha_verificar >>> (7*4)) | mask) == senha_interna) |
		(((senha_verificar >>> (8*4)) | mask) == senha_interna) |
		(((senha_verificar >>> (9*4)) | mask) == senha_interna) |
		(((senha_verificar >>> (10*4)) | mask) == senha_interna) |
		(((senha_verificar >>> (11*4)) | mask) == senha_interna) |
		(((senha_verificar >>> (12*4)) | mask) == senha_interna) |
		(((senha_verificar >>> (13*4)) | mask) == senha_interna) |
		(((senha_verificar >>> (14*4)) | mask) == senha_interna) |
		(((senha_verificar >>> (15*4)) | mask) == senha_interna) |
		(((senha_verificar >>> (16*4)) | mask) == senha_interna) )
		&& mask != '1 )begin
		return 1'b1;
		end
		else begin
			return 0;
		end

	endfunction

	estados_t estado;
	setupPac_t config_atual;
	senhaPac_t senha_temp;
	int quant_falhas;
	logic confirmou_senha, modo_n_pertube;
	int	contador_n_pertube, contador_falhas, contador_trancamento, contador_bip;

	assign modo_n_pertube = contador_n_pertube >=  T_N_PERTUBE;
	assign confirmou_senha = digitos_valid;

	assign teclado_en = estado != NO_PERTUBE && estado != TEMPO_BIP && estado != TEMPO_TRANCAMENTO && estado != DESTRANCAR_PORTA && estado != TIMEOUT_SENHA_ERRADA;

	logic sinal_anterior, interno_borda;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            sinal_anterior <= 1'b0;
        end
		else begin
            // Guarda o estado atual para ser o "anterior" no próximo ciclo
            sinal_anterior <= botao_interno;
        end
    end

	assign interno_borda = (botao_interno == 1'b1) && (sinal_anterior == 1'b0);

	//always principal
	always_ff @( posedge clk or posedge rst ) begin
		if (rst)begin
			estado <= RESET_STATE;
			config_atual.bip_status <= 1;
            config_atual.bip_time <= 5;
            config_atual.tranca_aut_time <= 5;
            config_atual.senha_master <= {{16{4'hF}},4'h1,4'h2,4'h3,4'h4 };
            config_atual.senha_1 <= {20{4'hF}};
            config_atual.senha_2 <= {20{4'hF}};
            config_atual.senha_3 <= {20{4'hF}};
            config_atual.senha_4 <= {20{4'hF}};
			senha_temp <= {20{4'hF}};
			contador_falhas <= 0;
			contador_trancamento <= 0;
			contador_falhas <= 0;
			quant_falhas <= 0;
      setup_on <= 0;
		end
		else begin
			case (estado)
                RESET_STATE: begin
                    if(!sensor_contato)begin
                        estado <= IDLE;
                    end
                end
				IDLE : begin //pronto
					if(modo_n_pertube)begin
						estado <= NO_PERTUBE;
					end
					else if(confirmou_senha &&
						digitos_value.digits[0] != 4'hE &&
						digitos_value.digits[0] != 4'hB)begin
						estado <= VERIFICAR_SENHA;
						senha_temp <= digitos_value;
					end
					else if(interno_borda) begin
						estado <= DESTRANCAR_PORTA;
					end
				end
				NO_PERTUBE : begin //pronto
					if(interno_borda)begin
						estado <= DESTRANCAR_PORTA;
					end
				end
				VERIFICAR_SENHA : begin //pronto
					if (verificar_senha(senha_temp, config_atual.senha_1) ||
						verificar_senha(senha_temp, config_atual.senha_2) ||
						verificar_senha(senha_temp, config_atual.senha_3) ||
						verificar_senha(senha_temp, config_atual.senha_4) ||
                        verificar_senha(senha_temp, config_atual.senha_master)) begin
							estado <= DESTRANCAR_PORTA;
							quant_falhas <= 0;
					end
					else begin
						estado <= TIMEOUT_SENHA_ERRADA;
						quant_falhas <= quant_falhas + 1;
						contador_falhas <= 0;
					end
					senha_temp <= '1;
				end
				TIMEOUT_SENHA_ERRADA : begin //pronto
					contador_falhas <= contador_falhas + 1;
					if(quant_falhas < 5  && contador_falhas >= 1000) estado <= IDLE;
					else if(contador_falhas >= 30000) estado <= IDLE;
				end
				DESTRANCAR_PORTA : begin //pronto
					if(sensor_contato)begin
						estado <= TEMPO_BIP;
					end
					else estado <= TEMPO_TRANCAMENTO;
					contador_trancamento <= 0;
					contador_bip <= 0;
				end
				TEMPO_BIP : begin //pronto
					if(botao_config)begin
						estado <= CONFIG;
					end
					else if(!sensor_contato) begin
						estado <= TEMPO_TRANCAMENTO;
						contador_trancamento <= 0;
					end
					else begin
						contador_bip <= contador_bip + 1;
					end
				end
				TEMPO_TRANCAMENTO : begin // PRONTO
					if(contador_trancamento >= (config_atual.tranca_aut_time *1000) || interno_borda) begin
						estado <= TRANCAR_PORTA;
					end
					else if(sensor_contato)begin
						estado <= TEMPO_BIP;
						contador_bip <= 0;
					end
					contador_trancamento <= contador_trancamento + 1;

				end
				TRANCAR_PORTA : begin //pronto
					estado <= IDLE;
				end
				CONFIG : begin //PRONTO
					if(confirmou_senha && digitos_value.digits[0] != 4'hE)begin
						if(digitos_value.digits[0] != 4'hB)begin

							estado <= VALIDA_SENHA_MASTER;
							senha_temp <= digitos_value;
						end
						else estado <= IDLE;
					end
				end
				VALIDA_SENHA_MASTER:begin //pronto
					if(verificar_senha(senha_temp, config_atual.senha_master))begin
						estado <= ESPERAR_CONFIG;
                        setup_on <= 1;
					end
					else estado <= CONFIG;
				end
				ESPERAR_CONFIG : begin // PRONTO
					if(data_setup_ok)begin
						estado <= ATUALIZAR_CONFIG;
					end
				end
				ATUALIZAR_CONFIG : begin //PRONTO
					config_atual <= data_setup_new;
                    setup_on <= 0;
                    estado <= TEMPO_BIP;
				end
				default: begin
					estado <= IDLE;
					config_atual.bip_status <= 1;
					config_atual.bip_time <= 5;
					config_atual.tranca_aut_time <= 5;
					config_atual.senha_master <= {{16{4'hF}},4'h1,4'h2,4'h3,4'h4 };
					config_atual.senha_1 <= {20{4'hF}};
					config_atual.senha_2 <= {20{4'hF}};
					config_atual.senha_3 <= {20{4'hF}};
					config_atual.senha_4 <= {20{4'hF}};
					senha_temp <= {20{4'hF}};
					contador_falhas <= 0;
					contador_trancamento <= 0;
					contador_falhas <= 0;
					quant_falhas <= 0;
				end
			endcase
		end
	end

	//always contador botão bloqueio
	always_ff @(posedge clk or posedge rst) begin
		if (rst) begin
			contador_n_pertube <= 0;
		end
		else if( estado != IDLE || !botao_bloqueio)begin
			contador_n_pertube <= 0;
		end
		else begin
			contador_n_pertube <= contador_n_pertube + 1;
		end
	end

	//display
	always_comb begin
		if(rst)begin
			display_en = 1;
			bcd_pac = {6{4'hB}};
		end
		else begin
			case (estado)
				TIMEOUT_SENHA_ERRADA:begin
					display_en <= 1;
					bcd_pac.BCD0 = quant_falhas >= 1 ? 4'hA : 4'hB;
					bcd_pac.BCD1 = quant_falhas >= 2 ? 4'hA : 4'hB;
					bcd_pac.BCD2 = quant_falhas >= 3 ? 4'hA : 4'hB;
					bcd_pac.BCD3 = quant_falhas >= 4 ? 4'hA : 4'hB;
					bcd_pac.BCD4 = quant_falhas >= 5 ? 4'hA : 4'hB;
					bcd_pac.BCD5 = quant_falhas >= 5 ? 4'hA : 4'hB;
				end
				VALIDA_SENHA_MASTER : begin
					display_en <= 1;
					bcd_pac.BCD0 = 4'hB;
					bcd_pac.BCD1 = 4'hB;
					bcd_pac.BCD2 = 4'hB;
					bcd_pac.BCD3 = 4'hB;
					bcd_pac.BCD4 = 4'hB;
					bcd_pac.BCD5 = 4'h0;
				end
				CONFIG: begin
					display_en = 1;
					bcd_pac.BCD0 = 4'hB;
					bcd_pac.BCD1 = 4'hB;
					bcd_pac.BCD2 = 4'hB;
					bcd_pac.BCD3 = 4'hB;
					bcd_pac.BCD4 = 4'hB;
					bcd_pac.BCD5 = 4'h0;
				end
				ESPERAR_CONFIG, ATUALIZAR_CONFIG : begin
					display_en = 0;
					bcd_pac = {6{4'hB}};
				end
				default: begin
					display_en = 1;
					bcd_pac.BCD0 =4'hB;
					bcd_pac.BCD1 =4'hB;
					bcd_pac.BCD2 =4'hB;
					bcd_pac.BCD3 =4'hB;
					bcd_pac.BCD4 =4'hB;
					bcd_pac.BCD5 =4'hB;
				end
			endcase
		end
	end


	//tranca e bip
	always_comb begin
		if(rst) begin
			tranca = 1;
			bip = 0;
		end
		else begin
			case (estado)
				DESTRANCAR_PORTA : begin
					tranca = 0;
					bip = 0;
				end
				TEMPO_TRANCAMENTO:begin
					tranca = 0;
					bip = 0;
				end
				TEMPO_BIP : begin
					tranca = 0;
					bip = (contador_bip >= (config_atual.bip_time * 1000) && config_atual.bip_status) ? 1 : 0;
				end
				IDLE: begin
					tranca = 1;
					bip = digitos_value.digits[0] == 4'hE ? 1 : 0;
				end
				default: begin
					tranca = sensor_contato ? 0 : 1;
					bip = 0;
				end
			endcase
		end
	end
endmodule

//=========================================FIM DO OPERACIONAL =========================


//========================================= INICIO DO DISPLAY =========================

module display (
input 		logic 		clk,
input 		logic 		rst,
input 		logic 		enable_o, enable_s,
input 		bcdPac_t 	bcd_packet_operacional, bcd_packet_setup,
output 		logic [6:0] 	HEX0, HEX1,HEX2, HEX3, HEX4, HEX5
);

    function automatic logic [6:0] decodifica_7seg(input logic [3:0] valor_hex);
        case (valor_hex)
            4'h0 : return 7'b1000000; // 0
            4'h1 : return 7'b1111001; // 1
            4'h2 : return 7'b0100100; // 2
            4'h3 : return 7'b0110000; // 3
            4'h4 : return 7'b0011001; // 4
            4'h5 : return 7'b0010010; // 5
            4'h6 : return 7'b0000010; // 6
            4'h7 : return 7'b1111000; // 7
            4'h8 : return 7'b0000000; // 8
            4'h9 : return 7'b0010000; // 9
            4'hA : return 7'b0111111; // -
            4'hB : return 7'b1111111; //apagado
            default : return 7'b1111111;
        endcase
    endfunction

    logic [5:0] [6:0] traducao_setup, traducao_op;

    assign traducao_setup[0] = decodifica_7seg(bcd_packet_setup.BCD0);
    assign traducao_setup[1] = decodifica_7seg(bcd_packet_setup.BCD1);
    assign traducao_setup[2] = decodifica_7seg(bcd_packet_setup.BCD2);
    assign traducao_setup[3] = decodifica_7seg(bcd_packet_setup.BCD3);
    assign traducao_setup[4] = decodifica_7seg(bcd_packet_setup.BCD4);
    assign traducao_setup[5] = decodifica_7seg(bcd_packet_setup.BCD5);

    assign traducao_op[0] = decodifica_7seg(bcd_packet_operacional.BCD0);
    assign traducao_op[1] = decodifica_7seg(bcd_packet_operacional.BCD1);
    assign traducao_op[2] = decodifica_7seg(bcd_packet_operacional.BCD2);
    assign traducao_op[3] = decodifica_7seg(bcd_packet_operacional.BCD3);
    assign traducao_op[4] = decodifica_7seg(bcd_packet_operacional.BCD4);
    assign traducao_op[5] = decodifica_7seg(bcd_packet_operacional.BCD5);

  always_ff @( posedge clk or posedge rst ) begin
    if(rst)begin
        HEX0 <= 7'b1111111;
        HEX1 <= 7'b1111111;
        HEX2 <= 7'b1111111;
        HEX3 <= 7'b1111111;
        HEX4 <= 7'b1111111;
        HEX5 <= 7'b1111111;
    end
    else begin
        if(enable_o)begin
            HEX0 <= traducao_op[0];
            HEX1 <= traducao_op[1];
            HEX2 <= traducao_op[2];
            HEX3 <= traducao_op[3];
            HEX4 <= traducao_op[4];
            HEX5 <= traducao_op[5];
        end
        else if(enable_s)begin
            HEX0 <= traducao_setup[0];
            HEX1 <= traducao_setup[1];
            HEX2 <= traducao_setup[2];
            HEX3 <= traducao_setup[3];
            HEX4 <= traducao_setup[4];
            HEX5 <= traducao_setup[5];
        end
        else begin
            HEX0 <= 7'b1111111;
            HEX1 <= 7'b1111111;
            HEX2 <= 7'b1111111;
            HEX3 <= 7'b1111111;
            HEX4 <= 7'b1111111;
            HEX5 <= 7'b1111111;
        end
    end
  end

endmodule

// ====================================== FIM DO DISPLAY ===========================

// ====================================== INICIO DO RESETHOLD ===========================

module resetHold5s #(parameter TIME_TO_RST = 5)
	(input logic clk, reset_in,
output logic reset_out);


  int contador;

  always_ff @(posedge clk)begin
    if(!reset_in)begin
      contador <= 0;
      reset_out <= 0;
    end
    else if(contador >= 5000)begin
      reset_out <= 1;
    end
    else begin
      contador <= contador + 1;
      reset_out <= 0;
    end
  end

endmodule

// ====================================== FIM DO RESETHOLD ===========================

module divfreq(input reset, clock, output logic clk_i);
  int cont;
  always @(posedge clock or posedge reset) begin
    if(reset) begin
      cont  = 0;
      clk_i = 0;
    end
    else
      if( cont <= 25000 )
        cont++;
      else begin
        clk_i = ~clk_i;
        cont = 0;
      end
  end
endmodule

//===================================== INICIO FECHADURA TOP =======================

module FechaduraTop (
input 	logic clk, rst, sensor_de_contato, botao_interno, botao_bloqueio, botao_config,
input	logic [3:0] matricial_col,
output	logic [3:0] matricial_lin,
output 	logic [6:0] dispHex0, dispHex1, dispHex2, dispHex3, dispHex4, dispHex5,
output logic tranca, bip );


    logic enable_teclado;
    logic teclado_digit_valid;
    senhaPac_t teclado_senha_value;

  logic reset_out;

  resetHold5s rst_module(
    .clk(clk),
    .reset_in(rst),
    .reset_out(reset_out)
  );

    decodificador_de_teclado teclado (
        .clk(clk),
        .rst(reset_out),
        .enable(enable_teclado),
        .col_matriz(matricial_col),
        .lin_matriz(matricial_lin),
        .digitos_value(teclado_senha_value),
        .digitos_valid(teclado_digit_valid)
    );

    logic enable_d_o;
    logic enable_d_s;
    bcdPac_t bcd_packet_op, bcd_packet_setup;

    display u_displa(
        .clk(clk),
        .rst(reset_out),
        .enable_o(enable_d_o),
        .enable_s(enable_d_s),
        .bcd_packet_operacional(bcd_packet_op),
        .bcd_packet_setup(bcd_packet_setup),
        .HEX0(dispHex0),
        .HEX1(dispHex1),
        .HEX2(dispHex2),
        .HEX3(dispHex3),
        .HEX4(dispHex4),
        .HEX5(dispHex5)
    );

    logic setup_on, setup_ok;
    setupPac_t data_setup;

    setup configuracao(
        .clk(clk),
        .rst(reset_out),
        .setup_on(setup_on),
        .digitos_value(teclado_senha_value),
        .digitos_valid(teclado_digit_valid),
        .display_en(enable_d_s),
        .bcd_pac(bcd_packet_setup),
        .data_setup_new(data_setup),
        .data_setup_ok(setup_ok)
	);
    operacional operacional(
        .clk(clk),
        .rst(reset_out),
        .sensor_contato(sensor_de_contato),
        .botao_interno(botao_interno),
        .botao_bloqueio(botao_bloqueio),
        .botao_config(botao_config),
        .data_setup_new(data_setup),
        .data_setup_ok(setup_ok),
        .digitos_value(teclado_senha_value),
        .digitos_valid(teclado_digit_valid),
        .bcd_pac(bcd_packet_op),
        .teclado_en(enable_teclado),
        .display_en(enable_d_o),
        .setup_on(setup_on),
        .tranca(tranca),
        .bip(bip)
    );

endmodule

//=====================================FIM FECHADURA TOP====================================
