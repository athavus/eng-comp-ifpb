import pytest
from cart import calcular_total_carrinho

@pytest.mark.parametrize("forma_pagamento, resultado_esperado", [
    ("PIX", 232.74),
    ("Cartão de Débito", 258.60),
    ("Cartão de Crédito", 271.53)
])
def test_calcular_total_carrinho(forma_pagamento, resultado_esperado):
    carrinho = [
        {"codigo": 101, "nome": "Café Gourmet", "valor_unitario": 25.50, "quantidade": 2},
        {"codigo": 102, "nome": "Filtro de Papel", "valor_unitario": 5.00, "quantidade": 5},
        {"codigo": 103, "nome": "Açúcar Mascavo", "valor_unitario": 12.00, "quantidade": 1},
        {"codigo": 104, "nome": "Caneca Premium", "valor_unitario": 45.00, "quantidade": 3},
        {"codigo": 105, "nome": "Biscoito", "valor_unitario": 8.90, "quantidade": 4}
    ]
    assert calcular_total_carrinho(carrinho, forma_pagamento) == resultado_esperado
