// TECLADO COMEÇA NA LINHA 38 E TERMINA NA LINHA 444
// SETUP COMEÇA NA LINHA 446 E TERMINA NA LINHA 832
// OPERACIONAL COMEÇA NA LINHA 834 E TERMINA NA LINHA 1181
// DISPLAY COMEÇA NA LINHA 1184 E TERMINA NA LINHA 1267
// RESET COMEÇA NA LINHA 1270 E TERMINA NA LINHA 1297
// FECHADURA TOP COMEÇA NA LINHA 1299 E TERMINA NA LINHA 1386






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


localparam T_DEBOUNCE = 100;
localparam logic [3:0] map_out [0:3] = '{
    4'b1110,
    4'b1101,
    4'b1011,
    4'b0111
};

typedef enum logic [2:0] {
    SCAN,
    DEBOUNCE,
    DECODE,
    SEND_VALID_DIGIT,
    WAIT_RELEASE
} estados_t;

typedef enum logic [1:0] {
    NEXT_LINE,
    CHECK,
    CLEAN
} sub_machine_t;

estados_t state;
sub_machine_t sub_machine;
int deb_counter;
logic [1:0] current_line; //define qual é a linha atual
logic [3:0] decoded_key, pressed_column;

logic [1:0] clean_line;


logic key_pressed; //define se tem uma tecla pressionada
logic debounce_exceeded; // define se o contador ultrapassou o tempo de debounce

// assign de variaveis de branch.
//informa se há alguma tecla sendo pressionada
assign key_pressed = col_matriz != 4'b1111;
assign debounce_exceeded = deb_counter >= T_DEBOUNCE;

always_ff @( posedge clk or posedge rst ) begin
    if(rst)begin
        state <= SCAN;
        current_line <= 0;
        deb_counter <= 1;
        decoded_key <= 4'hF;
        sub_machine <= NEXT_LINE;
        clean_line <= 0;
        pressed_column <= 0;
    end
    else
        case (state)
            SCAN:begin
                if(key_pressed)begin
                    state <= DEBOUNCE;
                    deb_counter <= 1;
                    pressed_column <= col_matriz;
                end
                else begin
                    lin_matriz <= map_out[current_line];
                    current_line <= current_line + 1;
                end
            end
            DEBOUNCE:begin
                if(debounce_exceeded) begin
                    state <= DECODE;
                    deb_counter <= 1;
                end
                else if(!key_pressed)begin
                    state <= SCAN;
                    deb_counter <= 1;
                end
                else begin
                    deb_counter <= deb_counter +1;
                end
            end
            DECODE:begin
                case ({lin_matriz, pressed_column})
                    8'b0111_0111:begin
                        decoded_key <= 'h1; //1
                        state <= SEND_VALID_DIGIT;
                    end
                    8'b0111_1011:begin
                        decoded_key <= 'h2; //2
                        state <= SEND_VALID_DIGIT;
                    end
                    8'b0111_1101:begin
                        decoded_key <= 'h3; //3
                        state <= SEND_VALID_DIGIT;
                    end
                    8'b0111_1110:begin
                        decoded_key <= 'hA; //A
                        state <= SEND_VALID_DIGIT;
                    end
                    8'b1011_0111:begin
                        decoded_key <= 'h4; //4
                        state <= SEND_VALID_DIGIT;
                    end
                    8'b1011_1011:begin
                        decoded_key <= 'h5; //5
                        state <= SEND_VALID_DIGIT;
                    end
                    8'b1011_1101:begin
                        decoded_key <= 'h6; //6
                        state <= SEND_VALID_DIGIT;
                        end
                    8'b1011_1110:begin
                        decoded_key <= 'hB; //b
                        state <= SEND_VALID_DIGIT;
                    end
                    8'b1101_0111:begin
                        decoded_key <= 'h7; //7
                        state <= SEND_VALID_DIGIT;
                    end
                    8'b1101_1011:begin
                        decoded_key <= 'h8; //8
                        state <= SEND_VALID_DIGIT;
                    end
                    8'b1101_1101:begin
                        decoded_key <= 'h9; //9
                        state <= SEND_VALID_DIGIT;
                    end
                    8'b1101_1110:begin
                        decoded_key <= 'hC; //c
                        state <= SEND_VALID_DIGIT;
                    end
                    8'b1110_0111:begin
                        decoded_key <= 'hF; //*
                        state <= SEND_VALID_DIGIT;
                    end
                    8'b1110_1011:begin
                        decoded_key <= 'h0; //0
                        state <= SEND_VALID_DIGIT;
                    end
                    8'b1110_1101:begin
                        decoded_key <= 'hE; //#
                        state <= SEND_VALID_DIGIT;
                    end
                    8'b1110_1110:begin
                        decoded_key <= 'hD; // D
                        state <= SEND_VALID_DIGIT;
                        end
                    default:begin
                        state <= SCAN;
                    end
                endcase
            end

            SEND_VALID_DIGIT:begin
                state <= WAIT_RELEASE;
                sub_machine <= NEXT_LINE;
                clean_line <= 0;
            end
            WAIT_RELEASE:begin
                case (sub_machine)
                    NEXT_LINE:begin
                        lin_matriz <= map_out[clean_line];
                        sub_machine <= CHECK;
                    end
                    CHECK:begin
                        if(!key_pressed)begin
                            if(clean_line == 3)begin
                                sub_machine <= CLEAN;
                            end
                            else begin
                                clean_line <= clean_line + 1;
                                sub_machine <= NEXT_LINE;
                            end
                        end
                        else
                            sub_machine <= NEXT_LINE;
                    end
                    CLEAN:begin
                        state <= SCAN;
                        clean_line <= 0;
                        sub_machine <= NEXT_LINE;
                    end
                    default:
                        sub_machine <= NEXT_LINE;
                endcase
            end

            default:
                state <= SCAN;
        endcase

