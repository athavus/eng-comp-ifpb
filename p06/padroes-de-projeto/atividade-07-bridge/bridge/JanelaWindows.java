package bridge;

public class JanelaWindows implements JanelaImplementada {
    @Override
    public void desenharJanela(String titulo) {
        System.out.println(titulo + " - Janela Windows");
    }
    
    @Override
    public void desenharBotao(String titulo) {
        System.out.println(titulo + " - Botão Windows");
    }
    
    @Override
    public void desenharEditBox(String titulo) { // Novo método implementado
        System.out.println(titulo + " - EditBox Windows");
    }
}