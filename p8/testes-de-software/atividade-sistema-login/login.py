"""
Implementação das funções de validação de e-mails e senhas.

Equipe:
    - Carlos Elias Fialho de Lima
    - Felipe Luiz de Lima
    - Katia Emmanuelle Gomes da Silva
    - Marcus Cauê de Farias Barbosa
    - Miguel Ryan Dantas de Freitas
"""


def validate_email(email: str) -> bool:
    if " " in email:
        return False

    if email == "":
        return False

    if email.count("@") != 1:
        return False

    local, domain = email.split("@")
    if not local or not domain:
        return False

    if "." not in domain:
        return False

    if local[0] == "." or local[-1] == ".":
        return False
    if domain[0] == "." or domain[-1] == ".":
        return False

    if ".." in email:
        return False

    allowed_local = set(
        "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789._-"
    )
    allowed_domain = set(
        "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.-"
    )

    for char in local:
        if char not in allowed_local:
            return False
    for char in domain:
        if char not in allowed_domain:
            return False

    return True


def validate_password(password: str) -> bool:
    if not (8 <= len(password) <= 16):
        return False

    special_chars = {"&", "*", "$", "%", "#", "!", "^", "~", "[", "]"}
    has_special = has_upper = has_lower = has_digit = False

    for char in password:
        if char in special_chars:
            has_special = True
        if char.isupper():
            has_upper = True
        if char.islower():
            has_lower = True
        if char.isdigit():
            has_digit = True

        if has_special and has_upper and has_lower and has_digit:
            return True

    return has_special and has_upper and has_lower and has_digit