end


always_comb begin
    if(rst)begin
        tecla_value = 4'hF;
        tecla_valid = 0;
    end
    else
        case (state)
            {SCAN, DEBOUNCE, WAIT_RELEASE}:begin
                tecla_value = 4'hF;
                tecla_valid = 0;
            end
            DECODE:begin
                tecla_value = decoded_key;
                tecla_valid = 0;
            end
            SEND_VALID_DIGIT:begin
                tecla_value = decoded_key;
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

    function senhaPac_t shift_bus (
        input senhaPac_t in_pac,
        input logic [3:0] new_digit
        );
        return {(in_pac.digits[18:0]), new_digit};
    endfunction

    function senhaPac_t fill_bus (
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

    estados_t state;

    logic [3:0] received_code;
    senhaPac_t temporary;
    int timeout_counter;

    logic counter_control;
    logic counter_exceeded;
    logic counter_alert;
    assign counter_exceeded = timeout_counter >= TIME_OUT;

    assign digitos_valid = state == ENVIAR_DIGITO_VALID;
    assign digitos_value = temporary;

    always_ff @(posedge clk or posedge rst or negedge enable) begin
        if(rst || ! enable) begin
            state <= ESPERAR;
            received_code <= 4'hF;
            counter_control <= 0;
            temporary = {20{4'hF}};
        end
        else if (counter_alert)begin
            counter_control <= 0;
            state <= TIME_OUT_S;
        end
        else begin
            case (state)
                ESPERAR:begin
                    if(tecla_valid)begin
                        received_code <= tecla_value;
                        state <= DECIDIR;
                        counter_control <= 0;
                    end
                end
                DECIDIR:begin
                    counter_control <= 1;
                    case (received_code)
                        {4'hC, 4'hA, 4'hB, 4'hD}:begin //teclas que não importam.
                            state <=  ESPERAR;
                        end
                        4'hF:begin //asterisco
                            state <= ENVIAR_DIGITO_VALID;
                        end
                        4'hE: begin //HASHTAG
                            state <= HASHTAG;
                        end
                        default: begin
                            state <= SHIFT;
                        end
                    endcase
                end
                SHIFT: begin
                    temporary <= shift_bus(digitos_value, received_code);
                    state <= ESPERAR;
                end
                CLEAR:begin
                    temporary <= fill_bus(4'hF);
                    state <= ESPERAR;
                end
                HASHTAG:begin
                    temporary <= fill_bus(4'hB);
                    state <= ENVIAR_DIGITO_VALID;
                end
                ENVIAR_DIGITO_VALID: begin
                    state <= CLEAR;
                    counter_control <= 0;
                end
                TIME_OUT_S: begin
                    temporary <= fill_bus(4'hE);
                    state <= ENVIAR_DIGITO_VALID;
                end
                default:begin
                    state <= ESPERAR;
                end
            endcase
        end
    end


    //contador de 5 sec
    always_ff @(posedge clk or posedge rst) begin
        if(rst)begin
            timeout_counter <= 0;
            counter_alert <= 0;
        end
        else begin
            if (!counter_control)begin
                timeout_counter <= 0;
                counter_alert <= 0;
            end
            else if(counter_exceeded)begin
                counter_alert <= 1;
            end
            else begin
                timeout_counter <= timeout_counter + 1;
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

//=======================================  SETUP ==============================================

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
        ENVIAR_DADOS
    } estados_t;


    estados_t state;
    setupPac_t temp_pac;
    logic [3:0] unit_digit, tens_digit;
    int sum_tens_digit;

    logic confirmed, keyboard_timeout, pressed_hashtag;

    assign confirmed = digitos_valid;
    assign keyboard_timeout = digitos_value.digits[0] == 4'hE;
    assign pressed_hashtag = digitos_value.digits[0] == 4'hB;
    assign sum_tens_digit = (tens_digit * 10) + unit_digit;



    always_ff @( posedge clk or posedge rst ) begin
        if(rst)begin
            state <= IDLE;

            temp_pac.bip_status <= 1;
            temp_pac.bip_time <= 5;
            temp_pac.tranca_aut_time <= 5;
            temp_pac.senha_master <= {{16{4'hF}}, 4'h1, 4'h2, 4'h3, 4'h4};
            temp_pac.senha_1 <= {20{4'hF}};
            temp_pac.senha_2 <= {20{4'hF}};
            temp_pac.senha_3 <= {20{4'hF}};
            temp_pac.senha_4 <= {20{4'hF}};

            data_setup_new.bip_status <= 1;
            data_setup_new.bip_time <= 5;
            data_setup_new.tranca_aut_time <= 5;
            data_setup_new.senha_master <= {{16{4'hF}},4'h1,4'h2,4'h3,4'h4 };
            data_setup_new.senha_1 <= {20{4'hF}};
            data_setup_new.senha_2 <= {20{4'hF}};
            data_setup_new.senha_3 <= {20{4'hF}};
            data_setup_new.senha_4 <= {20{4'hF}};

            tens_digit <= 4'hF;
            unit_digit <= 4'hF;

        end

        else begin
            case (state)
                IDLE:begin
                    data_setup_ok <= 0;
                    if(setup_on)begin
                        state <= ATIVAR_BIP;
                        unit_digit <= data_setup_new.bip_status;
                    end
                end
                ATIVAR_BIP:begin
                    if(confirmed)begin
                        if(pressed_hashtag)begin
                            state <= ATUALIZAR_BARRAMENTO;
                        end
                        else if(!keyboard_timeout)begin
                            temp_pac.bip_status <= unit_digit;
                            state <= TEMPO_BIP;
                            unit_digit <= temp_pac.bip_time % 10;
                            tens_digit <= temp_pac.bip_time / 10;
                        end
                    end
                    else begin
                        if(digitos_value.digits[0] == 4'h1 || digitos_value.digits[0] == 4'h0)begin
                            unit_digit <= digitos_value.digits[0];
                        end
                    end
                end
                TEMPO_BIP:begin
                    if(confirmed)begin
                        if(pressed_hashtag)begin
                            state <= ATUALIZAR_BARRAMENTO;
                        end
                        else if(!keyboard_timeout)begin
                            if(sum_tens_digit <= 60 && sum_tens_digit >= 5 )begin
                                temp_pac.bip_time <= sum_tens_digit ;
                            end
                            else begin
                                temp_pac.bip_time <= sum_tens_digit > 60 ? 60 : 5;
                            end
                            state <= TEMPO_FECHAMENTO;
                            unit_digit <= temp_pac.tranca_aut_time % 10;
                            tens_digit <= temp_pac.tranca_aut_time / 10;
                        end
                    end
                    else begin
                        if(
                        digitos_value.digits[0] == 4'h0 ||
                        digitos_value.digits[0] == 4'h1 ||
                        digitos_value.digits[0] == 4'h2 ||
                        digitos_value.digits[0] == 4'h3 ||
                        digitos_value.digits[0] == 4'h4 ||
                        digitos_value.digits[0] == 4'h5 ||
                        digitos_value.digits[0] == 4'h6 ||
                        digitos_value.digits[0] == 4'h7 ||
                        digitos_value.digits[0] == 4'h8 ||
                        digitos_value.digits[0] == 4'h9 )begin
                            unit_digit <= digitos_value.digits[0];
                        end
                        if(
                        digitos_value.digits[1] == 4'h0 ||
                        digitos_value.digits[1] == 4'h1 ||
                        digitos_value.digits[1] == 4'h2 ||
                        digitos_value.digits[1] == 4'h3 ||
                        digitos_value.digits[1] == 4'h4 ||
                        digitos_value.digits[1] == 4'h5 ||
                        digitos_value.digits[1] == 4'h6 ||
                        digitos_value.digits[1] == 4'h7 ||
                        digitos_value.digits[1] == 4'h8 ||
                        digitos_value.digits[1] == 4'h9 )begin
                                tens_digit <= digitos_value.digits[1];
                            end
                    end
                end
                TEMPO_FECHAMENTO:begin
                    if(confirmed)begin
                        if(pressed_hashtag)begin
                            state <= ATUALIZAR_BARRAMENTO;
                        end
                        else if(!keyboard_timeout)begin
                            if(sum_tens_digit <= 60 && sum_tens_digit >= 5 )begin
                                temp_pac.tranca_aut_time <= sum_tens_digit ;
                            end
                            else begin
                                temp_pac.tranca_aut_time <= sum_tens_digit > 60 ? 60 : 5;
                            end
                            state <= SENHA_MASTER;
                        end
                    end
                    else begin
                        if(
                        digitos_value.digits[0] == 4'h0 ||
                        digitos_value.digits[0] == 4'h1 ||
                        digitos_value.digits[0] == 4'h2 ||
                        digitos_value.digits[0] == 4'h3 ||
                        digitos_value.digits[0] == 4'h4 ||
                        digitos_value.digits[0] == 4'h5 ||
                        digitos_value.digits[0] == 4'h6 ||
                        digitos_value.digits[0] == 4'h7 ||
                        digitos_value.digits[0] == 4'h8 ||
                        digitos_value.digits[0] == 4'h9 )begin
                            unit_digit <= digitos_value.digits[0];
                        end
                        if(
                        digitos_value.digits[1] == 4'h0 ||
                        digitos_value.digits[1] == 4'h1 ||
                        digitos_value.digits[1] == 4'h2 ||
                        digitos_value.digits[1] == 4'h3 ||
                        digitos_value.digits[1] == 4'h4 ||
                        digitos_value.digits[1] == 4'h5 ||
                        digitos_value.digits[1] == 4'h6 ||
                        digitos_value.digits[1] == 4'h7 ||
                        digitos_value.digits[1] == 4'h8 ||
                        digitos_value.digits[1] == 4'h9 )begin
                                tens_digit <= digitos_value.digits[1];
                            end
                    end
                end
                SENHA_MASTER:begin
                    if(confirmed && !keyboard_timeout)begin
                        if(pressed_hashtag)begin
                            state <= ATUALIZAR_BARRAMENTO;
                        end
                        else begin
                            if(digitos_value.digits[3] != 4'hF )begin
                                state <= SENHA_1;
                                temp_pac.senha_master <= {{8{4'hF}}, digitos_value.digits[11:0]};
                            end
                            else if(digitos_value.digits[0] == 4'hF ) state <= SENHA_1;
                        end
                    end
                end
                SENHA_1:begin
                    if(confirmed && !keyboard_timeout)begin
                        if(pressed_hashtag)begin
                            state <= ATUALIZAR_BARRAMENTO;
                        end
                        else begin
                            if(digitos_value.digits[3] != 4'hF)begin
                                state <= SENHA_2;
                                temp_pac.senha_1 <= {{8{4'hF}}, digitos_value.digits[11:0]};
                            end
                            else if(digitos_value.digits[0] == 4'hF ) state <= SENHA_2;
                        end
                    end
                end
                SENHA_2:begin
                    if(confirmed && !keyboard_timeout)begin
                        if(pressed_hashtag)begin
                            state <= ATUALIZAR_BARRAMENTO;
                        end
                        else begin
                            if(digitos_value.digits[3] != 4'hF)begin
                                state <= SENHA_3;
                                temp_pac.senha_2 <= {{8{4'hF}}, digitos_value.digits[11:0]};
                            end
                            else if(digitos_value.digits[0] == 4'hF ) state <= SENHA_3;
                        end
                    end
                end
                SENHA_3:begin
                    if(confirmed && !keyboard_timeout)begin
                        if(pressed_hashtag)begin
                            state <= ATUALIZAR_BARRAMENTO;
                        end
                        else begin
                            if(digitos_value.digits[3] != 4'hF)begin
                                state <= SENHA_4;
                                temp_pac.senha_3 <= {{8{4'hF}}, digitos_value.digits[11:0]};
                            end
                            else if(digitos_value.digits[0] == 4'hF ) state <= SENHA_4;
                        end
                    end
                end
                SENHA_4:begin
                    if(confirmed && !keyboard_timeout)begin
                        if(pressed_hashtag)begin
                            state <= ATUALIZAR_BARRAMENTO;
                        end
                        else begin
                            if(digitos_value.digits[3] != 4'hF)begin
                                state <= ATUALIZAR_BARRAMENTO;
                                temp_pac.senha_4 <= {{8{4'hF}}, digitos_value.digits[11:0]};
                            end
                            else if(digitos_value.digits[0] == 4'hF ) state <= ATUALIZAR_BARRAMENTO;
                        end
                    end
                end
                ATUALIZAR_BARRAMENTO:begin
                    data_setup_new <= temp_pac;
                    state <= ENVIAR_DADOS;
                end
                ENVIAR_DADOS:begin
                    state <= IDLE;
                    data_setup_ok <= 1;
                end
                default:begin
                    state <= IDLE;
                    temp_pac.bip_status <= 1;
                    temp_pac.bip_time <= 5;
                    temp_pac.tranca_aut_time <= 5;
                    temp_pac.senha_master <= {{16{4'hF}},4'h1,4'h2,4'h3,4'h4 };
                    temp_pac.senha_1 <= {20{4'hF}};
                    temp_pac.senha_2 <= {20{4'hF}};
                    temp_pac.senha_3 <= {20{4'hF}};
                    temp_pac.senha_4 <= {20{4'hF}};
                    tens_digit <= 4'hF;
                    unit_digit <= 4'hF;
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
            case (state)
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
                    bcd_pac.BCD0 = unit_digit;
                    bcd_pac.BCD1 = 4'hB;
                    bcd_pac.BCD2 = 4'hB;
                    bcd_pac.BCD3 = 4'hB;
                    bcd_pac.BCD4 = 4'hB;
                    bcd_pac.BCD5 = 4'h1;
                end
                TEMPO_BIP:begin
                    display_en = 1;
                    bcd_pac.BCD0 = unit_digit;
                    bcd_pac.BCD1 = tens_digit;
                    bcd_pac.BCD2 = 4'hB;
                    bcd_pac.BCD3 = 4'hB;
                    bcd_pac.BCD4 = 4'hB;
                    bcd_pac.BCD5 = 4'h2;
                end
                TEMPO_FECHAMENTO:begin
                    display_en = 1;
                    bcd_pac.BCD0 = unit_digit;
                    bcd_pac.BCD1 = tens_digit;
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
		IDLE, // 0
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

	estados_t state;
	setupPac_t current_config;
	senhaPac_t temp_password;
	int fail_count;
	logic password_confirmed, no_disturb_mode;
	int	no_disturb_counter, fail_counter, lock_counter, bip_counter;

	assign no_disturb_mode = no_disturb_counter >=  T_N_PERTUBE;
	assign password_confirmed = digitos_valid;

	assign setup_on = state == ESPERAR_CONFIG;
	assign teclado_en = state != NO_PERTUBE && state != TEMPO_BIP && state != TEMPO_TRANCAMENTO && state != DESTRANCAR_PORTA && state != TIMEOUT_SENHA_ERRADA;

	logic previous_signal, internal_edge;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            previous_signal <= 1'b0;
        end
		else begin
            // Guarda o estado atual para ser o "anterior" no próximo ciclo
            previous_signal <= botao_interno;
        end
    end

	assign internal_edge = (botao_interno == 1'b1) && (previous_signal == 1'b0);

	//always principal
	always_ff @( posedge clk or posedge rst ) begin
		if (rst)begin
			state <= IDLE;
			current_config.bip_status <= 1;
            current_config.bip_time <= 5;
            current_config.tranca_aut_time <= 5;
            current_config.senha_master <= {{16{4'hF}},4'h1,4'h2,4'h3,4'h4 };
            current_config.senha_1 <= {20{4'hF}};
            current_config.senha_2 <= {20{4'hF}};
            current_config.senha_3 <= {20{4'hF}};
            current_config.senha_4 <= {20{4'hF}};
			temp_password <= {20{4'hF}};
			fail_counter <= 0;
			lock_counter <= 0;
			fail_counter <= 0;
			fail_count <= 0;
		end
		else begin
			case (state)
				IDLE : begin
					if(no_disturb_mode)begin
						state <= NO_PERTUBE;
					end
					else if(password_confirmed &&
						digitos_value.digits[0] != 4'hE &&
						digitos_value.digits[0] != 4'hB)begin
						state <= VERIFICAR_SENHA;
						temp_password <= digitos_value;
					end
					else if(internal_edge) begin
						state <= DESTRANCAR_PORTA;
					end
				end
				NO_PERTUBE : begin
					if(internal_edge)begin
						state <= DESTRANCAR_PORTA;
					end
				end
				VERIFICAR_SENHA : begin
					if (verificar_senha(temp_password, current_config.senha_1) |
						verificar_senha(temp_password, current_config.senha_2) |
						verificar_senha(temp_password, current_config.senha_3) |
						verificar_senha(temp_password, current_config.senha_4)) begin
							state <= DESTRANCAR_PORTA;
							fail_count <= 0;
					end
					else begin
						state <= TIMEOUT_SENHA_ERRADA;
						fail_count <= fail_count + 1;
						fail_counter <= 0;
					end
					temp_password <= '1;
				end
				TIMEOUT_SENHA_ERRADA : begin
					fail_counter <= fail_counter + 1;
					if(fail_count < 5  && fail_counter >= 1000) state <= IDLE;
					else if(fail_counter >= 30000) state <= IDLE;
				end
				DESTRANCAR_PORTA : begin
					if(sensor_contato)begin
						state <= TEMPO_BIP;
					end
					else state <= TEMPO_TRANCAMENTO;
					lock_counter <= 0;
					bip_counter <= 0;
				end
				TEMPO_BIP : begin
					if(botao_config)begin
						state <= CONFIG;
					end
					else if(!sensor_contato) begin
						state <= TEMPO_TRANCAMENTO;
						lock_counter <= 0;
					end
					else begin
						bip_counter <= bip_counter + 1;
					end
				end
				TEMPO_TRANCAMENTO : begin
					if(lock_counter >= (current_config.tranca_aut_time *1000) || internal_edge) begin
						state <= TRANCAR_PORTA;
					end
					else if(sensor_contato)begin
						state <= TEMPO_BIP;
						bip_counter <= 0;
					end
					lock_counter <= lock_counter + 1;

				end
				TRANCAR_PORTA : begin
					state <= IDLE;
				end
				CONFIG : begin
					if(password_confirmed && digitos_value.digits[0] != 4'hE)begin
						if(digitos_value.digits[0] != 4'hB)begin

							state <= VALIDA_SENHA_MASTER;
							temp_password <= digitos_value;
						end
						else state <= IDLE;
					end
				end
				VALIDA_SENHA_MASTER:begin
					if(verificar_senha(temp_password, current_config.senha_master))begin
						state <= ESPERAR_CONFIG;
					end
					else state <= CONFIG;
				end
				ESPERAR_CONFIG : begin
					if(data_setup_ok)begin
						state <= ATUALIZAR_CONFIG;
					end
				end
				ATUALIZAR_CONFIG : begin
					current_config <= data_setup_new;
					state <= IDLE;
				end
				default: begin
					state <= IDLE;
					current_config.bip_status <= 1;
					current_config.bip_time <= 5;
					current_config.tranca_aut_time <= 5;
					current_config.senha_master <= {{16{4'hF}},4'h1,4'h2,4'h3,4'h4 };
					current_config.senha_1 <= {20{4'hF}};
					current_config.senha_2 <= {20{4'hF}};
					current_config.senha_3 <= {20{4'hF}};
					current_config.senha_4 <= {20{4'hF}};
					temp_password <= {20{4'hF}};
					fail_counter <= 0;
					lock_counter <= 0;
					fail_counter <= 0;
					fail_count <= 0;
				end
			endcase
		end
	end

	//always contador botão bloqueio
	always_ff @(posedge clk or posedge rst) begin
		if (rst) begin
			no_disturb_counter <= 0;
		end
		else if( state != IDLE || !botao_bloqueio)begin
			no_disturb_counter <= 0;
		end
		else begin
			no_disturb_counter <= no_disturb_counter + 1;
		end
	end

	//display
	always_comb begin
		if(rst)begin
			display_en = 1;
			bcd_pac = {6{4'hB}};
		end
		else begin
			case (state)
				TIMEOUT_SENHA_ERRADA:begin
					display_en <= 1;
					bcd_pac.BCD0 = fail_count >= 1 ? 4'hA : 4'hB;
					bcd_pac.BCD1 = fail_count >= 2 ? 4'hA : 4'hB;
					bcd_pac.BCD2 = fail_count >= 3 ? 4'hA : 4'hB;
					bcd_pac.BCD3 = fail_count >= 4 ? 4'hA : 4'hB;
					bcd_pac.BCD4 = fail_count >= 5 ? 4'hA : 4'hB;
					bcd_pac.BCD5 = fail_count >= 5 ? 4'hA : 4'hB;
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
					display_en <= 1;
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
			case (state)
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
					bip = bip_counter >= (current_config.bip_time * 1000) ? 1 : 0;
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

    function automatic logic [6:0] decode_7seg(input logic [3:0] hex_value);
        case (hex_value)
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

    logic [5:0] [6:0] translation_setup, translation_op;

    assign translation_setup[0] = decode_7seg(bcd_packet_setup.BCD0);
    assign translation_setup[1] = decode_7seg(bcd_packet_setup.BCD1);
    assign translation_setup[2] = decode_7seg(bcd_packet_setup.BCD2);
    assign translation_setup[3] = decode_7seg(bcd_packet_setup.BCD3);
    assign translation_setup[4] = decode_7seg(bcd_packet_setup.BCD4);
    assign translation_setup[5] = decode_7seg(bcd_packet_setup.BCD5);

    assign translation_op[0] = decode_7seg(bcd_packet_operacional.BCD0);
    assign translation_op[1] = decode_7seg(bcd_packet_operacional.BCD1);
    assign translation_op[2] = decode_7seg(bcd_packet_operacional.BCD2);
    assign translation_op[3] = decode_7seg(bcd_packet_operacional.BCD3);
    assign translation_op[4] = decode_7seg(bcd_packet_operacional.BCD4);
    assign translation_op[5] = decode_7seg(bcd_packet_operacional.BCD5);

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
            HEX0 <= translation_op[0];
            HEX1 <= translation_op[1];
            HEX2 <= translation_op[2];
            HEX3 <= translation_op[3];
            HEX4 <= translation_op[4];
            HEX5 <= translation_op[5];
        end
        else if(enable_s)begin
            HEX0 <= translation_setup[0];
            HEX1 <= translation_setup[1];
            HEX2 <= translation_setup[2];
            HEX3 <= translation_setup[3];
            HEX4 <= translation_setup[4];
            HEX5 <= translation_setup[5];
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


// ===================================== INICIO DO RESET ===========================


module resetHold5s #(parameter TIME_TO_RST = 5)
	(input logic clk, reset_in,
output logic reset_out);


  int counter;

  always_ff @(posedge clk)begin
    if(!reset_in)begin
      counter <= 0;
      reset_out <= 0;
    end
    else if(counter >= 5000)begin
      reset_out <= 1;
    end
    else begin
      counter <= counter + 1;
      reset_out <= 0;
    end
  end

endmodule


// ===================================== FIM DO RESET ============================

//=================================== INICIO FECHADURA TOP =======================


module FechaduraTop (
  	input 	logic clk, rst, sensor_de_contato, botao_interno, botao_bloqueio, botao_config,
  	input	logic [3:0] matricial_col,
  	output	logic [3:0] matricial_lin,
  	output 	logic [6:0] dispHex0, dispHex1, dispHex2, dispHex3, dispHex4, dispHex5,
	output logic tranca, bip
);


    logic enable_teclado;
    logic teclado_digit_valid;
    senhaPac_t teclado_senha_value;

    logic reset_out;

    resetHold5s(
      .clk(clk),
      .reset_in(rst),
      .reset_out(reset_out)
    )

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

//=============================== FIM FECHADURA TOP ========================================
