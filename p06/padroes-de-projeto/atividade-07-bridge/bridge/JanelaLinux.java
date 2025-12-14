package bridge;

public class JanelaLinux implements JanelaImplementada {
    @Override
    public void desenharJanela(String titulo) {
        System.out.println(titulo + " - Janela Linux");
    }
    
    @Override
    public void desenharBotao(String titulo) {
        System.out.println(titulo + " - Botão Linux");
    }
    
    @Override
    public void desenharEditBox(String titulo) { // Novo método implementado
        System.out.println(titulo + " - EditBox Linux");
    }
}