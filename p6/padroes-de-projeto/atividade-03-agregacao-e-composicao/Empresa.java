import java.util.ArrayList;
import java.util.List;

public class Empresa {
    private String nome;
    private List<EquipeDeProjeto> equipes;
    private List<Empregado> empregados;
    
    public Empresa(String nome) {
        this.nome = nome;
        this.equipes = new ArrayList<>();
        this.empregados = new ArrayList<>();
    }
    
    public String getNome() {
        return nome;
    }
    
    public void setNome(String nome) {
        this.nome = nome;
    }
    
    public List<EquipeDeProjeto> getEquipes() {
        return equipes;
    }
    
    public void adicionarEquipe(EquipeDeProjeto equipe) {
        if (!this.equipes.contains(equipe)) {
            this.equipes.add(equipe);
        }
    }
    
    public void removerEquipe(EquipeDeProjeto equipe) {
        this.equipes.remove(equipe);
    }
    
    public List<Empregado> getEmpregados() {
        return empregados;
    }
    
    public void adicionarEmpregado(Empregado empregado) {
        if (!this.empregados.contains(empregado)) {
            this.empregados.add(empregado);
        }
    }
    
    public void removerEmpregado(Empregado empregado) {
        this.empregados.remove(empregado);
    }

    public void excluir() {
        System.out.println("Iniciando exclusão da empresa: " + this.nome);
        
        List<EquipeDeProjeto> equipesParaExcluir = new ArrayList<>(this.equipes);
        List<Empregado> empregadosParaExcluir = new ArrayList<>(this.empregados);
        
        System.out.println("Excluindo " + equipesParaExcluir.size() + " equipes de projeto");
        for (EquipeDeProjeto equipe : equipesParaExcluir) {
            equipe.excluir();
        }
        
        this.equipes.clear();
        
        System.out.println("Excluindo " + empregadosParaExcluir.size() + " empregados");
        for (Empregado empregado : empregadosParaExcluir) {
            empregado.excluir();
        }
        
        this.empregados.clear();
        
        System.out.println("Empresa " + this.nome + " excluída com sucesso");
    }
}