public class Empregado {
    private String nome;
    private String cargo;
    private Empresa empresa; 
    private EquipedeProjeto equipeDeProjeto; 

    public Empregado(String nome, String cargo, Empresa empresa, EquipedeProjeto equipeDeProjeto) {
        this.nome = nome;
        this.cargo = cargo;
        this.empresa = empresa;
        this.equipeDeProjeto = equipeDeProjeto;
    }

    public String getNome() {
        return nome;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    public String getCargo() {
        return cargo;
    }

    public void setCargo(String cargo) {
        this.cargo = cargo;
    }

    public Empresa getEmpresa() {
        return empresa;
    }

    public void setEmpresa(Empresa empresa) {
        this.empresa = empresa;
    }

    public EquipedeProjeto getEquipeDeProjeto() {
        return equipeDeProjeto;
    }

    public void setEquipeDeProjeto(EquipedeProjeto equipeDeProjeto) {
        this.equipeDeProjeto = equipeDeProjeto;
    }

    
    public void exibirInformacoes() {
        System.out.println("Nome: " + nome);
        System.out.println("Cargo: " + cargo);
        System.out.println("========================================================");
        System.out.println("Informações da Empresa:");
        empresa.exibirInformacoes();
        if (equipeDeProjeto != null) {
            System.out.println("========================================================");
            System.out.println("Informações da Equipe de Projeto:");
            equipeDeProjeto.exibirInformacoes();
        } else {
            System.out.println("========================================================");
            System.out.println("Este empregado não está associado a nenhuma equipe de projeto.");
        }
    }
}