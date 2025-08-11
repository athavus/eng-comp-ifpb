import java.util.ArrayList;
import java.util.List;

public class Empregado {
    private String nome;
    private String cargo;
    private Empresa empresa;
    private List<EquipeDeProjeto> equipes;
    
    public Empregado(String nome, String cargo, Empresa empresa) {
        this.nome = nome;
        this.cargo = cargo;
        this.equipes = new ArrayList<>();
        
        if (empresa != null) {
            this.empresa = empresa;
            empresa.adicionarEmpregado(this);
        }
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
        if (this.empresa != null) {
            this.empresa.removerEmpregado(this);
        }
        
        this.empresa = empresa;
        
        if (empresa != null) {
            empresa.adicionarEmpregado(this);
        }
    }
    
    public List<EquipeDeProjeto> getEquipes() {
        return equipes;
    }
    
    public void adicionarEquipe(EquipeDeProjeto equipe) {
        if (!this.equipes.contains(equipe)) {
            this.equipes.add(equipe);
            if (!equipe.getMembros().contains(this)) {
                equipe.adicionarMembro(this);
            }
        }
    }
    
    public void removerEquipe(EquipeDeProjeto equipe) {
        this.equipes.remove(equipe);
        equipe.removerMembro(this);
    }

    public void excluir() {
        System.out.println("Excluindo empregado: " + this.nome);
        
        List<EquipeDeProjeto> equipesParaRemover = new ArrayList<>(this.equipes);
        for (EquipeDeProjeto equipe : equipesParaRemover) {
            equipe.removerMembro(this);
        }
        
        this.equipes.clear();
        
        if (this.empresa != null) {
            this.empresa.removerEmpregado(this);
            this.empresa = null;
        }
    }
}