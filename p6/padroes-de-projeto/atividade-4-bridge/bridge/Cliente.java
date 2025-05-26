package bridge;

public class Cliente {
    public static void main(String[] args) {
        System.out.println("=== Testes no Windows ===");
        JanelaAbstrata janela = new JanelaDialogo(new JanelaWindows());
        janela.desenhar();
        
        System.out.println("\n=== Janela de Aviso no Windows ===");
        janela = new JanelaAviso(new JanelaWindows());
        janela.desenhar();
        
        System.out.println("\n=== Janela de Entrada de Dados no Windows ===");
        janela = new JanelaEntradaDados(new JanelaWindows());
        janela.desenhar();
        
        System.out.println("\n=== Testes no Linux ===");
        janela = new JanelaDialogo(new JanelaLinux());
        janela.desenhar();
        
        System.out.println("\n=== Janela de Aviso no Linux ===");
        janela = new JanelaAviso(new JanelaLinux());
        janela.desenhar();
        
        System.out.println("\n=== Janela de Entrada de Dados no Linux ===");
        janela = new JanelaEntradaDados(new JanelaLinux());
        janela.desenhar();
        
        System.out.println("\n=== Testes no Mac ===");
        janela = new JanelaDialogo(new JanelaMac());
        janela.desenhar();
        
        System.out.println("\n=== Janela de Aviso no Mac ===");
        janela = new JanelaAviso(new JanelaMac());
        janela.desenhar();
        
        System.out.println("\n=== Janela de Entrada de Dados no Mac ===");
        janela = new JanelaEntradaDados(new JanelaMac());
        janela.desenhar();
    }
}