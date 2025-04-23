public class Main {
  public static void main(String[] args) {
    // Criação de uma instância da classe Empresa
    Empresa empresa = new Empresa("Tech Solutions", "12.345.678/0001-90", "Rua das Flores, 123");

    // Criação de uma instância da classe EquipedeProjeto
    EquipedeProjeto equipe = new EquipedeProjeto("Desenvolvimento de Software", empresa);

    Empregado empregado = new Empregado("Markingocleico", "Desenvolvedor", empresa, equipe);
    // Exibição das informações da empresa e do projeto
    empregado.exibirInformacoes();
  }
}