"""
Testes para a validação de e-mails e senhas.

Equipe:
    - Carlos Elias Fialho de Lima
    - Felipe Luiz de Lima
    - Katia Emmanuelle Gomes da Silva
    - Marcus Cauê de Farias Barbosa
    - Miguel Ryan Dantas de Freitas
"""

import unittest

from login import validate_email, validate_password


class TestEmailAndPassword(unittest.TestCase):
    def test_valid_emails_and_passwords(self):
        valid_cases = {
            "usuario@exemplo.com": "Abcdef1!",
            "miguel.ryan@ifpb.edu.br": "Ssenha1#",  # Aceito
            "a@b.c": "Abcdef1!",  # Aceito
            "usuario_carlos-01@sub.dominio.org": "Test123$",  # Aceito
        }

        valid_cases_keys = list(valid_cases.keys())

        # ("usuario@exemplo.com", "Abcdef1!")
        self.assertTrue(validate_email(valid_cases_keys[0]))
        self.assertTrue(validate_password(valid_cases["usuario@exemplo.com"]))

        # ("miguel.ryan@ifpb.edu.br", "Senha1#")
        self.assertTrue(validate_email(valid_cases_keys[1]))
        self.assertTrue(validate_password(valid_cases["miguel.ryan@ifpb.edu.br"]))

        # ("a@b.c", "Abcdef1!")
        self.assertTrue(validate_email(valid_cases_keys[2]))
        self.assertTrue(validate_password(valid_cases["a@b.c"]))

        # ("usuario_carlos-01@sub.dominio.org", "Test123$")
        self.assertTrue(validate_email(valid_cases_keys[3]))
        self.assertTrue(
            validate_password(valid_cases["usuario_carlos-01@sub.dominio.org"])
        )

    def test_invalid_emails(self):
        invalid_emails = [
            "usuarioexemplo.com",  # email sem @
            "@dominio.com",  # email sem local
            "user@",  # email sem domínio
            "user@domain",  # email domínio sem ponto
            "user@.domain.com",  # ponto no início do domínio
            "user@domain..com",  # email com dois pontos seguidos
            "user@domain.com.",  # email com ponto no final do domínio
            ".user@domain.com",  # email com ponto no início do local
            ".user @domain.com",  # email com espaços
            "",  # email vazio
        ]

        self.assertFalse(validate_email(invalid_emails[0]))
        self.assertFalse(validate_email(invalid_emails[1]))
        self.assertFalse(validate_email(invalid_emails[2]))
        self.assertFalse(validate_email(invalid_emails[3]))
        self.assertFalse(validate_email(invalid_emails[4]))
        self.assertFalse(validate_email(invalid_emails[5]))
        self.assertFalse(validate_email(invalid_emails[6]))
        self.assertFalse(validate_email(invalid_emails[7]))

    def test_invalid_passwords(self):
        invalid_passwords = [
            "abcdefg1!",  # senha sem maiúscula
            "ABCDEFG1!",  # senha sem minúscula
            "Abcdefghi!",  # senha sem número
            "Abcdefg1",  # senha sem caractere especial
            "A1!",  # senha curta
            "A1!aaaaaaaaaaaaaaaa",  # senha longa
            "",  # senha vazia
        ]

        self.assertFalse(validate_password(invalid_passwords[0]))
        self.assertFalse(validate_password(invalid_passwords[1]))
        self.assertFalse(validate_password(invalid_passwords[2]))
        self.assertFalse(validate_password(invalid_passwords[3]))
        self.assertFalse(validate_password(invalid_passwords[4]))
        self.assertFalse(validate_password(invalid_passwords[5]))


if __name__ == "__main__":
    unittest.main()
