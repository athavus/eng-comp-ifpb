
Funcionalidade: Cadastro de Senha
  Como um usuário do sistema
  Quero cadastrar uma nova senha
  Para poder autenticar-me posteriormente

  Cenário: Tentativa de cadastro de senha com confirmação incorreta
    Dado que o usuário acessa a tela de autenticação em "http://localhost:8080/ini"
    E preenche o campo de login com "Breno Romero"
    E preenche o campo de senha com "$567#997_113141516"
    E preenche o campo de confirmação de senha com "$567#997_113141519"
    Quando o usuário clica em "Enviar"
    Então o sistema deve exibir a mensagem "Senha não Confere"
