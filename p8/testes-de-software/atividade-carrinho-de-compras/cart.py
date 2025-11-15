products = [
    {"codigo": 101, "nome": "Café Gourmet", "valor_unitario": 25.50, "quantidade": 2},
    {"codigo": 102, "nome": "Filtro de Papel", "valor_unitario": 5.00, "quantidade": 5},
    {"codigo": 103, "nome": "Açúcar Mascavo", "valor_unitario": 12.00, "quantidade": 1},
    {"codigo": 104, "nome": "Caneca Premium", "valor_unitario": 45.00, "quantidade": 3},
    {"codigo": 105, "nome": "Biscoito", "valor_unitario": 8.90, "quantidade": 4}
]

def calcular_total_carrinho(produtos, forma_de_pagamento):
    total = sum(produto["valor_unitario"] * produto["quantidade"] for produto in produtos)
    match forma_de_pagamento:
        case "PIX":
            total *= 0.90
        case "Cartão de Débito":
            total *= 1.00
        case "Cartão de Crédito":
            total *= 1.05
        case _:
            total *= 1.00
    return round(total, 2)  # sempre float com duas casas
