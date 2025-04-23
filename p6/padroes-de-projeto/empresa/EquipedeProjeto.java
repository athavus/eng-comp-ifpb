public class EquipedeProjeto {
    private String nomeProjeto;
    private Empresa empresa; 

    public EquipedeProjeto(String nomeProjeto, Empresa empresa) {
        this.nomeProjeto = nomeProjeto;
        this.empresa = empresa;
    }

    
    public String getNomeProjeto() {
        return nomeProjeto;
    }

    public void setNomeProjeto(String nomeProjeto) {
        this.nomeProjeto = nomeProjeto;
    }

    public Empresa getEmpresa() {
        return empresa;
    }

    public void setEmpresa(Empresa empresa) {
        this.empresa = empresa;
    }

    
    public void exibirInformacoes() {
        System.out.println("Nome do Projeto: " + nomeProjeto);
        System.out.println("========================================================");
    }
}