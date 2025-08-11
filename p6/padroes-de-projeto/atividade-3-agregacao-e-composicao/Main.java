public class Main {
    public static void main(String[] args) {
        Empresa empresa = new Empresa("IFPB");
        
        Empregado empregado1 = new Empregado("Miguel Ryan", "Desenvolvedor", empresa);
        Empregado empregado2 = new Empregado("Carlos Elias", "Designer", empresa);
        Empregado empregado3 = new Empregado("Ismael Marinho", "Gerente de Projeto", empresa);
        
        EquipeDeProjeto equipe1 = new EquipeDeProjeto("Projeto Mobile", empresa);
        EquipeDeProjeto equipe2 = new EquipeDeProjeto("Projeto Web", empresa);
        
        equipe1.adicionarMembro(empregado1);
        equipe1.adicionarMembro(empregado2);
        equipe2.adicionarMembro(empregado1);
        equipe2.adicionarMembro(empregado3);
        
        System.out.println("== Antes da Exclusão ==");
        System.out.println("Empresa: " + empresa.getNome());
        System.out.println("Número de equipes: " + empresa.getEquipes().size());
        for (EquipeDeProjeto equipe : empresa.getEquipes()) {
            System.out.println("  - Equipe: " + equipe.getNome() + " (Membros: " + equipe.getMembros().size() + ")");
        }
        
        System.out.println("Número de empregados: " + empresa.getEmpregados().size());
        for (Empregado empregado : empresa.getEmpregados()) {
            System.out.println("  - Empregado: " + empregado.getNome() + " (Equipes: " + empregado.getEquipes().size() + ")");
        }
        
        System.out.println("\n== Processo de Exclusão ==");
        empresa.excluir();
        
        System.out.println("\n== Após a Exclusão ==");
        System.out.println("Equipes restantes na empresa: " + empresa.getEquipes().size());
        System.out.println("Empregados restantes na empresa: " + empresa.getEmpregados().size());
        
        System.out.println("\n== Estado dos Objetos ==");
        System.out.println("Equipe 1 - Empresa associada: " + (equipe1.getEmpresa() == null ? "Nenhuma" : equipe1.getEmpresa().getNome()));
        System.out.println("Equipe 1 - Número de membros: " + equipe1.getMembros().size());
        
        System.out.println("Empregado 1 - Empresa associada: " + (empregado1.getEmpresa() == null ? "Nenhuma" : empregado1.getEmpresa().getNome()));
        System.out.println("Empregado 1 - Número de equipes: " + empregado1.getEquipes().size());
    }
}