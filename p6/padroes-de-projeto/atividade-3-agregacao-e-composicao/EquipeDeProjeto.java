import java.util.ArrayList;
import java.util.List;

public class EquipeDeProjeto {
    private String nome;
    private Empresa empresa;
    private List<Empregado> membros;
    
    public EquipeDeProjeto(String nome, Empresa empresa) {
        this.nome = nome;
        this.membros = new ArrayList<>();
        
        if (empresa != null) {
            this.empresa = empresa;
            empresa.adicionarEquipe(this);
        }
    }
    
    public String getNome() {
        return nome;
    }
    
    public void setNome(String nome) {
        this.nome = nome;
    }
    
    public Empresa getEmpresa() {
        return empresa;
    }
    
    public void setEmpresa(Empresa empresa) {
        if (this.empresa != null) {
            this.empresa.removerEquipe(this);
        }
        
        this.empresa = empresa;
        
        if (empresa != null) {
            empresa.adicionarEquipe(this);
        }
    }
    
    public List<Empregado> getMembros() {
        return membros;
    }
    
    public void adicionarMembro(Empregado empregado) {
        if (!this.membros.contains(empregado)) {
            this.membros.add(empregado);
            empregado.adicionarEquipe(this);
        }
    }
    
    public void removerMembro(Empregado empregado) {
        this.membros.remove(empregado);
    }

    public void excluir() {
        System.out.println("Excluindo equipe: " + this.nome);
        
        // Remover a equipe de cada membro
        List<Empregado> membrosParaRemover = new ArrayList<>(this.membros);
        for (Empregado membro : membrosParaRemover) {
            membro.removerEquipe(this);
        }
        
        // Limpar a lista de membros
        this.membros.clear();
        
        // Remover a equipe da empresa
        if (this.empresa != null) {
            this.empresa.removerEquipe(this);
            this.empresa = null;
        }
    }
}