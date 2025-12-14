print("=================================")
print("SISTEMA DE ILUMINAÇÃO INTELIGENTE")
print("=================================")

modo = 0
lampada = 0

while True:
    print(f"\nMODO ATUAL = {'MANUAL' if not modo else 'AUTO'}")
    print(f"A LAMPÂDA ESTÁ {'DESLIGADA' if not lampada else 'LIGADA'}")
    print(f"O LED INDICADOR ESTÁ {'LIGADO' if modo == 0 else 'DESLIGADO'}")

    print("\nINPUTS POSSÍVEIS:")

    print("[1] - Apertar Botão por 5 segundos (troca o modo de funcionamento do sistema")
    print("[2] - Sensor Infravermelho detectar alguém")
    print("[3] - Sensor Infravermelho passar 30 segundos sem detectar movimento nenhum")
    print("[4] - Apertar Botão por menos de 5 segundos e mais de 300ms")

    entrada = int(input())

    match entrada:
        case 1:
            modo = 0 if modo == 1 else 1
        case 2:
            if modo == 1:
                lampada = 1
        case 3:
            if modo == 1:
                lampada = 0
        case 4:
            if modo == 0:
                lampada = not lampada
        case _:
            break;
